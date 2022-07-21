unit cu_tz;

{ Time Zone processing component.
  Based on FreePascal RTL rtl/unix/timezone.inc revision 47339  Nov 8 07:18:49 2020

  Copyright (C) 2007 Patrick Chevalley  pch@ap-i.net

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
  Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
}


{$mode objfpc}{$H+}

interface

uses
  {$ifdef mswindows}
  Windows,
  {$endif}
  {$ifdef unix}
  unixutil,
  {$endif}
  Classes, SysUtils, Math;

type
  ttzhead=packed record
    tzh_identifier : array[0..3] of AnsiChar;
    tzh_version : AnsiChar;
    tzh_reserved : array[0..14] of byte;
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
    transition : int64;
    change     : int64;
  end;

  TTZInfo = record
    daylight     : boolean;
    seconds      : Longint; // difference from UTC
    validsince   : int64;   // UTC timestamp
    validuntil   : int64;   // UTC timestamp
  end;
  TTZInfoEx = record
    name         : array[boolean] of RawByteString; { False = StandardName, True = DaylightName }
    leap_correct : longint;
    leap_hit     : longint;
  end;

  TCdCTimeZone = class(TObject)
  private
    fTZInfo: TTZInfo;
    fTZInfoEx: TTZInfoEx;
    fTimer: Int64;
    fTimeZoneLMT: boolean;
    fTimeZoneFile: string;
    fZoneTabCnty: TStringList;
    fZoneTabCoord: TStringList;
    fZoneTabZone: TStringList;
    fZoneTabComment: TStringList;
    fLongitude: double;
    num_transitions, num_leaps, num_types: longint;
    transitions: PInt64;
    type_idxs: pbyte;
    types: pttinfo;
    zone_names: PChar;
    leaps: pleap;
    procedure DoGetLocalTimezone(info:pttinfo;const trans_start,trans_end:int64;var ATZInfo:TTZInfo);
    procedure DoGetLocalTimezoneEx(timer:int64;info:pttinfo;var ATZInfoEx:TTZInfoEx);
    function GetLocalTimezone(timer:int64;timerIsUTC:Boolean;var ATZInfo:TTZInfo):Boolean;
    function GetLocalTimezone(timer:int64;timerIsUTC:Boolean;var ATZInfo:TTZInfo;var ATZInfoEx:TTZInfoEx):Boolean;
    procedure GetLocalTimezone(timer:int64);
    function find_transition(timer:int64;timerIsUTC:Boolean;var trans_start,trans_end:int64):pttinfo;
    function ReadTimezoneFile(fn: shortstring):boolean;
    function GetTZName: string;
    procedure SetDate(Value: TDateTime);
    function GetDate: TDateTime;
    procedure SetLongitude(Value: double);
    function GetLongitude: double;
    procedure SetJD(Value: double);
    function GetJD: double;
    procedure SetTimeZoneFile(Value: string);
    function GetTimeZoneFile: string;
    function GetNowLocalTime: TDateTime;
    function GetNowUTC: TDateTime;
    function GetTZInfo : TTZInfo;
    function GetTZInfoEx : TTZInfoEx;
    function UTC2Local(t: TDateTime): TDateTime;
    function UTC2Local(t: double): double; // jd
    function Local2UTC(t: TDateTime): TDateTime;
    function Local2UTC(t: double): double; // jd
    function GetSecondOffset: longint;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Assign(Source: TCdCTimeZone);
    function LoadZoneTab(fn: string): boolean;
    property TimeZoneFile: string read GetTimeZoneFile write SetTimeZoneFile;
    property Longitude: double read GetLongitude write SetLongitude;
    property Date: TDateTime read GetDate write SetDate;
    property JD: double read GetJD write SetJD;
    property SecondsOffset: longint read GetSecondOffset;
    property ZoneName: string read GetTZName;
    property Daylight: boolean read fTZInfo.daylight;
    property ZoneTabCnty: TStringList read fZoneTabCnty;
    property ZoneTabCoord: TStringList read fZoneTabCoord;
    property ZoneTabZone: TStringList read fZoneTabZone;
    property ZoneTabComment: TStringList read fZoneTabComment;
    property NowLocalTime: TDateTime read GetNowLocalTime;
    property NowUTC: TDateTime read GetNowUTC;
    property TZInfo : TTZInfo read GetTZInfo;
    property TZInfoEx : TTZInfoEx read GetTZInfoEx;
  end;

