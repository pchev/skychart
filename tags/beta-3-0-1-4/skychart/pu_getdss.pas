unit pu_getdss;

{$MODE Delphi}{$H+}

{
Copyright (C) 2005 Patrick Chevalley

http://www.astrosurf.com/astropc
pch@freesurf.ch

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
Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
}
{
 Interface to GetDSS to extract DSS images from Realsky CDrom.
}

interface

uses u_translation,
  dynlibs, u_constant, u_util, Math,
  LCLIntf, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, LResources, downloaddialog, IpHtml;

// GetDss.dll interface
  type
  SImageConfig = record
     pDir : Pchar;
     pDrive : Pchar;
     pImageFile : Pchar;
     DataSource : integer;
     PromptForDisk : boolean;
     SubSample : integer;
     Ra : double;
     De : double;
     Width : double;
     Height : double;
     Sender : Thandle;
     pApplication :Pchar;
     pPrompt1 : Pchar;
     pPrompt2 : Pchar;
  end;
  Plate_data = packed record
   nplate : integer;
   plate_name, gsc_plate_name : array[1..10]of Pchar;
   dist_from_edge, cd_number, is_uk_survey : array[1..10]of integer;
   year_imaged, exposure : array[1..10]of double;
  end;
  PImageConfig = ^SImageConfig;
  PPlate_data = ^Plate_data;

  TImageExtract=function( img : PImageConfig): Integer; cdecl;
  TGetPlateList=function( img : PImageConfig; pl : PPlate_data): Integer; cdecl;
  TImageExtractFromPlate=function( img : PImageConfig; ReqPlateName : Pchar): Integer; cdecl;

type
  TSimpleIpHtml = class(TIpHtml)
  public
    property OnGetImageX;
  end;

type

  { Tf_getdss }

  Tf_getdss = class(TForm)
    DownloadDialog1: TDownloadDialog;
    IpHtmlPanel1: TIpHtmlPanel;
    ListBox1: TListBox;
    Label1: TLabel;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
    dsslib: Dword;
    Fenabled: boolean;
    ImageExtract: TImageExtract;
    GetPlateList: TGetPlateList;
    ImageExtractFromPlate: TImageExtractFromPlate;
    procedure HTMLGetImageX(Sender: TIpHtmlNode; const URL: string; var Picture: TPicture);
  public
    { Public declarations }
    cfgdss: Tconf_dss;
    cmain: TConf_Main;
    function GetDss(ra,de,fov,ratio:double; imgx:integer):boolean;
    procedure SetLang;
  end;

  Var f_getdss: Tf_getdss;

  {$ifdef win32}
  Const dsslibname = 'libgetdss.dll';
  {$endif}
  {$ifdef linux}
  Const dsslibname = 'libgetdss.so';
  {$endif}
  {$ifdef darwin}
  Const dsslibname = 'libgetdss.dylib';
  {$endif}

{$ifdef unix}
{$DEFINE RETRY_MOUNT}
{$endif}

implementation

procedure Tf_getdss.SetLang;
begin
Caption:=rsListOfAvaila;
BitBtn1.caption:=rsOK;
BitBtn2.caption:=rsCancel;
end;

procedure Tf_getdss.FormCreate(Sender: TObject);
begin
SetLang;
cfgdss:=Tconf_dss.Create;
{$ifdef win32}
 ScaleForm(self,Screen.PixelsPerInch/96);
{$endif}
  dsslib := LoadLibrary(dsslibname);
  if dsslib<>0 then begin
    ImageExtract:= TImageExtract(GetProcAddress(dsslib, 'ImageExtract'));
    GetPlateList:= TGetPlateList(GetProcAddress(dsslib, 'GetPlateList'));
    ImageExtractFromPlate:= TImageExtractFromPlate(GetProcAddress(dsslib, 'ImageExtractFromPlate'));
    Fenabled:=true;
  end else begin
    Fenabled:=false;
    writetrace(Format(rsNotFound, [dsslibname]));
  end;
end;

procedure Tf_getdss.FormDestroy(Sender: TObject);
begin
try
Fenabled:=false;
ImageExtract:=nil;
GetPlateList:=nil;
ImageExtractFromPlate:=nil;
if dsslib<>0 then Freelibrary(dsslib);
cfgdss.Free;
except
writetrace('error destroy '+name);
end;
end;

function Tf_getdss.GetDss(ra,de,fov,ratio:double; imgx:integer):boolean;
var i : SImageConfig;
    pl: Plate_data;
    rc,datasource,subsample,n,l,imgy : integer;
    width,height,npix,imgsize,fovx,fovy : double;
    ima,app,platename,buf,dd,mm,ss : string;
    firstrec: boolean;
    gzf:pointer;
    fitsfile:file;
    gzbuf : array[0..4095]of char;
    NewHTML: TSimpleIpHtml;
    s: TMemoryStream;
