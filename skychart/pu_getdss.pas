unit pu_getdss;

{$MODE Delphi}{$H+}

{
Copyright (C) 2005 Patrick Chevalley

http://www.ap-i.net
pch@ap-i.net

This program is free software; you can redistribute it and/or
modify it under the terms of the GNU General Public License
as published by the Free Software Foundation; either version 2
of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software
Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
}
{
 Interface to GetDSS to extract DSS images from Realsky CDrom.
}

interface

uses
  u_help, u_translation, UScaleDPI, gzio,
  dynlibs, u_constant, u_util, Math, LazUTF8, IpHtml,
  LCLIntf, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, LResources, downloaddialog, LazHelpHTML_fix;

// GetDss.dll interface
type
  SImageConfig = record
    pDir: PChar;
    pDrive: PChar;
    pImageFile: PChar;
    DataSource: integer;
    PromptForDisk: boolean;
    SubSample: integer;
    Ra: double;
    De: double;
    Width: double;
    Height: double;
    Sender: Thandle;
    pApplication: PChar;
    pPrompt1: PChar;
    pPrompt2: PChar;
  end;

  Plate_data = record
    nplate: integer;
    plate_name, gsc_plate_name: array[1..10] of PChar;
    dist_from_edge, cd_number, is_uk_survey: array[1..10] of integer;
    year_imaged, exposure: array[1..10] of double;
  end;
  PImageConfig = ^SImageConfig;
  PPlate_data = ^Plate_data;

  TImageExtract = function(img: PImageConfig): integer; cdecl;
  TGetPlateList = function(img: PImageConfig; pl: PPlate_data): integer; cdecl;
  TImageExtractFromPlate = function(img: PImageConfig;
    ReqPlateName: PChar): integer; cdecl;

type

  { Tf_getdss }

  Tf_getdss = class(TForm)
    DownloadDialog1: TDownloadDialog;
    Memo1: TIpHtmlPanel;
    ListBox1: TListBox;
    Label1: TLabel;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    procedure BitBtn2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
    dsslib: TLibHandle;
    Fenabled: boolean;
    ImageExtract: TImageExtract;
    GetPlateList: TGetPlateList;
    ImageExtractFromPlate: TImageExtractFromPlate;
  public
    { Public declarations }
    cfgdss: Tconf_dss;
    cmain: TConf_Main;
    function GetDss(ra, de, fov, ratio: double; imgx: integer): boolean;
    procedure SetLang;
  end;

var
  f_getdss: Tf_getdss;

  {$ifdef mswindows}
const
  dsslibname = 'libgetdss.dll';
  {$endif}
  {$ifdef linux}
const
  dsslibname = 'libpasgetdss.so.1';
  {$endif}
  {$ifdef freebsd}
const
  dsslibname = 'libgetdss.so';
  {$endif}
  {$ifdef darwin}
const
  dsslibname = 'libgetdss.dylib';
  {$endif}

{$ifdef unix}
{$DEFINE RETRY_MOUNT}
{$endif}

implementation

{$R *.lfm}

procedure Tf_getdss.SetLang;
begin
  Caption := rsListOfAvaila;
  BitBtn1.Caption := rsOK;
  BitBtn2.Caption := rsCancel;
  SetHelp(self, hlpCfgPict);
  DownloadDialog1.msgDownloadFile := rsDownloadFile;
  DownloadDialog1.msgCopyfrom := rsCopyFrom;
  DownloadDialog1.msgtofile := rsToFile;
  DownloadDialog1.msgDownloadBtn := rsDownload;
  DownloadDialog1.msgCancelBtn := rsCancel;
end;

procedure Tf_getdss.FormCreate(Sender: TObject);
begin
  ScaleDPI(Self);
  DownloadDialog1.ScaleDpi:=UScaleDPI.scale;
  SetLang;
  cfgdss := Tconf_dss.Create;
  if VerboseMsg then
    WriteTrace('Loadlibrary ' + dsslibname);
  dsslib := LoadLibrary(dsslibname);
  if dsslib <> 0 then
  begin
    ImageExtract := TImageExtract(GetProcedureAddress(dsslib, 'ImageExtract'));
    GetPlateList := TGetPlateList(GetProcedureAddress(dsslib, 'GetPlateList'));
    ImageExtractFromPlate := TImageExtractFromPlate(
      GetProcedureAddress(dsslib, 'ImageExtractFromPlate'));
    Fenabled := True;
    if VerboseMsg then
      WriteTrace('Library ok');
  end
  else
  begin
    Fenabled := False;
    writetrace(Format(rsNotFound, [dsslibname]));
  end;
