unit pu_calendar;

{$MODE Delphi} {$H+}

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

uses u_translation, Math, cu_database, Printers,
  LCLIntf, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, FileCtrl, enhedits, Grids, ComCtrls, IniFiles,
  jdcalendar, cu_planet, u_constant, pu_image, Buttons, ExtCtrls,
  ActnList, StdActns, LResources;

type
    TScFunc = procedure(csc:Tconf_skychart) of object;
    TObjCoord = class(Tobject)
                jd,ra,dec : double;
                end;

const nummsg = 47;
      maxcombo = 50;

type

  { Tf_calendar }

  Tf_calendar = class(TForm)
    BtnRefresh: TButton;
    BtnHelp: TButton;
    BtnClose: TButton;
    BtnSave: TButton;
    BtnPrint: TButton;
    BtnReset: TButton;
    SatChartBox:TCheckBox;
    IridiumBox:TCheckBox;
    fullday:TCheckBox;
    Time: TTimePicker;
    TLEListBox:TFileListBox;
    maglimit:TFloatEdit;
    magchart:TFloatEdit;
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
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure BtnRefreshClick(Sender: TObject);
    procedure BtnCloseClick(Sender: TObject);
    procedure GridMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormDestroy(Sender: TObject);
    procedure GridDblClick(Sender: TObject);
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
  private
    { Private declarations }
    initial, lockclick: boolean;
    ShowImage: Tf_image;
    Fplanet : Tplanet;
    Fnightvision: boolean;
    FGetChartConfig: TScFunc;
    Fupdchart: TScFunc;
    Feclipsepath: string;
    deltajd: double;
    dat11,dat12,dat13,dat21,dat22,dat23,dat31,dat32,dat33 : double ;
    dat41,dat51,{dat61,}dat71,dat72,dat73 : double ;
    dat14,dat24,dat34,dat74,west,east,title : string;
    century_Solar, century_Lunar: string;
    appmsg: array[1..nummsg] of string;
    cometid, astid : array[0..maxcombo] of string;
    procedure Sattitle;
    procedure Lunartitle;
    procedure Solartitle;
    procedure planettitle;
    procedure crepusculetitle;
    procedure cometetitle;
    procedure asteroidtitle;
    function SetObjCoord(jd,ra,dec: double) : Tobject;
    procedure FreeCoord(var gr : Tstringgrid);
    procedure InitRiseCell(var gr : Tstringgrid);
//    procedure PlanetRiseCell(var gr : Tstringgrid; i,irc : integer; hr,ht,hs,azr,azs,jda,h,ar,de : double);
    procedure SaveGrid(grid : tstringgrid);
    procedure Gridtoprinter(grid : tstringgrid);
    procedure RefreshAll;
    procedure RefreshTwilight;
    procedure RefreshPlanet;
    procedure RefreshComet;
    procedure RefreshAsteroid;
    procedure RefreshLunarEclipse;
    procedure RefreshSolarEclipse;
  public
    { Public declarations }
    cdb: Tcdcdb;
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


uses u_util, u_projection;

const maxstep = 100;
      MonthLst : array [1..12] of string = ('Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec');

procedure Tf_calendar.FormCreate(Sender: TObject);
var yy,mm,dd: word;
begin
SetLang;
{$ifdef win32}
 ScaleForm(self,Screen.PixelsPerInch/96);
{$endif}
config:=Tconf_skychart.Create;
Fnightvision:=false;
AzNorth:=true;
ShowImage:=Tf_image.Create(self);
decodedate(now,yy,mm,dd);
date1.JD:=jdd(yy,mm,dd,0);
date2.JD:=date1.JD+5;
time.Time:=now;
initial:=true;
end;

procedure Tf_calendar.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
CanClose:=true;
if BtnReset.Visible then begin
   if MessageDlg(Format(rsWarningTheCu, [rsResetChart]), mtWarning, mbYesNo, 0)
     = mrNo then CanClose:=false;
end;
end;

procedure Tf_calendar.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  initial:=true;
end;

procedure Tf_calendar.FormDestroy(Sender: TObject);
begin
try
ShowImage.Free;
config.Free;
except
writetrace('error destroy '+name);
end;
end;

procedure Tf_calendar.FormShow(Sender: TObject);
begin
{$ifdef WIN32}
if Fnightvision<>nightvision then begin
   SetFormNightVision(self,nightvision);
   Fnightvision:=nightvision;
   PageControl1.Invalidate;
end;
{$endif}
if initial then begin
  Satellites.TabVisible:=false;
  date1.JD:=jd(config.CurYear,config.CurMonth,config.CurDay,0);
//  date1.JD:=trunc(config.CurJD+(config.TimeZone-config.DT_UT)/24);
  date2.JD:=date1.JD+5;
  deltajd:=date2.JD-date1.JD;
  time.Time:=config.CurTime/24;
  CometFilter.Text:='C/'+inttostr(config.CurYear);
  RefreshAll;
  initial:=false;
end;
BtnReset.visible:=false;
lockclick:=true;
end;

procedure Tf_calendar.Date1Change(Sender: TObject);
begin
if deltajd<=0 then exit;
if date2.JD<=date1.JD then date2.JD:=date1.JD+deltajd;
deltajd:=date2.JD-date1.JD;
end;

procedure Tf_calendar.Date2Change(Sender: TObject);
begin
if deltajd<=0 then exit;
if date2.JD<=date1.JD then date1.JD:=date2.JD-deltajd;
deltajd:=date2.JD-date1.JD;
end;

Procedure Tf_calendar.SetLang;
begin
Caption:=rsCalendar;
Date1.Caption:=rsJDCalendar;
Date1.labels.Mon:=rsMonday;
Date1.labels.Tue:=rsTuesday;
Date1.labels.Wed:=rsWednesday;
Date1.labels.Thu:=rsThursday;
Date1.labels.Fri:=rsFriday;
Date1.labels.Sat:=rsSaturday;
Date1.labels.Sun:=rsSunday;
Date1.labels.jd:=rsJulianDay;
Date1.labels.today:=rsToday;
Date2.Caption:=rsJDCalendar;
Date2.labels.Mon:=rsMonday;
Date2.labels.Tue:=rsTuesday;
Date2.labels.Wed:=rsWednesday;
Date2.labels.Thu:=rsThursday;
Date2.labels.Fri:=rsFriday;
Date2.labels.Sat:=rsSaturday;
Date2.labels.Sun:=rsSunday;
Date2.labels.jd:=rsJulianDay;
Date2.labels.today:=rsToday;
east:=rsEast;
west:=rsWest;
EcliPanel.Hint:='http://sunearth.gsfconfig.nasa.gov/eclipse/eclipse.html';
mercure.caption:=pla[1];
venus.caption:=pla[2];
mars.caption:=pla[4];
jupiter.caption:=pla[5];
saturne.caption:=pla[6];
uranus.caption:=pla[7];
neptune.caption:=pla[8];
pluton.caption:=pla[9];
psoleil.caption:=pla[10];
plune.caption:=pla[11];
Label1.caption:=rsDateFrom;
Label2.caption:=rsTo;
Label5.caption:=rsAt;
Label3.caption:=rsBy;
Label4.caption:=rsDays;
Label9.caption:='Satellites calculation use QuickSat by Mike McCants, Iridium flare prediction use Iridflar by Robert Matson';
BtnRefresh.caption:=rsRefresh;
BtnHelp.caption:=rsHelp;
BtnClose.caption:=rsClose;
BtnSave.caption:=rsSaveToFile;
BtnPrint.caption:=rsPrint;
BtnReset.caption:=rsResetChart;
twilight.caption:=rsTwilight;
planets.caption:=rsPlanet;
comet.caption:=rsComet;
Asteroids.caption:=rsAsteroid;
Button1.caption:=rsFilter;
Button2.caption:=rsFilter;
Solar.caption:=rsSolarEclipse;
Lunar.caption:=rsLunarEclipse;
Satellites.caption:=rsArtificialSa;
Label8.caption:=rsChart2;
Label7.caption:=rsLimitingMagn;
Label6.caption:='TLE';
tle1.text:='Visual.tle';
fullday.caption:='Include day time pass';
IridiumBox.caption:='Include Iridium flare';
SatChartBox.caption:='For current chart only';
appmsg[1]:=rsRA;
appmsg[2]:=rsDE;
appmsg[3]:=rsMagn;
appmsg[4]:=rsDiam;
appmsg[5]:=rsIllum;
appmsg[6]:=rsRise;
appmsg[7]:=rsCulmination;
appmsg[8]:=rsSet;
appmsg[9]:=rsMorningTwili;
appmsg[10]:=rsEveningTwili;
appmsg[11]:=rsDate;
appmsg[12]:=rsAstronomical;
appmsg[13]:=rsNautical;
appmsg[14]:=rsTwilight;
appmsg[15]:=rsMorning;
appmsg[16]:=rsEvening;
appmsg[17]:=rsElong;
appmsg[18]:=rsPhase;
appmsg[19]:=rsWarningCalcu;
appmsg[20]:=rsDatesMayTake;
appmsg[21]:=rsAz;
appmsg[22]:=rsAlt;
appmsg[23]:=rsUT;
appmsg[24]:=rsMax;
appmsg[25]:=rsType;
appmsg[26]:=rsSaros;
appmsg[27]:=rsGamma;
appmsg[28]:=rsMagnitude;
appmsg[29]:=rsGreatest;
appmsg[30]:=rsEclipse;
appmsg[31]:=rsLatitude;
appmsg[32]:=rsLongitude;
appmsg[33]:=rsSunAlt;
appmsg[34]:=rsPathWidth;
appmsg[35]:=rsDuration;
appmsg[36]:=rsPenumbra;
appmsg[37]:=rsUmbra;
appmsg[38]:=rsSemi;
appmsg[39]:=rsDuration;
appmsg[40]:=rsPartial;
appmsg[41]:=rsTotal;
appmsg[42]:=rsSatellite;
appmsg[43]:=rsRange;
appmsg[44]:='+/-';
appmsg[45]:=rsDir;
appmsg[46]:=rsCoord;
appmsg[47]:=rsMap;
title:=caption;
crepusculetitle;
cometetitle;
asteroidtitle;
planettitle;
Solartitle;
LunarTitle;
SatTitle; 
if ShowImage<>nil then ShowImage.SetLang;
end;

