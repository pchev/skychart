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
    InputEquinox: TComboBox;
    LockPosition: TCheckBox;
    PanelCoord: TPanel;
    coord1: TLabel;
    coord2: TLabel;
    long: TRaDec;
    lat: TRaDec;
    coord: TLabel;
    PanelEq: TPanel;
    eq1: TLabel;
    eq2: TLabel;
    LblEquinox: TLabel;
    PanelFOV: TPanel;
    Label3: TLabel;
    Label4: TLabel;
    Fov: TRaDec;
    PanelLock: TPanel;
    Panel5: TPanel;
    ra: TRaDec;
    de: TRaDec;
    rot: TFloatEdit;
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure EqChange(Sender: TObject);
    procedure CoordChange(Sender: TObject);
    procedure InputEquinoxChange(Sender: TObject);
    procedure GetRaDec(out r,d: double);
  private
    { Private declarations }
    lock: boolean;
    FApply: TNotifyEvent;
    CurrentEquinox: double;
    Equinox: array [0..2] of double;
    procedure ChartToCurrent(var r,d: double);
    procedure CurrentToChart(var r,d: double);
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
  LockPosition.Caption := rsLockTheChart;
  SetHelp(self, hlpPosition);
end;

procedure Tf_position.FormShow(Sender: TObject);
var x: double;
begin
  ra.Value := rad2deg * cfgsc.racentre / 15;
  de.Value := rad2deg * cfgsc.decentre;
  fov.Value := rad2deg * cfgsc.fov;
  rot.Value := rad2deg * cfgsc.theta;
  LblEquinox.Caption := format(rsEquatorialCo2,['']);
  InputEquinox.Visible:=true;
  InputEquinox.Clear;
  InputEquinox.Items.Add(rsDate);
  InputEquinox.Items.Add('J2000');
  Equinox[0]:=cfgsc.JDChart;
  Equinox[1]:=jd2000;
  if cfgsc.EquinoxName = rsDate then begin
    InputEquinox.ItemIndex:=0;
    CurrentEquinox:=cfgsc.JDChart;
  end
  else if cfgsc.EquinoxName = 'J2000' then begin
    InputEquinox.ItemIndex:=1;
    CurrentEquinox:=jd2000;
  end
  else begin
    x:=StrToFloatDef(cfgsc.EquinoxName,-1);
    if x>0 then begin
      InputEquinox.Items.Add(cfgsc.EquinoxName);
      InputEquinox.ItemIndex:=2;
      CurrentEquinox:=jd(trunc(x),1,1,0)+frac(x)*365.25;
      Equinox[2]:=CurrentEquinox;
    end
    else begin
      InputEquinox.Visible:=false;
      LblEquinox.Caption := format(rsEquatorialCo2,[cfgsc.EquinoxName]);
    end;
  end;
  case cfgsc.projpole of
    Equat:
    begin
      PanelCoord.Visible := False;
    end;
    AltAz:
    begin
      PanelCoord.Visible := True;
      coord.Caption := rsAltAZCoord;
      coord1.Caption := rsAz;
      coord2.Caption := rsAlt;
    end;
    Gal:
    begin
      PanelCoord.Visible := True;
      coord.Caption := rsGalacticCoor2;
      coord1.Caption := rsLII;
      coord2.Caption := rsBII;
    end;
    Ecl:
    begin
      PanelCoord.Visible := True;
      coord.Caption := rsEclipticCoor3;
      coord1.Caption := rsL;
      coord2.Caption := rsB;
    end;
    else
      PanelCoord.Visible := False;
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
  r, d, a, h: double;
begin
  if lock then
    exit;

  try
  lock := True;

  r := ra.Value * 15 * deg2rad;
  d := de.Value * deg2rad;
  CurrentToChart(r,d);

  case cfgsc.projpole of
    Equat: exit;
    AltAz:
      begin
        eq2hz(cfgsc.CurST - r, d, a, h, cfgsc,2);
        if AzNorth then
          a := Rmod(a + pi, pi2);
      end;
    Gal: eq2gal(r, d, a, h, cfgsc);
    Ecl: eq2ecl(r, d, cfgsc.ecl, a, h);
  end;
  long.Value := rad2deg * rmod(a + pi2, pi2);
  lat.Value := h * rad2deg;
  application.ProcessMessages;
  finally
    lock := False;
  end;
end;

procedure Tf_position.CoordChange(Sender: TObject);
var
  a, r, d: double;
begin
  if lock then
    exit;

  try
  lock := True;

  case cfgsc.projpole of
    AltAz:
      begin
        a := deg2rad * long.Value;
        if AzNorth then
          a := rmod(a + pi, pi2);
        Hz2Eq(a, deg2rad * lat.Value, r, d, cfgsc,2);
        r := cfgsc.CurST - r;
      end;

    Gal: Gal2Eq(deg2rad * long.Value, deg2rad * lat.Value, r, d, cfgsc);
    Ecl: Ecl2Eq(deg2rad * long.Value, deg2rad * lat.Value, cfgsc.ecl, r, d);

  end;
  ChartToCurrent(r,d);
  ra.Value := rmod(r + pi2, pi2) * rad2deg / 15;
  de.Value := rad2deg * d;
  application.ProcessMessages;
  finally
    lock := False;
  end;
end;

procedure Tf_position.ChartToCurrent(var r,d: double);
begin
  if abs(CurrentEquinox - cfgsc.JDChart) > 0.01 then begin
    if cfgsc.ApparentPos then
      mean_equatorial(r, d, cfgsc, True, True);
    Precession(cfgsc.JDChart,CurrentEquinox,r,d);
  end;
end;

procedure Tf_position.CurrentToChart(var r,d: double);
begin
  if abs(CurrentEquinox - cfgsc.JDChart) > 0.01 then begin
    Precession(CurrentEquinox,cfgsc.JDChart,r,d);
    if cfgsc.ApparentPos then
      apparent_equatorial(r, d, cfgsc, True, True);
  end;
end;

procedure Tf_position.InputEquinoxChange(Sender: TObject);
var xra,xde: double;
begin
  try
  lock:=true;
  xra:=ra.Value*15*deg2rad;
  xde:=de.Value*deg2rad;
  if cfgsc.ApparentPos and (CurrentEquinox=cfgsc.JDChart) then
    mean_equatorial(xra, xde, cfgsc, True, True);
  Precession(CurrentEquinox,Equinox[InputEquinox.ItemIndex],xra,xde);
  if cfgsc.ApparentPos and (CurrentEquinox<>cfgsc.JDChart) then
    apparent_equatorial(xra, xde, cfgsc, True, True);
  CurrentEquinox:=Equinox[InputEquinox.ItemIndex];
  ra.Value:=xra*rad2deg/15;
  de.Value:=xde*rad2deg;
  finally
  lock:=false;
  end;
  EqChange(nil);
end;

procedure Tf_position.GetRaDec(out r,d: double);
begin
  r := ra.Value * 15 * deg2rad;
  d := de.Value * deg2rad;
  CurrentToChart(r,d);
  r := r*rad2deg/15;
  d := d*rad2deg;
end;

end.
