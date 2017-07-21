unit pu_catgen;

{
Copyright (C) 2006 Patrick Chevalley

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

{$MODE objfpc}{$H+}

interface

uses
  u_help, u_translation, u_constant, u_util, pu_progressbar, pu_catgenadv,
  GSCconst, skylibcat, gcatunit,
  SysUtils, Classes, Graphics, Controls, Forms, Dialogs, UScaleDPI,
  StdCtrls, ExtCtrls, ComCtrls, CheckLst, EnhEdits,
  Buttons, Math, Inifiles, Grids, mwFixedRecSort, mwCompFrom,
  LResources, EditBtn, LazHelpHTML;

const
  l_sup = 10;

type

  { Tf_catgen }

  Tf_catgen = class(TForm)
    Button13: TButton;
    CheckBox8: TCheckBox;
    CheckBox9: TCheckBox;
    Edit6: TEdit;
    Label22: TLabel;
    Label23: TLabel;
    ListBox1: TListBox;
    Memo1: TMemo;
    PageControl1: TPageControl;
    binarycat: TRadioGroup;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    TabSheet4: TTabSheet;
    RadioGroup1: TRadioGroup;
    CheckListBox1: TCheckListBox;
    Edit1: TEdit;
    Edit2: TEdit;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label2: TLabel;
    RadioGroup2: TRadioGroup;
    RadioGroup3: TRadioGroup;
    GroupBox1: TGroupBox;
    FloatEdit1: TFloatEdit;
    Label1: TLabel;
    RadioGroup4: TRadioGroup;
    GroupBox3: TGroupBox;
    DirectoryEdit1: TDirectoryEdit;
    GroupBox4: TGroupBox;
    FloatEdit2: TFloatEdit;
    GroupBox5: TGroupBox;
    ComboBox1: TComboBox;
    LongEdit1: TLongEdit;
    Label11: TLabel;
    Label12: TLabel;
    CheckBox1: TCheckBox;
    Edit3: TEdit;
    Label3: TLabel;
    Label10: TLabel;
    Edit4: TEdit;
    Label13: TLabel;
    Edit5: TEdit;
    Panel1: TPanel;
    prevbt: TButton;
    nextbt: TButton;
    Endbt: TButton;
    Exitbt: TButton;
    Image1: TImage;
    GroupBox2: TGroupBox;
    FloatEdit3: TFloatEdit;
    SpeedButton1: TSpeedButton;
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    Button2: TButton;
    Button1: TButton;
    ComboBox3: TComboBox;
    TabSheet5: TTabSheet;
    StringGrid1: TStringGrid;
    Label9: TLabel;
    Button3: TButton;
    Button4: TButton;
    TabSheet6: TTabSheet;
    Label14: TLabel;
    StringGrid2: TStringGrid;
    Button5: TButton;
    Button6: TButton;
    Label15: TLabel;
    Label16: TLabel;
    CheckBox2: TCheckBox;
    GroupBox6: TGroupBox;
    CheckBox3: TCheckBox;
    CheckBox4: TCheckBox;
    CheckBox6: TCheckBox;
    Button7: TButton;
    TabSheet7: TTabSheet;
    Label17: TLabel;
    StringGrid3: TStringGrid;
    Button8: TButton;
    GroupBox7: TGroupBox;
    Button9: TButton;
    LongEdit2: TLongEdit;
    Label18: TLabel;
    ColorDialog1: TColorDialog;
    Label19: TLabel;
    Shape1: TShape;
    TabSheet8: TTabSheet;
    Label20: TLabel;
    StringGrid4: TStringGrid;
    Button10: TButton;
    Shape2: TShape;
    Shape3: TShape;
    Shape4: TShape;
    Shape5: TShape;
    Shape6: TShape;
    Shape7: TShape;
    Shape8: TShape;
    Shape9: TShape;
    Shape10: TShape;
    Shape11: TShape;
    Label21: TLabel;
    Button11: TButton;
    RadioGroup6: TRadioGroup;
    CheckBox7: TCheckBox;
    Button12: TButton;
    procedure CheckBox9Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure PageControl1Change(Sender: TObject);
    procedure binarycatChange(Sender: TObject);
    procedure DirectoryEdit1AcceptDirectory(Sender: TObject; var Value: string);
    procedure FormCreate(Sender: TObject);
    procedure nextbtClick(Sender: TObject);
    procedure prevbtClick(Sender: TObject);
    procedure CheckListBox1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: integer);
    procedure RadioGroup1Click(Sender: TObject);
    procedure Edit1Change(Sender: TObject);
    procedure Edit2Change(Sender: TObject);
    procedure CheckListBox1KeyUp(Sender: TObject; var Key: word;
      Shift: TShiftState);
    procedure EndbtClick(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure ExitbtClick(Sender: TObject);
    procedure Memo1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: integer);
    procedure Edit3Change(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure CheckBox2Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure Button9Click(Sender: TObject);
    procedure Shape1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: integer);
    procedure Button11Click(Sender: TObject);
    procedure Button12Click(Sender: TObject);
  private
    Fcatgenadv: Tf_catgenadv;
    Fprogress: Tf_progress;
    textpos: array [0..40] of array[1..2] of integer;
    calc: array[0..40, 1..2] of double;
    Lra, Lde, ListIndex, nebulaesizescale, l_fixe, nbalt, basealt: integer;
    lockchange: boolean;
    catheader: TFileHeader;
    catinfo: TCatHdrInfo;
    datarec: array [0..4096] of byte;
    ff: array [1..9537] of file;
    ffn: array [1..9537] of string;
    destdir: string;
    freject: textfile;
    rejectopen: boolean;
    fillstring, inl: string;
    flabel: array [1..35] of string;
    Ft: textfile;
    catrec, catsize: integer;
    colorlst: array[1..10] of string;
    Linelst: array[1..4] of string;
    neblst: array[1..19] of string;
    nebunit: array[1..3] of string;
    altname: array[1..l_sup] of byte;
    altprefix: array[1..l_sup] of byte;
    createindex, indexaltname, abort: boolean;
    usealt: array[0..10] of record
      i: integer;
      l: string;
    end;
    {$ifdef build_old_index}
    indexrec: array [0..1024] of byte;
    ixf: file;
    ixfn: string;
    {$endif}
    procedure SetFieldlist(field: array of string; n: integer);
    procedure BuildFieldList;
    procedure OpenCatalog(filename: string);
    procedure CloseCatalog;
    procedure ReadCatalog(out line: string);
    function GetCatalogSize: integer;
    function GetCatalogPos: integer;
    function CatalogEOF: boolean;
    procedure GetSampleData(filename: string);
    function CheckPageValid(i: integer): boolean;
    procedure SetListIndex;
    procedure InitPage(i: integer);
    procedure BuildHeader;
    procedure BuildTxtHeader;
    function GetFloat(p: integer; default: double): double;
    function GetInt(p: integer): integer;
    function GetString(p: integer): string;
    function GetNebType(p: integer): byte;
    function GetNebUnit(p: integer): smallint;
    function GetLineType(p: integer): smallint;
    function Getcolor(p: integer): Tcolor;
    procedure PutRecDouble(x: double; p: integer);
    procedure PutRecSingle(x: single; p: integer);
    procedure PutRecInt(x: integer; p: integer);
    procedure PutRecCard(x: cardinal; p: integer);
    procedure PutRecSmallInt(x: integer; p: integer);
    procedure PutRecByte(x: byte; p: integer);
    procedure PutRecString(x: string; p: integer);
    procedure FindRegion30(ar, de: double; var lg: integer);
    procedure FindRegion15(ar, de: double; var lg: integer);
    procedure FindRegion7(ar, de: double; var hemis: char; var zone, S: integer);
    procedure FindRegion(ar, de: double; var hemis: char; var zone, S: integer);
    procedure Createfiles;
    procedure CreateTxtfiles;
    procedure Closefiles;
    procedure WriteRec(num: integer);
    procedure RejectRec(lin: string);
    procedure BuildFiles;
    function filegetsize(fn: string): integer;
    procedure Sortfiles;
    procedure BuildBinCat;
    procedure BuildTxtCat;
    procedure ProgressAbort(Sender: TObject);
    procedure BuildIXrec;
    {$ifdef build_old_index}
    procedure PutIxSingle(x: single; p: integer);
    procedure PutIxkey(x: string);
    procedure WriteIx;
    procedure SortIXfile;
    {$endif}
  public
    procedure SetLang;

  end;

var
  f_catgen: Tf_catgen;
  keypos, ixlen: integer; // not thread safe but cannot define the sort exit otherwise

implementation

{$R *.lfm}

const
  zone_lst: array [0..23] of integer =
    (593, 1177, 1728, 2258, 2780, 3245, 3651, 4013,
    4293, 4491, 4614, 4662, 5259, 5837, 6411, 6988,
    7522, 8021, 8463, 8839, 9133, 9345, 9489, 9537);
  zone_lst7: array [0..23] of integer =
    (48, 95, 140, 183, 223, 259, 291, 318,
    339, 354, 363, 366, 414, 461, 506, 549,
    589, 625, 657, 684, 705, 720, 729, 732);
  zone_nam: array [0..23] of string =
    ('n0000', 'n0730', 'n1500', 'n2230', 'n3000', 'n3730', 'n4500', 'n5230',
    'n6000', 'n6730', 'n7500', 'n8230', 's0000', 's0730', 's1500', 's2230',
    's3000', 's3730', 's4500', 's5230', 's6000', 's6730', 's7500', 's8230');
  rahms: array[0..2] of string = ('[RA (hours)]', 'RA (minutes)', 'RA (seconds)');
  rah: array[0..0] of string = ('[RA decimal (hours)]');
  radms: array[0..2] of string = ('[RA (degrees)]', 'RA (minutes)', 'RA (seconds)');
  rad: array[0..0] of string = ('[RA decimal (degrees)]');
  dedms: array[0..3] of string =
    ('DEC sign', '[DEC (degrees)]', 'DEC (arcmin)', 'DEC (arcsec)');
  ded: array[0..0] of string = ('[DEC decimal (degrees)]');
  despd: array[0..0] of string = ('[SPD decimal (degrees)]');
  etoiles: array[0..10] of string =
    ('Catalog ID', '[Magnitude (mag)]', 'B-V (mag)', 'Magnitude B (mag)',
    'Magnitude R (mag)', 'Spectral class', 'Proper motion RA (arcsec/yr)',
    'Proper motion DEC (arcsec/yr)', 'Position Epoch (year)', 'Parallax (arcsec)', 'Comments');
  variable: array[0..9] of string =
    ('Catalog ID', 'Magnitude max (mag)', 'Magnitude min (mag)', 'Period (days)',
    'Variable Type', 'Maxima Epoch (JD)', 'Rise Time (%period)', 'Spectral class',
    'Magnitude code', 'Comments');
  doubles: array[0..9] of string =
    ('Catalog ID', '[Magnitude component 1 (mag)]', 'Magnitude component 2 (mag)',
    '[Separation (arcsec)]', 'Position angle (degrees)', 'Epoch (year)',
    'Component name', 'Spectral class component 1', 'Spectral class component 2', 'Comments');
  nebuleuse: array[0..11] of
    string = ('Catalog ID', 'Nebula type', 'Magnitude (mag)',
    'Surface brigtness (mag/arcmin2)', 'Largest dimension (as defined)',
    'Smallest dimension (as defined)', 'Dimension Unit', 'Position angle (degrees)',
    'Radial velocity (km/s)', 'Morphological class', 'Comments', 'Color');
  outlines: array[0..5] of string =
    ('Catalog ID (only for Start operation)', '[Line operation]',
    'Line width (only for Start operation)', 'Line color (only for Start operation)',
    'Drawing Type (only for Start operation)', 'Comments');
  sup_string: array[0..9] of string =
    ('String 1', 'String 2', 'String 3', 'String 4', 'String 5', 'String 6',
    'String 7', 'String 8', 'String 9', 'String 10');
  sup_num: array[0..9] of string =
    ('Numeric 1', 'Numeric 2', 'Numeric 3', 'Numeric 4', 'Numeric 5',
    'Numeric 6', 'Numeric 7', 'Numeric 8', 'Numeric 9', 'Numeric 10');
  l_rahms = 3;
  l_rah = 1;
  l_radms = 3;
  l_rad = 1;
  l_dedms = 4;
  l_ded = 1;
  l_despd = 1;
  l_base = 2;
  l_etoiles = 11;
  l_variable = 10;
  l_double = 10;
  l_nebuleuse = 12;
  l_outlines = 6;
  lab_base: array[1..2] of string = ('RA', 'DEC');
  lab_etoiles: array[1..l_etoiles] of string =
    ('Id', 'mV', 'b-v', 'mB', 'mR', 'sp', 'pmRA', 'pmDE', 'date', 'px', 'desc');
  lab_var: array[1..l_variable] of string =
    ('Id', 'mMax', 'mMin', 'P', 'T', 'Mepoch', 'rise', 'sp', 'band', 'desc');
  lab_double: array[1..l_double] of string =
    ('Id', 'm1', 'm2', 'sep', 'pa', 'date', 'Comp', 'sp', 'sp', 'desc');
  lab_neb: array[1..l_nebuleuse] of string =
    ('Id', 'NebTyp', 'm', 'sbr', 'D', 'D', 'Unit', 'pa', 'rv', 'class', 'desc', 'color');
  lab_outlines: array[1..l_outlines] of string =
    ('Id', 'LineOp', 'LineWidth', 'LineColor', 'Drawing', 'desc');
  lab_string: array[1..l_sup] of string =
    ('Str1', 'Str2', 'Str3', 'Str4', 'Str5', 'Str6', 'Str7', 'Str8', 'Str9', 'Str10');
  lab_num: array[1..l_sup] of string =
    ('Num1', 'Num2', 'Num3', 'Num4', 'Num5', 'Num6', 'Num7', 'Num8', 'Num9', 'Num10');
  nebtype: array[1..19] of integer = (1, 12, 2, 3, 4, 5, 13, 6, 11, 7, 8, 9, 10, 255, 0, 14, 15, 16, 17);
  linetype: array[1..5] of byte = (0, 1, 2, 3, 4);
  nebunits: array[1..3] of integer = (1, 60, 3600);
  pageFiles = 0;
  pageDefault = 1;
  pageDetails = 2;
  pageBuild = 3;
  pageTypeObject = 4;
  pageUnits = 5;
  pageLine = 6;
  pageColor = 7;

procedure Tf_catgen.SetFieldlist(field: array of string; n: integer);
var
  i: integer;
begin
  for i := 0 to n - 1 do
  begin
    CheckListBox1.Items.Add(field[i]);
  end;
end;

procedure Tf_catgen.BuildFieldList;
var
  i, nextpos: integer;
