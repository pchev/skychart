{
Copyright (C) 2002 Patrick Chevalley

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
 Cross-platform common code for Main form.
}

procedure Tf_main.Init;
var cfgs :conf_skychart;
    cfgp : conf_plot;
    i: integer;
begin
try
 // some initialisation that need to be done after all the forms are created. Kylix onShow is called immediatly after onCreate, not after application.run!
 f_info.onGetTCPinfo:=GetTCPInfo;
 f_info.onKillTCP:=KillTCPClient;
 f_info.onPrintSetup:=PrintSetup;
 f_info.OnShowDetail:=showdetailinfo;
 f_detail.OnCenterObj:=CenterFindObj;
 f_detail.OnNeighborObj:=NeighborObj;
 SetDefault;
 ReadDefault;
 // must read db configuration before to create this one!
 cdcdb:=TCDCdb.Create(self);
 planet:=Tplanet.Create(self);
 Fits:=TFits.Create(self);
 cdcdb.onInitializeDB:=InitializeDB;
 planet.cdb:=cdcdb;
 SetButtonImage(ButtonImage);
{$ifdef mswindows}
 if nightvision then SetNightVision(nightvision);
 telescope.pluginpath:=slash(appdir)+slash('plugins')+slash('telescope');
 telescope.plugin:=def_cfgsc.ScopePlugin;
{$endif}
 if def_cfgsc.BackgroundImage='' then begin
   def_cfgsc.BackgroundImage:=slash(privatedir)+slash('pictures');
   if not DirectoryExists(def_cfgsc.BackgroundImage) then forcedirectories(def_cfgsc.BackgroundImage);
 end;
 catalog.LoadConstellation(cfgm.Constellationfile);
 catalog.LoadConstL(cfgm.ConstLfile);
 catalog.LoadConstB(cfgm.ConstBfile);
 catalog.LoadHorizon(cfgm.horizonfile,def_cfgsc);
 catalog.LoadStarName(slash(appdir)+slash('data')+slash('common_names')+'StarsNames.txt');
 f_search.cfgshr:=catalog.cfgshr;
 f_search.Init;
 SetLang;
 InitFonts;
 SetLpanel1('');
 ConnectDB;
 Fits.min_sigma:=cfgm.ImageLuminosity;
 Fits.max_sigma:=cfgm.ImageContrast;
 CreateMDIChild(GetUniqueName('Chart_',true),true,def_cfgsc,def_cfgplot,true);
 Autorefresh.Interval:=cfgm.autorefreshdelay*1000;
 Autorefresh.enabled:=true;
 if cfgm.AutostartServer then StartServer;
 f_calendar.planet:=planet;
 f_calendar.cdb:=cdcdb;
 f_calendar.eclipsepath:=slash(appdir)+slash('data')+slash('eclipses');
 f_calendar.OnGetChartConfig:=GetChartConfig;
 f_calendar.OnUpdateChart:=DrawChart;
 f_calendar.setlang(slash(appdir)+slash('data')+slash('language')+'cdclang_'+trim(cfgm.language)+'.ini');
 if InitialChartNum>1 then
    for i:=1 to InitialChartNum-1 do begin
      cfgp:=def_cfgplot;
      cfgs:=def_cfgsc;
      ReadChartConfig(configfile+inttostr(i),true,false,cfgp,cfgs);
      CreateMDIChild(GetUniqueName('Chart_',true) ,false,cfgs,cfgp);
    end;
 if nightvision then begin
    nightvision:=false;
    ToolButtonNightVisionClick(self);
 end;
except
end;
end;

function Tf_main.CreateMDIChild(const CName: string; copyactive: boolean; cfg1 : conf_skychart; cfgp : conf_plot; locked:boolean=false):boolean;
var
  Child : Tf_chart;
  maxi: boolean;
  w,h,t,l: integer;
begin
  { allow for a reasonable number of chart }
  if (MDIChildCount>=MaxWindow) then begin
     SetLpanel1('Too many open window, please close some chart.');
     result:=false;
     exit;
  end;
  { copy active child config }
  if copyactive and (ActiveMDIchild is Tf_chart) then with ActiveMDIchild as Tf_chart do begin
    cfg1:=sc.cfgsc;
    cfgp:=sc.plot.cfgplot;
    cfg1.scopemark:=false;
    maxi:=maximize;
    w:=width;
    h:=height;
    t:=-1;
    l:=-1;
  end
  else begin
    maxi:=cfgm.maximized;
    w:=cfg1.winx;
    h:=cfg1.winy;
    t:=cfg1.wintop;
    l:=cfg1.winleft;
  end;
  { create a new MDI child window }
  Child := Tf_chart.Create(Application);
  if locked then Child.lock_refresh:=true;
  inc(cfgm.MaxChildID);
  Child.tag:=cfgm.MaxChildID;
  Child.Caption:=CName;
  Child.locked:=false;
  Child.sc.catalog:=catalog;
  Child.sc.Fits:=Fits;
  Child.sc.planet:=planet;
  Child.sc.cdb:=cdcdb;
  {$ifdef mswindows}
  Child.telescopeplugin:=telescope;
  {$endif}
  Child.sc.plot.cfgplot:=cfgp;
  Child.sc.plot.starshape:=starshape.Picture.Bitmap;
  Child.sc.plot.cfgplot.starshapesize:=starshape.Picture.bitmap.Width div 11;
  Child.sc.plot.cfgplot.starshapew:=Child.sc.plot.cfgplot.starshapesize div 2;
  Child.sc.cfgsc:=cfg1;
  Child.sc.cfgsc.chartname:=CName;
  Child.onImageSetFocus:=ImageSetFocus;
  Child.onShowTopMessage:=SetTopMessage;
  Child.OnUpdateBtn:=UpdateBtn;
  Child.OnChartMove:=ChartMove;
  Child.onShowInfo:=SetLpanel1;
  Child.onShowCoord:=SetLpanel0;
  Child.onListInfo:=ListInfo;
  Child.maximize:=maxi;
  Child.width:=w;
  Child.height:=h;
  if t>=0 then Child.top:=t;
  if l>=0 then Child.left:=l;
  if Child.sc.cfgsc.Projpole=Altaz then begin
     Child.sc.cfgsc.TrackOn:=true;
     Child.sc.cfgsc.TrackType:=4;
  end;
  {$ifdef mswindows}
    if not maxi then begin
  {$endif}
       Child.lock_refresh:=false;
       Child.FormResize(nil);
  {$ifdef mswindows}
    end;
  {$endif}
  {$ifdef linux}
  {require to switch the focus to work with the right child. Kylix bug?}
  try
  if MDIChildCount>2 then MDIChildren[1].setfocus // MDIChildren[0] already as focus
                     else quicksearch.setfocus;
  except
    // here if quicksearch is hiden, do nothing.
  end;
  {$endif}
  result:=true;
  UpdateBtn(Child.sc.cfgsc.flipx,Child.sc.cfgsc.flipy,Child.Connect1.checked,Child);
end;

procedure Tf_main.CopySCconfig(c1:conf_skychart;var c2:conf_skychart);
var i : integer;
begin
c2.CurYear:=c1.CurYear;
c2.CurMonth := c1.CurMonth ;
c2.CurDay := c1.CurDay ;
c2.UseSystemTime := c1.UseSystemTime ;
c2.autorefresh := c1.autorefresh ;
c2.CurTime := c1.CurTime ;
c2.DT_UT := c1.DT_UT ;
c2.DT_UT_val := c1.DT_UT_val ;
c2.Force_DT_UT := c1.Force_DT_UT ;
c2.ObsLatitude := c1.ObsLatitude ;
c2.ObsLongitude := c1.ObsLongitude ;
c2.ObsAltitude := c1.ObsAltitude ;
c2.ObsTZ := c1.ObsTZ ;
c2.TimeZone := c1.TimeZone ;
c2.ObsTemperature := c1.ObsTemperature ;
c2.ObsPressure := c1.ObsPressure ;
c2.ObsName := c1.ObsName ;
c2.ObsCountry := c1.ObsCountry ;
c2.DrawPMyear := c1.DrawPMyear ;
c2.PMon := c1.PMon ;
c2.DrawPMon := c1.DrawPMon ;
c2.ApparentPos := c1.ApparentPos;
for i:=0 to 10 do c2.projname[i] := c1.projname[i];
c2.Simnb := c1.Simnb ;
c2.SimLine := c1.SimLine ;
c2.SimD := c1.SimD ;
c2.SimH := c1.SimH ;
c2.SimM := c1.SimM ;
c2.SimS := c1.SimS ;
c2.SimObject := c1.SimObject ;
c2.PlanetParalaxe := c1.PlanetParalaxe ;
c2.ShowPlanet := c1.ShowPlanet ;
c2.ShowAsteroid := c1.ShowAsteroid ;
c2.ShowImages := c1.ShowImages ;
c2.ShowBackgroundImage := c1.ShowBackgroundImage ;
c2.BackgroundImage := c1.BackgroundImage ;
c2.AstmagMax := c1.AstmagMax;
c2.AstmagDiff := c1.AstmagDiff;
c2.AstSymbol := c1.AstSymbol;
c2.ShowComet := c1.ShowComet ;
c2.CommagMax := c1.CommagMax;
c2.CommagDiff := c1.CommagDiff;
c2.ComSymbol := c1.ComSymbol;
c2.MagLabel := c1.MagLabel;
c2.NameLabel := c1.NameLabel;
c2.ConstFullLabel := c1.ConstFullLabel;
c2.GRSlongitude := c1.GRSlongitude ;
c2.ShowEarthShadow := c1.ShowEarthShadow ;
c2.ProjPole := c1.ProjPole ;
c2.ShowEqGrid := c1.ShowEqGrid ;
c2.ShowGrid := c1.ShowGrid ;
c2.ShowGridNum := c1.ShowGridNum ;
c2.ShowConstL := c1.ShowConstL ;
c2.ShowConstB := c1.ShowConstB ;
c2.ShowEcliptic := c1.ShowEcliptic ;
c2.ShowGalactic := c1.ShowGalactic ;
c2.ShowMilkyWay := c1.ShowMilkyWay ;
c2.FillMilkyWay := c1.FillMilkyWay ;
c2.HorizonOpaque := c1.HorizonOpaque ;
c2.ShowHorizon := c1.ShowHorizon ;
c2.ShowHorizonDepression := c1.ShowHorizonDepression ;
c2.HorizonMax := c1.HorizonMax ;
c2.Horizonlist := c1.Horizonlist ;
c2.ShowlabelAll := c1.ShowlabelAll ;
c2.Editlabels := c1.Editlabels ;
for i:=1 to numlabtype do begin
   c2.ShowLabel[i]:=c1.ShowLabel[i];
   c2.LabelMagDiff[i]:=c1.LabelMagDiff[i];
end;
for i:=1 to 10 do c2.circle[i,1]:=c1.circle[i,1];
for i:=1 to 10 do c2.circle[i,2]:=c1.circle[i,2];
for i:=1 to 10 do c2.circle[i,3]:=c1.circle[i,3];
for i:=1 to 10 do c2.circleok[i]:=c1.circleok[i];
for i:=1 to 10 do c2.circlelbl[i]:=c1.circlelbl[i];
for i:=1 to 10 do c2.rectangle[i,1]:=c1.rectangle[i,1];
for i:=1 to 10 do c2.rectangle[i,2]:=c1.rectangle[i,2];
for i:=1 to 10 do c2.rectangle[i,3]:=c1.rectangle[i,3];
for i:=1 to 10 do c2.rectangle[i,4]:=c1.rectangle[i,4];
for i:=1 to 10 do c2.rectangleok[i]:=c1.rectangleok[i];
for i:=1 to 10 do c2.rectanglelbl[i]:=c1.rectanglelbl[i];
c2.ShowCircle:=c1.ShowCircle;
c2.IndiServerHost:=c1.IndiServerHost;
c2.IndiServerPort:=c1.IndiServerPort;
c2.IndiServerCmd:=c1.IndiServerCmd;
c2.IndiDriver:=c1.IndiDriver;
c2.IndiPort:=c1.IndiPort;
c2.IndiDevice:=c1.IndiDevice;
c2.IndiTelescope:=c1.IndiTelescope;
c2.ScopePlugin:=c1.ScopePlugin;
//c2. := c1. ;
end;

procedure Tf_main.RefreshAllChild(applydef:boolean);
var i: integer;
begin
for i:=0 to MDIChildCount-1 do
  if MDIChildren[i] is Tf_chart then
     with MDIChildren[i] as Tf_chart do begin
      sc.Fits:=Fits;
      sc.planet:=planet;
      sc.cdb:=cdcdb;
      sc.plot.cfgplot:=def_cfgplot;
      if applydef then begin
        CopySCconfig(def_cfgsc,sc.cfgsc);
        sc.cfgsc.FindOk:=false;
      end;
      AutoRefresh;
     end;
end;

procedure Tf_main.SyncChild;
var i,y,m,d: integer;
    ra,de,jda,t,tz: double;
    st: boolean;
begin
if ActiveMDIChild is Tf_chart then begin
 ra:=(f_main.ActiveMDIChild as Tf_chart).sc.cfgsc.racentre;
 de:=(f_main.ActiveMDIChild as Tf_chart).sc.cfgsc.decentre;
 jda:=(f_main.ActiveMDIChild as Tf_chart).sc.cfgsc.jdchart;
 y:=(f_main.ActiveMDIChild as Tf_chart).sc.cfgsc.curyear;
 m:=(f_main.ActiveMDIChild as Tf_chart).sc.cfgsc.curmonth;
 d:=(f_main.ActiveMDIChild as Tf_chart).sc.cfgsc.curday;
 t:=(f_main.ActiveMDIChild as Tf_chart).sc.cfgsc.curtime;
 tz:=(f_main.ActiveMDIChild as Tf_chart).sc.cfgsc.ObsTZ;
 st:=(f_main.ActiveMDIChild as Tf_chart).sc.cfgsc.UseSystemTime;
 for i:=0 to MDIChildCount-1 do
  if (MDIChildren[i] is Tf_chart) and (MDIChildren[i]<>ActiveMDIChild) then
     with MDIChildren[i] as Tf_chart do begin
      precession(jda,sc.cfgsc.jdchart,ra,de);
      sc.cfgsc.UseSystemTime:=st;
      sc.cfgsc.curyear:=y;
      sc.cfgsc.curmonth:=m;
      sc.cfgsc.curday:=d;
      sc.cfgsc.curtime:=t;
      sc.cfgsc.ObsTZ:=tz;
      sc.cfgsc.TrackOn:=false;
      sc.cfgsc.racentre:=ra;
      sc.cfgsc.decentre:=de;
      Refresh;
     end;
end;
end;

procedure Tf_main.AutorefreshTimer(Sender: TObject);
var i: integer;
begin
for i:=0 to MDIChildCount-1 do
  if MDIChildren[i] is Tf_chart then
     with MDIChildren[i] as Tf_chart do begin
      if sc.cfgsc.autorefresh then AutoRefresh;
     end;
end;

function Tf_main.GetUniqueName(cname:string; forcenumeric:boolean):string;
var xname: array of string;
    i,n : integer;
    ok: boolean;
begin
setlength(xname,MDIChildCount);
for i:=0 to MDIChildCount-1 do xname[i]:=MDIChildren[i].caption;
if forcenumeric then n:=1
                else n:=0;
repeat
  ok:=true;
  if n=0 then result:=cname
         else result:=cname+inttostr(n);
  for i:=0 to MDIChildCount-1 do
     if xname[i]=result then ok:=false;
  inc(n);
until ok;
end;

procedure Tf_main.FileNew1Execute(Sender: TObject);
begin
  CreateMDIChild(GetUniqueName('Chart_',true),true,def_cfgsc,def_cfgplot);
end;

procedure Tf_main.FileOpen1Execute(Sender: TObject);
var cfgs :conf_skychart;
    cfgp : conf_plot;
    nam: string;
    p: integer;
begin
if Opendialog.InitialDir='' then Opendialog.InitialDir:=privatedir;
OpenDialog.Filter:='Cartes du Ciel 3 File|*.cdc3|All Files|*.*';
  if OpenDialog.Execute then begin
    cfgp:=def_cfgplot;
    cfgs:=def_cfgsc;
    ReadChartConfig(OpenDialog.FileName,true,false,cfgp,cfgs);
    nam:=stringreplace(extractfilename(OpenDialog.FileName),' ','_',[rfReplaceAll]);
    p:=pos('.',nam);
    if p>0 then nam:=copy(nam,1,p-1);
    CreateMDIChild(GetUniqueName(nam,false) ,false,cfgs,cfgp);
  end;
end;

procedure Tf_main.FileSaveAs1Execute(Sender: TObject);
begin
Savedialog.DefaultExt:='cdc3';
if Savedialog.InitialDir='' then Savedialog.InitialDir:=privatedir;
savedialog.Filter:='Cartes du Ciel 3 File|*.cdc3|All Files|*.*';
if ActiveMDIchild is Tf_chart then
  if SaveDialog.Execute then SaveChartConfig(SaveDialog.Filename,(ActiveMDIchild as Tf_chart));
end;

procedure Tf_main.SaveImageExecute(Sender: TObject);
var ext,format:string;
begin
Savedialog.DefaultExt:='png';
if Savedialog.InitialDir='' then Savedialog.InitialDir:=privatedir;
savedialog.Filter:='PNG|*.png|JPEG|*.jpg|BMP|*.bmp';
if ActiveMDIchild is Tf_chart then
 with ActiveMDIchild as Tf_chart do
  if SaveDialog.Execute then begin
     ext:=uppercase(extractfileext(SaveDialog.Filename));
     if (ext='.BMP') then format:='BMP'
     else if (ext='.JPG')or(ext='.JPEG') then format:='JPEG'
     else format:='PNG';
     SaveChartImage(format,SaveDialog.Filename,75);
  end;
end;

procedure Tf_main.HelpAbout1Execute(Sender: TObject);
begin
  f_about.ShowModal;
end;

procedure Tf_main.HelpContents1Execute(Sender: TObject);
begin
   ExecuteFile(slash(helpdir)+'index.html');
end;

procedure Tf_main.FileExit1Execute(Sender: TObject);
begin
  Close;
end;

Procedure Tf_main.GetAppDir;
var inif: TMemIniFile;
    buf: string;
{$ifdef mswindows}
    PIDL : PItemIDList;
    Folder : array[0..MAX_PATH] of Char;
{$endif}
begin
appdir:=extractfilepath(paramstr(0));
privatedir:=DefaultPrivateDir;
Tempdir:=DefaultTmpDir;
{$ifdef linux}
appdir:=expanddirectoryname(appdir);
privatedir:=expanddirectoryname(PrivateDir);
Tempdir:=expanddirectoryname(Tempdir);
{$endif}
{$ifdef mswindows}
SHGetSpecialFolderLocation(0, CSIDL_PERSONAL, PIDL);
SHGetPathFromIDList(PIDL, Folder);
privatedir:=slash(Folder)+privatedir;
configfile:=slash(privatedir)+configfile;
tracefile:=slash(privatedir)+tracefile;
Tempdir:=slash(privatedir)+DefaultTmpDir;
{$endif}
inif:=TMeminifile.create(configfile);
try
buf:=inif.ReadString('main','AppDir',appdir);
if Directoryexists(buf) then appdir:=buf;
privatedir:=inif.ReadString('main','PrivateDir',privatedir);
finally
 inif.Free;
end;
if not directoryexists(privatedir) then forcedirectories(privatedir);
if not directoryexists(slash(privatedir)+'MPC') then forcedirectories(slash(privatedir)+'MPC');
if not directoryexists(TempDir) then forcedirectories(TempDir);
{$ifdef linux}  // allow a shared install
if (not directoryexists(slash(appdir)+'data/constellation')) and
   (directoryexists(SharedDir)) then
   appdir:=SharedDir;
{$endif}
SampleDir:=slash(appdir)+slash('data')+'sample';
end;

