unit cu_tz;

{ Time Zone processing component.
  Based on FreePascal RTL rtl/unix/timezone.inc

  Copyright (C) 2007 Patrick Chevalley  pch@freesurf.ch

  This library is free software; you can redistribute it and/or modify it
  under the terms of the GNU Library General Public License as published by
  the Free Software Foundation; either version 2 of the License, or (at your
  option) any later version with the following modification:

  As a special exception, the copyright holders of this library give you
  permission to link this library with independent modules to produce an
  executable, regardless of the license terms of these independent modules,and
  to copy and distribute the resulting executable under terms of your choice,
  provided that you also meet, for each linked independent module, the terms
  and conditions of the license of that module. An independent module is a
  module which is not derived from or based on this library. If you modify
  this library, you may extend this exception to your version of the library,
  but you are not obligated to do so. If you do not wish to do so, delete this
  exception statement from your version.

  This program is distributed in the hope that it will be useful, but WITHOUT
  ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
  FITNESS FOR A PARTICULAR PURPOSE. See the GNU Library General Public License
  for more details.

  You should have received a copy of the GNU Library General Public License
  along with this library; if not, write to the Free Software Foundation,
  Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
}


{$mode objfpc}{$H+}

interface

uses
  {$ifdef win32}
    Windows,
  {$endif}
  {$ifdef unix}
    unixutil,
  {$endif}
  Classes, SysUtils, Math;
  
type
  ttzhead=packed record
    tzh_reserved : array[0..19] of byte;
    tzh_ttisgmtcnt,
    tzh_ttisstdcnt,
    tzh_leapcnt,
    tzh_timecnt,
    tzh_typecnt,
    tzh_charcnt  : longint;
  end;

  pttinfo=^tttinfo;
  tttinfo=packed record
    offset : longint;
    isdst  : boolean;
    idx    : byte;
    isstd  : byte;
    isgmt  : byte;
  end;

  pleap=^tleap;
  tleap=record
    transition : longint;
    change     : longint;
  end;
  
  TCdCTimeZone = class(TObject)
     private
      fTZDaylight:boolean;
      fTZSeconds:longint;
      fTZName: array[boolean] of pchar;
      fTimer:longint;
      fTimeZoneFile: string;
      fZoneTabCnty: TStringList;
      fZoneTabCoord: TStringList;
      fZoneTabZone: TStringList;
      fZoneTabComment: TStringList;
      num_transitions,
      num_leaps,
      num_types    : longint;
      transitions  : plongint;
      type_idxs    : pbyte;
      types        : pttinfo;
      zone_names   : pchar;
      leaps        : pleap;
      procedure GetLocalTimezone(timer:longint;var leap_correct,leap_hit:longint);
      procedure GetLocalTimezone(timer:longint);
      function find_transition(timer:longint):pttinfo;
      procedure ReadTimezoneFile(fn:shortstring);
      function GetTZName: string;
      procedure SetDate(value: TDateTime);
      function GetDate:TDateTime ;
      procedure SetJD(value: double);
      function GetJD:double ;
      procedure SetTimeZoneFile(value: string);
      function GetTimeZoneFile:string ;
      function GetNowLocalTime: TDateTime;
      function GetNowUTC: TDateTime;
     public
      constructor Create;
      destructor  Destroy; override;
      procedure Assign(Source: TCdCTimeZone);
      function LoadZoneTab(fn: string):boolean;
      function UTC2Local(t: TDateTime):TDateTime;
      function UTC2Local(t: double):double; // jd
      function Local2UTC(t: TDateTime):TDateTime;
      function Local2UTC(t: double):double; // jd
      property TimeZoneFile: string read GetTimeZoneFile write SetTimeZoneFile;
      property Date: TDateTime read GetDate write SetDate;
      property JD: double read GetJD write SetJD;
      property SecondsOffset :longint read fTZSeconds;
      property ZoneName : string read GetTZName;
      property Daylight:boolean read fTZDaylight;
      property ZoneTabCnty: TStringList read fZoneTabCnty;
      property ZoneTabCoord: TStringList read fZoneTabCoord;
      property ZoneTabZone: TStringList read fZoneTabZone;
      property ZoneTabComment: TStringList read fZoneTabComment;
      property NowLocalTime: TDateTime read GetNowLocalTime;
      property NowUTC: TDateTime read GetNowUTC;
     end;

