unit pu_calendar;
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

uses Math,
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, FileCtrl, enhedits, Grids, ComCtrls, Mask, Inifiles,
  cu_jdcalendar, cu_planet, u_constant, pu_image, Buttons, ExtCtrls,
  passql, pasmysql, ActnList, StdActns;

type
    TScFunc = procedure(var csc:conf_skychart) of object;
    TObjCoord = class(Tobject)
                jd,ra,dec : double;
                end;

const nummsg = 46;
      maxcombo = 50;

type
  Tf_calendar = class(TForm)
    Panel1: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    Label5: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    EcliPanel: TPanel;
    SatPanel: TPanel;
    Label9: TLabel;
    BitBtn1: TBitBtn;
    Time: TDateTimePicker;
    BitBtn2: TBitBtn;
    BitBtn3: TBitBtn;
    BitBtn4: TBitBtn;
    BitBtn5: TBitBtn;
    ResetBtn: TBitBtn;
    Date1: TJDDatePicker;
    Date2: TJDDatePicker;
    PageControl1: TPageControl;
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
    ComboBox1: TComboBox;
    CometGrid: TStringGrid;
    Solar: TTabSheet;
    SolarGrid: TStringGrid;
    Lunar: TTabSheet;
    LunarGrid: TStringGrid;
    Satellites: TTabSheet;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    SatGrid: TStringGrid;
    maglimit: TFloatEdit;
    tle: TEdit;
    SatChartBox: TCheckBox;
    magchart: TFloatEdit;
    IridiumBox: TCheckBox;
    TLEListBox: TFileListBox;
    fullday: TCheckBox;
    step: TLongEdit;
    Asteroids: TTabSheet;
    AsteroidGrid: TStringGrid;
    CometFilter: TEdit;
    Button1: TButton;
    AstFilter: TEdit;
    Button2: TButton;
    ComboBox2: TComboBox;
    ActionList1: TActionList;
    HelpContents1: THelpContents;
    memo1: TRichEdit;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure GridMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormDestroy(Sender: TObject);
    procedure PageControl1Change(Sender: TObject);
    procedure BitBtn5Click(Sender: TObject);
    procedure EcliPanelClick(Sender: TObject);
    procedure ResetBtnClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure ComboBox2Change(Sender: TObject);
    procedure HelpContents1Execute(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure BitBtn4Click(Sender: TObject);
  private
    { Private declarations }
    initial: boolean;
    ShowImage: Tf_image;
    Fplanet : Tplanet;
    FGetChartConfig: TScFunc;
    Fupdchart: TScFunc;
    c: conf_skychart;
    db : TMyDB;
    Feclipsepath: string;
    dat11,dat12,dat13,dat21,dat22,dat23,dat31,dat32,dat33,dat41,dat51,dat61,dat71,dat72,dat73 : double ;
    dat14,dat24,dat34,dat74,tz,west,east,title : string;
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
    procedure PlanetRiseCell(var gr : Tstringgrid; i,irc : integer; hr,ht,hs,azr,azs,jda,h,ar,de : double);
    procedure Gridetoclipboard(grid : tstringgrid);
    procedure Gridetoprinter(grid : tstringgrid);
    procedure RefreshAll;
    procedure RefreshTwilight;
    procedure RefreshPlanet;
    procedure RefreshComet;
    procedure RefreshAsteroid;
    procedure RefreshLunarEclipse;
    procedure RefreshSolarEclipse;
  public
    { Public declarations }
    function ConnectDB(host,dbn,user,pass:string; port:integer):boolean;
    procedure SetLang(languagefile:string);
    property planet: Tplanet read Fplanet write Fplanet;
    property config: conf_skychart read c write c;
    property EclipsePath: string read Feclipsepath write Feclipsepath;
    property OnGetChartConfig: TScFunc read FGetChartConfig write FGetChartConfig;
    property OnUpdateChart: TScFunc read Fupdchart write Fupdchart;
  end;

var
  f_calendar: Tf_calendar;

implementation

{$R *.dfm}

// include all cross-platform common code.
// you can temporarily copy the file content here
// to use the IDE facilities

{$include i_calendar.pas}

// end of common code

end.
