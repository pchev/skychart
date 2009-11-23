unit pu_config;

{$MODE Delphi}{$H+}

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
 Configuration form
}

interface

uses u_help, u_translation, u_constant, u_util,
  LCLIntf, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, Buttons, ExtCtrls, enhedits,
  cu_fits, cu_catalog, cu_database,
  pu_config_chart, pu_config_observatory, pu_config_time, pu_config_catalog,
  pu_config_system, pu_config_pictures, pu_config_display, pu_config_solsys,
  pu_config_internet,
  LResources, MultiDoc, ChildDoc, PairSplitter, LazHelpHTML;

type

  { Tf_config }

  Tf_config = class(TForm)
    HTMLBrowserHelpViewer1: THTMLBrowserHelpViewer;
    HTMLHelpDatabase1: THTMLHelpDatabase;
    MultiDoc1: TMultiDoc;
    Panel1: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    Splitter1: TSplitter;
    TreeView1: TTreeView;
    previous: TButton;
    next: TButton;
    Panel2: TPanel;
    Applyall: TCheckBox;
    OKBtn: TButton;
    Apply: TButton;
    CancelBtn: TButton;
    HelpBtn: TButton;
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormDestroy(Sender: TObject);
    procedure HelpBtnClick(Sender: TObject);
    procedure TreeView1Change(Sender: TObject; Node: TTreeNode);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure nextClick(Sender: TObject);
    procedure previousClick(Sender: TObject);
    procedure ApplyClick(Sender: TObject);
  private
    { Déclarations privées }
    locktree: boolean;
    Fccat : Tconf_catalog;
    Fcshr : Tconf_shared;
    Fcsc  : Tconf_skychart;
    Fcplot : Tconf_plot;
    Fcmain : Tconf_main;
    Fcdss : Tconf_dss;
    Fnightvision: boolean;
    astpage,compage,dbpage: integer;
    lastSelectedNode: TTreeNode;
    FApplyConfig: TNotifyEvent;
    FDBChange: TNotifyEvent;
    FSaveAndRestart: TNotifyEvent;
    FPrepareAsteroid: TPrepareAsteroid;
    f_config_observatory1: Tf_config_observatory;
    f_config_chart1: Tf_config_chart;
    f_config_catalog1: Tf_config_catalog;
    f_config_solsys1: Tf_config_solsys;
    f_config_display1: Tf_config_display;
    f_config_pictures1: Tf_config_pictures;
    f_config_system1: Tf_config_system;
    f_config_time1: Tf_config_time;
    f_config_internet1: Tf_config_internet;
    function GetFits: TFits;
    procedure SetFits(value: TFits);
    function GetCatalog: Tcatalog;
    procedure SetCatalog(value: Tcatalog);
    function GetDB: Tcdcdb;
    procedure SetDB(value: Tcdcdb);
    procedure SetCcat(value: Tconf_catalog);
    procedure SetCshr(value: Tconf_shared);
    procedure SetCsc(value: Tconf_skychart);
    procedure SetCplot(value: Tconf_plot);
    procedure SetCmain(value: Tconf_main);
    procedure SetCdss(value: Tconf_dss);
    procedure ShowDBSetting(Sender: TObject);
    procedure ShowCometSetting(Sender: TObject);
    procedure ShowAsteroidSetting(Sender: TObject);
    procedure LoadMPCSample(Sender: TObject);
    procedure SysDBChange(Sender: TObject);
    procedure SysSaveAndRestart(Sender: TObject);
    function  SolSysPrepareAsteroid(jdt:double; msg:Tstrings):boolean;
    procedure ShowPage(i,j:Integer);
    procedure ActivateChanges;
  public
    { Déclarations publiques }
    procedure SetLang;
    property ccat : Tconf_catalog read Fccat write SetCcat;
    property cshr : Tconf_shared read Fcshr write SetCshr;
    property csc  : Tconf_skychart read Fcsc write SetCsc;
    property cplot : Tconf_plot read Fcplot write SetCplot;
    property cmain : Tconf_main read Fcmain write SetCmain;
    property cdss : Tconf_dss read Fcdss write SetCdss;
    property fits : TFits read GetFits write SetFits;
    property catalog : Tcatalog read GetCatalog write SetCatalog;
    property db : Tcdcdb read GetDB write SetDB;
    property onApplyConfig: TNotifyEvent read FApplyConfig write FApplyConfig;
    property onDBChange: TNotifyEvent read FDBChange write FDBChange;
    property onSaveAndRestart: TNotifyEvent read FSaveAndRestart write FSaveAndRestart;
    property onPrepareAsteroid: TPrepareAsteroid read FPrepareAsteroid write FPrepareAsteroid;
  end;

