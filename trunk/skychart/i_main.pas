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
begin
 // some initialisation that need to be done after all the forms are created. Kylix onShow is called immediatly after onCreate, not after application.run!
 f_info.onGetTCPinfo:=GetTCPInfo;
 f_info.onKillTCP:=KillTCPClient;
 f_info.onPrintSetup:=PrintSetup;
 f_info.OnShowDetail:=showdetailinfo;
 f_detail.OnCenterObj:=CenterFindObj;
 f_detail.OnNeighborObj:=NeighborObj;
end;

function Tf_main.CreateMDIChild(const CName: string; copyactive,linkactive: boolean; cfg1 : conf_skychart; cfgp : conf_plot; locked:boolean=false):boolean;
var
  Child : Tf_chart;
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
  Child.onShowInfo:=SetLpanel1;
  Child.onShowCoord:=SetLpanel0;
  Child.onListInfo:=ListInfo;
  if cfgm.maximized then Child.maximize:=true
                    else begin Child.maximize:=false;
                               Child.width:=Child.sc.cfgsc.winx;
                               Child.height:=Child.sc.cfgsc.winy;
                         end;
  if Child.sc.cfgsc.Projpole=Altaz then begin
     Child.sc.cfgsc.TrackOn:=true;
     Child.sc.cfgsc.TrackType:=4;
  end;
  {$ifdef linux}
  {require to switch the focus to work with the right child. Kylix bug?}
  try
  if MDIChildCount>2 then MDIChildren[1].setfocus // MDIChildren[0] already as focus
                     else quicksearch.setfocus;
  except
    // here if quicksearch is hiden, do nothing.
  end;
  {$endif}
  Child.setfocus;
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
c2.AstmagMax := c1.AstmagMax;
c2.AstmagDiff := c1.AstmagDiff;
c2.AstSymbol := c1.AstSymbol;
c2.ShowComet := c1.ShowComet ;
c2.CommagMax := c1.CommagMax;
c2.CommagDiff := c1.CommagDiff;
c2.ComSymbol := c1.ComSymbol;
c2.MagLabel := c1.MagLabel;
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
c2.HorizonMax := c1.HorizonMax ;
c2.Horizonlist := c1.Horizonlist ;
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
      sc.plot.cfgplot:=def_cfgplot;
      if applydef then begin
        CopySCconfig(def_cfgsc,sc.cfgsc);
        sc.cfgsc.FindOk:=false;
      end;
      AutoRefresh;
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
  CreateMDIChild(GetUniqueName('Chart_',true),true,true,def_cfgsc,def_cfgplot);
end;

procedure Tf_main.FileOpen1Execute(Sender: TObject);
var cfgs :conf_skychart;
    cfgp : conf_plot;
begin
if Opendialog.InitialDir='' then Opendialog.InitialDir:=privatedir;
OpenDialog.Filter:='Cartes du Ciel 3 File|*.cdc3|All Files|*.*';
  if OpenDialog.Execute then begin
    cfgp:=def_cfgplot;
    cfgs:=def_cfgsc;
    ReadChartConfig(OpenDialog.FileName,true,cfgp,cfgs);
    CreateMDIChild(GetUniqueName(stringreplace(extractfilename(OpenDialog.FileName),' ','_',[rfReplaceAll]),false) ,false,false,cfgs,cfgp);
  end;
end;

procedure Tf_main.FileSaveAs1Execute(Sender: TObject);
begin
Savedialog.DefaultExt:='cdc3';
if Savedialog.InitialDir='' then Savedialog.InitialDir:=privatedir;
savedialog.Filter:='Cartes du Ciel 3 File|*.cdc3|All Files|*.*';
if ActiveMDIchild is Tf_chart then
  if SaveDialog.Execute then SaveChartConfig(SaveDialog.Filename);
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

procedure Tf_main.FileExit1Execute(Sender: TObject);
begin
  Close;
end;

Procedure Tf_main.GetAppDir;
var inif: TMemIniFile;
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
SHGetSpecialFolderLocation(0, CSIDL_APPDATA, PIDL);
if PIDL=nil then begin // Pre-IE4.0
  SHGetSpecialFolderLocation(0, CSIDL_PERSONAL, PIDL);
end;
SHGetPathFromIDList(PIDL, Folder);
privatedir:=slash(Folder)+privatedir;
configfile:=slash(privatedir)+configfile;
tracefile:=slash(privatedir)+tracefile;
{$endif}
inif:=TMeminifile.create(configfile);
try
appdir:=inif.ReadString('main','AppDir',appdir);
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
DecimalSeparator:='.';
{$ifdef linux}
f_directory:=Tf_directory.Create(application);
configfile:=expandfilename(Defaultconfigfile);
{$endif}
{$ifdef mswindows}
configfile:=Defaultconfigfile;
{$endif}
GetAppDir;
chdir(appdir);
InitTrace;
traceon:=true;
catalog:=Tcatalog.Create(self);
planet:=Tplanet.Create(self);
Fits:=TFits.Create(self);
//planet.OnAsteroidConfig:=OpenAsteroidConfig;
//planet.OnCometConfig:=OpenCometConfig;
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
try
 SetDefault;
 ReadDefault;
{$ifdef mswindows}
 telescope.pluginpath:=slash(appdir)+slash('plugins')+slash('telescope');
 telescope.plugin:=def_cfgsc.ScopePlugin;
{$endif}
 catalog.LoadConstellation(cfgm.Constellationfile);
 catalog.LoadConstL(cfgm.ConstLfile);
 catalog.LoadConstB(cfgm.ConstBfile);
 catalog.LoadHorizon(cfgm.horizonfile,def_cfgsc);
 SetLang;
 InitFonts;
 SetLpanel1('');
 ConnectDB;
 Fits.min_sigma:=cfgm.ImageLuminosity;
 Fits.max_sigma:=cfgm.ImageContrast;
 CreateMDIChild(GetUniqueName('Chart_',true),true,true,def_cfgsc,def_cfgplot,true);
 Autorefresh.Interval:=cfgm.autorefreshdelay*1000;
 Autorefresh.enabled:=true;
 if cfgm.AutostartServer then StartServer;
