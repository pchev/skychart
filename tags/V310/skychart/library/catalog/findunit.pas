unit findunit;
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
{$mode objfpc}{$H+}
interface
Uses sysutils,skylibcat,ngcunit,wdsunit,gcvunit,gscunit,gscfits,gsccompact,
     bscunit,pgcunit,sacunit,tyc2unit,usnoaunit,usnobunit,gcatunit;

Procedure FindNumNGC(id:Integer ;var ar,de:double; var ok:boolean);
Procedure FindNumIC(id:Integer ;var ar,de:double; var ok:boolean);
Procedure FindNumMessier(id:Integer ;var ar,de:double; var ok:boolean);
Procedure FindNumGCVS(id:string; var lin:GCVrec; var ok:boolean);
Procedure FindNumGSC(id : string ;var ar,de:double; var ok:boolean);
Procedure FindNumGSCF(id : string ;var ar,de:double; var ok:boolean);
Procedure FindNumGSCC(id : string ;var ar,de:double; var ok:boolean);
Procedure FindNumGC(id:Integer ;var ar,de:double; var ok:boolean);
Procedure FindNumHR(id:Integer ;var ar,de:double; var ok:boolean);
Procedure FindNumBayer(var id:string ;var ra,dec: double; var ok:boolean);
Procedure FindNumFlam(var id:string ;var ra,dec: double; var ok:boolean);
Procedure FindNumHD(id:Integer ;var ar,de:double; var ok:boolean);
Procedure FindNumSAO(id:Integer ;var ar,de:double; var ok:boolean);
Procedure FindNumBD(id:string ;var ar,de:double; var ok:boolean);
Procedure FindNumCD(id:string ;var ar,de:double; var ok:boolean);
Procedure FindNumCPD(id:string ;var ar,de:double; var ok:boolean);
Procedure FindNumPGC(id:Integer ;var lin: PGCrec; var ok:boolean);
Procedure FindNumSAC(id:string ;var rec:SACrec; var ok:boolean);
Procedure FindNumWDS(id:string; var lin:WDSrec; var ok:boolean);
Procedure FindNumGcat(path,catshortname,id : string ; keylen : integer; var ar,de:double; var ok:boolean);
Procedure FindNumGcatRec(path,catshortname,id : string ; keylen : integer; var rec:GCatrec; var ok:boolean);
Procedure FindNumTYC2(id : string ;var lin: TY2rec; var ok:boolean);
Procedure FindNumUSNOA(id : string ;var ar,de:double; var ok:boolean);
Procedure FindNumUSNOB(id : string ;var ar,de:double; var ok:boolean);
procedure SetXHIPpath(path : string);

implementation                          

const blank='                    ';

var XHIPpath: string;


procedure SetXHIPpath(path : string);
begin
XHIPpath:=noslash(path);
end;

Procedure FindIdxStr(idx, id : string; var ar,de:double; var ok:boolean);
Type idxfil = record
              num : array[1..12] of char;
              ar,de :single;
              end;
var
    imin,imax,i : integer;
    pnum : string;
    fx : file of idxfil ;
    lin : idxfil;
begin
ok:=false;
if not fileexists(idx) then begin
   exit;
end;
AssignFile(fx,idx);
FileMode:=0;
Reset(fx);
imin:=0;
imax := filesize(fx);
lin.num:='';
repeat
  pnum:=lin.num;
  i:=imin + ((imax-imin) div 2);
  seek(fx,i);
  read(fx,lin);
  if lin.num>id then imax:=i
                else imin:=i;
  if lin.num=id then ok:=true;
until ok or (pnum=lin.num);
CloseFile(fx);
if ok then begin
   ar:=lin.ar/15;
   de:=lin.de;
end;
end;

Procedure FindIdx(idx : string; id:Integer ;var ar,de:double; var ok:boolean);
type idxfil = record num :longint ;
                 ar,de :single;
                 end;
