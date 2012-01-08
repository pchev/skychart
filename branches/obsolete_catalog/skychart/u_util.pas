unit u_util;
{
Copyright (C) 2002 Patrick Chevalley

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
 Utility functions
}
{$mode delphi}{$H+}
interface

uses Math, SysUtils, Classes, u_constant, LCLType, FileUtil,
  {$ifdef mswindows}
    Windows, Registry,
  {$endif}
  {$ifdef unix}
    unix,baseunix,unixutil,
  {$endif}
    Controls, Process,
    MaskEdit,enhedits,Menus,Spin,CheckLst,Buttons, ExtCtrls,
    Forms,Graphics,StdCtrls,ComCtrls,Dialogs,Grids,PrintersDlgs,Printers;

function rmod(x,y:Double):Double;
Function NormRA(ra : double):double;
Function sgn(x:Double):Double ;
Function PadZeros(x : string ; l :integer) : string;
Function mm2pi(l,PrinterResolution : single): integer;
Function Slash(nom : string) : string;
Function NoSlash(nom : string) : string;
function IsNumber(n : string) : boolean;
function AddColor(c1,c2 : Tcolor):Tcolor;
function SubColor(c1,c2 : Tcolor):Tcolor;
function roundF(x:double;n:integer):double;
Procedure InitTrace;
Procedure WriteTrace( buf : string);
procedure Splitarg(buf,sep:string; var arg: TStringList);
procedure SplitRec(buf,sep:string; var arg: TStringList);
function ExpandTab(str:string; tabwidth:integer):string;
function words(str,sep : string; p,n : integer) : string;
function wordspace(str:string):string;
function pos2(sub,str:string;i:integer):integer;
function InvertI16(X : Word) : SmallInt;
function InvertI32(X : LongWord) : LongInt;
function InvertI64(X : Int64) : Int64;
function InvertF32(X : LongWord) : Single;
function InvertF64(X : Int64) : Double;
Procedure DToS(t: Double; var h,m,s : integer);
Function DEToStr(de: Double) : string;
Function ARtoStr(ar: Double) : string;
Function DEmToStr(de: Double) : string;
Function DEdToStr(de: Double) : string;
Function DEToStrmin(de: Double) : string;
Function ARmtoStr(ar: Double) : string;
Function DEpToStr(de: Double; precision:integer=1) : string;
Function ARptoStr(ar: Double; precision:integer=1) : string;
Function TimToStr(tim: Double) : string;
Function YearADBC(year : integer) : string;
Function Date2Str(y,m,d:integer):string;
Function ARToStr2(ar: Double; var d,m,s : string) : string;
Function ARToStr3(ar: Double) : string;
Function Str3ToAR(dms : string) : double;
Function DEToStr2(de: Double; var d,m,s : string) : string;
Function DEToStr3(de: Double) : string;
Function Str3ToDE(dms : string) : double;
Function DEToStr4(de: Double) : string;
function isodate(a,m,d : integer) : string;
function LeapYear(Year: longint): boolean;
function DayofYear(y,m,d: integer):integer;
function jddate(jd: double) : string;
function jddatetime(jd: double;fy,fm,fd,fh,fn,fs:boolean) : string;
function DateTimetoJD(Date: Tdatetime): double;
Function LONmToStr(l: Double) : string;
Function LONToStr(l: Double) : string;
function SetCurrentTime(cfgsc:Tconf_skychart):boolean;
function DTminusUT(year,month : integer; c:Tconf_skychart) : double;
Procedure FormPos(form : Tform; x,y : integer);
Function ExecProcess(cmd: string; output: TStringList; ShowConsole:boolean=false): integer;
Function Exec(cmd: string; hide: boolean=true): integer;
procedure ExecNoWait(cmd: string; title:string=''; hide: boolean=true);
function decode_mpc_date(s: string; var y,m,d : integer; var hh:double):boolean;
Function GreekLetter(gr : shortstring) : shortstring;
function GetId(str:string):integer;
Procedure GetPrinterResolution(var name : string; var resol : integer);
Function ExecuteFile(const FileName: string): integer;
procedure PrintStrings(str: TStrings; PrtTitle, PrtText, PrtTextDate:string; orient:TPrinterOrientation);
Procedure PrtGrid(Grid:TStringGrid; PrtTitle, PrtText, PrtTextDate:string; orient:TPrinterOrientation);
Function EncryptStr(Str,Pwd: String; Encode: Boolean=true): String;
Function DecryptStr(Str,Pwd: String): String;
function strtohex(str:string):string;
function hextostr(str:string):string;
procedure GetTranslationString(form: TForm; var f: textfile);
function CondUTF8Decode(v:string):string;
function CondUTF8Encode(v:string):string;
function GreekSymbolUtf8(v:string):string;
function SafeUTF8ToSys(v:string):string;
function GetSerialPorts(var c: TComboBox):boolean;
{$ifdef unix}
function ExecFork(cmd:string;p1:string='';p2:string='';p3:string='';p4:string='';p5:string=''):integer;
function CdcSigAction(const action: pointer):boolean;
{$endif}
{$ifdef mswindows}
procedure SetFormNightVision(form: TForm; onoff:boolean);
function FindWin98: boolean;
function ScreenBPP: integer;
{$endif}

var traceon : boolean;

implementation

uses u_projection;

var
  dummy_ext : extended;
  ftrace : textfile;
  
{$ifdef lclgtk2} {$define cdcutf8} {$define greekutf8} {$endif}
{$ifdef lclqt} {$define cdcutf8} {$define greekutf8} {$endif}
{$ifdef lclcarbon} {$define cdcutf8} {$define greekutf8} {$endif}
{$ifdef lclwin32} {$define cdcutf8} {$endif}
{$ifdef lclwin64} {$define cdcutf8} {$endif}

function CondUTF8Decode(v:string):string;
begin
{$ifdef cdcutf8}
result:=v;
{$else}
result:=UTF8Decode(v);
{$endif}
end;

function CondUTF8Encode(v:string):string;
begin
{$ifdef cdcutf8}
result:=v;
{$else}
result:=UTF8Encode(v);
{$endif}
end;

function GreekSymbolUtf8(v:string):string;
{$ifdef greekutf8}
var c,n : string;
    i: integer;
{$endif}
begin
{$ifdef greekutf8}
c:=lowercase(trim(copy(v,1,1)));
n:=trim(copy(v,2,1));
result:=v;
for i:=1 to 24 do begin
  if c=greeksymbol[2,i] then begin
     result:=chr(hi(greekUTF8[i]))+chr(lo(greekUTF8[i]))+n;
     break;
   end;
end;
{$else}
result:=v;
{$endif}
end;

function SafeUTF8ToSys(v:string):string;
begin
result:=UTF8ToSys(v);
if result='' then result:=v;
end;

function GetSerialPorts(var c: TComboBox):boolean;
var p: TStringList;
    i: integer;
    fs : TSearchRec;
    buf: string;
    {$ifdef mswindows}
    reg: TRegistry;
    l: TStringList;
    n: integer;
    {$endif}
begin
p:=TStringList.Create;
p.clear;
{$ifdef linux}
  i:=findfirst('/dev/ttyS*',faSysFile,fs);
  while i=0 do begin
    p.Add('/dev/'+fs.Name);
    i:=findnext(fs);
  end;
  findclose(fs);
  i:=findfirst('/dev/ttyUSB*',faSysFile,fs);
  while i=0 do begin
    p.Add('/dev/'+fs.Name);
    i:=findnext(fs);
  end;
  findclose(fs);
{$endif}
{$ifdef darwin}
  i:=findfirst('/dev/tty.serial*',faSysFile,fs);
  while i=0 do begin
    p.Add('/dev/'+fs.Name);
    i:=findnext(fs);
  end;
  findclose(fs);
  i:=findfirst('/dev/tty.usbserial*',faSysFile,fs);
  while i=0 do begin
    p.Add('/dev/'+fs.Name);
    i:=findnext(fs);
  end;
  findclose(fs);
{$endif}
{$ifdef mswindows}
  l := TStringList.Create;
  reg := TRegistry.Create;
  reg.RootKey := HKEY_LOCAL_MACHINE;
  reg.OpenKey('\HARDWARE\DEVICEMAP\SERIALCOMM', false);
  reg.GetValueNames(l);
  for n := 0 to l.Count - 1 do
    p.Add(reg.ReadString(l[n]));
  reg.Free;
  l.Free;
{$endif}
p.Sort;
buf := c.text;
try
if p.Count>0 then begin
  c.Clear;
  for i:=0 to p.count-1 do
      c.Items.Add(p[i]);
