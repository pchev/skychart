unit tyc2unit;
{
Copyright (C) 2000 Patrick Chevalley

http://www.ap-i.net
pchev@geocities.com

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
 correction of an error message if only the first part of the Tycho-2 catalog is installed.
}
{$mode objfpc}{$H+}
interface

uses
  gscconst,
  skylibcat, math, sysutils;

type  TY2rec = record
               ar,de : double;
               gscz: word;
               gscn: word;
               tycn: word;
               bt,vt,pmar,pmde :double;
               end;
     TYC2rec = record
               gscz : array [1..4] of char;
               s1   : char;
               gscn : array [1..5] of char;
               s2   : char;
               tycn : char;
               s3   : array [1..3] of char;
               arm  : array [1..12] of char;
               s4   : char;
               dem  : array [1..12] of char;
               s5   : char;
               pmar : array [1..7] of char;
               s6   : char;
               pmde : array [1..7] of char;
               s7   : array [1..54] of char;
               bt   : array [1..6] of char;
               s8   : array [1..7] of char;
               vt   : array [1..6] of char;
               s9   : array [1..23] of char;
               ar   : array [1..12] of char;
               s10  : char;
               de   : array [1..12] of char;
               s11  : array [1..29] of char;
               crlf : array [1..2] of char;
               end;
     SUP1rec = record
               gscz : array [1..4] of char;
               s1   : char;
               gscn : array [1..5] of char;
               s2   : char;
               tycn : char;
               s3   : array [1..3] of char;
               ar   : array [1..12] of char;
               s4   : char;
               de   : array [1..12] of char;
               s5   : char;
               pmar : array [1..7] of char;
               s6   : char;
               pmde : array [1..7] of char;
               s7   : array [1..27] of char;
               bt   : array [1..6] of char;
               s8   : array [1..7] of char;
               vt   : array [1..6] of char;
               s9   : array [1..20] of char;
               crlf : array [1..2] of char;
               end;
     TYC2idx = record
               rect2 : array [1..7] of char;
               s1    : char;
               recs1 : array [1..6] of char;
               s2    : array [1..28] of char;
               crlf : array [1..2] of char;
               end;
     TYC2bin = packed record
               ar,de : longint;
               pmar,pmde : word;
               gscz: word;
               gscn: word;
               bt,vt :word
               end;

Function IsTY2path(path : string) : Boolean;
procedure SetTY2path(path : string);
Procedure OpenTY2(ar1,ar2,de1,de2: double ;ncat : integer; var ok : boolean);
Procedure OpenTY2win(ncat : integer;var ok : boolean);
Procedure ReadTY2(var lin : TY2rec; var SMnum : string ; var ok : boolean);
Procedure NextTY2( var ok : boolean);
procedure CloseTY2 ;
Procedure FindTYC2num(SMnum,num :Integer; var lin: TY2rec; var ok : boolean);

var
  TY2path: String;

implementation

const CacheNum = 900;
      Numa     = 900;

var
   fbin,sbin  : file of TYC2bin ;
   ftyc2 : file of TYC2rec ;
   fidx2 : file of TYC2idx ;
   fsup1 : file of SUP1rec ;
   lin : TY2rec;
   rec : TYC2rec ;
   idx : TYC2idx ;
   sup : SUP1rec ;
   bin : TYC2bin ;
   curSM,maxcat : integer;
   SMname : string;
   hemis : char;
   zone,Sm,nSM : integer;
   hemislst : array[1..9537] of char;
   zonelst,SMlst : array[1..9537] of integer;
   FileIsOpen : Boolean = false;
   t2rec1,s1rec1,t2nrec,s1nrec,currec : integer;
   readsup,readbin : boolean;
   cache : array[1..CacheNum] of array of TY2rec;
   cachelst,tmax,smax,catread : array[1..CacheNum] of integer;
   OnCache : boolean;
   Ncache,Icache : integer;
   lastcache : integer = 0;
   maxbin : integer = 2;

Function IsTY2path(path : string) : Boolean;
begin
result:= FileExists(slash(path)+'tyc2idx.dat');
end;

procedure SetTY2path(path : string);
var i : integer;
    buf: string;
begin
buf:=noslash(path);
if buf<>TY2path then for i:=1 to CacheNum do cachelst[i]:=0;
TY2path:=buf;
end;

Procedure CloseRegion;
begin
{$I-}
if fileisopen and (curSM=nSM) then begin
FileisOpen:=false;
closefile(fidx2);
if readbin then begin
  closefile(fbin);
  if maxcat>1 then closefile(sbin);
end else begin
  closefile(ftyc2);
  closefile(fsup1);
end;
end;
{$I+}
end;

Procedure OpenRegion(hemis : char ;zone,S : integer ; var ok:boolean);
var nomzone,nomreg,nomfich1,nomfich2,nombin1,nombin2,nomidx :string;
    i,j: integer;
