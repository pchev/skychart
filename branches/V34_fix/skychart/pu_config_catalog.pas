unit pu_config_catalog;

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

uses u_help, u_translation, u_constant, u_util, cu_catalog, pu_catgen,
  pu_catgenadv, pu_progressbar, FileUtil,
  LCLIntf, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, enhedits, Grids, Buttons, ComCtrls, LResources,
  EditBtn, LazHelpHTML;

type

  { Tf_config_catalog }

  Tf_config_catalog = class(TForm)
    bsc3: TDirectoryEdit;
    addcat: TButton;
    Button4: TButton;
    delcat: TButton;
    CatgenButton: TButton;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    fgcm1: TLongEdit;
    fgcm2: TLongEdit;
    fgpn1: TLongEdit;
    fgpn2: TLongEdit;
    flbn1: TLongEdit;
    flbn2: TLongEdit;
    fngc1: TLongEdit;
    fngc2: TLongEdit;
    focl1: TLongEdit;
    focl2: TLongEdit;
    fpgc1: TLongEdit;
    fpgc2: TLongEdit;
    frc31: TLongEdit;
    frc32: TLongEdit;
    fsac1: TLongEdit;
    fsac2: TLongEdit;
    fw4: TLabel;
    fw5: TLabel;
    fw6: TLabel;
    fw7: TLabel;
    fw8: TLabel;
    fw9: TLabel;
    fw0: TLabel;
    fw1: TLabel;
    fw2: TLabel;
    fw3: TLabel;
    gcm3: TDirectoryEdit;
    GCMbox: TCheckBox;
    gpn3: TDirectoryEdit;
    GPNbox: TCheckBox;
    Label95: TLabel;
    LabelWarning: TLabel;
    Label119: TLabel;
    Label22: TLabel;
    Label23: TLabel;
    Label24: TLabel;
    Label25: TLabel;
    Label26: TLabel;
    Label5: TLabel;
    fw10: TLabel;
    Label69: TLabel;
    lbn3: TDirectoryEdit;
    LBNbox: TCheckBox;
    ngc3: TDirectoryEdit;
    NGCbox: TCheckBox;
    FOVPanel: TPanel;
    ocl3: TDirectoryEdit;
    OCLbox: TCheckBox;
    Page5: TTabSheet;
    Panel1: TPanel;
    PanelDef: TPanel;
    PanelGen: TPanel;
    PanelSpec: TPanel;
    pgc3: TDirectoryEdit;
    PGCBox: TCheckBox;
    rc33: TDirectoryEdit;
    RC3box: TCheckBox;
    sac3: TDirectoryEdit;
    SACbox: TCheckBox;
    tyc3: TDirectoryEdit;
    tic3: TDirectoryEdit;
    gsc3: TDirectoryEdit;
    mct3: TDirectoryEdit;
    wds3: TDirectoryEdit;
    gcv3: TDirectoryEdit;
    dsgsc3: TDirectoryEdit;
    dstyc3: TDirectoryEdit;
    dsbase3: TDirectoryEdit;
    DirOpenImg: TImage;
    usn3: TDirectoryEdit;
    gscc3: TDirectoryEdit;
    gscf3: TDirectoryEdit;
    ty23: TDirectoryEdit;
    sky3: TDirectoryEdit;
    MainPanel: TPanel;
    Page1: TTabSheet;
    Page2: TTabSheet;
    Page3: TTabSheet;
    Page4: TTabSheet;
    Label37: TLabel;
    StringGrid3: TStringGrid;
    Label2: TLabel;
    Label65: TLabel;
    Label66: TLabel;
    Label87: TLabel;
    Label16: TLabel;
    Label28: TLabel;
    Label17: TLabel;
    Label27: TLabel;
    Label18: TLabel;
    Label21: TLabel;
    Label19: TLabel;
    Label20: TLabel;
    BSCbox: TCheckBox;
    Fbsc1: TLongEdit;
    Fbsc2: TLongEdit;
    SKYbox: TCheckBox;
    Fsky1: TLongEdit;
    Fsky2: TLongEdit;
    TY2Box: TCheckBox;
    Fty21: TLongEdit;
    Fty22: TLongEdit;
    GSCFBox: TCheckBox;
    GSCCbox: TCheckBox;
    USNbox: TCheckBox;
    dsbasebox: TCheckBox;
    dstycBox: TCheckBox;
    dsgscBox: TCheckBox;
    USNBright: TCheckBox;
    fgscf1: TLongEdit;
    fgscc1: TLongEdit;
    fusn1: TLongEdit;
    dsbase1: TLongEdit;
    dstyc1: TLongEdit;
    dsgsc1: TLongEdit;
    dsgsc2: TLongEdit;
    dstyc2: TLongEdit;
    dsbase2: TLongEdit;
    fusn2: TLongEdit;
    fgscc2: TLongEdit;
    fgscf2: TLongEdit;
    Fgcv2: TLongEdit;
    Fwds2: TLongEdit;
    Fwds1: TLongEdit;
    Fgcv1: TLongEdit;
    GCVBox: TCheckBox;
    IRVar: TCheckBox;
    WDSbox: TCheckBox;
    Label3: TLabel;
    Label15: TLabel;
    Label116: TLabel;
    Label117: TLabel;
    Label118: TLabel;
    Label120: TLabel;
    Label88: TLabel;
    Label91: TLabel;
    Label92: TLabel;
    Label93: TLabel;
    Label94: TLabel;
    TYCbox: TCheckBox;
    Ftyc1: TLongEdit;
    Ftyc2: TLongEdit;
    TICbox: TCheckBox;
    Ftic1: TLongEdit;
    Ftic2: TLongEdit;
    GSCbox: TCheckBox;
    fgsc1: TLongEdit;
    fgsc2: TLongEdit;
    MCTBox: TCheckBox;
    fmct1: TLongEdit;
    fmct2: TLongEdit;
    OpenDialog1: TOpenDialog;
    PageControl1: TPageControl;
    procedure Button2Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure CatgenClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure StringGrid3DrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure StringGrid3MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure StringGrid3SelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure StringGrid3SetEditText(Sender: TObject; ACol, ARow: Integer;const Value: String);
    procedure AddCatClick(Sender: TObject);
    procedure DelCatClick(Sender: TObject);
    procedure CDCStarSelClick(Sender: TObject);
    procedure CDCAcceptDirectory(Sender: TObject; var Value: String);
    procedure USNBrightClick(Sender: TObject);
    procedure CDCStarField1Change(Sender: TObject);
    procedure CDCStarField2Change(Sender: TObject);
    procedure CDCStarPathChange(Sender: TObject);
    procedure GCVBoxClick(Sender: TObject);
    procedure IRVarClick(Sender: TObject);
    procedure Fgcv1Change(Sender: TObject);
    procedure Fgcv2Change(Sender: TObject);
    procedure gcv3Change(Sender: TObject);
    procedure WDSboxClick(Sender: TObject);
    procedure Fwds1Change(Sender: TObject);
    procedure Fwds2Change(Sender: TObject);
    procedure wds3Change(Sender: TObject);
    procedure CDCNebSelClick(Sender: TObject);
    procedure CDCNebField1Change(Sender: TObject);
    procedure CDCNebField2Change(Sender: TObject);
    procedure CDCNebPathChange(Sender: TObject);
    procedure CDCNebSelPathClick(Sender: TObject);
    procedure ActivateGCat;
    procedure ShowFov;

  private
    { Private declarations }
    catalogempty, LockChange,LockCatPath,LockActivePath: boolean;
    FApplyConfig: TNotifyEvent;
    FCatGen: Tf_catgen;
    textcolor: TColor; // clWindow replacement hack
    procedure ShowGCat;
    procedure ShowCDCStar;                                
    procedure ShowCDCNeb;
    procedure EditGCatPath(row : integer);
    procedure DeleteGCatRow(p : integer);
  public
    { Public declarations }
    catalog: Tcatalog;
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
    procedure SetLang;
    property onApplyConfig: TNotifyEvent read FApplyConfig write FApplyConfig;
  end;

