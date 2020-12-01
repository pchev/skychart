         unit pu_calendar;

{$MODE Delphi} {$H+}

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
  u_help, u_translation, Math, cu_database, u_satellite, Printers, LCLIntf,
  SysUtils, Classes, Graphics, Controls, Forms, FileUtil, Dialogs, StdCtrls,
  FileCtrl, enhedits, Grids, ComCtrls, IniFiles, jdcalendar, cu_planet, u_unzip,
  u_constant, pu_image, downloaddialog, Buttons, ExtCtrls, ActnList, StdActns,
  UScaleDPI, LResources, LazHelpHTML_fix, CheckLst, types;

type
  TScFunc = procedure(csc: Tconf_skychart) of object;

  TObjCoord = class(TObject)
    jd, ra, Dec: double;
  end;

  TLine = record
    P1, P2: TPoint;
  end;

const
  nummsg = 47;
  maxcombo = 1000;

type

  { Tf_calendar }

  Tf_calendar = class(TForm)
    Bevel1: TBevel;
    BtnCopyClip: TButton;
    BtnRefresh: TButton;
    BtnHelp: TButton;
    BtnClose: TButton;
    BtnSave: TButton;
    BtnPrint: TButton;
    BtnReset: TButton;
    BtnTleDownload: TButton;
    Button4: TButton;
    TleCheckList: TCheckListBox;
    dgPlanet: TDrawGrid;
    DownloadDialog1: TDownloadDialog;
    fullday: TCheckBox;
    Label10: TLabel;
    LabelTle: TLabel;
    DownloadMemo: TMemo;
    MinSatAlt: TLongEdit;
    DownloadPanel: TPanel;
    tsPGraphs: TTabSheet;
    Time: TTimePicker;
    maglimit: TFloatEdit;
    magchart: TFloatEdit;
    AstFilter: TEdit;
    Button1: TButton;
    Button2: TButton;
    ComboBox1: TComboBox;
    ComboBox2: TComboBox;
    CometFilter: TEdit;
    Date1: TJDDatePicker;
    Date2: TJDDatePicker;
    Panel1: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    Label5: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    EcliPanel: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    SatPanel: TPanel;
    Label9: TLabel;
    PageControl1: TPageControl;
    tle1: TEdit;
    twilight: TTabSheet;
    TwilightGrid: TStringGrid;
    planets: TTabSheet;
    Pagecontrol2: TPageControl;
    Psoleil: TTabSheet;
    SoleilGrid: TStringGrid;
    Mercure: TTabSheet;
    MercureGrid: TStringGrid;
    Venus: TTabSheet;
    VenusGrid: TStringGrid;
    PLune: TTabSheet;
    LuneGrid: TStringGrid;
    Mars: TTabSheet;
    MarsGrid: TStringGrid;
    Jupiter: TTabSheet;
    JupiterGrid: TStringGrid;
    Saturne: TTabSheet;
    SaturneGrid: TStringGrid;
    Uranus: TTabSheet;
    UranusGrid: TStringGrid;
    Neptune: TTabSheet;
    NeptuneGrid: TStringGrid;
    Pluton: TTabSheet;
    PlutonGrid: TStringGrid;
    comet: TTabSheet;
    CometGrid: TStringGrid;
    Solar: TTabSheet;
    SolarGrid: TStringGrid;
    Lunar: TTabSheet;
    LunarGrid: TStringGrid;
    Satellites: TTabSheet;
    SatGrid: TStringGrid;
    step: TLongEdit;
    Asteroids: TTabSheet;
    AsteroidGrid: TStringGrid;
    SaveDialog1: TSaveDialog;
    procedure BtnCopyClipClick(Sender: TObject);
    procedure BtnTleDownloadClick(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure dgPlanetDrawCell(Sender: TObject; aCol, aRow: integer;
      aRect: TRect; aState: TGridDrawState);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCloseQuery(Sender: TObject; var CanClose: boolean);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure BtnRefreshClick(Sender: TObject);
    procedure BtnCloseClick(Sender: TObject);
    procedure GridMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: integer);
    procedure FormDestroy(Sender: TObject);
    procedure GridDblClick(Sender: TObject);
    procedure Label9Click(Sender: TObject);
    procedure PageControl1Change(Sender: TObject);
    procedure BtnSaveClick(Sender: TObject);
    procedure EcliPanelClick(Sender: TObject);
    procedure BtnResetClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure ComboBox2Change(Sender: TObject);
    procedure BtnHelpClick(Sender: TObject);
    procedure BtnPrintClick(Sender: TObject);
    procedure Date1Change(Sender: TObject);
    procedure Date2Change(Sender: TObject);
    procedure SatPanelClick(Sender: TObject);
    procedure tle1Change(Sender: TObject);
    procedure TleCheckListClickCheck(Sender: TObject);
  private
    { Private declarations }
    initial, lockclick: boolean;
    ShowImage: Tf_image;
    Fplanet: Tplanet;
    FGetChartConfig: TScFunc;
    Fupdchart: TScFunc;
    Feclipsepath: string;
    deltajd: double;
    dat11, dat12, dat13, dat21, dat22, dat23, dat31, dat32, dat33: double;
    dat41, dat51, dat61, dat71, dat72, dat73: double;
    dat14, dat24, dat34, dat74, west, east, title: string;
    century_Solar, century_Lunar: string;
    appmsg: array[1..nummsg] of string;
    cometid, astid: array[0..maxcombo] of string;
    PlanetGraphs: array[1..9] of TBitmap;
    procedure Sattitle;
    procedure Lunartitle;
    procedure Solartitle;
    procedure planettitle;
    procedure crepusculetitle;
    procedure cometetitle;
    procedure asteroidtitle;
    function SetObjCoord(jd, ra, Dec: double): TObject;
    procedure FreeCoord(var gr: Tstringgrid);
    procedure InitRiseCell(var gr: Tstringgrid);
    //    procedure PlanetRiseCell(var gr : Tstringgrid; i,irc : integer; hr,ht,hs,azr,azs,jda,h,ar,de : double);
    procedure SaveGrid(grid: tstringgrid);
    procedure Gridtoprinter(grid: tstringgrid);
    procedure RefreshAll;
    procedure RefreshTwilight;
    procedure RefreshPlanet;
    procedure RefreshComet;
    procedure RefreshAsteroid;
    procedure RefreshLunarEclipse;
    procedure RefreshSolarEclipse;
    procedure RefreshPlanetGraph;
    procedure RefreshSatellite;
    procedure DownloadTle;
    procedure TLEfeedback(txt: string);
    procedure UpdTleList;
  public
    { Public declarations }
    cdb: Tcdcdb;
    cmain: Tconf_main;
    AzNorth: boolean;
    config: Tconf_skychart;
    procedure SetLang;
    property planet: Tplanet read Fplanet write Fplanet;
    property EclipsePath: string read Feclipsepath write Feclipsepath;
    property OnGetChartConfig: TScFunc read FGetChartConfig write FGetChartConfig;
    property OnUpdateChart: TScFunc read Fupdchart write Fupdchart;
  end;

var
  f_calendar: Tf_calendar;

implementation

{$R *.lfm}

uses u_util, u_projection, Clipbrd, LazUTF8, LazFileUtils;

type
  {For Planet graphs}
  TPGScaledTime = record
    Valid: boolean;
    ScTime: integer;
  end;
  TPGScaledTimeRow = array[0..8] of TPGScaledTime;

const
  maxstep = 1000;
  MonthLst: array [1..12] of string =
    ('Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec');

procedure Tf_calendar.FormCreate(Sender: TObject);
var
  yy, mm, dd: word;
  i: integer;
begin
  SatGrid.ColWidths[0] := 130;
  SatGrid.ColWidths[1] := 120;
  ScaleDPI(Self);
  DownloadDialog1.ScaleDpi:=UScaleDPI.scale;
  SetLang;
  config := Tconf_skychart.Create;
  AzNorth := True;
  if VerboseMsg then
    WriteTrace('Create Tf_image');
  ShowImage := Tf_image.Create(self);
  ShowImage.Position := poScreenCenter;
  decodedate(now, yy, mm, dd);
  date1.JD := jdd(yy, mm, dd, 0);
  date2.JD := date1.JD + 5;
  time.Time := now;
  LabelTle.Caption := '';
  initial := True;
  for i := low(PlanetGraphs) to high(PlanetGraphs) do
  begin
    PlanetGraphs[i] := TBitmap.Create;
    PlanetGraphs[i].SetSize(dgPlanet.DefaultColWidth, dgPlanet.DefaultRowHeight);
  end;
{$ifdef mswindows}
  SaveDialog1.Options := SaveDialog1.Options - [ofNoReadOnlyReturn];
  { TODO : check readonly test on Windows }
{$endif}
{$ifdef lclcocoa}
  { TODO : check cocoa dark theme color}
  if DarkTheme then begin
    TwilightGrid.FixedColor := clBackground;
    SoleilGrid.FixedColor := clBackground;
    MercureGrid.FixedColor := clBackground;
    VenusGrid.FixedColor := clBackground;
    LuneGrid.FixedColor := clBackground;
    MarsGrid.FixedColor := clBackground;
    JupiterGrid.FixedColor := clBackground;
    SaturneGrid.FixedColor := clBackground;
    UranusGrid.FixedColor := clBackground;
    NeptuneGrid.FixedColor := clBackground;
    PlutonGrid.FixedColor := clBackground;
    CometGrid.FixedColor := clBackground;
    AsteroidGrid.FixedColor := clBackground;
    SolarGrid.FixedColor := clBackground;
    LunarGrid.FixedColor := clBackground;
    SatGrid.FixedColor := clBackground;
  end;
{$endif}
end;

procedure Tf_calendar.FormCloseQuery(Sender: TObject; var CanClose: boolean);
begin
  CanClose := True;
  if BtnReset.Visible then
  begin
    if MessageDlg(Format(rsWarningTheCu, [rsResetChart]), mtWarning,
      mbYesNo, 0) = mrNo then
      CanClose := False;
  end;
end;

procedure Tf_calendar.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  initial := True;
end;

procedure Tf_calendar.FormDestroy(Sender: TObject);
var
  i: integer;
begin
  try
    FreeCoord(Solargrid);
    FreeCoord(Lunargrid);
    FreeCoord(SatGrid);
    FreeCoord(TwilightGrid);
    FreeCoord(SoleilGrid);
    FreeCoord(MercureGrid);
    FreeCoord(VenusGrid);
    FreeCoord(LuneGrid);
    FreeCoord(MarsGrid);
    FreeCoord(JupiterGrid);
    FreeCoord(SaturneGrid);
    FreeCoord(UranusGrid);
    FreeCoord(NeptuneGrid);
    FreeCoord(PlutonGrid);
    FreeCoord(Cometgrid);
    FreeCoord(Asteroidgrid);
    ShowImage.Free;
    config.Free;
    for i := low(PlanetGraphs) to high(PlanetGraphs) do
      PlanetGraphs[i].Free;
  except
    writetrace('error destroy ' + Name);
  end;
end;

procedure Tf_calendar.FormShow(Sender: TObject);
var
  i: integer;
begin
  // apply graph setting (config is not available in formcreate)
  dgPlanet.DefaultRowHeight := config.CalGraphHeight;
  for i := low(PlanetGraphs) to high(PlanetGraphs) do
  begin
    PlanetGraphs[i].SetSize(dgPlanet.DefaultColWidth, dgPlanet.DefaultRowHeight);
  end;
  if initial then
  begin
    date1.JD := jd(config.CurYear, config.CurMonth, config.CurDay, 0);
    date2.JD := date1.JD + 14;
    deltajd := date2.JD - date1.JD;
    time.Time := config.CurTime / 24;
    CometFilter.Text := 'C/' + IntToStr(config.CurYear);
    RefreshAll;
    initial := False;
  end;
  BtnReset.Visible := False;
  BtnPrint.Visible := (Printer.PrinterIndex >= 0);
  if cdb = nil then
  begin
    comet.TabVisible := False;
    Asteroids.TabVisible := False;
  end;
  if cmain = nil then
    BtnTleDownload.Visible := False;
  lockclick := True;
end;

procedure Tf_calendar.Date1Change(Sender: TObject);
begin
  if deltajd <= 0 then
    exit;
  if date2.JD <= date1.JD then
    date2.JD := date1.JD + deltajd;
  deltajd := date2.JD - date1.JD;
end;

procedure Tf_calendar.Date2Change(Sender: TObject);
begin
  if deltajd <= 0 then
    exit;
  if date2.JD <= date1.JD then
    date1.JD := date2.JD - deltajd;
  deltajd := date2.JD - date1.JD;
end;

procedure Tf_calendar.SetLang;
var
  Alabels: TDatesLabelsArray;
begin
  Caption := rsCalendar;
  Date1.Caption := rsJDCalendar;
  Date2.Caption := rsJDCalendar;
  Alabels.Mon := rsMonday;
  Alabels.Tue := rsTuesday;
  Alabels.Wed := rsWednesday;
  Alabels.Thu := rsThursday;
  Alabels.Fri := rsFriday;
  Alabels.Sat := rsSaturday;
  Alabels.Sun := rsSunday;
  Alabels.jd := rsJulianDay;
  Alabels.today := rsToday;
  Date1.labels := Alabels;
  Date2.labels := Alabels;
  east := rsEast;
  west := rsWest;
  EcliPanel.Hint := 'http://eclipse.gsfc.nasa.gov';
  mercure.Caption := pla[1];
  venus.Caption := pla[2];
  mars.Caption := pla[4];
  jupiter.Caption := pla[5];
  saturne.Caption := pla[6];
  uranus.Caption := pla[7];
  neptune.Caption := pla[8];
  pluton.Caption := pla[9];
  psoleil.Caption := pla[10];
  plune.Caption := pla[11];
  tsPGraphs.Caption := rsGraphs;
  Label1.Caption := rsDateFrom;
  Label2.Caption := rsTo;
  Label5.Caption := rsAt;
  Label3.Caption := rsBy;
  Label4.Caption := rsDays;
  Label9.Caption := rsSatellitesCa + ' QuickSat by Mike McCants';
  label9.Hint := URL_QUICKSAT;
  label10.Caption := rsMinimalAltit;
  BtnRefresh.Caption := rsRefresh;
  BtnHelp.Caption := rsHelp;
  BtnClose.Caption := rsClose;
  BtnSave.Caption := rsSaveToFile;
  BtnPrint.Caption := rsPrint;
  BtnCopyClip.Caption := rsCopy;
  BtnReset.Caption := rsResetChart;
  twilight.Caption := rsTwilight;
  planets.Caption := rsSolarSystem;
  comet.Caption := rsComet;
  Asteroids.Caption := rsAsteroid;
  Button1.Caption := rsFilter;
  Button2.Caption := rsFilter;
  BtnTleDownload.Caption := rsDownloadTLE;
  Button4.Caption := '<- ' + rsBrightest;
  Solar.Caption := rsSolarEclipse;
  Lunar.Caption := rsLunarEclipse;
  Satellites.Caption := rsArtificialSa;
  Label8.Caption := rsChart2;
  Label7.Caption := rsLimitingMagn;
  Label6.Caption := 'TLE';
  fullday.Caption := rsIncludeDayTi;
  appmsg[1] := rsRA;
  appmsg[2] := rsDE;
  appmsg[3] := rsMagn;
  appmsg[4] := rsDiam;
  appmsg[5] := rsIllum;
  appmsg[6] := rsRise;
  appmsg[7] := rsTransit;
  appmsg[8] := rsSet;
  appmsg[9] := rsMorningTwili;
  appmsg[10] := rsEveningTwili;
  appmsg[11] := rsDate;
  appmsg[12] := rsAstronomical;
  appmsg[13] := rsNautical;
  appmsg[14] := rsTwilight;
  appmsg[15] := rsMorning;
  appmsg[16] := rsEvening;
  appmsg[17] := rsElong;
  appmsg[18] := rsPhase;
  appmsg[19] := rsWarningCalcu;
  appmsg[20] := rsDatesMayTake;
  appmsg[21] := rsAz;
  appmsg[22] := rsAlt;
  appmsg[23] := rsUT;
  appmsg[24] := rsMax;
  appmsg[25] := rsType;
  appmsg[26] := rsSaros;
  appmsg[27] := rsGamma;
  appmsg[28] := rsMagnitudeEcl;
  appmsg[29] := rsGreatest;
  appmsg[30] := rsEclipse;
  appmsg[31] := rsLatitude;
  appmsg[32] := rsLongitude;
  appmsg[33] := rsSunAlt;
  appmsg[34] := rsPathWidth;
  appmsg[35] := rsDuration;
  appmsg[36] := rsPenumbra;
  appmsg[37] := rsUmbra;
  appmsg[38] := rsSemi;
  appmsg[39] := rsDuration;
  appmsg[40] := rsPartial;
  appmsg[41] := rsTotal;
  appmsg[42] := rsSatellite;
  appmsg[43] := rsRange;
  appmsg[44] := '+/-';
  appmsg[45] := rsDir;
  appmsg[46] := rsCoord;
  appmsg[47] := rsMap;
  title := Caption;
  crepusculetitle;
  cometetitle;
  asteroidtitle;
  planettitle;
  Solartitle;
  LunarTitle;
  SatTitle;
  if ShowImage <> nil then
    ShowImage.SetLang;
  SetHelp(self, hlpCalInput);
  SetHelp(twilight, hlpCalTw);
  SetHelp(planets, hlpCalPla);
  SetHelp(comet, hlpCalCom);
  SetHelp(Asteroids, hlpCalAst);
  SetHelp(Solar, hlpCalSol);
  SetHelp(Lunar, hlpCalLuna);
  SetHelp(Satellites, hlpCalSat);
