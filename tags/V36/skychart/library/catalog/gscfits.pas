unit gscfits;
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

uses gscconst,
  skylibcat, sysutils;

type GSCFrec = packed record
                     ar,de : double;
                     gscn: integer;
                     pe,m,me : double;
                     mb,cl : integer;
                     plate,mult : shortstring;
                     end;

Function IsGSCFpath(path : string) : Boolean;
procedure SetGSCFpath(path : string);
Procedure OpenGSCF(ar1,ar2,de1,de2: double ; var ok : boolean);
Procedure OpenGSCFwin(var ok : boolean);
Procedure ReadGSCF(var lin : GSCFrec; var SMnum : string ; var ok : boolean);
procedure CloseGSCF ;
Procedure FindGSCFnum(SMnum,num :Integer; var ar,de : Double; var ok : boolean);

var
  GSCFpath: String;

implementation

Const
    maxl=2880 ;

var
   fgsc : file ;
   buf : array[1..maxl] of char;
   recsz,nrecs,currec,curSM : integer;
   SMname : string;
   hemis : char;
   zone,Sm,nSM : integer;
   hemislst : array[1..9537] of char;
   zonelst,SMlst : array[1..9537] of integer;
   FileIsOpen : Boolean = false;

Function IsGSCFpath(path : string) : Boolean;
var p,buf : string;
    tst : array[0..5]of char;
    i,n : integer;
    ok : boolean;
    f : file;
begin
p:=slash(path);
result:=false;
for i:=0 to 23 do begin
  buf:=p+dirlst[i]+slashchar+firstfile[i]+'.gsc';
  ok:=FileExists(buf);
  if ok then begin
    FileMode:=0;
    assignfile(f,buf);
    reset(f,1);
    BlockRead(f,tst,6,n);
    closefile(f);
    result:=(n=6)and(tst='SIMPLE');
    break;
  end;
end;
end;

procedure SetGSCFpath(path : string);
var buf:string;
begin
buf:=noslash(path);
GSCFpath:=buf;
end;

procedure ReadFITSHeader;
var debut,fin : boolean;
    t: string;
    d1,d2,l,r,i : integer;
    header,value : string;
begin
FileMode:=0;
reset(fgsc,1);
l:=80;
debut:=true; fin:=false;
repeat
 BlockRead(fgsc,buf,maxl,r);
 for i:=0 to 35 do begin
   t:=copy(buf,80*i+1,l);
   d1:=pos('=',t);
   if (d1=0) and (trim(t)<>'END') then continue;
   d2:=pos('/',t);
   if d2=0 then d2:=l ;
   header:=trim(copy(t,1,d1-1));
   value:=trim(copy(t,d1+1,d2-d1-1));
   if (header='XTENSION') and (copy(value,2,5)='TABLE') then debut:=false;
   if debut then continue;
   if trim(t)='END' then fin:=true;
   if (header='NAXIS1') then recsz:=strtoint(value);
   if (header='NAXIS2') then nrecs:=strtoint(value);
 end;
until fin;
end;

Procedure CloseRegion;
begin
{$I-}
if fileisopen then begin
FileisOpen:=false;
closefile(fgsc);
end;
{$I+}
end;

Procedure OpenRegion(hemis : char ;zone,S : integer ; var ok:boolean);
var nomzone,nomreg,nomfich :string;
begin
str(S:4,nomreg);
str(abs(zone):4,nomzone);
nomfich:=GSCFpath+slashchar+hemis+padzeros(nomzone,4)+slashchar+padzeros(nomreg,4)+'.GSC';
if not FileExists(nomfich) then begin
   ok:=false;
   exit;
end;
if fileisopen then CloseRegion;
AssignFile(fgsc,nomfich);
FileisOpen:=true;
ReadFITSHeader;
SMname:=nomreg;
ok:=true;
end;

Procedure ReadFITSRec(l:integer ; var rec : string);
var
   r : integer;
begin
 BlockRead(fgsc,buf,l,r);
 rec:=copy(buf,1,l);
end;

Procedure OpenGSCF(ar1,ar2,de1,de2: double ; var ok : boolean);
begin
JDCatalog:=jd2000;
currec:=0;
curSM:=1;
ar1:=ar1*15; ar2:=ar2*15;
if usecache then FindRegionList(ar1,ar2,de1,de2,nSM,zonelst,SMlst,hemislst)
            else FindRegionAll(ar1,ar2,de1,de2,nSM,zonelst,SMlst,hemislst);
hemis:= hemislst[curSM];
zone := zonelst[curSM];
Sm := Smlst[curSM];
OpenRegion(hemis,zone,Sm,ok);
end;

Procedure ReadGSCF(var lin : GSCFrec; var SMnum : string ; var ok : boolean);
var rec : string;
begin
inc(currec);
if currec>nrecs then begin
  CloseRegion;
  inc(curSM);
  if curSM>nSM then ok:=false
  else begin
    hemis:= hemislst[curSM];
    zone := zonelst[curSM];
    Sm := Smlst[curSM];
    currec:=1;
    OpenRegion(hemis,zone,Sm,ok);
  end;
end;
if ok then begin
   ReadFITSRec(recsz,rec);
   lin.gscn:=strtoint(copy(rec,1,5));
   lin.ar:=strtofloat(copy(rec,6,9));
   lin.de:=strtofloat(copy(rec,15,9));
   lin.pe:=strtofloat(copy(rec,24,5));
   lin.m:=strtofloat(copy(rec,29,5));
   lin.me:=strtofloat(copy(rec,34,4));
   lin.mb:=strtoint(copy(rec,38,2));
   lin.cl:=strtoint(copy(rec,40,1));
   lin.plate:=copy(rec,41,4);
   lin.mult:=copy(rec,45,1);
end;
SMnum:=SMname;
end;

procedure CloseGSCF ;
begin
currec:=nrecs;
curSM:=nSM;
CloseRegion;
end;

Procedure FindGSCFnum(SMnum,num :Integer; var ar,de : Double; var ok : boolean);
var L1,S1,zone,i,j : integer;
    hemis : char;
    rec : string;
begin
ok:=false ;
for i:=0 to 11 do begin
  L1:=lg_reg_x[i,2] ;
  S1:=sm_reg_x[L1,1] ;
  if SMnum>=S1 then begin ok:=true; break; end;
end;
if not ok then begin
for i:=0 to 11 do begin
  j:=23-i;
  L1:=lg_reg_x[j,2] ;
  S1:=sm_reg_x[L1,1] ;
  if SMnum>=S1 then  break;
end;
i:=j;
end;
hemis:=dirlst[i,1];
zone:=strtoint(copy(dirlst[i],2,4));
OpenRegion(hemis,zone,Smnum,ok);
if ok then begin
  ok:=false;
  for i:=1 to nrecs do begin
      ReadFITSRec(recsz,rec);
      if strtoint(copy(rec,1,5))=num then begin ok:=true; break; end;
  end;
  if ok then begin
    ar:=strtofloat(copy(rec,6,9))/15;
    de:=strtofloat(copy(rec,15,9));
  end;
  Closeregion;
end;
end;

Procedure OpenGSCFwin(var ok : boolean);
begin
JDCatalog:=jd2000;
currec:=0;
curSM:=1;
if usecache then FindRegionListWin(nSM,zonelst,SMlst,hemislst)
            else FindRegionAllWin(nSM,zonelst,SMlst,hemislst);
hemis:= hemislst[curSM];
zone := zonelst[curSM];
Sm := Smlst[curSM];
OpenRegion(hemis,zone,Sm,ok);
end;

end.
