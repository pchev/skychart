unit fu_config_solsys;

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
  u_help, u_translation, u_constant, u_util, u_projection, cu_database, cu_radec,
  LCLIntf, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, Math, IniFiles,
  Spin, enhedits, StdCtrls, Buttons, ExtCtrls, ComCtrls, LResources, UScaleDPI,
  downloaddialog, jdcalendar, EditBtn, Process, LazHelpHTML, LazUTF8, LazFileUtils;

type

  { Tf_config_solsys }

  Tf_config_solsys = class(TFrame)
    ButtonEphDefault: TButton;
    ButtonEphAdd: TButton;
    ButtonEphDel: TButton;
    ButtonEphUp: TButton;
    ButtonEphDown: TButton;
    EditEph: TEdit;
    GroupBox2: TGroupBox;
    ListBoxEph: TListBox;
    smallsat: TCheckBox;
    ComboBox2: TComboBox;
    AstNeo: TCheckBox;
    GRSdrift: TFloatEdit;
    GRSJDDate: TJDDatePicker;
    Label10: TLabel;
    Label4: TLabel;
    Label6: TLabel;
    Label8: TLabel;
    GRSPanel: TPanel;
    Label9: TLabel;
    SunPanel: TPanel;
    SunOnline: TCheckBox;
    CheckBoxPluto: TCheckBox;
    ComboBox1: TComboBox;
    comfile: TFileNameEdit;
    comt_y: TEdit;
    comt_m: TEdit;
    comt_d: TEdit;
    astdeldate_y: TEdit;
    astdeldate_m: TEdit;
    aststrtdate_y: TEdit;
    aststrtdate_m: TEdit;
    DownloadAsteroid: TButton;
    DownloadComet: TButton;
    astnummonthEdit: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Loadcom: TButton;
    LoadMPC: TButton;
    mpcfile: TFileNameEdit;
    ComPageControl1: TPageControl;
    AstPageControl2: TPageControl;
    astnummonth: TMouseUpDown;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    TabSheet4: TTabSheet;
    TransparentPlanet: TCheckBox;
    planetdir: TDirectoryEdit;
    DownloadDialog1: TDownloadDialog;
    GroupBox1: TGroupBox;
    MainPanel: TPanel;
    Page1: TTabSheet;
    Page2: TTabSheet;
    Page3: TTabSheet;
    Page4: TTabSheet;
    Label12: TLabel;
    Label131: TLabel;
    PlaParalaxe: TRadioGroup;
    Label5: TLabel;
    Label89: TLabel;
    PlanetBox: TCheckBox;
    PlanetMode: TRadioGroup;
    PlanetBox3: TCheckBox;
    GRS: TFloatEdit;
    BtnDownloadGRS: TBitBtn;
    ComPageControl: TPageControl;
    comsetting: TTabSheet;
    GroupBox13: TGroupBox;
    Label154: TLabel;
    Label216: TLabel;
    Label231: TLabel;
    comlimitmag: TFloatEdit;
    showcom: TCheckBox;
    comsymbol: TRadioGroup;
    commagdiff: TFloatEdit;
    comdbset: TButton;
    comload: TTabSheet;
    Label232: TLabel;
    MemoCom: TMemo;
    comdelete: TTabSheet;
    Label238: TLabel;
    GroupBox16: TGroupBox;
    comelemlist: TComboBox;
    DelCom: TButton;
    GroupBox17: TGroupBox;
    Label239: TLabel;
    DelComAll: TButton;
    DelComMemo: TMemo;
    Addsinglecom: TTabSheet;
    Label241: TLabel;
    Label242: TLabel;
    Label243: TLabel;
    Label244: TLabel;
    Label245: TLabel;
    Label246: TLabel;
    Label247: TLabel;
    Label248: TLabel;
    Label249: TLabel;
    Label250: TLabel;
    Label251: TLabel;
    Label253: TLabel;
    Label254: TLabel;
    comid: TEdit;
    comh: TEdit;
    comg: TEdit;
    comep: TEdit;
    comperi: TEdit;
    comnode: TEdit;
    comi: TEdit;
    comec: TEdit;
    comq: TEdit;
    comnam: TEdit;
    comeq: TEdit;
    AddCom: TButton;
    AstPageControl: TPageControl;
    astsetting: TTabSheet;
    GroupBox9: TGroupBox;
    Label203: TLabel;
    Label212: TLabel;
    Label213: TLabel;
    astlimitmag: TFloatEdit;
    showast: TCheckBox;
    astsymbol: TRadioGroup;
    astmagdiff: TFloatEdit;
    astdbset: TButton;
    astload: TTabSheet;
    Label206: TLabel;
    Label215: TLabel;
    astnumbered: TCheckBox;
    aststoperr: TCheckBox;
    astlimitbox: TCheckBox;
    astlimit: TLongEdit;
    MemoMPC: TMemo;
    astprepare: TTabSheet;
    Label210: TLabel;
    GroupBox8: TGroupBox;
    Label7: TLabel;
    Label207: TLabel;
    AstCompute: TButton;
    prepastmemo: TMemo;
    astdelete: TTabSheet;
    Label211: TLabel;
    GroupBox10: TGroupBox;
    astelemlist: TComboBox;
    delast: TButton;
    GroupBox11: TGroupBox;
    Label209: TLabel;
    delallast: TButton;
    delastMemo: TMemo;
    GroupBox12: TGroupBox;
    Label214: TLabel;
    deldateast: TButton;
    AddsingleAst: TTabSheet;
    Label217: TLabel;
    Label218: TLabel;
    Label219: TLabel;
    Label220: TLabel;
    Label221: TLabel;
    Label222: TLabel;
    Label223: TLabel;
    Label224: TLabel;
    Label225: TLabel;
    Label226: TLabel;
    Label227: TLabel;
    Label228: TLabel;
    Label229: TLabel;
    Label230: TLabel;
    astid: TEdit;
    asth: TEdit;
    astg: TEdit;
    astep: TEdit;
    astma: TEdit;
    astperi: TEdit;
    astnode: TEdit;
    asti: TEdit;
    astec: TEdit;
    astax: TEdit;
    astref: TEdit;
    astnam: TEdit;
    asteq: TEdit;
    Addast: TButton;
    OpenDialog1: TOpenDialog;
    PageControl1: TPageControl;
    procedure AstNeoClick(Sender: TObject);
    procedure AstPageControl2Changing(Sender: TObject; var AllowChange: boolean);
    procedure ButtonEphAddClick(Sender: TObject);
    procedure ButtonEphDefaultClick(Sender: TObject);
    procedure ButtonEphDelClick(Sender: TObject);
    procedure ButtonEphDownClick(Sender: TObject);
    procedure ButtonEphUpClick(Sender: TObject);
    procedure CheckBoxPlutoChange(Sender: TObject);
    procedure ComboBox1Select(Sender: TObject);
    procedure ComboBox2Select(Sender: TObject);
    procedure ComPageControl1Changing(Sender: TObject; var AllowChange: boolean);
    procedure DownloadAsteroidClick(Sender: TObject);
    procedure DownloadCometClick(Sender: TObject);
    procedure GRSdriftChange(Sender: TObject);
    procedure GRSJDDateChange(Sender: TObject);
    procedure PageControl1Changing(Sender: TObject; var AllowChange: boolean);
    procedure PlanetDirChange(Sender: TObject);
    procedure PlaParalaxeClick(Sender: TObject);
    procedure PlanetBoxClick(Sender: TObject);
    procedure PlanetModeClick(Sender: TObject);
    procedure GRSChange(Sender: TObject);
    procedure PlanetBox3Click(Sender: TObject);
    procedure BtnDownloadGRSClick(Sender: TObject);
    procedure showcomClick(Sender: TObject);
    procedure comsymbolClick(Sender: TObject);
    procedure comlimitmagChange(Sender: TObject);
    procedure commagdiffChange(Sender: TObject);
    procedure LoadcomClick(Sender: TObject);
    procedure DelComClick(Sender: TObject);
    procedure DelComAllClick(Sender: TObject);
    procedure AddComClick(Sender: TObject);
    procedure comdbsetClick(Sender: TObject);
    procedure showastClick(Sender: TObject);
    procedure astsymbolClick(Sender: TObject);
    procedure astlimitmagChange(Sender: TObject);
    procedure astmagdiffChange(Sender: TObject);
    procedure astdbsetClick(Sender: TObject);
    procedure LoadMPCClick(Sender: TObject);
    procedure AstComputeClick(Sender: TObject);
    procedure delastClick(Sender: TObject);
    procedure deldateastClick(Sender: TObject);
    procedure delallastClick(Sender: TObject);
    procedure AddastClick(Sender: TObject);
    procedure smallsatChange(Sender: TObject);
    procedure SunOnlineClick(Sender: TObject);
    procedure TransparentPlanetClick(Sender: TObject);
  private
    { Private declarations }
    FShowDB: TNotifyEvent;
    FPrepareAsteroid: TPrepareAsteroid;
    FApplyConfig: TNotifyEvent;
    LockChange: boolean;
    FConfirmDownload: boolean;
    procedure ShowPlanet;
    procedure ShowComet;
    procedure UpdComList;
    procedure ShowAsteroid;
    procedure UpdAstList;
    procedure AsteroidFeedback(txt: string);
    procedure CometFeedback(txt: string);
  public
    { Public declarations }
    cdb: Tcdcdb;
    autoprocess, autoOK: boolean;
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
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Init; // old FormShow
    procedure Lock; // old FormClose
    procedure SetLang;
    procedure LoadSampleData;
    procedure ActivateJplEph;
    property ConfirmDownload: boolean read FConfirmDownload write FConfirmDownload;
    property onShowDB: TNotifyEvent read FShowDB write FShowDB;
    property onPrepareAsteroid: TPrepareAsteroid
      read FPrepareAsteroid write FPrepareAsteroid;
    property onApplyConfig: TNotifyEvent read FApplyConfig write FApplyConfig;
  end;

