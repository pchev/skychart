unit pu_catgenadv;

{
Copyright (C) 2006 Patrick Chevalley

http://www.ap-i.net
pch@ap-i.net

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
Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
}

{$MODE objfpc}{$H+}

interface

uses
  u_help, u_translation, UScaleDPI,
  Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, LResources, LazHelpHTML_fix;

type

  { Tf_catgenadv }

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
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Edit1Change(Sender: TObject);
    procedure Edit3Change(Sender: TObject);
  private
    { Déclarations privées }
    procedure RefreshCalc;
  public
    { Déclarations publiques }
    A, B, X, R: double;
    procedure SetLang;
  end;

implementation

{$R *.lfm}

const
  fformat = '0.###############';

procedure Tf_catgenadv.SetLang;
begin
  Caption := rsComputeField;
  Label4.Caption := rsIndicateHere;
  Button1.Caption := rsOK;
  Button2.Caption := rsCancel;
  SetHelp(self, hlpCatgen);
end;

procedure Tf_catgenadv.RefreshCalc;
var
  buf: string;
begin
  R := A * X + B;
  //str(R:16:10,buf);
  buf := formatfloat(fformat, R);
  edit4.Text := buf;
end;

procedure Tf_catgenadv.FormShow(Sender: TObject);
var
  buf: string;
begin
  //str(A:16:10,buf);
  buf := formatfloat(fformat, A);
  edit1.Text := buf;
  //str(X:16:10,buf);
  buf := formatfloat(fformat, X);
  edit2.Text := buf;
  //str(B:16:10,buf);
  buf := formatfloat(fformat, B);
  edit3.Text := buf;
  RefreshCalc;
end;

procedure Tf_catgenadv.FormCreate(Sender: TObject);
begin
  ScaleDPI(Self);
  SetLang;
end;

procedure Tf_catgenadv.Edit1Change(Sender: TObject);
var
  xx: double;
  i: integer;
begin
  val(edit1.Text, xx, i);
  if i = 0 then
  begin
    A := xx;
    RefreshCalc;
  end
  else
    edit1.SetFocus;
end;

procedure Tf_catgenadv.Edit3Change(Sender: TObject);
var
  xx: double;
  i: integer;
begin
  val(edit3.Text, xx, i);
  if i = 0 then
  begin
    B := xx;
    RefreshCalc;
  end
  else
    edit3.SetFocus;
end;

end.
