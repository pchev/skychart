unit pu_main;

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
 Main form for CDC/Skychart application
}

interface

uses
  {$ifdef win32}
    Windows,
  {$endif}
  u_help, u_translation, cu_catalog, cu_planet, cu_telescope, cu_fits, cu_database, pu_chart,
  pu_config_time, pu_config_observatory, pu_config_display, pu_config_pictures,
  pu_config_catalog, pu_config_solsys, pu_config_chart, pu_config_system, pu_config_internet,
  u_constant, u_util, blcksock, synsock, dynlibs,
  LCLIntf, SysUtils, Classes, Graphics, Forms, Controls, Menus, Math,
  StdCtrls, Dialogs, Buttons, ExtCtrls, ComCtrls, StdActns,
  ActnList, IniFiles, Spin, Clipbrd, MultiDoc, ChildDoc,
  LResources, uniqueinstance, LazHelpHTML;

type
  TTCPThrd = class(TThread)
  private
    FSock:TTCPBlockSocket;
    CSock: TSocket;
    cmd : TStringlist;
    cmdresult : string;
    FConnectTime : double;
  public
    id : integer;
    keepalive,abort,lockexecutecmd,stoping : boolean;
    active_chart,remoteip,remoteport : string;
    Constructor Create (hsock:tSocket);
    procedure Execute; override;
    procedure SendData(str:string);
    procedure ExecuteCmd;
    property sock : TTCPBlockSocket read FSock;
    property ConnectTime : double read FConnectTime;
    property Terminated;
  end;

  TTCPDaemon = class(TThread)
  private
    Sock:TTCPBlockSocket;
    active_chart : string;
    procedure ShowError;
  public
    keepalive, stoping : boolean;
    TCPThrd: array [1..Maxwindow] of TTCPThrd ;
    ThrdActive: array [1..Maxwindow] of boolean ;
    Constructor Create;
    procedure Execute; override;
    procedure ShowSocket;
    procedure GetACtiveChart;
  end;

  TCdCUniqueInstance = class(TUniqueInstance)
  public
    procedure Loaded; override;
  end;

