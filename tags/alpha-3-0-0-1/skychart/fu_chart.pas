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

uses cu_skychart, u_constant, u_util,
  SysUtils, Types, Classes, QGraphics, QControls, QForms, QDialogs,
  QStdCtrls, QExtCtrls, QMenus, QTypes, QComCtrls, QPrinters, QActnList;

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
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Refresh;
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
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure CentreExecute(Sender: TObject);
    procedure PopupMenu1Popup(Sender: TObject);
    procedure FormMouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
    procedure Image1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure zoomplusmoveExecute(Sender: TObject);
    procedure zoomminusmoveExecute(Sender: TObject);
    procedure FlipxExecute(Sender: TObject);
    procedure FlipyExecute(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
    movefactor,zoomfactor: double;
    xcursor,ycursor : integer;
    lock_trackcursor : boolean;
    skip_wheel : boolean;
  public
    { Public declarations }
    sc: Tskychart;
    maximize:boolean;
    procedure PrintChart(Sender: TObject);
  end;


implementation

{$R *.xfm}

uses QClipbrd, fu_main;

// include all cross-platform common code.
// you can temporarily copy the file content here
// to use the IDE facilities

{$include i_chart.pas}


// end of common code


end.