end;
finally
c.Text := buf;
p.free;
end;
result:=true;
end;

Function mm2pi(l,PrinterResolution : single): integer;
begin
result:=round(l*PrinterResolution/25.4);
end;

Function PadZeros(x : string ; l :integer) : string;
const zero = '000000000000';
var p : integer;
begin
x:=trim(x);
p:=l-length(x);
result:=copy(zero,1,p)+x;
end;

function  Rmod(x,y:Double):Double;
BEGIN
    Rmod := x - Int(x/y) * y ;
END  ;

Function NormRA(ra : double):double;
begin
result:=rmod(ra+pi2+pi2,pi2);
//if (ar2<ar1)and(ra<=arm) then NormRA:=ra+pi2
//else NormRA:=ra;
end;

Function sgn(x:Double):Double ;
begin
// sign function with zero positive
if x<0 then
   sgn:= -1
else
   sgn:=  1 ;
end ;

Function NoSlash(nom : string) : string;
begin
result:=trim(nom);
if copy(result,length(nom),1)=PathDelim then result:=copy(result,1,length(nom)-1);
end;

Function Slash(nom : string) : string;
begin
result:=trim(nom);
if copy(result,length(nom),1)<>PathDelim then result:=result+PathDelim;
end;

function IsNumber(n : string) : boolean;
begin
result:=TextToFloat(PChar(n),Dummy_ext);
end;

function roundF(x:double;n:integer):double;
var y : double;
begin
y:=intpower(10,n);
result:=round(x*y)/y;
end;

Procedure InitTrace;
begin
try
 traceon:=true;
 if tracefile<>'' then tracefile:=expandfilename(tracefile); 
 Filemode:=2;
 assignfile(ftrace,tracefile);
 rewrite(ftrace);
 writeln(ftrace,FormatDateTime(dateiso,Now)+'  Start trace');
 if tracefile<>'' then closefile(ftrace);
except
{$I-}
 traceon:=false;
 closefile(ftrace);
 IOResult;
{$I+}
end;end;

Procedure WriteTrace( buf : string);
begin
try
if traceon then begin
 if tracefile<>'' then begin
    Filemode:=2;
    assignfile(ftrace,tracefile);
    append(ftrace);
 end;   
 writeln(ftrace,FormatDateTime(dateiso,Now)+'  '+UTF8ToSys(buf));
 if tracefile<>'' then closefile(ftrace);
end;
except
{$I-}
 traceon:=false;
 closefile(ftrace);
 IOResult;
{$I+}
end;
end;

function AddColor(c1,c2 : Tcolor):Tcolor;
var max,r,v,b : integer;
    f : double;
begin
r:=(c1 and $000000ff)+(c2 and $000000ff);
v:=((c1 and $0000ff00)+(c2 and $0000ff00)) shr 8;
b:=((c1 and $00ff0000)+(c2 and $00ff0000)) shr 16;
max:=maxintvalue([r,v,b]);
if max>255 then begin
  f:=255/max;
  r:=trunc(f*r);
  v:=trunc(f*v);
  b:=trunc(f*b);
end;
result:=r+256*v+65536*b;
end;

function SubColor(c1,c2 : Tcolor):Tcolor;
var min,r,v,b : integer;
    f : double;
begin
r:=(c1 and $000000ff)-(c2 and $000000ff);
v:=((c1 and $0000ff00)-(c2 and $0000ff00)) shr 8;
b:=((c1 and $00ff0000)-(c2 and $00ff0000)) shr 16;
min:=minintvalue([r,v,b]);
if min<0 then begin
  f:=255/(255-min);
  r:=trunc(f*(r-min));
  v:=trunc(f*(v-min));
  b:=trunc(f*(b-min));
end;
result:=r+256*v+65536*b;
end;

// same as SplitRec but remove empty strings
procedure Splitarg(buf,sep:string; var arg: TStringList);
var i,j,k,l:integer;
begin
arg.clear;
l:=length(sep);
while copy(buf,1,l)=sep do delete(buf,1,1);
while pos(sep,buf)<>0 do begin
 for i:=1 to length(buf) do begin
  if copy(buf,i,l) = sep then begin
    if copy(buf,i+l,l)=sep then continue;
    if copy(buf,1,1)='"' then begin
      j:=length(buf);
      for k:=2 to length(buf) do
        if copy(buf,k,1)='"' then begin
          j:=k;
          break;
        end;
      arg.Add(copy(buf,2,j-2));
      delete(buf,1,j);
      while copy(buf,1,l)=sep do delete(buf,1,1);
      break;
    end else begin
      arg.add(copy(buf,1,i-1));
      delete(buf,1,i-1+l);
      break;
    end;
  end;
 end;
end;
arg.add(buf);
end;

// same as SplitArg but keep empty strings
procedure SplitRec(buf,sep:string; var arg: TStringList);
var i,l:integer;
begin
arg.clear;
l:=length(sep);
while pos(sep,buf)<>0 do begin
 for i:=1 to length(buf) do begin
  if copy(buf,i,l) = sep then begin
      arg.add(copy(buf,1,i-1));
      delete(buf,1,i-1+l);
      break;
  end;
 end;
end;
arg.add(buf);
end;

function ExpandTab(str:string; tabwidth:integer):string;
const tab=#09;
var i,j,k:integer;
    c:char;
begin
result:='';
i:=0;
for j:=1 to length(str) do begin
    c:=str[j-1];
    if c=tab then begin
       k:=i mod tabwidth;
       result:=result+StringOfChar(blank, tabwidth-k);
       i:=i+tabwidth-k;
    end else begin
      result:=result+c;
      inc(i);
    end;
end;
end;

function wordspace(str:string):string;
var i : integer;
    c : char;
begin
c:=blank;
result:='';
for i:=1 to length(str) do begin
  if str[i]=blank then begin
     if c<>blank then result:=result+str[i];
  end else result:=result+str[i];
  c:=str[i];
end;
end;

function words(str,sep : string; p,n : integer) : string;
var     i,j : Integer;
begin
result:='';
str:=trim(str);
for i:=1 to p-1 do begin
 j:=pos(blank,str);
 if j=0 then j:=length(str)+1;
 str:=trim(copy(str,j,length(str)));
end;
for i:=1 to n do begin
 j:=pos(blank,str);
 if j=0 then j:=length(str)+1;
 result:=result+trim(copy(str,1,j))+sep;
 str:=trim(copy(str,j,length(str)));
end;
end;

function pos2(sub,str:string;i:integer):integer;
begin
result:=pos(sub,copy(str,i,length(str)));
if result>0 then result:=result+i-1;
end;

function InvertI16(X : word) : smallInt;
var  P : PbyteArray;
     temp : word;
begin
    P:=@X;
    temp:=(P[0] shl 8) or (P[1]);
    move(temp,result,2);
end;

function InvertI32(X : LongWord) : LongInt;
var  P : PbyteArray;
begin
    P:=@X;
    result:=(P[0] shl 24) or (P[1] shl 16) or (P[2] shl 8) or (P[3]);
end;

