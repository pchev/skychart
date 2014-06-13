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
Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
}
{
 Script panel container
}

interface

uses  u_translation, u_constant, u_help, pu_edittoolbar, pu_scriptengine, u_util,
  fu_chart, cu_database, cu_catalog, cu_fits, cu_planet,
  ActnList, Menus, Classes, SysUtils, FileUtil, Forms, Controls, ExtCtrls,
  StdCtrls, ComCtrls, Buttons;

type

  { Tf_script }

  Tf_script = class(TFrame)
    ButtonEditTB: TBitBtn;
    ButtonEditSrc: TBitBtn;
    BottomPanel: TPanel;
    Label1: TLabel;
    LabelShortcut: TLabel;
    MainPanel: TPanel;
    PanelTitle: TPanel;
    ToolBar1: TToolBar;
    ToolBar2: TToolBar;
    procedure ButtonEditTBClick(Sender: TObject);
    procedure ButtonEditSrcClick(Sender: TObject);
  private
    { private declarations }
    fedittoolbar: Tf_edittoolbar;
    fscriptengine: Tf_scriptengine;
    FImageNormal: TImageList;
    FContainerPanel: TPanel;
    FToolButtonMouseUp,FToolButtonMouseDown: TMouseEvent;
    FActionListFile,FActionListEdit,FActionListSetup,
    FActionListView,FActionListChart,FActionListTelescope,FActionListWindow: TActionList;
    FTimeValPanel,FMainTimeValPanel: Tpanel;
    FEditTimeVal,FMainEditTimeVal: TEdit;
    FTimeVal,FMainTimeVal: TUpDown;
    FTimeU,FMainTimeU: TComboBox;
    FMainmenu: TMenu;
    Fcdb: TCDCdb;
    Fcatalog: TCatalog;
    Ffits : TFits;
    Fplanet  : Tplanet;
    Fcmain: Tconf_main;
    FExecuteCmd: TExecuteCmd;
    FCometMark: TExecuteCmd;
    FAsteroidMark: TExecuteCmd;
    FGetScopeRates: TExecuteCmd;
    FSendInfo: TSendInfo;
    FActivechart: Tf_chart;
    FonApply: TNotifyEvent;
    FScriptTitle: string;
    FConfigToolbar1,FConfigToolbar2,FConfigScriptButton,FConfigCombo,FConfigScript,FConfigEvent: TStringList;
    FHidenTimer: Boolean;
    FTelescopeConnected: Boolean;
    TelescopeChartName: string;
    procedure CreateEngine;
    procedure ApplyScript(Sender: TObject);
    procedure SetExecuteCmd(value:TExecuteCmd);
    procedure SetCometMark(value:TExecuteCmd);
    procedure SetAsteroidMark(value:TExecuteCmd);
    procedure SetGetScopeRates(value:TExecuteCmd);
    procedure SetSendInfo(value:TSendInfo);
    procedure SetActiveChart(value:Tf_chart);
    function  GetHidenTimer: Boolean;
    procedure SetHidenTimer(value:Boolean);
    procedure SetMainmenu(value:TMenu);
    procedure SetCDB(value:TCDCdb);
    procedure SetCatalog(value:TCatalog);
    procedure SetPlanet(value:TPlanet);
    procedure SetFits(value:TFits);
    procedure SetTimeU(value:TComboBox);
    procedure SetTimeValPanel(value:TPanel);
    procedure SetEditTimeVal(value:TEdit);
    procedure SetTimeVal(value:TUpDown);
    procedure TimeUChange(Sender: TObject);
    procedure EditTimeValChange(Sender: TObject);
    procedure TimeValChangingEx(Sender: TObject; var AllowChange: Boolean; NewValue: SmallInt; Direction: TUpDownDirection);

  public
    { public declarations }
    constructor Create(TheOwner: TComponent); override;
    destructor Destroy; override;
    procedure SetLang;
    procedure Init;
    procedure ShowScript(onoff:boolean);
    procedure ChartRefreshEvent(origin,str:string);
    procedure ObjectSelectionEvent(origin,str,longstr:string);
    procedure DistanceMeasurementEvent(origin,str:string);
    procedure TelescopeMoveEvent(origin:string; ra,de: double);
    procedure TelescopeConnectEvent(origin:string; connected: boolean);
    procedure ActivateEvent;
    property ImageNormal: TImageList read FImageNormal  write FImageNormal ;
    property ContainerPanel: TPanel read FContainerPanel  write FContainerPanel ;
    property ToolButtonMouseUp: TMouseEvent read FToolButtonMouseUp  write FToolButtonMouseUp ;
    property ToolButtonMouseDown: TMouseEvent read FToolButtonMouseDown  write FToolButtonMouseDown ;
    property ActionListFile: TActionList read FActionListFile  write FActionListFile ;
    property ActionListEdit: TActionList read  FActionListEdit write FActionListEdit ;
    property ActionListSetup: TActionList read FActionListSetup  write FActionListSetup ;
    property ActionListView: TActionList read FActionListView  write FActionListView ;
    property ActionListChart: TActionList read FActionListChart  write FActionListChart ;
    property ActionListTelescope: TActionList read FActionListTelescope  write FActionListTelescope ;
    property ActionListWindow: TActionList read FActionListWindow  write FActionListWindow ;
    property TimeValPanel: Tpanel read FTimeValPanel  write SetTimeValPanel ;
    property EditTimeVal: TEdit read FEditTimeVal  write SetEditTimeVal ;
    property TimeVal: TUpDown read FTimeVal  write SetTimeVal ;
    property TimeU: TComboBox read FTimeU  write SetTimeU ;
    property Mainmenu: TMenu read FMainmenu  write SetMainmenu;
    property cdb: TCDCdb read Fcdb  write SetCDB;
    property planet: Tplanet read Fplanet write Setplanet;
    property fits: Tfits read Ffits write Setfits;
    property catalog: Tcatalog read Fcatalog write Setcatalog;
    property cmain: Tconf_main read Fcmain write Fcmain;
    property ConfigToolbar1: TStringList read FConfigToolbar1 write FConfigToolbar1;
    property ConfigToolbar2: TStringList read FConfigToolbar2 write FConfigToolbar2;
    property ConfigScriptButton: TStringList read FConfigScriptButton write FConfigScriptButton;
    property ConfigScript: TStringList read FConfigScript write FConfigScript;
    property ConfigCombo: TStringList read FConfigCombo write FConfigCombo;
    property ConfigEvent: TStringList read FConfigEvent write FConfigEvent;
    property ExecuteCmd: TExecuteCmd read FExecuteCmd write SetExecuteCmd;
    property CometMark: TExecuteCmd read FCometMark write SetCometMark;
    property AsteroidMark: TExecuteCmd read FAsteroidMark write SetAsteroidMark;
    property GetScopeRates: TExecuteCmd read FGetScopeRates write SetGetScopeRates;
    property SendInfo: TSendInfo read FSendInfo write SetSendInfo;
    property ActiveChart: Tf_chart read FActiveChart write SetActiveChart;
    property HidenTimer: Boolean read GetHidenTimer write SetHidenTimer;
    property onApply: TNotifyEvent read FonApply write FonApply;
  end;

