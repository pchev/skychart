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

function Tf_main.CreateMDIChild(const Name: string; copyactive,linkactive: boolean; cfg1 : conf_skychart; cfgp : conf_plot):boolean;
var
  Child : Tf_chart;
begin
  { allow for a reasonable number of chart }
  if (MDIChildCount>=9) then begin
     SetLpanel1('Too many open window, please close some chart.');
     result:=false;
     exit;
  end;
  { copy active child config }
  if copyactive and (ActiveMDIchild is Tf_chart) then with ActiveMDIchild as Tf_chart do begin
    cfg1:=sc.cfgsc;
    cfgp:=sc.plot.cfgplot;
  end;
  { create a new MDI child window }
  Child := Tf_chart.Create(Application);
  Child.Caption:=name;
  Child.sc.catalog:=catalog;
  Child.sc.planet:=planet;
  Child.sc.plot.cfgplot:=cfgp;
  Child.sc.plot.starshape:=starshape.Picture.Bitmap;
  Child.sc.plot.cfgplot.starshapesize:=starshape.Picture.bitmap.Width div 11;
  Child.sc.plot.cfgplot.starshapew:=Child.sc.plot.cfgplot.starshapesize div 2;
  Child.sc.cfgsc:=cfg1;
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
  UpdateBtn(Child.sc.cfgsc.flipx,Child.sc.cfgsc.flipy);
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
c2.DrawPMyear := c1.DrawPMyear ;
c2.PMon := c1.PMon ;
c2.DrawPMon := c1.DrawPMon ;
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
c2.GRSlongitude := c1.GRSlongitude ;
c2.ShowEarthShadow := c1.ShowEarthShadow ;
c2.ProjPole := c1.ProjPole ;
c2.ShowEqGrid := c1.ShowEqGrid ;
c2.ShowAzGrid := c1.ShowAzGrid ;
c2.ShowConstL := c1.ShowConstL ;
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

procedure Tf_main.FileNew1Execute(Sender: TObject);
begin
  CreateMDIChild('Chart ' + IntToStr(MDIChildCount + 1),true,true,def_cfgsc,def_cfgplot);
end;

procedure Tf_main.FileOpen1Execute(Sender: TObject);
var cfgs :conf_skychart;
    cfgp : conf_plot;
begin
OpenDialog.Filter:='Cartes du Ciel 3 File|*.cdc3|All Files|*.*';
  if OpenDialog.Execute then begin
    cfgp:=def_cfgplot;
    cfgs:=def_cfgsc;
    ReadChartConfig(OpenDialog.FileName,true,cfgp,cfgs);
    CreateMDIChild(extractfilename(OpenDialog.FileName),false,false,cfgs,cfgp);
  end;
end;

procedure Tf_main.FileSaveAs1Execute(Sender: TObject);
begin
Savedialog.DefaultExt:='cdc3';
savedialog.Filter:='Cartes du Ciel 3 File|*.cdc3|All Files|*.*';
if ActiveMDIchild is Tf_chart then
  if SaveDialog.Execute then SaveChartConfig(SaveDialog.Filename);
end;

procedure Tf_main.HelpAbout1Execute(Sender: TObject);
begin
  f_about.ShowModal;
end;

procedure Tf_main.FileExit1Execute(Sender: TObject);
begin
  Close;
end;

procedure Tf_main.FormCreate(Sender: TObject);
begin
DecimalSeparator:='.';
appdir:=getcurrentdir;
catalog:=Tcatalog.Create(self);
planet:=Tplanet.Create(self);
end;

procedure Tf_main.FormShow(Sender: TObject);
begin
 SetDefault;
 ReadDefault;
 LoadConstL(cfgm.ConstLfile);
 SetLang;
 InitFonts;
 SetLpanel1('');
 FileNewItem.click;
 Autorefresh.Interval:=cfgm.autorefreshdelay*1000;
 Autorefresh.enabled:=true;
end;

procedure Tf_main.FormDestroy(Sender: TObject);
begin
catalog.free;
planet.free;
end;

procedure Tf_main.FormClose(Sender: TObject; var Action: TCloseAction);
begin
if SaveConfigOnExit.checked then SaveDefault
                            else SaveQuickSearch(configfile);
end;

