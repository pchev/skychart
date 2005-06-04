unit fr_config_observatory;
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

uses  u_constant, u_util, Math,
  SysUtils, Types, Classes, Variants, QTypes, QGraphics, QControls, QForms, 
  QDialogs, QButtons, QStdCtrls, cu_zoomimage, QExtCtrls, enhedits,
  QComCtrls;

type
  Tf_config_observatory = class(TFrame)
    pa_observatory: TPageControl;
    t_observatory: TTabSheet;
    Latitude: TGroupBox;
    Label58: TLabel;
    Label59: TLabel;
    Label60: TLabel;
    hemis: TComboBox;
    latdeg: TLongEdit;
    latmin: TLongEdit;
    latsec: TLongEdit;
    Longitude: TGroupBox;
    Label61: TLabel;
    Label62: TLabel;
    Label63: TLabel;
    long: TComboBox;
    longdeg: TLongEdit;
    longmin: TLongEdit;
    longsec: TLongEdit;
    Altitude: TGroupBox;
    Label70: TLabel;
    altmeter: TFloatEdit;
    timezone: TGroupBox;
    Label81: TLabel;
    timez: TFloatEdit;
    obsname: TGroupBox;
    dbreado: TPanel;
    citylist: TComboBox;
    citysearch: TButton;
    countrylist: TComboBox;
    cityfilter: TEdit;
    newcity: TButton;
    updcity: TButton;
    delcity: TButton;
    refraction: TGroupBox;
    Label82: TLabel;
    pressure: TFloatEdit;
    Label83: TLabel;
    temperature: TFloatEdit;
    Obszp: TButton;
    Obszm: TButton;
    Obsmap: TButton;
    ZoomImage1: TZoomImage;
    HScrollBar: TScrollBar;
    VScrollBar: TScrollBar;
    t_horizon: TTabSheet;
    horizonopaque: TCheckBox;
    hor_l1: TLabel;
    horizonfile: TEdit;
    horizonfileBtn: TBitBtn;
    hor_l2: TLabel;
    OpenDialog1: TOpenDialog;
    procedure countrylistClick(Sender: TObject);
    procedure citysearchClick(Sender: TObject);
    procedure citylistChange(Sender: TObject);
    procedure citylistClick(Sender: TObject);
    procedure newcityClick(Sender: TObject);
    procedure updcityClick(Sender: TObject);
    procedure delcityClick(Sender: TObject);
    procedure latdegChange(Sender: TObject);
    procedure longdegChange(Sender: TObject);
    procedure altmeterChange(Sender: TObject);
    procedure pressureChange(Sender: TObject);
    procedure temperatureChange(Sender: TObject);
    procedure timezChange(Sender: TObject);
    procedure ZoomImage1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ZoomImage1Paint(Sender: TObject);
    procedure ZoomImage1PosChange(Sender: TObject);
    procedure ObszpClick(Sender: TObject);
    procedure ObszmClick(Sender: TObject);
    procedure ObsmapClick(Sender: TObject);
    procedure horizonopaqueClick(Sender: TObject);
    procedure horizonfileChange(Sender: TObject);
    procedure horizonfileBtnClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure HScrollBarChange(Sender: TObject);
    procedure VScrollBarChange(Sender: TObject);

  private
    { Private declarations }
    scrolllock,obslock:boolean;
//    EarthMapZoom: double;
    Obsposx,Obsposy : integer;
    scrollw, scrollh : integer;
    ObsMapFile:string;
    procedure UpdCityList(changecity:boolean);
    Procedure SetScrollBar;
    Procedure SetObsPos;
    Procedure ShowObsCoord;
    procedure CenterObs;
    procedure ShowHorizon;
    procedure ShowObservatory;
  public
    { Public declarations }
    mycsc : conf_skychart;
    myccat : conf_catalog;
    mycshr : conf_shared;
    mycplot : conf_plot;
    mycmain : conf_main;
    csc : ^conf_skychart;
    ccat : ^conf_catalog;
    cshr : ^conf_shared;
    cplot : ^conf_plot;
    cmain : ^conf_main;
    constructor Create(AOwner:TComponent); override;
  end;

var
  f_config_observatory: Tf_config_observatory;

implementation

{$R *.xfm}

// include all cross-platform common code.
// you can temporarily copy the file content here
// to use the IDE facilities

{$include i_config_observatory.pas}

// end of common code


end.