function InvertI64(X : Int64) : Int64;
var  P : PbyteArray;
begin
    P:=@X;
    result:=4294967296 * ((P[0] shl 24) or (P[1] shl 16) or (P[2] shl 8) or (P[3])) + ((P[4] shl 24) or (P[5] shl 16) or (P[6] shl 8) or (P[7]));
end;

function InvertF32(X : LongWord) : Single;
var  P : PbyteArray;
     temp : LongWord;
begin
    P:=@X;
    if (P[0]=$7F)or(P[0]=$FF) then result:=0   // IEEE-754 NaN
    else begin
    temp:=(P[0] shl 24) or (P[1] shl 16) or (P[2] shl 8) or (P[3]);
    move(temp,result,4);
    end;
end;

function InvertF64(X : Int64) : Double;
var  P : PbyteArray;
     temp : Int64;
begin
    P:=@X;
    if (P[0]=$7F)or(P[0]=$FF) then result:=0   // IEEE-754 NaN
    else begin
    temp:=4294967296 * ((P[0] shl 24) or (P[1] shl 16) or (P[2] shl 8) or (P[3])) + ((P[4] shl 24) or (P[5] shl 16) or (P[6] shl 8) or (P[7]));
    move(temp,result,8);
    end;
end;

Procedure DToS(t: Double; var h,m,s : integer);
var dd,min1,min,sec: Double;
begin
    dd:=Int(t);
    min1:=abs(t-dd)*60;
    if min1>=59.99166667 then begin
       dd:=dd+sgn(t);
       min1:=0.0;
    end;
    min:=Int(min1);
    sec:=(min1-min)*60;
    if sec>=59.95 then begin
       min:=min+1;
       sec:=0.0;
    end;
    h:=round(dd);
    m:=round(min);
    s:=round(sec);
end;

Function DEToStr(de: Double) : string;
var dd,min1,min,sec: Double;
    d,m,s : string;
begin
    dd:=Int(de);
    min1:=abs(de-dd)*60;
    if min1>=59.99166667 then begin
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
    result := d+ldeg+m+lmin+s+lsec;
end;

Function DEToStr3(de: Double) : string;
var dd,min1,min,sec: Double;
    d,m,s : string;
begin
    dd:=Int(de);
    min1:=abs(de-dd)*60;
    if min1>=59.99166667 then begin
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

Function DEToStr4(de: Double) : string;
var dd,min1,min,sec: Double;
    d,m,s : string;
