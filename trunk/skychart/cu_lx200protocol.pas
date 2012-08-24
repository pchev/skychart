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
Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
}

{------------- interface for LX200 system. ----------------------------
Contribution from :
PJ Pallez Nov 1999
Patrick Chevalley Oct 2000
Renato Bonomini Jul 2004
Lazarus version, Patrick Chevalley Jun 2011
-------------------------------------------------------------------------------}

interface

Uses Dialogs,SysUtils,Classes,Forms,StrUtils,synaser ;

{basic LX200 functions}
Function LX200_Open(model,commport,baud,parity,data,stop,timeout,inttimeout : string) : boolean;
Function LX200_Close : boolean;
Function LX200_QueryEQ(var RA,DEC : double) : boolean;
Function LX200_QueryAZ(var Az,Al : double) : boolean;
Function LX200_Slew : boolean;
Function LX200_Goto(RA,DEC : double) : boolean;
Function LX200_Sync : boolean;
Function LX200_SyncPos( RA,DEC : double) : boolean;
Function LX200_SetObs( Lat,Long,TZ : double; datenow : Tdatetime) : boolean;
Function LX200_SetSpeed(speed : integer) : boolean;
Function LX200_Move(direction : integer) : boolean;
Function LX200_StopDir(direction : integer) : boolean;
Function LX200_StopMove : boolean;
Procedure LX200_SetFormat(format : integer);
Function LX200_SwitchHighPrecision : string;
Function LX200_QueryHighPrecision : string;
Function LX200_SetFocusSteep(speed:char):boolean;
Function LX200_StartFocus(dir:char):boolean;
Function LX200_StopFocus:boolean;
function LX200_SetTimeDate : boolean;
function LX200_Parkscope : boolean;
// Renato Bonomini:
Procedure LX200_SimpleCmd(cmd: string);
Function LX200_QueryGV(query: string; chartoread: integer) : string;
Function LX200_QueryFirmwareID : string;
Function LX200_QueryProductID : string;
Function LX200_QueryFirmwareTime : string;
Function LX200_QueryFirmwareDate : string;
Function LX200_QueryFirmwareNumber : string;
Procedure LX200_PecToggle;
Procedure LX200_FieldRotationOn;
Procedure LX200_FieldRotationOff;
Function LX200_GetTrackingRate : Single;
Function LX200_SetTrackingRateS(arcsec : Single): boolean;
Function LX200_SetTrackingRateT(arcsec : Single): boolean;
Procedure LX200_TrackingDefaultRate;
Procedure LX200_TrackingCustomRate;
Procedure LX200_TrackingLunarRate;
Procedure LX200_TrackingIncreaseRate;
Procedure LX200_TrackingDecreaseRate;
Procedure LX200_FanOn;
Procedure LX200_FanOff;
Procedure LX200_SlewSpeed(speed: integer);
Procedure LX200_GPS_SetGuideRate(rate: Single);
Procedure LX200_GPS_RASlewRate(rate: Single);
Procedure LX200_GPS_DECSlewRate(rate: Single);
// :$QA+ Enable Dec/Alt PEC [LX200gps only]
// :$QA- Enable Dec/Alt PEC [LX200gps only]
// :$QZ+ Enable RA/AZ PEC compensation [LX200gps only]
// :$QZ- Disable RA/AZ PEC Compensation [LX200gpgs only]
Procedure LX200_GPS_EnableDecPec;
Procedure LX200_GPS_EnableRAPec;
Procedure LX200_GPS_DisableDecPec;
Procedure LX200_GPS_DisableRAPec;

// Scope.exe custom commands:
Function LX200_Scope_HpLm:boolean;
Function LX200_Scope_HpRm:boolean;
Function LX200_Scope_Hp_Mode(smode:char):boolean;
Function LX200_Scope_GetGuideArcSec : Integer;
Function LX200_Scope_GetMsArcSec : Integer;
Procedure LX200_Scope_SetGuideArcSec(arcsec: Integer);
Procedure LX200_Scope_SetMsArcSec(arcsec: Integer);
Function LX200_Scope_GetFRAngle : Single;

Function DEToStr(de: Double; var d,m,s : string) : string;
Function ARToStr(ar: Double; var d,m,s : string) : string;
Function DEmToStr(de: Double; var d,m : string) : string;
Function ARmToStr(ar: Double; var d,m : string) : string;

const ValidPort='COM1 COM2 COM3 COM4 COM5 COM6 COM7 COM8';
      ValidModel :array[1..5] of string=('LX200','AutoStar','Magellan-II','Magellan-I','Scope.exe');
      NumModel = 5;
      crlf = chr(13)+chr(10);
var
{system flags and statuses}
  port_opened   : boolean;            // Interface is opened
  initialised:boolean;                // Last Init operation was successful
  LX200_model : string;               // actual model
  LX200_type  : integer = 0;          // kind of protocol to use
  LX200_mode : string;                // alignement mode
  LX200_format : integer;             // 0 : short , 1 : long
  LX200_opened,LX200_UseHPP : boolean;

const north=0; south=1; east=2; west=3;

implementation

Uses cu_serial;

var
  LX200_port : TBlockSerial;       // COM port synaser