Procedure Tf_calendar.cometetitle;
begin
with cometgrid do begin
cells[9,0]:=appmsg[14];
cells[10,0]:=appmsg[15];
cells[11,0]:=appmsg[14];
cells[12,0]:=appmsg[16];
cells[0,1]:=appmsg[11];
cells[1,1]:=appmsg[1];
cells[2,1]:=appmsg[2];
cells[3,1]:=appmsg[3];
cells[4,1]:=appmsg[17];
cells[5,1]:=appmsg[18];
cells[6,1]:=appmsg[6];
cells[7,1]:=appmsg[7];
cells[8,1]:=appmsg[8];
cells[9,1]:=appmsg[12];
cells[10,1]:=appmsg[13];
cells[11,1]:=appmsg[13];
cells[12,1]:=appmsg[12];
end;
end;

Procedure Tf_calendar.asteroidtitle;
begin
with asteroidgrid do begin
//cells[9,0]:=appmsg[14];
//cells[10,0]:=appmsg[15];
//cells[11,0]:=appmsg[14];
//cells[12,0]:=appmsg[16];
cells[0,1]:=appmsg[11];
cells[1,1]:=appmsg[1];
cells[2,1]:=appmsg[2];
cells[3,1]:=appmsg[3];
cells[4,1]:=appmsg[17];
cells[5,1]:=appmsg[18];
cells[6,1]:=appmsg[6];
cells[7,1]:=appmsg[7];
cells[8,1]:=appmsg[8];
end;
end;

Procedure Tf_calendar.crepusculetitle;
begin
with twilightgrid do begin
cells[1,0]:=appmsg[9];
cells[2,0]:='';
cells[3,0]:=appmsg[10];
cells[4,0]:='';
cells[0,1]:=appmsg[11];
cells[1,1]:=appmsg[12];
cells[2,1]:=appmsg[13];
cells[3,1]:=appmsg[13];
cells[4,1]:=appmsg[12];
end;
end;

Procedure Tf_calendar.planettitle;
begin
with Soleilgrid do begin
cells[1,1]:=appmsg[1];
cells[2,1]:=appmsg[2];
cells[3,1]:=appmsg[3];
cells[4,1]:=appmsg[4];
cells[5,1]:=appmsg[5];
cells[6,1]:=appmsg[6];
cells[7,1]:=appmsg[7];
cells[8,1]:=appmsg[8];
cells[9,1]:=appmsg[21];
cells[10,1]:=appmsg[22];
end;
with Mercuregrid do begin
cells[1,1]:=appmsg[1];
cells[2,1]:=appmsg[2];
cells[3,1]:=appmsg[3];
cells[4,1]:=appmsg[4];
cells[5,1]:=appmsg[5];
cells[6,1]:=appmsg[6];
cells[7,1]:=appmsg[7];
cells[8,1]:=appmsg[8];
cells[9,1]:=appmsg[21];
cells[10,1]:=appmsg[22];
end;
with venusgrid do begin
cells[1,1]:=appmsg[1];
cells[2,1]:=appmsg[2];
cells[3,1]:=appmsg[3];
cells[4,1]:=appmsg[4];
cells[5,1]:=appmsg[5];
cells[6,1]:=appmsg[6];
cells[7,1]:=appmsg[7];
cells[8,1]:=appmsg[8];
cells[9,1]:=appmsg[21];
cells[10,1]:=appmsg[22];
end;
with lunegrid do begin
cells[1,1]:=appmsg[1];
cells[2,1]:=appmsg[2];
cells[3,1]:=appmsg[3];
cells[4,1]:=appmsg[4];
cells[5,1]:=appmsg[5];
cells[6,1]:=appmsg[6];
cells[7,1]:=appmsg[7];
cells[8,1]:=appmsg[8];
cells[9,1]:=appmsg[21];
cells[10,1]:=appmsg[22];
end;
with Marsgrid do begin
cells[1,1]:=appmsg[1];
cells[2,1]:=appmsg[2];
cells[3,1]:=appmsg[3];
cells[4,1]:=appmsg[4];
cells[5,1]:=appmsg[5];
cells[6,1]:=appmsg[6];
cells[7,1]:=appmsg[7];
cells[8,1]:=appmsg[8];
cells[9,1]:=appmsg[21];
cells[10,1]:=appmsg[22];
end;
with jupitergrid do begin
cells[1,1]:=appmsg[1];
cells[2,1]:=appmsg[2];
cells[3,1]:=appmsg[3];
cells[4,1]:=appmsg[4];
cells[5,1]:=appmsg[5];
cells[6,1]:=appmsg[6];
cells[7,1]:=appmsg[7];
cells[8,1]:=appmsg[8];
cells[9,1]:=appmsg[21];
cells[10,1]:=appmsg[22];
end;
with saturnegrid do begin
cells[1,1]:=appmsg[1];
cells[2,1]:=appmsg[2];
cells[3,1]:=appmsg[3];
cells[4,1]:=appmsg[4];
cells[5,1]:=appmsg[5];
cells[6,1]:=appmsg[6];
cells[7,1]:=appmsg[7];
cells[8,1]:=appmsg[8];
cells[9,1]:=appmsg[21];
cells[10,1]:=appmsg[22];
end;
with uranusgrid do begin
cells[1,1]:=appmsg[1];
cells[2,1]:=appmsg[2];
cells[3,1]:=appmsg[3];
cells[4,1]:=appmsg[4];
cells[5,1]:=appmsg[5];
cells[6,1]:=appmsg[6];
cells[7,1]:=appmsg[7];
cells[8,1]:=appmsg[8];
cells[9,1]:=appmsg[21];
cells[10,1]:=appmsg[22];
end;
with neptunegrid do begin
cells[1,1]:=appmsg[1];
cells[2,1]:=appmsg[2];
cells[3,1]:=appmsg[3];
cells[4,1]:=appmsg[4];
cells[5,1]:=appmsg[5];
cells[6,1]:=appmsg[6];
cells[7,1]:=appmsg[7];
cells[8,1]:=appmsg[8];
cells[9,1]:=appmsg[21];
cells[10,1]:=appmsg[22];
end;
with plutongrid do begin
cells[1,1]:=appmsg[1];
cells[2,1]:=appmsg[2];
cells[3,1]:=appmsg[3];
cells[4,1]:=appmsg[4];
cells[5,1]:=appmsg[5];
cells[6,1]:=appmsg[6];
cells[7,1]:=appmsg[7];
cells[8,1]:=appmsg[8];
cells[9,1]:=appmsg[21];
cells[10,1]:=appmsg[22];
end;
end;