begin
  for i := 1 to l_base do
    flabel[i] := lab_base[i];
  CheckListBox1.Clear;
  case RadioGroup2.ItemIndex of
    0: setfieldlist(rahms, l_rahms);
    1: setfieldlist(rah, l_rah);
    2: setfieldlist(radms, l_radms);
    3: setfieldlist(rad, l_rad);
  end;
  case RadioGroup3.ItemIndex of
    0: setfieldlist(dedms, l_dedms);
    1: setfieldlist(ded, l_ded);
    2: setfieldlist(despd, l_despd);
  end;
  nextpos := l_base;
  case RadioGroup1.ItemIndex of
    0:
    begin
      setfieldlist(etoiles, l_etoiles);
      for i := 1 to l_etoiles do
        flabel[i + nextpos] := lab_etoiles[i];
      nextpos := l_etoiles + nextpos;
    end;
    1:
    begin
      setfieldlist(variable, l_variable);
      for i := 1 to l_variable do
        flabel[i + nextpos] := lab_var[i];
      nextpos := l_variable + nextpos;
    end;
    2:
    begin
      setfieldlist(doubles, l_double);
      for i := 1 to l_double do
        flabel[i + nextpos] := lab_double[i];
      nextpos := l_double + nextpos;
    end;
    3:
    begin
      setfieldlist(nebuleuse, l_nebuleuse);
      for i := 1 to l_nebuleuse do
        flabel[i + nextpos] := lab_neb[i];
      nextpos := l_nebuleuse + nextpos;
    end;
    4:
    begin
      setfieldlist(outlines, l_outlines);
      for i := 1 to l_outlines do
        flabel[i + nextpos] := lab_outlines[i];
      nextpos := l_outlines + nextpos;
    end;
  end;
  l_fixe := CheckListBox1.Items.Count;
  setfieldlist(sup_string, l_sup);
  for i := 1 to l_sup do
    flabel[i + nextpos] := lab_string[i];
  setfieldlist(sup_num, l_sup);
  nextpos := nextpos + l_sup;
  for i := 1 to l_sup do
    flabel[i + nextpos] := lab_num[i];
end;

procedure Tf_catgen.SetLang;
begin
  Caption := rsPrepareACata + ' 3.0';
  Label6.Caption := rsSelectTheTyp;
  Label8.Caption := rsInputCatalog;
  Label10.Caption := rsCatalogShort;
  Label13.Caption := rsCatalogLongN;
  Label22.Caption := rsForALargeCat;
  RadioGroup1.Caption := rsCatalogType;
  RadioGroup1.Items[0] := rsStars;
  RadioGroup1.Items[1] := rsVariableStar;
  RadioGroup1.Items[2] := rsDoubleStar;
  RadioGroup1.Items[3] := rsNebulaeOrOth;
  RadioGroup1.Items[4] := rsNebulaeOutli;
  binarycat.Caption := rsOutputCatalo;
  binarycat.Items[0] := rsBinaryIndexe;
  binarycat.Items[1] := rsTextFileCata;
  Label2.Caption := rsGeneralCatal;
  GroupBox5.Caption := rsDefaultNebul;
  Label11.Caption := rsDimensionAnd;
  Label12.Caption := rsObjectType;
  Label15.Caption := rsRecognizeUni;
  Label16.Caption := rsUsefulToRepr;
  ComboBox1.items[0] := rsDegree;
  ComboBox1.items[1] := rsMinute;
  ComboBox1.items[2] := rsSecond;
  CheckBox1.Caption := rsLogarithmicS;
  ComboBox3.items[0] := rsGalaxy;
  ComboBox3.items[1] := rsGalaxyCluste;
  ComboBox3.items[2] := rsOpenCluster;
  ComboBox3.items[3] := rsGlobularClus;
  ComboBox3.items[4] := rsPlanetaryNeb;
  ComboBox3.items[5] := rsBrightNebula;
  ComboBox3.items[6] := rsDarkNebula;
  ComboBox3.items[7] := rsClusterAndNe;
  ComboBox3.items[8] := rsKnot;
  ComboBox3.items[9] := rsStar;
  ComboBox3.items[10] := rsDoubleStar;
  ComboBox3.items[11] := rsTripleStar;
  ComboBox3.items[12] := rsAsterism;
  ComboBox3.items[13] := rsNonExistant;
  ComboBox3.items[14] := rsUnknow;
  ComboBox3.items[15] := rsCircle;
  ComboBox3.items[16] := rsSquare;
  ComboBox3.items[17] := rsLosange;
  Button3.Caption := rsEditObjectTy;
  Button6.Caption := rsEditUnits;
  GroupBox7.Caption := rsDefaultOutli;
  Label18.Caption := rsLineWidth;
  Label19.Caption := rsColor;
  Button9.Caption := rsEditLineOper;
  Button11.Caption := rsEditColor;
  RadioGroup6.Caption := rsDrawingType;
  CheckBox7.Caption := rsClosedContou;
  RadioGroup2.Caption := rsRAOptions;
  RadioGroup2.Items[0] := rsHoursMinutes;
  RadioGroup2.Items[1] := rsDecimalHours;
  RadioGroup2.Items[2] := rsDegreesMinut;
  RadioGroup2.Items[3] := rsDecimalDegre;
  RadioGroup3.Caption := rsDECOptions;
  RadioGroup3.Items[0] := rsDegreesMinut;
  RadioGroup3.Items[1] := rsDecimalDegre;
  RadioGroup3.Items[2] := rsDecimalSouth;
  RadioGroup6.Items[0] := rsLine1;
  RadioGroup6.Items[1] := rsSpline;
  RadioGroup6.Items[2] := rsSurface;
  GroupBox1.Caption := rsCoordinatesE;
  GroupBox4.Caption := rsMaximumMagni;
  GroupBox2.Caption := rsPositionEpoc;
  Label4.Caption := rsFirstChar;
  Label5.Caption := rsLength;
  Label7.Caption := rsSelectTheFie;
  Label3.Caption := rsLabel2;
  CheckBox2.Caption := rsUseThisField;
  Button7.Caption := rsAdvanced;
  Label1.Caption := rsOutputCatalo2;
  RadioGroup4.Caption := rsNumberOfFile;
  RadioGroup4.Items[0] := rs50Recommende;
  RadioGroup4.Items[1] := rs184Recommend;
  RadioGroup4.Items[2] := rs732Recommend;
  RadioGroup4.Items[3] := rs9537LargerDa;
  GroupBox3.Caption := rsOutputDirect;
  CheckBox6.Caption := rsAppendToAnEx;
  GroupBox6.Caption := rsSearchIndex;
  CheckBox3.Caption := rsCreateASearc;
  CheckBox4.Caption := rsAddTheAltern;
  CheckBox8.Caption := rsPrefixNameWi;
  Label9.Caption := rsIndicateTheS;
  Button4.Caption := rsReturn;
  Label14.Caption := rsIndicateHowT;
  Button5.Caption := rsReturn;
  Label17.Caption := rsIndicateTheS2;
  Button8.Caption := rsReturn;
  Label20.Caption := rsIndicateTheS3;
  Label21.Caption := rsClickToChang;
  Button10.Caption := rsReturn;
  Exitbt.Caption := rsClose;
  prevbt.Caption := rsPrev;
  nextbt.Caption := rsNext;
  Endbt.Caption := rsBuildCatalog;
  Button2.Caption := rsLoadProject;
  Button1.Caption := rsSaveProject;
  Button12.Caption := rsHelp;
  with stringgrid1 do
  begin
    cells[0, 0] := rsObjectType;
    cells[1, 0] := rsCatalogStrin;
    cells[0, 1] := rsGalaxy;
    cells[0, 2] := rsGalaxyCluste;
    cells[0, 3] := rsOpenCluster;
    cells[0, 4] := rsGlobularClus;
    cells[0, 5] := rsPlanetaryNeb;
    cells[0, 6] := rsBrightNebula;
    cells[0, 7] := rsDarkNebula;
    cells[0, 8] := rsClusterAndNe;
    cells[0, 9] := rsKnot;
    cells[0, 10] := rsStar;
    cells[0, 11] := rsDoubleStar;
    cells[0, 12] := rsTripleStar;
    cells[0, 13] := rsAsterism;
    cells[0, 14] := rsNonExistant;
    cells[0, 15] := rsUnknow;
    cells[0, 16] := rsCircle;
    cells[0, 17] := rsSquare;
    cells[0, 18] := rsLosange;
    cells[0, 19] := rsDuplicate;
  end;
  with stringgrid2 do
  begin
    cells[0, 0] := rsObjectSizeUn;
    cells[1, 0] := rsCatalogStrin;
    cells[0, 1] := rsDegree;
    cells[0, 2] := rsMinute;
    cells[0, 3] := rsSecond;
  end;
  with stringgrid3 do
  begin
    cells[0, 0] := rsLineOperatio;
    cells[1, 0] := rsCatalogStrin;
    cells[0, 1] := rsStartOfObjec;
    cells[0, 2] := rsEndOfObject;
    cells[0, 3] := rsDrawLine;
  end;
  with stringgrid4 do
  begin
    cells[0, 0] := rsCatalogStrin;
  end;
  SetHelp(self, hlpCatgen);
end;

procedure Tf_catgen.FormCreate(Sender: TObject);
var
  i: integer;
begin
  ScaleDPI(Self);
  Fcatgenadv := Tf_catgenadv.Create(self);
  Fprogress := Tf_progress.Create(self);
  rejectopen := False;
  lockchange := False;
  for i := 1 to l_sup do
    altname[i] := 0;
  for i := 1 to l_sup do
    altprefix[i] := 0;
  pagecontrol1.PageIndex := pageFiles;
  nextbt.Enabled := True;
  prevbt.Enabled := False;
  BuildFieldList;
  combobox1.ItemIndex := 1;
  nebulaesizescale := 60;
  combobox3.ItemIndex := 14;
  for i := 0 to 40 do
  begin
    textpos[i, 1] := 0;
    textpos[i, 2] := 0;
    calc[i, 1] := 1;
    calc[i, 2] := 0;
  end;
  with stringgrid1 do
  begin
    rowcount := 20;
    cells[1, 1] := 'Gx,GALXY,QUASR';
    cells[1, 2] := 'GALCL';
    cells[1, 3] := 'OC,OPNCL,LMCOC,SMCOC';
    cells[1, 4] := 'Gb,GLOCL,GX+GC,LMCGC,SMCGC';
    cells[1, 5] := 'Pl,PLNNB';
    cells[1, 6] := 'Nb,BRTNB,GX+DN,LMCDN,SMCDN,SNREM';
    cells[1, 7] := 'Drk,DRKNB';
    cells[1, 8] := 'C+N,CL+NB,G+C+N,LMCCN,SMCCN';
    cells[1, 9] := 'Kt';
    cells[1, 10] := '*,1STAR';
    cells[1, 11] := 'D*,2STAR';
    cells[1, 12] := '***,3STAR';
    cells[1, 13] := 'Ast,ASTER,4STAR,5STAR,6STAR,7STAR,8STAR';
    cells[1, 14] := '-,PD,NONEX';
    cells[1, 15] := ' ,?';
    cells[1, 16] := 'Circle';
    cells[1, 17] := 'Rectangle';
    cells[1, 18] := 'Lozenge';
    cells[1, 19] := 'Dup';
  end;
  with stringgrid2 do
  begin
    cells[1, 1] := 'd,°';
    cells[1, 2] := 'm,''';
    cells[1, 3] := 's,"';
  end;
  with stringgrid3 do
  begin
    cells[1, 1] := 'start,0';
    cells[1, 2] := 'end,1';
    cells[1, 3] := 'vertex, ,2';
  end;
  with stringgrid4 do
  begin
    rowcount := 11;
    cells[0, 1] := 'White,W,1';
    cells[0, 2] := 'LightGray,LG,2';
    cells[0, 3] := 'Gray,G,3';
    cells[0, 4] := 'Black,D,4';
    cells[0, 5] := 'Red,R,5';
    cells[0, 6] := 'Green,V,6';
    cells[0, 7] := 'Yellow,Y,7';
    cells[0, 8] := 'Blue,B,8';
    cells[0, 9] := 'Magenta,M,9';
    cells[0, 10] := 'Turquoise,T,10';
  end;
  SetLang;
{$ifdef mswindows}
  SaveDialog1.Options := SaveDialog1.Options - [ofNoReadOnlyReturn];
  { TODO : check readonly test on Windows }
{$endif}
end;


procedure Tf_catgen.OpenCatalog(filename: string);
begin
  catrec := 0;
  Filemode := 0;
  Assignfile(Ft, filename);
  reset(Ft);
end;

procedure Tf_catgen.CloseCatalog;
begin
  Closefile(Ft);
end;

procedure Tf_catgen.ReadCatalog(out line: string);
begin
  Readln(Ft, line);
  Inc(catrec);
end;

function Tf_catgen.GetCatalogSize: integer;
begin
  catsize := 0;
  reset(Ft);
  repeat
    readln(Ft);
    Inc(catsize);
  until EOF(Ft);
  reset(Ft);
  Result := catsize;
  // result:=filesize(Ft);
end;

function Tf_catgen.GetCatalogPos: integer;
begin
  Result := catrec;
  //result:=filepos(Ft);
end;

function Tf_catgen.CatalogEOF: boolean;
begin
  Result := EOF(Ft);
end;

procedure Tf_catgen.GetSampleData(filename: string);
var
  buf, scal: string;
  i, n: integer;
begin
  OpenCatalog(filename);
  try
    ReadCatalog(buf);
    memo1.Lines.Clear;
    memo1.Lines.add(buf);
    n := 1 + (length(buf) div 10);
    scal := '';
    for i := 1 to n do
      scal := scal + '1234567890';
    memo1.Lines.add(scal);
    scal := '';
    for i := 1 to n do
      scal := scal + copy('         ', 1, 9 - trunc(log10(i))) + IntToStr(i);
    memo1.Lines.add(scal);
    memo1.SelStart := 0;
    memo1.SelLength := 0;
  finally
    CloseCatalog;
  end;
end;

function Tf_catgen.CheckPageValid(i: integer): boolean;
var
  n: integer;
