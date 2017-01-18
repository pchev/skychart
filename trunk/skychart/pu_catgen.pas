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

uses u_help, u_translation, u_constant, u_util, pu_progressbar, pu_catgenadv, GSCconst, skylibcat, gcatunit,
  SysUtils, Classes, Graphics, Controls, Forms, Dialogs, UScaleDPI,
  StdCtrls, ExtCtrls, ComCtrls, CheckLst, EnhEdits,
  Buttons, Math, Inifiles, Grids, mwFixedRecSort, mwCompFrom,
  LResources, EditBtn, LazHelpHTML;

const
l_sup =10;

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
    procedure DirectoryEdit1AcceptDirectory(Sender: TObject; var Value: String);
    procedure FormCreate(Sender: TObject);
    procedure nextbtClick(Sender: TObject);
    procedure prevbtClick(Sender: TObject);
    procedure CheckListBox1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure RadioGroup1Click(Sender: TObject);
    procedure Edit1Change(Sender: TObject);
    procedure Edit2Change(Sender: TObject);
    procedure CheckListBox1KeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure EndbtClick(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure ExitbtClick(Sender: TObject);
    procedure Memo1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
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
      Shift: TShiftState; X, Y: Integer);
    procedure Button11Click(Sender: TObject);
    procedure Button12Click(Sender: TObject);
  private
    Fcatgenadv: Tf_catgenadv;
    Fprogress: Tf_progress;
    textpos : array [0..40] of array[1..2] of integer;
    calc : array[0..40,1..2] of double;
    Lra,Lde,ListIndex,nebulaesizescale,l_fixe,nbalt,basealt : integer;
    lockchange: boolean;
    catheader : TFileHeader;
    catinfo : TCatHdrInfo;
    datarec : array [0..4096] of byte;
    ff : array [1..9537] of file;
    ffn : array [1..9537] of string;
    destdir : string;
    freject : textfile;
    rejectopen : boolean;
    fillstring,inl : string;
    flabel : array [1..35] of string;
    Ft : textfile;
    catrec,catsize : integer;
    colorlst : array[1..10] of string;
    Linelst : array[1..4] of string;
    neblst  : array[1..19] of string;
    nebunit : array[1..3]  of string;
    altname : array[1..l_sup] of byte;
    altprefix : array[1..l_sup] of byte;
    createindex, indexaltname, abort : boolean;
    usealt : array[0..10] of record i:integer; l : string; end;
    {$ifdef build_old_index}
    indexrec : array [0..1024] of byte;
    ixf : file;
    ixfn : string;
    {$endif}
    Procedure SetFieldlist(field : array of string; n : integer);
    Procedure BuildFieldList;
    procedure OpenCatalog(filename : string);
    Procedure CloseCatalog;
    Procedure ReadCatalog(out line : string);
    Function GetCatalogSize : Integer;
    Function GetCatalogPos : Integer;
    Function CatalogEOF : Boolean;
    Procedure GetSampleData(filename : string);
    Function CheckPageValid(i : integer): boolean;
    Procedure SetListIndex;
    Procedure InitPage(i : integer);
    Procedure BuildHeader;
    Procedure BuildTxtHeader;
    Function GetFloat(p : integer; default :double) : double ;
    Function GetInt(p : integer) : Integer;
    Function GetString(p : integer) : string;
    Function GetNebType(p : integer) : byte;
    Function GetNebUnit(p : integer) : Smallint;
    Function GetLineType(p : integer) : Smallint;
    Function Getcolor(p : integer) : Tcolor;
    Procedure PutRecDouble(x : double; p: integer) ;
    Procedure PutRecSingle(x : single; p: integer) ;
    Procedure PutRecInt(x : integer; p: integer) ;
    Procedure PutRecCard(x : cardinal; p: integer) ;
    Procedure PutRecSmallInt(x : integer; p: integer) ;
    Procedure PutRecByte(x : byte; p: integer) ;
    Procedure PutRecString(x : string; p: integer) ;
    Procedure FindRegion30(ar,de : double; var lg : integer);
    Procedure FindRegion15(ar,de : double; var lg : integer);
    Procedure FindRegion7(ar,de : double; var hemis : char ; var zone,S : integer);
    Procedure FindRegion(ar,de : double; var hemis : char ; var zone,S : integer);
    Procedure Createfiles;
    Procedure CreateTxtfiles;
    Procedure Closefiles;
    Procedure WriteRec(num: integer);
    Procedure RejectRec(lin : string);
    Procedure BuildFiles;
    function  filegetsize(fn:string):integer;
    Procedure Sortfiles;
    Procedure BuildBinCat;
    Procedure BuildTxtCat;
    procedure ProgressAbort(Sender: TObject);
    procedure BuildIXrec;
    {$ifdef build_old_index}
    Procedure PutIxSingle(x : single; p: integer) ;
    Procedure PutIxkey(x : string) ;
    Procedure WriteIx;
    Procedure SortIXfile;
    {$endif}
  public
    procedure SetLang;

  end;

Var
  f_catgen: Tf_catgen;
  keypos,ixlen : integer; // not thread safe but cannot define the sort exit otherwise

implementation
{$R *.lfm}

const
  zone_lst : array [0..23] of integer = (   593 ,  1177 ,  1728 , 2258  ,  2780 ,  3245 ,  3651 , 4013  , 4293  ,  4491 ,  4614 , 4662  ,  5259 ,  5837 ,  6411 ,  6988 ,  7522 ,  8021 ,  8463 ,  8839 ,  9133 ,  9345 ,  9489 ,  9537 );
  zone_lst7: array [0..23] of integer = (    48 ,    95 ,   140 ,  183  ,   223 ,   259 ,   291 ,  318  ,  339  ,   354 ,   363 ,  366  ,   414 ,   461 ,   506 ,   549 ,   589 ,   625 ,   657 ,   684 ,   705 ,   720 ,   729 ,   732 );
  zone_nam : array [0..23] of string  = ('n0000','n0730','n1500','n2230','n3000','n3730','n4500','n5230','n6000','n6730','n7500','n8230','s0000','s0730','s1500','s2230','s3000','s3730','s4500','s5230','s6000','s6730','s7500','s8230');
  rahms   : array[0..2] of string = ('[RA (hours)]','RA (minutes)','RA (seconds)');
  rah     : array[0..0] of string = ('[RA decimal (hours)]');
  radms   : array[0..2] of string = ('[RA (degrees)]','RA (minutes)','RA (seconds)');
  rad     : array[0..0] of string = ('[RA decimal (degrees)]');
  dedms   : array[0..3] of string = ('DEC sign','[DEC (degrees)]','DEC (arcmin)','DEC (arcsec)');
  ded     : array[0..0] of string = ('[DEC decimal (degrees)]');
  despd   : array[0..0] of string = ('[SPD decimal (degrees)]');
  etoiles : array[0..10] of string = ('Catalog ID','[Magnitude (mag)]','B-V (mag)','Magnitude B (mag)','Magnitude R (mag)','Spectral class','Proper motion RA (arcsec/yr)','Proper motion DEC (arcsec/yr)','Position Epoch (year)','Parallax (arcsec)','Comments');
  variable: array[0..9] of string = ('Catalog ID','Magnitude max (mag)','Magnitude min (mag)','Period (days)','Variable Type','Maxima Epoch (JD)','Rise Time (%period)','Spectral class','Magnitude code','Comments');
  doubles : array[0..9] of string = ('Catalog ID','[Magnitude component 1 (mag)]','Magnitude component 2 (mag)','[Separation (arcsec)]','Position angle (degrees)','Epoch (year)','Component name','Spectral class component 1','Spectral class component 2','Comments');
  nebuleuse: array[0..11] of string =('Catalog ID','Nebula type','Magnitude (mag)','Surface brigtness (mag/arcmin2)','Largest dimension (as defined)','Smallest dimension (as defined)','Dimension Unit','Position angle (degrees)','Radial velocity (km/s)','Morphological class','Comments','Color');
  outlines: array[0..5] of string =('Catalog ID (only for Start operation)','[Line operation]','Line width (only for Start operation)','Line color (only for Start operation)','Drawing Type (only for Start operation)','Comments');
  sup_string: array[0..9] of string = ('String 1','String 2','String 3','String 4','String 5','String 6','String 7','String 8','String 9','String 10');
  sup_num : array[0..9] of string = ('Numeric 1','Numeric 2','Numeric 3','Numeric 4','Numeric 5','Numeric 6','Numeric 7','Numeric 8','Numeric 9','Numeric 10');
  l_rahms = 3; l_rah = 1; l_radms = 3; l_rad = 1;
  l_dedms = 4; l_ded = 1; l_despd = 1;
  l_base = 2; l_etoiles = 11; l_variable = 10; l_double = 10; l_nebuleuse = 12; l_outlines = 6;
  lab_base : array[1..2] of string = ('RA','DEC');
  lab_etoiles : array[1..l_etoiles] of string = ('Id','mV','b-v','mB','mR','sp','pmRA','pmDE','date','px','desc');
  lab_var     : array[1..l_variable] of string = ('Id','mMax','mMin','P','T','Mepoch','rise','sp','band','desc');
  lab_double  : array[1..l_double] of string = ('Id','m1','m2','sep','pa','date','Comp','sp','sp','desc');
  lab_neb     : array[1..l_nebuleuse] of string = ('Id','NebTyp','m','sbr','D','D','Unit','pa','rv','class','desc','color');
  lab_outlines : array[1..l_outlines] of string = ('Id','LineOp','LineWidth','LineColor','Drawing','desc');
  lab_string  : array[1..l_sup] of string = ('Str1','Str2','Str3','Str4','Str5','Str6','Str7','Str8','Str9','Str10');
  lab_num     : array[1..l_sup] of string = ('Num1','Num2','Num3','Num4','Num5','Num6','Num7','Num8','Num9','Num10');
  nebtype : array[1..19] of integer =(1,12,2,3,4,5,13,6,11,7,8,9,10,255,0,14,15,16,17);
  linetype : array[1..5] of byte =(0,1,2,3,4);
  nebunits: array[1..3]  of integer =(1,60,3600);
  pageFiles=0;
  pageDefault=1;
  pageDetails=2;
  pageBuild=3;
  pageTypeObject=4;
  pageUnits=5;
  pageLine=6;
  pageColor=7;

Procedure Tf_catgen.SetFieldlist(field : array of string; n : integer);
var i : integer;
begin
for i:=0 to n-1 do begin
   CheckListBox1.Items.Add(field[i]);
end;
end;

Procedure Tf_catgen.BuildFieldList;
var i,nextpos : integer;
begin
for i:=1 to l_base do flabel[i]:=lab_base[i];
CheckListBox1.Clear;
case RadioGroup2.ItemIndex of
     0 : setfieldlist(rahms,l_rahms);
     1 : setfieldlist(rah,l_rah);
     2 : setfieldlist(radms,l_radms);
     3 : setfieldlist(rad,l_rad);
end;
case RadioGroup3.ItemIndex of
     0 : setfieldlist(dedms,l_dedms);
     1 : setfieldlist(ded,l_ded);
     2 : setfieldlist(despd,l_despd);
end;
nextpos:=l_base;
case RadioGroup1.ItemIndex of
     0 : begin
         setfieldlist(etoiles,l_etoiles);
         for i:=1 to l_etoiles do flabel[i+nextpos]:=lab_etoiles[i];
         nextpos:=l_etoiles+nextpos;
         end;
     1 : begin
         setfieldlist(variable,l_variable);
         for i:=1 to l_variable do flabel[i+nextpos]:=lab_var[i];
         nextpos:=l_variable+nextpos;
         end;
     2 : begin
         setfieldlist(doubles,l_double);
         for i:=1 to l_double do flabel[i+nextpos]:=lab_double[i];
         nextpos:=l_double+nextpos;
         end;
     3 : begin
         setfieldlist(nebuleuse,l_nebuleuse);
         for i:=1 to l_nebuleuse do flabel[i+nextpos]:=lab_neb[i];
         nextpos:=l_nebuleuse+nextpos;
         end;
     4 : begin
         setfieldlist(outlines,l_outlines);
         for i:=1 to l_outlines do flabel[i+nextpos]:=lab_outlines[i];
         nextpos:=l_outlines+nextpos;
         end;
end;
l_fixe:=CheckListBox1.Items.count;
setfieldlist(sup_string,l_sup);
for i:=1 to l_sup do flabel[i+nextpos]:=lab_string[i];
setfieldlist(sup_num,l_sup);
nextpos:=nextpos+l_sup;
for i:=1 to l_sup do flabel[i+nextpos]:=lab_num[i];
end;

