unit cu_catalog;
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
Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
}
{
 Catalog interface component. Also contain shared resources.
}

{$mode delphi}{$H+}

interface

uses
    bscunit, dscat, findunit, gcatunit, gcmunit, gcvunit, gpnunit, gsccompact,
    gscfits, gscunit, lbnunit, microcatunit, ngcunit, oclunit, pgcunit, vocat,
    sacunit, skylibcat, skyunit, ticunit, tyc2unit, tycunit, usnoaunit, wdsunit,
    rc3unit,
    u_translation, u_constant, u_util, u_projection,
    SysUtils, Classes, Math, Dialogs, Forms;

type

  Tcatalog = class(TComponent)
  private
    { Private declarations }
    LockCat : boolean;
    NumCat,CurCat,CurGCat,VerGCat,CurrentUserObj,DSLcolor : integer;
    GcatFilter, DSLForceColor: boolean;
    EmptyRec : GCatRec;
    FFindId : string;
    FFindRecOK : boolean;
    FFindRec : GCatrec;
  protected
    { Protected declarations }
     function InitRec(cat:integer):boolean;
     function OpenStarCat:boolean;
     function CloseStarCat:boolean;
     function NewGCat:boolean;
     function GetVOCatS(var rec:GcatRec):boolean;
     function GetVOCatN(var rec:GcatRec):boolean;
     function GetUObjN(var rec:GcatRec):boolean;
     function GetGCatS(var rec:GcatRec):boolean;
     function GetGCatV(var rec:GcatRec):boolean;
     function GetGCatD(var rec:GcatRec):boolean;
     function GetGCatN(var rec:GcatRec):boolean;
     function GetGCatL(var rec:GcatRec):boolean;
     procedure FindNGCat(id : shortstring; var ar,de:double ; var ok:boolean; ctype:integer=-1);
     function GetBSC(var rec:GcatRec):boolean;
     function GetSky2000(var rec:GcatRec):boolean;
     function GetTYC(var rec:GcatRec):boolean;
     procedure FormatTYC2(lin : TY2rec; var rec:GcatRec);
     function GetTYC2(var rec:GcatRec):boolean;
     procedure FindTYC2(id: string; var ra,dec: double; var ok:boolean);
     function GetTIC(var rec:GcatRec):boolean;
     function GetGSCF(var rec:GcatRec):boolean;
     function GetGSCC(var rec:GcatRec):boolean;
     function GetGSC(var rec:GcatRec):boolean;
     function GetUSNOA(var rec:GcatRec):boolean;
     function GetMCT(var rec:GcatRec):boolean;
     function GetDSbase(var rec:GcatRec):boolean;
     function GetDSTyc(var rec:GcatRec):boolean;
     function GetDSGsc(var rec:GcatRec):boolean;
     function OpenVarStarCat:boolean;
     function CloseVarStarCat:boolean;
     function GetGCVS(var rec:GcatRec):boolean;
     procedure FormatGCVS(lin : GCVrec; var rec:GcatRec);
     procedure FindGCVS(id: string; var ra,dec: double; var ok:boolean);
     function OpenDblStarCat:boolean;
     function CloseDblStarCat:boolean;
     function GetWDS(var rec:GcatRec):boolean;
     procedure FormatWDS(lin : WDSrec; var rec:GcatRec);
     procedure FindWDS(id: string; var ra,dec: double; var ok:boolean);
     function OpenNebCat:boolean;
     function CloseNebCat:boolean;
     function GetSAC(var rec:GcatRec):boolean;
     procedure FormatSAC(lin : SACrec; var rec:GcatRec);
     procedure FindSAC(id: string; var ra,dec: double; var ok:boolean);
     function GetNGC(var rec:GcatRec):boolean;
     function GetLBN(var rec:GcatRec):boolean;
     function GetRC3(var rec:GcatRec):boolean;
     procedure FormatPGC(lin : PGCrec; var rec:GcatRec);
     function GetPGC(var rec:GcatRec):boolean;
     procedure FindPGC(id: integer; var ra,dec: double; var ok:boolean);
     function GetOCL(var rec:GcatRec):boolean;
     function GetGCM(var rec:GcatRec):boolean;
     function GetGPN(var rec:GcatRec):boolean;
     function OpenLinCat:boolean;
     function CloseLinCat:boolean;
     procedure FormatGCatS(var rec:GcatRec);
  public
    { Public declarations }
     cfgcat : Tconf_catalog;
     cfgshr : Tconf_shared;
     constructor Create(AOwner:TComponent); override;
     destructor  Destroy; override;
     function OpenCat(c: Tconf_skychart):boolean;
     function CloseCat:boolean;
     function OpenStar:boolean;
     function CloseStar:boolean;
     function ReadStar(var rec:GcatRec):boolean;
     function OpenVarStar:boolean;
     function CloseVarStar:boolean;
     function ReadVarStar(var rec:GcatRec):boolean;
     function OpenDblStar:boolean;
     function CloseDblStar:boolean;
     function ReadDblStar(var rec:GcatRec):boolean;
     function OpenNeb:boolean;
     function CloseNeb:boolean;
     function ReadNeb(var rec:GcatRec):boolean;
     function OpenLin:boolean;
     function CloseLin:boolean;
     function ReadLin(var rec:GcatRec):boolean;
     function OpenMilkyWay(fill:boolean):boolean;
     function CloseMilkyWay:boolean;
     function ReadMilkyWay(var rec:GcatRec):boolean;
     function OpenDSL(forcecolor: boolean; col:integer):boolean;
     function CloseDSL:boolean;
     function ReadDSL(var rec:GcatRec):boolean;
     function OpenDefaultStars:boolean;
     Procedure OpenDefaultStarsPos(ar1,ar2,de1,de2: double ; var ok : boolean);
     function CloseDefaultStars:boolean;
     function GetDefaultStars(var rec:GcatRec):boolean;
     procedure FindDefaultStars(id:shortstring; var ar,de:double ; var ok:boolean; ctype:integer=-1);
     function FindNum(cat: integer; id: string; var ra,dec: double):boolean ;
     function SearchNebulae(Num:string; var ar1,de1: double): boolean;
     function SearchStar(Num:string; var ar1,de1: double): boolean;
     function SearchStarName(Num:string; var ar1,de1: double): boolean;
     function SearchDblStar(Num:string; var ar1,de1: double): boolean;
     function SearchVarStar(Num:string; var ar1,de1: double): boolean;
     function SearchLines(Num:string; var ar1,de1: double): boolean;
     function SearchConstellation(Num:string; var ar1,de1: double): boolean;
     function SearchConstAbrev(Num:string; var ar1,de1: double): boolean;
     function FindAtPos(cat:integer; x1,y1,x2,y2:double; nextobj,truncate,searchcenter : boolean;cfgsc:Tconf_skychart; var rec: Gcatrec):boolean;
     function FindObj(x1,y1,x2,y2:double; searchcenter : boolean;cfgsc:Tconf_skychart; var rec: Gcatrec;ftype:integer=ftAll):boolean;
     procedure GetAltName(rec: GCatrec; var txt: string);
     function CheckPath(cat: integer; catpath:string):boolean;
     function GetInfo(path,shortname:string; var magmax:single;var v:integer; var version,longname:string):boolean;
     function GetMaxField(path,cat: string):string;
     function GetCatType(path,cat: string):integer;
     function GetVOstarmag: double;
     Procedure LoadConstellation(fpath,lang:string);
     Procedure LoadConstL(fname:string);
     Procedure LoadConstB(fname:string);
     Procedure LoadHorizon(fname:string; cfgsc:Tconf_skychart);
     Procedure LoadStarName(fpath,lang:string);
     function  LongLabelGreek(txt : string) : string;
     function  LongLabelConst(txt : string) : string;
     function  LongLabel(txt:string):string;
     function  LongLabelObj(txt:string):string;
     procedure ClearSearch;
     property FindId : string read FFindId;
     property FindRecOK : boolean read FFindRecOK;
     property FindRec : GCatrec read FFindRec write FFindRec;
  published
    { Published declarations }
  end;


Implementation

// compute nebula radius
function GetRadius(var rec:Gcatrec):double;
var nebunit:double;
begin
  result:=0;
  if rec.neb.valid[vnNebunit] then nebunit:=rec.neb.nebunit
                              else nebunit:=rec.options.Units;
  if nebunit<>0 then begin
     result:=minarc*rec.neb.dim1*60/2/nebunit;
     if result=0 then result:=minarc*rec.neb.dim2*60/2/nebunit;
  end;
end;

constructor Tcatalog.Create(AOwner:TComponent);
begin
 inherited Create(AOwner);
 cfgcat:=Tconf_catalog.Create;
 cfgshr:=Tconf_shared.Create;
 lockcat:=false;
end;

destructor Tcatalog.Destroy;
begin
gcatunit.CleanCache;
cfgcat.Free;
cfgshr.Free;
try
 inherited destroy;
except
writetrace('error destroy '+name);
end;
end;

procedure Tcatalog.ClearSearch;
begin
FFindRecOK:=false;
FFindId:='';
end;

Function Tcatalog.OpenCat(c: Tconf_skychart):boolean;
var ac,dc,rac,ddc: double;
begin
// get a lock before to do anything, libcatalog is NOT thread safe.
  while lockcat do application.ProcessMessages;
  lockcat:=true;
  case c.ProjPole of
  Gal   : begin
          ac:=rad2deg*c.lcentre;
          dc:=rad2deg*c.bcentre;
          end;
  Ecl   : begin
          ac:=rad2deg*c.lecentre;
          dc:=rad2deg*c.becentre;
          end;
  else    begin
          ac:=rad2deg*c.acentre;
          dc:=rad2deg*c.hcentre;
          end;
  end;
  rac:=c.racentre; ddc:=c.decentre;
  if c.ApparentPos then mean_equatorial(rac,ddc,c,true,true);
  InitCatWin(c.axglb,c.ayglb,c.bxglb/rad2deg,c.byglb/rad2deg,c.sintheta,c.costheta,rad2deg*rac/15,rad2deg*ddc,ac,dc,c.CurJDUT,c.JDChart,rad2deg*c.CurST/15,c.ObsLatitude,c.ProjPole,c.xshift,c.yshift,c.xmin,c.xmax,c.ymin,c.ymax,c.projtype,northpole2000inmap(c),southpole2000inmap(c),c.ProjEquatorCentered,c.haicx,c.haicy);
  result:=true;
end;

function Tcatalog.CloseCat:boolean;
begin
lockcat:=false;
CloseGCat;
result:=true;
end;


{ Stars }

function Tcatalog.OpenStar:boolean;
begin
numcat:=MaxStarCatalog;
curcat:=BaseStar+1;
while ((curcat-BaseStar)<=numcat)and(not cfgcat.starcaton[curcat-BaseStar]) do inc(curcat);
if ((curcat-BaseStar)>numcat) then result:=false
 else result:=OpenStarCat;
end;

function Tcatalog.CloseStar:boolean;
begin
 result:=CloseStarCat;
 curcat:=numcat+BaseStar;
end;

function Tcatalog.ReadStar(var rec:GcatRec):boolean;
begin
result:=false;
case curcat of
   DefStar : result:=GetDefaultStars(rec);
   sky2000 : result:=GetSky2000(rec);
   tyc     : result:=GetTYC(rec);
   tyc2    : result:=GetTYC2(rec);
   tic     : result:=GetTIC(rec);
   gscf    : result:=GetGSCF(rec);
   gscc    : result:=GetGSCC(rec);
   gsc     : result:=GetGSC(rec);
   usnoa   : result:=GetUSNOA(rec);
   microcat: result:=GetMCT(rec);
   dsbase  : result:=GetDSbase(rec);
   dstyc   : result:=GetDSTyc(rec);
   dsgsc   : result:=GetDSGsc(rec);
   gcstar  : begin
             result:=GetGcatS(rec);
             if not result then begin
                result:=NewGcat;
                if result then begin
                   OpenGCatWin(result);
                   result:=ReadStar(rec);
                end;
             end;
             end;
   vostar  : begin
             result:=GetVOcatS(rec);
             end;
   bsc     : result:=GetBSC(rec);
end;
if (not result) and ((curcat-BaseStar)<numcat) then begin
repeat
  CloseStarCat;
  inc(curcat);
  while ((curcat-BaseStar)<=numcat)and(not cfgcat.starcaton[curcat-BaseStar]) do inc(curcat);
  result:=false;
  if ((curcat-BaseStar)>numcat) then break
  else begin
     result:=OpenStarCat;
     if result then result:=ReadStar(rec)
     else  cfgcat.starcaton[curcat-BaseStar]:=false;
  end;
until result;
end;
end;

function Tcatalog.OpenStarCat:boolean;
var nty2cat,nmctcat : integer;
begin
if cfgshr.StarFilter and (cfgcat.StarmagMax<=11) then begin
   nty2cat:=1;
   nmctcat:=1;
end else begin
   nty2cat:=2;
   nmctcat:=3;
end;
InitRec(curcat);
case curcat of
   DefStar : result:=OpenDefaultStars;
   sky2000 : begin SetSkyPath(cfgcat.starcatpath[sky2000-BaseStar]); OpenSkywin(result); end;
   tyc     : begin SetTycPath(cfgcat.starcatpath[tyc-BaseStar]); OpenTYCwin(result); end;
   tyc2    : begin SetTy2Path(cfgcat.starcatpath[tyc2-BaseStar]); OpenTY2win(nty2cat,result); end;
   tic     : begin SetTicPath(cfgcat.starcatpath[tic-BaseStar]); OpenTICwin(result); end;
   gscf    : begin SetGscfPath(cfgcat.starcatpath[gscf-BaseStar]); OpenGSCFwin(result); end;
   gscc    : begin SetGsccPath(cfgcat.starcatpath[gscc-BaseStar]); OpenGSCCwin(result); end;
   gsc     : begin SetGscPath(cfgcat.starcatpath[gsc-BaseStar]); OpenGSCwin(result); end;
   usnoa   : begin SetUSNOAPath(cfgcat.starcatpath[usnoa-BaseStar]); OpenUSNOAwin(result); end;
   microcat: begin SetMCTPath(cfgcat.starcatpath[microcat-BaseStar]); OpenMCTwin(nmctcat,result); end;
   dsbase  : begin SetDSPath(cfgcat.starcatpath[dsbase-BaseStar],cfgcat.starcatpath[dstyc-BaseStar],cfgcat.starcatpath[dsgsc-BaseStar]); OpenDSbasewin(result); end;
   dstyc   : begin SetDSPath(cfgcat.starcatpath[dsbase-BaseStar],cfgcat.starcatpath[dstyc-BaseStar],cfgcat.starcatpath[dsgsc-BaseStar]); OpenDStycwin(result); end;
   dsgsc   : begin SetDSPath(cfgcat.starcatpath[dsbase-BaseStar],cfgcat.starcatpath[dstyc-BaseStar],cfgcat.starcatpath[dsgsc-BaseStar]); OpenDSgscwin(result); end;
   gcstar  : begin
                   VerGCat:=rtStar;
                   CurGCat:=0;
                   result:=false;
                   while NewGCat do begin
                      OpenGCatWin(result);
                      if result then break;
                   end;
             end;
   vostar  : begin
                VOobject:='star';
                SetVOCatpath(slash(VODir));
                OpenVOCatwin(result);
             end;
   bsc     : begin SetBscPath(cfgcat.starcatpath[bsc-BaseStar]); OpenBSCwin(result); end;
   else result:=false;
end;
end;

function Tcatalog.CloseStarCat:boolean;
begin
result:=true;
case curcat of
   DefStar : CloseDefaultStars;
   sky2000 : CloseSky;
   tyc     : CloseTYC;
   tyc2    : CloseTY2;
   tic     : CloseTIC;
   gscf    : CloseGSCF;
   gscc    : CloseGSCC;
   gsc     : CloseGSC;
   usnoa   : CloseUSNOA;
   microcat: CloseMCT;
   dsbase  : CloseDSbase;
   dstyc   : CloseDStyc;
   dsgsc   : CloseDSgsc;
   gcstar  : CloseGcat;
   vostar  : CloseVOCat;
   bsc     : CloseBSC;
   else result:=false;
end;
end;

{ Variables Stars }

function Tcatalog.OpenVarStar:boolean;
begin
numcat:=MaxVarStarCatalog;
curcat:=BaseVar+1;
while ((curcat-BaseVar)<=numcat)and(not cfgcat.varstarcaton[curcat-BaseVar]) do inc(curcat);
if ((curcat-BaseVar)>numcat) then result:=false
 else result:=OpenVarStarCat;
end;

function Tcatalog.CloseVarStar:boolean;
begin
 result:=CloseVarStarCat;
 curcat:=numcat+BaseVar;
end;

function Tcatalog.ReadVarStar(var rec:GcatRec):boolean;
begin
result:=false;
case curcat of
   gcvs     : result:=GetGCVS(rec);
   gcvar   : begin
             result:=GetGcatV(rec);
             if not result then begin
                result:=NewGcat;
                if result then begin
                   OpenGCatWin(result);
                   result:=ReadVarStar(rec);
                end;
             end;
             end;
end;
if (not result) and ((curcat-BaseVar)<numcat) then begin
repeat
  CloseVarStarCat;
  inc(curcat);
  while ((curcat-BaseVar)<=numcat)and(not cfgcat.varstarcaton[curcat-BaseVar]) do inc(curcat);
  result:=false;
  if ((curcat-BaseVar)>numcat) then break
  else begin
     result:=OpenVarStarCat;
     if result then result:=ReadVarStar(rec)
     else cfgcat.varstarcaton[curcat-BaseVar]:=false;
  end;
until result;
end;
end;

function Tcatalog.OpenVarStarCat:boolean;
begin
InitRec(curcat);
case curcat of
   gcvs    : begin SetGCVPath(cfgcat.varstarcatpath[gcvs-BaseVar]); OpenGCVwin(result); end;
   gcvar   : begin
                   VerGCat:=rtVar;
                   CurGCat:=0;
                   result:=false;
                   while NewGCat do begin
                      OpenGCatWin(result);
                      if result then break;
                   end;
             end;
   else result:=false;
end;
end;

function Tcatalog.CloseVarStarCat:boolean;
begin
result:=true;
case curcat of
   gcvs    : CloseGCV;
   gcvar   : CloseGcat;
   else result:=false;
end;
end;

{ Doubles Stars }

function Tcatalog.OpenDblStar:boolean;
begin
numcat:=MaxDblStarCatalog;
curcat:=BaseDbl+1;
while ((curcat-BaseDbl)<=numcat)and(not cfgcat.dblstarcaton[curcat-BaseDbl]) do inc(curcat);
if ((curcat-BaseDbl)>numcat) then result:=false
 else result:=OpenDblStarCat;
end;

function Tcatalog.CloseDblStar:boolean;
begin
 result:=CloseDblStarCat;
 curcat:=numcat+BaseDbl;     
end;

function Tcatalog.ReadDblStar(var rec:GcatRec):boolean;
begin
result:=false;
case curcat of
   wds      : result:=GetWDS(rec);
   gcdbl   : begin
             result:=GetGcatD(rec);
             if not result then begin
                result:=NewGcat;
                if result then begin
                   OpenGCatWin(result);
                   result:=ReadDblStar(rec);
                end;
             end;
             end;
