unit fu_script;

{$mode objfpc}{$H+}

{
Copyright (C) 2014 Patrick Chevalley

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
 Script panel container
}

interface

uses
  u_translation, u_constant, u_help, pu_edittoolbar, pu_scriptengine, u_util,
  fu_chart, cu_database, cu_catalog, cu_fits, cu_planet, MultiFrame,
  ActnList, Menus, Classes, SysUtils, FileUtil, Forms, Controls, ExtCtrls,
  StdCtrls, ComCtrls, Buttons;

type

  { Tf_script }

  Tf_script = class(TFrame)
    ButtonConfig: TBitBtn;
    ButtonEditSrc: TBitBtn;
    BottomPanel: TPanel;
    LabelShortcut: TLabel;
    MainPanel: TPanel;
    PanelTitle: TPanel;
    SpeedButton1: TSpeedButton;
    ToolBar1: TToolBar;
    ToolBar2: TToolBar;
    procedure ButtonConfigClick(Sender: TObject);
    procedure ButtonEditSrcClick(Sender: TObject);
    procedure FrameResize(Sender: TObject);
    procedure PanelTitleMouseEnter(Sender: TObject);
    procedure PanelTitleMouseLeave(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
  private
    { private declarations }
    FScriptFilename: string;
    fedittoolbar: Tf_edittoolbar;
    fscriptengine: Tf_scriptengine;
    FImageNormal: TImageList;
    FContainerPanel: TPanel;
    FToolButtonMouseUp, FToolButtonMouseDown: TMouseEvent;
    FActionListFile, FActionListEdit, FActionListSetup,
    FActionListView, FActionListChart, FActionListTelescope, FActionListWindow: TActionList;
    FTimeValPanel, FMainTimeValPanel: Tpanel;
    FEditTimeVal, FMainEditTimeVal: TEdit;
    FTimeVal, FMainTimeVal: TUpDown;
    FTimeU, FMainTimeU: TComboBox;
    FMainmenu: TMenu;
    FMultiFrame: TMultiframe;
    Fcdb: TCDCdb;
    Fcatalog: TCatalog;
    Ffits: TFits;
    Fplanet: Tplanet;
    Fcmain: Tconf_main;
    FExecuteCmd: TExecuteCmd;
    FCometMark: TExecuteCmd;
    FAsteroidMark: TExecuteCmd;
    FGetScopeRates: TExecuteCmd;
    FSendInfo: TSendInfo;
    FActivechart: Tf_chart;
    FonApply: TNotifyEvent;
    FScriptTitle: string;
    FConfigToolbar1, FConfigToolbar2, FConfigScriptButton, FConfigCombo,
    FConfigScript, FConfigEvent: TStringList;
    FTelescopeConnected: boolean;
    TelescopeChartName: string;
    FToolboxConfig: TNotifyEvent;
    procedure CreateEngine;
    procedure ApplyScript(Sender: TObject);
    procedure SetExecuteCmd(Value: TExecuteCmd);
    procedure SetCometMark(Value: TExecuteCmd);
    procedure SetAsteroidMark(Value: TExecuteCmd);
    procedure SetGetScopeRates(Value: TExecuteCmd);
    procedure SetSendInfo(Value: TSendInfo);
    procedure SetActiveChart(Value: Tf_chart);
    procedure SetMainmenu(Value: TMenu);
    procedure SetMultiFrame(Value: TMultiFrame);
    procedure SetCDB(Value: TCDCdb);
    procedure SetCatalog(Value: TCatalog);
    procedure SetPlanet(Value: TPlanet);
    procedure SetFits(Value: TFits);
    procedure SetTimeU(Value: TComboBox);
    procedure SetTimeValPanel(Value: TPanel);
    procedure SetEditTimeVal(Value: TEdit);
    procedure SetTimeVal(Value: TUpDown);
    procedure TimeUChange(Sender: TObject);
    procedure EditTimeValChange(Sender: TObject);
    procedure TimeValChangingEx(Sender: TObject; var AllowChange: boolean;
      NewValue: smallint; Direction: TUpDownDirection);
    procedure EditToolBar(Sender: TObject);

  public
    { public declarations }
    constructor Create(TheOwner: TComponent); override;
    destructor Destroy; override;
    procedure SetLang;
    procedure Init;
    procedure Loadfile;
    procedure ShowScript(onoff: boolean);
    procedure SetMenu(aMenu: TMenuItem);
    procedure ChartRefreshEvent(origin, str: string);
    procedure ObjectSelectionEvent(origin, str, longstr: string);
    procedure DistanceMeasurementEvent(origin, str: string);
    procedure TelescopeMoveEvent(origin: string; ra, de: double);
    procedure TelescopeConnectEvent(origin: string; connected: boolean);
    procedure ActivateEvent;
    property ScriptFilename: string read FScriptFilename write FScriptFilename;
    property ImageNormal: TImageList read FImageNormal write FImageNormal;
    property ContainerPanel: TPanel read FContainerPanel write FContainerPanel;
    property ToolButtonMouseUp: TMouseEvent read FToolButtonMouseUp
      write FToolButtonMouseUp;
    property ToolButtonMouseDown: TMouseEvent
      read FToolButtonMouseDown write FToolButtonMouseDown;
    property ActionListFile: TActionList read FActionListFile write FActionListFile;
    property ActionListEdit: TActionList read FActionListEdit write FActionListEdit;
    property ActionListSetup: TActionList read FActionListSetup write FActionListSetup;
    property ActionListView: TActionList read FActionListView write FActionListView;
    property ActionListChart: TActionList read FActionListChart write FActionListChart;
    property ActionListTelescope: TActionList
      read FActionListTelescope write FActionListTelescope;
    property ActionListWindow: TActionList read FActionListWindow
      write FActionListWindow;
    property TimeValPanel: Tpanel read FTimeValPanel write SetTimeValPanel;
    property EditTimeVal: TEdit read FEditTimeVal write SetEditTimeVal;
    property TimeVal: TUpDown read FTimeVal write SetTimeVal;
    property TimeU: TComboBox read FTimeU write SetTimeU;
    property Mainmenu: TMenu read FMainmenu write SetMainmenu;
    property MultiFrame: TMultiFrame read FMultiFrame write SetMultiFrame;
    property cdb: TCDCdb read Fcdb write SetCDB;
    property planet: Tplanet read Fplanet write Setplanet;
    property fits: Tfits read Ffits write Setfits;
    property catalog: Tcatalog read Fcatalog write Setcatalog;
    property cmain: Tconf_main read Fcmain write Fcmain;
    property ConfigToolbar1: TStringList read FConfigToolbar1 write FConfigToolbar1;
    property ConfigToolbar2: TStringList read FConfigToolbar2 write FConfigToolbar2;
    property ConfigScriptButton: TStringList
      read FConfigScriptButton write FConfigScriptButton;
    property ConfigScript: TStringList read FConfigScript write FConfigScript;
    property ConfigCombo: TStringList read FConfigCombo write FConfigCombo;
    property ConfigEvent: TStringList read FConfigEvent write FConfigEvent;
    property ExecuteCmd: TExecuteCmd read FExecuteCmd write SetExecuteCmd;
    property CometMark: TExecuteCmd read FCometMark write SetCometMark;
    property AsteroidMark: TExecuteCmd read FAsteroidMark write SetAsteroidMark;
    property GetScopeRates: TExecuteCmd read FGetScopeRates write SetGetScopeRates;
    property SendInfo: TSendInfo read FSendInfo write SetSendInfo;
    property ActiveChart: Tf_chart read FActiveChart write SetActiveChart;
    property onApply: TNotifyEvent read FonApply write FonApply;
    property onToolboxConfig: TNotifyEvent read FToolboxConfig write FToolboxConfig;
    property ScriptTitle: string read FScriptTitle;
  end;

implementation

{$R *.lfm}

{ Tf_script }

procedure Tf_script.SetLang;
begin
  ButtonConfig.Caption := rsManageToolbo;
  ButtonEditSrc.Caption := rsScriptEditor;
  fedittoolbar.SetLang;
  FScriptTitle := '';
  if fscriptengine <> nil then
  begin
    fscriptengine.SetLang;
    FScriptTitle := fscriptengine.Title;
  end;
  if FScriptTitle = '' then
    PanelTitle.Caption := rsToolBox + ' ' + IntToStr(tag + 1)
  else
    PanelTitle.Caption := FScriptTitle;
  SetHelp(self, hlpToolbox);
end;

constructor Tf_script.Create(TheOwner: TComponent);
begin
  inherited Create(TheOwner);
  FScriptTitle := '';
  FScriptFilename := '';
  FTelescopeConnected := False;
  fedittoolbar := Tf_edittoolbar.Create(self);
  fedittoolbar.ButtonMini.Visible := False;
  fedittoolbar.ButtonStd.Visible := False;
  FConfigToolbar1 := TStringList.Create;
  FConfigToolbar2 := TStringList.Create;
  FConfigScriptButton := TStringList.Create;
  FConfigScript := TStringList.Create;
  FConfigCombo := TStringList.Create;
  FConfigEvent := TStringList.Create;
end;

destructor Tf_script.Destroy;
begin
  fedittoolbar.Free;
  FConfigToolbar1.Free;
  FConfigToolbar2.Free;
  FConfigScriptButton.Free;
  FConfigScript.Free;
  FConfigCombo.Free;
  FConfigEvent.Free;
  if fscriptengine <> nil then
    fscriptengine.Free;
  inherited Destroy;
end;

procedure Tf_script.ShowScript(onoff: boolean);
begin
  if onoff <> Visible then
  begin
    Visible := onoff;
    if Visible then
    begin
      if fscriptengine <> nil then
      begin
        fscriptengine.EventReady := True;
        fscriptengine.StartTimer;
        fscriptengine.TelescopeConnectEvent(TelescopeChartName, FTelescopeConnected);
        fscriptengine.ActivateEvent;
      end;
    end
    else
    if fscriptengine <> nil then
    begin
      if not fscriptengine.CheckBoxAlwaysActive.Checked then
        fscriptengine.StopAllScript;
      fscriptengine.Hide;
      if fscriptengine.CheckBoxAlwaysActive.Checked or
        fscriptengine.CheckBoxHidenTimer.Checked then
        fscriptengine.StartTimer;
    end;
  end;
end;

procedure Tf_script.CreateEngine;
begin
  fscriptengine := Tf_scriptengine.Create(self);
  fscriptengine.Tag := Tag;
  fscriptengine.ConfigToolbar1 := ConfigToolbar1;
  fscriptengine.ConfigToolbar2 := ConfigToolbar2;
  fscriptengine.editsurface := MainPanel;
  fscriptengine.onApply := @ApplyScript;
  fscriptengine.onEditToolBar := @EditToolBar;
  fscriptengine.ExecuteCmd := FExecuteCmd;
  fscriptengine.CometMark := FCometMark;
  fscriptengine.AsteroidMark := FAsteroidMark;
  fscriptengine.GetScopeRates := FGetScopeRates;
  fscriptengine.SendInfo := FSendInfo;
  fscriptengine.Activechart := FActivechart;
  fscriptengine.Mainmenu := FMainmenu;
  fscriptengine.MultiFrame := FMultiFrame;
  fscriptengine.cdb := Fcdb;
  fscriptengine.catalog := Fcatalog;
  fscriptengine.fits := Ffits;
  fscriptengine.planet := Fplanet;
  fscriptengine.cmain := Fcmain;
end;

procedure Tf_script.Loadfile;
begin
  if (fscriptengine <> nil) then
    fscriptengine.LoadFile(FScriptFilename);
end;

procedure Tf_script.Init;
begin
  LabelShortcut.Caption := 'F' + IntToStr(tag + 1);
  ToolBar1.Images := FImageNormal;
  ToolBar2.Images := FImageNormal;
  fedittoolbar.Images := FImageNormal;
  fedittoolbar.DisabledContainer := FContainerPanel;
  fedittoolbar.TBOnMouseUp := FToolButtonMouseUp;
  fedittoolbar.TBOnMouseDown := FToolButtonMouseDown;
  fedittoolbar.ClearAction;
  fedittoolbar.DefaultAction := rsFile;
  fedittoolbar.AddAction(FActionListFile, rsFile);
  fedittoolbar.AddAction(FActionListEdit, rsEdit);
  fedittoolbar.AddAction(FActionListSetup, rsSetup);
  fedittoolbar.AddAction(FActionListView, rsView);
  fedittoolbar.AddAction(FActionListChart, rsChart);
  fedittoolbar.AddAction(FActionListTelescope, rsTelescope);
  fedittoolbar.AddAction(FActionListWindow, rsWindow);
  fedittoolbar.ClearControl;
  fedittoolbar.AddOtherControl(FTimeValPanel, rsEditTimeIncr,
    rsAnimation, rsChart, 103);
  fedittoolbar.AddOtherControl(FTimeU, rsSelectTimeUn, rsAnimation, rsChart, 104);
  fedittoolbar.ClearToolbar;
  fedittoolbar.DefaultToolbar := ToolBar1.Caption;
  fedittoolbar.AddToolbar(ToolBar1);
  fedittoolbar.AddToolbar(ToolBar2);
  fedittoolbar.ProcessActions;
  fedittoolbar.LoadToolbar(0, ConfigToolbar1);
  fedittoolbar.LoadToolbar(1, ConfigToolbar2);
  fedittoolbar.ActivateToolbar;
  ToolBar1.Visible := (VisibleControlCount(ToolBar1) > 0);
  ToolBar2.Visible := (VisibleControlCount(ToolBar2) > 0);
  if fscriptengine = nil then
  begin
    CreateEngine;
  end;
  fscriptengine.LoadFile(FScriptFilename);
  fscriptengine.InitialLoad := False;
end;

procedure Tf_script.EditToolBar(Sender: TObject);
begin
  fedittoolbar.LoadToolbar(0, ConfigToolbar1);
  fedittoolbar.LoadToolbar(1, ConfigToolbar2);
  FormPos(fedittoolbar, mouse.cursorpos.x, mouse.cursorpos.y);
  fedittoolbar.ShowModal;
  if fedittoolbar.ModalResult = mrOk then
  begin
    fedittoolbar.SaveToolbar(0, ConfigToolbar1);
    fedittoolbar.SaveToolbar(1, ConfigToolbar2);
    ToolBar1.Visible := (VisibleControlCount(ToolBar1) > 0);
    ToolBar2.Visible := (VisibleControlCount(ToolBar2) > 0);
  end;
end;

procedure Tf_script.ButtonConfigClick(Sender: TObject);
begin
  if assigned(FToolboxConfig) then
    FToolboxConfig(self);
end;

procedure Tf_script.ButtonEditSrcClick(Sender: TObject);
begin
  if fscriptengine = nil then
  begin
    CreateEngine;
    fscriptengine.InitialLoad := False;
  end;
  FormPos(fscriptengine, mouse.cursorpos.x, mouse.cursorpos.y);
  fscriptengine.Show;
end;

procedure Tf_script.FrameResize(Sender: TObject);
begin
  MainPanel.Width := ClientWidth;
  MainPanel.Constraints.MaxWidth := ClientWidth;
  MainPanel.Constraints.MinWidth := ClientWidth;
end;

procedure Tf_script.PanelTitleMouseEnter(Sender: TObject);
begin
  SpeedButton1.Visible := True;
end;

procedure Tf_script.PanelTitleMouseLeave(Sender: TObject);
begin
  SpeedButton1.Visible := False;
end;

procedure Tf_script.SpeedButton1Click(Sender: TObject);
begin
  ShowHelp;
end;

procedure Tf_script.ApplyScript(Sender: TObject);
begin
  fscriptengine.Save(FConfigScriptButton, FConfigScript, FConfigCombo,
    FConfigEvent, FScriptTitle);
  if FScriptTitle <> '' then
    PanelTitle.Caption := FScriptTitle
  else
    PanelTitle.Caption := rsToolBox + ' ' + IntToStr(tag + 1);
  fedittoolbar.LoadToolbar(0, ConfigToolbar1);
  fedittoolbar.LoadToolbar(1, ConfigToolbar2);
  fedittoolbar.ActivateToolbar;
  ToolBar1.Visible := (VisibleControlCount(ToolBar1) > 0);
  ToolBar2.Visible := (VisibleControlCount(ToolBar2) > 0);
  FScriptFilename := fscriptengine.ScriptFilename;
  if Assigned(FonApply) then
    FonApply(self);
end;

procedure Tf_script.SetExecuteCmd(Value: TExecuteCmd);
begin
  FExecuteCmd := Value;
  if fscriptengine <> nil then
    fscriptengine.ExecuteCmd := FExecuteCmd;
end;

procedure Tf_script.SetCometMark(Value: TExecuteCmd);
begin
  FCometMark := Value;
  if fscriptengine <> nil then
    fscriptengine.CometMark := FCometMark;
end;

procedure Tf_script.SetAsteroidMark(Value: TExecuteCmd);
begin
  FAsteroidMark := Value;
  if fscriptengine <> nil then
    fscriptengine.AsteroidMark := FAsteroidMark;
end;

procedure Tf_script.SetGetScopeRates(Value: TExecuteCmd);
begin
  FGetScopeRates := Value;
  if fscriptengine <> nil then
    fscriptengine.GetScopeRates := FGetScopeRates;
end;

procedure Tf_script.SetSendInfo(Value: TSendInfo);
begin
  FSendInfo := Value;
  if fscriptengine <> nil then
    fscriptengine.SendInfo := FSendInfo;
end;

procedure Tf_script.SetActiveChart(Value: Tf_chart);
begin
  FActivechart := Value;
  if fscriptengine <> nil then
    fscriptengine.Activechart := FActivechart;
end;

procedure Tf_script.SetMainmenu(Value: TMenu);
begin
  FMainmenu := Value;
  if fscriptengine <> nil then
    fscriptengine.Mainmenu := FMainmenu;
end;

procedure Tf_script.SetMultiFrame(Value: TMultiFrame);
begin
  FMultiFrame := Value;
  if fscriptengine <> nil then
    fscriptengine.MultiFrame := FMultiFrame;
end;

procedure Tf_script.SetCDB(Value: TCDCdb);
begin
  Fcdb := Value;
  if fscriptengine <> nil then
    fscriptengine.cdb := Fcdb;
end;

procedure Tf_script.SetCatalog(Value: TCatalog);
begin
  Fcatalog := Value;
  if fscriptengine <> nil then
    fscriptengine.catalog := Fcatalog;
end;

procedure Tf_script.SetPlanet(Value: TPlanet);
begin
  Fplanet := Value;
  if fscriptengine <> nil then
    fscriptengine.planet := Fplanet;
end;

procedure Tf_script.SetFits(Value: TFits);
begin
  Ffits := Value;
  if fscriptengine <> nil then
    fscriptengine.fits := Ffits;
end;

procedure Tf_script.SetMenu(aMenu: TMenuItem);
begin
  if fscriptengine <> nil then
    fscriptengine.SetMenu(aMenu);
end;

procedure Tf_script.ChartRefreshEvent(origin, str: string);
begin
  if fscriptengine <> nil then
    fscriptengine.ChartRefreshEvent(origin, str);
end;

procedure Tf_script.ObjectSelectionEvent(origin, str, longstr: string);
begin
  if fscriptengine <> nil then
    fscriptengine.ObjectSelectionEvent(origin, str, longstr);
end;

procedure Tf_script.DistanceMeasurementEvent(origin, str: string);
begin
  if fscriptengine <> nil then
    fscriptengine.DistanceMeasurementEvent(origin, str);
end;

procedure Tf_script.TelescopeMoveEvent(origin: string; ra, de: double);
begin
  if fscriptengine <> nil then
    fscriptengine.TelescopeMoveEvent(origin, ra, de);
end;

procedure Tf_script.TelescopeConnectEvent(origin: string; connected: boolean);
begin
  FTelescopeConnected := connected;
  TelescopeChartName := origin;
  if Visible and (fscriptengine <> nil) then
    fscriptengine.TelescopeConnectEvent(origin, connected);
end;

procedure Tf_script.ActivateEvent;
begin
  if fscriptengine <> nil then
    fscriptengine.ActivateEvent;
end;

procedure Tf_script.SetTimeU(Value: TComboBox);
var
  i: integer;
begin
  FMainTimeU := Value;
  if FTimeU <> nil then
    FreeAndNil(FTimeU);
  FTimeU := TComboBox.Create(self);
  FTimeU.Style := Value.Style;
  FTimeU.Width := Value.Width;
  FTimeU.Height := Value.Height;
  FTimeU.Caption := Value.Caption;
  FTimeU.Hint := Value.Hint;
  FTimeU.Name := Value.Name;
  for i := 0 to Value.Items.Count - 1 do
    FTimeU.Items.Add(Value.Items[i]);
  FTimeU.ItemIndex := Value.ItemIndex;
  FTimeU.OnChange := @TimeUChange;
end;

procedure Tf_script.SetTimeValPanel(Value: TPanel);
begin
  FMainTimeValPanel := Value;
  if FTimeValPanel <> nil then
    FreeAndNil(FTimeValPanel);
  FTimeValPanel := TPanel.Create(self);
  FTimeValPanel.Name := Value.Name;
  FTimeValPanel.Caption := Value.Caption;
  FTimeValPanel.BevelOuter := Value.BevelOuter;
  FTimeValPanel.Width := Value.Width;
  FTimeValPanel.Height := Value.Height;
end;

procedure Tf_script.SetEditTimeVal(Value: TEdit);
begin
  FMainEditTimeVal := Value;
  if FEditTimeVal <> nil then
    FreeAndNil(FEditTimeVal);
  FEditTimeVal := TEdit.Create(self);
  FEditTimeVal.Name := Value.Name;
  FEditTimeVal.Parent := FTimeValPanel;
  FEditTimeVal.Width := Value.Width;
  FEditTimeVal.Height := Value.Height;
  FEditTimeVal.Top := Value.Top;
  FEditTimeVal.Left := Value.Left;
  FEditTimeVal.Text := Value.Text;
  FEditTimeVal.OnChange := @EditTimeValChange;
end;

procedure Tf_script.SetTimeVal(Value: TUpDown);
begin
  FMainTimeVal := Value;
  if FTimeVal <> nil then
    FreeAndNil(FTimeVal);
  FTimeVal := TUpDown.Create(self);
  FTimeVal.Parent := FTimeValPanel;
  FTimeVal.Name := Value.Name;
  FTimeVal.Width := Value.Width;
  FTimeVal.Height := Value.Height;
  FTimeVal.Top := Value.Top;
  FTimeVal.Left := Value.Left;
  FTimeVal.Max := Value.Max;
  FTimeVal.Min := Value.Min;
  FTimeVal.Thousands := Value.Thousands;
  FTimeVal.Associate := FEditTimeVal;
  FTimeVal.Position := Value.Position;
  FTimeVal.OnChangingEx := @TimeValChangingEx;
end;

procedure Tf_script.TimeUChange(Sender: TObject);
begin
  FMainTimeU.ItemIndex := TimeU.ItemIndex;
  FMainTimeU.OnChange(self);
end;

procedure Tf_script.EditTimeValChange(Sender: TObject);
var
  i, n: integer;
begin
  val(FEditTimeVal.Text, i, n);
  if (n = 0) and (i = 0) then
    FEditTimeVal.Text := '1';
  FTimeVal.Position := strtointdef(FEditTimeVal.Text, 1);
  FMainEditTimeVal.Text := FEditTimeVal.Text;
end;

procedure Tf_script.TimeValChangingEx(Sender: TObject; var AllowChange: boolean;
  NewValue: smallint; Direction: TUpDownDirection);
begin
  if NewValue = 0 then
  begin
    if FTimeVal.Position > 0 then
      FTimeVal.Position := -1
    else
      FTimeVal.Position := 1;
    AllowChange := False;
  end;
  FMainTimeVal.Position := FTimeVal.Position;
end;


end.