begin
try
result:=false;
if cfgdss.OnlineDSS and zlibok then begin // Online DSS
  if cmain.HttpProxy then begin
    DownloadDialog1.HttpProxy:=cmain.ProxyHost;
    DownloadDialog1.HttpProxyPort:=cmain.ProxyPort;
    DownloadDialog1.HttpProxyUser:=cmain.ProxyUser;
    DownloadDialog1.HttpProxyPass:=cmain.ProxyPass;
  end else begin
    DownloadDialog1.HttpProxy:='';
    DownloadDialog1.HttpProxyPort:='';
    DownloadDialog1.HttpProxyUser:='';
    DownloadDialog1.HttpProxyPass:='';
  end;
  DownloadDialog1.FtpUserName:='anonymous';
  DownloadDialog1.FtpPassword:=cmain.AnonPass;
  DownloadDialog1.FtpFwPassive:=cmain.FtpPassive;
  buf:=cfgdss.DSSurl[cfgdss.OnlineDSSid,1];
  width:=fov*rad2deg*60;
  height:=width/ratio;
  fovx:=rad2deg*fov;
  fovy:=fovx/ratio;
  imgy:=round(imgx/ratio);
  buf:=StringReplace(buf,'$XSZ',formatfloat(f1s,width),[rfReplaceAll]);
  buf:=StringReplace(buf,'$YSZ',formatfloat(f1s,height),[rfReplaceAll]);
  ArToStr2(rad2deg*ra/15,dd,mm,ss);
  buf:=StringReplace(buf,'$RAH',dd,[rfReplaceAll]);
  buf:=StringReplace(buf,'$RAM',mm,[rfReplaceAll]);
  buf:=StringReplace(buf,'$RAS',ss,[rfReplaceAll]);
  DeToStr2(rad2deg*de,dd,mm,ss);
  buf:=StringReplace(buf,'$DED',dd,[rfReplaceAll]);
  buf:=StringReplace(buf,'$DEM',mm,[rfReplaceAll]);
  buf:=StringReplace(buf,'$DES',ss,[rfReplaceAll]);
  buf:=StringReplace(buf,'$FOVF',formatfloat(f5,rad2deg*fov),[rfReplaceAll]);
  buf:=StringReplace(buf,'$FOVX',formatfloat(f5,fovx),[rfReplaceAll]);
  buf:=StringReplace(buf,'$FOVY',formatfloat(f5,fovy),[rfReplaceAll]);
  buf:=StringReplace(buf,'$RAF',formatfloat(f5,rad2deg*ra),[rfReplaceAll]);
  buf:=StringReplace(buf,'$DEF',formatfloat(f5,rad2deg*de),[rfReplaceAll]);
  buf:=StringReplace(buf,'$PIXX',inttostr(imgx),[rfReplaceAll]);
  buf:=StringReplace(buf,'$PIXY',inttostr(imgy),[rfReplaceAll]);
  DownloadDialog1.URL:=buf;
  DownloadDialog1.SaveToFile:=ExpandFileName(cfgdss.dssfile+'.gz');
  if DownloadDialog1.Execute then begin
     gzf:=gzopen(pchar(DownloadDialog1.SaveToFile),pchar('rb'));
     Filemode:=2;
     assignfile(fitsfile,ExpandFileName(cfgdss.dssfile));
     rewrite(fitsfile,1);
     firstrec:=true;
     repeat
       l:=gzread(gzf,@gzbuf,length(gzbuf));
       blockwrite(fitsfile,gzbuf,l,n);
       if firstrec then begin
          firstrec:=false;
          if copy(gzbuf,1,6)='SIMPLE' then result:=true;
       end;
     until gzeof(gzf);
     gzclose(gzf);
     CloseFile(fitsfile);
  end
  else begin
     Filemode:=2;
     assignfile(fitsfile,ExpandFileName(cfgdss.dssfile));
     rewrite(fitsfile,1);
     buf:=html_h+DownloadDialog1.ResponseText;
     if pos('Timeout',DownloadDialog1.ResponseText)>0 then
        buf:=buf+html_p+rsRequestTimeo+htms_p
     else
        buf:=buf+html_p+rsPleaseCheckY+htms_p;
     buf:=buf+htms_h;
     gzbuf:=buf;
     blockwrite(fitsfile,gzbuf,length(buf),n);
     CloseFile(fitsfile);
  end;
  if (DownloadDialog1.ResponseText<>'')and(not result) then begin
     caption:=rsError;
     Label1.Caption:=DownloadDialog1.ResponseText;
     s:=TMemoryStream.Create;
     s.LoadFromFile(ExpandFileName(cfgdss.dssfile));
     NewHTML:=TSimpleIpHtml.Create; // Beware: Will be freed automatically by IpHtmlPanel1
     NewHTML.OnGetImageX:=HTMLGetImageX;
     NewHTML.LoadFromStream(s);
     s.free;
     IpHtmlPanel1.SetHtml(NewHTML);
     IpHtmlPanel1.visible:=true;
     ListBox1.Visible:=false;
     BitBtn1.Visible:=false;
     showmodal;
     IpHtmlPanel1.visible:=false;
     ListBox1.Visible:=true;
     BitBtn1.Visible:=true;
  end;

