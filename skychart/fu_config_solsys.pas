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

uses u_help, u_translation, u_constant, u_util, u_projection, cu_database, cu_radec,
  LCLIntf, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, Math, IniFiles,
  Spin, enhedits, StdCtrls, Buttons, ExtCtrls, ComCtrls, LResources,
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
    BitBtn37: TBitBtn;
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
    procedure ButtonEphAddClick(Sender: TObject);
    procedure ButtonEphDefaultClick(Sender: TObject);
    procedure ButtonEphDelClick(Sender: TObject);
    procedure ButtonEphDownClick(Sender: TObject);
    procedure ButtonEphUpClick(Sender: TObject);
    procedure CheckBoxPlutoChange(Sender: TObject);
    procedure ComboBox1Select(Sender: TObject);
    procedure ComboBox2Select(Sender: TObject);
    procedure DownloadAsteroidClick(Sender: TObject);
    procedure DownloadCometClick(Sender: TObject);
    procedure GRSdriftChange(Sender: TObject);
    procedure GRSJDDateChange(Sender: TObject);
    procedure PageControl1Changing(Sender: TObject; var AllowChange: Boolean);
    procedure PlanetDirChange(Sender: TObject);
    procedure PlaParalaxeClick(Sender: TObject);
    procedure PlanetBoxClick(Sender: TObject);
    procedure PlanetModeClick(Sender: TObject);
    procedure GRSChange(Sender: TObject);
    procedure PlanetBox3Click(Sender: TObject);
    procedure BitBtn37Click(Sender: TObject);
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
    FConfirmDownload: Boolean;
    procedure ShowPlanet;
    procedure ShowComet;
    procedure UpdComList;
    procedure ShowAsteroid;
    procedure UpdAstList;
    procedure AsteroidFeedback(txt:string);
    procedure CometFeedback(txt:string);
  public
    { Public declarations }
    cdb: Tcdcdb;
    autoprocess, autoOK: boolean;
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
    destructor Destroy; override;
    procedure Init; // old FormShow
    procedure Lock; // old FormClose
    procedure SetLang;
    procedure LoadSampleData;
    procedure ActivateJplEph;
    property ConfirmDownload: Boolean read FConfirmDownload write FConfirmDownload;
    property onShowDB: TNotifyEvent read FShowDB write FShowDB;
    property onPrepareAsteroid: TPrepareAsteroid read FPrepareAsteroid write FPrepareAsteroid;
    property onApplyConfig: TNotifyEvent read FApplyConfig write FApplyConfig;
  end;

implementation
{$R *.lfm}

