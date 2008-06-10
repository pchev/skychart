unit aavsochart;

{$MODE Delphi}

{
Copyright (C) 2005 Patrick Chevalley

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

interface

uses
  LCLIntf, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, LResources, u_param;

type
  Tchartform = class(TForm)
    Button1: TButton;
    ListBox1: TListBox;
    Label1: TLabel;
    procedure FormShow(Sender: TObject);
    procedure ListBox1Click(Sender: TObject);
  private
    { Private declarations }
  public
    chartlist:string;
    chartdir:string;
    { Public declarations }
  end;

var
  chartform: Tchartform;

implementation

Uses Variables1;

procedure Tchartform.FormShow(Sender: TObject);
var i: integer;
    buf1,buf2:string;
    byinternet:boolean;
begin
byinternet:=(pos('://',chartdir)>0);
if byinternet then chartdir:=slashX(chartdir)
              else chartdir:=slash(chartdir);
label1.Caption:=chartdir;
Listbox1.clear;
buf1:=chartlist;
i:=pos(',',buf1);
while i>0 do begin
  buf2:=trim(copy(buf1,1,i-1));
  if not byinternet then buf2:=stringreplace(buf2,'/','\',[rfReplaceAll]);
  delete(buf1,1,i);
  Listbox1.items.add(buf2);
  i:=pos(',',buf1);
end;
end;

procedure Tchartform.ListBox1Click(Sender: TObject);
begin
ExecuteFile(chartdir+ListBox1.Items[ListBox1.ItemIndex]);
end;

initialization
  {$i aavsochart.lrs}

end.
