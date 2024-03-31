unit fu_config_catalog;

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
Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
}

interface

uses
  u_ccdconfig, u_help, u_translation, u_constant, u_util, cu_catalog, pu_catgen,
  pu_catgenadv, pu_progressbar, LazUTF8, LazFileUtils, pu_voconfig,
  Math, LCLIntf, SysUtils, UScaleDPI,
  Classes, Graphics, Controls, Forms, Dialogs, ExtCtrls, StdCtrls, enhedits,
  downloaddialog, Grids, Buttons, ComCtrls, LResources, EditBtn, LazHelpHTML_fix;

type

  TSendVoTable = procedure(client, tname, tid, url: string) of object;

  { Tf_config_catalog }

  Tf_config_catalog = class(TFrame)
    addobj: TButton;
    addcat: TButton;
    Button1: TButton;
    ButtonInstallCat: TButton;
    Button5: TButton;
    Button6: TButton;
    Button7: TButton;
    Button8: TButton;
    Button9: TButton;
    ButtonInstallCat1: TButton;
    ButtonInstallCat2: TButton;
    CatalogGridLin: TStringGrid;
    CatalogGridNeb: TStringGrid;
    CatalogGridDbl: TStringGrid;
    CatalogGridVar: TStringGrid;
    CatalogGridStar: TStringGrid;
    fsac1: TLongEdit;
    fsac2: TLongEdit;
    Image1: TImage;
    Image2: TImage;
    Image3: TImage;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label99: TLabel;
    LabelNewCat: TLabel;
    Label98: TLabel;
    OngcBox: TCheckBox;
    frc31: TLongEdit;
    frc32: TLongEdit;
    Fgaia1: TLongEdit;
    Fgaia2: TLongEdit;
    hnName: TComboBox;
    hn290Box: TCheckBox;
    hnbase1: TLongEdit;
    hnbase2: TLongEdit;
    hnbase3: TDirectoryEdit;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    Label119: TLabel;
    Label120: TLabel;
    Label122: TLabel;
    Label21: TLabel;
    Label7: TLabel;
    Label92: TLabel;
    Label95: TLabel;
    PageControlGCat: TPageControl;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    Panel5: TPanel;
    Panel6: TPanel;
    Panel7: TPanel;
    Panel8: TPanel;
    rc33: TDirectoryEdit;
    RC3box: TCheckBox;
    sac3: TDirectoryEdit;
    SacBox: TCheckBox;
    sh2box: TCheckBox;
    drkbox: TCheckBox;
    ColorDialog1: TColorDialog;
    ComboBox1: TComboBox;
    delcat: TButton;
    CatgenButton: TButton;
    delobj: TButton;
    DownloadDialog1: TDownloadDialog;
    fgcm1: TLongEdit;
    fgcm2: TLongEdit;
    fgpn1: TLongEdit;
    fgpn2: TLongEdit;
    flbn1: TLongEdit;
    flbn2: TLongEdit;
    fsh21: TLongEdit;
    fsh22: TLongEdit;
    fdrk1: TLongEdit;
    fdrk2: TLongEdit;
    fngc1: TLongEdit;
    fngc2: TLongEdit;
    focl1: TLongEdit;
    focl2: TLongEdit;
    fpgc1: TLongEdit;
    fpgc2: TLongEdit;
    Fsky1: TLongEdit;
    Fsky2: TLongEdit;
    Fdef1: TLongEdit;
    Fdef2: TLongEdit;
    funb1: TLongEdit;
    funb2: TLongEdit;
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
    ImageList1: TImageList;
    Label121: TLabel;
    Label4: TLabel;
    Label6: TLabel;
    Label96: TLabel;
    LabelDownload: TLabel;
    sh23: TDirectoryEdit;
    drk3: TDirectoryEdit;
    maxrows: TLongEdit;
    Label1: TLabel;
    LabelWarning: TLabel;
    Label22: TLabel;
    Label23: TLabel;
    Label24: TLabel;
    Label25: TLabel;
    Label26: TLabel;
    Label5: TLabel;
    fw10: TLabel;
    lbn3: TDirectoryEdit;
    LBNbox: TCheckBox;
    ngc3: TDirectoryEdit;
    FOVPanel: TPanel;
    ocl3: TDirectoryEdit;
    OCLbox: TCheckBox;
    OpenDialog2: TOpenDialog;
    Page5: TTabSheet;
    PanelDef: TPanel;
    PanelSpec: TPanel;
    pgc3: TDirectoryEdit;
    PGCBox: TCheckBox;
    Page1a: TTabSheet;
    SaveDialog1: TSaveDialog;
    sky3: TDirectoryEdit;
    SKYbox: TCheckBox;
    StringGrid1: TStringGrid;
    StringGrid4: TStringGrid;
    Page1b: TTabSheet;
    def3: TDirectoryEdit;
    DefBox: TCheckBox;
    gaia3: TDirectoryEdit;
    GAIABox: TCheckBox;
    Page4b: TTabSheet;
    TabSheetGcatStar: TTabSheet;
    TabSheetGcatVar: TTabSheet;
    TabSheetGcatDbl: TTabSheet;
    TabSheetGcatNeb: TTabSheet;
    TabSheetGcatLin: TTabSheet;
    tyc3: TDirectoryEdit;
    tic3: TDirectoryEdit;
    gsc3: TDirectoryEdit;
    mct3: TDirectoryEdit;
    unb3: TDirectoryEdit;
    UNBbox: TCheckBox;
    dsgsc3: TDirectoryEdit;
    dstyc3: TDirectoryEdit;
    dsbase3: TDirectoryEdit;
    usn3: TDirectoryEdit;
    gscc3: TDirectoryEdit;
    gscf3: TDirectoryEdit;
    ty23: TDirectoryEdit;
    MainPanel: TPanel;
    Page1: TTabSheet;
    Page2: TTabSheet;
    Page3: TTabSheet;
    Page4: TTabSheet;
    Label37: TLabel;
    Label2: TLabel;
    Label16: TLabel;
    Label28: TLabel;
    Label17: TLabel;
    Label27: TLabel;
    Label18: TLabel;
    Label19: TLabel;
    Label20: TLabel;
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
    Label3: TLabel;
    Label15: TLabel;
    Label116: TLabel;
    Label117: TLabel;
    Label118: TLabel;
    Label88: TLabel;
    Label91: TLabel;
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
    procedure addobjClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure ButtonInstallCatClick(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure Button8Click(Sender: TObject);
    procedure Button9Click(Sender: TObject);
    procedure CatgenClick(Sender: TObject);
    procedure delobjClick(Sender: TObject);
    procedure hnNameChange(Sender: TObject);
    procedure maxrowsChange(Sender: TObject);
    procedure PageControl1Change(Sender: TObject);
    procedure PageControl1Changing(Sender: TObject; var AllowChange: boolean);
    procedure StringGrid1DrawCell(Sender: TObject; aCol, aRow: integer;
      aRect: TRect; aState: TGridDrawState);
    procedure StringGrid1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: integer);
    procedure StringGrid1SelectCell(Sender: TObject; aCol, aRow: integer;
      var CanSelect: boolean);
    procedure CatalogGridDrawCell(Sender: TObject; ACol, ARow: integer;
      Rect: TRect; State: TGridDrawState);
    procedure CatalogGridMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: integer);
    procedure CatalogGridSelectCell(Sender: TObject; ACol, ARow: integer;
      var CanSelect: boolean);
    procedure CatalogGridSetEditText(Sender: TObject; ACol, ARow: integer;
      const Value: string);
    procedure AddCatClick(Sender: TObject);
    procedure DelCatClick(Sender: TObject);
    procedure CDCStarSelClick(Sender: TObject);
    procedure CDCAcceptDirectory(Sender: TObject; var Value: string);
    procedure StringGrid4DrawCell(Sender: TObject; aCol, aRow: integer;
      aRect: TRect; aState: TGridDrawState);
    procedure StringGrid4MouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: integer);
    procedure StringGrid4MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: integer);
    procedure StringGrid4SelectCell(Sender: TObject; aCol, aRow: integer;
      var CanSelect: boolean);
    procedure USNBrightClick(Sender: TObject);
    procedure CDCStarField1Change(Sender: TObject);
    procedure CDCStarField2Change(Sender: TObject);
    procedure CDCStarPathChange(Sender: TObject);
    procedure CDCNebSelClick(Sender: TObject);
    procedure CDCNebField1Change(Sender: TObject);
    procedure CDCNebField2Change(Sender: TObject);
    procedure CDCNebPathChange(Sender: TObject);
    procedure ActivateGCat;
    procedure ActivateUserObjects;
    procedure ShowFov;

  private
    { Private declarations }
    HintX, HintY: integer;
    catalogempty, LockChange, LockCatPath, LockActivePath: boolean;
    FApplyConfig,FInstallCatalog: TNotifyEvent;
    FSendVoTable: TSendVoTable;
    FCatGen: Tf_catgen;
    textcolor: TColor;
    procedure ShowGCat;
    procedure ShowCDCStar;
    procedure ShowCDCNeb;
    procedure ShowVO;
    procedure ShowUserObjects;
    procedure ReloadVO(fn: string);
    procedure ReloadCat(path, cat: string);
    function SelectGCat(var path, shortname: string): boolean;
    procedure EditGCatPath(grid: TStringGrid; row: integer);
    procedure DeleteGCatRow(grid: TStringGrid; p: integer);
    procedure DeleteObjRow(p: integer);
    procedure ReloadFeedback(txt: string);
    procedure Upd290List(path: string);
  public
    { Public declarations }
    catalog: Tcatalog;
    mycsc: Tconf_skychart;
    myccat: Tconf_catalog;
    mycshr: Tconf_shared;
    mycplot: Tconf_plot;
    mycmain: Tconf_main;
    csc: Tconf_skychart;
    ccat: Tconf_catalog;
    cshr: Tconf_shared;
    cplot: Tconf_plot;
    cmain: Tconf_main;
    ra, Dec, fov: double;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Init; // old FormShow
    procedure Lock; // old FormClose
    procedure SetLang;
    property onApplyConfig: TNotifyEvent read FApplyConfig write FApplyConfig;
    property onSendVoTable: TSendVoTable read FSendVoTable write FSendVoTable;
    property onInstallCatalog: TNotifyEvent read FInstallCatalog write FInstallCatalog;
  end;