const
     secday=24*3600;
     JDUnixDelta=2440587.5;  // 1.1.1970 0h
     minJD=2415750;// 1.1.1902 risk of 32bit unixtime underflow
     minYear=1904;   // next leap year after underflow
     maxJD=2465424;// 1.1.2038 risk of 32bit unixtime overflow
     maxYear=2036;   // last leap year before overflow
     minDate=732;    // 1.1.1902 risk of 32bit unixtime underflow
     maxDate=50406;  // 1.1.2038 risk of 32bit unixtime overflow

implementation

function Cjd(annee,mois,jour :INTEGER; Heure:double):double;
var u,u0,u1,u2 : double;
	gregorian : boolean;
begin
if annee*10000+mois*100+jour >= 15821015 then gregorian:=true else gregorian:=false;
u:=annee;
if mois<3 then u:=u-1;
u0:=u+4712;
u1:=mois+1;
if u1<4 then u1:=u1+12;
result:=floor(u0*365.25)+floor(30.6*u1+0.000001)+jour+heure/24-63.5;
if gregorian then begin
   u2:=floor(abs(u)/100)-floor(abs(u)/400);
   if u<0 then u2:=-u2;
   result:=result-u2+2;
   if (u<0)and((u/100)=floor(u/100))and((u/400)<>floor(u/400)) then result:=result-1;
end;
end;

PROCEDURE Djd(jd:Double;VAR annee,mois,jour:INTEGER; VAR Heure:double);
var u0,u1,u2,u3,u4 : double;
	gregorian : boolean;
begin
u0:=jd+0.5;
if int(u0)>=2299161 then gregorian:=true else gregorian:=false;
u0:=jd+32082.5;
if gregorian then begin
   u1:=u0+floor(u0/36525)-floor(u0/146100)-38;
   if jd>=1830691.5 then u1:=u1+1;
   u0:=u0+floor(u1/36525)-floor(u1/146100)-38;
end;
u2:=floor(u0+123);
u3:=floor((u2-122.2)/365.25);
u4:=floor((u2-floor(365.25*u3))/30.6001);
mois:=round(u4-1);
if mois>12 then mois:=mois-12;
jour:=round(u2-floor(365.25*u3)-floor(30.6001*u4));
annee:=round(u3+floor((u4-2)/12)-4800);
heure:=(jd-floor(jd+0.5)+0.5)*24;
end;

procedure SplitRec(buf,sep:string; var arg: TStringList);
var i,l:integer;
begin
arg.clear;
l:=length(sep);
while pos(sep,buf)<>0 do begin
 for i:=1 to length(buf) do begin
  if copy(buf,i,l) = sep then begin
      arg.add(copy(buf,1,i-1));
      delete(buf,1,i-1+l);
      break;
  end;
 end;
end;
arg.add(buf);
end;

constructor TCdCTimeZone.Create;
begin
  inherited Create;
  fZoneTabCnty:=TStringList.Create;
  fZoneTabCoord:=TStringList.Create;
  fZoneTabZone:=TStringList.Create;
  fZoneTabComment:=TStringList.Create;
  fTimeZoneFile:='';
  ReadTimezoneFile(GetTimezoneFile);
  GetLocalTimezone(round((now-UnixDateDelta)*24*3600));
end;

destructor  TCdCTimeZone.Destroy;
begin
  if assigned(transitions) then
   freemem(transitions);
  if assigned(type_idxs) then
   freemem(type_idxs);
  if assigned(types) then
   freemem(types);
  if assigned(zone_names) then
   freemem(zone_names);
  if assigned(leaps) then
   freemem(leaps);
  num_transitions:=0;
  num_leaps:=0;
  num_types:=0;
  fZoneTabCnty.Free;
  fZoneTabCoord.Free;
  fZoneTabZone.Free;
  fZoneTabComment.Free;
  inherited Destroy;