procedure Tf_catgen.SetLang;
begin
Caption:=rsPrepareACata+' 3.0';
Label6.caption:=rsSelectTheTyp;
Label8.caption:=rsInputCatalog;
Label10.caption:=rsCatalogShort;
Label13.caption:=rsCatalogLongN;
Label22.caption:=rsForALargeCat;
RadioGroup1.caption:=rsCatalogType;
RadioGroup1.Items[0]:=rsStars;
RadioGroup1.Items[1]:=rsVariableStar;
RadioGroup1.Items[2]:=rsDoubleStar;
RadioGroup1.Items[3]:=rsNebulaeOrOth;
RadioGroup1.Items[4]:=rsNebulaeOutli;
binarycat.caption:=rsOutputCatalo;
binarycat.Items[0]:=rsBinaryIndexe;
binarycat.Items[1]:=rsTextFileCata;
Label2.caption:=rsGeneralCatal;
GroupBox5.caption:=rsDefaultNebul;
Label11.caption:=rsDimensionAnd;
Label12.caption:=rsObjectType;
Label15.caption:=rsRecognizeUni;
Label16.caption:=rsUsefulToRepr;
ComboBox1.items[0]:=rsDegree;
ComboBox1.items[1]:=rsMinute;
ComboBox1.items[2]:=rsSecond;
CheckBox1.caption:=rsLogarithmicS;
ComboBox3.items[0]:=rsGalaxy;
ComboBox3.items[1]:=rsGalaxyCluste;
ComboBox3.items[2]:=rsOpenCluster;
ComboBox3.items[3]:=rsGlobularClus;
ComboBox3.items[4]:=rsPlanetaryNeb;
ComboBox3.items[5]:=rsBrightNebula;
ComboBox3.items[6]:=rsDarkNebula;
ComboBox3.items[7]:=rsClusterAndNe;
ComboBox3.items[8]:=rsKnot;
ComboBox3.items[9]:=rsStar;
ComboBox3.items[10]:=rsDoubleStar;
ComboBox3.items[11]:=rsTripleStar;
ComboBox3.items[12]:=rsAsterism;
ComboBox3.items[13]:=rsNonExistant;
ComboBox3.items[14]:=rsUnknow;
ComboBox3.items[15]:=rsCircle;
ComboBox3.items[16]:=rsSquare;
ComboBox3.items[17]:=rsLosange;
Button3.caption:=rsEditObjectTy;
Button6.caption:=rsEditUnits;
GroupBox7.caption:=rsDefaultOutli;
Label18.caption:=rsLineWidth;
Label19.caption:=rsColor;
Button9.caption:=rsEditLineOper;
Button11.caption:=rsEditColor;
RadioGroup6.caption:=rsDrawingType;
CheckBox7.caption:=rsClosedContou;
RadioGroup2.caption:=rsRAOptions;
RadioGroup2.Items[0]:=rsHoursMinutes;
RadioGroup2.Items[1]:=rsDecimalHours;
RadioGroup2.Items[2]:=rsDegreesMinut;
RadioGroup2.Items[3]:=rsDecimalDegre;
RadioGroup3.caption:=rsDECOptions;
RadioGroup3.Items[0]:=rsDegreesMinut;
RadioGroup3.Items[1]:=rsDecimalDegre;
RadioGroup3.Items[2]:=rsDecimalSouth;
RadioGroup6.Items[0]:=rsLine1;
RadioGroup6.Items[1]:=rsSpline;
RadioGroup6.Items[2]:=rsSurface;
GroupBox1.caption:=rsCoordinatesE;
GroupBox4.caption:=rsMaximumMagni;
GroupBox2.caption:=rsPositionEpoc;
Label4.caption:=rsFirstChar;
Label5.caption:=rsLength;
Label7.caption:=rsSelectTheFie;
Label3.caption:=rsLabel2;
CheckBox2.caption:=rsUseThisField;
Button7.caption:=rsAdvanced;
Label1.caption:=rsOutputCatalo2;
RadioGroup4.caption:=rsNumberOfFile;
RadioGroup4.Items[0]:=rs50Recommende;
RadioGroup4.Items[1]:=rs184Recommend;
RadioGroup4.Items[2]:=rs732Recommend;
RadioGroup4.Items[3]:=rs9537LargerDa;
GroupBox3.caption:=rsOutputDirect;
CheckBox6.caption:=rsAppendToAnEx;
GroupBox6.caption:=rsSearchIndex;
CheckBox3.caption:=rsCreateASearc;
CheckBox4.caption:=rsAddTheAltern;
CheckBox8.caption:=rsPrefixNameWi;
Label9.caption:=rsIndicateTheS;
Button4.caption:=rsReturn;
Label14.caption:=rsIndicateHowT;
Button5.caption:=rsReturn;
Label17.caption:=rsIndicateTheS2;
Button8.caption:=rsReturn;
Label20.caption:=rsIndicateTheS3;
Label21.caption:=rsClickToChang;
Button10.caption:=rsReturn;
Exitbt.caption:=rsClose;
prevbt.caption:=rsPrev;
nextbt.caption:=rsNext;
Endbt.caption:=rsBuildCatalog;
Button2.caption:=rsLoadProject;
Button1.caption:=rsSaveProject;
Button12.caption:=rsHelp;
with stringgrid1 do begin
cells[0, 0]:=rsObjectType;
cells[1, 0]:=rsCatalogStrin;
cells[0, 1]:=rsGalaxy;
cells[0, 2]:=rsGalaxyCluste;
cells[0, 3]:=rsOpenCluster;
cells[0, 4]:=rsGlobularClus;
cells[0, 5]:=rsPlanetaryNeb;
cells[0, 6]:=rsBrightNebula;
cells[0, 7]:=rsDarkNebula;
cells[0, 8]:=rsClusterAndNe;
cells[0, 9]:=rsKnot;
cells[0, 10]:=rsStar;
cells[0, 11]:=rsDoubleStar;
cells[0, 12]:=rsTripleStar;
cells[0, 13]:=rsAsterism;
cells[0, 14]:=rsNonExistant;
cells[0, 15]:=rsUnknow;
cells[0, 16]:=rsCircle;
cells[0, 17]:=rsSquare;
cells[0, 18]:=rsLosange;
cells[0, 19]:=rsDuplicate;
end;
with stringgrid2 do begin
cells[0, 0]:=rsObjectSizeUn;
cells[1, 0]:=rsCatalogStrin;
cells[0, 1]:=rsDegree;
cells[0, 2]:=rsMinute;
cells[0, 3]:=rsSecond;
end;
with stringgrid3 do begin
cells[0, 0]:=rsLineOperatio;
cells[1, 0]:=rsCatalogStrin;
cells[0, 1]:=rsStartOfObjec;
cells[0, 2]:=rsEndOfObject;
cells[0, 3]:=rsDrawLine;
end;
with stringgrid4 do begin
cells[0, 0]:=rsCatalogStrin;
end;
SetHelp(self,hlpCatgen);
end;

procedure Tf_catgen.FormCreate(Sender: TObject);
var i : integer;
begin
ScaleDPI(Self);
Fcatgenadv:=Tf_catgenadv.Create(self);
Fprogress:=Tf_progress.Create(self);
rejectopen := false;
lockchange:=false;
for i:=1 to l_sup do altname[i]:=0;
for i:=1 to l_sup do altprefix[i]:=0;
pagecontrol1.PageIndex:=pageFiles;
nextbt.enabled:=true;
prevbt.enabled:=false;
BuildFieldList;
combobox1.ItemIndex:=1;
nebulaesizescale:=60;
combobox3.ItemIndex:=14;
for i:=0 to 40 do begin
   textpos[i,1]:=0;
   textpos[i,2]:=0;
   calc[i,1]:=1;
   calc[i,2]:=0;
end;
with stringgrid1 do begin
rowcount:=20;
cells[1,1]:='Gx,GALXY,QUASR';
cells[1,2]:='GALCL';
cells[1,3]:='OC,OPNCL,LMCOC,SMCOC';
cells[1,4]:='Gb,GLOCL,GX+GC,LMCGC,SMCGC';
cells[1,5]:='Pl,PLNNB';
cells[1,6]:='Nb,BRTNB,GX+DN,LMCDN,SMCDN,SNREM';
cells[1,7]:='Drk,DRKNB';
cells[1,8]:='C+N,CL+NB,G+C+N,LMCCN,SMCCN';
cells[1,9]:='Kt';
cells[1,10]:='*,1STAR';
cells[1,11]:='D*,2STAR';
cells[1,12]:='***,3STAR';
cells[1,13]:='Ast,ASTER,4STAR,5STAR,6STAR,7STAR,8STAR';
cells[1,14]:='-,PD,NONEX';
cells[1,15]:=' ,?';
cells[1,16]:='Circle';
cells[1,17]:='Rectangle';
cells[1,18]:='Lozenge';
cells[1,19]:='Dup';
end;
with stringgrid2 do begin
cells[1,1]:='d,°';
cells[1,2]:='m,''';
cells[1,3]:='s,"';
end;
with stringgrid3 do begin
cells[1,1]:='start,0';
cells[1,2]:='end,1';
cells[1,3]:='vertex, ,2';
end;
with stringgrid4 do begin
rowcount:=11;
cells[0,1]:='White,W,1';
cells[0,2]:='LightGray,LG,2';
cells[0,3]:='Gray,G,3';
cells[0,4]:='Black,D,4';
cells[0,5]:='Red,R,5';
cells[0,6]:='Green,V,6';
cells[0,7]:='Yellow,Y,7';
cells[0,8]:='Blue,B,8';
cells[0,9]:='Magenta,M,9';
cells[0,10]:='Turquoise,T,10';
end;
SetLang;
{$ifdef mswindows}
SaveDialog1.Options:=SaveDialog1.Options-[ofNoReadOnlyReturn]; { TODO : check readonly test on Windows }
{$endif}
end;


Procedure Tf_catgen.OpenCatalog(filename : string);
begin
    catrec:=0;
    Filemode:=0;
    Assignfile(Ft,filename);
    reset(Ft);
end;

Procedure Tf_catgen.CloseCatalog;
begin
 Closefile(Ft);
end;

Procedure Tf_catgen.ReadCatalog(out line : string);
begin
 Readln(Ft,line);
 inc(catrec)
end;

Function Tf_catgen.GetCatalogSize : Integer;
begin
catsize:=0;
reset(Ft);
repeat
 readln(Ft);
 inc(catsize);
until eof(Ft);
reset(Ft);
result:=catsize;
// result:=filesize(Ft);
end;

Function Tf_catgen.GetCatalogPos : Integer;
begin
result:=catrec;
//result:=filepos(Ft);
end;

Function Tf_catgen.CatalogEOF : Boolean;
begin
result:=Eof(Ft);
end;

Procedure Tf_catgen.GetSampleData(filename : string);
var buf,scal : string;
    i,n : integer;
begin
OpenCatalog(filename);
try
  ReadCatalog(buf);
  memo1.Lines.clear;
  memo1.Lines.add(buf);
  n:= 1 + (length(buf)  div 10);
  scal:='';
  for i:=1 to n do scal:=scal+'1234567890';
  memo1.Lines.add(scal);
  scal:='';
  for i:=1 to n do scal:=scal+copy('         ',1,9-trunc(log10(i)))+inttostr(i);
  memo1.Lines.add(scal);
  memo1.SelStart:=0;
  memo1.SelLength:=0;
finally
  CloseCatalog;
end;
end;

Function Tf_catgen.CheckPageValid(i : integer): boolean;
var n : integer;
begin
case i of
pageFiles : begin
       if (ListBox1.Items.Count>0)and(fileexists(ListBox1.Items[0])) then result:=true
          else begin
               result:=false;
               ShowMessage(rsFileNotFound);
       end;
       if result and (trim(edit4.text)='') then begin
               result:=false;
               ShowMessage(rsPleaseIndica);
               edit4.SetFocus;
       end;
       if result and (trim(edit5.text)='') then begin
               result:=false;
               ShowMessage(rsPleaseIndica2);
               edit5.SetFocus;
       end;
    end;
pageDefault : begin
    if (FloatEdit1.Value>2100)or(FloatEdit1.Value<1800) then begin
       if mrOK=MessageDlg(Format(rsIsCoordinate, [FloatEdit1.text]),
         mtConfirmation, mbOkCancel, 0) then result:=true
          else result:=false;
    end else result:=true;
    end;
pageDetails : begin
    result:=true;
    for n:=0 to CheckListBox1.Items.Count-1 do begin
       if (not CheckListBox1.Checked[n])and(copy(CheckListBox1.items[n],1,1)='[') then result:=false;
    end;
    if result=false then Showmessage(rsRequiredFiel);
    end;
else result:=true;
end;
end;

Procedure Tf_catgen.SetListIndex;
var i : integer;
    buf:string;
begin
lockchange:=true;
case RadioGroup2.ItemIndex of
     0 : lra:=l_rahms;
     1 : lra:=l_rah;
     2 : lra:=l_radms;
     3 : lra:=l_rad;
end;
case RadioGroup3.ItemIndex of
     0 : lde:=l_dedms;
     1 : lde:=l_ded;
     2 : lde:=l_despd;
end;
  i:=listindex+1;
  if (i<=lra) then edit3.text:=flabel[1]
  else if (i<=(lra+lde)) then edit3.text:=flabel[2]
  else edit3.text:=flabel[i-lra-lde+2];
  buf:=inttostr(textpos[ListIndex,1]);
  edit1.text:=buf;
  buf:=inttostr(textpos[ListIndex,2]);
  edit2.text:=buf;
  if (textpos[ListIndex,1]>0)and(textpos[ListIndex,2]>0) then begin
    memo1.SelStart:=textpos[ListIndex,1]-1;
    memo1.SelLength:=minintvalue([textpos[ListIndex,2],length(memo1.Lines.Strings[0])-memo1.SelStart]);
  end else begin
    memo1.SelStart:=0;
    memo1.SelLength:=0;
  end;;
  if (i>l_fixe)and(i<=l_fixe+l_sup) then begin
     checkbox2.visible:=true;
     checkbox2.checked:=AltName[i-l_fixe]=1;
     checkbox9.visible:=true;
     checkbox9.checked:=altprefix[i-l_fixe]=1;
  end else begin
     checkbox2.visible:=false;
     checkbox9.visible:=false;
  end;
