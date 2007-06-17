unit pu_chart;

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
 Chart child form 
}
//{$define showtime}

interface

uses u_translation, pu_detail, cu_skychart, cu_indiclient, u_constant, u_util, u_projection,
     Printers, Math, cu_telescope, lazjpeg, IntfGraphics, PostscriptCanvas,
     LCLIntf, Classes, Graphics, Dialogs, Forms, Controls, StdCtrls, ExtCtrls, Menus,
     ActnList, SysUtils, LResources;
     
const maxundo=10;

type
  Tstr1func = procedure(txt:string) of object;
  Tint2func = procedure(i1,i2:integer) of object;
  Tbtnfunc = procedure(i1,i2:integer;b1:boolean;sender:TObject) of object;
  Tshowinfo = procedure(txt:string; origin:string='';sendmsg:boolean=true; Sender: TObject=nil) of object;

type
  TChartDrawingControl = class(TCustomControl)
  public
    procedure Paint; override;
    property onMouseDown;
    property onMouseMove;
    property onMouseUp;
  end;
  
  { Tf_chart }
  Tf_chart = class(TForm)
    About2: TMenuItem;
    About1: TMenuItem;
    AddLabel1: TMenuItem;
    MenuItem1: TMenuItem;
    Panel1: TPanel;
    RemoveLastLabel1: TMenuItem;
    RemoveAllLabel1: TMenuItem;
    RefreshTimer: TTimer;
    ActionList1: TActionList;
    BlinkTimer: TTimer;
    VertScrollBar: TScrollBar;
    HorScrollBar: TScrollBar;
    zoomplus: TAction;
    zoomminus: TAction;
    MoveWest: TAction;
    MoveEast: TAction;
    MoveNorth: TAction;
    MoveSouth: TAction;
    MoveNorthWest: TAction;
    MoveNorthEast: TAction;
    MoveSouthWest: TAction;
    MoveSouthEast: TAction;
    Centre: TAction;
    PopupMenu1: TPopupMenu;
    Zoom1: TMenuItem;
    Zoom2: TMenuItem;
    Centre1: TMenuItem;
    zoomplusmove: TAction;
    zoomminusmove: TAction;
    FlipX: TAction;
    FlipY: TAction;
    Undo: TAction;
    Redo: TAction;
    rot_plus: TAction;
    rot_minus: TAction;
    GridEQ: TAction;
    Grid: TAction;
    identlabel: TLabel;
    switchbackground: TAction;
    switchstar: TAction;
    elescope1: TMenuItem;
    Connect1: TMenuItem;
    Slew1: TMenuItem;
    Sync1: TMenuItem;
    NewFinderCircle1: TMenuItem;
    N1: TMenuItem;
    N2: TMenuItem;
    RemoveLastCircle1: TMenuItem;
    RemoveAllCircles1: TMenuItem;
    AbortSlew1: TMenuItem;
    TelescopeTimer: TTimer;
    N3: TMenuItem;
    TrackOn1: TMenuItem;
    TrackOff1: TMenuItem;
    procedure About1Click(Sender: TObject);
    procedure AddLabel1Click(Sender: TObject);
    procedure BlinkTimerTimer(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure ChartResize(Sender: TObject);
    procedure HorScrollBarChange(Sender: TObject);
    procedure HorScrollBarScroll(Sender: TObject; ScrollCode: TScrollCode;
      var ScrollPos: Integer);
    procedure RefreshTimerTimer(Sender: TObject);
    procedure RemoveAllLabel1Click(Sender: TObject);
    procedure RemoveLastLabel1Click(Sender: TObject);
    procedure VertScrollBarChange(Sender: TObject);
    procedure VertScrollBarScroll(Sender: TObject; ScrollCode: TScrollCode;
      var ScrollPos: Integer);
    procedure zoomplusExecute(Sender: TObject);
    procedure zoomminusExecute(Sender: TObject);
    procedure MoveWestExecute(Sender: TObject);
    procedure MoveEastExecute(Sender: TObject);
    procedure MoveNorthExecute(Sender: TObject);
    procedure MoveSouthExecute(Sender: TObject);
    procedure MoveNorthWestExecute(Sender: TObject);
    procedure MoveNorthEastExecute(Sender: TObject);
    procedure MoveSouthWestExecute(Sender: TObject);
    procedure MoveSouthEastExecute(Sender: TObject);
    procedure CentreExecute(Sender: TObject);
    procedure PopupMenu1Popup(Sender: TObject);
    procedure zoomminusmoveExecute(Sender: TObject);
    procedure zoomplusmoveExecute(Sender: TObject);
    procedure FlipXExecute(Sender: TObject);
    procedure FlipYExecute(Sender: TObject);
    procedure UndoExecute(Sender: TObject);
    procedure RedoExecute(Sender: TObject);
    procedure rot_plusExecute(Sender: TObject);
    procedure rot_minusExecute(Sender: TObject);
    procedure GridEQExecute(Sender: TObject);
    procedure GridExecute(Sender: TObject);
    procedure identlabelClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure switchstarExecute(Sender: TObject);
    procedure switchbackgroundExecute(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure Connect1Click(Sender: TObject);
    procedure Slew1Click(Sender: TObject);
    procedure Sync1Click(Sender: TObject);
    procedure NewFinderCircle1Click(Sender: TObject);
    procedure RemoveLastCircle1Click(Sender: TObject);
    procedure RemoveAllCircles1Click(Sender: TObject);
    procedure AbortSlew1Click(Sender: TObject);
    procedure TelescopeTimerTimer(Sender: TObject);
    procedure TrackOn1Click(Sender: TObject);
    procedure TrackOff1Click(Sender: TObject);
  private
    { Private declarations }
    Ftelescope: Ttelescope;
    FImageSetFocus: TnotifyEvent;
    FSetFocus: TnotifyEvent;
    FShowTopMessage: Tstr1func;
    FUpdateBtn: Tbtnfunc;
    FShowInfo : Tshowinfo;
    FShowCoord: Tstr1func;
    FListInfo: Tstr1func;
    FChartMove: TnotifyEvent;
    movefactor,zoomfactor: double;
    xcursor,ycursor,skipmove : integer;
    MovingCircle,FNightVision,StartCircle,lockkey: Boolean;
    SaveColor: Starcolarray;
    SaveLabelColor: array[1..numlabtype] of Tcolor;
    procedure TelescopeCoordChange(Sender: TObject);
    procedure TelescopeStatusChange(Sender : Tobject; source: TIndiSource; status: TIndistatus);
    procedure TelescopeGetMessage(Sender : TObject; const msg : string);
    procedure ConnectPlugin(Sender: TObject);
    procedure SlewPlugin(Sender: TObject);
    procedure AbortSlewPlugin(Sender: TObject);
    procedure SyncPlugin(Sender: TObject);
    procedure SetNightVision(value:boolean);
    procedure Image1Click(Sender: TObject);
    procedure Image1MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure Image1MouseMove(Sender: TObject; Shift: TShiftState; X,Y: Integer);
    procedure Image1MouseUp(Sender: TObject; Button: TMouseButton;Shift: TShiftState; X, Y: Integer);
    procedure Image1MouseWheel(Sender: TObject; Shift: TShiftState; WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
    procedure Image1Paint(Sender: TObject);
    procedure SetScrollBar;
    procedure ShowCoord(x,y: Integer);
  public
    { Public declarations }
    Image1 : TChartDrawingControl;
    ChartCursor: TCursor;
    sc: Tskychart;
    indi1: TIndiClient;
    locked,LockTrackCursor,LockKeyboard,lastquick,lock_refresh,lockscrollbar :boolean;
    undolist : array[1..maxundo] of Tconf_skychart;
    lastundo,curundo,validundo, lastx,lasty,lastyzoom  : integer;
    zoomstep,Xzoom1,Yzoom1,Xzoom2,Yzoom2,DXzoom,DYzoom,XZoomD1,YZoomD1,XZoomD2,YZoomD2,ZoomMove : integer;
    procedure Refresh;
    procedure AutoRefresh;
    procedure PrintChart(printlandscape:boolean; printcolor,printmethod,printresol:integer ;printcmd1,printcmd2,printpath:string; cm:Tconf_main);
    function  FormatDesc:string;
    procedure ShowIdentLabel;
    function  IdentXY(X, Y: Integer;searchcenter: boolean= true):boolean;
    procedure Identdetail(X, Y: Integer);
    function  ListXY(X, Y: Integer):boolean;
    function  LongLabel(txt:string):string;
    function  LongLabelObj(txt:string):string;
    function  LongLabelGreek(txt : string) : string;
    Function  LongLabelConst(txt : string) : string;
    procedure CKeyDown(var Key: Word; Shift: TShiftState);
    procedure rotation(rot:double);
    function cmd_SetCursorPosition(x,y:integer):string;
    function cmd_SetGridEQ(onoff:string):string;
    function cmd_SetGrid(onoff:string):string;
    function cmd_SetStarMode(i:integer):string;
    function cmd_SetNebMode(i:integer):string;
    function cmd_SetSkyMode(onoff:string):string;
    function cmd_SetProjection(proj:string):string;
    function cmd_SetFov(fov:string):string;
    function cmd_SetRa(param1:string):string;
    function cmd_SetDec(param1:string):string;
    function cmd_SetDate(dt:string):string;
    function cmd_SetObs(obs:string):string;
    function cmd_IdentCursor:string;
    function cmd_SaveImage(format,fn,quality:string):string;
    function ExecuteCmd(arg:Tstringlist):string;
    function SaveChartImage(format,fn : string; quality: integer=95):boolean;
    Procedure ZoomBox(action,x,y:integer);
    Procedure TrackCursor(X,Y : integer);
    Procedure ZoomCursor(yy : double);
    procedure SetField(field : double);
    procedure SetZenit(field : double; redraw:boolean=true);
    procedure SetAz(Az : double; redraw:boolean=true);
    procedure SetDateUT(y,m,d,h,n,s:integer);
    procedure SetJD(njd:double);
    function cmd_GetProjection:string;
    function cmd_GetSkyMode:string;
    function cmd_GetNebMode:string;
    function cmd_GetStarMode:string;
    function cmd_GetGrid:string;
    function cmd_GetGridEQ:string;
    function cmd_GetCursorPosition :string;
    function cmd_GetFov(format:string):string;
    function cmd_GetRA(format:string):string;
    function cmd_GetDEC(format:string):string;
    function cmd_GetDate:string;
    function cmd_GetObs:string;
    function cmd_SetTZ(tz:string):string;
    function cmd_GetTZ:string;
    procedure cmd_GoXY(xx,yy : string);
    function cmd_IdXY(xx,yy : string): string;
    procedure cmd_MoreStar;
    procedure cmd_LessStar;
    procedure cmd_MoreNeb;
    procedure cmd_LessNeb;
    function cmd_SetGridNum(onoff:string):string;
    function cmd_SetConstL(onoff:string):string;
    function cmd_SetConstB(onoff:string):string;
    function cmd_SwitchGridNum:string;
    function cmd_SwitchConstL:string;
    function cmd_SwitchConstB:string;
    procedure SetLang;
    procedure ChartActivate;
    property telescopeplugin: Ttelescope read Ftelescope write Ftelescope;
    property OnImageSetFocus: TNotifyEvent read FImageSetFocus write FImageSetFocus;
    property OnSetFocus: TNotifyEvent read FSetFocus write FSetFocus;
    property OnShowTopMessage: Tstr1func read FShowTopMessage write FShowTopMessage;
    property OnUpdateBtn: Tbtnfunc read FUpdateBtn write FUpdateBtn;
    property OnShowInfo: TShowinfo read FShowInfo write FShowInfo;
    property OnShowCoord: Tstr1func read FShowCoord write FShowCoord;
    property OnListInfo: Tstr1func read FListInfo write FListInfo;
    property OnChartMove: TNotifyEvent read FChartMove write FChartMove;
    property NightVision: Boolean read FNightVision write SetNightVision;
  end;

implementation

procedure Tf_chart.SetLang;
begin
About1.caption:=rsAbout;
Centre1.caption:=rsCentre;
Zoom1.caption:=rsZoomCentre;
Zoom2.caption:=rsZoomCentre2;
NewFinderCircle1.caption:=rsNewFinderCir;
RemoveLastCircle1.caption:=rsRemoveLastCi;
RemoveAllCircles1.caption:=rsRemoveAllCir;
AddLabel1.caption:=rsNewLabel;
RemoveLastLabel1.caption:=rsRemoveLastLa;
RemoveAllLabel1.caption:=rsRemoveAllLab;
elescope1.caption:=rsTelescope;
Slew1.caption:=rsSlew;
Sync1.caption:=rsSync;
Connect1.caption:=rsConnect;
AbortSlew1.caption:=rsAbortSlew;
TrackOff1.caption:=rsUnlockChart;
if sc<>nil then sc.SetLang;
end;

procedure Tf_chart.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  RefreshTimer.Enabled:=false;
{$ifdef win32}
  TelescopeTimer.Enabled:=false;
 {$endif}
  Action := caFree;
end;

procedure Tf_chart.FormCreate(Sender: TObject);
var i: integer;
begin
 locked:=true;
 lockkey:=false;
 SetLang;
 for i:=1 to maxundo do undolist[i]:=Tconf_skychart.Create;
 Image1:= TChartDrawingControl.Create(Self);
 Image1.Parent := Panel1;
 IdentLabel.Parent:=Image1;
 Image1.Align:=alClient;
 Image1.DoubleBuffered := True;
 Image1.PopupMenu:=popupmenu1;
 Image1.OnClick:=Image1Click;
 Image1.OnMouseDown:=Image1MouseDown;
 Image1.OnMouseMove:=Image1MouseMove;
 Image1.OnMouseUp:=Image1MouseUp;
 Image1.OnMouseWheel:=Image1MouseWheel;
 Image1.OnPaint:=Image1Paint;

 sc:=Tskychart.Create(Image1);
 sc.Image:=Image1.Canvas;
 // set initial value
 sc.cfgsc.racentre:=1.4;
 sc.cfgsc.decentre:=0;
 sc.cfgsc.fov:=1;
 sc.cfgsc.theta:=0;
 sc.cfgsc.projtype:='A';
 sc.cfgsc.ProjPole:=Equat;
 sc.cfgsc.FlipX:=1;
 sc.cfgsc.FlipY:=1;
 sc.onShowDetailXY:=IdentDetail;
 sc.InitChart;
 skipmove:=0;
 movefactor:=4;
 zoomfactor:=2;
 lastundo:=0;
 validundo:=0;
 LockKeyboard:=false;
 LockTrackCursor:=false;
 ChartCursor:=crRetic;
 Image1.Cursor := ChartCursor;
 lock_refresh:=false;
 MovingCircle:=false;
 // must use onScroll on Windows to solve bug 193
 // but Gtk need onChange
 {$ifdef win32}
   HorScrollBar.onScroll:=HorScrollBarScroll;
   VertScrollBar.onScroll:=VertScrollBarScroll;
 {$else}
   HorScrollBar.onChange:=HorScrollBarChange;
   VertScrollBar.onChange:=VertScrollBarChange;
 {$endif}
 VertScrollBar.Max:=90*3600;   // arcsecond position precision
 VertScrollBar.Min:=-90*3600;
 VertScrollBar.SmallChange:=3600;
 VertScrollBar.LargeChange:=8*VertScrollBar.SmallChange;
 VertScrollBar.PageSize:=VertScrollBar.LargeChange;
 VertScrollBar.Width:=HorScrollBar.Height;
 HorScrollBar.Max:=360*3600;
 HorScrollBar.Min:=0;
 HorScrollBar.SmallChange:=3600;
 HorScrollBar.LargeChange:=8*HorScrollBar.SmallChange;
 HorScrollBar.PageSize:=HorScrollBar.LargeChange;
end;

procedure Tf_chart.FormDestroy(Sender: TObject);
var i: integer;
begin
try
 locked:=true;
 if sc<>nil then sc.free;
 Image1.Free;
 if indi1<>nil then begin
   indi1.onCoordChange:=nil;
   indi1.onStatusChange:=nil;
   indi1.onMessage:=nil;
   indi1.terminate;
 end;
 for i:=1 to maxundo do undolist[i].Free;
except
writetrace('error destroy '+name);
end;
end;

procedure Tf_chart.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
CKeyDown(Key,Shift);
end;

procedure Tf_chart.Image1Click(Sender: TObject);
begin
// to restore focus to the chart that as no text control
if assigned(FSetFocus) then FSetFocus(Self);
if assigned(FImageSetFocus) then FImageSetFocus(Sender);
//setfocus;
end;

procedure Tf_chart.AutoRefresh;
begin
if locked then exit;
if (not sc.cfgsc.TrackOn)and(sc.cfgsc.Projpole=Altaz) then begin
  sc.cfgsc.TrackOn:=true;
  sc.cfgsc.TrackType:=4;
end;
Refresh;
end;

procedure Tf_chart.Refresh;
var  savebg:Tcolor;
{$ifdef showtime}
     starttime:TDateTime;
{$endif}
begin
{$ifdef showtime}
starttime:=now;
{$endif}
try
if locked then exit;
if lock_refresh then exit;
 lock_refresh:=true;
 lastquick:=sc.cfgsc.quick;
 if not lastquick then screen.cursor:=crHourGlass;
 zoomstep:=0;
 identlabel.visible:=false;
 Image1.width:=clientwidth;
 Image1.height:=clientheight;
 sc.plot.init(Image1.width,Image1.height);
 savebg:=sc.plot.cfgplot.color[0];
 if (sc.plot.cfgplot.color[0]<clWhite) and
    not(sc.plot.cfgplot.AutoSkyColor and (sc.cfgsc.Projpole=AltAz)) then
    sc.plot.cfgplot.bgcolor:=sc.plot.cfgplot.skycolor[0];
 sc.Refresh;
 sc.plot.cfgplot.color[0]:=savebg;
 Image1.Invalidate;
 if not lastquick then begin
    inc(lastundo); inc(validundo);
    if lastundo>maxundo then lastundo:=1;
    undolist[lastundo].Assign(sc.cfgsc);
    curundo:=lastundo;
    Identlabel.color:=sc.plot.cfgplot.color[0];
    Identlabel.font.color:=sc.plot.cfgplot.color[11];
    if sc.cfgsc.FindOk then ShowIdentLabel;
    if assigned(fshowtopmessage) then fshowtopmessage(sc.GetChartInfo);
    Image1.Cursor:=ChartCursor;
end;
finally
 lock_refresh:=false;
 screen.cursor:=crDefault;
 if (not lastquick) and assigned(FUpdateBtn) then FUpdateBtn(sc.cfgsc.flipx,sc.cfgsc.flipy,Connect1.checked,self);
 if (not lastquick) and sc.cfgsc.moved and assigned(FChartMove) then FChartMove(self);
end;
if assigned(FImageSetFocus) then FImageSetFocus(Self);
if assigned(Fshowinfo) then begin
  {$ifdef showtime}
   Fshowinfo('Drawing time: '+formatfloat(f2,(now-starttime)*86400));
  {$else}
  if sc.cfgsc.TrackOn then
    IdentXY(Image1.Width div 2, Image1.Height div 2)
  else
    Fshowinfo('');
  {$endif}
end;
SetScrollBar;
end;

procedure Tf_chart.UndoExecute(Sender: TObject);
var i,j : integer;
begin
if locked then exit;
zoomstep:=0;
i:=curundo-1;
j:=lastundo+1;
if i<1 then i:=maxundo;
if j>maxundo then j:=1;
if (i<=validundo)and(i<>lastundo)and((i<lastundo)or(i>=j)) then begin
  curundo:=i;
  sc.cfgsc.Assign(undolist[curundo]);
  sc.plot.init(Image1.width,Image1.height);
  sc.Refresh;
  Image1.Invalidate;
  if assigned(FUpdateBtn) then FUpdateBtn(sc.cfgsc.flipx,sc.cfgsc.flipy,Connect1.checked,self);
  if assigned(fshowtopmessage) then fshowtopmessage(sc.GetChartInfo);
  if assigned(FChartMove) then FChartMove(self);
  SetScrollBar;
end;
end;

procedure Tf_chart.RedoExecute(Sender: TObject);
var i,j : integer;
begin
if locked then exit;
zoomstep:=0;
i:=curundo+1;
j:=lastundo+1;
if i>maxundo then i:=1;
if j>maxundo then j:=1;
if (i<=validundo)and(i<>j)and((i<=lastundo)or(i>j)) then begin
  curundo:=i;
  sc.cfgsc.Assign(undolist[curundo]);
  sc.plot.init(Image1.width,Image1.height);
  sc.Refresh;
  Image1.Invalidate;
  if assigned(FUpdateBtn) then FUpdateBtn(sc.cfgsc.flipx,sc.cfgsc.flipy,Connect1.checked,self);
  if assigned(fshowtopmessage) then fshowtopmessage(sc.GetChartInfo);
  if assigned(FChartMove) then FChartMove(self);
  SetScrollBar;
end;
end;

procedure Tf_chart.ChartResize(Sender: TObject);
begin
if locked or (fsCreating in FormState) then exit;
RefreshTimer.Enabled:=false;
RefreshTimer.Enabled:=true;
with Image1.Canvas do begin
 Brush.Color:=sc.plot.cfgplot.Color[0];
 Pen.Color:=sc.plot.cfgplot.Color[0];
 Brush.style:=bsSolid;
 Pen.Mode:=pmCopy;
 Pen.Style:=psSolid;
 Rectangle(0,0,Image1.Width,Image1.Height);
end;
if sc<>nil then sc.plot.init(Image1.width,Image1.height);
end;

procedure Tf_chart.SetScrollBar;
var i: integer;
begin
lockscrollbar:=true;
try
if VertScrollBar.Visible then
with sc do begin
 if cfgsc.Projpole=AltAz then begin
    HorScrollBar.Position:=round(rmod(cfgsc.acentre+pi2,pi2)*rad2deg*3600);
    VertScrollBar.Position:=-round(cfgsc.hcentre*rad2deg*3600);
 end
 else if cfgsc.Projpole=Gal then begin
    HorScrollBar.Position:=round(rmod(pi2-cfgsc.lcentre+pi2,pi2)*rad2deg*3600);
    VertScrollBar.Position:=-round(cfgsc.bcentre*rad2deg*3600);
 end
 else if cfgsc.Projpole=Ecl then begin
    HorScrollBar.Position:=round(rmod(pi2-cfgsc.lecentre+pi2,pi2)*rad2deg*3600);
    VertScrollBar.Position:=-round(cfgsc.becentre*rad2deg*3600);
 end
 else begin // Equ
    HorScrollBar.Position:=round(rmod(pi2-cfgsc.racentre+pi2,pi2)*rad2deg*3600);
    VertScrollBar.Position:=-round(cfgsc.decentre*rad2deg*3600);
 end;
 i:=round(rad2deg*3600*cfgsc.fov/90);
 if i<1 then i:=1;
 if i>3600 then i:=3600;
 VertScrollBar.SmallChange:=i;
 VertScrollBar.LargeChange:=8*VertScrollBar.SmallChange;
 VertScrollBar.PageSize:=VertScrollBar.LargeChange;
 HorScrollBar.SmallChange:=i;
 HorScrollBar.LargeChange:=8*HorScrollBar.SmallChange;
 HorScrollBar.PageSize:=HorScrollBar.LargeChange;
// application.ProcessMessages;
 ShowCoord(Image1.Width div 2, Image1.Height div 2);
end;
finally
lockscrollbar:=false;
end;
end;

procedure Tf_chart.HorScrollBarChange(Sender: TObject);
var i: integer;
begin
  HorScrollBarScroll(Sender,scTrack,i);
end;

procedure Tf_chart.HorScrollBarScroll(Sender: TObject; ScrollCode: TScrollCode;
  var ScrollPos: Integer);
begin
{$ifdef win32}
if ScrollCode in [scPageUp,scPageDown] then exit; // do not refresh while scrolling scEndScroll do the final refresh
{$endif}
if lockscrollbar then exit;
lockscrollbar:=true;
try
with sc do begin
 cfgsc.TrackOn:=false;
 cfgsc.Quick:=true;
 if cfgsc.Projpole=AltAz then begin
    cfgsc.acentre:=rmod(deg2rad*HorScrollBar.Position/3600+pi2,pi2);
    Hz2Eq(cfgsc.acentre,cfgsc.hcentre,cfgsc.racentre,cfgsc.decentre,cfgsc);
    cfgsc.racentre:=cfgsc.CurST-cfgsc.racentre;
 end
 else if cfgsc.Projpole=Gal then begin
    cfgsc.lcentre:=rmod(pi2-deg2rad*HorScrollBar.Position/3600+pi2,pi2);
    Gal2Eq(cfgsc.lcentre,cfgsc.bcentre,cfgsc.racentre,cfgsc.decentre,cfgsc);
 end
 else if cfgsc.Projpole=Ecl then begin
    cfgsc.lecentre:=rmod(pi2-deg2rad*HorScrollBar.Position/3600+pi2,pi2);
    Ecl2Eq(cfgsc.lecentre,cfgsc.becentre,cfgsc.e,cfgsc.racentre,cfgsc.decentre);
 end
 else begin // Equ
    cfgsc.racentre:=rmod(pi2-deg2rad*HorScrollBar.Position/3600+pi2,pi2);
end;
end;
Refresh;
//application.processmessages;
RefreshTimer.enabled:=false;
RefreshTimer.enabled:=true;
finally
lockscrollbar:=false;
end;
end;

procedure Tf_chart.VertScrollBarChange(Sender: TObject);
var i: integer;
begin
  VertScrollBarScroll(Sender,scTrack,i);
end;

procedure Tf_chart.VertScrollBarScroll(Sender: TObject;
  ScrollCode: TScrollCode; var ScrollPos: Integer);
begin
{$ifdef win32}
if ScrollCode in [scPageUp,scPageDown] then exit; // do not refresh while scrolling scEndScroll do the final refresh
{$endif}
if lockscrollbar then exit;
lockscrollbar:=true;
try
with sc do begin
 cfgsc.TrackOn:=false;
 cfgsc.Quick:=true;
 if cfgsc.Projpole=AltAz then begin
    cfgsc.hcentre:=-deg2rad*VertScrollBar.Position/3600;
    if cfgsc.hcentre>pid2 then cfgsc.hcentre:=pi-cfgsc.hcentre;
    Hz2Eq(cfgsc.acentre,cfgsc.hcentre,cfgsc.racentre,cfgsc.decentre,cfgsc);
    cfgsc.racentre:=cfgsc.CurST-cfgsc.racentre;
 end
 else if cfgsc.Projpole=Gal then begin
    cfgsc.bcentre:=-deg2rad*VertScrollBar.Position/3600;
    if cfgsc.bcentre>pid2 then cfgsc.bcentre:=pi-cfgsc.bcentre;
    Gal2Eq(cfgsc.lcentre,cfgsc.bcentre,cfgsc.racentre,cfgsc.decentre,cfgsc);
 end
 else if cfgsc.Projpole=Ecl then begin
    cfgsc.becentre:=-deg2rad*VertScrollBar.Position/3600;
    if cfgsc.becentre>pid2 then cfgsc.becentre:=pi-cfgsc.becentre;
    Ecl2Eq(cfgsc.lecentre,cfgsc.becentre,cfgsc.e,cfgsc.racentre,cfgsc.decentre);
 end
 else begin // Equ
    cfgsc.decentre:=-deg2rad*VertScrollBar.Position/3600;
    if cfgsc.decentre>pid2 then cfgsc.decentre:=pi-cfgsc.decentre;
end;
end;
Refresh;
//application.processmessages;
RefreshTimer.enabled:=false;
RefreshTimer.enabled:=true;
finally
lockscrollbar:=false;
end;
end;

procedure Tf_chart.Image1Paint(Sender: TObject);
begin
ZoomStep:=0;
sc.plot.FlushCnv;
if StartCircle then begin
  sc.DrawFinderMark(sc.cfgsc.CircleLst[0,1],sc.cfgsc.CircleLst[0,2],true);
  StartCircle:=false;
  end
  else MovingCircle := false;
inherited Paint;
end;

procedure TChartDrawingControl.Paint;
begin
  inherited Paint;
end;

procedure Tf_chart.RefreshTimerTimer(Sender: TObject);
begin
RefreshTimer.Enabled:=false;
if locked then exit;
if sc<>nil then sc.plot.init(Image1.width,Image1.height);
Refresh;
end;

procedure Tf_chart.RemoveAllLabel1Click(Sender: TObject);
begin
sc.cfgsc.poscustomlabels:=0;
sc.cfgsc.numcustomlabels:=0;
Refresh;
end;

procedure Tf_chart.RemoveLastLabel1Click(Sender: TObject);
var j: integer;
begin
if sc.cfgsc.poscustomlabels>0 then begin
  for j:=sc.cfgsc.poscustomlabels+1 to sc.cfgsc.numcustomlabels do
      sc.cfgsc.customlabels[j-1]:=sc.cfgsc.customlabels[j];
  dec(sc.cfgsc.numcustomlabels);
  sc.cfgsc.poscustomlabels:=sc.cfgsc.numcustomlabels;
end;
Refresh;
end;

procedure Tf_chart.PrintChart(printlandscape:boolean; printcolor,printmethod,printresol:integer ;printcmd1,printcmd2,printpath:string; cm:Tconf_main);
var savecolor: Starcolarray;
    savesplot,savenplot,savepplot,savebgcolor,resol: integer;
    saveskycolor: boolean;
    saveLabelColor : array[1..numlabtype] of Tcolor;
    prtname:string;
    prtbmp:Tbitmap;
    fname:WideString;
    i,w,h :integer;
    ps:TPostscriptCanvas;
 begin
 zoomstep:=0;
 // save current state
 savecolor:=sc.plot.cfgplot.color;
 savesplot:=sc.plot.cfgplot.starplot;
 savenplot:=sc.plot.cfgplot.nebplot;
 savepplot:=sc.plot.cfgplot.plaplot;
 saveskycolor:=sc.plot.cfgplot.autoskycolor;
 savebgcolor:=sc.plot.cfgplot.bgColor;
 for i:=1 to numlabtype do saveLabelColor[i]:=sc.plot.cfgplot.LabelColor[i];
 prtbmp:=Tbitmap.create;
try
 screen.cursor:=crHourGlass;
 if printcolor<>2 then begin
   // force line drawing
   sc.plot.cfgplot.starplot:=0;
   sc.plot.cfgplot.nebplot:=0;
   if sc.plot.cfgplot.plaplot=2 then sc.plot.cfgplot.plaplot:=1;
   // ensure white background
   sc.plot.cfgplot.autoskycolor:=false;
   if printcolor=0 then begin
     sc.plot.cfgplot.color[0]:=clWhite;
     sc.plot.cfgplot.color[11]:=clBlack;
   end else begin
     sc.plot.cfgplot.color:=DfWBColor;
   end;
   if printcolor<2 then for i:=1 to numlabtype do sc.plot.cfgplot.LabelColor[i]:=clBlack;
   sc.plot.cfgplot.bgColor:=sc.plot.cfgplot.color[0];
 end;
 if (printcolor=2)and(sc.plot.cfgplot.starplot=2) then sc.plot.cfgplot.starplot:=1;
 Case PrintMethod of
 0: begin    // to printer
    GetPrinterResolution(prtname,resol);
    if PrintLandscape then Printer.Orientation:=poLandscape
                   else Printer.Orientation:=poPortrait;
    // print
    Printer.Title:='CdC';
    Printer.BeginDoc;
    sc.plot.destcnv:=Printer.canvas;
    sc.plot.cfgchart.onprinter:=true;
    sc.plot.cfgchart.drawpen:=maxintvalue([1,resol div 150]);
    sc.plot.cfgchart.drawsize:=maxintvalue([1,resol div 100]);
    sc.plot.cfgchart.fontscale:=1;
    sc.cfgsc.LeftMargin:=mm2pi(cm.PrtLeftMargin,resol);
    sc.cfgsc.RightMargin:=mm2pi(cm.PrtRightMargin,resol);
    sc.cfgsc.TopMargin:=mm2pi(cm.PrtTopMargin,resol);
    sc.cfgsc.BottomMargin:=mm2pi(cm.PrtBottomMargin,resol);
    sc.cfgsc.xshift:=printer.PaperSize.PaperRect.WorkRect.Left+sc.cfgsc.LeftMargin;
    sc.cfgsc.yshift:=printer.PaperSize.PaperRect.WorkRect.Top+sc.cfgsc.TopMargin;
    w:=Printer.PageWidth;
    h:=Printer.PageHeight;
    sc.plot.init(w,h);
    sc.Refresh;
    Printer.EndDoc;
    end;
 1: begin  // to postscript canvas
    if assigned(Fshowinfo) then Fshowinfo(rsCreatePostsc , caption);
    ps:=TPostscriptCanvas.Create;
    if PrintLandscape then begin
       ps.pagewidth:=11*printresol;
       ps.pageheight:=8*printresol;
    end else begin
       ps.pagewidth:=8*printresol;
       ps.pageheight:=11*printresol;
    end;
   // draw the chart
    ps.begindoc;
    sc.plot.destcnv:=ps;
    sc.plot.cfgchart.onprinter:=true;
    sc.plot.cfgchart.drawpen:=maxintvalue([1,printresol div 150]);
    sc.plot.cfgchart.drawsize:=maxintvalue([1,printresol div 100]);
    sc.plot.cfgchart.fontscale:=sc.plot.cfgchart.drawsize; // because we cannot set a dpi property for the bitmap
    sc.cfgsc.LeftMargin:=mm2pi(cm.PrtLeftMargin,printresol);
    sc.cfgsc.RightMargin:=mm2pi(cm.PrtRightMargin,printresol);
    sc.cfgsc.TopMargin:=mm2pi(cm.PrtTopMargin,printresol);
    sc.cfgsc.BottomMargin:=mm2pi(cm.PrtBottomMargin,printresol);
    sc.cfgsc.xshift:=sc.cfgsc.LeftMargin;
    sc.cfgsc.yshift:=sc.cfgsc.TopMargin;
    sc.plot.init(ps.pagewidth,ps.pageheight);
    sc.Refresh;
    ps.enddoc;
    fname:=slash(printpath)+'cdcprint.ps';
    ps.savetofile(fname);
    chdir(appdir);
    if assigned(Fshowinfo) then Fshowinfo(rsSendChartToP , caption);
    execnowait(printcmd1+' "'+fname+'"');
    end;
 2: begin  // to bitmap
    if assigned(Fshowinfo) then Fshowinfo(Format(rsCreateRaster, [inttostr(
      printresol)]) , caption);
    //prtbmp.pixelformat:=pf32bit;
    if PrintLandscape then begin
       prtbmp.width:=11*printresol;
       prtbmp.height:=8*printresol;
    end else begin
       prtbmp.width:=8*printresol;
       prtbmp.height:=11*printresol;
    end;
   // draw the chart to the bitmap
    sc.plot.destcnv:=prtbmp.canvas;
    sc.plot.cfgchart.onprinter:=true;
    sc.plot.cfgchart.drawpen:=maxintvalue([1,printresol div 150]);
    sc.plot.cfgchart.drawsize:=maxintvalue([1,printresol div 100]);
    sc.plot.cfgchart.fontscale:=sc.plot.cfgchart.drawsize; // because we cannot set a dpi property for the bitmap
    sc.cfgsc.LeftMargin:=mm2pi(cm.PrtLeftMargin,printresol);
    sc.cfgsc.RightMargin:=mm2pi(cm.PrtRightMargin,printresol);
    sc.cfgsc.TopMargin:=mm2pi(cm.PrtTopMargin,printresol);
    sc.cfgsc.BottomMargin:=mm2pi(cm.PrtBottomMargin,printresol);
    sc.cfgsc.xshift:=sc.cfgsc.LeftMargin;
    sc.cfgsc.yshift:=sc.cfgsc.TopMargin;
    sc.plot.init(prtbmp.width,prtbmp.height);
    sc.Refresh;
    // save the bitmap
    fname:=slash(printpath)+'cdcprint.bmp';
    prtbmp.savetofile(fname);
    if printcmd2<>'' then begin
       if assigned(Fshowinfo) then Fshowinfo(rsOpenTheBitma , caption);
       execnowait(printcmd2+' "'+fname+'"','',false);
    end;
 end;
end;
finally
 chdir(appdir);
 screen.cursor:=crDefault;
 prtbmp.free;
 // restore state
 sc.plot.cfgplot.color:=savecolor;
 sc.plot.cfgplot.starplot:=savesplot;
 sc.plot.cfgplot.nebplot:=savenplot;
 sc.plot.cfgplot.plaplot:=savepplot;
 sc.plot.cfgplot.autoskycolor:=saveskycolor;
 sc.plot.cfgplot.bgColor:=savebgcolor;
 for i:=1 to numlabtype do sc.plot.cfgplot.LabelColor[i]:=saveLabelColor[i];
 sc.cfgsc.xshift:=0;
 sc.cfgsc.yshift:=0;
 sc.cfgsc.LeftMargin:=0;
 sc.cfgsc.RightMargin:=0;
 sc.cfgsc.TopMargin:=0;
 sc.cfgsc.BottomMargin:=0;
 // redraw to screen
 sc.plot.destcnv:=Image1.canvas;
 sc.plot.cfgchart.onprinter:=false;
 sc.plot.cfgchart.drawpen:=1;
 sc.plot.cfgchart.drawsize:=1;
 sc.plot.cfgchart.fontscale:=1;
 sc.plot.init(Image1.width,Image1.height);
 sc.Refresh;
 Image1.Invalidate;
 SetScrollBar;
end;
end;

procedure Tf_chart.ChartActivate;
begin
// code to execute when the chart get focus.
if assigned(FUpdateBtn) then FUpdateBtn(sc.cfgsc.flipx,sc.cfgsc.flipy,Connect1.checked,self);
if assigned(fshowtopmessage) then fshowtopmessage(sc.GetChartInfo);
if sc.cfgsc.FindOk and assigned(Fshowinfo) then Fshowinfo(sc.cfgsc.FindDesc,caption,false);
end;

procedure Tf_chart.FlipxExecute(Sender: TObject);
begin
 sc.cfgsc.FlipX:=-sc.cfgsc.FlipX;
 if assigned(FUpdateBtn) then FUpdateBtn(sc.cfgsc.flipx,sc.cfgsc.flipy,Connect1.checked,self);
 Refresh;
end;

procedure Tf_chart.FlipyExecute(Sender: TObject);
begin
 sc.cfgsc.FlipY:=-sc.cfgsc.FlipY;
 if assigned(FUpdateBtn) then FUpdateBtn(sc.cfgsc.flipx,sc.cfgsc.flipy,Connect1.checked,self);
 Refresh;
end;

procedure Tf_chart.rotation(rot:double);
begin
 sc.cfgsc.theta:=sc.cfgsc.theta+deg2rad*rot;
 Refresh;
end;

procedure Tf_chart.rot_plusExecute(Sender: TObject);
begin
 rotation(15);
end;

procedure Tf_chart.rot_minusExecute(Sender: TObject);
begin
 rotation(-15);
end;

procedure Tf_chart.GridEQExecute(Sender: TObject);
begin
 sc.cfgsc.ShowEqGrid := not sc.cfgsc.ShowEqGrid;
 Refresh;
end;

procedure Tf_chart.GridExecute(Sender: TObject);
begin
 sc.cfgsc.ShowGrid := not sc.cfgsc.ShowGrid;
 Refresh;
end;

procedure Tf_chart.zoomplusExecute(Sender: TObject);
begin
sc.zoom(zoomfactor);
Refresh;
end;

procedure Tf_chart.zoomminusExecute(Sender: TObject);
begin
sc.zoom(1/zoomfactor);
Refresh;
end;

procedure Tf_chart.zoomplusmoveExecute(Sender: TObject);
begin
sc.zoom(zoomfactor);
sc.MovetoXY(xcursor,ycursor);
sc.cfgsc.TrackOn:=false;
Refresh;
end;

procedure Tf_chart.zoomminusmoveExecute(Sender: TObject);
begin
sc.zoom(1/zoomfactor);
sc.MovetoXY(xcursor,ycursor);
sc.cfgsc.TrackOn:=false;
Refresh;
end;

procedure Tf_chart.MoveWestExecute(Sender: TObject);
begin
 sc.MoveChart(0,-1,movefactor);
 Refresh;
end;

procedure Tf_chart.MoveEastExecute(Sender: TObject);
begin
 sc.MoveChart(0,1,movefactor);
 Refresh;
end;

procedure Tf_chart.MoveNorthExecute(Sender: TObject);
begin
 sc.MoveChart(1,0,movefactor);
 Refresh;
end;

procedure Tf_chart.MoveSouthExecute(Sender: TObject);
begin
 sc.MoveChart(-1,0,movefactor);
 Refresh;
end;

procedure Tf_chart.MoveNorthWestExecute(Sender: TObject);
begin
 sc.MoveChart(1,-1,movefactor);
 Refresh;
end;

procedure Tf_chart.MoveNorthEastExecute(Sender: TObject);
begin
 sc.MoveChart(1,1,movefactor);
 Refresh;
end;

procedure Tf_chart.MoveSouthWestExecute(Sender: TObject);
begin
 sc.MoveChart(-1,-1,movefactor);
 Refresh;
end;

procedure Tf_chart.MoveSouthEastExecute(Sender: TObject);
begin
 sc.MoveChart(-1,1,movefactor);
 Refresh;
end;

procedure Tf_chart.CKeyDown(var Key: Word; Shift: TShiftState);
begin
if LockKeyboard then exit;
try
LockKeyboard:=true;
movefactor:=6;
zoomfactor:=2;
if Shift = [ssShift] then begin
   movefactor:=12;
   zoomfactor:=1.5;
end;
if Shift = [ssCtrl] then begin
   movefactor:=4;
   zoomfactor:=3;
end;
case key of
key_upright   : MoveNorthWest.execute;
key_downright : MoveSouthWest.execute;
key_downleft  : MoveSouthEast.execute;
key_upleft    : MoveNorthEast.execute;
key_left      : MoveEast.execute;
key_up        : MoveNorth.execute;
key_right     : MoveWest.execute;
key_down      : MoveSouth.execute;
key_plus      : Zoomplus.execute;
key_minus     : Zoomminus.execute;
end;
movefactor:=4;
zoomfactor:=2;
application.processmessages;  // very important to empty the mouse event queue before to unlock
finally
LockKeyboard:=false;
end;
end;

procedure Tf_chart.PopupMenu1Popup(Sender: TObject);
begin
 xcursor:=Image1.ScreenToClient(mouse.cursorpos).x;
 ycursor:=Image1.ScreenToClient(mouse.cursorpos).y;
 IdentXY(xcursor, ycursor);
 if sc.cfgsc.TrackOn then begin
    TrackOff1.visible:=true;
    TrackOn1.visible:=false;
 end else begin
    TrackOff1.visible:=false;
    if ((sc.cfgsc.TrackType>=1)and(sc.cfgsc.TrackType<=3))or(sc.cfgsc.TrackType=6) then begin
      TrackOn1.Caption:=Format(rsLockOn, [sc.cfgsc.TrackName]);
      TrackOn1.visible:=true;
    end
    else TrackOn1.visible:=false;
 end;
 if sc.cfgsc.FindName>'' then begin
   About1.Caption:=Format(rsAbout2, [sc.cfgsc.FindName]);
   About1.visible:=true;
   About2.visible:=true;
 end
 else begin
   About1.visible:=false;
   About2.visible:=false;
 end;
end;

procedure Tf_chart.TrackOn1Click(Sender: TObject);

begin
  sc.cfgsc.TrackOn:=true;
  Refresh;
end;

procedure Tf_chart.TrackOff1Click(Sender: TObject);

begin
  sc.cfgsc.TrackOn:=false;
  Refresh;
end;

procedure Tf_chart.CentreExecute(Sender: TObject);
begin
  sc.MovetoXY(xcursor,ycursor);
  sc.cfgsc.TrackOn:=false;
  Refresh;
end;

procedure Tf_chart.Image1MouseWheel(Sender: TObject; Shift: TShiftState; WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
begin
handled:=true;
//lock_TrackCursor:=true;
if wheeldelta>0 then sc.Zoom(1.25)
                else sc.Zoom(0.8);
Refresh;
end;

Procedure Tf_chart.ShowIdentLabel;
var x,y : integer;
begin
if locked then exit;
if sc.cfgsc.FindOK then begin
   identlabel.Visible:=false;
   identlabel.font.name:=sc.plot.cfgplot.fontname[2];
   identlabel.font.size:=sc.plot.cfgplot.fontSize[2];
   identlabel.caption:=trim(sc.cfgsc.FindName);
   sc.GetLabPos(sc.cfgsc.FindRA,sc.cfgsc.FindDec,sc.cfgsc.FindSize/2,identlabel.Width,identlabel.Height,x,y);
   identlabel.left:=x;
   identlabel.top:=y;
   identlabel.Visible:=true;
   identlabel.Cursor:=crHandPoint;
   identlabel.bringtofront;
end
else identlabel.Visible:=false;
end;

function Tf_chart.IdentXY(X, Y: Integer;searchcenter: boolean=true):boolean;
var ra,dec,a,h,a1,h1,l,b,le,be,dx,dy,lastra,lastdec,lasttrra,lasttrde,dist:double;
    pa,lasttype,lastobj: integer;
    txt,lastname,lasttrname,buf: string;
    showdist:boolean;
begin
result:=false;
if locked then exit;
showdist:=sc.cfgsc.FindOk;
lastra:=sc.cfgsc.FindRA;
lastdec:=sc.cfgsc.FindDEC;
lastname:=sc.cfgsc.FindName;
lasttrra:=sc.cfgsc.TrackRA;
lasttrde:=sc.cfgsc.TrackDEC;
lasttype:=sc.cfgsc.TrackType;
lastobj:=sc.cfgsc.Trackobj;
lasttrname:=sc.cfgsc.TrackName;
sc.GetCoord(x,y,ra,dec,a,h,l,b,le,be);
ra:=rmod(ra+pi2,pi2);
dx:=abs(2/sc.cfgsc.BxGlb); // search a 2 pixel radius
result:=sc.FindatRaDec(ra,dec,dx,searchcenter);
if (not result) then result:=sc.FindatRaDec(ra,dec,3*dx,searchcenter);  //else 6 pixel
ShowIdentLabel;
if showdist then begin
   ra:=sc.cfgsc.FindRA;
   dec:=sc.cfgsc.FindDEC;
   dist := rad2deg*angulardistance(ra,dec,lastra,lastdec);
   if dist>0 then begin
      pa:=round(rmod(rad2deg*PositionAngle(lastra,lastdec,ra,dec)+360,360));
      txt:=DEptoStr(dist)+' PA:'+inttostr(pa)+ldeg;
      dx:=rmod((rad2deg*(ra-lastra)/15)+24,24);
      if dx>12 then dx:=dx-24;
      dy:=rad2deg*(dec-lastdec);
      txt:=txt+crlf+artostr(dx)+blank+detostr(dy);
      if assigned(Fshowcoord) then Fshowcoord(txt);
      buf:=rsFrom+' "'+lastname+'" '+rsTo+' "'+sc.cfgsc.FindName+'"'+tab+rsSeparation+': '+txt;
      txt:=stringreplace(buf,crlf,tab+rsOffset+':',[]);
      if assigned(Fshowinfo) then Fshowinfo(txt,caption,true,self);
      if sc.cfgsc.ManualTelescope then begin
        case sc.cfgsc.ManualTelescopeType of
         0 : begin
             txt:=Format(rsRATurns2, [txt+tab]);
             txt:=txt+blank+formatfloat(f2,abs(dx*sc.cfgsc.TelescopeTurnsX))+blank;
             if (dx*sc.cfgsc.TelescopeTurnsX)>0 then txt:=Format(rsCW, [txt])
                else txt:=Format(rsCCW, [txt]);
             txt:=Format(rsDECTurns2, [txt+tab]);
             txt:=txt+blank+formatfloat(f2,abs(dy*sc.cfgsc.TelescopeTurnsY))+blank;
             if (dy*sc.cfgsc.TelescopeTurnsY)>0 then txt:=Format(rsCW, [txt])
                else txt:=Format(rsCCW, [txt]);
             end;
         1 : begin
             Eq2Hz(sc.cfgsc.CurSt-ra,dec,a,h,sc.cfgsc) ;
             Eq2Hz(sc.cfgsc.CurSt-lastra,lastdec,a1,h1,sc.cfgsc) ;
             dx:=rmod((rad2deg*(a-a1))+360,360);
             if dx>180 then dx:=dx-360;
             dy:=rad2deg*(h-h1);
             txt:=Format(rsAzTurns, [txt+tab]);
             txt:=txt+blank+formatfloat(f2,abs(dx*sc.cfgsc.TelescopeTurnsX))+blank;
             if (dx*sc.cfgsc.TelescopeTurnsX)>0 then txt:=Format(rsCW, [txt])
                else txt:=Format(rsCCW, [txt]);
             txt:=Format(rsAltTurns, [txt+tab]);
             txt:=txt+blank+formatfloat(f2,abs(dy*sc.cfgsc.TelescopeTurnsY))+blank;
             if (dy*sc.cfgsc.TelescopeTurnsY)>0 then txt:=Format(rsCW, [txt])
                else txt:=Format(rsCCW, [txt]);
             end;
          end;
      end;
      sc.cfgsc.FindNote:=txt+tab+sc.cfgsc.FindNote;
      skipmove:=10;
   end;
end;
if sc.cfgsc.TrackOn then begin
//  sc.cfgsc.FindRA:=lastra;
//  sc.cfgsc.FindDEC:=lastdec;
//  sc.cfgsc.FindName:=lastname;
  sc.cfgsc.TrackRA:=lasttrra;
  sc.cfgsc.TrackDEC:=lasttrde;
  sc.cfgsc.TrackType:=lasttype;
  sc.cfgsc.Trackobj:=lastobj;
  sc.cfgsc.TrackName:=lasttrname;
end;
if assigned(Fshowinfo) then Fshowinfo(wordspace(sc.cfgsc.FindDesc),caption,true,self);
end;

function Tf_chart.ListXY(X, Y: Integer):boolean;
var ra,dec,a,h,l,b,le,be,dx:double;
    buf:widestring;
begin
result:=false;
if locked then exit;
sc.GetCoord(x,y,ra,dec,a,h,l,b,le,be);
ra:=rmod(ra+pi2,pi2);
dx:=12/sc.cfgsc.BxGlb; // search a 12 pixel radius
sc.Findlist(ra,dec,dx,dx,buf,false,true,true);
if assigned(FListInfo) then FListInfo(buf);
end;

procedure Tf_chart.Image1MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
if MovingCircle then begin
   sc.DrawFinderMark(sc.cfgsc.CircleLst[0,1],sc.cfgsc.CircleLst[0,2],true);
   MovingCircle := false;
   if button=mbLeft then begin
      inc(sc.cfgsc.NumCircle);
      GetAdXy(Xcursor,Ycursor,sc.cfgsc.CircleLst[sc.cfgsc.NumCircle,1],sc.cfgsc.CircleLst[sc.cfgsc.NumCircle,2],sc.cfgsc);
      Refresh;
   end;
end
else
if (button=mbLeft)and((shift=[])or(shift=[ssLeft])) then begin
   if zoomstep>0 then
     ZoomBox(3,X,Y)
   else
     IdentXY(x,y);
end
else if (button=mbLeft)and(ssCtrl in shift) then begin
   IdentXY(x,y,false);
end
else if (button=mbLeft)and(ssShift in shift)and(not lastquick) then begin
   ZoomBox(4,0,0);
   ListXY(x,y);
end
else if (button=mbMiddle)or((button=mbLeft)and(ssShift in shift)) then begin
   Image1.Cursor:=ChartCursor;
   Refresh;
end;
end;


procedure Tf_chart.Image1MouseDown(Sender: TObject; Button: TMouseButton;

  Shift: TShiftState; X, Y: Integer);
begin
lastx:=x;
lasty:=y;
lastyzoom:=y;
case Button of
   mbLeft  : ZoomBox(1,X,Y);
   mbMiddle: image1.cursor:=crHandPoint;
end;
if assigned(FSetFocus) then FSetFocus(Self);
if assigned(FImageSetFocus) then FImageSetFocus(Sender);
end;

procedure Tf_chart.Image1MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
var c:double;
begin
if locked then exit;
if skipmove>0 then begin
   system.dec(skipmove);
   exit;
end;
if MovingCircle then begin
   Xcursor:=x;
   Ycursor:=y;
   sc.DrawFinderMark(sc.cfgsc.CircleLst[0,1],sc.cfgsc.CircleLst[0,2],true);
   GetAdXy(Xcursor,Ycursor,sc.cfgsc.CircleLst[0,1],sc.cfgsc.CircleLst[0,2],sc.cfgsc);
   sc.DrawFinderMark(sc.cfgsc.CircleLst[0,1],sc.cfgsc.CircleLst[0,2],true);
end else
if shift = [ssLeft] then begin
   ZoomBox(2,X,Y);
end else if (shift=[ssMiddle])or(shift=[ssLeft,ssShift]) then begin
     TrackCursor(X,Y);
end else if shift=[ssMiddle,ssCtrl] then begin
     c:=abs(y-lastyzoom)/200;
     if c>1 then c:=1;
     if (y-lastyzoom)>0 then ZoomCursor(1+c)
                        else ZoomCursor(1-c/2);
     lastx:=x;
     lasty:=y;
     lastyzoom:=y;
end else begin
   if lastquick then Refresh; //the mouse as leave during a quick refresh
   ShowCoord(x,y);
end;
end;

Procedure Tf_chart.ShowCoord(x,y: Integer);
var ra,dec,a,h,l,b,le,be:double;
    txt:string;
begin
   {show the coordinates}
   sc.GetCoord(x,y,ra,dec,a,h,l,b,le,be);
   case sc.cfgsc.projpole of
   AltAz: begin
          txt:=rsAz+':'+deptostr(rad2deg*a)+blank+deptostr(rad2deg*h)+crlf
              +rsRA+':'+arptostr(rad2deg*ra/15)+blank+deptostr(rad2deg*dec);
          end;
   Equat: begin
          ra:=rmod(ra+pi2,pi2);
          txt:=rsRA+':'+arptostr(rad2deg*ra/15)+blank+deptostr(rad2deg*dec);
          end;
   Gal:   begin
          l:=rmod(l+pi2,pi2);
          txt:=rsL+':'+deptostr(rad2deg*l)+blank+deptostr(rad2deg*b)+crlf
              +rsRA+':'+arptostr(rad2deg*ra/15)+blank+deptostr(rad2deg*dec);
          end;
   Ecl:   begin
          le:=rmod(le+pi2,pi2);
          txt:=rsL+':'+deptostr(rad2deg*le)+blank+deptostr(rad2deg*be)+crlf
              +rsRA+':'+arptostr(rad2deg*ra/15)+blank+deptostr(rad2deg*dec);
          end;
   end;
   if assigned(Fshowcoord) then Fshowcoord(txt);
end;

Procedure Tf_chart.ZoomBox(action,x,y:integer);
var
   x1,x2,y1,y2,dx,dy,xc,yc,lc : integer;
begin
case action of
1 : begin    // mouse down
   ZoomMove:=0;
   if Zoomstep=0 then begin
     // begin zoom
     XZoom1:=X;
     YZoom1:=Y;
     Zoomstep:=1;
   end else begin
     // move box or confirm click
     DXzoom:=Xzoom1-X;
     DYzoom:=Yzoom1-Y;
     Zoomstep:=4;
   end;
   end;
2 : begin   // mouse move
  if Zoomstep>=3 then  begin
     // move box
     inc(ZoomMove);
     if ZoomMove>2 then zoomstep:=3;
     with Image1.Canvas do begin
      Pen.Width := 1;
      pen.Color:=clWhite;
      Pen.Mode:=pmXor;
      brush.Style:=bsclear;
      rectangle(Rect(XZoomD1,YZoomD1,XZoomD2,YZoomD2));
      dx:=abs(XzoomD2-XzoomD1);
      dy:=abs(YzoomD2-YzoomD1);
      XZoom1:=x+DXZoom;
      YZoom1:=y+DYZoom;
      Xzoom2:=Xzoom1+dx;
      YZoom2:=Yzoom1+dy;
      x1:=round(minvalue([Xzoom1,Xzoom2]));
      x2:=round(maxvalue([Xzoom1,Xzoom2]));
      y1:=round(minvalue([Yzoom1,Yzoom2]));
      y2:=round(maxvalue([Yzoom1,Yzoom2]));
      XzoomD1:=x1;
      XzoomD2:=x2;
      YzoomD1:=y1;
      YzoomD2:=y2;
      rectangle(Rect(XZoomD1,YZoomD1,XZoomD2,YZoomD2));
      Pen.Mode:=pmCopy;
      brush.Style:=bsSolid;
     end;
     if assigned(Fshowcoord) then Fshowcoord(demtostr(rad2deg*abs(dx/sc.cfgsc.Bxglb)));
  end else begin
     // draw zoom box
     inc(ZoomMove);
     if ZoomMove<2 then exit;
     with Image1.Canvas do begin
      Pen.Width := 1;
      pen.Color:=clWhite;
      Pen.Mode:=pmXor;
      brush.Style:=bsclear;
      if Zoomstep>1 then rectangle(Rect(XZoomD1,YZoomD1,XZoomD2,YZoomD2));
      Xzoom2:=x;
      Yzoom2:=Yzoom1+round(sgn(y-Yzoom1)*abs(Xzoom2-Xzoom1)/sc.cfgsc.windowratio);
      x1:=round(minvalue([Xzoom1,Xzoom2]));
      x2:=round(maxvalue([Xzoom1,Xzoom2]));
      y1:=round(minvalue([Yzoom1,Yzoom2]));
      y2:=round(maxvalue([Yzoom1,Yzoom2]));
      XzoomD1:=x1;
      XzoomD2:=x2;
      YzoomD1:=y1;
      YzoomD2:=y2;
      Zoomstep:=2;
      rectangle(Rect(XZoomD1,YZoomD1,XZoomD2,YZoomD2));
      Pen.Mode:=pmCopy;
      brush.Style:=bsSolid;
     end;
     if assigned(Fshowcoord) then Fshowcoord(demtostr(rad2deg*abs((XZoomD2-XZoomD1)/sc.cfgsc.Bxglb)));
     end
    end;
3 : begin   // mouse up
    if zoomstep>=4 then begin
     // final confirmation
      with Image1.Canvas do begin
        Pen.Width := 1;
        Pen.Color:=clWhite;
        Pen.Mode:=pmXor;
        Brush.Style:=bsclear;
        Rectangle(Rect(XZoom1,YZoom1,XZoom2,YZoom2));
        Pen.Mode:=pmCopy;
        Brush.Style:=bsSolid;
      end;
      Zoomstep:=0;
     x1:=trunc(Minvalue([XZoom1,XZoom2])); x2:=trunc(Maxvalue([XZoom1,XZoom2]));
     y1:=trunc(Minvalue([YZoom1,YZoom2])); y2:=trunc(Maxvalue([YZoom1,YZoom2]));
     if (X>=X1) and (X<=X2) and (Y>=Y1) and (Y<=Y2)
        and (X1<>X2 ) and (Y1<>Y2) and (abs(x2-x1)>5) and (abs(y2-y1)>5) then begin
        // do the zoom
        lc := abs(X2-X1);
        xc := round(X1+lc/2);
        yc := round(Y1+(Y2-Y1)/2);
        sc.setfov(abs(lc/sc.cfgsc.BxGlb));
        sc.MovetoXY(xc,yc);
        Refresh;
     end
     else // zoom aborted, nothing to do.
    end else if zoomstep>=2 then begin
        zoomstep:=4  // box size fixed, wait confirmation or move
    end else begin
        // zoom aborted or not initialized
        // box cleanup if necessary
        if Zoomstep>1 then
        with Image1.Canvas do begin
          Pen.Width := 1;
          Pen.Color:=clWhite;
          Pen.Mode:=pmXor;
          Brush.Style:=bsclear;
          Rectangle(Rect(XZoom1,YZoom1,XZoom2,YZoom2));
          Pen.Mode:=pmCopy;
          Brush.Style:=bsSolid;
        end;
        // zoom reset
        Zoomstep:=0;
        // call other mouseup function (identification)
        Image1MouseUp(Self,mbLeft,[],X,Y);
    end;
   end;
4 : begin   // abort
        if Zoomstep>1 then
        with Image1.Canvas do begin
          Pen.Width := 1;
          Pen.Color:=clWhite;
          Pen.Mode:=pmXor;
          Brush.Style:=bsclear;
          Rectangle(Rect(XZoom1,YZoom1,XZoom2,YZoom2));
          Pen.Mode:=pmCopy;
          Brush.Style:=bsSolid;
        end;
        Zoomstep:=0;
   end;
end;
end;

Procedure Tf_chart.TrackCursor(X,Y : integer);
var xx,yy : integer;
begin
if LockTrackCursor then exit;
try
   LockTrackCursor:=true;
   image1.cursor:=crHandPoint;
   xx:=sc.cfgsc.xcentre-(x-lastx);
   yy:=sc.cfgsc.ycentre-(y-lasty);
   lastx:=x;
   lasty:=y;
   lastyzoom:=y;
   GetADxy(xx,yy,sc.cfgsc.racentre,sc.cfgsc.decentre,sc.cfgsc);
   if sc.cfgsc.racentre>pi2 then sc.cfgsc.racentre:=sc.cfgsc.racentre-pi2;
   if sc.cfgsc.racentre<0 then sc.cfgsc.racentre:=sc.cfgsc.racentre+pi2;
   sc.cfgsc.quick:=true;
   Refresh;
//   image1.cursor:=crHandPoint;
   application.processmessages;  // very important to empty the mouse event queue before to unlock
finally
LockTrackCursor:=false;
end;
end;

Procedure Tf_chart.ZoomCursor(yy : double);
begin
if LockTrackCursor then exit;
try
   LockTrackCursor:=true;
   yy:=sc.cfgsc.fov*abs(yy);
   if yy<FovMin then yy:=FovMin;
   if yy>FovMax then yy:=FovMax;
   sc.cfgsc.fov:=yy;
   Refresh;
   application.processmessages;
finally
LockTrackCursor:=false;
end;
end;

procedure Tf_chart.About1Click(Sender: TObject);
begin
  identlabelClick(Sender);
end;

procedure Tf_chart.AddLabel1Click(Sender: TObject);
var ra,dec: double;
begin
GetAdXy(Xcursor,Ycursor,ra,dec,sc.cfgsc);
sc.AddNewLabel(ra,dec);
end;

procedure Tf_chart.BlinkTimerTimer(Sender: TObject);
begin
  BlinkTimer.Enabled:=false;
  sc.cfgsc.ShowBackgroundImage:=not sc.cfgsc.ShowBackgroundImage;
  Refresh;
  BlinkTimer.Enabled:=true;
end;

procedure Tf_chart.identlabelClick(Sender: TObject);
begin
f_detail.text:=FormatDesc;
if (sender<>nil)and(not f_detail.visible) then formpos(f_detail,mouse.cursorpos.x,mouse.cursorpos.y);
f_detail.source_chart:=caption;
f_detail.show;
f_detail.setfocus;
f_detail.BringToFront;
end;

function Tf_chart.FormatDesc:string;
var desc,buf,buf2,otype,oname,txt: string;
    thr,tht,ths,tazr,tazs,tculmalt: string;
    i,p,l,y,m,d,precision : integer;
    isStar, isSolarSystem: boolean;
    ra,dec,a,h,hr,ht,hs,azr,azs,j1,j2,j3,rar,der,rat,det,ras,des,culmalt :double;
    ra2000,de2000,radate,dedate,raapp,deapp: double;
function Bold(s:string):string;
var k:integer;
begin
  k:=pos(':',s);
  if k>0 then begin
     insert(htms_b,s,k+1);
     result:=html_b+s;
  end
  else result:=s;
end;
begin
desc:=sc.cfgsc.FindDesc;
// header
if NightVision then txt:=html_h_nv
               else txt:=html_h;
// object type
p:=pos(tab,desc);
p:=pos2(tab,desc,p+1);
l:=pos2(tab,desc,p+1);
otype:=trim(copy(desc,p+1,l-p-1));
if otype='*' then precision:=2
else if otype='As' then precision:=2
else if otype='Cm' then precision:=1
else if otype='P' then precision:=1
else if otype='Ps' then precision:=1
else precision:=0;
isStar:=(otype='*');
isSolarSystem:=((otype='P')or(otype='Ps')or(otype='As')or(otype='Cm'));
buf:=LongLabelObj(otype);
txt:=txt+html_h2+buf+htms_h2;
buf:=copy(desc,l+1,9999);
// object name
i:=pos(tab,buf);
oname:=trim(copy(buf,1,i-1));
delete(buf,1,i);
txt:=txt+html_b+oname+htms_b+html_br;
// other attribute
repeat
  i:=pos(tab,buf);
  if i=0 then i:=length(buf)+1;
  buf2:=copy(buf,1,i-1);
  delete(buf,1,i);
  i:=pos(':',buf2);
  if i>0 then begin
     buf2:=stringreplace(buf2,':',': ',[]);
     if copy(buf2, 1, 5)=rsDesc then buf2:=stringreplace(buf2, ';', html_br+html_sp+html_sp+html_sp, [rfReplaceAll]);
     txt:=txt+bold(LongLabel(buf2));
  end
  else
     txt:=txt+buf2;
  txt:=txt+html_br;
until buf='';

// coordinates
txt:=txt+html_br+html_b+rsCoordinates+blank;
if sc.cfgsc.CoordExpertMode then begin;
  if sc.cfgsc.ApparentPos then txt:=txt+blank+rsApparent
                          else txt:=txt+blank+rsMean;
  txt:=txt+blank+sc.cfgsc.EquinoxName;
end else
  case sc.cfgsc.CoordType of
  0: txt:=txt+blank+rsApparent;
  1: txt:=txt+blank+rsMeanOfTheDat;
  2: txt:=txt+blank+rsMeanJ2000;
  end;
if isStar and sc.cfgsc.PMon then txt:=txt+blank+rsWithProperMo;
if isSolarSystem then
   if sc.cfgsc.PlanetParalaxe then txt:=txt+blank+rsTopoCentric
                              else txt:=txt+blank+rsGeocentric;
txt:=txt+htms_b+html_br;
ra2000:=sc.cfgsc.FindRA;
de2000:=sc.cfgsc.FindDec;
if sc.cfgsc.ApparentPos then mean_equatorial(ra2000,de2000,sc.cfgsc);
precession(sc.cfgsc.JDChart,jd2000,ra2000,de2000);
radate:=sc.cfgsc.FindRA;
dedate:=sc.cfgsc.FindDec;
precession(sc.cfgsc.JDChart,sc.cfgsc.CurJD,radate,dedate);
if sc.cfgsc.ApparentPos then mean_equatorial(radate,dedate,sc.cfgsc);
raapp:=sc.cfgsc.FindRA;
deapp:=sc.cfgsc.FindDec;
precession(sc.cfgsc.JDChart,sc.cfgsc.CurJD,raapp,deapp);
if not sc.cfgsc.ApparentPos then apparent_equatorial(raapp,deapp,sc.cfgsc);
if sc.cfgsc.CoordExpertMode then txt:=txt+rsRA+': '+arptostr(rad2deg*sc.cfgsc.FindRA/15,precision)+'   '+rsDE+':'+deptostr(rad2deg*sc.cfgsc.FindDec, precision)+html_br;
txt:=txt+html_b+rsApparent+blank+htms_b+rsRA+': '+arptostr(rad2deg*raapp/15,precision)+'   '+rsDE+':'+deptostr(rad2deg*deapp, precision)+html_br;
txt:=txt+html_b+rsMeanOfTheDat+blank+htms_b+rsRA+': '+arptostr(rad2deg*radate/15,precision)+'   '+rsDE+':'+deptostr(rad2deg*dedate,precision)+html_br;
txt:=txt+html_b+rsMeanJ2000+htms_b+' '+rsRA+': '+arptostr(rad2deg*ra2000/15,precision)+'   '+rsDE+':'+deptostr(rad2deg*de2000, precision)+html_br;
ra:=sc.cfgsc.FindRA;
dec:=sc.cfgsc.FindDec;
Eq2Ecl(ra,dec,sc.cfgsc.e,a,h) ;
a:=rmod(a+pi2,pi2);
txt:=txt+html_b+rsEcliptic+blank+htms_b+blank+rsL+': '+detostr(rad2deg*a)+blank+rsB+':'+detostr(rad2deg*h)+html_br;
ra:=sc.cfgsc.FindRA;
dec:=sc.cfgsc.FindDec;
if sc.cfgsc.ApparentPos then mean_equatorial(ra,dec,sc.cfgsc);
Eq2Gal(ra,dec,a,h,sc.cfgsc) ;
a:=rmod(a+pi2,pi2);
txt:=txt+html_b+rsGalactic+blank+htms_b+blank+rsL+': '+detostr(rad2deg*a)+blank+rsB+':'+detostr(rad2deg*h)+html_br;
txt:=txt+html_br;

// local position
txt:=txt+html_b+rsVisibilityFo+':'+htms_b+html_br;
txt:=txt+sc.cfgsc.ObsName+blank+Date2Str(sc.cfgsc.CurYear,sc.cfgsc.curmonth,sc.cfgsc.curday)+blank+ArToStr3(sc.cfgsc.Curtime)+'  ( '+sc.cfgsc.tz.ZoneName+' )'+html_br;
//txt:=txt+html_pre;
djd(sc.cfgsc.CurJD-sc.cfgsc.DT_UT/24,y,m,d,h);
txt:=txt+html_b+copy(rsUniversalTim+blank15,1,17)+':'+htms_b+blank+date2str(y,m,d)+'T'+timtostr(h)+html_br;
ra:=sc.cfgsc.FindRA;
dec:=sc.cfgsc.FindDec;
precession(sc.cfgsc.JDChart,sc.cfgsc.CurJD,ra,dec);
Eq2Hz(sc.cfgsc.CurSt-ra,dec,a,h,sc.cfgsc) ;
if sc.catalog.cfgshr.AzNorth then a:=Rmod(a+pi,pi2);
txt:=txt+html_b+copy(rsSideralTime+blank15,1,17)+':'+htms_b+armtostr(rmod(rad2deg*sc.cfgsc.CurSt/15+24,24))+html_br;
txt:=txt+html_b+copy(rsHourAngle+blank15,1,17)+':'+htms_b+armtostr(rmod(rad2deg*(sc.cfgsc.CurSt-ra)/15+24,24))+html_br;
txt:=txt+html_b+copy(rsAzimuth+blank15,1,17)+':'+htms_b+demtostr(rad2deg*a)+html_br;
txt:=txt+html_b+copy(rsAltitude+blank15,1,17)+':'+htms_b+demtostr(rad2deg*h)+html_br;
// rise/set time
if (otype='P') then begin // planet
   sc.planet.PlanetRiseSet(sc.cfgsc.TrackObj,sc.cfgsc.jd0,sc.catalog.cfgshr.AzNorth,thr,tht,ths,tazr,tazs,j1,j2,j3,rar,der,rat,det,ras,des,i,sc.cfgsc);
end
// todo: rise/set time comet, asteroid, satellites, ...
else begin // fixed object
     RiseSet(1,sc.cfgsc.jd0,ra,dec,hr,ht,hs,azr,azs,i,sc.cfgsc);
     if sc.catalog.cfgshr.AzNorth then begin
        Azr:=rmod(Azr+pi,pi2);
        Azs:=rmod(Azs+pi,pi2);
     end;
     thr:=armtostr(hr);
     tht:=armtostr(ht);
     ths:=armtostr(hs);
     tazr:=demtostr(rad2deg*Azr);
     tazs:=demtostr(rad2deg*Azs);
end;
culmalt:= 90 - sc.cfgsc.ObsLatitude + rad2deg*sc.cfgsc.FindDec;
if culmalt>90 then culmalt:=180-culmalt;
if culmalt>-1 then culmalt:=min(90,culmalt+sc.cfgsc.ObsRefractionCor*(1.02/tan(deg2rad*(culmalt+10.3/(culmalt+5.11))))/60)
              else culmalt:=culmalt+0.64658062088;
tculmalt:=demtostr(culmalt);
case i of
0 : begin
    txt:=txt+html_b+rsRise+':'+htms_b+thr+blank;
    if trim(tazr)>'' then txt:=txt+rsAzimuth+tAzr+html_br
                     else txt:=txt+html_br;
    txt:=txt+html_b+rsCulmination+':'+htms_b+tht+blank+tculmalt+html_br;
    txt:=txt+html_b+rsSet+':'+htms_b+ths+blank;
    if trim(tazs)>'' then txt:=txt+rsAzimuth+tAzs+html_br
                     else txt:=txt+html_br;
    end;
1 : begin
    txt:=txt+rsCircumpolar+html_br;
    txt:=txt+html_b+copy(rsCulmination+blank15,1,17)+':'+htms_b+tht+blank+tculmalt+html_br;
    end;
else begin
    txt:=txt+rsInvisibleAtT+html_br;
    end;
end;
//txt:=txt+htms_pre;
// other notes
buf:=sc.cfgsc.FindNote;
txt:=txt+html_pre;
repeat
  i:=pos(tab,buf);
  if i=0 then i:=length(buf)+1;
  buf2:=copy(buf,1,i-1);
  delete(buf,1,i);
  i:=pos(':',buf2);
  if i>0 then begin
     txt:=txt+bold(copy(buf2,1,i));
     delete(buf2,1,i);
  end;
  txt:=txt+buf2+html_br;
until buf='';
txt:=txt+htms_pre;
//writetrace(txt);
result:=txt+htms_f+html_br+htms_h;
end;

function Tf_chart.LongLabelObj(txt:string):string;
begin
if txt='OC' then txt:=rsOpenCluster
else if txt='Gb' then txt:=rsGlobularClus
else if txt='Gx' then txt:=rsGalaxy
else if txt='Nb' then txt:=rsBrightNebula
else if txt='Pl' then txt:=rsPlanetaryNeb
else if txt='C+N' then txt:=rsClusterAndNe
else if txt='N' then txt:=rsNebula
else if txt='*' then txt:=rsStar
else if txt='**' then txt:=rsDoubleStar
else if txt='***' then txt:=rsTripleStar
else if txt='D*' then txt:=rsDoubleStar
else if txt='V*' then txt:=rsVariableStar
else if txt='Ast' then txt:=rsAsterism
else if txt='Kt' then txt:=rsKnot
else if txt='?' then txt:=rsUnknowObject
else if txt='' then txt:=rsUnknowObject
else if txt='-' then txt:=rsPlateDefect
else if txt='PD' then txt:=rsPlateDefect
else if txt='P' then txt:=rsPlanet
else if txt='Ps' then txt:=rsPlanetarySat
else if txt='As' then txt:=rsAsteroid
else if txt='Cm' then txt:=rsComet
else if txt='C1' then txt:=rsExternalCata
else if txt='C2' then txt:=rsExternalCata;
result:=txt;
end;

function Tf_chart.LongLabel(txt:string):string;
var key,value : string;
    i : integer;
const d=': ';
begin
i:=pos(':',txt);
if i>0 then begin
  key:=uppercase(trim(copy(txt,1,i-1)));
  value:=copy(txt,i+1,9999);
  if key='MB' then result:=rsBlueMagnitud+d+value
  else if key='MV' then result:=rsVisualMagnit+d+value
  else if key='MR' then result:=rsRedMagnitude+d+value
  else if key='M' then result:=rsMagnitude+d+value
  else if key='BT' then result:=rsMagnitudeTyc+d+value
  else if key='VT' then result:=rsMagnitudeTyc2+d+value
  else if key='B-V' then result:=rsColorIndex+d+value
  else if key='SP' then result:=rsSpectralClas+d+value
  else if key='PM' then result:=rsAnnualProper+d+value
  else if key='CLASS' then result:=rsClass+d+value
  else if key='N' then result:=rsNote+d+value
  else if key='T' then result:=rsTypeOfVariab+d+value
  else if key='P' then result:=rsPeriod+d+value
  else if key='BAND' then result:=rsMagnitudeBan+d+value
  else if key='PLATE' then result:=rsPhotographic+d+value
  else if key='MULT' then result:=rsMultipleFlag+d+value
  else if key='FIELD' then result:=rsFieldNumber+d+value
  else if key='Q' then result:=rsMagnitudeErr+d+value
  else if key='S' then result:=rsCorrelated+d+value
  else if key='DIM' then result:=rsDimension+d+value
  else if key='CONST' then result:=rsConstellatio+d+longlabelconst(value)
  else if key='SBR' then result:=rsSurfaceBrigh+d+value
  else if key='DESC' then result:=rsDescription+d+value
  else if key='RV' then result:=rsRadialVeloci+d+value
  else if key='SURFACE' then result:=rsSurface+d+value
  else if key='COLOR' then result:=rsColor+d+value
  else if key='BRIGHT' then result:=rsBrightness+d+value
  else if key='TR' then result:=rsTrumplerClas+d+value
  else if key='DIST' then result:=rsDistance+d+value
  else if key='M*' then result:=rsBrightestSta+d+value
  else if key='N*' then result:=rsNumberOfStar+d+value
  else if key='AGE' then result:=rsAge+d+value
  else if key='RT' then result:=rsTotalRadius+d+value
  else if key='RH' then result:=rsHalfMassRadi+d+value
  else if key='RC' then result:=rsCoreRadius+d+value
  else if key='MHB' then result:=rsHbetaMagnitu+d+value
  else if key='C*B' then result:=rsCentralStarB+d+value
  else if key='C*V' then result:=rsCentralStarV+d+value
  else if key='DIAM' then result:=rsDiameter+d+value
  else if key='ILLUM' then result:=rsIlluminatedF+d+value
  else if key='PHASE' then result:=rsPhase+d+value
  else if key='TL' then result:=rsEstimatedTai+d+value
  else if key='EL' then result:=rsSolarElongat+d+value
  else if key='RSOL' then result:=rsSolarDistanc+d+value
  else if key='D1' then result:=rsDescription+' 1'+d+value
  else if key='D2' then result:=rsDescription+' 2'+d+value
  else if key='D3' then result:=rsDescription+' 3'+d+value
  else if key='FL' then result:=rsFlamsteedNum+d+value
  else if key='BA' then result:=rsBayerLetter+d+LongLabelGreek(value)
  else if key='PX' then result:=rsParallax+d+value
  else if key='PA' then result:=rsPositionAngl+d+value
  else if key='PMRA' then result:=rsProperMotion+d+value
  else if key='PMDE' then result:=rsProperMotion2+d+value
  else if key='MMAX' then result:=rsMagnitudeAtM+d+value
  else if key='MMIN' then result:=rsMagnitudeAtM2+d+value
  else if key='MEPOCH' then result:=rsEpochOfMaxim+d+value
  else if key='RISE' then result:=rsRiseTime+d+value
  else if key='M1' then result:=rsComponent1Ma+d+value
  else if key='M2' then result:=rsComponent2Ma+d+value
  else if key='SEP' then result:=rsSeparation+d+value
  else if key='DATE' then result:=rsDate+d+value
  else if key='POLEINCL' then result:=rsPoleInclinat+d+value
  else if key='SUNINCL' then result:=rsSunInclinati+d+value
  else if key='CM' then result:=rsCentralMerid+d+value
  else if key='CMI' then result:=rsCentralMerid+' I'+d+value
  else if key='CMII' then result:=rsCentralMerid+' II'+d+value
  else if key='CMIII' then result:=rsCentralMerid+' III'+d+value
  else if key='GRSTR' then result:=rsGRSTransit+d+value
  else if key='LLAT' then result:=rsLibrationInL+d+value
  else if key='LLON' then result:=rsLibrationInL2+d+value
  else result:=txt;
end
else result:=txt;
end;

Function Tf_chart.LongLabelConst(txt : string) : string;
var i : integer;
begin
txt:=uppercase(trim(txt));
for i:=0 to sc.catalog.cfgshr.ConstelNum-1 do begin
  if txt=UpperCase(sc.catalog.cfgshr.ConstelName[i,1]) then begin
     txt:=sc.catalog.cfgshr.ConstelName[i,2];
     break;
   end;
end;
result:=txt;
end;

Function Tf_chart.LongLabelGreek(txt : string) : string;
var i : integer;
begin
txt:=uppercase(trim(txt));
for i:=1 to 24 do begin
  if txt=UpperCase(trim(greek[2,i])) then begin
     txt:=greek[1,i];
     break;
   end;
end;
result:=txt;
end;

procedure Tf_chart.switchstarExecute(Sender: TObject);
begin
//sc.plot.cfgplot.starplot:=abs(sc.plot.cfgplot.starplot-1);
//sc.plot.cfgplot.nebplot:=sc.plot.cfgplot.starplot;
dec(sc.plot.cfgplot.starplot);
if sc.plot.cfgplot.starplot<0 then sc.plot.cfgplot.starplot:=2;
if sc.plot.cfgplot.starplot=0 then sc.plot.cfgplot.nebplot:=0
                              else sc.plot.cfgplot.nebplot:=1;
sc.cfgsc.FillMilkyWay:=(sc.plot.cfgplot.nebplot=1);
Refresh;
end;

procedure Tf_chart.switchbackgroundExecute(Sender: TObject);

begin
sc.plot.cfgplot.autoskycolor:=not sc.plot.cfgplot.autoskycolor;
Refresh;
end;


function Tf_Chart.cmd_SetCursorPosition(x,y:integer) :string;

begin

if (x>=0)and(x<=image1.width)and(y>=0)and(y<=image1.height) then begin

  xcursor:=x;

  ycursor:=y;

  result:=msgOK;

end else result:=msgfailed+' Bad position.';

end;


function Tf_Chart.cmd_GetCursorPosition :string;

begin

result:=msgOK+blank+inttostr(xcursor)+blank+inttostr(ycursor);

end;


function Tf_Chart.cmd_SetGridEQ(onoff:string):string;

begin

 sc.cfgsc.ShowEqGrid := (uppercase(onoff)='ON');

 result:=msgOK;

end;

function Tf_Chart.cmd_GetGridEQ:string;
begin

 if sc.cfgsc.ShowEqGrid then result:=msgOK+' ON'

                        else result:=msgOK+' OFF'

end;

function Tf_Chart.cmd_SetGrid(onoff:string):string;
begin

 sc.cfgsc.ShowGrid := (uppercase(onoff)='ON');

 result:=msgOK;

end;


function Tf_Chart.cmd_GetGrid:string;

begin

 if sc.cfgsc.ShowGrid then result:=msgOK+' ON'

                      else result:=msgOK+' OFF'

end;


function Tf_Chart.cmd_SetGridNum(onoff:string):string;

begin

 sc.cfgsc.ShowGridNum := (uppercase(onoff)='ON');

 result:=msgOK;

end;


function Tf_Chart.cmd_SetConstL(onoff:string):string;

begin

 sc.cfgsc.ShowConstl := (uppercase(onoff)='ON');

 result:=msgOK;

end;


function Tf_Chart.cmd_SetConstB(onoff:string):string;

begin

 sc.cfgsc.ShowConstB := (uppercase(onoff)='ON');

 result:=msgOK;

end;


function Tf_Chart.cmd_SwitchGridNum:string;

begin

 sc.cfgsc.ShowGridNum := not sc.cfgsc.ShowGridNum;

 result:=msgOK;

end;


function Tf_Chart.cmd_SwitchConstL:string;

begin

 sc.cfgsc.ShowConstl := not sc.cfgsc.ShowConstl;

 result:=msgOK;

end;


function Tf_Chart.cmd_SwitchConstB:string;

begin

 sc.cfgsc.ShowConstB := not sc.cfgsc.ShowConstB;

 result:=msgOK;

end;


function Tf_chart.cmd_SetStarMode(i:integer):string;

begin
if (i>=0)and(i<=2) then begin
  sc.plot.cfgplot.starplot:=i;
  result:=msgOK;
end else result:=msgFailed+' Bad star mode.';
end;

function Tf_chart.cmd_GetStarMode:string;
begin
  result:=msgOK+blank+inttostr(sc.plot.cfgplot.starplot);
end;

function Tf_chart.cmd_SetNebMode(i:integer):string;
begin
if (i>=0)and(i<=1) then begin
  sc.plot.cfgplot.nebplot:=i;
  result:=msgOK;
end else result:=msgFailed+' Bad nebula mode.';
end;

function Tf_chart.cmd_GetNebMode:string;
begin
  result:=msgOK+blank+inttostr(sc.plot.cfgplot.nebplot);
end;

function Tf_chart.cmd_SetSkyMode(onoff:string):string;
begin
sc.plot.cfgplot.autoskycolor:=(uppercase(onoff)='ON');
result:=msgOK;
end;

function Tf_chart.cmd_GetSkyMode:string;
begin
 if sc.plot.cfgplot.autoskycolor then result:=msgOK+' ON'
                                 else result:=msgOK+' OFF'

end;

function Tf_chart.cmd_SetProjection(proj:string):string;
begin
result:=msgOK;
proj:=uppercase(proj);
if proj='ALTAZ' then sc.cfgsc.projpole:=altaz
  else if proj='EQUAT' then sc.cfgsc.projpole:=equat
  else if proj='GALACTIC' then sc.cfgsc.projpole:=gal
  else if proj='ECLIPTIC' then sc.cfgsc.projpole:=ecl
  else result:=msgFailed+' Bad projection name.';
sc.cfgsc.FindOk:=false;
end;

function Tf_chart.cmd_GetProjection:string;
begin
case sc.cfgsc.projpole of
equat :  result:='EQUAT';
altaz :  result:='ALTAZ';
gal   :  result:='GALACTIC';
ecl   :  result:='ECLIPTIC';
end;
result:=msgOK+blank+result;
end;

function Tf_chart.cmd_SetFov(fov:string):string;
var f : double;
    p : integer;
begin
result:=msgFailed+' Bad format!';
try
fov:=trim(fov);
p:=pos('d',fov);
if p>0 then begin
  f:=strtofloat(copy(fov,1,p-1));
  fov:=copy(fov,p+1,999);
  p:=pos('m',fov);
  f:=f+strtofloat(copy(fov,1,p-1))/60;
  fov:=copy(fov,p+1,999);
  p:=pos('s',fov);
  f:=f+strtofloat(copy(fov,1,p-1))/3600;
end else begin
  f:=strtofloat(fov);
end;
sc.setfov(deg2rad*f);
result:=msgOK;
except
exit;
end;
end;

function Tf_chart.cmd_GetFov(format:string):string;
begin
if format='F' then begin
 result:=msgOK+blank+formatfloat(f5,rad2deg*sc.cfgsc.fov);
end else begin
 result:=msgOK+blank+detostr3(rad2deg*sc.cfgsc.fov);
end
end;

function Tf_chart.cmd_SetRa(param1:string):string;
var buf : string;
    p : integer;
    ar : double;
begin
result:=msgFailed+' Bad coordinates format!';
try
p:=pos('RA:',param1);
if p>0 then begin
 buf:=copy(param1,p+3,999);
 p:=pos('h',buf);
 ar:=strtofloat(copy(buf,1,p-1));
 buf:=copy(buf,p+1,999);
 p:=pos('m',buf);
 ar:=ar+strtofloat(copy(buf,1,p-1))/60;
 buf:=copy(buf,p+1,999);
 p:=pos('s',buf);
 ar:=ar+strtofloat(copy(buf,1,p-1))/3600;
end else begin
 ar:=strtofloat(param1);
end;
sc.cfgsc.racentre:=rmod(deg2rad*ar*15+pi2,pi2);
result:=msgOK;
except
exit;
end;
end;

function Tf_chart.cmd_SetDec(param1:string):string;
var buf : string;
    p : integer;
    s,de : double;
begin
result:=msgFailed+' Bad coordinates format!';
try
p:=pos('DEC:',param1);
if p>0 then begin
 buf:=copy(param1,p+4,999);
 p:=pos('d',buf);
 de:=strtofloat(copy(buf,1,p-1));
 s:=sgn(de);
 buf:=copy(buf,p+1,999);
 p:=pos('m',buf);
 de:=de+s*strtofloat(copy(buf,1,p-1))/60;
 buf:=copy(buf,p+1,999);
 p:=pos('s',buf);
 de:=de+s*strtofloat(copy(buf,1,p-1))/3600;
end else begin
 de:=strtofloat(param1);
end;
sc.cfgsc.decentre:=deg2rad*de;
result:=msgOK;
except
exit;
end;
end;

function Tf_chart.cmd_GetRA(format:string):string;
begin
if format='F' then begin
 result:=msgOK+blank+formatfloat(f5,rad2deg*sc.cfgsc.racentre/15);
end else begin
 result:=msgOK+blank+artostr3(rad2deg*sc.cfgsc.racentre/15);
end
end;

function Tf_chart.cmd_GetDEC(format:string):string;
begin
if format='F' then begin
 result:=msgOK+blank+formatfloat(f5,rad2deg*sc.cfgsc.decentre);
end else begin
 result:=msgOK+blank+detostr3(rad2deg*sc.cfgsc.decentre);
end
end;

function Tf_chart.cmd_SetDate(dt:string):string;
var p,y,m,d,h,n,s : integer;
begin
result:=msgFailed+' Bad date format!';
try
dt:=trim(dt);
p:=pos('-',dt);
if p=0 then exit;
y:=strtoint(trim(copy(dt,1,p-1)));
dt:=copy(dt,p+1,999);
p:=pos('-',dt);
if p=0 then exit;
m:=strtoint(trim(copy(dt,1,p-1)));
dt:=copy(dt,p+1,999);
p:=pos('T',dt);
if p=0 then p:=pos(' ',dt);
if p=0 then exit;
d:=strtoint(trim(copy(dt,1,p-1)));
dt:=copy(dt,p+1,999);
p:=pos(':',dt);
if p=0 then exit;
h:=strtoint(trim(copy(dt,1,p-1)));
dt:=copy(dt,p+1,999);
p:=pos(':',dt);
if p=0 then exit;
n:=strtoint(trim(copy(dt,1,p-1)));
dt:=copy(dt,p+1,999);
s:=strtoint(trim(dt));
sc.cfgsc.UseSystemTime:=false;
sc.cfgsc.CurYear:=y;
sc.cfgsc.CurMonth:=m;
sc.cfgsc.CurDay:=d;
sc.cfgsc.CurTime:=h+n/60+s/3600;
sc.cfgsc.tz.JD:=jd(sc.cfgsc.CurYear,sc.cfgsc.CurMonth,sc.cfgsc.CurDay,sc.cfgsc.CurTime);
sc.cfgsc.TimeZone:=sc.cfgsc.tz.SecondsOffset/3600;
if (not sc.cfgsc.TrackOn)and(sc.cfgsc.Projpole=Altaz) then begin
  sc.cfgsc.TrackOn:=true;
  sc.cfgsc.TrackType:=4;
end;
result:=msgOK;
except
exit;
end;
end;

function Tf_chart.cmd_GetDate:string;
begin
result:=msgOK+blank+Date2Str(sc.cfgsc.CurYear,sc.cfgsc.curmonth,sc.cfgsc.curday)+'T'+ArToStr3(sc.cfgsc.Curtime);
end;

function Tf_chart.cmd_SetObs(obs:string):string;
var n,buf : string;
    p : integer;
    s,la,lo,al : double;
begin
result:=msgFailed+' Bad observatory format!';
try
p:=pos('LAT:',obs);          
if p=0 then exit;
buf:=copy(obs,p+4,999);
p:=pos('d',buf);
la:=strtofloat(copy(buf,1,p-1));
s:=sgn(la);
buf:=copy(buf,p+1,999);
p:=pos('m',buf);
la:=la+s*strtofloat(copy(buf,1,p-1))/60;
buf:=copy(buf,p+1,999);
p:=pos('s',buf);
la:=la+s*strtofloat(copy(buf,1,p-1))/3600;
p:=pos('LON:',obs);
if p=0 then exit;
buf:=copy(obs,p+4,999);
p:=pos('d',buf);
lo:=strtofloat(copy(buf,1,p-1));
s:=sgn(lo);
buf:=copy(buf,p+1,999);
p:=pos('m',buf);
lo:=lo+s*strtofloat(copy(buf,1,p-1))/60;
buf:=copy(buf,p+1,999);
p:=pos('s',buf);
lo:=lo+s*strtofloat(copy(buf,1,p-1))/3600;
p:=pos('ALT:',obs);
if p=0 then exit;
buf:=copy(obs,p+4,999);
p:=pos('m',buf);
al:=strtofloat(copy(buf,1,p-1));
p:=pos('OBS:',obs);
if p=0 then n:='obs?'
       else n:=trim(copy(obs,p+4,999));
sc.cfgsc.ObsLatitude := la;
sc.cfgsc.ObsLongitude := lo;
sc.cfgsc.ObsAltitude := al;
p:=pos('/',n);
if p>0 then begin
   sc.cfgsc.Obscountry:=trim(copy(n,1,p-1));
   delete(n,1,p);
end else sc.cfgsc.Obscountry:='';
sc.cfgsc.ObsName := n;
result:=msgOK;
except
exit;
end;
end;

function Tf_chart.cmd_GetObs:string;
begin
result:=msgOK+blank+'LAT:'+detostr3(sc.cfgsc.ObsLatitude)+'LON:'+detostr3(sc.cfgsc.ObsLongitude)+'ALT:'+formatfloat(f0,sc.cfgsc.ObsAltitude)+'mOBS:'+sc.cfgsc.Obscountry+'/'+sc.cfgsc.ObsName;
end;

function Tf_chart.cmd_SetTZ(tz:string):string;
begin
try
  sc.cfgsc.ObsTZ:=tz;
  sc.cfgsc.tz.TimeZoneFile:=ZoneDir+StringReplace(sc.cfgsc.ObsTZ,'/',PathDelim,[rfReplaceAll]);
  sc.cfgsc.TimeZone:=sc.cfgsc.tz.SecondsOffset/3600;
  result:=msgOK;
except
  result:=msgFailed;
end
end;

function Tf_chart.cmd_GetTZ:string;
begin
 result:=msgOK+blank+sc.cfgsc.ObsTZ;
end;

function Tf_chart.cmd_IdentCursor:string;
begin
if identxy(xcursor,ycursor) then result:=msgOK
   else result:=msgFailed+' No object found!';
end;

Function Tf_chart.cmd_IdXY(xx,yy : string): string;
var x,y,p : integer;
    buf : string;
begin
p:=pos('X:',xx);
if p=0 then buf:=xx
       else buf:=copy(xx,p+2,999);
x:=strtoint(trim(buf));
p:=pos('Y:',yy);
if p=0 then buf:=yy
       else buf:=copy(yy,p+2,999);
y:=strtoint(trim(buf));
if identxy(x,y) then result:=msgOK
   else result:=msgFailed+' No object found!';
end;

Procedure Tf_chart.cmd_GoXY(xx,yy : string);
var x,y,p : integer;
    buf:string;
begin
p:=pos('X:',xx);
if p=0 then buf:=xx
       else buf:=copy(xx,p+2,999);
x:=strtoint(trim(buf));
p:=pos('Y:',yy);
if p=0 then buf:=yy
       else buf:=copy(yy,p+2,999);
y:=strtoint(trim(buf));
sc.MovetoXY(x,y);
end;

function Tf_chart.cmd_SaveImage(format,fn,quality:string):string;
var i : integer;
begin
i:=strtointdef(quality,95);
if SaveChartImage(format,fn,i) then result:=msgOK
   else result:=msgFailed;
end;

procedure Tf_chart.cmd_MoreStar;
begin
if sc.catalog.cfgshr.AutoStarFilter then
   sc.catalog.cfgshr.AutoStarFilterMag:=min(16,sc.catalog.cfgshr.AutoStarFilterMag+0.5)
else begin
   sc.catalog.cfgshr.StarMagFilter[sc.cfgsc.FieldNum]:=min(sc.plot.cfgchart.max_catalog_mag,sc.catalog.cfgshr.StarMagFilter[sc.cfgsc.FieldNum]+0.5);
   if sc.catalog.cfgshr.StarMagFilter[sc.cfgsc.FieldNum]>sc.plot.cfgchart.max_catalog_mag then sc.catalog.cfgshr.StarMagFilter[sc.cfgsc.FieldNum]:=99;
end;
refresh;
end;

procedure Tf_chart.cmd_LessStar;
begin
if sc.catalog.cfgshr.AutoStarFilter then
   sc.catalog.cfgshr.AutoStarFilterMag:=max(1,sc.catalog.cfgshr.AutoStarFilterMag-0.5)
else begin
   if sc.catalog.cfgshr.StarMagFilter[sc.cfgsc.FieldNum]>=99 then sc.catalog.cfgshr.StarMagFilter[sc.cfgsc.FieldNum]:=sc.plot.cfgchart.min_ma
      else sc.catalog.cfgshr.StarMagFilter[sc.cfgsc.FieldNum]:=max(1,sc.catalog.cfgshr.StarMagFilter[sc.cfgsc.FieldNum]-0.5);
end;
refresh;
end;

procedure Tf_chart.cmd_MoreNeb;
begin
sc.catalog.cfgshr.NebMagFilter[sc.cfgsc.FieldNum]:=sc.catalog.cfgshr.NebMagFilter[sc.cfgsc.FieldNum]+0.5;
if sc.catalog.cfgshr.NebMagFilter[sc.cfgsc.FieldNum]>15 then sc.catalog.cfgshr.NebMagFilter[sc.cfgsc.FieldNum]:=99;
sc.catalog.cfgshr.NebSizeFilter[sc.cfgsc.FieldNum]:=sc.catalog.cfgshr.NebSizeFilter[sc.cfgsc.FieldNum]/1.5;
if sc.catalog.cfgshr.NebSizeFilter[sc.cfgsc.FieldNum]<0.1 then sc.catalog.cfgshr.NebSizeFilter[sc.cfgsc.FieldNum]:=0;
refresh;
end;

procedure Tf_chart.cmd_LessNeb;
begin
if sc.catalog.cfgshr.NebMagFilter[sc.cfgsc.FieldNum]>=99 then sc.catalog.cfgshr.NebMagFilter[sc.cfgsc.FieldNum]:=15
   else sc.catalog.cfgshr.NebMagFilter[sc.cfgsc.FieldNum]:=sc.catalog.cfgshr.NebMagFilter[sc.cfgsc.FieldNum]-0.5;
if sc.catalog.cfgshr.NebMagFilter[sc.cfgsc.FieldNum]<6 then sc.catalog.cfgshr.NebMagFilter[sc.cfgsc.FieldNum]:=6;
if sc.catalog.cfgshr.NebSizeFilter[sc.cfgsc.FieldNum]<=0 then sc.catalog.cfgshr.NebSizeFilter[sc.cfgsc.FieldNum]:=0.1
   else sc.catalog.cfgshr.NebSizeFilter[sc.cfgsc.FieldNum]:=sc.catalog.cfgshr.NebSizeFilter[sc.cfgsc.FieldNum]*1.5;
if sc.catalog.cfgshr.NebSizeFilter[sc.cfgsc.FieldNum]>100 then sc.catalog.cfgshr.NebSizeFilter[sc.cfgsc.FieldNum]:=100;
refresh;
end;

function Tf_chart.ExecuteCmd(arg:Tstringlist):string;
var i,n : integer;
    cmd : string;
begin
cmd:=trim(uppercase(arg[0]));
n:=-1;
for i:=1 to numcmd do
   if cmd=cmdlist[i,1] then begin
      n:=strtointdef(cmdlist[i,2],-1);
      break;
   end;
result:=msgOK;
case n of
 1 : sc.zoom(zoomfactor);
 2 : sc.zoom(1/zoomfactor);
 3 : sc.MoveChart(0,1,movefactor);
 4 : sc.MoveChart(0,-1,movefactor);
 5 : sc.MoveChart(1,0,movefactor);
 6 : sc.MoveChart(-1,0,movefactor);
 7 : sc.MoveChart(1,1,movefactor);
 8 : sc.MoveChart(1,-1,movefactor);
 9 : sc.MoveChart(-1,1,movefactor);
 10 : sc.MoveChart(-1,-1,movefactor);
 11 : begin sc.cfgsc.FlipX:=-sc.cfgsc.FlipX; if assigned(FUpdateBtn) then FUpdateBtn(sc.cfgsc.flipx,sc.cfgsc.flipy,Connect1.checked,self);end;
 12 : begin sc.cfgsc.FlipY:=-sc.cfgsc.FlipY; if assigned(FUpdateBtn) then FUpdateBtn(sc.cfgsc.flipx,sc.cfgsc.flipy,Connect1.checked,self);end;
 13 : result:=cmd_SetCursorPosition(strtointdef(arg[1],-1),strtointdef(arg[2],-1));
 14 : sc.MovetoXY(xcursor,ycursor);
 15 : begin sc.zoom(zoomfactor);sc.MovetoXY(xcursor,ycursor);end;
 16 : begin sc.zoom(1/zoomfactor);sc.MovetoXY(xcursor,ycursor);end;
 17 : sc.cfgsc.theta:=sc.cfgsc.theta+deg2rad*15;
 18 : sc.cfgsc.theta:=sc.cfgsc.theta-deg2rad*15;
 19 : result:=cmd_SetGridEQ(arg[1]);
 20 : result:=cmd_SetGrid(arg[1]);
 21 : result:=cmd_SetStarMode(strtointdef(arg[1],-1));
 22 : result:=cmd_SetNebMode(strtointdef(arg[1],-1));
 23 : result:=cmd_SetSkyMode(arg[1]);
 24 : UndoExecute(self);
 25 : RedoExecute(self);
 26 : result:=cmd_SetProjection(arg[1]);
 27 : result:=cmd_SetFov(arg[1]);
 28 : result:=cmd_SetRa(arg[1]);
 29 : result:=cmd_SetDec(arg[1]);
 30 : result:=cmd_SetObs(arg[1]);
 31 : result:=cmd_IdentCursor;
 32 : result:=cmd_SaveImage(arg[1],arg[2],arg[3]);
 33 : SetAz(deg2rad*180,false);
 34 : SetAz(0,false);
 35 : SetAz(deg2rad*270,false);
 36 : SetAz(deg2rad*90,false);
 37 : SetZenit(0,false);
 38 : SetZenit(deg2rad*200,false);
 39 : Refresh;
 40 : result:=cmd_GetCursorPosition;
 41 : result:=cmd_GetGridEQ;
 42 : result:=cmd_GetGrid;
 43 : result:=cmd_GetStarMode;
 44 : result:=cmd_GetNebMode;
 45 : result:=cmd_GetSkyMode;
 46 : result:=cmd_GetProjection;
 47 : result:=cmd_GetFov(arg[1]);
 48 : result:=cmd_GetRA(arg[1]);
 49 : result:=cmd_GetDEC(arg[1]);
 50 : result:=cmd_GetDate;
 51 : result:=cmd_GetObs;
 52 : result:=cmd_SetDate(arg[1]);
 53 : result:=cmd_SetTZ(arg[1]);
 54 : result:=cmd_GetTZ;
 55 : begin cmd_SetRa(arg[1]); cmd_SetDec(arg[2]); cmd_SetFov(arg[3]); Refresh; end;
 56 : result:='not implemented'; // dss
 57 : result:=cmd_SaveImage('BMP',arg[1],'');
 58 : result:=cmd_SaveImage('GIF',arg[1],'');
 59 : result:=cmd_SaveImage('JPEG',arg[1],arg[2]);
 60 : result:=cmd_IdXY(arg[1],arg[2]);
 61 : cmd_GoXY(arg[1],arg[2]);
 62 : cmd_MoreStar;
 63 : cmd_LessStar;
 64 : cmd_MoreNeb;
 65 : cmd_LessNeb;
 66 : GridEQExecute(Self);
 67 : GridExecute(Self);
 68 : begin result:=cmd_SwitchGridNum; Refresh; end;
 69 : begin result:=cmd_SwitchConstL; Refresh; end;
 70 : begin result:=cmd_SwitchConstB; Refresh; end;
 71 : begin if sc.cfgsc.projpole<>equat then sc.cfgsc.projpole:=equat else sc.cfgsc.projpole:=altaz; refresh; end;
 77 : result:=cmd_SetGridNum(arg[1]);
 78 : result:=cmd_SetConstL(arg[1]);
 79 : result:=cmd_SetConstB(arg[1]);
else result:=msgFailed+' Bad command name';
end;
end;

procedure Tf_chart.FormKeyPress(Sender: TObject; var Key: Char);
begin
if lockkey then exit;
lockkey:=true;
try
case key of
#17 : if sc.plot.cfgplot.partsize<=4.8 then begin  // ctrl+q
       sc.plot.cfgplot.partsize:=sc.plot.cfgplot.partsize+0.2;
       Refresh;
     end;
#1 : if sc.plot.cfgplot.partsize>=0.3 then begin  // ctrl+a
       sc.plot.cfgplot.partsize:=sc.plot.cfgplot.partsize-0.2;
       Refresh;
     end;
#23 : if sc.plot.cfgplot.magsize<=9.5  then begin   // ctrl+w
       sc.plot.cfgplot.magsize:=sc.plot.cfgplot.magsize+0.5;
       Refresh;
     end;
#19 : if sc.plot.cfgplot.magsize>=1.5   then begin   // ctrl+s
       sc.plot.cfgplot.magsize:=sc.plot.cfgplot.magsize-0.5;
       Refresh;
     end;
#5  : if sc.plot.cfgplot.contrast<=980 then begin   // ctrl+e
       sc.plot.cfgplot.contrast:=sc.plot.cfgplot.contrast+20;
       Refresh;
     end;
#4  : if sc.plot.cfgplot.contrast>=120  then begin   // ctrl+d
       sc.plot.cfgplot.contrast:=sc.plot.cfgplot.contrast-20;
       Refresh;
     end;
#18 : if sc.plot.cfgplot.saturation<=250 then begin  // ctrl+r
       sc.plot.cfgplot.saturation:=sc.plot.cfgplot.saturation+20;
       Refresh;
     end;
#6  : if sc.plot.cfgplot.saturation>=5 then begin  // ctrl+f
       sc.plot.cfgplot.saturation:=sc.plot.cfgplot.saturation-20;
       Refresh;
     end;
'1' : SetField(deg2rad*sc.catalog.cfgshr.FieldNum[0]);
'2' : SetField(deg2rad*sc.catalog.cfgshr.FieldNum[1]);
'3' : SetField(deg2rad*sc.catalog.cfgshr.FieldNum[2]);
'4' : SetField(deg2rad*sc.catalog.cfgshr.FieldNum[3]);
'5' : SetField(deg2rad*sc.catalog.cfgshr.FieldNum[4]);
'6' : SetField(deg2rad*sc.catalog.cfgshr.FieldNum[5]);
'7' : SetField(deg2rad*sc.catalog.cfgshr.FieldNum[6]);
'8' : SetField(deg2rad*sc.catalog.cfgshr.FieldNum[7]);
'9' : SetField(deg2rad*sc.catalog.cfgshr.FieldNum[8]);
'0' : SetField(deg2rad*sc.catalog.cfgshr.FieldNum[9]);
'a' : SetZenit(deg2rad*200);
'e' : SetAz(deg2rad*270);
//'f' : SpeedButton17Click(Sender);  // find
//'h' : SpeedButton24Click(Sender);  // horizon
//'l' : ToolbarButtonLabelClick(Sender);  // label
//'m' : Coordone1Click(Sender);     // entree des coordonnees
'n' : SetAz(deg2rad*180);
//'p' : popupmenu2.popup(mouse.cursorpos.x,mouse.cursorpos.y);
//'q' : SwitchProj;
//'r' : SetRot(15);
's' : SetAz(0);
//'t' : Heure1Click(Sender);         // date time
'w' : SetAz(deg2rad*90);
'z' : SetZenit(0);
//'P' : SetRecording;
//'R' : SetRot(-15);
//'+' : SpeedButton2Click(Sender);
//'-' : SpeedButton3Click(Sender);
//' ' : HideMenu(not menu_on);
end;
Application.ProcessMessages;
finally
lockkey:=false;
end;
end;

procedure Tf_chart.SetField(field : double);
begin
sc.setfov(field);
Refresh;
end;

procedure Tf_chart.SetZenit(field : double; redraw:boolean=true);
var a,d,az : double;
begin
az:=sc.cfgsc.acentre;
if field>0 then begin
  if sc.cfgsc.windowratio>1  then sc.cfgsc.fov:=field*sc.cfgsc.windowratio
     else sc.cfgsc.fov:=field;
end;
sc.cfgsc.ProjPole:=Altaz;
sc.cfgsc.Acentre:=0;
sc.cfgsc.hcentre:=pid2;
Hz2Eq(sc.cfgsc.acentre,sc.cfgsc.hcentre,a,d,sc.cfgsc);
sc.cfgsc.racentre:=sc.cfgsc.CurST-a;
sc.cfgsc.decentre:=d;
sc.cfgsc.TrackOn:=false;
if field>0 then begin
   setaz(az,redraw);
   end
else if redraw then Refresh;
end;

procedure Tf_chart.SetAz(Az : double; redraw:boolean=true);
var a,d : double;
begin
a := minvalue([sc.cfgsc.Fov,sc.cfgsc.Fov/sc.cfgsc.windowratio]);
if sc.cfgsc.Fov<pi then Hz2Eq(Az,a/2.3,a,d,sc.cfgsc)
                   else Hz2Eq(Az,sc.cfgsc.hcentre,a,d,sc.cfgsc);
sc.cfgsc.acentre:=Az;
sc.cfgsc.racentre:=sc.cfgsc.CurST-a;
sc.cfgsc.decentre:=d;
sc.cfgsc.ProjPole:=Altaz;
sc.cfgsc.TrackOn:=false;
if redraw then Refresh;
end;

procedure Tf_chart.SetDateUT(y,m,d,h,n,s:integer);
var jj,hh,sn: double;
begin
sn:=sign(h);
hh:=h+sn*n/60+sn*s/3600;
jj:=jd(y,m,d,hh);
SetJD(jj);
end;

procedure Tf_chart.SetJD(njd:double);
var y,m,d : integer;
    h : double;
begin
sc.cfgsc.tz.JD:=njd;
sc.cfgsc.TimeZone:=sc.cfgsc.tz.SecondsOffset/3600;
djd(njd+(sc.cfgsc.TimeZone-sc.cfgsc.DT_UT)/24,y,m,d,h);
sc.cfgsc.UseSystemTime:=false;
sc.cfgsc.CurYear:=y;
sc.cfgsc.CurMonth:=m;
sc.cfgsc.CurDay:=d;
sc.cfgsc.CurTime:=h;
if (not sc.cfgsc.TrackOn)and(sc.cfgsc.Projpole=Altaz) then begin
  sc.cfgsc.TrackOn:=true;
  sc.cfgsc.TrackType:=4;
end;
Refresh;
end;

procedure Tf_chart.IdentDetail(X, Y: Integer);
var ra,dec,a,h,l,b,le,be,dx:double;
begin
if locked then exit;
sc.GetCoord(x,y,ra,dec,a,h,l,b,le,be);
ra:=rmod(ra+pi2,pi2);
dx:=1/sc.cfgsc.BxGlb; // search a 1 pixel radius
sc.FindatRaDec(ra,dec,dx,true);
if sc.cfgsc.FindDesc>'' then begin
   if assigned(Fshowinfo) then Fshowinfo(wordspace(sc.cfgsc.FindDesc),caption,true,self);
   identlabelClick(Self);
end;   
end;


procedure Tf_chart.Connect1Click(Sender: TObject);

begin
{$ifdef win32}
if sc.cfgsc.PluginTelescope then begin
   ConnectPlugin(Sender);
end;
{$endif}
if sc.cfgsc.ManualTelescope then begin

end;
if sc.cfgsc.IndiTelescope then begin
if Connect1.checked then begin
   indi1.terminate;
   sc.cfgsc.ScopeMark:=false;
   sc.cfgsc.TrackOn:=false;
   Refresh;
end else begin
if (indi1=nil)or(indi1.Terminated) then begin
   indi1:=TIndiClient.Create;
   indi1.TargetHost:=sc.cfgsc.IndiServerHost;
   indi1.TargetPort:=sc.cfgsc.IndiServerPort;
   indi1.Timeout := 500;
   indi1.TelescopePort:=sc.cfgsc.IndiPort;
   if sc.cfgsc.IndiDevice=rsOther then indi1.Device:=''
      else indi1.Device:=sc.cfgsc.IndiDevice;
   indi1.IndiServer:=sc.cfgsc.IndiServerCmd;
   indi1.IndiDriver:=sc.cfgsc.IndiDriver;
   indi1.AutoStart:=sc.cfgsc.IndiAutostart;
   indi1.Autoconnect:=true;
   indi1.onCoordChange:=TelescopeCoordChange;
   indi1.onStatusChange:=TelescopeStatusChange;
   indi1.onMessage:=TelescopeGetMessage;
   indi1.Resume;
   sc.cfgsc.TrackOn:=true;
end else begin
   indi1.Connect;
   sc.cfgsc.TrackOn:=true;
end;
end;
end;
end;

procedure Tf_chart.Slew1Click(Sender: TObject);
var ra,dec:double;
begin
if Connect1.checked then begin
{$ifdef win32}
if not sc.cfgsc.IndiTelescope then begin
   SlewPlugin(Sender);
end else
{$endif}
begin
ra:=sc.cfgsc.FindRA;
dec:=sc.cfgsc.FindDec;
if sc.cfgsc.ApparentPos then mean_equatorial(ra,dec,sc.cfgsc);
if not indi1.EquatorialOfDay then precession(sc.cfgsc.JDChart,jd2000,ra,dec);
indi1.RA:=formatfloat(f6,ra*rad2deg/15);
indi1.Dec:=formatfloat(f6,dec*rad2deg);
Indi1.Slew;
end;
end
else if assigned(Fshowinfo) then Fshowinfo(rsTelescopeNot);
end;

procedure Tf_chart.AbortSlew1Click(Sender: TObject);
begin
if Connect1.checked then begin
{$ifdef win32}
if not sc.cfgsc.IndiTelescope then begin
   AbortSlewPlugin(Sender);
end else
{$endif}
begin
Indi1.AbortSlew;
end;
end;
end;

procedure Tf_chart.Sync1Click(Sender: TObject);

var ra,dec:double;
begin
if Connect1.checked and
   (mrYes=MessageDlg(Format(rsPleaseConfir, [sc.cfgsc.FindName]),
     mtConfirmation, [mbYes, mbNo], 0))
then begin
{$ifdef win32}
if not sc.cfgsc.IndiTelescope then begin
   SyncPlugin(Sender);
end else
{$endif}
begin
  ra:=sc.cfgsc.FindRA;
  dec:=sc.cfgsc.FindDec;
  if sc.cfgsc.ApparentPos then mean_equatorial(ra,dec,sc.cfgsc);
  if not indi1.EquatorialOfDay then precession(sc.cfgsc.JDChart,jd2000,ra,dec);
  indi1.RA:=formatfloat(f6,ra*rad2deg/15);
  indi1.Dec:=formatfloat(f6,dec*rad2deg);
  Indi1.Sync;
end;
end
else if assigned(Fshowinfo) then Fshowinfo(rsTelescopeNot);
end;

procedure Tf_chart.TelescopeCoordChange(Sender: TObject);
var ra,dec:double;
    i:integer;
begin
//if (indi1.RA='0')and(indi1.Dec='0') then exit;
try
val(indi1.RA,ra,i);
if i<>0 then exit;
val(indi1.Dec,Dec,i);
if i<>0 then exit;
ra:=ra*15*deg2rad;
dec:=dec*deg2rad;
if not indi1.EquatorialOfDay then precession(jd2000,sc.cfgsc.JDChart,ra,dec);
if sc.cfgsc.ApparentPos then apparent_equatorial(ra,dec,sc.cfgsc);
identlabel.Visible:=false;
sc.TelescopeMove(ra,dec);
if sc.cfgsc.moved and assigned(FChartMove) then FChartMove(self);
except
end;
end;


procedure Tf_chart.TelescopeStatusChange(Sender : Tobject; source: TIndiSource; status: TIndistatus);
begin
if source=Telescope then begin
   if (status=Ok)or(status=Busy) then Connect1.checked:=true
                                 else Connect1.checked:=false;
if assigned(FUpdateBtn) then FUpdateBtn(sc.cfgsc.flipx,sc.cfgsc.flipy,Connect1.checked,self);
end;
end;

procedure Tf_chart.TelescopeGetMessage(Sender : TObject; const msg : string);
begin
if assigned(Fshowinfo) then Fshowinfo(Format(rsTelescope2, [msg]));
end;

procedure Tf_chart.NewFinderCircle1Click(Sender: TObject);
begin
if MovingCircle or (sc.cfgsc.NumCircle>=MaxCircle) then exit;
mouse.CursorPos:=point(xcursor+Image1.ClientOrigin.x,ycursor+Image1.ClientOrigin.y);
GetAdXy(Xcursor,Ycursor,sc.cfgsc.CircleLst[0,1],sc.cfgsc.CircleLst[0,2],sc.cfgsc);
sc.DrawFinderMark(sc.cfgsc.CircleLst[0,1],sc.cfgsc.CircleLst[0,2],true);
MovingCircle := true;
StartCircle:=true;
end;


procedure Tf_chart.RemoveLastCircle1Click(Sender: TObject);
begin
if sc.cfgsc.NumCircle>0 then dec(sc.cfgsc.NumCircle);
Refresh;
end;

procedure Tf_chart.RemoveAllCircles1Click(Sender: TObject);
begin
sc.cfgsc.NumCircle:=0;
Refresh;
end;

procedure Tf_chart.SetNightVision(value:boolean);
var i:integer;
begin
if value=FNightVision then exit;
FNightVision:=value;
if FNightVision then begin
   SaveColor:=sc.plot.cfgplot.color;
   for i:=1 to numlabtype do SaveLabelColor[i]:=sc.plot.cfgplot.labelcolor[i];
   sc.plot.cfgplot.color:=DfRedColor;
   for i:=1 to numlabtype do sc.plot.cfgplot.labelcolor[i]:=$000000A0;
   {$ifdef win32}
     Panel1.Color:=nv_dark;
   {$endif}
end else begin
   if (Savecolor[2]=DfRedColor[2])and(Savecolor[11]=DfRedColor[11]) then begin // started with night vision, return to default color as save is also red. 
      sc.plot.cfgplot.color:=DfColor;
      for i:=1 to numlabtype do sc.plot.cfgplot.labelcolor[i]:=clWhite;
      sc.plot.cfgplot.labelcolor[6]:=clYellow;
   end else begin
      sc.plot.cfgplot.color:=SaveColor;
      for i:=1 to numlabtype do sc.plot.cfgplot.labelcolor[i]:=SaveLabelColor[i];
   end;
   {$ifdef win32}
     Panel1.Color:=clBtnFace;
   {$endif}
end;
Refresh;
end;


function Tf_chart.SaveChartImage(format,fn : string; quality : integer=95):boolean;
var
   JPG : TJpegImage;
   PNG : TPortableNetworkGraphic;
   savelabel,needrefresh:boolean;
begin
needrefresh:=false;
savelabel:= sc.cfgsc.Editlabels;
format:=uppercase(format);
try
if savelabel then begin
   sc.cfgsc.Editlabels:=false;
   sc.Refresh;
   needrefresh:=true;
end;
if identlabel.Visible then begin
  sc.plot.cnv:=sc.plot.cbmp.Canvas;
  sc.plot.PlotText(identlabel.Left,identlabel.Top,2,identlabel.Font.Color,laLeft,laTop,identlabel.Caption);
  needrefresh:=true;
end;
 if fn='' then fn:='cdc.bmp';
 if format='' then format:='BMP';
 if format='PNG' then begin
    fn:=changefileext(fn,'.png');
    PNG := TPortableNetworkGraphic.Create;
    try
    // Convert the bitmap to PNG
    PNG.Assign(sc.plot.cbmp);
    // Save the PNG
    PNG.SaveToFile(fn);
    result:=true;
    finally
    PNG.Free;
    end;
    end
 else if format='JPEG' then begin
    fn:=changefileext(fn,'.jpg');
    JPG := TJpegImage.Create;
    try
    // Convert the bitmap to a Jpeg
    JPG.Assign(sc.plot.cbmp);
    JPG.CompressionQuality:=quality;
    // Save the Jpeg
    JPG.SaveToFile(fn);
    result:=true;
    finally
    JPG.Free;
    end;
    end
 else if format='BMP' then begin
    fn:=changefileext(fn,'.bmp');
    sc.plot.cbmp.savetofile(fn);
    result:=true;
    end
 else result:=false;
finally
if savelabel then begin
   sc.cfgsc.Editlabels:=true;
end;
if needrefresh then begin
   sc.Refresh;
   SetScrollBar;
end;
end;
end;

// Windows only telescope plugin 

procedure Tf_chart.ConnectPlugin(Sender: TObject);
var ok: boolean;
begin
if Connect1.checked then begin
   Ftelescope.ScopeShow;
end else begin
   if not Ftelescope.scopelibok then Ftelescope.InitScopeLibrary;
   if Ftelescope.scopelibok then begin
     Ftelescope.ScopeSetObs(sc.cfgsc.ObsLatitude,sc.cfgsc.ObsLongitude);
     Ftelescope.ScopeShow;
     ok:=Ftelescope.ScopeConnect;
     Connect1.Checked:=ok;
     TelescopeTimer.Enabled:=ok;
     sc.cfgsc.TrackOn:=true;
   end;
end;
if assigned(FUpdateBtn) then FUpdateBtn(sc.cfgsc.flipx,sc.cfgsc.flipy,Connect1.checked,self);
end;

procedure Tf_chart.SlewPlugin(Sender: TObject);
var ra,dec:double;
    ok:boolean;
begin
ra:=sc.cfgsc.FindRA;
dec:=sc.cfgsc.FindDec;
if sc.cfgsc.ApparentPos then mean_equatorial(ra,dec,sc.cfgsc);
precession(sc.cfgsc.JDChart,jd2000,ra,dec);
Ftelescope.ScopeGoto(ra*rad2deg/15,dec*rad2deg,ok);
end;

procedure Tf_chart.AbortSlewPlugin(Sender: TObject);
begin
Ftelescope.ScopeShow;
end;

procedure Tf_chart.SyncPlugin(Sender: TObject);
var ra,dec:double;
begin
ra:=sc.cfgsc.FindRA;
dec:=sc.cfgsc.FindDec;
if sc.cfgsc.ApparentPos then mean_equatorial(ra,dec,sc.cfgsc);
precession(sc.cfgsc.JDChart,jd2000,ra,dec);
Ftelescope.ScopeAlign(sc.cfgsc.FindName,ra*rad2deg/15,dec*rad2deg);
end;

procedure Tf_chart.TelescopeTimerTimer(Sender: TObject);
var ra,dec:double;
    ok: boolean;
begin
try
TelescopeTimer.Enabled:=false;
if Ftelescope.scopelibok then begin
 Connect1.checked:=Ftelescope.ScopeConnected;
 if Connect1.checked then begin
   Ftelescope.ScopeGetRaDec(ra,dec,ok);
   if ok then begin
      ra:=ra*15*deg2rad;
      dec:=dec*deg2rad;
      precession(jd2000,sc.cfgsc.JDChart,ra,dec);
      if sc.TelescopeMove(ra,dec) then identlabel.Visible:=false;
      if sc.cfgsc.moved then begin
         Image1.Invalidate;
         if assigned(FChartMove) then FChartMove(self);
      end;
      TelescopeTimer.Interval:=500;
      TelescopeTimer.Enabled:=true;
   end;
 end else begin
   TelescopeTimer.Interval:=2000;
   TelescopeTimer.Enabled:=true;
   if sc.cfgsc.ScopeMark then begin
      sc.cfgsc.ScopeMark:=false;
      sc.cfgsc.TrackOn:=false;
      Refresh;
   end;
 end;
end else begin
   Connect1.checked:=false;
   TelescopeTimer.Enabled:=false;
   if sc.cfgsc.ScopeMark then begin
      sc.cfgsc.ScopeMark:=false;
      sc.cfgsc.TrackOn:=false;
      Refresh;
   end;
end;
if assigned(FUpdateBtn) then FUpdateBtn(sc.cfgsc.flipx,sc.cfgsc.flipy,Connect1.checked,self);
except
 TelescopeTimer.Enabled:=false;
 Connect1.checked:=false;
end;
end;


initialization
  {$i pu_chart.lrs}

end.

