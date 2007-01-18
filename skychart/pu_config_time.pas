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

uses u_translation, u_constant, u_util, u_projection,
  LCLIntf, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, CheckLst, Buttons, Spin, ExtCtrls, enhedits, ComCtrls, LResources,
  ButtonPanel, jdcalendar;

type

  { Tf_config_time }

  Tf_config_time = class(TForm)
    BitBtn1: TBitBtn;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    CheckGroup1: TCheckGroup;
    DST: TCheckBox;
    JDEdit: TFloatEdit;
    Label1: TLabel;
    tzLabel: TLabel;
    MainPanel: TPanel;
    Page1: TPage;
    Page2: TPage;
    Label142: TLabel;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    Panel1: TPanel;
    Panel7: TPanel;
    Label134: TLabel;
    Label148: TLabel;
    Label149: TLabel;
    RadioGroup1: TRadioGroup;
    tz: TFloatEdit;
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
    BitBtn4: TBitBtn;
    ADBC: TRadioGroup;
    d_year: TSpinEdit;
    d_month: TSpinEdit;
    d_day: TSpinEdit;
    t_hour: TSpinEdit;
    t_min: TSpinEdit;
    t_sec: TSpinEdit;
    stepreset: TSpeedButton;
    Label178: TLabel;
    Label179: TLabel;
    Label180: TLabel;
    Label56: TLabel;
    stepunit: TRadioGroup;
    stepline: TCheckBox;
    nbstep: TSpinEdit;
    stepsize: TSpinEdit;
    SimObj: TCheckListBox;
    AllSim: TButton;
    NoSim: TButton;
    Notebook1: TNotebook;
    procedure BitBtn1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure CheckBox1Click(Sender: TObject);
    procedure CheckBox2Click(Sender: TObject);
    procedure CheckGroup1ItemClick(Sender: TObject; Index: integer);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure JDEditChange(Sender: TObject);
    procedure LongEdit2Change(Sender: TObject);
    procedure DateChange(Sender: TObject);
    procedure RadioGroup1Click(Sender: TObject);
    procedure SimObjItemClick(Sender: TObject; Index: LongInt);
    procedure TimeChange(Sender: TObject);
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
  private
    { Private declarations }
    LockChange, LockJD: boolean;
    FApplyConfig: TNotifyEvent;
    JDCalendarDialog1: TJDCalendarDialog;
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
    property onApplyConfig: TNotifyEvent read FApplyConfig write FApplyConfig;
  end;

implementation

procedure Tf_config_time.SetLang;
begin
Caption:=rsDateTime;
Page1.caption:=rsTime;
Label142.caption:=rsSeconds;
CheckBox2.caption:=rsAutoRefreshE;
Label134.caption:=rsLocalTime+rsUT+' +';
Label148.caption:=rsTimeZone;
Label149.caption:=rsNegativeWest;
DST.caption:=rsDaylightSavi;
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
BitBtn4.caption:=rsActualSystem;
CheckBox1.caption:=rsUseSystemTim;
Page2.caption:=rsSimulation;
stepreset.caption:=rsReset;
Label178.caption:=rsEvery;
Label179.caption:=rsNumberOfStep;
Label180.caption:=rsChooseWhichO;
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
JDCalendarDialog1.labels.Mon:=rsMonday;
JDCalendarDialog1.labels.Tue:=rsTuesday;
JDCalendarDialog1.labels.Wed:=rsWednesday;
JDCalendarDialog1.labels.Thu:=rsThursday;
JDCalendarDialog1.labels.Fri:=rsFriday;
JDCalendarDialog1.labels.Sat:=rsSaturday;
JDCalendarDialog1.labels.Sun:=rsSunday;
JDCalendarDialog1.labels.jd:=rsJulianDay;
JDCalendarDialog1.labels.today:=rsToday;
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
ADBC.Items[0]:=rsAD;
ADBC.Items[1]:=rsBC;
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
if csc.ShowPluto then SimObj.items[9]:=rsPluto
                 else SimObj.items[9]:='';
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
  d_year.value:=y;
  adbc.itemindex:=0;
end else begin
  d_year.value:=1-y;
  adbc.itemindex:=1;
end;
d_month.value:=m;
d_day.value:=d;
artostr2(csc.curtime,h,n,s);
t_hour.value:=strtoint(h);
t_min.value:=strtoint(n);
t_sec.value:=strtoint(s);
tz.value:=csc.tz.SecondsOffset/3600;
DST.Checked:=csc.tz.Daylight;
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
  10: j:=12;   // asteroid
  11: j:=13;   // comet
  else j:=i;
  end;
  if (i=9) and (not csc.ShowPluto) then SimObj.checked[9]:=false
     else SimObj.checked[i]:=csc.SimObject[j];
end;
RadioGroup1.ItemIndex:=csc.SimLabel;
CheckGroup1.Checked[0]:=csc.SimNameLabel;
CheckGroup1.Checked[1]:=csc.SimDateLabel;
end;