implementation
{$R *.lfm}

procedure Tf_config_catalog.SetLang;
begin
Caption:=rsCatalog;
Page1.caption:=rsCatalog;
Label37.caption:=rsStarsAndNebu;
addcat.caption:=rsAdd;
delcat.caption:=rsDelete;
Page2.caption:=rsCdCStars;
Label2.caption:=rsCDCStarsCata;
Label65.caption:=rsPm;
Label66.caption:=rsPm;
Label87.caption:=rsPm;
Label16.caption:=rsMin2;
Label28.caption:=rsFieldNumber;
Label17.caption:=rsMax2;
Label27.caption:=rsFilesPath;
Label18.caption:=rsStars;
Label19.caption:=rsVariables;
Label20.caption:=rsDoubles;
USNBright.caption:=rsBrightStars;
IRVar.caption:=rsShowIRVariab;
Page3.caption:=rsCdCNebulae;
Label3.caption:=rsCDCNebulaeCa;
Label22.caption:=rsNebulae;
Label23.caption:=rsGalaxies;
Label24.caption:=rsOpenCluster;
Label25.caption:=rsGlobularClus;
Label26.caption:=rsPlanetaryNeb2;
Label69.caption:=rsGeneral;
Label15.caption:=rsFieldNumber;
Label116.caption:=rsMin2;
Label117.caption:=rsMax2;
Label118.caption:=rsFilesPath;
Label119.caption:=rsDefault;
Label120.caption:=rsUseOnlyCatal;
Page5.caption:=rsOtherSoftwar;
Page4.caption:=rsObsolete;
Label88.caption:=rsCDCObsoleteC;
Label91.caption:=rsReplacedBy+' Tycho-2';
Label92.caption:=rsReplacedBy+' Tycho-2';
Label93.caption:=rsReplacedBy+' UCAC3';
Label95.Caption:=rsReplacedBy+' PGC/LEDA';
Label94.caption:=rsNotAvailable;
Label5.caption:=rsFovNumber;
Button1.caption:=rsOK;
Button2.caption:=rsApply;
Button3.caption:=rsCancel;
Button4.caption:=rsHelp;
LabelWarning.Caption:=rsWarningYouAr2;
if Fcatgen<>nil then Fcatgen.SetLang;
SetHelp(self,hlpCatalog);
end;

