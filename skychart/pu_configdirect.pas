unit pu_configdirect;

{$MODE Delphi}{$H+}

{
Copyright (C) 2002 Patrick Chevalley

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
 Configuration form for use in script panel
 it share the config with the current chart instead of working with a copy
}

interface

uses
  u_help, u_translation, u_constant, u_util, UScaleDPI,
  LCLIntf, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, Buttons, ExtCtrls, enhedits,
  cu_fits, cu_catalog, cu_database,
  fu_config_chart, fu_config_observatory, fu_config_time, fu_config_catalog,
  fu_config_system, fu_config_pictures, fu_config_display, fu_config_solsys,
  fu_config_internet, fu_config_calendar,
  LResources, PairSplitter, LazHelpHTML_fix;

type

  { Tf_configdirect }

  Tf_configdirect = class(TForm)
    PageControl1: TPageControl;
    Panel4: TPanel;
    Splitter1: TSplitter;
    TabSheet1: TTabSheet;
    TabSheet10: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    TabSheet4: TTabSheet;
    TabSheet5: TTabSheet;
    TabSheet6: TTabSheet;
    TabSheet7: TTabSheet;
    TabSheet0: TTabSheet;
    TabSheet9: TTabSheet;
    PanelBottom: TPanel;
    Apply: TButton;
    HelpBtn: TButton;
    procedure HelpBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ApplyClick(Sender: TObject);
  private
    { Déclarations privées }
    f_config_system1: Tf_config_system;
    f_config_time1: Tf_config_time;
    f_config_observatory1: Tf_config_observatory;
    f_config_chart1: Tf_config_chart;
    f_config_solsys1: Tf_config_solsys;
    f_config_display1: Tf_config_display;
    f_config_pictures1: Tf_config_pictures;
    f_config_internet1: Tf_config_internet;
    f_config_calendar1: Tf_config_calendar;
    lockupd: boolean;
    Fccat: Tconf_catalog;
    Fcshr: Tconf_shared;
    Fcsc: Tconf_skychart;
    Fcplot: Tconf_plot;
    Fcmain: Tconf_main;
    Fcdss: Tconf_dss;
    FApplyConfig,FDisableAsteroid,FEnableAsteroid: TNotifyEvent;
    FPrepareAsteroid: TPrepareAsteroid;
    FGetTwilight: TGetTwilight;
    function GetFits: TFits;
    procedure SetFits(Value: TFits);
    function GetCatalog: Tcatalog;
    procedure SetCatalog(Value: Tcatalog);
    function GetDB: Tcdcdb;
    procedure SetDB(Value: Tcdcdb);
    procedure SetCcat(Value: Tconf_catalog);
    procedure SetCshr(Value: Tconf_shared);
    procedure SetCsc(Value: Tconf_skychart);
    procedure SetCplot(Value: Tconf_plot);
    procedure SetCmain(Value: Tconf_main);
    procedure SetCdss(Value: Tconf_dss);
    function SolSysPrepareAsteroid(jd1, jd2, step: double; msg: TStrings): boolean;
    procedure TimeGetTwilight(jd0: double; out ht: double);
    procedure ActivateChanges;
    procedure EnableAsteroid(Sender: TObject);
    procedure DisableAsteroid(Sender: TObject);
  public
    { Déclarations publiques }
    f_config_catalog1: Tf_config_catalog;
    procedure SetLang;
    procedure UpdateBtn;
    property ccat: Tconf_catalog read Fccat write SetCcat;
    property cshr: Tconf_shared read Fcshr write SetCshr;
    property csc: Tconf_skychart read Fcsc write SetCsc;
    property cplot: Tconf_plot read Fcplot write SetCplot;
    property cmain: Tconf_main read Fcmain write SetCmain;
    property cdss: Tconf_dss read Fcdss write SetCdss;
    property fits: TFits read GetFits write SetFits;
    property catalog: Tcatalog read GetCatalog write SetCatalog;
    property db: Tcdcdb read GetDB write SetDB;
    property onApplyConfig: TNotifyEvent read FApplyConfig write FApplyConfig;
    property onPrepareAsteroid: TPrepareAsteroid read FPrepareAsteroid write FPrepareAsteroid;
    property onGetTwilight: TGetTwilight read FGetTwilight write FGetTwilight;
    property onDisableAsteroid: TNotifyEvent read FDisableAsteroid write FDisableAsteroid;
    property onEnableAsteroid: TNotifyEvent read FEnableAsteroid write FEnableAsteroid;
  end;

