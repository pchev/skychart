unit usnoaunit;
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
Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
}
{$mode objfpc}{$H+}
interface

uses math,
  skylibcat, sysutils;

Type USNOArec = record  id  : shortstring;
                        ar  : double;
                        de  : double;
                        mb  : double;
                        mr  : double;
                        field,q,s: integer;
                end;

Function IsUSNOApath(path : string) : Boolean;
Procedure OpenUSNOAwin(var ok : boolean);
Procedure OpenUSNOA(ar1,ar2,de1,de2: double ; var ok : boolean);
Procedure ReadUSNOA(var lin : USNOArec; var ok : boolean);
procedure CloseUSNOA ;
procedure SetUSNOApath(path : string);
Procedure FindUSNOAnum(zone,num :integer; var ar,de : Double; var ok : boolean);

var USNOApath : string;

implementation

Type Catrec = record ar,de,ma : longword; end;

Type Accrec = record ar   : array[1..8] of char;
                     rec1 : array[1..12] of char;
                     nrec : array[1..9] of char;
                     lf   : char;
              end;
var
   fcat : file of Catrec ;
   curSM : integer;
   Sm,nSM : integer;
   rec1,nrec,CurRec : integer;
   SMlst : array[1..100] of integer;
   FileIsOpen : Boolean = false;
   CurZone : string;
   demin,demax,armin,armax : double;
   fullwin : boolean;

Function IsUSNOApath(path : string) : Boolean;
var p : string;
begin
p:=slash(path);
result:= FileExists(p+'zone0000.acc')
         or FileExists(p+'zone0075.acc')
         or FileExists(p+'zone0150.acc')
         or FileExists(p+'zone0225.acc')
         or FileExists(p+'zone0300.acc')
         or FileExists(p+'zone0375.acc')
         or FileExists(p+'zone0450.acc')
         or FileExists(p+'zone0525.acc')
         or FileExists(p+'zone0600.acc')
         or FileExists(p+'zone0675.acc')
         or FileExists(p+'zone0750.acc')
         or FileExists(p+'zone0825.acc')
         or FileExists(p+'zone0900.acc')
         or FileExists(p+'zone0975.acc')
         or FileExists(p+'zone1050.acc')
         or FileExists(p+'zone1125.acc')
         or FileExists(p+'zone1200.acc')
         or FileExists(p+'zone1275.acc')
         or FileExists(p+'zone1350.acc')
         or FileExists(p+'zone1425.acc')
         or FileExists(p+'zone1500.acc')
         or FileExists(p+'zone1575.acc')
         or FileExists(p+'zone1650.acc')
         or FileExists(p+'zone1725.acc');
end;


procedure SetUSNOApath(path : string);
begin
USNOApath:=noslash(path);
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
  a:=InvertI32(cat.ar);
  ar:=a/360000;
until (ar>armin);
i:=i-1000;
seek(fcat,rec1+i);
currec:=i;
end;

Procedure OpenRegion(var ok:boolean);
var nomreg,nomfich,nomacc :string;
    zone,box : integer;
    facc : file of Accrec ;
    acc : accrec;
begin
box:=0;
if fullwin and northpoleinmap then nomreg:='1725'
else if fullwin and southpoleinmap then nomreg:='0000'
else begin
zone:= ((sm-1) div 96)*75 ;
box := ((sm-1) mod 96);
str(zone:4,nomreg);
nomreg:=padzeros(nomreg,4);
end;
CurZone:=nomreg;
nomfich:=USNOApath+slashchar+'zone'+nomreg+'.cat';
if not FileExists(nomfich) then begin
   ok:=false;
   exit;
end;
if fileisopen then CloseRegion;
if fullwin and (northpoleinmap or southpoleinmap) then begin
rec1:=0;
nrec:=99999999;
end else begin
nomacc:=USNOApath+slashchar+'zone'+nomreg+'.acc';
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

Procedure ReadUSNOA(var lin : USNOArec; var ok : boolean);
var
    cat:CatRec;
    ar,de : cardinal;
    ma : longint;
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
     ar:=InvertI32(cat.ar);
     lin.ar:=ar/360000;
     if (lin.ar<armin) then continue;
     if (lin.ar>armax) then begin
        NextRegion(ok);
        if not ok then exit;
        continue;
     end;
     de:=InvertI32(cat.de);
     lin.de:=de/360000-90;
     if (lin.de>demin)and(lin.de<demax) then fok:=true;
   until fok;
   ma:=InvertI32(cat.ma);
   lin.ar:=lin.ar/15;
   lin.s:=trunc(sgn(ma));
   ma:=abs(ma);
   lin.q:=trunc(ma/1e9); ma:=trunc(1e9*frac(ma/1e9));
   lin.field:=trunc(ma/1e6); ma:=trunc(1e6*frac(ma/1e6));
   lin.mb:=trunc(ma/1e3)/10; ma:=trunc(1e3*frac(ma/1e3));
   lin.mr:=ma/10;
   str((rec1+currec):8,buf);
   lin.id:=CurZone+'-'+padzeros(buf,8);
end;

procedure CloseUSNOA ;
begin
curSM:=nSM;
CloseRegion;
end;

Procedure FindUSNOAnum(zone,num :integer; var ar,de : Double; var ok : boolean);
var nomfich: string;
    lin : USNOArec;
begin
ok:=false;
if num<1 then exit;
nomfich:=USNOApath+slashchar+'zone'+PadZeros(inttostr(zone),4)+'.cat';
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
  ReadUSNOA(lin,ok);
  ar:=lin.ar;
  de:=lin.de;
end;
CloseUSNOA;
end;

Procedure FindRegionU(ar,de : double; var lg : integer);
var i1,i2,N,L1 : integer;
begin
i1 := Trunc((de+90)/7.5) ;
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
fullwin:=true;
dx:=Trunc((xmax-xmin)/9);
dy:=Trunc((ymax-ymin)/9);
nSM:=0;
demin:=90;
demax:=-90;
armin:=360;
armax:=0;
for i:=0 to 9 do begin
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
   nSM:=1;
   demax:=90;
end;
if southpoleinmap then begin
   nSM:=1;
   demin:=-90;
end;
end;

procedure FindRegionList(x1,x2,y1,y2:Double );
var
   Sm,i,j,k : integer;
   ar,de,dar,dde,arp,dep : double;
   def : boolean;
begin
fullwin:=false;
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

Procedure OpenUSNOAwin(var ok : boolean);
begin
JDCatalog:=jd2000;
curSM:=1;
FindRegionListWin;
Sm := Smlst[curSM];
OpenRegion(ok);
end;

Procedure OpenUSNOA(ar1,ar2,de1,de2: double ; var ok : boolean);
begin
JDCatalog:=jd2000;
curSM:=1;
ar1:=ar1*15; ar2:=ar2*15;
FindRegionList(ar1,ar2,de1,de2);
Sm := Smlst[curSM];
OpenRegion(ok);
end;

end.
