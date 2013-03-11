unit gsccompact;
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

uses gscconst,
  skylibcat, sysutils;

  type GSCCrec = packed record
                     ar,de : double;
                     gscn: integer;
                     pe,m,me : double;
                     mb,cl : integer;
                     plate : shortstring;
                     mult : shortstring;
                     end;
  type GSCCbin = array[0..11]of char;
  type header = record
       len,vers,region,nobj : integer;
       amin,amax,dmin,dmax,magoff : double;
       scale_ra,scale_dec,scale_pos,scale_mag : double;
       npl : integer;
       plate : array[1..10]of string;
       end;

Function IsGSCCpath(path : string) : Boolean;
procedure SetGSCCpath(path : string);
Procedure OpenGSCC(ar1,ar2,de1,de2: double ; var ok : boolean);
Procedure OpenGSCCwin(var ok : boolean);
Procedure ReadGSCC(var lin : GSCCrec; var SMnum : string ; var ok : boolean);
Procedure NextGSCC( var ok : boolean);
procedure CloseGSCC ;
Procedure FindGSCCnum(SMnum,num :Integer; var ar,de : Double; var ok : boolean);

var
  GSCCpath: String;
  gscext: string = '.gsc';

implementation

var
   fgsc : file ;
   lin : GSCCrec ;
   h : header;
   curSM : integer;
   SMname : string;
   hemis : char;
   zone,Sm,nSM : integer;
   hemislst : array[1..9537] of char;
   zonelst,SMlst : array[1..9537] of integer;
   FileIsOpen : Boolean = false;

Procedure FixCase(p:string);
var i : integer;
begin
p:=slash(p);
for i:=0 to 23 do begin
   if DirectoryExists(p+lowercase(dirlst[i])) then begin dirlst[i]:=lowercase(dirlst[i]); gscN:='n'; gscS:='s';end;
   if DirectoryExists(p+uppercase(dirlst[i])) then begin dirlst[i]:=uppercase(dirlst[i]); gscN:='N'; gscS:='S';end;
   if FileExists(p+dirlst[i]+slashchar+firstfile[i]+lowercase(gscext)) then gscext:=lowercase(gscext);
   if FileExists(p+dirlst[i]+slashchar+firstfile[i]+uppercase(gscext)) then gscext:=uppercase(gscext);
end;
end;

Function IsGSCCpath(path : string) : Boolean;
var p,buf : string;
    tst : array[0..5]of char;
    i,n : integer;
    ok : boolean;
    f : file;
begin
result:=false;
p:=slash(path);
if not DirectoryExists(p) then exit;
FixCase(p);
for i:=0 to 23 do begin
  buf:=p+dirlst[i]+slashchar+firstfile[i]+gscext;
  ok:=FileExists(buf);
  if ok then begin
    FileMode:=0;
    assignfile(f,buf);
    reset(f,1);
    BlockRead(f,tst,6,n);
    closefile(f);
    result:=(n=6)and(tst<>'SIMPLE');
    break;
  end;
end;
end;

procedure SetGSCCpath(path : string);
var buf:string;
begin
buf:=noslash(path);
FixCase(buf);
GSCCpath:=buf;
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

Function NextWord(var buf : string):string;
var p : integer;
begin
p:=pos(' ',buf);
result:=copy(buf,1,p-1);
buf:=copy(buf,p+1,maxint);
end;

Procedure OpenRegion(hemis : char ;zone,S : integer ; var ok:boolean);
var nomzone,nomreg,nomfich :string;
    buf : string;
    w : array[0..512]of char;
    c4 : array[0..3] of char;
    i : integer;
begin
str(S:4,nomreg);
str(abs(zone):4,nomzone);
nomfich:=GSCCpath+slashchar+hemis+padzeros(nomzone,4)+slashchar+padzeros(nomreg,4)+gscext;
if not FileExists(nomfich) then begin
   ok:=false;
   exit;
