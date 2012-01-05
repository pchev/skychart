unit gcatunit;
{
Copyright (C) 2000 Patrick Chevalley

http://www.astrosurf.org/astropc
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

interface

uses
  skylibcat, sysutils;
type
Tstar =   packed record
          magv,b_v,magb,magr,pmra,pmdec,epoch,px : double;
          id,sp,comment : shortstring;
          end;
Tvariable=packed record
          magmax,magmin,period,maxepoch,risetime : double;
          id,vartype,sp,magcode,comment : shortstring;
          end;
Tdouble = packed record
          mag1,mag2,sep,pa,epoch : double;
          id,compname,sp1,sp2,comment : shortstring;
          end;
Tneb    = packed record
          mag,sbr,dim1,dim2,pa,rv : double;
          nebunit : Smallint;
          nebtype : ShortInt;
          id,morph,comment : shortstring;
          end;
Toutlines = packed record
          linecolor : LongWord;
          linetype,linewidth,usespline : byte;
          id,comment : shortstring;
          end;
GCatrec = packed record
          ra,dec   : double ;
          star     : Tstar;
          variable : Tvariable;
          double   : Tdouble;
          neb      : Tneb;
          outlines : Toutlines;
          str      : array[1..10] of shortstring;
          num      : array[1..10] of double;
          end;
Type TCatHeader = packed record
                 hdrl     : Integer;
                 version  : array[0..7] of char;
                 ShortName: array[0..3] of char;
                 LongName : array[0..49] of char;
                 reclen   : Integer;
                 FileNum  : Integer;
                 Equinox  : double;
                 Epoch    : double;
                 MagMax   : double;
                 Size     : Integer;
                 Units    : Integer;
                 ObjType  : Integer;
                 LogSize  : Integer;
                 UsePrefix: byte;
                 IxKeylen : byte;
                 AltName  : array[1..10] of byte;
                 Spare1   : array[1..20] of integer;
                 fpos     : array[1..35] of integer;
                 Spare2   : array[1..20] of integer;
                 flen     : array[1..35] of integer;
                 Spare3   : array[1..20] of integer;
                 flabel   : array[1..35,0..10] of char;
                 Spare4   : array[1..20,0..10] of char;
                 end;


procedure SetGCatpath(path,catshortname : shortstring); stdcall;
procedure GetGCatInfo(var h : TCatHeader; var version : integer; var ok : boolean); stdcall;
Procedure OpenGCat(ar1,ar2,de1,de2: double ; var ok : boolean); stdcall;
Procedure OpenGCatwin(var ok : boolean); stdcall;
Procedure ReadGCat(var lin : GCatrec; var ok : boolean); stdcall;
Procedure ReadGCat2(var lin : GCatrec; var ok : boolean); stdcall;
Procedure NextGCat( var ok : boolean); stdcall;
procedure CloseGCat ; stdcall;


implementation

var
   GCatpath : string ='';
   catheader : Tcatheader;
   datarec : array [0..4096] of byte;
   f : file ;
   hemis : char;
   zone,Sm,nSM,catversion : integer;
   curSM : integer;
   SMname,NomFich,Catname : string;
   hemislst : array[1..9537] of char;
   zonelst,SMlst : array[1..9537] of integer;
   FileIsOpen : Boolean = false;
   chkfile : Boolean = true;

procedure SetGCatpath(path,catshortname : shortstring);
begin
path:=noslash(path);
GCatpath:=path;
CatName:=trim(catshortname);
end;

Function ReadCatHeader : boolean;
var n : integer;
    fh : file;
begin
result:=false;
if fileexists(Gcatpath+slashchar+catname+'.hdr') then begin
filemode:=0;
assignfile(fh,Gcatpath+slashchar+catname+'.hdr');
reset(fh,1);
blockread(fh,catheader,sizeof(catheader),n);
result:=(n=sizeof(catheader))and(n=catheader.hdrl);
closefile(fh);
if catheader.version='CDCSTAR1' then catversion:=0;
if catheader.version='CDCVAR 1' then catversion:=1;
if catheader.version='CDCDBL 1' then catversion:=2;
if catheader.version='CDCNEB 1' then catversion:=3;
if catheader.version='CDCLINE1' then catversion:=4;
end;
end;

procedure GetGCatInfo(var h : TCatHeader; var version : integer; var ok : boolean); stdcall;
begin
ok:=ReadCatheader;
h:=catheader;
version:=catversion;
end;

Function GetRecCard(p: integer):cardinal ;
begin
  move(datarec[catheader.fpos[p]-1],result,catheader.flen[p]);
end;

Function GetRecString(p: integer):string ;
begin
  setlength(result,catheader.flen[p]);
  move(datarec[catheader.fpos[p]-1],result[1],catheader.flen[p]);
end;

Function GetRecSmallInt(p: integer):smallint ;
begin
  move(datarec[catheader.fpos[p]-1],result,catheader.flen[p]);
end;

Function GetRecByte(p: integer):byte ;
begin
  move(datarec[catheader.fpos[p]-1],result,catheader.flen[p]);
end;

Function GetRecSingle(p: integer):single ;
begin
  move(datarec[catheader.fpos[p]-1],result,catheader.flen[p]);
end;

Procedure CloseRegion;
begin
{$I-}
if fileisopen then begin
FileisOpen:=false;
closefile(f);
end;
{$I+}
end;

Procedure Openfile(nomfich : string; var ok : boolean);
begin
ok:=false;
if not FileExists(nomfich) then begin ; ok:=false ; chkfile:=false ; exit; end;
FileMode:=0;
AssignFile(f,nomfich);
FileisOpen:=true;
reset(f,1);
ok:=true;
if filesize(f)=0 then NextGCat(ok);
end;

Procedure OpenRegion(hemis : char ;zone,S : integer ; var ok:boolean);
var nomreg,nomzone :string;
begin
str(S:4,nomreg);
str(abs(zone):4,nomzone);
case catheader.filenum of
    1      : nomfich:=GCatpath+slashchar+catname+'.dat';
    50     : nomfich:=GCatpath+slashchar+catname+padzeros(nomreg,2)+'.dat';
    184    : nomfich:=GCatpath+slashchar+catname+padzeros(nomreg,3)+'.dat';
    732    : nomfich:=GCatpath+slashchar+hemis+padzeros(nomzone,4)+slashchar+catname+padzeros(nomreg,3)+'.dat';
    9537   : nomfich:=GCatpath+slashchar+hemis+padzeros(nomzone,4)+slashchar+catname+padzeros(nomreg,4)+'.dat';
end;
SMname:=nomreg;
if fileisopen then CloseRegion;
OpenFile(nomfich,ok);
end;

Procedure OpenGCat(ar1,ar2,de1,de2: double ; var ok : boolean); stdcall;
begin
curSM:=1;
ar1:=ar1*15; ar2:=ar2*15;
ok:=ReadCatHeader;
if ok then begin
case catheader.filenum of
    1      : begin nSM:=1; SMlst[1]:=1; end;
    50     : FindRegionList30(ar1,ar2,de1,de2,nSM,SMlst);
    184    : FindRegionAll15(ar1,ar2,de1,de2,nSM,SMlst);
    732    : FindRegionAll7(ar1,ar2,de1,de2,nSM,zonelst,SMlst,hemislst);
    9537   : FindRegionAll(ar1,ar2,de1,de2,nSM,zonelst,SMlst,hemislst);
end;
hemis:= hemislst[curSM];
zone := zonelst[curSM];
Sm := Smlst[curSM];
OpenRegion(hemis,zone,Sm,ok);
end;
end;

Procedure ReadGCat(var lin : GCatrec; var ok : boolean);
var n : integer;
begin
ok:=true;
//fillchar(lin,sizeof(lin),0);
if eof(f) then NextGCat(ok);
if ok then begin
 blockread(f,datarec,catheader.reclen,n);
 if n=catheader.reclen then begin
  lin.ra:=GetRecCard(1)/3600000;
  lin.dec:=GetRecCard(2)/3600000-90;
  case catversion of
  0 : begin  // Star 1
      if catheader.flen[3]>0 then lin.star.id:=GetRecString(3);
      if catheader.flen[4]>0 then begin lin.star.magv:=GetRecSmallint(4)/1000; if lin.star.magv>32 then lin.star.magv:=99.9;end;
      if catheader.flen[5]>0 then begin lin.star.b_v:=GetRecSmallint(5)/1000;  if lin.star.b_v>32  then lin.star.b_v:=99.9;end;
      if catheader.flen[6]>0 then begin lin.star.magb:=GetRecSmallint(6)/1000; if lin.star.magb>32 then lin.star.magb:=99.9;end;
      if catheader.flen[7]>0 then begin lin.star.magr:=GetRecSmallint(7)/1000; if lin.star.magr>32 then lin.star.magr:=99.9;end;
      if catheader.flen[8]>0 then lin.star.sp:=GetRecString(8);
      if catheader.flen[9]>0 then lin.star.pmra:=GetRecSmallint(9)/1000;
      if catheader.flen[10]>0 then lin.star.pmdec:=GetRecSmallint(10)/1000;
      if catheader.flen[11]>0 then lin.star.epoch:=GetRecSingle(11);
      if catheader.flen[12]>0 then lin.star.px:=GetRecSmallint(12)/10000;
      if catheader.flen[13]>0 then lin.star.comment:=GetRecString(13);
      end;
  1 : begin  // variables stars 1
      if catheader.flen[3]>0 then lin.variable.id:=GetRecString(3);
      if catheader.flen[4]>0 then begin lin.variable.magmax:=GetRecSmallint(4)/1000; if lin.variable.magmax>32 then lin.variable.magmax:=99.9;end;
      if catheader.flen[5]>0 then begin lin.variable.magmin:=GetRecSmallint(5)/1000; if lin.variable.magmin>32 then lin.variable.magmin:=99.9;end;
      if catheader.flen[6]>0 then lin.variable.period:=GetRecSingle(6);
      if catheader.flen[7]>0 then lin.variable.vartype:=GetRecString(7);
      if catheader.flen[8]>0 then lin.variable.maxepoch:=GetRecSingle(8);
      if catheader.flen[9]>0 then lin.variable.risetime:=GetRecSmallint(9)/100;
      if catheader.flen[10]>0 then lin.variable.sp:=GetRecString(10);
      if catheader.flen[11]>0 then lin.variable.magcode:=GetRecString(11);
      if catheader.flen[12]>0 then lin.variable.comment:=GetRecString(12);
      end;
  2 : begin  // doubles stars 1
      if catheader.flen[3]>0 then lin.double.id:=GetRecString(3);
      if catheader.flen[4]>0 then begin lin.double.mag1:=GetRecSmallint(4)/1000; if lin.double.mag1>32 then lin.double.mag1:=99.9;end;
      if catheader.flen[5]>0 then begin lin.double.mag2:=GetRecSmallint(5)/1000; if lin.double.mag2>32 then lin.double.mag2:=99.9;end;
      if catheader.flen[6]>0 then lin.double.sep:=GetRecSmallint(6)/10;
      if catheader.flen[7]>0 then lin.double.pa:=GetRecSmallint(7);
      if catheader.flen[8]>0 then lin.double.epoch:=GetRecSingle(8);
      if catheader.flen[9]>0 then lin.double.compname:=GetRecString(9);
      if catheader.flen[10]>0 then lin.double.sp1:=GetRecString(10);
      if catheader.flen[11]>0 then lin.double.sp2:=GetRecString(11);
      if catheader.flen[12]>0 then lin.double.comment:=GetRecString(12);
      end;
  3 : begin  // nebulae 1
      if catheader.flen[3]>0 then lin.neb.id:=GetRecString(3);
      if catheader.flen[4]>0 then lin.neb.nebtype:=GetRecByte(4);
      if catheader.flen[5]>0 then begin lin.neb.mag:=GetRecSmallint(5)/1000; if lin.neb.mag>32 then lin.neb.mag:=99.9;end;
      if catheader.flen[6]>0 then begin lin.neb.sbr:=GetRecSmallint(6)/1000; if lin.neb.sbr>32 then lin.neb.sbr:=99.9;end;
      if catheader.flen[7]>0 then lin.neb.dim1:=GetRecSingle(7);
      if catheader.flen[8]>0 then lin.neb.dim2:=GetRecSingle(8);
      if catheader.flen[9]>0 then lin.neb.nebunit:=GetRecSmallint(9);
      if catheader.flen[10]>0 then begin lin.neb.pa:=GetRecSmallint(10); if lin.neb.pa=32767 then lin.neb.pa:=-999;end;
      if catheader.flen[11]>0 then lin.neb.rv:=GetRecSingle(11);
      if catheader.flen[12]>0 then lin.neb.morph:=GetRecString(12);
      if catheader.flen[13]>0 then lin.neb.comment:=GetRecString(13);
      end;
  4 : begin  // outlines
      if catheader.flen[3]>0 then lin.outlines.id:=GetRecString(3);
      if catheader.flen[4]>0 then lin.outlines.linetype:=GetRecByte(4);
      if catheader.flen[5]>0 then lin.outlines.linewidth:=GetRecByte(5);
      if catheader.flen[6]>0 then lin.outlines.linecolor:=GetRecCard(6);
      if catheader.flen[7]>0 then lin.outlines.usespline:=GetRecByte(7);
      if catheader.flen[8]>0 then lin.outlines.comment:=GetRecString(8);
      end;
  end;
  if catheader.flen[16]>0 then lin.str[1]:=GetRecString(16);
  if catheader.flen[17]>0 then lin.str[2]:=GetRecString(17);
  if catheader.flen[18]>0 then lin.str[3]:=GetRecString(18);
  if catheader.flen[19]>0 then lin.str[4]:=GetRecString(19);
  if catheader.flen[20]>0 then lin.str[5]:=GetRecString(20);
  if catheader.flen[21]>0 then lin.str[6]:=GetRecString(21);
  if catheader.flen[22]>0 then lin.str[7]:=GetRecString(22);
  if catheader.flen[23]>0 then lin.str[8]:=GetRecString(23);
  if catheader.flen[24]>0 then lin.str[9]:=GetRecString(24);
  if catheader.flen[25]>0 then lin.str[10]:=GetRecString(25);
  if catheader.flen[26]>0 then lin.num[1]:=GetRecSingle(26);
  if catheader.flen[27]>0 then lin.num[2]:=GetRecSingle(27);
  if catheader.flen[28]>0 then lin.num[3]:=GetRecSingle(28);
  if catheader.flen[29]>0 then lin.num[4]:=GetRecSingle(29);
  if catheader.flen[30]>0 then lin.num[5]:=GetRecSingle(30);
  if catheader.flen[31]>0 then lin.num[6]:=GetRecSingle(31);
  if catheader.flen[32]>0 then lin.num[7]:=GetRecSingle(32);
  if catheader.flen[33]>0 then lin.num[8]:=GetRecSingle(33);
  if catheader.flen[34]>0 then lin.num[9]:=GetRecSingle(34);
  if catheader.flen[35]>0 then lin.num[10]:=GetRecSingle(35);
 end else ok:=false;
end;
end;

Procedure ReadGCat2(var lin : GCatrec; var ok : boolean);
// version plus rapide juste pour le dessin
var n : integer;
begin
ok:=true;
//fillchar(lin,sizeof(lin),0);
if eof(f) then NextGCat(ok);
if ok then begin
 blockread(f,datarec,catheader.reclen,n);
 if n=catheader.reclen then begin
  lin.ra:=GetRecCard(1)/3600000;
  lin.dec:=GetRecCard(2)/3600000-90;
  case catversion of
  0 : begin  // Star 1
      if catheader.flen[3]>0 then lin.star.id:=GetRecString(3);
      if catheader.flen[4]>0 then begin lin.star.magv:=GetRecSmallint(4)/1000; if lin.star.magv>32 then lin.star.magv:=99.9;end;
      if catheader.flen[5]>0 then begin lin.star.b_v:=GetRecSmallint(5)/1000;  if lin.star.b_v>32  then lin.star.b_v:=99.9;end;
      if catheader.flen[6]>0 then begin lin.star.magb:=GetRecSmallint(6)/1000; if lin.star.magb>32 then lin.star.magb:=99.9;end;
      if catheader.flen[9]>0 then lin.star.pmra:=GetRecSmallint(9)/1000;
      if catheader.flen[10]>0 then lin.star.pmdec:=GetRecSmallint(10)/1000;
      end;
  1 : begin  // variables stars 1
      if catheader.flen[3]>0 then lin.variable.id:=GetRecString(3);
      if catheader.flen[4]>0 then begin lin.variable.magmax:=GetRecSmallint(4)/1000; if lin.variable.magmax>32 then lin.variable.magmax:=99.9;end;
      if catheader.flen[5]>0 then begin lin.variable.magmin:=GetRecSmallint(5)/1000; if lin.variable.magmin>32 then lin.variable.magmin:=99.9;end;
      end;
  2 : begin  // doubles stars 1
      if catheader.flen[3]>0 then lin.double.id:=GetRecString(3);
      if catheader.flen[4]>0 then begin lin.double.mag1:=GetRecSmallint(4)/1000; if lin.double.mag1>32 then lin.double.mag1:=99.9;end;
      if catheader.flen[5]>0 then begin lin.double.mag2:=GetRecSmallint(5)/1000; if lin.double.mag2>32 then lin.double.mag2:=99.9;end;
      if catheader.flen[6]>0 then lin.double.sep:=GetRecSmallint(6)/10;
      if catheader.flen[7]>0 then begin lin.double.pa:=GetRecSmallint(7); if lin.double.pa=32767 then lin.double.pa:=-999;end;
      end;
  3 : begin  // nebulae 1
      if catheader.flen[3]>0 then lin.neb.id:=GetRecString(3);
      if catheader.flen[4]>0 then lin.neb.nebtype:=GetRecByte(4);
      if catheader.flen[5]>0 then begin lin.neb.mag:=GetRecSmallint(5)/1000; if lin.neb.mag>32 then lin.neb.mag:=99.9;end;
      if catheader.flen[6]>0 then begin lin.neb.sbr:=GetRecSmallint(6)/1000; if lin.neb.sbr>32 then lin.neb.sbr:=99.9;end;
      if catheader.flen[7]>0 then lin.neb.dim1:=GetRecSingle(7);
      if catheader.flen[8]>0 then lin.neb.dim2:=GetRecSingle(8);
      if catheader.flen[9]>0 then lin.neb.nebunit:=GetRecSmallint(9);
      if catheader.flen[10]>0 then begin lin.neb.pa:=GetRecSmallint(10); if lin.neb.pa=32767 then lin.neb.pa:=-999;end;
      end;
  4 : begin  // outlines
      if catheader.flen[3]>0 then lin.outlines.id:=GetRecString(3);
      if catheader.flen[4]>0 then lin.outlines.linetype:=GetRecByte(4);
      if catheader.flen[5]>0 then lin.outlines.linewidth:=GetRecByte(5);
      if catheader.flen[6]>0 then lin.outlines.linecolor:=GetRecCard(6);
      if catheader.flen[7]>0 then lin.outlines.usespline:=GetRecByte(7);
      end;
  end;
  if catheader.flen[16]>0 then lin.str[1]:=GetRecString(16);
  if catheader.flen[17]>0 then lin.str[2]:=GetRecString(17);
  if catheader.flen[18]>0 then lin.str[3]:=GetRecString(18);
  if catheader.flen[19]>0 then lin.str[4]:=GetRecString(19);
  if catheader.flen[20]>0 then lin.str[5]:=GetRecString(20);
  if catheader.flen[21]>0 then lin.str[6]:=GetRecString(21);
  if catheader.flen[22]>0 then lin.str[7]:=GetRecString(22);
  if catheader.flen[23]>0 then lin.str[8]:=GetRecString(23);
  if catheader.flen[24]>0 then lin.str[9]:=GetRecString(24);
  if catheader.flen[25]>0 then lin.str[10]:=GetRecString(25);
 end else ok:=false;
end;
end;

Procedure NextGCat( var ok : boolean);
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

procedure CloseGCat ;
begin
curSM:=nSM;
CloseRegion;
end;

Procedure OpenGCatwin(var ok : boolean);
begin
curSM:=1;
ok:=ReadCatHeader;
if ok then begin
case catheader.filenum of
    1      : begin nSM:=1; SMlst[1]:=1; end;
    50     : FindRegionListWin30(nSM,SMlst);
    184    : FindRegionAllWin15(nSM,SMlst);
    732    : FindRegionAllWin7(nSM,zonelst,SMlst,hemislst);
    9537   : FindRegionAllWin(nSM,zonelst,SMlst,hemislst);
end;
hemis:= hemislst[curSM];
zone := zonelst[curSM];
Sm := Smlst[curSM];
OpenRegion(hemis,zone,Sm,ok);
end;
end;

end.
