unit fu_search;
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
 Search dialog for different object type.
}

interface

uses u_constant, u_util,
  SysUtils, Classes, Variants, QGraphics, QControls, QForms,
  QDialogs, QStdCtrls, QExtCtrls, QButtons;

type
  Tf_search = class(TForm)
    RadioGroup1: TRadioGroup;
    IDPanel: TPanel;
    Button1: TButton;
    Button2: TButton;
    Id: TEdit;
    NumPanel: TPanel;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    SpeedButton4: TSpeedButton;
    SpeedButton5: TSpeedButton;
    SpeedButton6: TSpeedButton;
    SpeedButton7: TSpeedButton;
    SpeedButton8: TSpeedButton;
    SpeedButton9: TSpeedButton;
    SpeedButton10: TSpeedButton;
    SpeedButton11: TSpeedButton;
    SpeedButton12: TSpeedButton;
    SpeedButton13: TSpeedButton;
    Label1: TLabel;
    NebPanel: TPanel;
    SpeedButton14: TSpeedButton;
    SpeedButton15: TSpeedButton;
    SpeedButton16: TSpeedButton;
    SpeedButton17: TSpeedButton;
    SpeedButton18: TSpeedButton;
    StarPanel: TPanel;
    SpeedButton19: TSpeedButton;
    SpeedButton20: TSpeedButton;
    SpeedButton22: TSpeedButton;
    SpeedButton23: TSpeedButton;
    VarPanel: TPanel;
    SpeedButton21: TSpeedButton;
    SpeedButton24: TSpeedButton;
    SpeedButton25: TSpeedButton;
    SpeedButton26: TSpeedButton;
    SpeedButton27: TSpeedButton;
    SpeedButton28: TSpeedButton;
    SpeedButton29: TSpeedButton;
    DblPanel: TPanel;
    SpeedButton30: TSpeedButton;
    SpeedButton31: TSpeedButton;
    PlanetPanel: TPanel;
    PlanetBox: TComboBox;
    Label2: TLabel;
    NebNamePanel: TPanel;
    Label3: TLabel;
    NebNameBox: TComboBox;
    StarNamePanel: TPanel;
    Label4: TLabel;
    StarNameBox: TComboBox;
    ConstPanel: TPanel;
    Label5: TLabel;
    ConstBox: TComboBox;
    procedure NumButtonClick(Sender: TObject);
    procedure SpeedButton11Click(Sender: TObject);
    procedure SpeedButton13Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure CatButtonClick(Sender: TObject);
    procedure IdKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure RadioGroup1Click(Sender: TObject);
    procedure Init;
    procedure InitPlanet;
    procedure InitConst;
    procedure InitStarName;
    procedure InitNebName;
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    NebNameAR : array of single;
    NebNameDE : array of single;
    numNebName : integer;
  public
    { Public declarations }
    Num : string;
    ra,de: double;
    SearchKind : integer;
    cfgshr: conf_shared;
  end;

var
  f_search: Tf_search;

implementation

{$R *.xfm}

{$include i_search.pas}


end.