procedure Tf_main.FormCreate(Sender: TObject);
begin
activecontrol:=quicksearch;
SysDecimalSeparator:=DecimalSeparator;
DecimalSeparator:='.';
NeedRestart:=false;
{$ifdef mswindows}
  configfile:=Defaultconfigfile;
{$endif}
{$ifdef linux}
  configfile:=expandfilename(Defaultconfigfile);
{$endif}
GetAppDir;
chdir(appdir);
InitTrace;
traceon:=true;
{$ifdef linux}    // FormShow is called immediately, before Application.Run, so this form need to be created immediately here. Be sure to remove them from the .dpr file.
InitTheme;
f_info:=TF_info.Create(application);
f_directory:=Tf_directory.Create(application);
f_calendar:=Tf_calendar.Create(application);
f_search:=Tf_search.Create(application);
f_getdss:=Tf_getdss.Create(application);
{$endif}
catalog:=Tcatalog.Create(self);
{$ifdef mswindows}
DdeOpen := false;
DdeEnqueue := false;
DdeInfo := TstringList.create;
DdeInfo.add('.');
DdeInfo.add('.');
DdeInfo.add('.');
DdeInfo.add('.');
DdeInfo.add('.');
Screen.Cursors[crRetic] := LoadCursor(HInstance,'RETIC');
Application.UpdateFormatSettings:=false;
telescope:=Ttelescope.Create(self);
{$endif}
end;

procedure Tf_main.FormShow(Sender: TObject);
begin

end;

procedure Tf_main.FormDestroy(Sender: TObject);
begin
try
StopServer;
catalog.free;
Fits.Free;
planet.free;
cdcdb.free;
{$ifdef mswindows}
telescope.free;
DdeInfo.free;
{$endif}
{$ifdef linux}
{f_info.free;
f_directory.free;
f_calendar.free;
f_search.free; }
{$endif}
if NeedRestart then
   {$ifdef mswindows}
      ExecNoWait(paramstr(0));
   {$endif}
   {$ifdef linux}
      ExecFork(paramstr(0),'-ns');
   {$endif}
except
end;
end;

procedure Tf_main.FormClose(Sender: TObject; var Action: TCloseAction);
var i:integer;
begin
try
{$ifdef mswindows}
if nightvision then ResetWinColor;
{$endif}
writetrace('Exiting ...');
SaveQuickSearch(configfile);
if SaveConfigOnExit.checked and
   (MessageDlg('Do you want to save the program setting now?',mtConfirmation,[mbYes, mbNo],0)=mrYes) then
      SaveDefault;
for i:=0 to MDIChildCount-1 do
   if MDIChildren[i] is Tf_chart then with (MDIChildren[i] as Tf_chart) do begin
      locked:=true;
      if indi1<>nil then indi1.terminate;
   end;
except
end;
end;

procedure Tf_main.SaveConfigurationExecute(Sender: TObject);
begin
SaveDefault;
end;

procedure Tf_main.EditCopy1Execute(Sender: TObject);
begin
if ActiveMDIchild is Tf_chart then Clipboard.Assign(Tf_chart(ActiveMDIchild).Image1.Picture.Bitmap);
end;

procedure Tf_main.Print1Execute(Sender: TObject);
begin
if ActiveMdiChild is Tf_chart then
   with ActiveMdiChild as Tf_chart do
      PrintChart(cfgm.printlandscape,cfgm.printcolor,cfgm.PrintMethod,cfgm.PrinterResolution,cfgm.PrintCmd1,cfgm.PrintCmd2,cfgm.PrintTmpPath);
end;

procedure Tf_main.UndoExecute(Sender: TObject);
begin
if ActiveMdiChild is Tf_chart then with ActiveMdiChild as Tf_chart do UndoExecute(Sender);
end;

procedure Tf_main.RedoExecute(Sender: TObject);
begin
if ActiveMdiChild is Tf_chart then with ActiveMdiChild as Tf_chart do RedoExecute(Sender);
end;

procedure Tf_main.zoomplusExecute(Sender: TObject);
begin
if ActiveMdiChild is Tf_chart then with ActiveMdiChild as Tf_chart do zoomplusExecute(Sender);
end;

procedure Tf_main.zoomminusExecute(Sender: TObject);
begin
if ActiveMdiChild is Tf_chart then with ActiveMdiChild as Tf_chart do zoomminusExecute(Sender);
end;


procedure Tf_main.ZoomBarExecute(Sender: TObject);
begin
if ActiveMdiChild is Tf_chart then with ActiveMdiChild as Tf_chart do begin
 formpos(f_zoom,mouse.cursorpos.x,mouse.cursorpos.y);
 f_zoom.fov:=rad2deg*sc.cfgsc.fov;
 f_zoom.showmodal;
 if f_zoom.modalresult=mrOK then begin
    sc.setfov(deg2rad*f_zoom.fov);
    Refresh;
 end;

end;
end;

procedure Tf_main.FlipxExecute(Sender: TObject);
begin
if ActiveMdiChild is Tf_chart then with ActiveMdiChild as Tf_chart do FlipxExecute(Sender);
end;

procedure Tf_main.FlipyExecute(Sender: TObject);
begin
if ActiveMdiChild is Tf_chart then with ActiveMdiChild as Tf_chart do FlipyExecute(Sender);
end;

procedure Tf_main.rot_plusExecute(Sender: TObject);
begin
if ActiveMdiChild is Tf_chart then with ActiveMdiChild as Tf_chart do rot_plusExecute(Sender);
end;

procedure Tf_main.rot_minusExecute(Sender: TObject);
begin
if ActiveMdiChild is Tf_chart then with ActiveMdiChild as Tf_chart do rot_minusExecute(Sender);
end;

procedure Tf_main.TelescopeConnectExecute(Sender: TObject);
begin
if ActiveMdiChild is Tf_chart then with ActiveMdiChild as Tf_chart do Connect1Click(Sender);
end;

procedure Tf_main.TelescopeSlewExecute(Sender: TObject);
begin
if ActiveMdiChild is Tf_chart then with ActiveMdiChild as Tf_chart do Slew1Click(Sender);
end;

procedure Tf_main.TelescopeSyncExecute(Sender: TObject);
begin
if ActiveMdiChild is Tf_chart then with ActiveMdiChild as Tf_chart do Sync1Click(Sender);
end;

procedure Tf_main.ListObjExecute(Sender: TObject);
var buf:widestring;
begin
if ActiveMdiChild is Tf_chart then with ActiveMdiChild as Tf_chart do begin
  sc.Findlist(sc.cfgsc.racentre,sc.cfgsc.decentre,sc.cfgsc.fov/2,sc.cfgsc.fov/2/sc.cfgsc.windowratio,buf,false,false,false);
  f_info.Memo1.text:=buf;
  f_info.Memo1.selstart:=0;
  f_info.Memo1.sellength:=0;
  f_info.setpage(1);
  f_info.source_chart:=caption;
  f_info.show;
end;
end;

procedure Tf_main.GridEQExecute(Sender: TObject);
begin
if ActiveMdiChild is Tf_chart then with ActiveMdiChild as Tf_chart do GridEQExecute(Sender);
end;

procedure Tf_main.GridExecute(Sender: TObject);
begin
if ActiveMdiChild is Tf_chart then with ActiveMdiChild as Tf_chart do GridExecute(Sender);
end;

procedure Tf_main.switchstarsExecute(Sender: TObject);
begin
if ActiveMdiChild is Tf_chart then with ActiveMdiChild as Tf_chart do switchstarExecute(Sender);
end;

procedure Tf_main.switchbackgroundExecute(Sender: TObject);
begin
if ActiveMdiChild is Tf_chart then with ActiveMdiChild as Tf_chart do switchbackgroundExecute(Sender);
end;

procedure Tf_main.SetFOVClick(Sender: TObject);
var f : integer;
begin
with Sender as TSpeedButton do f:=tag;
if ActiveMdiChild is Tf_chart then with ActiveMdiChild as Tf_chart do begin
   SetField(deg2rad*sc.catalog.cfgshr.FieldNum[f]);
end;
end;

procedure Tf_main.SetFovExecute(Sender: TObject);
var f : integer;
begin
with Sender as TMenuItem do f:=tag;
if ActiveMdiChild is Tf_chart then with ActiveMdiChild as Tf_chart do begin
   SetField(deg2rad*sc.catalog.cfgshr.FieldNum[f]);
end;
end;

procedure Tf_main.toNExecute(Sender: TObject);
begin
if ActiveMdiChild is Tf_chart then with ActiveMdiChild as Tf_chart do SetAz(deg2rad*180);
end;

procedure Tf_main.toEExecute(Sender: TObject);
begin
if ActiveMdiChild is Tf_chart then with ActiveMdiChild as Tf_chart do SetAz(deg2rad*270);
end;

procedure Tf_main.toSExecute(Sender: TObject);
begin
if ActiveMdiChild is Tf_chart then with ActiveMdiChild as Tf_chart do SetAz(0);
end;

procedure Tf_main.toWExecute(Sender: TObject);
begin
if ActiveMdiChild is Tf_chart then with ActiveMdiChild as Tf_chart do SetAz(deg2rad*90);
end;

procedure Tf_main.toZenithExecute(Sender: TObject);
begin
if ActiveMdiChild is Tf_chart then with ActiveMdiChild as Tf_chart do SetZenit(0);
end;

procedure Tf_main.allSkyExecute(Sender: TObject);
begin
if ActiveMdiChild is Tf_chart then with ActiveMdiChild as Tf_chart do SetZenit(deg2rad*200);
end;


procedure Tf_main.MoreStarExecute(Sender: TObject);
begin
if ActiveMdiChild is Tf_chart then with ActiveMdiChild as Tf_chart do cmd_MoreStar;
end;

procedure Tf_main.LessStarExecute(Sender: TObject);
begin
if ActiveMdiChild is Tf_chart then with ActiveMdiChild as Tf_chart do cmd_LessStar;
end;

procedure Tf_main.MoreNebExecute(Sender: TObject);
begin
if ActiveMdiChild is Tf_chart then with ActiveMdiChild as Tf_chart do cmd_MoreNeb;
end;

procedure Tf_main.LessNebExecute(Sender: TObject);
begin
if ActiveMdiChild is Tf_chart then with ActiveMdiChild as Tf_chart do cmd_LessNeb;
end;

procedure Tf_main.TimeIncExecute(Sender: TObject);
var hh : double;
    y,m,d,h,n,s,mult : integer;
begin
// tag is used for the sign
mult:=TAction(sender).tag*TimeVal.value;
if ActiveMdiChild is Tf_chart then with ActiveMdiChild as Tf_chart do begin
   djd(sc.cfgsc.CurJD,y,m,d,hh);
   DtoS(hh+sc.cfgsc.TimeZone-sc.cfgsc.DT_UT,h,n,s);
   case TimeU.itemindex of
   0 : begin
       inc(h,mult);
       SetDate(y,m,d,h,n,s);
       end;
   1 : begin
       inc(n,mult);
       SetDate(y,m,d,h,n,s);
       end;
   2 : begin
       inc(s,mult);
       SetDate(y,m,d,h,n,s);
       end;
   3 : begin
       inc(d,mult);
       SetDate(y,m,d,h,n,s);
       end;
   4 : begin
       inc(m,mult);
       SetDate(y,m,d,h,n,s);
       end;
   5 : begin
       inc(y,mult);
       SetDate(y,m,d,h,n,s);
       end;
   6 : SetJD(sc.cfgsc.CurJD+(sc.cfgsc.TimeZone)/24+mult*365.25);      // julian year
   7 : SetJD(sc.cfgsc.CurJD+(sc.cfgsc.TimeZone)/24+mult*365.2421988); // tropical year
   8 : SetJD(sc.cfgsc.CurJD+(sc.cfgsc.TimeZone)/24+mult*0.99726956633); // sideral day
   9 : SetJD(sc.cfgsc.CurJD+(sc.cfgsc.TimeZone)/24+mult*29.530589);   // synodic month
   10: SetJD(sc.cfgsc.CurJD+(sc.cfgsc.TimeZone)/24+mult*6585.321);    // saros
   end;
end;
end;

procedure Tf_main.TimeResetExecute(Sender: TObject);
begin
if ActiveMdiChild is Tf_chart then with ActiveMdiChild as Tf_chart do begin
   sc.cfgsc.UseSystemTime:=true;
   if (not sc.cfgsc.TrackOn)and(sc.cfgsc.Projpole=Altaz) then begin
      sc.cfgsc.TrackOn:=true;
      sc.cfgsc.TrackType:=4;
   end;
   Refresh;
end;
end;


procedure Tf_main.ShowStarsExecute(Sender: TObject);
begin
if ActiveMdiChild is Tf_chart then with ActiveMdiChild as Tf_chart do begin
   sc.cfgsc.showstars:=not sc.cfgsc.showstars;
   Refresh;
end;
end;

procedure Tf_main.ShowNebulaeExecute(Sender: TObject);
begin
if ActiveMdiChild is Tf_chart then with ActiveMdiChild as Tf_chart do begin
   sc.cfgsc.shownebulae:=not sc.cfgsc.shownebulae;
   Refresh;
end;
end;

procedure Tf_main.ShowPicturesExecute(Sender: TObject);
begin
if ActiveMdiChild is Tf_chart then with ActiveMdiChild as Tf_chart do begin
   sc.cfgsc.ShowImages:=not sc.cfgsc.ShowImages;
   if sc.cfgsc.ShowImages and (not Fits.dbconnected) then begin
      sc.cfgsc.ShowImages:=false;
      showmessage('Error! Please check the database parameters and load the picture package.');
   end;
   Refresh;
end;
end;

procedure Tf_main.ShowBackgroundImageExecute(Sender: TObject);
begin
if ActiveMdiChild is Tf_chart then with ActiveMdiChild as Tf_chart do begin
   sc.cfgsc.ShowBackgroundImage:=not sc.cfgsc.ShowBackgroundImage;
   if sc.cfgsc.ShowBackgroundImage and (not Fits.dbconnected) then begin
      sc.cfgsc.ShowBackgroundImage:=false;
      showmessage('Error! Please check the database parameters.');
   end;
   Refresh;
end;
end;


procedure Tf_main.DSSImageExecute(Sender: TObject);

begin
if (ActiveMdiChild is Tf_chart) and (Fits.dbconnected)
  then with ActiveMdiChild as Tf_chart do begin
   if f_getdss.GetDss(sc.cfgsc.racentre,sc.cfgsc.decentre,sc.cfgsc.fov,sc.cfgsc.windowratio) then begin
      sc.Fits.Filename:=expandfilename(f_getdss.cfgdss.dssfile);
      if sc.Fits.Header.valid then begin
         sc.Fits.DeleteDB('OTHER','BKG');
         if not sc.Fits.InsertDB(sc.Fits.Filename,'OTHER','BKG',sc.Fits.Center_RA,sc.Fits.Center_DE,sc.Fits.Img_Width,sc.Fits.Img_Height,sc.Fits.Rotation) then
                sc.Fits.InsertDB(sc.Fits.Filename,'OTHER','BKG',sc.Fits.Center_RA+0.00001,sc.Fits.Center_DE+0.00001,sc.Fits.Img_Width,sc.Fits.Img_Height,sc.Fits.Rotation);
         sc.cfgsc.TrackOn:=true;
         sc.cfgsc.TrackType:=5;
         sc.cfgsc.BackgroundImage:=sc.Fits.Filename;
         sc.cfgsc.ShowBackgroundImage:=true;
         Refresh;
      end;
   end;
end;
end;


procedure Tf_main.SyncChartExecute(Sender: TObject);
begin
if ActiveMdiChild is Tf_chart then with ActiveMdiChild as Tf_chart do begin
   cfgm.SyncChart:=not cfgm.SyncChart;
   if cfgm.SyncChart then SyncChild;
end;
end;

procedure Tf_main.ShowLinesExecute(Sender: TObject);
begin
if ActiveMdiChild is Tf_chart then with ActiveMdiChild as Tf_chart do begin
   sc.cfgsc.ShowLine:=not sc.cfgsc.ShowLine;
   Refresh;
end;
end;

procedure Tf_main.ShowPlanetsExecute(Sender: TObject);
begin
if ActiveMdiChild is Tf_chart then with ActiveMdiChild as Tf_chart do begin
   sc.cfgsc.ShowPlanet:=not sc.cfgsc.ShowPlanet;
   Refresh;
end;
end;

procedure Tf_main.ShowAsteroidsExecute(Sender: TObject);
var showast:boolean;
begin
if ActiveMdiChild is Tf_chart then with ActiveMdiChild as Tf_chart do begin
   sc.cfgsc.ShowAsteroid:=not sc.cfgsc.ShowAsteroid;
   showast:=sc.cfgsc.ShowAsteroid;
   Refresh;
   if showast<>sc.cfgsc.ShowAsteroid then begin
      f_info.setpage(2);
      f_info.show;
      f_info.ProgressMemo.lines.add('Compute asteroid data for this month');
      if Planet.PrepareAsteroid(sc.cfgsc.curjd, f_info.ProgressMemo.lines) then begin
         sc.cfgsc.ShowAsteroid:=true;
         Refresh;
      end;
      f_info.close;
   end;
end;
end;

procedure Tf_main.ShowCometsExecute(Sender: TObject);
var showcom:boolean;
begin
if ActiveMdiChild is Tf_chart then with ActiveMdiChild as Tf_chart do begin
   sc.cfgsc.ShowComet:=not sc.cfgsc.ShowComet;
   showcom:=sc.cfgsc.ShowComet;
   Refresh;
   if showcom<>sc.cfgsc.ShowComet then showmessage('Error! Please check the database parameters and load the comete data file.');
end;
end;

procedure Tf_main.ShowMilkyWayExecute(Sender: TObject);
begin
if ActiveMdiChild is Tf_chart then with ActiveMdiChild as Tf_chart do begin
   sc.cfgsc.ShowMilkyWay:=not sc.cfgsc.ShowMilkyWay;
   Refresh;
end;
end;

procedure Tf_main.ShowLabelsExecute(Sender: TObject);
begin
if ActiveMdiChild is Tf_chart then with ActiveMdiChild as Tf_chart do begin
   sc.cfgsc.Showlabelall:=not sc.cfgsc.Showlabelall;
   Refresh;
end;
end;

procedure Tf_main.EditLabelsExecute(Sender: TObject);
begin
if ActiveMdiChild is Tf_chart then with ActiveMdiChild as Tf_chart do begin
   sc.cfgsc.Editlabels:=not sc.cfgsc.Editlabels;
   Refresh;
end;
end;

procedure Tf_main.ShowConstellationLineExecute(Sender: TObject);
begin
if ActiveMdiChild is Tf_chart then with ActiveMdiChild as Tf_chart do begin
   sc.cfgsc.ShowConstl:=not sc.cfgsc.ShowConstl;
   Refresh;
end;
end;

procedure Tf_main.ShowConstellationLimitExecute(Sender: TObject);
begin
if ActiveMdiChild is Tf_chart then with ActiveMdiChild as Tf_chart do begin
   sc.cfgsc.ShowConstB:=not sc.cfgsc.ShowConstB;
   Refresh;
end;
end;

procedure Tf_main.ShowGalacticEquatorExecute(Sender: TObject);
begin
if ActiveMdiChild is Tf_chart then with ActiveMdiChild as Tf_chart do begin
   sc.cfgsc.ShowGalactic:=not sc.cfgsc.ShowGalactic;
   Refresh;
end;
end;

procedure Tf_main.ShowEclipticExecute(Sender: TObject);
begin
if ActiveMdiChild is Tf_chart then with ActiveMdiChild as Tf_chart do begin
   sc.cfgsc.ShowEcliptic:=not sc.cfgsc.ShowEcliptic;
   Refresh;
end;
end;

procedure Tf_main.ShowMarkExecute(Sender: TObject);
begin
if ActiveMdiChild is Tf_chart then with ActiveMdiChild as Tf_chart do begin
   sc.cfgsc.ShowCircle:=not sc.cfgsc.ShowCircle;
   Refresh;
end;
end;

procedure Tf_main.ShowObjectbelowHorizonExecute(Sender: TObject);
begin
if ActiveMdiChild is Tf_chart then with ActiveMdiChild as Tf_chart do begin
   sc.cfgsc.horizonopaque:=not sc.cfgsc.horizonopaque;
   Refresh;
end;
end;

procedure Tf_main.StarSizeChange(Sender: TObject);
begin
if ActiveMdiChild is Tf_chart then with ActiveMdiChild as Tf_chart do begin
  case Ttrackbar(sender).tag of
    1: sc.plot.cfgplot.partsize:=trackbar1.position/10;
    2: sc.plot.cfgplot.magsize:=trackbar2.position/10;
    3: sc.plot.cfgplot.contrast:=trackbar3.position;
    4: sc.plot.cfgplot.saturation:=trackbar4.position;
  end;
  RefreshTimer.Interval:=1000;
  RefreshTimer.Enabled:=false;
  RefreshTimer.Enabled:=true;
end;  
end;