const
  JDUnixDelta = 2440587.5;  // 1.1.1970 0h

implementation

constructor TCdCTimeZone.Create;
begin
  inherited Create;
  fZoneTabCnty := TStringList.Create;
  fZoneTabCoord := TStringList.Create;
  fZoneTabZone := TStringList.Create;
  fZoneTabComment := TStringList.Create;
  fTimeZoneFile := '';
  fLongitude:=maxint;
  fTimeZoneLMT:=false;
  ReadTimezoneFile(GetTimezoneFile);
  GetLocalTimezone(round((now - UnixDateDelta) * 24 * 3600),true,fTZInfo,fTZInfoEx);
end;

destructor TCdCTimeZone.Destroy;
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
  num_transitions := 0;
  num_leaps := 0;
  num_types := 0;
  fZoneTabCnty.Free;
  fZoneTabCoord.Free;
  fZoneTabZone.Free;
  fZoneTabComment.Free;
  inherited Destroy;
end;

procedure TCdCTimeZone.Assign(Source: TCdCTimeZone);
var
  i: integer;
begin
  fLongitude:=Source.fLongitude;
  TimeZoneFile := Source.TimeZoneFile;
  JD := Source.JD;
  fZoneTabCnty.Clear;
  for i := 0 to Source.ZoneTabCnty.Count - 1 do
    fZoneTabCnty.Add(Source.ZoneTabCnty[i]);
  fZoneTabCoord.Clear;
  for i := 0 to Source.ZoneTabCoord.Count - 1 do
    fZoneTabCoord.Add(Source.ZoneTabCoord[i]);
  fZoneTabZone.Clear;
  for i := 0 to Source.ZoneTabZone.Count - 1 do
    fZoneTabZone.Add(Source.ZoneTabZone[i]);
  fZoneTabComment.Clear;
  for i := 0 to Source.ZoneTabComment.Count - 1 do
    fZoneTabComment.Add(Source.ZoneTabComment[i]);
end;

function TCdCTimeZone.find_transition(timer:int64;timerIsUTC:Boolean;var trans_start,trans_end:int64):pttinfo;
var
  i,L,R,CompareRes : longint;
  found : boolean;

  function DoCompare: longint;
  var
    timerUTC: int64;
  begin
    if not timerIsUTC then
      timerUTC:=timer-types[type_idxs[i-1]].offset
    else
      timerUTC:=timer;
    if timerUTC<transitions[i-1] then
      Exit(-1)
    else
    if timerUTC>=transitions[i] then
      Exit(1)
    else
      Exit(0);
  end;
begin
  if (num_transitions=0) or (timer<transitions[0]) then
   begin
     i:=0;
     while (i<num_types) and (types[i].isdst) do
      inc(i);
     if (i=num_types) then
      i:=0;
     { unknown transition boundaries }
     trans_start:=low(trans_start);
     trans_end:=high(trans_end);
   end
  else
   begin
      // Use binary search.
      L := 1;
      R := num_transitions-1;
      found := false;
      while not found and (L<=R) do
      begin
        I := L + (R - L) div 2;
        CompareRes := DoCompare;
        if (CompareRes>0) then
          L := I+1
        else begin
          R := I-1;
          if (CompareRes=0) then
             found:=true; // break cycle
        end;
      end;
     if not found then begin
       i:=num_transitions; // use last std transition to not fallback to LMT in the future
     end;
     trans_start:=transitions[i-1];
     trans_end:=transitions[i];
     i:=type_idxs[i-1];
   end;
  find_transition:=@types[i];
end;

procedure TCdCTimeZone.DoGetLocalTimezone(info:pttinfo;const trans_start,trans_end:int64;var ATZInfo:TTZInfo);
begin
  ATZInfo.validsince:=trans_start;
  ATZInfo.validuntil:=trans_end;
  ATZInfo.Daylight:=info^.isdst;
  ATZInfo.Seconds:=info^.offset;