Procedure Tf_calendar.Solartitle;
begin
with solargrid do begin
cells[0,1]:=appmsg[11];
cells[1,1]:=appmsg[47];
cells[2,0]:=appmsg[23];
cells[2,1]:=appmsg[24];
cells[3,1]:=appmsg[25];
cells[4,1]:=appmsg[26];
cells[5,1]:=appmsg[27];
cells[6,1]:=appmsg[28];
cells[7,0]:=appmsg[29];
cells[7,1]:=appmsg[31];
cells[8,0]:=appmsg[30];
cells[8,1]:=appmsg[32];
cells[9,1]:=appmsg[33];
cells[10,1]:=appmsg[34];
cells[11,1]:=appmsg[35];

end;
end;

Procedure Tf_calendar.Lunartitle;
begin
with Lunargrid do begin
cells[0,1]:=appmsg[11];
cells[1,0]:=appmsg[23];
cells[1,1]:=appmsg[24];
cells[2,1]:=appmsg[25];
cells[3,1]:=appmsg[26];
cells[4,1]:=appmsg[27];
cells[5,0]:=appmsg[36];
cells[5,1]:=appmsg[28];
cells[6,0]:=appmsg[37];
cells[6,1]:=appmsg[28];
cells[7,0]:=appmsg[38];
cells[7,1]:=appmsg[40];
cells[8,0]:=appmsg[39];
cells[8,1]:=appmsg[41];
end;
end;

Procedure Tf_calendar.Sattitle;
begin
with Satgrid do begin
cells[0,1]:=appmsg[11];
cells[1,1]:=appmsg[42];
cells[2,1]:=appmsg[3];
cells[3,1]:=appmsg[21];
cells[4,1]:=appmsg[22];
cells[5,1]:=appmsg[43];
cells[6,1]:=appmsg[1];
cells[7,1]:=appmsg[2];
cells[8,1]:=appmsg[44];
cells[9,1]:=appmsg[45];
end;
end;

function Tf_calendar.SetObjCoord(jd,ra,dec: double) : Tobject;
var p : TObjCoord;
begin
  p:=TObjCoord.Create;
  p.jd:=jd;
  p.ra:=ra;
  p.dec:=dec;
  result:=p;
end;

Procedure Tf_calendar.FreeCoord(var gr : Tstringgrid);
var i,j : integer;
begin
try
if gr<>nil then with gr as Tstringgrid do
  if rowcount>=3 then
    for i:=2 to rowcount-1 do
      for j:=0 to colcount-1 do
        if Objects[j,i]<>nil then Objects[j,i].Free;
except
  gr.Cells[0,0]:='';
end;
end;

Procedure Tf_calendar.InitRiseCell(var gr : Tstringgrid);
var i : integer;
begin
with gr do
    for i:=2 to rowcount-1 do begin
        cells[6,i]:=''; cells[7,i]:=''; cells[8,i]:='';
        end;
end;

procedure Tf_calendar.RefreshSolarEclipse;
var f : textfile;
    buf,mm,century,pathimage : string;
    h,jda : double;
    i,n,a,m,j : integer;
begin
dat41:=date1.JD;
djd(dat41,j,m,a,h);
if j>0 then begin
  j:=j-1;
  century:=padzeros(inttostr(1+((abs(j)) div 100)),2);
end else begin
  century:=padzeros(inttostr(((abs(j)) div 100)),2);
  century:='-'+century;
end;
if century_Solar<>century then begin // lire le fichier la premiere fois
FreeCoord(Solargrid);
solargrid.RowCount:=3;
for i:=0 to solargrid.ColCount-1 do solargrid.Cells[i,2]:='';
if not fileexists(slash(Feclipsepath)+'solar'+century+'.txt') then exit;
screen.cursor:=crHourglass;
try
Filemode:=0;
Assignfile(f,slash(Feclipsepath)+'solar'+century+'.txt');
reset(f);
i:=2;
//solargrid.visible:=false;
repeat
Readln(f,buf);
with solargrid do begin
  RowCount:=i+1;
  cells[0,i]:=copy(buf,1,12);
  cells[2,i]:=copy(buf,15,5);
  cells[3,i]:=copy(buf,23,3);
  cells[4,i]:=copy(buf,26,4);
  cells[5,i]:=copy(buf,31,6);
  cells[6,i]:=copy(buf,39,5);
  cells[7,i]:=copy(buf,46,5);
  cells[8,i]:=copy(buf,52,6);
  cells[9,i]:=copy(buf,60,2);
  cells[10,i]:=copy(buf,63,4);
  cells[11,i]:=copy(buf,69,6);
  pathimage:=slash(Feclipsepath)+'SE'+stringreplace(cells[0,i],blank,'',[rfReplaceAll])+copy(cells[3,i],1,1)+'.png';
  if fileexists(pathimage) then cells[1,i]:=appmsg[47]
                           else cells[1,i]:='';
  a:=strtointdef(copy(cells[0,i],1,5),-9999);
  mm:=copy(cells[0,i],7,3);
  m:=0;
  for n:=1 to 12 do
      if mm=monthlst[n] then begin
         m:=n;
         break;
      end;
  j:=strtointdef(copy(cells[0,i],11,2),0);
  if (a<>-9999)and(m<>0)and(j<>0) then begin
     h:=strtofloat(copy(cells[2,i],1,2))+strtofloat(copy(cells[2,i],4,2))/60;
     jda:=jd(a,m,j,h);
     objects[0,i]:=SetObjCoord(jda,-1000,-1000);
  end;
end;
i:=i+1;
until eof(f);
century_Solar:=century;
finally
//solargrid.visible:=true;
Closefile(f);
screen.cursor:=crDefault;
end;
end; // fin lecture fichier
djd(dat41,a,m,j,h);
with solargrid do begin
  for i:=2 to rowcount-1 do begin
     if strtoint(copy(cells[0,i],1,5))=a then begin
        toprow:=i;
        break;
     end;
     if strtoint(copy(cells[0,i],1,5))>a then begin
        toprow:=i-1;
        break;
     end;
  end;
end;
end;

procedure Tf_calendar.RefreshLunarEclipse;
var f : textfile;
    buf,mm,century : string;
    h,jda : double;
    i,n,a,m,j : integer;
begin
dat51:=date1.jd;
djd(dat51,j,m,a,h);
if j>0 then begin
  j:=j-1;
  century:=padzeros(inttostr(1+((abs(j)) div 100)),2);
end else begin
  century:=padzeros(inttostr(((abs(j)) div 100)),2);
  century:='-'+century;
