unit fu_config_pictures;

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
  u_help, u_translation, u_constant, u_util, cu_fits, cu_database,
  BGRABitmap, BGRABitmapTypes,
  LCLIntf, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, LazUTF8, LazFileUtils,
  StdCtrls, ComCtrls, ExtCtrls, Buttons, enhedits, LResources,
  EditBtn, LazHelpHTML_fix, Grids;

type

  { Tf_config_pictures }

  Tf_config_pictures = class(TFrame)
    backimg: TFileNameEdit;
    ArchiveBox: TCheckBox;
    ArchiveDirectory1: TDirectoryEdit;
    Button1: TButton;
    Panel4: TPanel;
    Panel5: TPanel;
    Panel6: TPanel;
    Panel7: TPanel;
    ShowImageLabel: TCheckBox;
    ConfirmArchive: TCheckBox;
    ImgITT2: TComboBox;
    Label9: TLabel;
    ShowImageList: TCheckBox;
    Label8: TLabel;
    MaxImg: TComboBox;
    ScanArchive: TButton;
    GroupBox2: TGroupBox;
    Header1: TButton;
    Button5: TButton;
    ImageList1: TImageList;
    ImgTrBar2: TTrackBar;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Panel2: TPanel;
    Panel3: TPanel;
    ResetLum: TButton;
    OnlineDSS: TCheckBox;
    OnlineDSSList: TComboBox;
    GroupBox1: TGroupBox;
    imgpath: TDirectoryEdit;
    MainPanel: TPanel;
    Page1: TTabSheet;
    Page2: TTabSheet;
    Page3: TTabSheet;
    Label50: TLabel;
    Label264: TLabel;
    nimages: TLabel;
    ScanImages: TButton;
    Panel11: TPanel;
    Label266: TLabel;
    Label268: TLabel;
    ImgLumBar: TTrackBar;
    ImgContrastBar: TTrackBar;
    ProgressPanel: TPanel;
    ProgressCat: TLabel;
    ProgressBar1: TProgressBar;
    SelectDirectoryDialog1: TSelectDirectoryDialog;
    ShowImagesBox: TCheckBox;
    Label270: TLabel;
    Label271: TLabel;
    backimginfo: TLabel;
    ShowBackImg: TCheckBox;
    Panel1: TPanel;
    ImgLumBar2: TTrackBar;
    Image1: TImage;
    ImgContrastBar2: TTrackBar;
    Label1: TLabel;
    Label2: TLabel;
    ImageTimer1: TTimer;
    GroupBox3: TGroupBox;
    Label72: TLabel;
    Label73: TLabel;
    Label74: TLabel;
    Label75: TLabel;
    Label77: TLabel;
    realskydir: TEdit;
    realskydrive: TEdit;
    realskyfile: TEdit;
    RealSkyNorth: TCheckBox;
    RealSkySouth: TCheckBox;
    DSS102CD: TCheckBox;
    Page4: TTabSheet;
    StringGrid1: TStringGrid;
    usesubsample: TCheckBox;
    reallist: TCheckBox;
    realskymax: TLongEdit;
    realskymb: TLongEdit;
    PageControl1: TPageControl;
    procedure ArchiveBoxChange(Sender: TObject);
    procedure ArchiveDirectory1Change(Sender: TObject);
    procedure backimgAcceptFileName(Sender: TObject; var Value: string);
    procedure Button1Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure ConfirmArchiveChange(Sender: TObject);
    procedure Header1Click(Sender: TObject);
    procedure ImgITT2Change(Sender: TObject);
    procedure ImgTrBar2Change(Sender: TObject);
    procedure MaxImgChange(Sender: TObject);
    procedure PageControl1Changing(Sender: TObject; var AllowChange: boolean);
    procedure ResetLumClick(Sender: TObject);
    procedure PageControl1PageChanged(Sender: TObject);
    procedure imgpathChange(Sender: TObject);
    procedure OnlineDSSChange(Sender: TObject);
    procedure OnlineDSSListChange(Sender: TObject);
    procedure ScanArchiveClick(Sender: TObject);
    procedure ScanImagesClick(Sender: TObject);
    procedure ImgLumBarChange(Sender: TObject);
    procedure ImgContrastBarChange(Sender: TObject);
    procedure ShowImageLabelChange(Sender: TObject);
    procedure ShowImageListChange(Sender: TObject);
    procedure ShowImagesBoxClick(Sender: TObject);
    procedure backimgChange(Sender: TObject);
    procedure ShowBackImgClick(Sender: TObject);
    procedure ImgLumBar2Change(Sender: TObject);
    procedure ImgContrastBar2Change(Sender: TObject);
    procedure ImageTimer1Timer(Sender: TObject);
    procedure RealSkyNorthClick(Sender: TObject);
    procedure DSS102CDClick(Sender: TObject);
    procedure RealSkySouthClick(Sender: TObject);
    procedure realskymaxChange(Sender: TObject);
    procedure realskydirChange(Sender: TObject);
    procedure realskydriveChange(Sender: TObject);
    procedure realskyfileChange(Sender: TObject);
    procedure reallistClick(Sender: TObject);
    procedure StringGrid1DrawCell(Sender: TObject; aCol, aRow: integer;
      aRect: TRect; aState: TGridDrawState);
    procedure StringGrid1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: integer);
    procedure StringGrid1SelectCell(Sender: TObject; aCol, aRow: integer;
      var CanSelect: boolean);
    procedure StringGrid1SetEditText(Sender: TObject; ACol, ARow: integer;
      const Value: string);
    procedure usesubsampleClick(Sender: TObject);
  private
    { Private declarations }
    LockChange: boolean;
    FFits: TFits;
    FApplyConfig: TNotifyEvent;
    InitialTimer: boolean;
    procedure ShowImages;
    procedure RefreshImage;
    procedure EditArchivePath(row: integer);
  public
    { Public declarations }
    cdb: Tcdcdb;
    mycsc: Tconf_skychart;
    myccat: Tconf_catalog;
    mycshr: Tconf_shared;
    mycplot: Tconf_plot;
    mycmain: Tconf_main;
    mycdss: Tconf_dss;
    csc: Tconf_skychart;
    ccat: Tconf_catalog;
    cshr: Tconf_shared;
    cplot: Tconf_plot;
    cmain: Tconf_main;
    cdss: Tconf_dss;
    procedure SetLang;
    procedure Init; // Old FormShow
    procedure Lock; // old FormClose
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property Fits: TFits read FFits write FFits;
    property onApplyConfig: TNotifyEvent read FApplyConfig write FApplyConfig;
  end;