var
  f_config: Tf_config;

implementation

procedure Tf_config.SetLang;
begin
Caption:=rsConfiguratio;
TreeView1.items[0].text:='1- '+rsDateTime2;
TreeView1.items[1].text:='1- '+rsDateTime2;
TreeView1.items[2].text:='2- '+rsTimeSimulati;
TreeView1.items[3].text:='2- '+rsObservatory;
TreeView1.items[4].text:='1- '+rsObservatory;
TreeView1.items[5].text:='2- '+rsHorizon;
TreeView1.items[6].text:='3- '+rsChartCoordin;
TreeView1.items[7].text:='1- '+rsChartCoordin;
TreeView1.items[8].text:='2- '+rsFieldOfVisio;
TreeView1.items[9].text:='3- '+rsProjection;
TreeView1.items[10].text:='4- '+rsObjectFilter;
TreeView1.items[11].text:='5- '+rsGridSpacing;
TreeView1.items[12].text:='6- '+rsObjectList;
TreeView1.items[13].text:='4- '+rsCatalog;
TreeView1.items[14].text:='1- '+rsCatalog;
TreeView1.items[15].text:='2- '+rsCdCStars;
TreeView1.items[16].text:='3- '+rsCdCNebulae;
TreeView1.items[17].text:='4- '+rsObsolete;
TreeView1.items[18].text:='5- '+rsSolarSystem;
TreeView1.items[19].text:='1- '+rsSolarSystem;
TreeView1.items[20].text:='2- '+rsPlanet;
TreeView1.items[21].text:='3- '+rsComet;
TreeView1.items[22].text:='4- '+rsAsteroid;
TreeView1.items[23].text:='6- '+rsDisplay;
TreeView1.items[24].text:='1- '+rsDisplay;
TreeView1.items[25].text:='2- '+rsDisplayColou;
TreeView1.items[26].text:='3- '+rsDeepSkyObjec;
TreeView1.items[27].text:='4- '+rsSkyBackgroun;
TreeView1.items[28].text:='5- '+rsLines;
TreeView1.items[29].text:='6- '+rsLabels;
TreeView1.items[30].text:='7- '+rsFonts;
TreeView1.items[31].text:='8- '+rsFinderCircle;
TreeView1.items[32].text:='9- '+rsFinderRectan;
TreeView1.items[33].text:='7- '+rsPictures;
TreeView1.items[34].text:='1- '+rsObject;
TreeView1.items[35].text:='2- '+rsBackground;
TreeView1.items[36].text:='3- '+rsDSSRealSky;
TreeView1.items[37].text:='8- '+rsSystem;
TreeView1.items[38].text:='1- '+rsSystem;
TreeView1.items[39].text:='2- '+rsServer;
TreeView1.items[40].text:='3- '+rsTelescope;
TreeView1.items[41].text:='4- '+rsLanguage2;
TreeView1.items[42].text:='9- '+rsInternet;
TreeView1.items[43].text:='1- '+rsProxy;
TreeView1.items[44].text:='2- '+rsOrbitalEleme;
TreeView1.items[45].text:='3- '+rsOnlineDSSPic;
Applyall.caption:=rsApplyChangeT;
Apply.Caption:=rsApply;
OKBtn.caption:=rsOK;
CancelBtn.caption:=rsCancel;
HelpBtn.caption:=rsHelp;
if f_config_catalog1<>nil then f_config_catalog1.SetLang;
if f_config_chart1<>nil then f_config_chart1.SetLang;
if f_config_display1<>nil then f_config_display1.SetLang;
if f_config_internet1<>nil then f_config_internet1.SetLang;
if f_config_observatory1<>nil then f_config_observatory1.SetLang;
if f_config_pictures1<>nil then f_config_pictures1.SetLang;
if f_config_solsys1<>nil then f_config_solsys1.SetLang;
if f_config_system1<>nil then f_config_system1.SetLang;
if f_config_time1<>nil then f_config_time1.SetLang;
SetHelpDB(HTMLHelpDatabase1);
SetHelp(self,hlpMenuSetup);
end;