constructor Tf_config_catalog.Create(AOwner:TComponent);
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
 PageControl1.ShowTabs:=false;
end;

procedure Tf_config_catalog.FormShow(Sender: TObject);
begin
//textcolor:=clWindow;
textcolor:=clWhite;
LockCatPath:=false;
LockActivePath:=false;
LockChange:=true;
ShowGCat;
ShowCDCStar;
ShowCDCNeb;
ShowFov;
LockChange:=false;
end;

procedure Tf_config_catalog.FormCreate(Sender: TObject);
begin
  textcolor:=0;
  LockChange:=true;
  LockCatPath:=true;
  SetLang;
end;

procedure Tf_config_catalog.FormDestroy(Sender: TObject);
begin
mycsc.Free;
myccat.Free;
mycshr.Free;
mycplot.Free;
mycmain.Free;
if Fcatgen<>nil then Fcatgen.Free;
end;

procedure Tf_config_catalog.FormClose(Sender: TObject;
  var CloseAction: TCloseAction);
begin
  LockChange:=true;
end;

procedure Tf_config_catalog.CatgenClick(Sender: TObject);
begin
if Fcatgen=nil then Fcatgen:=Tf_catgen.create(self);
FormPos(Fcatgen,mouse.CursorPos.x,mouse.CursorPos.y);
Fcatgen.ShowModal;
end;

procedure Tf_config_catalog.Button2Click(Sender: TObject);
begin
  if assigned(FApplyConfig) then FApplyConfig(Self);
end;

procedure Tf_config_catalog.Button4Click(Sender: TObject);
begin
  ShowHelp;
end;

procedure Tf_config_catalog.ShowGCat;
var i,j:integer;
begin
stringgrid3.RowCount:=ccat.GCatnum+1;
stringgrid3.cells[0,0]:='x';
stringgrid3.Columns[0].Title.Caption:=rsCat;
stringgrid3.Columns[1].Title.Caption:=rsMin2;
stringgrid3.Columns[2].Title.Caption:=rsMax2;
stringgrid3.Columns[3].Title.Caption:=rsPath;
CatalogEmpty:=true;
for j:=0 to ccat.GCatnum-1 do begin
  if catalogempty then catalogempty:=false;
  i:=j+1;
  stringgrid3.cells[1,i]:=ccat.GCatLst[j].shortname;
  stringgrid3.cells[2,i]:=formatfloat(f0,ccat.GCatLst[j].min);
  stringgrid3.cells[3,i]:=formatfloat(f0,ccat.GCatLst[j].max);
  stringgrid3.cells[4,i]:=systoutf8(ccat.GCatLst[j].path);
  if ccat.GCatLst[j].actif then stringgrid3.cells[0,i]:='1'
                           else stringgrid3.cells[0,i]:='0';
end;
end;

function changetext(newtext,oldtext: string):string;
begin
  if newtext=oldtext then result:=newtext+blank
     else result:=newtext;
end;

