unit usnobunit;
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
{$mode objfpc}{$H+}
interface

uses math,
  skylibcat, sysutils;

Type USNOBrec = record  id  : shortstring;
                        ra  : double;
                        de  : double;
                        pmra  : double;
                        pmde  : double;
                        mb1  : double;
                        mr1  : double;
                        mb2  : double;
                        mr2  : double;
                end;

Function IsUSNOBpath(path : string) : Boolean;
Procedure OpenUSNOBwin(var ok : boolean);
Procedure OpenUSNOB(ar1,ar2,de1,de2: double ; var ok : boolean);
Procedure ReadUSNOB(var lin : USNOBrec; var ok : boolean);
procedure CloseUSNOB ;
procedure SetUSNOBpath(path : string);
Procedure FindUSNOBnum(zone,num :integer; var ar,de : Double; var ok : boolean);

var USNOBpath : string;

implementation

Type Catrec = record d: array[1..20] of longword ; end;

Type Accrec = record ar   : array[1..5] of char;
                     rec1 : array[1..12] of char;
                     nrec : array[1..12] of char;
                     lf   : char;
              end;
var
   fcat : file of Catrec ;
   curSM : integer;
   Sm,nSM : integer;
   rec1,nrec,CurRec : integer;
   SMlst : array[1..500] of integer;
   FileIsOpen : Boolean = false;
   CurZone : string;
   demin,demax,armin,armax : double;
//   fullwin : boolean;

Function IsUSNOBpath(path : string) : Boolean;
var p : string;
begin
p:=slash(path);
result:= FileExists(p+slash('000')+'b0000.acc');
end;


procedure SetUSNOBpath(path : string);
begin
USNOBpath:=noslash(path);
end;

Procedure CloseRegion;
begin
{$I-}
if fileisopen then begin
FileisOpen:=false;
closefile(fcat);
end;
{$I+}
end;

Procedure SetFirstRec;
var
    cat:CatRec;
    a : cardinal;
    i : integer;
    ar : double;
begin
i:=currec;
ar:=0;
repeat
  i:=i+1000;
  if i>nrec then break;
  seek(fcat,rec1+i);
  Read(fcat,cat);
  if eof(fcat) then break;
  a:=cat.d[1];
  ar:=a/360000;
until (ar>armin);
i:=i-1000;
seek(fcat,rec1+i);
currec:=i;
end;

Procedure OpenRegion(var ok:boolean);
var nomreg,nomfich,nomacc,nomdir :string;
    dir,zone,box : integer;
    facc : file of Accrec ;
    acc : accrec;
begin
box:=0;
{if fullwin and northpoleinmap then nomreg:='1799'
else if fullwin and southpoleinmap then nomreg:='0000'
else} begin
zone:= ((sm-1) div 96);
dir := zone div 10;
box := ((sm-1) mod 96);
str(zone:4,nomreg);
nomreg:=padzeros(nomreg,4);
str(dir:3,nomdir);
nomdir:=padzeros(nomdir,3);
end;
CurZone:=nomreg;
nomfich:=slash(USNOBpath)+slash(nomdir)+'b'+nomreg+'.cat';
if not FileExists(nomfich) then begin
   ok:=false;
   exit;
end;
if fileisopen then CloseRegion;
{if fullwin and (northpoleinmap or southpoleinmap) then begin
 rec1:=0;
 nrec:=99999999;
end else} begin
 nomacc:=slash(USNOBpath)+slash(nomdir)+'b'+nomreg+'.acc';
 AssignFile(facc,nomacc);
 FileMode:=0;
 reset(facc);
 seek(facc,box);
 read(facc,acc);
 rec1:=strtoint(trim(acc.rec1));
 nrec:=strtoint(trim(acc.nrec));
 CloseFile(facc);
end;
AssignFile(fcat,nomfich);
FileisOpen:=true;
FileMode:=0;
reset(fcat);
seek(fcat,rec1);
currec:=1;
if (armax-armin)<300 then setfirstrec;
ok:=true;
end;

Procedure NextRegion( var ok : boolean);
begin
  CloseRegion;
  inc(curSM);
  if curSM>nSM then ok:=false
  else begin
    Sm := Smlst[curSM];
    OpenRegion(ok);
  end;
end;

Procedure ReadUSNOB(var lin : USNOBrec; var ok : boolean);
var
    cat:CatRec;
    ar,de : cardinal;
    n : longint;
    buf : string;
    fok:boolean;
begin
ok:=true;
fok:=false;
   repeat
     inc(currec);
     if eof(fcat) or (currec>nrec) then NextRegion(ok);
     if not ok then exit;
     Read(fcat,cat);
     ar:=cat.d[1];
     lin.ra:=ar/360000;
     if (lin.ra<armin) then continue;
     if (lin.ra>armax) then begin
        NextRegion(ok);
        if not ok then exit;
        continue;
     end;
     de:=cat.d[2];
     lin.de:=de/360000-90;
     if (lin.de>demin)and(lin.de<demax) then fok:=true;
   until fok;
   n:=cat.d[3]; // PM
   lin.pmra:=(frac(n/1e4)*1e4*0.002-10);
   n:=trunc(n/1e4);
   lin.pmde:=(frac(n/1e4)*1e4*0.002-10);
   n:=cat.d[6]; // mb1
   lin.mb1:=frac(n/1e4)*1e4*0.01;
   n:=cat.d[7]; // mr1
   lin.mr1:=frac(n/1e4)*1e4*0.01;
   n:=cat.d[8]; // mb2
   lin.mb2:=frac(n/1e4)*1e4*0.01;
   n:=cat.d[9]; // mr2
   lin.mr2:=frac(n/1e4)*1e4*0.01;
   str((rec1+currec):7,buf);
   lin.id:=CurZone+'-'+padzeros(buf,7);