begin
  case i of
    pageFiles:
    begin
      if (ListBox1.Items.Count > 0) and (fileexists(ListBox1.Items[0])) then
        Result := True
      else
      begin
        Result := False;
        ShowMessage(rsFileNotFound);
      end;
      if Result and (trim(edit4.Text) = '') then
      begin
        Result := False;
        ShowMessage(rsPleaseIndica);
        edit4.SetFocus;
      end;
      if Result and (trim(edit5.Text) = '') then
      begin
        Result := False;
        ShowMessage(rsPleaseIndica2);
        edit5.SetFocus;
      end;
    end;
    pageDefault:
    begin
      if (FloatEdit1.Value > 2100) or (FloatEdit1.Value < 1800) then
      begin
        if mrOk = MessageDlg(Format(rsIsCoordinate, [FloatEdit1.Text]),
          mtConfirmation, mbOkCancel, 0) then
          Result := True
        else
          Result := False;
      end
      else
        Result := True;
    end;
    pageDetails:
    begin
      Result := True;
      for n := 0 to CheckListBox1.Items.Count - 1 do
      begin
        if (not CheckListBox1.Checked[n]) and (copy(CheckListBox1.items[n], 1, 1) = '[') then
          Result := False;
      end;
      if Result = False then
        ShowMessage(rsRequiredFiel);
    end;
    else
      Result := True;
  end;
end;

procedure Tf_catgen.SetListIndex;
var
  i: integer;
  buf: string;
begin
  lockchange := True;
  case RadioGroup2.ItemIndex of
    0: lra := l_rahms;
    1: lra := l_rah;
    2: lra := l_radms;
    3: lra := l_rad;
  end;
  case RadioGroup3.ItemIndex of
    0: lde := l_dedms;
    1: lde := l_ded;
    2: lde := l_despd;
  end;
  i := listindex + 1;
  if (i <= lra) then
    edit3.Text := flabel[1]
  else if (i <= (lra + lde)) then
    edit3.Text := flabel[2]
  else
    edit3.Text := flabel[i - lra - lde + 2];
  buf := IntToStr(textpos[ListIndex, 1]);
  edit1.Text := buf;
  buf := IntToStr(textpos[ListIndex, 2]);
  edit2.Text := buf;
  if (textpos[ListIndex, 1] > 0) and (textpos[ListIndex, 2] > 0) then
  begin
    memo1.SelStart := textpos[ListIndex, 1] - 1;
    memo1.SelLength := minintvalue(
      [textpos[ListIndex, 2], length(memo1.Lines.Strings[0]) - memo1.SelStart]);
  end
  else
  begin
    memo1.SelStart := 0;
    memo1.SelLength := 0;
  end;
  ;
  if (i > l_fixe) and (i <= l_fixe + l_sup) then
  begin
    checkbox2.Visible := True;
    checkbox2.Checked := AltName[i - l_fixe] = 1;
    checkbox9.Visible := True;
    checkbox9.Checked := altprefix[i - l_fixe] = 1;
  end
  else
  begin
    checkbox2.Visible := False;
    checkbox9.Visible := False;
  end;
  lockchange := False;
end;

procedure Tf_catgen.Edit3Change(Sender: TObject);
var
  i, j: integer;
begin
  if lockchange then
    exit;
  i := listindex + 1;
  if i <= lra then
    j := 1
  else if i <= (lra + lde) then
    j := 2
  else
    j := i - lra - lde + 2;
  flabel[j] := edit3.Text;
end;

procedure Tf_catgen.InitPage(i: integer);
begin
  case i of
    pageDefault:
    begin
      GroupBox5.Visible := (RadioGroup1.ItemIndex = 3);
      GroupBox7.Visible := (RadioGroup1.ItemIndex = 4);
    end;
    pageDetails:
    begin
      getsampledata(ListBox1.Items[0]);
      SetListIndex;
    end;
    pageBuild:
    begin
      exitbt.Visible := False;
      endbt.Visible := True;
      endbt.Enabled := True;
      if radiogroup1.ItemIndex = 4 then
      begin
        radiogroup4.Visible := False;
        groupbox6.Visible := False;
      end;
    end;
  end;
end;

procedure Tf_catgen.nextbtClick(Sender: TObject);
var
  i: integer;
begin
  chdir(appdir);
  if not Checkpagevalid(pagecontrol1.PageIndex) then
    exit;
  i := pagecontrol1.PageIndex + 1;
  endbt.Enabled := False;
  if i >= pageBuild then
  begin
    i := pageBuild;
    nextbt.Enabled := False;
    endbt.Visible := True;
    endbt.Enabled := True;
  end;
  pagecontrol1.PageIndex := i;
  prevbt.Enabled := True;
  InitPage(i);
end;

procedure Tf_catgen.prevbtClick(Sender: TObject);
var
  i: integer;
begin
  chdir(appdir);
  i := pagecontrol1.PageIndex - 1;
  endbt.Enabled := False;
  if i <= 0 then
  begin
    i := 0;
    prevbt.Enabled := False;
  end;
  pagecontrol1.PageIndex := i;
  nextbt.Enabled := True;
  InitPage(i);
end;

procedure Tf_catgen.CheckListBox1MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: integer);
var
  APoint: TPoint;
begin
  if Button = mbLeft then
  begin
    APoint.X := X;
    APoint.Y := Y;
    ListIndex := CheckListBox1.ItemAtPos(APoint, True);
    if ListIndex < 0 then
      exit;
    SetListIndex;
  end;
end;

procedure Tf_catgen.RadioGroup1Click(Sender: TObject);
begin
  BuildFieldList;
end;

procedure Tf_catgen.Edit1Change(Sender: TObject);
var
  i, n: integer;
begin
  if lockchange then
    exit;
  val(edit1.Text, i, n);
  if n = 0 then
  begin
    textpos[ListIndex, 1] := i;
    SetListIndex;
  end;
end;

procedure Tf_catgen.Edit2Change(Sender: TObject);
var
  i, n: integer;
begin
  if lockchange then
    exit;
  val(edit2.Text, i, n);
  if n = 0 then
  begin
    textpos[ListIndex, 2] := i;
    SetListIndex;
  end;
end;

procedure Tf_catgen.CheckListBox1KeyUp(Sender: TObject; var Key: word;
  Shift: TShiftState);
begin
  listindex := checklistbox1.ItemIndex;
  if ListIndex < 0 then
    exit;
  SetListIndex;
end;


procedure Tf_catgen.BuildHeader;
var
  i, j, n: integer;
  nextpos, curpos: integer;
  buf: shortstring;
  CatPrefix: boolean;