procedure Tf_config_solsys.SetLang;
var Alabels: TDatesLabelsArray;
begin
Caption:=rsSolarSystem;
page1.Caption:=rsSolarSystem;
page2.Caption:=rsPlanet;
page3.Caption:=rsComet;
page4.Caption:=rsAsteroid;
Label12.caption:=rsSolarSystemS;
Label131.caption:=rsDataFiles;
PlaParalaxe.caption:=rsPosition;
PlaParalaxe.Items[0]:=rsGeocentric;
PlaParalaxe.Items[1]:=rsTopoCentric;
GroupBox2.Caption:=rsJPLEphemeris;
ButtonEphAdd.Caption:=rsAdd;
ButtonEphDefault.Caption:=rsDefault;
ButtonEphDel.Caption:=rsDelete;
ButtonEphDown.Caption:=rsDown;
ButtonEphUp.Caption:=rsUp;
CheckBoxPluto.Caption:=rsPlutoIsAPlan;
Label3.caption:=rsUncheckToAvo;
Label5.caption:=rsPlanetsSetti;
Label89.caption:=rsJupiterGRSLo;
Label9.Caption:=rsDrift;
Label10.Caption:=rsDate;
BitBtn37.Caption:=rsGetRecentMea;
BitBtn37.Hint:=rsGetRecentMea;
PlanetBox.caption:=rsShowPlanetOn;
PlanetMode.caption:=rsDrawPlanetAs;
PlanetMode.Items[0]:=rsStar;
PlanetMode.Items[1]:=rsLineModeDraw;
PlanetMode.Items[2]:=rsRealisticsIm;
PlanetMode.Items[3]:=rsSymbol;
{$ifdef unix}
PlanetMode.Items[2]:=PlanetMode.Items[2]+blank+rsRequireXplan;
{$endif}
PlanetBox3.caption:=rsShowEarthSha;
TransparentPlanet.caption:=rsTransparentL;
SunOnline.Caption:=rsUseOnlineSun;
smallsat.Caption:=rsShowTheSmall;
Label4.Caption:=rsSunImageSour;
Label6.Caption:=rsRefreshImage;
Label8.Caption:=rsHours;
comsetting.caption:=rsGeneralSetti;
GroupBox13.caption:=rsChartSetting;
Label154.caption:=rsButNeverFain;
Label216.caption:=rsShowComets;
Label231.caption:=rsMagnitudeFai;
showcom.caption:=rsShowCometsOn;
comdbset.caption:=rsDatabaseSett;
comload.caption:=rsLoadMPCFile;
Label232.caption:=rsMessages;
TabSheet2.caption:=rsOrUseALocalF;
TabSheet1.caption:=rsLoadMPCForma;
Label2.caption:=rsDownloadLate;
DownloadComet.caption:=rsDownload;
Loadcom.caption:=rsLoadFile;
comdelete.caption:=rsDataMaintena;
Label238.caption:=rsMessages;
GroupBox16.caption:=rsDeleteMPCDat;
DelCom.caption:=rsDelete;
GroupBox17.caption:=rsQuickDelete;
Label239.caption:=rsQuicklyDelet;
DelComAll.caption:=rsDelete;
Addsinglecom.caption:=rsAdd;
Label241.caption:=rsAddASingleEl;
Label242.caption:=rsDesignation;
Label243.caption:=rsHAbsoluteMag;
Label244.caption:=rsGSlopeParame;
Label245.caption:=rsEpochJD;
Label246.caption:=rsPerihelionDa;
Label247.caption:=rsArgumentOfPe;
Label248.caption:=rsLongitudeAsc;
Label249.caption:=rsInclination;
Label250.caption:=rsEccentricity;
Label251.caption:=rsPerihelionDi;
Label253.caption:=rsEquinox2;
Label254.caption:=rsName;
AddCom.caption:=rsAdd;
astsetting.caption:=rsGeneralSetti;
GroupBox9.caption:=rsChartSetting;
Label203.caption:=rsButNeverFain;
Label212.caption:=rsShowAsteroid;
Label213.caption:=rsMagnitudeFai;
AstNeo.Caption:=rsShowNearEart;
showast.caption:=rsShowAsteroid3;
astdbset.caption:=rsDatabaseSett;
astload.caption:=rsLoadMPCFile;
Label206.caption:=rsMessages;
TabSheet4.caption:=rsOrUseALocalF;
TabSheet3.caption:=rsLoadMPCForma;
Label1.caption:=rsDownloadLate;
DownloadAsteroid.caption:=rsDownload;
GroupBox1.caption:=rsOptions;
Label215.caption:=rsAsteroidsFro;
astnumbered.caption:=rsOnlyNumbered;
aststoperr.caption:=rsHaltAfter100;
astlimitbox.caption:=rsLoadOnlyTheF;
LoadMPC.caption:=rsLoadFile;
astprepare.caption:=rsPrepareMonth;
Label210.caption:=rsMessages;
GroupBox8.caption:=rsPrepareData;
Label7.caption:=rsStartMonth;
Label207.caption:=rsNumberOfMont;
AstCompute.caption:=rsCompute;
astdelete.caption:=rsDataMaintena;
Label211.caption:=rsMessages;
GroupBox10.caption:=rsDeleteMPCDat;
delast.caption:=rsDelete;
GroupBox11.caption:=rsQuickDelete;
Label209.caption:=rsQuicklyDelet2;
delallast.caption:=rsDelete;
GroupBox12.caption:=rsDeleteMonthl;
Label214.caption:=rsDeleteMonthl2;
deldateast.caption:=rsDelete;
AddsingleAst.caption:=rsAdd;
Label217.caption:=rsAddASingleEl;
Label218.caption:=rsDesignation;
Label219.caption:=rsHAbsoluteMag;
Label220.caption:=rsGSlopeParame;
Label221.caption:=rsEpochJD;
Label222.caption:=rsMeanAnomaly;
Label223.caption:=rsArgumentOfPe;
Label224.caption:=rsLongitudeAsc;
Label225.caption:=rsInclination;
Label226.caption:=rsEccentricity;
Label227.caption:=rsSemimajorAxi;
Label228.caption:=rsReference;
Label229.caption:=rsEquinox2;
Label230.caption:=rsName;
Addast.caption:=rsAdd;
comsymbol.Items[0]:=rsDisplayAsASy;
comsymbol.Items[1]:=rsProportional;
astsymbol.Items[0]:=rsDisplayAsASy;
astsymbol.Items[1]:=rsProportional2;
SetHelp(self,hlpCfgSol);
DownloadDialog1.msgDownloadFile:=rsDownloadFile;
DownloadDialog1.msgCopyfrom:=rsCopyFrom;
DownloadDialog1.msgtofile:=rsToFile;
DownloadDialog1.msgDownloadBtn:=rsDownload;
DownloadDialog1.msgCancelBtn:=rsCancel;
GRSJDDate.Caption:=rsJDCalendar;
Alabels.Mon:=rsMonday;
Alabels.Tue:=rsTuesday;
Alabels.Wed:=rsWednesday;
Alabels.Thu:=rsThursday;
Alabels.Fri:=rsFriday;
Alabels.Sat:=rsSaturday;
Alabels.Sun:=rsSunday;
Alabels.jd:=rsJulianDay;
Alabels.today:=rsToday;
GRSJDDate.labels:=Alabels;
end;