var
  f_configdirect: Tf_configdirect;

implementation

{$R *.lfm}

procedure Tf_configdirect.SetLang;
begin
  Caption := rsConfiguratio;
  Apply.Caption := rsApply;
  HelpBtn.Caption := rsHelp;

  TabSheet0.Caption := rsGeneral;
  TabSheet1.Caption := rsDateTime2;
  TabSheet2.Caption := rsObservatory;
  TabSheet3.Caption := rsChartCoordin;
  TabSheet4.Caption := rsCatalog;
  TabSheet5.Caption := rsSolarSystem;
  TabSheet6.Caption := rsDisplay;
  TabSheet7.Caption := rsPictures;
  TabSheet9.Caption := rsUpdate1;
  TabSheet10.Caption := rsCalendar;

  if f_config_catalog1 <> nil then
    f_config_catalog1.SetLang;
  if f_config_chart1 <> nil then
    f_config_chart1.SetLang;
  if f_config_display1 <> nil then
    f_config_display1.SetLang;
  if f_config_internet1 <> nil then
    f_config_internet1.SetLang;
  if f_config_observatory1 <> nil then
    f_config_observatory1.SetLang;
  if f_config_pictures1 <> nil then
    f_config_pictures1.SetLang;
  if f_config_solsys1 <> nil then
    f_config_solsys1.SetLang;
  if f_config_system1 <> nil then
    f_config_system1.SetLang;
  if f_config_time1 <> nil then
    f_config_time1.SetLang;
  if f_config_calendar1 <> nil then
    f_config_calendar1.SetLang;
  SetHelp(self, hlpMenuSetup);
end;

procedure Tf_configdirect.FormCreate(Sender: TObject);
begin
  f_config_system1:= Tf_config_system.Create(Self);
  f_config_time1:= Tf_config_time.Create(Self);
  f_config_observatory1:= Tf_config_observatory.Create(Self);
  f_config_chart1:= Tf_config_chart.Create(Self);
  f_config_catalog1:= Tf_config_catalog.Create(Self);
  f_config_solsys1:= Tf_config_solsys.Create(Self);
  f_config_display1:= Tf_config_display.Create(Self);
  f_config_pictures1:= Tf_config_pictures.Create(Self);
  f_config_internet1:= Tf_config_internet.Create(Self);
  f_config_calendar1:= Tf_config_calendar.Create(Self);
  f_config_system1.parent:=TabSheet0 ;
  f_config_time1.parent:=TabSheet1 ;
  f_config_observatory1.parent:=TabSheet2 ;
  f_config_chart1.parent:=TabSheet3 ;
  f_config_catalog1.parent:=TabSheet4 ;
  f_config_solsys1.parent:=TabSheet5 ;
  f_config_display1.parent:=TabSheet6 ;
  f_config_pictures1.parent:=TabSheet7 ;
  f_config_internet1.parent:=TabSheet9 ;
  f_config_calendar1.parent:=TabSheet10 ;
  f_config_system1.Align:=alClient;
  f_config_time1.Align:=alClient;
  f_config_observatory1.Align:=alClient;
  f_config_chart1.Align:=alClient;
  f_config_catalog1.Align:=alClient;
  f_config_solsys1.Align:=alClient;
  f_config_display1.Align:=alClient;
  f_config_pictures1.Align:=alClient;
  f_config_internet1.Align:=alClient;
  f_config_calendar1.Align:=alClient;
  f_config_system1.PageControl1.ShowTabs:=true;
  f_config_time1.PageControl1.ShowTabs:=true;
  f_config_observatory1.PageControl1.ShowTabs:=true;
  f_config_chart1.PageControl1.ShowTabs:=true;
  f_config_catalog1.PageControl1.ShowTabs:=true;
  f_config_solsys1.PageControl1.ShowTabs:=true;
  f_config_display1.PageControl1.ShowTabs:=true;
  f_config_pictures1.PageControl1.ShowTabs:=true;
  f_config_internet1.PageControl1.ShowTabs:=true;
  f_config_calendar1.PageControl1.ShowTabs:=true;
  ScaleDPI(Self);
  SetLang;
  f_config_solsys1.onPrepareAsteroid := SolSysPrepareAsteroid;
  f_config_time1.onGetTwilight := TimeGetTwilight;
  lockupd := False;
