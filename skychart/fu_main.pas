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

uses cu_catalog, cu_planet, u_constant, u_util, blcksock, libc, Math,
     SysUtils, Classes, QForms, QImgList, QStdActns, QActnList, QDialogs,
     QMenus, QTypes, QComCtrls, QControls, QExtCtrls, QGraphics,  QPrinters,
     QStdCtrls, IniFiles, Types;

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
    WindowCascade1: TWindowCascade;
    WindowMinimizeAll1: TWindowMinimizeAll;
    HelpAbout1: TAction;
    FileClose1: TWindowClose;
    WindowTileItem2: TMenuItem;
    WindowClose1: TWindowClose;
    WindowTile1: TWindowTile;
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
    ToolButton8: TToolButton;
    ToolButton9: TToolButton;
    ToolButton10: TToolButton;
    ToolButton11: TToolButton;
    ToolButton15: TToolButton;
    ToolButton16: TToolButton;
    ToolButton17: TToolButton;
    ToolButton18: TToolButton;
    ToolBar2: TToolBar;
    ToolButton1: TToolButton;
    FlipButtonX: TToolButton;
    ToolBar3: TToolBar;
    ToolButton3: TToolButton;
    ToolButton4: TToolButton;
    PPanels0: TPanel;
    LPanels0: TLabel;
    PPanels1: TPanel;
    LPanels1: TLabel;
    ToolButton5: TToolButton;
    ToolButton6: TToolButton;
    zoomplus: TAction;
    zoomminus: TAction;
    ToolButton7: TToolButton;
    quicksearch: TComboBox;
    Copy1: TMenuItem;
    Flipx: TAction;
    Flipy: TAction;
    FlipButtonY: TToolButton;
    ToolButton13: TToolButton;
    ToolButton14: TToolButton;
    ToolButton19: TToolButton;
    ToolButton20: TToolButton;
    ToolButton21: TToolButton;
    ToolButton22: TToolButton;
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
    View: TMenuItem;
    ViewToolsBar1: TMenuItem;
    ViewStatus1: TMenuItem;
    SaveConfigurationNow1: TMenuItem;
    SaveConfigurationOnExit1: TMenuItem;
    N3: TMenuItem;
    ToolButton2: TToolButton;
    ToolButton12: TToolButton;
    ToolButton23: TToolButton;
    ToolButton24: TToolButton;
    ToolButton25: TToolButton;
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
    ToolButton31: TToolButton;
    ToolButton32: TToolButton;
    toN: TAction;
    toE: TAction;
    toS: TAction;
    toW: TAction;
    toZenith: TAction;
    allSky: TAction;
    ToolButton27: TToolButton;
    ToolButton28: TToolButton;
    ToolButton33: TToolButton;
    ToolButton34: TToolButton;
    ToolButton35: TToolButton;
    ToolButton36: TToolButton;
    ToolButton37: TToolButton;
    ToolButton38: TToolButton;
    TimeInc: TAction;
    TimeDec: TAction;
    TimeReset: TAction;
    TimeVal: TSpinEdit;
    TimeU: TComboBox;
    ToolButton29: TToolButton;
    ToolButton30: TToolButton;
    ToolButton39: TToolButton;
    ToolButton40: TToolButton;
    ListObj: TAction;
    ToolButton41: TToolButton;
    procedure FileNew1Execute(Sender: TObject);
    procedure FileOpen1Execute(Sender: TObject);
    procedure HelpAbout1Execute(Sender: TObject);
    procedure FileExit1Execute(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
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
    procedure SetFOVExecute(Sender: TObject);
    procedure AutoRefreshTimer(Sender: TObject);
    procedure ChangeProjExecute(Sender: TObject);
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
    procedure popupProjClick(Sender: TObject);
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
  private
    { Private declarations }
    function CreateMDIChild(const CName: string; copyactive,linkactive: boolean; cfg1 : conf_skychart; cfgp : conf_plot; locked:boolean=false):boolean;
    Procedure RefreshAllChild(applydef:boolean);
    procedure CopySCconfig(c1:conf_skychart;var c2:conf_skychart);
  public
    { Public declarations }
    cfgm : conf_main;
    def_cfgsc : conf_skychart;
    def_cfgplot : conf_plot;
    catalog : Tcatalog;
    planet  : Tplanet;
    serverinfo,topmsg : string;
    TCPDaemon: TTCPDaemon;
    procedure ReadChartConfig(filename:string; usecatalog:boolean; var cplot:conf_plot ;var csc:conf_skychart);
    procedure ReadPrivateConfig(filename:string);
    procedure ReadDefault;
    procedure SavePrivateConfig(filename:string);
    procedure SaveQuickSearch(filename:string);
    procedure SaveChartConfig(filename:string);
    procedure SaveDefault;
    procedure SetDefault;
    procedure SetLang;
    Procedure InitFonts;
    Procedure ActivateConfig;
    Procedure SetLPanel1(txt:string; origin:string='';sendmsg:boolean=true);
    Procedure SetLPanel0(txt:string);
    Procedure SetTopMessage(txt:string);
    Procedure UpdateBtn(fx,fy:integer);
    Procedure LoadConstL(fname:string);
    Procedure LoadConstB(fname:string);
    Procedure LoadHorizon(fname:string);
    Function NewChart(cname:string):string;
    Function CloseChart(cname:string):string;
    Function ListChart:string;
    Function SelectChart(cname:string):string;
    function ExecuteCmd(cname:string; arg:Tstringlist):string;
    procedure SendInfo(origin,str:string);
    function GenericSearch(cname,Num:string):boolean;
    procedure StartServer;
    procedure StopServer;
    function GetUniqueName(cname:string; forcenumeric:boolean):string;
    procedure showdetailinfo(chart:string;ra,dec:double;nm,desc:string);
    procedure CenterFindObj(chart:string);
    procedure NeighborObj(chart:string);
    procedure ConnectDB;
    procedure OpenAsteroidConfig(Sender: TObject);
    procedure OpenDBConfig(Sender: TObject);
  end;

var
  f_main: Tf_main;


implementation

{$R *.xfm}

uses fu_chart, fu_about, fu_config, fu_info, u_projection, MyDB ;

// include all cross-platform common code.
// you can temporarily copy the file content here
// to use the IDE facilities

{$include i_main.pas}

// end of common code


// Specific Linux CLX code:

procedure Tf_main.FilePrintSetup1Execute(Sender: TObject);
begin
Printer.executesetup;
end;

procedure Tf_main.ToolBar1MouseEnter(Sender: TObject);

begin
quicksearch.SetFocus;
end;

procedure Tf_main.ToolBar1MouseLeave(Sender: TObject);

begin
activecontrol:=nil;
end;

// End of Linux specific CLX code:


end.