except
end; 
end;

procedure Tf_main.FormDestroy(Sender: TObject);
begin
try
catalog.free;
Fits.Free;
planet.free;
{$ifdef mswindows}
telescope.free;
DdeInfo.free;
{$endif}
StopServer;
except
end;
end;

procedure Tf_main.FormClose(Sender: TObject; var Action: TCloseAction);
var i:integer;
begin
try
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

procedure Tf_main.ChangeProjExecute(Sender: TObject);
begin
if ActiveMdiChild is Tf_chart then with ActiveMdiChild as Tf_chart do begin
   inc(sc.cfgsc.projpole);
   if sc.cfgsc.projpole>Ecl then sc.cfgsc.projpole:=Equat;
   sc.cfgsc.FindOk:=false; // invalidate the search result
   Refresh;
end;
end;

procedure Tf_main.popupProjClick(Sender: TObject);
var newproj: integer;
begin
with Sender as TmenuItem do newproj:=tag;
if (newproj<Equat)or(newproj>Ecl) then newproj:=Equat;
if ActiveMdiChild is Tf_chart then with ActiveMdiChild as Tf_chart do begin
   sc.cfgsc.projpole:=newproj;
   sc.cfgsc.FindOk:=false; // invalidate the search result
   Refresh;
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

procedure Tf_main.SetFOVExecute(Sender: TObject);
var f : double;
begin
with Sender as TToolButton do f:=deg2rad*tag/60;
if ActiveMdiChild is Tf_chart then with ActiveMdiChild as Tf_chart do begin
   sc.SetFOV(f);
   Refresh;
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
   sc.cfgsc.TrackOn:=true;
   sc.cfgsc.TrackType:=4;
   Refresh;
end;
end;

procedure Tf_main.OpenConfigExecute(Sender: TObject);
begin
screen.cursor:=crHourGlass;
if f_config=nil then f_config:=Tf_config.Create(application);
try
 f_config.Fits:=fits;
 f_config.ccat:=catalog.cfgcat;
 f_config.cshr:=catalog.cfgshr;
 f_config.cplot:=def_cfgplot;
 f_config.csc:=def_cfgsc;
 if ActiveMdiChild is Tf_chart then with ActiveMdiChild as Tf_chart do
     CopySCconfig(sc.cfgsc,f_config.csc);
 f_config.cmain:=cfgm;
 f_config.applyall.checked:=cfgm.updall;
 formpos(f_config,mouse.cursorpos.x,mouse.cursorpos.y);
 f_config.topmsg.caption:='';
 f_config.TreeView1.enabled:=true;
 f_config.previous.enabled:=true;
 f_config.next.enabled:=true;
 f_config.apply.enabled:=true;
 f_config.AstDB.enabled:=true;
 f_config.CometDB.enabled:=true;
 f_config.showmodal;
 if f_config.ModalResult=mrOK then begin
   activateconfig;
 end;
 cfgm.configpage:=f_config.Treeview1.selected.absoluteindex;
finally
screen.cursor:=crDefault;
end;
end;

procedure Tf_main.OpenAsteroidConfig(Sender: TObject);
var i:integer;
begin
if f_config=nil then f_config:=Tf_config.Create(application);
if f_config.visible then exit;
screen.cursor:=crHourGlass;
try
 f_config.Fits:=fits;
 cfgm.configpage:=f_config.astpage;
 f_config.AstPageControl.activepage:=f_config.astprepare;
 f_config.ccat:=catalog.cfgcat;
 f_config.cshr:=catalog.cfgshr;
 f_config.cplot:=def_cfgplot;
 f_config.csc:=def_cfgsc;
 if ActiveMdiChild is Tf_chart then with ActiveMdiChild as Tf_chart do
     CopySCconfig(sc.cfgsc,f_config.csc);
 f_config.cmain:=cfgm;
 f_config.applyall.checked:=cfgm.updall;
 formpos(f_config,mouse.cursorpos.x,mouse.cursorpos.y);
 f_config.topmsg.caption:='No Asteroid data found for this date. Please prepare the data for at least two month, or click Cancel to disable the Asteroid display.';
 f_config.TreeView1.enabled:=false;
 f_config.previous.enabled:=false;
 f_config.next.enabled:=false;
 f_config.apply.enabled:=false;
 f_config.AstDB.enabled:=true;
 f_config.CometDB.enabled:=true;
 f_config.showmodal;
 if f_config.ModalResult=mrCancel then for i:=0 to MDIChildCount-1 do
    if MDIChildren[i] is Tf_chart then
       with MDIChildren[i] as Tf_chart do begin
          sc.cfgsc.ShowAsteroid:=false;
          sc.cfgsc.FindOk:=false;
       end;
 cfgm.configpage:=f_config.Treeview1.selected.absoluteindex;