constructor Tf_config_solsys.Create(AOwner:TComponent);
var i:integer;
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
  autoOK:= false;
  FConfirmDownload:=true;
  SetLang;
  LockChange:=true;
  ComboBox1.Clear;
  for i:=1 to URL_SUN_NUMBER do ComboBox1.Items.Add(URL_SUN_NAME[i]);
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
LockChange:=true;
ComPageControl.ActivePageIndex:=1;
ComPageControl.ActivePageIndex:=0;
ComPageControl1.ActivePageIndex:=1;
ComPageControl1.ActivePageIndex:=0;
AstPageControl.ActivePageIndex:=1;
AstPageControl.ActivePageIndex:=0;
AstPageControl2.ActivePageIndex:=1;
AstPageControl2.ActivePageIndex:=0;
ShowPlanet;
ShowComet;
ShowAsteroid;
LockChange:=false;
if PageControl1.ActivePage=page2 then
   PlanetModeClick(nil);
end;

procedure Tf_config_solsys.ShowPlanet;
var i:integer;
begin
if csc.PlanetParalaxe then PlaParalaxe.itemindex:=1
                      else PlaParalaxe.itemindex:=0;
CheckBoxPluto.checked:=csc.ShowPluto;
smallsat.checked := csc.ShowSmallsat;
PlanetBox.checked:=csc.ShowPlanet;
PlanetMode.itemindex:=cplot.plaplot;
grs.value:=csc.GRSlongitude;
GRSdrift.Value:=csc.GRSdrift*365.25;
GRSJDDate.JD:=csc.GRSjd;
PlanetBox3.checked:=csc.ShowEarthShadow;
Planetdir.Text:=cmain.planetdir;
TransparentPlanet.Checked:=cplot.TransparentPlanet;
SunOnline.Checked:=csc.SunOnline;
for i:=0 to URL_SUN_NUMBER-1 do
  if ComboBox1.Items[i]=csc.sunurlname then ComboBox1.ItemIndex:=i;
for i:=0 to ComboBox2.Items.Count-1 do
  if strtoint(ComboBox2.Items[i])=csc.sunrefreshtime then ComboBox2.ItemIndex:=i;
if PlanetMode.itemindex=2 then begin
   SunPanel.Visible:=true;
end else begin
   SunPanel.Visible:=false;
end;
ListBoxEph.clear;
for i:=1 to nJPL_DE do ListBoxEph.Items.Add(IntToStr(JPL_DE[i]));
ListBoxEph.TopIndex:=0;
end;

procedure Tf_config_solsys.ShowComet;
begin
showcom.checked:=csc.ShowComet;
comsymbol.itemindex:=csc.ComSymbol;
comlimitmag.value:=csc.CommagMax;
commagdiff.value:=csc.CommagDiff;
UpdComList;
comfile.InitialDir:=slash(MPCDir);
end;

procedure Tf_config_solsys.ShowAsteroid;
begin
showast.checked:=csc.ShowAsteroid;
AstNeo.Checked:=csc.AstNEO;
astsymbol.itemindex:=csc.AstSymbol;
astlimitmag.value:=csc.AstmagMax;
astmagdiff.value:=csc.AstmagDiff;
aststrtdate_y.text:=inttostr(csc.curyear);
aststrtdate_m.text:=inttostr(csc.curmonth);
astdeldate_y.text:=inttostr(csc.curyear-1);
astdeldate_m.text:=inttostr(csc.curmonth);
UpdAstList;
mpcfile.InitialDir:=slash(MPCDir);
end;