procedure Tf_config.FormCreate(Sender: TObject);
var Child: TChildDoc;
begin
Fcsc:=Tconf_skychart.Create;
Fccat:=Tconf_catalog.Create;
Fcshr:=Tconf_shared.Create;
Fcplot:=Tconf_plot.Create;
Fcmain:=Tconf_main.Create;
Fcdss:=Tconf_dss.Create;
SetLang;
compage:=21;
astpage:=22;
dbpage:=37;
Fnightvision:=false;

Child:=MultiDoc1.NewChild;
f_config_time1:=Tf_config_time.Create(Child);
Child.DockedPanel:=f_config_time1.MainPanel;

Child:=MultiDoc1.NewChild;
f_config_observatory1:=Tf_config_observatory.Create(Child);
Child.DockedPanel:=f_config_observatory1.MainPanel;

Child:=MultiDoc1.NewChild;
f_config_chart1:=Tf_config_chart.Create(Child);
Child.DockedPanel:=f_config_chart1.MainPanel;

Child:=MultiDoc1.NewChild;
f_config_catalog1:=Tf_config_catalog.Create(Child);
Child.DockedPanel:=f_config_catalog1.MainPanel;

Child:=MultiDoc1.NewChild;
f_config_solsys1:=Tf_config_solsys.Create(Child);
Child.DockedPanel:=f_config_solsys1.MainPanel;

Child:=MultiDoc1.NewChild;
f_config_display1:=Tf_config_display.Create(Child);
Child.DockedPanel:=f_config_display1.MainPanel;

Child:=MultiDoc1.NewChild;
f_config_pictures1:=Tf_config_pictures.Create(Child);
Child.DockedPanel:=f_config_pictures1.MainPanel;

Child:=MultiDoc1.NewChild;
f_config_system1:=Tf_config_system.Create(Child);
Child.DockedPanel:=f_config_system1.MainPanel;

Child:=MultiDoc1.NewChild;
f_config_internet1:=Tf_config_internet.Create(Child);
Child.DockedPanel:=f_config_internet1.MainPanel;

f_config_solsys1.onShowDB:=ShowDBSetting;
f_config_solsys1.onPrepareAsteroid:=SolSysPrepareAsteroid;
f_config_system1.onShowAsteroid:=ShowAsteroidSetting;
f_config_system1.onShowComet:=ShowCometSetting;
f_config_system1.onLoadMPCSample:=LoadMPCSample;
f_config_system1.onDBChange:=SysDBChange;
f_config_system1.onSaveAndRestart:=SysSaveAndRestart;

{$ifdef mswindows}
 ScaleForm(self,Screen.PixelsPerInch/96);
 ScaleForm(f_config_time1,Screen.PixelsPerInch/96);
 ScaleForm(f_config_observatory1,Screen.PixelsPerInch/96);
 ScaleForm(f_config_chart1,Screen.PixelsPerInch/96);
 ScaleForm(f_config_catalog1,Screen.PixelsPerInch/96);
 ScaleForm(f_config_solsys1,Screen.PixelsPerInch/96);
 ScaleForm(f_config_display1,Screen.PixelsPerInch/96);
 ScaleForm(f_config_pictures1,Screen.PixelsPerInch/96);
 ScaleForm(f_config_system1,Screen.PixelsPerInch/96);
 ScaleForm(f_config_internet1,Screen.PixelsPerInch/96);
{$endif}
end;

procedure Tf_config.FormShow(Sender: TObject);
{$ifdef mswindows}var i:integer;{$endif}
begin
locktree:=false;
{$ifdef mswindows}
if Fnightvision<>nightvision then begin
   for i:=0 to MultiDoc1.ChildCount-1 do MultiDoc1.Childs[i].Color:=nv_dark;
   SetFormNightVision(self,nightvision);
   SetFormNightVision(f_config_time1,nightvision);
   SetFormNightVision(f_config_observatory1,nightvision);
   SetFormNightVision(f_config_chart1,nightvision);
   SetFormNightVision(f_config_catalog1,nightvision);
   SetFormNightVision(f_config_solsys1,nightvision);
   SetFormNightVision(f_config_display1,nightvision);
   SetFormNightVision(f_config_pictures1,nightvision);
   SetFormNightVision(f_config_system1,nightvision);
   SetFormNightVision(f_config_internet1,nightvision);
   Fnightvision:=nightvision;