finally
screen.cursor:=crDefault;
end;
end;

procedure Tf_main.OpenCometConfig(Sender: TObject);
var i:integer;
begin
if f_config=nil then f_config:=Tf_config.Create(application);
if f_config.visible then exit;
screen.cursor:=crHourGlass;
try
 f_config.Fits:=fits;
 cfgm.configpage:=f_config.compage;
 f_config.ComPageControl.activepage:=f_config.comload;
 f_config.ccat:=catalog.cfgcat;
 f_config.cshr:=catalog.cfgshr;
 f_config.cplot:=def_cfgplot;
 f_config.csc:=def_cfgsc;
 if ActiveMdiChild is Tf_chart then with ActiveMdiChild as Tf_chart do
     CopySCconfig(sc.cfgsc,f_config.csc);
 f_config.cmain:=cfgm;
 f_config.applyall.checked:=cfgm.updall;
 formpos(f_config,mouse.cursorpos.x,mouse.cursorpos.y);
 f_config.topmsg.caption:='No Comet element found. Please load an element file, or click Cancel to disable the Comet display.';
 f_config.TreeView1.enabled:=false;
 f_config.previous.enabled:=false;
 f_config.next.enabled:=false;
 f_config.apply.enabled:=false;
 f_config.showmodal;
 if f_config.ModalResult=mrCancel then for i:=0 to MDIChildCount-1 do
    if MDIChildren[i] is Tf_chart then
       with MDIChildren[i] as Tf_chart do begin
          sc.cfgsc.ShowComet:=false;
          sc.cfgsc.FindOk:=false;
       end;
 cfgm.configpage:=f_config.Treeview1.selected.absoluteindex;
finally
screen.cursor:=crDefault;
end;
end;

procedure Tf_main.OpenDBConfig(Sender: TObject);
begin
if f_config=nil then f_config:=Tf_config.Create(application);
if f_config.visible then exit;
screen.cursor:=crHourGlass;
try
 f_config.Fits:=fits;
 cfgm.configpage:=f_config.dbpage;
 f_config.ccat:=catalog.cfgcat;
 f_config.cshr:=catalog.cfgshr;
 f_config.cplot:=def_cfgplot;
 f_config.csc:=def_cfgsc;
 if ActiveMdiChild is Tf_chart then with ActiveMdiChild as Tf_chart do
     CopySCconfig(sc.cfgsc,f_config.csc);
 f_config.cmain:=cfgm;
 f_config.applyall.checked:=cfgm.updall;
 formpos(f_config,mouse.cursorpos.x,mouse.cursorpos.y);
 f_config.topmsg.caption:='Please set your MySQL database preferences. Use the Check button to control your input. Click Cancel to disable database function.';
 f_config.TreeView1.enabled:=false;
 f_config.previous.enabled:=false;
 f_config.next.enabled:=false;
 f_config.apply.enabled:=false;
 f_config.AstDB.enabled:=false;
 f_config.CometDB.enabled:=false;
 f_config.showmodal;
 if f_config.ModalResult=mrCancel then begin
    def_cfgsc.ShowAsteroid:=false;
 end else begin
    if directoryexists(f_config.prgdir.text) then appdir:=f_config.prgdir.text; // this setting is on the same page
    if directoryexists(f_config.persdir.text) then privatedir:=f_config.persdir.text;
    cfgm:=f_config.cmain;
 end;
 cfgm.configpage:=f_config.Treeview1.selected.absoluteindex;
finally
screen.cursor:=crDefault;
end;
end;

procedure Tf_main.activateconfig;
begin
    if directoryexists(f_config.prgdir.text) then appdir:=f_config.prgdir.text;
    if directoryexists(f_config.persdir.text) then privatedir:=f_config.persdir.text;
    cfgm:=f_config.cmain;
    cfgm.updall:=f_config.applyall.checked;
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
       sc.cfgsc.FindOk:=false;
    end;
    RefreshAllChild(cfgm.updall);
    Autorefresh.enabled:=false;
    Autorefresh.Interval:=cfgm.autorefreshdelay*1000;
    Autorefresh.enabled:=true;
end;

procedure Tf_main.ViewBarExecute(Sender: TObject);
begin
PanelTop.visible:=not PanelTop.visible;
PanelLeft.visible:=PanelTop.visible;
PanelRight.visible:=PanelTop.visible;
end;

procedure Tf_main.ViewStatusExecute(Sender: TObject);
begin
PanelBottom.visible:=not PanelBottom.visible;
end;

Procedure Tf_main.InitFonts;
begin
   font.name:=def_cfgplot.fontname[4];
   font.size:=def_cfgplot.fontsize[4];
   if def_cfgplot.FontBold[4] then font.style:=[fsBold] else font.style:=[];
   if def_cfgplot.FontItalic[4] then font.style:=font.style+[fsItalic];
   LPanels0.Caption:='Ra:22h22m22.22s +22°22''22"22';
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
{$ifdef linux}
topmessage.caption:=topmsg;
{$endif}
{$ifdef mswindows}
// do something to refresh the text
topmessage.visible:=false;
topmessage.visible:=true;
{$endif}
end;

