unit fu_chart;
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
 Chart form for Linux CLX application
}

interface

uses fu_detail, cu_skychart, u_constant, u_util, u_projection,
  SysUtils, Types, Classes, QGraphics, QControls, QForms, QDialogs,
  QStdCtrls, QExtCtrls, QMenus, QTypes, QComCtrls, QPrinters, QActnList;

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
    MoveSouthEast: TAction;
    MoveSouthWest: TAction;
    PopupMenu1: TPopupMenu;
    zoomplus1: TMenuItem;
    zoomminus1: TMenuItem;
    Centre: TAction;
    Centre1: TMenuItem;
    Panel1: TPanel;
    Image1: TImage;
    EdCopy: TAction;
    zoomplusmove: TAction;
    zoomminusmove: TAction;
    Flipx: TAction;
    Flipy: TAction;
    GridEQ: TAction;
    GridAZ: TAction;
    rot_plus: TAction;
    rot_minus: TAction;
    Undo: TAction;
    Redo: TAction;
    identlabel: TLabel;
    switchstar: TAction;
    switchbackground: TAction;
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
    procedure zoomplusmoveExecute(Sender: TObject);
    procedure zoomminusmoveExecute(Sender: TObject);
    procedure FlipxExecute(Sender: TObject);
    procedure FlipyExecute(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure GridAZExecute(Sender: TObject);
    procedure GridEQExecute(Sender: TObject);
    procedure rot_minusExecute(Sender: TObject);
    procedure rot_plusExecute(Sender: TObject);
    procedure RedoExecute(Sender: TObject);
    procedure UndoExecute(Sender: TObject);
    procedure identlabelClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Image1Click(Sender: TObject);
    procedure FormMouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
    procedure switchstarExecute(Sender: TObject);
    procedure switchbackgroundExecute(Sender: TObject);
  private
    { Private declarations }
    movefactor,zoomfactor: double;
    xcursor,ycursor : integer;
    lock_trackcursor,LockWheel : boolean;
  public
    { Public declarations }
    sc: Tskychart;
    maximize:boolean;
    undolist : array[1..maxundo] of conf_skychart;
    lastundo,curundo,validundo : integer;
    procedure Refresh;
    procedure AutoRefresh;
    procedure PrintChart(Sender: TObject);
    function  FormatDesc:string;
    procedure ShowIdentLabel;
    function  LongLabel(txt:string):string;
    function  LongLabelObj(txt:string):string;
    function  LongLabelGreek(txt : string) : string;
    Function  LongLabelConst(txt : string) : string;
    procedure CKeyDown(var Key: Word; Shift: TShiftState);
    procedure CMouseWheel(Shift: TShiftState;WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
  end;


implementation

{$R *.xfm}

uses QClipbrd, fu_main;

// include all cross-platform common code.
// you can temporarily copy the file content here
// to use the IDE facilities

{$include i_chart.pas}


// end of common code



// Specific Linux CLX code:


procedure Tf_chart.FormMouseWheel(Sender: TObject; Shift: TShiftState;

  WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
begin
// why two event for each mouse turn ?
if lockwheel then begin
   lockwheel:=false;
end else begin
   lockwheel:=true;
   CMouseWheel(Shift,WheelDelta,MousePos,Handled);
end;   
end;

// End of Linux specific CLX code:



end.