lockchange:=false;
end;

procedure Tf_catgen.Edit3Change(Sender: TObject);
var i,j : integer;
begin
if lockchange then exit;
  i:=listindex+1;
  if i<=lra then j:=1
  else if i<=(lra+lde) then j:=2
  else j:=i-lra-lde+2;
flabel[j]:=edit3.text;
end;

Procedure Tf_catgen.InitPage(i : integer);
begin
case i of
pageDefault : begin
     GroupBox5.Visible:=(RadioGroup1.ItemIndex=3);
     GroupBox7.Visible:=(RadioGroup1.ItemIndex=4);
    end;
pageDetails : begin
     getsampledata(ListBox1.Items[0]);
     SetListIndex;
    end;
pageBuild : begin
     exitbt.Visible:=false;
     endbt.Visible:=true;
     endbt.enabled:=true;
     if radiogroup1.ItemIndex=4 then begin
       radiogroup4.Visible:=false;
       groupbox6.Visible:=false;
     end;
    end;
end;
end;

procedure Tf_catgen.nextbtClick(Sender: TObject);
var i : integer;
begin
chdir(appdir);
if not Checkpagevalid(pagecontrol1.PageIndex) then exit;
i:=pagecontrol1.PageIndex+1;
endbt.enabled:=false;
if i>=pageBuild then begin
   i:=pageBuild;
   nextbt.enabled:=false;
   endbt.visible:=true;
   endbt.enabled:=true;
end;
pagecontrol1.PageIndex:=i;
prevbt.enabled:=true;
InitPage(i);
end;

procedure Tf_catgen.prevbtClick(Sender: TObject);
var i : integer;
begin
chdir(appdir);
i:=pagecontrol1.PageIndex-1;
endbt.enabled:=false;
if i<=0 then begin
   i:=0;
   prevbt.enabled:=false;
end;
pagecontrol1.PageIndex:=i;
nextbt.enabled:=true;
InitPage(i);
end;

procedure Tf_catgen.CheckListBox1MouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  APoint: TPoint;
begin
if Button = mbLeft then
begin
  APoint.X := X;
  APoint.Y := Y;
  ListIndex := CheckListBox1.ItemAtPos(APoint, True);
  if ListIndex<0 then exit;
  SetListIndex;
end;
end;

procedure Tf_catgen.RadioGroup1Click(Sender: TObject);
begin
BuildFieldList;
end;

procedure Tf_catgen.Edit1Change(Sender: TObject);
var i,n : integer;
begin
if lockchange then exit;
val(edit1.text,i,n);
if n=0 then begin
   textpos[ListIndex,1]:=i;
   SetListIndex;
end;
end;

procedure Tf_catgen.Edit2Change(Sender: TObject);
var i,n : integer;
begin
if lockchange then exit;
val(edit2.text,i,n);
if n=0 then begin
   textpos[ListIndex,2]:=i;
   SetListIndex;
end;
end;

procedure Tf_catgen.CheckListBox1KeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
listindex:=checklistbox1.ItemIndex;
  if ListIndex<0 then exit;
  SetListIndex;
end;


Procedure Tf_catgen.BuildHeader;
var i,j,n : integer;
    nextpos,curpos : integer;
    buf : shortstring;
    CatPrefix: boolean;
begin
for i:=1 to 10 do catheader.Spare1[i]:=0;
for i:=1 to 15 do catheader.Spare2[i]:=0;
for i:=1 to 15 do catheader.Spare3[i]:=0;
for i:=1 to 40 do catheader.fpos[i]:=0;
for i:=1 to 40 do catheader.flen[i]:=0;
n:=l_base;
case radiogroup1.itemindex of
 0 : begin catheader.version:='CDCSTAR1'; n:=n+l_etoiles; end;
 1 : begin catheader.version:='CDCVAR 1'; n:=n+l_variable; end;
 2 : begin catheader.version:='CDCDBL 1'; n:=n+l_double; end;
 3 : begin catheader.version:='CDCNEB 1'; n:=n+l_nebuleuse; end;
 4 : begin catheader.version:='CDCLINE1'; n:=n+l_outlines; end;
end;
for i:=1 to n do begin
    buf:=flabel[i]+'           ';
    for j:=0 to 10 do catheader.flabel[i,j]:=buf[j+1];
end;
for i:=n+1 to 14 do begin
    buf:='           ';
    for j:=0 to 10 do catheader.flabel[i,j]:=buf[j+1];
end;
for i:=15 to 35 do begin
    buf:=flabel[i-(15-n)]+'           ';
    for j:=0 to 10 do catheader.flabel[i,j]:=buf[j+1];
end;
if GroupBox6.Visible then begin
 createindex:=checkbox3.checked;
 indexaltname:=checkbox4.checked;
 catheader.useprefix:=0;
 for i:=1 to l_sup do if altprefix[i]=1 then catheader.useprefix:=2;
end else begin
 createindex:=false;
 indexaltname:=false;
 catheader.useprefix:=0;
end;
for i:=1 to l_sup do catheader.AltName[i]:=altname[i];
for i:=1 to l_sup do catheader.AltPrefix[i]:=altprefix[i];
buf:=pchar(edit4.text+'    ');
for i:=1 to 4 do catheader.ShortName[i-1]:=buf[i];
buf:=pchar(edit5.text+StringOfChar(' ',50));
for i:=1 to 50 do catheader.LongName[i-1]:=buf[i];
catheader.hdrl:=sizeof(catheader);
if radiogroup4.visible then
 case radiogroup4.itemindex of
 0 : catheader.filenum:=50;
 1 : catheader.filenum:=184;
 2 : catheader.filenum:=732;
 3 : catheader.filenum:=9537;
 end
 else catheader.filenum:=1;
catheader.Equinox:=floatedit1.value;
catheader.Epoch:=floatedit3.value;
if catheader.version='CDCNEB 1' then begin
   catheader.MagMax:=floatedit2.value;
   catheader.Size:=longedit1.Value;
   catheader.Units:=nebulaesizescale;
   catheader.ObjType:=nebtype[Combobox3.ItemIndex+1];
   if CheckBox1.Checked then catheader.LogSize:=1 else catheader.LogSize:=0;
end else if catheader.version='CDCLINE1' then begin
   catheader.MagMax:=floatedit2.value;
   catheader.Size:=longedit2.Value;
   catheader.Units:=Shape1.Brush.Color;
   if checkbox7.checked then catheader.ObjType:=1
                        else catheader.ObjType:=0;
   catheader.LogSize:=RadioGroup6.ItemIndex;
end else begin
   catheader.MagMax:=floatedit2.value;
   catheader.Size:=0;
   catheader.Units:=0;
   catheader.ObjType:=0;
   catheader.LogSize:=0;
end;
nextpos:=0;
curpos:=1;
n:=1;
//RA [mas]
catheader.fpos[n]:=curpos;  catheader.flen[n]:=sizeof(cardinal);
curpos:=curpos+catheader.flen[n]; inc(n);
//DEC [mas]
catheader.fpos[n]:=curpos;  catheader.flen[n]:=sizeof(cardinal);
curpos:=curpos+catheader.flen[n]; inc(n);
case radiogroup2.itemindex of  // RA
 0 : nextpos:=3;
 1 : nextpos:=1;
 2 : nextpos:=3;
 3 : nextpos:=1;
end;
case radiogroup3.itemindex of  // DEC
 0   : nextpos:=nextpos+4;
 1,2 : nextpos:=nextpos+1;
end;
usealt[0].i:=0;
CatPrefix:=CheckBox8.Checked;
case radiogroup1.itemindex of
//9 ('Catalog ID','[Magnitude V]','B-V','Magnitude B','Magnitude R','Spectral class','Proper motion RA','Proper motion DEC','epoch','Parallax','Comments');
 0 : begin     // Stars
       if CheckListBox1.Checked[nextpos+0] then begin catheader.fpos[n]:=curpos;  catheader.flen[n]:=textpos[nextpos+0,2]; end;// ID
       ixlen:=catheader.flen[n]; if ixlen>0 then begin usealt[0].i:=nextpos; if CatPrefix then usealt[0].l:=trim(edit4.text) else usealt[0].l:=''; ixlen:=ixlen+length(usealt[0].l) end;
       curpos:=curpos+catheader.flen[n]; inc(n);
       if CheckListBox1.Checked[nextpos+1] then begin catheader.fpos[n]:=curpos;  catheader.flen[n]:=sizeof(smallint);  end;// mag V
       keypos:=curpos;
       curpos:=curpos+catheader.flen[n]; inc(n);
       if CheckListBox1.Checked[nextpos+2] then begin catheader.fpos[n]:=curpos;  catheader.flen[n]:=sizeof(smallint); end;// B-V
       curpos:=curpos+catheader.flen[n]; inc(n);
       if CheckListBox1.Checked[nextpos+3] then begin catheader.fpos[n]:=curpos;  catheader.flen[n]:=sizeof(smallint); end;// B
       curpos:=curpos+catheader.flen[n]; inc(n);
       if CheckListBox1.Checked[nextpos+4] then begin catheader.fpos[n]:=curpos;  catheader.flen[n]:=sizeof(smallint); end;// R
       curpos:=curpos+catheader.flen[n]; inc(n);
       if CheckListBox1.Checked[nextpos+5] then begin catheader.fpos[n]:=curpos;  catheader.flen[n]:=textpos[nextpos+5,2]; end;// Sp
       curpos:=curpos+catheader.flen[n]; inc(n);
       if CheckListBox1.Checked[nextpos+6] then begin catheader.fpos[n]:=curpos;  catheader.flen[n]:=sizeof(smallint); end;// pmAR
       curpos:=curpos+catheader.flen[n]; inc(n);
       if CheckListBox1.Checked[nextpos+7] then begin catheader.fpos[n]:=curpos;  catheader.flen[n]:=sizeof(smallint); end;// pmDE
       curpos:=curpos+catheader.flen[n]; inc(n);
       if CheckListBox1.Checked[nextpos+8] then begin catheader.fpos[n]:=curpos;  catheader.flen[n]:=sizeof(single); end;// pos epoch
       curpos:=curpos+catheader.flen[n]; inc(n);
       if CheckListBox1.Checked[nextpos+9] then begin catheader.fpos[n]:=curpos;  catheader.flen[n]:=sizeof(smallint); end;// Px
       curpos:=curpos+catheader.flen[n]; inc(n);
       if CheckListBox1.Checked[nextpos+10] then begin catheader.fpos[n]:=curpos;  catheader.flen[n]:=textpos[nextpos+10,2]; end;// Comment
       curpos:=curpos+catheader.flen[n]; inc(n);
       inc(n);
       inc(n);
       nextpos:=nextpos+11;
     end;
//9 ('Catalog ID','[Magnitude max]','[Magnitude min]','Period','Type','Maxima Epoch','Rise Time','Spectral class','Magnitude code','Comments');
 1 : begin     // variables
       if CheckListBox1.Checked[nextpos+0] then begin catheader.fpos[n]:=curpos;  catheader.flen[n]:=textpos[nextpos+0,2]; end;// ID
       ixlen:=catheader.flen[n]; if ixlen>0 then begin usealt[0].i:=nextpos; if CatPrefix then usealt[0].l:=trim(edit4.text) else usealt[0].l:=''; ixlen:=ixlen+length(usealt[0].l) end;
       curpos:=curpos+catheader.flen[n]; inc(n);
       if CheckListBox1.Checked[nextpos+1] then begin catheader.fpos[n]:=curpos;  catheader.flen[n]:=sizeof(smallint); end;// mag1
       keypos:=curpos;
       curpos:=curpos+catheader.flen[n]; inc(n);
       if CheckListBox1.Checked[nextpos+2] then begin catheader.fpos[n]:=curpos;  catheader.flen[n]:=sizeof(smallint); end;// mag2
       curpos:=curpos+catheader.flen[n]; inc(n);
       if CheckListBox1.Checked[nextpos+3] then begin catheader.fpos[n]:=curpos;  catheader.flen[n]:=sizeof(single); end;// period
       curpos:=curpos+catheader.flen[n]; inc(n);
       if CheckListBox1.Checked[nextpos+4] then begin catheader.fpos[n]:=curpos;  catheader.flen[n]:=textpos[nextpos+4,2]; end;// Type
       curpos:=curpos+catheader.flen[n]; inc(n);
       if CheckListBox1.Checked[nextpos+5] then begin catheader.fpos[n]:=curpos;  catheader.flen[n]:=sizeof(single); end;// epoch
       curpos:=curpos+catheader.flen[n]; inc(n);
       if CheckListBox1.Checked[nextpos+6] then begin catheader.fpos[n]:=curpos;  catheader.flen[n]:=sizeof(smallint); end;// rise
       curpos:=curpos+catheader.flen[n]; inc(n);
       if CheckListBox1.Checked[nextpos+7] then begin catheader.fpos[n]:=curpos;  catheader.flen[n]:=textpos[nextpos+7,2]; end;// Sp
       curpos:=curpos+catheader.flen[n]; inc(n);
       if CheckListBox1.Checked[nextpos+8] then begin catheader.fpos[n]:=curpos;  catheader.flen[n]:=textpos[nextpos+8,2]; end;// mag. code
       curpos:=curpos+catheader.flen[n]; inc(n);
       if CheckListBox1.Checked[nextpos+9] then begin catheader.fpos[n]:=curpos;  catheader.flen[n]:=textpos[nextpos+9,2]; end;// Comment
       curpos:=curpos+catheader.flen[n]; inc(n);
       inc(n);
       inc(n);
       inc(n);
       nextpos:=nextpos+10;
     end;
