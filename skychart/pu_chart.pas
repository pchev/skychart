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

uses pu_detail, cu_skychart, u_constant, u_util, u_projection, jpeg, pngimage,
     Printers, Math, SysUtils,
     Windows, Classes, Graphics, Dialogs, Forms, Controls, StdCtrls, ExtCtrls, Menus,
     ActnList;
     
const maxundo=10;

type
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
  private
    { Private declarations }
    movefactor,zoomfactor: double;
    xcursor,ycursor : integer;
    lock_trackcursor : boolean;
  public
    { Public declarations }
    sc: Tskychart;
    maximize,LockTrackCursor,lastquick,lock_refresh :boolean;
    undolist : array[1..maxundo] of conf_skychart;
    lastundo,curundo,validundo, lastx,lasty,lastyzoom  : integer;
    zoomstep,Xzoom1,Yzoom1,Xzoom2,Yzoom2,DXzoom,DYzoom,XZoomD1,YZoomD1,XZoomD2,YZoomD2,ZoomMove : integer;
    procedure Refresh;
    procedure AutoRefresh;
    procedure PrintChart(Sender: TObject);
    function  FormatDesc:string;
    procedure ShowIdentLabel;
    function  IdentXY(X, Y: Integer):boolean;
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
    function GetChartInfo:string;
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
  end;

implementation

{$R *.dfm}

uses pu_main, pu_info;

// include all cross-platform common code.
// you can temporarily copy the file content here
// to use the IDE facilities

{$include i_chart.pas}

// end of common code

// windows vcl specific code:

function Tf_chart.SaveChartImage(format,fn : string; quality : integer=75):boolean;
var
   JPG : TJpegImage;
   PNG: TPNGObject;
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

// end of windows vcl specific code:

end.

