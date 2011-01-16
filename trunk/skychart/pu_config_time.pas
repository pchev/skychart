unit pu_config_time;

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

uses u_help, u_translation, u_constant, u_util, u_projection, cu_tz,
  LCLIntf, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, CheckLst, Buttons, Spin, ExtCtrls, enhedits, ComCtrls, LResources,
  ButtonPanel, jdcalendar, LazHelpHTML, EditBtn;

type

  { Tf_config_time }

  Tf_config_time = class(TForm)
    BitBtn1: TBitBtn;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    Button6: TButton;
    BitBtn4: TButton;
    Button7: TButton;
    Button8: TButton;
    Button9: TButton;
    CheckBox3: TCheckBox;
    CheckGroup1: TCheckGroup;
    CheckGroup2: TCheckGroup;
    ComboBox1: TComboBox;
    DirectoryEdit1: TDirectoryEdit;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    Edit5: TEdit;
    FileNameEdit1: TFileNameEdit;
    FloatSpinEdit1: TFloatSpinEdit;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    Label10: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Page3: TTabSheet;
    TrackBar1: TTrackBar;
    t_hour: TUpDown;
    d_yearEdit: TEdit;
    d_monthEdit: TEdit;
    d_dayEdit: TEdit;
    t_min: TUpDown;
    t_hourEdit: TEdit;
    JDEdit: TFloatEdit;
    Label1: TLabel;
    tzLabel: TLabel;
    MainPanel: TPanel;
    Page1: TTabSheet;
    Page2: TTabSheet;
    Label142: TLabel;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    Panel1: TPanel;
    RadioGroup1: TRadioGroup;
    Panel8: TPanel;
    Label135: TLabel;
    Tdt_Ut: TLabel;
    Label136: TLabel;
    Label150: TLabel;
    CheckBox4: TCheckBox;
    dt_ut: TLongEdit;
    LongEdit2: TLongEdit;
    Panel9: TPanel;
    Label137: TLabel;
    Label139: TLabel;
    Label141: TLabel;
    Label138: TLabel;
    Label143: TLabel;
    Label144: TLabel;
    Label145: TLabel;
    Label140: TLabel;
    ADBC: TRadioGroup;
    stepreset: TSpeedButton;
    Label178: TLabel;
    Label179: TLabel;
    Label56: TLabel;
    stepunit: TRadioGroup;
    stepline: TCheckBox;
    nbstep: TSpinEdit;
    stepsize: TSpinEdit;
    SimObj: TCheckListBox;
    AllSim: TButton;
    NoSim: TButton;
    PageControl1: TPageControl;
    d_year: TUpDown;
    d_month: TUpDown;
    d_day: TUpDown;
    t_sec: TUpDown;
    t_minEdit: TEdit;
    t_secEdit: TEdit;
    procedure BitBtn1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure Button8Click(Sender: TObject);
    procedure Button9Click(Sender: TObject);
    procedure CheckBox1Click(Sender: TObject);
    procedure CheckBox2Click(Sender: TObject);
    procedure CheckBox3Change(Sender: TObject);
    procedure CheckGroup1ItemClick(Sender: TObject; Index: integer);
    procedure CheckGroup2ItemClick(Sender: TObject; Index: integer);
    procedure ComboBox1Change(Sender: TObject);
    procedure DateEditChange(Sender: TObject);
    procedure DirectoryEdit1Change(Sender: TObject);
    procedure Edit1Change(Sender: TObject);
    procedure Edit2Change(Sender: TObject);
    procedure Edit3Change(Sender: TObject);
    procedure Edit4Change(Sender: TObject);
    procedure Edit5Change(Sender: TObject);
    procedure FileNameEdit1AcceptFileName(Sender: TObject; var Value: String);
    procedure FileNameEdit1Change(Sender: TObject);
    procedure FloatSpinEdit1Change(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure JDEditChange(Sender: TObject);
    procedure LongEdit2Change(Sender: TObject);
    procedure DateChange(Sender: TObject; Button: TUDBtnType);
    procedure RadioGroup1Click(Sender: TObject);
    procedure SimObjItemClick(Sender: TObject; Index: LongInt);
    procedure TimeChange(Sender: TObject; Button: TUDBtnType);
    procedure BitBtn4Click(Sender: TObject);
    procedure CheckBox4Click(Sender: TObject);
    procedure dt_utChange(Sender: TObject);
    procedure nbstepChanged(Sender: TObject);
    procedure stepsizeChanged(Sender: TObject);
    procedure stepunitClick(Sender: TObject);
    procedure stepresetClick(Sender: TObject);
    procedure steplineClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure AllSimClick(Sender: TObject);
    procedure NoSimClick(Sender: TObject);
    procedure TimeEditChange(Sender: TObject);
    procedure TrackBar1Change(Sender: TObject);
  private
    { Private declarations }
    LockChange, LockJD: boolean;
    FApplyConfig: TNotifyEvent;
    JDCalendarDialog1: TJDCalendarDialog;
    FGetTwilight: TGetTwilight;
    procedure ShowTime;
  public
    { Public declarations }
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
    procedure SetLang;
    constructor Create(AOwner:TComponent); override;
    destructor Destroy; override;
    property onGetTwilight: TGetTwilight read FGetTwilight write FGetTwilight;
    property onApplyConfig: TNotifyEvent read FApplyConfig write FApplyConfig;
  end;

implementation

procedure Tf_config_time.SetLang;
var Alabels: TDatesLabelsArray;
begin
Caption:=rsDateTime;
Page1.caption:=rsTime;
Label142.caption:=rsSeconds;
CheckBox2.caption:=rsAutoRefreshE;
Label135.caption:=rsDTUT;
Label136.caption:=rsSeconds;
Label150.caption:=rsDynamicTimeD;
CheckBox4.caption:=rsUseAnotherDT;
Label137.caption:=rsTime;
Label138.caption:=rsSHour;
Label139.caption:=rsSMinute;
Label141.caption:=rsSSecond;
Label143.caption:=rsSYear;
Label144.caption:=rsSMonth;
Label145.caption:=rsSDay;
Label140.caption:=rsDate;
Label1.caption:=rsJD;
Button8.Caption:=rsTonight;
BitBtn4.caption:=rsActualSystem;
Button5.Caption:='0h';
Button6.Caption:='0h '+rsUT;
CheckBox1.caption:=rsUseSystemTim;
Page2.caption:=rsSimulation;
stepreset.caption:=rsReset;
Label178.caption:=rsEvery;
Label179.caption:=rsNumberOfStep;
Label56.caption:=rsPlotThePosit;
stepunit.caption:=rsStepUnit;
stepunit.items[0]:=rsDay;
stepunit.items[1]:=rsHour;
stepunit.items[2]:=rsMinute;
stepunit.items[3]:=rsSecond;
stepline.caption:=rsConnectionLi;
SimObj.items[0]:=rsSun;
SimObj.items[1]:=rsMercury;
SimObj.items[2]:=rsVenus;
SimObj.items[3]:=rsMoon;
SimObj.items[4]:=rsMars;
SimObj.items[5]:=rsJupiter;
SimObj.items[6]:=rsSaturn;
SimObj.items[7]:=rsUranus;
SimObj.items[8]:=rsNeptune;
SimObj.items[9]:=rsPluto;
SimObj.items[10]:=rsAsteroid;
SimObj.items[11]:=rsComet;
AllSim.caption:=rsAll;
NoSim.caption:=rsNone1;
Button1.caption:=rsOK;
Button2.caption:=rsApply;
Button3.caption:=rsCancel;
JDCalendarDialog1.Caption:=rsJDCalendar;
Alabels.Mon:=rsMonday;
Alabels.Tue:=rsTuesday;
Alabels.Wed:=rsWednesday;
Alabels.Thu:=rsThursday;
Alabels.Fri:=rsFriday;
Alabels.Sat:=rsSaturday;
Alabels.Sun:=rsSunday;
Alabels.jd:=rsJulianDay;
Alabels.today:=rsToday;
JDCalendarDialog1.labels:=Alabels;
RadioGroup1.Caption:=rsShowLabels;
RadioGroup1.Items[0]:=rsEveryPositio;
RadioGroup1.Items[1]:=rsOneOfTwo;
RadioGroup1.Items[2]:=rsOneOfThree;
RadioGroup1.Items[3]:=rsOnlyTheFirst;
RadioGroup1.Items[4]:=rsOnlyTheLast;
RadioGroup1.Items[5]:=rsNone1;
CheckGroup1.Caption:=rsLabelText;
CheckGroup1.Items[0]:=rsObjectName;
CheckGroup1.Items[1]:=rsCurrentDate;
CheckGroup1.Items[2]:=rsMagnitude;
CheckGroup2.Caption:=rsDateFormat;
CheckGroup2.Items[0]:=rsYear;
CheckGroup2.Items[1]:=rsMonth;
CheckGroup2.Items[2]:=rsDay;
CheckGroup2.Items[3]:=rsHour;
CheckGroup2.Items[4]:=rsMinute;
CheckGroup2.Items[5]:=rsSecond;
ADBC.Items[0]:=rsAD;
ADBC.Items[1]:=rsBC;
Button4.Caption:=rsMoreOptions;
Button7.caption:=rsHelp;
SetHelp(self,hlpCfgDate);
Page3.Caption:=rsAnimation;
Button9.Caption:=rsDefault;
GroupBox1.Caption:=rsRealTimeOpti;
Label2.Caption:=rsDelayBetween;
GroupBox2.Caption:=rsRecordingOpt;
CheckBox3.Caption:=rsRecordAnimat;
Label3.Caption:=rsRecordingDir;
Label4.Caption:=rsRecordingPre;
Label9.Caption:=rsRecordingExt;
Label5.Caption:=rsFramesPerSec;
Label7.Caption:=rsFramesSize;
Label6.Caption:=rsAdditionalFf;
Label10.Caption:=rsFfmpegProgra;
ComboBox1.Items[0]:=rsNoChange;
ComboBox1.Items[5]:=rsFreeSize;
end;

constructor Tf_config_time.Create(AOwner:TComponent);
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
end;

destructor Tf_config_time.Destroy;
begin
JDCalendarDialog1.Free;
inherited Destroy;
end;

procedure Tf_config_time.FormShow(Sender: TObject);
begin
LockJD:=false;
LockChange:=true;
if csc.ShowPluto and (SimObj.Items[9]<>rsPluto) then SimObj.Items.Insert(9,rsPluto);
if (not csc.ShowPluto) and (SimObj.Items[9]=rsPluto) then SimObj.Items.Delete(9);
if not csc.ShowPluto then csc.SimObject[9]:=false;
ShowTime;
LockChange:=false;
end;

procedure Tf_config_time.ShowTime;
var h,n,s:string;
    y,m,d,i,j:integer;
begin
if not lockJD then JDEdit.Value:=Jd(csc.curyear,csc.curmonth,csc.curday,csc.curtime-csc.timezone);
y:=csc.curyear;
m:=csc.curmonth;
d:=csc.curday;
checkbox1.checked:=csc.UseSystemTime;
checkbox2.checked:=csc.AutoRefresh;
longedit2.value:=cmain.AutoRefreshDelay;
if y>0 then begin
  d_year.Position:=y;
  adbc.itemindex:=0;
end else begin
  d_year.Position:=1-y;
  adbc.itemindex:=1;
end;
d_month.Position:=m;
d_day.Position:=d;
artostr2(csc.curtime,h,n,s);
t_hour.Position:=strtoint(h);
t_min.Position:=strtoint(n);
t_sec.Position:=strtoint(s);
tzlabel.caption:=csc.tz.ZoneName;
Tdt_Ut.caption:=inttostr(round(csc.DT_UT*3600));
checkbox4.checked:=csc.Force_DT_UT;
if not csc.Force_DT_UT then csc.DT_UT_val:=csc.DT_UT;
dt_ut.value:=round(csc.DT_UT_val*3600);
nbstep.value:=csc.Simnb;
if csc.SimD>0 then begin
   stepsize.value:=csc.SimD;
   stepunit.itemindex:=0;
end;
if csc.SimH>0 then begin
   stepsize.value:=csc.SimH;
   stepunit.itemindex:=1;
end;
if csc.SimM>0 then begin
   stepsize.value:=csc.SimM;
   stepunit.itemindex:=2;
end;
if csc.SimS>0 then begin
   stepsize.value:=csc.SimS;
   stepunit.itemindex:=3;
end;
stepline.checked:=csc.SimLine;
for i:=0 to SimObj.Items.Count-1 do begin
  case i of
  0 : j:=10;   // sun
  3 : j:=11;   // moon
  9 : if  csc.ShowPluto then j:=9 else j:=12; // pluto / asteroid
  10: if  csc.ShowPluto then j:=12 else j:=13;   // asteroid / comet
  11: j:=13;   // comet
  else j:=i;
  end;
  if (i=9) and (not csc.ShowPluto) then SimObj.checked[9]:=false
     else SimObj.checked[i]:=csc.SimObject[j];
end;
RadioGroup1.ItemIndex:=csc.SimLabel;
CheckGroup1.Checked[0]:=csc.SimNameLabel;
CheckGroup1.Checked[1]:=csc.SimDateLabel;
CheckGroup2.Checked[0]:=csc.SimDateYear;
CheckGroup2.Checked[1]:=csc.SimDateMonth;
CheckGroup2.Checked[2]:=csc.SimDateDay;
CheckGroup2.Checked[3]:=csc.SimDateHour;
CheckGroup2.Checked[4]:=csc.SimDateMinute;
CheckGroup2.Checked[5]:=csc.SimDateSecond;
TrackBar1.Position:=cmain.AnimDelay;
CheckBox3.Checked:=cmain.AnimRec;
DirectoryEdit1.Directory:=cmain.AnimRecDir;
Edit1.Text:=cmain.AnimRecPrefix;
Edit5.Text:=cmain.AnimRecExt;
FloatSpinEdit1.Value:=cmain.AnimFps;
edit3.Text:=inttostr(cmain.AnimSx);
edit4.Text:=inttostr(cmain.AnimSy);
ComboBox1.ItemIndex:=cmain.AnimSize;
ComboBox1Change(nil);
edit2.Text := cmain.AnimOpt;
FileNameEdit1.FileName:=cmain.Animffmpeg;
end;

procedure Tf_config_time.CheckBox1Click(Sender: TObject);
begin
csc.UseSystemTime:=checkbox1.checked;
SetCurrentTime(csc);
csc.DT_UT:=DTminusUT(csc.curyear,csc);
d_year.enabled:=not csc.UseSystemTime;
d_yearEdit.enabled:=d_year.enabled;
d_month.enabled:=d_year.enabled;
d_monthEdit.enabled:=d_year.enabled;
d_day.enabled:=d_year.enabled;
d_dayEdit.enabled:=d_year.enabled;
ADBC.enabled:=d_year.enabled;
t_hour.enabled:=d_year.enabled;
t_hourEdit.enabled:=d_year.enabled;
t_min.enabled:=d_year.enabled;
t_minEdit.enabled:=d_year.enabled;
t_sec.enabled:=d_year.enabled;
t_secEdit.enabled:=d_year.enabled;
bitbtn4.enabled:=d_year.enabled;
JDedit.enabled:=d_year.enabled;
BitBtn1.enabled:=d_year.enabled;
Button5.enabled:=d_year.enabled;
Button6.enabled:=d_year.enabled;
Button8.enabled:=d_year.enabled;
ShowTime;
end;

procedure Tf_config_time.Button2Click(Sender: TObject);
begin
  if assigned(FApplyConfig) then FApplyConfig(Self);
end;

procedure Tf_config_time.Button4Click(Sender: TObject);
begin
  panel8.Visible:= not panel8.Visible;
end;

procedure Tf_config_time.BitBtn1Click(Sender: TObject);
begin
JDCalendarDialog1.JD:=JDEdit.Value;
if JDCalendarDialog1.Execute then begin
   JDEdit.Value:=JDCalendarDialog1.JD+csc.CurTime/24-csc.timezone/24;
end;
end;

procedure Tf_config_time.JDEditChange(Sender: TObject);
begin
if LockChange or LockJD then exit;
csc.tz.JD:=JDEdit.Value;
csc.TimeZone:=csc.tz.SecondsOffset/3600;
tzlabel.caption:=csc.tz.ZoneName;
Djd(JDEdit.Value+csc.timezone/24,csc.curyear,csc.curmonth,csc.curday,csc.CurTime);
LockChange:=true;
LockJD:=true;
ShowTime;
LockChange:=false;
LockJD:=false;
end;

procedure Tf_config_time.CheckBox2Click(Sender: TObject);
begin
csc.AutoRefresh:=checkbox2.checked;
end;

procedure Tf_config_time.CheckBox3Change(Sender: TObject);
begin
  cmain.AnimRec := CheckBox3.Checked;
end;

procedure Tf_config_time.CheckGroup1ItemClick(Sender: TObject; Index: integer);
begin
if (not CheckGroup1.Checked[0])and(not CheckGroup1.Checked[1])and(not CheckGroup1.Checked[2])
  then CheckGroup1.Checked[abs(Index-1)]:=true;
csc.SimNameLabel:=CheckGroup1.Checked[0];
csc.SimDateLabel:=CheckGroup1.Checked[1];
csc.SimMagLabel:=CheckGroup1.Checked[2];
end;

procedure Tf_config_time.CheckGroup2ItemClick(Sender: TObject; Index: integer);
begin
csc.SimDateYear:=CheckGroup2.Checked[0];
csc.SimDateMonth:=CheckGroup2.Checked[1];
csc.SimDateDay:=CheckGroup2.Checked[2];
csc.SimDateHour:=CheckGroup2.Checked[3];
csc.SimDateMinute:=CheckGroup2.Checked[4];
csc.SimDateSecond:=CheckGroup2.Checked[5];
end;

procedure Tf_config_time.ComboBox1Change(Sender: TObject);
begin
cmain.AnimSize := ComboBox1.ItemIndex;
if ComboBox1.ItemIndex=5 then begin
   edit3.Enabled:=true;
   edit4.Enabled:=true;
end else begin
  edit3.Enabled:=false;
  edit4.Enabled:=false;
end;
case  ComboBox1.ItemIndex of
  0: begin
       edit3.text:='-1';
       edit4.text:='-1';
     end;
  1: begin
       edit3.text:='640';
       edit4.text:='480';
     end;
  2: begin
       edit3.text:='852';
       edit4.text:='480';
     end;
  3: begin
       edit3.text:='1280';
       edit4.text:='720';
     end;
  4: begin
       edit3.text:='1920';
       edit4.text:='1080';
     end;
end;
end;

procedure Tf_config_time.FormClose(Sender: TObject;
  var CloseAction: TCloseAction);
begin
 LockChange:=true;
end;

procedure Tf_config_time.FormCreate(Sender: TObject);
begin
LockChange:=true;
JDCalendarDialog1:=TJDCalendarDialog.Create(nil);
JDEdit.MaxValue:=maxJD;
JDEdit.MinValue:=minJD;
//BitBtn1.Glyph.LoadFromLazarusResource('BtnDatePicker');
SetLang;
end;

procedure Tf_config_time.FormDestroy(Sender: TObject);
begin
mycsc.Free;
myccat.Free;
mycshr.Free;
mycplot.Free;
mycmain.Free;
end;

procedure Tf_config_time.LongEdit2Change(Sender: TObject);
begin
if LockChange then exit;
cmain.AutoRefreshDelay:=longedit2.value;
end;

procedure Tf_config_time.DateEditChange(Sender: TObject);
begin
if LockChange then exit;
if adbc.itemindex=0 then
  csc.curyear:=d_year.Position
else
  csc.curyear:=1-d_year.Position;
csc.curmonth:=d_month.Position;
d_day.max:=MonthDays[IsleapYear(csc.curyear),csc.curmonth];
csc.curday:=d_day.Position;
csc.tz.JD:=Jd(csc.curyear,csc.curmonth,csc.curday,csc.curtime-csc.timezone);
csc.TimeZone:=csc.tz.SecondsOffset/3600;
tzlabel.caption:=csc.tz.ZoneName;
csc.DT_UT:=DTminusUT(csc.curyear,csc);
Tdt_Ut.caption:=inttostr(round(csc.DT_UT*3600));
dt_ut.text:=Tdt_Ut.caption;
LockChange:=true;
JDEdit.Value:=Jd(csc.curyear,csc.curmonth,csc.curday,csc.curtime-csc.timezone);
LockChange:=false;
end;

procedure Tf_config_time.DirectoryEdit1Change(Sender: TObject);
begin
  cmain.AnimRecDir := DirectoryEdit1.Directory;
end;

procedure Tf_config_time.Edit1Change(Sender: TObject);
begin
  cmain.AnimRecPrefix := Edit1.Text;
end;

procedure Tf_config_time.Edit2Change(Sender: TObject);
begin
  cmain.AnimOpt:=edit2.Text;
end;

procedure Tf_config_time.Edit3Change(Sender: TObject);
var i,n: integer;
begin
val(edit3.Text,i,n);
if n=0 then cmain.AnimSx := i;
end;

procedure Tf_config_time.Edit4Change(Sender: TObject);
var i,n: integer;
begin
val(edit4.Text,i,n);
if n=0 then cmain.AnimSy := i;
end;

procedure Tf_config_time.Edit5Change(Sender: TObject);
begin
  cmain.AnimRecExt:=edit5.Text;
  if copy(cmain.AnimRecExt,1,1)<>'.' then cmain.AnimRecExt:='.'+cmain.AnimRecExt
end;

procedure Tf_config_time.FileNameEdit1AcceptFileName(Sender: TObject;
  var Value: String);
begin
cmain.Animffmpeg:=value;
end;

procedure Tf_config_time.FileNameEdit1Change(Sender: TObject);
begin
  cmain.Animffmpeg:=FileNameEdit1.FileName;
end;

procedure Tf_config_time.FloatSpinEdit1Change(Sender: TObject);
begin
  cmain.AnimFps := FloatSpinEdit1.Value;
end;

procedure Tf_config_time.DateChange(Sender: TObject; Button: TUDBtnType);
begin
{$ifdef darwin}
DateEditChange(Sender);
{$endif}
end;

procedure Tf_config_time.TimeEditChange(Sender: TObject);
begin
if LockChange then exit;
csc.curtime:=t_hour.Position+t_min.Position/60+t_sec.Position/3600;
csc.tz.JD:=jd(csc.curyear,csc.curmonth,csc.curday,csc.curtime/secday);
csc.TimeZone:=csc.tz.SecondsOffset/3600;
tzlabel.caption:=csc.tz.ZoneName;
LockChange:=true;
JDEdit.Value:=Jd(csc.curyear,csc.curmonth,csc.curday,csc.curtime-csc.timezone);
LockChange:=false;
end;

procedure Tf_config_time.TrackBar1Change(Sender: TObject);
begin
  cmain.AnimDelay:=TrackBar1.Position;
end;

procedure Tf_config_time.TimeChange(Sender: TObject; Button: TUDBtnType);
begin
{$ifdef darwin}
TimeEditChange(Sender);
{$endif}
end;

procedure Tf_config_time.RadioGroup1Click(Sender: TObject);
begin
if LockChange then exit;
csc.SimLabel:=RadioGroup1.ItemIndex;
end;

procedure Tf_config_time.BitBtn4Click(Sender: TObject);
var y,m,d,h,n,s,ms : word;
begin
 ADBC.itemindex:=0;
 decodedate(csc.tz.NowLocalTime,y,m,d);
 d_year.Position:=y;
 d_month.Position:=m;
 d_day.Position:=d;
 decodeTime(csc.tz.NowLocalTime,h,n,s,ms);
 t_hour.Position:=h;
 t_min.Position:=n;
 t_sec.Position:=s;
 DateEditChange(Sender);
 TimeEditChange(Sender);
end;

procedure Tf_config_time.Button5Click(Sender: TObject);
var y,m,d,h,n,s,ms : word;
begin
 csc.tz.JD:=Jd(csc.curyear,csc.curmonth,csc.curday,0);
 if (csc.curyear>cu_tz.minYear)and(csc.curyear<cu_tz.maxYear) then begin
   decodedate(csc.tz.Date,y,m,d);
   d_year.Position:=y;
   d_month.Position:=m;
   d_day.Position:=d;
 end;
 decodeTime(csc.tz.Date,h,n,s,ms);
 t_hour.Position:=h;
 t_min.Position:=n;
 t_sec.Position:=s;
 DateEditChange(Sender);
 TimeEditChange(Sender);
end;

procedure Tf_config_time.Button6Click(Sender: TObject);
var y,m,d,h,n,s,ms : word;
begin
 csc.tz.JD:=Jd(csc.curyear,csc.curmonth,csc.curday,csc.timezone);
 if (csc.curyear>cu_tz.minYear)and(csc.curyear<cu_tz.maxYear) then begin
   decodedate(csc.tz.Date,y,m,d);
   d_year.Position:=y;
   d_month.Position:=m;
   d_day.Position:=d;
 end;
 decodeTime(csc.tz.Date,h,n,s,ms);
 t_hour.Position:=h;
 t_min.Position:=n;
 t_sec.Position:=s;
 DateEditChange(Sender);
 TimeEditChange(Sender);
end;

procedure Tf_config_time.Button7Click(Sender: TObject);
begin
  ShowHelp;
end;

procedure Tf_config_time.Button8Click(Sender: TObject);
var ht: double;
    h,n,s: string;
    y,m,d : word;
begin
if assigned(FGetTwilight) then begin
   ADBC.itemindex:=0;
   decodedate(csc.tz.NowLocalTime,y,m,d);
   d_year.Position:=y;
   d_month.Position:=m;
   d_day.Position:=d;
   FGetTwilight(jd(y,m,d,0),ht);
   if ht>0 then begin
     artostr2(ht,h,n,s);
     t_hour.Position:=strtoint(h);
     t_min.Position:=strtoint(n);
     t_sec.Position:=strtoint(s);
   end else
     ShowMessage(rsNoAstronomic);
end;
end;

procedure Tf_config_time.Button9Click(Sender: TObject);
begin
  CheckBox3.Checked:=false;
  DirectoryEdit1.Directory:=PrivateDir;
  Edit1.Text:='skychart';
  Edit5.Text:='.mp4';
  FloatSpinEdit1.Value:=2.0;
  ComboBox1.ItemIndex:=0;
  Edit2.Text:=DefaultffmpegOptions;
end;

procedure Tf_config_time.CheckBox4Click(Sender: TObject);
begin
csc.Force_DT_UT:=checkbox4.checked;
dt_ut.enabled:=csc.Force_DT_UT;
csc.DT_UT:=DTminusUT(csc.curyear,csc);
Tdt_Ut.caption:=inttostr(round(csc.DT_UT*3600));
dt_ut.text:=Tdt_Ut.caption;
end;

procedure Tf_config_time.dt_utChange(Sender: TObject);
begin
if LockChange then exit;
csc.DT_UT_val:=dt_ut.value/3600;
csc.DT_UT:=csc.DT_UT_val;
Tdt_ut.caption:=dt_ut.text;
end;

procedure Tf_config_time.SimObjItemClick(Sender: TObject; Index: LongInt);
var j:integer;
begin
  case index of
  0 : j:=10;   // sun
  3 : j:=11;   // moon
  9 : if  csc.ShowPluto then j:=9 else j:=12; // pluto / asteroid
  10: if  csc.ShowPluto then j:=12 else j:=13;   // asteroid / comet
  11: j:=13;   // comet
  else j:=index;
  end;
  csc.SimObject[j]:=SimObj.checked[index];
end;

procedure Tf_config_time.AllSimClick(Sender: TObject);
var i:integer;
begin
for i:=0 to SimObj.Items.Count-1 do begin
    SimObj.checked[i]:=true;
end;
{$IF DEFINED(mswindows) or DEFINED(LCLgtk2)}
 for i:=0 to SimObj.Items.Count-1 do SimObjItemClick(Sender,i);
{$endif}
end;

procedure Tf_config_time.NoSimClick(Sender: TObject);
var i:integer;
begin
for i:=0 to SimObj.Items.Count-1 do
    SimObj.checked[i]:=false;
{$IF DEFINED(mswindows) or DEFINED(LCLgtk2)}
 for i:=0 to SimObj.Items.Count-1 do SimObjItemClick(Sender,i);
{$endif}
end;

procedure Tf_config_time.stepunitClick(Sender: TObject);
begin
case stepunit.ItemIndex of
 0 : begin
       csc.SimD:=stepsize.value;
       csc.SimH:=0;csc.SimM:=0;csc.SimS:=0;
     end;
 1 : begin
       csc.SimH:=stepsize.value;
       csc.SimD:=0;csc.SimM:=0;csc.SimS:=0;
     end;
 2 : begin
       csc.SimM:=stepsize.value;
       csc.SimD:=0;csc.SimH:=0;csc.SimS:=0;
     end;
 3 : begin
       csc.SimS:=stepsize.value;
       csc.SimD:=0;csc.SimH:=0;csc.SimM:=0;
     end;
end;
end;


procedure Tf_config_time.steplineClick(Sender: TObject);
begin
csc.SimLine:=stepline.checked;
end;

procedure Tf_config_time.stepresetClick(Sender: TObject);
begin
nbstep.value:=1;
nbstepChanged(Sender);
stepsize.value:=1;
stepunit.ItemIndex:=0;
stepunitClick(Sender);
end;

procedure Tf_config_time.nbstepChanged(Sender: TObject);
begin
if LockChange then exit;
csc.Simnb:=nbstep.value;
Setlength(csc.AsteroidLst,csc.Simnb);
SetLength(csc.CometLst,csc.SimNb);
SetLength(csc.AsteroidName,csc.SimNb);
SetLength(csc.CometName,csc.SimNb);
end;

procedure Tf_config_time.stepsizeChanged(Sender: TObject);
begin
if LockChange then exit;
stepunitClick(Sender);
end;

initialization
  {$i pu_config_time.lrs}

end.