end;

procedure Tf_getdss.BitBtn2Click(Sender: TObject);
begin
  if memo1.Visible then
    Close;
end;

procedure Tf_getdss.FormDestroy(Sender: TObject);
begin
  try
    Fenabled := False;
    ImageExtract := nil;
    GetPlateList := nil;
    ImageExtractFromPlate := nil;
    if dsslib <> 0 then
      UnloadLibrary(dsslib);
    cfgdss.Free;
  except
    writetrace('error destroy ' + Name);
  end;
end;

function Tf_getdss.GetDss(ra, de, fov, ratio: double; imgx: integer): boolean;
var
  i: SImageConfig;
  errtxt:TMemoryStream;
  pl: Plate_data;
  gzbuf: array[0..4095] of char;
  rc, datasource, n, l, imgy: integer;
  subsample, wi, he, npix, imgsize, fovx, fovy: double;
  ima, app, platename, buf, dd, mm, ss, gzfn: string;
  firstrec: boolean;
  gzf: pointer;
  fitsfile: file;
begin
  try
    memo1.Visible := False;
    ListBox1.Visible := True;
    BitBtn1.Visible := True;
    hide;
    application.ProcessMessages;
    Result := False;
    if cfgdss.OnlineDSS then
    begin // Online DSS
      if cmain.HttpProxy then
      begin
        DownloadDialog1.SocksProxy := '';
        DownloadDialog1.SocksType := '';
        DownloadDialog1.HttpProxy := cmain.ProxyHost;
        DownloadDialog1.HttpProxyPort := cmain.ProxyPort;
        DownloadDialog1.HttpProxyUser := cmain.ProxyUser;
        DownloadDialog1.HttpProxyPass := cmain.ProxyPass;
      end
      else if cmain.SocksProxy then
      begin
        DownloadDialog1.HttpProxy := '';
        DownloadDialog1.SocksType := cmain.SocksType;
        DownloadDialog1.SocksProxy := cmain.ProxyHost;
        DownloadDialog1.HttpProxyPort := cmain.ProxyPort;
        DownloadDialog1.HttpProxyUser := cmain.ProxyUser;
        DownloadDialog1.HttpProxyPass := cmain.ProxyPass;
      end
      else
      begin
        DownloadDialog1.SocksProxy := '';
        DownloadDialog1.SocksType := '';
        DownloadDialog1.HttpProxy := '';
        DownloadDialog1.HttpProxyPort := '';
        DownloadDialog1.HttpProxyUser := '';
        DownloadDialog1.HttpProxyPass := '';
      end;
      DownloadDialog1.FtpUserName := 'anonymous';
      DownloadDialog1.FtpPassword := cmain.AnonPass;
      DownloadDialog1.FtpFwPassive := cmain.FtpPassive;
      DownloadDialog1.ConfirmDownload := cmain.ConfirmDownload;
      buf := cfgdss.DSSurl[cfgdss.OnlineDSSid, 1];
      wi := fov * rad2deg * 60;
      he := wi / ratio;
      fovx := rad2deg * fov;
      fovy := fovx / ratio;
      imgy := round(imgx / ratio);
      buf := StringReplace(buf, '$XSZ', formatfloat(f1s, wi), [rfReplaceAll]);
      buf := StringReplace(buf, '$YSZ', formatfloat(f1s, he), [rfReplaceAll]);
      ArToStr2(rad2deg * ra / 15, dd, mm, ss);
      buf := StringReplace(buf, '$RAH', dd, [rfReplaceAll]);
      buf := StringReplace(buf, '$RAM', mm, [rfReplaceAll]);
      buf := StringReplace(buf, '$RAS', ss, [rfReplaceAll]);
      DeToStr2(rad2deg * de, dd, mm, ss);
      buf := StringReplace(buf, '$DED', dd, [rfReplaceAll]);
      buf := StringReplace(buf, '$DEM', mm, [rfReplaceAll]);
      buf := StringReplace(buf, '$DES', ss, [rfReplaceAll]);
      buf := StringReplace(buf, '$FOVF', formatfloat(f5, rad2deg * fov), [rfReplaceAll]);
      buf := StringReplace(buf, '$FOVX', formatfloat(f5, fovx), [rfReplaceAll]);
      buf := StringReplace(buf, '$FOVY', formatfloat(f5, fovy), [rfReplaceAll]);
      buf := StringReplace(buf, '$RAF', formatfloat(f5, rad2deg * ra), [rfReplaceAll]);
      buf := StringReplace(buf, '$DEF', formatfloat(f5, rad2deg * de), [rfReplaceAll]);
      buf := StringReplace(buf, '$PIXX', IntToStr(imgx), [rfReplaceAll]);
      buf := StringReplace(buf, '$PIXY', IntToStr(imgy), [rfReplaceAll]);
      DownloadDialog1.URL := buf;
      gzfn := ExpandFileName(cfgdss.dssfile + '.gz');
      DownloadDialog1.SaveToFile := gzfn;
      if DownloadDialog1.Execute then
      begin
        try
     {$ifdef mswindows}
          gzfn := UTF8ToWinCP(gzfn);
     {$endif}
          gzf := gzopen(PChar(gzfn), PChar('rb'));
          Filemode := 2;
          assignfile(fitsfile, ExpandFileName(cfgdss.dssfile));
          rewrite(fitsfile, 1);
          firstrec := True;
          repeat
            l := gzread(gzf, @gzbuf, length(gzbuf));
            if l>0 then begin
              blockwrite(fitsfile, gzbuf, l, n);
              if firstrec then
              begin
                firstrec := False;
                if copy(gzbuf, 1, 6) = 'SIMPLE' then
                  Result := True;
              end;
            end
            else begin
              break;
            end;
          until gzeof(gzf);
        finally
          gzclose(gzf);
          CloseFile(fitsfile);
        end;
      end
      else
      begin
        Filemode := 2;
        try
          assignfile(fitsfile, ExpandFileName(cfgdss.dssfile));
          rewrite(fitsfile, 1);
          buf := html_h + DownloadDialog1.ResponseText;
          if pos('Timeout', DownloadDialog1.ResponseText) > 0 then
            buf := buf + html_p + rsRequestTimeo + htms_p
          else
            buf := buf + html_p + rsPleaseCheckY + htms_p;
          buf := buf + htms_h;
          gzbuf := buf;
          blockwrite(fitsfile, gzbuf, length(buf), n);
        finally
          CloseFile(fitsfile);
        end;
      end;
      if (DownloadDialog1.ResponseText <> '') and (not Result) then
      begin
        Caption := rsError;
        Label1.Caption := DownloadDialog1.ResponseText;
        RenameFile(ExpandFileName(cfgdss.dssfile), ExpandFileName(cfgdss.dssfile) + '.txt');
        Memo1.Visible:=true;
        ListBox1.Visible := False;
        BitBtn1.Visible := False;
        errtxt:=TMemoryStream.Create;
        errtxt.LoadFromFile((ExpandFileName(cfgdss.dssfile) + '.txt'));
        Memo1.SetHtmlFromStream(errtxt);
        errtxt.Free;
        Show;
      end;

    end
    else if Fenabled then
    begin    // RealSky cdrom
      datasource := 0;
      if cfgdss.dss102 then
        datasource := 3
      else if cfgdss.dssnorth and cfgdss.dsssouth then
        datasource := 4
      else if cfgdss.dssnorth then
        datasource := 1
      else if cfgdss.dsssouth then
        datasource := 2;
      if datasource = 0 then
      begin
        ShowMessage(rsPleaseConfig);
        exit;
      end;
      ima := ExpandFileName(cfgdss.dssfile);
      i.pDir := PChar(slash(expandfilename(cfgdss.dssdir)));
      i.pDrive := PChar(slash(cfgdss.dssdrive));
      i.pImageFile := PChar(ima);
      i.DataSource := datasource;
      i.PromptForDisk := True;
      wi := fov * rad2deg * 60;
      he := wi / ratio;
      if min(wi, he) > 420 then
      begin
        ShowMessage(Format(rsFieldTooWidt, ['7' + ldeg]));
        exit;
      end;
      wi := min(wi, 400);
      he := min(he, 400);
      if cfgdss.dsssampling then
      begin
        npix := max(wi, he) * 60 / 1.7;
        n := trunc(npix / cfgdss.dssmaxsize);
        case n of
          0: subsample := 1;
          1: subsample := 2;
          2..3: subsample := 4;
          4: subsample := 5;
          5..9: subsample := 10;
          10..19: subsample := 20;
          20..24: subsample := 25;
          else
            subsample := 50;
        end;
      end
      else
      begin
        subsample := 1;
        imgsize := (wi * 60 / 1.7 / subsample) * (he * 60 / 1.7 / subsample) * 2 / 1024 / 1024;
        if imgsize > 8 then
        begin
          if MessageDlg(Format(rsEstimatedFil,
            [floattostrf(imgsize, ffFixed, 6, 0), crlf]),
            mtWarning, [mbOK, mbCancel], 0) <> mrOk then
            exit;
        end;
      end;
      i.SubSample := round(subsample);
      i.Ra := ra;
      i.De := de;
      i.Width := wi;
      i.Height := he;
      i.Sender := integer(handle);
      app := application.title;
      i.pApplication := PChar(app);
      i.pPrompt1 := PChar(rsPleaseMountR);
      i.pPrompt2 := PChar(rsInDrive);
  {$ifdef unix}
      exec('export LC_ALL=C');
  {$endif}
      chdir(TempDir);
      if cfgdss.dssplateprompt then
      begin
        rc := GetPlateList(addr(i), addr(pl));
        if (rc <> 0) then
          exit;
        listbox1.Clear;
        Caption := rsListOfAvaila;
        label1.Caption := rsPlateIdDateE;
        if pl.nplate > 10 then
          pl.nplate := 10;
        for n := 1 to pl.nplate do
        begin
          buf := copy(pl.plate_name[n] + '   ', 1, 5) + blank +
            copy(pl.gsc_plate_name[n] + '   ', 1, 5) + '  ' +
            Formatfloat('0000', pl.year_imaged[n]) + '   ' +
            Formatfloat('000', pl.exposure[n]) + '   ' +
            Formatfloat('"+"00000;"-"00000', pl.dist_from_edge[n]) + '  ' +
            Formatfloat('000', pl.cd_number[n]) + '   ';
          if pl.is_uk_survey[n] = 0 then
            buf := buf + 'PAL'
          else
            buf := BUF + 'UK';
          listbox1.items.Add(buf);
        end;
        listbox1.ItemIndex := 0;
        showmodal;
        if ModalResult <> mrOk then
          exit;
        platename := pl.plate_name[listbox1.ItemIndex + 1];
    {$ifdef RETRY_MOUNT}
        repeat
    {$endif}
          rc := ImageExtractFromPlate(addr(i), PChar(platename));
    {$ifdef RETRY_MOUNT}
          if rc > 0 then
          begin
            if (MessageDlg(i.pPrompt1 + blank + IntToStr(rc) + crlf + i.pPrompt2 +
              blank + cfgdss.dssdrive, mtConfirmation, [mbOK, mbCancel], 0) <> mrOk) then
              rc := -999;
          end;
        until rc <= 0;
    {$endif}
      end
      else
      begin
   {$ifdef RETRY_MOUNT}
        repeat
    {$endif}
          rc := ImageExtract(addr(i));
    {$ifdef RETRY_MOUNT}
          if rc > 0 then
          begin
            if (MessageDlg(i.pPrompt1 + blank + IntToStr(rc) + crlf + i.pPrompt2 +
              blank + cfgdss.dssdrive, mtConfirmation, [mbOK, mbCancel], 0) <> mrOk) then
              rc := -999;
          end;
        until rc <= 0;
    {$endif}
      end;
      Result := (rc = 0);
    end;
  finally
    chdir(appdir);
  end;
end;

end.