end;

procedure CloseUSNOB ;
begin
curSM:=nSM;
CloseRegion;
end;

Procedure FindUSNOBnum(zone,num :integer; var ar,de : Double; var ok : boolean);
var nomfich,nomreg,nomdir: string;
    lin : USNOBrec;
    dir : integer;
begin
ok:=false;
if num<1 then exit;
dir := zone div 10;
str(zone:4,nomreg);
nomreg:=padzeros(nomreg,4);
str(dir:3,nomdir);
nomdir:=padzeros(nomdir,3);
CurZone:=nomreg;
nomfich:=slash(USNOBpath)+slash(nomdir)+'b'+nomreg+'.cat';
if not FileExists(nomfich) then exit;
AssignFile(fcat,nomfich);
FileisOpen:=true;
FileMode:=0;
reset(fcat);
rec1:=0;
nrec:=MaxInt;
curSM:=1;
nSM:=1;
armin:=-1E99;
armax:=1E99;
demin:=-1E99;
demax:=1E99;
currec:=num-1;
seek(fcat,currec);
if not eof(fcat) then begin
  ReadUSNOB(lin,ok);
  ar:=lin.ra/15;
  de:=lin.de;
end;
CloseUSNOB;
end;

Procedure FindRegionU(ar,de : double; var lg : integer);
var i1,i2,N,L1 : integer;
begin
i1 := Trunc((de+90)/0.1) ;
N  := 96;
L1 := N*i1+1;
i2 := Trunc(ar/(360/N));
Lg := L1+i2;
end;

Procedure FindRegionListWin;
var
   xx,yy,dx,dy,Sm,i,j,k : integer;
   ar,de,arp,dep : double;
   def : boolean;
begin
//fullwin:=true;
dx:=Trunc((xmax-xmin)/9);
dy:=Trunc((ymax-ymin)/49);
nSM:=0;
demin:=90;
demax:=-90;
armin:=360;
armax:=0;
for i:=0 to 49 do begin
  yy:=ymin+i*dy ;
  for j:=0 to 9 do begin
    xx:=xmin+j*dx ;
    GetADxy(xx,yy,ar,de);
    ar:=ar*15;
    if ar>=360 then ar:=ar-360;
    if ar<0 then ar:=ar+360;
    arp:=ar; dep:=de;
    precession(JDChart,JDCatalog,arp,dep);
    FindregionU(arp,dep,Sm);
    demin:=minvalue([demin,dep]);
    demax:=maxvalue([demax,dep]);
    armin:=minvalue([armin,arp]);
    armax:=maxvalue([armax,arp]);
    def:=true ;
    for k:=1 to nSM do begin
      if Sm=SMlst[k] then def:=false
    end;
    if def then begin
      inc(nSM);
      SMlst[nSM]:=Sm;
    end;
  end;
end;
if (armax-armin)>300 then begin
   armin:=0;
   armax:=360;
end;
if northpoleinmap then begin
//   nSM:=1;
   demax:=90;
end;
if southpoleinmap then begin
//   nSM:=1;
   demin:=-90;
end;
end;

procedure FindRegionList(x1,x2,y1,y2:Double );
var
   Sm,i,j,k : integer;
   ar,de,dar,dde,arp,dep : double;
   def : boolean;
begin
//fullwin:=false;
demin:=90;
demax:=-90;
armin:=360;
armax:=0;
dar:=(x2-x1)/9;
dde:=(y2-y1)/9;
nSM:=0;
for i:=0 to 9 do begin
  ar:=x1+i*dar ;
  if ar>=360 then ar:=ar-360;
  if ar<0 then ar:=ar+360;
  for j:=0 to 9 do begin
    de:=y1+j*dde ;
    arp:=ar; dep:=de;
    precession(JDChart,JDCatalog,arp,dep);
    if abs(dep) >= 90 then continue;
    FindregionU(arp,dep,Sm);
    demin:=minvalue([demin,dep]);
    demax:=maxvalue([demax,dep]);
    armin:=minvalue([armin,arp]);
    armax:=maxvalue([armax,arp]);
    def:=true ;
    for k:=1 to nSM do begin
      if Sm=Smlst[k] then def:=false
    end;
    if def then begin
      inc(nSM);
      Smlst[nSm]:=Sm;
    end;
  end;
end;
if (armax-armin)>300 then begin
   armin:=0;
   armax:=360;
end;
end;

Procedure OpenUSNOBwin(var ok : boolean);
begin
JDCatalog:=jd2000;
curSM:=1;
FindRegionListWin;
Sm := Smlst[curSM];
OpenRegion(ok);
end;

Procedure OpenUSNOB(ar1,ar2,de1,de2: double ; var ok : boolean);
begin
JDCatalog:=jd2000;
curSM:=1;
ar1:=ar1*15; ar2:=ar2*15;
FindRegionList(ar1,ar2,de1,de2);
Sm := Smlst[curSM];
OpenRegion(ok);
end;

end.
