unit pu_updcatalog;
{
Copyright (C) 2024 Patrick Chevalley

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

{$mode ObjFPC}{$H+}

interface

uses u_constant, u_util, u_translation, UScaleDPI, downloaddialog, cu_httpdownload, u_unzip, cu_catalog, FileUtil,
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, Grids, ComCtrls, StdCtrls;

type

  TCatInfo = class(TObject)
    installed, prereqok, newversion: boolean;
    catnum,minlevel,maxlevel: integer;
    cattype,cdcminversion,version,catname,desc,size,url,prereq,path: string;
    installedversion: string;
    grid: TStringGrid;
    constructor Create(data:Tstringlist);
    procedure SearchInstalled(basedir:string);
    procedure SearchPrereqInGrid(g:TStringGrid);
    function ListDependInGrid(g:TStringGrid): string;
    function ListSamePathInGrid(g:TStringGrid): string;
  end;

  { Tf_updcatalog }

  Tf_updcatalog = class(TForm)
    ButtonClose: TButton;
    ButtonAbort: TButton;
    GridVar: TStringGrid;
    GridDouble: TStringGrid;
    GridDSO: TStringGrid;
    LabelAction: TLabel;
    LabelProgress: TLabel;
    PageControl1: TPageControl;
    Panel1: TPanel;
    Panel2: TPanel;
    GridStar: TStringGrid;
    PanelDownload: TPanel;
    TabSheetStar: TTabSheet;
    TabSheetVar: TTabSheet;
    TabSheetDouble: TTabSheet;
    TabSheetDSO: TTabSheet;
    EndInstallTimer: TTimer;
    procedure ButtonAbortClick(Sender: TObject);
    procedure ButtonCloseClick(Sender: TObject);
    procedure EndInstallTimerTimer(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure GridButtonClick(Sender: TObject; aCol, aRow: Integer);
  private
    Fcatalog: Tcatalog;
    Fcmain: Tconf_main;
    FSaveConfig: TNotifyEvent;
    InstallInfo: TCatInfo;
    httpdownload: THTTPBigDownload;
    FRunning: boolean;
    procedure ClearGrid(g:TStringGrid);
    procedure LoadCatalogList;
    procedure UpdateList;
    procedure ShowStatus(grid: TStringGrid);
    procedure InstallDlg(info: TCatInfo);
    procedure UninstallDlg(info: TCatInfo);
    procedure Install(info: TCatInfo);
    procedure Uninstall(info: TCatInfo);
    procedure ShowProgress;
    procedure DownloadComplete;
    procedure DownloadError;
    procedure UnzipProgress(Sender : TObject);
  public
    procedure SetLang;
    property cmain: Tconf_main read Fcmain write Fcmain;
    property catalog: Tcatalog read Fcatalog write Fcatalog;
    property onSaveConfig: TNotifyEvent read FSaveConfig write FSaveConfig;
  end;

var
  f_updcatalog: Tf_updcatalog;

implementation

const colaction=0; colinstall=1; colname=2; coldesc=3; colsize=4;

{$R *.lfm}

constructor TCatInfo.Create(data:Tstringlist);
begin
  inherited Create;
// star;4.3;20240101;GAIA DR3 part 2;Complement stars to magnitude 15;1.1 GB;
// https://vega.ap-i.net/pub/GaiaDR3/GaiaDR3_2.zip;GAIA DR3 part 1;gaia/gaia2;0;5
  cattype:=data[0];
  cdcminversion:=data[1];
  version:=data[2];
  catname:=data[3];
  desc:=data[4];
  size:=data[5];
  url:=data[6];
  prereq:=data[7];
  path:=StringReplace(data[8],'/',DirectorySeparator,[rfReplaceAll]);
  catnum:=StrToIntDef(data[9],-1);
  minlevel:=StrToIntDef(data[10],0);
  maxlevel:=StrToIntDef(data[11],10)
end;

procedure TCatInfo.SearchInstalled(basedir:string);
var f: TextFile;
    vf: string;
begin
  vf:=slash(basedir)+slash(path)+catname+'_version.txt';
  installed:=FileExists(vf);
  if installed then begin
    AssignFile(f,vf);
    Reset(f);
    readln(f,installedversion);
    CloseFile(f);
    installedversion:=trim(installedversion);
    newversion:=(installedversion<>version);
  end
  else begin
    newversion:=false;
    installedversion:='';
  end;
end;

procedure TCatInfo.SearchPrereqInGrid(g:TStringGrid);
var i:integer;
    info:TCatInfo;
begin
  if prereq='' then
    prereqok:=true
  else
  begin
    for i:=1 to g.RowCount-1 do begin
      info:=TCatInfo(g.Objects[colinstall,i]);
      if info.catname=prereq then begin
        if info.installed then begin
          info.SearchPrereqInGrid(g);
          prereqok:=info.prereqok;
        end
        else begin
          prereqok:=false;
        end;
      end;
    end;
  end;
end;

function TCatInfo.ListDependInGrid(g:TStringGrid): string;
var i:integer;
    info:TCatInfo;
begin
  result:='';
  for i:=1 to g.RowCount-1 do begin
    info:=TCatInfo(g.Objects[colinstall,i]);
    if catname=info.prereq then begin
      result:=result+';'+info.catname;
      result:=result+info.ListDependInGrid(g);
    end;
  end;
end;

function TCatInfo.ListSamePathInGrid(g:TStringGrid): string;
var i:integer;
    info:TCatInfo;
begin
  result:='';
  for i:=1 to g.RowCount-1 do begin
    info:=TCatInfo(g.Objects[colinstall,i]);
    if (catname<>info.catname)and(path=info.path) then begin
      result:=result+';'+info.catname;
    end;
  end;
end;

{ Tf_updcatalog }

procedure Tf_updcatalog.SetLang;
begin
  Caption:=rsInstallObjec;
  panel1.Caption:=rsSelectTheCat;
  TabSheetStar.Caption:=rsStars;
  TabSheetVar.Caption:=rsVariableStar2;
  TabSheetDouble.Caption:=rsDoubleStar;
  TabSheetDSO.Caption:=rsNebulae;
  GridStar.Columns[1].Title.Caption:=rsStatus;
  GridStar.Columns[2].Title.Caption:=rsCatalog;
  GridStar.Columns[3].Title.Caption:=rsDescription;
  GridStar.Columns[4].Title.Caption:=rsSize;
  GridVar.Columns[1].Title.Caption:=rsStatus;
  GridVar.Columns[2].Title.Caption:=rsCatalog;
  GridVar.Columns[3].Title.Caption:=rsDescription;
  GridVar.Columns[4].Title.Caption:=rsSize;
  GridDouble.Columns[1].Title.Caption:=rsStatus;
  GridDouble.Columns[2].Title.Caption:=rsCatalog;
  GridDouble.Columns[3].Title.Caption:=rsDescription;
  GridDouble.Columns[4].Title.Caption:=rsSize;
  GridDSO.Columns[1].Title.Caption:=rsStatus;
  GridDSO.Columns[2].Title.Caption:=rsCatalog;
  GridDSO.Columns[3].Title.Caption:=rsDescription;
  GridDSO.Columns[4].Title.Caption:=rsSize;
  ButtonAbort.Caption:=rsAbort;
  ButtonClose.Caption:=rsClose;

end;

procedure Tf_updcatalog.FormCreate(Sender: TObject);
begin
  ScaleDPI(Self);
  SetLang;
end;

procedure Tf_updcatalog.FormShow(Sender: TObject);
begin
  FRunning:=false;
  PanelDownload.Visible:=false;
  LoadCatalogList;
end;

procedure Tf_updcatalog.FormDestroy(Sender: TObject);
begin
  ClearGrid(GridStar);
  ClearGrid(GridVar);
  ClearGrid(GridDouble);
  ClearGrid(GridDSO);
end;

procedure Tf_updcatalog.ButtonCloseClick(Sender: TObject);
begin
  Close;
end;

procedure Tf_updcatalog.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CanClose := not FRunning;
end;

procedure Tf_updcatalog.ClearGrid(g:TStringGrid);
var i: integer;
begin
  for i:=1 to g.RowCount-1 do begin
    if g.Objects[colinstall,i]<>nil then g.Objects[colinstall,i].Free;
    g.Objects[colinstall,i]:=nil;
  end;
  g.RowCount:=1;
end;

procedure Tf_updcatalog.LoadCatalogList;
var f: textfile;
    fn,buf: string;
    info: TCatInfo;
    row: Tstringlist;
    grid: TStringGrid;
begin
  UpdateList;
  ClearGrid(GridStar);
  ClearGrid(GridVar);
  ClearGrid(GridDouble);
  ClearGrid(GridDSO);
  row := Tstringlist.Create;
  fn := slash(PrivateCatalogDir)+'catalog_list.txt';
  AssignFile(f,fn);
  Reset(f);
  repeat
    ReadLn(f,buf);
    if copy(buf,1,1)='#' then continue;
    Splitrec2(buf,';',row);
    if row.Count<>12 then continue;
    if row[1] > cdcver then continue; // skip catalog not supported by this version of the program
    // type of object
    if row[0]='star' then grid:=GridStar
    else if row[0]='double star' then grid:=GridDouble
    else if row[0]='variable star' then grid:=GridVar
    else if row[0]='dso' then grid:=GridDSO
    else continue;
    info:=TCatInfo.Create(row);
    info.SearchInstalled(PrivateCatalogDir);
    info.grid:=grid;
    grid.RowCount:=grid.RowCount+1;
    grid.Objects[colinstall,grid.RowCount-1]:=info;
    grid.Cells[colaction,grid.RowCount-1]:=Ellipsis;
    grid.Cells[colname,grid.RowCount-1]:=info.catname;
    grid.Cells[coldesc,grid.RowCount-1]:=info.desc;
    grid.Cells[colsize,grid.RowCount-1]:=info.size;
  until eof(f);
  row.Free;
  ShowStatus(GridStar);
  ShowStatus(GridVar);
  ShowStatus(GridDouble);
  ShowStatus(GridDSO);
end;

procedure Tf_updcatalog.UpdateList;
var
  dl: TDownloadDialog;
  fn: string;
  ft: TDateTime;
  doDownload: boolean;
begin
  fn := slash(PrivateCatalogDir)+'catalog_list.txt';
  doDownload:=true;
  if FileExists(fn) then begin
    if FileAge(fn,ft) then begin
      doDownload:=(ft<(now-1));
    end;
  end;
  if doDownload then begin
    dl := TDownloadDialog.Create(self);
    dl.ScaleDpi:=UScaleDPI.scale;
    try
      if Fcmain.HttpProxy then
      begin
        dl.SocksProxy := '';
        dl.SocksType := '';
        dl.HttpProxy := Fcmain.ProxyHost;
        dl.HttpProxyPort := Fcmain.ProxyPort;
        dl.HttpProxyUser := Fcmain.ProxyUser;
        dl.HttpProxyPass := Fcmain.ProxyPass;
      end
      else if Fcmain.SocksProxy then
      begin
        dl.HttpProxy := '';
        dl.SocksType := Fcmain.SocksType;
        dl.SocksProxy := Fcmain.ProxyHost;
        dl.HttpProxyPort := Fcmain.ProxyPort;
        dl.HttpProxyUser := Fcmain.ProxyUser;
        dl.HttpProxyPass := Fcmain.ProxyPass;
      end
      else
      begin
        dl.SocksProxy := '';
        dl.SocksType := '';
        dl.HttpProxy := '';
        dl.HttpProxyPort := '';
        dl.HttpProxyUser := '';
        dl.HttpProxyPass := '';
      end;
      dl.ConfirmDownload := False;
      dl.QuickCancel := true;
      dl.URL := URL_CATALOG_LIST;
      dl.SaveToFile := fn;
      dl.Execute;
    finally
      dl.Free;
    end;
  end;
end;

procedure Tf_updcatalog.ShowStatus(grid: TStringGrid);
var i: integer;
    info: TCatInfo;
    txt: string;
begin
  for i:=1 to grid.RowCount-1 do begin
    info:=TCatInfo(grid.Objects[colinstall,i]);
    info.SearchPrereqInGrid(grid);
    if info.installed then begin
      if info.newversion then
        txt:=rsNewVersionAv
      else
        txt:=rsInstalled;
    end
    else begin
      if info.prereqok then
        txt:=rsInstall
      else
        txt:=rsMissingPrere;
    end;
    grid.Cells[colinstall,i]:=txt;
  end;
end;

procedure Tf_updcatalog.GridButtonClick(Sender: TObject; aCol, aRow: Integer);
var info: TCatInfo;
begin
  FRunning:=True;
  ButtonClose.Enabled:=false;
  with Tstringgrid(Sender) do
  begin
    if (aRow >= 1) and (aCol = 0) then
    begin
      info:=TCatInfo(Objects[colinstall,aRow]);
      if info.installed then
      begin
        if info.newversion then
          InstallDlg(info)
        else
          UninstallDlg(info);
      end
      else begin
        if info.prereqok then
          InstallDlg(info)
        else
          ShowMessage(rsMissingPrere+' '+info.prereq);
      end;
    end;
  end;
end;

procedure Tf_updcatalog.InstallDlg(info: TCatInfo);
begin
  if info.newversion then
  begin
    if MessageDlg(Format(rsInstallNewVe, [info.version, info.installedversion]), mtConfirmation, mbYesNo, 0)=mryes then
    begin
      Uninstall(info);
      Install(info);
    end
    else EndInstallTimer.Enabled:=true;
  end
  else begin
    if MessageDlg(rsInstall+' '+info.catname,mtConfirmation,mbYesNo,0)=mryes then
    begin
      Install(info);
    end
    else EndInstallTimer.Enabled:=true;
  end;
end;

procedure Tf_updcatalog.UninstallDlg(info: TCatInfo);
var catlist: string;
begin
  catlist:=info.ListSamePathinGrid(info.grid);
  if MessageDlg(rsUninstall+' '+info.catname+catlist, mtConfirmation, mbYesNo, 0)=mryes then
  begin
    Uninstall(info);
  end;
  EndInstallTimer.Enabled:=true;
end;

procedure Tf_updcatalog.Install(info: TCatInfo);
var fn,ext: string;
begin
  ext := LowerCase(ExtractFileExt(info.url));
  if ext<>'.zip' then begin
    ShowMessage('Catalog file download is '+ext+', only .zip is supported');
    Exit;
  end;
  httpdownload:=THTTPBigDownload.Create(true);
  if Fcmain.HttpProxy then
  begin
    httpdownload.Proxy.Host:=Fcmain.ProxyHost;
    httpdownload.Proxy.Port:=StrToIntDef(Fcmain.ProxyPort,0);
    httpdownload.Proxy.UserName:=Fcmain.ProxyUser;
    httpdownload.Proxy.Password:=Fcmain.ProxyPass;
  end
  else
  begin
    httpdownload.Proxy.Host:='';
    httpdownload.Proxy.Port:=0;
    httpdownload.Proxy.UserName:='';
    httpdownload.Proxy.Password:='';
  end;
  fn:=slash(TempDir)+'catalog.zip';
  httpdownload.url:=info.url;
  httpdownload.filename:=fn;
  httpdownload.onProgress:=@ShowProgress;
  httpdownload.onDownloadComplete:=@DownloadComplete;
  httpdownload.onDownloadError:=@DownloadError;
  PanelDownload.Visible:=true;
  ButtonAbort.Visible:=true;
  LabelAction.Caption:=rsInstalling+' '+info.catname+Ellipsis;
  LabelProgress.Caption:='';
  InstallInfo:=info;
  httpdownload.Start;
end;

procedure Tf_updcatalog.DownloadComplete;
var f: textfile;
    fn: string;
begin
try
  ButtonAbort.Visible:=false;
  fn:=httpdownload.filename;
  if httpdownload.HttpResult and FileExists(fn) then
  begin
     if FileUnzipWithPath(PChar(fn), PChar(PrivateCatalogDir), @UnzipProgress) then
     begin
        AssignFile(f,slash(PrivateCatalogDir)+slash(InstallInfo.path)+InstallInfo.catname+'_version.txt');
        Rewrite(f);
        WriteLn(f,InstallInfo.version);
        CloseFile(f);
        DeleteFile(fn);

        if InstallInfo.catnum>0 then begin
          if InstallInfo.cattype='star' then
          begin
            Fcatalog.cfgcat.starcatpath[InstallInfo.catnum - BaseStar] := slash(PrivateCatalogDir)+slash(InstallInfo.path);
            Fcatalog.cfgcat.starcatdef[InstallInfo.catnum - BaseStar] := true;
            Fcatalog.cfgcat.starcatfield[InstallInfo.catnum - BaseStar, 1] := InstallInfo.minlevel;
            Fcatalog.cfgcat.starcatfield[InstallInfo.catnum - BaseStar, 2] := InstallInfo.maxlevel;
            if InstallInfo.catnum=gaia then begin
              Fcatalog.cfgcat.GaiaLevel:=1;
              Fcatalog.cfgcat.LimitGaiaCount:=false;
            end;
          end
          else if InstallInfo.cattype='double star' then
          begin
            Fcatalog.cfgcat.dblstarcatpath[InstallInfo.catnum - BaseDbl] := slash(PrivateCatalogDir)+slash(InstallInfo.path);
            Fcatalog.cfgcat.dblstarcatdef[InstallInfo.catnum - BaseDbl] := true;
            Fcatalog.cfgcat.dblstarcatfield[InstallInfo.catnum - BaseDbl, 1] := InstallInfo.minlevel;
            Fcatalog.cfgcat.dblstarcatfield[InstallInfo.catnum - BaseDbl, 2] := InstallInfo.maxlevel;
          end
          else if InstallInfo.cattype='variable star' then
          begin
            Fcatalog.cfgcat.varstarcatpath[InstallInfo.catnum - BaseVar] := slash(PrivateCatalogDir)+slash(InstallInfo.path);
            Fcatalog.cfgcat.varstarcatdef[InstallInfo.catnum - BaseVar] := true;
            Fcatalog.cfgcat.varstarcatfield[InstallInfo.catnum - BaseVar, 1] := InstallInfo.minlevel;
            Fcatalog.cfgcat.varstarcatfield[InstallInfo.catnum - BaseVar, 2] := InstallInfo.maxlevel;
          end
          else if InstallInfo.cattype='dso' then
          begin
            Fcatalog.cfgcat.nebcatpath[InstallInfo.catnum - BaseNeb] := slash(PrivateCatalogDir)+slash(InstallInfo.path);;
            Fcatalog.cfgcat.nebcatdef[InstallInfo.catnum - BaseNeb] := true;
            Fcatalog.cfgcat.nebcatfield[InstallInfo.catnum - BaseNeb, 1] := InstallInfo.minlevel;
            Fcatalog.cfgcat.nebcatfield[InstallInfo.catnum - BaseNeb, 2] := InstallInfo.maxlevel;
          end;
          if Assigned(FSaveConfig) then FSaveConfig(self);
        end;

     end
     else begin
       ShowMessage('Unzip error : '+fn);
     end;
  end
  else
  begin
    ShowMessage('Download error: '+httpdownload.HttpErr);
  end;
finally
  EndInstallTimer.Enabled:=true;
end;
end;

procedure Tf_updcatalog.DownloadError;
begin
try
 ShowMessage('Download error: '+httpdownload.HttpErr);
finally
  EndInstallTimer.Enabled:=true;
end;
end;

procedure Tf_updcatalog.EndInstallTimerTimer(Sender: TObject);
begin
  EndInstallTimer.Enabled:=false;
  PanelDownload.Visible:=false;
  LoadCatalogList;
  FRunning:=False;
  ButtonClose.Enabled:=true;
end;

procedure Tf_updcatalog.ButtonAbortClick(Sender: TObject);
begin
  httpdownload.Abort;
end;

procedure Tf_updcatalog.ShowProgress;
begin
  LabelProgress.Caption:=httpdownload.progresstext;
end;

procedure Tf_updcatalog.UnzipProgress(Sender : TObject);
begin
 LabelProgress.Caption:=u_unzip.ProgressMessage;
 Application.ProcessMessages;
end;

procedure Tf_updcatalog.Uninstall(info: TCatInfo);
var dir: string;
begin
  if (trim(PrivateCatalogDir)='')or(trim(info.path)='') then exit;
  dir:=slash(PrivateCatalogDir)+slash(info.path);
  if not DeleteDirectory(dir,false) then
    ShowMessage('Error deleting '+dir);
end;

end.