procedure Tf_main.SaveConfigurationExecute(Sender: TObject);
begin
SaveDefault;
end;

procedure Tf_main.Print1Execute(Sender: TObject);
begin
if ActiveMdiChild is Tf_chart then with ActiveMdiChild as Tf_chart do PrintChart(Sender);
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

procedure Tf_main.ChangeProjExecute(Sender: TObject);
begin
if ActiveMdiChild is Tf_chart then with ActiveMdiChild as Tf_chart do begin
   if sc.cfgsc.projpole=Equat then sc.cfgsc.projpole:=Altaz
                              else sc.cfgsc.projpole:=Equat;
   sc.cfgsc.FindOk:=false; // invalidate the search result
   Refresh;
end;
end;

procedure Tf_main.GridEQExecute(Sender: TObject);
begin
if ActiveMdiChild is Tf_chart then with ActiveMdiChild as Tf_chart do GridEQExecute(Sender);
end;

procedure Tf_main.GridAZExecute(Sender: TObject);
begin
if ActiveMdiChild is Tf_chart then with ActiveMdiChild as Tf_chart do GridAZExecute(Sender);
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

procedure Tf_main.OpenConfigExecute(Sender: TObject);
begin
if f_config=nil then f_config:=Tf_config.Create(application);
try
 f_config.ccat:=catalog.cfgcat;
 f_config.cshr:=catalog.cfgshr;
 f_config.cplot:=def_cfgplot;
 f_config.csc:=def_cfgsc;
 if ActiveMdiChild is Tf_chart then with ActiveMdiChild as Tf_chart do
     CopySCconfig(sc.cfgsc,f_config.csc);
 f_config.cmain:=cfgm;
 f_config.applyall.checked:=cfgm.updall;
 formpos(f_config,mouse.cursorpos.x,mouse.cursorpos.y);
 f_config.showmodal;
 if f_config.ModalResult=mrOK then begin
   activateconfig;
 end;
 cfgm.configpage:=f_config.Pagecontrol1.activepageindex;
finally
// f_config.free;
end;
end;

procedure Tf_main.activateconfig;
begin
    cfgm:=f_config.cmain;
    cfgm.updall:=f_config.applyall.checked;
    catalog.cfgcat:=f_config.ccat;
    catalog.cfgshr:=f_config.cshr;
    def_cfgsc:=f_config.csc;
    def_cfgplot:=f_config.cplot;
    def_cfgplot.starshapesize:=starshape.Picture.bitmap.Width div 11;
    def_cfgplot.starshapew:=def_cfgplot.starshapesize div 2;
    InitFonts;
    LoadConstL(cfgm.ConstLfile);
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
   Lpanels0.Caption:='';
   Ppanels1.left:=Ppanels0.left+Ppanels0.width;
   Ppanels1.width:=PanelBottom.ClientWidth-Ppanels1.left;
end;

Procedure Tf_main.SetLPanel1(txt:string);
begin
LPanels1.width:=PPanels1.ClientWidth;
LPanels1.Caption:=txt;
PPanels1.ClientHeight:=LPanels1.Height+8;
end;

Procedure Tf_main.SetLPanel0(txt:string);
begin
LPanels0.Caption:=txt;
PPanels0.ClientHeight:=LPanels0.Height+8;
end;

procedure Tf_main.FormResize(Sender: TObject);
begin
//   PanelLeft.width:=ToolBar2.width+2;
//   PanelRight.width:=ToolBar3.width+2;
   Ppanels1.width:=PanelBottom.ClientWidth-Ppanels1.left;
end;

