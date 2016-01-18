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

uses  u_help, u_translation, u_constant, u_projection, u_util,
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
Caption:=rsPosition;
Button1.caption:=rsOK;
Button2.caption:=rsCancel;
Button3.caption:=rsHelp;
Button4.caption:=rsApply;
coord1.caption:=rsAz;
coord2.caption:=rsAlt;
eq1.caption:=rsRA;
eq2.caption:=rsDE;
Label3.caption:=rsFOV;
Label4.caption:=rsRotation;
SetHelp(self,hlpPosition);
end;

procedure Tf_position.FormShow(Sender: TObject);
begin
ra.value:=rad2deg*cfgsc.racentre/15;
de.value:=rad2deg*cfgsc.decentre;
fov.value:=rad2deg*cfgsc.fov;
rot.value:=rad2deg*cfgsc.theta;
Equinox.Caption:=Format(rsEquatorialCo2, [cfgsc.EquinoxName]);
case cfgsc.projpole of
    Equat : begin
            Panel1.visible:=false;
            end;
    AltAz : begin
            Panel1.visible:=true;
            coord.Caption:=rsAltAZCoord;
            coord1.caption:=rsAz;
            coord2.caption:=rsAlt;
            end;
    Gal :   begin
            Panel1.visible:=true;
            coord.Caption:=rsGalacticCoor2;
            coord1.caption:=rsLII;
            coord2.caption:=rsBII;
            end;
    Ecl :   begin
            Panel1.visible:=true;
            coord.Caption:=rsEclipticCoor3;
            coord1.caption:=rsL;
            coord2.caption:=rsB;
            end;
  else Panel1.visible:=false;
end;
EqChange(self);
end;

procedure Tf_position.FormCreate(Sender: TObject);
begin
ScaleDPI(Self,96);
SetLang;
end;

procedure Tf_position.Button3Click(Sender: TObject);
begin
  ShowHelp;
end;

procedure Tf_position.Button4Click(Sender: TObject);
begin
  if Assigned(FApply) then FApply(self);
end;

procedure Tf_position.EqChange(Sender: TObject);
var a,h: double;
begin
if lock then exit;
lock:=true;
case cfgsc.projpole of
  Equat : begin
          a:=ra.value*deg2rad;
          h:=de.value*deg2rad;
          end;
  AltAz : begin
          eq2hz(cfgsc.CurST-deg2rad*15*ra.value,deg2rad*de.value,a,h,cfgsc);
          if AzNorth then a:=Rmod(a+pi,pi2);
          end;
  Gal   : begin
          eq2gal(deg2rad*15*ra.value,deg2rad*de.value,a,h,cfgsc);
          end;
  Ecl   : begin
          eq2ecl(deg2rad*15*ra.value,deg2rad*de.value,cfgsc.ecl,a,h);
          end;
end;
long.value:=rad2deg*rmod(a+pi2,pi2);
lat.value:=h*rad2deg;
application.ProcessMessages;
lock:=false;
end;

procedure Tf_position.CoordChange(Sender: TObject);
var a,r,d: double;
begin
if lock then exit;
lock:=true;
case cfgsc.projpole of
  AltAz : begin
          a:=deg2rad*long.value;
          if AzNorth then a:=rmod(a+pi,pi2);
          Hz2Eq(a,deg2rad*lat.value,r,d,cfgsc);
          r:=cfgsc.CurST-r;
          end;
  Gal   : begin
          Gal2Eq(deg2rad*long.value,deg2rad*lat.value,r,d,cfgsc);
          end;
  Ecl   : begin
          Ecl2Eq(deg2rad*long.value,deg2rad*lat.value,cfgsc.ecl,r,d);
          end;
end;
ra.value:=rmod(r+pi2,pi2)*rad2deg/15;
de.value:=rad2deg*d;
application.ProcessMessages;
lock:=false;
end;

end.