procedure Tf_main.FormResize(Sender: TObject);
begin
   Ppanels1.width:=PanelBottom.ClientWidth-Ppanels1.left;
end;

procedure Tf_main.SetDefault;
var i:integer;
begin
ldeg:='°';
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
cfgm.db:='cdc';
cfgm.dbuser:='root';
cfgm.dbpass:='';
cfgm.ImagePath:=slash(appDir)+slash('data')+slash('images');
cfgm.ImageLuminosity:=0;
cfgm.ImageContrast:=0;
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
def_cfgplot.AutoSkycolor:=true;
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
def_cfgsc.ObsName := 'Genève' ;
def_cfgsc.ObsCountry := 'Switzerland' ;
def_cfgsc.horizonopaque:=true;
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
def_cfgsc.Simnb:=1;
def_cfgsc.SimD:=1;
def_cfgsc.SimH:=0;
def_cfgsc.SimM:=0;
def_cfgsc.SimS:=0;
def_cfgsc.SimLine:=True;
for i:=1 to NumSimObject do def_cfgsc.SimObject[i]:=true;
def_cfgsc.ShowPlanet:=true;
def_cfgsc.ShowAsteroid:=true;
def_cfgsc.AstSymbol:=0;
def_cfgsc.AstmagMax:=18;
def_cfgsc.AstmagDiff:=6;
def_cfgsc.ShowComet:=true;
def_cfgsc.ComSymbol:=1;
def_cfgsc.CommagMax:=18;
def_cfgsc.CommagDiff:=4;
def_cfgsc.MagLabel:=false;
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
catalog.cfgshr.BigNebLimit:=150;
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
catalog.cfgshr.NebMagFilter[4]:=16;
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
ReadChartConfig(configfile,true,def_cfgplot,def_cfgsc);
end;

procedure Tf_main.ReadChartConfig(filename:string; usecatalog:boolean; var cplot:conf_plot ;var csc:conf_skychart);
var i:integer;
    inif: TMemIniFile;
    section,buf : string;
begin
inif:=TMeminifile.create(filename);
try
with inif do begin
section:='main';
f_main.Top := ReadInteger(section,'WinTop',f_main.Top);
f_main.Left := ReadInteger(section,'WinLeft',f_main.Left);
f_main.Width := ReadInteger(section,'WinWidth',f_main.Width);
f_main.Height := ReadInteger(section,'WinHeight',f_main.Height);
if f_main.Width>screen.Width then f_main.Width:=screen.Width;
if f_main.Height>(screen.Height-25) then f_main.Height:=screen.Height-25;
formpos(f_main,f_main.Left,f_main.Top);
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
csc.ShowEqGrid:=ReadBool(section,'ShowEqGrid',csc.ShowEqGrid);
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
csc.AstSymbol:=ReadInteger(section,'AstSymbol',csc.AstSymbol);
csc.AstmagMax:=ReadFloat(section,'AstmagMax',csc.AstmagMax);
csc.AstmagDiff:=ReadFloat(section,'AstmagDiff',csc.AstmagDiff);
csc.ComSymbol:=ReadInteger(section,'ComSymbol',csc.ComSymbol);
csc.CommagMax:=ReadFloat(section,'CommagMax',csc.CommagMax);
csc.CommagDiff:=ReadFloat(section,'CommagDiff',csc.CommagDiff);
csc.MagLabel:=ReadBool(section,'MagLabel',csc.MagLabel);
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
SaveConfigOnExit.Checked:=ReadBool(section,'SaveConfigOnExit',SaveConfigOnExit.Checked);
cfgm.language:=ReadString(section,'language',cfgm.language);
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
cfgm.dbhost:=ReadString(section,'dbhost',cfgm.dbhost);
cfgm.dbport:=ReadInteger(section,'dbport',cfgm.dbport);
cfgm.db:=ReadString(section,'db',cfgm.db);
cfgm.dbuser:=ReadString(section,'dbuser',cfgm.dbuser);
cfgm.dbpass:=ReadString(section,'dbpass',cfgm.dbpass);
cfgm.ImagePath:=ReadString(section,'ImagePath',cfgm.ImagePath);
cfgm.ImageLuminosity:=ReadFloat(section,'ImageLuminosity',cfgm.ImageLuminosity);
cfgm.ImageContrast:=ReadFloat(section,'ImageContrast',cfgm.ImageContrast);
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
section:='quicksearch';
j:=ReadInteger(section,'count',0);
for i:=1 to j do quicksearch.Items.Add(ReadString(section,'item'+inttostr(i),''));
end;
finally
inif.Free;
end;
end;

procedure Tf_main.SaveDefault;
begin
SavePrivateConfig(configfile);
SaveChartConfig(configfile);
end;

procedure Tf_main.SaveChartConfig(filename:string);
var i:integer;
    inif: TMemIniFile;
    section : string;
begin
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
if ActiveMDIchild is Tf_chart then with ActiveMDIchild as Tf_chart do begin
  def_cfgplot:=sc.plot.cfgplot;
