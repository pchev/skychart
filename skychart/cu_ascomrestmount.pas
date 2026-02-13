unit cu_ascomrestmount;

{$mode objfpc}{$H+}

{
Copyright (C) 2019 Patrick Chevalley

http://www.ap-i.net
pch@ap-i.net

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>. 

}

{$define AppSkychart}
//{$define AppCcdciel}

interface

uses  cu_mount, cu_ascomrest, indiapi,
    {$ifdef AppSkychart}
    u_constant, u_util,
    {$endif}
    {$ifdef AppCcdciel}
    u_global, u_utils,
    {$endif}
    u_translation,
  Forms, ExtCtrls, Classes, SysUtils;

type
doublearray = array of double;
Pdoublearray = ^doublearray;

T_ascomrestmount = class(T_mount)
 private
   V: TAscomRest;
   CanPark,CanSlew,CanSlewAsync,CanSync,CanSetTracking: boolean;
   stRA,stDE,stFocalLength: double;
   FInterfaceVersion: integer;
   stPark:boolean;
   stPierside: TPierSide;
   stTracking: boolean;
   StatusTimer: TTimer;
   StatusCount: integer;
   FDeviceName: string;
   statusinterval,waitpoll: integer;
   function Connected: boolean;
   procedure StatusTimerTimer(sender: TObject);
   procedure CheckEqmod;
   function WaitConnecting(maxtime:integer):boolean;
   function WaitMountSlewing(maxtime:integer):boolean;
   function WaitMountPark(maxtime:integer):boolean;
   procedure GetScopeRates(var nrates0, nrates1: integer; axis0rates, axis1rates: Pdoublearray);
 protected
   function  GetTracking:Boolean; override;
   function  getCanSetGuideRates:Boolean; override;
   procedure SetPark(value:Boolean); override;
   function  GetPark:Boolean; override;
   function  GetRA:double; override;
   function  GetDec:double; override;
   function  GetPierSide: TPierSide; override;
   procedure SetPierSide(value: TPierSide); override;
   function  GetEquinox: double; override;
   function  GetAperture:double; override;
   function  GetFocaleLength:double; override;
   procedure SetTimeout(num:integer); override;
   function  GetSyncMode:TEqmodAlign; override;
   procedure SetSyncMode(value:TEqmodAlign); override;
   function GetMountSlewing:boolean; override;
   function  GetRAReal:double;
   function  GetDecReal:double;
   function  GetPierSideReal: TPierSide;
   function  GetFocaleLengthReal:double;
   function GetGuideRateRa: double; override;
   function GetGuideRateDe: double; override;
   procedure SetGuideRateRa(value:double); override;
   procedure SetGuideRateDe(value:double); override;
   function GetPulseGuiding: boolean; override;
   function GetAlignmentMode: TAlignmentMode; override;
   function GetCanSetPierSide: boolean; override;
   function GetSlewRates: TstringList; override;
   function GetTrackRate: TTrackRate; override;
   procedure SetTrackRate(value: TTrackRate); override;
   function GetMountRefraction: TMountRefraction; override;
public
   constructor Create(AOwner: TComponent);override;
   destructor  Destroy; override;
   procedure Connect(cp1: string; cp2:string=''; cp3:string=''; cp4:string=''; cp5:string=''; cp6:string=''); override;
   procedure Disconnect; override;
   function Slew(sra,sde: double):boolean; override;
   function SlewAsync(sra,sde: double):boolean; override;
   function FlipMeridian(belowthepole:boolean): boolean; override;
   function Sync(sra,sde: double):boolean; override;
   function Track:boolean; override;
   procedure AbortMotion; override;
   procedure AbortSlew; override;
   function ClearAlignment:boolean; override;
   function ClearDelta:boolean; override;
   function GetSite(var long,lat,elev: double): boolean; override;
   function SetSite(long,lat,elev: double): boolean; override;
   function GetDate(var utc,offset: double): boolean; override;
   function SetDate(utc,offset: double): boolean; override;
   function PulseGuide(direction,duration:integer): boolean; override;
   procedure MoveAxis(axis: integer; rate: string); override;
end;

implementation

