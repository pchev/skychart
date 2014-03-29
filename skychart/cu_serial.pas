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
Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
****************************************************************}
{
Patrick Chevalley Oct 2000
Lazarus version, Patrick Chevalley Jun 2011
Tomas Mandys Apr 2013
}

interface

Uses Forms, synaser, sysutils, FileUtil, synautil;

Function OpenCom(var ser:TBlockSerial; CommPort,baud,parity,data,stop,timeouts,inttimeout : string):boolean;
Function ReadCom(var ser:TBlockSerial; var buf : string; var count : integer) : boolean;
Function ReadComTerm(var ser:TBlockSerial; var buf : string) : boolean;
Function WriteCom(var ser:TBlockSerial; var buf : string; var count : integer) : boolean;
Procedure PurgeBuffer(var ser:TBlockSerial);
Procedure CloseCom(var ser:TBlockSerial) ;
Procedure InitSerialDebug(ff : string);
Procedure WriteSerialDebug( buf : string);
Procedure CloseSerialDebug;

Var     debug : boolean = false;

implementation

Var Com_opened : boolean = false;
    fdebug : textfile;
    debugfile : string;
    Tot_timout,Int_timout : integer;

{$NOTES OFF}
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
{$NOTES ON}

Procedure InitSerialDebug(ff : string);
begin
 debugfile:=ExpandFileName(ff);
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

Function OpenCom(var ser:TBlockSerial; CommPort,baud,parity,data,stop,timeouts,inttimeout : string):boolean;
var sb:integer;
begin
  result:=false;
  if debug then writeserialdebug(FormatDateTime('hh:mm:ss.zzz',now)+' Open  : '+CommPort+' '+baud+' '+parity+' '+data+' '+stop+' '+timeouts+' '+inttimeout);

  if com_opened then CloseCom(ser);

  ser:=TBlockSerial.Create;
  try
    ser.Connect(CommPort);
    if ser.LastError<>0 then exit;
    sb:=0;
    if stop='1.5' then sb:=1;
    if stop='2' then sb:=2;
    ser.config(strtoint(baud),strtoint(data),char(parity[1]),sb,false,false);
    if ser.LastError<>0 then exit;
    Tot_timout:=strtointdef(timeouts,1000);
    Int_timout:=strtointdef(inttimeout,100);
    com_opened:=true;
    result:=true;
    if debug then  writeserialdebug(FormatDateTime('hh:mm:ss.zzz',now)+' Open OK');
  finally
  end;
end;

Procedure PurgeBuffer(var ser:TBlockSerial);
begin
if com_opened then begin
  if debug then writeserialdebug(FormatDateTime('hh:mm:ss.zzz',now)+' Purge Buffer');
  ser.Purge;
end;
end;

Function ReadCom(var ser:TBlockSerial; var buf : string; var count : integer) : boolean;
var n : integer;
var
  Tick: LongWord;
begin
  buf:='';
  if com_opened then
    begin
      Tick:= GetTick();
      repeat
        n := ser.RecvByte(Int_timout);
        if (ser.LastError=0) then
          buf:=buf+char(n)
        else
          break;
        // Application.ProcessMessages; // TMa no!!!  it causes problem with timer's showcoordinates
      until (length(buf)>=count)or(GetTick-Tick > Tot_timout)or not com_opened;
      count:=length(buf);
      result:=(ser.LastError=0)or(ser.LastError=ErrTimeout);
      if debug then writeserialdebug(FormatDateTime('hh:mm:ss.zzz',now)+' Read  : '+inttostr(count)+' *'+buf+'*');
    end
  else
    begin
      result:= false;
    end;
end;

Function ReadComTerm(var ser:TBlockSerial; var buf : string) : boolean;
var
  Tick: LongWord;
  n: Integer;
begin
  buf:= '';
  if com_opened then
  begin
    Tick:= GetTick();
    repeat
      if (ser.WaitingDataEx > 0) then
      begin
        n := ser.RecvByte(Int_timout);
        if char(n) = '#' then
        begin
          Result:= true;
          if debug then
            writeserialdebug(FormatDateTime('hh:mm:ss.zzz',now)+' Read# : '+inttostr(length(buf)+1) +' *'+buf+'#*');
          Exit;
        end;
        buf:= buf + char(n);
      end;
      if ser.LastError <> 0 then
        break;
    until (GetTick-Tick > Tot_timout) or not com_opened;
    if debug then
      writeserialdebug(FormatDateTime('hh:mm:ss.zzz',now)+' Read# : '+inttostr(length(buf)) +' *'+buf+'* missed #');
  end;
  result:= false;
end;


Function WriteCom(var ser:TBlockSerial; var buf : string; var count : integer) : boolean;
begin
if com_opened then begin
  ser.SendString(buf);
  result:=(ser.LastError=0);
  if debug then writeserialdebug(FormatDateTime('hh:mm:ss.zzz',now)+' Write : '+inttostr(count)+' *'+buf+'*');
end;
end;

Procedure CloseCom(var ser:TBlockSerial);
begin
if com_opened then begin
  com_opened:=false;
  try
  if ser<>Nil then ser.Free;
  if debug then writeserialdebug(FormatDateTime('hh:mm:ss.zzz',now)+' Close');
  except
  end;
end;
end;


end.