//9 ('Catalog ID','[Magnitude component 1]','Magnitude component 2','[Separation]','Position angle','Epoch','Component name','Spectral class 1','Spectral class 2','Comments');
 2 : begin     // Doubles Stars
       if CheckListBox1.Checked[nextpos+0] then begin catheader.fpos[n]:=curpos;  catheader.flen[n]:=textpos[nextpos+0,2]; end;// ID
       ixlen:=catheader.flen[n]; if ixlen>0 then begin usealt[0].i:=nextpos; if CatPrefix then usealt[0].l:=trim(edit4.text) else usealt[0].l:=''; ixlen:=ixlen+length(usealt[0].l) end;
       curpos:=curpos+catheader.flen[n]; inc(n);
       if CheckListBox1.Checked[nextpos+1] then begin catheader.fpos[n]:=curpos;  catheader.flen[n]:=sizeof(smallint); end;// mag1
       keypos:=curpos;
       curpos:=curpos+catheader.flen[n]; inc(n);
       if CheckListBox1.Checked[nextpos+2] then begin catheader.fpos[n]:=curpos;  catheader.flen[n]:=sizeof(smallint); end;// mag2
       curpos:=curpos+catheader.flen[n]; inc(n);
       if CheckListBox1.Checked[nextpos+3] then begin catheader.fpos[n]:=curpos;  catheader.flen[n]:=sizeof(smallint); end;// sep
       curpos:=curpos+catheader.flen[n]; inc(n);
       if CheckListBox1.Checked[nextpos+4] then begin catheader.fpos[n]:=curpos;  catheader.flen[n]:=sizeof(smallint); end;// PA
       curpos:=curpos+catheader.flen[n]; inc(n);
       if CheckListBox1.Checked[nextpos+5] then begin catheader.fpos[n]:=curpos;  catheader.flen[n]:=sizeof(single); end;// epoch
       curpos:=curpos+catheader.flen[n]; inc(n);
       if CheckListBox1.Checked[nextpos+6] then begin catheader.fpos[n]:=curpos;  catheader.flen[n]:=textpos[nextpos+6,2]; end;// Comp name
       curpos:=curpos+catheader.flen[n]; inc(n);
       if CheckListBox1.Checked[nextpos+7] then begin catheader.fpos[n]:=curpos;  catheader.flen[n]:=textpos[nextpos+7,2]; end;// SP 1
       curpos:=curpos+catheader.flen[n]; inc(n);
       if CheckListBox1.Checked[nextpos+8] then begin catheader.fpos[n]:=curpos;  catheader.flen[n]:=textpos[nextpos+8,2]; end;// SP 2
       curpos:=curpos+catheader.flen[n]; inc(n);
       if CheckListBox1.Checked[nextpos+9] then begin catheader.fpos[n]:=curpos;  catheader.flen[n]:=textpos[nextpos+9,2]; end;// Comment
       curpos:=curpos+catheader.flen[n]; inc(n);
       inc(n);
       inc(n);
       inc(n);
       nextpos:=nextpos+10;
     end;
//9 ('ID number','Nebula type','Magnitude','Surface brigtness','Largest dimension','Smallest diemnsion','Position angle','Radial velocity','Morphological class','Comments','Color');
 3 : begin     // Nebulae
       if CheckListBox1.Checked[nextpos+0] then begin catheader.fpos[n]:=curpos;  catheader.flen[n]:=textpos[nextpos+0,2]; end;// ID
       ixlen:=catheader.flen[n]; if ixlen>0 then begin usealt[0].i:=nextpos; if CatPrefix then usealt[0].l:=trim(edit4.text) else usealt[0].l:=''; ixlen:=ixlen+length(usealt[0].l) end;
       curpos:=curpos+catheader.flen[n]; inc(n);
       if CheckListBox1.Checked[nextpos+1] then begin catheader.fpos[n]:=curpos;  catheader.flen[n]:=sizeof(byte)    ; end;// type
       curpos:=curpos+catheader.flen[n]; inc(n);
       if CheckListBox1.Checked[nextpos+2] then begin catheader.fpos[n]:=curpos;  catheader.flen[n]:=sizeof(smallint); end;// mag.
       keypos:=curpos;
       curpos:=curpos+catheader.flen[n]; inc(n);
       if CheckListBox1.Checked[nextpos+3] then begin catheader.fpos[n]:=curpos;  catheader.flen[n]:=sizeof(smallint); end;// sbr
       curpos:=curpos+catheader.flen[n]; inc(n);
       if CheckListBox1.Checked[nextpos+4] then begin catheader.fpos[n]:=curpos;  catheader.flen[n]:=sizeof(single); end;// size
       curpos:=curpos+catheader.flen[n]; inc(n);
       if CheckListBox1.Checked[nextpos+5] then begin catheader.fpos[n]:=curpos;  catheader.flen[n]:=sizeof(single); end;// size2
       curpos:=curpos+catheader.flen[n]; inc(n);
       if CheckListBox1.Checked[nextpos+6] then begin catheader.fpos[n]:=curpos;  catheader.flen[n]:=sizeof(smallint); end;// Unit
       curpos:=curpos+catheader.flen[n]; inc(n);
       if CheckListBox1.Checked[nextpos+7] then begin catheader.fpos[n]:=curpos;  catheader.flen[n]:=sizeof(smallint); end;// PA
       curpos:=curpos+catheader.flen[n]; inc(n);
       if CheckListBox1.Checked[nextpos+8] then begin catheader.fpos[n]:=curpos;  catheader.flen[n]:=sizeof(single); end;// RV
       curpos:=curpos+catheader.flen[n]; inc(n);
       if CheckListBox1.Checked[nextpos+9] then begin catheader.fpos[n]:=curpos;  catheader.flen[n]:=textpos[nextpos+9,2]; end;// morph class
       curpos:=curpos+catheader.flen[n]; inc(n);
       if CheckListBox1.Checked[nextpos+10] then begin catheader.fpos[n]:=curpos;  catheader.flen[n]:=textpos[nextpos+10,2]; end;// Comment
       curpos:=curpos+catheader.flen[n]; inc(n);
       if CheckListBox1.Checked[nextpos+11] then begin catheader.fpos[n]:=curpos;  catheader.flen[n]:=sizeof(cardinal); end;// Color
       curpos:=curpos+catheader.flen[n]; inc(n);
       inc(n);
       nextpos:=nextpos+12;
     end;
//5 ('Catalog ID','[Line op]','Line width','Line color','use spline','Comments');
 4 : begin     // Outlines
       if CheckListBox1.Checked[nextpos+0] then begin catheader.fpos[n]:=curpos;  catheader.flen[n]:=textpos[nextpos+0,2]; end;// ID
       ixlen:=catheader.flen[n]; if ixlen>0 then begin usealt[0].i:=nextpos; if CatPrefix then usealt[0].l:=trim(edit4.text) else usealt[0].l:=''; ixlen:=ixlen+length(usealt[0].l) end;
       keypos:=curpos;
       curpos:=curpos+catheader.flen[n]; inc(n);
       if CheckListBox1.Checked[nextpos+1] then begin catheader.fpos[n]:=curpos;  catheader.flen[n]:=sizeof(byte)  ; end;// line type
       curpos:=curpos+catheader.flen[n]; inc(n);
       if CheckListBox1.Checked[nextpos+2] then begin catheader.fpos[n]:=curpos;  catheader.flen[n]:=sizeof(byte)  ; end;// line width
       curpos:=curpos+catheader.flen[n]; inc(n);
       if CheckListBox1.Checked[nextpos+3] then begin catheader.fpos[n]:=curpos;  catheader.flen[n]:=sizeof(cardinal); end;// line color
       curpos:=curpos+catheader.flen[n]; inc(n);
       if CheckListBox1.Checked[nextpos+4] then begin catheader.fpos[n]:=curpos;  catheader.flen[n]:=sizeof(byte)  ; end;// drawing
       curpos:=curpos+catheader.flen[n]; inc(n);
       if CheckListBox1.Checked[nextpos+5] then begin catheader.fpos[n]:=curpos;  catheader.flen[n]:=textpos[nextpos+5,2]; end;// Comment
       curpos:=curpos+catheader.flen[n]; inc(n);
       inc(n);
       inc(n);
       inc(n);
       inc(n);
       inc(n);
       inc(n);
       inc(n);
       nextpos:=nextpos+6;
     end;
end;
nbalt:=0;
basealt:=nextpos;
for i:=0 to 9 do begin
   if CheckListBox1.Checked[nextpos+i] then begin
      catheader.fpos[n]:=curpos;
      catheader.flen[n]:=textpos[nextpos+i,2];
   end;
   if createindex and indexaltname and (altname[n-15]=1) then begin
      inc(nbalt);
      j:=catheader.flen[n];
      if (catheader.UsePrefix>=1)and(altprefix[n-15]=1)and(trim(catheader.flabel[n])<>'NA') then j:=j+length(trim(catheader.flabel[n]));
      usealt[nbalt].i:=nextpos+i;
      if (altprefix[n-15]=1)and(trim(catheader.flabel[n])<>'NA') then usealt[nbalt].l:=trim(catheader.flabel[n])
         else usealt[nbalt].l:='';
      ixlen:=maxintvalue([ixlen,j]);
   end;
   curpos:=curpos+catheader.flen[n];
   inc(n);
end;
for i:=10 to 19 do begin
   if CheckListBox1.Checked[nextpos+i] then begin
      catheader.fpos[n]:=curpos;
      catheader.flen[n]:=sizeof(single);
   end;
   curpos:=curpos+catheader.flen[n];
   inc(n);
end;
catheader.reclen:=0;
for i:=1 to 35 do catheader.reclen:=catheader.reclen+catheader.flen[i];
ixlen:=minintvalue([ixlen,255]);
catheader.IxKeylen:=ixlen;
end;

Procedure Tf_catgen.BuildTxtHeader;
var i,j,n : integer;
    curpos : integer;
    buf : shortstring;
begin
for i:=1 to 10 do catheader.Spare1[i]:=0;
for i:=1 to 15 do catheader.Spare2[i]:=0;
for i:=1 to 15 do catheader.Spare3[i]:=0;
for i:=1 to 40 do catheader.fpos[i]:=0;
for i:=1 to 40 do catheader.flen[i]:=0;
n:=l_base;
case radiogroup1.itemindex of
 0 : begin catheader.version:='CDCSTAR2'; n:=n+l_etoiles; end;
 1 : begin catheader.version:='CDCVAR 2'; n:=n+l_variable; end;
 2 : begin catheader.version:='CDCDBL 2'; n:=n+l_double; end;
 3 : begin catheader.version:='CDCNEB 2'; n:=n+l_nebuleuse; end;
 4 : begin catheader.version:='CDCLINE2'; n:=n+l_outlines; end;
end;
for i:=1 to n do begin
    buf:=flabel[i]+'           ';
    for j:=0 to 10 do catheader.flabel[i,j]:=buf[j+1];
end;
for i:=n+1 to 14 do begin
    buf:='           ';
    for j:=0 to 10 do catheader.flabel[i,j]:=buf[j+1];
end;
for i:=15 to 35 do begin
    buf:=flabel[i-(15-n)]+'           ';
    for j:=0 to 10 do catheader.flabel[i,j]:=buf[j+1];
end;
createindex:=false;
indexaltname:=false;
catheader.useprefix:=0;
for i:=1 to l_sup do catheader.AltName[i]:=altname[i];
for i:=1 to l_sup do catheader.AltPrefix[i]:=altprefix[i];
buf:=pchar(edit4.text+'    ');
for i:=1 to 4 do catheader.ShortName[i-1]:=buf[i];
buf:=pchar(edit5.text+StringOfChar(' ',50));
for i:=1 to 50 do catheader.LongName[i-1]:=buf[i];
catheader.hdrl:=sizeof(catheader);
catheader.filenum:=1;
catheader.TxtFileName:=extractfilename(listbox1.Items[0]);
catheader.Equinox:=floatedit1.value;
catheader.Epoch:=floatedit3.value;
if catheader.version='CDCNEB 2' then begin
   catheader.MagMax:=floatedit2.value;
   catheader.Size:=longedit1.Value;
   catheader.Units:=nebulaesizescale;
   catheader.ObjType:=nebtype[Combobox3.ItemIndex+1];
   if CheckBox1.Checked then catheader.LogSize:=1 else catheader.LogSize:=0;
end else if catheader.version='CDCLINE2' then begin
   catheader.MagMax:=floatedit2.value;
   catheader.Size:=longedit2.Value;
   catheader.Units:=Shape1.Brush.Color;
   if checkbox7.checked then catheader.ObjType:=1
                        else catheader.ObjType:=0;
   catheader.LogSize:=RadioGroup6.ItemIndex;