constructor T_ascomrestmount.Create(AOwner: TComponent);
begin
 inherited Create(AOwner);
 V:=TAscomRest.Create(self);
 V.ClientId:=3203;
 FMountInterface:=ASCOMREST;
 stRA:=NullCoord;
 stDE:=NullCoord;
 stFocalLength:=NullCoord;
 stPark:=false;
 stPierside:=pierNotImplemented;
 stTracking:=false;
 CanPark:=false;
 CanSlew:=false;
 CanSlewAsync:=false;
 CanSync:=false;
 CanSetTracking:=false;
 waitpoll:=500;
 statusinterval:=2000;
 StatusTimer:=TTimer.Create(nil);
 StatusTimer.Enabled:=false;
 StatusTimer.Interval:=statusinterval;
 StatusTimer.OnTimer:=@StatusTimerTimer;
end;

destructor  T_ascomrestmount.Destroy;
begin
 StatusTimer.Free;
 inherited Destroy;
end;

procedure T_ascomrestmount.Connect(cp1: string; cp2:string=''; cp3:string=''; cp4:string=''; cp5:string=''; cp6:string='');
var buf: string;
    j: double;
begin
  try
  FStatus := devConnecting;
  V.Host:=cp1;
  V.Port:=cp2;
  V.Protocol:=cp3;
  V.User:=cp5;
  V.Password:=cp6;
  Fdevice:=cp4;
  V.Device:=Fdevice;
  if Assigned(FonStatusChange) then FonStatusChange(self);
  msg('Connecting to Alpaca server '+cp1+':'+cp2,9);
  V.Timeout:=StdTimeout;
  try
  FInterfaceVersion:=V.Get('interfaceversion').AsInt;
  except
    FInterfaceVersion:=1;
  end;
  msg('Interface version: '+inttostr(FInterfaceVersion),9);
  if FInterfaceVersion>=4 then begin
    V.Put('Connect');
    WaitConnecting(30000);
  end
  else
     V.Put('Connected',true);
  if V.Get('connected').AsBool then begin
     try
     msg(V.Get('driverinfo').AsString,9);
     except
     end;
     try
     msg('Driver version: '+V.Get('driverversion').AsString,9);
     except
       msg('Error: unknown driver version',9);
     end;
     try
     FDeviceName:=V.Get('name').AsString;
     except
       FDeviceName:=Fdevice;
     end;
     FStatus := devConnected;
     CheckEqmod;
     CanPark:=V.Get('canpark').AsBool;
     CanSlew:=V.Get('canslew').AsBool;
     CanSlewAsync:=V.Get('canslewasync').AsBool;
     CanSync:=V.Get('cansync').AsBool;
     CanSetTracking:=V.Get('cansettracking').AsBool;
     FCanPulseGuide:=V.Get('canpulseguide').AsBool;
     FisGem:=(GetAlignmentMode=algGermanPolar)and(GetPierSideReal<>pierNotImplemented);
     try
       if FInterfaceVersion>1 then begin
         FCanMoveAxis:=V.Get('canmoveaxis','Axis=0').AsBool and V.Get('canmoveaxis','Axis=1').AsBool;
       end
       else
         FCanMoveAxis:=false;
     except
       FCanMoveAxis:=false;
     end;
     Fcapability:='';
     if IsEqmod then Fcapability:=Fcapability+'EQmod; ';
     if CanPark then Fcapability:=Fcapability+'CanPark; ';
     if CanSlew then Fcapability:=Fcapability+'CanSlew; ';
     if CanSlewAsync then Fcapability:=Fcapability+'CanSlewAsync; ';
     if CanSetPierSide then Fcapability:=Fcapability+'CanSetPierSide; ';
     if CanSync then Fcapability:=Fcapability+'CanSync; ';
     if CanSetTracking then Fcapability:=Fcapability+'CanSetTracking; ';
     if CanPulseGuide then Fcapability:=Fcapability+'CanPulseGuide; ';
     if FCanMoveAxis then Fcapability:=Fcapability+'CanMoveAxis; ';
     if FIsGem then Fcapability:=Fcapability+'GEM; ';
     FEquinox:=NullCoord;
     FEquinoxJD:=NullCoord;
     j:=GetEquinox;
     if j=0 then Fcapability:=Fcapability+'EquatorialSystem: Local; '
            else Fcapability:=Fcapability+'EquatorialSystem: '+FormatFloat(f0,j)+'; ';
     if isLocalIP(V.RemoteIP) then begin
       waitpoll:=500;
       statusinterval:=2000;
     end
     else begin
       waitpoll:=1000;
       statusinterval:=3000;
     end;
     msg(rsConnected3);
     msg(Format(rsMountCapabil, [Fcapability]));
     if Assigned(FonStatusChange) then FonStatusChange(self);
     if Assigned(FonParkChange) then FonParkChange(self);
     if Assigned(FonPiersideChange) then FonPiersideChange(self);
     StatusCount:=0;
     StatusTimer.Interval:=1000;
     StatusTimer.Enabled:=true;
  end
  else
     Disconnect;
  except
    on E: Exception do begin
       msg(Format(rsConnectionEr, [E.Message]),0);
       Disconnect;
    end;
  end;
