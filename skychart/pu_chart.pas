unit pu_chart;
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
 Chart form for Windows VCL application
}

interface

uses pu_detail, cu_skychart, cu_indiclient, u_constant, u_util, u_projection, jpeg, pngimage,
     Printers, Math, cu_telescope,
     Windows, Classes, Graphics, Dialogs, Forms, Controls, StdCtrls, ExtCtrls, Menus,
     ActnList, SysUtils;
     
const maxundo=10;

type
  Tstr1func = procedure(txt:string) of object;
  Tint2func = procedure(i1,i2:integer) of object;
  Tbtnfunc = procedure(i1,i2:integer;b1:boolean;sender:TObject) of object;
  Tshowinfo = procedure(txt:string; origin:string='';sendmsg:boolean=true; Sender: TObject=nil) of object;

  Tf_chart = class(TForm)
    RefreshTimer: TTimer;
    ActionList1: TActionList;
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
    Panel1: TPanel;
    Image1: TImage;
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
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure RefreshTimerTimer(Sender: TObject);
    procedure Image1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure FormShow(Sender: TObject);
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
    procedure Image1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure zoomminusmoveExecute(Sender: TObject);
    procedure zoomplusmoveExecute(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FlipXExecute(Sender: TObject);
    procedure FlipYExecute(Sender: TObject);
    procedure UndoExecute(Sender: TObject);
    procedure RedoExecute(Sender: TObject);
    procedure rot_plusExecute(Sender: TObject);
    procedure rot_minusExecute(Sender: TObject);
    procedure GridEQExecute(Sender: TObject);
    procedure GridExecute(Sender: TObject);
    procedure identlabelClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Image1Click(Sender: TObject);
    procedure switchstarExecute(Sender: TObject);
    procedure switchbackgroundExecute(Sender: TObject);
    procedure Image1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
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
    FShowTopMessage: Tstr1func;
    FUpdateBtn: Tbtnfunc;
    FShowInfo : Tshowinfo;
    FShowCoord: Tstr1func;
    FListInfo: Tstr1func;
    FChartMove: TnotifyEvent;
    movefactor,zoomfactor: double;
    xcursor,ycursor,skipmove : integer;
    MovingCircle: Boolean;
    procedure TelescopeCoordChange(Sender: TObject);
    procedure TelescopeStatusChange(Sender : Tobject; source: TIndiSource; status: TIndistatus);
    procedure TelescopeGetMessage(Sender : TObject; const msg : string);
    procedure ConnectPlugin(Sender: TObject);
    procedure SlewPlugin(Sender: TObject);
    procedure AbortSlewPlugin(Sender: TObject);
    procedure SyncPlugin(Sender: TObject);
  public
    { Public declarations }
    sc: Tskychart;
    indi1: TIndiClient;
    maximize,locked,LockTrackCursor,LockKeyboard,lastquick,lock_refresh :boolean;
    undolist : array[1..maxundo] of conf_skychart;
    lastundo,curundo,validundo, lastx,lasty,lastyzoom  : integer;
    zoomstep,Xzoom1,Yzoom1,Xzoom2,Yzoom2,DXzoom,DYzoom,XZoomD1,YZoomD1,XZoomD2,YZoomD2,ZoomMove : integer;
    procedure Refresh;
    procedure AutoRefresh;
    procedure PrintChart(printlandscape:boolean; printcolor,printmethod,printresol:integer ;printcmd1,printcmd2,printpath:string);
    function  FormatDesc:string;
    procedure ShowIdentLabel;
    function  IdentXY(X, Y: Integer):boolean;
    procedure Identdetail(X, Y: Integer);
    function  ListXY(X, Y: Integer):boolean;
    function  LongLabel(txt:string):string;
    function  LongLabelObj(txt:string):string;
    function  LongLabelGreek(txt : string) : string;
    Function  LongLabelConst(txt : string) : string;
    procedure CMouseWheel(Shift: TShiftState;WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
    procedure CKeyDown(var Key: Word; Shift: TShiftState);
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
    function SaveChartImage(format,fn : string; quality: integer=75):boolean;
    Procedure ZoomBox(action,x,y:integer);
    Procedure TrackCursor(X,Y : integer);
    Procedure ZoomCursor(yy : double);
    procedure SetField(field : double);
    procedure SetZenit(field : double; redraw:boolean=true);
    procedure SetAz(Az : double; redraw:boolean=true);
    procedure SetDate(y,m,d,h,n,s:integer);
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
    property telescopeplugin: Ttelescope read Ftelescope write Ftelescope;
    property OnImageSetFocus: TNotifyEvent read FImageSetFocus write FImageSetFocus;
    property OnShowTopMessage: Tstr1func read FShowTopMessage write FShowTopMessage;
    property OnUpdateBtn: Tbtnfunc read FUpdateBtn write FUpdateBtn;
    property OnShowInfo: TShowinfo read FShowInfo write FShowInfo;
    property OnShowCoord: Tstr1func read FShowCoord write FShowCoord;
    property OnListInfo: Tstr1func read FListInfo write FListInfo;
    property OnChartMove: TNotifyEvent read FChartMove write FChartMove;
  end;

implementation

{$R *.dfm}

// include all cross-platform common code.
// you can temporarily copy the file content here
// to use the IDE facilities

{$include i_chart.pas}

// end of common code

// windows vcl specific code:

function Tf_chart.SaveChartImage(format,fn : string; quality : integer=75):boolean;
var
   JPG : TJpegImage;
   PNG : TPNGObject;
begin
 if fn='' then fn:='cdc.png';
 if format='' then format:='PNG';
 if format='PNG' then begin
    fn:=changefileext(fn,'.png');
    PNG := TPNGObject.Create;
    try
    // Convert the bitmap to PNG
    PNG.Assign(Image1.Picture.Bitmap);
    PNG.CompressionLevel:=9;
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
    JPG.Assign(Image1.Picture.Bitmap);
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
    try
    Image1.Picture.Bitmap.SaveTofile(fn);
    result:=true;
    except
      result:=false;
    end;
    end
 else result:=false;
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
      if sc.cfgsc.moved and assigned(FChartMove) then FChartMove(self);
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

// end of windows vcl specific code

end.