begin
  for i := 1 to 10 do
    catheader.Spare1[i] := 0;
  for i := 1 to 15 do
    catheader.Spare2[i] := 0;
  for i := 1 to 15 do
    catheader.Spare3[i] := 0;
  for i := 1 to 40 do
    catheader.fpos[i] := 0;
  for i := 1 to 40 do
    catheader.flen[i] := 0;
  n := l_base;
  case radiogroup1.ItemIndex of
    0:
    begin
      catheader.version := 'CDCSTAR1';
      n := n + l_etoiles;
    end;
    1:
    begin
      catheader.version := 'CDCVAR 1';
      n := n + l_variable;
    end;
    2:
    begin
      catheader.version := 'CDCDBL 1';
      n := n + l_double;
    end;
    3:
    begin
      catheader.version := 'CDCNEB 1';
      n := n + l_nebuleuse;
    end;
    4:
    begin
      catheader.version := 'CDCLINE1';
      n := n + l_outlines;
    end;
  end;
  for i := 1 to n do
  begin
    buf := flabel[i] + '           ';
    for j := 0 to 10 do
      catheader.flabel[i, j] := buf[j + 1];
  end;
  for i := n + 1 to 14 do
  begin
    buf := '           ';
    for j := 0 to 10 do
      catheader.flabel[i, j] := buf[j + 1];
  end;
  for i := 15 to 35 do
  begin
    buf := flabel[i - (15 - n)] + '           ';
    for j := 0 to 10 do
      catheader.flabel[i, j] := buf[j + 1];
  end;
  if GroupBox6.Visible then
  begin
    createindex := checkbox3.Checked;
    indexaltname := checkbox4.Checked;
    catheader.useprefix := 0;
    for i := 1 to l_sup do
      if altprefix[i] = 1 then
        catheader.useprefix := 2;
  end
  else
  begin
    createindex := False;
    indexaltname := False;
    catheader.useprefix := 0;
  end;
  for i := 1 to l_sup do
    catheader.AltName[i] := altname[i];
  for i := 1 to l_sup do
    catheader.AltPrefix[i] := altprefix[i];
  buf := PChar(edit4.Text + '    ');
  for i := 1 to 4 do
    catheader.ShortName[i - 1] := buf[i];
  buf := PChar(edit5.Text + StringOfChar(' ', 50));
  for i := 1 to 50 do
    catheader.LongName[i - 1] := buf[i];
  catheader.hdrl := sizeof(catheader);
  if radiogroup4.Visible then
    case radiogroup4.ItemIndex of
      0: catheader.filenum := 50;
      1: catheader.filenum := 184;
      2: catheader.filenum := 732;
      3: catheader.filenum := 9537;
    end
  else
    catheader.filenum := 1;
  catheader.Equinox := floatedit1.Value;
  catheader.Epoch := floatedit3.Value;
  if catheader.version = 'CDCNEB 1' then
  begin
    catheader.MagMax := floatedit2.Value;
    catheader.Size := longedit1.Value;
    catheader.Units := nebulaesizescale;
    catheader.ObjType := nebtype[Combobox3.ItemIndex + 1];
    if CheckBox1.Checked then
      catheader.LogSize := 1
    else
      catheader.LogSize := 0;
  end
  else if catheader.version = 'CDCLINE1' then
  begin
    catheader.MagMax := floatedit2.Value;
    catheader.Size := longedit2.Value;
    catheader.Units := Shape1.Brush.Color;
    if checkbox7.Checked then
      catheader.ObjType := 1
    else
      catheader.ObjType := 0;
    catheader.LogSize := RadioGroup6.ItemIndex;
  end
  else
  begin
    catheader.MagMax := floatedit2.Value;
    catheader.Size := 0;
    catheader.Units := 0;
    catheader.ObjType := 0;
    catheader.LogSize := 0;
  end;
  nextpos := 0;
  curpos := 1;
  n := 1;
  //RA [mas]
  catheader.fpos[n] := curpos;
  catheader.flen[n] := sizeof(cardinal);
  curpos := curpos + catheader.flen[n];
  Inc(n);
  //DEC [mas]
  catheader.fpos[n] := curpos;
  catheader.flen[n] := sizeof(cardinal);
  curpos := curpos + catheader.flen[n];
  Inc(n);
  case radiogroup2.ItemIndex of  // RA
    0: nextpos := 3;
    1: nextpos := 1;
    2: nextpos := 3;
    3: nextpos := 1;
  end;
  case radiogroup3.ItemIndex of  // DEC
    0: nextpos := nextpos + 4;
    1, 2: nextpos := nextpos + 1;
  end;
  usealt[0].i := 0;
  CatPrefix := CheckBox8.Checked;
  case radiogroup1.ItemIndex of
    //9 ('Catalog ID','[Magnitude V]','B-V','Magnitude B','Magnitude R','Spectral class','Proper motion RA','Proper motion DEC','epoch','Parallax','Comments');
    0:
    begin     // Stars
      if CheckListBox1.Checked[nextpos + 0] then
      begin
        catheader.fpos[n] := curpos;
        catheader.flen[n] := textpos[nextpos + 0, 2];
      end;// ID
      ixlen := catheader.flen[n];
      if ixlen > 0 then
      begin
        usealt[0].i := nextpos;
        if CatPrefix then
          usealt[0].l := trim(edit4.Text)
        else
          usealt[0].l := '';
        ixlen := ixlen + length(usealt[0].l);
      end;
      curpos := curpos + catheader.flen[n];
      Inc(n);
      if CheckListBox1.Checked[nextpos + 1] then
      begin
        catheader.fpos[n] := curpos;
        catheader.flen[n] := sizeof(smallint);
      end;// mag V
      keypos := curpos;
      curpos := curpos + catheader.flen[n];
      Inc(n);
      if CheckListBox1.Checked[nextpos + 2] then
      begin
        catheader.fpos[n] := curpos;
        catheader.flen[n] := sizeof(smallint);
      end;// B-V
      curpos := curpos + catheader.flen[n];
      Inc(n);
      if CheckListBox1.Checked[nextpos + 3] then
      begin
        catheader.fpos[n] := curpos;
        catheader.flen[n] := sizeof(smallint);
      end;// B
      curpos := curpos + catheader.flen[n];
      Inc(n);
      if CheckListBox1.Checked[nextpos + 4] then
      begin
        catheader.fpos[n] := curpos;
        catheader.flen[n] := sizeof(smallint);
      end;// R
      curpos := curpos + catheader.flen[n];
      Inc(n);
      if CheckListBox1.Checked[nextpos + 5] then
      begin
        catheader.fpos[n] := curpos;
        catheader.flen[n] := textpos[nextpos + 5, 2];
      end;// Sp
      curpos := curpos + catheader.flen[n];
      Inc(n);
      if CheckListBox1.Checked[nextpos + 6] then
      begin
        catheader.fpos[n] := curpos;
        catheader.flen[n] := sizeof(smallint);
      end;// pmAR
      curpos := curpos + catheader.flen[n];
      Inc(n);
      if CheckListBox1.Checked[nextpos + 7] then
      begin
        catheader.fpos[n] := curpos;
        catheader.flen[n] := sizeof(smallint);
      end;// pmDE
      curpos := curpos + catheader.flen[n];
      Inc(n);
      if CheckListBox1.Checked[nextpos + 8] then
      begin
        catheader.fpos[n] := curpos;
        catheader.flen[n] := sizeof(single);
      end;// pos epoch
      curpos := curpos + catheader.flen[n];
      Inc(n);
      if CheckListBox1.Checked[nextpos + 9] then
      begin
        catheader.fpos[n] := curpos;
        catheader.flen[n] := sizeof(smallint);
      end;// Px
      curpos := curpos + catheader.flen[n];
      Inc(n);
      if CheckListBox1.Checked[nextpos + 10] then
      begin
        catheader.fpos[n] := curpos;
        catheader.flen[n] := textpos[nextpos + 10, 2];
      end;// Comment
      curpos := curpos + catheader.flen[n];
      Inc(n);
      Inc(n);
      Inc(n);
      nextpos := nextpos + 11;
    end;
    //9 ('Catalog ID','[Magnitude max]','[Magnitude min]','Period','Type','Maxima Epoch','Rise Time','Spectral class','Magnitude code','Comments');
    1:
    begin     // variables
      if CheckListBox1.Checked[nextpos + 0] then
      begin
        catheader.fpos[n] := curpos;
        catheader.flen[n] := textpos[nextpos + 0, 2];
      end;// ID
      ixlen := catheader.flen[n];
      if ixlen > 0 then
      begin
        usealt[0].i := nextpos;
        if CatPrefix then
          usealt[0].l := trim(edit4.Text)
        else
          usealt[0].l := '';
        ixlen := ixlen + length(usealt[0].l);
      end;
      curpos := curpos + catheader.flen[n];
      Inc(n);
      if CheckListBox1.Checked[nextpos + 1] then
      begin
        catheader.fpos[n] := curpos;
        catheader.flen[n] := sizeof(smallint);
      end;// mag1
      keypos := curpos;
      curpos := curpos + catheader.flen[n];
      Inc(n);
      if CheckListBox1.Checked[nextpos + 2] then
      begin
        catheader.fpos[n] := curpos;
        catheader.flen[n] := sizeof(smallint);
      end;// mag2
      curpos := curpos + catheader.flen[n];
      Inc(n);
      if CheckListBox1.Checked[nextpos + 3] then
      begin
        catheader.fpos[n] := curpos;
        catheader.flen[n] := sizeof(single);
      end;// period
      curpos := curpos + catheader.flen[n];
      Inc(n);
      if CheckListBox1.Checked[nextpos + 4] then
      begin
        catheader.fpos[n] := curpos;
        catheader.flen[n] := textpos[nextpos + 4, 2];
      end;// Type
      curpos := curpos + catheader.flen[n];
      Inc(n);
      if CheckListBox1.Checked[nextpos + 5] then
      begin
        catheader.fpos[n] := curpos;
        catheader.flen[n] := sizeof(single);
      end;// epoch
      curpos := curpos + catheader.flen[n];
      Inc(n);
      if CheckListBox1.Checked[nextpos + 6] then
      begin
        catheader.fpos[n] := curpos;
        catheader.flen[n] := sizeof(smallint);
      end;// rise
      curpos := curpos + catheader.flen[n];
      Inc(n);
      if CheckListBox1.Checked[nextpos + 7] then
      begin
        catheader.fpos[n] := curpos;
        catheader.flen[n] := textpos[nextpos + 7, 2];
      end;// Sp
      curpos := curpos + catheader.flen[n];
      Inc(n);
      if CheckListBox1.Checked[nextpos + 8] then
      begin
        catheader.fpos[n] := curpos;
        catheader.flen[n] := textpos[nextpos + 8, 2];
      end;// mag. code
      curpos := curpos + catheader.flen[n];
      Inc(n);
      if CheckListBox1.Checked[nextpos + 9] then
      begin
        catheader.fpos[n] := curpos;
        catheader.flen[n] := textpos[nextpos + 9, 2];
      end;// Comment
      curpos := curpos + catheader.flen[n];
      Inc(n);
      Inc(n);
      Inc(n);
      Inc(n);
      nextpos := nextpos + 10;
    end;
    //9 ('Catalog ID','[Magnitude component 1]','Magnitude component 2','[Separation]','Position angle','Epoch','Component name','Spectral class 1','Spectral class 2','Comments');
    2:
    begin     // Doubles Stars
      if CheckListBox1.Checked[nextpos + 0] then
      begin
        catheader.fpos[n] := curpos;
        catheader.flen[n] := textpos[nextpos + 0, 2];
      end;// ID
      ixlen := catheader.flen[n];
      if ixlen > 0 then
      begin
        usealt[0].i := nextpos;
        if CatPrefix then
          usealt[0].l := trim(edit4.Text)
        else
          usealt[0].l := '';
        ixlen := ixlen + length(usealt[0].l);
      end;
      curpos := curpos + catheader.flen[n];
      Inc(n);
      if CheckListBox1.Checked[nextpos + 1] then
      begin
        catheader.fpos[n] := curpos;
        catheader.flen[n] := sizeof(smallint);
      end;// mag1
      keypos := curpos;
      curpos := curpos + catheader.flen[n];
      Inc(n);
      if CheckListBox1.Checked[nextpos + 2] then
      begin
        catheader.fpos[n] := curpos;
        catheader.flen[n] := sizeof(smallint);
      end;// mag2
      curpos := curpos + catheader.flen[n];
      Inc(n);
      if CheckListBox1.Checked[nextpos + 3] then
      begin
        catheader.fpos[n] := curpos;
        catheader.flen[n] := sizeof(smallint);
      end;// sep
      curpos := curpos + catheader.flen[n];
      Inc(n);
      if CheckListBox1.Checked[nextpos + 4] then
      begin
        catheader.fpos[n] := curpos;
        catheader.flen[n] := sizeof(smallint);
      end;// PA
      curpos := curpos + catheader.flen[n];
      Inc(n);
      if CheckListBox1.Checked[nextpos + 5] then
      begin
        catheader.fpos[n] := curpos;
        catheader.flen[n] := sizeof(single);
      end;// epoch
      curpos := curpos + catheader.flen[n];
      Inc(n);
      if CheckListBox1.Checked[nextpos + 6] then
      begin
        catheader.fpos[n] := curpos;
        catheader.flen[n] := textpos[nextpos + 6, 2];
      end;// Comp name
      curpos := curpos + catheader.flen[n];
      Inc(n);
      if CheckListBox1.Checked[nextpos + 7] then
      begin
        catheader.fpos[n] := curpos;
        catheader.flen[n] := textpos[nextpos + 7, 2];
      end;// SP 1
      curpos := curpos + catheader.flen[n];
      Inc(n);
      if CheckListBox1.Checked[nextpos + 8] then
      begin
        catheader.fpos[n] := curpos;
        catheader.flen[n] := textpos[nextpos + 8, 2];
      end;// SP 2
      curpos := curpos + catheader.flen[n];
      Inc(n);
      if CheckListBox1.Checked[nextpos + 9] then
      begin
        catheader.fpos[n] := curpos;
        catheader.flen[n] := textpos[nextpos + 9, 2];
      end;// Comment
      curpos := curpos + catheader.flen[n];
      Inc(n);
      Inc(n);
      Inc(n);
      Inc(n);
      nextpos := nextpos + 10;
    end;
    //9 ('ID number','Nebula type','Magnitude','Surface brigtness','Largest dimension','Smallest diemnsion','Position angle','Radial velocity','Morphological class','Comments','Color');
    3:
    begin     // Nebulae
      if CheckListBox1.Checked[nextpos + 0] then
      begin
        catheader.fpos[n] := curpos;
        catheader.flen[n] := textpos[nextpos + 0, 2];
      end;// ID
      ixlen := catheader.flen[n];
      if ixlen > 0 then
      begin
        usealt[0].i := nextpos;
        if CatPrefix then
          usealt[0].l := trim(edit4.Text)
        else
          usealt[0].l := '';
        ixlen := ixlen + length(usealt[0].l);
      end;
      curpos := curpos + catheader.flen[n];
      Inc(n);
      if CheckListBox1.Checked[nextpos + 1] then
      begin
        catheader.fpos[n] := curpos;
        catheader.flen[n] := sizeof(byte);
      end;// type
      curpos := curpos + catheader.flen[n];
      Inc(n);
      if CheckListBox1.Checked[nextpos + 2] then
      begin
        catheader.fpos[n] := curpos;
        catheader.flen[n] := sizeof(smallint);
      end;// mag.
      keypos := curpos;
      curpos := curpos + catheader.flen[n];
      Inc(n);
      if CheckListBox1.Checked[nextpos + 3] then
      begin
        catheader.fpos[n] := curpos;
        catheader.flen[n] := sizeof(smallint);
      end;// sbr
      curpos := curpos + catheader.flen[n];
      Inc(n);
      if CheckListBox1.Checked[nextpos + 4] then
      begin
        catheader.fpos[n] := curpos;
        catheader.flen[n] := sizeof(single);
      end;// size
      curpos := curpos + catheader.flen[n];
      Inc(n);
      if CheckListBox1.Checked[nextpos + 5] then
      begin
        catheader.fpos[n] := curpos;
        catheader.flen[n] := sizeof(single);
      end;// size2
      curpos := curpos + catheader.flen[n];
      Inc(n);
      if CheckListBox1.Checked[nextpos + 6] then
      begin
        catheader.fpos[n] := curpos;
        catheader.flen[n] := sizeof(smallint);
      end;// Unit
      curpos := curpos + catheader.flen[n];
      Inc(n);
      if CheckListBox1.Checked[nextpos + 7] then
      begin
        catheader.fpos[n] := curpos;
        catheader.flen[n] := sizeof(smallint);
      end;// PA
      curpos := curpos + catheader.flen[n];
      Inc(n);
      if CheckListBox1.Checked[nextpos + 8] then
      begin
        catheader.fpos[n] := curpos;
        catheader.flen[n] := sizeof(single);
      end;// RV
      curpos := curpos + catheader.flen[n];
      Inc(n);
      if CheckListBox1.Checked[nextpos + 9] then
      begin
        catheader.fpos[n] := curpos;
        catheader.flen[n] := textpos[nextpos + 9, 2];
      end;// morph class
      curpos := curpos + catheader.flen[n];
      Inc(n);
      if CheckListBox1.Checked[nextpos + 10] then
      begin
        catheader.fpos[n] := curpos;
        catheader.flen[n] := textpos[nextpos + 10, 2];
      end;// Comment
      curpos := curpos + catheader.flen[n];
      Inc(n);
      if CheckListBox1.Checked[nextpos + 11] then
      begin
        catheader.fpos[n] := curpos;
        catheader.flen[n] := sizeof(cardinal);
      end;// Color
      curpos := curpos + catheader.flen[n];
      Inc(n);
      Inc(n);
      nextpos := nextpos + 12;
    end;
    //5 ('Catalog ID','[Line op]','Line width','Line color','use spline','Comments');
    4:
    begin     // Outlines
      if CheckListBox1.Checked[nextpos + 0] then
      begin
        catheader.fpos[n] := curpos;
        catheader.flen[n] := textpos[nextpos + 0, 2];
      end;// ID
      ixlen := catheader.flen[n];
      if ixlen > 0 then
      begin
        usealt[0].i := nextpos;
        if CatPrefix then
          usealt[0].l := trim(edit4.Text)
        else
          usealt[0].l := '';
        ixlen := ixlen + length(usealt[0].l);
      end;
      keypos := curpos;
      curpos := curpos + catheader.flen[n];
      Inc(n);
      if CheckListBox1.Checked[nextpos + 1] then
      begin
        catheader.fpos[n] := curpos;
        catheader.flen[n] := sizeof(byte);
      end;// line type
      curpos := curpos + catheader.flen[n];
      Inc(n);
      if CheckListBox1.Checked[nextpos + 2] then
      begin
        catheader.fpos[n] := curpos;
        catheader.flen[n] := sizeof(byte);
      end;// line width
      curpos := curpos + catheader.flen[n];
      Inc(n);
      if CheckListBox1.Checked[nextpos + 3] then
      begin
        catheader.fpos[n] := curpos;
        catheader.flen[n] := sizeof(cardinal);
      end;// line color
      curpos := curpos + catheader.flen[n];
      Inc(n);
      if CheckListBox1.Checked[nextpos + 4] then
      begin
        catheader.fpos[n] := curpos;
        catheader.flen[n] := sizeof(byte);
      end;// drawing
      curpos := curpos + catheader.flen[n];
      Inc(n);
      if CheckListBox1.Checked[nextpos + 5] then
      begin
        catheader.fpos[n] := curpos;
        catheader.flen[n] := textpos[nextpos + 5, 2];
      end;// Comment
      curpos := curpos + catheader.flen[n];
      Inc(n);
      Inc(n);
      Inc(n);
      Inc(n);
      Inc(n);
      Inc(n);
      Inc(n);
      Inc(n);
      nextpos := nextpos + 6;
    end;
  end;
  nbalt := 0;
  basealt := nextpos;
  for i := 0 to 9 do
  begin
    if CheckListBox1.Checked[nextpos + i] then
    begin
      catheader.fpos[n] := curpos;
      catheader.flen[n] := textpos[nextpos + i, 2];
    end;
    if createindex and indexaltname and (altname[n - 15] = 1) then
    begin
      Inc(nbalt);
      j := catheader.flen[n];
      if (catheader.UsePrefix >= 1) and (altprefix[n - 15] = 1) and
        (trim(catheader.flabel[n]) <> 'NA') then
        j := j + length(trim(catheader.flabel[n]));
      usealt[nbalt].i := nextpos + i;
      if (altprefix[n - 15] = 1) and (trim(catheader.flabel[n]) <> 'NA') then
        usealt[nbalt].l := trim(catheader.flabel[n])
      else
        usealt[nbalt].l := '';
      ixlen := maxintvalue([ixlen, j]);
    end;
    curpos := curpos + catheader.flen[n];
    Inc(n);
  end;
  for i := 10 to 19 do
  begin
    if CheckListBox1.Checked[nextpos + i] then
    begin
      catheader.fpos[n] := curpos;
      catheader.flen[n] := sizeof(single);
    end;
    curpos := curpos + catheader.flen[n];
    Inc(n);
  end;
  catheader.reclen := 0;
  for i := 1 to 35 do
    catheader.reclen := catheader.reclen + catheader.flen[i];
  ixlen := minintvalue([ixlen, 255]);
  catheader.IxKeylen := ixlen;
end;

procedure Tf_catgen.BuildTxtHeader;
var
  i, j, n: integer;
  curpos: integer;
  buf: shortstring;
