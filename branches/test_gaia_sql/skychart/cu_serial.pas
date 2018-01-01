unit cu_serial;

{$MODE Delphi}

{****************************************************************
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
****************************************************************}
{
Patrick Chevalley Oct 2000
Lazarus version, Patrick Chevalley Jun 2011
Tomas Mandys Apr 2013
Add Tcp/Ip protocol, Patrick Chevalley Aug 2014
}

interface

uses
  Forms, synaser, SysUtils, FileUtil, synautil, blcksock, synsock;

function OpenCom(var ser: TBlockSerial;
  CommPort, baud, parity, Data, stop, timeouts, inttimeout: string): boolean;
function ReadCom(var ser: TBlockSerial; var buf: string; var Count: integer): boolean;
function ReadComTerm(var ser: TBlockSerial; var buf: string): boolean;
function WriteCom(var ser: TBlockSerial; var buf: string; var Count: integer): boolean;
procedure PurgeBuffer(var ser: TBlockSerial);
procedure CloseCom(var ser: TBlockSerial);

function OpenTcpip(var Sock: TTCPBlockSocket; ipaddr, port, timeout: string): boolean;
function ReadTcpip(var Sock: TTCPBlockSocket; var buf: string;
  var Count: integer): boolean;
function ReadTcpipTerm(var Sock: TTCPBlockSocket; var buf: string): boolean;
function WriteTcpip(var Sock: TTCPBlockSocket; var buf: string;
  var Count: integer): boolean;
procedure PurgeBufferTcpip(var Sock: TTCPBlockSocket);
procedure CloseTcpip(var Sock: TTCPBlockSocket);

procedure InitSerialDebug(ff: string);
procedure WriteSerialDebug(buf: string);
procedure CloseSerialDebug;

var
  debug: boolean = False;

implementation

var
  Com_opened: boolean = False;
  Tcpip_opened: boolean = False;
  fdebug: textfile;
  debugfile: string;
  Tot_timout, Int_timout, Tcp_timout: integer;

{$NOTES OFF}
procedure CloseSerialDebug;
var
  i: integer;
begin
  try
    debug := False;
{$I-}
    closefile(fdebug);
{$I+}
    // just to cleanup ioresult
    i := ioresult;
  except
  end;
end;

{$NOTES ON}

procedure InitSerialDebug(ff: string);
begin
  debugfile := ExpandFileName(ff);
  assignfile(fdebug, debugfile);
  rewrite(fdebug);
  writeln(fdebug, DateTimeToStr(Now) + '  Start trace');
  closefile(fdebug);
end;

procedure WriteSerialDebug(buf: string);
begin
  try
    assignfile(fdebug, debugfile);
    append(fdebug);
    writeln(fdebug, buf);
    closefile(fdebug);
  except
    CloseSerialDebug;
  end;
end;

function OpenCom(var ser: TBlockSerial;
  CommPort, baud, parity, Data, stop, timeouts, inttimeout: string): boolean;
var
  sb: integer;
begin
  Result := False;
  if debug then
    writeserialdebug(FormatDateTime('hh:mm:ss.zzz', now) + ' Open  : ' +
      CommPort + ' ' + baud + ' ' + parity + ' ' + Data + ' ' + stop + ' ' + timeouts + ' ' + inttimeout);

  if com_opened then
    CloseCom(ser);

  ser := TBlockSerial.Create;
  try
    ser.Connect(CommPort);
    if ser.LastError <> 0 then
      exit;
    sb := 0;
    if stop = '1.5' then
      sb := 1;
    if stop = '2' then
      sb := 2;
    ser.config(StrToInt(baud), StrToInt(Data), char(parity[1]), sb, False, False);
    if ser.LastError <> 0 then
      exit;
    Tot_timout := strtointdef(timeouts, 1000);
    Int_timout := strtointdef(inttimeout, 100);
    com_opened := True;
    Result := True;
    if debug then
      writeserialdebug(FormatDateTime('hh:mm:ss.zzz', now) + ' Open OK');
  finally
  end;
end;

procedure PurgeBuffer(var ser: TBlockSerial);
begin
  if com_opened then
  begin
    if debug then
      writeserialdebug(FormatDateTime('hh:mm:ss.zzz', now) + ' Purge Buffer');
    ser.Purge;
  end;
end;

function ReadCom(var ser: TBlockSerial; var buf: string; var Count: integer): boolean;
var
  n: integer;
var
  Tick: longword;
begin
  buf := '';
  if com_opened then
  begin
    Tick := GetTick();
    repeat
      n := ser.RecvByte(Int_timout);
      if (ser.LastError = 0) then
        buf := buf + char(n)
      else
        break;
    until (length(buf) >= Count) or (GetTick - Tick > Tot_timout) or not com_opened;
    Count := length(buf);
    Result := (ser.LastError = 0) or (ser.LastError = ErrTimeout);
    if debug then
      writeserialdebug(FormatDateTime('hh:mm:ss.zzz', now) + ' Read  : ' +
        IntToStr(Count) + ' *' + buf + '*');
  end
  else
  begin
    Result := False;
  end;
