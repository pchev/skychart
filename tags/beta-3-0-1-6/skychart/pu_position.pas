unit pu_position;

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
{
 Display and set the chart  center position.
}

interface

uses  u_help, u_translation, u_constant, u_projection, u_util,
  LCLIntf, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, cu_radec, enhedits, ExtCtrls, LResources, Buttons,
  LazHelpHTML;

type

  { Tf_position }

  Tf_position = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    HTMLBrowserHelpViewer1: THTMLBrowserHelpViewer;
    HTMLHelpDatabase1: THTMLHelpDatabase;
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
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure EqChange(Sender: TObject);
    procedure CoordChange(Sender: TObject);
  private
    { Private declarations }
    lock: boolean;
  public
    { Public declarations }
    AzNorth: boolean;
    cfgsc: Tconf_skychart;
    procedure SetLang;
  end;

var
  f_position: Tf_position;

implementation

procedure Tf_position.SetLang;
begin
Caption:=rsPosition;
Button1.caption:=rsOK;
Button2.caption:=rsCancel;
Button3.caption:=rsHelp;
coord1.caption:=rsAz;
coord2.caption:=rsAlt;
eq1.caption:=rsRA;
eq2.caption:=rsDE;
Label3.caption:=rsFOV;
Label4.caption:=rsRotation;
SetHelpDB(HTMLHelpDatabase1);
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
SetLang;
{$ifdef win32}
 ScaleForm(self,Screen.PixelsPerInch/96);
{$endif}
end;

procedure Tf_position.Button3Click(Sender: TObject);
begin
  ShowHelp;
end;

procedure Tf_position.EqChange(Sender: TObject);
var a,h: double;
begin
if lock then exit;
lock:=true;
case cfgsc.projpole of
  AltAz : begin
          eq2hz(cfgsc.CurST-deg2rad*15*ra.value,deg2rad*de.value,a,h,cfgsc);
          if AzNorth then a:=Rmod(a+pi,pi2);
          end;
  Gal   : begin
          eq2gal(deg2rad*15*ra.value,deg2rad*de.value,a,h,cfgsc);
          end;
  Ecl   : begin
          eq2ecl(deg2rad*15*ra.value,deg2rad*de.value,cfgsc.e,a,h);
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
          Ecl2Eq(deg2rad*long.value,deg2rad*lat.value,cfgsc.e,r,d);
          end;
end;
ra.value:=rmod(r+pi2,pi2)*rad2deg/15;
de.value:=rad2deg*d;
application.ProcessMessages;
lock:=false;
end;

initialization
  {$i pu_position.lrs}

end.