procedure Tf_config_catalog.ShowCDCNeb;
var spec,def,gen: boolean;
begin
sacbox.Checked:=ccat.NebCatDef[sac-BaseNeb];
ngcbox.Checked:=ccat.NebCatDef[ngc-BaseNeb];
lbnbox.Checked:=ccat.NebCatDef[lbn-BaseNeb];
rc3box.Checked:=ccat.NebCatDef[rc3-BaseNeb];
pgcbox.Checked:=ccat.NebCatDef[pgc-BaseNeb];
oclbox.Checked:=ccat.NebCatDef[ocl-BaseNeb];
gcmbox.Checked:=ccat.NebCatDef[gcm-BaseNeb];
gpnbox.Checked:=ccat.NebCatDef[gpn-BaseNeb];
fsac1.Value:=ccat.NebCatField[sac-BaseNeb,1];
fngc1.Value:=ccat.NebCatField[ngc-BaseNeb,1];
flbn1.Value:=ccat.NebCatField[lbn-BaseNeb,1];
frc31.Value:=ccat.NebCatField[rc3-BaseNeb,1];
fpgc1.Value:=ccat.NebCatField[pgc-BaseNeb,1];
focl1.Value:=ccat.NebCatField[ocl-BaseNeb,1];
fgcm1.Value:=ccat.NebCatField[gcm-BaseNeb,1];
fgpn1.Value:=ccat.NebCatField[gpn-BaseNeb,1];
fsac2.Value:=ccat.NebCatField[sac-BaseNeb,2];
fngc2.Value:=ccat.NebCatField[ngc-BaseNeb,2];
flbn2.Value:=ccat.NebCatField[lbn-BaseNeb,2];
frc32.Value:=ccat.NebCatField[rc3-BaseNeb,2];
fpgc2.Value:=ccat.NebCatField[pgc-BaseNeb,2];
focl2.Value:=ccat.NebCatField[ocl-BaseNeb,2];
fgcm2.Value:=ccat.NebCatField[gcm-BaseNeb,2];
fgpn2.Value:=ccat.NebCatField[gpn-BaseNeb,2];
sac3.Text:=changetext(systoutf8(ccat.NebCatPath[sac-BaseNeb]),sac3.Text);
ngc3.Text:=changetext(systoutf8(ccat.NebCatPath[ngc-BaseNeb]),ngc3.Text);
lbn3.Text:=changetext(systoutf8(ccat.NebCatPath[lbn-BaseNeb]),lbn3.Text);
rc33.Text:=changetext(systoutf8(ccat.NebCatPath[rc3-BaseNeb]),rc33.Text);
pgc3.Text:=changetext(systoutf8(ccat.NebCatPath[pgc-BaseNeb]),pgc3.Text);
ocl3.Text:=changetext(systoutf8(ccat.NebCatPath[ocl-BaseNeb]),ocl3.Text);
gcm3.Text:=changetext(systoutf8(ccat.NebCatPath[gcm-BaseNeb]),gcm3.Text);
gpn3.Text:=changetext(systoutf8(ccat.NebCatPath[gpn-BaseNeb]),gpn3.Text);
def:= sacbox.Checked;
gen:=ngcbox.Checked;
spec:=lbnbox.Checked or rc3box.Checked or pgcbox.Checked or oclbox.Checked or gcmbox.Checked or gpnbox.Checked;
LabelWarning.Visible:=(def and gen) or (def and spec) or (gen and spec);
end;