end;
if (not result) and ((curcat-BaseDbl)<numcat) then begin
repeat
  CloseDblStarCat;
  inc(curcat);
  while ((curcat-BaseDbl)<=numcat)and(not cfgcat.dblstarcaton[curcat-BaseDbl]) do inc(curcat);
  result:=false;
  if ((curcat-BaseDbl)>numcat) then break
  else begin
     result:=OpendblStarCat;
     if result then result:=ReadDblStar(rec)
     else cfgcat.dblstarcaton[curcat-BaseDbl]:=false;
  end;
until result;
end;
end;

function Tcatalog.OpenDblStarCat:boolean;
begin
InitRec(curcat);
case curcat of
   wds     : begin SetWDSPath(cfgcat.dblstarcatpath[wds-BaseDbl]); OpenWDSwin(result); end;
   gcdbl   : begin
                  VerGCat:=rtDbl;
                  CurGCat:=0;
                  result:=false;
                  while NewGCat do begin
                     OpenGCatWin(result);
                     if result then break;
                  end;
             end;
   else result:=false;
end;
end;

function Tcatalog.CloseDblStarCat:boolean;
begin
result:=true;
case curcat of
   wds     : CloseWDS;
   gcdbl   : CloseGcat;
   else result:=false;
end;
end;

{ Nebulae }

function Tcatalog.OpenNeb:boolean;
begin
numcat:=MaxNebCatalog;
curcat:=BaseNeb+1;
while ((curcat-BaseNeb)<=numcat)and(not cfgcat.nebcaton[curcat-BaseNeb]) do inc(curcat);
if ((curcat-BaseNeb)>numcat) then result:=false
 else result:=OpenNebCat;
end;

function Tcatalog.CloseNeb:boolean;
begin
 result:=CloseNebCat;
 curcat:=numcat+BaseNeb;
end;

function Tcatalog.ReadNeb(var rec:GcatRec):boolean;
begin
result:=false;
case curcat of
   sac     : result:=GetSAC(rec);
   ngc     : result:=GetNGC(rec);
   lbn     : result:=GetLBN(rec);
   rc3     : result:=GetRC3(rec);
   pgc     : result:=GetPGC(rec);
   ocl     : result:=GetOCL(rec);
   gcm     : result:=GetGCM(rec);
   gpn     : result:=GetGPN(rec);
   gcneb   : begin
             result:=GetGcatN(rec);
             if not result then begin
                result:=NewGcat;
                if result then begin
                   OpenGCatWin(result);
                   result:=ReadNeb(rec);
                end;
             end;
             end;
   voneb   : begin
             result:=GetVOcatN(rec);
             end;
   uneb   : begin
             result:=GetUObjN(rec);
             end;
end;
if (not result) and ((curcat-BaseNeb)<numcat) then begin
repeat
  CloseNebCat;
  inc(curcat);
  while ((curcat-BaseNeb)<=numcat)and(not cfgcat.nebcaton[curcat-BaseNeb]) do inc(curcat);
  result:=false;
  if ((curcat-BaseNeb)>numcat) then break
  else begin
    result:=OpenNebCat;
    if result then result:=ReadNeb(rec)
    else  cfgcat.nebcaton[curcat-BaseNeb]:=false;
  end;
until result;
end;
end;

function Tcatalog.OpenNebCat:boolean;
begin
InitRec(curcat);
case curcat of
   sac     : begin SetSacPath(cfgcat.nebcatpath[sac-BaseNeb]); OpenSACwin(result); end;
   ngc     : begin SetngcPath(cfgcat.nebcatpath[ngc-BaseNeb]); Openngcwin(result); end;
   lbn     : begin SetlbnPath(cfgcat.nebcatpath[lbn-BaseNeb]); Openlbnwin(result); end;
   rc3     : begin Setrc3Path(cfgcat.nebcatpath[rc3-BaseNeb]); Openrc3win(result); end;
   pgc     : begin SetpgcPath(cfgcat.nebcatpath[pgc-BaseNeb]); Openpgcwin(result); end;
   ocl     : begin SetoclPath(cfgcat.nebcatpath[ocl-BaseNeb]); Openoclwin(result); end;
   gcm     : begin SetgcmPath(cfgcat.nebcatpath[gcm-BaseNeb]); Opengcmwin(result); end;
   gpn     : begin SetgpnPath(cfgcat.nebcatpath[gpn-BaseNeb]); Opengpnwin(result); end;
   gcneb  : begin
                   VerGCat:=rtNeb;
                   CurGCat:=0;
                   result:=false;
                   while NewGCat do begin
                      OpenGCatWin(result);
                      if result then break;
                   end;
            end;
   voneb  : begin
                VOobject:='dso';
                SetVOCatpath(slash(VODir));
                OpenVOCatwin(result);
             end;
   uneb   :  begin
                CurrentUserObj:=-1;
                result:=true;
             end;
   else result:=false;
end;
end;

function Tcatalog.CloseNebCat:boolean;
begin
result:=true;
case curcat of
   sac     : CloseSAC;
   ngc     : CloseNGC;
   lbn     : CloseLBN;
   rc3     : CloseRC3;
   pgc     : ClosePGC;
   ocl     : CloseOCL;
   gcm     : CloseGCM;
   gpn     : CloseGPN;
   gcneb   : CloseGcat;
   voneb   : CloseVOCat;
   uneb    : CurrentUserObj:=MaxInt;
   else result:=false;
end;
end;

{ Outline }

function Tcatalog.OpenLin:boolean;
begin
numcat:=MaxLinCatalog;
curcat:=BaseLin+1;
while ((curcat-BaseLin)<=numcat)and(not cfgcat.lincaton[curcat-BaseLin]) do inc(curcat);
if ((curcat-BaseLin)>numcat) then result:=false
 else result:=OpenLinCat;
end;

function Tcatalog.CloseLin:boolean;
begin
 result:=CloseLinCat;
 curcat:=numcat+BaseLin;
end;

function Tcatalog.ReadLin(var rec:GcatRec):boolean;
begin
result:=false;
case curcat of
   gclin   : begin
             result:=GetGcatL(rec);
             if not result then begin
                result:=NewGcat;
                if result then begin
                   OpenGCatWin(result);
                   result:=ReadLin(rec);
                end;
             end;
             end;
end;
if (not result) and ((curcat-BaseLin)<numcat) then begin
  CloseLinCat;
  inc(curcat);
  while ((curcat-BaseLin)<=numcat)and(not cfgcat.Lincaton[curcat-BaseLin]) do inc(curcat);
  if ((curcat-BaseLin)>numcat) then result:=false
     else result:=OpenLinCat;
  if result then result:=ReadLin(rec);
end;
end;

function Tcatalog.OpenLinCat:boolean;
begin
InitRec(curcat);
case curcat of
   gclin  : begin
                 VerGCat:=rtLin;
                 CurGCat:=0;
                 result:=false;
                 while NewGCat do begin
                    OpenGCatWin(result);
                    if result then break;
                 end;
             end;
   else result:=false;
end;
end;

function Tcatalog.CloseLinCat:boolean;
begin
result:=true;
case curcat of
   gclin   : CloseGcat;
   else result:=false;
end;
end;

function Tcatalog.OpenMilkyWay(fill:boolean):boolean;
var GcatH : TCatHeader;
    v : integer;
begin
 if fill then
    SetGcatPath(slash(appdir)+pathdelim+'cat'+pathdelim+'milkyway','mwf')
 else
    SetGcatPath(slash(appdir)+pathdelim+'cat'+pathdelim+'milkyway','mwl');
 GetGCatInfo(GcatH,v,GCatFilter,result);
 if result then result:=(v=rtLin);
 if result then OpenGCatWin(result);
end;

function Tcatalog.CloseMilkyWay:boolean;
begin
 CloseGcat;
 result:=true;
end;

function Tcatalog.ReadMilkyWay(var rec:GcatRec):boolean;
begin
result:=true;
repeat
  ReadGCat(rec,result);
  if not result then break;
  rec.ra:=deg2rad*rec.ra;
  rec.dec:=deg2rad*rec.dec;
  break;
until not result;
end;

function Tcatalog.OpenDSL(forcecolor: boolean; col:integer):boolean;
var GcatH : TCatHeader;
    v : integer;
begin
 DSLForceColor:=forcecolor;
 DSLcolor:=col;
 SetGcatPath(slash(appdir)+pathdelim+'cat'+pathdelim+'DSoutlines','dsl');
 GetGCatInfo(GcatH,v,GCatFilter,result);
 if result then result:=(v=rtLin);
 if result then OpenGCatWin(result);
end;

function Tcatalog.CloseDSL:boolean;
begin
 CloseGcat;
 result:=true;
end;

function Tcatalog.ReadDSL(var rec:GcatRec):boolean;
begin
result:=true;
repeat
  ReadGCat(rec,result);
  if not result then break;
  rec.ra:=deg2rad*rec.ra;
  rec.dec:=deg2rad*rec.dec;
  if DSLForceColor then begin
    rec.outlines.valid[vlLinecolor]:=true;
    rec.outlines.linecolor:=DSLcolor;
  end;
  break;
until not result;
end;

function Tcatalog.OpenDefaultStars:boolean;
var GcatH : TCatHeader;
    v : integer;
begin
 SetGcatPath(cfgcat.starcatpath[DefStar-BaseStar],'star');
 GetGCatInfo(GcatH,v,GCatFilter,result);
 // files are sorted
 GCatFilter:=true;
 if result then result:=(v=rtStar);
 if result then OpenGCatWin(result);
end;

Procedure Tcatalog.OpenDefaultStarsPos(ar1,ar2,de1,de2: double ; var ok : boolean);
var GcatH : TCatHeader;
    v : integer;
begin
 SetGcatPath(cfgcat.starcatpath[DefStar-BaseStar],'star');
 GetGCatInfo(GcatH,v,GCatFilter,ok);
 // files are sorted
 GCatFilter:=true;
 if ok then ok:=(v=rtStar);
 if ok then OpenGCat(ar1,ar2,de1,de2,ok);
end;

function Tcatalog.CloseDefaultStars:boolean;
begin
 CloseGcat;
 result:=true;
end;

function Tcatalog.GetDefaultStars(var rec:GcatRec):boolean;
begin
  result:=GetGCatS(rec);
end;

procedure Tcatalog.FindDefaultStars(id:shortstring; var ar,de:double ; var ok:boolean; ctype:integer=-1);
var
   H : TCatHeader;
   rec:GCatrec;
   version : integer;
   iid:string;
begin
ok:=false;
iid:=id;
SetGcatPath(cfgcat.starcatpath[DefStar-BaseStar],'star');
GetGCatInfo(H,version,GCatFilter,ok);
GCatFilter:=true;
if fileexists(slash(cfgcat.starcatpath[DefStar-BaseStar])+'star'+'.ixr') then begin
   if ok then FindNumGcatRec(cfgcat.starcatpath[DefStar-BaseStar],'star',iid,H.ixkeylen,rec,ok);
   if ok then begin
      ar:=rec.ra/15;
      de:=rec.dec;
      FormatGCatS(rec);
      FFindId:=id;
      FFindRecOK:=true;
      FFindRec:=rec;
   end;
end
else ok:=false;
end;

// CatGen header simulation for old catalog

