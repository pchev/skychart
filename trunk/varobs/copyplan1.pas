unit copyplan1;

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
  LCLIntf, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, LResources;

type
  TForm1 = class(TForm)
    Edit1: TEdit;
    Label1: TLabel;
    Edit2: TEdit;
    Label2: TLabel;
    Label3: TLabel;
    Edit3: TEdit;
    Button1: TButton;
    Label4: TLabel;
    Button2: TButton;
    OpenDialog1: TOpenDialog;
    Button3: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Edit1Change(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  Form1: TForm1;
  f, fi, fv : textfile;

implementation


Function Findval(design : string; var line : string):boolean;
var buf : string;
    p : integer;
begin
line:='';
reset(fv);
repeat
   readln(fv,buf);
   p:=pos(design,buf);
   result:=p>0;
until result or eof(fv);
if result then line:=buf;
end;

procedure TForm1.Button1Click(Sender: TObject);
var buf,design : string;
    ok : boolean;
begin
screen.cursor:=crhourglass;
try
filemode:=0;
assignfile(fi,edit1.text);
reset(fi);
assignfile(fv,edit2.text);
reset(fv);
assignfile(f,edit3.text);
rewrite(f);
repeat
   readln(fi,buf);
   design:=trim(copy(buf,1,8));
   ok:=findval(design,buf);
   if ok then writeln(f,buf);
until eof(fi);
closefile(f);
closefile(fi);
closefile(fv);
showmessage('Terminated !')
finally
screen.cursor:=crdefault;
end;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
Close;
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
if opendialog1.execute then edit1.Text:=opendialog1.FileName;
end;

procedure TForm1.Edit1Change(Sender: TObject);
begin
edit3.Text:=changefileext(edit1.Text,'.txt');
end;

initialization
  {$i copyplan1.lrs}

end.