implementation

{$R *.lfm}

procedure Tf_config_catalog.SetLang;
begin
  Caption := rsCatalog;
  Page1.Caption := rsCatalog;
  TabSheetGcatStar.Caption:=rsStars;
  TabSheetGcatVar.Caption:=rsVariableStar2;
  TabSheetGcatDbl.Caption:=rsDoubleStar;
  TabSheetGcatNeb.Caption:=rsNebula;
  TabSheetGcatLin.Caption:=rsLines;
  Label37.Caption := rsStarsAndNebu;
  addcat.Caption := rsAdd;
  delcat.Caption := rsDelete;
  ButtonInstallCat.Caption:=rsInstallObjec;
  ButtonInstallCat1.Caption:=rsInstallObjec;
  ButtonInstallCat2.Caption:=rsInstallObjec;
  ColorDialog1.Title := rsSelectColorB;
  Page1a.Caption := rsVOCatalog;
  Label1.Caption := rsVirtualObser;
  Label4.Caption := rsMaximumRows;
  Button5.Caption := rsAdd;
  Button7.Caption := rsUpdate1;
  Button6.Caption := rsDelete;
  Page2.Caption := rsCdCStars;
  Label2.Caption := rsCDCStarsCata;
  Label16.Caption := rsMin2;
  Label28.Caption := rsFieldNumber;
  Label17.Caption := rsMax2;
  Label27.Caption := rsFilesPath;
  Label18.Caption := rsStars;
  label99.Caption := rsStarCatalogI+' SAO, BD, HD, GC';
  Label19.Caption := rsVariables;
  LabelNewCat.Caption:=Format(rsUseTheButton, [rsUpdate1, rsInstallObjec]);
  Label20.Caption := rsDoubles;
  USNBright.Caption := rsBrightStars;
  Page3.Caption := rsCdCNebulae;
  Label3.Caption := rsCDCNebulaeCa;
  Label22.Caption := rsNebulae;
  Label23.Caption := rsGalaxies;
  Label24.Caption := rsOpenCluster;
  Label25.Caption := rsGlobularClus;
  Label26.Caption := rsPlanetaryNeb;
  Label15.Caption := rsFieldNumber;
  Label116.Caption := rsMin2;
  Label117.Caption := rsMax2;
  Label118.Caption := rsFilesPath;
  Label121.Caption := rsDefault;
  Page5.Caption := rsOtherSoftwar;
  Page4.Caption := rsObsolete+blank+rsStars;
  Label88.Caption := rsCDCObsoleteC;
  Label91.Caption := rsReplacedBy + ' GAIA';
  Label96.Caption := rsReplacedBy + ' XHIP';
  Label95.Caption := rsReplacedBy + ' Hyperleda';
  Label94.Caption := rsNotAvailable;
  Page4b.Caption := rsObsolete+blank+rsNebulae;
  Label92.Caption := rsCDCObsoleteC;
  Label5.Caption := rsFovNumber;
  LabelWarning.Caption := rsWarningYouAr2;
  if Fcatgen <> nil then
    Fcatgen.SetLang;
  SetHelp(self, hlpCatalog);
  page1b.Caption := rsUserDefinedO;
  label6.Caption := rsUserDefinedO;
  addobj.Caption := rsAdd;
  delobj.Caption := rsDelete;
  button8.Caption := rsSaveAs;
  button9.Caption := rsLoad;
  button1.Caption := rsSendTableTo;
  StringGrid1.Columns[0].PickList.Clear;
  StringGrid1.Columns[0].PickList.Add(rsUnknowObject);
  StringGrid1.Columns[0].PickList.Add(rsGalaxy);
  StringGrid1.Columns[0].PickList.Add(rsOpenCluster);
  StringGrid1.Columns[0].PickList.Add(rsGlobularClus);
  StringGrid1.Columns[0].PickList.Add(rsPlanetaryNeb);
  StringGrid1.Columns[0].PickList.Add(rsBrightNebula);
  StringGrid1.Columns[0].PickList.Add(rsClusterAndNe);
  StringGrid1.Columns[0].PickList.Add(rsStar);
  StringGrid1.Columns[0].PickList.Add(rsDoubleStar);
  StringGrid1.Columns[0].PickList.Add(rsTripleStar);
  StringGrid1.Columns[0].PickList.Add(rsAsterism);
  StringGrid1.Columns[0].PickList.Add(rsKnot);
  StringGrid1.Columns[0].PickList.Add(rsGalaxyCluste);
  StringGrid1.Columns[0].PickList.Add(rsDarkNebula);
  StringGrid1.Columns[0].PickList.Add(rsCircle);
  StringGrid1.Columns[0].PickList.Add(rsSquare);
  StringGrid1.Columns[0].PickList.Add(rsLosange);
end;

constructor Tf_config_catalog.Create(AOwner: TComponent);
begin
  mycsc := Tconf_skychart.Create;
  myccat := Tconf_catalog.Create;
  mycshr := Tconf_shared.Create;
  mycplot := Tconf_plot.Create;
  mycmain := Tconf_main.Create;
  csc := mycsc;
  ccat := myccat;
  cshr := mycshr;
  cplot := mycplot;
  cmain := mycmain;
  inherited Create(AOwner);
  PageControl1.ShowTabs := False;
  textcolor := 0;
  LabelDownload.Caption := '';
  LockChange := True;
  LockCatPath := True;
  SetLang;
  {$ifdef lclcocoa}
    { TODO : check cocoa dark theme color}
    if DarkTheme then begin
      StringGrid1.FixedColor := clBackground;
      CatalogGrid1.FixedColor := clBackground;
      StringGrid4.FixedColor := clBackground;
    end;
  {$endif}
end;

destructor Tf_config_catalog.Destroy;
begin
  mycsc.Free;
  myccat.Free;
  mycshr.Free;
  mycplot.Free;
  mycmain.Free;
  if Fcatgen <> nil then
    Fcatgen.Free;
  inherited Destroy;
end;

procedure Tf_config_catalog.Init;
begin
  textcolor:=clWindow;
  LockCatPath := False;
  LockActivePath := False;
  cmain.VOforceactive := False;
  cmain.UOforceactive := False;
  LockChange := True;
  ShowGCat;
  ShowVO;
  ShowUserObjects;
  ShowCDCStar;
  ShowCDCNeb;
  ShowFov;
  LockChange := False;
end;

procedure Tf_config_catalog.maxrowsChange(Sender: TObject);
begin
  cmain.VOmaxrecord := maxrows.Value;
end;

procedure Tf_config_catalog.PageControl1Change(Sender: TObject);
begin

end;

procedure Tf_config_catalog.PageControl1Changing(Sender: TObject;
  var AllowChange: boolean);
begin
  if parent is TForm then
    TForm(Parent).ActiveControl := PageControl1;
end;

procedure Tf_config_catalog.Lock;
begin
  LockChange := True;
end;

procedure Tf_config_catalog.CatgenClick(Sender: TObject);
begin
  if Fcatgen = nil then
    Fcatgen := Tf_catgen.Create(self);
  FormPos(Fcatgen, mouse.CursorPos.x, mouse.CursorPos.y);
  ShowModalForm(Fcatgen);
end;

procedure Tf_config_catalog.Button5Click(Sender: TObject);
begin
  f_voconfig := Tf_voconfig.Create(Self);
  f_voconfig.vopath := VODir;
  if cmain.HttpProxy then
  begin
    f_voconfig.SocksProxy := '';
    f_voconfig.SocksType := '';
    f_voconfig.HttpProxy := cmain.ProxyHost;
    f_voconfig.HttpProxyPort := cmain.ProxyPort;
    f_voconfig.HttpProxyUser := cmain.ProxyUser;
    f_voconfig.HttpProxyPass := cmain.ProxyPass;
  end
  else if cmain.SocksProxy then
  begin
    f_voconfig.HttpProxy := '';
    f_voconfig.SocksType := cmain.SocksType;
    f_voconfig.SocksProxy := cmain.ProxyHost;
    f_voconfig.HttpProxyPort := cmain.ProxyPort;
    f_voconfig.HttpProxyUser := cmain.ProxyUser;
    f_voconfig.HttpProxyPass := cmain.ProxyPass;
  end
  else
  begin
    f_voconfig.SocksProxy := '';
    f_voconfig.SocksType := '';
    f_voconfig.HttpProxy := '';
    f_voconfig.HttpProxyPort := '';
    f_voconfig.HttpProxyUser := '';
    f_voconfig.HttpProxyPass := '';
  end;
  f_voconfig.ra := ra;
  f_voconfig.Dec := Dec;
  f_voconfig.fov := fov;
  f_voconfig.vourlnum := cmain.VOurl;
  f_voconfig.vo_maxrecord := cmain.VOmaxrecord;
  formpos(f_voconfig, left, top);
  ShowModalForm(f_voconfig);
  cmain.VOforceactive := True;
  cmain.VOurl := f_voconfig.vourlnum;
  cmain.VOmaxrecord := f_voconfig.vo_maxrecord;
  f_voconfig.Free;
  ShowVO;
end;

procedure Tf_config_catalog.Button7Click(Sender: TObject);
var
  p: integer;
  fn: string;
