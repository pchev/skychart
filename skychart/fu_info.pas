unit fu_info;
{
Copyright (C) 2003 Patrick Chevalley

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
 Information Form (TCP/IP Server)
}

interface

uses u_constant, blcksock,
  SysUtils, Types, Classes, Variants, QTypes, QGraphics, QControls, QForms,
  QDialogs, QStdCtrls, QGrids, QComCtrls, QExtCtrls, QMenus;

type
  Tf_info = class(TForm)
    PageControl1: TPageControl;
    Panel1: TPanel;
    Button1: TButton;
    TabSheet1: TTabSheet;
    StringGrid1: TStringGrid;
    Panel2: TPanel;
    Button2: TButton;
    PopupMenu1: TPopupMenu;
    closeconnection: TMenuItem;
    CheckBox1: TCheckBox;
    Timer1: TTimer;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure closeconnectionClick(Sender: TObject);
    procedure StringGrid1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormShow(Sender: TObject);
    procedure CheckBox1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Timer1Timer(Sender: TObject);
  private
    { Private declarations }
    RowClick,ColClick :integer;
  public
    { Public declarations }
  end;

var
  f_info: Tf_info;

implementation

uses fu_main;

{$R *.xfm}

// include all cross-platform common code.
// you can temporarily copy the file content here
// to use the IDE facilities

{$include i_info.pas }

// end of common code

// Linux CLX specific code:


// end of Linux CLX specific code:

end.