implementation

{$R *.lfm}

procedure Tf_config_solsys.SetLang;
var
  Alabels: TDatesLabelsArray;
begin
  Caption := rsSolarSystem;
  page1.Caption := rsSolarSystem;
  page2.Caption := rsPlanet;
  page3.Caption := rsComet;
  page4.Caption := rsAsteroid;
  Label12.Caption := rsSolarSystemS;
  Label131.Caption := rsDataFiles;
  PlaParalaxe.Caption := rsPosition;
  PlaParalaxe.Items[0] := rsGeocentric;
  PlaParalaxe.Items[1] := rsTopoCentric;
  GroupBox2.Caption := rsJPLEphemeris;
  ButtonEphAdd.Caption := rsAdd;
  ButtonEphDefault.Caption := rsDefault;
  ButtonEphDel.Caption := rsDelete;
  ButtonEphDown.Caption := rsDown;
  ButtonEphUp.Caption := rsUp;
  CheckBoxPluto.Caption := rsPlutoIsAPlan;
  Label3.Caption := rsUncheckToAvo;
  Label5.Caption := rsPlanetsSetti;
  Label89.Caption := rsJupiterGRSLo;
  Label9.Caption := rsDrift;
  Label10.Caption := rsDate;
  BtnDownloadGRS.Caption := rsGetRecentMea;
  BtnDownloadGRS.Hint := rsGetRecentMea;
  PlanetBox.Caption := rsShowPlanetOn;
  PlanetMode.Caption := rsDrawPlanetAs;
  PlanetMode.Items[0] := rsStar;
  PlanetMode.Items[1] := rsLineModeDraw;
  PlanetMode.Items[2] := rsRealisticsIm;
  PlanetMode.Items[3] := rsSymbol;
{$ifdef unix}
  PlanetMode.Items[2] := PlanetMode.Items[2] + blank + rsRequireXplan;
{$endif}
  PlanetBox3.Caption := rsShowEarthSha;
  TransparentPlanet.Caption := rsTransparentL;
  SunOnline.Caption := rsUseOnlineSun;
  smallsat.Caption := rsShowTheSmall;
  Label4.Caption := rsSunImageSour;
  Label6.Caption := rsRefreshImage;
  Label8.Caption := rsHours;
  comsetting.Caption := rsGeneralSetti;
  GroupBox13.Caption := rsChartSetting;
  Label154.Caption := rsButNeverFain;
  Label216.Caption := rsShowComets;
  Label231.Caption := rsMagnitudeFai;
  showcom.Caption := rsShowCometsOn;
  comdbset.Caption := rsDatabaseSett;
  comload.Caption := rsLoadMPCFile;
  Label232.Caption := rsMessages;
  TabSheet2.Caption := rsOrUseALocalF;
  TabSheet1.Caption := rsLoadMPCForma;
  Label2.Caption := rsDownloadLate;
  DownloadComet.Caption := rsDownload;
  Loadcom.Caption := rsLoadFile;
  comdelete.Caption := rsDataMaintena;
  Label238.Caption := rsMessages;
  GroupBox16.Caption := rsDeleteMPCDat;
  DelCom.Caption := rsDelete;
  GroupBox17.Caption := rsQuickDelete;
  Label239.Caption := rsQuicklyDelet;
  DelComAll.Caption := rsDelete;
  Addsinglecom.Caption := rsAdd;
  Label241.Caption := rsAddASingleEl;
  Label242.Caption := rsDesignation;
  Label243.Caption := rsHAbsoluteMag;
  Label244.Caption := rsGSlopeParame;
  Label245.Caption := rsEpochJD;
  Label246.Caption := rsPerihelionDa;
  Label247.Caption := rsArgumentOfPe;
  Label248.Caption := rsLongitudeAsc;
  Label249.Caption := rsInclination;
  Label250.Caption := rsEccentricity;
  Label251.Caption := rsPerihelionDi;
  Label253.Caption := rsEquinox2;
  Label254.Caption := rsName;
  AddCom.Caption := rsAdd;
  astsetting.Caption := rsGeneralSetti;
  GroupBox9.Caption := rsChartSetting;
  Label203.Caption := rsButNeverFain;
  Label212.Caption := rsShowAsteroid;
  Label213.Caption := rsMagnitudeFai;
  AstNeo.Caption := rsShowNearEart;
  showast.Caption := rsShowAsteroid3;
  astdbset.Caption := rsDatabaseSett;
  astload.Caption := rsLoadMPCFile;
  Label206.Caption := rsMessages;
  TabSheet4.Caption := rsOrUseALocalF;
  TabSheet3.Caption := rsLoadMPCForma;
  Label1.Caption := rsDownloadLate;
  DownloadAsteroid.Caption := rsDownload;
  GroupBox1.Caption := rsOptions;
  Label215.Caption := rsAsteroidsFro;
  astnumbered.Caption := rsOnlyNumbered;
  aststoperr.Caption := rsHaltAfter100;
  astlimitbox.Caption := rsLoadOnlyTheF;
  LoadMPC.Caption := rsLoadFile;
  astprepare.Caption := rsPrepareMonth;
  Label210.Caption := rsMessages;
  GroupBox8.Caption := rsPrepareData;
  Label7.Caption := rsStartMonth;
  Label207.Caption := rsNumberOfMont;
  AstCompute.Caption := rsCompute;
  astdelete.Caption := rsDataMaintena;
  Label211.Caption := rsMessages;
  GroupBox10.Caption := rsDeleteMPCDat;
  delast.Caption := rsDelete;
  GroupBox11.Caption := rsQuickDelete;
  Label209.Caption := rsQuicklyDelet2;
  delallast.Caption := rsDelete;
  GroupBox12.Caption := rsDeleteMonthl;
  Label214.Caption := rsDeleteMonthl2;
  deldateast.Caption := rsDelete;
  AddsingleAst.Caption := rsAdd;
  Label217.Caption := rsAddASingleEl;
  Label218.Caption := rsDesignation;
  Label219.Caption := rsHAbsoluteMag;
  Label220.Caption := rsGSlopeParame;
  Label221.Caption := rsEpochJD;
  Label222.Caption := rsMeanAnomaly;
  Label223.Caption := rsArgumentOfPe;
  Label224.Caption := rsLongitudeAsc;
  Label225.Caption := rsInclination;
  Label226.Caption := rsEccentricity;
  Label227.Caption := rsSemimajorAxi;
  Label228.Caption := rsReference;
  Label229.Caption := rsEquinox2;
  Label230.Caption := rsName;
  Addast.Caption := rsAdd;
  comsymbol.Items[0] := rsDisplayAsASy;
  comsymbol.Items[1] := rsProportional;
  astsymbol.Items[0] := rsDisplayAsASy;
  astsymbol.Items[1] := rsProportional2;
  SetHelp(self, hlpCfgSol);
  DownloadDialog1.msgDownloadFile := rsDownloadFile;
  DownloadDialog1.msgCopyfrom := rsCopyFrom;
  DownloadDialog1.msgtofile := rsToFile;
  DownloadDialog1.msgDownloadBtn := rsDownload;
  DownloadDialog1.msgCancelBtn := rsCancel;
  GRSJDDate.Caption := rsJDCalendar;
  Alabels.Mon := rsMonday;
  Alabels.Tue := rsTuesday;
  Alabels.Wed := rsWednesday;
  Alabels.Thu := rsThursday;
  Alabels.Fri := rsFriday;
  Alabels.Sat := rsSaturday;
  Alabels.Sun := rsSunday;
  Alabels.jd := rsJulianDay;
  Alabels.today := rsToday;
  GRSJDDate.labels := Alabels;