begin
  p := stringgrid4.Row;
  if p > 0 then
  begin
    fn := slash(VODir) + stringgrid4.cells[2, p];
    fn := ChangeFileExt(fn, '.config');
    f_voconfig := Tf_voconfig.Create(Self);
    f_voconfig.vopath := VODir;
    if cmain.HttpProxy then
    begin
      f_voconfig.SocksProxy := '';
      f_voconfig.SocksType := '';
      f_voconfig.HttpProxy := cmain.ProxyHost;
      f_voconfig.HttpProxyPort := cmain.ProxyPort;
      f_voconfig.HttpProxyUser := cmain.ProxyUser;
      f_voconfig.HttpProxyPass := cmain.ProxyPass;
    end
    else if cmain.SocksProxy then
    begin
      f_voconfig.HttpProxy := '';
      f_voconfig.SocksType := cmain.SocksType;
      f_voconfig.SocksProxy := cmain.ProxyHost;
      f_voconfig.HttpProxyPort := cmain.ProxyPort;
      f_voconfig.HttpProxyUser := cmain.ProxyUser;
      f_voconfig.HttpProxyPass := cmain.ProxyPass;
    end
    else
    begin
      f_voconfig.SocksProxy := '';
      f_voconfig.SocksType := '';
      f_voconfig.HttpProxy := '';
      f_voconfig.HttpProxyPort := '';
      f_voconfig.HttpProxyUser := '';
      f_voconfig.HttpProxyPass := '';
    end;
    f_voconfig.ra := ra;
    f_voconfig.Dec := Dec;
    f_voconfig.fov := fov;
    f_voconfig.vourlnum := cmain.VOurl;
    f_voconfig.vo_maxrecord := cmain.VOmaxrecord;
    f_voconfig.UpdateCatalog(fn);
    formpos(f_voconfig, left, top);
    ShowModalForm(f_voconfig);
    cmain.VOurl := f_voconfig.vourlnum;
    cmain.VOmaxrecord := f_voconfig.vo_maxrecord;
    f_voconfig.Free;
    ShowVO;
    stringgrid4.Row := p;
  end;
end;

procedure Tf_config_catalog.Button6Click(Sender: TObject);
var
  p: integer;
  fn, fnu: string;
begin
  p := stringgrid4.selection.top;
  fn := slash(VODir) + stringgrid4.cells[2, p];
  fnu := systoutf8(fn);
  if MessageDlg(rsConfirmFileD + fnu, mtConfirmation, mbYesNo, 0) = mrYes then
  begin
    DeleteFile(fn);
    DeleteFile(ChangeFileExt(fn, '.config'));
    ShowVO;
  end;
end;

procedure Tf_config_catalog.ShowGCat;
var
  i, j, n: integer;
  ncolor,scolor: boolean;
  caturl: string;
  g: TStringGrid;

  procedure GCatTitle(grid: TStringGrid);
  begin
    grid.RowCount := 1;
    grid.cells[0, 0] := 'x';
    grid.Columns[0].Title.Caption := rsCat;
    grid.Columns[1].Title.Caption := rsMin2;
    grid.Columns[2].Title.Caption := rsMax2;
    grid.Columns[3].Title.Caption := rsPath;
    grid.Columns[5].Title.Caption := rsColor;
    grid.Columns[6].Title.Caption := rsReload;
  end;

begin
  for g in [CatalogGridStar,CatalogGridVar,CatalogGridDbl,CatalogGridNeb,CatalogGridLin] do begin
    GCatTitle(g);
  end;
  CatalogEmpty := True;
  for j := 0 to ccat.GCatnum - 1 do
  begin
    n := catalog.GetCatType(systoutf8(ccat.GCatLst[j].path), ccat.GCatLst[j].shortname);
    case n of
      1:  g := CatalogGridStar; // rtStar
      2:  g := CatalogGridVar; // rtVar
      3:  g := CatalogGridDbl; // rtDbl
      4:  g := CatalogGridNeb; // rtNeb
      5:  g := CatalogGridLin; // rtLin
      else g := CatalogGridStar;
    end;
    if catalogempty then
      catalogempty := False;
    g.RowCount := g.RowCount+1;
    i := g.RowCount - 1;
    g.cells[1, i] := ccat.GCatLst[j].shortname;
    g.cells[2, i] := formatfloat(f0, ccat.GCatLst[j].min);
    g.cells[3, i] := formatfloat(f0, ccat.GCatLst[j].max);
    g.cells[4, i] := systoutf8(ccat.GCatLst[j].path);
    if ccat.GCatLst[j].actif then
      g.cells[0, i] := '1'
    else if ccat.GCatLst[j].Search then
      g.cells[0, i] := '2'
    else
      g.cells[0, i] := '0';
    ncolor := catalog.GetNebColorSet(g.Cells[4, i], g.Cells[1, i]);
    scolor := catalog.GetStarColorSet(g.Cells[4, i], g.Cells[1, i]);
    if ((n = 4) and (not ncolor)) or (n = 5) then
    begin  // rtneb, rtlin
      if ccat.GCatLst[j].ForceColor and (ccat.GCatLst[j].col > 0) then
        g.cells[6, i] := IntToStr(ccat.GCatLst[j].col)
      else
        g.cells[6, i] := '';
    end
    else if (n = 1) and scolor then
    begin  // rtstar with symbol drawing
      if ccat.GCatLst[j].col = 0 then
        ccat.GCatLst[j].col := clYellow;
      g.cells[6, i] := IntToStr(ccat.GCatLst[j].col)
    end
    else
      g.cells[6, i] := 'N';
    caturl := catalog.GetCatURL(g.Cells[4, i], g.Cells[1, i]);
    if trim(caturl) > '' then
      g.cells[7, i] := '1'
    else
      g.cells[7, i] := '0';
  end;
end;

function changetext(newtext, oldtext: string): string;
begin
  if newtext = oldtext then
    Result := newtext + blank
  else
    Result := newtext;
end;

procedure Tf_config_catalog.ShowCDCNeb;
var
  spec, def: boolean;
begin
  OngcBox.Checked := ccat.NebCatDef[ngc - BaseNeb];
  SacBox.Checked := ccat.NebCatDef[sac - BaseNeb];
  lbnbox.Checked := ccat.NebCatDef[lbn - BaseNeb];
  sh2box.Checked := ccat.NebCatDef[sh2 - BaseNeb];
  drkbox.Checked := ccat.NebCatDef[drk - BaseNeb];
  rc3box.Checked := ccat.NebCatDef[rc3 - BaseNeb];
  pgcbox.Checked := ccat.NebCatDef[pgc - BaseNeb];
  oclbox.Checked := ccat.NebCatDef[ocl - BaseNeb];
  gcmbox.Checked := ccat.NebCatDef[gcm - BaseNeb];
  gpnbox.Checked := ccat.NebCatDef[gpn - BaseNeb];
  fsac1.Value := ccat.NebCatField[sac - BaseNeb, 1];
  fngc1.Value := ccat.NebCatField[ngc - BaseNeb, 1];
  flbn1.Value := ccat.NebCatField[lbn - BaseNeb, 1];
  fsh21.Value := ccat.NebCatField[sh2 - BaseNeb, 1];
  fdrk1.Value := ccat.NebCatField[drk - BaseNeb, 1];
  frc31.Value := ccat.NebCatField[rc3 - BaseNeb, 1];
  fpgc1.Value := ccat.NebCatField[pgc - BaseNeb, 1];
  focl1.Value := ccat.NebCatField[ocl - BaseNeb, 1];
  fgcm1.Value := ccat.NebCatField[gcm - BaseNeb, 1];
  fgpn1.Value := ccat.NebCatField[gpn - BaseNeb, 1];
  fsac2.Value := ccat.NebCatField[sac - BaseNeb, 2];
  fngc2.Value := ccat.NebCatField[ngc - BaseNeb, 2];
  flbn2.Value := ccat.NebCatField[lbn - BaseNeb, 2];
  fsh22.Value := ccat.NebCatField[sh2 - BaseNeb, 2];
  fdrk2.Value := ccat.NebCatField[drk - BaseNeb, 2];
  frc32.Value := ccat.NebCatField[rc3 - BaseNeb, 2];
  fpgc2.Value := ccat.NebCatField[pgc - BaseNeb, 2];
  focl2.Value := ccat.NebCatField[ocl - BaseNeb, 2];
  fgcm2.Value := ccat.NebCatField[gcm - BaseNeb, 2];
  fgpn2.Value := ccat.NebCatField[gpn - BaseNeb, 2];
  sac3.Text := changetext(systoutf8(ccat.NebCatPath[sac - BaseNeb]), sac3.Text);
  ngc3.Text := changetext(systoutf8(ccat.NebCatPath[ngc - BaseNeb]), ngc3.Text);
  lbn3.Text := changetext(systoutf8(ccat.NebCatPath[lbn - BaseNeb]), lbn3.Text);
  sh23.Text := changetext(systoutf8(ccat.NebCatPath[sh2 - BaseNeb]), sh23.Text);
  drk3.Text := changetext(systoutf8(ccat.NebCatPath[drk - BaseNeb]), drk3.Text);
  rc33.Text := changetext(systoutf8(ccat.NebCatPath[rc3 - BaseNeb]), rc33.Text);
  pgc3.Text := changetext(systoutf8(ccat.NebCatPath[pgc - BaseNeb]), pgc3.Text);
  ocl3.Text := changetext(systoutf8(ccat.NebCatPath[ocl - BaseNeb]), ocl3.Text);
  gcm3.Text := changetext(systoutf8(ccat.NebCatPath[gcm - BaseNeb]), gcm3.Text);
  gpn3.Text := changetext(systoutf8(ccat.NebCatPath[gpn - BaseNeb]), gpn3.Text);
  def := OngcBox.Checked;
  spec := lbnbox.Checked or rc3box.Checked or pgcbox.Checked or oclbox.Checked or
    gcmbox.Checked or gpnbox.Checked;
  LabelWarning.Visible := (def and spec);
end;