implementation

{$R *.lfm}

procedure Tf_config_pictures.SetLang;
begin
  Caption := rsPictures;
  Page1.Caption := rsDSOCatalogPi;
  Label50.Caption := rsDisplayImage;
  Label264.Caption := rsImageDirecto;
  Label3.Caption := rsTheImageDire;
  ScanImages.Caption := rsScanDirector;
  Label266.Caption := rsLuminosity;
  Label268.Caption := rsContrast;
  ResetLum.Caption := rsDefault;
  Button5.Caption := rsDefault;
  ShowImagesBox.Caption := rsShowObjectPi;
  ProgressCat.Caption := rsOther;
  Page2.Caption := rsBackground;
  Label270.Caption := rsBackgroundPi;
  Label271.Caption := rsFITSFile;
  Label5.Caption := rsShowASingleP;
  Header1.Caption := rsViewHeader;
  label9.Caption := rsVisualisatio;
  ImgITT2.Items[0] := rsLinear;
  ImgITT2.Items[1] := rsScaled;
  ImgITT2.Items[2] := rsLog;
  ImgITT2.Items[3] := rsSqrt;
  ShowBackImg.Caption := rsShowThisPict;
  Label1.Caption := rsLuminosity;
  Label2.Caption := rsContrast;
  label4.Caption := rsTransparency;
  Page3.Caption := rsDSSRealsky;
  Label72.Caption := rsAuxiliaryFil;
  Label73.Caption := rsDataFilesCDr;
  Label74.Caption := rsTemporaryFil;
  Label75.Caption := rsPixels;
  Label77.Caption := rsMBytes;
  RealSkyNorth.Caption := rsRealSkyNorth;
  RealSkySouth.Caption := rsRealSkySouth;
  DSS102CD.Caption := rs102CDDSS;
  usesubsample.Caption := rsUseSubsampli;
  reallist.Caption := rsSelectPlateF;
  GroupBox1.Caption := rsOnlineDSS;
  OnlineDSS.Caption := rsUseOnlineDSS;
  groupbox2.Caption := rsDownloadArch;
  ArchiveBox.Caption := rsArchiveToDir;
  ConfirmArchive.Caption := rsConfirmation;
  SetHelp(self, hlpCfgPict);
  Page4.Caption := rsImageArchive;
  label7.Caption := rsImageArchive;
  ScanArchive.Caption := rsScanArchives + '...';
  stringgrid1.Columns[0].Title.Caption := 'x';
  stringgrid1.Columns[1].Title.Caption := rsPath;
  stringgrid1.Columns[3].Title.Caption := rsCount;
  label8.Caption := rsMaximumNumbe;
  ShowImageList.Caption := rsShowTheImage;
  ShowImageLabel.Caption := rsShowImageNam;
  Button1.Caption := rsAdjustTheVis;