end;

procedure Tf_calendar.cometetitle;
begin
  with cometgrid do
  begin
    cells[9, 0] := appmsg[14];
    cells[10, 0] := appmsg[15];
    cells[11, 0] := appmsg[14];
    cells[12, 0] := appmsg[16];
    cells[0, 1] := appmsg[11];
    cells[1, 1] := appmsg[1];
    cells[2, 1] := appmsg[2];
    cells[3, 1] := appmsg[3];
    cells[4, 1] := appmsg[17];
    cells[5, 1] := appmsg[18];
    cells[6, 1] := appmsg[6];
    cells[7, 1] := appmsg[7];
    cells[8, 1] := appmsg[8];
    cells[9, 1] := appmsg[12];
    cells[10, 1] := appmsg[13];
    cells[11, 1] := appmsg[13];
    cells[12, 1] := appmsg[12];
  end;
end;

procedure Tf_calendar.asteroidtitle;
begin
  with asteroidgrid do
  begin
    //cells[9,0]:=appmsg[14];
    //cells[10,0]:=appmsg[15];
    //cells[11,0]:=appmsg[14];
    //cells[12,0]:=appmsg[16];
    cells[0, 1] := appmsg[11];
    cells[1, 1] := appmsg[1];
    cells[2, 1] := appmsg[2];
    cells[3, 1] := appmsg[3];
    cells[4, 1] := appmsg[17];
    cells[5, 1] := appmsg[18];
    cells[6, 1] := appmsg[6];
    cells[7, 1] := appmsg[7];
    cells[8, 1] := appmsg[8];
  end;
end;

procedure Tf_calendar.crepusculetitle;
begin
  with twilightgrid do
  begin
    cells[0, 0] := '';
    cells[1, 0] := rsMorningTwili;
    cells[2, 0] := '';
    cells[3, 0] := '';
    cells[4, 0] := rsEveningTwili;
    cells[5, 0] := '';
    cells[6, 0] := '';
    cells[7, 0] := rsDarkNight;
    cells[8, 0] := '';
    cells[9, 0] := rsMoon;
    cells[0, 1] := rsDate;
    cells[1, 1] := rsAstronomical;
    cells[2, 1] := rsNautical;
    cells[3, 1] := rsCivil;
    cells[4, 1] := rsCivil;
    cells[5, 1] := rsNautical;
    cells[6, 1] := rsAstronomical;
    cells[7, 1] := rsStart;
    cells[8, 1] := rsEnd;
    cells[9, 1] := rsIllum;
  end;
end;

procedure Tf_calendar.planettitle;
begin
  with Soleilgrid do
  begin
    cells[1, 1] := appmsg[1];
    cells[2, 1] := appmsg[2];
    cells[3, 1] := appmsg[3];
    cells[4, 1] := appmsg[4];
    cells[5, 1] := appmsg[5];
    cells[6, 1] := appmsg[6];
    cells[7, 1] := appmsg[7];
    cells[8, 1] := appmsg[8];
    cells[9, 1] := appmsg[21];
    cells[10, 1] := appmsg[22];
  end;
  with Mercuregrid do
  begin
    cells[1, 1] := appmsg[1];
    cells[2, 1] := appmsg[2];
    cells[3, 1] := appmsg[3];
    cells[4, 1] := appmsg[4];
    cells[5, 1] := appmsg[5];
    cells[6, 1] := appmsg[6];
    cells[7, 1] := appmsg[7];
    cells[8, 1] := appmsg[8];
    cells[9, 1] := appmsg[21];
    cells[10, 1] := appmsg[22];
  end;
  with venusgrid do
  begin
    cells[1, 1] := appmsg[1];
    cells[2, 1] := appmsg[2];
    cells[3, 1] := appmsg[3];
    cells[4, 1] := appmsg[4];
    cells[5, 1] := appmsg[5];
    cells[6, 1] := appmsg[6];
    cells[7, 1] := appmsg[7];
    cells[8, 1] := appmsg[8];
    cells[9, 1] := appmsg[21];
    cells[10, 1] := appmsg[22];
  end;
  with lunegrid do
  begin
    cells[1, 1] := appmsg[1];
    cells[2, 1] := appmsg[2];
    cells[3, 1] := appmsg[3];
    cells[4, 1] := appmsg[4];
    cells[5, 1] := appmsg[5];
    cells[6, 1] := appmsg[6];
    cells[7, 1] := appmsg[7];
    cells[8, 1] := appmsg[8];
    cells[9, 1] := appmsg[21];
    cells[10, 1] := appmsg[22];
  end;
  with Marsgrid do
  begin
    cells[1, 1] := appmsg[1];
    cells[2, 1] := appmsg[2];
    cells[3, 1] := appmsg[3];
    cells[4, 1] := appmsg[4];
    cells[5, 1] := appmsg[5];
    cells[6, 1] := appmsg[6];
    cells[7, 1] := appmsg[7];
    cells[8, 1] := appmsg[8];
    cells[9, 1] := appmsg[21];
    cells[10, 1] := appmsg[22];
  end;
  with jupitergrid do
  begin
    cells[1, 1] := appmsg[1];
    cells[2, 1] := appmsg[2];
    cells[3, 1] := appmsg[3];
    cells[4, 1] := appmsg[4];
    cells[5, 1] := appmsg[5];
    cells[6, 1] := appmsg[6];
    cells[7, 1] := appmsg[7];
    cells[8, 1] := appmsg[8];
    cells[9, 1] := appmsg[21];
    cells[10, 1] := appmsg[22];
  end;
  with saturnegrid do
  begin
    cells[1, 1] := appmsg[1];
    cells[2, 1] := appmsg[2];
    cells[3, 1] := appmsg[3];
    cells[4, 1] := appmsg[4];
    cells[5, 1] := appmsg[5];
    cells[6, 1] := appmsg[6];
    cells[7, 1] := appmsg[7];
    cells[8, 1] := appmsg[8];
    cells[9, 1] := appmsg[21];
    cells[10, 1] := appmsg[22];
  end;
  with uranusgrid do
  begin
    cells[1, 1] := appmsg[1];
    cells[2, 1] := appmsg[2];
    cells[3, 1] := appmsg[3];
    cells[4, 1] := appmsg[4];
    cells[5, 1] := appmsg[5];
    cells[6, 1] := appmsg[6];
    cells[7, 1] := appmsg[7];
    cells[8, 1] := appmsg[8];
    cells[9, 1] := appmsg[21];
    cells[10, 1] := appmsg[22];
  end;
  with neptunegrid do
  begin
    cells[1, 1] := appmsg[1];
    cells[2, 1] := appmsg[2];
    cells[3, 1] := appmsg[3];
    cells[4, 1] := appmsg[4];
    cells[5, 1] := appmsg[5];
    cells[6, 1] := appmsg[6];
    cells[7, 1] := appmsg[7];
    cells[8, 1] := appmsg[8];
    cells[9, 1] := appmsg[21];
    cells[10, 1] := appmsg[22];
  end;
  with plutongrid do
  begin
    cells[1, 1] := appmsg[1];
    cells[2, 1] := appmsg[2];
    cells[3, 1] := appmsg[3];
    cells[4, 1] := appmsg[4];
    cells[5, 1] := appmsg[5];
    cells[6, 1] := appmsg[6];
    cells[7, 1] := appmsg[7];
    cells[8, 1] := appmsg[8];
    cells[9, 1] := appmsg[21];
    cells[10, 1] := appmsg[22];
  end;
end;

procedure Tf_calendar.Solartitle;
begin
  with solargrid do
  begin
    cells[0, 1] := appmsg[11];
    cells[1, 1] := appmsg[47];
    cells[2, 0] := appmsg[23];
    cells[2, 1] := appmsg[24];
    cells[3, 1] := appmsg[25];
    cells[4, 1] := appmsg[26];
    cells[5, 1] := appmsg[27];
    cells[6, 1] := appmsg[28];
    cells[7, 0] := appmsg[29];
    cells[7, 1] := appmsg[31];
    cells[8, 0] := appmsg[30];
    cells[8, 1] := appmsg[32];
    cells[9, 1] := appmsg[33];
    cells[10, 1] := appmsg[34];
    cells[11, 1] := appmsg[35];

  end;
end;

procedure Tf_calendar.Lunartitle;
begin
  with Lunargrid do
  begin
    cells[0, 1] := appmsg[11];
    cells[1, 0] := appmsg[23];
    cells[1, 1] := appmsg[24];
    cells[2, 1] := appmsg[25];
    cells[3, 1] := appmsg[26];
    cells[4, 1] := appmsg[27];
    cells[5, 0] := appmsg[36];
    cells[5, 1] := appmsg[28];
    cells[6, 0] := appmsg[37];
    cells[6, 1] := appmsg[28];
    cells[7, 0] := appmsg[39];
    cells[7, 1] := appmsg[40];
    cells[8, 0] := appmsg[39];
    cells[8, 1] := appmsg[41];
  end;
end;

procedure Tf_calendar.Sattitle;
begin
  with Satgrid do
  begin
    cells[0, 1] := appmsg[11];
    cells[1, 1] := appmsg[42];
    cells[2, 1] := appmsg[3];
    cells[3, 1] := appmsg[21];
    cells[4, 1] := appmsg[22];
    cells[5, 1] := appmsg[43];
    cells[6, 1] := appmsg[1];
    cells[7, 1] := appmsg[2];
    cells[8, 1] := appmsg[44];
    cells[9, 1] := appmsg[45];
  end;
end;

function Tf_calendar.SetObjCoord(jd, ra, Dec: double): TObject;
var
  p: TObjCoord;
begin
  p := TObjCoord.Create;
  p.jd := jd;
  p.ra := ra;
  p.Dec := Dec;
  Result := p;
end;

procedure Tf_calendar.FreeCoord(var gr: Tstringgrid);
var
  i, j: integer;
begin
  try
    if gr <> nil then
      with gr as Tstringgrid do
        if rowcount >= 3 then
          for i := 2 to rowcount - 1 do
            for j := 0 to colcount - 1 do
              if Objects[j, i] <> nil then
                Objects[j, i].Free;
  except
    gr.Cells[0, 0] := '';
  end;
end;

procedure Tf_calendar.InitRiseCell(var gr: Tstringgrid);
var
  i: integer;
begin
  with gr do
    for i := 2 to rowcount - 1 do
    begin
      cells[6, i] := '';
      cells[7, i] := '';
      cells[8, i] := '';
    end;
end;

procedure Tf_calendar.RefreshSolarEclipse;
var
  f: textfile;
  buf, mm, century, pathimage: string;
  h, jda: double;
  i, n, a, m, j: integer;
begin
  dat41 := date1.JD;
  djd(dat41, j, m, a, h);
  if j > 0 then
  begin
    j := j - 1;
    century := padzeros(IntToStr(1 + ((abs(j)) div 100)), 2);
  end
  else
  begin
    century := padzeros(IntToStr(((abs(j)) div 100)), 2);
    century := '-' + century;
  end;
  if century_Solar <> century then
  begin // lire le fichier la premiere fois
    FreeCoord(Solargrid);
    solargrid.RowCount := 3;
    for i := 0 to solargrid.ColCount - 1 do
      solargrid.Cells[i, 2] := '';
    if not fileexists(slash(Feclipsepath) + 'solar' + century + '.txt') then
      exit;
    screen.cursor := crHourglass;
    try
      Filemode := 0;
      Assignfile(f, slash(Feclipsepath) + 'solar' + century + '.txt');
      reset(f);
      i := 2;
      //solargrid.visible:=false;
      repeat
        Readln(f, buf);
        with solargrid do
        begin
          RowCount := i + 1;
          cells[0, i] := copy(buf, 1, 12);
          cells[2, i] := copy(buf, 15, 5);
          cells[3, i] := copy(buf, 23, 3);
          cells[4, i] := copy(buf, 26, 4);
          cells[5, i] := copy(buf, 31, 6);
          cells[6, i] := copy(buf, 39, 5);
          cells[7, i] := copy(buf, 46, 5);
          cells[8, i] := copy(buf, 52, 6);
          cells[9, i] := copy(buf, 60, 2);
          cells[10, i] := copy(buf, 63, 4);
          cells[11, i] := copy(buf, 69, 6);
          pathimage := slash(Feclipsepath) + 'SE' + stringreplace(cells[0, i], blank, '', [rfReplaceAll]) +
            copy(cells[3, i], 1, 1) + '.png';
          if fileexists(pathimage) then
            cells[1, i] := appmsg[47]
          else
            cells[1, i] := '';
          a := strtointdef(copy(cells[0, i], 1, 5), -9999);
          mm := copy(cells[0, i], 7, 3);
          m := 0;
          for n := 1 to 12 do
            if mm = monthlst[n] then
            begin
              m := n;
              break;
            end;
          j := strtointdef(copy(cells[0, i], 11, 2), 0);
          if (a <> -9999) and (m <> 0) and (j <> 0) then
          begin
            h := strtofloat(copy(cells[2, i], 1, 2)) + strtofloat(copy(cells[2, i], 4, 2)) / 60;
            jda := jd(a, m, j, h);
            objects[0, i] := SetObjCoord(jda, -1000, -1000);
          end;
        end;
        i := i + 1;
      until EOF(f);
      century_Solar := century;
    finally
      //solargrid.visible:=true;
      Closefile(f);
      screen.cursor := crDefault;
    end;
  end; // fin lecture fichier
  djd(dat41, a, m, j, h);
  with solargrid do
  begin
    for i := 2 to rowcount - 1 do
    begin
      if StrToInt(copy(cells[0, i], 1, 5)) = a then
      begin
        toprow := i;
        break;
      end;
      if StrToInt(copy(cells[0, i], 1, 5)) > a then
      begin
        toprow := i - 1;
        break;
      end;
    end;
  end;