procedure Tf_config_catalog.ShowCDCStar;
begin
  defbox.Checked := ccat.StarCatDef[DefStar - BaseStar];
  GAIAbox.Checked := ccat.StarCatDef[gaia - BaseStar];
  skybox.Checked := ccat.StarCatDef[sky2000 - BaseStar];
  tycbox.Checked := ccat.StarCatDef[tyc - BaseStar];
  ty2box.Checked := ccat.StarCatDef[tyc2 - BaseStar];
  ticbox.Checked := ccat.StarCatDef[tic - BaseStar];
  gscfbox.Checked := ccat.StarCatDef[gscf - BaseStar];
  gsccbox.Checked := ccat.StarCatDef[gscc - BaseStar];
  gscbox.Checked := ccat.StarCatDef[gsc - BaseStar];
  usnbox.Checked := ccat.StarCatDef[usnoa - BaseStar];
  unbbox.Checked := ccat.StarCatDef[usnob - BaseStar];
  usnbright.Checked := ccat.UseUSNOBrightStars;
  mctbox.Checked := ccat.StarCatDef[microcat - BaseStar];
  dsbasebox.Checked := ccat.StarCatDef[dsbase - BaseStar];
  dstycbox.Checked := ccat.StarCatDef[dstyc - BaseStar];
  dsgscbox.Checked := ccat.StarCatDef[dsgsc - BaseStar];
  hn290Box.Checked := ccat.StarCatDef[hn290 - BaseStar];
  fdef1.Value := ccat.StarCatField[DefStar - BaseStar, 1];
  fdef2.Value := ccat.StarCatField[DefStar - BaseStar, 2];
  fgaia1.Value := ccat.StarCatField[gaia - BaseStar, 1];
  fgaia2.Value := ccat.StarCatField[gaia - BaseStar, 2];
  fsky1.Value := ccat.StarCatField[sky2000 - BaseStar, 1];
  fsky2.Value := ccat.StarCatField[sky2000 - BaseStar, 2];
  ftyc1.Value := ccat.StarCatField[tyc - BaseStar, 1];
  ftyc2.Value := ccat.StarCatField[tyc - BaseStar, 2];
  fty21.Value := ccat.StarCatField[tyc2 - BaseStar, 1];
  fty22.Value := ccat.StarCatField[tyc2 - BaseStar, 2];
  ftic1.Value := ccat.StarCatField[tic - BaseStar, 1];
  ftic2.Value := ccat.StarCatField[tic - BaseStar, 2];
  fgscf1.Value := ccat.StarCatField[gscf - BaseStar, 1];
  fgscf2.Value := ccat.StarCatField[gscf - BaseStar, 2];
  fgscc1.Value := ccat.StarCatField[gscc - BaseStar, 1];
  fgscc2.Value := ccat.StarCatField[gscc - BaseStar, 2];
  fgsc1.Value := ccat.StarCatField[gsc - BaseStar, 1];
  fgsc2.Value := ccat.StarCatField[gsc - BaseStar, 2];
  fusn1.Value := ccat.StarCatField[usnoa - BaseStar, 1];
  fusn2.Value := ccat.StarCatField[usnoa - BaseStar, 2];
  funb1.Value := ccat.StarCatField[usnob - BaseStar, 1];
  funb2.Value := ccat.StarCatField[usnob - BaseStar, 2];
  fmct1.Value := ccat.StarCatField[microcat - BaseStar, 1];
  fmct2.Value := ccat.StarCatField[microcat - BaseStar, 2];
  dsbase1.Value := ccat.StarCatField[dsbase - BaseStar, 1];
  dsbase2.Value := ccat.StarCatField[dsbase - BaseStar, 2];
  dstyc1.Value := ccat.StarCatField[dstyc - BaseStar, 1];
  dstyc2.Value := ccat.StarCatField[dstyc - BaseStar, 2];
  dsgsc1.Value := ccat.StarCatField[dsgsc - BaseStar, 1];
  dsgsc2.Value := ccat.StarCatField[dsgsc - BaseStar, 2];
  hnbase1.Value := ccat.StarCatField[hn290 - BaseStar, 1];
  hnbase2.Value := ccat.StarCatField[hn290 - BaseStar, 2];
  def3.Text := changetext(systoutf8(ccat.StarCatPath[DefStar - BaseStar]), def3.Text);
  gaia3.Text := changetext(systoutf8(ccat.StarCatPath[gaia - BaseStar]), gaia3.Text);
  sky3.Text := changetext(systoutf8(ccat.StarCatPath[sky2000 - BaseStar]), sky3.Text);
  tyc3.Text := changetext(systoutf8(ccat.StarCatPath[tyc - BaseStar]), tyc3.Text);
  ty23.Text := changetext(systoutf8(ccat.StarCatPath[tyc2 - BaseStar]), ty23.Text);
  tic3.Text := changetext(systoutf8(ccat.StarCatPath[tic - BaseStar]), tic3.Text);
  gscf3.Text := changetext(systoutf8(ccat.StarCatPath[gscf - BaseStar]), gscf3.Text);
  gscc3.Text := changetext(systoutf8(ccat.StarCatPath[gscc - BaseStar]), gscc3.Text);
  gsc3.Text := changetext(systoutf8(ccat.StarCatPath[gsc - BaseStar]), gsc3.Text);
  usn3.Text := changetext(systoutf8(ccat.StarCatPath[usnoa - BaseStar]), usn3.Text);
  unb3.Text := changetext(systoutf8(ccat.StarCatPath[usnob - BaseStar]), unb3.Text);
  mct3.Text := changetext(systoutf8(ccat.StarCatPath[microcat - BaseStar]), mct3.Text);
  dsbase3.Text := changetext(systoutf8(ccat.StarCatPath[dsbase - BaseStar]), dsbase3.Text);
  dstyc3.Text := changetext(systoutf8(ccat.StarCatPath[dstyc - BaseStar]), dstyc3.Text);
  dsgsc3.Text := changetext(systoutf8(ccat.StarCatPath[dsgsc - BaseStar]), dsgsc3.Text);
  hnbase3.Text := changetext(systoutf8(ccat.StarCatPath[hn290 - BaseStar]), hnbase3.Text);
  Upd290List(hnbase3.Text);
end;

procedure Tf_config_catalog.ShowFov;
begin
  fw0.Caption := '0: 0 - ' + formatfloat(f2s, cshr.fieldnum[0]);
  fw1.Caption := '1: ' + formatfloat(f2s, cshr.fieldnum[0]) + ' - ' + formatfloat(
    f1s, cshr.fieldnum[1]);
  fw2.Caption := '2: ' + formatfloat(f1s, cshr.fieldnum[1]) + ' - ' + formatfloat(
    f1s, cshr.fieldnum[2]);
  fw3.Caption := '3: ' + formatfloat(f1s, cshr.fieldnum[2]) + ' - ' + formatfloat(
    f1s, cshr.fieldnum[3]);
  fw4.Caption := '4: ' + formatfloat(f1s, cshr.fieldnum[3]) + ' - ' + formatfloat(
    f1s, cshr.fieldnum[4]);
  fw5.Caption := '5: ' + formatfloat(f1s, cshr.fieldnum[4]) + ' - ' + formatfloat(
    f1s, cshr.fieldnum[5]);
  fw6.Caption := '6: ' + formatfloat(f1s, cshr.fieldnum[5]) + ' - ' + formatfloat(
    f1s, cshr.fieldnum[6]);
  fw7.Caption := '7: ' + formatfloat(f1s, cshr.fieldnum[6]) + ' - ' + formatfloat(
    f1s, cshr.fieldnum[7]);
  fw8.Caption := '8: ' + formatfloat(f1s, cshr.fieldnum[7]) + ' - ' + formatfloat(
    f1s, cshr.fieldnum[8]);
  fw9.Caption := '9: ' + formatfloat(f1s, cshr.fieldnum[8]) + ' - ' + formatfloat(
    f1s, cshr.fieldnum[9]);
  fw10.Caption := '10: ' + formatfloat(f1s, cshr.fieldnum[9]) + ' - ' + formatfloat(
    f1s, cshr.fieldnum[10]);
end;

procedure Tf_config_catalog.CatalogGridDrawCell(Sender: TObject;
  ACol, ARow: integer; Rect: TRect; State: TGridDrawState);
begin
  with Sender as TStringGrid do
  begin
    if (Acol = 0) and (Arow > 0) then
    begin
      Canvas.Brush.style := bssolid;
      if (cells[acol, arow] = '1') then
      begin
        Canvas.Brush.Color := clWindow;
        Canvas.FillRect(Rect);
        ImageList1.Draw(Canvas, Rect.left + 2, Rect.top + 2, 3);
      end
      else if (cells[acol, arow] = '2') then
      begin
        Canvas.Brush.Color := clWindow;
        Canvas.FillRect(Rect);
        ImageList1.Draw(Canvas, Rect.left + 2, Rect.top + 2, 4);
      end
      else
      begin
        Canvas.Brush.Color := clWindow;
        Canvas.FillRect(Rect);
        ImageList1.Draw(Canvas, Rect.left + 2, Rect.top + 2, 2);
      end;
    end
    else if (Acol = 5) and (Arow > 0) then
    begin
      ImageList1.Draw(Canvas, Rect.left + 2, Rect.top + 2, 0);
    end
    else if (Acol = 6) and (Arow > 0) then
    begin
      Canvas.Brush.style := bssolid;
      Canvas.Brush.Color := clWindow;
      Canvas.FillRect(Rect);
      if cells[acol, arow] <> 'N' then
      begin
        Canvas.Brush.Color := StrToIntDef(cells[acol, arow], clWhite);
        Canvas.Pen.Color := clBtnShadow;
        Canvas.EllipseC(Rect.Left + (abs(Rect.Right - Rect.Left) div 2),
          Rect.Top + (abs(Rect.Bottom - Rect.Top) div 2), 6, 6);
      end;
    end
    else if (Acol = 7) and (Arow > 0) then
    begin
      if (cells[acol, arow] = '1') then
      begin
        ImageList1.Draw(Canvas, Rect.left + 2, Rect.top + 2, 1);
      end
      else
      begin
        Canvas.Brush.Color := Color;
        Canvas.FillRect(Rect);
      end;
    end;
  end;
end;

procedure Tf_config_catalog.CatalogGridMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: integer);
var
  i, col, row: integer;
