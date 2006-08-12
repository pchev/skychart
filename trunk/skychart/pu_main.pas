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
    //WinXP, // XP theme still not working with night vision
  {$endif}
  u_translation, cu_catalog, cu_planet, cu_telescope, cu_fits, cu_database, pu_chart,
  pu_config_time, pu_config_observatory, pu_config_display, pu_config_pictures,
  pu_config_catalog, u_constant, u_util, blcksock, synsock, lazjpeg, dynlibs,
  LCLIntf, SysUtils, Classes, Graphics, Forms, Controls, Menus, Math,
  StdCtrls, Dialogs, Buttons, ExtCtrls, ComCtrls, StdActns,
  ActnList, CDC_IniFiles, Spin, Clipbrd, MultiDoc, ChildDoc,
  LResources;

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
    keepalive,abort : boolean;
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
    keepalive : boolean;
    TCPThrd: array [1..Maxwindow] of TTCPThrd ;
    ThrdActive: array [1..Maxwindow] of boolean ;
    Constructor Create;
    procedure Execute; override;
    procedure ShowSocket;
    procedure GetACtiveChart;
  end;

type

  { Tf_main }

  Tf_main = class(TForm)
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
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    MenuItem4: TMenuItem;
    MenuItem5: TMenuItem;
    MenuItem6: TMenuItem;
    SetupDisplay: TAction;
    SetupColour: TAction;
    SetupLines: TAction;
    SetupLabels: TAction;
    SetupFonts: TAction;
    SetupFinder: TAction;
    ObsConfig1: TMenuItem;
    N11: TMenuItem;
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
    OpenConfig: TAction;
    Configuration1: TMenuItem;
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
    ileVertically1: TMenuItem;
    zoomminus1: TMenuItem;
    elescope1: TMenuItem;
    elescopeConnect1: TMenuItem;
    elescopeSlew1: TMenuItem;
    elescopeSync1: TMenuItem;
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
    procedure BugReport1Click(Sender: TObject);
    procedure FileClose1Execute(Sender: TObject);
    procedure FileNew1Execute(Sender: TObject);
    procedure FileOpen1Execute(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure HelpAbout1Execute(Sender: TObject);
    procedure FileExit1Execute(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure HomePage1Click(Sender: TObject);
    procedure Maillist1Click(Sender: TObject);
    procedure Print1Execute(Sender: TObject);
    procedure OpenConfigExecute(Sender: TObject);
    procedure ResetAllLabels1Click(Sender: TObject);
    procedure SetupCatalogExecute(Sender: TObject);
    procedure SetupColourExecute(Sender: TObject);
    procedure SetupDisplayExecute(Sender: TObject);
    procedure SetupFinderExecute(Sender: TObject);
    procedure SetupFontsExecute(Sender: TObject);
    procedure SetupLabelsExecute(Sender: TObject);
    procedure SetupLinesExecute(Sender: TObject);
    procedure SetupObservatoryExecute(Sender: TObject);
    procedure SetupPicturesExecute(Sender: TObject);
    procedure SetupTimeExecute(Sender: TObject);
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
    ConfigTime: Tf_config_time;
    ConfigObservatory: Tf_config_observatory;
    ConfigDisplay: Tf_config_display;
    ConfigPictures: Tf_config_pictures;
    ConfigCatalog: Tf_config_catalog;
    cryptedpwd,basecaption :string;
    NeedRestart,NeedToInitializeDB : Boolean;
    InitialChartNum: integer;
    AutoRefreshLock: Boolean;
  {$ifdef win32}
    savwincol  : array[0..30] of Tcolor;
  {$endif}
    procedure SetButtonImage(button: Integer);
    function CreateChild(const CName: string; copyactive: boolean; var cfg1 : conf_skychart; var cfgp : conf_plot; locked:boolean=false):boolean;
    Procedure RefreshAllChild(applydef:boolean);
    Procedure SyncChild;
    procedure CopySCconfig(c1:conf_skychart;var c2:conf_skychart);
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
    procedure SetupObservatoryPage(page:integer);
    procedure SetupTimePage(page:integer);
    procedure SetupDisplayPage(pagegroup:integer);
    procedure SetupPicturesPage(page:integer);
    procedure SetupCatalogPage(page:integer);
  {$ifdef win32}
    Procedure SaveWinColor;
    Procedure ResetWinColor;
  {$endif}
  public
    { Public declarations }
    cfgm : conf_main;
    def_cfgsc : conf_skychart;
    def_cfgplot : conf_plot;
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
    procedure ReadChartConfig(filename:string; usecatalog,resizemain:boolean; var cplot:conf_plot ;var csc:conf_skychart);
    procedure ReadPrivateConfig(filename:string);
    procedure ReadDefault;
    procedure UpdateConfig;
    procedure SavePrivateConfig(filename:string);
    procedure SaveQuickSearch(filename:string);
    procedure SaveChartConfig(filename:string; child: TChildDoc);
    procedure SaveDefault;
    procedure SetDefault;
    procedure SetLang;
    procedure ChangeLanguage(lang:string);
    Procedure InitFonts;
    Procedure activateconfig(cmain:Pconf_main; csc:Pconf_skychart; ccat:Pconf_catalog; cshr:Pconf_shared; cplot:Pconf_plot; cdss:Pconf_dss; applyall:boolean );
    Procedure SetLPanel1(txt:string; origin:string='';sendmsg:boolean=true; Sender: TObject=nil);
    Procedure SetLPanel0(txt:string);
    Procedure SetTopMessage(txt:string);
    procedure updatebtn(fx,fy:integer;tc:boolean;sender:TObject);
    Function NewChart(cname:string):string;
    Function CloseChart(cname:string):string;
    Function ListChart:string;
    Function SelectChart(cname:string):string;
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
    procedure GetChartConfig(var csc:conf_skychart);
    procedure DrawChart(var csc:conf_skychart);
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

{$ifdef win32}
   {$R cdc_icon.res}
{$endif}
//todo: lazarus cursor {$R cursbmp.res}

uses
     pu_detail, pu_about, pu_config, pu_info, pu_getdss, u_projection,
     pu_printsetup, pu_calendar, pu_position, pu_search, pu_zoom,
     pu_manualtelescope, pu_print;


function Tf_main.CreateChild(const CName: string; copyactive: boolean; var cfg1 : conf_skychart; var cfgp : conf_plot; locked:boolean=false):boolean;
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
    cfg1:=(MultiDoc1.Activeobject as Tf_chart).sc.cfgsc^;
    cfgp:=(MultiDoc1.Activeobject as Tf_chart).sc.plot.cfgplot^;
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
  Child.sc.plot.cfgplot^:=cfgp;
  Child.sc.plot.starshape:=starshape.Picture.Bitmap;
  Child.sc.plot.cfgplot.starshapesize:=starshape.Picture.bitmap.Width div 11;
  Child.sc.plot.cfgplot.starshapew:=Child.sc.plot.cfgplot.starshapesize div 2;
  Child.sc.cfgsc^:=cfg1;
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
  cp.maximized:=maxi;
  result:=true;
  Child.locked:=false;
  Child.Refresh;
  caption:=basecaption+' - '+MultiDoc1.ActiveChild.Caption ;
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
c2.DST := c1.DST ;
c2.ObsTemperature := c1.ObsTemperature ;
c2.ObsPressure := c1.ObsPressure ;
c2.ObsName := c1.ObsName ;
c2.ObsCountry := c1.ObsCountry ;
c2.DrawPMyear := c1.DrawPMyear ;
c2.PMon := c1.PMon ;
c2.DrawPMon := c1.DrawPMon ;
c2.ApparentPos := c1.ApparentPos;
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
c2.ShowAsteroid := c1.ShowAsteroid ;
c2.ShowImages := c1.ShowImages ;
c2.ShowBackgroundImage := c1.ShowBackgroundImage ;
c2.BackgroundImage := c1.BackgroundImage ;
c2.AstmagMax := c1.AstmagMax;
c2.AstmagDiff := c1.AstmagDiff;
c2.AstSymbol := c1.AstSymbol;
c2.ShowComet := c1.ShowComet ;
c2.CommagMax := c1.CommagMax;
c2.CommagDiff := c1.CommagDiff;
c2.ComSymbol := c1.ComSymbol;
c2.MagLabel := c1.MagLabel;
c2.NameLabel := c1.NameLabel;
c2.ConstFullLabel := c1.ConstFullLabel;
c2.GRSlongitude := c1.GRSlongitude ;
c2.ShowEarthShadow := c1.ShowEarthShadow ;
c2.ProjPole := c1.ProjPole ;
c2.ShowEqGrid := c1.ShowEqGrid ;
c2.ShowGrid := c1.ShowGrid ;
c2.ShowGridNum := c1.ShowGridNum ;
c2.ShowConstL := c1.ShowConstL ;
c2.ShowConstB := c1.ShowConstB ;
c2.ShowEcliptic := c1.ShowEcliptic ;
c2.ShowGalactic := c1.ShowGalactic ;
c2.ShowMilkyWay := c1.ShowMilkyWay ;
c2.FillMilkyWay := c1.FillMilkyWay ;
c2.HorizonOpaque := c1.HorizonOpaque ;
c2.ShowHorizon := c1.ShowHorizon ;
c2.ShowHorizonDepression := c1.ShowHorizonDepression ;
c2.HorizonMax := c1.HorizonMax ;
c2.Horizonlist := c1.Horizonlist ;
c2.ShowlabelAll := c1.ShowlabelAll ;
c2.Editlabels := c1.Editlabels ;
for i:=1 to numlabtype do begin
   c2.ShowLabel[i]:=c1.ShowLabel[i];
   c2.LabelMagDiff[i]:=c1.LabelMagDiff[i];
end;
for i:=1 to 10 do c2.circle[i,1]:=c1.circle[i,1];
for i:=1 to 10 do c2.circle[i,2]:=c1.circle[i,2];
for i:=1 to 10 do c2.circle[i,3]:=c1.circle[i,3];
for i:=1 to 10 do c2.circleok[i]:=c1.circleok[i];
for i:=1 to 10 do c2.circlelbl[i]:=c1.circlelbl[i];
for i:=1 to 10 do c2.rectangle[i,1]:=c1.rectangle[i,1];
for i:=1 to 10 do c2.rectangle[i,2]:=c1.rectangle[i,2];
for i:=1 to 10 do c2.rectangle[i,3]:=c1.rectangle[i,3];
for i:=1 to 10 do c2.rectangle[i,4]:=c1.rectangle[i,4];
for i:=1 to 10 do c2.rectangleok[i]:=c1.rectangleok[i];
for i:=1 to 10 do c2.rectanglelbl[i]:=c1.rectanglelbl[i];
c2.ShowCircle:=c1.ShowCircle;
c2.IndiServerHost:=c1.IndiServerHost;
c2.IndiServerPort:=c1.IndiServerPort;
c2.IndiServerCmd:=c1.IndiServerCmd;
c2.IndiDriver:=c1.IndiDriver;
c2.IndiPort:=c1.IndiPort;
c2.IndiDevice:=c1.IndiDevice;
c2.IndiTelescope:=c1.IndiTelescope;
c2.PluginTelescope:=c1.PluginTelescope;
c2.ManualTelescope:=c1.ManualTelescope;
c2.ManualTelescopeType:=c1.ManualTelescopeType;
c2.TelescopeTurnsX:=c1.TelescopeTurnsX;
c2.TelescopeTurnsY:=c1.TelescopeTurnsY;
c2.ScopePlugin:=c1.ScopePlugin;
c2.StyleGrid:=c1.StyleGrid;
c2.StyleEqGrid:=c1.StyleEqGrid;
c2.StyleConstL:=c1.StyleConstL;
c2.StyleConstB:=c1.StyleConstB;
c2.StyleEcliptic:=c1.StyleEcliptic;
c2.StyleGalEq:=c1.StyleGalEq;
//c2. := c1. ;
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
        CopySCconfig(def_cfgsc,sc.cfgsc^);
        sc.cfgsc.FindOk:=false;
        sc.plot.cfgplot^:=def_cfgplot;
      end;
      AutoRefresh;
     end;
end;

procedure Tf_main.SyncChild;
var i,y,m,d: integer;
    ra,de,jda,t,tz: double;
    st,dst: boolean;
begin
if MultiDoc1.ActiveObject is Tf_chart then begin
 ra:=(MultiDoc1.ActiveObject as Tf_chart).sc.cfgsc.racentre;
 de:=(MultiDoc1.ActiveObject as Tf_chart).sc.cfgsc.decentre;
 jda:=(MultiDoc1.ActiveObject as Tf_chart).sc.cfgsc.jdchart;
 y:=(MultiDoc1.ActiveObject as Tf_chart).sc.cfgsc.curyear;
 m:=(MultiDoc1.ActiveObject as Tf_chart).sc.cfgsc.curmonth;
 d:=(MultiDoc1.ActiveObject as Tf_chart).sc.cfgsc.curday;
 t:=(MultiDoc1.ActiveObject as Tf_chart).sc.cfgsc.curtime;
 tz:=(MultiDoc1.ActiveObject as Tf_chart).sc.cfgsc.ObsTZ;
 dst:=(MultiDoc1.ActiveObject as Tf_chart).sc.cfgsc.DST;
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
      sc.cfgsc.ObsTZ:=tz;
      sc.cfgsc.DST:=dst;
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

procedure Tf_main.FileOpen1Execute(Sender: TObject);
var cfgs :conf_skychart;
    cfgp : conf_plot;
    nam: string;
    p: integer;
begin
if Opendialog.InitialDir='' then Opendialog.InitialDir:=privatedir;
OpenDialog.Filter:='Cartes du Ciel 3 File|*.cdc3|All Files|*.*';
OpenDialog.Title:=rsOpenAChart;
  if OpenDialog.Execute then begin
    cfgp:=def_cfgplot;
    cfgs:=def_cfgsc;
    ReadChartConfig(OpenDialog.FileName,true,false,cfgp,cfgs);
    nam:=stringreplace(extractfilename(OpenDialog.FileName),blank,'_',[rfReplaceAll]);
    p:=pos('.',nam);
    if p>0 then nam:=copy(nam,1,p-1);
    CreateChild(GetUniqueName(nam,false) ,false,cfgs,cfgp);
  end;
end;

procedure Tf_main.FormShow(Sender: TObject);
var i:integer;
begin
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
end;

procedure Tf_main.Init;
var cfgs :conf_skychart;
    cfgp : conf_plot;
    i: integer;
begin
try
 // some initialisation that need to be done after all the forms are created.
 f_info.onGetTCPinfo:=GetTCPInfo;
 f_info.onKillTCP:=KillTCPClient;
 f_info.onPrintSetup:=PrintSetup;
 f_info.OnShowDetail:=showdetailinfo;
 f_detail.OnCenterObj:=CenterFindObj;
 f_detail.OnNeighborObj:=NeighborObj;
 SetDefault;
 ReadDefault;
 // must read db configuration before to create this one!
 cdcdb:=TCDCdb.Create(self);
 planet:=Tplanet.Create(self);
 Fits:=TFits.Create(self);
 cdcdb.onInitializeDB:=InitializeDB;
 planet.cdb:=cdcdb;
 f_search.cdb:=cdcdb;
 telescope.pluginpath:=slash(appdir)+slash('plugins')+slash('telescope');
 telescope.plugin:=def_cfgsc.ScopePlugin;
 if def_cfgsc.BackgroundImage='' then begin
   def_cfgsc.BackgroundImage:=slash(privatedir)+slash('pictures');
   if not DirectoryExists(def_cfgsc.BackgroundImage) then forcedirectories(def_cfgsc.BackgroundImage);
 end;
 catalog.LoadConstellation(cfgm.Constellationfile);
 catalog.LoadConstL(cfgm.ConstLfile);
 catalog.LoadConstB(cfgm.ConstBfile);
 catalog.LoadHorizon(cfgm.horizonfile,@def_cfgsc);
 catalog.LoadStarName(slash(appdir)+slash('data')+slash('common_names')+'StarsNames.txt');
 f_search.cfgshr:=catalog.cfgshr;
 f_search.Init;
 ConnectDB;
 Fits.min_sigma:=cfgm.ImageLuminosity;
 Fits.max_sigma:=cfgm.ImageContrast;
 CreateChild(GetUniqueName(rsChart_, true), true, def_cfgsc, def_cfgplot, true);
 Autorefresh.Interval:=max(10,cfgm.autorefreshdelay)*1000;
 AutoRefreshLock:=false;
 Autorefresh.enabled:=true;
 if cfgm.AutostartServer then StartServer;
 f_calendar.planet:=planet;
 f_calendar.cdb:=cdcdb;
 f_calendar.OnGetChartConfig:=GetChartConfig;
 f_calendar.OnUpdateChart:=DrawChart;
 f_calendar.eclipsepath:=slash(appdir)+slash('data')+slash('eclipses');
 if InitialChartNum>1 then
    for i:=1 to InitialChartNum-1 do begin
      cfgp:=def_cfgplot;
      cfgs:=def_cfgsc;
      ReadChartConfig(configfile+inttostr(i),true,false,cfgp,cfgs);
      CreateChild(GetUniqueName(rsChart_, true) , false, cfgs, cfgp);
    end;
 if nightvision then begin
    nightvision:=false;
    ToolButtonNightVisionClick(self);
 end;
except
 on E: Exception do SetLPanel1(E.Message);
end;
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

procedure Tf_main.SaveImageExecute(Sender: TObject);
var ext,format:string;
begin
Savedialog.DefaultExt:='bmp';
if Savedialog.InitialDir='' then Savedialog.InitialDir:=privatedir;
savedialog.Filter:='BMP|*.bmp|JPEG|*.jpg|PNG|*.png';
savedialog.Title:=rsSaveImage;
if MultiDoc1.ActiveObject  is Tf_chart then
 with MultiDoc1.ActiveObject as Tf_chart do
  if SaveDialog.Execute then begin
     ext:=uppercase(extractfileext(SaveDialog.Filename));
     if (ext='.PNG') then format:='PNG'
     else if (ext='.JPG')or(ext='.JPEG') then format:='JPEG'
     else format:='BMP';
     SaveChartImage(format,SaveDialog.Filename,95);
  end;
end;

procedure Tf_main.HelpAbout1Execute(Sender: TObject);
begin
  f_about.ShowModal;
end;

procedure Tf_main.HelpContents1Execute(Sender: TObject);
begin
   ExecuteFile(slash(helpdir)+'index.html');
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
    buf: string;
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
{$ifdef win32}
    PIDL : PItemIDList;
    Folder : array[0..MAX_PATH] of Char;
const CSIDL_PERSONAL = $0005;
{$endif}
begin
appdir:=getcurrentdir;
privatedir:=DefaultPrivateDir;
Tempdir:=DefaultTmpDir;
{$ifdef unix}
appdir:=expandfilename(appdir);
privatedir:=expandfilename(PrivateDir);
Tempdir:=expandfilename(Tempdir);
{$endif}
{$ifdef win32}
SHGetSpecialFolderLocation(0, CSIDL_PERSONAL, PIDL);
SHGetPathFromIDList(PIDL, Folder);
privatedir:=slash(Folder)+privatedir;
configfile:=slash(privatedir)+configfile;
tracefile:=slash(privatedir)+tracefile;
Tempdir:=slash(privatedir)+DefaultTmpDir;
{$endif}
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
if not directoryexists(privatedir) then forcedirectories(privatedir);
if not directoryexists(slash(privatedir)+'MPC') then forcedirectories(slash(privatedir)+'MPC');
if not directoryexists(TempDir) then forcedirectories(TempDir);
{$ifdef unix}  // allow a shared install
if (not directoryexists(slash(appdir)+'data/constellation')) and
   (directoryexists(SharedDir)) then
   appdir:=SharedDir;
{$endif}
SampleDir:=slash(appdir)+slash('data')+'sample';
end;

procedure Tf_main.FormCreate(Sender: TObject);
begin
SysDecimalSeparator:=DecimalSeparator;
DecimalSeparator:='.';
NeedRestart:=false;
ImageListCount:=ImageNormal.Count;
{$ifdef win32}
  configfile:=Defaultconfigfile;
{$endif}
{$ifdef unix}
  configfile:=expandfilename(Defaultconfigfile);
{$endif}
GetAppDir;
chdir(appdir);
InitTrace;
traceon:=true;
GetLanguage;
u_translation.translate(cfgm.language,'en');
catalog:=Tcatalog.Create(self);
SetLang;
telescope:=Ttelescope.Create(self);
basecaption:=caption;
MultiDoc1.WindowList:=Window1;
MultiDoc1.KeepLastChild:=true;
ChildControl.visible:=false;
BtnCloseChild.Glyph.LoadFromLazarusResource('CLOSE');
BtnRestoreChild.Glyph.LoadFromLazarusResource('RESTORE');
starshape.Picture.Bitmap.Transparent:=false;
TimeVal.Width:= round( 60 {$ifdef win32} * Screen.PixelsPerInch/96 {$endif} );
quicksearch.Width:=round( 75 {$ifdef win32} * Screen.PixelsPerInch/96 {$endif} );
TimeU.Width:=round( 95 {$ifdef win32} * Screen.PixelsPerInch/96 {$endif} );
//todo: Screen.Cursors[crRetic] := LoadCursorFromFile('retic.cur');
zlib:=LoadLibrary(libz);
if zlib<>0 then begin
  gzopen:= Tgzopen(GetProcAddress(zlib,'gzopen'));
  gzread:= Tgzread(GetProcAddress(zlib,'gzread'));
  gzclose:= Tgzclose(GetProcAddress(zlib,'gzclose'));
  gzeof:= Tgzeof(GetProcAddress(zlib,'gzeof'));
  zlibok:=true;
end else zlibok:=false;
Plan404lib:=LoadLibrary(lib404);
if Plan404lib<>0 then begin
  Plan404:= TPlan404(GetProcAddress(Plan404lib,'Plan404'));
  Plan404ok:=true;
end else Plan404ok:=false;
end;

procedure Tf_main.FormDestroy(Sender: TObject);
begin
try
StopServer;
catalog.free;
Fits.Free;
planet.free;
cdcdb.free;
telescope.free;
if NeedRestart then ExecNoWait(paramstr(0));
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
writetrace(rsExiting);
Autorefresh.Enabled:=false;
SaveQuickSearch(configfile);
if SaveConfigOnExit.checked and
   (MessageDlg(rsDoYouWantToS, mtConfirmation, [mbYes, mbNo], 0)=mrYes) then
      SaveDefault;
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
    savelabel:= sc.cfgsc^.Editlabels;
    try
      if savelabel then begin
         sc.cfgsc^.Editlabels:=false;
         sc.Refresh;
      end;
      Clipboard.Assign(sc.plot.cbmp);
    finally
      if savelabel then begin
         sc.cfgsc^.Editlabels:=true;
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

procedure Tf_main.rot_minusExecute(Sender: TObject);
begin
if MultiDoc1.ActiveObject is Tf_chart then with MultiDoc1.ActiveObject as Tf_chart do rot_minusExecute(Sender);
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
   DtoS(hh+sc.cfgsc.TimeZone-sc.cfgsc.DT_UT,h,n,s);
   case TimeU.itemindex of
   0 : begin
       SetJD(sc.cfgsc.CurJD+(sc.cfgsc.TimeZone)/24+mult/24);
       end;
   1 : begin
       SetJD(sc.cfgsc.CurJD+(sc.cfgsc.TimeZone)/24+mult/1440);
       end;
   2 : begin
       SetJD(sc.cfgsc.CurJD+(sc.cfgsc.TimeZone)/24+mult/86400);
       end;
   3 : begin
       SetJD(sc.cfgsc.CurJD+(sc.cfgsc.TimeZone)/24+mult);
       end;
   4 : begin
       inc(m,mult);
       SetDate(y,m,d,h,n,s);
       end;
   5 : begin
       inc(y,mult);
       SetDate(y,m,d,h,n,s);
       end;
   6 : SetJD(sc.cfgsc.CurJD+(sc.cfgsc.TimeZone)/24+mult*365.25);      // julian year
   7 : SetJD(sc.cfgsc.CurJD+(sc.cfgsc.TimeZone)/24+mult*365.2421988); // tropical year
   8 : SetJD(sc.cfgsc.CurJD+(sc.cfgsc.TimeZone)/24+mult*0.99726956633); // sideral day
   9 : SetJD(sc.cfgsc.CurJD+(sc.cfgsc.TimeZone)/24+mult*29.530589);   // synodic month
   10: SetJD(sc.cfgsc.CurJD+(sc.cfgsc.TimeZone)/24+mult*6585.321);    // saros
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
      showmessage(rsErrorPleaseC3);
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
      showmessage(rsErrorPleaseC);
   end;
   Refresh;
end;
end;


procedure Tf_main.DSSImageExecute(Sender: TObject);

begin
if (MultiDoc1.ActiveObject is Tf_chart) and (Fits.dbconnected)
  then with MultiDoc1.ActiveObject as Tf_chart do begin
   f_getdss.cmain:=@cfgm;
   if f_getdss.GetDss(sc.cfgsc.racentre,sc.cfgsc.decentre,sc.cfgsc.fov,sc.cfgsc.windowratio,image1.width) then begin
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
      f_info.close;
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
   if showcom<>sc.cfgsc.ShowComet then showmessage(rsErrorPleaseC2);
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
    if MultiDoc1.ActiveObject is Tf_chart then f_calendar.config^:= Tf_chart(MultiDoc1.ActiveObject).sc.cfgsc^
       else f_calendar.config^:=def_cfgsc;
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
        ShowMessage(Format(rsNotFoundMayb, [f_search.Num, crlf]) );
      end;
   end;
   until ok or (f_search.ModalResult<>mrOk);
end;
end;

procedure Tf_main.GetChartConfig(var csc:conf_skychart);
begin
if MultiDoc1.ActiveObject is Tf_chart then
 with MultiDoc1.ActiveObject as Tf_chart do
   csc:=sc.cfgsc^
else
   csc:=def_cfgsc;
end;

procedure Tf_main.DrawChart(csc:conf_skychart);
begin
if MultiDoc1.ActiveObject is Tf_chart then
 with MultiDoc1.ActiveObject as Tf_chart do begin
   sc.cfgsc^:=csc;
   Refresh;
end;
end;

procedure Tf_main.OpenConfigExecute(Sender: TObject);
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
     f_config.csc:=sc.cfgsc^;
     f_config.cplot:=sc.plot.cfgplot^;
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
   activateconfig(@f_config.cmain,@f_config.csc,@f_config.ccat,@f_config.cshr,@f_config.cplot,@f_config.cdss,f_config.Applyall.Checked);
 end;

finally
screen.cursor:=crDefault;
end;
end;

procedure Tf_main.ApplyConfig(Sender: TObject);
begin
 activateconfig(@f_config.cmain,@f_config.csc,@f_config.ccat,@f_config.cshr,@f_config.cplot,@f_config.cdss,f_config.Applyall.Checked);
end;

procedure Tf_main.SetupTimeExecute(Sender: TObject);
begin
SetupTimePage(0);
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
ConfigTime.ccat^:=catalog.cfgcat;
ConfigTime.cshr^:=catalog.cfgshr;
ConfigTime.cplot^:=def_cfgplot;
ConfigTime.csc^:=def_cfgsc;
if MultiDoc1.ActiveObject is Tf_chart then with MultiDoc1.ActiveObject as Tf_chart do begin
   ConfigTime.csc^:=sc.cfgsc^;
   ConfigTime.cplot^:=sc.plot.cfgplot^;
end;
cfgm.prgdir:=appdir;
cfgm.persdir:=privatedir;
ConfigTime.cmain^:=cfgm;
formpos(ConfigTime,mouse.cursorpos.x,mouse.cursorpos.y);
ConfigTime.Notebook1.PageIndex:=page;
ConfigTime.showmodal;
if ConfigTime.ModalResult=mrOK then begin
 activateconfig(ConfigTime.cmain,ConfigTime.csc,ConfigTime.ccat,ConfigTime.cshr,ConfigTime.cplot,nil,false);
end;
end;

procedure Tf_main.ApplyConfigTime(Sender: TObject);
begin
 activateconfig(ConfigTime.cmain,ConfigTime.csc,ConfigTime.ccat,ConfigTime.cshr,ConfigTime.cplot,nil,false);
end;

procedure Tf_main.SetupPicturesExecute(Sender: TObject);
begin
SetupPicturesPage(1);
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
ConfigPictures.cdss^:=f_getdss.cfgdss;
ConfigPictures.Fits:=Fits;
ConfigPictures.ccat^:=catalog.cfgcat;
ConfigPictures.cshr^:=catalog.cfgshr;
ConfigPictures.cplot^:=def_cfgplot;
ConfigPictures.csc^:=def_cfgsc;
if MultiDoc1.ActiveObject is Tf_chart then with MultiDoc1.ActiveObject as Tf_chart do begin
   ConfigPictures.csc^:=sc.cfgsc^;
   ConfigPictures.cplot^:=sc.plot.cfgplot^;
end;
cfgm.prgdir:=appdir;
cfgm.persdir:=privatedir;
ConfigPictures.cmain^:=cfgm;
formpos(ConfigPictures,mouse.cursorpos.x,mouse.cursorpos.y);
ConfigPictures.Notebook1.PageIndex:=page;
ConfigPictures.show;
ConfigPictures.backimgChange(self);
ConfigPictures.hide;
ConfigPictures.showmodal;
if ConfigPictures.ModalResult=mrOK then begin
 activateconfig(ConfigPictures.cmain,ConfigPictures.csc,ConfigPictures.ccat,ConfigPictures.cshr,ConfigPictures.cplot,ConfigPictures.cdss,false);
end;
end;

procedure Tf_main.ApplyConfigPictures(Sender: TObject);
begin
 activateconfig(ConfigPictures.cmain,ConfigPictures.csc,ConfigPictures.ccat,ConfigPictures.cshr,ConfigPictures.cplot,ConfigPictures.cdss,false);
end;


procedure Tf_main.SetupObservatoryExecute(Sender: TObject);
begin
SetupObservatoryPage(0);
end;

procedure Tf_main.SetupObservatoryPage(page:integer);
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
ConfigObservatory.ccat^:=catalog.cfgcat;
ConfigObservatory.cshr^:=catalog.cfgshr;
ConfigObservatory.cplot^:=def_cfgplot;
ConfigObservatory.csc^:=def_cfgsc;
if MultiDoc1.ActiveObject is Tf_chart then with MultiDoc1.ActiveObject as Tf_chart do begin
   ConfigObservatory.csc^:=sc.cfgsc^;
   ConfigObservatory.cplot^:=sc.plot.cfgplot^;
end;
cfgm.prgdir:=appdir;
cfgm.persdir:=privatedir;
ConfigObservatory.cmain^:=cfgm;
formpos(ConfigObservatory,mouse.cursorpos.x,mouse.cursorpos.y);
ConfigObservatory.Notebook1.PageIndex:=page;
ConfigObservatory.showmodal;
if ConfigObservatory.ModalResult=mrOK then begin
 activateconfig(ConfigObservatory.cmain,ConfigObservatory.csc,ConfigObservatory.ccat,ConfigObservatory.cshr,ConfigObservatory.cplot,nil,false);
end;
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
ConfigCatalog.ccat^:=catalog.cfgcat;
ConfigCatalog.cshr^:=catalog.cfgshr;
ConfigCatalog.cplot^:=def_cfgplot;
ConfigCatalog.csc^:=def_cfgsc;
if MultiDoc1.ActiveObject is Tf_chart then with MultiDoc1.ActiveObject as Tf_chart do begin
   ConfigCatalog.csc^:=sc.cfgsc^;
   ConfigCatalog.cplot^:=sc.plot.cfgplot^;
end;
cfgm.prgdir:=appdir;
cfgm.persdir:=privatedir;
ConfigCatalog.cmain^:=cfgm;
formpos(ConfigCatalog,mouse.cursorpos.x,mouse.cursorpos.y);
ConfigCatalog.Notebook1.PageIndex:=page;
ConfigCatalog.showmodal;
if ConfigCatalog.ModalResult=mrOK then begin
 ConfigCatalog.ActivateGCat;
 activateconfig(ConfigCatalog.cmain,ConfigCatalog.csc,ConfigCatalog.ccat,ConfigCatalog.cshr,ConfigCatalog.cplot,nil,false);
end;
end;

procedure Tf_main.ApplyConfigCatalog(Sender: TObject);
begin
 ConfigCatalog.ActivateGCat;
 activateconfig(ConfigCatalog.cmain,ConfigCatalog.csc,ConfigCatalog.ccat,ConfigCatalog.cshr,ConfigCatalog.cplot,nil,false);
end;

procedure Tf_main.SetupColourExecute(Sender: TObject);
begin
SetupDisplayPage(1);
end;

procedure Tf_main.SetupDisplayExecute(Sender: TObject);
begin
SetupDisplayPage(0);
end;

procedure Tf_main.SetupFinderExecute(Sender: TObject);
begin
SetupDisplayPage(5);
end;

procedure Tf_main.SetupFontsExecute(Sender: TObject);
begin
SetupDisplayPage(4);
end;

procedure Tf_main.SetupLabelsExecute(Sender: TObject);
begin
SetupDisplayPage(3);
end;

procedure Tf_main.SetupLinesExecute(Sender: TObject);
begin
SetupDisplayPage(2);
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
ConfigDisplay.ccat^:=catalog.cfgcat;
ConfigDisplay.cshr^:=catalog.cfgshr;
ConfigDisplay.cplot^:=def_cfgplot;
ConfigDisplay.csc^:=def_cfgsc;
if MultiDoc1.ActiveObject is Tf_chart then with MultiDoc1.ActiveObject as Tf_chart do begin
   ConfigDisplay.csc^:=sc.cfgsc^;
   ConfigDisplay.cplot^:=sc.plot.cfgplot^;
end;
cfgm.prgdir:=appdir;
cfgm.persdir:=privatedir;
ConfigDisplay.cmain^:=cfgm;
formpos(ConfigDisplay,mouse.cursorpos.x,mouse.cursorpos.y);
case pagegroup of
 0 : begin  //display mode
     ConfigDisplay.Notebook1.Page[0].Visible:=true;
     ConfigDisplay.Notebook1.Pages.Delete(1);
     ConfigDisplay.Notebook1.Pages.Delete(1);
     ConfigDisplay.Notebook1.Pages.Delete(1);
     ConfigDisplay.Notebook1.Pages.Delete(1);
     ConfigDisplay.Notebook1.Pages.Delete(1);
     ConfigDisplay.Notebook1.Pages.Delete(1);
     ConfigDisplay.Notebook1.Pages.Delete(1);
     ConfigDisplay.Notebook1.Pages.Delete(1);
     ConfigDisplay.Notebook1.PageIndex:=0;
     end;
 1 : begin  //colours
     ConfigDisplay.Notebook1.Pages.Delete(0);
     ConfigDisplay.Notebook1.Page[0].Visible:=true;
     ConfigDisplay.Notebook1.Page[1].Visible:=true;
     ConfigDisplay.Notebook1.Page[2].Visible:=true;
     ConfigDisplay.Notebook1.Pages.Delete(3);
     ConfigDisplay.Notebook1.Pages.Delete(3);
     ConfigDisplay.Notebook1.Pages.Delete(3);
     ConfigDisplay.Notebook1.Pages.Delete(3);
     ConfigDisplay.Notebook1.Pages.Delete(3);
     ConfigDisplay.Notebook1.PageIndex:=0;
     end;
 2 : begin  //lines
     ConfigDisplay.Notebook1.Pages.Delete(0);
     ConfigDisplay.Notebook1.Pages.Delete(0);
     ConfigDisplay.Notebook1.Pages.Delete(0);
     ConfigDisplay.Notebook1.Pages.Delete(0);
     ConfigDisplay.Notebook1.Page[0].Visible:=true;
     ConfigDisplay.Notebook1.Pages.Delete(1);
     ConfigDisplay.Notebook1.Pages.Delete(1);
     ConfigDisplay.Notebook1.Pages.Delete(1);
     ConfigDisplay.Notebook1.Pages.Delete(1);
     ConfigDisplay.Notebook1.PageIndex:=0;
     end;
 3 : begin  //labels
     ConfigDisplay.Notebook1.Pages.Delete(0);
     ConfigDisplay.Notebook1.Pages.Delete(0);
     ConfigDisplay.Notebook1.Pages.Delete(0);
     ConfigDisplay.Notebook1.Pages.Delete(0);
     ConfigDisplay.Notebook1.Pages.Delete(0);
     ConfigDisplay.Notebook1.Page[0].Visible:=true;
     ConfigDisplay.Notebook1.Pages.Delete(1);
     ConfigDisplay.Notebook1.Pages.Delete(1);
     ConfigDisplay.Notebook1.Pages.Delete(1);
     ConfigDisplay.Notebook1.PageIndex:=0;
     end;
 4 : begin  //fonts
     ConfigDisplay.Notebook1.Pages.Delete(0);
     ConfigDisplay.Notebook1.Pages.Delete(0);
     ConfigDisplay.Notebook1.Pages.Delete(0);
     ConfigDisplay.Notebook1.Pages.Delete(0);
     ConfigDisplay.Notebook1.Pages.Delete(0);
     ConfigDisplay.Notebook1.Pages.Delete(0);
     ConfigDisplay.Notebook1.Page[0].Visible:=true;
     ConfigDisplay.Notebook1.Pages.Delete(1);
     ConfigDisplay.Notebook1.Pages.Delete(1);
     ConfigDisplay.Notebook1.PageIndex:=0;
     end;
 5 : begin  //finder
     ConfigDisplay.Notebook1.Pages.Delete(0);
     ConfigDisplay.Notebook1.Pages.Delete(0);
     ConfigDisplay.Notebook1.Pages.Delete(0);
     ConfigDisplay.Notebook1.Pages.Delete(0);
     ConfigDisplay.Notebook1.Pages.Delete(0);
     ConfigDisplay.Notebook1.Pages.Delete(0);
     ConfigDisplay.Notebook1.Pages.Delete(0);
     ConfigDisplay.Notebook1.Page[0].Visible:=true;
     ConfigDisplay.Notebook1.Page[1].Visible:=true;
     ConfigDisplay.Notebook1.PageIndex:=0;
     end;
end;

{$ifdef win32}
// Problem with initialization
ConfigDisplay.show;
ConfigDisplay.hide;
ConfigDisplay.ccat^:=catalog.cfgcat;
ConfigDisplay.cshr^:=catalog.cfgshr;
ConfigDisplay.cplot^:=def_cfgplot;
ConfigDisplay.csc^:=def_cfgsc;
if MultiDoc1.ActiveObject is Tf_chart then with MultiDoc1.ActiveObject as Tf_chart do begin
   ConfigDisplay.csc^:=sc.cfgsc^;
   ConfigDisplay.cplot^:=sc.plot.cfgplot^;
end;
cfgm.prgdir:=appdir;
cfgm.persdir:=privatedir;
ConfigDisplay.cmain^:=cfgm;
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
cfgm.dbhost:=f_config.cmain.dbhost;
cfgm.db:=f_config.cmain.db;
cfgm.dbuser:=f_config.cmain.dbuser;
cfgm.dbpass:=f_config.cmain.dbpass;
cfgm.dbport:=f_config.cmain.dbport;
ConnectDB;
end;

procedure Tf_main.SaveAndRestart(Sender: TObject);
begin
cfgm:=f_config.cmain;
if directoryexists(cfgm.prgdir) then appdir:=cfgm.prgdir;
if directoryexists(cfgm.persdir) then privatedir:=cfgm.persdir;
def_cfgsc:=f_config.csc;
catalog.cfgcat:=f_config.ccat;
catalog.cfgshr:=f_config.cshr;
SavePrivateConfig(configfile);
NeedRestart:=true;
Close;
end;

procedure Tf_main.activateconfig(cmain:Pconf_main; csc:Pconf_skychart; ccat:Pconf_catalog; cshr:Pconf_shared; cplot:Pconf_plot; cdss:Pconf_dss; applyall:boolean );
var i:integer;
  themechange,langchange: Boolean;
begin
    themechange:=false; langchange:=false;
    if cmain<>nil then begin
      if (cfgm.language <> cmain^.language) then langchange:=true;
    end;
    if langchange then ChangeLanguage(cmain^.language);
    if cmain<>nil then begin
      if (cfgm.ButtonNight <> cmain^.ButtonNight) or
         (cfgm.ButtonStandard <> cmain^.ButtonStandard) or
         (cfgm.ThemeName <> cmain^.ThemeName)
         then themechange:=true;
      cfgm:=cmain^;
    end;
    if themechange then SetTheme;
    cfgm.updall:=applyall;
    if directoryexists(cfgm.prgdir) then appdir:=cfgm.prgdir;
    if directoryexists(cfgm.persdir) then privatedir:=cfgm.persdir;
    if ccat<>nil then begin
      for i:=0 to ccat^.GCatNum-1 do begin
        if ccat^.GCatLst[i].Actif then begin
          if not
          catalog.GetInfo(ccat^.GCatLst[i].path,
                          ccat^.GCatLst[i].shortname,
                          ccat^.GCatLst[i].magmax,
                          ccat^.GCatLst[i].cattype,
                          ccat^.GCatLst[i].version,
                          ccat^.GCatLst[i].name)
          then ccat^.GCatLst[i].Actif:=false;
        end;
      end;
      catalog.cfgcat:=ccat^;
    end;
    if cdss<>nil then f_getdss.cfgdss:=cdss^;
    if cshr<>nil then catalog.cfgshr:=cshr^;
    if csc<>nil  then def_cfgsc:=csc^;
    if cplot<>nil then def_cfgplot:=cplot^;
    def_cfgplot.starshapesize:=starshape.Picture.bitmap.Width div 11;
    def_cfgplot.starshapew:=def_cfgplot.starshapesize div 2;
    InitFonts;
    catalog.LoadConstellation(cfgm.Constellationfile);
    catalog.LoadConstL(cfgm.ConstLfile);
    catalog.LoadConstB(cfgm.ConstBfile);
    catalog.LoadHorizon(cfgm.horizonfile,@def_cfgsc);
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
       CopySCconfig(def_cfgsc,sc.cfgsc^);
       sc.Fits:=Fits;
       sc.planet:=planet;
       sc.cdb:=cdcdb;
       sc.cfgsc.FindOk:=false;
       sc.plot.cfgplot^:=def_cfgplot;
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
end;

procedure Tf_main.ViewObjectBarExecute(Sender: TObject);
begin
ToolBar4.visible:=not ToolBar4.visible;
ObjectBar1.checked:=ToolBar4.visible;
if not ObjectBar1.checked then ViewToolsBar1.checked:=false;
if MainBar1.checked and ObjectBar1.checked and LeftBar1.checked and RightBar1.checked and ViewStatusBar1.checked then ViewToolsBar1.checked:=true;
ViewTopPanel;
end;

procedure Tf_main.ViewLeftBarExecute(Sender: TObject);
begin
PanelLeft.visible:=not PanelLeft.visible;
LeftBar1.checked:=PanelLeft.visible;
if not LeftBar1.checked then ViewToolsBar1.checked:=false;
if MainBar1.checked and ObjectBar1.checked and LeftBar1.checked and RightBar1.checked and ViewStatusBar1.checked then ViewToolsBar1.checked:=true;
end;

procedure Tf_main.ViewRightBarExecute(Sender: TObject);
begin
PanelRight.visible:=not PanelRight.visible;
RightBar1.checked:=PanelRight.visible;
if not RightBar1.checked then ViewToolsBar1.checked:=false;
if MainBar1.checked and ObjectBar1.checked and LeftBar1.checked and RightBar1.checked and ViewStatusBar1.checked then ViewToolsBar1.checked:=true;
end;

procedure Tf_main.ViewStatusExecute(Sender: TObject);
begin
PanelBottom.visible:=not PanelBottom.visible;
ViewStatusBar1.checked:=PanelBottom.visible;
if not ViewStatusBar1.checked then ViewToolsBar1.checked:=false;
if MainBar1.checked and ObjectBar1.checked and LeftBar1.checked and RightBar1.checked and ViewStatusBar1.checked then ViewToolsBar1.checked:=true;
end;

Procedure Tf_main.InitFonts;
begin
{$ifdef win32}
   font.name:=def_cfgplot.fontname[4];
   font.size:=def_cfgplot.fontsize[4];
   if def_cfgplot.FontBold[4] then font.style:=[fsBold] else font.style:=[];
   if def_cfgplot.FontItalic[4] then font.style:=font.style+[fsItalic];
{$endif}
   LPanels01.Caption:='Ra:22h22m22.22s +22°22''22"22';
   PanelBottom.height:=2*LPanels01.Height+8;
   PPanels0.Width:=LPanels01.width+8;
   Lpanels01.Caption:='';
   Lpanels0.Caption:='';
end;

Procedure Tf_main.SetLPanel1(txt:string; origin:string='';sendmsg:boolean=true;Sender: TObject=nil);
begin
if traceon then writetrace(txt);
LPanels1.Caption:=wordspace(stringreplace(txt,tab,blank,[rfReplaceall]));
if sendmsg then SendInfo(Sender,origin,txt);
// refresh tracking object
if MultiDoc1.ActiveObject is Tf_chart then with (MultiDoc1.ActiveObject as Tf_chart) do begin
    if sc.cfgsc.TrackOn then
       ToolButtonTrack.Hint:=rsUnlockChart
     else if ((sc.cfgsc.TrackType>=1)and(sc.cfgsc.TrackType<=3))or(sc.cfgsc.TrackType=6)
     then
       ToolButtonTrack.Hint:=Format(rsLockOn, [sc.cfgsc.Trackname])
     else
       ToolButtonTrack.Hint:=rsNoObjectToLo;
     if f_manualtelescope.visible then  f_manualtelescope.SetTurn(sc.cfgsc.FindNote);
end;
end;

Procedure Tf_main.SetLPanel0(txt:string);
begin
LPanels0.Caption:=txt;
end;

Procedure Tf_main.SetTopMessage(txt:string);
begin
// set the message that appear in the menu bar
topmsg:=txt;
if cfgm.ShowChartInfo then topmessage.caption:=topmsg
   else topmessage.caption:=' ';
end;

procedure Tf_main.FormResize(Sender: TObject);
begin

end;

procedure Tf_main.SetDefault;
var i:integer;
    buf:string;
begin
nightvision:=false;
ldeg:='°';
lmin:='''';
lsec:='"';
cfgm.MaxChildID:=0;
cfgm.prtname:='';
cfgm.configpage:=0;
cfgm.configpage_i:=0;
cfgm.configpage_j:=0;
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
cfgm.keepalive:=false;
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
cfgm.ProxyHost:='';
cfgm.ProxyPort:='';
cfgm.ProxyUser:='';
cfgm.ProxyPass:='';
cfgm.AnonPass:='skychart@';
cfgm.CometUrlList:=TStringList.Create;
cfgm.CometUrlList.Add(URL_HTTPCometElements);
cfgm.AsteroidUrlList:=TStringList.Create;
buf:=stringreplace(URL_HTTPAsteroidElements1,'$YYYY',FormatDateTime('yyyy',now),[]);
cfgm.AsteroidUrlList.Add(buf);
buf:=stringreplace(URL_HTTPAsteroidElements2,'$YYYY',FormatDateTime('yyyy',now),[]);
cfgm.AsteroidUrlList.Add(buf);
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
def_cfgplot.magsize:=4;
def_cfgplot.saturation:=192;
cfgm.Constellationfile:=slash(appdir)+'data'+Pathdelim+'constellation'+Pathdelim+'constlabel.cla';
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
def_cfgsc.ObsTZ := GetTimezone ;
def_cfgsc.DST := false;
def_cfgsc.ObsTemperature := 10 ;
def_cfgsc.ObsPressure := 1010 ;
def_cfgsc.ObsName := 'Genève' ;
def_cfgsc.ObsCountry := 'Switzerland' ;
def_cfgsc.horizonopaque:=true;
def_cfgsc.ShowHorizon:=false;
def_cfgsc.ShowHorizonDepression:=false;
def_cfgsc.HorizonMax:=0;
def_cfgsc.PMon:=false;
def_cfgsc.DrawPMon:=false;
def_cfgsc.DrawPMyear:=1000;
def_cfgsc.ApparentPos:=false;
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
def_cfgsc.SimD:=1;
def_cfgsc.SimH:=0;
def_cfgsc.SimM:=0;
def_cfgsc.SimS:=0;
def_cfgsc.SimLine:=True;
for i:=1 to NumSimObject do def_cfgsc.SimObject[i]:=true;
def_cfgsc.ShowPlanet:=true;
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
def_cfgsc.IndiDriver:='lx200generic';
def_cfgsc.IndiPort:='/dev/ttyS0';
def_cfgsc.IndiDevice:='LX200 Generic';
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
catalog.cfgshr.EquinoxType:=0;
catalog.cfgshr.EquinoxChart:='J2000';
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
catalog.cfgcat.GCatNum:=0;
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
//if config_version<cdcver then UpdateConfig;
end;

procedure Tf_main.ReadChartConfig(filename:string; usecatalog,resizemain:boolean; var cplot:conf_plot ;var csc:conf_skychart);
var i:integer;
    inif: TMemIniFile;
    section,buf : string;
begin
inif:=TMeminifile.create(filename);
try
with inif do begin
section:='main';
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
cplot.TransparentPlanet:=ReadBool(section,'TransparentPlanet',cplot.TransparentPlanet);
cplot.plaplot:=ReadInteger(section,'plaplot',cplot.plaplot);
cplot.Nebgray:=ReadInteger(section,'Nebgray',cplot.Nebgray);
cplot.NebBright:=ReadInteger(section,'NebBright',cplot.NebBright);
cplot.contrast:=ReadInteger(section,'contrast',cplot.contrast);
cplot.saturation:=ReadInteger(section,'saturation',cplot.saturation);
cplot.partsize:=ReadFloat(section,'partsize',cplot.partsize);
cplot.magsize:=ReadFloat(section,'magsize',cplot.magsize);
cplot.AutoSkycolor:=ReadBool(section,'AutoSkycolor',cplot.AutoSkycolor);
for i:=0 to maxcolor do cplot.color[i]:=ReadInteger(section,'color'+inttostr(i),cplot.color[i]);
for i:=1 to 7 do cplot.skycolor[i]:=ReadInteger(section,'skycolor'+inttostr(i),cplot.skycolor[i]);
cplot.bgColor:=ReadInteger(section,'bgColor',cplot.bgColor);
section:='grid';
for i:=0 to maxfield do catalog.cfgshr.HourGridSpacing[i]:=ReadFloat(section,'HourGridSpacing'+inttostr(i),catalog.cfgshr.HourGridSpacing[i] );
for i:=0 to maxfield do catalog.cfgshr.DegreeGridSpacing[i]:=ReadFloat(section,'DegreeGridSpacing'+inttostr(i),catalog.cfgshr.DegreeGridSpacing[i] );
section:='Finder';
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
section:='chart';
catalog.cfgshr.EquinoxType:=ReadInteger(section,'EquinoxType',catalog.cfgshr.EquinoxType);
catalog.cfgshr.EquinoxChart:=ReadString(section,'EquinoxChart',catalog.cfgshr.EquinoxChart);
catalog.cfgshr.DefaultJDchart:=ReadFloat(section,'DefaultJDchart',catalog.cfgshr.DefaultJDchart);
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
csc.PMon:=ReadBool(section,'PMon',csc.PMon);
csc.DrawPMon:=ReadBool(section,'DrawPMon',csc.DrawPMon);
csc.ApparentPos:=ReadBool(section,'ApparentPos',csc.ApparentPos);
csc.DrawPMyear:=ReadInteger(section,'DrawPMyear',csc.DrawPMyear);
csc.horizonopaque:=ReadBool(section,'horizonopaque',csc.horizonopaque);
csc.ShowHorizon:=ReadBool(section,'ShowHorizon',csc.ShowHorizon);
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
csc.ShowPlanet:=ReadBool(section,'ShowPlanet',csc.ShowPlanet);
csc.ShowAsteroid:=ReadBool(section,'ShowAsteroid',csc.ShowAsteroid);
csc.ShowComet:=ReadBool(section,'ShowComet',csc.ShowComet);
csc.ShowImages:=ReadBool(section,'ShowImages',csc.ShowImages);
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
csc.ConstFullLabel:=ReadBool(section,'ConstFullLabel',csc.ConstFullLabel);
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
section:='observatory';
csc.ObsLatitude := ReadFloat(section,'ObsLatitude',csc.ObsLatitude );
csc.ObsLongitude := ReadFloat(section,'ObsLongitude',csc.ObsLongitude );
csc.ObsAltitude := ReadFloat(section,'ObsAltitude',csc.ObsAltitude );
csc.ObsTemperature := ReadFloat(section,'ObsTemperature',csc.ObsTemperature );
csc.ObsPressure := ReadFloat(section,'ObsPressure',csc.ObsPressure );
csc.ObsName := ReadString(section,'ObsName',csc.ObsName );
csc.ObsCountry := ReadString(section,'ObsCountry',csc.ObsCountry );
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
csc.DST:=ReadBool(section,'DST',csc.DST);
section:='projection';
for i:=1 to maxfield do csc.projname[i]:=ReadString(section,'ProjName'+inttostr(i),csc.projname[i] );
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
   csc.modlabels[i].hiden:=ReadBool(section,'labelhiden'+inttostr(i),false);
end;
section:='custom_labels';
csc.poscustomlabels:=ReadInteger(section,'poslabels',0);
csc.numcustomlabels:=ReadInteger(section,'numlabels',0);
for i:=1 to csc.numcustomlabels do begin
   csc.customlabels[i].ra:=ReadFloat(section,'labelra'+inttostr(i),0);
   csc.customlabels[i].dec:=ReadFloat(section,'labeldec'+inttostr(i),0);
   csc.customlabels[i].labelnum:=ReadInteger(section,'labelnum'+inttostr(i),7);
   csc.customlabels[i].txt:=ReadString(section,'labeltxt'+inttostr(i),'');
end;
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
cfgm.PrinterResolution:=ReadInteger(section,'PrinterResolution',cfgm.PrinterResolution);
cfgm.PrintColor:=ReadInteger(section,'PrintColor',cfgm.PrintColor);
cfgm.PrintLandscape:=ReadBool(section,'PrintLandscape',cfgm.PrintLandscape);
cfgm.PrintMethod:=ReadInteger(section,'PrintMethod',cfgm.PrintMethod);
cfgm.PrintCmd1:=ReadString(section,'PrintCmd1',cfgm.PrintCmd1);
cfgm.PrintCmd2:=ReadString(section,'PrintCmd2',cfgm.PrintCmd2);
cfgm.PrintTmpPath:=ReadString(section,'PrintTmpPath',cfgm.PrintTmpPath);
cfgm.PrtLeftMargin:=ReadInteger(section,'PrtLeftMargin',cfgm.PrtLeftMargin);
cfgm.PrtRightMargin:=ReadInteger(section,'PrtRightMargin',cfgm.PrtRightMargin);
cfgm.PrtTopMargin:=ReadInteger(section,'PrtTopMargin',cfgm.PrtTopMargin);
cfgm.PrtBottomMargin:=ReadInteger(section,'PrtBottomMargin',cfgm.PrtBottomMargin);
cfgm.ThemeName:=ReadString(section,'Theme',cfgm.ThemeName);
if (ReadBool(section,'WinMaximize',true)) then f_main.WindowState:=wsMaximized;
cfgm.autorefreshdelay:=ReadInteger(section,'autorefreshdelay',cfgm.autorefreshdelay);
cfgm.Constellationfile:=ReadString(section,'Constellationfile',cfgm.Constellationfile);
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
MainBar1.checked:=ToolBar1.visible;
ObjectBar1.checked:=ToolBar4.visible;
LeftBar1.checked:=PanelLeft.visible;
RightBar1.checked:=PanelRight.visible;
ViewToolsBar1.checked:=(MainBar1.checked and ObjectBar1.checked and LeftBar1.checked and RightBar1.checked);
ViewTopPanel;
InitialChartNum:=ReadInteger(section,'NumChart',0);
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
section:='dss';
f_getdss.cfgdss.dssnorth:=ReadBool(section,'dssnorth',false);
f_getdss.cfgdss.dsssouth:=ReadBool(section,'dsssouth',false);
f_getdss.cfgdss.dss102:=ReadBool(section,'dss102',false);
f_getdss.cfgdss.dsssampling:=ReadBool(section,'dsssampling',true);
f_getdss.cfgdss.dssplateprompt:=ReadBool(section,'dssplateprompt',true);
f_getdss.cfgdss.dssmaxsize:=ReadInteger(section,'dssmaxsize',2048);
f_getdss.cfgdss.dssdir:=ReadString(section,'dssdir',slash('cat')+'RealSky');
f_getdss.cfgdss.dssdrive:=ReadString(section,'dssdrive',default_dssdrive);
f_getdss.cfgdss.dssfile:=ReadString(section,'dssfile',slash(privatedir)+slash('pictures')+'$temp.fit');
for i:=1 to MaxDSSurl do begin
  f_getdss.cfgdss.DSSurl[i,0]:=ReadString(section,'DSSurlName'+inttostr(i),f_getdss.cfgdss.DSSurl[i,0]);
  f_getdss.cfgdss.DSSurl[i,1]:=ReadString(section,'DSSurl'+inttostr(i),f_getdss.cfgdss.DSSurl[i,1]);
end;
f_getdss.cfgdss.OnlineDSS:=ReadBool(section,'OnlineDSS',f_getdss.cfgdss.OnlineDSS);
f_getdss.cfgdss.OnlineDSSid:=ReadInteger(section,'OnlineDSSid',f_getdss.cfgdss.OnlineDSSid);
section:='quicksearch';
j:=min(MaxQuickSearch,ReadInteger(section,'count',0));
for i:=1 to j do quicksearch.Items.Add(ReadString(section,'item'+inttostr(i),''));
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
end;
if Config_Version < '3.0.0.8' then begin
   cfgm.dbpass:=cryptedpwd;
end;
SaveDefault;
end;

procedure Tf_main.SaveDefault;
var i,j: integer;
begin
SavePrivateConfig(configfile);
SaveChartConfig(configfile,MultiDoc1.ActiveChild);
j:=0;
for i:=0 to MultiDoc1.ChildCount-1 do
  if (MultiDoc1.Childs[i].DockedObject is Tf_chart) and (MultiDoc1.Childs[i].DockedObject<>MultiDoc1.ActiveObject) then begin
     inc(j);
     SaveChartConfig(configfile+inttostr(j),MultiDoc1.Childs[i]);
  end;
end;

procedure Tf_main.SaveChartConfig(filename:string; child: TChildDoc);
var i:integer;
    inif: TMemIniFile;
    section : string;
    cplot:conf_plot ;
    csc:conf_skychart;
begin
if (child<>nil) and (child.DockedObject is Tf_chart) then with child.DockedObject as Tf_chart do begin
  cplot:=sc.plot.cfgplot^;
  csc:=sc.cfgsc^;
end
else begin
  cplot:=def_cfgplot;
  csc:=def_cfgsc;
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
WriteFloat(section,'partsize',cplot.partsize);
WriteFloat(section,'magsize',cplot.magsize);
WriteBool(section,'AutoSkycolor',cplot.AutoSkycolor);
for i:=0 to maxcolor do WriteInteger(section,'color'+inttostr(i),cplot.color[i]);
for i:=1 to 7 do WriteInteger(section,'skycolor'+inttostr(i),cplot.skycolor[i]);
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
for i:=0 to maxfield do WriteFloat(section,'HourGridSpacing'+inttostr(i),catalog.cfgshr.HourGridSpacing[i] );
for i:=0 to maxfield do WriteFloat(section,'DegreeGridSpacing'+inttostr(i),catalog.cfgshr.DegreeGridSpacing[i] );
section:='Finder';
for i:=1 to 10 do WriteFloat(section,'Circle'+inttostr(i),csc.circle[i,1]);
for i:=1 to 10 do WriteFloat(section,'CircleR'+inttostr(i),csc.circle[i,2]);
for i:=1 to 10 do WriteFloat(section,'CircleOffset'+inttostr(i),csc.circle[i,3]);
for i:=1 to 10 do WriteBool(section,'ShowCircle'+inttostr(i),csc.circleok[i]);
for i:=1 to 10 do WriteString(section,'CircleLbl'+inttostr(i),csc.circlelbl[i]);
for i:=1 to 10 do WriteFloat(section,'RectangleW'+inttostr(i),csc.rectangle[i,1]);
for i:=1 to 10 do WriteFloat(section,'RectangleH'+inttostr(i),csc.rectangle[i,2]);
for i:=1 to 10 do WriteFloat(section,'RectangleR'+inttostr(i),csc.rectangle[i,3]);
for i:=1 to 10 do WriteFloat(section,'RectangleOffset'+inttostr(i),csc.rectangle[i,4]);
for i:=1 to 10 do WriteBool(section,'ShowRectangle'+inttostr(i),csc.rectangleok[i]);
for i:=1 to 10 do WriteString(section,'RectangleLbl'+inttostr(i),csc.rectanglelbl[i]);
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
WriteBool(section,'PMon',csc.PMon);
WriteBool(section,'DrawPMon',csc.DrawPMon);
WriteBool(section,'ApparentPos',csc.ApparentPos);
WriteInteger(section,'DrawPMyear',csc.DrawPMyear);
WriteBool(section,'horizonopaque',csc.horizonopaque);
WriteBool(section,'ShowHorizon',csc.ShowHorizon);
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
WriteBool(section,'ShowPlanet',csc.ShowPlanet);
WriteBool(section,'ShowAsteroid',csc.ShowAsteroid);
WriteBool(section,'ShowComet',csc.ShowComet);
WriteBool(section,'ShowImages',csc.ShowImages);
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
WriteBool(section,'ConstFullLabel',csc.ConstFullLabel);
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
WriteString(section,'ObsName',csc.ObsName );
WriteString(section,'ObsCountry',csc.ObsCountry );
WriteFloat(section,'ObsTZ',csc.ObsTZ );
section:='date';
WriteBool(section,'UseSystemTime',csc.UseSystemTime);
WriteInteger(section,'CurYear',csc.CurYear);
WriteInteger(section,'CurMonth',csc.CurMonth);
WriteInteger(section,'CurDay',csc.CurDay);
WriteFloat(section,'CurTime',csc.CurTime);
WriteBool(section,'autorefresh',csc.autorefresh);
WriteBool(section,'Force_DT_UT',csc.Force_DT_UT);
WriteFloat(section,'DT_UT_val',csc.DT_UT_val);
WriteBool(section,'DST',csc.DST);
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
end;
Updatefile;
end;
finally
 inif.Free;
end;
end;

procedure Tf_main.SavePrivateConfig(filename:string);
var i,j:integer;
    inif: TMemIniFile;
    section : string;
begin
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
{$ifdef win32}
WriteBool(section,'use_xplanet',use_xplanet);
WriteString(section,'xplanet_dir',xplanet_dir);
{$endif}
WriteBool(section,'NightVision',NightVision);
WriteString(section,'language',cfgm.language);
WriteString(section,'prtname',cfgm.prtname);
WriteInteger(section,'PrinterResolution',cfgm.PrinterResolution);
WriteInteger(section,'PrintColor',cfgm.PrintColor);
WriteBool(section,'PrintLandscape',cfgm.PrintLandscape);
WriteInteger(section,'PrintMethod',cfgm.PrintMethod);
WriteString(section,'PrintCmd1',cfgm.PrintCmd1);
WriteString(section,'PrintCmd2',cfgm.PrintCmd2);
WriteString(section,'PrintTmpPath',cfgm.PrintTmpPath);
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
WriteString(section,'Constellationfile',cfgm.Constellationfile);
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
WriteString(section,'dssfile',f_getdss.cfgdss.dssfile);
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
end;

procedure Tf_main.SaveQuickSearch(filename:string);
var i,j:integer;
    inif: TMemIniFile;
    section : string;
    {$ifdef win32}
    instini: TIniFile;
    {$endif}
begin
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
{$ifdef win32}
 // hard to locate the main .ini file, the location depend on the Windows version
 // put this one in the system default location (C:\windows) to locate the install path
 // To be read by external software only
 instini:=TIniFile.Create('cdc_install.ini');
 instini.WriteString('Default','Install_Dir',appdir);
 instini.free;
{$endif}
end;

procedure Tf_main.SaveConfigOnExitExecute(Sender: TObject);
var inif: TMemIniFile;
    section : string;
begin
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
end;

procedure Tf_main.ChangeLanguage(lang:string);
var inif: TMemIniFile;
    i: integer;
begin
cfgm.language:=lang;
inif:=TMeminifile.create(configfile);
try
with inif do begin
  WriteString('main','language',cfgm.language);
  Updatefile;
end;
finally
 inif.Free;
end;
u_translation.translate(cfgm.language,'en');
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
if f_about<>nil then f_about.SetLang;
if f_config<>nil then f_config.SetLang;

end;

procedure Tf_main.SetLang;
var i:integer;
begin
if cfgm.language='' then helpdir:=slash(appdir)+slash('doc')+slash('en')
   else helpdir:=slash(appdir)+slash('doc')+slash(trim(cfgm.language));
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
ToolButtonPosition.hint:=rsPosition;
ToolButtonListObj.hint:=rsObjectList;
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
ToolButtonDSS.hint:=rsGetDSSImage;
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
ToolButtonShowObjectbelowHorizon.hint:=rsShowObjectBe;
ToolButtonswitchbackground.hint:=rsSkyBackgroun;
ToolButtonSyncChart.hint:=rsLinkAllChart;
ToolButtonTrack.hint:=rsNoObjectToLo;
ToolButtonswitchstars.hint:=rsChangeDrawin;
File1.caption:=rsFile;
FileNewItem.caption:=rsNewChart;
FileOpenItem.caption:=rsOpen;
FileSaveAsItem.caption:=rsSaveAs;
SaveImage1.caption:=rsSaveImage;
FileCloseItem.caption:=rsCloseChart;
Calendar1.caption:=rsCalendar;
Print2.caption:=rsPrint;
PrintSetup2.caption:=rsPrinterSetup;
FileExitItem.caption:=rsExit;
Edit1.caption:=rsEdit;
CopyItem.caption:=rsCopy;
Undo1.caption:=rsUndo;
Redo1.caption:=rsRedo;
Setup1.caption:=rsSetup;
Configuration1.caption:=rsconfigurethe;
SaveConfigurationNow1.caption:=rsSaveConfigur;
SaveConfigurationOnExit1.caption:=rsSaveConfigur2;
DateConfig1.caption:=rsDateTime;
ObsConfig1.caption:=rsObservatory;
MenuItem1.caption:=rsDisplayMode;
MenuItem2.caption:=rsColor;
MenuItem3.caption:=rsLines;
MenuItem4.caption:=rsLabels;
MenuItem5.caption:=rsFonts;
MenuItem6.caption:=rsFinderMark;
MenuItem7.caption:=rsPictures;
MenuItem8.caption:=rsShowHideDSSI;
MenuItem9.caption:=rsCatalog;
View1.caption:=rsView;
FullScreen1.caption:=rsViewFullScre;
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
ileVertically1.caption:=rsZoomIn;
zoomminus1.caption:=rsZoomOut;
Chart1.caption:=rsChart;
Projection1.caption:=rsProjection;
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
elescope1.caption:=rsTelescope;
elescopeConnect1.caption:=rsConnect;
ControlPanel1.caption:=rsControlPanel;
elescopeSlew1.caption:=rsSlew;
elescopeSync1.caption:=rsSync;
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
ButtonMoreStar.Hint:=rsMoreStars;
ButtonLessStar.Hint:=rsLessStars;
ButtonMoreNeb.Hint:=rsMoreNebulae;
ButtonLessNeb.Hint:=rsLessNebulae;
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
label findit;
begin
result:=false;
if trim(num)='' then exit;
chart:=nil;
if cname='' then begin
  if MultiDoc1.ActiveObject is Tf_chart then chart:=MultiDoc1.ActiveObject;
end else begin
 for i:=0 to MultiDoc1.ChildCount-1 do
   if MultiDoc1.Childs[i].DockedObject is Tf_chart then
      if MultiDoc1.Childs[i].caption=cname then chart:=MultiDoc1.Childs[i].DockedObject;
end;
if chart is Tf_chart then with chart as Tf_chart do begin
   ok:=catalog.SearchNebulae(Num,ar1,de1) ;
   if ok then goto findit;
   ok:=catalog.SearchStar(Num,ar1,de1) ;
   if ok then goto findit;
   ok:=catalog.SearchDblStar(Num,ar1,de1) ;
   if ok then goto findit;
   ok:=catalog.SearchVarStar(Num,ar1,de1) ;
   if ok then goto findit;
   ok:=planet.FindPlanetName(trim(Num),ar1,de1,sc.cfgsc);
   if ok then goto findit;
   ok:=planet.FindAsteroidName(trim(Num),ar1,de1,sc.cfgsc);
   if ok then goto findit;
   ok:=planet.FindCometName(trim(Num),ar1,de1,sc.cfgsc);
   if ok then goto findit;
   ok:=catalog.SearchStarName(Num,ar1,de1) ;
   if ok then goto findit;
   ok:=f_search.SearchNebName(Num,ar1,de1) ;
   if ok then goto findit;

Findit:
   result:=ok;
   if ok then begin
      sc.cfgsc.TrackOn:=false;
      IdentLabel.visible:=false;
      precession(jd2000,sc.cfgsc.JDchart,ar1,de1);
      sc.movetoradec(ar1,de1);
      Refresh;
      if sc.cfgsc.fov>0.17 then sc.FindatRaDec(ar1,de1,0.0005,true)
                        else sc.FindatRaDec(ar1,de1,0.00005,true);
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
    ToolButtonswitchbackground.Enabled:=(sc.cfgsc.Projpole=altaz);
    ToolButtonSyncChart.down:=cfgm.SyncChart;
    ToolButtonTrack.down:=sc.cfgsc.TrackOn;
    if sc.cfgsc.TrackOn then
       ToolButtonTrack.Hint:=rsUnlockChart
     else if ((sc.cfgsc.TrackType>=1)and(sc.cfgsc.TrackType<=3))or(sc.cfgsc.TrackType=6)
     then
       ToolButtonTrack.Hint:=Format(rsLockOn, [sc.cfgsc.Trackname])
     else
       ToolButtonTrack.Hint:=rsNoObjectToLo;
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
  application.processmessages; 
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
for i:=1 to MaxWindow do ThrdActive[i]:=false;
sock:=TTCPBlockSocket.create;
try
  with sock do
    begin
      CreateSocket;
      if lasterror<>0 then Synchronize(ShowError);
      MaxLineLength:=1024;
      setLinger(true,10);
      if lasterror<>0 then Synchronize(ShowError);
      bind(f_main.cfgm.ServerIPaddr,f_main.cfgm.ServerIPport);
      if lasterror<>0 then Synchronize(ShowError);
      listen;
      if lasterror<>0 then Synchronize(ShowError);
      Synchronize(ShowSocket);
      repeat
        if terminated then break;
        if canread(1000) and (not terminated) then
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
  terminate;
  Sock.CloseSocket;
  Sock.free;
end;
end;

Constructor TTCPThrd.Create(Hsock:TSocket);
begin
  Csock := Hsock;
  FreeOnTerminate:=true;
  cmd:=TStringlist.create;
  keepalive:=false;
  abort:=false;
  inherited create(false);
end;

procedure TTCPThrd.Execute;
var
  s: string;
  i: integer;
begin
  Fsock:=TTCPBlockSocket.create;
  FConnectTime:=now;
  try
    Fsock.socket:=CSock;
    Fsock.GetSins;
    Fsock.MaxLineLength:=1024;
    remoteip:=Fsock.GetRemoteSinIP;
    remoteport:=inttostr(Fsock.GetRemoteSinPort);
    with Fsock do
      begin
        repeat
          if terminated then break;
          s := RecvString(1000);
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
                SendString('.'+crlf);        // keepalive check
                if lastError<>0 then break;  // if send failed we close the connection
          end;
        until false;
      end;
  finally
    terminate;
    f_main.TCPDaemon.ThrdActive[id]:=false;
    Fsock.SendString(msgBye+crlf);
    Fsock.CloseSocket;
    Fsock.Free;
    cmd.free;
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
cmdresult:=f_main.ExecuteCmd(active_chart,cmd);
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
//    d :double;
begin
if TCPDaemon=nil then exit;
try
screen.cursor:=crHourglass;
for i:=1 to Maxwindow do
 if (TCPDaemon.TCPThrd[i]<>nil) then
    TCPDaemon.TCPThrd[i].terminate;
application.processmessages;
TCPDaemon.terminate;
//d:=now+1.7E-5;  // 1.5 seconde delay to close the thread
//while now<d do application.processmessages;
screen.cursor:=crDefault;
except
 screen.cursor:=crDefault;
end;
end;

procedure Tf_main.ConnectDB;
begin
try
    NeedToInitializeDB:=false;
    if ((DBtype=sqlite) and not Fileexists(cfgm.db)) then
       ForceDirectories(Extractfilepath(cfgm.db));
    if (cdcdb.ConnectDB(cfgm.dbhost,cfgm.db,cfgm.dbuser,cfgm.dbpass,cfgm.dbport)
       and cdcdb.CheckDB) then begin
          planet.ConnectDB(cfgm.dbhost,cfgm.db,cfgm.dbuser,cfgm.dbpass,cfgm.dbport);
          Fits.ConnectDB(cfgm.dbhost,cfgm.db,cfgm.dbuser,cfgm.dbpass,cfgm.dbport);
          SetLpanel1(Format(rsConnectedToS, [cfgm.db]));
    end else begin
          SetLpanel1(rsSQLDatabaseN);
          def_cfgsc.ShowAsteroid:=false;
          def_cfgsc.ShowComet:=false;
          def_cfgsc.ShowImages:=false;
    end;
    if NeedToInitializeDB then begin
       f_info.setpage(2);
       f_info.show;
       f_info.ProgressMemo.lines.add(rsInitializeDa);
       cdcdb.LoadSampleData(f_info.ProgressMemo);
       Planet.PrepareAsteroid(DateTimetoJD(now), f_info.ProgressMemo.lines);
       def_cfgsc.ShowAsteroid:=true;
       f_info.close;
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
  quicksearch.Enabled:=true;
  TimeVal.Enabled:=true;
  TimeU.Enabled:=true;
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
begin
 if nightvision then
    SetNightVision(true)
 else
    SetButtonImage(cfgm.ButtonStandard);
end;

procedure Tf_main.SetButtonImage(button: Integer);
var btn : TBitmap;
    col: Tcolor;
    i: Integer;
    iconpath: String;
begin
btn:=TBitmap.Create;
btn.canvas.pen.color:=clBlack;
btn.canvas.brush.color:=clBlack;
btn.canvas.brush.style:=bsSolid;
col:=clNavy;
try
case button of
 1:begin    // color
   ImageNormal.Clear;
   iconpath:=slash(appdir)+slash('data')+slash('Themes')+slash(cfgm.ThemeName)+slash('icon_color');
     for i:=0 to ImageListCount-1 do begin
       try
         btn.LoadFromFile(iconpath+'i'+inttostr(i)+'.xpm');
         ImageNormal.Add(btn,nil);
         btn:=TBitmap.Create;
       except
       end;
     end;
   ActionList1.Images:=ImageNormal;
   Toolbar1.Images:=ImageNormal;
   Toolbar2.Images:=ImageNormal;
   Toolbar3.Images:=ImageNormal;
   Toolbar4.Images:=ImageNormal;
   BtnCloseChild.Glyph.LoadFromLazarusResource('CLOSE');
   BtnRestoreChild.Glyph.LoadFromLazarusResource('RESTORE');
   ImageNormal.GetBitmap(52,btn); ButtonMoreStar.Picture.Assign(btn);
   btn.canvas.rectangle(0,0,btn.width,btn.height);
   ImageNormal.GetBitmap(53,btn); ButtonLessStar.Picture.Assign(btn);
   btn.canvas.rectangle(0,0,btn.width,btn.height);
   ImageNormal.GetBitmap(54,btn); ButtonMoreNeb.Picture.Assign(btn);
   btn.canvas.rectangle(0,0,btn.width,btn.height);
   ImageNormal.GetBitmap(55,btn); ButtonLessNeb.Picture.Assign(btn);
   end;
 2:begin  // red
   ImageList2.Clear;
   iconpath:=slash(appdir)+slash('data')+slash('Themes')+slash(cfgm.ThemeName)+slash('icon_red');
     for i:=0 to ImageListCount-1 do begin
       try
         btn.LoadFromFile(iconpath+'i'+inttostr(i)+'.xpm');
         ImageList2.Add(btn,nil);
         btn:=TBitmap.Create;
       except
       end;
     end;
   BtnCloseChild.Glyph.LoadFromFile(iconpath+'b1.xpm');
   BtnRestoreChild.Glyph.LoadFromFile(iconpath+'b2.xpm');
   col:=$acb5f5;
   ActionList1.Images:=ImageList2;
   Toolbar1.Images:=ImageList2;
   Toolbar2.Images:=ImageList2;
   Toolbar3.Images:=ImageList2;
   Toolbar4.Images:=ImageList2;
   ImageList2.GetBitmap(52,btn); ButtonMoreStar.Picture.Assign(btn);
   btn.canvas.rectangle(0,0,btn.width,btn.height);
   ImageList2.GetBitmap(53,btn); ButtonLessStar.Picture.Assign(btn);
   btn.canvas.rectangle(0,0,btn.width,btn.height);
   ImageList2.GetBitmap(54,btn); ButtonMoreNeb.Picture.Assign(btn);
   btn.canvas.rectangle(0,0,btn.width,btn.height);
   ImageList2.GetBitmap(55,btn); ButtonLessNeb.Picture.Assign(btn);
   end;
 3:begin   // blue
   ImageList2.Clear;
   iconpath:=slash(appdir)+slash('data')+slash('Themes')+slash(cfgm.ThemeName)+slash('icon_blue');
     for i:=0 to ImageListCount-1 do begin
       try
         btn.LoadFromFile(iconpath+'i'+inttostr(i)+'.xpm');
         ImageList2.Add(btn,nil);
         btn:=TBitmap.Create;
       except
       end;
     end;
   BtnCloseChild.Glyph.LoadFromFile(iconpath+'b1.xpm');
   BtnRestoreChild.Glyph.LoadFromFile(iconpath+'b2.xpm');
   ActionList1.Images:=ImageList2;
   Toolbar1.Images:=ImageList2;
   Toolbar2.Images:=ImageList2;
   Toolbar3.Images:=ImageList2;
   Toolbar4.Images:=ImageList2;
   ImageList2.GetBitmap(52,btn); ButtonMoreStar.Picture.Assign(btn);
   btn.canvas.rectangle(0,0,btn.width,btn.height);
   ImageList2.GetBitmap(53,btn); ButtonLessStar.Picture.Assign(btn);
   btn.canvas.rectangle(0,0,btn.width,btn.height);
   ImageList2.GetBitmap(54,btn); ButtonMoreNeb.Picture.Assign(btn);
   btn.canvas.rectangle(0,0,btn.width,btn.height);
   ImageList2.GetBitmap(55,btn); ButtonLessNeb.Picture.Assign(btn);
   end;
 4:begin   // Green
   ImageList2.Clear;
   iconpath:=slash(appdir)+slash('data')+slash('Themes')+slash(cfgm.ThemeName)+slash('icon_green');
     for i:=0 to ImageListCount-1 do begin
       try
         btn.LoadFromFile(iconpath+'i'+inttostr(i)+'.xpm');
         ImageList2.Add(btn,nil);
         btn:=TBitmap.Create;
       except
       end;
     end;
   BtnCloseChild.Glyph.LoadFromFile(iconpath+'b1.xpm');
   BtnRestoreChild.Glyph.LoadFromFile(iconpath+'b2.xpm');
   col:=clLime;
   ActionList1.Images:=ImageList2;
   Toolbar1.Images:=ImageList2;
   Toolbar2.Images:=ImageList2;
   Toolbar3.Images:=ImageList2;
   Toolbar4.Images:=ImageList2;
   ImageList2.GetBitmap(52,btn); ButtonMoreStar.Picture.Assign(btn);
   btn.canvas.rectangle(0,0,btn.width,btn.height);
   ImageList2.GetBitmap(53,btn); ButtonLessStar.Picture.Assign(btn);
   btn.canvas.rectangle(0,0,btn.width,btn.height);
   ImageList2.GetBitmap(54,btn); ButtonMoreNeb.Picture.Assign(btn);
   btn.canvas.rectangle(0,0,btn.width,btn.height);
   ImageList2.GetBitmap(55,btn); ButtonLessNeb.Picture.Assign(btn);
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
btn.Free;
except
end;
end;
{ code to save the image list to individual files
   for i:=0 to ImageNormal.Count-1 do begin
     ImageNormal.GetBitmap(i,btn);
     btn.SavetoFile('/home/cdc/src/skychart/bitmaps/icon_color/i'+inttostr(i)+'.xpm');
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
if (MultiDoc1.ActiveObject is Tf_chart)and (Activecontrol=nil) then
   (MultiDoc1.ActiveObject as Tf_chart).FormKeyDown(Sender,Key,Shift);
end;

procedure Tf_main.FormKeyPress(Sender: TObject; var Key: Char);
begin
if (MultiDoc1.ActiveObject is Tf_chart)and (Activecontrol=nil) then
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
   for n:=0 to 30 do savwincol[n]:=getsyscolor(n);
end;

Procedure Tf_main.ResetWinColor;
const elem31 : array[0..30] of integer=(0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30);
begin
setsyscolors(31,elem31,savwincol);
end;

procedure Tf_main.SetNightVision(night: boolean);
const elem : array[0..30] of integer = (COLOR_BACKGROUND,COLOR_BTNFACE,COLOR_ACTIVEBORDER,11    ,COLOR_ACTIVECAPTION,COLOR_BTNTEXT,COLOR_CAPTIONTEXT,COLOR_HIGHLIGHT,COLOR_BTNHIGHLIGHT,COLOR_HIGHLIGHTTEXT,COLOR_INACTIVECAPTION,COLOR_APPWORKSPACE,COLOR_INACTIVECAPTIONTEXT,COLOR_INFOBK,COLOR_INFOTEXT,COLOR_MENU,30,COLOR_MENUTEXT,COLOR_SCROLLBAR,COLOR_WINDOW,COLOR_WINDOWTEXT,COLOR_WINDOWFRAME,COLOR_3DDKSHADOW,COLOR_3DLIGHT,COLOR_BTNSHADOW,COLOR_GRAYTEXT,25   ,26   ,27   ,28   ,29   );
      rgb  : array[0..30] of Tcolor =  (nv_black        ,nv_dark      ,nv_dark           ,nv_dark,nv_dim            ,nv_middle    ,nv_middle        ,nv_dark        ,nv_dark           ,nv_light           ,nv_dark              ,nv_black          ,nv_dark                  ,nv_black    ,nv_middle     ,nv_dark   ,nv_dark          ,nv_middle      ,nv_black    ,nv_black        ,nv_middle        ,nv_black        ,nv_black     ,nv_middle      ,nv_black      ,nv_dark,nv_dark,nv_dark,nv_dark,nv_dark,nv_dark);
begin
if night then begin
 if (Color<>nv_dark) then begin
   SaveWinColor;
   SetButtonImage(cfgm.ButtonNight);
   setsyscolors(sizeof(elem),elem,rgb);
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
   if f_config<>nil then begin
      f_config.Color:=nv_dark;
      f_config.Font.Color:=nv_middle;
   end;
 end;
end else begin
   ResetWinColor;
   SetButtonImage(cfgm.ButtonStandard);
   Color:=clBtnFace;
   Font.Color:=clWindowText;
   quicksearch.Color:=clBtnFace;
   quicksearch.Font.Color:=clWindowText;
   timeu.Color:=clBtnFace;
   timeu.Font.Color:=clWindowText;
   timeval.Color:=clBtnFace;
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
   if f_config<>nil then begin
      f_config.Color:=clBtnFace;
      f_config.Font.Color:=clWindowText;
   end;
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
begin
if night then begin
   SetButtonImage(cfgm.ButtonNight);
   MultiDoc1.InactiveBorderColor:=nv_black;
   MultiDoc1.TitleColor:=nv_middle;
   MultiDoc1.BorderColor:=nv_dark;
 end else begin
   SetButtonImage(cfgm.ButtonStandard);
   MultiDoc1.InactiveBorderColor:=clDisabledHighlight;
   MultiDoc1.TitleColor:=clCaptionText;
   MultiDoc1.BorderColor:=clHighlight;
end;
end;

procedure Tf_main.ViewFullScreenExecute(Sender: TObject);
begin
//Too tricky and windows manager dependant...
//Beware that modal form get hiden and lock the app.
//Is this really useful ? better to use a theme with small border.
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