Function PadZeros(x : string ; l :integer) : string;
const zero = '000000000000';
var p : integer;
begin
x:=trim(x);
p:=l-length(x);
result:=copy(zero,1,p)+x;
end;

Function sgn(x:Double):Double ;
begin
if x<0 then
   sgn:= -1
else
   sgn:=  1 ;
end ;

Function DEToStr(de: Double; var d,m,s : string) : string;
var dd,min1,min,sec: Double;
begin
    dd:=Int(de);
    min1:=abs(de-dd)*60;
    if min1>=59.99 then begin
       dd:=dd+sgn(de);
       min1:=0.0;
    end;
    min:=Int(min1);
    sec:=(min1-min)*60;
    if sec>=59.5 then begin
       min:=min+1;
       sec:=0.0;
    end;
    str(abs(dd):2:0,d);
    if abs(dd)<10 then d:='0'+trim(d);
    if de<0 then d:='-'+d else d:='+'+d;
    str(min:2:0,m);
    if abs(min)<10 then m:='0'+trim(m);
    str(sec:2:0,s);
    if abs(sec)<9.5 then s:='0'+trim(s);
    result := d+'°'+m+chr(39)+s+'"';
end;

Function ARToStr(ar: Double; var d,m,s : string) : string;
var dd,min1,min,sec: Double;
begin
    dd:=Int(ar);
    min1:=abs(ar-dd)*60;
    if min1>=59.999 then begin
       dd:=dd+sgn(ar);
       min1:=0.0;
    end;
    min:=Int(min1);
    sec:=(min1-min)*60;
    if sec>=59.95 then begin
       min:=min+1;
       sec:=0.0;
    end;
    str(dd:2:0,d);
    if abs(dd)<10 then d:='0'+trim(d);
    str(min:2:0,m);
    if abs(min)<10 then m:='0'+trim(m);
    str(sec:2:0,s);
    if abs(sec)<9.95 then s:='0'+trim(s);
    result := d+'h'+m+'m'+s+'s';
end;

Function DEmToStr(de: Double; var d,m : string) : string;
var dd,min: Double;
begin
    dd:=Int(de);
    min:=abs(de-dd)*60;
    if min>=59.5 then begin
       dd:=dd+sgn(de);
       min:=0.0;
    end;
    min:=Round(min);
    str(abs(dd):2:0,d);
    if abs(dd)<10 then d:='0'+trim(d);
    if de<0 then d:='-'+d else d:='+'+d;
    str(min:2:0,m);
    if abs(min)<10 then m:='0'+trim(m);
    result := d+'°'+m+chr(39);
end;

Function ARmToStr(ar: Double; var d,m : string) : string;
var dd,min: Double;
begin
    dd:=Int(ar);
    min:=abs(ar-dd)*60;
    if min>=59.5 then begin
       dd:=dd+sgn(ar);
       min:=0.0;
    end;
//    min:=Round(min);
    str(dd:2:0,d);
    if abs(dd)<10 then d:='0'+trim(d);
    str(min:4:1,m);
    if length(trim(m))<4 then m:='0'+trim(m);
    result := d+'h'+m+'m';
end;

//  LX-200 uses 9600 N 8 1
Function LX200_Open(model,commport,baud,parity,data,stop,timeout,inttimeout : string) : boolean;
var i,typ,count : integer;
    buf : string;
begin
result:=false;
{if (length(CommPort)<>4)or
   (pos(CommPort,ValidPort)=0)
   then begin ShowMessage('Invalid communication port : '+commport); exit; end;}
typ:=0;
for i:=1 to NumModel do if (pos(Model,ValidModel[i])>0) then typ:=i;
if typ=0 then begin ShowMessage('Unsupported encoder model : '+model); exit; end;
if port_opened then LX200_Close;
if OpenCom(LX200_port,commport,baud,parity,data,stop,timeout,inttimeout) then begin
   port_opened:=true;
   LX200_model:=model;
   LX200_type:=typ;
   PurgeBuffer(LX200_port);
   // check scope connected
   case LX200_type of
   5,1..2 : begin  // get DEC (change for FS2 with no ACK nor GC)
         buf:='#:GD#';
         count:=length(buf);
         if WriteCom(LX200_port,buf,count)= false then exit;
         count:=20;
         if ReadCom(LX200_port,buf,count) = false then exit;
         if count<6 then exit;
         buf:='P';
         LX200_mode:=buf;
         LX200_opened:=true;
         result:=true;
         end;
   3..4 : begin  // get date  for Magellan
         buf:='#:GC#';
         count:=length(buf);
         if WriteCom(LX200_port,buf,count)= false then exit;
         count:=9;
         if ReadCom(LX200_port,buf,count) = false then exit;
         if count<9 then exit;
         LX200_mode:='P';
         LX200_opened:=true;
         result:=true;
         end;
   end;
end else begin
   ShowMessage('Port '+commport+' cannot be opened!'+crlf+lx200_port.LastErrorDesc);
   LX200_opened:=false;
end;
end;

Procedure LX200_SetFormat(format : integer);
var count,f : integer;
    buf : string;