end;

constructor Tf_config_solsys.Create(AOwner: TComponent);
var
  i: integer;
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
  autoOK := False;
  FConfirmDownload := True;
  SetLang;
  LockChange := True;
  ComboBox1.Clear;
  for i := 1 to URL_SUN_NUMBER do
    ComboBox1.Items.Add(URL_SUN_NAME[i]);
end;

destructor Tf_config_solsys.Destroy;
begin
  mycsc.Free;
  myccat.Free;
  mycshr.Free;
  mycplot.Free;
  mycmain.Free;
  inherited Destroy;
end;

procedure Tf_config_solsys.Init;
begin
  LockChange := True;
  ComPageControl.ActivePageIndex := 1;
  ComPageControl.ActivePageIndex := 0;
  ComPageControl1.ActivePageIndex := 1;
  ComPageControl1.ActivePageIndex := 0;
  AstPageControl.ActivePageIndex := 1;
  AstPageControl.ActivePageIndex := 0;
  AstPageControl2.ActivePageIndex := 1;
  AstPageControl2.ActivePageIndex := 0;
  ShowPlanet;
  ShowComet;
  ShowAsteroid;
  LockChange := False;
  if PageControl1.ActivePage = page2 then
    PlanetModeClick(nil);
end;

procedure Tf_config_solsys.ShowPlanet;
var
  i: integer;
