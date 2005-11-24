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
 Cross-platform common code for Config form.
}

procedure Tf_config.FormCreate(Sender: TObject);
begin
compage:=22;
astpage:=23;
dbpage:=38;
f_config_solsys1.onShowDB:=ShowDBSetting;
f_config_solsys1.onPrepareAsteroid:=SolSysPrepareAsteroid;
f_config_system1.onShowAsteroid:=ShowAsteroidSetting;
f_config_system1.onShowComet:=ShowCometSetting;
f_config_system1.onLoadMPCSample:=LoadMPCSample;
f_config_system1.onDBChange:=SysDBChange;
f_config_system1.onSaveAndRestart:=SysSaveAndRestart;
end;

procedure Tf_config.FormShow(Sender: TObject);
begin
locktree:=false;
{$ifdef linux}
SetFrameNightVision(f_config_time1, color=dark);
SetFrameNightVision(f_config_observatory1, color=dark);
SetFrameNightVision(f_config_chart1, color=dark);
SetFrameNightVision(f_config_catalog1, color=dark);
SetFrameNightVision(f_config_solsys1, color=dark);
SetFrameNightVision(f_config_display1, color=dark);
SetFrameNightVision(f_config_pictures1, color=dark);
SetFrameNightVision(f_config_system1, color=dark);
{$endif}
f_config_time1.FormShow(Sender);
f_config_observatory1.FormShow(Sender);
f_config_chart1.FormShow(Sender);
f_config_catalog1.FormShow(Sender);
f_config_solsys1.FormShow(Sender);
f_config_display1.FormShow(Sender);
f_config_pictures1.FormShow(Sender);
f_config_system1.FormShow(Sender);
TreeView1.TopItem.Expand(false);
Treeview1.selected:=Treeview1.items[cmain.configpage];
Treeview1.selected.parent.expand(true);
Treeview1.selected:=Treeview1.items[cmain.configpage];
TreeView1Change(Sender,Treeview1.selected);
end;

procedure Tf_config.TreeView1Change(Sender: TObject; Node: TTreeNode);
var i,j: integer;
begin
if locktree then exit;
try
if node.level=0 then begin
   Treeview1.selected:=Treeview1.items[(Treeview1.selected.absoluteindex+1)];
end else begin
   locktree:=true;
   i:=node.parent.index;
   j:=node.index;
   PageControl1.ActivePageIndex:=i;
   case i of
     0 : begin f_config_time1.pa_time.ActivePageIndex:=j;               f_config_time1.FormShow(Sender); end;
     1 : begin f_config_observatory1.pa_observatory.ActivePageIndex:=j; f_config_observatory1.FormShow(Sender); end;
     2 : begin f_config_chart1.pa_chart.ActivePageIndex:=j;             f_config_chart1.FormShow(Sender); end;
     3 : begin f_config_catalog1.pa_catalog.ActivePageIndex:=j;         f_config_catalog1.FormShow(Sender); end;
     4 : begin f_config_solsys1.pa_solsys.ActivePageIndex:=j;           f_config_solsys1.FormShow(Sender); end;
     5 : begin f_config_display1.pa_display.ActivePageIndex:=j;         f_config_display1.FormShow(Sender); end;
     6 : begin f_config_pictures1.pa_images.ActivePageIndex:=j;         f_config_pictures1.FormShow(Sender); end;
     7 : begin f_config_system1.pa_system.ActivePageIndex:=j;           f_config_system1.FormShow(Sender); end;
   end;
end;
application.processmessages;
finally
locktree:=false;
end;
end;

procedure Tf_config.nextClick(Sender: TObject);
begin
if Treeview1.selected.absoluteindex< Treeview1.items.count-1 then begin
 Treeview1.selected:=Treeview1.selected.GetNext;
 Treeview1.selected.parent.expand(true);
 treeview1.topitem:=Treeview1.selected;
 TreeView1Change(Sender,Treeview1.selected);
end;
end;

procedure Tf_config.previousClick(Sender: TObject);
var i : integer;
begin
if Treeview1.selected.absoluteindex>1 then begin
 locktree:=true;
 Treeview1.selected:=Treeview1.selected.GetPrev;
 if Treeview1.selected.level=0 then Treeview1.selected:=Treeview1.selected.GetPrev;
 i:=Treeview1.selected.absoluteindex;
 locktree:=false;
 Treeview1.selected.parent.expand(true);
 Treeview1.selected:=Treeview1.items[i];
 treeview1.topitem:=Treeview1.selected;
 TreeView1Change(Sender,Treeview1.selected);
end;
end;

procedure Tf_config.ShowDBSetting(Sender: TObject);
begin
Treeview1.selected:=Treeview1.items[dbpage];
Treeview1.selected.parent.expand(true);
Treeview1.selected:=Treeview1.items[dbpage];
end;