end;

procedure T_ascomrestmount.Disconnect;
begin
   StatusTimer.Enabled:=false;
   try
   if FInterfaceVersion>=4 then begin
     V.Put('Disconnect');
     WaitConnecting(30000);
   end
   else
     V.Put('Connected',false);
   except
    on E: Exception do msg(Format(rsDisconnectio, [E.Message]),0);
   end;
   FStatus := devDisconnected;
   Fcapability:='';
   if Assigned(FonStatusChange) then FonStatusChange(self);
   msg(rsDisconnected3,1);
end;

function T_ascomrestmount.Connected: boolean;
begin
result:=false;
  try
  result:=V.Get('connected').AsBool;
  except
   on E: Exception do begin
     if debug_msg then msg('Error Connected : '+ E.Message);
     result:=false;
   end;
  end;
end;

procedure T_ascomrestmount.StatusTimerTimer(sender: TObject);
var x,y: double;
    pk: boolean;
    ps: TPierSide;
    tr: Boolean;
begin
 StatusTimer.Enabled:=false;
 StatusTimer.Interval:=statusinterval;
 try
  if Connected then begin
    try
    x:=GetRAReal;
    y:=GetDecReal;
    pk:=GetPark;
    ps:=GetPierSideReal;
    tr:=GetTracking;
    if (StatusCount mod 20)=0 then begin
      stFocalLength:=GetFocaleLengthReal;
      StatusCount:=0;
    end;
    inc(StatusCount);
    if (x<>stRA)or(y<>stDE) then begin
       stRA:=x;
       stDE:=y;
       if Assigned(FonCoordChange) then FonCoordChange(self);
    end;
    if pk<>stPark then begin
       stPark:=pk;
       if Assigned(FonParkChange) then FonParkChange(self);
    end;
    if ps<>stPierside then begin
       stPierside:=ps;
       if Assigned(FonPiersideChange) then FonPiersideChange(self);
    end;
    if tr<>stTracking then begin
       stTracking:=tr;
       if Assigned(FonTrackingChange) then FonTrackingChange(self);
    end;
    except
     on E: Exception do msg('Status error: ' + E.Message,0);
    end;
  end;
  finally
   if FStatus=devConnected then StatusTimer.Enabled:=true;
  end;
end;

procedure T_ascomrestmount.SetPark(value:Boolean);
begin
   if FStatus<>devConnected then exit;
   try
   if CanPark then begin
      if value then begin
         msg(rsPark);
         V.Put('park');
         WaitMountPark(SlewDelay);
      end else begin
         msg(rsUnpark);
         V.Put('unpark');
      end;
   end;
   except
    on E: Exception do msg('Park error: ' + E.Message,0);
   end;
end;

function  T_ascomrestmount.GetPark:Boolean;
begin
 result:=false;
   if FStatus<>devConnected then exit;
   try
   result:=V.Get('atpark').AsBool;
   except
    result:=false;
   end;
end;

function  T_ascomrestmount.GetRAReal:double;
begin
 result:=NullCoord;
   if FStatus<>devConnected then exit;
   try
   result:=V.Get('rightascension').AsFloat;
   except
    result:=NullCoord;
   end;
end;

function  T_ascomrestmount.GetDecReal:double;
begin
 result:=NullCoord;
   if FStatus<>devConnected then exit;
   try
   result:=V.Get('declination').AsFloat;
   except
    result:=NullCoord;
   end;
end;

function  T_ascomrestmount.GetPierSideReal:TPierSide;
var i: integer;
begin
 result:=pierNotImplemented;
   if FStatus<>devConnected then exit;
   try
   i:=V.Get('sideofpier').AsInt;  // pascal enum may have different size
   case i of
     -1: result:=pierUnknown;
      0: result:=pierEast;
      1: result:=pierWest;
   end;
   except
    result:=pierNotImplemented;
   end;
end;

function  T_ascomrestmount.GetRA:double;
begin
 if FStatus=devConnected then begin
     {$ifdef AppCcdciel}if stRA=NullCoord then {$endif} stRA:=GetRAReal;
    result:=stRA;
 end
 else
    result:=NullCoord;
end;

