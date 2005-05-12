unit fr_config_time;
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

uses  u_constant, u_util,
  SysUtils, Types, Classes, Variants, QTypes, QGraphics, QControls, QForms, 
  QDialogs, QStdCtrls, QCheckLst, QButtons, QComCtrls, QExtCtrls, enhedits;

type
  Tf_config_time = class(TFrame)
    pa_time: TPageControl;
    t_time: TTabSheet;
    Label50: TLabel;
    Label72: TLabel;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    Panel7: TPanel;
    Label131: TLabel;
    Label132: TLabel;
    Label133: TLabel;
    tz: TFloatEdit;
    Panel12: TPanel;
    Label146: TLabel;
    Tdt_Ut: TLabel;
    Label152: TLabel;
    Label153: TLabel;
    CheckBox4: TCheckBox;
    dt_ut: TLongEdit;
    LongEdit2: TLongEdit;
    Panel9: TPanel;
    Label154: TLabel;
    Label158: TLabel;
    Label159: TLabel;
    Label160: TLabel;
    Label161: TLabel;
    Label162: TLabel;
    Label163: TLabel;
    Label164: TLabel;
    BitBtn4: TBitBtn;
    ADBC: TRadioGroup;
    d_year: TSpinEdit;
    d_month: TSpinEdit;
    d_day: TSpinEdit;
    t_hour: TSpinEdit;
    t_min: TSpinEdit;
    t_sec: TSpinEdit;
    t_simulation: TTabSheet;
    stepreset: TSpeedButton;
    Label165: TLabel;
    Label167: TLabel;
    Label168: TLabel;
    stepunit: TRadioGroup;
    stepline: TCheckBox;
    Label166: TLabel;
    nbstep: TSpinEdit;
    stepsize: TSpinEdit;
    SimObj: TCheckListBox;
    Label178: TLabel;
    AllSim: TButton;
    NoSim: TButton;
    procedure CheckBox1Click(Sender: TObject);
    procedure CheckBox2Click(Sender: TObject);
    procedure LongEdit2Change(Sender: TObject);
    procedure DateChange(Sender: TObject; NewValue: Integer);
    procedure DateChange2(Sender: TObject);
    procedure TimeChange(Sender: TObject; NewValue: Integer);
    procedure BitBtn4Click(Sender: TObject);
    procedure tzChange(Sender: TObject);
    procedure CheckBox4Click(Sender: TObject);
    procedure dt_utChange(Sender: TObject);
    procedure SimObjClickCheck(Sender: TObject);
    procedure nbstepChanged(Sender: TObject; NewValue: Integer);
    procedure stepsizeChanged(Sender: TObject; NewValue: Integer);
    procedure stepunitClick(Sender: TObject);
    procedure stepresetClick(Sender: TObject);
    procedure steplineClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure AllSimClick(Sender: TObject);
    procedure NoSimClick(Sender: TObject);
  private
    { Private declarations }
    procedure ShowTime;
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
  f_config_time: Tf_config_time;


implementation

{$R *.xfm}

// include all cross-platform common code.
// you can temporarily copy the file content here
// to use the IDE facilities

{$include i_config_time.pas}

// end of common code

end.