begin
   // Get format
   buf:='#:GD#';
   count:=length(buf);
   if WriteCom(LX200_port,buf,count)= false then exit;
   count:=20;
   if ReadCom(LX200_port,buf,count) = false then exit;
   if length(trim(buf))>7 then f:=1 else f:=0;
   if f<>format then begin
       buf:='#:U#';          // switch format
       count:=length(buf);
       if WriteCom(LX200_port,buf,count)= false then exit;
   end;
   LX200_format:=format;
end;

Function LX200_Close : boolean;
begin
CloseCom(LX200_port);
port_opened:=false;
LX200_opened:=false;
LX200_model:='';
LX200_mode:='';
LX200_type:=0;
result:=true;
end;

Function LX200_QueryEQ(var RA,DEC : double) : boolean;
var buf : string;
    a,b,c : double;
    count,p,i : integer;
begin
result:=false;
case LX200_type of
  2 : begin       // Autostar, some model have problem to respond to the double command
    buf:='#:GR#';
    count:=length(buf);
    PurgeBuffer(LX200_port);
    if WriteCom(LX200_port,buf,count)= false then exit;
    count:=20;
    if ReadCom(LX200_port,buf,count) = false then exit;
    case LX200_format of
    0 : begin
        //1234567890123456
        //+HH:MM.M#
        //03:21.7#
        i:=pos(':',buf);
        val(copy(buf,1,i-1),a,p); if p>0 then exit;
        buf:=copy(buf,i+1,999);
        i:=pos('#',buf);
        val(copy(buf,1,i-1),b,p); if p>0 then exit;
        RA:=15*(a+b/60);
        end;
    1 : begin
        //1234567890123456
        //06:07:58#
        i:=pos(':',buf);
        val(copy(buf,1,i-1),a,p); if p>0 then exit;
        buf:=copy(buf,i+1,999);
        i:=pos(':',buf);
        val(copy(buf,1,i-1),b,p); if p>0 then exit;
        buf:=copy(buf,i+1,999);
        i:=pos('#',buf);
        val(copy(buf,1,i-1),c,p); if p>0 then exit;
        RA:=15*(a+b/60+c/3600);
        end;
    end;
    buf:='#:GD#';
    count:=length(buf);
    PurgeBuffer(LX200_port);
    if WriteCom(LX200_port,buf,count)= false then exit;
    count:=20;
    if ReadCom(LX200_port,buf,count) = false then exit;
    case LX200_format of
    0 : begin
        //1234567890123456
        //-DD*MM#
        //+30ß02#
        val(copy(buf,2,2),a,p); if p>0 then exit;
        val(copy(buf,5,2),b,p); if p>0 then exit;
        DEC:=a+b/60;
        if copy(buf,1,1)='-' then DEC:=-DEC;
        end;
    1 : begin
        //1234567890123456
        //+19ß46:02d#
        val(copy(buf,2,2),a,p); if p>0 then exit;
        val(copy(buf,5,2),b,p); if p>0 then exit;
        val(copy(buf,8,2),c,p); if p>0 then exit;
        DEC:=a+b/60+c/3600;
        if copy(buf,1,1)='-' then DEC:=-DEC;
        end;
    end;
  end;
  else begin          // LX200, Magellan
  buf:='#:GR#:GD#';
  count:=length(buf);
  PurgeBuffer(LX200_port);
  if WriteCom(LX200_port,buf,count)= false then exit;
  count:=20;
  if ReadCom(LX200_port,buf,count) = false then exit;
  case LX200_format of
  0 : begin
      //1234567890123456
      //+HH:MM.M#-DD*MM#
      //03:21.7#+30ß02#
      i:=pos(':',buf);
      val(copy(buf,1,i-1),a,p); if p>0 then exit;
      buf:=copy(buf,i+1,999);
      i:=pos('#',buf);
      val(copy(buf,1,i-1),b,p); if p>0 then exit;
      RA:=15*(a+b/60);
      buf:=copy(buf,i+1,999);
      val(copy(buf,2,2),a,p); if p>0 then exit;
      val(copy(buf,5,2),b,p); if p>0 then exit;
      DEC:=a+b/60;
      if copy(buf,1,1)='-' then DEC:=-DEC;
      end;
  1 : begin
      //1234567890123456
      //06:07:58#+19ß46:02d#
      i:=pos(':',buf);
      val(copy(buf,1,i-1),a,p); if p>0 then exit;
      buf:=copy(buf,i+1,999);
      i:=pos(':',buf);
      val(copy(buf,1,i-1),b,p); if p>0 then exit;
      buf:=copy(buf,i+1,999);
      i:=pos('#',buf);
      val(copy(buf,1,i-1),c,p); if p>0 then exit;
      RA:=15*(a+b/60+c/3600);
      buf:=copy(buf,i+1,999);
      val(copy(buf,2,2),a,p); if p>0 then exit;
      val(copy(buf,5,2),b,p); if p>0 then exit;
      val(copy(buf,8,2),c,p); if p>0 then exit;
      DEC:=a+b/60+c/3600;
      if copy(buf,1,1)='-' then DEC:=-DEC;
      end;
  end;
  end;
end;
result:=true;
end;

Function LX200_QueryAZ(var Az,Al : double) : boolean;
var buf : string;
    a,b,c : double;
    count,p : integer;