end;

procedure Tf_configdirect.FormShow(Sender: TObject);
{$ifdef mswindows}var
  i: integer;
{$endif}
begin
  UpdateBtn;
end;

procedure Tf_configdirect.UpdateBtn;
begin
  if lockupd then exit;
  try
  lockupd:=true;
  f_config_time1.Init;
  f_config_observatory1.Init;
  f_config_chart1.Init;
  f_config_catalog1.Init;
  f_config_solsys1.Init;
  f_config_display1.Init;
  f_config_pictures1.Init;
  f_config_system1.Init;
  f_config_internet1.Init;
  f_config_calendar1.Init;
  finally
    lockupd:=false;
  end;
end;

procedure Tf_configdirect.ActivateChanges;
begin
  if PageControl1.PageIndex = 4 then
  begin // config catalog
    if f_config_catalog1.PageControl1.ActivePage = f_config_catalog1.Page1 then
      f_config_catalog1.ActivateGCat;
    if f_config_catalog1.PageControl1.ActivePage = f_config_catalog1.Page1b then
      f_config_catalog1.ActivateUserObjects;
  end;
  Fcdss := f_config_internet1.cdss;
end;

procedure Tf_configdirect.HelpBtnClick(Sender: TObject);
begin
  case PageControl1.PageIndex of
    0: f_config_system1.ShowHelp;
    1: f_config_time1.ShowHelp;
    2: f_config_observatory1.ShowHelp;
    3: f_config_chart1.ShowHelp;
    4: f_config_catalog1.ShowHelp;
    5: f_config_solsys1.ShowHelp;
    6: f_config_display1.ShowHelp;
    7: f_config_pictures1.ShowHelp;
    8: f_config_internet1.ShowHelp;
    9: f_config_calendar1.ShowHelp;
  end;
end;

function Tf_configdirect.SolSysPrepareAsteroid(jd1, jd2, step: double; msg: TStrings): boolean;
begin
  if assigned(FPrepareAsteroid) then
    Result := FPrepareAsteroid(jd1, jd2, step, msg)
  else
    Result := False;
end;

procedure Tf_configdirect.EnableAsteroid(Sender: TObject);
begin
   if assigned(FEnableAsteroid) then FEnableAsteroid(self);
end;

procedure Tf_configdirect.DisableAsteroid(Sender: TObject);
begin
   if assigned(FDisableAsteroid) then FDisableAsteroid(self);
end;

procedure Tf_configdirect.TimeGetTwilight(jd0: double; out ht: double);
begin
  if assigned(FGetTwilight) then
    FGetTwilight(jd0, ht)
  else
    ht := -99;
end;

function Tf_configdirect.GetFits: TFits;
begin
  Result := f_config_pictures1.Fits;
end;

procedure Tf_configdirect.SetFits(Value: TFits);
begin
  f_config_pictures1.Fits := Value;
