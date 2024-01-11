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

uses u_constant, u_util, u_translation, UScaleDPI, downloaddialog, cu_calceph,
  cu_httpdownload, u_unzip, cu_catalog, FileUtil, cu_database, cu_planet,
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, Grids, ComCtrls, StdCtrls, Types;

type

  TCatInfo = class(TObject)
    installed, prereqok, newversion: boolean;
    catnum,minlevel,maxlevel: integer;
    cattype,cdcminversion,version,catname,desc,size,url,prereq,path,shortname: string;
    installedversion,infourl: string;
    grid: TStringGrid;
    constructor Create(data:Tstringlist);
    procedure SearchInstalled(basedir:string);
    procedure SearchPrereqInGrid(g:TStringGrid);
    function ListDependInGrid(g:TStringGrid): string;
    function ListSamePathInGrid(g:TStringGrid): string;
  end;

  { Tf_updcatalog }

  Tf_updcatalog = class(TForm)
    ButtonSetup: TButton;
    ButtonRefresh: TButton;
    ButtonClose: TButton;
    ButtonAbort: TButton;
    GridExpert: TStringGrid;
    GridKernel: TStringGrid;
    GridPicture: TStringGrid;
    GridVar: TStringGrid;
    GridDouble: TStringGrid;
    GridDSO: TStringGrid;
    Label1: TLabel;
    LabelInfo: TLabel;
    LabelAction: TLabel;
    LabelProgress: TLabel;
    PageControl1: TPageControl;
    Panel1: TPanel;
    Panel2: TPanel;
    GridStar: TStringGrid;
    PanelDownload: TPanel;
    ProgressBar1: TProgressBar;
    ProgressCat: TLabel;
    TabSheetExpert: TTabSheet;
    TabSheetKernel: TTabSheet;
    TabSheetPicture: TTabSheet;
    TabSheetStar: TTabSheet;
    TabSheetVar: TTabSheet;
    TabSheetDouble: TTabSheet;
    TabSheetDSO: TTabSheet;
    EndInstallTimer: TTimer;
    procedure ButtonAbortClick(Sender: TObject);
    procedure ButtonCloseClick(Sender: TObject);
    procedure ButtonRefreshClick(Sender: TObject);
    procedure ButtonSetupClick(Sender: TObject);
    procedure EndInstallTimerTimer(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure GridButtonClick(Sender: TObject; aCol, aRow: Integer);
    procedure GridGetCellHint(Sender: TObject; ACol, ARow: Integer; var HintText: String);
    procedure GridDrawCell(Sender: TObject; aCol, aRow: Integer; aRect: TRect; aState: TGridDrawState);
    procedure PageControl1Change(Sender: TObject);
  private
    Fcatalog: Tcatalog;
    Fcmain: Tconf_main;
    Fcdb: Tcdcdb;
    Fplanet: TPlanet;
    FSaveConfig, FOpenSetup: TNotifyEvent;
    InstallInfo: TCatInfo;
    httpdownload: THTTPBigDownload;
    FRunning: boolean;
    procedure ClearGrid(g:TStringGrid);
    procedure LoadCatalogList;
    function UpdateList(ForceDownload: boolean; out txt: string): boolean;
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
    property Running: boolean read FRunning;
    property cmain: Tconf_main read Fcmain write Fcmain;
    property catalog: Tcatalog read Fcatalog write Fcatalog;
    property cdb: Tcdcdb read Fcdb write Fcdb;
    property onSaveConfig: TNotifyEvent read FSaveConfig write FSaveConfig;
    property onOpenSetup: TNotifyEvent read FOpenSetup write FOpenSetup;
  end;

var
  f_updcatalog: Tf_updcatalog;

implementation

const colaction=0; colinstall=1; colname=2; coldesc=3; colsize=4; colinfo=5;

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
  shortname:=data[10];
  minlevel:=StrToIntDef(data[11],0);
  maxlevel:=StrToIntDef(data[12],10);
  infourl:=data[13];
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
  ButtonRefresh.Caption:=rsRefreshTheLi;
  TabSheetStar.Caption:=rsStars;
  TabSheetVar.Caption:=rsVariableStar2;
  TabSheetDouble.Caption:=rsDoubleStar;
  TabSheetDSO.Caption:=rsNebulae;
  TabSheetPicture.Caption:=rsDSOCatalogPi;
  TabSheetKernel.Caption:=rsSolarSystem;
  TabSheetExpert.Caption:=rsSpecializedD;
  GridStar.Columns[1].Title.Caption:=rsStatus;
  GridStar.Columns[2].Title.Caption:=rsCatalog;
  GridStar.Columns[3].Title.Caption:=rsDescription;
  GridStar.Columns[4].Title.Caption:=rsSize;
  GridStar.Columns[5].Title.Caption:=rsInfo;
  GridVar.Columns[1].Title.Caption:=rsStatus;
  GridVar.Columns[2].Title.Caption:=rsCatalog;
  GridVar.Columns[3].Title.Caption:=rsDescription;
  GridVar.Columns[4].Title.Caption:=rsSize;
  GridVar.Columns[5].Title.Caption:=rsInfo;
  GridDouble.Columns[1].Title.Caption:=rsStatus;
  GridDouble.Columns[2].Title.Caption:=rsCatalog;
  GridDouble.Columns[3].Title.Caption:=rsDescription;
  GridDouble.Columns[4].Title.Caption:=rsSize;
  GridDouble.Columns[5].Title.Caption:=rsInfo;
  GridDSO.Columns[1].Title.Caption:=rsStatus;
  GridDSO.Columns[2].Title.Caption:=rsCatalog;
  GridDSO.Columns[3].Title.Caption:=rsDescription;
  GridDSO.Columns[4].Title.Caption:=rsSize;
  GridDSO.Columns[5].Title.Caption:=rsInfo;
  GridPicture.Columns[1].Title.Caption:=rsStatus;
  GridPicture.Columns[2].Title.Caption:=rsCatalog;
  GridPicture.Columns[3].Title.Caption:=rsDescription;
  GridPicture.Columns[4].Title.Caption:=rsSize;
  GridPicture.Columns[5].Title.Caption:=rsInfo;
  GridKernel.Columns[1].Title.Caption:=rsStatus;
  GridKernel.Columns[2].Title.Caption:=rsCatalog;
  GridKernel.Columns[3].Title.Caption:=rsDescription;
  GridKernel.Columns[4].Title.Caption:=rsSize;
  GridKernel.Columns[5].Title.Caption:=rsInfo;
  GridExpert.Columns[1].Title.Caption:=rsStatus;
  GridExpert.Columns[2].Title.Caption:=rsCatalog;
  GridExpert.Columns[3].Title.Caption:=rsDescription;
  GridExpert.Columns[4].Title.Caption:=rsSize;
  GridExpert.Columns[5].Title.Caption:=rsInfo;
  Label1.Caption := rsToConfigureT+':';
  ButtonSetup.Caption:=rsOpenCatalogS;
  ButtonAbort.Caption:=rsAbort;
  ButtonClose.Caption:=rsClose;

end;

procedure Tf_updcatalog.FormCreate(Sender: TObject);
begin
  ScaleDPI(Self);
  SetLang;
  PageControl1.ActivePageIndex:=0;
  LabelInfo.Caption:=rsInstallStarC;
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
  ClearGrid(GridPicture);
  ClearGrid(GridKernel);
  ClearGrid(GridExpert);
end;

procedure Tf_updcatalog.ButtonCloseClick(Sender: TObject);
begin
  Close;
end;

procedure Tf_updcatalog.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CanClose := not FRunning;
end;

procedure Tf_updcatalog.PageControl1Change(Sender: TObject);
begin
  case PageControl1.ActivePageIndex of
    0 : LabelInfo.Caption:=rsInstallStarC;
    1 : LabelInfo.Caption:=rsInstallOneOf;
    2 : LabelInfo.Caption:=rsInstallOneOf2;
    3 : LabelInfo.Caption:=rsInstallAddit;
    4 : LabelInfo.Caption:=rsInstallPictu;
    5 : LabelInfo.Caption:=rsInstallEphem;
  end;
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
  UpdateList(False,buf);
  ClearGrid(GridStar);
  ClearGrid(GridVar);
  ClearGrid(GridDouble);
  ClearGrid(GridDSO);
  ClearGrid(GridPicture);
  ClearGrid(GridKernel);
  ClearGrid(GridExpert);
  row := Tstringlist.Create;
  fn := slash(PrivateCatalogDir)+'catalog_list.txt';
  if FileExists(fn) then begin
    AssignFile(f,fn);
    Reset(f);
    repeat
      ReadLn(f,buf);
      if copy(buf,1,1)='#' then continue;
      Splitrec2(buf,';',row);
      if row.Count<>14 then continue;
      if row[1] > cdcver then continue; // skip catalog not supported by this version of the program
      // type of object
      if row[0]='star' then grid:=GridStar
      else if row[0]='double star' then grid:=GridDouble
      else if row[0]='variable star' then grid:=GridVar
      else if row[0]='dso' then grid:=GridDSO
      else if row[0]='picture' then grid:=GridPicture
      else if row[0]='kernel' then grid:=GridKernel
      else if row[0]='expert' then grid:=GridExpert
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
      grid.Cells[colinfo,grid.RowCount-1]:='->';
    until eof(f);
    CloseFile(f);
    row.Free;
    ShowStatus(GridStar);
    ShowStatus(GridVar);
    ShowStatus(GridDouble);
    ShowStatus(GridDSO);
    ShowStatus(GridPicture);
    ShowStatus(GridKernel);
    ShowStatus(GridExpert);
  end;
end;

function Tf_updcatalog.UpdateList(ForceDownload: boolean; out txt: string): boolean;
var
  dl: TDownloadDialog;
  fn: string;
  ft: TDateTime;
  doDownload: boolean;
begin
  result:=false;
  txt:='';
  fn := slash(PrivateCatalogDir)+'catalog_list.txt';
  doDownload:=true;
  if (not ForceDownload) and FileExists(fn) then begin
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
      dl.QuickCancel := FileExists(fn);
      dl.URL := URL_CATALOG_LIST;
      dl.SaveToFile := fn;
      result:=dl.Execute;
      txt:=dl.ResponseText;
    finally
      dl.Free;
    end;
  end;
end;

procedure Tf_updcatalog.ButtonRefreshClick(Sender: TObject);
var txt: string;
begin
  if UpdateList(True,txt) then begin
    LoadCatalogList;
    ShowMessage(rsUpdatedSucce);
  end
  else
    ShowMessage(rsError+': '+txt);
end;

procedure Tf_updcatalog.ShowStatus(grid: TStringGrid);
var i: integer;
    info: TCatInfo;
    txt: string;
    prereqgrid:TStringGrid;
begin
  for i:=1 to grid.RowCount-1 do begin
    info:=TCatInfo(grid.Objects[colinstall,i]);
    if info.cattype='picture' then
      prereqgrid:=GridDSO
    else
      prereqgrid:=grid;
    info.SearchPrereqInGrid(prereqgrid);
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
  with Tstringgrid(Sender) do
  begin
    if (aRow >= 1) and (aCol = colaction) then
    begin
      if FRunning then Exit;
      FRunning:=True;
      ButtonClose.Enabled:=false;
      ButtonRefresh.Enabled:=false;
      ButtonSetup.Enabled:=false;
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
        else begin
          ShowMessage(rsMissingPrere+' '+info.prereq);
          FRunning:=False;
          ButtonClose.Enabled:=true;
          ButtonRefresh.Enabled:=true;
          ButtonSetup.Enabled:=true;
        end;
      end;
    end
    else if (aRow >= 1) and (aCol = colinfo) then
    begin
      info:=TCatInfo(Objects[colinstall,aRow]);
      if info.infourl<>'' then ExecuteFile(info.infourl);
    end;
  end;
end;

procedure Tf_updcatalog.GridGetCellHint(Sender: TObject; ACol, ARow: Integer; var HintText: String);
var txt: string;
begin
with sender as TStringGrid do begin
 if ((aCol=colinstall)or(aCol=colaction))and(arow>0) then begin
   with Objects[colinstall,ARow] as TCatInfo do begin
      if installed then begin
        if newversion then
          txt:=rsNewVersionAv+': '+version
        else
          txt:=rsInstalled+': '+slash(PrivateCatalogDir)+slash(path);
      end
      else begin
        if prereqok then
          txt:=rsInstall+': '+catname
        else
          if cattype='picture' then
            txt:=rsMissingPrere+': '+rsNebula+', '+prereq
          else
            txt:=rsMissingPrere+': '+prereq;
      end;
   end;
   HintText:=txt;
 end
 else if (trim(Cells[Acol,Arow])<>'')and(Canvas.TextWidth(Cells[Acol,Arow])>ColWidths[Acol]) then begin
   HintText:=Cells[Acol,Arow];
 end;
end;
end;

procedure Tf_updcatalog.GridDrawCell(Sender: TObject; aCol, aRow: Integer; aRect: TRect; aState: TGridDrawState);
begin
  if (aCol=colinstall)and(aRow>0) then begin
    with sender as TStringGrid do begin
      with Objects[colinstall,ARow] as TCatInfo do begin
         if installed then begin
           if newversion then
             Canvas.Pen.Color:=clYellow
           else
             Canvas.Pen.Color:=clLime;
         end
         else begin
           if prereqok then
             Canvas.Pen.Color:=clWindow
           else
             Canvas.Pen.Color:=clred;
         end;
      end;
      Canvas.Pen.Style:=psSolid;
      Canvas.Pen.Width:=DoScaleX(3);
      Canvas.Brush.Style:=bsClear;
      Canvas.Rectangle(aRect);
    end;
  end;
end;

procedure Tf_updcatalog.InstallDlg(info: TCatInfo);
begin
  if info.newversion then
  begin
    if MessageDlg(info.catname+crlf+Format(rsInstallNewVe, [info.version, info.installedversion]), mtConfirmation, mbYesNo, 0)=mryes then
    begin
      Uninstall(info);
      Install(info);
    end
    else EndInstallTimer.Enabled:=true;
  end
  else begin
    if MessageDlg(rsInstall+' '+info.catname+crlf+info.desc,mtConfirmation,mbYesNo,0)=mryes then
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
  if Info.catnum<>3 then begin
    ext := LowerCase(ExtractFileExt(info.url));
    if ext<>'.zip' then begin
      ShowMessage('Catalog file download is '+ext+', only .zip is supported');
      EndInstallTimer.Enabled:=true;
      Exit;
    end;
  end;
  httpdownload:=THTTPBigDownload.Create(true);
  if Fcmain.HttpProxy then
  begin
    httpdownload.SocksProxy := '';
    httpdownload.SocksType := '';
    httpdownload.HttpProxy := Fcmain.ProxyHost;
    httpdownload.HttpProxyPort := Fcmain.ProxyPort;
    httpdownload.HttpProxyUser := Fcmain.ProxyUser;
    httpdownload.HttpProxyPass := Fcmain.ProxyPass;
  end
  else if Fcmain.SocksProxy then
  begin
    httpdownload.HttpProxy := '';
    httpdownload.SocksType := Fcmain.SocksType;
    httpdownload.SocksProxy := Fcmain.ProxyHost;
    httpdownload.HttpProxyPort := Fcmain.ProxyPort;
    httpdownload.HttpProxyUser := Fcmain.ProxyUser;
    httpdownload.HttpProxyPass := Fcmain.ProxyPass;
  end
  else
  begin
    httpdownload.SocksProxy := '';
    httpdownload.SocksType := '';
    httpdownload.HttpProxy := '';
    httpdownload.HttpProxyPort := '';
    httpdownload.HttpProxyUser := '';
    httpdownload.HttpProxyPass := '';
  end;
  if info.catnum=3 then begin
    fn:=slash(PrivateCatalogDir)+slash(info.path);
    if not directoryexists(fn) then
      CreateDir(fn);
    fn:=fn+ExtractFileName(info.url)
  end
  else
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
    i,j: integer;
begin
try
  ButtonAbort.Visible:=false;
  fn:=httpdownload.filename;
  if httpdownload.HttpResult and FileExists(fn) then
  begin
     if (InstallInfo.catnum=3) or FileUnzipWithPath(PChar(fn), PChar(PrivateCatalogDir), @UnzipProgress) then
     begin
        AssignFile(f,slash(PrivateCatalogDir)+slash(InstallInfo.path)+InstallInfo.catname+'_version.txt');
        Rewrite(f);
        WriteLn(f,InstallInfo.version);
        CloseFile(f);
        if (InstallInfo.catnum<>3) then DeleteFile(fn);

        if InstallInfo.catnum>BaseStar then begin      // standard catalog
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
            Fcatalog.cfgcat.nebcatpath[InstallInfo.catnum - BaseNeb] := slash(PrivateCatalogDir)+slash(InstallInfo.path);
            Fcatalog.cfgcat.nebcatdef[InstallInfo.catnum - BaseNeb] := true;
            Fcatalog.cfgcat.nebcatfield[InstallInfo.catnum - BaseNeb, 1] := InstallInfo.minlevel;
            Fcatalog.cfgcat.nebcatfield[InstallInfo.catnum - BaseNeb, 2] := InstallInfo.maxlevel;
          end;
          if Assigned(FSaveConfig) then FSaveConfig(self);
        end
        else if InstallInfo.catnum=0 then  // Catgen catalog
        begin
          i := -1;
          for j := 0 to Fcatalog.cfgcat.GCatNum - 1 do
            if Fcatalog.cfgcat.GCatLst[j].shortname = trim(InstallInfo.shortname) then
              i := j;
          if i < 0 then
          begin
            Fcatalog.cfgcat.GCatNum := Fcatalog.cfgcat.GCatNum + 1;
            SetLength(Fcatalog.cfgcat.GCatLst, Fcatalog.cfgcat.GCatNum);
            i := Fcatalog.cfgcat.GCatNum - 1;
          end;
          Fcatalog.cfgcat.GCatLst[i].shortname := trim(InstallInfo.shortname);
          Fcatalog.cfgcat.GCatLst[i].path := slash(PrivateCatalogDir)+slash(InstallInfo.path);
          Fcatalog.cfgcat.GCatLst[i].min := InstallInfo.minlevel;
          Fcatalog.cfgcat.GCatLst[i].max := InstallInfo.maxlevel;
          Fcatalog.cfgcat.GCatLst[i].Actif := true;
          Fcatalog.cfgcat.GCatLst[i].magmax := 0;
          Fcatalog.cfgcat.GCatLst[i].Name := '';
          Fcatalog.cfgcat.GCatLst[i].cattype := 0;
          Fcatalog.cfgcat.GCatLst[i].ForceColor := False;
          Fcatalog.cfgcat.GCatLst[i].col := 0;
          if not Fcatalog.GetInfo(Fcatalog.cfgcat.GCatLst[i].path,
            Fcatalog.cfgcat.GCatLst[i].shortname, Fcatalog.cfgcat.GCatLst[i].magmax,
            Fcatalog.cfgcat.GCatLst[i].cattype, Fcatalog.cfgcat.GCatLst[i].version,
            Fcatalog.cfgcat.GCatLst[i].Name) then
            Fcatalog.cfgcat.GCatLst[i].Actif := False;
          if Assigned(FSaveConfig) then FSaveConfig(self);
        end
        else if InstallInfo.catnum=1 then  // Pictures
        begin
          if InstallInfo.cattype='picture' then
          begin
            ProgressCat.Visible:=true;
            ProgressBar1.Visible:=true;
            cmain.ImagePath:=slash(PrivateCatalogDir)+'pictures';
            Fcdb.ScanImagesDirectory(cmain.ImagePath, ProgressCat, ProgressBar1);
            ProgressCat.Visible:=false;
            ProgressBar1.Visible:=false;
          end;
          if Assigned(FSaveConfig) then FSaveConfig(self);
        end
        else if InstallInfo.catnum=2 then  // spice kernel
        begin
          if InstallInfo.cattype='kernel' then
          begin
            Load_Calceph_Files;
          end;
        end
        else if InstallInfo.catnum=3 then  // JPL ephemeris
        begin
          if InstallInfo.cattype='kernel' then
          begin
            Fplanet.load_de(MaxInt); // clear current file in cache
          end;
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
  ButtonRefresh.Enabled:=true;
  ButtonSetup.Enabled:=true;
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
  if (info.catnum=0)and(info.shortname<>'') then
    Fcatalog.removeGcat(info.shortname);
  dir:=slash(PrivateCatalogDir)+slash(info.path);
  if not DeleteDirectory(dir,false) then begin
    ShowMessage('Error deleting '+dir);
    exit;
  end;
  if (info.catnum=1)and(info.cattype='picture') then
  begin
    PanelDownload.Visible:=true;
    ProgressCat.Visible:=true;
    ProgressBar1.Visible:=true;
    Application.ProcessMessages;
    cmain.ImagePath:=slash(PrivateCatalogDir)+'pictures';
    Fcdb.ScanImagesDirectory(cmain.ImagePath, ProgressCat, ProgressBar1);
    ProgressCat.Visible:=false;
    ProgressBar1.Visible:=false;
    PanelDownload.Visible:=false;
  end;
end;

procedure Tf_updcatalog.ButtonSetupClick(Sender: TObject);
begin
  if assigned(FOpenSetup) then FOpenSetup(self);
end;


end.