begin
  TStringGrid(sender).MouseToCell(X, Y, Col, Row);
  if row = 0 then
    exit;
  case col of
    0:
    begin
      if not fileexistsutf8(slash(TStringGrid(sender).cells[4, row]) + TStringGrid(sender).cells[1, row] + '.hdr') then
        TStringGrid(sender).Cells[col, row] := '0'
      else begin
        if TStringGrid(sender).Cells[col, row] = '0' then
          TStringGrid(sender).Cells[col, row] := '1'
        else if TStringGrid(sender).Cells[col, row] = '1' then
          TStringGrid(sender).Cells[col, row] := '2'
        else if TStringGrid(sender).Cells[col, row] = '2' then
          TStringGrid(sender).Cells[col, row] := '0'
      end;
    end;
    5:
    begin
      EditGCatPath(TStringGrid(sender), row);
    end;
    6:
    begin
      if TStringGrid(sender).Cells[col, row] <> 'N' then
      begin  // editable color
        ColorDialog1.Color := StrToIntDef(TStringGrid(sender).Cells[col, row], clBlack);
        if ColorDialog1.Execute then
        begin
          if ColorDialog1.Color = 0 then
            TStringGrid(sender).Cells[col, row] := ''
          else
            TStringGrid(sender).Cells[col, row] := IntToStr(ColorDialog1.Color);
        end;
      end;
    end;
    7:
    begin
      if TStringGrid(sender).Cells[col, row] = '1' then
      begin
        ReloadCat(TStringGrid(sender).Cells[4, row], TStringGrid(sender).Cells[1, row]);
      end;
    end;
  end;
end;

procedure Tf_config_catalog.ReloadCat(path, cat: string);
var
  fn, fntmp, url: string;
begin
  fn := catalog.GetCatTxtFile(path, cat);
  fntmp := fn + '.tmp';
  url := catalog.GetCatURL(path, cat);
  DownloadDialog1.ScaleDpi:=UScaleDPI.scale;
  DownloadDialog1.msgDownloadFile := rsDownloadFile;
  DownloadDialog1.msgCopyfrom := rsCopyFrom;
  DownloadDialog1.msgtofile := rsToFile;
  DownloadDialog1.msgDownloadBtn := rsDownload;
  DownloadDialog1.msgCancelBtn := rsCancel;
  if cmain.HttpProxy then
  begin
    DownloadDialog1.SocksProxy := '';
    DownloadDialog1.SocksType := '';
    DownloadDialog1.HttpProxy := cmain.ProxyHost;
    DownloadDialog1.HttpProxyPort := cmain.ProxyPort;
    DownloadDialog1.HttpProxyUser := cmain.ProxyUser;
    DownloadDialog1.HttpProxyPass := cmain.ProxyPass;
  end
  else if cmain.SocksProxy then
  begin
    DownloadDialog1.HttpProxy := '';
    DownloadDialog1.SocksType := cmain.SocksType;
    DownloadDialog1.SocksProxy := cmain.ProxyHost;
    DownloadDialog1.HttpProxyPort := cmain.ProxyPort;
    DownloadDialog1.HttpProxyUser := cmain.ProxyUser;
    DownloadDialog1.HttpProxyPass := cmain.ProxyPass;
  end
  else
  begin
    DownloadDialog1.SocksProxy := '';
    DownloadDialog1.SocksType := '';
    DownloadDialog1.HttpProxy := '';
    DownloadDialog1.HttpProxyPort := '';
    DownloadDialog1.HttpProxyUser := '';
    DownloadDialog1.HttpProxyPass := '';
  end;
  DownloadDialog1.URL := url;
  DownloadDialog1.SaveToFile := slash(path) + fntmp;
  if DownloadDialog1.Execute then
  begin
    DeleteFile(slash(path) + fn);
    RenameFile(slash(path) + fntmp, slash(path) + fn);
  end
  else
    ShowMessage(rsErrorFileNot + crlf + DownloadDialog1.ResponseText);
end;

function Tf_config_catalog.SelectGCat(var path, shortname: string): boolean;
var
  buf: string;
  p: integer;
begin
  result:= false;
  chdir(appdir);
  if trim(path) <> '' then
    opendialog1.InitialDir := ExpandFileName(path)
  else
    opendialog1.InitialDir := slash(appdir) + 'cat';
  if trim(shortname) <> '' then
    opendialog1.filename := trim(shortname) + '.hdr';
  opendialog1.Filter := 'Catalog header|*.hdr';
  opendialog1.DefaultExt := '.hdr';
  try
    if opendialog1.Execute then
    begin
      buf := extractfilename(opendialog1.FileName);
      p := pos('.', buf);
      shortname := copy(buf, 1, p - 1);
      path := extractfilepath(opendialog1.filename);
      result:=true;
    end;
  finally
    chdir(appdir);
  end;
end;

procedure Tf_config_catalog.EditGCatPath(grid: TStringGrid; row: integer);
var
  sname,path: string;
  i: integer;
begin
  path := grid.Cells[4, row];
  sname := grid.Cells[1, row];
  if SelectGCat(path,sname) then
    begin
      grid.Cells[1, row] := sname;
      grid.Cells[4, row] := path;
      grid.Cells[2, row] := '0';
      grid.Cells[3, row] := catalog.GetMaxField(grid.Cells[4, row], grid.Cells[1, row]);
    end;
    i := catalog.GetCatType(grid.Cells[4, row], grid.Cells[1, row]);
    if (i = 4) or (i = 5) then   // rtneb, rtlin
      grid.Cells[6, row] := ''
    else if (i = 1) and catalog.GetStarColorSet(grid.Cells[4, row], grid.Cells[1, row]) then
      grid.Cells[6, row] := inttostr(clYellow)
    else
      grid.Cells[6, row] := 'N';
end;

procedure Tf_config_catalog.CatalogGridSelectCell(Sender: TObject;
  ACol, ARow: integer; var CanSelect: boolean);
begin
  if (Acol = 5) or (Acol = 6) or (Acol = 7) then
    canselect := False
  else
    canselect := True;
end;

procedure Tf_config_catalog.CatalogGridSetEditText(Sender: TObject;
  ACol, ARow: integer; const Value: string);
var
  i: integer;
begin
  if (Acol = 4) and (Arow > 0) then
    if not fileexists(slash(Value) + TStringGrid(sender).cells[1, arow] + '.hdr') then
    begin
      TStringGrid(sender).Canvas.Brush.Color := clRed;
      TStringGrid(sender).Canvas.FillRect(TStringGrid(sender).CellRect(ACol, ARow));
      TStringGrid(sender).cells[0, arow] := '0';
    end;
  if (Acol = 1) and (Arow > 0) then
    if not fileexists(slash(TStringGrid(sender).cells[4, arow]) + Value + '.hdr') then
    begin
      TStringGrid(sender).Canvas.Brush.Color := clRed;
      TStringGrid(sender).Canvas.FillRect(TStringGrid(sender).CellRect(ACol, ARow));
      TStringGrid(sender).cells[0, arow] := '0';
    end;
  if ((Acol = 2) or (Acol = 3)) and (Arow > 0) and (Value > '') then
  begin
    if not IsNumber(Value) then
    begin
      TStringGrid(sender).Canvas.Brush.Color := clRed;
      TStringGrid(sender).Canvas.FillRect(TStringGrid(sender).CellRect(ACol, ARow));
      TStringGrid(sender).cells[0, arow] := '0';
    end;
  end;
end;

procedure Tf_config_catalog.AddCatClick(Sender: TObject);
var i,r: integer;
    g: TStringGrid;
    path,sname: string;
begin
  if SelectGCat(path,sname) then begin
    i := catalog.GetCatType(path, sname);
    if (i<1) or (i>5) then exit;
    PageControlGCat.ActivePageIndex := i - 1;
    case i of
      1: g := CatalogGridStar;
      2: g := CatalogGridVar;
      3: g := CatalogGridDbl;
      4: g := CatalogGridNeb;
      5: g := CatalogGridLin;
    end;
    catalogempty := False;
    g.rowcount := g.rowcount + 1;
    r := g.rowcount - 1;
    g.cells[0, r] := '1';
    g.Cells[1, r] := sname;
    g.Cells[4, r] := path;
    g.Cells[2, r] := '0';
    g.Cells[3, r] := catalog.GetMaxField(path, sname);
    if (i = 4) or (i = 5) then   // rtneb, rtlin
      g.Cells[6, r] := ''
    else if (i = 1) and catalog.GetStarColorSet(path, sname) then
      g.Cells[6, r] := inttostr(clYellow)
    else
      g.Cells[6, r] := 'N';
  end;
end;

procedure Tf_config_catalog.DelCatClick(Sender: TObject);
var
  p: integer;
  g: TStringGrid;
begin
  case PageControlGCat.ActivePageIndex of
    0: g := CatalogGridStar;
    1: g := CatalogGridVar;
    2: g := CatalogGridDbl;
    3: g := CatalogGridNeb;
    4: g := CatalogGridLin;
  end;
  p := g.selection.top;
  g.cells[1, p] := '';
  g.cells[2, p] := '';
  g.cells[3, p] := '';
  g.cells[4, p] := '';
  g.cells[5, p] := '';
  g.cells[6, p] := '';
  DeleteGCatRow(g, p);
  catalog.CleanCache;
end;

procedure Tf_config_catalog.DeleteGCatRow(grid: TStringGrid; p: integer);
var
  i: integer;
begin
  if p < 1 then
    exit;
  if grid.rowcount = 2 then
  begin
    grid.cells[0, 1] := '';
    grid.cells[1, 1] := '';
    grid.cells[2, 1] := '';
    grid.cells[3, 1] := '';
    grid.cells[4, 1] := '';
    grid.cells[5, 1] := '';
    grid.cells[6, 1] := '';
    CatalogEmpty := True;
  end
  else
  begin
    for i := p to grid.RowCount - 2 do
    begin
      grid.cells[0, i] := grid.cells[0, i + 1];
      grid.cells[1, i] := grid.cells[1, i + 1];
      grid.cells[2, i] := grid.cells[2, i + 1];
      grid.cells[3, i] := grid.cells[3, i + 1];
      grid.cells[4, i] := grid.cells[4, i + 1];
      grid.cells[5, i] := grid.cells[5, i + 1];
      grid.cells[6, i] := grid.cells[6, i + 1];
      grid.cells[7, i] := grid.cells[7, i + 1];
   end;
    grid.RowCount := grid.RowCount - 1;
  end;
