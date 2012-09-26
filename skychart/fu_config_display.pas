unit fu_config_display;

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
Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
}

interface

uses u_help, u_translation, u_constant, u_util,
  LCLIntf, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Grids, Spin, Buttons, StdCtrls, ExtCtrls, ComCtrls, LResources,
  EditBtn, LCLType, enhedits, LazHelpHTML;

type

  { Tf_config_display }

  Tf_config_display = class(TFrame)
    Button3: TButton;
    BtnDefaultColor: TButton;
    BtnRedColor: TButton;
    BtnWBColor: TButton;
    BtnBWColor: TButton;
    Button7: TButton;
    Button8: TButton;
    Button9: TButton;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    antialias: TCheckBox;
    CheckBox3: TCheckBox;
    CheckBox4: TCheckBox;
    CheckBox5: TCheckBox;
    CheckBox6: TCheckBox;
    OptLabels: TCheckBox;
    Label10: TLabel;
    Label14: TLabel;
    ShowLineShape: TShape;
    ShowLines: TCheckBox;
    OnlyMeridian: TCheckBox;
    LabelLine: TCheckBox;
    FillPanel1: TPanel;
    FillPanel2: TPanel;
    ShowTitle: TCheckBox;
    Edit1: TEdit;
    Edit10: TEdit;
    Edit11: TEdit;
    Edit12: TEdit;
    Edit13: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    Edit5: TEdit;
    Edit6: TEdit;
    Edit7: TEdit;
    Edit8: TEdit;
    Edit9: TEdit;
    FileNameEdit1: TFileNameEdit;
    Label9: TLabel;
    labelSizeStar: TUpDown;
    labelsizeVar: TUpDown;
    labelsizeMult: TUpDown;
    labelsizeNeb: TUpDown;
    labelsizeSol: TUpDown;
    labelsizeConst: TUpDown;
    labelsizeMisc: TUpDown;
    labelsizeChartInfo: TUpDown;
    labelmagVar: TUpDown;
    labelmagMult: TUpDown;
    labelmagNeb: TUpDown;
    labelmagSol: TUpDown;
    lstDSOCScheme: TComboBox;
    DrawAllStarLabel: TCheckBox;
    DrawPmBox: TCheckBox;
    DrawPMy: TLongEdit;
    GridStyle: TComboBox;
    EclipticStyle: TComboBox;
    EqGridStyle: TComboBox;
    GalEqStyle: TComboBox;
    CFStyle: TComboBox;
    CBStyle: TComboBox;
    ConstlFile: TFileNameEdit;
    ConstbFile: TFileNameEdit;
    GroupBox6: TGroupBox;
    GroupBox7: TGroupBox;
    GroupBox8: TGroupBox;
    Label258: TLabel;
    Label259: TLabel;
    Label5: TLabel;
    Label68: TLabel;
    Label8: TLabel;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    Panel5: TPanel;
    Panel7: TPanel;
    red_moveBox: TCheckBox;
    Shape8: TShape;
    StarButton5: TButton;
    StarButton6: TButton;
    StarButton7: TButton;
    StarDynBar1: TTrackBar;
    StarSizeBar1: TTrackBar;
    ThemeList: TComboBox;
    MainPanel: TPanel;
    Page1: TTabSheet;
    Page2: TTabSheet;
    Page3: TTabSheet;
    Page4: TTabSheet;
    Page5: TTabSheet;
    Page6: TTabSheet;
    Page7: TTabSheet;
    Page8: TTabSheet;
    Page9: TTabSheet;
    NightButton: TRadioGroup;
    StandardButton: TRadioGroup;
    stardisplay: TRadioGroup;
    nebuladisplay: TRadioGroup;
    Label256: TLabel;
    Label262: TLabel;
    Label263: TLabel;
    Label257: TLabel;
    StarSizeBar: TTrackBar;
    StarContrastBar: TTrackBar;
    SaturationBar: TTrackBar;
    SizeContrastBar: TTrackBar;
    StarButton1: TButton;
    StarButton2: TButton;
    StarButton3: TButton;
    StarButton4: TButton;
    Bevel10: TBevel;
    Label121: TLabel;
    Label122: TLabel;
    Label123: TLabel;
    Label124: TLabel;
    Label125: TLabel;
    Label126: TLabel;
    Label127: TLabel;
    Label128: TLabel;
    Label129: TLabel;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    SpeedButton4: TSpeedButton;
    SpeedButton5: TSpeedButton;
    SpeedButton6: TSpeedButton;
    SpeedButton7: TSpeedButton;
    Label235: TLabel;
    gridfont: TEdit;
    labelfont: TEdit;
    legendfont: TEdit;
    statusfont: TEdit;
    listfont: TEdit;
    prtfont: TEdit;
    Button1: TButton;
    symbfont: TEdit;
    Label181: TLabel;
    Label182: TLabel;
    Label183: TLabel;
    Label184: TLabel;
    Label185: TLabel;
    Label186: TLabel;
    Label187: TLabel;
    Label188: TLabel;
    Label189: TLabel;
    Label193: TLabel;
    Label194: TLabel;
    Label195: TLabel;
    Label197: TLabel;
    Label198: TLabel;
    Label199: TLabel;
    Label196: TLabel;
    Label11: TLabel;
    Label6: TLabel;
    Label234: TLabel;
    Label269: TLabel;
    bg1: TPanel;
    Shape1: TShape;
    Shape2: TShape;
    Shape3: TShape;
    Shape4: TShape;
    Shape5: TShape;
    Shape6: TShape;
    Shape7: TShape;
    bg3: TPanel;
    Shape15: TShape;
    Shape16: TShape;
    Shape14: TShape;
    bg4: TPanel;
    Shape26: TShape;
    Shape27: TShape;
    Shape28: TShape;
    Label202: TLabel;
    Label205: TLabel;
    Label208: TLabel;
    skycolorbox: TRadioGroup;
    Panel6: TPanel;
    Shape18: TShape;
    Shape19: TShape;
    Shape20: TShape;
    Shape21: TShape;
    Shape22: TShape;
    Shape23: TShape;
    Shape24: TShape;
    EqGrid: TCheckBox;
    CGrid: TCheckBox;
    ecliptic: TCheckBox;
    galactic: TCheckBox;
    GridNum: TCheckBox;
    MagLabel: TRadioGroup;
    constlabel: TRadioGroup;
    Label307: TLabel;
    cb1: TCheckBox;
    cb2: TCheckBox;
    cb3: TCheckBox;
    cb4: TCheckBox;
    cb5: TCheckBox;
    cb6: TCheckBox;
    cb7: TCheckBox;
    cb8: TCheckBox;
    cb9: TCheckBox;
    cb10: TCheckBox;
    Circlegrid: TStringGrid;
    CenterMark1: TCheckBox;
    Label308: TLabel;
    rb1: TCheckBox;
    rb2: TCheckBox;
    rb3: TCheckBox;
    rb4: TCheckBox;
    rb5: TCheckBox;
    rb6: TCheckBox;
    rb7: TCheckBox;
    rb8: TCheckBox;
    rb9: TCheckBox;
    rb10: TCheckBox;
    RectangleGrid: TStringGrid;
    CenterMark2: TCheckBox;
    FontDialog1: TFontDialog;
    ColorDialog1: TColorDialog;
    Showlabelall: TCheckBox;
    ShowChartInfo: TCheckBox;
    lblDSOCScheme: TLabel;
    gbDSOCOverrides: TGroupBox;
    lblAst: TLabel;
    shpAst: TShape;
    lblSN: TLabel;
    shpSN: TShape;
    lblOCl: TLabel;
    lblGCl: TLabel;
    lblPNe: TLabel;
    lblDN: TLabel;
    lblEN: TLabel;
    lblRN: TLabel;
    shpRN: TShape;
    shpEN: TShape;
    shpDN: TShape;
    shpPNe: TShape;
    shpGCl: TShape;
    shpOCl: TShape;
    lblGxy: TLabel;
    lblGxyCl: TLabel;
    lblQ: TLabel;
    lblGL: TLabel;
    lblNE: TLabel;
    shpNE: TShape;
    shpGL: TShape;
    shpQ: TShape;
    shpGxyCl: TShape;
    shpGxy: TShape;
    lblDSOType: TLabel;
    lblDSOColour: TLabel;
    lblDSOColourFill: TLabel;
    Label7: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    chkFillAst: TCheckBox;
    chkFillOCl: TCheckBox;
    chkFillGCl: TCheckBox;
    chkFillPNe: TCheckBox;
    chkFillDN: TCheckBox;
    chkFillEN: TCheckBox;
    chkFillRN: TCheckBox;
    chkFillSN: TCheckBox;
    chkFillGxy: TCheckBox;
    chkFillGxyCl: TCheckBox;
    chkFillQ: TCheckBox;
    chkFillGL: TCheckBox;
    chkFillNE: TCheckBox;
    GroupBox2: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    NebBrightBar: TTrackBar;
    NebGrayBar: TTrackBar;
    DefNebColorButton: TButton;
    NebColorPanel: TPanel;
    Shape29: TShape;
    Shape30: TShape;
    GroupBox1: TGroupBox;
    Constl: TCheckBox;
    Label132: TLabel;
    GroupBox3: TGroupBox;
    Constb: TCheckBox;
    Label72: TLabel;
    GroupBox4: TGroupBox;
    milkyway: TCheckBox;
    fillmilkyway: TCheckBox;
    GroupBox5: TGroupBox;
    showlabelStar: TCheckBox;
    showlabelVar: TCheckBox;
    showlabelMult: TCheckBox;
    showlabelNeb: TCheckBox;
    showlabelSol: TCheckBox;
    showlabelConst: TCheckBox;
    showlabelMisc: TCheckBox;
    ShowLabelChartInfo: TCheckBox;
    Label237: TLabel;
    Label252: TLabel;
    Label240: TLabel;
    labelcolorStar: TShape;
    labelcolorVar: TShape;
    labelcolorMult: TShape;
    labelcolorNeb: TShape;
    labelcolorSol: TShape;
    labelcolorConst: TShape;
    labelcolorMisc: TShape;
    labelcolorchartinfo: TShape;
    Label255: TLabel;
    Shape25: TShape;
    Shape13: TShape;
    Shape17: TShape;
    Shape12: TShape;
    Shape11: TShape;
    PageControl1: TPageControl;
    labelmagStar: TUpDown;
    procedure antialiasClick(Sender: TObject);
    procedure BtnBWColorClick(Sender: TObject);
    procedure BtnDefaultColorClick(Sender: TObject);
    procedure BtnRedColorClick(Sender: TObject);
    procedure BtnWBColorClick(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure Button8Click(Sender: TObject);
    procedure Button9Click(Sender: TObject);
    procedure CBStyleChange(Sender: TObject);
    procedure CFStyleChange(Sender: TObject);
    procedure CheckBox1Click(Sender: TObject);
    procedure CheckBox2Click(Sender: TObject);
    procedure CheckBox5Click(Sender: TObject);
    procedure CheckBox6Click(Sender: TObject);
    procedure MarkNumberClick(Sender: TObject);
    procedure ConstbFileAcceptFileName(Sender: TObject; var Value: String);
    procedure ConstlFileAcceptFileName(Sender: TObject; var Value: String);
    procedure DrawAllStarLabelClick(Sender: TObject);
    procedure DrawPMyChange(Sender: TObject);
    procedure DrawPmBoxClick(Sender: TObject);
    procedure EclipticStyleChange(Sender: TObject);
    procedure EqGridStyleChange(Sender: TObject);
    procedure FileNameEdit1AcceptFileName(Sender: TObject; var Value: String);
    procedure FileNameEdit1Change(Sender: TObject);
    procedure GalEqStyleChange(Sender: TObject);
    procedure GridStyleChange(Sender: TObject);
    procedure LabelLineClick(Sender: TObject);
    procedure lstDSOCSchemeChange(Sender: TObject);
    procedure OnlyMeridianClick(Sender: TObject);
    procedure OptLabelsClick(Sender: TObject);
    procedure Page3Show(Sender: TObject);
    procedure ShowLinesClick(Sender: TObject);
    procedure ShowLineShapeMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ShowTitleClick(Sender: TObject);
    procedure StarButton5Click(Sender: TObject);
    procedure StarButton6Click(Sender: TObject);
    procedure StarButton7Click(Sender: TObject);
    procedure StarDynBar1Change(Sender: TObject);
    procedure StarSizeBar1Change(Sender: TObject);
    procedure StyleDrawItem(Control: TWinControl; Index: Integer;
      ARect: TRect; State: TOwnerDrawState);
    procedure NightButtonClick(Sender: TObject);
    procedure StandardButtonClick(Sender: TObject);
    procedure ThemeListChange(Sender: TObject);
    procedure lDrawPMyChange(Sender: TObject);
    procedure nebuladisplayClick(Sender: TObject);
    procedure red_moveBoxClick(Sender: TObject);
    procedure stardisplayClick(Sender: TObject);
    procedure StarSizeBarChange(Sender: TObject);
    procedure SizeContrastBarChange(Sender: TObject);
    procedure StarContrastBarChange(Sender: TObject);
    procedure SaturationBarChange(Sender: TObject);
    procedure StarButton1Click(Sender: TObject);
    procedure StarButton2Click(Sender: TObject);
    procedure StarButton3Click(Sender: TObject);
    procedure StarButton4Click(Sender: TObject);
    procedure SelectFontClick(Sender: TObject);
    procedure DefaultFontClick(Sender: TObject);
    procedure ShapeMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure skycolorboxClick(Sender: TObject);
    procedure ShapeSkyMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Button3Click(Sender: TObject);
    procedure CGridClick(Sender: TObject);
    procedure EqGridClick(Sender: TObject);
    procedure GridNumClick(Sender: TObject);
    procedure eclipticClick(Sender: TObject);
    procedure galacticClick(Sender: TObject);
    procedure ConstlClick(Sender: TObject);
    procedure ConstlFileChange(Sender: TObject);
    procedure ConstbClick(Sender: TObject);
    procedure ConstbFileChange(Sender: TObject);
    procedure milkywayClick(Sender: TObject);
    procedure fillmilkywayClick(Sender: TObject);
    procedure showlabelClick(Sender: TObject);
    procedure labelcolorMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure labelsizeChanged(Sender: TObject; Button: TUDBtnType);
    procedure labelmagChanged(Sender: TObject; Button: TUDBtnType);
    procedure MagLabelClick(Sender: TObject);
    procedure constlabelClick(Sender: TObject);
    procedure CirclegridSetEditText(Sender: TObject; ACol, ARow: Integer;
      const Value: String);
    procedure cbClick(Sender: TObject);
    procedure CenterMark1Click(Sender: TObject);
    procedure RectangleGridSetEditText(Sender: TObject; ACol,
      ARow: Integer; const Value: String);
    procedure rbClick(Sender: TObject);
    procedure NebGrayBarChange(Sender: TObject);
    procedure NebBrightBarChange(Sender: TObject);
    procedure DefNebColorButtonClick(Sender: TObject);
    procedure NebShapeMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ShowlabelallClick(Sender: TObject);
    procedure ShowChartInfoClick(Sender: TObject);

//  deep-sky objects colour

    procedure ShapeDSOMouseUp(Sender: TObject; Button: TMouseButton;
              Shift: TShiftState; X, Y: Integer);
    procedure chkFillAstClick(Sender: TObject);
    procedure chkFillOClClick(Sender: TObject);
    procedure chkFillPNeClick(Sender: TObject);
    procedure chkFillGClClick(Sender: TObject);
    procedure chkFillDNClick(Sender: TObject);
    procedure chkFillENClick(Sender: TObject);
    procedure chkFillRNClick(Sender: TObject);
    procedure chkFillSNClick(Sender: TObject);
    procedure chkFillGxyClick(Sender: TObject);
    procedure chkFillGxyClClick(Sender: TObject);
    procedure chkFillQClick(Sender: TObject);
    procedure chkFillGLClick(Sender: TObject);
    procedure chkFillNEClick(Sender: TObject);
    procedure FillDSOMouseUp(Sender: TObject; Button: TMouseButton;
              Shift: TShiftState; X, Y: Integer);

//  End of deep-sky objects colour
  private
    { Private declarations }
    FApplyConfig: TNotifyEvent;
    LockChange: boolean;
    procedure ShowDisplay;
    procedure ShowFonts;
    procedure ShowColor;
    procedure ShowSkyColor;
    procedure ShowDSOColor;
    procedure ShowNebColor;
    procedure ShowLine;
    procedure ShowLabelColor;
    procedure ShowLabel;
    procedure ShowCircle;
    procedure ShowRectangle;
    procedure SetFonts(ctrl:Tedit;num:integer);
    procedure UpdNebColor;
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
    constructor Create(AOwner:TComponent); override;
    destructor Destroy; override;
    procedure Init; // old FormShow
    procedure Lock; // old FormClose
    procedure SetLang;
    property onApplyConfig: TNotifyEvent read FApplyConfig write FApplyConfig;
  end;

implementation
{$R *.lfm}

procedure Tf_config_display.SetLang;
begin
Caption:=rsDisplay;
Page1.caption:=rsDisplay;
stardisplay.caption:=rsStarDisplay;
stardisplay.Items[0]:=rsLineMode;
stardisplay.Items[1]:=rsPhotographic2;
stardisplay.Items[2]:=rsParametric;
nebuladisplay.caption:=rsNebulaDispla;
nebuladisplay.Items[0]:=rsLineMode;
nebuladisplay.Items[1]:=rsGraphic;
Label256.caption:=rsFaintStarsSi;
Label262.caption:=rsContrast;
Label263.caption:=rsColorSaturat;
Label257.caption:=rsIncrementFor;
StarButton1.caption:=rsDefault;
StarButton2.caption:=rsNakedEye;
StarButton3.caption:=rsHighColor;
StarButton4.caption:=rsBlackWhite;
StarButton5.caption:=rsDefault;
StarButton6.caption:=rsSmallStars;
StarButton7.caption:=rsBigStars;
Label258.caption:=rsBrightStarsS;
Label259.caption:=rsContrast;
label9.Caption:=rsStarsBitmapF;
Button7.Caption:=rsDefault;

Page2.caption:=rsColor;
Label189.caption:=rsStarColourBV;
Label193.caption:=rsCoordGrid;
Label194.caption:=rsEqGrid;
Label195.caption:=rsOrbit;
Label197.caption:=rsConstellatio;
Label198.caption:=rsBoundary;
Label199.caption:=rsEyepiece;
Label196.caption:=rsMiscLines;
Label11.caption:=rsHorizon;
Label6.caption:=rsAsteroid;
Label234.caption:=rsComet;
Label269.caption:=rsMilkyWay;
GroupBox7.caption:=rsStandardColo;
BtnDefaultColor.caption:=rsDefault;
Button8.Caption:=rsPastel;
BtnRedColor.caption:=rsRed;
BtnBWColor.caption:=rsWhiteOnBlack;
BtnWBColor.caption:=rsBlackOnWhite;
GroupBox6.caption:=rsTheme;
NightButton.caption:=rsNightVisionB;
NightButton.Items[0]:=rsNormalColor;
NightButton.Items[1]:=rsRed;
NightButton.Items[2]:=rsBlue;
NightButton.Items[3]:=rsGreen;
StandardButton.caption:=rsDefaultButto;
StandardButton.Items[0]:=rsNormalColor;
StandardButton.Items[1]:=rsRed;
StandardButton.Items[2]:=rsBlue;
StandardButton.Items[3]:=rsGreen;

Page3.caption:=rsDeepSkyColou;
lblDSOCScheme.caption:=rsUseAPresetCo;
gbDSOCOverrides.caption:=rsChooseColour;
lblAst.caption:=rsAsterism;
lblSN.caption:=rsSupernovaRem;
lblOCl.caption:=rsOpenCluster;
lblGCl.caption:=rsGlobularClus;
lblPNe.caption:=rsPlanetaryNeb;
lblDN.caption:=rsDarkNebula;
lblEN.caption:=rsEmissionNebu;
lblRN.caption:=rsReflectionNe;
lblGxy.caption:=rsGalaxy;
lblGxyCl.caption:=rsGalaxyCluste;
lblQ.caption:=rsQuasar;
lblGL.caption:=rsGravitationa;
lblNE.caption:=rsNonExistentU;
lblDSOType.caption:=rsObjectType;
lblDSOColour.caption:=rsColor;
lblDSOColourFill.caption:=rsFill;
Label7.caption:=rsObjectType;
Label12.caption:=rsColor;
Label13.caption:=rsFill;
GroupBox2.caption:=rsAdjustColour;
Label1.caption:=rsLowSurfaceBr;
Label2.caption:=rsHighSurfaceB;
Label3.caption:=rsFainter;
Label4.caption:=rsBrighter;
DefNebColorButton.caption:=rsDefault;
lstDSOCScheme.items[0]:='CdC v2 '+rsDefault;
lstDSOCScheme.items[1]:='CdC v3 '+rsDefault;
lstDSOCScheme.items[2]:=rsPrintedChart;
lstDSOCScheme.items[3]:=rsGreen;

Page4.caption:=rsSkyColour;
skycolorbox.caption:=rsSkyColour;
skycolorbox.items[0]:=rsFixedBlack;
skycolorbox.items[1]:=rsAutomatic;
Label205.caption:=rsTwilight;
Label202.caption:=rsDayTime;
Label208.caption:=rsAstronomical2;
Label5.Caption:=rsFixedSkyColo;
Button3.caption:=rsDefaultColor;

Page5.caption:=rsLines;
EqGrid.caption:=rsAddEquatoria;
CGrid.caption:=rsShowCoordina;
OnlyMeridian.Caption:=rsShowOnlyMeri;
ShowLines.Caption:=rsShowDSOLines;
Label10.Caption:=rsEditDSOLines;
ecliptic.caption:=rsShowEcliptic;
galactic.caption:=rsShowGalactic;
GridNum.caption:=rsShowGridLabe;
GroupBox1.caption:=rsConstellatio2;
Label132.caption:=rsConstellatio3;
Constl.caption:=rsShowConstell3;
CFStyle.items[0]:=rsLine1;
CFStyle.items[1]:=rsDash1;
CFStyle.items[2]:=rsDot1;
CFStyle.items[3]:=rsDashDot1;
CFStyle.items[4]:=rsDashDotDot1;
GroupBox3.caption:=rsConstellatio4;
Label72.caption:=rsConstellatio5;
Constb.caption:=rsShowConstell4;
CBStyle.items[0]:=rsLine1;
CBStyle.items[1]:=rsDash1;
CBStyle.items[2]:=rsDot1;
CBStyle.items[3]:=rsDashDot1;
CBStyle.items[4]:=rsDashDotDot1;
GroupBox4.caption:=rsMilkyWay;
milkyway.caption:=rsShowMilkyWay;
fillmilkyway.caption:=rsFillMilkyWay;
GroupBox8.caption:=rsProperMotion3;
GridStyle.items[0]:=rsLine1;
GridStyle.items[1]:=rsDash1;
GridStyle.items[2]:=rsDot1;
GridStyle.items[3]:=rsDashDot1;
GridStyle.items[4]:=rsDashDotDot1;
EclipticStyle.items[0]:=rsLine1;
EclipticStyle.items[1]:=rsDash1;
EclipticStyle.items[2]:=rsDot1;
EclipticStyle.items[3]:=rsDashDot1;
EclipticStyle.items[4]:=rsDashDotDot1;
EqGridStyle.items[0]:=rsLine1;
EqGridStyle.items[1]:=rsDash1;
EqGridStyle.items[2]:=rsDot1;
EqGridStyle.items[3]:=rsDashDot1;
EqGridStyle.items[4]:=rsDashDotDot1;
GalEqStyle.items[0]:=rsLine1;
GalEqStyle.items[1]:=rsDash1;
GalEqStyle.items[2]:=rsDot1;
GalEqStyle.items[3]:=rsDashDot1;
GalEqStyle.items[4]:=rsDashDotDot1;

Page6.caption:=rsLabels;
DrawAllStarLabel.Caption:=rsDisplayLabel;
LabelLine.Caption:=rsShowLineFrom;
OptLabels.Caption:=rsAutomaticall2;
MagLabel.caption:=rsStarLabel;
MagLabel.Items[0]:=rsName;
MagLabel.Items[1]:=rsCommonName;
MagLabel.Items[2]:=rsMagnitude;
constlabel.caption:=rsConstellatio6;
constlabel.Items[0]:=rsFullName;
constlabel.Items[1]:=rsAbbreviation;
constlabel.Items[2]:=rsLatinName;
Showlabelall.caption:=rsDisplayTheLa;
ShowChartInfo.caption:=rsDisplayTheCh;
ShowTitle.Caption:=rsShowPosition;
label14.caption:=rsLabelObject;
Label237.caption:=rsMagnitudeDif;
Label252.caption:=rsColor;
Label240.caption:=rsLabel2;
Label255.caption:=rsSize;
showlabelStar.caption:=rsStars;
showlabelVar.caption:=rsVariableStar;
showlabelMult.caption:=rsMultipleStar;
showlabelNeb.caption:=rsNebulae;
showlabelSol.caption:=rsSolarSystem;
showlabelConst.caption:=rsConstellatio7;
showlabelMisc.caption:=rsOtherLabel;
ShowLabelChartInfo.caption:=rsChartInforma;
CheckBox5.Caption:=rsChartLegend;
Button9.Caption:=rsDefault;

Page7.caption:=rsFonts;
Label121.caption:=rsCoordinatesG;
Label122.caption:=rsObject;
Label123.caption:=rsLabels;
Label124.caption:=rsLegend;
Label125.caption:=rsInformationD;
Label126.caption:=rsObjectList;
Label127.caption:=rsPrinterLegen;
Label128.caption:=rsFonts;
Label129.caption:=rsModify;
Label235.caption:=rsGreekSymbol;
Button1.caption:=rsDefault;
Page8.caption:=rsFinderCircle;
Label307.caption:=rsFinderCircle;
cb1.caption:=rsNo+' 1';
cb2.caption:=rsNo+' 2';
cb3.caption:=rsNo+' 3';
cb4.caption:=rsNo+' 4';
cb5.caption:=rsNo+' 5';
cb6.caption:=rsNo+' 6';
cb7.caption:=rsNo+' 7';
cb8.caption:=rsNo+' 8';
cb9.caption:=rsNo+' 9';
cb10.caption:=rsNo+' 10';
CenterMark1.caption:=rsMarkTheChart;
CheckBox1.Caption:=rsShowLabels;
CheckBox3.Caption:=rsShowMarkInde;
Page9.caption:=rsFinderRectan;
Label308.caption:=rsFinderRectan;
rb1.caption:=rsNo+' 1';
rb2.caption:=rsNo+' 2';
rb3.caption:=rsNo+' 3';
rb4.caption:=rsNo+' 4';
rb5.caption:=rsNo+' 5';
rb6.caption:=rsNo+' 6';
rb7.caption:=rsNo+' 7';
rb8.caption:=rsNo+' 8';
rb9.caption:=rsNo+' 9';
rb10.caption:=rsNo+'10';
CenterMark2.caption:=rsMarkTheChart;
CheckBox2.Caption:=rsShowLabels;
CheckBox4.Caption:=rsShowMarkInde;
label8.caption:=rsDrawALineTha;
Label68.caption:=rsYears;
red_moveBox.Caption:=rsReduceDetail;
antialias.Caption:=rsAntiAliasDra;
CheckBox6.Caption:=rsShowOnlyText;
SetHelp(self,hlpCfgDispl);
end;

constructor Tf_config_display.Create(AOwner:TComponent);
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
  LockChange:=true;
  SetLang;
  label124.Visible:=false;   // legend font
  legendfont.Visible:=false;
  speedbutton3.Visible:=false;
{$ifndef mswindows}
  label235.Visible:=false;      // symbol same as label with utf-8
  symbfont.Visible:=false;
  speedbutton7.Visible:=false;
{$endif}
end;

Destructor Tf_config_display.Destroy;
begin
mycsc.Free;
myccat.Free;
mycshr.Free;
mycplot.Free;
mycmain.Free;
inherited Destroy;
end;


procedure Tf_config_display.Init;
begin
LockChange:=true;
ShowDisplay;
ShowFonts;
ShowColor;
ShowSkyColor;
// changes for DSO Colors
ShowDSOColor;
ShowNebColor;
ShowLine;
Showlabel;
ShowCircle;
ShowRectangle;
//Application.ProcessMessages;
FileNameEdit1.InitialDir:=slash(appdir)+slash('data')+'stars';;
LockChange:=false;
end;

procedure Tf_config_display.GridStyleChange(Sender: TObject);
var i:integer;
begin
i:=GridStyle.itemindex;
if (i>=Ord(Low(TPenStyle)))and(i<=Ord(High(TPenStyle))) then
   csc.StyleGrid:=TPenStyle(i);
end;

procedure Tf_config_display.LabelLineClick(Sender: TObject);
begin
  csc.MovedLabelLine:=LabelLine.Checked;
end;

procedure Tf_config_display.StarButton5Click(Sender: TObject);
begin
StarSizeBar1.Position:=13;
StarDynBar1.Position:=65;
cplot.stardyn:=StarDynBar1.Position;
cplot.starsize:=StarSizeBar1.Position;
end;

procedure Tf_config_display.StarButton6Click(Sender: TObject);
begin
StarSizeBar1.Position:=5;
StarDynBar1.Position:=50;
cplot.stardyn:=StarDynBar1.Position;
cplot.starsize:=StarSizeBar1.Position;
end;

procedure Tf_config_display.StarButton7Click(Sender: TObject);
begin
StarSizeBar1.Position:=40;
StarDynBar1.Position:=78;
cplot.stardyn:=StarDynBar1.Position;
cplot.starsize:=StarSizeBar1.Position;
end;

procedure Tf_config_display.EqGridStyleChange(Sender: TObject);
var i:integer;
begin
i:=EqGridStyle.itemindex;
if (i>=Ord(Low(TPenStyle)))and(i<=Ord(High(TPenStyle))) then
   csc.StyleEqGrid:=TPenStyle(i);
end;

procedure Tf_config_display.FileNameEdit1AcceptFileName(Sender: TObject;
  var Value: String);
begin
  cmain.starshape_file:=value;
end;

procedure Tf_config_display.FileNameEdit1Change(Sender: TObject);
begin
  cmain.starshape_file:=FileNameEdit1.FileName;
end;

procedure Tf_config_display.CFStyleChange(Sender: TObject);
var i:integer;
begin
i:=CFStyle.itemindex;
if (i>=Ord(Low(TPenStyle)))and(i<=Ord(High(TPenStyle))) then
   csc.StyleConstL:=TPenStyle(i);
end;

procedure Tf_config_display.CheckBox1Click(Sender: TObject);
begin
  csc.CircleLabel:=CheckBox1.Checked;
end;

procedure Tf_config_display.CheckBox2Click(Sender: TObject);
begin
csc.RectangleLabel:=CheckBox2.Checked
end;

procedure Tf_config_display.CheckBox5Click(Sender: TObject);
begin
  csc.ShowLegend:=CheckBox5.Checked;
end;

procedure Tf_config_display.CheckBox6Click(Sender: TObject);
begin
 cmain.TextOnlyDetail := CheckBox6.Checked;
end;

procedure Tf_config_display.MarkNumberClick(Sender: TObject);
begin
csc.marknumlabel:=TCheckBox(sender).Checked;
CheckBox3.Checked:=csc.marknumlabel;
CheckBox4.Checked:=csc.marknumlabel;
end;

procedure Tf_config_display.ConstbFileAcceptFileName(Sender: TObject;
  var Value: String);
begin
if LockChange then exit;
  cmain.ConstBfile:=expandfilename(value);
end;

procedure Tf_config_display.ConstlFileAcceptFileName(Sender: TObject;
  var Value: String);
begin
if LockChange then exit;
  cmain.ConstLfile:=expandfilename(value);
end;

procedure Tf_config_display.DrawAllStarLabelClick(Sender: TObject);
begin
csc.DrawAllStarLabel:=DrawAllStarLabel.Checked;
end;

procedure Tf_config_display.GalEqStyleChange(Sender: TObject);
var i:integer;
begin
i:=GalEqStyle.itemindex;
if (i>=Ord(Low(TPenStyle)))and(i<=Ord(High(TPenStyle))) then
   csc.StyleGalEq:=TPenStyle(i);
end;

procedure Tf_config_display.EclipticStyleChange(Sender: TObject);
var i:integer;
begin
i:=EclipticStyle.itemindex;
if (i>=Ord(Low(TPenStyle)))and(i<=Ord(High(TPenStyle))) then
   csc.StyleEcliptic:=TPenStyle(i);
end;

procedure Tf_config_display.CBStyleChange(Sender: TObject);
var i:integer;
begin
i:=CBStyle.itemindex;
if (i>=Ord(Low(TPenStyle)))and(i<=Ord(High(TPenStyle))) then
   csc.StyleConstB:=TPenStyle(i);
end;

procedure Tf_config_display.StyleDrawItem(Control: TWinControl;
  Index: Integer; ARect: TRect; State: TOwnerDrawState);
var tw: integer;
begin
with  TComboBox(Control).Canvas do begin
  Pen.Style:=TPenStyle(index);
  if odSelected in State then begin
     Brush.Color:=clHighlight;
     Pen.Color:=clHighlightText;
     Font.Color:=clHighlightText;
  end else begin
     Brush.Color:=clWindow;
     Pen.Color:=clWindowText;
     Font.Color:=clWindowText;
  end;
  tw:=TextWidth(TComboBox(Control).Items[index])+5;
  FillRect(ARect);
  Textout(ARect.Left,ARect.Top,TComboBox(Control).Items[index]);
  moveto(ARect.Left+tw,(ARect.Top+ARect.Bottom) div 2);
  lineto(ARect.Right,(ARect.Top+ARect.Bottom) div 2);
end;
end;

procedure Tf_config_display.DrawPmBoxClick(Sender: TObject);
begin
csc.DrawPMon:=DrawPMBox.checked;
end;

procedure Tf_config_display.DrawPMyChange(Sender: TObject);
begin
if LockChange then exit;
csc.DrawPMyear:=DrawPMy.value;
end;


procedure Tf_config_display.NightButtonClick(Sender: TObject);
begin
  cmain.ButtonNight:=NightButton.ItemIndex+1;
end;

procedure Tf_config_display.StandardButtonClick(Sender: TObject);
begin
  cmain.ButtonStandard:=StandardButton.ItemIndex+1;
end;

procedure Tf_config_display.ThemeListChange(Sender: TObject);
begin
if LockChange then exit;
  cmain.ThemeName:=ThemeList.Text;
end;

procedure Tf_config_display.lDrawPMyChange(Sender: TObject);
begin
  end;

procedure Tf_config_display.Button7Click(Sender: TObject);
begin
  FileNameEdit1.FileName:='';
  cmain.starshape_file:='';
end;

procedure Tf_config_display.Button8Click(Sender: TObject);
begin
 cplot.Color:=DfPastelColor;
 cplot.bgcolor:=cplot.color[0];
 ShowColor;
end;

procedure Tf_config_display.BtnDefaultColorClick(Sender: TObject);
begin
 cplot.Color:=DfColor;
 cplot.bgcolor:=cplot.color[0];
 ShowColor;
end;

procedure Tf_config_display.BtnBWColorClick(Sender: TObject);
begin
 cplot.Color:=DfBWColor;
 cplot.bgcolor:=cplot.color[0];
 ShowColor;
end;

procedure Tf_config_display.BtnRedColorClick(Sender: TObject);
begin
 cplot.Color:=DfRedColor;
 cplot.bgcolor:=cplot.color[0];
 ShowColor;
end;

procedure Tf_config_display.BtnWBColorClick(Sender: TObject);
begin
 cplot.Color:=DfWBColor;
 cplot.bgcolor:=cplot.color[0];
 ShowColor;
end;

procedure Tf_config_display.Lock;
begin
  LockChange:=true;
end;

procedure Tf_config_display.ShowDisplay;
begin
 stardisplay.itemindex:=cplot.starplot;
 nebuladisplay.itemindex:=cplot.nebplot;
 StarSizeBar.position:=round(cplot.partsize*10);
 StarContrastBar.position:=cplot.contrast;
 SaturationBar.position:=cplot.saturation;
 panel7.visible:= (cplot.starplot=2);
 panel4.visible:= (cplot.starplot=0);
 panel5.visible:= (cplot.starplot=1);
 SizeContrastBar.position:=round(cplot.magsize*10);
 red_moveBox.Checked:=cplot.red_move;
 antialias.Checked:=cplot.AntiAlias;
 CheckBox6.Checked:=cmain.TextOnlyDetail;
 StarSizeBar1.position:=cplot.starsize;
 StarDynBar1.position:=cplot.stardyn;
 FileNameEdit1.FileName:=cmain.starshape_file;
// Application.ProcessMessages;
end;

procedure Tf_config_display.ShowFonts;
begin
 SetFonts(gridfont,1);
 SetFonts(labelfont,2);
 SetFonts(legendfont,3);
 SetFonts(statusfont,4);
 SetFonts(listfont,5);
 SetFonts(prtfont,6);
 SetFonts(symbfont,7);
end;

procedure Tf_config_display.ShowColor;
var fs : TSearchRec;
    buf : string;
    i,n: integer;
begin
 bg1.color:=cplot.bgColor;
 bg3.color:=cplot.bgColor;
 bg4.color:=cplot.bgColor;
 shape1.brush.color:=cplot.color[1];
 shape2.brush.color:=cplot.color[2];
 shape3.brush.color:=cplot.color[3];
 shape4.brush.color:=cplot.color[4];
 shape5.brush.color:=cplot.color[5];
 shape6.brush.color:=cplot.color[6];
 shape7.brush.color:=cplot.color[7];
 shape11.pen.color:=cplot.color[12];
 shape11.brush.color:=cplot.bgColor;
 shape12.pen.color:=cplot.color[13];
 shape12.brush.color:=cplot.bgColor;
 shape13.pen.color:=cplot.color[14];
 shape13.brush.color:=cplot.bgColor;
 shape14.pen.color:=cplot.color[15];
 shape14.brush.color:=cplot.bgColor;
 shape15.pen.color:=cplot.color[16];
 shape15.brush.color:=cplot.bgColor;
 shape16.pen.color:=cplot.color[17];
 shape16.brush.color:=cplot.bgColor;
 shape17.pen.color:=cplot.color[18];
 shape17.brush.color:=cplot.bgColor;
 shape25.brush.color:=cplot.color[19];
 shape26.brush.color:=cplot.color[20];
 shape27.brush.color:=cplot.color[21];
 shape28.brush.color:=cplot.color[22];
 StandardButton.ItemIndex:=cmain.ButtonStandard-1;
 NightButton.ItemIndex:=cmain.ButtonNight-1;
 ThemeList.clear;
 n:=0;
 i:=findfirst(slash(appdir)+slash('data')+slash('Themes')+'*',faDirectory,fs);
 while i=0 do begin
   if ((fs.attr and faDirectory)<>0)and(fs.Name<>'.')and(fs.Name<>'..') then begin
     buf:=extractfilename(fs.name);
     ThemeList.items.Add(buf);
     if cmain.ThemeName=buf then ThemeList.itemindex:=n;
     inc(n);
   end;
   i:=findnext(fs);
 end;
 findclose(fs);
end;

procedure Tf_config_display.ShowSkyColor;
begin
 if cplot.autoskycolor then skycolorbox.itemindex:=1
                       else skycolorbox.itemindex:=0;
 panel2.visible:=cplot.autoskycolor;
 shape8.pen.color:=cplot.skycolor[0];
 shape8.brush.color:=cplot.skycolor[0];
 shape18.pen.color:=cplot.skycolor[1];
 shape18.brush.color:=cplot.skycolor[1];
 shape19.pen.color:=cplot.skycolor[2];
 shape19.brush.color:=cplot.skycolor[2];
 shape20.pen.color:=cplot.skycolor[3];
 shape20.brush.color:=cplot.skycolor[3];
 shape21.pen.color:=cplot.skycolor[4];
 shape21.brush.color:=cplot.skycolor[4];
 shape22.pen.color:=cplot.skycolor[5];
 shape22.brush.color:=cplot.skycolor[5];
 shape23.pen.color:=cplot.skycolor[6];
 shape23.brush.color:=cplot.skycolor[6];
 shape24.pen.color:=cplot.skycolor[7];
 shape24.brush.color:=cplot.skycolor[7];
end;

procedure Tf_config_display.ShowNebColor;
begin
NebGrayBar.position:=cplot.NebGray;
NebBrightBar.position:=cplot.NebBright;
UpdNebColor;
end;

// ---dso color -----------------------
procedure Tf_config_display.ShowDSOColor;
var vTCBStateChecked,vTCBStateUnChecked: TCheckBoxState;
begin
{
  Now show those objects for the active base catalogs
  Allow user to change the colours of the objects that are active
}

//  if f_config_catalog1.pa_catalog.t_cdcneb.sacbox.Checked then   shpAst.Visible = False;


//  Tf_config_catalog.sacbox.Checked then shpAst.Visible = False;
{
    pa_catalog: TPageControl;
    t_catalog: TTabSheet;


ngcbox.Checked:=ccat.NebCatDef[ngc-BaseNeb];
lbnbox.Checked:=ccat.NebCatDef[lbn-BaseNeb];
rc3box.Checked:=ccat.NebCatDef[rc3-BaseNeb];
pgcbox.Checked:=ccat.NebCatDef[pgc-BaseNeb];
oclbox.Checked:=ccat.NebCatDef[ocl-BaseNeb];
gcmbox.Checked:=ccat.NebCatDef[gcm-BaseNeb];
gpnbox.Checked:=ccat.NebCatDef[gpn-BaseNeb];
}


    shpAst.Brush.Color:=cplot.Color[23];
    shpOCl.Brush.Color:=cplot.Color[24];
    shpGCl.Brush.Color:=cplot.Color[25];
    shpPNe.Brush.Color:= cplot.Color[26];
    shpDN.Brush.Color:=cplot.Color[27];
    shpEN.Brush.Color:=cplot.Color[28];
    shpRN.Brush.Color:=cplot.Color[29];
    shpSN.Brush.Color:=cplot.Color[30];
    shpGxy.Brush.Color:=cplot.Color[31];
    shpGxyCl.Brush.Color:=cplot.Color[32];
    shpQ.Brush.Color:=cplot.Color[33];
    shpGL.Brush.Color:=cplot.Color[34];
    shpNE.Brush.Color:=cplot.Color[35];

    vTCBStateChecked:=cbChecked;
    vTCBStateUnChecked:=cbUnchecked;

    If (cplot.DSOColorFillAst=true)
       then chkFillAst.State:=vTCBStateChecked
       else chkFillAst.State:=vTCBStateUnChecked;
    If (cplot.DSOColorFillOCl=true)
        then chkFillOCl.State:=vTCBStateChecked
        else chkFillOCl.State:=vTCBStateUnChecked;
    If (cplot.DSOColorFillGCl=true)
        then chkFillGCl.State:=vTCBStateChecked
        else chkFillGCl.State:=vTCBStateUnChecked;
    If (cplot.DSOColorFillPNe=true)
        then chkFillPNe.State:=vTCBStateChecked
        else chkFillPNe.State:=vTCBStateUnChecked;
    If (cplot.DSOColorFillDN=true)
        then chkFillDN.State:=vTCBStateChecked
        else chkFillDN.State:=vTCBStateUnChecked;
    If (cplot.DSOColorFillEN=true)
        then chkFillEN.State:=vTCBStateChecked
        else chkFillEN.State:=vTCBStateUnChecked;
    If (cplot.DSOColorFillRN=true)
        then chkFillRN.State:=vTCBStateChecked
        else chkFillRN.State:=vTCBStateUnChecked;
    If (cplot.DSOColorFillSN=true)
        then chkFillSN.State:=vTCBStateChecked
        else chkFillSN.State:=vTCBStateUnChecked;
    If (cplot.DSOColorFillGxy=true)
        then chkFillGxy.State:=vTCBStateChecked
        else chkFillGxy.State:=vTCBStateUnChecked;
    If (cplot.DSOColorFillGxyCl=true)
        then chkFillGxyCl.State:=vTCBStateChecked
        else chkFillGxyCl.State:=vTCBStateUnChecked;
    If (cplot.DSOColorFillQ=true)
        then chkFillQ.State:=vTCBStateChecked
        else chkFillQ.State:=vTCBStateUnChecked;
    If (cplot.DSOColorFillGL=true)
        then chkFillGL.State:=vTCBStateChecked
        else chkFillGL.State:=vTCBStateUnChecked;
    If (cplot.DSOColorFillNE=true)
        then chkFillNE.State:=vTCBStateChecked
        else chkFillNE.State:=vTCBStateUnChecked;
end;

// ------------------------------------

procedure Tf_config_display.ShowLine;
begin
EqGrid.Checked:=csc.ShowEqGrid;
CGrid.Checked:=csc.ShowGrid;
OnlyMeridian.Checked := csc.ShowOnlyMeridian;
GridNum.Checked:=csc.ShowGridNum;
ShowLines.Checked := csc.showline;
if csc.DSLforcecolor then ShowLineShape.Brush.Color:=csc.DSLcolor
   else ShowLineShape.Brush.Color:=clWhite;
Ecliptic.Checked:=csc.ShowEcliptic;
Galactic.Checked:=csc.ShowGalactic;
ConstlFile.Text:=cmain.ConstLfile;
ConstbFile.Text:=cmain.ConstBfile;
ConstL.Checked:=csc.ShowConstl;
ConstB.Checked:=csc.ShowConstb;
milkyway.Checked:=csc.ShowMilkyWay;
fillmilkyway.Checked:=csc.FillMilkyWay;
GridStyle.ItemIndex:=ord(csc.StyleGrid);
EqGridStyle.ItemIndex:=ord(csc.StyleEqGrid);
EclipticStyle.ItemIndex:=ord(csc.StyleEcliptic);
GalEqStyle.ItemIndex:=ord(csc.StyleGalEq);
CBStyle.ItemIndex:=ord(csc.StyleConstB);
CFStyle.ItemIndex:=ord(csc.StyleConstL);
DrawPMBox.checked:=csc.DrawPMon;
DrawPMy.value:=csc.DrawPMyear;
end;

procedure Tf_config_display.showlabelcolor;
begin

 labelcolorStar.brush.color:=cplot.labelcolor[1];
 labelcolorVar.brush.color:=cplot.labelcolor[2];
 labelcolorMult.brush.color:=cplot.labelcolor[3];
 labelcolorNeb.brush.color:=cplot.labelcolor[4];
 labelcolorSol.brush.color:=cplot.labelcolor[5];
 labelcolorConst.brush.color:=cplot.labelcolor[6];
 labelcolorMisc.brush.color:=cplot.labelcolor[7];
 labelcolorChartInfo.brush.color:=cplot.labelcolor[8];
end;

procedure Tf_config_display.showlabel;
begin
 showlabelStar.checked:=csc.showlabel[1];
 showlabelVar.checked:=csc.showlabel[2];
 showlabelMult.checked:=csc.showlabel[3];
 showlabelNeb.checked:=csc.showlabel[4];
 showlabelSol.checked:=csc.showlabel[5];
 showlabelConst.checked:=csc.showlabel[6];
 showlabelMisc.checked:=csc.showlabel[7];
 showlabelChartInfo.checked:=csc.showlabel[8];
 labelmagStar.position:=round(csc.labelmagdiff[1]);
 labelmagVar.position:=round(csc.labelmagdiff[2]);
 labelmagMult.position:=round(csc.labelmagdiff[3]);
 labelmagNeb.position:=round(csc.labelmagdiff[4]);
 labelmagSol.position:=round(csc.labelmagdiff[5]);
 labelsizeStar.position:=cplot.labelsize[1];
 labelsizeVar.position:=cplot.labelsize[2];
 labelsizeMult.position:=cplot.labelsize[3];
 labelsizeNeb.position:=cplot.labelsize[4];
 labelsizeSol.position:=cplot.labelsize[5];
 labelsizeConst.position:=cplot.labelsize[6];
 labelsizeMisc.position:=cplot.labelsize[7];
 labelsizeChartInfo.position:=cplot.labelsize[8];
 showlabelcolor;
 if csc.NameLabel then MagLabel.ItemIndex:=1
 else if csc.MagLabel then MagLabel.ItemIndex:=2
                      else MagLabel.itemindex:=0;
 if csc.ConstFullLabel then begin
    if csc.ConstLatinLabel then constlabel.ItemIndex:=2
                           else constlabel.ItemIndex:=0;
  end
    else constlabel.ItemIndex:=1;
 Showlabelall.checked:=csc.Showlabelall;
 ShowChartInfo.checked:=cmain.ShowChartInfo;
 ShowTitle.Checked:=cmain.ShowTitlePos;
 DrawAllStarLabel.Checked:=csc.DrawAllStarLabel;
 LabelLine.Checked := csc.MovedLabelLine;
 OptLabels.Checked:= csc.OptimizeLabels;
 CheckBox5.Checked := csc.ShowLegend;
end;

procedure Tf_config_display.ShowCircle;

var i:integer;
begin
cb1.checked:=csc.circleok[1];
cb2.checked:=csc.circleok[2];
cb3.checked:=csc.circleok[3];
cb4.checked:=csc.circleok[4];
cb5.checked:=csc.circleok[5];
cb6.checked:=csc.circleok[6];
cb7.checked:=csc.circleok[7];
cb8.checked:=csc.circleok[8];
cb9.checked:=csc.circleok[9];
cb10.checked:=csc.circleok[10];
circlegrid.ColWidths[0]:=60;
circlegrid.ColWidths[1]:=60;
circlegrid.ColWidths[2]:=60;
circlegrid.ColWidths[3]:=circlegrid.clientwidth-185;
circlegrid.Cells[0, 0]:=rsFOV;
circlegrid.Cells[1, 0]:=rsRotation;
circlegrid.Cells[2, 0]:=rsOffset;
circlegrid.Cells[3, 0]:=rsDescription;
for i:=1 to 10 do begin
  circlegrid.Cells[0,i]:=formatfloat(f2,csc.circle[i,1]);
  circlegrid.Cells[1,i]:=formatfloat(f2,csc.circle[i,2]);
  circlegrid.Cells[2,i]:=formatfloat(f2,csc.circle[i,3]);
  circlegrid.Cells[3,i]:=csc.circlelbl[i];
end;
CenterMark1.checked:=csc.ShowCircle;
CheckBox1.Checked:=csc.CircleLabel;
CheckBox3.Checked:=csc.marknumlabel;
CheckBox4.Checked:=csc.marknumlabel;
end;

procedure Tf_config_display.ShowRectangle;
var i:integer;
begin
rb1.checked:=csc.rectangleok[1];
rb2.checked:=csc.rectangleok[2];
rb3.checked:=csc.rectangleok[3];
rb4.checked:=csc.rectangleok[4];
rb5.checked:=csc.rectangleok[5];
rb6.checked:=csc.rectangleok[6];
rb7.checked:=csc.rectangleok[7];
rb8.checked:=csc.rectangleok[8];
rb9.checked:=csc.rectangleok[9];
rb10.checked:=csc.rectangleok[10];
rectanglegrid.ColWidths[0]:=60;
rectanglegrid.ColWidths[1]:=60;
rectanglegrid.ColWidths[2]:=60;
rectanglegrid.ColWidths[3]:=60;
rectanglegrid.ColWidths[4]:=rectanglegrid.clientwidth-245;
rectanglegrid.Cells[0, 0]:=rsWidth;
rectanglegrid.Cells[1, 0]:=rsHeight;
rectanglegrid.Cells[2, 0]:=rsRotation;
rectanglegrid.Cells[3, 0]:=rsOffset;
rectanglegrid.Cells[4, 0]:=rsDescription;
for i:=1 to 10 do begin
  rectanglegrid.Cells[0,i]:=formatfloat(f2,csc.rectangle[i,1]);
  rectanglegrid.Cells[1,i]:=formatfloat(f2,csc.rectangle[i,2]);
  rectanglegrid.Cells[2,i]:=formatfloat(f2,csc.rectangle[i,3]);
  rectanglegrid.Cells[3,i]:=formatfloat(f2,csc.rectangle[i,4]);
  rectanglegrid.Cells[4,i]:=csc.rectanglelbl[i];
end;
CenterMark2.checked:=csc.ShowCircle;
CheckBox2.Checked:=csc.RectangleLabel;
end;

procedure Tf_config_display.nebuladisplayClick(Sender: TObject);
begin
if LockChange then exit;
 cplot.nebplot:=nebuladisplay.itemindex;
end;

procedure Tf_config_display.red_moveBoxClick(Sender: TObject);
begin
  cplot.red_move:=red_moveBox.Checked;
end;

procedure Tf_config_display.antialiasClick(Sender: TObject);
begin
   cplot.AntiAlias := antialias.Checked;
end;

procedure Tf_config_display.stardisplayClick(Sender: TObject);
begin
if LockChange then exit;
cplot.starplot:=stardisplay.itemindex;
panel7.visible:= (cplot.starplot=2);
panel4.visible:= (cplot.starplot=0);
panel5.visible:= (cplot.starplot=1);
end;

procedure Tf_config_display.StarSizeBar1Change(Sender: TObject);
begin
if LockChange then exit;
cplot.starsize:= StarSizeBar1.position;
end;

procedure Tf_config_display.StarDynBar1Change(Sender: TObject);
begin
if LockChange then exit;
cplot.stardyn:= StarDynBar1.position;
end;

procedure Tf_config_display.StarSizeBarChange(Sender: TObject);
begin
if LockChange then exit;
cplot.partsize:= StarSizeBar.position/10;
end;

procedure Tf_config_display.SizeContrastBarChange(Sender: TObject);
begin
if LockChange then exit;
cplot.magsize:= SizeContrastBar.position/10;
end;

procedure Tf_config_display.StarContrastBarChange(Sender: TObject);
begin
if LockChange then exit;
cplot.contrast:= StarContrastBar.position;
end;

procedure Tf_config_display.SaturationBarChange(Sender: TObject);
begin
if LockChange then exit;
cplot.saturation:= SaturationBar.position;
end;

procedure Tf_config_display.StarButton1Click(Sender: TObject);
begin
StarSizeBar.Position:=12;
SizeContrastBar.Position:=40;
StarContrastBar.Position:=450;
SaturationBar.Position:=255;
cplot.partsize:= StarSizeBar.position/10;
cplot.magsize:= SizeContrastBar.position/10;
cplot.contrast:= StarContrastBar.position;
cplot.saturation:= SaturationBar.position;
end;

procedure Tf_config_display.StarButton2Click(Sender: TObject);
begin
StarSizeBar.Position:=12;
SizeContrastBar.Position:=10;
StarContrastBar.Position:=400;
SaturationBar.Position:=192;
cplot.partsize:= StarSizeBar.position/10;
cplot.magsize:= SizeContrastBar.position/10;
cplot.contrast:= StarContrastBar.position;
cplot.saturation:= SaturationBar.position;
end;

procedure Tf_config_display.StarButton3Click(Sender: TObject);
begin
StarSizeBar.Position:=25;
SizeContrastBar.Position:=40;
StarContrastBar.Position:=300;
SaturationBar.Position:=255;
cplot.partsize:= StarSizeBar.position/10;
cplot.magsize:= SizeContrastBar.position/10;
cplot.contrast:= StarContrastBar.position;
cplot.saturation:= SaturationBar.position;
end;

procedure Tf_config_display.StarButton4Click(Sender: TObject);
begin
StarSizeBar.Position:=12;
SizeContrastBar.Position:=40;
StarContrastBar.Position:=500;
SaturationBar.Position:=0;
cplot.partsize:= StarSizeBar.position/10;
cplot.magsize:= SizeContrastBar.position/10;
cplot.contrast:= StarContrastBar.position;
cplot.saturation:= SaturationBar.position;
end;

procedure Tf_config_display.SetFonts(ctrl:Tedit;num:integer);
begin
 ctrl.Text:=cplot.FontName[num];
{$ifdef mswindows}
 ctrl.Font.Name:=cplot.FontName[num];
 ctrl.Font.Size:=cplot.FontSize[num];
 if cplot.FontBold[num] then ctrl.Font.Style:=[fsBold]
                        else ctrl.Font.Style:=[];
 if cplot.FontItalic[num] then ctrl.Font.Style:=ctrl.Font.Style+[fsItalic];
{$endif}
end;

procedure Tf_config_display.SelectFontClick(Sender: TObject);
var i,p : integer;
    fontn: string;
begin
if sender is Tspeedbutton then with sender as Tspeedbutton do i:=tag
   else exit;
Fontdialog1.Font.Name:=cplot.FontName[i];
Fontdialog1.Font.Size:=cplot.FontSize[i];
if cplot.FontBold[i] then Fontdialog1.Font.Style:=[fsBold]
                     else Fontdialog1.Font.Style:=[];
if cplot.FontItalic[i] then Fontdialog1.Font.Style:=Fontdialog1.Font.Style+[fsItalic];
if Fontdialog1.Execute then begin
   fontn:=Fontdialog1.Font.Name;
   // keep only the name from the selected font
   //  '-bitstream-bitstream vera sans-medium-r-normal-*-*-140-*-*-p-*-iso8859-1'
   p:=pos('-',fontn);
   if p>0 then begin
     Delete(fontn,1,p);
     p:=pos('-',fontn);
     if p>0 then Delete(fontn,1,p);
     p:=pos('-',fontn);
     if p>0 then fontn:=Copy(fontn,1,p-1);
   end;
   if fontn<>'' then begin
     cplot.FontName[i]:=fontn;
     // assign other font properties
     cplot.FontSize[i]:=Fontdialog1.Font.Size;
     cplot.FontBold[i]:=fsBold in Fontdialog1.Font.Style;
     cplot.FontItalic[i]:=fsItalic in Fontdialog1.Font.Style;
   end;
end;
ShowFonts;
end;

procedure Tf_config_display.DefaultFontClick(Sender: TObject);
var i : integer;
begin
for i:=1 to numfont do begin
    cplot.FontName[i]:=DefaultFontName;
    cplot.FontSize[i]:=DefaultFontSize;
    cplot.FontBold[i]:=false;
    cplot.FontItalic[i]:=false;
end;
cplot.FontName[5]:=DefaultFontFixed;
cplot.FontName[7]:='Symbol';
ShowFonts;
end;

procedure Tf_config_display.ShapeMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
if sender is TShape then with sender as TShape do begin
   ColorDialog1.color:=cplot.Color[tag];
   if ColorDialog1.Execute then begin
      cplot.Color[tag]:=ColorDialog1.Color;
      ShowColor;
   end;
end;
end;

procedure Tf_config_display.skycolorboxClick(Sender: TObject);
begin
cplot.autoskycolor:=(skycolorbox.itemindex=1);
panel2.visible:=cplot.autoskycolor;
end;

procedure Tf_config_display.ShapeSkyMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
if sender is TShape then with sender as TShape do begin
   ColorDialog1.color:=cplot.SkyColor[tag];
   if ColorDialog1.Execute then begin
      cplot.SkyColor[tag]:=ColorDialog1.Color;
      ShowSkyColor;
   end;
end;
end;

procedure Tf_config_display.Button3Click(Sender: TObject);
begin
cplot.SkyColor:=dfSkyColor;
ShowSkyColor;
end;

procedure Tf_config_display.ShapeDSOMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
if sender is TShape then
   with sender as TShape do begin
   ColorDialog1.color:=cplot.Color[23];
   if ColorDialog1.Execute then begin
      if sender = shpAst then begin
         cplot.Color[23]:=ColorDialog1.Color;
         shpAst.Brush.Color:= cplot.Color[23]
//         ShowSkyColor;
      end;
      if sender = shpOCl then begin
          cplot.Color[24]:=ColorDialog1.Color;
          shpOCl.Brush.Color:= cplot.Color[24];
//         ShowSkyColor;
      end;
      if sender = shpGCl then begin
          cplot.Color[25]:=ColorDialog1.Color;
          shpGCl.Brush.Color:= cplot.Color[25];
//         ShowSkyColor;
      end;
      if sender = shpPNe then begin
          cplot.Color[26]:=ColorDialog1.Color;
          shpPNe.Brush.Color:= cplot.Color[26];
//         ShowSkyColor;
      end;
      if sender = shpDN then begin
          cplot.Color[27]:=ColorDialog1.Color;
          shpDN.Brush.Color:= cplot.Color[27];
//         ShowSkyColor;
      end;
      if sender = shpEN then begin
          cplot.Color[28]:=ColorDialog1.Color;
          shpEN.Brush.Color:= cplot.Color[28];
//         ShowSkyColor;
      end;
      if sender = shpRN then begin
          cplot.Color[29]:=ColorDialog1.Color;
          shpRN.Brush.Color:= cplot.Color[29];
//         ShowSkyColor;
      end;
      if sender = shpSN then begin
          cplot.Color[30]:=ColorDialog1.Color;
          shpSN.Brush.Color:= cplot.Color[30];
//         ShowSkyColor;
      end;
      if sender = shpGxy then begin
          cplot.Color[31]:=ColorDialog1.Color;
          shpGxy.Brush.Color:= cplot.Color[31]
//         ShowSkyColor;
      end;
      if sender = shpGxyCl then begin
          cplot.Color[32]:=ColorDialog1.Color;
          shpGxyCl.Brush.Color:= cplot.Color[32];
//         ShowSkyColor;
      end;
      if sender = shpQ then begin
          cplot.Color[33]:=ColorDialog1.Color;
          shpQ.Brush.Color:= cplot.Color[33];
//         ShowSkyColor;
      end;
      if sender = shpGL then begin
          cplot.Color[34]:=ColorDialog1.Color;
          shpGL.Brush.Color:= cplot.Color[34];
//         ShowSkyColor;
      end;
      if sender = shpNE then begin
          cplot.Color[35]:=ColorDialog1.Color;
          shpNE.Brush.Color:= cplot.Color[35];
//         ShowSkyColor;
      end;
   end;
end;
end;

procedure Tf_config_display.FillDSOMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
if sender is TCheckBox then
   with sender as TCheckBox do begin
   cplot.DSOColorFillOCl:=false;
   if sender = chkFillGCl then cplot.DSOColorFillOCl:=true;
   end;
end;

procedure Tf_config_display.UpdNebColor;
  function SetColor(i,col:integer):Tcolor;
   var r,g,b: byte;
   begin
     r:=cplot.Color[i] and $FF;
     g:=(cplot.Color[i] shr 8) and $FF;
     b:=(cplot.Color[i] shr 16) and $FF;
     result:=(r*col div 255)+256*(g*col div 255)+65536*(b*col div 255);
   end;
begin
NebColorPanel.color:=cplot.Color[0];
shape29.brush.color:=SetColor(8,cplot.NebGray);
shape30.brush.color:=SetColor(8,cplot.NebBright);
end;

procedure Tf_config_display.NebShapeMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
if sender is TShape then with sender as TShape do begin
   ColorDialog1.color:=cplot.Color[tag];
   if ColorDialog1.Execute then begin
      cplot.Color[tag]:=ColorDialog1.Color;
      UpdNebColor;
   end;
end;
end;

procedure Tf_config_display.NebGrayBarChange(Sender: TObject);
begin
if LockChange then exit;
if NebGrayBar.position < cplot.NebBright then begin
   cplot.NebGray:=NebGrayBar.position;
   UpdNebColor;
end else begin
   NebGrayBar.position:=cplot.NebBright-1;
end;
end;

procedure Tf_config_display.NebBrightBarChange(Sender: TObject);
begin
if LockChange then exit;
if NebBrightBar.position > cplot.NebGray then begin
   cplot.NebBright:=NebBrightBar.position;
   UpdNebColor;
end else begin
   NebBrightBar.position:=cplot.NebGray+1;
end;
end;

procedure Tf_config_display.DefNebColorButtonClick(Sender: TObject);
begin
cplot.Nebgray:=55;
cplot.NebBright:=180;
ShowNebColor;
end;

procedure Tf_config_display.CGridClick(Sender: TObject);
begin
  csc.ShowGrid:=CGrid.Checked;
end;

procedure Tf_config_display.OnlyMeridianClick(Sender: TObject);
begin
  csc.ShowOnlyMeridian:=OnlyMeridian.Checked;
end;

procedure Tf_config_display.OptLabelsClick(Sender: TObject);
begin
   csc.OptimizeLabels := OptLabels.Checked;
end;

procedure Tf_config_display.EqGridClick(Sender: TObject);
begin
  csc.ShowEqGrid:=EqGrid.Checked;
end;

procedure Tf_config_display.GridNumClick(Sender: TObject);
begin
  csc.ShowGridNum:=GridNum.Checked;
end;

procedure Tf_config_display.eclipticClick(Sender: TObject);
begin
  csc.Showecliptic:=ecliptic.Checked;
end;

procedure Tf_config_display.galacticClick(Sender: TObject);
begin
  csc.Showgalactic:=galactic.Checked;
end;

procedure Tf_config_display.ConstlClick(Sender: TObject);
begin
  csc.ShowConstl:=ConstL.Checked;
end;

procedure Tf_config_display.ConstlFileChange(Sender: TObject);
begin
if LockChange then exit;
  cmain.ConstLfile:=expandfilename(ConstlFile.Text);
end;

procedure Tf_config_display.ConstbClick(Sender: TObject);
begin
  csc.ShowConstb:=ConstB.Checked;
end;

procedure Tf_config_display.ConstbFileChange(Sender: TObject);
begin
if LockChange then exit;
  cmain.ConstBfile:=expandfilename(ConstbFile.Text);
end;

procedure Tf_config_display.milkywayClick(Sender: TObject);
begin
  csc.showmilkyway:=milkyway.checked;
end;

procedure Tf_config_display.fillmilkywayClick(Sender: TObject);
begin
  csc.fillmilkyway:=fillmilkyway.checked;
end;

procedure Tf_config_display.showlabelClick(Sender: TObject);
begin
with sender as TCheckBox do csc.ShowLabel[tag]:=checked;
end;

procedure Tf_config_display.showlabelallClick(Sender: TObject);
begin
csc.Showlabelall:=Showlabelall.checked;
end;

procedure Tf_config_display.ShowChartInfoClick(Sender: TObject);
begin
cmain.ShowChartInfo:=ShowChartInfo.checked;
end;

procedure Tf_config_display.ShowTitleClick(Sender: TObject);
begin
cmain.ShowTitlePos:=ShowTitle.Checked;
end;

procedure Tf_config_display.labelmagChanged(Sender: TObject; Button: TUDBtnType);
begin
if LockChange then exit;
with sender as TUpDown do csc.LabelmagDiff[tag]:=Position;
end;

procedure Tf_config_display.labelsizeChanged(Sender: TObject; Button: TUDBtnType);
begin
if LockChange then exit;
with sender as TUpDown do cplot.LabelSize[tag]:=Position;
end;

procedure Tf_config_display.labelcolorMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
if sender is TShape then with sender as TShape do begin
   ColorDialog1.color:=cplot.LabelColor[tag];
   if ColorDialog1.Execute then begin
      cplot.LabelColor[tag]:=ColorDialog1.Color;
      ShowLabelColor;
   end;
end;
end;

procedure Tf_config_display.Button9Click(Sender: TObject);
var i: integer;
begin
for i:=1 to numlabtype do begin
   cplot.LabelColor[i]:=clWhite;
   cplot.LabelSize[i]:=DefaultFontSize;
   csc.LabelMagDiff[i]:=4;
   csc.ShowLabel[i]:=true;
end;
csc.LabelMagDiff[1]:=3;
csc.LabelMagDiff[5]:=2;
cplot.LabelColor[6]:=clYellow;
cplot.LabelColor[7]:=clSilver;
cplot.LabelSize[6]:=cplot.LabelSize[6]+2;
csc.Showlabelall:=true;
cmain.ShowChartInfo:=false;
cmain.ShowTitlePos:=false;
csc.DrawAllStarLabel:=false;
csc.MovedLabelLine:=true;
csc.NameLabel:=false;
csc.MagLabel:=false;
csc.ConstFullLabel:=true;
csc.ConstLatinLabel:=false;
ShowLabel;
ShowLabelColor;
end;

procedure Tf_config_display.MagLabelClick(Sender: TObject);
begin
csc.MagLabel:=(MagLabel.ItemIndex=2);
csc.NameLabel:=(MagLabel.ItemIndex=1);
end;

procedure Tf_config_display.constlabelClick(Sender: TObject);
begin
csc.ConstFullLabel:=(constlabel.ItemIndex<>1);
csc.ConstLatinLabel:=(constlabel.ItemIndex=2);
end;


procedure Tf_config_display.cbClick(Sender: TObject);
begin
 with Sender as TCheckBox do csc.circleok[tag]:=checked;
end;

procedure Tf_config_display.CirclegridSetEditText(Sender: TObject; ACol,ARow: Integer; const Value: String);
var x:single;
    n:integer;
begin
case ACol of
0 : begin
    val(value,x,n);
    if n=0 then csc.circle[Arow,1]:=x
           else beep;
    end;
1 : begin
    val(value,x,n);
    if n=0 then csc.circle[Arow,2]:=x
           else beep;
    end;
2 : begin
    val(value,x,n);
    if n=0 then csc.circle[Arow,3]:=x
           else beep;
    end;
3 : begin
    csc.circlelbl[ARow]:=Value;
    end;
end;
end;

procedure Tf_config_display.CenterMark1Click(Sender: TObject);
begin
with sender as TCheckbox do begin
 csc.ShowCircle:=checked;
 CenterMark1.checked:=checked;
 CenterMark2.checked:=checked;
end;
end;

procedure Tf_config_display.RectangleGridSetEditText(Sender: TObject; ACol,ARow: Integer; const Value: String);
var x:single;
    n:integer;
begin
case ACol of
0 : begin
    val(value,x,n);
    if n=0 then csc.rectangle[Arow,1]:=x
           else beep;
    end;
1 : begin
    val(value,x,n);
    if n=0 then csc.rectangle[Arow,2]:=x
           else beep;
    end;
2 : begin
    val(value,x,n);
    if n=0 then csc.rectangle[Arow,3]:=x
           else beep;
    end;
3 : begin
    val(value,x,n);
    if n=0 then csc.rectangle[Arow,4]:=x
           else beep;
    end;
4 : begin
    csc.rectanglelbl[ARow]:=Value;
    end;
end;
end;

procedure Tf_config_display.rbClick(Sender: TObject);
begin
with Sender as TCheckBox do csc.rectangleok[tag]:=checked;
end;


procedure Tf_config_display.chkFillAstClick(Sender: TObject);
begin
with sender as TCheckbox do begin
  if chkFillAst.Checked
    then cplot.DSOColorFillAst:=true
    else cplot.DSOColorFillAst:=false;
  end;
end;

procedure Tf_config_display.chkFillOClClick(Sender: TObject);
begin
with sender as TCheckbox do begin
  if chkFillOCl.Checked
    then cplot.DSOColorFillOCl:=true
    else cplot.DSOColorFillOCl:=false;
end;
end;

procedure Tf_config_display.chkFillPNeClick(Sender: TObject);
begin
with sender as TCheckbox do begin
  if chkFillPNe.Checked
    then cplot.DSOColorFillPNe:=true
    else cplot.DSOColorFillPNe:=false;
end;
end;

procedure Tf_config_display.chkFillGClClick(Sender: TObject);
begin
with sender as TCheckbox do begin
  if chkFillGCl.Checked
    then cplot.DSOColorFillGCl:=true
    else cplot.DSOColorFillGCl:=false;
end;
end;

procedure Tf_config_display.chkFillDNClick(Sender: TObject);
begin
with sender as TCheckbox do begin
  if chkFillDN.Checked
    then cplot.DSOColorFillDN:=true
    else cplot.DSOColorFillDN:=false;
  end;
end;

procedure Tf_config_display.chkFillENClick(Sender: TObject);
begin
with sender as TCheckbox do begin
  if chkFillEN.Checked
    then cplot.DSOColorFillEN:=true
    else cplot.DSOColorFillEN:=false;
  end;
end;

procedure Tf_config_display.chkFillRNClick(Sender: TObject);
begin
with sender as TCheckbox do begin
  if chkFillRN.Checked
    then cplot.DSOColorFillRN:=true
    else cplot.DSOColorFillRN:=false;
  end;
end;

procedure Tf_config_display.chkFillSNClick(Sender: TObject);
begin
with sender as TCheckbox do begin
  if chkFillSN.Checked
    then cplot.DSOColorFillSN:=true
    else cplot.DSOColorFillSN:=false;
  end;
end;

procedure Tf_config_display.chkFillGxyClick(Sender: TObject);
begin
with sender as TCheckbox do begin
  if chkFillGxy.Checked
    then cplot.DSOColorFillGxy:=true
    else cplot.DSOColorFillGxy:=false;
  end;
end;

procedure Tf_config_display.chkFillGxyClClick(Sender: TObject);
begin
with sender as TCheckbox do begin
  if chkFillGxyCl.Checked
    then cplot.DSOColorFillGxyCl:=true
    else cplot.DSOColorFillGxyCl:=false;
  end;
end;

procedure Tf_config_display.chkFillQClick(Sender: TObject);
begin
with sender as TCheckbox do begin
  if chkFillQ.Checked
    then cplot.DSOColorFillQ:=true
    else cplot.DSOColorFillQ:=false;
  end;
end;

procedure Tf_config_display.chkFillGLClick(Sender: TObject);
begin
with sender as TCheckbox do begin
  if chkFillGL.Checked
    then cplot.DSOColorFillGL:=true
    else cplot.DSOColorFillGL:=false;
  end;
end;

procedure Tf_config_display.chkFillNEClick(Sender: TObject);
begin
with sender as TCheckbox do begin
  if chkFillNE.Checked
    then cplot.DSOColorFillNE:=true
    else cplot.DSOColorFillNE:=false;
  end;
end;

procedure Tf_config_display.lstDSOCSchemeChange(Sender: TObject);
var
  i: Integer;
begin
i:=lstDSOCScheme.ItemIndex;
        case i of
//        CdC v2.nn
          0: begin //CdC v2.nn
              shpAst.Brush.Color:=16776960;
              shpOCl.Brush.Color:=16776960;
              shpGCl.Brush.Color:=16776960;
              shpPNe.Brush.Color:=8454016;
              shpDN.Brush.Color:=4210752;
              shpEN.Brush.Color:=8454016;
              shpRN.Brush.Color:=8454016;
              shpSN.Brush.Color:=0;
              shpGxy.Brush.Color:=255;
              shpGxyCl.Brush.Color:=255;
              shpQ.Brush.Color:=0;
              shpGL.Brush.Color:=0;
              shpNE.Brush.Color:=16777215;
             end;
          1: begin //CdC v3.nn
              shpAst.Brush.Color:=45311;
              shpOCl.Brush.Color:=45311;
              shpGCl.Brush.Color:=16777088;
              shpPNe.Brush.Color:=8453888;
              shpDN.Brush.Color:=4210752;
              shpEN.Brush.Color:=255;
              shpRN.Brush.Color:=16744448;
              shpSN.Brush.Color:=0;
              shpGxy.Brush.Color:=255;
              shpGxyCl.Brush.Color:=255;
              shpQ.Brush.Color:=8421631;
              shpGL.Brush.Color:=16711808;
              shpNE.Brush.Color:=16777215;
             end;
          2: begin //Tirion Sky Atlas 2000
              shpAst.Brush.Color:=45311;
              shpOCl.Brush.Color:=45311;
              shpGCl.Brush.Color:=32696;
              shpPNe.Brush.Color:=4259584;
              shpDN.Brush.Color:=8421504;
              shpEN.Brush.Color:=16711935;
              shpRN.Brush.Color:=16711935;
              shpSN.Brush.Color:=4227327;
              shpGxy.Brush.Color:=255;
              shpGxyCl.Brush.Color:=255;
              shpQ.Brush.Color:=255;
              shpGL.Brush.Color:=16776960;
              shpNE.Brush.Color:=12632256;
             end;
          3: begin //Megastar
              shpAst.Brush.Color:=4259584;
              shpOCl.Brush.Color:=4259584;
              shpGCl.Brush.Color:=4259584;
              shpPNe.Brush.Color:=4259584;
              shpDN.Brush.Color:=4259584;
              shpEN.Brush.Color:=4259584;
              shpRN.Brush.Color:=4259584;
              shpSN.Brush.Color:=4259584;
              shpGxy.Brush.Color:=4259584;
              shpGxyCl.Brush.Color:=4259584;
              shpQ.Brush.Color:=4259584;
              shpGL.Brush.Color:=4259584;
              shpNE.Brush.Color:=4259584;
             end;
          end;
          cplot.Color[23]:=shpAst.Brush.Color;
          cplot.Color[24]:=shpOCl.Brush.Color;
          cplot.Color[25]:=shpGCl.Brush.Color;
          cplot.Color[26]:=shpPNe.Brush.Color;
          cplot.Color[27]:=shpDN.Brush.Color;
          cplot.Color[28]:=shpEN.Brush.Color;
          cplot.Color[29]:=shpRN.Brush.Color;
          cplot.Color[30]:=shpSN.Brush.Color;
          cplot.Color[31]:=shpGxy.Brush.Color;
          cplot.Color[32]:=shpGxyCl.Brush.Color;
          cplot.Color[33]:=shpQ.Brush.Color;
          cplot.Color[34]:=shpGL.Brush.Color;
          cplot.Color[35]:=shpNE.Brush.Color;
end;

procedure Tf_config_display.Page3Show(Sender: TObject);
begin
    if cplot.nebplot=0 then begin
      FillPanel1.Visible:=false;
      FillPanel2.Visible:=false;
    end else begin
      FillPanel1.Visible:=true;
      FillPanel2.Visible:=true;
    end;
end;

procedure Tf_config_display.ShowLinesClick(Sender: TObject);
begin
  csc.showline:=ShowLines.Checked;
end;

procedure Tf_config_display.ShowLineShapeMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var buf: string;
begin
  buf:=ColorDialog1.Title;
  ColorDialog1.Title:=rsSelectColorB;
  ColorDialog1.Color:=csc.DSLcolor;
  if ColorDialog1.Execute then begin
     csc.DSLforcecolor:=(ColorDialog1.Color<>0);
     csc.DSLcolor:=ColorDialog1.Color;
     if csc.DSLforcecolor then ShowLineShape.Brush.Color:=csc.DSLcolor
        else ShowLineShape.Brush.Color:=clWhite;
  end;
  ColorDialog1.Title := buf;
end;

end.