end;
if fileisopen then CloseRegion;
AssignFile(fgsc,nomfich);
FileisOpen:=true;
SMname:=nomreg;
FileMode:=0;
reset(fgsc,1);
buf:='';
// read header
blockread(fgsc,c4,4);
h.len:=strtoint(trim(c4));
blockread(fgsc,w,h.len-4);
buf:=trim(w);
h.vers:=strtoint(nextword(buf));
h.region:=strtoint(nextword(buf));
h.nobj:=strtoint(nextword(buf));
h.amin:=strtofloat(nextword(buf));
h.amax:=strtofloat(nextword(buf));
h.dmin:=strtofloat(nextword(buf));
h.dmax:=strtofloat(nextword(buf));
h.magoff:=strtofloat(nextword(buf));
h.scale_ra:=strtofloat(nextword(buf));
h.scale_dec:=strtofloat(nextword(buf));
h.scale_pos:=strtofloat(nextword(buf));
h.scale_mag:=strtofloat(nextword(buf));
h.npl:=strtoint(nextword(buf));
for i:=1 to h.npl do begin
  h.plate[i]:=nextword(buf);
end;
ok:=true;
end;

Procedure OpenGSCC(ar1,ar2,de1,de2: double ; var ok : boolean);
begin
JDCatalog:=jd2000;
curSM:=1;
ar1:=ar1*15; ar2:=ar2*15;
if usecache then FindRegionList(ar1,ar2,de1,de2,nSM,zonelst,SMlst,hemislst,gscN,gscS)
            else FindRegionAll(ar1,ar2,de1,de2,nSM,zonelst,SMlst,hemislst,gscN,gscS);
hemis:= hemislst[curSM];
zone := zonelst[curSM];
Sm := Smlst[curSM];
OpenRegion(hemis,zone,Sm,ok);
end;

Procedure ReadGsccRec(var lin : GSCCrec; var ok : boolean);
var c : array[0..11] of byte;
    n,i : integer;
begin
  BlockRead(fgsc,c,12,n);
  if n<>12 then ok:=false;
  lin.gscn := ((c[0] and 127) shl 7)or(c[1] shr 1);
  i := ((c[1] and 1) shl 8) or c[2];
  i := (i shl 8) or c[3];
  i := ((i shl 8) or c[4]) shr 3;
  lin.ar := i/h.scale_ra + h.amin;
  i := (c[4] and 7);
  i := (i shl 8) or c[5];
  i := (i shl 8) or c[6];
  lin.de := i/h.scale_dec + h.dmin;
  i := c[7];
  i := (i shl 1) or (c[8] shr 7);
  lin.pe := i/h.scale_pos;
  i := c[9];
  i := (i shl 3) or (c[10] shr 5);
  lin.m := i/h.scale_mag + h.magoff;
  i := c[8] and 127;
  lin.me := i/h.scale_mag;
  lin.mb := (c[10] shr 1) and 15;
  lin.cl := (c[11] shr 4) and 7;
  i := c[11] and 15;
  lin.plate := h.plate[i+1];
  i := c[10] and 1;
  if i=0 then lin.mult := 'F'
         else lin.mult := 'T';
end;

Procedure ReadGSCC(var lin : GSCCrec; var SMnum : string ; var ok : boolean);
begin
if eof(fgsc) then NextGSCC(ok);
if ok then ReadGsccRec(lin,ok);
SMnum:=SMname;
end;

Procedure NextGSCC( var ok : boolean);
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

procedure CloseGSCC ;
begin
curSM:=nSM;
CloseRegion;
end;

Procedure FindGSCCnum(SMnum,num :Integer; var ar,de : Double; var ok : boolean);
var L1,S1,zone,i,j : integer;
    hemis : char;
    fok : boolean;
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
  repeat
      ReadGsccRec(lin,fok);
      if lin.gscn=num then begin ok:=true; break; end;
  until eof(fgsc);
  if ok then begin
    ar:=lin.ar/15;
    de:=lin.de;
  end;
  Closeregion;
end;
end;

Procedure OpenGSCCwin(var ok : boolean);
begin
JDCatalog:=jd2000;
curSM:=1;
if usecache then FindRegionListWin(nSM,zonelst,SMlst,hemislst,gscN,gscS)
            else FindRegionAllWin(nSM,zonelst,SMlst,hemislst,gscN,gscS);
hemis:= hemislst[curSM];
zone := zonelst[curSM];
Sm := Smlst[curSM];
OpenRegion(hemis,zone,Sm,ok);
end;

end.