end else begin
   catheader.MagMax:=floatedit2.value;
   catheader.Size:=0;
   catheader.Units:=0;
   catheader.ObjType:=0;
   catheader.LogSize:=0;
end;
curpos:=0;
n:=1;
//RA
catheader.RAmode:=radiogroup2.itemindex;
catheader.fpos[n]:=textpos[curpos,1]; // H
catheader.flen[n]:=textpos[curpos,2];
inc(curpos);inc(n);
if (radiogroup2.itemindex=0)or(radiogroup2.itemindex=2) then begin
  catheader.fpos[36]:=textpos[curpos,1]; // M
  catheader.flen[36]:=textpos[curpos,2];
  inc(curpos);
  catheader.fpos[37]:=textpos[curpos,1]; // S
  catheader.flen[37]:=textpos[curpos,2];
  inc(curpos);
end;
//DEC
catheader.DECmode:=radiogroup3.itemindex;
if radiogroup3.itemindex=0 then begin
  catheader.fpos[40]:=textpos[curpos,1]; // sign
  catheader.flen[40]:=textpos[curpos,2];
  inc(curpos);
end;
catheader.fpos[n]:=textpos[curpos,1]; // D
catheader.flen[n]:=textpos[curpos,2];
inc(curpos);inc(n);
if radiogroup3.itemindex=0 then begin
  catheader.fpos[38]:=textpos[curpos,1]; // M
  catheader.flen[38]:=textpos[curpos,2];
  inc(curpos);
  catheader.fpos[39]:=textpos[curpos,1]; // S
  catheader.flen[39]:=textpos[curpos,2];
  inc(curpos);
end;
case radiogroup1.itemindex of
//9 ('Catalog ID','[Magnitude V]','B-V','Magnitude B','Magnitude R','Spectral class','Proper motion RA','Proper motion DEC','epoch','Parallax','Comments');
 0 : begin     // Stars
       for i:=1 to 11 do begin
         if CheckListBox1.Checked[curpos] then begin catheader.fpos[n]:=textpos[curpos,1];  catheader.flen[n]:=textpos[curpos,2]; end;
         inc(curpos); inc(n);
       end;
       inc(n,2); // skip 2
     end;
//9 ('Catalog ID','[Magnitude max]','[Magnitude min]','Period','Type','Maxima Epoch','Rise Time','Spectral class','Magnitude code','Comments');
 1 : begin     // variables
       for i:=1 to 10 do begin
         if CheckListBox1.Checked[curpos] then begin catheader.fpos[n]:=textpos[curpos,1];  catheader.flen[n]:=textpos[curpos,2]; end;
         inc(curpos); inc(n);
       end;
       inc(n,3); // skip 3
     end;
//9 ('Catalog ID','[Magnitude component 1]','Magnitude component 2','[Separation]','Position angle','Epoch','Component name','Spectral class 1','Spectral class 2','Comments');
 2 : begin     // Doubles Stars
       for i:=1 to 10 do begin
         if CheckListBox1.Checked[curpos] then begin catheader.fpos[n]:=textpos[curpos,1];  catheader.flen[n]:=textpos[curpos,2]; end;
         inc(curpos); inc(n);
       end;
       inc(n); // skip 3
       inc(n);
       inc(n);
     end;
//9 ('ID number','Nebula type','Magnitude','Surface brigtness','Largest dimension','Smallest diemnsion','Units','Position angle','Radial velocity','Morphological class','Comments','Color');
 3 : begin     // Nebulae
       for i:=1 to 12 do begin
         if CheckListBox1.Checked[curpos] then begin catheader.fpos[n]:=textpos[curpos,1];  catheader.flen[n]:=textpos[curpos,2]; end;
         inc(curpos); inc(n);
       end;
       inc(n); // skip 1
     end;
//5 ('Catalog ID','[Line op]','Line width','Line color','use spline','Comments');
 4 : begin     // Outlines
       for i:=1 to 6 do begin
         if CheckListBox1.Checked[curpos] then begin catheader.fpos[n]:=textpos[curpos,1];  catheader.flen[n]:=textpos[curpos,2]; end;
         inc(curpos); inc(n);
       end;
       inc(n,7); // skip 7
     end;
end;
for i:=0 to 19 do begin
   if CheckListBox1.Checked[curpos] then begin
      catheader.fpos[n]:=textpos[curpos,1];
      catheader.flen[n]:=textpos[curpos,2];
   end;
   inc(curpos); inc(n);
   if curpos>=CheckListBox1.Count then break;
end;
catheader.reclen:=0;
catheader.IxKeylen:=0;
end;

Function Tf_catgen.GetFloat(p : integer; default :double) : double ;
var code : integer;
begin
val(trim(copy(inl,textpos[p,1],textpos[p,2])),result,code);
if code<>0 then result:=default
           else result:=calc[p,1]*result+calc[p,2];
end;

Function Tf_catgen.GetInt(p : integer) : Integer;
var code : integer;
begin
val(trim(copy(inl,textpos[p,1],textpos[p,2])),result,code);
if code<>0 then result:=MaxInt;
end;

Function Tf_catgen.GetString(p : integer) : string;
begin
result:=copy(inl,textpos[p,1],textpos[p,2]);
end;

Function Tf_catgen.GetNebType(p : integer) : byte;
var i : integer;
    buf:string;
begin
buf:=trim(copy(inl,textpos[p,1],textpos[p,2]));
if buf='' then result:=255
else begin
result:=255;
buf:=buf+',';
for i:=1 to 19 do begin
  if pos(buf,neblst[i])>0 then begin
     result:=nebtype[i];
     break;
  end;
end;
end;
end;

Function Tf_catgen.GetNebUnit(p : integer) : Smallint;
var i : integer;
    buf:string;
begin
buf:=trim(copy(inl,textpos[p,1],textpos[p,2]));
if buf='' then result:=60
else begin
result:=60;
buf:=buf+',';
for i:=1 to 3 do begin
  if pos(buf,nebunit[i])>0 then begin
     result:=nebunits[i];
     break;
  end;
end;
end;
end;

Function Tf_catgen.GetLineType(p : integer) : Smallint;
var i : integer;
    buf:string;
begin
buf:=trim(copy(inl,textpos[p,1],textpos[p,2]));
if buf='' then buf:=' ';
result:=-1;
buf:=buf+',';
for i:=1 to 4 do begin
  if pos(buf,Linelst[i])>0 then begin
     result:=Linetype[i];
     break;
  end;
end;
end;

Function Tf_catgen.Getcolor(p : integer) : Tcolor;
var i : integer;
    buf:string;
begin
buf:=trim(copy(inl,textpos[p,1],textpos[p,2]));
if buf='' then buf:=' ';
result:=clWhite;
buf:=buf+',';
for i:=1 to 10 do begin
  if pos(buf,colorlst[i])>0 then begin
     case i of
      1 : result:=shape2.brush.color;
      2 : result:=shape3.brush.color;
      3 : result:=shape4.brush.color;
      4 : result:=shape5.brush.color;
      5 : result:=shape6.brush.color;
      6 : result:=shape7.brush.color;
      7 : result:=shape8.brush.color;
      8 : result:=shape9.brush.color;
      9 : result:=shape10.brush.color;
      10: result:=shape11.brush.color;
      end;
     break;
  end;
end;
end;

Procedure Tf_catgen.PutRecDouble(x : double; p: integer) ;
begin
  move(x,datarec[catheader.fpos[p]-1],catheader.flen[p]);
end;

Procedure Tf_catgen.PutRecSingle(x : single; p: integer) ;
begin
  move(x,datarec[catheader.fpos[p]-1],catheader.flen[p]);
end;

Procedure Tf_catgen.PutRecInt(x : integer; p: integer) ;
begin
  move(x,datarec[catheader.fpos[p]-1],catheader.flen[p]);
end;

Procedure Tf_catgen.PutRecCard(x : cardinal; p: integer) ;
begin
  move(x,datarec[catheader.fpos[p]-1],catheader.flen[p]);
end;

Procedure Tf_catgen.PutRecSmallInt(x : integer; p: integer) ;
var i : Smallint;
begin
  if x>32767 then x:=32767;
  if x<-32768 then x:=-32768;
  i:=x;
  move(i,datarec[catheader.fpos[p]-1],catheader.flen[p]);
end;

Procedure Tf_catgen.PutRecByte(x : byte; p: integer) ;
begin
  move(x,datarec[catheader.fpos[p]-1],catheader.flen[p]);
end;

Procedure Tf_catgen.PutRecString(x : string; p: integer) ;
begin
  x:=x+fillstring;
  move(x[1],datarec[catheader.fpos[p]-1],catheader.flen[p]);
end;

{$ifdef build_old_index}
Procedure Tf_catgen.PutIxSingle(x : single; p: integer) ;
begin
  move(x,indexrec[p*4],4);
end;

Procedure Tf_catgen.PutIxkey(x : string) ;
begin
  x:=x+fillstring;
  move(x[1],indexrec[8],ixlen);
end;

Procedure Tf_catgen.WriteIx;
var n : integer;
begin
blockwrite(ixf,indexrec[0],8+ixlen,n);
end;

{$endif}

Procedure Tf_catgen.FindRegion30(ar,de : double; var lg : integer);
var i1,i2,N,L1 : integer;
begin
i1 := Trunc((de+90)/30) ;
N  := lg_reg_x30[i1,1];
L1 := lg_reg_x30[i1,2];
i2 := Trunc(ar/(360/N));
Lg := L1+i2;
end;

Procedure Tf_catgen.FindRegion15(ar,de : double; var lg : integer);
var i1,i2,N,L1 : integer;
begin
i1 := Trunc((de+90)/15) ;
N  := lg_reg_x15[i1,1];
L1 := lg_reg_x15[i1,2];
i2 := Trunc(ar/(360/N));
Lg := L1+i2;
end;

Procedure Tf_catgen.FindRegion7(ar,de : double; var hemis : char ; var zone,S : integer);
var i1,i2,N,L1,L : integer;
    del : double;
begin
if de>0 then hemis:='n'
        else hemis:='s';
i1 := Trunc((de+90)/7.5) ;
N  := lg_reg_x7[i1,1];
L1 := lg_reg_x7[i1,2];
i2 := Trunc(ar/(360/N));
L  := L1+i2;
del:= Trunc(de/7.5)*7.5;
S  := L;
zone := Trunc(abs(del))*100 + Trunc(Frac(abs(del))*60) ;
end;

Procedure Tf_catgen.FindRegion(ar,de : double; var hemis : char ; var zone,S : integer);
var i1,i2,j1,j2,N,L1,L,S1,k : integer;
    arl,del,dar,dde : double;
begin
if de>0 then hemis:='n'
        else hemis:='s';
i1 := Trunc((de+90)/7.5) ;
N  := lg_reg_x[i1,1];
L1 := lg_reg_x[i1,2];
i2 := Trunc(ar/(360/N));
L  := L1+i2;
S1 := sm_reg_x[L,1];
k  := sm_reg_x[L,2];
del:= Trunc((de+1e-12)/7.5)*7.5;
arl:= (360/N)*i2;
dde:= 7.5/k;
dar:= (360/N)/k;
j1 := Trunc(abs(de-del)/dde);
j2 := Trunc((ar-arl)/dar);
S  := S1+j1*k+j2;
zone := Trunc(abs(del))*100 + Trunc(Frac(abs(del))*60) ;
end;

Procedure Tf_catgen.Createfiles;
var i,n,m : integer;
    f : file;
begin
case catheader.FileNum of
  732 : for n:=0 to 23 do Forcedirectories(destdir+zone_nam[n]);
  9537: for n:=0 to 23 do Forcedirectories(destdir+zone_nam[n]);
end;
filemode:=2;
assignfile(f,destdir+lowercase(trim(catheader.ShortName))+'.hdr');
rewrite(f,1);
blockwrite(f,catheader,catheader.hdrl,n);
Closefile(f);
{$ifdef build_old_index}
if createindex then begin
  ixfn:=lowercase(trim(catheader.ShortName))+'.idx';
  assignfile(ixf,destdir+ixfn);
  if checkbox6.checked then begin reset(ixf,1);Seek(ixf, FileSize(ixf));end
                             else rewrite(ixf,1);
end;
{$endif}
for i:=1 to catheader.FileNum do begin
  if abort then raise exception.create(rsAbortedByUse);
  Fprogress.ProgressBar2.Position:=i;
  Fprogress.label2.caption:=inttostr(i);
  Fprogress.invalidate;
  m:=0;
  case catheader.FileNum of
    1      : ffn[i]:=lowercase(trim(catheader.ShortName))+'.dat';
    50     : ffn[i]:=lowercase(trim(catheader.ShortName))+padzeros(inttostr(i),2)+'.dat';
    184    : ffn[i]:=lowercase(trim(catheader.ShortName))+padzeros(inttostr(i),3)+'.dat';
    732    : begin
               for n:=0 to 23 do if i <= zone_lst7[n] then begin; m:=n; break; end;
               ffn[i]:=slash(zone_nam[m])+lowercase(trim(catheader.ShortName))+padzeros(inttostr(i),3)+'.dat';
             end;
    9537   : begin
               for n:=0 to 23 do if i <= zone_lst[n] then begin; m:=n; break; end;
               ffn[i]:=slash(zone_nam[m])+lowercase(trim(catheader.ShortName))+padzeros(inttostr(i),4)+'.dat';
             end;
    else raise ERangeError.CreateFmt('Invalid number of files : %d',[catheader.filenum]);
  end;
  assignfile(ff[i],destdir+ffn[i]);
  if checkbox6.checked then begin reset(ff[i],1);Seek(ff[i], FileSize(ff[i]));end
                             else rewrite(ff[i],1);
