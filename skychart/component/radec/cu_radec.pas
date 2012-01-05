unit cu_radec;
{                                        
Copyright (C) 2005 Patrick Chevalley

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
}
{
 RA - DEC input.
}

interface

uses
    SysUtils, Classes, Math,  Types,
{$ifdef linux}
    QMask, QForms ;
{$endif}
{$ifdef mswindows}
    Mask, Forms ;
{$endif}

type 
  Tradeckind=( RA, DE, Az, Alt );

type
  TRaDec = class(TMaskEdit)
  private
    { Private declarations }
    Fkind : Tradeckind;
    procedure SetValue(Value: Double);
    function ReadValue: Double;
    procedure SetKind(Value: Tradeckind);
  public
    { Public declarations }
     constructor Create(Aowner:Tcomponent); override;
     destructor Destroy; override;
  published
    { Published declarations }
     property kind: Tradeckind read Fkind write SetKind;
     property value : double Read ReadValue write SetValue;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('CDC', [TRaDec]);
end;
//////////////////////////////////////////////////////////
Function sgn(x:Double):Double ;
begin
// sign function with zero positive
if x<0 then
   sgn:= -1
else
   sgn:=  1 ;
end ;

Function ARToStr(ar: Double) : string;
var dd,min1,min,sec: Double;
    d,m,s : string;
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

Function StrToAR(dms : string) : double;
var s,p : integer;
    t : string;
begin
try
dms:=trim(dms);
if copy(dms,1,1)='-' then s:=-1 else s:=1;
p:=pos('h',dms);
t:=stringreplace((copy(dms,1,p-1)),' ','',[rfReplaceAll]); delete(dms,1,p);
if t='' then t:='0';
result:=strtoint(t);
p:=pos('m',dms);
t:=trim(copy(dms,1,p-1)); delete(dms,1,p);
if t='' then t:='0';
result:=result+ s * strtoint(t) / 60;
p:=pos('s',dms);
t:=trim(copy(dms,1,p-1));
if t='' then t:='0';
result:=result+ s * strtoint(t) / 3600;
except
result:=0;
end;
end;

Function DEToStr(de: Double) : string;
var dd,min1,min,sec: Double;
    d,m,s : string;
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
    result := d+'d'+m+'m'+s+'s';
end;

Function StrToDE(dms : string) : double;
var s,p : integer;
    t : string;
begin
try
dms:=trim(dms);
if copy(dms,1,1)='-' then s:=-1 else s:=1;
p:=pos('d',dms);
t:=stringreplace((copy(dms,1,p-1)),' ','',[rfReplaceAll]); delete(dms,1,p);
if t='' then t:='0';
result:=strtoint(t);
p:=pos('m',dms);
t:=trim(copy(dms,1,p-1)); delete(dms,1,p);
if t='' then t:='0';
result:=result+ s * strtoint(t) / 60;
p:=pos('s',dms);
t:=trim(copy(dms,1,p-1));
if t='' then t:='0';
result:=result+ s * strtoint(t) / 3600;
except
result:=0;
end;
end;

Function AzToStr(de: Double) : string;
var dd,min1,min,sec: Double;
    d,m,s : string;
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
    if abs(dd)<100 then d:='00'+trim(d)
     else if abs(dd)<10 then d:='0'+trim(d);
    if de<0 then d:='-'+d;
    str(min:2:0,m);
    if abs(min)<10 then m:='0'+trim(m);
    str(sec:2:0,s);
    if abs(sec)<9.5 then s:='0'+trim(s);
    result := d+'d'+m+'m'+s+'s';
end;

Function AltToStr(de: Double) : string;
var dd,min1,min,sec: Double;
    d,m,s : string;
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
    result := d+'d'+m+'m'+s+'s';
end;
//////////////////////////////////////////////////////////

constructor TRaDec.Create(Aowner:Tcomponent);
begin
inherited create(Aowner);
EditMask:='!99h99m99s;1; ';
Text:='';
Width:=75;
setvalue(0);
end;

destructor TRaDec.Destroy;
begin
inherited destroy;
end;

procedure TRaDec.SetKind(Value: Tradeckind);
begin
Fkind:=Value;
case Fkind of
 RA: EditMask:='!99h99m99s;1; ';
 DE: EditMask:='!##9d99m99s;1; ';
 Az: EditMask:='!999d99m99s;1; ';
 Alt: EditMask:='!##9d99m99s;1; ';
end;
end;

procedure TRaDec.SetValue(Value: Double);
begin
case Fkind of
 RA: Text:=ARToStr(Value);
 DE: Text:=DEToStr(Value);
 Az: Text:=AzToStr(Value);
 Alt: Text:=AltToStr(Value);
end;
end;

function TRaDec.ReadValue: Double;
begin
case Fkind of
 RA: result:=StrToAR(Text);
 DE: result:=StrToDE(Text);
 Az: result:=StrToDE(Text);
 Alt: result:=StrToDE(Text);
 else result:=0;
end;
end;


//////////////////////////////////////////////////////////

end.