var
    imin,imax,i,pnum : integer;
    fx : file of idxfil ;
    lin : idxfil;
begin
ok:=false;
if not fileexists(idx) then begin
   exit;
end;
AssignFile(fx,idx);
FileMode:=0;
Reset(fx);
imin:=0;
imax := filesize(fx);
lin.num:=-MaxInt;
repeat
  pnum:=lin.num;
  i:=imin + ((imax-imin) div 2);
  seek(fx,i);
  read(fx,lin);
  if lin.num>id then imax:=i
                else imin:=i;
  if lin.num=id then ok:=true;
until ok or (pnum=lin.num);
CloseFile(fx);
if ok then begin
   ar:=lin.ar/15;
   de:=lin.de;
end;
end;

Procedure FindIxrStr(ixr, id : string; var n,r: integer; var ok:boolean);
Type filixr = packed record n: smallint;
                r: integer;
                key: array[1..12] of char;
         end;
var
    imin,imax,i : integer;
    pnum : string;
    fx : file of filixr ;
    lin : filixr;
begin
ok:=false;
if not fileexists(ixr) then begin
   exit;
end;
AssignFile(fx,ixr);
FileMode:=0;
Reset(fx);
imin:=0;
imax := filesize(fx);
lin.key:='';
repeat
  pnum:=lin.key;
  i:=imin + ((imax-imin) div 2);
  seek(fx,i);
  read(fx,lin);
  if lin.key>id then imax:=i
                else imin:=i;
  if lin.key=id then ok:=true;
until ok or (pnum=lin.key);
CloseFile(fx);
if ok then begin
   n:=lin.n;
   r:=lin.r;
end;
end;

Procedure FindIxr(ixr: string; id: integer ; var n,r: integer; var ok:boolean);
Type filixr = packed record n: smallint;
                r: integer;
                key: Longint;
         end;
var
    imin,imax,i : integer;
    pnum : integer;
    fx : file of filixr ;
    lin : filixr;
begin
ok:=false;
if not fileexists(ixr) then begin
   exit;
end;
AssignFile(fx,ixr);
FileMode:=0;
Reset(fx);
imin:=0;
imax := filesize(fx);
lin.key:=0;
repeat
  pnum:=lin.key;
  i:=imin + ((imax-imin) div 2);
  seek(fx,i);
  read(fx,lin);
  if lin.key>id then imax:=i
                else imin:=i;
  if lin.key=id then ok:=true;
until ok or (pnum=lin.key);
CloseFile(fx);
if ok then begin
   n:=lin.n;
   r:=lin.r;
end;
end;

Procedure FindNumNGC(id:Integer ;var ar,de:double; var ok:boolean);
begin
FindIdx(NGCpath+slashchar+'ngc.idx',id,ar,de,ok);
end;

Procedure FindNumIC(id:Integer ;var ar,de:double; var ok:boolean);
begin
FindIdx(NGCpath+slashchar+'ic.idx',id,ar,de,ok);
end;

Procedure FindNumMessier(id:Integer ;var ar,de:double; var ok:boolean);
begin
FindIdx(NGCpath+slashchar+'messier.idx',id,ar,de,ok);
end;

{$NOTES OFF}
function IsNumber(n : string) : boolean;
var i : integer;
    dummy_double : double;
begin
val(n,Dummy_double,i);
result:= (i=0) ;
end;
{$NOTES ON}

Procedure FindNumGCVS(id:string; var lin:GCVrec; var ok:boolean);
var buf,buf1,buf2 : string;
    n,r: integer;
begin
buf1:=words(id,'',1,1);
buf2:=words(id,'',2,1);
buf1:=uppercase(buf1)+blank;
if trim(buf1)='NSV' then buf2:=padzeros(buf2,5);
if copy(buf1,1,1)='V' then begin
   buf:=trim(copy(buf1,2,99));
   if IsNumber(buf) then buf1:='V'+padzeros(buf,4)+blank;