begin
  if csc.PlanetParalaxe then
    PlaParalaxe.ItemIndex := 1
  else
    PlaParalaxe.ItemIndex := 0;
  CheckBoxPluto.Checked := csc.ShowPluto;
  smallsat.Checked := csc.ShowSmallsat;
  PlanetBox.Checked := csc.ShowPlanet;
  PlanetMode.ItemIndex := cplot.plaplot;
  grs.Value := csc.GRSlongitude;
  GRSdrift.Value := csc.GRSdrift * 365.25;
  GRSJDDate.JD := csc.GRSjd;
  PlanetBox3.Checked := csc.ShowEarthShadow;
  Planetdir.Text := cmain.planetdir;
  TransparentPlanet.Checked := cplot.TransparentPlanet;
  SunOnline.Checked := csc.SunOnline;
  for i := 0 to URL_SUN_NUMBER - 1 do
    if ComboBox1.Items[i] = csc.sunurlname then
      ComboBox1.ItemIndex := i;
  for i := 0 to ComboBox2.Items.Count - 1 do
    if StrToInt(ComboBox2.Items[i]) = csc.sunrefreshtime then
      ComboBox2.ItemIndex := i;
  if PlanetMode.ItemIndex = 2 then
  begin
    SunPanel.Visible := True;
  end
  else
  begin
    SunPanel.Visible := False;
  end;
  ListBoxEph.Clear;
  for i := 1 to nJPL_DE do
    ListBoxEph.Items.Add(IntToStr(JPL_DE[i]));
  ListBoxEph.TopIndex := 0;
end;

procedure Tf_config_solsys.ShowComet;
begin
  showcom.Checked := csc.ShowComet;
  comsymbol.ItemIndex := csc.ComSymbol;
  comlimitmag.Value := csc.CommagMax;
  commagdiff.Value := csc.CommagDiff;
  UpdComList;
  comfile.InitialDir := slash(MPCDir);
end;

