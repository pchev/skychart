unit pu_catgenadv;
{
Copyright (C) 2006 Patrick Chevalley

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

{$MODE objfpc}{$H+}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, LResources;

type
  Tf_catgenadv = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    procedure FormShow(Sender: TObject);
    procedure Edit1Change(Sender: TObject);
    procedure Edit3Change(Sender: TObject);
  private
    { Déclarations privées }
    Procedure RefreshCalc;
  public
    { Déclarations publiques }
    A,B,X,R : double;
  end;

var
  f_catgenadv: Tf_catgenadv;

implementation

const fformat = '0.###############';

Procedure Tf_catgenadv.RefreshCalc;
var buf:string;
begin
R:=A*X+B;
//str(R:16:10,buf);
buf:=formatfloat(fformat,R);
f_catgenadv.edit4.text:=buf;
end;

procedure Tf_catgenadv.FormShow(Sender: TObject);
var buf:string;
begin
//str(A:16:10,buf);
buf:=formatfloat(fformat,A);
edit1.text:=buf;
//str(X:16:10,buf);
buf:=formatfloat(fformat,X);
edit2.text:=buf;
//str(B:16:10,buf);
buf:=formatfloat(fformat,B);
edit3.text:=buf;
RefreshCalc;
end;

procedure Tf_catgenadv.Edit1Change(Sender: TObject);
var xx : double;
    i : integer;
begin
val(edit1.text,xx,i);
if i=0 then begin
  A:=xx;
  RefreshCalc;
end else edit1.setfocus;
end;

procedure Tf_catgenadv.Edit3Change(Sender: TObject);
var xx : double;
    i : integer;
begin
val(edit3.text,xx,i);
if i=0 then begin
  B:=xx;
  RefreshCalc;
end else edit3.setfocus;
end;

initialization
  {$i pu_catgenadv.lrs}

end.