procedure Tf_main.EquatorialProjectionExecute(Sender: TObject);
begin
if ActiveMdiChild is Tf_chart then with ActiveMdiChild as Tf_chart do begin
   sc.cfgsc.projpole:=Equat;
   sc.cfgsc.FindOk:=false; // invalidate the search result
   sc.cfgsc.theta:=0; // rotation = 0
   Refresh;
end;
end;

procedure Tf_main.AltAzProjectionExecute(Sender: TObject);
begin
if ActiveMdiChild is Tf_chart then with ActiveMdiChild as Tf_chart do begin
   sc.cfgsc.projpole:=AltAz;
   sc.cfgsc.FindOk:=false; // invalidate the search result
   sc.cfgsc.theta:=0; // rotation = 0
   Refresh;
end;
end;

procedure Tf_main.EclipticProjectionExecute(Sender: TObject);
begin
if ActiveMdiChild is Tf_chart then with ActiveMdiChild as Tf_chart do begin
   sc.cfgsc.projpole:=Ecl;
   sc.cfgsc.FindOk:=false; // invalidate the search result
   sc.cfgsc.theta:=0; // rotation = 0
   Refresh;
end;
end;

procedure Tf_main.GalacticProjectionExecute(Sender: TObject);
begin
if ActiveMdiChild is Tf_chart then with ActiveMdiChild as Tf_chart do begin
   sc.cfgsc.projpole:=Gal;
   sc.cfgsc.FindOk:=false; // invalidate the search result
   sc.cfgsc.theta:=0; // rotation = 0
   Refresh;
end;
end;

procedure Tf_main.CalendarExecute(Sender: TObject);
begin
  if ActiveMdiChild is Tf_chart then f_calendar.config:= Tf_chart(ActiveMdiChild).sc.cfgsc
     else f_calendar.config:=def_cfgsc;
  formpos(f_calendar,mouse.cursorpos.x,mouse.cursorpos.y);
  f_calendar.show;
end;

procedure Tf_main.TrackExecute(Sender: TObject);
begin
if ActiveMDIChild is Tf_chart then with (ActiveMDIChild as Tf_chart) do begin
  if sc.cfgsc.TrackOn then begin
     sc.cfgsc.TrackOn:=false;
     Refresh;
  end else if ((sc.cfgsc.TrackType>=1)and(sc.cfgsc.TrackType<=3))or(sc.cfgsc.TrackType=6)
  then begin
     sc.cfgsc.TrackOn:=true;
     Refresh;
  end;
end;
end;
        
procedure Tf_main.PositionExecute(Sender: TObject);
begin
if ActiveMdiChild is Tf_chart then with ActiveMdiChild as Tf_chart do begin
   f_position.cfgsc:=sc.cfgsc;
   f_position.AzNorth:=sc.catalog.cfgshr.AzNorth;
   formpos(f_position,mouse.cursorpos.x,mouse.cursorpos.y);
   f_position.showmodal;
   if f_position.modalresult=mrOK then begin
      if sc.cfgsc.Projpole=Altaz then begin
         sc.cfgsc.TrackOn:=true;
         sc.cfgsc.TrackType:=4;
         sc.cfgsc.acentre:=deg2rad*f_position.long.value;
         if sc.catalog.cfgshr.AzNorth then sc.cfgsc.acentre:=rmod(sc.cfgsc.acentre+pi,pi2);
         sc.cfgsc.hcentre:=deg2rad*f_position.lat.value;
      end
         else sc.cfgsc.TrackOn:=false;
      sc.cfgsc.racentre:=15*deg2rad*f_position.ra.value;
      sc.cfgsc.decentre:=deg2rad*f_position.de.value;
      sc.cfgsc.fov:=deg2rad*f_position.fov.value;
      sc.cfgsc.theta:=deg2rad*f_position.rot.value;
      refresh;
   end;
end;
end;

procedure Tf_main.Search1Execute(Sender: TObject);
var ok: Boolean;
    ar1,de1 : Double;
    i : integer;
    chart:TForm;
begin
chart:=nil; ok:=false;
if ActiveMdiChild is Tf_chart then chart:=ActiveMdiChild
 else
 for i:=0 to MDIChildCount-1 do
   if MDIChildren[i] is Tf_chart then begin
      chart:=MDIChildren[i];
      break;
   end;
if chart is Tf_chart then with chart as Tf_chart do begin
   formpos(f_search,mouse.cursorpos.x,mouse.cursorpos.y);
   repeat
   f_search.showmodal;
   if f_search.modalresult=mrOk then begin
      case f_search.SearchKind of
      0  : ok:=catalog.SearchNebulae(f_search.Num,ar1,de1) ;
      1  : begin
           ar1:=f_search.ra;
           de1:=f_search.de;
           ok:=true;
           end;
      2  : ok:=catalog.SearchStar(f_search.Num,ar1,de1) ;
      3  : ok:=catalog.SearchStar(f_search.Num,ar1,de1) ;
      4  : ok:=catalog.SearchVarStar(f_search.Num,ar1,de1) ;
      5  : ok:=catalog.SearchDblStar(f_search.Num,ar1,de1) ;
      6  : ok:=planet.FindCometName(trim(f_search.Num),ar1,de1,sc.cfgsc);
      7  : ok:=planet.FindAsteroidName(trim(f_search.Num),ar1,de1,sc.cfgsc);
      8  : ok:=planet.FindPlanetName(trim(f_search.Num),ar1,de1,sc.cfgsc);
      9  : ok:=catalog.SearchConstellation(f_search.Num,ar1,de1);
      10 : ok:=catalog.SearchLines(f_search.Num,ar1,de1) ;
      else ok:=false;
      end;
      if ok then begin
        sc.cfgsc.TrackOn:=false;
        IdentLabel.visible:=false;
        precession(jd2000,sc.cfgsc.JDchart,ar1,de1);
        sc.movetoradec(ar1,de1);
        Refresh;
        if sc.cfgsc.fov>0.17 then sc.FindatRaDec(ar1,de1,0.0005,true)
                             else sc.FindatRaDec(ar1,de1,0.00005,true);
        ShowIdentLabel;
        f_main.SetLpanel1(wordspace(sc.cfgsc.FindDesc),caption);
        if f_search.SearchKind in [0,2,3,4,5,8] then begin
          i:=quicksearch.Items.IndexOf(f_search.Num);
          if i=-1 then i:=MaxQuickSearch-1;
          quicksearch.Items.Delete(i);
          quicksearch.Items.Insert(0,f_search.Num);
          quicksearch.ItemIndex:=0;
        end;
      end
      else begin
        ShowMessage(f_search.Num+' Not found!'+crlf+'Maybe the catalog is not installed, or wrong path in catalog setting.' );
      end;
   end;
   until ok or (f_search.ModalResult<>mrOk);
end;
end;

procedure Tf_main.GetChartConfig(var csc:conf_skychart);
begin
if ActiveMdiChild is Tf_chart then with ActiveMdiChild as Tf_chart do
   csc:=sc.cfgsc
else csc:=def_cfgsc;
end;

procedure Tf_main.DrawChart(var csc:conf_skychart);
begin
if ActiveMdiChild is Tf_chart then with ActiveMdiChild as Tf_chart do begin
   sc.cfgsc:=csc;
   Refresh;
end;
end;

procedure Tf_main.OpenConfigExecute(Sender: TObject);
begin
screen.cursor:=crHourGlass;
if f_config=nil then begin
   f_config:=Tf_config.Create(application);
   f_config.onApplyConfig:=ApplyConfig;
   f_config.onDBChange:=ConfigDBChange;
   f_config.onSaveAndRestart:=SaveAndRestart;
   f_config.onPrepareAsteroid:=PrepareAsteroid;
   f_config.Fits:=fits;
   f_config.catalog:=catalog;
   f_config.db:=cdcdb;
   {$ifdef linux}
     if nightvision then begin
        f_config.Color:=dark;
        f_config.font.Color:=middle;
     end;
   {$endif}
end;
try
 f_config.ccat:=catalog.cfgcat;
 f_config.cshr:=catalog.cfgshr;
 f_config.cplot:=def_cfgplot;
 f_config.csc:=def_cfgsc;
 if ActiveMdiChild is Tf_chart then with ActiveMdiChild as Tf_chart do begin
     f_config.csc:=sc.cfgsc;
     f_config.cplot:=sc.plot.cfgplot;
 end;
 cfgm.prgdir:=appdir;
 cfgm.persdir:=privatedir;
 f_config.cmain:=cfgm;
 f_config.cdss:=f_getdss.cfgdss;
 f_config.applyall.checked:=cfgm.updall;
 formpos(f_config,mouse.cursorpos.x,mouse.cursorpos.y);
 f_config.TreeView1.enabled:=true;
 f_config.previous.enabled:=true;
 f_config.next.enabled:=true;
 f_config.showmodal;
 if f_config.ModalResult=mrOK then begin
   activateconfig;
 end;
 cfgm.configpage:=f_config.Treeview1.selected.absoluteindex;
finally
screen.cursor:=crDefault;
end;
end;

function Tf_main.PrepareAsteroid(jdt:double; msg:Tstrings):boolean;
begin
 result:=planet.PrepareAsteroid(jdt,msg);
end;

procedure Tf_main.ApplyConfig(Sender: TObject);
begin
 activateconfig;
end;

procedure Tf_main.ConfigDBChange(Sender: TObject);
begin
cfgm.dbhost:=f_config.cmain.dbhost;
cfgm.db:=f_config.cmain.db;
cfgm.dbuser:=f_config.cmain.dbuser;
cfgm.dbpass:=f_config.cmain.dbpass;
cfgm.dbport:=f_config.cmain.dbport;
ConnectDB;
end;

procedure Tf_main.SaveAndRestart(Sender: TObject);
begin
cfgm:=f_config.cmain;
if directoryexists(cfgm.prgdir) then appdir:=cfgm.prgdir;
if directoryexists(cfgm.persdir) then privatedir:=cfgm.persdir;
def_cfgsc:=f_config.csc;
catalog.cfgcat:=f_config.ccat;
catalog.cfgshr:=f_config.cshr;
SavePrivateConfig(configfile);
NeedRestart:=true;
Close;
end;

procedure Tf_main.activateconfig;
var i:integer;
begin
    cfgm:=f_config.cmain;
    cfgm.updall:=f_config.applyall.checked;
    if directoryexists(cfgm.prgdir) then appdir:=cfgm.prgdir;
    if directoryexists(cfgm.persdir) then privatedir:=cfgm.persdir;
    for i:=0 to f_config.ccat.GCatNum-1 do begin
    if f_config.ccat.GCatLst[i].Actif then begin
      if not
      catalog.GetInfo(f_config.ccat.GCatLst[i].path,
                      f_config.ccat.GCatLst[i].shortname,
                      f_config.ccat.GCatLst[i].magmax,
                      f_config.ccat.GCatLst[i].cattype,
                      f_config.ccat.GCatLst[i].version,
                      f_config.ccat.GCatLst[i].name)
      then f_config.ccat.GCatLst[i].Actif:=false;
    end;
    end;
    f_getdss.cfgdss:=f_config.cdss;
    catalog.cfgcat:=f_config.ccat;
    catalog.cfgshr:=f_config.cshr;
    def_cfgsc:=f_config.csc;
    def_cfgplot:=f_config.cplot;
    def_cfgplot.starshapesize:=starshape.Picture.bitmap.Width div 11;
    def_cfgplot.starshapew:=def_cfgplot.starshapesize div 2;
    InitFonts;
    catalog.LoadConstellation(cfgm.Constellationfile);
    catalog.LoadConstL(cfgm.ConstLfile);
    catalog.LoadConstB(cfgm.ConstBfile);
    catalog.LoadHorizon(cfgm.horizonfile,def_cfgsc);
    ConnectDB;
    Fits.min_sigma:=cfgm.ImageLuminosity;
    Fits.max_sigma:=cfgm.ImageContrast;
    {$ifdef mswindows}
    if (telescope.scopelibok)and(def_cfgsc.IndiTelescope) then begin
       telescope.ScopeDisconnect;
       telescope.UnloadScopeLibrary;
    end;
    if (telescope.scopelibok)and(not def_cfgsc.IndiTelescope)and(def_cfgsc.ScopePlugin<>telescope.plugin) then begin
       telescope.ScopeDisconnect;
       telescope.UnloadScopeLibrary;
    end;
    telescope.plugin:=def_cfgsc.ScopePlugin;
    {$endif}
    if ActiveMdiChild is Tf_chart then with ActiveMdiChild as Tf_chart do begin
       CopySCconfig(def_cfgsc,sc.cfgsc);
       sc.Fits:=Fits;
       sc.planet:=planet;
       sc.cdb:=cdcdb;
       sc.cfgsc.FindOk:=false;
       if cfgm.NewBackgroundImage then begin
          sc.Fits.Filename:=sc.cfgsc.BackgroundImage;
          if sc.Fits.Header.valid then begin
            sc.Fits.DeleteDB('OTHER','BKG');
            if not sc.Fits.InsertDB(sc.cfgsc.BackgroundImage,'OTHER','BKG',sc.Fits.Center_RA,sc.Fits.Center_DE,sc.Fits.Img_Width,sc.Fits.Img_Height,sc.Fits.Rotation) then
               sc.Fits.InsertDB(sc.cfgsc.BackgroundImage,'OTHER','BKG',sc.Fits.Center_RA+0.00001,sc.Fits.Center_DE+0.00001,sc.Fits.Img_Width,sc.Fits.Img_Height,sc.Fits.Rotation);
            sc.cfgsc.TrackOn:=true;
            sc.cfgsc.TrackType:=5;
          end;
          cfgm.NewBackgroundImage:=false;
       end;
    end;
    cfgm.NewBackgroundImage:=false;
    RefreshAllChild(cfgm.updall);
    Autorefresh.enabled:=false;
    Autorefresh.Interval:=cfgm.autorefreshdelay*1000;
    Autorefresh.enabled:=true;
end;

procedure Tf_main.ViewTopPanel;
var i: integer;
begin
i:=0;
if ToolBar1.visible then i:=i+ToolBar1.Height;
if ToolBar4.visible then i:=i+ToolBar4.Height;
if i=0 then PanelTop.visible:=false
   else begin
     PanelTop.visible:=true;
     PanelTop.Height:=i+2;
   end;  
end;

procedure Tf_main.ViewBarExecute(Sender: TObject);
begin
ToolBar1.visible:=not ViewToolsBar1.checked;
PanelLeft.visible:=ToolBar1.visible;
PanelRight.visible:=ToolBar1.visible;
ToolBar4.visible:=ToolBar1.visible;
PanelBottom.visible:=ToolBar1.visible;
ViewToolsBar1.checked:=ToolBar1.visible;
MainBar1.checked:=ToolBar1.visible;
ObjectBar1.checked:=ToolBar1.visible;
LeftBar1.checked:=ToolBar1.visible;
RightBar1.checked:=ToolBar1.visible;
ViewStatusBar1.checked:=ToolBar1.visible;
ViewTopPanel;
end;

procedure Tf_main.ViewMainBarExecute(Sender: TObject);
begin
ToolBar1.visible:=not ToolBar1.visible;
MainBar1.checked:=ToolBar1.visible;
if not MainBar1.checked then ViewToolsBar1.checked:=false;
if MainBar1.checked and ObjectBar1.checked and LeftBar1.checked and RightBar1.checked and ViewStatusBar1.checked then ViewToolsBar1.checked:=true;
ViewTopPanel;
end;

procedure Tf_main.ViewObjectBarExecute(Sender: TObject);
begin
ToolBar4.visible:=not ToolBar4.visible;
ObjectBar1.checked:=ToolBar4.visible;
if not ObjectBar1.checked then ViewToolsBar1.checked:=false;
if MainBar1.checked and ObjectBar1.checked and LeftBar1.checked and RightBar1.checked and ViewStatusBar1.checked then ViewToolsBar1.checked:=true;
ViewTopPanel;
end;

procedure Tf_main.ViewLeftBarExecute(Sender: TObject);
begin
PanelLeft.visible:=not PanelLeft.visible;
LeftBar1.checked:=PanelLeft.visible;
if not LeftBar1.checked then ViewToolsBar1.checked:=false;
if MainBar1.checked and ObjectBar1.checked and LeftBar1.checked and RightBar1.checked and ViewStatusBar1.checked then ViewToolsBar1.checked:=true;
end;

procedure Tf_main.ViewRightBarExecute(Sender: TObject);
begin
PanelRight.visible:=not PanelRight.visible;
RightBar1.checked:=PanelRight.visible;
if not RightBar1.checked then ViewToolsBar1.checked:=false;
if MainBar1.checked and ObjectBar1.checked and LeftBar1.checked and RightBar1.checked and ViewStatusBar1.checked then ViewToolsBar1.checked:=true;
end;

procedure Tf_main.ViewStatusExecute(Sender: TObject);
begin
PanelBottom.visible:=not PanelBottom.visible;
ViewStatusBar1.checked:=PanelBottom.visible;
if not ViewStatusBar1.checked then ViewToolsBar1.checked:=false;
if MainBar1.checked and ObjectBar1.checked and LeftBar1.checked and RightBar1.checked and ViewStatusBar1.checked then ViewToolsBar1.checked:=true;
end;

Procedure Tf_main.InitFonts;
begin
   font.name:=def_cfgplot.fontname[4];
   font.size:=def_cfgplot.fontsize[4];
   if def_cfgplot.FontBold[4] then font.style:=[fsBold] else font.style:=[];
   if def_cfgplot.FontItalic[4] then font.style:=font.style+[fsItalic];
   LPanels0.Caption:='Ra:22h22m22.22s +22�22''22"22';
   Ppanels0.ClientWidth:=LPanels0.width+8;
   Ppanels0.ClientHeight:=2*LPanels0.Height+2;
   Lpanels0.Caption:='';
   Ppanels1.left:=Ppanels0.left+Ppanels0.width;
   Ppanels1.width:=PanelBottom.ClientWidth-Ppanels1.left;
   Ppanels1.height:=Ppanels0.height;
   PanelBottom.height:=Ppanels0.height+1;
end;

Procedure Tf_main.SetLPanel1(txt:string; origin:string='';sendmsg:boolean=true;Sender: TObject=nil);
begin
LPanels1.width:=PPanels1.ClientWidth;
LPanels1.Caption:=stringreplace(txt,tab,' ',[rfReplaceall]);
PPanels1.refresh;
if sendmsg then SendInfo(Sender,origin,txt);
if traceon then writetrace(txt);
// refresh tracking object
if ActiveMDIChild is Tf_chart then with (ActiveMDIChild as Tf_chart) do begin
    if sc.cfgsc.TrackOn then
       ToolButtonTrack.Hint:='Unlock Chart'
     else if ((sc.cfgsc.TrackType>=1)and(sc.cfgsc.TrackType<=3))or(sc.cfgsc.TrackType=6)
     then
       ToolButtonTrack.Hint:='Lock on '+sc.cfgsc.Trackname
     else
       ToolButtonTrack.Hint:='No object to lock on';
end;
end;

Procedure Tf_main.SetLPanel0(txt:string);
begin
LPanels0.Caption:=txt;
LPanels0.refresh;
end;

Procedure Tf_main.SetTopMessage(txt:string);
begin
// set the message that appear in the menu bar
topmsg:=txt;
if cfgm.ShowChartInfo then topmessage.caption:=topmsg
   else topmessage.caption:='';
end;

procedure Tf_main.FormResize(Sender: TObject);
begin
   Ppanels1.width:=PanelBottom.ClientWidth-Ppanels1.left;
end;