begin
    dd:=Int(de);
    min1:=abs(de-dd)*60;
    if min1>=59.99166667 then begin
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
    result := d+'°'+m+''''+s+'"';
end;

Function TimToStr(tim: Double) : string;
var dd,min1,min,sec: Double;
    d,m,s : string;
begin
    dd:=Int(tim);
    min1:=abs(tim-dd)*60;
    if min1>=59.99166667 then begin
       dd:=dd+sgn(tim);
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
    str(min:2:0,m);
    if abs(min)<10 then m:='0'+trim(m);
    str(sec:2:0,s);
    if abs(sec)<9.5 then s:='0'+trim(s);
    result := d+':'+m+':'+s;
end;

Function Date2Str(y,m,d:integer):string;
var buf:string;
begin
  result:=YearADBC(y);
  str(m:2,buf);
  if m<10 then buf:='0'+trim(buf);
  result:=result+'-'+buf;
  str(d:2,buf);
  if d<10 then buf:='0'+trim(buf);
  result:=result+'-'+buf;
end;

Function YearADBC(year : integer) : string;
begin
if year>0 then begin
   result:=inttostr(year);
end else begin
   result:='BC'+inttostr(-year+1) ;
end;
end;

Function ARToStr(ar: Double) : string;
var dd,min1,min,sec: Double;
    d,m,s : string;
begin
    dd:=Int(ar);
    min1:=abs(ar-dd)*60;
    if min1>=59.99166667 then begin
       dd:=dd+sgn(ar);
       min1:=0.0;
    end;
    min:=Int(min1);
    sec:=(min1-min)*60;
    if sec>=59.95 then begin
       min:=min+1;
       sec:=0.0;
    end;
    str(dd:3:0,d);
    str(min:2:0,m);
    if abs(min)<10 then m:='0'+trim(m);
    str(sec:4:1,s);
    if abs(sec)<9.95 then s:='0'+trim(s);
    result := d+'h'+m+'m'+s+'s';
end;

Function DEpToStr(de: Double; precision:integer=1) : string;
var dd,min1,min,sec: Double;
    d,m,s : string;
begin
    dd:=Int(de);
    min1:=abs(de-dd)*60;
    if min1>=59.99166667 then begin
       dd:=dd+sgn(de);
       min1:=0.0;
    end;
    min:=Int(min1);
    sec:=(min1-min)*60;
    if sec>=59.995 then begin
       min:=min+1;
       sec:=0.0;
    end;
    str(abs(dd):2:0,d);
    if abs(dd)<10 then d:='0'+trim(d);
    if de<0 then d:='-'+d else d:='+'+d;
    str(min:2:0,m);
    if abs(min)<10 then m:='0'+trim(m);
    str(sec:4:precision,s);
    if abs(sec)<9.95 then s:='0'+trim(s);
    result := d+ldeg+m+lmin+s+lsec;
end;

Function ARpToStr(ar: Double; precision:integer=1) : string;
var dd,min1,min,sec: Double;
    d,m,s : string;
begin
    dd:=Int(ar);
    min1:=abs(ar-dd)*60;
    if min1>=59.99166667 then begin
       dd:=dd+sgn(ar);
       min1:=0.0;
    end;
    min:=Int(min1);
    sec:=(min1-min)*60;
    if sec>=59.995 then begin
       min:=min+1;
       sec:=0.0;
    end;
    str(abs(dd):2:0,d);
    if abs(dd)<10 then d:='0'+trim(d);
    if dd<0 then d:='-'+d else d:=blank+d;
    str(min:2:0,m);
    if abs(min)<10 then m:='0'+trim(m);
    str(sec:5:precision+1,s);
    if abs(sec)<9.995 then s:='0'+trim(s);
   result := d+'h'+m+'m'+s+'s';
end;

Function DEmToStr(de: Double) : string;
var dd,min: Double;
    d,m : string;
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
    result := d+ldeg+m+lmin;
end;

Function DEdToStr(de: Double) : string;
var dd: Double;
    d : string;
begin
    dd:=round(de);
    str(abs(dd):2:0,d);
    if abs(dd)<10 then d:='0'+trim(d);
    if de<0 then d:='-'+d else d:='+'+d;
    result := d+ldeg;
end;

Function DEToStrmin(de: Double) : string;
var dd: Double;
    d : string;
begin
 if de<=0 then result:='0'
 else if de<1 then begin
    str((de*60):2:0,d);
    result := d+lmin;
 end
 else begin
    dd:=round(de);
    str(dd:2:0,d);
    result := d;
 end;
end;

Function ARmToStr(ar: Double) : string;
var dd,min: Double;
    d,m: string;
begin
    dd:=Int(ar);
    min:=abs(ar-dd)*60;
    if min>=59.5 then begin
       dd:=dd+sgn(ar);
       min:=0.0;
    end;
    min:=Round(min);
    str(dd:3:0,d);
    str(min:2:0,m);
    if abs(min)<9.5 then m:='0'+trim(m);
    result := d+'h'+m+'m';
end;

Function DEToStr2(de: Double; var d,m,s : string) : string;
var dd,min1,min,sec: Double;
begin
    dd:=Int(de);
    min1:=abs(de-dd)*60;
    if min1>=59.99166667 then begin
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
    result := d+ldeg+m+lmin+s+lsec;
end;

Function ARToStr2(ar: Double; var d,m,s : string) : string;
var dd,min1,min,sec: Double;
begin
    dd:=Int(ar);
    min1:=abs(ar-dd)*60;
    if min1>=59.99166667 then begin
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

Function ARToStr3(ar: Double) : string;
var dd,min1,min,sec: Double;
    d,m,s : string;
begin
    dd:=Int(ar);
    min1:=abs(ar-dd)*60;
    if min1>=59.99166667 then begin
       dd:=dd+sgn(ar);
       min1:=0.0;
    end;
    min:=Int(min1);
    sec:=(min1-min)*60;
    if sec>=59.5 then begin
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

Function Str3ToAR(dms : string) : double;
var s,p : integer;
    t : string;
begin
try
dms:=StringReplace(dms,blank,'0',[rfReplaceAll]);
if copy(dms,1,1)='-' then s:=-1 else s:=1;
p:=pos('h',dms);
if p=0 then
  result:=StrToFloatDef(dms,0)
else begin
  t:=copy(dms,1,p-1); delete(dms,1,p);
  result:=StrToIntDef(t,0);
  p:=pos('m',dms);
  t:=copy(dms,1,p-1); delete(dms,1,p);
  result:=result+ s * StrToIntDef(t,0) / 60;
  p:=pos('s',dms);
  t:=copy(dms,1,p-1);
  result:=result+ s * StrToFloatDef(t,0) / 3600;
end;
except
result:=0;
end;
end;

Function Str3ToDE(dms : string) : double;
var s,p : integer;
    t : string;
begin
try
dms:=StringReplace(dms,blank,'0',[rfReplaceAll]);
if copy(dms,1,1)='-' then s:=-1 else s:=1;
p:=pos('d',dms);
if p=0 then
  result:=StrToFloatDef(dms,0)
else begin
t:=copy(dms,1,p-1); delete(dms,1,p);
result:=StrToIntDef(t,0);
p:=pos('m',dms);
t:=copy(dms,1,p-1); delete(dms,1,p);
result:=result+ s * StrToIntDef(t,0) / 60;
p:=pos('s',dms);
t:=copy(dms,1,p-1);
result:=result+ s * StrToFloatDef(t,0) / 3600;
end;
except
result:=0;
end;
end;

function isodate(a,m,d : integer) : string;
begin
result:=padzeros(inttostr(a),4)+'-'+padzeros(inttostr(m),2)+'-'+padzeros(inttostr(d),2);
end;

function jddatetime(jd: double;fy,fm,fd,fh,fn,fs:boolean) : string;
var a,m,d : integer;
    h:double;
    var hd,hm,hs,sep : string;
begin
djd(jd,a,m,d,h);
ARToStr2(h,hd,hm,hs);
result:='';
sep:='';
if fy then begin result:=result+padzeros(inttostr(a),4); sep:='-'; end;
if fm then begin result:=result+sep+padzeros(inttostr(m),2); sep:='-'; end;
if fd then result:=result+sep+padzeros(inttostr(d),2);
if result>'' then sep:=blank;
if fh then begin result:=result+sep+hd; sep:=':'; end;
if fn then begin result:=result+sep+hm; sep:=':'; end;
if fs then result:=result+sep+hs;
end;

function jddate(jd: double) : string;
var a,m,d : integer;
    h:double;
begin
djd(jd,a,m,d,h);
result:=isodate(a,m,d);
end;

function LeapYear(Year: longint): boolean;
begin
  Result := (Year mod 4 = 0) and ((Year mod 100 <> 0) or (Year mod 400 = 0));
end;

function DayofYear(y,m,d: integer):integer;
var k: integer;
begin
if LeapYear(y) then k:=1 else k:=2;
result:=floor(275*m/9)-k*floor((m+9)/12)+d-30;
end;

function DateTimetoJD(date: Tdatetime): double;
var Year, Month, Day: Word;
begin
DecodeDate(Date, Year, Month, Day);
result:=jd(Year,Month,Day,frac(date)*24);
end;

Function LONToStr(l: Double) : string;
var dd,min1,min,sec: Double;
    d,m,s : string;
begin
    dd:=Int(l);
    min1:=abs(l-dd)*60;
    if min1>=59.99166667 then begin
       dd:=dd+sgn(l);
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
    if l<0 then d:='-'+d;
    str(min:2:0,m);
    if abs(min)<10 then m:='0'+trim(m);
    str(sec:2:0,s);
    if abs(sec)<9.5 then s:='0'+trim(s);
    result := d+ldeg+m+lmin+s+lsec;
end;

Function LONmToStr(l: Double) : string;
var dd,min: Double;
    d,m : string;
begin
    dd:=Int(l);
    min:=abs(l-dd)*60;
    if min>=59.5 then begin
       dd:=dd+sgn(l);
       min:=0.0;
    end;
    min:=Round(min);
    str(abs(dd):2:0,d);
    if abs(dd)<10 then d:='0'+trim(d);
    if l<0 then d:='-'+d;
    str(min:2:0,m);
    if abs(min)<10 then m:='0'+trim(m);
    result := d+ldeg+m+lmin;
end;

function SetCurrentTime(cfgsc:Tconf_skychart):boolean;
var y,m,d:word;
    n: TDateTime;
begin
n:=cfgsc.tz.NowLocalTime;
decodedate(n,y,m,d);
cfgsc.CurYear:=y;
cfgsc.CurMonth:=m;
cfgsc.CurDay:=d;
cfgsc.CurTime:=frac(n)*24;
cfgsc.TimeZone:=cfgsc.tz.SecondsOffset/3600;
result:=true;
end;

function DTminusUT(year,month : integer; c:Tconf_skychart) : double;
var y,u,t : double;
begin
if c.Force_DT_UT then
  result:=c.DT_UT_val
else begin
  { Reference  :
  NASA/TP2006214141
  Five Millennium Canon of Solar Eclipses: 1999 to +3000 (2000 BCE to 3000 CE)
  Fred Espenak and Jean Meeus
  }
  y:=year+(month-0.5)/12;
  case year of
  -MaxInt..-501:begin
                u:=(y-1820)/100;
                result:=(-20+32*u*u)/3600;
                end;
  -500..499   : begin
                u:=y/100;
                result:=(10583.6+u*(-1014.41+u*(33.78311+u*(-5.952053+u*(-0.1798452+u*(0.022174192+u*(0.0090316521)))))))/3600;
                end;
  500..1599   : begin
                u:=(y-1000)/100;
                result:=(1574.2+u*(-556.01+u*(71.23472+u*(0.319781+u*(-0.8503463+u*(-0.005050998+u*(0.0083572073)))))))/3600;
                end;
  1600..1699  : begin
                t:=y-1600;
                result:=(120+t*(-0.9808+t*(-0.01532+t*(1/7129))))/3600;
                end;
  1700..1799  : begin
                t:=y-1700;
                result:=(8.83+t*(0.1603+t*(-0.0059285+t*(0.00013336+t*(-1/1174000)))))/3600;
                end;
  1800..1859  : begin
                t:=y-1800;
                result:=(13.72+t*(-0.332447+t*(0.0068612+t*(0.0041116+t*(-0.00037436+t*(0.0000121272+t*(-0.0000001699+t*(0.000000000875))))))))/3600;
                end;
  1860..1899  : begin
                t:=y-1860;
                result:=(7.62+t*(0.5737+t*(-0.251754+t*(0.01680668+t*(-0.0004473624+t*(1/233174))))))/3600;
                end;
  1900..1919  : begin
                t:=y-1900;
                result:=(-2.79+t*(1.494119+t*(-0.0598939+t*(0.0061966+t*(-0.000197)))))/3600;
                end;
  1920..1940  : begin
                t:=y-1920;
                result:=(21.20+t*(0.84493+t*(-0.076100+t*(0.0020936))))/3600;
                end;
  1941..1960  : begin
                t:=y-1950;
                result:=(29.07+t*(0.407+t*(-1/233+t*(1/2547))))/3600;
                end;
  1961..1985  : begin
                t:=y-1975;
                result:=(45.45+t*(1.067+t*(-1/260+t*(-1/718))))/3600;
                end;
  1986..2004  : begin
                t:=y-2000;
                result:=(63.86+t*(0.3345+t*(-0.060374+t*(0.0017275+t*(0.000651814+t*(0.00002373599))))))/3600;
                end;
  // adjustement for measured values after 2005 :
  // linear adjustement from 2005.0 value to 67 sec. reached by 2014.0
  // factor up to 2150 are adjusted to avoid a discontinuity.
  2005..2013  : begin
                t:=y-2005;
                result:=(64.69+t*0.256667)/3600;
                end;
  2014..2049  : begin
                t:=y-2000;
                result:=(61.4+t*(0.32217+t*(0.005589)))/3600;
                //result:=(62.92+t*(0.32217+t*(0.005589)))/3600;
                end;
  2050..2149  : begin
                u:=(y-1820)/100;
                t:=2150-y;
                result:=(-20+32*u*u-0.5788*t)/3600;
                //result:=(-20+32*u*u-0.5628*t)/3600;
                end;
  2150..MaxInt: begin
                u:=(y-1820)/100;
                result:=(-20+32*u*u)/3600;
                end;
  end;
end;
end;

Function RotateBits(C: Char; Bits: Integer): Char;
var
  SI : Word;
begin
  Bits := Bits mod 8;
  // Are we shifting left?
  if Bits < 0 then
    begin
      // Put the data on the right half of a Word (2 bytes)
      SI := word(C);
//      SI := MakeWord(Byte(C),0);
      // Now shift it left the appropriate number of bits
      SI := SI shl Abs(Bits);
    end
  else
    begin
      // Put the data on the left half of a Word (2 bytes)
      SI := word(C) shl 8;
//      SI := MakeWord(0,Byte(C));
      // Now shift it right the appropriate number of bits
      SI := SI shr Abs(Bits);
    end;
  // Finally, Swap the bytes
  SI := Swap(SI);
  // And OR the two halves together
  SI := Lo(SI) or Hi(SI);
  Result := Chr(SI);
end;

Function EncryptStr(Str,Pwd: String; Encode: Boolean = true): String;
var
  a,PwdChk,Direction,ShiftVal,PasswordDigit : Integer;
begin
  if Encode then str:=str+blank15;
  PasswordDigit := 1;
  PwdChk := 0;
  for a := 1 to Length(Pwd) do Inc(PwdChk,Ord(Pwd[a]));
  Result := Str;
  if Encode then Direction := -1 else Direction := 1;
  for a := 1 to Length(Result) do
    begin
      if Length(Pwd)=0 then
        ShiftVal := a
      else
        ShiftVal := Ord(Pwd[PasswordDigit]);
      if Odd(A) then
        Result[A] := RotateBits(Result[A],-Direction*(ShiftVal+PwdChk))
      else
        Result[A] := RotateBits(Result[A],Direction*(ShiftVal+PwdChk));
      inc(PasswordDigit);
      if PasswordDigit > Length(Pwd) then PasswordDigit := 1;
    end;
end;

Function DecryptStr(Str,Pwd: String): String;
begin
result:=trim(EncryptStr(Str,Pwd,false));
end;

function strtohex(str:string):string;
var
  i: Integer;
begin
result:='';
if str='' then exit;
for i:=1 to length(str) do
  result:=result+inttohex(ord(str[i]),2);
end;

function hextostr(str:string):string;
var
  i,k: Integer;
begin
result:='';
if str='' then exit;
for i:=0 to (length(str)-1) div 2 do begin
  k:=strtointdef('$'+str[2*i+1]+str[2*i+2],-1);
  if k>0 then
     result:=result+char(k)
  else begin
     result:=str;   // if not numeric default to the input string
     break;
  end;
end;
end;

Procedure FormPos(form : Tform; x,y : integer);
const margin=60; //minimal distance from screen border
begin
with Form do begin
  if x>margin then left:=x
     else left:=margin;
  if left+width>(Screen.Width-margin) then left:=Screen.Width-width-margin;
  if left<0 then left:=0;
  if y>margin then top:=y
     else top:=margin;
  if top+height>(Screen.height-margin) then top:=Screen.height-height-margin;
  if top<0 then top:=0;
end;
end;

Function ExecProcess(cmd: string; output: TStringList; ShowConsole:boolean=false): integer;
const READ_BYTES = 2048;
var
  M: TMemoryStream;
  P: TProcess;
  n: LongInt;
  BytesRead: LongInt;
begin
M := TMemoryStream.Create;
P := TProcess.Create(nil);
result:=1;
try
  BytesRead := 0;
  P.CommandLine := cmd;
  if ShowConsole then begin
     P.ShowWindow:=swoShowNormal;
     P.StartupOptions:=[suoUseShowWindow];
  end else begin
     P.ShowWindow:=swoHIDE;
  end;
  P.Options := [poUsePipes, poStdErrToOutPut];
  P.Execute;
  while P.Running do begin
    Application.ProcessMessages;
    if P.Output<>nil then begin
      M.SetSize(BytesRead + READ_BYTES);
      n := P.Output.Read((M.Memory + BytesRead)^, READ_BYTES);
      if n > 0 then inc(BytesRead, n);
    end;
  end;
  result:=P.ExitStatus;
  if (result<>127)and(P.Output<>nil) then repeat
    M.SetSize(BytesRead + READ_BYTES);
    n := P.Output.Read((M.Memory + BytesRead)^, READ_BYTES);
    if n > 0
    then begin
      Inc(BytesRead, n);
    end;
  until (n<=0)or(P.Output=nil);
  M.SetSize(BytesRead);
  output.LoadFromStream(M);
  P.Free;
  M.Free;
except
  on E: Exception do begin
    result:=-1;
    output.add(E.Message);
    P.Free;
    M.Free;
  end;
end;
end;

Function Exec(cmd: string; hide: boolean=true): integer;
{$ifdef unix}
begin
 result:=fpSystem(cmd);
end;
{$endif}
{$ifdef mswindows}
var
   bchExec: array[0..1024] of char;
   pchEXEC: Pchar;
   si: TStartupInfo;
   pi: TProcessInformation;
   res:cardinal;
begin
   pchExec := @bchExec;
   StrPCopy(pchExec,cmd);
   FillChar(si,sizeof(si),0);
   FillChar(pi,sizeof(pi),0);
   si.dwFlags:=STARTF_USESHOWWINDOW;
   if hide then si.wShowWindow:=SW_HIDE
           else si.wShowWindow:=SW_SHOWNORMAL;
   si.cb := sizeof(si);
   try
      if CreateProcess(Nil,pchExec,Nil,Nil,false,CREATE_NEW_CONSOLE or NORMAL_PRIORITY_CLASS,
                       Nil,Nil,si,pi) = True then
         begin
           WaitForSingleObject(pi.hProcess,INFINITE);
           GetExitCodeProcess(pi.hProcess,Res);
           result:=res;
         end
         else
           Result := GetLastError;
    except;
       Result := GetLastError;
    end;
end;
{$endif}

procedure ExecNoWait(cmd: string; title:string=''; hide: boolean=true);
{$ifdef unix}
begin
 fpSystem(cmd+' &');
end;
{$endif}
{$ifdef mswindows}
var
   bchExec: array[0..1024] of char;
   pchEXEC: Pchar;
   si: TStartupInfo;
   pi: TProcessInformation;
begin
   pchExec := @bchExec;
   StrPCopy(pchExec,cmd);
   FillChar(si,sizeof(si),0);
   FillChar(pi,sizeof(pi),0);
   si.dwFlags:=STARTF_USESHOWWINDOW;
   if title<>'' then si.lpTitle:=Pchar(title);
   if hide then si.wShowWindow:=SW_SHOWMINIMIZED
           else si.wShowWindow:=SW_SHOWNORMAL;
   si.cb := sizeof(si);
   writetrace('Try to launch '+cmd);
   try
     CreateProcess(Nil,pchExec,Nil,Nil,false,CREATE_NEW_CONSOLE or NORMAL_PRIORITY_CLASS, Nil,Nil,si,pi);
    except;
      writetrace('Could not launch '+cmd);
    end;
end;
{$endif}

Function ExecuteFile(const FileName: string): integer;
{$ifdef mswindows}
var
  zFileName, zParams, zDir: array[0..255] of Char;
begin
  writetrace('Try to launch: '+FileName);
  Result := ShellExecute(Application.MainForm.Handle, nil, StrPCopy(zFileName, FileName),
                         StrPCopy(zParams, ''), StrPCopy(zDir, ''), SW_SHOWNOACTIVATE);
{$endif}
{$ifdef unix}
var cmd,p1,p2,p3,p4: string;
begin
  writetrace('Try to launch: '+FileName);
  cmd:=trim(words(OpenFileCMD,blank,1,1));
  p1:=trim(words(OpenFileCMD,blank,2,1));
  p2:=trim(words(OpenFileCMD,blank,3,1));
  p3:=trim(words(OpenFileCMD,blank,4,1));
  p4:=trim(words(OpenFileCMD,blank,5,1));
  if p1='' then result:=ExecFork(cmd,FileName)
  else if p2='' then result:=ExecFork(cmd,p1,FileName)
  else if p3='' then result:=ExecFork(cmd,p1,p2,FileName)
  else if p4='' then result:=ExecFork(cmd,p1,p2,p3,FileName)
  else result:=ExecFork(cmd,p1,p2,p3,p4,FileName);
{$endif}
end;

{$ifdef unix}
function ExecFork(cmd:string;p1:string='';p2:string='';p3:string='';p4:string='';p5:string=''):integer;
var
  parg: array[1..7] of PChar;
begin
  result := fpFork;
  if result = 0 then
  begin
    parg[1] := Pchar(cmd);
    if p1='' then parg[2]:=nil else parg[2] := PChar(p1);
    if p2='' then parg[3]:=nil else parg[3] := PChar(p2);
    if p3='' then parg[4]:=nil else parg[4] := PChar(p3);
    if p4='' then parg[5]:=nil else parg[5] := PChar(p4);
    if p5='' then parg[6]:=nil else parg[6] := PChar(p5);
    parg[7] := nil;
    writetrace('Try to launch '+cmd+blank+p1+blank+p2+blank+p3+blank+p4+blank+p5);
    if fpExecVP(cmd,PPChar(@parg[1])) = -1 then
    begin
      writetrace('Could not launch '+cmd);
    end;
  end;
end;

function CdcSigAction(const action: pointer):boolean;
var oa,na : psigactionrec;
begin
result:=false;
new(oa);
new(na);
na^.sa_Handler:=SigActionHandler(action);
fillchar(na^.Sa_Mask,sizeof(na^.sa_mask),#0);
na^.Sa_Flags:=0;
{$ifdef Linux}
na^.Sa_Restorer:=Nil;
{$endif}
fpSigAction(SIGHUP,na,oa);
if fpSigAction(SIGTerm,na,oa)<>0 then
   result:=true;
Dispose(oa);
Dispose(na);
end;
{$endif}

function decode_mpc_date(s: string; var y,m,d : integer; var hh:double):boolean;
var c: char;
begin
try
c:=s[1];
case c of
 'I' : y:=1800;
 'J' : y:=1900;
 'K' : y:=2000;
end;
y:=y+strtoint(copy(s,2,2));
c:=s[4];
if c<='9' then m:=strtoint(c)
          else m:=ord(c)-55;
c:=s[5];
if c<='9' then d:=strtoint(c)
          else d:=ord(c)-55;
s:=trim(copy(s,6,999));
if s>'' then hh:=strtofloat(trim(s))
        else hh:=0;
result:=true;
except
 result:=false;
end;
end;

Function GreekLetter(gr : shortstring) : shortstring;
var i : integer;
    buf,num:shortstring;
begin
result:='';
i:=pos('0',gr);
if i=0 then begin
  buf:=copy(gr,1,3);
  num:=copy(gr,4,1);
end else begin
   buf:=copy(gr,1,i-1);
   num:=copy(gr,i+1,9);
end;
buf:=lowercase(trim(copy(buf,1,3)));
buf:=StringReplace(buf,'.','',[]);
for i:=1 to 24 do begin
  if buf=greeksymbol[1,i] then begin
     result:=greeksymbol[2,i]+num; // ome2 -> w2
     break;
   end;
end;
end;

function GetId(str:string):integer;
var buf:shortstring;
    i,k:integer;
    v,w:extended;
begin
buf:=trim(str);
k:=length(buf);
v:=0;
for i:=0 to k-1 do
  v:=v+intpower(10,i)*ord(buf[i]);
w:=255*intpower(10,k-1)/maxint;
if w>1 then result:=trunc(v/w)
       else result:=trunc(v);
end;

Procedure GetPrinterResolution(var name : string; var resol : integer);
begin
if Printer.PrinterIndex >=0 then begin
  name:=Printer.Printers[Printer.PrinterIndex];
  resol:=Printer.XDPI;
end else begin
  name:='';
  resol:=72;
end;
end;

procedure PrintStrings(str: TStrings; PrtTitle, PrtText, PrtTextDate:string; orient:TPrinterOrientation);
 Var
  pw,ph,marg:Integer;
  r:longint;
  y:integer;
  MargeLeft,Margetop,MargeRight:integer;
  StrDate:String;
  TextDown:integer;
  Procedure PrintRow(r:longint);
   begin
    With Printer.Canvas do begin
     TextOut(MargeLeft,y+10,str.Strings[r]);
     inc(y,TextDown);
     //MoveTo(MargeLeft,y); LineTo(MargeRight,y);
    end;
   end;
  Procedure Entete;
   begin
    With Printer.Canvas do begin
     Font.Style:=[fsBold];
     TextOut(MargeLeft,MargeTop,PrtText);
     TextOut(MargeRight-TextWidth(StrDate),MargeTop,StrDate);
     y:=MargeTop+TextDown;
     MoveTo(MargeLeft,y); LineTo(MargeRight,y);
     inc(y,TextDown);
     Font.Style:=[];
    end;
   end;
begin
  StrDate:=PrtTextDate+DateToStr(Date);
  With Printer do begin
   Title:=PrtTitle;
   Orientation:=orient;
   if Orientation=poLandscape then marg:=50
      else marg:=25;
   {$ifdef mswindows}
   pw:=XDPI*PageWidth div 254;
   ph:=YDPI*PageHeight div 254;
   {$endif}
   {$ifdef unix}
   pw:=PageWidth;
   ph:=PageHeight;
   {$endif}
   BeginDoc;
   With Canvas do begin
    Font.Name:='courier';
    Font.Pitch:=fpFixed;
    Font.Size:=8;
    {$ifdef unix}
    Font.Size:=6;
    {$endif}
    Font.Color:=clBlack;
    Pen.Color:=clBlack;
    TextDown:=TextHeight(StrDate)*3 div 2;
   end;
   MargeLeft:=pw div marg;
   MargeTop :=ph div marg;
   MargeRight:=pw-MargeLeft;
   Entete;
   For r:=0 to str.Count-1 do begin
    PrintRow(r);
    if y>=(ph-MargeTop) then begin
     NewPage;
     Entete;
    end;
   end;
   EndDoc;
  end;
end;

{ By Paul Toth tothpaul@multimania.com }
{ http://www.multimania.com/tothpaul  }
{ Just a little Unit to print a Grid :) }
Procedure PrtGrid(Grid:TStringGrid; PrtTitle, PrtText, PrtTextDate:string; orient:TPrinterOrientation);
 Type
  TCols=Array[0..20] of integer;
 Var
  Rapport,pw,ph,marg:Integer;
  r,c:longint;
  cols:^TCols;
  y:integer;
  MargeLeft,Margetop,MargeRight:integer;
  StrDate:String;
  TextDown:integer;
  Procedure VerticalLines;
   Var
    c:LongInt;
   begin
     With Printer.Canvas do begin
      For c:=0 to Grid.ColCount-1 do begin
       MoveTo(Cols^[c],MargeTop+TextDown);
       LineTo(Cols^[c],y);
      end;
      MoveTo(MargeRight,MargeTop+TextDown);
      LineTo(MargeRight,y);
     end;
   end;
  Procedure PrintRow(r:longint);
   Var
    c:longint;
   begin
    With Printer.Canvas do begin
     For c:=0 to Grid.ColCount-1 do TextOut(Cols^[c]+10,y+10,Grid.Cells[c,r]);
     inc(y,TextDown);
     MoveTo(MargeLeft,y); LineTo(MargeRight,y);
    end;
   end;
  Procedure Entete;
   Var
    rr:longint;
   begin
    With Printer.Canvas do begin
     Font.Style:=[fsBold];

     TextOut(MargeLeft,MargeTop,PrtText);
     TextOut(MargeRight-TextWidth(StrDate),MargeTop,StrDate);
     y:=MargeTop+TextDown;

     Brush.Color:=clSilver;
     FillRect(Classes.Rect(MargeLeft,y,MargeRight,y+TextDown*Grid.FixedRows));
     MoveTo(MargeLeft,y); LineTo(MargeRight,y);
     for rr:=0 to Grid.FixedRows-1 do PrintRow(rr);
     Brush.Color:=clWhite;

     Font.Style:=[];
    end;
   end;
 begin
  GetMem(Cols,Grid.ColCount*SizeOf(Integer));
  StrDate:=PrtTextDate+DateToStr(Date);
  With Printer do begin
   Title:=PrtTitle;
   Orientation:=orient;
   if Orientation=poLandscape then marg:=50
      else marg:=25;
   {$ifdef mswindows}
   pw:=XDPI*PageWidth div 254;
   ph:=YDPI*PageHeight div 254;
   {$endif}
   {$ifdef unix}
   pw:=PageWidth;
   ph:=PageHeight;
   {$endif}
   MargeLeft:=pw div marg;
   MargeTop :=ph div marg;
   MargeRight:=pw-MargeLeft;
   Rapport:=(MargeRight) div Grid.GridWidth;
   BeginDoc;
   With Canvas do begin
    Font.Name:=Grid.Font.Name;
    Font.Height:=Grid.Font.Height*Rapport;
    if Font.Height=0  then Font.Height:=11*Rapport;
    Font.Color:=clBlack;
    Pen.Color:=clBlack;
    TextDown:=TextHeight(StrDate)*3 div 2;
   end;
   { calcul des Cols }
   Cols^[0]:=MargeLeft;
   For c:=1 to Grid.ColCount-1 do begin
     Cols^[c]:=round(Cols^[c-1]+Grid.ColWidths[c-1]*Rapport);
   end;
   Entete;
   For r:=Grid.FixedRows to Grid.RowCount-1 do begin
    PrintRow(r);
    if y>=(ph-MargeTop) then begin
     VerticalLines;
     NewPage;
     Entete;
    end;
   end;
   VerticalLines;
   EndDoc;
  end;
  FreeMem(Cols,Grid.ColCount*SizeOf(Integer));
 end;

{$ifdef mswindows}
function FindWin98: boolean;
var lpversioninfo: TOSVERSIONINFO;
begin
lpversioninfo.dwOSVersionInfoSize:=sizeof(TOSVERSIONINFO);
if GetVersionEx(lpversioninfo) then begin
   result:=lpversioninfo.dwMajorVersion<=4;
end
else
 result:=false;
end;

function ScreenBPP: integer;
var screendc: HDC;
begin
screendc:=GetDC(0);
result:=GetDeviceCaps(screendc,BITSPIXEL);
ReleaseDC(0,screendc);
end;

procedure SetFormNightVision(form: TForm; onoff:boolean);
var i: integer;
begin
with form do begin
  if onoff then begin
     color:=nv_dark;
     font.Color:=nv_middle;
     for i := 0 to ComponentCount-1 do begin
        if  ( Components[i] is TPageControl ) then with (Components[i] as TPageControl) do begin
           if color=clWindow   then  color:=nv_black;
           if color=clBtnFace then  color:=nv_dark;
        end;
        if  ( Components[i] is TButton ) then with (Components[i] as TButton) do begin
           if color=clWindow   then  color:=nv_black;
           if color=clBtnFace then  color:=nv_dark;
        end;
        if  ( Components[i] is TBitBtn ) then with (Components[i] as TBitBtn) do begin
           if color=clWindow   then  color:=nv_black;
           if color=clBtnFace then  color:=nv_dark;
        end;
        if  ( Components[i] is TMemo ) then with (Components[i] as TMemo) do begin
           if color=clWindow   then  color:=nv_black;
           if color=clBtnFace then  color:=nv_dark;
        end;
        if  ( Components[i] is TEdit ) then with (Components[i] as TEdit) do begin
           if color=clWindow   then  color:=nv_black;
           if color=clBtnFace then  color:=nv_dark;
        end;
        if  ( Components[i] is TMaskEdit ) then with (Components[i] as TMaskEdit) do begin
           if color=clWindow   then  color:=nv_black;
           if color=clBtnFace then  color:=nv_dark;
        end;
        if  ( Components[i] is TStringGrid ) then with (Components[i] as TStringGrid) do begin
           if color=clWindow   then  color:=nv_black;
           if color=clBtnFace then  color:=nv_dark;
           if fixedcolor=clBtnFace then  fixedcolor:=nv_dark;
        end;
        if  ( Components[i] is TRightEdit ) then with (Components[i] as TRightEdit) do begin
           if color=clWindow   then  color:=nv_black;
           if color=clBtnFace then  color:=nv_dark;
        end;
        if  ( Components[i] is TCombobox ) then with (Components[i] as TCombobox) do begin
           if color=clWindow   then  color:=nv_black;
           if color=clBtnFace then  color:=nv_dark;
        end;
        if  ( Components[i] is TMainMenu ) then with (Components[i] as TMainMenu) do begin
           if color=clWindow   then  color:=nv_black;
           if color=clBtnFace then  color:=nv_dark;
        end;
        if  ( Components[i] is TSpinEdit ) then with (Components[i] as TSpinEdit) do begin
           if color=clWindow   then  color:=nv_black;
           if color=clBtnFace then  color:=nv_dark;
        end;
        if  ( Components[i] is TListBox ) then with (Components[i] as TListBox) do begin
           if color=clWindow   then  color:=nv_black;
           if color=clBtnFace then  color:=nv_dark;
        end;
        if  ( Components[i] is TTreeView ) then with (Components[i] as TTreeView) do begin
           if color=clWindow   then  color:=nv_black;
           if color=clBtnFace then  color:=nv_dark;
        end;
        if  ( Components[i] is TCheckListbox ) then with (Components[i] as TCheckListbox) do begin
           if color=clWindow   then  color:=nv_black;
           if color=clBtnFace then  color:=nv_dark;
        end;
     end;
  end else begin
     Color:=clBtnFace;
     font.Color:=clBtnText;
     for i := 0 to ComponentCount-1 do begin
        if  ( Components[i] is TPageControl ) then with (Components[i] as TPageControl) do begin
           if color=nv_black then color:=clWindow;
           if color=nv_dark  then color:=clBtnFace;
        end;
        if  ( Components[i] is TBitBtn ) then with (Components[i] as TBitBtn) do begin
           if color=nv_black then color:=clWindow;
           if color=nv_dark  then color:=clBtnFace;
        end;
        if  ( Components[i] is TButton ) then with (Components[i] as TButton) do begin
           if color=nv_black then color:=clWindow;
           if color=nv_dark  then color:=clBtnFace;
        end;
        if  ( Components[i] is TMemo ) then with (Components[i] as TMemo) do begin
           if color=nv_black then color:=clWindow;
           if color=nv_dark  then color:=clBtnFace;
        end;
        if  ( Components[i] is TEdit ) then with (Components[i] as TEdit) do begin
           if color=nv_black then color:=clWindow;
           if color=nv_dark  then color:=clBtnFace;
        end;
        if  ( Components[i] is TMaskEdit ) then with (Components[i] as TMaskEdit) do begin
           if color=nv_black then color:=clWindow;
           if color=nv_dark  then color:=clBtnFace;
        end;
        if  ( Components[i] is TStringGrid ) then with (Components[i] as TStringGrid) do begin
           if color=nv_black then color:=clWindow;
           if color=nv_dark  then color:=clBtnFace;
           if fixedcolor=nv_dark  then fixedcolor:=clBtnFace;
        end;
        if  ( Components[i] is TRightEdit ) then with (Components[i] as TRightEdit) do begin
           if color=nv_black then color:=clWindow;
           if color=nv_dark  then color:=clBtnFace;
        end;
        if  ( Components[i] is TCombobox ) then with (Components[i] as TCombobox) do begin
           if color=nv_black then color:=clWindow;
           if color=nv_dark  then color:=clBtnFace;
        end;
        if  ( Components[i] is TMainMenu ) then with (Components[i] as TMainMenu) do begin
           if color=nv_black then color:=clWindow;
           if color=nv_dark  then color:=clBtnFace;
        end;
        if  ( Components[i] is TSpinEdit ) then with (Components[i] as TSpinEdit) do begin
           if color=nv_black then color:=clWindow;
           if color=nv_dark  then color:=clBtnFace;
        end;
        if  ( Components[i] is TListBox ) then with (Components[i] as TListBox) do begin
           if color=nv_black then color:=clWindow;
           if color=nv_dark  then color:=clBtnFace;
        end;
        if  ( Components[i] is TTreeView ) then with (Components[i] as TTreeView) do begin
           if color=nv_black then color:=clWindow;
           if color=nv_dark  then color:=clBtnFace;
        end;
        if  ( Components[i] is TCheckListbox ) then with (Components[i] as TCheckListbox) do begin
           if color=nv_black then color:=clWindow;
           if color=nv_dark  then color:=clBtnFace;
        end;
     end;
  end;
end;
end;
{$endif}

procedure GetTranslationString(form: TForm; var f: textfile);
var i,j: integer;
    cname,cprop,ctext : string;
begin
with form do begin
     writeln(f);
     writeln(f,'Form: '+name);
     for i := 0 to ComponentCount-1 do begin
        cname:=''; cprop:=''; ctext:='';
        if  ( Components[i] is TPageControl ) then with (Components[i] as TPageControl) do begin
           cname:=name;
           cprop:='caption';
           ctext:=caption;
        end;
        if  ( Components[i] is TTabSheet ) then with (Components[i] as TTabSheet) do begin
           cname:=name;
           cprop:='caption';
           ctext:=caption;
        end;
        if  ( Components[i] is TButton ) then with (Components[i] as TButton) do begin
           cname:=name;
           cprop:='caption';
           ctext:=caption;
        end;
        if  ( Components[i] is TLabel ) then with (Components[i] as TLabel) do begin
           cname:=name;
           cprop:='caption';
           ctext:=caption;
        end;
        if  ( Components[i] is TToolButton ) then with (Components[i] as TToolButton) do begin
           cname:=name;
           cprop:='hint';
           ctext:=hint;
        end;
        if  ( Components[i] is TBitBtn ) then with (Components[i] as TBitBtn) do begin
           cname:=name;
           cprop:='caption';
           ctext:=caption;
        end;
        if  ( Components[i] is TSpeedButton ) then with (Components[i] as TSpeedButton) do begin
           cname:=name;
           cprop:='caption';
           ctext:=caption;
        end;
        if  ( Components[i] is TMemo ) then with (Components[i] as TMemo) do begin
           cname:=name;
           cprop:='text';
           ctext:=text;
        end;
        if  ( Components[i] is TEdit ) then with (Components[i] as TEdit) do begin
           cname:=name;
           cprop:='text';
           ctext:=text;
        end;
        if  ( Components[i] is TMaskEdit ) then with (Components[i] as TMaskEdit) do begin
           cname:=name;
           cprop:='text';
           ctext:=text;
        end;
        if  ( Components[i] is TStringGrid ) then with (Components[i] as TStringGrid) do begin
           cname:=name;
           cprop:='caption';
           ctext:=caption;
        end;
        if  ( Components[i] is TCombobox ) then with (Components[i] as TCombobox) do begin
           for j:=0 to Items.Count-1 do begin
              cname:=name+'.items['+inttostr(j)+']';
              ctext:=Items[j];
              writeln(f,cname+':='''+ctext+''';');
           end;
           ctext:='';
        end;
        if  ( Components[i] is TMenuItem ) then with (Components[i] as TMenuItem) do begin
           cname:=name;
           cprop:='caption';
           ctext:=caption;
        end;
        if  ( Components[i] is TSpinEdit ) then with (Components[i] as TSpinEdit) do begin
           cname:=name;
           cprop:='caption';
           ctext:=caption;
        end;
        if  ( Components[i] is TTreeView ) then with (Components[i] as TTreeView) do begin
           for j:=0 to Items.Count-1 do begin
              cname:=name+'.items['+inttostr(j)+'].text';
              ctext:=Items[j].Text;
              writeln(f,cname+':='''+ctext+''';');
           end;
           cname:=name;
           cprop:='caption';
           ctext:=caption;
        end;
        if  ( Components[i] is TListBox ) then with (Components[i] as TListBox) do begin
           for j:=0 to Items.Count-1 do begin
              cname:=name+'.items['+inttostr(j)+']';
              ctext:=Items[j];
              writeln(f,cname+':='''+ctext+''';');
           end;
           cname:=name;
           cprop:='caption';
           ctext:=caption;
        end;
        if  ( Components[i] is TCheckListbox ) then with (Components[i] as TCheckListbox) do begin
           for j:=0 to Items.Count-1 do begin
              cname:=name+'.items['+inttostr(j)+']';
              ctext:=Items[j];
              writeln(f,cname+':='''+ctext+''';');
           end;
           cname:=name;
           cprop:='caption';
           ctext:=caption;
        end;
        if  ( Components[i] is TGroupBox ) then with (Components[i] as TGroupBox) do begin
           cname:=name;
           cprop:='caption';
           ctext:=caption;
        end;
        if  ( Components[i] is TRadioGroup ) then with (Components[i] as TRadioGroup) do begin
           cname:=name;
           cprop:='caption';
           ctext:=caption;
        end;
        if  ( Components[i] is TCheckGroup ) then with (Components[i] as TCheckGroup) do begin
           cname:=name;
           cprop:='caption';
           ctext:=caption;
        end;
        if  ( Components[i] is TCheckBox ) then with (Components[i] as TCheckBox) do begin
           cname:=name;
           cprop:='caption';
           ctext:=caption;
        end;
        if  ( Components[i] is TRadioButton ) then with (Components[i] as TRadioButton) do begin
           cname:=name;
           cprop:='caption';
           ctext:=caption;
        end;
        if (ctext<>'')and(ctext<>'-')and(ctext<>cname)and(not IsNumber(ctext))then
           writeln(f,cname+'.'+cprop+':='''+ctext+''';');
     end;
end;
end;

end.