end;
{$endif}
f_config_time1.FormShow(Sender);
f_config_observatory1.FormShow(Sender);
f_config_chart1.FormShow(Sender);
f_config_catalog1.FormShow(Sender);
f_config_solsys1.FormShow(Sender);
f_config_display1.FormShow(Sender);
f_config_pictures1.FormShow(Sender);
f_config_system1.FormShow(Sender);
f_config_internet1.FormShow(Sender);
TreeView1.FullCollapse;
Treeview1.selected:=Treeview1.items[0];
Treeview1.selected:=Treeview1.items[cmain.configpage];
lastSelectedNode:=Treeview1.selected;
end;

procedure Tf_config.TreeView1Change(Sender: TObject; Node: TTreeNode);
var i,j: integer;
begin
if locktree then exit;
if node=nil then begin
   Treeview1.selected:=lastSelectedNode;
   exit;
end;
try
if node.level=0 then begin
   Treeview1.selected:=Treeview1.items[(Treeview1.selected.absoluteindex+1)];
end else begin
   locktree:=true;
   i:=node.parent.index;
   j:=node.index;
   ShowPage(i,j);
   TreeView1.FullCollapse;
   node.Parent.Expand(true);
end;
lastSelectedNode:=Treeview1.selected;
application.processmessages;
finally
locktree:=false;
end;
end;

procedure Tf_config.ShowPage(i,j:Integer);
var k: integer;
begin
   // before the page change:
   if MultiDoc1.ActiveObject=f_config_catalog1 then begin
     if f_config_catalog1.Notebook1.ActivePageComponent=f_config_catalog1.Page1 then f_config_catalog1.ActivateGCat;
   end;
   if MultiDoc1.ActiveObject=f_config_system1 then begin
     if f_config_system1.Notebook1.ActivePageComponent=f_config_system1.Page1 then f_config_system1.ActivateDBchange;
   end;
   // page change
   for k:=0 to MultiDoc1.ChildCount-1 do MultiDoc1.Childs[k].Visible:=false;
   MultiDoc1.Childs[i].Visible:=true;
   MultiDoc1.SetActiveChild(i);
   case i of
     0 : begin f_config_time1.Notebook1.PageIndex:=j;        f_config_time1.FormShow(self);  end;
     1 : begin f_config_observatory1.Notebook1.PageIndex:=j; f_config_observatory1.FormShow(self);  end;
     2 : begin f_config_chart1.Notebook1.PageIndex:=j;       f_config_chart1.FormShow(self);  end;
     3 : begin f_config_catalog1.Notebook1.PageIndex:=j;     f_config_catalog1.FormShow(self);  end;
     4 : begin f_config_solsys1.Notebook1.PageIndex:=j;      f_config_solsys1.FormShow(self);  end;
     5 : begin f_config_display1.Notebook1.PageIndex:=j;     f_config_display1.FormShow(self); end;
     6 : begin f_config_pictures1.Notebook1.PageIndex:=j;    f_config_pictures1.FormShow(self);  end;
     7 : begin f_config_system1.Notebook1.PageIndex:=j;      f_config_system1.FormShow(self);  end;
     8 : begin f_config_internet1.Notebook1.PageIndex:=j;    f_config_internet1.FormShow(self);  end;
   end;
   cmain.configpage_i:=i;
   cmain.configpage_j:=j;
end;

procedure Tf_config.ActivateChanges;
var i:integer;
begin
  if Treeview1.selected<>nil then
     cmain.configpage:=Treeview1.selected.absoluteindex;
  if MultiDoc1.ActiveObject=f_config_catalog1 then begin
    if f_config_catalog1.Notebook1.ActivePageComponent=f_config_catalog1.Page1 then f_config_catalog1.ActivateGCat;
  end;
  if MultiDoc1.ActiveObject=f_config_system1 then begin
    if f_config_system1.Notebook1.ActivePageComponent=f_config_system1.Page1 then f_config_system1.ActivateDBchange;
  end;
  Fcdss:=f_config_internet1.cdss;
end;

procedure Tf_config.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  ActivateChanges;
end;

procedure Tf_config.FormDestroy(Sender: TObject);
begin
  Fcsc.free;
  Fccat.free;
  Fcshr.free;
  Fcplot.free;
  Fcmain.free;
  Fcdss.free;
end;

procedure Tf_config.HelpBtnClick(Sender: TObject);
begin
  MultiDoc1.ActiveObject.ShowHelp;
end;