function  T_ascomrestmount.GetDec:double;
begin
 if FStatus=devConnected then begin
     {$ifdef AppCcdciel}if stDE=NullCoord then {$endif} stDE:=GetDecReal;
    result:=stDE;
 end
 else
    result:=NullCoord;
end;

function  T_ascomrestmount.GetPierSide:TPierSide;
begin
 if FStatus=devConnected then
    result:=stPierside
 else
    result:=pierNotImplemented;
end;

procedure T_ascomrestmount.SetPierSide(value: TPierSide);
var i: integer;
begin
 try
 case value of
   pierEast: i:=0;
   pierWest: i:=1;
   else raise Exception.Create('Invalid value');
 end;
 if debug_msg then msg('Set sideofpier = '+IntToStr(i));
 V.Put('SideOfPier',i);
 wait(5);
 WaitMountSlewing(SlewDelay);
 except
   on E: Exception do msg('Set SideOfPier error: ' + E.Message,0);
 end;
end;

function  T_ascomrestmount.GetFocaleLength:double;
begin
 if FStatus=devConnected then
    result:=stFocalLength
 else
    result:=-1;
end;

function  T_ascomrestmount.GetEquinox: double;
var i: Integer;
begin
 result:=0;
  if FStatus<>devConnected then exit;
  try
  i:=V.Get('equatorialsystem').AsInt;
  case i of
  0 : result:=0;
  1 : result:=0;
  2 : result:=2000;
  3 : result:=2050;
  4 : result:=1950;
  end;
  except
   result:=0;
  end;
end;

function  T_ascomrestmount.GetAperture:double;
begin
 result:=-1;
  if FStatus<>devConnected then exit;
   try
   result:=V.Get('aperturediameter').AsFloat*1000;
   except
    result:=-1;
   end;
end;

function  T_ascomrestmount.GetFocaleLengthReal:double;
begin
 result:=-1;
  if FStatus<>devConnected then exit;
   try
   result:=V.Get('focallength').AsFloat*1000;
   except
    result:=-1;
   end;
end;

function T_ascomrestmount.SlewAsync(sra,sde: double):boolean;
begin
 result:=false;
 if FStatus<>devConnected then exit;
 if CanSlew then begin
   try
   if CanSetTracking and (not V.Get('tracking').AsBool) then begin
     try
      V.Put('Tracking',true);
     except
       on E: Exception do msg('Set tracking error: ' + E.Message,0);
     end;
   end;
   if Equinox=0 then
      msg(Format(rsSlewToEQ, ['Local', ARToStr3(sra), DEToStr(sde)]))
   else
      msg(Format(rsSlewToEQ, ['J'+inttostr(round(Equinox)) ,ARToStr3(sra), DEToStr(sde)]));
   if CanSlewAsync then begin
     V.Put('slewtocoordinatesasync',['RightAscension',FormatFloat(f6,sra),'Declination',FormatFloat(f6,sde)]);
   end
   else begin
    try
     V.Timeout:=LongTimeout;
     V.Put('slewtocoordinates',['RightAscension',FormatFloat(f6,sra),'Declination',FormatFloat(f6,sde)]);
    finally
     V.Timeout:=StdTimeout;
    end;
   end;
   result:=true;
   except
     on E: Exception do msg('Slew error: ' + E.Message,0);
   end;
 end;
end;

function T_ascomrestmount.Slew(sra,sde: double):boolean;
begin
 result:=false;
 if FStatus<>devConnected then exit;
 if CanSlew then begin
   try
   if CanSetTracking and (not V.Get('tracking').AsBool) then begin
     try
      V.Put('Tracking',true);
     except
       on E: Exception do msg('Set tracking error: ' + E.Message,0);
     end;
   end;
   FMountSlewing:=true;
   if Equinox=0 then
      msg(Format(rsSlewToEQ, ['Local', ARToStr3(sra), DEToStr(sde)]))
   else
      msg(Format(rsSlewToEQ, ['J'+inttostr(round(Equinox)) ,ARToStr3(sra), DEToStr(sde)]));
   if CanSlewAsync then begin
     V.Put('slewtocoordinatesasync',['RightAscension',FormatFloat(f6,sra),'Declination',FormatFloat(f6,sde)]);
     WaitMountSlewing(SlewDelay);
   end
   else begin
     try
     V.Timeout:=LongTimeout;
     V.Put('slewtocoordinates',['RightAscension',FormatFloat(f6,sra),'Declination',FormatFloat(f6,sde)]);
     finally
      V.Timeout:=StdTimeout;
     end;
   end;
   wait(2);
   msg(rsSlewComplete);
   FMountSlewing:=false;
   result:=true;
   except
     on E: Exception do msg('Slew error: ' + E.Message,0);
   end;
 end;