end;

procedure TCdCTimeZone.DoGetLocalTimezoneEx(timer:int64;info:pttinfo;var ATZInfoEx:TTZInfoEx);
var
  i : longint;
  names: array[Boolean] of pchar;
begin
  names[true]:=nil;
  names[false]:=nil;
  ATZInfoEx.leap_hit:=0;
  ATZInfoEx.leap_correct:=0;

  i:=0;
  while (i<num_types) do
   begin
     names[types[i].isdst]:=@zone_names[types[i].idx];
     inc(i);
   end;
  names[info^.isdst]:=@zone_names[info^.idx];
  ATZInfoEx.name[true]:=names[true];
  ATZInfoEx.name[false]:=names[false];
  i:=num_leaps;
  repeat
    if i=0 then
     exit;
    dec(i);
  until (timer>leaps[i].transition);
  ATZInfoEx.leap_correct:=leaps[i].change;
  if (timer=leaps[i].transition) and
     (((i=0) and (leaps[i].change>0)) or
      (leaps[i].change>leaps[i-1].change)) then
   begin
     ATZInfoEx.leap_hit:=1;
     while (i>0) and
           (leaps[i].transition=leaps[i-1].transition+1) and
           (leaps[i].change=leaps[i-1].change+1) do
      begin
        inc(ATZInfoEx.leap_hit);
        dec(i);
      end;
   end;
end;

procedure LockTZInfo;
begin
// not need because one tz object for each chart
(*  {$if declared(UseTZThreading)}
  if UseTZThreading then
    EnterCriticalSection(TZInfoCS);
  {$endif} *)
end;

procedure UnlockTZInfo;
begin
(*  {$if declared(UseTZThreading)}
  if UseTZThreading then
    LeaveCriticalSection(TZInfoCS);
  {$endif} *)
end;

function TCdCTimeZone.GetTZInfo : TTZInfo;
begin
  GetTZInfo:=fTZInfo;
end;

function TCdCTimeZone.GetTZInfoEx : TTZInfoEx;
begin
  GetTZInfoEx:=fTZInfoEx;
end;

function TCdCTimeZone.GetLocalTimezone(timer:int64;timerIsUTC:Boolean;var ATZInfo:TTZInfo):Boolean;
var
  info: pttinfo;
  trans_start,trans_end,timerUTC: int64;
begin
  { check if time is in current global Tzinfo }
  ATZInfo:=fTZInfo;
  if not timerIsUTC then
    timerUTC:=timer-ATZInfo.seconds
  else
    timerUTC:=timer;
  if (ATZInfo.validsince>low(int64)) and (ATZInfo.validsince<=timerUTC) and (timerUTC<ATZInfo.validuntil) then
    Exit(True);

  LockTZInfo;
  info:=find_transition(timer,timerIsUTC,trans_start,trans_end);
  GetLocalTimezone:=assigned(info);
  if GetLocalTimezone then
    DoGetLocalTimezone(info,trans_start,trans_end,ATZInfo);
  UnlockTZInfo;
end;

function TCdCTimeZone.GetLocalTimezone(timer:int64;timerIsUTC:Boolean;var ATZInfo:TTZInfo;var ATZInfoEx:TTZInfoEx):Boolean;
var
  info: pttinfo;
  trans_start,trans_end,timerUTC: int64;
begin
  { check if time is in current global Tzinfo }
  ATZInfo:=fTZInfo;
  if not timerIsUTC then
    timerUTC:=timer-ATZInfo.seconds
  else
    timerUTC:=timer;
  if (ATZInfo.validsince>low(int64)) and (ATZInfo.validsince<=timerUTC) and (timerUTC<ATZInfo.validuntil) then
    begin
    ATZInfoEx:=TZInfoEx;
    Exit(True);
    end;

  { not current - search through all }
  LockTZInfo;
  info:=find_transition(timer,timerIsUTC,trans_start,trans_end);
  GetLocalTimezone:=assigned(info);
  if GetLocalTimezone then
    begin
    DoGetLocalTimezone(info,trans_start,trans_end,ATZInfo);
    DoGetLocalTimezoneEx(timer,info,ATZInfoEx);
    end;
  UnlockTZInfo;
