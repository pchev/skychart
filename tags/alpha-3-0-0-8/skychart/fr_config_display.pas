unit fr_config_display;
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

uses  u_constant,
  SysUtils, Types, Classes, Variants, QTypes, QGraphics, QControls, QForms, 
  QDialogs, QGrids, QComCtrls, QButtons, QStdCtrls, QExtCtrls;

type
  Tf_config_display = class(TFrame)
    pa_display: TPageControl;
    t_display: TTabSheet;
    Label14: TLabel;
    stardisplay: TRadioGroup;
    nebuladisplay: TRadioGroup;
    starvisual: TGroupBox;
    StarSizeBar: TTrackBar;
    StarContrastBar: TTrackBar;
    SaturationBar: TTrackBar;
    Label75: TLabel;
    Label262: TLabel;
    Label263: TLabel;
    SizeContrastBar: TTrackBar;
    Label264: TLabel;
    StarButton1: TButton;
    StarButton2: TButton;
    StarButton3: TButton;
    StarButton4: TButton;
    t_fonts: TTabSheet;
    Bevel10: TBevel;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    SpeedButton4: TSpeedButton;
    SpeedButton5: TSpeedButton;
    SpeedButton6: TSpeedButton;
    SpeedButton7: TSpeedButton;
    Label51: TLabel;
    Label121: TLabel;
    Label122: TLabel;
    Label123: TLabel;
    Label124: TLabel;
    Label125: TLabel;
    Label126: TLabel;
    Label127: TLabel;
    Label128: TLabel;
    Label129: TLabel;
    gridfont: TEdit;
    labelfont: TEdit;
    legendfont: TEdit;
    statusfont: TEdit;
    listfont: TEdit;
    prtfont: TEdit;
    Button1: TButton;
    Label235: TLabel;
    symbfont: TEdit;
    t_color: TTabSheet;
    Label8: TLabel;
    bg1: TPanel;
    Shape1: TShape;
    Shape2: TShape;
    Shape3: TShape;
    Shape4: TShape;
    Shape5: TShape;
    Shape6: TShape;
    Shape7: TShape;
    Label181: TLabel;
    Label182: TLabel;
    Label183: TLabel;
    Label184: TLabel;
    Label185: TLabel;
    Label186: TLabel;
    Label187: TLabel;
    Label188: TLabel;
    Label189: TLabel;
    bg2: TPanel;
    Shape8: TShape;
    Shape9: TShape;
    Shape10: TShape;
    Shape11: TShape;
    Shape12: TShape;
    Shape13: TShape;
    Label190: TLabel;
    Label191: TLabel;
    Label192: TLabel;
    Label193: TLabel;
    Label194: TLabel;
    Label195: TLabel;
    bg3: TPanel;
    Shape15: TShape;
    Shape16: TShape;
    Shape17: TShape;
    Shape14: TShape;
    Shape25: TShape;
    Label197: TLabel;
    Label198: TLabel;
    Label199: TLabel;
    Label196: TLabel;
    DefColor: TRadioGroup;
    Label11: TLabel;
    Label256: TLabel;
    Label257: TLabel;
    bg4: TPanel;
    Shape26: TShape;
    Shape27: TShape;
    Shape28: TShape;
    t_skycolor: TTabSheet;
    Label200: TLabel;
    skycolorbox: TRadioGroup;
    Panel6: TPanel;
    Shape18: TShape;
    Shape19: TShape;
    Shape20: TShape;
    Shape21: TShape;
    Shape22: TShape;
    Shape23: TShape;
    Shape24: TShape;
    Label202: TLabel;
    Label205: TLabel;
    Label208: TLabel;
    Button3: TButton;
    t_nebcolor: TTabSheet;
    Label201: TLabel;
    t_lines: TTabSheet;
    Bevel6: TBevel;
    Bevel11: TBevel;
    Bevel12: TBevel;
    Label9: TLabel;
    EqGrid: TCheckBox;
    CGrid: TCheckBox;
    Constl: TCheckBox;
    ConstlFile: TEdit;
    Label180: TLabel;
    ConstlFileBtn: TBitBtn;
    Constb: TCheckBox;
    ConstbFile: TEdit;
    Label56: TLabel;
    ConstbfileBtn: TBitBtn;
    ecliptic: TCheckBox;
    galactic: TCheckBox;
    milkyway: TCheckBox;
    fillmilkyway: TCheckBox;
    GridNum: TCheckBox;
    t_labels: TTabSheet;
    labelcolorStar: TShape;
    labelcolorVar: TShape;
    labelcolorMult: TShape;
    labelcolorNeb: TShape;
    labelcolorSol: TShape;
    labelcolorMisc: TShape;
    labelcolorConst: TShape;
    Label10: TLabel;
    Label236: TLabel;
    Label237: TLabel;
    Label240: TLabel;
    Label252: TLabel;
    Label255: TLabel;
    labelsizeStar: TSpinEdit;
    labelmagStar: TSpinEdit;
    showlabelStar: TCheckBox;
    labelsizeVar: TSpinEdit;
    labelmagVar: TSpinEdit;
    showlabelVar: TCheckBox;
    labelsizeMult: TSpinEdit;
    LabelmagMult: TSpinEdit;
    showlabelMult: TCheckBox;
    labelsizeNeb: TSpinEdit;
    labelmagNeb: TSpinEdit;
    showlabelNeb: TCheckBox;
    labelsizeSol: TSpinEdit;
    labelmagSol: TSpinEdit;
    showlabelSol: TCheckBox;
    labelsizeMisc: TSpinEdit;
    showlabelMisc: TCheckBox;
    showlabelConst: TCheckBox;
    labelsizeConst: TSpinEdit;
    MagLabel: TRadioGroup;
    constlabel: TRadioGroup;
    t_circle: TTabSheet;
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
    Label307: TLabel;
    Circlegrid: TStringGrid;
    CenterMark1: TCheckBox;
    t_rectangle: TTabSheet;
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
    Label308: TLabel;
    RectangleGrid: TStringGrid;
    CenterMark2: TCheckBox;
    OpenDialog1: TOpenDialog;
    FontDialog1: TFontDialog;
    ColorDialog1: TColorDialog;
    NebGrayBar: TTrackBar;
    NebBrightBar: TTrackBar;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    NebColorPanel: TPanel;
    Shape29: TShape;
    Shape30: TShape;
    Shape31: TShape;
    Shape32: TShape;
    Shape33: TShape;
    Shape34: TShape;
    DefNebColorButton: TButton;
    showlabelall: TCheckBox;
    procedure FormShow(Sender: TObject);
    procedure nebuladisplayClick(Sender: TObject);
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
    procedure DefColorClick(Sender: TObject);
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
    procedure ConstlFileBtnClick(Sender: TObject);
    procedure ConstbClick(Sender: TObject);
    procedure ConstbFileChange(Sender: TObject);
    procedure ConstbfileBtnClick(Sender: TObject);
    procedure milkywayClick(Sender: TObject);
    procedure fillmilkywayClick(Sender: TObject);
    procedure showlabelClick(Sender: TObject);
    procedure labelcolorMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure labelsizeChanged(Sender: TObject; NewValue: Integer);
    procedure labelmagChanged(Sender: TObject; NewValue: Integer);
    procedure MagLabelClick(Sender: TObject);
    procedure constlabelClick(Sender: TObject);
    procedure CirclegridSetEditText(Sender: TObject; ACol, ARow: Integer;
      const Value: WideString);
    procedure cbClick(Sender: TObject);
    procedure CenterMark1Click(Sender: TObject);
    procedure RectangleGridSetEditText(Sender: TObject; ACol,
      ARow: Integer; const Value: WideString);
    procedure rbClick(Sender: TObject);
    procedure NebShapeMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure NebGrayBarChange(Sender: TObject);
    procedure NebBrightBarChange(Sender: TObject);
    procedure DefNebColorButtonClick(Sender: TObject);
    procedure showlabelallClick(Sender: TObject);
  private
    { Private declarations }
    procedure ShowDisplay;
    procedure ShowFonts;
    procedure ShowColor;
    procedure ShowSkyColor;
    procedure ShowNebColor;
    procedure ShowLine;
    procedure ShowLabelColor;
    procedure Showlabel;    
    procedure ShowCircle;
    procedure ShowRectangle;
    procedure SetFonts(ctrl:Tedit;num:integer);
    procedure UpdNebColor;
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
  f_config_display: Tf_config_display;

implementation

{$R *.xfm}

// include all cross-platform common code.
// you can temporarily copy the file content here
// to use the IDE facilities

{$include i_config_display.pas}

// end of common code

end.