end;
if century_Lunar<>century then begin // lire le fichier la premiere fois
FreeCoord(Lunargrid);
lunargrid.RowCount:=3;
for i:=0 to lunargrid.ColCount-1 do lunargrid.Cells[i,2]:='';
if not fileexists(slash(Feclipsepath)+'lunar'+century+'.txt') then exit;
screen.cursor:=crHourglass;
try
Filemode:=0;
Assignfile(f,slash(Feclipsepath)+'lunar'+century+'.txt');
reset(f);
i:=2;
//lunargrid.visible:=false;
repeat
Readln(f,buf);
with lunargrid do begin
  RowCount:=i+1;
  cells[0,i]:=copy(buf,1,12);
  cells[1,i]:=copy(buf,15,5);
  cells[2,i]:=copy(buf,21,3);
  cells[3,i]:=copy(buf,25,3);
  cells[4,i]:=copy(buf,30,6);
  cells[5,i]:=copy(buf,38,5);
  cells[6,i]:=copy(buf,44,6);
  cells[7,i]:=copy(buf,51,4);
  cells[8,i]:=copy(buf,56,4);
  a:=strtointdef(copy(cells[0,i],1,5),-9999);
  mm:=copy(cells[0,i],7,3);
  m:=0;
  for n:=1 to 12 do
      if mm=monthlst[n] then begin
         m:=n;
         break;
      end;
  j:=strtointdef(copy(cells[0,i],11,2),0);
  if (a<>-9999)and(m<>0)and(j<>0) then begin
     h:=strtofloat(copy(cells[1,i],1,2))+strtofloat(copy(cells[1,i],4,2))/60;
     jda:=jd(a,m,j,h);
     objects[0,i]:=SetObjCoord(jda,-1000,-1000);
  end;
end;
i:=i+1;
until eof(f);
century_Lunar:=century;
finally
//lunargrid.visible:=true;
Closefile(f);
screen.cursor:=crDefault;
end;
end; // fin lecture fichier
djd(dat51,a,m,j,h);
with lunargrid do begin
  for i:=2 to rowcount-1 do begin
     if strtoint(copy(cells[0,i],1,5))=a then begin
        toprow:=i;
        break;
     end;
     if strtoint(copy(cells[0,i],1,5))>a then begin
        toprow:=i-1;
        break;
     end;
  end;
end;
end;

procedure Tf_calendar.RefreshAll;
var z1,z2: string;
begin
  RefreshTwilight;
  RefreshPlanet;
//  RefreshSolarEclipse;
//  RefreshLunarEclipse;
  config.tz.JD:=date1.JD;
  z1:=config.tz.ZoneName;
  config.tz.JD:=date2.JD;
  z2:=config.tz.ZoneName;
  if z1<>z2 then z1:=z1+'/'+z2;
  caption:=title+blank+config.Obsname+blank+rsTimeZone+'='+z1;
end;

procedure Tf_calendar.RefreshTwilight;
var jda,jd0,jd1,jd2,h,hh : double;
    hp1,hp2,ars,des,dist,diam :Double;
    a,m,d,s,i,nj : integer;
begin
screen.cursor:=crHourglass;
try
//TwilightGrid.Visible:=false;
FreeCoord(TwilightGrid);
dat11:=date1.JD;
dat12:=date2.JD;
dat13:=time.time;
dat14:=step.text;
s:=strtoint(step.text);
djd(date1.JD,a,m,d,hh);
config.tz.JD:=date1.JD;
config.TimeZone:=config.tz.SecondsOffset/3600;;
h:=12-config.TimeZone;
jd1:=jd(a,m,d,h);
djd(date2.JD,a,m,d,hh);
jd2:=jd(a,m,d,h);
nj:=round((jd2-jd1)/s);
if nj>maxstep then if MessageDlg(appmsg[19]+blank+inttostr(nj)+blank+appmsg[20],
    mtConfirmation,[mbOk, mbCancel], 0) <> mrOK then exit;
jda:=jd1;
i:=2;
repeat
djd(jda,a,m,d,h);
jd0:=jd(a,m,d,0);
config.tz.JD:=jda;
config.timezone:=config.tz.SecondsOffset/3600;
with TwilightGrid do begin
  RowCount:=i+1;
  cells[0,i]:=isodate(a,m,d);
  Fplanet.Sun(jd0+0.5,ars,des,dist,diam);
  if (ars<0) then ars:=ars+pi2;
  objects[0,i]:=SetObjCoord(jda,-999,-999);
  // crepuscule nautique
  Time_Alt(jd0,ars,des,-12,hp1,hp2,config);
  if hp1>-99 then begin
     cells[2,i]:=armtostr(rmod(hp1+config.timezone+24,24));
     objects[2,i]:=SetObjCoord(jda+(hp1-h)/24,-999,-999);
  end else  begin
     cells[2,i]:='-';
     objects[2,i]:=nil;
  end;
  if hp1>-99 then begin
     cells[3,i]:=armtostr(rmod(hp2+config.timezone+24,24));
     objects[3,i]:=SetObjCoord(jda+(hp2-h)/24,-999,-999);
  end else  begin
     cells[3,i]:='-';
     objects[3,i]:=nil;
  end;
  // crepuscule astro
  Time_Alt(jd0,ars,des,-18,hp1,hp2,config);
  if hp1>-99 then begin
     cells[1,i]:=armtostr(rmod(hp1+config.timezone+24,24));
     objects[1,i]:=SetObjCoord(jda+(hp1-h)/24,-999,-999);
  end else begin
     cells[1,i]:='-';
     objects[1,i]:=nil;
  end;
  if hp1>-99 then begin
     cells[4,i]:=armtostr(rmod(hp2+config.timezone+24,24));
     objects[4,i]:=SetObjCoord(jda+(hp2-h)/24,-999,-999);
  end else begin
     cells[4,i]:='-';
     objects[4,i]:=nil;
  end;
end;
jda:=jda+s;
i:=i+1;
until jda>jd2;
finally
//TwilightGrid.Visible:=true;
screen.cursor:=crDefault;
end;
end;

procedure Tf_calendar.RefreshPlanet;
var ar,de,dist,illum,phase,diam,jda,magn,dkm,q,az,ha,dp : double;
    i,ipla,nj: integer;
    s,a,m,d,irc : integer;
    jd1,jd2,jd0,h,jdr,jdt,jds,st0,hh: double;
    rar,der,rat,det,ras,des : double;
    jdt_ut : double;
    mr,mt,ms,azr,azs : string;

procedure ComputeRow(gr:TstringGrid; ipla:integer);
var PSat,aSat,bSat,beSat,sbSat: double;
begin
with gr do begin
  RowCount:=i+1;
  case ipla of
  1..9: begin
    planet.Planet(ipla,jda+jdt_ut,ar,de,dist,illum,phase,diam,magn,dp);
    precession(jd2000,config.jdchart,ar,de);
    if config.PlanetParalaxe then Paralaxe(st0,dist,ar,de,ar,de,q,config);
    if config.ApparentPos then apparent_equatorial(ar,de,config);
    if ipla=6 then begin  // ring magn. correction
       planet.SatRing(jda+jdt_ut,PSat,aSat,bSat,beSat);
       sbSat:=sin(deg2rad*abs(beSat));
       magn:=magn-2.6*sbSat+1.25*sbSat*sbSat;
    end;
    end;
  10: begin
    Planet.Sun(jda+jdt_ut,ar,de,dist,diam);
    precession(jd2000,config.jdchart,ar,de);
    if config.PlanetParalaxe then Paralaxe(st0,dist,ar,de,ar,de,q,config);
    if config.ApparentPos then apparent_equatorial(ar,de,config);
    illum:=1;
    magn:=-26.7;
    end;
  11: begin
    planet.Moon(jda+jdt_ut,ar,de,dist,dkm,diam,phase,illum);
    precession(jd2000,config.jdchart,ar,de);
    if config.PlanetParalaxe then begin
       Paralaxe(st0,dist,ar,de,ar,de,q,config);
       diam:=diam/q;
    end;
    if config.ApparentPos then apparent_equatorial(ar,de,config);
    magn:=planet.MoonMag(phase);
    end;
  end;
  ar:=rmod(ar+pi2,pi2);
  objects[0,i]:=SetObjCoord(jda,ar,de);
  Eq2Hz((st0-ar),de,az,ha,config);
  az:=rmod(az+pi,pi2);
  cells[0,0]:=pla[ipla];
  cells[1,0]:=trim(config.EquinoxName)+blank+appmsg[46];
  cells[0,1]:=trim(armtostr(h))+' UT';
  cells[0,i]:=isodate(a,m,d);
  cells[1,i]:=artostr(rad2deg*ar/15);
  cells[2,i]:=detostr(rad2deg*de);
  cells[3,i]:=floattostrf(magn,ffFixed,5,1);
  cells[4,i]:=floattostrf(diam,ffFixed,6,1);
  cells[5,i]:=floattostrf(illum,ffFixed,6,2);
  cells[9,i]:=demtostr(rad2deg*az);
  cells[10,i]:=demtostr(rad2deg*ha);
  Planet.PlanetRiseSet(ipla,jd0,AzNorth,mr,mt,ms,azr,azs,jdr,jdt,jds,rar,der,rat,det,ras,des,irc,config);
  case irc of
       0 : begin
           cells[6,i]:=mr; cells[7,i]:=mt; cells[8,i]:=ms;
           if trim(mr)>'' then objects[6,i]:=SetObjCoord(jdr,rar,der)
                          else objects[6,i]:=nil;
           if trim(mt)>'' then objects[7,i]:=SetObjCoord(jdt,rat,det)
                          else objects[7,i]:=nil;
           if trim(ms)>'' then objects[8,i]:=SetObjCoord(jds,ras,des)
                          else objects[8,i]:=nil;
           end;
       1 : begin
           cells[6,i]:='-'; cells[7,i]:=mt; cells[8,i]:='-';
           objects[6,i]:=nil;
           if trim(mt)>'' then objects[7,i]:=SetObjCoord(jdt,rat,det)
                          else objects[7,i]:=nil;
           objects[8,i]:=nil;
           end;
       2 : begin
           cells[6,i]:='-'; cells[7,i]:='-'; cells[8,i]:='-';
           objects[6,i]:=nil;
           objects[7,i]:=nil;
           objects[8,i]:=nil;
           end;
  end;