end;

procedure TCdCTimeZone.Assign(Source: TCdCTimeZone);
var i: integer;
begin
TimeZoneFile:=Source.TimeZoneFile;
JD:=Source.JD;
fZoneTabCnty.Clear;
for i:=0 to Source.ZoneTabCnty.Count-1 do
   fZoneTabCnty.Add(Source.ZoneTabCnty[i]);
fZoneTabCoord.Clear;
for i:=0 to Source.ZoneTabCoord.Count-1 do
   fZoneTabCoord.Add(Source.ZoneTabCoord[i]);
fZoneTabZone.Clear;
for i:=0 to Source.ZoneTabZone.Count-1 do
   fZoneTabZone.Add(Source.ZoneTabZone[i]);
fZoneTabComment.Clear;
for i:=0 to Source.ZoneTabComment.Count-1 do
   fZoneTabComment.Add(Source.ZoneTabComment[i]);
end;

function TCdCTimeZone.find_transition(timer:longint):pttinfo;
var
  i : longint;
begin
  if (num_transitions=0) or (timer<transitions[0]) then
   begin
     i:=0;
     while (i<num_types) and (types[i].isdst) do
      inc(i);
     if (i=num_types) then
      i:=0;
   end
  else
   begin
     for i:=1 to num_transitions do
      if (timer<transitions[i]) then
       break;
     i:=type_idxs[i-1];
   end;
  find_transition:=@types[i];
end;

procedure TCdCTimeZone.GetLocalTimezone(timer:longint;var leap_correct,leap_hit:longint);
var
  info : pttinfo;
  i    : longint;
begin
{ reset }
  fTZDaylight:=false;
  fTZSeconds:=0;
  fTZName[false]:=nil;
  fTZName[true]:=nil;
  leap_correct:=0;
  leap_hit:=0;
  fTimer:=timer;
{ get info }
  info:=find_transition(timer);
  if not assigned(info) then
   exit;
  fTZDaylight:=info^.isdst;
  fTZSeconds:=info^.offset;
  i:=0;
  while (i<num_types) do
   begin
     ftzname[types[i].isdst]:=@zone_names[types[i].idx];
     inc(i);
   end;
  ftzname[info^.isdst]:=@zone_names[info^.idx];
  i:=num_leaps;
  repeat
    if i=0 then
     exit;
    dec(i);
  until (timer>leaps[i].transition);
  leap_correct:=leaps[i].change;
  if (timer=leaps[i].transition) and
     (((i=0) and (leaps[i].change>0)) or
      (leaps[i].change>leaps[i-1].change)) then
   begin
     leap_hit:=1;
     while (i>0) and
           (leaps[i].transition=leaps[i-1].transition+1) and
           (leaps[i].change=leaps[i-1].change+1) do
      begin
        inc(leap_hit);
        dec(i);
      end;
   end;
end;

procedure TCdCTimeZone.GetLocalTimezone(timer:longint);
var
  lc,lh : longint;
begin
  GetLocalTimezone(timer,lc,lh);
end;

procedure TCdCTimeZone.ReadTimezoneFile(fn:shortstring);

  procedure decode(var l:longint);
  var
    k : longint;
    p : pbyte;
  begin
    p:=pbyte(@l);
    if (p[0] and (1 shl 7))<>0 then
     k:=not 0
    else
     k:=0;
    k:=(k shl 8) or p[0];
    k:=(k shl 8) or p[1];
    k:=(k shl 8) or p[2];
    k:=(k shl 8) or p[3];
    l:=k;
  end;

const
  bufsize = 2048;