begin
OnCache:=false;                          // search if already in cache
if UseCache then for i:=1 to CacheNum do if cachelst[i]=s then begin OnCache:=true; Ncache:=i;t2nrec:=tmax[Ncache];s1nrec:=smax[Ncache]; break; end;
str(S:4,nomreg);
str(abs(zone):4,nomzone);
Icache:=-1;
currec:=0;
nomfich1:=TY2path+slashchar+'catalog.dat';
nomfich2:=TY2path+slashchar+'suppl_1.dat';
nombin1 :=TY2path+slashchar+'tyc2a.dat';
nombin2 :=TY2path+slashchar+'tyc2b.dat';
if (not OnCache) and UseCache then begin
   j:=lastcache+1;                         // get a free cache
   if j>CacheNum then j:=1;
   cachelst[j]:=s;
   catread[j]:=0;
   tmax[j]:=0;
   smax[j]:=0;
   Ncache:=j;
   lastcache:=j;
end;
if (not OnCache)or(Catread[Ncache]<maxcat) then begin    // work with files
if (not FileExists(nomfich1))and(not FileExists(nombin1)) then begin
   ok:=false;
   exit;
end;
if FileExists(nombin1) then readbin:=true else readbin:=false;
FileMode:=0;
if not fileisopen then begin
if readbin then begin                        // open binary files
  nomidx:=TY2path+slashchar+'tyc2idx.dat';
  AssignFile(fidx2,nomidx);
  reset(fidx2);
  AssignFile(fbin,nombin1);
  reset(fbin);
  if FileExists(nombin2) then begin
  if maxcat>1 then begin
     AssignFile(sbin,nombin2);
     reset(sbin);
  end;
  end else begin
      maxcat:=1;
      maxbin:=maxcat;
  end;
end else begin                              // open text files
  maxcat:=2;
  nomidx:=TY2path+slashchar+'index.dat';
  AssignFile(fidx2,nomidx);
  reset(fidx2);
  AssignFile(ftyc2,nomfich1);
  AssignFile(fsup1,nomfich2);
  reset(ftyc2);
  reset(fsup1);
end;
FileisOpen:=true;
end;
seek(fidx2,S-1);                           // read index
read(fidx2,idx);
t2rec1:=strtoint(idx.rect2);
s1rec1:=strtoint(idx.recs1);
read(fidx2,idx);
t2nrec:=strtoint(idx.rect2)-t2rec1;
s1nrec:=strtoint(idx.recs1)-s1rec1;
if readbin then begin
  i:=t2rec1; t2rec1:=s1rec1; s1rec1:=i;  // inverted  bin index
  i:=t2nrec; t2nrec:=s1nrec; s1nrec:=i;
  if maxcat>1 then seek(sbin,s1rec1-1);
  seek(fbin,t2rec1-1);
end else begin
  seek(fsup1,s1rec1-1);
  seek(ftyc2,t2rec1-1);
end;
if (not OnCache) and UseCache then begin      // initialize cache
   SetLength(cache[Ncache],1);
   tmax[Ncache]:=t2nrec;
   smax[Ncache]:=s1nrec;
   SetLength(cache[Ncache],t2nrec+s1nrec+2);
end;
end;
SMname:=nomreg;
readsup:=false ;    // begin with first file
ok:=true;
end;

Procedure OpenTY2(ar1,ar2,de1,de2: double ;ncat : integer; var ok : boolean);
begin
JDCatalog:=jd2000;
maxcat:=ncat;
if maxbin=1 then maxcat:=maxbin;
curSM:=1;
ar1:=ar1*15; ar2:=ar2*15;
if usecache then FindRegionList2(ar1,ar2,de1,de2,nSM,zonelst,SMlst,hemislst)
            else FindRegionAll(ar1,ar2,de1,de2,nSM,zonelst,SMlst,hemislst);
hemis:= hemislst[curSM];
zone := zonelst[curSM];
Sm := Smlst[curSM];
OpenRegion(hemis,zone,Sm,ok);
end;

Procedure ReadTY2(var lin : TY2rec; var SMnum : string ; var ok : boolean);
begin
inc(currec);
inc(icache);
ok:=true;
if (not readsup)and(currec>t2nrec) then begin         // end of first data file
   catread[ncache]:=MaxIntValue([1,catread[ncache]]);
   if maxcat>1 then begin
      readsup:=true;
      currec:=1;
      if Catread[Ncache]<2 then oncache:=false;
   end else begin
      NextTY2(ok);
      inc(currec);
      inc(icache);
   end;
end;
if readsup and (currec>s1nrec) then begin            // end of second data file
   catread[ncache]:=2;
   NextTY2(ok);
   inc(currec);
   inc(icache);
end;
if not ok then exit;