end;
end;

// RefreshPlanet
begin
screen.cursor:=crHourGlass;
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
dat21:=date1.JD;
dat22:=date2.JD;
dat23:=time.time;
dat24:=step.text;
s:=strtoint(step.text);
djd(date1.JD,a,m,d,hh);
config.tz.JD:=date1.JD;
h:=frac(Time.time)*24-config.tz.SecondsOffset/3600;
jd1:=jd(a,m,d,h);
djd(date2.JD,a,m,d,hh);
jd2:=jd(a,m,d,h);
nj:=round((jd2-jd1)/s);
if nj>maxstep then if MessageDlg(appmsg[19]+blank+inttostr(nj)+blank+appmsg[20],
    mtConfirmation,[mbOk, mbCancel], 0) <> mrOK then exit;
jda:=jd1;
i:=2;
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
djd(jda,a,m,d,h);
jd0:=jd(a,m,d,0);
jdt_ut:=DTminusUT(a,config)/24;
st0:=SidTim(jd0,h,config.ObsLongitude);
config.tz.JD:=jda;
config.TimeZone:=config.tz.SecondsOffset/3600;
for ipla:=1 to 11 do begin
 if ipla=3 then continue;
case ipla of
 1 : ComputeRow(Mercuregrid,ipla);
 2 : ComputeRow(Venusgrid,ipla);
 4 : ComputeRow(Marsgrid,ipla);
 5 : ComputeRow(Jupitergrid,ipla);
 6 : ComputeRow(Saturnegrid,ipla);
 7 : ComputeRow(Uranusgrid,ipla);
 8 : ComputeRow(Neptunegrid,ipla);
 9 : ComputeRow(Plutongrid,ipla);
 10 : ComputeRow(Soleilgrid,ipla);
 11 : ComputeRow(Lunegrid,ipla);
 end;
end;
jda:=jda+s;
i:=i+1;
until jda>jd2;
finally
screen.cursor:=crDefault;
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

procedure Tf_calendar.BtnRefreshClick(Sender: TObject);
var z1,z2: string;
begin
chdir(appdir);
case pagecontrol1.ActivePage.TabIndex of
     0 : RefreshTwilight;
     1 : RefreshPlanet;
     2 : RefreshComet;
     3 : RefreshAsteroid;
     4 : RefreshSolarEclipse;
     5 : RefreshLunarEclipse;
//     6 : RefreshSat;
end;
config.tz.JD:=date1.JD;
z1:=config.tz.ZoneName;
config.tz.JD:=date2.JD;
z2:=config.tz.ZoneName;
if z1<>z2 then z1:=z1+'/'+z2;
caption:=title+blank+config.Obsname+blank+rsTimeZone+'='+z1;
end;

procedure Tf_calendar.BtnCloseClick(Sender: TObject);
begin
Close;
end;

procedure Tf_calendar.GridDblClick(Sender: TObject);
begin
lockclick:=false;
end;

procedure Tf_calendar.GridMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  aColumn, aRow: Longint;
  csconfig: Tconf_skychart;
  p : TObjCoord;
  pathimage: string;
  a,d: double;
begin
if lockclick then exit;
lockclick:=true;
csconfig:=Tconf_skychart.Create;
try
with Tstringgrid(sender) do begin
MouseToCell(X, Y, aColumn, aRow);
if (aRow>=0)and(aColumn>=0) then begin
  p:=TObjCoord(Objects[aColumn,aRow]);
  if p=nil then p:=TObjCoord(Objects[0,aRow]);
  if p<>nil then begin
    if assigned(FGetChartConfig) then FGetChartConfig(csconfig)
                                 else csconfig.Assign(config);
    csconfig.UseSystemTime:=false;
    csconfig.tz.JD:=p.jd;
    csconfig.TimeZone:=csconfig.tz.SecondsOffset/3600;
    djd(p.jd+csconfig.timezone/24,csconfig.CurYear,csconfig.CurMonth,csconfig.CurDay,csconfig.CurTime);
    if Sender = solargrid then  begin      // Solar eclipse
       if (aColumn=1) then begin   // image map
         pathimage:=slash(Feclipsepath)+'SE'+stringreplace(cells[0,aRow],blank,'',[rfReplaceAll])+copy(cells[3,aRow],1,1)+'.png';
         if fileexists(pathimage) then begin
            ShowImage.labeltext:=eclipanel.caption;
            ShowImage.titre:=solar.Caption+blank+inttostr(csconfig.CurMonth)+'/'+inttostr(csconfig.CurYear);
            ShowImage.LoadImage(pathimage);
            ShowImage.ClientHeight:=min(screen.Height-80,ShowImage.imageheight+ShowImage.Panel1.Height+ShowImage.HScrollBar.Height);
            ShowImage.ClientWidth:=min(screen.Width-50,ShowImage.imagewidth+ShowImage.VScrollBar.Width);
            ShowImage.image1.ZoomMin:=1;
            ShowImage.Init;
            ShowImage.Show;
         end;
         exit;
       end;
       csconfig.TrackOn:=true;     // set tracking to the Sun
       csconfig.TrackType:=1;
       csconfig.TrackObj:=10;
       csconfig.PlanetParalaxe:=true;
       csconfig.ShowPlanet:=true;
       if (aColumn=7)or(aColumn=8) then begin         // change location to eclipse maxima
         d:=strtofloat(copy(cells[7,aRow],1,4));
         if copy(cells[7,aRow],5,1)='S' then d:=-d;
         a:=strtofloat(copy(cells[8,aRow],1,5));
         if copy(cells[8,aRow],6,1)='E' then a:=-a;
         csconfig.ObsLatitude:=d;
         csconfig.ObsLongitude:=a;
         csconfig.ObsName:='Max. Solar Eclipse '+inttostr(csconfig.CurMonth)+'/'+inttostr(csconfig.CurYear);
       end;
       BtnReset.visible:=true;
       if assigned(Fupdchart) then Fupdchart(csconfig);
    end else if sender = lunargrid then begin
       csconfig.TrackOn:=true;         // Lunar eclipse
       csconfig.TrackType:=1;          // set tracking to the Moon
       csconfig.TrackObj:=11;
       csconfig.PlanetParalaxe:=true;
       csconfig.ShowPlanet:=true;
       csconfig.ShowEarthShadow:=true;
       BtnReset.visible:=true;
       if assigned(Fupdchart) then Fupdchart(csconfig);
    end else if sender = Satgrid then begin    // Satellites
           // .....
    end else begin  // other grid
       if p.ra>-900 then csconfig.racentre:=p.ra;
       if p.dec>-900 then csconfig.decentre:=p.dec
       else begin
         csconfig.TrackOn:=true;
         csconfig.TrackType:=4;
       end;
       BtnReset.visible:=true;
       if assigned(Fupdchart) then Fupdchart(csconfig);
    end;
  end; // p<>nil
