unit pu_config_chart;

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
                            
interface

uses u_translation, u_constant, u_projection, u_util,
  LCLIntf, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, enhedits, ComCtrls, LResources,
  Buttons, cu_radec, cu_zoomimage;

type

  { Tf_config_chart }

  Tf_config_chart = class(TForm)
    ApparentType: TRadioGroup;
    Bevel7: TBevel;
    BigNebBox: TCheckBox;
    BigNebUnit: TLabel;
    Button1: TButton;
    Button2: TButton;
    CheckBox1: TCheckBox;
    CheckBox10: TCheckBox;
    CheckBox13: TCheckBox;
    CheckBox11: TCheckBox;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    CheckBox4: TCheckBox;
    CheckBox5: TCheckBox;
    CheckBox6: TCheckBox;
    CheckBox7: TCheckBox;
    CheckBox8: TCheckBox;
    CheckBox9: TCheckBox;
    ComboBox1: TComboBox;
    ComboBox10: TComboBox;
    ComboBox11: TComboBox;
    ComboBox2: TComboBox;
    ComboBox3: TComboBox;
    ComboBox4: TComboBox;
    ComboBox5: TComboBox;
    ComboBox6: TComboBox;
    ComboBox7: TComboBox;
    ComboBox8: TComboBox;
    ComboBox9: TComboBox;
    DrawPmBox: TCheckBox;
    equinox1: TComboBox;
    equinox2: TFloatEdit;
    EquinoxLabel: TLabel;
    equinoxtype: TRadioGroup;
    fBigNebLimit: TLongEdit;
    fdim0: TFloatEdit;
    fdim1: TFloatEdit;
    fdim2: TFloatEdit;
    fdim3: TFloatEdit;
    fdim4: TFloatEdit;
    fdim5: TFloatEdit;
    fdim6: TFloatEdit;
    fdim7: TFloatEdit;
    fdim8: TFloatEdit;
    fdim9: TFloatEdit;
    fmag0: TFloatEdit;
    fmag1: TFloatEdit;
    fmag2: TFloatEdit;
    fmag3: TFloatEdit;
    fmag4: TFloatEdit;
    fmag5: TFloatEdit;
    fmag6: TFloatEdit;
    fmag7: TFloatEdit;
    fmag8: TFloatEdit;
    fmag9: TFloatEdit;
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
    fsmagvis: TFloatEdit;
    ft0: TFloatEdit;
    ft1: TFloatEdit;
    ft10: TFloatEdit;
    ft2: TFloatEdit;
    ft3: TFloatEdit;
    ft4: TFloatEdit;
    ft5: TFloatEdit;
    ft6: TFloatEdit;
    ft7: TFloatEdit;
    ft8: TFloatEdit;
    ft9: TFloatEdit;
    fw0: TFloatEdit;
    fw00: TFloatEdit;
    fw1: TFloatEdit;
    fw2: TFloatEdit;
    fw3: TFloatEdit;
    fw4: TFloatEdit;
    fw5: TFloatEdit;
    fw6: TFloatEdit;
    fw7: TFloatEdit;
    fw8: TFloatEdit;
    fw9: TFloatEdit;
    fv10: TLabel;
    fv9: TLabel;
    fv8: TLabel;
    fv7: TLabel;
    fv6: TLabel;
    fv5: TLabel;
    fv4: TLabel;
    fv3: TLabel;
    fv2: TLabel;
    fv1: TLabel;
    fv0: TLabel;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    GroupBox5: TGroupBox;
    Label1: TLabel;
    Label101: TLabel;
    Label102: TLabel;
    Label103: TLabel;
    Label104: TLabel;
    Label105: TLabel;
    Label106: TLabel;
    Label107: TLabel;
    Label108: TLabel;
    Label109: TLabel;
    Label110: TLabel;
    Label111: TLabel;
    Label112: TLabel;
    Label113: TLabel;
    Label114: TLabel;
    Label158: TLabel;
    Label159: TLabel;
    Label160: TLabel;
    Label161: TLabel;
    Label162: TLabel;
    Label163: TLabel;
    Label164: TLabel;
    Label165: TLabel;
    Label166: TLabel;
    Label167: TLabel;
    Label168: TLabel;
    Label169: TLabel;
    Label170: TLabel;
    Label172: TLabel;
    Label174: TLabel;
    Label175: TLabel;
    Label176: TLabel;
    Label177: TLabel;
    Label2: TLabel;
    Label29: TLabel;
    Label3: TLabel;
    Label30: TLabel;
    Label31: TLabel;
    Label32: TLabel;
    Label33: TLabel;
    Label34: TLabel;
    Label35: TLabel;
    Label36: TLabel;
    Label38: TLabel;
    Label39: TLabel;
    Label4: TLabel;
    Label40: TLabel;
    Label41: TLabel;
    Label42: TLabel;
    Label43: TLabel;
    Label44: TLabel;
    Label45: TLabel;
    Label46: TLabel;
    Label47: TLabel;
    Label48: TLabel;
    Label49: TLabel;
    Label5: TLabel;
    Label57: TLabel;
    Label68: TLabel;
    Label74: TLabel;
    Label76: TLabel;
    Label78: TLabel;
    Label79: TLabel;
    Label80: TLabel;
    Label95: TLabel;
    Label96: TLabel;
    Label97: TLabel;
    Label98: TLabel;
    Label99: TLabel;
    Labelp0: TLabel;
    Labelp1: TLabel;
    Labelp10: TLabel;
    Labelp2: TLabel;
    Labelp3: TLabel;
    Labelp4: TLabel;
    Labelp5: TLabel;
    Labelp6: TLabel;
    Labelp7: TLabel;
    Labelp8: TLabel;
    Labelp9: TLabel;
    lDrawPMy: TLongEdit;
    listdbl: TCheckBox;
    listneb: TCheckBox;
    listpla: TCheckBox;
    liststar: TCheckBox;
    listvar: TCheckBox;
    MainPanel: TPanel;
    NebBox: TCheckBox;
    Page1: TPage;
    Page2: TPage;
    Page3: TPage;
    Page4: TPage;
    Page5: TPage;
    Page6: TPage;
    Panel1: TPanel;
    Panel10: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    Panel5: TPanel;
    FOVPanel: TPanel;
    PMBox: TCheckBox;
    projectiontype: TRadioGroup;
    RaDec1: TRaDec;
    RaDec10: TRaDec;
    RaDec11: TRaDec;
    RaDec12: TRaDec;
    RaDec13: TRaDec;
    RaDec14: TRaDec;
    RaDec15: TRaDec;
    RaDec16: TRaDec;
    RaDec17: TRaDec;
    RaDec18: TRaDec;
    RaDec19: TRaDec;
    RaDec2: TRaDec;
    RaDec20: TRaDec;
    RaDec21: TRaDec;
    RaDec22: TRaDec;
    RaDec3: TRaDec;
    RaDec4: TRaDec;
    RaDec5: TRaDec;
    RaDec6: TRaDec;
    RaDec7: TRaDec;
    RaDec8: TRaDec;
    RaDec9: TRaDec;
    StarAutoBox: TCheckBox;
    StarBox: TCheckBox;
    Notebook1: TNotebook;
    TrackBar1: TTrackBar;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure CheckBox13Click(Sender: TObject);
    procedure ShowGridBoxClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormDestroy(Sender: TObject);
    procedure Notebook1PageChanged(Sender: TObject);
    procedure TrackBar1Change(Sender: TObject);
    procedure equinoxtypeClick(Sender: TObject);
    procedure equinox1Change(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure PMBoxClick(Sender: TObject);
    procedure DrawPmBoxClick(Sender: TObject);
    procedure lDrawPMyChange(Sender: TObject);
    procedure ApparentTypeClick(Sender: TObject);
    procedure projectiontypeClick(Sender: TObject);
    procedure FWExit(Sender: TObject);
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
    LockChange: boolean;
    procedure ShowChart;
    procedure ShowField;
    procedure ShowFOV;
    procedure ShowProjection;
    procedure ShowFilter;
    procedure ShowGridSpacing;
    procedure ShowObjList;
    procedure SetEquinox;
    procedure SetFieldHint(var lab:Tlabel; n:integer);
  public
    { Public declarations }
    mycsc : Tconf_skychart;
    myccat : Tconf_catalog;
    mycshr : Tconf_shared;
    mycplot : Tconf_plot;
    mycmain : Tconf_main;
    csc : Tconf_skychart;
    ccat : Tconf_catalog;
    cshr : Tconf_shared;
    cplot : Tconf_plot;
    cmain : Tconf_main;
    procedure SetLang;
   constructor Create(AOwner:TComponent); override;
  end;
  
implementation


procedure Tf_config_chart.SetLang;
begin
Caption:=rsCharts;
Label31.caption:=rsChartSetting;
Label68.caption:=rsYears;
Label113.caption:=rsStarsProperM;
PMBox.caption:=rsUseTheProper;
DrawPmBox.caption:=rsDrawALineTha;
EquinoxLabel.caption:=rsEquinox;
Label1.caption:=rsEquatorialAn;
projectiontype.caption:=rsChartCoordin2;
ApparentType.caption:=rsNutationAber;
Label30.caption:=rsFieldOfVisio3;
Label106.caption:=rsFieldNumber;
Label107.caption:=rsFieldOfVisio;
Label57.caption:=rsFrom;
Label5.caption:=rsTo;
Button1.caption:=rsDefault;
Label158.caption:=rsProjectionSe;
Label165.caption:=rsFieldNumber;
Label172.caption:=rsProjection;
Label29.caption:=rsObjectFilter2;
GroupBox2.caption:=rsStarsFilter;
StarBox.caption:=rsFilterStars;
Label108.caption:=rsFieldOfVisio5;
Label109.caption:=rsLimitingMagn2;
Label110.caption:=rsNakedEyeRefe;
StarAutoBox.caption:=rsAutomatic;
GroupBox1.caption:=rsNebulaeFilte;
BigNebUnit.caption:=rsMinutes;
NebBox.caption:=rsFilterNebula;
BigNebBox.caption:=rsHideObjectWi;
Label48.caption:=rsLimitingMagn2;
Label49.caption:=rsLimitingSize;
Label112.caption:=rsFieldOfVisio5;
Label159.caption:=rsGridSetting;
Label160.caption:=rsFieldNumber;
Label176.caption:=rsDegreeGridSp;
Label175.caption:=rsHourGridSpac;
Label95.caption:=rsObjectListSe;
GroupBox5.caption:=rsTypeOfObject;
liststar.caption:=rsStars;
listneb.caption:=rsNebulae;
listpla.caption:=rsSolarSystemO;
listvar.caption:=rsVariableStar;
listdbl.caption:=rsDoubleStar;
Label2.caption:=rsFovNumber;
equinoxtype.items[0]:=rsStandardEqui;
equinoxtype.items[1]:=rsFixedEquinox;
equinoxtype.items[2]:=rsEquinoxOfThe;
ApparentType.Items[0]:=rsMeanPosition;
ApparentType.Items[1]:=rsTruePosition;
projectiontype.Items[0]:=rsEquatorialCo;
projectiontype.Items[1]:=rsAzimuthalCoo;
projectiontype.Items[2]:=rsGalacticCoor;
projectiontype.Items[3]:=rsEclipticCoor;
Button2.Caption:=rsDefault;
Label3.caption:=rsShowGrid;
Label4.caption:=rsCompassRoseS;
CheckBox13.caption:=rsAlwaysShowCo;
end;

constructor Tf_config_chart.Create(AOwner:TComponent);
begin
 mycsc:=Tconf_skychart.Create;
 myccat:=Tconf_catalog.Create;
 mycshr:=Tconf_shared.Create;
 mycplot:=Tconf_plot.Create;
 mycmain:=Tconf_main.Create;
 csc:=mycsc;
 ccat:=myccat;
 cshr:=mycshr;
 cplot:=mycplot;
 cmain:=mycmain;
 inherited Create(AOwner);
end;

procedure Tf_config_chart.FormShow(Sender: TObject);
begin
LockChange:=true;
ShowChart;
ShowField;
ShowFilter;
ShowProjection;
ShowGridSpacing;
ShowObjList;
LockChange:=false;
end;

procedure Tf_config_chart.ShowChart;
var i : integer;
begin
equinox2.text:=stringreplace(stringreplace(stringreplace(cshr.EquinoxChart,'J','',[]),'B','',[]),rsDate,'2000.0',[]);
equinox1.itemindex:=0;
for i:=0 to equinox1.items.count-1 do
  if equinox1.items[i]=cshr.EquinoxChart then
      equinox1.itemindex:=i;
equinoxtype.itemindex:=cshr.EquinoxType;
PMBox.checked:=csc.PMon;
DrawPMBox.checked:=csc.DrawPMon;
lDrawPMy.value:=csc.DrawPMyear;
if csc.ApparentPos then ApparentType.ItemIndex:=1
                   else Apparenttype.itemindex:=0;
projectiontype.itemindex:=csc.ProjPole;
end;

procedure Tf_config_chart.ShowGridSpacing;
begin
  CheckBox13.Checked:=cshr.ShowCRose;
  TrackBar1.Position:=cshr.CRoseSz;
  RaDec1.value:=cshr.DegreeGridSpacing[0];
  RaDec2.value:=cshr.DegreeGridSpacing[1];
  RaDec3.value:=cshr.DegreeGridSpacing[2];
  RaDec4.value:=cshr.DegreeGridSpacing[3];
  RaDec5.value:=cshr.DegreeGridSpacing[4];
  RaDec6.value:=cshr.DegreeGridSpacing[5];
  RaDec7.value:=cshr.DegreeGridSpacing[6];
  RaDec8.value:=cshr.DegreeGridSpacing[7];
  RaDec9.value:=cshr.DegreeGridSpacing[8];
  RaDec10.value:=cshr.DegreeGridSpacing[9];
  RaDec11.value:=cshr.DegreeGridSpacing[10];
  RaDec1.Enabled:=cshr.DegreeGridSpacing[0]<1000;
  RaDec2.Enabled:=cshr.DegreeGridSpacing[1]<1000;
  RaDec3.Enabled:=cshr.DegreeGridSpacing[2]<1000;
  RaDec4.Enabled:=cshr.DegreeGridSpacing[3]<1000;
  RaDec5.Enabled:=cshr.DegreeGridSpacing[4]<1000;
  RaDec6.Enabled:=cshr.DegreeGridSpacing[5]<1000;
  RaDec7.Enabled:=cshr.DegreeGridSpacing[6]<1000;
  RaDec8.Enabled:=cshr.DegreeGridSpacing[7]<1000;
  RaDec9.Enabled:=cshr.DegreeGridSpacing[8]<1000;
  RaDec10.Enabled:=cshr.DegreeGridSpacing[9]<1000;
  RaDec11.Enabled:=cshr.DegreeGridSpacing[10]<1000;
  CheckBox1.Checked:=RaDec1.Enabled;
  CheckBox2.Checked:=RaDec2.Enabled;
  CheckBox3.Checked:=RaDec3.Enabled;
  CheckBox4.Checked:=RaDec4.Enabled;
  CheckBox5.Checked:=RaDec5.Enabled;
  CheckBox6.Checked:=RaDec6.Enabled;
  CheckBox7.Checked:=RaDec7.Enabled;
  CheckBox8.Checked:=RaDec8.Enabled;
  CheckBox9.Checked:=RaDec9.Enabled;
  CheckBox10.Checked:=RaDec10.Enabled;
  CheckBox11.Checked:=RaDec11.Enabled;
  RaDec12.value:=cshr.HourGridSpacing[0];
  RaDec13.value:=cshr.HourGridSpacing[1];
  RaDec14.value:=cshr.HourGridSpacing[2];
  RaDec15.value:=cshr.HourGridSpacing[3];
  RaDec16.value:=cshr.HourGridSpacing[4];
  RaDec17.value:=cshr.HourGridSpacing[5];
  RaDec18.value:=cshr.HourGridSpacing[6];
  RaDec19.value:=cshr.HourGridSpacing[7];
  RaDec20.value:=cshr.HourGridSpacing[8];
  RaDec21.value:=cshr.HourGridSpacing[9];
  RaDec22.value:=cshr.HourGridSpacing[10];
  RaDec12.Enabled:=RaDec1.Enabled;
  RaDec13.Enabled:=RaDec2.Enabled;
  RaDec14.Enabled:=RaDec3.Enabled;
  RaDec15.Enabled:=RaDec4.Enabled;
  RaDec16.Enabled:=RaDec5.Enabled;
  RaDec17.Enabled:=RaDec6.Enabled;
  RaDec18.Enabled:=RaDec7.Enabled;
  RaDec19.Enabled:=RaDec8.Enabled;
  RaDec20.Enabled:=RaDec9.Enabled;
  RaDec21.Enabled:=RaDec10.Enabled;
  RaDec22.Enabled:=RaDec11.Enabled;
end;

procedure Tf_config_chart.ShowField;
begin
fw0.Value:=cshr.fieldnum[0];
fw1.Value:=cshr.fieldnum[1];
fw2.Value:=cshr.fieldnum[2];
fw3.Value:=cshr.fieldnum[3];
fw4.Value:=cshr.fieldnum[4];
fw5.Value:=cshr.fieldnum[5];
fw6.Value:=cshr.fieldnum[6];
fw7.Value:=cshr.fieldnum[7];
fw8.Value:=cshr.fieldnum[8];
fw9.Value:=cshr.fieldnum[9];
ft0.Value:=cshr.fieldnum[0];
ft1.Value:=cshr.fieldnum[1];
ft2.Value:=cshr.fieldnum[2];
ft3.Value:=cshr.fieldnum[3];
ft4.Value:=cshr.fieldnum[4];
ft5.Value:=cshr.fieldnum[5];
ft6.Value:=cshr.fieldnum[6];
ft7.Value:=cshr.fieldnum[7];
ft8.Value:=cshr.fieldnum[8];
ft9.Value:=cshr.fieldnum[9];
ShowFOV;
end;

procedure Tf_config_chart.ShowFov;
begin
fv0.Caption:='0: 0 - '+formatfloat(f1s,cshr.fieldnum[0]);
fv1.Caption:='1: '+formatfloat(f1s,cshr.fieldnum[0])+' - '+formatfloat(f1s,cshr.fieldnum[1]);
fv2.Caption:='2: '+formatfloat(f1s,cshr.fieldnum[1])+' - '+formatfloat(f1s,cshr.fieldnum[2]);
fv3.Caption:='3: '+formatfloat(f1s,cshr.fieldnum[2])+' - '+formatfloat(f1s,cshr.fieldnum[3]);
fv4.Caption:='4: '+formatfloat(f1s,cshr.fieldnum[3])+' - '+formatfloat(f1s,cshr.fieldnum[4]);
fv5.Caption:='5: '+formatfloat(f1s,cshr.fieldnum[4])+' - '+formatfloat(f1s,cshr.fieldnum[5]);
fv6.Caption:='6: '+formatfloat(f1s,cshr.fieldnum[5])+' - '+formatfloat(f1s,cshr.fieldnum[6]);
fv7.Caption:='7: '+formatfloat(f1s,cshr.fieldnum[6])+' - '+formatfloat(f1s,cshr.fieldnum[7]);
fv8.Caption:='8: '+formatfloat(f1s,cshr.fieldnum[7])+' - '+formatfloat(f1s,cshr.fieldnum[8]);
fv9.Caption:='9: '+formatfloat(f1s,cshr.fieldnum[8])+' - '+formatfloat(f1s,cshr.fieldnum[9]);
fv10.Caption:='10: '+formatfloat(f1s,cshr.fieldnum[9])+' - '+formatfloat(f1s,cshr.fieldnum[10]);
end;


procedure Tf_config_chart.ShowFilter;
begin
starbox.Checked:=cshr.StarFilter;
StarAutoBox.Checked:=cshr.AutoStarFilter;
fsmagvis.Value:=cshr.AutoStarFilterMag;
fsmag0.Value:=cshr.StarMagFilter[1];
fsmag1.Value:=cshr.StarMagFilter[2];
fsmag2.Value:=cshr.StarMagFilter[3];
fsmag3.Value:=cshr.StarMagFilter[4];
fsmag4.Value:=cshr.StarMagFilter[5];
fsmag5.Value:=cshr.StarMagFilter[6];
fsmag6.Value:=cshr.StarMagFilter[7];
fsmag7.Value:=cshr.StarMagFilter[8];
fsmag8.Value:=cshr.StarMagFilter[9];
fsmag9.Value:=cshr.StarMagFilter[10];
nebbox.Checked:=cshr.NebFilter;
bignebbox.Checked:=cshr.BigNebFilter;
fBigNebLimit.value:=round(cshr.BigNebLimit);
fmag0.Value:=cshr.NebMagFilter[1];
fmag1.Value:=cshr.NebMagFilter[2];
fmag2.Value:=cshr.NebMagFilter[3];
fmag3.Value:=cshr.NebMagFilter[4];
fmag4.Value:=cshr.NebMagFilter[5];
fmag5.Value:=cshr.NebMagFilter[6];
fmag6.Value:=cshr.NebMagFilter[7];
fmag7.Value:=cshr.NebMagFilter[8];
fmag8.Value:=cshr.NebMagFilter[9];
fmag9.Value:=cshr.NebMagFilter[10];
fdim0.Value:=cshr.NebSizeFilter[1];
fdim1.Value:=cshr.NebSizeFilter[2];
fdim2.Value:=cshr.NebSizeFilter[3];
fdim3.Value:=cshr.NebSizeFilter[4];
fdim4.Value:=cshr.NebSizeFilter[5];
fdim5.Value:=cshr.NebSizeFilter[6];
fdim6.Value:=cshr.NebSizeFilter[7];
fdim7.Value:=cshr.NebSizeFilter[8];
fdim8.Value:=cshr.NebSizeFilter[1];
fdim9.Value:=cshr.NebSizeFilter[10];
panel4.Visible:=cshr.StarFilter;
panel3.visible:=cshr.AutoStarFilter;
panel2.Visible:=not cshr.AutoStarFilter;
Panel5.visible:=cshr.NebFilter;
BigNebBox.visible:=cshr.NebFilter;
end;

procedure Tf_config_chart.ShowProjection;
   procedure setprojrange(var cb:Tcombobox;n:integer);
   begin
     cb.items.clear;
     cb.items.add('ARC');
     if cshr.fieldnum[n]<=140 then cb.items.add('TAN');
     if cshr.fieldnum[n]<=90 then cb.items.add('SIN');
     cb.items.add('CAR');
     cb.text:=csc.projname[n]
   end;
begin
setprojrange(combobox1,0);
setprojrange(combobox2,1);
setprojrange(combobox3,2);
setprojrange(combobox4,3);
setprojrange(combobox5,4);
setprojrange(combobox6,5);
setprojrange(combobox7,6);
setprojrange(combobox8,7);
setprojrange(combobox9,8);
setprojrange(combobox10,9);
setprojrange(combobox11,10);
setfieldhint(labelp0,0); combobox1.hint:=labelp0.hint;
setfieldhint(labelp1,1); combobox2.hint:=labelp1.hint;
setfieldhint(labelp2,2); combobox3.hint:=labelp2.hint;
setfieldhint(labelp3,3); combobox4.hint:=labelp3.hint;
setfieldhint(labelp4,4); combobox5.hint:=labelp4.hint;
setfieldhint(labelp5,5); combobox6.hint:=labelp5.hint;
setfieldhint(labelp6,6); combobox7.hint:=labelp6.hint;
setfieldhint(labelp7,7); combobox8.hint:=labelp7.hint;
setfieldhint(labelp8,8); combobox9.hint:=labelp8.hint;
setfieldhint(labelp9,9); combobox10.hint:=labelp9.hint;
setfieldhint(labelp10,10); combobox11.hint:=labelp10.hint;
end;

procedure Tf_config_chart.ShowObjList;
begin
 liststar.checked:=cshr.liststar;
 listneb.checked:=cshr.listneb;
 listvar.checked:=cshr.listvar;
 listdbl.checked:=cshr.listdbl;
 listpla.checked:=cshr.listpla;
end;

procedure Tf_config_chart.SetFieldHint(var lab:Tlabel; n:integer);
const ff='0.0';
begin
case n of
0 : lab.hint:='0 - '+formatfloat(ff,cshr.fieldnum[n]);
1..(MaxField) : lab.hint:=formatfloat(ff,cshr.fieldnum[n-1])+' - '+formatfloat(ff,cshr.fieldnum[n]);
end;
lab.showhint:=true;
end;

procedure Tf_config_chart.equinoxtypeClick(Sender: TObject);
begin
cshr.EquinoxType:=equinoxtype.itemindex;
SetEquinox;
end;

procedure Tf_config_chart.Button1Click(Sender: TObject);
begin
cshr.FieldNum[0]:=0.5;
cshr.FieldNum[1]:=1;
cshr.FieldNum[2]:=2;
cshr.FieldNum[3]:=5;
cshr.FieldNum[4]:=10;
cshr.FieldNum[5]:=20;
cshr.FieldNum[6]:=45;
cshr.FieldNum[7]:=90;
cshr.FieldNum[8]:=180;
cshr.FieldNum[9]:=310;
cshr.FieldNum[10]:=360;
ShowField;
end;

procedure Tf_config_chart.FormClose(Sender: TObject;
  var CloseAction: TCloseAction);
begin
  LockChange:=true;
end;

procedure Tf_config_chart.FormDestroy(Sender: TObject);
begin
mycsc.Free;
myccat.Free;
mycshr.Free;
mycplot.Free;
mycmain.Free;
end;

procedure Tf_config_chart.Notebook1PageChanged(Sender: TObject);
begin
if (Notebook1.ActivePage='Page3') or
   (Notebook1.ActivePage='Page4') or
   (Notebook1.ActivePage='Page5')
then
   FOVPanel.Visible:=true
else
   FOVPanel.Visible:=false;

end;

procedure Tf_config_chart.TrackBar1Change(Sender: TObject);
begin
if LockChange then exit;
cshr.CRoseSz:=TrackBar1.Position;
end;

procedure Tf_config_chart.equinox1Change(Sender: TObject);
begin
if LockChange then exit;
if (cshr.EquinoxType=0) then SetEquinox;
end;

procedure Tf_config_chart.FormCreate(Sender: TObject);
begin
  SetLang;
  LockChange:=true;
  fw0.OnExit:=FWExit;
  fw1.OnExit:=FWExit;
  fw2.OnExit:=FWExit;
  fw3.OnExit:=FWExit;
  fw4.OnExit:=FWExit;
  fw5.OnExit:=FWExit;
  fw6.OnExit:=FWExit;
  fw7.OnExit:=FWExit;
  fw8.OnExit:=FWExit;
  fw9.OnExit:=FWExit;
end;

procedure Tf_config_chart.equinox2Change(Sender: TObject);
begin
if LockChange then exit;
if (cshr.EquinoxType=1)and(trim(equinox2.text)>'') then SetEquinox;
end;

procedure Tf_config_chart.PMBoxClick(Sender: TObject);
begin
csc.PMon:=PMBox.checked;
end;

procedure Tf_config_chart.DrawPmBoxClick(Sender: TObject);
begin
csc.DrawPMon:=DrawPMBox.checked;
end;

procedure Tf_config_chart.lDrawPMyChange(Sender: TObject);
begin
if LockChange then exit;
csc.DrawPMyear:=lDrawPMy.value;
end;

procedure Tf_config_chart.ApparentTypeClick(Sender: TObject);
begin
csc.ApparentPos:=(ApparentType.ItemIndex=1);
end;

procedure Tf_config_chart.projectiontypeClick(Sender: TObject);
begin
csc.ProjPole:=projectiontype.itemindex;
end;

procedure Tf_config_chart.SetEquinox;
begin
case cshr.EquinoxType of
0 : begin
     case equinox1.itemindex of
     0 : begin
           cshr.EquinoxChart:='J2000';
           cshr.DefaultJDChart:=jd2000;
         end;
     1 : begin
           cshr.EquinoxChart:='B1950';
           cshr.DefaultJDChart:=jd1950;
         end;
     2 : begin
           cshr.EquinoxChart:='B1900';
           cshr.DefaultJDChart:=jd1900;
         end;
     end;
     equinox1.Visible:=true;
     equinox2.Visible:=false;
     EquinoxLabel.Visible:=true;
    end;
1 : begin
     cshr.EquinoxChart:=equinox2.text;
     cshr.DefaultJDChart:=jd(trunc(equinox2.Value),trunc(frac(equinox2.Value)*12)+1,0,0);
     equinox1.Visible:=false;
     equinox2.Visible:=true;
     EquinoxLabel.Visible:=true;
    end;
2 : begin
     cshr.EquinoxChart:=rsDate;
     cshr.DefaultJDChart:=jd2000;
     equinox1.Visible:=false;
     equinox2.Visible:=false;
     EquinoxLabel.Visible:=false;
    end;
end;
end;

procedure Tf_config_chart.FWExit(Sender: TObject);
begin
if LockChange then exit;
if sender is TFloatEdit then with sender as TFloatEdit do begin
 if value>0 then begin
    cshr.fieldnum[tag]:=Value;
    ShowField;
 end;
end;
end;

procedure Tf_config_chart.ProjectionChange(Sender: TObject);
begin
if LockChange then exit;
if sender is TComboBox then with sender as TComboBox do
   csc.projname[tag]:=text;
end;

procedure Tf_config_chart.StarBoxClick(Sender: TObject);
begin
cshr.StarFilter:=StarBox.Checked;
panel4.Visible:=cshr.StarFilter;
end;

procedure Tf_config_chart.StarAutoBoxClick(Sender: TObject);
begin
cshr.AutoStarFilter:=StarAutoBox.Checked;
panel3.visible:=cshr.AutoStarFilter;
panel2.Visible:=not cshr.AutoStarFilter;
end;

procedure Tf_config_chart.fsmagvisChange(Sender: TObject);
begin
if LockChange then exit;
cshr.AutoStarFilterMag:=fsmagvis.Value;
end;

procedure Tf_config_chart.fsmagChange(Sender: TObject);
begin
if LockChange then exit;
if sender is TFloatEdit then with sender as TFloatEdit do begin
  cshr.StarMagFilter[tag]:=Value;
end;
end;

procedure Tf_config_chart.NebBoxClick(Sender: TObject);
begin
cshr.NebFilter:=NebBox.Checked;
Panel5.visible:=cshr.NebFilter;
BigNebBox.visible:=cshr.NebFilter;
fBigNebLimit.visible:=cshr.NebFilter;
BigNebUnit.visible:=cshr.NebFilter;
end;

procedure Tf_config_chart.BigNebBoxClick(Sender: TObject);
begin
cshr.BigNebFilter:=bignebbox.Checked;
end;

procedure Tf_config_chart.fBigNebLimitChange(Sender: TObject);
begin
if LockChange then exit;
cshr.BigNebLimit:=fBigNebLimit.value;
end;

procedure Tf_config_chart.fmagChange(Sender: TObject);
begin
if LockChange then exit;
if sender is TFloatEdit then with sender as TFloatEdit do begin
  cshr.NebMagFilter[tag]:=Value;
end;
end;

procedure Tf_config_chart.fdimChange(Sender: TObject);
begin
if LockChange then exit;
if sender is TFloatEdit then with sender as TFloatEdit do begin
  cshr.NebSizeFilter[tag]:=Value;
end;
end;

procedure Tf_config_chart.Button2Click(Sender: TObject);
begin
cshr.DegreeGridSpacing[0]:=1000+5/60;
cshr.DegreeGridSpacing[1]:=1000+10/60;
cshr.DegreeGridSpacing[2]:=1000+20/60;
cshr.DegreeGridSpacing[3]:=1000+30/60;
cshr.DegreeGridSpacing[4]:=1000+1;
cshr.DegreeGridSpacing[5]:=1000+2;
cshr.DegreeGridSpacing[6]:=1000+5;
cshr.DegreeGridSpacing[7]:=10;
cshr.DegreeGridSpacing[8]:=15;
cshr.DegreeGridSpacing[9]:=20;
cshr.DegreeGridSpacing[10]:=20;
cshr.HourGridSpacing[0]:=20/3600;
cshr.HourGridSpacing[1]:=30/3600;
cshr.HourGridSpacing[2]:=1/60;
cshr.HourGridSpacing[3]:=2/60;
cshr.HourGridSpacing[4]:=5/60;
cshr.HourGridSpacing[5]:=15/60;
cshr.HourGridSpacing[6]:=30/60;
cshr.HourGridSpacing[7]:=1;
cshr.HourGridSpacing[8]:=1;
cshr.HourGridSpacing[9]:=2;
cshr.HourGridSpacing[10]:=2;
cshr.CRoseSz:=80;
LockChange:=true;
ShowGridSpacing;
LockChange:=false;
end;

procedure Tf_config_chart.CheckBox13Click(Sender: TObject);
begin
if LockChange then exit;
  cshr.ShowCRose:=CheckBox13.Checked;
end;

procedure Tf_config_chart.ShowGridBoxClick(Sender: TObject);
begin
if LockChange then exit;
LockChange:=true;
if sender is TCheckBox then with sender as TCheckBox do begin
  if checked then begin
     if cshr.DegreeGridSpacing[tag]>1000 then begin
        cshr.DegreeGridSpacing[tag]:=cshr.DegreeGridSpacing[tag]-1000;
     end
  end else begin
     cshr.DegreeGridSpacing[tag]:=cshr.DegreeGridSpacing[tag]+1000;
  end;
end;
ShowGridSpacing;
LockChange:=false;
end;

procedure Tf_config_chart.DegSpacingChange(Sender: TObject);
var x: double;
begin
if LockChange then exit;
if sender is TRaDec then begin
   x:=TRaDec(sender).value;
   if x>0 then cshr.DegreeGridSpacing[TRaDec(sender).tag]:=x;
end;
end;

procedure Tf_config_chart.HourSpacingChange(Sender: TObject);
var x: double;
begin
if LockChange then exit;
if sender is TRaDec then  begin
   x:=TRaDec(sender).value;
   if x>0 then cshr.HourGridSpacing[TRaDec(sender).tag]:=x;
end;   
end;

procedure Tf_config_chart.liststarClick(Sender: TObject);
begin
cshr.liststar:=liststar.checked;
end;

procedure Tf_config_chart.listnebClick(Sender: TObject);
begin
cshr.listneb:=listneb.checked;
end;

procedure Tf_config_chart.listplaClick(Sender: TObject);
begin
cshr.listpla:=listpla.checked;
end;

procedure Tf_config_chart.listvarClick(Sender: TObject);
begin
cshr.listvar:=listvar.checked;
end;

procedure Tf_config_chart.listdblClick(Sender: TObject);
begin
cshr.listdbl:=listdbl.checked;
end;

initialization
  {$i pu_config_chart.lrs}

end.