procedure Tf_config_solsys.ShowAsteroid;
begin
  showast.Checked := csc.ShowAsteroid;
  AstNeo.Checked := csc.AstNEO;
  astsymbol.ItemIndex := csc.AstSymbol;
  astlimitmag.Value := csc.AstmagMax;
  astmagdiff.Value := csc.AstmagDiff;
  aststrtdate_y.Text := IntToStr(csc.curyear);
  aststrtdate_m.Text := IntToStr(csc.curmonth);
  astdeldate_y.Text := IntToStr(csc.curyear - 1);
  astdeldate_m.Text := IntToStr(csc.curmonth);
  UpdAstList;
  mpcfile.InitialDir := slash(MPCDir);
end;

procedure Tf_config_solsys.PlanetDirChange(Sender: TObject);
begin
  if LockChange then
    exit;
  cmain.planetdir := planetdir.Text;
end;

procedure Tf_config_solsys.DownloadAsteroidClick(Sender: TObject);
var
  fn, tmpfn, tfn, ext, buf: string;
  i, l, n: integer;
  ok, gzfile: boolean;
  fi, fo: Textfile;
  gzf: pointer;
  ffile: file;
  gzbuf: array[0..4095] of char;
begin
  MemoMpc.Clear;
  n := cmain.AsteroidUrlList.Count;
  if n = 0 then
  begin
    ShowMessage(rsPleaseConfig2);
    exit;
  end;
  fn := slash(MPCDir) + 'MPCORB-' + FormatDateTime('yyyy-mm-dd', now) + '.DAT';
  DownloadDialog1.ScaleDpi:=UScaleDPI.scale;
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
  DownloadDialog1.FtpUserName := 'anonymous';
  DownloadDialog1.FtpPassword := cmain.AnonPass;
  DownloadDialog1.FtpFwPassive := cmain.FtpPassive;
  DownloadDialog1.onFeedback := AsteroidFeedback;
  ok := False;
  gzfile := False;
  for i := 1 to n do
  begin
    if copy(cmain.AsteroidUrlList[i - 1], 1, 1) = '*' then
      continue;
    DownloadDialog1.URL := cmain.AsteroidUrlList[i - 1];
    ext := ExtractFileExt(DownloadDialog1.URL);
    gzfile := (ext = '.gz');
    MemoMpc.Lines.Add(Format(rsDownload2, [DownloadDialog1.URL]));
    tmpfn := slash(TempDir) + 'mpc.tmp';
    if i = 1 then
    begin
      tfn := fn;
      if gzfile then
        DownloadDialog1.SaveToFile := fn + '.gz'
      else
        DownloadDialog1.SaveToFile := fn;
      DownloadDialog1.ConfirmDownload := FConfirmDownload;
    end
    else
    begin
      tfn := fn;
      if gzfile then
        DownloadDialog1.SaveToFile := tmpfn + '.gz'
      else
        DownloadDialog1.SaveToFile := tmpfn;
      DownloadDialog1.ConfirmDownload := False;
    end;
    if DownloadDialog1.Execute then
    begin
      ok := True;
      if gzfile then
      begin
        try
          gzf := gzopen(PChar(DownloadDialog1.SaveToFile), PChar('rb'));
          Filemode := 2;
          assignfile(ffile, tfn);
          rewrite(ffile, 1);
          repeat
            l := gzread(gzf, @gzbuf, length(gzbuf));
            blockwrite(ffile, gzbuf, l, n);
          until gzeof(gzf);
        finally
          gzclose(gzf);
          CloseFile(ffile);
        end;
      end;
      if i > 1 then
      begin
        Filemode := 2;
        assignfile(fi, tmpfn);
        assignfile(fo, fn);
        reset(fi);
        append(fo);
        repeat
          readln(fi, buf);
          writeln(fo, buf);
        until EOF(fi);
        Closefile(fi);
        Closefile(fo);
        DeleteFile(tmpfn);
      end;
    end
    else
    begin
      ShowMessage(Format(rsCancel2, [DownloadDialog1.ResponseText]));
      ok := False;
      break;
    end;
  end;
  if ok then
  begin
    mpcfile.Text := systoutf8(fn);
    application.ProcessMessages;
    LoadMPCClick(Sender);
  end;
  autoOK := ok;
end;

procedure Tf_config_solsys.CheckBoxPlutoChange(Sender: TObject);
begin
  if LockChange then
    exit;
  csc.ShowPluto := CheckBoxPluto.Checked;
end;

procedure Tf_config_solsys.ComboBox1Select(Sender: TObject);
var
  i: integer;
begin
  i := ComboBox1.ItemIndex + 1;
  csc.sunurlname := URL_SUN_NAME[i];
  csc.sunurl := URL_SUN[i];
  csc.sunurlsize := URL_SUN_SIZE[i];
  csc.sunurlmargin := URL_SUN_MARGIN[i];
end;

procedure Tf_config_solsys.ComboBox2Select(Sender: TObject);
begin
  csc.sunrefreshtime := StrToInt(ComboBox2.Text);
end;

procedure Tf_config_solsys.ComPageControl1Changing(Sender: TObject;
  var AllowChange: boolean);
begin
  if LockChange then
    exit;
  // remove focus from filenamedit to avoid focus bug
 {$ifndef darwin} MemoCom.SetFocus; {$endif}
end;

procedure Tf_config_solsys.AstNeoClick(Sender: TObject);
begin
  csc.AstNEO := AstNeo.Checked;
end;

procedure Tf_config_solsys.AstPageControl2Changing(Sender: TObject;
  var AllowChange: boolean);
begin
  if LockChange then
    exit;
  // remove focus from filenamedit to avoid focus bug
  {$ifndef darwin}MemoMPC.SetFocus;  {$endif}
