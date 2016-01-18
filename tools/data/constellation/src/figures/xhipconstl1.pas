unit xhipconstl1;

{$MODE Delphi}

{
Copyright (C) 2002 Patrick Chevalley

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
{
 Build Constellation Figure file.
}

interface

uses Math, FileCtrl, Registry,
  LCLIntf, LCLType, LMessages, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, MaskEdit,  ComCtrls, FileUtil;

type

  { TConvForm }

  TConvForm = class(TForm)
    BitBtn1: TBitBtn;
    Edit1: TEdit;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    BitBtn2: TBitBtn;
    FilenameEdit1: TEdit;
    FilenameEdit2: TEdit;
    GroupBox3: TGroupBox;
    Label1: TLabel;
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    hr: array[1..10000,1..6] of double; // Ra,Dec,pmra,pmdec,px,rv
    procedure getHR;
  public
    { Public declarations }
  end;

var
  ConvForm: TConvForm;

const
  invdbl: double = 1.23456E99;
  deg2rad = pi / 180;
  rad2deg = 180 / pi;
  pi2 = 2 * pi;
  secarc = deg2rad / 3600;
  km_au = 149597870.691;
  vfr = (365.25 * 86400.0 / km_au) * secarc;

type
  coordvector = array[1..3] of double;
  rotmatrix = array[1..3, 1..3] of double;

implementation

{$R *.lfm}


procedure sofa_S2C(theta,phi: double; var c: coordvector);
// Convert spherical coordinates to Cartesian.
// THETA    d         longitude angle (radians)
// PHI      d         latitude angle (radians)
var sa,ca,sd,cd: extended;
begin
sincos(theta,sa,ca);
sincos(phi,sd,cd);
c[1]:=ca*cd;
c[2]:=sa*cd;
c[3]:=sd;
end;

procedure sofa_c2s(p: coordvector; var theta,phi: double);
// P-vector to spherical coordinates.
// THETA    d         longitude angle (radians)
// PHI      d         latitude angle (radians)
var x,y,z,d2: double;
begin
X := P[1];
Y := P[2];
Z := P[3];
D2 := X*X + Y*Y;
IF ( D2 = 0 ) THEN
   theta := 0
ELSE
   theta := arctan2(Y,X);
IF ( Z = 0 ) THEN
   phi := 0
ELSE
   phi := arctan2(Z,SQRT(D2));
end;

function  Rmod(x,y:Double):Double;
BEGIN
    Rmod := x - Int(x/y) * y ;
END  ;

procedure ProperMotion(var r0,d0: double; t,pr,pd: double; fullmotion: boolean;px,rv:double);
var w: extended;
    cr0,sr0,cd0,sd0: extended;
    i: integer;
    p,em: coordvector;
begin
if fullmotion then begin
  // "communicated by Patrick Wallace, RAL Space, UK"
  sincos(r0,sr0,cr0);
  sincos(d0,sd0,cd0);
  pr:=pr/cd0;
  sofa_S2C(r0,d0,p);
  w := vfr*rv*px;
  em[1] := - pr*p[2] - pd*cr0*sd0 + w*p[1];
  em[2] :=   pr*p[1] - pd*sr0*sd0 + w*p[2];
  em[3] :=             pd*cd0     + w*p[3];
  for i:=1 to 3 do
     p[i] := p[i]+t*em[i];
  sofa_C2S(p,r0,d0);
end else begin
  r0:=r0+(pr/cos(d0))*t;
  d0:=d0+(pd)*t;
end;
r0:=rmod(r0+pi2,pi2);
end;


function copyp(t1: string; First, last: integer): string;
begin
  Result := copy(t1, First, last - First + 1);
end;

procedure TConvForm.getHR;
var
  bsc: textfile;
  buf: string;
  ar,de,des,pmra,pmde,px,rv : double;
  n,hrn: integer;
begin
  for n:=1 to 10000 do begin
    hr[n,1]:=invdbl;
    hr[n,2]:=invdbl;
    hr[n,3]:=invdbl;
    hr[n,4]:=invdbl;
    hr[n,5]:=invdbl;
    hr[n,6]:=invdbl;
  end;
  AssignFile(bsc, 'cdc_xhip_hr.dat');
  reset(bsc);
  readln(bsc, buf); // skip header
  n:=0;
  while not EOF(bsc) do
  begin
    readln(bsc, buf);
    inc(n);
    hrn:=StrToIntDef(trim(copyp(buf, 27, 30)),0);
    if hrn=0 then raise exception.create('hrn '+buf);
    ar:=strtofloatdef(trim(copyp(buf, 49, 60)),invdbl);
    if ar=invdbl then raise exception.create('ar '+buf);
    de:=strtofloatdef(trim(copyp(buf, 62, 73)),invdbl);
    if de=invdbl then raise exception.create('de '+buf);
    pmra:=strtofloatdef(trim(copyp(buf, 82, 89)),0);
    pmde:=strtofloatdef(trim(copyp(buf, 91, 98)),0);
    px:=strtofloatdef(trim(copyp(buf, 75, 80)),0);
    rv:=strtofloatdef(trim(copyp(buf, 127, 133)),0);
    hr[hrn,1]:=ar*deg2rad;
    hr[hrn,2]:=de*deg2rad;
    hr[hrn,3]:=pmra*deg2rad/1000/3600;
    hr[hrn,4]:=pmde*deg2rad/1000/3600;
    hr[hrn,5]:=px/1000;
    hr[hrn,6]:=rv;
  end;
  closefile(bsc);
end;


procedure TConvForm.BitBtn1Click(Sender: TObject);
var fi : textfile;
    fo,err : textfile;
    buf,c,h1,h2 : string;
    h,nerr : integer;
    pmra,pmde,px,rv,dyear : double;
    ar1,de1,ar2,de2 : double;
    ok : boolean;
    msg : array[0..99]of char;
begin
label1.Caption:='';
Application.ProcessMessages;
assignfile(fi,filenameedit1.text);
reset(fi);
assignfile(fo,filenameedit2.text);
assignfile(err,'Error.txt');
rewrite(fo);
rewrite(err);
try
getHR;
dyear:=StrToFloat(edit1.Text)-1991.5;  // HIP epoch
nerr:=0;
repeat
  readln(fi,buf);
  application.processmessages;
  if trim(buf)='' then continue;
  if copy(buf,1,1)=';' then continue;
  c:=copy(buf,1,3);
  h1:=trim(copy(buf,6,5));
  h2:=trim(copy(buf,13,5));
  h:= strtoint(h1);
  ar1:=hr[h,1];
  if ar1=invdbl then begin
    writeln(err,'HR'+h1+' not in Hipparcos, ignoring this point.');
    inc(nerr);
    Continue;
  end;
  de1:=hr[h,2];
  pmra:=hr[h,3];
  pmde:=hr[h,4];
  px:=hr[h,5];
  rv:=hr[h,6];
  propermotion(ar1,de1,dyear,pmra,pmde,true,px,rv);
  ar1:=rad2deg*ar1/15;
  de1:=rad2deg*de1;
  h:= strtoint(h2);
  ar2:=hr[h,1];
  if ar2=invdbl then begin
    writeln(err,'HR'+h2+' not in Hipparcos, ignoring this point.');
    inc(nerr);
    Continue;
  end;
  de2:=hr[h,2];
  pmra:=hr[h,3];
  pmde:=hr[h,4];
  px:=hr[h,5];
  rv:=hr[h,6];
  propermotion(ar2,de2,dyear,pmra,pmde,true,px,rv);
  ar2:=rad2deg*ar2/15;
  de2:=rad2deg*de2;
  writeln(fo,format('%8.5f %8.4f %8.5f %8.4f',[ar1,de1,ar2,de2]));
until eof(fi);
closefile(fi);
closefile(fo);
closefile(err);
if nerr=0 then label1.Caption:='Completed!'
else label1.Caption:='Error! see Error.txt';
except
 closefile(fi);
 closefile(fo);
 raise;
end
end;

procedure TConvForm.BitBtn2Click(Sender: TObject);
begin
Close;
end;

procedure TConvForm.FormShow(Sender: TObject);
begin
label1.Caption:='';
filenameedit1.Text:='DefaultConstL.txt';
filenameedit2.Text:='DefaultConstL.cln';
end;

end.