end;

function TCdCTimeZone.ReadTimezoneFile(fn: shortstring):boolean;

function decode(const l:longint):longint;
begin
  {$IFDEF ENDIAN_LITTLE}
  decode:=SwapEndian(l);
  {$ELSE}
  decode:=l;
  {$ENDIF}
end;

function decode(const l:int64):int64;
begin
  {$IFDEF ENDIAN_LITTLE}
  decode:=SwapEndian(l);
  {$ELSE}
  decode:=l;
  {$ENDIF}
end;

const
  bufsize = 2048;
var
  buf    : array[0..bufsize-1] of byte;
  bufptr : pbyte;
  f      : file;
  tzhead : ttzhead;

  procedure readfilebuf;
  var Count: longint;
  begin
    bufptr := @buf[0];
    blockread(f, buf, bufsize, Count);
  end;

  function readbufbyte: byte;
  begin
    if bufptr > @buf[bufsize-1] then
      readfilebuf;
    readbufbyte := bufptr^;
    inc(bufptr);
  end;

  function readbuf(dest:pointer; count: integer): integer;
  var
    numbytes: integer;
  begin
    readbuf := 0;
    repeat
      numbytes := (@buf[bufsize-1] + 1) - bufptr;
      if numbytes > count then
        numbytes := count;
      if numbytes > 0 then
      begin
        if assigned(dest) then
          move(bufptr^, dest^, numbytes);
        inc(bufptr, numbytes);
        dec(count, numbytes);
        inc(readbuf, numbytes);
        inc(dest, numbytes);
      end;
      if count > 0 then
        readfilebuf
      else
        break;
    until false;
  end;

  function readheader: boolean;
  var
    i      : longint;
  begin
    i:=readbuf(@tzhead,sizeof(tzhead));
    if i<>sizeof(tzhead) then
      exit(False);
    tzhead.tzh_timecnt:=decode(tzhead.tzh_timecnt);
    tzhead.tzh_typecnt:=decode(tzhead.tzh_typecnt);
    tzhead.tzh_charcnt:=decode(tzhead.tzh_charcnt);
    tzhead.tzh_leapcnt:=decode(tzhead.tzh_leapcnt);
    tzhead.tzh_ttisstdcnt:=decode(tzhead.tzh_ttisstdcnt);
    tzhead.tzh_ttisgmtcnt:=decode(tzhead.tzh_ttisgmtcnt);
    readheader:=(tzhead.tzh_identifier[0]='T') and (tzhead.tzh_identifier[1]='Z')
      and (tzhead.tzh_identifier[2]='i') and (tzhead.tzh_identifier[3]='f');
  end;

  procedure AllocFields;
  begin
    num_transitions:=tzhead.tzh_timecnt;
    num_types:=tzhead.tzh_typecnt;
    num_leaps:=tzhead.tzh_leapcnt;
    reallocmem(transitions,num_transitions*sizeof(int64));
    reallocmem(type_idxs,num_transitions);
    reallocmem(types,num_types*sizeof(tttinfo));
    reallocmem(zone_names,tzhead.tzh_charcnt);
    reallocmem(leaps,num_leaps*sizeof(tleap));
  end;

  function readdata: boolean;
  var
    i      : longint;
    longval: longint;
    version: longint;
  begin
    if tzhead.tzh_version='2' then
      begin
        version:=2;
        // skip version 0
        readbuf(nil,
           tzhead.tzh_timecnt*4  // transitions
          +tzhead.tzh_timecnt    // type_idxs
          +tzhead.tzh_typecnt*6  // types
          +tzhead.tzh_charcnt    // zone_names
          +tzhead.tzh_leapcnt*8  // leaps
          +tzhead.tzh_ttisstdcnt // isstd
          +tzhead.tzh_ttisgmtcnt // isgmt
          );
        readheader; // read version 2 header
        if tzhead.tzh_version<>'2' then
          Exit(False);
      end
    else
      version:=0;

    AllocFields;

    if version=2 then
      begin // read 64bit values
        readbuf(transitions,num_transitions*sizeof(int64));
        for i:=0 to num_transitions-1 do
          transitions[i]:=decode(transitions[i]);
      end
    else
      begin // read 32bit values
        for i:=0 to num_transitions-1 do
         begin
           readbuf(@longval,sizeof(longval));
           transitions[i]:=decode(longval);
         end;
      end;
    readbuf(type_idxs,num_transitions);

    for i:=0 to num_types-1 do
     begin
       readbuf(@types[i].offset,sizeof(LongInt));
       types[i].offset:=decode(types[i].offset);
       readbuf(@types[i].isdst,1);
       readbuf(@types[i].idx,1);
       types[i].isstd:=0;
       types[i].isgmt:=0;
     end;

    readbuf(zone_names,tzhead.tzh_charcnt);

    if version=2 then
      begin // read 64bit values
        for i:=0 to num_leaps-1 do
         begin
           readbuf(@leaps[i].transition,sizeof(int64));
           readbuf(@leaps[i].change,sizeof(int64));
           leaps[i].transition:=decode(leaps[i].transition);
           leaps[i].change:=decode(leaps[i].change);
         end;
      end
    else
      begin
        for i:=0 to num_leaps-1 do
         begin
           readbuf(@longval,sizeof(longval));
           leaps[i].transition:=decode(longval);
           readbuf(@longval,sizeof(longval));
           leaps[i].change:=decode(longval);
         end;
      end;

    for i:=0 to tzhead.tzh_ttisstdcnt-1 do
     types[i].isstd:=byte(readbufbyte<>0);

    for i:=0 to tzhead.tzh_ttisgmtcnt-1 do
     types[i].isgmt:=byte(readbufbyte<>0);

    readdata:=true;
  end;

