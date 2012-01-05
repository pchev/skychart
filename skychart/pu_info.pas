unit pu_info;
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
 Information Form (TCP/IP Server, Object list, ...)
}

interface

uses u_constant, u_util,
  SysUtils, Types, Classes, Variants, Controls, Forms, Printers,
  Dialogs, StdCtrls, Grids, ComCtrls, ExtCtrls, Menus, StdActns, ActnList;

type
  Tistrfunc = procedure(i:integer; var txt:string) of object;
  Tint1func = procedure(i:integer) of object;
  Tdetinfo  = procedure(chart:string;ra,dec:double;nm,desc:string) of object;

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
    TabSheet2: TTabSheet;
    Panel3: TPanel;
    Button3: TButton;
    Edit1: TEdit;
    Button5: TButton;
    Button4: TButton;
    Memo1: TRichEdit;
    PopupMenu2: TPopupMenu;
    ActionList1: TActionList;
    EditSelectAll1: TEditSelectAll;
    EditCopy1: TEditCopy;
    outslectionner1: TMenuItem;
    Copier1: TMenuItem;
    Button6: TButton;
    Button7: TButton;
    SaveDialog1: TSaveDialog;
    ProgressMessages: TTabSheet;
    ProgressMemo: TMemo;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure closeconnectionClick(Sender: TObject);
    procedure StringGrid1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormShow(Sender: TObject);
    procedure CheckBox1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Timer1Timer(Sender: TObject);
    procedure Edit1KeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Button3Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure Memo1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  private
    { Private declarations }
    FGetTCPinfo : Tistrfunc;
    FKillTCP : Tint1func;
    FPrintSetup: TNotifyEvent;
    Fdetailinfo: Tdetinfo;
    RowClick,ColClick :integer;
  public
    { Public declarations }
    source_chart:string;
    procedure setpage(n:integer);
    property OnGetTCPinfo: Tistrfunc read FGetTCPinfo write FGetTCPinfo;
    property OnKillTCP: Tint1func read FKillTCP write FKillTCP;
    property OnPrintSetup: TNotifyEvent read FPrintSetup write FPrintSetup;
    property OnShowDetail: Tdetinfo read Fdetailinfo write Fdetailinfo;
  end;

var
  f_info: Tf_info;

implementation

{$R *.dfm}

// include all cross-platform common code.
// you can temporarily copy the file content here
// to use the IDE facilities

{$include i_info.pas }

// end of common code

// windows vcl specific code:

// end of windows vcl specific code:


end.