begin
result:=false;
case LX200_type of
2 : begin       // Autostar, some model have problem to respond to the double command
buf:='#:GZ#';
count:=length(buf);
PurgeBuffer(LX200_port);
if WriteCom(LX200_port,buf,count)= false then exit;
count:=20;
if ReadCom(LX200_port,buf,count) = false then exit;
case LX200_format of
0 : begin
    //1234567890123456
    //DDD*MM#
    val(copy(buf,1,3),a,p); if p>0 then exit;
    val(copy(buf,5,2),b,p); if p>0 then exit;
    Az:=a+b/60;
    end;
1 : begin
    //1234567890123456789
    //311ß52:05#
    val(copy(buf,1,3),a,p); if p>0 then exit;
    val(copy(buf,5,2),b,p); if p>0 then exit;
    val(copy(buf,8,2),c,p); if p>0 then exit;
    Az:=a+b/60+c/3600;
    end;
end;
buf:='#:GA#';
count:=length(buf);
PurgeBuffer(LX200_port);
if WriteCom(LX200_port,buf,count)= false then exit;
count:=20;
if ReadCom(LX200_port,buf,count) = false then exit;
case LX200_format of
0 : begin
    //1234567890123456
    //-DD*MM#
    val(copy(buf,2,2),a,p); if p>0 then exit;
    val(copy(buf,5,2),b,p); if p>0 then exit;
    Al:=a+b/60;
    if copy(buf,1,1)='-' then Al:=-Al;
    end;
1 : begin
    //1234567890123456789
    //+19ß46:10#
    val(copy(buf,2,2),a,p); if p>0 then exit;
    val(copy(buf,5,2),b,p); if p>0 then exit;
    val(copy(buf,8,2),c,p); if p>0 then exit;
    Al:=a+b/60+c/3600;
    if copy(buf,1,1)='-' then Al:=-Al;
    end;
end;
end;
else begin          // LX200, Magellan, scope
buf:='#:GZ#:GA#';
count:=length(buf);
PurgeBuffer(LX200_port);
if WriteCom(LX200_port,buf,count)= false then exit;
count:=20;
if ReadCom(LX200_port,buf,count) = false then exit;
case LX200_format of
0 : begin
    //1234567890123456
    //DDD*MM#-DD*MM#
    val(copy(buf,1,3),a,p); if p>0 then exit;
    val(copy(buf,5,2),b,p); if p>0 then exit;
    Az:=a+b/60;
    val(copy(buf,9,2),a,p); if p>0 then exit;
    val(copy(buf,12,2),b,p); if p>0 then exit;
    Al:=a+b/60;
    if copy(buf,8,1)='-' then Al:=-Al;
    end;
1 : begin
    //1234567890123456789
    //311ß52:05#+19ß46:10#
    val(copy(buf,1,3),a,p); if p>0 then exit;
    val(copy(buf,5,2),b,p); if p>0 then exit;
    val(copy(buf,8,2),c,p); if p>0 then exit;
    Az:=a+b/60+c/3600;
    val(copy(buf,12,2),a,p); if p>0 then exit;
    val(copy(buf,15,2),b,p); if p>0 then exit;
    val(copy(buf,18,2),c,p); if p>0 then exit;
    Al:=a+b/60+c/3600;
    if copy(buf,11,1)='-' then Al:=-Al;
    end;
end;
end;
end;
result:=true;
end;

Function LX200_Pos(var RA,DEC : double) : boolean;
var buf,s1,s2,s3 : string;
    count : integer;
begin
result:=false;
RA:=RA/15;
case LX200_type of
2 : begin       // Autostar, some model have problem to respond to the double command
case LX200_format of
0 : begin
    armtostr(ra,s1,s2);
    buf:='#:Sr '+s1+':'+s2+'#';
    count:=length(buf);
    PurgeBuffer(LX200_port);
    if WriteCom(LX200_port,buf,count)= false then exit;
    count:=20;
    if ReadCom(LX200_port,buf,count) = false then exit;
    if trim(buf)='0' then exit;
    demtostr(dec,s1,s2);
    buf:='#:Sd '+s1+chr(223)+s2+'#';
    count:=length(buf);
    PurgeBuffer(LX200_port);
    if WriteCom(LX200_port,buf,count)= false then exit;
    count:=20;
    if ReadCom(LX200_port,buf,count) = false then exit;
    if trim(buf)='0' then exit;
    end;
1 : begin
    artostr(ra,s1,s2,s3);
    buf:='#:Sr '+s1+':'+s2+':'+s3+'#';
    count:=length(buf);
    PurgeBuffer(LX200_port);
    if WriteCom(LX200_port,buf,count)= false then exit;
    count:=20;
    if ReadCom(LX200_port,buf,count) = false then exit;
    if trim(buf)='0' then exit;
    detostr(dec,s1,s2,s3);
    buf:='#:Sd '+s1+chr(223)+s2+':'+s3+'#';
    count:=length(buf);
    PurgeBuffer(LX200_port);
    if WriteCom(LX200_port,buf,count)= false then exit;
    count:=20;
    if ReadCom(LX200_port,buf,count) = false then exit;
    if trim(buf)='0' then exit;
    end;