end;
WriteInteger(section,'starplot',def_cfgplot.starplot);
WriteInteger(section,'nebplot',def_cfgplot.nebplot);
WriteInteger(section,'plaplot',def_cfgplot.plaplot);
WriteInteger(section,'contrast',def_cfgplot.contrast);
WriteInteger(section,'saturation',def_cfgplot.saturation);
WriteFloat(section,'partsize',def_cfgplot.partsize);
WriteFloat(section,'magsize',def_cfgplot.magsize);
WriteBool(section,'PlanetTransparent',def_cfgplot.PlanetTransparent);
WriteBool(section,'AutoSkycolor',def_cfgplot.AutoSkycolor);
for i:=0 to maxcolor do WriteInteger(section,'color'+inttostr(i),def_cfgplot.color[i]);
for i:=1 to 7 do WriteInteger(section,'skycolor'+inttostr(i),def_cfgplot.skycolor[i]);
WriteInteger(section,'bgColor',def_cfgplot.bgColor);
section:='font';
for i:=1 to numfont do begin
    WriteString(section,'FontName'+inttostr(i),def_cfgplot.FontName[i]);
    WriteInteger(section,'FontSize'+inttostr(i),def_cfgplot.FontSize[i]);
    WriteBool(section,'FontBold'+inttostr(i),def_cfgplot.FontBold[i]);
    WriteBool(section,'FontItalic'+inttostr(i),def_cfgplot.FontItalic[i]);
end;
for i:=1 to numlabtype do begin
   WriteInteger(section,'LabelColor'+inttostr(i),def_cfgplot.LabelColor[i]);
   WriteInteger(section,'LabelSize'+inttostr(i),def_cfgplot.LabelSize[i]);
end;
section:='grid';
for i:=0 to maxfield do WriteFloat(section,'HourGridSpacing'+inttostr(i),catalog.cfgshr.HourGridSpacing[i] );
for i:=0 to maxfield do WriteFloat(section,'DegreeGridSpacing'+inttostr(i),catalog.cfgshr.DegreeGridSpacing[i] );
section:='Finder';
for i:=1 to 10 do WriteFloat(section,'Circle'+inttostr(i),def_cfgsc.circle[i,1]);
for i:=1 to 10 do WriteFloat(section,'CircleR'+inttostr(i),def_cfgsc.circle[i,2]);
for i:=1 to 10 do WriteFloat(section,'CircleOffset'+inttostr(i),def_cfgsc.circle[i,3]);
for i:=1 to 10 do WriteBool(section,'ShowCircle'+inttostr(i),def_cfgsc.circleok[i]);
for i:=1 to 10 do WriteString(section,'CircleLbl'+inttostr(i),def_cfgsc.circlelbl[i]);
for i:=1 to 10 do WriteFloat(section,'RectangleW'+inttostr(i),def_cfgsc.rectangle[i,1]);
for i:=1 to 10 do WriteFloat(section,'RectangleH'+inttostr(i),def_cfgsc.rectangle[i,2]);
for i:=1 to 10 do WriteFloat(section,'RectangleR'+inttostr(i),def_cfgsc.rectangle[i,3]);
for i:=1 to 10 do WriteFloat(section,'RectangleOffset'+inttostr(i),def_cfgsc.rectangle[i,4]);
for i:=1 to 10 do WriteBool(section,'ShowRectangle'+inttostr(i),def_cfgsc.rectangleok[i]);
for i:=1 to 10 do WriteString(section,'RectangleLbl'+inttostr(i),def_cfgsc.rectanglelbl[i]);
section:='chart';
WriteInteger(section,'EquinoxType',catalog.cfgshr.EquinoxType);
WriteString(section,'EquinoxChart',catalog.cfgshr.EquinoxChart);
WriteFloat(section,'DefaultJDchart',catalog.cfgshr.DefaultJDchart);
section:='default_chart';
if ActiveMDIchild is Tf_chart then with ActiveMDIchild as Tf_chart do begin
  def_cfgsc:=sc.cfgsc;
  WriteInteger(section,'ChartWidth',width);
  WriteInteger(section,'ChartHeight',height);
  WriteBool(section,'ChartMaximized',(WindowState=wsMaximized));