function Tcatalog.InitRec(cat:integer):boolean;
begin
  fillchar(EmptyRec,sizeof(GcatRec),0);
  result:=true;
  case cat of
   bsc     : begin
             EmptyRec.options.flabel:=StarLabel;
             EmptyRec.options.ShortName:='BSC';
             EmptyRec.options.LongName:='Bright Stars Catalog';
             EmptyRec.options.rectype:=rtStar;
             EmptyRec.options.Equinox:=2000;
             EmptyRec.options.EquinoxJD:=jd2000;
             EmptyRec.options.Epoch:=2000;
             EmptyRec.options.MagMax:=6.5;
             EmptyRec.options.UsePrefix:=1;
             EmptyRec.options.altname[1]:=true;
             EmptyRec.options.altname[2]:=true;
             EmptyRec.options.flabel[16]:='HR';
             EmptyRec.options.flabel[17]:='HD';
             EmptyRec.options.flabel[18]:=rsCommonName;
             EmptyRec.options.flabel[19]:='Flamsteed';
             EmptyRec.options.flabel[20]:='Bayer';
             Emptyrec.star.valid[vsId]:=true;
             Emptyrec.star.valid[vsMagv]:=true;
             Emptyrec.star.valid[vsB_v]:=true;
             Emptyrec.star.valid[vsSp]:=true;
             Emptyrec.star.valid[vsPmra]:=true;
             Emptyrec.star.valid[vsPmdec]:=true;
             EmptyRec.vstr[1]:=true;
             EmptyRec.vstr[2]:=true;
             end;
   sky2000 : begin
             EmptyRec.options.flabel:=StarLabel;
             EmptyRec.options.ShortName:='Sky';
             EmptyRec.options.LongName:='Sky2000 catalog';
             EmptyRec.options.rectype:=rtStar;
             EmptyRec.options.Equinox:=2000;
             EmptyRec.options.EquinoxJD:=jd2000;
             EmptyRec.options.Epoch:=2000;
             EmptyRec.options.MagMax:=9.5;
             EmptyRec.options.UsePrefix:=0;
             EmptyRec.options.altname[1]:=true;
             EmptyRec.options.altname[2]:=true;
             EmptyRec.options.flabel[16]:='HD';
             EmptyRec.options.flabel[17]:='SAO';
             EmptyRec.options.flabel[26]:='Sep';
             EmptyRec.options.flabel[27]:='Dmag';
             Emptyrec.star.valid[vsId]:=true;
             Emptyrec.star.valid[vsMagv]:=true;
             Emptyrec.star.valid[vsB_v]:=true;
             Emptyrec.star.valid[vsSp]:=true;
             Emptyrec.star.valid[vsPmra]:=true;
             Emptyrec.star.valid[vsPmdec]:=true;
             EmptyRec.vstr[1]:=true;
             EmptyRec.vstr[2]:=true;
             EmptyRec.vnum[1]:=true;
             EmptyRec.vnum[2]:=true;
             end;
   tyc     : begin
             EmptyRec.options.flabel:=StarLabel;
             EmptyRec.options.ShortName:='TYC';
             EmptyRec.options.LongName:='Tycho catalog';
             EmptyRec.options.rectype:=rtStar;
             EmptyRec.options.Equinox:=2000;
             EmptyRec.options.EquinoxJD:=jd2000;
             EmptyRec.options.Epoch:=1991.25;
             EmptyRec.options.MagMax:=12;
             EmptyRec.options.UsePrefix:=0;
             Emptyrec.star.valid[vsId]:=true;
             Emptyrec.star.valid[vsMagv]:=true;
             Emptyrec.star.valid[vsMagb]:=true;
             Emptyrec.star.valid[vsB_v]:=true;
             Emptyrec.star.valid[vsPmra]:=true;
             Emptyrec.star.valid[vsPmdec]:=true;
             end;
   tyc2    : begin
             EmptyRec.options.flabel:=StarLabel;
             EmptyRec.options.ShortName:='TYC';
             EmptyRec.options.LongName:='Tycho2 catalog';
             EmptyRec.options.rectype:=rtStar;
             EmptyRec.options.Equinox:=2000;
             EmptyRec.options.EquinoxJD:=jd2000;
             EmptyRec.options.Epoch:=2000.0;
             EmptyRec.options.MagMax:=12;
             EmptyRec.options.UsePrefix:=0;
             Emptyrec.star.valid[vsId]:=true;
             Emptyrec.star.valid[vsMagv]:=true;
             Emptyrec.star.valid[vsMagb]:=true;
             Emptyrec.star.valid[vsB_v]:=true;
             Emptyrec.star.valid[vsPmra]:=true;
             Emptyrec.star.valid[vsPmdec]:=true;
             end;
   tic     : begin
             EmptyRec.options.flabel:=StarLabel;
             EmptyRec.options.ShortName:='TIC';
             EmptyRec.options.LongName:='Tycho Input catalog';
             EmptyRec.options.rectype:=rtStar;
             EmptyRec.options.Equinox:=2000;
             EmptyRec.options.EquinoxJD:=jd2000;
             EmptyRec.options.MagMax:=12;
             EmptyRec.options.UsePrefix:=0;
             Emptyrec.star.valid[vsId]:=true;
             Emptyrec.star.valid[vsMagv]:=true;
             Emptyrec.star.valid[vsMagb]:=true;
             Emptyrec.star.valid[vsB_v]:=true;
             EmptyRec.vnum[1]:=true;
             EmptyRec.options.flabel[26]:='Class';
             end;
   gscf    : begin
             EmptyRec.options.flabel:=StarLabel;
             EmptyRec.options.ShortName:='GSC';
             EmptyRec.options.LongName:='HST Guide Star catalog';
             EmptyRec.options.rectype:=rtStar;
             EmptyRec.options.Equinox:=2000;
             EmptyRec.options.EquinoxJD:=jd2000;
             EmptyRec.options.MagMax:=15;
             EmptyRec.options.UsePrefix:=0;
             Emptyrec.star.valid[vsId]:=true;
             Emptyrec.star.valid[vsMagv]:=true;
             EmptyRec.vstr[1]:=true;
             EmptyRec.vstr[2]:=true;
             EmptyRec.vstr[3]:=true;
             EmptyRec.vstr[4]:=true;
             EmptyRec.options.flabel[16]:='Mag.band';
             EmptyRec.options.flabel[17]:='Class';
             EmptyRec.options.flabel[18]:='Mult';
             EmptyRec.options.flabel[19]:='Plate';
             EmptyRec.vnum[1]:=true;
             EmptyRec.vnum[2]:=true;
             EmptyRec.options.flabel[26]:='Pos.error';
             EmptyRec.options.flabel[27]:='Mag.error';
             end;
   gscc    : begin
             EmptyRec.options.flabel:=StarLabel;
             EmptyRec.options.ShortName:='GSC';
             EmptyRec.options.LongName:='HST Guide Star catalog';
             EmptyRec.options.rectype:=rtStar;
             EmptyRec.options.Equinox:=2000;
             EmptyRec.options.EquinoxJD:=jd2000;
             EmptyRec.options.MagMax:=15;
             EmptyRec.options.UsePrefix:=0;
             Emptyrec.star.valid[vsId]:=true;
             Emptyrec.star.valid[vsMagv]:=true;
             EmptyRec.vstr[1]:=true;
             EmptyRec.vstr[2]:=true;
             EmptyRec.vstr[3]:=true;
             EmptyRec.vstr[4]:=true;
             EmptyRec.options.flabel[16]:='Mag.band';
             EmptyRec.options.flabel[17]:='Class';
             EmptyRec.options.flabel[18]:='Mult';
             EmptyRec.options.flabel[19]:='Plate';
             EmptyRec.vnum[1]:=true;
             EmptyRec.vnum[2]:=true;
             EmptyRec.options.flabel[26]:='Pos.error';
             EmptyRec.options.flabel[27]:='Mag.error';
             end;
   gsc     : begin
             EmptyRec.options.flabel:=StarLabel;
             EmptyRec.options.ShortName:='GSC';
             EmptyRec.options.LongName:='HST Guide Star catalog';
             EmptyRec.options.rectype:=rtStar;
             EmptyRec.options.Equinox:=2000;
             EmptyRec.options.EquinoxJD:=jd2000;
             EmptyRec.options.MagMax:=15;
             EmptyRec.options.UsePrefix:=0;
             Emptyrec.star.valid[vsId]:=true;
             Emptyrec.star.valid[vsMagv]:=true;
             EmptyRec.vstr[1]:=true;
             EmptyRec.vstr[2]:=true;
             EmptyRec.vstr[3]:=true;
             EmptyRec.options.flabel[16]:='Mag.band';
             EmptyRec.options.flabel[17]:='Class';
             EmptyRec.options.flabel[18]:='Mult';
             EmptyRec.vnum[1]:=true;
             EmptyRec.vnum[2]:=true;
             EmptyRec.options.flabel[26]:='Pos.error';
             EmptyRec.options.flabel[27]:='Mag.error';
             end;
   usnoa   : begin
             EmptyRec.options.flabel:=StarLabel;
             EmptyRec.options.ShortName:='UNA';
             EmptyRec.options.LongName:='USNO-A catalog';
             EmptyRec.options.rectype:=rtStar;
             EmptyRec.options.Equinox:=2000;
             EmptyRec.options.EquinoxJD:=jd2000;
             EmptyRec.options.MagMax:=18;
             EmptyRec.options.UsePrefix:=0;
             Emptyrec.star.valid[vsId]:=true;
             Emptyrec.star.valid[vsMagv]:=true;
             Emptyrec.star.valid[vsMagb]:=true;
             EmptyRec.vstr[1]:=true;
             EmptyRec.vstr[2]:=true;
             EmptyRec.vstr[3]:=true;
             EmptyRec.options.flabel[16]:='Field';
             EmptyRec.options.flabel[17]:='Quality';
             EmptyRec.options.flabel[18]:='Calibration';
             end;
   microcat: begin
             EmptyRec.options.flabel:=StarLabel;
             EmptyRec.options.ShortName:='MCT';
             EmptyRec.options.LongName:='Microcat catalog';
             EmptyRec.options.rectype:=rtStar;
             EmptyRec.options.Equinox:=2000;
             EmptyRec.options.EquinoxJD:=jd2000;
             EmptyRec.options.MagMax:=16;
             EmptyRec.options.UsePrefix:=0;
             Emptyrec.star.valid[vsId]:=true;
             Emptyrec.star.valid[vsMagv]:=true;
             Emptyrec.star.valid[vsMagb]:=true;
             end;
   dsbase  : begin
             EmptyRec.options.flabel:=StarLabel;
             EmptyRec.options.ShortName:='BRS';
             EmptyRec.options.LongName:='Deepsky2000 base star catalog';
             EmptyRec.options.rectype:=rtStar;
             EmptyRec.options.Equinox:=2000;
             EmptyRec.options.EquinoxJD:=jd2000;
             EmptyRec.options.MagMax:=5;
             EmptyRec.options.UsePrefix:=0;
             Emptyrec.star.valid[vsId]:=true;
             end;
   dstyc   : begin
             EmptyRec.options.flabel:=StarLabel;
             EmptyRec.options.ShortName:='TYC';
             EmptyRec.options.LongName:='Deepsky2000 Tycho catalog';
             EmptyRec.options.rectype:=rtStar;
             EmptyRec.options.Equinox:=2000;
             EmptyRec.options.EquinoxJD:=jd2000;
             EmptyRec.options.MagMax:=12;
             EmptyRec.options.UsePrefix:=0;
             Emptyrec.star.valid[vsId]:=true;
             end;
   dsgsc   : begin
             EmptyRec.options.flabel:=StarLabel;
             EmptyRec.options.ShortName:='GSC';
             EmptyRec.options.LongName:='Deepsky2000 GSC catalog';
             EmptyRec.options.rectype:=rtStar;
             EmptyRec.options.Equinox:=2000;
             EmptyRec.options.EquinoxJD:=jd2000;
             EmptyRec.options.MagMax:=15;
             EmptyRec.options.UsePrefix:=0;
             Emptyrec.star.valid[vsId]:=true;
             end;
   gcvs    : begin
             EmptyRec.options.flabel:=VarLabel;
             EmptyRec.options.ShortName:='GCVS';
             EmptyRec.options.LongName:='General Catalog of Variable stars';
             EmptyRec.options.rectype:=rtVar;
             EmptyRec.options.Equinox:=2000;
             EmptyRec.options.EquinoxJD:=jd2000;
             EmptyRec.options.MagMax:=12;
             EmptyRec.options.UsePrefix:=0;
             Emptyrec.variable.valid[vvId]:=true;
             Emptyrec.variable.valid[vvMagmax]:=true;
             Emptyrec.variable.valid[vvMagmin]:=true;
             Emptyrec.variable.valid[vvPeriod]:=true;
             Emptyrec.variable.valid[vvVartype]:=true;
             Emptyrec.variable.valid[vvMagcode]:=true;
             EmptyRec.options.altname[1]:=true;
             EmptyRec.vstr[1]:=true;
             EmptyRec.vstr[2]:=true;
             EmptyRec.options.flabel[16]:='Num';
             EmptyRec.options.flabel[17]:='Limit';
             end;

   wds     : begin
             EmptyRec.options.flabel:=DblLabel;
             EmptyRec.options.ShortName:='WDS';
             EmptyRec.options.LongName:='Washington Double Star catalog';
             EmptyRec.options.rectype:=rtDbl;
             EmptyRec.options.Equinox:=2000;
             EmptyRec.options.EquinoxJD:=jd2000;
             EmptyRec.options.MagMax:=12;
             EmptyRec.options.UsePrefix:=0;
             Emptyrec.double.valid[vdId]:=true;
             Emptyrec.double.valid[vdMag1]:=true;
             Emptyrec.double.valid[vdMag2]:=true;
             Emptyrec.double.valid[vdPa]:=true;
             Emptyrec.double.valid[vdSep]:=true;
             Emptyrec.double.valid[vdEpoch]:=true;
             Emptyrec.double.valid[vdCompname]:=true;
             Emptyrec.double.valid[vdSp1]:=true;
             Emptyrec.double.valid[vdComment]:=true;
             end;

   sac     : begin
             EmptyRec.options.flabel:=NebLabel;
             EmptyRec.options.ShortName:='SAC';
             EmptyRec.options.LongName:='Saguaro Astronomy Club Database';
             EmptyRec.options.rectype:=rtNeb;
             EmptyRec.options.Equinox:=2000;
             EmptyRec.options.EquinoxJD:=jd2000;
             EmptyRec.options.MagMax:=12;
             EmptyRec.options.UsePrefix:=0;
             EmptyRec.options.Units:=60;
             EmptyRec.options.LogSize:=0;
             EmptyRec.options.ObjType:=-1;
             Emptyrec.neb.valid[vnId]:=true;
             Emptyrec.neb.valid[vnMag]:=true;
             Emptyrec.neb.valid[vnSbr]:=true;
             Emptyrec.neb.valid[vnDim1]:=true;
             Emptyrec.neb.valid[vnDim2]:=true;
             Emptyrec.neb.valid[vnPa]:=true;
             Emptyrec.neb.valid[vnNebtype]:=true;
             Emptyrec.neb.valid[vnMorph]:=true;
             Emptyrec.neb.valid[vnComment]:=true;
             EmptyRec.options.altname[1]:=true;
             EmptyRec.vstr[1]:=true;
             EmptyRec.vstr[2]:=true;
             EmptyRec.options.flabel[16]:='Name';
             EmptyRec.options.flabel[17]:='Const';
             end;
   ngc     : begin
             EmptyRec.options.flabel:=NebLabel;
             EmptyRec.options.ShortName:='NGC';
             EmptyRec.options.LongName:='New General Catalog';
             EmptyRec.options.rectype:=rtNeb;
             EmptyRec.options.Equinox:=2000;
             EmptyRec.options.EquinoxJD:=jd2000;
             EmptyRec.options.MagMax:=12;
             EmptyRec.options.UsePrefix:=0;
             EmptyRec.options.Units:=60;
             EmptyRec.options.LogSize:=0;
             EmptyRec.options.ObjType:=-1;
             Emptyrec.neb.valid[vnId]:=true;
             Emptyrec.neb.valid[vnMag]:=true;
             Emptyrec.neb.valid[vnSbr]:=true;
             Emptyrec.neb.valid[vnDim1]:=true;
             Emptyrec.neb.valid[vnNebtype]:=true;
             Emptyrec.neb.valid[vnComment]:=true;
             EmptyRec.vstr[1]:=true;
             EmptyRec.options.flabel[16]:='Const';
             end;
   lbn     : begin
             EmptyRec.options.flabel:=NebLabel;
             EmptyRec.options.ShortName:='LBN';
             EmptyRec.options.LongName:='Lynds Catalogue of Bright Nebulae';
             EmptyRec.options.rectype:=rtNeb;
             EmptyRec.options.Equinox:=2000;
             EmptyRec.options.EquinoxJD:=jd2000;
             EmptyRec.options.MagMax:=12;
             EmptyRec.options.UsePrefix:=0;
             EmptyRec.options.Units:=60;
             EmptyRec.options.LogSize:=0;
             EmptyRec.options.ObjType:=5;
             Emptyrec.neb.valid[vnId]:=true;
             Emptyrec.neb.valid[vnMag]:=true;
             Emptyrec.neb.valid[vnSbr]:=true;
             Emptyrec.neb.valid[vnDim1]:=true;
             Emptyrec.neb.valid[vnDim2]:=true;
             EmptyRec.options.altname[1]:=true;
             EmptyRec.vstr[1]:=true;
             EmptyRec.options.flabel[16]:='LBN';
             EmptyRec.vnum[1]:=true;
             EmptyRec.vnum[2]:=true;
             EmptyRec.vnum[3]:=true;
             EmptyRec.vnum[4]:=true;
             EmptyRec.options.flabel[26]:='Region';
             EmptyRec.options.flabel[27]:='Bright';
             EmptyRec.options.flabel[28]:='Color';
             EmptyRec.options.flabel[29]:='Area';
             end;
   rc3     : begin
             EmptyRec.options.flabel:=NebLabel;
             EmptyRec.options.ShortName:='RC3';
             EmptyRec.options.LongName:='Third Reference Cat. of Bright Galaxies';
             EmptyRec.options.rectype:=rtNeb;
             EmptyRec.options.Equinox:=2000;
             EmptyRec.options.EquinoxJD:=jd2000;
             EmptyRec.options.MagMax:=12;
             EmptyRec.options.UsePrefix:=0;
             EmptyRec.options.Units:=60;
             EmptyRec.options.LogSize:=0;
             EmptyRec.options.ObjType:=1;
             Emptyrec.neb.valid[vnId]:=true;
             Emptyrec.neb.valid[vnMag]:=true;
             Emptyrec.neb.valid[vnSbr]:=true;
             Emptyrec.neb.valid[vnDim1]:=true;
             Emptyrec.neb.valid[vnDim2]:=true;
             Emptyrec.neb.valid[vnPA]:=true;
             Emptyrec.neb.valid[vnRV]:=true;
             Emptyrec.neb.valid[vnMorph]:=true;
             EmptyRec.options.altname[1]:=true;
             EmptyRec.vstr[1]:=true;
             EmptyRec.options.flabel[16]:='PGC';
             EmptyRec.vnum[1]:=true;
             EmptyRec.vnum[2]:=true;
             EmptyRec.vnum[3]:=true;
             EmptyRec.vnum[4]:=true;
             EmptyRec.vnum[5]:=true;
             EmptyRec.options.flabel[26]:='Aperture';
             EmptyRec.options.flabel[27]:='B-V';
             EmptyRec.options.flabel[28]:='App.B-V';
             EmptyRec.options.flabel[29]:='Stage';
             EmptyRec.options.flabel[30]:='Luminosity';
             end;
   pgc     : begin
             EmptyRec.options.flabel:=NebLabel;
             EmptyRec.options.ShortName:='PGC';
             EmptyRec.options.LongName:='HyperLeda Database for physics of galaxies';
             EmptyRec.options.rectype:=rtNeb;
             EmptyRec.options.Equinox:=2000;
             EmptyRec.options.EquinoxJD:=jd2000;
             EmptyRec.options.MagMax:=12;
             EmptyRec.options.UsePrefix:=0;
             EmptyRec.options.Units:=60;
             EmptyRec.options.LogSize:=0;
             EmptyRec.options.ObjType:=1;
             Emptyrec.neb.valid[vnId]:=true;
             Emptyrec.neb.valid[vnMag]:=true;
             Emptyrec.neb.valid[vnSbr]:=false;
             Emptyrec.neb.valid[vnDim1]:=true;
             Emptyrec.neb.valid[vnDim2]:=true;
             Emptyrec.neb.valid[vnPA]:=true;
             Emptyrec.neb.valid[vnRV]:=true;
             EmptyRec.options.altname[1]:=true;
             EmptyRec.vstr[1]:=true;
             EmptyRec.options.flabel[16]:='PGC';
             end;
   ocl     : begin
             EmptyRec.options.flabel:=NebLabel;
             EmptyRec.options.ShortName:='OCL';
             EmptyRec.options.LongName:='Open Cluster Data 5th Edition';
             EmptyRec.options.rectype:=rtNeb;
             EmptyRec.options.Equinox:=2000;
             EmptyRec.options.EquinoxJD:=jd2000;
             EmptyRec.options.MagMax:=12;
             EmptyRec.options.UsePrefix:=0;
             EmptyRec.options.Units:=60;
             EmptyRec.options.LogSize:=0;
             EmptyRec.options.ObjType:=2;
             Emptyrec.neb.valid[vnId]:=true;
             Emptyrec.neb.valid[vnMag]:=true;
             Emptyrec.neb.valid[vnDim1]:=true;
             Emptyrec.neb.valid[vnMorph]:=true;
             EmptyRec.options.altname[1]:=true;
             EmptyRec.vstr[1]:=true;
             EmptyRec.options.flabel[16]:='OCL';
             EmptyRec.vnum[1]:=true;
             EmptyRec.vnum[2]:=true;
             EmptyRec.vnum[3]:=true;
             EmptyRec.vnum[4]:=true;
             EmptyRec.vnum[5]:=true;
             EmptyRec.options.flabel[26]:='Dist';
             EmptyRec.options.flabel[27]:='Age';
             EmptyRec.options.flabel[28]:='B-V';
             EmptyRec.options.flabel[29]:='Star-Num.';
             EmptyRec.options.flabel[30]:='Star-Mag.';
             end;
   gcm     : begin
             EmptyRec.options.flabel:=NebLabel;
             EmptyRec.options.ShortName:='GCM';
             EmptyRec.options.LongName:='Globular Clusters in the Milky Way';
             EmptyRec.options.rectype:=rtNeb;
             EmptyRec.options.Equinox:=2000;
             EmptyRec.options.EquinoxJD:=jd2000;
             EmptyRec.options.MagMax:=12;
             EmptyRec.options.UsePrefix:=0;
             EmptyRec.options.Units:=60;
             EmptyRec.options.LogSize:=0;
             EmptyRec.options.ObjType:=3;
             Emptyrec.neb.valid[vnId]:=true;
             Emptyrec.neb.valid[vnMag]:=true;
             Emptyrec.neb.valid[vnDim1]:=true;
             EmptyRec.options.altname[1]:=true;
             EmptyRec.vstr[1]:=true;
             EmptyRec.vstr[2]:=true;
             EmptyRec.options.flabel[16]:='GCM';
             EmptyRec.options.flabel[17]:='Sp';
             EmptyRec.vnum[1]:=true;
             EmptyRec.vnum[2]:=true;
             EmptyRec.vnum[3]:=true;
             EmptyRec.vnum[4]:=true;
             EmptyRec.vnum[5]:=true;
             EmptyRec.options.flabel[26]:='B-V';
             EmptyRec.options.flabel[27]:='Central-Sbr';
             EmptyRec.options.flabel[28]:='Nucleus';
             EmptyRec.options.flabel[29]:='Half-Mass';
             EmptyRec.options.flabel[30]:='Dist';
             end;
   gpn     : begin
             EmptyRec.options.flabel:=NebLabel;
             EmptyRec.options.ShortName:='GPN';
             EmptyRec.options.LongName:='Strasbourg-ESO Catalogue of Galactic Planetary Nebulae';
             EmptyRec.options.rectype:=rtNeb;
             EmptyRec.options.Equinox:=2000;
             EmptyRec.options.EquinoxJD:=jd2000;
             EmptyRec.options.MagMax:=12;
             EmptyRec.options.UsePrefix:=0;
             EmptyRec.options.Units:=3600;
             EmptyRec.options.LogSize:=0;
             EmptyRec.options.ObjType:=4;
             Emptyrec.neb.valid[vnId]:=true;
             Emptyrec.neb.valid[vnMag]:=true;
             Emptyrec.neb.valid[vnDim1]:=true;
             EmptyRec.options.altname[1]:=true;
             EmptyRec.options.altname[2]:=true;
             EmptyRec.vstr[1]:=true;
             EmptyRec.vstr[2]:=true;
             EmptyRec.options.flabel[16]:='PK';
             EmptyRec.options.flabel[17]:='PNG';
             EmptyRec.vnum[1]:=true;
             EmptyRec.vnum[2]:=true;
             EmptyRec.vnum[3]:=true;
             EmptyRec.options.flabel[26]:='Mag. Hb';
             EmptyRec.options.flabel[27]:='C.Star_V';
             EmptyRec.options.flabel[28]:='C.Star_B';
             end;
   else result:=false;
  end;
end;

{ catalog read functions }

function Tcatalog.NewGCat:boolean;
var GcatH : TCatHeader;
    v : integer;
begin
repeat
   inc(CurGCat);
   if CurGCat>cfgcat.GCatNum then begin
      result:=false;
      exit;
   end;
   if cfgcat.GCatLst[CurGCat-1].CatOn then begin
     SetGcatPath(cfgcat.GCatLst[CurGCat-1].path,cfgcat.GCatLst[CurGCat-1].shortname);
     GetGCatInfo(GcatH,v,GCatFilter,result);
   end else
     result:=false;
until result and (v=VerGCat);
end;

function Tcatalog.GetInfo(path,shortname:string; var magmax:single;var v:integer; var version,longname:string):boolean;
var GcatH : TCatHeader;
begin
SetGcatPath(path,shortname);
GetGCatInfo(GcatH,v,GCatFilter,result);
magmax:=GcatH.MagMax;
version:=GcatH.version;
longname:=GcatH.LongName;
end;

function Tcatalog.GetMaxField(path,cat: string):string;
var GCatH : TCatHeader;
    v : integer;
    ok : boolean;
begin
SetGcatPath(path,cat);
GetGCatInfo(GcatH,v,GCatFilter,ok);
case GcatH.FileNum of
  1    : result:='10';
  50   : result:='10';
  184  : result:='7';
  732  : result:='5';
  9537 : result:='3';
  else   result:='7';
end;
end;

function Tcatalog.GetCatType(path,cat: string):integer;
var GCatH : TCatHeader;
    v : integer;
    ok : boolean;
begin
SetGcatPath(path,cat);
GetGCatInfo(GcatH,v,GCatFilter,ok);
if ok then result:=v
   else result:=-1;
end;