end;
end;
else begin          // LX200, Magellan
case LX200_format of
0 : begin
    armtostr(ra,s1,s2);
    buf:='#:Sr '+s1+':'+s2+'#:Sd ';
    demtostr(dec,s1,s2);
    buf:=buf+s1+chr(223)+s2+'#';
    count:=length(buf);
    PurgeBuffer(LX200_port);
    if WriteCom(LX200_port,buf,count)= false then exit;
    count:=20;
    ReadCom(LX200_port,buf,count);
    if trim(buf)='00' then exit;
    end;
1 : begin
    artostr(ra,s1,s2,s3);
    buf:='#:Sr '+s1+':'+s2+':'+s3+'#:Sd ';
    detostr(dec,s1,s2,s3);
    buf:=buf+s1+chr(223)+s2+':'+s3+'#';
    count:=length(buf);
    PurgeBuffer(LX200_port);
    if WriteCom(LX200_port,buf,count)= false then exit;
    count:=20;
    if ReadCom(LX200_port,buf,count) = false then exit;
    if trim(buf)='00' then exit;
    end;
end;
end;
end;
result:=true;
end;

Function LX200_Slew : boolean;
var buf : string;
    count : integer;
begin
result:=false;
PurgeBuffer(LX200_port);
    // slew to current object
    buf:='#:MS#';
    count:=length(buf);
    if WriteCom(LX200_port,buf,count)= false then exit;
    count:=50;
    if ReadCom(LX200_port,buf,count) = false then exit;
result:=true;
end;

Function LX200_Goto(RA,DEC : double) : boolean;
begin
result:=false;
// set object position
if not LX200_Pos(RA,DEC) then exit;
// slew to object
if not LX200_Slew then exit;
result:=true;
end;

Function LX200_Sync : boolean;
var buf : string;
    count : integer;
begin
result:=false;
PurgeBuffer(LX200_port);
    buf:='#:CM#';
    count:=length(buf);
    if WriteCom(LX200_port,buf,count)= false then exit;
    count:=50;
    if ReadCom(LX200_port,buf,count) = false then exit;
result:=true;
end;

Function LX200_SyncPos( RA,DEC : double) : boolean;
begin
result:=false;
PurgeBuffer(LX200_port);
    // set object position
    if not LX200_Pos(RA,DEC) then exit;
    // sync object
    if not LX200_Sync then exit;
result:=true;
end;

Function LX200_SetObs( Lat,Long,TZ : double; datenow : Tdatetime) : boolean;
begin
result:=true;
end;

Function LX200_SetSpeed(speed : integer) : boolean;
var count : integer;
    buf : string;
begin
result:=false;
PurgeBuffer(LX200_port);
case LX200_type of
5,1 : begin // LX200 + scope.exe
    buf:='#:R';
    case speed of
    0 : buf:=buf+'S#';
    1 : buf:=buf+'M#';
    2 : buf:=buf+'C#';
    3 : buf:=buf+'G#';
    else exit;
    end;
    end;
2 : begin // Autostar
    case speed of
    0 : buf:='#:Sw4#';
    1 : buf:='#:Sw3#';
    2 : buf:='#:Sw2#';
    3 : buf:='#:Sw2#';
    else exit;
    end;
    end;
end;
count:=length(buf);
if WriteCom(LX200_port,buf,count)= false then exit;
result:=true;
end;

Function LX200_Move(direction : integer) : boolean;
var count : integer;
    buf : string;
begin
result:=false;
PurgeBuffer(LX200_port);
    buf:='#:M';
    case direction of
    north : buf:=buf+'n#';
    south : buf:=buf+'s#';
    east  : buf:=buf+'e#';
    west  : buf:=buf+'w#';
    else exit;
    end;
    count:=length(buf);
    if WriteCom(LX200_port,buf,count)= false then exit;
result:=true;
end;

Function LX200_StopDir(direction : integer) : boolean;
var count : integer;
    buf : string;
begin
result:=false;
PurgeBuffer(LX200_port);
case LX200_type of
5,1 : begin // LX200
    buf:='#:Q';
    case direction of
    north : buf:=buf+'n#';
    south : buf:=buf+'s#';
    east  : buf:=buf+'e#';
    west  : buf:=buf+'w#';
    else buf:=buf+'#';
    end;
    end;
2 : begin // Autostar
    buf:='#:Q#';
    end;
end;
count:=length(buf);
if WriteCom(LX200_port,buf,count)= false then exit;
result:=true;
end;

Function LX200_StopMove : boolean;
var count : integer;
    buf : string;
begin
result:=false;
    buf:='#:Q#:Qn#:Qs#:Qe#:Qw#';
    count:=length(buf);
    if WriteCom(LX200_port,buf,count)= false then exit;
result:=true;
end;

Function LX200_QueryHighPrecision : string;
var buf : string;
    i,count : integer;
begin
result:='Error';
PurgeBuffer(LX200_port);
for i:=1 to 2 do begin
    buf:='#:P#';
    count:=length(buf);
    if WriteCom(LX200_port,buf,count)= false then exit;
    count:=50;
    if ReadCom(LX200_port,buf,count) = false then exit;
end;
// buf:='HIGH PRECISION  ';
result:=trim(buf);
LX200_UseHPP:=result='HIGH PRECISION';
end;

Function LX200_SwitchHighPrecision : string;
var buf : string;
    count : integer;