end else if Fenabled then begin    // RealSky cdrom
  datasource:=0;
  if cfgdss.dss102 then datasource:=3
  else if cfgdss.dssnorth and cfgdss.dsssouth then datasource:=4
  else if cfgdss.dssnorth then datasource:=1
  else if cfgdss.dsssouth then datasource:=2;
  if datasource=0 then begin ShowMessage(rsPleaseConfig); exit; end;
  ima:=ExpandFileName(cfgdss.dssfile);
  i.pDir:=Pchar(slash(expandfilename(cfgdss.dssdir)));
  i.pDrive:=Pchar(slash(cfgdss.dssdrive));
  i.pImageFile:=Pchar(ima);
  i.DataSource:=datasource;
  i.PromptForDisk:=true;
  width:=fov*rad2deg*60;
  height:=width/ratio;
  if min(width, height) > 420 then begin ShowMessage(Format(rsFieldTooWidt, [
    '7'+ldeg])); exit; end;
  width:=min(width,400);
  height:=min(height,400);
  if cfgdss.dsssampling then begin
    npix:=max(width,height)*60/1.7;
    n:=trunc(npix/cfgdss.dssmaxsize);
    case n of
         0    : subsample:=1;
         1    : subsample:=2;
         2..3 : subsample:=4;
         4    : subsample:=5;
         5..9 : subsample:=10;
        10..19: subsample:=20;
        20..24: subsample:=25;
           else subsample:=50;
    end;
  end else begin
      subsample:=1;
      imgsize:=(width*60/1.7/subsample)*(height*60/1.7/subsample)*2/1024/1024;
      if imgsize>8 then begin
         if MessageDlg(Format(rsEstimatedFil, [floattostrf(imgsize, ffFixed, 6,
           0), crlf]),
            mtWarning,[mbOk, mbCancel],0)<>mrOK then exit;
      end;
  end;
  i.SubSample:=subsample;
  i.Ra:=ra;
  i.De:=de;
  i.Width:=width;
  i.Height:=height;
  i.Sender:=integer(handle);
  app:=application.title;
  i.pApplication:=Pchar(app);
  i.pPrompt1:=Pchar(rsPleaseMountR);
  i.pPrompt2:=Pchar(rsInDrive);
  {$ifdef unix}
  exec('export LC_ALL=C');
  chdir(TempDir);
  {$endif}
  if cfgdss.dssplateprompt then begin
    rc:=GetPlateList(addr(i),addr(pl));
    if (rc<>0) then exit;
      listbox1.clear;
      caption:=rsListOfAvaila;
      label1.caption:=rsPlateIdDateE;
      if pl.nplate>10 then pl.nplate:=10;
      for n:=1 to pl.nplate do begin
        buf:=copy(pl.plate_name[n]+'   ',1,5)+blank+
             copy(pl.gsc_plate_name[n]+'   ',1,5)+'  '+
             Formatfloat('0000',pl.year_imaged[n])+'   '+
             Formatfloat('000',pl.exposure[n])+'   '+
             Formatfloat('"+"00000;"-"00000',pl.dist_from_edge[n])+'  '+
             Formatfloat('000',pl.cd_number[n])+'   ';
        if pl.is_uk_survey[n]=0 then buf:=buf+'PAL'
                                else buf:=BUF+'UK';
        listbox1.items.Add(buf);
      end;
      listbox1.itemindex:=0;
      showmodal;
      if ModalResult<>mrOK then exit;
      platename:=pl.plate_name[listbox1.itemindex+1];
    {$ifdef RETRY_MOUNT}
    repeat
    {$endif}
    rc:=ImageExtractFromPlate(addr(i),Pchar(platename));
    {$ifdef RETRY_MOUNT}
    if rc>0 then begin
      if (MessageDlg(i.pPrompt1+blank+inttostr(rc)+crlf+i.pPrompt2+blank+cfgdss.dssdrive,mtConfirmation,[mbOK, mbCancel],0)<>mrOK) then
         rc:=-999;
    end;
    until rc<=0;
    {$endif}
  end
  else begin
   {$ifdef RETRY_MOUNT}
    repeat
    {$endif}
     rc:=ImageExtract(addr(i));
    {$ifdef RETRY_MOUNT}
    if rc>0 then begin
      if (MessageDlg(i.pPrompt1+blank+inttostr(rc)+crlf+i.pPrompt2+blank+cfgdss.dssdrive,mtConfirmation,[mbOK, mbCancel],0)<>mrOK) then
         rc:=-999;
    end;
    until rc<=0;
    {$endif}
  end;
  result:=(rc=0);
end;
finally
  chdir(appdir);
end;
end;

procedure Tf_getdss.HTMLGetImageX(Sender: TIpHtmlNode; const URL: string; var Picture: TPicture);
var
  PicCreated: boolean;
begin
  try
    if FileExists(URL) then begin
      PicCreated := False;
      if Picture=nil then begin
        Picture:=TPicture.Create;
        PicCreated := True;
      end;
      Picture.LoadFromFile(URL);
    end;
  except
    if PicCreated then
      Picture.Free;
    Picture := nil;
  end;
end;

initialization
  {$i pu_getdss.lrs}

end.
