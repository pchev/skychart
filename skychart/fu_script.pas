unit fu_script;

{$mode objfpc}{$H+}

interface

uses  u_translation, u_constant, u_help, pu_edittoolbar, pu_scriptengine, u_util,
  fu_chart, ActnList, Menus, Classes, SysUtils,
  FileUtil, Forms, Controls, ExtCtrls, StdCtrls, ComCtrls, Buttons;

type

  { Tf_script }

  Tf_script = class(TFrame)
    ButtonEditTB: TBitBtn;
    ButtonEditSrc: TBitBtn;
    BottomPanel: TPanel;
    Label1: TLabel;
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
    FMagPanel: TPanel;
    Fquicksearch: TComboBox;
    FTimeValPanel: Tpanel;
    FTimeU: TComboBox;
    FToolBarFOV: Tpanel;
    FMainmenu: TMenu;
    FExecuteCmd: TExecuteCmd;
    FActivechart: Tf_chart;
    FonApply: TNotifyEvent;
    FScriptTitle: string;
    FConfigToolbar1,FConfigToolbar2,FConfigScriptButton,FConfigScript,FConfigEvent: TStringList;
    FHidenTimer: Boolean;
    procedure ApplyScript(Sender: TObject);
    procedure SetExecuteCmd(value:TExecuteCmd);
    procedure SetActiveChart(value:Tf_chart);
    function  GetHidenTimer: Boolean;
    procedure SetHidenTimer(value:Boolean);
    procedure SetMainmenu(value:TMenu);
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
    property MagPanel: TPanel read FMagPanel  write FMagPanel ;
    property quicksearch: TComboBox read Fquicksearch  write Fquicksearch ;
    property TimeValPanel: Tpanel read FTimeValPanel  write FTimeValPanel ;
    property TimeU: TComboBox read FTimeU  write FTimeU ;
    property ToolBarFOV: Tpanel read FToolBarFOV  write FToolBarFOV ;
    property Mainmenu: TMenu read FMainmenu  write SetMainmenu;
    property ConfigToolbar1: TStringList read FConfigToolbar1 write FConfigToolbar1;
    property ConfigToolbar2: TStringList read FConfigToolbar2 write FConfigToolbar2;
    property ConfigScriptButton: TStringList read FConfigScriptButton write FConfigScriptButton;
    property ConfigScript: TStringList read FConfigScript write FConfigScript;
    property ConfigEvent: TStringList read FConfigEvent write FConfigEvent;
    property ExecuteCmd: TExecuteCmd read FExecuteCmd write SetExecuteCmd;
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
  fedittoolbar:=Tf_edittoolbar.Create(self);
  fedittoolbar.ButtonMini.Visible:=false;
  fedittoolbar.ButtonStd.Visible:=false;
  FConfigToolbar1:=TStringList.Create;
  FConfigToolbar2:=TStringList.Create;
  FConfigScriptButton:=TStringList.Create;
  FConfigScript:=TStringList.Create;
  FConfigEvent:=TStringList.Create;
end;

destructor Tf_script.Destroy;
begin
  fedittoolbar.Free;
  FConfigToolbar1.Free;
  FConfigToolbar2.Free;
  FConfigScriptButton.Free;
  FConfigScript.Free;
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
           fscriptengine.StartTimer;
        end;
     end else
        if fscriptengine<>nil then begin
           fscriptengine.StopAllScript;
           fscriptengine.Hide;
           if fscriptengine.CheckBoxHidenTimer.Checked then fscriptengine.StartTimer;
        end;
  end;
end;

procedure Tf_script.Init;
begin
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
  fedittoolbar.AddOtherControl(FMagPanel, rsStarAndNebul, rsFilter2, rsChart, 99);
  fedittoolbar.AddOtherControl(Fquicksearch, rsSearchBox, rsSearch, rsEdit, 102);
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
  if FConfigScriptButton.Count>0 then begin
     if fscriptengine=nil then begin
        fscriptengine:=Tf_scriptengine.Create(self);
        fscriptengine.ConfigToolbar1:=ConfigToolbar1;
        fscriptengine.ConfigToolbar2:=ConfigToolbar2;
        fscriptengine.editsurface:=MainPanel;
        fscriptengine.onApply:=@ApplyScript;
        fscriptengine.ExecuteCmd:=FExecuteCmd;
        fscriptengine.Activechart:=FActivechart;
        fscriptengine.Mainmenu:=FMainmenu;
     end;
     fscriptengine.CheckBoxHidenTimer.Checked:=FHidenTimer;
     fscriptengine.Load(FConfigScriptButton, FConfigScript, FConfigEvent,PanelTitle.Caption);
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
     fscriptengine:=Tf_scriptengine.Create(self);
     fscriptengine.ConfigToolbar1:=ConfigToolbar1;
     fscriptengine.ConfigToolbar2:=ConfigToolbar2;
     fscriptengine.editsurface:=MainPanel;
     fscriptengine.onApply:=@ApplyScript;
     fscriptengine.ExecuteCmd:=FExecuteCmd;
     fscriptengine.Activechart:=FActivechart;
     fscriptengine.Mainmenu:=FMainmenu;
  end;
  FormPos(fscriptengine,mouse.cursorpos.x,mouse.cursorpos.y);
  fscriptengine.Show;
end;

procedure Tf_script.ApplyScript(Sender: TObject);
begin
 fscriptengine.Save(FConfigScriptButton, FConfigScript, FConfigEvent,FScriptTitle);
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

end.