end;

function ReadComTerm(var ser: TBlockSerial; var buf: string): boolean;
var
  Tick: longword;
  n: integer;
begin
  buf := '';
  if com_opened then
  begin
    Tick := GetTick();
    repeat
      if (ser.WaitingDataEx > 0) then
      begin
        n := ser.RecvByte(Int_timout);
        if char(n) = '#' then
        begin
          Result := True;
          if debug then
            writeserialdebug(FormatDateTime('hh:mm:ss.zzz', now) +
              ' Read# : ' + IntToStr(length(buf) + 1) + ' *' + buf + '#*');
          Exit;
        end;
        buf := buf + char(n);
      end;
      if ser.LastError <> 0 then
        break;
    until (GetTick - Tick > Tot_timout) or not com_opened;
    if debug then
      writeserialdebug(FormatDateTime('hh:mm:ss.zzz', now) + ' Read# : ' +
        IntToStr(length(buf)) + ' *' + buf + '* missed #');
  end;
  Result := False;
end;


function WriteCom(var ser: TBlockSerial; var buf: string; var Count: integer): boolean;
begin
  if com_opened then
  begin
    ser.SendString(buf);
    Result := (ser.LastError = 0);
    if debug then
      writeserialdebug(FormatDateTime('hh:mm:ss.zzz', now) + ' Write : ' +
        IntToStr(Count) + ' *' + buf + '*');
  end
  else
    Result := False;
end;

procedure CloseCom(var ser: TBlockSerial);
begin
  if com_opened then
  begin
    com_opened := False;
    try
      if ser <> nil then
        ser.Free;
      if debug then
        writeserialdebug(FormatDateTime('hh:mm:ss.zzz', now) + ' Close');
    except
    end;
  end;
end;

function OpenTcpip(var Sock: TTCPBlockSocket; ipaddr, port, timeout: string): boolean;
begin
  Result := False;
  if debug then
    writeserialdebug(FormatDateTime('hh:mm:ss.zzz', now) + ' Open  : ' +
      ipaddr + ' ' + port + ' ' + timeout);

  if Tcpip_opened then
    CloseTcpip(Sock);

  Sock := TTCPBlockSocket.Create;
  try
    Sock.Connect(ipaddr, port);
    if Sock.LastError <> 0 then
      exit;
    Sock.SetTimeout(StrToInt(timeout));
    Tcp_timout := strtointdef(timeout, 1000);
    Tcpip_opened := True;
    Result := True;
    if debug then
      writeserialdebug(FormatDateTime('hh:mm:ss.zzz', now) + ' Open OK');
  except
  end;
end;

function ReadTcpip(var Sock: TTCPBlockSocket; var buf: string;
  var Count: integer): boolean;
begin
  Result := False;
  if Tcpip_opened then
  begin
    buf := Sock.RecvBufferStr(Count, Tcp_timout);
    Result := (Sock.LastError = 0) or (Sock.LastError = WSAETIMEDOUT);
    if debug then
      writeserialdebug(FormatDateTime('hh:mm:ss.zzz', now) + ' Read  : ' +
        IntToStr(Count) + ' *' + buf + '*');
  end;
end;

function ReadTcpipTerm(var Sock: TTCPBlockSocket; var buf: string): boolean;
begin
  Result := False;
  if Tcpip_opened then
  begin
    buf := Sock.RecvTerminated(Tcp_timout, '#');
    Result := (Sock.LastError = 0);
    if debug then
      writeserialdebug(FormatDateTime('hh:mm:ss.zzz', now) + ' Read# : ' +
        IntToStr(length(buf) + 1) + ' *' + buf + '#*');
  end;
end;

function WriteTcpip(var Sock: TTCPBlockSocket; var buf: string;
  var Count: integer): boolean;
begin
  Result := False;
  if Tcpip_opened then
  begin
    sock.SendString(buf);
    Result := (Sock.LastError = 0);
    if debug then
      writeserialdebug(FormatDateTime('hh:mm:ss.zzz', now) + ' Write : ' +
        IntToStr(Count) + ' *' + buf + '*');
  end;
end;

procedure PurgeBufferTcpip(var Sock: TTCPBlockSocket);
begin
  if Tcpip_opened then
  begin
    if debug then
      writeserialdebug(FormatDateTime('hh:mm:ss.zzz', now) + ' Purge Buffer');
    Sock.Purge;
  end;
end;

procedure CloseTcpip(var Sock: TTCPBlockSocket);
begin
  if tcpip_opened then
  begin
    tcpip_opened := False;
    try
      if Sock <> nil then
        FreeAndNil(Sock);
      if debug then
        writeserialdebug(FormatDateTime('hh:mm:ss.zzz', now) + ' Close');
    except
    end;
  end;
end;


end.