end;
WriteFloat(section,'racentre',def_cfgsc.racentre);
WriteFloat(section,'decentre',def_cfgsc.decentre);
WriteFloat(section,'acentre',def_cfgsc.acentre);
WriteFloat(section,'hcentre',def_cfgsc.hcentre);
WriteFloat(section,'fov',def_cfgsc.fov);
WriteFloat(section,'theta',def_cfgsc.theta);
WriteString(section,'projtype',def_cfgsc.projtype);
WriteInteger(section,'ProjPole',def_cfgsc.ProjPole);
WriteInteger(section,'FlipX',def_cfgsc.FlipX);
WriteInteger(section,'FlipY',def_cfgsc.FlipY);
WriteBool(section,'PMon',def_cfgsc.PMon);
WriteBool(section,'DrawPMon',def_cfgsc.DrawPMon);
WriteBool(section,'ApparentPos',def_cfgsc.ApparentPos);
WriteInteger(section,'DrawPMyear',def_cfgsc.DrawPMyear);
WriteBool(section,'horizonopaque',def_cfgsc.horizonopaque);
WriteBool(section,'ShowEqGrid',def_cfgsc.ShowEqGrid);
WriteBool(section,'ShowGrid',def_cfgsc.ShowGrid);
WriteBool(section,'ShowGridNum',def_cfgsc.ShowGridNum);
WriteBool(section,'ShowConstL',def_cfgsc.ShowConstL);
WriteBool(section,'ShowConstB',def_cfgsc.ShowConstB);
WriteBool(section,'ShowEcliptic',def_cfgsc.ShowEcliptic);   
WriteBool(section,'ShowGalactic',def_cfgsc.ShowGalactic);
WriteBool(section,'ShowMilkyWay',def_cfgsc.ShowMilkyWay);
WriteBool(section,'FillMilkyWay',def_cfgsc.FillMilkyWay);
WriteBool(section,'ShowPlanet',def_cfgsc.ShowPlanet);
WriteBool(section,'ShowAsteroid',def_cfgsc.ShowAsteroid);
WriteBool(section,'ShowComet',def_cfgsc.ShowComet);
WriteInteger(section,'AstSymbol',def_cfgsc.AstSymbol);
WriteFloat(section,'AstmagMax',def_cfgsc.AstmagMax);
WriteFloat(section,'AstmagDiff',def_cfgsc.AstmagDiff);
WriteInteger(section,'ComSymbol',def_cfgsc.ComSymbol);
WriteFloat(section,'CommagMax',def_cfgsc.CommagMax);
WriteFloat(section,'CommagDiff',def_cfgsc.CommagDiff);
WriteBool(section,'MagLabel',def_cfgsc.MagLabel);
WriteBool(section,'ConstFullLabel',def_cfgsc.ConstFullLabel);
WriteBool(section,'PlanetParalaxe',def_cfgsc.PlanetParalaxe);
WriteBool(section,'ShowEarthShadow',def_cfgsc.ShowEarthShadow);
WriteFloat(section,'GRSlongitude',def_cfgsc.GRSlongitude);
WriteInteger(section,'Simnb',def_cfgsc.Simnb);
WriteInteger(section,'SimD',def_cfgsc.SimD);
WriteInteger(section,'SimH',def_cfgsc.SimH);
WriteInteger(section,'SimM',def_cfgsc.SimM);
WriteInteger(section,'SimS',def_cfgsc.SimS);
WriteBool(section,'SimLine',def_cfgsc.SimLine);
for i:=1 to NumSimObject do WriteBool(section,'SimObject'+inttostr(i),def_cfgsc.SimObject[i]);
for i:=1 to numlabtype do begin
   WriteBool(section,'ShowLabel'+inttostr(i),def_cfgsc.ShowLabel[i]);
   WriteFloat(section,'LabelMag'+inttostr(i),def_cfgsc.LabelMagDiff[i]);
end;
section:='observatory';
WriteFloat(section,'ObsLatitude',def_cfgsc.ObsLatitude );
WriteFloat(section,'ObsLongitude',def_cfgsc.ObsLongitude );
WriteFloat(section,'ObsAltitude',def_cfgsc.ObsAltitude );
WriteFloat(section,'ObsTemperature',def_cfgsc.ObsTemperature );
WriteFloat(section,'ObsPressure',def_cfgsc.ObsPressure );
WriteString(section,'ObsName',def_cfgsc.ObsName );
WriteString(section,'ObsCountry',def_cfgsc.ObsCountry );
WriteFloat(section,'ObsTZ',def_cfgsc.ObsTZ );
section:='date';
WriteBool(section,'UseSystemTime',def_cfgsc.UseSystemTime);
WriteInteger(section,'CurYear',def_cfgsc.CurYear);
WriteInteger(section,'CurMonth',def_cfgsc.CurMonth);
WriteInteger(section,'CurDay',def_cfgsc.CurDay);
WriteFloat(section,'CurTime',def_cfgsc.CurTime);
WriteBool(section,'autorefresh',def_cfgsc.autorefresh);
WriteBool(section,'Force_DT_UT',def_cfgsc.Force_DT_UT);
WriteFloat(section,'DT_UT_val',def_cfgsc.DT_UT_val);
section:='projection';
for i:=1 to maxfield do WriteString(section,'ProjName'+inttostr(i),def_cfgsc.projname[i] );
section:='labels';
EraseSection(section);
WriteInteger(section,'numlabels',def_cfgsc.nummodlabels);
for i:=1 to def_cfgsc.nummodlabels do begin
   WriteInteger(section,'labelid'+inttostr(i),def_cfgsc.modlabels[i].id);
   WriteInteger(section,'labeldx'+inttostr(i),def_cfgsc.modlabels[i].dx);
   WriteInteger(section,'labeldy'+inttostr(i),def_cfgsc.modlabels[i].dy);
   WriteInteger(section,'labelnum'+inttostr(i),def_cfgsc.modlabels[i].labelnum);
   WriteInteger(section,'labelfont'+inttostr(i),def_cfgsc.modlabels[i].fontnum);
   WriteString(section,'labeltxt'+inttostr(i),def_cfgsc.modlabels[i].txt);
   WriteBool(section,'labelhiden'+inttostr(i),def_cfgsc.modlabels[i].hiden);
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
WriteString(section,'AppDir',appdir);
WriteString(section,'PrivateDir',privatedir); 
WriteString(section,'language',cfgm.language);
WriteString(section,'prtname',cfgm.prtname);
WriteInteger(section,'PrinterResolution',cfgm.PrinterResolution);
WriteInteger(section,'PrintColor',cfgm.PrintColor);
WriteBool(section,'PrintLandscape',cfgm.PrintLandscape);
WriteInteger(section,'PrintMethod',cfgm.PrintMethod);
WriteString(section,'PrintCmd1',cfgm.PrintCmd1);
WriteString(section,'PrintCmd2',cfgm.PrintCmd2);
WriteString(section,'PrintTmpPath',cfgm.PrintTmpPath);
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
WriteString(section,'dbhost',cfgm.dbhost);
WriteInteger(section,'dbport',cfgm.dbport);
WriteString(section,'db',cfgm.db);
WriteString(section,'dbuser',cfgm.dbuser);
WriteString(section,'dbpass',cfgm.dbpass);
WriteString(section,'ImagePath',cfgm.ImagePath);
WriteFloat(section,'ImageLuminosity',cfgm.ImageLuminosity);
WriteFloat(section,'ImageContrast',cfgm.ImageContrast);
WriteBool(section,'IndiAutostart',def_cfgsc.IndiAutostart);
WriteString(section,'IndiServerHost',def_cfgsc.IndiServerHost);
WriteString(section,'IndiServerPort',def_cfgsc.IndiServerPort);
WriteString(section,'IndiServerCmd',def_cfgsc.IndiServerCmd);
WriteString(section,'IndiDriver',def_cfgsc.IndiDriver);
WriteString(section,'IndiPort',def_cfgsc.IndiPort);
WriteString(section,'IndiDevice',def_cfgsc.IndiDevice);
WriteBool(section,'IndiTelescope',def_cfgsc.IndiTelescope);
WriteString(section,'ScopePlugin',def_cfgsc.ScopePlugin);
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
Updatefile;
end;
finally
 inif.Free;