begin
  for i := 1 to 10 do
    catheader.Spare1[i] := 0;
  for i := 1 to 15 do
    catheader.Spare2[i] := 0;
  for i := 1 to 15 do
    catheader.Spare3[i] := 0;
  for i := 1 to 40 do
    catheader.fpos[i] := 0;
  for i := 1 to 40 do
    catheader.flen[i] := 0;
  n := l_base;
  case radiogroup1.ItemIndex of
    0:
    begin
      catheader.version := 'CDCSTAR2';
      n := n + l_etoiles;
    end;
    1:
    begin
      catheader.version := 'CDCVAR 2';
      n := n + l_variable;
    end;
    2:
    begin
      catheader.version := 'CDCDBL 2';
      n := n + l_double;
    end;
    3:
    begin
      catheader.version := 'CDCNEB 2';
      n := n + l_nebuleuse;
    end;
    4:
    begin
      catheader.version := 'CDCLINE2';
      n := n + l_outlines;
    end;
  end;
  for i := 1 to n do
  begin
    buf := flabel[i] + '           ';
    for j := 0 to 10 do
      catheader.flabel[i, j] := buf[j + 1];
  end;
  for i := n + 1 to 14 do
  begin
    buf := '           ';
    for j := 0 to 10 do
      catheader.flabel[i, j] := buf[j + 1];
  end;
  for i := 15 to 35 do
  begin
    buf := flabel[i - (15 - n)] + '           ';
    for j := 0 to 10 do
      catheader.flabel[i, j] := buf[j + 1];
  end;
  createindex := False;
  indexaltname := False;
  catheader.useprefix := 0;
  for i := 1 to l_sup do
    catheader.AltName[i] := altname[i];
  for i := 1 to l_sup do
    catheader.AltPrefix[i] := altprefix[i];
  buf := PChar(edit4.Text + '    ');
  for i := 1 to 4 do
    catheader.ShortName[i - 1] := buf[i];
  buf := PChar(edit5.Text + StringOfChar(' ', 50));
  for i := 1 to 50 do
    catheader.LongName[i - 1] := buf[i];
  catheader.hdrl := sizeof(catheader);
  catheader.filenum := 1;
  catheader.TxtFileName := extractfilename(listbox1.Items[0]);
  catheader.Equinox := floatedit1.Value;
  catheader.Epoch := floatedit3.Value;
  if catheader.version = 'CDCNEB 2' then
  begin
    catheader.MagMax := floatedit2.Value;
    catheader.Size := longedit1.Value;
    catheader.Units := nebulaesizescale;
    catheader.ObjType := nebtype[Combobox3.ItemIndex + 1];
    if CheckBox1.Checked then
      catheader.LogSize := 1
    else
      catheader.LogSize := 0;
  end
  else if catheader.version = 'CDCLINE2' then
  begin
    catheader.MagMax := floatedit2.Value;
    catheader.Size := longedit2.Value;
    catheader.Units := Shape1.Brush.Color;
    if checkbox7.Checked then
      catheader.ObjType := 1
    else
      catheader.ObjType := 0;
    catheader.LogSize := RadioGroup6.ItemIndex;
  end
  else
  begin
    catheader.MagMax := floatedit2.Value;
    catheader.Size := 0;
    catheader.Units := 0;
    catheader.ObjType := 0;
    catheader.LogSize := 0;
  end;
  curpos := 0;
  n := 1;
  //RA
  catheader.RAmode := radiogroup2.ItemIndex;
  catheader.fpos[n] := textpos[curpos, 1]; // H
  catheader.flen[n] := textpos[curpos, 2];
  Inc(curpos);
  Inc(n);
  if (radiogroup2.ItemIndex = 0) or (radiogroup2.ItemIndex = 2) then
  begin
    catheader.fpos[36] := textpos[curpos, 1]; // M
    catheader.flen[36] := textpos[curpos, 2];
    Inc(curpos);
    catheader.fpos[37] := textpos[curpos, 1]; // S
    catheader.flen[37] := textpos[curpos, 2];
    Inc(curpos);
  end;
  //DEC
  catheader.DECmode := radiogroup3.ItemIndex;
  if radiogroup3.ItemIndex = 0 then
  begin
    catheader.fpos[40] := textpos[curpos, 1]; // sign
    catheader.flen[40] := textpos[curpos, 2];
    Inc(curpos);
  end;
  catheader.fpos[n] := textpos[curpos, 1]; // D
  catheader.flen[n] := textpos[curpos, 2];
  Inc(curpos);
  Inc(n);
  if radiogroup3.ItemIndex = 0 then
  begin
    catheader.fpos[38] := textpos[curpos, 1]; // M
    catheader.flen[38] := textpos[curpos, 2];
    Inc(curpos);
    catheader.fpos[39] := textpos[curpos, 1]; // S
    catheader.flen[39] := textpos[curpos, 2];
    Inc(curpos);
  end;
  case radiogroup1.ItemIndex of
    //9 ('Catalog ID','[Magnitude V]','B-V','Magnitude B','Magnitude R','Spectral class','Proper motion RA','Proper motion DEC','epoch','Parallax','Comments');
    0:
    begin     // Stars
      for i := 1 to 11 do
      begin
        if CheckListBox1.Checked[curpos] then
        begin
          catheader.fpos[n] := textpos[curpos, 1];
          catheader.flen[n] := textpos[curpos, 2];
        end;
        Inc(curpos);
        Inc(n);
      end;
      Inc(n, 2); // skip 2
    end;
    //9 ('Catalog ID','[Magnitude max]','[Magnitude min]','Period','Type','Maxima Epoch','Rise Time','Spectral class','Magnitude code','Comments');
    1:
    begin     // variables
      for i := 1 to 10 do
      begin
        if CheckListBox1.Checked[curpos] then
        begin
          catheader.fpos[n] := textpos[curpos, 1];
          catheader.flen[n] := textpos[curpos, 2];
        end;
        Inc(curpos);
        Inc(n);
      end;
      Inc(n, 3); // skip 3
    end;
    //9 ('Catalog ID','[Magnitude component 1]','Magnitude component 2','[Separation]','Position angle','Epoch','Component name','Spectral class 1','Spectral class 2','Comments');
    2:
    begin     // Doubles Stars
      for i := 1 to 10 do
      begin
        if CheckListBox1.Checked[curpos] then
        begin
          catheader.fpos[n] := textpos[curpos, 1];
          catheader.flen[n] := textpos[curpos, 2];
        end;
        Inc(curpos);
        Inc(n);
      end;
      Inc(n); // skip 3
      Inc(n);
      Inc(n);
    end;
    //9 ('ID number','Nebula type','Magnitude','Surface brigtness','Largest dimension','Smallest diemnsion','Units','Position angle','Radial velocity','Morphological class','Comments','Color');
    3:
    begin     // Nebulae
      for i := 1 to 12 do
      begin
        if CheckListBox1.Checked[curpos] then
        begin
          catheader.fpos[n] := textpos[curpos, 1];
          catheader.flen[n] := textpos[curpos, 2];
        end;
        Inc(curpos);
        Inc(n);
      end;
      Inc(n); // skip 1
    end;
    //5 ('Catalog ID','[Line op]','Line width','Line color','use spline','Comments');
    4:
    begin     // Outlines
      for i := 1 to 6 do
      begin
        if CheckListBox1.Checked[curpos] then
        begin
          catheader.fpos[n] := textpos[curpos, 1];
          catheader.flen[n] := textpos[curpos, 2];
        end;
        Inc(curpos);
        Inc(n);
      end;
      Inc(n, 7); // skip 7
    end;
  end;
  for i := 0 to 19 do
  begin
    if CheckListBox1.Checked[curpos] then
    begin
      catheader.fpos[n] := textpos[curpos, 1];
      catheader.flen[n] := textpos[curpos, 2];
    end;
    Inc(curpos);
    Inc(n);
    if curpos >= CheckListBox1.Count then
      break;
  end;
  catheader.reclen := 0;
  catheader.IxKeylen := 0;
end;

function Tf_catgen.GetFloat(p: integer; default: double): double;
var
  code: integer;
begin
  val(trim(copy(inl, textpos[p, 1], textpos[p, 2])), Result, code);
  if code <> 0 then
    Result := default
  else
    Result := calc[p, 1] * Result + calc[p, 2];
end;

function Tf_catgen.GetInt(p: integer): integer;
var
  code: integer;
begin
  val(trim(copy(inl, textpos[p, 1], textpos[p, 2])), Result, code);
  if code <> 0 then
    Result := MaxInt;
end;

function Tf_catgen.GetString(p: integer): string;
begin
  Result := copy(inl, textpos[p, 1], textpos[p, 2]);
end;

function Tf_catgen.GetNebType(p: integer): byte;
var
  i: integer;
  buf: string;
begin
  buf := trim(copy(inl, textpos[p, 1], textpos[p, 2]));
  if buf = '' then
    Result := 255
  else
  begin
    Result := 255;
    buf := buf + ',';
    for i := 1 to 19 do
    begin
      if pos(buf, neblst[i]) > 0 then
      begin
        Result := nebtype[i];
        break;
      end;
    end;
  end;
end;

function Tf_catgen.GetNebUnit(p: integer): smallint;
var
  i: integer;
  buf: string;
begin
  buf := trim(copy(inl, textpos[p, 1], textpos[p, 2]));
  if buf = '' then
    Result := 60
  else
  begin
    Result := 60;
    buf := buf + ',';
    for i := 1 to 3 do
    begin
      if pos(buf, nebunit[i]) > 0 then
      begin
        Result := nebunits[i];
        break;
      end;
    end;
  end;
end;

function Tf_catgen.GetLineType(p: integer): smallint;
var
  i: integer;
  buf: string;
begin
  buf := trim(copy(inl, textpos[p, 1], textpos[p, 2]));
  if buf = '' then
    buf := ' ';
  Result := -1;
  buf := buf + ',';
  for i := 1 to 4 do
  begin
    if pos(buf, Linelst[i]) > 0 then
    begin
      Result := Linetype[i];
      break;
    end;
  end;
end;

function Tf_catgen.Getcolor(p: integer): Tcolor;
var
  i: integer;
  buf: string;
begin
  buf := trim(copy(inl, textpos[p, 1], textpos[p, 2]));
  if buf = '' then
    buf := ' ';
  Result := clWhite;
  buf := buf + ',';
  for i := 1 to 10 do
  begin
    if pos(buf, colorlst[i]) > 0 then
    begin
      case i of
        1: Result := shape2.brush.color;
        2: Result := shape3.brush.color;
        3: Result := shape4.brush.color;
        4: Result := shape5.brush.color;
        5: Result := shape6.brush.color;
        6: Result := shape7.brush.color;
        7: Result := shape8.brush.color;
        8: Result := shape9.brush.color;
        9: Result := shape10.brush.color;
        10: Result := shape11.brush.color;
      end;
      break;
    end;
  end;
end;

procedure Tf_catgen.PutRecDouble(x: double; p: integer);
begin
  move(x, datarec[catheader.fpos[p] - 1], catheader.flen[p]);
end;

procedure Tf_catgen.PutRecSingle(x: single; p: integer);
begin
  move(x, datarec[catheader.fpos[p] - 1], catheader.flen[p]);
end;

procedure Tf_catgen.PutRecInt(x: integer; p: integer);
begin
  move(x, datarec[catheader.fpos[p] - 1], catheader.flen[p]);
end;

procedure Tf_catgen.PutRecCard(x: cardinal; p: integer);
begin
  move(x, datarec[catheader.fpos[p] - 1], catheader.flen[p]);
end;

procedure Tf_catgen.PutRecSmallInt(x: integer; p: integer);
var
  i: smallint;
begin
  if x > 32767 then
    x := 32767;
  if x < -32768 then
    x := -32768;
  i := x;
  move(i, datarec[catheader.fpos[p] - 1], catheader.flen[p]);
end;

procedure Tf_catgen.PutRecByte(x: byte; p: integer);
begin
  move(x, datarec[catheader.fpos[p] - 1], catheader.flen[p]);
end;

procedure Tf_catgen.PutRecString(x: string; p: integer);
begin
  x := x + fillstring;
  move(x[1], datarec[catheader.fpos[p] - 1], catheader.flen[p]);
end;

{$ifdef build_old_index}
procedure Tf_catgen.PutIxSingle(x: single; p: integer);
begin
  move(x, indexrec[p * 4], 4);
end;

procedure Tf_catgen.PutIxkey(x: string);
begin
  x := x + fillstring;
  move(x[1], indexrec[8], ixlen);
end;

procedure Tf_catgen.WriteIx;
var
  n: integer;
begin
  blockwrite(ixf, indexrec[0], 8 + ixlen, n);
end;

{$endif}

procedure Tf_catgen.FindRegion30(ar, de: double; var lg: integer);
var
  i1, i2, N, L1: integer;
begin
  i1 := Trunc((de + 90) / 30);
  N := lg_reg_x30[i1, 1];
  L1 := lg_reg_x30[i1, 2];
  i2 := Trunc(ar / (360 / N));
  Lg := L1 + i2;
end;

procedure Tf_catgen.FindRegion15(ar, de: double; var lg: integer);
var
  i1, i2, N, L1: integer;
begin
  i1 := Trunc((de + 90) / 15);
  N := lg_reg_x15[i1, 1];
  L1 := lg_reg_x15[i1, 2];
  i2 := Trunc(ar / (360 / N));
  Lg := L1 + i2;
end;

procedure Tf_catgen.FindRegion7(ar, de: double; var hemis: char; var zone, S: integer);
var
  i1, i2, N, L1, L: integer;
  del: double;
begin
  if de > 0 then
    hemis := 'n'
  else
    hemis := 's';
  i1 := Trunc((de + 90) / 7.5);
  N := lg_reg_x7[i1, 1];
  L1 := lg_reg_x7[i1, 2];
  i2 := Trunc(ar / (360 / N));
  L := L1 + i2;
  del := Trunc(de / 7.5) * 7.5;
  S := L;
  zone := Trunc(abs(del)) * 100 + Trunc(Frac(abs(del)) * 60);
end;

procedure Tf_catgen.FindRegion(ar, de: double; var hemis: char; var zone, S: integer);
var
  i1, i2, j1, j2, N, L1, L, S1, k: integer;
  arl, del, dar, dde: double;
begin
  if de > 0 then
    hemis := 'n'
  else
    hemis := 's';
  i1 := Trunc((de + 90) / 7.5);
  N := lg_reg_x[i1, 1];
  L1 := lg_reg_x[i1, 2];
  i2 := Trunc(ar / (360 / N));
  L := L1 + i2;
  S1 := sm_reg_x[L, 1];
  k := sm_reg_x[L, 2];
  del := Trunc((de + 1e-12) / 7.5) * 7.5;
  arl := (360 / N) * i2;
  dde := 7.5 / k;
  dar := (360 / N) / k;
  j1 := Trunc(abs(de - del) / dde);
  j2 := Trunc((ar - arl) / dar);
  S := S1 + j1 * k + j2;
  zone := Trunc(abs(del)) * 100 + Trunc(Frac(abs(del)) * 60);
end;

procedure Tf_catgen.Createfiles;
var
  i, n, m: integer;
  f: file;
begin
  case catheader.FileNum of
    732: for n := 0 to 23 do
        Forcedirectories(destdir + zone_nam[n]);
    9537: for n := 0 to 23 do
        Forcedirectories(destdir + zone_nam[n]);
  end;
  filemode := 2;
  assignfile(f, destdir + lowercase(trim(catheader.ShortName)) + '.hdr');
  rewrite(f, 1);
  blockwrite(f, catheader, catheader.hdrl, n);
  Closefile(f);
{$ifdef build_old_index}
  if createindex then
  begin
    ixfn := lowercase(trim(catheader.ShortName)) + '.idx';
    assignfile(ixf, destdir + ixfn);
    if checkbox6.Checked then
    begin
      reset(ixf, 1);
      Seek(ixf, FileSize(ixf));
    end
    else
      rewrite(ixf, 1);
  end;
{$endif}
  for i := 1 to catheader.FileNum do
  begin
    if abort then
      raise Exception.Create(rsAbortedByUse);
    Fprogress.ProgressBar2.Position := i;
    Fprogress.label2.Caption := IntToStr(i);
    Fprogress.invalidate;
    m := 0;
    case catheader.FileNum of
      1: ffn[i] := lowercase(trim(catheader.ShortName)) + '.dat';
      50: ffn[i] := lowercase(trim(catheader.ShortName)) + padzeros(IntToStr(i), 2) + '.dat';
      184: ffn[i] := lowercase(trim(catheader.ShortName)) + padzeros(IntToStr(i), 3) + '.dat';
      732:
      begin
        for n := 0 to 23 do
          if i <= zone_lst7[n] then
          begin
            ;
            m := n;
            break;
          end;
        ffn[i] := slash(zone_nam[m]) + lowercase(trim(catheader.ShortName)) +
          padzeros(IntToStr(i), 3) + '.dat';
      end;
      9537:
      begin
        for n := 0 to 23 do
          if i <= zone_lst[n] then
          begin
            ;
            m := n;
            break;
          end;
        ffn[i] := slash(zone_nam[m]) + lowercase(trim(catheader.ShortName)) +
          padzeros(IntToStr(i), 4) + '.dat';
      end;
      else
        raise ERangeError.CreateFmt('Invalid number of files : %d', [catheader.filenum]);
    end;
    assignfile(ff[i], destdir + ffn[i]);
    if checkbox6.Checked then
    begin
      reset(ff[i], 1);
      Seek(ff[i], FileSize(ff[i]));
    end
    else
      rewrite(ff[i], 1);
  end;