end;

procedure Tf_config_catalog.CDCStarSelClick(Sender: TObject);
begin
  if Sender is TCheckBox then
    with Sender as TCheckBox do
    begin
      ccat.StarCatDef[tag] := Checked;
      ShowCDCStar;
    end;
end;

procedure Tf_config_catalog.CDCAcceptDirectory(Sender: TObject; var Value: string);
begin
{$ifdef darwin}{ TODO : Remove when onChange work correctly on Mac OS X }
  if LockActivePath then
    exit;
  LockActivePath := True;
  TDirectoryEdit(Sender).Text := Value;
  CDCStarPathChange(Sender);
  LockActivePath := False;
{$endif}
end;

procedure Tf_config_catalog.StringGrid4DrawCell(Sender: TObject;
  aCol, aRow: integer; aRect: TRect; aState: TGridDrawState);
begin
  with Sender as TStringGrid do
  begin
    if (Acol = 0) and (Arow > 0) then
    begin
      Canvas.Brush.style := bssolid;
      if (cells[acol, arow] = '1') then
      begin
        Canvas.Brush.Color := clWindow;
        Canvas.FillRect(aRect);
        ImageList1.Draw(Canvas, aRect.left + 2, aRect.top + 2, 3);
      end
      else
      begin
        Canvas.Brush.Color := clWindow;
        Canvas.FillRect(aRect);
        ImageList1.Draw(Canvas, aRect.left + 2, aRect.top + 2, 2);
      end;
    end
    else if (Acol = 3) and (Arow > 0) then
    begin
      if (cells[acol, arow] = '1') then
      begin
        ImageList1.Draw(Canvas, aRect.left + 2, aRect.top + 2, 1);
      end
      else
      begin
        Canvas.Brush.Color := StringGrid4.Color;
        Canvas.FillRect(aRect);
      end;
    end;
  end;
end;

procedure Tf_config_catalog.StringGrid4MouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: integer);
var
  col, row: integer;
begin
  StringGrid4.MouseToCell(X, Y, Col, Row);
  if (col >= 0) and (row >= 0) then
  begin
    if (HintX <> row) or (HintY <> col) then
    begin
      StringGrid4.Hint := '';
      StringGrid4.ShowHint := False;
      HintX := row;
      HintY := col;
    end
    else
    begin
      if col = 3 then
      begin
        StringGrid4.Hint := Format(rsReloadForCur,
          ['"' + trim(StringGrid4.Cells[1, row]) + '"']);
        StringGrid4.ShowHint := True;
      end
      else if (trim(StringGrid4.Cells[col, row]) <> '') and
        (StringGrid4.Canvas.TextWidth(StringGrid4.Cells[col, row]) >
        StringGrid4.ColWidths[col]) then
      begin
        StringGrid4.Hint := StringGrid4.Cells[col, row];
        StringGrid4.ShowHint := True;
      end;
    end;
  end;
end;

procedure Tf_config_catalog.StringGrid4MouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: integer);
var
  col, row: integer;
  config: TCCDconfig;
begin
  StringGrid4.MouseToCell(X, Y, Col, Row);
  if row = 0 then
    exit;
  case col of
    0:
    begin
      if stringgrid4.Cells[col, row] = '1' then
        stringgrid4.Cells[col, row] := '0'
      else
      begin
        cmain.VOforceactive := True;
        stringgrid4.Cells[col, row] := '1';
      end;
      config := TCCDconfig.Create(self);
      config.Filename := slash(VODir) + ChangeFileExt(stringgrid4.Cells[2, row], '.config');
      ;
      config.SetValue('VOcat/plot/active', stringgrid4.Cells[col, row] = '1');
      config.Flush;
      config.Free;
    end;
    3:
    begin
      if stringgrid4.Cells[col, row] = '1' then
      begin
        ReloadVO(stringgrid4.Cells[2, row]);
      end;
    end;
  end;
end;

procedure Tf_config_catalog.StringGrid4SelectCell(Sender: TObject;
  aCol, aRow: integer; var CanSelect: boolean);
begin
  if (Acol = 1) or (Acol = 2) then
    canselect := True
  else
    canselect := False;
end;

procedure Tf_config_catalog.USNBrightClick(Sender: TObject);
begin
  ccat.UseUSNOBrightStars := usnbright.Checked;
end;

procedure Tf_config_catalog.CDCStarField1Change(Sender: TObject);
begin
  if LockChange then
    exit;
  if Sender is TLongEdit then
    with Sender as TLongEdit do
    begin
      ccat.StarCatField[tag, 1] := Value;
    end;
end;

procedure Tf_config_catalog.CDCStarField2Change(Sender: TObject);
begin
  if LockChange then
    exit;
  if Sender is TLongEdit then
    with Sender as TLongEdit do
    begin
      ccat.StarCatField[tag, 2] := Value;
    end;
end;

procedure Tf_config_catalog.CDCStarPathChange(Sender: TObject);
begin
  if LockCatPath then
    exit;
  try
    LockCatPath := True;
    if Sender is TDirectoryEdit then
      with Sender as TDirectoryEdit do
      begin
        Text := trim(Text);
        ccat.StarCatPath[tag] := utf8tosys(Text);
        if ccat.StarCatDef[tag] then
          if catalog.checkpath(tag + BaseStar, utf8tosys(Text)) then
            color := textcolor
          else
            color := clRed
        else
          color := textcolor;
        if ((tag+BaseStar) = hn290) and (color=textcolor) then Upd290List(ccat.StarCatPath[tag]);
      end;
  finally
    LockCatPath := False;
  end;
end;

procedure Tf_config_catalog.CDCNebSelClick(Sender: TObject);
begin
  if Sender is TCheckBox then
    with Sender as TCheckBox do
    begin
      ccat.NebCatDef[tag] := Checked;
      ShowCDCNeb;
    end;
end;

procedure Tf_config_catalog.CDCNebField1Change(Sender: TObject);
begin
  if LockChange then
    exit;
  if Sender is TLongEdit then
    with Sender as TLongEdit do
    begin
      ccat.NebCatField[tag, 1] := Value;
    end;
end;

procedure Tf_config_catalog.CDCNebField2Change(Sender: TObject);
begin
  if LockChange then
    exit;
  if Sender is TLongEdit then
    with Sender as TLongEdit do
    begin
      ccat.NebCatField[tag, 2] := Value;
    end;
end;

procedure Tf_config_catalog.CDCNebPathChange(Sender: TObject);
begin
  if LockCatPath then
    exit;
  try
    LockCatPath := True;
    if Sender is TDirectoryEdit then
      with Sender as TDirectoryEdit do
      begin
        Text := trim(Text);
        ccat.NebCatPath[tag] := utf8tosys(Text);
        if ccat.NebCatDef[tag] then
          if catalog.checkpath(tag + BaseNeb, utf8tosys(Text)) then
            color := textcolor
          else
            color := clRed
        else
          color := textcolor;
      end;
  finally
    LockCatPath := False;
  end;
end;

procedure Tf_config_catalog.ActivateGCat;
var
  i, j, x, v: integer;
  buf: string;
  grid: TStringGrid;
begin
  ccat.GCatNum := 0;
  i:=-1;
  for grid in [CatalogGridStar,CatalogGridVar,CatalogGridDbl,CatalogGridNeb,CatalogGridLin] do begin
    ccat.GCatNum := ccat.GCatNum + grid.RowCount - 1;
    SetLength(ccat.GCatLst, ccat.GCatNum);
    for j := 1 to grid.RowCount-1 do
    begin
      inc(i);
      buf := grid.cells[1, j];
      ccat.GCatLst[i].shortname := grid.cells[1, j];
      ccat.GCatLst[i].path := utf8tosys(grid.cells[4, j]);
      val(grid.cells[2, j], x, v);
      if v = 0 then
        ccat.GCatLst[i].min := x
      else
        ccat.GCatLst[i].min := 0;
      val(grid.cells[3, j], x, v);
      if v = 0 then
        ccat.GCatLst[i].max := x
      else
        ccat.GCatLst[i].max := 0;
      ccat.GCatLst[i].Actif := grid.cells[0, j] = '1';
      ccat.GCatLst[i].Search:= grid.cells[0, j] = '2';
      ccat.GCatLst[i].magmax := 0;
      ccat.GCatLst[i].Name := '';
      ccat.GCatLst[i].cattype := 0;
      buf := grid.cells[6, j];
      val(buf, x, v);
      if v = 0 then
      begin
        ccat.GCatLst[i].ForceColor := True;
        ccat.GCatLst[i].col := x;
      end
      else
      begin
        ccat.GCatLst[i].ForceColor := False;
        ccat.GCatLst[i].col := 0;
      end;
    end;
  end;
end;