end;

function T_ascomrestmount.GetMountSlewing:boolean;
var islewing: boolean;
begin
 result:=false;
 if FStatus<>devConnected then exit;
 try
 islewing:=false;
  if CanSlewAsync then
    islewing:=V.Get('slewing').AsBool
  else
    islewing:=false;
  result:=(islewing or FMountSlewing);
  except
    on E: Exception do msg('Get slewing error: ' + E.Message,0);
  end;
end;

function T_ascomrestmount.WaitConnecting(maxtime:integer):boolean;
var timemax,lastcheck: double;
    ok: boolean;
begin
 result:=true;
 try
   timemax:=now+maxtime/1000/SecsPerDay;
   lastcheck:=0;
   repeat
      if now>(lastcheck+waitpoll/1000/SecsPerDay) then begin
         ok:=not (V.Get('connecting').AsBool);
         if ok then break;
         lastcheck:=now;
      end;
      sleep(10);
      if GetCurrentThreadId=MainThreadID then Application.ProcessMessages;
   until ok or (now>timemax);
   result:=(now<timemax);
 except
   on E: Exception do begin
     msg(Format(rsConnectionEr, [E.Message]),0);
     result:=false;
   end;
 end;
end;

function T_ascomrestmount.WaitMountSlewing(maxtime:integer):boolean;
var timemax,lastcheck: double;
    ok: boolean;
begin
 result:=true;
 try
   timemax:=now+maxtime/1000/SecsPerDay;
   lastcheck:=0;
   repeat
      if now>(lastcheck+waitpoll/1000/SecsPerDay) then begin
         ok:=not (V.Get('slewing').AsBool);
         if ok then break;
         lastcheck:=now;
      end;
      sleep(10);
      if GetCurrentThreadId=MainThreadID then Application.ProcessMessages;
   until ok or (now>timemax);
   result:=(now<timemax);
 except
   result:=false;
 end;
end;

function T_ascomrestmount.WaitMountPark(maxtime:integer):boolean;
var timemax,lastcheck: double;
    ok: boolean;
begin
 result:=true;
 if FStatus<>devConnected then exit;
 try
  if CanPark then begin
   timemax:=now+maxtime/1000/SecsPerDay;
   lastcheck:=0;
   repeat
      if now>(lastcheck+waitpoll/1000/SecsPerDay) then begin
         ok:=(V.Get('atpark').AsBool);
         if ok then break;
         lastcheck:=now;
      end;
      sleep(10);
      if GetCurrentThreadId=MainThreadID then Application.ProcessMessages;
   until ok or (now>timemax);
   result:=(now<timemax);
  end;
 except
   result:=false;
 end;
end;

function T_ascomrestmount.FlipMeridian(belowthepole:boolean):boolean;
var sra,sde,ra1,ra2: double;
    pierside1,pierside2,destside:TPierSide;
    rightside: boolean;
begin
  result:=false;
  {$ifdef AppCcdciel}
 if FStatus<>devConnected then exit;
  if Connected then begin
    sra:=GetRA;
    sde:=GetDec;
    pierside1:=GetPierSideReal;
    rightside:=((not belowthepole)and(pierside1=pierEast))or((belowthepole)and(pierside1=pierWest));
    if rightside then exit; // already right side
    if (sra=NullCoord)or(sde=NullCoord) then exit;
    msg(rsMeridianFlip5);
    if FUseSetPierSide and CanSetPierSide and CanSlewAsync then begin
       if belowthepole then
         destside:=pierWest
       else
         destside:=pierEast;
       // do the flip
       SetPierSide(destside);
       // check result
       pierside2:=GetPierSideReal;
       result:=(pierside2<>pierside1);
    end
    else begin
      // point one hour to the east of meridian
       if belowthepole then
         ra1:=rmod(36+1+rad2deg*CurrentSidTim/15,24)
       else
         ra1:=rmod(24+1+rad2deg*CurrentSidTim/15,24);
      slew(ra1,sde);
      // point one hour to the west of target to force the flip
      ra2:=sra-1;
      if ra2<0 then ra2:=ra2+24;
      slew(ra2,sde);
      // return to position
      slew(sra,sde);
      // check result
      pierside2:=GetPierSide;
      result:=(pierside2<>pierside1);
    end;
  end;
  {$endif}
end;