end;

procedure Tf_catgen.CreateTxtfiles;
var
  i, n: integer;
  f: file;
begin
  filemode := 2;
  assignfile(f, destdir + lowercase(trim(catheader.ShortName)) + '.hdr');
  rewrite(f, 1);
  blockwrite(f, catheader, catheader.hdrl, n);
  Closefile(f);
  for i := 1 to 15 do
    catinfo.neblst[i] := neblst[i];
  for i := 1 to 15 do
    catinfo.nebtype[i] := nebtype[i];
  for i := 1 to 3 do
    catinfo.nebunit[i] := nebunit[i];
  for i := 1 to 3 do
    catinfo.nebunits[i] := nebunits[i];
  for i := 1 to 4 do
    catinfo.Linelst[i] := Linelst[i];
  for i := 1 to 4 do
    catinfo.Linetype[i] := Linetype[i];
  for i := 1 to 10 do
    catinfo.Colorlst[i] := Colorlst[i];
  for i := 1 to 10 do
  begin
    case i of
      1: catinfo.Color[i] := shape2.brush.color;
      2: catinfo.Color[i] := shape3.brush.color;
      3: catinfo.Color[i] := shape4.brush.color;
      4: catinfo.Color[i] := shape5.brush.color;
      5: catinfo.Color[i] := shape6.brush.color;
      6: catinfo.Color[i] := shape7.brush.color;
      7: catinfo.Color[i] := shape8.brush.color;
      8: catinfo.Color[i] := shape9.brush.color;
      9: catinfo.Color[i] := shape10.brush.color;
      10: catinfo.Color[i] := shape11.brush.color;
    end;
  end;
  for i := 0 to 40 do
  begin
    catinfo.calc[i, 1] := calc[i, 1];
    catinfo.calc[i, 2] := calc[i, 2];
  end;
  catinfo.caturl := trim(edit6.Text);
  assignfile(f, destdir + lowercase(trim(catheader.ShortName)) + '.info2');
  rewrite(f, 1);
  blockwrite(f, catinfo, sizeof(catinfo), n);
  Closefile(f);
end;

procedure Tf_catgen.Closefiles;
var
  i: integer;
begin
  for i := 1 to catheader.FileNum do
  begin
    Fprogress.ProgressBar2.Position := i;
    Fprogress.label2.Caption := IntToStr(i);
    Fprogress.invalidate;
    Closefile(ff[i]);
  end;
{$ifdef build_old_index}
  if createindex then
    closefile(ixf);
{$endif}
end;

procedure Tf_catgen.WriteRec(num: integer);
var
  n: integer;
begin
  blockwrite(ff[num], datarec[0], catheader.reclen, n);
end;

procedure Tf_catgen.RejectRec(lin: string);
begin
  if not rejectopen then
  begin
    assignfile(freject, destdir + 'reject.txt');
    rewrite(freject);
    rejectopen := True;
  end;
  writeln(freject, lin);
end;

procedure Tf_catgen.BuildFiles;
var
  ra, s, de: double;
  nextpos, reg, zone, i, j, n: integer;
  hemis: char;
    {$ifdef build_old_index}
  ixra, ixde: single;
    {$endif}
begin
  Fprogress.progressbar1.max := ListBox1.Items.Count;
  fillstring := StringOfChar(' ', 255);
  for n := 0 to ListBox1.Items.Count - 1 do
  begin
    Fprogress.label1.Caption := Format(rsConvertCatal, [ListBox1.Items[n]]);
    Fprogress.progressbar1.position := n + 1;
    Fprogress.invalidate;
    OpenCatalog(ListBox1.Items[n]);
    Fprogress.progressbar2.max := GetCatalogSize;
    ra := 0;
    de := 0;
    i := 0;
    repeat
      Inc(i);
      if (i mod 1000) = 0 then
      begin
        if abort then
          raise Exception.Create(rsAbortedByUse);
        Fprogress.progressbar2.position := GetCatalogPos;
        Fprogress.progressbar2.invalidate;
        application.ProcessMessages;
      end;
      ReadCatalog(inl);
      nextpos := 0;
      case RadioGroup2.ItemIndex of
        0:
        begin
          ra := 15 * (Getfloat(nextpos + 0, 0) + Getfloat(nextpos + 1, 0) / 60 + Getfloat(
            nextpos + 2, 0) / 3600);
          nextpos := nextpos + 3;
        end;
        1:
        begin
          ra := 15 * (Getfloat(nextpos + 0, 0));
          nextpos := nextpos + 1;
        end;
        2:
        begin
          ra := Getfloat(nextpos + 0, 0) + Getfloat(nextpos + 1, 0) / 60 + Getfloat(nextpos + 2, 0) / 3600;
          nextpos := nextpos + 3;
        end;
        3:
        begin
          ra := Getfloat(nextpos + 0, 0);
          nextpos := nextpos + 1;
        end;
      end;
      case RadioGroup3.ItemIndex of
        0:
        begin
          if GetString(nextpos) = '-' then
            s := -1
          else
            s := 1;
          de := s * Getfloat(nextpos + 1, 0) + s * Getfloat(nextpos + 2, 0) / 60 + s *
            Getfloat(nextpos + 3, 0) / 3600;
          nextpos := nextpos + 4;
        end;
        1:
        begin
          de := Getfloat(nextpos + 0, 0);
          nextpos := nextpos + 1;
        end;
        2:
        begin
          de := Getfloat(nextpos + 0, 0) - 90;
          nextpos := nextpos + 1;
        end;
      end;
      if ((ra = 0) and (de = 0)) or (ra < 0) or (ra > 360) or (de < -90) or (de > 90) then
      begin
        RejectRec(inl);
        continue;
      end;
      PutRecCard(round(ra * 3600000), 1);
      PutRecCard(round((de + 90) * 3600000), 2);
  {$ifdef build_old_index}
      if createindex then
      begin
        ixra := ra;
        ixde := de;
        PutIxSingle(ixra, 0);
        PutIxSingle(ixde, 1);
      end;
  {$endif}
      case radiogroup1.ItemIndex of
        //9 ('Catalog ID','[Magnitude V]','B-V','Magnitude B','Magnitude R','Spectral class','Proper motion RA','Proper motion DEC','Parallax','Comments');
        0:
        begin     // Stars
          if catheader.flen[3] > 0 then
            PutRecString(GetString(nextpos), 3);  // id
          Inc(nextpos);
          if catheader.flen[4] > 0 then
            PutRecSmallint(round(Getfloat(nextpos, 99) * 1000), 4);   // ma
          Inc(nextpos);
          if catheader.flen[5] > 0 then
            PutRecSmallint(round(Getfloat(nextpos, 99) * 1000), 5);   // b-v
          Inc(nextpos);
          if catheader.flen[6] > 0 then
            PutRecSmallint(round(Getfloat(nextpos, 99) * 1000), 6);   // b
          Inc(nextpos);
          if catheader.flen[7] > 0 then
            PutRecSmallint(round(Getfloat(nextpos, 99) * 1000), 7);   // r
          Inc(nextpos);
          if catheader.flen[8] > 0 then
            PutRecString(GetString(nextpos), 8);  // sp
          Inc(nextpos);
          if catheader.flen[9] > 0 then
            PutRecSmallint(round(Getfloat(nextpos, 0) * 1000), 9);   // pmar
          Inc(nextpos);
          if catheader.flen[10] > 0 then
            PutRecSmallint(round(Getfloat(nextpos, 0) * 1000), 10);   // pmde
          Inc(nextpos);
          if catheader.flen[11] > 0 then
            PutRecSingle(Getfloat(nextpos, 0), 11);   // pos epoch
          Inc(nextpos);
          if catheader.flen[12] > 0 then
            PutRecSmallint(round(Getfloat(nextpos, 0) * 10000), 12);  // px
          Inc(nextpos);
          if catheader.flen[13] > 0 then
            PutRecString(GetString(nextpos), 13); // com
          Inc(nextpos);
        end;
        //9 ('Catalog ID','[Magnitude max]','[Magnitude min]','Period','Type','Maxima Epoch','Rise Time','Spectral class','Magnitude code','Comments');
        1:
        begin     // Variables Stars
          if catheader.flen[3] > 0 then
            PutRecString(GetString(nextpos), 3);  // id
          Inc(nextpos);
          if catheader.flen[4] > 0 then
            PutRecSmallint(round(Getfloat(nextpos, 99) * 1000), 4);   // ma 1
          Inc(nextpos);
          if catheader.flen[5] > 0 then
            PutRecSmallint(round(Getfloat(nextpos, 99) * 1000), 5);   // ma 2
          Inc(nextpos);
          if catheader.flen[6] > 0 then
            PutRecSingle(Getfloat(nextpos, 0), 6);   // period
          Inc(nextpos);
          if catheader.flen[7] > 0 then
            PutRecString(GetString(nextpos), 7);  // type
          Inc(nextpos);
          if catheader.flen[8] > 0 then
            PutRecSingle(Getfloat(nextpos, 0), 8);   // epoch
          Inc(nextpos);
          if catheader.flen[9] > 0 then
            PutRecSmallint(round(Getfloat(nextpos, 0) * 100), 9);   // rise
          Inc(nextpos);
          if catheader.flen[10] > 0 then
            PutRecString(GetString(nextpos), 10);  // sp
          Inc(nextpos);
          if catheader.flen[11] > 0 then
            PutRecString(GetString(nextpos), 11);  // m code
          Inc(nextpos);
          if catheader.flen[12] > 0 then
            PutRecString(GetString(nextpos), 12);  // com
          Inc(nextpos);
        end;
        //9 ('Catalog ID','[Magnitude component 1]','Magnitude component 2','[Separation]','Position angle','Epoch','Component name','Spectral class 1','Spectral class 2','Comments');
        2:
        begin     // Doubles Stars
          if catheader.flen[3] > 0 then
            PutRecString(GetString(nextpos), 3);  // id
          Inc(nextpos);
          if catheader.flen[4] > 0 then
            PutRecSmallint(round(Getfloat(nextpos, 99) * 1000), 4);   // ma 1
          Inc(nextpos);
          if catheader.flen[5] > 0 then
            PutRecSmallint(round(Getfloat(nextpos, 99) * 1000), 5);   // ma 2
          Inc(nextpos);
          if catheader.flen[6] > 0 then
            PutRecSmallint(round(Getfloat(nextpos, 0) * 10), 6);   // sep
          Inc(nextpos);
          if catheader.flen[7] > 0 then
            PutRecSmallint(round(Getfloat(nextpos, -999)), 7);   // pa
          Inc(nextpos);
          if catheader.flen[8] > 0 then
            PutRecSingle(Getfloat(nextpos, 0), 8);   // epoch
          Inc(nextpos);
          if catheader.flen[9] > 0 then
            PutRecString(GetString(nextpos), 9);  // comp
          Inc(nextpos);
          if catheader.flen[10] > 0 then
            PutRecString(GetString(nextpos), 10);  // sp 1
          Inc(nextpos);
          if catheader.flen[11] > 0 then
            PutRecString(GetString(nextpos), 11);  // sp 2
          Inc(nextpos);
          if catheader.flen[12] > 0 then
            PutRecString(GetString(nextpos), 12); // com
          Inc(nextpos);
        end;
        //9 ('ID number','Nebula type','Magnitude','Surface brigtness','Largest dimension','Smallest diemnsion','Position angle','Radial velocity','Morphological class','Comments','Color');
        3:
        begin     // Nebulae
          if catheader.flen[3] > 0 then
            PutRecString(GetString(nextpos), 3);  // id
          Inc(nextpos);
          if catheader.flen[4] > 0 then
            PutRecByte(GetNebType(nextpos), 4);       // nebtyp
          Inc(nextpos);
          if catheader.flen[5] > 0 then
            PutRecSmallint(round(Getfloat(nextpos, 99) * 1000), 5);   // ma
          Inc(nextpos);
          if catheader.flen[6] > 0 then
            PutRecSmallint(round(Getfloat(nextpos, 99) * 1000), 6);   // sbr
          Inc(nextpos);
          if catheader.flen[7] > 0 then
            PutRecSingle(Getfloat(nextpos, 0), 7);   // size
          Inc(nextpos);
          if catheader.flen[8] > 0 then
            PutRecSingle(Getfloat(nextpos, 0), 8);   // size2
          Inc(nextpos);
          if catheader.flen[9] > 0 then
            PutRecSmallint(GetNebUnit(nextpos), 9);   // Unit
          Inc(nextpos);
          if catheader.flen[10] > 0 then
            PutRecSmallint(round(Getfloat(nextpos, 99999)), 10);   // pa
          Inc(nextpos);
          if catheader.flen[11] > 0 then
            PutRecSingle(Getfloat(nextpos, 0), 11);  // rv
          Inc(nextpos);
          if catheader.flen[12] > 0 then
            PutRecString(GetString(nextpos), 12); // class
          Inc(nextpos);
          if catheader.flen[13] > 0 then
            PutRecString(GetString(nextpos), 13); // com
          Inc(nextpos);
          if catheader.flen[14] > 0 then
            PutRecCard(Getcolor(nextpos), 14);   // color
          Inc(nextpos);
        end;
        //5 ('Catalog ID','[Line op]','Line width','Line color','use spline','Comments');
        4:
        begin     // Nebulae outlines
          if catheader.flen[3] > 0 then
            PutRecString(GetString(nextpos), 3);  // id
          Inc(nextpos);
          if catheader.flen[4] > 0 then
            PutRecByte(GetLineType(nextpos), 4);       // linetyp
          Inc(nextpos);
          if catheader.flen[5] > 0 then
            PutRecByte(round(Getfloat(nextpos, 1)), 5);   // line width
          Inc(nextpos);
          if catheader.flen[6] > 0 then
            PutRecCard(Getcolor(nextpos), 6);   // linecolor
          Inc(nextpos);
          if catheader.flen[7] > 0 then
            PutRecByte(round(Getfloat(nextpos, 1)), 7);   // drawing
          Inc(nextpos);
          if catheader.flen[8] > 0 then
            PutRecString(GetString(nextpos), 8); // com
          Inc(nextpos);
        end;
      end;
      for j := 16 to 25 do
      begin
        if catheader.flen[j] > 0 then
          PutRecString(GetString(nextpos), j);  // str
        Inc(nextpos);
      end;
      for j := 26 to 35 do
      begin
        if catheader.flen[j] > 0 then
          PutRecSingle(Getfloat(nextpos, 0), j);   // num
        Inc(nextpos);
      end;
  {$ifdef build_old_index}
      if createindex then
        for j := 0 to nbalt do
        begin
          if usealt[j].i > 0 then
          begin
            buf := uppercase(StringReplace(GetString(usealt[j].i), ' ', '', [rfReplaceAll]));
            if buf > '' then
            begin
              if (j > 0) and (catheader.useprefix >= 1) then
                buf := usealt[j].l + buf;
              if (j = 0) and CheckBox8.Checked then
                buf := usealt[j].l + buf;
              PutIxKey(buf);
              WriteIx;
            end;
          end;
        end;
  {$endif}
      case catheader.filenum of
        1: reg := 1;
        50: FindRegion30(ra, de, reg);
        184: FindRegion15(ra, de, reg);
        732: FindRegion7(ra, de, hemis, zone, reg);
        9537: FindRegion(ra, de, hemis, zone, reg);
      end;
      WriteRec(reg);
    until CatalogEOF;
    CloseCatalog;
  end;
