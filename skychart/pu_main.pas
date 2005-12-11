unit pu_main;
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
 Main form for Windows VCL application 
}

interface

uses cu_catalog, cu_planet, cu_telescope, cu_fits, cu_database, pu_chart,
  u_constant, u_util, blcksock, Winsock,
  //{$IFDEF VER150} XPman, {$ENDIF}  // night vision mode do not work well with XP theme
  //{$IFDEF VER160} XPman, {$ENDIF}
  //{$IFDEF VER170} XPman, {$ENDIF}
  Windows, SysUtils, Classes, Graphics, Forms, Controls, Menus, Math,
  StdCtrls, Dialogs, Buttons, Messages, ExtCtrls, ComCtrls, StdActns,
  ActnList, ToolWin, ImgList, IniFiles, Spin, DdeMan, Clipbrd, cu_MultiForm, cu_MultiFormChild;

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
  Tf_main = class(TForm)
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
    FileClose1: TWindowClose;
    WindowTileItem2: TMenuItem;
    ImageList1: TImageList;
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
    LPanels0: TLabel;
    PPanels1: TPanel;
    LPanels1: TLabel;
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
    N3: TMenuItem;
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
    MagPanel: TPanel;
    SpeedButtonMoreStar: TSpeedButton;
    SpeedButtonLessStar: TSpeedButton;
    SpeedButtonMoreNeb: TSpeedButton;
    SpeedButtonLessNeb: TSpeedButton;
    DdeData: TDdeServerItem;
    DdeSkyChart: TDdeServerConv;
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
    StarSizePanel: TPanel;
    TrackBar1: TTrackBar;
    TrackBar2: TTrackBar;
    TrackBar3: TTrackBar;
    TrackBar4: TTrackBar;
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
    ButtonStarSize: TSpeedButton;
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
    Buttons1: TMenuItem;
    Normal1: TMenuItem;
    Reverse1: TMenuItem;
    NightVision1: TMenuItem;
    ToolButtonEditlabels: TToolButton;
    EditLabels: TAction;
    N7: TMenuItem;
    FullScreen1: TMenuItem;
    N8: TMenuItem;
    N9: TMenuItem;
    MultiDoc1: TMultiForm;
    PanelMenu: TPanel;
    ToolBarMenu: TToolBar;
    ChildControl: TPanel;
    N10: TMenuItem;
    Cascade1: TAction;
    TileHorizontal1: TAction;
    TileVertical1: TAction;
    topmessage: TLabel;
    BtnRestoreChild: TSpeedButton;
    BtnCloseChild: TSpeedButton;
    Maximize1: TMenuItem;
    Maximize: TAction;
    PanelStar: TPanel;
    TelescopePanel: TAction;
    ControlPanel1: TMenuItem;
    ViewFullScreen: TAction;
    procedure FileNew1Execute(Sender: TObject);
    procedure FileOpen1Execute(Sender: TObject);
    procedure HelpAbout1Execute(Sender: TObject);
    procedure FileExit1Execute(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Print1Execute(Sender: TObject);
    procedure OpenConfigExecute(Sender: TObject);
    procedure ViewBarExecute(Sender: TObject);
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
    procedure FormMouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
//    procedure FormKeyDown(Sender: TObject; var Key: Word;   Shift: TShiftState);
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
    procedure DdeDataPokeData(Sender: TObject);
    procedure DdeSkyChartClose(Sender: TObject);
    procedure DdeSkyChartOpen(Sender: TObject);
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
    procedure StarSizeChange(Sender: TObject);
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
    procedure ButtonStarSizeClick(Sender: TObject);
    procedure EditCopy1Execute(Sender: TObject);
    procedure SetFovExecute(Sender: TObject);
    procedure ShowBackgroundImageExecute(Sender: TObject);
    procedure PositionExecute(Sender: TObject);
    procedure Search1Execute(Sender: TObject);
    procedure SyncChartExecute(Sender: TObject);
    procedure TrackExecute(Sender: TObject);
    procedure ZoomBarExecute(Sender: TObject);
    procedure DSSImageExecute(Sender: TObject);
    procedure ToolButtonNightVisionClick(Sender: TObject);
    procedure ButtonModeClick(Sender: TObject);
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
    procedure ViewFullScreenExecute(Sender: TObject);
  private
    { Private declarations }
    cryptedpwd,basecaption :string;
    NeedRestart,NeedToInitializeDB : Boolean;
    InitialChartNum, ButtonImage: integer;
    nightvision : Boolean;
    savwincol  : array[0..30] of Tcolor;
    Procedure SaveWinColor;
    Procedure ResetWinColor;
    procedure SetNightVision(night: boolean);
    procedure SetButtonImage(button: Integer);
    function CreateChild(const CName: string; copyactive: boolean; cfg1 : conf_skychart; cfgp : conf_plot; locked:boolean=false):boolean;
    Procedure RefreshAllChild(applydef:boolean);
    Procedure SyncChild;
    procedure CopySCconfig(c1:conf_skychart;var c2:conf_skychart);
    Procedure GetAppDir;
    procedure ViewTopPanel;
    procedure ApplyConfig(Sender: TObject);
    procedure SetChildFocus(Sender: TObject);
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
    procedure Init;
    procedure ReadChartConfig(filename:string; usecatalog,resizemain:boolean; var cplot:conf_plot ;var csc:conf_skychart);
    procedure ReadPrivateConfig(filename:string);
    procedure ReadDefault;
    procedure UpdateConfig;
    procedure SavePrivateConfig(filename:string);
    procedure SaveQuickSearch(filename:string);
    procedure SaveChartConfig(filename:string; child: TChildPanel);
    procedure SaveDefault;
    procedure SetDefault;
    procedure SetLang;
    Procedure InitFonts;
    Procedure ActivateConfig;
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
    function PrepareAsteroid(jdt:double; msg:Tstrings):boolean;
    procedure ChartMove(Sender: TObject);
  end;

var
  f_main: Tf_main;

implementation

{$R *.dfm}
{$R cursbmp.res}

uses pu_detail, pu_about, pu_config, pu_info, pu_getdss, u_projection,
     pu_printsetup, pu_calendar, pu_position, pu_search, pu_zoom,
     pu_manualtelescope,
     passql, pasmysql, ShlObj ;

// include all cross-platform common code.
// you can temporarily copy the file content here
// to use the IDE facilities

{$include i_main.pas}

// end of common code

// windows vcl specific code:

// DDE server, windows only
procedure Tf_main.DdeDataPokeData(Sender: TObject);
var cmd : Tstringlist;
    cmdresult:string;
    i: integer;
begin
while DDEenqueue do application.processmessages;
try
DdeEnqueue:=true;
cmd:=TStringlist.create;
splitarg(DdeData.text,' ',cmd);
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
end;

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
const light  = $004040ff;
      middle = $003030c0;
      dim    = $00000060;
      dark   = $00000040;
      black  = $00000000;
      elem : array[0..30] of integer = (COLOR_BACKGROUND,COLOR_BTNFACE,COLOR_ACTIVEBORDER,11    ,COLOR_ACTIVECAPTION,COLOR_BTNTEXT,COLOR_CAPTIONTEXT,COLOR_HIGHLIGHT,COLOR_BTNHIGHLIGHT,COLOR_HIGHLIGHTTEXT,COLOR_INACTIVECAPTION,COLOR_APPWORKSPACE,COLOR_INACTIVECAPTIONTEXT,COLOR_INFOBK,COLOR_INFOTEXT,COLOR_MENU,COLOR_MENUBAR,COLOR_MENUTEXT,COLOR_SCROLLBAR,COLOR_WINDOW,COLOR_WINDOWTEXT,COLOR_WINDOWFRAME,COLOR_3DDKSHADOW,COLOR_3DLIGHT,COLOR_BTNSHADOW,COLOR_GRAYTEXT,25   ,26   ,27   ,28   ,29   );
      rgb  : array[0..30] of Tcolor =  (black           ,dark         ,dark              ,dark  ,dim                ,middle       ,middle           ,dark           ,dark              ,light              ,dark                 ,black             ,dark                     ,black       ,middle        ,dark      ,dark         ,middle        ,black          ,black       ,middle          ,black            ,black           ,middle       ,black          ,dark          ,dark ,dark ,dark ,dark ,dark );
begin
if night then begin
   SaveWinColor;
   setsyscolors(sizeof(elem),elem,rgb);
   SetButtonImage(2);
end else begin
   ResetWinColor;
   SetButtonImage(ButtonImage);
end;
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


// end of windows vcl specific code:


 
end.