end;
buf2:=uppercase(buf2)+blank;
if copy(buf2,1,1)='V' then begin
   buf:=trim(copy(buf2,2,99));
   if IsNumber(buf) then buf2:='V'+padzeros(buf,4)+blank;
end;
buf:=copy(trim(copy(buf1,1,6))+trim(copy(buf2,1,6))+blank,1,12);
FindIxrStr(GCVpath+slashchar+'gcvs.ixr',buf,n,r,ok);
if ok then begin
   OpenGCVSFileNum(n,ok);
   if not ok then exit;
   ReadGCVSRec(r, lin, ok);
   CloseGCV;
end;

end;

Procedure FindNumGSC(id : string ;var ar,de:double; var ok:boolean);
var smnum,num,p : integer;
    buf:string;
begin
ok:=false;
buf:=trim(id);
p:=pos('-',buf);
if p>0 then begin
   smnum:=strtoint(copy(buf,1,p-1));
   num:=strtoint(copy(buf,p+1,5));
   FindGSCnum(smnum,num,ar,de,ok);
end;
end;

Procedure FindNumGSCF(id : string ;var ar,de:double; var ok:boolean);
var smnum,num,p : integer;
    buf:string;
begin
ok:=false;
buf:=trim(id);
p:=pos('-',buf);
if p>0 then begin
   smnum:=strtoint(copy(buf,1,p-1));
   num:=strtoint(copy(buf,p+1,5));
   FindGSCFnum(smnum,num,ar,de,ok);
end;
end;

Procedure FindNumGSCC(id : string ;var ar,de:double; var ok:boolean);
var smnum,num : integer;
    p : integer;
    buf:string;
begin
ok:=false;
buf:=trim(id);
p:=pos('-',buf);
if p>0 then begin
   smnum:=strtoint(copy(buf,1,p-1));
   num:=strtoint(copy(buf,p+1,5));
   FindGSCCnum(smnum,num,ar,de,ok);
end;
end;

Procedure FindNumTYC2(id : string ;var lin: TY2rec; var ok:boolean);
var smnum,num : integer;
    p : integer;
    buf:string;
begin
ok:=false;
buf:=trim(id);
p:=pos('-',buf);
if p>0 then begin
   smnum:=strtoint(copy(buf,1,p-1));
   buf:=copy(buf,p+1,5);
   p:=pos('-',buf);
   if p>0 then delete(buf,p,5);
   num:=strtoint(buf);
   FindTYC2num(smnum,num,lin,ok);
end;
end;

Procedure FindNumUSNOA(id : string ;var ar,de:double; var ok:boolean);
var smnum,num : integer;
    p : integer;
    buf:string;
begin
ok:=false;
buf:=trim(id);
p:=pos('-',buf);
if p>0 then begin
   smnum:=strtoint(copy(buf,1,p-1));
   num:=strtoint(copy(buf,p+1,99));
   FindUSNOAnum(smnum,num,ar,de,ok);
end;
end;

Procedure FindNumUSNOB(id : string ;var ar,de:double; var ok:boolean);
var smnum,num : integer;
    p : integer;
    buf:string;
begin
ok:=false;
buf:=trim(id);
p:=pos('-',buf);
if p>0 then begin
   smnum:=strtoint(copy(buf,1,p-1));
   num:=strtoint(copy(buf,p+1,99));
   FindUSNOBnum(smnum,num,ar,de,ok);
end;
end;

Procedure FindNumGC(id:Integer ;var ar,de:double; var ok:boolean);
begin
FindIdx(BSCpath+slashchar+'gc.idx',id,ar,de,ok);
end;

Procedure FindNumHR(id:Integer ;var ar,de:double; var ok:boolean);
var buf:string;
    rec: GCatrec;
begin
buf:='HR'+inttostr(id);
FindNumGcatRec(XHIPpath,'star',buf,11,rec,ok);
ar:=rec.ra;
de:=rec.dec;
end;