begin
result:='Error';
PurgeBuffer(LX200_port);
    buf:='#:P#';
    count:=length(buf);
    if WriteCom(LX200_port,buf,count)= false then exit;
    count:=50;
    if ReadCom(LX200_port,buf,count) = false then exit;
result:=trim(buf);
LX200_UseHPP:=result='HIGH PRECISION';
end;

Function LX200_QueryGV(query: string; chartoread: integer) : string;
var count : integer;
begin
// Renato Bonomini:
result:='Error';
PurgeBuffer(LX200_port);
count:=length(query);
if WriteCom(LX200_port,query,count)= false then exit;
if ReadCom(LX200_port,query,chartoread) = false then exit;
Result:=trim(LeftStr(query, length(query)-1));
end;

Function LX200_QueryFirmwareID : string;
var count : integer;
character: string;
query: string;
maxtries: integer;
begin
// GVF variabile string length:
query:=':GVF#';
result:='Error';
PurgeBuffer(LX200_port);
count:=length(query);
if WriteCom(LX200_port,query,count)= false then exit;
// Read one character at a time, max characters 20,
// read until we receive a #
PurgeBuffer(LX200_port);
count:=1;
character:='';
query:='';
maxtries:=0;
while (character <> '#') and (maxtries <20) do
begin
        if ReadCom(LX200_port,character,count) = false then exit;
        query:=query+character;
        maxtries:=maxtries+1;
end;
Result:=trim(LeftStr(query, maxtries-1));
end;

Function LX200_QueryProductID : string;
var count : integer;
character: string;
query: string;
maxtries: integer;
begin
// GVP variabile string length:
query:=':GVP#';
result:='Error';
PurgeBuffer(LX200_port);
count:=length(query);
if WriteCom(LX200_port,query,count)= false then exit;
// Read one character at a time, max characters 20,
// read until we receive a #
PurgeBuffer(LX200_port);
count:=1;
character:='';
query:='';
maxtries:=0;
while (character <> '#') and (maxtries <20) do
begin
        if ReadCom(LX200_port,character,count) = false then exit;
        query:=query+character;
        maxtries:=maxtries+1;
end;
Result:=trim(LeftStr(query, maxtries-1));
end;

Function LX200_QueryFirmwareDate : string;
begin
// Renato Bonomini:
// GVD Get Telescope Firmware Date
Result:=LX200_QueryGV(':GVD#',12);
end;

Function LX200_QueryFirmwareNumber : string;
begin
// Renato Bonomini:
// GVD Get Telescope Firmware Number
Result:=LX200_QueryGV(':GVN#',5);
end;

Function LX200_QueryFirmwareTime : string;
begin
// Renato Bonomini:
// GVD Get Telescope Firmware Time
Result:=LX200_QueryGV(':GVT#',9);
end;

Function LX200_SetFocusSteep(speed:char):boolean;
var count : integer;
    buf : string;
begin
// standard lx200 :      speed = (F,S)
// lx200gps, autostar :  speed = (1,2,3,4)
buf:='#:F'+speed+'#';
count:=length(buf);
result:=WriteCom(LX200_port,buf,count);
end;

Function LX200_StartFocus(dir:char):boolean;
var count : integer;
    buf : string;
begin
// dir = (+,-)
buf:='#:F'+dir+'#';
count:=length(buf);
result:=WriteCom(LX200_port,buf,count);
end;

Function LX200_StopFocus:boolean;
var count : integer;
    buf : string;
begin
buf:='#:FQ#';
count:=length(buf);
result:=WriteCom(LX200_port,buf,count);
end;

function LX200_SetTimeDate : boolean;
var count : integer;
    buf, dt, tm, tz, site, saved, savet : string;
label exit;
begin
  saved := DefaultFormatSettings.ShortDateFormat;
  savet := DefaultFormatSettings.ShortTimeFormat;
  try
        result:=false;
        PurgeBuffer(LX200_port);

        //Set Date
        DefaultFormatSettings.ShortDateFormat := 'mm/dd/yy';
        buf := '#:SC '+DateToStr(Date)+'#';
        count:=length(buf);
        if WriteCom(LX200_port,buf,count)= false then goto exit;
        // read ok response
        count:=1;
        ReadCom(LX200_port,buf,count);
        // read planetary update response
        count:=50;
        ReadCom(LX200_port,buf,count);
        count:=50;
        ReadCom(LX200_port,buf,count);

        //Set Time
        DefaultFormatSettings.ShortTimeFormat := 'hh:mm:ss';
        buf := '#:SL '+TimeToStr(Time)+'#';
        count:=length(buf);
        if WriteCom(LX200_port,buf,count)= false then goto exit;
        count:=1;
        ReadCom(LX200_port,buf,count);

        //Clean buffer
        PurgeBuffer(LX200_port);

        //Get from scope: site, date and time
        buf := '#:GM#';
        count:=length(buf);
        if WriteCom(LX200_port,buf,count)= false then goto exit;
        count := 50;
        if ReadCom(LX200_port,site,count) = false then goto exit;
        site := stringreplace(trim(site),'#','',[rfReplaceAll]);

        buf := '#:GC#';
        count:=length(buf);
        if WriteCom(LX200_port,buf,count)= false then goto exit;
        count := 10;
        if ReadCom(LX200_port,dt,count) = false then goto exit;
        dt := stringreplace(trim(dt),'#','',[rfReplaceAll]);

        buf := '#:GL#';
        count:=length(buf);
        if WriteCom(LX200_port,buf,count)= false then goto exit;
        count := 10;
        if ReadCom(LX200_port,tm,count) = false then goto exit;
        tm := stringreplace(trim(tm),'#','',[rfReplaceAll]);

        buf := '#:GG#';
        count:=length(buf);
        if WriteCom(LX200_port,buf,count)= false then goto exit;
        count := 10;
        if ReadCom(LX200_port,tz,count) = false then goto exit;
        tz := stringreplace(trim(tz),'#','',[rfReplaceAll]);

        result := true;
        ShowMessage('Telescope setting is now:'+crlf+'Site: ' + site + crlf+'Date: ' + dt + crlf+'Time: ' + tm +crlf+'Time zone: ' + tz+ '.');