function Tcatalog.GetVOstarmag: double;
begin
SetVOCatpath(slash(VODir));
result:=GetVOMagmax;
end;

function Tcatalog.GetVOCatS(var rec:GcatRec):boolean;
begin
repeat
  ReadVOCat(rec,result);
  if not result then break;
  if cfgshr.StarFilter and (rec.star.magv>cfgcat.StarMagMax) then continue;
  break;
until not result;
end;

function Tcatalog.GetVOCatN(var rec:GcatRec):boolean;
begin
repeat
  ReadVOCat(rec,result);
  if not result then break;
  if not rec.neb.valid[vnMag] then rec.neb.mag:=rec.options.MagMax;

  if cfgshr.NebFilter and
     rec.neb.valid[vnMag] and
    (rec.neb.mag>cfgcat.NebMagMax) then continue;
  if not rec.neb.valid[vnNebunit] then rec.neb.nebunit:=rec.options.Units;
  if not rec.neb.valid[vnDim1] then rec.neb.dim1:=rec.options.Size;
  if cfgshr.NebFilter and
     (rec.neb.dim1*60/rec.neb.nebunit<cfgcat.NebSizeMin) then continue;
  if not rec.neb.valid[vnNebtype] then rec.neb.nebtype:=rec.options.ObjType;
  if cfgshr.NebFilter and cfgshr.BigNebFilter and (rec.neb.dim1*60/rec.neb.nebunit>=cfgshr.BigNebLimit) and (rec.neb.nebtype<>1) then continue; // filter big object except M31, LMC, SMC
  break;
until not result;
end;

function Tcatalog.GetUObjN(var rec:GcatRec):boolean;
begin
result:=false;
inc(CurrentUserObj);
fillchar(Rec,sizeof(GcatRec),0);
if CurrentUserObj>=Length(cfgcat.UserObjects) then exit;
if cfgcat.UserObjects[CurrentUserObj].active then begin
rec.options.rectype:=rtneb;
rec.options.Equinox:=2000;
rec.options.EquinoxJD:=jd2000;
JDCatalog:=rec.options.EquinoxJD;
rec.options.Epoch:=2000;
rec.options.MagMax:=20;
rec.options.Size:=1;
rec.options.Units:=60;
rec.options.ObjType:=1;
rec.options.LogSize:=0;
rec.options.UsePrefix:=0;
if cfgcat.UserObjects[CurrentUserObj].color>0 then
   rec.options.UseColor:=1
else
   rec.options.UseColor:=0;
rec.options.ShortName:='UDO';
rec.options.LongName:=rsUserDefinedO;
rec.options.flabel[lOffset+vnMag]:='Magn';
rec.options.flabel[lOffset+vnDim1]:='Size';
rec.options.flabel[lOffset+vsComment]:='Desc';
rec.neb.valid[vnId]:=true;
rec.neb.valid[vnNebtype]:=true;
rec.neb.valid[vnMag]:=true;
rec.neb.valid[vnDim1]:=true;
rec.neb.valid[vnComment]:=true;
rec.neb.id:=cfgcat.UserObjects[CurrentUserObj].oname;
rec.neb.nebtype:=cfgcat.UserObjects[CurrentUserObj].otype;
rec.neb.color:=cfgcat.UserObjects[CurrentUserObj].color;
rec.neb.mag:=cfgcat.UserObjects[CurrentUserObj].mag;
rec.neb.dim1:=cfgcat.UserObjects[CurrentUserObj].size;
rec.neb.comment:=cfgcat.UserObjects[CurrentUserObj].comment;
rec.ra:=cfgcat.UserObjects[CurrentUserObj].ra;
rec.dec:=cfgcat.UserObjects[CurrentUserObj].dec;
result:=true;
end else begin
   result:=GetUObjN(rec);
end;
end;

procedure Tcatalog.FormatGCatS(var rec:GcatRec);
var bsccat, flam, bayer : boolean;
    i: integer;
begin
rec.ra:=deg2rad*rec.ra;
rec.dec:=deg2rad*rec.dec;
rec.star.pmra:=deg2rad*rec.star.pmra/3600;
rec.star.pmdec:=deg2rad*rec.star.pmdec/3600;
rec.star.valid[vsGreekSymbol]:=false;
bsccat:=(rec.vstr[3] and (trim(rec.options.flabel[lOffsetStr+3])='CommonName'))and
        (rec.vstr[4] and (trim(rec.options.flabel[lOffsetStr+4])='Fl'))and
        (rec.vstr[5] and (trim(rec.options.flabel[lOffsetStr+5])='Bayer'))and
        (rec.vstr[6] and (trim(rec.options.flabel[lOffsetStr+6])='Const'));
if bsccat then begin
    for i:=1 to 10 do begin  // remove fields used only for index
       if UpperCase(trim(rec.options.flabel[lOffsetStr+i]))='NA' then rec.vstr[i]:=false;
    end;
    flam:=(trim(rec.str[4])<>'');
    rec.vstr[4]:=flam;
    bayer:=(trim(rec.str[5])<>'');
    if trim(rec.str[5])='H02' then begin
       rec.vstr[5]:=bayer;
    end;
    rec.vstr[5]:=bayer;
    if bayer then begin
        rec.star.greeksymbol:=GreekLetter(rec.str[5]);
        if rec.star.greeksymbol<>'' then rec.star.valid[vsGreekSymbol]:=true
           else bayer:=false;
    end;
    if (not bayer) and flam  then begin
        rec.star.greeksymbol:=trim(rec.str[4]);
        if rec.star.greeksymbol<>'' then rec.star.valid[vsGreekSymbol]:=true
           else flam:=false;
    end;
    rec.options.flabel[lOffsetStr+3]:=rsCommonName;
    rec.vstr[3]:=(trim(rec.str[3])<>'');
    if flam and (not bayer) then rec.star.id:=copy(trim(rec.str[4])+blank15,1,3) else rec.star.id:='';
    if bayer or flam  then begin
      rec.star.id:=rec.star.id+blank+trim(rec.str[5])+blank+trim(rec.str[6]);
      rec.star.valid[vsId]:=true;
    end;
end;
end;

function Tcatalog.GetGCatS(var rec:GcatRec):boolean;
begin
result:=true;
repeat
  ReadGCat(rec,result);
  if not result then break;
  if cfgshr.StarFilter and (rec.star.magv>cfgcat.StarMagMax) then begin
             if GCatFilter then NextGCat(result);
             if result then continue;
  end;
  FormatGCatS(rec);
  break;
until not result;
end;

function Tcatalog.GetGCatV(var rec:GcatRec):boolean;
begin
result:=true;
repeat
  ReadGCat(rec,result);
  if not result then break;
  if cfgshr.StarFilter and (rec.variable.magmax>cfgcat.StarMagMax) then begin
             if GCatFilter then NextGCat(result);
             if result then continue;
  end;
  rec.ra:=deg2rad*rec.ra;
  rec.dec:=deg2rad*rec.dec;
  break;
until not result;
end;

function Tcatalog.GetGCatD(var rec:GcatRec):boolean;
begin
result:=true;
repeat
  ReadGCat(rec,result);
  if not result then break;
  if cfgshr.StarFilter and (rec.double.mag1>cfgcat.StarMagMax) then begin
             if GCatFilter then NextGCat(result);
             if result then continue;
  end;
  rec.ra:=deg2rad*rec.ra;
  rec.dec:=deg2rad*rec.dec;
  break;
until not result;
end;

function Tcatalog.GetGCatN(var rec:GcatRec):boolean;
begin
result:=true;
repeat
  ReadGCat(rec,result);
  if not result then break;
  if cfgshr.NebFilter and
     rec.neb.valid[vnMag] and
    (rec.neb.mag>cfgcat.NebMagMax) then begin
             if GCatFilter then NextGCat(result);
             if result then continue;
  end;
  if not rec.neb.valid[vnNebunit] then rec.neb.nebunit:=rec.options.Units;
  if not rec.neb.valid[vnDim1] then rec.neb.dim1:=rec.options.Size;
  if cfgshr.NebFilter and
     rec.neb.valid[vnDim1] and
     (rec.neb.dim1*60/rec.neb.nebunit<cfgcat.NebSizeMin) then continue;
  if not rec.neb.valid[vnNebtype] then rec.neb.nebtype:=rec.options.ObjType;
  if cfgshr.NebFilter and cfgshr.BigNebFilter and (rec.neb.dim1*60/rec.neb.nebunit>=cfgshr.BigNebLimit) and (rec.neb.nebtype<>1) then continue; // filter big object except M31, LMC, SMC
  rec.ra:=deg2rad*rec.ra;
  rec.dec:=deg2rad*rec.dec;
  if cfgcat.GCatLst[CurGCat-1].ForceColor then begin
    rec.options.UseColor:=1;
    rec.neb.color:=cfgcat.GCatLst[CurGCat-1].col;
  end;
  break;
until not result;
end;

function Tcatalog.GetGCatL(var rec:GcatRec):boolean;
begin
result:=true;
repeat
  ReadGCat(rec,result);
  if not result then break;
  // no line filter at the moment
  rec.ra:=deg2rad*rec.ra;
  rec.dec:=deg2rad*rec.dec;
  if cfgcat.GCatLst[CurGCat-1].ForceColor then begin
    rec.outlines.valid[vlLinecolor]:=true;
    rec.outlines.linecolor:=cfgcat.GCatLst[CurGCat-1].col;
  end;
  break;
until not result;
end;

procedure Tcatalog.FindNGCat(id:shortstring; var ar,de:double ; var ok:boolean; ctype:integer=-1);
var
   H : TCatHeader;
   rec:GCatrec;
   i,version : integer;
   iid:string;
   catok: boolean;
begin
ok:=false;
iid:=id;
for i:=0 to cfgcat.GCatNum-1 do begin
  if ((ctype=-1)or(cfgcat.GCatLst[i].cattype=ctype)) then begin
   SetGcatPath(cfgcat.GCatLst[i].path,cfgcat.GCatLst[i].shortname);
   GetGCatInfo(H,version,GCatFilter,catok);
   if catok and fileexists(slash(cfgcat.GCatLst[i].path)+cfgcat.GCatLst[i].shortname+'.ixr') then begin
     FindNumGcatRec(cfgcat.GCatLst[i].path,cfgcat.GCatLst[i].shortname,iid,H.ixkeylen,rec,ok);
     if ok then begin
        ar:=rec.ra/15;
        de:=rec.dec;
        FormatGCatS(rec);
        FFindId:=id;
        FFindRecOK:=true;
        FFindRec:=rec;
        break;
     end;
   end
   else if catok and fileexists(slash(cfgcat.GCatLst[i].path)+cfgcat.GCatLst[i].shortname+'.idx') then begin
      FindNumGcat(cfgcat.GCatLst[i].path,cfgcat.GCatLst[i].shortname,iid,H.ixkeylen, ar,de,ok);
      if ok then break;
    end;
  end;
end;
end;

function Tcatalog.GetBSC(var rec:GcatRec):boolean;
var lin : BSCrec;
    i: integer;
begin
rec:=EmptyRec;
result:=true;
repeat
  ReadBSC(lin,result);
  if not result then break;
  rec.star.magv:=lin.mv/100;
  if cfgshr.StarFilter and (rec.star.magv>cfgcat.StarMagMax) then begin
     NextBSC(result);
     if result then continue;
  end;
  break;
until not result;
if result then begin
   rec.ra:=deg2rad*lin.ar/100000;
   rec.dec:=deg2rad*lin.de/100000;
   rec.star.b_v:=lin.b_v/100;
   rec.star.pmra:=deg2rad*lin.pmar/1000/3600;  // mas -> rad
   rec.star.pmdec:=deg2rad*lin.pmde/1000/3600;
   rec.star.sp:=lin.sp;
   if (lin.flam>0)and(trim(lin.bayer)='') then rec.star.id:=copy(inttostr(lin.flam)+blank15,1,3) else rec.star.id:='';
   rec.star.id:=rec.star.id+blank+ lin.bayer+blank+lin.cons;
   rec.str[1]:=inttostr(lin.bs);
   if lin.hd>0 then rec.str[2]:=inttostr(lin.hd) else rec.str[2]:='';
   if trim(lin.bayer)<>'' then begin
      rec.star.greeksymbol:=GreekLetter(lin.bayer);
      rec.star.valid[vsGreekSymbol]:=true;
   end else if lin.flam>0 then begin
      rec.star.greeksymbol:=inttostr(lin.flam);
      rec.star.valid[vsGreekSymbol]:=true;
   end;
   rec.str[3]:='';
   for i:=0 to cfgshr.StarNameNum-1 do begin
     if cfgshr.StarNameHR[i]=lin.bs then begin rec.str[3]:=cfgshr.StarName[i]; rec.vstr[3]:=true; break;end;
   end;
   i:=pos(';',rec.str[3]);
   if i>0 then rec.str[3]:=copy(rec.str[3],1,i-1);
   if lin.flam>0 then begin rec.str[4]:=inttostr(lin.flam); rec.vstr[4]:=true; end;
   if trim(lin.bayer)<>'' then begin rec.str[5]:=trim(lin.bayer); rec.vstr[5]:=true; end;
end;
end;

function Tcatalog.GetSky2000(var rec:GcatRec):boolean;
var
   lin : SKYrec;
   n,s :string;
   p: integer;
begin
rec:=EmptyRec;
result:=true;
repeat
  ReadSKY(lin,result);
  if not result then break;
  rec.star.magv:=lin.mv/100;
  if cfgshr.StarFilter and (rec.star.magv>cfgcat.StarMagMax) then begin
     NextSKY(result);
     if result then continue;
  end;
  break;
until not result;
if result then begin
   rec.ra:=deg2rad*lin.ar/100000;
   rec.dec:=deg2rad*lin.de/100000;
   rec.star.b_v:=lin.b_v/100;
   rec.star.pmra:=deg2rad*lin.pmar/1000/3600;
   rec.star.pmdec:=deg2rad*lin.pmde/1000/3600;
   rec.star.sp:=lin.sp;
   if lin.dm<>0 then begin
     if lin.dm>=0 then s:='+' else s:='-';
     n:=inttostr(abs(lin.dm));
     p:=length(n)-4;
     if p>0 then n:=s+copy(n,1,p-1)+'.'+copy(n,p,p+5)
            else n:=s+'0.'+padzeros(n,5);
     n:=blank+lin.dm_cat+n;
   end
   else n:='';
   rec.star.id:=n;
   if lin.sep>0 then begin
     rec.num[1]:=lin.sep/100;
     rec.num[2]:=lin.d_m/100;
   end else begin
     rec.num[1]:=0;
     rec.num[2]:=0;
     rec.vnum[1]:=false;
     rec.vnum[2]:=false;
   end;
   if lin.hd>0 then rec.str[1]:=inttostr(lin.hd) else rec.str[1]:='';
   if lin.sao>0 then rec.str[2]:=inttostr(lin.sao) else rec.str[2]:='';
end;
end;

function Tcatalog.GetTYC(var rec:GcatRec):boolean;
var lin : TYCrec;
   smnum : string;
begin
rec:=EmptyRec;
result:=true;
repeat
  ReadTYC(lin,smnum,result);
  if not result then break;
  rec.star.magv:=lin.vt/100;
  if rec.star.magv=99 then rec.star.magv:=lin.bt/100;
  if cfgshr.StarFilter and (rec.star.magv>cfgcat.StarMagMax) then begin
     NextTYC(result);
     if result then continue;
  end;
  break;
until not result;
if result then begin
   rec.ra:=deg2rad*lin.ar/100000;
   rec.dec:=deg2rad*lin.de/100000;
   rec.star.magb:=lin.bt/100;
   rec.star.b_v:=lin.b_v/100;
   rec.star.pmra:=deg2rad*lin.pmar/1000/3600;
   rec.star.pmdec:=deg2rad*lin.pmde/1000/3600;
   rec.star.id:=inttostr(lin.gscz)+'-'+inttostr(lin.gscn)+'-'+inttostr(lin.tycn);
end;
end;

procedure Tcatalog.FormatTYC2(lin : TY2rec; var rec:GcatRec);
begin
rec.ra:=deg2rad*lin.ar;
rec.dec:=deg2rad*lin.de;
rec.star.magv:=lin.vt;
if rec.star.magv>30 then rec.star.magv:=lin.bt;
rec.star.magb:=lin.bt;
if (lin.vt<30)and(lin.bt<30) then rec.star.b_v:=0.850*(lin.bt-lin.vt)
                             else rec.star.b_v:=0;
rec.star.pmra:=deg2rad*lin.pmar/1000/3600;
rec.star.pmdec:=deg2rad*lin.pmde/1000/3600;
rec.star.id:=inttostr(lin.gscz)+'-'+inttostr(lin.gscn)+'-'+inttostr(lin.tycn);
end;

function Tcatalog.GetTYC2(var rec:GcatRec):boolean;
var lin : TY2rec;
   smnum : string;
   ma:  double;
begin
rec:=EmptyRec;
result:=true;
repeat
  ReadTY2(lin,smnum,result);
  if not result then break;
  ma:=lin.vt;
  if ma>30 then ma:=lin.bt;
  if cfgshr.StarFilter and (ma>cfgcat.StarMagMax) then continue;
  break;
until not result;
if result then begin
   FormatTYC2(lin,rec);
end;
end;

procedure Tcatalog.FindTYC2(id: string; var ra,dec: double; var ok:boolean);
var lin: TY2rec;
    rec: GCatrec;
begin
InitRec(tyc2);
rec:=EmptyRec;
FindNumTYC2(id,lin,ok);
if ok then begin
   FormatTYC2(lin,rec);
   ra:=rad2deg*rec.ra/15;
   dec:=rad2deg*rec.dec;
   FFindId:='TYC '+trim(id);
   FFindRecOK:=true;
   FFindRec:=rec;
end;
end;

function Tcatalog.GetTIC(var rec:GcatRec):boolean;
var lin : TICrec;
    smnum : string;
begin
rec:=EmptyRec;
result:=true;
repeat
  ReadTIC(lin,smnum,result);
  if not result then break;
  rec.star.magv:=lin.mv/100;
  if lin.mb>=10000 then begin
     rec.num[1]:=1;
     rec.star.magb:=(lin.mb-10000)/100
  end else begin
     rec.num[1]:=0;
     rec.star.magb:=lin.mb/100;
  end;
  if rec.star.magv>90 then rec.star.magv:=rec.star.magb;
  if cfgshr.StarFilter and (rec.star.magv>cfgcat.StarMagMax) then begin
     NextTIC(result);
     if result then continue;
  end;
  break;
until not result;
if result then begin
   rec.ra:=deg2rad*lin.ar/100000;
   rec.dec:=deg2rad*lin.de/100000;
   if (rec.star.magv<90) and (rec.star.magb<90) then rec.star.b_v:=rec.star.magb-rec.star.magv
                         else rec.star.b_v:=99;
   rec.star.id:=inttostr(lin.gscz)+'-'+inttostr(lin.gscn);
end;
end;

function Tcatalog.GetGSCF(var rec:GcatRec):boolean;
var lin : GSCFrec;
    smnum : string;
begin
rec:=EmptyRec;
result:=true;
repeat
  ReadGSCF(lin,smnum,result);
  if not result then break;
  rec.star.magv:=lin.m;
  if cfgshr.StarFilter and (rec.star.magv>cfgcat.StarMagMax) then continue;
  break;