end; // row>=0..
end; // with ..
csconfig.free;
except
csconfig.free;
end;
end;

procedure Tf_calendar.PageControl1Change(Sender: TObject);
   procedure Dategroup1(onoff : boolean);
   begin
   label2.visible:=onoff;
   date2.visible:=onoff;
   end;

   procedure Dategroup2(onoff : boolean);
   begin
   label3.visible:=onoff;
   label4.visible:=onoff;
   label5.visible:=onoff;
   step.visible:=onoff;
   time.visible:=onoff;
   EcliPanel.visible:=false;
   SatPanel.visible:=false;
   end;
begin
case pagecontrol1.ActivePage.TabIndex of
     0 : begin
         Dategroup1(true);
         Dategroup2(true);
         if (dat11<>date1.jd)or(dat12<>date2.jd)or(dat13<>time.time)or(dat14<>step.text) then
            RefreshTwilight;
         end;
     1 : begin
         Dategroup1(true);
         Dategroup2(true);
         if (dat21<>date1.jd)or(dat22<>date2.jd)or(dat23<>time.time)or(dat24<>step.text) then
            RefreshPlanet;
         end;
     2 : begin
         Dategroup1(true);
         Dategroup2(true);
         if (cometgrid.Cells[0,2]<>'')and((dat31<>date1.jd)or(dat32<>date2.jd)or(dat33<>time.time)or(dat34<>step.text)) then
            RefreshComet;
         end;
     3 : begin
         Dategroup1(true);
         Dategroup2(true);
         if (asteroidgrid.Cells[0,2]<>'')and((dat71<>date1.jd)or(dat72<>date2.jd)or(dat73<>time.time)or(dat74<>step.text)) then
            RefreshAsteroid;
         end;
     4 : begin
         Dategroup1(false);
         Dategroup2(false);
         EcliPanel.Visible:=true;
         if (dat41<>date1.jd) then RefreshSolarEclipse;
         end;
     5 : begin
         Dategroup1(false);
         Dategroup2(false);
         EcliPanel.Visible:=true;
         if (dat51<>date1.jd) then RefreshLunarEclipse;
         end;
     6 : begin
         Dategroup1(true);
         Dategroup2(false);
         SatPanel.Visible:=true;
         end;

end;
end;

Procedure Tf_calendar.SaveGrid(grid : tstringgrid);
var buf,d,z1,z2 : string;
    i,j : integer;
    x : double;
    lst:TStringList;
begin
lst:=TStringList.Create;
buf:='"'+config.ObsName+'";"';
x:=abs(config.ObsLongitude);
if config.ObsLongitude>0 then d:=west else d:=east;
buf:=buf+appmsg[32]+'='+stringreplace(copy(detostr(x),2,99),'"','""',[rfReplaceAll])+d+'";"'+appmsg[31]+'='+stringreplace(detostr(config.ObsLatitude),'"','""',[rfReplaceAll])+'";"';
config.tz.JD:=date1.JD;
z1:=config.tz.ZoneName;
config.tz.JD:=date2.JD;
z2:=config.tz.ZoneName;
if z1<>z2 then z1:=z1+'/'+z2;
buf:=buf+rsTimeZone+'='+z1+'"';
lst.Add(buf);
for i:=0 to grid.RowCount-1 do begin
  for j:=0 to grid.ColCount-1 do begin
    if j=0 then buf:= '"'+stringreplace(grid.cells[j,i],'"','""',[rfReplaceAll])
           else buf:=buf+'";"'+stringreplace(grid.cells[j,i],'"','""',[rfReplaceAll]);
  end;
  buf:=buf+'"';
  lst.Add(buf);
end;
try
Savedialog1.DefaultExt:='.csv';
Savedialog1.filter:='Tab Separated File (*.csv)|*.csv';
Savedialog1.Initialdir:=privatedir;
if SaveDialog1.Execute then
   lst.SaveToFile(savedialog1.Filename);
finally
ChDir(appdir);
end;
lst.free;
end;

procedure Tf_calendar.BtnSaveClick(Sender: TObject);
begin
case pagecontrol1.ActivePage.TabIndex of
 0 : SaveGrid(TwilightGrid);
 1 : case pagecontrol2.ActivePage.TabIndex of
     0 : SaveGrid(SoleilGrid);
     1 : SaveGrid(MercureGrid);
     2 : SaveGrid(VenusGrid);
     3 : SaveGrid(LuneGrid);
     4 : SaveGrid(MarsGrid);
     5 : SaveGrid(JupiterGrid);
     6 : SaveGrid(SaturneGrid);
     7 : SaveGrid(UranusGrid);
     8 : SaveGrid(NeptuneGrid);
     9 : SaveGrid(PlutonGrid);
     end;
 2 : SaveGrid(CometGrid);
 3 : SaveGrid(AsteroidGrid);
 4 : SaveGrid(SolarGrid);
 5 : SaveGrid(LunarGrid);
 6 : SaveGrid(SatGrid);
 end;
end;

procedure Tf_calendar.Gridtoprinter(grid : tstringgrid);
var buf,d,z1,z2 : string;
    x : double;
begin
buf:=config.ObsName;
x:=abs(config.ObsLongitude);
if config.ObsLongitude>0 then d:=west else d:=east;
buf:=buf+blank+appmsg[32]+'='+copy(detostr(x),2,99)+d+blank+appmsg[31]+'='+detostr(config.ObsLatitude);
config.tz.JD:=date1.JD;
z1:=config.tz.ZoneName;
config.tz.JD:=date2.JD;
z2:=config.tz.ZoneName;
if z1<>z2 then z1:=z1+'/'+z2;
buf:=buf+blank+rsTimeZone+'='+z1;
if grid=cometgrid then
  PrtGrid(Grid,'CdC',buf,'',poLandscape)
else
  PrtGrid(Grid,'CdC',buf,'',poPortrait);
end;

procedure Tf_calendar.BtnPrintClick(Sender: TObject);
begin
case pagecontrol1.ActivePage.TabIndex of
 0 : GridtoPrinter(TwilightGrid);
 1 : case pagecontrol2.ActivePage.TabIndex of
     0 : GridtoPrinter(SoleilGrid);
     1 : GridtoPrinter(MercureGrid);
     2 : GridtoPrinter(VenusGrid);
     3 : GridtoPrinter(LuneGrid);
     4 : GridtoPrinter(MarsGrid);
     5 : GridtoPrinter(JupiterGrid);
     6 : GridtoPrinter(SaturneGrid);
     7 : GridtoPrinter(UranusGrid);
     8 : GridtoPrinter(NeptuneGrid);
     9 : GridtoPrinter(PlutonGrid);
     end;
 2 : GridtoPrinter(CometGrid);
 3 : GridtoPrinter(AsteroidGrid);
 4 : GridtoPrinter(SolarGrid);
 5 : GridtoPrinter(LunarGrid);
 6 : GridtoPrinter(SatGrid);
 end;
end;


procedure Tf_calendar.EcliPanelClick(Sender: TObject);
begin
ExecuteFile(EcliPanel.Hint);
end;

procedure Tf_calendar.BtnResetClick(Sender: TObject);
begin
if assigned(Fupdchart) then Fupdchart(config);
BtnReset.visible:=false;
end;

procedure Tf_calendar.Button1Click(Sender: TObject);
var list: TStringList;
begin
list:=TStringList.Create;
Cdb.GetCometList(CometFilter.Text,maxcombo,list,cometid);
Combobox1.Items.Assign(list);
Combobox1.ItemIndex:=0;
RefreshComet;
end;

procedure Tf_calendar.ComboBox1Change(Sender: TObject);
begin
RefreshComet;
end;