procedure Tf_main.SetDefault;
var i:integer;
begin
u_util.ldeg:='°';
u_util.lmin:='''';
u_util.lsec:='"';
cfgm.language:='UK';
cfgm.prtname:='';
cfgm.configpage:=0;
cfgm.PrinterResolution:=300;
cfgm.PrintColor:=true;
cfgm.PrintLandscape:=true;
cfgm.maximized:=true;
cfgm.updall:=true;
cfgm.AutoRefreshDelay:=60;
for i:=1 to 6 do begin
   def_cfgplot.FontName[i]:=DefaultFontName;
   def_cfgplot.FontSize[i]:=DefaultFontSize;
   def_cfgplot.FontBold[i]:=false;
   def_cfgplot.FontItalic[i]:=false;
end;
for i:=1 to 9 do begin
   def_cfgplot.LabelColor[i]:=clWhite;
   def_cfgplot.LabelSize[i]:=DefaultFontSize;
end;
cfgm.ConstLfile:=slash(appdir)+'data'+Pathdelim+'constellation'+Pathdelim+'constl.dat';
def_cfgplot.invisible:=false;
def_cfgplot.color:=dfColor;
def_cfgplot.skycolor:=dfSkyColor;
def_cfgplot.backgroundcolor:=def_cfgplot.color[0];
def_cfgplot.Nebgray:=55;
def_cfgplot.NebBright:=180;
def_cfgplot.stardyn:=65;
def_cfgplot.starsize:=13;
def_cfgplot.starplot:=1;
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
def_cfgsc.ObsLongitude := 6.1 ;
def_cfgsc.ObsAltitude := 0 ;
def_cfgsc.ObsTemperature := 10 ;
def_cfgsc.ObsPressure := 1010 ;
def_cfgsc.ObsName := 'Geneve' ;
def_cfgsc.horizonopaque:=true;
def_cfgsc.HorizonMax:=0;
def_cfgsc.PMon:=false;
def_cfgsc.DrawPMon:=false;
def_cfgsc.DrawPMyear:=1000;
def_cfgsc.ShowEqGrid:=false;
def_cfgsc.ShowAzGrid:=true;
def_cfgsc.ShowConstL:=true;
def_cfgsc.Simnb:=1;
def_cfgsc.SimD:=1;
def_cfgsc.SimH:=0;
def_cfgsc.SimM:=0;
def_cfgsc.SimS:=0;
def_cfgsc.SimLine:=True;
for i:=1 to NumSimObject do def_cfgsc.SimObject[i]:=true;
def_cfgsc.ShowPlanet:=true;
def_cfgsc.PlanetParalaxe:=true;
def_cfgsc.ShowEarthShadow:=false;
def_cfgsc.GRSlongitude:=84;
def_cfgsc.LabelOrientation:=1;
def_cfgsc.FindOk:=false;
catalog.cfgshr.AzNorth:=true;
catalog.cfgshr.EquinoxType:=0;
catalog.cfgshr.EquinoxChart:='J2000';
catalog.cfgshr.DefaultJDchart:=jd2000;
catalog.cfgshr.StarFilter:=true;
catalog.cfgshr.AutoStarFilter:=false;
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
catalog.cfgcat.starcatpath[bsc-BaseStar]:=slash(appdir)+'cat'+PathDelim+'bsc5';
catalog.cfgcat.starcatdef[bsc-BaseStar]:=true;
catalog.cfgcat.starcatfield[bsc-BaseStar,2]:=10;
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
catalog.cfgshr.FieldNum[9]:=270;
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
catalog.cfgshr.StarMagFilter[2]:=15;
catalog.cfgshr.StarMagFilter[3]:=13;
catalog.cfgshr.StarMagFilter[4]:=12;
catalog.cfgshr.StarMagFilter[5]:=11;
catalog.cfgshr.StarMagFilter[6]:=10;
catalog.cfgshr.StarMagFilter[7]:=9;
catalog.cfgshr.StarMagFilter[8]:=6.5;
catalog.cfgshr.StarMagFilter[9]:=6;
catalog.cfgshr.StarMagFilter[10]:=5;
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
{ platform specific default values }
{$ifdef linux}
configfile:=expandfilename(Defaultconfigfile);
{$endif}
{$ifdef mswindows}
configfile:=Defaultconfigfile;
{$endif}
end;

procedure Tf_main.ReadDefault;
begin
ReadPrivateConfig(configfile);
ReadChartConfig(configfile,true,def_cfgplot,def_cfgsc);
end;

procedure Tf_main.ReadChartConfig(filename:string; usecatalog:boolean; var cplot:conf_plot ;var csc:conf_skychart);
var i:integer;
    inif: TIniFile;
    section,buf : string;
begin
inif:=Tinifile.create(filename);
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
for i:=1 to 6 do begin
   cplot.FontName[i]:=ReadString(section,'FontName'+inttostr(i),cplot.FontName[i]);
   cplot.FontSize[i]:=ReadInteger(section,'FontSize'+inttostr(i),cplot.FontSize[i]);
   cplot.FontBold[i]:=ReadBool(section,'FontBold'+inttostr(i),cplot.FontBold[i]);
   cplot.FontItalic[i]:=ReadBool(section,'FontItalic'+inttostr(i),cplot.FontItalic[i]);
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
cplot.PlanetTransparent:=ReadBool(section,'PlanetTransparent',cplot.PlanetTransparent);
cplot.AutoSkycolor:=ReadBool(section,'AutoSkycolor',cplot.AutoSkycolor);
for i:=0 to maxcolor do cplot.color[i]:=ReadInteger(section,'color'+inttostr(i),cplot.color[i]);
for i:=1 to 7 do cplot.skycolor[i]:=ReadInteger(section,'skycolor'+inttostr(i),cplot.skycolor[i]);
cplot.bgColor:=cplot.color[0];
section:='grid';
for i:=1 to maxfield do catalog.cfgshr.HourGridSpacing[i]:=ReadFloat(section,'HourGridSpacing'+inttostr(i),catalog.cfgshr.HourGridSpacing[i] );
for i:=1 to maxfield do catalog.cfgshr.DegreeGridSpacing[i]:=ReadFloat(section,'DegreeGridSpacing'+inttostr(i),catalog.cfgshr.DegreeGridSpacing[i] );
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
csc.fov:=ReadFloat(section,'fov',csc.fov);
csc.theta:=ReadFloat(section,'theta',csc.theta);
buf:=trim(ReadString(section,'projtype',csc.projtype))+'A';
csc.projtype:=buf[1];
csc.ProjPole:=ReadInteger(section,'ProjPole',csc.ProjPole);
csc.FlipX:=ReadInteger(section,'FlipX',csc.FlipX);
csc.FlipY:=ReadInteger(section,'FlipY',csc.FlipY);
csc.PMon:=ReadBool(section,'PMon',csc.PMon);
csc.DrawPMon:=ReadBool(section,'DrawPMon',csc.DrawPMon);
csc.DrawPMyear:=ReadInteger(section,'DrawPMyear',csc.DrawPMyear);
csc.horizonopaque:=ReadBool(section,'horizonopaque',csc.horizonopaque);
csc.ShowEqGrid:=ReadBool(section,'ShowEqGrid',csc.ShowEqGrid);
csc.ShowAzGrid:=ReadBool(section,'ShowAzGrid',csc.ShowAzGrid);
csc.ShowConstL:=ReadBool(section,'ShowConstL',csc.ShowConstL);
csc.ShowPlanet:=ReadBool(section,'ShowPlanet',csc.ShowPlanet);
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
section:='observatory';
csc.ObsLatitude := ReadFloat(section,'ObsLatitude',csc.ObsLatitude );
csc.ObsLongitude := ReadFloat(section,'ObsLongitude',csc.ObsLongitude );
csc.ObsAltitude := ReadFloat(section,'ObsAltitude',csc.ObsAltitude );
csc.ObsTemperature := ReadFloat(section,'ObsTemperature',csc.ObsTemperature );
csc.ObsPressure := ReadFloat(section,'ObsPressure',csc.ObsPressure );
csc.ObsName := ReadString(section,'ObsName',csc.ObsName );
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
end;
finally
inif.Free;
end;
end;

procedure Tf_main.ReadPrivateConfig(filename:string);
var i,j:integer;
    inif: TIniFile;
    section : string;
begin
inif:=Tinifile.create(filename);
try
with inif do begin
section:='main';
SaveConfigOnExit.Checked:=ReadBool(section,'SaveConfigOnExit',SaveConfigOnExit.Checked);
cfgm.language:=ReadString(section,'language',cfgm.language);
cfgm.prtname:=ReadString(section,'prtname',cfgm.prtname);
cfgm.PrinterResolution:=ReadInteger(section,'PrinterResolution',cfgm.PrinterResolution);
cfgm.PrintColor:=ReadBool(section,'PrintColor',cfgm.PrintColor);
cfgm.PrintLandscape:=ReadBool(section,'PrintLandscape',cfgm.PrintLandscape);
if (ReadBool(section,'WinMaximize',false)) then f_main.WindowState:=wsMaximized;
cfgm.autorefreshdelay:=ReadInteger(section,'autorefreshdelay',cfgm.autorefreshdelay);
cfgm.ConstLfile:=ReadString(section,'ConstLfile',cfgm.ConstLfile);
catalog.cfgshr.AzNorth:=ReadBool(section,'AzNorth',catalog.cfgshr.AzNorth);
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
SaveQuickSearch(configfile);
SaveChartConfig(configfile);
end;

procedure Tf_main.SaveChartConfig(filename:string);
var i:integer;
    inif: TIniFile;
    section : string;
begin
inif:=Tinifile.create(filename);
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
WriteBool(section,'PlanetTransparent',def_cfgplot.PlanetTransparent);
WriteBool(section,'AutoSkycolor',def_cfgplot.AutoSkycolor);
for i:=0 to maxcolor do WriteInteger(section,'color'+inttostr(i),def_cfgplot.color[i]);
for i:=1 to 7 do WriteInteger(section,'skycolor'+inttostr(i),def_cfgplot.skycolor[i]);
section:='font';
for i:=1 to 6 do begin
    WriteString(section,'FontName'+inttostr(i),def_cfgplot.FontName[i]);
    WriteInteger(section,'FontSize'+inttostr(i),def_cfgplot.FontSize[i]);
    WriteBool(section,'FontBold'+inttostr(i),def_cfgplot.FontBold[i]);
    WriteBool(section,'FontItalic'+inttostr(i),def_cfgplot.FontItalic[i]);
end;
section:='grid';
for i:=1 to maxfield do WriteFloat(section,'HourGridSpacing'+inttostr(i),catalog.cfgshr.HourGridSpacing[i] );
for i:=1 to maxfield do WriteFloat(section,'DegreeGridSpacing'+inttostr(i),catalog.cfgshr.DegreeGridSpacing[i] );
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
WriteInteger(section,'DrawPMyear',def_cfgsc.DrawPMyear);
WriteBool(section,'horizonopaque',def_cfgsc.horizonopaque);
WriteBool(section,'ShowEqGrid',def_cfgsc.ShowEqGrid);
WriteBool(section,'ShowAzGrid',def_cfgsc.ShowAzGrid);
WriteBool(section,'ShowConstL',def_cfgsc.ShowConstL);
WriteBool(section,'ShowPlanet',def_cfgsc.ShowPlanet);
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
section:='observatory';
WriteFloat(section,'ObsLatitude',def_cfgsc.ObsLatitude );
WriteFloat(section,'ObsLongitude',def_cfgsc.ObsLongitude );
WriteFloat(section,'ObsAltitude',def_cfgsc.ObsAltitude );
WriteFloat(section,'ObsTemperature',def_cfgsc.ObsTemperature );
WriteFloat(section,'ObsPressure',def_cfgsc.ObsPressure );
WriteString(section,'ObsName',def_cfgsc.ObsName );
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
end;
finally
 inif.Free;
end;
end;

procedure Tf_main.SavePrivateConfig(filename:string);
var i:integer;
    inif: TIniFile;
    section : string;
begin
inif:=Tinifile.create(filename);
try
with inif do begin
section:='main';
WriteString(section,'language',cfgm.language);
WriteString(section,'prtname',cfgm.prtname);
WriteInteger(section,'PrinterResolution',cfgm.PrinterResolution);
WriteBool(section,'PrintColor',cfgm.PrintColor);
WriteBool(section,'PrintLandscape',cfgm.PrintLandscape);
WriteBool(section,'WinMaximize',(f_main.WindowState=wsMaximized));
WriteBool(section,'AzNorth',catalog.cfgshr.AzNorth);
WriteInteger(section,'autorefreshdelay',cfgm.autorefreshdelay);
WriteString(section,'ConstLfile',cfgm.ConstLfile);
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
end;
finally
 inif.Free;
end;
end;

procedure Tf_main.SaveQuickSearch(filename:string);
var i:integer;
    inif: TIniFile;
    section : string;
begin
inif:=Tinifile.create(filename);
try
with inif do begin
section:='quicksearch';
WriteInteger(section,'count',quicksearch.Items.count);
for i:=1 to quicksearch.Items.count do WriteString(section,'item'+inttostr(i),quicksearch.Items[i-1]);
end;
finally
 inif.Free;
end;
end;

procedure Tf_main.SaveConfigOnExitExecute(Sender: TObject);
var inif: TIniFile;
    section : string;
begin
SaveConfigOnExit.Checked:=not SaveConfigOnExit.Checked;
inif:=Tinifile.create(configfile);
try
with inif do begin
section:='main';
WriteBool(section,'SaveConfigOnExit',SaveConfigOnExit.Checked);
end;
finally
 inif.Free;
end;
end;

procedure Tf_main.SetLang;
var i:integer;
    inif: TIniFile;
    section : string;
begin
inif:=Tinifile.create(slash(appdir)+'cdclang_'+trim(cfgm.language)+'.ini');
try
with inif do begin
section:='main';
u_util.ldeg:=ReadString(section,'ldeg',u_util.ldeg);
u_util.lmin:=ReadString(section,'lmin',u_util.lmin);
u_util.lsec:=ReadString(section,'lsec',u_util.lsec);
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
var ar1,de1 : Double;
    ok,TrackInProgress : Boolean;
    num,buf : string;
    i : integer;
label findit;
begin
if key<>key_cr then exit;  // wait press Enter
if ActiveMdiChild is Tf_chart then with ActiveMdiChild as Tf_chart do begin
   TrackInProgress:=sc.cfgsc.TrackOn;
   sc.cfgsc.TrackOn:=false;
   Num:=trim(quicksearch.text);
   if trim(num)='' then exit;
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
{   buf:=trim(uppercase(num));
   j:=length(buf);
   if j>3 then for i:=1 to CometNb do begin
     if uppercase(copy(CometNLst[i],1,j))=buf then begin
         Findnumcom(i,ar1,de1,ok);
         if ok and beingfollow then begin
               FollowOn:=true;
               FollowType:=2;
               FollowObj:=i;
         end;
         break;
     end;
   end;
   if ok then goto findit;  }
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
   if ok then begin
      IdentLabel.visible:=false;
      precession(jd2000,sc.cfgsc.JDchart,ar1,de1);
      sc.movetoradec(ar1,de1);
      Refresh;
      sc.FindatRaDec(ar1,de1,0.0003);
      ShowIdentLabel;
      f_main.SetLpanel1(sc.cfgsc.FindDesc);
      i:=quicksearch.Items.IndexOf(Num);
      if i=-1 then i:=MaxQuickSearch-1;               
      quicksearch.Items.Delete(i);
      quicksearch.Items.Insert(0,Num);
      quicksearch.ItemIndex:=0;
   end
   else begin
      sc.cfgsc.TrackOn:=TrackInProgress;
      ShowMessage('Not found'+' '+Num);
   end;
end;
end;

procedure Tf_main.UpdateBtn(fx,fy:integer);
begin
  if fx>0 then FlipButtonX.ImageIndex:=15
          else FlipButtonX.ImageIndex:=16;
  if fy>0 then FlipButtonY.ImageIndex:=17
          else FlipButtonY.ImageIndex:=18;
end;

Procedure Tf_main.LoadConstL(fname:string);
var f : textfile;
    i,n:integer;
    ra1,ra2,de1,de2:single;
    txt:string;
begin
   if not FileExists(fname) then begin
      catalog.cfgshr.ConstLNum := 0;
      setlength(catalog.cfgshr.ConstL,0);
      exit;
   end;
   assignfile(f,fname);
   try
   reset(f);
   n:=0;
   // first loop to get the size
   repeat
     readln(f,txt);
     inc(n);
   until eof(f);
   setlength(catalog.cfgshr.ConstL,n);
   // read the file now
   reset(f);
   for i:=0 to n-1 do begin
     readln(f,ra1,de1,ra2,de2);
     catalog.cfgshr.ConstL[i].ra1:=deg2rad*ra1*15;
     catalog.cfgshr.ConstL[i].de1:=deg2rad*de1;
     catalog.cfgshr.ConstL[i].ra2:=deg2rad*ra2*15;
     catalog.cfgshr.ConstL[i].de2:=deg2rad*de2;
   end;
   catalog.cfgshr.ConstLNum := n;
   finally
   closefile(f);
   end;
end;


