unit fu_directory;
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
 Directory dialog replacement for Linux CLX application
}

interface

uses  u_constant, 
  SysUtils, Types, Classes, Variants, QTypes, QGraphics, QControls, QForms, 
  QDialogs, QStdCtrls, QComCtrls, QFileCtrls;

type
  Tf_directory = class(TForm)
    DirectoryTreeView1: TDirectoryTreeView;
    Button1: TButton;
    Button2: TButton;
    Label1: TLabel;
    procedure DirectoryTreeView1Change(Sender: TObject; Node: TTreeNode);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  f_directory: Tf_directory;

implementation

{$R *.xfm}

procedure Tf_directory.DirectoryTreeView1Change(Sender: TObject;
  Node: TTreeNode);
begin
 label1.Caption:=DirectoryTreeView1.Directory;
end;

procedure Tf_directory.FormShow(Sender: TObject);
begin
 label1.Caption:=DirectoryTreeView1.Directory;
end;

end.