procedure Tf_config.nextClick(Sender: TObject);
begin
if (Treeview1.selected<>nil)and(Treeview1.selected.absoluteindex< Treeview1.items.count-1) then begin
 Treeview1.selected:=Treeview1.selected.GetNext;
 treeview1.topitem:=Treeview1.selected;
 TreeView1Change(Sender,Treeview1.selected);
end;
end;

procedure Tf_config.previousClick(Sender: TObject);
var i : integer;
begin
if (Treeview1.selected<>nil)and(Treeview1.selected.absoluteindex>1) then begin
 locktree:=true;
 Treeview1.selected:=Treeview1.selected.GetPrev;
 if Treeview1.selected.level=0 then Treeview1.selected:=Treeview1.selected.GetPrev;
 i:=Treeview1.selected.absoluteindex;
 locktree:=false;
 Treeview1.selected:=Treeview1.items[i];
 treeview1.topitem:=Treeview1.selected;
 TreeView1Change(Sender,Treeview1.selected);
end;
end;

procedure Tf_config.ShowDBSetting(Sender: TObject);
begin
Treeview1.selected:=Treeview1.items[dbpage];
end;

procedure Tf_config.ShowCometSetting(Sender: TObject);
begin
Treeview1.selected:=Treeview1.items[compage];
end;

procedure Tf_config.ShowAsteroidSetting(Sender: TObject);
begin
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
f_config_observatory1.cdb:=value;
end;

procedure Tf_config.SetCcat(value: Tconf_catalog);
begin
Fccat.Assign(value);
f_config_time1.ccat:=Fccat;
f_config_observatory1.ccat:=Fccat;
f_config_chart1.ccat:=Fccat;
f_config_catalog1.ccat:=Fccat;
f_config_solsys1.ccat:=Fccat;
f_config_display1.ccat:=Fccat;
f_config_pictures1.ccat:=Fccat;
f_config_system1.ccat:=Fccat;
end;

procedure Tf_config.SetCshr(value: Tconf_shared);
begin
Fcshr.Assign(value);
f_config_time1.cshr:=Fcshr;
f_config_observatory1.cshr:=Fcshr;
f_config_chart1.cshr:=Fcshr;
f_config_catalog1.cshr:=Fcshr;
f_config_solsys1.cshr:=Fcshr;
f_config_display1.cshr:=Fcshr;
f_config_pictures1.cshr:=Fcshr;
f_config_system1.cshr:=Fcshr;
end;

procedure Tf_config.SetCsc(value: Tconf_skychart);
begin
Fcsc.Assign(value);
f_config_time1.csc:=Fcsc;
f_config_observatory1.csc:=Fcsc;
f_config_chart1.csc:=Fcsc;
f_config_catalog1.csc:=Fcsc;
f_config_solsys1.csc:=Fcsc;
f_config_display1.csc:=Fcsc;
f_config_pictures1.csc:=Fcsc;
f_config_system1.csc:=Fcsc;
end;

procedure Tf_config.SetCplot(value: Tconf_plot);
begin
Fcplot.Assign(value);
f_config_time1.cplot:=Fcplot;
f_config_observatory1.cplot:=Fcplot;
f_config_chart1.cplot:=Fcplot;
f_config_catalog1.cplot:=Fcplot;
f_config_solsys1.cplot:=Fcplot;
f_config_display1.cplot:=Fcplot;
f_config_pictures1.cplot:=Fcplot;
f_config_system1.cplot:=Fcplot;
end;

procedure Tf_config.SetCmain(value: Tconf_main);
begin
Fcmain.Assign(value);
f_config_time1.cmain:=Fcmain;
f_config_observatory1.cmain:=Fcmain;
f_config_chart1.cmain:=Fcmain;
f_config_catalog1.cmain:=Fcmain;
f_config_solsys1.cmain:=Fcmain;
f_config_display1.cmain:=Fcmain;
f_config_pictures1.cmain:=Fcmain;
f_config_system1.cmain:=Fcmain;
f_config_internet1.cmain:=Fcmain;
end;

procedure Tf_config.SetCdss(value: Tconf_dss);
begin
Fcdss.Assign(value);
f_config_pictures1.cdss:=Fcdss;
f_config_internet1.cdss:=Fcdss;
end;

procedure Tf_config.applyClick(Sender: TObject);
begin
ActivateChanges;
if assigned(FApplyConfig) then FApplyConfig(Self);
end;

initialization
  {$i pu_config.lrs}

end.




