unit fr_config_catalog;
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

uses  u_constant, u_util, cu_catalog, fu_directory,
  SysUtils, Types, Classes, Variants, QTypes, QGraphics, QControls, QForms, 
  QDialogs, QExtCtrls, QStdCtrls, enhedits, QGrids, QButtons, QComCtrls;

type
  Tf_config_catalog = class(TFrame)
    pa_catalog: TPageControl;
    t_catgen: TTabSheet;
    Label1: TLabel;
    Label37: TLabel;
    AddCat: TBitBtn;
    DelCat: TBitBtn;
    StringGrid3: TStringGrid;
    t_cdcstar: TTabSheet;
    Label2: TLabel;
    Label65: TLabel;
    Label66: TLabel;
    Label87: TLabel;
    Label16: TLabel;
    Label28: TLabel;
    Label17: TLabel;
    Label27: TLabel;
    Label18: TLabel;
    BSCbox: TCheckBox;
    Fbsc1: TLongEdit;
    Fbsc2: TLongEdit;
    bsc3: TEdit;
    BitBtn9: TBitBtn;
    SKYbox: TCheckBox;
    Fsky1: TLongEdit;
    Fsky2: TLongEdit;
    sky3: TEdit;
    BitBtn10: TBitBtn;
    TY2Box: TCheckBox;
    Fty21: TLongEdit;
    Fty22: TLongEdit;
    ty23: TEdit;
    BitBtn12: TBitBtn;
    GSCFBox: TCheckBox;
    GSCCbox: TCheckBox;
    USNbox: TCheckBox;
    USNBright: TCheckBox;
    fgscf1: TLongEdit;
    fgscc1: TLongEdit;
    fusn1: TLongEdit;
    fusn2: TLongEdit;
    fgscc2: TLongEdit;
    fgscf2: TLongEdit;
    gscf3: TEdit;
    gscc3: TEdit;
    usn3: TEdit;
    BitBtn19: TBitBtn;
    BitBtn17: TBitBtn;
    BitBtn16: TBitBtn;
    Label21: TLabel;
    Label19: TLabel;
    Label20: TLabel;
    dsbasebox: TCheckBox;
    dstycBox: TCheckBox;
    dsgscBox: TCheckBox;
    dsbase1: TLongEdit;
    dstyc1: TLongEdit;
    dsgsc1: TLongEdit;
    dsgsc2: TLongEdit;
    dstyc2: TLongEdit;
    dsbase2: TLongEdit;
    dsbase3: TEdit;
    dstyc3: TEdit;
    dsgsc3: TEdit;
    BitBtn22: TBitBtn;
    BitBtn21: TBitBtn;
    BitBtn20: TBitBtn;
    BitBtn14: TBitBtn;
    BitBtn15: TBitBtn;
    wds3: TEdit;
    gcv3: TEdit;
    Fgcv2: TLongEdit;
    Fwds2: TLongEdit;
    Fwds1: TLongEdit;
    Fgcv1: TLongEdit;
    GCVBox: TCheckBox;
    IRVar: TCheckBox;
    WDSbox: TCheckBox;
    t_cdcneb: TTabSheet;
    Bevel3: TBevel;
    Bevel4: TBevel;
    Bevel5: TBevel;
    Label3: TLabel;
    Label69: TLabel;
    Label15: TLabel;
    Label116: TLabel;
    Label117: TLabel;
    Label118: TLabel;
    Label119: TLabel;
    NGCbox: TCheckBox;
    ngc3: TEdit;
    SACbox: TCheckBox;
    sac3: TEdit;
    fngc1: TLongEdit;
    fngc2: TLongEdit;
    fsac1: TLongEdit;
    fsac2: TLongEdit;
    BitBtn23: TBitBtn;
    BitBtn24: TBitBtn;
    Label22: TLabel;
    Label23: TLabel;
    Label24: TLabel;
    Label25: TLabel;
    Label26: TLabel;
    Label120: TLabel;
    RC3box: TCheckBox;
    OCLbox: TCheckBox;
    GCMbox: TCheckBox;
    GPNbox: TCheckBox;
    LBNbox: TCheckBox;
    rc33: TEdit;
    lbn3: TEdit;
    ocl3: TEdit;
    gcm3: TEdit;
    gpn3: TEdit;
    PGCBox: TCheckBox;
    pgc3: TEdit;
    flbn1: TLongEdit;
    flbn2: TLongEdit;
    frc31: TLongEdit;
    frc32: TLongEdit;
    fpgc1: TLongEdit;
    fpgc2: TLongEdit;
    focl1: TLongEdit;
    focl2: TLongEdit;
    fgcm1: TLongEdit;
    fgcm2: TLongEdit;
    fgpn1: TLongEdit;
    fgpn2: TLongEdit;
    BitBtn25: TBitBtn;
    BitBtn26: TBitBtn;
    BitBtn27: TBitBtn;
    BitBtn28: TBitBtn;
    BitBtn29: TBitBtn;
    BitBtn30: TBitBtn;
    t_obsolete: TTabSheet;
    Label88: TLabel;
    Label67: TLabel;
    TYCbox: TCheckBox;
    Ftyc1: TLongEdit;
    Ftyc2: TLongEdit;
    tyc3: TEdit;
    BitBtn11: TBitBtn;
    TICbox: TCheckBox;
    Ftic1: TLongEdit;
    Ftic2: TLongEdit;
    tic3: TEdit;
    BitBtn13: TBitBtn;
    GSCbox: TCheckBox;
    fgsc1: TLongEdit;
    fgsc2: TLongEdit;
    gsc3: TEdit;
    BitBtn18: TBitBtn;
    MCTBox: TCheckBox;
    fmct1: TLongEdit;
    fmct2: TLongEdit;
    mct3: TEdit;
    BitBtn32: TBitBtn;
    Label90: TLabel;
    Label91: TLabel;
    Label92: TLabel;
    Label93: TLabel;
    Label94: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    t_external: TTabSheet;
    Label4: TLabel;
    Label52: TLabel;
    Label71: TLabel;
    StringGrid1: TStringGrid;
    Cat1Box: TCheckBox;
    Edit1: TEdit;
    Label64: TLabel;
    Cat2Box: TCheckBox;
    StringGrid2: TStringGrid;
    OpenDialog1: TOpenDialog;
    procedure FormShow(Sender: TObject);
    procedure StringGrid3DrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure StringGrid3MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure StringGrid3SelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure StringGrid3SetEditText(Sender: TObject; ACol, ARow: Integer;
      const Value: WideString);
    procedure AddCatClick(Sender: TObject);
    procedure DelCatClick(Sender: TObject);
    procedure CDCStarSelClick(Sender: TObject);
    procedure USNBrightClick(Sender: TObject);
    procedure CDCStarField1Change(Sender: TObject);
    procedure CDCStarField2Change(Sender: TObject);
    procedure CDCStarPathChange(Sender: TObject);
    procedure CDCStarSelPathClick(Sender: TObject);
    procedure GCVBoxClick(Sender: TObject);
    procedure IRVarClick(Sender: TObject);
    procedure Fgcv1Change(Sender: TObject);
    procedure Fgcv2Change(Sender: TObject);
    procedure gcv3Change(Sender: TObject);
    procedure BitBtn14Click(Sender: TObject);
    procedure WDSboxClick(Sender: TObject);
    procedure Fwds1Change(Sender: TObject);
    procedure Fwds2Change(Sender: TObject);
    procedure wds3Change(Sender: TObject);
    procedure BitBtn15Click(Sender: TObject);
    procedure CDCNebSelClick(Sender: TObject);
    procedure CDCNebField1Change(Sender: TObject);
    procedure CDCNebField2Change(Sender: TObject);
    procedure CDCNebPathChange(Sender: TObject);
    procedure CDCNebSelPathClick(Sender: TObject);
    procedure FrameExit(Sender: TObject);
  private
    { Private declarations }
    catalogempty: boolean;
    procedure ShowGCat;
    procedure ShowCDCStar;                                
    procedure ShowCDCNeb;
    procedure EditGCatPath(row : integer);
    procedure DeleteGCatRow(p : integer);
  public
    { Public declarations }
    catalog: Tcatalog;
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
  f_config_catalog: Tf_config_catalog;

implementation

{$R *.xfm}

// include all cross-platform common code.
// you can temporarily copy the file content here
// to use the IDE facilities

{$include i_config_catalog.pas}

// end of common code

end.