procedure Tf_config_catalog.ReloadVO(fn: string);
begin
  try
    screen.Cursor := crHourGlass;
    f_voconfig := Tf_voconfig.Create(Self);
    f_voconfig.onReloadFeedback := ReloadFeedback;
    f_voconfig.vopath := VODir;
    if cmain.HttpProxy then
    begin
      f_voconfig.SocksProxy := '';
      f_voconfig.SocksType := '';
      f_voconfig.HttpProxy := cmain.ProxyHost;
      f_voconfig.HttpProxyPort := cmain.ProxyPort;
      f_voconfig.HttpProxyUser := cmain.ProxyUser;
      f_voconfig.HttpProxyPass := cmain.ProxyPass;
    end
    else if cmain.SocksProxy then
    begin
      f_voconfig.HttpProxy := '';
      f_voconfig.SocksType := cmain.SocksType;
      f_voconfig.SocksProxy := cmain.ProxyHost;
      f_voconfig.HttpProxyPort := cmain.ProxyPort;
      f_voconfig.HttpProxyUser := cmain.ProxyUser;
      f_voconfig.HttpProxyPass := cmain.ProxyPass;
    end
    else
    begin
      f_voconfig.SocksProxy := '';
      f_voconfig.SocksType := '';
      f_voconfig.HttpProxy := '';
      f_voconfig.HttpProxyPort := '';
      f_voconfig.HttpProxyUser := '';
      f_voconfig.HttpProxyPass := '';
    end;
    f_voconfig.ra := ra;
    f_voconfig.Dec := Dec;
    f_voconfig.fov := fov;
    f_voconfig.vourlnum := cmain.VOurl;
    f_voconfig.vo_maxrecord := cmain.VOmaxrecord;
    f_voconfig.ReloadVO(fn);
    f_voconfig.Free;
  finally
    screen.Cursor := crDefault;
  end;
end;

procedure Tf_config_catalog.ReloadFeedback(txt: string);
begin
  LabelDownload.Caption := txt;
  LabelDownload.Invalidate;
  Application.ProcessMessages;
end;

procedure Tf_config_catalog.ShowVO;
var
  i, j, r: integer;
  fs: TSearchRec;
  VOobject, configfile, cname: string;
  config: TCCDconfig;
  active, fullcat: boolean;
const
  VOo: array[1..3] of string = ('star', 'dso', 'samp');
begin
  maxrows.Value := cmain.VOmaxrecord;
  StringGrid4.RowCount := 1;
  stringgrid4.cells[0, 0] := 'x';
  stringgrid4.Columns[0].Title.Caption := rsName;
  stringgrid4.Columns[1].Title.Caption := rsFile;
  stringgrid4.Columns[2].Title.Caption := rsReload;
  for j in [1, 2, 3] do
  begin
    VOobject := VOo[j];
    i := findfirst(slash(VODir) + 'vo_' + VOobject + '_*.xml', 0, fs);
    while i = 0 do
    begin
      configfile := slash(VODir) + ChangeFileExt(fs.Name, '.config');
      if FileExists(configfile) then
      begin
        config := TCCDconfig.Create(self);
        config.Filename := configfile;
        cname := config.GetValue('VOcat/catalog/name', '');
        active := config.GetValue('VOcat/plot/active', True);
        fullcat := config.GetValue('VOcat/update/fullcat', True);
        config.Free;
        StringGrid4.RowCount := StringGrid4.RowCount + 1;
        r := StringGrid4.RowCount - 1;
        StringGrid4.Cells[1, r] := cname;
        StringGrid4.Cells[2, r] := fs.Name;
        if active then
          StringGrid4.Cells[0, r] := '1'
        else
          StringGrid4.Cells[0, r] := '0';
        if fullcat then
          StringGrid4.Cells[3, r] := '0'
        else
          StringGrid4.Cells[3, r] := '1';
      end;
      i := findnext(fs);
    end;
    findclose(fs);
  end;
  if SampConnected then
  begin
    ComboBox1.Enabled := True;
    button1.Enabled := True;
    ComboBox1.Clear;
    ComboBox1.Items.Add(rsAllSAMPClien);
    for i := 0 to SampClientName.Count - 1 do
    begin
      if SampClientTableLoadVotable[i] = '1' then
      begin
        ComboBox1.Items.Add(SampClientName[i]);
      end;
    end;
    ComboBox1.ItemIndex := 0;
  end
  else
  begin
    ComboBox1.Clear;
    ComboBox1.Items.Add(rsAllSAMPClien);
    ComboBox1.ItemIndex := 0;
    ComboBox1.Enabled := False;
    button1.Enabled := False;
  end;
end;

procedure Tf_config_catalog.Button1Click(Sender: TObject);
var
  cn, client, tname, tid, url: string;
  i, p: integer;
begin
  client := '';
  cn := ComboBox1.Text;
  for i := 0 to SampClientName.Count - 1 do
  begin
    if SampClientName[i] = cn then
    begin
      client := SampClientId[i];
      break;
    end;
  end;
  p := stringgrid4.selection.top;
  tname := stringgrid4.cells[1, p];
  tid := 'skychart_' + ExtractFileNameOnly(stringgrid4.cells[2, p]);
  url := 'file://' + slash(VODir) + stringgrid4.cells[2, p];
  if assigned(FSendVoTable) then
    FSendVoTable(client, tname, tid, url);
end;

procedure Tf_config_catalog.ButtonInstallCatClick(Sender: TObject);
begin
  if MessageDlg(rsCloseTheSetu, mtConfirmation, mbYesNo, 0)=mryes then begin
    if Assigned(FInstallCatalog) then FInstallCatalog(self);
  end;
end;

procedure Tf_config_catalog.StringGrid1DrawCell(Sender: TObject;
  aCol, aRow: integer; aRect: TRect; aState: TGridDrawState);
var
  buf: string;
begin
  with Sender as TStringGrid do
  begin
    if (Acol = 0) and (Arow > 0) then
    begin
      Canvas.Brush.style := bssolid;
      if (cells[acol, arow] = '1') then
      begin
        Canvas.Brush.Color := clWindow;
        Canvas.FillRect(aRect);
        ImageList1.Draw(Canvas, aRect.left + 2, aRect.top + 2, 3);
      end
      else
      begin
        Canvas.Brush.Color := clWindow;
        Canvas.FillRect(aRect);
        ImageList1.Draw(Canvas, aRect.left + 2, aRect.top + 2, 2);
      end;
    end
    else if (Acol = 7) and (Arow > 0) then
    begin
      Canvas.Brush.style := bssolid;
      Canvas.Brush.Color := clWindow;
      Canvas.FillRect(aRect);
      if cells[acol, arow] <> 'N' then
      begin
        buf := trim(cells[acol, arow]);
        if buf = '0' then
          buf := '';
        Canvas.Brush.Color := StrToIntDef(buf, clWhite);
        Canvas.Pen.Color := clBtnShadow;
        Canvas.EllipseC(aRect.Left + (abs(aRect.Right - aRect.Left) div 2),
          aRect.Top + (abs(aRect.Bottom - aRect.Top) div 2), 6, 6);
      end;
    end;
  end;
end;

procedure Tf_config_catalog.StringGrid1MouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: integer);
var
  col, row: integer;
begin
  StringGrid1.MouseToCell(X, Y, Col, Row);
  if row = 0 then
    exit;
  case col of
    0:
    begin
      if stringgrid1.Cells[col, row] = '1' then
        stringgrid1.Cells[col, row] := '0'
      else begin
        stringgrid1.Cells[col, row] := '1';
        cmain.UOforceactive := True;
      end;
    end;
    7:
    begin
      ColorDialog1.Color := StrToIntDef(stringgrid1.Cells[col, row], clBlack);
      if ColorDialog1.Execute then
      begin
        if ColorDialog1.Color = 0 then
          stringgrid1.Cells[col, row] := ''
        else
          stringgrid1.Cells[col, row] := IntToStr(ColorDialog1.Color);
      end;
    end;
  end;
end;

procedure Tf_config_catalog.StringGrid1SelectCell(Sender: TObject;
  aCol, aRow: integer; var CanSelect: boolean);
begin
  if (Acol = 0) or (Acol = 7) then
    canselect := False
  else
    canselect := True;
end;


procedure Tf_config_catalog.ShowUserObjects;
var
  i, r: integer;
begin
  StringGrid1.RowCount := 1;
  stringgrid1.cells[0, 0] := 'x';
  stringgrid1.Columns[0].Title.Caption := rsType;
  stringgrid1.Columns[1].Title.Caption := rsObject;
  stringgrid1.Columns[2].Title.Caption := rsRA + '(' + rsHour + ')';
  stringgrid1.Columns[3].Title.Caption := rsDEC + '(' + rsDegree + ')';
  stringgrid1.Columns[4].Title.Caption := rsMagn;
  stringgrid1.Columns[5].Title.Caption := rsSize + '('')';
  stringgrid1.Columns[6].Title.Caption := rsColor;
  stringgrid1.Columns[7].Title.Caption := rsDescription;
  for i := 0 to length(ccat.UserObjects) - 1 do
  begin
    StringGrid1.RowCount := StringGrid1.RowCount + 1;
    r := StringGrid1.RowCount - 1;
    if ccat.UserObjects[i].active then
      StringGrid1.Cells[0, r] := '1'
    else
      StringGrid1.Cells[0, r] := '0';
    StringGrid1.Cells[1, r] := StringGrid1.Columns[0].PickList[ccat.UserObjects[i].otype];
    StringGrid1.Cells[2, r] := ccat.UserObjects[i].oname;
    StringGrid1.Cells[3, r] := ARToStr3(rad2deg * ccat.UserObjects[i].ra / 15);
    StringGrid1.Cells[4, r] := DEToStr3(rad2deg * ccat.UserObjects[i].Dec);
    StringGrid1.Cells[5, r] := FormatFloat(f2, ccat.UserObjects[i].mag);
    StringGrid1.Cells[6, r] := FormatFloat(f2, ccat.UserObjects[i].size);
    if ccat.UserObjects[i].color = 0 then
      StringGrid1.Cells[7, r] := ''
    else
      StringGrid1.Cells[7, r] := IntToStr(ccat.UserObjects[i].color);
    StringGrid1.Cells[8, r] := ccat.UserObjects[i].comment;
  end;
end;

procedure Tf_config_catalog.addobjClick(Sender: TObject);
begin
  if stringgrid1.rowcount < MaxUserObjects then
  begin
    stringgrid1.rowcount := stringgrid1.rowcount + 1;
    stringgrid1.cells[0, stringgrid1.rowcount - 1] := '0';
    stringgrid1.cells[1, stringgrid1.rowcount - 1] := StringGrid1.Columns[0].PickList[0];
    cmain.UOforceactive := True;
  end;