end;

constructor Tf_config_pictures.Create(AOwner: TComponent);
begin
  mycsc := Tconf_skychart.Create;
  myccat := Tconf_catalog.Create;
  mycshr := Tconf_shared.Create;
  mycplot := Tconf_plot.Create;
  mycmain := Tconf_main.Create;
  mycdss := Tconf_DSS.Create;
  csc := mycsc;
  ccat := myccat;
  cshr := mycshr;
  cplot := mycplot;
  cmain := mycmain;
  cdss := mycdss;
  inherited Create(AOwner);
  SetLang;
  LockChange := True;
  backimginfo.Caption := rsNoPicture;
  ShowBackImg.Checked := False;
  Image1.canvas.brush.color := clBlack;
  Image1.canvas.pen.color := clBlack;
  Image1.canvas.rectangle(0, 0, Image1.Width, Image1.Height);
  label6.Visible := False;
  StringGrid1.RowCount := MaxArchiveDir + 1;
  {$ifdef lclcocoa}
    { TODO : check cocoa dark theme color}
    if DarkTheme then begin
      StringGrid1.FixedColor := clBackground;
    end;
  {$endif}
end;

destructor Tf_config_pictures.Destroy;
begin
  mycsc.Free;
  myccat.Free;
  mycshr.Free;
  mycplot.Free;
  mycmain.Free;
  mycdss.Free;
  inherited Destroy;
end;

procedure Tf_config_pictures.Init;
begin
  LockChange := True;
  ShowImages;
  LockChange := False;
  InitialTimer := True;
  ImageTimer1.Interval := 100;
  ImageTimer1.Enabled := True;
end;

procedure Tf_config_pictures.ShowImages;
var
  save: boolean;
  i: integer;
begin
  imgpath.Text := cmain.ImagePath;
  ImgLumBar.position := -round(100 * csc.NEBmin_sigma);
  ImgContrastBar.position := round(100 * csc.NEBmax_sigma);
  ImgLumBar2.position := -round(10 * csc.BGmin_sigma);
  ImgContrastBar2.position := round(10 * csc.BGmax_sigma);
  ImgTrBar2.position := csc.BGalpha;
  ImgITT2.ItemIndex := Ord(csc.BGitt);
  ShowImagesBox.Checked := csc.ShowImages;
  nimages.Caption := Format(rsThereAreCata, [IntToStr(cdb.CountImages(''))]);
  save := csc.ShowBackgroundImage;
  backimg.filename := SysToUTF8(csc.BackgroundImage);
  backimg.InitialDir := ExtractFilePath(backimg.filename);
  ShowBackImg.Checked := save;
  cmain.NewBackgroundImage := False;
  ImageTimer1.Enabled := False;
  RealSkyNorth.Checked := cdss.dssnorth;
  RealSkySouth.Checked := cdss.dsssouth;
  DSS102CD.Checked := cdss.dss102;
  realskydir.Text := SysToUTF8(cdss.dssdir);
  realskydrive.Text := SysToUTF8(cdss.dssdrive);
  realskyfile.Text := SysToUTF8(cdss.dssfile);
  reallist.Checked := cdss.dssplateprompt;
  usesubsample.Checked := cdss.dsssampling;
  realskymax.Value := cdss.dssmaxsize;
  GroupBox3.Visible := (not cdss.OnlineDSS);
  OnlineDSS.Checked := cdss.OnlineDSS;
  OnlineDSSList.Clear;
  for i := 1 to MaxDSSurl do
    if cdss.DSSurl[i, 1] <> '' then
      OnlineDSSList.Items.Add(cdss.DSSurl[i, 0]);
  OnlineDSSList.ItemIndex := cdss.OnlineDSSid - 1;
  ArchiveBox.Checked := cdss.dssarchive;
  ArchiveDirectory1.Directory := SysToUTF8(cdss.dssarchivedir);
  ConfirmArchive.Checked := cdss.dssarchiveprompt;
  MaxImg.ItemIndex := csc.MaxArchiveImg - 1;
  ShowImageList.Checked := csc.ShowImageList;
  ShowImageLabel.Checked := csc.ShowImageLabel;
  for i := 1 to MaxArchiveDir do
    StringGrid1.Cells[1, i] := SysToUTF8(csc.ArchiveDir[i]);
  for i := 1 to MaxArchiveDir do
    if csc.ArchiveDirActive[i] then
      StringGrid1.Cells[0, i] := '1'
    else
      StringGrid1.Cells[0, i] := '0';
  for i := 1 to MaxArchiveDir do
    if csc.ArchiveDirActive[i] then
      StringGrid1.Cells[3, i] := IntToStr(cdb.CountImages(csc.ArchiveDir[i]));