procedure Tf_config_catalog.ShowCDCStar;
begin
bscbox.Checked:=ccat.StarCatDef[bsc-BaseStar];
skybox.Checked:=ccat.StarCatDef[sky2000-BaseStar];
tycbox.Checked:=ccat.StarCatDef[tyc-BaseStar];
ty2box.Checked:=ccat.StarCatDef[tyc2-BaseStar];
ticbox.Checked:=ccat.StarCatDef[tic-BaseStar];
gscfbox.Checked:=ccat.StarCatDef[gscf-BaseStar];
gsccbox.Checked:=ccat.StarCatDef[gscc-BaseStar];
gscbox.Checked:=ccat.StarCatDef[gsc-BaseStar];
usnbox.Checked:=ccat.StarCatDef[usnoa-BaseStar];
usnbright.Checked:=ccat.UseUSNOBrightStars;
mctbox.Checked:=ccat.StarCatDef[microcat-BaseStar];
gcvbox.Checked:=ccat.VarStarCatDef[gcvs-BaseVar];
irvar.Checked:=ccat.UseGSVSIr;
wdsbox.Checked:=ccat.DblStarCatDef[wds-BaseDbl];
dsbasebox.Checked:=ccat.StarCatDef[dsbase-BaseStar];
dstycbox.Checked:=ccat.StarCatDef[dstyc-BaseStar];
dsgscbox.Checked:=ccat.StarCatDef[dsgsc-BaseStar];
fbsc1.Value:=ccat.StarCatField[bsc-BaseStar,1];
fbsc2.Value:=ccat.StarCatField[bsc-BaseStar,2];
fsky1.Value:=ccat.StarCatField[sky2000-BaseStar,1];
fsky2.Value:=ccat.StarCatField[sky2000-BaseStar,2];
ftyc1.Value:=ccat.StarCatField[tyc-BaseStar,1];
ftyc2.Value:=ccat.StarCatField[tyc-BaseStar,2];
fty21.Value:=ccat.StarCatField[tyc2-BaseStar,1];
fty22.Value:=ccat.StarCatField[tyc2-BaseStar,2];
ftic1.Value:=ccat.StarCatField[tic-BaseStar,1];
ftic2.Value:=ccat.StarCatField[tic-BaseStar,2];
fgscf1.Value:=ccat.StarCatField[gscf-BaseStar,1];
fgscf2.Value:=ccat.StarCatField[gscf-BaseStar,2];
fgscc1.Value:=ccat.StarCatField[gscc-BaseStar,1];
fgscc2.Value:=ccat.StarCatField[gscc-BaseStar,2];
fgsc1.Value:=ccat.StarCatField[gsc-BaseStar,1];
fgsc2.Value:=ccat.StarCatField[gsc-BaseStar,2];
fusn1.Value:=ccat.StarCatField[usnoa-BaseStar,1];
fusn2.Value:=ccat.StarCatField[usnoa-BaseStar,2];
fmct1.Value:=ccat.StarCatField[microcat-BaseStar,1];
fmct2.Value:=ccat.StarCatField[microcat-BaseStar,2];
fgcv1.Value:=ccat.VarStarCatField[gcvs-BaseVar,1];
fgcv2.Value:=ccat.VarStarCatField[gcvs-BaseVar,2];
fwds1.Value:=ccat.DblStarCatField[wds-BaseDbl,1];
fwds2.Value:=ccat.DblStarCatField[wds-BaseDbl,2];
dsbase1.Value:=ccat.StarCatField[dsbase-BaseStar,1];
dsbase2.Value:=ccat.StarCatField[dsbase-BaseStar,2];
dstyc1.Value:=ccat.StarCatField[dstyc-BaseStar,1];
dstyc2.Value:=ccat.StarCatField[dstyc-BaseStar,2];
dsgsc1.Value:=ccat.StarCatField[dsgsc-BaseStar,1];
dsgsc2.Value:=ccat.StarCatField[dsgsc-BaseStar,2];
bsc3.Text:=changetext(systoutf8(ccat.StarCatPath[bsc-BaseStar]),bsc3.Text);
sky3.Text:=changetext(systoutf8(ccat.StarCatPath[sky2000-BaseStar]),sky3.Text);
tyc3.Text:=changetext(systoutf8(ccat.StarCatPath[tyc-BaseStar]),tyc3.Text);
ty23.Text:=changetext(systoutf8(ccat.StarCatPath[tyc2-BaseStar]),ty23.Text);
tic3.Text:=changetext(systoutf8(ccat.StarCatPath[tic-BaseStar]),tic3.Text);
gscf3.Text:=changetext(systoutf8(ccat.StarCatPath[gscf-BaseStar]),gscf3.Text);
gscc3.Text:=changetext(systoutf8(ccat.StarCatPath[gscc-BaseStar]),gscc3.Text);
gsc3.Text:=changetext(systoutf8(ccat.StarCatPath[gsc-BaseStar]),gsc3.Text);
usn3.Text:=changetext(systoutf8(ccat.StarCatPath[usnoa-BaseStar]),usn3.Text);
mct3.Text:=changetext(systoutf8(ccat.StarCatPath[microcat-BaseStar]),mct3.Text);
gcv3.Text:=changetext(systoutf8(ccat.VarStarCatPath[gcvs-BaseVar]),gcv3.Text);
wds3.Text:=changetext(systoutf8(ccat.DblStarCatPath[wds-BaseDbl]),wds3.Text);
dsbase3.Text:=changetext(systoutf8(ccat.StarCatPath[dsbase-BaseStar]),dsbase3.Text);
dstyc3.Text:=changetext(systoutf8(ccat.StarCatPath[dstyc-BaseStar]),dstyc3.Text);
dsgsc3.Text:=changetext(systoutf8(ccat.StarCatPath[dsgsc-BaseStar]),dsgsc3.Text);
end;

procedure Tf_config_catalog.ShowFov;
begin
fw0.Caption:='0: 0 - '+formatfloat(f1s,cshr.fieldnum[0]);
fw1.Caption:='1: '+formatfloat(f1s,cshr.fieldnum[0])+' - '+formatfloat(f1s,cshr.fieldnum[1]);
fw2.Caption:='2: '+formatfloat(f1s,cshr.fieldnum[1])+' - '+formatfloat(f1s,cshr.fieldnum[2]);
fw3.Caption:='3: '+formatfloat(f1s,cshr.fieldnum[2])+' - '+formatfloat(f1s,cshr.fieldnum[3]);
fw4.Caption:='4: '+formatfloat(f1s,cshr.fieldnum[3])+' - '+formatfloat(f1s,cshr.fieldnum[4]);
fw5.Caption:='5: '+formatfloat(f1s,cshr.fieldnum[4])+' - '+formatfloat(f1s,cshr.fieldnum[5]);
fw6.Caption:='6: '+formatfloat(f1s,cshr.fieldnum[5])+' - '+formatfloat(f1s,cshr.fieldnum[6]);
fw7.Caption:='7: '+formatfloat(f1s,cshr.fieldnum[6])+' - '+formatfloat(f1s,cshr.fieldnum[7]);
fw8.Caption:='8: '+formatfloat(f1s,cshr.fieldnum[7])+' - '+formatfloat(f1s,cshr.fieldnum[8]);
fw9.Caption:='9: '+formatfloat(f1s,cshr.fieldnum[8])+' - '+formatfloat(f1s,cshr.fieldnum[9]);
fw10.Caption:='10: '+formatfloat(f1s,cshr.fieldnum[9])+' - '+formatfloat(f1s,cshr.fieldnum[10]);
end;

procedure Tf_config_catalog.StringGrid3DrawCell(Sender: TObject; ACol,
  ARow: Integer; Rect: TRect; State: TGridDrawState);
