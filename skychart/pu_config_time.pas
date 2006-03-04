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

uses u_constant, u_util,
  LCLIntf, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, CheckLst, Buttons, Spin, ExtCtrls, enhedits, ComCtrls, LResources,
  WizardNotebook, ButtonPanel;

type

  { Tf_config_time }

  Tf_config_time = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
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
    WizardNotebook1: TWizardNotebook;
    procedure Button2Click(Sender: TObject);
    procedure CheckBox1Click(Sender: TObject);
    procedure CheckBox2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure LongEdit2Change(Sender: TObject);
    procedure DateChange(Sender: TObject);
    procedure TimeChange(Sender: TObject);
    procedure BitBtn4Click(Sender: TObject);
    procedure tzChange(Sender: TObject);
    procedure CheckBox4Click(Sender: TObject);
    procedure dt_utChange(Sender: TObject);
    procedure SimObjClickCheck(Sender: TObject);
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
    LockChange: boolean;
    FApplyConfig: TNotifyEvent;
    procedure ShowTime;
  public
    { Public declarations }
    mycsc : conf_skychart;
    myccat : conf_catalog;
    mycshr : conf_shared;
    mycplot : conf_plot;
    mycmain : conf_main;
    csc : Pconf_skychart;
    ccat : Pconf_catalog;
    cshr : Pconf_shared;
    cplot : Pconf_plot;
    cmain : Pconf_main;
    constructor Create(AOwner:TComponent); override;
    property onApplyConfig: TNotifyEvent read FApplyConfig write FApplyConfig;
  end;

implementation



constructor Tf_config_time.Create(AOwner:TComponent);
begin
 csc:=@mycsc;
 ccat:=@myccat;
 cshr:=@mycshr;
 cplot:=@mycplot;
 cmain:=@mycmain;
 inherited Create(AOwner);
end;

procedure Tf_config_time.FormShow(Sender: TObject);
begin
LockChange:=true;
ShowTime;
LockChange:=false;
end;

procedure Tf_config_time.ShowTime;
var h,n,s:string;
    y,m,d,i,j:integer;
begin
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
tz.value:=csc.timezone;
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
  SimObj.checked[i]:=csc.SimObject[j];
end;
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
tz.enabled:=d_year.enabled;
ShowTime;
end;

procedure Tf_config_time.Button2Click(Sender: TObject);
begin
  if assigned(FApplyConfig) then FApplyConfig(Self);
end;

procedure Tf_config_time.CheckBox2Click(Sender: TObject);
begin
csc.AutoRefresh:=checkbox2.checked;
end;

procedure Tf_config_time.FormCreate(Sender: TObject);
begin
  LockChange:=true;
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
csc.curday:=d_day.value;
csc.DT_UT:=DTminusUT(csc.curyear,csc);
Tdt_Ut.caption:=inttostr(round(csc.DT_UT*3600));
dt_ut.text:=Tdt_Ut.caption;
end;


procedure Tf_config_time.TimeChange(Sender: TObject);
begin
if LockChange then exit;
csc.curtime:=t_hour.value+t_min.value/60+t_sec.value/3600;
end;

procedure Tf_config_time.BitBtn4Click(Sender: TObject);
var y,m,d,h,n,s,ms : word;
begin
 ADBC.itemindex:=0;
 decodedate(now,y,m,d);
 decodeTime(now,h,n,s,ms);
 d_year.value:=y;
 d_month.value:=m;
 d_day.value:=d;
 t_hour.value:=h;
 t_min.value:=n;
 t_sec.value:=s;
 tz.value:=GetTimezone;
 TimeChange(Sender);
end;

procedure Tf_config_time.tzChange(Sender: TObject);
begin
if LockChange then exit;
with sender as Tfloatedit do begin
  csc.obstz:=value;
end;
// same value in Time and Observatory panel
if tz<>nil then tz.value:=csc.obstz;
//if timez<>nil then timez.value:=csc.obstz;
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

procedure Tf_config_time.SimObjClickCheck(Sender: TObject);
var i,j:integer;
begin
for i:=0 to SimObj.Items.Count-1 do begin
  case i of
  0 : j:=10;   // sun
  3 : j:=11;   // moon
  10: j:=12;   // asteroid
  11: j:=13;   // comet
  else j:=i;
  end;
  csc.SimObject[j]:=SimObj.checked[i];
end;
end;

procedure Tf_config_time.AllSimClick(Sender: TObject);
var i:integer;
begin
for i:=0 to SimObj.Items.Count-1 do
    SimObj.checked[i]:=true;
SimObjClickCheck(Sender);
end;

procedure Tf_config_time.NoSimClick(Sender: TObject);
var i:integer;
begin
for i:=0 to SimObj.Items.Count-1 do
    SimObj.checked[i]:=false;
SimObjClickCheck(Sender);
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
