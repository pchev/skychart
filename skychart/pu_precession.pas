unit pu_precession;
{
Copyright (C) 2023 Patrick Chevalley

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

{$mode ObjFPC}{$H+}

interface

uses u_translation, UScaleDPI,
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, Spin, StdCtrls, ExtCtrls;

type

  { Tf_precession }

  Tf_precession = class(TForm)
    Button1: TButton;
    DrawLabel: TCheckBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    yearstart: TSpinEdit;
    yearend: TSpinEdit;
    labelstep: TSpinEdit;
    procedure Button1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    FonChange: TNotifyEvent;
    Fdraw: boolean;
  public
    property Draw: boolean read Fdraw;
    property onChange: TNotifyEvent read FonChange write FonChange;
    procedure SetLang;
  end;

var
  f_precession: Tf_precession;

implementation

{$R *.lfm}

{ Tf_precession }

procedure Tf_precession.FormCreate(Sender: TObject);
begin
  ScaleDPI(Self);
  SetLang;
end;

procedure Tf_precession.SetLang;
begin
  Caption := rsPolePrecessi;
  Label1.Caption := rsDrawThePosit;
  Label2.Caption := rsFrom;
  Label3.Caption := rsTo;
  DrawLabel.Caption := rsLabelEvery;
  Button1.Caption := rsApply;
end;

procedure Tf_precession.FormShow(Sender: TObject);
begin
  Fdraw:=true;
end;

procedure Tf_precession.Button1Click(Sender: TObject);
begin
  Fdraw:=true;
  if Assigned(FonChange) then FonChange(self);
end;

procedure Tf_precession.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  Fdraw:=false;
  if Assigned(FonChange) then FonChange(self);
  CloseAction:=caHide;
end;



end.

