unit microcatunit;
{
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
}
{$mode objfpc}{$H+}
interface

uses math, skylibcat, sysutils;

Type MCTrec = record    ar  : double;
                        de  : double;
                        mb  : double;
                        mr  : double;
                end;

Function IsMCTpath(path : PChar) : Boolean; stdcall;
Procedure OpenMCTwin(ncat : integer;var ok : boolean); stdcall;
Procedure OpenMCT(ar1,ar2,de1,de2: double ;ncat : integer; var ok : boolean); stdcall;
Procedure ReadMCT(var lin : MCTrec; var ok : boolean); stdcall;
procedure CloseMCT ; stdcall;
procedure SetMCTpath(path : PChar); stdcall;

var MCTpath : string;

implementation

Type Catrec = packed record ar,de : longWord;
//                     mb,mr : byte; apparement inverser par raport a la doc
                     mr,mb : byte;
              end;

Type Accrec = record ar   : array[1..8] of char;
                     rec1 : array[1..12] of char;
                     nrec : array[1..9] of char;
                     cr   : char;
                     lf   : char;
              end;
var
   fcat : file of Catrec ;
   curSM,cursub,maxsub : integer;
   Sm,nSM : integer;
   rec1,nrec,CurRec : integer;
   SMlst : array[1..100] of integer;
   FileIsOpen : Boolean = false;
   CurZone : string;
   demin,demax,armin,armax : double;
   fullwin : boolean;

Const SubCat : array[1..3] of string = (slashchar+'tyc',slashchar+'gsc',slashchar+'usno');

Function IsMCTpath(path : PChar) : Boolean; stdcall;
begin
result:=     FileExists(noslash(path)+subcat[1]+slashchar+'Zon0000.acc')
         and FileExists(noslash(path)+subcat[2]+slashchar+'Zon0000.acc')
         and FileExists(noslash(path)+subcat[3]+slashchar+'Zon0000.acc');
end;



procedure SetMCTpath(path : PChar); stdcall;
begin
MCTpath:=noslash(path);
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
  ar:=cat.ar/360000;
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
nomfich:=MCTpath+subcat[cursub]+slashchar+'zon'+nomreg+'.cat';
nomacc:=MCTpath+subcat[cursub]+slashchar+'zon'+nomreg+'.acc';
while not FileExists(nomacc) do
if not FileExists(nomacc) then begin
   ok:=false;
   exit;
end;
if not FileExists(nomfich) then begin
   ok:=false;
   exit;
end;
if fileisopen then CloseRegion;
if fullwin and (northpoleinmap or southpoleinmap) then begin
rec1:=0;
nrec:=99999999;
end else begin
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

Procedure NextRegion(var ok : boolean);
begin
  CloseRegion;
  inc(curSM);
  if curSM>nSM then begin
     curSM:=1;
     inc(cursub);
     if cursub>maxsub then ok:=false
  end
  else ok:=true;
  if ok then begin
    Sm := Smlst[curSM];
    OpenRegion(ok);
  end;
end;

Procedure ReadMCT(var lin : MCTrec; var ok : boolean); stdcall;
var
    cat:CatRec;
    fok:boolean;
begin
ok:=true;
fok:=false;
   repeat
     inc(currec);
     if eof(fcat) or (currec>nrec) then NextRegion(ok);
     if not ok then exit;
     Read(fcat,cat);
     lin.ar:=cat.ar/360000;
     if (lin.ar<armin) then continue;
     if (lin.ar>armax) then begin
        NextRegion(ok);
        if not ok then exit;
        continue;
     end;
     lin.de:=cat.de/360000-90;
     if (lin.de>demin)and(lin.de<demax) then fok:=true;
   until fok;
   lin.ar:=lin.ar/15;
   lin.mb:=(cat.mb/10)-3;
   lin.mr:=(cat.mr/10)-3;
end;

procedure CloseMCT ; stdcall;
begin
curSM:=nSM;
cursub:=1;
CloseRegion;
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

Procedure OpenMCTwin(ncat : integer; var ok : boolean); stdcall;
begin
JDCatalog:=jd2000;
curSM:=1;
FindRegionListWin;
Sm := Smlst[curSM];
cursub:=1;
maxsub:=ncat;
OpenRegion(ok);
end;

Procedure OpenMCT(ar1,ar2,de1,de2: double ;ncat : integer; var ok : boolean); stdcall;
begin
JDCatalog:=jd2000;
curSM:=1;
ar1:=ar1*15; ar2:=ar2*15;
FindRegionList(ar1,ar2,de1,de2);
Sm := Smlst[curSM];
cursub:=1;
maxsub:=ncat;
OpenRegion(ok);
end;

end.