begin
  if (fn<>'') and FileExists(fn) and ((FileGetAttr(fn) and faDirectory) = 0) then
  begin
    Filemode := 0;
    system.Assign(f, fn);
    reset(f, 1);
    bufptr := @buf[bufsize-1]+1;
    tzhead:=default(ttzhead);
    LockTZInfo;
    ReadTimezoneFile:=(readheader() and readdata());
    UnlockTZInfo;
    closefile(f);
  end;
end;

procedure TCdCTimeZone.SetLongitude(Value: double);
begin
  fLongitude:=-value;
  fTimeZoneLMT:=(fTZInfoEx.name[fTZInfo.daylight]='LMT')and(fLongitude<maxint);
end;

function TCdCTimeZone.GetLongitude: double;
begin
  result:=-fLongitude;
end;

procedure TCdCTimeZone.GetLocalTimezone(timer:Int64);
begin
  GetLocalTimezone(timer,true,fTZInfo,fTZInfoEx);
  fTimeZoneLMT:=(fTZInfoEx.name[fTZInfo.daylight]='LMT')and(fLongitude<maxint);
  fTimer:=timer;
end;

function TCdCTimeZone.GetSecondOffset: longint;
begin
  if fTimeZoneLMT then
    result:=round(3600*fLongitude/15)
  else
    result:=fTZInfo.seconds;
end;

function TCdCTimeZone.GetTZName: string;
begin
  Result := string(fTZInfoEx.name[fTZInfo.daylight]);
end;

procedure TCdCTimeZone.SetDate(Value: TDateTime);
var
  timer: Int64;
begin
  timer := round((Value - UnixDateDelta) * SecsPerDay);
  if timer <> fTimer then
    GetLocalTimezone(timer);
end;

function TCdCTimeZone.GetDate: TDateTime;
begin
  Result := (fTimer / SecsPerDay) + UnixDateDelta;
end;

procedure TCdCTimeZone.SetJD(Value: double);
var
  timer: Int64;
begin
  timer := round((Value - JDUnixDelta) * SecsPerDay);
  if timer <> fTimer then
    GetLocalTimezone(timer);
end;

function TCdCTimeZone.GetJD: double;
begin
  Result := (fTimer / SecsPerDay) + JDUnixDelta;
end;

procedure TCdCTimeZone.SetTimeZoneFile(Value: string);
begin
  if (Value <> fTimeZoneFile) and fileexists(Value) and
    ((FileGetAttr(Value) and faDirectory) = 0) then
  begin
    fTimeZoneFile := Value;
    ReadTimezoneFile(fTimezoneFile);
    fTZInfo.validsince:=low(int64);
    GetLocalTimezone(fTimer);
  end;