function T_ascomrestmount.Sync(sra,sde: double):boolean;
begin
 result:=false;
 if FStatus<>devConnected then exit;
 if CanSync then begin
   try
   if CanSetTracking and (not V.Get('tracking').AsBool) then begin
     msg(rsCannotSyncWh,0);
     exit;
   end;
   if Equinox=0 then
      msg(Format(rsSyncToEQ, ['Local', ARToStr3(sra), DEToStr(sde)]))
   else
      msg(Format(rsSyncToEQ, ['J'+inttostr(round(Equinox)) ,ARToStr3(sra), DEToStr(sde)]));
   V.Put('synctocoordinates',['RightAscension',FormatFloat(f6,sra),'Declination',FormatFloat(f6,sde)]);
   result:=true;
   except
     on E: Exception do msg('Sync error: ' + E.Message,0);
   end;
 end;
end;

function T_ascomrestmount.GetTracking:Boolean;
begin
 result:=true;
 if FStatus<>devConnected then exit;
   try
   result:=V.Get('tracking').AsBool;
   except
   end;
end;

function T_ascomrestmount.getCanSetGuideRates:Boolean;
begin
 result:=false;
 if FStatus<>devConnected then exit;
   try
   result:=V.Get('cansetguiderates').AsBool;
   except
   end;
end;

function T_ascomrestmount.Track:boolean;
begin
 result:=false;
 if FStatus<>devConnected then exit;
   try
   if CanSetTracking and (not V.Get('tracking').AsBool) then begin
     try
      msg(rsStartTracking);
      V.Put('Tracking',true);
     except
       on E: Exception do msg('Set tracking error: ' + E.Message,0);
     end;
   end;
   result:=true;
   except
     on E: Exception do msg('Track error: ' + E.Message,0);
   end;
end;

procedure T_ascomrestmount.AbortMotion;
begin
 MountTrackingAlert:=false;
 if FStatus<>devConnected then exit;
 if CanSlew then begin
   try
   msg(rsStopTelescop);
   V.Put('abortslew');
   if CanSetTracking  then V.Put('Tracking',false);
   except
     on E: Exception do msg('Abort motion error: ' + E.Message,0);
   end;
 end;
end;

procedure T_ascomrestmount.AbortSlew;
begin
 MountTrackingAlert:=false;
 if FStatus<>devConnected then exit;
 if CanSlew then begin
   try
   V.Put('abortslew');
   except
     on E: Exception do msg('Abort motion error: ' + E.Message,0);
   end;
 end;
end;

procedure T_ascomrestmount.SetTimeout(num:integer);
begin
 FTimeOut:=num;
end;

// Eqmod specific

procedure T_ascomrestmount.CheckEqmod;
var buf:string;
begin
  FIsEqmod:=false;
  if pos('EQMOD',uppercase(FDeviceName))>0 then begin
    try
    buf:=V.PutR('commandstring',['Command',':MOUNTVER#','Raw','true']).AsString;
    if length(buf)=8 then FIsEqmod:=true;
    except
     FIsEqmod:=false;
    end;
  end;
end;

function  T_ascomrestmount.GetSyncMode:TEqmodAlign;
var buf:string;
begin
 result:=alUNSUPPORTED;
 if IsEqmod then begin
   try
   buf:=V.PutR('commandstring',['Command',':ALIGN_MODE#','Raw','true']).AsString;
   if buf='1#' then result:=alADDPOINT
   else if buf='0#' then result:=alSTDSYNC;
   except
    result:=alUNSUPPORTED;
   end;
 end
 else result:=alUNSUPPORTED;
end;

procedure T_ascomrestmount.SetSyncMode(value:TEqmodAlign);
begin
 if IsEqmod and (value<>alUNSUPPORTED) then begin
   try
   if value=alSTDSYNC then begin
     msg('align mode Std Sync');
     V.Put('commandstring',['Command',':ALIGN_MODE,0#','Raw','true']);
   end
   else if value=alADDPOINT then begin
     msg('align mode Add Point');
     V.Put('commandstring',['Command',':ALIGN_MODE,1#','Raw','true']);
   end;
   except
     on E: Exception do msg('Eqmod set sync mode error: ' + E.Message,0);
   end;
 end;
end;

function T_ascomrestmount.ClearAlignment:boolean;
begin
 result:=false;
 if IsEqmod then begin
   try
   msg('clear alignment');
   V.Put('commandstring',['Command',':ALIGN_CLEAR_POINTS#','Raw','true']);
   result:=true;
   except
     on E: Exception do msg('Eqmod clear alignment error: ' + E.Message,0);
   end;
 end;