procedure Tf_config.ShowCometSetting(Sender: TObject);
begin
Treeview1.selected:=Treeview1.items[compage];
Treeview1.selected.parent.expand(true);
Treeview1.selected:=Treeview1.items[compage];
end;

procedure Tf_config.ShowAsteroidSetting(Sender: TObject);
begin
Treeview1.selected:=Treeview1.items[astpage];
Treeview1.selected.parent.expand(true);
Treeview1.selected:=Treeview1.items[astpage];
end;

procedure Tf_config.LoadMPCSample(Sender: TObject);
begin
f_config_solsys1.LoadSampleData;
end;

procedure Tf_config.SysDBChange(Sender: TObject);
begin
 if Assigned(FDBChange) then FDBChange(self);
end;

procedure Tf_config.SysSaveAndRestart(Sender: TObject);
begin
 if Assigned(FSaveAndRestart) then FSaveAndRestart(self);
end;

function Tf_config.SolSysPrepareAsteroid(jdt:double; msg:Tstrings):boolean;
begin
 if assigned(FPrepareAsteroid) then result:=FPrepareAsteroid(jdt,msg)
   else result:=false;
end;

function Tf_config.GetFits: TFits;
begin
result:=f_config_pictures1.Fits;
end;

procedure Tf_config.SetFits(value: TFits);
begin
f_config_pictures1.Fits:=value;
end;

function Tf_config.GetCatalog: Tcatalog;
begin
result:=f_config_catalog1.catalog;
end;

procedure Tf_config.SetCatalog(value: Tcatalog);
begin
f_config_catalog1.catalog:=value;
end;

function Tf_config.GetDB: Tcdcdb;
begin
result:=f_config_system1.cdb;
end;

procedure Tf_config.SetDB(value: Tcdcdb);
begin
f_config_system1.cdb:=value;
f_config_solsys1.cdb:=value;
f_config_pictures1.cdb:=value;
end;

procedure Tf_config.SetCcat(value: conf_catalog);
begin
Fccat:=value;
f_config_time1.ccat:=@Fccat;
f_config_observatory1.ccat:=@Fccat;
f_config_chart1.ccat:=@Fccat;
f_config_catalog1.ccat:=@Fccat;
f_config_solsys1.ccat:=@Fccat;
f_config_display1.ccat:=@Fccat;
f_config_pictures1.ccat:=@Fccat;
f_config_system1.ccat:=@Fccat;
end;

procedure Tf_config.SetCshr(value: conf_shared);
begin
Fcshr:=value;
f_config_time1.cshr:=@Fcshr;
f_config_observatory1.cshr:=@Fcshr;
f_config_chart1.cshr:=@Fcshr;
f_config_catalog1.cshr:=@Fcshr;
f_config_solsys1.cshr:=@Fcshr;
f_config_display1.cshr:=@Fcshr;
f_config_pictures1.cshr:=@Fcshr;
f_config_system1.cshr:=@Fcshr;
end;

procedure Tf_config.SetCsc(value: conf_skychart);
begin
Fcsc:=value;
f_config_time1.csc:=@Fcsc;
f_config_observatory1.csc:=@Fcsc;
f_config_chart1.csc:=@Fcsc;
f_config_catalog1.csc:=@Fcsc;
f_config_solsys1.csc:=@Fcsc;
f_config_display1.csc:=@Fcsc;
f_config_pictures1.csc:=@Fcsc;
f_config_system1.csc:=@Fcsc;
end;

procedure Tf_config.SetCplot(value: conf_plot);
begin
Fcplot:=value;
f_config_time1.cplot:=@Fcplot;
f_config_observatory1.cplot:=@Fcplot;
f_config_chart1.cplot:=@Fcplot;
f_config_catalog1.cplot:=@Fcplot;
f_config_solsys1.cplot:=@Fcplot;
f_config_display1.cplot:=@Fcplot;
f_config_pictures1.cplot:=@Fcplot;
f_config_system1.cplot:=@Fcplot;
end;

procedure Tf_config.SetCmain(value: conf_main);
begin
Fcmain:=value;
f_config_time1.cmain:=@Fcmain;
f_config_observatory1.cmain:=@Fcmain;
f_config_chart1.cmain:=@Fcmain;
f_config_catalog1.cmain:=@Fcmain;
f_config_solsys1.cmain:=@Fcmain;
f_config_display1.cmain:=@Fcmain;
f_config_pictures1.cmain:=@Fcmain;
f_config_system1.cmain:=@Fcmain;
end;

procedure Tf_config.SetCdss(value: conf_dss);
begin
Fcdss:=value;
f_config_pictures1.cdss:=@Fcdss;
end;

procedure Tf_config.applyClick(Sender: TObject);
begin
if assigned(FApplyConfig) then FApplyConfig(Self);
end;