until not result;
if result then begin
   rec.ra:=deg2rad*lin.ar;
   rec.dec:=deg2rad*lin.de;
   rec.star.id:=smnum+'-'+inttostr(lin.gscn);
   rec.num[1]:=lin.pe;
   rec.num[2]:=lin.me;
   rec.str[1]:=inttostr(lin.mb);
   rec.str[2]:=inttostr(lin.cl);
   rec.str[3]:=lin.mult;
   rec.str[4]:=lin.plate;
end;
end;

function Tcatalog.GetGSCC(var rec:GcatRec):boolean;
var lin : GSCCrec;
    smnum : string;
begin
rec:=EmptyRec;
result:=true;
repeat
  ReadGSCC(lin,smnum,result);
  if not result then break;
  rec.star.magv:=lin.m;
  if cfgshr.StarFilter and (rec.star.magv>cfgcat.StarMagMax) then continue;
  break;
until not result;
if result then begin
   rec.ra:=deg2rad*lin.ar;
   rec.dec:=deg2rad*lin.de;
   rec.star.id:=smnum+'-'+inttostr(lin.gscn);
   rec.num[1]:=lin.pe;
   rec.num[2]:=lin.me;
   rec.str[1]:=inttostr(lin.mb);
   rec.str[2]:=inttostr(lin.cl);
   rec.str[3]:=lin.mult;
   rec.str[4]:=lin.plate;
end;
end;

function Tcatalog.GetGSC(var rec:GcatRec):boolean;
var lin : GSCrec;
    smnum : string;
begin
rec:=EmptyRec;
result:=true;
repeat
  ReadGSC(lin,smnum,result);
  if not result then break;
  rec.star.magv:=lin.m/100;
  if cfgshr.StarFilter and (rec.star.magv>cfgcat.StarMagMax) then begin
     NextGSC(result);
     if result then continue;
  end;
  break;
until not result;
if result then begin
   rec.ra:=deg2rad*lin.ar/100000;
   rec.dec:=deg2rad*lin.de/100000;
   rec.star.id:=smnum+'-'+inttostr(lin.gscn);
   rec.num[1]:=lin.pe;
   rec.num[2]:=lin.me;
   rec.str[1]:=inttostr(lin.mb);
   rec.str[2]:=inttostr(lin.cl);
   rec.str[3]:=lin.mult;
end;
end;

function Tcatalog.GetUSNOA(var rec:GcatRec):boolean;
var lin : USNOArec;
begin
rec:=EmptyRec;
result:=true;
repeat
  ReadUSNOA(lin,result);
  if not result then break;
  rec.star.magv:=lin.mr;
  if cfgshr.StarFilter and (rec.star.magv>cfgcat.StarMagMax) then continue;
  if (not cfgcat.UseUSNOBrightStars) and (rec.star.magv<5) then continue;
  break;
until not result;
if result then begin
   rec.ra:=deg2rad*lin.ar*15;
   rec.dec:=deg2rad*lin.de;
   if lin.mr>25 then lin.mr:=lin.mb;
   if (lin.mb>25)or(lin.mb=0) then lin.mb:=lin.mr;
   rec.star.magv:=lin.mr;
   rec.star.magb:=lin.mb;
   rec.star.b_v:=rec.star.magb-(rec.star.magb+rec.star.magv)/2;  // usno-a2.0
   rec.star.id:=lin.id;
   rec.str[1]:=inttostr(lin.field);
   rec.str[2]:=inttostr(lin.q);
   rec.str[3]:=inttostr(lin.s);
end;
end;

function Tcatalog.GetMCT(var rec:GcatRec):boolean;
var lin : MCTrec;
begin
rec:=EmptyRec;
result:=true;
repeat
  ReadMCT(lin,result);
  if not result then break;
  rec.star.magv:=lin.mr;
  if cfgshr.StarFilter and (rec.star.magv>cfgcat.StarMagMax) then continue;
  break;
until not result;
if result then begin
   rec.ra:=deg2rad*lin.ar*15;
   rec.dec:=deg2rad*lin.de;
   rec.star.magb:=lin.mb;
   rec.star.b_v:=lin.mb-(lin.mb+lin.mr)/2;
   rec.star.id:='';
end;
end;

function Tcatalog.GetDSbase(var rec:GcatRec):boolean;
var lin : DSrec;
begin
rec:=EmptyRec;
result:=true;
repeat
  ReadDSbase(lin,result);
  if not result then break;
  rec.star.magv:=lin.mag;
  if cfgshr.StarFilter and (rec.star.magv>cfgcat.StarMagMax) then continue;
  break;
until not result;
if result then begin
   rec.ra:=deg2rad*lin.ra*15;
   rec.dec:=deg2rad*lin.dec;
   rec.star.id:='';
end;
end;

function Tcatalog.GetDSTyc(var rec:GcatRec):boolean;
var lin : DSrec;
begin
rec:=EmptyRec;
result:=true;
repeat
  ReadDSTyc(lin,result);
  if not result then break;
  rec.star.magv:=lin.mag;
  if cfgshr.StarFilter and (rec.star.magv>cfgcat.StarMagMax) then begin
     NextDSTyc(result);
     if result then continue;
  end;
  break;
until not result;
if result then begin
   rec.ra:=deg2rad*lin.ra*15;
   rec.dec:=deg2rad*lin.dec;
   rec.star.id:='';
end;
end;

function Tcatalog.GetDSGsc(var rec:GcatRec):boolean;
var lin : DSrec;
begin
rec:=EmptyRec;
result:=true;
repeat
  ReadDSGsc(lin,result);
  if not result then break;
  rec.star.magv:=lin.mag;
  if cfgshr.StarFilter and (rec.star.magv>cfgcat.StarMagMax) then begin
     NextDSGsc(result);
     if result then continue;
  end;
  break;
until not result;
if result then begin
   rec.ra:=deg2rad*lin.ra*15;
   rec.dec:=deg2rad*lin.dec;
   rec.star.id:='';
end;
end;

procedure Tcatalog.FormatGCVS(lin: GCVrec; var rec: GcatRec);
begin
rec.ra:=deg2rad*lin.ar/100000;
rec.dec:=deg2rad*lin.de/100000;
rec.variable.magmin:=lin.min/100;
rec.variable.magmax:=lin.max/100;
rec.variable.id:=lin.gcvs;
str(lin.num:7,rec.str[1]);
if copy(lin.vartype,7,3)='NSV' then rec.str[1]:='NSV'+rec.str[1];
rec.variable.period:=lin.period;
rec.variable.vartype:=stringreplace(lin.vartype,':',blank,[rfReplaceAll]);
rec.variable.magcode:=lin.mcode;
rec.str[2]:=lin.lmin+blank+lin.lmax;
end;

function Tcatalog.GetGCVS(var rec:GcatRec):boolean;
var lin : GCVrec;
    ma: double;
begin
rec:=EmptyRec;
result:=true;
repeat
  ReadGCV(lin,result);
  if not result then break;
  ma:=lin.max/100;
  if cfgshr.StarFilter and (ma>cfgcat.StarMagMax) then continue;
  if (not cfgcat.UseGSVSIr) and (lin.mcode>='J')and(lin.mcode<='N') then continue;
  break;
until not result;
if result then begin
   FormatGCVS(lin,rec);
end;
end;

procedure Tcatalog.FindGCVS(id: string; var ra,dec: double; var ok:boolean);
var lin: GCVrec;
    rec: GCatrec;
begin
InitRec(gcvs);
rec:=EmptyRec;
FindNumGCVS(id,lin,ok);
if ok then begin
   FormatGCVS(lin,rec);
   ra:=rad2deg*rec.ra/15;
   dec:=rad2deg*rec.dec;
   FFindId:=id;
   FFindRecOK:=true;
   FFindRec:=rec;
end;
end;


procedure Tcatalog.FormatWDS(lin : WDSrec; var rec:GcatRec);
var n,s:string;
    p:integer;
begin
rec.ra:=deg2rad*lin.ar/100000;
rec.dec:=deg2rad*lin.de/100000;
if (lin.pa2<>-999) and (lin.sep2>0) then begin
   rec.double.epoch:=lin.date2;
   rec.double.pa:=lin.pa2;
   rec.double.sep:=lin.sep2/10;
   end
else begin
   rec.double.epoch:=lin.date1;
   rec.double.pa:=lin.pa1;
   rec.double.sep:=lin.sep1/10;
end;
rec.double.mag1:=lin.ma/100;
rec.double.mag2:=lin.mb/100;
rec.double.id:=lin.id;
rec.double.compname:=lin.comp;
rec.double.sp1:=lin.sp;
rec.double.comment:=lin.note;
if lin.dm<>0 then begin
  if lin.dm>=0 then s:='+' else s:='-';
  n:=inttostr(abs(lin.dm));
  p:=length(n)-4;
  if p>0 then n:=s+copy(n,1,p-1)+'.'+copy(n,p,p+5)
         else n:=s+'0.'+padzeros(n,5);
  rec.double.comment:=rec.double.comment+' BD'+n;
end;
end;

function Tcatalog.GetWDS(var rec:GcatRec):boolean;
var lin : WDSrec;
    ma:  double;
begin
rec:=EmptyRec;
result:=true;
repeat
  ReadWDS(lin,result);
  if not result then break;
  ma:=lin.ma/100;
  if cfgshr.StarFilter and (ma>cfgcat.StarMagMax) then continue;
  break;
until not result;
if result then begin
   FormatWDS(lin,rec);
end;
end;

procedure Tcatalog.FindWDS(id: string; var ra,dec: double; var ok:boolean);
var lin: WDSrec;
    rec: GCatrec;
begin
InitRec(wds);
rec:=EmptyRec;
FindNumWDS(id,lin,ok);
if ok then begin
   FormatWDS(lin,rec);
   ra:=rad2deg*rec.ra/15;
   dec:=rad2deg*rec.dec;
   FFindId:=id;
   FFindRecOK:=true;
   FFindRec:=rec;
end;
end;

procedure Tcatalog.FormatSAC(lin : SACrec; var rec:GcatRec);
begin
rec.ra:=deg2rad*lin.ar;
rec.dec:=deg2rad*lin.de;
rec.neb.messierobject:=(copy(lin.nom1,1,2)='M ');
rec.neb.dim1:=lin.s1;
rec.neb.mag:=lin.ma;
if trim(lin.typ)='Drk' then rec.neb.mag:=11;
rec.neb.nebtype:=-1;
if trim(lin.typ)='Gx'  then rec.neb.nebtype:=1
else if trim(lin.typ)='OC'  then rec.neb.nebtype:=2
else if trim(lin.typ)='Gb'  then rec.neb.nebtype:=3
else if trim(lin.typ)='Pl'  then rec.neb.nebtype:=4
else if trim(lin.typ)='Nb'  then rec.neb.nebtype:=5
else if trim(lin.typ)='C+N'  then rec.neb.nebtype:=6
else if trim(lin.typ)='*'  then rec.neb.nebtype:=7
else if trim(lin.typ)='D*'  then rec.neb.nebtype:=8
else if trim(lin.typ)='***'  then rec.neb.nebtype:=9
else if trim(lin.typ)='Ast'  then rec.neb.nebtype:=10
else if trim(lin.typ)='Kt'  then rec.neb.nebtype:=11
else if trim(lin.typ)='Gcl'  then rec.neb.nebtype:=12
else if trim(lin.typ)='Drk'  then rec.neb.nebtype:=13
else if trim(lin.typ)='?'  then rec.neb.nebtype:=0
else if lin.typ='   '  then rec.neb.nebtype:=0
else if trim(lin.typ)='-'  then rec.neb.nebtype:=-1
else if trim(lin.typ)='PD'  then rec.neb.nebtype:=-1;
if (rec.neb.mag>70)or(rec.neb.mag<-70) then rec.neb.mag:=99.9;    // undefined magnitude
rec.neb.dim2:=lin.s2;
if rec.neb.nebtype=4 then begin // arc second units for PN
   rec.neb.dim1:=rec.neb.dim1*60;
   rec.neb.dim2:=rec.neb.dim2*60;
   rec.neb.valid[vnNebunit]:=true;
   rec.neb.nebunit:=3600;
end;
if lin.pa=255 then rec.neb.pa:=90
              else rec.neb.pa:=lin.pa;
rec.neb.sbr:=lin.sbr;
rec.neb.id:=lin.nom1;
rec.str[1]:=lin.nom2;
rec.str[2]:=lin.cons;
rec.neb.morph:=lin.clas;
rec.neb.comment:=lin.desc;
end;

function Tcatalog.GetSAC(var rec:GcatRec):boolean;
var lin : SACrec;
    nebunit:integer;
begin
rec:=EmptyRec;
result:=true;
repeat
  ReadSAC(lin,result);
  if not result then break;
  rec.neb.messierobject:=(copy(lin.nom1,1,2)='M ');
  rec.neb.dim1:=lin.s1;
  if rec.neb.valid[vnNebunit] then nebunit:=rec.neb.nebunit
                              else nebunit:=rec.options.Units;
  if cfgshr.NebFilter and (not (cfgshr.NoFilterMessier and rec.neb.messierobject)) and ((rec.neb.dim1*60/nebunit)<cfgcat.NebSizeMin) then continue;
  rec.neb.mag:=lin.ma;
  if trim(lin.typ)='Drk' then rec.neb.mag:=11;  // also filter dark nebulae
  if cfgshr.NebFilter and (not (cfgshr.NoFilterMessier and rec.neb.messierobject)) and (rec.neb.mag>cfgcat.NebMagMax) then continue;
  if cfgshr.BigNebFilter and (rec.neb.dim1>=cfgshr.BigNebLimit) and (trim(lin.typ)<>'Gx') then continue; // filter big object (only open cluster)
  break;
until not result;
if result then begin
  FormatSAC(lin,rec);
end;
end;

procedure Tcatalog.FindSAC(id: string; var ra,dec: double; var ok:boolean);
var lin: SACrec;
    rec: GCatrec;
begin
InitRec(sac);
rec:=EmptyRec;
FindNumSAC(id,lin,ok);
if ok then begin
   FormatSAC(lin,rec);
   ra:=rad2deg*rec.ra/15;
   dec:=rad2deg*rec.dec;
   FFindId:=id;
   FFindRecOK:=true;
   FFindRec:=rec;
end;
end;

function Tcatalog.GetNGC(var rec:GcatRec):boolean;
var lin : NGCrec;
begin
rec:=EmptyRec;
result:=true;
repeat
  ReadNGC(lin,result);
  if not result then break;
  rec.neb.dim1:=lin.dim/10;
  if cfgshr.NebFilter and (rec.neb.dim1<cfgcat.NebSizeMin) then continue;
  rec.neb.mag:=lin.ma/100;
  if cfgshr.NebFilter and (rec.neb.mag>cfgcat.NebMagMax) then continue;
  if cfgshr.BigNebFilter and (rec.neb.dim1>=cfgshr.BigNebLimit) and (trim(lin.typ)<>'Gx') then continue; // filter big object except M31, LMC, SMC
  break;
until not result;
if result then begin
   rec.ra:=deg2rad*lin.ar/100000;
   rec.dec:=deg2rad*lin.de/100000;
   rec.neb.nebtype:=-1;
   if trim(lin.typ)='Gx'  then rec.neb.nebtype:=1
   else if trim(lin.typ)='OC'  then rec.neb.nebtype:=2
   else if trim(lin.typ)='Gb'  then rec.neb.nebtype:=3
   else if trim(lin.typ)='Pl'  then rec.neb.nebtype:=4
   else if trim(lin.typ)='Nb'  then rec.neb.nebtype:=5
   else if trim(lin.typ)='C+N'  then rec.neb.nebtype:=6
   else if trim(lin.typ)='*'  then rec.neb.nebtype:=7
   else if trim(lin.typ)='D*'  then rec.neb.nebtype:=8
   else if trim(lin.typ)='***'  then rec.neb.nebtype:=9
   else if trim(lin.typ)='Ast'  then rec.neb.nebtype:=10
   else if trim(lin.typ)='Kt'  then rec.neb.nebtype:=11
   else if trim(lin.typ)='?'  then rec.neb.nebtype:=0
   else if lin.typ='   '  then rec.neb.nebtype:=0
   else if trim(lin.typ)='-'  then rec.neb.nebtype:=-1
   else if trim(lin.typ)='PD'  then rec.neb.nebtype:=-1;
   if rec.neb.dim1<=0 then rec.neb.dim1:=1;
   if (rec.neb.mag>70)or(rec.neb.mag<-70) then begin
     rec.neb.mag:=99.9;     // undefined magnitude
     rec.neb.sbr:=99.9;
   end else begin;
     rec.neb.sbr:= rec.neb.mag + 5*log10(rec.neb.dim1) - 0.26;
   end;
   str(lin.id:4,rec.neb.id);
   if lin.ic='I' then rec.neb.id:='IC '+rec.neb.id
                 else rec.neb.id:='NGC'+rec.neb.id;
   rec.str[1]:=lin.cons;
   rec.neb.comment:=lin.desc;
end;
end;

function Tcatalog.GetLBN(var rec:GcatRec):boolean;
var lin : LBNrec;
begin
rec:=EmptyRec;
result:=true;
repeat
  ReadLBN(lin,result);
  if not result then break;
  rec.neb.dim1:=lin.d1;
  if cfgshr.NebFilter and (rec.neb.dim1<cfgcat.NebSizeMin) then continue;
  case lin.bright of
  0..1 : rec.neb.mag:=8;
  2    : rec.neb.mag:=13;
  3    : rec.neb.mag:=15;
  4    : rec.neb.mag:=16;
  else rec.neb.mag:=18;
  end;
  if cfgshr.NebFilter and (rec.neb.mag>cfgcat.NebMagMax) then continue;
  if cfgshr.BigNebFilter and (rec.neb.dim1>=cfgshr.BigNebLimit) then continue;
  break;
until not result;
if result then begin
   rec.ra:=deg2rad*lin.ar/100000;
   rec.dec:=deg2rad*lin.de/100000;
   rec.neb.dim2:=lin.d2;
   if rec.neb.dim1<=0 then rec.neb.dim1:=1;
   if (rec.neb.mag>70)or(rec.neb.mag<-70) then begin
     rec.neb.mag:=99.9;     // undefined magnitude
     rec.neb.sbr:=99.9;
   end else begin;
     rec.neb.sbr:= rec.neb.mag + 5*log10(rec.neb.dim1) - 0.26;
   end;
   rec.neb.id:=lin.name;
   rec.str[1]:=inttostr(lin.num);
   rec.num[1]:=lin.id;
   rec.num[2]:=lin.bright;
   rec.num[3]:=lin.color;
   rec.num[4]:=lin.area;
end;
end;

function Tcatalog.GetRC3(var rec:GcatRec):boolean;
var lin : RC3rec;
begin
rec:=EmptyRec;
result:=true;
repeat
  ReadRC3(lin,result);
  if not result then break;
  rec.neb.mag:=min(90,abs(lin.mb/100));
  if cfgshr.NebFilter and (rec.neb.mag>cfgcat.NebMagMax) then continue;
  if lin.d25>=0 then rec.neb.dim1:=power(10,lin.d25/100)/10
                else rec.neb.dim1:=0;
  if cfgshr.NebFilter and (rec.neb.dim1<cfgcat.NebSizeMin) then continue;
  break;
