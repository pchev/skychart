unit pu_position;

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
{
 Display and set the chart  center position.
}

interface

uses
  u_help, u_translation, u_constant, u_projection, u_util,
  LCLIntf, SysUtils, Classes, Graphics, Controls, Forms, UScaleDPI,
  Dialogs, StdCtrls, cu_radec, enhedits, ExtCtrls, LResources, Buttons;

type

  { Tf_position }

  Tf_position = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Panel1: TPanel;
    coord1: TLabel;
    coord2: TLabel;
    long: TRaDec;
    lat: TRaDec;
    coord: TLabel;
    Panel2: TPanel;
    eq1: TLabel;
    eq2: TLabel;
    Equinox: TLabel;
    Panel3: TPanel;
    Label3: TLabel;
    Label4: TLabel;
    Fov: TRaDec;
    ra: TRaDec;
    de: TRaDec;
    rot: TFloatEdit;
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure EqChange(Sender: TObject);
    procedure CoordChange(Sender: TObject);
  private
    { Private declarations }
    lock: boolean;
    FApply: TNotifyEvent;
  public
    { Public declarations }
    AzNorth: boolean;
    cfgsc: Tconf_skychart;
    procedure SetLang;
    property onApply: TNotifyEvent read FApply write FApply;
  end;

var
  f_position: Tf_position;

implementation

{$R *.lfm}

procedure Tf_position.SetLang;
begin
  Caption := rsPosition;
  Button1.Caption := rsOK;
  Button2.Caption := rsCancel;
  Button3.Caption := rsHelp;
  Button4.Caption := rsApply;
  coord1.Caption := rsAz;
  coord2.Caption := rsAlt;
  eq1.Caption := rsRA;
  eq2.Caption := rsDE;
  Label3.Caption := rsFOV;
  Label4.Caption := rsRotation;
  SetHelp(self, hlpPosition);
end;

procedure Tf_position.FormShow(Sender: TObject);
begin
  ra.Value := rad2deg * cfgsc.racentre / 15;
  de.Value := rad2deg * cfgsc.decentre;
  fov.Value := rad2deg * cfgsc.fov;
  rot.Value := rad2deg * cfgsc.theta;
  Equinox.Caption := Format(rsEquatorialCo2, [cfgsc.EquinoxName]);
  case cfgsc.projpole of
    Equat:
    begin
      Panel1.Visible := False;
    end;
    AltAz:
    begin
      Panel1.Visible := True;
      coord.Caption := rsAltAZCoord;
      coord1.Caption := rsAz;
      coord2.Caption := rsAlt;
    end;
    Gal:
    begin
      Panel1.Visible := True;
      coord.Caption := rsGalacticCoor2;
      coord1.Caption := rsLII;
      coord2.Caption := rsBII;
    end;
    Ecl:
    begin
      Panel1.Visible := True;
      coord.Caption := rsEclipticCoor3;
      coord1.Caption := rsL;
      coord2.Caption := rsB;
    end;
    else
      Panel1.Visible := False;
  end;
  EqChange(self);
end;

procedure Tf_position.FormCreate(Sender: TObject);
begin
  ScaleDPI(Self);
  SetLang;
end;

procedure Tf_position.Button3Click(Sender: TObject);
begin
  ShowHelp;
end;

procedure Tf_position.Button4Click(Sender: TObject);
begin
  if Assigned(FApply) then
    FApply(self);
end;

procedure Tf_position.EqChange(Sender: TObject);
var
  a, h: double;
begin
  if lock then
    exit;

  lock := True;

  case cfgsc.projpole of
    Equat:
      begin
        a := ra.Value * deg2rad;
        h := de.Value * deg2rad;
      end;

    AltAz:
      begin
        eq2hz(cfgsc.CurST - deg2rad * 15 * ra.Value, deg2rad * de.Value, a, h, cfgsc);
        if AzNorth then
          a := Rmod(a + pi, pi2);
      end;

    Gal: eq2gal(deg2rad * 15 * ra.Value, deg2rad * de.Value, a, h, cfgsc);
    Ecl: eq2ecl(deg2rad * 15 * ra.Value, deg2rad * de.Value, cfgsc.ecl, a, h);
  end;
  long.Value := rad2deg * rmod(a + pi2, pi2);
  lat.Value := h * rad2deg;
  application.ProcessMessages;
  lock := False;
end;

procedure Tf_position.CoordChange(Sender: TObject);
var
  a, r, d: double;
begin
  if lock then
    exit;

  lock := True;

  case cfgsc.projpole of
    AltAz:
      begin
        a := deg2rad * long.Value;
        if AzNorth then
          a := rmod(a + pi, pi2);
        Hz2Eq(a, deg2rad * lat.Value, r, d, cfgsc);
        r := cfgsc.CurST - r;
      end;

    Gal: Gal2Eq(deg2rad * long.Value, deg2rad * lat.Value, r, d, cfgsc);
    Ecl: Ecl2Eq(deg2rad * long.Value, deg2rad * lat.Value, cfgsc.ecl, r, d);

  end;
  ra.Value := rmod(r + pi2, pi2) * rad2deg / 15;
  de.Value := rad2deg * d;
  application.ProcessMessages;
  lock := False;
end;

end.