end;

procedure Tf_config_pictures.imgpathChange(Sender: TObject);
begin
  if LockChange then
    exit;
  cmain.ImagePath := imgpath.Text;
end;

procedure Tf_config_pictures.ResetLumClick(Sender: TObject);
begin
  LockChange := True;
  try
    ImgContrastBar.position := 0;
    ImgLumBar.position := 0;
    csc.NEBmin_sigma := 0;
    csc.NEBmax_sigma := 0;
  finally
    LockChange := False;
  end;
end;

procedure Tf_config_pictures.Button5Click(Sender: TObject);
begin
  LockChange := True;
  try
    ImgContrastBar2.position := 0;
    ImgLumBar2.position := 0;
    ImgTrBar2.Position := 200;
    ImgITT2.ItemIndex := Ord(ittramp);
    csc.BGmin_sigma := 0;
    csc.BGmax_sigma := 0;
    csc.BGalpha := 200;
    csc.BGitt := ittramp;
    ImageTimer1.Enabled := True;
  finally
    LockChange := False;
  end;
end;

procedure Tf_config_pictures.Header1Click(Sender: TObject);
begin
  Fits.ViewHeaders;
end;

procedure Tf_config_pictures.Lock;
begin
  LockChange := True;
end;

procedure Tf_config_pictures.PageControl1PageChanged(Sender: TObject);
begin
  if PageControl1.PageIndex = 1 then
    backimgChange(Sender);
end;

procedure Tf_config_pictures.ScanImagesClick(Sender: TObject);
begin
  WriteTrace('Scan picture directory: ' + cmain.ImagePath);
  if DirectoryExists(cmain.ImagePath) then
  begin
    screen.cursor := crHourGlass;
    ProgressPanel.Visible := True;
    Cdb.ScanImagesDirectory(cmain.ImagePath, ProgressCat, ProgressBar1);
    ShowImagesBox.Checked := True;
    screen.cursor := crDefault;
    ProgressPanel.Visible := False;
    nimages.Caption := Format(rsThereAreCata, [IntToStr(cdb.CountImages(''))]);
  end
  else
  begin
    nimages.Caption := rsDirectoryNot2;
  end;
  WriteTrace(nimages.Caption);
end;

procedure Tf_config_pictures.ImgLumBarChange(Sender: TObject);
begin
  if LockChange then
    exit;
  csc.NEBmin_sigma := -ImgLumBar.position / 100;
end;

procedure Tf_config_pictures.ImgContrastBarChange(Sender: TObject);
begin
  if LockChange then
    exit;
  csc.NEBmax_sigma := ImgContrastBar.position / 100;
end;

procedure Tf_config_pictures.ShowImageLabelChange(Sender: TObject);
begin
  csc.ShowImageLabel := ShowImageLabel.Checked;
end;

procedure Tf_config_pictures.ShowImageListChange(Sender: TObject);
begin
  csc.ShowImageList := ShowImageList.Checked;