end;

function Tf_catgen.filegetsize(fn: string): integer;
var
  f: file;
begin
  assignfile(f, fn);
  filemode := 0;
  reset(f, 1);
  Result := filesize(f);
  closefile(f);
end;

function CompareMag(Item1, Item2: Pointer): integer;
begin
  Result := CompSmallAt(Item1, Item2, keypos - 1);
end;

{$ifdef build_old_index}
function CompareIX(Item1, Item2: Pointer): integer;
begin
  Result := CompareTextFrom(Item1, Item2, 9, ixlen);
end;

{$endif}

function CompareIXrec(Item1, Item2: Pointer): integer;
begin
  Result := CompareTextFrom(Item1, Item2, 7, ixlen);
end;

procedure Tf_catgen.Sortfiles;
var
  i: integer;
  Sorter: TFixRecSort;
begin
  for i := 1 to catheader.FileNum do
  begin
    if abort then
      raise Exception.Create(rsAbortedByUse);
    Fprogress.ProgressBar2.Position := i;
    Fprogress.label2.Caption := IntToStr(i);
    Fprogress.invalidate;
    if filegetsize(destdir + ffn[i]) <= catheader.reclen then
      continue;
    Sorter := TFixRecSort.Create(catheader.reclen);
    Sorter.Stable := True;
    Sorter.Start(destdir + ffn[i], destdir + 'sort.out', @CompareMag);
    Sorter.Free;
    DeleteFile(destdir + ffn[i]);
    RenameFile(destdir + 'sort.out', destdir + ffn[i]);
  end;
end;

{$ifdef build_old_index}
procedure Tf_catgen.SortIXfile;
var
  Sorter: TFixRecSort;
begin
  Fprogress.progressbar2.max := 2;
  Fprogress.progressbar2.position := 1;
  Fprogress.label1.Caption := rsSortingTheIn;
  Fprogress.label2.Caption := '';
  application.ProcessMessages;
  Sorter := TFixRecSort.Create(ixlen + 8);
  Sorter.Stable := True;
  Sorter.Start(destdir + ixfn, destdir + 'sort.out', @CompareIX);
  Fprogress.progressbar2.position := 2;
  application.ProcessMessages;
  Sorter.Free;
  DeleteFile(destdir + ixfn);
  RenameFile(destdir + 'sort.out', destdir + ixfn);
end;

{$endif}

procedure Tf_catgen.BuildBinCat;
begin
  Fprogress.onAbortClick := @ProgressAbort;
  Fprogress.progressbar1.max := 4;
  Fprogress.progressbar1.position := 0;
  Fprogress.progressbar2.max := 1;
  Fprogress.progressbar2.position := 0;
  Fprogress.label1.Caption := rsCreateHeader;
  Fprogress.label2.Caption := '';
  Fprogress.Show;
  application.ProcessMessages;
  BuildHeader;
  Fprogress.progressbar2.position := 1;
  Fprogress.invalidate;
  Fprogress.label1.Caption := rsCreateFiles;
  Fprogress.progressbar1.position := 1;
  Fprogress.progressbar2.max := catheader.filenum;
  Fprogress.progressbar2.position := 0;
  Fprogress.label2.Caption := '';
  Fprogress.invalidate;
  application.ProcessMessages;
  CreateFiles;
  Fprogress.label1.Caption := rsConvertCatal2;
  Fprogress.progressbar1.position := 2;
  Fprogress.progressbar2.max := 1;
  Fprogress.progressbar2.position := 0;
  Fprogress.label2.Caption := '';
  Fprogress.invalidate;
  application.ProcessMessages;
  BuildFiles;
  Fprogress.label1.Caption := rsCloseFiles;
  Fprogress.progressbar1.max := 4;
  Fprogress.progressbar1.position := 3;
  Fprogress.progressbar2.max := catheader.filenum;
  Fprogress.progressbar2.position := 0;
  Fprogress.label2.Caption := '';
  Fprogress.invalidate;
  application.ProcessMessages;
  CloseFiles;
  if radiogroup1.ItemIndex < 4 then
  begin
    Fprogress.label1.Caption := rsSortingFiles;
    Fprogress.progressbar1.position := 4;
    Fprogress.progressbar2.max := catheader.filenum;
    Fprogress.progressbar2.position := 0;
    Fprogress.label2.Caption := '';
    Fprogress.invalidate;
    application.ProcessMessages;
    SortFiles;
  end;
{$ifdef build_old_index}
  if createindex then
    SortIXfile;
{$endif}
  if createindex then
    BuildIXrec;
  if rejectopen then
  begin
    rejectopen := False;
    closefile(freject);
    ShowMessage(Format(rsSomeRecordsW, [destdir]));
  end;
end;

procedure Tf_catgen.BuildTxtCat;
begin
  BuildTxtHeader;
  CreateTxtfiles;
end;

procedure Tf_catgen.EndbtClick(Sender: TObject);
var
  i: integer;
begin
  try
    abort := False;
    chdir(appdir);
    if not DirectoryExists(directoryedit1.Text) then
    begin
      ShowMessage(rsPleaseIndica3);
      directoryedit1.SetFocus;
      exit;
    end;
    if FileIsReadOnly(directoryedit1.Text) then
    begin
      ShowMessage(rsCannotWriteT + ' ' + directoryedit1.Text);
      directoryedit1.SetFocus;
      exit;
    end;
    if checkbox6.Checked and (messagedlg(Format(rsWARNINGYouHa, [crlf, crlf, crlf, crlf]),
      mtConfirmation, [mbYes, mbNo], 0) <> mrYes) then
      exit;
    try
      destdir := slash(directoryedit1.Text);
      panel1.Enabled := False;
      if not directoryexists(destdir) then
        Forcedirectories(destdir);
      for i := 1 to 19 do
        neblst[i] := trim(stringgrid1.cells[1, i]) + ',';
      for i := 1 to 3 do
        nebunit[i] := trim(stringgrid2.cells[1, i]) + ',';
      for i := 1 to 3 do
        linelst[i] := trim(stringgrid3.cells[1, i]) + ',';
      for i := 1 to 10 do
        colorlst[i] := trim(stringgrid4.cells[0, i]) + ',';
      if binarycat.ItemIndex = 0 then
        BuildBinCat
      else
        BuildTxtCat;
      Endbt.Visible := False;
      Exitbt.Visible := True;
    finally
      Fprogress.hide;
      panel1.Enabled := True;
    end;
  except
    on E: Exception do
    begin
      WriteTrace('Catgen error: ' + E.Message);
      MessageDlg('Error: ' + E.Message, mtError, [mbClose], 0);
    end;
  end;
end;

procedure Tf_catgen.ComboBox1Change(Sender: TObject);
begin
  case Combobox1.ItemIndex of
    0: nebulaesizescale := 1;
    1: nebulaesizescale := 60;
    2: nebulaesizescale := 3600;
  end;
end;

procedure Tf_catgen.ExitbtClick(Sender: TObject);
begin
  Close;
end;

procedure Tf_catgen.Memo1MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: integer);
var
  i, j, k, l: integer;
begin
  i := memo1.selstart;
  j := memo1.SelLength;
  if (i >= 0) and (j > 0) then
  begin
    k := length(memo1.Lines.Strings[0]);
    l := length(memo1.Lines.Strings[1]);
    if i > k then
      if i > (k + l) then
        i := i - k - l - 4
      else
        i := i - k - 2;
    i := i + 1;
    edit1.Text := IntToStr(i);
    edit2.Text := IntToStr(j);
  end;
end;

procedure Tf_catgen.SpeedButton1Click(Sender: TObject);
var
  i: integer;
begin
  opendialog1.filterindex := 1;
  opendialog1.DefaultExt := '';
  OpenDialog1.Options := OpenDialog1.Options + [ofAllowMultiSelect];
  opendialog1.filename := '';
  if opendialog1.Execute then
  begin
    ListBox1.Items.Clear;
    for i := 0 to opendialog1.files.Count - 1 do
    begin
      ListBox1.Items.Add(opendialog1.files[i]);
    end;
  end;
end;

procedure Tf_catgen.Button1Click(Sender: TObject);
var
  ini: Tinifile;
  i: integer;
  fn, prjdir: string;
begin
  chdir(appdir);
  savedialog1.filterindex := 2;
  savedialog1.DefaultExt := '.prj';
  if savedialog1.Execute then
  begin
    fn := SafeUTF8ToSys(savedialog1.filename);
    if fileexists(fn) then
    begin
      deletefile(fn + '.old');
      renamefile(fn, fn + '.old');
    end;
    prjdir := ExtractFilePath(fn);
    ini := Tinifile.Create(fn);
    ini.writeInteger('Page1', 'binarycat', binarycat.ItemIndex);
    ini.writeInteger('Page1', 'type', RadioGroup1.ItemIndex);
    ini.writeString('Page1', 'shortname', edit4.Text);
    ini.writeString('Page1', 'longname', edit5.Text);
    ini.writeInteger('Page1', 'numfiles', ListBox1.Items.Count);
    for i := 0 to ListBox1.Items.Count - 1 do
      ini.writeString('Page1', 'inputfiles' + IntToStr(i), ExtractRelativepath(
        prjdir, ListBox1.Items[i]));
    ini.writeString('Page1', 'caturl', edit6.Text);
    ini.writeInteger('Page2', 'ratype', RadioGroup2.ItemIndex);
    ini.writeInteger('Page2', 'dectype', RadioGroup3.ItemIndex);
    ini.writeFloat('Page2', 'equinox', FloatEdit1.Value);
    ini.writeFloat('Page2', 'epoch', FloatEdit3.Value);
    ini.writeFloat('Page2', 'magmax', FloatEdit2.Value);
    ini.writeInteger('Page2', 'nebsize', LongEdit1.Value);
    ini.writeInteger('Page2', 'nebunit', Combobox1.ItemIndex);
    ini.writeInteger('Page2', 'nebtype', Combobox3.ItemIndex);
    ini.writeBool('Page2', 'neblog', checkbox1.Checked);
    ini.writeInteger('Page2', 'linewidth', LongEdit2.Value);
    ini.writeInteger('Page2', 'linecolor', shape1.Brush.color);
    ini.writeInteger('Page2', 'drawingtype', RadioGroup6.ItemIndex);
    ini.writeBool('Page2', 'closedline', checkbox7.Checked);
    ini.writeInteger('Page3', 'numitem', checklistbox1.Items.Count);
    for i := 0 to checklistbox1.Items.Count - 1 do
      ini.writeBool('Page3', 'field' + IntToStr(i), checklistbox1.Checked[i]);
    for i := 1 to 35 do
      ini.writeString('Page3', 'label' + IntToStr(i), flabel[i]);
    for i := 0 to 40 do
    begin
      ini.writeInteger('Page3', 'fieldindex' + IntToStr(i), textpos[i, 1]);
      ini.writeInteger('Page3', 'fieldlength' + IntToStr(i), textpos[i, 2]);
      ini.writeFloat('Page3', 'calcA' + IntToStr(i), calc[i, 1]);
      ini.writeFloat('Page3', 'calcB' + IntToStr(i), calc[i, 2]);
    end;
    for i := 1 to l_sup do
      ini.writeInteger('Page3', 'altname' + IntToStr(i), altname[i]);
    for i := 1 to l_sup do
      ini.WriteInteger('Page3', 'altprefix' + IntToStr(i), altprefix[i]);
    ini.writeInteger('Page4', 'numfile', RadioGroup4.ItemIndex);
    ini.writeString('Page4', 'ouputdir', ExtractRelativepath(
      prjdir, slash(DirectoryEdit1.Text)));
    ini.writeBool('Page4', 'index', checkbox3.Checked);
    ini.writeBool('Page4', 'altindex', checkbox4.Checked);
    ini.writeBool('Page4', 'prefname', checkbox8.Checked);
    ini.writeBool('Page4', 'append', checkbox6.Checked);
    with stringgrid1 do
      for i := 1 to 16 do
        ini.writeString('Page5', 'nebtype' + IntToStr(i), cells[1, i]);
    with stringgrid2 do
      for i := 1 to 3 do
        ini.writeString('Page5', 'unit' + IntToStr(i), cells[1, i]);
    with stringgrid3 do
      for i := 1 to 4 do
        ini.writeString('Page6', 'linetype' + IntToStr(i), cells[1, i]);
    with stringgrid4 do
      for i := 1 to 10 do
        ini.writeString('Page7', 'colorstr' + IntToStr(i), cells[0, i]);
    ini.writeInteger('Page7', 'color1', shape2.Brush.Color);
    ini.writeInteger('Page7', 'color2', shape3.Brush.Color);
    ini.writeInteger('Page7', 'color3', shape4.Brush.Color);
    ini.writeInteger('Page7', 'color4', shape5.Brush.Color);
    ini.writeInteger('Page7', 'color5', shape6.Brush.Color);
    ini.writeInteger('Page7', 'color6', shape7.Brush.Color);
    ini.writeInteger('Page7', 'color7', shape8.Brush.Color);
    ini.writeInteger('Page7', 'color8', shape9.Brush.Color);
    ini.writeInteger('Page7', 'color9', shape10.Brush.Color);
    ini.writeInteger('Page7', 'color10', shape11.Brush.Color);
    ini.Free;
  end;
  chdir(appdir);