end;

function Tf_configdirect.GetCatalog: Tcatalog;
begin
  Result := f_config_catalog1.catalog;
end;

procedure Tf_configdirect.SetCatalog(Value: Tcatalog);
begin
  f_config_catalog1.catalog := Value;
end;

function Tf_configdirect.GetDB: Tcdcdb;
begin
  Result := f_config_system1.cdb;
end;

procedure Tf_configdirect.SetDB(Value: Tcdcdb);
begin
  f_config_system1.cdb := Value;
  f_config_solsys1.cdb := Value;
  f_config_pictures1.cdb := Value;
  f_config_observatory1.cdb := Value;
  f_config_time1.cdb := Value;
end;

procedure Tf_configdirect.SetCcat(Value: Tconf_catalog);
begin
  Fccat := Value;
  f_config_time1.ccat := Fccat;
  f_config_observatory1.ccat := Fccat;
  f_config_chart1.ccat := Fccat;
  f_config_catalog1.ccat := Fccat;
  f_config_solsys1.ccat := Fccat;
  f_config_display1.ccat := Fccat;
  f_config_pictures1.ccat := Fccat;
  f_config_system1.ccat := Fccat;
end;

procedure Tf_configdirect.SetCshr(Value: Tconf_shared);
begin
  Fcshr := Value;
  f_config_time1.cshr := Fcshr;
  f_config_observatory1.cshr := Fcshr;
  f_config_chart1.cshr := Fcshr;
  f_config_catalog1.cshr := Fcshr;
  f_config_solsys1.cshr := Fcshr;
  f_config_display1.cshr := Fcshr;
  f_config_pictures1.cshr := Fcshr;
  f_config_system1.cshr := Fcshr;
end;

procedure Tf_configdirect.SetCsc(Value: Tconf_skychart);
begin
  Fcsc := Value;
  f_config_time1.csc := Fcsc;
  f_config_observatory1.csc := Fcsc;
  f_config_chart1.csc := Fcsc;
  f_config_catalog1.csc := Fcsc;
  f_config_solsys1.csc := Fcsc;
  f_config_display1.csc := Fcsc;
  f_config_pictures1.csc := Fcsc;
  f_config_system1.csc := Fcsc;
  f_config_calendar1.csc := Fcsc;
end;

procedure Tf_configdirect.SetCplot(Value: Tconf_plot);
begin
  Fcplot := Value;
  f_config_time1.cplot := Fcplot;
  f_config_observatory1.cplot := Fcplot;
  f_config_chart1.cplot := Fcplot;
  f_config_catalog1.cplot := Fcplot;
  f_config_solsys1.cplot := Fcplot;
  f_config_display1.cplot := Fcplot;
  f_config_pictures1.cplot := Fcplot;
  f_config_system1.cplot := Fcplot;
end;

procedure Tf_configdirect.SetCmain(Value: Tconf_main);
begin
  Fcmain := Value;
  f_config_time1.cmain := Fcmain;
  f_config_observatory1.cmain := Fcmain;
  f_config_chart1.cmain := Fcmain;
  f_config_catalog1.cmain := Fcmain;
  f_config_solsys1.cmain := Fcmain;
  f_config_display1.cmain := Fcmain;
  f_config_pictures1.cmain := Fcmain;
  f_config_system1.cmain := Fcmain;
  f_config_internet1.cmain := Fcmain;
end;

procedure Tf_configdirect.SetCdss(Value: Tconf_dss);
begin
  Fcdss := Value;
  f_config_pictures1.cdss := Fcdss;
  f_config_internet1.cdss := Fcdss;
end;

procedure Tf_configdirect.applyClick(Sender: TObject);
begin
  f_config_observatory1.Button6Click(nil);
  f_config_solsys1.ActivateJplEph;
  ActivateChanges;
  if assigned(FApplyConfig) then
    FApplyConfig(Self);
end;

end.