end;

procedure Tf_config_pictures.ShowImagesBoxClick(Sender: TObject);
begin
  csc.ShowImages := ShowImagesBox.Checked;
end;

procedure Tf_config_pictures.ImgContrastBar2Change(Sender: TObject);
begin
  if LockChange then
    exit;
  csc.BGmax_sigma := ImgContrastBar2.position / 10;
  FFits.max_sigma := csc.BGmax_sigma;
  ImageTimer1.Enabled := True;
end;

procedure Tf_config_pictures.ImgLumBar2Change(Sender: TObject);
begin
  if LockChange then
    exit;
  csc.BGmin_sigma := -ImgLumBar2.position / 10;
  FFits.min_sigma := csc.BGmin_sigma;
  ImageTimer1.Enabled := True;
end;

procedure Tf_config_pictures.ImgTrBar2Change(Sender: TObject);
begin
  if LockChange then
    exit;
  csc.BGalpha := ImgTrBar2.position;
  //ImageTimer1.enabled:=true;
end;

procedure Tf_config_pictures.ImgITT2Change(Sender: TObject);
begin
  if LockChange then
    exit;
  csc.BGitt := titt(ImgITT2.ItemIndex);
  FFits.itt := csc.BGitt;
  ImageTimer1.Enabled := True;
end;



procedure Tf_config_pictures.MaxImgChange(Sender: TObject);
begin
  csc.MaxArchiveImg := MaxImg.ItemIndex + 1;
end;

procedure Tf_config_pictures.PageControl1Changing(Sender: TObject;
  var AllowChange: boolean);
begin
  if parent is TForm then
    TForm(Parent).ActiveControl := PageControl1;
end;

procedure Tf_config_pictures.ImageTimer1Timer(Sender: TObject);
begin
  ImageTimer1.Enabled := False;
  ImageTimer1.Interval := 500;
  if InitialTimer then
  begin
    InitialTimer := False;
    backimgChange(Sender);
  end
  else
    RefreshImage;
end;

////////// duplicate because of filenameedit onchange bug on Mac OS X //////////////////////////
procedure Tf_config_pictures.backimgChange(Sender: TObject);
begin
  if LockChange or (not FileExistsUTF8(backimg.Text)) then
    exit;
  csc.BackgroundImage := UTF8ToSys(backimg.Text);
  Ffits.filename := csc.BackgroundImage;
  if not FFits.Header.valid then exit;
  FFits.InfoWCScoord;
  if Ffits.WCSvalid then
  begin
    if Sender = backimg then
    begin
      ShowBackImg.Checked := True;
      cmain.NewBackgroundImage := True;
    end;
    backimginfo.Caption := extractfilename(csc.BackgroundImage) + blank + rsRA + ':' +
      ARtoStr(Ffits.center_ra * rad2deg / 15) + blank + '' + rsDEC + '' + ':' +
      DEtoStr(Ffits.center_de * rad2deg) + blank + rsFOV + ':' + DEtoStr(
      Ffits.img_width * rad2deg);
    RefreshImage;
  end
  else
  begin
    backimginfo.Caption := rsNoPicture;
    ShowBackImg.Checked := False;
    Image1.canvas.brush.color := clBlack;
    Image1.canvas.pen.color := clBlack;
    Image1.canvas.rectangle(0, 0, Image1.Width, Image1.Height);
  end;
end;

procedure Tf_config_pictures.backimgAcceptFileName(Sender: TObject; var Value: string);
begin
{$ifdef darwin}
  if LockChange or (not FileExistsUTF8(Value)) then
    exit;
  csc.BackgroundImage := UTF8ToSys(Value);
  Ffits.filename := csc.BackgroundImage;
  FFits.InfoWCScoord;
  if Ffits.WCSvalid then
  begin
    if Sender = backimg then
    begin
      ShowBackImg.Checked := True;
      cmain.NewBackgroundImage := True;
    end;
    backimginfo.Caption := extractfilename(csc.BackgroundImage) + blank + rsRA + ':' +
      ARtoStr(Ffits.center_ra * rad2deg / 15) + blank + '' + rsDEC + '' + ':' +
      DEtoStr(Ffits.center_de * rad2deg) + blank + rsFOV + ':' + DEtoStr(
      Ffits.img_width * rad2deg);
    RefreshImage;
  end
  else
  begin
    backimginfo.Caption := rsNoPicture;
    ShowBackImg.Checked := False;
    Image1.canvas.brush.color := clBlack;
    Image1.canvas.pen.color := clBlack;
    Image1.canvas.rectangle(0, 0, Image1.Width, Image1.Height);
  end;
{$endif}
end;

