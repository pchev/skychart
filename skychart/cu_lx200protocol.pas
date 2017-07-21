unit cu_lx200protocol;

{$MODE Delphi}

{
Copyright (C) 2000 Patrick Chevalley

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

{------------- interface for LX200 system. ----------------------------
Contribution from :
PJ Pallez Nov 1999
Patrick Chevalley Oct 2000
Renato Bonomini Jul 2004
Lazarus version, Patrick Chevalley Jun 2011
Tomas Mandys Apr 2013
Add Tcp/Ip protocol, Patrick Chevalley Aug 2014
-------------------------------------------------------------------------------}

interface

uses
  Dialogs, SysUtils, Classes, Forms, StrUtils, synaser, blcksock;

{Communication functions}
function LX200_Read(var buf: string; var Count: integer): boolean;
function LX200_ReadTerm(var buf: string): boolean;
function LX200_Write(var buf: string; var Count: integer): boolean;
procedure LX200_PurgeBuffer;
{basic LX200 functions}
function LX200_Open(model, commport, baud, parity, Data, stop, timeout, inttimeout: string)
  : boolean; overload;
function LX200_Open(model, ipaddr, port, timeout: string): boolean; overload;
function LX200_Close: boolean;
function LX200_QueryEQ(var RA, Dec: double): boolean;
function LX200_QueryAZ(var Az, Al: double): boolean;
function LX200_Slew: boolean;
function LX200_Goto(RA, Dec: double): boolean;
function LX200_Sync: boolean;
function LX200_SyncPos(RA, Dec: double): boolean;
function LX200_SetObs(Lat, Long, TIZ: double; datenow: Tdatetime): boolean;
function LX200_SetSpeed(speed: integer): boolean;
function LX200_Move(direction: integer): boolean;
function LX200_StopDir(direction: integer): boolean;
function LX200_StopMove: boolean;
procedure LX200_SetFormat(format: integer);
function LX200_SwitchHighPrecision: string;
function LX200_QueryHighPrecision: string;
function LX200_SetFocusSteep(speed: char): boolean;
function LX200_StartFocus(dir: char): boolean;
function LX200_StopFocus: boolean;
function LX200_Parkscope: boolean;
// Renato Bonomini:
procedure LX200_SimpleCmd(cmd: string);
function LX200_QueryGV(query: string): string;
function LX200_QueryFirmwareID: string;
function LX200_QueryProductID: string;
function LX200_QueryFirmwareTime: string;
function LX200_QueryFirmwareDate: string;
function LX200_QueryFirmwareNumber: string;
procedure LX200_PecToggle;
procedure LX200_FieldRotationOn;
procedure LX200_FieldRotationOff;
function LX200_GetTrackingRate: single;
function LX200_SetTrackingRateS(arcsec: single): boolean;
function LX200_SetTrackingRateT(arcsec: single): boolean;
procedure LX200_TrackingDefaultRate;
procedure LX200_TrackingCustomRate;
procedure LX200_TrackingLunarRate;
procedure LX200_TrackingIncreaseRate;
procedure LX200_TrackingDecreaseRate;
procedure LX200_FanOn;
procedure LX200_FanOff;
procedure LX200_SlewSpeed(speed: integer);
procedure LX200_GPS_SetGuideRate(rate: single);
procedure LX200_GPS_RASlewRate(rate: single);
procedure LX200_GPS_DECSlewRate(rate: single);
// :$QA+ Enable Dec/Alt PEC [LX200gps only]
// :$QA- Enable Dec/Alt PEC [LX200gps only]
// :$QZ+ Enable RA/AZ PEC compensation [LX200gps only]
// :$QZ- Disable RA/AZ PEC Compensation [LX200gpgs only]
procedure LX200_GPS_EnableDecPec;
procedure LX200_GPS_EnableRAPec;
procedure LX200_GPS_DisableDecPec;
procedure LX200_GPS_DisableRAPec;

// Scope.exe custom commands:
function LX200_Scope_HpLm: boolean;
function LX200_Scope_HpRm: boolean;
function LX200_Scope_Hp_Mode(smode: char): boolean;
function LX200_Scope_GetGuideArcSec: integer;
function LX200_Scope_GetMsArcSec: integer;
procedure LX200_Scope_SetGuideArcSec(arcsec: integer);
procedure LX200_Scope_SetMsArcSec(arcsec: integer);
function LX200_Scope_GetFRAngle: single;

function DEToStr(de: double; var d, m, s: string): string;
function ARToStr(ar: double; var d, m, s: string): string;
function DEmToStr(de: double; var d, m: string): string;
function ARmToStr(ar: double; var d, m: string): string;

type
  Tlx200connection = (serial, tcpip);

const
  ValidPort = 'COM1 COM2 COM3 COM4 COM5 COM6 COM7 COM8';
  ValidModel: array[1..5] of
    string = ('LX200', 'AutoStar', 'Magellan-II', 'Magellan-I', 'Scope.exe');
  NumModel = 5;
  crlf = chr(13) + chr(10);

var
  {system flags and statuses}
  port_type: Tlx200connection;
  port_opened: boolean;            // Interface is opened
  initialised: boolean;                // Last Init operation was successful
  LX200_model: string;               // actual model
  LX200_type: integer = 0;          // kind of protocol to use
  LX200_mode: string;                // alignement mode
  LX200_format: integer;             // 0 : short , 1 : long
  LX200_opened, LX200_UseHPP: boolean;

const
  north = 0;
  south = 1;
  east = 2;
  west = 3;

implementation

uses cu_serial;

var
  LX200_port: TBlockSerial;       // COM port synaser
  LX200_Sock: TTCPBlockSocket;    // Tcp/Ip socket


function PadZeros(x: string; l: integer): string;
const
  zero = '000000000000';
var
  p: integer;
begin
  x := trim(x);
  p := l - length(x);
  Result := copy(zero, 1, p) + x;
end;

function sgn(x: double): double;
begin
  if x < 0 then
    sgn := -1
  else
    sgn := 1;
end;

function DEToStr(de: double; var d, m, s: string): string;
var
  dd, min1, min, sec: double;
begin
  dd := Int(de);
  min1 := abs(de - dd) * 60;
  if min1 >= 59.99 then
  begin
    dd := dd + sgn(de);
    min1 := 0.0;
  end;
  min := Int(min1);
  sec := (min1 - min) * 60;
  if sec >= 59.5 then
  begin
    min := min + 1;
    sec := 0.0;
  end;
  str(abs(dd): 2: 0, d);
  if abs(dd) < 10 then
    d := '0' + trim(d);
  if de < 0 then
    d := '-' + d
  else
    d := '+' + d;
  str(min: 2: 0, m);
  if abs(min) < 10 then
    m := '0' + trim(m);
  str(sec: 2: 0, s);
  if abs(sec) < 9.5 then
    s := '0' + trim(s);
  Result := d + '°' + m + chr(39) + s + '"';
end;

function ARToStr(ar: double; var d, m, s: string): string;
var
  dd, min1, min, sec: double;
begin
  dd := Int(ar);
  min1 := abs(ar - dd) * 60;
  if min1 >= 59.999 then
  begin
    dd := dd + sgn(ar);
    min1 := 0.0;
  end;
  min := Int(min1);
  sec := (min1 - min) * 60;
  if sec >= 59.95 then
  begin
    min := min + 1;
    sec := 0.0;
  end;
  str(dd: 2: 0, d);
  if abs(dd) < 10 then
    d := '0' + trim(d);
  str(min: 2: 0, m);
  if abs(min) < 10 then
    m := '0' + trim(m);
  str(sec: 2: 0, s);
  if abs(sec) < 9.95 then
    s := '0' + trim(s);
  Result := d + 'h' + m + 'm' + s + 's';
end;

function DEmToStr(de: double; var d, m: string): string;
var
  dd, min: double;
begin
  dd := Int(de);
  min := abs(de - dd) * 60;
  if min >= 59.5 then
  begin
    dd := dd + sgn(de);
    min := 0.0;
  end;
  min := Round(min);
  str(abs(dd): 2: 0, d);
  if abs(dd) < 10 then
    d := '0' + trim(d);
  if de < 0 then
    d := '-' + d
  else
    d := '+' + d;
  str(min: 2: 0, m);
  if abs(min) < 10 then
    m := '0' + trim(m);
  Result := d + '°' + m + chr(39);
end;

function ARmToStr(ar: double; var d, m: string): string;
var
  dd, min: double;
begin
  dd := Int(ar);
  min := abs(ar - dd) * 60;
  if min >= 59.5 then
  begin
    dd := dd + sgn(ar);
    min := 0.0;
  end;
  //    min:=Round(min);
  str(dd: 2: 0, d);
  if abs(dd) < 10 then
    d := '0' + trim(d);
  str(min: 4: 1, m);
  if length(trim(m)) < 4 then
    m := '0' + trim(m);
  Result := d + 'h' + m + 'm';
end;

function LonToStr(lon: double; var d, m: string): string;
var
  dd, min: double;
begin
  lon := abs(lon); // 0..360
  dd := Int(lon);
  min := abs(lon - dd) * 60;
  if min >= 59.5 then
  begin
    dd := dd + sgn(lon);
    min := 0.0;
  end;
  min := Round(min);
  str(abs(dd): 2: 0, d);
  if abs(dd) < 10 then
    d := '0' + trim(d);
  str(min: 2: 0, m);
  if abs(min) < 10 then
    m := '0' + trim(m);
  Result := d + '°' + m + chr(39);
end;

function LX200_Read(var buf: string; var Count: integer): boolean;
begin
  case port_type of
    serial: Result := ReadCom(LX200_port, buf, Count);
    tcpip: Result := ReadTcpip(LX200_Sock, buf, Count);
    else
      Result := False;
  end;
end;

function LX200_ReadTerm(var buf: string): boolean;
begin
  case port_type of
    serial: Result := ReadComTerm(LX200_port, buf);
    tcpip: Result := ReadTcpipTerm(LX200_Sock, buf);
    else
      Result := False;
  end;
end;

function LX200_Write(var buf: string; var Count: integer): boolean;
begin
  case port_type of
    serial: Result := WriteCom(LX200_port, buf, Count);
    tcpip: Result := WriteTcpip(LX200_Sock, buf, Count);
    else
      Result := False;
  end;
end;

procedure LX200_PurgeBuffer;
begin
  case port_type of
    serial: PurgeBuffer(LX200_port);
    tcpip: PurgeBufferTcpip(LX200_Sock);
  end;
end;

//  LX-200 uses 9600 N 8 1
function LX200_Open(model, commport, baud, parity, Data, stop, timeout, inttimeout: string)
: boolean;
var
  i, typ, Count: integer;
  buf: string;
begin
  Result := False;
  port_type := serial;
  typ := 0;
  for i := 1 to NumModel do
    if (pos(Model, ValidModel[i]) > 0) then
      typ := i;
  if typ = 0 then
  begin
    ShowMessage('Unsupported mount model : ' + model);
    exit;
  end;
  if port_opened then
    LX200_Close;
  if OpenCom(LX200_port, commport, baud, parity, Data, stop, timeout, inttimeout) then
  begin
    port_opened := True;
    LX200_model := model;
    LX200_type := typ;
    LX200_PurgeBuffer;
    // check scope connected
    case LX200_type of
      5, 1..2:
      begin  // get DEC (change for FS2 with no ACK nor GC)
        buf := '#:GD#';
        Count := length(buf);
        if LX200_Write(buf, Count) = False then
          exit;
        if LX200_ReadTerm(buf) = False then
          exit;
        if length(buf) < 6 then
          exit;
        buf := 'P';
        LX200_mode := buf;
        LX200_opened := True;
        Result := True;
      end;
      3..4:
      begin  // get date  for Magellan
        buf := '#:GC#';
        Count := length(buf);
        if LX200_Write(buf, Count) = False then
          exit;
        if LX200_ReadTerm(buf) = False then
          exit;
        if length(buf) < 9 then
          exit;
        LX200_mode := 'P';
        LX200_opened := True;
        Result := True;
      end;
    end;
  end
  else
  begin
    ShowMessage('Port ' + commport + ' cannot be opened!' + crlf + lx200_port.LastErrorDesc);
    LX200_opened := False;
  end;
end;

function LX200_Open(model, ipaddr, port, timeout: string): boolean;
var
  i, typ, Count: integer;
  buf: string;
begin
  Result := False;
  port_type := tcpip;
  typ := 0;
  for i := 1 to NumModel do
    if (pos(Model, ValidModel[i]) > 0) then
      typ := i;
  if typ = 0 then
  begin
    ShowMessage('Unsupported mount model : ' + model);
    exit;
  end;
  if port_opened then
    LX200_Close;
  if OpenTcpip(LX200_Sock, ipaddr, port, timeout) then
  begin
    port_opened := True;
    LX200_model := model;
    LX200_type := typ;
    LX200_PurgeBuffer;
    // check scope connected
    case LX200_type of
      5, 1..2:
      begin  // get DEC (change for FS2 with no ACK nor GC)
        buf := '#:GD#';
        Count := length(buf);
        if LX200_Write(buf, Count) = False then
          exit;
        if LX200_ReadTerm(buf) = False then
          exit;
        if length(buf) < 6 then
          exit;
        buf := 'P';
        LX200_mode := buf;
        LX200_opened := True;
        Result := True;
      end;
      3..4:
      begin  // get date  for Magellan
        buf := '#:GC#';
        Count := length(buf);
        if LX200_Write(buf, Count) = False then
          exit;
        if LX200_ReadTerm(buf) = False then
          exit;
        if length(buf) < 9 then
          exit;
        LX200_mode := 'P';
        LX200_opened := True;
        Result := True;
      end;
    end;
  end
  else
  begin
    ShowMessage('Port ' + ipaddr + ':' + port + ' cannot be opened!' + crlf +
      LX200_Sock.LastErrorDesc);
    LX200_opened := False;
  end;
end;

procedure LX200_SetFormat(format: integer);
var
  Count, f: integer;
  buf: string;
begin
  // Get format
  buf := '#:GD#';
  Count := length(buf);
  if LX200_Write(buf, Count) = False then
    exit;
  if LX200_ReadTerm(buf) = False then
    exit;
  if length(trim(buf)) > 7 then
    f := 1
  else
    f := 0;
  if f <> format then
  begin
    buf := '#:U#';          // switch format
    Count := length(buf);
    if LX200_Write(buf, Count) = False then
      exit;
  end;
  LX200_format := format;
end;

function LX200_Close: boolean;
begin
  case port_type of
    serial: CloseCom(LX200_port);
    tcpip: CloseTcpip(LX200_Sock);
  end;
  port_opened := False;
  LX200_opened := False;
  LX200_model := '';
  LX200_mode := '';
  LX200_type := 0;
  Result := True;
end;

function LX200_QueryEQ(var RA, Dec: double): boolean;
var
  buf, buf2: string;
  a, b, c: double;
  Count, p, i: integer;
begin
  Result := False;
  case LX200_type of
    2:
    begin       // Autostar, some model have problem to respond to the double command
      buf := '#:GR#';
      Count := length(buf);
      LX200_PurgeBuffer;
      if LX200_Write(buf, Count) = False then
        exit;
      if LX200_ReadTerm(buf) = False then
        exit;
      case LX200_format of
        0:
        begin
          //1234567890123456
          //+HH:MM.M#
          //03:21.7#
          i := pos(':', buf);
          val(copy(buf, 1, i - 1), a, p);
          if p > 0 then
            exit;
          buf := copy(buf, i + 1, 999);
          i := pos('#', buf);
          val(copy(buf, 1, i - 1), b, p);
          if p > 0 then
            exit;
          RA := 15 * (a + b / 60);
        end;
        1:
        begin
          //1234567890123456
          //06:07:58#
          i := pos(':', buf);
          val(copy(buf, 1, i - 1), a, p);
          if p > 0 then
            exit;
          buf := copy(buf, i + 1, 999);
          i := pos(':', buf);
          val(copy(buf, 1, i - 1), b, p);
          if p > 0 then
            exit;
          buf := copy(buf, i + 1, 999);
          i := pos('#', buf);
          val(copy(buf, 1, i - 1), c, p);
          if p > 0 then
            exit;
          RA := 15 * (a + b / 60 + c / 3600);
        end;
      end;
      buf := '#:GD#';
      Count := length(buf);
      LX200_PurgeBuffer;
      if LX200_Write(buf, Count) = False then
        exit;
      if LX200_ReadTerm(buf) = False then
        exit;
      case LX200_format of
        0:
        begin
          //1234567890123456
          //-DD*MM#
          //+30ß02#
          val(copy(buf, 2, 2), a, p);
          if p > 0 then
            exit;
          val(copy(buf, 5, 2), b, p);
          if p > 0 then
            exit;
          Dec := a + b / 60;
          if copy(buf, 1, 1) = '-' then
            Dec := -Dec;
        end;
        1:
        begin
          //1234567890123456
          //+19ß46:02d#
          val(copy(buf, 2, 2), a, p);
          if p > 0 then
            exit;
          val(copy(buf, 5, 2), b, p);
          if p > 0 then
            exit;
          val(copy(buf, 8, 2), c, p);
          if p > 0 then
            exit;
          Dec := a + b / 60 + c / 3600;
          if copy(buf, 1, 1) = '-' then
            Dec := -Dec;
        end;
      end;
    end;
    else
    begin          // LX200, Magellan
      buf := '#:GR#:GD#';
      Count := length(buf);
      LX200_PurgeBuffer;
      if LX200_Write(buf, Count) = False then
        exit;
      if LX200_ReadTerm(buf) = False then
        exit;
      if LX200_ReadTerm(buf2) = False then
        exit;
      buf := buf + '#' + buf2;
      case LX200_format of
        0:
        begin
          //1234567890123456
          //+HH:MM.M#-DD*MM#
          //03:21.7#+30ß02#
          i := pos(':', buf);
          val(copy(buf, 1, i - 1), a, p);
          if p > 0 then
            exit;
          buf := copy(buf, i + 1, 999);
          i := pos('#', buf);
          val(copy(buf, 1, i - 1), b, p);
          if p > 0 then
            exit;
          RA := 15 * (a + b / 60);
          buf := copy(buf, i + 1, 999);
          val(copy(buf, 2, 2), a, p);
          if p > 0 then
            exit;
          val(copy(buf, 5, 2), b, p);
          if p > 0 then
            exit;
          Dec := a + b / 60;
          if copy(buf, 1, 1) = '-' then
            Dec := -Dec;
        end;
        1:
        begin
          //1234567890123456
          //06:07:58#+19ß46:02d#
          i := pos(':', buf);
          val(copy(buf, 1, i - 1), a, p);
          if p > 0 then
            exit;
          buf := copy(buf, i + 1, 999);
          i := pos(':', buf);
          val(copy(buf, 1, i - 1), b, p);
          if p > 0 then
            exit;
          buf := copy(buf, i + 1, 999);
          i := pos('#', buf);
          val(copy(buf, 1, i - 1), c, p);
          if p > 0 then
            exit;
          RA := 15 * (a + b / 60 + c / 3600);
          buf := copy(buf, i + 1, 999);
          val(copy(buf, 2, 2), a, p);
          if p > 0 then
            exit;
          val(copy(buf, 5, 2), b, p);
          if p > 0 then
            exit;
          val(copy(buf, 8, 2), c, p);
          if p > 0 then
            exit;
          Dec := a + b / 60 + c / 3600;
          if copy(buf, 1, 1) = '-' then
            Dec := -Dec;
        end;
      end;
    end;
  end;
  Result := True;
end;

function LX200_QueryAZ(var Az, Al: double): boolean;
var
  buf, buf2: string;
  a, b, c: double;
  Count, p: integer;
begin
  Result := False;
  case LX200_type of
    2:
    begin       // Autostar, some model have problem to respond to the double command
      buf := '#:GZ#';
      Count := length(buf);
      LX200_PurgeBuffer;
      if LX200_Write(buf, Count) = False then
        exit;
      if LX200_ReadTerm(buf) = False then
        exit;
      case LX200_format of
        0:
        begin
          //1234567890123456
          //DDD*MM#
          val(copy(buf, 1, 3), a, p);
          if p > 0 then
            exit;
          val(copy(buf, 5, 2), b, p);
          if p > 0 then
            exit;
          Az := a + b / 60;
        end;
        1:
        begin
          //1234567890123456789
          //311ß52:05#
          val(copy(buf, 1, 3), a, p);
          if p > 0 then
            exit;
          val(copy(buf, 5, 2), b, p);
          if p > 0 then
            exit;
          val(copy(buf, 8, 2), c, p);
          if p > 0 then
            exit;
          Az := a + b / 60 + c / 3600;
        end;
      end;
      buf := '#:GA#';
      Count := length(buf);
      LX200_PurgeBuffer;
      if LX200_Write(buf, Count) = False then
        exit;
      if LX200_ReadTerm(buf) = False then
        exit;
      case LX200_format of
        0:
        begin
          //1234567890123456
          //-DD*MM#
          val(copy(buf, 2, 2), a, p);
          if p > 0 then
            exit;
          val(copy(buf, 5, 2), b, p);
          if p > 0 then
            exit;
          Al := a + b / 60;
          if copy(buf, 1, 1) = '-' then
            Al := -Al;
        end;
        1:
        begin
          //1234567890123456789
          //+19ß46:10#
          val(copy(buf, 2, 2), a, p);
          if p > 0 then
            exit;
          val(copy(buf, 5, 2), b, p);
          if p > 0 then
            exit;
          val(copy(buf, 8, 2), c, p);
          if p > 0 then
            exit;
          Al := a + b / 60 + c / 3600;
          if copy(buf, 1, 1) = '-' then
            Al := -Al;
        end;
      end;
    end;
    else
    begin          // LX200, Magellan, scope
      buf := '#:GZ#:GA#';
      Count := length(buf);
      LX200_PurgeBuffer;
      if LX200_Write(buf, Count) = False then
        exit;
      if LX200_ReadTerm(buf) = False then
        exit;
      if LX200_ReadTerm(buf2) = False then
        exit;
      buf := buf + '#' + buf2;
      case LX200_format of
        0:
        begin
          //1234567890123456
          //DDD*MM#-DD*MM#
          val(copy(buf, 1, 3), a, p);
          if p > 0 then
            exit;
          val(copy(buf, 5, 2), b, p);
          if p > 0 then
            exit;
          Az := a + b / 60;
          val(copy(buf, 9, 2), a, p);
          if p > 0 then
            exit;
          val(copy(buf, 12, 2), b, p);
          if p > 0 then
            exit;
          Al := a + b / 60;
          if copy(buf, 8, 1) = '-' then
            Al := -Al;
        end;
        1:
        begin
          //1234567890123456789
          //311ß52:05#+19ß46:10#
          val(copy(buf, 1, 3), a, p);
          if p > 0 then
            exit;
          val(copy(buf, 5, 2), b, p);
          if p > 0 then
            exit;
          val(copy(buf, 8, 2), c, p);
          if p > 0 then
            exit;
          Az := a + b / 60 + c / 3600;
          val(copy(buf, 12, 2), a, p);
          if p > 0 then
            exit;
          val(copy(buf, 15, 2), b, p);
          if p > 0 then
            exit;
          val(copy(buf, 18, 2), c, p);
          if p > 0 then
            exit;
          Al := a + b / 60 + c / 3600;
          if copy(buf, 11, 1) = '-' then
            Al := -Al;
        end;
      end;
    end;
  end;
  Result := True;
end;

function LX200_Pos(var RA, Dec: double): boolean;
var
  buf, s1, s2, s3: string;
  Count: integer;
begin
  Result := False;
  RA := RA / 15;
  case LX200_type of
    2:
    begin       // Autostar, some model have problem to respond to the double command
      case LX200_format of
        0:
        begin
          armtostr(ra, s1, s2);
          buf := '#:Sr' + s1 + ':' + s2 + '#';
          Count := length(buf);
          LX200_PurgeBuffer;
          if LX200_Write(buf, Count) = False then
            exit;
          Count := 20;
          if LX200_Read(buf, Count) = False then
            exit;
          if trim(buf) = '0' then
            exit;
          demtostr(Dec, s1, s2);
          buf := '#:Sd' + s1 + '*' + s2 + '#';
          Count := length(buf);
          LX200_PurgeBuffer;
          if LX200_Write(buf, Count) = False then
            exit;
          Count := 20;
          if LX200_Read(buf, Count) = False then
            exit;
          if trim(buf) = '0' then
            exit;
        end;
        1:
        begin
          artostr(ra, s1, s2, s3);
          buf := '#:Sr' + s1 + ':' + s2 + ':' + s3 + '#';
          Count := length(buf);
          LX200_PurgeBuffer;
          if LX200_Write(buf, Count) = False then
            exit;
          Count := 20;
          if LX200_Read(buf, Count) = False then
            exit;
          if trim(buf) = '0' then
            exit;
          detostr(Dec, s1, s2, s3);
          buf := '#:Sd' + s1 + '*' + s2 + ':' + s3 + '#';
          Count := length(buf);
          LX200_PurgeBuffer;
          if LX200_Write(buf, Count) = False then
            exit;
          Count := 20;
          if LX200_Read(buf, Count) = False then
            exit;
          if trim(buf) = '0' then
            exit;
        end;
      end;
    end;
    else
    begin          // LX200, Magellan
      case LX200_format of
        0:
        begin
          armtostr(ra, s1, s2);
          buf := '#:Sr' + s1 + ':' + s2;
          demtostr(Dec, s1, s2);
          buf := buf + '#:Sd' + s1 + '*' + s2 + '#';
          Count := length(buf);
          LX200_PurgeBuffer;
          if LX200_Write(buf, Count) = False then
            exit;
          Count := 20;
          LX200_Read(buf, Count);
          if trim(buf) = '00' then
            exit;
        end;
        1:
        begin
          artostr(ra, s1, s2, s3);
          buf := '#:Sr' + s1 + ':' + s2 + ':' + s3;
          detostr(Dec, s1, s2, s3);
          buf := buf + '#:Sd' + s1 + '*' + s2 + ':' + s3 + '#';
          Count := length(buf);
          LX200_PurgeBuffer;
          if LX200_Write(buf, Count) = False then
            exit;
          Count := 20;
          if LX200_Read(buf, Count) = False then
            exit;
          if trim(buf) = '00' then
            exit;
        end;
      end;
    end;
  end;
  Result := True;
end;

function LX200_Slew: boolean;
var
  buf: string;
  Count: integer;
begin
  Result := False;
  LX200_PurgeBuffer;
  // slew to current object
  buf := '#:MS#';
  Count := length(buf);
  if LX200_Write(buf, Count) = False then
    exit;
  Count := 50;
  if LX200_Read(buf, Count) = False then
    exit;
  Result := True;
end;

function LX200_Goto(RA, Dec: double): boolean;
begin
  Result := False;
  // set object position
  if not LX200_Pos(RA, Dec) then
    exit;
  // slew to object
  if not LX200_Slew then
    exit;
  Result := True;
end;

function LX200_Sync: boolean;
var
  buf: string;
  Count: integer;
begin
  Result := False;
  LX200_PurgeBuffer;
  buf := '#:CM#';
  Count := length(buf);
  if LX200_Write(buf, Count) = False then
    exit;
  Count := 50;
  if LX200_Read(buf, Count) = False then
    exit;
  Result := True;
end;

function LX200_SyncPos(RA, Dec: double): boolean;
begin
  Result := False;
  LX200_PurgeBuffer;
  // set object position
  if not LX200_Pos(RA, Dec) then
    exit;
  // sync object
  if not LX200_Sync then
    exit;
  Result := True;
end;


function LX200_SetSpeed(speed: integer): boolean;
var
  Count: integer;
  buf: string;
begin
  Result := False;
  LX200_PurgeBuffer;
  case LX200_type of
    5, 1:
    begin // LX200 + scope.exe
      buf := '#:R';
      case speed of
        0: buf := buf + 'S#';
        1: buf := buf + 'M#';
        2: buf := buf + 'C#';
        3: buf := buf + 'G#';
        else
          exit;
      end;
    end;
    2:
    begin // Autostar
      case speed of
        0: buf := '#:Sw4#';
        1: buf := '#:Sw3#';
        2: buf := '#:Sw2#';
        3: buf := '#:Sw2#';
        else
          exit;
      end;
    end;
    else
      buf := '';
  end;
  Count := length(buf);
  if LX200_Write(buf, Count) = False then
    exit;
  Result := True;
end;

function LX200_Move(direction: integer): boolean;
var
  Count: integer;
  buf: string;
begin
  Result := False;
  LX200_PurgeBuffer;
  buf := '#:M';
  case direction of
    north: buf := buf + 'n#';
    south: buf := buf + 's#';
    east: buf := buf + 'e#';
    west: buf := buf + 'w#';
    else
      exit;
  end;
  Count := length(buf);
  if LX200_Write(buf, Count) = False then
    exit;
  Result := True;
end;

function LX200_StopDir(direction: integer): boolean;
var
  Count: integer;
  buf: string;
begin
  Result := False;
  LX200_PurgeBuffer;
  case LX200_type of
    5, 1:
    begin // LX200
      buf := '#:Q';
      case direction of
        north: buf := buf + 'n#';
        south: buf := buf + 's#';
        east: buf := buf + 'e#';
        west: buf := buf + 'w#';
        else
          buf := buf + '#';
      end;
    end;
    2:
    begin // Autostar
      buf := '#:Q#';
    end;
    else
      buf := '';
  end;
  Count := length(buf);
  if LX200_Write(buf, Count) = False then
    exit;
  Result := True;
end;

function LX200_StopMove: boolean;
var
  Count: integer;
  buf: string;
begin
  Result := False;
  buf := '#:Q#:Qn#:Qs#:Qe#:Qw#';
  Count := length(buf);
  if LX200_Write(buf, Count) = False then
    exit;
  Result := True;
end;

function LX200_QueryHighPrecision: string;
var
  buf: string;
  i, Count: integer;
begin
  Result := 'Error';
  LX200_PurgeBuffer;
  for i := 1 to 2 do
  begin
    buf := '#:P#';
    Count := length(buf);
    if LX200_Write(buf, Count) = False then
      exit;
    Count := 50;
    if LX200_Read(buf, Count) = False then
      exit;
  end;
  // buf:='HIGH PRECISION  ';
  Result := trim(buf);
  LX200_UseHPP := Result = 'HIGH PRECISION';
end;

function LX200_SwitchHighPrecision: string;
var
  buf: string;
  Count: integer;
begin
  Result := 'Error';
  LX200_PurgeBuffer;
  buf := '#:P#';
  Count := length(buf);
  if LX200_Write(buf, Count) = False then
    exit;
  Count := 50;
  if LX200_Read(buf, Count) = False then
    exit;
  Result := trim(buf);
  LX200_UseHPP := Result = 'HIGH PRECISION';
end;

function LX200_QueryGV(query: string): string;
var
  Count: integer;
begin
  // Renato Bonomini:
  Result := 'Error';
  LX200_PurgeBuffer;
  Count := length(query);
  if LX200_Write(query, Count) = False then
    exit;
  if LX200_ReadTerm(query) = False then
    exit;
  Result := trim(query);
end;

function LX200_QueryFirmwareID: string;
begin
  Result := LX200_QueryGV(':GVF#');
end;

function LX200_QueryProductID: string;
begin
  Result := LX200_QueryGV(':GVP#');
end;

function LX200_QueryFirmwareDate: string;
begin
  // Renato Bonomini:
  // GVD Get Telescope Firmware Date
  Result := LX200_QueryGV(':GVD#');
end;

function LX200_QueryFirmwareNumber: string;
begin
  // Renato Bonomini:
  // GVD Get Telescope Firmware Number
  Result := LX200_QueryGV(':GVN#');
end;

function LX200_QueryFirmwareTime: string;
begin
  // Renato Bonomini:
  // GVD Get Telescope Firmware Time
  Result := LX200_QueryGV(':GVT#');
end;

function LX200_SetFocusSteep(speed: char): boolean;
var
  Count: integer;
  buf: string;
begin
  // standard lx200 :      speed = (F,S)
  // lx200gps, autostar :  speed = (1,2,3,4)
  buf := '#:F' + speed + '#';
  Count := length(buf);
  Result := LX200_Write(buf, Count);
end;

function LX200_StartFocus(dir: char): boolean;
var
  Count: integer;
  buf: string;
begin
  // dir = (+,-)
  buf := '#:F' + dir + '#';
  Count := length(buf);
  Result := LX200_Write(buf, Count);
end;

function LX200_StopFocus: boolean;
var
  Count: integer;
  buf: string;
begin
  buf := '#:FQ#';
  Count := length(buf);
  Result := LX200_Write(buf, Count);
end;

function LX200_SetObs(Lat, Long, TIZ: double; datenow: Tdatetime): boolean;
var
  Count: integer;
  cms, s1, s2, buf, dt, tm, tz, site, saved, savet: string;
begin
  saved := DefaultFormatSettings.ShortDateFormat;
  savet := DefaultFormatSettings.ShortTimeFormat;
  try
    Result := False;
    LX200_PurgeBuffer;

    // Set Latitude
    demtostr(Lat, s1, s2);
    cms := '#:St' + s1 + '*' + s2 + '#';
    Count := length(cms);
    if LX200_Write(cms, Count) then
    begin
      Count := 1;
      LX200_Read(buf, Count);
    end;

    // Set Longitude
    lontostr(Long, s1, s2);
    cms := '#:Sg' + s1 + '*' + s2 + '#';
    Count := length(cms);
    if LX200_Write(cms, Count) then
    begin
      Count := 1;
      LX200_Read(buf, Count);
    end;

    // Set Timezone
    s1 := FormatFloat('0.0', TIZ);
    if TIZ >= 0 then
      s1 := '+' + s1;
    cms := '#:SG' + s1 + '#';
    Count := length(cms);
    if LX200_Write(cms, Count) then
    begin
      Count := 1;
      LX200_Read(buf, Count);
    end;

    //Set Time
    DefaultFormatSettings.ShortTimeFormat := 'hh:mm:ss';
    cms := '#:SL' + TimeToStr(datenow) + '#';
    DefaultFormatSettings.ShortTimeFormat := savet;
    Count := length(cms);
    if LX200_Write(cms, Count) then
    begin
      Count := 1;
      LX200_Read(buf, Count);
    end;

    //Set Date
    DefaultFormatSettings.ShortDateFormat := 'mm/dd/yy';
    cms := '#:SC' + DateToStr(datenow) + '#';
    DefaultFormatSettings.ShortDateFormat := saved;
    Count := length(cms);
    if LX200_Write(cms, Count) then
    begin
      Count := 1;
      LX200_Read(buf, Count);
      if (Count = 1) then
      begin
        // read planetary update response
        LX200_ReadTerm(buf);
        LX200_ReadTerm(buf);
      end;
    end;

    //Clean buffer
    sleep(100);
    LX200_PurgeBuffer;

    //Get from scope: site, date and time
    cms := '#:Gt#';
    Count := length(cms);
    buf := '?';
    if LX200_Write(cms, Count) then
      LX200_ReadTerm(buf);
    site := buf;
    if site = '' then
    begin
      if LX200_Write(cms, Count) then
        LX200_ReadTerm(buf);
      site := buf;
    end;
    cms := '#:Gg#';
    Count := length(cms);
    buf := '?';
    LX200_PurgeBuffer;
    if LX200_Write(cms, Count) then
      LX200_ReadTerm(buf);
    site := site + '/' + buf;
    site := StringReplace(site, chr(223), '*', [rfReplaceAll]);

    cms := '#:GC#';
    Count := length(cms);
    dt := '?';
    LX200_PurgeBuffer;
    if LX200_Write(cms, Count) then
      LX200_ReadTerm(dt);

    cms := '#:GL#';
    Count := length(cms);
    tm := '?';
    LX200_PurgeBuffer;
    if LX200_Write(cms, Count) then
      LX200_ReadTerm(tm);

    cms := '#:GG#';
    Count := length(cms);
    tz := '?';
    LX200_PurgeBuffer;
    if LX200_Write(cms, Count) then
      LX200_ReadTerm(tz);

    Result := True;
    ShowMessage('Telescope setting is now:' + crlf + 'Site: ' + site +
      crlf + 'Date: ' + dt + crlf + 'Time: ' + tm + crlf + 'Time zone: ' + tz + '.');
  finally
    DefaultFormatSettings.ShortDateFormat := saved;
    DefaultFormatSettings.ShortTimeFormat := savet;
  end;
end;

function LX200_Parkscope: boolean;
var
  buf: string;
  Count: integer;
begin
  Result := False;
  buf := '#:hP#';
  Count := length(buf);
  if LX200_Write(buf, Count) = False then
    exit;
  Result := True;
end;

procedure LX200_SimpleCmd(cmd: string);
// Renato Bonomini:
// Executes simple commands
var
  Count: integer;
begin
  LX200_PurgeBuffer;
  Count := length(cmd);
  if LX200_Write(cmd, Count) = False then
    exit;
end;

procedure LX200_PecToggle;
// Toggles Pec condition on both drives
begin
  LX200_SimpleCmd(':$Q#');
end;

procedure LX200_FieldRotationOn;
// Turns field rotation on
begin
  LX200_SimpleCmd(':r+#');
end;

procedure LX200_FieldRotationOff;
// Turns field rotation off
begin
  LX200_SimpleCmd(':r-#');
end;

function LX200_SetTrackingRateS(arcsec: single): boolean;
var
  buf: string;
  arcsecstr: string;
  Count: integer;
begin
  Result := False;
  LX200_PurgeBuffer;
  // :SDDD.D# format
  arcsecstr := PadZeros(Format('%4.1f', [arcsec]), 5);
  buf := '#:S' + arcsecstr + '#';
  Count := length(buf);
  if LX200_Write(buf, Count) = False then
    exit;
  // Read response 1 or 0
  Count := 1;
  if LX200_Read(buf, Count) = False then
    exit;
  if buf = '1' then
    Result := True;
end;

function LX200_SetTrackingRateT(arcsec: single): boolean;
var
  buf: string;
  arcsecstr: string;
  Count: integer;
begin
  Result := False;
  LX200_PurgeBuffer;
  // :TDDD.DDD# format
  arcsecstr := PadZeros(Format('%6.3f', [arcsec]), 7);
  buf := '#:T' + arcsecstr + '#';
  Count := length(buf);
  if LX200_Write(buf, Count) = False then
    exit;
  // Read response 1 or 0
  Count := 1;
  if LX200_Read(buf, Count) = False then
    exit;
  if buf = '1' then
    Result := True;
end;

function LX200_GetTrackingRate: single;
var
  buf: string;
  Count: integer;
begin
  Result := -1;
  LX200_PurgeBuffer;
  buf := ':GT#';
  Count := length(buf);
  if LX200_Write(buf, Count) = False then
    exit;
  if LX200_ReadTerm(buf) = False then
    exit;
  Result := StrToFloat(LeftStr(trim(buf), 4));
end;

procedure LX200_TrackingDefaultRate;
// Sets default tracking rate, 60Hz
begin
  LX200_SimpleCmd(':TQ#');
end;

procedure LX200_TrackingCustomRate;
// Sets custom tracking rate
begin
  LX200_SimpleCmd(':TM#');
end;

procedure LX200_TrackingLunarRate;
// Sets selenic tracking rate
begin
  LX200_SimpleCmd(':TL#');
end;

procedure LX200_TrackingIncreaseRate;
// increase tracking rate 1Hz
begin
  LX200_SimpleCmd(':T+#');
end;

procedure LX200_TrackingDecreaseRate;
// decrease tracking rate 1Hz
begin
  LX200_SimpleCmd(':T-#');
end;

procedure LX200_FanOn;
// Turns Fan On (16" Only)
begin
  LX200_SimpleCmd(':f+#');
end;

procedure LX200_FanOff;
// Turns Fan Off (16" Only)
begin
  LX200_SimpleCmd(':f-#');
end;

procedure LX200_SlewSpeed(speed: integer);
// Sends Sw1 .. Sw4 to change slew speed
begin
  LX200_SimpleCmd(':Sw' + IntToStr(speed) + '#');
end;

procedure LX200_GPS_SetGuideRate(rate: single);
// Set Guide rate on LX200GPS
// :RgSS.S# format
var
  buf: string;
  arcsecstr: string;
  Count: integer;
begin
  LX200_PurgeBuffer;
  arcsecstr := PadZeros(Format('%3.1f', [rate]), 4);
  buf := '#:Rg' + arcsecstr + '#';
  Count := length(buf);
  if LX200_Write(buf, Count) = False then
    exit;
end;

procedure LX200_GPS_RASlewRate(rate: single);
// Set RA Slew rate on LX200GPS
// :RADD.D# format
var
  buf: string;
  arcsecstr: string;
  Count: integer;
begin
  LX200_PurgeBuffer;
  arcsecstr := PadZeros(Format('%3.1f', [rate]), 4);
  buf := '#:RA' + arcsecstr + '#';
  Count := length(buf);
  if LX200_Write(buf, Count) = False then
    exit;
end;

procedure LX200_GPS_DECSlewRate(rate: single);
// Set DEC Slew rate on LX200GPS
// :REDD.D# format
var
  buf: string;
  arcsecstr: string;
  Count: integer;
begin
  LX200_PurgeBuffer;
  arcsecstr := PadZeros(Format('%3.1f', [rate]), 4);
  buf := '#:RE' + arcsecstr + '#';
  Count := length(buf);
  if LX200_Write(buf, Count) = False then
    exit;
end;

procedure LX200_GPS_EnableDecPec;
// :$QA+ Enable Dec/Alt PEC [LX200gps only]
begin
  LX200_SimpleCmd(':$QA+#');
end;

procedure LX200_GPS_EnableRAPec;
// :$QZ+ Enable RA/AZ PEC compensation [LX200gps only]
begin
  LX200_SimpleCmd(':$QZ+#');
end;

procedure LX200_GPS_DisableDecPec;
// :$QA- Disable Dec/Alt PEC [LX200gps only]
begin
  LX200_SimpleCmd(':$QA-#');
end;

procedure LX200_GPS_DisableRAPec;
// :$QZ- Disable RA/AZ PEC Compensation [LX200gpgs only]
begin
  LX200_SimpleCmd(':$QZ-#');
end;


///////////////////////////////////////////////
// Scope.exe custom lx-200 protocol commands //
///////////////////////////////////////////////

function LX200_Scope_HpRm: boolean;
  // Renato Bonomini:
  // Simulates Right mode
var
  Count: integer;
  buf: string;
begin
  LX200_PurgeBuffer;
  buf := '#:XHR#';
  Count := length(buf);
  Result := LX200_Write(buf, Count);
end;

function LX200_Scope_HpLm: boolean;
  // Renato Bonomini:
  // Simulates Left mode
var
  Count: integer;
  buf: string;
begin
  LX200_PurgeBuffer;
  buf := '#:XHL#';
  Count := length(buf);
  Result := LX200_Write(buf, Count);
end;

function LX200_Scope_Hp_Mode(smode: char): boolean;
  // Renato Bonomini:
  // Simulates selected mode
var
  Count: integer;
  buf: string;
begin
  LX200_PurgeBuffer;
  buf := '#:XH' + smode + '#';
  Count := length(buf);
  Result := LX200_Write(buf, Count);
end;

function LX200_Scope_GetMsArcSec: integer;
  // Renato Bonomini:
  // XGM Get MsArcSec
var
  buf: string;
  Count: integer;
begin
  Result := -1;
  LX200_PurgeBuffer;
  buf := '#:XGM#';
  Count := length(buf);
  if LX200_Write(buf, Count) = False then
    exit;
  Count := 5;
  if LX200_Read(buf, Count) = False then
    exit;
  Result := StrToIntDef(LeftStr(trim(buf), 4), 0);
end;

function LX200_Scope_GetGuideArcSec: integer;
  // Renato Bonomini:
  // XGG Get GuideArcSec
var
  buf: string;
  Count: integer;
begin
  Result := -1;
  LX200_PurgeBuffer;
  buf := '#:XGG#';
  Count := length(buf);
  if LX200_Write(buf, Count) = False then
    exit;
  Count := 5;
  if LX200_Read(buf, Count) = False then
    exit;
  Result := StrToIntDef(LeftStr(trim(buf), 4), 0);
end;

procedure LX200_Scope_SetGuideArcSec(arcsec: integer);
// Renato Bonomini:
// XSGnnnn set GuideArcSec in nnnn
var
  buf: string;
  arcsecstr: string;
begin
  LX200_PurgeBuffer;
  arcsecstr := PadZeros(IntToStr(arcsec), 4);
  buf := '#:XSG' + arcsecstr + '#';
  LX200_SimpleCmd(buf);
end;

procedure LX200_Scope_SetMsArcSec(arcsec: integer);
// Renato Bonomini:
// XSMnnnn set MsArcSec in nnnn
var
  buf: string;
  arcsecstr: string;
begin
  LX200_PurgeBuffer;
  arcsecstr := PadZeros(IntToStr(arcsec), 4);
  buf := '#:XSM' + arcsecstr + '#';
  LX200_SimpleCmd(buf);
end;

function LX200_Scope_GetFRAngle: single;
  // Renato Bonomini:
  // XGR Get FR angle
var
  buf: string;
  Count: integer;
begin
  Result := -1;
  LX200_PurgeBuffer;
  buf := ':XGR#';
  Count := length(buf);
  if LX200_Write(buf, Count) = False then
    exit;
  Count := 7;
  if LX200_Read(buf, Count) = False then
    exit;
  //ShowMessage(buf);
  Result := StrToFloat(LeftStr(trim(buf), 6));
end;

end.