end;
end;

Procedure Tf_catgen.CreateTxtfiles;
var i,n : integer;
    f : file;
begin
filemode:=2;
assignfile(f,destdir+lowercase(trim(catheader.ShortName))+'.hdr');
rewrite(f,1);
blockwrite(f,catheader,catheader.hdrl,n);
Closefile(f);
for i:=1 to 15 do catinfo.neblst[i]:=neblst[i];
for i:=1 to 15 do catinfo.nebtype[i]:=nebtype[i];
for i:=1 to 3 do catinfo.nebunit[i]:=nebunit[i];
for i:=1 to 3 do catinfo.nebunits[i]:=nebunits[i];
for i:=1 to 4 do catinfo.Linelst[i]:=Linelst[i];
for i:=1 to 4 do catinfo.Linetype[i]:=Linetype[i];
for i:=1 to 10 do catinfo.Colorlst[i]:=Colorlst[i];
for i:=1 to 10 do begin
     case i of
      1 : catinfo.Color[i]:=shape2.brush.color;
      2 : catinfo.Color[i]:=shape3.brush.color;
      3 : catinfo.Color[i]:=shape4.brush.color;
      4 : catinfo.Color[i]:=shape5.brush.color;
      5 : catinfo.Color[i]:=shape6.brush.color;
      6 : catinfo.Color[i]:=shape7.brush.color;
      7 : catinfo.Color[i]:=shape8.brush.color;
      8 : catinfo.Color[i]:=shape9.brush.color;
      9 : catinfo.Color[i]:=shape10.brush.color;
      10: catinfo.Color[i]:=shape11.brush.color;
      end;
end;
for i:=0 to 40 do begin
  catinfo.calc[i,1]:=calc[i,1];
  catinfo.calc[i,2]:=calc[i,2];
end;
catinfo.caturl:=trim(edit6.Text);
assignfile(f,destdir+lowercase(trim(catheader.ShortName))+'.info2');
rewrite(f,1);
blockwrite(f,catinfo,sizeof(catinfo),n);
Closefile(f);
end;

Procedure Tf_catgen.Closefiles;
var i : integer;
begin
for i:=1 to catheader.FileNum do begin
  Fprogress.ProgressBar2.Position:=i;
  Fprogress.label2.caption:=inttostr(i);
  Fprogress.invalidate;
  Closefile(ff[i]);
end;
{$ifdef build_old_index}
if createindex then closefile(ixf);
{$endif}
end;

Procedure Tf_catgen.WriteRec(num: integer);
var n : integer;
begin
blockwrite(ff[num],datarec[0],catheader.reclen,n);
end;

Procedure Tf_catgen.RejectRec(lin : string);
begin
if not rejectopen then begin
  assignfile(freject,destdir+'reject.txt');
  rewrite(freject);
  rejectopen:=true;
end;
writeln(freject,lin);
end;

Procedure Tf_catgen.BuildFiles;
var
    ra,s,de : double;
    nextpos,reg,zone,i,j,n : integer;
    hemis : char;
    {$ifdef build_old_index}
    ixra,ixde : single;
    {$endif}
begin
Fprogress.progressbar1.max:=ListBox1.Items.count;
fillstring:=StringOfChar(' ',255);
for n:=0 to ListBox1.Items.count-1 do begin
Fprogress.label1.caption:=Format(rsConvertCatal, [ListBox1.Items[n]]);
Fprogress.progressbar1.position:=n+1;
Fprogress.invalidate;
OpenCatalog(ListBox1.Items[n]);
Fprogress.progressbar2.max:=GetCatalogSize;
ra:=0; de:=0;
i:=0;
repeat
  inc(i);
  if (i mod 1000)=0 then begin
     if abort then raise exception.create(rsAbortedByUse);
     Fprogress.progressbar2.position:=GetCatalogPos;
     Fprogress.progressbar2.invalidate;
     application.processmessages;
  end;
  ReadCatalog(inl);
  nextpos:=0;
  case RadioGroup2.ItemIndex of
  0 : begin
        ra:=15*(Getfloat(nextpos+0,0)+Getfloat(nextpos+1,0)/60+Getfloat(nextpos+2,0)/3600);
        nextpos:=nextpos+3;
      end;
  1 : begin
        ra:=15*(Getfloat(nextpos+0,0));
        nextpos:=nextpos+1;
      end;
  2 : begin
        ra:=Getfloat(nextpos+0,0)+Getfloat(nextpos+1,0)/60+Getfloat(nextpos+2,0)/3600;
        nextpos:=nextpos+3;
      end;
  3 : begin
        ra:=Getfloat(nextpos+0,0);
        nextpos:=nextpos+1;
      end;
  end;
  case RadioGroup3.ItemIndex of
  0 : begin
        if GetString(nextpos)='-' then s:=-1 else s:=1;
        de:=s*Getfloat(nextpos+1,0)+s*Getfloat(nextpos+2,0)/60+s*Getfloat(nextpos+3,0)/3600;
        nextpos:=nextpos+4;
      end;
  1 : begin
        de:=Getfloat(nextpos+0,0);
        nextpos:=nextpos+1;
      end;
  2 : begin
        de:=Getfloat(nextpos+0,0)-90;
        nextpos:=nextpos+1;
      end;
  end;
  if ((ra=0)and(de=0))or
     (ra<0)or(ra>360)or
     (de<-90)or(de>90)
     then begin
       RejectRec(inl);
       continue;
  end;
  PutRecCard(round(ra*3600000),1);
  PutRecCard(round((de+90)*3600000),2);
  {$ifdef build_old_index}
  if createindex then begin
     ixra:=ra;
     ixde:=de;
     PutIxSingle(ixra,0);
     PutIxSingle(ixde,1);
  end;
  {$endif}
  case radiogroup1.itemindex of
//9 ('Catalog ID','[Magnitude V]','B-V','Magnitude B','Magnitude R','Spectral class','Proper motion RA','Proper motion DEC','Parallax','Comments');
  0 : begin     // Stars
        if catheader.flen[3]>0 then PutRecString(GetString(nextpos),3);  // id
        inc(nextpos);
        if catheader.flen[4]>0 then PutRecSmallint(round(Getfloat(nextpos,99)*1000),4);   // ma
        inc(nextpos);
        if catheader.flen[5]>0 then PutRecSmallint(round(Getfloat(nextpos,99)*1000),5);   // b-v
        inc(nextpos);
        if catheader.flen[6]>0 then PutRecSmallint(round(Getfloat(nextpos,99)*1000),6);   // b
        inc(nextpos);
        if catheader.flen[7]>0 then PutRecSmallint(round(Getfloat(nextpos,99)*1000),7);   // r
        inc(nextpos);
        if catheader.flen[8]>0 then PutRecString(GetString(nextpos),8);  // sp
        inc(nextpos);
        if catheader.flen[9]>0 then PutRecSmallint(round(Getfloat(nextpos,0)*1000),9);   // pmar
        inc(nextpos);
        if catheader.flen[10]>0 then PutRecSmallint(round(Getfloat(nextpos,0)*1000),10);   // pmde
        inc(nextpos);
        if catheader.flen[11]>0 then PutRecSingle(Getfloat(nextpos,0),11);   // pos epoch
        inc(nextpos);
        if catheader.flen[12]>0 then PutRecSmallint(round(Getfloat(nextpos,0)*10000),12);  // px
        inc(nextpos);
        if catheader.flen[13]>0 then PutRecString(GetString(nextpos),13); // com
        inc(nextpos);
  end;
//9 ('Catalog ID','[Magnitude max]','[Magnitude min]','Period','Type','Maxima Epoch','Rise Time','Spectral class','Magnitude code','Comments');
  1 : begin     // Variables Stars
        if catheader.flen[3]>0 then PutRecString(GetString(nextpos),3);  // id
        inc(nextpos);
        if catheader.flen[4]>0 then PutRecSmallint(round(Getfloat(nextpos,99)*1000),4);   // ma 1
        inc(nextpos);
        if catheader.flen[5]>0 then PutRecSmallint(round(Getfloat(nextpos,99)*1000),5);   // ma 2
        inc(nextpos);
        if catheader.flen[6]>0 then PutRecSingle(Getfloat(nextpos,0),6);   // period
        inc(nextpos);
        if catheader.flen[7]>0 then PutRecString(GetString(nextpos),7);  // type
        inc(nextpos);
        if catheader.flen[8]>0 then PutRecSingle(Getfloat(nextpos,0),8);   // epoch
        inc(nextpos);
        if catheader.flen[9]>0 then PutRecSmallint(round(Getfloat(nextpos,0)*100),9);   // rise
        inc(nextpos);
        if catheader.flen[10]>0 then PutRecString(GetString(nextpos),10);  // sp
        inc(nextpos);
        if catheader.flen[11]>0 then PutRecString(GetString(nextpos),11);  // m code
        inc(nextpos);
        if catheader.flen[12]>0 then PutRecString(GetString(nextpos),12);  // com
        inc(nextpos);
  end;
//9 ('Catalog ID','[Magnitude component 1]','Magnitude component 2','[Separation]','Position angle','Epoch','Component name','Spectral class 1','Spectral class 2','Comments');
  2 : begin     // Doubles Stars
        if catheader.flen[3]>0 then PutRecString(GetString(nextpos),3);  // id
        inc(nextpos);
        if catheader.flen[4]>0 then PutRecSmallint(round(Getfloat(nextpos,99)*1000),4);   // ma 1
        inc(nextpos);
        if catheader.flen[5]>0 then PutRecSmallint(round(Getfloat(nextpos,99)*1000),5);   // ma 2
        inc(nextpos);
        if catheader.flen[6]>0 then PutRecSmallint(round(Getfloat(nextpos,0)*10),6);   // sep
        inc(nextpos);
        if catheader.flen[7]>0 then PutRecSmallint(round(Getfloat(nextpos,-999)),7);   // pa
        inc(nextpos);
        if catheader.flen[8]>0 then PutRecSingle(Getfloat(nextpos,0),8);   // epoch
        inc(nextpos);
        if catheader.flen[9]>0 then PutRecString(GetString(nextpos),9);  // comp
        inc(nextpos);
        if catheader.flen[10]>0 then PutRecString(GetString(nextpos),10);  // sp 1
        inc(nextpos);
        if catheader.flen[11]>0 then PutRecString(GetString(nextpos),11);  // sp 2
        inc(nextpos);
        if catheader.flen[12]>0 then PutRecString(GetString(nextpos),12); // com
        inc(nextpos);
  end;
  //9 ('ID number','Nebula type','Magnitude','Surface brigtness','Largest dimension','Smallest diemnsion','Position angle','Radial velocity','Morphological class','Comments','Color');
  3 : begin     // Nebulae
        if catheader.flen[3]>0 then PutRecString(GetString(nextpos),3);  // id
        inc(nextpos);
        if catheader.flen[4]>0 then PutRecByte(GetNebType(nextpos),4);       // nebtyp
        inc(nextpos);
        if catheader.flen[5]>0 then PutRecSmallint(round(Getfloat(nextpos,99)*1000),5);   // ma
        inc(nextpos);
        if catheader.flen[6]>0 then PutRecSmallint(round(Getfloat(nextpos,99)*1000),6);   // sbr
        inc(nextpos);
        if catheader.flen[7]>0 then PutRecSingle(Getfloat(nextpos,0),7);   // size
        inc(nextpos);
        if catheader.flen[8]>0 then PutRecSingle(Getfloat(nextpos,0),8);   // size2
        inc(nextpos);
        if catheader.flen[9]>0 then PutRecSmallint(GetNebUnit(nextpos),9);   // Unit
        inc(nextpos);
        if catheader.flen[10]>0 then PutRecSmallint(round(Getfloat(nextpos,99999)),10);   // pa
        inc(nextpos);
        if catheader.flen[11]>0 then PutRecSingle(Getfloat(nextpos,0),11);  // rv
        inc(nextpos);
        if catheader.flen[12]>0 then PutRecString(GetString(nextpos),12); // class
        inc(nextpos);
        if catheader.flen[13]>0 then PutRecString(GetString(nextpos),13); // com
        inc(nextpos);
        if catheader.flen[14]>0 then PutRecCard(Getcolor(nextpos),14);   // color
        inc(nextpos);
     end;