end;

procedure Tf_config_catalog.delobjClick(Sender: TObject);
var
  p: integer;
begin
  p := stringgrid1.selection.top;
  stringgrid1.cells[0, p] := '';
  stringgrid1.cells[1, p] := '';
  stringgrid1.cells[2, p] := '';
  stringgrid1.cells[3, p] := '';
  stringgrid1.cells[4, p] := '';
  stringgrid1.cells[5, p] := '';
  stringgrid1.cells[6, p] := '';
  stringgrid1.cells[7, p] := '';
  stringgrid1.cells[8, p] := '';
  DeleteObjRow(p);
end;

procedure Tf_config_catalog.DeleteObjRow(p: integer);
var
  i: integer;
begin
  if p < 1 then
    exit;
  for i := p to stringgrid1.RowCount - 2 do
  begin
    stringgrid1.cells[0, i] := stringgrid1.cells[0, i + 1];
    stringgrid1.cells[1, i] := stringgrid1.cells[1, i + 1];
    stringgrid1.cells[2, i] := stringgrid1.cells[2, i + 1];
    stringgrid1.cells[3, i] := stringgrid1.cells[3, i + 1];
    stringgrid1.cells[4, i] := stringgrid1.cells[4, i + 1];
    stringgrid1.cells[5, i] := stringgrid1.cells[5, i + 1];
    stringgrid1.cells[6, i] := stringgrid1.cells[6, i + 1];
    stringgrid1.cells[7, i] := stringgrid1.cells[7, i + 1];
    stringgrid1.cells[8, i] := stringgrid1.cells[8, i + 1];
  end;
  stringgrid1.RowCount := stringgrid1.RowCount - 1;
end;

procedure Tf_config_catalog.ActivateUserObjects;
var
  i, j, k, n: integer;
begin
  n := stringgrid1.RowCount - 1;
  SetLength(ccat.UserObjects, n);
  for i := 0 to n - 1 do
  begin
    ccat.UserObjects[i].active := (stringgrid1.cells[0, i + 1] = '1');
    k := 0;
    for j := 0 to StringGrid1.Columns[0].PickList.Count - 1 do
    begin
      if stringgrid1.cells[1, i + 1] = StringGrid1.Columns[0].PickList[j] then
      begin
        k := j;
        break;
      end;
    end;
    ccat.UserObjects[i].otype := k;
    ccat.UserObjects[i].oname := stringgrid1.cells[2, i + 1];
    ccat.UserObjects[i].ra := deg2rad * 15 * Str3ToAR(stringgrid1.cells[3, i + 1]);
    ccat.UserObjects[i].Dec := deg2rad * Str3ToDE(stringgrid1.cells[4, i + 1]);
    ccat.UserObjects[i].mag := StrToFloatDef(stringgrid1.cells[5, i + 1], 6);
    ccat.UserObjects[i].size := StrToFloatDef(stringgrid1.cells[6, i + 1], 60);
    ccat.UserObjects[i].color := StrToIntDef(stringgrid1.cells[7, i + 1], 0);
    ccat.UserObjects[i].comment := stringgrid1.cells[8, i + 1];
  end;
end;

procedure Tf_config_catalog.Button8Click(Sender: TObject);
var
  f: textfile;
  i, n: integer;
  ac,sep: string;
begin
  if stringgrid1.RowCount <= 1 then
    exit;
  if SaveDialog1.InitialDir = '' then
    SaveDialog1.InitialDir := HomeDir;
  if SaveDialog1.Execute then
  begin
    if VerboseMsg then
      WriteTrace(Caption + ' Save user objects to ' + UTF8ToSys(SaveDialog1.FileName));
    ActivateUserObjects;
    AssignFile(f, UTF8ToSys(SaveDialog1.FileName));
    Rewrite(f);
    n := length(ccat.UserObjects);
    sep:=',';
    for i := 0 to n - 1 do
    begin
      if ccat.UserObjects[i].active then
        ac := '1'
      else
        ac := '0';
      WriteLn(f, StringReplace(ccat.UserObjects[i].oname,sep,blank,[rfReplaceAll]) + sep +
        ARToStr3(rad2deg * ccat.UserObjects[i].ra / 15) + sep +
        DEToStr3(rad2deg * ccat.UserObjects[i].Dec) + sep + ac + sep +
        IntToStr(ccat.UserObjects[i].otype) + sep +
        FormatFloat(f2, ccat.UserObjects[i].mag) + sep +
        FormatFloat(f2, ccat.UserObjects[i].size) + sep +
        IntToStr(ccat.UserObjects[i].color) + sep + StringReplace(ccat.UserObjects[i].comment,sep,blank,[rfReplaceAll])
        );
    end;
    CloseFile(f);
  end;
end;

procedure Tf_config_catalog.Button9Click(Sender: TObject);
var
  f: textfile;
  i, n, p: integer;
  buf1, buf2: string;
  sep: char;
  newformat: boolean;
  str:TStringList;
begin
  if OpenDialog1.InitialDir = '' then
    OpenDialog1.InitialDir := HomeDir;
  if OpenDialog1.Execute then
  begin
    if VerboseMsg then
      WriteTrace(Caption + ' Load user objects from ' + UTF8ToSys(OpenDialog1.FileName));
    AssignFile(f, UTF8ToSys(OpenDialog1.FileName));
    reset(f);

    // test format on first line
    sep:=',';
    str:=TStringList.Create;
    ReadLn(f, buf1);
    SplitRec2(buf1,sep,str);
    newformat:=(str.Count>=3);

    // count number of record
    reset(f);
    n := 0;
    while not EOF(f) do
    begin
      ReadLn(f, buf1);
      Inc(n);
    end;
    n := min(n, MaxUserObjects);
    setlength(ccat.UserObjects, n);

    // read file
    reset(f);
    if newformat then begin
      // newformat, coma separated with optional fields
      for i := 0 to n - 1 do
      begin
        ReadLn(f, buf1);
        SplitRec2(buf1,sep,str);
        ccat.UserObjects[i].oname := str[0];
        ccat.UserObjects[i].ra := deg2rad * 15 * Str3ToAR(trim(str[1]));
        ccat.UserObjects[i].Dec := deg2rad * Str3ToDE(trim(str[2]));
        if str.Count>3 then
          ccat.UserObjects[i].active := (trim(str[3]) = '1')
        else
          ccat.UserObjects[i].active := true;
        if str.Count>4 then
          ccat.UserObjects[i].otype := strtointdef(str[4], 0)
        else
          ccat.UserObjects[i].otype := 0;
        if str.Count>5 then
          ccat.UserObjects[i].mag := StrToFloatDef(str[5], 6)
        else
          ccat.UserObjects[i].mag := 6;
        if str.Count>6 then
          ccat.UserObjects[i].size := StrToFloatDef(str[6], 60)
        else
          ccat.UserObjects[i].size := 60;
        if str.Count>7 then
          ccat.UserObjects[i].color := StrToIntDef(str[7], 0)
        else
          ccat.UserObjects[i].color := 0;
        if str.Count>8 then
          ccat.UserObjects[i].comment := str[8]
        else
          ccat.UserObjects[i].comment := '';
      end;
    end
    else begin
      // old format, space separated, all fields must be present
      for i := 0 to n - 1 do
      begin
        ReadLn(f, buf1);
        p := pos(blank, buf1);
        buf2 := copy(buf1, 1, p - 1);
        Delete(buf1, 1, p);
        ccat.UserObjects[i].oname := buf2;
        p := pos(blank, buf1);
        buf2 := copy(buf1, 1, p - 1);
        Delete(buf1, 1, p);
        ccat.UserObjects[i].ra := deg2rad * 15 * Str3ToAR(trim(buf2));
        p := pos(blank, buf1);
        buf2 := copy(buf1, 1, p - 1);
        Delete(buf1, 1, p);
        ccat.UserObjects[i].Dec := deg2rad * Str3ToDE(trim(buf2));
        p := pos(blank, buf1);
        buf2 := copy(buf1, 1, p - 1);
        Delete(buf1, 1, p);
        ccat.UserObjects[i].active := (trim(buf2) = '1');
        p := pos(blank, buf1);
        buf2 := copy(buf1, 1, p - 1);
        Delete(buf1, 1, p);
        ccat.UserObjects[i].otype := strtointdef(buf2, 0);
        p := pos(blank, buf1);
        buf2 := copy(buf1, 1, p - 1);
        Delete(buf1, 1, p);
        ccat.UserObjects[i].mag := StrToFloatDef(buf2, 6);
        p := pos(blank, buf1);
        buf2 := copy(buf1, 1, p - 1);
        Delete(buf1, 1, p);
        ccat.UserObjects[i].size := StrToFloatDef(buf2, 60);
        p := pos(blank, buf1);
        buf2 := copy(buf1, 1, p - 1);
        Delete(buf1, 1, p);
        ccat.UserObjects[i].color := StrToIntDef(buf2, 0);
        ccat.UserObjects[i].comment := buf1;
      end;
    end;

    CloseFile(f);
    str.Free;
    ShowUserObjects;
  end;
end;

procedure Tf_config_catalog.Upd290List(path: string);
var
  fs: TSearchRec;
  i: integer;
  txt: string;
begin
  hnName.Clear;
  i := findfirst(slash(path) + '*.290', 0, fs);
  while i=0 do begin
    txt:=copy(fs.Name,1,3);
    if hnName.Items.IndexOf(txt)<0 then begin
       hnName.Items.Add(txt);
    end;
    i := findnext(fs);
  end;
  findclose(fs);
  if hnName.Items.Count>0 then begin
    i:=hnName.Items.IndexOf(ccat.Name290);
    if i>=0 then
      hnName.ItemIndex:=i
    else begin
      hnName.ItemIndex:=0;
      ccat.Name290:=hnName.Items[0];
    end;
  end;
end;

procedure Tf_config_catalog.hnNameChange(Sender: TObject);
begin
  ccat.Name290:=hnName.text;
end;

end.