end;
end;

procedure Tf_main.SaveQuickSearch(filename:string);
var i:integer;
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
WriteInteger(section,'count',quicksearch.Items.count);
for i:=1 to quicksearch.Items.count do WriteString(section,'item'+inttostr(i),quicksearch.Items[i-1]);
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
var ok,TrackInProgress : Boolean;
    ar1,de1 : Double;
    buf : string;
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
   TrackInProgress:=sc.cfgsc.TrackOn;
   sc.cfgsc.TrackOn:=false;
   if uppercase(copy(Num,1,1))='M' then begin
      buf:=StringReplace(Num,'m','',[rfReplaceAll,rfIgnoreCase]);
      ok:=catalog.FindNum(S_messier,buf,ar1,de1) ;
      if ok then goto findit;
   end;
   if uppercase(copy(Num,1,3))='NGC' then begin
      buf:=StringReplace(Num,'ngc','',[rfReplaceAll,rfIgnoreCase]);
      ok:=catalog.FindNum(S_NGC,buf,ar1,de1) ;
      if ok then goto findit;
   end;
   if uppercase(copy(Num,1,2))='IC' then begin
      buf:=StringReplace(Num,'ic','',[rfReplaceAll,rfIgnoreCase]);
      ok:=catalog.FindNum(S_IC,buf,ar1,de1) ;
      if ok then goto findit;
   end;
   if uppercase(copy(Num,1,3))='PGC' then begin
      buf:=StringReplace(Num,'pgc','',[rfReplaceAll,rfIgnoreCase]);
      ok:=catalog.FindNum(S_PGC,buf,ar1,de1) ;
      if ok then goto findit;
   end;
   if uppercase(copy(Num,1,2))='GC' then begin
      buf:=StringReplace(Num,'gc','',[rfReplaceAll,rfIgnoreCase]);
      ok:=catalog.FindNum(S_GC,buf,ar1,de1) ;
      if ok then goto findit;
   end;
   if uppercase(copy(Num,1,3))='GSC' then begin
      buf:=StringReplace(Num,'gsc','',[rfReplaceAll,rfIgnoreCase]);
      ok:=catalog.FindNum(S_GSC,buf,ar1,de1) ;
      if ok then goto findit;
   end;
   if uppercase(copy(Num,1,3))='TYC' then begin
      buf:=StringReplace(Num,'tyc','',[rfReplaceAll,rfIgnoreCase]);
      ok:=catalog.FindNum(S_TYC2,buf,ar1,de1) ;
      if ok then goto findit;
   end;
   if uppercase(copy(Num,1,3))='SAO' then begin
      buf:=StringReplace(Num,'sao','',[rfReplaceAll,rfIgnoreCase]);
      ok:=catalog.FindNum(S_SAO,buf,ar1,de1) ;
      if ok then goto findit;
   end;
   if uppercase(copy(Num,1,2))='HD' then begin
      buf:=StringReplace(Num,'hd','',[rfReplaceAll,rfIgnoreCase]);
      ok:=catalog.FindNum(S_HD,buf,ar1,de1) ;
      if ok then goto findit;
   end;
   if uppercase(copy(Num,1,2))='BD' then begin
      buf:=StringReplace(Num,'bd','',[rfReplaceAll,rfIgnoreCase]);
      ok:=catalog.FindNum(S_BD,buf,ar1,de1) ;
      if ok then goto findit;
   end;
   if uppercase(copy(Num,1,2))='CD' then begin
      buf:=StringReplace(Num,'cd','',[rfReplaceAll,rfIgnoreCase]);
      ok:=catalog.FindNum(S_CD,buf,ar1,de1) ;
      if ok then goto findit;
   end;
   if uppercase(copy(Num,1,3))='CPD' then begin
      buf:=StringReplace(Num,'cpd','',[rfReplaceAll,rfIgnoreCase]);
      ok:=catalog.FindNum(S_CPD,buf,ar1,de1) ;
      if ok then goto findit;
   end;
   if uppercase(copy(Num,1,2))='HR' then begin
      buf:=StringReplace(Num,'hr','',[rfReplaceAll,rfIgnoreCase]);
      ok:=catalog.FindNum(S_HR,buf,ar1,de1) ;
      if ok then goto findit;
   end;
   for i:=1 to 30 do begin
     if (uppercase(trim(Num))=uppercase(trim(pla[i]))) then begin
         planet.FindNumPla(i,ar1,de1,ok,sc.cfgsc);
         if ok and TrackInProgress then begin
               sc.cfgsc.TrackOn:=true;
               sc.cfgsc.TrackType:=1;
               sc.cfgsc.TrackObj:=i;
         end;
         break;
     end;
   end;
   if ok then goto findit;
   ok:=planet.FindAsteroidName(trim(Num),ar1,de1,sc.cfgsc);
   if ok then goto findit;
   ok:=planet.FindCometName(trim(Num),ar1,de1,sc.cfgsc);
   if ok then goto findit;
   if fileexists(slash(catalog.cfgcat.VarStarCatPath[gcvs-BaseVar])+'gcvs.idx') then begin
      ok:=catalog.FindNum(S_GCVS,Num,ar1,de1) ;
      if ok then goto findit;
   end;
   ok:=catalog.FindNum(S_SAC,Num,ar1,de1) ;
   if ok then goto findit;
   ok:=catalog.FindNum(S_Bayer,Num,ar1,de1) ;
   if ok then goto findit;
   ok:=catalog.FindNum(S_Flam,Num,ar1,de1) ;
   if ok then goto findit;
   if fileexists(slash(catalog.cfgcat.DblStarCatPath[wds-BaseDbl])+'wds.idx') then begin
      ok:=catalog.FindNum(S_WDS,Num,ar1,de1) ;
      if ok then goto findit;
   end;
   ok:=catalog.FindNum(S_Gcat,Num,ar1,de1) ;
   if ok then goto findit;
   ok:=catalog.FindNum(S_Ext,Num,ar1,de1) ;
   if ok then goto findit;