end;

procedure Tf_calendar.RefreshLunarEclipse;
var
  f: textfile;
  buf, mm, century, dbuf: string;
  h, jda: double;
  i, n, a, m, j, d: integer;
begin
  dat51 := date1.jd;
  djd(dat51, j, m, a, h);
  if j > 0 then
  begin
    j := j - 1;
    century := padzeros(IntToStr(1 + ((abs(j)) div 100)), 2);
  end
  else
  begin
    century := padzeros(IntToStr(((abs(j)) div 100)), 2);
    century := '-' + century;
  end;
  if century_Lunar <> century then
  begin // lire le fichier la premiere fois
    FreeCoord(Lunargrid);
    lunargrid.RowCount := 3;
    for i := 0 to lunargrid.ColCount - 1 do
      lunargrid.Cells[i, 2] := '';
    if not fileexists(slash(Feclipsepath) + 'lunar' + century + '.txt') then
      exit;
    screen.cursor := crHourglass;
    try
      Filemode := 0;
      Assignfile(f, slash(Feclipsepath) + 'lunar' + century + '.txt');
      reset(f);
      i := 2;
      //lunargrid.visible:=false;
      repeat
        Readln(f, buf);
        with lunargrid do
        begin
          RowCount := i + 1;
          cells[0, i] := copy(buf, 1, 12);
          cells[1, i] := copy(buf, 15, 5);
          cells[2, i] := copy(buf, 21, 3);
          cells[3, i] := copy(buf, 25, 3);
          cells[4, i] := copy(buf, 30, 6);
          cells[5, i] := copy(buf, 38, 5);
          cells[6, i] := copy(buf, 44, 6);
          dbuf := copy(buf, 51, 4);
          if pos('m', dbuf) > 0 then
          begin
            d := strtointdef(trim(StringReplace(dbuf, 'm', '', [rfReplaceAll])), -1);
            if d > 0 then
            begin
              dbuf := IntToStr(2 * d) + 'm';
            end;
          end;
          cells[7, i] := dbuf;
          dbuf := copy(buf, 56, 4);
          if pos('m', dbuf) > 0 then
          begin
            d := strtointdef(trim(StringReplace(dbuf, 'm', '', [rfReplaceAll])), -1);
            if d > 0 then
            begin
              dbuf := IntToStr(2 * d) + 'm';
            end;
          end;
          cells[8, i] := dbuf;
          a := strtointdef(copy(cells[0, i], 1, 5), -9999);
          mm := copy(cells[0, i], 7, 3);
          m := 0;
          for n := 1 to 12 do
            if mm = monthlst[n] then
            begin
              m := n;
              break;
            end;
          j := strtointdef(copy(cells[0, i], 11, 2), 0);
          if (a <> -9999) and (m <> 0) and (j <> 0) then
          begin
            h := strtofloat(copy(cells[1, i], 1, 2)) + strtofloat(copy(cells[1, i], 4, 2)) / 60;
            jda := jd(a, m, j, h);
            objects[0, i] := SetObjCoord(jda, -1000, -1000);
          end;
        end;
        i := i + 1;
      until EOF(f);
      century_Lunar := century;
    finally
      //lunargrid.visible:=true;
      Closefile(f);
      screen.cursor := crDefault;
    end;
  end; // fin lecture fichier
  djd(dat51, a, m, j, h);
  with lunargrid do
  begin
    for i := 2 to rowcount - 1 do
    begin
      if StrToInt(copy(cells[0, i], 1, 5)) = a then
      begin
        toprow := i;
        break;
      end;
      if StrToInt(copy(cells[0, i], 1, 5)) > a then
      begin
        toprow := i - 1;
        break;
      end;
    end;
  end;
end;

procedure Tf_calendar.RefreshSatellite;
var
  f: textfile;
  buf, mm, y, d, ed, hh, mi, ss, dat1, s1, s2: string;
  prgdir,  srcdir, wrkdir: string;
  h, jda, ar, de, ma, tzo: double;
  th,tm,ts,tms: word;
  i, k, a, m, j: integer;
const
  mois: array[1..12] of string =
    ('Jan ', 'Feb ', 'Mar ', 'Apr ', 'May ', 'June', 'July', 'Aug ', 'Sept', 'Oct ', 'Nov ', 'Dec ');
begin
  prgdir := slash(appdir) + slash('data') + slash('quicksat');
  config.tz.JD := date1.JD;
  tzo := config.tz.SecondsOffset / 3600;
  dat61 := date1.jd;
  djd(dat61, j, m, a, h);
  FreeCoord(SatGrid);
  SatGrid.RowCount := 2;
  if j < 1956 then
    exit;
  try
    screen.Cursor := crHourGlass;
    Application.ProcessMessages;
    ed := IntToStr(a + round(date2.jd - date1.jd));
    srcdir := SysToUTF8(slash(prgdir));
    wrkdir := SysToUTF8(slash(satdir));
    DeleteFile(slash(satdir) + 'satlist.out');
    DeleteFile(slash(satdir) + 'quicksat.ctl');
    DeleteFile(slash(satdir) + 'quicksat.mag');
    if not fileexists(slash(satdir) + 'qs.mag') then
      CopyFile(srcdir + 'qs.mag', wrkdir + 'qs.mag');
    SatelliteList(IntToStr(j), IntToStr(m), IntToStr(a), ed, maglimit.Text,
      tle1.Text, SatDir, prgdir, formatfloat(f1, config.tz.SecondsOffset / 3600),
      config.ObsName, MinSatAlt.Text, config.ObsLatitude, config.ObsLongitude,
      config.ObsAltitude, 0, 0, 0, 0, fullday.Checked, False);
    if not Fileexists(slash(SatDir) + 'satlist.out') then
    begin
      ShowMessage(rsCannotComput + crlf + rsPleaseDownlo);
      exit;
    end;
    Assignfile(f, slash(SatDir) + 'satlist.out');
    reset(f);
    i := 2;
    Readln(f, buf);
    Readln(f, buf);
    m := 1;
    a := 1;
    j := 1;
    repeat
      Readln(f, buf);
      if copy(buf, 1, 3) = '***' then
      begin
        SatGrid.RowCount := i + 1;
        y := copy(buf, 6, 4);
        a := StrToInt(y);
        mm := copy(buf, 11, 4);
        for k := 1 to 12 do
          if mm = mois[k] then
            m := k;
        d := copy(buf, 16, 2);
        j := StrToInt(d);
        Readln(f, buf);
        Readln(f, buf);
        continue;
      end;
      if trim(buf) = '' then
        continue;
      hh := padzeros(copy(buf, 1, 2), 2);
      mi := padzeros(copy(buf, 4, 2), 2);
      ss := padzeros(copy(buf, 7, 2), 2);
      h := StrToInt(hh) + StrToInt(mi) / 60 + StrToInt(ss) / 3600;
      jda := jd(a, m, j, h - tzo);
      config.tz.JD := jda;
      djd(jda+config.tz.SecondsOffset/SecsPerDay,a,m,j,h);
      DecodeTime(h/24,th,tm,ts,tms);
      dat1 := padzeros(IntToStr(a), 4) + '-' + padzeros(IntToStr(m), 2) + '-' + padzeros(IntToStr(j), 2) +
              ' ' +  padzeros(IntToStr(th), 2) + ':' +  padzeros(IntToStr(tm), 2) + ':' +  padzeros(IntToStr(ts), 2);
      with satgrid do
      begin
        RowCount := i + 1;
        cells[0, i] := dat1;
        cells[1, i] := copy(buf, 66, 99);
        ma := strtofloat(copy(buf, 26, 4));
        if ma > 17.9 then
        begin
          ma := (ma - 20 + 6);
          str(ma: 4: 1, s1);
          cells[2, i] := '(' + s1 + ')';
        end
        else
          cells[2, i] := copy(buf, 26, 4);
        cells[3, i] := copy(buf, 14, 3);
        cells[4, i] := copy(buf, 18, 2);
        cells[5, i] := copy(buf, 46, 4);
        s1 := padzeros(copy(buf, 51, 2), 2);
        s2 := padzeros(copy(buf, 53, 2), 2);
        ar := (StrToInt(s1) + StrToInt(s2) / 60) * 15 * deg2rad;
        cells[6, i] := s1 + 'h' + s2 + 'm';
        cells[7, i] := copy(buf, 55, 5);
        de := strtofloat(cells[7, i]) * deg2rad;
        cells[8, i] := copy(buf, 9, 4);
        cells[9, i] := copy(buf, 22, 3);
        objects[0, i] := SetObjCoord(jda, ar, de);
      end;
      i := i + 1;
    until EOF(f);
    jda := 99999999;
  finally
{$I-}
    screen.Cursor := crDefault;
    Closefile(f);
    i := ioresult;
{$I+}
  end;
end;

procedure Tf_calendar.RefreshAll;
var
  z1, z2: string;
begin
  RefreshTwilight;
  RefreshPlanet;
  //  RefreshSolarEclipse;
  //  RefreshLunarEclipse;
  config.tz.JD := date1.JD;
  z1 := config.tz.ZoneName;
  config.tz.JD := date2.JD;
  z2 := config.tz.ZoneName;
  if z1 <> z2 then
    z1 := z1 + '/' + z2;
  Caption := title + blank + config.Obsname + blank + rsTimeZone + '=' + TzGMT2UTC(z1);
end;

procedure Tf_calendar.RefreshTwilight;
type
  tttr = record
    t: double;
    tr: word;
  end;
var
  jda, jd0, jd1, jd2, h, hh, tat1, tat2, tmr, tms, tds, tde: double;
  hp1, hp2, ars, des, dist, diam, jdt_ut: double;
  jdr, jdt, jds, rar, der, rat, det, ras: double;
  dkm, phase, illum: double;
  a, m, d, s, i, nj, irc, j: integer;
  mr, mt, ms, azr, azs: string;
  ttr: array[0..5] of tttr;
  ctr: tttr;
  ttrsorted, night, moonup, dark, newdark: boolean;
begin
  screen.cursor := crHourglass;
  try
    FreeCoord(TwilightGrid);
    dat11 := date1.JD;
    dat12 := date2.JD;
    dat13 := time.time;
    dat14 := step.Text;
    s := step.Value;
    djd(date1.JD, a, m, d, hh);
    config.tz.JD := date1.JD;
    config.TimeZone := config.tz.SecondsOffset / 3600;
    jdt_ut := DTminusUT(a, m, d, config) / 24;
    h := 12 - config.TimeZone;
    jd1 := jd(a, m, d, h);
    djd(date2.JD, a, m, d, hh);
    jd2 := jd(a, m, d, h);
    nj := round((jd2 - jd1) / s);
    if nj > maxstep then
      if MessageDlg(appmsg[19] + blank + IntToStr(nj) + blank + appmsg[20],
        mtConfirmation, [mbOK, mbCancel], 0) <> mrOk then
        exit;
    jda := jd1;
    i := 2;
    repeat
      djd(jda, a, m, d, h);
      jd0 := jd(a, m, d, 0);
      config.tz.JD := jda;
      config.timezone := config.tz.SecondsOffset / 3600;
      with TwilightGrid do
      begin
        RowCount := i + 1;
        cells[0, i] := isodate(a, m, d);
        Fplanet.Sun(jda + jdt_ut, ars, des, dist, diam);
        //  precession(jd2000,config.JDChart,ars,des);
        precession(jd2000, jda, ars, des);
        if (ars < 0) then
          ars := ars + pi2;
        objects[0, i] := SetObjCoord(jda, -999, -999);
        // crepuscule civil
        Time_Alt(jd0, ars, des, -6, hp1, hp2, config.ObsLatitude, config.ObsLongitude);
        if abs(hp1) < 90 then
        begin
          cells[3, i] := armtostr(rmod(hp1 + config.timezone + 24, 24));
          objects[3, i] := SetObjCoord(jda + (hp1 - h) / 24, -999, -999);
        end
        else
        begin
          cells[3, i] := '-';
          objects[3, i] := nil;
        end;
        if abs(hp1) < 90 then
        begin
          cells[4, i] := armtostr(rmod(hp2 + config.timezone + 24, 24));
          objects[4, i] := SetObjCoord(jda + (hp2 - h) / 24, -999, -999);
        end
        else
        begin
          cells[4, i] := '-';
          objects[4, i] := nil;
        end;
        // crepuscule nautique
        Time_Alt(jd0, ars, des, -12, hp1, hp2, config.ObsLatitude, config.ObsLongitude);
        if abs(hp1) < 90 then
        begin
          cells[2, i] := armtostr(rmod(hp1 + config.timezone + 24, 24));
          objects[2, i] := SetObjCoord(jda + (hp1 - h) / 24, -999, -999);
        end
        else
        begin
          cells[2, i] := '-';
          objects[2, i] := nil;
        end;
        if abs(hp1) < 90 then
        begin
          cells[5, i] := armtostr(rmod(hp2 + config.timezone + 24, 24));
          objects[5, i] := SetObjCoord(jda + (hp2 - h) / 24, -999, -999);
        end
        else
        begin
          cells[5, i] := '-';
          objects[5, i] := nil;
        end;
        // crepuscule astro
        Time_Alt(jd0, ars, des, -18, hp1, hp2, config.ObsLatitude, config.ObsLongitude);
        if abs(hp1) < 90 then
        begin
          tat1 := rmod(hp1 + config.timezone + 24, 24);
          cells[1, i] := armtostr(tat1);
          objects[1, i] := SetObjCoord(jda + (hp1 - h) / 24, -999, -999);
        end
        else
        begin
          tat1 := -99;
          cells[1, i] := '-';
          objects[1, i] := nil;
        end;
        if abs(hp1) < 90 then
        begin
          tat2 := rmod(hp2 + config.timezone + 24, 24);
          cells[6, i] := armtostr(tat2);
          objects[6, i] := SetObjCoord(jda + (hp2 - h) / 24, -999, -999);
        end
        else
        begin
          tat2 := -99;
          cells[6, i] := '-';
          objects[6, i] := nil;
        end;
        // Moon visibility
        Planet.PlanetRiseSet(11, jd0, AzNorth, mr, mt, ms, azr, azs, jdr, jdt, jds,
          rar, der, rat, det, ras, des, irc, config);
        case irc of
          0:
          begin  // moon rise and set
            if (tat1 > -99) and (tat2 > -99) then
            begin
              tmr := rmod((jdr - jd0) * 24 + config.TimeZone + 24, 24);
              tms := rmod((jds - jd0) * 24 + config.TimeZone + 24, 24);
              ttr[0].t := 0;
              ttr[0].tr := 0;    // 0h , no transition
              ttr[1].t := tat1;
              ttr[1].tr := 1; // morning twilight night->day
              ttr[2].t := tat2;
              ttr[2].tr := 2; // evening twilight day->night
              ttr[3].t := tmr;
              ttr[3].tr := 3;  // moon rise night->day
              ttr[4].t := tms;
              ttr[4].tr := 4;  // moon set day->night
              ttr[5].t := 24;
              ttr[5].tr := 0;    // 24h , no transition
              // sort by time
              repeat
                ttrsorted := True;
                for j := 1 to 5 do
                begin
                  if ttr[j - 1].t > ttr[j].t then
                  begin
                    ctr := ttr[j - 1];
                    ttr[j - 1] := ttr[j];
                    ttr[j] := ctr;
                    ttrsorted := False;
                  end;
                end;
              until ttrsorted;
              // state at 0h
              for j := 1 to 4 do
              begin
                if ttr[j].tr = 1 then
                begin
                  night := True;
                  break;
                end;
                if ttr[j].tr = 2 then
                begin
                  night := False;
                  break;
                end;
              end;
              for j := 1 to 4 do
              begin
                if ttr[j].tr = 3 then
                begin
                  moonup := False;
                  break;
                end;
                if ttr[j].tr = 4 then
                begin
                  moonup := True;
                  break;
                end;
              end;
              // search transitions
              tds := -1;
              tde := -1;
              for j := 1 to 4 do
              begin
                dark := night and (not moonup);
                if ttr[j].tr = 1 then
                  night := False;
                if ttr[j].tr = 2 then
                  night := True;
                if ttr[j].tr = 3 then
                  moonup := True;
                if ttr[j].tr = 4 then
                  moonup := False;
                newdark := night and (not moonup);
                if dark <> newdark then
                begin
                  if newdark then
                    tds := ttr[j].t
                  else
                    tde := ttr[j].t;
                end;
              end;
              if (tds > 0) then
              begin
                cells[7, i] := armtostr(tds);
                objects[7, i] := SetObjCoord(jda + (tds - h - config.timezone) / 24, -999, -999);
              end
              else
                cells[7, i] := '-';
              if (tde > 0) then
              begin
                cells[8, i] := armtostr(tde);
                objects[8, i] := SetObjCoord(jda + (tde - h - config.timezone) / 24, -999, -999);
              end
              else
                cells[8, i] := '-';
            end
            else
            begin
              cells[7, i] := '-';
              cells[8, i] := '-';
            end;
          end;
          1:
          begin // moon circumpolar
            cells[7, i] := '-';
            cells[8, i] := '-';
          end;
          2:
          begin // no moon rise
            cells[7, i] := cells[6, i];
            cells[8, i] := cells[1, i];
          end;
        end;
        // Moon illumination at midnight
        Planet.Moon(jda+0.5, rat, det, dist, dkm, diam, phase, illum,config);
        cells[9, i] := FormatFloat(f2, illum);
      end;
      jda := jda + s;
      i := i + 1;
    until jda > jd2;
  finally
    screen.cursor := crDefault;
  end;