procedure Tf_config_pictures.Button1Click(Sender: TObject);
begin
  PageControl1.ActivePage := Page2;
end;

procedure Tf_config_pictures.ArchiveBoxChange(Sender: TObject);
begin
  cdss.dssarchive := ArchiveBox.Checked;
end;

procedure Tf_config_pictures.ArchiveDirectory1Change(Sender: TObject);
begin
  cdss.dssarchivedir := utf8tosys(ArchiveDirectory1.Directory);
end;

procedure Tf_config_pictures.ConfirmArchiveChange(Sender: TObject);
begin
  cdss.dssarchiveprompt := ConfirmArchive.Checked;
end;

//////////////////////////

procedure Tf_config_pictures.RefreshImage;
var
  bmp, bmp2: TBGRABitmap;
  c1, c2: double;
  dx, dy: integer;
begin
  bmp := TBGRABitmap.Create;
  FFits.min_sigma := csc.BGmin_sigma;
  FFits.max_sigma := csc.BGmax_sigma;
  FFits.GetBGRABitmap(bmp);
  if bmp.Width > 1 then
  begin
    c1 := Image1.Width / Image1.Height;
    c2 := bmp.Width / bmp.Height;
    if c1 > c2 then
    begin
      dy := Image1.Height;
      dx := round(c2 * dy);
    end
    else
    begin
      dx := Image1.Width;
      dy := round(dx / c2);
    end;
    bmp2 := bmp.Resample(dx, dy) as TBGRABitmap;
    try
      bmp2.Draw(Image1.canvas, 0, 0);
    finally
      bmp2.Free;
    end;
    Image1.Invalidate;
  end;
  bmp.Free;
end;

procedure Tf_config_pictures.ShowBackImgClick(Sender: TObject);
begin
  csc.ShowBackgroundImage := ShowBackImg.Checked;
  if csc.ShowBackgroundImage then
    ShowImageList.Checked := True;
  cmain.NewBackgroundImage := csc.ShowBackgroundImage;
  backimgChange(Sender);
end;

procedure Tf_config_pictures.DSS102CDClick(Sender: TObject);
begin
  cdss.dss102 := DSS102CD.Checked;
  if DSS102CD.Checked then
  begin
    RealSkyNorth.Checked := False;
    RealSkySouth.Checked := False;
  end;
end;

procedure Tf_config_pictures.RealSkyNorthClick(Sender: TObject);
begin
  cdss.dssnorth := RealSkyNorth.Checked;
  if RealSkyNorth.Checked then
  begin
    DSS102CD.Checked := False;
  end;
end;

procedure Tf_config_pictures.RealSkySouthClick(Sender: TObject);
begin
  cdss.dsssouth := RealSkySouth.Checked;
  if RealSkySouth.Checked then
  begin
    DSS102CD.Checked := False;
  end;
end;

procedure Tf_config_pictures.realskymaxChange(Sender: TObject);
begin
  if LockChange then
    exit;
  cdss.dssmaxsize := realskymax.Value;
  realskymb.Value := round(sqr(realskymax.Value) * 2 / 1024 / 1024);
end;


procedure Tf_config_pictures.realskydirChange(Sender: TObject);
begin
  if LockChange then
    exit;
  cdss.dssdir := utf8tosys(realskydir.Text);
  if fileexists(slash(cdss.dssdir) + 'hi_comp.lis') then
    realskydir.color := realskydrive.color
  else
    realskydir.color := clRed;
end;

procedure Tf_config_pictures.realskydriveChange(Sender: TObject);
begin
  if LockChange then
    exit;
  cdss.dssdrive := utf8tosys(realskydrive.Text);
end;

procedure Tf_config_pictures.realskyfileChange(Sender: TObject);
begin
  if LockChange then
    exit;
  cdss.dssfile := utf8tosys(realskyfile.Text);
end;