procedure Tf_config_solsys.PlanetDirChange(Sender: TObject);
begin
if LockChange then exit;
cmain.planetdir:=planetdir.text;
end;

procedure Tf_config_solsys.DownloadAsteroidClick(Sender: TObject);
var fn,tmpfn,tfn,ext,buf: string;
    i,l,n: integer;
    ok,gzfile: boolean;
    fi,fo: Textfile;
    gzf:pointer;
    ffile:file;
    gzbuf : array[0..4095]of char;
begin
 MemoMpc.Clear;
 n:=cmain.AsteroidUrlList.Count;
 if n=0 then begin showmessage(rsPleaseConfig2); exit; end;
 fn:=slash(MPCDir)+'MPCORB-'+FormatDateTime('yyyy-mm-dd',now)+'.DAT';
  if cmain.HttpProxy then begin
    DownloadDialog1.SocksProxy:='';
    DownloadDialog1.SocksType:='';
    DownloadDialog1.HttpProxy:=cmain.ProxyHost;
    DownloadDialog1.HttpProxyPort:=cmain.ProxyPort;
    DownloadDialog1.HttpProxyUser:=cmain.ProxyUser;
    DownloadDialog1.HttpProxyPass:=cmain.ProxyPass;
 end else if cmain.SocksProxy then begin
    DownloadDialog1.HttpProxy:='';
    DownloadDialog1.SocksType:=cmain.SocksType;
    DownloadDialog1.SocksProxy:=cmain.ProxyHost;
    DownloadDialog1.HttpProxyPort:=cmain.ProxyPort;
    DownloadDialog1.HttpProxyUser:=cmain.ProxyUser;
    DownloadDialog1.HttpProxyPass:=cmain.ProxyPass;
 end else begin
    DownloadDialog1.SocksProxy:='';
    DownloadDialog1.SocksType:='';
    DownloadDialog1.HttpProxy:='';
    DownloadDialog1.HttpProxyPort:='';
    DownloadDialog1.HttpProxyUser:='';
    DownloadDialog1.HttpProxyPass:='';
 end;
 DownloadDialog1.FtpUserName:='anonymous';
 DownloadDialog1.FtpPassword:=cmain.AnonPass;
 DownloadDialog1.FtpFwPassive:=cmain.FtpPassive;
 DownloadDialog1.onFeedback:=AsteroidFeedback;
 ok:=false; gzfile:=false;
 for i:=1 to n do begin
    if copy(cmain.AsteroidUrlList[i-1],1,1)='*' then continue;
    DownloadDialog1.URL:=cmain.AsteroidUrlList[i-1];
    ext:=ExtractFileExt(DownloadDialog1.URL);
    gzfile:=(ext='.gz');
    MemoMpc.Lines.Add(Format(rsDownload2, [DownloadDialog1.URL]));
    tmpfn:=slash(TempDir)+'mpc.tmp';
    if i=1 then begin
      tfn:=fn;
       if gzfile then
         DownloadDialog1.SaveToFile:=fn+'.gz'
       else
         DownloadDialog1.SaveToFile:=fn;
       DownloadDialog1.ConfirmDownload:=FConfirmDownload;
    end else begin
       tfn:=fn;
       if gzfile then
         DownloadDialog1.SaveToFile:=tmpfn+'.gz'
       else
         DownloadDialog1.SaveToFile:=tmpfn;
       DownloadDialog1.ConfirmDownload:=false;
    end;
    if DownloadDialog1.Execute then begin
       ok:=true;
       if gzfile then begin
         try
         gzf:=gzopen(pchar(DownloadDialog1.SaveToFile),pchar('rb'));
         Filemode:=2;
         assignfile(ffile,tfn);
         rewrite(ffile,1);
         repeat
           l:=gzread(gzf,@gzbuf,length(gzbuf));
           blockwrite(ffile,gzbuf,l,n);
         until gzeof(gzf);
         finally
         gzclose(gzf);
         CloseFile(ffile);
         end;
       end;
       if i>1 then begin
          Filemode:=2;
          assignfile(fi,tmpfn);
          assignfile(fo,fn);
          reset(fi);
          append(fo);
          repeat
            readln(fi,buf);
            writeln(fo,buf);
          until eof(fi);
          Closefile(fi);
          Closefile(fo);
          DeleteFile(tmpfn);
       end;
    end else begin
       Showmessage(Format(rsCancel2, [DownloadDialog1.ResponseText]));
       ok:=false;
       break;
    end;
 end;
 if ok then begin
    mpcfile.Text:=systoutf8(fn);
    application.ProcessMessages;
    LoadMPCClick(Sender);
 end;
 autoOK:=ok;