var
  buf    : array[0..bufsize-1] of byte;
  bufptr : pbyte;
  f      : file;
  count : longint;

  procedure readfilebuf;
  begin
    bufptr := @buf[0];
    blockread(f, buf, bufsize, count);
  end;

  function readbufbyte: byte;
  begin
    if bufptr > @buf[bufsize-1] then
      readfilebuf;
    readbufbyte := bufptr^;
    inc(bufptr);
  end;

  function readbuf(var dest; count: integer): integer;
  var
    numbytes: integer;
  begin
    readbuf := 0;
    repeat
      numbytes := @buf[bufsize-1] - bufptr + 1;
      if numbytes > count then
        numbytes := count;
      if numbytes > 0 then
      begin
        move(bufptr^, dest, numbytes);
        inc(bufptr, numbytes);
        dec(count, numbytes);
        inc(readbuf, numbytes);
      end;
      if count > 0 then
        readfilebuf
      else
        break;
    until false;
  end;

var
  tzhead : ttzhead;
  i      : longint;
  chars  : longint;
begin
if fn='' then fn:='localtime';
if FileExists(fn) and ((FileGetAttr(fn) and faDirectory)=0) then begin
  Filemode:=0;
  system.assign(f,fn);
  reset(f,1);
  bufptr := @buf[bufsize-1]+1;
  i:=readbuf(tzhead,sizeof(tzhead));
  if i<>sizeof(tzhead) then
   exit;
  decode(tzhead.tzh_timecnt);
  decode(tzhead.tzh_typecnt);
  decode(tzhead.tzh_charcnt);
  decode(tzhead.tzh_leapcnt);
  decode(tzhead.tzh_ttisstdcnt);
  decode(tzhead.tzh_ttisgmtcnt);

  num_transitions:=tzhead.tzh_timecnt;
  num_types:=tzhead.tzh_typecnt;
  chars:=tzhead.tzh_charcnt;

  reallocmem(transitions,num_transitions*sizeof(longint));
  reallocmem(type_idxs,num_transitions);
  reallocmem(types,num_types*sizeof(tttinfo));
  reallocmem(zone_names,chars);
  reallocmem(leaps,num_leaps*sizeof(tleap));

  readbuf(transitions^,num_transitions*4);
  readbuf(type_idxs^,num_transitions);

  for i:=0 to num_transitions-1 do
   decode(transitions[i]);

  for i:=0 to num_types-1 do
   begin
     readbuf(types[i].offset,4);
     readbuf(types[i].isdst,1);
     readbuf(types[i].idx,1);
     decode(types[i].offset);
     types[i].isstd:=0;
     types[i].isgmt:=0;
   end;

  readbuf(zone_names^,chars);

  for i:=0 to num_leaps-1 do
   begin
     readbuf(leaps[i].transition,4);
     readbuf(leaps[i].change,4);
     decode(leaps[i].transition);
     decode(leaps[i].change);
   end;

  for i:=0 to tzhead.tzh_ttisstdcnt-1 do
   types[i].isstd:=byte(readbufbyte<>0);

  for i:=0 to tzhead.tzh_ttisgmtcnt-1 do
   types[i].isgmt:=byte(readbufbyte<>0);

  closefile(f);
end;
end;

function TCdCTimeZone.GetTZName: string;
begin
result:=string(fTZName[fTZDaylight]);
end;

procedure TCdCTimeZone.SetDate(value: TDateTime);
var Year, Month, Day: word;
    timer:longint;
begin
if value<minDate then begin
   decodedate(value,Year, Month, Day);
   Year:=minYear;
   value:=encodedate(Year, Month, Day);
end;
if value>maxDate then begin
   decodedate(value,Year, Month, Day);
   Year:=maxYear;
   value:=encodedate(Year, Month, Day);
end;
timer:=round((value-UnixDateDelta)*secday);
if timer<>fTimer then
   GetLocalTimezone(timer);
end;

function TCdCTimeZone.GetDate:TDateTime ;
begin
result:=(fTimer/secday)+UnixDateDelta;
end;

procedure TCdCTimeZone.SetJD(value: double);
var Year, Month, Day: integer;
    Hour: double;
    timer:longint;
begin
if value<minJD then begin
   djd(value,Year, Month, Day, Hour);
   Year:=minYear;
   value:=cjd(Year, Month, Day, Hour);
