unit fu_position;
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

uses u_constant, u_projection, u_util,
  SysUtils, Classes, Variants, QGraphics, QControls, QForms,
  QDialogs, QStdCtrls, QExtCtrls, QButtons, QMask, cu_radec, enhedits;

type
  Tf_position = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Panel1: TPanel;
    coord1: TLabel;
    coord2: TLabel;
    long: TRaDec;
    lat: TRaDec;
    coord: TLabel;
    Panel2: TPanel;
    eq1: TLabel;
    eq2: TLabel;
    Ra: TRaDec;
    De: TRaDec;
    Equinox: TLabel;
    Panel3: TPanel;
    Label3: TLabel;
    Label4: TLabel;
    Fov: TRaDec;
    rot: TFloatEdit;
    procedure FormShow(Sender: TObject);
    procedure EqChange(Sender: TObject);
    procedure CoordChange(Sender: TObject);
  private
    { Private declarations }
    lock: boolean;
  public
    { Public declarations }
    AzNorth: boolean;
    cfgsc: conf_skychart;
  end;

var
  f_position: Tf_position;

implementation

{$R *.xfm}

{$include i_position.pas}

end.