end;

procedure Tf_config_solsys.ButtonEphAddClick(Sender: TObject);
begin
  if IsInteger(EditEph.Text) then
  begin
    ListBoxEph.Items.Insert(0, EditEph.Text);
    ListBoxEph.TopIndex := 0;
  end;
end;

procedure Tf_config_solsys.ButtonEphDefaultClick(Sender: TObject);
var
  i: integer;
begin
  ListBoxEph.Clear;
  for i := 1 to DefaultnJPL_DE do
    ListBoxEph.Items.Add(IntToStr(DefaultJPL_DE[i]));
end;

procedure Tf_config_solsys.ButtonEphDelClick(Sender: TObject);
begin
  ListBoxEph.Items.Delete(ListBoxEph.ItemIndex);
end;

procedure Tf_config_solsys.ButtonEphDownClick(Sender: TObject);
var
  p: integer;
begin
  p := ListBoxEph.ItemIndex;
  if p < (ListBoxEph.Count - 1) then
  begin
    ListBoxEph.Items.Move(p, p + 1);
    ListBoxEph.ItemIndex := p + 1;
  end;
end;

procedure Tf_config_solsys.ButtonEphUpClick(Sender: TObject);
var
  p: integer;
begin
  p := ListBoxEph.ItemIndex;
  if p > 0 then
  begin
    ListBoxEph.Items.Move(p, p - 1);
    ListBoxEph.ItemIndex := p - 1;
  end;
end;

procedure Tf_config_solsys.ActivateJplEph;
var
  i: integer;
begin
  nJPL_DE := ListBoxEph.Count;
  SetLength(JPL_DE, nJPL_DE + 1);
  for i := 1 to nJPL_DE do
    JPL_DE[i] := StrToIntDef(ListBoxEph.Items[i - 1], 0);
  de_type := 0;
  de_jdcheck := MaxInt;
  de_jdstart := MaxInt;
  de_jdend := -MaxInt;
end;

procedure Tf_config_solsys.Lock;
begin
  LockChange := True;
end;

procedure Tf_config_solsys.AsteroidFeedback(txt: string);
begin
  if copy(txt, 1, 9) = 'Read Byte' then
    exit;
  memompc.Lines.Add(txt);
  memompc.SelStart := length(memompc.Text) - 1;
end;

procedure Tf_config_solsys.DownloadCometClick(Sender: TObject);
var
  fn, tmpfn, buf: string;
  i, n: integer;
  ok: boolean;
  fi, fo: Textfile;
begin
  MemoCom.Clear;
  n := cmain.CometUrlList.Count;
  if n = 0 then
  begin
    ShowMessage(rsPleaseConfig2);
    exit;
  end;
  fn := slash(MPCDir) + 'COMET-' + FormatDateTime('yyyy-mm-dd', now) + '.DAT';
  tmpfn := slash(TempDir) + 'mpc.tmp';
  DownloadDialog1.ScaleDpi:=UScaleDPI.scale;
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
  DownloadDialog1.FtpUserName := 'anonymous';
  DownloadDialog1.FtpPassword := cmain.AnonPass;
  DownloadDialog1.FtpFwPassive := cmain.FtpPassive;
  DownloadDialog1.onFeedback := CometFeedback;
  ok := False;
  for i := 1 to n do
  begin
    if copy(cmain.CometUrlList[i - 1], 1, 1) = '*' then
      continue;
    DownloadDialog1.URL := cmain.CometUrlList[i - 1];
    MemoCom.Lines.Add(Format(rsDownload2, [DownloadDialog1.URL]));
    if i = 1 then
    begin
      DownloadDialog1.SaveToFile := fn;
      DownloadDialog1.ConfirmDownload := FConfirmDownload;
    end
    else
    begin
      DownloadDialog1.SaveToFile := tmpfn;
      DownloadDialog1.ConfirmDownload := False;
    end;
    if DownloadDialog1.Execute then
    begin
      ok := True;
      if i > 1 then
      begin
        Filemode := 2;
        assignfile(fi, tmpfn);
        assignfile(fo, fn);
        reset(fi);
        append(fo);
        repeat
          readln(fi, buf);
          writeln(fo, buf);
        until EOF(fi);
        Closefile(fi);
        Closefile(fo);
        DeleteFile(tmpfn);
      end;
    end
    else
    begin
      ShowMessage(Format(rsCancel2, [DownloadDialog1.ResponseText]));
      ok := False;
      break;
    end;
  end;
  if ok then
  begin
    comfile.Text := systoutf8(fn);
    application.ProcessMessages;
    LoadcomClick(Sender);
  end;
  autoOK := ok;
end;

procedure Tf_config_solsys.CometFeedback(txt: string);
begin
  if copy(txt, 1, 9) = 'Read Byte' then
    exit;
  memocom.Lines.Add(txt);
  memocom.SelStart := length(memocom.Text) - 1;
end;

procedure Tf_config_solsys.PlaParalaxeClick(Sender: TObject);
begin
  csc.PlanetParalaxe := (PlaParalaxe.ItemIndex = 1);
end;

procedure Tf_config_solsys.TransparentPlanetClick(Sender: TObject);
begin
  cplot.TransparentPlanet := TransparentPlanet.Checked;
end;

