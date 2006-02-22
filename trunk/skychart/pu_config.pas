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

uses u_constant, u_util,
  LCLIntf, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, Buttons, ExtCtrls, enhedits,
  cu_fits, cu_catalog, cu_database,
  pu_config_chart, pu_config_observatory, pu_config_time, pu_config_catalog,
  pu_config_system, pu_config_pictures, pu_config_display, pu_config_solsys,
  LResources, MultiDoc, ChildDoc;

type

  { Tf_config }

  Tf_config = class(TForm)
    MultiDoc1: TMultiDoc;
    Panel1: TPanel;
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
    procedure TreeView1Change(Sender: TObject; Node: TTreeNode);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure nextClick(Sender: TObject);
    procedure previousClick(Sender: TObject);
    procedure ApplyClick(Sender: TObject);
  private
    { Déclarations privées }
    locktree: boolean;
    Fccat : conf_catalog;
    Fcshr : conf_shared;
    Fcsc  : conf_skychart;
    Fcplot : conf_plot;
    Fcmain : conf_main;
    Fcdss : conf_dss;
    Fnightvision: boolean;
    astpage,compage,dbpage: integer;
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
    function GetFits: TFits;
    procedure SetFits(value: TFits);
    function GetCatalog: Tcatalog;
    procedure SetCatalog(value: Tcatalog);
    function GetDB: Tcdcdb;
    procedure SetDB(value: Tcdcdb);
    procedure SetCcat(value: conf_catalog);
    procedure SetCshr(value: conf_shared);
    procedure SetCsc(value: conf_skychart);
    procedure SetCplot(value: conf_plot);
    procedure SetCmain(value: conf_main);
    procedure SetCdss(value: conf_dss);
    procedure ShowDBSetting(Sender: TObject);
    procedure ShowCometSetting(Sender: TObject);
    procedure ShowAsteroidSetting(Sender: TObject);
    procedure LoadMPCSample(Sender: TObject);
    procedure SysDBChange(Sender: TObject);
    procedure SysSaveAndRestart(Sender: TObject);
    function  SolSysPrepareAsteroid(jdt:double; msg:Tstrings):boolean;
    procedure ShowPage(i,j:Integer);
  public
    { Déclarations publiques }
    property ccat : conf_catalog read Fccat write SetCcat;
    property cshr : conf_shared read Fcshr write SetCshr;
    property csc  : conf_skychart read Fcsc write SetCsc;
    property cplot : conf_plot read Fcplot write SetCplot;
    property cmain : conf_main read Fcmain write SetCmain;
    property cdss : conf_dss read Fcdss write SetCdss;
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

procedure Tf_config.FormCreate(Sender: TObject);
var Child: TChildDoc;
begin
compage:=22;
astpage:=23;
dbpage:=38;
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

f_config_solsys1.onShowDB:=ShowDBSetting;
f_config_solsys1.onPrepareAsteroid:=SolSysPrepareAsteroid;
f_config_system1.onShowAsteroid:=ShowAsteroidSetting;
f_config_system1.onShowComet:=ShowCometSetting;
f_config_system1.onLoadMPCSample:=LoadMPCSample;
f_config_system1.onDBChange:=SysDBChange;
f_config_system1.onSaveAndRestart:=SysSaveAndRestart;

{$ifdef win32}
 ScaleForm(self,Screen.PixelsPerInch/96);
 ScaleForm(f_config_time1,Screen.PixelsPerInch/96);
 ScaleForm(f_config_observatory1,Screen.PixelsPerInch/96);
 ScaleForm(f_config_chart1,Screen.PixelsPerInch/96);
 ScaleForm(f_config_catalog1,Screen.PixelsPerInch/96);
 ScaleForm(f_config_solsys1,Screen.PixelsPerInch/96);
 ScaleForm(f_config_display1,Screen.PixelsPerInch/96);
 ScaleForm(f_config_pictures1,Screen.PixelsPerInch/96);
 ScaleForm(f_config_system1,Screen.PixelsPerInch/96);
{$endif}
end;

procedure Tf_config.FormShow(Sender: TObject);
{$ifdef WIN32}var i:integer;{$endif}
begin
locktree:=false;
{$ifdef WIN32}
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
TreeView1.FullCollapse;
Treeview1.selected:=Treeview1.items[0];
Treeview1.selected:=Treeview1.items[cmain.configpage];
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
   ShowPage(i,j);
   TreeView1.FullCollapse;
   node.Parent.Expand(true);
end;
application.processmessages;
finally
locktree:=false;
end;
end;

procedure Tf_config.ShowPage(i,j:Integer);
begin
   // before the page change:
   if MultiDoc1.ActiveObject=f_config_catalog1 then begin
     if f_config_catalog1.WizardNotebook1.ActivePage='Page1' then f_config_catalog1.ActivateGCat;
   end;
   if MultiDoc1.ActiveObject=f_config_system1 then begin
     if f_config_system1.WizardNotebook1.ActivePage='Page1' then f_config_system1.ActivateDBchange;
   end;
   // page change
   MultiDoc1.SetActiveChild(i);
   case i of
     0 : begin f_config_time1.WizardNotebook1.PageIndex:=j;        f_config_time1.FormShow(self); end;
     1 : begin f_config_observatory1.WizardNotebook1.PageIndex:=j; f_config_observatory1.FormShow(self); end;
     2 : begin f_config_chart1.WizardNotebook1.PageIndex:=j;       f_config_chart1.FormShow(self); end;
     3 : begin f_config_catalog1.WizardNotebook1.PageIndex:=j;     f_config_catalog1.FormShow(self); end;
     4 : begin f_config_solsys1.WizardNotebook1.PageIndex:=j;      f_config_solsys1.FormShow(self); end;
     5 : begin f_config_display1.WizardNotebook1.PageIndex:=j;     f_config_display1.FormShow(self); end;
     6 : begin f_config_pictures1.WizardNotebook1.PageIndex:=j;    f_config_pictures1.FormShow(self); end;
     7 : begin f_config_system1.WizardNotebook1.PageIndex:=j;      f_config_system1.FormShow(self); end;
   end;
   cmain.configpage_i:=i;
   cmain.configpage_j:=j;
end;

procedure Tf_config.FormClose(Sender: TObject; var CloseAction: TCloseAction);
var i:integer;
begin
  i:=f_config.Treeview1.selected.absoluteindex;
  cmain.configpage:=i;
  if MultiDoc1.ActiveObject=f_config_catalog1 then begin
    if f_config_catalog1.WizardNotebook1.ActivePage='Page1' then f_config_catalog1.ActivateGCat;
  end;
  if MultiDoc1.ActiveObject=f_config_system1 then begin
    if f_config_system1.WizardNotebook1.ActivePage='Page1' then f_config_system1.ActivateDBchange;
  end;
  
  // todo: remove after correction of Lazarus bug 905
  f_config_time1.SimObjClickCheck(nil);

end;

procedure Tf_config.nextClick(Sender: TObject);
begin
if Treeview1.selected.absoluteindex< Treeview1.items.count-1 then begin
 Treeview1.selected:=Treeview1.selected.GetNext;
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

initialization
  {$i pu_config.lrs}

end.




