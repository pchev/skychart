unit indicom;
{
Copyright (C) 2014 Patrick Chevalley

http://www.ap-i.net
pch@ap-i.net

This program is free software; you can redistribute it and/or
modify it under the terms of the GNU General Public License
as published by the Free Software Foundation; either version 2

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software
Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
}
{
   Pascal Indi client library freely inspired by libindiclient.
   See: http://www.indilib.org/
}

{$mode objfpc}{$H+}

interface

uses indiapi, DOM,
  Classes, SysUtils;

function GetAttrib(node:TDOMNode; attr:string):TDOMNode;
function GetNodeName(node:TDOMNode): string;
function GetNodeValue(node:TDOMNode): string;
function GetChildValue(node:TDOMNode): string;
function pstateStr (s:IPState):string;
function crackIPState (str: string; out ip: IPState): boolean;
function crackISState (str:string; out ip: ISState): boolean;
function crackIPerm (str: string; out ip: IPerm): boolean;
function crackISRule (str:string; out ip: ISRule): boolean;
function f_scansexa (str: string; out dp: double): boolean;
function IUFindText (tvp: ITextVectorProperty; name: string): IText;
function IUFindNumber(nvp: INumberVectorProperty; name: string): INumber;
function IUFindSwitch(svp: ISwitchVectorProperty; name: string): ISwitch;
function IUFindLight(lvp: ILightVectorProperty; name: string): ILight;
function IUFindBLOB(bvp: IBLOBVectorProperty; name: string): IBLOB;
function IUFindOnSwitch(svp: ISwitchVectorProperty): ISwitch;
procedure IUResetSwitch(svp: ISwitchVectorProperty);

implementation

function GetAttrib(node:TDOMNode; attr:string):TDOMNode;
begin
  if node=nil then result:=nil
  else result:=node.Attributes.GetNamedItem(DOMString(attr));
end;

function GetNodeName(node:TDOMNode): string;
begin
  if node=nil then result:=''
  else result:=trim(string(node.NodeName));
end;

function GetNodeValue(node:TDOMNode): string;
begin
  if node=nil then result:=''
  else result:=trim(string(node.NodeValue));
end;

function GetChildValue(node:TDOMNode): string;
var cnode: TDOMNode;
begin
  if node=nil then result:=''
  else begin
    cnode:=node.FirstChild;
    if (cnode=nil) then result:=''
    else result:=trim(string(cnode.NodeValue));
  end
end;

//* return static string corresponding to the given property or light state */
function pstateStr (s:IPState):string;
begin
        case s of
         IPS_IDLE:  result:= 'Idle';
         IPS_OK:    result:= 'Ok';
         IPS_BUSY:  result:= 'Busy';
         IPS_ALERT: result:= 'Alert';
         else  result:= '';
        end;
end;



//* crack string into IPState.
function crackIPState (str: string; out ip: IPState): boolean;
begin
        result:=true;
             if (str='Idle')  then ip := IPS_IDLE
        else if (str= 'Ok')   then ip := IPS_OK
        else if (str= 'Busy') then ip := IPS_BUSY
        else if (str= 'Alert')then ip := IPS_ALERT
        else result:=false;
end;

//* crack string into ISState.
function crackISState (str:string; out ip: ISState): boolean;
begin
        result:=true;
             if (str='On')  then ip := ISS_ON
        else if (str='Off') then ip := ISS_OFF
        else result:=false;
end;

function crackIPerm (str: string; out ip: IPerm): boolean;
begin
        result:=true;
             if (str='rw') then ip := IP_RW
        else if (str='ro') then ip := IP_RO
        else if (str='wo') then ip := IP_WO
        else result:=false;
end;

function crackISRule (str:string; out ip: ISRule): boolean;
begin
    result:=true;
    if (str='OneOfMany')      then ip := ISR_1OFMANY
    else if (str='AtMostOne') then ip := ISR_ATMOST1
    else if (str='AnyOfMany') then ip := ISR_NOFMANY
    else result:=false;
end;

function f_scansexa (str: string; out dp: double): boolean;
var a,b,c: extended;
    s1,s2,s3: char;
    p: array[0..5] of pointer;
    neg: boolean;
    r: integer;
begin
	a := 0; b := 0; c := 0;
        p[0]:=@a;
        p[1]:=@s1;
        p[2]:=@b;
        p[3]:=@s2;
        p[4]:=@c;
        p[5]:=@s3;
	r := pos('-',str);
        neg := r>0;
        if neg then Delete(str,r,1);
	r := sscanf (str, '%f%c%f%c%f%c', p);
	if (r < 1) then exit (false);
	dp := a + b/60 + c/3600;
	if (neg) then dp *= -1;
	exit (true);
end;

function IUFindText (tvp: ITextVectorProperty; name: string): IText;
var i: integer;
begin
   for i:=0 to tvp.ntp-1 do
     if tvp.tp[i].name = name then
        exit(tvp.tp[i]);
   if Ftrace then writeln('No IText ',name,tvp.device,tvp.name);
   exit(nil);
end;

function IUFindNumber(nvp: INumberVectorProperty; name: string): INumber;
var i: integer;
begin
   for i:=0 to nvp.nnp-1 do
     if nvp.np[i].name = name then
        exit(nvp.np[i]);
   if Ftrace then writeln('No INumber ',name,nvp.device,nvp.name);
   exit(nil);
end;

function IUFindSwitch(svp: ISwitchVectorProperty; name: string): ISwitch;
var i: integer;
begin
   for i:=0 to svp.nsp-1 do
     if svp.sp[i].name = name then
        exit(svp.sp[i]);
   if Ftrace then writeln('No ISwitch ',name,svp.device,svp.name);
   exit(nil);
end;

function IUFindLight(lvp: ILightVectorProperty; name: string): ILight;
var i: integer;
begin
   for i:=0 to lvp.nlp-1 do
     if lvp.lp[i].name = name then
        exit(lvp.lp[i]);
   if Ftrace then writeln('No ILight ',name,lvp.device,lvp.name);
   exit(nil);
end;

function IUFindBLOB(bvp: IBLOBVectorProperty; name: string): IBLOB;
var i: integer;
begin
   for i:=0 to bvp.nbp-1 do
     if bvp.bp[i].name = name then
        exit(bvp.bp[i]);
   if Ftrace then writeln('No IBLOB ',name,bvp.device,bvp.name);
   exit(nil);
end;

function IUFindOnSwitch(svp: ISwitchVectorProperty): ISwitch;
var i: integer;
begin
  for i := 0 to svp.nsp-1 do
    if svp.sp[i].s = ISS_ON then
       exit(svp.sp[i]);
  exit(nil);
end;

procedure IUResetSwitch(svp: ISwitchVectorProperty);
var i: integer;
begin
  for i := 0 to svp.nsp-1 do
    svp.sp[i].s := ISS_OFF;
end;

end.