Procedure FindNumBayer(var id:string ;var ra,dec: double; var ok:boolean);
const
  maxgreek=25;
  greek: array[1..2, 1..maxgreek] of
    string = (('ALPHA', 'BETA', 'GAMMA', 'DELTA', 'EPSILON', 'ZETA', 'ETA',
    'THETA', 'IOTA', 'KAPPA', 'LAMBDA', 'MU', 'NU', 'XI', 'OMICRON', 'PI', 'RHO',
    'SIGMA', 'TAU', 'UPSILON', 'PHI', 'CHI', 'PSI', 'OMEGA','KSI'),
    ('alp', 'bet', 'gam', 'del', 'eps', 'zet', 'eta', 'the', 'iot',
    'kap', 'lam', 'mu', 'nu', 'ksi', 'omi', 'pi', 'rho', 'sig', 'tau', 'ups', 'phi', 'chi', 'psi', 'ome','ksi'));
  maxconst=90;
  constel: array[1..maxconst,1..3] of string =(
  ('AND','ANDROMEDA','ANDROMEDAE'),
  ('ANT','ANTLIA','ANTLIAE'),
  ('APS','APUS','APODIS'),
  ('AQR','AQUARIUS','AQUARII'),
  ('AQL','AQUILA','AQUILAE'),
  ('ARA','ARA','ARAE'),
  ('ARI','ARIES','ARIETIS'),
  ('AUR','AURIGA','AURIGAE'),
  ('BOO','BOOTES','BOOTIS'),
  ('CAE','CAELUM','CAELI'),
  ('CAM','CAMELOPARDALIS','CAMELOPARDALIS'),
  ('CNC','CANCER','CANCRI'),
  ('CVN','CANES VENATICI','CANUM VENATICORUM'),
  ('CMA','CANIS MAJOR','CANIS MAJORIS'),
  ('CMI','CANIS MINOR','CANIS MINORIS'),
  ('CAP','CAPRICORNUS','CAPRICORNI'),
  ('CAR','CARINA','CARINAE'),
  ('CAS','CASSIOPEIA','CASSIOPEIAE'),
  ('CEN','CENTAURUS','CENTAURI'),
  ('CEP','CEPHEUS','CEPHEI'),
  ('CET','CETUS','CETI'),
  ('CHA','CHAMAELEON','CHAMAELEONTIS'),
  ('CIR','CIRCINUS','CIRCINI'),
  ('COL','COLUMBA','COLUMBAE'),
  ('COM','COMA BERENICES','COMAE BERENICES'),
  ('CRA','CORONA AUSTRALIS','CORONAE AUSTRALIS'),
  ('CRB','CORONA BOREALIS','CORONAE BOREALIS'),
  ('CRV','CORVUS','CORVI'),
  ('CRT','CRATER','CRATERIS'),
  ('CRU','CRUX','CRUCIS'),
  ('CYG','CYGNUS','CYGNI'),
  ('DEL','DELPHINUS','DELPHINI'),
  ('DOR','DORADO','DORADUS'),
  ('DRA','DRACO','DRACONIS'),
  ('EQU','EQUULEUS','EQUULEI'),
  ('ERI','ERIDANUS','ERIDANI'),
  ('FOR','FORNAX','FORNACIS'),
  ('GEM','GEMINI','GEMINORUM'),
  ('GRU','GRUS','GRUIS'),
  ('HER','HERCULES','HERCULIS'),
  ('HOR','HOROLOGIUM','HOROLOGII'),
  ('HYA','HYDRA','HYDRAE'),
  ('HYI','HYDRUS','HYDRI'),
  ('IND','INDUS','INDI'),
  ('LAC','LACERTA','LACERTAE'),
  ('LEO','LEO','LEONIS'),
  ('LMI','LEO MINOR','LEONIS MINORIS'),
  ('LEP','LEPUS','LEPORIS'),
  ('LIB','LIBRA','LIBRAE'),
  ('LUP','LUPUS','LUPI'),
  ('LYN','LYNX','LYNCIS'),
  ('LYR','LYRA','LYRAE'),
  ('MEN','MENSA','MENSAE'),
  ('MIC','MICROSCOPIUM','MICROSCOPII'),
  ('MON','MONOCEROS','MONOCEROTIS'),
  ('MUS','MUSCA','MUSCAE'),
  ('NOR','NORMA','NORMAE'),
  ('OCT','OCTANS','OCTANTIS'),
  ('OPH','OPHIUCHUS','OPHIUCHI'),
  ('ORI','ORION','ORIONIS'),
  ('PAV','PAVO','PAVONI'),
  ('PEG','PEGASUS','PEGASI'),
  ('PER','PERSEUS','PERSEI'),
  ('PHE','PHOENIX','PHOENICIS'),
  ('PIC','PICTOR','PICTORIS'),
  ('PSC','PISCES','PISCIUM'),
  ('PSA','PISCIS AUSTRINUS','PISCIS AUSTRINI'),
  ('PUP','PUPPIS','PUPPIS'),
  ('PYX','PYXIS','PYXIDIS'),
  ('RET','RETICULUM','RETICULI'),
  ('SGE','SAGITTA','SAGITTAE'),
  ('SGR','SAGITTARIUS','SAGITTARII'),
  ('SCO','SCORPIUS','SCORPII'),
  ('SCL','SCULPTOR','SCULPTORIS'),
  ('SCT','SCUTUM','SCUTI'),
  ('SER','SERPENS CAPUT','SERPENS CAPUT'),
  ('SER','SERPENS CAUDA','SERPENS CAUDA'),
  ('SER','SERPENS','SERPENTIS'),
  ('SEX','SEXTANS','SEXTANTIS'),
  ('TAU','TAURUS','TAURI'),
  ('TEL','TELESCOPIUM','TELESCOPII'),
  ('TRI','TRIANGULUM','TRIANGULI'),
  ('TRA','TRIANGULUM AUSTRALE','TRIANGULI AUSTRALIS'),
  ('TUC','TUCANA','TUCANAE'),
  ('UMA','URSA MAJOR','URSAE MAJORIS'),
  ('UMI','URSA MINOR','URSAE MINORIS'),
  ('VEL','VELA','VELORUM'),
  ('VIR','VIRGO','VIRGINIS'),
  ('VOL','VOLANS','VOLANTIS'),
  ('VUL','VULPECULA','VULPECULAE')
  );