begin
with Sender as TStringGrid do begin
if (Acol=0)and(Arow>0) then begin
  Canvas.Brush.style := bssolid;
  if (cells[acol,arow]='1')then begin
    Canvas.Brush.Color := clLime;
    Canvas.FillRect(Rect);
  end else begin
    Canvas.Brush.Color := clRed;
    Canvas.FillRect(Rect);
  end;
end {else if (Acol=1)and(Arow>0) then begin
  if not fileexists(slash(cells[4,arow])+cells[1,arow]+'.hdr') then begin
    Canvas.Pen.Color := clRed;
    Canvas.Brush.style := bsclear;
    Canvas.rectangle(Rect);
  end else begin
    Canvas.Pen.Color := clWindow;
    Canvas.Brush.style := bsSolid;
    Canvas.rectangle(Rect);
  end;
end else if (Acol=2)and(Arow>0) then begin
  if not IsNumber(cells[acol,arow]) then begin
    Canvas.Pen.Color := clRed;
    Canvas.Brush.style := bsclear;
    Canvas.rectangle(Rect);
  end else begin
    Canvas.Pen.Color := clWindow;
    Canvas.Brush.style := bsSolid;
    Canvas.rectangle(Rect);
  end;
end else if (Acol=3)and(Arow>0) then begin
  if not IsNumber(cells[acol,arow]) then begin
    Canvas.Pen.Color := clRed;
    Canvas.Brush.style := bsclear;
    Canvas.rectangle(Rect);
  end else begin
    Canvas.Pen.Color := clWindow;
    Canvas.Brush.style := bsSolid;
    Canvas.rectangle(Rect);
  end;
end else if (Acol=4)and(Arow>0) then begin
  if not fileexists(slash(cells[4,arow])+cells[1,arow]+'.hdr') then begin
    Canvas.Pen.Color := clRed;
    Canvas.Brush.style := bsclear;
    Canvas.rectangle(Rect);
  end else begin
    Canvas.Pen.Color := clWindow;
    Canvas.Brush.style := bsSolid;
    Canvas.rectangle(Rect);
  end;
end }else if (Acol=5)and(Arow>0) then begin
    Canvas.draw(Rect.left,Rect.top,DirOpenImg.Picture.Bitmap);
end {else if (Arow=0) then begin
    Canvas.Pen.Color := clBtnFace;
    Canvas.Brush.style := bsSolid;
    Canvas.rectangle(Rect);
end else begin
    Canvas.Pen.Color := clWindow;
    Canvas.Brush.style := bsSolid;
    Canvas.rectangle(Rect);
end; }
end;
end;

procedure Tf_config_catalog.StringGrid3MouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var col,row:integer;
begin
StringGrid3.MouseToCell(X, Y, Col, Row);
if row=0 then exit;
case col of
0 : begin
    if stringgrid3.Cells[col,row]='1' then stringgrid3.Cells[col,row]:='0'
       else
       if fileexistsutf8(slash(stringgrid3.cells[4,row])+stringgrid3.cells[1,row]+'.hdr') then stringgrid3.Cells[col,row]:='1'
          else  stringgrid3.Cells[col,row]:='0';
    end;
5 : begin
    EditGCatPath(row);
    end;
end;
end;

Procedure Tf_config_catalog.EditGCatPath(row : integer);
var buf : string;
    p : integer;
begin
    chdir(appdir);
    if trim(stringgrid3.Cells[4,row])<>'' then opendialog1.InitialDir:=ExpandFileName(stringgrid3.Cells[4,row])
                                          else opendialog1.InitialDir:=slash(appdir)+'cat';
    if trim(stringgrid3.Cells[1,row])<>'' then opendialog1.filename:=trim(stringgrid3.Cells[1,row])+'.hdr';
    opendialog1.Filter:='Catalog header|*.hdr';
    opendialog1.DefaultExt:='.hdr';
    try
    if opendialog1.execute then begin
       buf:=extractfilename(opendialog1.FileName);
       p:=pos('.',buf);
       stringgrid3.Cells[1,row]:=copy(buf,1,p-1);
       stringgrid3.Cells[4,row]:=extractfilepath(opendialog1.filename);
       stringgrid3.Cells[2,row]:='0';
       stringgrid3.Cells[3,row]:=catalog.GetMaxField(stringgrid3.Cells[4,row],stringgrid3.Cells[1,row]);
    end;
    finally
    chdir(appdir);
    end;
end;

procedure Tf_config_catalog.StringGrid3SelectCell(Sender: TObject; ACol,
  ARow: Integer; var CanSelect: Boolean);
begin
if Acol=5 then canselect:=false else canselect:=true;
end;

procedure Tf_config_catalog.StringGrid3SetEditText(Sender: TObject; ACol,
  ARow: Integer; const Value: String);