implementation

{$R *.lfm}

{ Tf_script }

procedure Tf_script.SetLang;
begin
  if FScriptTitle='' then PanelTitle.Caption:=rsToolBox+' '+inttostr(tag+1)
                     else PanelTitle.Caption:=FScriptTitle;
  Label1.Caption:=rsConfiguratio;
  ButtonEditSrc.Caption:=rsScript;
  ButtonEditTB.Caption:=rsToolBar;
  fedittoolbar.SetLang;
  if fscriptengine<>nil then fscriptengine.SetLang;
  SetHelp(self,hlpScriptEditor);
end;

constructor Tf_script.Create(TheOwner: TComponent);
begin
  inherited Create(TheOwner);
  FScriptTitle:='';
  FHidenTimer:=false;
  FTelescopeConnected:=False;
  fedittoolbar:=Tf_edittoolbar.Create(self);
  fedittoolbar.ButtonMini.Visible:=false;
  fedittoolbar.ButtonStd.Visible:=false;
  FConfigToolbar1:=TStringList.Create;
  FConfigToolbar2:=TStringList.Create;
  FConfigScriptButton:=TStringList.Create;
  FConfigScript:=TStringList.Create;
  FConfigCombo:=TStringList.Create;
  FConfigEvent:=TStringList.Create;
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
  if fscriptengine<>nil then fscriptengine.Free;
  inherited Destroy;
end;

procedure Tf_script.ShowScript(onoff:boolean);
begin
  if onoff<>visible then begin
     visible:=onoff;
     if visible then begin
        if fscriptengine<>nil then begin
           fscriptengine.EventReady:=true;
           fscriptengine.StartTimer;
           fscriptengine.TelescopeConnectEvent(TelescopeChartName,FTelescopeConnected);
           fscriptengine.ActivateEvent;
        end;
     end else
        if fscriptengine<>nil then begin
           fscriptengine.StopAllScript;
           fscriptengine.Hide;
           if fscriptengine.CheckBoxHidenTimer.Checked then fscriptengine.StartTimer;
        end;
  end;