exit:
finally
  DefaultFormatSettings.ShortDateFormat := saved;
  DefaultFormatSettings.ShortTimeFormat := savet;
end;
end;

function LX200_Parkscope : boolean;
var buf : string;
    count : integer;
begin
 result := false;
 buf := '#:hP#';
 count:=length(buf);
 if WriteCom(LX200_port,buf,count) = false then exit;
 result := true;
end;

Procedure LX200_SimpleCmd(cmd: string);
// Renato Bonomini:
// Executes simple commands
var count : integer;
begin
PurgeBuffer(LX200_port);
count:=length(cmd);
if WriteCom(LX200_port,cmd,count)= false then exit;
end;

Procedure LX200_PecToggle;
// Toggles Pec condition on both drives
begin
LX200_SimpleCmd(':$Q#');
end;

Procedure LX200_FieldRotationOn;
// Turns field rotation on
begin
LX200_SimpleCmd(':r+#');
end;

Procedure LX200_FieldRotationOff;
// Turns field rotation off
begin
LX200_SimpleCmd(':r-#');
end;

Function LX200_SetTrackingRateS(arcsec : Single): boolean;
var buf : string;
    arcsecstr : string;
    count : integer;
begin
Result:=False;
PurgeBuffer(LX200_port);
// :SDDD.D# format
arcsecstr:=PadZeros(Format('%4.1f',[ arcsec]),5);
buf:='#:S'+arcsecstr+'#';
count:=length(buf);
if WriteCom(LX200_port,buf,count) = false then exit;
// Read response 1 or 0
count:=1;
if ReadCom(LX200_port,buf,count) = false then exit;
if buf='1' then Result := True;
end;

Function LX200_SetTrackingRateT(arcsec : Single): boolean;
var buf : string;
    arcsecstr : string;
    count: integer;
begin
Result:=False;
PurgeBuffer(LX200_port);
// :TDDD.DDD# format
arcsecstr:=PadZeros(Format('%6.3f', [arcsec]),7);
buf:='#:T'+arcsecstr+'#';
count:=length(buf);
if WriteCom(LX200_port,buf,count) = false then exit;
// Read response 1 or 0
count:=1;
if ReadCom(LX200_port,buf,count) = false then exit;
if buf='1' then Result := True;
end;

Function LX200_GetTrackingRate: Single;
var buf : string;
    count : integer;
begin
result:=-1;
PurgeBuffer(LX200_port);
buf:=':GT#';
count:=length(buf);
if WriteCom(LX200_port,buf,count)= false then exit;
count:=5;
if ReadCom(LX200_port,buf,count) = false then exit;
Result:=StrToFloat(LeftStr(trim(buf),4));
end;

Procedure LX200_TrackingDefaultRate;
// Sets default tracking rate, 60Hz
begin
LX200_SimpleCmd(':TQ#');
end;

Procedure LX200_TrackingCustomRate;
// Sets custom tracking rate
begin
LX200_SimpleCmd(':TM#');
end;

Procedure LX200_TrackingLunarRate;
// Sets selenic tracking rate
begin
LX200_SimpleCmd(':TL#');
end;

Procedure LX200_TrackingIncreaseRate;
// increase tracking rate 1Hz
begin
LX200_SimpleCmd(':T+#');
end;

Procedure LX200_TrackingDecreaseRate;
// decrease tracking rate 1Hz
begin
LX200_SimpleCmd(':T-#');
end;

Procedure LX200_FanOn;
// Turns Fan On (16" Only)
begin
LX200_SimpleCmd(':f+#');
end;
Procedure LX200_FanOff;
// Turns Fan Off (16" Only)
begin
LX200_SimpleCmd(':f-#');
end;

Procedure LX200_SlewSpeed(speed: integer);
// Sends Sw1 .. Sw4 to change slew speed
begin
LX200_SimpleCmd(':Sw'+IntToStr(speed)+'#');
end;

Procedure LX200_GPS_SetGuideRate(rate: Single);
// Set Guide rate on LX200GPS
// :RgSS.S# format
var buf : string;
    arcsecstr : string;
    count: integer;
begin
PurgeBuffer(LX200_port);
arcsecstr:=PadZeros(Format('%3.1f', [rate]),4);
buf:='#:Rg'+arcsecstr+'#';
count:=length(buf);
if WriteCom(LX200_port,buf,count) = false then exit;
end;

