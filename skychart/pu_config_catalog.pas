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

uses  u_constant, u_util, cu_catalog,
  LCLIntf, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, enhedits, Grids, Buttons, ComCtrls, LResources,
  EditBtn;

type

  { Tf_config_catalog }

  Tf_config_catalog = class(TForm)
    bsc3: TDirectoryEdit;
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
    Label5: TLabel;
    fw10: TLabel;
    ocl3: TDirectoryEdit;
    gcm3: TDirectoryEdit;
    gpn3: TDirectoryEdit;
    FOVPanel: TPanel;
    pgc3: TDirectoryEdit;
    rc33: TDirectoryEdit;
    lbn3: TDirectoryEdit;
    ngc3: TDirectoryEdit;
    sac3: TDirectoryEdit;
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
    Page1: TPage;
    Page2: TPage;
    Page3: TPage;
    Page4: TPage;
    Page5: TPage;
    Label1: TLabel;
    Label37: TLabel;
    addcat: TBitBtn;
    delcat: TBitBtn;
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
    Bevel5: TBevel;
    Bevel3: TBevel;
    Bevel4: TBevel;
    Label3: TLabel;
    Label22: TLabel;
    Label23: TLabel;
    Label24: TLabel;
    Label25: TLabel;
    Label26: TLabel;
    Label69: TLabel;
    Label15: TLabel;
    Label116: TLabel;
    Label117: TLabel;
    Label118: TLabel;
    Label119: TLabel;
    Label120: TLabel;
    NGCbox: TCheckBox;
    RC3box: TCheckBox;
    OCLbox: TCheckBox;
    GCMbox: TCheckBox;
    GPNbox: TCheckBox;
    LBNbox: TCheckBox;
    PGCBox: TCheckBox;
    SACbox: TCheckBox;
    fngc1: TLongEdit;
    fngc2: TLongEdit;
    fsac1: TLongEdit;
    fsac2: TLongEdit;
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
    Label88: TLabel;
    Label67: TLabel;
    Label91: TLabel;
    Label92: TLabel;
    Label93: TLabel;
    Label94: TLabel;
    Label90: TLabel;
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
    Label4: TLabel;
    Label52: TLabel;
    Label71: TLabel;
    Label64: TLabel;
    StringGrid1: TStringGrid;
    Cat1Box: TCheckBox;
    Edit1: TEdit;
    Cat2Box: TCheckBox;
    StringGrid2: TStringGrid;
    OpenDialog1: TOpenDialog;
    Notebook1: TNotebook;
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
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
    catalogempty, LockChange,LockCatPath: boolean;
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

implementation



constructor Tf_config_catalog.Create(AOwner:TComponent);
begin
 csc:=@mycsc;
 ccat:=@myccat;
 cshr:=@mycshr;
 cplot:=@mycplot;
 cmain:=@mycmain;
 inherited Create(AOwner);
 Notebook1.ShowTabs:=false;
end;

procedure Tf_config_catalog.FormShow(Sender: TObject);
begin
LockCatPath:=false;
LockChange:=true;
ShowGCat;
ShowCDCStar;
ShowCDCNeb;
ShowFov;
LockChange:=false;
end;

procedure Tf_config_catalog.FormCreate(Sender: TObject);
begin
  LockChange:=true;
  LockCatPath:=true;
end;

procedure Tf_config_catalog.FormClose(Sender: TObject;
  var CloseAction: TCloseAction);
begin
  LockChange:=true;
end;

procedure Tf_config_catalog.ShowGCat;
var i,j:integer;
begin
stringgrid3.RowCount:=2;
stringgrid3.cells[0,0]:='x';
stringgrid3.cells[1,0]:='Cat.';
stringgrid3.cells[2,0]:='Min.';
stringgrid3.cells[3,0]:='Max.';
stringgrid3.cells[4,0]:='Path';
stringgrid3.cells[0,1]:='';
stringgrid3.cells[1,1]:='';
stringgrid3.cells[2,1]:='';
stringgrid3.cells[3,1]:='';
stringgrid3.cells[4,1]:='';
CatalogEmpty:=true;
for j:=0 to ccat.GCatnum-1 do begin
  if catalogempty then catalogempty:=false
                  else stringgrid3.rowcount:=stringgrid3.rowcount+1;
  i:=stringgrid3.rowcount-1;
  stringgrid3.cells[1,i]:=ccat.GCatLst[j].shortname;
  stringgrid3.cells[2,i]:=floattostr(ccat.GCatLst[j].min);
  stringgrid3.cells[3,i]:=floattostr(ccat.GCatLst[j].max);
  stringgrid3.cells[4,i]:=ccat.GCatLst[j].path;
  if ccat.GCatLst[j].actif then stringgrid3.cells[0,i]:='1'
                           else stringgrid3.cells[0,i]:='0';
end;
end;