procedure Tf_main.SetDefault;
var i:integer;
begin
nightvision:=false;
ButtonImage:=1;
ldeg:='�';
lmin:='''';
lsec:='"';
cfgm.MaxChildID:=0;
cfgm.language:='UK';
cfgm.prtname:='';
cfgm.configpage:=0;
cfgm.PrinterResolution:=150;
cfgm.PrintColor:=0;
cfgm.PrintLandscape:=true;
cfgm.PrintMethod:=0;
cfgm.PrintCmd1:=DefaultPrintCmd1;
cfgm.PrintCmd2:=DefaultPrintCmd2;
cfgm.PrintTmpPath:=expandfilename(TempDir);
cfgm.maximized:=true;
cfgm.updall:=true;
cfgm.AutoRefreshDelay:=60;
cfgm.ServerIPaddr:='127.0.0.1';
cfgm.ServerIPport:='3292'; // x'CDC' :o)
cfgm.keepalive:=false;
cfgm.AutostartServer:=true;
cfgm.dbhost:='localhost';
cfgm.dbport:=3306;
cfgm.db:=slash(privatedir)+StringReplace(defaultSqliteDB,'/',PathDelim,[rfReplaceAll]);
cfgm.dbuser:='root';
cfgm.dbpass:='';
cfgm.ImagePath:=slash(appDir)+slash('data')+slash('pictures');
cfgm.ImageLuminosity:=0;
cfgm.ImageContrast:=0;
cfgm.ShowChartInfo:=false;
cfgm.SyncChart:=false;
for i:=1 to numfont do begin
   def_cfgplot.FontName[i]:=DefaultFontName;
   def_cfgplot.FontSize[i]:=DefaultFontSize;
   def_cfgplot.FontBold[i]:=false;
   def_cfgplot.FontItalic[i]:=false;
end;
def_cfgplot.FontName[7]:=DefaultFontSymbol;
for i:=1 to numlabtype do begin
   def_cfgplot.LabelColor[i]:=clWhite;
   def_cfgplot.LabelSize[i]:=DefaultFontSize;
   def_cfgsc.LabelMagDiff[i]:=4;
   def_cfgsc.ShowLabel[i]:=true;
end;
def_cfgsc.LabelMagDiff[1]:=3;
def_cfgsc.LabelMagDiff[5]:=2;
def_cfgplot.LabelColor[6]:=clYellow;
def_cfgplot.LabelSize[6]:=12;
def_cfgplot.contrast:=400;
def_cfgplot.partsize:=1.2;
def_cfgplot.magsize:=4;
def_cfgplot.saturation:=192;
cfgm.Constellationfile:=slash(appdir)+'data'+Pathdelim+'constellation'+Pathdelim+'constlabel.cla';
cfgm.ConstLfile:=slash(appdir)+'data'+Pathdelim+'constellation'+Pathdelim+'DefaultConstL.cln';
cfgm.ConstBfile:=slash(appdir)+'data'+Pathdelim+'constellation'+Pathdelim+'constb.cby';
cfgm.EarthMapFile:=slash(appdir)+'data'+Pathdelim+'earthmap'+Pathdelim+'earthmap1k.jpg';
cfgm.PlanetDir:=slash(appdir)+'data'+Pathdelim+'planet';
cfgm.horizonfile:='';
def_cfgplot.invisible:=false;
def_cfgplot.color:=dfColor;
def_cfgplot.skycolor:=dfSkyColor;
def_cfgplot.bgColor:=dfColor[0];
def_cfgplot.backgroundcolor:=def_cfgplot.color[0];
def_cfgplot.Nebgray:=55;
def_cfgplot.NebBright:=180;
def_cfgplot.stardyn:=65;
def_cfgplot.starsize:=13;
def_cfgplot.starplot:=2;
def_cfgplot.nebplot:=1;
def_cfgplot.plaplot:=1;
def_cfgplot.AutoSkycolor:=false;
def_cfgsc.winx:=clientwidth;
def_cfgsc.winy:=clientheight;
def_cfgsc.UseSystemTime:=true;
def_cfgsc.AutoRefresh:=false;
def_cfgsc.JDchart:=jd2000;
def_cfgsc.LastJDchart:=-1E25;
def_cfgsc.racentre:=1.4;
def_cfgsc.decentre:=0;
def_cfgsc.fov:=deg2rad*90;
def_cfgsc.theta:=0;
def_cfgsc.projtype:='A';
def_cfgsc.ProjPole:=AltAz;
def_cfgsc.acentre:=0;
def_cfgsc.hcentre:=deg2rad*28;
def_cfgsc.FlipX:=1;
def_cfgsc.FlipY:=1;
def_cfgsc.WindowRatio:=1;
def_cfgsc.BxGlb:=1;
def_cfgsc.ByGlb:=1;
def_cfgsc.AxGlb:=0;
def_cfgsc.AyGlb:=0;
def_cfgsc.xmin:=0;
def_cfgsc.xmax:=100;
def_cfgsc.ymin:=0;
def_cfgsc.ymax:=100;
def_cfgsc.ObsLatitude := 46.2 ;
def_cfgsc.ObsLongitude := -6.1 ;
def_cfgsc.ObsAltitude := 0 ;
def_cfgsc.ObsTZ := GetTimezone ;
def_cfgsc.ObsTemperature := 10 ;
def_cfgsc.ObsPressure := 1010 ;
def_cfgsc.ObsName := 'Gen�ve' ;
def_cfgsc.ObsCountry := 'Switzerland' ;
def_cfgsc.horizonopaque:=true;
def_cfgsc.ShowHorizon:=false;
def_cfgsc.ShowHorizonDepression:=false;
def_cfgsc.HorizonMax:=0;
def_cfgsc.PMon:=false;
def_cfgsc.DrawPMon:=false;
def_cfgsc.DrawPMyear:=1000;
def_cfgsc.ApparentPos:=false;
def_cfgsc.ShowEqGrid:=false;
def_cfgsc.ShowGrid:=true;
def_cfgsc.ShowGridNum:=true;
def_cfgsc.ShowConstL:=true;
def_cfgsc.ShowConstB:=false;
def_cfgsc.ShowEcliptic:=false;                  
def_cfgsc.ShowGalactic:=false;
def_cfgsc.ShowMilkyWay:=true;
def_cfgsc.FillMilkyWay:=true;
def_cfgsc.showstars:=true;
def_cfgsc.shownebulae:=true;
def_cfgsc.showline:=true;
def_cfgsc.showlabelall:=true;
def_cfgsc.Editlabels:=false;
def_cfgsc.Simnb:=1;
def_cfgsc.SimD:=1;
def_cfgsc.SimH:=0;
def_cfgsc.SimM:=0;
def_cfgsc.SimS:=0;
def_cfgsc.SimLine:=True;
for i:=1 to NumSimObject do def_cfgsc.SimObject[i]:=true;
def_cfgsc.ShowPlanet:=true;
def_cfgsc.ShowAsteroid:=true;
def_cfgsc.ShowImages:=true;
def_cfgsc.ShowBackgroundImage:=false;
def_cfgsc.BackgroundImage:='';
def_cfgsc.AstSymbol:=0;
def_cfgsc.AstmagMax:=18;
def_cfgsc.AstmagDiff:=6;
def_cfgsc.ShowComet:=true;
def_cfgsc.ComSymbol:=1;
def_cfgsc.CommagMax:=18;
def_cfgsc.CommagDiff:=4;
def_cfgsc.MagLabel:=false;
def_cfgsc.NameLabel:=false;
def_cfgsc.ConstFullLabel:=true;
def_cfgsc.PlanetParalaxe:=true;
def_cfgsc.ShowEarthShadow:=false;
def_cfgsc.GRSlongitude:=92;
def_cfgsc.LabelOrientation:=1;
def_cfgsc.FindOk:=false;
def_cfgsc.nummodlabels:=0;
for i:=1 to 10 do def_cfgsc.circle[i,1]:=0;
for i:=1 to 10 do def_cfgsc.circle[i,2]:=0;
for i:=1 to 10 do def_cfgsc.circle[i,3]:=0;
for i:=1 to 10 do def_cfgsc.circleok[i]:=false;
for i:=1 to 10 do def_cfgsc.circlelbl[i]:='';
for i:=1 to 10 do def_cfgsc.rectangle[i,1]:=0;
for i:=1 to 10 do def_cfgsc.rectangle[i,2]:=0;
for i:=1 to 10 do def_cfgsc.rectangle[i,3]:=0;
for i:=1 to 10 do def_cfgsc.rectangle[i,4]:=0;
for i:=1 to 10 do def_cfgsc.rectangleok[i]:=false;
for i:=1 to 10 do def_cfgsc.rectanglelbl[i]:='';
def_cfgsc.circle[1,1]:=240;
def_cfgsc.circle[2,1]:=120;
def_cfgsc.circle[3,1]:=30;
def_cfgsc.circleok[1]:=true;
def_cfgsc.circleok[2]:=true;
def_cfgsc.circleok[3]:=true;
def_cfgsc.circlelbl[1]:='Telrad';
def_cfgsc.circle[4,1]:=18;
def_cfgsc.circle[4,2]:=45;
def_cfgsc.circle[4,3]:=30;
def_cfgsc.circlelbl[4]:='Off-Axis guider';
def_cfgsc.circle[5,1]:=26.5;
def_cfgsc.circle[6,1]:=17.5;
def_cfgsc.circlelbl[5]:='ST7 autoguider area';
def_cfgsc.circlelbl[6]:='ST7 autoguider area';
def_cfgsc.rectangle[1,1]:=11.8;
def_cfgsc.rectangle[1,2]:=7.9;
def_cfgsc.rectangleok[1]:=true;
def_cfgsc.rectanglelbl[1]:='KAF400 prime focus';
def_cfgsc.rectangle[2,1]:=4.5;
def_cfgsc.rectangle[2,2]:=4.5;
def_cfgsc.rectangle[2,4]:=11;
def_cfgsc.rectangleok[2]:=true;
def_cfgsc.rectanglelbl[2]:='ST7 autoguider';
def_cfgsc.NumCircle:=0;
def_cfgsc.IndiAutostart:=true;
def_cfgsc.IndiServerHost:='localhost';
def_cfgsc.IndiServerPort:='7624';
def_cfgsc.IndiServerCmd:='indiserver';
def_cfgsc.IndiDriver:='lx200generic';
def_cfgsc.IndiPort:='/dev/ttyS0';
def_cfgsc.IndiDevice:='LX200 Generic';
def_cfgsc.IndiTelescope:=false;
def_cfgsc.ScopePlugin:='Ascom.tid';
catalog.cfgshr.ListStar:=false;
catalog.cfgshr.ListNeb:=true;
catalog.cfgshr.ListVar:=true;
catalog.cfgshr.ListDbl:=true;
catalog.cfgshr.ListPla:=true;
catalog.cfgshr.AzNorth:=true;
catalog.cfgshr.EquinoxType:=0;
catalog.cfgshr.EquinoxChart:='J2000';
catalog.cfgshr.DefaultJDchart:=jd2000;
catalog.cfgshr.StarFilter:=true;
catalog.cfgshr.AutoStarFilter:=true;
catalog.cfgshr.AutoStarFilterMag:=6.5;
catalog.cfgcat.StarmagMax:=12;
catalog.cfgshr.NebFilter:=true;
catalog.cfgshr.BigNebFilter:=true;
catalog.cfgshr.BigNebLimit:=211;
catalog.cfgcat.NebmagMax:=12;
catalog.cfgcat.NebSizeMin:=1;
catalog.cfgcat.UseUSNOBrightStars:=false;
catalog.cfgcat.UseGSVSIr:=false;
catalog.cfgcat.GCatNum:=0;
for i:=1 to maxstarcatalog do begin
   catalog.cfgcat.starcatpath[i]:=slash(appdir)+'cat';
   catalog.cfgcat.starcatdef[i]:=false;
   catalog.cfgcat.starcaton[i]:=false;
   catalog.cfgcat.starcatfield[i,1]:=0;
   catalog.cfgcat.starcatfield[i,2]:=0;
end;
catalog.cfgcat.starcatpath[bsc-BaseStar]:=catalog.cfgcat.starcatpath[bsc-BaseStar]+PathDelim+'bsc5';
catalog.cfgcat.starcatdef[bsc-BaseStar]:=true;
catalog.cfgcat.starcatfield[bsc-BaseStar,2]:=10;
catalog.cfgcat.starcatpath[sky2000-BaseStar]:=catalog.cfgcat.starcatpath[sky2000-BaseStar]+PathDelim+'sky2000';
catalog.cfgcat.starcatfield[sky2000-BaseStar,1]:=6;
catalog.cfgcat.starcatfield[sky2000-BaseStar,2]:=7;
catalog.cfgcat.starcatpath[tyc2-BaseStar]:=catalog.cfgcat.starcatpath[tyc2-BaseStar]+PathDelim+'tycho2';
catalog.cfgcat.starcatfield[tyc2-BaseStar,1]:=0;
catalog.cfgcat.starcatfield[tyc2-BaseStar,2]:=5;
for i:=1 to maxvarstarcatalog do begin
   catalog.cfgcat.varstarcatpath[i]:=slash(appdir)+'cat';
   catalog.cfgcat.varstarcatdef[i]:=false;
   catalog.cfgcat.varstarcaton[i]:=false;
   catalog.cfgcat.varstarcatfield[i,1]:=0;
   catalog.cfgcat.varstarcatfield[i,2]:=0;
end;
for i:=1 to maxdblstarcatalog do begin
   catalog.cfgcat.dblstarcatpath[i]:=slash(appdir)+'cat';
   catalog.cfgcat.dblstarcatdef[i]:=false;
   catalog.cfgcat.dblstarcaton[i]:=false;
   catalog.cfgcat.dblstarcatfield[i,1]:=0;
   catalog.cfgcat.dblstarcatfield[i,2]:=0;
end;
for i:=1 to maxnebcatalog do begin
   catalog.cfgcat.nebcatpath[i]:=slash(appdir)+'cat';
   catalog.cfgcat.nebcatdef[i]:=false;
   catalog.cfgcat.nebcaton[i]:=false;
   catalog.cfgcat.nebcatfield[i,1]:=0;
   catalog.cfgcat.nebcatfield[i,2]:=0;
end;
catalog.cfgcat.nebcatpath[sac-BaseNeb]:=slash(appdir)+'cat'+PathDelim+'sac';
catalog.cfgcat.nebcatdef[sac-BaseNeb]:=true;
catalog.cfgcat.nebcatfield[sac-BaseNeb,2]:=10;
catalog.cfgcat.nebcatpath[ngc-BaseNeb]:=slash(appdir)+'cat'+PathDelim+'ngc2000';
catalog.cfgshr.FieldNum[0]:=0.5;
catalog.cfgshr.FieldNum[1]:=1;
catalog.cfgshr.FieldNum[2]:=2;
catalog.cfgshr.FieldNum[3]:=5;
catalog.cfgshr.FieldNum[4]:=10;
catalog.cfgshr.FieldNum[5]:=20;
catalog.cfgshr.FieldNum[6]:=45;
catalog.cfgshr.FieldNum[7]:=90;
catalog.cfgshr.FieldNum[8]:=180;
catalog.cfgshr.FieldNum[9]:=310;
catalog.cfgshr.FieldNum[10]:=360;
catalog.cfgshr.DegreeGridSpacing[0]:=5/60;
catalog.cfgshr.DegreeGridSpacing[1]:=10/60;
catalog.cfgshr.DegreeGridSpacing[2]:=20/60;
catalog.cfgshr.DegreeGridSpacing[3]:=30/60;
catalog.cfgshr.DegreeGridSpacing[4]:=1;
catalog.cfgshr.DegreeGridSpacing[5]:=2;
catalog.cfgshr.DegreeGridSpacing[6]:=5;
catalog.cfgshr.DegreeGridSpacing[7]:=10;
catalog.cfgshr.DegreeGridSpacing[8]:=15;
catalog.cfgshr.DegreeGridSpacing[9]:=20;
catalog.cfgshr.DegreeGridSpacing[10]:=20;
catalog.cfgshr.HourGridSpacing[0]:=20/3600;
catalog.cfgshr.HourGridSpacing[1]:=30/3600;
catalog.cfgshr.HourGridSpacing[2]:=1/60;
catalog.cfgshr.HourGridSpacing[3]:=2/60;
catalog.cfgshr.HourGridSpacing[4]:=5/60;
catalog.cfgshr.HourGridSpacing[5]:=15/60;
catalog.cfgshr.HourGridSpacing[6]:=30/60;
catalog.cfgshr.HourGridSpacing[7]:=1;
catalog.cfgshr.HourGridSpacing[8]:=1;
catalog.cfgshr.HourGridSpacing[9]:=2;
catalog.cfgshr.HourGridSpacing[10]:=2;
def_cfgsc.projname[0]:='ARC';
def_cfgsc.projname[1]:='ARC';
def_cfgsc.projname[2]:='ARC';
def_cfgsc.projname[3]:='ARC';
def_cfgsc.projname[4]:='ARC';
def_cfgsc.projname[5]:='ARC';
def_cfgsc.projname[6]:='ARC';
def_cfgsc.projname[7]:='ARC';
def_cfgsc.projname[8]:='ARC';
def_cfgsc.projname[9]:='ARC';
def_cfgsc.projname[10]:='ARC';
catalog.cfgshr.StarMagFilter[0]:=99;
catalog.cfgshr.StarMagFilter[1]:=99;
catalog.cfgshr.StarMagFilter[2]:=99;
catalog.cfgshr.StarMagFilter[3]:=12;
catalog.cfgshr.StarMagFilter[4]:=11;
catalog.cfgshr.StarMagFilter[5]:=9;
catalog.cfgshr.StarMagFilter[6]:=8;
catalog.cfgshr.StarMagFilter[7]:=7;
catalog.cfgshr.StarMagFilter[8]:=6;
catalog.cfgshr.StarMagFilter[9]:=5;
catalog.cfgshr.StarMagFilter[10]:=4;
catalog.cfgshr.NebMagFilter[0]:=99;
catalog.cfgshr.NebMagFilter[1]:=99;
catalog.cfgshr.NebMagFilter[2]:=99;
catalog.cfgshr.NebMagFilter[3]:=99;
catalog.cfgshr.NebMagFilter[4]:=99;
catalog.cfgshr.NebMagFilter[5]:=13;
catalog.cfgshr.NebMagFilter[6]:=11;
catalog.cfgshr.NebMagFilter[7]:=10;
catalog.cfgshr.NebMagFilter[8]:=9;
catalog.cfgshr.NebMagFilter[9]:=6;
catalog.cfgshr.NebMagFilter[10]:=6;
catalog.cfgshr.NebSizeFilter[0]:=0;
catalog.cfgshr.NebSizeFilter[1]:=0;
catalog.cfgshr.NebSizeFilter[2]:=0;
catalog.cfgshr.NebSizeFilter[3]:=1;
catalog.cfgshr.NebSizeFilter[4]:=2;
catalog.cfgshr.NebSizeFilter[5]:=4;
catalog.cfgshr.NebSizeFilter[6]:=6;
catalog.cfgshr.NebSizeFilter[7]:=10;
catalog.cfgshr.NebSizeFilter[8]:=20;
catalog.cfgshr.NebSizeFilter[9]:=30;
catalog.cfgshr.NebSizeFilter[10]:=60;
end;

procedure Tf_main.ReadDefault;
begin
ReadPrivateConfig(configfile);
ReadChartConfig(configfile,true,true,def_cfgplot,def_cfgsc);
if config_version<cdcver then UpdateConfig;
end;

procedure Tf_main.ReadChartConfig(filename:string; usecatalog,resizemain:boolean; var cplot:conf_plot ;var csc:conf_skychart);
var i:integer;
    inif: TMemIniFile;
    section,buf : string;
begin
inif:=TMeminifile.create(filename);
try
with inif do begin
section:='main';
if resizemain then begin
  f_main.Top := ReadInteger(section,'WinTop',f_main.Top);
  f_main.Left := ReadInteger(section,'WinLeft',f_main.Left);
  f_main.Width := ReadInteger(section,'WinWidth',f_main.Width);
  f_main.Height := ReadInteger(section,'WinHeight',f_main.Height);
  if f_main.Width>screen.Width then f_main.Width:=screen.Width;
  if f_main.Height>(screen.Height-25) then f_main.Height:=screen.Height-25;
  formpos(f_main,f_main.Left,f_main.Top);
end;
for i:=0 to MaxField do catalog.cfgshr.FieldNum[i]:=ReadFloat(section,'FieldNum'+inttostr(i),catalog.cfgshr.FieldNum[i]);
section:='font';
for i:=1 to numfont do begin
   cplot.FontName[i]:=ReadString(section,'FontName'+inttostr(i),cplot.FontName[i]);
   cplot.FontSize[i]:=ReadInteger(section,'FontSize'+inttostr(i),cplot.FontSize[i]);
   cplot.FontBold[i]:=ReadBool(section,'FontBold'+inttostr(i),cplot.FontBold[i]);
   cplot.FontItalic[i]:=ReadBool(section,'FontItalic'+inttostr(i),cplot.FontItalic[i]);
end;
for i:=1 to numlabtype do begin
   cplot.LabelColor[i]:=ReadInteger(section,'LabelColor'+inttostr(i),cplot.LabelColor[i]);
   cplot.LabelSize[i]:=ReadInteger(section,'LabelSize'+inttostr(i),cplot.LabelSize[i]);
end;
section:='filter';
catalog.cfgshr.StarFilter:=ReadBool(section,'StarFilter',catalog.cfgshr.StarFilter);
catalog.cfgshr.AutoStarFilter:=ReadBool(section,'AutoStarFilter',catalog.cfgshr.AutoStarFilter);
catalog.cfgshr.AutoStarFilterMag:=ReadFloat(section,'AutoStarFilterMag',catalog.cfgshr.AutoStarFilterMag);
catalog.cfgshr.NebFilter:=ReadBool(section,'NebFilter',catalog.cfgshr.NebFilter);
catalog.cfgshr.BigNebFilter:=ReadBool(section,'BigNebFilter',catalog.cfgshr.BigNebFilter);
catalog.cfgshr.BigNebLimit:=ReadFloat(section,'BigNebLimit',catalog.cfgshr.BigNebLimit);
for i:=1 to maxfield do begin
   catalog.cfgshr.StarMagFilter[i]:=ReadFloat(section,'StarMagFilter'+inttostr(i),catalog.cfgshr.StarMagFilter[i]);
   catalog.cfgshr.NebMagFilter[i]:=ReadFloat(section,'NebMagFilter'+inttostr(i),catalog.cfgshr.NebMagFilter[i]);
   catalog.cfgshr.NebSizeFilter[i]:=ReadFloat(section,'NebSizeFilter'+inttostr(i),catalog.cfgshr.NebSizeFilter[i]);
end;
if usecatalog then begin
section:='catalog';
catalog.cfgcat.GCatNum:=Readinteger(section,'GCatNum',0);
SetLength(catalog.cfgcat.GCatLst,catalog.cfgcat.GCatNum);
for i:=0 to catalog.cfgcat.GCatNum-1 do begin
   catalog.cfgcat.GCatLst[i].shortname:=Readstring(section,'CatName'+inttostr(i),'');
   catalog.cfgcat.GCatLst[i].name:=Readstring(section,'CatLongName'+inttostr(i),'');
   catalog.cfgcat.GCatLst[i].path:=Readstring(section,'CatPath'+inttostr(i),'');
   catalog.cfgcat.GCatLst[i].min:=ReadFloat(section,'CatMin'+inttostr(i),0);
   catalog.cfgcat.GCatLst[i].max:=ReadFloat(section,'CatMax'+inttostr(i),0);
   catalog.cfgcat.GCatLst[i].Actif:=ReadBool(section,'CatActif'+inttostr(i),false);
   catalog.cfgcat.GCatLst[i].magmax:=0;
   catalog.cfgcat.GCatLst[i].cattype:=0;
   if catalog.cfgcat.GCatLst[i].Actif then begin
      if not
      catalog.GetInfo(catalog.cfgcat.GCatLst[i].path,
                      catalog.cfgcat.GCatLst[i].shortname,
                      catalog.cfgcat.GCatLst[i].magmax,
                      catalog.cfgcat.GCatLst[i].cattype,
                      catalog.cfgcat.GCatLst[i].version,
                      catalog.cfgcat.GCatLst[i].name)
      then catalog.cfgcat.GCatLst[i].Actif:=false;
   end;
end;
catalog.cfgcat.StarmagMax:=ReadFloat(section,'StarmagMax',catalog.cfgcat.StarmagMax);
catalog.cfgcat.NebmagMax:=ReadFloat(section,'NebmagMax',catalog.cfgcat.NebmagMax);
catalog.cfgcat.NebSizeMin:=ReadFloat(section,'NebSizeMin',catalog.cfgcat.NebSizeMin);
catalog.cfgcat.UseUSNOBrightStars:=ReadBool(section,'UseUSNOBrightStars',catalog.cfgcat.UseUSNOBrightStars);
catalog.cfgcat.UseGSVSIr:=ReadBool(section,'UseGSVSIr',catalog.cfgcat.UseGSVSIr);
for i:=1 to maxstarcatalog do begin
   catalog.cfgcat.starcatdef[i]:=ReadBool(section,'starcatdef'+inttostr(i),catalog.cfgcat.starcatdef[i]);
   catalog.cfgcat.starcaton[i]:=ReadBool(section,'starcaton'+inttostr(i),catalog.cfgcat.starcaton[i]);
   catalog.cfgcat.starcatfield[i,1]:=ReadInteger(section,'starcatfield1'+inttostr(i),catalog.cfgcat.starcatfield[i,1]);
   catalog.cfgcat.starcatfield[i,2]:=ReadInteger(section,'starcatfield2'+inttostr(i),catalog.cfgcat.starcatfield[i,2]);
end;
for i:=1 to maxvarstarcatalog do begin
   catalog.cfgcat.varstarcatdef[i]:=ReadBool(section,'varstarcatdef'+inttostr(i),catalog.cfgcat.varstarcatdef[i]);
   catalog.cfgcat.varstarcaton[i]:=ReadBool(section,'varstarcaton'+inttostr(i),catalog.cfgcat.varstarcaton[i]);
   catalog.cfgcat.varstarcatfield[i,1]:=ReadInteger(section,'varstarcatfield1'+inttostr(i),catalog.cfgcat.varstarcatfield[i,1]);
   catalog.cfgcat.varstarcatfield[i,2]:=ReadInteger(section,'varstarcatfield2'+inttostr(i),catalog.cfgcat.varstarcatfield[i,2]);
end;
for i:=1 to maxdblstarcatalog do begin
   catalog.cfgcat.dblstarcatdef[i]:=ReadBool(section,'dblstarcatdef'+inttostr(i),catalog.cfgcat.dblstarcatdef[i]);
   catalog.cfgcat.dblstarcaton[i]:=ReadBool(section,'dblstarcaton'+inttostr(i),catalog.cfgcat.dblstarcaton[i]);
   catalog.cfgcat.dblstarcatfield[i,1]:=ReadInteger(section,'dblstarcatfield1'+inttostr(i),catalog.cfgcat.dblstarcatfield[i,1]);
   catalog.cfgcat.dblstarcatfield[i,2]:=ReadInteger(section,'dblstarcatfield2'+inttostr(i),catalog.cfgcat.dblstarcatfield[i,2]);
end;
for i:=1 to maxnebcatalog do begin
   catalog.cfgcat.nebcatdef[i]:=ReadBool(section,'nebcatdef'+inttostr(i),catalog.cfgcat.nebcatdef[i]);
   catalog.cfgcat.nebcaton[i]:=ReadBool(section,'nebcaton'+inttostr(i),catalog.cfgcat.nebcaton[i]);
   catalog.cfgcat.nebcatfield[i,1]:=ReadInteger(section,'nebcatfield1'+inttostr(i),catalog.cfgcat.nebcatfield[i,1]);
   catalog.cfgcat.nebcatfield[i,2]:=ReadInteger(section,'nebcatfield2'+inttostr(i),catalog.cfgcat.nebcatfield[i,2]);
end;
end;
section:='display';
cplot.starplot:=ReadInteger(section,'starplot',cplot.starplot);
cplot.nebplot:=ReadInteger(section,'nebplot',cplot.nebplot);
cplot.plaplot:=ReadInteger(section,'plaplot',cplot.plaplot);
cplot.Nebgray:=ReadInteger(section,'Nebgray',cplot.Nebgray);
cplot.NebBright:=ReadInteger(section,'NebBright',cplot.NebBright);
cplot.contrast:=ReadInteger(section,'contrast',cplot.contrast);
cplot.saturation:=ReadInteger(section,'saturation',cplot.saturation);
cplot.partsize:=ReadFloat(section,'partsize',cplot.partsize);
cplot.magsize:=ReadFloat(section,'magsize',cplot.magsize);
cplot.PlanetTransparent:=ReadBool(section,'PlanetTransparent',cplot.PlanetTransparent);
cplot.AutoSkycolor:=ReadBool(section,'AutoSkycolor',cplot.AutoSkycolor);
for i:=0 to maxcolor do cplot.color[i]:=ReadInteger(section,'color'+inttostr(i),cplot.color[i]);
for i:=1 to 7 do cplot.skycolor[i]:=ReadInteger(section,'skycolor'+inttostr(i),cplot.skycolor[i]);
cplot.bgColor:=ReadInteger(section,'bgColor',cplot.bgColor);
section:='grid';
for i:=0 to maxfield do catalog.cfgshr.HourGridSpacing[i]:=ReadFloat(section,'HourGridSpacing'+inttostr(i),catalog.cfgshr.HourGridSpacing[i] );
for i:=0 to maxfield do catalog.cfgshr.DegreeGridSpacing[i]:=ReadFloat(section,'DegreeGridSpacing'+inttostr(i),catalog.cfgshr.DegreeGridSpacing[i] );
section:='Finder';
for i:=1 to 10 do csc.circle[i,1]:=ReadFloat(section,'Circle'+inttostr(i),csc.circle[i,1]);
for i:=1 to 10 do csc.circle[i,2]:=ReadFloat(section,'CircleR'+inttostr(i),csc.circle[i,2]);
for i:=1 to 10 do csc.circle[i,3]:=ReadFloat(section,'CircleOffset'+inttostr(i),csc.circle[i,3]);
for i:=1 to 10 do csc.circleok[i]:=ReadBool(section,'ShowCircle'+inttostr(i),csc.circleok[i]);
for i:=1 to 10 do csc.circlelbl[i]:=ReadString(section,'CircleLbl'+inttostr(i),csc.circlelbl[i]);
for i:=1 to 10 do csc.rectangle[i,1]:=ReadFloat(section,'RectangleW'+inttostr(i),csc.rectangle[i,1]);
for i:=1 to 10 do csc.rectangle[i,2]:=ReadFloat(section,'RectangleH'+inttostr(i),csc.rectangle[i,2]);
for i:=1 to 10 do csc.rectangle[i,3]:=ReadFloat(section,'RectangleR'+inttostr(i),csc.rectangle[i,3]);
for i:=1 to 10 do csc.rectangle[i,4]:=ReadFloat(section,'RectangleOffset'+inttostr(i),csc.rectangle[i,4]);
for i:=1 to 10 do csc.rectangleok[i]:=ReadBool(section,'ShowRectangle'+inttostr(i),csc.rectangleok[i]);
for i:=1 to 10 do csc.rectanglelbl[i]:=ReadString(section,'RectangleLbl'+inttostr(i),csc.rectanglelbl[i]);
section:='chart';
catalog.cfgshr.EquinoxType:=ReadInteger(section,'EquinoxType',catalog.cfgshr.EquinoxType);
catalog.cfgshr.EquinoxChart:=ReadString(section,'EquinoxChart',catalog.cfgshr.EquinoxChart);
catalog.cfgshr.DefaultJDchart:=ReadFloat(section,'DefaultJDchart',catalog.cfgshr.DefaultJDchart);
section:='default_chart';
csc.winx:=ReadInteger(section,'ChartWidth',csc.xmax);
csc.winy:=ReadInteger(section,'ChartHeight',csc.ymax);
csc.wintop:=ReadInteger(section,'ChartTop',0);
csc.winleft:=ReadInteger(section,'Chartleft',0);
cfgm.maximized:=ReadBool(section,'ChartMaximized',true);
csc.racentre:=ReadFloat(section,'racentre',csc.racentre);
csc.decentre:=ReadFloat(section,'decentre',csc.decentre);
csc.acentre:=ReadFloat(section,'acentre',csc.acentre);
csc.hcentre:=ReadFloat(section,'hcentre',csc.hcentre);
csc.fov:=round(ReadFloat(section,'fov',csc.fov)/secarc)*secarc; // round to 1 arcsec
csc.theta:=ReadFloat(section,'theta',csc.theta);
buf:=trim(ReadString(section,'projtype',csc.projtype))+'A';
csc.projtype:=buf[1];
csc.ProjPole:=ReadInteger(section,'ProjPole',csc.ProjPole);
csc.FlipX:=ReadInteger(section,'FlipX',csc.FlipX);
csc.FlipY:=ReadInteger(section,'FlipY',csc.FlipY);
csc.PMon:=ReadBool(section,'PMon',csc.PMon);
csc.DrawPMon:=ReadBool(section,'DrawPMon',csc.DrawPMon);
csc.ApparentPos:=ReadBool(section,'ApparentPos',csc.ApparentPos);
csc.DrawPMyear:=ReadInteger(section,'DrawPMyear',csc.DrawPMyear);
csc.horizonopaque:=ReadBool(section,'horizonopaque',csc.horizonopaque);
csc.ShowHorizon:=ReadBool(section,'ShowHorizon',csc.ShowHorizon);
csc.ShowHorizonDepression:=ReadBool(section,'ShowHorizonDepression',csc.ShowHorizonDepression);
csc.ShowEqGrid:=ReadBool(section,'ShowEqGrid',csc.ShowEqGrid);
csc.ShowLabelAll:=ReadBool(section,'ShowLabelAll',csc.ShowLabelAll);
csc.EditLabels:=ReadBool(section,'EditLabels',csc.EditLabels);
csc.ShowGrid:=ReadBool(section,'ShowGrid',csc.ShowGrid);
csc.ShowGridNum:=ReadBool(section,'ShowGridNum',csc.ShowGridNum);
csc.ShowConstL:=ReadBool(section,'ShowConstL',csc.ShowConstL);
csc.ShowConstB:=ReadBool(section,'ShowConstB',csc.ShowConstB);
csc.ShowEcliptic:=ReadBool(section,'ShowEcliptic',csc.ShowEcliptic);
csc.ShowGalactic:=ReadBool(section,'ShowGalactic',csc.ShowGalactic); 
csc.ShowMilkyWay:=ReadBool(section,'ShowMilkyWay',csc.ShowMilkyWay);
csc.FillMilkyWay:=ReadBool(section,'FillMilkyWay',csc.FillMilkyWay);
csc.ShowPlanet:=ReadBool(section,'ShowPlanet',csc.ShowPlanet);
csc.ShowAsteroid:=ReadBool(section,'ShowAsteroid',csc.ShowAsteroid);
csc.ShowComet:=ReadBool(section,'ShowComet',csc.ShowComet);
csc.ShowImages:=ReadBool(section,'ShowImages',csc.ShowImages);
csc.ShowBackgroundImage:=ReadBool(section,'ShowBackgroundImage',csc.ShowBackgroundImage);
csc.BackgroundImage:=ReadString(section,'BackgroundImage',csc.BackgroundImage);
csc.AstSymbol:=ReadInteger(section,'AstSymbol',csc.AstSymbol);
csc.AstmagMax:=ReadFloat(section,'AstmagMax',csc.AstmagMax);
csc.AstmagDiff:=ReadFloat(section,'AstmagDiff',csc.AstmagDiff);
csc.ComSymbol:=ReadInteger(section,'ComSymbol',csc.ComSymbol);
csc.CommagMax:=ReadFloat(section,'CommagMax',csc.CommagMax);
csc.CommagDiff:=ReadFloat(section,'CommagDiff',csc.CommagDiff);
csc.MagLabel:=ReadBool(section,'MagLabel',csc.MagLabel);
csc.NameLabel:=ReadBool(section,'NameLabel',csc.NameLabel);
csc.ConstFullLabel:=ReadBool(section,'ConstFullLabel',csc.ConstFullLabel);
csc.PlanetParalaxe:=ReadBool(section,'PlanetParalaxe',csc.PlanetParalaxe);
csc.ShowEarthShadow:=ReadBool(section,'ShowEarthShadow',csc.ShowEarthShadow);
csc.GRSlongitude:=ReadFloat(section,'GRSlongitude',csc.GRSlongitude);
csc.Simnb:=ReadInteger(section,'Simnb',csc.Simnb);
csc.SimD:=ReadInteger(section,'SimD',csc.SimD);
csc.SimH:=ReadInteger(section,'SimH',csc.SimH);
csc.SimM:=ReadInteger(section,'SimM',csc.SimM);
csc.SimS:=ReadInteger(section,'SimS',csc.SimS);
csc.SimLine:=ReadBool(section,'SimLine',csc.SimLine);
for i:=1 to NumSimObject do csc.SimObject[i]:=ReadBool(section,'SimObject'+inttostr(i),csc.SimObject[i]);
for i:=1 to numlabtype do begin
   csc.ShowLabel[i]:=readBool(section,'ShowLabel'+inttostr(i),csc.ShowLabel[i]);
   csc.LabelMagDiff[i]:=readFloat(section,'LabelMag'+inttostr(i),csc.LabelMagDiff[i]);
end;
section:='observatory';
csc.ObsLatitude := ReadFloat(section,'ObsLatitude',csc.ObsLatitude );
csc.ObsLongitude := ReadFloat(section,'ObsLongitude',csc.ObsLongitude );
csc.ObsAltitude := ReadFloat(section,'ObsAltitude',csc.ObsAltitude );
csc.ObsTemperature := ReadFloat(section,'ObsTemperature',csc.ObsTemperature );
csc.ObsPressure := ReadFloat(section,'ObsPressure',csc.ObsPressure );
csc.ObsName := ReadString(section,'ObsName',csc.ObsName );
csc.ObsCountry := ReadString(section,'ObsCountry',csc.ObsCountry );
csc.ObsTZ := ReadFloat(section,'ObsTZ',csc.ObsTZ );
section:='date';
csc.UseSystemTime:=ReadBool(section,'UseSystemTime',csc.UseSystemTime);
csc.CurYear:=ReadInteger(section,'CurYear',csc.CurYear);
csc.CurMonth:=ReadInteger(section,'CurMonth',csc.CurMonth);
csc.CurDay:=ReadInteger(section,'CurDay',csc.CurDay);
csc.CurTime:=ReadFloat(section,'CurTime',csc.CurTime);
csc.autorefresh:=ReadBool(section,'autorefresh',csc.autorefresh);
csc.Force_DT_UT:=ReadBool(section,'Force_DT_UT',csc.Force_DT_UT);
csc.DT_UT_val:=ReadFloat(section,'DT_UT_val',csc.DT_UT_val);
section:='projection';
for i:=1 to maxfield do csc.projname[i]:=ReadString(section,'ProjName'+inttostr(i),csc.projname[i] );
section:='labels';
csc.nummodlabels:=ReadInteger(section,'numlabels',0);
for i:=1 to csc.nummodlabels do begin
   csc.modlabels[i].id:=ReadInteger(section,'labelid'+inttostr(i),0);
   csc.modlabels[i].dx:=ReadInteger(section,'labeldx'+inttostr(i),0);
   csc.modlabels[i].dy:=ReadInteger(section,'labeldy'+inttostr(i),0);
   csc.modlabels[i].labelnum:=ReadInteger(section,'labelnum'+inttostr(i),1);
   csc.modlabels[i].fontnum:=ReadInteger(section,'labelfont'+inttostr(i),2);
   csc.modlabels[i].txt:=ReadString(section,'labeltxt'+inttostr(i),'');
   csc.modlabels[i].hiden:=ReadBool(section,'labelhiden'+inttostr(i),false);
end;
end;
finally
inif.Free;
end;
end;

procedure Tf_main.ReadPrivateConfig(filename:string);
var i,j:integer;
    inif: TMemIniFile;
    section : string;
begin
inif:=TMeminifile.create(filename);
try
with inif do begin
section:='main';
Config_Version:=ReadString(section,'version','0');
SaveConfigOnExit.Checked:=ReadBool(section,'SaveConfigOnExit',SaveConfigOnExit.Checked);
cfgm.language:=ReadString(section,'language',cfgm.language);
{$ifdef linux}
LinuxDesktop:=ReadInteger(section,'LinuxDesktop',LinuxDesktop);
OpenFileCMD:=ReadString(section,'OpenFileCMD',OpenFileCMD);
{$endif}
{$ifdef mswindows}
use_xplanet:=ReadBool(section,'use_xplanet',use_xplanet);
xplanet_dir:=ReadString(section,'xplanet_dir',xplanet_dir);
{$endif}
ButtonImage:=ReadInteger(section,'ButtonImage',ButtonImage);
NightVision:=ReadBool(section,'NightVision',NightVision);
cfgm.prtname:=ReadString(section,'prtname',cfgm.prtname);
cfgm.PrinterResolution:=ReadInteger(section,'PrinterResolution',cfgm.PrinterResolution);
cfgm.PrintColor:=ReadInteger(section,'PrintColor',cfgm.PrintColor);
cfgm.PrintLandscape:=ReadBool(section,'PrintLandscape',cfgm.PrintLandscape);
cfgm.PrintMethod:=ReadInteger(section,'PrintMethod',cfgm.PrintMethod);
cfgm.PrintCmd1:=ReadString(section,'PrintCmd1',cfgm.PrintCmd1);
cfgm.PrintCmd2:=ReadString(section,'PrintCmd2',cfgm.PrintCmd2);
cfgm.PrintTmpPath:=ReadString(section,'PrintTmpPath',cfgm.PrintTmpPath);
if (ReadBool(section,'WinMaximize',false)) then f_main.WindowState:=wsMaximized;
cfgm.autorefreshdelay:=ReadInteger(section,'autorefreshdelay',cfgm.autorefreshdelay);
cfgm.Constellationfile:=ReadString(section,'Constellationfile',cfgm.Constellationfile);
cfgm.ConstLfile:=ReadString(section,'ConstLfile',cfgm.ConstLfile);
cfgm.ConstBfile:=ReadString(section,'ConstBfile',cfgm.ConstBfile);
cfgm.EarthMapFile:=ReadString(section,'EarthMapFile',cfgm.EarthMapFile);
cfgm.PlanetDir:=ReadString(section,'PlanetDir',cfgm.PlanetDir);
cfgm.horizonfile:=ReadString(section,'horizonfile',cfgm.horizonfile);
cfgm.ServerIPaddr:=ReadString(section,'ServerIPaddr',cfgm.ServerIPaddr);
cfgm.ServerIPport:=ReadString(section,'ServerIPport',cfgm.ServerIPport);
cfgm.keepalive:=ReadBool(section,'keepalive',cfgm.keepalive);
cfgm.AutostartServer:=ReadBool(section,'AutostartServer',cfgm.AutostartServer);
DBtype:=TDBtype(ReadInteger(section,'dbtype',1));
cfgm.dbhost:=ReadString(section,'dbhost',cfgm.dbhost);
cfgm.dbport:=ReadInteger(section,'dbport',cfgm.dbport);
cfgm.db:=ReadString(section,'db',cfgm.db);
cfgm.dbuser:=ReadString(section,'dbuser',cfgm.dbuser);
cryptedpwd:=ReadString(section,'dbpass',cfgm.dbpass);
cfgm.dbpass:=DecryptStr(cryptedpwd,encryptpwd);
cfgm.ImagePath:=ReadString(section,'ImagePath',cfgm.ImagePath);
cfgm.ImageLuminosity:=ReadFloat(section,'ImageLuminosity',cfgm.ImageLuminosity);
cfgm.ImageContrast:=ReadFloat(section,'ImageContrast',cfgm.ImageContrast);
cfgm.ShowChartInfo:=ReadBool(section,'ShowChartInfo',cfgm.ShowChartInfo);
cfgm.SyncChart:=ReadBool(section,'SyncChart',cfgm.SyncChart);
catalog.cfgshr.AzNorth:=ReadBool(section,'AzNorth',catalog.cfgshr.AzNorth);
catalog.cfgshr.ListStar:=ReadBool(section,'ListStar',catalog.cfgshr.ListStar);
catalog.cfgshr.ListNeb:=ReadBool(section,'ListNeb',catalog.cfgshr.ListNeb);
catalog.cfgshr.ListVar:=ReadBool(section,'ListVar',catalog.cfgshr.ListVar);
catalog.cfgshr.ListDbl:=ReadBool(section,'ListDbl',catalog.cfgshr.ListDbl);
catalog.cfgshr.ListPla:=ReadBool(section,'ListPla',catalog.cfgshr.ListPla);
def_cfgsc.IndiAutostart:=ReadBool(section,'IndiAutostart',def_cfgsc.IndiAutostart);
def_cfgsc.IndiServerHost:=ReadString(section,'IndiServerHost',def_cfgsc.IndiServerHost);
def_cfgsc.IndiServerPort:=ReadString(section,'IndiServerPort',def_cfgsc.IndiServerPort);
def_cfgsc.IndiServerCmd:=ReadString(section,'IndiServerCmd',def_cfgsc.IndiServerCmd);
def_cfgsc.IndiDriver:=ReadString(section,'IndiDriver',def_cfgsc.IndiDriver);
def_cfgsc.IndiPort:=ReadString(section,'IndiPort',def_cfgsc.IndiPort);
def_cfgsc.IndiDevice:=ReadString(section,'IndiDevice',def_cfgsc.IndiDevice);
def_cfgsc.IndiTelescope:=ReadBool(section,'IndiTelescope',def_cfgsc.IndiTelescope);
def_cfgsc.ScopePlugin:=ReadString(section,'ScopePlugin',def_cfgsc.ScopePlugin);
toolbar1.visible:=ReadBool(section,'ViewMainBar',true);
PanelLeft.visible:=ReadBool(section,'ViewLeftBar',true);
PanelRight.visible:=ReadBool(section,'ViewRightBar',true);
toolbar4.visible:=ReadBool(section,'ViewObjectBar',true);
MainBar1.checked:=ToolBar1.visible;
ObjectBar1.checked:=ToolBar4.visible;
LeftBar1.checked:=PanelLeft.visible;
RightBar1.checked:=PanelRight.visible;
ViewToolsBar1.checked:=(MainBar1.checked and ObjectBar1.checked and LeftBar1.checked and RightBar1.checked);
ViewTopPanel;
InitialChartNum:=ReadInteger(section,'NumChart',0);
section:='catalog';
for i:=1 to maxstarcatalog do begin
   catalog.cfgcat.starcatpath[i]:=ReadString(section,'starcatpath'+inttostr(i),catalog.cfgcat.starcatpath[i]);
end;
for i:=1 to maxvarstarcatalog do begin
   catalog.cfgcat.varstarcatpath[i]:=ReadString(section,'varstarcatpath'+inttostr(i),catalog.cfgcat.varstarcatpath[i]);
end;
for i:=1 to maxdblstarcatalog do begin
   catalog.cfgcat.dblstarcatpath[i]:=ReadString(section,'dblstarcatpath'+inttostr(i),catalog.cfgcat.dblstarcatpath[i]);
end;
for i:=1 to maxnebcatalog do begin
   catalog.cfgcat.nebcatpath[i]:=ReadString(section,'nebcatpath'+inttostr(i),catalog.cfgcat.nebcatpath[i]);
end;
section:='dss';
f_getdss.cfgdss.dssnorth:=ReadBool(section,'dssnorth',false);
f_getdss.cfgdss.dsssouth:=ReadBool(section,'dsssouth',false);
f_getdss.cfgdss.dss102:=ReadBool(section,'dss102',false);
f_getdss.cfgdss.dsssampling:=ReadBool(section,'dsssampling',true);
f_getdss.cfgdss.dssplateprompt:=ReadBool(section,'dssplateprompt',true);
f_getdss.cfgdss.dssmaxsize:=ReadInteger(section,'dssmaxsize',2048);
f_getdss.cfgdss.dssdir:=ReadString(section,'dssdir',slash('cat')+'RealSky');
f_getdss.cfgdss.dssdrive:=ReadString(section,'dssdrive','D:\');
f_getdss.cfgdss.dssfile:=ReadString(section,'dssfile',slash(privatedir)+slash('pictures')+'$temp.fit');
section:='quicksearch';
j:=min(MaxQuickSearch,ReadInteger(section,'count',0));
for i:=1 to j do quicksearch.Items.Add(ReadString(section,'item'+inttostr(i),''));
end;
finally
inif.Free;
end;
end;

procedure Tf_main.UpdateConfig;
begin
if Config_Version < '3.0.0.7' then begin
   def_cfgplot.color[22]:=DFcolor[22];
   catalog.cfgshr.BigNebLimit:=211;
   catalog.cfgshr.NebMagFilter[4]:=99;
end;
if Config_Version < '3.0.0.8' then begin
   cfgm.dbpass:=cryptedpwd;
end;
SaveDefault;
end;

procedure Tf_main.SaveDefault;
var i,j: integer;
begin
SavePrivateConfig(configfile);
SaveChartConfig(configfile,(ActiveMDIchild as Tf_chart));
j:=0;
for i:=0 to MDIChildCount-1 do
  if (MDIChildren[i] is Tf_chart) and (MDIChildren[i]<>ActiveMDIChild) then begin
     inc(j);
     SaveChartConfig(configfile+inttostr(j),(MDIChildren[i] as Tf_chart));
  end;
end;

procedure Tf_main.SaveChartConfig(filename:string; chart: Tf_chart);
var i:integer;
    inif: TMemIniFile;
    section : string;
    cplot:conf_plot ;
    csc:conf_skychart;
begin
if chart is Tf_chart then with chart as Tf_chart do begin
  cplot:=sc.plot.cfgplot;
  csc:=sc.cfgsc;
end
else begin
  cplot:=def_cfgplot;
  csc:=def_cfgsc;
end;
inif:=TMeminifile.create(filename);
try
with inif do begin
section:='main';
WriteInteger(section,'WinTop',f_main.Top);
WriteInteger(section,'WinLeft',f_main.Left);
WriteInteger(section,'WinWidth',f_main.Width);
WriteInteger(section,'WinHeight',f_main.Height);
for i:=0 to MaxField do WriteFloat(section,'FieldNum'+inttostr(i),catalog.cfgshr.FieldNum[i]);
section:='filter';
WriteBool(section,'StarFilter',catalog.cfgshr.StarFilter);
WriteBool(section,'AutoStarFilter',catalog.cfgshr.AutoStarFilter);
WriteFloat(section,'AutoStarFilterMag',catalog.cfgshr.AutoStarFilterMag);
WriteBool(section,'NebFilter',catalog.cfgshr.NebFilter);
WriteBool(section,'BigNebFilter',catalog.cfgshr.BigNebFilter);
WriteFloat(section,'BigNebLimit',catalog.cfgshr.BigNebLimit);
for i:=1 to maxfield do begin
   WriteFloat(section,'StarMagFilter'+inttostr(i),catalog.cfgshr.StarMagFilter[i]);
   WriteFloat(section,'NebMagFilter'+inttostr(i),catalog.cfgshr.NebMagFilter[i]);
   WriteFloat(section,'NebSizeFilter'+inttostr(i),catalog.cfgshr.NebSizeFilter[i]);
end;
section:='catalog';
Writeinteger(section,'GCatNum',catalog.cfgcat.GCatNum);
for i:=0 to catalog.cfgcat.GCatNum-1 do begin
   Writestring(section,'CatName'+inttostr(i),catalog.cfgcat.GCatLst[i].shortname);
   Writestring(section,'CatLongName'+inttostr(i),catalog.cfgcat.GCatLst[i].name);
   Writestring(section,'CatPath'+inttostr(i),catalog.cfgcat.GCatLst[i].path);
   WriteFloat(section,'CatMin'+inttostr(i),catalog.cfgcat.GCatLst[i].min);
   WriteFloat(section,'CatMax'+inttostr(i),catalog.cfgcat.GCatLst[i].max);
   WriteBool(section,'CatActif'+inttostr(i),catalog.cfgcat.GCatLst[i].Actif);
end;
WriteFloat(section,'StarmagMax',catalog.cfgcat.StarmagMax);
WriteFloat(section,'NebmagMax',catalog.cfgcat.NebmagMax);
WriteFloat(section,'NebSizeMin',catalog.cfgcat.NebSizeMin);
WriteBool(section,'UseUSNOBrightStars',catalog.cfgcat.UseUSNOBrightStars);
WriteBool(section,'UseGSVSIr',catalog.cfgcat.UseGSVSIr);
for i:=1 to maxstarcatalog do begin
   WriteBool(section,'starcatdef'+inttostr(i),catalog.cfgcat.starcatdef[i]);
   WriteBool(section,'starcaton'+inttostr(i),catalog.cfgcat.starcaton[i]);
   WriteInteger(section,'starcatfield1'+inttostr(i),catalog.cfgcat.starcatfield[i,1]);
   WriteInteger(section,'starcatfield2'+inttostr(i),catalog.cfgcat.starcatfield[i,2]);
end;
for i:=1 to maxvarstarcatalog do begin
   WriteBool(section,'varstarcatdef'+inttostr(i),catalog.cfgcat.varstarcatdef[i]);
   WriteBool(section,'varstarcaton'+inttostr(i),catalog.cfgcat.varstarcaton[i]);
   WriteInteger(section,'varstarcatfield1'+inttostr(i),catalog.cfgcat.varstarcatfield[i,1]);
   WriteInteger(section,'varstarcatfield2'+inttostr(i),catalog.cfgcat.varstarcatfield[i,2]);
end;
for i:=1 to maxdblstarcatalog do begin
   WriteBool(section,'dblstarcatdef'+inttostr(i),catalog.cfgcat.dblstarcatdef[i]);
   WriteBool(section,'dblstarcaton'+inttostr(i),catalog.cfgcat.dblstarcaton[i]);
   WriteInteger(section,'dblstarcatfield1'+inttostr(i),catalog.cfgcat.dblstarcatfield[i,1]);
   WriteInteger(section,'dblstarcatfield2'+inttostr(i),catalog.cfgcat.dblstarcatfield[i,2]);
end;
for i:=1 to maxnebcatalog do begin
   WriteBool(section,'nebcatdef'+inttostr(i),catalog.cfgcat.nebcatdef[i]);
   WriteBool(section,'nebcaton'+inttostr(i),catalog.cfgcat.nebcaton[i]);
   WriteInteger(section,'nebcatfield1'+inttostr(i),catalog.cfgcat.nebcatfield[i,1]);
   WriteInteger(section,'nebcatfield2'+inttostr(i),catalog.cfgcat.nebcatfield[i,2]);
end;
section:='display';
WriteInteger(section,'starplot',cplot.starplot);
WriteInteger(section,'nebplot',cplot.nebplot);
WriteInteger(section,'plaplot',cplot.plaplot);
WriteInteger(section,'Nebgray',cplot.Nebgray);
WriteInteger(section,'NebBright',cplot.NebBright);
WriteInteger(section,'contrast',cplot.contrast);
WriteInteger(section,'saturation',cplot.saturation);
WriteFloat(section,'partsize',cplot.partsize);
WriteFloat(section,'magsize',cplot.magsize);
WriteBool(section,'PlanetTransparent',cplot.PlanetTransparent);
WriteBool(section,'AutoSkycolor',cplot.AutoSkycolor);
for i:=0 to maxcolor do WriteInteger(section,'color'+inttostr(i),cplot.color[i]);
for i:=1 to 7 do WriteInteger(section,'skycolor'+inttostr(i),cplot.skycolor[i]);
WriteInteger(section,'bgColor',cplot.bgColor);
section:='font';
for i:=1 to numfont do begin
    WriteString(section,'FontName'+inttostr(i),cplot.FontName[i]);
    WriteInteger(section,'FontSize'+inttostr(i),cplot.FontSize[i]);
    WriteBool(section,'FontBold'+inttostr(i),cplot.FontBold[i]);
    WriteBool(section,'FontItalic'+inttostr(i),cplot.FontItalic[i]);
end;
for i:=1 to numlabtype do begin
   WriteInteger(section,'LabelColor'+inttostr(i),cplot.LabelColor[i]);
   WriteInteger(section,'LabelSize'+inttostr(i),cplot.LabelSize[i]);
end;
section:='grid';
for i:=0 to maxfield do WriteFloat(section,'HourGridSpacing'+inttostr(i),catalog.cfgshr.HourGridSpacing[i] );
for i:=0 to maxfield do WriteFloat(section,'DegreeGridSpacing'+inttostr(i),catalog.cfgshr.DegreeGridSpacing[i] );
section:='Finder';
for i:=1 to 10 do WriteFloat(section,'Circle'+inttostr(i),csc.circle[i,1]);
for i:=1 to 10 do WriteFloat(section,'CircleR'+inttostr(i),csc.circle[i,2]);
for i:=1 to 10 do WriteFloat(section,'CircleOffset'+inttostr(i),csc.circle[i,3]);
for i:=1 to 10 do WriteBool(section,'ShowCircle'+inttostr(i),csc.circleok[i]);
for i:=1 to 10 do WriteString(section,'CircleLbl'+inttostr(i),csc.circlelbl[i]);
for i:=1 to 10 do WriteFloat(section,'RectangleW'+inttostr(i),csc.rectangle[i,1]);
for i:=1 to 10 do WriteFloat(section,'RectangleH'+inttostr(i),csc.rectangle[i,2]);
for i:=1 to 10 do WriteFloat(section,'RectangleR'+inttostr(i),csc.rectangle[i,3]);
for i:=1 to 10 do WriteFloat(section,'RectangleOffset'+inttostr(i),csc.rectangle[i,4]);
for i:=1 to 10 do WriteBool(section,'ShowRectangle'+inttostr(i),csc.rectangleok[i]);
for i:=1 to 10 do WriteString(section,'RectangleLbl'+inttostr(i),csc.rectanglelbl[i]);
section:='chart';
WriteInteger(section,'EquinoxType',catalog.cfgshr.EquinoxType);
WriteString(section,'EquinoxChart',catalog.cfgshr.EquinoxChart);
WriteFloat(section,'DefaultJDchart',catalog.cfgshr.DefaultJDchart);
section:='default_chart';
if chart is Tf_chart then with chart as Tf_chart do begin
  WriteInteger(section,'ChartWidth',width);
  WriteInteger(section,'ChartHeight',height);
  WriteInteger(section,'ChartTop',top);
  WriteInteger(section,'Chartleft',left);
  WriteBool(section,'ChartMaximized',(WindowState=wsMaximized));
end;
WriteFloat(section,'racentre',csc.racentre);
WriteFloat(section,'decentre',csc.decentre);
WriteFloat(section,'acentre',csc.acentre);
WriteFloat(section,'hcentre',csc.hcentre);
WriteFloat(section,'fov',csc.fov);
WriteFloat(section,'theta',csc.theta);
WriteString(section,'projtype',csc.projtype);
WriteInteger(section,'ProjPole',csc.ProjPole);
WriteInteger(section,'FlipX',csc.FlipX);
WriteInteger(section,'FlipY',csc.FlipY);
WriteBool(section,'PMon',csc.PMon);
WriteBool(section,'DrawPMon',csc.DrawPMon);
WriteBool(section,'ApparentPos',csc.ApparentPos);
WriteInteger(section,'DrawPMyear',csc.DrawPMyear);
WriteBool(section,'horizonopaque',csc.horizonopaque);
WriteBool(section,'ShowHorizon',csc.ShowHorizon);
WriteBool(section,'ShowHorizonDepression',csc.ShowHorizonDepression);
WriteBool(section,'ShowEqGrid',csc.ShowEqGrid);
WriteBool(section,'ShowLabelAll',csc.ShowLabelAll);
WriteBool(section,'EditLabels',csc.EditLabels);
WriteBool(section,'ShowGrid',csc.ShowGrid);
WriteBool(section,'ShowGridNum',csc.ShowGridNum);
WriteBool(section,'ShowConstL',csc.ShowConstL);
WriteBool(section,'ShowConstB',csc.ShowConstB);
WriteBool(section,'ShowEcliptic',csc.ShowEcliptic);   
WriteBool(section,'ShowGalactic',csc.ShowGalactic);
WriteBool(section,'ShowMilkyWay',csc.ShowMilkyWay);
WriteBool(section,'FillMilkyWay',csc.FillMilkyWay);
WriteBool(section,'ShowPlanet',csc.ShowPlanet);
WriteBool(section,'ShowAsteroid',csc.ShowAsteroid);
WriteBool(section,'ShowComet',csc.ShowComet);
WriteBool(section,'ShowImages',csc.ShowImages);
WriteBool(section,'ShowBackgroundImage',csc.ShowBackgroundImage);
WriteString(section,'BackgroundImage',csc.BackgroundImage);
WriteInteger(section,'AstSymbol',csc.AstSymbol);
WriteFloat(section,'AstmagMax',csc.AstmagMax);
WriteFloat(section,'AstmagDiff',csc.AstmagDiff);
WriteInteger(section,'ComSymbol',csc.ComSymbol);
WriteFloat(section,'CommagMax',csc.CommagMax);
WriteFloat(section,'CommagDiff',csc.CommagDiff);
WriteBool(section,'MagLabel',csc.MagLabel);
WriteBool(section,'NameLabel',csc.NameLabel);
WriteBool(section,'ConstFullLabel',csc.ConstFullLabel);
WriteBool(section,'PlanetParalaxe',csc.PlanetParalaxe);
WriteBool(section,'ShowEarthShadow',csc.ShowEarthShadow);
WriteFloat(section,'GRSlongitude',csc.GRSlongitude);
WriteInteger(section,'Simnb',csc.Simnb);
WriteInteger(section,'SimD',csc.SimD);
WriteInteger(section,'SimH',csc.SimH);
WriteInteger(section,'SimM',csc.SimM);
WriteInteger(section,'SimS',csc.SimS);
WriteBool(section,'SimLine',csc.SimLine);
for i:=1 to NumSimObject do WriteBool(section,'SimObject'+inttostr(i),csc.SimObject[i]);
for i:=1 to numlabtype do begin
   WriteBool(section,'ShowLabel'+inttostr(i),csc.ShowLabel[i]);
   WriteFloat(section,'LabelMag'+inttostr(i),csc.LabelMagDiff[i]);
end;
section:='observatory';
WriteFloat(section,'ObsLatitude',csc.ObsLatitude );
WriteFloat(section,'ObsLongitude',csc.ObsLongitude );
WriteFloat(section,'ObsAltitude',csc.ObsAltitude );
WriteFloat(section,'ObsTemperature',csc.ObsTemperature );
WriteFloat(section,'ObsPressure',csc.ObsPressure );
WriteString(section,'ObsName',csc.ObsName );
WriteString(section,'ObsCountry',csc.ObsCountry );
WriteFloat(section,'ObsTZ',csc.ObsTZ );
section:='date';
WriteBool(section,'UseSystemTime',csc.UseSystemTime);
WriteInteger(section,'CurYear',csc.CurYear);
WriteInteger(section,'CurMonth',csc.CurMonth);
WriteInteger(section,'CurDay',csc.CurDay);
WriteFloat(section,'CurTime',csc.CurTime);
WriteBool(section,'autorefresh',csc.autorefresh);
WriteBool(section,'Force_DT_UT',csc.Force_DT_UT);
WriteFloat(section,'DT_UT_val',csc.DT_UT_val);
section:='projection';
for i:=1 to maxfield do WriteString(section,'ProjName'+inttostr(i),csc.projname[i] );
section:='labels';
EraseSection(section);
WriteInteger(section,'numlabels',csc.nummodlabels);
for i:=1 to csc.nummodlabels do begin
   WriteInteger(section,'labelid'+inttostr(i),csc.modlabels[i].id);
   WriteInteger(section,'labeldx'+inttostr(i),csc.modlabels[i].dx);
   WriteInteger(section,'labeldy'+inttostr(i),csc.modlabels[i].dy);
   WriteInteger(section,'labelnum'+inttostr(i),csc.modlabels[i].labelnum);
   WriteInteger(section,'labelfont'+inttostr(i),csc.modlabels[i].fontnum);
   WriteString(section,'labeltxt'+inttostr(i),csc.modlabels[i].txt);
   WriteBool(section,'labelhiden'+inttostr(i),csc.modlabels[i].hiden);
end;
Updatefile;
end;
finally
 inif.Free;
end;
end;

procedure Tf_main.SavePrivateConfig(filename:string);
var i:integer;
    inif: TMemIniFile;
    section : string;
begin
inif:=TMeminifile.create(filename);
try
with inif do begin
section:='main';
WriteString(section,'version',cdcver);
WriteString(section,'AppDir',appdir);
WriteString(section,'PrivateDir',privatedir);
{$ifdef linux}
WriteInteger(section,'LinuxDesktop',LinuxDesktop);
WriteString(section,'OpenFileCMD',OpenFileCMD);
{$endif}
{$ifdef mswindows}
WriteBool(section,'use_xplanet',use_xplanet);
WriteString(section,'xplanet_dir',xplanet_dir);
{$endif}
WriteInteger(section,'ButtonImage',ButtonImage);
WriteBool(section,'NightVision',NightVision);
WriteString(section,'language',cfgm.language);
WriteString(section,'prtname',cfgm.prtname);
WriteInteger(section,'PrinterResolution',cfgm.PrinterResolution);
WriteInteger(section,'PrintColor',cfgm.PrintColor);
WriteBool(section,'PrintLandscape',cfgm.PrintLandscape);
WriteInteger(section,'PrintMethod',cfgm.PrintMethod);
WriteString(section,'PrintCmd1',cfgm.PrintCmd1);
WriteString(section,'PrintCmd2',cfgm.PrintCmd2);
WriteString(section,'PrintTmpPath',cfgm.PrintTmpPath);
WriteString(section,'ThemeName',cfgm.ThemeName);
WriteBool(section,'WinMaximize',(f_main.WindowState=wsMaximized));
WriteBool(section,'AzNorth',catalog.cfgshr.AzNorth);
WriteBool(section,'ListStar',catalog.cfgshr.ListStar);
WriteBool(section,'ListNeb',catalog.cfgshr.ListNeb);
WriteBool(section,'ListVar',catalog.cfgshr.ListVar);
WriteBool(section,'ListDbl',catalog.cfgshr.ListDbl);
WriteBool(section,'ListPla',catalog.cfgshr.ListPla);
WriteInteger(section,'autorefreshdelay',cfgm.autorefreshdelay);
WriteString(section,'Constellationfile',cfgm.Constellationfile);
WriteString(section,'ConstLfile',cfgm.ConstLfile);
WriteString(section,'ConstBfile',cfgm.ConstBfile);
WriteString(section,'EarthMapFile',cfgm.EarthMapFile);
WriteString(section,'PlanetDir',cfgm.PlanetDir);
WriteString(section,'horizonfile',cfgm.horizonfile);
WriteString(section,'ServerIPaddr',cfgm.ServerIPaddr);
WriteString(section,'ServerIPport',cfgm.ServerIPport);
WriteBool(section,'keepalive',cfgm.keepalive);
WriteBool(section,'AutostartServer',cfgm.AutostartServer);
WriteInteger(section,'dbtype',ord(DBtype));
WriteString(section,'dbhost',cfgm.dbhost);
WriteInteger(section,'dbport',cfgm.dbport);
WriteString(section,'db',cfgm.db);
WriteString(section,'dbuser',cfgm.dbuser);
WriteString(section,'dbpass',encryptStr(cfgm.dbpass,encryptpwd));
WriteString(section,'ImagePath',cfgm.ImagePath);
WriteFloat(section,'ImageLuminosity',cfgm.ImageLuminosity);
WriteFloat(section,'ImageContrast',cfgm.ImageContrast);
WriteBool(section,'ShowChartInfo',cfgm.ShowChartInfo);
WriteBool(section,'SyncChart',cfgm.SyncChart);
WriteBool(section,'IndiAutostart',def_cfgsc.IndiAutostart);
WriteString(section,'IndiServerHost',def_cfgsc.IndiServerHost);
WriteString(section,'IndiServerPort',def_cfgsc.IndiServerPort);
WriteString(section,'IndiServerCmd',def_cfgsc.IndiServerCmd);
WriteString(section,'IndiDriver',def_cfgsc.IndiDriver);
WriteString(section,'IndiPort',def_cfgsc.IndiPort);
WriteString(section,'IndiDevice',def_cfgsc.IndiDevice);
WriteBool(section,'IndiTelescope',def_cfgsc.IndiTelescope);
WriteString(section,'ScopePlugin',def_cfgsc.ScopePlugin);
WriteBool(section,'ViewMainBar',toolbar1.visible);
WriteBool(section,'ViewLeftBar',PanelLeft.visible);
WriteBool(section,'ViewRightBar',PanelRight.visible);
WriteBool(section,'ViewObjectBar',toolbar4.visible);
WriteInteger(section,'NumChart',MDIChildcount);
section:='catalog';
for i:=1 to maxstarcatalog do begin
   WriteString(section,'starcatpath'+inttostr(i),catalog.cfgcat.starcatpath[i]);
end;
for i:=1 to maxvarstarcatalog do begin
   WriteString(section,'varstarcatpath'+inttostr(i),catalog.cfgcat.varstarcatpath[i]);
end;
for i:=1 to maxdblstarcatalog do begin
   WriteString(section,'dblstarcatpath'+inttostr(i),catalog.cfgcat.dblstarcatpath[i]);
end;
for i:=1 to maxnebcatalog do begin
   WriteString(section,'nebcatpath'+inttostr(i),catalog.cfgcat.nebcatpath[i]);
end;
section:='dss';
WriteBool(section,'dssnorth',f_getdss.cfgdss.dssnorth);
WriteBool(section,'dsssouth',f_getdss.cfgdss.dsssouth);
WriteBool(section,'dss102',f_getdss.cfgdss.dss102);
WriteBool(section,'dsssampling',f_getdss.cfgdss.dsssampling);
WriteBool(section,'dssplateprompt',f_getdss.cfgdss.dssplateprompt);
WriteInteger(section,'dssmaxsize',f_getdss.cfgdss.dssmaxsize);
WriteString(section,'dssdir',f_getdss.cfgdss.dssdir);
WriteString(section,'dssdrive',f_getdss.cfgdss.dssdrive);
WriteString(section,'dssfile',f_getdss.cfgdss.dssfile);
Updatefile;
end;
finally
 inif.Free;
end;
end;

procedure Tf_main.SaveQuickSearch(filename:string);
var i,j:integer;
    inif: TMemIniFile;
    section : string;
    {$ifdef mswindows}
    instini: TIniFile;
    {$endif}
begin
inif:=TMeminifile.create(filename);
try
with inif do begin
section:='quicksearch';
j:=min(MaxQuickSearch,quicksearch.Items.count);
WriteInteger(section,'count',j);
for i:=1 to j do WriteString(section,'item'+inttostr(i),quicksearch.Items[i-1]);
Updatefile;
end;
finally
 inif.Free;
end;
{$ifdef mswindows}
 // hard to locate the main .ini file, the location depend on the Windows version
 // put this one in the system default location (C:\windows) to locate the install path
 // To be read by external software only
 instini:=TIniFile.Create('cdc_install.ini');
 instini.WriteString('Default','Install_Dir',appdir);
 instini.free;
{$endif}
end;

procedure Tf_main.SaveConfigOnExitExecute(Sender: TObject);
var inif: TMemIniFile;
    section : string;
begin
SaveConfigOnExit.Checked:=not SaveConfigOnExit.Checked;
inif:=TMeminifile.create(configfile);
try
with inif do begin
section:='main';
WriteBool(section,'SaveConfigOnExit',SaveConfigOnExit.Checked);
Updatefile;
end;
finally
 inif.Free;
end;
end;

procedure Tf_main.SetLang;
var i:integer;
    inif: TMemIniFile;
    section : string;
begin
helpdir:=slash(appdir)+slash('doc')+slash(trim(cfgm.language));
inif:=TMeminifile.create(slash(appdir)+slash('data')+slash('language')+'cdclang_'+trim(cfgm.language)+'.ini');
try
with inif do begin
section:='main';
ldeg:=ReadString(section,'ldeg',ldeg);
lmin:=ReadString(section,'lmin',lmin);
lsec:=ReadString(section,'lsec',lsec);
section:='detail_label';
for i:=1 to NumLlabel do begin
  catalog.cfgshr.llabel[i]:=ReadString(section,'m_'+trim(inttostr(i)),deftxt);
end;
end;
TimeU.Items.Clear;
TimeU.Items.Add('Hour');
TimeU.Items.Add('Minute');
TimeU.Items.Add('Second');
TimeU.Items.Add('Day');
TimeU.Items.Add('Month');
TimeU.Items.Add('Year');
TimeU.Items.Add('Julian Year');
TimeU.Items.Add('Tropical Year');
TimeU.Items.Add('Sideral Day');
TimeU.Items.Add('Synodic Month');
TimeU.Items.Add('Saros');
TimeU.ItemIndex:=0;
finally
 inif.Free;
end;
end;

procedure Tf_main.quicksearchClick(Sender: TObject);
var key:word;
begin
 key:=key_cr;
 quicksearchKeyDown(Sender,key,[]);
end;

procedure Tf_main.quicksearchKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
var ok : Boolean;
    num : string;
    i : integer;
begin
if key<>key_cr then exit;  // wait press Enter
Num:=trim(quicksearch.text);
ok:=GenericSearch('',num);
if ok then begin
      i:=quicksearch.Items.IndexOf(Num);
      if i=-1 then i:=MaxQuickSearch-1;
      quicksearch.Items.Delete(i);
      quicksearch.Items.Insert(0,Num);
      quicksearch.ItemIndex:=0;
   end
   else begin
      SetLPanel1(Num+'  Not found in any installed catalog index.');
   end;
end;


function Tf_main.GenericSearch(cname,Num:string):boolean;
var ok : Boolean;
    ar1,de1 : Double;
    i : integer;
    chart:TForm;
label findit;
begin
result:=false;
if trim(num)='' then exit;
chart:=nil;
if cname='' then begin
  if ActiveMdiChild is Tf_chart then chart:=ActiveMdiChild;
end else begin
 for i:=0 to MDIChildCount-1 do
   if MDIChildren[i] is Tf_chart then
      if MDIChildren[i].caption=cname then chart:=MDIChildren[i];
end;
if chart is Tf_chart then with chart as Tf_chart do begin
   ok:=catalog.SearchNebulae(Num,ar1,de1) ;
   if ok then goto findit;
   ok:=catalog.SearchStar(Num,ar1,de1) ;
   if ok then goto findit;
   ok:=catalog.SearchDblStar(Num,ar1,de1) ;
   if ok then goto findit;
   ok:=catalog.SearchVarStar(Num,ar1,de1) ;
   if ok then goto findit;
   ok:=planet.FindPlanetName(trim(Num),ar1,de1,sc.cfgsc);
   if ok then goto findit;
   ok:=planet.FindAsteroidName(trim(Num),ar1,de1,sc.cfgsc);
   if ok then goto findit;
   ok:=planet.FindCometName(trim(Num),ar1,de1,sc.cfgsc);
   if ok then goto findit;

Findit:
   result:=ok;
   if ok then begin
      sc.cfgsc.TrackOn:=false;
      IdentLabel.visible:=false;
      precession(jd2000,sc.cfgsc.JDchart,ar1,de1);
      sc.movetoradec(ar1,de1);
      Refresh;
      if sc.cfgsc.fov>0.17 then sc.FindatRaDec(ar1,de1,0.0005,true)
                        else sc.FindatRaDec(ar1,de1,0.00005,true);
      ShowIdentLabel;
      f_main.SetLpanel1(wordspace(sc.cfgsc.FindDesc),caption);
   end;
end;
end;

procedure Tf_main.UpdateBtn(fx,fy:integer;tc:boolean;sender:TObject);
begin
if ActiveMDIchild=sender then begin
  if fx>0 then begin FlipButtonX.ImageIndex:=15 ; Flipx1.checked:=false; end
          else begin FlipButtonX.ImageIndex:=16 ; Flipx1.checked:=true;  end;
  if fy>0 then begin FlipButtonY.ImageIndex:=17 ; Flipy1.checked:=false; end
          else begin FlipButtonY.ImageIndex:=18 ; Flipy1.checked:=true; end;
  if tc   then begin
               TConnect.ImageIndex:=49;
               TelescopeConnect.Hint:='Disconnect Telescope';
          end else begin
               TConnect.ImageIndex:=48;
               TelescopeConnect.Hint:='Connect Telescope';
          end;
  with ActiveMdiChild as Tf_chart do begin
    toolbuttonshowStars.down:=sc.cfgsc.showstars;
    ShowStars1.checked:=sc.cfgsc.showstars;
    toolbuttonshowNebulae.down:=sc.cfgsc.shownebulae;
    ShowNebulae1.checked:=sc.cfgsc.shownebulae;
    toolbuttonShowPictures.down:=sc.cfgsc.ShowImages;
    ToolButtonShowBackgroundImage.down:=sc.cfgsc.ShowBackgroundImage;
    ShowPictures1.checked:=sc.cfgsc.ShowImages;
    toolbuttonShowLines.down:=sc.cfgsc.ShowLine;
    ShowLines1.checked:=sc.cfgsc.ShowLine;
    toolbuttonShowAsteroids.down:=sc.cfgsc.ShowAsteroid;
    ShowAsteroids1.checked:=sc.cfgsc.ShowAsteroid;
    toolbuttonShowComets.down:=sc.cfgsc.ShowComet;
    ShowComets1.checked:=sc.cfgsc.ShowComet;
    toolbuttonShowPlanets.down:=sc.cfgsc.ShowPlanet;
    ShowPlanets1.checked:=sc.cfgsc.ShowPlanet;
    toolbuttonShowMilkyWay.down:=sc.cfgsc.ShowMilkyWay;
    ShowMilkyWay.checked:=sc.cfgsc.ShowMilkyWay;
    toolbuttonShowlabels.down:=sc.cfgsc.Showlabelall;
    toolbuttonEditlabels.down:=sc.cfgsc.Editlabels;
    ShowLabels1.checked:=sc.cfgsc.Showlabelall;
    toolbuttonGrid.down:=sc.cfgsc.ShowGrid;
    Grid1.checked:=sc.cfgsc.ShowGrid;
    toolbuttonGridEq.down:=sc.cfgsc.ShowEqGrid;
    GridEQ1.checked:=sc.cfgsc.ShowEqGrid;
    ToolButtonShowConstellationLine.down:=sc.cfgsc.ShowConstl;
    ShowConstellationLine1.checked:=sc.cfgsc.ShowConstl;
    ToolButtonShowConstellationLimit.down:=sc.cfgsc.ShowConstB;
    ShowConstellationLimit1.checked:=sc.cfgsc.ShowConstB;
    ToolButtonShowGalacticEquator.down:=sc.cfgsc.ShowGalactic;
    ShowGalacticEquator1.checked:=sc.cfgsc.ShowGalactic;
    toolbuttonShowEcliptic.down:=sc.cfgsc.ShowEcliptic;
    ShowEcliptic1.checked:=sc.cfgsc.ShowEcliptic;
    ToolButtonShowMark.down:=sc.cfgsc.ShowCircle;
    ShowMark1.checked:=sc.cfgsc.ShowCircle;
    ToolButtonShowObjectbelowHorizon.down:=not sc.cfgsc.horizonopaque;
    ShowObjectbelowthehorizon1.checked:=not sc.cfgsc.horizonopaque;
    ToolButtonswitchbackground.down:= sc.plot.cfgplot.autoskycolor;
    ToolButtonSyncChart.down:=cfgm.SyncChart;
    ToolButtonTrack.down:=sc.cfgsc.TrackOn;
    if sc.cfgsc.TrackOn then
       ToolButtonTrack.Hint:='Unlock Chart'
     else if ((sc.cfgsc.TrackType>=1)and(sc.cfgsc.TrackType<=3))or(sc.cfgsc.TrackType=6)
     then
       ToolButtonTrack.Hint:='Lock on '+sc.cfgsc.Trackname
     else
       ToolButtonTrack.Hint:='No object to lock on';
    case sc.plot.cfgplot.starplot of
    0: begin ToolButtonswitchstars.down:=true; ToolButtonswitchstars.marked:=true; ButtonStarSize.visible:=false; starsizepanel.Visible:=false; end;
    1: begin ToolButtonswitchstars.down:=true; ToolButtonswitchstars.marked:=false; ButtonStarSize.visible:=false; starsizepanel.Visible:=false; end;
    2: begin ToolButtonswitchstars.down:=false; ToolButtonswitchstars.marked:=false; ButtonStarSize.visible:=true; end;
    end;
    trackbar1.position:=round(sc.plot.cfgplot.partsize*10);
    trackbar2.position:=round(sc.plot.cfgplot.magsize*10);
    trackbar3.position:=sc.plot.cfgplot.contrast;
    trackbar4.position:=sc.plot.cfgplot.saturation;
    toolbuttonEQ.down:= (sc.cfgsc.projpole=Equat);
    toolbuttonAZ.down:= (sc.cfgsc.projpole=AltAz);
    toolbuttonEC.down:= (sc.cfgsc.projpole=Ecl);
    toolbuttonGL.down:= (sc.cfgsc.projpole=Gal);
    EquatorialCoordinate1.checked:= toolbuttonEQ.down;
    AltAzProjection1.checked:= toolbuttonAZ.down;
    EclipticProjection1.checked:= toolbuttonEC.down;
    GalacticProjection1.checked:= toolbuttonGL.down;
    Field1.caption:= DEToStrmin(sc.catalog.cfgshr.FieldNum[0]);
    Field2.caption:= DEToStrmin(sc.catalog.cfgshr.FieldNum[1]);
    Field3.caption:= DEToStrmin(sc.catalog.cfgshr.FieldNum[2]);
    Field4.caption:= DEToStrmin(sc.catalog.cfgshr.FieldNum[3]);
    Field5.caption:= DEToStrmin(sc.catalog.cfgshr.FieldNum[4]);
    Field6.caption:= DEToStrmin(sc.catalog.cfgshr.FieldNum[5]);
    Field7.caption:= DEToStrmin(sc.catalog.cfgshr.FieldNum[6]);
    Field8.caption:= DEToStrmin(sc.catalog.cfgshr.FieldNum[7]);
    Field9.caption:= DEToStrmin(sc.catalog.cfgshr.FieldNum[8]);
    Field10.caption:= DEToStrmin(sc.catalog.cfgshr.FieldNum[9]);
    SetFov1.caption:=Field1.caption;
    SetFov2.caption:=Field2.caption;
    SetFov3.caption:=Field3.caption;
    SetFov4.caption:=Field4.caption;
    SetFov5.caption:=Field5.caption;
    SetFov6.caption:=Field6.caption;
    SetFov7.caption:=Field7.caption;
    SetFov8.caption:=Field8.caption;
    SetFov9.caption:=Field9.caption;
    SetFov10.caption:=Field10.caption;
  end;
end;
end;

procedure Tf_main.ChartMove(Sender: TObject);
begin
if ActiveMDIchild=sender then begin   // active chart refresh
  application.processmessages; 
  if cfgm.SyncChart then SyncChild;
end;
end;

procedure Tf_main.ButtonStarSizeClick(Sender: TObject);
begin
starsizepanel.Visible:= not starsizepanel.Visible;
end;

Function Tf_main.NewChart(cname:string):string;
begin
if cname='' then cname:='Chart_' + IntToStr(MDIChildCount + 1);
cname:=GetUniqueName(cname,false);
if CreateMDIChild(cname,true,def_cfgsc,def_cfgplot) then result:=msgOK+blank+cname
  else result:=msgFailed;
end;

Function Tf_main.CloseChart(cname:string):string;
var i: integer;
begin
result:=msgNotFound;
for i:=0 to MDIChildCount-1 do
  if MDIChildren[i] is Tf_chart then
     with MDIChildren[i] as Tf_chart do
        if caption=cname then begin
           Close;
           result:=msgOK;
        end;
end;

Function Tf_main.ListChart:string;
var i: integer;
begin
result:='';
for i:=0 to MDIChildCount-1 do
  if MDIChildren[i] is Tf_chart then
     with MDIChildren[i] as Tf_chart do
        result:=result+';'+caption;

if result>'' then result:=msgOK+blank+result+';'
             else result:=msgFailed+blank+'No Chart!';
end;

Function Tf_main.SelectChart(cname:string):string;
var i: integer;
begin
result:=msgNotFound;
for i:=0 to MDIChildCount-1 do
  if MDIChildren[i] is Tf_chart then
     with MDIChildren[i] as Tf_chart do
        if caption=cname then begin
          {$ifdef linux}
          {require to switch the focus to work with the right child. Kylix bug?}
          try
          if MDIChildCount>2 then MDIChildren[1].setfocus // MDIChildren[0] already as focus
                             else quicksearch.setfocus;
          except
          // here if quicksearch is hiden, do nothing.
          end;
         {$endif}
         setfocus;
         result:=msgOK;
        end;
end;

function Tf_main.ExecuteCmd(cname:string; arg:Tstringlist):string;
var i,n : integer;
    var cmd:string;
begin
cmd:=trim(uppercase(arg[0]));
n:=-1;
for i:=1 to numcmdmain do
   if cmd=maincmdlist[i,1] then begin
      n:=strtointdef(maincmdlist[i,2],-1);
      break;
   end;
case n of
 1 : result:=NewChart(arg[1]);
 2 : result:=CloseChart(arg[1]);
 3 : result:=SelectChart(arg[1]);
 4 : result:=ListChart;
 5 : if Genericsearch(cname,arg[1]) then result:=msgOK else result:=msgNotFound;
 6 : result:=msgOK+blank+LPanels1.Caption;
 7 : result:=msgOK+blank+LPanels0.Caption;
 8 : result:=msgOK+blank+topmsg;
 9 :  ;// find
 10 : ;// save
 11 : ;// load
else begin
 result:='Bad chart name '+cname;
 for i:=0 to MDIChildCount-1 do
   if MDIChildren[i] is Tf_chart then
     with MDIChildren[i] as Tf_chart do
       if caption=cname then
         result:=ExecuteCmd(arg);
end;
end;
end;

procedure Tf_main.SendInfo(Sender: TObject; origin,str:string);
var i : integer;
begin
for i:=1 to Maxwindow do
 if (TCPDaemon<>nil)
    and(TCPDaemon.ThrdActive[i])
    and (TCPDaemon.TCPThrd[i]<>nil)
    and(TCPDaemon.TCPThrd[i].Fsock<>nil)
    and(not TCPDaemon.TCPThrd[i].terminated)
    then TCPDaemon.TCPThrd[i].SendData('>'+tab+origin+' :'+tab+str);
{$ifdef mswindows}
if DDEopen then begin
   DdeInfo[0]:=formatdatetime('c',now);
   DdeInfo[2]:='> '+origin+' : '+str;
   if sender is Tf_Chart then with sender as Tf_Chart do begin
      DdeInfo[1]:='RA:'+arptostr(rad2deg*sc.cfgsc.racentre/15)+' DEC:'+deptostr(rad2deg*sc.cfgsc.decentre)+' FOV:'+detostr(rad2deg*sc.cfgsc.fov);
      DdeInfo[3]:=Date2Str(sc.cfgsc.CurYear,sc.cfgsc.curmonth,sc.cfgsc.curday)+'T'+TimtoStr(sc.cfgsc.Curtime);
      DdeInfo[4]:='LAT:'+detostr3(sc.cfgsc.ObsLatitude)+' LON:'+detostr3(sc.cfgsc.ObsLongitude)+' ALT:'+floattostr(sc.cfgsc.ObsAltitude)+'m OBS:'+sc.cfgsc.ObsName;
   end else begin
      DdeInfo[1]:='';
      DdeInfo[3]:='';
      DdeInfo[4]:='';
   end;
   DdeData.Lines:=DdeInfo;
end;
{$endif}
end;

{ TCP/IP Connexion, based on Synapse Echo demo }

Constructor TTCPDaemon.Create;
begin
  FreeOnTerminate:=true;
  keepalive:=false;
  inherited create(false);
end;

procedure TTCPDaemon.ShowError;
begin
f_main.SetLpanel1('Socket error '+inttostr(sock.lasterror)+'.  '+sock.GetErrorDesc(sock.lasterror));
end;

procedure TTCPDaemon.ShowSocket;

var locport:string;

begin
sock.GetSins;
locport:=inttostr(sock.GetLocalSinPort);
if locport<>f_main.cfgm.ServerIPport then locport:=locport+' (different than configured port, maybe busy or other error.)';
f_main.serverinfo:='Listen on port: '+locport;
f_main.SetLpanel1(f_main.serverinfo);
end;

procedure TTCPDaemon.GetActiveChart;
begin
  if f_main.ActiveMDIchild is Tf_chart then
    active_chart:=f_main.ActiveMDIchild.caption
  else
    active_chart:=f_main.newchart('');
end;

procedure TTCPDaemon.Execute;
var
  ClientSock:TSocket;
  i,n : integer;
begin
for i:=1 to MaxWindow do ThrdActive[i]:=false;
sock:=TTCPBlockSocket.create;
try
  with sock do
    begin
      CreateSocket;
      if lasterror<>0 then Synchronize(ShowError);
      MaxLineLength:=1024;
      setLinger(true,10);
      if lasterror<>0 then Synchronize(ShowError);
      bind(f_main.cfgm.ServerIPaddr,f_main.cfgm.ServerIPport);
      if lasterror<>0 then Synchronize(ShowError);
      listen;
      if lasterror<>0 then Synchronize(ShowError);
      Synchronize(ShowSocket);
      repeat
        if terminated then break;
        if canread(1000) and (not terminated) then
          begin
            ClientSock:=accept;
            if lastError=0 then begin
              n:=-1;
              for i:=1 to Maxwindow do
                 if (not ThrdActive[i])
                    or(TCPThrd[i]=nil)
                    or(TCPThrd[i].Fsock=nil)
                    or(TCPThrd[i].terminated)
                    then begin
                      n:=i;
                      break;
                    end;
              if n>0 then begin
                 TCPThrd[n]:=TTCPThrd.create(ClientSock);
                 TCPThrd[n].keepalive:=keepalive;
                 i:=0; while (TCPThrd[n].Fsock=nil)and(i<100) do begin sleep(100); inc(i); end;
                 if not TCPThrd[n].terminated then begin
                      TCPThrd[n].id:=n;
                      ThrdActive[n]:=true;
                      Synchronize(GetActiveChart);
                      if active_chart=msgFailed then
                        TCPThrd[n].senddata(msgFailed+' Cannot activate a chart.')
                      else begin
                        TCPThrd[n].active_chart:=active_chart;
                        TCPThrd[n].senddata(msgOK+' id='+inttostr(n)+' chart='+active_chart);
                      end;
                 end;
              end else
                 with TTCPThrd.create(ClientSock) do begin
                   i:=0; while (sock=nil)and(i<100) do begin sleep(100); inc(i); end;
                   if not terminated then begin
                      if Sock<>nil then Sock.SendString(msgFailed+' Maximum connection reach!'+CRLF);
                      terminate;
                   end;
              end;
            end
            else Synchronize(ShowError);
          end;
      until false;
    end;
finally
  terminate;
  Sock.CloseSocket;
  Sock.free;
end;
end;

Constructor TTCPThrd.Create(Hsock:TSocket);
begin
  Csock := Hsock;
  FreeOnTerminate:=true;
  cmd:=TStringlist.create;
  keepalive:=false;
  abort:=false;
  inherited create(false);
end;

procedure TTCPThrd.Execute;
var
  s: string;
  i: integer;
begin
  Fsock:=TTCPBlockSocket.create;
  FConnectTime:=now;
  try
    Fsock.socket:=CSock;
    Fsock.GetSins;
    Fsock.MaxLineLength:=1024;
    remoteip:=Fsock.GetRemoteSinIP;
    remoteport:=inttostr(Fsock.GetRemoteSinPort);
    with Fsock do
      begin
        repeat
          if terminated then break;
          s := RecvString(1000);
          //if s<>'' then writetrace(s);   // for debuging only, not thread safe!
          if lastError=0 then begin
             if (uppercase(s)='QUIT')or(uppercase(s)='EXIT') then break;
             splitarg(s,' ',cmd);
             for i:=cmd.count to MaxCmdArg do cmd.add('');
             Synchronize(ExecuteCmd);
             SendString(cmdresult+crlf);
             if lastError<>0 then break;
             if (cmdresult=msgOK)and(uppercase(cmd[0])='SELECTCHART') then active_chart:=cmd[1];
          end else
             if keepalive then begin
                SendString('.'+crlf);        // keepalive check
                if lastError<>0 then break;  // if send failed we close the connection
          end;
        until false;
      end;
  finally
    terminate;
    f_main.TCPDaemon.ThrdActive[id]:=false;
    Fsock.SendString(msgBye+crlf);
    Fsock.CloseSocket;
    Fsock.Free;
    cmd.free;
  end;
end;

procedure TTCPThrd.Senddata(str:string);
begin
try
if Fsock<>nil then
 with Fsock do begin
   if terminated then exit;
   SendString(str+CRLF);
   if LastError<>0 then
      terminate;
 end;
except
terminate;
end;
end;

procedure TTCPThrd.ExecuteCmd;
begin
cmdresult:=f_main.ExecuteCmd(active_chart,cmd);
end;

procedure Tf_main.StartServer;
begin
 try
 TCPDaemon:=TTCPDaemon.create;
 TCPDaemon.keepalive:=cfgm.keepalive;
 except
  SetLpanel1('TCP/IP service not available.');
 end;
end;

procedure Tf_main.StopServer;
var i :integer;
//    d :double;
begin
if TCPDaemon=nil then exit;
try
screen.cursor:=crHourglass;
for i:=1 to Maxwindow do
 if (TCPDaemon.TCPThrd[i]<>nil) then
    TCPDaemon.TCPThrd[i].terminate;
application.processmessages;
TCPDaemon.terminate;
//d:=now+1.7E-5;  // 1.5 seconde delay to close the thread
//while now<d do application.processmessages;
screen.cursor:=crDefault;
except
 screen.cursor:=crDefault;
end;
end;

procedure Tf_main.ConnectDB;
begin
try
    NeedToInitializeDB:=false;
    if ((DBtype=sqlite) and not Fileexists(cfgm.db)) then
       ForceDirectories(Extractfilepath(cfgm.db));
    if (cdcdb.ConnectDB(cfgm.dbhost,cfgm.db,cfgm.dbuser,cfgm.dbpass,cfgm.dbport)
       and cdcdb.CheckDB) then begin
          planet.ConnectDB(cfgm.dbhost,cfgm.db,cfgm.dbuser,cfgm.dbpass,cfgm.dbport);
          Fits.ConnectDB(cfgm.dbhost,cfgm.db,cfgm.dbuser,cfgm.dbpass,cfgm.dbport);
          SetLpanel1('Connected to SQL database '+cfgm.db);
    end else begin
          SetLpanel1('SQL database not available.');
          def_cfgsc.ShowAsteroid:=false;
          def_cfgsc.ShowComet:=false;
          def_cfgsc.ShowImages:=false;
    end;
    if NeedToInitializeDB then begin
       f_info.setpage(2);
       f_info.show;
       f_info.ProgressMemo.lines.add('Initialize Database');
       cdcdb.LoadSampleData(f_info.ProgressMemo);
       Planet.PrepareAsteroid(DateTimetoJD(now), f_info.ProgressMemo.lines);
       def_cfgsc.ShowAsteroid:=true;
       f_info.close;
    end;
except
  SetLpanel1('SQL database not available.');
end;
end;

procedure Tf_main.InitializeDB(Sender: TObject);
begin
  NeedToInitializeDB:=true;
end;

procedure Tf_main.ViewInfoExecute(Sender: TObject);
begin
f_info.setpage(0);
f_info.show;
end;

procedure Tf_main.showdetailinfo(chart:string;ra,dec:double;nm,desc:string);
var i : integer;
begin
for i:=0 to MDIChildCount-1 do
 if MDIChildren[i] is Tf_chart then
   if MDIChildren[i].caption=chart then with MDIChildren[i] as Tf_chart do begin
      sc.cfgsc.FindRa:=ra;
      sc.cfgsc.FindDec:=dec;
      sc.cfgsc.FindDesc:=desc;
      sc.cfgsc.FindName:=nm;
      sc.cfgsc.FindNote:='';
      sc.cfgsc.FindOK:=true;
      sc.cfgsc.FindSize:=0;
      ShowIdentLabel;
      identlabelClick(nil);
      break;
end;
end;

procedure Tf_main.CenterFindObj(chart:string);
var i : integer;
begin
for i:=0 to MDIChildCount-1 do
 if MDIChildren[i] is Tf_chart then
   if MDIChildren[i].caption=chart then with MDIChildren[i] as Tf_chart do begin
     sc.cfgsc.racentre:=sc.cfgsc.FindRa;
     sc.cfgsc.decentre:=sc.cfgsc.FindDec;
     Refresh;
     break;
end;
end;

procedure Tf_main.NeighborObj(chart:string);
var i :integer;
    x,y:single;
    x1,y1: double;
begin
for i:=0 to MDIChildCount-1 do
 if MDIChildren[i] is Tf_chart then
   if MDIChildren[i].caption=chart then with MDIChildren[i] as Tf_chart do begin
     projection(sc.cfgsc.FindRa,sc.cfgsc.FindDec,x1,y1,true,sc.cfgsc) ;
     WindowXY(x1,y1,x,y,sc.cfgsc);
     ListXY(round(x),round(y));
     break;
end;
end;

procedure Tf_main.ImageSetFocus(Sender: TObject);
begin
// to restore focus to the chart that as no text control
// it is also mandatory to keep the keydown and mousewheel
// event to the main form.
{$ifdef linux}
  activecontrol:=nil;
{$endif}
{$ifdef mswindows}
  quicksearch.Enabled:=false;   // add all main form focusable control here
  TimeVal.Enabled:=false;
  TimeU.Enabled:=false;
  TrackBar1.Enabled:=false;
  TrackBar2.Enabled:=false;
  TrackBar3.Enabled:=false;
  TrackBar4.Enabled:=false;
  quicksearch.Enabled:=true;
  TimeVal.Enabled:=true;
  TimeU.Enabled:=true;
  TrackBar1.Enabled:=true;
  TrackBar2.Enabled:=true;
  TrackBar3.Enabled:=true;
  TrackBar4.Enabled:=true;
  setfocus;
{$endif}
end;

procedure Tf_main.ListInfo(buf:string);
begin
f_info.Memo1.text:=buf;
f_info.Memo1.selstart:=0;
f_info.Memo1.sellength:=0;
f_info.setpage(1);
f_info.source_chart:=caption;
f_info.show;
end;

procedure Tf_main.GetTCPInfo(i:integer; var buf:string);
begin
if (TCPDaemon<>nil) then
 with TCPDaemon do begin
   if (not TCPDaemon.ThrdActive[i])
     or(TCPThrd[i]=nil)
     or(TCPThrd[i].sock=nil)
     or(TCPThrd[i].terminated)
     then begin
       buf:=inttostr(i)+' not connected.';
     end
     else begin
       buf:=inttostr(i)+' connected from '+TCPThrd[i].RemoteIP+blank+TCPThrd[i].RemotePort+', using chart '+TCPThrd[i].active_chart+', connect time:'+datetimetostr(TCPThrd[i].connecttime);
     end;
 end
   else buf:='';    
end;

procedure Tf_main.KillTCPClient(i:integer);
begin
if (i>0)
   and(TCPDaemon.ThrdActive[i])
   and(TCPDaemon<>nil)
   and(TCPDaemon.TCPThrd[i]<>nil)
   then TCPDaemon.TCPThrd[i].Terminate;
end;

procedure Tf_main.PrintSetup(Sender: TObject);
begin
FilePrintSetup1.Execute;
end;                                              

procedure Tf_main.FilePrintSetup1Execute(Sender: TObject);
begin
f_printsetup.cm:=cfgm;
formpos(f_printsetup,mouse.cursorpos.x,mouse.cursorpos.y);
if f_printsetup.showmodal=mrOK then begin
 cfgm:=f_printsetup.cm;
end;
end;

procedure Tf_main.SetButtonImage(button: Integer);
var btn : TBitmap;
    col: Tcolor;
begin
btn:=TBitmap.Create;
btn.canvas.pen.color:=clBlack;
btn.canvas.brush.color:=clBlack;
btn.canvas.brush.style:=bsSolid;
col:=clNavy;
try
case button of
 1:begin
   ActionList1.Images:=ImageList1;
   Toolbar1.Images:=ImageList1;
   Toolbar2.Images:=ImageList1;
   Toolbar3.Images:=ImageList1;
   Toolbar4.Images:=ImageList1;
   ImageList1.GetBitmap(52,btn); SpeedButtonMoreStar.Glyph:=btn;
   btn.canvas.rectangle(0,0,btn.width,btn.height);
   ImageList1.GetBitmap(53,btn); SpeedButtonLessStar.Glyph:=btn;
   btn.canvas.rectangle(0,0,btn.width,btn.height);
   ImageList1.GetBitmap(54,btn); SpeedButtonMoreNeb.Glyph:=btn;
   btn.canvas.rectangle(0,0,btn.width,btn.height);
   ImageList1.GetBitmap(55,btn); SpeedButtonLessNeb.Glyph:=btn;
   Normal1.Checked:=true;
   end;
 2:begin
   col:=$acb5f5;
   ActionList1.Images:=ImageList2;
   Toolbar1.Images:=ImageList2;
   Toolbar2.Images:=ImageList2;
   Toolbar3.Images:=ImageList2;
   Toolbar4.Images:=ImageList2;
   ImageList2.GetBitmap(52,btn); SpeedButtonMoreStar.Glyph:=btn;
   btn.canvas.rectangle(0,0,btn.width,btn.height);
   ImageList2.GetBitmap(53,btn); SpeedButtonLessStar.Glyph:=btn;
   btn.canvas.rectangle(0,0,btn.width,btn.height);
   ImageList2.GetBitmap(54,btn); SpeedButtonMoreNeb.Glyph:=btn;
   btn.canvas.rectangle(0,0,btn.width,btn.height);
   ImageList2.GetBitmap(55,btn); SpeedButtonLessNeb.Glyph:=btn;
   Reverse1.Checked:=true;
   end;
end;
Field1.font.color:=col;
Field2.font.color:=col;
Field3.font.color:=col;
Field4.font.color:=col;
Field5.font.color:=col;
Field6.font.color:=col;
Field7.font.color:=col;
Field8.font.color:=col;
Field9.font.color:=col;
Field10.font.color:=col;
finally
 btn.Free;
end;
end;

procedure Tf_main.ButtonModeClick(Sender: TObject);
begin
ButtonImage:=(sender as TMenuItem).Tag;
SetButtonImage(ButtonImage);
end;