end;

procedure Tf_script.CreateEngine;
begin
  fscriptengine:=Tf_scriptengine.Create(self);
  fscriptengine.Tag:=Tag;
  fscriptengine.ConfigToolbar1:=ConfigToolbar1;
  fscriptengine.ConfigToolbar2:=ConfigToolbar2;
  fscriptengine.editsurface:=MainPanel;
  fscriptengine.onApply:=@ApplyScript;
  fscriptengine.ExecuteCmd:=FExecuteCmd;
  fscriptengine.CometMark:=FCometMark;
  fscriptengine.AsteroidMark:=FAsteroidMark;
  fscriptengine.GetScopeRates:=FGetScopeRates;
  fscriptengine.SendInfo:=FSendInfo;
  fscriptengine.Activechart:=FActivechart;
  fscriptengine.Mainmenu:=FMainmenu;
  fscriptengine.cdb:=Fcdb;
  fscriptengine.catalog:=Fcatalog;
  fscriptengine.fits:=Ffits;
  fscriptengine.planet:=Fplanet;
  fscriptengine.cmain:=Fcmain;
end;

procedure Tf_script.Init;
begin
  LabelShortcut.Caption:='F'+inttostr(tag+1);
  ToolBar1.Images:=FImageNormal;
  ToolBar2.Images:=FImageNormal;
  fedittoolbar.Images:=FImageNormal;
  fedittoolbar.DisabledContainer:=FContainerPanel;
  fedittoolbar.TBOnMouseUp:=FToolButtonMouseUp;
  fedittoolbar.TBOnMouseDown:=FToolButtonMouseDown;
  fedittoolbar.ClearAction;
  fedittoolbar.DefaultAction:=rsFile;
  fedittoolbar.AddAction(FActionListFile,rsFile);
  fedittoolbar.AddAction(FActionListEdit,rsEdit);
  fedittoolbar.AddAction(FActionListSetup,rsSetup);
  fedittoolbar.AddAction(FActionListView,rsView);
  fedittoolbar.AddAction(FActionListChart,rsChart);
  fedittoolbar.AddAction(FActionListTelescope,rsTelescope);
  fedittoolbar.AddAction(FActionListWindow,rsWindow);
  fedittoolbar.ClearControl;
  fedittoolbar.AddOtherControl(FTimeValPanel, rsEditTimeIncr, rsAnimation,  rsChart, 103);
  fedittoolbar.AddOtherControl(FTimeU, rsSelectTimeUn, rsAnimation, rsChart, 104);
  fedittoolbar.ClearToolbar;
  fedittoolbar.DefaultToolbar:=ToolBar1.Caption;
  fedittoolbar.AddToolbar(ToolBar1);
  fedittoolbar.AddToolbar(ToolBar2);
  fedittoolbar.ProcessActions;
  fedittoolbar.LoadToolbar(0,ConfigToolbar1);
  fedittoolbar.LoadToolbar(1,ConfigToolbar2);
  fedittoolbar.ActivateToolbar;
  ToolBar1.Visible:=(VisibleControlCount(ToolBar1)>0);
  ToolBar2.Visible:=(VisibleControlCount(ToolBar2)>0);
  if Tag>=ReservedScript then begin
    if FConfigScriptButton.Count>0 then begin
       if fscriptengine=nil then begin
          CreateEngine;
       end;
       fscriptengine.CheckBoxHidenTimer.Checked:=FHidenTimer;
       fscriptengine.Load(FConfigScriptButton, FConfigScript, FConfigCombo, FConfigEvent,PanelTitle.Caption);
       fscriptengine.InitialLoad:=false;
    end;
  end else begin
    if fscriptengine=nil then begin
       CreateEngine;
    end;
    fscriptengine.LoadFile(slash(appdir)+slash('data')+slash('script')+'script'+inttostr(tag+1)+'.cdcps');
    fscriptengine.InitialLoad:=false;
  end;
end;