end;

procedure Tf_config_solsys.CheckBoxPlutoChange(Sender: TObject);
begin
if LockChange then exit;
  csc.ShowPluto:=CheckBoxPluto.checked;
end;

procedure Tf_config_solsys.ComboBox1Select(Sender: TObject);
var i: integer;
begin
  i:=ComboBox1.ItemIndex+1;
  csc.sunurlname:=URL_SUN_NAME[i];
  csc.sunurl:=URL_SUN[i];
  csc.sunurlsize:=URL_SUN_SIZE[i];
  csc.sunurlmargin:=URL_SUN_MARGIN[i];
end;

procedure Tf_config_solsys.ComboBox2Select(Sender: TObject);
begin
  csc.sunrefreshtime:=StrToInt(ComboBox2.Text);
end;

procedure Tf_config_solsys.AstNeoClick(Sender: TObject);
begin
  csc.AstNEO := AstNeo.Checked;
end;

procedure Tf_config_solsys.ButtonEphAddClick(Sender: TObject);
begin
if IsInteger(EditEph.Text) then  begin
   ListBoxEph.Items.Insert(0,EditEph.Text);
   ListBoxEph.TopIndex:=0;
end;
end;

procedure Tf_config_solsys.ButtonEphDefaultClick(Sender: TObject);
var i:integer;
begin
ListBoxEph.clear;
for i:=1 to DefaultnJPL_DE do ListBoxEph.Items.Add(IntToStr(DefaultJPL_DE[i]));
end;

procedure Tf_config_solsys.ButtonEphDelClick(Sender: TObject);
begin
ListBoxEph.Items.Delete(ListBoxEph.ItemIndex);
end;

procedure Tf_config_solsys.ButtonEphDownClick(Sender: TObject);
var p:integer;
begin
p:=ListBoxEph.ItemIndex;
if p<(ListBoxEph.Count-1) then begin
  ListBoxEph.Items.Move(p,p+1);
  ListBoxEph.ItemIndex:=p+1;
end;
end;

procedure Tf_config_solsys.ButtonEphUpClick(Sender: TObject);
var p:integer;
begin
p:=ListBoxEph.ItemIndex;
if p>0 then begin
  ListBoxEph.Items.Move(p,p-1);
  ListBoxEph.ItemIndex:=p-1;
end;
end;

procedure Tf_config_solsys.ActivateJplEph;
var i: integer;
begin
nJPL_DE:=ListBoxEph.Count;
SetLength(JPL_DE,nJPL_DE+1);
for i:=1 to nJPL_DE do JPL_DE[i]:=StrToIntDef(ListBoxEph.Items[i-1],0);
de_type:=0;
de_jdcheck:=MaxInt;
de_jdstart:=MaxInt;
de_jdend:=-MaxInt;
end;

procedure Tf_config_solsys.Lock;
begin
LockChange:=true;
end;

procedure Tf_config_solsys.AsteroidFeedback(txt:string);
begin
if copy(txt,1,9)='Read Byte' then exit;
memompc.Lines.Add(txt);
memompc.SelStart:=length(memompc.Text)-1;
end;

procedure Tf_config_solsys.DownloadCometClick(Sender: TObject);
var fn,tmpfn,buf: string;
    i,n: integer;
    ok: boolean;
    fi,fo: Textfile;
