unit gaiaunit;
{
Copyright (C) 2018 Patrick Chevalley

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

uses
  gcatunit, skylibcat, sysutils, Classes;

// Gaia catalog is build with Catgen
// but we define the record directly here for performance
type TGaiaRec = packed record
        ra,de: cardinal;
        sid  : qword;
        G,B,R: smallint;
        pmra,pmdec,px,rv: single;
     end;

function IsGaiapath(path : string) : Boolean;
procedure SetGaiapath(path,catshortname : string);
procedure GetGaiaInfo(var h : TCatHeader; var info:TCatHdrInfo; var version : integer; var filter,ok : boolean);
function  GetGaiaVersion: String;
Procedure OpenGaiap(ar1,ar2,de1,de2: double ; var ok : boolean; out maxlevel: integer);
Procedure OpenGaiawin(var ok : boolean; out maxlevel: integer);
Procedure ReadGaia(var lin : GCatrec; var ok : boolean);
Procedure NextGaia( var ok : boolean);
procedure CloseGaia ;

var
   MaxGaiaRec: integer = MaxInt;
   GaiaVersion: string;

const
// Constant to find the healpix from the source_id
// healpix = source_id div filterXX
//                                        level  fov      source_id filter
HealpixFilter0 = 576460752303423488;  //  0      58.632   576460752303423488
HealpixFilter1 = 144115188075855872;  //  1      29.316   144115188075855872
HealpixFilter2 = 36028797018963968;   //  2      14.658   36028797018963968
HealpixFilter3 = 9007199254740992;    //  3       7.329   9007199254740992
HealpixFilter4 = 2251799813685248;    //  4       3.665   2251799813685248
HealpixFilter5 = 562949953421312;     //  5       1.832   562949953421312
HealpixFilter6 = 140737488355328;     //  6       0.916   140737488355328
HealpixFilter7 = 35184372088832;      //  7       0.458   35184372088832
HealpixFilter8 = 8796093022208;       //  8       0.229   8796093022208
HealpixFilter9 = 2199023255552;       //  9       0.115   2199023255552
HealpixFilter10= 549755813888;        //  10      0.057   549755813888
HealpixFilter11= 137438953472;        //  11      0.029   137438953472
HealpixFilter12= 34359738368;         //  12      0.014   34359738368

implementation

var
   GaiaPath : string ='';
   catheader : Tcatheader;
   catinfo : TCatHdrInfo;
   emptyrec : gcatrec;
   datarec : TGaiaRec;
   mem: TMemoryStream;
   hemis : char;
   zone,Sm,nSM,catversion,cattype : integer;
   curSM, Nrec : integer;
   SMname,NomFich,Catname : string;
   hemislst : array[1..9537] of char;
   zonelst,SMlst : array[1..9537] of integer;
   FileBIsOpen : Boolean = false;
   FirstRead : Boolean;


function IsGaiapath(path : string) : Boolean;
var p : string;
begin
p:=slash(path)+slash('gaia1'); // Check at least level 1 is available
result:= (FileExists(p+'n0000'+slashchar+'gaia0001.dat')    // old gaia1 to mag 15
        and FileExists(p+'s8230'+slashchar+'gaia9490.dat'))
        or (FileExists(p+'n0000'+slashchar+'gaia001.dat')   // new gaia1 to mag 12
        and FileExists(p+'s8230'+slashchar+'gaia732.dat'))
        and FileExists(p+'gaia.hdr');
end;

Procedure InitGaiaRec;
var n : integer;
begin
  emptyrec.options.rectype:=catversion;
  emptyrec.options.Equinox:=catheader.Equinox;
  if catheader.Equinox=2000 then emptyrec.options.EquinoxJD:=jd2000
  else if catheader.Equinox=1950 then emptyrec.options.EquinoxJD:=jd1950
  else emptyrec.options.EquinoxJD:=jd(trunc(catheader.Equinox),1,0,0);
  JDCatalog:=emptyrec.options.EquinoxJD;
  emptyrec.options.Epoch:=catheader.Epoch;
  emptyrec.options.MagMax:=catheader.MagMax;
  emptyrec.options.Size:=catheader.Size;
  emptyrec.options.Units:=catheader.Units;
  emptyrec.options.ObjType:=catheader.ObjType;
  emptyrec.options.LogSize:=catheader.LogSize;
  emptyrec.options.UsePrefix:=catheader.UsePrefix;
  for n:=1 to 10 do emptyrec.options.altname[n]:=(catheader.altname[n]=1);
  for n:=1 to 10 do emptyrec.options.altprefix[n]:=(catheader.AltPrefix[n]=1);
  emptyrec.options.flabel:=catheader.flabel;
  emptyrec.options.ShortName:=catheader.shortname;
  emptyrec.options.LongName:=catheader.LongName;
  emptyrec.options.Amplitudeflag:=-1;
  emptyrec.options.StarColor:=-1;
  case catversion of
  rtstar : begin  // Star 1
      if catheader.flen[3]>0 then emptyrec.star.valid[vsId]:=true;
      if catheader.flen[4]>0 then emptyrec.star.valid[vsMagV]:=true;
      if catheader.flen[5]>0 then emptyrec.star.valid[vsB_V]:=true;
      if catheader.flen[6]>0 then emptyrec.star.valid[vsMagB]:=true;
      if catheader.flen[7]>0 then emptyrec.star.valid[vsMagR]:=true;
      if catheader.flen[8]>0 then emptyrec.star.valid[vsSp]:=true;
      if catheader.flen[9]>0 then emptyrec.star.valid[vsPmra]:=true;
      if catheader.flen[10]>0 then emptyrec.star.valid[vsPmdec]:=true;
      if catheader.flen[11]>0 then emptyrec.star.valid[vsEpoch]:=true;
      if catheader.flen[12]>0 then emptyrec.star.valid[vsPx]:=true;
      if catheader.flen[13]>0 then emptyrec.star.valid[vsComment]:=true;
      end;
  end;
  if catheader.flen[16]>0 then emptyrec.vstr[1]:=true;
  if catheader.flen[17]>0 then emptyrec.vstr[2]:=true;
  if catheader.flen[18]>0 then emptyrec.vstr[3]:=true;
  if catheader.flen[19]>0 then emptyrec.vstr[4]:=true;
  if catheader.flen[20]>0 then emptyrec.vstr[5]:=true;
  if catheader.flen[21]>0 then emptyrec.vstr[6]:=true;
  if catheader.flen[22]>0 then emptyrec.vstr[7]:=true;
  if catheader.flen[23]>0 then emptyrec.vstr[8]:=true;
  if catheader.flen[24]>0 then emptyrec.vstr[9]:=true;
  if catheader.flen[25]>0 then emptyrec.vstr[10]:=true;
  if catheader.flen[26]>0 then emptyrec.vnum[1]:=true;
  if catheader.flen[27]>0 then emptyrec.vnum[2]:=true;
  if catheader.flen[28]>0 then emptyrec.vnum[3]:=true;
  if catheader.flen[29]>0 then emptyrec.vnum[4]:=true;
  if catheader.flen[30]>0 then emptyrec.vnum[5]:=true;
  if catheader.flen[31]>0 then emptyrec.vnum[6]:=true;
  if catheader.flen[32]>0 then emptyrec.vnum[7]:=true;
  if catheader.flen[33]>0 then emptyrec.vnum[8]:=true;
  if catheader.flen[34]>0 then emptyrec.vnum[9]:=true;
  if catheader.flen[35]>0 then emptyrec.vnum[10]:=true;
  emptyrec.options.flabel[lOffset + vsMagv]:='mG';
  emptyrec.options.flabel[lOffset + vsMagb]:='mBP';
  emptyrec.options.flabel[lOffset + vsMagr]:='mRP';
end;

procedure SetGaiapath(path,catshortname : string);
begin
GaiaPath:=noslash(path);
CatName:=trim(catshortname);
end;

Function ReadGaiaHeaderFile: boolean;
var n : integer;
    buf: string;
    fh : file;
    hdr: TFileHeader;
begin
try
fillchar(EmptyRec,sizeof(GcatRec),0);
if fileexists(GaiaPath+slashchar+catname+'.hdr') then begin
  filemode:=0;
  assignfile(fh,GaiaPath+slashchar+catname+'.hdr');
  reset(fh,1);
  blockread(fh,hdr,sizeof(hdr),n);
  result:=(n=sizeof(hdr))and(n=hdr.hdrl);
  closefile(fh);
  catheader.hdrl:=hdr.hdrl;
  catheader.version:=hdr.version;
  catheader.ShortName:=hdr.ShortName;
  catheader.LongName:=hdr.LongName;
  catheader.reclen:=hdr.reclen;
  catheader.FileNum:=hdr.FileNum;
  catheader.Equinox:=hdr.Equinox;
  catheader.Epoch:=hdr.Epoch;
  catheader.MagMax:=hdr.MagMax;
  catheader.Size:=hdr.Size;
  catheader.Units:=hdr.Units;
  catheader.ObjType:=hdr.ObjType;
  catheader.LogSize:=hdr.LogSize;
  catheader.UsePrefix:=hdr.UsePrefix;
  catheader.IxKeylen:=hdr.IxKeylen;
  catheader.AltName:=hdr.AltName;
  catheader.AltPrefix:=hdr.AltPrefix;
  catheader.IdFormat:=hdr.IdFormat;
  catheader.HighPrecPM:=hdr.HighPrecPM;
  catheader.IdPrefix:=hdr.IdPrefix;
  catheader.Spare1:=hdr.Spare1;
  catheader.fpos:=hdr.fpos;
  catheader.Spare2:=hdr.Spare2;
  catheader.flen:=hdr.flen;
  catheader.Spare3:=hdr.Spare3;
  for n:=1 to 35 do
      catheader.flabel[n]:=hdr.flabel[n]+'     ';
  catheader.TxtFileName:=hdr.TxtFileName;
  catheader.RAmode:=hdr.RAmode;
  catheader.DECmode:=hdr.DECmode;
  catheader.Spare41:=hdr.Spare41;
  catheader.Spare4:=hdr.Spare4;
  buf:=copy(catheader.version,1,7);
  if buf='CDCSTAR' then catversion:=rtStar
    else result:=false;
  buf:=copy(catheader.version,8,1);
  cattype:=strtointdef(buf,0);
  GaiaVersion := trim(catheader.LongName);
end
else result:=false;
except
  result:=false;
end;
end;

Function ReadGaiaHeader : boolean;
var buf: string;
begin
 result:=ReadGaiaHeaderFile;
 if result then begin
   InitGaiaRec;
 end
 else begin
   exit;
 end;
 buf:=copy(catheader.version,1,7);
 if buf='CDCSTAR' then catversion:=rtStar
    else begin result:=false; exit; end;
 buf:=copy(catheader.version,8,1);
 cattype:=strtointdef(buf,0);
 fillchar(catinfo,sizeof(catinfo),0);
 if cattype=ctText then
    begin result:=false; exit; end;
 // If crash here you are using the wrong catalog or the record need to be adapted to new Catgen definition
 if catheader.reclen<>sizeof(TGaiaRec) then
    raise Exception.Create('Gaia catalog '+GaiaPath+' as wrong record length');
end;

procedure GetGaiaInfo(var h : TCatHeader; var info:TCatHdrInfo; var version : integer; var filter,ok : boolean);
begin
ok:=ReadGaiaheader;
h:=catheader;
version:=catversion;
info:=catinfo;
filter:=(cattype=ctBin);
end;

function GetGaiaVersion: String;
begin
  result:=trim(catheader.LongName);
  if result='' then begin
    ReadGaiaHeader;
    result:=trim(catheader.LongName);
  end;
end;

Procedure CloseGaiaRegion;
begin
{$I-}
try
if FileBIsOpen then begin
  FileBIsOpen:=false;
  mem.free;
end;
except
end;
{$I+}
end;

Procedure OpenGaiafile(nomfich : string; var ok : boolean);
begin
 ok:=false;
 if not FileExists(nomfich) then exit;
 FileMode:=0;
 try
   mem:=TMemoryStream.Create;
   mem.LoadFromFile(nomfich);
   mem.Position:=0;
   FileBIsOpen:=true;
   FirstRead:=true;
   Nrec:=0;
   ok:=true;
   if mem.Size=0 then NextGaia(ok);
 except
   ok:=false;            // catgen running?
   FileBIsOpen:=false;
 end;
end;

Procedure OpenGaiaRegion(hemis : char ;zone,S : integer ; var ok:boolean);
var nomreg,nomzone :string;
begin
 str(S:4,nomreg);
 str(abs(zone):4,nomzone);
 case catheader.filenum of
   732    : nomfich:=GaiaPath+slashchar+hemis+padzeros(nomzone,4)+slashchar+catname+padzeros(nomreg,3)+'.dat';
   9537   : nomfich:=GaiaPath+slashchar+hemis+padzeros(nomzone,4)+slashchar+catname+padzeros(nomreg,4)+'.dat';
   63002  : nomfich:=GaiaPath+slashchar+padzeros(nomzone,3)+slashchar+catname+padzeros(nomreg,3)+'.dat';
 end;
 SMname:=nomreg;
 if FileBIsOpen then CloseGaiaRegion;
 OpenGaiaFile(nomfich,ok);
end;


Procedure OpenGaiap(ar1,ar2,de1,de2: double ; var ok : boolean; out maxlevel: integer);
begin
 curSM:=1;
 ar1:=ar1*15; ar2:=ar2*15;
 ok:=ReadGaiaHeader;
 if ok then begin
    case catheader.filenum of
      732    : begin FindRegionAll7(ar1,ar2,de1,de2,nSM,zonelst,SMlst,hemislst); maxlevel:=4; end;
      9537   : begin FindRegionAll(ar1,ar2,de1,de2,nSM,zonelst,SMlst,hemislst); maxlevel:=3; end;
      63002  : begin FindRegionAll1(ar1,ar2,de1,de2,nSM,zonelst,SMlst,hemislst); maxlevel:=4; end;
    end;
    hemis:= hemislst[curSM];
    zone := zonelst[curSM];
    Sm := Smlst[curSM];
    OpenGaiaRegion(hemis,zone,Sm,ok);
 end;
end;

Procedure NextGaia( var ok : boolean);
begin
  CloseGaiaRegion;
  inc(curSM);
  if curSM>nSM then ok:=false
  else begin
    hemis:= hemislst[curSM];
    zone := zonelst[curSM];
    Sm := Smlst[curSM];
    OpenGaiaRegion(hemis,zone,Sm,ok);
  end;
end;

procedure CloseGaia ;
begin
curSM:=nSM;
CloseGaiaRegion;
end;

Procedure OpenGaiawin(var ok : boolean; out maxlevel: integer);
begin
curSM:=1;
ok:=ReadGaiaHeader;
if ok then begin
 case catheader.filenum of
   732    : begin FindRegionAllWin7(nSM,zonelst,SMlst,hemislst); maxlevel:=4; end;
   9537   : begin FindRegionAllWin(nSM,zonelst,SMlst,hemislst); maxlevel:=3; end;
   63002  : begin FindRegionAllWin1(nSM,zonelst,SMlst,hemislst); maxlevel:=4; end;
 end;
 hemis:= hemislst[curSM];
 zone := zonelst[curSM];
 Sm := Smlst[curSM];
 OpenGaiaRegion(hemis,zone,Sm,ok);
end;
end;

Procedure ReadGaia(var lin : GCatrec; var ok : boolean);
var n : integer;
begin
ok:=true;
if FirstRead then begin
   lin:=emptyrec;
   FirstRead:=false;
end;
  if not FileBIsOpen then begin
    ok:=false;
    exit;
  end;
  if (Nrec>MaxGaiaRec)or(mem.Position>=mem.Size) then begin
     NextGaia(ok)
  end;
  if ok then begin
   inc(Nrec);
   n:=mem.Read(datarec,catheader.reclen);
   if n=catheader.reclen then begin
    lin.ra:=datarec.ra/3600000;
    lin.dec:=datarec.de/3600000-90;
    lin.star.id:=IntToStr(datarec.sid);
    lin.star.magv:=datarec.G/1000; if lin.star.magv>32 then lin.star.magv:=99;
    lin.star.magb:=datarec.B/1000; if lin.star.magb>32 then lin.star.magb:=99;
    lin.star.magr:=datarec.R/1000; if lin.star.magr>32 then lin.star.magr:=99;
    lin.star.pmra:=datarec.pmra;
    lin.star.pmdec:=datarec.pmdec;
    lin.star.px:=datarec.px;
    lin.num[1]:=datarec.rv;
  end else ok:=false;
end;
end;

end.