end;

procedure Tf_calendar.RefreshPlanet;
var
  ar, de, dist, illum, phase, diam, jda, magn, dkm, q, az, ha, dp, xp, yp, zp, vel: double;
  i, ipla, nj: integer;
  s, a, m, d, irc: integer;
  jd1, jd2, jd0, h, jdr, jdt, jds, st0, hh: double;
  rar, der, rat, det, ras, des: double;
  jdt_ut: double;
  mr, mt, ms, azr, azs: string;

  procedure ComputeRow(gr: TstringGrid; ipla: integer);
  var
    PSat, aSat, bSat, beSat, sbSat: double;
  begin
    with gr do
    begin
      RowCount := i + 1;
      case ipla of
        1..9:
        begin
          planet.Planet(ipla, jda + jdt_ut, ar, de, dist, illum, phase, diam, magn, dp, xp, yp, zp, vel);
          precession(jd2000, config.JDChart, ar, de);
          if config.PlanetParalaxe then
            Paralaxe(st0, dist, ar, de, ar, de, q, config);
          if config.ApparentPos then
            apparent_equatorial(ar, de, config, True, False);
          if ipla = 6 then
          begin  // ring magn. correction
            planet.SatRing(jda + jdt_ut, PSat, aSat, bSat, beSat);
            sbSat := sin(deg2rad * abs(beSat));
            magn := magn - 2.6 * sbSat + 1.25 * sbSat * sbSat;
          end;
        end;
        10:
        begin
          Planet.Sun(jda + jdt_ut, ar, de, dist, diam);
          precession(jd2000, config.jdchart, ar, de);
          if config.PlanetParalaxe then
            Paralaxe(st0, dist, ar, de, ar, de, q, config);
          if config.ApparentPos then
            apparent_equatorial(ar, de, config, True, False);
          illum := 1;
          magn := -26.7;
        end;
        11:
        begin
          planet.Moon(jda + jdt_ut, ar, de, dist, dkm, diam, phase, illum,config);
          precession(jd2000, config.jdchart, ar, de);
          if config.PlanetParalaxe then
          begin
            Paralaxe(st0, dist, ar, de, ar, de, q, config);
            diam := diam / q;
          end;
          if config.ApparentPos then
            apparent_equatorial(ar, de, config, False, False);
          magn := planet.MoonMag(phase);
        end;
      end;
      ar := rmod(ar + pi2, pi2);
      objects[0, i] := SetObjCoord(jda, ar, de);
      objects[3, i] := SetObjCoord(magn, diam, illum);
      Eq2Hz((st0 - ar), de, az, ha, config);
      az := rmod(az + pi, pi2);
      cells[0, 0] := pla[ipla];
      cells[1, 0] := trim(config.EquinoxName) + blank + appmsg[46];
      cells[0, 1] := trim(armtostr(h)) + ' UT';
      cells[0, i] := isodate(a, m, d);
      cells[1, i] := artostr(rad2deg * ar / 15);
      cells[2, i] := detostr(rad2deg * de);
      cells[3, i] := floattostrf(magn, ffFixed, 5, 1);
      cells[4, i] := floattostrf(diam, ffFixed, 6, 1);
      cells[5, i] := floattostrf(illum, ffFixed, 6, 2);
      cells[9, i] := demtostr(rad2deg * az);
      cells[10, i] := demtostr(rad2deg * ha);
      Planet.PlanetRiseSet(ipla, jd0, AzNorth, mr, mt, ms, azr, azs, jdr, jdt, jds,
        rar, der, rat, det, ras, des, irc, config);
      objects[9, i] := SetObjCoord(irc, rad2deg * az, rad2deg * ha);
      case irc of
        0:
        begin
          cells[6, i] := mr;
          cells[7, i] := mt;
          cells[8, i] := ms;
          if trim(mr) > '' then
            objects[6, i] := SetObjCoord(jdr, rar, der)
          else
            objects[6, i] := nil;
          if trim(mt) > '' then
            objects[7, i] := SetObjCoord(jdt, rat, det)
          else
            objects[7, i] := nil;
          if trim(ms) > '' then
            objects[8, i] := SetObjCoord(jds, ras, des)
          else
            objects[8, i] := nil;
        end;
        1:
        begin
          cells[6, i] := '-';
          cells[7, i] := mt;
          cells[8, i] := '-';
          objects[6, i] := nil;
          if trim(mt) > '' then
            objects[7, i] := SetObjCoord(jdt, rat, det)
          else
            objects[7, i] := nil;
          objects[8, i] := nil;
        end;
        2:
        begin
          cells[6, i] := '-';
          cells[7, i] := '-';
          cells[8, i] := '-';
          objects[6, i] := nil;
          objects[7, i] := nil;
          objects[8, i] := nil;
        end;
      end;
    end;
  end;

  // RefreshPlanet
begin
  screen.cursor := crHourGlass;
  try
{SoleilGrid.Visible:=false;
MercureGrid.Visible:=false;
VenusGrid.Visible:=false;
LuneGrid.Visible:=false;
MarsGrid.Visible:=false;
JupiterGrid.Visible:=false;
SaturneGrid.Visible:=false;
UranusGrid.Visible:=false;
NeptuneGrid.Visible:=false;
PlutonGrid.Visible:=false;}
    dat21 := date1.JD;
    dat22 := date2.JD;
    dat23 := time.time;
    dat24 := step.Text;
    s := step.Value;
    djd(date1.JD, a, m, d, hh);
    config.tz.JD := date1.JD;
    h := frac(Time.time) * 24 - config.tz.SecondsOffset / 3600;
    jd1 := jd(a, m, d, h);
    djd(date2.JD, a, m, d, hh);
    jd2 := jd(a, m, d, h);
    nj := round((jd2 - jd1) / s);
    if nj > maxstep then
      if MessageDlg(appmsg[19] + blank + IntToStr(nj) + blank + appmsg[20],
        mtConfirmation, [mbOK, mbCancel], 0) <> mrOk then
        exit;
    jda := jd1;
    i := 2;
    InitRiseCell(SoleilGrid);
    InitRiseCell(MercureGrid);
    InitRiseCell(VenusGrid);
    InitRiseCell(LuneGrid);
    InitRiseCell(MarsGrid);
    InitRiseCell(JupiterGrid);
    InitRiseCell(SaturneGrid);
    InitRiseCell(UranusGrid);
    InitRiseCell(NeptuneGrid);
    InitRiseCell(PlutonGrid);
    FreeCoord(SoleilGrid);
    FreeCoord(MercureGrid);
    FreeCoord(VenusGrid);
    FreeCoord(LuneGrid);
    FreeCoord(MarsGrid);
    FreeCoord(JupiterGrid);
    FreeCoord(SaturneGrid);
    FreeCoord(UranusGrid);
    FreeCoord(NeptuneGrid);
    FreeCoord(PlutonGrid);
    repeat
      djd(jda, a, m, d, h);
      jd0 := jd(a, m, d, 0);
      jdt_ut := DTminusUT(a, m, d, config) / 24;
      st0 := SidTim(jd0, h, config.ObsLongitude);
      config.tz.JD := jda;
      config.TimeZone := config.tz.SecondsOffset / 3600;
      for ipla := 1 to 11 do
      begin
        if ipla = 3 then
          continue;
        case ipla of
          1: ComputeRow(Mercuregrid, ipla);
          2: ComputeRow(Venusgrid, ipla);
          4: ComputeRow(Marsgrid, ipla);
          5: ComputeRow(Jupitergrid, ipla);
          6: ComputeRow(Saturnegrid, ipla);
          7: ComputeRow(Uranusgrid, ipla);
          8: ComputeRow(Neptunegrid, ipla);
          9: ComputeRow(Plutongrid, ipla);
          10: ComputeRow(Soleilgrid, ipla);
          11: ComputeRow(Lunegrid, ipla);
        end;
      end;
      jda := jda + s;
      i := i + 1;
    until jda > jd2;
    RefreshPlanetGraph;  {Kept separate for now}
  finally
    screen.cursor := crDefault;
{SoleilGrid.Visible:=true;
MercureGrid.Visible:=true;
VenusGrid.Visible:=true;
LuneGrid.Visible:=true;
MarsGrid.Visible:=true;
JupiterGrid.Visible:=true;
SaturneGrid.Visible:=true;
UranusGrid.Visible:=true;
NeptuneGrid.Visible:=true;
PlutonGrid.Visible:=true;}
  end;
end;