begin
 MemoCom.Clear;
 n:=cmain.CometUrlList.Count;
 if n=0 then begin showmessage(rsPleaseConfig2); exit; end;
 fn:=slash(MPCDir)+'COMET-'+FormatDateTime('yyyy-mm-dd',now)+'.DAT';
 tmpfn:=slash(TempDir)+'mpc.tmp';
 if cmain.HttpProxy then begin
    DownloadDialog1.SocksProxy:='';
    DownloadDialog1.SocksType:='';
    DownloadDialog1.HttpProxy:=cmain.ProxyHost;
    DownloadDialog1.HttpProxyPort:=cmain.ProxyPort;
    DownloadDialog1.HttpProxyUser:=cmain.ProxyUser;
    DownloadDialog1.HttpProxyPass:=cmain.ProxyPass;
 end else if cmain.SocksProxy then begin
    DownloadDialog1.HttpProxy:='';
    DownloadDialog1.SocksType:=cmain.SocksType;
    DownloadDialog1.SocksProxy:=cmain.ProxyHost;
    DownloadDialog1.HttpProxyPort:=cmain.ProxyPort;
    DownloadDialog1.HttpProxyUser:=cmain.ProxyUser;
    DownloadDialog1.HttpProxyPass:=cmain.ProxyPass;
 end else begin
    DownloadDialog1.SocksProxy:='';
    DownloadDialog1.SocksType:='';
    DownloadDialog1.HttpProxy:='';
    DownloadDialog1.HttpProxyPort:='';
    DownloadDialog1.HttpProxyUser:='';
    DownloadDialog1.HttpProxyPass:='';
 end;
 DownloadDialog1.FtpUserName:='anonymous';
 DownloadDialog1.FtpPassword:=cmain.AnonPass;
 DownloadDialog1.FtpFwPassive:=cmain.FtpPassive;
 DownloadDialog1.onFeedback:=CometFeedback;
 ok:=false;
 for i:=1 to n do begin
    if copy(cmain.CometUrlList[i-1],1,1)='*' then continue;
    DownloadDialog1.URL:=cmain.CometUrlList[i-1];
    MemoCom.Lines.Add(Format(rsDownload2, [DownloadDialog1.URL]));
    if i=1 then begin
       DownloadDialog1.SaveToFile:=fn;
       DownloadDialog1.ConfirmDownload:=FConfirmDownload;
    end else begin
       DownloadDialog1.SaveToFile:=tmpfn;
       DownloadDialog1.ConfirmDownload:=false;
    end;
    if DownloadDialog1.Execute then begin
       ok:=true;
       if i>1 then begin
          Filemode:=2;
          assignfile(fi,tmpfn);
          assignfile(fo,fn);
          reset(fi);
          append(fo);
          repeat
            readln(fi,buf);
            writeln(fo,buf);
          until eof(fi);
          Closefile(fi);
          Closefile(fo);
          DeleteFile(tmpfn);
       end;
    end else begin
       Showmessage(Format(rsCancel2, [DownloadDialog1.ResponseText]));
       ok:=false;
       break;
    end;
 end;
 if ok then begin
    comfile.Text:=systoutf8(fn);
    application.ProcessMessages;
    LoadcomClick(Sender);
 end;
 autoOK:=ok;
end;

procedure Tf_config_solsys.CometFeedback(txt:string);
begin
if copy(txt,1,9)='Read Byte' then exit;
memocom.Lines.Add(txt);
memocom.SelStart:=length(memocom.Text)-1;
end;

procedure Tf_config_solsys.PlaParalaxeClick(Sender: TObject);
begin
csc.PlanetParalaxe:=(PlaParalaxe.itemindex=1);
end;

procedure Tf_config_solsys.TransparentPlanetClick(Sender: TObject);
begin
cplot.TransparentPlanet:=TransparentPlanet.checked;
end;

procedure Tf_config_solsys.PlanetBoxClick(Sender: TObject);
begin
csc.ShowPlanet:=PlanetBox.checked;
end;

procedure Tf_config_solsys.PlanetModeClick(Sender: TObject);
begin
if LockChange and (PageControl1.ActivePage<>Page2) then exit;
if PlanetMode.itemindex=2 then begin
   SunPanel.Visible:=true;
end else begin
   SunPanel.Visible:=false;
end;
cplot.plaplot:=PlanetMode.itemindex;
end;

procedure Tf_config_solsys.GRSChange(Sender: TObject);
begin
if LockChange then exit;
csc.GRSlongitude:=grs.value;
end;

procedure Tf_config_solsys.GRSdriftChange(Sender: TObject);
begin
if LockChange then exit;
csc.GRSdrift := GRSdrift.Value/365.25;
end;

procedure Tf_config_solsys.GRSJDDateChange(Sender: TObject);
begin
if LockChange then exit;
csc.GRSjd := GRSJDDate.JD;
end;

procedure Tf_config_solsys.PageControl1Changing(Sender: TObject;
  var AllowChange: Boolean);
begin
  if parent is TForm then TForm(Parent).ActiveControl:=PageControl1;
end;


procedure Tf_config_solsys.PlanetBox3Click(Sender: TObject);
begin
csc.ShowEarthShadow:=PlanetBox3.checked;
end;