procedure Tf_config_catalog.ShowCDCNeb;
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
sac3.Text:=ccat.NebCatPath[sac-BaseNeb]+blank;
ngc3.Text:=ccat.NebCatPath[ngc-BaseNeb]+blank;
lbn3.Text:=ccat.NebCatPath[lbn-BaseNeb]+blank;
rc33.Text:=ccat.NebCatPath[rc3-BaseNeb]+blank;
pgc3.Text:=ccat.NebCatPath[pgc-BaseNeb]+blank;
ocl3.Text:=ccat.NebCatPath[ocl-BaseNeb]+blank;
gcm3.Text:=ccat.NebCatPath[gcm-BaseNeb]+blank;
gpn3.Text:=ccat.NebCatPath[gpn-BaseNeb]+blank;
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
bsc3.Text:=ccat.StarCatPath[bsc-BaseStar]+blank;
sky3.Text:=ccat.StarCatPath[sky2000-BaseStar]+blank;
tyc3.Text:=ccat.StarCatPath[tyc-BaseStar]+blank;
ty23.Text:=ccat.StarCatPath[tyc2-BaseStar]+blank;
tic3.Text:=ccat.StarCatPath[tic-BaseStar]+blank;
gscf3.Text:=ccat.StarCatPath[gscf-BaseStar]+blank;
gscc3.Text:=ccat.StarCatPath[gscc-BaseStar]+blank;
gsc3.Text:=ccat.StarCatPath[gsc-BaseStar]+blank;
usn3.Text:=ccat.StarCatPath[usnoa-BaseStar]+blank;
mct3.Text:=ccat.StarCatPath[microcat-BaseStar]+blank;
gcv3.Text:=ccat.VarStarCatPath[gcvs-BaseVar]+blank;
wds3.Text:=ccat.DblStarCatPath[wds-BaseDbl]+blank;
dsbase3.Text:=ccat.StarCatPath[dsbase-BaseStar]+blank;
dstyc3.Text:=ccat.StarCatPath[dstyc-BaseStar]+blank;
dsgsc3.Text:=ccat.StarCatPath[dsgsc-BaseStar]+blank;
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
end else if (Acol=1)and(Arow>0) then begin
  if not fileexists(slash(cells[4,arow])+cells[1,arow]+'.hdr') then begin
    Canvas.Pen.Color := clRed;
    Canvas.Brush.style := bsclear;
    Canvas.rectangle(Rect);
    cells[0,arow]:='0';
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
    cells[0,arow]:='0';
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
    cells[0,arow]:='0';
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
    cells[0,arow]:='0';
  end else begin
    Canvas.Pen.Color := clWindow;
    Canvas.Brush.style := bsSolid;
    Canvas.rectangle(Rect);
  end;
end else if (Acol=5)and(Arow>0) then begin
    Canvas.draw(Rect.left,Rect.top,DirOpenImg.Picture.Bitmap);
end else if (Arow=0) then begin
    Canvas.Pen.Color := clBtnFace;
    Canvas.Brush.style := bsSolid;
    Canvas.rectangle(Rect);
end else begin
    Canvas.Pen.Color := clWindow;
    Canvas.Brush.style := bsSolid;
    Canvas.rectangle(Rect);
end;
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
       if fileexists(slash(stringgrid3.cells[4,row])+stringgrid3.cells[1,row]+'.hdr') then stringgrid3.Cells[col,row]:='1'
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
    if trim(stringgrid3.Cells[4,row])<>'' then opendialog1.InitialDir:=stringgrid3.Cells[4,row]
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
  ccat.StarCatPath[tag]:=Text;
  if ccat.StarCatDef[tag] then
     if catalog.checkpath(tag+BaseStar,Text)
        then color:=clWindow
        else color:=clRed
     else color:=clWindow;
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
  ccat.VarStarCatPath[gcvs-BaseVar]:=gcv3.Text;
  if ccat.VarStarCatDef[gcvs-BaseVar] then
     if catalog.checkpath(gcvs,gcv3.text)
        then gcv3.color:=clWindow
        else gcv3.color:=clRed
     else gcv3.color:=clWindow;
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
  ccat.DblStarCatPath[wds-BaseDbl]:=wds3.Text;
  if ccat.DblStarCatDef[wds-BaseDbl] then
     if catalog.checkpath(wds,wds3.text)
        then wds3.color:=clWindow
        else wds3.color:=clRed
     else wds3.color:=clWindow;
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
if sender is TEdit then with sender as TEdit do begin
  Text:=trim(Text);
  ccat.NebCatPath[tag]:=Text;
  if ccat.NebCatDef[tag] then
     if catalog.checkpath(tag+BaseNeb,text)
        then color:=clWindow
        else color:=clRed
     else color:=clWindow;
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
   ccat.GCatLst[i].path:=stringgrid3.cells[4,i+1];
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


initialization
  {$i pu_config_catalog.lrs}

end.