procedure Tf_script.ButtonEditTBClick(Sender: TObject);
begin
  fedittoolbar.LoadToolbar(0,ConfigToolbar1);
  fedittoolbar.LoadToolbar(1,ConfigToolbar2);
  FormPos(fedittoolbar,mouse.cursorpos.x,mouse.cursorpos.y);
  fedittoolbar.ShowModal;
  if fedittoolbar.ModalResult=mrOK then begin
     fedittoolbar.SaveToolbar(0,ConfigToolbar1);
     fedittoolbar.SaveToolbar(1,ConfigToolbar2);
     ToolBar1.Visible:=(VisibleControlCount(ToolBar1)>0);
     ToolBar2.Visible:=(VisibleControlCount(ToolBar2)>0);
  end;
end;

procedure Tf_script.ButtonEditSrcClick(Sender: TObject);
begin
  if fscriptengine=nil then begin
     CreateEngine;
     fscriptengine.InitialLoad:=false;
  end;
  FormPos(fscriptengine,mouse.cursorpos.x,mouse.cursorpos.y);
  fscriptengine.Show;
end;

procedure Tf_script.ApplyScript(Sender: TObject);
begin
 fscriptengine.Save(FConfigScriptButton, FConfigScript, FConfigCombo, FConfigEvent,FScriptTitle);
 PanelTitle.Caption:=FScriptTitle;
 fedittoolbar.LoadToolbar(0,ConfigToolbar1);
 fedittoolbar.LoadToolbar(1,ConfigToolbar2);
 fedittoolbar.ActivateToolbar;
 ToolBar1.Visible:=(VisibleControlCount(ToolBar1)>0);
 ToolBar2.Visible:=(VisibleControlCount(ToolBar2)>0);
  if Assigned(FonApply) then FonApply(self);
end;

procedure Tf_script.SetExecuteCmd(value:TExecuteCmd);
begin
 FExecuteCmd:=value;
 if fscriptengine<>nil then fscriptengine.ExecuteCmd:=FExecuteCmd;
end;

procedure Tf_script.SetCometMark(value:TExecuteCmd);
begin
FCometMark:=value;
if fscriptengine<>nil then fscriptengine.CometMark:=FCometMark;
end;

procedure Tf_script.SetAsteroidMark(value:TExecuteCmd);
begin
FAsteroidMark:=value;
if fscriptengine<>nil then fscriptengine.AsteroidMark:=FAsteroidMark;
end;

procedure Tf_script.SetGetScopeRates(value:TExecuteCmd);
begin
FGetScopeRates:=value;
if fscriptengine<>nil then fscriptengine.GetScopeRates:=FGetScopeRates;
end;

procedure Tf_script.SetSendInfo(value:TSendInfo);
begin
FSendInfo:=value;
if fscriptengine<>nil then fscriptengine.SendInfo:=FSendInfo;
end;

procedure Tf_script.SetActiveChart(value:Tf_chart);
begin
 FActivechart:=value;
 if fscriptengine<>nil then fscriptengine.Activechart:=FActivechart;
end;

procedure Tf_script.SetMainmenu(value:TMenu);
begin
 FMainmenu:=value;
 if fscriptengine<>nil then fscriptengine.Mainmenu:=FMainmenu;
end;

procedure Tf_script.SetCDB(value:TCDCdb);
begin
 Fcdb:=value;
 if fscriptengine<>nil then fscriptengine.cdb:=Fcdb;
end;

procedure Tf_script.SetCatalog(value:TCatalog);
begin
 Fcatalog:=value;
 if fscriptengine<>nil then fscriptengine.catalog:=Fcatalog;
end;

procedure Tf_script.SetPlanet(value:TPlanet);
begin
 Fplanet:=value;
 if fscriptengine<>nil then fscriptengine.planet:=Fplanet;
end;

procedure Tf_script.SetFits(value:TFits);
begin
 Ffits:=value;
 if fscriptengine<>nil then fscriptengine.fits:=Ffits;
end;

procedure Tf_script.ChartRefreshEvent(origin,str:string);
begin
  if fscriptengine<>nil then fscriptengine.ChartRefreshEvent(origin,str);
end;

procedure Tf_script.ObjectSelectionEvent(origin,str,longstr:string);
begin
  if fscriptengine<>nil then fscriptengine.ObjectSelectionEvent(origin,str,longstr);
end;

procedure Tf_script.DistanceMeasurementEvent(origin,str:string);
begin
  if fscriptengine<>nil then fscriptengine.DistanceMeasurementEvent(origin,str);
end;

procedure Tf_script.TelescopeMoveEvent(origin:string; ra,de: double);
begin
  if fscriptengine<>nil then fscriptengine.TelescopeMoveEvent(origin,ra,de);
end;