procedure Tf_config_pictures.reallistClick(Sender: TObject);
begin
  if LockChange then
    exit;
  cdss.dssplateprompt := reallist.Checked;
end;

procedure Tf_config_pictures.StringGrid1DrawCell(Sender: TObject;
  aCol, aRow: integer; aRect: TRect; aState: TGridDrawState);
begin
  with Sender as TStringGrid do
  begin
    if (Acol = 0) and (Arow > 0) then
    begin
      csc.ArchiveDirActive[arow] := cells[acol, arow] = '1';
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
    else if (Acol = 1) and (Arow > 0) then
    begin
      csc.ArchiveDir[arow] := utf8tosys(cells[acol, arow]);
    end
    else if (Acol = 2) and (Arow > 0) then
    begin
      ImageList1.Draw(Canvas, aRect.left + 2, aRect.top + 2, 0);
    end;
  end;
end;

procedure Tf_config_pictures.EditArchivePath(row: integer);
begin
  chdir(appdir);
  if trim(stringgrid1.Cells[1, row]) <> '' then
    SelectDirectoryDialog1.InitialDir := ExpandFileName(stringgrid1.Cells[1, row])
  else
    SelectDirectoryDialog1.InitialDir := slash(HomeDir);
  try
    if SelectDirectoryDialog1.Execute then
    begin
      stringgrid1.Cells[1, row] := SelectDirectoryDialog1.FileName;
      stringgrid1.Cells[0, row] := '1';
    end;
  finally
    chdir(appdir);
  end;
end;

procedure Tf_config_pictures.StringGrid1MouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: integer);
var
  Col, Row: integer;
begin
  StringGrid1.MouseToCell(X, Y, Col, Row);
  if row = 0 then
    exit;
  case col of
    0:
    begin
      if stringgrid1.Cells[col, row] = '1' then
        stringgrid1.Cells[col, row] := '0'
      else
      if (trim(stringgrid1.cells[1, row]) > '') and
        DirectoryExistsUTF8(slash(stringgrid1.cells[1, row])) then
        stringgrid1.Cells[col, row] := '1'
      else
        stringgrid1.Cells[col, row] := '0';
    end;
    2:
    begin
      EditArchivePath(row);
    end;
  end;
end;

procedure Tf_config_pictures.StringGrid1SelectCell(Sender: TObject;
  aCol, aRow: integer; var CanSelect: boolean);
begin
  if (Acol = 1) then
    canselect := True
  else
    canselect := False;
end;

procedure Tf_config_pictures.StringGrid1SetEditText(Sender: TObject;
  ACol, ARow: integer; const Value: string);
begin
  if (Acol = 1) and (Arow > 0) then
    if not DirectoryExistsUTF8(slash(stringgrid1.cells[1, arow])) then
    begin
      StringGrid1.Canvas.Brush.Color := clRed;
      StringGrid1.Canvas.FillRect(StringGrid1.CellRect(ACol, ARow));
      StringGrid1.cells[0, arow] := '0';
    end;
end;

procedure Tf_config_pictures.usesubsampleClick(Sender: TObject);
begin
  if LockChange then
    exit;
  cdss.dsssampling := usesubsample.Checked;
end;

procedure Tf_config_pictures.OnlineDSSChange(Sender: TObject);
begin
  if LockChange then
    exit;
  cdss.OnlineDSS := OnlineDSS.Checked;
  GroupBox3.Visible := (not cdss.OnlineDSS);
end;

procedure Tf_config_pictures.OnlineDSSListChange(Sender: TObject);
begin
  if LockChange then
    exit;
  cdss.OnlineDSSid := OnlineDSSList.ItemIndex + 1;
end;

procedure Tf_config_pictures.ScanArchiveClick(Sender: TObject);
var
  i, Count: integer;
begin
  screen.Cursor := crHourGlass;
  try
    for i := 1 to MaxArchiveDir do
    begin
      if (csc.ArchiveDirActive[i]) and (csc.ArchiveDir[i] > '') and
        DirectoryExists(csc.ArchiveDir[i]) then
      begin
        Cdb.ScanArchiveDirectory(csc.ArchiveDir[i], Count);
        StringGrid1.Cells[3, i] := IntToStr(Count);
      end;
    end;
  finally
    screen.Cursor := crDefault;
  end;
end;

end.