begin
if (Acol=4)and(Arow>0) then
  if not fileexists(slash(value)+StringGrid3.cells[1,arow]+'.hdr') then begin
    StringGrid3.Canvas.Brush.Color := clRed;
    StringGrid3.Canvas.FillRect(StringGrid3.CellRect(ACol, ARow));
    StringGrid3.cells[0,arow]:='0';
  end;
if (Acol=1)and(Arow>0) then
  if not fileexists(slash(StringGrid3.cells[4,arow])+value+'.hdr') then begin
    StringGrid3.Canvas.Brush.Color := clRed;
    StringGrid3.Canvas.FillRect(StringGrid3.CellRect(ACol, ARow));
    StringGrid3.cells[0,arow]:='0';
  end;
if ((Acol=2)or(Acol=3))and(Arow>0)and(value>'') then begin
  if not IsNumber(value) then begin
    StringGrid3.Canvas.Brush.Color := clRed;
    StringGrid3.Canvas.FillRect(StringGrid3.CellRect(ACol, ARow));
    StringGrid3.cells[0,arow]:='0';
  end;
end;
end;

procedure Tf_config_catalog.AddCatClick(Sender: TObject);
begin
catalogempty:=false;
stringgrid3.rowcount:=stringgrid3.rowcount+1;
stringgrid3.cells[2,stringgrid3.rowcount-1]:='0';
stringgrid3.cells[3,stringgrid3.rowcount-1]:='10';
EditGCatPath(stringgrid3.rowcount-1);
end;

procedure Tf_config_catalog.DelCatClick(Sender: TObject);
var p : integer;
begin
p:=stringgrid3.selection.top;
stringgrid3.cells[1,p]:='';
stringgrid3.cells[2,p]:='';
stringgrid3.cells[3,p]:='';
stringgrid3.cells[4,p]:='';
DeleteGCatRow(p);
end;

Procedure Tf_config_catalog.DeleteGCatRow(p : integer);
var i : integer;
begin
if p<1 then exit;
if stringgrid3.rowcount=2 then begin
 stringgrid3.cells[0,1]:='';
 stringgrid3.cells[1,1]:='';
 stringgrid3.cells[2,1]:='';
 stringgrid3.cells[3,1]:='';
 stringgrid3.cells[4,1]:='';
 CatalogEmpty:=true;
end else begin
for i:=p to stringgrid3.RowCount-2 do begin
 stringgrid3.cells[0,i]:=stringgrid3.cells[0,i+1];
 stringgrid3.cells[1,i]:=stringgrid3.cells[1,i+1];
 stringgrid3.cells[2,i]:=stringgrid3.cells[2,i+1];
 stringgrid3.cells[3,i]:=stringgrid3.cells[3,i+1];
 stringgrid3.cells[4,i]:=stringgrid3.cells[4,i+1];
end;
stringgrid3.RowCount:=stringgrid3.RowCount-1;
end;
end;

procedure Tf_config_catalog.CDCStarSelClick(Sender: TObject);
begin
if sender is TCheckBox then with sender as TCheckBox do begin
  ccat.StarCatDef[tag]:=Checked;
  ShowCDCStar;
end;
end;

procedure Tf_config_catalog.CDCAcceptDirectory(Sender: TObject;
  var Value: String);
begin
{$ifdef darwin}    { TODO : Remove when onChange work correctly on Mac OS X }
  if LockActivePath then exit;
  LockActivePath:=true;
  TDirectoryEdit(sender).Text:=value;
  CDCStarPathChange(sender);
  LockActivePath:=false;
{$endif}
end;

procedure Tf_config_catalog.USNBrightClick(Sender: TObject);
begin
ccat.UseUSNOBrightStars:=usnbright.Checked;
end;

procedure Tf_config_catalog.CDCStarField1Change(Sender: TObject);
begin
if LockChange then exit;
if sender is TLongEdit then with sender as TLongEdit do begin
  ccat.StarCatField[tag,1]:=Value;
end;
end;

procedure Tf_config_catalog.CDCStarField2Change(Sender: TObject);
begin
if LockChange then exit;
if sender is TLongEdit then with sender as TLongEdit do begin
  ccat.StarCatField[tag,2]:=Value;
end;
end;

procedure Tf_config_catalog.CDCStarPathChange(Sender: TObject);
begin
if LockCatPath then exit;
try
LockCatPath:=true;
if sender is TDirectoryEdit then with sender as TDirectoryEdit do begin
  Text:=trim(Text);
  ccat.StarCatPath[tag]:=utf8tosys(Text);
  if ccat.StarCatDef[tag] then
     if catalog.checkpath(tag+BaseStar,utf8tosys(Text))
        then color:=textcolor
        else color:=clRed
     else color:=textcolor;
end;
finally
LockCatPath:=false;
end;
end;

procedure Tf_config_catalog.GCVBoxClick(Sender: TObject);
begin
ccat.VarStarCatDef[gcvs-BaseVar]:=GCVBox.Checked;
ShowCDCStar;
end;