Findit:
   result:=ok;
   if ok then begin
      IdentLabel.visible:=false;
      precession(jd2000,sc.cfgsc.JDchart,ar1,de1);
      sc.movetoradec(ar1,de1);
      Refresh;
      if sc.cfgsc.fov>0.17 then sc.FindatRaDec(ar1,de1,0.0005,true)
                        else sc.FindatRaDec(ar1,de1,0.00005,true);
      ShowIdentLabel;
      f_main.SetLpanel1(wordspace(sc.cfgsc.FindDesc),caption);
   end
   else begin
      sc.cfgsc.TrackOn:=TrackInProgress;
   end;
end;
end;

procedure Tf_main.UpdateBtn(fx,fy:integer;tc:boolean;sender:TObject);
begin
if f_main.ActiveMDIchild=sender then begin
  if fx>0 then FlipButtonX.ImageIndex:=15
          else FlipButtonX.ImageIndex:=16;
  if fy>0 then FlipButtonY.ImageIndex:=17
          else FlipButtonY.ImageIndex:=18;
  if tc   then begin
               TConnect.ImageIndex:=49;
               TelescopeConnect.Hint:='Disconnect Telescope';
          end else begin
               TConnect.ImageIndex:=48;
               TelescopeConnect.Hint:='Connect Telescope';
          end;
end;
end;

Function Tf_main.NewChart(cname:string):string;
begin
if cname='' then cname:='Chart_' + IntToStr(MDIChildCount + 1);
cname:=GetUniqueName(cname,false);
if CreateMDIChild(cname,true,true,def_cfgsc,def_cfgplot) then result:=msgOK+blank+cname
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
    then TCPDaemon.TCPThrd[i].SendData('> '+origin+' : '+str);
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
        if canread(1000) then
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
    d :double;
begin
if TCPDaemon=nil then exit;
try
screen.cursor:=crHourglass;
for i:=1 to Maxwindow do
 if (TCPDaemon.TCPThrd[i]<>nil) then
    TCPDaemon.TCPThrd[i].terminate;
application.processmessages;
TCPDaemon.terminate;
d:=now+1.7E-5;  // 1.5 seconde delay to close the thread
while now<d do application.processmessages;
screen.cursor:=crDefault;
except
 screen.cursor:=crDefault;
end;
end;

procedure Tf_main.ConnectDB;
begin
try
if def_cfgsc.ShowAsteroid or def_cfgsc.ShowComet then begin
    if (planet.ConnectDB(cfgm.dbhost,cfgm.db,cfgm.dbuser,cfgm.dbpass,cfgm.dbport) and planet.CheckDB) then begin
        Fits.ConnectDB(cfgm.dbhost,cfgm.db,cfgm.dbuser,cfgm.dbpass,cfgm.dbport);
    end else begin
          SetLpanel1('MySQL database not available.');
          def_cfgsc.ShowAsteroid:=false;
          def_cfgsc.ShowComet:=false;
    end;
end;
except
  SetLpanel1('MySQL database not available.');
end;
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
quicksearch.Enabled:=false;
quicksearch.Enabled:=true;
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