procedure Tf_calendar.RefreshComet;
var id,nam,elem_id : string;
    i,a,m,d,s,nj,irc,irc2: integer;
    cjd,epoch: double;
    ra,dec,dist,r,elong,phase,magn,st0,q : double;
    hh,g,ap,an,ic,ec,eq,tp,diam,lc,car,cde,rc : double;
    hr,ht,hs,azr,azs,hp1,hp2,ars,des,ds,dds,az,ha :Double;
    jda,jd0,jd1,jd2,jdt,h,st,hhh : double;
    hr1,ht1,hs1,hr2,ht2,hs2 : double;
    ra1,dec1,ra2,dec2,ra3,dec3: double;
begin
if ComboBox1.itemindex<0 then exit;
screen.cursor:=crHourGlass;
try
cjd:=(date1.JD+date2.JD)/2;
id:=cometid[ComboBox1.itemindex];
epoch:=cdb.GetCometEpoch(id,cjd);
if cdb.GetComElem(id,epoch,tp,q,ec,ap,an,ic,hh,g,eq,nam,elem_id) then begin
   Fplanet.InitComet(tp,q,ec,ap,an,ic,hh,g,eq,nam);
//   Cometgrid.Visible:=false;
   FreeCoord(Cometgrid);
   dat31:=date1.jd;
   dat32:=date2.jd;
   dat33:=time.time;
   dat34:=step.text;
   s:=strtoint(step.text);
   djd(date1.JD,a,m,d,hhh);
   config.tz.JD:=date1.JD;
   h:=frac(Time.time)*24-config.tz.SecondsOffset/3600;
   jd1:=jd(a,m,d,h);
   djd(date2.JD,a,m,d,hhh);
   jd2:=jd(a,m,d,h);
   nj:=round((jd2-jd1)/s);
   if nj>maxstep then if MessageDlg(appmsg[19]+blank+inttostr(nj)+blank+appmsg[20],
       mtConfirmation,[mbOk, mbCancel], 0) <> mrOK then exit;
   jda:=jd1;
   i:=2;
   Cometgrid.cells[0,0]:=trim(nam);
   Cometgrid.cells[1,0]:=trim(config.EquinoxName)+blank+appmsg[46];
   Cometgrid.cells[0,1]:=trim(armtostr(h))+' UT';
   repeat
      djd(jda,a,m,d,h);
      jd0:=jd(a,m,d,0);
      st0:=SidTim(jd0,h,config.ObsLongitude);
      config.tz.JD:=jda;
      config.TimeZone:=config.tz.SecondsOffset/3600;
      Fplanet.Comet(jda,true,ra,dec,dist,r,elong,phase,magn,diam,lc,car,cde,rc);
      precession(jd2000,config.jdchart,ra,dec);
      if config.PlanetParalaxe then Paralaxe(st0,dist,ra,dec,ra,dec,q,config);
      if config.ApparentPos then apparent_equatorial(ra,dec,config);
      ra:=rmod(ra+pi2,pi2);
      with Cometgrid do begin
         RowCount:=i+1;
         cells[0,i]:=isodate(a,m,d);
         cells[1,i]:=artostr(rad2deg*ra/15);
         cells[2,i]:=detostr(rad2deg*dec);
         cells[3,i]:=floattostrf(magn,ffFixed,5,1);
         cells[4,i]:=demtostr(rad2deg*elong);
         cells[5,i]:=demtostr(rad2deg*phase);
         objects[0,i]:=SetObjCoord(jda,ra,dec);
         RiseSet(1,jd0,ra,dec,hr1,ht1,hs1,azr,azs,irc,config);
         Fplanet.Comet(jd0+rmod((hr1-config.TimeZone)+24,24)/24,false,ra1,dec1,dist,r,elong,phase,magn,diam,lc,car,cde,rc);
         precession(jd2000,config.jdchart,ra1,dec1);
         RiseSet(1,jd0,ra1,dec1,hr,ht2,hs2,azr,azs,irc2,config);
         Fplanet.Comet(jd0+rmod((ht1-config.TimeZone)+24,24)/24,false,ra2,dec2,dist,r,elong,phase,magn,diam,lc,car,cde,rc);
         precession(jd2000,config.jdchart,ra2,dec2);
         RiseSet(1,jd0,ra2,dec2,hr2,ht,hs2,azr,azs,irc2,config);
         Fplanet.Comet(jd0+rmod((hs1-config.TimeZone)+24,24)/24,false,ra3,dec3,dist,r,elong,phase,magn,diam,lc,car,cde,rc);
         precession(jd2000,config.jdchart,ra3,dec3);
         RiseSet(1,jd0,ra3,dec3,hr2,ht2,hs,azr,azs,irc2,config);
         case irc of
          0 : begin
           cells[6,i]:=armtostr(hr);
           cells[7,i]:=armtostr(ht);
           cells[8,i]:=armtostr(hs);
           objects[6,i]:=SetObjCoord(jda+(hr-config.TimeZone-h)/24,ra1,dec1);
           objects[7,i]:=SetObjCoord(jda+(ht-config.TimeZone-h)/24,ra2,dec2);
           objects[8,i]:=SetObjCoord(jda+(hs-config.TimeZone-h)/24,ra3,dec3);
           end;
          1 : begin
           cells[6,i]:='-';
           cells[7,i]:=armtostr(ht);
           objects[7,i]:=SetObjCoord(jda+(ht-config.TimeZone-h)/24,ra2,dec2);
           cells[8,i]:='-';
           objects[6,i]:=nil;
           objects[8,i]:=nil;
           end;
          2 : begin
           cells[6,i]:='-';
           cells[7,i]:='-';
           cells[8,i]:='-';
           objects[6,i]:=nil;
           objects[7,i]:=nil;
           objects[8,i]:=nil;
           end;
         end;
         Fplanet.Sun(jda,ars,des,ds,dds);
         precession(jd2000,config.jdchart,ars,des);
         // crepuscule nautique
         Time_Alt(jd0,ars,des,-12,hp1,hp2,config);
         if hp1>-99 then begin
            jdt:=jd(a,m,d,hp1);
            Fplanet.Comet(jdt,false,ra,dec,dist,r,elong,phase,magn,diam,lc,car,cde,rc);
            precession(jd2000,config.jdchart,ra,dec);
            st := Sidtim(jd0,hp1,config.ObsLongitude);
            Eq2Hz((st-ra),dec,az,ha,config);
            az:=rmod(az+pi,pi2);
            if ha>0 then cells[10,i]:=dedtostr(rad2deg*ha)+'  '+StringReplace(dedtostr(rad2deg*az),'+','Az',[])
                    else cells[10,i]:=dedtostr(rad2deg*ha);
            objects[10,i]:=SetObjCoord(jdt,ra,dec);
         end else begin
            cells[10,i]:='-';
            objects[10,i]:=nil;
         end;
         if hp2>-99 then begin
            jdt:=jd(a,m,d,hp2);
            Fplanet.Comet(jdt,false,ra,dec,dist,r,elong,phase,magn,diam,lc,car,cde,rc);
            precession(jd2000,config.jdchart,ra,dec);
            st := Sidtim(jd0,hp2,config.ObsLongitude);
            Eq2Hz((st-ra),dec,az,ha,config);
            az:=rmod(az+pi,pi2);
            if ha>0 then cells[11,i]:=dedtostr(rad2deg*ha)+'  '+StringReplace(dedtostr(rad2deg*az),'+','Az',[])
                    else cells[11,i]:=dedtostr(rad2deg*ha);
            objects[11,i]:=SetObjCoord(jdt,ra,dec);
         end else begin
            cells[11,i]:='-';
            objects[11,i]:=nil;
         end;
         // crepuscule astro
         Time_Alt(jd0,ars,des,-18,hp1,hp2,config);
         if hp1>-99 then begin
            jdt:=jd(a,m,d,hp1);
            Fplanet.Comet(jdt,false,ra,dec,dist,r,elong,phase,magn,diam,lc,car,cde,rc);
            precession(jd2000,config.jdchart,ra,dec);
            st := Sidtim(jd0,hp1,config.ObsLongitude);
            Eq2Hz((st-ra),dec,az,ha,config);
            az:=rmod(az+pi,pi2);
            if ha>0 then cells[9,i]:=dedtostr(rad2deg*ha)+'  '+StringReplace(dedtostr(rad2deg*az),'+','Az',[])
                    else cells[9,i]:=dedtostr(rad2deg*ha);
            objects[9,i]:=SetObjCoord(jdt,ra,dec);
         end else begin
            cells[9,i]:='-';
            objects[9,i]:=nil;
         end;
         if hp2>-99 then begin
            jdt:=jd(a,m,d,hp2);
            Fplanet.Comet(jdt,false,ra,dec,dist,r,elong,phase,magn,diam,lc,car,cde,rc);
            precession(jd2000,config.jdchart,ra,dec);
            st := Sidtim(jd0,hp2,config.ObsLongitude);
            Eq2Hz((st-ra),dec,az,ha,config);
            az:=rmod(az+pi,pi2);
            if ha>0 then cells[12,i]:=dedtostr(rad2deg*ha)+'  '+StringReplace(dedtostr(rad2deg*az),'+','Az',[])
                    else cells[12,i]:=dedtostr(rad2deg*ha);
            objects[12,i]:=SetObjCoord(jdt,ra,dec);
         end else begin
            cells[12,i]:='-';
            objects[12,i]:=nil;
         end; 
      end;
      jda:=jda+s;
      i:=i+1;
   until jda>jd2;