procedure Tf_script.TelescopeConnectEvent(origin:string; connected: boolean);
begin
  FTelescopeConnected:=connected;
  TelescopeChartName:=origin;
  if visible and (fscriptengine<>nil) then fscriptengine.TelescopeConnectEvent(origin,connected);
end;

procedure Tf_script.ActivateEvent;
begin
  if fscriptengine<>nil then fscriptengine.ActivateEvent;
end;

function  Tf_script.GetHidenTimer: Boolean;
begin
  if fscriptengine<>nil then Result:=fscriptengine.CheckBoxHidenTimer.Checked
     else Result:=FHidenTimer;
end;

procedure Tf_script.SetHidenTimer(value:Boolean);
begin
  FHidenTimer:=value;
  if fscriptengine<>nil then fscriptengine.CheckBoxHidenTimer.Checked:=value;
end;

procedure Tf_script.SetTimeU(value:TComboBox);
var i:integer;
begin
  FMainTimeU:=value;
  if FTimeU<>nil then FreeAndNil(FTimeU);
  FTimeU:=TComboBox.Create(self);
  FTimeU.Style:=value.Style;
  FTimeU.Width:=value.Width;
  FTimeU.Height:=value.Height;
  FTimeU.Caption:=value.Caption;
  FTimeU.Hint:=value.Hint;
  FTimeU.Name:=value.Name;
  for i:=0 to value.Items.Count-1 do FTimeU.Items.Add(value.Items[i]);
  FTimeU.ItemIndex:=value.ItemIndex;
  FTimeU.OnChange:=@TimeUChange;
end;

procedure Tf_script.SetTimeValPanel(value:TPanel);
begin
  FMainTimeValPanel:=value;
  if FTimeValPanel<>nil then FreeAndNil(FTimeValPanel);
  FTimeValPanel:=TPanel.Create(self);
  FTimeValPanel.Name:=value.Name;
  FTimeValPanel.Caption:=value.Caption;
  FTimeValPanel.BevelOuter:=value.BevelOuter;
  FTimeValPanel.Width:=value.Width;
  FTimeValPanel.Height:=value.Height;
end;

procedure Tf_script.SetEditTimeVal(value:TEdit);
begin
  FMainEditTimeVal:=value;
  if FEditTimeVal<>nil then FreeAndNil(FEditTimeVal);
  FEditTimeVal:=TEdit.Create(self);
  FEditTimeVal.Name:=value.Name;
  FEditTimeVal.Parent:=FTimeValPanel;
  FEditTimeVal.Width:=value.Width;
  FEditTimeVal.Height:=value.Height;
  FEditTimeVal.Top:=value.Top;
  FEditTimeVal.Left:=value.Left;
  FEditTimeVal.Text:=value.Text;
  FEditTimeVal.OnChange:=@EditTimeValChange;
end;

procedure Tf_script.SetTimeVal(value:TUpDown);
begin
  FMainTimeVal:=value;
  if FTimeVal<>nil then FreeAndNil(FTimeVal);
  FTimeVal:=TUpDown.Create(self);
  FTimeVal.Parent:=FTimeValPanel;
  FTimeVal.Name:=value.Name;
  FTimeVal.Width:=value.Width;
  FTimeVal.Height:=value.Height;
  FTimeVal.Top:=value.Top;
  FTimeVal.Left:=value.Left;
  FTimeVal.Max:=value.Max;
  FTimeVal.Min:=value.Min;
  FTimeVal.Thousands:=value.Thousands;
  FTimeVal.Associate:=FEditTimeVal;
  FTimeVal.Position:=value.Position;
  FTimeVal.OnChangingEx:=@TimeValChangingEx;
end;

procedure Tf_script.TimeUChange(Sender: TObject);
begin
  FMainTimeU.ItemIndex:=TimeU.ItemIndex;
  FMainTimeU.OnChange(self);
end;

procedure Tf_script.EditTimeValChange(Sender: TObject);
var i,n: integer;
begin
val(FEditTimeVal.Text,i,n);
if (n=0)and(i=0) then
  FEditTimeVal.Text:='1';
FTimeVal.Position:=strtointdef(FEditTimeVal.Text,1);
FMainEditTimeVal.Text:=FEditTimeVal.Text;
end;

procedure Tf_script.TimeValChangingEx(Sender: TObject; var AllowChange: Boolean; NewValue: SmallInt; Direction: TUpDownDirection);
begin
if NewValue=0 then begin
  if FTimeVal.Position>0 then FTimeVal.Position:=-1 else FTimeVal.Position:=1;
  AllowChange:=false;
end;
FMainTimeVal.Position:=FTimeVal.Position;
end;


end.