procedure Tf_config_solsys.PlanetBoxClick(Sender: TObject);
begin
  csc.ShowPlanet := PlanetBox.Checked;
end;

procedure Tf_config_solsys.PlanetModeClick(Sender: TObject);
begin
  if LockChange and (PageControl1.ActivePage <> Page2) then
    exit;
  if PlanetMode.ItemIndex = 2 then
  begin
    SunPanel.Visible := True;
  end
  else
  begin
    SunPanel.Visible := False;
  end;
  cplot.plaplot := PlanetMode.ItemIndex;
end;

procedure Tf_config_solsys.GRSChange(Sender: TObject);
begin
  if LockChange then
    exit;
  csc.GRSlongitude := grs.Value;
end;

procedure Tf_config_solsys.GRSdriftChange(Sender: TObject);
begin
  if LockChange then
    exit;
  csc.GRSdrift := GRSdrift.Value / 365.25;
end;

procedure Tf_config_solsys.GRSJDDateChange(Sender: TObject);
begin
  if LockChange then
    exit;
  csc.GRSjd := GRSJDDate.JD;
end;

procedure Tf_config_solsys.PageControl1Changing(Sender: TObject;
  var AllowChange: boolean);
begin
  if parent is TForm then
    TForm(Parent).ActiveControl := PageControl1;
end;


procedure Tf_config_solsys.PlanetBox3Click(Sender: TObject);
begin
  csc.ShowEarthShadow := PlanetBox3.Checked;
end;

procedure Tf_config_solsys.BtnDownloadGRSClick(Sender: TObject);
var
  dl: TDownloadDialog;
  inif: TMeminifile;
  fn, section: string;
  y, m, d: integer;
  h: double;
begin
  dl := TDownloadDialog.Create(self);
  dl.ScaleDpi:=UScaleDPI.scale;
  dl.SocksProxy := '';
  dl.SocksType := '';
  dl.HttpProxy := '';
  dl.HttpProxyPort := '';
  dl.HttpProxyUser := '';
  dl.HttpProxyPass := '';
  dl.ConfirmDownload := False;
  dl.QuickCancel := True;
  dl.URL := URL_GRS;
  fn := slash(TempDir) + 'grs.txt';
  dl.SaveToFile := fn;
  if dl.Execute and FileExists(fn) then
  begin
    inif := TMeminifile.Create(fn);
    try
      section := 'grs';
      djd(GRSJDDate.JD, y, m, d, h);
      GRS.Value := inif.ReadFloat(section, 'RefGRSLon', GRS.Value);
      GRSdrift.Value := inif.ReadFloat(section, 'RefGRSdrift', GRSdrift.Value);
      y := inif.ReadInteger(section, 'RefGRSY', y);
      m := inif.ReadInteger(section, 'RefGRSM', m);
      d := inif.ReadInteger(section, 'RefGRSD', d);
      GRSJDDate.JD := jd(y, m, d, 0);
      csc.GRSlongitude := grs.Value;
      csc.GRSdrift := GRSdrift.Value / 365.25;
      csc.GRSjd := GRSJDDate.JD;
      ShowMessage(rsUpdatedSucce);
    finally
      inif.Free;
    end;
  end;
  dl.Free;
end;


procedure Tf_config_solsys.UpdComList;
begin
  cdb.GetCometFileList(cmain, comelemlist.items);
  comelemlist.ItemIndex := 0;
  if comelemlist.items.Count > 0 then
    comelemlist.Text := comelemlist.items[0];
end;

procedure Tf_config_solsys.showcomClick(Sender: TObject);
begin
  csc.ShowComet := showcom.Checked;
end;

procedure Tf_config_solsys.comsymbolClick(Sender: TObject);
begin
  csc.ComSymbol := comsymbol.ItemIndex;
end;

procedure Tf_config_solsys.comlimitmagChange(Sender: TObject);
begin
  if LockChange then
    exit;
  csc.CommagMax := comlimitmag.Value;
end;

procedure Tf_config_solsys.commagdiffChange(Sender: TObject);
begin
  if LockChange then
    exit;
  csc.CommagDiff := commagdiff.Value;
end;

procedure Tf_config_solsys.LoadcomClick(Sender: TObject);
begin
  if Sender = LoadCom then
    MemoCom.Clear;
  screen.cursor := crHourGlass;
  cdb.LoadCometFile(SafeUTF8ToSys(comfile.Text), MemoCom);
  memocom.SelStart := length(memocom.Text) - 1;
  UpdComList;
  screen.cursor := crDefault;
end;

procedure Tf_config_solsys.DelComClick(Sender: TObject);
begin
  screen.cursor := crHourGlass;
  cdb.DelComet(comelemlist.Text, delcommemo);
  screen.cursor := crDefault;
  UpdComList;
end;

procedure Tf_config_solsys.DelComAllClick(Sender: TObject);
begin
  screen.cursor := crHourGlass;
  cdb.DelCometAll(delComMemo);
  screen.cursor := crDefault;
  UpdComList;
end;

procedure Tf_config_solsys.AddComClick(Sender: TObject);
var
  msg: string;
begin
  msg := cdb.AddCom(comid.Text, trim(comt_y.Text) + '.' + trim(comt_m.Text) +
    '.' + trim(comt_d.Text), comep.Text, comq.Text, comec.Text, comperi.Text,
    comnode.Text, comi.Text, comh.Text, comg.Text, comnam.Text, comeq.Text);
  UpdComList;
  if msg <> '' then
    ShowMessage(msg);