var buf,b0,b1,b,n,c: string;
    i,p: integer;
    H : TCatHeader;
    info:TCatHdrInfo;
    version : integer;
    rec: GCatrec;
    GCatFilter: boolean;
begin
b0:='';
p:=pos(' ',id);
if p>0 then begin      // must be at least two words (alpha cygni)
  b1:=copy(id,1,p-1);
  c:=copy(id,p+1,999);
  b:=''; n:='';
  for p:=1 to length(b1) do begin    // separate the numeric part (alpha2 Librae)
   buf:=copy(b1,p,1);
   if (buf>='0')and(buf<='9') then n:=n+buf
                              else b:=b+buf;
  end;
  b:=trim(uppercase(b));
  for i:=1 to maxgreek do begin     // replace full greek letter by abrev.
    if b=greek[1,i] then begin
      b:=greek[2,i];
      break;
    end;
  end;
  if b>'' then begin
    b0:=b;
    if n>'' then begin             // bayer+num case
      p:=StrToIntDef(n,-1);
      if p>=0 then begin
        b:=b+FormatFloat('00',p);  // format with two digits
      end
      else b:=b+n;
    end;
  end
  else b:=n;                      // flamsteed num case
  c:=trim(uppercase(c));
  for i:=1 to maxconst do begin    // replace full constellation name by abrev.
    if (c=constel[i,2])or(c=constel[i,3]) then begin // also test genitive form
      c:=constel[i,1];
      break;
    end;
  end;
  id:=b+' '+c;      // star name as in index
