unit pu_manualtelescope;

{$MODE Delphi}{$H+}

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

uses u_translation,
  LCLIntf, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, LResources;

type

  { Tf_manualtelescope }

  Tf_manualtelescope = class(TForm)
    Panel1: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure FormMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Panel1DblClick(Sender: TObject);
  private
    { Private declarations }
    startpoint: TPoint;
    moving, lockmove: boolean;
  public
    { Public declarations }
    procedure SetTurn(txt:string);
    procedure SetLang;
  end;

var
  f_manualtelescope: Tf_manualtelescope;

implementation

uses u_constant;

procedure Tf_manualtelescope.SetLang;
begin
Caption:=rsManualTelesc;
Label1.caption:=rsManualTelesc;
Label4.caption:=rsRATurns;
Label5.caption:=rsDECTurns;
Label2.Caption:='';
end;

procedure Tf_manualtelescope.SetTurn(txt:string);
var i:integer;
begin
  i:=pos(tab,txt);
  if i=0 then exit;
  label1.Caption:=copy(txt,1,i-1);
  delete(txt,1,i);
  i:=pos(tab,txt);
  if i=0 then exit;
  label2.Caption:=copy(txt,1,i-1);
  delete(txt,1,i);
  i:=pos(tab,txt);
  if i=0 then exit;
  label2.Caption:=label2.Caption+blank+copy(txt,1,i-1);
  delete(txt,1,i);
  i:=pos(tab,txt);
  if i=0 then exit;
  label4.Caption:=copy(txt,1,i-1);
  delete(txt,1,i);
  i:=pos(tab,txt);
  if i=0 then exit;
  label5.Caption:=copy(txt,1,i-1);
  delete(txt,1,i);
if (label2.width+label2.left+8)>width then width:=label2.width+label2.left+8;
end;

procedure Tf_manualtelescope.FormMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
startpoint:=clienttoscreen(point(X,Y));
moving:=true;
lockmove:=false;
end;

procedure Tf_manualtelescope.FormCreate(Sender: TObject);
begin
  SetLang;
end;

procedure Tf_manualtelescope.FormMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
var P: Tpoint;
begin
if moving and (not lockmove) then begin
  lockmove:=true;
  P:=clienttoscreen(Point(X,Y));
  top:=top+P.Y-startpoint.Y;
  if top<0 then top:=0;
  if top>(screen.Height-Height) then top:=screen.Height-Height;
  left:=left+P.X-startpoint.X;
  if left<0 then left:=0;
  if left>(screen.Width-Width) then left:=screen.Width-Width;
  startpoint:=P;
  application.ProcessMessages;
  lockmove:=false;
end;
end;

procedure Tf_manualtelescope.FormMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
moving:=false;
end;

procedure Tf_manualtelescope.Panel1DblClick(Sender: TObject);
begin
moving:=false;
Hide;
end;

initialization
  {$i pu_manualtelescope.lrs}

end.
