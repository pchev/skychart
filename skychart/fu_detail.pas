unit fu_detail;
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
 Detail display form for Linux CLX application
}
interface

uses
  SysUtils, Types, Classes, Variants, QTypes, QGraphics, QControls, QForms, 
  QDialogs, QStdCtrls, QComCtrls, QExtCtrls, QMenus, QStdActns, QActnList;

type
  Tf_detail = class(TForm)
    Panel1: TPanel;
    memo: TTextBrowser;
    Button1: TButton;
    ActionList1: TActionList;
    EditSelectAll1: TEditSelectAll;
    EditCopy1: TEditCopy;
    PopupMenu1: TPopupMenu;
    SelectAll1: TMenuItem;
    Copy1: TMenuItem;
    procedure Button1Click(Sender: TObject);
    procedure EditSelectAll1Execute(Sender: TObject);
    procedure EditCopy1Execute(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  f_detail: Tf_detail;

implementation

{$R *.xfm}

procedure Tf_detail.Button1Click(Sender: TObject);
begin
close;
end;

procedure Tf_detail.EditSelectAll1Execute(Sender: TObject);
begin
memo.SelectAll;
end;

procedure Tf_detail.EditCopy1Execute(Sender: TObject);
begin
memo.CopyToClipboard;
end;

end.