end;

procedure Tf_config_solsys.comdbsetClick(Sender: TObject);
begin
  if Assigned(FShowDB) then
    FShowDB(self);
end;

procedure Tf_config_solsys.UpdAstList;
begin
  cdb.GetAsteroidFileList(cmain, astelemlist.items);
  astelemlist.ItemIndex := 0;
  if astelemlist.items.Count > 0 then
    astelemlist.Text := astelemlist.items[0];
end;


procedure Tf_config_solsys.showastClick(Sender: TObject);
begin
  csc.ShowAsteroid := showast.Checked;
end;

procedure Tf_config_solsys.astsymbolClick(Sender: TObject);
begin
  csc.astsymbol := astsymbol.ItemIndex;
end;

procedure Tf_config_solsys.astlimitmagChange(Sender: TObject);
begin
  if LockChange then
    exit;
  if trim(astlimitmag.Text) <> '' then
    csc.AstmagMax := astlimitmag.Value;
end;

procedure Tf_config_solsys.astmagdiffChange(Sender: TObject);
begin
  if LockChange then
    exit;
  csc.AstmagDiff := astmagdiff.Value;
end;

procedure Tf_config_solsys.astdbsetClick(Sender: TObject);
begin
  if Assigned(FShowDB) then
    FShowDB(self);
end;

procedure Tf_config_solsys.LoadMPCClick(Sender: TObject);
var
  ok: boolean;
begin
  MemoMpc.Clear;
  screen.cursor := crHourGlass;
  ok := cdb.LoadAsteroidFile(SafeUTF8ToSys(mpcfile.Text), astnumbered.Checked,
    aststoperr.Checked, astlimitbox.Checked, astlimit.Value, MemoMPC);
  UpdAstList;
  screen.cursor := crDefault;
  if ok then
  begin
    if not autoprocess then
      ShowMessage(rsToUseThisNew);
    AstPageControl.ActivePage := astprepare;
    AstComputeClick(Sender);
  end;
end;

procedure Tf_config_solsys.AstComputeClick(Sender: TObject);
var
  jd1, jd2, step: double;
  y, m, i: integer;
begin
  try
    screen.cursor := crHourGlass;
    prepastmemo.Clear;
    if assigned(FPrepareAsteroid) then
    begin
      y := StrToInt(trim(aststrtdate_y.Text));
      m := StrToInt(trim(aststrtdate_m.Text));
      i := astnummonth.position - 1;
      jd1 := jd(y, m, 1, 0);
      jd2 := jd(y, m + i, 1, 0);
      step := max(1.0, (jd2 - jd1) / i);
      if not FPrepareAsteroid(jd1, jd2, step, prepastmemo.Lines) then
      begin
        screen.cursor := crDefault;
        ShowMessage(Format(rsNoAsteroidDa, [crlf]));
        AstPageControl.ActivePage := astload;
        exit;
      end;
      prepastmemo.Lines.Add(rsYouAreNowRea);
      screen.cursor := crDefault;
      showast.Checked := True;
    end
    else
      prepastmemo.Lines.Add('Error! PrepareAsteroid function not initialized.');
  except
    screen.cursor := crDefault;
  end;
end;

procedure Tf_config_solsys.delastClick(Sender: TObject);
begin
  screen.cursor := crHourGlass;
  Cdb.DelAsteroid(astelemlist.Text, delastMemo);
  screen.cursor := crDefault;
  UpdAstList;
end;

procedure Tf_config_solsys.deldateastClick(Sender: TObject);
begin
  screen.cursor := crHourGlass;
  cdb.DelAstDate(trim(astdeldate_y.Text) + '.' + trim(astdeldate_m.Text), delastMemo);
  screen.cursor := crDefault;
end;

procedure Tf_config_solsys.delallastClick(Sender: TObject);
begin
  screen.cursor := crHourGlass;
  cdb.DelAstAll(delastMemo);
  screen.cursor := crDefault;
  UpdAstList;
end;

procedure Tf_config_solsys.AddastClick(Sender: TObject);
var
  msg: string;
begin
  msg := Cdb.AddAsteroid(astid.Text, asth.Text, astg.Text, astep.Text,
    astma.Text, astperi.Text, astnode.Text, asti.Text, astec.Text, astax.Text,
    astref.Text, astnam.Text, asteq.Text);
  UpdAstList;
  if msg <> '' then
    ShowMessage(msg);
end;

procedure Tf_config_solsys.smallsatChange(Sender: TObject);
begin
  if LockChange then
    exit;
  csc.ShowSmallsat := smallsat.Checked;
end;

procedure Tf_config_solsys.SunOnlineClick(Sender: TObject);
begin
  csc.SunOnline := SunOnline.Checked;
end;

procedure Tf_config_solsys.LoadSampleData;
begin
  // load sample asteroid data
  mpcfile.Text := slash(sampledir) + 'MPCsample.dat';
  autoprocess := True;
  LoadMPCClick(Self);
  autoprocess := False;
  mpcfile.Text := '';
  // load sample comet data
  comfile.Text := slash(sampledir) + 'Cometsample.dat';
  LoadComClick(Self);
  comfile.Text := '';
  csc.ShowComet := True;
  csc.ShowAsteroid := True;
end;

end.
