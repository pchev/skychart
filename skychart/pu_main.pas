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

uses cu_catalog, cu_planet, u_constant, u_util, blcksock, Winsock,
  Windows, SysUtils, Classes, Graphics, Forms, Controls, Menus, Math,
  StdCtrls, Dialogs, Buttons, Messages, ExtCtrls, ComCtrls, StdActns,
  ActnList, ToolWin, ImgList, IniFiles, Spin;

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
    WindowArrangeItem: TMenuItem;
    HelpAboutItem: TMenuItem;
    OpenDialog: TOpenDialog;
    FileSaveAsItem: TMenuItem;
    Edit1: TMenuItem;
    CopyItem: TMenuItem;
    WindowMinimizeItem: TMenuItem;
    ActionList1: TActionList;
    EditCopy1: TEditCopy;
    FileNew1: TAction;
    FileExit1: TAction;
    FileOpen1: TAction;
    FileSaveAs1: TAction;
    WindowCascade1: TWindowCascade;
    WindowTileHorizontal1: TWindowTileHorizontal;
    WindowArrangeAll1: TWindowArrange;
    WindowMinimizeAll1: TWindowMinimizeAll;
    HelpAbout1: TAction;
    FileClose1: TWindowClose;
    WindowTileVertical1: TWindowTileVertical;
    WindowTileItem2: TMenuItem;
    ImageList1: TImageList;
    Print1: TAction;
    Print2: TMenuItem;
    FilePrintSetup1: TFilePrintSetup;
    starshape: TImage;
    OpenConfig: TAction;
    Configuration1: TMenuItem;
    Configurerlimpression1: TMenuItem;
    N2: TMenuItem;
    Setup1: TMenuItem;
    HelpContents1: THelpContents;
    Search1: TAction;
    PanelLeft: TPanel;
    ToolBar2: TToolBar;
    ToolButton7: TToolButton;
    PanelRight: TPanel;
    ToolBar3: TToolBar;
    ToolButton6: TToolButton;
    PanelBottom: TPanel;
    PPanels0: TPanel;
    LPanels0: TLabel;
    PPanels1: TPanel;
    LPanels1: TLabel;
    PanelTop: TPanel;
    ToolBar1: TToolBar;
    ToolButton9: TToolButton;
    ToolButton1: TToolButton;
    ToolButton2: TToolButton;
    ToolButton15: TToolButton;
    ToolButton3: TToolButton;
    ToolButton8: TToolButton;
    ToolButton11: TToolButton;
    ToolButton5: TToolButton;
    ToolButton21: TToolButton;
    ToolButton22: TToolButton;
    ViewBar: TAction;
    zoomplus: TAction;
    zoomminus: TAction;
    quicksearch: TComboBox;
    FlipX: TAction;
    FlipY: TAction;
    FlipButtonX: TToolButton;
    FlipButtonY: TToolButton;
    ToolButton4: TToolButton;
    ToolButton10: TToolButton;
    ToolButton12: TToolButton;
    ToolButton13: TToolButton;
    ToolButton14: TToolButton;
    ToolButton16: TToolButton;
    ToolButton17: TToolButton;
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
    ToolButton18: TToolButton;
    Undo: TAction;
    Redo: TAction;
    ToolButton19: TToolButton;
    ToolButton20: TToolButton;
    ChangeProj: TAction;
    Autorefresh: TTimer;
    ToolButton23: TToolButton;
    ToolButton24: TToolButton;
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
    N4: TMenuItem;
    topmessage: TMenuItem;
    ToolButton29: TToolButton;
    ToolButton30: TToolButton;
    ToolButton31: TToolButton;
    ToolButton32: TToolButton;
    toN: TAction;
    toE: TAction;
    toS: TAction;
    toW: TAction;
    toZenith: TAction;
    allSky: TAction;
    popupProj: TPopupMenu;
    Equatorial1: TMenuItem;
    AltAz1: TMenuItem;
    Galactic1: TMenuItem;
    Ecliptic1: TMenuItem;
    ToolButton25: TToolButton;
    ToolButton26: TToolButton;
    ToolButton27: TToolButton;
    ToolButton28: TToolButton;
    ToolButton33: TToolButton;
    ToolButton34: TToolButton;
    TimeInc: TAction;
    TimeDec: TAction;
    TimeReset: TAction;
    ToolButton35: TToolButton;
    ToolButton36: TToolButton;
    TimeVal: TSpinEdit;
    TimeU: TComboBox;
    ToolButton37: TToolButton;
    ToolButton38: TToolButton;
    ToolButton39: TToolButton;
    listobj: TAction;
    ToolButton40: TToolButton;
    procedure FileNew1Execute(Sender: TObject);
    procedure FileOpen1Execute(Sender: TObject);
    procedure HelpAbout1Execute(Sender: TObject);
    procedure FileExit1Execute(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
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
    procedure SetFOVExecute(Sender: TObject);
    procedure FileSaveAs1Execute(Sender: TObject);
    procedure ViewStatusExecute(Sender: TObject);
    procedure SaveConfigurationExecute(Sender: TObject);
    procedure SaveConfigOnExitExecute(Sender: TObject);
    procedure UndoExecute(Sender: TObject);
    procedure RedoExecute(Sender: TObject);
    procedure ChangeProjExecute(Sender: TObject);
    procedure AutorefreshTimer(Sender: TObject);
    procedure rot_plusExecute(Sender: TObject);
    procedure rot_minusExecute(Sender: TObject);
    procedure GridEQExecute(Sender: TObject);
    procedure GridExecute(Sender: TObject);
    procedure FormMouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure switchstarsExecute(Sender: TObject);
    procedure switchbackgroundExecute(Sender: TObject);
    procedure SaveImageExecute(Sender: TObject);
    procedure ViewInfoExecute(Sender: TObject);
    procedure topmessageDrawItem(Sender: TObject; ACanvas: TCanvas;
      ARect: TRect; Selected: Boolean);
    procedure toNExecute(Sender: TObject);
    procedure toEExecute(Sender: TObject);
    procedure toSExecute(Sender: TObject);
    procedure toWExecute(Sender: TObject);
    procedure toZenithExecute(Sender: TObject);
    procedure allSkyExecute(Sender: TObject);
    procedure popupProjClick(Sender: TObject);
    procedure TimeResetExecute(Sender: TObject);
    procedure TimeIncExecute(Sender: TObject);
    procedure listobjExecute(Sender: TObject);
  private
    { Private declarations }
    function CreateMDIChild(const Name: string; copyactive,linkactive: boolean; cfg1 : conf_skychart; cfgp : conf_plot):boolean;
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
    procedure updatebtn(fx,fy:integer);
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
  end;

var
  f_main: Tf_main;

implementation

{$R *.dfm}
{$R cursbmp.res}

uses pu_chart, pu_about, pu_config, pu_info, u_projection ;

// include all cross-platform common code.
// you can temporarily copy the file content here
// to use the IDE facilities

{$include i_main.pas}

// end of common code

// windows vcl specific code:

procedure Tf_main.FormMouseWheel(Sender: TObject; Shift: TShiftState;
  WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
begin
// keep here because of focus problem with the child that have no text control
if ActiveMdiChild is Tf_chart then with ActiveMdiChild as Tf_chart do
   CMouseWheel(Shift,WheelDelta,MousePos,Handled);
end;

procedure Tf_main.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
// keep here because of focus problem with the child that have no text control
if ActiveMdiChild is Tf_chart then with ActiveMdiChild as Tf_chart do
   CKeyDown(Key,Shift);
end;

procedure Tf_main.topmessageDrawItem(Sender: TObject; ACanvas: TCanvas;
  ARect: TRect; Selected: Boolean);
begin
// draw the message in the menu bar, avoiding to extent the menu on the next line
ACanvas.TextOut(Arect.left,Arect.top+2,topmsg);
end;

// end of windows vcl specific code:

end.
