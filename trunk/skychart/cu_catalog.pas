unit cu_catalog;
{
Copyright (C) 2002 Patrick Chevalley

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
{
 Catalog interface component. Also contain shared resources.
}

interface

uses u_constant, libcatalog, u_util, u_projection,
     SysUtils, Classes, Math,
{$ifdef linux}
   Qforms;
{$endif}
{$ifdef mswindows}
   Forms;
{$endif}

type

  Tcatalog = class(TComponent)
  private
    { Private declarations }
    LockCat : boolean;
    NumCat,CurCat,CurGCat,VerGCat : integer;
    EmptyRec : GCatRec;
  protected
    { Protected declarations }
     function InitRec(cat:integer):boolean;
     function OpenStarCat:boolean;
     function CloseStarCat:boolean;
     function NewGCat:boolean;
     function GetGCatS(var rec:GcatRec):boolean;
     function GetGCatV(var rec:GcatRec):boolean;
     function GetGCatD(var rec:GcatRec):boolean;
     function GetGCatN(var rec:GcatRec):boolean;
     function GetGCatL(var rec:GcatRec):boolean;
     procedure FindNGCat(id : shortstring; var ar,de:double ; var ok:boolean);
     function GetBSC(var rec:GcatRec):boolean;
     function GetSky2000(var rec:GcatRec):boolean;
     function GetTYC(var rec:GcatRec):boolean;
     function GetTYC2(var rec:GcatRec):boolean;
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
     function OpenDblStarCat:boolean;
     function CloseDblStarCat:boolean;
     function GetWDS(var rec:GcatRec):boolean;
     function OpenNebCat:boolean;
     function CloseNebCat:boolean;
     function GetSAC(var rec:GcatRec):boolean;
     function GetNGC(var rec:GcatRec):boolean;
     function GetLBN(var rec:GcatRec):boolean;
     function GetRC3(var rec:GcatRec):boolean;
     function GetPGC(var rec:GcatRec):boolean;
     function GetOCL(var rec:GcatRec):boolean;
     function GetGCM(var rec:GcatRec):boolean;
     function GetGPN(var rec:GcatRec):boolean;
     function OpenLinCat:boolean;
     function CloseLinCat:boolean;
  public
    { Public declarations }
     cfgcat : conf_catalog;
     cfgshr : conf_shared;
     constructor Create(AOwner:TComponent); override;
     destructor  Destroy; override;
     function OpenCat(c: conf_skychart):boolean;
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
     function FindNum(cat: integer; id: string; var ra,dec: double ):boolean ;
     function FindAtPos(cat:integer; x1,y1,x2,y2:double; nextobj,truncate : boolean;var cfgsc:conf_skychart; var rec: Gcatrec):boolean;
     function FindObj(x1,y1,x2,y2:double; nextobj : boolean;var cfgsc:conf_skychart; var rec: Gcatrec):boolean;
     procedure GetAltName(rec: GCatrec; var txt: string);
     function CheckPath(cat: integer; catpath:string):boolean;
     function GetInfo(path,shortname:string; var magmax:single;var v:integer; var version,longname:shortstring):boolean;
     function GetMaxField(path,cat: string):string;
     Procedure LoadConstellation(fname:string);
     Procedure LoadConstL(fname:string);
     Procedure LoadConstB(fname:string);
     Procedure LoadHorizon(fname:string; var cfgsc:conf_skychart);
  published
    { Published declarations }
  end;

Implementation

constructor Tcatalog.Create(AOwner:TComponent);
begin
 inherited Create(AOwner);
 lockcat:=false;
end;

destructor Tcatalog.Destroy;
begin
 inherited destroy;
end;

Function Tcatalog.OpenCat(c: conf_skychart):boolean;
var ac,dc: double;
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
  InitCatWin(c.axglb,c.ayglb,c.bxglb/rad2deg,c.byglb/rad2deg,c.sintheta,c.costheta,rad2deg*c.racentre/15,rad2deg*c.decentre,ac,dc,c.CurJD,c.JDChart,rad2deg*c.CurST/15,c.ObsLatitude,c.ProjPole,c.xshift,c.yshift,c.xmin,c.xmax,c.ymin,c.ymax,c.projtype,northpole2000inmap(c),southpole2000inmap(c));
  result:=true;
end;

function Tcatalog.CloseCat:boolean;
begin
lockcat:=false;
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
   bsc     : result:=GetBSC(rec);
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
                if result then OpenGCatWin(result);
                if result then result:=ReadStar(rec);
             end;
             end;
end;
if (not result) and ((curcat-BaseStar)<numcat) then begin
  CloseStarCat;
  inc(curcat);
  while ((curcat-BaseStar)<=numcat)and(not cfgcat.starcaton[curcat-BaseStar]) do inc(curcat);
  if ((curcat-BaseStar)>numcat) then result:=false
     else result:=OpenStarCat;
  if result then result:=ReadStar(rec);
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
   bsc     : begin SetBscPath(cfgcat.starcatpath[bsc-BaseStar]); OpenBSCwin(result); end;
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
   gcstar  : begin VerGCat:=rtStar; CurGCat:=0; result:=NewGCat; if result then OpenGCatWin(result);end;
   else result:=false;
end;
end;

function Tcatalog.CloseStarCat:boolean;
begin
result:=true;
case curcat of
   bsc     : CloseBSC;
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
                if result then OpenGCatWin(result);
                if result then result:=ReadVarStar(rec);
             end;
             end;
end;
if (not result) and ((curcat-BaseVar)<numcat) then begin
  CloseVarStarCat;
  inc(curcat);
  while ((curcat-BaseVar)<=numcat)and(not cfgcat.varstarcaton[curcat-BaseVar]) do inc(curcat);
  if ((curcat-BaseVar)>numcat) then result:=false
     else result:=OpenVarStarCat;
  if result then result:=ReadVarStar(rec);
end;
end;

function Tcatalog.OpenVarStarCat:boolean;
begin
InitRec(curcat);
case curcat of
   gcvs    : begin SetGCVPath(cfgcat.varstarcatpath[gcvs-BaseVar]); OpenGCVwin(result); end;
   gcvar   : begin VerGCat:=rtVar; CurGCat:=0; result:=NewGCat; if result then OpenGCatWin(result); end;
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
                if result then OpenGCatWin(result);
                if result then result:=ReadDblStar(rec);
             end;
             end;
end;
if (not result) and ((curcat-BaseDbl)<numcat) then begin
  CloseDblStarCat;
  inc(curcat);
  while ((curcat-BaseDbl)<=numcat)and(not cfgcat.dblstarcaton[curcat-BaseDbl]) do inc(curcat);
  if ((curcat-BaseDbl)>numcat) then result:=false
     else result:=OpendblStarCat;
  if result then result:=ReadDblStar(rec);
end;
end;

function Tcatalog.OpenDblStarCat:boolean;
begin
InitRec(curcat);
case curcat of
   wds     : begin SetWDSPath(cfgcat.dblstarcatpath[wds-BaseDbl]); OpenWDSwin(result); end;
   gcdbl   : begin VerGCat:=rtDbl; CurGCat:=0; result:=NewGCat; if result then OpenGCatWin(result); end;
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
                if result then OpenGCatWin(result);
                if result then result:=ReadNeb(rec);
             end;
             end;
end;
if (not result) and ((curcat-BaseNeb)<numcat) then begin
  CloseNebCat;
  inc(curcat);
  while ((curcat-BaseNeb)<=numcat)and(not cfgcat.nebcaton[curcat-BaseNeb]) do inc(curcat);
  if ((curcat-BaseNeb)>numcat) then result:=false
     else result:=OpenNebCat;
  if result then result:=ReadNeb(rec);
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
   gcneb  : begin VerGCat:=rtNeb; CurGCat:=0; result:=NewGCat; if result then OpenGCatWin(result); end;
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
                if result then OpenGCatWin(result);
                if result then result:=ReadLin(rec);
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
   gclin  : begin VerGCat:=rtLin; CurGCat:=0; result:=NewGCat; if result then OpenGCatWin(result); end;
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
 GetGCatInfo(GcatH,v,result);
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
result:=GetGcatL(rec);
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
   tic     : begin
             EmptyRec.options.flabel:=StarLabel;
             EmptyRec.options.ShortName:='TIC';
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
             EmptyRec.options.rectype:=rtStar;
             EmptyRec.options.Equinox:=2000;
             EmptyRec.options.EquinoxJD:=jd2000;
             EmptyRec.options.MagMax:=15;
             EmptyRec.options.UsePrefix:=0;
             Emptyrec.star.valid[vsId]:=true;
             end;
   gcvs    : begin
             EmptyRec.options.flabel:=VarLabel;
             EmptyRec.options.ShortName:='GCV';
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
             EmptyRec.options.altname[1]:=true;
             EmptyRec.vstr[1]:=true;
             EmptyRec.options.flabel[16]:='PGC';
             end;
   ocl     : begin
             EmptyRec.options.flabel:=NebLabel;
             EmptyRec.options.ShortName:='OCL';
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
    break;
 end;
 if cfgcat.GCatLst[CurGCat-1].CatOn then begin
   SetGcatPath(cfgcat.GCatLst[CurGCat-1].path,cfgcat.GCatLst[CurGCat-1].shortname);
   GetGCatInfo(GcatH,v,result);
 end else result:=false;
until result and (v=VerGCat);
end;

function Tcatalog.GetInfo(path,shortname:string; var magmax:single;var v:integer; var version,longname:shortstring):boolean;
var GcatH : TCatHeader;
begin
SetGcatPath(path,shortname);
GetGCatInfo(GcatH,v,result);
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
GetGCatInfo(GcatH,v,ok);
case GcatH.FileNum of
  1    : result:='10';
  50   : result:='10';
  184  : result:='7';
  732  : result:='5';
  9537 : result:='3';
  else   result:='7';
end;
end;

function Tcatalog.GetGCatS(var rec:GcatRec):boolean;
begin
result:=true;
repeat
  ReadGCat(rec,result);
  if not result then break;
  if cfgshr.StarFilter and (rec.star.magv>cfgcat.StarMagMax) then begin
             NextGCat(result);
             if result then continue;
  end;
  rec.ra:=deg2rad*rec.ra;
  rec.dec:=deg2rad*rec.dec;
  rec.star.pmra:=deg2rad*rec.star.pmra/3600;
  rec.star.pmdec:=deg2rad*rec.star.pmdec/3600;
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
             NextGCat(result);
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
             NextGCat(result);
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
             NextGCat(result);
             if result then continue;
  end;
  if not rec.neb.valid[vnNebunit] then rec.neb.nebunit:=rec.options.Units;
  if cfgshr.NebFilter and
     rec.neb.valid[vnDim1] and
     (rec.neb.dim1*60/rec.neb.nebunit<cfgcat.NebSizeMin) then continue;
  if not rec.neb.valid[vnNebtype] then rec.neb.nebtype:=rec.options.ObjType;
  if cfgshr.NebFilter and cfgshr.BigNebFilter and (rec.neb.dim1*60/rec.neb.nebunit>=cfgshr.BigNebLimit) and (rec.neb.nebtype<>1) then continue; // filter big object except M31, LMC, SMC
  rec.ra:=deg2rad*rec.ra;
  rec.dec:=deg2rad*rec.dec;
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
  break;
until not result;
end;

procedure Tcatalog.FindNGCat(id : shortstring; var ar,de:double ; var ok:boolean);
var
   H : TCatHeader;
   i,version : integer;
begin
ok:=false;
for i:=0 to cfgcat.GCatNum-1 do begin
  if fileexists(slash(cfgcat.GCatLst[i].path)+cfgcat.GCatLst[i].shortname+'.idx') then begin
   SetGcatPath(cfgcat.GCatLst[i].path,cfgcat.GCatLst[i].shortname);
   GetGCatInfo(H,version,ok);
   if ok then FindNumGcat(cfgcat.GCatLst[i].path,cfgcat.GCatLst[i].shortname,id,H.ixkeylen, ar,de,ok);
   if ok then break;
  end;
end;
end;

function Tcatalog.GetBSC(var rec:GcatRec):boolean;
var lin : BSCrec;
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
   if lin.flam>0 then rec.star.id:=copy(inttostr(lin.flam)+blank15,1,3) else rec.star.id:='';
   rec.star.id:=rec.star.id+' '+ lin.bayer+' '+lin.cons;
   rec.str[1]:=inttostr(lin.bs);
   if lin.hd>0 then rec.str[2]:=inttostr(lin.hd) else rec.str[2]:='';
   if trim(lin.bayer)<>'' then begin
      rec.star.greeksymbol:=GreekLetter(lin.bayer);
      rec.star.valid[vsGreekSymbol]:=true;
   end else if lin.flam>0 then begin
      rec.star.greeksymbol:=inttostr(lin.flam);
      rec.star.valid[vsGreekSymbol]:=true;
   end;
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
     n:=' '+lin.dm_cat+n;
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
   smnum : shortstring;
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
   rec.star.id:=inttostr(lin.gscz)+'.'+inttostr(lin.gscn)+'.'+inttostr(lin.tycn);
end;
end;

function Tcatalog.GetTYC2(var rec:GcatRec):boolean;
var lin : TY2rec;
   smnum : shortstring;
begin
rec:=EmptyRec;
result:=true;
repeat
  ReadTY2(lin,smnum,result);
  if not result then break;
  rec.star.magv:=lin.vt;
  if rec.star.magv>30 then rec.star.magv:=lin.bt;
  if cfgshr.StarFilter and (rec.star.magv>cfgcat.StarMagMax) then continue;
  break;
until not result;
if result then begin
   rec.ra:=deg2rad*lin.ar;
   rec.dec:=deg2rad*lin.de;
   rec.star.magb:=lin.bt;
   if (lin.vt<30)and(lin.bt<30) then rec.star.b_v:=0.850*(lin.bt-lin.vt)
                                else rec.star.b_v:=0;
   rec.star.pmra:=deg2rad*lin.pmar/1000/3600;
   rec.star.pmdec:=deg2rad*lin.pmde/1000/3600;
   rec.star.id:=inttostr(lin.gscz)+'.'+inttostr(lin.gscn)+'.'+inttostr(lin.tycn);
end;
end;

function Tcatalog.GetTIC(var rec:GcatRec):boolean;
var lin : TICrec;
    smnum : shortstring;
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
   rec.star.id:=inttostr(lin.gscz)+'.'+inttostr(lin.gscn);
end;
end;

function Tcatalog.GetGSCF(var rec:GcatRec):boolean;
var lin : GSCFrec;
    smnum : shortstring;
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
   rec.star.id:=smnum+'.'+inttostr(lin.gscn);
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
    smnum : shortstring;
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
   rec.star.id:=smnum+'.'+inttostr(lin.gscn);
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
    smnum : shortstring;
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
   rec.star.id:=smnum+'.'+inttostr(lin.gscn);
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

function Tcatalog.GetGCVS(var rec:GcatRec):boolean;
var lin : GCVrec;
begin
rec:=EmptyRec;
result:=true;
repeat
  ReadGCV(lin,result);
  if not result then break;
  rec.variable.magmax:=lin.max/100;
  if cfgshr.StarFilter and (rec.variable.magmax>cfgcat.StarMagMax) then continue;
  if (not cfgcat.UseGSVSIr) and (lin.mcode>='J')and(lin.mcode<='N') then continue;
  break;
until not result;
if result then begin
   rec.ra:=deg2rad*lin.ar/100000;
   rec.dec:=deg2rad*lin.de/100000;
   rec.variable.magmin:=lin.min/100;
   rec.variable.magmax:=lin.max/100;
   rec.variable.id:=lin.gcvs;
   str(lin.num:7,rec.str[1]);
   if copy(lin.vartype,7,3)='NSV' then rec.str[1]:='NSV'+rec.str[1];
   rec.variable.period:=lin.period;
   rec.variable.vartype:=stringreplace(lin.vartype,':',' ',[rfReplaceAll]);
   rec.variable.magcode:=lin.mcode;
   rec.str[2]:=lin.lmin+' '+lin.lmax;
end;
end;

function Tcatalog.GetWDS(var rec:GcatRec):boolean;
var lin : WDSrec;
begin
rec:=EmptyRec;
result:=true;
repeat
  ReadWDS(lin,result);
  if not result then break;
  rec.double.mag1:=lin.ma/100;
  if cfgshr.StarFilter and (rec.double.mag1>cfgcat.StarMagMax) then continue;
  break;
until not result;
if result then begin
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
   rec.double.mag2:=lin.mb/100;
   rec.double.id:=lin.id;
   rec.double.compname:=lin.comp;
   rec.double.sp1:=lin.sp;
   rec.double.comment:=lin.note;
end;
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
  rec.neb.dim1:=lin.s1;
  if rec.neb.valid[vnNebunit] then nebunit:=rec.neb.nebunit
                              else nebunit:=rec.options.Units;
  if cfgshr.NebFilter and ((rec.neb.dim1*60/nebunit)<cfgcat.NebSizeMin) then continue;
  rec.neb.mag:=lin.ma;
  if trim(lin.typ)='Drk' then rec.neb.mag:=11;  // also filter dark nebulae
  if cfgshr.NebFilter and (rec.neb.mag>cfgcat.NebMagMax) then continue;
  if cfgshr.BigNebFilter and (rec.neb.dim1>=cfgshr.BigNebLimit) and (trim(lin.typ)<>'Gx') then continue; // filter big object except M31, LMC, SMC
  break;
until not result;
if result then begin
   rec.ra:=deg2rad*lin.ar;
   rec.dec:=deg2rad*lin.de;
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
   if lin.pa=255 then rec.neb.pa:=90
                 else rec.neb.pa:=lin.pa;
   if (lin.sbr>70)or(rec.neb.nebtype=2)or(rec.neb.nebtype=6) then rec.neb.sbr:=99 // not reliable sbr for open cluster
                else rec.neb.sbr:=lin.sbr;
   if (rec.neb.mag<6)and((rec.neb.nebtype=2)or(rec.neb.nebtype=6)) then rec.neb.mag:=6;  // overestimate mag for open cluster
   rec.neb.id:=lin.nom1;
   rec.neb.messierobject:=(copy(lin.nom1,1,2)='M ');
   rec.str[1]:=lin.nom2;
   rec.str[2]:=lin.cons;
   rec.neb.morph:=lin.clas;
   rec.neb.comment:=lin.desc;
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
  rec.neb.mag:=minvalue([90,abs(lin.mb/100)]);
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

function Tcatalog.GetPGC(var rec:GcatRec):boolean;
var lin : PGCrec;
begin
rec:=EmptyRec;
result:=true;
repeat
  ReadPGC(lin,result);
  if not result then break;
  rec.neb.mag:=minvalue([90,abs(lin.mb/100)]);
  if cfgshr.NebFilter and (rec.neb.mag>cfgcat.NebMagMax) then continue;
  if lin.maj>=0 then rec.neb.dim1:=lin.maj/100
                else rec.neb.dim1:=0;
  if cfgshr.NebFilter and (rec.neb.dim1<cfgcat.NebSizeMin) then continue;
  break;
until not result;
if result then begin
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
        S_Messier  : begin
                     SetNGCPath(cfgcat.NebCatPath[ngc-BaseNeb]);
                     FindNumMessier(strtointdef(id,0),ra,dec,result) ;
                     end;
        S_NGC      : begin
                     SetNGCPath(cfgcat.NebCatPath[ngc-BaseNeb]);
                     FindNumNGC(strtointdef(id,0),ra,dec,result) ;
                     end;
        S_IC       : begin
                     SetNGCPath(cfgcat.NebCatPath[ngc-BaseNeb]);
                     FindNumIC(strtointdef(id,0),ra,dec,result) ;
                     end;
        S_PGC      : begin
                     SetNGCPath(cfgcat.NebCatPath[pgc-BaseNeb]);
                     FindNumPGC(strtointdef(id,0),ra,dec,result) ;
                     end;
        S_GCVS     : begin
                     SetGCVPath(cfgcat.VarStarCatPath[gcvs-BaseVar]);
                     FindNumGCVS(id,ra,dec,result) ;
                     end;
        S_GC       : begin
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
        S_SAO      : begin
                     SetBSCPath(cfgcat.StarCatPath[bsc-BaseStar]);
                     FindNumSAO(strtointdef(id,0),ra,dec,result) ;
                     end;
        S_HD       : begin
                     SetBSCPath(cfgcat.StarCatPath[bsc-BaseStar]);
                     FindNumHD(strtointdef(id,0),ra,dec,result) ;
                     end;
        S_BD       : begin
                     SetBSCPath(cfgcat.StarCatPath[bsc-BaseStar]);
                     FindNumBD(id,ra,dec,result) ;
                     end;
        S_CD       : begin
                     SetBSCPath(cfgcat.StarCatPath[bsc-BaseStar]);
                     FindNumCD(id,ra,dec,result) ;
                     end;
        S_CPD      : begin
                     SetBSCPath(cfgcat.StarCatPath[bsc-BaseStar]);
                     FindNumCPD(id,ra,dec,result) ;
                     end;
        S_HR       : begin
                     SetBSCPath(cfgcat.StarCatPath[bsc-BaseStar]);
                     FindNumHR(strtointdef(id,0),ra,dec,result) ;
                     end;
{       S_Comet    : begin
            FindNumCom(strtointdef(id,0),ra,dec,result);
            if result and beingfollow then begin
               FollowOn:=true;
               FollowType:=2;
               FollowObj:=strtointdef(id,0);
            end;
            end;
        S_Planet   : begin
            FindNumPla(strtointdef(id,0),ra,dec,result);
            if result and beingfollow then begin
               FollowOn:=true;
               FollowType:=1;
               FollowObj:=strtointdef(id,0);
            end;
            end;
        S_Asteroid : begin
            FindNumAst(strtointdef(id,0),ra,dec,result);
            if result and beingfollow then begin
               FollowOn:=true;
               FollowType:=3;
               FollowObj:=strtointdef(id,0);
            end;
            end;
        S_Const    : begin
                     FindNumCon(strtointdef(id,0),ra,dec,result);
                     end; }
        S_Bayer    : begin
                     SetBSCPath(cfgcat.StarCatPath[bsc-BaseStar]);
                     FindNumBayer(id,ra,dec,result) ;
                     end;
        S_Flam     : begin
                     SetBSCPath(cfgcat.StarCatPath[bsc-BaseStar]);
                     FindNumFlam(id,ra,dec,result) ;
                     end;
{       S_U2k      : begin
                     FindNumU2000(strtointdef(id,0),ra,dec,result);
                     end;
        S_Ext      : begin
                     FindNumExt(id,ra,dec,result) ;
                     end; }
        S_SAC      : begin
                     SetSACPath(cfgcat.NebCatPath[sac-BaseNeb]);
                     FindNumSAC(id,ra,dec,result) ;
                     end;
{       S_SIMBAD   : begin
                     FindNumSIMBAD(id,ra,dec,result) ;
                     end;
        S_NED      : begin
                     FindNumNED(id,ra,dec,result) ;
                     end;}
        S_WDS      : begin
                     SetWDSPath(cfgcat.DblStarCatPath[wds-BaseDbl]);
                     FindNumWDS(id,ra,dec,result) ;
                     end;
        S_GCat     : begin
                     FindNGcat(id,ra,dec,result) ;
                     end;
        S_TYC2     : begin
                     SetTY2Path(cfgcat.StarCatPath[tyc2-BaseStar]);
                     FindNumTYC2(id,ra,dec,result) ;
                     end;
{       S_Common   : begin
                     FindNumObjectName(strtointdef(id,0),ra,dec,result);
                     end; }
   end;
   ra:=deg2rad*15*ra;
   dec:=deg2rad*dec;
finally
   lockcat:=false;
end;
end;

function Tcatalog.FindAtPos(cat:integer; x1,y1,x2,y2:double; nextobj,truncate : boolean;var cfgsc:conf_skychart; var rec: Gcatrec):boolean;
var
   xx1,xx2,yy1,yy2,cyear,dyear : double;
   ok : boolean;
begin
xx1:=rad2deg*x1/15;
xx2:=rad2deg*x2/15;
yy1:=rad2deg*y1;
yy2:=rad2deg*y2;
cyear:=cfgsc.CurYear+cfgsc.CurMonth/12;
if not nextobj then begin
  InitRec(cat);
  case cat of
   bsc     : OpenBSC(xx1,xx2,yy1,yy2,ok);
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
   gcstar  : begin VerGCat:=rtStar; CurGCat:=0; ok:=NewGCat; if ok then OpenGCat(xx1,xx2,yy1,yy2,ok);end;
   gcvar   : begin VerGCat:=rtVar; CurGCat:=0; ok:=NewGCat; if ok then OpenGCat(xx1,xx2,yy1,yy2,ok);end;
   gcdbl   : begin VerGCat:=rtDbl; CurGCat:=0; ok:=NewGCat; if ok then OpenGCat(xx1,xx2,yy1,yy2,ok);end;
   gcneb   : begin VerGCat:=rtNeb; CurGCat:=0; ok:=NewGCat; if ok then OpenGCat(xx1,xx2,yy1,yy2,ok);end;
   else ok:=false;
  end;
  if not ok then begin result:=false; exit; end;
end;
repeat
  case cat of
   bsc     : ok:=GetBSC(rec);
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
   gcvs    : ok:=GetGCVS(rec);
   wds     : ok:=GetWDS(rec);
   sac     : ok:=GetSAC(rec);
   ngc     : ok:=GetNGC(rec);
   lbn     : ok:=GetLBN(rec);
   rc3     : ok:=GetRC3(rec);
   pgc     : ok:=GetPGC(rec);
   ocl     : ok:=GetOCL(rec);
   gcm     : ok:=GetGCM(rec);
   gpn     : ok:=GetGPN(rec);
   gcstar  : begin
             ok:=GetGcatS(rec);
             while not ok do begin
                ok:=NewGcat;
                if not ok then break;
                OpenGCat(xx1,xx2,yy1,yy2,ok);
                if ok then ok:=GetGcatS(rec);
             end;
             end;
   gcvar   : begin
             ok:=GetGcatV(rec);
             while not ok do begin
                ok:=NewGcat;
                if not ok then break;
                OpenGCat(xx1,xx2,yy1,yy2,ok);
                if ok then ok:=GetGcatV(rec);
             end;
             end;
   gcdbl   : begin
             ok:=GetGcatD(rec);
             while not ok do begin
                ok:=NewGcat;
                if not ok then break;
                OpenGCat(xx1,xx2,yy1,yy2,ok);
                if ok then ok:=GetGcatD(rec);
             end;
             end;
   gcneb   : begin
             ok:=GetGcatN(rec);
             while not ok do begin
                ok:=NewGcat;
                if not ok then break;
                OpenGCat(xx1,xx2,yy1,yy2,ok);
                if ok then ok:=GetGcatN(rec);
             end;
             end;
   else ok:=false;
  end;
  if not ok then break;
  if cfgsc.PMon and (rec.options.rectype=rtStar) and rec.star.valid[vsPmra] and rec.star.valid[vsPmdec] then begin
    if rec.star.valid[vsEpoch] then dyear:=cyear-rec.star.epoch
                               else dyear:=cyear-rec.options.Epoch;
    rec.ra:=rec.ra+(rec.star.pmra/cos(rec.dec))*dyear;
    rec.dec:=rec.dec+(rec.star.pmdec)*dyear;
  end;
  precession(rec.options.EquinoxJD,cfgsc.JDChart,rec.ra,rec.dec);
  if cfgsc.ApparentPos then apparent_equatorial(rec.ra,rec.dec,cfgsc);
  if truncate then begin
    if (rec.ra<x1) or (rec.ra>x2) then continue;
    if (rec.dec<y1) or (rec.dec>y2) then continue;
  end;
  break;
until false ;
result:=ok;
end;

function Tcatalog.FindObj(x1,y1,x2,y2:double; nextobj : boolean;var cfgsc:conf_skychart; var rec: Gcatrec):boolean;
var
   ok : boolean;
begin
  ok:=FindAtPos(gcneb,x1,y1,x2,y2,nextobj,true,cfgsc,rec);
  if (not ok) and cfgcat.nebcaton[sac-BaseNeb] then ok:=FindAtPos(sac,x1,y1,x2,y2,nextobj,true,cfgsc,rec);
  if (not ok) and cfgcat.nebcaton[ngc-BaseNeb] then ok:=FindAtPos(ngc,x1,y1,x2,y2,nextobj,true,cfgsc,rec);
  if (not ok) and cfgcat.nebcaton[lbn-BaseNeb] then ok:=FindAtPos(lbn,x1,y1,x2,y2,nextobj,true,cfgsc,rec);
  if (not ok) and cfgcat.nebcaton[rc3-BaseNeb] then ok:=FindAtPos(rc3,x1,y1,x2,y2,nextobj,true,cfgsc,rec);
  if (not ok) and cfgcat.nebcaton[pgc-BaseNeb] then ok:=FindAtPos(pgc,x1,y1,x2,y2,nextobj,true,cfgsc,rec);
  if (not ok) and cfgcat.nebcaton[ocl-BaseNeb] then ok:=FindAtPos(ocl,x1,y1,x2,y2,nextobj,true,cfgsc,rec);
  if (not ok) and cfgcat.nebcaton[gcm-BaseNeb] then ok:=FindAtPos(gcm,x1,y1,x2,y2,nextobj,true,cfgsc,rec);
  if (not ok) and cfgcat.nebcaton[gpn-BaseNeb] then ok:=FindAtPos(gpn,x1,y1,x2,y2,nextobj,true,cfgsc,rec);
  if (not ok) then ok:=FindAtPos(gcvar,x1,y1,x2,y2,nextobj,true,cfgsc,rec);
  if (not ok) and cfgcat.varstarcaton[gcvs-BaseVar] then ok:=FindAtPos(gcvs,x1,y1,x2,y2,nextobj,true,cfgsc,rec);
  if (not ok) then ok:=FindAtPos(gcdbl,x1,y1,x2,y2,nextobj,true,cfgsc,rec);
  if (not ok) and cfgcat.dblstarcaton[wds-BaseDbl]  then ok:=FindAtPos(wds,x1,y1,x2,y2,nextobj,true,cfgsc,rec);
  if (not ok) then ok:=FindAtPos(gcstar,x1,y1,x2,y2,nextobj,true,cfgsc,rec);
  if (not ok) and cfgcat.starcaton[bsc-BaseStar] then ok:=FindAtPos(bsc,x1,y1,x2,y2,nextobj,true,cfgsc,rec);
  if (not ok) and cfgcat.starcaton[dsbase-BaseStar] then ok:=FindAtPos(dsbase,x1,y1,x2,y2,nextobj,true,cfgsc,rec);
  if (not ok) and cfgcat.starcaton[sky2000-BaseStar] then ok:=FindAtPos(sky2000,x1,y1,x2,y2,nextobj,true,cfgsc,rec);
  if (not ok) and cfgcat.starcaton[tyc-BaseStar] then ok:=FindAtPos(tyc,x1,y1,x2,y2,nextobj,true,cfgsc,rec);
  if (not ok) and cfgcat.starcaton[tyc2-BaseStar] then ok:=FindAtPos(tyc2,x1,y1,x2,y2,nextobj,true,cfgsc,rec);
  if (not ok) and cfgcat.starcaton[tic-BaseStar] then ok:=FindAtPos(tic,x1,y1,x2,y2,nextobj,true,cfgsc,rec);
  if (not ok) and cfgcat.starcaton[dstyc-BaseStar] then ok:=FindAtPos(dstyc,x1,y1,x2,y2,nextobj,true,cfgsc,rec);
  if (not ok) and cfgcat.starcaton[gsc-BaseStar] then ok:=FindAtPos(gsc,x1,y1,x2,y2,nextobj,true,cfgsc,rec);
  if (not ok) and cfgcat.starcaton[gscf-BaseStar] then ok:=FindAtPos(gscf,x1,y1,x2,y2,nextobj,true,cfgsc,rec);
  if (not ok) and cfgcat.starcaton[gscc-BaseStar] then ok:=FindAtPos(gscc,x1,y1,x2,y2,nextobj,true,cfgsc,rec);
  if (not ok) and cfgcat.starcaton[dsgsc-BaseStar] then ok:=FindAtPos(dsgsc,x1,y1,x2,y2,nextobj,true,cfgsc,rec);
  if (not ok) and cfgcat.starcaton[usnoa-BaseStar] then ok:=FindAtPos(usnoa,x1,y1,x2,y2,nextobj,true,cfgsc,rec);
  if (not ok) and cfgcat.starcaton[microcat-BaseStar] then ok:=FindAtPos(microcat,x1,y1,x2,y2,nextobj,true,cfgsc,rec);
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
        if rec.options.UsePrefix=1 then txt:=trim(rec.options.flabel[15+i])+txt;
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

Procedure Tcatalog.LoadConstellation(fname:string);
var f : textfile;
    i,n,p:integer;
    txt:string;
begin
   if not FileExists(fname) then begin
      cfgshr.ConstelNum := 0;
      setlength(cfgshr.ConstelName,0);
      setlength(cfgshr.ConstelPos,0);
      exit;
   end;
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
     txt:=trim(txt);
     if (txt='')or(copy(txt,1,1)=';') then continue;
     p:=pos(';',txt);
     if p=0 then continue;
     if not isnumber(trim(copy(txt,1,p-1))) then continue;
     cfgshr.ConstelPos[i].ra:=deg2rad*15*strtofloat(trim(copy(txt,1,p-1)));
     delete(txt,1,p);
     p:=pos(';',txt);
     if p=0 then continue;
     cfgshr.ConstelPos[i].de:=deg2rad*strtofloat(trim(copy(txt,1,p-1)));
     delete(txt,1,p);
     p:=pos(';',txt);
     if p=0 then continue;
     cfgshr.ConstelName[i,1]:=trim(copy(txt,1,p-1));
     delete(txt,1,p);
     cfgshr.ConstelName[i,2]:=trim(txt);
     inc(i);
   until eof(f) or (i>=(n-1));
   cfgshr.ConstelNum := n;
   finally
   closefile(f);
   end;
end;

Procedure Tcatalog.LoadConstL(fname:string);
var f : textfile;
    i,n:integer;
    ra1,ra2,de1,de2:single;
    txt:string;
begin
   if not FileExists(fname) then begin
      cfgshr.ConstLNum := 0;
      setlength(cfgshr.ConstL,0);
      exit;
   end;
   assignfile(f,fname);
   try
   reset(f);
   n:=0;
   // first loop to get the size
   repeat
     readln(f,txt);
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

Procedure Tcatalog.LoadHorizon(fname:string; var cfgsc:conf_skychart);
var de,d0,d1,d2 : single;
    i,i1,i2 : integer;
    f : textfile;
    buf : string;
begin
cfgsc.HorizonMax:=0;  // require in cfgsc for horizon clipping in u_projection
for i:=1 to 360 do cfgshr.horizonlist[i]:=0;
if fileexists(fname) then begin
i1:=0;i2:=0;d1:=0;d0:=0;
try
assignfile(f,fname);
reset(f);
// get first point
repeat readln(f,buf) until eof(f)or((trim(buf)<>'')and(buf[1]<>'#'));
if (trim(buf)='')or(buf[1]='#') then exit;
i1:=strtoint(trim(words(buf,' ',1,1)));
d1:=strtofloat(trim(words(buf,' ',2,1)));
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
    i2:=strtoint(trim(words(buf,' ',1,1)));
    d2:=strtofloat(trim(words(buf,' ',2,1)));
    if i2>359 then i2:=359;
    if i1>=i2 then continue;
    if d2>90 then d2:=90;
    if d2<0 then d2:=0;
    for i := i1 to i2 do begin
        de:=deg2rad*(d1+(i-i1)*(d2-d1)/(i2-i1));
        cfgshr.horizonlist[i+1]:=de;
        cfgsc.HorizonMax:=maxvalue([cfgsc.HorizonMax,de]);
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
        cfgsc.HorizonMax:=maxvalue([cfgsc.HorizonMax,de]);
    end;
end;
cfgsc.horizonlist:=@cfgshr.horizonlist;  // require in cfgsc for horizon clipping in u_projection, this also let the door open for a specific horizon for each chart but this is not implemented at this time.
end;
end;
end;


end.