end;

function T_ascomrestmount.ClearDelta:boolean;
begin
 result:=false;
 if IsEqmod then begin
   try
   msg('clear delta sync');
   V.Put('commandstring',['Command',':ALIGN_CLEAR_SYNC#','Raw','true']);
   result:=true;
   except
     on E: Exception do msg('Eqmod clear delta error: ' + E.Message,0);
   end;
 end;
end;

function T_ascomrestmount.GetSite(var long,lat,elev: double): boolean;
begin
 result:=false;
 if FStatus<>devConnected then exit;
   try
   long:=V.Get('sitelongitude').AsFloat;
   lat:=V.Get('sitelatitude').AsFloat;
   elev:=V.Get('siteelevation').AsFloat;
   result:=true;
   except
     on E: Exception do msg('Cannot get site information: ' + E.Message,0);
   end;
end;

function T_ascomrestmount.SetSite(long,lat,elev: double): boolean;
begin
 result:=false;
 if FStatus<>devConnected then exit;
   try
   V.Put('SiteLongitude',long);
   V.Put('SiteLatitude',lat);
   V.Put('SiteElevation',elev);
   result:=true;
   except
     on E: Exception do msg('Cannot set site information: ' + E.Message,0);
   end;
end;

function T_ascomrestmount.GetDate(var utc,offset: double): boolean;
begin
 result:=false;
 if FStatus<>devConnected then exit;
   try
   utc:=DateIso2DateTime(V.Get('utcdate').AsString);     //2019-01-30T18:15:23.734
   offset:=ObsTimeZone; // No offset in ASCOM telescope interface
   result:=true;
   except
     on E: Exception do msg('Cannot get date: ' + E.Message,0);
   end;
end;

function T_ascomrestmount.SetDate(utc,offset: double): boolean;
begin
 result:=false;
 if FStatus<>devConnected then exit;
   try
   V.Put('UTCDate',FormatDateTime(dateiso,utc)+'Z');
   result:=true;
   except
     on E: Exception do msg('Cannot set date: ' + E.Message,0);
   end;
end;


function T_ascomrestmount.GetGuideRateRa: double;
begin
 result:=0;
 if FStatus<>devConnected then exit;
   try
   result:=V.Get('guideraterightascension').AsFloat;
   if debug_msg then msg('GuideRateRightAscension = '+formatfloat(f6,Result));
   except
     on E: Exception do msg('Cannot get guide rate: ' + E.Message,0);
   end;
end;

function T_ascomrestmount.GetGuideRateDe: double;
begin
 result:=0;
 if FStatus<>devConnected then exit;
   try
   result:=V.Get('guideratedeclination').AsFloat;
   if debug_msg then msg('GuideRateDeclination = '+formatfloat(f6,Result));
   except
     on E: Exception do msg('Cannot get guide rate: ' + E.Message,0);
   end;
end;

procedure T_ascomrestmount.SetGuideRateRa(value:double);
begin
 try
 if debug_msg then msg('Set GuideRateRightAscension = '+formatfloat(f6,value));
 V.Put('GuideRateRightAscension',value);
 except
   on E: Exception do msg('Set GuideRateRightAscension error: ' + E.Message,0);
 end;
end;

procedure T_ascomrestmount.SetGuideRateDe(value:double);
begin
 try
 if debug_msg then msg('Set GuideRateDeclination = '+formatfloat(f6,value));
 V.Put('GuideRateDeclination',value);
 except
   on E: Exception do msg('Set GuideRateDeclination error: ' + E.Message,0);
 end;
end;

function T_ascomrestmount.PulseGuide(direction,duration:integer): boolean;
begin
 result:=false;
 if FStatus<>devConnected then exit;
   try
    if debug_msg then msg('PulseGuide, Direction='+inttostr(direction)+', Duration='+inttostr(duration));
    V.Put('pulseguide',['Direction',inttostr(direction),'Duration',inttostr(duration)]);
    result:=true;
   except
     on E: Exception do msg('Pulse guide error: ' + E.Message,0);
   end;
end;

function T_ascomrestmount.GetPulseGuiding: boolean;
begin
 result:=false;
 if FStatus<>devConnected then exit;
   try
   result:=V.Get('ispulseguiding').AsBool;
   if debug_msg then msg('IsPulseGuiding = '+BoolToStr(result, rsTrue, rsFalse));
   except
     on E: Exception do msg('Cannot get pulse guide state: ' + E.Message,0);
   end;