end;
SetGcatPath(XHIPpath,'star');
GetGCatInfo(H,info,version,GCatFilter,ok);
FindNumGcatRec(XHIPpath,'star',id,H.ixkeylen,rec,ok);
if (not ok)and(b0>'')and(c>'') then begin
  if n>'' then id:=b0+' '+c                       // try without numeric index
          else id:=b0+'01 '+c;                 // try with first numeric index
  FindNumGcatRec(XHIPpath,'star',id,H.ixkeylen,rec,ok);
end;
if ok then begin
  ra:=rec.ra/15;
  dec:=rec.dec;
end;
end;

Procedure FindNumFlam(var id:string ;var ra,dec: double; var ok:boolean);
begin
// now using the same index
FindNumBayer(id,ra,dec,ok);
end;

Procedure FindNumWDS(id:string ; var lin:WDSrec; var ok:boolean);
var buf : string;
    n,r: integer;
begin
buf:=copy(uppercase(stringreplace(id,' ','',[rfReplaceAll]))+'             ',1,12);
FindIxrStr(WDSpath+slashchar+'wds.ixr',buf,n,r,ok);
if ok then begin
   OpenWDSFileNum(n,ok);
   if not ok then exit;
   ReadWDSRec(r, lin, ok);
   CloseWDS;
end;
end;

Procedure FindNumHD(id:Integer ;var ar,de:double; var ok:boolean);
begin
FindIdx(BSCpath+slashchar+'hd.idx',id,ar,de,ok);
end;

Procedure FindNumSAO(id:Integer ;var ar,de:double; var ok:boolean);
begin
FindIdx(BSCpath+slashchar+'sao.idx',id,ar,de,ok);
end;

Procedure FindNumBD(id:string ;var ar,de:double; var ok:boolean);
var sign,buf : string;
    zone,num,p : integer;
begin
buf:=trim(id);
p:=pos(' ',buf);
if p>0 then begin
   sign:=copy(buf,1,1);
   zone:=strtoint(sign+trim(copy(buf,2,p-1)));
   num:=strtoint(sign+trim(copy(buf,p+1,5)));
   num:=100000*zone + num;
   FindIdx(BSCpath+slashchar+'bd.idx',num,ar,de,ok);
end;
end;

Procedure FindNumCD(id:string ;var ar,de:double; var ok:boolean);
var sign,buf : string;
    zone,num,p : integer;
begin
buf:=trim(id);
p:=pos(' ',id);
if p>0 then begin
   sign:=copy(buf,1,1);
   zone:=strtoint(sign+trim(copy(buf,2,p-1)));
   num:=strtoint(sign+trim(copy(buf,p+1,5)));
   num:=100000*zone + num;
   FindIdx(BSCpath+slashchar+'cd.idx',num,ar,de,ok);
end;
end;

Procedure FindNumCPD(id:string ;var ar,de:double; var ok:boolean);
var sign,buf : string;
    zone,num,p : integer;
begin
buf:=trim(id);
p:=pos(' ',buf);
if p>0 then begin
   sign:=copy(buf,1,1);
   zone:=strtoint(sign+trim(copy(buf,2,p-1)));
   num:=strtoint(sign+trim(copy(buf,p+1,5)));
   num:=100000*zone + num;
   FindIdx(BSCpath+slashchar+'cp.idx',num,ar,de,ok);
end;
end;

Procedure FindNumPGC(id:Integer ;var lin:PGCrec; var ok:boolean);
var n,r: integer;
begin
FindIxr(PGCpath+slashchar+'pgc.ixr',id,n,r,ok);
if ok then begin
   OpenPGCFileNum(n,ok);
   if not ok then exit;
   ReadPGCRec(r, lin, ok);
   ClosePGC;
end;
end;

