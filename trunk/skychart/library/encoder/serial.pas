unit serial;

{****************************************************************
Copyright (C) 2000 Patrick Chevalley

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
****************************************************************}

interface

Uses Windows,Sysutils;

Function OpenCom(var fh : Thandle; CommPort,baud,parity,data,stop,timeouts,inttimeout : string):boolean;
Function ReadCom(var fh : Thandle; var buf : string; var count : integer) : boolean;
Function WriteCom(var fh : Thandle; var buf : string; var count : integer) : boolean;
Procedure CloseCom(var fh : Thandle) ;
Procedure InitSerialDebug(ff : string);
Procedure WriteSerialDebug( buf : string);
Procedure CloseSerialDebug;
Procedure PurgeBuffer(var fh : Thandle);

Var     debug : boolean = false;

implementation

Var Com_opened : boolean = false;
    fdebug : textfile;
    debugfile : string;
    Tot_timout,Int_timout : integer;

Procedure CloseSerialDebug;
var i : integer;
begin
try
debug:=false;
{$I-}
closefile(fdebug);
{$I+}
// just to cleanup ioresult
i:=ioresult;
except
end;
end;

Procedure InitSerialDebug(ff : string);
begin
 debugfile:=expandfilename(ff);
 assignfile(fdebug,debugfile);
 rewrite(fdebug);
 writeln(fdebug,DateTimeToStr(Now)+'  Start trace');
 closefile(fdebug);
end;

Procedure WriteSerialDebug( buf : string);
begin
try
 assignfile(fdebug,debugfile);
 append(fdebug);
 writeln(fdebug,buf);
 closefile(fdebug);
except
 CloseSerialDebug;
end
end;

Function OpenCom(var fh : Thandle; CommPort,baud,parity,data,stop,timeouts,inttimeout : string):boolean;
var
  Timeout : TCOMMTIMEOUTS;
//  Buffer : PCommConfig;
//  size : DWORD;
  DCB: TDCB;
  Config : String;
Const RxBufferSize = 4096; TxBufferSize = 4096;
begin
  result:=false;
  if debug then writeserialdebug(FormatDateTime('hh:mm:ss.zzz',now)+' Open  : '+CommPort+' '+baud+' '+parity+' '+data+' '+stop+' '+timeouts+' '+inttimeout);
  Tot_timout:=strtointdef(timeouts,1000);
  Int_timout:=strtointdef(inttimeout,100);
  if com_opened then CloseCom(fh);
  fh := CreateFile(PChar(CommPort),
                          GENERIC_WRITE+GENERIC_READ,
                          0,
                          nil,
                          OPEN_EXISTING,
                          FILE_ATTRIBUTE_NORMAL,
                          0);
  if fh=INVALID_HANDLE_VALUE then exit;
  com_opened:=true;
  {Set port config}
  if not SetupComm(fh, RxBufferSize, TxBufferSize) then exit;
  if not GetCommState(fh, DCB) then exit;
  Config := 'baud='+baud+' parity='+parity+' data='+data+'stop='+stop;
  if not BuildCommDCB(PChar(Config), DCB) then exit;
  if not SetCommState(fh, DCB) then exit;

{ other method
  GetMem(Buffer, sizeof(TCommConfig));
  size := 0;
  GetCommConfig(fh, Buffer^, size);
  FreeMem(Buffer, sizeof(TCommConfig));
  GetMem(Buffer, size);
  GetCommConfig(fh, Buffer^, size);
  Buffer^.dcb.BaudRate := 9600;
  dcb:=buffer^.dcb;
  SetCommConfig(fh, Buffer^, size);
  FreeMem(Buffer, size);}

  { set timeout}
  timeout.ReadIntervalTimeout:=Int_timout;   // end of data timeout
  timeout.ReadTotalTimeoutMultiplier:=0;
  timeout.ReadTotalTimeoutConstant:=Tot_timout;
  timeout.WriteTotalTimeoutMultiplier:=0;
  timeout.WriteTotalTimeoutConstant:=Tot_timout;
  SetCommTimeouts(fh,timeout);
  result:=true;
  if debug then  writeserialdebug(FormatDateTime('hh:mm:ss.zzz',now)+' Open OK');
end;

Procedure PurgeBuffer(var fh : Thandle);
var count : integer;
    buf : string;
    Timeout : TCOMMTIMEOUTS;
begin
timeout.ReadIntervalTimeout:=10;
timeout.ReadTotalTimeoutMultiplier:=0;
timeout.ReadTotalTimeoutConstant:=10;
timeout.WriteTotalTimeoutMultiplier:=0;
timeout.WriteTotalTimeoutConstant:=Tot_timout;
SetCommTimeouts(fh,timeout);
try
repeat
   count:=50;
   if debug then writeserialdebug(FormatDateTime('hh:mm:ss.zzz',now)+' Purge Buffer');
   ReadCom(fh,buf,count);
until count=0;
finally
timeout.ReadIntervalTimeout:=Int_timout;
timeout.ReadTotalTimeoutMultiplier:=0;
timeout.ReadTotalTimeoutConstant:=Tot_timout;
timeout.WriteTotalTimeoutMultiplier:=0;
timeout.WriteTotalTimeoutConstant:=Tot_timout;
SetCommTimeouts(fh,timeout);
end;
end;

Function ReadCom(var fh : Thandle; var buf : string; var count : integer) : boolean;
var NumberRead : Cardinal;
begin
buf := StringOfChar(' ', count);
NumberRead:=0;
result:= ReadFile(fh, PChar(buf)^, count, NumberRead, nil);
if debug then writeserialdebug(FormatDateTime('hh:mm:ss.zzz',now)+' Read  : '+inttostr(count)+' '+inttostr(NumberRead)+' *'+buf+'*');
count:=NumberRead;
end;

Function WriteCom(var fh : Thandle; var buf : string; var count : integer) : boolean;
var NumberWritten : Cardinal;
begin
NumberWritten:=0;
result:= WriteFile(fh, PChar(buf)^, count, NumberWritten, nil);
if debug then writeserialdebug(FormatDateTime('hh:mm:ss.zzz',now)+' Write : '+inttostr(count)+' '+inttostr(NumberWritten)+' *'+buf+'*');
count:=NumberWritten;
end;

Procedure CloseCom(var fh : Thandle) ;
begin
CloseHandle(fh);
if debug then writeserialdebug(FormatDateTime('hh:mm:ss.zzz',now)+' Close');
end;


end.
