unit fu_main;
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
 Main form for Linux CLX application
}

                                
interface

uses fu_chart, cu_catalog, cu_planet, cu_fits, cu_database, u_constant, u_util, blcksock, libc, Math,
     {$ifdef Themed}
     QThemed, QThemeSrvLinux,
     {$endif}
     SysUtils, Classes, QForms, QImgList, QStdActns, QActnList, QDialogs, Qt,
     QMenus, QTypes, QComCtrls, QControls, QExtCtrls, QGraphics,  QPrinters,
     QStdCtrls, IniFiles, Types, QButtons, QFileCtrls, QClipbrd,
  cu_MultiForm, cu_MultiFormChild;

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
    WindowMinimizeItem: TMenuItem;
    ActionList1: TActionList;
    FileNew1: TAction;
    FileExit1: TAction;
    FileOpen1: TAction;
    FileSaveAs1: TAction;
    HelpAbout1: TAction;
    FileClose1: TWindowClose;
    ImageList1: TImageList;
    starshape: TImage;
    OpenConfig: TAction;
    Print1: TAction;
    Configuration1: TMenuItem;
    Setup1: TMenuItem;
    Print2: TMenuItem;
    FilePrintSetup1: TAction;
    PrintSetup2: TMenuItem;
    N2: TMenuItem;
    HelpContents1: THelpContents;
    Search1: TAction;
    ViewBar: TAction;
    PanelTop: TPanel;
    PanelLeft: TPanel;
    PanelRight: TPanel;
    PanelBottom: TPanel;
    ToolBar1: TToolBar;
    ToolButtonNew: TToolButton;
    ToolButtonOpen: TToolButton;
    ToolButtonSave: TToolButton;
    ToolButtonPrint: TToolButton;
    ToolButton15: TToolButton;
    ToolButtonCascade: TToolButton;
    ToolButtonTile: TToolButton;
    ToolButton18: TToolButton;
    ToolBar2: TToolBar;
    ToolButtonConfig: TToolButton;
    FlipButtonX: TToolButton;
    ToolBar3: TToolBar;
    PPanels0: TPanel;
    LPanels0: TLabel;
    PPanels1: TPanel;
    LPanels1: TLabel;
    ToolButtonZoom: TToolButton;
    ToolButtonUnZomm: TToolButton;
    zoomplus: TAction;
    zoomminus: TAction;
    ToolButton7: TToolButton;
    quicksearch: TComboBox;
    Copy1: TMenuItem;
    Flipx: TAction;
    Flipy: TAction;
    FlipButtonY: TToolButton;
    AutoRefresh: TTimer;
    ChangeProj: TAction;
    rot_plus: TAction;
    rot_minus: TAction;
    GridEQ: TAction;
    Grid: TAction;
    SaveConfiguration: TAction;
    SaveConfigOnExit: TAction;
    Undo: TAction;
    Redo: TAction;
    ViewStatus: TAction;
    ViewToolsBar1: TMenuItem;
    SaveConfigurationNow1: TMenuItem;
    SaveConfigurationOnExit1: TMenuItem;
    N3: TMenuItem;
    ToolButtonRotP: TToolButton;
    ToolButtonRotM: TToolButton;
    ToolButtonUndo: TToolButton;
    ToolButtonRedo: TToolButton;
    ToolButton26: TToolButton;
    SaveDialog: TSaveDialog;
    switchstars: TAction;
    switchbackground: TAction;
    SaveImage: TAction;
    SaveImage1: TMenuItem;
    ViewInfo: TAction;
    ViewInformation1: TMenuItem;
    topmessage: TMenuItem;
    N4: TMenuItem;
    popupProj: TPopupMenu;
    Equatorial1: TMenuItem;
    AltAz1: TMenuItem;
    Galactic1: TMenuItem;
    Ecliptic1: TMenuItem;
    ToolButtonswitchbackground: TToolButton;
    ToolButtonswitchstars: TToolButton;
    toN: TAction;
    toE: TAction;
    toS: TAction;
    toW: TAction;
    toZenith: TAction;
    allSky: TAction;
    ToolButtonToN: TToolButton;
    ToolButtonToS: TToolButton;
    ToolButtonToE: TToolButton;
    ToolButtonToW: TToolButton;
    ToolButtonToZ: TToolButton;
    ToolButtonAllSky: TToolButton;
    TimeInc: TAction;
    TimeDec: TAction;
    TimeReset: TAction;
    TimeVal: TSpinEdit;
    TimeU: TComboBox;
    ToolButtonTnow: TToolButton;
    ToolButtonTdec: TToolButton;
    ToolButtonTinc: TToolButton;
    ToolButton40: TToolButton;
    ListObj: TAction;
    ToolButtonShowStars: TToolButton;
    TConnect: TToolButton;
    TSlew: TToolButton;
    TSync: TToolButton;
    TelescopeConnect: TAction;
    TelescopeSlew: TAction;
    TelescopeSync: TAction;
    MagPanel: TPanel;
    SpeedButtonMoreStar: TSpeedButton;
    SpeedButtonLessStar: TSpeedButton;
    SpeedButtonMoreNeb: TSpeedButton;
    SpeedButtonLessNeb: TSpeedButton;
    MoreStar: TAction;
    LessStar: TAction;
    MoreNeb: TAction;
    LessNeb: TAction;
    ToolBar4: TToolBar;
    ToolButtonListObj: TToolButton;
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
    ToolButtonGrid: TToolButton;
    ToolButtonGridEq: TToolButton;
    EditCopy1: TEditCopy;
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
    N6: TMenuItem;
    Calendar1: TMenuItem;
    Undo1: TMenuItem;
    Redo1: TMenuItem;
    Chart1: TMenuItem;
    Projection1: TMenuItem;
    EquatorialCoordinate1: TMenuItem;
    AltAzProjection1: TMenuItem;
    EclipticProjection1: TMenuItem;
    GalacticProjection1: TMenuItem;
    zoomplus1: TMenuItem;
    zoomminus1: TMenuItem;
    Transformation1: TMenuItem;
    Flipx1: TMenuItem;
    flipy1: TMenuItem;
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
    ViewHorizon1: TMenuItem;
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
    LinesGrid1: TMenuItem;
    Grid1: TMenuItem;
    GridEQ1: TMenuItem;
    ShowConstellationLine1: TMenuItem;
    ShowConstellationLimit1: TMenuItem;
    ShowGalacticEquator1: TMenuItem;
    ShowEcliptic1: TMenuItem;
    ShowMark1: TMenuItem;
    ShowLabels1: TMenuItem;
    ShowObjectbelowthehorizon1: TMenuItem;
    Telescope1: TMenuItem;
    Connect1: TMenuItem;
    Slew1: TMenuItem;
    TelescopeSync1: TMenuItem;
    ToolButtonShowBackgroundImage: TToolButton;
    ShowBackgroundImage: TAction;
    SyncChart: TAction;
    Position: TAction;
    ToolButtonSyncChart: TToolButton;
    ToolButton1: TToolButton;
    ZoomBar: TAction;
    ImageList2: TImageList;
    DSSImage: TAction;
    ToolButton2: TToolButton;
    ToolButton3: TToolButton;
    Track: TAction;
    ToolButtonTrack: TToolButton;
    Buttons1: TMenuItem;
    Normal1: TMenuItem;
    Reverse1: TMenuItem;
    ToolButtonEditLabels: TToolButton;
    EditLabels: TAction;
    Themes1: TMenuItem;
    Default1: TMenuItem;
    N8: TMenuItem;
    ViewStatusBar1: TMenuItem;
    N9: TMenuItem;
    ToolButtonNightVision: TToolButton;
    NightVision1: TMenuItem;
    N7: TMenuItem;
    MultiDoc1: TMultiForm;
    WindowCascade1: TAction;
    WindowTileHorizontal1: TAction;
    WindowTileVertical1: TAction;
    N10: TMenuItem;
    Maximize: TAction;
    Maximize1: TMenuItem;
    PanelStar: TPanel;
    ButtonStarSize: TSpeedButton;
    ChildControl: TPanel;
    BtnCloseChild: TSpeedButton;
    BtnRestoreChild: TSpeedButton;
    TelescopePanel: TAction;
    TelescopePanel1: TMenuItem;

    procedure FileNew1Execute(Sender: TObject);
    procedure FileOpen1Execute(Sender: TObject);
    procedure HelpAbout1Execute(Sender: TObject);
    procedure FileExit1Execute(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure OpenConfigExecute(Sender: TObject);
    procedure Print1Execute(Sender: TObject);
    procedure FilePrintSetup1Execute(Sender: TObject);
    procedure ViewBarExecute(Sender: TObject);
    procedure zoomplusExecute(Sender: TObject);
    procedure zoomminusExecute(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormResize(Sender: TObject);
    procedure quicksearchClick(Sender: TObject);
    procedure FlipxExecute(Sender: TObject);
    procedure FlipyExecute(Sender: TObject);
    procedure SetFOVClick(Sender: TObject);
    procedure AutoRefreshTimer(Sender: TObject);
    procedure rot_plusExecute(Sender: TObject);
    procedure rot_minusExecute(Sender: TObject);
    procedure GridEQExecute(Sender: TObject);
    procedure GridExecute(Sender: TObject);
    procedure FileSaveAs1Execute(Sender: TObject);
    procedure SaveConfigurationExecute(Sender: TObject);
    procedure SaveConfigOnExitExecute(Sender: TObject);
    procedure UndoExecute(Sender: TObject);
    procedure RedoExecute(Sender: TObject);
    procedure ViewStatusExecute(Sender: TObject);
    procedure ToolBar1MouseEnter(Sender: TObject);
    procedure ToolBar1MouseLeave(Sender: TObject);
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
    procedure TimeIncExecute(Sender: TObject);
    procedure TimeResetExecute(Sender: TObject);
    procedure ListObjExecute(Sender: TObject);
    procedure quicksearchKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure TelescopeConnectExecute(Sender: TObject);
    procedure TelescopeSlewExecute(Sender: TObject);
    procedure TelescopeSyncExecute(Sender: TObject);
    procedure MoreStarExecute(Sender: TObject);
    procedure LessStarExecute(Sender: TObject);
    procedure MoreNebExecute(Sender: TObject);
    procedure LessNebExecute(Sender: TObject);
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
    procedure ChartMove(Sender: TObject);
    procedure SyncChild;
    procedure SyncChartExecute(Sender: TObject);
    procedure PositionExecute(Sender: TObject);
    procedure Search1Execute(Sender: TObject);
    procedure ZoomBarExecute(Sender: TObject);
    procedure DSSImageExecute(Sender: TObject);
    procedure TrackExecute(Sender: TObject);
    procedure ButtonModeClick(Sender: TObject);
    procedure EditLabelsExecute(Sender: TObject);
    procedure SetThemeClick(Sender: TObject);
    procedure ToolButtonNightVisionClick(Sender: TObject);
    procedure MultiDoc1ActiveChildChange(Sender: TObject);
    procedure MultiDoc1Maximize(Sender: TObject);
    procedure BtnCloseChildClick(Sender: TObject);
    procedure BtnRestoreChildClick(Sender: TObject);
    procedure WindowCascade1Execute(Sender: TObject);
    procedure WindowTileHorizontal1Execute(Sender: TObject);
    procedure WindowTileVertical1Execute(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure MaximizeExecute(Sender: TObject);
    procedure FormMouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
    procedure TelescopePanelExecute(Sender: TObject);

  private
    { Private declarations }
    cryptedpwd,basecaption: string;
    NeedRestart,NeedToInitializeDB: Boolean;
    InitialChartNum, ButtonImage : integer;
    NightVision: boolean;
    procedure SetButtonImage(button: Integer);
    function CreateChild(const CName: string; copyactive: boolean; cfg1 : conf_skychart; cfgp : conf_plot; locked:boolean=false):boolean;
    Procedure RefreshAllChild(applydef:boolean);
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
    cdcdb: TCDCdb;
    serverinfo,topmsg : string;
    TCPDaemon: TTCPDaemon;
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
    Procedure UpdateBtn(fx,fy:integer;tc:boolean;sender:TObject);
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
    procedure InitTheme;
    procedure SetTheme;
    procedure SetNightVision(night: boolean);
  end;

var
  f_main: Tf_main;


implementation

{$R *.xfm}

uses fu_detail, fu_about, fu_config, fu_info, u_projection, passql, pasmysql,
     LibcExec,  // libc exec bug workaround by Andreas Hausladen
     fu_zoom, fu_getdss, fu_manualtelescope,
     fu_printsetup, fu_directory, fu_calendar, fu_search, fu_position;

// include all cross-platform common code.
// you can temporarily copy the file content here
// to use the IDE facilities

{$include i_main.pas}

// end of common code


// Specific Linux CLX code:

procedure Tf_main.ToolBar1MouseEnter(Sender: TObject);

begin
quicksearch.SetFocus;
end;

procedure Tf_main.ToolBar1MouseLeave(Sender: TObject);
begin
activecontrol:=nil;
end;

// use QThemed

procedure Tf_main.InitTheme;
var  sr: TSearchRec;
     inif: TMemIniFile;
     m: Tmenuitem;
begin
  cfgm.ThemeName:='Default';
 {$ifdef Themed}
   inif:=TMeminifile.create(configfile);
   ThemePath:=slash(appdir)+ThemePath;
   try
     cfgm.ThemeName:=inif.ReadString('main','ThemeName',cfgm.ThemeName);
   finally
     inif.Free;
   end;
   if cfgm.ThemeName='Default' then Default1.Checked:=true;
   if FindFirst(ThemePath + PathDelim + '*', faAnyFile, sr) = 0 then
   try
    repeat
      if (sr.Attr and faDirectory <> 0) and (sr.Name <> '.') and (sr.Name <> '..') and
         (CompareText(sr.Name, '.svn') <> 0) and (CompareText(sr.Name, 'svn') <> 0) and
         (CompareText(sr.Name, '.cvs') <> 0) and (CompareText(sr.Name, 'cvs') <> 0) then begin
             m:=Tmenuitem.create(self);
             m.caption:=sr.Name;
             m.OnClick:=SetThemeClick;
             m.RadioItem:=true;
             m.GroupIndex:=102;
             m.checked:=(m.caption=cfgm.ThemeName);
             Themes1.add(m);
      end;
    until FindNext(sr) <> 0;
   finally
    FindClose(sr);
   end;
   SetTheme;
 {$else}
   Themes1.visible:=false;
 {$endif}
end;

procedure Tf_main.SetTheme;
var i: integer;
begin
{$ifdef Themed}
   if cfgm.ThemeName<>'Default' then begin
      SetThemesDirectory(ThemePath);
      if ThemeServices.ThemesAvailable and (ThemeServices.ThemeCount > 0) then
         for i:=0 to ThemeServices.ThemeCount-1 do begin
             if ThemeServices.ThemeNames[i]=cfgm.ThemeName then begin
                ThemeServices.ThemeIndex := i;
             end;
         end;
  end;
{$endif}
end;

procedure Tf_main.SetThemeClick(Sender: TObject);
var  inif: TMemIniFile;
begin
{$ifdef Themed}
if sender is TmenuItem then with Sender as TmenuItem do begin
  if cfgm.ThemeName<>Caption then begin
     cfgm.ThemeName:=Caption;
     checked:=true;
     inif:=TMeminifile.create(configfile);
     try
       inif.WriteString('main','ThemeName',cfgm.ThemeName);
       inif.Updatefile;
     finally
       inif.Free;
     end;
     SetTheme;
     if (cfgm.ThemeName='Default') and
        (MessageDlg('You need to restart the program to reset the default theme. Do you want to restart now?',mtConfirmation,[mbYes, mbNo],0)=mrYes) then begin
            NeedRestart:=true;
            Close;
     end;
  end;
end;
 {$endif}
end;

// fullscreen without border
{
too tricky and windows manager dependant...
beware that modal form get hiden and lock the app.
is this really useful ? better to use a theme with small border.
procedure Tf_main.FullScreen1Click(Sender: TObject);
var i: integer;
    p:Tpoint;
begin
FullScreen1.Checked:=not FullScreen1.Checked;
if FullScreen1.Checked then begin
   cfgm.savetop:=f_main.top;
   cfgm.saveleft:=f_main.left;
   cfgm.savewidth:=f_main.width;
   cfgm.saveheight:=f_main.height;
   WindowState:=wsMinimized;
   application.ProcessMessages;
   BoundsRect:=Rect(0,0,screen.Width,screen.Height);
   BorderStyle:=fbsNone;
   WindowState:=wsNormal;
   QWidget_setActiveWindow(Handle);
end else begin
   WindowState:=wsMinimized;
   application.ProcessMessages;
   f_main.top:=cfgm.savetop;
   f_main.left:=cfgm.saveleft;
   f_main.width:=cfgm.savewidth;
   f_main.height:=cfgm.saveheight;
   WindowState:=wsNormal;
   application.ProcessMessages;
   BorderStyle:=fbsSizeable;
end;
end;}

// nightvision apply only to the program window

procedure Tf_main.SetNightVision(night: boolean);
begin
if night then begin
   if cfgm.ThemeName<>'Default' then cfgm.ThemeName:='Red';
   SetButtonImage(2);
   Color:=dark;
   font.Color:=middle;
   MainMenu1.Color:=dark;
   quicksearch.Color:=black;
   timeu.Color:=black;
   timeval.Color:=black;
   f_calendar.Color:=dark;
   f_calendar.font.Color:=middle;
   f_detail.Color:=dark;
   f_detail.font.Color:=middle;
   f_search.Color:=dark;
   f_search.font.Color:=middle;
   f_zoom.Color:=dark;
   f_zoom.font.Color:=middle;
   f_info.Color:=dark;
   f_info.font.Color:=middle;
   f_position.Color:=dark;
   f_position.font.Color:=middle;
   f_directory.Color:=dark;
   f_directory.font.Color:=middle;
   f_getdss.Color:=dark;
   f_getdss.font.Color:=middle;
   f_printsetup.Color:=dark;
   f_printsetup.font.Color:=middle;
   if f_config<>nil then begin
      f_config.Color:=dark;
      f_config.font.Color:=middle;
   end;
   MultiDoc1.InactiveBorderColor:=black;
   MultiDoc1.TitleColor:=middle;
   MultiDoc1.BorderColor:=dark;
 end else begin
   if cfgm.ThemeName<>'Default' then cfgm.ThemeName:='Silver';
   SetButtonImage(1);
   Color:=clButton;
   font.Color:=clText;
   MainMenu1.Color:=clButton;
   quicksearch.Color:=clBase;
   timeu.Color:=clBase;
   timeval.Color:=clBase;
   f_calendar.Color:=clButton;
   f_calendar.font.Color:=clText;
   f_detail.Color:=clButton;
   f_detail.font.Color:=clText;
   f_search.Color:=clButton;
   f_search.font.Color:=clText;
   f_zoom.Color:=clButton;
   f_zoom.font.Color:=clText;
   f_info.Color:=clButton;
   f_info.font.Color:=clText;
   f_position.Color:=clButton;
   f_position.font.Color:=clText;
   f_directory.Color:=clButton;
   f_directory.font.Color:=clText;
   f_getdss.Color:=clButton;
   f_getdss.font.Color:=clText;
   f_printsetup.Color:=clButton;
   f_printsetup.font.Color:=clText;
   if f_config<>nil then begin
      f_config.Color:=clButton;
      f_config.font.Color:=clText;
   end;
   MultiDoc1.InactiveBorderColor:=clDisabledHighlight;
   MultiDoc1.TitleColor:=clCaptionText;
   MultiDoc1.BorderColor:=clHighlight;
end;
SetTheme;
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
      Tf_chart(MultiDoc1.Childs[i].DockedObject).NightVision:=nightvision;
end;

// End of Linux specific CLX code:


end.

