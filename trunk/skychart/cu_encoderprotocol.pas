unit cu_encoderprotocol;

{$MODE Delphi}

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


Modified Sept 21, 2004 by G. Carpenter for support of Orion Intelliscope
Object locator.  Changes marked with ####
Also modified the encoder.dfm
This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

****************************************************************}

interface

Uses u_constant, synaser, Dialogs,SysUtils,Classes ;

{basic encoder functions}
Function Encoder_Open(model,commport,baud,parity,data,stop,timeout,inttimeout : string) : boolean;
Function Encoder_Close : boolean;
Function Encoder_Query(var Xpos,Ypos : integer) : boolean;
Function Encoder_Set_Resolution(Xres,Yres : integer) : boolean;
Function Encoder_Init(Xpos,Ypos : integer) : boolean;
Function Encoder_Set_Init_Flag : boolean;
Function Encoder_Get_Init_Flag(var initflag : string): boolean;
Function GetDeviceStatus(var ex,ey : integer; var batteryOK : boolean) : boolean;

const ValidPort='COM1 COM2 COM3 COM4 COM5 COM6 COM7 COM8';
      ValidModel :array[1..4] of string=('Tangent Ouranos MicroGuider','NGC-MAX' ,'AAM SkyVector Discovery','Intelliscope');
      NumModel = 4;
      max_error = 10;
var
{system flags and statuses}
  port_opened   : boolean;            // Interface is opened
  initialised:boolean;                // Last Init operation was successful
  resolution_sent:boolean;            // Encoder resolution was sent
  encoder_model : string;             // actual encoder model
  encoder_type  : integer;            // kind of protocol to use
  reso_x, reso_y:integer;             // encoders resolution in steps
  num_error  : integer;               // number of error encountered form last success
{Init parameters}
  last_init:string;                   // last time an Init was performed
  last_init_target:string;            // last target's name
  last_init_alpha:double;             // last target's alpha
  last_init_delta:double;             // last target's delta
  init_x,init_y:integer;              // Init target (in steps)
  init_objects:tlist;                 // List to store Initialisation objects coordinates
  Alpha_Inversion : boolean;          // Encoder direction x
  Delta_Inversion : boolean;          // Encoder direction y
{Current values}
  curdeg_x,  curdeg_y :double;        // current equatorial position in degrees
  cur_az,  cur_alt :double;           // current alt-az position in degrees
  curstep_x, curstep_y:integer;       // current position in steps
  scaling_x:double;                   // how much is one step in degrees (alpha axis)
  scaling_y:double;                   // ...                             (delta axis)
  Sideral_Time : Double;              // Current sideral time
  Longitude : Double;                 // Observatory longitude (Negative East of Greenwich}
  Latitude : Double;                  // Observatory latitude
  Last_p1, Last_p2 : PInit_object;              // Last used init star

const tab=chr(9);
      cr =chr(13);

implementation

Uses cu_serial, pu_encoderclient;

var
  encoder_port  : Tblockserial;            // COM port file handle


function pad_zeros(num:integer):string;
var i:integer;
    sgn,str:string;
begin
case encoder_type of
1,2,3,4 : begin
     if num < 0 then sgn:='-' else sgn:='+';
     str:=inttostr(abs(num));
     if length(str) = 1 then result:=sgn+'0000'+str;
     if length(str) > 1 then
     begin
          for i:=1 to 5-length(str) do result:=result+'0';
          result:=sgn+result+str;
     end;
    end;
end;
end;

Function Encoder_Open(model,commport,baud,parity,data,stop,timeout,inttimeout : string) : boolean;
var i,typ : integer;
begin
result:=false;
typ:=0;
for i:=1 to NumModel do if (pos(Model,ValidModel[i])>0) then typ:=i;
if typ=0 then begin {ShowMessage('Unsupported encoder model : '+model);} exit; end;
if port_opened then Encoder_Close;
if debug then writeserialdebug(FormatDateTime('hh:mm:ss.zzz',now)+' Model  : '+model);
if OpenCom(encoder_port,commport,baud,parity,data,stop,timeout,inttimeout) then begin
   port_opened:=true;
   encoder_model:=model;
   encoder_type:=typ;
   result:=true;
   num_error:=0;
end else begin
//   ShowMessage('Port '+commport+' cannot be opened!');
end;
end;

Function Encoder_Close : boolean;
begin
CloseCom(encoder_port);
port_opened:=false;
encoder_model:='';
encoder_type:=0;
result:=true;
end;

Function Encoder_Query(var Xpos,Ypos : integer) : boolean;
var buf,a,b: string;						
    count,p : integer;