end;
if value>maxJD then begin
   djd(value,Year, Month, Day, Hour);
   Year:=maxYear;
   value:=cjd(Year, Month, Day, Hour);
end;
timer:=round((value-JDUnixDelta)*secday);
if timer<>fTimer then
   GetLocalTimezone(timer);
end;

function TCdCTimeZone.GetJD:double ;
begin
result:=(fTimer/secday)+JDUnixDelta;
end;

procedure TCdCTimeZone.SetTimeZoneFile(value: string);
begin
if (value<>fTimeZoneFile) and fileexists(value) and ((FileGetAttr(value) and faDirectory)=0) then begin
  fTimeZoneFile:=value;
  ReadTimezoneFile(fTimezoneFile);
  GetLocalTimezone(fTimer);
end;
end;

function TCdCTimeZone.GetTimeZoneFile:string ;
begin
result:=fTimeZoneFile;
end;

function TCdCTimeZone.UTC2Local(t: TDateTime):TDateTime;
begin
  SetDate(t);
  result:=t+fTZSeconds/secday;
end;

function TCdCTimeZone.UTC2Local(t: double):double;
begin
  SetJD(t);
  result:=t+fTZSeconds/secday;
end;

function TCdCTimeZone.Local2UTC(t: TDateTime):TDateTime;
begin
  SetDate(t);
  result:=t-fTZSeconds/secday;
end;

function TCdCTimeZone.Local2UTC(t: double):double;
begin
  SetJD(t);
  result:=t-fTZSeconds/secday;
end;

function TCdCTimeZone.LoadZoneTab(fn: string):boolean;
var f: textfile;
    buf: string;
    rec: TStringList;
    i: integer;
const tzgmt: array[1..25] of string=('Etc/GMT-12','Etc/GMT-11','Etc/GMT-10','Etc/GMT-9','Etc/GMT-8','Etc/GMT-7','Etc/GMT-6','Etc/GMT-5','Etc/GMT-4','Etc/GMT-3','Etc/GMT-2','Etc/GMT-1','Etc/GMT','Etc/GMT+1','Etc/GMT+2','Etc/GMT+3','Etc/GMT+4','Etc/GMT+5','Etc/GMT+6','Etc/GMT+7','Etc/GMT+8','Etc/GMT+9','Etc/GMT+10','Etc/GMT+11','Etc/GMT+12');
begin
if fileexists(fn) then begin
  fZoneTabCnty.Clear;
  fZoneTabCoord.Clear;
  fZoneTabZone.Clear;
  fZoneTabComment.Clear;
  rec:=TStringList.Create;
  Filemode:=0;
  system.assign(f,fn);
  reset(f);
  repeat
    readln(f,buf);
    buf:=trim(buf);
    if buf='' then continue;
    if buf[1]='#' then continue;
    SplitRec(buf,#9,rec);
    if rec.Count<3 then continue;
    fZoneTabCnty.Add(rec[0]);
    fZoneTabCoord.Add(rec[1]);
    fZoneTabZone.Add(rec[2]);
    if rec.Count>3 then fZoneTabComment.Add(rec[3])
                   else fZoneTabComment.Add('');
  until eof(f);
  closefile(f);
  for i:=1 to 25 do begin
    fZoneTabCnty.Add('ZZ');
    fZoneTabCoord.Add('');
    fZoneTabZone.Add(tzgmt[i]);
    fZoneTabComment.Add('');
  end;
  result:=fZoneTabCnty.Count>0;
  rec.Free;
end
else
  result:=false;
end;

function TCdCTimeZone.GetNowUTC: TDateTime;
var
  st : TSystemTime;
begin
{$ifdef win32}
 GetSystemTime(st);
 result:=SystemTimeToDateTime(st);
{$endif}
{$ifdef unix}
  GetLocalTime(st);
  result:=SystemTimeToDateTime(st)-(TzSeconds/secday);
{$endif}
end;

function TCdCTimeZone.GetNowLocalTime: TDateTime;
begin
result:=UTC2Local(GetNowUTC);
end;

end.