end;

function T_ascomrestmount.GetAlignmentMode: TAlignmentMode;
var i: integer;
begin
 // Default to GEM and let availability of PierSide make further difference
 result:=algGermanPolar;
 if FStatus<>devConnected then exit;
   try
   i:=V.Get('alignmentmode').AsInt;
   case i of
      0: result:=algAltAz;
      1: result:=algPolar;
      2: result:=algGermanPolar;
   end;
   if debug_msg then msg('AlignmentMode = '+inttostr(i));
   except
     result:=algGermanPolar;
   end;
end;

function T_ascomrestmount.GetCanSetPierSide: boolean;
begin
  result:=false;
  try
    result:=V.Get('cansetpierside').AsBool;
  except
    result:=false;
  end;
end;

procedure T_ascomrestmount.GetScopeRates(var nrates0, nrates1: integer; axis0rates, axis1rates: Pdoublearray);
var
  i : integer;
  x: IAxisRates;
begin
  SetLength(axis0rates^, 0);
  SetLength(axis1rates^, 0);
  nrates0 := 0;
  nrates1 := 0;
  if FStatus<>devConnected then exit;
  try
    x:=V.GetAxisRates('0');
    nrates0:=Length(x);
    SetLength(axis0rates^, 2*nrates0);
    for i:=0 to nrates0-1 do begin
      axis0rates^[2*i]   := x[i].Minimum;
      axis0rates^[2*i+1] := x[i].Maximum;
      x[i].Free;
    end;
    x:=V.GetAxisRates('1');
    nrates1:=Length(x);
    SetLength(axis1rates^, 2*nrates1);
    for i:=0 to nrates1-1 do begin
      axis1rates^[2*i]   := x[i].Minimum;
      axis1rates^[2*i+1] := x[i].Maximum;
      x[i].Free;
    end;
  except
    // unsupported by interface V1
  end;
end;

function T_ascomrestmount.GetSlewRates: TStringList;
var
  i, j, n0, n1: integer;
  ax0r, ax1r: array of double;
  min, max, step, rate, x: double;
function Format4(val:double):string;
begin
  val:=trunc(10000*val)/10000;
  result:=formatfloat('0.####', val);
end;
begin
  n0 := 0;
  n1 := 0;
  Result:=TStringList.Create;
  try
  if FInterfaceVersion>1 then begin
    GetScopeRates(n0, n1, @ax0r, @ax1r);
    if n0 >= 1 then
    begin
      for i := 0 to (n0 div 2) do
      begin
        min := ax0r[2 * i];
        max := ax0r[2 * i + 1];
        if min = max then
          Result.Add(Format4(min))
        else
        begin
          step := (max - min) / 3;
          for j := 0 to 3 do
          begin
            rate := min + j * step;
            if (i=0) and (rate = 0) and (max > 0.15) then
            begin  // add slow speed 2x ->32x sidereal
              Result.add('0.0083');  // 2x
              Result.add('0.0333');  // 8x
              Result.add('0.1333');  //32x
              x := step / 2;
              if step > 0.3 then
                Result.add(Format4(x));
            end
            else if rate > 0 then
              Result.add(Format4(rate));
          end;
        end;
      end;
    end;
  end;
  except
  end;
end;

procedure T_ascomrestmount.MoveAxis(axis: integer; rate: string);
begin
  if FStatus<>devConnected then exit;
  try
    if V.Get('canmoveaxis','Axis='+IntToStr(axis)).AsBool then
    begin
      V.Put('moveaxis',['Axis',IntToStr(axis),'Rate',rate]);
    end;
  except
    // unsupported by interface V1
  end;
end;

function T_ascomrestmount.GetTrackRate: TTrackRate;
var i: integer;
begin
  result:=trSidereal;
  try
    i:=V.Get('trackingrate').AsInt;
    result:=TTrackRate(i);
  except
    on E: Exception do msg('Cannot get mount tracking rate: ' + E.Message,0);
  end;
end;

procedure T_ascomrestmount.SetTrackRate(value: TTrackRate);
var i: integer;
begin
  try
  i:=ord(value);
  V.Put('TrackingRate',i);
  except
    on E: Exception do msg('Cannot set mount tracking rate: ' + E.Message,0);
  end;
end;

function T_ascomrestmount.GetMountRefraction: TMountRefraction;
begin
  try
  if V.Get('doesrefraction').AsBool then
    result:=refractTrue
  else
    result:=refractFalse;
  except
    result:=refractUnknown;
  end;
end;

end.