procedure Tf_calendar.RefreshPlanetGraph;

  procedure DrawGraph(bm: TBitmap; gr: TStringGrid; iPl: integer); {of RefreshPlanetGraph}
  // bm is the bit map of the draw grid for this planet.
  var
    xts, xte: integer;  {x pos of start and end of rise/set area}
    //xmidday,
    //xmiddnight  : Integer;   { the x positon that midday would have if shown}
    //  tFst, tLst: Double; {first and last times of Graph Axis}
    ygtop, ygbtm: integer; {y pos of top and bottom of graph area}
    i, ix, iy, ily: integer;
    x, y: double;
    s: string;
    txtsz: TSize;       {Size of a date, eg 99/99}
    ytick: single;
    xtick, yskip: integer; {skip is a ratio - 1 = all, 2 = ev 2nd}
    xSStrt, xSInc: double;
    tstrt, tsc: double;
    {to get graph x, sub tstrt, * by tsc}
    //LineEnds: TLine; {Start and end point of a line drawn by TimeLine}
{Scaled Time takes a time from the objects of the specified StringGrid and
 column, and converts it to an x value on the graph.}
    function ScaledTime(grd: TStringGrid; C, R: integer; var x: integer): boolean;
    var
      //dbgs: String;
      evt_time: double;
    begin {ScaledTime of DrawGraph of RefreshPlanetGraph}
      Result := True;
      if assigned(grd) and (C < grd.ColCount) and (R < grd.RowCount) and
        assigned(grd.Objects[c, r]) then
      begin
        config.tz.JD := date1.JD + (r - 2) * step.Value;
        evt_time := (grd.Objects[c, r] as TObjCoord).jd -
          (date1.JD + (r - 2) * step.Value) + config.tz.SecondsOffset / (3600 * 24);
        // local time
        // Normalise time ot current day
        evt_time := evt_time - floor(evt_time);
        // try this instead
        if evt_time < 0.5 then
          evt_time := evt_time + 1.0;

        // now convert to graph scale
        x := trunc((evt_time - tstrt) * tsc) + xts;
    (*if x < xmidday then
      x := x + trunc(tsc);*)
      end
      else
        Result := False;
    end;
    {ScaledTime of DrawGraph of RefreshPlanetGraph}
{ draw one line on the rise / set graph, using the data in column C of grid grd
  on canvas cv.  s is a label, if set }
    procedure TimeLine(grd: TStringGrid; C: integer; cv: TCanvas; s: string = '');
    var
      i, lix, liy: integer; {last x,y coordinate (as graph integer)}
      ir, lir: boolean; {in range, last point in range}
    begin {TimeLine of DrawGraph of RefreshPlanetGraph}
      ir := False;
      i := 2; {First row of grid with times}
      {Skip past any lines with missing values}
      while (i < grd.RowCount) and not ScaledTime(Grd, C, i, lix) do
        Inc(i);
      liy := ygtop;
      lir := (lix >= xts) and (lix <= xte);
      if lir then
        cv.MoveTo(lix, liy);
      y := liy;
      {line end start - this is a bit of a guess, check this later 201103}
      //  LineEnds.P1.x := lix;
      //  LineEnds.P1.y := liy;
      Inc(i);
      {late note - can't see how this stays in sync if there are missing points 201103}
      while i < grd.RowCount do
      begin
        y := y + ytick;
        iy := trunc(y);
        if ScaledTime(Grd, C, i, ix) then
        begin {otherwise just skip completely}
          ir := (ix >= xts) and (ix <= xte);
          if ir then
          begin
            if not lir then {interpolation}
              if lix < xts then {from left}
                cv.MoveTo(xts, liy + ((iy - liy) * (xts - lix)) div (ix - lix))
              else {must be from right}
                cv.MoveTo(xte, liy + ((iy - liy) * (xte - lix)) div (ix - lix));
            cv.lineto(ix, iy);
          end
          else {NOW out of range}
          if lir then {interpolate to edge of range from last point}
            if ix < xts then {from left}
              cv.LineTo(xts, liy + ((iy - liy) * (xts - lix)) div (ix - lix))
            else {must be from right}
              cv.LineTo(xte, liy + ((iy - liy) * (xte - lix)) div (ix - lix));
          lix := ix;
          liy := iy;
          lir := ir;
        end;
        Inc(i);
      end;
      {record last point drawn - also a bit of a guess, 201103}
      //  LineEnds.P2.x:= ix;
      //  LineEnds.P2.y:= iy;
      if ir then
      begin
        cv.LineTo(ix, ygbtm);
        if s <> '' then
        begin
          txtsz := cv.TextExtent(s);
          cv.TextOut(ix - (txtsz.cx div 2), ygbtm - txtsz.cy - 1, s);
        end;
      end;
    end; {TimeLine of of DrawGraph RefreshPlanetGraph}

{DrawZone draws the twilight zones.  Prior to 20121219, they were drawn as lines
 and then flood filled, but this was not reliable.  This version draws them
 as quadrilaterals.  DrawZone must be called with grd1 as the "outside" limit,
 ie earlier in the evening, later in the morning}
    procedure DrawZone(cv: TCanvas);
    var
      crow, lrow: TPGScaledTimeRow;
      rowcount, k{, i}: integer;
      grdrw: integer;

{dzScaled time calls ScaledTime and "tidies up", forcing times outside the graph
 back to the edge of the graph}
      function dzScaledTime(grd: TStringGrid; C, R: integer; var x: integer): boolean;
      begin {dzScaledTime of DrawZone of of DrawGraph of RefreshPlanetGraph}
        Result := ScaledTime(grd, C, R, x);
        if Result then
          if x > xte then
            x := xte
          else if x < xts then
            x := xts;
      end;{dzReadRow of DrawZone of of DrawGraph of RefreshPlanetGraph}

      procedure dzReadRow(rw: integer; var r: TPGScaledTimeRow);
      var
        i: integer;
        //a: double;
        ai: integer;
      begin {dzReadRow of DrawZone of of DrawGraph of RefreshPlanetGraph}
        {LeftEdge}
        r[0].Valid := True;
        r[0].ScTime := xts;
        {Sunset}
        r[1].Valid := dzScaledTime(SoleilGrid, 8, rw, r[1].ScTime);
        {EndNatTL}
        r[2].Valid := dzScaledTime(TwilightGrid, 5, rw, r[2].ScTime);
        {EndAstTL}
        r[3].Valid := dzScaledTime(TwilightGrid, 6, rw, r[3].ScTime);
        {StartAstTL}
        r[4].Valid := dzScaledTime(TwilightGrid, 1, rw, r[4].ScTime);
        {StartNatTL}
        r[5].Valid := dzScaledTime(TwilightGrid, 2, rw, r[5].ScTime);
        {Sunrise}
        r[6].Valid := dzScaledTime(SoleilGrid, 6, rw, r[6].ScTime);
        {RightEdge}
        r[7].Valid := True;
        r[7].ScTime := xte;
        {Sun behaviour}
        r[8].Valid := Assigned(SoleilGrid) and Assigned(SoleilGrid.Objects[9, rw]);
        if r[8].Valid then
          r[8].ScTime := round((SoleilGrid.Objects[9, rw] as TObjCoord).jd);
        {Now tidy up exceptions}
        if not r[8].Valid then
        begin {give up - make everything night}
          for i := 1 to 3 do
            r[i].ScTime := r[0].ScTime;
          for i := 4 to 6 do
            r[i].ScTime := r[7].ScTime;
        end
        else if r[8].ScTime = 1 then {sun up all day}
          for i := 1 to 6 do
            r[i].ScTime := r[7].ScTime
        else
        begin {sun either rises and sets or is down  }
          if r[8].ScTime = 2 then
          begin {is always down, so move rise & set to graph edge}
            r[1] := r[0];
            r[6] := r[7];
          end;
          if not (r[2].Valid and r[3].Valid and r[4].Valid and r[5].Valid) then
            {not all twighlights valid, so need to do some sorting out}
            if not (r[2].Valid or r[3].Valid or r[4].Valid or r[5].Valid) then
            begin
              if r[8].ScTime = 0 then {sun rises/sets, no twilight change}
                ai := 0
              else
              {none valid - twilight doesn't change all day - very near poles (or something horribly wrong)}
              {get twilight estimate from sun's altitude - as it doesn't change (much)}
              if assigned(SoleilGrid) and assigned(SoleilGrid.Objects[9, rw]) then
                ai := trunc((SoleilGrid.Objects[9, rw] as TObjCoord).Dec / 6)
              else
                ai := -3; {give up and treat as night}
              case ai of {note this should never be positive if we get here}
                0, -1: for i := 2 to 5 do
                    r[i] := r[7];
                {all Nautical/civil twilight} -2:
                begin
                  r[2] := r[0];
                  for i := 3 to 5 do
                    r[i] := r[7];
                end {Ast}
                else
                begin
                  r[2] := r[0];
                  r[3] := r[0];
                  r[4] := r[7];
                  r[5] := r[7];
                end
              end;
            end
            else {some valid, but not all - shoud be able to work back fron the valid ones}
            if r[2].Valid and r[5].Valid then
              {but not both r3 and r4 are, so assume no night, all ast twilight}
              for i := 3 to 4 do
                r[i] := r[5]
            else if r[3].Valid and r[4].Valid then
            begin
              {but not both r2 and r5 - assume have nautical then ast twighlight all night}
              r[2] := r[1];
              r[5] := r[6];
            end
            else
            begin {give up - show everything as night}
              r[2] := r[1];
              r[3] := r[1];
              r[4] := r[6];
              r[5] := r[7];
            end;
        end;
      end;{dzReadRow of DrawZone of of DrawGraph of RefreshPlanetGraph}

      procedure dzDrawPoly(idx (*, c*): integer);
      begin {dzDrawPoly of DrawZone of of DrawGraph of RefreshPlanetGraph}
        cv.Brush.Color := dfskycolor[7 - abs(3 - idx) * 2];
        cv.Polygon([Point(lrow[idx].ScTime, ily), Point(
          lrow[idx + 1].ScTime, ily), Point(crow[idx + 1].ScTime, iy),
          Point(crow[idx].ScTime, iy)]);
      end;
      {dzDrawPoly of DrawZone of of DrawGraph of RefreshPlanetGraph}
    begin {DrawZone of of DrawGraph of RefreshPlanetGraph}
      if assigned(SoleilGrid) then
        {assume twighlight grid the same - should not crash anyway}
        rowcount := SoleilGrid.RowCount
      else
        rowcount := 0;
      y := ygtop;
      ily := ygtop;
      grdrw := 2; {First row of grid with times}
      dzReadRow(grdrw, lrow);
      Inc(grdrw);
      while grdrw < rowcount do
      begin
        y := y + ytick;
        iy := trunc(y); {bump y to next point}
        dzReadRow(grdrw, crow);
        for k := 0 to 6 do
          dzDrawPoly(k);
        lrow := crow;
        ily := iy;
        Inc(grdrw);
      end;
    end;
    {DrawZone of of DrawGraph RefreshPlanetGraph}
  begin {DrawGraph of RefreshPlanetGraph}
    with bm.Canvas do
    begin
      // Basic Geometry - needed for canvas and background setup
      // y scale & axis - same for all graph segments
      txtsz := TextExtent('22/22'); // all numbers will be the same size
      ygtop := txtsz.cy div 2;
      ygBtm := Height - 3 - txtsz.cy;
      ytick := (ygbtm - ygtop) / (gr.RowCount - 3);
      {rc-2 gives data rows, -1 for intervals}
      {ytick needs to be float to adequately fill the range - calc float then trun}
      ySkip := trunc(txtsz.cy / ytick) + 1;
      // Set up constants for Rise/set - rise set is 70% of width
      xte := ((Width * 7) div 10) - 2; {-2 provides gutter to next}
      xts := txtsz.cx + 2;
      {for now, take nominal graph time range as 5pm to 8 am}
      xtick := (xte - xts) div 15; // pixels
      ix := (txtsz.cx div xtick + 1); {temp x skip}
      xtick := xtick * ix;
      xSInc := (1 / 24) * ix;
      xSStrt := 17 / 24;  // 5 pm
      tstrt := xSStrt;
      tsc := xtick / xSInc;
      //    xmidday := trunc((0.5 - tstrt) * tsc);

      //Set up the canvas - first darw the whole canvas black
      Pen.Style := psClear;
      Brush.Color := clBlack;
      Brush.Style := bsSolid;
      Font.Color := clWhite;
      Rectangle(2, 2, 3, 3); {Dummy - it seems the first command won't do anything}
      FillRect(0, 0, Width - 1, Height - 1); // Whole canvas
      // Backgrounds for thr rise / set graphs
      DrawZone(bm.Canvas);

      // Still draw sunrise/set time as a line
      Pen.Color := clYellow;
      Pen.Style := psSolid;
      Pen.Width := 2;
      Pen.Mode := pmCopy;
      TimeLine(SoleilGrid, 8, bm.Canvas); {set, left on graph}
      TimeLine(SoleilGrid, 6, bm.Canvas); {rise, right on graph}

      // Now do the graph frames.  Want these to oeverlay the backgrounds, but
      // be behind the actual graph lines
      Brush.Style := bsClear; // no fill
      i := 2; {first data cell}
      iy := ygtop - txtsz.cy div 2; {very close to 0 !!!}
      y := iy;
      ix := 1;
      while i < gr.RowCount do
      begin
        s := gr.Cells[0, i]; {isodate}
        TextOut(ix, iy, s[9] + s[10] + '/' + s[6] + s[7]);
        Inc(i, yskip);
        y := y + ytick * yskip;
        iy := trunc(y);
      end;
      Rectangle(xts, ygtop, xte, ygBtm);
      ix := xts + xtick;
      x := xSStrt + xSInc;
      iy := Height - txtsz.cy;
      repeat
        s := FormatDateTime('h a/p', x);
        txtsz := TextExtent(s);
        TextOut(ix - (txtsz.cx div 2), iy, s);
        Inc(ix, xtick);
        x := x + xSInc;
      until (ix + txtsz.cx div 2) > xte;

      {Now - finally - the planet times}
      font.Color := clWhite;
      Brush.Style := bsSolid;
      Brush.Color := clBlack;
      TimeLine(gr, 6, bm.Canvas, 'Rise'); {leave yellow}
      pen.Color := clWhite;
      TimeLine(gr, 7, bm.Canvas, 'Cul');
      pen.Color := clRed;
      TimeLine(gr, 8, bm.Canvas, 'Set');

      Brush.Style := bsClear;
      Font.Style := Font.Style + [fsBold];
      Font.Color := clWhite;
      TextOut(xts + 2, ygTop + 2, pla[iPl]);
      Font.Style := Font.Style - [fsBold];
      pen.Width := 1;
      pen.Color := clYellow;
      brush.Color := dfskycolor[4];
      Brush.Style := bsSolid;
      {Planet Mag, Size, Illum}
    { Set up constants for Mag - scale is fixed at 8 to -4, but allows
      little room on either side.  Work out from 0 @ 2/3 scale }
      xts := xte + 4;
      xte := xts + (Width div 10) - 4;
      FillRect(xts, ygtop, xte, ygBtm);
      Rectangle(xts, ygtop, xte, ygBtm);
      Brush.Style := bsClear;
      xtick := (xte - xts) div 7;
      xSInc := 2;
      tsc := xtick / xSInc;
      if ipl < 10 {planet} then
      begin
        xSStrt := 8;
        tstrt := (((xte - xts) * 2) / 3) / tsc; {now ix = (tstrt - x) * tsc + xts}
      end
      else
      begin {moon}
        xSStrt := 0;
        tstrt := 0; {now ix = (tstrt - x) * tsc + xts}
      end;
      ix := trunc((tstrt - xSStrt) * tsc) + xts;
      x := xSStrt;
      iy := Height - txtsz.cy; {whatever was last done should do!}
      repeat
        s := FormatFloat('0;-0', x);
        txtsz := TextExtent(s);
        TextOut(ix - (txtsz.cx div 2), iy, s);
        Inc(ix, xtick * 2);
        x := x - xSInc * 2;
      until (ix + txtsz.cx div 2) > xte;
      pen.Width := 2;
      ix := trunc((tstrt - (gr.Objects[3, 2] as TObjCoord).jd) * tsc) + xts;
      iy := ygtop;
      y := iy;
      MoveTo(ix, iy);
      i := 3;
      while i < Gr.RowCount do
      begin
        y := y + ytick;
        iy := trunc(y);
        ix := trunc((tstrt - (gr.Objects[3, i] as TObjCoord).jd) * tsc) + xts;
        lineto(ix, iy);
        Inc(i);
      end;
      LineTo(ix, ygbtm);
      pen.Width := 1;
      TextOut(xts + 2, ygtop + 2, 'Mag');
      // Size
      xts := xte + 4;
      xte := xts + (Width div 10) - 4;
      Brush.Style := bsSolid;
      FillRect(xts, ygtop, xte, ygBtm);
      Rectangle(xts, ygtop, xte, ygBtm);
      Brush.Style := bsClear;
      xtick := (xte - xts - 10) div 3;
      xSInc := 20;
      xSStrt := 0;
      tsc := xtick / xSInc;
      ix := xts;
      x := xSStrt;
      iy := Height - txtsz.cy; {whatever was last done should do!}
      repeat
        s := FormatFloat('0', x);
        txtsz := TextExtent(s);
        TextOut(ix - (txtsz.cx div 2), iy, s);
        Inc(ix, xtick);
        x := x + xSInc;
      until (ix + txtsz.cx div 2) > xte;
      pen.Width := 2;
      ix := trunc(((gr.Objects[3, 2] as TObjCoord).ra - xSStrt) * tsc) + xts;
      iy := ygtop;
      y := iy;
      MoveTo(ix, iy);
      i := 3;
      while i < gr.RowCount do
      begin
        y := y + ytick;
        iy := trunc(y);
        ix := trunc(((gr.Objects[3, i] as TObjCoord).ra - xSStrt) * tsc) + xts;
        lineto(ix, iy);
        Inc(i);
      end;
      LineTo(ix, ygbtm);
      pen.Width := 1;
      TextOut(xts + 2, ygtop + 2, 'Diam(")');
      // Luumination
      xts := xte + 4;
      xte := xts + (Width div 10) - 4;
      Brush.Style := bsSolid;
      FillRect(xts, ygtop, xte, ygBtm);
      Rectangle(xts, ygtop, xte, ygBtm);
      Brush.Style := bsClear;
      xtick := (xte - xts) div 5;
      xSInc := 20;
      xSStrt := 0;
      tsc := xtick / xSInc;
      ix := xts;
      x := xSStrt;
      iy := Height - txtsz.cy; {whatever was last done should do!}
      repeat
        s := FormatFloat('0', x);
        txtsz := TextExtent(s);
        TextOut(ix - (txtsz.cx div 2), iy, s);
        Inc(ix, xtick);
        x := x + xSInc;
      until (ix + txtsz.cx div 2) > xte;
      pen.Width := 2;
      ix := trunc(((gr.Objects[3, 2] as TObjCoord).Dec * 100 - xSStrt) * tsc) + xts;
      iy := ygtop;
      y := iy;
      MoveTo(ix, iy);
      i := 3;
      while i < gr.RowCount do
      begin
        y := y + ytick;
        iy := trunc(y);
        ix := trunc(((gr.Objects[3, i] as TObjCoord).Dec * 100 - xSStrt) * tsc) + xts;
        lineto(ix, iy);
        Inc(i);
      end;
      LineTo(ix, ygbtm);
      pen.Width := 1;
      TextOut(xts + 2, ygtop + 2, 'Illum(%)');
    end;
  end;
  {DrawGraph of RefreshPlanetGraph}
begin {RefreshPlanetGraph}
  if Mercuregrid.RowCount < 4 then
  begin
    tsPGraphs.TabVisible := False;
    tsPGraphs.Visible := False;
    exit;
  end;
  try
    tsPGraphs.Visible := True;
    tsPGraphs.TabVisible := True;
    // This does the messy bit of correlating bitmap, grid, etc
    DrawGraph(PlanetGraphs[1], Mercuregrid, 1);
    DrawGraph(PlanetGraphs[2], Venusgrid, 2);
    DrawGraph(PlanetGraphs[3], Marsgrid, 4);
    DrawGraph(PlanetGraphs[4], Jupitergrid, 5);
    DrawGraph(PlanetGraphs[5], Saturnegrid, 6);
    DrawGraph(PlanetGraphs[6], Uranusgrid, 7);
    DrawGraph(PlanetGraphs[7], Neptunegrid, 8);
    DrawGraph(PlanetGraphs[8], Plutongrid, 9);
    DrawGraph(PlanetGraphs[9], Lunegrid, 11);
    dgPlanet.Invalidate;
  except
    tsPGraphs.TabVisible := False;
    tsPGraphs.Visible := False;
  end;
end;

procedure Tf_calendar.BtnRefreshClick(Sender: TObject);
var
  z1, z2: string;
  s: integer;
begin
  chdir(appdir);
  s := step.Value;
  if s <= 0 then
    exit;
  case pagecontrol1.ActivePage.TabIndex of
    0: RefreshTwilight;
    1:
    begin
      RefreshTwilight;
      RefreshPlanet;
    end;
    2: RefreshComet;
    3: RefreshAsteroid;
    4: RefreshSolarEclipse;
    5: RefreshLunarEclipse;
    6: RefreshSatellite;
  end;
  config.tz.JD := date1.JD;
  z1 := config.tz.ZoneName;
  config.tz.JD := date2.JD;
  z2 := config.tz.ZoneName;
  if z1 <> z2 then
    z1 := z1 + '/' + z2;
  Caption := title + blank + config.Obsname + blank + rsTimeZone + '=' + TzGMT2UTC(z1);
end;

procedure Tf_calendar.BtnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure Tf_calendar.GridDblClick(Sender: TObject);
begin
  lockclick := False;
end;

procedure Tf_calendar.SatPanelClick(Sender: TObject);
begin
  ExecuteFile(URL_QUICKSAT);
end;

procedure Tf_calendar.tle1Change(Sender: TObject);
var
  fn: string;
begin
  LabelTle.Caption := '';
  if tle1.Text <> '' then
  begin
    fn := slash(SatDir) + tle1.Text;
    if FileExists(fn) then
    begin
      LabelTle.Caption := FormatDateTime('yyyy"-"mm"-"dd', TleDate(fn));
    end;
  end;
end;

procedure Tf_calendar.Label9Click(Sender: TObject);
begin
  ExecuteFile(URL_QUICKSAT);
end;

procedure Tf_calendar.GridMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: integer);
var
  aColumn, aRow: longint;
  csconfig: Tconf_skychart;
  p: TObjCoord;
  pathimage, satmag, sattle: string;
  a, d: double;
begin
  if lockclick then
    exit;
  lockclick := True;
  csconfig := Tconf_skychart.Create;
  try
    with Tstringgrid(Sender) do
    begin
      MouseToCell(X, Y, aColumn, aRow);
      if (aRow >= 0) and (aColumn >= 0) then
      begin
        p := TObjCoord(Objects[aColumn, aRow]);
        if p = nil then
          p := TObjCoord(Objects[0, aRow]);
        if p <> nil then
        begin
          if assigned(FGetChartConfig) then
            FGetChartConfig(csconfig)
          else
            csconfig.Assign(config);
          csconfig.UseSystemTime := False;
          csconfig.tz.JD := p.jd;
          csconfig.TimeZone := csconfig.tz.SecondsOffset / 3600;
          djd(p.jd + csconfig.timezone / 24, csconfig.CurYear, csconfig.CurMonth,
            csconfig.CurDay, csconfig.CurTime);
          if Sender = solargrid then
          begin      // Solar eclipse
            if (aColumn = 1) then
            begin   // image map
              pathimage := slash(Feclipsepath) + 'SE' + stringreplace(
                cells[0, aRow], blank, '', [rfReplaceAll]) + copy(cells[3, aRow], 1, 1) + '.png';
              if fileexists(pathimage) then
              begin
                ShowImage.ButtonPrint.Visible := False;
                ShowImage.labeltext := eclipanel.Caption;
                ShowImage.titre := solar.Caption + blank + IntToStr(csconfig.CurMonth) +
                  '/' + IntToStr(csconfig.CurYear);
                ShowImage.LoadImage(pathimage);
                ShowImage.ClientHeight :=
                  min(screen.Height - 80, ShowImage.imageheight + ShowImage.Panel1.Height +
                  ShowImage.HScrollBar.Height);
                ShowImage.ClientWidth :=
                  min(screen.Width - 50, ShowImage.imagewidth + ShowImage.VScrollBar.Width);
                ShowImage.image1.ZoomMin := 1;
                ShowImage.Init;
                ShowImage.Show;
              end;
            end
            else
            begin
              csconfig.TrackOn := True;     // set tracking to the Sun
              csconfig.TrackType := 1;
              csconfig.TrackObj := 10;
              csconfig.PlanetParalaxe := True;
              csconfig.ShowPlanet := True;
              if (aColumn = 7) or (aColumn = 8) then
              begin         // change location to eclipse maxima
                d := strtofloat(copy(cells[7, aRow], 1, 4));
                if copy(cells[7, aRow], 5, 1) = 'S' then
                  d := -d;
                a := strtofloat(copy(cells[8, aRow], 1, 5));
                if copy(cells[8, aRow], 6, 1) = 'E' then
                  a := -a;
                csconfig.ObsLatitude := d;
                csconfig.ObsLongitude := a;
                csconfig.ObsName := 'Max. Solar Eclipse ' + IntToStr(
                  csconfig.CurMonth) + '/' + IntToStr(csconfig.CurYear);
              end;
              if assigned(Fupdchart) then
              begin
                BtnReset.Visible := True;
                Fupdchart(csconfig);
              end;
            end;
          end
          else if Sender = lunargrid then
          begin
            csconfig.TrackOn := True;         // Lunar eclipse
            csconfig.TrackType := 1;          // set tracking to the Moon
            csconfig.TrackObj := 11;
            csconfig.PlanetParalaxe := True;
            csconfig.ShowPlanet := True;
            csconfig.ShowEarthShadow := True;
            if assigned(Fupdchart) then
            begin
              BtnReset.Visible := True;
              Fupdchart(csconfig);
            end;
          end
          else if Sender = Satgrid then
          begin    // Satellites
            satmag := magchart.Text;
            sattle := tle1.Text;
            config.tz.JD:=p.jd;
            DetailSat(p.jd, config.ObsLatitude, config.ObsLongitude,
              config.ObsAltitude, 0, 0, 0, 0, satmag, sattle, SatDir, slash(appdir) + slash(
              'data') + slash('quicksat'), formatfloat(f1, config.tz.SecondsOffset / 3600),
              config.ObsName, MinSatAlt.Text, False);
            csconfig.racentre := p.ra;
            csconfig.decentre := p.Dec;
            csconfig.ShowArtSat := True;
            csconfig.NewArtSat := True;
            if assigned(Fupdchart) then
            begin
              BtnReset.Visible := True;
              Fupdchart(csconfig);
            end;
          end
          else
          begin  // other grid
            if p.ra > -900 then
              csconfig.racentre := p.ra;
            if p.Dec > -900 then
              csconfig.decentre := p.Dec
            else
            begin
              csconfig.TrackOn := True;
              csconfig.TrackType := 4;
            end;
            if assigned(Fupdchart) then
            begin
              BtnReset.Visible := True;
              Fupdchart(csconfig);
            end;
          end;
        end; // p<>nil
      end; // row>=0..
    end; // with ..
    csconfig.Free;
  except
    csconfig.Free;
  end;
end;

procedure Tf_calendar.PageControl1Change(Sender: TObject);

  procedure Dategroup1(onoff: boolean);
  begin
    label2.Visible := onoff;
    date2.Visible := onoff;
  end;

  procedure Dategroup2(onoff: boolean);
  begin
    label3.Visible := onoff;
    label4.Visible := onoff;
    label5.Visible := onoff;
    step.Visible := onoff;
    time.Visible := onoff;
    EcliPanel.Visible := False;
    SatPanel.Visible := False;
  end;

begin
  case pagecontrol1.ActivePage.TabIndex of
    0:
    begin
      Dategroup1(True);
      Dategroup2(True);
      if (dat11 <> date1.jd) or (dat12 <> date2.jd) or (dat13 <> time.time) or
        (dat14 <> step.Text) then
        RefreshTwilight;
    end;
    1:
    begin
      Dategroup1(True);
      Dategroup2(True);
      if (dat21 <> date1.jd) or (dat22 <> date2.jd) or (dat23 <> time.time) or
        (dat24 <> step.Text) then
        RefreshPlanet;
    end;
    2:
    begin
      Dategroup1(True);
      Dategroup2(True);
      if (cometgrid.Cells[0, 2] <> '') and ((dat31 <> date1.jd) or
        (dat32 <> date2.jd) or (dat33 <> time.time) or (dat34 <> step.Text)) then
        RefreshComet
      else
      if ComboBox1.Items.Count = 0 then
        Button4Click(self);
    end;
    3:
    begin
      Dategroup1(True);
      Dategroup2(True);
      if (asteroidgrid.Cells[0, 2] <> '') and ((dat71 <> date1.jd) or
        (dat72 <> date2.jd) or (dat73 <> time.time) or (dat74 <> step.Text)) then
        RefreshAsteroid
      else
      if ComboBox2.Items.Count = 0 then
        Button2Click(self);
    end;
    4:
    begin
      Dategroup1(False);
      Dategroup2(False);
      EcliPanel.Visible := True;
      if (dat41 <> date1.jd) then
        RefreshSolarEclipse;
    end;
    5:
    begin
      Dategroup1(False);
      Dategroup2(False);
      EcliPanel.Visible := True;
      if (dat51 <> date1.jd) then
        RefreshLunarEclipse;
    end;
    6:
    begin
      Dategroup1(True);
      Dategroup2(False);
      SatPanel.Visible := True;
      if doscmd = 'wine' then
        CheckWine;
      UpdTleList;
      tle1Change(nil);
      //if (dat61<>date1.jd) then RefreshSatellite;
    end;

  end;
end;

procedure Tf_calendar.SaveGrid(grid: tstringgrid);
var
  buf, d, z1, z2: string;
  i, j: integer;
  x: double;
  lst: TStringList;
begin
  lst := TStringList.Create;
  buf := '"' + config.ObsName + '";"';
  x := abs(config.ObsLongitude);
  if config.ObsLongitude > 0 then
    d := west
  else
    d := east;
  buf := buf + appmsg[32] + '=' + stringreplace(copy(detostr(x), 2, 99), '"', '""', [rfReplaceAll]) +
    d + '";"' + appmsg[31] + '=' + stringreplace(detostr(config.ObsLatitude), '"',
    '""', [rfReplaceAll]) + '";"';
  config.tz.JD := date1.JD;
  z1 := config.tz.ZoneName;
  config.tz.JD := date2.JD;
  z2 := config.tz.ZoneName;
  if z1 <> z2 then
    z1 := z1 + '/' + z2;
  buf := buf + rsTimeZone + '=' + TzGMT2UTC(z1) + '"';
  lst.Add(buf);
  for i := 0 to grid.RowCount - 1 do
  begin
    for j := 0 to grid.ColCount - 1 do
    begin
      if j = 0 then
        buf := '"' + stringreplace(grid.cells[j, i], '"', '""', [rfReplaceAll])
      else
        buf := buf + '";"' + stringreplace(grid.cells[j, i], '"', '""', [rfReplaceAll]);
    end;
    buf := buf + '"';
    lst.Add(buf);
  end;
  try
    Savedialog1.DefaultExt := '.csv';
    Savedialog1.filter := 'Tab Separated File (*.csv)|*.csv';
    Savedialog1.Initialdir := HomeDir;
    if SaveDialog1.Execute then
      lst.SaveToFile(SafeUTF8ToSys(savedialog1.Filename));
  finally
    ChDir(appdir);
  end;
  lst.Free;
end;

procedure Tf_calendar.BtnSaveClick(Sender: TObject);
begin
  case pagecontrol1.ActivePage.TabIndex of
    0: SaveGrid(TwilightGrid);
    1: case pagecontrol2.ActivePage.TabIndex of
        0: SaveGrid(SoleilGrid);
        1: SaveGrid(MercureGrid);
        2: SaveGrid(VenusGrid);
        3: SaveGrid(LuneGrid);
        4: SaveGrid(MarsGrid);
        5: SaveGrid(JupiterGrid);
        6: SaveGrid(SaturneGrid);
        7: SaveGrid(UranusGrid);
        8: SaveGrid(NeptuneGrid);
        9: SaveGrid(PlutonGrid);
      end;
    2: SaveGrid(CometGrid);
    3: SaveGrid(AsteroidGrid);
    4: SaveGrid(SolarGrid);
    5: SaveGrid(LunarGrid);
    6: SaveGrid(SatGrid);
  end;
end;

procedure Tf_calendar.Gridtoprinter(grid: tstringgrid);
var
  buf, d, z1, z2: string;
  x: double;
begin
  buf := config.ObsName;
  x := abs(config.ObsLongitude);
  if config.ObsLongitude > 0 then
    d := west
  else
    d := east;
  buf := buf + blank + appmsg[32] + '=' + copy(detostr(x), 2, 99) + d + blank + appmsg[31] + '=' +
    detostr(config.ObsLatitude);
  config.tz.JD := date1.JD;
  z1 := config.tz.ZoneName;
  config.tz.JD := date2.JD;
  z2 := config.tz.ZoneName;
  if z1 <> z2 then
    z1 := z1 + '/' + z2;
  buf := buf + blank + rsTimeZone + '=' + TzGMT2UTC(z1);
  if grid = cometgrid then
    PrtGrid(Grid, 'CdC', buf, '', poLandscape)
  else
    PrtGrid(Grid, 'CdC', buf, '', poPortrait);
end;

procedure Tf_calendar.BtnPrintClick(Sender: TObject);
begin
  case pagecontrol1.ActivePage.TabIndex of
    0: GridtoPrinter(TwilightGrid);
    1: case pagecontrol2.ActivePage.TabIndex of
        0: GridtoPrinter(SoleilGrid);
        1: GridtoPrinter(MercureGrid);
        2: GridtoPrinter(VenusGrid);
        3: GridtoPrinter(LuneGrid);
        4: GridtoPrinter(MarsGrid);
        5: GridtoPrinter(JupiterGrid);
        6: GridtoPrinter(SaturneGrid);
        7: GridtoPrinter(UranusGrid);
        8: GridtoPrinter(NeptuneGrid);
        9: GridtoPrinter(PlutonGrid);
      end;
    2: GridtoPrinter(CometGrid);
    3: GridtoPrinter(AsteroidGrid);
    4: GridtoPrinter(SolarGrid);
    5: GridtoPrinter(LunarGrid);
    6: GridtoPrinter(SatGrid);
  end;
end;

procedure Tf_calendar.BtnCopyClipClick(Sender: TObject);  // added js
var
  grid: TStringGrid;
  buf, d, z1, z2: string;
  x: double;
  planetgrid: boolean;
  i, j: integer;

  procedure AddToBuff(vals: array of double); {of BtnCopyClipClick}
  var
    k: integer;
  begin {AddToBuff of BtnCopyClipClick}
    for k := Low(vals) to high(vals) do
      buf := buf + FloatToStr(vals[k]) + tab;
  end;

begin {BtnCopyClipClick}
  {This routine is modelled on the print routine, but it uses tab format and
   stores numbers such that they should become numbers when pasted into a
   spreadsheet}
  grid := nil;
  planetgrid := False;
  case pagecontrol1.ActivePage.TabIndex of
    0: Grid := TwilightGrid;
    1:
    begin
      planetgrid := True;
      case pagecontrol2.ActivePage.TabIndex of
        0: Grid := SoleilGrid;
        1: Grid := MercureGrid;
        2: Grid := VenusGrid;
        3: Grid := LuneGrid;
        4: Grid := MarsGrid;
        5: Grid := JupiterGrid;
        6: Grid := SaturneGrid;
        7: Grid := UranusGrid;
        8: Grid := NeptuneGrid;
        9: Grid := PlutonGrid;
        10: Clipboard.Assign(PlanetGraphs[dgPlanet.Selection.Top + 1]);
      end {case};
    end;
    2: Grid := CometGrid;
    3: Grid := AsteroidGrid;
    4: Grid := SolarGrid;
    5: Grid := LunarGrid;
    6: Grid := SatGrid;
    else
      ShowMessage(rsSorryCopyIsN);
  end {case};
  if assigned(grid) then
  begin
    if planetgrid then
    begin
      buf := config.ObsName;
      x := abs(config.ObsLongitude);
      if config.ObsLongitude > 0 then
        d := west
      else
        d := east;
      buf := buf + blank + appmsg[32] + '=' + copy(detostr(x), 2, 99) + d + blank +
        appmsg[31] + '=' + detostr(config.ObsLatitude);
      config.tz.JD := date1.JD;
      z1 := config.tz.ZoneName;
      config.tz.JD := date2.JD;
      z2 := config.tz.ZoneName;
      if z1 <> z2 then
        z1 := z1 + '/' + z2;
      buf := buf + blank + rsTimeZone + '=' + TzGMT2UTC(z1) + LineEnding;
      {At this stage we have something like
       "Churchill Longitude=146Â°24'55"East Latitude=-38Â°21'50" Time Zone=LHST"}
      for i := 0 to 1 do
      begin
        for j := 0 to grid.ColCount - 1 do
          buf := buf + grid.Cells[j, i] + tab;
        {it will have a spurious last cloumn, but too bad!}
        buf := buf + LineEnding;
      end;
      {Now have added titles}
      {Churchill Longitude=146Â°24'55"East Latitude=-38Â°21'50" Time Zone=LHST
      Venus  Date Coord.
      7h37m UT  RA  DE  Magn.  Diam.  Illum.  Rise  Culmination
      }
      for i := 2 to grid.RowCount - 1 do
      begin
        buf := buf + grid.Cells[0, i] + tab;
        if assigned(grid.Objects[0, i]) then
          with grid.Objects[0, i] as TObjCoord do
            AddToBuff([rad2deg * ra / 15, rad2deg * Dec])
        else
          buf := buf + tab + tab;
        if (grid.ColCount >= 4) and assigned(grid.Objects[3, i]) then
          with grid.Objects[3, i] as TObjCoord do
            AddToBuff([jd, ra, Dec])
        else
          buf := buf + tab + tab + tab;
        if (grid.ColCount >= 7) and assigned(grid.Objects[6, i]) then
          with grid.Objects[6, i] as TObjCoord do
            AddToBuff([frac(jd - 0.5 + config.tz.SecondsOffset / (3600 * 24))])
        else
          buf := buf + tab;
        if (grid.ColCount >= 8) and assigned(grid.Objects[7, i]) then
          with grid.Objects[7, i] as TObjCoord do
            AddToBuff([frac(jd - 0.5 + config.tz.SecondsOffset / (3600 * 24))])
        else
          buf := buf + tab;
        if (grid.ColCount >= 9) and assigned(grid.Objects[8, i]) then
          with grid.Objects[8, i] as TObjCoord do
            AddToBuff([frac(jd - 0.5 + config.tz.SecondsOffset / (3600 * 24))])
        else
          buf := buf + tab;
        if (grid.ColCount >= 10) and assigned(grid.Objects[9, i]) then
          with grid.Objects[9, i] as TObjCoord do
            AddToBuff([ra, Dec])
        else
          buf := buf + tab + tab;
        buf := buf + LineEnding;
      end;
      buf := buf + 'Times are in days - format rise/transit/set columns as time' +
        LineEnding;
      Clipboard.AsText := buf;
    end {planet grid}
    else
    begin
      { TODO : Add number formating for other grid }
      grid.CopyToClipboard(False);
    end;
  end;
end;

procedure Tf_calendar.BtnTleDownloadClick(Sender: TObject);
var
  txt: string;
begin
  if cmain.TleUrlList.Count > 0 then
  begin
    DownloadTle;
  end
  else
  begin
    txt := Format(rsPutTheFilesW, [satdir]);
  {$ifdef unix}
    txt := txt + crlf + rsBeSureTheyUs;
  {$endif}
    ShowMessage(txt);
    ExecuteFile(URL_TLE);
    ExecuteFile(Satdir);
  end;
  UpdTleList;
end;

procedure Tf_calendar.dgPlanetDrawCell(Sender: TObject; aCol, aRow: integer;
  aRect: TRect; aState: TGridDrawState);
begin
  if (aCol = 0) and (aRow < high(PlanetGraphs)) then
    dgPlanet.Canvas.Draw(aRect.Left, aRect.Top, PlanetGraphs[aRow + 1]);
  if dgPlanet.Selection.Top = ARow then
    with dgPlanet.Canvas do
    begin
      Pen.Style := psSolid;
      Pen.Color := clLime;
      Pen.Width := 3;
      Brush.Style := bsClear;
      Rectangle(aRect.Left + 1, aRect.Top + 1, aRect.Right - 1, aRect.Bottom - 1);
    end;
end;

procedure Tf_calendar.EcliPanelClick(Sender: TObject);
begin
  ExecuteFile(EcliPanel.Hint);
end;

procedure Tf_calendar.BtnResetClick(Sender: TObject);
begin
  if assigned(Fupdchart) then
    Fupdchart(config);
  BtnReset.Visible := False;
end;

procedure Tf_calendar.Button1Click(Sender: TObject);
var
  list: TStringList;
begin
  list := TStringList.Create;
  Cdb.GetCometList(CometFilter.Text, maxcombo, list, cometid);
  Combobox1.Items.Assign(list);
  list.Free;
  if Combobox1.Items.Count > 0 then
  begin
    Combobox1.ItemIndex := 0;
    RefreshComet;
  end;
end;

procedure Tf_calendar.Button4Click(Sender: TObject);
type
  Tmaglist = record
    mag: integer;
    cname, cid: string;
  end;
var
  list: TStringList;
  maglist: array[1..maxcombo + 1] of Tmaglist;
  i, n: integer;
  epoch, jda, tp, q, ec, ap, an, ic, hh, g, eq: double;
  ra, de, dist, r, elong, phase, magn, diam, lc, car, cde, rc, xc, yc, zc: double;
  nam, elem_id: string;
  Left, Right, SubArray, SubLeft, SubRight: integer;
  Temp, Pivot: Tmaglist;
  Stack: array[1..32] of record
    First, Last: integer;
  end;

  function SorCompare(c1, c2: Tmaglist): integer;
  begin
    if c1.mag < c2.mag then
      Result := -1
    else if c1.mag = c2.mag then
      Result := 0
    else if c1.mag > c2.mag then
      Result := 1
    else
      Result := -1;
  end;

begin
  list := TStringList.Create;
  try
    Cdb.GetCometList('', maxcombo, list, cometid);
    jda := date1.JD;
    n := list.Count;
    if n = 0 then
      exit;
    for i := 0 to n - 1 do
    begin
      maglist[i + 1].cname := list[i];
      maglist[i + 1].cid := cometid[i];
      epoch := cdb.GetCometEpoch(cometid[i], jda);
      if cdb.GetComElem(cometid[i], epoch, tp, q, ec, ap, an, ic, hh, g, eq, nam, elem_id) then
      begin
        Fplanet.InitComet(tp, q, ec, ap, an, ic, hh, g, eq, nam);
        Fplanet.Comet(jda, False, ra, de, dist, r, elong, phase, magn, diam, lc, car, cde, rc, xc, yc, zc);
        maglist[i + 1].mag := round(100 * magn);
      end
      else
      begin
        maglist[i + 1].mag := 9999;
      end;
    end;
    SubArray := 1;
    Stack[SubArray].First := 1;
    Stack[SubArray].Last := n;
    repeat
      Left := Stack[SubArray].First;
      Right := Stack[SubArray].Last;
      Dec(SubArray);
      repeat
        SubLeft := Left;
        SubRight := Right;
        Pivot := maglist[(Left + Right) shr 1];
        repeat
          while SorCompare(maglist[SubLeft], Pivot) < 0 do
            Inc(SubLeft);
          while SorCompare(maglist[SubRight], Pivot) > 0 do
            Dec(SubRight);
          if SubLeft <= SubRight then
          begin
            Temp := maglist[SubLeft];
            maglist[SubLeft] := maglist[SubRight];
            maglist[SubRight] := Temp;
            Inc(SubLeft);
            Dec(SubRight);
          end;
        until SubLeft > SubRight;
        if SubLeft < Right then
        begin
          Inc(SubArray);
          Stack[SubArray].First := SubLeft;
          Stack[SubArray].Last := Right;
        end;
        Right := SubRight;
      until Left >= Right;
    until SubArray = 0;
    list.Clear;
    for i := 1 to n do
    begin
      if maglist[i].mag >= round(100 * config.CommagMax) then
        break;
      list.Add(maglist[i].cname);
      cometid[i - 1] := maglist[i].cid;
    end;
    Combobox1.Items.Assign(list);
    Combobox1.ItemIndex := 0;
    RefreshComet;
  finally
    list.Free;
  end;
end;


procedure Tf_calendar.ComboBox1Change(Sender: TObject);
begin
  RefreshComet;
end;

procedure Tf_calendar.RefreshComet;
var
  id, nam, elem_id: string;
  i, a, m, d, s, nj, irc, irc2: integer;
  cjd, epoch: double;
  ra, Dec, dist, r, elong, phase, magn, st0, q: double;
  hh, g, ap, an, ic, ec, eq, tp, diam, lc, car, cde, rc, xc, yc, zc: double;
  hr, ht, hs, azr, azs, hp1, hp2, ars, des, ds, dds, az, ha: double;
  jda, jd0, jd1, jd2, jdt, h, st, hhh: double;
  hr1, ht1, hs1, hr2, ht2, hs2: double;
  ra1, dec1, ra2, dec2, ra3, dec3: double;
begin
  if ComboBox1.ItemIndex < 0 then
    exit;
  screen.cursor := crHourGlass;
  try
    cjd := (date1.JD + date2.JD) / 2;
    id := cometid[ComboBox1.ItemIndex];
    epoch := cdb.GetCometEpoch(id, cjd);
    if cdb.GetComElem(id, epoch, tp, q, ec, ap, an, ic, hh, g, eq, nam, elem_id) then
    begin
      Fplanet.InitComet(tp, q, ec, ap, an, ic, hh, g, eq, nam);
      //   Cometgrid.Visible:=false;
      FreeCoord(Cometgrid);
      dat31 := date1.jd;
      dat32 := date2.jd;
      dat33 := time.time;
      dat34 := step.Text;
      s := step.Value;
      djd(date1.JD, a, m, d, hhh);
      config.tz.JD := date1.JD;
      h := frac(Time.time) * 24 - config.tz.SecondsOffset / 3600;
      jd1 := jd(a, m, d, h);
      djd(date2.JD, a, m, d, hhh);
      jd2 := jd(a, m, d, h);
      nj := round((jd2 - jd1) / s);
      if nj > maxstep then
        if MessageDlg(appmsg[19] + blank + IntToStr(nj) + blank + appmsg[20],
          mtConfirmation, [mbOK, mbCancel], 0) <> mrOk then
          exit;
      jda := jd1;
      i := 2;
      Cometgrid.cells[0, 0] := trim(nam);
      Cometgrid.cells[1, 0] := trim(config.EquinoxName) + blank + appmsg[46];
      repeat
        djd(jda, a, m, d, h);
        jd0 := jd(a, m, d, 0);
        st0 := SidTim(jd0, h, config.ObsLongitude);
        config.tz.JD := jda;
        config.TimeZone := config.tz.SecondsOffset / 3600;
        Fplanet.Comet(jda, True, ra, Dec, dist, r, elong, phase, magn, diam, lc, car, cde, rc, xc, yc, zc);
        precession(jd2000, config.jdchart, ra, Dec);
        if config.PlanetParalaxe then
          Paralaxe(st0, dist, ra, Dec, ra, Dec, q, config);
        if config.ApparentPos then
          apparent_equatorial(ra, Dec, config, True, False);
        ra := rmod(ra + pi2, pi2);
        with Cometgrid do
        begin
          RowCount := i + 1;
          cells[0, 1] := trim(armtostr(h)) + ' UT';
          cells[0, i] := isodate(a, m, d);
          cells[1, i] := artostr(rad2deg * ra / 15);
          cells[2, i] := detostr(rad2deg * Dec);
          cells[3, i] := floattostrf(magn, ffFixed, 5, 1);
          cells[4, i] := demtostr(rad2deg * elong);
          cells[5, i] := demtostr(rad2deg * phase);
          objects[0, i] := SetObjCoord(jda, ra, Dec);
          RiseSet(jd0, ra, Dec, hr1, ht1, hs1, azr, azs, irc, config);
          Fplanet.Comet(jd0 + rmod((hr1 - config.TimeZone) + 24, 24) / 24, False,
            ra1, dec1, dist, r, elong, phase, magn, diam, lc, car, cde, rc, xc, yc, zc);
          precession(jd2000, config.jdchart, ra1, dec1);
          RiseSet(jd0, ra1, dec1, hr, ht2, hs2, azr, azs, irc2, config);
          Fplanet.Comet(jd0 + rmod((ht1 - config.TimeZone) + 24, 24) / 24, False,
            ra2, dec2, dist, r, elong, phase, magn, diam, lc, car, cde, rc, xc, yc, zc);
          precession(jd2000, config.jdchart, ra2, dec2);
          RiseSet(jd0, ra2, dec2, hr2, ht, hs2, azr, azs, irc2, config);
          Fplanet.Comet(jd0 + rmod((hs1 - config.TimeZone) + 24, 24) / 24, False,
            ra3, dec3, dist, r, elong, phase, magn, diam, lc, car, cde, rc, xc, yc, zc);
          precession(jd2000, config.jdchart, ra3, dec3);
          RiseSet(jd0, ra3, dec3, hr2, ht2, hs, azr, azs, irc2, config);
          case irc of
            0:
            begin
              cells[6, i] := armtostr(hr);
              cells[7, i] := armtostr(ht);
              cells[8, i] := armtostr(hs);
              objects[6, i] := SetObjCoord(jda + (hr - config.TimeZone - h) / 24, ra1, dec1);
              objects[7, i] := SetObjCoord(jda + (ht - config.TimeZone - h) / 24, ra2, dec2);
              objects[8, i] := SetObjCoord(jda + (hs - config.TimeZone - h) / 24, ra3, dec3);
            end;
            1:
            begin
              cells[6, i] := '-';
              cells[7, i] := armtostr(ht);
              objects[7, i] := SetObjCoord(jda + (ht - config.TimeZone - h) / 24, ra2, dec2);
              cells[8, i] := '-';
              objects[6, i] := nil;
              objects[8, i] := nil;
            end;
            2:
            begin
              cells[6, i] := '-';
              cells[7, i] := '-';
              cells[8, i] := '-';
              objects[6, i] := nil;
              objects[7, i] := nil;
              objects[8, i] := nil;
            end;
          end;
          Fplanet.Sun(jda, ars, des, ds, dds);
          precession(jd2000, config.jdchart, ars, des);
          // crepuscule nautique
          Time_Alt(jd0, ars, des, -12, hp1, hp2, config.ObsLatitude, config.ObsLongitude);
          if abs(hp1) < 90 then
          begin
            jdt := jd(a, m, d, hp1);
            Fplanet.Comet(jdt, False, ra, Dec, dist, r, elong, phase, magn,
              diam, lc, car, cde, rc, xc, yc, zc);
            precession(jd2000, config.jdchart, ra, Dec);
            st := Sidtim(jd0, hp1, config.ObsLongitude);
            Eq2Hz((st - ra), Dec, az, ha, config);
            az := rmod(az + pi, pi2);
            if ha > 0 then
              cells[10, i] := dedtostr(rad2deg * ha) + '  ' + StringReplace(dedtostr(rad2deg * az), '+', 'Az', [])
            else
              cells[10, i] := dedtostr(rad2deg * ha);
            objects[10, i] := SetObjCoord(jdt, ra, Dec);
          end
          else
          begin
            cells[10, i] := '-';
            objects[10, i] := nil;
          end;
          if abs(hp2) < 90 then
          begin
            jdt := jd(a, m, d, hp2);
            Fplanet.Comet(jdt, False, ra, Dec, dist, r, elong, phase, magn,
              diam, lc, car, cde, rc, xc, yc, zc);
            precession(jd2000, config.jdchart, ra, Dec);
            st := Sidtim(jd0, hp2, config.ObsLongitude);
            Eq2Hz((st - ra), Dec, az, ha, config);
            az := rmod(az + pi, pi2);
            if ha > 0 then
              cells[11, i] := dedtostr(rad2deg * ha) + '  ' + StringReplace(dedtostr(rad2deg * az), '+', 'Az', [])
            else
              cells[11, i] := dedtostr(rad2deg * ha);
            objects[11, i] := SetObjCoord(jdt, ra, Dec);
          end
          else
          begin
            cells[11, i] := '-';
            objects[11, i] := nil;
          end;
          // crepuscule astro
          Time_Alt(jd0, ars, des, -18, hp1, hp2, config.ObsLatitude, config.ObsLongitude);
          if abs(hp1) < 90 then
          begin
            jdt := jd(a, m, d, hp1);
            Fplanet.Comet(jdt, False, ra, Dec, dist, r, elong, phase, magn,
              diam, lc, car, cde, rc, xc, yc, zc);
            precession(jd2000, config.jdchart, ra, Dec);
            st := Sidtim(jd0, hp1, config.ObsLongitude);
            Eq2Hz((st - ra), Dec, az, ha, config);
            az := rmod(az + pi, pi2);
            if ha > 0 then
              cells[9, i] := dedtostr(rad2deg * ha) + '  ' + StringReplace(dedtostr(rad2deg * az), '+', 'Az', [])
            else
              cells[9, i] := dedtostr(rad2deg * ha);
            objects[9, i] := SetObjCoord(jdt, ra, Dec);
          end
          else
          begin
            cells[9, i] := '-';
            objects[9, i] := nil;
          end;
          if abs(hp2) < 90 then
          begin
            jdt := jd(a, m, d, hp2);
            Fplanet.Comet(jdt, False, ra, Dec, dist, r, elong, phase, magn,
              diam, lc, car, cde, rc, xc, yc, zc);
            precession(jd2000, config.jdchart, ra, Dec);
            st := Sidtim(jd0, hp2, config.ObsLongitude);
            Eq2Hz((st - ra), Dec, az, ha, config);
            az := rmod(az + pi, pi2);
            if ha > 0 then
              cells[12, i] := dedtostr(rad2deg * ha) + '  ' + StringReplace(dedtostr(rad2deg * az), '+', 'Az', [])
            else
              cells[12, i] := dedtostr(rad2deg * ha);
            objects[12, i] := SetObjCoord(jdt, ra, Dec);
          end
          else
          begin
            cells[12, i] := '-';
            objects[12, i] := nil;
          end;
        end;
        jda := jda + s;
        i := i + 1;
      until jda > jd2;
    end;
  finally
    //Cometgrid.Visible:=true;
    screen.cursor := crDefault;
  end;
end;

procedure Tf_calendar.Button2Click(Sender: TObject);
var
  list: TStringList;
begin
  list := TStringList.Create;
  Cdb.GetAsteroidList(AstFilter.Text, maxcombo, list, astid);
  Combobox2.Items.Assign(list);
  list.Free;
  if Combobox2.Items.Count > 0 then
  begin
    Combobox2.ItemIndex := 0;
    RefreshAsteroid;
  end;
end;

procedure Tf_calendar.ComboBox2Change(Sender: TObject);
begin
  RefreshAsteroid;
end;

procedure Tf_calendar.RefreshAsteroid;
var
  id, nam, elem_id, ref: string;
  i, a, m, d, s, nj, irc, irc2: integer;
  cjd, epoch: double;
  ra, Dec, dist, r, elong, phase, magn, xc, yc, zc, st0, q, xac, yac, zac: double;
  hh, g, ma, ap, an, ic, ec, sa, eq: double;
  hr, ht, hs, azr, azs: double;
  jda, jd0, jd1, jd2, h, hhh: double;
  hr1, ht1, hs1, hr2, ht2, hs2: double;
  ra1, dec1, ra2, dec2, ra3, dec3: double;
begin
  if Combobox2.Items.Count = 0 then
    exit;
  screen.cursor := crHourGlass;
  try
    cjd := (date1.JD + date2.JD) / 2;
    id := astid[ComboBox2.ItemIndex];
    epoch := cdb.GetAsteroidEpoch(id, cjd);
    if cdb.GetAstElem(id, epoch, hh, g, ma, ap, an, ic, ec, sa, eq, ref, nam, elem_id) then
    begin
      Fplanet.InitAsteroid(epoch, hh, g, ma, ap, an, ic, ec, sa, eq, nam);
      //   Asteroidgrid.Visible:=false;
      FreeCoord(Asteroidgrid);
      dat71 := date1.jd;
      dat72 := date2.jd;
      dat73 := time.time;
      dat74 := step.Text;
      s := step.Value;
      djd(date1.JD, a, m, d, hhh);
      config.tz.JD := date1.JD;
      h := frac(Time.time) * 24 - config.tz.SecondsOffset / 3600;
      jd1 := jd(a, m, d, h);
      djd(date2.JD, a, m, d, hhh);
      jd2 := jd(a, m, d, h);
      nj := round((jd2 - jd1) / s);
      if nj > maxstep then
        if MessageDlg(appmsg[19] + blank + IntToStr(nj) + blank + appmsg[20],
          mtConfirmation, [mbOK, mbCancel], 0) <> mrOk then
          exit;
      jda := jd1;
      i := 2;
      Asteroidgrid.cells[0, 0] := trim(nam);
      Asteroidgrid.cells[1, 0] := trim(config.EquinoxName) + blank + appmsg[46];
      repeat
        djd(jda, a, m, d, h);
        jd0 := jd(a, m, d, 0);
        st0 := SidTim(jd0, h, config.ObsLongitude);
        config.tz.JD := jda;
        config.TimeZone := config.tz.SecondsOffset / 3600;
        Fplanet.Asteroid(jda, True, ra, Dec, dist, r, elong, phase, magn, xc, yc, zc);
        precession(jd2000, config.jdchart, ra, Dec);
        if config.PlanetParalaxe then
          Paralaxe(st0, dist, ra, Dec, ra, Dec, q, config);
        if config.ApparentPos then
          apparent_equatorial(ra, Dec, config, True, False);
        ra := rmod(ra + pi2, pi2);
        with Asteroidgrid do
        begin
          RowCount := i + 1;
          cells[0, 1] := trim(armtostr(h)) + ' UT';
          cells[0, i] := isodate(a, m, d);
          cells[1, i] := artostr(rad2deg * ra / 15);
          cells[2, i] := detostr(rad2deg * Dec);
          cells[3, i] := floattostrf(magn, ffFixed, 5, 1);
          cells[4, i] := demtostr(rad2deg * elong);
          cells[5, i] := demtostr(rad2deg * phase);
          objects[0, i] := SetObjCoord(jda, ra, Dec);
          RiseSet(jd0, ra, Dec, hr1, ht1, hs1, azr, azs, irc, config);
          Fplanet.Asteroid(jd0 + rmod((hr1 - config.TimeZone) + 24, 24) / 24,
            False, ra1, dec1, dist, r, elong, phase, magn, xac, yac, zac);
          precession(jd2000, config.jdchart, ra1, dec1);
          RiseSet(jd0, ra1, dec1, hr, ht2, hs2, azr, azs, irc2, config);
          Fplanet.Asteroid(jd0 + rmod((ht1 - config.TimeZone) + 24, 24) / 24,
            False, ra2, dec2, dist, r, elong, phase, magn, xac, yac, zac);
          precession(jd2000, config.jdchart, ra2, dec2);
          RiseSet(jd0, ra2, dec2, hr2, ht, hs2, azr, azs, irc2, config);
          Fplanet.Asteroid(jd0 + rmod((hs1 - config.TimeZone) + 24, 24) / 24,
            False, ra3, dec3, dist, r, elong, phase, magn, xac, yac, zac);
          precession(jd2000, config.jdchart, ra3, dec3);
          RiseSet(jd0, ra3, dec3, hr2, ht2, hs, azr, azs, irc2, config);
          case irc of
            0:
            begin
              cells[6, i] := armtostr(hr);
              cells[7, i] := armtostr(ht);
              cells[8, i] := armtostr(hs);
              objects[6, i] := SetObjCoord(jda + (hr - config.TimeZone - h) / 24, ra1, dec1);
              objects[7, i] := SetObjCoord(jda + (ht - config.TimeZone - h) / 24, ra2, dec2);
              objects[8, i] := SetObjCoord(jda + (hs - config.TimeZone - h) / 24, ra3, dec3);
            end;
            1:
            begin
              cells[6, i] := '-';
              cells[7, i] := armtostr(ht);
              objects[7, i] := SetObjCoord(jda + (ht - config.TimeZone - h) / 24, ra2, dec2);
              cells[8, i] := '-';
              objects[6, i] := nil;
              objects[8, i] := nil;
            end;
            2:
            begin
              cells[6, i] := '-';
              cells[7, i] := '-';
              cells[8, i] := '-';
              objects[6, i] := nil;
              objects[7, i] := nil;
              objects[8, i] := nil;
            end;
          end;
        end;
        jda := jda + s;
        i := i + 1;
      until jda > jd2;
    end;
  finally
    //Asteroidgrid.Visible:=true;
    screen.cursor := crDefault;
  end;
end;

procedure Tf_calendar.BtnHelpClick(Sender: TObject);
begin
  pagecontrol1.ActivePage.ShowHelp;
  //ExecuteFile(slash(helpdir)+slash('wiki_doc')+stringreplace(rsDocumentatio,'/',PathDelim,[rfReplaceAll]));
end;

procedure Tf_calendar.DownloadTle;
var
  fn, ext: string;
  i, n: integer;
  ok, zipfile,qsmagfile: boolean;

  procedure ArchiveFile(fn, destdir: string);
  var
    buf, ext: string;
  begin
    buf := ExtractFileNameOnly(fn);
    ext := ExtractFileExt(fn);
    buf := slash(destdir) + buf + '-' + FormatDateTime('yyyy"-"mm"-"dd', TleDate(fn)) + ext;
    if CopyFile(fn, buf) then
      DeleteFile(fn);
  end;

  procedure ArchiveFiles(ext: string);
  var
    fs: TSearchRec;
    i: integer;
  begin
    i := findfirst(slash(SatDir) + '*.' + ext, 0, fs);
    while i = 0 do
    begin
      ArchiveFile(slash(SatDir) + fs.Name, SatArchiveDir);
      i := findnext(fs);
    end;
    findclose(fs);
  end;

begin
  try
    DownloadPanel.Visible := True;
    n := cmain.TleUrlList.Count;
    if n = 0 then
      exit;
    // Archive old TLE
    ArchiveFiles('tle');
    ArchiveFiles('txt');
    ArchiveFiles('TLE');
    ArchiveFiles('TXT');
    // Download TLE
    fn := slash(SatDir);
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
    DownloadDialog1.onFeedback := TLEfeedback;
    DownloadDialog1.ConfirmDownload := False;
    ok := False;
    zipfile := False;
    DownloadMemo.Clear;
    for i := 1 to n do
    begin
      if trim(cmain.TleUrlList[i - 1]) = '' then
        continue;
      DownloadDialog1.URL := cmain.TleUrlList[i - 1];
      DownloadMemo.Lines.Add('');
      DownloadMemo.Lines.Add(DownloadDialog1.URL);
      DownloadMemo.SelStart := length(DownloadMemo.Text) - 1;
      ext := LowerCase(ExtractFileExt(DownloadDialog1.URL));
      zipfile := (ext = '.zip');
      qsmagfile := pos('qsmag',DownloadDialog1.URL)>0;
      fn := slash(SatDir) + ExtractFileName(DownloadDialog1.URL);
      DownloadDialog1.SaveToFile := fn;
      if DownloadDialog1.Execute then
      begin
        ok := True;
        if zipfile then
        begin
          FileUnzipAll(PChar(fn), PChar(SatDir));
        end;
      end
      else
      begin
       if not qsmagfile then begin
        ShowMessage(Format(rsCancel2, [DownloadDialog1.ResponseText]));
        ok := False;
        break;
       end;
      end;
    end;
    if ok then
    begin
      ShowMessage(rsTLEDownloadO);
    end;
  finally
    DownloadPanel.Visible := False;
  end;
end;

procedure Tf_calendar.TLEfeedback(txt: string);
begin
  if copy(txt, 1, 9) = 'Read Byte' then
    exit;
  DownloadMemo.Lines.Add(txt);
  DownloadMemo.SelStart := length(DownloadMemo.Text) - 1;
end;

procedure Tf_calendar.UpdTleList;

  procedure FillList(ext, lst: string);
  var
    fs: TSearchRec;
    i, n: integer;
  begin
    i := findfirst(slash(SatDir) + '*.' + ext, 0, fs);
    while i = 0 do
    begin
      n := TleCheckList.Items.Add(fs.Name);
      TleCheckList.Checked[n] := (pos(fs.Name, lst) > 0);
      i := findnext(fs);
    end;
    findclose(fs);
  end;

var
  buf: string;
  j: integer;
begin
  buf := tle1.Text;
  TleCheckList.Clear;
  FillList('txt', buf);
  FillList('tle', buf);
  {$ifndef mswindows}
  FillList('TXT', buf);
  FillList('TLE', buf);
  {$endif}
  if buf = '' then
  begin
    for j := 0 to TleCheckList.Count - 1 do
      TleCheckList.Checked[j] := True;
    TleCheckListClickCheck(nil);
  end;
end;

procedure Tf_calendar.TleCheckListClickCheck(Sender: TObject);
var
  i: integer;
  buf: string;
begin
  buf := '';
  for i := 0 to TleCheckList.Count - 1 do
  begin
    if TleCheckList.Checked[i] then
      buf := buf + ',' + TleCheckList.Items[i];
  end;
  tle1.Text := copy(buf, 2, 9999);
end;


end.
