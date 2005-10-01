unit pr_config_chart;
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

uses u_constant, u_projection, u_util,
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Mask, StdCtrls, ExtCtrls, enhedits, ComCtrls;

type
  Tf_config_chart = class(TFrame)
    pa_chart: TPageControl;
    t_chart: TTabSheet;
    Label31: TLabel;
    Panel1: TPanel;
    Label68: TLabel;
    Label113: TLabel;
    PMBox: TCheckBox;
    DrawPmBox: TCheckBox;
    lDrawPMy: TLongEdit;
    Panel10: TPanel;
    Label151: TLabel;
    EquinoxLabel: TLabel;
    equinoxtype: TRadioGroup;
    equinox2: TFloatEdit;
    projectiontype: TRadioGroup;
    ApparentType: TRadioGroup;
    t_fov: TTabSheet;
    Label30: TLabel;
    Bevel1: TBevel;
    Bevel2: TBevel;
    Label96: TLabel;
    Label97: TLabel;
    Label98: TLabel;
    Label99: TLabel;
    Label100: TLabel;
    Label101: TLabel;
    Label102: TLabel;
    Label103: TLabel;
    Label104: TLabel;
    Label105: TLabel;
    Label106: TLabel;
    Label107: TLabel;
    Label114: TLabel;
    Label57: TLabel;
    Label73: TLabel;
    Label74: TLabel;
    fw1: TFloatEdit;
    fw2: TFloatEdit;
    fw3: TFloatEdit;
    fw4: TFloatEdit;
    fw5: TFloatEdit;
    fw6: TFloatEdit;
    fw7: TFloatEdit;
    fw8: TFloatEdit;
    fw9: TFloatEdit;
    fw10: TFloatEdit;
    fw0: TFloatEdit;
    fw00: TFloatEdit;
    fw4b: TFloatEdit;
    fw5b: TFloatEdit;
    t_projection: TTabSheet;
    Bevel8: TBevel;
    Bevel7: TBevel;
    Label158: TLabel;
    Labelp1: TLabel;
    Labelp2: TLabel;
    Labelp3: TLabel;
    Labelp4: TLabel;
    Label165: TLabel;
    Labelp0: TLabel;
    Labelp5: TLabel;
    Labelp6: TLabel;
    Labelp7: TLabel;
    Labelp8: TLabel;
    Labelp9: TLabel;
    Labelp10: TLabel;
    Label171: TLabel;
    Label172: TLabel;
    Label173: TLabel;
    ComboBox2: TComboBox;
    ComboBox1: TComboBox;
    ComboBox3: TComboBox;
    ComboBox4: TComboBox;
    ComboBox5: TComboBox;
    ComboBox6: TComboBox;
    ComboBox7: TComboBox;
    ComboBox8: TComboBox;
    ComboBox9: TComboBox;
    ComboBox10: TComboBox;
    ComboBox11: TComboBox;
    t_filter: TTabSheet;
    Label29: TLabel;
    GroupBox2: TGroupBox;
    StarBox: TCheckBox;
    Panel4: TPanel;
    Panel2: TPanel;
    Label32: TLabel;
    Label33: TLabel;
    Label34: TLabel;
    Label35: TLabel;
    Label36: TLabel;
    Label38: TLabel;
    Label39: TLabel;
    Label40: TLabel;
    Label76: TLabel;
    Label78: TLabel;
    Label108: TLabel;
    Label109: TLabel;
    fsmag0: TFloatEdit;
    fsmag1: TFloatEdit;
    fsmag2: TFloatEdit;
    fsmag3: TFloatEdit;
    fsmag4: TFloatEdit;
    fsmag5: TFloatEdit;
    fsmag6: TFloatEdit;
    fsmag7: TFloatEdit;
    fsmag8: TFloatEdit;
    fsmag9: TFloatEdit;
    Panel3: TPanel;
    Label110: TLabel;
    fsmagvis: TFloatEdit;
    StarAutoBox: TCheckBox;
    GroupBox1: TGroupBox;
    BigNebUnit: TLabel;
    NebBox: TCheckBox;
    BigNebBox: TCheckBox;
    Panel5: TPanel;
    Label48: TLabel;
    Label49: TLabel;
    Label41: TLabel;
    Label42: TLabel;
    Label43: TLabel;
    Label44: TLabel;
    Label45: TLabel;
    Label46: TLabel;
    Label47: TLabel;
    Label79: TLabel;
    Label80: TLabel;
    Label111: TLabel;
    Label112: TLabel;
    fmag0: TFloatEdit;
    fmag1: TFloatEdit;
    fmag2: TFloatEdit;
    fmag3: TFloatEdit;
    fmag4: TFloatEdit;
    fmag5: TFloatEdit;
    fmag6: TFloatEdit;
    fdim0: TFloatEdit;
    fdim1: TFloatEdit;
    fdim2: TFloatEdit;
    fdim3: TFloatEdit;
    fdim4: TFloatEdit;
    fdim5: TFloatEdit;
    fdim6: TFloatEdit;
    fmag7: TFloatEdit;
    fmag8: TFloatEdit;
    fmag9: TFloatEdit;
    fdim7: TFloatEdit;
    fdim8: TFloatEdit;
    fdim9: TFloatEdit;
    fBigNebLimit: TLongEdit;
    t_grid: TTabSheet;
    Bevel9: TBevel;
    Label159: TLabel;
    Label160: TLabel;
    Label176: TLabel;
    Label175: TLabel;
    Label161: TLabel;
    Label162: TLabel;
    Label163: TLabel;
    Label164: TLabel;
    Label166: TLabel;
    Label167: TLabel;
    Label168: TLabel;
    Label169: TLabel;
    Label170: TLabel;
    Label174: TLabel;
    Label177: TLabel;
    MaskEdit1: TMaskEdit;
    MaskEdit2: TMaskEdit;
    MaskEdit3: TMaskEdit;
    MaskEdit4: TMaskEdit;
    MaskEdit5: TMaskEdit;
    MaskEdit6: TMaskEdit;
    MaskEdit7: TMaskEdit;
    MaskEdit8: TMaskEdit;
    MaskEdit9: TMaskEdit;
    MaskEdit10: TMaskEdit;
    MaskEdit11: TMaskEdit;
    MaskEdit12: TMaskEdit;
    MaskEdit13: TMaskEdit;
    MaskEdit14: TMaskEdit;
    MaskEdit15: TMaskEdit;
    MaskEdit16: TMaskEdit;
    MaskEdit17: TMaskEdit;
    MaskEdit18: TMaskEdit;
    MaskEdit19: TMaskEdit;
    MaskEdit20: TMaskEdit;
    MaskEdit21: TMaskEdit;
    MaskEdit22: TMaskEdit;
    t_objlist: TTabSheet;
    Label95: TLabel;
    GroupBox5: TGroupBox;
    liststar: TCheckBox;
    listneb: TCheckBox;
    listpla: TCheckBox;
    listvar: TCheckBox;
    listdbl: TCheckBox;
    equinox1: TComboBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    procedure equinoxtypeClick(Sender: TObject);
    procedure equinox1Change(Sender: TObject);
    procedure PMBoxClick(Sender: TObject);
    procedure DrawPmBoxClick(Sender: TObject);
    procedure lDrawPMyChange(Sender: TObject);
    procedure ApparentTypeClick(Sender: TObject);
    procedure projectiontypeClick(Sender: TObject);
    procedure FWChange(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ProjectionChange(Sender: TObject);
    procedure StarBoxClick(Sender: TObject);
    procedure StarAutoBoxClick(Sender: TObject);
    procedure fsmagvisChange(Sender: TObject);
    procedure fsmagChange(Sender: TObject);
    procedure NebBoxClick(Sender: TObject);
    procedure BigNebBoxClick(Sender: TObject);
    procedure fBigNebLimitChange(Sender: TObject);
    procedure fmagChange(Sender: TObject);
    procedure fdimChange(Sender: TObject);
    procedure DegSpacingChange(Sender: TObject);
    procedure HourSpacingChange(Sender: TObject);
    procedure liststarClick(Sender: TObject);
    procedure listnebClick(Sender: TObject);
    procedure listplaClick(Sender: TObject);
    procedure listvarClick(Sender: TObject);
    procedure listdblClick(Sender: TObject);
    procedure equinox2Change(Sender: TObject);
  private
    { Private declarations }
    procedure ShowChart;
    procedure ShowField;
    procedure ShowProjection;
    procedure ShowFilter;
    procedure ShowGridSpacing;
    procedure ShowObjList;
    procedure SetEquinox;
    procedure SetFieldHint(var lab:Tlabel; n:integer);
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
  
implementation

{$R *.dfm}

// include all cross-platform common code.
// you can temporarily copy the file content here
// to use the IDE facilities

{$include i_config_chart.pas}

// end of common code


end.