until not result;
if result then begin
   rec.ra:=deg2rad*lin.ar/100000;
   rec.dec:=deg2rad*lin.de/100000;
   rec.neb.id:=lin.nom;
   rec.str[1]:=lin.pgc;
   rec.neb.morph:=lin.typ;
   if lin.r25>=0 then rec.neb.dim2:=rec.neb.dim1/power(10,lin.r25/100)
                 else rec.neb.dim2:=rec.neb.dim1;
   if lin.ae>=0 then rec.num[1]:=power(10,lin.ae/100)/10
                else rec.num[1]:=0;
   if lin.pa=255 then rec.neb.pa:=90
                 else rec.neb.pa:=lin.pa;
   rec.num[2]:=lin.b_vt/100;
   rec.num[3]:=lin.b_ve/100;
   if lin.m25>-9000 then rec.neb.sbr:=lin.m25/100
                    else rec.neb.sbr:=-99;
   if lin.vgsr>-999999 then rec.neb.rv:=lin.vgsr;
   rec.num[4]:=lin.stage/10;
   rec.num[5]:=lin.lumcl/10;
end;
end;

procedure Tcatalog.FormatPGC(lin : PGCrec; var rec:GcatRec);
begin
rec.neb.mag:=min(99,abs(lin.mb/100));
if lin.maj>=0 then rec.neb.dim1:=lin.maj/100
              else rec.neb.dim1:=0;
rec.ra:=deg2rad*lin.ar/100000;
rec.dec:=deg2rad*lin.de/100000;
rec.neb.id:=lin.nom;
rec.str[1]:=inttostr(lin.pgc);
rec.neb.morph:=lin.typ;
if lin.min>=0 then rec.neb.dim2:=lin.min/100
              else rec.neb.dim2:=rec.neb.dim1;
if lin.pa=255 then rec.neb.pa:=90
              else rec.neb.pa:=lin.pa;
if lin.hrv>-999999 then rec.neb.rv:=lin.hrv;
end;

function Tcatalog.GetPGC(var rec:GcatRec):boolean;
var lin : PGCrec;
    ma,sz: double;
begin
rec:=EmptyRec;
result:=true;
repeat
  ReadPGC(lin,result);
  if not result then break;
  ma:=min(99,abs(lin.mb/100));
  if cfgshr.NebFilter and (ma>cfgcat.NebMagMax) then continue;
  if lin.maj>=0 then sz:=lin.maj/100
                else sz:=0;
  if cfgshr.NebFilter and (sz<cfgcat.NebSizeMin) then continue;
  break;
until not result;
if result then begin
   FormatPGC(lin,rec);
end;
end;

procedure Tcatalog.FindPGC(id: integer; var ra,dec: double; var ok:boolean);
var lin: PGCrec;
    rec: GCatrec;
begin
InitRec(pgc);
rec:=EmptyRec;
FindNumPGC(id,lin,ok);
if ok then begin
   FormatPGC(lin,rec);
   ra:=rad2deg*rec.ra/15;
   dec:=rad2deg*rec.dec;
   FFindId:='PGC'+inttostr(id);
   FFindRecOK:=true;
   FFindRec:=rec;
end;
end;

function Tcatalog.GetOCL(var rec:GcatRec):boolean;
var lin : OCLrec;
begin
rec:=EmptyRec;
result:=true;
repeat
  ReadOCL(lin,result);
  if not result then break;
  rec.neb.dim1:=lin.dim/10;
  if cfgshr.NebFilter and (rec.neb.dim1<cfgcat.NebSizeMin) then continue;
  if cfgshr.BigNebFilter and (rec.neb.dim1>=cfgshr.BigNebLimit) then continue; // filter big object except M31, LMC, SMC
  rec.neb.mag:=lin.mt/100;
  if cfgshr.NebFilter and (rec.neb.mag>cfgcat.NebMagMax) then continue;
  break;
until not result;
if result then begin
   rec.ra:=deg2rad*lin.ar/100000;
   rec.dec:=deg2rad*lin.de/100000;
   case lin.cat of
   1 : rec.neb.id:='NGC';
   2 : rec.neb.id:='IC ';
   else str(lin.cat:3,rec.neb.id);
   end;
   rec.neb.id:=rec.neb.id+inttostr(lin.num);
   rec.str[1]:=inttostr(lin.ocl);
   rec.neb.morph:=lin.conc+lin.range+lin.rich+lin.neb;
   rec.num[1]:=3.2616*lin.dist;
   if lin.age>0 then rec.num[2]:=power(10,frac(lin.age/100));
   rec.num[3]:=lin.b_v/100;
   rec.num[4]:=lin.ns;
   rec.num[5]:=lin.ms/100;
end;
end;

function Tcatalog.GetGCM(var rec:GcatRec):boolean;
var lin : GCMrec;
begin
rec:=EmptyRec;
result:=true;
repeat
  ReadGCM(lin,result);
  if not result then break;
  rec.neb.mag:=lin.vt/100;
  if cfgshr.NebFilter and (rec.neb.mag>cfgcat.NebMagMax) then continue;
  rec.neb.dim1:=(lin.rc/100)*power(10,(lin.c/100));
  if cfgshr.NebFilter and (rec.neb.dim1<cfgcat.NebSizeMin) then continue;
  if cfgshr.BigNebFilter and (rec.neb.dim1>=cfgshr.BigNebLimit) then continue; // filter big object except M31, LMC, SMC
  break;
until not result;
if result then begin
   rec.ra:=deg2rad*lin.ar/100000;
   rec.dec:=deg2rad*lin.de/100000;
   rec.neb.id:=lin.name;
   if trim(rec.neb.id)='' then rec.neb.id:=lin.id;
   rec.str[1]:=lin.id;
   rec.str[2]:=lin.spt;
   rec.num[1]:=lin.b_vt/100;
   rec.num[2]:=(lin.muv/100)-8.89; // sec->min
   rec.num[3]:=lin.rc/100;
   rec.num[4]:=lin.rh/100;
   rec.num[5]:=3261.6*lin.rsun/10;
end;
end;

function Tcatalog.GetGPN(var rec:GcatRec):boolean;
var lin : GPNrec;
begin
rec:=EmptyRec;
result:=true;
repeat
  ReadGPN(lin,result);
  if not result then break;
  rec.neb.mag:=lin.mv/100;
  if cfgshr.NebFilter and (rec.neb.mag>cfgcat.NebMagMax) then continue;
  rec.neb.dim1:=lin.dim/10;
  if cfgshr.NebFilter and (rec.neb.dim1/60<cfgcat.NebSizeMin) then continue;
  break;
until not result;
if result then begin
   rec.ra:=deg2rad*lin.ar/100000;
   rec.dec:=deg2rad*lin.de/100000;
   rec.neb.id:=lin.name;
   rec.str[1]:=lin.pk;
   rec.str[2]:=lin.png;
   rec.num[1]:=lin.mHb/100;
   rec.num[2]:=lin.cs_v/100;
   rec.num[3]:=lin.cs_b/100;
end;
end;

function Tcatalog.FindNum(cat: integer; id: string; var ra,dec: double ):boolean ;
begin
result:=false;
while lockcat do application.ProcessMessages;
try
  lockcat:=true;
  case cat of
        S_Messier  : if IsNGCPath(cfgcat.NebCatPath[ngc-BaseNeb]) then begin
                     SetNGCPath(cfgcat.NebCatPath[ngc-BaseNeb]);
                     FindNumMessier(strtointdef(id,0),ra,dec,result) ;
                     end;
        S_NGC      : if IsNGCPath(cfgcat.NebCatPath[ngc-BaseNeb]) then begin
                     SetNGCPath(cfgcat.NebCatPath[ngc-BaseNeb]);
                     FindNumNGC(strtointdef(id,0),ra,dec,result) ;
                     end;
        S_IC       : if IsNGCPath(cfgcat.NebCatPath[ngc-BaseNeb]) then begin
                     SetNGCPath(cfgcat.NebCatPath[ngc-BaseNeb]);
                     FindNumIC(strtointdef(id,0),ra,dec,result) ;
                     end;
        S_PGC      : if IsPGCPath(cfgcat.NebCatPath[pgc-BaseNeb]) then begin
                     SetPGCPath(cfgcat.NebCatPath[pgc-BaseNeb]);
                     FindPGC(strtointdef(id,0),ra,dec,result) ;
                     end;
        S_GCVS     : if IsGCVPath(cfgcat.VarStarCatPath[gcvs-BaseVar]) then begin
                     SetGCVPath(cfgcat.VarStarCatPath[gcvs-BaseVar]);
                     FindGCVS(id,ra,dec,result) ;
                     end;
        S_GC       : if IsBSCPath(cfgcat.StarCatPath[bsc-BaseStar]) then begin
                     SetBSCPath(cfgcat.StarCatPath[bsc-BaseStar]);
                     FindNumGC(strtointdef(id,0),ra,dec,result) ;
                     end;
        S_GSC      : begin
                       SetGSCPath(cfgcat.StarCatPath[gsc-BaseStar]);
                       SetGSCCPath(cfgcat.StarCatPath[gscc-BaseStar]);
                       SetGSCFPath(cfgcat.StarCatPath[gscf-BaseStar]);
                       if cfgcat.StarCatDef[gsc-BaseStar] then FindNumGSC(id,ra,dec,result)
                       else if cfgcat.StarCatDef[gscf-BaseStar] then FindNumGSCF(id,ra,dec,result)
                       else if cfgcat.StarCatDef[gscc-BaseStar] then FindNumGSCC(id,ra,dec,result) ;
                     end;
        S_SAO      : if IsBSCPath(cfgcat.StarCatPath[bsc-BaseStar]) then begin
                     SetBSCPath(cfgcat.StarCatPath[bsc-BaseStar]);
                     FindNumSAO(strtointdef(id,0),ra,dec,result) ;
                     end;
        S_HD       : if IsBSCPath(cfgcat.StarCatPath[bsc-BaseStar]) then begin
                     SetBSCPath(cfgcat.StarCatPath[bsc-BaseStar]);
                     FindNumHD(strtointdef(id,0),ra,dec,result) ;
                     end;
        S_BD       : if IsBSCPath(cfgcat.StarCatPath[bsc-BaseStar]) then begin
                     SetBSCPath(cfgcat.StarCatPath[bsc-BaseStar]);
                     FindNumBD(id,ra,dec,result) ;
                     end;
        S_CD       : if IsBSCPath(cfgcat.StarCatPath[bsc-BaseStar]) then begin
                     SetBSCPath(cfgcat.StarCatPath[bsc-BaseStar]);
                     FindNumCD(id,ra,dec,result) ;
                     end;
        S_CPD      : if IsBSCPath(cfgcat.StarCatPath[bsc-BaseStar]) then begin
                     SetBSCPath(cfgcat.StarCatPath[bsc-BaseStar]);
                     FindNumCPD(id,ra,dec,result) ;
                     end;
        S_HR       : begin
                     SetXHIPPath(cfgcat.StarCatPath[DefStar-BaseStar]);
                     FindNumHR(strtointdef(id,0),ra,dec,result) ;
                     end;
        S_Bayer    : begin
                     SetXHIPPath(cfgcat.StarCatPath[DefStar-BaseStar]);
                     FindNumBayer(id,ra,dec,result) ;
                     end;
        S_Flam     : begin
                     SetXHIPPath(cfgcat.StarCatPath[DefStar-BaseStar]);
                     FindNumFlam(id,ra,dec,result) ;
                     end;
        S_SAC      : if IsSACPath(cfgcat.NebCatPath[sac-BaseNeb]) then begin
                     SetSACPath(cfgcat.NebCatPath[sac-BaseNeb]);
                     FindSAC(id,ra,dec,result) ;
                     end;
        S_WDS      : if IsWDSPath(cfgcat.DblStarCatPath[wds-BaseDbl]) then begin
                     SetWDSPath(cfgcat.DblStarCatPath[wds-BaseDbl]);
                     FindWDS(id,ra,dec,result) ;
                     end;
        S_GCat     : begin
                     FindNGcat(id,ra,dec,result) ;
                     end;
        S_TYC2     : if IsTY2Path(cfgcat.StarCatPath[tyc2-BaseStar]) then begin
                     SetTY2Path(cfgcat.StarCatPath[tyc2-BaseStar]);
                     FindTYC2(id,ra,dec,result) ;
                     end;
        S_UNA      : if IsUSNOApath(cfgcat.StarCatPath[usnoa-BaseStar]) then begin
                     SetUSNOApath(cfgcat.StarCatPath[usnoa-BaseStar]);
                     FindNumUSNOA(id,ra,dec,result) ;
                     end;
   end;
   ra:=deg2rad*15*ra;
   dec:=deg2rad*dec;
finally
   lockcat:=false;
end;
end;

function Tcatalog.SearchNebulae(Num:string; var ar1,de1: double): boolean;
var buf : string;
    i:integer;
begin
   if cfgcat.nebcatdef[uneb-BaseNeb] then begin
     buf:=uppercase(Num);
     for i:=0 to Length(cfgcat.UserObjects)-1 do begin
       if cfgcat.UserObjects[i].active and (UpperCase(cfgcat.UserObjects[i].oname)=buf) then begin
          ar1:= cfgcat.UserObjects[i].ra;
          de1:= cfgcat.UserObjects[i].dec;
          result:=true;
          exit;
       end;
     end;
   end;
   result:=FindNum(S_SAC,Num,ar1,de1) ;
   if result then exit;
   if uppercase(copy(Num,1,1))='M' then begin
      buf:=StringReplace(Num,'m','',[rfReplaceAll,rfIgnoreCase]);
      result:=FindNum(S_messier,buf,ar1,de1) ;
      if result then exit;
   end;
   if uppercase(copy(Num,1,3))='NGC' then begin
      buf:=StringReplace(Num,'ngc','',[rfReplaceAll,rfIgnoreCase]);
      result:=FindNum(S_NGC,buf,ar1,de1) ;
      if result then exit;
   end;
   if uppercase(copy(Num,1,2))='IC' then begin
      buf:=StringReplace(Num,'ic','',[rfReplaceAll,rfIgnoreCase]);
      result:=FindNum(S_IC,buf,ar1,de1) ;
      if result then exit;
   end;
   if uppercase(copy(Num,1,3))='PGC' then begin
      buf:=StringReplace(Num,'pgc','',[rfReplaceAll,rfIgnoreCase]);
      result:=FindNum(S_PGC,buf,ar1,de1) ;
      if result then exit;
   end;
   FindNGcat(Num,ar1,de1,result,rtNeb) ;
   if result then begin
      ar1:=deg2rad*15*ar1;
      de1:=deg2rad*de1;
      exit;
   end;
end;

function Tcatalog.SearchStarName(Num:string; var ar1,de1: double): boolean;
var i,j,l,p: integer;
    buf,sn: string;
    snl: TStringList;
begin
snl:=TStringList.Create;
buf:=uppercase(Num);
result:=false;
l:=MaxInt;
for i:=0 to cfgshr.StarNameNum-1 do begin
   Splitarg(uppercase(cfgshr.StarName[i]),';',snl);
   for j:=0 to snl.Count-1 do begin
     sn:=trim(snl[j]);
     p:=pos(buf,sn);
     if p=1 then begin
        if j<l then begin
          Num:='HR'+inttostr(cfgshr.StarNameHR[i]);
          result:=SearchStar(Num,ar1,de1);
          if buf=sn then l:=j;
        end;
     end;
   end;
end;
snl.free;
end;

function Tcatalog.SearchStar(Num:string; var ar1,de1: double): boolean;
var buf : string;
begin
   // first the id not in the default catalog
   if uppercase(copy(Num,1,2))='GC' then begin
      buf:=StringReplace(Num,'gc','',[rfReplaceAll,rfIgnoreCase]);
      result:=FindNum(S_GC,buf,ar1,de1) ;
      if result then exit;
   end;
   if uppercase(copy(Num,1,3))='GSC' then begin
      buf:=StringReplace(Num,'gsc','',[rfReplaceAll,rfIgnoreCase]);
      result:=FindNum(S_GSC,buf,ar1,de1) ;
      if result then exit;
   end;
   if uppercase(copy(Num,1,3))='UNA' then begin
      buf:=StringReplace(Num,'una','',[rfReplaceAll,rfIgnoreCase]);
      result:=FindNum(S_UNA,buf,ar1,de1) ;
      if result then exit;
   end;
   if uppercase(copy(Num,1,3))='TYC' then begin
      buf:=StringReplace(Num,'tyc','',[rfReplaceAll,rfIgnoreCase]);
      result:=FindNum(S_TYC2,buf,ar1,de1) ;
      if result then exit;
   end;
   if uppercase(copy(Num,1,3))='SAO' then begin
      buf:=StringReplace(Num,'sao','',[rfReplaceAll,rfIgnoreCase]);
      result:=FindNum(S_SAO,buf,ar1,de1) ;
      if result then exit;
   end;
   // the default catalog
   FindDefaultStars(Num,ar1,de1,result,rtStar) ;
   if result then begin
      ar1:=deg2rad*15*ar1;
      de1:=deg2rad*de1;
      exit;
   end;
   // other catgen catalog
   FindNGcat(Num,ar1,de1,result,rtStar) ;
   if result then begin
      ar1:=deg2rad*15*ar1;
      de1:=deg2rad*de1;
      exit;
   end;
   // then the id that duplicate some default catalog entries
   if uppercase(copy(Num,1,2))='HD' then begin
      buf:=StringReplace(Num,'hd','',[rfReplaceAll,rfIgnoreCase]);
      result:=FindNum(S_HD,buf,ar1,de1) ;
      if result then exit;
   end;
   if uppercase(copy(Num,1,2))='BD' then begin
      buf:=StringReplace(Num,'bd','',[rfReplaceAll,rfIgnoreCase]);
      result:=FindNum(S_BD,buf,ar1,de1) ;
      if result then exit;
   end;
   if uppercase(copy(Num,1,2))='CD' then begin
      buf:=StringReplace(Num,'cd','',[rfReplaceAll,rfIgnoreCase]);
      result:=FindNum(S_CD,buf,ar1,de1) ;
      if result then exit;
   end;
   if uppercase(copy(Num,1,3))='CPD' then begin
      buf:=StringReplace(Num,'cpd','',[rfReplaceAll,rfIgnoreCase]);
      result:=FindNum(S_CPD,buf,ar1,de1) ;
      if result then exit;
   end;
   if uppercase(copy(Num,1,2))='HR' then begin
      buf:=StringReplace(Num,'hr','',[rfReplaceAll,rfIgnoreCase]);
      result:=FindNum(S_HR,buf,ar1,de1) ;
      if result then exit;
   end;
   result:=FindNum(S_Bayer,Num,ar1,de1) ;
   if result then exit;
   result:=FindNum(S_Flam,Num,ar1,de1) ;
   if result then exit;
end;

function Tcatalog.SearchDblStar(Num:string; var ar1,de1: double): boolean;
begin
   result:=false;
   if fileexists(slash(cfgcat.DblStarCatPath[wds-BaseDbl])+'wds.ixr') then begin
      result:=FindNum(S_WDS,Num,ar1,de1) ;
      if result then exit;
   end;
   FindNGcat(Num,ar1,de1,result,rtDbl) ;
   if result then begin
      ar1:=deg2rad*15*ar1;
      de1:=deg2rad*de1;
      exit;
   end;