procedure Tf_config_solsys.BitBtn37Click(Sender: TObject);
var dl:TDownloadDialog;
    inif: TMeminifile;
    fn,section: string;
    y,m,d: Integer;
    h: double;
begin
 dl:=TDownloadDialog.Create(self);
 dl.SocksProxy:='';
 dl.SocksType:='';
 dl.HttpProxy:='';
 dl.HttpProxyPort:='';
 dl.HttpProxyUser:='';
 dl.HttpProxyPass:='';
 dl.ConfirmDownload:=false;
 dl.QuickCancel:=true;
 dl.URL:=URL_GRS;
 fn:=slash(TempDir)+'grs.txt';
 dl.SaveToFile:=fn;
 if dl.Execute and FileExists(fn) then begin
   inif:=TMeminifile.create(fn);
   try
   section:='grs';
   djd(GRSJDDate.JD,y,m,d,h);
   GRS.Value:=inif.ReadFloat(section,'RefGRSLon',GRS.Value);
   GRSdrift.Value:=inif.ReadFloat(section,'RefGRSdrift',GRSdrift.Value);
   y:=inif.ReadInteger(section,'RefGRSY',y);
   m:=inif.ReadInteger(section,'RefGRSM',m);
   d:=inif.ReadInteger(section,'RefGRSD',d);
   GRSJDDate.JD:=jd(y,m,d,0);
   csc.GRSlongitude:=grs.value;
   csc.GRSdrift := GRSdrift.Value/365.25;
   csc.GRSjd := GRSJDDate.JD;
   ShowMessage(rsUpdatedSucce);
   finally
    inif.Free;
   end;
 end;
 dl.free;
end;


procedure Tf_config_solsys.UpdComList;
begin
cdb.GetCometFileList(cmain,comelemlist.items);
comelemlist.itemindex:=0;
if comelemlist.items.count>0 then comelemlist.text:=comelemlist.items[0];
end;

procedure Tf_config_solsys.showcomClick(Sender: TObject);
begin
csc.ShowComet:=showcom.checked;
end;

procedure Tf_config_solsys.comsymbolClick(Sender: TObject);
begin
csc.ComSymbol:=comsymbol.itemindex;
end;

procedure Tf_config_solsys.comlimitmagChange(Sender: TObject);
begin
if LockChange then exit;
csc.CommagMax:=comlimitmag.value;
end;

procedure Tf_config_solsys.commagdiffChange(Sender: TObject);
begin
if LockChange then exit;
csc.CommagDiff:=commagdiff.value;
end;

procedure Tf_config_solsys.LoadcomClick(Sender: TObject);
begin
if Sender=LoadCom then MemoCom.Clear;
screen.cursor:=crHourGlass;
cdb.LoadCometFile(SafeUTF8ToSys(comfile.text),MemoCom);
memocom.SelStart:=length(memocom.Text)-1;
UpdComList;
screen.cursor:=crDefault;
end;

procedure Tf_config_solsys.DelComClick(Sender: TObject);
begin
screen.cursor:=crHourGlass;
cdb.DelComet(comelemlist.text,delcommemo);
screen.cursor:=crDefault;
UpdComList;
end;

procedure Tf_config_solsys.DelComAllClick(Sender: TObject);
begin
screen.cursor:=crHourGlass;
cdb.DelCometAll(delComMemo);
screen.cursor:=crDefault;
UpdComList;
end;

procedure Tf_config_solsys.AddComClick(Sender: TObject);
var
  msg :string;
begin
msg:=cdb.AddCom(comid.text,trim(comt_y.text)+'.'+trim(comt_m.text)+'.'+trim(comt_d.text),comep.text,comq.text,comec.text,comperi.text,comnode.text,comi.text,comh.text,comg.text,comnam.text,comeq.text);
UpdComList;
if msg<>'' then Showmessage(msg);
end;

procedure Tf_config_solsys.comdbsetClick(Sender: TObject);
begin
if Assigned(FShowDB) then FShowDB(self);
end;

procedure Tf_config_solsys.UpdAstList;
begin
cdb.GetAsteroidFileList(cmain,astelemlist.items);
astelemlist.itemindex:=0;
if astelemlist.items.count>0 then astelemlist.text:=astelemlist.items[0];
end;


procedure Tf_config_solsys.showastClick(Sender: TObject);
begin
csc.ShowAsteroid:=showast.checked;
end;