if not readsup then begin                                  // read first data file
if oncache then lin:=cache[ncache,icache]
else
if readbin then begin
    Read(fbin,bin);
    lin.tycn:=trunc(bin.gscz/10000);
    lin.gscz:=round(frac(bin.gscz/10000)*10000);
    lin.gscn:=bin.gscn;
    lin.ar:=bin.ar/5000000;
    lin.de:=bin.de/5000000;
    lin.pmar:=((word(bin.bt and $0000F000) * 16)+bin.pmar-100000)/10;
    lin.pmde:=((word(bin.vt and $0000F000) * 16)+bin.pmde-100000)/10;
    lin.bt:=((bin.bt and $00000FFF)-200)/100;
    lin.vt:=((bin.vt and $00000FFF)-200)/100;
    if usecache then cache[ncache,icache]:=lin;
end else begin
    Read(ftyc2,rec);
    lin.gscz:=strtoint(rec.gscz);
    lin.gscn:=strtoint(rec.gscn);
    lin.tycn:=strtoint(rec.tycn);
    if trim(rec.arm)>'' then lin.ar:=strtofloat(rec.arm)
                    else lin.ar:=strtofloat(rec.ar);
    if trim(rec.dem)>'' then lin.de:=strtofloat(rec.dem)
                    else lin.de:=strtofloat(rec.de);
    if trim(rec.pmar)>'' then lin.pmar:=strtofloat(rec.pmar)
                     else lin.pmar:=0;
    if trim(rec.pmde)>'' then lin.pmde:=strtofloat(rec.pmde)
                     else lin.pmde:=0;
    if trim(rec.bt)>'' then lin.bt:=strtofloat(rec.bt)
                   else lin.bt:=99;
    if trim(rec.vt)>'' then lin.vt:=strtofloat(rec.vt)
                   else lin.vt:=99;
    if usecache then cache[ncache,icache]:=lin;
end;
end;

if readsup then begin                                      // read second data file
if oncache then lin:=cache[ncache,icache]
else
 if readbin then begin
    Read(sbin,bin);
    lin.tycn:=trunc(bin.gscz/10000);
    lin.gscz:=round(frac(bin.gscz/10000)*10000);
    lin.gscn:=bin.gscn;
    lin.ar:=bin.ar/5000000;
    lin.de:=bin.de/5000000;
    lin.pmar:=((word(bin.bt and $0000F000) * 16)+bin.pmar-100000)/10;
    lin.pmde:=((word(bin.vt and $0000F000) * 16)+bin.pmde-100000)/10;
    lin.bt:=((bin.bt and $00000FFF)-200)/100;
    lin.vt:=((bin.vt and $00000FFF)-200)/100;
    if usecache then cache[ncache,icache]:=lin;
  end else begin
    Read(fsup1,sup);
    lin.gscz:=strtoint(sup.gscz);
    lin.gscn:=strtoint(sup.gscn);
    lin.tycn:=strtoint(sup.tycn);
    lin.ar:=strtofloat(sup.ar);
    lin.de:=strtofloat(sup.de);
    if trim(sup.pmar)>'' then lin.pmar:=strtofloat(sup.pmar)
                     else lin.pmar:=0;
    if trim(sup.pmde)>'' then lin.pmde:=strtofloat(sup.pmde)
                     else lin.pmde:=0;
    if trim(sup.bt)>'' then lin.bt:=strtofloat(sup.bt)
                   else lin.bt:=99;
    if trim(sup.vt)>'' then lin.vt:=strtofloat(sup.vt)
                   else lin.vt:=99;
    if usecache then cache[ncache,icache]:=lin;
  end;
  end;
SMnum:=SMname;
end;

Procedure NextTY2( var ok : boolean);
begin
  CloseRegion;
  inc(curSM);
  if curSM>nSM then ok:=false
  else begin
    hemis:= hemislst[curSM];
    zone := zonelst[curSM];
    Sm := Smlst[curSM];
    OpenRegion(hemis,zone,Sm,ok);
  end;
end;

procedure CloseTY2 ;
begin
curSM:=nSM;
CloseRegion;
end;

Procedure OpenTY2win(ncat : integer; var ok : boolean);
begin
JDCatalog:=jd2000;
maxcat:=ncat;
if maxbin=1 then maxcat:=maxbin;
curSM:=1;
if usecache then FindRegionListWin2(nSM,zonelst,SMlst,hemislst)
            else FindRegionAllWin(nSM,zonelst,SMlst,hemislst);
hemis:= hemislst[curSM];
zone := zonelst[curSM];
Sm := Smlst[curSM];
OpenRegion(hemis,zone,Sm,ok);
end;

Procedure FindTYC2num(SMnum,num :Integer; var lin: TY2rec; var ok : boolean);
var L1,S1,zone,i,j : integer;
    hemis : char;
    fok : boolean;
    buf:string;
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
ok:=false;
repeat
    ReadTY2(lin,buf,fok);
    if lin.gscn=num then begin ok:=true; break; end;
until not fok;
Closeregion;
end;

end.
