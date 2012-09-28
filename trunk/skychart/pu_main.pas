unit pu_main;

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
Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
}
{
 Main form for CDC/Skychart application
}

interface

uses
  {$ifdef mswindows}
    Windows, ShlObj, Registry,
  {$endif}
  lclstrconsts, u_help, u_translation, cu_catalog, cu_planet, cu_fits, cu_database, fu_chart,
  cu_tcpserver, pu_config_time, pu_config_observatory, pu_config_display, pu_config_pictures,
  pu_config_catalog, pu_config_solsys, pu_config_chart, pu_config_system, pu_config_internet,
  u_constant, u_util, blcksock, synsock, dynlibs, FileUtil, LCLVersion, LCLType,
  LCLIntf, SysUtils, Classes, Graphics, Forms, Controls, Menus, Math,
  StdCtrls, Dialogs, Buttons, ExtCtrls, ComCtrls, StdActns, types,
  ActnList, IniFiles, Spin, Clipbrd, MultiFrame, ChildFrame,
  LResources, uniqueinstance, enhedits, LazHelpHTML, ButtonPanel;

type

  { Tf_main }

  Tf_main = class(TForm)
    EditTimeVal: TEdit;
    MenuItem31: TMenuItem;
    CloseTimer: TTimer;
    MenuItem32: TMenuItem;
    MenuChartInfo: TMenuItem;
    MenuChartLegend: TMenuItem;
    Compass1: TMenuItem;
    MultiFrame1: TMultiFrame;
    ShowLabels1: TMenuItem;
    ResetLanguage: TMenuItem;
    InitTimer: TTimer;
    TabControl1: TTabControl;
    ToolButtonRot180: TToolButton;
    ToolButtonCompass: TToolButton;
    ToolButtonScale: TToolButton;
    ToolButtonUObj: TToolButton;
    ToolButtonVO: TToolButton;
    TrackTelescope1: TMenuItem;
    PrintPreview1: TMenuItem;
    TelescopeSetup1: TMenuItem;
    NextChild1: TMenuItem;
    ReloadLanguage1: TMenuItem;
    ResetDefaultChart: TAction;
    EditCopy1: TAction;
    HelpFaq1: TAction;
    HelpQS1: TAction;
    MenuItem27: TMenuItem;
    MenuItem29: TMenuItem;
    MenuItem30: TMenuItem;
    ThemeTimer: TTimer;
    AnimationTimer: TTimer;
    TimeVal: TUpDown;
    ToolButton13: TToolButton;
    ViewClock: TAction;
    HTMLBrowserHelpViewer1: THTMLBrowserHelpViewer;
    HTMLHelpDatabase1: THTMLHelpDatabase;
    MenuItem24: TMenuItem;
    MenuItem25: TMenuItem;
    MenuItem26: TMenuItem;
    MenuEditLabels: TMenuItem;
    MenuDSS: TMenuItem;
    MenuBlinkImage: TMenuItem;
    MenuTrack: TMenuItem;
    MenuSyncChart: TMenuItem;
    MenuItem28: TMenuItem;
    Menuswitchbackground: TMenuItem;
    MenuPosition: TMenuItem;
    MenuListObj: TMenuItem;
    MenuSearch: TMenuItem;
    zoommenu: TMenuItem;
    MenuStarNum: TMenuItem;
    MenuNebNum: TMenuItem;
    MenuMoreStar: TMenuItem;
    MenuLessStar: TMenuItem;
    MenuMoreNeb: TMenuItem;
    MenuLessNeb: TMenuItem;
    MenuItem6: TMenuItem;
    SetupConfig: TAction;
    MenuItem12: TMenuItem;
    MenuItem13: TMenuItem;
    MenuItem14: TMenuItem;
    MenuItem15: TMenuItem;
    MenuItem16: TMenuItem;
    MenuItem17: TMenuItem;
    MenuItem18: TMenuItem;
    MenuItem19: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem20: TMenuItem;
    MenuItem21: TMenuItem;
    MenuItem22: TMenuItem;
    MenuItem23: TMenuItem;
    MenuItem3: TMenuItem;
    MenuItem4: TMenuItem;
    MenuItem5: TMenuItem;
    ToolButton10: TToolButton;
    ToolButton11: TToolButton;
    ToolButton12: TToolButton;
    VariableStar1: TMenuItem;
    PopupConfig: TPopupMenu;
    SetupInternet: TAction;
    SetupSystem: TAction;
    SetupSolSys: TAction;
    SetupChart: TAction;
    BlinkImage: TAction;
    P1L1: TLabel;
    P0L1: TLabel;
    ReleaseNotes1: TMenuItem;
    ToolButtonBlink: TToolButton;
    ViewScrollBar1: TMenuItem;
    ResetAllLabels1: TMenuItem;
    PopupMenu1: TPopupMenu;
    SetupCatalog: TAction;
    HomePage1: TMenuItem;
    Maillist1: TMenuItem;
    BugReport1: TMenuItem;
    MenuItem10: TMenuItem;
    MenuItem11: TMenuItem;
    MenuItem7: TMenuItem;
    MenuItem8: TMenuItem;
    LPanels0: TPanel;
    LPanels1: TPanel;
    MenuItem9: TMenuItem;
    SetupPictures: TAction;
    MenuItem1: TMenuItem;
    SetupDisplay: TAction;
    ObsConfig1: TMenuItem;
    SetupObservatory: TAction;
    DateConfig1: TMenuItem;
    SetupTime: TAction;
    FileClose1: TAction;
    ButtonMoreStar: TImage;
    ButtonLessStar: TImage;
    ButtonMoreNeb: TImage;
    ButtonLessNeb: TImage;
    ImageNormal: TImageList;
    Shape1: TShape;
    ToolButton8: TToolButton;
    ToolButton9: TToolButton;
    topmessage: TMenuItem;
    PanelFieldSize: TPanel;
    ToolButton2: TToolButton;
    ToolButton4: TToolButton;
    ToolButton6: TToolButton;
    ToolButton7: TToolButton;
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    FileNewItem: TMenuItem;
    FileOpenItem: TMenuItem;
    FileCloseItem: TMenuItem;
    Window1: TMenuItem;
    Help1: TMenuItem;
    N1: TMenuItem;
    FileExitItem: TMenuItem;
    WindowCascadeItem: TMenuItem;
    WindowTileItem: TMenuItem;
    HelpAboutItem: TMenuItem;
    OpenDialog: TOpenDialog;
    FileSaveAsItem: TMenuItem;
    Edit1: TMenuItem;
    CopyItem: TMenuItem;
    ActionList1: TActionList;
    FileNew1: TAction;
    FileExit1: TAction;
    FileOpen1: TAction;
    FileSaveAs1: TAction;
    HelpAbout1: TAction;
    WindowTileItem2: TMenuItem;
    Print1: TAction;
    Print2: TMenuItem;
    starshape: TImage;
    PrintSetup2: TMenuItem;
    N2: TMenuItem;
    Setup1: TMenuItem;
    HelpContents1: THelpContents;
    Search1: TAction;
    PanelLeft: TPanel;
    ToolBar2: TToolBar;
    ToolButtonConfig: TToolButton;
    PanelRight: TPanel;
    ToolBar3: TToolBar;
    PanelBottom: TPanel;
    PPanels0: TPanel;
    PPanels1: TPanel;
    PanelTop: TPanel;
    ToolBar1: TToolBar;
    ToolButtonNew: TToolButton;
    ToolButtonOpen: TToolButton;
    ToolButtonSave: TToolButton;
    ToolButtonPrint: TToolButton;
    ToolButton3: TToolButton;
    ToolButtonCascade: TToolButton;
    ToolButtonTile: TToolButton;
    ToolButton5: TToolButton;
    ToolButtonZoom: TToolButton;
    ToolButtonUnZoom: TToolButton;
    MagPanel: TPanel;
    ViewBar: TAction;
    zoomplus: TAction;
    zoomminus: TAction;
    quicksearch: TComboBox;
    FlipX: TAction;
    FlipY: TAction;
    FlipButtonX: TToolButton;
    FlipButtonY: TToolButton;
    ViewToolsBar1: TMenuItem;
    SaveDialog: TSaveDialog;
    ViewStatus: TAction;
    ViewStatusBar1: TMenuItem;
    View1: TMenuItem;
    SaveConfiguration: TAction;
    SaveConfigurationNow1: TMenuItem;
    SaveConfigOnExit: TAction;
    SaveConfigurationOnExit1: TMenuItem;
    ToolButtonUndo: TToolButton;
    Undo: TAction;
    Redo: TAction;
    ToolButtonRedo: TToolButton;
    Autorefresh: TTimer;
    ToolButtonRotP: TToolButton;
    ToolButtonRotM: TToolButton;
    rot_plus: TAction;
    rot_minus: TAction;
    GridEQ: TAction;
    Grid: TAction;
    switchstars: TAction;
    switchbackground: TAction;
    SaveImage: TAction;
    SaveImage1: TMenuItem;
    ViewInfo: TAction;
    ViewInformation1: TMenuItem;
    toN: TAction;
    toE: TAction;
    toS: TAction;
    toW: TAction;
    toZenith: TAction;
    allSky: TAction;
    ToolButtonAllSky: TToolButton;
    ToolButtonToN: TToolButton;
    ToolButtonToS: TToolButton;
    ToolButtonToE: TToolButton;
    ToolButtonToW: TToolButton;
    ToolButtonToZ: TToolButton;
    TimeInc: TAction;
    TimeDec: TAction;
    TimeReset: TAction;
    ToolButton35: TToolButton;
    ToolButtonTnow: TToolButton;
    TimeU: TComboBox;
    ToolButtonTdec: TToolButton;
    ToolButtonTinc: TToolButton;
    ToolButton39: TToolButton;
    listobj: TAction;
    ToolButtonListObj: TToolButton;
    FilePrintSetup1: TAction;
    TConnect: TToolButton;
    TSlew: TToolButton;
    TSync: TToolButton;
    TelescopeConnect: TAction;
    TelescopeSlew: TAction;
    TelescopeSync: TAction;
    MoreStar: TAction;
    LessStar: TAction;
    MoreNeb: TAction;
    LessNeb: TAction;
//    DdeData: TDdeServerItem;
//    DdeSkyChart: TDdeServerConv;
    ToolBar4: TToolBar;
    ToolButtonShowStars: TToolButton;
    ToolButtonShowNebulae: TToolButton;
    ToolButtonShowPictures: TToolButton;
    ToolButtonShowLines: TToolButton;
    ToolButtonShowAsteroids: TToolButton;
    ToolButtonShowComets: TToolButton;
    ToolButtonShowPlanets: TToolButton;
    ShowStars: TAction;
    ShowNebulae: TAction;
    ShowPictures: TAction;
    ShowLines: TAction;
    ShowPlanets: TAction;
    ShowAsteroids: TAction;
    ShowComets: TAction;
    ShowMilkyWay: TAction;
    ToolButtonShowMilkyWay: TToolButton;
    ShowLabels: TAction;
    ToolButtonShowLabels: TToolButton;
    ToolButtonGrid: TToolButton;
    ToolButtonGridEq: TToolButton;
    ShowConstellationLine: TAction;
    ShowConstellationLimit: TAction;
    ToolButtonShowConstellationLine: TToolButton;
    ToolButtonShowConstellationLimit: TToolButton;
    ToolButtonShowGalacticEquator: TToolButton;
    ToolButtonShowEcliptic: TToolButton;
    ShowGalacticEquator: TAction;
    ShowEcliptic: TAction;
    ToolButtonShowMark: TToolButton;
    ShowMark: TAction;
    ShowObjectbelowHorizon: TAction;
    ToolButtonShowObjectbelowHorizon: TToolButton;
    ToolButtonswitchbackground: TToolButton;
    ToolButtonswitchstars: TToolButton;
    ToolButtonEQ: TToolButton;
    ToolButtonAZ: TToolButton;
    ToolButtonEC: TToolButton;
    ToolButtonGL: TToolButton;
    EquatorialProjection: TAction;
    AltAzProjection: TAction;
    EclipticProjection: TAction;
    GalacticProjection: TAction;
    oolBar1: TMenuItem;
    MainBar1: TMenuItem;
    LeftBar1: TMenuItem;
    RightBar1: TMenuItem;
    ObjectBar1: TMenuItem;
    ViewMainBar: TAction;
    ViewObjectBar: TAction;
    ViewLeftBar: TAction;
    ViewRightBar: TAction;
    N5: TMenuItem;
    ToolButtonCal: TToolButton;
    Calendar: TAction;
    ToolButtonSearch: TToolButton;
    Content1: TMenuItem;
    Field1: TSpeedButton;
    Field2: TSpeedButton;
    Field3: TSpeedButton;
    Field4: TSpeedButton;
    Field5: TSpeedButton;
    Field6: TSpeedButton;
    Field7: TSpeedButton;
    Field8: TSpeedButton;
    Field9: TSpeedButton;
    Field10: TSpeedButton;
    Undo1: TMenuItem;
    Redo1: TMenuItem;
    zoomplus1: TMenuItem;
    zoomminus1: TMenuItem;
    telescope1: TMenuItem;
    telescopeConnect1: TMenuItem;
    telescopeSlew1: TMenuItem;
    telescopeSync1: TMenuItem;
    Chart1: TMenuItem;
    Projection1: TMenuItem;
    EquatorialCoordinate1: TMenuItem;
    AltAzProjection1: TMenuItem;
    EclipticProjection1: TMenuItem;
    GalacticProjection1: TMenuItem;
    ransformation1: TMenuItem;
    FlipX1: TMenuItem;
    FlipY1: TMenuItem;
    rotplus1: TMenuItem;
    rotminus1: TMenuItem;
    FieldofVision1: TMenuItem;
    SetFov1: TMenuItem;
    SetFov2: TMenuItem;
    SetFov3: TMenuItem;
    SetFov4: TMenuItem;
    SetFov5: TMenuItem;
    SetFov6: TMenuItem;
    SetFov7: TMenuItem;
    SetFov8: TMenuItem;
    SetFov9: TMenuItem;
    SetFov10: TMenuItem;
    allSky1: TMenuItem;
    ShowHorizon1: TMenuItem;
    toN1: TMenuItem;
    toS1: TMenuItem;
    toE1: TMenuItem;
    toW1: TMenuItem;
    ShowObjects1: TMenuItem;
    ShowStars1: TMenuItem;
    ShowNebulae1: TMenuItem;
    ShowPictures1: TMenuItem;
    ShowLines1: TMenuItem;
    ShowPlanets1: TMenuItem;
    ShowAsteroids1: TMenuItem;
    ShowComets1: TMenuItem;
    ShowMilkyWay1: TMenuItem;
    ShowGrid1: TMenuItem;
    Grid1: TMenuItem;
    GridEQ1: TMenuItem;
    ShowConstellationLine1: TMenuItem;
    ShowConstellationLimit1: TMenuItem;
    ShowGalacticEquator1: TMenuItem;
    ShowEcliptic1: TMenuItem;
    ShowMark1: TMenuItem;
    ShowObjectbelowthehorizon1: TMenuItem;
    Calendar1: TMenuItem;
    N6: TMenuItem;
    ShowBackgroundImage: TAction;
    ToolButtonShowBackgroundImage: TToolButton;
    ToolButtonPosition: TToolButton;
    Position: TAction;
    ToolButtonSyncChart: TToolButton;
    SyncChart: TAction;
    Track: TAction;
    ToolButtonTrack: TToolButton;
    ZoomBar: TAction;
    ToolButton1: TToolButton;
    DSSImage: TAction;
    ToolButtonDSS: TToolButton;
    ToolButtonNightVision: TToolButton;
    ImageList2: TImageList;
    NightVision1: TMenuItem;
    ToolButtonEditlabels: TToolButton;
    EditLabels: TAction;
    N7: TMenuItem;
    FullScreen1: TMenuItem;
    N8: TMenuItem;
    N9: TMenuItem;
    ChildControl: TPanel;
    N10: TMenuItem;
    Cascade1: TAction;
    TileHorizontal1: TAction;
    TileVertical1: TAction;
    BtnRestoreChild: TSpeedButton;
    BtnCloseChild: TSpeedButton;
    Maximize1: TMenuItem;
    Maximize: TAction;
    TelescopePanel: TAction;
    ControlPanel1: TMenuItem;
    ViewFullScreen: TAction;
    procedure AnimationTimerTimer(Sender: TObject);
    procedure BlinkImageExecute(Sender: TObject);
    procedure BugReport1Click(Sender: TObject);
    procedure CloseTimerTimer(Sender: TObject);
    procedure FileClose1Execute(Sender: TObject);
    procedure FileNew1Execute(Sender: TObject);
    procedure FileOpen1Execute(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure HelpAbout1Execute(Sender: TObject);
    procedure FileExit1Execute(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure HelpFaq1Execute(Sender: TObject);
    procedure HelpQS1Execute(Sender: TObject);
    procedure HomePage1Click(Sender: TObject);
    procedure InitTimerTimer(Sender: TObject);
    procedure MagPanelMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Maillist1Click(Sender: TObject);
    procedure MenuChartInfoClick(Sender: TObject);
    procedure MenuChartLegendClick(Sender: TObject);
    procedure MenuItem7Click(Sender: TObject);
    procedure MultiFrame1CreateChild(Sender: TObject);
    procedure MultiFrame1DeleteChild(Sender: TObject);
    procedure PrintPreview1Click(Sender: TObject);
    procedure ResetLanguageClick(Sender: TObject);
    procedure TelescopeSetup1Click(Sender: TObject);
    procedure NextChild1Click(Sender: TObject);
    procedure Print1Execute(Sender: TObject);
    procedure ReleaseNotes1Click(Sender: TObject);
    procedure ReloadLanguage1Click(Sender: TObject);
    procedure ResetAllLabels1Click(Sender: TObject);
    procedure ResetDefaultChartExecute(Sender: TObject);
    procedure SetupCatalogExecute(Sender: TObject);
    procedure SetupChartExecute(Sender: TObject);
    procedure SetupConfigExecute(Sender: TObject);
    procedure SetupDisplayExecute(Sender: TObject);
    procedure SetupInternetExecute(Sender: TObject);
    procedure SetupObservatoryExecute(Sender: TObject);
    procedure SetupPicturesExecute(Sender: TObject);
    procedure SetupSolSysExecute(Sender: TObject);
    procedure SetupSystemExecute(Sender: TObject);
    procedure SetupTimeExecute(Sender: TObject);
    procedure TConnectMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ThemeTimerTimer(Sender: TObject);
    procedure ToolButton13Click(Sender: TObject);
    procedure ToolButton13MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ToolButtonRot180MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ToolButtonCompassClick(Sender: TObject);
    procedure ToolButtonScaleClick(Sender: TObject);
    procedure ToolButton1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ToolButtonConfigClick(Sender: TObject);
    procedure ToolButtonDSSMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ToolButtonListObjMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ToolButtonRotMMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ToolButtonRotPMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ToolButtonShowAsteroidsMouseUp(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure ToolButtonShowBackgroundImageMouseUp(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure ToolButtonShowCometsMouseUp(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure ToolButtonShowLineMouseUp(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure ToolButtonShowLabelsMouseUp(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure ToolButtonShowLinesMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ToolButtonShowMarkMouseUp(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure ToolButtonShowNebulaeMouseUp(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure ToolButtonShowPicturesMouseUp(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure ToolButtonShowPlanetsMouseUp(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure ToolButtonShowStarsMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ToolButtonswitchbackgroundMouseUp(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure ToolButtonswitchstarsMouseUp(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure ToolButtonUObjClick(Sender: TObject);
    procedure ToolButtonUObjMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ToolButtonVOClick(Sender: TObject);
    procedure ToolButtonVOMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure TrackTelescope1Click(Sender: TObject);
    procedure VariableStar1Click(Sender: TObject);
    procedure View1Click(Sender: TObject);
    procedure ViewBarExecute(Sender: TObject);
    procedure ViewClockExecute(Sender: TObject);
    procedure ViewScrollBar1Click(Sender: TObject);
    procedure zoomplusExecute(Sender: TObject);
    procedure zoomminusExecute(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure quicksearchKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormResize(Sender: TObject);
    procedure quicksearchClick(Sender: TObject);
    procedure FlipXExecute(Sender: TObject);
    procedure FlipYExecute(Sender: TObject);
    procedure SetFOVClick(Sender: TObject);
    procedure FileSaveAs1Execute(Sender: TObject);
    procedure ViewStatusExecute(Sender: TObject);
    procedure SaveConfigurationExecute(Sender: TObject);
    procedure SaveConfigOnExitExecute(Sender: TObject);
    procedure UndoExecute(Sender: TObject);
    procedure RedoExecute(Sender: TObject);
    procedure AutorefreshTimer(Sender: TObject);
    procedure rot_plusExecute(Sender: TObject);
    procedure rot_minusExecute(Sender: TObject);
    procedure GridEQExecute(Sender: TObject);
    procedure GridExecute(Sender: TObject);
    procedure switchstarsExecute(Sender: TObject);
    procedure switchbackgroundExecute(Sender: TObject);
    procedure SaveImageExecute(Sender: TObject);
    procedure ViewInfoExecute(Sender: TObject);
    procedure toNExecute(Sender: TObject);
    procedure toEExecute(Sender: TObject);
    procedure toSExecute(Sender: TObject);
    procedure toWExecute(Sender: TObject);
    procedure toZenithExecute(Sender: TObject);
    procedure allSkyExecute(Sender: TObject);
    procedure TimeResetExecute(Sender: TObject);
    procedure TimeIncExecute(Sender: TObject);
    procedure listobjExecute(Sender: TObject);
    procedure FilePrintSetup1Execute(Sender: TObject);
    procedure TelescopeConnectExecute(Sender: TObject);
    procedure TelescopeSlewExecute(Sender: TObject);
    procedure TelescopeSyncExecute(Sender: TObject);
    procedure LessNebExecute(Sender: TObject);
    procedure LessStarExecute(Sender: TObject);
    procedure MoreNebExecute(Sender: TObject);
    procedure MoreStarExecute(Sender: TObject);
{    procedure DdeDataPokeData(Sender: TObject);
    procedure DdeSkyChartClose(Sender: TObject);
    procedure DdeSkyChartOpen(Sender: TObject); }
    procedure ShowStarsExecute(Sender: TObject);
    procedure ShowNebulaeExecute(Sender: TObject);
    procedure ShowPicturesExecute(Sender: TObject);
    procedure ShowLinesExecute(Sender: TObject);
    procedure ShowPlanetsExecute(Sender: TObject);
    procedure ShowAsteroidsExecute(Sender: TObject);
    procedure ShowCometsExecute(Sender: TObject);
    procedure ShowMilkyWayExecute(Sender: TObject);
    procedure ShowLabelsExecute(Sender: TObject);
    procedure ShowConstellationLineExecute(Sender: TObject);
    procedure ShowConstellationLimitExecute(Sender: TObject);
    procedure ShowGalacticEquatorExecute(Sender: TObject);
    procedure ShowEclipticExecute(Sender: TObject);
    procedure ShowMarkExecute(Sender: TObject);
    procedure ShowObjectbelowHorizonExecute(Sender: TObject);
    procedure EquatorialProjectionExecute(Sender: TObject);
    procedure AltAzProjectionExecute(Sender: TObject);
    procedure EclipticProjectionExecute(Sender: TObject);
    procedure GalacticProjectionExecute(Sender: TObject);
    procedure ViewMainBarExecute(Sender: TObject);
    procedure ViewObjectBarExecute(Sender: TObject);
    procedure ViewLeftBarExecute(Sender: TObject);
    procedure ViewRightBarExecute(Sender: TObject);
    procedure CalendarExecute(Sender: TObject);
    procedure HelpContents1Execute(Sender: TObject);
    procedure EditCopy1Execute(Sender: TObject);
    procedure SetFovExecute(Sender: TObject);
    procedure ShowBackgroundImageExecute(Sender: TObject);
    procedure PositionExecute(Sender: TObject);
    procedure Search1Execute(Sender: TObject);
    procedure SyncChartExecute(Sender: TObject);
    procedure TabControl1Change(Sender: TObject);
    procedure TrackExecute(Sender: TObject);
    procedure ZoomBarExecute(Sender: TObject);
    procedure DSSImageExecute(Sender: TObject);
    procedure EditLabelsExecute(Sender: TObject);
    procedure MultiFrame1ActiveChildChange(Sender: TObject);
    procedure MultiFrame1Maximize(Sender: TObject);
    procedure BtnRestoreChildClick(Sender: TObject);
    procedure BtnCloseChildClick(Sender: TObject);
    procedure WindowCascade1Execute(Sender: TObject);
    procedure WindowTileHorizontal1Execute(Sender: TObject);
    procedure WindowTileVertical1Execute(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure MaximizeExecute(Sender: TObject);
    procedure TelescopePanelExecute(Sender: TObject);
    procedure ToolButtonNightVisionClick(Sender: TObject);
    procedure ViewFullScreenExecute(Sender: TObject);
    procedure SetTheme;
    procedure SetStarShape;
  private
    { Private declarations }
    UniqueInstance1: TCdCUniqueInstance;
    ConfigTime: Tf_configtime;
    ConfigObservatory: Tf_configobservatory;
    ConfigChart: Tf_configchart;
    ConfigSolsys: Tf_configsolsys;
    ConfigSystem: Tf_configsystem;
    ConfigInternet: Tf_configinternet;
    ConfigDisplay: Tf_configdisplay;
    ConfigPictures: Tf_configpictures;
    ConfigCatalog: Tf_configcatalog;
    cryptedpwd,basecaption,kioskpwd :string;
    NeedRestart,NeedToInitializeDB,ConfirmSaveConfig,InitOK,RestoreState,ForceClose : Boolean;
    InitialChartNum, Animcount: integer;
    AutoRefreshLock: Boolean;
    compass,arrow: TBitmap;
    CursorImage1: TCursorImage;
    SaveState: TWindowState;
  {$ifdef mswindows}
    savwincol  : array[0..25] of Tcolor;
  {$endif}
    procedure OtherInstance(Sender : TObject; ParamCount: Integer; Parameters: array of String);
    procedure InstanceRunning(Sender : TObject);
    procedure ProcessParams1;
    procedure ProcessParams2;
    procedure ProcessParamsQuit;
    procedure ShowError(msg: string);
    procedure SetButtonImage(button: Integer);
    function CreateChild(const CName: string; copyactive: boolean; cfg1 : Tconf_skychart; cfgp : Tconf_plot; locked:boolean=false):boolean;
    Procedure RefreshAllChild(applydef:boolean);
    Procedure SyncChild;
    procedure GetLanguage;
    Procedure GetAppDir;
    procedure ViewTopPanel;
    procedure ApplyConfig(Sender: TObject);
    procedure ApplyConfigTime(Sender: TObject);
    procedure ApplyConfigObservatory(Sender: TObject);
    procedure ApplyConfigDisplay(Sender: TObject);
    procedure ApplyConfigPictures(Sender: TObject);
    procedure ApplyConfigCatalog(Sender: TObject);
    procedure SetChildFocus(Sender: TObject);
    procedure SetNightVision(night: boolean);
    procedure SetupObservatoryPage(page:integer; posx:integer=0; posy:integer=0);
    procedure SetupTimePage(page:integer);
    procedure SetupDisplayPage(pagegroup:integer);
    procedure SetupPicturesPage(page:integer; action:integer=0);
    procedure SetupCatalogPage(page:integer);
    procedure SetupChartPage(page:integer);
    procedure ApplyConfigChart(Sender: TObject);
    procedure SetupSolsysPage(page:integer);
    procedure ApplyConfigSolsys(Sender: TObject);
    procedure SetupSystemPage(page:integer);
    procedure ApplyConfigSystem(Sender: TObject);
    procedure SetupInternetPage(page:integer);
    procedure ApplyConfigInternet(Sender: TObject);
    procedure FirstSetup;
    procedure ShowReleaseNotes(shownext:boolean);
    function Find(kind:integer; num:string; def_ra:double=0;def_de:double=0): string;
    function SaveChart(fn: string): string;
    function OpenChart(fn: string): string;
    function LoadDefaultChart(fn: string): string;
    function SetGCat(path,shortname,active,min,max: string): string;
  {$ifdef mswindows}
    Procedure SaveWinColor;
    Procedure ResetWinColor;
  {$endif}
  public
    { Public declarations }
    cfgm : Tconf_main;
    def_cfgsc,cfgs : Tconf_skychart;
    def_cfgplot,cfgp : Tconf_plot;
    catalog : Tcatalog;
    fits : TFits;
    planet  : Tplanet;
    cdcdb: TCDCdb;
    serverinfo,topmsg : string;
    TCPDaemon: TTCPDaemon;
    DdeInfo : TstringList;
    Dde_active_chart : string;
    DdeOpen : boolean;
    DdeEnqueue: boolean;
    CanShowScrollbar: boolean;
    Config_Version : string;
    showsplash: boolean;
    procedure ReadChartConfig(filename:string; usecatalog,resizemain:boolean; var cplot:Tconf_plot ;var csc:Tconf_skychart);
    procedure ReadPrivateConfig(filename:string);
    procedure ReadDefault;
    procedure UpdateConfig;
    procedure SavePrivateConfig(filename:string);
    procedure SaveQuickSearch(filename:string);
    procedure SaveChartConfig(filename:string; child: TChildFrame);
    procedure SaveVersion;
    procedure SaveDefault;
    procedure SetDefault;
    procedure SetLang;
    procedure ChangeLanguage(newlang:string);
    Procedure InitFonts;
    Procedure activateconfig(cmain:Tconf_main; csc:Tconf_skychart; ccat:Tconf_catalog; cshr:Tconf_shared; cplot:Tconf_plot; cdss:Tconf_dss; applyall:boolean );
    Procedure SetLPanel1(txt1:string; origin:string='';sendmsg:boolean=false; Sender: TObject=nil; txt2:string='');
    Procedure SetLPanel0(txt:string);
    Procedure SetTopMessage(txt:string;sender:TObject);
    Procedure SetTitleMessage(txt:string;sender:TObject);
    procedure updatebtn(fx,fy:integer;tc:boolean;sender:TObject);
    Function NewChart(cname:string):string;
    Function CloseChart(cname:string):string;
    Function ListChart:string;
    Function SelectChart(cname:string):string;
    Function HelpCmd(cname:string):string;
    function ExecuteCmd(cname:string; arg:Tstringlist):string;
    procedure SendInfo(Sender: TObject; origin,str:string);
    function GenericSearch(cname,Num:string):boolean;
    procedure StartServer;
    procedure StopServer;
    function GetUniqueName(cname:string; forcenumeric:boolean):string;
    procedure showdetailinfo(chart:string;ra,dec:double;cat,nm,desc:string);
    procedure CenterFindObj(chart:string);
    procedure NeighborObj(chart:string);
    procedure ConnectDB;
    procedure ImageSetFocus(Sender: TObject);
    procedure ListInfo(buf,msg:string);
    function  TCPClientConnected: boolean;
    procedure GetTCPInfo(i:integer; var buf:string);
    procedure KillTCPClient(i:integer);
    procedure PrintSetup(Sender: TObject);
    procedure GetChartConfig(csc:Tconf_skychart);
    procedure DrawChart(csc:Tconf_skychart);
    procedure ConfigDBChange(Sender: TObject);
    procedure SaveAndRestart(Sender: TObject);
    procedure ClearAndRestart;
    procedure InitializeDB(Sender: TObject);
    procedure Init;
    Procedure InitDS2000;
    function PrepareAsteroid(jdt:double; msg:Tstrings):boolean;
    procedure ChartMove(Sender: TObject);
    procedure GetActiveChart(var active_chart: string);
    procedure TCPShowError(var msg: string);
    procedure TCPShowSocket(var msg: string);
    procedure GetTwilight(jd0: double; out ht: double);
  end;

var
  f_main: Tf_main;

implementation

{$R *.lfm}

uses
{$if (lcl_major=0) and (lcl_minor=9) and (lcl_release<29) }
    {$IF DEFINED(LCLgtk) or DEFINED(LCLgtk2)}
     gtkproc,
    {$endif}
{$else}
    {$ifdef LCLgtk}
     gtkproc,
    {$endif}
    {$ifdef LCLgtk2}
     gtk2proc,
    {$endif}
{$endif}
     LCLProc,pu_detail, pu_about, pu_info, pu_getdss, u_projection, pu_config,
     pu_printsetup, pu_calendar, pu_position, pu_search, pu_zoom,
     pu_splash, pu_manualtelescope, pu_print, pu_clock;

{$ifdef mswindows}
const win32_color_elem : array[0..25] of integer = (COLOR_BACKGROUND,COLOR_BTNFACE,COLOR_ACTIVEBORDER,11    ,COLOR_ACTIVECAPTION,COLOR_BTNTEXT,COLOR_CAPTIONTEXT,COLOR_HIGHLIGHT,COLOR_BTNHIGHLIGHT,COLOR_HIGHLIGHTTEXT,COLOR_INACTIVECAPTION,COLOR_APPWORKSPACE,COLOR_INACTIVECAPTIONTEXT,COLOR_INFOBK,COLOR_INFOTEXT,COLOR_MENU,COLOR_MENUTEXT,COLOR_SCROLLBAR,COLOR_WINDOW,COLOR_WINDOWTEXT,COLOR_WINDOWFRAME,COLOR_3DDKSHADOW,COLOR_3DLIGHT,COLOR_BTNSHADOW,COLOR_GRAYTEXT,COLOR_MENUBAR);
{$endif}

procedure Tf_main.ShowError(msg: string);
begin
WriteTrace(msg);
ShowMessage(msg);
end;

function Tf_main.CreateChild(const CName: string; copyactive: boolean; cfg1 : Tconf_skychart; cfgp : Tconf_plot; locked:boolean=false):boolean;
var
  Child : Tf_chart;
  cp: TChildFrame;
  maxi: boolean;
  w,h,t,l: integer;
begin
  // allow for a reasonable number of chart 
  if (MultiFrame1.ChildCount>=MaxWindow) then begin
     SetLpanel1(rsTooManyOpenW);
     result:=false;
     exit;
  end;
  // copy active child config
  if copyactive and (MultiFrame1.Activeobject is Tf_chart) then begin
    cfg1.Assign((MultiFrame1.Activeobject as Tf_chart).sc.cfgsc);
    cfgp.Assign((MultiFrame1.Activeobject as Tf_chart).sc.plot.cfgplot);
    cfg1.scopemark:=false;
    maxi:=MultiFrame1.maximized;
    w:=MultiFrame1.ActiveChild.width;
    h:=MultiFrame1.ActiveChild.height;
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
  // create a new child window
  cp:=MultiFrame1.NewChild(CName);
  Child := Tf_chart.Create(cp);
  cp.DockedObject:=child;
  if locked then Child.lock_refresh:=true;
  inc(cfgm.MaxChildID);
  Child.tag:=cfgm.MaxChildID;
  Child.VertScrollBar.Visible:=ViewScrollBar1.Checked;
  Child.HorScrollBar.Visible:=ViewScrollBar1.Checked;
  if cfgm.KioskMode then Child.Image1.PopupMenu:=nil;
  cp.Caption:=CName;
  Child.Caption:=CName;
  Child.sc.catalog:=catalog;
  Child.sc.Fits:=Fits;
  Child.sc.planet:=planet;
  Child.sc.cdb:=cdcdb;
  Child.cmain:=cfgm;
  Child.sc.plot.cfgplot.Assign(cfgp);
  Child.sc.plot.cfgplot.starshapesize:=starshape.Picture.bitmap.Width div 11;
  Child.sc.plot.cfgplot.starshapew:=Child.sc.plot.cfgplot.starshapesize div 2;
  Child.sc.plot.starshape:=starshape.Picture.Bitmap;
  Child.sc.plot.compassrose:=compass;
  Child.sc.plot.compassarrow:=arrow;
  Child.sc.cfgsc.Assign(cfg1);
  Child.sc.cfgsc.chartname:=CName;
  Child.onImageSetFocus:=ImageSetFocus;
  Child.onSetFocus:=SetChildFocus;
  Child.onShowTopMessage:=SetTopMessage;
  Child.onShowTitleMessage:=SetTitleMessage;
  Child.OnUpdateBtn:=UpdateBtn;
  Child.OnChartMove:=ChartMove;
  Child.onShowInfo:=SetLpanel1;
  Child.onShowCoord:=SetLpanel0;
  Child.onListInfo:=ListInfo;
  if (not Child.sc.cfgsc.TrackOn)and(Child.sc.cfgsc.Projpole=Altaz) then begin
     Child.sc.cfgsc.TrackOn:=true;
     Child.sc.cfgsc.TrackType:=4;
  end;
  if not maxi then begin
     cp.width:=w;
     cp.height:=h;
     if t>=0 then cp.top:=t;
     if l>=0 then cp.left:=l;
  end;
  MultiFrame1.maximized:=maxi;
  result:=true;
  Child.locked:=false;
  Child.lock_refresh:=false;
  Child.Refresh;
end;

procedure Tf_main.RefreshAllChild(applydef:boolean);
var i: integer;
begin
for i:=0 to MultiFrame1.ChildCount-1 do
  if MultiFrame1.Childs[i].DockedObject is Tf_chart then
     with MultiFrame1.Childs[i].DockedObject as Tf_chart do begin
      sc.Fits:=Fits;
      sc.planet:=planet;
      sc.cdb:=cdcdb;
      if applydef then begin
        sc.cfgsc.Assign(def_cfgsc);
        sc.cfgsc.FindOk:=false;
        sc.plot.cfgplot.Assign(def_cfgplot);
      end;
      if VerboseMsg then
       WriteTrace('RefreshAllChild');
      AutoRefresh;
     end;
end;

procedure Tf_main.SyncChild;
var i,y,m,d: integer;
    ra,de,jda,t,tz: double;
    st: boolean;
begin
if MultiFrame1.ActiveObject is Tf_chart then begin
 ra:=(MultiFrame1.ActiveObject as Tf_chart).sc.cfgsc.racentre;
 de:=(MultiFrame1.ActiveObject as Tf_chart).sc.cfgsc.decentre;
 jda:=(MultiFrame1.ActiveObject as Tf_chart).sc.cfgsc.jdchart;
 y:=(MultiFrame1.ActiveObject as Tf_chart).sc.cfgsc.curyear;
 m:=(MultiFrame1.ActiveObject as Tf_chart).sc.cfgsc.curmonth;
 d:=(MultiFrame1.ActiveObject as Tf_chart).sc.cfgsc.curday;
 t:=(MultiFrame1.ActiveObject as Tf_chart).sc.cfgsc.curtime;
 tz:=(MultiFrame1.ActiveObject as Tf_chart).sc.cfgsc.Timezone;
 st:=(MultiFrame1.ActiveObject as Tf_chart).sc.cfgsc.UseSystemTime;
 for i:=0 to MultiFrame1.ChildCount-1 do
  if (MultiFrame1.Childs[i].DockedObject is Tf_chart) and (MultiFrame1.Childs[i].DockedObject<>MultiFrame1.ActiveObject) then
     with MultiFrame1.Childs[i].DockedObject as Tf_chart do begin
      precession(jda,sc.cfgsc.jdchart,ra,de);
      sc.cfgsc.UseSystemTime:=st;
      sc.cfgsc.curyear:=y;
      sc.cfgsc.curmonth:=m;
      sc.cfgsc.curday:=d;
      sc.cfgsc.curtime:=t;
      sc.cfgsc.Timezone:=tz;
      sc.cfgsc.TrackOn:=false;
      sc.cfgsc.racentre:=ra;
      sc.cfgsc.decentre:=de;
if VerboseMsg then
 WriteTrace('SyncChild');
      Refresh;
     end;
end;
end;

procedure Tf_main.AutorefreshTimer(Sender: TObject);
var i: integer;
begin
if AutoRefreshLock or (WindowState=wsMinimized) then exit;
try
if VerboseMsg then
 WriteTrace('AutorefreshTimer');
AutoRefreshLock:=true;
Autorefresh.enabled:=false;
for i:=0 to MultiFrame1.ChildCount-1 do
  if MultiFrame1.Childs[i].DockedObject is Tf_chart then
     with MultiFrame1.Childs[i].DockedObject as Tf_chart do begin
      if sc.cfgsc.autorefresh then AutoRefresh;
     end;
finally
AutoRefreshLock:=false;
Autorefresh.enabled:=true;
end;
end;

function Tf_main.GetUniqueName(cname:string; forcenumeric:boolean):string;
var xname: array of string;
    i,n : integer;
    ok: boolean;
    sep: string;
begin
if copy(cname,length(cname),1)='_' then sep:='' else sep:='_';
setlength(xname,MultiFrame1.ChildCount);
for i:=0 to MultiFrame1.ChildCount-1 do xname[i]:=MultiFrame1.Childs[i].caption;
if forcenumeric then n:=1
                else n:=0;
repeat
  ok:=true;
  if n=0 then result:=cname
         else result:=cname+sep+inttostr(n);
  for i:=0 to MultiFrame1.ChildCount-1 do
     if xname[i]=result then ok:=false;
  inc(n);
until ok;
end;

procedure Tf_main.FileNew1Execute(Sender: TObject);
var cname: string;
begin
  cname:=GetUniqueName(rsChart_, true);
  CreateChild(cname, true, def_cfgsc, def_cfgplot);
  SelectChart(cname);
end;

procedure Tf_main.FileClose1Execute(Sender: TObject);
begin
  if (MultiFrame1.ActiveObject is Tf_chart)and(MultiFrame1.ChildCount>1) then
   MultiFrame1.ActiveChild.close;
end;

function Tf_main.SaveChart(fn: string): string;
begin
if (fn<>'')and(MultiFrame1.ActiveObject is Tf_chart) then begin
  SaveChartConfig(SafeUTF8ToSys(fn),MultiFrame1.ActiveChild);
  result:=msgOK;
end else
  result:=msgFailed;
end;

procedure Tf_main.FileSaveAs1Execute(Sender: TObject);
begin
Savedialog.DefaultExt:='cdc3';
if Savedialog.InitialDir='' then Savedialog.InitialDir:=HomeDir;
savedialog.Filter:='Cartes du Ciel 3 File|*.cdc3|All Files|*.*';
savedialog.Title:=rsSaveTheCurre;
if SaveDialog.Execute then SaveChart(SaveDialog.Filename);
end;

function Tf_main.OpenChart(fn: string): string;
var nam: string;
    p: integer;
    maxi: boolean;
begin
if FileExistsUTF8(fn) then begin
 cfgp.Assign(def_cfgplot);
 cfgs.Assign(def_cfgsc);
 ReadChartConfig(SafeUTF8ToSys(fn),true,MultiFrame1.Maximized,cfgp,cfgs);
 nam:=stringreplace(extractfilename(fn),blank,'_',[rfReplaceAll]);
 p:=pos('.',nam);
 if p>0 then nam:=copy(nam,1,p-1);
 maxi:=cfgm.maximized;
 cfgm.maximized:=MultiFrame1.Maximized;
 CreateChild(GetUniqueName(nam,false) ,false,cfgs,cfgp);
 cfgm.maximized:=maxi;
 result:=msgOK;
end else
 result:=msgNotFound+' '+fn;
end;

function Tf_main.LoadDefaultChart(fn: string): string;
begin
if VerboseMsg then
 WriteTrace('LoadDefaultChart '+fn);
if FileExistsUTF8(fn) then begin
 cfgp.Assign(def_cfgplot);
 cfgs.Assign(def_cfgsc);
 ReadChartConfig(SafeUTF8ToSys(fn),true,true,def_cfgplot,def_cfgsc);
 Tf_chart(MultiFrame1.Childs[0].DockedObject).sc.cfgsc.Assign(def_cfgsc);
 Tf_chart(MultiFrame1.Childs[0].DockedObject).sc.plot.cfgplot.Assign(def_cfgplot);
 result:=msgOK;
end else if FileExists(fn) then begin
 cfgp.Assign(def_cfgplot);
 cfgs.Assign(def_cfgsc);
 ReadChartConfig(fn,true,true,def_cfgplot,def_cfgsc);
 Tf_chart(MultiFrame1.Childs[0].DockedObject).sc.cfgsc.Assign(def_cfgsc);
 Tf_chart(MultiFrame1.Childs[0].DockedObject).sc.plot.cfgplot.Assign(def_cfgplot);
 result:=msgOK;
end else
 result:=msgNotFound+' '+fn;
end;

function Tf_main.SetGCat(path,shortname,active,min,max: string): string;
var i,j,x,v:integer;
begin
if VerboseMsg then
 WriteTrace('SetGCat '+path+blank+shortname+blank+active+blank+min+blank+max);
result:=msgFailed;
val(min,x,v);
if v<>0 then exit;
val(max,x,v);
if v<>0 then exit;
if not fileexists(slash(path)+shortname+'.hdr') then exit;
path:=ExtractSubPath(Appdir,path);
i:=-1;
for j:=0 to catalog.cfgcat.GCatNum-1 do
   if catalog.cfgcat.GCatLst[j].shortname=trim(shortname) then i:=j;
if i<0 then begin
  catalog.cfgcat.GCatNum:=catalog.cfgcat.GCatNum+1;
  SetLength(catalog.cfgcat.GCatLst,catalog.cfgcat.GCatNum);
  i:=catalog.cfgcat.GCatNum-1;
end;
catalog.cfgcat.GCatLst[i].shortname:=trim(shortname);
catalog.cfgcat.GCatLst[i].path:=trim(path);
val(min,x,v);
if v=0 then catalog.cfgcat.GCatLst[i].min:=x
       else catalog.cfgcat.GCatLst[i].min:=0;
val(max,x,v);
if v=0 then catalog.cfgcat.GCatLst[i].max:=x
       else catalog.cfgcat.GCatLst[i].max:=0;
catalog.cfgcat.GCatLst[i].Actif:=(active='1');
catalog.cfgcat.GCatLst[i].magmax:=0;
catalog.cfgcat.GCatLst[i].name:='';
catalog.cfgcat.GCatLst[i].cattype:=0;
catalog.cfgcat.GCatLst[i].ForceColor:=false;
catalog.cfgcat.GCatLst[i].col:=0;
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
if (active='1')and(not catalog.cfgcat.GCatLst[i].Actif) then begin
  catalog.cfgcat.GCatNum:=catalog.cfgcat.GCatNum-1;
  SetLength(catalog.cfgcat.GCatLst,catalog.cfgcat.GCatNum);
  exit;
end;
result:=msgOK;
end;

procedure Tf_main.FileOpen1Execute(Sender: TObject);
begin
if OpenDialog.InitialDir='' then OpenDialog.InitialDir:=HomeDir;
OpenDialog.Filter:='Cartes du Ciel 3 File|*.cdc3|All Files|*.*';
OpenDialog.Title:=rsOpenAChart;
if OpenDialog.Execute then
    OpenChart(OpenDialog.FileName);
end;

procedure Tf_main.FormActivate(Sender: TObject);
begin
  ImageSetFocus(Sender);
end;

procedure Tf_main.FormShow(Sender: TObject);
begin
try
if VerboseMsg then
 WriteTrace('Enter Tf_main.FormShow');
 if nightvision or (cfgm.ThemeName<>'default')or(cfgm.ButtonStandard>1) then ThemeTimer.Enabled:=true;
 InitFonts;
 SetLpanel1('');
except
  on E: Exception do begin
   WriteTrace('FormShow error: '+E.Message);
   MessageDlg('FormShow error: '+E.Message, mtError, [mbClose], 0);
  end;
end;
InitTimer.Enabled:=true;
InitOK:=true;
if VerboseMsg then
 WriteTrace('Exit Tf_main.FormShow');
end;

procedure Tf_main.InitTimerTimer(Sender: TObject);
var i:integer;
begin
InitTimer.Enabled:=False;
if VerboseMsg then
 WriteTrace('Enter Tf_main.InitTimerTimer');
MultiFrame1.setActiveChild(0);
// ensure a first chart is draw, even if it usually result in a double refresh on launch
for i:=0 to MultiFrame1.ChildCount-1 do
 if MultiFrame1.Childs[i].DockedObject is Tf_chart then
    with MultiFrame1.Childs[i].DockedObject as Tf_chart do begin
       RefreshTimer.Enabled:=false;
       RefreshTimer.Enabled:=true;
    end;
if VerboseMsg then
 WriteTrace('Exit Tf_main.InitTimerTimer');
end;

{$ifdef unix}
Procedure RecvSignal(sig:longint);cdecl;
begin
WriteTrace('Receiving signal '+inttostr(sig));
case sig of
1  : f_main.ResetDefaultChartExecute(nil);
15 : f_main.Close;
end;
end;
{$endif}

Procedure Tf_main.InitDS2000;
var srcdir, dsdir: string;
    i: integer;
const
    numfn = 4;
    fn: array [1..numfn] of string = ('ds2000.cdc3','d2k.hdr','d2k.info2','d2k.prj');
begin
try
srcdir:=systoutf8(slash(SampleDir));
dsdir:=systoutf8(slash(PrivateDir)+slash('ds2000'));
if not DirectoryExistsutf8(dsdir) then ForceDirectoriesutf8(dsdir);
// Upgrade
for i:=1 to numfn do begin
  if fileexists(dsdir+fn[i])and(FileAge(srcdir+fn[i]) > FileAge(dsdir+fn[i])) then begin
     DeleteFile(dsdir+fn[i]);
     CopyFile(srcdir+fn[i], dsdir+fn[i], true);
  end;
end;
// Initial copy
for i:=1 to numfn do begin
  if not fileexists(dsdir+fn[i]) then
    CopyFile(srcdir+fn[i], dsdir+fn[i], true);
end;
except
end;
end;

procedure Tf_main.Init;
var i: integer;
    firstuse: boolean;
begin
firstuse:=false;
try
if VerboseMsg then
 WriteTrace('Enter Tf_main.Init');
 // some initialisation that need to be done after all the forms are created.
 f_info.onGetTCPinfo:=GetTCPInfo;
 f_info.onKillTCP:=KillTCPClient;
 f_info.onPrintSetup:=PrintSetup;
 f_info.OnShowDetail:=showdetailinfo;
 f_detail.OnCenterObj:=CenterFindObj;
 f_detail.OnNeighborObj:=NeighborObj;
if VerboseMsg then
 WriteTrace('SetDefault');
 SetDefault;
if VerboseMsg then
 WriteTrace('ReadDefault');
 ReadDefault;
if VerboseMsg then
 WriteTrace('InitDS2000');
 InitDS2000;
 // must read db configuration before to create this one!
if VerboseMsg then
 WriteTrace('Create DB');
 cdcdb:=TCDCdb.Create(self);
 planet:=Tplanet.Create(self);
 Fits:=TFits.Create(self);
 cdcdb.onInitializeDB:=InitializeDB;
 planet.cdb:=cdcdb;
 f_search.cdb:=cdcdb;
 planet.SetDE(slash(Appdir)+slash('data')+'jpleph');
if VerboseMsg then
 WriteTrace('Background Image');
 if def_cfgsc.BackgroundImage='' then begin
   def_cfgsc.BackgroundImage:=slash(PictureDir);
   if not DirectoryExists(def_cfgsc.BackgroundImage) then forcedirectories(def_cfgsc.BackgroundImage);
 end;
if VerboseMsg then
 WriteTrace('Constellation');
 if def_cfgsc.ConstLatinLabel then
    catalog.LoadConstellation(cfgm.Constellationpath,'Latin')
  else
    catalog.LoadConstellation(cfgm.Constellationpath,Lang);
 catalog.LoadConstL(cfgm.ConstLfile);
 catalog.LoadConstB(cfgm.ConstBfile);
 catalog.LoadHorizon(cfgm.horizonfile,def_cfgsc);
 catalog.LoadStarName(slash(appdir)+slash('data')+slash('common_names'),Lang);
 f_search.cfgshr:=catalog.cfgshr;
 f_search.showpluto:=def_cfgsc.ShowPluto;
 f_search.SesameUrlNum:=cfgm.SesameUrlNum;
 f_search.SesameCatNum:=cfgm.SesameCatNum;
 f_search.Init;
if VerboseMsg then
 WriteTrace('Connect DB');
 ConnectDB;
if VerboseMsg then
 WriteTrace('Cursor');
 if (not isWin98) and fileexists(slash(appdir)+slash('data')+slash('Themes')+slash('default')+'retic.cur') then begin
    try
    CursorImage1.LoadFromFile(SysToUTF8(slash(appdir)+slash('data')+slash('Themes')+slash('default')+'retic.cur'));
    Screen.Cursors[crRetic]:=CursorImage1.Handle;
    except
      crRetic:=crCross;
    end;
 end
 else crRetic:=crCross;
if VerboseMsg then
 WriteTrace('Compass');
 if fileexists(slash(appdir)+slash('data')+slash('Themes')+slash('default')+'compass.bmp') then
    compass.LoadFromFile(SysToUTF8(slash(appdir)+slash('data')+slash('Themes')+slash('default')+'compass.bmp'));
 if fileexists(slash(appdir)+slash('data')+slash('Themes')+slash('default')+'arrow.bmp') then
    arrow.LoadFromFile(SysToUTF8(slash(appdir)+slash('data')+slash('Themes')+slash('default')+'arrow.bmp'));
if VerboseMsg then
 WriteTrace('Starshape file');
if (cfgm.starshape_file<>'')and(FileExists(utf8tosys(cfgm.starshape_file))) then begin
  starshape.Picture.LoadFromFile(cfgm.starshape_file);
end;
if VerboseMsg then
 WriteTrace('Timezone');
 def_cfgsc.tz.TimeZoneFile:=ZoneDir+StringReplace(def_cfgsc.ObsTZ,'/',PathDelim,[rfReplaceAll]);
 if def_cfgsc.tz.TimeZoneFile='' then firstuse:=true;
 if firstuse then begin
    if VerboseMsg then
     WriteTrace('First setup');
    FirstSetup
 end;
 application.ProcessMessages; // apply any resizing
if VerboseMsg then
 WriteTrace('Init calendar');
 f_calendar.planet:=planet;
 f_calendar.cdb:=cdcdb;
 f_calendar.OnGetChartConfig:=GetChartConfig;
 f_calendar.OnUpdateChart:=DrawChart;
 f_calendar.eclipsepath:=slash(appdir)+slash('data')+slash('eclipses');
 if cfgm.KioskMode then begin
   if VerboseMsg then
    WriteTrace('Initialize kiosk mode');
   if not cfgm.KioskDebug then ViewFullScreenExecute(nil);
   ViewScrollBar1Click(nil);
   file1.Visible:=False;
   edit1.Visible:=False;
   setup1.Visible:=False;
   view1.Visible:=False;
   chart1.Visible:=False;
   telescope1.Visible:=False;
   Window1.Visible:=False;
   help1.Visible:=False;
   topmessage.Visible:=False;
   ToolBar1.visible:=False;
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
   FormResize(nil);
 end;
if VerboseMsg then
 WriteTrace('Create default chart');
 CreateChild(GetUniqueName(rsChart_, true), true, def_cfgsc, def_cfgplot, true);
 if InitialChartNum>1 then begin
    if VerboseMsg then
     WriteTrace('Load '+inttostr(InitialChartNum-1)+' supplementary charts');
    for i:=1 to InitialChartNum-1 do begin
      try
      cfgp.Assign(def_cfgplot);
      cfgs.Assign(def_cfgsc);
      ReadChartConfig(configfile+inttostr(i),true,false,cfgp,cfgs);
      CreateChild(GetUniqueName(rsChart_, true) , false, cfgs, cfgp);
      except
      end;
    end;
 end;
 if VerboseMsg then
 WriteTrace('Read params');
 ProcessParams2;
if cfgm.AutostartServer then begin
    if VerboseMsg then
     WriteTrace('Start server');
    StartServer;
end;
{$ifdef unix}
if VerboseMsg then
 WriteTrace('Add signal handler');
CdcSigAction(@RecvSignal);
{$endif}
if DirectoryExists(cfgm.ImagePath+'sac')and(cdcdb.CountImages=0) then begin
  if VerboseMsg then
   WriteTrace('Init picture DB');
  SetupPicturesPage(0,1);
end;
if (not firstuse)and(config_version<cdcver) then
   ShowReleaseNotes(false);
Autorefresh.Interval:=max(10,cfgm.autorefreshdelay)*1000;
AutoRefreshLock:=false;
Autorefresh.enabled:=true;
if not Application.ShowMainForm then InitOK:=true;  // no formshow if --daemon
except
  on E: Exception do begin
   WriteTrace('Initialization error: '+E.Message);
   MessageDlg('Initialization error: '+E.Message, mtError, [mbClose], 0);
  end;
end;
if VerboseMsg then
 WriteTrace('Exit Tf_main.Init');
end;

procedure Tf_main.ShowReleaseNotes(shownext:boolean);
var buf: string;
begin
 if f_splash<>nil then f_splash.Close;
 application.ProcessMessages;
 buf:=slash(HelpDir)+'releasenotes_'+lang+'.txt';
 if not fileexists(buf) then
    buf:=slash(HelpDir)+'releasenotes.txt';
 if fileexists(buf) then begin
    f_info.setpage(3);
    f_info.TitlePanel.Caption:=f_info.TitlePanel.Caption+', '+cdcversion+RevisionStr;
    if shownext then f_info.Button1.caption:=rsNext
                else f_info.Button1.caption:=rsClose;
    f_info.InfoMemo.Lines.LoadFromFile(buf);
    f_info.InfoMemo.Text:=CondUTF8Decode(f_info.InfoMemo.Text);
    f_info.showmodal;
 end;
 SaveDefault;
end;

procedure Tf_main.FirstSetup;
begin
 ShowReleaseNotes(true);
 SetupObservatoryPage(0,-1);
 def_cfgsc.tz.TimeZoneFile:=ZoneDir+StringReplace(def_cfgsc.ObsTZ,'/',PathDelim,[rfReplaceAll]);
 if def_cfgsc.tz.TimeZoneFile='' then begin
    def_cfgsc.ObsTZ:='Etc/GMT';
    def_cfgsc.tz.TimeZoneFile:=ZoneDir+StringReplace(def_cfgsc.ObsTZ,'/',PathDelim,[rfReplaceAll]);
 end;
 SavePrivateConfig(configfile);
 SaveChartConfig(configfile,nil);
end;

procedure Tf_main.SaveImageExecute(Sender: TObject);
var ext,format,fn:string;
begin
Savedialog.DefaultExt:='';
if Savedialog.InitialDir='' then Savedialog.InitialDir:=HomeDir;
savedialog.Filter:='PNG|*.png|JPEG|*.jpg|BMP|*.bmp';
savedialog.Title:=rsSaveImage;
if MultiFrame1.ActiveObject  is Tf_chart then
 with MultiFrame1.ActiveObject as Tf_chart do
  if SaveDialog.Execute then begin
     fn:=SaveDialog.Filename;
     ext:=uppercase(extractfileext(fn));
     if ext='' then
        case Savedialog.FilterIndex of
        0,1 : ext:='.PNG';
        2   : ext:='.JPG';
        3   : ext:='.BMP';
        end;
     if (ext='.JPG')or(ext='.JPEG') then format:='JPEG'
     else if (ext='.BMP') then format:='BMP'
     else format:='PNG';
     SaveChartImage(format,fn,95);
  end;
end;

procedure Tf_main.HelpAbout1Execute(Sender: TObject);
begin
if f_about=nil then f_about:=Tf_about.Create(application);
f_about.ShowModal;
end;

procedure Tf_main.HelpContents1Execute(Sender: TObject);
begin
sethelp(self,hlpIndex);
ShowHelp;
end;

procedure Tf_main.HelpFaq1Execute(Sender: TObject);
begin
sethelp(self,hlpFaq);
ShowHelp;
sethelp(self,hlpIndex);
end;

procedure Tf_main.HelpQS1Execute(Sender: TObject);
begin
sethelp(self,hlpQSguide);
ShowHelp;
sethelp(self,hlpIndex);
end;

procedure Tf_main.HomePage1Click(Sender: TObject);
begin
   ExecuteFile(URL_WebHome);
end;

procedure Tf_main.Maillist1Click(Sender: TObject);
begin
   ExecuteFile(URL_Maillist);
end;

procedure Tf_main.MenuChartInfoClick(Sender: TObject);
begin
if MultiFrame1.ActiveObject is Tf_chart then with MultiFrame1.ActiveObject as Tf_chart do begin
   sc.cfgsc.ShowLabel[8]:=not sc.cfgsc.ShowLabel[8];
   Refresh;
end;
end;

procedure Tf_main.MenuChartLegendClick(Sender: TObject);
begin
if MultiFrame1.ActiveObject is Tf_chart then with MultiFrame1.ActiveObject as Tf_chart do begin
   sc.cfgsc.ShowLegend:=not sc.cfgsc.ShowLegend;
   Refresh;
end;
end;

procedure Tf_main.MenuItem7Click(Sender: TObject);
begin
  SetupPicturesPage(1);
end;

procedure Tf_main.MultiFrame1CreateChild(Sender: TObject);
begin
TabControl1.Tabs.Add(TChildFrame(Sender).Caption);
if TabControl1.Visible<>(MultiFrame1.Maximized)and(MultiFrame1.ChildCount>1) then begin
  TabControl1.Visible:=(MultiFrame1.Maximized)and(MultiFrame1.ChildCount>1);
  ViewTopPanel;
end;
end;

procedure Tf_main.MultiFrame1DeleteChild(Sender: TObject);
var i: integer;
begin
for i:=0 to TabControl1.Tabs.Count-1 do begin
   if TabControl1.Tabs[i]=TChildFrame(Sender).Caption then begin
      TabControl1.Tabs.Delete(i);
      break;
   end;
end;
// test for two childs because the currently deleting child is still counted
if TabControl1.Visible<>(MultiFrame1.Maximized)and(MultiFrame1.ChildCount>2) then begin
  TabControl1.Visible:=(MultiFrame1.Maximized)and(MultiFrame1.ChildCount>2);
  ViewTopPanel;
end;
end;

procedure Tf_main.TabControl1Change(Sender: TObject);
var cname: string;
begin
if (TabControl1.TabIndex>=0)and(TabControl1.TabIndex<TabControl1.Tabs.Count)  then begin
  cname:=TabControl1.Tabs[TabControl1.TabIndex];
  SelectChart(cname);
end;
end;

procedure Tf_main.NextChild1Click(Sender: TObject);
begin
  MultiFrame1.NexChild;
end;

procedure Tf_main.BugReport1Click(Sender: TObject);
begin
   ExecuteFile(URL_BugTracker);
end;

procedure Tf_main.CloseTimerTimer(Sender: TObject);
begin
  CloseTimer.Enabled:=false;
  Close;
end;


procedure Tf_main.MagPanelMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
 if Button=mbRight then SetupChartPage(3);
end;

procedure Tf_main.FileExit1Execute(Sender: TObject);
begin
  Close;
end;

Procedure Tf_main.GetLanguage;
var inif: TMemIniFile;
begin
if fileexists(configfile) then begin
  inif:=TMeminifile.create(configfile);
  try
  cfgm.language:=inif.ReadString('main','language','');
  if cfgm.language='UK' then cfgm.language:=''; // migration pre-beta 2
  finally
   inif.Free;
  end;
end;
end;

Procedure Tf_main.GetAppDir;
var inif: TMemIniFile;
    buf: string;
{$ifdef darwin}
    i: integer;
{$endif}
{$ifdef mswindows}
    PIDL : LPITEMIDLIST;
    Folder : array[0..MAX_PATH] of Char;
{$endif}
begin
{$ifdef darwin}
appdir:=getcurrentdir;
if not DirectoryExists(slash(appdir)+slash('data')+slash('planet')) then begin
   appdir:=ExtractFilePath(ParamStr(0));
   i:=pos('.app/',appdir);
   if i>0 then begin
     appdir:=ExtractFilePath(copy(appdir,1,i));
   end;
end;
{$else}
appdir:=getcurrentdir;
if not DirectoryExists(slash(appdir)+slash('data')+slash('planet')) then begin
   appdir:=ExtractFilePath(ParamStr(0));
end;
if VerboseMsg then
 debugln('appdir='+appdir);
{$endif}
PrivateDir:=DefaultPrivateDir;
HomeDir:=DefaultHomeDir;
{$ifdef unix}
Appdir:=expandfilename(appdir);
PrivateDir:=expandfilename(PrivateDir);
HomeDir:=expandfilename(HomeDir);
{$endif}
{$ifdef mswindows}
buf:=systoutf8(appdir);
buf:=trim(buf);
appdir:=SafeUTF8ToSys(buf);
buf:='';
SHGetSpecialFolderLocation(0, CSIDL_LOCAL_APPDATA, PIDL);
SHGetPathFromIDList(PIDL, Folder);
buf:=systoutf8(Folder);
buf:=trim(buf);
buf:=SafeUTF8ToSys(buf);
if buf='' then begin  // old windows version
   SHGetSpecialFolderLocation(0, CSIDL_APPDATA, PIDL);
   SHGetPathFromIDList(PIDL, Folder);
   buf:=trim(Folder);
end;
if buf='' then begin
   MessageDlg(rsUnableToCrea+privatedir+crlf
             +rsPleaseTryToC,
             mtError, [mbAbort], 0);
   Halt;
end;
privatedir:=slash(buf)+privatedir;
configfile:=slash(privatedir)+configfile;
SHGetSpecialFolderLocation(0, CSIDL_PERSONAL, PIDL);
SHGetPathFromIDList(PIDL, Folder);
homedir:=trim(systoutf8(Folder));
{$endif}

if ForceConfig<>'' then Configfile:=ForceConfig;

ConfigAppdir:='';
ConfigPrivateDir:='';

if fileexists(configfile) then begin
  inif:=TMeminifile.create(configfile);
  try
  buf:=inif.ReadString('main','AppDir',appdir);
  if Directoryexists(buf) then appdir:=noslash(buf);
  if buf<>'' then ConfigAppdir:=noslash(buf);
  buf:=inif.ReadString('main','PrivateDir',privatedir);
  if Directoryexists(buf) then privatedir:=noslash(buf);
  if buf<>'' then ConfigPrivateDir:=noslash(buf);
  finally
   inif.Free;
  end;
end;

if ForceUserDir<>'' then PrivateDir:=noslash(ForceUserDir);

if not directoryexists(privatedir) then CreateDir(privatedir);
if not directoryexists(privatedir) then forcedirectories(privatedir);
if not directoryexists(privatedir) then begin
   MessageDlg(rsUnableToCrea+privatedir+crlf
             +rsPleaseTryToC,
             mtError, [mbAbort], 0);
   Halt;
end;
MPCDir:=slash(privatedir)+'MPC';
if not directoryexists(MPCDir) then CreateDir(MPCDir);
if not directoryexists(MPCDir) then forcedirectories(MPCDir);
DBDir:=slash(privatedir)+'database';
if not directoryexists(DBDir) then CreateDir(DBDir);
if not directoryexists(DBDir) then forcedirectories(DBDir);
PictureDir:=slash(privatedir)+'pictures';
if not directoryexists(PictureDir) then CreateDir(slash(privatedir)+'pictures');
if not directoryexists(slash(privatedir)+'pictures') then forcedirectories(slash(privatedir)+'pictures');
VODir:=slash(privatedir)+'vo';
if not directoryexists(VODir) then CreateDir(VODir);
if not directoryexists(VODir) then forcedirectories(VODir);
Tempdir:=slash(privatedir)+DefaultTmpDir;
if not directoryexists(TempDir) then CreateDir(TempDir);
if not directoryexists(TempDir) then forcedirectories(TempDir);
SatDir:=slash(privatedir)+'satellites';
if not directoryexists(SatDir) then CreateDir(SatDir);
if not directoryexists(SatDir) then forcedirectories(SatDir);
if VerboseMsg then
 debugln('appdir='+appdir);
// Be sur the data directory exists
if (not directoryexists(slash(appdir)+slash('data')+'constellation')) then begin
  // try under the current directory
  buf:=GetCurrentDir;
  if VerboseMsg then
   debugln('Try '+buf);
  if (directoryexists(slash(buf)+slash('data')+'constellation')) then
     appdir:=buf
  else begin
     // try under the program directory
     buf:=ExtractFilePath(ParamStr(0));
    if VerboseMsg then
     debugln('Try '+buf);
     if (directoryexists(slash(buf)+slash('data')+'constellation')) then
        appdir:=buf
     else begin
         // try share directory under current location
         buf:=ExpandFileName(slash(GetCurrentDir)+SharedDir);
          if VerboseMsg then
           debugln('Try '+buf);
         if (directoryexists(slash(buf)+slash('data')+'constellation')) then
            appdir:=buf
         else begin
            // try share directory at the same location as the program
            buf:=ExpandFileName(slash(ExtractFilePath(ParamStr(0)))+SharedDir);
            if VerboseMsg then
             debugln('Try '+buf);
            if (directoryexists(slash(buf)+slash('data')+'constellation')) then
               appdir:=buf
            else begin
               MessageDlg('Could not found the application data directory.'+crlf
                   +'Please edit the file skychart.ini'+crlf
                   +'and indicate at the line Appdir= where you install the data.',
                   mtError, [mbAbort], 0);
               Halt;
            end;
         end;
     end;
  end;
end;
if VerboseMsg then begin
 debugln('appdir='+appdir);
 debugln('privatedir='+privatedir);
end;
{$ifdef mswindows}
tracefile:=slash(privatedir)+tracefile;
{$endif}
VarObs:=slash(appdir)+DefaultVarObs;     // varobs normally at same location as skychart
if not FileExists(VarObs) then VarObs:=DefaultVarObs; // if not try in $PATH
helpdir:=slash(appdir)+slash('doc');
SampleDir:=slash(appdir)+slash('data')+'sample';
// Be sure zoneinfo exists in standard location or in skychart directory
ZoneDir:=slash(appdir)+slash('data')+slash('zoneinfo');
if VerboseMsg then
 debugln('ZoneDir='+ZoneDir);
buf:=slash('')+slash('usr')+slash('share')+slash('zoneinfo');
if VerboseMsg then
 debugln('Try '+buf);
if (FileExists(slash(buf)+'zone.tab')) then
     ZoneDir:=slash(buf)
else begin
  buf:=slash('')+slash('usr')+slash('lib')+slash('zoneinfo');
  if VerboseMsg then
   debugln('Try '+buf);
  if (FileExists(slash(buf)+'zone.tab')) then
      ZoneDir:=slash(buf)
  else begin
     if (not FileExists(slash(ZoneDir)+'zone.tab')) then begin
       MessageDlg('zoneinfo directory not found!'+crlf
         +'Please install the tzdata package.'+crlf
         +'If it is not installed at a standard location create a logical link zoneinfo in skychart data directory.',
         mtError, [mbAbort], 0);
       Halt;
     end;
  end;
end;
if VerboseMsg then
 debugln('ZoneDir='+ZoneDir);
end;

procedure Tf_main.FormCreate(Sender: TObject);
var step,buf:string;
begin
try
if VerboseMsg then
 debugln('Enter f_main.formcreate');
InitOK:=false;
ForceClose:=false;
RestoreState:=false;
SaveState:=wsNormal;
UniqueInstance1:=TCdCUniqueInstance.Create(self);
UniqueInstance1.Identifier:='skychart';
UniqueInstance1.OnOtherInstance:=OtherInstance;
UniqueInstance1.OnInstanceRunning:=InstanceRunning;
UniqueInstance1.Enabled:=true;
UniqueInstance1.Loaded;
step:='Init';
if VerboseMsg then
 debugln(step);
DefaultFormatSettings.DecimalSeparator:='.';
DefaultFormatSettings.ThousandSeparator:=',';
DefaultFormatSettings.DateSeparator:='/';
DefaultFormatSettings.TimeSeparator:=':';
NeedRestart:=false;
showsplash:=true;
ConfirmSaveConfig:=true;
ImageListCount:=ImageNormal.Count;
DisplayIs32bpp:=true;
isWin98:=false;
{$ifdef mswindows}
  step:='Windows spefic';
  isWin98:=FindWin98;
  DisplayIs32bpp:=(ScreenBPP=32);
  configfile:=Defaultconfigfile;
  if isWin98 then begin
    step:='Windows 98 spefic';
    MenuItem24.Visible:=false;  // config all not working
    MenuItem25.Visible:=false;
    MenuItem26.Visible:=false;
    MenuItem6.Visible:=false;
    if FileExists(Win98DefaultBrowser) then HTMLBrowserHelpViewer1.BrowserPath:=Win98DefaultBrowser;
  end;
  SaveDialog.Options:=SaveDialog.Options-[ofNoReadOnlyReturn]; { TODO : check readonly test on Windows }
{$endif}
CanShowScrollbar:=true;
{$ifdef unix}
  step:='Unix specific';
  configfile:=expandfilename(Defaultconfigfile);
  if DirectoryExists('/usr/share/doc/overlay-scrollbar') then begin
     buf:=GetEnvironmentVariable('LIBOVERLAY_SCROLLBAR');
     if buf<>'0' then CanShowScrollbar:=false;
  end;
{$endif}
{$ifdef darwin}
  step:='Darwin specific';
  MenuItem24.Visible:=false;  // config all not working
  MenuItem25.Visible:=false;
  MenuItem26.Visible:=false;
  MenuItem6.Visible:=false;
{$endif}
step:='Create config';
if VerboseMsg then
 debugln(step);
def_cfgsc:=Tconf_skychart.Create;
cfgs:=Tconf_skychart.Create;
cfgm:=Tconf_main.Create;
def_cfgplot:=Tconf_plot.Create;
cfgp:=Tconf_plot.Create;
ForceConfig:='';
step:='Create cursor';
if VerboseMsg then
 debugln(step);
CursorImage1:=TCursorImage.Create;
step:='Read initial parameters';
if VerboseMsg then
 debugln(step);
ProcessParams1;
step:='Application directory';
if VerboseMsg then
 debugln(step);
GetAppDir;
chdir(appdir);
step:='Trace';
if VerboseMsg then
 debugln(step);
InitTrace;
if VerboseMsg then begin
 WriteTrace('Privatedir: '+PrivateDir);
 WriteTrace('Appdir: '+AppDir);
end;
step:='Language';
if VerboseMsg then
 WriteTrace(step);
GetLanguage;
lang:=u_translation.translate(cfgm.language);
u_help.Translate(lang);
catalog:=Tcatalog.Create(self);
SetLang;
step:='Multiframe';
if VerboseMsg then
 WriteTrace(step);
TabControl1.Visible:=false;
basecaption:=caption;
MultiFrame1.WindowList:=Window1;
MultiFrame1.KeepLastChild:=true;
ChildControl.visible:=false;
BtnCloseChild.Glyph.LoadFromLazarusResource('CLOSE');
BtnRestoreChild.Glyph.LoadFromLazarusResource('RESTORE');
step:='Size control';
if VerboseMsg then
 WriteTrace(step);
MultiFrame1.Align:=alClient;
starshape.Picture.Bitmap.Transparent:=false;
quicksearch.Width:=round( 75 {$ifdef mswindows} * Screen.PixelsPerInch/96 {$endif} );
TimeU.Width:=round( 95 {$ifdef mswindows} * Screen.PixelsPerInch/96 {$endif} );
step:='Load zlib';
if VerboseMsg then
 WriteTrace(step);
zlib:=LoadLibrary(libz);
if zlib<>0 then begin
  gzopen:= Tgzopen(GetProcedureAddress(zlib,'gzopen'));
  gzread:= Tgzread(GetProcedureAddress(zlib,'gzread'));
  gzclose:= Tgzclose(GetProcedureAddress(zlib,'gzclose'));
  gzeof:= Tgzeof(GetProcedureAddress(zlib,'gzeof'));
  zlibok:=true;
end else zlibok:=false;
step:='Load plan404';
if VerboseMsg then
 WriteTrace(step);
Plan404:=nil;
Plan404lib:=LoadLibrary(lib404);
if Plan404lib<>0 then begin
  Plan404:= TPlan404(GetProcedureAddress(Plan404lib,'Plan404'));
end;
if @Plan404=nil then begin
   MessageDlg(rsCouldNotLoad+lib404+crlf
             +rsPleaseTryToR,
             mtError, [mbAbort], 0);
   Halt;
end;
step:='Load cdcwcs';
if VerboseMsg then
 WriteTrace(step);
cdcwcs_initfitsfile:=nil;
cdcwcs_release:=nil;
cdcwcs_sky2xy:=nil;
cdcwcslib:=LoadLibrary(libcdcwcs);
if cdcwcslib<>0 then begin
  cdcwcs_initfitsfile:= Tcdcwcs_initfitsfile(GetProcedureAddress(cdcwcslib,'cdcwcs_initfitsfile'));
  cdcwcs_release:= Tcdcwcs_release(GetProcedureAddress(cdcwcslib,'cdcwcs_release'));
  cdcwcs_sky2xy:= Tcdcwcs_sky2xy(GetProcedureAddress(cdcwcslib,'cdcwcs_sky2xy'));
  cdcwcs_getinfo:= Tcdcwcs_getinfo(GetProcedureAddress(cdcwcslib,'cdcwcs_getinfo'));
end;
if (@cdcwcs_initfitsfile=nil)or(@cdcwcs_release=nil)or(@cdcwcs_sky2xy=nil)or(@cdcwcs_getinfo=nil) then begin
   MessageDlg(rsCouldNotLoad+libcdcwcs+crlf
             +rsPleaseTryToR,
             mtError, [mbAbort], 0);
   Halt;
end;
{$ifdef unix}
   step:='Multiframe unix';
if VerboseMsg then
 WriteTrace(step);
   MultiFrame1.InactiveBorderColor:=$404040;
   MultiFrame1.TitleColor:=clBlack;
   MultiFrame1.BorderColor:=$808080;
{$endif}
step:='Bitmap';
if VerboseMsg then
 WriteTrace(step);
compass:=TBitmap.create;
arrow:=TBitmap.create;
step:='Load timezone';
if VerboseMsg then
 WriteTrace(step);
def_cfgsc.tz.LoadZoneTab(ZoneDir+'zone.tab');
except
  on E: Exception do begin
   WriteTrace(step+': '+E.Message);
   MessageDlg(step+': '+E.Message+crlf+rsSomethingGoW+crlf
             +rsPleaseTryToR,
             mtError, [mbAbort], 0);
   Halt;
   end;
end;
if VerboseMsg then
 WriteTrace('Exit Tf_main.FormCreate');
end;

procedure Tf_main.FormDestroy(Sender: TObject);
var i:integer;
begin
try
if VerboseMsg then
 WriteTrace('Destroy Tf_main');
catalog.free;
Fits.Free;
planet.free;
cdcdb.free;
def_cfgsc.Free;
cfgs.Free;
if cfgm.ObsNameList<>nil then begin
  try
  for i:=0 to cfgm.ObsNameList.Count-1 do
      if cfgm.ObsNameList.Objects[i]<>nil then cfgm.ObsNameList.Objects[i].Free;
  except
  end;
  cfgm.ObsNameList.Free;
end;
cfgm.Free;
def_cfgplot.Free;
cfgp.Free;
compass.free;
arrow.free;
if NeedRestart then ExecNoWait(paramstr(0));
if VerboseMsg then
 WriteTrace('Destroy Cursor');
if CursorImage1<>nil then begin
  if lclver<'0.9.29' then CursorImage1.FreeImage;
  CursorImage1.Free;
end;
if VerboseMsg then
 WriteTrace('Destroy end');
except
writetrace('error destroy '+name);
end;
end;

procedure Tf_main.FormClose(Sender: TObject; var Action: TCloseAction);
var i,h,w,mresult:integer;
    f1: TForm;
    l1: TLabel;
    c1: Tcheckbox;
    btn: TButtonPanel;
begin
if (not ForceClose) and TCPClientConnected then begin  // do not close if client are connected
   Action:=caMinimize;
   SaveState:=WindowState;
   RestoreState:=true;
   writetrace('Client still connected, minimize instead of close.');
end else begin
  try
  {$ifdef mswindows}
  if nightvision then ResetWinColor;
  {$endif}
  StopServer;
  writetrace(rsExiting);
  Autorefresh.Enabled:=false;
  if SaveConfigOnExit.checked then begin
     if ConfirmSaveConfig then begin
     try
      f1:=TForm.Create(self);
      f1.AutoSize:=false;
      f1.Position:=poScreenCenter;
      f1.Caption:=rsSaveConfigur;
      l1:=TLabel.Create(f1);
      l1.Caption:=rsDoYouWantToS;
      l1.ParentFont:=true;
      btn:= TButtonPanel.Create(f1);
      btn.ShowButtons:=[pbOK,pbCancel];
      btn.OKButton.Caption:=rsmbYes;
      btn.CancelButton.Caption:=rsmbNo;
      btn.ShowGlyphs:=[];
      btn.AutoSize:=true;
      btn.Align:=alBottom;
      c1:=Tcheckbox.Create(f1);
      c1.AutoSize:=true;
      c1.Caption:=rsAlwaysSaveWi;
      c1.Checked:=false;
      l1.Parent:=f1;
      c1.Parent:=f1;
      btn.Parent:=f1;
      l1.AdjustSize;
      c1.AdjustSize;
      btn.AdjustSize;
      l1.top:=8;
      l1.Left:=8;
      c1.Left:=8;
      c1.Top:=8+l1.Height+8;
      h:=l1.height+c1.Height+btn.Height+20;
      w:=f1.Canvas.TextWidth(l1.Caption)+16;
      f1.Width:=w;
      f1.Height:=h;
      mresult:=f1.ShowModal;
      ConfirmSaveConfig:=not c1.Checked;
      if mresult=mrOK then
         SaveDefault;
     finally
      btn.free;
      l1.Free;
      c1.Free;
      f1.Free;
     end;
     end else
       SaveDefault;
  end else begin
     if not NeedRestart then SaveQuickSearch(configfile);
  end;
  for i:=0 to MultiFrame1.ChildCount-1 do
     if MultiFrame1.Childs[i].DockedObject is Tf_chart then with (MultiFrame1.Childs[i].DockedObject as Tf_chart) do begin
        TelescopeTimer.Enabled:=false;
        locked:=true;
     end;
  except
  end;
end;
end;

procedure Tf_main.SaveConfigurationExecute(Sender: TObject);
begin
SaveDefault;
end;

procedure Tf_main.EditCopy1Execute(Sender: TObject);
var savelabel:boolean;
    bmp:TBitmap;
begin
if MultiFrame1.ActiveObject is Tf_chart then
 with Tf_chart(MultiFrame1.ActiveObject) do begin
    savelabel:= sc.cfgsc.Editlabels;
if VerboseMsg then
 WriteTrace('EditCopy1Execute');
    bmp:=TBitmap.Create;
    try
      if savelabel then begin
         sc.cfgsc.Editlabels:=false;
         sc.Refresh;
      end;
      bmp.Assign(sc.plot.cbmp);
      Clipboard.Assign(bmp);
    finally
      bmp.free;
      if savelabel then begin
         sc.cfgsc.Editlabels:=true;
         sc.Refresh;
      end;
    end;
 end;
end;

procedure Tf_main.Print1Execute(Sender: TObject);
begin
f_print.cm:=cfgm;
formpos(f_print,mouse.cursorpos.x,mouse.cursorpos.y);
f_print.showmodal;
if (f_print.ModalResult=mrOK)or(f_print.ModalResult=mrYes) then begin
 cfgm:=f_print.cm;
 if MultiFrame1.ActiveObject is Tf_chart then
   with MultiFrame1.ActiveObject as Tf_chart do
      PrintChart(cfgm.printlandscape,cfgm.printcolor,cfgm.PrintMethod,cfgm.PrinterResolution,cfgm.PrintCmd1,cfgm.PrintCmd2,cfgm.PrintTmpPath,cfgm,(f_print.ModalResult=mrYes));
end;
PrintPreview1.Visible:=(cfgm.PrintMethod=0);
end;

procedure Tf_main.PrintPreview1Click(Sender: TObject);
begin
if MultiFrame1.ActiveObject is Tf_chart then
  with MultiFrame1.ActiveObject as Tf_chart do
     PrintChart(cfgm.printlandscape,cfgm.printcolor,cfgm.PrintMethod,cfgm.PrinterResolution,cfgm.PrintCmd1,cfgm.PrintCmd2,cfgm.PrintTmpPath,cfgm,true);
end;

procedure Tf_main.UndoExecute(Sender: TObject);
begin
if MultiFrame1.ActiveObject is Tf_chart then with MultiFrame1.ActiveObject as Tf_chart do UndoExecute(Sender);
end;

procedure Tf_main.RedoExecute(Sender: TObject);
begin
if MultiFrame1.ActiveObject is Tf_chart then with MultiFrame1.ActiveObject as Tf_chart do RedoExecute(Sender);
end;

procedure Tf_main.zoomplusExecute(Sender: TObject);
begin
if MultiFrame1.ActiveObject is Tf_chart then with MultiFrame1.ActiveObject as Tf_chart do zoomplusExecute(Sender);
end;

procedure Tf_main.zoomminusExecute(Sender: TObject);
begin
if MultiFrame1.ActiveObject is Tf_chart then with MultiFrame1.ActiveObject as Tf_chart do zoomminusExecute(Sender);
end;


procedure Tf_main.ZoomBarExecute(Sender: TObject);
begin
if MultiFrame1.ActiveObject is Tf_chart then with MultiFrame1.ActiveObject as Tf_chart do begin
 formpos(f_zoom,mouse.cursorpos.x,mouse.cursorpos.y);
 f_zoom.fov:=rad2deg*sc.cfgsc.fov;
 f_zoom.showmodal;
 if f_zoom.modalresult=mrOK then begin
    sc.setfov(deg2rad*f_zoom.fov);
if VerboseMsg then
 WriteTrace('ZoomBarExecute');
    Refresh;
 end;

end;
end;

procedure Tf_main.FlipxExecute(Sender: TObject);
begin
if MultiFrame1.ActiveObject is Tf_chart then with MultiFrame1.ActiveObject as Tf_chart do FlipxExecute(Sender);
end;

procedure Tf_main.FlipyExecute(Sender: TObject);
begin
if MultiFrame1.ActiveObject is Tf_chart then with MultiFrame1.ActiveObject as Tf_chart do FlipyExecute(Sender);
end;

procedure Tf_main.rot_plusExecute(Sender: TObject);
begin
if MultiFrame1.ActiveObject is Tf_chart then with MultiFrame1.ActiveObject as Tf_chart do rot_plusExecute(Sender);
end;

procedure Tf_main.VariableStar1Click(Sender: TObject);
begin
  ExecNoWait(varobs);
end;

procedure Tf_main.View1Click(Sender: TObject);
begin
    ViewClock.Checked:=(f_clock<>nil)and(f_clock.Visible);
end;

procedure Tf_main.rot_minusExecute(Sender: TObject);
begin
if MultiFrame1.ActiveObject is Tf_chart then with MultiFrame1.ActiveObject as Tf_chart do rot_minusExecute(Sender);
end;

procedure Tf_main.ToolButtonRotPMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var rot:double;
begin
if Button=mbLeft then begin
  if ssCtrl in Shift then rot:=45
  else if ssShift in Shift then rot:=1
  else if ssMeta in Shift then rot:=180
  else rot:=15;
  if MultiFrame1.ActiveObject is Tf_chart then with MultiFrame1.ActiveObject as Tf_chart do rotation(rot);
end;
if Button=mbRight then begin
  if MultiFrame1.ActiveObject is Tf_chart then with MultiFrame1.ActiveObject as Tf_chart do begin
     sc.cfgsc.theta:=0;
     Refresh;
  end;
end;
end;

procedure Tf_main.ToolButtonRotMMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var rot:double;
begin
if Button=mbLeft then begin
  if ssCtrl in Shift then rot:=-45
  else if ssShift in Shift then rot:=-1
  else if ssMeta in Shift then rot:=-180
  else rot:=-15;
  if MultiFrame1.ActiveObject is Tf_chart then with MultiFrame1.ActiveObject as Tf_chart do  rotation(rot);
end;
if Button=mbRight then begin
  if MultiFrame1.ActiveObject is Tf_chart then with MultiFrame1.ActiveObject as Tf_chart do begin
     sc.cfgsc.theta:=0;
     Refresh;
  end;
end;
end;

procedure Tf_main.ToolButtonRot180MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var rot:double;
begin
if Button=mbLeft then begin
  rot:=180;
  if MultiFrame1.ActiveObject is Tf_chart then with MultiFrame1.ActiveObject as Tf_chart do rotation(rot);
end;
if Button=mbRight then begin
  if MultiFrame1.ActiveObject is Tf_chart then with MultiFrame1.ActiveObject as Tf_chart do begin
     sc.cfgsc.theta:=0;
     Refresh;
  end;
end;
end;

procedure Tf_main.TelescopeConnectExecute(Sender: TObject);
var P : Tpoint;
begin
P:=point(0,0);
if MultiFrame1.ActiveObject is Tf_chart then with MultiFrame1.ActiveObject as Tf_chart do begin
   Connect1Click(Sender);
   if sc.cfgsc.ManualTelescope then begin
     if f_manualtelescope.visible then
       f_manualtelescope.hide
     else begin
       formpos(f_manualtelescope,P.x,P.y);
       f_manualtelescope.SetTurn(sc.cfgsc.FindNote);
       f_manualtelescope.Show;
       f_main.Setfocus;
     end;
   end;
end;
end;

procedure Tf_main.TelescopeSlewExecute(Sender: TObject);
begin
if MultiFrame1.ActiveObject is Tf_chart then with MultiFrame1.ActiveObject as Tf_chart do Slew1Click(Sender);
end;

procedure Tf_main.TelescopeSyncExecute(Sender: TObject);
begin
if MultiFrame1.ActiveObject is Tf_chart then with MultiFrame1.ActiveObject as Tf_chart do Sync1Click(Sender);
end;

procedure Tf_main.TelescopePanelExecute(Sender: TObject);
begin
execnowait(cfgm.IndiPanelCmd);
end;

procedure Tf_main.ListObjExecute(Sender: TObject);
var buf,msg:string;
begin
if MultiFrame1.ActiveObject is Tf_chart then with MultiFrame1.ActiveObject as Tf_chart do begin
  if sc.cfgsc.windowratio=0 then sc.cfgsc.windowratio:=1;
  sc.Findlist(sc.cfgsc.racentre,sc.cfgsc.decentre,sc.cfgsc.fov/2,sc.cfgsc.fov/2/sc.cfgsc.windowratio,buf,msg,false,false,false);
  ListInfo(buf,msg);
end;
end;

procedure Tf_main.ListInfo(buf,msg:string);
begin
  f_info.source_chart:=MultiFrame1.ActiveChild.Caption;
  f_info.setpage(1);
  f_info.TitlePanel.Caption:=f_info.TitlePanel.Caption+':   '+msg;
  f_info.StringGrid2.Font.Name:=def_cfgplot.FontName[5];
  f_info.StringGrid2.Font.Size:=def_cfgplot.FontSize[5];
  f_info.setgrid(blank+wordspace(buf));
  f_info.show;
  f_info.BringToFront;
end;

procedure Tf_main.GridEQExecute(Sender: TObject);
begin
if MultiFrame1.ActiveObject is Tf_chart then with MultiFrame1.ActiveObject as Tf_chart do GridEQExecute(Sender);
end;

procedure Tf_main.GridExecute(Sender: TObject);
begin
if MultiFrame1.ActiveObject is Tf_chart then with MultiFrame1.ActiveObject as Tf_chart do GridExecute(Sender);
end;

procedure Tf_main.ToolButtonCompassClick(Sender: TObject);
begin
if MultiFrame1.ActiveObject is Tf_chart then with MultiFrame1.ActiveObject as Tf_chart do SwitchCompass(Sender);
end;

procedure Tf_main.switchstarsExecute(Sender: TObject);
begin
if MultiFrame1.ActiveObject is Tf_chart then with MultiFrame1.ActiveObject as Tf_chart do switchstarExecute(Sender);
end;

procedure Tf_main.switchbackgroundExecute(Sender: TObject);
begin
if MultiFrame1.ActiveObject is Tf_chart then with MultiFrame1.ActiveObject as Tf_chart do switchbackgroundExecute(Sender);
end;

procedure Tf_main.SetFOVClick(Sender: TObject);
var f : integer;
begin
with Sender as TSpeedButton do f:=tag;
if MultiFrame1.ActiveObject is Tf_chart then with MultiFrame1.ActiveObject as Tf_chart do begin
   SetField(deg2rad*sc.catalog.cfgshr.FieldNum[f]);
end;
end;

procedure Tf_main.SetFovExecute(Sender: TObject);
var f : integer;
begin
with Sender as TMenuItem do f:=tag;
if MultiFrame1.ActiveObject is Tf_chart then with MultiFrame1.ActiveObject as Tf_chart do begin
   SetField(deg2rad*sc.catalog.cfgshr.FieldNum[f]);
end;
end;

procedure Tf_main.toNExecute(Sender: TObject);
begin
if MultiFrame1.ActiveObject is Tf_chart then with MultiFrame1.ActiveObject as Tf_chart do SetAz(deg2rad*180);
end;

procedure Tf_main.toEExecute(Sender: TObject);
begin
if MultiFrame1.ActiveObject is Tf_chart then with MultiFrame1.ActiveObject as Tf_chart do SetAz(deg2rad*270);
end;

procedure Tf_main.toSExecute(Sender: TObject);
begin
if MultiFrame1.ActiveObject is Tf_chart then with MultiFrame1.ActiveObject as Tf_chart do SetAz(0);
end;

procedure Tf_main.toWExecute(Sender: TObject);
begin
if MultiFrame1.ActiveObject is Tf_chart then with MultiFrame1.ActiveObject as Tf_chart do SetAz(deg2rad*90);
end;

procedure Tf_main.toZenithExecute(Sender: TObject);
begin
if MultiFrame1.ActiveObject is Tf_chart then with MultiFrame1.ActiveObject as Tf_chart do SetZenit(0);
end;

procedure Tf_main.allSkyExecute(Sender: TObject);
begin
if MultiFrame1.ActiveObject is Tf_chart then with MultiFrame1.ActiveObject as Tf_chart do SetZenit(deg2rad*200);
end;


procedure Tf_main.MoreStarExecute(Sender: TObject);
begin
if MultiFrame1.ActiveObject is Tf_chart then with MultiFrame1.ActiveObject as Tf_chart do cmd_MoreStar;
end;

procedure Tf_main.LessStarExecute(Sender: TObject);
begin
if MultiFrame1.ActiveObject is Tf_chart then with MultiFrame1.ActiveObject as Tf_chart do cmd_LessStar;
end;

procedure Tf_main.MoreNebExecute(Sender: TObject);
begin
if MultiFrame1.ActiveObject is Tf_chart then with MultiFrame1.ActiveObject as Tf_chart do cmd_MoreNeb;
end;

procedure Tf_main.LessNebExecute(Sender: TObject);
begin
if MultiFrame1.ActiveObject is Tf_chart then with MultiFrame1.ActiveObject as Tf_chart do cmd_LessNeb;
end;

procedure Tf_main.ToolButton13Click(Sender: TObject);
var fs : TSearchRec;
    i,rc: integer;
    r: TStringList;
    fn,cmd,logfile: string;
begin
AnimationTimer.Enabled:=ToolButton13.Down;
if ToolButton13.Down then begin  // start animation
   if (cfgm.AnimSx>0)and(cfgm.AnimSy>0) then begin
     r:=TStringList.Create;
     cmd:='RESIZE '+inttostr(cfgm.AnimSx)+' '+inttostr(cfgm.AnimSy);
     splitarg(cmd,blank,r);
     for i:=r.count to MaxCmdArg do r.add('');
     ExecuteCmd('',r);
     r.free;
   end;
   Animcount:=0;
   if cfgm.AnimRec then begin
      i:=findfirst(slash(TempDir)+'*.jpg',0,fs);
      while i=0 do begin
        DeleteFile(slash(TempDir)+fs.name);
        i:=findnext(fs);
      end;
      findclose(fs);
   end;
end else begin                   // end animation
   if cfgm.AnimRec then begin
      r:=TStringList.Create;
      i:=0;
      repeat
        inc(i);
        fn:=slash(cfgm.AnimRecDir)+cfgm.AnimRecPrefix+inttostr(i)+cfgm.AnimRecExt;
      until (not FileExists(fn))or(i>1000);
      cmd:=cfgm.Animffmpeg+' -r '+formatfloat(f1,cfgm.AnimFps)+' '+cfgm.AnimOpt+' -i "'+slash(TempDir)+'%06d.jpg" "'+utf8tosys(fn)+'"';
      rc:=ExecProcess(cmd,r,true);
      logfile:=slash(TempDir)+'ffmpeg.log';
      r.SaveToFile(logfile);
      r.free;
      if (rc<>0)and(fileexists(logfile)) then begin
         f_info.setpage(3);
         f_info.TitlePanel.Caption:='ffmpeg command failed';
         f_info.Button1.caption:=rsClose;
         f_info.InfoMemo.Lines.LoadFromFile(logfile);
         f_info.InfoMemo.Text:=CondUTF8Decode(f_info.InfoMemo.Text);
         f_info.showmodal;
      end;
   end;
end;
end;

procedure Tf_main.ToolButton13MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if Button=mbRight then SetupTimePage(2);
end;


procedure Tf_main.ToolButtonScaleClick(Sender: TObject);
begin
  if MultiFrame1.ActiveObject is Tf_chart then with MultiFrame1.ActiveObject as Tf_chart do begin
     sc.cfgsc.ShowScale:=ToolButtonScale.Down;
     if MeasureOn then MeasureDistance(4,0,0);
     Refresh;
  end;
end;

procedure Tf_main.AnimationTimerTimer(Sender: TObject);
var fn:string;
begin
  AnimationTimer.Enabled:=false;
  TimeInc.Execute;
  if cfgm.AnimRec then begin
    if MultiFrame1.ActiveObject  is Tf_chart then
     with MultiFrame1.ActiveObject as Tf_chart do begin
         inc(Animcount);
         fn:=Slash(systoutf8(TempDir))+FormatFloat('000000',Animcount)+'.jpg';
         SaveChartImage('JPEG',fn,80);
      end;
  end;
  AnimationTimer.Enabled:=true;
end;

procedure Tf_main.TimeIncExecute(Sender: TObject);
var hh : double;
    y,m,d,h,n,s,mult : integer;
begin
// tag is used for the sign
mult:=TAction(sender).tag*TimeVal.Position;
if MultiFrame1.ActiveObject is Tf_chart then with MultiFrame1.ActiveObject as Tf_chart do begin
   djd(sc.cfgsc.CurJDUT,y,m,d,hh);
   DtoS(hh,h,n,s);
   case TimeU.itemindex of
   0 : begin
       SetJD(sc.cfgsc.CurJDUT+mult/24);
       end;
   1 : begin
       SetJD(sc.cfgsc.CurJDUT+mult/1440);
       end;
   2 : begin
       SetJD(sc.cfgsc.CurJDUT+mult/86400);
       end;
   3 : begin
       SetJD(sc.cfgsc.CurJDUT+mult);
       end;
   4 : begin
       inc(m,mult);
       SetDateUT(y,m,d,h,n,s);
       end;
   5 : begin
       inc(y,mult);
       SetDateUT(y,m,d,h,n,s);
       end;
   6 : SetJD(sc.cfgsc.CurJDUT+mult*365.25);      // julian year
   7 : SetJD(sc.cfgsc.CurJDUT+mult*365.2421988); // tropical year
   8 : SetJD(sc.cfgsc.CurJDUT+mult*0.99726956633); // sideral day
   9 : SetJD(sc.cfgsc.CurJDUT+mult*29.530589);   // synodic month
   10: SetJD(sc.cfgsc.CurJDUT+mult*6585.321);    // saros
   end;
end;
end;

procedure Tf_main.TimeResetExecute(Sender: TObject);
begin
if MultiFrame1.ActiveObject is Tf_chart then with MultiFrame1.ActiveObject as Tf_chart do begin
   sc.cfgsc.UseSystemTime:=true;
   if (not sc.cfgsc.TrackOn)and(sc.cfgsc.Projpole=Altaz) then begin
      sc.cfgsc.TrackOn:=true;
      sc.cfgsc.TrackType:=4;
   end;
if VerboseMsg then
 WriteTrace('TimeResetExecute');
   Refresh;
end;
end;


procedure Tf_main.ShowStarsExecute(Sender: TObject);
begin
if MultiFrame1.ActiveObject is Tf_chart then with MultiFrame1.ActiveObject as Tf_chart do begin
   sc.cfgsc.showstars:=not sc.cfgsc.showstars;
if VerboseMsg then
 WriteTrace('ShowStarsExecute');
   Refresh;
end;
end;

procedure Tf_main.ShowNebulaeExecute(Sender: TObject);
begin
if MultiFrame1.ActiveObject is Tf_chart then with MultiFrame1.ActiveObject as Tf_chart do begin
   sc.cfgsc.shownebulae:=not sc.cfgsc.shownebulae;
if VerboseMsg then
 WriteTrace('ShowNebulaeExecute');
   Refresh;
end;
end;

procedure Tf_main.ShowPicturesExecute(Sender: TObject);
begin
if MultiFrame1.ActiveObject is Tf_chart then with MultiFrame1.ActiveObject as Tf_chart do begin
   sc.cfgsc.ShowImages:=not sc.cfgsc.ShowImages;
   if sc.cfgsc.ShowImages then begin
     sc.catalog.cfgcat.nebcatdef[sac-BaseNeb]:=true;
     sc.catalog.cfgcat.nebcatfield[sac-BaseNeb,2]:=10;
   end;
   if sc.cfgsc.ShowImages and (not Fits.dbconnected) then begin
      sc.cfgsc.ShowImages:=false;
      ShowError(rsErrorPleaseC3);
   end;
if VerboseMsg then
 WriteTrace('ShowPicturesExecute');
   Refresh;
end;
end;

procedure Tf_main.ShowBackgroundImageExecute(Sender: TObject);
begin
if MultiFrame1.ActiveObject is Tf_chart then with MultiFrame1.ActiveObject as Tf_chart do begin
   sc.cfgsc.ShowBackgroundImage:=not sc.cfgsc.ShowBackgroundImage;
   if sc.cfgsc.ShowBackgroundImage and (not Fits.Header.valid) then begin
      sc.cfgsc.ShowBackgroundImage:=false;
   end;
   if sc.cfgsc.ShowBackgroundImage and (not Fits.dbconnected) then begin
      sc.cfgsc.ShowBackgroundImage:=false;
      ShowError(rsErrorPleaseC);
   end;
if VerboseMsg then
 WriteTrace('ShowBackgroundImageExecute');
   Refresh;
end;
end;

procedure Tf_main.DSSImageExecute(Sender: TObject);
begin
if (MultiFrame1.ActiveObject is Tf_chart) and (Fits.dbconnected)
  then with MultiFrame1.ActiveObject as Tf_chart do begin
      if VerboseMsg then
       WriteTrace('DSSImageExecute');
      cmd_PDSS('','','','');
  end;
end;

procedure Tf_main.BlinkImageExecute(Sender: TObject);
begin
if (MultiFrame1.ActiveObject is Tf_chart)
  then with MultiFrame1.ActiveObject as Tf_chart do begin
     if BlinkTimer.enabled then begin
        BlinkTimer.enabled:=false;
        sc.cfgsc.ShowBackgroundImage:=true;
if VerboseMsg then
 WriteTrace('BlinkImageExecute');
        Refresh;
     end else begin
        if sc.cfgsc.ShowBackgroundImage then
           BlinkTimer.enabled:=true
        else begin
           BlinkTimer.enabled:=false;
           ToolButtonBlink.Down:=false;
        end;
     end;
  end;
end;

procedure Tf_main.SyncChartExecute(Sender: TObject);
begin
if MultiFrame1.ActiveObject is Tf_chart then begin
   cfgm.SyncChart:=not cfgm.SyncChart;
   if cfgm.SyncChart then SyncChild;
end;
end;

procedure Tf_main.ShowLinesExecute(Sender: TObject);
begin
if MultiFrame1.ActiveObject is Tf_chart then with MultiFrame1.ActiveObject as Tf_chart do begin
   sc.cfgsc.ShowLine:=not sc.cfgsc.ShowLine;
if VerboseMsg then
 WriteTrace('ShowLinesExecute');
   Refresh;
end;
end;

procedure Tf_main.ShowPlanetsExecute(Sender: TObject);
begin
if MultiFrame1.ActiveObject is Tf_chart then with MultiFrame1.ActiveObject as Tf_chart do begin
   sc.cfgsc.ShowPlanet:=not sc.cfgsc.ShowPlanet;
if VerboseMsg then
 WriteTrace('ShowPlanetsExecute');
   Refresh;
end;
end;

procedure Tf_main.ShowAsteroidsExecute(Sender: TObject);
var showast:boolean;
begin
if MultiFrame1.ActiveObject is Tf_chart then with MultiFrame1.ActiveObject as Tf_chart do begin
   sc.cfgsc.ShowAsteroid:=not sc.cfgsc.ShowAsteroid;
   showast:=sc.cfgsc.ShowAsteroid;
if VerboseMsg then
 WriteTrace('ShowAsteroidsExecute');
   Refresh;
   if showast<>sc.cfgsc.ShowAsteroid then begin
      f_info.setpage(2);
      f_info.show;
      f_info.ProgressMemo.lines.add(rsComputeAster);
      if Planet.PrepareAsteroid(sc.cfgsc.curjdtt, f_info.ProgressMemo.lines) then begin
         sc.cfgsc.ShowAsteroid:=true;
         Refresh;
      end;
      f_info.hide;
   end;
end;
end;

procedure Tf_main.ShowCometsExecute(Sender: TObject);
var showcom:boolean;
begin
if MultiFrame1.ActiveObject is Tf_chart then with MultiFrame1.ActiveObject as Tf_chart do begin
   sc.cfgsc.ShowComet:=not sc.cfgsc.ShowComet;
   showcom:=sc.cfgsc.ShowComet;
if VerboseMsg then
 WriteTrace('ShowCometsExecute');
   Refresh;
   if showcom<>sc.cfgsc.ShowComet then ShowError(rsErrorPleaseC2);
end;
end;

procedure Tf_main.ShowMilkyWayExecute(Sender: TObject);
begin
if MultiFrame1.ActiveObject is Tf_chart then with MultiFrame1.ActiveObject as Tf_chart do begin
   sc.cfgsc.ShowMilkyWay:=not sc.cfgsc.ShowMilkyWay;
 if VerboseMsg then
 WriteTrace('ShowMilkyWayExecute');
  Refresh;
end;
end;

procedure Tf_main.ShowLabelsExecute(Sender: TObject);
begin
if MultiFrame1.ActiveObject is Tf_chart then with MultiFrame1.ActiveObject as Tf_chart do begin
   sc.cfgsc.Showlabelall:=not sc.cfgsc.Showlabelall;
if VerboseMsg then
 WriteTrace('ShowLabelsExecute');
   Refresh;
end;
end;

procedure Tf_main.ResetAllLabels1Click(Sender: TObject);
begin
if MultiFrame1.ActiveObject is Tf_chart then
      Tf_chart(MultiFrame1.ActiveObject).sc.ResetAllLabel;
end;

procedure Tf_main.ResetDefaultChartExecute(Sender: TObject);
var i,w,h: integer;
    f1: TForm;
    r1: TRadioGroup;
    btn: TButtonPanel;
begin
if VerboseMsg then
 WriteTrace('ResetDefaultChartExecute');
if sender<>nil then begin
  f1:=TForm.Create(self);
  f1.AutoSize:=false;
  f1.Caption:=rsResetChartAn;
  r1:=TRadioGroup.Create(f1);
  r1.AutoSize:=true;
  r1.top:=8;
  r1.Left:=8;
  btn:= TButtonPanel.Create(f1);
  btn.ShowButtons:=[pbOK,pbCancel];
  btn.OKButton.Caption:=rsOK;
  btn.CancelButton.Caption:=rsCancel;
  btn.ShowGlyphs:=[];
  btn.AutoSize:=true;
  btn.Align:=alBottom;
  r1.Items.Add(rsResetInitial);
  r1.Items.Add(rsResetToLastT);
  r1.ItemIndex:=1;
  r1.Parent:=f1;
  btn.Parent:=f1;
  r1.AdjustSize;
  btn.AdjustSize;
  h:=r1.Height+btn.Height+16;
  w:=max(f1.Canvas.TextWidth(rsResetInitial),f1.Canvas.TextWidth(rsResetToLastT))+80;
  f1.Height:=h;
  f1.Width:=w;
  try
  FormPos(f1,mouse.cursorpos.x,mouse.cursorpos.y);
  if f1.ShowModal=mrOK then begin
    case r1.ItemIndex of
      0: begin
          WriteTrace('Reload default configuration');
          ClearAndRestart;
         end;
      1: begin
          WriteTrace('Reload last configuration');
          for i:=1 to MultiFrame1.ChildCount-1 do
            if MultiFrame1.Childs[i].DockedObject is Tf_chart then
               MultiFrame1.Childs[i].close;
          MultiFrame1.Maximized:=true;
          with MultiFrame1.ActiveObject as Tf_chart do begin
            ReadChartConfig(configfile,true,true,sc.plot.cfgplot,sc.cfgsc);
            Refresh;
          end;
         end;
    end;
  end;
  finally
   btn.Free;
   r1.Free;
   f1.Free;
  end;
end else begin
  WriteTrace('Reload last configuration');
  for i:=1 to MultiFrame1.ChildCount-1 do
    if MultiFrame1.Childs[i].DockedObject is Tf_chart then
       MultiFrame1.Childs[i].close;
  MultiFrame1.Maximized:=true;
  with MultiFrame1.ActiveObject as Tf_chart do begin
    ReadChartConfig(configfile,true,true,sc.plot.cfgplot,sc.cfgsc);
    Refresh;
  end;
end;
end;

procedure Tf_main.EditLabelsExecute(Sender: TObject);
begin
if MultiFrame1.ActiveObject is Tf_chart then with MultiFrame1.ActiveObject as Tf_chart do begin
   sc.cfgsc.Editlabels:=not sc.cfgsc.Editlabels;
if VerboseMsg then
 WriteTrace('EditLabelsExecute');
   Refresh;
end;
end;

procedure Tf_main.ShowConstellationLineExecute(Sender: TObject);
begin
if MultiFrame1.ActiveObject is Tf_chart then with MultiFrame1.ActiveObject as Tf_chart do begin
   sc.cfgsc.ShowConstl:=not sc.cfgsc.ShowConstl;
if VerboseMsg then
 WriteTrace('ShowConstellationLineExecute');
   Refresh;
end;
end;

procedure Tf_main.ShowConstellationLimitExecute(Sender: TObject);
begin
if MultiFrame1.ActiveObject is Tf_chart then with MultiFrame1.ActiveObject as Tf_chart do begin
   sc.cfgsc.ShowConstB:=not sc.cfgsc.ShowConstB;
if VerboseMsg then
 WriteTrace('ShowConstellationLimitExecute');
   Refresh;
end;
end;

procedure Tf_main.ShowGalacticEquatorExecute(Sender: TObject);
begin
if MultiFrame1.ActiveObject is Tf_chart then with MultiFrame1.ActiveObject as Tf_chart do begin
   sc.cfgsc.ShowGalactic:=not sc.cfgsc.ShowGalactic;
if VerboseMsg then
 WriteTrace('ShowGalacticEquatorExecute');
   Refresh;
end;
end;

procedure Tf_main.ShowEclipticExecute(Sender: TObject);
begin
if MultiFrame1.ActiveObject is Tf_chart then with MultiFrame1.ActiveObject as Tf_chart do begin
   sc.cfgsc.ShowEcliptic:=not sc.cfgsc.ShowEcliptic;
if VerboseMsg then
 WriteTrace('ShowEclipticExecute');
   Refresh;
end;
end;

procedure Tf_main.ShowMarkExecute(Sender: TObject);
begin
if MultiFrame1.ActiveObject is Tf_chart then with MultiFrame1.ActiveObject as Tf_chart do begin
   sc.cfgsc.ShowCircle:=not sc.cfgsc.ShowCircle;
if VerboseMsg then
 WriteTrace('ShowMarkExecute');
   Refresh;
end;
end;

procedure Tf_main.ShowObjectbelowHorizonExecute(Sender: TObject);
begin
if MultiFrame1.ActiveObject is Tf_chart then with MultiFrame1.ActiveObject as Tf_chart do begin
   sc.cfgsc.horizonopaque:=not sc.cfgsc.horizonopaque;
if VerboseMsg then
 WriteTrace('ShowObjectbelowHorizonExecute');
   Refresh;
end;
end;

procedure Tf_main.EquatorialProjectionExecute(Sender: TObject);
begin
if MultiFrame1.ActiveObject is Tf_chart then with MultiFrame1.ActiveObject as Tf_chart do begin
   sc.cfgsc.projpole:=Equat;
   sc.cfgsc.FindOk:=false; // invalidate the search result
   sc.cfgsc.theta:=0; // rotation = 0
if VerboseMsg then
 WriteTrace('EquatorialProjectionExecute');
   Refresh;
end;
end;

procedure Tf_main.AltAzProjectionExecute(Sender: TObject);
begin
if MultiFrame1.ActiveObject is Tf_chart then with MultiFrame1.ActiveObject as Tf_chart do begin
   sc.cfgsc.projpole:=AltAz;
   sc.cfgsc.FindOk:=false; // invalidate the search result
   sc.cfgsc.theta:=0; // rotation = 0
   if sc.catalog.cfgshr.EquinoxType<>2 then begin // ensure equinox of the date
     sc.catalog.cfgshr.EquinoxType:=2;
     sc.catalog.cfgshr.EquinoxChart:=rsDate;
     sc.catalog.cfgshr.DefaultJDChart:=jd2000;
     sc.cfgsc.CoordExpertMode:=false;
     sc.cfgsc.ApparentPos:=true;
     sc.cfgsc.PMon:=true;
     sc.cfgsc.YPmon:=0;
     sc.cfgsc.CoordType:=0;
   end;
if VerboseMsg then
 WriteTrace('AltAzProjectionExecute');
   Refresh;
end;
end;

procedure Tf_main.EclipticProjectionExecute(Sender: TObject);
begin
if MultiFrame1.ActiveObject is Tf_chart then with MultiFrame1.ActiveObject as Tf_chart do begin
   sc.cfgsc.projpole:=Ecl;
   sc.cfgsc.FindOk:=false; // invalidate the search result
   sc.cfgsc.theta:=0; // rotation = 0
if VerboseMsg then
 WriteTrace('EclipticProjectionExecute');
   Refresh;
end;
end;

procedure Tf_main.GalacticProjectionExecute(Sender: TObject);
begin
if MultiFrame1.ActiveObject is Tf_chart then with MultiFrame1.ActiveObject as Tf_chart do begin
   sc.cfgsc.projpole:=Gal;
   sc.cfgsc.FindOk:=false; // invalidate the search result
   sc.cfgsc.theta:=0; // rotation = 0
if VerboseMsg then
 WriteTrace('GalacticProjectionExecute');
   Refresh;
end;
end;

procedure Tf_main.CalendarExecute(Sender: TObject);
begin
  if not f_calendar.Visible then begin
    if MultiFrame1.ActiveObject is Tf_chart then f_calendar.config.Assign(Tf_chart(MultiFrame1.ActiveObject).sc.cfgsc)
       else f_calendar.config.Assign(def_cfgsc);
  end;
  f_calendar.AzNorth:=catalog.cfgshr.AzNorth;
  formpos(f_calendar,mouse.cursorpos.x,mouse.cursorpos.y);
  f_calendar.show;
  f_calendar.bringtofront;
end;

procedure Tf_main.TrackExecute(Sender: TObject);
begin
if MultiFrame1.ActiveObject is Tf_chart then with (MultiFrame1.ActiveObject as Tf_chart) do begin
  if sc.cfgsc.TrackOn then begin
     if VerboseMsg then
      WriteTrace('TrackExecute 1');
     sc.cfgsc.TrackOn:=false;
     Refresh;
  end else if (((sc.cfgsc.TrackType>=1)and(sc.cfgsc.TrackType<=3)) or(sc.cfgsc.TrackType=6))and(sc.cfgsc.TrackName<>'')
  then begin
     if VerboseMsg then
      WriteTrace('TrackExecute 2');
     sc.cfgsc.TrackOn:=true;
     Refresh;
  end else begin
    sc.cfgsc.TrackOn:=false;
    UpdateBtn(sc.cfgsc.flipx,sc.cfgsc.flipy,Connect1.checked,MultiFrame1.ActiveObject);
  end;
end;
end;

procedure Tf_main.TrackTelescope1Click(Sender: TObject);
begin
if MultiFrame1.ActiveObject is Tf_chart then with (MultiFrame1.ActiveObject as Tf_chart) do begin
  TrackTelescopeClick(Sender);
end;
end;

procedure Tf_main.PositionExecute(Sender: TObject);
begin
if MultiFrame1.ActiveObject is Tf_chart then with MultiFrame1.ActiveObject as Tf_chart do begin
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
if VerboseMsg then
 WriteTrace('PositionExecute');
      refresh;
   end;
end;
end;

procedure Tf_main.Search1Execute(Sender: TObject);
var ok: string;
begin
if cfgm.HttpProxy then begin
   f_search.SocksProxy:='';
   f_search.SocksType:='';
   f_search.HttpProxy:=cfgm.ProxyHost;
   f_search.HttpProxyPort:=cfgm.ProxyPort;
   f_search.HttpProxyUser:=cfgm.ProxyUser;
   f_search.HttpProxyPass:=cfgm.ProxyPass;
end else if cfgm.SocksProxy then begin
   f_search.HttpProxy:='';
   f_search.SocksType:=cfgm.SocksType;
   f_search.SocksProxy:=cfgm.ProxyHost;
   f_search.HttpProxyPort:=cfgm.ProxyPort;
   f_search.HttpProxyUser:=cfgm.ProxyUser;
   f_search.HttpProxyPass:=cfgm.ProxyPass;
end else begin
   f_search.SocksProxy:='';
   f_search.SocksType:='';
   f_search.HttpProxy:='';
   f_search.HttpProxyPort:='';
   f_search.HttpProxyUser:='';
   f_search.HttpProxyPass:='';
end;
 formpos(f_search,mouse.cursorpos.x,mouse.cursorpos.y);
 repeat
   f_search.showmodal;
   if f_search.modalresult=mrOk then begin
        ok:=Find(f_search.SearchKind,f_search.Num,f_search.ra,f_search.de);
        if ok<>msgOK then
          ShowError(Format(rsNotFoundMayb, [f_search.Num, crlf]) );
   end;
 until (ok=msgOK) or (f_search.ModalResult<>mrOk);
end;

function Tf_main.Find(kind:integer; num:string; def_ra:double=0;def_de:double=0): string;
var ok: Boolean;
    ar1,de1,saveChartJD,dyear : Double;
    i, itype : integer;
    chart:TFrame;
    saveCurYear,saveCurMonth,saveCurDay:integer;
    lastra,lastdec,lasttrra,lasttrde,lastxx,lastyy,lastzz: double;
    lasttype,lastobj: integer;
    lastname,lasttrname: string;
    lastok: boolean;
begin
result:=msgFailed;
chart:=nil; ok:=false;
if MultiFrame1.ActiveObject is Tf_chart then chart:=MultiFrame1.ActiveObject
 else
 for i:=0 to MultiFrame1.ChildCount-1 do
   if MultiFrame1.Childs[i].DockedObject is Tf_chart then begin
      chart:=MultiFrame1.Childs[i].DockedObject;
      break;
   end;
itype:=ftInv;
if chart is Tf_chart then with chart as Tf_chart do begin
    lastok:=sc.cfgsc.FindOK;
    lastra:=sc.cfgsc.FindRA;
    lastdec:=sc.cfgsc.FindDEC;
    lastname:=sc.cfgsc.FindName;
    lasttrra:=sc.cfgsc.TrackRA;
    lasttrde:=sc.cfgsc.TrackDEC;
    lasttype:=sc.cfgsc.TrackType;
    lastobj:=sc.cfgsc.Trackobj;
    lasttrname:=sc.cfgsc.TrackName;
    lastXX:=sc.cfgsc.FindX;
    lastYY:=sc.cfgsc.FindY;
    lastZZ:=sc.cfgsc.FindZ;
    case kind of
      0  : begin ok:=catalog.SearchNebulae(num,ar1,de1) ; itype:=ftNeb  ; end;
      1  : begin
           ar1:=def_ra;
           de1:=def_de;
           itype:=ftNeb ;
           ok:=true;
           end;
      2  : begin ok:=catalog.SearchStar(num,ar1,de1) ; itype:=ftStar  ; end;
      3  : begin ok:=catalog.SearchStar(num,ar1,de1) ; itype:=ftStar  ; end;
      4  : begin ok:=catalog.SearchVarStar(num,ar1,de1) ; itype:=ftVar  ; end;
      5  : begin ok:=catalog.SearchDblStar(num,ar1,de1) ; itype:=ftDbl  ; end;
      6  : begin ok:=planet.FindCometName(trim(num),ar1,de1,sc.cfgsc); itype:=ftCom  ; end;
      7  : begin ok:=planet.FindAsteroidName(trim(num),ar1,de1,sc.cfgsc); itype:=ftAst  ; end;
      8  : begin ok:=planet.FindPlanetName(trim(num),ar1,de1,sc.cfgsc); itype:=ftPla  ; end;
      9  : begin ok:=catalog.SearchConstellation(num,ar1,de1); itype:=ftlin  ; end;
      10 : begin
            ar1:=def_ra;
            de1:=def_de;
            itype:=ftOnline ;
            ok:=true;
           end;
      11 : begin ok:=catalog.SearchConstAbrev(num,ar1,de1); itype:=ftlin  ; end;
      else ok:=false;
      end;
      if ok then begin
        sc.cfgsc.TrackOn:=false;
        IdentLabel.visible:=false;
        saveChartJD:=sc.cfgsc.JDChart;
        saveCurYear:=sc.cfgsc.CurYear;
        saveCurMonth:=sc.cfgsc.CurMonth;
        saveCurDay:=sc.cfgsc.CurDay;
        sc.cfgsc.JDChart:=jd2000;
        sc.cfgsc.CurYear:=2000;
        sc.cfgsc.CurMonth:=1;
        sc.cfgsc.CurDay:=1;
if VerboseMsg then
 WriteTrace('Search1Execute');
        if itype=ftlin then begin
            sc.cfgsc.FindCatname:='';
            sc.cfgsc.FindCat:='';
            sc.cfgsc.FindName:=Num;
            sc.cfgsc.FindDesc:='';
            sc.cfgsc.FindRA:=ar1;
            sc.cfgsc.FindDec:=de1;
            sc.cfgsc.FindSize:=0;
            sc.cfgsc.FindPM:=false;
            sc.cfgsc.FindStarPM:=false;
            sc.cfgsc.FindOK:=true;
            sc.cfgsc.FindType:=itype;
            sc.cfgsc.TrackOn:=False;
            sc.cfgsc.TrackType:=0;
        end else if itype=ftOnline then begin
            sc.cfgsc.FindCatname:='';
            sc.cfgsc.FindCat:=f_search.sesame_resolver;
            sc.cfgsc.FindName:=f_search.sesame_name;
            sc.cfgsc.FindDesc:=ARpToStr(rmod(rad2deg*ar1/15+24, 24))+tab+DEpToStr(rad2deg*de1)+tab+'OSR'+tab+f_search.sesame_name+tab+f_search.sesame_desc;
            sc.cfgsc.FindRA:=ar1;
            sc.cfgsc.FindDec:=de1;
            sc.cfgsc.FindSize:=0;
            sc.cfgsc.FindPM:=false;
            sc.cfgsc.FindStarPM:=false;
            sc.cfgsc.FindOK:=true;
            sc.cfgsc.FindType:=itype;
            sc.cfgsc.TrackOn:=False;
            sc.cfgsc.TrackType:=0;
        end else begin
          ok:=sc.FindatRaDec(ar1,de1,0.00005,true,true,itype);               // search 10 sec radius
          if (not ok)or(sc.cfgsc.FindType<>itype) then ok:=sc.FindatRaDec(ar1,de1,0.0005,true,true,itype); // if not search 1.7 min
          if (not ok)or(sc.cfgsc.FindType<>itype) then ok:=sc.FindatRaDec(ar1,de1,0.001,true,true,itype);  // big idx position error, search 3.5 min
          if (not ok)or(sc.cfgsc.FindType<>itype) then ok:=sc.FindatRaDec(ar1,de1,0.003,true,true,itype);  // big idx position error, search 10 min
          if (not ok)or(sc.cfgsc.FindType<>itype) then ok:=sc.FindatRaDec(ar1,de1,0.006,true,true,itype);  // big idx position error, search 20 min
          if (not ok)or(sc.cfgsc.FindType<>itype) then begin  // object in index but not in any active catalog
            sc.cfgsc.FindName:=Num;
            sc.cfgsc.FindDesc:=ARpToStr(rmod(rad2deg*ar1/15+24, 24))+tab+DEpToStr(rad2deg*de1)+tab+blank+tab+Num+tab+''+rsObjectPositi+'';
            sc.cfgsc.FindRA:=ar1;
            sc.cfgsc.FindDec:=de1;
            sc.cfgsc.FindSize:=0;
            sc.cfgsc.FindPM:=false;
            sc.cfgsc.FindStarPM:=false;
            sc.cfgsc.FindOK:=true;
            sc.cfgsc.FindType:=itype;
            sc.cfgsc.TrackOn:=true;
            sc.cfgsc.TrackType:=6;
            sc.cfgsc.TrackRA:=ar1;
            sc.cfgsc.TrackDec:=de1;
            sc.cfgsc.TrackName:=Num;
          end;
        end;
        sc.cfgsc.JDChart := saveChartJD;
        sc.cfgsc.CurYear  := saveCurYear;
        sc.cfgsc.CurMonth := saveCurMonth;
        sc.cfgsc.CurDay   := saveCurDay;
        if sc.cfgsc.FindStarPM then begin
          dyear:=(sc.cfgsc.CurYear+DayofYear(sc.cfgsc.CurYear,sc.cfgsc.CurMonth,sc.cfgsc.CurDay)/365.25)-sc.cfgsc.FindPMEpoch;
          propermotion(sc.cfgsc.FindRA,sc.cfgsc.FindDec,dyear,sc.cfgsc.FindPMra,sc.cfgsc.FindPMde,sc.cfgsc.FindPMfullmotion,sc.cfgsc.FindPMpx,sc.cfgsc.FindPMrv);
        end;
        precession(jd2000,sc.cfgsc.JDchart,sc.cfgsc.FindRA,sc.cfgsc.FindDec);
        if sc.cfgsc.ApparentPos then apparent_equatorial(sc.cfgsc.FindRA,sc.cfgsc.FindDec,sc.cfgsc,true,itype<ftPla);
        sc.cfgsc.TrackRA:=sc.cfgsc.FindRA;
        sc.cfgsc.TrackDec:=sc.cfgsc.FindDec;
        sc.movetoradec(sc.cfgsc.FindRA,sc.cfgsc.FindDec);
        Refresh;
        sc.cfgsc.FindOK    := lastok;
        sc.cfgsc.FindRA    := lastra;
        sc.cfgsc.FindDEC   := lastdec;
        sc.cfgsc.FindName  := lastname;
        sc.cfgsc.TrackRA   := lasttrra;
        sc.cfgsc.TrackDEC  := lasttrde;
        sc.cfgsc.TrackType := lasttype;
        sc.cfgsc.Trackobj  := lastobj;
        sc.cfgsc.TrackName := lasttrname;
        sc.cfgsc.FindX     := lastXX;
        sc.cfgsc.FindY     := lastYY;
        sc.cfgsc.FindZ     := lastZZ;
        IdentXY(sc.cfgsc.Xcentre,sc.cfgsc.Ycentre,false,true,itype);
        if kind in [0,2,3,4,5,6,7,8] then begin
          i:=quicksearch.Items.IndexOf(num);
          if (i<0)and(quicksearch.Items.Count>=MaxQuickSearch) then i:=MaxQuickSearch-1;
          if i>=0 then quicksearch.Items.Delete(i);
          quicksearch.Items.Insert(0,num);
          quicksearch.ItemIndex:=0;
        end;
        result:=msgOK;
      end
      else begin
        result:=msgNotFound;
      end;
   end;
end;

procedure Tf_main.GetChartConfig(csc:Tconf_skychart);
begin
if MultiFrame1.ActiveObject is Tf_chart then
 with MultiFrame1.ActiveObject as Tf_chart do
   csc.Assign(sc.cfgsc)
else
   csc.Assign(def_cfgsc);
end;

procedure Tf_main.DrawChart(csc:Tconf_skychart);
begin
if MultiFrame1.ActiveObject is Tf_chart then
 with MultiFrame1.ActiveObject as Tf_chart do begin
   sc.cfgsc.Assign(csc);
if VerboseMsg then
 WriteTrace('DrawChart');
   Refresh;
end;
end;

procedure Tf_main.ReleaseNotes1Click(Sender: TObject);
begin
  ShowReleaseNotes(false);
end;

procedure Tf_main.ReloadLanguage1Click(Sender: TObject);
begin
ChangeLanguage(cfgm.language);
end;

procedure Tf_main.SetupTimeExecute(Sender: TObject);
begin
SetupTimePage(0);
end;


procedure Tf_main.ToolButtonConfigClick(Sender: TObject);
begin
  ToolButtonConfig.PopupMenu.PopUp(mouse.cursorpos.x,mouse.cursorpos.y);
end;

procedure Tf_main.ToolButtonDSSMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if Button=mbRight then SetupPicturesPage(2);
end;

procedure Tf_main.ToolButtonListObjMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if Button=mbRight then SetupChartPage(5);
end;

procedure Tf_main.SetupTimePage(page:integer);
begin
if ConfigTime=nil then begin
   ConfigTime:=Tf_configtime.Create(self);
   ConfigTime.f_config_time1.PageControl1.ShowTabs:=true;
   ConfigTime.f_config_time1.PageControl1.PageIndex:=0;
   ConfigTime.f_config_time1.onApplyConfig:=ApplyConfigTime;
   ConfigTime.f_config_time1.onGetTwilight:=GetTwilight;
end;
{$ifdef mswindows}SetFormNightVision(ConfigTime,nightvision);{$endif}
ConfigTime.f_config_time1.ccat.Assign(catalog.cfgcat);
ConfigTime.f_config_time1.cshr.Assign(catalog.cfgshr);
ConfigTime.f_config_time1.cplot.Assign(def_cfgplot);
ConfigTime.f_config_time1.csc.Assign(def_cfgsc);
if MultiFrame1.ActiveObject is Tf_chart then with MultiFrame1.ActiveObject as Tf_chart do begin
   ConfigTime.f_config_time1.csc.Assign(sc.cfgsc);
   ConfigTime.f_config_time1.cplot.Assign(sc.plot.cfgplot);
end;
cfgm.prgdir:=appdir;
cfgm.persdir:=privatedir;
ConfigTime.f_config_time1.cmain.Assign(cfgm);
formpos(ConfigTime,mouse.cursorpos.x,mouse.cursorpos.y);
ConfigTime.f_config_time1.PageControl1.PageIndex:=page;
ConfigTime.showmodal;
if ConfigTime.ModalResult=mrOK then begin
 activateconfig(ConfigTime.f_config_time1.cmain,ConfigTime.f_config_time1.csc,ConfigTime.f_config_time1.ccat,ConfigTime.f_config_time1.cshr,ConfigTime.f_config_time1.cplot,nil,false);
end;
ConfigTime.Free;
ConfigTime:=nil;
end;

procedure Tf_main.ApplyConfigTime(Sender: TObject);
begin
 activateconfig(ConfigTime.f_config_time1.cmain,ConfigTime.f_config_time1.csc,ConfigTime.f_config_time1.ccat,ConfigTime.f_config_time1.cshr,ConfigTime.f_config_time1.cplot,nil,false);
end;

procedure Tf_main.SetupPicturesExecute(Sender: TObject);
begin
ShowBackgroundImageExecute(sender);
end;

procedure Tf_main.SetupChartExecute(Sender: TObject);
begin
 SetupChartPage(0);
end;

procedure Tf_main.SetupConfigExecute(Sender: TObject);
begin
if f_config=nil then begin
   f_config:=Tf_config.Create(application);
   f_config.onApplyConfig:=ApplyConfig;
   f_config.onDBChange:=ConfigDBChange;
   f_config.onSaveAndRestart:=SaveAndRestart;
   f_config.onPrepareAsteroid:=PrepareAsteroid;
   f_config.onGetTwilight:=GetTwilight;
   f_config.Fits:=fits;
   f_config.catalog:=catalog;
   f_config.db:=cdcdb;
end;
try
 f_config.ccat:=catalog.cfgcat;
 f_config.cshr:=catalog.cfgshr;
 f_config.cplot:=def_cfgplot;
 f_config.csc:=def_cfgsc;
 if MultiFrame1.ActiveObject is Tf_chart then with MultiFrame1.ActiveObject as Tf_chart do begin
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
   activateconfig(f_config.cmain,f_config.csc,f_config.ccat,f_config.cshr,f_config.cplot,f_config.cdss,f_config.Applyall.Checked);
 end;

finally
screen.cursor:=crDefault;
f_config.Free;
f_config:=nil;
end;
end;

procedure Tf_main.ApplyConfig(Sender: TObject);
begin
 activateconfig(f_config.cmain,f_config.csc,f_config.ccat,f_config.cshr,f_config.cplot,f_config.cdss,f_config.Applyall.Checked);
end;

procedure Tf_main.SetupChartPage(page:integer);
begin
if ConfigChart=nil then begin
   ConfigChart:=Tf_configchart.Create(self);
   ConfigChart.f_config_chart1.PageControl1.ShowTabs:=true;
   ConfigChart.f_config_chart1.PageControl1.PageIndex:=0;
   ConfigChart.f_config_chart1.onApplyConfig:=ApplyConfigChart;
end;
{$ifdef mswindows}SetFormNightVision(ConfigChart,nightvision);{$endif}
ConfigChart.f_config_chart1.ccat.Assign(catalog.cfgcat);
ConfigChart.f_config_chart1.cshr.Assign(catalog.cfgshr);
ConfigChart.f_config_chart1.cplot.Assign(def_cfgplot);
ConfigChart.f_config_chart1.csc.Assign(def_cfgsc);
if MultiFrame1.ActiveObject is Tf_chart then with MultiFrame1.ActiveObject as Tf_chart do begin
   ConfigChart.f_config_chart1.csc.Assign(sc.cfgsc);
   ConfigChart.f_config_chart1.cplot.Assign(sc.plot.cfgplot);
end;
cfgm.prgdir:=appdir;
cfgm.persdir:=privatedir;
ConfigChart.f_config_chart1.cmain.Assign(cfgm);
formpos(ConfigChart,mouse.cursorpos.x,mouse.cursorpos.y);
ConfigChart.f_config_chart1.PageControl1.PageIndex:=page;
ConfigChart.showmodal;
if ConfigChart.ModalResult=mrOK then begin
 activateconfig(ConfigChart.f_config_chart1.cmain,ConfigChart.f_config_chart1.csc,ConfigChart.f_config_chart1.ccat,ConfigChart.f_config_chart1.cshr,ConfigChart.f_config_chart1.cplot,nil,false);
end;
ConfigChart.Free;
ConfigChart:=nil;
end;

procedure Tf_main.ApplyConfigChart(Sender: TObject);
begin
 activateconfig(ConfigChart.f_config_chart1.cmain,ConfigChart.f_config_chart1.csc,ConfigChart.f_config_chart1.ccat,ConfigChart.f_config_chart1.cshr,ConfigChart.f_config_chart1.cplot,nil,false);
end;

procedure Tf_main.ToolButtonShowPlanetsMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
if Button=mbRight then SetupSolsysPage(1);
end;

procedure Tf_main.ToolButtonShowStarsMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
if Button=mbRight then SetupCatalogPage(0);
end;

procedure Tf_main.ToolButtonShowAsteroidsMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
if Button=mbRight then SetupSolsysPage(3);
end;

procedure Tf_main.ToolButtonShowBackgroundImageMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
if Button=mbRight then SetupPicturesPage(1);
end;

procedure Tf_main.ToolButtonShowCometsMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
if Button=mbRight then SetupSolsysPage(2);
end;

procedure Tf_main.SetupSolSysExecute(Sender: TObject);
begin
 SetupSolsysPage(0);
end;

procedure Tf_main.SetupSolsysPage(page:integer);
begin
if ConfigSolsys=nil then begin
   ConfigSolsys:=Tf_configsolsys.Create(self);
   ConfigSolsys.f_config_solsys1.PageControl1.ShowTabs:=true;
   ConfigSolsys.f_config_solsys1.PageControl1.PageIndex:=0;
   ConfigSolsys.f_config_solsys1.onApplyConfig:=ApplyConfigSolsys;
   ConfigSolsys.f_config_solsys1.onPrepareAsteroid:=PrepareAsteroid;
end;
{$ifdef mswindows}SetFormNightVision(ConfigSolsys,nightvision);{$endif}
ConfigSolsys.f_config_solsys1.cdb:=cdcdb;
ConfigSolsys.f_config_solsys1.ccat.Assign(catalog.cfgcat);
ConfigSolsys.f_config_solsys1.cshr.Assign(catalog.cfgshr);
ConfigSolsys.f_config_solsys1.cplot.Assign(def_cfgplot);
ConfigSolsys.f_config_solsys1.csc.Assign(def_cfgsc);
if MultiFrame1.ActiveObject is Tf_chart then with MultiFrame1.ActiveObject as Tf_chart do begin
   ConfigSolsys.f_config_solsys1.csc.Assign(sc.cfgsc);
   ConfigSolsys.f_config_solsys1.cplot.Assign(sc.plot.cfgplot);
end;
cfgm.prgdir:=appdir;
cfgm.persdir:=privatedir;
ConfigSolsys.f_config_solsys1.cmain.Assign(cfgm);
formpos(ConfigSolsys,mouse.cursorpos.x,mouse.cursorpos.y);
ConfigSolsys.f_config_solsys1.PageControl1.PageIndex:=page;
ConfigSolsys.showmodal;
if ConfigSolsys.ModalResult=mrOK then begin
 activateconfig(ConfigSolsys.f_config_solsys1.cmain,ConfigSolsys.f_config_solsys1.csc,ConfigSolsys.f_config_solsys1.ccat,ConfigSolsys.f_config_solsys1.cshr,ConfigSolsys.f_config_solsys1.cplot,nil,false);
end;
ConfigSolsys.Free;
ConfigSolsys:=nil;
end;

procedure Tf_main.ApplyConfigSolsys(Sender: TObject);
begin
 activateconfig(ConfigSolsys.f_config_solsys1.cmain,ConfigSolsys.f_config_solsys1.csc,ConfigSolsys.f_config_solsys1.ccat,ConfigSolsys.f_config_solsys1.cshr,ConfigSolsys.f_config_solsys1.cplot,nil,false);
end;

procedure Tf_main.TConnectMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if Button=mbRight then SetupSystemPage(2);
end;

procedure Tf_main.ThemeTimerTimer(Sender: TObject);
begin
ThemeTimer.Enabled:=false;
  if nightvision then begin
      if VerboseMsg then
       WriteTrace('Night vision');
     ToolButtonNightVision.Down:=nightvision;
     NightVision1.Checked:=nightvision;
   end;
   if nightvision or (cfgm.ThemeName<>'default')or(cfgm.ButtonStandard>1) then SetTheme;
end;

procedure Tf_main.ToolButton1MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if Button=mbRight then SetupChartPage(1);
end;

procedure Tf_main.TelescopeSetup1Click(Sender: TObject);
begin
  SetupSystemPage(2);
end;

procedure Tf_main.SetupSystemExecute(Sender: TObject);
begin
 SetupSystemPage(0);
end;

procedure Tf_main.SetupSystemPage(page:integer);
begin
if ConfigSystem=nil then begin
   ConfigSystem:=Tf_configsystem.Create(self);
   ConfigSystem.f_config_system1.PageControl1.ShowTabs:=true;
   ConfigSystem.f_config_system1.PageControl1.PageIndex:=0;
   ConfigSystem.f_config_system1.onApplyConfig:=ApplyConfigSystem;
   ConfigSystem.f_config_system1.onDBChange:=ConfigDBChange;
   ConfigSystem.f_config_system1.onSaveAndRestart:=SaveAndRestart;
end;
{$ifdef mswindows}SetFormNightVision(ConfigSystem,nightvision);{$endif}
ConfigSystem.f_config_system1.cdb:=cdcdb;
ConfigSystem.f_config_system1.ccat.Assign(catalog.cfgcat);
ConfigSystem.f_config_system1.cshr.Assign(catalog.cfgshr);
ConfigSystem.f_config_system1.cplot.Assign(def_cfgplot);
ConfigSystem.f_config_system1.csc.Assign(def_cfgsc);
if MultiFrame1.ActiveObject is Tf_chart then with MultiFrame1.ActiveObject as Tf_chart do begin
   ConfigSystem.f_config_system1.csc.Assign(sc.cfgsc);
   ConfigSystem.f_config_system1.cplot.Assign(sc.plot.cfgplot);
end;
cfgm.prgdir:=appdir;
cfgm.persdir:=privatedir;
ConfigSystem.f_config_system1.cmain.Assign(cfgm);
formpos(ConfigSystem,mouse.cursorpos.x,mouse.cursorpos.y);
ConfigSystem.f_config_system1.PageControl1.PageIndex:=page;
ConfigSystem.showmodal;
if ConfigSystem.ModalResult=mrOK then begin
 ConfigSystem.f_config_system1.ActivateDBchange;
 activateconfig(ConfigSystem.f_config_system1.cmain,ConfigSystem.f_config_system1.csc,ConfigSystem.f_config_system1.ccat,ConfigSystem.f_config_system1.cshr,ConfigSystem.f_config_system1.cplot,nil,false);
end;
ConfigSystem.Free;
ConfigSystem:=nil;
end;

procedure Tf_main.ResetLanguageClick(Sender: TObject);
begin
// Reset language to default using the same procedure as SetupSystemPage
if ConfigSystem=nil then begin
   ConfigSystem:=Tf_configsystem.Create(self);
   ConfigSystem.f_config_system1.PageControl1.ShowTabs:=true;
   ConfigSystem.f_config_system1.PageControl1.PageIndex:=0;
   ConfigSystem.f_config_system1.onApplyConfig:=ApplyConfigSystem;
   ConfigSystem.f_config_system1.onDBChange:=ConfigDBChange;
   ConfigSystem.f_config_system1.onSaveAndRestart:=SaveAndRestart;
end;
ConfigSystem.f_config_system1.cdb:=cdcdb;
ConfigSystem.f_config_system1.ccat.Assign(catalog.cfgcat);
ConfigSystem.f_config_system1.cshr.Assign(catalog.cfgshr);
ConfigSystem.f_config_system1.cplot.Assign(def_cfgplot);
ConfigSystem.f_config_system1.csc.Assign(def_cfgsc);
if MultiFrame1.ActiveObject is Tf_chart then with MultiFrame1.ActiveObject as Tf_chart do begin
   ConfigSystem.f_config_system1.csc.Assign(sc.cfgsc);
   ConfigSystem.f_config_system1.cplot.Assign(sc.plot.cfgplot);
end;
cfgm.prgdir:=appdir;
cfgm.persdir:=privatedir;
ConfigSystem.f_config_system1.cmain.Assign(cfgm);
ConfigSystem.f_config_system1.cmain.language:='';
ConfigSystem.f_config_system1.ActivateDBchange;
activateconfig(ConfigSystem.f_config_system1.cmain,ConfigSystem.f_config_system1.csc,ConfigSystem.f_config_system1.ccat,ConfigSystem.f_config_system1.cshr,ConfigSystem.f_config_system1.cplot,nil,false);
ConfigSystem.Free;
ConfigSystem:=nil;
end;

procedure Tf_main.ApplyConfigSystem(Sender: TObject);
begin
 activateconfig(ConfigSystem.f_config_system1.cmain,ConfigSystem.f_config_system1.csc,ConfigSystem.f_config_system1.ccat,ConfigSystem.f_config_system1.cshr,ConfigSystem.f_config_system1.cplot,nil,false);
end;

procedure Tf_main.SetupInternetExecute(Sender: TObject);
begin
 SetupInternetPage(0);
end;

procedure Tf_main.SetupInternetPage(page:integer);
begin
if ConfigInternet=nil then begin
   ConfigInternet:=Tf_configinternet.Create(self);
   ConfigInternet.f_config_internet1.PageControl1.ShowTabs:=true;
   ConfigInternet.f_config_internet1.PageControl1.PageIndex:=0;
   ConfigInternet.f_config_internet1.onApplyConfig:=ApplyConfigInternet;
end;
{$ifdef mswindows}SetFormNightVision(ConfigInternet,nightvision);{$endif}
cfgm.prgdir:=appdir;
cfgm.persdir:=privatedir;
ConfigInternet.f_config_internet1.cmain.Assign(cfgm);
ConfigInternet.f_config_internet1.cdss.Assign(f_getdss.cfgdss);
formpos(ConfigInternet,mouse.cursorpos.x,mouse.cursorpos.y);
ConfigInternet.f_config_internet1.PageControl1.PageIndex:=page;
ConfigInternet.showmodal;
if ConfigInternet.ModalResult=mrOK then begin
 activateconfig(ConfigInternet.f_config_internet1.cmain,nil,nil,nil,nil,ConfigInternet.f_config_internet1.cdss,false);
end;
ConfigInternet.Free;
ConfigInternet:=nil;
end;

procedure Tf_main.ApplyConfigInternet(Sender: TObject);
begin
 activateconfig(ConfigInternet.f_config_internet1.cmain,nil,nil,nil,nil,ConfigInternet.f_config_internet1.cdss,false);
end;

procedure Tf_main.SetupPicturesPage(page:integer; action:integer=0);
begin
if ConfigPictures=nil then begin
   ConfigPictures:=Tf_configpictures.Create(self);
   ConfigPictures.f_config_pictures1.PageControl1.ShowTabs:=true;
   ConfigPictures.f_config_pictures1.PageControl1.PageIndex:=0;
   ConfigPictures.f_config_pictures1.onApplyConfig:=ApplyConfigPictures;
end;
{$ifdef mswindows}SetFormNightVision(ConfigPictures,nightvision);{$endif}
ConfigPictures.f_config_pictures1.cdb:=cdcdb;
ConfigPictures.f_config_pictures1.cdss.Assign(f_getdss.cfgdss);
ConfigPictures.f_config_pictures1.Fits:=Fits;
ConfigPictures.f_config_pictures1.ccat.Assign(catalog.cfgcat);
ConfigPictures.f_config_pictures1.cshr.Assign(catalog.cfgshr);
ConfigPictures.f_config_pictures1.cplot.Assign(def_cfgplot);
ConfigPictures.f_config_pictures1.csc.Assign(def_cfgsc);
if MultiFrame1.ActiveObject is Tf_chart then with MultiFrame1.ActiveObject as Tf_chart do begin
   ConfigPictures.f_config_pictures1.csc.Assign(sc.cfgsc);
   ConfigPictures.f_config_pictures1.cplot.Assign(sc.plot.cfgplot);
end;
cfgm.prgdir:=appdir;
cfgm.persdir:=privatedir;
ConfigPictures.f_config_pictures1.cmain.Assign(cfgm);
formpos(ConfigPictures,mouse.cursorpos.x,mouse.cursorpos.y);
ConfigPictures.f_config_pictures1.PageControl1.PageIndex:=page;
//ConfigPictures.show;
ConfigPictures.f_config_pictures1.backimgChange(self);
//ConfigPictures.hide;
case action of
0 : ConfigPictures.showmodal;
1 : begin
    ConfigPictures.show;
    ConfigPictures.f_config_pictures1.ScanImagesClick(nil);
    ConfigPictures.Close;
    end;
end;
if ConfigPictures.ModalResult=mrOK then begin
 activateconfig(ConfigPictures.f_config_pictures1.cmain,ConfigPictures.f_config_pictures1.csc,ConfigPictures.f_config_pictures1.ccat,ConfigPictures.f_config_pictures1.cshr,ConfigPictures.f_config_pictures1.cplot,ConfigPictures.f_config_pictures1.cdss,false);
end;
ConfigPictures.Free;
ConfigPictures:=nil;
end;

procedure Tf_main.ApplyConfigPictures(Sender: TObject);
begin
 activateconfig(ConfigPictures.f_config_pictures1.cmain,ConfigPictures.f_config_pictures1.csc,ConfigPictures.f_config_pictures1.ccat,ConfigPictures.f_config_pictures1.cshr,ConfigPictures.f_config_pictures1.cplot,ConfigPictures.f_config_pictures1.cdss,false);
end;


procedure Tf_main.SetupObservatoryExecute(Sender: TObject);
begin
SetupObservatoryPage(0);
end;

procedure Tf_main.SetupObservatoryPage(page:integer; posx:integer=0; posy:integer=0);
begin
if ConfigObservatory=nil then begin
   ConfigObservatory:=Tf_configobservatory.Create(self);
   ConfigObservatory.f_config_observatory1.PageControl1.ShowTabs:=true;
   ConfigObservatory.f_config_observatory1.PageControl1.PageIndex:=0;
   ConfigObservatory.f_config_observatory1.onApplyConfig:=ApplyConfigObservatory;
end;
{$ifdef mswindows}SetFormNightVision(ConfigObservatory,nightvision);{$endif}
ConfigObservatory.f_config_observatory1.cdb:=cdcdb;
ConfigObservatory.f_config_observatory1.ccat.Assign(catalog.cfgcat);
ConfigObservatory.f_config_observatory1.cshr.Assign(catalog.cfgshr);
ConfigObservatory.f_config_observatory1.cplot.Assign(def_cfgplot);
ConfigObservatory.f_config_observatory1.csc.Assign(def_cfgsc);
if MultiFrame1.ActiveObject is Tf_chart then with MultiFrame1.ActiveObject as Tf_chart do begin
   ConfigObservatory.f_config_observatory1.csc.Assign(sc.cfgsc);
   ConfigObservatory.f_config_observatory1.cplot.Assign(sc.plot.cfgplot);
end;
cfgm.prgdir:=appdir;
cfgm.persdir:=privatedir;
ConfigObservatory.f_config_observatory1.cmain.Assign(cfgm);
if (posx=0)and(posy=0) then
   formpos(ConfigObservatory,mouse.cursorpos.x,mouse.cursorpos.y)
else
  if (posx>0)and(posy>0) then
   formpos(ConfigObservatory,posx,posy)
else begin
   posx:=Screen.Width div 2 - ConfigObservatory.Width div 2;
   posy:=Screen.Height div 2 - ConfigObservatory.Height div 2;
   formpos(ConfigObservatory,posx,posy)
end;
ConfigObservatory.f_config_observatory1.PageControl1.PageIndex:=page;
ConfigObservatory.showmodal;
if ConfigObservatory.ModalResult=mrOK then begin
 activateconfig(ConfigObservatory.f_config_observatory1.cmain,ConfigObservatory.f_config_observatory1.csc,ConfigObservatory.f_config_observatory1.ccat,ConfigObservatory.f_config_observatory1.cshr,ConfigObservatory.f_config_observatory1.cplot,nil,false);
end;
ConfigObservatory.Free;
ConfigObservatory:=nil;
end;

procedure Tf_main.ApplyConfigObservatory(Sender: TObject);
begin
 activateconfig(ConfigObservatory.f_config_observatory1.cmain,ConfigObservatory.f_config_observatory1.csc,ConfigObservatory.f_config_observatory1.ccat,ConfigObservatory.f_config_observatory1.cshr,ConfigObservatory.f_config_observatory1.cplot,nil,false);
end;

procedure Tf_main.SetupCatalogExecute(Sender: TObject);
begin
SetupCatalogPage(0);
end;

procedure Tf_main.SetupCatalogPage(page:integer);
begin
if ConfigCatalog=nil then begin
   ConfigCatalog:=Tf_configcatalog.Create(self);
   ConfigCatalog.f_config_catalog1.catalog:=catalog;
   ConfigCatalog.f_config_catalog1.PageControl1.ShowTabs:=true;
   ConfigCatalog.f_config_catalog1.PageControl1.PageIndex:=0;
   ConfigCatalog.f_config_catalog1.onApplyConfig:=ApplyConfigCatalog;
end;
{$ifdef mswindows}SetFormNightVision(ConfigCatalog,nightvision);{$endif}
ConfigCatalog.f_config_catalog1.ccat.Assign(catalog.cfgcat);
ConfigCatalog.f_config_catalog1.cshr.Assign(catalog.cfgshr);
ConfigCatalog.f_config_catalog1.cplot.Assign(def_cfgplot);
ConfigCatalog.f_config_catalog1.csc.Assign(def_cfgsc);
if MultiFrame1.ActiveObject is Tf_chart then with MultiFrame1.ActiveObject as Tf_chart do begin
   ConfigCatalog.f_config_catalog1.csc.Assign(sc.cfgsc);
   ConfigCatalog.f_config_catalog1.cplot.Assign(sc.plot.cfgplot);
   ConfigCatalog.f_config_catalog1.ra:=sc.cfgsc.racentre;
   ConfigCatalog.f_config_catalog1.dec:=sc.cfgsc.decentre;
   ConfigCatalog.f_config_catalog1.fov:=sc.cfgsc.fov*0.75;
   Precession(sc.cfgsc.JDChart,jd2000,ConfigCatalog.f_config_catalog1.ra,ConfigCatalog.f_config_catalog1.dec);
end;
cfgm.prgdir:=appdir;
cfgm.persdir:=privatedir;
ConfigCatalog.f_config_catalog1.cmain.Assign(cfgm);
formpos(ConfigCatalog,mouse.cursorpos.x,mouse.cursorpos.y);
ConfigCatalog.f_config_catalog1.PageControl1.PageIndex:=page;
ConfigCatalog.showmodal;
if ConfigCatalog.ModalResult=mrOK then begin
 ConfigCatalog.f_config_catalog1.ActivateGCat;
 ConfigCatalog.f_config_catalog1.ActivateUserObjects;
 activateconfig(ConfigCatalog.f_config_catalog1.cmain,ConfigCatalog.f_config_catalog1.csc,ConfigCatalog.f_config_catalog1.ccat,ConfigCatalog.f_config_catalog1.cshr,ConfigCatalog.f_config_catalog1.cplot,nil,false);
end;
ConfigCatalog.Free;
ConfigCatalog:=nil;
end;

procedure Tf_main.ApplyConfigCatalog(Sender: TObject);
begin
 ConfigCatalog.f_config_catalog1.ActivateGCat;
 ConfigCatalog.f_config_catalog1.ActivateUserObjects;
 activateconfig(ConfigCatalog.f_config_catalog1.cmain,ConfigCatalog.f_config_catalog1.csc,ConfigCatalog.f_config_catalog1.ccat,ConfigCatalog.f_config_catalog1.cshr,ConfigCatalog.f_config_catalog1.cplot,nil,false);
end;

procedure Tf_main.ToolButtonShowLabelsMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if Button=mbRight then SetupDisplayPage(5);
end;

procedure Tf_main.ToolButtonShowLineMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if Button=mbRight then SetupDisplayPage(4);
end;

procedure Tf_main.ToolButtonswitchstarsMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if Button=mbRight then SetupDisplayPage(0);
end;

procedure Tf_main.ToolButtonUObjClick(Sender: TObject);
begin
  if MultiFrame1.ActiveObject is Tf_chart then with MultiFrame1.ActiveObject as Tf_chart do begin
     sc.catalog.cfgcat.nebcatdef[uneb-BaseNeb]:=ToolButtonUObj.Down;
     Refresh;
  end;
end;

procedure Tf_main.ToolButtonUObjMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if Button=mbRight then SetupCatalogPage(4);
end;

procedure Tf_main.ToolButtonVOClick(Sender: TObject);
begin
  if MultiFrame1.ActiveObject is Tf_chart then with MultiFrame1.ActiveObject as Tf_chart do begin
     sc.catalog.cfgcat.starcatdef[vostar-BaseStar]:=ToolButtonVO.Down;
     sc.catalog.cfgcat.nebcatdef[voneb-BaseNeb]:=ToolButtonVO.Down;
     Refresh;
  end;
end;

procedure Tf_main.ToolButtonVOMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if Button=mbRight then SetupCatalogPage(3);
end;

procedure Tf_main.ToolButtonswitchbackgroundMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if Button=mbRight then SetupDisplayPage(3);
end;

procedure Tf_main.ToolButtonShowMarkMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
if Button=mbRight then SetupDisplayPage(7);
end;

procedure Tf_main.ToolButtonShowNebulaeMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
if Button=mbRight then SetupCatalogPage(1);
end;

procedure Tf_main.ToolButtonShowLinesMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
if Button=mbRight then SetupDisplayPage(4);
end;

procedure Tf_main.ToolButtonShowPicturesMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if Button=mbRight then SetupPicturesPage(0);
end;

procedure Tf_main.SetupDisplayExecute(Sender: TObject);
begin
SetupDisplayPage(0);
end;

procedure Tf_main.SetupDisplayPage(pagegroup:integer);
begin
if ConfigDisplay=nil then begin
   ConfigDisplay:=Tf_configdisplay.Create(self);
   ConfigDisplay.f_config_display1.PageControl1.ShowTabs:=true;
   ConfigDisplay.f_config_display1.PageControl1.PageIndex:=0;
   ConfigDisplay.f_config_display1.onApplyConfig:=ApplyConfigDisplay;
end;
{$ifdef mswindows}SetFormNightVision(ConfigDisplay,nightvision);{$endif}
ConfigDisplay.f_config_display1.ccat.Assign(catalog.cfgcat);
ConfigDisplay.f_config_display1.cshr.Assign(catalog.cfgshr);
ConfigDisplay.f_config_display1.cplot.Assign(def_cfgplot);
ConfigDisplay.f_config_display1.csc.Assign(def_cfgsc);
if MultiFrame1.ActiveObject is Tf_chart then with MultiFrame1.ActiveObject as Tf_chart do begin
   ConfigDisplay.f_config_display1.csc.Assign(sc.cfgsc);
   ConfigDisplay.f_config_display1.cplot.Assign(sc.plot.cfgplot);
end;
cfgm.prgdir:=appdir;
cfgm.persdir:=privatedir;
ConfigDisplay.f_config_display1.cmain.Assign(cfgm);
formpos(ConfigDisplay,mouse.cursorpos.x,mouse.cursorpos.y);
{$ifdef mswindows}
// TODO: Problem with initialization
ConfigDisplay.show;
ConfigDisplay.hide;
ConfigDisplay.f_config_display1.ccat.Assign(catalog.cfgcat);
ConfigDisplay.f_config_display1.cshr.Assign(catalog.cfgshr);
ConfigDisplay.f_config_display1.cplot.Assign(def_cfgplot);
ConfigDisplay.f_config_display1.csc.Assign(def_cfgsc);
if MultiFrame1.ActiveObject is Tf_chart then with MultiFrame1.ActiveObject as Tf_chart do begin
   ConfigDisplay.f_config_display1.csc.Assign(sc.cfgsc);
   ConfigDisplay.f_config_display1.cplot.Assign(sc.plot.cfgplot);
end;
cfgm.prgdir:=appdir;
cfgm.persdir:=privatedir;
ConfigDisplay.f_config_display1.cmain.Assign(cfgm);
///////////////////////////////
{$endif}
ConfigDisplay.f_config_display1.PageControl1.PageIndex:=pagegroup;
ConfigDisplay.showmodal;
if ConfigDisplay.ModalResult=mrOK then begin
 activateconfig(ConfigDisplay.f_config_display1.cmain,ConfigDisplay.f_config_display1.csc,ConfigDisplay.f_config_display1.ccat,ConfigDisplay.f_config_display1.cshr,ConfigDisplay.f_config_display1.cplot,nil,false);
end;
ConfigDisplay.Free;
ConfigDisplay:=nil;
end;

procedure Tf_main.ApplyConfigDisplay(Sender: TObject);
begin
 activateconfig(ConfigDisplay.f_config_display1.cmain,ConfigDisplay.f_config_display1.csc,ConfigDisplay.f_config_display1.ccat,ConfigDisplay.f_config_display1.cshr,ConfigDisplay.f_config_display1.cplot,nil,false);
end;

function Tf_main.PrepareAsteroid(jdt:double; msg:Tstrings):boolean;
begin
 result:=planet.PrepareAsteroid(jdt,msg);
end;

procedure Tf_main.ConfigDBChange(Sender: TObject);
begin
if ConfigSystem<>nil then begin
  cfgm.dbhost:=ConfigSystem.f_config_system1.cmain.dbhost;
  cfgm.db:=ConfigSystem.f_config_system1.cmain.db;
  cfgm.dbuser:=ConfigSystem.f_config_system1.cmain.dbuser;
  cfgm.dbpass:=ConfigSystem.f_config_system1.cmain.dbpass;
  cfgm.dbport:=ConfigSystem.f_config_system1.cmain.dbport;
  ConnectDB;
end;
end;

procedure Tf_main.SaveAndRestart(Sender: TObject);
begin
if ConfigSystem<>nil then begin
  cfgm.Assign(ConfigSystem.f_config_system1.cmain);
  if directoryexists(cfgm.prgdir) then appdir:=cfgm.prgdir;
  privatedir:=cfgm.persdir;
  def_cfgsc.Assign(ConfigSystem.f_config_system1.csc);
  catalog.cfgcat.Assign(ConfigSystem.f_config_system1.ccat);
  catalog.cfgshr.Assign(ConfigSystem.f_config_system1.cshr);
  SavePrivateConfig(configfile);
  NeedRestart:=true;
  Close;
end;
end;

procedure Tf_main.ClearAndRestart;
begin
  SaveConfigOnExit.checked:=false;
  DeleteFile(configfile);
  NeedRestart:=true;
  Close;
end;

procedure Tf_main.activateconfig(cmain:Tconf_main; csc:Tconf_skychart; ccat:Tconf_catalog; cshr:Tconf_shared; cplot:Tconf_plot; cdss:Tconf_dss; applyall:boolean );
var i:integer;
  dbchange,themechange,langchange,starchange: Boolean;
begin
    dbchange:=false; themechange:=false; langchange:=false; starchange:=false;
    if cmain<>nil then begin
      if (cfgm.language<>cmain.language) then langchange:=true;
    end;
    if langchange then ChangeLanguage(cmain.language);
    if cmain<>nil then begin
      if (cfgm.ButtonNight <> cmain.ButtonNight) or
         (cfgm.ButtonStandard <> cmain.ButtonStandard) or
         (cfgm.ThemeName <> cmain.ThemeName)
         then themechange:=true;
      if cfgm.starshape_file<>cmain.starshape_file then
         starchange:=true;
      if (cfgm.dbhost<>cmain.dbhost) or
         (cfgm.db<>cmain.db) or
         (cfgm.dbuser<>cmain.dbuser) or
         (cfgm.dbpass<>cmain.dbpass) or
         (cfgm.dbport<>cmain.dbport)
         then dbchange:=true;
      cfgm.Assign(cmain);
      AnimationTimer.Interval:=max(10,cfgm.AnimDelay);
    end;
    if themechange then SetTheme;
    if starchange then SetStarShape;
    cfgm.updall:=applyall;
    if directoryexists(cfgm.prgdir) then appdir:=cfgm.prgdir;
    privatedir:=cfgm.persdir;
    if ccat<>nil then begin
      for i:=0 to ccat.GCatNum-1 do begin
        if ccat.GCatLst[i].Actif then begin
          if not
          catalog.GetInfo(ccat.GCatLst[i].path,
                          ccat.GCatLst[i].shortname,
                          ccat.GCatLst[i].magmax,
                          ccat.GCatLst[i].cattype,
                          ccat.GCatLst[i].version,
                          ccat.GCatLst[i].name)
          then ccat.GCatLst[i].Actif:=false;
        end;
      end;
      catalog.cfgcat.Assign(ccat);
    end;
    if cdss<>nil then f_getdss.cfgdss.Assign(cdss);
    if cshr<>nil then catalog.cfgshr.Assign(cshr);
    if csc<>nil  then begin
       if (not csc.SunOnline)or(csc.sunurlname<>def_cfgsc.sunurlname) then DeleteFile(slash(Tempdir)+'sun.jpg');
       def_cfgsc.Assign(csc);
    end;
    if cplot<>nil then begin
       def_cfgplot.Assign(cplot);
       def_cfgplot.starshapesize:=starshape.Picture.bitmap.Width div 11;
       def_cfgplot.starshapew:=def_cfgplot.starshapesize div 2;
    end;
    InitFonts;
    if def_cfgsc.ConstLatinLabel then
         catalog.LoadConstellation(cfgm.Constellationpath,'Latin')
      else
         catalog.LoadConstellation(cfgm.Constellationpath,lang);
    catalog.LoadStarName(slash(appdir)+slash('data')+slash('common_names'),Lang);
    catalog.LoadConstL(cfgm.ConstLfile);
    catalog.LoadConstB(cfgm.ConstBfile);
    catalog.LoadHorizon(cfgm.horizonfile,def_cfgsc);
    f_search.init;
    if dbchange then ConnectDB;
    if MultiFrame1.ActiveObject is Tf_chart then with MultiFrame1.ActiveObject as Tf_chart do begin
       if csc<>nil then sc.cfgsc.Assign(def_cfgsc);
       sc.Fits:=Fits;
       sc.planet:=planet;
       sc.cdb:=cdcdb;
       sc.cfgsc.FindOk:=false;
       sc.plot.cfgplot.Assign(def_cfgplot);
       if cfgm.NewBackgroundImage then begin
          sc.Fits.Filename:=sc.cfgsc.BackgroundImage;
          sc.Fits.InfoWCScoord;
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
    Autorefresh.Interval:=max(10,cfgm.autorefreshdelay)*1000;
    AutoRefreshLock:=false;
    Autorefresh.enabled:=true;
end;

procedure Tf_main.ViewTopPanel;
var i: integer;
begin
i:=0;
if ToolBar1.visible then i:=i+ToolBar1.Height;
if ToolBar4.visible then i:=i+ToolBar4.Height;
if TabControl1.visible then i:=i+TabControl1.Height;
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
if PanelBottom.visible then InitFonts;
FormResize(sender);
end;

procedure Tf_main.ViewClockExecute(Sender: TObject);
var P : Tpoint;
begin
P:=point(0,110);
  if f_clock=nil then begin
     f_clock:=Tf_clock.Create(application);
     f_clock.cfgsc:=def_cfgsc;
     f_clock.planet:=planet;
  end;
  if f_clock.visible then  begin
     f_clock.hide;
     ViewClock.Checked:=false;
  end else begin
     formpos(f_clock,P.x,P.y);
     f_clock.Show;
     f_main.Setfocus;
     ViewClock.Checked:=true;
  end;
end;

procedure Tf_main.ViewScrollBar1Click(Sender: TObject);
var i: Integer;
begin
if VerboseMsg then
 WriteTrace('ViewScrollBar1Click');
if cfgm.KioskMode then ViewScrollBar1.Checked:=false
                  else ViewScrollBar1.Checked:=(not ViewScrollBar1.Checked)and CanShowScrollbar;
for i:=0 to MultiFrame1.ChildCount-1 do
  if MultiFrame1.Childs[i].DockedObject is Tf_chart then begin
    (MultiFrame1.Childs[i].DockedObject as Tf_chart).VertScrollBar.Visible:=ViewScrollBar1.Checked;
    (MultiFrame1.Childs[i].DockedObject as Tf_chart).HorScrollBar.Visible:=ViewScrollBar1.Checked;
    (MultiFrame1.Childs[i].DockedObject as Tf_chart).Refresh;
  end;
end;

procedure Tf_main.ViewMainBarExecute(Sender: TObject);
begin
ToolBar1.visible:=not ToolBar1.visible;
MainBar1.checked:=ToolBar1.visible;
if not MainBar1.checked then ViewToolsBar1.checked:=false;
if MainBar1.checked and ObjectBar1.checked and LeftBar1.checked and RightBar1.checked and ViewStatusBar1.checked then ViewToolsBar1.checked:=true;
ViewTopPanel;
FormResize(sender);
end;

procedure Tf_main.ViewObjectBarExecute(Sender: TObject);
begin
ToolBar4.visible:=not ToolBar4.visible;
ObjectBar1.checked:=ToolBar4.visible;
if not ObjectBar1.checked then ViewToolsBar1.checked:=false;
if MainBar1.checked and ObjectBar1.checked and LeftBar1.checked and RightBar1.checked and ViewStatusBar1.checked then ViewToolsBar1.checked:=true;
ViewTopPanel;
FormResize(sender);
end;

procedure Tf_main.ViewLeftBarExecute(Sender: TObject);
begin
PanelLeft.visible:=not PanelLeft.visible;
LeftBar1.checked:=PanelLeft.visible;
if not LeftBar1.checked then ViewToolsBar1.checked:=false;
if MainBar1.checked and ObjectBar1.checked and LeftBar1.checked and RightBar1.checked and ViewStatusBar1.checked then ViewToolsBar1.checked:=true;
FormResize(sender);
end;

procedure Tf_main.ViewRightBarExecute(Sender: TObject);
begin
PanelRight.visible:=not PanelRight.visible;
RightBar1.checked:=PanelRight.visible;
if not RightBar1.checked then ViewToolsBar1.checked:=false;
if MainBar1.checked and ObjectBar1.checked and LeftBar1.checked and RightBar1.checked and ViewStatusBar1.checked then ViewToolsBar1.checked:=true;
FormResize(sender);
end;

procedure Tf_main.ViewStatusExecute(Sender: TObject);
begin
PanelBottom.visible:=not PanelBottom.visible;
ViewStatusBar1.checked:=PanelBottom.visible;
if not ViewStatusBar1.checked then ViewToolsBar1.checked:=false;
if MainBar1.checked and ObjectBar1.checked and LeftBar1.checked and RightBar1.checked and ViewStatusBar1.checked then ViewToolsBar1.checked:=true;
if PanelBottom.visible then InitFonts;
FormResize(sender);
end;

Procedure Tf_main.InitFonts;
var ts: Tsize;
begin
   P0L1.Caption:='';
   ts:=P0L1.Canvas.TextExtent('Ra:222h22m22.22s +22d22m22s22');
   PanelBottom.height:=2*ts.cy+4;
   PPanels0.Width:=ts.cx+4;
   P0L1.Align:=alClient;
end;

Procedure Tf_main.SetLPanel1(txt1:string; origin:string='';sendmsg:boolean=false;Sender: TObject=nil; txt2:string='');
var txt,buf,buf1,buf2,k: string;
    p: integer;
begin
if (trim(txt1)>'') then writetrace(txt1);
if txt2='' then begin
  txt:=StringReplace(txt1,tab,blank,[rfReplaceAll]);
end else begin
  buf:=txt1+tab;
  p:=pos(tab,buf);
  txt:=rsRA+':'+copy(buf,1,p-1)+blank;                     // RA
  delete(buf,1,p);
  p:=pos(tab,buf);
  txt:=txt+rsDE+':'+copy(buf,1,p-1)+blank+blank;           // DEC
  delete(buf,1,p);
  p:=pos(tab,buf);
  buf1:=trim(copy(buf,1,p-1));
  txt:=txt+catalog.LongLabelObj(buf1)+':'+blank;           // Object type
  delete(buf,1,p);
  p:=pos(tab,buf);
  txt:=txt+wordspace(copy(buf,1,p-1))+blank+blank;         // Object name
  delete(buf,1,p);
  p:=pos(tab,buf);
  buf1:=trim(copy(buf,1,p-1));
  txt:=txt+catalog.LongLabel(buf1)+blank+blank;            // Magnitude
  delete(buf,1,p);
  p:=pos(tab,buf);
  buf2:=trim(copy(buf,1,p-1));                             // save Alt name for the end
  delete(buf,1,p);
  while buf>'' do begin                                    // Search for size
    p:=pos(tab,buf);
    buf1:=trim(copy(buf,1,p-1));
    delete(buf,1,p);
    p:=pos(':',buf1);
    k:=uppercase(trim(copy(buf1,1,p-1)));
    if (k='DIM')or(k=uppercase(rsCommonName)) then begin
       txt:=txt+catalog.LongLabel(buf1)+blank+blank;       // Size / common name
    end;
  end;
  txt:=txt+catalog.LongLabel(buf2);                        // Alt name
end;
P1L1.Caption:=txt+crlf+txt2;
if sendmsg then SendInfo(Sender,origin,txt1);
// refresh tracking object
if MultiFrame1.ActiveObject is Tf_chart then with (MultiFrame1.ActiveObject as Tf_chart) do begin
    if sc.cfgsc.TrackOn then begin
       ToolButtonTrack.Hint:=rsUnlockChart;
       MenuTrack.Caption:=rsUnlockChart;
     end else if ((sc.cfgsc.TrackType>=1)and(sc.cfgsc.TrackType<=3))or(sc.cfgsc.TrackType=6)
     then begin
       ToolButtonTrack.Hint:=Format(rsLockOn, [sc.cfgsc.Trackname]);
       MenuTrack.Caption:=Format(rsLockOn, [sc.cfgsc.Trackname]);
     end else begin
       ToolButtonTrack.Hint:=rsNoObjectToLo;
       MenuTrack.Caption:=rsNoObjectToLo;
     end;
     if f_manualtelescope.visible then  f_manualtelescope.SetTurn(sc.cfgsc.FindNote);
end;
end;

Procedure Tf_main.SetLPanel0(txt:string);
begin
P0L1.Caption:=txt;
if PPanels0.Width<P0L1.width then PPanels0.Width:=P0L1.width+8;
end;

Procedure Tf_main.SetTopMessage(txt:string;sender:TObject);
begin
// set the message that appear in the menu bar
if MultiFrame1.ActiveObject=sender then begin
  topmsg:=txt;
  if cfgm.ShowChartInfo then topmessage.caption:=topmsg
     else topmessage.caption:=' ';
end;
end;

Procedure Tf_main.SetTitleMessage(txt:string;sender:TObject);
begin
// set the message that appear in the title bar
if MultiFrame1.ActiveObject=sender then begin
  if cfgm.ShowTitlePos then caption:=basecaption+' - '+MultiFrame1.ActiveChild.Caption+blank+blank+txt
     else caption:=basecaption+' - '+MultiFrame1.ActiveChild.Caption;
end;
end;

procedure Tf_main.FormResize(Sender: TObject);
begin
SaveState:=WindowState;
end;

procedure Tf_main.SetDefault;
var i:integer;
begin
nightvision:=false;
cfgm.MaxChildID:=0;
cfgm.prtname:='';
cfgm.SesameUrlNum:=0;
cfgm.SesameCatNum:=3;
cfgm.configpage:=0;
cfgm.configpage_i:=0;
cfgm.configpage_j:=0;
cfgm.Paper:=2;
cfgm.PrinterResolution:=300;
cfgm.PrintColor:=0;
cfgm.PrintLandscape:=true;
cfgm.PrintMethod:=0;
cfgm.PrintCmd1:=DefaultPrintCmd1;
cfgm.PrintCmd2:=DefaultPrintCmd2;
cfgm.PrintTmpPath:=expandfilename(TempDir);
cfgm.PrintDesc:='';
cfgm.PrintCopies:=1;
cfgm.PrtLeftMargin:=15;
cfgm.PrtRightMargin:=15;
cfgm.PrtTopMargin:=10;
cfgm.PrtBottomMargin:=5;
cfgm.maximized:=true;
cfgm.KioskMode:=false;
cfgm.KioskDebug:=false;
cfgm.KioskPass:='';
cfgm.updall:=true;
cfgm.AutoRefreshDelay:=60;
cfgm.ServerIPaddr:='127.0.0.1';
cfgm.ServerIPport:='3292'; // x'CDC' :o)
cfgm.IndiPanelCmd:=dcd_cmd;
cfgm.keepalive:=true;
cfgm.TextOnlyDetail:=false;
cfgm.AutostartServer:=true;
cfgm.dbhost:='localhost';
cfgm.dbport:=3306;
cfgm.db:=slash(dbdir)+(defaultSqliteDB);
cfgm.dbuser:='root';
cfgm.dbpass:='';
cfgm.ImagePath:=slash('data')+slash('pictures');
cfgm.ShowChartInfo:=false;
cfgm.ShowTitlePos:=false;
cfgm.SyncChart:=false;
cfgm.ThemeName:='default';
cfgm.ButtonStandard:=1;
cfgm.ButtonNight:=2;
cfgm.VOurl:=0;
cfgm.VOmaxrecord:=10000;
cfgm.AnimDelay:=500;
cfgm.AnimFps:=2.0;
cfgm.AnimRec:=false;
cfgm.AnimRecDir:=HomeDir;
cfgm.AnimRecPrefix:='skychart';
cfgm.AnimRecExt:='.mp4';
cfgm.Animffmpeg:=Defaultffmpeg;
cfgm.AnimSx:=-1;
cfgm.AnimSy:=-1;
cfgm.AnimSize:=0;
cfgm.AnimOpt:=DefaultffmpegOptions;
cfgm.HttpProxy:=false;
cfgm.SocksProxy:=false;
cfgm.SocksType:='Socks5';
cfgm.FtpPassive:=true;
cfgm.ConfirmDownload:=true;
cfgm.ProxyHost:='';
cfgm.ProxyPort:='';
cfgm.ProxyUser:='';
cfgm.ProxyPass:='';
cfgm.AnonPass:='skychart@';
cfgm.ObsNameList:=TStringList.Create;
cfgm.CometUrlList:=TStringList.Create;
cfgm.CometUrlList.Add(URL_HTTPCometElements);
cfgm.AsteroidUrlList:=TStringList.Create;
cfgm.AsteroidUrlList.Add(URL_CDCAsteroidElements);
cfgm.AsteroidUrlList.Add(URL_HTTPAsteroidElements2);
cfgm.AsteroidUrlList.Add(URL_HTTPAsteroidElements3);
cfgm.starshape_file:='';
for i:=1 to MaxDSSurl do begin
  f_getdss.cfgdss.DSSurl[i,0]:='';
  f_getdss.cfgdss.DSSurl[i,1]:='';
end;
f_getdss.cfgdss.DSSurl[1,0]:=URL_DSS_NAME1;
f_getdss.cfgdss.DSSurl[1,1]:=URL_DSS1;
f_getdss.cfgdss.DSSurl[2,0]:=URL_DSS_NAME2;
f_getdss.cfgdss.DSSurl[2,1]:=URL_DSS2;
f_getdss.cfgdss.DSSurl[3,0]:=URL_DSS_NAME3;
f_getdss.cfgdss.DSSurl[3,1]:=URL_DSS3;
f_getdss.cfgdss.DSSurl[4,0]:=URL_DSS_NAME4;
f_getdss.cfgdss.DSSurl[4,1]:=URL_DSS4;
f_getdss.cfgdss.DSSurl[5,0]:=URL_DSS_NAME5;
f_getdss.cfgdss.DSSurl[5,1]:=URL_DSS5;
f_getdss.cfgdss.DSSurl[6,0]:=URL_DSS_NAME6;
f_getdss.cfgdss.DSSurl[6,1]:=URL_DSS6;
f_getdss.cfgdss.DSSurl[7,0]:=URL_DSS_NAME7;
f_getdss.cfgdss.DSSurl[7,1]:=URL_DSS7;
f_getdss.cfgdss.DSSurl[8,0]:=URL_DSS_NAME8;
f_getdss.cfgdss.DSSurl[8,1]:=URL_DSS8;
f_getdss.cfgdss.DSSurl[9,0]:=URL_DSS_NAME9;
f_getdss.cfgdss.DSSurl[9,1]:=URL_DSS9;
f_getdss.cfgdss.DSSurl[10,0]:=URL_DSS_NAME10;
f_getdss.cfgdss.DSSurl[10,1]:=URL_DSS10;
f_getdss.cfgdss.DSSurl[11,0]:=URL_DSS_NAME11;
f_getdss.cfgdss.DSSurl[11,1]:=URL_DSS11;
f_getdss.cfgdss.DSSurl[12,0]:=URL_DSS_NAME12;
f_getdss.cfgdss.DSSurl[12,1]:=URL_DSS12;
f_getdss.cfgdss.DSSurl[13,0]:=URL_DSS_NAME13;
f_getdss.cfgdss.DSSurl[13,1]:=URL_DSS13;
f_getdss.cfgdss.DSSurl[14,0]:=URL_DSS_NAME14;
f_getdss.cfgdss.DSSurl[14,1]:=URL_DSS14;
f_getdss.cfgdss.DSSurl[15,0]:=URL_DSS_NAME15;
f_getdss.cfgdss.DSSurl[15,1]:=URL_DSS15;
f_getdss.cfgdss.DSSurl[16,0]:=URL_DSS_NAME16;
f_getdss.cfgdss.DSSurl[16,1]:=URL_DSS16;
f_getdss.cfgdss.DSSurl[17,0]:=URL_DSS_NAME17;
f_getdss.cfgdss.DSSurl[17,1]:=URL_DSS17;
f_getdss.cfgdss.DSSurl[18,0]:=URL_DSS_NAME18;
f_getdss.cfgdss.DSSurl[18,1]:=URL_DSS18;
f_getdss.cfgdss.DSSurl[19,0]:=URL_DSS_NAME19;
f_getdss.cfgdss.DSSurl[19,1]:=URL_DSS19;
f_getdss.cfgdss.OnlineDSS:=true;
f_getdss.cfgdss.OnlineDSSid:=1;
for i:=1 to numfont do begin
   def_cfgplot.FontName[i]:=DefaultFontName;
   def_cfgplot.FontSize[i]:=DefaultFontSize;
   def_cfgplot.FontBold[i]:=false;
   def_cfgplot.FontItalic[i]:=false;
end;
def_cfgplot.FontName[5]:=DefaultFontFixed;
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
def_cfgplot.LabelColor[7]:=clSilver;
def_cfgplot.LabelSize[6]:=def_cfgplot.LabelSize[6]+2;
def_cfgplot.contrast:=450;
def_cfgplot.partsize:=1.2;
def_cfgplot.red_move:=true;
def_cfgplot.magsize:=4;
def_cfgplot.saturation:=255;
cfgm.Constellationpath:='data'+Pathdelim+'constellation';
cfgm.ConstLfile:='data'+Pathdelim+'constellation'+Pathdelim+'DefaultConstL.cln';
cfgm.ConstBfile:='data'+Pathdelim+'constellation'+Pathdelim+'constb.cby';
cfgm.EarthMapFile:='data'+Pathdelim+'earthmap'+Pathdelim+'earthmap1k.jpg';
cfgm.PlanetDir:='data'+Pathdelim+'planet';
cfgm.horizonfile:='';
def_cfgplot.UseBMP:=true;
def_cfgplot.AntiAlias:=true;
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
def_cfgplot.plaplot:=2;
def_cfgplot.TransparentPlanet:=false;
def_cfgplot.AutoSkycolor:=false;
def_cfgplot.DSOColorFillAst:=true;
def_cfgplot.DSOColorFillOCl:=true;
def_cfgplot.DSOColorFillGCl:=true;
def_cfgplot.DSOColorFillPNe:=true;
def_cfgplot.DSOColorFillDN:=true;
def_cfgplot.DSOColorFillEN:=true;
def_cfgplot.DSOColorFillRN:=true;
def_cfgplot.DSOColorFillSN:=true;
def_cfgplot.DSOColorFillGxy:=true;
def_cfgplot.DSOColorFillGxyCl:=true;
def_cfgplot.DSOColorFillQ:=true;
def_cfgplot.DSOColorFillGL:=true;
def_cfgplot.DSOColorFillNE:=true;
def_cfgsc.BGalpha:=200;
def_cfgsc.BGmin_sigma:=0;
def_cfgsc.BGmax_sigma:=0;
def_cfgsc.NEBmin_sigma:=0;
def_cfgsc.NEBmax_sigma:=0;
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
def_cfgsc.ObsTZ := '';
def_cfgsc.ObsTemperature := 10 ;
def_cfgsc.ObsPressure := 1010 ;
def_cfgsc.ObsName := 'Geneva' ;
def_cfgsc.countrytz := true;
def_cfgsc.ObsCountry := 'Switzerland' ;
def_cfgsc.horizonopaque:=true;
def_cfgsc.ShowScale:=false;
def_cfgsc.FillHorizon:=true;
def_cfgsc.ShowHorizon:=false;
def_cfgsc.ShowHorizonDepression:=false;
def_cfgsc.HorizonMax:=0;
def_cfgsc.CoordExpertMode:=false;
def_cfgsc.CoordType:=0;
def_cfgsc.PMon:=true;
def_cfgsc.DrawPMon:=false;
def_cfgsc.DrawPMyear:=5000;
def_cfgsc.ApparentPos:=true;
def_cfgsc.ShowEqGrid:=false;
def_cfgsc.ShowGrid:=true;
def_cfgsc.ShowGridNum:=true;
def_cfgsc.ShowOnlyMeridian:=false;
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
def_cfgsc.OptimizeLabels:=true;
def_cfgsc.StyleGrid:=psSolid;
def_cfgsc.StyleEqGrid:=psSolid;
def_cfgsc.StyleConstL:=psSolid;
def_cfgsc.StyleConstB:=psSolid;
def_cfgsc.StyleEcliptic:=psSolid;
def_cfgsc.StyleGalEq:=psSolid;
def_cfgsc.Simnb:=1;
def_cfgsc.SimLabel:=3;
def_cfgsc.SimNameLabel:=true;
def_cfgsc.SimDateLabel:=true;
def_cfgsc.SimDateYear:=true;
def_cfgsc.SimDateMonth:=true;
def_cfgsc.SimDateDay:=true;
def_cfgsc.SimDateHour:=true;
def_cfgsc.SimDateMinute:=true;
def_cfgsc.SimDateSecond:=false;
def_cfgsc.SimMagLabel:=false;
def_cfgsc.ShowLegend:=false;
def_cfgsc.SimD:=1;
def_cfgsc.SimH:=0;
def_cfgsc.SimM:=0;
def_cfgsc.SimS:=0;
def_cfgsc.SimLine:=True;
for i:=1 to NumSimObject do def_cfgsc.SimObject[i]:=true;
def_cfgsc.sunurlname:=URL_SUN_NAME[1];
def_cfgsc.sunurl:=URL_SUN[1];
def_cfgsc.sunurlsize:=URL_SUN_SIZE[1];
def_cfgsc.sunurlmargin:=URL_SUN_MARGIN[1];
def_cfgsc.sunrefreshtime:=24;
def_cfgsc.SunOnline:=false;
def_cfgsc.ShowPlanet:=true;
def_cfgsc.ShowPluto:=true;
def_cfgsc.ShowAsteroid:=true;
def_cfgsc.DSLforcecolor:=false;
def_cfgsc.DSLcolor:=0;
def_cfgsc.ShowImages:=true;
def_cfgsc.ShowBackgroundImage:=false;
def_cfgsc.BackgroundImage:='';
def_cfgsc.AstSymbol:=0;
def_cfgsc.AstmagMax:=18;
def_cfgsc.AstmagDiff:=6;
def_cfgsc.AstNEO:=true;
def_cfgsc.ShowComet:=true;
def_cfgsc.ShowArtSat:=false;
def_cfgsc.NewArtSat:=false;
def_cfgsc.ComSymbol:=1;
def_cfgsc.CommagMax:=18;
def_cfgsc.CommagDiff:=4;
def_cfgsc.MagLabel:=false;
def_cfgsc.NameLabel:=false;
def_cfgsc.ConstFullLabel:=true;
def_cfgsc.DrawAllStarLabel:=false;
def_cfgsc.MovedLabelLine:=true;
def_cfgsc.ConstLatinLabel:=false;
def_cfgsc.PlanetParalaxe:=true;
def_cfgsc.ShowEarthShadow:=false;
def_cfgsc.GRSlongitude:=168.0;
def_cfgsc.GRSjd:=jd(2011,7,15,0);
def_cfgsc.GRSdrift:=15.2/365.25;
def_cfgsc.LabelOrientation:=1;
def_cfgsc.FindOk:=false;
def_cfgsc.nummodlabels:=0;
def_cfgsc.posmodlabels:=0;
def_cfgsc.numcustomlabels:=0;
def_cfgsc.poscustomlabels:=0;
for i:=1 to 10 do def_cfgsc.circle[i,1]:=0;
for i:=1 to 10 do def_cfgsc.circle[i,2]:=0;
for i:=1 to 10 do def_cfgsc.circle[i,3]:=0;
for i:=1 to 10 do def_cfgsc.circle[i,4]:=0;
for i:=1 to 10 do def_cfgsc.circleok[i]:=false;
for i:=1 to 10 do def_cfgsc.circlelbl[i]:='';
for i:=1 to 10 do def_cfgsc.rectangle[i,1]:=0;
for i:=1 to 10 do def_cfgsc.rectangle[i,2]:=0;
for i:=1 to 10 do def_cfgsc.rectangle[i,3]:=0;
for i:=1 to 10 do def_cfgsc.rectangle[i,4]:=0;
for i:=1 to 10 do def_cfgsc.rectangle[i,5]:=0;
for i:=1 to 10 do def_cfgsc.rectangleok[i]:=false;
for i:=1 to 10 do def_cfgsc.rectanglelbl[i]:='';
def_cfgsc.CircleLabel:=true;
def_cfgsc.RectangleLabel:=true;
def_cfgsc.marknumlabel:=true;
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
def_cfgsc.IndiDriver:='indi_lx200basic';
def_cfgsc.IndiPort:='/dev/ttyS0';
def_cfgsc.IndiDevice:='LX200 Basic';
def_cfgsc.IndiTelescope:=false;
def_cfgsc.ASCOMTelescope:=false;
def_cfgsc.LX200Telescope:=false;
def_cfgsc.EncoderTelescope:=false;
def_cfgsc.ManualTelescope:=false;
{$ifdef unix}
   def_cfgsc.ManualTelescope:=true;
{$endif}
{$ifdef mswindows}
   def_cfgsc.ASCOMTelescope:=true;
{$endif}
def_cfgsc.ManualTelescopeType:=0;
def_cfgsc.TelescopeTurnsX:=6;    // Vixen GP
def_cfgsc.TelescopeTurnsY:=0.4;
def_cfgsc.TelescopeJD:=0;
catalog.cfgshr.ListStar:=false;
catalog.cfgshr.ListNeb:=true;
catalog.cfgshr.ListVar:=true;
catalog.cfgshr.ListDbl:=true;
catalog.cfgshr.ListPla:=true;
catalog.cfgshr.AzNorth:=true;
catalog.cfgshr.EquinoxType:=2;
catalog.cfgshr.EquinoxChart:=rsDate;
catalog.cfgshr.DefaultJDchart:=jd2000;
catalog.cfgshr.StarFilter:=true;
catalog.cfgshr.AutoStarFilter:=true;
catalog.cfgshr.AutoStarFilterMag:=6.5;
catalog.cfgcat.StarmagMax:=12;
catalog.cfgshr.NebFilter:=true;
catalog.cfgshr.BigNebFilter:=true;
catalog.cfgshr.BigNebLimit:=211;
catalog.cfgshr.NoFilterMessier:=true;
catalog.cfgcat.NebmagMax:=12;
catalog.cfgcat.NebSizeMin:=1;
catalog.cfgcat.UseUSNOBrightStars:=false;
catalog.cfgcat.UseGSVSIr:=false;
SetLength(catalog.cfgcat.UserObjects,1);
catalog.cfgcat.UserObjects[0].active:=false;
catalog.cfgcat.UserObjects[0].oname:='NGP';
catalog.cfgcat.UserObjects[0].otype:=14;
catalog.cfgcat.UserObjects[0].ra:=3.36601290658;
catalog.cfgcat.UserObjects[0].dec:=0.473478737245;
catalog.cfgcat.UserObjects[0].mag:=0;
catalog.cfgcat.UserObjects[0].size:=30;
catalog.cfgcat.UserObjects[0].color:=0;
catalog.cfgcat.UserObjects[0].comment:=rsExampleOfUse;
catalog.cfgcat.GCatNum:=0;
SetLength(catalog.cfgcat.GCatLst,catalog.cfgcat.GCatNum);
for i:=1 to maxstarcatalog do begin
   catalog.cfgcat.starcatpath[i]:='cat';
   catalog.cfgcat.starcatdef[i]:=false;
   catalog.cfgcat.starcaton[i]:=false;
   catalog.cfgcat.starcatfield[i,1]:=0;
   catalog.cfgcat.starcatfield[i,2]:=0;
end;
catalog.cfgcat.starcatpath[DefStar-BaseStar]:=catalog.cfgcat.starcatpath[DefStar-BaseStar]+PathDelim+'xhip';
catalog.cfgcat.starcatdef[DefStar-BaseStar]:=true;
catalog.cfgcat.starcatfield[DefStar-BaseStar,2]:=10;
catalog.cfgcat.starcatdef[vostar-BaseStar]:=false;
catalog.cfgcat.starcatfield[vostar-BaseStar,2]:=10;
catalog.cfgcat.starcatpath[bsc-BaseStar]:=catalog.cfgcat.starcatpath[bsc-BaseStar]+PathDelim+'bsc5';
catalog.cfgcat.starcatfield[bsc-BaseStar,2]:=10;
catalog.cfgcat.starcatpath[sky2000-BaseStar]:=catalog.cfgcat.starcatpath[sky2000-BaseStar]+PathDelim+'sky2000';
catalog.cfgcat.starcatfield[sky2000-BaseStar,1]:=6;
catalog.cfgcat.starcatfield[sky2000-BaseStar,2]:=7;
catalog.cfgcat.starcatpath[tyc2-BaseStar]:=catalog.cfgcat.starcatpath[tyc2-BaseStar]+PathDelim+'tycho2';
catalog.cfgcat.starcatfield[tyc2-BaseStar,1]:=0;
catalog.cfgcat.starcatfield[tyc2-BaseStar,2]:=5;
catalog.cfgcat.starcatpath[gscf-BaseStar]:=catalog.cfgcat.starcatpath[gscf-BaseStar]+PathDelim+'gsc';
catalog.cfgcat.starcatfield[gscf-BaseStar,1]:=0;
catalog.cfgcat.starcatfield[gscf-BaseStar,2]:=3;
catalog.cfgcat.starcatpath[gscc-BaseStar]:=catalog.cfgcat.starcatpath[gscc-BaseStar]+PathDelim+'gsc';
catalog.cfgcat.starcatfield[gscc-BaseStar,1]:=0;
catalog.cfgcat.starcatfield[gscc-BaseStar,2]:=3;
catalog.cfgcat.starcatpath[usnoa-BaseStar]:=catalog.cfgcat.starcatpath[usnoa-BaseStar]+PathDelim+'usnoa';
catalog.cfgcat.starcatfield[usnoa-BaseStar,1]:=0;
catalog.cfgcat.starcatfield[usnoa-BaseStar,2]:=1;
catalog.cfgcat.starcatpath[dsbase-BaseStar]:='C:\Program Files\Deepsky Astronomy Software';
catalog.cfgcat.starcatfield[dsbase-BaseStar,1]:=0;
catalog.cfgcat.starcatfield[dsbase-BaseStar,2]:=10;
catalog.cfgcat.starcatpath[dstyc-BaseStar]:='C:\Program Files\Deepsky Astronomy Software\SuperTycho';
catalog.cfgcat.starcatfield[dstyc-BaseStar,1]:=0;
catalog.cfgcat.starcatfield[dstyc-BaseStar,2]:=5;
catalog.cfgcat.starcatpath[dsgsc-BaseStar]:='C:\Program Files\Deepsky Astronomy Software\HGC';
catalog.cfgcat.starcatfield[dsgsc-BaseStar,1]:=0;
catalog.cfgcat.starcatfield[dsgsc-BaseStar,2]:=3;
for i:=1 to maxvarstarcatalog do begin
   catalog.cfgcat.varstarcatpath[i]:='cat';
   catalog.cfgcat.varstarcatdef[i]:=false;
   catalog.cfgcat.varstarcaton[i]:=false;
   catalog.cfgcat.varstarcatfield[i,1]:=0;
   catalog.cfgcat.varstarcatfield[i,2]:=0;
end;
catalog.cfgcat.varstarcatpath[gcvs-BaseVar]:=catalog.cfgcat.varstarcatpath[gcvs-BaseVar]+PathDelim+'gcvs';
catalog.cfgcat.varstarcatfield[gcvs-BaseVar,1]:=0;
catalog.cfgcat.varstarcatfield[gcvs-BaseVar,2]:=10;
for i:=1 to maxdblstarcatalog do begin
   catalog.cfgcat.dblstarcatpath[i]:='cat';
   catalog.cfgcat.dblstarcatdef[i]:=false;
   catalog.cfgcat.dblstarcaton[i]:=false;
   catalog.cfgcat.dblstarcatfield[i,1]:=0;
   catalog.cfgcat.dblstarcatfield[i,2]:=0;
end;
catalog.cfgcat.dblstarcatpath[wds-BaseDbl]:=catalog.cfgcat.dblstarcatpath[wds-BaseDbl]+PathDelim+'wds';
catalog.cfgcat.dblstarcatfield[wds-BaseDbl,1]:=0;
catalog.cfgcat.dblstarcatfield[wds-BaseDbl,2]:=10;
for i:=1 to maxnebcatalog do begin
   catalog.cfgcat.nebcatpath[i]:='cat';
   catalog.cfgcat.nebcatdef[i]:=false;
   catalog.cfgcat.nebcaton[i]:=false;
   catalog.cfgcat.nebcatfield[i,1]:=0;
   catalog.cfgcat.nebcatfield[i,2]:=0;
end;
catalog.cfgcat.nebcatdef[uneb-BaseNeb]:=false;
catalog.cfgcat.nebcatfield[uneb-BaseNeb,2]:=10;
catalog.cfgcat.nebcatdef[voneb-BaseNeb]:=false;
catalog.cfgcat.nebcatfield[voneb-BaseNeb,2]:=10;
catalog.cfgcat.nebcatpath[sac-BaseNeb]:='cat'+PathDelim+'sac';
catalog.cfgcat.nebcatdef[sac-BaseNeb]:=true;
catalog.cfgcat.nebcatfield[sac-BaseNeb,2]:=10;
catalog.cfgcat.nebcatpath[ngc-BaseNeb]:='cat'+PathDelim+'ngc2000';
catalog.cfgcat.nebcatfield[ngc-BaseNeb,2]:=10;
catalog.cfgcat.nebcatpath[lbn-BaseNeb]:='cat'+PathDelim+'lbn';
catalog.cfgcat.nebcatfield[lbn-BaseNeb,2]:=5;
catalog.cfgcat.nebcatpath[rc3-BaseNeb]:='cat'+PathDelim+'rc3';
catalog.cfgcat.nebcatfield[rc3-BaseNeb,2]:=5;
catalog.cfgcat.nebcatpath[pgc-BaseNeb]:='cat'+PathDelim+'pgc';
catalog.cfgcat.nebcatfield[pgc-BaseNeb,2]:=5;
catalog.cfgcat.nebcatpath[ocl-BaseNeb]:='cat'+PathDelim+'ocl';
catalog.cfgcat.nebcatfield[ocl-BaseNeb,2]:=5;
catalog.cfgcat.nebcatpath[gcm-BaseNeb]:='cat'+PathDelim+'gcm';
catalog.cfgcat.nebcatfield[gcm-BaseNeb,2]:=5;
catalog.cfgcat.nebcatpath[gpn-BaseNeb]:='cat'+PathDelim+'gpn';
catalog.cfgcat.nebcatfield[gpn-BaseNeb,2]:=5;
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
catalog.cfgshr.ShowCRose:=false;
catalog.cfgshr.CRoseSz:=80;
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
def_cfgsc.projname[0]:='TAN';
def_cfgsc.projname[1]:='TAN';
def_cfgsc.projname[2]:='TAN';
def_cfgsc.projname[3]:='TAN';
def_cfgsc.projname[4]:='TAN';
def_cfgsc.projname[5]:='TAN';
def_cfgsc.projname[6]:='TAN';
def_cfgsc.projname[7]:='TAN';
def_cfgsc.projname[8]:='MER';
def_cfgsc.projname[9]:='MER';
def_cfgsc.projname[10]:='MER';
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
catalog.cfgshr.NebMagFilter[4]:=20;
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

procedure Tf_main.ReadChartConfig(filename:string; usecatalog,resizemain:boolean; var cplot:Tconf_plot ;var csc:Tconf_skychart);
var i,j,t,l,w,h,n:integer;
    inif: TMemIniFile;
    section,buf : string;
begin
inif:=TMeminifile.create(filename);
try
with inif do begin
section:='main';
try
if resizemain then begin
  t := ReadInteger(section,'WinTop',f_main.Top);
  l := ReadInteger(section,'WinLeft',f_main.Left);
  w := ReadInteger(section,'WinWidth',f_main.Width);
  h := ReadInteger(section,'WinHeight',f_main.Height);
  if w>screen.Width then begin
    l:=0;
    w:=screen.Width-80;
  end;
  if h>screen.Height then begin
    t:=0;
    h:=screen.Height-80;
  end;
  f_main.SetBounds(l,t,w,h);
end;
for i:=0 to MaxField do catalog.cfgshr.FieldNum[i]:=ReadFloat(section,'FieldNum'+inttostr(i),catalog.cfgshr.FieldNum[i]);
except
  ShowError('Error reading '+filename+' chart main');
end;
try
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
except
  ShowError('Error reading '+filename+' font');
end;
try
section:='filter';
catalog.cfgshr.StarFilter:=ReadBool(section,'StarFilter',catalog.cfgshr.StarFilter);
catalog.cfgshr.AutoStarFilter:=ReadBool(section,'AutoStarFilter',catalog.cfgshr.AutoStarFilter);
catalog.cfgshr.AutoStarFilterMag:=ReadFloat(section,'AutoStarFilterMag',catalog.cfgshr.AutoStarFilterMag);
catalog.cfgshr.NebFilter:=ReadBool(section,'NebFilter',catalog.cfgshr.NebFilter);
catalog.cfgshr.BigNebFilter:=ReadBool(section,'BigNebFilter',catalog.cfgshr.BigNebFilter);
catalog.cfgshr.BigNebLimit:=ReadFloat(section,'BigNebLimit',catalog.cfgshr.BigNebLimit);
catalog.cfgshr.NoFilterMessier:=ReadBool(section,'NoFilterMessier',catalog.cfgshr.NoFilterMessier);
for i:=1 to maxfield do begin
   catalog.cfgshr.StarMagFilter[i]:=ReadFloat(section,'StarMagFilter'+inttostr(i),catalog.cfgshr.StarMagFilter[i]);
   catalog.cfgshr.NebMagFilter[i]:=ReadFloat(section,'NebMagFilter'+inttostr(i),catalog.cfgshr.NebMagFilter[i]);
   catalog.cfgshr.NebSizeFilter[i]:=ReadFloat(section,'NebSizeFilter'+inttostr(i),catalog.cfgshr.NebSizeFilter[i]);
end;
except
  ShowError('Error reading '+filename+' filter');
end;
if usecatalog then begin
try
section:='catalog';
catalog.cfgcat.GCatNum:=Readinteger(section,'GCatNum',0);
SetLength(catalog.cfgcat.GCatLst,catalog.cfgcat.GCatNum);
j:=-1;
for i:=0 to catalog.cfgcat.GCatNum-1 do begin
   inc(j);
   catalog.cfgcat.GCatLst[j].shortname:=Readstring(section,'CatName'+inttostr(i),catalog.cfgcat.GCatLst[i].shortname);
   if catalog.cfgcat.GCatLst[j].shortname='dsl' then begin
      dec(j);
      continue;
   end;
   catalog.cfgcat.GCatLst[j].name:=Readstring(section,'CatLongName'+inttostr(i),catalog.cfgcat.GCatLst[i].name);
   catalog.cfgcat.GCatLst[j].path:=ExtractSubPath(ConfigAppdir,Readstring(section,'CatPath'+inttostr(i),catalog.cfgcat.GCatLst[i].path));
   catalog.cfgcat.GCatLst[j].min:=ReadFloat(section,'CatMin'+inttostr(i),catalog.cfgcat.GCatLst[i].min);
   catalog.cfgcat.GCatLst[j].max:=ReadFloat(section,'CatMax'+inttostr(i),catalog.cfgcat.GCatLst[i].max);
   catalog.cfgcat.GCatLst[j].Actif:=ReadBool(section,'CatActif'+inttostr(i),catalog.cfgcat.GCatLst[i].Actif);
   catalog.cfgcat.GCatLst[j].ForceColor:=ReadBool(section,'CatForceColor'+inttostr(i),false);
   catalog.cfgcat.GCatLst[j].Col:=ReadInteger(section,'CatColor'+inttostr(i),0);
   catalog.cfgcat.GCatLst[j].magmax:=0;
   catalog.cfgcat.GCatLst[j].cattype:=0;
   if catalog.cfgcat.GCatLst[j].Actif then begin
      if not
      catalog.GetInfo(catalog.cfgcat.GCatLst[j].path,
                      catalog.cfgcat.GCatLst[j].shortname,
                      catalog.cfgcat.GCatLst[j].magmax,
                      catalog.cfgcat.GCatLst[j].cattype,
                      catalog.cfgcat.GCatLst[j].version,
                      catalog.cfgcat.GCatLst[j].name)
      then catalog.cfgcat.GCatLst[j].Actif:=false;
   end;
end;
catalog.cfgcat.GCatNum:=j+1;
SetLength(catalog.cfgcat.GCatLst,catalog.cfgcat.GCatNum);
n:=Length(catalog.cfgcat.UserObjects);
n:=Readinteger(section,'UserObjectsNum',n);
SetLength(catalog.cfgcat.UserObjects,n);
for i:=0 to n-1 do begin
   catalog.cfgcat.UserObjects[i].active:=ReadBool(section,'UObjActive'+inttostr(i),catalog.cfgcat.UserObjects[i].active);
   catalog.cfgcat.UserObjects[i].otype:=ReadInteger(section,'UObjType'+inttostr(i),catalog.cfgcat.UserObjects[i].otype);
   catalog.cfgcat.UserObjects[i].oname:=ReadString(section,'UObjName'+inttostr(i),catalog.cfgcat.UserObjects[i].oname);
   catalog.cfgcat.UserObjects[i].ra:=ReadFloat(section,'UObjRA'+inttostr(i),catalog.cfgcat.UserObjects[i].ra);
   catalog.cfgcat.UserObjects[i].dec:=ReadFloat(section,'UObjDEC'+inttostr(i),catalog.cfgcat.UserObjects[i].dec);
   catalog.cfgcat.UserObjects[i].mag:=ReadFloat(section,'UObjMag'+inttostr(i),catalog.cfgcat.UserObjects[i].mag);
   catalog.cfgcat.UserObjects[i].size:=ReadFloat(section,'UObjSize'+inttostr(i),catalog.cfgcat.UserObjects[i].size);
   catalog.cfgcat.UserObjects[i].color:=ReadInteger(section,'UObjColor'+inttostr(i),catalog.cfgcat.UserObjects[i].color);
   catalog.cfgcat.UserObjects[i].comment:=ReadString(section,'UObjComment'+inttostr(i),catalog.cfgcat.UserObjects[i].comment);
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
if pos('bsc5',catalog.cfgcat.starcatpath[DefStar-BaseStar])>0 then begin    // Upgrade to new default catalog
  catalog.cfgcat.starcatpath[DefStar-BaseStar]:=slash('cat')+'xhip';
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
except
  ShowError('Error reading '+filename+' chart catalog');
end;
end;
try
section:='display';
cplot.AntiAlias:=ReadBool(section,'AntiAlias',cplot.AntiAlias);
cplot.starplot:=ReadInteger(section,'starplot',cplot.starplot);
cplot.nebplot:=ReadInteger(section,'nebplot',cplot.nebplot);
cplot.TransparentPlanet:=ReadBool(section,'TransparentPlanet',cplot.TransparentPlanet);
cplot.plaplot:=ReadInteger(section,'plaplot',cplot.plaplot);
cplot.Nebgray:=ReadInteger(section,'Nebgray',cplot.Nebgray);
cplot.NebBright:=ReadInteger(section,'NebBright',cplot.NebBright);
cplot.stardyn:=ReadInteger(section,'StarDyn',cplot.stardyn);
cplot.starsize:=ReadInteger(section,'StarSize',cplot.starsize);
cplot.contrast:=ReadInteger(section,'contrast',cplot.contrast);
cplot.saturation:=ReadInteger(section,'saturation',cplot.saturation);
cplot.red_move:=ReadBool(section,'redmove',cplot.red_move);
cplot.partsize:=ReadFloat(section,'partsize',cplot.partsize);
cplot.partsize:=max(cplot.partsize,0.1);
cplot.partsize:=min(cplot.partsize,5.0);
cplot.magsize:=ReadFloat(section,'magsize',cplot.magsize);
cplot.magsize:=max(cplot.magsize,1.0);
cplot.magsize:=min(cplot.magsize,10.0);
cplot.AutoSkycolor:=ReadBool(section,'AutoSkycolor',cplot.AutoSkycolor);
cplot.DSOColorFillAst:=ReadBool(section,'DSOColorFillAst',cplot.DSOColorFillAst);
cplot.DSOColorFillOCl:=ReadBool(section,'DSOColorFillOCl',cplot.DSOColorFillOCl);
cplot.DSOColorFillGCl:=ReadBool(section,'DSOColorFillGCl',cplot.DSOColorFillGCl);
cplot.DSOColorFillPNe:=ReadBool(section,'DSOColorFillPNe',cplot.DSOColorFillPNe);
cplot.DSOColorFillDN:=ReadBool(section,'DSOColorFillDN',cplot.DSOColorFillDN);
cplot.DSOColorFillEN:=ReadBool(section,'DSOColorFillEN',cplot.DSOColorFillEN);
cplot.DSOColorFillRN:=ReadBool(section,'DSOColorFillRN',cplot.DSOColorFillRN);
cplot.DSOColorFillSN:=ReadBool(section,'DSOColorFillSN',cplot.DSOColorFillSN);
cplot.DSOColorFillGxy:=ReadBool(section,'DSOColorFillGxy',cplot.DSOColorFillGxy);
cplot.DSOColorFillGxyCl:=ReadBool(section,'DSOColorFillGxyCl',cplot.DSOColorFillGxyCl);
cplot.DSOColorFillQ:=ReadBool(section,'DSOColorFillQ',cplot.DSOColorFillQ);
cplot.DSOColorFillGL:=ReadBool(section,'DSOColorFillGL',cplot.DSOColorFillGL);
cplot.DSOColorFillNE:=ReadBool(section,'DSOColorFillNE',cplot.DSOColorFillNE);
for i:=0 to maxcolor do cplot.color[i]:=ReadInteger(section,'color'+inttostr(i),cplot.color[i]);
for i:=0 to 7 do cplot.skycolor[i]:=ReadInteger(section,'skycolor'+inttostr(i),cplot.skycolor[i]);
cplot.bgColor:=ReadInteger(section,'bgColor',cplot.bgColor);
except
  ShowError('Error reading '+filename+' display');
end;
try
section:='grid';
catalog.cfgshr.ShowCRose:=ReadBool(section,'ShowCRose',catalog.cfgshr.ShowCRose);
catalog.cfgshr.CRoseSz:=ReadInteger(section,'CRoseSz',catalog.cfgshr.CRoseSz);
for i:=0 to maxfield do catalog.cfgshr.HourGridSpacing[i]:=ReadFloat(section,'HourGridSpacing'+inttostr(i),catalog.cfgshr.HourGridSpacing[i] );
for i:=0 to maxfield do begin
  catalog.cfgshr.DegreeGridSpacing[i]:=ReadFloat(section,'DegreeGridSpacing'+inttostr(i),catalog.cfgshr.DegreeGridSpacing[i] );
  if catalog.cfgshr.DegreeGridSpacing[i]>1000 then catalog.cfgshr.DegreeGridSpacing[i]:=catalog.cfgshr.DegreeGridSpacing[i]-1000;
end;
except
  ShowError('Error reading '+filename+' grid');
end;
try
section:='Finder';
csc.ShowCircle:=ReadBool(section,'ShowCircle',csc.ShowCircle);
csc.CircleLabel:=ReadBool(section,'CircleLabel',csc.CircleLabel);
csc.RectangleLabel:=ReadBool(section,'RectangleLabel',csc.RectangleLabel);
csc.marknumlabel:=ReadBool(section,'marknumlabel',csc.marknumlabel);
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
except
  ShowError('Error reading '+filename+' Finder');
end;
try
section:='chart';
catalog.cfgshr.EquinoxType:=ReadInteger(section,'EquinoxType',catalog.cfgshr.EquinoxType);
catalog.cfgshr.EquinoxChart:=ReadString(section,'EquinoxChart',catalog.cfgshr.EquinoxChart);
catalog.cfgshr.DefaultJDchart:=ReadFloat(section,'DefaultJDchart',catalog.cfgshr.DefaultJDchart);
except
  ShowError('Error reading '+filename+' chart');
end;
try
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
csc.fov:=max(csc.fov,secarc);
csc.fov:=min(csc.fov,pi2);
csc.theta:=ReadFloat(section,'theta',csc.theta);
buf:=trim(ReadString(section,'projtype',csc.projtype))+'A';
csc.projtype:=buf[1];
csc.ProjPole:=ReadInteger(section,'ProjPole',csc.ProjPole);
csc.FlipX:=ReadInteger(section,'FlipX',csc.FlipX);
csc.FlipY:=ReadInteger(section,'FlipY',csc.FlipY);
if csc.FlipY<0 then csc.FlipX:=1;
csc.CoordExpertMode:=ReadBool(section,'CoordExpertMode',csc.CoordExpertMode);
csc.PMon:=ReadBool(section,'PMon',csc.PMon);
csc.YPMon:=ReadFloat(section,'YPMon',csc.YPMon);
csc.DrawPMon:=ReadBool(section,'DrawPMon',csc.DrawPMon);
csc.ApparentPos:=ReadBool(section,'ApparentPos',csc.ApparentPos);
csc.CoordType:=ReadInteger(section,'CoordType',csc.CoordType);
csc.DrawPMyear:=ReadInteger(section,'DrawPMyear',csc.DrawPMyear);
csc.horizonopaque:=ReadBool(section,'horizonopaque',csc.horizonopaque);
csc.ShowHorizon:=ReadBool(section,'ShowHorizon',csc.ShowHorizon);
csc.FillHorizon:=ReadBool(section,'FillHorizon',csc.FillHorizon);
csc.ShowHorizonDepression:=ReadBool(section,'ShowHorizonDepression',csc.ShowHorizonDepression);
csc.ShowEqGrid:=ReadBool(section,'ShowEqGrid',csc.ShowEqGrid);
csc.ShowLabelAll:=ReadBool(section,'ShowLabelAll',csc.ShowLabelAll);
csc.EditLabels:=ReadBool(section,'EditLabels',csc.EditLabels);
csc.OptimizeLabels:=ReadBool(section,'OptimizeLabels',csc.OptimizeLabels);
csc.ShowGrid:=ReadBool(section,'ShowGrid',csc.ShowGrid);
csc.ShowGridNum:=ReadBool(section,'ShowGridNum',csc.ShowGridNum);
csc.ShowOnlyMeridian:=ReadBool(section,'ShowOnlyMeridian',csc.ShowOnlyMeridian);
csc.ShowConstL:=ReadBool(section,'ShowConstL',csc.ShowConstL);
csc.ShowConstB:=ReadBool(section,'ShowConstB',csc.ShowConstB);
csc.ShowEcliptic:=ReadBool(section,'ShowEcliptic',csc.ShowEcliptic);
csc.ShowGalactic:=ReadBool(section,'ShowGalactic',csc.ShowGalactic); 
csc.ShowMilkyWay:=ReadBool(section,'ShowMilkyWay',csc.ShowMilkyWay);
csc.FillMilkyWay:=ReadBool(section,'FillMilkyWay',csc.FillMilkyWay);
csc.sunurlname:=ReadString(section,'URL_SUN_NAME',csc.sunurlname);
csc.sunurl:=ReadString(section,'URL_SUN',csc.sunurl);
csc.sunurlsize:=ReadInteger(section,'URL_SUN_SIZE',csc.sunurlsize);
csc.sunurlmargin:=ReadInteger(section,'URL_SUN_MARGIN',csc.sunurlmargin);
csc.sunrefreshtime:=ReadInteger(section,'SunRefreshTime',csc.sunrefreshtime);
csc.SunOnline:=ReadBool(section,'SunOnline',csc.SunOnline);
csc.ShowPluto:=ReadBool(section,'ShowPluto',csc.ShowPluto);
csc.ShowPlanet:=ReadBool(section,'ShowPlanet',csc.ShowPlanet);
csc.ShowAsteroid:=ReadBool(section,'ShowAsteroid',csc.ShowAsteroid);
csc.ShowComet:=ReadBool(section,'ShowComet',csc.ShowComet);
csc.DSLforcecolor:=ReadBool(section,'DSLforcecolor',csc.DSLforcecolor);
csc.DSLcolor:=ReadInteger(section,'DSLcolor',csc.DSLcolor);
csc.ShowImages:=ReadBool(section,'ShowImages',csc.ShowImages);
csc.showstars:=ReadBool(section,'ShowStars',csc.showstars);
csc.shownebulae:=ReadBool(section,'ShowNebulae',csc.shownebulae);
csc.showline:=ReadBool(section,'ShowLine',csc.showline);
csc.ShowBackgroundImage:=ReadBool(section,'ShowBackgroundImage',csc.ShowBackgroundImage);
buf:=ReadString(section,'BackgroundImage',csc.BackgroundImage);
if (ConfigPrivateDir='')or(ConfigPrivateDir=PrivateDir)or(pos(ConfigPrivateDir,buf)=0) then
   csc.BackgroundImage:=buf
else begin
   buf:=ExtractSubPath(slash(ConfigPrivateDir),buf);
   csc.BackgroundImage:=slash(PrivateDir)+buf;
end;
csc.AstSymbol:=ReadInteger(section,'AstSymbol',csc.AstSymbol);
csc.AstmagMax:=ReadFloat(section,'AstmagMax',csc.AstmagMax);
csc.AstmagDiff:=ReadFloat(section,'AstmagDiff',csc.AstmagDiff);
csc.AstNEO:=ReadBool(section,'AstNEO',csc.AstNEO);
csc.ComSymbol:=ReadInteger(section,'ComSymbol',csc.ComSymbol);
csc.CommagMax:=ReadFloat(section,'CommagMax',csc.CommagMax);
csc.CommagDiff:=ReadFloat(section,'CommagDiff',csc.CommagDiff);
csc.MagLabel:=ReadBool(section,'MagLabel',csc.MagLabel);
csc.NameLabel:=ReadBool(section,'NameLabel',csc.NameLabel);
csc.DrawAllStarLabel:=ReadBool(section,'DrawAllStarLabel',csc.DrawAllStarLabel);
csc.MovedLabelLine:=ReadBool(section,'MovedLabelLine',csc.MovedLabelLine);
csc.ConstFullLabel:=ReadBool(section,'ConstFullLabel',csc.ConstFullLabel);
csc.ConstLatinLabel:=ReadBool(section,'ConstLatinLabel',csc.ConstLatinLabel);
csc.PlanetParalaxe:=ReadBool(section,'PlanetParalaxe',csc.PlanetParalaxe);
csc.ShowEarthShadow:=ReadBool(section,'ShowEarthShadow',csc.ShowEarthShadow);
csc.GRSlongitude:=ReadFloat(section,'GRSlongitude',csc.GRSlongitude);
csc.GRSjd:=ReadFloat(section,'GRSjd',csc.GRSjd);
csc.GRSdrift:=ReadFloat(section,'GRSdrift',csc.GRSdrift);
csc.StyleGrid:=TPenStyle(ReadInteger(section,'StyleGrid',ord(csc.StyleGrid)));
csc.StyleEqGrid:=TPenStyle(ReadInteger(section,'StyleEqGrid',ord(csc.StyleEqGrid)));
csc.StyleConstL:=TPenStyle(ReadInteger(section,'StyleConstL',ord(csc.StyleConstL)));
csc.StyleConstB:=TPenStyle(ReadInteger(section,'StyleConstB',ord(csc.StyleConstB)));
csc.StyleEcliptic:=TPenStyle(ReadInteger(section,'StyleEcliptic',ord(csc.StyleEcliptic)));
csc.StyleGalEq:=TPenStyle(ReadInteger(section,'StyleGalEq',ord(csc.StyleGalEq)));
csc.BGalpha:=ReadInteger(section,'BGalpha',csc.BGalpha);
csc.BGmin_sigma:=ReadFloat(section,'BGmin_sigma',csc.BGmin_sigma);
csc.BGmax_sigma:=ReadFloat(section,'BGmax_sigma',csc.BGmax_sigma);
csc.NEBmin_sigma:=ReadFloat(section,'NEBmin_sigma',csc.NEBmin_sigma);
csc.NEBmax_sigma:=ReadFloat(section,'NEBmax_sigma',csc.NEBmax_sigma);
csc.Simnb:=ReadInteger(section,'Simnb',csc.Simnb);
csc.SimLabel:=ReadInteger(section,'SimLabel',csc.SimLabel);
if csc.SimLabel>3 then csc.SimLabel:=3;
csc.SimNameLabel:=ReadBool(section,'SimNameLabel',csc.SimNameLabel);
csc.SimDateLabel:=ReadBool(section,'SimDateLabel',csc.SimDateLabel);
csc.SimDateYear:=ReadBool(section,'SimDateYear',csc.SimDateYear);
csc.SimDateMonth:=ReadBool(section,'SimDateMonth',csc.SimDateMonth);
csc.SimDateDay:=ReadBool(section,'SimDateDay',csc.SimDateDay);
csc.SimDateHour:=ReadBool(section,'SimDateHour',csc.SimDateHour);
csc.SimDateMinute:=ReadBool(section,'SimDateMinute',csc.SimDateMinute);
csc.SimDateSecond:=ReadBool(section,'SimDateSecond',csc.SimDateSecond);
csc.SimMagLabel:=ReadBool(section,'SimMagLabel',csc.SimMagLabel);
csc.ShowLegend:=ReadBool(section,'ShowLegend',csc.ShowLegend);
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
csc.TrackOn:=ReadBool(section,'TrackOn',csc.TrackOn);
csc.TrackType:=ReadInteger(section,'TrackType',csc.TrackType);
csc.TrackObj:=ReadInteger(section,'TrackObj',csc.TrackObj);
csc.TrackDec:=ReadFloat(section,'TrackDec',csc.TrackDec);
csc.TrackRA:=ReadFloat(section,'TrackRA',csc.TrackRA);
csc.TrackEpoch:=ReadFloat(section,'TrackEpoch',csc.TrackEpoch);
csc.TrackName:=ReadString(section,'TrackName',csc.TrackName);
except
  ShowError('Error reading '+filename+' default chart');
end;
try
section:='observatory';
csc.ObsLatitude := ReadFloat(section,'ObsLatitude',csc.ObsLatitude );
csc.ObsLongitude := ReadFloat(section,'ObsLongitude',csc.ObsLongitude );
csc.ObsAltitude := ReadFloat(section,'ObsAltitude',csc.ObsAltitude );
csc.ObsTemperature := ReadFloat(section,'ObsTemperature',csc.ObsTemperature );
csc.ObsPressure := ReadFloat(section,'ObsPressure',csc.ObsPressure );
csc.ObsName := Condutf8decode(ReadString(section,'ObsName',csc.ObsName ));
csc.ObsCountry := ReadString(section,'ObsCountry',csc.ObsCountry );
csc.ObsTZ := ReadString(section,'ObsTZ',csc.ObsTZ );
csc.countrytz := ReadBool(section,'countrytz',csc.countrytz );
except
  ShowError('Error reading '+filename+' observatory');
end;
try
section:='date';
csc.UseSystemTime:=ReadBool(section,'UseSystemTime',csc.UseSystemTime);
csc.CurYear:=ReadInteger(section,'CurYear',csc.CurYear);
csc.CurMonth:=ReadInteger(section,'CurMonth',csc.CurMonth);
csc.CurDay:=ReadInteger(section,'CurDay',csc.CurDay);
csc.CurTime:=ReadFloat(section,'CurTime',csc.CurTime);
csc.autorefresh:=ReadBool(section,'autorefresh',csc.autorefresh);
csc.Force_DT_UT:=ReadBool(section,'Force_DT_UT',csc.Force_DT_UT);
csc.DT_UT_val:=ReadFloat(section,'DT_UT_val',csc.DT_UT_val);
except
  ShowError('Error reading '+filename+' date');
end;
try
section:='projection';
for i:=1 to maxfield do csc.projname[i]:=ReadString(section,'ProjName'+inttostr(i),csc.projname[i] );
except
  ShowError('Error reading '+filename+' projection');
end;
try
section:='labels';
csc.posmodlabels:=ReadInteger(section,'poslabels',0);
csc.nummodlabels:=ReadInteger(section,'numlabels',0);
for i:=1 to csc.nummodlabels do begin
   csc.modlabels[i].id:=ReadInteger(section,'labelid'+inttostr(i),0);
   csc.modlabels[i].dx:=ReadInteger(section,'labeldx'+inttostr(i),0);
   csc.modlabels[i].dy:=ReadInteger(section,'labeldy'+inttostr(i),0);
   csc.modlabels[i].ra:=ReadFloat(section,'labelra'+inttostr(i),0);
   csc.modlabels[i].dec:=ReadFloat(section,'labeldec'+inttostr(i),0);
   csc.modlabels[i].labelnum:=ReadInteger(section,'labelnum'+inttostr(i),1);
   csc.modlabels[i].fontnum:=ReadInteger(section,'labelfont'+inttostr(i),2);
   csc.modlabels[i].txt:=ReadString(section,'labeltxt'+inttostr(i),'');
   csc.modlabels[i].align:=TLabelAlign(ReadInteger(section,'labelalign'+inttostr(i),ord(laLeft)));
   csc.modlabels[i].useradec:=ReadBool(section,'labeluseradec'+inttostr(i),false);
   csc.modlabels[i].hiden:=ReadBool(section,'labelhiden'+inttostr(i),false);
end;
except
  ShowError('Error reading '+filename+' labels');
end;
try
section:='custom_labels';
csc.poscustomlabels:=ReadInteger(section,'poslabels',0);
csc.numcustomlabels:=ReadInteger(section,'numlabels',0);
for i:=1 to csc.numcustomlabels do begin
   csc.customlabels[i].ra:=ReadFloat(section,'labelra'+inttostr(i),0);
   csc.customlabels[i].dec:=ReadFloat(section,'labeldec'+inttostr(i),0);
   csc.customlabels[i].labelnum:=ReadInteger(section,'labelnum'+inttostr(i),7);
   csc.customlabels[i].txt:=ReadString(section,'labeltxt'+inttostr(i),'');
   csc.customlabels[i].align:=TLabelAlign(ReadInteger(section,'labelalign'+inttostr(i),ord(laLeft)));
end;
except
  ShowError('Error reading '+filename+' custom_labels');
end;
end;
try
csc.tz.TimeZoneFile:=ZoneDir+StringReplace(def_cfgsc.ObsTZ,'/',PathDelim,[rfReplaceAll]);
csc.tz.JD:=jd(csc.CurYear,csc.CurMonth,csc.CurDay,csc.CurTime);
csc.TimeZone:=csc.tz.SecondsOffset/3600;
if not csc.CoordExpertMode then begin
case csc.CoordType of
 0 : begin
       catalog.cfgshr.EquinoxType:=2;
       csc.ApparentPos:=true;
       csc.PMon:=true;
       csc.YPmon:=0;
       catalog.cfgshr.EquinoxChart:=rsDate;
       catalog.cfgshr.DefaultJDChart:=jd2000;
     end;
 1 : begin
       catalog.cfgshr.EquinoxType:=2;
       csc.ApparentPos:=false;
       csc.PMon:=true;
       csc.YPmon:=0;
       catalog.cfgshr.EquinoxChart:=rsDate;
       catalog.cfgshr.DefaultJDChart:=jd2000;
     end;
 2 : begin
       catalog.cfgshr.EquinoxType:=0;
       csc.ApparentPos:=false;
       csc.PMon:=true;
       csc.YPmon:=2000;
       catalog.cfgshr.EquinoxChart:='J2000';
       catalog.cfgshr.DefaultJDChart:=jd2000;
     end;
 3 : begin
       catalog.cfgshr.EquinoxType:=0;
       csc.ApparentPos:=false;
       csc.PMon:=true;
       csc.YPmon:=0;
       catalog.cfgshr.EquinoxChart:='J2000';
       catalog.cfgshr.DefaultJDChart:=jd2000;
     end;
end;
end;
except
  ShowError('Error reading '+filename+' coordinates initialization');
end;
finally
inif.Free;
end;
end;

procedure Tf_main.ReadPrivateConfig(filename:string);
var i,j:integer;
    inif: TMemIniFile;
    section,buf : string;
    obsdetail: TObsDetail;
begin
inif:=TMeminifile.create(filename);
try
with inif do begin
section:='main';
try
Config_Version:=ReadString(section,'version',cdcver);
SaveConfigOnExit.Checked:=ReadBool(section,'SaveConfigOnExit',SaveConfigOnExit.Checked);
ConfirmSaveConfig:=ReadBool(section,'ConfirmSaveConfig',ConfirmSaveConfig);
{$ifdef linux}
LinuxDesktop:=ReadInteger(section,'LinuxDesktop',LinuxDesktop);
if LinuxDesktop>1 then LinuxDesktop:=1;
OpenFileCMD:=ReadString(section,'OpenFileCMD',OpenFileCMD);
{$endif}
NightVision:=ReadBool(section,'NightVision',NightVision);
cfgm.SesameUrlNum:=ReadInteger(section,'SesameUrlNum',cfgm.SesameUrlNum);
cfgm.SesameCatNum:=ReadInteger(section,'SesameCatNum',cfgm.SesameCatNum);
cfgm.prtname:=ReadString(section,'prtname',cfgm.prtname);
cfgm.Paper:=ReadInteger(section,'Paper',cfgm.Paper);
cfgm.PrinterResolution:=ReadInteger(section,'PrinterResolution',cfgm.PrinterResolution);
cfgm.PrintColor:=ReadInteger(section,'PrintColor',cfgm.PrintColor);
cfgm.PrintLandscape:=ReadBool(section,'PrintLandscape',cfgm.PrintLandscape);
cfgm.PrintMethod:=ReadInteger(section,'PrintMethod',cfgm.PrintMethod);
cfgm.PrintCmd1:=ReadString(section,'PrintCmd1',cfgm.PrintCmd1);
cfgm.PrintCmd2:=ReadString(section,'PrintCmd2',cfgm.PrintCmd2);
cfgm.PrintTmpPath:=ReadString(section,'PrintTmpPath',cfgm.PrintTmpPath);;
cfgm.PrtLeftMargin:=ReadInteger(section,'PrtLeftMargin',cfgm.PrtLeftMargin);
cfgm.PrtRightMargin:=ReadInteger(section,'PrtRightMargin',cfgm.PrtRightMargin);
cfgm.PrtTopMargin:=ReadInteger(section,'PrtTopMargin',cfgm.PrtTopMargin);
cfgm.PrtBottomMargin:=ReadInteger(section,'PrtBottomMargin',cfgm.PrtBottomMargin);
cfgm.ThemeName:=ReadString(section,'Theme',cfgm.ThemeName);
cfgm.KioskPass:=ReadString(section,'KioskPass','');
cfgm.KioskDebug:=ReadBool(section,'KioskDebug',false);
cfgm.KioskMode:=(cfgm.KioskPass>'');
if (ReadBool(section,'WinMaximize',true)) then f_main.WindowState:=wsMaximized;
cfgm.autorefreshdelay:=ReadInteger(section,'autorefreshdelay',cfgm.autorefreshdelay);
buf:=ReadString(section,'ConstLfile',cfgm.ConstLfile);
buf:=ExtractSubPath(ConfigAppdir,buf);
if FileExists(buf) then cfgm.ConstLfile:=buf;
buf:=ReadString(section,'ConstBfile',cfgm.ConstBfile);
buf:=ExtractSubPath(ConfigAppdir,buf);
if FileExists(buf) then cfgm.ConstBfile:=buf;
buf:=ReadString(section,'EarthMapFile',cfgm.EarthMapFile);
buf:=ExtractSubPath(ConfigAppdir,buf);
if FileExists(buf) then cfgm.EarthMapFile:=buf;
buf:=ReadString(section,'PlanetDir',cfgm.PlanetDir);
buf:=ExtractSubPath(ConfigAppdir,buf);
if DirectoryExists(buf) then cfgm.PlanetDir:=buf;
cfgm.horizonfile:=ReadString(section,'horizonfile',cfgm.horizonfile);
cfgm.ServerIPaddr:=ReadString(section,'ServerIPaddr',cfgm.ServerIPaddr);
cfgm.ServerIPport:=ReadString(section,'ServerIPport',cfgm.ServerIPport);
cfgm.IndiPanelCmd:=ReadString(section,'IndiPanelCmd',cfgm.IndiPanelCmd);
cfgm.keepalive:=ReadBool(section,'keepalive',cfgm.keepalive);
cfgm.TextOnlyDetail:=ReadBool(section,'TextOnlyDetail',cfgm.TextOnlyDetail);
cfgm.AutostartServer:=ReadBool(section,'AutostartServer',cfgm.AutostartServer);
DBtype:=TDBtype(ReadInteger(section,'dbtype',1));
cfgm.dbhost:=ReadString(section,'dbhost',cfgm.dbhost);
cfgm.dbport:=ReadInteger(section,'dbport',cfgm.dbport);
buf:=ReadString(section,'db',cfgm.db);
if (ConfigPrivateDir='')or(ConfigPrivateDir=PrivateDir)or(pos(ConfigPrivateDir,buf)=0) then
   cfgm.db:=buf
else begin
   buf:=ExtractSubPath(slash(ConfigPrivateDir),buf);
   cfgm.db:=slash(PrivateDir)+buf;
end;
cfgm.dbuser:=ReadString(section,'dbuser',cfgm.dbuser);
cryptedpwd:=hextostr(ReadString(section,'dbpass',cfgm.dbpass));
cfgm.dbpass:=DecryptStr(cryptedpwd,encryptpwd);
buf:=ReadString(section,'ImagePath',cfgm.ImagePath);
buf:=ExtractSubPath(ConfigAppdir,buf);
if DirectoryExists(buf) then cfgm.ImagePath:=buf;
cfgm.ShowChartInfo:=ReadBool(section,'ShowChartInfo',cfgm.ShowChartInfo);
cfgm.ShowTitlePos:=ReadBool(section,'ShowTitlePos',cfgm.ShowTitlePos);
cfgm.SyncChart:=ReadBool(section,'SyncChart',cfgm.SyncChart);
cfgm.ButtonStandard:=ReadInteger(section,'ButtonStandard',cfgm.ButtonStandard);
cfgm.ButtonNight:=ReadInteger(section,'ButtonNight',cfgm.ButtonNight);
cfgm.VOurl:=ReadInteger(section,'VOurl',cfgm.VOurl);
cfgm.VOmaxrecord:=ReadInteger(section,'VOmaxrecord',cfgm.VOmaxrecord);
cfgm.AnimDelay:=ReadInteger(section,'AnimDelay',cfgm.AnimDelay);
AnimationTimer.Interval:=max(10,cfgm.AnimDelay);
cfgm.AnimFps:=ReadFloat(section,'AnimFps',cfgm.AnimFps);
//cfgm.AnimRec:=ReadBool(section,'AnimRec',cfgm.AnimRec);
cfgm.AnimRecDir:=ReadString(section,'AnimRecDir',cfgm.AnimRecDir);
cfgm.AnimRecPrefix:=ReadString(section,'AnimRecPrefix',cfgm.AnimRecPrefix);
cfgm.AnimRecExt:=ReadString(section,'AnimRecExt',cfgm.AnimRecExt);
cfgm.Animffmpeg:=ReadString(section,'Animffmpeg',cfgm.Animffmpeg);
cfgm.AnimSx:=ReadInteger(section,'AnimSx',cfgm.AnimSx);
cfgm.AnimSy:=ReadInteger(section,'AnimSy',cfgm.AnimSy);
cfgm.AnimSize:=ReadInteger(section,'AnimSize',cfgm.AnimSize);
cfgm.AnimOpt:=ReadString(section,'AnimOpt',cfgm.AnimOpt);
cfgm.HttpProxy:=ReadBool(section,'HttpProxy',cfgm.HttpProxy);
cfgm.SocksProxy:=ReadBool(section,'SocksProxy',cfgm.SocksProxy);
cfgm.SocksType:=ReadString(section,'SocksType',cfgm.SocksType);
cfgm.FtpPassive:=ReadBool(section,'FtpPassive',cfgm.FtpPassive);
cfgm.ConfirmDownload:=ReadBool(section,'ConfirmDownload',cfgm.ConfirmDownload);
cfgm.ProxyHost:=ReadString(section,'ProxyHost',cfgm.ProxyHost);
cfgm.ProxyPort:=ReadString(section,'ProxyPort',cfgm.ProxyPort);
cfgm.ProxyUser:=ReadString(section,'ProxyUser',cfgm.ProxyUser);
cfgm.ProxyPass:=ReadString(section,'ProxyPass',cfgm.ProxyPass);
cfgm.AnonPass:=ReadString(section,'AnonPass',cfgm.AnonPass);
cfgm.starshape_file:=ReadString(section,'starshape_file',cfgm.starshape_file);
buf:=ReadString(section,'CometUrl1','');
if (Pos('cfa-www.harvard.edu',buf)=0) and (Pos('www.minorplanetcenter.org',buf)=0) then begin   // Old MPC URL, ignore saved configuration
  j:=ReadInteger(section,'CometUrlCount',0);
  if (j>0) then begin
     cfgm.CometUrlList.Clear;
     for i:=1 to j do cfgm.CometUrlList.Add(ReadString(section,'CometUrl'+inttostr(i),''));
  end;
  j:=ReadInteger(section,'AsteroidUrlCount',0);
  if j>0 then begin
    cfgm.AsteroidUrlList.Clear;
    for i:=1 to j do begin
      buf:=ReadString(section,'AsteroidUrl'+inttostr(i),'');
      if Pos('ap-i.net',buf)>0 then buf:=URL_CDCAsteroidElements; // change mpc5000 file location
      cfgm.AsteroidUrlList.Add(buf);
    end;
  end;
end;
j:=ReadInteger(section,'ObsNameListCount',0);
cfgm.ObsNameList.Clear;
if j>0 then for i:=0 to j-1 do begin
  obsdetail:=TObsDetail.Create;
  obsdetail.country:=ReadString(section,'ObsCountry'+inttostr(i),'');
  obsdetail.lat:=ReadFloat(section,'ObsLat'+inttostr(i),0);
  obsdetail.lon:=ReadFloat(section,'ObsLon'+inttostr(i),0);
  obsdetail.alt:=ReadFloat(section,'ObsAlt'+inttostr(i),0);
  cfgm.ObsNameList.AddObject(ReadString(section,'ObsName'+inttostr(i),''),obsdetail);
end;
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
def_cfgsc.ASCOMTelescope:=ReadBool(section,'ASCOMTelescope',def_cfgsc.ASCOMTelescope);
def_cfgsc.LX200Telescope:=ReadBool(section,'LX200Telescope',def_cfgsc.LX200Telescope);
def_cfgsc.EncoderTelescope:=ReadBool(section,'EncoderTelescope',def_cfgsc.EncoderTelescope);
def_cfgsc.ManualTelescope:=ReadBool(section,'ManualTelescope',def_cfgsc.ManualTelescope);
def_cfgsc.ManualTelescopeType:=ReadInteger(section,'ManualTelescopeType',def_cfgsc.ManualTelescopeType);
def_cfgsc.TelescopeTurnsX:=ReadFloat(section,'TelescopeTurnsX',def_cfgsc.TelescopeTurnsX);
def_cfgsc.TelescopeTurnsY:=ReadFloat(section,'TelescopeTurnsY',def_cfgsc.TelescopeTurnsY);
if not (def_cfgsc.IndiTelescope or def_cfgsc.ASCOMTelescope or def_cfgsc.LX200Telescope or def_cfgsc.EncoderTelescope or def_cfgsc.ManualTelescope) then begin
  {$ifdef unix}
     def_cfgsc.ManualTelescope:=true;
  {$endif}
  {$ifdef mswindows}
     def_cfgsc.ASCOMTelescope:=true;
  {$endif}
end;
TelescopePanel.visible:=def_cfgsc.IndiTelescope;
toolbar1.visible:=ReadBool(section,'ViewMainBar',true);
PanelLeft.visible:=ReadBool(section,'ViewLeftBar',true);
PanelRight.visible:=ReadBool(section,'ViewRightBar',true);
toolbar4.visible:=ReadBool(section,'ViewObjectBar',true);
ViewScrollBar1.Checked:=ReadBool(section,'ViewScrollBar',true) and CanShowScrollbar;
PanelBottom.visible:=ReadBool(section,'ViewStatusBar',true);
ViewStatusBar1.checked:=PanelBottom.visible;
MainBar1.checked:=ToolBar1.visible;
ObjectBar1.checked:=ToolBar4.visible;
LeftBar1.checked:=PanelLeft.visible;
RightBar1.checked:=PanelRight.visible;
ViewToolsBar1.checked:=(MainBar1.checked and ObjectBar1.checked and LeftBar1.checked and RightBar1.checked);
ViewTopPanel;
InitialChartNum:=ReadInteger(section,'NumChart',0);
except
  ShowError('Error reading '+filename+' main');
end;
try
section:='catalog';
for i:=1 to maxstarcatalog do begin
   buf:=ReadString(section,'starcatpath'+inttostr(i),catalog.cfgcat.starcatpath[i]);
   buf:=ExtractSubPath(slash(ConfigAppdir),buf);
   if DirectoryExists(buf) then catalog.cfgcat.starcatpath[i]:=buf;
end;
for i:=1 to maxvarstarcatalog do begin
   buf:=ReadString(section,'varstarcatpath'+inttostr(i),catalog.cfgcat.varstarcatpath[i]);
   buf:=ExtractSubPath(slash(ConfigAppdir),buf);
   if DirectoryExists(buf) then catalog.cfgcat.varstarcatpath[i]:=buf;
end;
for i:=1 to maxdblstarcatalog do begin
   buf:=ReadString(section,'dblstarcatpath'+inttostr(i),catalog.cfgcat.dblstarcatpath[i]);
   buf:=ExtractSubPath(slash(ConfigAppdir),buf);
   if DirectoryExists(buf) then catalog.cfgcat.dblstarcatpath[i]:=buf;
end;
for i:=1 to maxnebcatalog do begin
   buf:=ReadString(section,'nebcatpath'+inttostr(i),catalog.cfgcat.nebcatpath[i]);
   buf:=ExtractSubPath(slash(ConfigAppdir),buf);
   if DirectoryExists(buf) then catalog.cfgcat.nebcatpath[i]:=buf;
end;
except
  ShowError('Error reading '+filename+' catalog');
end;
try
section:='dss';
f_getdss.cfgdss.dssnorth:=ReadBool(section,'dssnorth',false);
f_getdss.cfgdss.dsssouth:=ReadBool(section,'dsssouth',false);
f_getdss.cfgdss.dss102:=ReadBool(section,'dss102',false);
f_getdss.cfgdss.dsssampling:=ReadBool(section,'dsssampling',true);
f_getdss.cfgdss.dssplateprompt:=ReadBool(section,'dssplateprompt',true);
f_getdss.cfgdss.dssmaxsize:=ReadInteger(section,'dssmaxsize',2048);
f_getdss.cfgdss.dssdir:=ReadString(section,'dssdir',slash('cat')+'RealSky');
f_getdss.cfgdss.dssdrive:=ReadString(section,'dssdrive',default_dssdrive);
f_getdss.cfgdss.dssfile:=slash(PictureDir)+'$temp.fit';
for i:=1 to MaxDSSurl do begin
  f_getdss.cfgdss.DSSurl[i,0]:=ReadString(section,'DSSurlName'+inttostr(i),f_getdss.cfgdss.DSSurl[i,0]);
  f_getdss.cfgdss.DSSurl[i,1]:=ReadString(section,'DSSurl'+inttostr(i),f_getdss.cfgdss.DSSurl[i,1]);
end;
f_getdss.cfgdss.OnlineDSS:=ReadBool(section,'OnlineDSS',f_getdss.cfgdss.OnlineDSS);
{$ifdef CPU64}
f_getdss.cfgdss.OnlineDSS:=true;  { TODO : Realsky libgetdss do not work on 64bit system }
{$endif}
f_getdss.cfgdss.OnlineDSSid:=ReadInteger(section,'OnlineDSSid',f_getdss.cfgdss.OnlineDSSid);
except
  ShowError('Error reading '+filename+' dss');
end;
try
section:='quicksearch';
j:=min(MaxQuickSearch,ReadInteger(section,'count',0));
for i:=1 to j do quicksearch.Items.Add(ReadString(section,'item'+inttostr(i),''));
except
  ShowError('Error reading '+filename+' quicksearch');
end;
end;
finally
inif.Free;
end;
end;

procedure Tf_main.UpdateConfig;
var i: integer;
begin
if Config_Version < '3.0.1.3d' then begin
  f_getdss.cfgdss.DSSurl[1,0]:=URL_DSS_NAME1;
  f_getdss.cfgdss.DSSurl[1,1]:=URL_DSS1;
  f_getdss.cfgdss.DSSurl[2,0]:=URL_DSS_NAME2;
  f_getdss.cfgdss.DSSurl[2,1]:=URL_DSS2;
  f_getdss.cfgdss.DSSurl[3,0]:=URL_DSS_NAME3;
  f_getdss.cfgdss.DSSurl[3,1]:=URL_DSS3;
  f_getdss.cfgdss.DSSurl[4,0]:=URL_DSS_NAME4;
  f_getdss.cfgdss.DSSurl[4,1]:=URL_DSS4;
  f_getdss.cfgdss.DSSurl[5,0]:=URL_DSS_NAME5;
  f_getdss.cfgdss.DSSurl[5,1]:=URL_DSS5;
  f_getdss.cfgdss.DSSurl[6,0]:=URL_DSS_NAME6;
  f_getdss.cfgdss.DSSurl[6,1]:=URL_DSS6;
  f_getdss.cfgdss.DSSurl[7,0]:=URL_DSS_NAME7;
  f_getdss.cfgdss.DSSurl[7,1]:=URL_DSS7;
  f_getdss.cfgdss.DSSurl[8,0]:=URL_DSS_NAME8;
  f_getdss.cfgdss.DSSurl[8,1]:=URL_DSS8;
  f_getdss.cfgdss.DSSurl[9,0]:=URL_DSS_NAME9;
  f_getdss.cfgdss.DSSurl[9,1]:=URL_DSS9;
  SaveDefault;
end;
if Config_Version < '3.0.1.5f' then begin
{$ifdef unix}
   cfgm.PrintCmd1:=DefaultPrintCmd1;
   cfgm.PrintCmd2:=DefaultPrintCmd2;
{$endif}
{$ifndef darwin}
   LinuxDesktop:=0;
   OpenFileCMD:='xdg-open';
{$endif}
end;
if Config_Version < '3.1a' then begin
   if cfgm.PrinterResolution<300 then
      cfgm.PrinterResolution:=300;
end;
if Config_Version < '3.3i' then begin
  // update Jupiter GRS default values
  def_cfgsc.GRSlongitude:=168.0;
  def_cfgsc.GRSjd:=jd(2011,7,15,0);
  def_cfgsc.GRSdrift:=15.2/365.25;
  // incoherent object filter
  catalog.cfgshr.NebMagFilter[0]:=99;
  catalog.cfgshr.NebMagFilter[1]:=99;
  catalog.cfgshr.NebMagFilter[2]:=99;
  catalog.cfgshr.NebMagFilter[3]:=99;
end;
if Config_Version < '3.3j' then begin
  catalog.cfgcat.starcatpath[dsbase-BaseStar]:='C:\Program Files\Deepsky Astronomy Software';
  catalog.cfgcat.starcatpath[dstyc-BaseStar]:='C:\Program Files\Deepsky Astronomy Software\SuperTycho';
  catalog.cfgcat.starcatpath[dsgsc-BaseStar]:='C:\Program Files\Deepsky Astronomy Software\HGC';
end;
if Config_Version < '3.5e' then begin
  i:=def_cfgsc.SimLabel;
  case i of
   0 : def_cfgsc.SimLabel:=3;
   1 : def_cfgsc.SimLabel:=-2;
   2 : def_cfgsc.SimLabel:=-3;
   3 : def_cfgsc.SimLabel:=1;
   4 : def_cfgsc.SimLabel:=2;
   else  def_cfgsc.SimLabel:=0;
  end;
end;
{$ifdef mswindows}
if Config_Version < '3.5f' then begin
  for i:=1 to numfont do begin
     if def_cfgplot.FontSize[i]=8 then def_cfgplot.FontSize[i]:=DefaultFontSize;
  end;
  for i:=1 to numlabtype do begin
     if (i=6) and (def_cfgplot.LabelSize[6]=10) then def_cfgplot.LabelSize[6]:=12;
     if def_cfgplot.LabelSize[i]=8 then def_cfgplot.LabelSize[i]:=DefaultFontSize;
  end;
end;
{$endif}
{$ifdef darwin}
if Config_Version < '3.5f' then begin
  for i:=1 to numfont do begin
     if def_cfgplot.FontSize[i]=12 then def_cfgplot.FontSize[i]:=DefaultFontSize;
  end;
  for i:=1 to numlabtype do begin
     if def_cfgplot.LabelSize[i]=12 then def_cfgplot.LabelSize[i]:=DefaultFontSize;
     if (i=6) and (def_cfgplot.LabelSize[6]=14) then def_cfgplot.LabelSize[6]:=12;
  end;
end;
{$endif}
if  Config_Version < '3.5i' then begin
  def_cfgsc.projname[0]:='TAN';
  def_cfgsc.projname[1]:='TAN';
  def_cfgsc.projname[2]:='TAN';
  def_cfgsc.projname[3]:='TAN';
  def_cfgsc.projname[4]:='TAN';
  def_cfgsc.projname[5]:='TAN';
  def_cfgsc.projname[6]:='TAN';
  def_cfgsc.projname[7]:='TAN';
  def_cfgsc.projname[8]:='MER';
  def_cfgsc.projname[9]:='MER';
  def_cfgsc.projname[10]:='MER';
end;
end;

procedure Tf_main.SaveVersion;
var inif: TMemIniFile;
    section : string;
begin
try
inif:=TMeminifile.create(configfile);
try
with inif do begin
section:='main';
WriteString(section,'version',cdcver);
Updatefile;
end;
finally
 inif.Free;
end;
except
end;
end;

procedure Tf_main.SaveDefault;
var i,j: integer;
begin
try
SavePrivateConfig(configfile);
SaveQuickSearch(configfile);
if (MultiFrame1.ActiveObject is Tf_chart) then begin
   SaveChartConfig(configfile,MultiFrame1.ActiveChild);
end;
j:=0;
for i:=0 to MultiFrame1.ChildCount-1 do
  if (MultiFrame1.Childs[i].DockedObject is Tf_chart) and (MultiFrame1.Childs[i].DockedObject<>MultiFrame1.ActiveObject) then begin
     inc(j);
     SaveChartConfig(configfile+inttostr(j),MultiFrame1.Childs[i]);
  end;
except
end;
end;

procedure Tf_main.SaveChartConfig(filename:string; child: TChildFrame);
var i,n:integer;
    inif: TMemIniFile;
    section : string;
    cplot:Tconf_plot ;
    csc:Tconf_skychart;
begin
try
cplot:=Tconf_plot.Create;
csc:=Tconf_skychart.create;
if (child<>nil) and (child.DockedObject is Tf_chart) then with child.DockedObject as Tf_chart do begin
  cplot.Assign(sc.plot.cfgplot);
  csc.Assign(sc.cfgsc);
end
else begin
  cplot.Assign(def_cfgplot);
  csc.Assign(def_cfgsc);
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
WriteBool(section,'NoFilterMessier',catalog.cfgshr.NoFilterMessier);
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
   WriteBool(section,'CatForceColor'+inttostr(i),catalog.cfgcat.GCatLst[i].ForceColor);
   WriteInteger(section,'CatColor'+inttostr(i),catalog.cfgcat.GCatLst[i].Col);
end;
n:=Length(catalog.cfgcat.UserObjects);
WriteInteger(section,'UserObjectsNum',n);
for i:=0 to n-1 do begin
   WriteBool(section,'UObjActive'+inttostr(i),catalog.cfgcat.UserObjects[i].active);
   WriteInteger(section,'UObjType'+inttostr(i),catalog.cfgcat.UserObjects[i].otype);
   WriteString(section,'UObjName'+inttostr(i),catalog.cfgcat.UserObjects[i].oname);
   WriteFloat(section,'UObjRA'+inttostr(i),catalog.cfgcat.UserObjects[i].ra);
   WriteFloat(section,'UObjDEC'+inttostr(i),catalog.cfgcat.UserObjects[i].dec);
   WriteFloat(section,'UObjMag'+inttostr(i),catalog.cfgcat.UserObjects[i].mag);
   WriteFloat(section,'UObjSize'+inttostr(i),catalog.cfgcat.UserObjects[i].size);
   WriteInteger(section,'UObjColor'+inttostr(i),catalog.cfgcat.UserObjects[i].color);
   WriteString(section,'UObjComment'+inttostr(i),catalog.cfgcat.UserObjects[i].comment);
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
WriteBool(section,'AntiAlias',cplot.AntiAlias);
WriteInteger(section,'starplot',cplot.starplot);
WriteInteger(section,'nebplot',cplot.nebplot);
WriteInteger(section,'plaplot',cplot.plaplot);
WriteBool(section,'TransparentPlanet',cplot.TransparentPlanet);
WriteInteger(section,'Nebgray',cplot.Nebgray);
WriteInteger(section,'NebBright',cplot.NebBright);
WriteInteger(section,'StarDyn',cplot.stardyn);
WriteInteger(section,'StarSize',cplot.starsize);
WriteInteger(section,'contrast',cplot.contrast);
WriteInteger(section,'saturation',cplot.saturation);
WriteBool(section,'redmove',cplot.red_move);
WriteFloat(section,'partsize',cplot.partsize);
WriteFloat(section,'magsize',cplot.magsize);
WriteBool(section,'AutoSkycolor',cplot.AutoSkycolor);
WriteBool(section,'DSOColorFillAst',cplot.DSOColorFillAst);
WriteBool(section,'DSOColorFillOCl',cplot.DSOColorFillOCl);
WriteBool(section,'DSOColorFillGCl',cplot.DSOColorFillGCl);
WriteBool(section,'DSOColorFillPNe',cplot.DSOColorFillPNe);
WriteBool(section,'DSOColorFillDN',cplot.DSOColorFillDN);
WriteBool(section,'DSOColorFillEN',cplot.DSOColorFillEN);
WriteBool(section,'DSOColorFillRN',cplot.DSOColorFillRN);
WriteBool(section,'DSOColorFillSN',cplot.DSOColorFillSN);
WriteBool(section,'DSOColorFillGxy',cplot.DSOColorFillGxy);
WriteBool(section,'DSOColorFillGxyCl',cplot.DSOColorFillGxyCl);
WriteBool(section,'DSOColorFillQ',cplot.DSOColorFillQ);
WriteBool(section,'DSOColorFillGL',cplot.DSOColorFillGL);
WriteBool(section,'DSOColorFillNE',cplot.DSOColorFillNE);
for i:=0 to maxcolor do WriteInteger(section,'color'+inttostr(i),cplot.color[i]);
for i:=0 to 7 do WriteInteger(section,'skycolor'+inttostr(i),cplot.skycolor[i]);
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
WriteBool(section,'ShowCRose',catalog.cfgshr.ShowCRose);
WriteInteger(section,'CRoseSz',catalog.cfgshr.CRoseSz);
for i:=0 to maxfield do WriteFloat(section,'HourGridSpacing'+inttostr(i),catalog.cfgshr.HourGridSpacing[i] );
for i:=0 to maxfield do WriteFloat(section,'DegreeGridSpacing'+inttostr(i),catalog.cfgshr.DegreeGridSpacing[i] );
section:='Finder';
WriteBool(section,'ShowCircle',csc.ShowCircle);
WriteBool(section,'CircleLabel',csc.CircleLabel);
WriteBool(section,'RectangleLabel',csc.RectangleLabel);
WriteBool(section,'marknumlabel',csc.marknumlabel);
for i:=1 to 10 do WriteFloat(section,'Circle'+inttostr(i),csc.circle[i,1]);
for i:=1 to 10 do WriteFloat(section,'CircleR'+inttostr(i),csc.circle[i,2]);
for i:=1 to 10 do WriteFloat(section,'CircleOffset'+inttostr(i),csc.circle[i,3]);
for i:=1 to 10 do WriteBool(section,'ShowCircle'+inttostr(i),csc.circleok[i]);
for i:=1 to 10 do WriteString(section,'CircleLbl'+inttostr(i),csc.circlelbl[i]+' ');
for i:=1 to 10 do WriteFloat(section,'RectangleW'+inttostr(i),csc.rectangle[i,1]);
for i:=1 to 10 do WriteFloat(section,'RectangleH'+inttostr(i),csc.rectangle[i,2]);
for i:=1 to 10 do WriteFloat(section,'RectangleR'+inttostr(i),csc.rectangle[i,3]);
for i:=1 to 10 do WriteFloat(section,'RectangleOffset'+inttostr(i),csc.rectangle[i,4]);
for i:=1 to 10 do WriteBool(section,'ShowRectangle'+inttostr(i),csc.rectangleok[i]);
for i:=1 to 10 do WriteString(section,'RectangleLbl'+inttostr(i),csc.rectanglelbl[i]+' ');
section:='chart';
WriteInteger(section,'EquinoxType',catalog.cfgshr.EquinoxType);
WriteString(section,'EquinoxChart',catalog.cfgshr.EquinoxChart);
WriteFloat(section,'DefaultJDchart',catalog.cfgshr.DefaultJDchart);
section:='default_chart';
if (child<>nil) then begin
  WriteInteger(section,'ChartWidth',child.Width);
  WriteInteger(section,'ChartHeight',child.Height);
  WriteInteger(section,'ChartTop',child.Top);
  WriteInteger(section,'Chartleft',child.Left);
  WriteBool(section,'ChartMaximized',child.Maximized);
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
WriteBool(section,'CoordExpertMode',csc.CoordExpertMode);
WriteBool(section,'PMon',csc.PMon);
WriteFloat(section,'YPMon',csc.YPMon);
WriteBool(section,'DrawPMon',csc.DrawPMon);
WriteBool(section,'ApparentPos',csc.ApparentPos);
WriteInteger(section,'CoordType',csc.CoordType);
WriteInteger(section,'DrawPMyear',csc.DrawPMyear);
WriteBool(section,'horizonopaque',csc.horizonopaque);
WriteBool(section,'ShowHorizon',csc.ShowHorizon);
WriteBool(section,'FillHorizon',csc.FillHorizon);
WriteBool(section,'ShowHorizonDepression',csc.ShowHorizonDepression);
WriteBool(section,'ShowEqGrid',csc.ShowEqGrid);
WriteBool(section,'ShowLabelAll',csc.ShowLabelAll);
WriteBool(section,'EditLabels',csc.EditLabels);
WriteBool(section,'OptimizeLabels',csc.OptimizeLabels);
WriteBool(section,'ShowGrid',csc.ShowGrid);
WriteBool(section,'ShowGridNum',csc.ShowGridNum);
WriteBool(section,'ShowOnlyMeridian',csc.ShowOnlyMeridian);
WriteBool(section,'ShowConstL',csc.ShowConstL);
WriteBool(section,'ShowConstB',csc.ShowConstB);
WriteBool(section,'ShowEcliptic',csc.ShowEcliptic);   
WriteBool(section,'ShowGalactic',csc.ShowGalactic);
WriteBool(section,'ShowMilkyWay',csc.ShowMilkyWay);
WriteBool(section,'FillMilkyWay',csc.FillMilkyWay);
WriteString(section,'URL_SUN_NAME',csc.sunurlname);
WriteString(section,'URL_SUN',csc.sunurl);
WriteInteger(section,'URL_SUN_SIZE',csc.sunurlsize);
WriteInteger(section,'URL_SUN_MARGIN',csc.sunurlmargin);
WriteInteger(section,'SunRefreshTime',csc.sunrefreshtime);
WriteBool(section,'SunOnline',csc.SunOnline);
WriteBool(section,'ShowPluto',csc.ShowPluto);
WriteBool(section,'ShowPlanet',csc.ShowPlanet);
WriteBool(section,'ShowAsteroid',csc.ShowAsteroid);
WriteBool(section,'ShowComet',csc.ShowComet);
WriteBool(section,'DSLforcecolor',csc.DSLforcecolor);
WriteInteger(section,'DSLcolor',csc.DSLcolor);
WriteBool(section,'ShowImages',csc.ShowImages);
WriteBool(section,'ShowStars',csc.showstars);
WriteBool(section,'ShowNebulae',csc.shownebulae);
WriteBool(section,'ShowLine',csc.showline);
WriteBool(section,'ShowBackgroundImage',csc.ShowBackgroundImage);
WriteString(section,'BackgroundImage',csc.BackgroundImage);
WriteInteger(section,'AstSymbol',csc.AstSymbol);
WriteFloat(section,'AstmagMax',csc.AstmagMax);
WriteFloat(section,'AstmagDiff',csc.AstmagDiff);
WriteBool(section,'AstNEO',csc.AstNEO);
WriteInteger(section,'ComSymbol',csc.ComSymbol);
WriteFloat(section,'CommagMax',csc.CommagMax);
WriteFloat(section,'CommagDiff',csc.CommagDiff);
WriteBool(section,'MagLabel',csc.MagLabel);
WriteBool(section,'NameLabel',csc.NameLabel);
WriteBool(section,'DrawAllStarLabel',csc.DrawAllStarLabel);
WriteBool(section,'MovedLabelLine',csc.MovedLabelLine);
WriteBool(section,'ConstFullLabel',csc.ConstFullLabel);
WriteBool(section,'ConstLatinLabel',csc.ConstLatinLabel);
WriteBool(section,'PlanetParalaxe',csc.PlanetParalaxe);
WriteBool(section,'ShowEarthShadow',csc.ShowEarthShadow);
WriteFloat(section,'GRSlongitude',csc.GRSlongitude);
WriteFloat(section,'GRSjd',csc.GRSjd);
WriteFloat(section,'GRSdrift',csc.GRSdrift);
WriteInteger(section,'StyleGrid',ord(csc.StyleGrid));
WriteInteger(section,'StyleEqGrid',ord(csc.StyleEqGrid));
WriteInteger(section,'StyleConstL',ord(csc.StyleConstL));
WriteInteger(section,'StyleConstB',ord(csc.StyleConstB));
WriteInteger(section,'StyleEcliptic',ord(csc.StyleEcliptic));
WriteInteger(section,'StyleGalEq',ord(csc.StyleGalEq));
WriteInteger(section,'BGalpha',csc.BGalpha);
WriteFloat(section,'BGmin_sigma',csc.BGmin_sigma);
WriteFloat(section,'BGmax_sigma',csc.BGmax_sigma);
WriteFloat(section,'NEBmin_sigma',csc.NEBmin_sigma);
WriteFloat(section,'NEBmax_sigma',csc.NEBmax_sigma);
WriteInteger(section,'Simnb',csc.Simnb);
WriteInteger(section,'SimLabel',csc.SimLabel);
WriteBool(section,'SimNameLabel',csc.SimNameLabel);
WriteBool(section,'SimDateLabel',csc.SimDateLabel);
WriteBool(section,'SimDateYear',csc.SimDateYear);
WriteBool(section,'SimDateMonth',csc.SimDateMonth);
WriteBool(section,'SimDateDay',csc.SimDateDay);
WriteBool(section,'SimDateHour',csc.SimDateHour);
WriteBool(section,'SimDateMinute',csc.SimDateMinute);
WriteBool(section,'SimDateSecond',csc.SimDateSecond);
WriteBool(section,'SimMagLabel',csc.SimMagLabel);
WriteBool(section,'ShowLegend',csc.ShowLegend);
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
WriteBool(section,'TrackOn',csc.TrackOn);
WriteInteger(section,'TrackType',csc.TrackType);
WriteInteger(section,'TrackObj',csc.TrackObj);
WriteFloat(section,'TrackDec',csc.TrackDec);
WriteFloat(section,'TrackRA',csc.TrackRA);
WriteFloat(section,'TrackEpoch',csc.TrackEpoch);
WriteString(section,'TrackName',csc.TrackName);
section:='observatory';
WriteFloat(section,'ObsLatitude',csc.ObsLatitude );
WriteFloat(section,'ObsLongitude',csc.ObsLongitude );
WriteFloat(section,'ObsAltitude',csc.ObsAltitude );
WriteFloat(section,'ObsTemperature',csc.ObsTemperature );
WriteFloat(section,'ObsPressure',csc.ObsPressure );
WriteString(section,'ObsName',Condutf8encode(csc.ObsName) );
WriteString(section,'ObsCountry',csc.ObsCountry );
WriteString(section,'ObsTZ',csc.ObsTZ );
WriteBool(section,'countrytz',csc.countrytz );
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
WriteInteger(section,'poslabels',csc.posmodlabels);
WriteInteger(section,'numlabels',csc.nummodlabels);
for i:=1 to csc.nummodlabels do begin
   WriteInteger(section,'labelid'+inttostr(i),csc.modlabels[i].id);
   WriteInteger(section,'labeldx'+inttostr(i),csc.modlabels[i].dx);
   WriteInteger(section,'labeldy'+inttostr(i),csc.modlabels[i].dy);
   WriteFloat(section,'labelra'+inttostr(i),csc.modlabels[i].ra);
   WriteFloat(section,'labeldec'+inttostr(i),csc.modlabels[i].dec);
   WriteInteger(section,'labelnum'+inttostr(i),csc.modlabels[i].labelnum);
   WriteInteger(section,'labelfont'+inttostr(i),csc.modlabels[i].fontnum);
   WriteString(section,'labeltxt'+inttostr(i),csc.modlabels[i].txt);
   WriteInteger(section,'labelalign'+inttostr(i),ord(csc.modlabels[i].align));
   WriteBool(section,'labeluseradec'+inttostr(i),csc.modlabels[i].useradec);
   WriteBool(section,'labelhiden'+inttostr(i),csc.modlabels[i].hiden);
end;
section:='custom_labels';
WriteInteger(section,'poslabels',csc.poscustomlabels);
WriteInteger(section,'numlabels',csc.numcustomlabels);
for i:=1 to csc.numcustomlabels do begin
   WriteFloat(section,'labelra'+inttostr(i),csc.customlabels[i].ra);
   WriteFloat(section,'labeldec'+inttostr(i),csc.customlabels[i].dec);
   WriteInteger(section,'labelnum'+inttostr(i),csc.customlabels[i].labelnum);
   WriteString(section,'labeltxt'+inttostr(i),csc.customlabels[i].txt);
   WriteInteger(section,'labelalign'+inttostr(i),ord(csc.customlabels[i].align));
end;
Updatefile;
end;
finally
 inif.Free;
 csc.Free;
 cplot.Free;
end;
except
end;
end;

procedure Tf_main.SavePrivateConfig(filename:string);
var i,j:integer;
    inif: TMemIniFile;
    section : string;
begin
try
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
WriteBool(section,'SaveConfigOnExit',SaveConfigOnExit.Checked);
WriteBool(section,'ConfirmSaveConfig',ConfirmSaveConfig);
WriteBool(section,'NightVision',NightVision);
WriteString(section,'language',cfgm.language);
WriteInteger(section,'SesameUrlNum',f_search.SesameUrlNum);
WriteInteger(section,'SesameCatNum',f_search.SesameCatNum);
WriteString(section,'prtname',cfgm.prtname);
WriteInteger(section,'Paper',cfgm.Paper);
WriteInteger(section,'PrinterResolution',cfgm.PrinterResolution);
WriteInteger(section,'PrintColor',cfgm.PrintColor);
WriteBool(section,'PrintLandscape',cfgm.PrintLandscape);
WriteInteger(section,'PrintMethod',cfgm.PrintMethod);
WriteString(section,'PrintCmd1',cfgm.PrintCmd1);
WriteString(section,'PrintCmd2',cfgm.PrintCmd2);
WriteString(section,'PrintTmpPath',cfgm.PrintTmpPath);;
WriteInteger(section,'PrtLeftMargin',cfgm.PrtLeftMargin);
WriteInteger(section,'PrtRightMargin',cfgm.PrtRightMargin);
WriteInteger(section,'PrtTopMargin',cfgm.PrtTopMargin);
WriteInteger(section,'PrtBottomMargin',cfgm.PrtBottomMargin);
WriteString(section,'Theme',cfgm.ThemeName);
WriteBool(section,'WinMaximize',(f_main.WindowState=wsMaximized));
WriteBool(section,'AzNorth',catalog.cfgshr.AzNorth);
WriteBool(section,'ListStar',catalog.cfgshr.ListStar);
WriteBool(section,'ListNeb',catalog.cfgshr.ListNeb);
WriteBool(section,'ListVar',catalog.cfgshr.ListVar);
WriteBool(section,'ListDbl',catalog.cfgshr.ListDbl);
WriteBool(section,'ListPla',catalog.cfgshr.ListPla);
WriteInteger(section,'autorefreshdelay',cfgm.autorefreshdelay);
WriteString(section,'ConstLfile',cfgm.ConstLfile);
WriteString(section,'ConstBfile',cfgm.ConstBfile);
WriteString(section,'EarthMapFile',cfgm.EarthMapFile);
WriteString(section,'PlanetDir',cfgm.PlanetDir);
WriteString(section,'horizonfile',cfgm.horizonfile);
WriteString(section,'ServerIPaddr',cfgm.ServerIPaddr);
WriteString(section,'ServerIPport',cfgm.ServerIPport);
WriteString(section,'IndiPanelCmd',cfgm.IndiPanelCmd);
WriteBool(section,'keepalive',cfgm.keepalive);
WriteBool(section,'TextOnlyDetail',cfgm.TextOnlyDetail);
WriteBool(section,'AutostartServer',cfgm.AutostartServer);
WriteInteger(section,'dbtype',ord(DBtype));
WriteString(section,'dbhost',cfgm.dbhost);
WriteInteger(section,'dbport',cfgm.dbport);
WriteString(section,'db',cfgm.db);
WriteString(section,'dbuser',cfgm.dbuser);
WriteString(section,'dbpass',strtohex(encryptStr(cfgm.dbpass,encryptpwd)));
WriteString(section,'ImagePath',cfgm.ImagePath);
WriteBool(section,'ShowChartInfo',cfgm.ShowChartInfo);
WriteBool(section,'ShowTitlePos',cfgm.ShowTitlePos);
WriteBool(section,'SyncChart',cfgm.SyncChart);
WriteInteger(section,'ButtonStandard',cfgm.ButtonStandard);
WriteInteger(section,'ButtonNight',cfgm.ButtonNight);
WriteInteger(section,'VOurl',cfgm.VOurl);
WriteInteger(section,'VOmaxrecord',cfgm.VOmaxrecord);
WriteInteger(section,'AnimDelay',cfgm.AnimDelay);
WriteFloat(section,'AnimFps',cfgm.AnimFps);
//WriteBool(section,'AnimRec',cfgm.AnimRec);
WriteString(section,'AnimRecDir',cfgm.AnimRecDir);
WriteString(section,'AnimRecPrefix',cfgm.AnimRecPrefix);
WriteString(section,'AnimRecExt',cfgm.AnimRecExt);
WriteString(section,'Animffmpeg',cfgm.Animffmpeg);
WriteInteger(section,'AnimSx',cfgm.AnimSx);
WriteInteger(section,'AnimSy',cfgm.AnimSy);
WriteInteger(section,'AnimSize',cfgm.AnimSize);
WriteString(section,'AnimOpt',cfgm.AnimOpt);
WriteBool(section,'HttpProxy',cfgm.HttpProxy);
WriteBool(section,'SocksProxy',cfgm.SocksProxy);
WriteString(section,'SocksType',cfgm.SocksType);
WriteBool(section,'FtpPassive',cfgm.FtpPassive);
WriteBool(section,'ConfirmDownload',cfgm.ConfirmDownload);
WriteString(section,'ProxyHost',cfgm.ProxyHost);
WriteString(section,'ProxyPort',cfgm.ProxyPort);
WriteString(section,'ProxyUser',cfgm.ProxyUser);
WriteString(section,'ProxyPass',cfgm.ProxyPass);
WriteString(section,'AnonPass',cfgm.AnonPass);
WriteString(section,'starshape_file',cfgm.starshape_file);
j:=cfgm.CometUrlList.Count;
WriteInteger(section,'CometUrlCount',j);
if j>0 then begin
   for i:=1 to j do WriteString(section,'CometUrl'+inttostr(i),cfgm.CometUrlList[i-1]);
end;
j:=cfgm.AsteroidUrlList.Count;
WriteInteger(section,'AsteroidUrlCount',j);
if j>0 then begin
   for i:=1 to j do WriteString(section,'AsteroidUrl'+inttostr(i),cfgm.AsteroidUrlList[i-1]);
end;
j:=cfgm.ObsNameList.Count;
WriteInteger(section,'ObsNameListCount',j);
if j>0 then for i:=0 to j-1 do begin
  if cfgm.ObsNameList.Objects[i]<>nil then begin
    WriteString(section,'ObsCountry'+inttostr(i),TObsDetail(cfgm.ObsNameList.Objects[i]).country);
    WriteFloat(section,'ObsLat'+inttostr(i),TObsDetail(cfgm.ObsNameList.Objects[i]).lat);
    WriteFloat(section,'ObsLon'+inttostr(i),TObsDetail(cfgm.ObsNameList.Objects[i]).lon);
    WriteFloat(section,'ObsAlt'+inttostr(i),TObsDetail(cfgm.ObsNameList.Objects[i]).alt);
    WriteString(section,'ObsName'+inttostr(i),cfgm.ObsNameList[i]);
  end;
end;
WriteBool(section,'IndiAutostart',def_cfgsc.IndiAutostart);
WriteString(section,'IndiServerHost',def_cfgsc.IndiServerHost);
WriteString(section,'IndiServerPort',def_cfgsc.IndiServerPort);
WriteString(section,'IndiServerCmd',def_cfgsc.IndiServerCmd);
WriteString(section,'IndiDriver',def_cfgsc.IndiDriver);
WriteString(section,'IndiPort',def_cfgsc.IndiPort);
WriteString(section,'IndiDevice',def_cfgsc.IndiDevice);
WriteBool(section,'IndiTelescope',def_cfgsc.IndiTelescope);
WriteBool(section,'ASCOMTelescope',def_cfgsc.ASCOMTelescope);
WriteBool(section,'LX200Telescope',def_cfgsc.LX200Telescope);
WriteBool(section,'EncoderTelescope',def_cfgsc.EncoderTelescope);
WriteBool(section,'ManualTelescope',def_cfgsc.ManualTelescope);
WriteInteger(section,'ManualTelescopeType',def_cfgsc.ManualTelescopeType);
WriteFloat(section,'TelescopeTurnsX',def_cfgsc.TelescopeTurnsX);
WriteFloat(section,'TelescopeTurnsY',def_cfgsc.TelescopeTurnsY);
WriteBool(section,'ViewMainBar',toolbar1.visible);
WriteBool(section,'ViewLeftBar',PanelLeft.visible);
WriteBool(section,'ViewRightBar',PanelRight.visible);
WriteBool(section,'ViewObjectBar',toolbar4.visible);
WriteBool(section,'ViewScrollBar',ViewScrollBar1.Checked);
WriteBool(section,'ViewStatusBar',ViewStatusBar1.Checked);
WriteInteger(section,'NumChart',MultiFrame1.ChildCount);
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
for i:=1 to MaxDSSurl do begin
  WriteString(section,'DSSurlName'+inttostr(i),f_getdss.cfgdss.DSSurl[i,0]);
  WriteString(section,'DSSurl'+inttostr(i),f_getdss.cfgdss.DSSurl[i,1]);
end;
WriteBool(section,'OnlineDSS',f_getdss.cfgdss.OnlineDSS);
WriteInteger(section,'OnlineDSSid',f_getdss.cfgdss.OnlineDSSid);
Updatefile;
end;
finally
 inif.Free;
end;
except
end;
end;

procedure Tf_main.SaveQuickSearch(filename:string);
var i,j:integer;
    inif: TMemIniFile;
    section : string;
begin
try
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
except
end;
end;

procedure Tf_main.SaveConfigOnExitExecute(Sender: TObject);
var inif: TMemIniFile;
    section : string;
begin
try
SaveConfigOnExit.Checked:=not SaveConfigOnExit.Checked;
ConfirmSaveConfig:=true;
inif:=TMeminifile.create(configfile);
try
with inif do begin
section:='main';
WriteBool(section,'SaveConfigOnExit',SaveConfigOnExit.Checked);
WriteBool(section,'ConfirmSaveConfig',ConfirmSaveConfig);
Updatefile;
end;
finally
 inif.Free;
end;
except
end;
end;

procedure Tf_main.ChangeLanguage(newlang:string);
var inif: TMemIniFile;
    i: integer;
begin
try
cfgm.language:=newlang;
inif:=TMeminifile.create(configfile);
try
with inif do begin
  WriteString('main','language',cfgm.language);
  Updatefile;
end;
finally
 inif.Free;
end;
lang:=u_translation.translate(cfgm.language);
u_help.Translate(lang);
SetLang;
f_position.SetLang;
f_search.SetLang;
f_zoom.SetLang;
f_getdss.SetLang;
f_manualtelescope.SetLang;
f_detail.SetLang;
f_info.SetLang;
f_calendar.SetLang;
f_printsetup.SetLang;
f_print.SetLang;
for i:=0 to MultiFrame1.ChildCount-1 do
  if MultiFrame1.Childs[i].DockedObject is Tf_chart then
     Tf_chart(MultiFrame1.Childs[i].DockedObject).SetLang;
if f_config<>nil then f_config.SetLang;
if f_about<>nil then f_about.SetLang;
if ConfigSystem<>nil then ConfigSystem.SetLang;
if ConfigInternet<>nil then ConfigInternet.SetLang;
if ConfigSolsys<>nil then ConfigSolsys.SetLang;
if ConfigChart<>nil then ConfigChart.SetLang;
if ConfigTime<>nil then ConfigTime.SetLang;
if ConfigObservatory<>nil then ConfigObservatory.SetLang;
if ConfigDisplay<>nil then ConfigDisplay.SetLang;
if ConfigPictures<>nil then ConfigPictures.SetLang;
if ConfigCatalog<>nil then ConfigCatalog.SetLang;
except
end;
end;

procedure Tf_main.SetLang;
begin
ldeg:=rsdeg;
lmin:=rsmin;
lsec:=rssec;
TimeU.Items.Clear;
TimeU.Items.Add(rsHour);
TimeU.Items.Add(rsMinute);
TimeU.Items.Add(rsSecond);
TimeU.Items.Add(rsDay);
TimeU.Items.Add(rsMonth);
TimeU.Items.Add(rsYear);
TimeU.Items.Add(rsJulianYear);
TimeU.Items.Add(rsTropicalYear);
TimeU.Items.Add(rsSiderealDay);
TimeU.Items.Add(rsSynodicMonth);
TimeU.Items.Add(rsSaros);
TimeU.ItemIndex:=0;
ToolButton8.hint:=rsSetDateAndTi;
ToolButton9.hint:=rsSetObservato;
SetupConfig.Caption:='&'+rsAllConfigura+Ellipsis;
ToolButtonConfig.hint:=rsConfigureThe;
ToolButtonEQ.hint:=rsEquatorialCo;
ToolButtonAZ.hint:=rsAltAzCoordin;
ToolButtonEC.hint:=rsEclipticCoor;
ToolButtonGL.hint:=rsGalacticCoor;
FlipButtonX.hint:=rsMirrorHorizo;
FlipButtonY.hint:=rsMirrorVertic;
ToolButtonRotP.hint:=rsRotateRight;
ToolButtonRotM.hint:=rsRotateLeft;
ToolButtonAllSky.hint:=rsShowAllSky;
ToolButtonToN.hint:=rsNorth;
ToolButtonToS.hint:=rsSouth;
ToolButtonToE.hint:=rsEast;
ToolButtonToW.hint:=rsWest;
ToolButtonToZ.hint:=rsZenith;
ToolButtonNew.hint:=rsCreateANewCh;
ToolButtonOpen.hint:=rsOpenAChart;
ToolButtonSave.hint:=rsSaveTheCurre;
ToolButtonPrint.hint:=rsPrintTheChar;
ToolButtonNightVision.hint:=rsNightVisionC;
ToolButtonCascade.hint:=rsCascade;
ToolButtonTile.hint:=rsTileVertical;
ToolButtonUndo.hint:=rsUndoLastChan;
ToolButtonRedo.hint:=rsRedoLastChan;
ToolButtonZoom.hint:=rsZoomIn;
ToolButtonUnZoom.hint:=rsZoomOut;
ToolButton1.hint:=rsSetFOV;
ToolButtonSearch.hint:=rsAdvancedSear;
MenuSearch.Caption:='&'+rsAdvancedSear+Ellipsis;
ToolButtonPosition.hint:=rsPosition;
MenuPosition.Caption:='&'+rsPosition+Ellipsis;
ToolButtonListObj.hint:=rsObjectList;
MenuListObj.Caption:='&'+rsObjectList+Ellipsis;
ToolButtonCal.hint:=rsEphemerisCal;
ToolButtonTdec.hint:=rsDecrementTim;
ToolButtonTnow.hint:=rsNow;
ToolButtonTinc.hint:=rsIncrementTim;
ToolButton13.Hint:=rsAnimation;
TConnect.hint:=rsControlPanel;
telescopeConnect1.caption:='&'+TConnect.hint+Ellipsis;
telescopeConnect.caption:='&'+TConnect.hint+Ellipsis;
TrackTelescope1.Caption:=rsTrackTelesco;
TSlew.hint:=rsSlew;
TSync.hint:=rsSync;
ToolButtonShowStars.hint:=rsShowStars;
ToolButtonShowNebulae.hint:=rsShowNebulae;
ToolButtonShowLines.hint:=rsShowLines;
ToolButtonVO.Hint:=rsShowVirtualO;
ToolButtonUObj.Hint:=rsShowUserDefi;
ToolButtonShowPictures.hint:=rsShowPictures;
ToolButtonBlink.hint:=rsBlinkingPict;
menublinkimage.Caption:='&'+rsBlinkingPict;
ToolButtonDSS.hint:=rsGetDSSImage;
MenuDSS.Caption:='&'+rsGetDSSImage+Ellipsis;
ToolButtonShowBackgroundImage.hint:=rsChangePictur;
ToolButtonShowPlanets.hint:=rsShowPlanets;
ToolButtonShowAsteroids.hint:=rsShowAsteroid;
ToolButtonShowComets.hint:=rsShowComets;
ToolButtonShowMilkyWay.hint:=rsShowMilkyWay;
ToolButtonGrid.hint:=rsShowCoordina;
ToolButtonGridEq.hint:=rsAddEquatoria;
ToolButtonCompass.Hint:=rsShowCompass;
Compass1.Caption:=rsShowCompass;
ToolButtonShowConstellationLine.hint:=rsShowConstell;
ToolButtonShowConstellationLimit.hint:=rsShowConstell2;
ToolButtonShowGalacticEquator.hint:=rsShowGalactic;
ToolButtonShowEcliptic.hint:=rsShowEcliptic;
ToolButtonShowMark.hint:=rsShowMark;
ToolButtonScale.Hint:=rsDistanceMeas;
MenuItem32.Caption:=rsLabels;
ToolButtonShowLabels.hint:=rsShowLabels;
ToolButtonEditlabels.hint:=rsEditLabel;
MenuEditlabels.Caption:='&'+rsEditLabel;
ToolButtonShowObjectbelowHorizon.hint:=rsShowObjectBe;
ToolButtonswitchbackground.hint:=rsSkyBackgroun;
Menuswitchbackground.caption:='&'+rsSkyBackgroun;
ToolButtonSyncChart.hint:=rsLinkAllChart;
MenuSyncChart.Caption:='&'+rsLinkAllChart;
MenuSyncChart.hint:=rsLinkAllChart;
ToolButtonTrack.hint:=rsNoObjectToLo;
MenuTrack.Caption:=rsNoObjectToLo;
ToolButtonswitchstars.hint:=rsChangeDrawin;
File1.caption:='&'+rsFile;
FileNewItem.caption:='&'+rsNewChart;
FileOpenItem.caption:='&'+rsOpen+Ellipsis;
FileSaveAsItem.caption:='&'+rsSaveAs;
SaveImage1.caption:='&'+rsSaveImage;
FileCloseItem.caption:='&'+rsCloseChart;
ResetDefaultChart.Caption:='&'+rsResetChartAn+Ellipsis;
Calendar1.caption:='&'+rsCalendar+Ellipsis;
VariableStar1.Caption:='&'+rsVariableStar2+Ellipsis;
Print2.caption:='&'+rsPrint+Ellipsis;
PrintSetup2.caption:='&'+rsPrinterSetup+Ellipsis;
PrintPreview1.Caption:='&'+rsPrintPreview;
FileExitItem.caption:='&'+rsExit;
Edit1.caption:='&'+rsEdit;
CopyItem.caption:='&'+rsCopy;
Undo1.caption:='&'+rsUndo;
Redo1.caption:='&'+rsRedo;
Setup1.caption:='&'+rsSetup;
SaveConfiguration.caption:='&'+rsSaveConfigur;
SaveConfigOnExit.caption:='&'+rsSaveConfigur2;
SetupTime.caption:='&'+rsDateTime+Ellipsis;
SetupObservatory.caption:='&'+rsObservatory+Ellipsis;
SetupDisplay.caption:='&'+rsDisplay+Ellipsis;
SetupChart.caption:='&'+rsChartCoordin+Ellipsis;
SetupSolSys.caption:='&'+rsSolarSystem+Ellipsis;
SetupSystem.caption:='&'+rsSystem+Ellipsis;
SetupInternet.caption:='&'+rsInternet+Ellipsis;
SetupPictures.caption:='&'+rsPictures+Ellipsis;
MenuItem7.caption:='&'+rsPictures+Ellipsis;
SetupCatalog.caption:='&'+rsCatalog+Ellipsis;
MenuItem8.caption:='&'+rsShowHideDSSI;
View1.caption:='&'+rsView;
FullScreen1.caption:='&'+rsFullScreen;
NightVision1.caption:='&'+rsNightVision;
oolBar1.caption:='&'+rsToolBar;
ViewToolsBar1.caption:='&'+rsAllToolsBar;
MainBar1.caption:='&'+rsMainBar;
ObjectBar1.caption:='&'+rsObjectBar;
LeftBar1.caption:='&'+rsLeftBar;
RightBar1.caption:='&'+rsRightBar;
ViewStatusBar1.caption:='&'+rsStatusBar;
ViewScrollBar1.caption:='&'+rsScrollBar;
ViewInformation1.caption:='&'+rsServerInform+Ellipsis;
ViewClock.Caption:='&'+rsClock+Ellipsis;
zoomplus1.caption:='&'+rsZoomIn;
zoomminus1.caption:='&'+rsZoomOut;
zoommenu.Caption:='&'+rsSetFOV+Ellipsis;
Chart1.caption:='&'+rsChart;
Projection1.caption:='&'+rsChartCoordin2;
EquatorialCoordinate1.caption:='&'+rsEquatorialCo;
AltAzProjection1.caption:='&'+rsAltAzCoordin;
EclipticProjection1.caption:='&'+rsEclipticCoor;
GalacticProjection1.caption:='&'+rsGalacticCoor;
ransformation1.caption:='&'+rsTransformati;
FlipX1.caption:='&'+rsMirrorHorizo;
FlipY1.caption:='&'+rsMirrorVertic;
rotplus1.caption:='&'+rsRotateRight;
rotminus1.caption:='&'+rsRotateLeft;
FieldofVision1.caption:='&'+rsFieldOfVisio;
allSky1.caption:='&'+rsShowAllSky;
ShowHorizon1.caption:='&'+rsViewHorizon;
toN1.caption:='&'+rsNorth;
toS1.caption:='&'+rsSouth;
toE1.caption:='&'+rsEast;
toW1.caption:='&'+rsWest;
ShowObjects1.caption:='&'+rsShowObjects;
ShowStars1.caption:='&'+rsShowStars;
ShowNebulae1.caption:='&'+rsShowNebulae;
ShowPictures1.caption:='&'+rsShowPictures;
ShowLines1.caption:='&'+rsShowLines;
ShowPlanets1.caption:='&'+rsShowPlanets;
ShowAsteroids1.caption:='&'+rsShowAsteroid;
ShowComets1.caption:='&'+rsShowComets;
ShowMilkyWay1.caption:='&'+rsShowMilkyWay;
ShowGrid1.caption:='&'+rsLinesGrid;
Grid1.caption:='&'+rsShowCoordina;
GridEQ1.caption:='&'+rsAddEquatoria;
ShowConstellationLine1.caption:='&'+rsShowConstell;
ShowConstellationLimit1.caption:='&'+rsShowConstell2;
ShowGalacticEquator1.caption:='&'+rsShowGalactic;
ShowEcliptic1.caption:='&'+rsShowEcliptic;
ShowMark1.caption:='&'+rsShowMark;
ShowLabels1.caption:='&'+rsShowLabels;
MenuChartInfo.Caption:=rsChartInforma;
MenuChartLegend.Caption:=rsChartLegend;
ShowObjectbelowthehorizon1.caption:='&'+rsBelowTheHori;
TelescopeSetup1.Caption:='&'+rsTelescopeSet+Ellipsis;
telescope1.caption:='&'+rsTelescope;
ControlPanel1.caption:='&'+rsControlPanel+Ellipsis;
telescopeSlew1.caption:='&'+rsSlew;
telescopeSync1.caption:='&'+rsSync;
Window1.caption:='&'+rsWindow;
WindowCascadeItem.caption:='&'+rsCascade;
NextChild1.Caption:='&'+rsNextChart;
WindowTileItem.caption:='&'+rsTileHorizont;
WindowTileItem2.caption:='&'+rsTileVertical;
Maximize1.caption:='&'+rsMaximize;
Help1.caption:='&'+rsHelp;
HelpContents1.caption:='&'+rsHelpContents+Ellipsis;
HelpFaq1.Caption:='&'+rsFAQ+Ellipsis;
HelpQS1.Caption:='&'+rsQuickStartGu+Ellipsis;
HomePage1.caption:='&'+rsSkychartHome+Ellipsis;
Maillist1.caption:='&'+rsMailList+Ellipsis;
BugReport1.caption:='&'+rsReportAProbl+Ellipsis;
HelpAboutItem.caption:='&'+rsAbout+Ellipsis;
ReleaseNotes1.Caption:='&'+rsReleaseNotes+Ellipsis;
ButtonMoreStar.Hint:=rsMoreStars;
ButtonLessStar.Hint:=rsLessStars;
ButtonMoreNeb.Hint:=rsMoreNebulae;
ButtonLessNeb.Hint:=rsLessNebulae;
MenuMoreStar.Caption:='&'+rsMoreStars;
MenuLessStar.Caption:='&'+rsLessStars;
MenuMoreNeb.Caption:='&'+rsMoreNebulae;
MenuLessNeb.Caption:='&'+rsLessNebulae;
MenuStarNum.Caption:='&'+rsNumberOfStar;
MenuNebNum.Caption:='&'+rsNumberOfNebu;
ResetAllLabels1.caption:='&'+rsResetAllLabe;
quicksearch.Hint:=rsSearch;
TimeVal.Hint:=rsTime;
TimeU.Hint:=rsTimeUnits;
Field1.Hint:=rsSetFOVTo;
Field2.Hint:=rsSetFOVTo;
Field3.Hint:=rsSetFOVTo;
Field4.Hint:=rsSetFOVTo;
Field5.Hint:=rsSetFOVTo;
Field6.Hint:=rsSetFOVTo;
Field7.Hint:=rsSetFOVTo;
Field8.Hint:=rsSetFOVTo;
Field9.Hint:=rsSetFOVTo;
Field10.Hint:=rsSetFOVTo;
pla[1]:=rsMercury;
pla[2]:=rsVenus;
pla[4]:=rsMars;
pla[5]:=rsJupiter;
pla[6]:=rsSaturn;
pla[7]:=rsUranus;
pla[8]:=rsNeptune;
pla[9]:=rsPluto;
pla[10]:=rsSun;
pla[11]:=rsMoon;
pla[31]:=rsSatRing;
pla[32]:=rsEarthShadow;
SetHelpDB(HTMLHelpDatabase1);
SetHelp(self,hlpIndex);
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
      if (i<0)and(quicksearch.Items.Count>=MaxQuickSearch) then i:=MaxQuickSearch-1;
      if i>=0 then quicksearch.Items.Delete(i);
      quicksearch.Items.Insert(0,Num);
      quicksearch.ItemIndex:=0;
   end
   else begin
      SetLPanel1(Format(rsNotFoundInAn, [Num]));
   end;
end;


function Tf_main.GenericSearch(cname,Num:string):boolean;
var ok : Boolean;
    ar1,de1,saveChartJD,dyear : Double;
    saveCurYear,saveCurMonth,saveCurDay:integer;
    i : integer;
    chart:TFrame;
    stype: string;
    itype:integer;
    lastra,lastdec,lasttrra,lasttrde,lastxx,lastyy,lastzz: double;
    lasttype,lastobj: integer;
    lastname,lasttrname: string;
    lastok: boolean;
label findit;
begin
result:=false;
if trim(num)='' then exit;
chart:=nil;
stype:='';
if cname='' then begin
  if MultiFrame1.ActiveObject is Tf_chart then chart:=MultiFrame1.ActiveObject;
end else begin
 for i:=0 to MultiFrame1.ChildCount-1 do
   if MultiFrame1.Childs[i].DockedObject is Tf_chart then
      if MultiFrame1.Childs[i].caption=cname then chart:=MultiFrame1.Childs[i].DockedObject;
end;
if chart is Tf_chart then with chart as Tf_chart do begin
   lastok:=sc.cfgsc.FindOK;
   lastra:=sc.cfgsc.FindRA;
   lastdec:=sc.cfgsc.FindDEC;
   lastname:=sc.cfgsc.FindName;
   lasttrra:=sc.cfgsc.TrackRA;
   lasttrde:=sc.cfgsc.TrackDEC;
   lasttype:=sc.cfgsc.TrackType;
   lastobj:=sc.cfgsc.Trackobj;
   lasttrname:=sc.cfgsc.TrackName;
   lastXX:=sc.cfgsc.FindX;
   lastYY:=sc.cfgsc.FindY;
   lastZZ:=sc.cfgsc.FindZ;
   if sc.cfgsc.shownebulae then begin
     stype:='N';  itype:=ftNeb;
     ok:=catalog.SearchNebulae(Num,ar1,de1) ;
     if ok then goto findit;
   end;
   if sc.cfgsc.showstars then begin
     stype:='V*'; itype:=ftVar;
     ok:=catalog.SearchVarStar(Num,ar1,de1) ;
     if ok then goto findit;
   end;
   if sc.cfgsc.showstars then begin
     stype:='D*'; itype:=ftDbl;
     ok:=catalog.SearchDblStar(Num,ar1,de1) ;
     if ok then goto findit;
   end;
   if sc.cfgsc.showstars then begin
     stype:='*';  itype:=ftStar;
     ok:=catalog.SearchStar(Num,ar1,de1) ;
     if ok then goto findit;
   end;
   if sc.cfgsc.ShowPlanet then begin
     stype:='P';  itype:=ftPla;
     ok:=planet.FindPlanetName(trim(Num),ar1,de1,sc.cfgsc);
     if ok then goto findit;
   end;
   if sc.cfgsc.showstars then begin
     stype:='*';  itype:=ftStar;
     ok:=catalog.SearchStarName(Num,ar1,de1) ;
     if ok then goto findit;
   end;
   if sc.cfgsc.shownebulae then begin
     stype:='N';  itype:=ftNeb;
     ok:=f_search.SearchNebName(Num,ar1,de1) ;
     if ok then goto findit;
   end;
   if sc.cfgsc.ShowAsteroid then begin
     stype:='As';  itype:=ftAst;
     ok:=planet.FindAsteroidName(trim(Num),ar1,de1,sc.cfgsc);
     if ok then goto findit;
   end;
   if sc.cfgsc.ShowComet then begin
     stype:='Cm'; itype:=ftCom;
     ok:=planet.FindCometName(trim(Num),ar1,de1,sc.cfgsc);
     if ok then goto findit;
   end;

Findit:
   result:=ok;
   if ok then begin
   if VerboseMsg then
    WriteTrace('GenericSearch');
      sc.cfgsc.TrackOn:=false;
      IdentLabel.visible:=false;
      sc.cfgsc.FindType:=ftInv;
      if itype=ftStar then begin     // search in catalog for proper motion
          saveChartJD:=sc.cfgsc.JDChart;
          saveCurYear:=sc.cfgsc.CurYear;
          saveCurMonth:=sc.cfgsc.CurMonth;
          saveCurDay:=sc.cfgsc.CurDay;
          sc.cfgsc.JDChart:=jd2000;
          sc.cfgsc.CurYear:=2000;
          sc.cfgsc.CurMonth:=1;
          sc.cfgsc.CurDay:=1;
          ok:=sc.FindatRaDec(ar1,de1,0.00005,true,true);               // search 10 sec radius
          if (not ok)or(sc.cfgsc.FindType<>itype) then ok:=sc.FindatRaDec(ar1,de1,0.0005,true,true); // if not search 1.7 min
          if (not ok)or(sc.cfgsc.FindType<>itype) then ok:=sc.FindatRaDec(ar1,de1,0.001,true,true);  // big idx position, error search 3.5 min
          if (not ok)or(sc.cfgsc.FindType<>itype) then ok:=sc.FindatRaDec(ar1,de1,0.003,true,true);  // big idx position, error search 10 min
          if (not ok)or(sc.cfgsc.FindType<>itype) then ok:=sc.FindatRaDec(ar1,de1,0.006,true,true);  // big idx position, error search 20 min
          if (not ok)or(sc.cfgsc.FindType<>itype) then begin  // object in index but not in any active catalog
            sc.cfgsc.FindName:=Num;
            sc.cfgsc.FindDesc:=ARpToStr(rmod(rad2deg*ar1/15+24, 24))+tab+DEpToStr(rad2deg*de1)+tab+stype+tab+Num+tab+''+rsObjectPositi+'';
            sc.cfgsc.FindRA:=ar1;
            sc.cfgsc.FindDec:=de1;
            sc.cfgsc.FindSize:=0;
            sc.cfgsc.FindPM:=false;
            sc.cfgsc.FindOK:=true;
            sc.cfgsc.FindType:=ftInv;
            sc.cfgsc.TrackOn:=false;
            sc.cfgsc.TrackType:=6;
            sc.cfgsc.TrackRA:=ar1;
            sc.cfgsc.TrackDec:=de1;
            sc.cfgsc.TrackName:=Num;
          end;
          sc.cfgsc.JDChart := saveChartJD;
          sc.cfgsc.CurYear  := saveCurYear;
          sc.cfgsc.CurMonth := saveCurMonth;
          sc.cfgsc.CurDay   := saveCurDay;
          if sc.cfgsc.FindStarPM then begin
            dyear:=(sc.cfgsc.CurYear+DayofYear(sc.cfgsc.CurYear,sc.cfgsc.CurMonth,sc.cfgsc.CurDay)/365.25)-sc.cfgsc.FindPMEpoch;
            propermotion(sc.cfgsc.FindRA,sc.cfgsc.FindDec,dyear,sc.cfgsc.FindPMra,sc.cfgsc.FindPMde,sc.cfgsc.FindPMfullmotion,sc.cfgsc.FindPMpx,sc.cfgsc.FindPMrv);
          end;
      end else begin
        sc.cfgsc.FindName:=Num;
        sc.cfgsc.FindDesc:=Num;
        sc.cfgsc.FindRA:=ar1;
        sc.cfgsc.FindDec:=de1;
        sc.cfgsc.FindSize:=0;
        sc.cfgsc.FindPM:=false;
        sc.cfgsc.FindOK:=true;
        sc.cfgsc.FindType:=itype;
        sc.cfgsc.TrackOn:=false;
        sc.cfgsc.TrackType:=6;
        sc.cfgsc.TrackRA:=ar1;
        sc.cfgsc.TrackDec:=de1;
        sc.cfgsc.TrackName:=Num;
      end;
      precession(jd2000,sc.cfgsc.JDchart,sc.cfgsc.FindRA,sc.cfgsc.FindDec);
      if sc.cfgsc.ApparentPos then apparent_equatorial(sc.cfgsc.FindRA,sc.cfgsc.FindDec,sc.cfgsc,true,itype<ftPla);
      sc.cfgsc.TrackRA:=sc.cfgsc.FindRA;
      sc.cfgsc.TrackDec:=sc.cfgsc.FindDec;
      sc.movetoradec(sc.cfgsc.FindRA,sc.cfgsc.FindDec);
      Refresh;
      sc.cfgsc.FindOK    := lastok;
      sc.cfgsc.FindRA    := lastra;
      sc.cfgsc.FindDEC   := lastdec;
      sc.cfgsc.FindName  := lastname;
      sc.cfgsc.TrackRA   := lasttrra;
      sc.cfgsc.TrackDEC  := lasttrde;
      sc.cfgsc.TrackType := lasttype;
      sc.cfgsc.Trackobj  := lastobj;
      sc.cfgsc.TrackName := lasttrname;
      sc.cfgsc.FindX     := lastXX;
      sc.cfgsc.FindY     := lastYY;
      sc.cfgsc.FindZ     := lastZZ;
      IdentXY(sc.cfgsc.Xcentre,sc.cfgsc.Ycentre,false,true);
   end;
end;
end;

procedure Tf_main.UpdateBtn(fx,fy:integer;tc:boolean;sender:TObject);
var cname:string;
    i: integer;
begin
if (sender<>nil)and(MultiFrame1.ActiveObject=sender) then begin
  if fx>0 then begin FlipButtonX.ImageIndex:=15 ; Flipx1.checked:=false; end
          else begin FlipButtonX.ImageIndex:=16 ; Flipx1.checked:=true;  end;
  if fy>0 then begin FlipButtonY.ImageIndex:=17 ; Flipy1.checked:=false; end
          else begin FlipButtonY.ImageIndex:=18 ; Flipy1.checked:=true; end;
  if tc   then begin
               TConnect.ImageIndex:=49;
               TConnect.Hint:=rsControlPanel;
               telescopeConnect1.caption:='&'+TConnect.hint+Ellipsis;
               telescopeConnect1.Checked:=true;
               //Tf_chart(sender).Connect1.caption :='&'+TConnect.hint;
          end else begin
               TConnect.ImageIndex:=48;
               TConnect.Hint:=rsControlPanel;
               telescopeConnect1.caption:='&'+TConnect.hint+Ellipsis;
               telescopeConnect1.Checked:=false;
               //Tf_chart(sender).Connect1.caption :='&'+TConnect.hint;
          end;
  ViewClock.Checked:=(f_clock<>nil)and(f_clock.Visible);
  PrintPreview1.Visible:=(cfgm.PrintMethod=0);
  cname:=MultiFrame1.ActiveChild.Caption;
  for i:=0 to TabControl1.Tabs.Count-1 do begin
      if TabControl1.Tabs[i]=cname then begin
         TabControl1.TabIndex:=i;
         break;
      end;
  end;
  with MultiFrame1.ActiveObject as Tf_chart do begin
    if sc.cfgsc.ManualTelescope then begin
       ControlPanel1.Visible:=false;
       telescopeSlew1.Visible:=false;
       telescopeSync1.Visible:=false;
       TSlew.Enabled:=false;
       TSync.Enabled:=false;
    end else begin
       ControlPanel1.Visible:=sc.cfgsc.IndiTelescope;
       telescopeSlew1.Visible:=true;
       telescopeSync1.Visible:=true;
       TSlew.Enabled:=true;
       TSync.Enabled:=true;
    end;
    if (abs(sc.cfgsc.theta)>(pi-secarc))and(abs(sc.cfgsc.theta)<(pi+secarc)) then ToolButtonRot180.ImageIndex:=93
       else  ToolButtonRot180.ImageIndex:=92;
    TrackTelescope1.Checked:=(sc.cfgsc.TrackOn and (sc.cfgsc.TrackName=rsTelescope));
    Tf_chart(sender).TrackTelescope.Checked:=TrackTelescope1.Checked;
    toolbuttonshowStars.down:=sc.cfgsc.showstars;
    ShowStars1.checked:=sc.cfgsc.showstars;
    toolbuttonshowNebulae.down:=sc.cfgsc.shownebulae;
    ShowNebulae1.checked:=sc.cfgsc.shownebulae;
    ToolButtonVO.Down:=(catalog.cfgcat.starcatdef[vostar-BaseStar] or catalog.cfgcat.nebcatdef[voneb-BaseNeb]);
    ToolButtonUObj.Down:=catalog.cfgcat.nebcatdef[uneb-BaseNeb];
    toolbuttonShowPictures.down:=sc.cfgsc.ShowImages;
    ShowPictures1.checked:=sc.cfgsc.ShowImages;
    ToolButtonShowBackgroundImage.down:=sc.cfgsc.ShowBackgroundImage;
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
    ToolButtonScale.Down := sc.cfgsc.ShowScale;
    ShowLabels1.checked:=sc.cfgsc.Showlabelall;
    MenuChartInfo.Checked:=sc.cfgsc.ShowLabel[8];
    MenuChartLegend.Checked:=sc.cfgsc.ShowLegend;
    toolbuttonGrid.down:=sc.cfgsc.ShowGrid;
    Grid1.checked:=sc.cfgsc.ShowGrid;
    toolbuttonGridEq.down:=sc.cfgsc.ShowEqGrid;
    GridEQ1.checked:=sc.cfgsc.ShowEqGrid;
    ToolButtonCompass.Down:=sc.catalog.cfgshr.ShowCRose;
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
    Menuswitchbackground.Checked:=sc.plot.cfgplot.autoskycolor;
    if sc.cfgsc.ProjPole=AltAz then begin
       ToolButtonShowObjectbelowHorizon.Enabled:=true;
       ToolButtonShowObjectbelowHorizon.Indeterminate:=false;
       ToolButtonswitchbackground.Enabled:=true;
       ToolButtonswitchbackground.Indeterminate:=false;
       ShowObjectbelowthehorizon1.Enabled:=true;
    end else begin
       ToolButtonShowObjectbelowHorizon.Enabled:=false;
       ToolButtonShowObjectbelowHorizon.Indeterminate:=true;
       ToolButtonswitchbackground.Enabled:=false;
       ToolButtonswitchbackground.Indeterminate:=true;
       ShowObjectbelowthehorizon1.Enabled:=false;
    end;
    ToolButtonBlink.Down:=BlinkTimer.enabled;
    ToolButtonSyncChart.down:=cfgm.SyncChart;
    ToolButtonTrack.down:=sc.cfgsc.TrackOn;
    if sc.cfgsc.TrackOn then begin
       ToolButtonTrack.Hint:=rsUnlockChart;
       MenuTrack.Caption:=rsUnlockChart;
     end else if ((sc.cfgsc.TrackType>=1)and(sc.cfgsc.TrackType<=3))or(sc.cfgsc.TrackType=6)
     then begin
       ToolButtonTrack.Hint:=Format(rsLockOn, [sc.cfgsc.Trackname]);
       MenuTrack.Caption:=Format(rsLockOn, [sc.cfgsc.Trackname]);
     end else begin
       ToolButtonTrack.Hint:=rsNoObjectToLo;
       MenuTrack.Caption:=rsNoObjectToLo;
    end;
    case sc.plot.cfgplot.starplot of
    0: begin ToolButtonswitchstars.down:=true; ToolButtonswitchstars.marked:=true; end;
    1: begin ToolButtonswitchstars.down:=true; ToolButtonswitchstars.marked:=false; end;
    2: begin ToolButtonswitchstars.down:=false; ToolButtonswitchstars.marked:=false; end;
    end;
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
    Field1.Hint:=rsSetFOVTo+blank+DEmToStr(sc.catalog.cfgshr.FieldNum[0]);
    Field2.Hint:=rsSetFOVTo+blank+DEmToStr(sc.catalog.cfgshr.FieldNum[1]);
    Field3.Hint:=rsSetFOVTo+blank+DEmToStr(sc.catalog.cfgshr.FieldNum[2]);
    Field4.Hint:=rsSetFOVTo+blank+DEmToStr(sc.catalog.cfgshr.FieldNum[3]);
    Field5.Hint:=rsSetFOVTo+blank+DEmToStr(sc.catalog.cfgshr.FieldNum[4]);
    Field6.Hint:=rsSetFOVTo+blank+DEmToStr(sc.catalog.cfgshr.FieldNum[5]);
    Field7.Hint:=rsSetFOVTo+blank+DEmToStr(sc.catalog.cfgshr.FieldNum[6]);
    Field8.Hint:=rsSetFOVTo+blank+DEmToStr(sc.catalog.cfgshr.FieldNum[7]);
    Field9.Hint:=rsSetFOVTo+blank+DEmToStr(sc.catalog.cfgshr.FieldNum[8]);
    Field10.Hint:=rsSetFOVTo+blank+DEmToStr(sc.catalog.cfgshr.FieldNum[9]);
    SetFov1.caption:=Field1.hint;
    SetFov2.caption:=Field2.hint;
    SetFov3.caption:=Field3.hint;
    SetFov4.caption:=Field4.hint;
    SetFov5.caption:=Field5.hint;
    SetFov6.caption:=Field6.hint;
    SetFov7.caption:=Field7.hint;
    SetFov8.caption:=Field8.hint;
    SetFov9.caption:=Field9.hint;
    SetFov10.caption:=Field10.hint;
  end;
end;
end;

procedure Tf_main.ChartMove(Sender: TObject);
begin
if MultiFrame1.ActiveObject=sender then begin   // active chart refresh
//  application.processmessages;
  if cfgm.SyncChart then SyncChild;
end;
end;

Function Tf_main.NewChart(cname:string):string;
begin
if cname='' then cname:=rsChart_ + IntToStr(MultiFrame1.ChildCount + 1);
cname:=GetUniqueName(cname,false);
if CreateChild(cname,true,def_cfgsc,def_cfgplot) then result:=msgOK+blank+cname
  else result:=msgFailed;
end;

Function Tf_main.CloseChart(cname:string):string;
var i: integer;
begin
result:=msgNotFound;
for i:=0 to MultiFrame1.ChildCount-1 do
  if MultiFrame1.Childs[i].DockedObject is Tf_chart then
     with MultiFrame1.Childs[i] do
        if caption=cname then begin
           Close;
           result:=msgOK;
        end;
end;

Function Tf_main.ListChart:string;
var i: integer;
begin
result:='';
for i:=0 to MultiFrame1.ChildCount-1 do
  if MultiFrame1.Childs[i].DockedObject is Tf_chart then
     result:=result+';'+MultiFrame1.Childs[i].caption;

if result>'' then result:=msgOK+blank+result+';'
             else result:=msgFailed+blank+'No Chart!';
end;

Function Tf_main.SelectChart(cname:string):string;
var i: integer;
begin
result:=msgNotFound;
for i:=0 to MultiFrame1.ChildCount-1 do
  if MultiFrame1.Childs[i].DockedObject is Tf_chart then
     with MultiFrame1.Childs[i] do
        if InitOK and (caption=cname) then begin
         setfocus;
         result:=msgOK;
        end;
end;

Function Tf_main.HelpCmd(cname:string):string;
var i: integer;
begin
result:='';
if cname='' then begin
   for i:=1 to numcmdmain do
      result:=result+maincmdlist[i,1]+blank+maincmdlist[i,3]+crlf;
   for i:=1 to numcmd do
      result:=result+cmdlist[i,1]+blank+cmdlist[i,3]+crlf;
   result:=result+crlf+msgOK;
end else begin
   for i:=1 to numcmdmain do
      if maincmdlist[i,1]=cname then result:=result+maincmdlist[i,1]+blank+maincmdlist[i,3]+crlf;
   for i:=1 to numcmd do
      if cmdlist[i,1]=cname then result:=result+cmdlist[i,1]+blank+cmdlist[i,3]+crlf;
   if result>'' then result:=result+crlf+msgOK
                else result:=msgNotFound;
end;
end;

function Tf_main.ExecuteCmd(cname:string; arg:Tstringlist):string;
var i,n,w,h : integer;
    cmd:string;
    chart:TFrame;
    child:TChildFrame;
begin
if VerboseMsg then begin
  cmd:=cname+' Receive command:';
  for i:=0 to arg.Count-1 do cmd:=cmd+blank+arg[i];
   WriteTrace(cmd);
end;
cmd:=trim(uppercase(arg[0]));
for i:=1 to arg.Count-1 do arg[i]:=StringReplace(arg[i],'"','',[rfReplaceAll]);
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
 6 : result:=msgOK+blank+P1L1.Caption;
 7 : result:=msgOK+blank+P0L1.Caption;
 8 : result:=msgOK+blank+topmsg;
 9 : result:=Find(StrToIntDef(arg[1],99),arg[2]);
 10 : result:=SaveChart(arg[1]);
 11 : result:=OpenChart(arg[1]);
 12 : result:=HelpCmd(trim(uppercase(arg[1])));
 13 : begin ForceClose:=true; Close; end;
 14 : begin ResetDefaultChartExecute(nil); result:=msgOK; end;
 15 : result:=LoadDefaultChart(arg[1]);
 16 : result:=SetGCat(arg[1],arg[2],arg[3],arg[4],arg[5]);
else begin
 result:='Bad chart name '+cname;
 if cname='' then begin
    if MultiFrame1.ActiveObject is Tf_chart then begin
      chart:=MultiFrame1.ActiveObject;
      child:=MultiFrame1.ActiveChild;
    end;
 end else begin
    for i:=0 to MultiFrame1.ChildCount-1 do
      if MultiFrame1.Childs[i].DockedObject is Tf_chart then
         if MultiFrame1.Childs[i].caption=cname then begin
           chart:=MultiFrame1.Childs[i].DockedObject;
           child:=MultiFrame1.Childs[i];
         end;
 end;
 if chart is Tf_chart then with chart as Tf_chart do begin
    if cmd='RESIZE' then begin // special case with action on main and on the chart
         w:=StrToIntDef(arg[1],child.Width);
         h:=StrToIntDef(arg[2],child.Height);
         if (w>10)and(h>10) then begin
           MultiFrame1.Maximized:=false;
           if InitOK then begin // only if form is show
             if VertScrollBar.Visible then w:=w+VertScrollBar.Width;
             if HorScrollBar.Visible then h:=h+HorScrollBar.Height;
             h:=h+child.TopBar.Height+child.BotBar.Height+child.MenuBar.Height;
             w:=w+child.LeftBar.Width+child.RightBar.width;
           end;
           child.width:=w;
           child.height:=h;
           arg[1]:=inttostr(w);
           arg[2]:=inttostr(h);
         end else begin
           result:=msgFailed+' invalid window size';
           exit;
         end;
    end;
    if RestoreState and (cmd='REDRAW') then begin
       WindowState:=SaveState;
       RestoreState:=false;
       {$ifdef mswindows}
       ShowWindow(f_main.Handle, SW_RESTORE);
       {$else}
       f_main.show;
       {$endif}
    end;
    result:=(chart as Tf_chart).ExecuteCmd(arg);
 end;
 end;
end;
end;

procedure Tf_main.SendInfo(Sender: TObject; origin,str:string);
var i : integer;
begin
if (origin='') and (str='') then exit;
for i:=1 to Maxwindow do
 if (TCPDaemon<>nil)
    and(TCPDaemon.ThrdActive[i])
    and (TCPDaemon.TCPThrd[i]<>nil)
    and(TCPDaemon.TCPThrd[i].sock<>nil)
    and(not TCPDaemon.TCPThrd[i].terminated)
    then TCPDaemon.TCPThrd[i].SendData('>'+tab+origin+' :'+tab+str);
{$ifdef mswindows}
{if DDEopen then begin
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
end; }
{$endif}
end;

procedure Tf_main.StartServer;
begin
 try
 TCPDaemon:=TTCPDaemon.create;
 TCPDaemon.keepalive:=cfgm.keepalive;
 TCPDaemon.onGetACtiveChart:=GetACtiveChart;
 TCPDaemon.onErrorMsg:=TCPShowError;
 TCPDaemon.onShowSocket:=TCPShowSocket;
 TCPDaemon.onExecuteCmd:=ExecuteCmd;
 TCPDaemon.IPaddr:=cfgm.ServerIPaddr;
 TCPDaemon.IPport:=cfgm.ServerIPport;
 TCPDaemon.Start;
 except
  SetLpanel1(rsTCPIPService);
 end;
end;

procedure Tf_main.StopServer;
var i :integer;
    d :double;
    {$ifdef mswindows}
    Registry1: TRegistry;
    {$else}
    f: textfile;
    {$endif}
begin
if TCPDaemon=nil then exit;
{$ifdef mswindows}
  Registry1 := TRegistry.Create;
  with Registry1 do begin
    Openkey('Software\Astro_PC\Ciel\Status',true);
    WriteString('TcpPort','0');
    CloseKey;
  end;
  Registry1.Free;
{$else}
  AssignFile(f,slash(TempDir)+'tcpport');
  Rewrite(f);
  Write(f,'0');
  CloseFile(f);
{$endif}
SetLpanel1(rsStopTCPIPSer);
try
screen.cursor:=crHourglass;
for i:=1 to Maxwindow do
 if (TCPDaemon.TCPThrd[i]<>nil) then begin
    TCPDaemon.TCPThrd[i].stoping:=true;
 end;
d:=now+1.16E-5;  // 1 seconde delay to close the thread, sleep to interrupt the thread
while now<d do begin; application.processmessages; sleep(50); end;
TCPDaemon.stoping:=true;
screen.cursor:=crDefault;
except
 screen.cursor:=crDefault;
end;
end;

procedure Tf_main.OtherInstance(Sender : TObject; ParamCount: Integer; Parameters: array of String);
var i : integer;
    buf,p: string;
begin
// process param from new instance
  if not InitOK then exit;  // ignore if not initialized
  buf:='';
  Params.Clear;
  for i:=0 to Paramcount-1 do begin
      p:=Parameters[i];
      if copy(p,1,2)='--' then begin
         if buf<>'' then Params.Add(buf);
         buf:=p;
      end
      else
         buf:=buf+blank+p;
  end;
  if buf<>'' then Params.Add(buf);
  buf:='';
  for i:=0 to Params.Count-1 do buf:=buf+blank+params[i];
  WriteTrace('Receive from new instance: '+buf);
  ProcessParamsQuit;
  ProcessParams2;
end;

procedure Tf_main.InstanceRunning(Sender : TObject);
var i : integer;
    parms : string;
begin
for i:=0 to Params.Count-1 do begin
   parms:= Params[i];
   if parms='--unique' then begin
      debugln('Other instance running, exit now.');
      UniqueInstance1.RetryOrHalt;
      debugln('... maybe not, try to continue ...');
   end;
end;
end;

// Parameters that need to be set before program initialisation
procedure Tf_main.ProcessParams1;
var i,p: integer;
    cmd, parms, parm : string;
begin
for i:=0 to Params.Count-1 do begin
   parms:= Params[i];
   p:=pos('=',parms);
   if p>0 then begin
      cmd:=trim(copy(parms,1,p-1));
      parm:=trim(copy(parms,p+1,999));
   end else begin
      cmd:=trim(parms);
      parm:='';
   end;
   if cmd='--config' then begin  // specify .ini file
      if parm<>'' then begin
         ForceConfig:=SafeUTF8ToSys(trim(parm));
      end;
   end else if cmd='--userdir' then begin
      ForceUserDir:=SafeUTF8ToSys(trim(parm));
   end else if cmd='--daemon' then begin
      showsplash:=false;
      Application.ShowMainForm:=false;
   end else if cmd='--nosplash' then begin
      showsplash:=false;
   end else if cmd='--verbose' then begin
      VerboseMsg:=true;
   end else if cmd='--test' then begin
   end;
end;
end;

// Parameters that need to be set after a chart is available
procedure Tf_main.ProcessParams2;
var i,p: integer;
    cmd, parm, parms,resp : string;
    pp: TStringList;
    chartchanged: boolean;
begin
if MultiFrame1.ChildCount=0 then exit;
chartchanged:=false;
pp:=TStringList.Create;
try
// parameters that need to be processed very first
for i:=0 to Params.Count-1 do begin
   pp.Clear;
   parms:= Params[i];
   p:=pos('=',parms);
   if p>0 then begin
      cmd:=trim(copy(parms,1,p-1));
      parm:=trim(copy(parms,p+1,999));
   end else begin
      cmd:=trim(parms);
      parm:='';
   end;
   if cmd='--loaddef' then begin
      pp.Add('LOADDEFAULT');
      pp.Add(parm);
      for p:=pp.count to MaxCmdArg do pp.add('');
      resp:=ExecuteCmd('',pp);
      if (resp<>msgOK)and(resp<>'') then WriteTrace(resp);
      chartchanged:=true;
   end;
   if cmd='--load' then begin
      pp.Add('LOAD');
      pp.Add(parm);
      for p:=pp.count to MaxCmdArg do pp.add('');
      resp:=ExecuteCmd('',pp);
      if (resp<>msgOK)and(resp<>'') then WriteTrace(resp);
      chartchanged:=true;
   end;
   if cmd='--nosave' then begin
      SaveConfigOnExit.checked:=false;
   end;
end;
if chartchanged then begin
  pp.Clear;
  pp.Add('REDRAW');
  ExecuteCmd('',pp);
end;
// parameters that need to be processed first
for i:=0 to Params.Count-1 do begin
   pp.Clear;
   parms:= Params[i];
   p:=pos('=',parms);
   if p>0 then begin
      cmd:=trim(copy(parms,1,p-1));
      parm:=trim(copy(parms,p+1,999));
   end else begin
      cmd:=trim(parms);
      parm:='';
   end;
   if cmd='--setobs' then begin
      pp.Add('SETOBS');
      pp.Add(parm);
      for p:=pp.count to MaxCmdArg do pp.add('');
      resp:=ExecuteCmd('',pp);
      if (resp<>msgOK)and(resp<>'') then WriteTrace(resp);
      chartchanged:=true;
   end else if cmd='--settz' then begin
      pp.Add('SETTZ');
      pp.Add(parm);
      for p:=pp.count to MaxCmdArg do pp.add('');
      resp:=ExecuteCmd('',pp);
      if (resp<>msgOK)and(resp<>'') then WriteTrace(resp);
      chartchanged:=true;
   end else if cmd='--setdate' then begin
      pp.Add('SETDATE');
      pp.Add(parm);
      for p:=pp.count to MaxCmdArg do pp.add('');
      resp:=ExecuteCmd('',pp);
      if (resp<>msgOK)and(resp<>'') then WriteTrace(resp);
      chartchanged:=true;
   end else if cmd='--setcat' then begin
      parm:='SETCAT '+parm;
      splitarg(parm,blank,pp);
      for p:=pp.count to MaxCmdArg do pp.add('');
      resp:=ExecuteCmd('',pp);
      if (resp<>msgOK)and(resp<>'') then WriteTrace(resp);
      chartchanged:=true;
   end;
end;
// parameters that need to be processed afterward
for i:=0 to Params.Count-1 do begin
   pp.Clear;
   parms:= Params[i];
   p:=pos('=',parms);
   if p>0 then begin
      cmd:=trim(copy(parms,1,p-1));
      parm:=trim(copy(parms,p+1,999));
   end else begin
      cmd:=trim(parms);
      parm:='';
   end;
   if cmd='--search' then begin
      pp.Add('SEARCH');
      pp.Add(parm);
      for p:=pp.count to MaxCmdArg do pp.add('');
      resp:=ExecuteCmd('',pp);
      if (resp<>msgOK)and(resp<>'') then WriteTrace(resp);
      chartchanged:=true;
   end else if cmd='--setproj' then begin
      pp.Add('SETPROJ');
      pp.Add(parm);
      for p:=pp.count to MaxCmdArg do pp.add('');
      resp:=ExecuteCmd('',pp);
      if (resp<>msgOK)and(resp<>'') then WriteTrace(resp);
      chartchanged:=true;
   end else if cmd='--setfov' then begin
      pp.Add('SETFOV');
      pp.Add(parm);
      for p:=pp.count to MaxCmdArg do pp.add('');
      resp:=ExecuteCmd('',pp);
      if (resp<>msgOK)and(resp<>'') then WriteTrace(resp);
      chartchanged:=true;
   end else if cmd='--setra' then begin
      pp.Add('SETRA');
      pp.Add(parm);
      for p:=pp.count to MaxCmdArg do pp.add('');
      resp:=ExecuteCmd('',pp);
      if (resp<>msgOK)and(resp<>'') then WriteTrace(resp);
      chartchanged:=true;
   end else if cmd='--setdec' then begin
      pp.Add('SETDEC');
      pp.Add(parm);
      for p:=pp.count to MaxCmdArg do pp.add('');
      resp:=ExecuteCmd('',pp);
      if (resp<>msgOK)and(resp<>'') then WriteTrace(resp);
      chartchanged:=true;
   end else if cmd='--resize' then begin
      parm:='RESIZE '+parm;
      splitarg(parm,blank,pp);
      for p:=pp.count to MaxCmdArg do pp.add('');
      resp:=ExecuteCmd('',pp);
      if (resp<>msgOK)and(resp<>'') then WriteTrace(resp);
   end;
end;
if chartchanged then begin
  pp.Clear;
  pp.Add('REDRAW');
  ExecuteCmd('',pp);
end;
// parameters that need to be processed after the position is set
for i:=0 to Params.Count-1 do begin
   pp.Clear;
   parms:= Params[i];
   p:=pos('=',parms);
   if p>0 then begin
      cmd:=trim(copy(parms,1,p-1));
      parm:=trim(copy(parms,p+1,999));
   end else begin
      cmd:=trim(parms);
      parm:='';
   end;
   if cmd='--dss' then begin
      parm:='PDSS '+parm;
      splitarg(parm,blank,pp);
      for p:=pp.count to MaxCmdArg do pp.add('');
      resp:=ExecuteCmd('',pp);
      if (resp<>msgOK)and(resp<>'') then WriteTrace(resp);
   end;
end;
// parameters that need to be processed after the chart is draw
for i:=0 to Params.Count-1 do begin
   pp.Clear;
   parms:= Params[i];
   p:=pos('=',parms);
   if p>0 then begin
      cmd:=trim(copy(parms,1,p-1));
      parm:=trim(copy(parms,p+1,999));
   end else begin
      cmd:=trim(parms);
      parm:='';
   end;
   if cmd='--saveimg' then begin
      parm:='SAVEIMG '+parm;
      splitarg(parm,blank,pp);
      for p:=pp.count to MaxCmdArg do pp.add('');
      resp:=ExecuteCmd('',pp);
      if (resp<>msgOK)and(resp<>'') then WriteTrace(resp);
   end else if cmd='--print' then begin
      parm:='PRINT '+parm;
      splitarg(parm,blank,pp);
      for p:=pp.count to MaxCmdArg do pp.add('');
      resp:=ExecuteCmd('',pp);
      if (resp<>msgOK)and(resp<>'') then WriteTrace(resp);
   end;
end;
finally
  pp.free;
end;
// --quit parameter
for i:=0 to Params.Count-1 do begin
   parms:= Params[i];
   cmd:=words(parms,'',1,1);
   if cmd='--quit' then begin
       CloseTimer.Enabled:=true;
   end;
end;
end;

procedure Tf_main.ProcessParamsQuit;
var i: integer;
    cmd, parms : string;
begin
for i:=0 to Params.Count-1 do begin
   parms:= Params[i];
   cmd:=words(parms,'',1,1);
   if cmd='--quit' then begin
       Close;
   end;
end;
end;

procedure Tf_main.ConnectDB;
var dbpath:string;
begin
try
    NeedToInitializeDB:=false;
    if ((DBtype=sqlite) and not Fileexists(cfgm.db)) then begin
        dbpath:=extractfilepath(cfgm.db);
        if VerboseMsg then
         WriteTrace('Create sqlite '+dbpath);
        if not directoryexists(dbpath) then CreateDir(dbpath);
        if not directoryexists(dbpath) then forcedirectories(dbpath);
    end;
    cdcdb.ConnectDB(cfgm.dbhost,cfgm.db,cfgm.dbuser,cfgm.dbpass,cfgm.dbport);
    if cdcdb.CheckDB then begin
         if VerboseMsg then
          WriteTrace('DB connected');
          if not NeedToInitializeDB then cdcdb.CheckForUpgrade(f_info.ProgressMemo);
          planet.ConnectDB(cfgm.dbhost,cfgm.db,cfgm.dbuser,cfgm.dbpass,cfgm.dbport);
          Fits.ConnectDB(cfgm.dbhost,cfgm.db,cfgm.dbuser,cfgm.dbpass,cfgm.dbport);
          SetLpanel1(Format(rsConnectedToS, [cfgm.db]));
    end else begin
          ShowError(rsSQLDatabaseN+crlf+rsSQLDatabaseS);
          def_cfgsc.ShowAsteroid:=false;
          def_cfgsc.ShowComet:=false;
          def_cfgsc.ShowImages:=false;
    end;
    if NeedToInitializeDB then begin
       if VerboseMsg then
       WriteTrace('Initialize DB');
       f_info.setpage(2);
       f_info.show;
       f_info.ProgressMemo.lines.add(rsInitializeDa);
       cdcdb.LoadSampleData(f_info.ProgressMemo,cfgm);
       Planet.PrepareAsteroid(DateTimetoJD(now), f_info.ProgressMemo.lines);
       def_cfgsc.ShowAsteroid:=true;
       f_info.hide;
    end;
except
  SetLpanel1(rsSQLDatabaseN);
end;
end;

procedure Tf_main.InitializeDB(Sender: TObject);
begin
  NeedToInitializeDB:=true;
end;

procedure Tf_main.ViewInfoExecute(Sender: TObject);
begin
f_info.setpage(0);
f_info.serverinfo.Caption:=f_main.serverinfo;
f_info.show;
f_info.bringtofront;
end;

procedure Tf_main.showdetailinfo(chart:string;ra,dec:double;cat,nm,desc:string);
var i : integer;
begin
for i:=0 to MultiFrame1.ChildCount-1 do
 if MultiFrame1.Childs[i].DockedObject is Tf_chart then
   if MultiFrame1.Childs[i].caption=chart then with MultiFrame1.Childs[i].DockedObject as Tf_chart do begin
      sc.cfgsc.FindCatname:=trim(cat);
      sc.cfgsc.FindCat:=trim(cat);
      sc.cfgsc.FindRa:=ra;
      sc.cfgsc.FindDec:=dec;
      sc.cfgsc.FindDesc:=desc;
      sc.cfgsc.FindName:=nm;
      sc.cfgsc.FindNote:='';
      sc.cfgsc.FindPM:=false;
      sc.cfgsc.FindOK:=true;
      sc.cfgsc.FindSize:=0;
      sc.cfgsc.TrackName:='';
      sc.cfgsc.TrackType:=0;
      ShowIdentLabel;
      identlabelClick(nil);
      UpdateBtn(sc.cfgsc.flipx,sc.cfgsc.flipy,Connect1.checked,MultiFrame1.Childs[i].DockedObject);
      break;
end;
end;

procedure Tf_main.CenterFindObj(chart:string);
var i : integer;
begin
for i:=0 to MultiFrame1.ChildCount-1 do
 if MultiFrame1.Childs[i].DockedObject is Tf_chart then
   if MultiFrame1.Childs[i].caption=chart then with MultiFrame1.Childs[i].DockedObject as Tf_chart do begin
     sc.cfgsc.racentre:=sc.cfgsc.FindRa;
     sc.cfgsc.decentre:=sc.cfgsc.FindDec;
     sc.cfgsc.TrackOn:=false;
if VerboseMsg then
 WriteTrace('CenterFindObj');
     Refresh;
     break;
end;
end;

procedure Tf_main.NeighborObj(chart:string);
var i :integer;
    x,y:single;
    x1,y1: double;
begin
for i:=0 to MultiFrame1.ChildCount-1 do
 if MultiFrame1.Childs[i].DockedObject is Tf_chart then
   if MultiFrame1.Childs[i].caption=chart then with MultiFrame1.Childs[i].DockedObject as Tf_chart do begin
     projection(sc.cfgsc.FindRa,sc.cfgsc.FindDec,x1,y1,true,sc.cfgsc) ;
     WindowXY(x1,y1,x,y,sc.cfgsc);
     ListXY(round(x),round(y));
     break;
end;
end;

procedure Tf_main.GetActiveChart(var active_chart: string);
begin
  if MultiFrame1.ActiveObject is Tf_chart then
    active_chart:=MultiFrame1.ActiveChild.caption
  else
    active_chart:=newchart('');
end;

procedure Tf_main.TCPShowError(var msg: string);
begin
SetLpanel1(Format(rsSocketError, [msg,'']));
end;

procedure Tf_main.TCPShowSocket(var msg: string);
var
tcpport: string;
{$ifdef mswindows}
 Registry1: TRegistry;
{$else}
 f: textfile;
{$endif}
begin
tcpport:=msg;
if msg<>cfgm.ServerIPport then msg:=Format(rsDifferentTha, [msg]);
serverinfo:=Format(rsListenOnPort, [msg]);
SetLpanel1(serverinfo);
{$ifdef mswindows}
  Registry1 := TRegistry.Create;
  with Registry1 do begin
    Openkey('Software\Astro_PC\Ciel\Status',true);
    WriteString('TcpPort',tcpport);
    CloseKey;
  end;
  Registry1.Free;
{$else}
  AssignFile(f,slash(TempDir)+'tcpport');
  Rewrite(f);
  Write(f,tcpport);
  CloseFile(f);
{$endif}
end;

procedure Tf_main.ImageSetFocus(Sender: TObject);
begin
// to restore focus to the chart that as no text control
if VerboseMsg then
 WriteTrace('ImageSetFocus');
  ActiveControl:=nil;
  quicksearch.Enabled:=false;   // add all main form focusable control here
  EditTimeVal.Enabled:=false;
  TimeVal.Enabled:=false;
  TimeU.Enabled:=false;
  quicksearch.Enabled:=true;
  EditTimeVal.Enabled:=true;
  TimeVal.Enabled:=true;
  TimeU.Enabled:=true;
  if sender is Tf_chart then ActiveControl:=Tf_chart(sender).Image1;
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
       buf:=Format(rsNotConnected, [inttostr(i)]);
     end
     else begin
       buf:=Format(rsConnectedFro, [inttostr(i), TCPThrd[i].RemoteIP+blank+
         TCPThrd[i].RemotePort, TCPThrd[i].active_chart, datetimetostr(TCPThrd[i
         ].connecttime)]);
     end;
 end
   else buf:='';    
end;

function Tf_main.TCPClientConnected: boolean;
var i : integer;
begin
result:=false;
if (TCPDaemon<>nil) then
 with TCPDaemon do begin
   for i:=1 to MaxWindow do begin
     if (TCPDaemon.ThrdActive[i])
       and(TCPThrd[i]<>nil)
       and(TCPThrd[i].sock<>nil)
       and(not TCPThrd[i].terminated)
       then begin
         result:=true;
       end;
 end;
 end;
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
var savecfgm:Tconf_main;
begin
savecfgm:=Tconf_main.Create;
try
savecfgm.Assign(cfgm);
f_printsetup.cm:=cfgm;
formpos(f_printsetup,mouse.cursorpos.x,mouse.cursorpos.y);
if f_printsetup.showmodal=mrOK then begin
 cfgm:=f_printsetup.cm;
end else begin
 cfgm.Assign(savecfgm);
end;
PrintPreview1.Visible:=(cfgm.PrintMethod=0);
finally
savecfgm.Free;
end;
end;

procedure Tf_main.SetTheme;
var i : integer;
begin
 if nightvision then
    SetNightVision(true)
 else
    SetButtonImage(cfgm.ButtonStandard);

(* if fileexists(slash(appdir)+slash('data')+slash('Themes')+slash(cfgm.ThemeName)+'retic.cur') then begin
   if lclver<'0.9.29' then CursorImage1.FreeImage;
   CursorImage1.Free;
   CursorImage1:=TCursorImage.Create;
   CursorImage1.LoadFromFile(SysToUTF8(slash(appdir)+slash('data')+slash('Themes')+slash(cfgm.ThemeName)+'retic.cur'));
 //  inc(crRetic);
   Screen.Cursors[crRetic]:=CursorImage1.Handle;
   for i:=0 to MultiFrame1.ChildCount-1 do
        if MultiFrame1.Childs[i].DockedObject is Tf_chart then
           Tf_chart(MultiFrame1.Childs[i].DockedObject).ChartCursor:=crRetic;
 end;  *)

 if fileexists(slash(appdir)+slash('data')+slash('Themes')+slash(cfgm.ThemeName)+'compass.bmp') then begin
    compass.LoadFromFile(SysToUTF8(slash(appdir)+slash('data')+slash('Themes')+slash(cfgm.ThemeName)+'compass.bmp'));
    for i:=0 to MultiFrame1.ChildCount-1 do
        if MultiFrame1.Childs[i].DockedObject is Tf_chart then
           Tf_chart(MultiFrame1.Childs[i].DockedObject).sc.plot.compassrose:=compass;
 end;
 if fileexists(slash(appdir)+slash('data')+slash('Themes')+slash(cfgm.ThemeName)+'arrow.bmp') then begin
    arrow.LoadFromFile(SysToUTF8(slash(appdir)+slash('data')+slash('Themes')+slash(cfgm.ThemeName)+'arrow.bmp'));
    for i:=0 to MultiFrame1.ChildCount-1 do
        if MultiFrame1.Childs[i].DockedObject is Tf_chart then
           Tf_chart(MultiFrame1.Childs[i].DockedObject).sc.plot.compassarrow:=arrow;
 end;
 SetStarShape;
end;

procedure Tf_main.SetStarShape;
var i : integer;
    defaultfile: string;
begin
  if (cfgm.starshape_file<>'')and(FileExists(utf8tosys(cfgm.starshape_file))) then begin
     starshape.Picture.LoadFromFile(cfgm.starshape_file);
  end;
  if (cfgm.starshape_file='') then begin
     defaultfile:=slash(appdir)+slash('data')+slash('Themes')+slash(cfgm.ThemeName)+'starshape.bmp';
     if not FileExists(defaultfile) then
        defaultfile:=slash(appdir)+slash('data')+slash('Themes')+slash('default')+'starshape.bmp';
     starshape.Picture.LoadFromFile(systoutf8(defaultfile));
  end;
  for i:=0 to MultiFrame1.ChildCount-1 do
    if MultiFrame1.Childs[i].DockedObject is Tf_chart then
       Tf_chart(MultiFrame1.Childs[i].DockedObject).sc.plot.Starshape:=starshape.Picture.Bitmap;
end;

procedure Tf_main.SetButtonImage(button: Integer);
var btn : TPortableNetworkGraphic; //TBitmap;
    col: Tcolor;
    iconpath: String;
procedure SetButtonImage1(imagelist:Timagelist);
var i: Integer;
begin
   imagelist.Clear;
     for i:=0 to ImageListCount-1 do begin
       try
         btn:=TPortableNetworkGraphic.Create;
         btn.LoadFromFile(iconpath+'i'+inttostr(i)+'.png');
         imagelist.Add(btn,nil);
         btn.Free;
       except
       end;
     end;
   ActionList1.Images:=imagelist;
   Toolbar1.Images:=imagelist;
   Toolbar2.Images:=imagelist;
   Toolbar3.Images:=imagelist;
   Toolbar4.Images:=imagelist;
   MainMenu1.Images:=imagelist;
   btn:=TPortableNetworkGraphic.Create;
   btn.LoadFromFile(iconpath+'b1.png');
   BtnCloseChild.Glyph.Assign(btn);
   btn.LoadFromFile(iconpath+'b2.png');
   BtnRestoreChild.Glyph.Assign(btn);
   btn.canvas.pen.color:=clBlack;
   btn.canvas.brush.color:=clBlack;
   btn.canvas.brush.style:=bsSolid;
   ImageNormal.GetBitmap(52,btn); ButtonMoreStar.Picture.Assign(btn);
   btn.canvas.rectangle(0,0,btn.width,btn.height);
   ImageNormal.GetBitmap(53,btn); ButtonLessStar.Picture.Assign(btn);
   btn.canvas.rectangle(0,0,btn.width,btn.height);
   ImageNormal.GetBitmap(54,btn); ButtonMoreNeb.Picture.Assign(btn);
   btn.canvas.rectangle(0,0,btn.width,btn.height);
   ImageNormal.GetBitmap(55,btn); ButtonLessNeb.Picture.Assign(btn);
   btn.free;
end;
begin
try
case button of
 1:begin    // color
   iconpath:=systoutf8(slash(appdir)+slash('data')+slash('Themes')+slash(cfgm.ThemeName)+slash('icon_color'));
   col:=clNavy;
   SetButtonImage1(ImageNormal);
   end;
 2:begin  // red
   iconpath:=systoutf8(slash(appdir)+slash('data')+slash('Themes')+slash(cfgm.ThemeName)+slash('icon_red'));
   col:=$acb5f5;
   SetButtonImage1(ImageList2);
   end;
 3:begin   // blue
   iconpath:=systoutf8(slash(appdir)+slash('data')+slash('Themes')+slash(cfgm.ThemeName)+slash('icon_blue'));
   col:=clNavy;
   SetButtonImage1(ImageList2);
   end;
 4:begin   // Green
   iconpath:=systoutf8(slash(appdir)+slash('data')+slash('Themes')+slash(cfgm.ThemeName)+slash('icon_green'));
   col:=clLime;
   SetButtonImage1(ImageList2);
   end;
end;
ChildControl.Left:=ToolBar1.Width-ChildControl.Width;
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
except
end;
end;
{ code to save the image list to individual files
   for i:=0 to ImageNormal.Count-1 do begin
     ImageNormal.GetBitmap(i,btn);
     btn.SavetoFile('/home/cdc/src/skychart/bitmaps/icon_color/i'+inttostr(i)+'.bmp');
   end;
}


procedure Tf_main.MultiFrame1ActiveChildChange(Sender: TObject);
begin
if MultiFrame1.ActiveObject<>nil then begin
   if cfgm.ShowTitlePos then caption:=basecaption+' - '+MultiFrame1.ActiveChild.Caption+blank+blank+Tf_chart(MultiFrame1.ActiveObject).sc.GetChartPos
      else caption:=basecaption+' - '+MultiFrame1.ActiveChild.Caption;
   Tf_chart(MultiFrame1.ActiveObject).ChartActivate;
end
else
   caption:=basecaption;
end;

procedure Tf_main.MultiFrame1Maximize(Sender: TObject);

begin
ChildControl.visible:=MultiFrame1.Maximized;
if TabControl1.Visible<>(MultiFrame1.Maximized)and(MultiFrame1.ChildCount>1) then begin
  TabControl1.Visible:=(MultiFrame1.Maximized)and(MultiFrame1.ChildCount>1);
  ViewTopPanel;
end;
end;

procedure Tf_main.BtnRestoreChildClick(Sender: TObject);
begin
   MultiFrame1.Maximized:=not MultiFrame1.Maximized;
end;

procedure Tf_main.BtnCloseChildClick(Sender: TObject);
begin
if (MultiFrame1.ActiveObject is Tf_chart)and(MultiFrame1.ChildCount>1) then
   MultiFrame1.ActiveChild.close;
end;

procedure Tf_main.WindowCascade1Execute(Sender: TObject);
begin
MultiFrame1.Cascade;
end;

procedure Tf_main.WindowTileHorizontal1Execute(Sender: TObject);
begin
MultiFrame1.TileHorizontal;
end;

procedure Tf_main.WindowTileVertical1Execute(Sender: TObject);
begin
MultiFrame1.TileVertical;
end;

procedure Tf_main.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
if (Activecontrol=quicksearch) or
   (Activecontrol=EditTimeVal) or
   (Activecontrol=TimeVal) or
   (Activecontrol=TimeU) then exit
else
   (MultiFrame1.ActiveObject as Tf_chart).CKeyDown(Key,Shift);
end;

procedure Tf_main.FormKeyPress(Sender: TObject; var Key: Char);
begin
if cfgm.KioskMode then begin
  if ord(key)=key_cr then kioskpwd:=''
     else kioskpwd:=kioskpwd+key;
  if kioskpwd=cfgm.KioskPass then begin
    Close;
    Exit;
  end;
end;
if (Activecontrol=quicksearch) or
   (Activecontrol=EditTimeVal) or
   (Activecontrol=TimeVal) or
   (Activecontrol=TimeU) then exit
else
   (MultiFrame1.ActiveObject as Tf_chart).CKeyPress(Key);
end;

procedure Tf_main.SetChildFocus(Sender: TObject);
var i:integer;
begin
for i:=0 to MultiFrame1.ChildCount-1 do
   if MultiFrame1.Childs[i].DockedObject=Sender then begin
     if VerboseMsg then
      WriteTrace('SetChildFocus '+tf_chart(MultiFrame1.Childs[i].DockedObject).Caption);
      MultiFrame1.setActiveChild(i);
   end;
end;


procedure Tf_main.MaximizeExecute(Sender: TObject);
begin
MultiFrame1.Maximized:=true;
end;

procedure Tf_main.ToolButtonNightVisionClick(Sender: TObject);
var i: integer;
begin
nightvision:= not nightvision;
SetNightVision(nightvision);
ToolButtonNightVision.Down:=nightvision;
NightVision1.Checked:=nightvision;
for i:=0 to MultiFrame1.ChildCount-1 do
  if MultiFrame1.Childs[i].DockedObject is Tf_chart then
    (MultiFrame1.Childs[i].DockedObject as Tf_chart).NightVision:=nightvision;
end;

{$ifdef mswindows}
// Nightvision change Windows system color
Procedure Tf_main.SaveWinColor;
var n : integer;
begin
for n:=0 to 25 do
   savwincol[n]:=getsyscolor(win32_color_elem[n]);
end;

Procedure Tf_main.ResetWinColor;
var n : integer;
begin
//setsyscolors(sizeof(win32_color_elem),win32_color_elem,savwincol); // strange this not reset all the colors
for n:=0 to 25 do
   setsyscolors(1,win32_color_elem[n],savwincol[n]);
end;

procedure Tf_main.SetNightVision(night: boolean);
const rgb  : array[0..25] of Tcolor =  (nv_black        ,nv_dark      ,nv_dark           ,nv_dark,nv_dim            ,nv_middle    ,nv_middle        ,nv_dark        ,nv_dark           ,nv_light           ,nv_dark              ,nv_black          ,nv_dark                  ,nv_black    ,nv_middle     ,nv_dark   ,nv_middle     ,nv_black       ,nv_black    ,nv_middle       ,nv_black         ,nv_black     ,nv_middle      ,nv_black        ,nv_dark       ,nv_black);
begin
if night then begin
 if (Color<>nv_dark) then begin
   SaveWinColor;
   SetButtonImage(cfgm.ButtonNight);
   setsyscolors(sizeof(win32_color_elem),win32_color_elem,rgb);
   Color:=nv_dark;
   Font.Color:=nv_middle;
   quicksearch.Color:=nv_dark;
   quicksearch.Font.Color:=nv_middle;
   timeu.Color:=nv_dark;
   timeu.Font.Color:=nv_middle;
   edittimeval.Color:=nv_dark;
   edittimeval.Font.Color:=nv_middle;
   Shape1.Pen.Color:=nv_black;
   Shape1.Brush.Color:=nv_black;
   f_zoom.Color:=nv_dark;
   f_zoom.Font.Color:=nv_middle;
   f_calendar.Color:=nv_dark;
   f_calendar.Font.Color:=nv_middle;
   f_detail.Color:=nv_dark;
   f_detail.Font.Color:=nv_middle;
   f_getdss.Color:=nv_dark;
   f_getdss.Font.Color:=nv_middle;
   f_position.Color:=nv_dark;
   f_position.Font.Color:=nv_middle;
   f_search.Color:=nv_dark;
   f_search.Font.Color:=nv_middle;
   f_info.Color:=nv_dark;
   f_info.Font.Color:=nv_middle;
   f_printsetup.Color:=nv_dark;
   f_printsetup.Font.Color:=nv_middle;
   f_print.Color:=nv_dark;
   f_print.Font.Color:=nv_middle;
 end;
end else begin
   ResetWinColor;
   SetButtonImage(cfgm.ButtonStandard);
   Color:=clBtnFace;
   Font.Color:=clWindowText;
   quicksearch.Color:=clWindow;
   quicksearch.Font.Color:=clWindowText;
   timeu.Color:=clWindow;
   timeu.Font.Color:=clWindowText;
   edittimeval.Color:=clWindow;
   edittimeval.Font.Color:=clWindowText;
   Shape1.Pen.Color:=clBtnShadow;
   Shape1.Brush.Color:=clBtnShadow;
   f_zoom.Color:=clBtnFace;
   f_zoom.Font.Color:=clWindowText;
   f_calendar.Color:=clBtnFace;
   f_calendar.Font.Color:=clWindowText;
   f_detail.Color:=clBtnFace;
   f_detail.Font.Color:=clWindowText;
   f_getdss.Color:=clBtnFace;
   f_getdss.Font.Color:=clWindowText;
   f_position.Color:=clBtnFace;
   f_position.Font.Color:=clWindowText;
   f_search.Color:=clBtnFace;
   f_search.Font.Color:=clWindowText;
   f_info.Color:=clBtnFace;
   f_info.Font.Color:=clWindowText;
   f_printsetup.Color:=clBtnFace;
   f_printsetup.Font.Color:=clWindowText;
   f_print.Color:=clBtnFace;
   f_print.Font.Color:=clWindowText;
end;
end;

// View fullscreen without border
procedure Tf_main.ViewFullScreenExecute(Sender: TObject);
var lPrevStyle: LongInt;
begin
FullScreen1.Checked:=not FullScreen1.Checked;
if FullScreen1.Checked then begin
   cfgm.savetop:=top;
   cfgm.saveleft:=left;
   cfgm.savewidth:=width;
   cfgm.saveheight:=height;
   lPrevStyle := GetWindowLong(f_main.handle, GWL_STYLE);
   SetWindowLong(f_main.handle, GWL_STYLE, (lPrevStyle And (Not WS_THICKFRAME) And (Not WS_BORDER) And (Not WS_CAPTION) And (Not WS_MINIMIZEBOX) And (Not WS_MAXIMIZEBOX)));
   SetWindowPos(f_main.handle, 0, 0, 0, 0, 0, SWP_FRAMECHANGED Or SWP_NOMOVE Or SWP_NOSIZE Or SWP_NOZORDER);
   top:=0;
   left:=0;
   width:=screen.Width;
   height:=screen.Height;
end else begin
   lPrevStyle := GetWindowLong(f_main.handle, GWL_STYLE);
   SetWindowLong(f_main.handle, GWL_STYLE, (lPrevStyle Or WS_THICKFRAME Or WS_BORDER Or WS_CAPTION Or WS_MINIMIZEBOX Or WS_MAXIMIZEBOX));
   SetWindowPos(f_main.handle, 0, 0, 0, 0, 0, SWP_FRAMECHANGED Or SWP_NOMOVE Or SWP_NOSIZE Or SWP_NOZORDER);
   top:=cfgm.savetop;
   left:=cfgm.saveleft;
   width:=cfgm.savewidth;
   height:=cfgm.saveheight;
end;
end;
// end of windows specific code:
{$endif}

{$ifdef unix}
procedure Tf_main.SetNightVision(night: boolean);
var i: integer;
begin
if night then begin
   SetButtonImage(cfgm.ButtonNight);
   MultiFrame1.InactiveBorderColor:=nv_black;
   MultiFrame1.TitleColor:=nv_middle;
   MultiFrame1.BorderColor:=nv_dark;
 end else begin
   SetButtonImage(cfgm.ButtonStandard);
   MultiFrame1.InactiveBorderColor:=$404040;
   MultiFrame1.TitleColor:=clBlack;
   MultiFrame1.BorderColor:=$808080;
end;
for i:=0 to MultiFrame1.ChildCount-1 do
  if MultiFrame1.Childs[i]=MultiFrame1.ActiveChild then
     MultiFrame1.Childs[i].SetBorderColor(MultiFrame1.BorderColor)
  else
     MultiFrame1.Childs[i].SetBorderColor(MultiFrame1.InactiveBorderColor);
end;

procedure Tf_main.ViewFullScreenExecute(Sender: TObject);
begin
if cfgm.KioskMode then FullScreen1.Checked:=true
                  else FullScreen1.Checked:=not FullScreen1.Checked;
{$IF DEFINED(LCLgtk) or DEFINED(LCLgtk2)}
{ TODO : fullscreen showmodal do not work with Gnome }
 SetWindowFullScreen(f_main,FullScreen1.Checked);
 if FullScreen1.Checked then
    WindowState:=wsMaximized
 else
    WindowState:=wsNormal;
{$else}
 if FullScreen1.Checked then
    WindowState:=wsMaximized
 else
    WindowState:=wsNormal;
{$endif}
end;
{$endif}

procedure Tf_main.GetTwilight(jd0: double; out ht: double);
var astrom,nautm,civm,cive,naute,astroe: double;
begin
  planet.Twilight(jd0,def_cfgsc.ObsLatitude,def_cfgsc.ObsLongitude,astrom,nautm,civm,cive,naute,astroe);
  def_cfgsc.tz.JD:=jd0;
  ht:=rmod(astroe+def_cfgsc.tz.SecondsOffset/3600+24,24);
end;

// DDE server, windows only
//todo: any DDE for Lazarus? if not create a separate app that relay to tcp/ip
{procedure Tf_main.DdeDataPokeData(Sender: TObject);
var cmd : Tstringlist;
    cmdresult:string;
    i: integer;
begin
while DDEenqueue do application.processmessages;
try
DdeEnqueue:=true;
cmd:=TStringlist.create;
splitarg(DdeData.text,blank,cmd);
for i:=cmd.count to MaxCmdArg do cmd.add('');
cmdresult:=ExecuteCmd(Dde_active_chart,cmd);
if (cmdresult=msgOK)and(uppercase(cmd[0])='SELECTCHART') then Dde_active_chart:=cmd[1];
if (cmdresult=msgOK) then DdeInfo[0]:=formatdatetime('c',now)+' ACK'
                     else DdeInfo[0]:=formatdatetime('c',now)+' NAK';
DdeInfo[2]:=cmdresult;
DdeInfo[1]:='';
DdeInfo[3]:='';
DdeInfo[4]:='';
DdeData.Lines:=DdeInfo;
finally
DdeEnqueue:=false;
cmd.Free;
end;
end;

procedure Tf_main.DdeSkyChartOpen(Sender: TObject);
begin
Dde_active_chart:='Chart_1';
if MultiFrame1.ActiveObject is Tf_chart then with MultiFrame1.ActiveChild do Dde_active_chart:=caption;
DDeOpen:=true;
end;

procedure Tf_main.DdeSkyChartClose(Sender: TObject);
begin
DDeOpen:=false;
end; }

// one time use function to extract all text to translate from component object
//uses pu_addlabel, pu_catgen, pu_catgenadv, pu_config_chart, pu_config_internet, pu_config_solsys, pu_config_system,pu_image, pu_progressbar,
{procedure Tf_main.MenuItem12Click(Sender: TObject);
//var f: textfile;
begin
AssignFile(f,'translation.txt');
rewrite(f);
GetTranslationString(f_main,f);
GetTranslationString(f_position,f);
GetTranslationString(f_search,f);
GetTranslationString(f_zoom,f);
GetTranslationString(f_getdss,f);
GetTranslationString(f_manualtelescope,f);
GetTranslationString(f_detail,f);
GetTranslationString(f_info,f);
GetTranslationString(f_calendar,f);
GetTranslationString(f_printsetup,f);
GetTranslationString(f_print,f);
GetTranslationString(Tf_chart(MultiFrame1.ActiveObject),f);
GetTranslationString(Tf_about.Create(self),f);
GetTranslationString(Tf_addlabel.Create(self),f);
GetTranslationString(Tf_catgen.Create(self),f);
GetTranslationString(Tf_catgenadv.Create(self),f);
GetTranslationString(Tf_config.Create(self),f);
GetTranslationString(Tf_config_catalog.Create(self),f);
GetTranslationString(Tf_config_chart.Create(self),f);
GetTranslationString(Tf_config_display.Create(self),f);
GetTranslationString(Tf_config_internet.Create(self),f);
GetTranslationString(Tf_config_observatory.Create(self),f);
GetTranslationString(Tf_config_pictures.Create(self),f);
GetTranslationString(Tf_config_solsys.Create(self),f);
GetTranslationString(Tf_config_system.Create(self),f);
GetTranslationString(Tf_config_time.Create(self),f);
GetTranslationString(Tf_image.Create(self),f);
GetTranslationString(Tf_progress.Create(self),f);
closefile(f);
end;}

end.