procedure Tf_config_solsys.astsymbolClick(Sender: TObject);
begin
csc.astsymbol:=astsymbol.itemindex;
end;

procedure Tf_config_solsys.astlimitmagChange(Sender: TObject);
begin
if LockChange then exit;
if trim(astlimitmag.text)<>'' then csc.AstmagMax:=astlimitmag.value;
end;

procedure Tf_config_solsys.astmagdiffChange(Sender: TObject);
begin
if LockChange then exit;
csc.AstmagDiff:=astmagdiff.value;
end;

procedure Tf_config_solsys.astdbsetClick(Sender: TObject);
begin
if Assigned(FShowDB) then FShowDB(self);
end;

procedure Tf_config_solsys.LoadMPCClick(Sender: TObject);
var ok:boolean;
begin
if Sender=LoadMPC then MemoMpc.Clear;
screen.cursor:=crHourGlass;
ok:=cdb.LoadAsteroidFile(SafeUTF8ToSys(mpcfile.text),astnumbered.checked,aststoperr.checked,astlimitbox.checked,astlimit.value,MemoMPC);
UpdAstList;
screen.cursor:=crDefault;
if ok then begin
  if autoprocess then AstComputeClick(Sender)
  else begin
     Showmessage(rsToUseThisNew);
     AstPageControl.activepage:=astprepare;
     AstComputeClick(Sender);
  end;
end;
end;

procedure Tf_config_solsys.AstComputeClick(Sender: TObject);
var jd1,jd2,step:double;
    y,m,i:integer;
begin
try
screen.cursor:=crHourGlass;
prepastmemo.clear;
if assigned(FPrepareAsteroid) then begin
y:=strtoint(trim(aststrtdate_y.text));
m:=strtoint(trim(aststrtdate_m.text));
i:=astnummonth.position-1;
jd1:=jd(y,m,1,0);
jd2:=jd(y,m+i,1,0);
step:=max(1.0,(jd2-jd1)/i);
if not FPrepareAsteroid(jd1,jd2,step,prepastmemo.lines) then begin
   screen.cursor:=crDefault;
   ShowMessage(Format(rsNoAsteroidDa, [crlf]));
   AstPageControl.activepage:=astload;
   exit;
end;
prepastmemo.lines.Add(rsYouAreNowRea);
screen.cursor:=crDefault;
showast.checked:=true;
end
 else prepastmemo.lines.Add('Error! PrepareAsteroid function not initialized.');
except
screen.cursor:=crDefault;
end;
end;

procedure Tf_config_solsys.delastClick(Sender: TObject);
begin
screen.cursor:=crHourGlass;
Cdb.DelAsteroid(astelemlist.text, delastMemo);
screen.cursor:=crDefault;
UpdAstList;
end;

procedure Tf_config_solsys.deldateastClick(Sender: TObject);
begin
screen.cursor:=crHourGlass;
cdb.DelAstDate(trim(astdeldate_y.text)+'.'+trim(astdeldate_m.text), delastMemo);
screen.cursor:=crDefault;
end;

procedure Tf_config_solsys.delallastClick(Sender: TObject);
begin
screen.cursor:=crHourGlass;
cdb.DelAstAll(delastMemo);
screen.cursor:=crDefault;
UpdAstList;
end;

procedure Tf_config_solsys.AddastClick(Sender: TObject);
var
  msg :string;
begin
msg:=Cdb.AddAsteroid(astid.text,asth.text,astg.text,astep.text,astma.text,astperi.text,astnode.text,asti.text,astec.text,astax.text,astref.text,astnam.text,asteq.text);
UpdAstList;
if msg<>'' then showmessage(msg);
end;

procedure Tf_config_solsys.smallsatChange(Sender: TObject);
begin
if LockChange then exit;
  csc.ShowSmallsat:=smallsat.checked;
end;

procedure Tf_config_solsys.SunOnlineClick(Sender: TObject);
begin
  csc.SunOnline := SunOnline.Checked;
end;

procedure Tf_config_solsys.LoadSampleData;
begin
  // load sample asteroid data
  mpcfile.text:=slash(sampledir)+'MPCsample.dat';
  autoprocess:=true;
  LoadMPCClick(Self);
  autoprocess:=false;
  mpcfile.text:='';
  // load sample comet data
  comfile.text:=slash(sampledir)+'Cometsample.dat';
  LoadComClick(Self);
  comfile.text:='';
  csc.ShowComet:=true;
  csc.ShowAsteroid:=true;
end;

end.