procedure Tf_config_time.CheckBox1Click(Sender: TObject);
begin
csc.UseSystemTime:=checkbox1.checked;
SetCurrentTime(csc);
d_year.enabled:=not csc.UseSystemTime;
d_month.enabled:=d_year.enabled;
d_day.enabled:=d_year.enabled;
ADBC.enabled:=d_year.enabled;
t_hour.enabled:=d_year.enabled;
t_min.enabled:=d_year.enabled;
t_sec.enabled:=d_year.enabled;
bitbtn4.enabled:=d_year.enabled;
JDedit.enabled:=d_year.enabled;
BitBtn1.enabled:=d_year.enabled;
ShowTime;
end;

procedure Tf_config_time.Button2Click(Sender: TObject);
begin
  if assigned(FApplyConfig) then FApplyConfig(Self);
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
Djd(JDEdit.Value+csc.timezone/24,csc.curyear,csc.curmonth,csc.curday,csc.CurTime);
csc.tz.Date:=EncodeDate(csc.curyear,csc.curmonth,csc.curday)+csc.curtime/secday;
csc.TimeZone:=csc.tz.SecondsOffset/3600;
tzlabel.caption:=csc.tz.ZoneName;
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

procedure Tf_config_time.CheckGroup1ItemClick(Sender: TObject; Index: integer);
begin
if (not CheckGroup1.Checked[0])and(not CheckGroup1.Checked[1])and(not CheckGroup1.Checked[2])
  then CheckGroup1.Checked[abs(Index-1)]:=true;
csc.SimNameLabel:=CheckGroup1.Checked[0];
csc.SimDateLabel:=CheckGroup1.Checked[1];
csc.SimMagLabel:=CheckGroup1.Checked[2];
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
BitBtn1.Glyph.LoadFromLazarusResource('BtnDatePicker');
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

procedure Tf_config_time.DateChange(Sender: TObject);
begin
if LockChange then exit;
if adbc.itemindex=0 then
  csc.curyear:=d_year.value
else
  csc.curyear:=1-d_year.value;
csc.curmonth:=d_month.value;
d_day.maxvalue:=MonthDays[IsleapYear(csc.curyear),csc.curmonth];
csc.curday:=d_day.value;
csc.tz.Date:=EncodeDate(csc.curyear,csc.curmonth,csc.curday)+csc.curtime/secday;
csc.TimeZone:=csc.tz.SecondsOffset/3600;
tzlabel.caption:=csc.tz.ZoneName;
csc.DT_UT:=DTminusUT(csc.curyear,csc);
Tdt_Ut.caption:=inttostr(round(csc.DT_UT*3600));
dt_ut.text:=Tdt_Ut.caption;
LockChange:=true;
JDEdit.Value:=Jd(csc.curyear,csc.curmonth,csc.curday,csc.curtime-csc.timezone);
LockChange:=false;
end;

procedure Tf_config_time.RadioGroup1Click(Sender: TObject);
begin
if LockChange then exit;
csc.SimLabel:=RadioGroup1.ItemIndex;
end;

procedure Tf_config_time.TimeChange(Sender: TObject);
begin
if LockChange then exit;
csc.curtime:=t_hour.value+t_min.value/60+t_sec.value/3600;
csc.tz.Date:=EncodeDate(csc.curyear,csc.curmonth,csc.curday)+csc.curtime/secday;
csc.TimeZone:=csc.tz.SecondsOffset/3600;
tzlabel.caption:=csc.tz.ZoneName;
LockChange:=true;
JDEdit.Value:=Jd(csc.curyear,csc.curmonth,csc.curday,csc.curtime-csc.timezone);
LockChange:=false;
end;

procedure Tf_config_time.BitBtn4Click(Sender: TObject);
var y,m,d,h,n,s,ms : word;
begin
 ADBC.itemindex:=0;
 decodedate(csc.tz.NowLocalTime,y,m,d);
 decodeTime(csc.tz.NowLocalTime,h,n,s,ms);
 d_year.value:=y;
 d_month.value:=m;
 d_day.value:=d;
 t_hour.value:=h;
 t_min.value:=n;
 t_sec.value:=s;
 DateChange(Sender);
 TimeChange(Sender);
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
  10: j:=12;   // asteroid
  11: j:=13;   // comet
  else j:=index;
  end;
  if (index=9) and (not csc.ShowPluto) then SimObj.checked[index]:=false;
  csc.SimObject[j]:=SimObj.checked[index];
end;

procedure Tf_config_time.AllSimClick(Sender: TObject);
var i:integer;
begin
for i:=0 to SimObj.Items.Count-1 do begin
  if (i=9) and (not csc.ShowPluto) then SimObj.checked[i]:=false
    else SimObj.checked[i]:=true;
end;
{$ifdef win32}
 for i:=0 to SimObj.Items.Count-1 do SimObjItemClick(Sender,i);
{$endif}
end;

procedure Tf_config_time.NoSimClick(Sender: TObject);
var i:integer;
begin
for i:=0 to SimObj.Items.Count-1 do
    SimObj.checked[i]:=false;
{$ifdef win32}
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
end;

procedure Tf_config_time.stepsizeChanged(Sender: TObject);
begin
if LockChange then exit;
stepunitClick(Sender);
end;

initialization
  {$i pu_config_time.lrs}

end.