end;

function Tcatalog.SearchVarStar(Num:string; var ar1,de1: double): boolean;
begin
   result:=false;
   if fileexists(slash(cfgcat.VarStarCatPath[gcvs-BaseVar])+'gcvs.ixr') then begin
      result:=FindNum(S_GCVS,Num,ar1,de1) ;
      if result then exit;
   end;
   FindNGcat(Num,ar1,de1,result,rtVar) ;
   if result then begin
      ar1:=deg2rad*15*ar1;
      de1:=deg2rad*de1;
      exit;
   end;
end;

function Tcatalog.SearchLines(Num:string; var ar1,de1: double): boolean;
begin
   FindNGcat(Num,ar1,de1,result,rtLin) ;
   if result then begin
      ar1:=deg2rad*15*ar1;
      de1:=deg2rad*de1;
      exit;
   end;
end;

function Tcatalog.SearchConstellation(Num:string; var ar1,de1: double): boolean;
var i : integer;
begin
   result:=false;
   for i:=0 to cfgshr.ConstelNum-1 do
     if trim(cfgshr.ConstelName[i,2])=trim(Num) then begin
        result:=true;
        ar1:=cfgshr.ConstelPos[i].ra;
        de1:=cfgshr.ConstelPos[i].de;
        break;
     end;
end;

function Tcatalog.SearchConstAbrev(Num:string; var ar1,de1: double): boolean;
var i : integer;
begin
   result:=false;
   for i:=0 to cfgshr.ConstelNum-1 do
     if uppercase(trim(cfgshr.ConstelName[i,1]))=uppercase(trim(Num)) then begin
        result:=true;
        ar1:=cfgshr.ConstelPos[i].ra;
        de1:=cfgshr.ConstelPos[i].de;
        break;
     end;
end;

function Tcatalog.FindAtPos(cat:integer; x1,y1,x2,y2:double; nextobj,truncate,searchcenter : boolean;cfgsc:Tconf_skychart; var rec: Gcatrec):boolean;
var
   xx1,xx2,yy1,yy2,xxc,yyc,cyear,dyear,radius,rac,epoch : double;
   p: coordvector;
   ok,found,fullmotion : boolean;
begin
if x2>pi2 then rac:=pi2 else rac:=0;
xxc:=(x1+x2)/2;
yyc:=(y1+y2)/2;
if cfgsc.YPmon=0 then cyear:=cfgsc.CurYear+DayofYear(cfgsc.CurYear,cfgsc.CurMonth,cfgsc.CurDay)/365.25
                 else cyear:=cfgsc.YPmon;
xx1:=x1;
xx2:=x2;
yy1:=y1;
yy2:=y2;
if not((abs(xx1)<musec)and(abs(xx2-pi2)<musec)) then begin
  if cfgsc.ApparentPos then mean_equatorial(xx1,yy1,cfgsc,true,true);
  if cfgsc.ApparentPos then mean_equatorial(xx2,yy2,cfgsc,true,true);
end;
xx1:=rad2deg*xx1/15;
xx2:=rad2deg*xx2/15;
yy1:=rad2deg*yy1;
yy2:=rad2deg*yy2;
if not nextobj then begin
  InitRec(cat);
  case cat of
   DefStar : OpenDefaultStarsPos(xx1,xx2,yy1,yy2,ok);
   sky2000 : OpenSky(xx1,xx2,yy1,yy2,ok);
   tyc     : OpenTYC(xx1,xx2,yy1,yy2,ok);
   tyc2    : OpenTY2(xx1,xx2,yy1,yy2,2,ok);
   tic     : OpenTIC(xx1,xx2,yy1,yy2,ok);
   gscf    : OpenGSCF(xx1,xx2,yy1,yy2,ok);
   gscc    : OpenGSCC(xx1,xx2,yy1,yy2,ok);
   gsc     : OpenGSC(xx1,xx2,yy1,yy2,ok);
   usnoa   : OpenUSNOA(xx1,xx2,yy1,yy2,ok);
   microcat: OpenMCT(xx1,xx2,yy1,yy2,3,ok);
   dsbase  : OpenDSbase(xx1,xx2,yy1,yy2,ok);
   dstyc   : OpenDSTyc(xx1,xx2,yy1,yy2,ok);
   dsgsc   : OpenDSGsc(xx1,xx2,yy1,yy2,ok);
   bsc     : OpenBSC(xx1,xx2,yy1,yy2,ok);
   gcvs    : OpenGCV(xx1,xx2,yy1,yy2,ok);
   wds     : OpenWDS(xx1,xx2,yy1,yy2,ok);
   sac     : OpenSAC(xx1,xx2,yy1,yy2,ok);
   ngc     : OpenNGC(xx1,xx2,yy1,yy2,ok);
   lbn     : OpenLBN(xx1,xx2,yy1,yy2,ok);
   rc3     : OpenRC3(xx1,xx2,yy1,yy2,ok);
   pgc     : OpenPGC(xx1,xx2,yy1,yy2,ok);
   ocl     : OpenOCL(xx1,xx2,yy1,yy2,ok);
   gcm     : OpenGCM(xx1,xx2,yy1,yy2,ok);
   gpn     : OpenGPN(xx1,xx2,yy1,yy2,ok);
   vostar  : begin
                VOobject:='star';
                SetVOCatpath(slash(VODir));
                OpenVOCat(xx1,xx2,yy1,yy2,ok);
             end;
   voneb   : begin
                VOobject:='dso';
                SetVOCatpath(slash(VODir));
                OpenVOCat(xx1,xx2,yy1,yy2,ok);
             end;
   uneb    : begin
                CurrentUserObj:=-1;
                ok:=true;
             end;
   gcstar  : begin
             VerGCat:=rtStar;
             CurGCat:=0;
             ok:=false;
             while NewGCat do begin
                 OpenGCat(xx1,xx2,yy1,yy2,ok);
                 if ok then break;
             end;
             end;
   gcvar   : begin
             VerGCat:=rtVar;
             CurGCat:=0;
             ok:=false;
             while NewGCat do begin
                 OpenGCat(xx1,xx2,yy1,yy2,ok);
                 if ok then break;
             end;
             end;
   gcdbl   : begin
             VerGCat:=rtDbl;
             CurGCat:=0;
             ok:=false;
             while NewGCat do begin
                 OpenGCat(xx1,xx2,yy1,yy2,ok);
                 if ok then break;
             end;
             end;
   gcneb   : begin
             VerGCat:=rtNeb;
             CurGCat:=0;
             ok:=false;
             while NewGCat do begin
                 OpenGCat(xx1,xx2,yy1,yy2,ok);
                 if ok then break;
             end;
             end;
   else ok:=false;
  end;
  if not ok then begin result:=false; exit; end;
end;
repeat
  radius:=0;
  case cat of
   DefStar : ok:=GetDefaultStars(rec);
   sky2000 : ok:=GetSky2000(rec);
   tyc     : ok:=GetTYC(rec);
   tyc2    : ok:=GetTYC2(rec);
   tic     : ok:=GetTIC(rec);
   gscf    : ok:=GetGSCF(rec);
   gscc    : ok:=GetGSCC(rec);
   gsc     : ok:=GetGSC(rec);
   usnoa   : ok:=GetUSNOA(rec);
   microcat: ok:=GetMCT(rec);
   dsbase  : ok:=GetDSbase(rec);
   dstyc   : ok:=GetDSTyc(rec);
   dsgsc   : ok:=GetDSGsc(rec);
   bsc     : ok:=GetBSC(rec);
   gcvs    : ok:=GetGCVS(rec);
   wds     : ok:=GetWDS(rec);
   sac     : begin
             ok:=GetSAC(rec);
             radius:=GetRadius(rec);
             end;
   ngc     : begin
             ok:=GetNGC(rec);
             radius:=GetRadius(rec);
             end;
   lbn     : begin
             ok:=GetLBN(rec);
             radius:=GetRadius(rec);
             end;
   rc3     : begin
             ok:=GetRC3(rec);
             radius:=GetRadius(rec);
             end;
   pgc     : begin
             ok:=GetPGC(rec);
             radius:=GetRadius(rec);
             end;
   ocl     : begin
             ok:=GetOCL(rec);
             radius:=GetRadius(rec);
             end;
   gcm     : begin
             ok:=GetGCM(rec);
             radius:=GetRadius(rec);
             end;
   gpn     : begin
             ok:=GetGPN(rec);
             radius:=GetRadius(rec);
             end;
   vostar  : begin
             ok:=GetVOcatS(rec);
             end;
   voneb   : begin
             ok:=GetVOcatN(rec);
             end;
   uneb    : begin
             ok:=GetUObjN(rec);
             end;
   gcstar  : begin
             ok:=GetGcatS(rec);
             while not ok do begin
                ok:=NewGcat;
                if not ok then break;
                OpenGCat(xx1,xx2,yy1,yy2,ok);
                ok:=GetGcatS(rec);
             end;
             end;
   gcvar   : begin
             ok:=GetGcatV(rec);
             while not ok do begin
                ok:=NewGcat;
                if not ok then break;
                OpenGCat(xx1,xx2,yy1,yy2,ok);
                ok:=GetGcatV(rec);
             end;
             end;
   gcdbl   : begin
             ok:=GetGcatD(rec);
             while not ok do begin
                ok:=NewGcat;
                if not ok then break;
                OpenGCat(xx1,xx2,yy1,yy2,ok);
                ok:=GetGcatD(rec);
             end;
             end;
   gcneb   : begin
             ok:=GetGcatN(rec);
             while not ok do begin
                ok:=NewGcat;
                if not ok then break;
                OpenGCat(xx1,xx2,yy1,yy2,ok);
                ok:=GetGcatN(rec);
             end;
             radius:=GetRadius(rec);
             end;
   else ok:=false;
  end;
  if not ok then break;
  cfgsc.FindStarPM:=false;
  if cfgsc.PMon and (rec.options.rectype=rtStar) and rec.star.valid[vsPmra] and rec.star.valid[vsPmdec] then begin
    if rec.star.valid[vsEpoch] then epoch:=rec.star.epoch
                               else epoch:=rec.options.Epoch;
    dyear:=cyear-epoch;
    fullmotion:=(rec.star.valid[vsPx] and (trim(rec.options.flabel[26])='RV'));
    propermotion(rec.ra,rec.dec,dyear,rec.star.pmra,rec.star.pmdec,fullmotion,rec.star.px,rec.num[1]);
    cfgsc.FindStarPM:=true;
  end;
  cfgsc.FindRA2000:=rec.ra;
  cfgsc.FindDec2000:=rec.dec;
  Precession(rec.options.EquinoxJD,jd2000,cfgsc.FindRA2000,cfgsc.FindDec2000);
  sofa_S2C(rec.ra,rec.dec,p);
  PrecessionV(rec.options.EquinoxJD,cfgsc.JDChart,p);
  if cfgsc.ApparentPos then apparent_equatorialV(p,cfgsc,true,true);
  sofa_c2s(p,rec.ra,rec.dec);
  rec.ra:=rmod(rec.ra+pi2,pi2);
  if (rec.ra<pid4) then rec.ra:=rec.ra+rac;
  found:=true;
  if truncate then begin
    if (rec.ra<x1) or (rec.ra>x2) then found:=false;
    if (rec.dec<y1) or (rec.dec>y2) then found:=false;
    if (not searchcenter)and(not found)and(radius>0) then begin
       if AngularDistance(xxc,yyc,rec.ra,rec.dec)<radius then found:=true;
    end;
    if not found then continue;
  end;
  if (rec.options.rectype=rtStar) and rec.star.valid[vsB_v] then
    cfgsc.FindBV:=rec.star.b_v
  else
    cfgsc.FindBV:=0;
  if (rec.options.rectype=rtStar) and rec.star.valid[vsMagv] then
    cfgsc.FindMag:=rec.star.magv
  else
    cfgsc.FindBV:=0;
  if cfgsc.FindStarPM then begin
    cfgsc.FindPMra:=rec.star.pmra;
    cfgsc.FindPMde:=rec.star.pmdec;
    cfgsc.FindPMEpoch:=epoch;
    cfgsc.FindPMpx:=rec.star.px;
    cfgsc.FindPMrv:=rec.num[1];
    cfgsc.FindPMfullmotion:=fullmotion;
  end else begin
    cfgsc.FindPMra:=0;
    cfgsc.FindPMde:=0;
    cfgsc.FindPMEpoch:=0;
    cfgsc.FindPMpx:=0;
    cfgsc.FindPMrv:=0;
    cfgsc.FindPMfullmotion:=false;
  end;
  break;
until false ;
result:=ok;
end;

function Tcatalog.FindObj(x1,y1,x2,y2:double; searchcenter : boolean;cfgsc:Tconf_skychart; var rec: Gcatrec;ftype:integer=ftAll):boolean;
var
   ok,nextobj : boolean;
begin
ok:=false;
nextobj:=false;
if cfgsc.shownebulae and ((ftype=ftAll)or(ftype=ftNeb)) then begin
  ok:=FindAtPos(uneb,x1,y1,x2,y2,nextobj,true,searchcenter,cfgsc,rec);
  if (not ok) and cfgcat.nebcaton[voneb-BaseNeb] then begin ok:=FindAtPos(voneb,x1,y1,x2,y2,nextobj,true,searchcenter,cfgsc,rec); CloseVOCat; end;
  if (not ok) then begin ok:=FindAtPos(gcneb,x1,y1,x2,y2,nextobj,true,searchcenter,cfgsc,rec); CloseGcat; end;
  if (not ok) and cfgcat.nebcaton[sac-BaseNeb] then begin ok:=FindAtPos(sac,x1,y1,x2,y2,nextobj,true,searchcenter,cfgsc,rec); CloseSAC; end;
  if (not ok) and cfgcat.nebcaton[ngc-BaseNeb] then begin ok:=FindAtPos(ngc,x1,y1,x2,y2,nextobj,true,searchcenter,cfgsc,rec); CloseNGC; end;
  if (not ok) and cfgcat.nebcaton[lbn-BaseNeb] then begin ok:=FindAtPos(lbn,x1,y1,x2,y2,nextobj,true,searchcenter,cfgsc,rec); CloseLBN; end;
  if (not ok) and cfgcat.nebcaton[rc3-BaseNeb] then begin ok:=FindAtPos(rc3,x1,y1,x2,y2,nextobj,true,searchcenter,cfgsc,rec); CloseRC3; end;
  if (not ok) and cfgcat.nebcaton[pgc-BaseNeb] then begin ok:=FindAtPos(pgc,x1,y1,x2,y2,nextobj,true,searchcenter,cfgsc,rec); ClosePGC; end;
  if (not ok) and cfgcat.nebcaton[ocl-BaseNeb] then begin ok:=FindAtPos(ocl,x1,y1,x2,y2,nextobj,true,searchcenter,cfgsc,rec); CloseOCL; end;
  if (not ok) and cfgcat.nebcaton[gcm-BaseNeb] then begin ok:=FindAtPos(gcm,x1,y1,x2,y2,nextobj,true,searchcenter,cfgsc,rec); CloseGCM; end;
  if (not ok) and cfgcat.nebcaton[gpn-BaseNeb] then begin ok:=FindAtPos(gpn,x1,y1,x2,y2,nextobj,true,searchcenter,cfgsc,rec); CloseGPN; end;
end;
if cfgsc.showstars and ((ftype=ftAll)or(ftype=ftStar)or(ftype=ftVar)or(ftype=ftDbl)) then begin
  if (not ok) and cfgcat.starcaton[vostar-BaseStar] then begin ok:=FindAtPos(vostar,x1,y1,x2,y2,nextobj,true,searchcenter,cfgsc,rec); CloseVOCat; end;
  if (not ok) and ((ftype=ftAll)or(ftype=ftVar)) then begin ok:=FindAtPos(gcvar,x1,y1,x2,y2,nextobj,true,searchcenter,cfgsc,rec); CloseGcat; end;
  if (not ok) and ((ftype=ftAll)or(ftype=ftVar)) and cfgcat.varstarcaton[gcvs-BaseVar] then begin ok:=FindAtPos(gcvs,x1,y1,x2,y2,nextobj,true,searchcenter,cfgsc,rec); CloseGCV; end;
  if (not ok) and ((ftype=ftAll)or(ftype=ftDbl)) then begin ok:=FindAtPos(gcdbl,x1,y1,x2,y2,nextobj,true,searchcenter,cfgsc,rec); CloseGcat; end;
  if (not ok) and ((ftype=ftAll)or(ftype=ftDbl)) and cfgcat.dblstarcaton[wds-BaseDbl]  then begin ok:=FindAtPos(wds,x1,y1,x2,y2,nextobj,true,searchcenter,cfgsc,rec); CloseWDS; end;
  if (not ok) and cfgcat.starcaton[DefStar-BaseStar] then begin ok:=FindAtPos(DefStar,x1,y1,x2,y2,nextobj,true,searchcenter,cfgsc,rec); CloseDefaultStars; end;
  if (not ok) then begin ok:=FindAtPos(gcstar,x1,y1,x2,y2,nextobj,true,searchcenter,cfgsc,rec); CloseGcat; end;
  if (not ok) and cfgcat.starcaton[dsbase-BaseStar] then begin ok:=FindAtPos(dsbase,x1,y1,x2,y2,nextobj,true,searchcenter,cfgsc,rec); CloseDSbase; end;
  if (not ok) and cfgcat.starcaton[sky2000-BaseStar] then begin  ok:=FindAtPos(sky2000,x1,y1,x2,y2,nextobj,true,searchcenter,cfgsc,rec); CloseSky; end;
  if (not ok) and cfgcat.starcaton[tyc-BaseStar] then begin ok:=FindAtPos(tyc,x1,y1,x2,y2,nextobj,true,searchcenter,cfgsc,rec); CloseTYC; end;
  if (not ok) and cfgcat.starcaton[tyc2-BaseStar] then begin ok:=FindAtPos(tyc2,x1,y1,x2,y2,nextobj,true,searchcenter,cfgsc,rec); CloseTY2; end;
  if (not ok) and cfgcat.starcaton[tic-BaseStar] then begin ok:=FindAtPos(tic,x1,y1,x2,y2,nextobj,true,searchcenter,cfgsc,rec); CloseTIC; end;
  if (not ok) and cfgcat.starcaton[dstyc-BaseStar] then begin ok:=FindAtPos(dstyc,x1,y1,x2,y2,nextobj,true,searchcenter,cfgsc,rec); CloseDStyc; end;
  if (not ok) and cfgcat.starcaton[gsc-BaseStar] then begin ok:=FindAtPos(gsc,x1,y1,x2,y2,nextobj,true,searchcenter,cfgsc,rec); CloseGSC; end;
  if (not ok) and cfgcat.starcaton[gscf-BaseStar] then begin ok:=FindAtPos(gscf,x1,y1,x2,y2,nextobj,true,searchcenter,cfgsc,rec); CloseGSCF; end;
  if (not ok) and cfgcat.starcaton[gscc-BaseStar] then begin ok:=FindAtPos(gscc,x1,y1,x2,y2,nextobj,true,searchcenter,cfgsc,rec); CloseGSCC; end;
  if (not ok) and cfgcat.starcaton[dsgsc-BaseStar] then begin ok:=FindAtPos(dsgsc,x1,y1,x2,y2,nextobj,true,searchcenter,cfgsc,rec); CloseDSgsc; end;
  if (not ok) and cfgcat.starcaton[usnoa-BaseStar] then begin ok:=FindAtPos(usnoa,x1,y1,x2,y2,nextobj,true,searchcenter,cfgsc,rec); CloseUSNOA; end;
  if (not ok) and cfgcat.starcaton[microcat-BaseStar] then begin ok:=FindAtPos(microcat,x1,y1,x2,y2,nextobj,true,searchcenter,cfgsc,rec); CloseMCT; end;
  if (not ok) and cfgcat.starcaton[bsc-BaseStar] then begin ok:=FindAtPos(bsc,x1,y1,x2,y2,nextobj,true,searchcenter,cfgsc,rec); CloseBSC; end;