end;
finally
//Cometgrid.Visible:=true;
screen.cursor:=crDefault;
end;
end;

procedure Tf_calendar.Button2Click(Sender: TObject);
var list:TstringList;
begin
list:=TstringList.create;
Cdb.GetAsteroidList(AstFilter.Text,maxcombo,list,astid);
Combobox2.Items.Assign(list);
list.Free;
Combobox2.ItemIndex:=0;
RefreshAsteroid;
end;

procedure Tf_calendar.ComboBox2Change(Sender: TObject);
begin
RefreshAsteroid;
end;

procedure Tf_calendar.RefreshAsteroid;
var id,nam,elem_id,ref : string;
    i,a,m,d,s,nj,irc,irc2: integer;
    cjd,epoch: double;
    ra,dec,dist,r,elong,phase,magn,st0,q : double;
    hh,g,ma,ap,an,ic,ec,sa,eq : double;
    hr,ht,hs,azr,azs: Double;
    jda,jd0,jd1,jd2,h,hhh : double;
    hr1,ht1,hs1,hr2,ht2,hs2 : double;
    ra1,dec1,ra2,dec2,ra3,dec3: double;
begin
screen.cursor:=crHourGlass;
try
cjd:=(date1.JD+date2.JD)/2;
id:=astid[ComboBox2.itemindex];
epoch:=cdb.GetAsteroidEpoch(id,cjd);
if cdb.GetAstElem(id,epoch,hh,g,ma,ap,an,ic,ec,sa,eq,ref,nam,elem_id) then begin
   Fplanet.InitAsteroid(epoch,hh,g,ma,ap,an,ic,ec,sa,eq,nam);
//   Asteroidgrid.Visible:=false;
   FreeCoord(Asteroidgrid);
   dat71:=date1.jd;
   dat72:=date2.jd;
   dat73:=time.time;
   dat74:=step.text;
   s:=strtoint(step.text);
   djd(date1.JD,a,m,d,hhh);
   config.tz.JD:=date1.JD;
   h:=frac(Time.time)*24-config.tz.SecondsOffset/3600;
   jd1:=jd(a,m,d,h);
   djd(date2.JD,a,m,d,hhh);
   jd2:=jd(a,m,d,h);
   nj:=round((jd2-jd1)/s);
   if nj>maxstep then if MessageDlg(appmsg[19]+blank+inttostr(nj)+blank+appmsg[20],
       mtConfirmation,[mbOk, mbCancel], 0) <> mrOK then exit;
   jda:=jd1;
   i:=2;
   Asteroidgrid.cells[0,0]:=trim(nam);
   Asteroidgrid.cells[1,0]:=trim(config.EquinoxName)+blank+appmsg[46];
   Asteroidgrid.cells[0,1]:=trim(armtostr(h))+' UT';
   repeat
      djd(jda,a,m,d,h);
      jd0:=jd(a,m,d,0);
      st0:=SidTim(jd0,h,config.ObsLongitude);
      config.tz.JD:=jda;
      config.TimeZone:=config.tz.SecondsOffset/3600;
      Fplanet.Asteroid(jda,true,ra,dec,dist,r,elong,phase,magn);
      precession(jd2000,config.jdchart,ra,dec);
      if config.PlanetParalaxe then Paralaxe(st0,dist,ra,dec,ra,dec,q,config);
      if config.ApparentPos then apparent_equatorial(ra,dec,config);
      ra:=rmod(ra+pi2,pi2);
      with Asteroidgrid do begin
         RowCount:=i+1;
         cells[0,i]:=isodate(a,m,d);
         cells[1,i]:=artostr(rad2deg*ra/15);
         cells[2,i]:=detostr(rad2deg*dec);
         cells[3,i]:=floattostrf(magn,ffFixed,5,1);
         cells[4,i]:=demtostr(rad2deg*elong);
         cells[5,i]:=demtostr(rad2deg*phase);
         objects[0,i]:=SetObjCoord(jda,ra,dec);
         RiseSet(1,jd0,ra,dec,hr1,ht1,hs1,azr,azs,irc,config);
         Fplanet.Asteroid(jd0+rmod((hr1-config.TimeZone)+24,24)/24,false,ra1,dec1,dist,r,elong,phase,magn);
         precession(jd2000,config.jdchart,ra1,dec1);
         RiseSet(1,jd0,ra1,dec1,hr,ht2,hs2,azr,azs,irc2,config);
         Fplanet.Asteroid(jd0+rmod((ht1-config.TimeZone)+24,24)/24,false,ra2,dec2,dist,r,elong,phase,magn);
         precession(jd2000,config.jdchart,ra2,dec2);
         RiseSet(1,jd0,ra2,dec2,hr2,ht,hs2,azr,azs,irc2,config);
         Fplanet.Asteroid(jd0+rmod((hs1-config.TimeZone)+24,24)/24,false,ra3,dec3,dist,r,elong,phase,magn);
         precession(jd2000,config.jdchart,ra3,dec3);
         RiseSet(1,jd0,ra3,dec3,hr2,ht2,hs,azr,azs,irc2,config);
         case irc of
          0 : begin
           cells[6,i]:=armtostr(hr);
           cells[7,i]:=armtostr(ht);
           cells[8,i]:=armtostr(hs);
           objects[6,i]:=SetObjCoord(jda+(hr-config.TimeZone-h)/24,ra1,dec1);
           objects[7,i]:=SetObjCoord(jda+(ht-config.TimeZone-h)/24,ra2,dec2);
           objects[8,i]:=SetObjCoord(jda+(hs-config.TimeZone-h)/24,ra3,dec3);
           end;
          1 : begin
           cells[6,i]:='-';
           cells[7,i]:=armtostr(ht);
           objects[7,i]:=SetObjCoord(jda+(ht-config.TimeZone-h)/24,ra2,dec2);
           cells[8,i]:='-';
           objects[6,i]:=nil;
           objects[8,i]:=nil;
           end;
          2 : begin
           cells[6,i]:='-';
           cells[7,i]:='-';
           cells[8,i]:='-';
           objects[6,i]:=nil;
           objects[7,i]:=nil;
           objects[8,i]:=nil;
           end;
         end;
      end;
      jda:=jda+s;
      i:=i+1;
   until jda>jd2;
end;
finally
//Asteroidgrid.Visible:=true;
screen.cursor:=crDefault;
end;
end;

procedure Tf_calendar.BtnHelpClick(Sender: TObject);
begin
ExecuteFile(slash(helpdir)+slash('wiki_doc')+stringreplace(rsDocumentatio,'/',PathDelim,[rfReplaceAll]));
end;

initialization
  {$i pu_calendar.lrs}

end.