Procedure LX200_GPS_RASlewRate(rate: Single);
// Set RA Slew rate on LX200GPS
// :RADD.D# format
var buf : string;
    arcsecstr : string;
    count: integer;
begin
PurgeBuffer(LX200_port);
arcsecstr:=PadZeros(Format('%3.1f', [rate]),4);
buf:='#:RA'+arcsecstr+'#';
count:=length(buf);
if WriteCom(LX200_port,buf,count) = false then exit;
end;

Procedure LX200_GPS_DECSlewRate(rate: Single);
// Set DEC Slew rate on LX200GPS
// :REDD.D# format
var buf : string;
    arcsecstr : string;
    count: integer;
begin
PurgeBuffer(LX200_port);
arcsecstr:=PadZeros(Format('%3.1f', [rate]),4);
buf:='#:RE'+arcsecstr+'#';
count:=length(buf);
if WriteCom(LX200_port,buf,count) = false then exit;
end;

Procedure LX200_GPS_EnableDecPec;
// :$QA+ Enable Dec/Alt PEC [LX200gps only]
begin
LX200_SimpleCmd(':$QA+#');
end;

Procedure LX200_GPS_EnableRAPec;
// :$QZ+ Enable RA/AZ PEC compensation [LX200gps only]
begin
LX200_SimpleCmd(':$QZ+#');
end;

Procedure LX200_GPS_DisableDecPec;
// :$QA- Disable Dec/Alt PEC [LX200gps only]
begin
LX200_SimpleCmd(':$QA-#');
end;

Procedure LX200_GPS_DisableRAPec;
// :$QZ- Disable RA/AZ PEC Compensation [LX200gpgs only]
begin
LX200_SimpleCmd(':$QZ-#');
end;


///////////////////////////////////////////////
// Scope.exe custom lx-200 protocol commands //
///////////////////////////////////////////////

Function LX200_Scope_HpRm:boolean;
// Renato Bonomini:
// Simulates Right mode
var count : integer;
    buf : string;
begin
PurgeBuffer(LX200_port);
buf:='#:XHR#';
count:=length(buf);
result:=WriteCom(LX200_port,buf,count);
end;

Function LX200_Scope_HpLm:boolean;
// Renato Bonomini:
// Simulates Left mode
var count : integer;
    buf : string;
begin
PurgeBuffer(LX200_port);
buf:='#:XHL#';
count:=length(buf);
result:=WriteCom(LX200_port,buf,count);
end;

Function LX200_Scope_Hp_Mode(smode:char):boolean;
// Renato Bonomini:
// Simulates selected mode
var count : integer;
    buf : string;
begin
PurgeBuffer(LX200_port);
buf:='#:XH'+smode+'#';
count:=length(buf);
result:=WriteCom(LX200_port,buf,count);
end;

Function LX200_Scope_GetMsArcSec : Integer;
// Renato Bonomini:
// XGM Get MsArcSec
var buf : string;
    count : integer;
begin
result:=-1;
PurgeBuffer(LX200_port);
buf:='#:XGM#';
count:=length(buf);
if WriteCom(LX200_port,buf,count)= false then exit;
count:=5;
if ReadCom(LX200_port,buf,count) = false then exit;
Result:=StrToIntDef(LeftStr(trim(buf),4),0);
end;

Function LX200_Scope_GetGuideArcSec : Integer;
// Renato Bonomini:
// XGG Get GuideArcSec
var buf : string;
    count : integer;
begin
result:=-1;
PurgeBuffer(LX200_port);
buf:='#:XGG#';
count:=length(buf);
if WriteCom(LX200_port,buf,count)= false then exit;
count:=5;
if ReadCom(LX200_port,buf,count) = false then exit;
Result:=StrToIntDef(LeftStr(trim(buf),4),0);
end;

Procedure LX200_Scope_SetGuideArcSec(arcsec: Integer);
// Renato Bonomini:
// XSGnnnn set GuideArcSec in nnnn
var buf : string;
    arcsecstr : string;
begin
PurgeBuffer(LX200_port);
arcsecstr:=PadZeros(InttoStr(arcsec),4);
buf:='#:XSG'+arcsecstr+'#';
LX200_SimpleCmd(buf);
end;

Procedure LX200_Scope_SetMsArcSec(arcsec: Integer);
// Renato Bonomini:
// XSMnnnn set MsArcSec in nnnn
var buf : string;
    arcsecstr : string;
begin
PurgeBuffer(LX200_port);
arcsecstr:=PadZeros(InttoStr(arcsec),4);
buf:='#:XSM'+arcsecstr+'#';
LX200_SimpleCmd(buf);
end;

Function LX200_Scope_GetFRAngle : Single;
// Renato Bonomini:
// XGR Get FR angle
var buf : string;
    count : integer;
begin
result:=-1;
PurgeBuffer(LX200_port);
buf:=':XGR#';
count:=length(buf);
if WriteCom(LX200_port,buf,count)= false then exit;
count:=7;
if ReadCom(LX200_port,buf,count) = false then exit;
//ShowMessage(buf);
Result:=StrToFloat(LeftStr(trim(buf),6));
end;

end.