Procedure FindNumSAC(id : string ;var rec:SACrec; var ok:boolean);
Type filixr = packed record n: smallint;
                r: integer;
                key: array[1..18] of char;
         end;
var
    imin,imax,i,n,r : integer;
    pnum,idx,buf : string;
    fx : file of filixr ;
    lin : filixr;
begin
buf:=Uppercase(stringreplace(id,' ','',[rfReplaceAll]));
buf:=copy(buf+blank,1,18);
idx:=SACpath+slashchar+'sac.ixr';
ok:=false;
if not fileexists(idx) then begin
   exit;
end;
AssignFile(fx,idx);
FileMode:=0;
Reset(fx);
imin:=0;
imax := filesize(fx);
lin.key:='';
repeat
  pnum:=lin.key;
  i:=imin + ((imax-imin) div 2);
  seek(fx,i);
  read(fx,lin);
  if lin.key>buf then imax:=i
                else imin:=i;
  if lin.key=buf then ok:=true;
until ok or (pnum=lin.key);
CloseFile(fx);
if ok then begin
   n:=lin.n;
   r:=lin.r;
   OpenSACFileNum(n,ok);
   if not ok then exit;
   ReadSACRec(r, rec, ok);
   CloseSAC;
end;
end;

Procedure FindNumGcat(path,catshortname,id : string ; keylen : integer; var ar,de:double; var ok:boolean);
Type
Tixrec = record ra,dec : single;
                   key : array [0..512] of char;
         end;
var
    reclen,n : integer;
    imin,imax,i: Int64;
    num,pnum,idx,buf : string;
    fx : file;
    lin : Tixrec;
begin
buf:=uppercase(stringreplace(id,' ','',[rfReplaceAll]));
idx:=path+slashchar+catshortname+'.idx';
ok:=false;
if not fileexists(idx) then begin
   exit;
end;
reclen:=keylen+8;
AssignFile(fx,idx);
FileMode:=0;
Reset(fx,1);
imin:=0;
imax := filesize(fx) div reclen;
num:='';
repeat
  pnum:=num;
  i:=(imin + ((imax-imin) div 2))*reclen;
  seek(fx,i);
  blockread(fx,lin,reclen,n);
  num:=trim(copy(lin.key,1,keylen));
  if num>buf then imax:=i div reclen
            else imin:=i div reclen;
  if num=buf then ok:=true;
until ok or (pnum=num);
CloseFile(fx);
if ok then begin
   ar:=lin.ra/15;
   de:=lin.dec;
end;
end;

Procedure FindNumGcatRec(path,catshortname,id : string ; keylen : integer; var rec:GCatrec; var ok:boolean);
Type
Tixrec = packed record n: smallint;
                k: integer;
                key : array [0..512] of char;
         end;
var
    reclen,n : integer;
    imin,imax,i: Int64;
    num,pnum,idx,buf : string;
    fx : file;
    lin : Tixrec;
begin
buf:=uppercase(stringreplace(id,' ','',[rfReplaceAll]));
idx:=path+slashchar+catshortname+'.ixr';
ok:=false;
if not fileexists(idx) then begin
   exit;
end;
reclen:=keylen+6;
AssignFile(fx,idx);
FileMode:=0;
Reset(fx,1);
imin:=0;
imax := filesize(fx) div reclen;
num:='';
repeat
  pnum:=num;
  i:=(imin + ((imax-imin) div 2))*reclen;
  seek(fx,i);
  blockread(fx,lin,reclen,n);
  num:=trim(copy(lin.key,1,keylen));
  if num>buf then imax:=i div reclen
            else imin:=i div reclen;
  if num=buf then ok:=true;
until ok or (pnum=num);
CloseFile(fx);
if ok then begin
   OpenGCatFileNum(lin.n,ok);
   if not ok then exit;
   ReadGCatRec(lin.k, rec, ok);
   CloseGCat;
end;
end;

end.
