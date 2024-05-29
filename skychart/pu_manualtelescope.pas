unit pu_manualtelescope;

{$MODE Delphi}{$H+}

{
Copyright (C) 2005 Patrick Chevalley

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

interface

uses
  u_translation, UScaleDPI,
  LCLIntf, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, LResources;

type

  { Tf_manualtelescope }

  Tf_manualtelescope = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormDblClick(Sender: TObject);
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: integer);
    procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X, Y: integer);
    procedure FormMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: integer);
  private
    { Private declarations }
    startpoint: TPoint;
    moving, lockmove: boolean;
  public
    { Public declarations }
    procedure SetTurn(txt: string);
    procedure SetLang;
  end;

var
  f_manualtelescope: Tf_manualtelescope;

implementation

{$R *.lfm}

uses u_constant;

procedure Tf_manualtelescope.SetLang;
begin
  Caption := rsManualTelesc;
  Label1.Caption := rsManualTelesc;
  Label4.Caption := rsRATurns;
  Label5.Caption := rsDECTurns;
  Label2.Caption := '';
end;

procedure Tf_manualtelescope.SetTurn(txt: string);
var
  i: integer;
begin
  i := pos(tab, txt);
  if i = 0 then
    exit;
  label1.Caption := copy(txt, 1, i - 1);
  Delete(txt, 1, i);
  i := pos(tab, txt);
  if i = 0 then
    exit;
  label2.Caption := copy(txt, 1, i - 1);
  Delete(txt, 1, i);
  i := pos(tab, txt);
  if i = 0 then
    exit;
  label2.Caption := label2.Caption + blank + copy(txt, 1, i - 1);
  Delete(txt, 1, i);
  i := pos(tab, txt);
  if i = 0 then
    exit;
  label4.Caption := copy(txt, 1, i - 1);
  Delete(txt, 1, i);
  i := pos(tab, txt);
  if i = 0 then
    exit;
  label5.Caption := copy(txt, 1, i - 1);
  Delete(txt, 1, i);
  if (label2.Width + label2.left + 8) > Width then
    Width := label2.Width + label2.left + 8;
end;

procedure Tf_manualtelescope.FormMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: integer);
begin
  startpoint := clienttoscreen(point(X, Y));
  moving := True;
  lockmove := False;
end;

procedure Tf_manualtelescope.FormCreate(Sender: TObject);
begin
  {$ifdef darwin}
  FormStyle := fsNormal;
  {$endif}
  {$ifdef lclgtk2}
  FormStyle := fsNormal;
  {$endif}
  ScaleDPI(Self);
  SetLang;
end;

procedure Tf_manualtelescope.FormDblClick(Sender: TObject);
begin
  moving := False;
  Hide;
end;

procedure Tf_manualtelescope.FormMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: integer);
var
  P: Tpoint;
  dt: TRect;
begin
  if moving and (not lockmove) then
  begin
    lockmove := True;
    dt := screen.DesktopRect;
    P := clienttoscreen(Point(X, Y));
    top := top + P.Y - startpoint.Y;
    if top < dt.Top then
      top := dt.Top;
    if top > (dt.Height - Height) then
      top := dt.Height - Height;
    left := left + P.X - startpoint.X;
    if left < dt.Left then
      left := dt.Left;
    if left > (dt.Width - Width) then
      left := dt.Width - Width;
    startpoint := P;
    application.ProcessMessages;
    lockmove := False;
  end;
end;

procedure Tf_manualtelescope.FormMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: integer);
begin
  moving := False;
end;

end.