//5 ('Catalog ID','[Line op]','Line width','Line color','use spline','Comments');
  4 : begin     // Nebulae outlines
        if catheader.flen[3]>0 then PutRecString(GetString(nextpos),3);  // id
        inc(nextpos);
        if catheader.flen[4]>0 then PutRecByte(GetLineType(nextpos),4);       // linetyp
        inc(nextpos);
        if catheader.flen[5]>0 then PutRecByte(round(Getfloat(nextpos,1)),5);   // line width
        inc(nextpos);
        if catheader.flen[6]>0 then PutRecCard(Getcolor(nextpos),6);   // linecolor
        inc(nextpos);
        if catheader.flen[7]>0 then PutRecByte(round(Getfloat(nextpos,1)),7);   // drawing
        inc(nextpos);
        if catheader.flen[8]>0 then PutRecString(GetString(nextpos),8); // com
        inc(nextpos);
     end;
  end;
  for j:=16 to 25 do begin
     if catheader.flen[j]>0 then PutRecString(GetString(nextpos),j);  // str
     inc(nextpos);
  end;
  for j:=26 to 35 do begin
     if catheader.flen[j]>0 then PutRecSingle(Getfloat(nextpos,0),j);   // num
     inc(nextpos);
  end;
  {$ifdef build_old_index}
  if createindex then for j:=0 to nbalt do begin
     if usealt[j].i>0 then begin
        buf:=uppercase(StringReplace(GetString(usealt[j].i),' ','',[rfReplaceAll]));
        if buf>'' then begin
           if (j>0) and (catheader.useprefix>=1) then buf:=usealt[j].l+buf;
           if (j=0) and CheckBox8.Checked then buf:=usealt[j].l+buf;
           PutIxKey(buf);
           WriteIx;
        end;
     end;
  end;
  {$endif}
  case catheader.filenum of
    1      : reg:=1;
    50     : FindRegion30(ra,de,reg);
    184    : FindRegion15(ra,de,reg);
    732    : FindRegion7(ra,de,hemis,zone,reg);
    9537   : FindRegion(ra,de,hemis,zone,reg);
  end;
  WriteRec(reg);
until CatalogEOF;
CloseCatalog;
end;
end;

function Tf_catgen.filegetsize(fn:string):integer;
var f : file;
begin
assignfile(f,fn);
filemode:=0;
reset(f,1);
result:=filesize(f);
closefile(f);
end;

function CompareMag(Item1, Item2: Pointer): Integer;
begin
  Result:=CompSmallAt(Item1, Item2, keypos-1);
end;

{$ifdef build_old_index}
function CompareIX(Item1, Item2: Pointer): Integer;
begin
  Result:=CompareTextFrom(Item1, Item2, 9, ixlen);
end;
{$endif}

function CompareIXrec(Item1, Item2: Pointer): Integer;
begin
  Result:=CompareTextFrom(Item1, Item2, 7, ixlen);
end;

Procedure Tf_catgen.Sortfiles;
var i : integer;
    Sorter: TFixRecSort;
begin
for i:=1 to catheader.FileNum do begin
  if abort then raise exception.create(rsAbortedByUse);
  Fprogress.ProgressBar2.Position:=i;
  Fprogress.label2.caption:=inttostr(i);
  Fprogress.invalidate;
  if filegetsize(destdir+ffn[i])<=catheader.reclen then continue;
  Sorter:=TFixRecSort.Create(catheader.reclen);
  Sorter.Stable:=True;
  Sorter.Start(destdir+ffn[i],destdir+'sort.out', @CompareMag);
  Sorter.Free;
  DeleteFile(destdir+ffn[i]);
  RenameFile(destdir+'sort.out', destdir+ffn[i]);
end;
end;

{$ifdef build_old_index}
Procedure Tf_catgen.SortIXfile;
var
  Sorter: TFixRecSort;
begin
Fprogress.progressbar2.max:=2;
Fprogress.progressbar2.position:=1;
Fprogress.label1.caption:=rsSortingTheIn;
Fprogress.label2.caption:='';
application.processmessages;
Sorter:=TFixRecSort.Create(ixlen+8);
Sorter.Stable:=True;
Sorter.Start(destdir+ixfn,destdir+'sort.out', @CompareIX);
Fprogress.progressbar2.position:=2;
application.processmessages;
Sorter.Free;
DeleteFile(destdir+ixfn);
RenameFile(destdir+'sort.out', destdir+ixfn);
end;
{$endif}

Procedure Tf_catgen.BuildBinCat;
begin
Fprogress.onAbortClick:=@ProgressAbort;
Fprogress.progressbar1.max:=4;
Fprogress.progressbar1.position:=0;
Fprogress.progressbar2.max:=1;
Fprogress.progressbar2.position:=0;
Fprogress.label1.caption:=rsCreateHeader;
Fprogress.label2.caption:='';
Fprogress.show;
application.processmessages;
BuildHeader;
Fprogress.progressbar2.position:=1;
Fprogress.invalidate;
Fprogress.label1.caption:=rsCreateFiles;
Fprogress.progressbar1.position:=1;
Fprogress.progressbar2.max:=catheader.filenum;
Fprogress.progressbar2.position:=0;
Fprogress.label2.caption:='';
Fprogress.invalidate;
application.processmessages;
CreateFiles;
Fprogress.label1.caption:=rsConvertCatal2;
Fprogress.progressbar1.position:=2;
Fprogress.progressbar2.max:=1;
Fprogress.progressbar2.position:=0;
Fprogress.label2.caption:='';
Fprogress.invalidate;
application.processmessages;
BuildFiles;
Fprogress.label1.caption:=rsCloseFiles;
Fprogress.progressbar1.max:=4;
Fprogress.progressbar1.position:=3;
Fprogress.progressbar2.max:=catheader.filenum;
Fprogress.progressbar2.position:=0;
Fprogress.label2.caption:='';
Fprogress.invalidate;
application.processmessages;
CloseFiles;
if radiogroup1.ItemIndex<4 then begin
 Fprogress.label1.caption:=rsSortingFiles;
 Fprogress.progressbar1.position:=4;
 Fprogress.progressbar2.max:=catheader.filenum;
 Fprogress.progressbar2.position:=0;
 Fprogress.label2.caption:='';
 Fprogress.invalidate;
 application.processmessages;
 SortFiles;
end;
{$ifdef build_old_index}
if createindex then SortIXfile;
{$endif}
if createindex then BuildIXrec;
if rejectopen then begin
   rejectopen:=false;
   closefile(freject);
   showmessage(Format(rsSomeRecordsW, [destdir]));
end;
end;

Procedure Tf_catgen.BuildTxtCat;
begin
BuildTxtHeader;
CreateTxtfiles;
end;

procedure Tf_catgen.EndbtClick(Sender: TObject);
var i:integer;
begin
try
abort:=false;
chdir(appdir);
if not DirectoryExists(directoryedit1.Text) then begin
  Showmessage(rsPleaseIndica3);
  directoryedit1.SetFocus;
  exit;
end;
if  FileIsReadOnly(directoryedit1.Text) then begin
  Showmessage(rsCannotWriteT+' '+directoryedit1.Text);
  directoryedit1.SetFocus;
  exit;
end;
if checkbox6.checked and (messagedlg(Format(rsWARNINGYouHa, [crlf, crlf, crlf,
  crlf]), mtConfirmation, [mbYes, mbNo], 0)<>mrYes) then exit;
try
  destdir:=slash(directoryedit1.Text);
  panel1.enabled:=false;
  if not directoryexists(destdir) then Forcedirectories(destdir);
  for i:=1 to 19 do neblst[i]:=trim(stringgrid1.cells[1,i])+',';
  for i:=1 to 3  do nebunit[i]:=trim(stringgrid2.cells[1,i])+',';
  for i:=1 to 3  do linelst[i]:=trim(stringgrid3.cells[1,i])+',';
  for i:=1 to 10  do colorlst[i]:=trim(stringgrid4.cells[0,i])+',';
  if binarycat.ItemIndex=0 then
     BuildBinCat
  else
     BuildTxtCat;
  Endbt.visible:=false;
  Exitbt.visible:=true;
finally
  Fprogress.hide;
  panel1.enabled:=true;
end;
except
  on E: Exception do begin
   WriteTrace('Catgen error: '+E.Message);
   MessageDlg('Error: '+E.Message, mtError, [mbClose], 0);
  end;
end;
end;

procedure Tf_catgen.ComboBox1Change(Sender: TObject);
begin
case Combobox1.ItemIndex of
0 : nebulaesizescale:=1;
1 : nebulaesizescale:=60;
2 : nebulaesizescale:=3600;
end;
end;

procedure Tf_catgen.ExitbtClick(Sender: TObject);
begin
close;
end;

procedure Tf_catgen.Memo1MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var i,j,k,l : integer;
begin
i:=memo1.selstart;
j:=memo1.SelLength;
if (i>=0) and (j>0) then begin
  k:=length(memo1.Lines.Strings[0]);
  l:=length(memo1.Lines.Strings[1]);
  if i>k then
    if i>(k+l) then i:=i-k-l-4
             else i:=i-k-2;
  i:=i+1;
  edit1.text:=inttostr(i);
  edit2.text:=inttostr(j);
end;
end;

procedure Tf_catgen.SpeedButton1Click(Sender: TObject);
var i : integer;
begin
opendialog1.filterindex:=1;
opendialog1.DefaultExt:='';
OpenDialog1.Options:=OpenDialog1.Options+[ofAllowMultiSelect];
opendialog1.filename:='';
if opendialog1.execute then begin
   ListBox1.Items.clear;
   for i:=0 to opendialog1.files.Count-1 do begin
      ListBox1.Items.Add(opendialog1.files[i]);
   end;
end;
end;

procedure Tf_catgen.Button1Click(Sender: TObject);
var ini : Tinifile;
    i : integer;
    fn,prjdir: string;
begin
chdir(appdir);
savedialog1.filterindex:=2;
savedialog1.DefaultExt:='.prj';
if savedialog1.execute then begin
  fn:=SafeUTF8ToSys(savedialog1.filename);
  if fileexists(fn) then begin
    deletefile(fn+'.old');
    renamefile(fn,fn+'.old');
  end;
  prjdir:=ExtractFilePath(fn);
  ini:=Tinifile.Create(fn);
  ini.writeInteger('Page1','binarycat',binarycat.itemindex);
  ini.writeInteger('Page1','type',RadioGroup1.itemindex);
  ini.writeString('Page1','shortname',edit4.text);
  ini.writeString('Page1','longname',edit5.text);
  ini.writeInteger('Page1','numfiles',ListBox1.Items.count);
  for i:=0 to ListBox1.Items.count-1 do
     ini.writeString('Page1','inputfiles'+inttostr(i),ExtractRelativepath(prjdir,ListBox1.Items[i]));
  ini.writeString('Page1','caturl',edit6.text);
  ini.writeInteger('Page2','ratype',RadioGroup2.itemindex);
  ini.writeInteger('Page2','dectype',RadioGroup3.itemindex);
  ini.writeFloat('Page2','equinox',FloatEdit1.value);
  ini.writeFloat('Page2','epoch',FloatEdit3.value);
  ini.writeFloat('Page2','magmax',FloatEdit2.value);
  ini.writeInteger('Page2','nebsize',LongEdit1.value);
  ini.writeInteger('Page2','nebunit',Combobox1.itemindex);
  ini.writeInteger('Page2','nebtype',Combobox3.itemindex);
  ini.writeBool('Page2','neblog',checkbox1.checked);
  ini.writeInteger('Page2','linewidth',LongEdit2.value);
  ini.writeInteger('Page2','linecolor',shape1.Brush.color);
  ini.writeInteger('Page2','drawingtype',RadioGroup6.ItemIndex);
  ini.writeBool('Page2','closedline',checkbox7.checked);
  ini.writeInteger('Page3','numitem',checklistbox1.Items.Count);
  for i:=0 to checklistbox1.Items.Count-1 do
      ini.writeBool('Page3','field'+inttostr(i),checklistbox1.Checked[i]);
  for i:=1 to 35 do
      ini.writeString('Page3','label'+inttostr(i),flabel[i]);
  for i:=0 to 40 do begin
      ini.writeInteger('Page3','fieldindex'+inttostr(i),textpos[i,1]);
      ini.writeInteger('Page3','fieldlength'+inttostr(i),textpos[i,2]);
      ini.writeFloat('Page3','calcA'+inttostr(i),calc[i,1]);
      ini.writeFloat('Page3','calcB'+inttostr(i),calc[i,2]);
  end;
  for i:=1 to l_sup do
      ini.writeInteger('Page3','altname'+inttostr(i),altname[i]);
  for i:=1 to l_sup do
      ini.WriteInteger('Page3','altprefix'+inttostr(i),altprefix[i]);
  ini.writeInteger('Page4','numfile',RadioGroup4.itemindex);
  ini.writeString('Page4','ouputdir',ExtractRelativepath(prjdir,slash(DirectoryEdit1.text)));
  ini.writeBool('Page4','index',checkbox3.checked);
  ini.writeBool('Page4','altindex',checkbox4.checked);
  ini.writeBool('Page4','prefname',checkbox8.checked);
  ini.writeBool('Page4','append',checkbox6.checked);
  with stringgrid1 do for i:=1 to 16 do
       ini.writeString('Page5','nebtype'+inttostr(i),cells[1,i]);
  with stringgrid2 do for i:=1 to 3 do
       ini.writeString('Page5','unit'+inttostr(i),cells[1,i]);
  with stringgrid3 do for i:=1 to 4 do
       ini.writeString('Page6','linetype'+inttostr(i),cells[1,i]);
  with stringgrid4 do for i:=1 to 10 do
       ini.writeString('Page7','colorstr'+inttostr(i),cells[0,i]);
  ini.writeInteger('Page7','color1',shape2.Brush.Color);
  ini.writeInteger('Page7','color2',shape3.Brush.Color);
  ini.writeInteger('Page7','color3',shape4.Brush.Color);
  ini.writeInteger('Page7','color4',shape5.Brush.Color);
  ini.writeInteger('Page7','color5',shape6.Brush.Color);
  ini.writeInteger('Page7','color6',shape7.Brush.Color);
  ini.writeInteger('Page7','color7',shape8.Brush.Color);
  ini.writeInteger('Page7','color8',shape9.Brush.Color);
  ini.writeInteger('Page7','color9',shape10.Brush.Color);
  ini.writeInteger('Page7','color10',shape11.Brush.Color);
  ini.free;