type

  { Tf_main }

  Tf_main = class(TForm)
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
    MultiDoc1: TMultiDoc;
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
    EditCopy1: TEditCopy;
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
    LPanels01: TLabel;
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
    TimeVal: TSpinEdit;
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
    ShowLabels1: TMenuItem;
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
    procedure BlinkImageExecute(Sender: TObject);
    procedure BugReport1Click(Sender: TObject);
    procedure FileClose1Execute(Sender: TObject);
    procedure FileNew1Execute(Sender: TObject);
    procedure FileOpen1Execute(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure HelpAbout1Execute(Sender: TObject);
    procedure FileExit1Execute(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure HomePage1Click(Sender: TObject);
    procedure Maillist1Click(Sender: TObject);
    procedure Print1Execute(Sender: TObject);
    procedure Toolbar1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure ReleaseNotes1Click(Sender: TObject);
    procedure ResetAllLabels1Click(Sender: TObject);
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
    procedure ToolBar1Enter(Sender: TObject);
    procedure ToolButtonConfigClick(Sender: TObject);
    procedure ToolButtonRotMMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ToolButtonRotPMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure VariableStar1Click(Sender: TObject);
    procedure ViewBarExecute(Sender: TObject);
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
    procedure TrackExecute(Sender: TObject);
    procedure ZoomBarExecute(Sender: TObject);
    procedure DSSImageExecute(Sender: TObject);
    procedure EditLabelsExecute(Sender: TObject);
    procedure MultiDoc1ActiveChildChange(Sender: TObject);
    procedure MultiDoc1Maximize(Sender: TObject);
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
  private
    { Private declarations }
    UniqueInstance1: TCdCUniqueInstance;
    ConfigTime: Tf_config_time;
    ConfigObservatory: Tf_config_observatory;
    ConfigChart: Tf_config_chart;
    ConfigSolsys: Tf_config_solsys;
    ConfigSystem: Tf_config_system;
    ConfigInternet: Tf_config_internet;
    ConfigDisplay: Tf_config_display;
    ConfigPictures: Tf_config_pictures;
    ConfigCatalog: Tf_config_catalog;
    cryptedpwd,basecaption :string;
    NeedRestart,NeedToInitializeDB : Boolean;
    InitialChartNum: integer;
    AutoRefreshLock: Boolean;
    compass,arrow: TBitmap;
    CursorImage1: TCursorImage;
  {$ifdef win32}
    savwincol  : array[0..25] of Tcolor;
  {$endif}
    procedure OtherInstance(Sender : TObject; ParamCount: Integer; Parameters: array of String);
    procedure InstanceRunning(Sender : TObject);
    procedure ProcessParams1;
    procedure ProcessParams2;
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
    procedure SetupPicturesPage(page:integer);
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
  {$ifdef win32}
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
    telescope: Ttelescope;
    cdcdb: TCDCdb;
    serverinfo,topmsg : string;
    TCPDaemon: TTCPDaemon;
    DdeInfo : TstringList;
    Dde_active_chart : string;
    DdeOpen : boolean;
    DdeEnqueue: boolean;
    Config_Version : string;
    procedure ReadChartConfig(filename:string; usecatalog,resizemain:boolean; var cplot:Tconf_plot ;var csc:Tconf_skychart);
    procedure ReadPrivateConfig(filename:string);
    procedure ReadDefault;
    procedure UpdateConfig;
    procedure SavePrivateConfig(filename:string; purge: boolean=false);
    procedure SaveQuickSearch(filename:string);
    procedure SaveChartConfig(filename:string; child: TChildDoc);
    procedure SaveVersion;
    procedure SaveDefault;
    procedure SetDefault;
    procedure SetLang;
    procedure ChangeLanguage(newlang:string);
    Procedure InitFonts;
    Procedure activateconfig(cmain:Tconf_main; csc:Tconf_skychart; ccat:Tconf_catalog; cshr:Tconf_shared; cplot:Tconf_plot; cdss:Tconf_dss; applyall:boolean );
    Procedure SetLPanel1(txt:string; origin:string='';sendmsg:boolean=true; Sender: TObject=nil);
    Procedure SetLPanel0(txt:string);
    Procedure SetTopMessage(txt:string;sender:TObject);
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
    procedure showdetailinfo(chart:string;ra,dec:double;nm,desc:string);
    procedure CenterFindObj(chart:string);
    procedure NeighborObj(chart:string);
    procedure ConnectDB;
    procedure ImageSetFocus(Sender: TObject);
    procedure ListInfo(buf:string);
    procedure GetTCPInfo(i:integer; var buf:string);
    procedure KillTCPClient(i:integer);
    procedure PrintSetup(Sender: TObject);
    procedure GetChartConfig(csc:Tconf_skychart);
    procedure DrawChart(csc:Tconf_skychart);
    procedure ConfigDBChange(Sender: TObject);
    procedure SaveAndRestart(Sender: TObject);
    procedure InitializeDB(Sender: TObject);
    procedure Init;
    function PrepareAsteroid(jdt:double; msg:Tstrings):boolean;
    procedure ChartMove(Sender: TObject);
  end;

var
  f_main: Tf_main;

implementation

uses
{$IF DEFINED(LCLgtk) or DEFINED(LCLgtk2)}
     gtkproc,
{$endif}
     pu_detail, pu_about, pu_info, pu_getdss, u_projection, pu_config,
     pu_printsetup, pu_calendar, pu_position, pu_search, pu_zoom,
     pu_splash, pu_manualtelescope, pu_print;

{$ifdef win32}
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
  cp: TChildDoc;
  maxi: boolean;
  w,h,t,l: integer;
begin
  // allow for a reasonable number of chart 
  if (MultiDoc1.ChildCount>=MaxWindow) then begin
     SetLpanel1(rsTooManyOpenW);
     result:=false;
     exit;
  end;
  // copy active child config
  if copyactive and (MultiDoc1.Activeobject is Tf_chart) then begin
    cfg1.Assign((MultiDoc1.Activeobject as Tf_chart).sc.cfgsc);
    cfgp.Assign((MultiDoc1.Activeobject as Tf_chart).sc.plot.cfgplot);
    cfg1.scopemark:=false;
    maxi:=MultiDoc1.maximized;
    w:=MultiDoc1.ActiveChild.width;
    h:=MultiDoc1.ActiveChild.height;
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
  cp:=MultiDoc1.NewChild;
  Child := Tf_chart.Create(cp);
  cp.DockedPanel:=child.Panel1;
  if locked then Child.lock_refresh:=true;
  inc(cfgm.MaxChildID);
  Child.tag:=cfgm.MaxChildID;
  Child.VertScrollBar.Visible:=ViewScrollBar1.Checked;
  Child.HorScrollBar.Visible:=ViewScrollBar1.Checked;
  cp.Caption:=CName;
  Child.Caption:=CName;
  Child.sc.catalog:=catalog;
  Child.sc.Fits:=Fits;
  Child.sc.planet:=planet;
  Child.sc.cdb:=cdcdb;
  {$ifdef win32}
  Child.telescopeplugin:=telescope;
  {$endif}
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
  Child.OnUpdateBtn:=UpdateBtn;
  Child.OnChartMove:=ChartMove;
  Child.onShowInfo:=SetLpanel1;
  Child.onShowCoord:=SetLpanel0;
  Child.onListInfo:=ListInfo;
  if Child.sc.cfgsc.Projpole=Altaz then begin
     Child.sc.cfgsc.TrackOn:=true;
     Child.sc.cfgsc.TrackType:=4;
  end;
  if not maxi then begin
     cp.width:=w;
     cp.height:=h;
     if t>=0 then cp.top:=t;
     if l>=0 then cp.left:=l;
  end;
  multidoc1.maximized:=maxi;
  result:=true;
  Child.locked:=false;
  Child.Refresh;
  caption:=basecaption+' - '+MultiDoc1.ActiveChild.Caption ;
end;

procedure Tf_main.RefreshAllChild(applydef:boolean);
var i: integer;
begin
for i:=0 to MultiDoc1.ChildCount-1 do
  if MultiDoc1.Childs[i].DockedObject is Tf_chart then
     with MultiDoc1.Childs[i].DockedObject as Tf_chart do begin
      sc.Fits:=Fits;
      sc.planet:=planet;
      sc.cdb:=cdcdb;
      if applydef then begin
        sc.cfgsc.Assign(def_cfgsc);
        sc.cfgsc.FindOk:=false;
        sc.plot.cfgplot.Assign(def_cfgplot);
      end;
      AutoRefresh;
     end;
end;

procedure Tf_main.SyncChild;
var i,y,m,d: integer;
    ra,de,jda,t,tz: double;
    st: boolean;
begin
if MultiDoc1.ActiveObject is Tf_chart then begin
 ra:=(MultiDoc1.ActiveObject as Tf_chart).sc.cfgsc.racentre;
 de:=(MultiDoc1.ActiveObject as Tf_chart).sc.cfgsc.decentre;
 jda:=(MultiDoc1.ActiveObject as Tf_chart).sc.cfgsc.jdchart;
 y:=(MultiDoc1.ActiveObject as Tf_chart).sc.cfgsc.curyear;
 m:=(MultiDoc1.ActiveObject as Tf_chart).sc.cfgsc.curmonth;
 d:=(MultiDoc1.ActiveObject as Tf_chart).sc.cfgsc.curday;
 t:=(MultiDoc1.ActiveObject as Tf_chart).sc.cfgsc.curtime;
 tz:=(MultiDoc1.ActiveObject as Tf_chart).sc.cfgsc.Timezone;
 st:=(MultiDoc1.ActiveObject as Tf_chart).sc.cfgsc.UseSystemTime;
 for i:=0 to MultiDoc1.ChildCount-1 do
  if (MultiDoc1.Childs[i].DockedObject is Tf_chart) and (MultiDoc1.Childs[i].DockedObject<>MultiDoc1.ActiveObject) then
     with MultiDoc1.Childs[i].DockedObject as Tf_chart do begin
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
      Refresh;
     end;
end;
end;

procedure Tf_main.AutorefreshTimer(Sender: TObject);
var i: integer;
begin
if AutoRefreshLock then exit;
try
AutoRefreshLock:=true;
Autorefresh.enabled:=false;
for i:=0 to MultiDoc1.ChildCount-1 do
  if MultiDoc1.Childs[i].DockedObject is Tf_chart then
     with MultiDoc1.Childs[i].DockedObject as Tf_chart do begin
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
begin
setlength(xname,MultiDoc1.ChildCount);
for i:=0 to MultiDoc1.ChildCount-1 do xname[i]:=MultiDoc1.Childs[i].caption;
if forcenumeric then n:=1
                else n:=0;
repeat
  ok:=true;
  if n=0 then result:=cname
         else result:=cname+inttostr(n);
  for i:=0 to MultiDoc1.ChildCount-1 do
     if xname[i]=result then ok:=false;
  inc(n);
until ok;
end;

procedure Tf_main.FileNew1Execute(Sender: TObject);
begin
  CreateChild(GetUniqueName(rsChart_, true), true, def_cfgsc, def_cfgplot);
end;

procedure Tf_main.FileClose1Execute(Sender: TObject);
begin
  if (MultiDoc1.ActiveObject is Tf_chart)and(MultiDoc1.ChildCount>1) then
   MultiDoc1.ActiveChild.close;
end;

procedure Tf_main.FileSaveAs1Execute(Sender: TObject);
begin
Savedialog.DefaultExt:='cdc3';
if Savedialog.InitialDir='' then Savedialog.InitialDir:=privatedir;
savedialog.Filter:='Cartes du Ciel 3 File|*.cdc3|All Files|*.*';
savedialog.Title:=rsSaveTheCurre;
if MultiDoc1.ActiveObject is Tf_chart then
  if SaveDialog.Execute then SaveChartConfig(SaveDialog.Filename,MultiDoc1.ActiveChild);
end;

procedure Tf_main.FileOpen1Execute(Sender: TObject);
var nam: string;
    p: integer;
begin
if OpenDialog.InitialDir='' then OpenDialog.InitialDir:=privatedir;
OpenDialog.Filter:='Cartes du Ciel 3 File|*.cdc3|All Files|*.*';
OpenDialog.Title:=rsOpenAChart;
  if OpenDialog.Execute then begin
    cfgp.Assign(def_cfgplot);
    cfgs.Assign(def_cfgsc);
    ReadChartConfig(OpenDialog.FileName,true,false,cfgp,cfgs);
    nam:=stringreplace(extractfilename(OpenDialog.FileName),blank,'_',[rfReplaceAll]);
    p:=pos('.',nam);
    if p>0 then nam:=copy(nam,1,p-1);
    CreateChild(GetUniqueName(nam,false) ,false,cfgs,cfgp);
  end;
end;

procedure Tf_main.FormActivate(Sender: TObject);
begin
  ImageSetFocus(Sender);
end;

procedure Tf_main.FormShow(Sender: TObject);
var i:integer;
begin
try
{$ifdef trace_debug}
 WriteTrace('Enter Tf_main.FormShow');
{$endif}
 if nightvision or (cfgm.ThemeName<>'default')or(cfgm.ButtonStandard>1) then SetTheme;
 InitFonts;
 SetLpanel1('');
 TimeVal.Width:= round( 60 {$ifdef win32} * Screen.PixelsPerInch/96 {$endif} );
 for i:=0 to MultiDoc1.ChildCount-1 do
  if MultiDoc1.Childs[i].DockedObject is Tf_chart then
     with MultiDoc1.Childs[i].DockedObject as Tf_chart do begin
        RefreshTimer.Enabled:=false;
        RefreshTimer.Enabled:=true;
     end;
 ImageSetFocus(Sender);
except
  on E: Exception do begin
   WriteTrace('FormShow error: '+E.Message);
   MessageDlg('FormShow error: '+E.Message, mtError, [mbClose], 0);
  end;
end;
{$ifdef trace_debug}
 WriteTrace('Exit Tf_main.FormShow');
{$endif}
end;

procedure Tf_main.Init;
var i: integer;
    firstuse: boolean;
begin
firstuse:=false;
try
{$ifdef trace_debug}
 WriteTrace('Enter Tf_main.Init');
{$endif}
 // some initialisation that need to be done after all the forms are created.
 f_info.onGetTCPinfo:=GetTCPInfo;
 f_info.onKillTCP:=KillTCPClient;
 f_info.onPrintSetup:=PrintSetup;
 f_info.OnShowDetail:=showdetailinfo;
 f_detail.OnCenterObj:=CenterFindObj;
 f_detail.OnNeighborObj:=NeighborObj;
{$ifdef trace_debug}
 WriteTrace('SetDefault');
{$endif}
 SetDefault;
{$ifdef trace_debug}
 WriteTrace('ReadDefault');
{$endif}
 ReadDefault;
 // must read db configuration before to create this one!
{$ifdef trace_debug}
 WriteTrace('Create DB');
{$endif}
 cdcdb:=TCDCdb.Create(self);
 planet:=Tplanet.Create(self);
 Fits:=TFits.Create(self);
 cdcdb.onInitializeDB:=InitializeDB;
 planet.cdb:=cdcdb;
 f_search.cdb:=cdcdb;
{$ifdef trace_debug}
 WriteTrace('Telescope plugin');
{$endif}
 telescope.pluginpath:=slash(appdir)+slash('plugins')+slash('telescope');
 telescope.plugin:=def_cfgsc.ScopePlugin;
{$ifdef trace_debug}
 WriteTrace('Background Image');
{$endif}
 if def_cfgsc.BackgroundImage='' then begin
   def_cfgsc.BackgroundImage:=slash(privatedir)+slash('pictures');
   if not DirectoryExists(def_cfgsc.BackgroundImage) then forcedirectories(def_cfgsc.BackgroundImage);
 end;
{$ifdef trace_debug}
 WriteTrace('Constellation');
{$endif}
 if def_cfgsc.ConstLatinLabel then
    catalog.LoadConstellation(cfgm.Constellationpath,'Latin')
  else
    catalog.LoadConstellation(cfgm.Constellationpath,Lang);
 catalog.LoadConstL(cfgm.ConstLfile);
 catalog.LoadConstB(cfgm.ConstBfile);
 catalog.LoadHorizon(cfgm.horizonfile,def_cfgsc);
 catalog.LoadStarName(slash(appdir)+slash('data')+slash('common_names'),Lang);
 f_search.cfgshr:=catalog.cfgshr;
 f_search.cfgsc:=def_cfgsc;
 f_search.Init;
{$ifdef trace_debug}
 WriteTrace('Connect DB');
{$endif}
 ConnectDB;
{$ifdef trace_debug}
 WriteTrace('FITS');
{$endif}
 Fits.min_sigma:=cfgm.ImageLuminosity;
 Fits.max_sigma:=cfgm.ImageContrast;
{$ifdef trace_debug}
 WriteTrace('Cursor');
{$endif}
 if (not isWin98) and fileexists(slash(appdir)+slash('data')+slash('Themes')+slash('default')+'retic.cur') then begin
    CursorImage1.LoadFromFile(slash(appdir)+slash('data')+slash('Themes')+slash('default')+'retic.cur');
    Screen.Cursors[crRetic]:=CursorImage1.Handle;
 end
 else crRetic:=crCross;
{$ifdef trace_debug}
 WriteTrace('Compass');
{$endif}
 if fileexists(slash(appdir)+slash('data')+slash('Themes')+slash('default')+'compass.bmp') then
    compass.LoadFromFile(slash(appdir)+slash('data')+slash('Themes')+slash('default')+'compass.bmp');
 if fileexists(slash(appdir)+slash('data')+slash('Themes')+slash('default')+'arrow.bmp') then
    arrow.LoadFromFile(slash(appdir)+slash('data')+slash('Themes')+slash('default')+'arrow.bmp');
{$ifdef trace_debug}
 WriteTrace('Timezone');
{$endif}
 def_cfgsc.tz.TimeZoneFile:=ZoneDir+StringReplace(def_cfgsc.ObsTZ,'/',PathDelim,[rfReplaceAll]);
 if def_cfgsc.tz.TimeZoneFile='' then firstuse:=true;
 if firstuse then begin
{$ifdef trace_debug}
 WriteTrace('First setup');
{$endif}
    FirstSetup
 end else
    if config_version<cdcver then ShowReleaseNotes(false);
 application.ProcessMessages; // apply any resizing
{$ifdef trace_debug}
 WriteTrace('Create default chart');
{$endif}
 CreateChild(GetUniqueName(rsChart_, true), true, def_cfgsc, def_cfgplot, true);
 Autorefresh.Interval:=max(10,cfgm.autorefreshdelay)*1000;
 AutoRefreshLock:=false;
 Autorefresh.enabled:=true;
{$ifdef trace_debug}
 WriteTrace('Start server');
{$endif}
 if cfgm.AutostartServer then StartServer;
{$ifdef trace_debug}
 WriteTrace('Init calendar');
{$endif}
 f_calendar.planet:=planet;
 f_calendar.cdb:=cdcdb;
 f_calendar.OnGetChartConfig:=GetChartConfig;
 f_calendar.OnUpdateChart:=DrawChart;
 f_calendar.eclipsepath:=slash(appdir)+slash('data')+slash('eclipses');
 if InitialChartNum>1 then
{$ifdef trace_debug}
 WriteTrace('Load supplementary charts');
{$endif}
    for i:=1 to InitialChartNum-1 do begin
      cfgp.Assign(def_cfgplot);
      cfgs.Assign(def_cfgsc);
      ReadChartConfig(configfile+inttostr(i),true,false,cfgp,cfgs);
      CreateChild(GetUniqueName(rsChart_, true) , false, cfgs, cfgp);
    end;
 if nightvision then begin
{$ifdef trace_debug}
 WriteTrace('Night vision');
{$endif}
    nightvision:=false;
    ToolButtonNightVisionClick(self);
 end;
{$ifdef trace_debug}
 WriteTrace('Read params');
{$endif}
 ProcessParams2;
except
  on E: Exception do begin
   WriteTrace('Initialization error: '+E.Message);
   MessageDlg('Initialization error: '+E.Message, mtError, [mbClose], 0);
  end;
end;
{$ifdef trace_debug}
 WriteTrace('Exit Tf_main.Init');
{$endif}
end;

procedure Tf_main.ShowReleaseNotes(shownext:boolean);
var buf: string;
begin
 f_splash.Close;
 application.ProcessMessages;
 buf:=slash(HelpDir)+'releasenotes_'+lang+'.txt';
 if not fileexists(buf) then
    buf:=slash(HelpDir)+'releasenotes.txt';
 if fileexists(buf) then begin
    f_info.setpage(3);
    if shownext then f_info.Button1.caption:=rsNext
                else f_info.Button1.caption:=rsClose;
    f_info.InfoMemo.Lines.LoadFromFile(buf);
    f_info.InfoMemo.Text:=CondUTF8Decode(f_info.InfoMemo.Text);
    f_info.showmodal;
 end;
 SaveVersion;
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
 SaveDefault;
end;

procedure Tf_main.SaveImageExecute(Sender: TObject);
var ext,format:string;
begin
Savedialog.DefaultExt:='';
if Savedialog.InitialDir='' then Savedialog.InitialDir:=privatedir;
savedialog.Filter:='PNG|*.png|JPEG|*.jpg|BMP|*.bmp';
savedialog.Title:=rsSaveImage;
if MultiDoc1.ActiveObject  is Tf_chart then
 with MultiDoc1.ActiveObject as Tf_chart do
  if SaveDialog.Execute then begin
     ext:=uppercase(extractfileext(SaveDialog.Filename));
     if ext='' then
        case Savedialog.FilterIndex of
        0,1 : ext:='.PNG';
        2   : ext:='.JPG';
        3   : ext:='.BMP';
        end;
     if (ext='.JPG')or(ext='.JPEG') then format:='JPEG'
     else if (ext='.BMP') then format:='BMP'
     else format:='PNG';
     SaveChartImage(format,SaveDialog.Filename,95);
  end;
end;

procedure Tf_main.HelpAbout1Execute(Sender: TObject);
begin
if f_about=nil then f_about:=Tf_about.Create(application);
f_about.ShowModal;
end;

procedure Tf_main.HelpContents1Execute(Sender: TObject);
begin
ShowHelp;
end;

procedure Tf_main.HomePage1Click(Sender: TObject);
begin
   ExecuteFile(URL_WebHome);
end;

procedure Tf_main.Maillist1Click(Sender: TObject);
begin
   ExecuteFile(URL_Maillist);
end;

procedure Tf_main.BugReport1Click(Sender: TObject);
begin
   ExecuteFile(URL_BugTracker);
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
{$ifdef win32}
    PIDL : PItemIDList;
    Folder : array[0..MAX_PATH] of Char;
const CSIDL_PERSONAL = $0005;
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
{$endif}
privatedir:=DefaultPrivateDir;
{$ifdef unix}
appdir:=expandfilename(appdir);
privatedir:=expandfilename(PrivateDir);
{$endif}
{$ifdef win32}
SHGetSpecialFolderLocation(0, CSIDL_PERSONAL, PIDL);
SHGetPathFromIDList(PIDL, Folder);
privatedir:=slash(Folder)+privatedir;
configfile:=slash(privatedir)+configfile;
{$endif}

if ForceConfig<>'' then Configfile:=ForceConfig;

if fileexists(configfile) then begin
  inif:=TMeminifile.create(configfile);
  try
  buf:=inif.ReadString('main','AppDir',appdir);
  if Directoryexists(buf) then appdir:=buf;
  privatedir:=inif.ReadString('main','PrivateDir',privatedir);
  finally
   inif.Free;
  end;
end;
if not directoryexists(privatedir) then CreateDir(privatedir);
if not directoryexists(privatedir) then forcedirectories(privatedir);
if not directoryexists(privatedir) then begin
   MessageDlg(rsUnableToCrea+privatedir+crlf
             +rsPleaseTryToC,
             mtError, [mbAbort], 0);
   Halt;
end;
if not directoryexists(slash(privatedir)+'MPC') then CreateDir(slash(privatedir)+'MPC');
if not directoryexists(slash(privatedir)+'MPC') then forcedirectories(slash(privatedir)+'MPC');
if not directoryexists(slash(privatedir)+'database') then CreateDir(slash(privatedir)+'database');
if not directoryexists(slash(privatedir)+'database') then forcedirectories(slash(privatedir)+'database');
if not directoryexists(slash(privatedir)+'pictures') then CreateDir(slash(privatedir)+'pictures');
if not directoryexists(slash(privatedir)+'pictures') then forcedirectories(slash(privatedir)+'pictures');
Tempdir:=slash(privatedir)+DefaultTmpDir;
if not directoryexists(TempDir) then CreateDir(TempDir);
if not directoryexists(TempDir) then forcedirectories(TempDir);

// Be sur the data directory exists
if (not directoryexists(slash(appdir)+slash('data')+'constellation')) then begin
  // try under the current directory
  buf:=GetCurrentDir;
  if (directoryexists(slash(buf)+slash('data')+'constellation')) then
     appdir:=buf
  else begin
     // try under the program directory
     buf:=ExtractFilePath(ParamStr(0));
     if (directoryexists(slash(buf)+slash('data')+'constellation')) then
        appdir:=buf
     else begin
         // try share directory under current location
         buf:=ExpandFileName(slash(GetCurrentDir)+SharedDir);
         if (directoryexists(slash(buf)+slash('data')+'constellation')) then
            appdir:=buf
         else begin
            // try share directory at the same location as the program
            buf:=ExpandFileName(slash(ExtractFilePath(ParamStr(0)))+SharedDir);
            if (directoryexists(slash(buf)+slash('data')+'constellation')) then
               appdir:=buf
            else begin
               MessageDlg('Could not found the application data directory.'+crlf
                   +'Please edit the file .cartesduciel.ini'+crlf
                   +'and indicate at the line Appdir= where you install the data.',
                   mtError, [mbAbort], 0);
               Halt;
            end;
         end;
     end;
  end;
end;

{$ifdef win32}
tracefile:=slash(privatedir)+tracefile;
{$endif}
VarObs:=slash(appdir)+DefaultVarObs;     // varobs normally at same location as skychart
if not FileExists(VarObs) then VarObs:=DefaultVarObs; // if not try in $PATH
helpdir:=slash(appdir)+slash('doc');
SampleDir:=slash(appdir)+slash('data')+'sample';
// Be sure zoneinfo exists in standard location or in skychart directory
ZoneDir:=slash(appdir)+slash('data')+slash('zoneinfo');
buf:=slash('')+slash('usr')+slash('share')+slash('zoneinfo');
if (FileExists(slash(buf)+'zone.tab')) then
     ZoneDir:=slash(buf)
else begin
  buf:=slash('')+slash('usr')+slash('lib')+slash('zoneinfo');
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
end;

procedure Tf_main.FormCreate(Sender: TObject);
var step:string;
begin
try
{$ifndef darwin}
UniqueInstance1:=TCdCUniqueInstance.Create(self);
UniqueInstance1.Identifier:='skychart';
UniqueInstance1.OnOtherInstance:=OtherInstance;
UniqueInstance1.OnInstanceRunning:=InstanceRunning;
UniqueInstance1.Enabled:=true;
UniqueInstance1.Loaded;
{$endif}
step:='Init';
SysDecimalSeparator:=DecimalSeparator;
DecimalSeparator:='.';
DateSeparator:='/';
TimeSeparator:=':';
NeedRestart:=false;
ImageListCount:=ImageNormal.Count;
DisplayIs32bpp:=true;
isWin98:=false;
{$ifdef win32}
  step:='Windows spefic';
  isWin98:=FindWin98;
  DisplayIs32bpp:=(ScreenBPP=32);
  configfile:=Defaultconfigfile;
{$endif}
{$ifdef unix}
  step:='Unix specific';
  configfile:=expandfilename(Defaultconfigfile);
{$endif}
{$ifdef darwin}
  step:='Darwin specific';
  MenuItem24.Visible:=false;  // config all not working
  MenuItem25.Visible:=false;
  MenuItem26.Visible:=false;
  MenuItem6.Visible:=false;
{$endif}
step:='Create config';
def_cfgsc:=Tconf_skychart.Create;
cfgs:=Tconf_skychart.Create;
cfgm:=Tconf_main.Create;
def_cfgplot:=Tconf_plot.Create;
cfgp:=Tconf_plot.Create;
ForceConfig:='';
step:='Create cursor';
CursorImage1:=TCursorImage.Create;
step:='Read initial parameters';
ProcessParams1;
step:='Application directory';
GetAppDir;
chdir(appdir);
step:='Trace';
InitTrace;
step:='Language';
{$ifdef trace_debug}
 WriteTrace(step);
{$endif}
GetLanguage;
lang:=u_translation.translate(cfgm.language);
u_help.Translate(lang);
catalog:=Tcatalog.Create(self);
SetLang;
step:='Telescope';
{$ifdef trace_debug}
 WriteTrace(step);
{$endif}
telescope:=Ttelescope.Create(self);
step:='Multidoc';
{$ifdef trace_debug}
 WriteTrace(step);
{$endif}
basecaption:=caption;
MultiDoc1.WindowList:=Window1;
MultiDoc1.KeepLastChild:=true;
ChildControl.visible:=false;
BtnCloseChild.Glyph.LoadFromLazarusResource('CLOSE');
BtnRestoreChild.Glyph.LoadFromLazarusResource('RESTORE');
step:='Size control';
{$ifdef trace_debug}
 WriteTrace(step);
{$endif}
starshape.Picture.Bitmap.Transparent:=false;
TimeVal.Width:= round( 60 {$ifdef win32} * Screen.PixelsPerInch/96 {$endif} );
quicksearch.Width:=round( 75 {$ifdef win32} * Screen.PixelsPerInch/96 {$endif} );
TimeU.Width:=round( 95 {$ifdef win32} * Screen.PixelsPerInch/96 {$endif} );
step:='Load zlib';
{$ifdef trace_debug}
 WriteTrace(step);
{$endif}
zlib:=LoadLibrary(libz);
if zlib<>0 then begin
  gzopen:= Tgzopen(GetProcAddress(zlib,'gzopen'));
  gzread:= Tgzread(GetProcAddress(zlib,'gzread'));
  gzclose:= Tgzclose(GetProcAddress(zlib,'gzclose'));
  gzeof:= Tgzeof(GetProcAddress(zlib,'gzeof'));
  zlibok:=true;
end else zlibok:=false;
step:='Load plan404';
{$ifdef trace_debug}
 WriteTrace(step);
{$endif}
Plan404:=nil;
Plan404lib:=LoadLibrary(lib404);
if Plan404lib<>0 then begin
  Plan404:= TPlan404(GetProcAddress(Plan404lib,'Plan404'));
end;
if @Plan404=nil then begin
   MessageDlg(rsCouldNotLoad+lib404+crlf
             +rsPleaseTryToR,
             mtError, [mbAbort], 0);
   Halt;
end;
{$ifdef unix}
   step:='Multidoc unix';
{$ifdef trace_debug}
 WriteTrace(step);
{$endif}
   MultiDoc1.InactiveBorderColor:=$404040;
   MultiDoc1.TitleColor:=clWhite;
   MultiDoc1.BorderColor:=$808080;
{$endif}
step:='Bitmap';
{$ifdef trace_debug}
 WriteTrace(step);
{$endif}
compass:=TBitmap.create;
arrow:=TBitmap.create;
step:='Load timezone';
{$ifdef trace_debug}
 WriteTrace(step);
{$endif}
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
{$ifdef trace_debug}
 WriteTrace('Exit Tf_main.FormCreate');
{$endif}
end;

procedure Tf_main.FormDestroy(Sender: TObject);
begin
try
catalog.free;
Fits.Free;
planet.free;
cdcdb.free;
telescope.free;
if NeedRestart then ExecNoWait(paramstr(0));
def_cfgsc.Free;
cfgs.Free;
cfgm.Free;
def_cfgplot.Free;
cfgp.Free;
compass.free;
arrow.free;
if CursorImage1<>nil then CursorImage1.FreeImage;
except
writetrace('error destroy '+name);
end;
end;

procedure Tf_main.FormClose(Sender: TObject; var Action: TCloseAction);
var i:integer;
begin
try
{$ifdef win32}
if nightvision then ResetWinColor;
{$endif}
StopServer;
writetrace(rsExiting);
Autorefresh.Enabled:=false;
if SaveConfigOnExit.checked and
   (MessageDlg(rsDoYouWantToS, mtConfirmation, [mbYes, mbNo], 0)=mrYes) then begin
      SaveDefault;
end else
   SaveQuickSearch(configfile);
for i:=0 to MultiDoc1.ChildCount-1 do
   if MultiDoc1.Childs[i].DockedObject is Tf_chart then with (MultiDoc1.Childs[i].DockedObject as Tf_chart) do begin
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

procedure Tf_main.EditCopy1Execute(Sender: TObject);
var savelabel:boolean;
begin
if MultiDoc1.ActiveObject is Tf_chart then
 with Tf_chart(MultiDoc1.ActiveObject) do begin
    savelabel:= sc.cfgsc.Editlabels;
    try
      if savelabel then begin
         sc.cfgsc.Editlabels:=false;
         sc.Refresh;
      end;
      Clipboard.Assign(sc.plot.cbmp);
    finally
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
if f_print.showmodal=mrOK then begin
 cfgm:=f_print.cm;
 if MultiDoc1.ActiveObject is Tf_chart then
   with MultiDoc1.ActiveObject as Tf_chart do
      PrintChart(cfgm.printlandscape,cfgm.printcolor,cfgm.PrintMethod,cfgm.PrinterResolution,cfgm.PrintCmd1,cfgm.PrintCmd2,cfgm.PrintTmpPath,cfgm);
end;
end;


procedure Tf_main.UndoExecute(Sender: TObject);
begin
if MultiDoc1.ActiveObject is Tf_chart then with MultiDoc1.ActiveObject as Tf_chart do UndoExecute(Sender);
end;

procedure Tf_main.RedoExecute(Sender: TObject);
begin
if MultiDoc1.ActiveObject is Tf_chart then with MultiDoc1.ActiveObject as Tf_chart do RedoExecute(Sender);
end;

procedure Tf_main.zoomplusExecute(Sender: TObject);
begin
if MultiDoc1.ActiveObject is Tf_chart then with MultiDoc1.ActiveObject as Tf_chart do zoomplusExecute(Sender);
end;

procedure Tf_main.zoomminusExecute(Sender: TObject);
begin
if MultiDoc1.ActiveObject is Tf_chart then with MultiDoc1.ActiveObject as Tf_chart do zoomminusExecute(Sender);
end;


procedure Tf_main.ZoomBarExecute(Sender: TObject);
begin
if MultiDoc1.ActiveObject is Tf_chart then with MultiDoc1.ActiveObject as Tf_chart do begin
 formpos(f_zoom,mouse.cursorpos.x,mouse.cursorpos.y);
 f_zoom.fov:=rad2deg*sc.cfgsc.fov;
 f_zoom.showmodal;
 if f_zoom.modalresult=mrOK then begin
    sc.setfov(deg2rad*f_zoom.fov);
    Refresh;
 end;

end;
end;

procedure Tf_main.FlipxExecute(Sender: TObject);
begin
if MultiDoc1.ActiveObject is Tf_chart then with MultiDoc1.ActiveObject as Tf_chart do FlipxExecute(Sender);
end;

procedure Tf_main.FlipyExecute(Sender: TObject);
begin
if MultiDoc1.ActiveObject is Tf_chart then with MultiDoc1.ActiveObject as Tf_chart do FlipyExecute(Sender);
end;

procedure Tf_main.rot_plusExecute(Sender: TObject);
begin
if MultiDoc1.ActiveObject is Tf_chart then with MultiDoc1.ActiveObject as Tf_chart do rot_plusExecute(Sender);
end;


procedure Tf_main.ToolButtonRotPMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var rot:double;
begin
if ssCtrl in Shift then rot:=45
else if ssShift in Shift then rot:=1
else rot:=15;
if MultiDoc1.ActiveObject is Tf_chart then with MultiDoc1.ActiveObject as Tf_chart do rotation(rot);
end;

procedure Tf_main.VariableStar1Click(Sender: TObject);
begin
  ExecNoWait(varobs);
end;

procedure Tf_main.rot_minusExecute(Sender: TObject);
begin
if MultiDoc1.ActiveObject is Tf_chart then with MultiDoc1.ActiveObject as Tf_chart do rot_minusExecute(Sender);
end;


procedure Tf_main.ToolButtonRotMMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var rot:double;
begin
if ssCtrl in Shift then rot:=-45
else if ssShift in Shift then rot:=-1
else rot:=-15;
if MultiDoc1.ActiveObject is Tf_chart then with MultiDoc1.ActiveObject as Tf_chart do  rotation(rot);
end;

procedure Tf_main.TelescopeConnectExecute(Sender: TObject);
var P : Tpoint;
begin
P:=point(0,0);
if MultiDoc1.ActiveObject is Tf_chart then with MultiDoc1.ActiveObject as Tf_chart do begin
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
if MultiDoc1.ActiveObject is Tf_chart then with MultiDoc1.ActiveObject as Tf_chart do Slew1Click(Sender);
end;

procedure Tf_main.TelescopeSyncExecute(Sender: TObject);
begin
if MultiDoc1.ActiveObject is Tf_chart then with MultiDoc1.ActiveObject as Tf_chart do Sync1Click(Sender);
end;

procedure Tf_main.TelescopePanelExecute(Sender: TObject);
begin
execnowait(cfgm.IndiPanelCmd);
end;

procedure Tf_main.ListObjExecute(Sender: TObject);
var buf:widestring;
begin
if MultiDoc1.ActiveObject is Tf_chart then with MultiDoc1.ActiveObject as Tf_chart do begin
  if sc.cfgsc.windowratio=0 then sc.cfgsc.windowratio:=1;
  sc.Findlist(sc.cfgsc.racentre,sc.cfgsc.decentre,sc.cfgsc.fov/2,sc.cfgsc.fov/2/sc.cfgsc.windowratio,buf,false,false,false);
  f_info.Memo1.Font.Name:=def_cfgplot.FontName[5];
  f_info.Memo1.Font.Size:=def_cfgplot.FontSize[5];
  f_info.Memo1.text:=blank+wordspace(buf);
  f_info.Memo1.selstart:=0;
  f_info.Memo1.selend:=0;
  f_info.setpage(1);
  f_info.source_chart:=MultiDoc1.ActiveChild.Caption;
  f_info.show;
  f_info.BringToFront;
end;
end;

procedure Tf_main.GridEQExecute(Sender: TObject);
begin
if MultiDoc1.ActiveObject is Tf_chart then with MultiDoc1.ActiveObject as Tf_chart do GridEQExecute(Sender);
end;

procedure Tf_main.GridExecute(Sender: TObject);
begin
if MultiDoc1.ActiveObject is Tf_chart then with MultiDoc1.ActiveObject as Tf_chart do GridExecute(Sender);
end;

procedure Tf_main.switchstarsExecute(Sender: TObject);
begin
if MultiDoc1.ActiveObject is Tf_chart then with MultiDoc1.ActiveObject as Tf_chart do switchstarExecute(Sender);
end;

procedure Tf_main.switchbackgroundExecute(Sender: TObject);
begin
if MultiDoc1.ActiveObject is Tf_chart then with MultiDoc1.ActiveObject as Tf_chart do switchbackgroundExecute(Sender);
end;

procedure Tf_main.SetFOVClick(Sender: TObject);
var f : integer;
begin
with Sender as TSpeedButton do f:=tag;
if MultiDoc1.ActiveObject is Tf_chart then with MultiDoc1.ActiveObject as Tf_chart do begin
   SetField(deg2rad*sc.catalog.cfgshr.FieldNum[f]);
end;
end;

procedure Tf_main.SetFovExecute(Sender: TObject);
var f : integer;
begin
with Sender as TMenuItem do f:=tag;
if MultiDoc1.ActiveObject is Tf_chart then with MultiDoc1.ActiveObject as Tf_chart do begin
   SetField(deg2rad*sc.catalog.cfgshr.FieldNum[f]);
end;
end;

procedure Tf_main.toNExecute(Sender: TObject);
begin
if MultiDoc1.ActiveObject is Tf_chart then with MultiDoc1.ActiveObject as Tf_chart do SetAz(deg2rad*180);
end;

procedure Tf_main.toEExecute(Sender: TObject);
begin
if MultiDoc1.ActiveObject is Tf_chart then with MultiDoc1.ActiveObject as Tf_chart do SetAz(deg2rad*270);
end;

procedure Tf_main.toSExecute(Sender: TObject);
begin
if MultiDoc1.ActiveObject is Tf_chart then with MultiDoc1.ActiveObject as Tf_chart do SetAz(0);
end;

procedure Tf_main.toWExecute(Sender: TObject);
begin
if MultiDoc1.ActiveObject is Tf_chart then with MultiDoc1.ActiveObject as Tf_chart do SetAz(deg2rad*90);
end;

procedure Tf_main.toZenithExecute(Sender: TObject);
begin
if MultiDoc1.ActiveObject is Tf_chart then with MultiDoc1.ActiveObject as Tf_chart do SetZenit(0);
end;

procedure Tf_main.allSkyExecute(Sender: TObject);
begin
if MultiDoc1.ActiveObject is Tf_chart then with MultiDoc1.ActiveObject as Tf_chart do SetZenit(deg2rad*200);
end;


procedure Tf_main.MoreStarExecute(Sender: TObject);
begin
if MultiDoc1.ActiveObject is Tf_chart then with MultiDoc1.ActiveObject as Tf_chart do cmd_MoreStar;
end;

procedure Tf_main.LessStarExecute(Sender: TObject);
begin
if MultiDoc1.ActiveObject is Tf_chart then with MultiDoc1.ActiveObject as Tf_chart do cmd_LessStar;
end;

procedure Tf_main.MoreNebExecute(Sender: TObject);
begin
if MultiDoc1.ActiveObject is Tf_chart then with MultiDoc1.ActiveObject as Tf_chart do cmd_MoreNeb;
end;

procedure Tf_main.LessNebExecute(Sender: TObject);
begin
if MultiDoc1.ActiveObject is Tf_chart then with MultiDoc1.ActiveObject as Tf_chart do cmd_LessNeb;
end;

procedure Tf_main.TimeIncExecute(Sender: TObject);
var hh : double;
    y,m,d,h,n,s,mult : integer;
begin
// tag is used for the sign
mult:=TAction(sender).tag*TimeVal.value;
if MultiDoc1.ActiveObject is Tf_chart then with MultiDoc1.ActiveObject as Tf_chart do begin
   djd(sc.cfgsc.CurJD,y,m,d,hh);
   DtoS(hh,h,n,s);
   case TimeU.itemindex of
   0 : begin
       SetJD(sc.cfgsc.CurJD+mult/24);
       end;
   1 : begin
       SetJD(sc.cfgsc.CurJD+mult/1440);
       end;
   2 : begin
       SetJD(sc.cfgsc.CurJD+mult/86400);
       end;
   3 : begin
       SetJD(sc.cfgsc.CurJD+mult);
       end;
   4 : begin
       inc(m,mult);
       SetDateUT(y,m,d,h,n,s);
       end;
   5 : begin
       inc(y,mult);
       SetDateUT(y,m,d,h,n,s);
       end;
   6 : SetJD(sc.cfgsc.CurJD+mult*365.25);      // julian year
   7 : SetJD(sc.cfgsc.CurJD+mult*365.2421988); // tropical year
   8 : SetJD(sc.cfgsc.CurJD+mult*0.99726956633); // sideral day
   9 : SetJD(sc.cfgsc.CurJD+mult*29.530589);   // synodic month
   10: SetJD(sc.cfgsc.CurJD+mult*6585.321);    // saros
   end;
end;
end;

procedure Tf_main.TimeResetExecute(Sender: TObject);
begin
if MultiDoc1.ActiveObject is Tf_chart then with MultiDoc1.ActiveObject as Tf_chart do begin
   sc.cfgsc.UseSystemTime:=true;
   if (not sc.cfgsc.TrackOn)and(sc.cfgsc.Projpole=Altaz) then begin
      sc.cfgsc.TrackOn:=true;
      sc.cfgsc.TrackType:=4;
   end;
   Refresh;
end;
end;


procedure Tf_main.ShowStarsExecute(Sender: TObject);
begin
if MultiDoc1.ActiveObject is Tf_chart then with MultiDoc1.ActiveObject as Tf_chart do begin
   sc.cfgsc.showstars:=not sc.cfgsc.showstars;
   Refresh;
end;
end;

procedure Tf_main.ShowNebulaeExecute(Sender: TObject);
begin
if MultiDoc1.ActiveObject is Tf_chart then with MultiDoc1.ActiveObject as Tf_chart do begin
   sc.cfgsc.shownebulae:=not sc.cfgsc.shownebulae;
   Refresh;
end;
end;

procedure Tf_main.ShowPicturesExecute(Sender: TObject);
begin
if MultiDoc1.ActiveObject is Tf_chart then with MultiDoc1.ActiveObject as Tf_chart do begin
   sc.cfgsc.ShowImages:=not sc.cfgsc.ShowImages;
   if sc.cfgsc.ShowImages and (not Fits.dbconnected) then begin
      sc.cfgsc.ShowImages:=false;
      ShowError(rsErrorPleaseC3);
   end;
   Refresh;
end;
end;

procedure Tf_main.ShowBackgroundImageExecute(Sender: TObject);
begin
if MultiDoc1.ActiveObject is Tf_chart then with MultiDoc1.ActiveObject as Tf_chart do begin
   sc.cfgsc.ShowBackgroundImage:=not sc.cfgsc.ShowBackgroundImage;
   if sc.cfgsc.ShowBackgroundImage and (not Fits.dbconnected) then begin
      sc.cfgsc.ShowBackgroundImage:=false;
      ShowError(rsErrorPleaseC);
   end;
   Refresh;
end;
end;


procedure Tf_main.DSSImageExecute(Sender: TObject);
var ra2000,de2000: double;
begin
if (MultiDoc1.ActiveObject is Tf_chart) and (Fits.dbconnected)
  then with MultiDoc1.ActiveObject as Tf_chart do begin
   f_getdss.cmain:=cfgm;
   ra2000:=sc.cfgsc.racentre;
   de2000:=sc.cfgsc.decentre;
   if sc.cfgsc.ApparentPos then mean_equatorial(ra2000,de2000,sc.cfgsc);
   precession(sc.cfgsc.JDchart,jd2000,ra2000,de2000);
   if f_getdss.GetDss(ra2000,de2000,sc.cfgsc.fov,sc.cfgsc.windowratio,image1.width) then begin
      sc.Fits.Filename:=expandfilename(f_getdss.cfgdss.dssfile);
      if sc.Fits.Header.valid then begin
         sc.Fits.DeleteDB('OTHER','BKG');
         if not sc.Fits.InsertDB(sc.Fits.Filename,'OTHER','BKG',sc.Fits.Center_RA,sc.Fits.Center_DE,sc.Fits.Img_Width,sc.Fits.Img_Height,sc.Fits.Rotation) then
                sc.Fits.InsertDB(sc.Fits.Filename,'OTHER','BKG',sc.Fits.Center_RA+0.00001,sc.Fits.Center_DE+0.00001,sc.Fits.Img_Width,sc.Fits.Img_Height,sc.Fits.Rotation);
         sc.cfgsc.TrackOn:=true;
         sc.cfgsc.TrackType:=5;
         sc.cfgsc.BackgroundImage:=sc.Fits.Filename;
         sc.cfgsc.ShowBackgroundImage:=true;
         Refresh;
      end;
   end;
end;
end;

procedure Tf_main.BlinkImageExecute(Sender: TObject);
begin
if (MultiDoc1.ActiveObject is Tf_chart)
  then with MultiDoc1.ActiveObject as Tf_chart do begin
     if BlinkTimer.enabled then begin
        BlinkTimer.enabled:=false;
        sc.cfgsc.ShowBackgroundImage:=true;
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
if MultiDoc1.ActiveObject is Tf_chart then begin
   cfgm.SyncChart:=not cfgm.SyncChart;
   if cfgm.SyncChart then SyncChild;
end;
end;

procedure Tf_main.ShowLinesExecute(Sender: TObject);
begin
if MultiDoc1.ActiveObject is Tf_chart then with MultiDoc1.ActiveObject as Tf_chart do begin
   sc.cfgsc.ShowLine:=not sc.cfgsc.ShowLine;
   Refresh;
end;
end;

procedure Tf_main.ShowPlanetsExecute(Sender: TObject);
begin
if MultiDoc1.ActiveObject is Tf_chart then with MultiDoc1.ActiveObject as Tf_chart do begin
   sc.cfgsc.ShowPlanet:=not sc.cfgsc.ShowPlanet;
   Refresh;
end;
end;

procedure Tf_main.ShowAsteroidsExecute(Sender: TObject);
var showast:boolean;
begin
if MultiDoc1.ActiveObject is Tf_chart then with MultiDoc1.ActiveObject as Tf_chart do begin
   sc.cfgsc.ShowAsteroid:=not sc.cfgsc.ShowAsteroid;
   showast:=sc.cfgsc.ShowAsteroid;
   Refresh;
   if showast<>sc.cfgsc.ShowAsteroid then begin
      f_info.setpage(2);
      f_info.show;
      f_info.ProgressMemo.lines.add(rsComputeAster);
      if Planet.PrepareAsteroid(sc.cfgsc.curjd, f_info.ProgressMemo.lines) then begin
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
if MultiDoc1.ActiveObject is Tf_chart then with MultiDoc1.ActiveObject as Tf_chart do begin
   sc.cfgsc.ShowComet:=not sc.cfgsc.ShowComet;
   showcom:=sc.cfgsc.ShowComet;
   Refresh;
   if showcom<>sc.cfgsc.ShowComet then ShowError(rsErrorPleaseC2);
end;
end;

procedure Tf_main.ShowMilkyWayExecute(Sender: TObject);
begin
if MultiDoc1.ActiveObject is Tf_chart then with MultiDoc1.ActiveObject as Tf_chart do begin
   sc.cfgsc.ShowMilkyWay:=not sc.cfgsc.ShowMilkyWay;
   Refresh;
end;
end;

procedure Tf_main.ShowLabelsExecute(Sender: TObject);
begin
if MultiDoc1.ActiveObject is Tf_chart then with MultiDoc1.ActiveObject as Tf_chart do begin
   sc.cfgsc.Showlabelall:=not sc.cfgsc.Showlabelall;
   Refresh;
end;
end;

procedure Tf_main.ResetAllLabels1Click(Sender: TObject);
begin
if MultiDoc1.ActiveObject is Tf_chart then
      Tf_chart(MultiDoc1.ActiveObject).sc.ResetAllLabel;
end;

procedure Tf_main.EditLabelsExecute(Sender: TObject);
begin
if MultiDoc1.ActiveObject is Tf_chart then with MultiDoc1.ActiveObject as Tf_chart do begin
   sc.cfgsc.Editlabels:=not sc.cfgsc.Editlabels;
   Refresh;
end;
end;

procedure Tf_main.ShowConstellationLineExecute(Sender: TObject);
begin
if MultiDoc1.ActiveObject is Tf_chart then with MultiDoc1.ActiveObject as Tf_chart do begin
   sc.cfgsc.ShowConstl:=not sc.cfgsc.ShowConstl;
   Refresh;
end;
end;

procedure Tf_main.ShowConstellationLimitExecute(Sender: TObject);
begin
if MultiDoc1.ActiveObject is Tf_chart then with MultiDoc1.ActiveObject as Tf_chart do begin
   sc.cfgsc.ShowConstB:=not sc.cfgsc.ShowConstB;
   Refresh;
end;
end;

procedure Tf_main.ShowGalacticEquatorExecute(Sender: TObject);
begin
if MultiDoc1.ActiveObject is Tf_chart then with MultiDoc1.ActiveObject as Tf_chart do begin
   sc.cfgsc.ShowGalactic:=not sc.cfgsc.ShowGalactic;
   Refresh;
end;
end;

procedure Tf_main.ShowEclipticExecute(Sender: TObject);
begin
if MultiDoc1.ActiveObject is Tf_chart then with MultiDoc1.ActiveObject as Tf_chart do begin
   sc.cfgsc.ShowEcliptic:=not sc.cfgsc.ShowEcliptic;
   Refresh;
end;
end;

procedure Tf_main.ShowMarkExecute(Sender: TObject);
begin
if MultiDoc1.ActiveObject is Tf_chart then with MultiDoc1.ActiveObject as Tf_chart do begin
   sc.cfgsc.ShowCircle:=not sc.cfgsc.ShowCircle;
   Refresh;
end;
end;

procedure Tf_main.ShowObjectbelowHorizonExecute(Sender: TObject);
begin
if MultiDoc1.ActiveObject is Tf_chart then with MultiDoc1.ActiveObject as Tf_chart do begin
   sc.cfgsc.horizonopaque:=not sc.cfgsc.horizonopaque;
   Refresh;
end;
end;

procedure Tf_main.EquatorialProjectionExecute(Sender: TObject);
begin
if MultiDoc1.ActiveObject is Tf_chart then with MultiDoc1.ActiveObject as Tf_chart do begin
   sc.cfgsc.projpole:=Equat;
   sc.cfgsc.FindOk:=false; // invalidate the search result
   sc.cfgsc.theta:=0; // rotation = 0
   Refresh;
end;
end;

procedure Tf_main.AltAzProjectionExecute(Sender: TObject);
begin
if MultiDoc1.ActiveObject is Tf_chart then with MultiDoc1.ActiveObject as Tf_chart do begin
   sc.cfgsc.projpole:=AltAz;
   sc.cfgsc.FindOk:=false; // invalidate the search result
   sc.cfgsc.theta:=0; // rotation = 0
   Refresh;
end;
end;

procedure Tf_main.EclipticProjectionExecute(Sender: TObject);
begin
if MultiDoc1.ActiveObject is Tf_chart then with MultiDoc1.ActiveObject as Tf_chart do begin
   sc.cfgsc.projpole:=Ecl;
   sc.cfgsc.FindOk:=false; // invalidate the search result
   sc.cfgsc.theta:=0; // rotation = 0
   Refresh;
end;
end;

procedure Tf_main.GalacticProjectionExecute(Sender: TObject);
begin
if MultiDoc1.ActiveObject is Tf_chart then with MultiDoc1.ActiveObject as Tf_chart do begin
   sc.cfgsc.projpole:=Gal;
   sc.cfgsc.FindOk:=false; // invalidate the search result
   sc.cfgsc.theta:=0; // rotation = 0
   Refresh;
end;
end;

procedure Tf_main.CalendarExecute(Sender: TObject);
begin
  if not f_calendar.Visible then begin
    if MultiDoc1.ActiveObject is Tf_chart then f_calendar.config.Assign(Tf_chart(MultiDoc1.ActiveObject).sc.cfgsc)
       else f_calendar.config.Assign(def_cfgsc);
  end;
  f_calendar.AzNorth:=catalog.cfgshr.AzNorth;
  formpos(f_calendar,mouse.cursorpos.x,mouse.cursorpos.y);
  f_calendar.show;
  f_calendar.bringtofront;
end;

procedure Tf_main.TrackExecute(Sender: TObject);
begin
if MultiDoc1.ActiveObject is Tf_chart then with (MultiDoc1.ActiveObject as Tf_chart) do begin
  if sc.cfgsc.TrackOn then begin
     sc.cfgsc.TrackOn:=false;
     Refresh;
  end else if ((sc.cfgsc.TrackType>=1)and(sc.cfgsc.TrackType<=3)) or(sc.cfgsc.TrackType=6)
  then begin
     sc.cfgsc.TrackOn:=true;
     Refresh;
  end;
end;
end;
        
procedure Tf_main.PositionExecute(Sender: TObject);
begin
if MultiDoc1.ActiveObject is Tf_chart then with MultiDoc1.ActiveObject as Tf_chart do begin
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
      refresh;
   end;
end;
end;

procedure Tf_main.Search1Execute(Sender: TObject);
var ok: Boolean;
    ar1,de1 : Double;
    i : integer;
    chart:TForm;
begin
chart:=nil; ok:=false;
if MultiDoc1.ActiveObject is Tf_chart then chart:=MultiDoc1.ActiveObject
 else
 for i:=0 to MultiDoc1.ChildCount-1 do
   if MultiDoc1.Childs[i].DockedObject is Tf_chart then begin
      chart:=MultiDoc1.Childs[i].DockedObject;
      break;
   end;
if chart is Tf_chart then with chart as Tf_chart do begin
   formpos(f_search,mouse.cursorpos.x,mouse.cursorpos.y);
   f_search.cfgsc:=sc.cfgsc;
   f_search.InitPlanet;
   repeat
   f_search.showmodal;
   if f_search.modalresult=mrOk then begin
      case f_search.SearchKind of
      0  : ok:=catalog.SearchNebulae(f_search.Num,ar1,de1) ;
      1  : begin
           ar1:=f_search.ra;
           de1:=f_search.de;
           ok:=true;
           end;
      2  : ok:=catalog.SearchStar(f_search.Num,ar1,de1) ;
      3  : ok:=catalog.SearchStar(f_search.Num,ar1,de1) ;
      4  : ok:=catalog.SearchVarStar(f_search.Num,ar1,de1) ;
      5  : ok:=catalog.SearchDblStar(f_search.Num,ar1,de1) ;
      6  : ok:=planet.FindCometName(trim(f_search.Num),ar1,de1,sc.cfgsc);
      7  : ok:=planet.FindAsteroidName(trim(f_search.Num),ar1,de1,sc.cfgsc);
      8  : ok:=planet.FindPlanetName(trim(f_search.Num),ar1,de1,sc.cfgsc);
      9  : ok:=catalog.SearchConstellation(f_search.Num,ar1,de1);
      10 : ok:=catalog.SearchLines(f_search.Num,ar1,de1) ;
      else ok:=false;
      end;
      if ok then begin
        sc.cfgsc.TrackOn:=false;
        IdentLabel.visible:=false;
        precession(jd2000,sc.cfgsc.JDchart,ar1,de1);
        if sc.cfgsc.ApparentPos then apparent_equatorial(ar1,de1,sc.cfgsc);
        sc.movetoradec(ar1,de1);
        Refresh;
        if sc.cfgsc.fov>0.17 then sc.FindatRaDec(ar1,de1,0.0005,true)
                             else sc.FindatRaDec(ar1,de1,0.00005,true);
        ShowIdentLabel;
        f_main.SetLpanel1(wordspace(sc.cfgsc.FindDesc),caption);
        if f_search.SearchKind in [0,2,3,4,5,6,7,8] then begin
          i:=quicksearch.Items.IndexOf(f_search.Num);
          if (i<0)and(quicksearch.Items.Count>=MaxQuickSearch) then i:=MaxQuickSearch-1;
          if i>=0 then quicksearch.Items.Delete(i);
          quicksearch.Items.Insert(0,f_search.Num);
          quicksearch.ItemIndex:=0;
        end;
      end
      else begin
        ShowError(Format(rsNotFoundMayb, [f_search.Num, crlf]) );
      end;
   end;
   until ok or (f_search.ModalResult<>mrOk);
end;
end;

procedure Tf_main.GetChartConfig(csc:Tconf_skychart);
begin
if MultiDoc1.ActiveObject is Tf_chart then
 with MultiDoc1.ActiveObject as Tf_chart do
   csc.Assign(sc.cfgsc)
else
   csc.Assign(def_cfgsc);
end;

procedure Tf_main.DrawChart(csc:Tconf_skychart);
begin
if MultiDoc1.ActiveObject is Tf_chart then
 with MultiDoc1.ActiveObject as Tf_chart do begin
   sc.cfgsc.Assign(csc);
   Refresh;
end;
end;

procedure Tf_main.ReleaseNotes1Click(Sender: TObject);
begin
  ShowReleaseNotes(false);
end;

procedure Tf_main.SetupTimeExecute(Sender: TObject);
begin
SetupTimePage(0);
end;

procedure Tf_main.ToolBar1Enter(Sender: TObject);
begin
{$ifdef lclgtk2}
  quicksearch.Enabled:=true;
  TimeVal.Enabled:=true;
  TimeU.Enabled:=true;
{$endif}
end;

procedure Tf_main.Toolbar1MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
    ToolBar1Enter(sender);
end;

procedure Tf_main.ToolButtonConfigClick(Sender: TObject);
begin
  ToolButtonConfig.PopupMenu.PopUp(mouse.cursorpos.x,mouse.cursorpos.y);
end;

procedure Tf_main.SetupTimePage(page:integer);
begin
if ConfigTime=nil then begin
   ConfigTime:=Tf_config_time.Create(self);
   {$ifdef win32}ScaleForm(ConfigTime,Screen.PixelsPerInch/96);{$endif}
   ConfigTime.Notebook1.ShowTabs:=true;
   ConfigTime.Notebook1.PageIndex:=0;
   ConfigTime.onApplyConfig:=ApplyConfigTime;
end;
{$ifdef win32}SetFormNightVision(ConfigTime,nightvision);{$endif}
ConfigTime.ccat.Assign(catalog.cfgcat);
ConfigTime.cshr.Assign(catalog.cfgshr);
ConfigTime.cplot.Assign(def_cfgplot);
ConfigTime.csc.Assign(def_cfgsc);
if MultiDoc1.ActiveObject is Tf_chart then with MultiDoc1.ActiveObject as Tf_chart do begin
   ConfigTime.csc.Assign(sc.cfgsc);
   ConfigTime.cplot.Assign(sc.plot.cfgplot);
end;
cfgm.prgdir:=appdir;
cfgm.persdir:=privatedir;
ConfigTime.cmain.Assign(cfgm);
formpos(ConfigTime,mouse.cursorpos.x,mouse.cursorpos.y);
ConfigTime.Notebook1.PageIndex:=page;
ConfigTime.showmodal;
if ConfigTime.ModalResult=mrOK then begin
 activateconfig(ConfigTime.cmain,ConfigTime.csc,ConfigTime.ccat,ConfigTime.cshr,ConfigTime.cplot,nil,false);
end;
ConfigTime.Free;
ConfigTime:=nil;
end;

procedure Tf_main.ApplyConfigTime(Sender: TObject);
begin
 activateconfig(ConfigTime.cmain,ConfigTime.csc,ConfigTime.ccat,ConfigTime.cshr,ConfigTime.cplot,nil,false);
end;

procedure Tf_main.SetupPicturesExecute(Sender: TObject);
begin
SetupPicturesPage(1);
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
   f_config.Fits:=fits;
   f_config.catalog:=catalog;
   f_config.db:=cdcdb;
end;
try
 f_config.ccat:=catalog.cfgcat;
 f_config.cshr:=catalog.cfgshr;
 f_config.cplot:=def_cfgplot;
 f_config.csc:=def_cfgsc;
 if MultiDoc1.ActiveObject is Tf_chart then with MultiDoc1.ActiveObject as Tf_chart do begin
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
   ConfigChart:=Tf_config_chart.Create(self);
   {$ifdef win32}ScaleForm(ConfigChart,Screen.PixelsPerInch/96);{$endif}
   ConfigChart.Notebook1.ShowTabs:=true;
   ConfigChart.Notebook1.PageIndex:=0;
   ConfigChart.onApplyConfig:=ApplyConfigChart;
end;
{$ifdef win32}SetFormNightVision(ConfigChart,nightvision);{$endif}
ConfigChart.ccat.Assign(catalog.cfgcat);
ConfigChart.cshr.Assign(catalog.cfgshr);
ConfigChart.cplot.Assign(def_cfgplot);
ConfigChart.csc.Assign(def_cfgsc);
if MultiDoc1.ActiveObject is Tf_chart then with MultiDoc1.ActiveObject as Tf_chart do begin
   ConfigChart.csc.Assign(sc.cfgsc);
   ConfigChart.cplot.Assign(sc.plot.cfgplot);
end;
cfgm.prgdir:=appdir;
cfgm.persdir:=privatedir;
ConfigChart.cmain.Assign(cfgm);
formpos(ConfigChart,mouse.cursorpos.x,mouse.cursorpos.y);
ConfigChart.Notebook1.PageIndex:=page;
ConfigChart.showmodal;
if ConfigChart.ModalResult=mrOK then begin
 activateconfig(ConfigChart.cmain,ConfigChart.csc,ConfigChart.ccat,ConfigChart.cshr,ConfigChart.cplot,nil,false);
end;
ConfigChart.Free;
ConfigChart:=nil;
end;

procedure Tf_main.ApplyConfigChart(Sender: TObject);
begin
 activateconfig(ConfigChart.cmain,ConfigChart.csc,ConfigChart.ccat,ConfigChart.cshr,ConfigChart.cplot,nil,false);
end;

procedure Tf_main.SetupSolSysExecute(Sender: TObject);
begin
 SetupSolsysPage(0);
end;

procedure Tf_main.SetupSolsysPage(page:integer);
begin
if ConfigSolsys=nil then begin
   ConfigSolsys:=Tf_config_solsys.Create(self);
   {$ifdef win32}ScaleForm(ConfigSolsys,Screen.PixelsPerInch/96);{$endif}
   ConfigSolsys.Notebook1.ShowTabs:=true;
   ConfigSolsys.Notebook1.PageIndex:=0;
   ConfigSolsys.onApplyConfig:=ApplyConfigSolsys;
   ConfigSolsys.onPrepareAsteroid:=PrepareAsteroid;
end;
{$ifdef win32}SetFormNightVision(ConfigSolsys,nightvision);{$endif}
ConfigSolsys.cdb:=cdcdb;
ConfigSolsys.ccat.Assign(catalog.cfgcat);
ConfigSolsys.cshr.Assign(catalog.cfgshr);
ConfigSolsys.cplot.Assign(def_cfgplot);
ConfigSolsys.csc.Assign(def_cfgsc);
if MultiDoc1.ActiveObject is Tf_chart then with MultiDoc1.ActiveObject as Tf_chart do begin
   ConfigSolsys.csc.Assign(sc.cfgsc);
   ConfigSolsys.cplot.Assign(sc.plot.cfgplot);
end;
cfgm.prgdir:=appdir;
cfgm.persdir:=privatedir;
ConfigSolsys.cmain.Assign(cfgm);
formpos(ConfigSolsys,mouse.cursorpos.x,mouse.cursorpos.y);
ConfigSolsys.Notebook1.PageIndex:=page;
ConfigSolsys.showmodal;
if ConfigSolsys.ModalResult=mrOK then begin
 activateconfig(ConfigSolsys.cmain,ConfigSolsys.csc,ConfigSolsys.ccat,ConfigSolsys.cshr,ConfigSolsys.cplot,nil,false);
end;
ConfigSolsys.Free;
ConfigSolsys:=nil;
end;

procedure Tf_main.ApplyConfigSolsys(Sender: TObject);
begin
 activateconfig(ConfigSolsys.cmain,ConfigSolsys.csc,ConfigSolsys.ccat,ConfigSolsys.cshr,ConfigSolsys.cplot,nil,false);
end;

procedure Tf_main.SetupSystemExecute(Sender: TObject);
begin
 SetupSystemPage(0);
end;

procedure Tf_main.SetupSystemPage(page:integer);
begin
if ConfigSystem=nil then begin
   ConfigSystem:=Tf_config_system.Create(self);
   {$ifdef win32}ScaleForm(ConfigSystem,Screen.PixelsPerInch/96);{$endif}
   ConfigSystem.Notebook1.ShowTabs:=true;
   ConfigSystem.Notebook1.PageIndex:=0;
   ConfigSystem.onApplyConfig:=ApplyConfigSystem;
   ConfigSystem.onDBChange:=ConfigDBChange;
   ConfigSystem.onSaveAndRestart:=SaveAndRestart;
end;
{$ifdef win32}SetFormNightVision(ConfigSystem,nightvision);{$endif}
ConfigSystem.cdb:=cdcdb;
ConfigSystem.ccat.Assign(catalog.cfgcat);
ConfigSystem.cshr.Assign(catalog.cfgshr);
ConfigSystem.cplot.Assign(def_cfgplot);
ConfigSystem.csc.Assign(def_cfgsc);
if MultiDoc1.ActiveObject is Tf_chart then with MultiDoc1.ActiveObject as Tf_chart do begin
   ConfigSystem.csc.Assign(sc.cfgsc);
   ConfigSystem.cplot.Assign(sc.plot.cfgplot);
end;
cfgm.prgdir:=appdir;
cfgm.persdir:=privatedir;
ConfigSystem.cmain.Assign(cfgm);
formpos(ConfigSystem,mouse.cursorpos.x,mouse.cursorpos.y);
ConfigSystem.Notebook1.PageIndex:=page;
ConfigSystem.showmodal;
if ConfigSystem.ModalResult=mrOK then begin
 ConfigSystem.ActivateDBchange;
 activateconfig(ConfigSystem.cmain,ConfigSystem.csc,ConfigSystem.ccat,ConfigSystem.cshr,ConfigSystem.cplot,nil,false);
end;
ConfigSystem.Free;
ConfigSystem:=nil;
end;

procedure Tf_main.ApplyConfigSystem(Sender: TObject);
begin
 activateconfig(ConfigSystem.cmain,ConfigSystem.csc,ConfigSystem.ccat,ConfigSystem.cshr,ConfigSystem.cplot,nil,false);
end;

procedure Tf_main.SetupInternetExecute(Sender: TObject);
begin
 SetupInternetPage(0);
end;

procedure Tf_main.SetupInternetPage(page:integer);
begin
if ConfigInternet=nil then begin
   ConfigInternet:=Tf_config_internet.Create(self);
   {$ifdef win32}ScaleForm(ConfigInternet,Screen.PixelsPerInch/96);{$endif}
   ConfigInternet.Notebook1.ShowTabs:=true;
   ConfigInternet.Notebook1.PageIndex:=0;
   ConfigInternet.onApplyConfig:=ApplyConfigInternet;
end;
{$ifdef win32}SetFormNightVision(ConfigInternet,nightvision);{$endif}
cfgm.prgdir:=appdir;
cfgm.persdir:=privatedir;
ConfigInternet.cmain.Assign(cfgm);
formpos(ConfigInternet,mouse.cursorpos.x,mouse.cursorpos.y);
ConfigInternet.Notebook1.PageIndex:=page;
ConfigInternet.showmodal;
if ConfigInternet.ModalResult=mrOK then begin
 activateconfig(ConfigInternet.cmain,nil,nil,nil,nil,nil,false);
end;
ConfigInternet.Free;
ConfigInternet:=nil;
end;

procedure Tf_main.ApplyConfigInternet(Sender: TObject);
begin
 activateconfig(ConfigInternet.cmain,nil,nil,nil,nil,nil,false);
end;

procedure Tf_main.SetupPicturesPage(page:integer);
begin
if ConfigPictures=nil then begin
   ConfigPictures:=Tf_config_pictures.Create(self);
   {$ifdef win32}ScaleForm(ConfigPictures,Screen.PixelsPerInch/96);{$endif}
   ConfigPictures.Notebook1.ShowTabs:=true;
   ConfigPictures.Notebook1.PageIndex:=0;
   ConfigPictures.onApplyConfig:=ApplyConfigPictures;
end;
{$ifdef win32}SetFormNightVision(ConfigPictures,nightvision);{$endif}
ConfigPictures.cdb:=cdcdb;
ConfigPictures.cdss.Assign(f_getdss.cfgdss);
ConfigPictures.Fits:=Fits;
ConfigPictures.ccat.Assign(catalog.cfgcat);
ConfigPictures.cshr.Assign(catalog.cfgshr);
ConfigPictures.cplot.Assign(def_cfgplot);
ConfigPictures.csc.Assign(def_cfgsc);
if MultiDoc1.ActiveObject is Tf_chart then with MultiDoc1.ActiveObject as Tf_chart do begin
   ConfigPictures.csc.Assign(sc.cfgsc);
   ConfigPictures.cplot.Assign(sc.plot.cfgplot);
end;
cfgm.prgdir:=appdir;
cfgm.persdir:=privatedir;
ConfigPictures.cmain.Assign(cfgm);
formpos(ConfigPictures,mouse.cursorpos.x,mouse.cursorpos.y);
ConfigPictures.Notebook1.PageIndex:=page;
ConfigPictures.show;
ConfigPictures.backimgChange(self);
ConfigPictures.hide;
ConfigPictures.showmodal;
if ConfigPictures.ModalResult=mrOK then begin
 activateconfig(ConfigPictures.cmain,ConfigPictures.csc,ConfigPictures.ccat,ConfigPictures.cshr,ConfigPictures.cplot,ConfigPictures.cdss,false);
end;
ConfigPictures.Free;
ConfigPictures:=nil;
end;

procedure Tf_main.ApplyConfigPictures(Sender: TObject);
begin
 activateconfig(ConfigPictures.cmain,ConfigPictures.csc,ConfigPictures.ccat,ConfigPictures.cshr,ConfigPictures.cplot,ConfigPictures.cdss,false);
end;


procedure Tf_main.SetupObservatoryExecute(Sender: TObject);
begin
SetupObservatoryPage(0);
end;

procedure Tf_main.SetupObservatoryPage(page:integer; posx:integer=0; posy:integer=0);
begin
if ConfigObservatory=nil then begin
   ConfigObservatory:=Tf_config_observatory.Create(self);
   {$ifdef win32} ScaleForm(ConfigObservatory,Screen.PixelsPerInch/96);{$endif}
   ConfigObservatory.Notebook1.ShowTabs:=true;
   ConfigObservatory.Notebook1.PageIndex:=0;
   ConfigObservatory.onApplyConfig:=ApplyConfigObservatory;
end;
{$ifdef win32}SetFormNightVision(ConfigObservatory,nightvision);{$endif}
ConfigObservatory.cdb:=cdcdb;
ConfigObservatory.ccat.Assign(catalog.cfgcat);
ConfigObservatory.cshr.Assign(catalog.cfgshr);
ConfigObservatory.cplot.Assign(def_cfgplot);
ConfigObservatory.csc.Assign(def_cfgsc);
if MultiDoc1.ActiveObject is Tf_chart then with MultiDoc1.ActiveObject as Tf_chart do begin
   ConfigObservatory.csc.Assign(sc.cfgsc);
   ConfigObservatory.cplot.Assign(sc.plot.cfgplot);
end;
cfgm.prgdir:=appdir;
cfgm.persdir:=privatedir;
ConfigObservatory.cmain.Assign(cfgm);
if (posx=0)and(posy=0) then
   formpos(ConfigObservatory,mouse.cursorpos.x,mouse.cursorpos.y)
else
  if (posx>0)and(posy>0) then
   formpos(ConfigObservatory,posx,posy);
ConfigObservatory.Notebook1.PageIndex:=page;
ConfigObservatory.showmodal;
if ConfigObservatory.ModalResult=mrOK then begin
 activateconfig(ConfigObservatory.cmain,ConfigObservatory.csc,ConfigObservatory.ccat,ConfigObservatory.cshr,ConfigObservatory.cplot,nil,false);
end;
ConfigObservatory.Free;
ConfigObservatory:=nil;
end;

procedure Tf_main.ApplyConfigObservatory(Sender: TObject);
begin
 activateconfig(ConfigObservatory.cmain,ConfigObservatory.csc,ConfigObservatory.ccat,ConfigObservatory.cshr,ConfigObservatory.cplot,nil,false);
end;

procedure Tf_main.SetupCatalogExecute(Sender: TObject);
begin
SetupCatalogPage(0);
end;

procedure Tf_main.SetupCatalogPage(page:integer);
begin
if ConfigCatalog=nil then begin
   ConfigCatalog:=Tf_config_catalog.Create(self);
   {$ifdef win32} ScaleForm(ConfigCatalog,Screen.PixelsPerInch/96);{$endif}
   ConfigCatalog.catalog:=catalog;
   ConfigCatalog.Notebook1.ShowTabs:=true;
   ConfigCatalog.Notebook1.PageIndex:=0;
   ConfigCatalog.onApplyConfig:=ApplyConfigCatalog;
end;
{$ifdef win32}SetFormNightVision(ConfigCatalog,nightvision);{$endif}
ConfigCatalog.ccat.Assign(catalog.cfgcat);
ConfigCatalog.cshr.Assign(catalog.cfgshr);
ConfigCatalog.cplot.Assign(def_cfgplot);
ConfigCatalog.csc.Assign(def_cfgsc);
if MultiDoc1.ActiveObject is Tf_chart then with MultiDoc1.ActiveObject as Tf_chart do begin
   ConfigCatalog.csc.Assign(sc.cfgsc);
   ConfigCatalog.cplot.Assign(sc.plot.cfgplot);
end;
cfgm.prgdir:=appdir;
cfgm.persdir:=privatedir;
ConfigCatalog.cmain.Assign(cfgm);
formpos(ConfigCatalog,mouse.cursorpos.x,mouse.cursorpos.y);
ConfigCatalog.Notebook1.PageIndex:=page;
ConfigCatalog.showmodal;
if ConfigCatalog.ModalResult=mrOK then begin
 ConfigCatalog.ActivateGCat;
 activateconfig(ConfigCatalog.cmain,ConfigCatalog.csc,ConfigCatalog.ccat,ConfigCatalog.cshr,ConfigCatalog.cplot,nil,false);
end;
ConfigCatalog.Free;
ConfigCatalog:=nil;
end;

procedure Tf_main.ApplyConfigCatalog(Sender: TObject);
begin
 ConfigCatalog.ActivateGCat;
 activateconfig(ConfigCatalog.cmain,ConfigCatalog.csc,ConfigCatalog.ccat,ConfigCatalog.cshr,ConfigCatalog.cplot,nil,false);
end;

procedure Tf_main.SetupDisplayExecute(Sender: TObject);
begin
SetupDisplayPage(0);
end;

procedure Tf_main.SetupDisplayPage(pagegroup:integer);
begin
if ConfigDisplay=nil then begin
   ConfigDisplay:=Tf_config_display.Create(self);
   {$ifdef win32} ScaleForm(ConfigDisplay,Screen.PixelsPerInch/96);{$endif}
   ConfigDisplay.Notebook1.ShowTabs:=true;
   ConfigDisplay.Notebook1.PageIndex:=0;
   ConfigDisplay.onApplyConfig:=ApplyConfigDisplay;
end;
{$ifdef win32}SetFormNightVision(ConfigDisplay,nightvision);{$endif}
ConfigDisplay.ccat.Assign(catalog.cfgcat);
ConfigDisplay.cshr.Assign(catalog.cfgshr);
ConfigDisplay.cplot.Assign(def_cfgplot);
ConfigDisplay.csc.Assign(def_cfgsc);
if MultiDoc1.ActiveObject is Tf_chart then with MultiDoc1.ActiveObject as Tf_chart do begin
   ConfigDisplay.csc.Assign(sc.cfgsc);
   ConfigDisplay.cplot.Assign(sc.plot.cfgplot);
end;
cfgm.prgdir:=appdir;
cfgm.persdir:=privatedir;
ConfigDisplay.cmain.Assign(cfgm);
formpos(ConfigDisplay,mouse.cursorpos.x,mouse.cursorpos.y);
{$ifdef win32}
// Problem with initialization
ConfigDisplay.show;
ConfigDisplay.hide;
ConfigDisplay.ccat.Assign(catalog.cfgcat);
ConfigDisplay.cshr.Assign(catalog.cfgshr);
ConfigDisplay.cplot.Assign(def_cfgplot);
ConfigDisplay.csc.Assign(def_cfgsc);
if MultiDoc1.ActiveObject is Tf_chart then with MultiDoc1.ActiveObject as Tf_chart do begin
   ConfigDisplay.csc.Assign(sc.cfgsc);
   ConfigDisplay.cplot.Assign(sc.plot.cfgplot);
end;
cfgm.prgdir:=appdir;
cfgm.persdir:=privatedir;
ConfigDisplay.cmain.Assign(cfgm);
///////////////////////////////
{$endif}
ConfigDisplay.showmodal;
if ConfigDisplay.ModalResult=mrOK then begin
 activateconfig(ConfigDisplay.cmain,ConfigDisplay.csc,ConfigDisplay.ccat,ConfigDisplay.cshr,ConfigDisplay.cplot,nil,false);
end;
ConfigDisplay.Free;
ConfigDisplay:=nil;
end;

procedure Tf_main.ApplyConfigDisplay(Sender: TObject);
begin
 activateconfig(ConfigDisplay.cmain,ConfigDisplay.csc,ConfigDisplay.ccat,ConfigDisplay.cshr,ConfigDisplay.cplot,nil,false);
end;

function Tf_main.PrepareAsteroid(jdt:double; msg:Tstrings):boolean;
begin
 result:=planet.PrepareAsteroid(jdt,msg);
end;

procedure Tf_main.ConfigDBChange(Sender: TObject);
begin
if ConfigSystem<>nil then begin
  cfgm.dbhost:=ConfigSystem.cmain.dbhost;
  cfgm.db:=ConfigSystem.cmain.db;
  cfgm.dbuser:=ConfigSystem.cmain.dbuser;
  cfgm.dbpass:=ConfigSystem.cmain.dbpass;
  cfgm.dbport:=ConfigSystem.cmain.dbport;
  ConnectDB;
end;
end;

procedure Tf_main.SaveAndRestart(Sender: TObject);
begin
if ConfigSystem<>nil then begin
  cfgm.Assign(ConfigSystem.cmain);
  if directoryexists(cfgm.prgdir) then appdir:=cfgm.prgdir;
  privatedir:=cfgm.persdir;
  def_cfgsc.Assign(ConfigSystem.csc);
  catalog.cfgcat.Assign(ConfigSystem.ccat);
  catalog.cfgshr.Assign(ConfigSystem.cshr);
  SavePrivateConfig(configfile);
  NeedRestart:=true;
  Close;
end;
end;

procedure Tf_main.activateconfig(cmain:Tconf_main; csc:Tconf_skychart; ccat:Tconf_catalog; cshr:Tconf_shared; cplot:Tconf_plot; cdss:Tconf_dss; applyall:boolean );
var i:integer;
  themechange,langchange: Boolean;
begin
    themechange:=false; langchange:=false;
    if cmain<>nil then begin
      if (cfgm.language<>cmain.language) then langchange:=true;
    end;
    if langchange then ChangeLanguage(cmain.language);
    if cmain<>nil then begin
      if (cfgm.ButtonNight <> cmain.ButtonNight) or
         (cfgm.ButtonStandard <> cmain.ButtonStandard) or
         (cfgm.ThemeName <> cmain.ThemeName)
         then themechange:=true;
      cfgm.Assign(cmain);
    end;
    if themechange then SetTheme;
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
    if csc<>nil  then def_cfgsc.Assign(csc);
    if cplot<>nil then def_cfgplot.Assign(cplot);
    def_cfgplot.starshapesize:=starshape.Picture.bitmap.Width div 11;
    def_cfgplot.starshapew:=def_cfgplot.starshapesize div 2;
    InitFonts;
    if def_cfgsc.ConstLatinLabel then
         catalog.LoadConstellation(cfgm.Constellationpath,'Latin')
      else
         catalog.LoadConstellation(cfgm.Constellationpath,lang);
    catalog.LoadStarName(slash(appdir)+slash('data')+slash('common_names'),Lang);
    catalog.LoadConstL(cfgm.ConstLfile);
    catalog.LoadConstB(cfgm.ConstBfile);
    catalog.LoadHorizon(cfgm.horizonfile,def_cfgsc);
    ConnectDB;
    Fits.min_sigma:=cfgm.ImageLuminosity;
    Fits.max_sigma:=cfgm.ImageContrast;
    TelescopePanel.visible:=def_cfgsc.IndiTelescope;
    {$ifdef win32}
    if (telescope.scopelibok)and(def_cfgsc.IndiTelescope) then begin
       telescope.ScopeDisconnect;
       telescope.UnloadScopeLibrary;
    end;
    if (telescope.scopelibok)and(def_cfgsc.PluginTelescope)and(def_cfgsc.ScopePlugin<>telescope.plugin) then begin
       telescope.ScopeDisconnect;
       telescope.UnloadScopeLibrary;
    end;
    telescope.plugin:=def_cfgsc.ScopePlugin;
    {$endif}
    if MultiDoc1.ActiveObject is Tf_chart then with MultiDoc1.ActiveObject as Tf_chart do begin
       sc.cfgsc.Assign(def_cfgsc);
       sc.Fits:=Fits;
       sc.planet:=planet;
       sc.cdb:=cdcdb;
       sc.cfgsc.FindOk:=false;
       sc.plot.cfgplot.Assign(def_cfgplot);
       if cfgm.NewBackgroundImage then begin
          sc.Fits.Filename:=sc.cfgsc.BackgroundImage;
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

procedure Tf_main.ViewScrollBar1Click(Sender: TObject);
var i: Integer;
begin
ViewScrollBar1.Checked:=not ViewScrollBar1.Checked;
for i:=0 to MultiDoc1.ChildCount-1 do
  if MultiDoc1.Childs[i].DockedObject is Tf_chart then begin
    (MultiDoc1.Childs[i].DockedObject as Tf_chart).VertScrollBar.Visible:=ViewScrollBar1.Checked;
    (MultiDoc1.Childs[i].DockedObject as Tf_chart).HorScrollBar.Visible:=ViewScrollBar1.Checked;
    (MultiDoc1.Childs[i].DockedObject as Tf_chart).Refresh;
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
begin
{   LPanels01.Caption:='Ra:222h22m22.22s +22°22''22"22';
   PanelBottom.height:=2*LPanels01.Height+8;
   PPanels0.Width:=LPanels01.width+8;
   Lpanels01.Caption:='';
   Lpanels0.Caption:='';}
end;

Procedure Tf_main.SetLPanel1(txt:string; origin:string='';sendmsg:boolean=true;Sender: TObject=nil);
begin
if (txt>'') then writetrace(txt);
P1L1.Caption:=wordspace(stringreplace(txt,tab,blank,[rfReplaceall]));
if sendmsg then SendInfo(Sender,origin,txt);
// refresh tracking object
if MultiDoc1.ActiveObject is Tf_chart then with (MultiDoc1.ActiveObject as Tf_chart) do begin
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
if MultiDoc1.ActiveObject=sender then begin
  topmsg:=txt;
  if cfgm.ShowChartInfo then topmessage.caption:=topmsg
     else topmessage.caption:=' ';
end;
end;

procedure Tf_main.FormResize(Sender: TObject);
begin
  MultiDoc1.Align:=alNone;
  MultiDoc1.Width:=MultiDoc1.Width-1;
  MultiDoc1.Align:=alClient;
end;

procedure Tf_main.SetDefault;
var i:integer;
    buf:string;
begin
nightvision:=false;
cfgm.MaxChildID:=0;
cfgm.prtname:='';
cfgm.configpage:=0;
cfgm.configpage_i:=0;
cfgm.configpage_j:=0;
cfgm.Paper:=2;
cfgm.PrinterResolution:=72;
cfgm.PrintColor:=0;
cfgm.PrintLandscape:=true;
cfgm.PrintMethod:=0;
cfgm.PrintCmd1:=DefaultPrintCmd1;
cfgm.PrintCmd2:=DefaultPrintCmd2;
cfgm.PrintTmpPath:=expandfilename(TempDir);
cfgm.PrtLeftMargin:=15;
cfgm.PrtRightMargin:=15;
cfgm.PrtTopMargin:=10;
cfgm.PrtBottomMargin:=5;
cfgm.maximized:=true;
cfgm.updall:=true;
cfgm.AutoRefreshDelay:=60;
cfgm.ServerIPaddr:='127.0.0.1';
cfgm.ServerIPport:='3292'; // x'CDC' :o)
cfgm.IndiPanelCmd:=dcd_cmd;
cfgm.keepalive:=true;
cfgm.AutostartServer:=true;
cfgm.dbhost:='localhost';
cfgm.dbport:=3306;
cfgm.db:=slash(privatedir)+StringReplace(defaultSqliteDB,'/',PathDelim,[rfReplaceAll]);
cfgm.dbuser:='root';
cfgm.dbpass:='';
cfgm.ImagePath:=slash(appDir)+slash('data')+slash('pictures');
cfgm.ImageLuminosity:=0;
cfgm.ImageContrast:=0;
cfgm.ShowChartInfo:=false;
cfgm.SyncChart:=false;
cfgm.ThemeName:='default';
cfgm.ButtonStandard:=1;
cfgm.ButtonNight:=2;
cfgm.HttpProxy:=false;
cfgm.FtpPassive:=true;
cfgm.ConfirmDownload:=true;
cfgm.ProxyHost:='';
cfgm.ProxyPort:='';
cfgm.ProxyUser:='';
cfgm.ProxyPass:='';
cfgm.AnonPass:='skychart@';
cfgm.CometUrlList:=TStringList.Create;
cfgm.CometUrlList.Add(URL_HTTPCometElements);
cfgm.AsteroidUrlList:=TStringList.Create;
cfgm.AsteroidUrlList.Add(URL_CDCAsteroidElements);
cfgm.AsteroidUrlList.Add(URL_HTTPAsteroidElements2);
cfgm.AsteroidUrlList.Add(URL_HTTPAsteroidElements3);
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
f_getdss.cfgdss.OnlineDSS:=true;
f_getdss.cfgdss.OnlineDSSid:=1;
for i:=1 to numfont do begin
   def_cfgplot.FontName[i]:=DefaultFontName;
   def_cfgplot.FontSize[i]:=DefaultFontSize;
   def_cfgplot.FontBold[i]:=false;
   def_cfgplot.FontItalic[i]:=false;
end;
def_cfgplot.FontSize[4]:=8;
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
def_cfgplot.LabelSize[6]:=12;
def_cfgplot.contrast:=400;
def_cfgplot.partsize:=1.2;
def_cfgplot.red_move:=true;
def_cfgplot.magsize:=4;
def_cfgplot.saturation:=192;
cfgm.Constellationpath:=slash(appdir)+'data'+Pathdelim+'constellation';
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
def_cfgplot.TransparentPlanet:=false;
def_cfgplot.AutoSkycolor:=false;
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
def_cfgsc.StyleGrid:=psSolid;
def_cfgsc.StyleEqGrid:=psSolid;
def_cfgsc.StyleConstL:=psSolid;
def_cfgsc.StyleConstB:=psSolid;
def_cfgsc.StyleEcliptic:=psSolid;
def_cfgsc.StyleGalEq:=psSolid;
def_cfgsc.Simnb:=1;
def_cfgsc.SimLabel:=1;
def_cfgsc.SimNameLabel:=true;
def_cfgsc.SimDateLabel:=true;
def_cfgsc.SimDateYear:=true;
def_cfgsc.SimDateMonth:=true;
def_cfgsc.SimDateDay:=true;
def_cfgsc.SimDateHour:=true;
def_cfgsc.SimDateMinute:=true;
def_cfgsc.SimDateSecond:=false;
def_cfgsc.SimMagLabel:=false;
def_cfgsc.SimD:=1;
def_cfgsc.SimH:=0;
def_cfgsc.SimM:=0;
def_cfgsc.SimS:=0;
def_cfgsc.SimLine:=True;
for i:=1 to NumSimObject do def_cfgsc.SimObject[i]:=true;
def_cfgsc.ShowPlanet:=true;
def_cfgsc.ShowPluto:=true;
def_cfgsc.ShowAsteroid:=true;
def_cfgsc.ShowImages:=true;
def_cfgsc.ShowBackgroundImage:=false;
def_cfgsc.BackgroundImage:='';
def_cfgsc.AstSymbol:=0;
def_cfgsc.AstmagMax:=18;
def_cfgsc.AstmagDiff:=6;
def_cfgsc.ShowComet:=true;
def_cfgsc.ComSymbol:=1;
def_cfgsc.CommagMax:=18;
def_cfgsc.CommagDiff:=4;
def_cfgsc.MagLabel:=false;
def_cfgsc.NameLabel:=false;
def_cfgsc.ConstFullLabel:=true;
def_cfgsc.DrawAllStarLabel:=false;
def_cfgsc.ConstLatinLabel:=false;
def_cfgsc.PlanetParalaxe:=true;
def_cfgsc.ShowEarthShadow:=false;
def_cfgsc.GRSlongitude:=92;
def_cfgsc.LabelOrientation:=1;
def_cfgsc.FindOk:=false;
def_cfgsc.nummodlabels:=0;
def_cfgsc.posmodlabels:=0;
def_cfgsc.numcustomlabels:=0;
def_cfgsc.poscustomlabels:=0;
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
def_cfgsc.IndiDriver:='lx200basic';
def_cfgsc.IndiPort:='/dev/ttyS0';
def_cfgsc.IndiDevice:='LX200 Basic';
def_cfgsc.IndiTelescope:=false;
def_cfgsc.PluginTelescope:=false;
def_cfgsc.ManualTelescope:=false;
{$ifdef unix}
   def_cfgsc.ManualTelescope:=true;
{$endif}
{$ifdef win32}
   def_cfgsc.PluginTelescope:=true;
{$endif}
def_cfgsc.ManualTelescopeType:=0;
def_cfgsc.TelescopeTurnsX:=6;    // Vixen GP
def_cfgsc.TelescopeTurnsY:=0.4;
def_cfgsc.ScopePlugin:='Ascom.tid';
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
catalog.cfgcat.NebmagMax:=12;
catalog.cfgcat.NebSizeMin:=1;
catalog.cfgcat.UseUSNOBrightStars:=false;
catalog.cfgcat.UseGSVSIr:=false;
catalog.cfgcat.GCatNum:=1;
SetLength(catalog.cfgcat.GCatLst,catalog.cfgcat.GCatNum);
catalog.cfgcat.GCatLst[0].shortname:='dsl';
catalog.cfgcat.GCatLst[0].name:='Nebulae Outlines, spline curve';
catalog.cfgcat.GCatLst[0].path:='cat/DSoutlines/';
catalog.cfgcat.GCatLst[0].min:=0;
catalog.cfgcat.GCatLst[0].max:=10;
catalog.cfgcat.GCatLst[0].Actif:=true;
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
catalog.cfgcat.starcatpath[gscf-BaseStar]:=catalog.cfgcat.starcatpath[gscf-BaseStar]+PathDelim+'gsc';
catalog.cfgcat.starcatfield[gscf-BaseStar,1]:=0;
catalog.cfgcat.starcatfield[gscf-BaseStar,2]:=3;
catalog.cfgcat.starcatpath[gscc-BaseStar]:=catalog.cfgcat.starcatpath[gscc-BaseStar]+PathDelim+'gsc';
catalog.cfgcat.starcatfield[gscc-BaseStar,1]:=0;
catalog.cfgcat.starcatfield[gscc-BaseStar,2]:=3;
catalog.cfgcat.starcatpath[usnoa-BaseStar]:=catalog.cfgcat.starcatpath[usnoa-BaseStar]+PathDelim+'usnoa';
catalog.cfgcat.starcatfield[usnoa-BaseStar,1]:=0;
catalog.cfgcat.starcatfield[usnoa-BaseStar,2]:=1;
catalog.cfgcat.starcatpath[dsbase-BaseStar]:=PathDelim+'Deepsky2000';
catalog.cfgcat.starcatfield[dsbase-BaseStar,1]:=0;
catalog.cfgcat.starcatfield[dsbase-BaseStar,2]:=10;
catalog.cfgcat.starcatpath[dstyc-BaseStar]:=PathDelim+'Deepsky2000';
catalog.cfgcat.starcatfield[dstyc-BaseStar,1]:=0;
catalog.cfgcat.starcatfield[dstyc-BaseStar,2]:=5;
catalog.cfgcat.starcatpath[dsgsc-BaseStar]:=PathDelim+'Deepsky2000';
catalog.cfgcat.starcatfield[dsgsc-BaseStar,1]:=0;
catalog.cfgcat.starcatfield[dsgsc-BaseStar,2]:=3;
for i:=1 to maxvarstarcatalog do begin
   catalog.cfgcat.varstarcatpath[i]:=slash(appdir)+'cat';
   catalog.cfgcat.varstarcatdef[i]:=false;
   catalog.cfgcat.varstarcaton[i]:=false;
   catalog.cfgcat.varstarcatfield[i,1]:=0;
   catalog.cfgcat.varstarcatfield[i,2]:=0;
end;
catalog.cfgcat.varstarcatpath[gcvs-BaseVar]:=catalog.cfgcat.varstarcatpath[gcvs-BaseVar]+PathDelim+'gcvs';
catalog.cfgcat.varstarcatfield[gcvs-BaseVar,1]:=0;
catalog.cfgcat.varstarcatfield[gcvs-BaseVar,2]:=10;
for i:=1 to maxdblstarcatalog do begin
   catalog.cfgcat.dblstarcatpath[i]:=slash(appdir)+'cat';
   catalog.cfgcat.dblstarcatdef[i]:=false;
   catalog.cfgcat.dblstarcaton[i]:=false;
   catalog.cfgcat.dblstarcatfield[i,1]:=0;
   catalog.cfgcat.dblstarcatfield[i,2]:=0;
end;
catalog.cfgcat.dblstarcatpath[wds-BaseDbl]:=catalog.cfgcat.dblstarcatpath[wds-BaseDbl]+PathDelim+'wds';
catalog.cfgcat.dblstarcatfield[wds-BaseDbl,1]:=0;
catalog.cfgcat.dblstarcatfield[wds-BaseDbl,2]:=10;
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
catalog.cfgcat.nebcatfield[ngc-BaseNeb,2]:=10;
catalog.cfgcat.nebcatpath[lbn-BaseNeb]:=slash(appdir)+'cat'+PathDelim+'lbn';
catalog.cfgcat.nebcatfield[lbn-BaseNeb,2]:=5;
catalog.cfgcat.nebcatpath[rc3-BaseNeb]:=slash(appdir)+'cat'+PathDelim+'rc3';
catalog.cfgcat.nebcatfield[rc3-BaseNeb,2]:=5;
catalog.cfgcat.nebcatpath[pgc-BaseNeb]:=slash(appdir)+'cat'+PathDelim+'pgc';
catalog.cfgcat.nebcatfield[pgc-BaseNeb,2]:=5;
catalog.cfgcat.nebcatpath[ocl-BaseNeb]:=slash(appdir)+'cat'+PathDelim+'ocl';
catalog.cfgcat.nebcatfield[ocl-BaseNeb,2]:=5;
catalog.cfgcat.nebcatpath[gcm-BaseNeb]:=slash(appdir)+'cat'+PathDelim+'gcm';
catalog.cfgcat.nebcatfield[gcm-BaseNeb,2]:=5;
catalog.cfgcat.nebcatpath[gpn-BaseNeb]:=slash(appdir)+'cat'+PathDelim+'gpn';
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
catalog.cfgshr.DegreeGridSpacing[0]:=1000+5/60;
catalog.cfgshr.DegreeGridSpacing[1]:=1000+10/60;
catalog.cfgshr.DegreeGridSpacing[2]:=1000+20/60;
catalog.cfgshr.DegreeGridSpacing[3]:=1000+30/60;
catalog.cfgshr.DegreeGridSpacing[4]:=1000+1;
catalog.cfgshr.DegreeGridSpacing[5]:=1000+2;
catalog.cfgshr.DegreeGridSpacing[6]:=1000+5;
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
catalog.cfgshr.NebMagFilter[4]:=99;
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
var i:integer;
    inif: TMemIniFile;
    section,buf : string;
begin
inif:=TMeminifile.create(filename);
try
with inif do begin
section:='main';
try
if resizemain then begin
  f_main.Top := ReadInteger(section,'WinTop',f_main.Top);
  f_main.Left := ReadInteger(section,'WinLeft',f_main.Left);
  f_main.Width := ReadInteger(section,'WinWidth',f_main.Width);
  f_main.Height := ReadInteger(section,'WinHeight',f_main.Height);
  if f_main.Width>screen.Width then f_main.Width:=screen.Width;
  if f_main.Height>(screen.Height-25) then f_main.Height:=screen.Height-25;
  formpos(f_main,f_main.Left,f_main.Top);
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
catalog.cfgcat.GCatNum:=Readinteger(section,'GCatNum',1);
SetLength(catalog.cfgcat.GCatLst,catalog.cfgcat.GCatNum);
for i:=0 to catalog.cfgcat.GCatNum-1 do begin
   catalog.cfgcat.GCatLst[i].shortname:=Readstring(section,'CatName'+inttostr(i),catalog.cfgcat.GCatLst[i].shortname);
   catalog.cfgcat.GCatLst[i].name:=Readstring(section,'CatLongName'+inttostr(i),catalog.cfgcat.GCatLst[i].name);
   catalog.cfgcat.GCatLst[i].path:=Readstring(section,'CatPath'+inttostr(i),catalog.cfgcat.GCatLst[i].path);
   catalog.cfgcat.GCatLst[i].min:=ReadFloat(section,'CatMin'+inttostr(i),catalog.cfgcat.GCatLst[i].min);
   catalog.cfgcat.GCatLst[i].max:=ReadFloat(section,'CatMax'+inttostr(i),catalog.cfgcat.GCatLst[i].max);
   catalog.cfgcat.GCatLst[i].Actif:=ReadBool(section,'CatActif'+inttostr(i),catalog.cfgcat.GCatLst[i].Actif);
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
except
  ShowError('Error reading '+filename+' chart catalog');
end;
end;
try
section:='display';
cplot.starplot:=ReadInteger(section,'starplot',cplot.starplot);
cplot.nebplot:=ReadInteger(section,'nebplot',cplot.nebplot);
cplot.TransparentPlanet:=ReadBool(section,'TransparentPlanet',cplot.TransparentPlanet);
cplot.plaplot:=ReadInteger(section,'plaplot',cplot.plaplot);
cplot.Nebgray:=ReadInteger(section,'Nebgray',cplot.Nebgray);
cplot.NebBright:=ReadInteger(section,'NebBright',cplot.NebBright);
cplot.contrast:=ReadInteger(section,'contrast',cplot.contrast);
cplot.saturation:=ReadInteger(section,'saturation',cplot.saturation);
cplot.red_move:=ReadBool(section,'redmove',cplot.red_move);
cplot.partsize:=ReadFloat(section,'partsize',cplot.partsize);
cplot.magsize:=ReadFloat(section,'magsize',cplot.magsize);
cplot.AutoSkycolor:=ReadBool(section,'AutoSkycolor',cplot.AutoSkycolor);
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
for i:=0 to maxfield do catalog.cfgshr.DegreeGridSpacing[i]:=ReadFloat(section,'DegreeGridSpacing'+inttostr(i),catalog.cfgshr.DegreeGridSpacing[i] );
except
  ShowError('Error reading '+filename+' grid');
end;
try
section:='Finder';
csc.ShowCircle:=ReadBool(section,'ShowCircle',csc.ShowCircle);
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
csc.theta:=ReadFloat(section,'theta',csc.theta);
buf:=trim(ReadString(section,'projtype',csc.projtype))+'A';
csc.projtype:=buf[1];
csc.ProjPole:=ReadInteger(section,'ProjPole',csc.ProjPole);
csc.FlipX:=ReadInteger(section,'FlipX',csc.FlipX);
csc.FlipY:=ReadInteger(section,'FlipY',csc.FlipY);
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
csc.ShowGrid:=ReadBool(section,'ShowGrid',csc.ShowGrid);
csc.ShowGridNum:=ReadBool(section,'ShowGridNum',csc.ShowGridNum);
csc.ShowConstL:=ReadBool(section,'ShowConstL',csc.ShowConstL);
csc.ShowConstB:=ReadBool(section,'ShowConstB',csc.ShowConstB);
csc.ShowEcliptic:=ReadBool(section,'ShowEcliptic',csc.ShowEcliptic);
csc.ShowGalactic:=ReadBool(section,'ShowGalactic',csc.ShowGalactic); 
csc.ShowMilkyWay:=ReadBool(section,'ShowMilkyWay',csc.ShowMilkyWay);
csc.FillMilkyWay:=ReadBool(section,'FillMilkyWay',csc.FillMilkyWay);
csc.ShowPluto:=ReadBool(section,'ShowPluto',csc.ShowPluto);
csc.ShowPlanet:=ReadBool(section,'ShowPlanet',csc.ShowPlanet);
csc.ShowAsteroid:=ReadBool(section,'ShowAsteroid',csc.ShowAsteroid);
csc.ShowComet:=ReadBool(section,'ShowComet',csc.ShowComet);
csc.ShowImages:=ReadBool(section,'ShowImages',csc.ShowImages);
csc.showstars:=ReadBool(section,'ShowStars',csc.showstars);
csc.shownebulae:=ReadBool(section,'ShowNebulae',csc.shownebulae);
csc.showline:=ReadBool(section,'ShowLine',csc.showline);
csc.ShowBackgroundImage:=ReadBool(section,'ShowBackgroundImage',csc.ShowBackgroundImage);
csc.BackgroundImage:=ReadString(section,'BackgroundImage',csc.BackgroundImage);
csc.AstSymbol:=ReadInteger(section,'AstSymbol',csc.AstSymbol);
csc.AstmagMax:=ReadFloat(section,'AstmagMax',csc.AstmagMax);
csc.AstmagDiff:=ReadFloat(section,'AstmagDiff',csc.AstmagDiff);
csc.ComSymbol:=ReadInteger(section,'ComSymbol',csc.ComSymbol);
csc.CommagMax:=ReadFloat(section,'CommagMax',csc.CommagMax);
csc.CommagDiff:=ReadFloat(section,'CommagDiff',csc.CommagDiff);
csc.MagLabel:=ReadBool(section,'MagLabel',csc.MagLabel);
csc.NameLabel:=ReadBool(section,'NameLabel',csc.NameLabel);
csc.DrawAllStarLabel:=ReadBool(section,'DrawAllStarLabel',csc.DrawAllStarLabel);
csc.ConstFullLabel:=ReadBool(section,'ConstFullLabel',csc.ConstFullLabel);
csc.ConstLatinLabel:=ReadBool(section,'ConstLatinLabel',csc.ConstLatinLabel);
csc.PlanetParalaxe:=ReadBool(section,'PlanetParalaxe',csc.PlanetParalaxe);
csc.ShowEarthShadow:=ReadBool(section,'ShowEarthShadow',csc.ShowEarthShadow);
csc.GRSlongitude:=ReadFloat(section,'GRSlongitude',csc.GRSlongitude);
csc.StyleGrid:=TPenStyle(ReadInteger(section,'StyleGrid',ord(csc.StyleGrid)));
csc.StyleEqGrid:=TPenStyle(ReadInteger(section,'StyleEqGrid',ord(csc.StyleEqGrid)));
csc.StyleConstL:=TPenStyle(ReadInteger(section,'StyleConstL',ord(csc.StyleConstL)));
csc.StyleConstB:=TPenStyle(ReadInteger(section,'StyleConstB',ord(csc.StyleConstB)));
csc.StyleEcliptic:=TPenStyle(ReadInteger(section,'StyleEcliptic',ord(csc.StyleEcliptic)));
csc.StyleGalEq:=TPenStyle(ReadInteger(section,'StyleGalEq',ord(csc.StyleGalEq)));
csc.Simnb:=ReadInteger(section,'Simnb',csc.Simnb);
csc.SimLabel:=ReadInteger(section,'SimLabel',csc.SimLabel);
csc.SimNameLabel:=ReadBool(section,'SimNameLabel',csc.SimNameLabel);
csc.SimDateLabel:=ReadBool(section,'SimDateLabel',csc.SimDateLabel);
csc.SimDateYear:=ReadBool(section,'SimDateYear',csc.SimDateYear);
csc.SimDateMonth:=ReadBool(section,'SimDateMonth',csc.SimDateMonth);
csc.SimDateDay:=ReadBool(section,'SimDateDay',csc.SimDateDay);
csc.SimDateHour:=ReadBool(section,'SimDateHour',csc.SimDateHour);
csc.SimDateMinute:=ReadBool(section,'SimDateMinute',csc.SimDateMinute);
csc.SimDateSecond:=ReadBool(section,'SimDateSecond',csc.SimDateSecond);
csc.SimMagLabel:=ReadBool(section,'SimMagLabel',csc.SimMagLabel);
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
   csc.modlabels[i].labelnum:=ReadInteger(section,'labelnum'+inttostr(i),1);
   csc.modlabels[i].fontnum:=ReadInteger(section,'labelfont'+inttostr(i),2);
   csc.modlabels[i].txt:=ReadString(section,'labeltxt'+inttostr(i),'');
   csc.modlabels[i].align:=TLabelAlign(ReadInteger(section,'labelalign'+inttostr(i),ord(laLeft)));
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
    section : string;
begin
inif:=TMeminifile.create(filename);
try
with inif do begin
section:='main';
try
Config_Version:=ReadString(section,'version','0');
SaveConfigOnExit.Checked:=ReadBool(section,'SaveConfigOnExit',SaveConfigOnExit.Checked);
{$ifdef linux}
LinuxDesktop:=ReadInteger(section,'LinuxDesktop',LinuxDesktop);
OpenFileCMD:=ReadString(section,'OpenFileCMD',OpenFileCMD);
{$endif}
{$ifdef win32}
use_xplanet:=ReadBool(section,'use_xplanet',use_xplanet);
xplanet_dir:=ReadString(section,'xplanet_dir',xplanet_dir);
{$endif}
NightVision:=ReadBool(section,'NightVision',NightVision);
cfgm.prtname:=ReadString(section,'prtname',cfgm.prtname);
cfgm.Paper:=ReadInteger(section,'Paper',cfgm.Paper);
cfgm.PrinterResolution:=ReadInteger(section,'PrinterResolution',cfgm.PrinterResolution);
cfgm.PrintColor:=ReadInteger(section,'PrintColor',cfgm.PrintColor);
cfgm.PrintLandscape:=ReadBool(section,'PrintLandscape',cfgm.PrintLandscape);
cfgm.PrintMethod:=ReadInteger(section,'PrintMethod',cfgm.PrintMethod);
cfgm.PrintCmd1:=ReadString(section,'PrintCmd1',cfgm.PrintCmd1);
cfgm.PrintCmd2:=ReadString(section,'PrintCmd2',cfgm.PrintCmd2);
cfgm.PrtLeftMargin:=ReadInteger(section,'PrtLeftMargin',cfgm.PrtLeftMargin);
cfgm.PrtRightMargin:=ReadInteger(section,'PrtRightMargin',cfgm.PrtRightMargin);
cfgm.PrtTopMargin:=ReadInteger(section,'PrtTopMargin',cfgm.PrtTopMargin);
cfgm.PrtBottomMargin:=ReadInteger(section,'PrtBottomMargin',cfgm.PrtBottomMargin);
cfgm.ThemeName:=ReadString(section,'Theme',cfgm.ThemeName);
if (ReadBool(section,'WinMaximize',true)) then f_main.WindowState:=wsMaximized;
cfgm.autorefreshdelay:=ReadInteger(section,'autorefreshdelay',cfgm.autorefreshdelay);
cfgm.ConstLfile:=ReadString(section,'ConstLfile',cfgm.ConstLfile);
cfgm.ConstBfile:=ReadString(section,'ConstBfile',cfgm.ConstBfile);
cfgm.EarthMapFile:=ReadString(section,'EarthMapFile',cfgm.EarthMapFile);
cfgm.PlanetDir:=ReadString(section,'PlanetDir',cfgm.PlanetDir);
cfgm.horizonfile:=ReadString(section,'horizonfile',cfgm.horizonfile);
cfgm.ServerIPaddr:=ReadString(section,'ServerIPaddr',cfgm.ServerIPaddr);
cfgm.ServerIPport:=ReadString(section,'ServerIPport',cfgm.ServerIPport);
cfgm.IndiPanelCmd:=ReadString(section,'IndiPanelCmd',cfgm.IndiPanelCmd);
cfgm.keepalive:=ReadBool(section,'keepalive',cfgm.keepalive);
cfgm.AutostartServer:=ReadBool(section,'AutostartServer',cfgm.AutostartServer);
DBtype:=TDBtype(ReadInteger(section,'dbtype',1));
cfgm.dbhost:=ReadString(section,'dbhost',cfgm.dbhost);
cfgm.dbport:=ReadInteger(section,'dbport',cfgm.dbport);
cfgm.db:=ReadString(section,'db',cfgm.db);
cfgm.dbuser:=ReadString(section,'dbuser',cfgm.dbuser);
cryptedpwd:=hextostr(ReadString(section,'dbpass',cfgm.dbpass));
cfgm.dbpass:=DecryptStr(cryptedpwd,encryptpwd);
cfgm.ImagePath:=ReadString(section,'ImagePath',cfgm.ImagePath);
cfgm.ImageLuminosity:=ReadFloat(section,'ImageLuminosity',cfgm.ImageLuminosity);
cfgm.ImageContrast:=ReadFloat(section,'ImageContrast',cfgm.ImageContrast);
cfgm.ShowChartInfo:=ReadBool(section,'ShowChartInfo',cfgm.ShowChartInfo);
cfgm.SyncChart:=ReadBool(section,'SyncChart',cfgm.SyncChart);
cfgm.ButtonStandard:=ReadInteger(section,'ButtonStandard',cfgm.ButtonStandard);
cfgm.ButtonNight:=ReadInteger(section,'ButtonNight',cfgm.ButtonNight);
cfgm.HttpProxy:=ReadBool(section,'HttpProxy',cfgm.HttpProxy);
cfgm.FtpPassive:=ReadBool(section,'FtpPassive',cfgm.FtpPassive);
cfgm.ConfirmDownload:=ReadBool(section,'ConfirmDownload',cfgm.ConfirmDownload);
cfgm.ProxyHost:=ReadString(section,'ProxyHost',cfgm.ProxyHost);
cfgm.ProxyPort:=ReadString(section,'ProxyPort',cfgm.ProxyPort);
cfgm.ProxyUser:=ReadString(section,'ProxyUser',cfgm.ProxyUser);
cfgm.ProxyPass:=ReadString(section,'ProxyPass',cfgm.ProxyPass);
cfgm.AnonPass:=ReadString(section,'AnonPass',cfgm.AnonPass);
j:=ReadInteger(section,'CometUrlCount',0);
if j>0 then begin
   cfgm.CometUrlList.Clear;
   for i:=1 to j do cfgm.CometUrlList.Add(ReadString(section,'CometUrl'+inttostr(i),''));
end;
j:=ReadInteger(section,'AsteroidUrlCount',0);
if j>0 then begin
   cfgm.AsteroidUrlList.Clear;
   for i:=1 to j do cfgm.AsteroidUrlList.Add(ReadString(section,'AsteroidUrl'+inttostr(i),''));
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
def_cfgsc.PluginTelescope:=ReadBool(section,'PluginTelescope',def_cfgsc.PluginTelescope);
def_cfgsc.ManualTelescope:=ReadBool(section,'ManualTelescope',def_cfgsc.ManualTelescope);
def_cfgsc.ManualTelescopeType:=ReadInteger(section,'ManualTelescopeType',def_cfgsc.ManualTelescopeType);
def_cfgsc.TelescopeTurnsX:=ReadFloat(section,'TelescopeTurnsX',def_cfgsc.TelescopeTurnsX);
def_cfgsc.TelescopeTurnsY:=ReadFloat(section,'TelescopeTurnsY',def_cfgsc.TelescopeTurnsY);
TelescopePanel.visible:=def_cfgsc.IndiTelescope;
def_cfgsc.ScopePlugin:=ReadString(section,'ScopePlugin',def_cfgsc.ScopePlugin);
toolbar1.visible:=ReadBool(section,'ViewMainBar',true);
PanelLeft.visible:=ReadBool(section,'ViewLeftBar',true);
PanelRight.visible:=ReadBool(section,'ViewRightBar',true);
toolbar4.visible:=ReadBool(section,'ViewObjectBar',true);
ViewScrollBar1.Checked:=ReadBool(section,'ViewScrollBar',true);
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
f_getdss.cfgdss.dssfile:=slash(privatedir)+slash('pictures')+'$temp.fit';
for i:=1 to MaxDSSurl do begin
  f_getdss.cfgdss.DSSurl[i,0]:=ReadString(section,'DSSurlName'+inttostr(i),f_getdss.cfgdss.DSSurl[i,0]);
  f_getdss.cfgdss.DSSurl[i,1]:=ReadString(section,'DSSurl'+inttostr(i),f_getdss.cfgdss.DSSurl[i,1]);
end;
f_getdss.cfgdss.OnlineDSS:=ReadBool(section,'OnlineDSS',f_getdss.cfgdss.OnlineDSS);
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
begin
if Config_Version < '3.0.0.7' then begin
   def_cfgplot.color[22]:=DFcolor[22];
   catalog.cfgshr.BigNebLimit:=211;
   catalog.cfgshr.NebMagFilter[4]:=99;
   SaveDefault;
end;
if Config_Version < '3.0.0.8' then begin
   cfgm.dbpass:=cryptedpwd;
   SaveDefault;
end;
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
SavePrivateConfig(configfile,true);
SaveQuickSearch(configfile);
if (MultiDoc1.ActiveObject is Tf_chart) then begin
   SaveChartConfig(configfile,MultiDoc1.ActiveChild);
end;
j:=0;
for i:=0 to MultiDoc1.ChildCount-1 do
  if (MultiDoc1.Childs[i].DockedObject is Tf_chart) and (MultiDoc1.Childs[i].DockedObject<>MultiDoc1.ActiveObject) then begin
     inc(j);
     SaveChartConfig(configfile+inttostr(j),MultiDoc1.Childs[i]);
  end;
except
end;
end;

procedure Tf_main.SaveChartConfig(filename:string; child: TChildDoc);
var i:integer;
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
WriteInteger(section,'starplot',cplot.starplot);
WriteInteger(section,'nebplot',cplot.nebplot);
WriteInteger(section,'plaplot',cplot.plaplot);
WriteBool(section,'TransparentPlanet',cplot.TransparentPlanet);
WriteInteger(section,'Nebgray',cplot.Nebgray);
WriteInteger(section,'NebBright',cplot.NebBright);
WriteInteger(section,'contrast',cplot.contrast);
WriteInteger(section,'saturation',cplot.saturation);
WriteBool(section,'redmove',cplot.red_move);
WriteFloat(section,'partsize',cplot.partsize);
WriteFloat(section,'magsize',cplot.magsize);
WriteBool(section,'AutoSkycolor',cplot.AutoSkycolor);
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
WriteBool(section,'ShowGrid',csc.ShowGrid);
WriteBool(section,'ShowGridNum',csc.ShowGridNum);
WriteBool(section,'ShowConstL',csc.ShowConstL);
WriteBool(section,'ShowConstB',csc.ShowConstB);
WriteBool(section,'ShowEcliptic',csc.ShowEcliptic);   
WriteBool(section,'ShowGalactic',csc.ShowGalactic);
WriteBool(section,'ShowMilkyWay',csc.ShowMilkyWay);
WriteBool(section,'FillMilkyWay',csc.FillMilkyWay);
WriteBool(section,'ShowPluto',csc.ShowPluto);
WriteBool(section,'ShowPlanet',csc.ShowPlanet);
WriteBool(section,'ShowAsteroid',csc.ShowAsteroid);
WriteBool(section,'ShowComet',csc.ShowComet);
WriteBool(section,'ShowImages',csc.ShowImages);
WriteBool(section,'ShowStars',csc.showstars);
WriteBool(section,'ShowNebulae',csc.shownebulae);
WriteBool(section,'ShowLine',csc.showline);
WriteBool(section,'ShowBackgroundImage',csc.ShowBackgroundImage);
WriteString(section,'BackgroundImage',csc.BackgroundImage);
WriteInteger(section,'AstSymbol',csc.AstSymbol);
WriteFloat(section,'AstmagMax',csc.AstmagMax);
WriteFloat(section,'AstmagDiff',csc.AstmagDiff);
WriteInteger(section,'ComSymbol',csc.ComSymbol);
WriteFloat(section,'CommagMax',csc.CommagMax);
WriteFloat(section,'CommagDiff',csc.CommagDiff);
WriteBool(section,'MagLabel',csc.MagLabel);
WriteBool(section,'NameLabel',csc.NameLabel);
WriteBool(section,'DrawAllStarLabel',csc.DrawAllStarLabel);
WriteBool(section,'ConstFullLabel',csc.ConstFullLabel);
WriteBool(section,'ConstLatinLabel',csc.ConstLatinLabel);
WriteBool(section,'PlanetParalaxe',csc.PlanetParalaxe);
WriteBool(section,'ShowEarthShadow',csc.ShowEarthShadow);
WriteFloat(section,'GRSlongitude',csc.GRSlongitude);
WriteInteger(section,'StyleGrid',ord(csc.StyleGrid));
WriteInteger(section,'StyleEqGrid',ord(csc.StyleEqGrid));
WriteInteger(section,'StyleConstL',ord(csc.StyleConstL));
WriteInteger(section,'StyleConstB',ord(csc.StyleConstB));
WriteInteger(section,'StyleEcliptic',ord(csc.StyleEcliptic));
WriteInteger(section,'StyleGalEq',ord(csc.StyleGalEq));
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
   WriteInteger(section,'labelnum'+inttostr(i),csc.modlabels[i].labelnum);
   WriteInteger(section,'labelfont'+inttostr(i),csc.modlabels[i].fontnum);
   WriteString(section,'labeltxt'+inttostr(i),csc.modlabels[i].txt);
   WriteInteger(section,'labelalign'+inttostr(i),ord(csc.modlabels[i].align));
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

procedure Tf_main.SavePrivateConfig(filename:string; purge: boolean=false);
var i,j:integer;
    inif: TMemIniFile;
    section : string;
begin
try
inif:=TMeminifile.create(filename);
try
with inif do begin
if purge then Clear;
section:='main';
WriteString(section,'version',cdcver);
WriteString(section,'AppDir',appdir);
WriteString(section,'PrivateDir',privatedir);
{$ifdef linux}
WriteInteger(section,'LinuxDesktop',LinuxDesktop);
WriteString(section,'OpenFileCMD',OpenFileCMD);
{$endif}
{$ifdef win32}
WriteBool(section,'use_xplanet',use_xplanet);
WriteString(section,'xplanet_dir',xplanet_dir);
{$endif}
WriteBool(section,'SaveConfigOnExit',SaveConfigOnExit.Checked);
WriteBool(section,'NightVision',NightVision);
WriteString(section,'language',cfgm.language);
WriteString(section,'prtname',cfgm.prtname);
WriteInteger(section,'Paper',cfgm.Paper);
WriteInteger(section,'PrinterResolution',cfgm.PrinterResolution);
WriteInteger(section,'PrintColor',cfgm.PrintColor);
WriteBool(section,'PrintLandscape',cfgm.PrintLandscape);
WriteInteger(section,'PrintMethod',cfgm.PrintMethod);
WriteString(section,'PrintCmd1',cfgm.PrintCmd1);
WriteString(section,'PrintCmd2',cfgm.PrintCmd2);
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
WriteBool(section,'AutostartServer',cfgm.AutostartServer);
WriteInteger(section,'dbtype',ord(DBtype));
WriteString(section,'dbhost',cfgm.dbhost);
WriteInteger(section,'dbport',cfgm.dbport);
WriteString(section,'db',cfgm.db);
WriteString(section,'dbuser',cfgm.dbuser);
WriteString(section,'dbpass',strtohex(encryptStr(cfgm.dbpass,encryptpwd)));
WriteString(section,'ImagePath',cfgm.ImagePath);
WriteFloat(section,'ImageLuminosity',cfgm.ImageLuminosity);
WriteFloat(section,'ImageContrast',cfgm.ImageContrast);
WriteBool(section,'ShowChartInfo',cfgm.ShowChartInfo);
WriteBool(section,'SyncChart',cfgm.SyncChart);
WriteInteger(section,'ButtonStandard',cfgm.ButtonStandard);
WriteInteger(section,'ButtonNight',cfgm.ButtonNight);
WriteBool(section,'HttpProxy',cfgm.HttpProxy);
WriteBool(section,'FtpPassive',cfgm.FtpPassive);
WriteBool(section,'ConfirmDownload',cfgm.ConfirmDownload);
WriteString(section,'ProxyHost',cfgm.ProxyHost);
WriteString(section,'ProxyPort',cfgm.ProxyPort);
WriteString(section,'ProxyUser',cfgm.ProxyUser);
WriteString(section,'ProxyPass',cfgm.ProxyPass);
WriteString(section,'AnonPass',cfgm.AnonPass);
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
WriteBool(section,'IndiAutostart',def_cfgsc.IndiAutostart);
WriteString(section,'IndiServerHost',def_cfgsc.IndiServerHost);
WriteString(section,'IndiServerPort',def_cfgsc.IndiServerPort);
WriteString(section,'IndiServerCmd',def_cfgsc.IndiServerCmd);
WriteString(section,'IndiDriver',def_cfgsc.IndiDriver);
WriteString(section,'IndiPort',def_cfgsc.IndiPort);
WriteString(section,'IndiDevice',def_cfgsc.IndiDevice);
WriteBool(section,'IndiTelescope',def_cfgsc.IndiTelescope);
WriteBool(section,'PluginTelescope',def_cfgsc.PluginTelescope);
WriteBool(section,'ManualTelescope',def_cfgsc.ManualTelescope);
WriteInteger(section,'ManualTelescopeType',def_cfgsc.ManualTelescopeType);
WriteFloat(section,'TelescopeTurnsX',def_cfgsc.TelescopeTurnsX);
WriteFloat(section,'TelescopeTurnsY',def_cfgsc.TelescopeTurnsY);
WriteString(section,'ScopePlugin',def_cfgsc.ScopePlugin);
WriteBool(section,'ViewMainBar',toolbar1.visible);
WriteBool(section,'ViewLeftBar',PanelLeft.visible);
WriteBool(section,'ViewRightBar',PanelRight.visible);
WriteBool(section,'ViewObjectBar',toolbar4.visible);
WriteBool(section,'ViewScrollBar',ViewScrollBar1.Checked);
WriteBool(section,'ViewStatusBar',ViewStatusBar1.Checked);
WriteInteger(section,'NumChart',MultiDoc1.ChildCount);
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
    {$ifdef win32}
    instini: TIniFile;
    {$endif}
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
for i:=0 to MultiDoc1.ChildCount-1 do
  if MultiDoc1.Childs[i].DockedObject is Tf_chart then
     Tf_chart(MultiDoc1.Childs[i].DockedObject).SetLang;
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
SetupConfig.Caption:=rsAllConfigura;
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
MenuSearch.Caption:=rsAdvancedSear;
ToolButtonPosition.hint:=rsPosition;
MenuPosition.Caption:=rsPosition;
ToolButtonListObj.hint:=rsObjectList;
MenuListObj.Caption:=rsObjectList;
ToolButtonCal.hint:=rsEphemerisCal;
ToolButtonTdec.hint:=rsDecrementTim;
ToolButtonTnow.hint:=rsNow;
ToolButtonTinc.hint:=rsIncrementTim;
TConnect.hint:=rsConnectTeles;
TSlew.hint:=rsSlew;
TSync.hint:=rsSync;
ToolButtonShowStars.hint:=rsShowStars;
ToolButtonShowNebulae.hint:=rsShowNebulae;
ToolButtonShowLines.hint:=rsShowLines;
ToolButtonShowPictures.hint:=rsShowPictures;
ToolButtonBlink.hint:=rsBlinkingPict;
menublinkimage.Caption:=rsBlinkingPict;
ToolButtonDSS.hint:=rsGetDSSImage;
MenuDSS.Caption:=rsGetDSSImage;
ToolButtonShowBackgroundImage.hint:=rsChangePictur;
ToolButtonShowPlanets.hint:=rsShowPlanets;
ToolButtonShowAsteroids.hint:=rsShowAsteroid;
ToolButtonShowComets.hint:=rsShowComets;
ToolButtonShowMilkyWay.hint:=rsShowMilkyWay;
ToolButtonGrid.hint:=rsShowCoordina;
ToolButtonGridEq.hint:=rsAddEquatoria;
ToolButtonShowConstellationLine.hint:=rsShowConstell;
ToolButtonShowConstellationLimit.hint:=rsShowConstell2;
ToolButtonShowGalacticEquator.hint:=rsShowGalactic;
ToolButtonShowEcliptic.hint:=rsShowEcliptic;
ToolButtonShowMark.hint:=rsShowMark;
ToolButtonShowLabels.hint:=rsShowLabels;
ToolButtonEditlabels.hint:=rsEditLabel;
MenuEditlabels.Caption:=rsEditLabel;
ToolButtonShowObjectbelowHorizon.hint:=rsShowObjectBe;
ToolButtonswitchbackground.hint:=rsSkyBackgroun;
Menuswitchbackground.caption:=rsSkyBackgroun;
ToolButtonSyncChart.hint:=rsLinkAllChart;
MenuSyncChart.Caption:=rsLinkAllChart;
MenuSyncChart.hint:=rsLinkAllChart;
ToolButtonTrack.hint:=rsNoObjectToLo;
MenuTrack.Caption:=rsNoObjectToLo;
ToolButtonswitchstars.hint:=rsChangeDrawin;
File1.caption:=rsFile;
FileNewItem.caption:=rsNewChart;
FileOpenItem.caption:=rsOpen;
FileSaveAsItem.caption:=rsSaveAs;
SaveImage1.caption:=rsSaveImage;
FileCloseItem.caption:=rsCloseChart;
Calendar1.caption:=rsCalendar;
VariableStar1.Caption:=rsVariableStar2;
Print2.caption:=rsPrint;
PrintSetup2.caption:=rsPrinterSetup;
FileExitItem.caption:=rsExit;
Edit1.caption:=rsEdit;
CopyItem.caption:=rsCopy;
Undo1.caption:=rsUndo;
Redo1.caption:=rsRedo;
Setup1.caption:=rsSetup;
SaveConfiguration.caption:=rsSaveConfigur;
SaveConfigOnExit.caption:=rsSaveConfigur2;
SetupTime.caption:=rsDateTime;
SetupObservatory.caption:=rsObservatory;
SetupDisplay.caption:=rsDisplay;
SetupChart.caption:=rsChartCoordin;
SetupSolSys.caption:=rsSolarSystem;
SetupSystem.caption:=rsSystem;
SetupInternet.caption:=rsInternet;
SetupPictures.caption:=rsPictures;
SetupCatalog.caption:=rsCatalog;
MenuItem8.caption:=rsShowHideDSSI;
View1.caption:=rsView;
FullScreen1.caption:=rsFullScreen;
NightVision1.caption:=rsNightVision;
oolBar1.caption:=rsToolBar;
ViewToolsBar1.caption:=rsAllToolsBar;
MainBar1.caption:=rsMainBar;
ObjectBar1.caption:=rsObjectBar;
LeftBar1.caption:=rsLeftBar;
RightBar1.caption:=rsRightBar;
ViewStatusBar1.caption:=rsStatusBar;
ViewScrollBar1.caption:=rsScrollBar;
ViewInformation1.caption:=rsServerInform;
zoomplus1.caption:=rsZoomIn;
zoomminus1.caption:=rsZoomOut;
zoommenu.Caption:=rsSetFOV;
Chart1.caption:=rsChart;
Projection1.caption:=rsChartCoordin2;
EquatorialCoordinate1.caption:=rsEquatorialCo;
AltAzProjection1.caption:=rsAltAzCoordin;
EclipticProjection1.caption:=rsEclipticCoor;
GalacticProjection1.caption:=rsGalacticCoor;
ransformation1.caption:=rsTransformati;
FlipX1.caption:=rsMirrorHorizo;
FlipY1.caption:=rsMirrorVertic;
rotplus1.caption:=rsRotateRight;
rotminus1.caption:=rsRotateLeft;
FieldofVision1.caption:=rsFieldOfVisio;
allSky1.caption:=rsShowAllSky;
ShowHorizon1.caption:=rsViewHorizon;
toN1.caption:=rsNorth;
toS1.caption:=rsSouth;
toE1.caption:=rsEast;
toW1.caption:=rsWest;
ShowObjects1.caption:=rsShowObjects;
ShowStars1.caption:=rsShowStars;
ShowNebulae1.caption:=rsShowNebulae;
ShowPictures1.caption:=rsShowPictures;
ShowLines1.caption:=rsShowLines;
ShowPlanets1.caption:=rsShowPlanets;
ShowAsteroids1.caption:=rsShowAsteroid;
ShowComets1.caption:=rsShowComets;
ShowMilkyWay1.caption:=rsShowMilkyWay;
ShowGrid1.caption:=rsLinesGrid;
Grid1.caption:=rsShowCoordina;
GridEQ1.caption:=rsAddEquatoria;
ShowConstellationLine1.caption:=rsShowConstell;
ShowConstellationLimit1.caption:=rsShowConstell2;
ShowGalacticEquator1.caption:=rsShowGalactic;
ShowEcliptic1.caption:=rsShowEcliptic;
ShowMark1.caption:=rsShowMark;
ShowLabels1.caption:=rsShowLabels;
ShowObjectbelowthehorizon1.caption:=rsBelowTheHori;
telescope1.caption:=rsTelescope;
telescopeConnect1.caption:=rsConnect;
ControlPanel1.caption:=rsControlPanel;
telescopeSlew1.caption:=rsSlew;
telescopeSync1.caption:=rsSync;
Window1.caption:=rsWindow;
WindowCascadeItem.caption:=rsCascade;
WindowTileItem.caption:=rsTileHorizont;
WindowTileItem2.caption:=rsTileVertical;
Maximize1.caption:=rsMaximize;
Help1.caption:=rsHelp;
Content1.caption:=rsHelpContents;
HomePage1.caption:=rsSkychartHome;
Maillist1.caption:=rsMailList;
BugReport1.caption:=rsReportAProbl;
HelpAboutItem.caption:=rsAbout;
ReleaseNotes1.Caption:=rsReleaseNotes;
ButtonMoreStar.Hint:=rsMoreStars;
ButtonLessStar.Hint:=rsLessStars;
ButtonMoreNeb.Hint:=rsMoreNebulae;
ButtonLessNeb.Hint:=rsLessNebulae;
MenuMoreStar.Caption:=rsMoreStars;
MenuLessStar.Caption:=rsLessStars;
MenuMoreNeb.Caption:=rsMoreNebulae;
MenuLessNeb.Caption:=rsLessNebulae;
MenuStarNum.Caption:=rsNumberOfStar;
MenuNebNum.Caption:=rsNumberOfNebu;
ResetAllLabels1.caption:=rsResetAllLabe;
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
    ar1,de1 : Double;
    i : integer;
    chart:TForm;
    stype: string;
label findit;
begin
result:=false;
if trim(num)='' then exit;
chart:=nil;
stype:='';
if cname='' then begin
  if MultiDoc1.ActiveObject is Tf_chart then chart:=MultiDoc1.ActiveObject;
end else begin
 for i:=0 to MultiDoc1.ChildCount-1 do
   if MultiDoc1.Childs[i].DockedObject is Tf_chart then
      if MultiDoc1.Childs[i].caption=cname then chart:=MultiDoc1.Childs[i].DockedObject;
end;
if chart is Tf_chart then with chart as Tf_chart do begin
   stype:='N';
   ok:=catalog.SearchNebulae(Num,ar1,de1) ;
   if ok then goto findit;
   stype:='V*';
   ok:=catalog.SearchVarStar(Num,ar1,de1) ;
   if ok then goto findit;
   stype:='D*';
   ok:=catalog.SearchDblStar(Num,ar1,de1) ;
   if ok then goto findit;
   stype:='*';
   ok:=catalog.SearchStar(Num,ar1,de1) ;
   if ok then goto findit;
   stype:='P';
   ok:=planet.FindPlanetName(trim(Num),ar1,de1,sc.cfgsc);
   if ok then goto findit;
   stype:='As';
   ok:=planet.FindAsteroidName(trim(Num),ar1,de1,sc.cfgsc);
   if ok then goto findit;
   stype:='Cm';
   ok:=planet.FindCometName(trim(Num),ar1,de1,sc.cfgsc);
   if ok then goto findit;
   stype:='*';
   ok:=catalog.SearchStarName(Num,ar1,de1) ;
   if ok then goto findit;
   stype:='N';
   ok:=f_search.SearchNebName(Num,ar1,de1) ;
   if ok then goto findit;

Findit:
   result:=ok;
   if ok then begin
      sc.cfgsc.TrackOn:=false;
      IdentLabel.visible:=false;
      precession(jd2000,sc.cfgsc.JDchart,ar1,de1);
      if sc.cfgsc.ApparentPos then apparent_equatorial(ar1,de1,sc.cfgsc);
      sc.movetoradec(ar1,de1);
      Refresh;
      if sc.cfgsc.fov>0.17 then ok:=sc.FindatRaDec(ar1,de1,0.0005,true)
                        else ok:=sc.FindatRaDec(ar1,de1,0.00005,true);
      if not ok then begin  // object not visible with current chart setting
        sc.cfgsc.FindName:=Num;
        sc.cfgsc.FindDesc:=ARpToStr(rmod(rad2deg*ar1/15+24, 24))+tab+DEpToStr(rad2deg*de1)+tab+stype+tab+Num+tab+''+rsNonVisibleSe+'';
        sc.cfgsc.FindRA:=ar1;
        sc.cfgsc.FindDec:=de1;
        sc.cfgsc.FindSize:=0;
        sc.cfgsc.FindPM:=false;
        sc.cfgsc.FindOK:=true;
      end;
      ShowIdentLabel;
      f_main.SetLpanel1(wordspace(sc.cfgsc.FindDesc),caption);
   end;
end;
end;

procedure Tf_main.UpdateBtn(fx,fy:integer;tc:boolean;sender:TObject);
begin
if MultiDoc1.ActiveObject=sender then begin
  if fx>0 then begin FlipButtonX.ImageIndex:=15 ; Flipx1.checked:=false; end
          else begin FlipButtonX.ImageIndex:=16 ; Flipx1.checked:=true;  end;
  if fy>0 then begin FlipButtonY.ImageIndex:=17 ; Flipy1.checked:=false; end
          else begin FlipButtonY.ImageIndex:=18 ; Flipy1.checked:=true; end;
  if tc   then begin
               TConnect.ImageIndex:=49;
               TelescopeConnect.Hint:=rsDisconnectTe;
          end else begin
               TConnect.ImageIndex:=48;
               TelescopeConnect.Hint:=rsConnectTeles;
          end;
  with MultiDoc1.ActiveObject as Tf_chart do begin
    toolbuttonshowStars.down:=sc.cfgsc.showstars;
    ShowStars1.checked:=sc.cfgsc.showstars;
    toolbuttonshowNebulae.down:=sc.cfgsc.shownebulae;
    ShowNebulae1.checked:=sc.cfgsc.shownebulae;
    toolbuttonShowPictures.down:=sc.cfgsc.ShowImages;
    ShowPictures1.checked:=sc.cfgsc.ShowImages;
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
    ShowLabels1.checked:=sc.cfgsc.Showlabelall;
    toolbuttonGrid.down:=sc.cfgsc.ShowGrid;
    Grid1.checked:=sc.cfgsc.ShowGrid;
    toolbuttonGridEq.down:=sc.cfgsc.ShowEqGrid;
    GridEQ1.checked:=sc.cfgsc.ShowEqGrid;
    if sc.cfgsc.ProjPole=Equat then begin
       toolbuttonGridEq.Enabled:=false;
       toolbuttonGridEq.Indeterminate:=true;
       toolbuttonGridEq.ImageIndex:=87;
       GridEQ1.Enabled:=false;
    end else begin
       toolbuttonGridEq.Enabled:=true;
       toolbuttonGridEq.Indeterminate:=false;
       toolbuttonGridEq.ImageIndex:=24;
       GridEQ1.Enabled:=true;
    end;
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
    if sc.cfgsc.ProjPole=AltAz then begin
       ToolButtonShowObjectbelowHorizon.Enabled:=true;
       ToolButtonShowObjectbelowHorizon.Indeterminate:=false;
       ToolButtonShowObjectbelowHorizon.ImageIndex:=70;
       ToolButtonswitchbackground.Enabled:=true;
       ToolButtonswitchbackground.Indeterminate:=false;
       ToolButtonswitchbackground.ImageIndex:=35;
       ShowObjectbelowthehorizon1.Enabled:=true;
    end else begin
       ToolButtonShowObjectbelowHorizon.Enabled:=false;
       ToolButtonShowObjectbelowHorizon.Indeterminate:=true;
       ToolButtonShowObjectbelowHorizon.ImageIndex:=87;
       ToolButtonswitchbackground.Enabled:=false;
       ToolButtonswitchbackground.Indeterminate:=true;
       ToolButtonswitchbackground.ImageIndex:=87;
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
if MultiDoc1.ActiveObject=sender then begin   // active chart refresh
//  application.processmessages;
  if cfgm.SyncChart then SyncChild;
end;
end;

Function Tf_main.NewChart(cname:string):string;
begin
if cname='' then cname:=rsChart_ + IntToStr(MultiDoc1.ChildCount + 1);
cname:=GetUniqueName(cname,false);
if CreateChild(cname,true,def_cfgsc,def_cfgplot) then result:=msgOK+blank+cname
  else result:=msgFailed;
end;

Function Tf_main.CloseChart(cname:string):string;
var i: integer;
begin
result:=msgNotFound;
for i:=0 to MultiDoc1.ChildCount-1 do
  if MultiDoc1.Childs[i].DockedObject is Tf_chart then
     with MultiDoc1.Childs[i] do
        if caption=cname then begin
           Close;
           result:=msgOK;
        end;
end;

Function Tf_main.ListChart:string;
var i: integer;
begin
result:='';
for i:=0 to MultiDoc1.ChildCount-1 do
  if MultiDoc1.Childs[i].DockedObject is Tf_chart then
     result:=result+';'+MultiDoc1.Childs[i].caption;

if result>'' then result:=msgOK+blank+result+';'
             else result:=msgFailed+blank+'No Chart!';
end;

Function Tf_main.SelectChart(cname:string):string;
var i: integer;
begin
result:=msgNotFound;
for i:=0 to MultiDoc1.ChildCount-1 do
  if MultiDoc1.Childs[i].DockedObject is Tf_chart then
     with MultiDoc1.Childs[i] do
        if caption=cname then begin
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
 12 : result:=HelpCmd(trim(uppercase(arg[1])));
else begin
 result:='Bad chart name '+cname;
 for i:=0 to MultiDoc1.ChildCount-1 do
   if MultiDoc1.Childs[i].DockedObject is Tf_chart then
     with MultiDoc1.Childs[i] do
       if caption=cname then
         result:=(DockedObject as Tf_chart).ExecuteCmd(arg);
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
    and(TCPDaemon.TCPThrd[i].Fsock<>nil)
    and(not TCPDaemon.TCPThrd[i].terminated)
    then TCPDaemon.TCPThrd[i].SendData('>'+tab+origin+' :'+tab+str);
{$ifdef win32}
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

{ TCP/IP Connexion, based on Synapse Echo demo }

Constructor TTCPDaemon.Create;
begin
  FreeOnTerminate:=true;
  keepalive:=false;
  inherited create(false);
end;

procedure TTCPDaemon.ShowError;
begin
f_main.SetLpanel1(Format(rsSocketError, [inttostr(sock.lasterror),
  sock.GetErrorDesc(sock.lasterror)]));
end;

procedure TTCPDaemon.ShowSocket;
var locport:string;
begin
sock.GetSins;
locport:=inttostr(sock.GetLocalSinPort);
if locport<>f_main.cfgm.ServerIPport then locport:=Format(rsDifferentTha, [
  locport]);
f_main.serverinfo:=Format(rsListenOnPort, [locport]);
f_main.SetLpanel1(f_main.serverinfo);
end;

procedure TTCPDaemon.GetActiveChart;
begin
  if f_main.MultiDoc1.ActiveObject is Tf_chart then
    active_chart:=f_main.MultiDoc1.ActiveChild.caption
  else
    active_chart:=f_main.newchart('');
end;

procedure TTCPDaemon.Execute;
var
  ClientSock:TSocket;
  i,n : integer;
begin
stoping:=false;
for i:=1 to MaxWindow do ThrdActive[i]:=false;
sock:=TTCPBlockSocket.create;
try
  with sock do
    begin
      CreateSocket;
      if lasterror<>0 then Synchronize(ShowError);
      MaxLineLength:=1024;
      setLinger(true,1000);
      if lasterror<>0 then Synchronize(ShowError);
      bind(f_main.cfgm.ServerIPaddr,f_main.cfgm.ServerIPport);
      if lasterror<>0 then Synchronize(ShowError);
      listen;
      if lasterror<>0 then Synchronize(ShowError);
      Synchronize(ShowSocket);
      repeat
        if stoping or terminated then break;
        if canread(500) and (not terminated) then
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
  suspend;
  Sock.CloseSocket;
  Sock.free;
  terminate;
end;
end;

Constructor TTCPThrd.Create(Hsock:TSocket);
begin
  Csock := Hsock;
  FreeOnTerminate:=true;
  cmd:=TStringlist.create;
  keepalive:=false;
  abort:=false;
  lockexecutecmd:=false;
  inherited create(false);
end;

procedure TTCPThrd.Execute;
var
  s: string;
  i: integer;
begin
  Fsock:=TTCPBlockSocket.create;
  FConnectTime:=now;
  stoping:=false;
  try
    Fsock.socket:=CSock;
    Fsock.GetSins;
    Fsock.MaxLineLength:=1024;
    remoteip:=Fsock.GetRemoteSinIP;
    remoteport:=inttostr(Fsock.GetRemoteSinPort);
    with Fsock do
      begin
        repeat
          if stoping or terminated then break;
          s := RecvString(500);
          //if s<>'' then writetrace(s);   // for debuging only, not thread safe!
          if lastError=0 then begin
             if (uppercase(s)='QUIT')or(uppercase(s)='EXIT') then break;
             splitarg(s,blank,cmd);
             for i:=cmd.count to MaxCmdArg do cmd.add('');
             Synchronize(ExecuteCmd);
             SendString(cmdresult+crlf);
             if lastError<>0 then break;
             if (cmdresult=msgOK)and(uppercase(cmd[0])='SELECTCHART') then active_chart:=cmd[1];
          end else
             if keepalive then begin
                SendString('.'+crlf);      // keepalive check
                if lastError<>0 then break;  // if send failed we close the connection
          end;
        until false;
      end;
  finally
    f_main.TCPDaemon.ThrdActive[id]:=false;
    Fsock.SendString(msgBye+crlf);
    Fsock.CloseSocket;
    Fsock.Free;
    cmd.free;
    suspend;
    terminate;
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
if lockexecutecmd then exit;
lockexecutecmd:=true;
try
  cmdresult:=f_main.ExecuteCmd(active_chart,cmd);
finally
  lockexecutecmd:=false;
end;
end;

procedure Tf_main.StartServer;
begin
 try
 TCPDaemon:=TTCPDaemon.create;
 TCPDaemon.keepalive:=cfgm.keepalive;
 except
  SetLpanel1(rsTCPIPService);
 end;
end;

procedure Tf_main.StopServer;
var i :integer;
    d :double;
begin
if TCPDaemon=nil then exit;
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

procedure  TCdCUniqueInstance.Loaded;
begin
  inherited;
end;

procedure Tf_main.OtherInstance(Sender : TObject; ParamCount: Integer; Parameters: array of String);
var i : integer;
    buf,p: string;
begin
// process param from new instance
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
  ProcessParams2;
end;

procedure Tf_main.InstanceRunning(Sender : TObject);
var i : integer;
begin
if Params.Find('--unique',i) then
   halt(1);
end;

// Parameters that need to be set before program initialisation
procedure Tf_main.ProcessParams1;
var i,p: integer;
    cmd, parms, buf : string;
    pp: TStringList;
begin
for i:=0 to Params.Count-1 do begin
   parms:= Params[i];
   cmd:=words(parms,'',1,1);
   if cmd='--config' then begin  // specify .ini file
      p:=pos(' ',parms);
      if p>0 then begin
         buf:=copy(parms,p+1,999);
         ForceConfig:=trim(buf);
      end;
   end else if cmd='--test' then begin
   end;
end;
end;

// Parameters that need to be set after a chart is available
procedure Tf_main.ProcessParams2;
var i: integer;
    cmd, parms, buf : string;
    pp: TStringList;
begin
for i:=0 to Params.Count-1 do begin
   parms:= Params[i];
   cmd:=words(parms,'',1,1);
   if cmd='--test1' then begin
   end else if cmd='--test2' then begin
       pp:=TStringList.Create;
       pp.Add('NEWCHART');
       pp.Add('test');
       ExecuteCmd('test',pp);
       pp.free;
   end;
end;
end;

procedure Tf_main.ConnectDB;
var dbpath:string;
begin
try
    NeedToInitializeDB:=false;
    if ((DBtype=sqlite) and not Fileexists(cfgm.db)) then begin
        {$ifdef trace_debug}
         WriteTrace('Create sqlite '+dbpath);
        {$endif}
        dbpath:=extractfilepath(cfgm.db);
        if not directoryexists(dbpath) then CreateDir(dbpath);
        if not directoryexists(dbpath) then forcedirectories(dbpath);
    end;
    if (cdcdb.ConnectDB(cfgm.dbhost,cfgm.db,cfgm.dbuser,cfgm.dbpass,cfgm.dbport)
       and cdcdb.CheckDB) then begin
         {$ifdef trace_debug}
          WriteTrace('DB connected');
         {$endif}
          cdcdb.CheckForUpgrade(f_info.ProgressMemo);
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
       {$ifdef trace_debug}
       WriteTrace('Initialize DB');
       {$endif}
       f_info.setpage(2);
       f_info.show;
       f_info.ProgressMemo.lines.add(rsInitializeDa);
       cdcdb.LoadSampleData(f_info.ProgressMemo);
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

procedure Tf_main.showdetailinfo(chart:string;ra,dec:double;nm,desc:string);
var i : integer;
begin
for i:=0 to MultiDoc1.ChildCount-1 do
 if MultiDoc1.Childs[i].DockedObject is Tf_chart then
   if MultiDoc1.Childs[i].caption=chart then with MultiDoc1.Childs[i].DockedObject as Tf_chart do begin
      sc.cfgsc.FindRa:=ra;
      sc.cfgsc.FindDec:=dec;
      sc.cfgsc.FindDesc:=desc;
      sc.cfgsc.FindName:=nm;
      sc.cfgsc.FindNote:='';
      sc.cfgsc.FindPM:=false;
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
for i:=0 to MultiDoc1.ChildCount-1 do
 if MultiDoc1.Childs[i].DockedObject is Tf_chart then
   if MultiDoc1.Childs[i].caption=chart then with MultiDoc1.Childs[i].DockedObject as Tf_chart do begin
     sc.cfgsc.racentre:=sc.cfgsc.FindRa;
     sc.cfgsc.decentre:=sc.cfgsc.FindDec;
     sc.cfgsc.TrackOn:=false;
     Refresh;
     break;
end;
end;

procedure Tf_main.NeighborObj(chart:string);
var i :integer;
    x,y:single;
    x1,y1: double;
begin
for i:=0 to MultiDoc1.ChildCount-1 do
 if MultiDoc1.Childs[i].DockedObject is Tf_chart then
   if MultiDoc1.Childs[i].caption=chart then with MultiDoc1.Childs[i].DockedObject as Tf_chart do begin
     projection(sc.cfgsc.FindRa,sc.cfgsc.FindDec,x1,y1,true,sc.cfgsc) ;
     WindowXY(x1,y1,x,y,sc.cfgsc);
     ListXY(round(x),round(y));
     break;
end;
end;

procedure Tf_main.ImageSetFocus(Sender: TObject);
begin
// to restore focus to the chart that as no text control
  activecontrol:=nil;
  quicksearch.Enabled:=false;   // add all main form focusable control here
  TimeVal.Enabled:=false;
  TimeU.Enabled:=false;
  Activecontrol:=Multidoc1;
{$ifndef lclgtk2}
  quicksearch.Enabled:=true;
  TimeVal.Enabled:=true;
  TimeU.Enabled:=true;
{$endif}
end;

procedure Tf_main.ListInfo(buf:string);
begin
f_info.Memo1.text:=buf;
f_info.Memo1.selstart:=0;
f_info.Memo1.selend:=0;
f_info.setpage(1);
f_info.source_chart:=MultiDoc1.ActiveChild.caption;
f_info.show;
f_info.bringtofront;
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

procedure Tf_main.SetTheme;
var i : integer;
begin
 if nightvision then
    SetNightVision(true)
 else
    SetButtonImage(cfgm.ButtonStandard);

 if fileexists(slash(appdir)+slash('data')+slash('Themes')+slash(cfgm.ThemeName)+'retic.cur') then begin
   CursorImage1.FreeImage;
   CursorImage1:=TCursorImage.Create;
   CursorImage1.LoadFromFile(slash(appdir)+slash('data')+slash('Themes')+slash(cfgm.ThemeName)+'retic.cur');
   inc(crRetic);
   Screen.Cursors[crRetic]:=CursorImage1.Handle;
   for i:=0 to MultiDoc1.ChildCount-1 do
        if MultiDoc1.Childs[i].DockedObject is Tf_chart then
           Tf_chart(MultiDoc1.Childs[i].DockedObject).ChartCursor:=crRetic;
 end;

 if fileexists(slash(appdir)+slash('data')+slash('Themes')+slash(cfgm.ThemeName)+'compass.bmp') then begin
    compass.LoadFromFile(slash(appdir)+slash('data')+slash('Themes')+slash(cfgm.ThemeName)+'compass.bmp');
    for i:=0 to MultiDoc1.ChildCount-1 do
        if MultiDoc1.Childs[i].DockedObject is Tf_chart then
           Tf_chart(MultiDoc1.Childs[i].DockedObject).sc.plot.compassrose:=compass;
 end;
 if fileexists(slash(appdir)+slash('data')+slash('Themes')+slash(cfgm.ThemeName)+'arrow.bmp') then begin
    arrow.LoadFromFile(slash(appdir)+slash('data')+slash('Themes')+slash(cfgm.ThemeName)+'arrow.bmp');
    for i:=0 to MultiDoc1.ChildCount-1 do
        if MultiDoc1.Childs[i].DockedObject is Tf_chart then
           Tf_chart(MultiDoc1.Childs[i].DockedObject).sc.plot.compassarrow:=arrow;
 end;
end;

procedure Tf_main.SetButtonImage(button: Integer);
var btn : TBitmap;
    col: Tcolor;
    iconpath: String;
procedure SetButtonImage1(imagelist:Timagelist);
var i: Integer;
begin
   imagelist.Clear;
     for i:=0 to ImageListCount-1 do begin
       try
         btn:=TBitmap.Create;
         btn.LoadFromFile(iconpath+'i'+inttostr(i)+'.bmp');
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
   BtnCloseChild.Glyph.LoadFromFile(iconpath+'b1.bmp');
   BtnRestoreChild.Glyph.LoadFromFile(iconpath+'b2.bmp');
   btn:=TBitmap.Create;
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
   iconpath:=slash(appdir)+slash('data')+slash('Themes')+slash(cfgm.ThemeName)+slash('icon_color');
   col:=clNavy;
   SetButtonImage1(ImageNormal);
   end;
 2:begin  // red
   iconpath:=slash(appdir)+slash('data')+slash('Themes')+slash(cfgm.ThemeName)+slash('icon_red');
   col:=$acb5f5;
   SetButtonImage1(ImageList2);
   end;
 3:begin   // blue
   iconpath:=slash(appdir)+slash('data')+slash('Themes')+slash(cfgm.ThemeName)+slash('icon_blue');
   col:=clNavy;
   SetButtonImage1(ImageList2);
   end;
 4:begin   // Green
   iconpath:=slash(appdir)+slash('data')+slash('Themes')+slash(cfgm.ThemeName)+slash('icon_green');
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


procedure Tf_main.MultiDoc1ActiveChildChange(Sender: TObject);
begin
if MultiDoc1.ActiveObject<>nil then begin
   caption:=basecaption+' - '+MultiDoc1.ActiveChild.Caption;
   (MultiDoc1.ActiveObject as Tf_chart).ChartActivate;
end
else
   caption:=basecaption;
end;

procedure Tf_main.MultiDoc1Maximize(Sender: TObject);
begin
ChildControl.visible:=MultiDoc1.Maximized;
end;

procedure Tf_main.BtnRestoreChildClick(Sender: TObject);
begin
   MultiDoc1.Maximized:=not MultiDoc1.Maximized;
end;

procedure Tf_main.BtnCloseChildClick(Sender: TObject);
begin
if (MultiDoc1.ActiveObject is Tf_chart)and(MultiDoc1.ChildCount>1) then
   MultiDoc1.ActiveChild.close;
end;

procedure Tf_main.WindowCascade1Execute(Sender: TObject);
begin
MultiDoc1.Cascade;
end;

procedure Tf_main.WindowTileHorizontal1Execute(Sender: TObject);
begin
MultiDoc1.TileHorizontal;
end;

procedure Tf_main.WindowTileVertical1Execute(Sender: TObject);
begin
MultiDoc1.TileVertical;
end;

procedure Tf_main.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
if (MultiDoc1.ActiveObject is Tf_chart) and ((Activecontrol=nil)or(Activecontrol=Multidoc1)) then
   (MultiDoc1.ActiveObject as Tf_chart).FormKeyDown(Sender,Key,Shift);
end;

procedure Tf_main.FormKeyPress(Sender: TObject; var Key: Char);
begin
if (MultiDoc1.ActiveObject is Tf_chart)and ((Activecontrol=nil)or(Activecontrol=Multidoc1)) then
   (MultiDoc1.ActiveObject as Tf_chart).FormKeyPress(Sender,Key);
end;

procedure Tf_main.SetChildFocus(Sender: TObject);
var i:integer;
begin
for i:=0 to MultiDoc1.ChildCount-1 do
   if MultiDoc1.Childs[i].DockedObject=Sender then
      MultiDoc1.setActiveChild(i);

end;


procedure Tf_main.MaximizeExecute(Sender: TObject);
begin
MultiDoc1.Maximized:=true;
end;

procedure Tf_main.ToolButtonNightVisionClick(Sender: TObject);
var i: integer;
begin
nightvision:= not nightvision;
SetNightVision(nightvision);
ToolButtonNightVision.Down:=nightvision;
NightVision1.Checked:=nightvision;
for i:=0 to MultiDoc1.ChildCount-1 do
  if MultiDoc1.Childs[i].DockedObject is Tf_chart then
    (MultiDoc1.Childs[i].DockedObject as Tf_chart).NightVision:=nightvision;
end;

{$ifdef win32}
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
   timeval.Color:=nv_dark;
   timeval.Font.Color:=nv_middle;
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
   timeval.Color:=clWindow;
   timeval.Font.Color:=clWindowText;
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
   MultiDoc1.InactiveBorderColor:=nv_black;
   MultiDoc1.TitleColor:=nv_middle;
   MultiDoc1.BorderColor:=nv_dark;
 end else begin
   SetButtonImage(cfgm.ButtonStandard);
   MultiDoc1.InactiveBorderColor:=$404040;
   MultiDoc1.TitleColor:=clWhite;
   MultiDoc1.BorderColor:=$808080;
end;
for i:=0 to MultiDoc1.ChildCount-1 do
  if MultiDoc1.Childs[i]=MultiDoc1.ActiveChild then
     MultiDoc1.Childs[i].SetBorderColor(MultiDoc1.BorderColor)
  else
     MultiDoc1.Childs[i].SetBorderColor(MultiDoc1.InactiveBorderColor);
end;

procedure Tf_main.ViewFullScreenExecute(Sender: TObject);
begin
FullScreen1.Checked:=not FullScreen1.Checked;
{$IF DEFINED(LCLgtk) or DEFINED(LCLgtk2)}
  SetWindowFullScreen(f_main,FullScreen1.Checked);
{$endif}
end;
{$endif}

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
if MultiDoc1.ActiveObject is Tf_chart then with MultiDoc1.ActiveChild do Dde_active_chart:=caption;
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
GetTranslationString(Tf_chart(MultiDoc1.ActiveObject),f);
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

initialization
  {$i pu_main.lrs}

end.