begin
result:=false;
PurgeBuffer(encoder_port);
case encoder_type of
1,2,3,4 : begin
    buf:='Q';
   
    count:=length(buf);
    if WriteCom(encoder_port,buf,count)= false then exit;
    count:=14;
    if ReadCom(encoder_port,buf,count) = false then begin; Affmsg('Encoder_Query : Read error'); exit; end;

    p:= pos('Q',buf);                                     // #### test is leading character is xmit character then intelliscope
    if p>0 then begin    // trim for intelliscope	      // #### HERE's the modifications for the intelliscope protocol
	 buf:=trim(copy(buf,2,count-1));                        // #### it strips off the leading Q Character
	 count:=count-1;							// #### shortens the count for the buffer by one so rest driver is not affected
    end;								       

    p:=pos(tab,buf);
    if p>0 then begin // Ouranos tab separated
      a:=trim(copy(buf,1,p-1));                              

     
      buf:=copy(buf,p+1,99);
      p:=pos(cr,buf); if p=0 then p:=99;
      b:=trim(copy(buf,1,p-1));
    end else begin    // other like AAM  +00000<space>+00000<cr>
      a:=trim(copy(buf,1,6));
      b:=trim(copy(buf,8,6));
    end;
    val(a,Xpos,p); if p>0 then begin; Affmsg('Encoder_Query : Alpha error "'+a+'"'); exit; end;
    val(b,Ypos,p); if p>0 then begin; Affmsg('Encoder_Query : Delta error "'+b+'"'); exit; end;
    result:=true;
    num_error:=0;
    end;
end;
end;

Function Encoder_Set_Resolution(Xres,Yres : integer) : boolean;
var buf : string;
    count : integer;
begin
result:=false;
PurgeBuffer(encoder_port);
case encoder_type of
1,2 : begin  // Ouranos , NGC-MAX
    buf:='R'+pad_zeros(Xres)+tab+pad_zeros(Yres)+cr;
    count:=length(buf);
    if WriteCom(encoder_port,buf,count)= false then exit;
    count:=20;
    if ReadCom(encoder_port,buf,count) = false then exit;
    if trim(buf)='R' then begin
       result:=true;
    end;
    end;
else result:=true;
end;
end;

Function Encoder_Init(Xpos,Ypos : integer) : boolean;
var buf : string;
    count : integer;
begin
result:=false;
PurgeBuffer(encoder_port);
case encoder_type of
1 : begin  // Ouranos
    buf:='I'+pad_zeros(Xpos)+tab+pad_zeros(Ypos)+cr;
    count:=length(buf);
    if WriteCom(encoder_port,buf,count)= false then exit;
    count:=20;
    if ReadCom(encoder_port,buf,count) = false then exit;
    if trim(buf)='R' then begin
       result:=true;
       Initialised:=true;
    end;
    end;
else result:=true;
end;
end;

Function Encoder_Set_Init_Flag : boolean;
var buf : string;
    count : integer;
begin
result:=false;
PurgeBuffer(encoder_port);
case encoder_type of
1 : begin  // Ouranos
    buf:='A';
    count:=length(buf);
    if WriteCom(encoder_port,buf,count)= false then exit;
    result:=true;
    end;
else result:=true;    
end;
end;

Function Encoder_Get_Init_Flag(var initflag : string): boolean;
var buf : string;
    count : integer;
begin
result:=false;
PurgeBuffer(encoder_port);
case encoder_type of
1 : begin  // Ouranos
    buf:='a';
    count:=length(buf);
    if WriteCom(encoder_port,buf,count)= false then exit;
    count:=20;
    if ReadCom(encoder_port,buf,count) = false then exit;
    initflag:=trim(buf);
    if (initflag='Y') or (initflag='N') then result:=true;
    end;
else result := true;
end;
end;

Function GetDeviceStatus(var ex,ey : integer; var batteryOK : boolean) : boolean;
var buf : string;							// #### added variable for intelliscope
    count,p : integer;
begin
result:=false;
PurgeBuffer(encoder_port);
    buf:='P';
    count:=length(buf);
    if WriteCom(encoder_port,buf,count)= false then exit;
    count:=20;
    if ReadCom(encoder_port,buf,count) = false then exit;
    p:=pos('P',buf);                                     // #### test is leading character is xmit character then intelliscope
    if p>0 then begin                                    // #### HERE's the modifications for the intelliscope protocol
	    buf:=trim(copy(buf,2,count-1));                        // #### it strips off the leading Q Character
	    count:=count-1;							// #### shortens the count for the buffer by one so rest driver is not affected
    end;



    if count<3 then exit;
    ey:=strtointdef(buf[1],0);
    ex:=strtointdef(buf[2],0);
    batteryOK:=buf[3]='1';
result:=true;
end;

end.