end;
chdir(appdir);
end;

procedure Tf_catgen.Button2Click(Sender: TObject);
var ini : Tinifile;
    i,n : integer;
    buf,fn,prjdir: string;
    bufok: boolean;
begin
chdir(appdir);
opendialog1.filterindex:=2;
opendialog1.DefaultExt:='.prj';
OpenDialog1.Options:=OpenDialog1.Options-[ofAllowMultiSelect];
opendialog1.filename:='';
if opendialog1.execute then begin
  fn:=SafeUTF8ToSys(OpenDialog1.filename);
  prjdir:=ExtractFilePath(fn);
  ini:=Tinifile.Create(fn);
  binarycat.itemindex:=ini.ReadInteger('Page1','binarycat',0);
  RadioGroup1.itemindex:=ini.ReadInteger('Page1','type',RadioGroup1.itemindex);
  edit4.text:=ini.readString('Page1','shortname',edit4.text);
  edit5.text:=ini.readString('Page1','longname',edit5.text);
  edit6.text:=ini.readString('Page1','caturl','');
  n:=ini.readInteger('Page1','numfiles',0);
  ListBox1.Items.clear;
  chdir(prjdir);
  for i:=0 to n-1 do begin
      buf:=ini.readString('Page1','inputfiles'+inttostr(i),'');
      if trim(buf)>'' then begin
         buf:=ExpandFileName(buf);
         ListBox1.Items.Add(buf);
      end;
  end;
  chdir(appdir);
  RadioGroup2.itemindex:=ini.readInteger('Page2','ratype',RadioGroup2.itemindex);
  RadioGroup3.itemindex:=ini.readInteger('Page2','dectype',RadioGroup3.itemindex);
  FloatEdit1.value:=ini.readFloat('Page2','equinox',FloatEdit1.value);
  FloatEdit3.value:=ini.readFloat('Page2','epoch',FloatEdit3.value);
  FloatEdit2.value:=ini.readFloat('Page2','magmax',FloatEdit2.value);
  LongEdit1.value:=ini.readInteger('Page2','nebsize',LongEdit1.value);
  Combobox1.itemindex:=ini.readInteger('Page2','nebunit',Combobox1.itemindex);
  ComboBox1Change(self);
  Combobox3.itemindex:=ini.readInteger('Page2','nebtype',Combobox3.itemindex);
  checkbox1.checked:=ini.readBool('Page2','neblog',checkbox1.checked);
  LongEdit2.value:=ini.readInteger('Page2','linewidth',LongEdit2.value);
  shape1.Brush.color:=ini.readInteger('Page2','linecolor',shape1.Brush.color);
  RadioGroup6.ItemIndex:=ini.readInteger('Page2','drawingtype',RadioGroup6.ItemIndex);
  checkbox7.checked:=ini.ReadBool('Page2','closedline',checkbox7.checked);
  n:=ini.readInteger('Page3','numitem',0);
  for i:=0 to n-1 do
      checklistbox1.Checked[i]:=ini.readBool('Page3','field'+inttostr(i),checklistbox1.Checked[i]);
  for i:=1 to 35 do
      flabel[i]:=ini.readString('Page3','label'+inttostr(i),flabel[i]);
  for i:=0 to 40 do begin
      textpos[i,1]:=ini.readInteger('Page3','fieldindex'+inttostr(i),textpos[i,1]);
      textpos[i,2]:=ini.readInteger('Page3','fieldlength'+inttostr(i),textpos[i,2]);
      calc[i,1]:=ini.readFloat('Page3','calcA'+inttostr(i),1);
      calc[i,2]:=ini.readFloat('Page3','calcB'+inttostr(i),0);
  end;
  for i:=1 to l_sup do
      altname[i]:=ini.readInteger('Page3','altname'+inttostr(i),altname[i]);
  // for migration of old .prj
    bufok:=ini.ReadBool('Page4','prefalt',false); // old checkbox5.checked
    for i:=1 to l_sup do
         if bufok and (altname[i]=1) then altprefix[i]:=1
                                     else altprefix[i]:=0;
  //
  for i:=1 to l_sup do
      altprefix[i]:=ini.ReadInteger('Page3','altprefix'+inttostr(i),altprefix[i]);
  RadioGroup4.itemindex:=ini.readInteger('Page4','numfile',RadioGroup4.itemindex);
  buf:=ini.readString('Page4','ouputdir','');
  chdir(prjdir);
  buf:=ExpandFileName(buf);
  chdir(appdir);
  DirectoryEdit1.text:=buf;
  checkbox3.checked:=ini.readBool('Page4','index',checkbox3.checked);
  checkbox4.checked:=ini.readBool('Page4','altindex',checkbox4.checked);
  checkbox8.checked:=ini.readBool('Page4','prefname',checkbox8.checked);
  checkbox6.checked:=ini.readBool('Page4','append',checkbox6.checked);
  with stringgrid1 do for i:=1 to 16 do
       cells[1,i]:=ini.readString('Page5','nebtype'+inttostr(i),cells[1,i]);
  with stringgrid2 do for i:=1 to 3 do
       cells[1,i]:=ini.readString('Page5','unit'+inttostr(i),cells[1,i]);
  with stringgrid3 do for i:=1 to 4 do
       cells[1,i]:=ini.readString('Page6','linetype'+inttostr(i),cells[1,i]);
  with stringgrid4 do for i:=1 to 10 do
       cells[0,i]:=ini.readString('Page7','colorstr'+inttostr(i),cells[0,i]);
  shape2.Brush.Color:=ini.readInteger('Page7','color1',shape2.Brush.Color);
  shape3.Brush.Color:=ini.readInteger('Page7','color2',shape3.Brush.Color);
  shape4.Brush.Color:=ini.readInteger('Page7','color3',shape4.Brush.Color);
  shape5.Brush.Color:=ini.readInteger('Page7','color4',shape5.Brush.Color);
  shape6.Brush.Color:=ini.readInteger('Page7','color5',shape6.Brush.Color);
  shape7.Brush.Color:=ini.readInteger('Page7','color6',shape7.Brush.Color);
  shape8.Brush.Color:=ini.readInteger('Page7','color7',shape8.Brush.Color);
  shape9.Brush.Color:=ini.readInteger('Page7','color8',shape9.Brush.Color);
  shape10.Brush.Color:=ini.readInteger('Page7','color9',shape10.Brush.Color);
  shape11.Brush.Color:=ini.readInteger('Page7','color10',shape11.Brush.Color);
  ini.free;
end;
chdir(appdir);
end;

procedure Tf_catgen.DirectoryEdit1AcceptDirectory(Sender: TObject;
  var Value: String);
begin
chdir(appdir);
end;

procedure Tf_catgen.binarycatChange(Sender: TObject);
begin
  RadioGroup4.Visible:=binarycat.ItemIndex=0;
  GroupBox6.Visible:=binarycat.ItemIndex=0;
  CheckBox6.Visible:=binarycat.ItemIndex=0;
  edit6.Visible:=binarycat.ItemIndex=1;
  label23.Visible:=binarycat.ItemIndex=1;
end;

procedure Tf_catgen.FormShow(Sender: TObject);
begin
pagecontrol1.PageIndex:=pageFiles;
nextbt.enabled:=true;
prevbt.enabled:=false;
exitbt.Visible:=true;
endbt.Visible:=false;
endbt.enabled:=false;
end;

procedure Tf_catgen.PageControl1Change(Sender: TObject);
begin
  Panel1.Visible:=PageControl1.PageIndex<=pageBuild;
end;

procedure Tf_catgen.FormDestroy(Sender: TObject);
begin
  Fcatgenadv.Free;
  Fprogress.Free;
end;

procedure Tf_catgen.Button3Click(Sender: TObject);
begin
panel1.enabled:=false;
pagecontrol1.PageIndex:=pageTypeObject;
end;

procedure Tf_catgen.Button4Click(Sender: TObject);
begin
panel1.enabled:=true;
pagecontrol1.PageIndex:=pageDefault;
end;

procedure Tf_catgen.Button6Click(Sender: TObject);
begin
panel1.enabled:=false;
pagecontrol1.PageIndex:=pageUnits;
end;

procedure Tf_catgen.CheckBox2Click(Sender: TObject);
begin
if checkbox2.checked then altname[listindex+1-l_fixe]:=1
                     else altname[listindex+1-l_fixe]:=0;
end;

procedure Tf_catgen.CheckBox9Click(Sender: TObject);
begin
if checkbox9.checked then altprefix[listindex+1-l_fixe]:=1
                     else altprefix[listindex+1-l_fixe]:=0;
end;

procedure Tf_catgen.Button7Click(Sender: TObject);
var i : integer;
    x : double;
begin
if (pos('(',CheckListBox1.items[listindex])=0)and
   (pos('Numeric',CheckListBox1.items[listindex])=0) then exit;
val(memo1.SelText,x,i);
if i<>0 then exit;
Fcatgenadv.A:=calc[listindex,1];
Fcatgenadv.B:=calc[listindex,2];
Fcatgenadv.X:=x;
Fcatgenadv.ShowModal;
if Fcatgenadv.ModalResult=mrOK then begin
  calc[listindex,1]:=Fcatgenadv.A;
  calc[listindex,2]:=Fcatgenadv.B;
end;
end;

procedure Tf_catgen.Button9Click(Sender: TObject);
begin
panel1.enabled:=false;
pagecontrol1.PageIndex:=pageLine;
end;

procedure Tf_catgen.Shape1MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
with sender as Tshape do begin
 ColorDialog1.Color:=Brush.color;
 if colordialog1.Execute then Brush.color:=colordialog1.Color;
end;
end;

procedure Tf_catgen.Button11Click(Sender: TObject);
begin
panel1.enabled:=false;
pagecontrol1.PageIndex:=pageColor;
end;

procedure Tf_catgen.Button12Click(Sender: TObject);
begin
ShowHelp;
end;

procedure Tf_catgen.ProgressAbort(Sender: TObject);
begin
abort:=true;
end;

procedure Tf_catgen.BuildIXrec;
type Tixrec = packed record n: smallint;
                k: integer;
                key : array [0..512] of char;
              end;
var rec:gcatrec;
    ok: boolean;
    i,j,k,kl,wr,ak: integer;
    n:smallint;
    key,fn:string;
    ixrec : Tixrec;
    ixrecf: file;
    Sorter: TFixRecSort;
procedure addindex;
begin
  ixrec.n:=n;
  ixrec.k:=k;
  ixrec.key:=key+fillstring;
  blockwrite(ixrecf,ixrec,6+kl,wr);
end;
begin
 kl:=ixlen;
 fn:=slash(destdir)+lowercase(trim(catheader.ShortName))+'.ixr';
 AssignFile(ixrecf,fn);
 rewrite(ixrecf,1);
 CleanCache;
 SetGCatpath(destdir,lowercase(trim(catheader.ShortName)));
 ReadGCatHeader;
 Fprogress.progressbar2.max:=catheader.FileNum;
 Fprogress.progressbar2.position:=0;
 Fprogress.label1.caption:=rsCreateASearc;
 Fprogress.label2.caption:='';
 application.processmessages;
 for i:=1 to catheader.FileNum do begin
    OpenGCatfile(destdir+ffn[i],ok);
    k:=0;
    n:=i;
    Fprogress.progressbar2.position:=0;
    application.processmessages;
    repeat
      ReadGCat(rec,ok,false);
      if ok then begin
        // main index
        if usealt[0].i>0 then begin
          case radiogroup1.itemindex of
          0:  key:=rec.star.id;
          1:  key:=rec.variable.id;
          2:  key:=rec.double.id;
          3:  key:=rec.neb.id;
          4:  key:=rec.outlines.id;
          else key:='';
          end;
          key:=uppercase(StringReplace(key,' ','',[rfReplaceAll]));
          if key<>'' then begin
            if CheckBox8.Checked then key:=usealt[0].l+key;
            addindex;
          end;
        end;
        // alternate indexes
        if indexaltname then begin
          for j:=1 to nbalt do begin
             if usealt[j].i>0 then begin
               ak:=usealt[j].i-basealt+1;
               key:=uppercase(StringReplace(rec.str[ak],' ','',[rfReplaceAll]));
               if key>'' then begin
                  if catheader.useprefix>=1 then key:=usealt[j].l+key;
                  addindex;
                end;
             end;
          end;
        end;
        inc(k);
      end;
    until not ok;
    CloseGCat;
 end;
 closefile(ixrecf);
 Fprogress.progressbar2.max:=2;
 Fprogress.progressbar2.position:=1;
 Fprogress.label1.caption:=rsSortingTheIn;
 Fprogress.label2.caption:='';
 application.processmessages;
 Sorter:=TFixRecSort.Create(kl+6);
 Sorter.Stable:=True;
 Sorter.Start(fn,destdir+'sort.out', @CompareIXrec);
 Fprogress.progressbar2.position:=2;
 application.processmessages;
 Sorter.Free;
 DeleteFile(fn);
 RenameFile(destdir+'sort.out', fn);
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