end;

procedure Tf_catgen.Button2Click(Sender: TObject);
var
  ini: Tinifile;
  i, n: integer;
  buf, fn, prjdir: string;
  bufok: boolean;
begin
  chdir(appdir);
  opendialog1.filterindex := 2;
  opendialog1.DefaultExt := '.prj';
  OpenDialog1.Options := OpenDialog1.Options - [ofAllowMultiSelect];
  opendialog1.filename := '';
  if opendialog1.Execute then
  begin
    fn := SafeUTF8ToSys(OpenDialog1.filename);
    prjdir := ExtractFilePath(fn);
    ini := Tinifile.Create(fn);
    binarycat.ItemIndex := ini.ReadInteger('Page1', 'binarycat', 0);
    RadioGroup1.ItemIndex := ini.ReadInteger('Page1', 'type', RadioGroup1.ItemIndex);
    edit4.Text := ini.readString('Page1', 'shortname', edit4.Text);
    edit5.Text := ini.readString('Page1', 'longname', edit5.Text);
    edit6.Text := ini.readString('Page1', 'caturl', '');
    n := ini.readInteger('Page1', 'numfiles', 0);
    ListBox1.Items.Clear;
    chdir(prjdir);
    for i := 0 to n - 1 do
    begin
      buf := ini.readString('Page1', 'inputfiles' + IntToStr(i), '');
      if trim(buf) > '' then
      begin
        buf := ExpandFileName(buf);
        ListBox1.Items.Add(buf);
      end;
    end;
    chdir(appdir);
    RadioGroup2.ItemIndex := ini.readInteger('Page2', 'ratype', RadioGroup2.ItemIndex);
    RadioGroup3.ItemIndex := ini.readInteger('Page2', 'dectype', RadioGroup3.ItemIndex);
    FloatEdit1.Value := ini.readFloat('Page2', 'equinox', FloatEdit1.Value);
    FloatEdit3.Value := ini.readFloat('Page2', 'epoch', FloatEdit3.Value);
    FloatEdit2.Value := ini.readFloat('Page2', 'magmax', FloatEdit2.Value);
    LongEdit1.Value := ini.readInteger('Page2', 'nebsize', LongEdit1.Value);
    Combobox1.ItemIndex := ini.readInteger('Page2', 'nebunit', Combobox1.ItemIndex);
    ComboBox1Change(self);
    Combobox3.ItemIndex := ini.readInteger('Page2', 'nebtype', Combobox3.ItemIndex);
    checkbox1.Checked := ini.readBool('Page2', 'neblog', checkbox1.Checked);
    LongEdit2.Value := ini.readInteger('Page2', 'linewidth', LongEdit2.Value);
    shape1.Brush.color := ini.readInteger('Page2', 'linecolor', shape1.Brush.color);
    RadioGroup6.ItemIndex := ini.readInteger('Page2', 'drawingtype', RadioGroup6.ItemIndex);
    checkbox7.Checked := ini.ReadBool('Page2', 'closedline', checkbox7.Checked);
    n := ini.readInteger('Page3', 'numitem', 0);
    for i := 0 to n - 1 do
      checklistbox1.Checked[i] :=
        ini.readBool('Page3', 'field' + IntToStr(i), checklistbox1.Checked[i]);
    for i := 1 to 35 do
      flabel[i] := ini.readString('Page3', 'label' + IntToStr(i), flabel[i]);
    for i := 0 to 40 do
    begin
      textpos[i, 1] := ini.readInteger('Page3', 'fieldindex' + IntToStr(i), textpos[i, 1]);
      textpos[i, 2] := ini.readInteger('Page3', 'fieldlength' + IntToStr(i), textpos[i, 2]);
      calc[i, 1] := ini.readFloat('Page3', 'calcA' + IntToStr(i), 1);
      calc[i, 2] := ini.readFloat('Page3', 'calcB' + IntToStr(i), 0);
    end;
    for i := 1 to l_sup do
      altname[i] := ini.readInteger('Page3', 'altname' + IntToStr(i), altname[i]);
    // for migration of old .prj
    bufok := ini.ReadBool('Page4', 'prefalt', False); // old checkbox5.checked
    for i := 1 to l_sup do
      if bufok and (altname[i] = 1) then
        altprefix[i] := 1
      else
        altprefix[i] := 0;

    for i := 1 to l_sup do
      altprefix[i] := ini.ReadInteger('Page3', 'altprefix' + IntToStr(i), altprefix[i]);
    RadioGroup4.ItemIndex := ini.readInteger('Page4', 'numfile', RadioGroup4.ItemIndex);
    buf := ini.readString('Page4', 'ouputdir', '');
    chdir(prjdir);
    buf := ExpandFileName(buf);
    chdir(appdir);
    DirectoryEdit1.Text := buf;
    checkbox3.Checked := ini.readBool('Page4', 'index', checkbox3.Checked);
    checkbox4.Checked := ini.readBool('Page4', 'altindex', checkbox4.Checked);
    checkbox8.Checked := ini.readBool('Page4', 'prefname', checkbox8.Checked);
    checkbox6.Checked := ini.readBool('Page4', 'append', checkbox6.Checked);
    with stringgrid1 do
      for i := 1 to 16 do
        cells[1, i] := ini.readString('Page5', 'nebtype' + IntToStr(i), cells[1, i]);
    with stringgrid2 do
      for i := 1 to 3 do
        cells[1, i] := ini.readString('Page5', 'unit' + IntToStr(i), cells[1, i]);
    with stringgrid3 do
      for i := 1 to 4 do
        cells[1, i] := ini.readString('Page6', 'linetype' + IntToStr(i), cells[1, i]);
    with stringgrid4 do
      for i := 1 to 10 do
        cells[0, i] := ini.readString('Page7', 'colorstr' + IntToStr(i), cells[0, i]);
    shape2.Brush.Color := ini.readInteger('Page7', 'color1', shape2.Brush.Color);
    shape3.Brush.Color := ini.readInteger('Page7', 'color2', shape3.Brush.Color);
    shape4.Brush.Color := ini.readInteger('Page7', 'color3', shape4.Brush.Color);
    shape5.Brush.Color := ini.readInteger('Page7', 'color4', shape5.Brush.Color);
    shape6.Brush.Color := ini.readInteger('Page7', 'color5', shape6.Brush.Color);
    shape7.Brush.Color := ini.readInteger('Page7', 'color6', shape7.Brush.Color);
    shape8.Brush.Color := ini.readInteger('Page7', 'color7', shape8.Brush.Color);
    shape9.Brush.Color := ini.readInteger('Page7', 'color8', shape9.Brush.Color);
    shape10.Brush.Color := ini.readInteger('Page7', 'color9', shape10.Brush.Color);
    shape11.Brush.Color := ini.readInteger('Page7', 'color10', shape11.Brush.Color);
    ini.Free;
  end;
  chdir(appdir);
end;

procedure Tf_catgen.DirectoryEdit1AcceptDirectory(Sender: TObject; var Value: string);
begin
  chdir(appdir);
end;

procedure Tf_catgen.binarycatChange(Sender: TObject);
begin
  RadioGroup4.Visible := binarycat.ItemIndex = 0;
  GroupBox6.Visible := binarycat.ItemIndex = 0;
  CheckBox6.Visible := binarycat.ItemIndex = 0;
  edit6.Visible := binarycat.ItemIndex = 1;
  label23.Visible := binarycat.ItemIndex = 1;
end;

procedure Tf_catgen.FormShow(Sender: TObject);
begin
  pagecontrol1.PageIndex := pageFiles;
  nextbt.Enabled := True;
  prevbt.Enabled := False;
  exitbt.Visible := True;
  endbt.Visible := False;
  endbt.Enabled := False;
end;

procedure Tf_catgen.PageControl1Change(Sender: TObject);
begin
  Panel1.Visible := PageControl1.PageIndex <= pageBuild;
end;

procedure Tf_catgen.FormDestroy(Sender: TObject);
begin
  Fcatgenadv.Free;
  Fprogress.Free;
end;

procedure Tf_catgen.Button3Click(Sender: TObject);
begin
  panel1.Enabled := False;
  pagecontrol1.PageIndex := pageTypeObject;
end;

procedure Tf_catgen.Button4Click(Sender: TObject);
begin
  panel1.Enabled := True;
  pagecontrol1.PageIndex := pageDefault;
end;

procedure Tf_catgen.Button6Click(Sender: TObject);
begin
  panel1.Enabled := False;
  pagecontrol1.PageIndex := pageUnits;
end;

procedure Tf_catgen.CheckBox2Click(Sender: TObject);
begin
  if checkbox2.Checked then
    altname[listindex + 1 - l_fixe] := 1
  else
    altname[listindex + 1 - l_fixe] := 0;
end;

procedure Tf_catgen.CheckBox9Click(Sender: TObject);
begin
  if checkbox9.Checked then
    altprefix[listindex + 1 - l_fixe] := 1
  else
    altprefix[listindex + 1 - l_fixe] := 0;
end;

procedure Tf_catgen.Button7Click(Sender: TObject);
var
  i: integer;
  x: double;
begin
  if (pos('(', CheckListBox1.items[listindex]) = 0) and
    (pos('Numeric', CheckListBox1.items[listindex]) = 0) then
    exit;
  val(memo1.SelText, x, i);
  if i <> 0 then
    exit;
  Fcatgenadv.A := calc[listindex, 1];
  Fcatgenadv.B := calc[listindex, 2];
  Fcatgenadv.X := x;
  Fcatgenadv.ShowModal;
  if Fcatgenadv.ModalResult = mrOk then
  begin
    calc[listindex, 1] := Fcatgenadv.A;
    calc[listindex, 2] := Fcatgenadv.B;
  end;
end;

procedure Tf_catgen.Button9Click(Sender: TObject);
begin
  panel1.Enabled := False;
  pagecontrol1.PageIndex := pageLine;
end;

procedure Tf_catgen.Shape1MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: integer);
begin
  with Sender as Tshape do
  begin
    ColorDialog1.Color := Brush.color;
    if colordialog1.Execute then
      Brush.color := colordialog1.Color;
  end;
end;

procedure Tf_catgen.Button11Click(Sender: TObject);
begin
  panel1.Enabled := False;
  pagecontrol1.PageIndex := pageColor;
end;

procedure Tf_catgen.Button12Click(Sender: TObject);
begin
  ShowHelp;
end;

procedure Tf_catgen.ProgressAbort(Sender: TObject);
begin
  abort := True;
end;

procedure Tf_catgen.BuildIXrec;
type
  Tixrec = packed record
    n: smallint;
    k: integer;
    key: array [0..512] of char;
  end;
var
  rec: gcatrec;
  ok: boolean;
  i, j, k, kl, wr, ak: integer;
  n: smallint;
  key, fn: string;
  ixrec: Tixrec;
  ixrecf: file;
  Sorter: TFixRecSort;

  procedure addindex;
  begin
    ixrec.n := n;
    ixrec.k := k;
    ixrec.key := key + fillstring;
    blockwrite(ixrecf, ixrec, 6 + kl, wr);
  end;

begin
  kl := ixlen;
  fn := slash(destdir) + lowercase(trim(catheader.ShortName)) + '.ixr';
  AssignFile(ixrecf, fn);
  rewrite(ixrecf, 1);
  CleanCache;
  SetGCatpath(destdir, lowercase(trim(catheader.ShortName)));
  ReadGCatHeader;
  Fprogress.progressbar2.max := catheader.FileNum;
  Fprogress.progressbar2.position := 0;
  Fprogress.label1.Caption := rsCreateASearc;
  Fprogress.label2.Caption := '';
  application.ProcessMessages;
  for i := 1 to catheader.FileNum do
  begin
    OpenGCatfile(destdir + ffn[i], ok);
    k := 0;
    n := i;
    Fprogress.progressbar2.position := 0;
    application.ProcessMessages;
    repeat
      ReadGCat(rec, ok, False);
      if ok then
      begin
        // main index
        if usealt[0].i > 0 then
        begin
          case radiogroup1.ItemIndex of
            0: key := rec.star.id;
            1: key := rec.variable.id;
            2: key := rec.double.id;
            3: key := rec.neb.id;
            4: key := rec.outlines.id;
            else
              key := '';
          end;
          key := uppercase(StringReplace(key, ' ', '', [rfReplaceAll]));
          if key <> '' then
          begin
            if CheckBox8.Checked then
              key := usealt[0].l + key;
            addindex;
          end;
        end;
        // alternate indexes
        if indexaltname then
        begin
          for j := 1 to nbalt do
          begin
            if usealt[j].i > 0 then
            begin
              ak := usealt[j].i - basealt + 1;
              key := uppercase(StringReplace(rec.str[ak], ' ', '', [rfReplaceAll]));
              if key > '' then
              begin
                if catheader.useprefix >= 1 then
                  key := usealt[j].l + key;
                addindex;
              end;
            end;
          end;
        end;
        Inc(k);
      end;
    until not ok;
    CloseGCat;
  end;
  closefile(ixrecf);
  Fprogress.progressbar2.max := 2;
  Fprogress.progressbar2.position := 1;
  Fprogress.label1.Caption := rsSortingTheIn;
  Fprogress.label2.Caption := '';
  application.ProcessMessages;
  Sorter := TFixRecSort.Create(kl + 6);
  Sorter.Stable := True;
  Sorter.Start(fn, destdir + 'sort.out', @CompareIXrec);
  Fprogress.progressbar2.position := 2;
  application.ProcessMessages;
  Sorter.Free;
  DeleteFile(fn);
  RenameFile(destdir + 'sort.out', fn);
end;

{  Sort testing
procedure Tf_catgen.Button13Click(Sender: TObject);
var i:integer;
begin
abort:=false;
chdir(appdir);
for i:=1 to 19 do neblst[i]:=trim(stringgrid1.cells[1,i])+',';
for i:=1 to 3  do nebunit[i]:=trim(stringgrid2.cells[1,i])+',';
for i:=1 to 3  do linelst[i]:=trim(stringgrid3.cells[1,i])+',';
for i:=1 to 10  do colorlst[i]:=trim(stringgrid4.cells[0,i])+',';
destdir:=slash(directoryedit1.Text);
ixfn:=lowercase(trim(edit4.text))+'.idx';
BuildHeader;
SortIXfile;
end;  }

end.