end;

function TCdCTimeZone.GetTimeZoneFile: string;
begin
  Result := fTimeZoneFile;
end;

function TCdCTimeZone.UTC2Local(t: TDateTime): TDateTime;
begin
  SetDate(t);
  Result := t + fTZInfo.seconds / SecsPerDay;
end;

function TCdCTimeZone.UTC2Local(t: double): double;
begin
  SetJD(t);
  Result := t + fTZInfo.seconds / SecsPerDay;
end;

function TCdCTimeZone.Local2UTC(t: TDateTime): TDateTime;
begin
  SetDate(t);
  Result := t - fTZInfo.seconds / SecsPerDay;
end;

function TCdCTimeZone.Local2UTC(t: double): double;
begin
  SetJD(t);
  Result := t - fTZInfo.seconds / SecsPerDay;
end;

function TCdCTimeZone.LoadZoneTab(fn: string): boolean;
var
  f: textfile;
  buf: string;
  rec: TStringList;
  i: integer;
const
  tzgmt: array[1..25] of string =
    ('Etc/GMT-12', 'Etc/GMT-11', 'Etc/GMT-10', 'Etc/GMT-9', 'Etc/GMT-8',
    'Etc/GMT-7', 'Etc/GMT-6', 'Etc/GMT-5', 'Etc/GMT-4', 'Etc/GMT-3', 'Etc/GMT-2',
    'Etc/GMT-1', 'Etc/GMT', 'Etc/GMT+1', 'Etc/GMT+2', 'Etc/GMT+3', 'Etc/GMT+4',
    'Etc/GMT+5', 'Etc/GMT+6', 'Etc/GMT+7', 'Etc/GMT+8', 'Etc/GMT+9', 'Etc/GMT+10',
    'Etc/GMT+11', 'Etc/GMT+12');
  procedure SplitRec(buf, sep: string; var arg: TStringList);
  var
    i, l: integer;
  begin
    arg.Clear;
    l := length(sep);
    while pos(sep, buf) <> 0 do
    begin
      for i := 1 to length(buf) do
      begin
        if copy(buf, i, l) = sep then
        begin
          arg.add(copy(buf, 1, i - 1));
          Delete(buf, 1, i - 1 + l);
          break;
        end;
      end;
    end;
    arg.add(buf);
  end;

begin
  if fileexists(fn) then
  begin
    fZoneTabCnty.Clear;
    fZoneTabCoord.Clear;
    fZoneTabZone.Clear;
    fZoneTabComment.Clear;
    rec := TStringList.Create;
    Filemode := 0;
    system.Assign(f, fn);
    reset(f);
    repeat
      readln(f, buf);
      buf := trim(buf);
      if buf = '' then
        continue;
      if buf[1] = '#' then
        continue;
      SplitRec(buf, #9, rec);
      if rec.Count < 3 then
        continue;
      fZoneTabCnty.Add(rec[0]);
      fZoneTabCoord.Add(rec[1]);
      fZoneTabZone.Add(rec[2]);
      if rec.Count > 3 then
        fZoneTabComment.Add(rec[3])
      else
        fZoneTabComment.Add('');
    until EOF(f);
    closefile(f);
    for i := 1 to 25 do
    begin
      fZoneTabCnty.Add('ZZ');
      fZoneTabCoord.Add('');
      fZoneTabZone.Add(tzgmt[i]);
      fZoneTabComment.Add('');
    end;
    Result := fZoneTabCnty.Count > 0;
    rec.Free;
  end
  else
    Result := False;
end;

function TCdCTimeZone.GetNowUTC: TDateTime;
var
  st: TSystemTime;
begin
{$ifdef mswindows}
  GetSystemTime(st);
  Result := SystemTimeToDateTime(st);
{$endif}
{$ifdef unix}
  GetLocalTime(st);
  Result := SystemTimeToDateTime(st) - (TzSeconds / SecsPerDay);
{$endif}
end;

function TCdCTimeZone.GetNowLocalTime: TDateTime;
begin
  Result := UTC2Local(GetNowUTC);
end;

end.