procedure Tf_config_catalog.IRVarClick(Sender: TObject);
begin
ccat.UseGSVSIr:=irvar.Checked;
end;

procedure Tf_config_catalog.Fgcv1Change(Sender: TObject);
begin
if LockChange then exit;
ccat.VarStarCatField[gcvs-BaseVar,1]:=Fgcv1.Value;
end;

procedure Tf_config_catalog.Fgcv2Change(Sender: TObject);
begin
if LockChange then exit;
ccat.VarStarCatField[gcvs-BaseVar,2]:=Fgcv2.Value;
end;

procedure Tf_config_catalog.gcv3Change(Sender: TObject);
begin
if LockCatPath then exit;
try
LockCatPath:=true;
  gcv3.Text:=trim(gcv3.Text);
  ccat.VarStarCatPath[gcvs-BaseVar]:=utf8tosys(gcv3.Text);
  if ccat.VarStarCatDef[gcvs-BaseVar] then
     if catalog.checkpath(gcvs,utf8tosys(gcv3.text))
        then gcv3.color:=textcolor
        else gcv3.color:=clRed
     else gcv3.color:=textcolor;
finally
LockCatPath:=false;
end;
end;

procedure Tf_config_catalog.WDSboxClick(Sender: TObject);
begin
ccat.DblStarCatDef[wds-BaseDbl]:=WDSbox.Checked;
ShowCDCStar;
end;

procedure Tf_config_catalog.Fwds1Change(Sender: TObject);
begin
if LockChange then exit;
ccat.DblStarCatField[wds-BaseDbl,1]:=Fwds1.Value;
end;

procedure Tf_config_catalog.Fwds2Change(Sender: TObject);
begin
if LockChange then exit;
ccat.DblStarCatField[wds-BaseDbl,2]:=Fwds2.Value;
end;

procedure Tf_config_catalog.wds3Change(Sender: TObject);
begin
if LockCatPath then exit;
try
LockCatPath:=true;
  wds3.Text:=trim(wds3.Text);
  ccat.DblStarCatPath[wds-BaseDbl]:=utf8tosys(wds3.Text);
  if ccat.DblStarCatDef[wds-BaseDbl] then
     if catalog.checkpath(wds,utf8tosys(wds3.text))
        then wds3.color:=textcolor
        else wds3.color:=clRed
     else wds3.color:=textcolor;
finally
LockCatPath:=false;
end;
end;

procedure Tf_config_catalog.CDCNebSelClick(Sender: TObject);
begin
if sender is TCheckBox then with sender as TCheckBox do begin
  ccat.NebCatDef[tag]:=Checked;
  ShowCDCNeb;
end;
end;

procedure Tf_config_catalog.CDCNebField1Change(Sender: TObject);
begin
if LockChange then exit;
if sender is TLongEdit then with sender as TLongEdit do begin
  ccat.NebCatField[tag,1]:=Value;
end;
end;

procedure Tf_config_catalog.CDCNebField2Change(Sender: TObject);
begin
if LockChange then exit;
if sender is TLongEdit then with sender as TLongEdit do begin
  ccat.NebCatField[tag,2]:=Value;
end;
end;

procedure Tf_config_catalog.CDCNebPathChange(Sender: TObject);
begin
if LockCatPath then exit;
try
LockCatPath:=true;
if sender is TDirectoryEdit then with sender as TDirectoryEdit do begin
  Text:=trim(Text);
  ccat.NebCatPath[tag]:=utf8tosys(Text);
  if ccat.NebCatDef[tag] then
     if catalog.checkpath(tag+BaseNeb,utf8tosys(text))
        then color:=textcolor
        else color:=clRed
     else color:=textcolor;
end;
finally
LockCatPath:=false;
end;
end;

procedure Tf_config_catalog.CDCNebSelPathClick(Sender: TObject);
begin

end;

procedure Tf_config_catalog.ActivateGCat;
var i,x,v:integer;
begin
ccat.GCatNum:=stringgrid3.RowCount-1;
SetLength(ccat.GCatLst,ccat.GCatNum);
for i:=0 to ccat.GCatNum-1 do begin
   ccat.GCatLst[i].shortname:=stringgrid3.cells[1,i+1];
   ccat.GCatLst[i].path:=utf8tosys(stringgrid3.cells[4,i+1]);
   val(stringgrid3.cells[2,i+1],x,v);
   if v=0 then ccat.GCatLst[i].min:=x
          else ccat.GCatLst[i].min:=0;
   val(stringgrid3.cells[3,i+1],x,v);
   if v=0 then ccat.GCatLst[i].max:=x
          else ccat.GCatLst[i].max:=0;
   ccat.GCatLst[i].Actif:=stringgrid3.cells[0,i+1]='1';
   ccat.GCatLst[i].magmax:=0;
   ccat.GCatLst[i].name:='';
   ccat.GCatLst[i].cattype:=0;
end;
end;

end.
