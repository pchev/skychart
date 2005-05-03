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
ShowTime;
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
  if i=0 then j:=10         // sun
  else if i=3 then j:=11    // moon
  else if i=10 then j:=12   // ast
  else if i=11 then j:=13   // com
  else j:=i;
  SimObj.checked[i]:=csc.SimObject[j];
end;
end;

procedure Tf_config_time.CheckBox1Click(Sender: TObject);
begin
csc.UseSystemTime:=checkbox1.checked;
SetCurrentTime(csc^);
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

procedure Tf_config_time.CheckBox2Click(Sender: TObject);
begin
csc.AutoRefresh:=checkbox2.checked;
end;

procedure Tf_config_time.LongEdit2Change(Sender: TObject);
begin
cmain.AutoRefreshDelay:=longedit2.value;
end;

{$ifdef mswindows}
procedure Tf_config_time.DateChange(Sender: TObject);
{$endif}
{$ifdef linux}
procedure Tf_config_time.DateChange(Sender: TObject; NewValue: Integer);
{$endif}
begin
// do not use NewValue for VCL compatibility
if adbc.itemindex=0 then
  csc.curyear:=d_year.value
else
  csc.curyear:=1-d_year.value;
csc.curmonth:=d_month.value;
csc.curday:=d_day.value;
csc.DT_UT:=DTminusUT(csc.curyear,csc^);
Tdt_Ut.caption:=inttostr(round(csc.DT_UT*3600));
dt_ut.text:=Tdt_Ut.caption;
end;

{$ifdef linux}
procedure Tf_config_time.DateChange2(Sender: TObject);
begin
DateChange(Sender,0);
end;
{$endif}

{$ifdef mswindows}
procedure Tf_config_time.TimeChange(Sender: TObject);
{$endif}
{$ifdef linux}
procedure Tf_config_time.TimeChange(Sender: TObject; NewValue: Integer);
{$endif}
begin
// do not use NewValue for VCL compatibility
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
end;

procedure Tf_config_time.tzChange(Sender: TObject);
begin
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
csc.DT_UT:=DTminusUT(csc.curyear,csc^);
Tdt_Ut.caption:=inttostr(round(csc.DT_UT*3600));
dt_ut.text:=Tdt_Ut.caption;
end;

procedure Tf_config_time.dt_utChange(Sender: TObject);
begin
csc.DT_UT_val:=dt_ut.value/3600;
csc.DT_UT:=csc.DT_UT_val;
Tdt_ut.caption:=dt_ut.text;
end;

procedure Tf_config_time.SimObjClickCheck(Sender: TObject);
var i,j:integer;
begin
for i:=0 to SimObj.Items.Count-1 do begin
  if i=0 then j:=10         // sun
  else if i=3 then j:=11    // moon
  else if i=10 then j:=12   // ast
  else if i=11 then j:=13   // com
  else j:=i;
  csc.SimObject[j]:=SimObj.checked[i];
end;
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
stepsize.value:=1;
stepunit.ItemIndex:=0;
end;

{$ifdef mswindows}
procedure Tf_config_time.nbstepChanged(Sender: TObject);
{$endif}
{$ifdef linux}
procedure Tf_config_time.nbstepChanged(Sender: TObject; NewValue: Integer);
{$endif}
begin
csc.Simnb:=nbstep.value;
end;

{$ifdef mswindows}
procedure Tf_config_time.stepsizeChanged(Sender: TObject);
{$endif}
{$ifdef linux}
procedure Tf_config_time.stepsizeChanged(Sender: TObject; NewValue: Integer);
{$endif}
begin
stepunitClick(Sender);
end;