end;
{ if (not ok) and Catalog1Show then FindCatalogue1(ar,de,dx,dx,nextobj,ok,nom,ma,desc);
  if (not ok) and Catalog2Show then FindCatalogue2(ar,de,dx,dx,nextobj,ok,nom,ma,desc,notes);
  if (not ok) and ArtSatOn then FindSatellite(ar,de,dx,dx,nextobj,ok,nom,ma,desc);}
result:=ok;
cfgsc.FindOK:=ok;
end;

Procedure Tcatalog.GetAltName(rec: GCatrec; var txt: string);
var i:integer;
begin
for i:=1 to 10 do begin
  if (rec.vstr[i])and(rec.options.altname[i]) then begin
     txt:=rec.str[i];
     if trim(txt)>'' then begin
        if (rec.options.UsePrefix=1) or
           ((rec.options.UsePrefix=2)and(rec.options.altprefix[i]))
           then txt:=trim(rec.options.flabel[15+i])+txt;
        break;
     end;
  end;
end;
end;

function Tcatalog.CheckPath(cat: integer; catpath:string):boolean;
begin
  case cat of
   bsc     : result:=IsBSCPath(catpath);
   sky2000 : result:=IsSkyPath(catpath);
   tyc     : result:=IsTYCPath(catpath);
   tyc2    : result:=IsTY2Path(catpath);
   tic     : result:=IsTICPath(catpath);
   gscf    : result:=IsGSCFPath(catpath);
   gscc    : result:=IsGSCCPath(catpath);
   gsc     : result:=IsGSCPath(catpath);
   usnoa   : result:=IsUSNOAPath(catpath);
   microcat: result:=IsMCTPath(catpath);
   dsbase  : result:=IsDSbasePath(catpath);
   dstyc   : result:=IsDSTycPath(catpath);
   dsgsc   : result:=IsDSGscPath(catpath);
   gcvs    : result:=IsGCVPath(catpath);
   wds     : result:=IsWDSPath(catpath);
   sac     : result:=IsSACPath(catpath);
   ngc     : result:=IsNGCPath(catpath);
   lbn     : result:=IsLBNPath(catpath);
   rc3     : result:=IsRC3Path(catpath);
   pgc     : result:=IsPGCPath(catpath);
   ocl     : result:=IsOCLPath(catpath);
   gcm     : result:=IsGCMPath(catpath);
   gpn     : result:=IsGPNPath(catpath);
   else result:=false;
  end;
end;

Procedure Tcatalog.LoadConstellation(fpath,lang:string);
var f : textfile;
    i,n,p:integer;
    fname,txt:string;
begin
   fname:=slash(fpath)+'constlabel_'+lang+'.cla';
   if not FileExists(fname) then fname:=slash(fpath)+'constlabel.cla';
   if not FileExists(fname) then begin
      cfgshr.ConstelNum := 0;
      setlength(cfgshr.ConstelName,0);
      setlength(cfgshr.ConstelPos,0);
      exit;
   end;
   Filemode:=0;
   assignfile(f,fname);
   try
   reset(f);
   n:=0;
   // first loop to get the size
   repeat
     readln(f,txt);
     txt:=trim(txt);
     if (txt='')or(copy(txt,1,1)=';') then continue;
     inc(n);
   until eof(f);
   setlength(cfgshr.ConstelName,n);
   setlength(cfgshr.ConstelPos,n);
   // read the file now
   reset(f);
   i:=0;
   repeat
     readln(f,txt);
     txt:=Condutf8decode(trim(txt));
     if (txt='')or(copy(txt,1,1)=';') then continue;
     p:=pos(';',txt);
     if p=0 then begin showmessage(txt); continue; end;
     if not isnumber(trim(copy(txt,1,p-1))) then continue;
     cfgshr.ConstelPos[i].ra:=deg2rad*15*strtofloat(trim(copy(txt,1,p-1)));
     delete(txt,1,p);
     p:=pos(';',txt);
     if p=0 then begin showmessage(txt); continue; end;
     cfgshr.ConstelPos[i].de:=deg2rad*strtofloat(trim(copy(txt,1,p-1)));
     delete(txt,1,p);
     p:=pos(';',txt);
     if p=0 then begin showmessage(txt); continue; end;
     cfgshr.ConstelName[i,1]:=trim(copy(txt,1,p-1));
     delete(txt,1,p);
     cfgshr.ConstelName[i,2]:=trim(txt);
     inc(i);
   until eof(f) or (i>=n);
   cfgshr.ConstelNum := n;
   finally
   closefile(f);
   end;
end;

Procedure Tcatalog.LoadConstL(fname:string);
var f : textfile;
    i,n:integer;
    ra1,ra2,de1,de2:single;
begin
   if not FileExists(fname) then begin
      cfgshr.ConstLNum := 0;
      setlength(cfgshr.ConstL,0);
      exit;
   end;
   Filemode:=0;
   assignfile(f,fname);
   try
   reset(f);
   n:=0;
   // first loop to get the size
   repeat
     readln(f);
     inc(n);
   until eof(f);
   setlength(cfgshr.ConstL,n);
   // read the file now
   reset(f);
   for i:=0 to n-1 do begin
     readln(f,ra1,de1,ra2,de2);
     cfgshr.ConstL[i].ra1:=deg2rad*ra1*15;
     cfgshr.ConstL[i].de1:=deg2rad*de1;
     cfgshr.ConstL[i].ra2:=deg2rad*ra2*15;
     cfgshr.ConstL[i].de2:=deg2rad*de2;
   end;
   cfgshr.ConstLNum := n;
   finally
   closefile(f);
   end;
end;

Procedure Tcatalog.LoadConstB(fname:string);
var
  f : textfile;
  i,n:integer;
  ra,de : Double;
  constel,curconst:string;
begin
   if not FileExists(fname) then begin
      cfgshr.ConstBNum := 0;
      setlength(cfgshr.ConstB,0);
      exit;
   end;
   Filemode:=0;
   assignfile(f,fname);
   try
   reset(f);
   n:=0;
   // first loop to get the size
   repeat
     readln(f,constel);
     inc(n);
   until eof(f);
   setlength(cfgshr.ConstB,n);
   // read the file now
   reset(f);
   curconst:='';
   for i:=0 to n-1 do begin
     readln(f,ra,de,constel);
     cfgshr.ConstB[i].ra:=deg2rad*ra*15;
     cfgshr.ConstB[i].de:=deg2rad*de;
     cfgshr.ConstB[i].newconst:=(constel<>curconst);
     curconst:=constel;
   end;
   cfgshr.ConstBNum := n;
   finally
   closefile(f);
   end;
end;

Procedure Tcatalog.LoadHorizon(fname:string; cfgsc:Tconf_skychart);
var de,d0,d1,d2 : single;
    i,i1,i2 : integer;
    f : textfile;
    buf : string;
begin
cfgsc.HorizonMax:=musec;  // require in cfgsc for horizon clipping in u_projection
for i:=1 to 360 do cfgshr.horizonlist[i]:=0;
if fileexists(fname) then begin
i1:=0;i2:=0;d1:=0;d0:=0;
try
Filemode:=0;
assignfile(f,fname);
reset(f);
// get first point
repeat readln(f,buf) until eof(f)or((trim(buf)<>'')and(buf[1]<>'#'));
if (trim(buf)='')or(buf[1]='#') then exit;
i1:=strtoint(trim(words(buf,blank,1,1)));
d1:=strtofloat(trim(words(buf,blank,2,1)));
if d1>90 then d1:=90;
if d1<0 then d1:=0;
if i1<>0 then begin
   reset(f);
   i1:=0;
   d1:=0;
end;
i2:=0;
d0:=d1;
// process each point
while (not eof(f))and(i2<359) do begin
    repeat readln(f,buf) until eof(f)or((trim(buf)<>'')and(buf[1]<>'#'));
    if (trim(buf)='')or(buf[1]='#') then break;
    i2:=strtoint(trim(words(buf,blank,1,1)));
    d2:=strtofloat(trim(words(buf,blank,2,1)));
    if i2>359 then i2:=359;
    if i1>=i2 then continue;
    if d2>90 then d2:=90;
    if d2<0 then d2:=0;
    for i := i1 to i2 do begin
        de:=deg2rad*(d1+(i-i1)*(d2-d1)/(i2-i1));
        cfgshr.horizonlist[i+1]:=de;
        cfgsc.HorizonMax:=max(cfgsc.HorizonMax,de);
    end;
    i1:=i2;
    d1:=d2;
end;
finally
closefile(f);
// fill last point
if i2<359 then begin
    for i:=i1 to 359 do begin
        de:=deg2rad*(d1+(i-i1)*(d0-d1)/(359-i1));
        cfgshr.horizonlist[i+1]:=de;
        cfgsc.HorizonMax:=max(cfgsc.HorizonMax,de);
    end;
end;
cfgshr.horizonlist[361]:=cfgshr.horizonlist[1];
end;
end;
cfgsc.horizonlist:=@(cfgshr.horizonlist);  // require in cfgsc for horizon clipping in u_projection, this also let the door open for a specific horizon for each chart but this is not implemented at this time.

end;


Procedure Tcatalog.LoadStarName(fpath,lang:string);

var

    buf,fname,hr : string;
    f : TextFile;
    n,i : integer;
begin
 fname:=slash(fpath)+'StarsNames_'+lang+'.txt';
 if not fileexists(fname) then fname:=slash(fpath)+'StarsNames.txt';
  cfgshr.StarNameNum := 0;
  if not FileExists(fname) then begin
     setlength(cfgshr.StarName,0);
     setlength(cfgshr.StarNameHR,0);
     exit;
  end;
  assignfile(f,fname);
  FileMode:=0;
  try
  reset(f);
  n:=0;
  // first loop to get the size
  repeat
     readln(f,buf);
     if copy(buf,1,1)=';' then continue;
     inc(n);
  until eof(f);
  setlength(cfgshr.StarName,n);
  setlength(cfgshr.StarNameHR,n);
  // read the file now
  reset(f);
  i:=0;
  repeat
    Readln(f,buf);
    buf:=CondUTF8Decode(buf);
    if copy(buf,1,1)=';' then continue;
    hr:=trim(copy(buf,1,6));
    buf:=trim(copy(buf,10,999));
    cfgshr.StarName[i]:=buf;
    cfgshr.StarNameHR[i]:=strtointdef(hr,0);
    inc(i);
  until eof(f);
  cfgshr.StarNameNum:=n;
  finally
   CloseFile(f);
  end;
end;


function Tcatalog.LongLabelObj(txt:string):string;
begin
if txt='OC' then txt:=rsOpenCluster
else if txt='Gb' then txt:=rsGlobularClus
else if txt='Gx' then txt:=rsGalaxy
else if txt='Nb' then txt:=rsBrightNebula
else if txt='Pl' then txt:=rsPlanetaryNeb
else if txt='C+N' then txt:=rsClusterAndNe
else if txt='N' then txt:=rsNebula
else if txt='*' then txt:=rsStar
else if txt='DS*' then txt:=rsStar
else if txt='**' then txt:=rsDoubleStar
else if txt='***' then txt:=rsTripleStar
else if txt='D*' then txt:=rsDoubleStar
else if txt='V*' then txt:=rsVariableStar
else if txt='DSV*' then txt:=rsVariableStar
else if txt='Ast' then txt:=rsAsterism
else if txt='Kt' then txt:=rsKnot
else if txt='?' then txt:=rsUnknowObject
else if txt='' then txt:=rsUnknowObject
else if txt='-' then txt:=rsPlateDefect
else if txt='PD' then txt:=rsPlateDefect
else if txt='S*' then txt:=rsStar
else if txt='P' then txt:=rsPlanet
else if txt='DSP' then txt:=rsPlanet
else if txt='Ps' then txt:=rsPlanetarySat
else if txt='As' then txt:=rsAsteroid
else if txt='DSAs' then txt:=rsAsteroid
else if txt='Cm' then txt:=rsComet
else if txt='DSCm' then txt:=rsComet
else if txt='Sat' then txt:=rsArtificialSa2
else if txt='C1' then txt:=rsExternalCata
else if txt='C2' then txt:=rsExternalCata
else if txt='OSR' then txt:=rsOnlineSearch2;
result:=txt;
end;

function Tcatalog.LongLabel(txt:string):string;
var key,value : string;
    i : integer;
const d=': ';
begin
i:=pos(':',txt);
if i>0 then begin
  key:=uppercase(trim(copy(txt,1,i-1)));
  value:=copy(txt,i+1,9999);
  if key='MB' then result:=rsBlueMagnitud+d+value
  else if key='MV' then result:=rsVisualMagnit+d+value
  else if key='MR' then result:=rsRedMagnitude+d+value
  else if key='M' then result:=rsMagnitude+d+value
  else if key='MI' then result:=rsMagnitude+' '+'I'+d+value
  else if key='MJ' then result:=rsMagnitude+' '+'J'+d+value
  else if key='MH' then result:=rsMagnitude+' '+'H'+d+value
  else if key='MK' then result:=rsMagnitude+' '+'K'+d+value
  else if key='BT' then result:=rsMagnitudeTyc+d+value
  else if key='VT' then result:=rsMagnitudeTyc2+d+value
  else if key='B-V' then result:=rsColorIndex+d+value
  else if key='SP' then result:=rsSpectralClas+d+value
  else if key='PM' then result:=rsAnnualProper+d+value
  else if key='CLASS' then result:=rsClass+d+value
  else if key='NAME' then result:=rsName+d+value
  else if key='N' then result:=rsNote+d+value
  else if key='T' then result:=rsTypeOfVariab+d+value
  else if key='P' then result:=rsPeriod+d+value
  else if key='BAND' then result:=rsMagnitudeBan+d+value
  else if key='PLATE' then result:=rsPhotographic+d+value
  else if key='MULT' then result:=rsMultipleFlag+d+value
  else if key='FIELD' then result:=rsFieldNumber+d+value
  else if key='Q' then result:=rsMagnitudeErr+d+value
  else if key='S' then result:=rsCorrelated+d+value
  else if key='DIM' then result:=rsDimension+d+value
  else if key='CONST' then result:=rsConstellatio+d+longlabelconst(value)
  else if key='SBR' then result:=rsSurfaceBrigh+d+value
  else if key='DESC' then result:=rsDescription+d+value
  else if key='RV' then result:=rsRadialVeloci+d+value
  else if key='SURFACE' then result:=rsSurface+d+value
  else if key='COLOR' then result:=rsColor+d+value
  else if key='BRIGHT' then result:=rsBrightness+d+value
  else if key='TR' then result:=rsTrumplerClas+d+value
  else if key='DIST' then result:=rsDistance+d+value
  else if key='M*' then result:=rsBrightestSta+d+value
  else if key='N*' then result:=rsNumberOfStar+d+value
  else if key='AGE' then result:=rsAge+d+value
  else if key='RT' then result:=rsTotalRadius+d+value
  else if key='RH' then result:=rsHalfMassRadi+d+value
  else if key='RC' then result:=rsCoreRadius+d+value
  else if key='MHB' then result:=rsHbetaMagnitu+d+value
  else if key='C*B' then result:=rsCentralStarB+d+value
  else if key='C*V' then result:=rsCentralStarV+d+value
  else if key='DIAM' then result:=rsDiameter+d+value
  else if key='ILLUM' then result:=rsIlluminatedF+d+value
  else if key='PHASE' then result:=rsPhase+d+value
  else if key='TL' then result:=rsEstimatedTai+d+value
  else if key='EL' then result:=rsSolarElongat+d+value
  else if key='RSOL' then result:=rsSolarDistanc+d+value
  else if key='VEL' then result:=rsVelocity+d+value
  else if key='D1' then result:=rsDescription+' 1'+d+value
  else if key='D2' then result:=rsDescription+' 2'+d+value
  else if key='D3' then result:=rsDescription+' 3'+d+value
  else if key='FL' then result:=rsFlamsteedNum+d+value
  else if key='BA' then result:=rsBayerLetter+d+LongLabelGreek(value)
  else if key='PX' then result:=rsParallax+d+value
  else if key='PA' then result:=rsPositionAngl+d+value
  else if key='PMRA' then result:=rsProperMotion+d+value
  else if key='PMDE' then result:=rsProperMotion2+d+value
  else if key='MMAX' then result:=rsMagnitudeAtM+d+value
  else if key='MMIN' then result:=rsMagnitudeAtM2+d+value
  else if key='MEPOCH' then result:=rsEpochOfMaxim+d+value
  else if key='RISE' then result:=rsRiseTime+d+value
  else if key='COMP' then result:=rsComponent+d+value
  else if key='COMPID' then result:=rsDoubleStar+d+value
  else if key='M1' then result:=rsComponent1Ma+d+value
  else if key='M2' then result:=rsComponent2Ma+d+value
  else if key='SEP' then result:=rsSeparation+d+value
  else if key='DATE' then result:=rsDate+d+value
  else if key='POLEINCL' then result:=rsPoleInclinat+d+value
  else if key='SUNINCL' then result:=rsSunInclinati+d+value
  else if key='CM' then result:=rsCentralMerid+d+value
  else if key='CMI' then result:=rsCentralMerid+' I'+d+value
  else if key='CMII' then result:=rsCentralMerid+' II'+d+value
  else if key='CMIII' then result:=rsCentralMerid+' III'+d+value
  else if key='GRSTR' then result:=rsGRSTransit+d+value
  else if key='LLAT' then result:=rsLibrationInL+d+value
  else if key='LLON' then result:=rsLibrationInL2+d+value
  else if key='EPHEMERIS' then result:=rsEphemeris+d+value
  else if key='D' then result:=value
  else result:=txt;
end
else result:=txt;
end;

Function Tcatalog.LongLabelConst(txt : string) : string;
var i : integer;
begin
txt:=uppercase(trim(txt));
for i:=0 to cfgshr.ConstelNum-1 do begin
  if txt=UpperCase(cfgshr.ConstelName[i,1]) then begin
     txt:=cfgshr.ConstelName[i,2];
     break;
   end;
end;
result:=txt;
end;

Function Tcatalog.LongLabelGreek(txt : string) : string;
var i : integer;
begin
txt:=uppercase(trim(txt));
for i:=1 to 24 do begin
  if txt=UpperCase(trim(greek[2,i])) then begin
     txt:=greek[1,i];
     break;
   end;
end;
result:=txt;
end;


end.
