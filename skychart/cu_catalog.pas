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
Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
}
{
 Catalog interface component. Also contain shared resources.
}

{$mode delphi}{$H+}

interface

uses
  bscunit, dscat, findunit, gcatunit, gcmunit, gcvunit, gpnunit, gsccompact,
  gscfits, gscunit, lbnunit, microcatunit, oclunit, pgcunit, vocat,
  sacunit, skylibcat, skyunit, ticunit, tyc2unit, tycunit, usnoaunit,
  usnobunit, wdsunit, u_290, gaiaunit, cu_healpix,
  rc3unit, BGRABitmap, BGRABitmapTypes, Graphics,
  u_translation, u_constant, u_util, u_projection,
  Controls, SysUtils, Classes, Math, Dialogs, Forms;

type

  Tcatalog = class(TComponent)
  private
    { Private declarations }
    LockCat: boolean;
    NumCat, CurCat, CurGCat, VerGCat, CurrentUserObj, DSLcolor, MessierStrPos: integer;
    GcatFilter, DSLForceColor, PgcLeda, GpnNew: boolean;
    EmptyRec: GCatRec;
    FFindId: string;
    FFindRecOK: boolean;
    FFindRec: GCatrec;
  protected
    { Protected declarations }
    function InitRec(cat: integer): boolean;
    function OpenStarCat: boolean;
    function CloseStarCat: boolean;
    function NewGCat: boolean;
    function GetVOCatS(var rec: GcatRec; filter: boolean = True): boolean;
    function GetVOCatN(var rec: GcatRec; filter: boolean = True): boolean;
    function GetUObjN(var rec: GcatRec): boolean;
    function GetGCatS(var rec: GcatRec): boolean;
    function GetGCatV(var rec: GcatRec): boolean;
    function GetGCatD(var rec: GcatRec): boolean;
    function GetGCatN(var rec: GcatRec): boolean;
    function GetGCatL(var rec: GcatRec): boolean;
    procedure FindNGCat(id: shortstring; var ar, de: double;
      var ok: boolean; ctype: integer = -1);
    function GetBSC(var rec: GcatRec): boolean;
    function GetSky2000(var rec: GcatRec): boolean;
    function GetTYC(var rec: GcatRec): boolean;
    procedure FormatTYC2(lin: TY2rec; var rec: GcatRec);
    function GetTYC2(var rec: GcatRec): boolean;
    procedure FindTYC2(id: string; var ra, Dec: double; var ok: boolean);
    function GetTIC(var rec: GcatRec): boolean;
    function GetGSCF(var rec: GcatRec): boolean;
    function GetGSCC(var rec: GcatRec): boolean;
    function GetGSC(var rec: GcatRec): boolean;
    function GetUSNOA(var rec: GcatRec): boolean;
    function GetUSNOB(var rec: GcatRec): boolean;
    function GetMCT(var rec: GcatRec): boolean;
    function GetDSbase(var rec: GcatRec): boolean;
    function GetDSTyc(var rec: GcatRec): boolean;
    function GetDSGsc(var rec: GcatRec): boolean;
    function OpenVarStarCat: boolean;
    function CloseVarStarCat: boolean;
    function GetGCVS(var rec: GcatRec): boolean;
    procedure FormatGCVS(lin: GCVrec; var rec: GcatRec);
    procedure FindGCVS(id: string; var ra, Dec: double; var ok: boolean);
    function OpenDblStarCat: boolean;
    function CloseDblStarCat: boolean;
    function GetWDS(var rec: GcatRec): boolean;
    procedure FormatWDS(lin: WDSrec; var rec: GcatRec);
    procedure FindWDS(id: string; var ra, Dec: double; var ok: boolean);
    procedure CheckMessierColumn;
    function OpenNebCat: boolean;
    function CloseNebCat: boolean;
    function GetSAC(var rec: GcatRec): boolean;
    procedure FormatSAC(lin: SACrec; var rec: GcatRec);
    procedure FindSAC(id: string; var ra, Dec: double; var ok: boolean);
    function IsNGCpath(path: string): boolean;
    function OpenNGC: boolean;
    procedure OpenNGCPos(ar1, ar2, de1, de2: double; var ok: boolean);
    function CloseNGC: boolean;
    procedure FindNGC(id: shortstring; var ar, de: double; var ok: boolean);
    function GetNGC(var rec: GcatRec): boolean;
    function IsSH2path(path: string): boolean;
    function OpenSH2: boolean;
    procedure OpenSH2Pos(ar1, ar2, de1, de2: double; var ok: boolean);
    function CloseSH2: boolean;
    procedure FindSH2(id: shortstring; var ar, de: double; var ok: boolean);
    function GetSH2(var rec: GcatRec): boolean;
    function IsDRKpath(path: string): boolean;
    function OpenDRK: boolean;
    procedure OpenDRKPos(ar1, ar2, de1, de2: double; var ok: boolean);
    function CloseDRK: boolean;
    procedure FindDRK(id: shortstring; var ar, de: double; var ok: boolean);
    function GetDRK(var rec: GcatRec): boolean;
    function GetLBN(var rec: GcatRec): boolean;
    procedure FormatLBN(lin: LBNrec; var rec: GcatRec);
    procedure FindLBN(id : string ;var ar,de:double; var ok:boolean);
    function GetRC3(var rec: GcatRec): boolean;
    procedure FormatPGC(lin: PGCrec; var rec: GcatRec);
    function IsPGCpath(path: string): boolean;
    function OpenPGC: boolean;
    procedure OpenPGCPos(ar1, ar2, de1, de2: double; var ok: boolean);
    function ClosePGC: boolean;
    procedure FindPGC(id: shortstring; var ar, de: double; var ok: boolean);
    function GetPGC(var rec: GcatRec): boolean;
    function GetOldPGC(var rec: GcatRec): boolean;
    procedure FindOldPGC(id: integer; var ra, Dec: double; var ok: boolean);
    function GetOCL(var rec: GcatRec): boolean;
    function GetGCM(var rec: GcatRec): boolean;
    function IsGPNpath(path: string): boolean;
    function OpenGPN: boolean;
    procedure OpenGPNPos(ar1, ar2, de1, de2: double; var ok: boolean);
    function CloseGPN: boolean;
    procedure FindGPN(id: shortstring; var ar, de: double; var ok: boolean);
    function GetGPN(var rec: GcatRec): boolean;
    function GetGPNold(var rec: GcatRec): boolean;
    function OpenLinCat: boolean;
    function CloseLinCat: boolean;
    procedure FormatGCatS(var rec: GcatRec);
    procedure FormatGCatN(var rec: GcatRec);
    Procedure Open290(ar1,ar2,de1,de2: double ; var ok : boolean);
    Procedure Open290win(var ok : boolean);
    function  Is290Path(path : string) : Boolean;
    Procedure Close290;
    function  Get290(var rec: GcatRec): boolean;
    function  OpenGaia: boolean;
    procedure OpenGaiaPos(ar1, ar2, de1, de2: double; var ok: boolean);
    function NextGaiaLevel: boolean;
    function  GetGaia(var rec: GcatRec): boolean;
    function GaiaBRtoBV(br:double):double;
    function GaiaBRtoBV_DR2(br:double):double;
    function GaiaBRtoBV_EDR3(br:double):double;
    function GaiaGtoV(g,br:double):double;
    function GaiaGtoV_DR2(g,br:double):double;
    function GaiaGtoV_EDR3(g,br:double):double;
    procedure FormatGaia(var rec: GcatRec);
    function  FindGaia(id: string; var ar, de: double): boolean;

  public
    { Public declarations }
    cfgcat: Tconf_catalog;
    cfgshr: Tconf_shared;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function OpenCat(c: Tconf_skychart): boolean;
    function CloseCat: boolean;
    function OpenStar: boolean;
    function CloseStar: boolean;
    function ReadStar(var rec: GcatRec): boolean;
    function OpenVarStar: boolean;
    function CloseVarStar: boolean;
    function ReadVarStar(var rec: GcatRec): boolean;
    function OpenDblStar: boolean;
    function CloseDblStar: boolean;
    function ReadDblStar(var rec: GcatRec): boolean;
    function OpenNeb: boolean;
    function CloseNeb: boolean;
    function ReadNeb(var rec: GcatRec): boolean;
    function OpenLin: boolean;
    function CloseLin: boolean;
    function ReadLin(var rec: GcatRec): boolean;
    function OpenMilkyWay(fill: boolean): boolean;
    function CloseMilkyWay: boolean;
    function ReadMilkyWay(var rec: GcatRec): boolean;
    function OpenDSL(surface, forcecolor: boolean; col: integer): boolean;
    function CloseDSL: boolean;
    function ReadDSL(var rec: GcatRec): boolean;
    Function IsDefaultStarspath(path : string) : Boolean;
    function OpenDefaultStars: boolean;
    procedure OpenDefaultStarsPos(ar1, ar2, de1, de2: double; var ok: boolean);
    function CloseDefaultStars: boolean;
    function GetDefaultStars(var rec: GcatRec): boolean;
    procedure FindDefaultStars(id: shortstring; var ar, de: double;
      var ok: boolean; ctype: integer = -1);
    function FindNum(cat: integer; id: string; var ra, Dec: double): boolean;
    function SearchNebulae(Num: string; var ar1, de1: double): boolean;
    function SearchStar(Num: string; var ar1, de1: double): boolean;
    function SearchStarNameExact(Num: string; var ar1, de1: double): boolean;
    function SearchStarNameGeneric(Num: string; var ar1, de1: double): boolean;
    function SearchDblStar(Num: string; var ar1, de1: double): boolean;
    function SearchVarStar(Num: string; var ar1, de1: double): boolean;
    function SearchLines(Num: string; var ar1, de1: double): boolean;
    function SearchConstellation(Num: string; var ar1, de1: double): boolean;
    function SearchConstAbrev(Num: string; var ar1, de1: double): boolean;
    function FindAtPos(cat: integer; x1, y1, x2, y2: double;
      nextobj, truncate, searchcenter: boolean; cfgsc: Tconf_skychart; var rec: Gcatrec): boolean;
    function FindInWin(cat: integer; nextobj: boolean; cfgsc: Tconf_skychart; var rec: Gcatrec): boolean;
    function FindObj(x1, y1, x2, y2: double; searchcenter: boolean; cfgsc: Tconf_skychart;
      var rec: Gcatrec; ftype: integer = ftAll): boolean;
    procedure GetAltName(rec: GCatrec; var txt: string);
    function CheckPath(cat: integer; catpath: string): boolean;
    function GetInfo(path, shortname: string; var magmax: single;
      var v: integer; var version, longname: string): boolean;
    function GetMaxField(path, cat: string): string;
    function GetCatType(path, cat: string): integer;
    function GetNebColorSet(path, cat: string): boolean;
    function GetCatURL(path, cat: string): string;
    function GetCatTxtFile(path, cat: string): string;
    function GetVOstarmag: double;
    procedure LoadConstellation(fpath, lang: string);
    procedure LoadConstL(fname: string);
    procedure LoadConstB(fname: string);
    procedure LoadMilkywaydot(fname: string);
    procedure LoadStarName(fpath, lang: string);
    function LongLabelGreek(txt: string): string;
    function GenitiveConst(txt: string): string;
    function LongLabelConst(txt: string): string;
    function LongLabel(txt: string): string;
    function LongLabelObj(txt: string): string;
    function Get290MagMax: double;
    function GetGaiaMagMax: double;
    procedure ClearSearch;
    procedure CleanCache;
    property FindId: string read FFindId;
    property FindRecOK: boolean read FFindRecOK;
    property FindRec: GCatrec read FFindRec write FFindRec;
  published
    { Published declarations }
  end;


implementation

// compute nebula radius
function GetRadius(var rec: Gcatrec): double;
var
  nebunit: double;
begin
  Result := 0;

  if rec.neb.valid[vnNebunit] then
    nebunit := rec.neb.nebunit
  else
    nebunit := rec.options.Units;

  if nebunit <> 0 then
  begin
    Result := minarc * rec.neb.dim1 * 60 / 2 / nebunit;

    if Result = 0 then
      Result := minarc * rec.neb.dim2 * 60 / 2 / nebunit;
  end;
end;

constructor Tcatalog.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  cfgcat := Tconf_catalog.Create;
  cfgshr := Tconf_shared.Create;
  lockcat := False;
end;

destructor Tcatalog.Destroy;
begin
  gcatunit.CleanCache;
  cfgcat.Free;
  cfgshr.Free;

  try
    inherited Destroy;
  except
    writetrace('error destroy ' + Name);
  end;

end;

procedure Tcatalog.ClearSearch;
begin
  FFindRecOK := False;
  FFindId := '';
end;

procedure  Tcatalog.CleanCache;
begin
   gcatunit.CleanCache;
end;

function Tcatalog.OpenCat(c: Tconf_skychart): boolean;
var
  ac, dc, rac, ddc: double;
begin
  // get a lock before to do anything, libcatalog is NOT thread safe.
  while lockcat do
  begin
    sleep(10);
    application.ProcessMessages;
  end;

  lockcat := True;

  case c.ProjPole of

    Gal:
      begin
        ac := rad2deg * c.lcentre;
        dc := rad2deg * c.bcentre;
      end;

    Ecl:
      begin
        ac := rad2deg * c.lecentre;
        dc := rad2deg * c.becentre;
      end;
      else
      begin
        ac := rad2deg * c.acentre;
        dc := rad2deg * c.hcentre;
      end;

  end;

  rac := c.racentre;
  ddc := c.decentre;

  if c.ApparentPos then
    mean_equatorial(rac, ddc, c, True, True);

  InitCatWin(c.axglb, c.ayglb, c.bxglb / rad2deg, c.byglb / rad2deg, c.sintheta,
    c.costheta, rad2deg * rac / 15, rad2deg * ddc, ac, dc, c.CurJDUT, c.JDChart,
    rad2deg * c.CurST / 15, c.ObsLatitude, c.ProjPole, c.xshift, c.yshift, c.xmin,
    c.xmax, c.ymin, c.ymax, c.projtype, northpole2000inmap(c), southpole2000inmap(
    c), c.ProjEquatorCentered, c.haicx, c.haicy);

  skylibcat.fov := c.fov*rad2deg;

  Result := True;
end;

function Tcatalog.CloseCat: boolean;
begin
  lockcat := False;
  CloseGCat;
  Result := True;
end;


{ Stars }

function Tcatalog.OpenStar: boolean;
begin
  numcat := MaxStarCatalog;
  curcat := BaseStar + MaxStarCatalog;

  while true do begin
    while (curcat > (BaseStar)) and (not cfgcat.starcaton[curcat - BaseStar]) do
      Dec(curcat);

    if (curcat <= BaseStar) then
      Result := False
    else begin
      Result := OpenStarCat;
      if not Result then begin
         Dec(curcat);  // try next catalog
         continue;
      end;
    end;
    break;
  end;
end;

function Tcatalog.CloseStar: boolean;
begin
  Result := CloseStarCat;
  curcat := BaseStar;
end;

function Tcatalog.ReadStar(var rec: GcatRec): boolean;
begin
  Result := False;

  case curcat of
    DefStar: Result := GetDefaultStars(rec);
    sky2000: Result := GetSky2000(rec);
    tyc: Result := GetTYC(rec);
    tyc2: Result := GetTYC2(rec);
    tic: Result := GetTIC(rec);
    gscf: Result := GetGSCF(rec);
    gscc: Result := GetGSCC(rec);
    gsc: Result := GetGSC(rec);
    usnoa: Result := GetUSNOA(rec);
    usnob: Result := GetUSNOB(rec);
    hn290: Result := Get290(rec);
    gaia: Result := GetGaia(rec);
    microcat: Result := GetMCT(rec);
    dsbase: Result := GetDSbase(rec);
    dstyc: Result := GetDSTyc(rec);
    dsgsc: Result := GetDSGsc(rec);

    gcstar:
      begin
        Result := GetGcatS(rec);
        if not Result then
        begin
          Result := NewGcat;
          if Result then
          begin
            OpenGCatWin(Result);
            Result := ReadStar(rec);
          end;
        end;
      end;

    vostar:
      begin
        Result := GetVOcatS(rec);
      end;

    bsc: Result := GetBSC(rec);

  end;

  if (not Result) and (curcat > (BaseStar+1)) then
  begin

    repeat
      CloseStarCat;
      Dec(curcat);

      while (curcat > (BaseStar)) and (not cfgcat.starcaton[curcat - BaseStar]) do
        Dec(curcat);

      Result := False;

      if (curcat <= BaseStar) then
        break
      else
      begin
        Result := OpenStarCat;
        if Result then
          Result := ReadStar(rec)
        else
          cfgcat.starcaton[curcat - BaseStar] := False;
      end;

    until Result;
  end;
end;

function Tcatalog.OpenStarCat: boolean;
var
  nty2cat, nmctcat: integer;
begin

  if cfgshr.StarFilter and (cfgcat.StarmagMax <= 11) then
  begin
    nty2cat := 1;
    nmctcat := 1;
  end
  else
  begin
    nty2cat := 2;
    nmctcat := 3;
  end;

  InitRec(curcat);

  case curcat of
    DefStar: Result := OpenDefaultStars;
    sky2000:
      begin
        SetSkyPath(cfgcat.starcatpath[sky2000 - BaseStar]);
        OpenSkywin(Result);
      end;
    tyc:
      begin
        SetTycPath(cfgcat.starcatpath[tyc - BaseStar]);
        OpenTYCwin(Result);
      end;
    tyc2:
      begin
        SetTy2Path(cfgcat.starcatpath[tyc2 - BaseStar]);
        OpenTY2win(nty2cat, Result);
      end;
    tic:
      begin
        SetTicPath(cfgcat.starcatpath[tic - BaseStar]);
        OpenTICwin(Result);
      end;
    gscf:
      begin
        SetGscfPath(cfgcat.starcatpath[gscf - BaseStar]);
        OpenGSCFwin(Result);
      end;
    gscc:
      begin
        SetGsccPath(cfgcat.starcatpath[gscc - BaseStar]);
        OpenGSCCwin(Result);
      end;
    gsc:
      begin
        SetGscPath(cfgcat.starcatpath[gsc - BaseStar]);
        OpenGSCwin(Result);
      end;
    usnoa:
      begin
        SetUSNOAPath(cfgcat.starcatpath[usnoa - BaseStar]);
        OpenUSNOAwin(Result);
      end;
    usnob:
      begin
        SetUSNOBPath(cfgcat.starcatpath[usnob - BaseStar]);
        OpenUSNOBwin(Result);
      end;
    hn290:
      begin
        Open290win(Result);
      end;
    gaia:
      begin
        Result:=OpenGaia;
      end;
    microcat:
      begin
        SetMCTPath(cfgcat.starcatpath[microcat - BaseStar]);
        OpenMCTwin(nmctcat, Result);
      end;
    dsbase:
      begin
        SetDSPath(cfgcat.starcatpath[dsbase - BaseStar], cfgcat.starcatpath[dstyc - BaseStar],
          cfgcat.starcatpath[dsgsc - BaseStar]);
        OpenDSbasewin(Result);
      end;
    dstyc:
      begin
        SetDSPath(cfgcat.starcatpath[dsbase - BaseStar], cfgcat.starcatpath[dstyc - BaseStar],
          cfgcat.starcatpath[dsgsc - BaseStar]);
        OpenDStycwin(Result);
      end;
    dsgsc:
      begin
        SetDSPath(cfgcat.starcatpath[dsbase - BaseStar], cfgcat.starcatpath[dstyc - BaseStar],
          cfgcat.starcatpath[dsgsc - BaseStar]);
        OpenDSgscwin(Result);
      end;
    gcstar:
      begin
        VerGCat := rtStar;
        CurGCat := 0;
        Result := False;
        while NewGCat do
        begin
          OpenGCatWin(Result);
          if Result then
            break;
        end;
      end;
    vostar:
      begin
        VOobject := 'star';
        SetVOCatpath(slash(VODir));
        OpenVOCatwin(Result);
      end;
    bsc:
      begin
        SetBscPath(cfgcat.starcatpath[bsc - BaseStar]);
        OpenBSCwin(Result);
      end;
      else
        Result := False;
  end;
end;

function Tcatalog.CloseStarCat: boolean;
begin
  Result := True;

  case curcat of
    DefStar: CloseDefaultStars;
    sky2000: CloseSky;
    tyc: CloseTYC;
    tyc2: CloseTY2;
    tic: CloseTIC;
    gscf: CloseGSCF;
    gscc: CloseGSCC;
    gsc: CloseGSC;
    usnoa: CloseUSNOA;
    usnob: CloseUSNOB;
    hn290: Close290;
    gaia: CloseGaia;
    microcat: CloseMCT;
    dsbase: CloseDSbase;
    dstyc: CloseDStyc;
    dsgsc: CloseDSgsc;
    gcstar: CloseGcat;
    vostar: CloseVOCat;
    bsc: CloseBSC;
  else
    Result := False;
  end;

end;

{ Variables Stars }

function Tcatalog.OpenVarStar: boolean;
begin
  numcat := MaxVarStarCatalog;
  curcat := BaseVar + 1;

  while ((curcat - BaseVar) <= numcat) and (not cfgcat.varstarcaton[curcat - BaseVar]) do
    Inc(curcat);

  if ((curcat - BaseVar) > numcat) then
    Result := False
  else
    Result := OpenVarStarCat;
end;

function Tcatalog.CloseVarStar: boolean;
begin
  Result := CloseVarStarCat;
  curcat := numcat + BaseVar;
end;

function Tcatalog.ReadVarStar(var rec: GcatRec): boolean;
begin
  Result := False;

  case curcat of
    gcvs: Result := GetGCVS(rec);
    gcvar:
      begin
        Result := GetGcatV(rec);
        if not Result then
        begin
          Result := NewGcat;
          if Result then
          begin
            OpenGCatWin(Result);
            Result := ReadVarStar(rec);
          end;
        end;
      end;
  end;

  if (not Result) and ((curcat - BaseVar) < numcat) then
  begin

    repeat
      CloseVarStarCat;
      Inc(curcat);

      while ((curcat - BaseVar) <= numcat) and (not cfgcat.varstarcaton[curcat - BaseVar]) do
        Inc(curcat);

      Result := False;

      if ((curcat - BaseVar) > numcat) then
        break
      else
      begin
        Result := OpenVarStarCat;
        if Result then
          Result := ReadVarStar(rec)
        else
          cfgcat.varstarcaton[curcat - BaseVar] := False;
      end;

    until Result;

  end;
end;

function Tcatalog.OpenVarStarCat: boolean;
begin
  InitRec(curcat);
  case curcat of
    gcvs:
    begin
      SetGCVPath(cfgcat.varstarcatpath[gcvs - BaseVar]);
      OpenGCVwin(Result);
    end;
    gcvar:
    begin
      VerGCat := rtVar;
      CurGCat := 0;
      Result := False;
      while NewGCat do
      begin
        OpenGCatWin(Result);
        if Result then
          break;
      end;
    end;
    else
      Result := False;
  end;
end;

function Tcatalog.CloseVarStarCat: boolean;
begin
  Result := True;
  case curcat of
    gcvs: CloseGCV;
    gcvar: CloseGcat;
    else
      Result := False;
  end;
end;

{ Doubles Stars }

function Tcatalog.OpenDblStar: boolean;
begin
  numcat := MaxDblStarCatalog;
  curcat := BaseDbl + 1;
  while ((curcat - BaseDbl) <= numcat) and (not cfgcat.dblstarcaton[curcat - BaseDbl]) do
    Inc(curcat);
  if ((curcat - BaseDbl) > numcat) then
    Result := False
  else
    Result := OpenDblStarCat;
end;

function Tcatalog.CloseDblStar: boolean;
begin
  Result := CloseDblStarCat;
  curcat := numcat + BaseDbl;
end;

function Tcatalog.ReadDblStar(var rec: GcatRec): boolean;
begin
  Result := False;
  case curcat of
    wds: Result := GetWDS(rec);
    gcdbl:
    begin
      Result := GetGcatD(rec);
      if not Result then
      begin
        Result := NewGcat;
        if Result then
        begin
          OpenGCatWin(Result);
          Result := ReadDblStar(rec);
        end;
      end;
    end;
  end;
  if (not Result) and ((curcat - BaseDbl) < numcat) then
  begin
    repeat
      CloseDblStarCat;
      Inc(curcat);
      while ((curcat - BaseDbl) <= numcat) and (not cfgcat.dblstarcaton[curcat - BaseDbl]) do
        Inc(curcat);
      Result := False;
      if ((curcat - BaseDbl) > numcat) then
        break
      else
      begin
        Result := OpendblStarCat;
        if Result then
          Result := ReadDblStar(rec)
        else
          cfgcat.dblstarcaton[curcat - BaseDbl] := False;
      end;
    until Result;
  end;
end;

function Tcatalog.OpenDblStarCat: boolean;
begin
  InitRec(curcat);
  case curcat of
    wds:
    begin
      SetWDSPath(cfgcat.dblstarcatpath[wds - BaseDbl]);
      OpenWDSwin(Result);
    end;
    gcdbl:
    begin
      VerGCat := rtDbl;
      CurGCat := 0;
      Result := False;
      while NewGCat do
      begin
        OpenGCatWin(Result);
        if Result then
          break;
      end;
    end;
    else
      Result := False;
  end;
end;

function Tcatalog.CloseDblStarCat: boolean;
begin
  Result := True;
  case curcat of
    wds: CloseWDS;
    gcdbl: CloseGcat;
    else
      Result := False;
  end;
end;

{ Nebulae }

function Tcatalog.OpenNeb: boolean;
begin
  numcat := MaxNebCatalog;
  curcat := BaseNeb + 1;
  while ((curcat - BaseNeb) <= numcat) and (not cfgcat.nebcaton[curcat - BaseNeb]) do
    Inc(curcat);
  if ((curcat - BaseNeb) > numcat) then
    Result := False
  else
    Result := OpenNebCat;
end;

function Tcatalog.CloseNeb: boolean;
begin
  Result := CloseNebCat;
  curcat := numcat + BaseNeb;
end;

function Tcatalog.ReadNeb(var rec: GcatRec): boolean;
begin
  Result := False;
  case curcat of
    sac: Result := GetSAC(rec);
    ngc: Result := GetNGC(rec);
    lbn: Result := GetLBN(rec);
    sh2: Result := GetSH2(rec);
    drk: Result := GetDRK(rec);
    rc3: Result := GetRC3(rec);
    pgc: Result := GetPGC(rec);
    ocl: Result := GetOCL(rec);
    gcm: Result := GetGCM(rec);
    gpn: Result := GetGPN(rec);
    gcneb:
    begin
      Result := GetGcatN(rec);
      if not Result then
      begin
        Result := NewGcat;
        if Result then
        begin
          OpenGCatWin(Result);
          CheckMessierColumn;
          Result := ReadNeb(rec);
        end;
      end;
    end;
    voneb:
    begin
      Result := GetVOcatN(rec);
    end;
    uneb:
    begin
      Result := GetUObjN(rec);
    end;
  end;
  if (not Result) and ((curcat - BaseNeb) < numcat) then
  begin
    repeat
      CloseNebCat;
      Inc(curcat);
      while ((curcat - BaseNeb) <= numcat) and (not cfgcat.nebcaton[curcat - BaseNeb]) do
        Inc(curcat);
      Result := False;
      if ((curcat - BaseNeb) > numcat) then
        break
      else
      begin
        Result := OpenNebCat;
        if Result then
          Result := ReadNeb(rec)
        else
          cfgcat.nebcaton[curcat - BaseNeb] := False;
      end;
    until Result;
  end;
end;

procedure Tcatalog.CheckMessierColumn;
var
  i: integer;
  trec: GCatrec;
begin
  // Messier object ?
  MessierStrPos := -1;
  GetEmptyRec(trec);
  for i := 1 to 10 do
    if trec.vstr[i] and trec.options.altname[i] and trec.options.altprefix[i] and
      (trim(trec.options.flabel[15 + i]) = 'M') then
    begin
      MessierStrPos := i;
      break;
    end;
end;

function Tcatalog.OpenNebCat: boolean;
begin
  InitRec(curcat);
  MessierStrPos := -1;
  case curcat of
    sac:
    begin
      SetSacPath(cfgcat.nebcatpath[sac - BaseNeb]);
      OpenSACwin(Result);
    end;
    ngc: Result := OpenNGC;
    lbn:
    begin
      SetlbnPath(cfgcat.nebcatpath[lbn - BaseNeb]);
      Openlbnwin(Result);
    end;
    sh2: Result := OpenSH2;
    drk: Result := OpenDRK;
    rc3:
    begin
      Setrc3Path(cfgcat.nebcatpath[rc3 - BaseNeb]);
      Openrc3win(Result);
    end;
    pgc: Result := OpenPGC;
    ocl:
    begin
      SetoclPath(cfgcat.nebcatpath[ocl - BaseNeb]);
      Openoclwin(Result);
    end;
    gcm:
    begin
      SetgcmPath(cfgcat.nebcatpath[gcm - BaseNeb]);
      Opengcmwin(Result);
    end;
    gpn: Result := OpenGPN;
    gcneb:
    begin
      VerGCat := rtNeb;
      CurGCat := 0;
      Result := False;
      while NewGCat do
      begin
        OpenGCatWin(Result);
        if Result then
          break;
      end;
      CheckMessierColumn;
    end;
    voneb:
    begin
      VOobject := 'dso';
      SetVOCatpath(slash(VODir));
      OpenVOCatwin(Result);
    end;
    uneb:
    begin
      CurrentUserObj := -1;
      Result := True;
    end;
    else
      Result := False;
  end;
end;

function Tcatalog.CloseNebCat: boolean;
begin
  Result := True;
  case curcat of
    sac: CloseSAC;
    ngc: CloseNGC;
    lbn: CloseLBN;
    sh2: CloseSH2;
    drk: CloseDRK;
    rc3: CloseRC3;
    pgc: ClosePGC;
    ocl: CloseOCL;
    gcm: CloseGCM;
    gpn: CloseGPN;
    gcneb: CloseGcat;
    voneb: CloseVOCat;
    uneb: CurrentUserObj := MaxInt;
    else
      Result := False;
  end;
end;

{ Outline }

function Tcatalog.OpenLin: boolean;
begin
  numcat := MaxLinCatalog;
  curcat := BaseLin + 1;
  while ((curcat - BaseLin) <= numcat) and (not cfgcat.lincaton[curcat - BaseLin]) do
    Inc(curcat);
  if ((curcat - BaseLin) > numcat) then
    Result := False
  else
    Result := OpenLinCat;
end;

function Tcatalog.CloseLin: boolean;
begin
  Result := CloseLinCat;
  curcat := numcat + BaseLin;
end;

function Tcatalog.ReadLin(var rec: GcatRec): boolean;
begin
  Result := False;
  case curcat of
    gclin:
    begin
      Result := GetGcatL(rec);
      if not Result then
      begin
        Result := NewGcat;
        if Result then
        begin
          OpenGCatWin(Result);
          Result := ReadLin(rec);
        end;
      end;
    end;
  end;
  if (not Result) and ((curcat - BaseLin) < numcat) then
  begin
    CloseLinCat;
    Inc(curcat);
    while ((curcat - BaseLin) <= numcat) and (not cfgcat.Lincaton[curcat - BaseLin]) do
      Inc(curcat);
    if ((curcat - BaseLin) > numcat) then
      Result := False
    else
      Result := OpenLinCat;
    if Result then
      Result := ReadLin(rec);
  end;
end;

function Tcatalog.OpenLinCat: boolean;
begin
  InitRec(curcat);
  case curcat of
    gclin:
    begin
      VerGCat := rtLin;
      CurGCat := 0;
      Result := False;
      while NewGCat do
      begin
        OpenGCatWin(Result);
        if Result then
          break;
      end;
    end;
    else
      Result := False;
  end;
end;

function Tcatalog.CloseLinCat: boolean;
begin
  Result := True;
  case curcat of
    gclin: CloseGcat;
    else
      Result := False;
  end;
end;

function Tcatalog.OpenMilkyWay(fill: boolean): boolean;
var
  GcatH: TCatHeader;
  info: TCatHdrInfo;
  v: integer;
begin
  if fill then
    SetGcatPath(slash(appdir) + pathdelim + 'cat' + pathdelim + 'milkyway', 'mwf')
  else
    SetGcatPath(slash(appdir) + pathdelim + 'cat' + pathdelim + 'milkyway', 'mwl');
  GetGCatInfo(GcatH, info, v, GCatFilter, Result);
  if Result then
    Result := (v = rtLin);
  if Result then
    OpenGCatWin(Result);
end;

function Tcatalog.CloseMilkyWay: boolean;
begin
  CloseGcat;
  Result := True;
end;

function Tcatalog.ReadMilkyWay(var rec: GcatRec): boolean;
begin
  Result := True;
  repeat
    ReadGCat(rec, Result);
    if not Result then
      break;
    rec.ra := deg2rad * rec.ra;
    rec.Dec := deg2rad * rec.Dec;
    break;
  until not Result;
end;

function Tcatalog.OpenDSL(surface, forcecolor: boolean; col: integer): boolean;
var
  GcatH: TCatHeader;
  info: TCatHdrInfo;
  v: integer;
begin
  DSLForceColor := forcecolor;
  DSLcolor := col;
  if surface then
    SetGcatPath(slash(appdir) + pathdelim + 'cat' + pathdelim + 'DSoutlines', 'ons')
  else
    SetGcatPath(slash(appdir) + pathdelim + 'cat' + pathdelim + 'DSoutlines', 'ono');
  GetGCatInfo(GcatH, info, v, GCatFilter, Result);
  if Result then
    Result := (v = rtLin);
  if Result then
    OpenGCatWin(Result);
end;

function Tcatalog.CloseDSL: boolean;
begin
  CloseGcat;
  Result := True;
end;

function Tcatalog.ReadDSL(var rec: GcatRec): boolean;
begin
  Result := True;
  repeat
    ReadGCat(rec, Result);
    if not Result then
      break;
    rec.ra := deg2rad * rec.ra;
    rec.Dec := deg2rad * rec.Dec;
    if DSLForceColor then
    begin
      rec.outlines.valid[vlLinecolor] := True;
      rec.outlines.linecolor := DSLcolor;
    end;
    break;
  until not Result;
end;

Function Tcatalog.IsDefaultStarspath(path : string) : Boolean;
begin
  result:= FileExists(slash(path)+'star.hdr');
end;

function Tcatalog.OpenDefaultStars: boolean;
var
  GcatH: TCatHeader;
  info: TCatHdrInfo;
  v: integer;
begin
  SetGcatPath(cfgcat.starcatpath[DefStar - BaseStar], 'star');
  GetGCatInfo(GcatH, info, v, GCatFilter, Result);
  // files are sorted
  GCatFilter := True;
  if Result then
    Result := (v = rtStar);
  if Result then
    OpenGCatWin(Result);
end;

procedure Tcatalog.OpenDefaultStarsPos(ar1, ar2, de1, de2: double; var ok: boolean);
var
  GcatH: TCatHeader;
  info: TCatHdrInfo;
  v: integer;
begin
  SetGcatPath(cfgcat.starcatpath[DefStar - BaseStar], 'star');
  GetGCatInfo(GcatH, info, v, GCatFilter, ok);
  // files are sorted
  GCatFilter := True;
  if ok then
    ok := (v = rtStar);
  if ok then
    OpenGCat(ar1, ar2, de1, de2, ok);
end;

function Tcatalog.CloseDefaultStars: boolean;
begin
  CloseGcat;
  Result := True;
end;

function Tcatalog.GetDefaultStars(var rec: GcatRec): boolean;
begin
  Result := GetGCatS(rec);
end;

procedure Tcatalog.FindDefaultStars(id: shortstring; var ar, de: double;
  var ok: boolean; ctype: integer = -1);
var
  H: TCatHeader;
  info: TCatHdrInfo;
  rec: GCatrec;
  version: integer;
  iid: string;
begin
  ok := False;
  iid := id;
  SetGcatPath(cfgcat.starcatpath[DefStar - BaseStar], 'star');
  GetGCatInfo(H, info, version, GCatFilter, ok);
  GCatFilter := True;
  if fileexists(slash(cfgcat.starcatpath[DefStar - BaseStar]) + 'star' + '.ixr') then
  begin
    if ok then
      FindNumGcatRec(cfgcat.starcatpath[DefStar - BaseStar], 'star', iid, H.ixkeylen, rec, ok);
    if ok then
    begin
      ar := rec.ra / 15;
      de := rec.Dec;
      FormatGCatS(rec);
      FFindId := id;
      FFindRecOK := True;
      FFindRec := rec;
    end;
  end
  else
    ok := False;
end;

// CatGen header simulation for old catalog

function Tcatalog.InitRec(cat: integer): boolean;
begin
  fillchar(EmptyRec, sizeof(GcatRec), 0);
  Result := True;
  case cat of
    bsc:
    begin
      EmptyRec.options.flabel := StarLabel;
      EmptyRec.options.ShortName := 'BSC';
      EmptyRec.options.LongName := 'Bright Stars Catalog';
      EmptyRec.options.rectype := rtStar;
      EmptyRec.options.Equinox := 2000;
      EmptyRec.options.EquinoxJD := jd2000;
      EmptyRec.options.Epoch := 2000;
      EmptyRec.options.MagMax := 6.5;
      EmptyRec.options.UsePrefix := 1;
      EmptyRec.options.altname[1] := True;
      EmptyRec.options.altname[2] := True;
      EmptyRec.options.flabel[16] := 'HR';
      EmptyRec.options.flabel[17] := 'HD';
      EmptyRec.options.flabel[18] := rsCommonName;
      EmptyRec.options.flabel[19] := 'Flamsteed';
      EmptyRec.options.flabel[20] := 'Bayer';
      Emptyrec.star.valid[vsId] := True;
      Emptyrec.star.valid[vsMagv] := True;
      Emptyrec.star.valid[vsB_v] := True;
      Emptyrec.star.valid[vsSp] := True;
      Emptyrec.star.valid[vsPmra] := True;
      Emptyrec.star.valid[vsPmdec] := True;
      EmptyRec.vstr[1] := True;
      EmptyRec.vstr[2] := True;
    end;
    sky2000:
    begin
      EmptyRec.options.flabel := StarLabel;
      EmptyRec.options.ShortName := 'Sky';
      EmptyRec.options.LongName := 'Sky2000 catalog';
      EmptyRec.options.rectype := rtStar;
      EmptyRec.options.Equinox := 2000;
      EmptyRec.options.EquinoxJD := jd2000;
      EmptyRec.options.Epoch := 2000;
      EmptyRec.options.MagMax := 9.5;
      EmptyRec.options.UsePrefix := 0;
      EmptyRec.options.altname[1] := True;
      EmptyRec.options.altname[2] := True;
      EmptyRec.options.flabel[16] := 'HD';
      EmptyRec.options.flabel[17] := 'SAO';
      EmptyRec.options.flabel[26] := 'Sep';
      EmptyRec.options.flabel[27] := 'Dmag';
      Emptyrec.star.valid[vsId] := True;
      Emptyrec.star.valid[vsMagv] := True;
      Emptyrec.star.valid[vsB_v] := True;
      Emptyrec.star.valid[vsSp] := True;
      Emptyrec.star.valid[vsPmra] := True;
      Emptyrec.star.valid[vsPmdec] := True;
      EmptyRec.vstr[1] := True;
      EmptyRec.vstr[2] := True;
      EmptyRec.vnum[1] := True;
      EmptyRec.vnum[2] := True;
    end;
    tyc:
    begin
      EmptyRec.options.flabel := StarLabel;
      EmptyRec.options.ShortName := 'TYC';
      EmptyRec.options.LongName := 'Tycho catalog';
      EmptyRec.options.rectype := rtStar;
      EmptyRec.options.Equinox := 2000;
      EmptyRec.options.EquinoxJD := jd2000;
      EmptyRec.options.Epoch := 1991.25;
      EmptyRec.options.MagMax := 12;
      EmptyRec.options.UsePrefix := 0;
      Emptyrec.star.valid[vsId] := True;
      Emptyrec.star.valid[vsMagv] := True;
      Emptyrec.star.valid[vsMagb] := True;
      Emptyrec.star.valid[vsB_v] := True;
      Emptyrec.star.valid[vsPmra] := True;
      Emptyrec.star.valid[vsPmdec] := True;
    end;
    tyc2:
    begin
      EmptyRec.options.flabel := StarLabel;
      EmptyRec.options.ShortName := 'TYC';
      EmptyRec.options.LongName := 'Tycho2 catalog';
      EmptyRec.options.rectype := rtStar;
      EmptyRec.options.Equinox := 2000;
      EmptyRec.options.EquinoxJD := jd2000;
      EmptyRec.options.Epoch := 2000.0;
      EmptyRec.options.MagMax := 12;
      EmptyRec.options.UsePrefix := 0;
      Emptyrec.star.valid[vsId] := True;
      Emptyrec.star.valid[vsMagv] := True;
      Emptyrec.star.valid[vsMagb] := True;
      Emptyrec.star.valid[vsB_v] := True;
      Emptyrec.star.valid[vsPmra] := True;
      Emptyrec.star.valid[vsPmdec] := True;
    end;
    tic:
    begin
      EmptyRec.options.flabel := StarLabel;
      EmptyRec.options.ShortName := 'TIC';
      EmptyRec.options.LongName := 'Tycho Input catalog';
      EmptyRec.options.rectype := rtStar;
      EmptyRec.options.Equinox := 2000;
      EmptyRec.options.EquinoxJD := jd2000;
      EmptyRec.options.MagMax := 12;
      EmptyRec.options.UsePrefix := 0;
      Emptyrec.star.valid[vsId] := True;
      Emptyrec.star.valid[vsMagv] := True;
      Emptyrec.star.valid[vsMagb] := True;
      Emptyrec.star.valid[vsB_v] := True;
      EmptyRec.vnum[1] := True;
      EmptyRec.options.flabel[26] := 'Class';
    end;
    gscf:
    begin
      EmptyRec.options.flabel := StarLabel;
      EmptyRec.options.ShortName := 'GSC';
      EmptyRec.options.LongName := 'HST Guide Star catalog';
      EmptyRec.options.rectype := rtStar;
      EmptyRec.options.Equinox := 2000;
      EmptyRec.options.EquinoxJD := jd2000;
      EmptyRec.options.MagMax := 15;
      EmptyRec.options.UsePrefix := 0;
      Emptyrec.star.valid[vsId] := True;
      Emptyrec.star.valid[vsMagv] := True;
      EmptyRec.vstr[1] := True;
      EmptyRec.vstr[2] := True;
      EmptyRec.vstr[3] := True;
      EmptyRec.vstr[4] := True;
      EmptyRec.options.flabel[16] := 'Mag.band';
      EmptyRec.options.flabel[17] := 'Class';
      EmptyRec.options.flabel[18] := 'Mult';
      EmptyRec.options.flabel[19] := 'Plate';
      EmptyRec.vnum[1] := True;
      EmptyRec.vnum[2] := True;
      EmptyRec.options.flabel[26] := 'Pos.error';
      EmptyRec.options.flabel[27] := 'Mag.error';
    end;
    gscc:
    begin
      EmptyRec.options.flabel := StarLabel;
      EmptyRec.options.ShortName := 'GSC';
      EmptyRec.options.LongName := 'HST Guide Star catalog';
      EmptyRec.options.rectype := rtStar;
      EmptyRec.options.Equinox := 2000;
      EmptyRec.options.EquinoxJD := jd2000;
      EmptyRec.options.MagMax := 15;
      EmptyRec.options.UsePrefix := 0;
      Emptyrec.star.valid[vsId] := True;
      Emptyrec.star.valid[vsMagv] := True;
      EmptyRec.vstr[1] := True;
      EmptyRec.vstr[2] := True;
      EmptyRec.vstr[3] := True;
      EmptyRec.vstr[4] := True;
      EmptyRec.options.flabel[16] := 'Mag.band';
      EmptyRec.options.flabel[17] := 'Class';
      EmptyRec.options.flabel[18] := 'Mult';
      EmptyRec.options.flabel[19] := 'Plate';
      EmptyRec.vnum[1] := True;
      EmptyRec.vnum[2] := True;
      EmptyRec.options.flabel[26] := 'Pos.error';
      EmptyRec.options.flabel[27] := 'Mag.error';
    end;
    gsc:
    begin
      EmptyRec.options.flabel := StarLabel;
      EmptyRec.options.ShortName := 'GSC';
      EmptyRec.options.LongName := 'HST Guide Star catalog';
      EmptyRec.options.rectype := rtStar;
      EmptyRec.options.Equinox := 2000;
      EmptyRec.options.EquinoxJD := jd2000;
      EmptyRec.options.MagMax := 15;
      EmptyRec.options.UsePrefix := 0;
      Emptyrec.star.valid[vsId] := True;
      Emptyrec.star.valid[vsMagv] := True;
      EmptyRec.vstr[1] := True;
      EmptyRec.vstr[2] := True;
      EmptyRec.vstr[3] := True;
      EmptyRec.options.flabel[16] := 'Mag.band';
      EmptyRec.options.flabel[17] := 'Class';
      EmptyRec.options.flabel[18] := 'Mult';
      EmptyRec.vnum[1] := True;
      EmptyRec.vnum[2] := True;
      EmptyRec.options.flabel[26] := 'Pos.error';
      EmptyRec.options.flabel[27] := 'Mag.error';
    end;
    usnoa:
    begin
      EmptyRec.options.flabel := StarLabel;
      EmptyRec.options.ShortName := 'UNA';
      EmptyRec.options.LongName := 'USNO-A catalog';
      EmptyRec.options.rectype := rtStar;
      EmptyRec.options.Equinox := 2000;
      EmptyRec.options.EquinoxJD := jd2000;
      EmptyRec.options.MagMax := 18;
      EmptyRec.options.UsePrefix := 0;
      Emptyrec.star.valid[vsId] := True;
      Emptyrec.star.valid[vsMagv] := True;
      Emptyrec.star.valid[vsMagb] := True;
      EmptyRec.vstr[1] := True;
      EmptyRec.vstr[2] := True;
      EmptyRec.vstr[3] := True;
      EmptyRec.options.flabel[16] := 'Field';
      EmptyRec.options.flabel[17] := 'Quality';
      EmptyRec.options.flabel[18] := 'Calibration';
    end;
    usnob:
    begin
      EmptyRec.options.flabel := StarLabel;
      EmptyRec.options.ShortName := 'UNB';
      EmptyRec.options.LongName := 'USNO-B catalog';
      EmptyRec.options.rectype := rtStar;
      EmptyRec.options.Equinox := 2000;
      EmptyRec.options.EquinoxJD := jd2000;
      EmptyRec.options.Epoch := 2000.0;
      EmptyRec.options.MagMax := 21;
      EmptyRec.options.UsePrefix := 0;
      Emptyrec.star.valid[vsId] := True;
      Emptyrec.star.valid[vsMagv] := True;
      Emptyrec.star.valid[vsMagb] := True;
      Emptyrec.star.valid[vsPmra] := True;
      Emptyrec.star.valid[vsPmdec] := True;
      EmptyRec.vnum[1] := True;
      EmptyRec.vnum[2] := True;
      EmptyRec.options.flabel[4] := 'MagR1';
      EmptyRec.options.flabel[6] := 'MagB1';
      EmptyRec.options.flabel[26] := 'MagR2';
      EmptyRec.options.flabel[27] := 'MagB2';
    end;
    hn290:
    begin
      EmptyRec.options.flabel := StarLabel;
      EmptyRec.options.ShortName := 'HNSKY';
      EmptyRec.options.LongName := '';
      EmptyRec.options.rectype := rtStar;
      EmptyRec.options.Equinox := 2000;
      EmptyRec.options.EquinoxJD := jd2000;
      EmptyRec.options.Epoch := 2000;
      EmptyRec.options.MagMax := 18;
      EmptyRec.options.UsePrefix := 0;
      Emptyrec.star.valid[vsId] := True;
      Emptyrec.star.valid[vsMagv] := True;
      EmptyRec.options.flabel[lOffset + vsMagv]:='mBP'
    end;
    microcat:
    begin
      EmptyRec.options.flabel := StarLabel;
      EmptyRec.options.ShortName := 'MCT';
      EmptyRec.options.LongName := 'Microcat catalog';
      EmptyRec.options.rectype := rtStar;
      EmptyRec.options.Equinox := 2000;
      EmptyRec.options.EquinoxJD := jd2000;
      EmptyRec.options.MagMax := 16;
      EmptyRec.options.UsePrefix := 0;
      Emptyrec.star.valid[vsId] := True;
      Emptyrec.star.valid[vsMagv] := True;
      Emptyrec.star.valid[vsMagb] := True;
    end;
    dsbase:
    begin
      EmptyRec.options.flabel := StarLabel;
      EmptyRec.options.ShortName := 'BRS';
      EmptyRec.options.LongName := 'Deepsky2000 base star catalog';
      EmptyRec.options.rectype := rtStar;
      EmptyRec.options.Equinox := 2000;
      EmptyRec.options.EquinoxJD := jd2000;
      EmptyRec.options.MagMax := 5;
      EmptyRec.options.UsePrefix := 0;
      Emptyrec.star.valid[vsId] := True;
    end;
    dstyc:
    begin
      EmptyRec.options.flabel := StarLabel;
      EmptyRec.options.ShortName := 'TYC';
      EmptyRec.options.LongName := 'Deepsky2000 Tycho catalog';
      EmptyRec.options.rectype := rtStar;
      EmptyRec.options.Equinox := 2000;
      EmptyRec.options.EquinoxJD := jd2000;
      EmptyRec.options.MagMax := 12;
      EmptyRec.options.UsePrefix := 0;
      Emptyrec.star.valid[vsId] := True;
    end;
    dsgsc:
    begin
      EmptyRec.options.flabel := StarLabel;
      EmptyRec.options.ShortName := 'GSC';
      EmptyRec.options.LongName := 'Deepsky2000 GSC catalog';
      EmptyRec.options.rectype := rtStar;
      EmptyRec.options.Equinox := 2000;
      EmptyRec.options.EquinoxJD := jd2000;
      EmptyRec.options.MagMax := 15;
      EmptyRec.options.UsePrefix := 0;
      Emptyrec.star.valid[vsId] := True;
    end;
    gcvs:
    begin
      EmptyRec.options.flabel := VarLabel;
      EmptyRec.options.ShortName := 'GCVS';
      EmptyRec.options.LongName := 'General Catalog of Variable stars';
      EmptyRec.options.rectype := rtVar;
      EmptyRec.options.Equinox := 2000;
      EmptyRec.options.EquinoxJD := jd2000;
      EmptyRec.options.MagMax := 12;
      EmptyRec.options.UsePrefix := 0;
      Emptyrec.variable.valid[vvId] := True;
      Emptyrec.variable.valid[vvMagmax] := True;
      Emptyrec.variable.valid[vvMagmin] := True;
      Emptyrec.variable.valid[vvPeriod] := True;
      Emptyrec.variable.valid[vvVartype] := True;
      Emptyrec.variable.valid[vvMagcode] := True;
      EmptyRec.options.altname[1] := True;
      EmptyRec.vstr[1] := True;
      EmptyRec.vstr[2] := True;
      EmptyRec.options.flabel[16] := 'Num';
      EmptyRec.options.flabel[17] := 'Limit';
    end;

    wds:
    begin
      EmptyRec.options.flabel := DblLabel;
      EmptyRec.options.ShortName := 'WDS';
      EmptyRec.options.LongName := 'Washington Double Star catalog';
      EmptyRec.options.rectype := rtDbl;
      EmptyRec.options.Equinox := 2000;
      EmptyRec.options.EquinoxJD := jd2000;
      EmptyRec.options.MagMax := 12;
      EmptyRec.options.UsePrefix := 0;
      Emptyrec.double.valid[vdId] := True;
      Emptyrec.double.valid[vdMag1] := True;
      Emptyrec.double.valid[vdMag2] := True;
      Emptyrec.double.valid[vdPa] := True;
      Emptyrec.double.valid[vdSep] := True;
      Emptyrec.double.valid[vdEpoch] := True;
      Emptyrec.double.valid[vdCompname] := True;
      Emptyrec.double.valid[vdSp1] := True;
      Emptyrec.double.valid[vdComment] := True;
    end;

    sac:
    begin
      EmptyRec.options.flabel := NebLabel;
      EmptyRec.options.ShortName := 'SAC';
      EmptyRec.options.LongName := 'Saguaro Astronomy Club Database';
      EmptyRec.options.rectype := rtNeb;
      EmptyRec.options.Equinox := 2000;
      EmptyRec.options.EquinoxJD := jd2000;
      EmptyRec.options.MagMax := 12;
      EmptyRec.options.UsePrefix := 0;
      EmptyRec.options.Units := 60;
      EmptyRec.options.LogSize := 0;
      EmptyRec.options.ObjType := -1;
      Emptyrec.neb.valid[vnId] := True;
      Emptyrec.neb.valid[vnMag] := True;
      Emptyrec.neb.valid[vnSbr] := True;
      Emptyrec.neb.valid[vnDim1] := True;
      Emptyrec.neb.valid[vnDim2] := True;
      Emptyrec.neb.valid[vnPa] := True;
      Emptyrec.neb.valid[vnNebtype] := True;
      Emptyrec.neb.valid[vnMorph] := True;
      Emptyrec.neb.valid[vnComment] := True;
      EmptyRec.options.altname[1] := True;
      EmptyRec.vstr[1] := True;
      EmptyRec.vstr[2] := True;
      EmptyRec.options.flabel[16] := 'Name';
      EmptyRec.options.flabel[17] := 'Const';
    end;
    ngc:
    begin
      EmptyRec.options.flabel := NebLabel;
      EmptyRec.options.ShortName := 'NGC';
      EmptyRec.options.LongName := 'New General Catalog';
      EmptyRec.options.rectype := rtNeb;
      EmptyRec.options.Equinox := 2000;
      EmptyRec.options.EquinoxJD := jd2000;
      EmptyRec.options.MagMax := 12;
      EmptyRec.options.UsePrefix := 0;
      EmptyRec.options.Units := 60;
      EmptyRec.options.LogSize := 0;
      EmptyRec.options.ObjType := -1;
      Emptyrec.neb.valid[vnId] := True;
      Emptyrec.neb.valid[vnMag] := True;
      Emptyrec.neb.valid[vnSbr] := True;
      Emptyrec.neb.valid[vnDim1] := True;
      Emptyrec.neb.valid[vnNebtype] := True;
      Emptyrec.neb.valid[vnComment] := True;
      EmptyRec.vstr[1] := True;
      EmptyRec.options.flabel[16] := 'Const';
    end;
    lbn:
    begin
      EmptyRec.options.flabel := NebLabel;
      EmptyRec.options.ShortName := 'LBN';
      EmptyRec.options.LongName := 'Lynds Catalogue of Bright Nebulae';
      EmptyRec.options.rectype := rtNeb;
      EmptyRec.options.Equinox := 2000;
      EmptyRec.options.EquinoxJD := jd2000;
      EmptyRec.options.MagMax := 12;
      EmptyRec.options.UsePrefix := 1;
      EmptyRec.options.Units := 60;
      EmptyRec.options.LogSize := 0;
      EmptyRec.options.ObjType := 5;
      Emptyrec.neb.valid[vnId] := True;
      Emptyrec.neb.valid[vnMag] := True;
      Emptyrec.neb.valid[vnSbr] := True;
      Emptyrec.neb.valid[vnDim1] := True;
      Emptyrec.neb.valid[vnDim2] := True;
      EmptyRec.options.altname[1] := True;
      EmptyRec.options.altprefix[1] := True;
      EmptyRec.vstr[1] := True;
      EmptyRec.options.flabel[16] := 'LBN';
      EmptyRec.vnum[1] := True;
      EmptyRec.vnum[2] := True;
      EmptyRec.vnum[3] := True;
      EmptyRec.vnum[4] := True;
      EmptyRec.options.flabel[26] := 'Region';
      EmptyRec.options.flabel[27] := 'Bright';
      EmptyRec.options.flabel[28] := 'Color';
      EmptyRec.options.flabel[29] := 'Area';
    end;
    rc3:
    begin
      EmptyRec.options.flabel := NebLabel;
      EmptyRec.options.ShortName := 'RC3';
      EmptyRec.options.LongName := 'Third Reference Cat. of Bright Galaxies';
      EmptyRec.options.rectype := rtNeb;
      EmptyRec.options.Equinox := 2000;
      EmptyRec.options.EquinoxJD := jd2000;
      EmptyRec.options.MagMax := 12;
      EmptyRec.options.UsePrefix := 0;
      EmptyRec.options.Units := 60;
      EmptyRec.options.LogSize := 0;
      EmptyRec.options.ObjType := 1;
      Emptyrec.neb.valid[vnId] := True;
      Emptyrec.neb.valid[vnMag] := True;
      Emptyrec.neb.valid[vnSbr] := True;
      Emptyrec.neb.valid[vnDim1] := True;
      Emptyrec.neb.valid[vnDim2] := True;
      Emptyrec.neb.valid[vnPA] := True;
      Emptyrec.neb.valid[vnRV] := True;
      Emptyrec.neb.valid[vnMorph] := True;
      EmptyRec.options.altname[1] := True;
      EmptyRec.vstr[1] := True;
      EmptyRec.options.flabel[16] := 'PGC';
      EmptyRec.vnum[1] := True;
      EmptyRec.vnum[2] := True;
      EmptyRec.vnum[3] := True;
      EmptyRec.vnum[4] := True;
      EmptyRec.vnum[5] := True;
      EmptyRec.options.flabel[26] := 'Aperture';
      EmptyRec.options.flabel[27] := 'B-V';
      EmptyRec.options.flabel[28] := 'App.B-V';
      EmptyRec.options.flabel[29] := 'Stage';
      EmptyRec.options.flabel[30] := 'Luminosity';
    end;
    pgc:
    begin
      EmptyRec.options.flabel := NebLabel;
      EmptyRec.options.ShortName := 'PGC';
      EmptyRec.options.LongName := 'HyperLeda Database for physics of galaxies';
      EmptyRec.options.rectype := rtNeb;
      EmptyRec.options.Equinox := 2000;
      EmptyRec.options.EquinoxJD := jd2000;
      EmptyRec.options.MagMax := 12;
      EmptyRec.options.UsePrefix := 0;
      EmptyRec.options.Units := 60;
      EmptyRec.options.LogSize := 0;
      EmptyRec.options.ObjType := 1;
      Emptyrec.neb.valid[vnId] := True;
      Emptyrec.neb.valid[vnMag] := True;
      Emptyrec.neb.valid[vnSbr] := False;
      Emptyrec.neb.valid[vnDim1] := True;
      Emptyrec.neb.valid[vnDim2] := True;
      Emptyrec.neb.valid[vnPA] := True;
      Emptyrec.neb.valid[vnRV] := True;
      EmptyRec.options.altname[1] := True;
      EmptyRec.vstr[1] := True;
      EmptyRec.options.flabel[16] := 'PGC';
    end;
    ocl:
    begin
      EmptyRec.options.flabel := NebLabel;
      EmptyRec.options.ShortName := 'OCL';
      EmptyRec.options.LongName := 'Open Cluster Data 5th Edition';
      EmptyRec.options.rectype := rtNeb;
      EmptyRec.options.Equinox := 2000;
      EmptyRec.options.EquinoxJD := jd2000;
      EmptyRec.options.MagMax := 12;
      EmptyRec.options.UsePrefix := 0;
      EmptyRec.options.Units := 60;
      EmptyRec.options.LogSize := 0;
      EmptyRec.options.ObjType := 2;
      Emptyrec.neb.valid[vnId] := True;
      Emptyrec.neb.valid[vnMag] := True;
      Emptyrec.neb.valid[vnDim1] := True;
      Emptyrec.neb.valid[vnMorph] := True;
      EmptyRec.options.altname[1] := True;
      EmptyRec.vstr[1] := True;
      EmptyRec.options.flabel[16] := 'OCL';
      EmptyRec.vnum[1] := True;
      EmptyRec.vnum[2] := True;
      EmptyRec.vnum[3] := True;
      EmptyRec.vnum[4] := True;
      EmptyRec.vnum[5] := True;
      EmptyRec.options.flabel[26] := 'Dist';
      EmptyRec.options.flabel[27] := 'Age';
      EmptyRec.options.flabel[28] := 'B-V';
      EmptyRec.options.flabel[29] := 'Star-Num.';
      EmptyRec.options.flabel[30] := 'Star-Mag.';
    end;
    gcm:
    begin
      EmptyRec.options.flabel := NebLabel;
      EmptyRec.options.ShortName := 'GCM';
      EmptyRec.options.LongName := 'Globular Clusters in the Milky Way';
      EmptyRec.options.rectype := rtNeb;
      EmptyRec.options.Equinox := 2000;
      EmptyRec.options.EquinoxJD := jd2000;
      EmptyRec.options.MagMax := 12;
      EmptyRec.options.UsePrefix := 0;
      EmptyRec.options.Units := 60;
      EmptyRec.options.LogSize := 0;
      EmptyRec.options.ObjType := 3;
      Emptyrec.neb.valid[vnId] := True;
      Emptyrec.neb.valid[vnMag] := True;
      Emptyrec.neb.valid[vnDim1] := True;
      EmptyRec.options.altname[1] := True;
      EmptyRec.vstr[1] := True;
      EmptyRec.vstr[2] := True;
      EmptyRec.options.flabel[16] := 'GCM';
      EmptyRec.options.flabel[17] := 'Sp';
      EmptyRec.vnum[1] := True;
      EmptyRec.vnum[2] := True;
      EmptyRec.vnum[3] := True;
      EmptyRec.vnum[4] := True;
      EmptyRec.vnum[5] := True;
      EmptyRec.options.flabel[26] := 'B-V';
      EmptyRec.options.flabel[27] := 'Central-Sbr';
      EmptyRec.options.flabel[28] := 'Nucleus';
      EmptyRec.options.flabel[29] := 'Half-Mass';
      EmptyRec.options.flabel[30] := 'Dist';
    end;
    gpn:
    begin
      EmptyRec.options.flabel := NebLabel;
      EmptyRec.options.ShortName := 'GPN';
      EmptyRec.options.LongName :=
        'Strasbourg-ESO Catalogue of Galactic Planetary Nebulae';
      EmptyRec.options.rectype := rtNeb;
      EmptyRec.options.Equinox := 2000;
      EmptyRec.options.EquinoxJD := jd2000;
      EmptyRec.options.MagMax := 12;
      EmptyRec.options.UsePrefix := 0;
      EmptyRec.options.Units := 3600;
      EmptyRec.options.LogSize := 0;
      EmptyRec.options.ObjType := 4;
      Emptyrec.neb.valid[vnId] := True;
      Emptyrec.neb.valid[vnMag] := True;
      Emptyrec.neb.valid[vnDim1] := True;
      EmptyRec.options.altname[1] := True;
      EmptyRec.options.altname[2] := True;
      EmptyRec.vstr[1] := True;
      EmptyRec.vstr[2] := True;
      EmptyRec.options.flabel[16] := 'PK';
      EmptyRec.options.flabel[17] := 'PNG';
      EmptyRec.vnum[1] := True;
      EmptyRec.vnum[2] := True;
      EmptyRec.vnum[3] := True;
      EmptyRec.options.flabel[26] := 'Mag. Hb';
      EmptyRec.options.flabel[27] := 'C.Star_V';
      EmptyRec.options.flabel[28] := 'C.Star_B';
    end;
    else
      Result := False;
  end;
end;

{ catalog read functions }

function Tcatalog.NewGCat: boolean;
var
  GcatH: TCatHeader;
  info: TCatHdrInfo;
  v: integer;
begin
  Result := False;
  v := 0;
  repeat
    Inc(CurGCat);
    if CurGCat > cfgcat.GCatNum then
    begin
      Result := False;
      exit;
    end;
    if cfgcat.GCatLst[CurGCat - 1].CatOn then
    begin
      SetGcatPath(cfgcat.GCatLst[CurGCat - 1].path, cfgcat.GCatLst[CurGCat - 1].shortname);
      GetGCatInfo(GcatH, info, v, GCatFilter, Result);
    end
    else
      Result := False;
  until Result and (v = VerGCat);
end;

function Tcatalog.GetInfo(path, shortname: string; var magmax: single;
  var v: integer; var version, longname: string): boolean;
var
  GcatH: TCatHeader;
  info: TCatHdrInfo;
begin
  SetGcatPath(path, shortname);
  GetGCatInfo(GcatH, info, v, GCatFilter, Result);
  magmax := GcatH.MagMax;
  version := GcatH.version;
  longname := GcatH.LongName;
end;

function Tcatalog.GetMaxField(path, cat: string): string;
var
  GCatH: TCatHeader;
  info: TCatHdrInfo;
  v: integer;
  ok: boolean;
begin
  SetGcatPath(path, cat);
  GetGCatInfo(GcatH, info, v, GCatFilter, ok);
  case GcatH.FileNum of
    1: Result := '10';
    50: Result := '10';
    184: Result := '7';
    732: Result := '5';
    9537: Result := '3';
    else
      Result := '7';
  end;
end;

function Tcatalog.GetCatType(path, cat: string): integer;
var
  GCatH: TCatHeader;
  info: TCatHdrInfo;
  v: integer;
  ok: boolean;
begin
  SetGcatPath(path, cat);
  GetGCatInfo(GcatH, info, v, GCatFilter, ok);
  if ok then
    Result := v
  else
    Result := -1;
end;

function Tcatalog.GetNebColorSet(path, cat: string): boolean;
var
  GCatH: TCatHeader;
  info: TCatHdrInfo;
  v: integer;
  ok: boolean;
begin
  SetGcatPath(path, cat);
  GetGCatInfo(GcatH, info, v, GCatFilter, ok);
  Result := ok and (v = rtNeb) and (GCatH.flen[14] > 0);
end;

function Tcatalog.GetCatURL(path, cat: string): string;
var
  GCatH: TCatHeader;
  info: TCatHdrInfo;
  v: integer;
  ok: boolean;
begin
  SetGcatPath(path, cat);
  GetGCatInfo(GcatH, info, v, GCatFilter, ok);
  Result := info.caturl;
end;

function Tcatalog.GetCatTxtFile(path, cat: string): string;
var
  GCatH: TCatHeader;
  info: TCatHdrInfo;
  v: integer;
  ok: boolean;
begin
  SetGcatPath(path, cat);
  GetGCatInfo(GcatH, info, v, GCatFilter, ok);
  Result := GCatH.TxtFileName;
end;

function Tcatalog.GetVOstarmag: double;
begin
  SetVOCatpath(slash(VODir));
  Result := GetVOMagmax;
end;

function Tcatalog.GetVOCatS(var rec: GcatRec; filter: boolean = True): boolean;
begin
  Result := False;
  repeat
    ReadVOCat(rec, Result);
    if not Result then
      break;
    if filter and cfgshr.StarFilter and (rec.star.magv > cfgcat.StarMagMax) then
      continue;
    break;
  until not Result;
end;

function Tcatalog.GetVOCatN(var rec: GcatRec; filter: boolean = True): boolean;
var
  i: integer;
begin
  Result := True;
  repeat
    ReadVOCat(rec, Result);
    cfgcat.SampSelectIdent := False;
    if not Result then
      break;
    if not rec.neb.valid[vnMag] then
      rec.neb.mag := rec.options.MagMax;
    if filter and cfgshr.NebFilter and rec.neb.valid[vnMag] and
      (rec.neb.mag < 99) and (rec.neb.mag > cfgcat.NebMagMax) then
      continue;
    if not rec.neb.valid[vnNebunit] then
      rec.neb.nebunit := rec.options.Units;
    if not rec.neb.valid[vnDim1] then
      rec.neb.dim1 := rec.options.Size;
    if filter and cfgshr.NebFilter and (not rec.neb.valid[vnDim1] and
      (rec.neb.dim1 <> 0)) and (rec.neb.dim1 * 60 / rec.neb.nebunit < cfgcat.NebSizeMin) then
      continue;
    if not rec.neb.valid[vnNebtype] then
      rec.neb.nebtype := rec.options.ObjType;
    if (cfgcat.SampSelectedNum > 0) and (cfgcat.SampSelectedTable = vocat.SAMPid) then
    begin
      for i := 0 to cfgcat.SampSelectedNum - 1 do
        if cfgcat.SampSelectedRec[i] = vocat.VOcatrec then
        begin
          cfgcat.SampSelectIdent := (cfgcat.SampSelectFirst and (i = 0));
          if rec.neb.color = $00FF00 then
            rec.neb.color := $FF00FF
          else
            rec.neb.color := $00FF00;
          rec.options.UseColor := 1;
        end;
    end;
    break;
  until not Result;
end;

function Tcatalog.GetUObjN(var rec: GcatRec): boolean;
begin
  Result := False;
  Inc(CurrentUserObj);
  fillchar(Rec, sizeof(GcatRec), 0);
  if CurrentUserObj >= Length(cfgcat.UserObjects) then
    exit;
  if cfgcat.UserObjects[CurrentUserObj].active then
  begin
    rec.options.rectype := rtneb;
    rec.options.Equinox := 2000;
    rec.options.EquinoxJD := jd2000;
    JDCatalog := rec.options.EquinoxJD;
    rec.options.Epoch := 2000;
    rec.options.MagMax := 20;
    rec.options.Size := 1;
    rec.options.Units := 60;
    rec.options.ObjType := 1;
    rec.options.LogSize := 0;
    rec.options.UsePrefix := 0;
    if cfgcat.UserObjects[CurrentUserObj].color > 0 then
      rec.options.UseColor := 1
    else
      rec.options.UseColor := 0;
    rec.options.ShortName := 'UDO';
    rec.options.LongName := rsUserDefinedO;
    rec.options.flabel[lOffset + vnMag] := 'Magn';
    rec.options.flabel[lOffset + vnDim1] := 'Size';
    rec.options.flabel[lOffset + vsComment] := 'Desc';
    rec.neb.valid[vnId] := True;
    rec.neb.valid[vnNebtype] := True;
    rec.neb.valid[vnMag] := True;
    rec.neb.valid[vnDim1] := True;
    rec.neb.valid[vnComment] := True;
    rec.neb.id := cfgcat.UserObjects[CurrentUserObj].oname;
    rec.neb.nebtype := cfgcat.UserObjects[CurrentUserObj].otype;
    rec.neb.color := cfgcat.UserObjects[CurrentUserObj].color;
    rec.neb.mag := cfgcat.UserObjects[CurrentUserObj].mag;
    rec.neb.dim1 := cfgcat.UserObjects[CurrentUserObj].size;
    rec.neb.comment := cfgcat.UserObjects[CurrentUserObj].comment;
    rec.ra := cfgcat.UserObjects[CurrentUserObj].ra;
    rec.Dec := cfgcat.UserObjects[CurrentUserObj].Dec;
    Result := True;
  end
  else
  begin
    Result := GetUObjN(rec);
  end;
end;

procedure Tcatalog.FormatGCatS(var rec: GcatRec);
var
  bsccat, flam, bayer: boolean;
begin
  rec.ra := deg2rad * rec.ra;
  rec.Dec := deg2rad * rec.Dec;
  rec.star.pmra := deg2rad * rec.star.pmra / 3600;
  rec.star.pmdec := deg2rad * rec.star.pmdec / 3600;
  rec.star.valid[vsGreekSymbol] := False;
  bsccat := (rec.vstr[3] and (trim(rec.options.flabel[lOffsetStr + 3]) = 'CommonName')) and
    (rec.vstr[4] and (trim(rec.options.flabel[lOffsetStr + 4]) = 'Fl')) and
    (rec.vstr[5] and (trim(rec.options.flabel[lOffsetStr + 5]) = 'Bayer')) and
    (rec.vstr[6] and (trim(rec.options.flabel[lOffsetStr + 6]) = 'Const'));
  if bsccat then
  begin
    // remove fields used only for index
    rec.vstr[8] := False;
    rec.vstr[10] := False;
    flam := (trim(rec.str[4]) <> '');
    rec.vstr[4] := flam;
    bayer := (trim(rec.str[5]) <> '');
    rec.vstr[5] := bayer;
    if bayer then
    begin
      rec.star.greeksymbol := GreekLetter(rec.str[5]);
      if rec.star.greeksymbol <> '' then
        rec.star.valid[vsGreekSymbol] := True
      else
        bayer := False;
    end;
    if (not bayer) and flam then
    begin
      rec.star.greeksymbol := trim(rec.str[4]);
      if rec.star.greeksymbol <> '' then
        rec.star.valid[vsGreekSymbol] := True
      else
        flam := False;
    end;
    rec.options.flabel[lOffsetStr + 3] := rsCommonName;
    rec.vstr[3] := (trim(rec.str[3]) <> '');
    if flam and (not bayer) then
      rec.star.id := copy(trim(rec.str[4]) + blank15, 1, 3)
    else
      rec.star.id := '';
    if bayer or flam then
    begin
      rec.star.id := rec.star.id + blank + trim(rec.str[5]) + blank + trim(rec.str[6]);
      rec.star.valid[vsId] := True;
    end;
  end;
end;

function Tcatalog.GetGCatS(var rec: GcatRec): boolean;
begin
  Result := True;
  repeat
    ReadGCat(rec, Result);
    if not Result then
      break;
    if cfgshr.StarFilter and (rec.star.magv > cfgcat.StarMagMax) then
    begin
      if GCatFilter then
        NextGCat(Result);
      if Result then
        continue;
    end;
    FormatGCatS(rec);
    break;
  until not Result;
end;

function Tcatalog.GetGCatV(var rec: GcatRec): boolean;
begin
  Result := True;
  repeat
    ReadGCat(rec, Result);
    if not Result then
      break;
    if cfgshr.StarFilter and (rec.variable.magmax > cfgcat.StarMagMax) then
    begin
      if GCatFilter then
        NextGCat(Result);
      if Result then
        continue;
    end;
    rec.ra := deg2rad * rec.ra;
    rec.Dec := deg2rad * rec.Dec;
    break;
  until not Result;
end;

function Tcatalog.GetGCatD(var rec: GcatRec): boolean;
begin
  Result := True;
  repeat
    ReadGCat(rec, Result);
    if not Result then
      break;
    if cfgshr.StarFilter and (rec.double.mag1 > cfgcat.StarMagMax) then
    begin
      if GCatFilter then
        NextGCat(Result);
      if Result then
        continue;
    end;
    rec.ra := deg2rad * rec.ra;
    rec.Dec := deg2rad * rec.Dec;
    break;
  until not Result;
end;

procedure Tcatalog.FormatGCatN(var rec: GcatRec);
var
  buf: string;
  i: integer;
begin
  rec.ra := deg2rad * rec.ra;
  rec.Dec := deg2rad * rec.Dec;
  // Messier object
  if (MessierStrPos > 0) then
  begin
    if (trim(rec.str[MessierStrPos]) > '') then
    begin
      // swap primary id
      buf := rec.neb.id;
      rec.neb.id := trim(rec.options.flabel[16]) + blank + trim(rec.str[MessierStrPos]);
      rec.neb.messierobject := True;
      rec.str[MessierStrPos] := buf;
      rec.options.flabel[15 + MessierStrPos] := 'Id';
    end
    else
      rec.vstr[MessierStrPos] := False;
    // replace missing magnitude
    if (rec.neb.mag>90)and(rec.options.ShortName = 'ONGC') then begin
      for i:=1 to 4 do begin
       if rec.vnum[i] and (rec.num[i]>0) and (rec.num[i]<90) then begin
         rec.neb.mag:=rec.num[i];
         rec.neb.valid[vnMag]:=true;
         rec.options.flabel[lOffset + vsMagv+1]:=rec.options.flabel[lOffsetNum + i];
         break;
       end;
      end;
    end;
  end;
  // Leda catalog
  if PgcLeda and (rec.options.ShortName = 'PGC ') then
  begin
    rec.neb.id := 'PGC' + trim(rec.neb.id);
    i := length(trim(rec.str[1]));
    if (i > 0) and (i < 15) then
    begin
      // swap primary id
      buf := rec.neb.id;
      rec.neb.id := trim(rec.str[1]);
      rec.str[1] := buf;
      rec.options.flabel[15 + 1] := 'Id';
    end;
  end;
end;

function Tcatalog.GetGCatN(var rec: GcatRec): boolean;
begin
  Result := True;
  repeat
    ReadGCat(rec, Result);
    if not Result then
      break;
    FormatGCatN(rec);
    if not rec.neb.valid[vnNebtype] then
      rec.neb.nebtype := rec.options.ObjType;
    if (not (cfgshr.NoFilterMessier and (MessierStrPos > 0))) and
      (not (cfgshr.NoFilterMagBright and ((rec.neb.nebtype=5)or(rec.neb.nebtype=6)))) and
      cfgshr.NebFilter and rec.neb.valid[vnMag] and (rec.neb.mag > cfgcat.NebMagMax) then
    begin
      if GCatFilter then
        NextGCat(Result);
      if Result then
        continue;
    end
    else if (not (cfgshr.NoFilterMessier and rec.neb.messierobject)) and
      (not (cfgshr.NoFilterMagBright and ((rec.neb.nebtype=5)or(rec.neb.nebtype=6)))) and
      cfgshr.NebFilter and (rec.neb.mag > cfgcat.NebMagMax) then
      continue;
    if not rec.neb.valid[vnNebunit] then
      rec.neb.nebunit := rec.options.Units;
    if not rec.neb.valid[vnDim1] then
      rec.neb.dim1 := rec.options.Size;
    if (not (cfgshr.NoFilterMessier and rec.neb.messierobject)) and
      cfgshr.NebFilter and rec.neb.valid[vnDim1] and
      (rec.neb.dim1 * 60 / rec.neb.nebunit < cfgcat.NebSizeMin) then
      continue;
    if rec.neb.valid[vnColor] then
    begin
      rec.options.UseColor := 1;
    end
    else
    begin
      if (CurGCat > 0) and cfgcat.GCatLst[CurGCat - 1].ForceColor then
      begin
        rec.options.UseColor := 1;
        rec.neb.color := cfgcat.GCatLst[CurGCat - 1].col;
      end;
    end;
    break;
  until not Result;
end;

function Tcatalog.GetGCatL(var rec: GcatRec): boolean;
begin
  Result := True;
  repeat
    ReadGCat(rec, Result);
    if not Result then
      break;
    // no line filter at the moment
    rec.ra := deg2rad * rec.ra;
    rec.Dec := deg2rad * rec.Dec;
    if cfgcat.GCatLst[CurGCat - 1].ForceColor then
    begin
      rec.outlines.valid[vlLinecolor] := True;
      rec.outlines.linecolor := cfgcat.GCatLst[CurGCat - 1].col;
    end;
    break;
  until not Result;
end;

procedure Tcatalog.FindNGCat(id: shortstring; var ar, de: double;
  var ok: boolean; ctype: integer = -1);
var
  H: TCatHeader;
  info: TCatHdrInfo;
  rec: GCatrec;
  i, version: integer;
  iid: string;
  catok: boolean;
begin
  ok := False;
  iid := id;
  for i := 0 to cfgcat.GCatNum - 1 do
  begin
    if ((ctype = -1) or (cfgcat.GCatLst[i].cattype = ctype)) then
    begin
      SetGcatPath(cfgcat.GCatLst[i].path, cfgcat.GCatLst[i].shortname);
      GetGCatInfo(H, info, version, GCatFilter, catok);
      if catok and fileexists(slash(cfgcat.GCatLst[i].path) +
        cfgcat.GCatLst[i].shortname + '.ixr') then
      begin
        FindNumGcatRec(cfgcat.GCatLst[i].path, cfgcat.GCatLst[i].shortname, iid,
          H.ixkeylen, rec, ok);
        if ok then
        begin
          ar := rec.ra / 15;
          de := rec.Dec;
          if ctype = rtStar then
            FormatGCatS(rec)
          else if ctype = rtNeb then
            FormatGCatN(rec)
          else
          begin
            rec.ra := deg2rad * rec.ra;
            rec.Dec := deg2rad * rec.Dec;
          end;
          FFindId := id;
          FFindRecOK := True;
          FFindRec := rec;
          break;
        end;
      end
      else if catok and fileexists(slash(cfgcat.GCatLst[i].path) +
        cfgcat.GCatLst[i].shortname + '.idx') then
      begin
        FindNumGcat(cfgcat.GCatLst[i].path, cfgcat.GCatLst[i].shortname, iid, H.ixkeylen,
          ar, de, ok);
        if ok then
          break;
      end;
    end;
  end;
end;

function Tcatalog.GetBSC(var rec: GcatRec): boolean;
var
  lin: BSCrec;
  i: integer;
begin
  rec := EmptyRec;
  Result := True;
  repeat
    ReadBSC(lin, Result);
    if not Result then
      break;
    rec.star.magv := lin.mv / 100;
    if cfgshr.StarFilter and (rec.star.magv > cfgcat.StarMagMax) then
    begin
      NextBSC(Result);
      if Result then
        continue;
    end;
    break;
  until not Result;
  if Result then
  begin
    rec.ra := deg2rad * lin.ar / 100000;
    rec.Dec := deg2rad * lin.de / 100000;
    rec.star.b_v := lin.b_v / 100;
    rec.star.pmra := deg2rad * lin.pmar / 1000 / 3600;  // mas -> rad
    rec.star.pmdec := deg2rad * lin.pmde / 1000 / 3600;
    rec.star.sp := lin.sp;
    if (lin.flam > 0) and (trim(lin.bayer) = '') then
      rec.star.id := copy(IntToStr(lin.flam) + blank15, 1, 3)
    else
      rec.star.id := '';
    rec.star.id := rec.star.id + blank + lin.bayer + blank + lin.cons;
    rec.str[1] := IntToStr(lin.bs);
    if lin.hd > 0 then
      rec.str[2] := IntToStr(lin.hd)
    else
      rec.str[2] := '';
    if trim(lin.bayer) <> '' then
    begin
      rec.star.greeksymbol := GreekLetter(lin.bayer);
      rec.star.valid[vsGreekSymbol] := True;
    end
    else if lin.flam > 0 then
    begin
      rec.star.greeksymbol := IntToStr(lin.flam);
      rec.star.valid[vsGreekSymbol] := True;
    end;
    rec.str[3] := '';
    for i := 0 to cfgshr.StarNameNum - 1 do
    begin
      if cfgshr.StarNameHR[i] = lin.bs then
      begin
        rec.str[3] := cfgshr.StarName[i];
        rec.vstr[3] := True;
        break;
      end;
    end;
    i := pos(';', rec.str[3]);
    if i > 0 then
      rec.str[3] := copy(rec.str[3], 1, i - 1);
    if lin.flam > 0 then
    begin
      rec.str[4] := IntToStr(lin.flam);
      rec.vstr[4] := True;
    end;
    if trim(lin.bayer) <> '' then
    begin
      rec.str[5] := trim(lin.bayer);
      rec.vstr[5] := True;
    end;
  end;
end;

function Tcatalog.GetSky2000(var rec: GcatRec): boolean;
var
  lin: SKYrec;
  n, s: string;
  p: integer;
begin
  rec := EmptyRec;
  Result := True;
  repeat
    ReadSKY(lin, Result);
    if not Result then
      break;
    rec.star.magv := lin.mv / 100;
    if cfgshr.StarFilter and (rec.star.magv > cfgcat.StarMagMax) then
    begin
      NextSKY(Result);
      if Result then
        continue;
    end;
    break;
  until not Result;
  if Result then
  begin
    rec.ra := deg2rad * lin.ar / 100000;
    rec.Dec := deg2rad * lin.de / 100000;
    rec.star.b_v := lin.b_v / 100;
    rec.star.pmra := deg2rad * lin.pmar / 1000 / 3600;
    rec.star.pmdec := deg2rad * lin.pmde / 1000 / 3600;
    rec.star.sp := lin.sp;
    if lin.dm <> 0 then
    begin
      if lin.dm >= 0 then
        s := '+'
      else
        s := '-';
      n := IntToStr(abs(lin.dm));
      p := length(n) - 4;
      if p > 0 then
        n := s + copy(n, 1, p - 1) + '.' + copy(n, p, p + 5)
      else
        n := s + '0.' + padzeros(n, 5);
      n := blank + lin.dm_cat + n;
    end
    else
      n := '';
    rec.star.id := n;
    if lin.sep > 0 then
    begin
      rec.num[1] := lin.sep / 100;
      rec.num[2] := lin.d_m / 100;
    end
    else
    begin
      rec.num[1] := 0;
      rec.num[2] := 0;
      rec.vnum[1] := False;
      rec.vnum[2] := False;
    end;
    if lin.hd > 0 then
      rec.str[1] := IntToStr(lin.hd)
    else
      rec.str[1] := '';
    if lin.sao > 0 then
      rec.str[2] := IntToStr(lin.sao)
    else
      rec.str[2] := '';
  end;
end;

function Tcatalog.GetTYC(var rec: GcatRec): boolean;
var
  lin: TYCrec;
  smnum: string;
begin
  rec := EmptyRec;
  Result := True;
  repeat
    ReadTYC(lin, smnum, Result);
    if not Result then
      break;
    rec.star.magv := lin.vt / 100;
    if rec.star.magv = 99 then
      rec.star.magv := lin.bt / 100;
    if cfgshr.StarFilter and (rec.star.magv > cfgcat.StarMagMax) then
    begin
      NextTYC(Result);
      if Result then
        continue;
    end;
    break;
  until not Result;
  if Result then
  begin
    rec.ra := deg2rad * lin.ar / 100000;
    rec.Dec := deg2rad * lin.de / 100000;
    rec.star.magb := lin.bt / 100;
    rec.star.b_v := lin.b_v / 100;
    rec.star.pmra := deg2rad * lin.pmar / 1000 / 3600;
    rec.star.pmdec := deg2rad * lin.pmde / 1000 / 3600;
    rec.star.id := IntToStr(lin.gscz) + '-' + IntToStr(lin.gscn) + '-' + IntToStr(lin.tycn);
  end;
end;

procedure Tcatalog.FormatTYC2(lin: TY2rec; var rec: GcatRec);
begin
  rec.ra := deg2rad * lin.ar;
  rec.Dec := deg2rad * lin.de;
  rec.star.magv := lin.vt;
  if rec.star.magv > 30 then
    rec.star.magv := lin.bt;
  rec.star.magb := lin.bt;
  if (lin.vt < 30) and (lin.bt < 30) then
    rec.star.b_v := 0.850 * (lin.bt - lin.vt)
  else
    rec.star.b_v := 0;
  rec.star.pmra := deg2rad * lin.pmar / 1000 / 3600;
  rec.star.pmdec := deg2rad * lin.pmde / 1000 / 3600;
  rec.star.id := IntToStr(lin.gscz) + '-' + IntToStr(lin.gscn) + '-' + IntToStr(lin.tycn);
end;

function Tcatalog.GetTYC2(var rec: GcatRec): boolean;
var
  lin: TY2rec;
  smnum: string;
  ma: double;
begin
  rec := EmptyRec;
  Result := True;
  repeat
    ReadTY2(lin, smnum, Result);
    if not Result then
      break;
    ma := lin.vt;
    if ma > 30 then
      ma := lin.bt;
    if cfgshr.StarFilter and (ma > cfgcat.StarMagMax) then
      continue;
    break;
  until not Result;
  if Result then
  begin
    FormatTYC2(lin, rec);
  end;
end;

procedure Tcatalog.FindTYC2(id: string; var ra, Dec: double; var ok: boolean);
var
  lin: TY2rec;
  rec: GCatrec;
begin
  InitRec(tyc2);
  rec := EmptyRec;
  FindNumTYC2(id, lin, ok);
  if ok then
  begin
    FormatTYC2(lin, rec);
    ra := rad2deg * rec.ra / 15;
    Dec := rad2deg * rec.Dec;
    FFindId := 'TYC ' + trim(id);
    FFindRecOK := True;
    FFindRec := rec;
  end;
end;

function Tcatalog.GetTIC(var rec: GcatRec): boolean;
var
  lin: TICrec;
  smnum: string;
begin
  rec := EmptyRec;
  Result := True;
  repeat
    ReadTIC(lin, smnum, Result);
    if not Result then
      break;
    rec.star.magv := lin.mv / 100;
    if lin.mb >= 10000 then
    begin
      rec.num[1] := 1;
      rec.star.magb := (lin.mb - 10000) / 100;
    end
    else
    begin
      rec.num[1] := 0;
      rec.star.magb := lin.mb / 100;
    end;
    if rec.star.magv > 90 then
      rec.star.magv := rec.star.magb;
    if cfgshr.StarFilter and (rec.star.magv > cfgcat.StarMagMax) then
    begin
      NextTIC(Result);
      if Result then
        continue;
    end;
    break;
  until not Result;
  if Result then
  begin
    rec.ra := deg2rad * lin.ar / 100000;
    rec.Dec := deg2rad * lin.de / 100000;
    if (rec.star.magv < 90) and (rec.star.magb < 90) then
      rec.star.b_v := rec.star.magb - rec.star.magv
    else
      rec.star.b_v := 99;
    rec.star.id := IntToStr(lin.gscz) + '-' + IntToStr(lin.gscn);
  end;
end;

function Tcatalog.GetGSCF(var rec: GcatRec): boolean;
var
  lin: GSCFrec;
  smnum: string;
begin
  rec := EmptyRec;
  Result := True;
  repeat
    ReadGSCF(lin, smnum, Result);
    if not Result then
      break;
    rec.star.magv := lin.m;
    if cfgshr.StarFilter and (rec.star.magv > cfgcat.StarMagMax) then
      continue;
    break;
  until not Result;
  if Result then
  begin
    rec.ra := deg2rad * lin.ar;
    rec.Dec := deg2rad * lin.de;
    rec.star.id := smnum + '-' + IntToStr(lin.gscn);
    rec.num[1] := lin.pe;
    rec.num[2] := lin.me;
    rec.str[1] := IntToStr(lin.mb);
    rec.str[2] := IntToStr(lin.cl);
    rec.str[3] := lin.mult;
    rec.str[4] := lin.plate;
  end;
end;

function Tcatalog.GetGSCC(var rec: GcatRec): boolean;
var
  lin: GSCCrec;
  smnum: string;
begin
  rec := EmptyRec;
  Result := True;
  repeat
    ReadGSCC(lin, smnum, Result);
    if not Result then
      break;
    rec.star.magv := lin.m;
    if cfgshr.StarFilter and (rec.star.magv > cfgcat.StarMagMax) then
      continue;
    break;
  until not Result;
  if Result then
  begin
    rec.ra := deg2rad * lin.ar;
    rec.Dec := deg2rad * lin.de;
    rec.star.id := smnum + '-' + IntToStr(lin.gscn);
    rec.num[1] := lin.pe;
    rec.num[2] := lin.me;
    rec.str[1] := IntToStr(lin.mb);
    rec.str[2] := IntToStr(lin.cl);
    rec.str[3] := lin.mult;
    rec.str[4] := lin.plate;
  end;
end;

function Tcatalog.GetGSC(var rec: GcatRec): boolean;
var
  lin: GSCrec;
  smnum: string;
begin
  rec := EmptyRec;
  Result := True;
  repeat
    ReadGSC(lin, smnum, Result);
    if not Result then
      break;
    rec.star.magv := lin.m / 100;
    if cfgshr.StarFilter and (rec.star.magv > cfgcat.StarMagMax) then
    begin
      NextGSC(Result);
      if Result then
        continue;
    end;
    break;
  until not Result;
  if Result then
  begin
    rec.ra := deg2rad * lin.ar / 100000;
    rec.Dec := deg2rad * lin.de / 100000;
    rec.star.id := smnum + '-' + IntToStr(lin.gscn);
    rec.num[1] := lin.pe;
    rec.num[2] := lin.me;
    rec.str[1] := IntToStr(lin.mb);
    rec.str[2] := IntToStr(lin.cl);
    rec.str[3] := lin.mult;
  end;
end;

function Tcatalog.GetUSNOA(var rec: GcatRec): boolean;
var
  lin: USNOArec;
begin
  rec := EmptyRec;
  Result := True;
  repeat
    ReadUSNOA(lin, Result);
    if not Result then
      break;
    rec.star.magv := lin.mr;
    if cfgshr.StarFilter and (rec.star.magv > cfgcat.StarMagMax) then
      continue;
    if (not cfgcat.UseUSNOBrightStars) and (rec.star.magv < 5) then
      continue;
    break;
  until not Result;
  if Result then
  begin
    rec.ra := deg2rad * lin.ar * 15;
    rec.Dec := deg2rad * lin.de;
    if lin.mr > 25 then
      lin.mr := lin.mb;
    if (lin.mb > 25) or (lin.mb = 0) then
      lin.mb := lin.mr;
    rec.star.magv := lin.mr;
    rec.star.magb := lin.mb;
    rec.star.b_v := rec.star.magb - (rec.star.magb + rec.star.magv) / 2;  // usno-a2.0
    rec.star.id := lin.id;
    rec.str[1] := IntToStr(lin.field);
    rec.str[2] := IntToStr(lin.q);
    rec.str[3] := IntToStr(lin.s);
  end;
end;

function Tcatalog.GetUSNOB(var rec: GcatRec): boolean;
var
  lin: USNOBrec;
begin
  rec := EmptyRec;
  Result := True;
  repeat
    ReadUSNOB(lin, Result);
    if not Result then
      break;
    if (lin.mr1 > 25) or (lin.mr1 = 0) then
    begin
      lin.mr1 := lin.mr2;
      rec.options.flabel[4] := 'MagR2';
    end;
    if (lin.mr1 > 25) or (lin.mr1 = 0) then
    begin
      lin.mr1 := lin.mb1;
      rec.options.flabel[4] := 'MagB1';
    end;
    if (lin.mr1 > 25) or (lin.mr1 = 0) then
    begin
      lin.mr1 := lin.mb2;
      rec.options.flabel[4] := 'MagB2';
    end;
    if (lin.mr1 > 25) or (lin.mr1 = 0) then
    begin
      lin.mr1 := 99;
      rec.options.flabel[4] := 'No mag.';
    end;
    if cfgshr.StarFilter and (lin.mr1 > cfgcat.StarMagMax) then
      continue;
    break;
  until not Result;
  if Result then
  begin
    rec.ra := deg2rad * lin.ra;
    rec.Dec := deg2rad * lin.de;
    rec.star.magv := lin.mr1;
    rec.star.magb := lin.mb1;
    rec.num[1] := lin.mr2;
    rec.num[2] := lin.mb2;
    rec.star.pmra := deg2rad * lin.pmra / 3600;
    rec.star.pmdec := deg2rad * lin.pmde / 3600;
    rec.star.id := lin.id;
  end;
end;

function Tcatalog.GetMCT(var rec: GcatRec): boolean;
var
  lin: MCTrec;
begin
  rec := EmptyRec;
  Result := True;
  repeat
    ReadMCT(lin, Result);
    if not Result then
      break;
    rec.star.magv := lin.mr;
    if cfgshr.StarFilter and (rec.star.magv > cfgcat.StarMagMax) then
      continue;
    break;
  until not Result;
  if Result then
  begin
    rec.ra := deg2rad * lin.ar * 15;
    rec.Dec := deg2rad * lin.de;
    rec.star.magb := lin.mb;
    rec.star.b_v := lin.mb - (lin.mb + lin.mr) / 2;
    rec.star.id := '';
  end;
end;

function Tcatalog.GetDSbase(var rec: GcatRec): boolean;
var
  lin: DSrec;
begin
  rec := EmptyRec;
  Result := True;
  repeat
    ReadDSbase(lin, Result);
    if not Result then
      break;
    rec.star.magv := lin.mag;
    if cfgshr.StarFilter and (rec.star.magv > cfgcat.StarMagMax) then
      continue;
    break;
  until not Result;
  if Result then
  begin
    rec.ra := deg2rad * lin.ra * 15;
    rec.Dec := deg2rad * lin.Dec;
    rec.star.id := '';
  end;
end;

function Tcatalog.GetDSTyc(var rec: GcatRec): boolean;
var
  lin: DSrec;
begin
  rec := EmptyRec;
  Result := True;
  repeat
    ReadDSTyc(lin, Result);
    if not Result then
      break;
    rec.star.magv := lin.mag;
    if cfgshr.StarFilter and (rec.star.magv > cfgcat.StarMagMax) then
    begin
      NextDSTyc(Result);
      if Result then
        continue;
    end;
    break;
  until not Result;
  if Result then
  begin
    rec.ra := deg2rad * lin.ra * 15;
    rec.Dec := deg2rad * lin.Dec;
    rec.star.id := '';
  end;
end;

function Tcatalog.GetDSGsc(var rec: GcatRec): boolean;
var
  lin: DSrec;
begin
  rec := EmptyRec;
  Result := True;
  repeat
    ReadDSGsc(lin, Result);
    if not Result then
      break;
    rec.star.magv := lin.mag;
    if cfgshr.StarFilter and (rec.star.magv > cfgcat.StarMagMax) then
    begin
      NextDSGsc(Result);
      if Result then
        continue;
    end;
    break;
  until not Result;
  if Result then
  begin
    rec.ra := deg2rad * lin.ra * 15;
    rec.Dec := deg2rad * lin.Dec;
    rec.star.id := '';
  end;
end;

procedure Tcatalog.FormatGCVS(lin: GCVrec; var rec: GcatRec);
begin
  rec.ra := deg2rad * lin.ar / 100000;
  rec.Dec := deg2rad * lin.de / 100000;
  rec.variable.magmin := lin.min / 100;
  rec.variable.magmax := lin.max / 100;
  rec.variable.id := lin.gcvs;
  str(lin.num: 7, rec.str[1]);
  if copy(lin.vartype, 7, 3) = 'NSV' then
    rec.str[1] := 'NSV' + rec.str[1];
  rec.variable.period := lin.period;
  rec.variable.vartype := stringreplace(lin.vartype, ':', blank, [rfReplaceAll]);
  rec.variable.magcode := lin.mcode;
  rec.str[2] := lin.lmin + blank + lin.lmax;
end;

function Tcatalog.GetGCVS(var rec: GcatRec): boolean;
var
  lin: GCVrec;
  ma: double;
begin
  rec := EmptyRec;
  Result := True;
  repeat
    ReadGCV(lin, Result);
    if not Result then
      break;
    ma := lin.max / 100;
    if cfgshr.StarFilter and (ma > cfgcat.StarMagMax) then
      continue;
    if (not cfgcat.UseGSVSIr) and (lin.mcode >= 'J') and (lin.mcode <= 'N') then
      continue;
    break;
  until not Result;
  if Result then
  begin
    FormatGCVS(lin, rec);
  end;
end;

procedure Tcatalog.FindGCVS(id: string; var ra, Dec: double; var ok: boolean);
var
  lin: GCVrec;
  rec: GCatrec;
begin
  InitRec(gcvs);
  rec := EmptyRec;
  FindNumGCVS(id, lin, ok);
  if ok then
  begin
    FormatGCVS(lin, rec);
    ra := rad2deg * rec.ra / 15;
    Dec := rad2deg * rec.Dec;
    FFindId := id;
    FFindRecOK := True;
    FFindRec := rec;
  end;
end;


procedure Tcatalog.FormatWDS(lin: WDSrec; var rec: GcatRec);
var
  n, s: string;
  p: integer;
begin
  rec.ra := deg2rad * lin.ar / 100000;
  rec.Dec := deg2rad * lin.de / 100000;
  if (lin.pa2 <> -999) and (lin.sep2 > 0) and (lin.sep2 < 9999) then
  begin
    rec.double.epoch := lin.date2;
    rec.double.pa := lin.pa2;
    rec.double.sep := lin.sep2 / 10;
  end
  else
  begin
    rec.double.epoch := lin.date1;
    rec.double.pa := lin.pa1;
    rec.double.sep := lin.sep1 / 10;
  end;
  if rec.double.sep>999 then rec.double.sep:=0;
  rec.double.mag1 := lin.ma / 100;
  rec.double.mag2 := lin.mb / 100;
  rec.double.id := lin.id;
  rec.double.compname := lin.comp;
  rec.double.sp1 := lin.sp;
  rec.double.comment := lin.note;
  if lin.dm <> 0 then
  begin
    if lin.dm >= 0 then
      s := '+'
    else
      s := '-';
    n := IntToStr(abs(lin.dm));
    p := length(n) - 4;
    if p > 0 then
      n := s + copy(n, 1, p - 1) + '.' + copy(n, p, p + 5)
    else
      n := s + '0.' + padzeros(n, 5);
    rec.double.comment := rec.double.comment + ' BD' + n;
  end;
end;

function Tcatalog.GetWDS(var rec: GcatRec): boolean;
var
  lin: WDSrec;
  ma: double;
begin
  rec := EmptyRec;
  Result := True;
  repeat
    ReadWDS(lin, Result);
    if not Result then
      break;
    ma := lin.ma / 100;
    if cfgshr.StarFilter and (ma > cfgcat.StarMagMax) then
      continue;
    break;
  until not Result;
  if Result then
  begin
    FormatWDS(lin, rec);
  end;
end;

procedure Tcatalog.FindWDS(id: string; var ra, Dec: double; var ok: boolean);
var
  lin: WDSrec;
  rec: GCatrec;
begin
  InitRec(wds);
  rec := EmptyRec;
  FindNumWDS(id, lin, ok);
  if ok then
  begin
    FormatWDS(lin, rec);
    ra := rad2deg * rec.ra / 15;
    Dec := rad2deg * rec.Dec;
    FFindId := id;
    FFindRecOK := True;
    FFindRec := rec;
  end;
end;

procedure Tcatalog.FormatSAC(lin: SACrec; var rec: GcatRec);
begin
  rec.ra := deg2rad * lin.ar;
  rec.Dec := deg2rad * lin.de;
  rec.neb.messierobject := (copy(lin.nom1, 1, 2) = 'M ');
  rec.neb.dim1 := lin.s1;
  rec.neb.mag := lin.ma;
  if trim(lin.typ) = 'Drk' then
    rec.neb.mag := 11;
  rec.neb.nebtype := -1;
  if trim(lin.typ) = 'Gx' then
    rec.neb.nebtype := 1
  else if trim(lin.typ) = 'OC' then
    rec.neb.nebtype := 2
  else if trim(lin.typ) = 'Gb' then
    rec.neb.nebtype := 3
  else if trim(lin.typ) = 'Pl' then
    rec.neb.nebtype := 4
  else if trim(lin.typ) = 'Nb' then
    rec.neb.nebtype := 5
  else if trim(lin.typ) = 'C+N' then
    rec.neb.nebtype := 6
  else if trim(lin.typ) = '*' then
    rec.neb.nebtype := 7
  else if trim(lin.typ) = 'D*' then
    rec.neb.nebtype := 8
  else if trim(lin.typ) = '***' then
    rec.neb.nebtype := 9
  else if trim(lin.typ) = 'Ast' then
    rec.neb.nebtype := 10
  else if trim(lin.typ) = 'Kt' then
    rec.neb.nebtype := 11
  else if trim(lin.typ) = 'Gcl' then
    rec.neb.nebtype := 12
  else if trim(lin.typ) = 'Drk' then
    rec.neb.nebtype := 13
  else if trim(lin.typ) = '?' then
    rec.neb.nebtype := 0
  else if lin.typ = '   ' then
    rec.neb.nebtype := 0
  else if trim(lin.typ) = '-' then
    rec.neb.nebtype := -1
  else if trim(lin.typ) = 'PD' then
    rec.neb.nebtype := -1;
  if (rec.neb.mag > 70) or (rec.neb.mag < -70) then
    rec.neb.mag := 99;    // undefined magnitude
  rec.neb.dim2 := lin.s2;
  if rec.neb.nebtype = 4 then
  begin // arc second units for PN
    rec.neb.dim1 := rec.neb.dim1 * 60;
    rec.neb.dim2 := rec.neb.dim2 * 60;
    rec.neb.valid[vnNebunit] := True;
    rec.neb.nebunit := 3600;
  end;
  if lin.pa = 255 then
    rec.neb.pa := 90
  else
    rec.neb.pa := lin.pa;
  rec.neb.sbr := lin.sbr;
  rec.neb.id := lin.nom1;
  rec.str[1] := lin.nom2;
  rec.str[2] := lin.cons;
  rec.neb.morph := lin.clas;
  rec.neb.comment := lin.desc;
end;

function Tcatalog.GetSAC(var rec: GcatRec): boolean;
var
  lin: SACrec;
  nebunit: integer;
begin
  rec := EmptyRec;
  Result := True;
  repeat
    ReadSAC(lin, Result);
    if not Result then
      break;
    rec.neb.messierobject := (copy(lin.nom1, 1, 2) = 'M ');
    rec.neb.dim1 := lin.s1;
    if rec.neb.valid[vnNebunit] then
      nebunit := rec.neb.nebunit
    else
      nebunit := rec.options.Units;
    if cfgshr.NebFilter and (not (cfgshr.NoFilterMessier and rec.neb.messierobject)) and
      ((rec.neb.dim1 * 60 / nebunit) < cfgcat.NebSizeMin) then
      continue;
    rec.neb.mag := lin.ma;
    if trim(lin.typ) = 'Drk' then
      rec.neb.mag := 11;  // also filter dark nebulae
    if cfgshr.NebFilter and (not (cfgshr.NoFilterMessier and rec.neb.messierobject)) and
      (not (cfgshr.NoFilterMagBright and ((trim(lin.typ)='Nb')or(trim(lin.typ)='C+N')))) and
      (rec.neb.mag > cfgcat.NebMagMax) then
      continue;
    if cfgshr.BigNebFilter and (rec.neb.dim1 >= cfgshr.BigNebLimit) and
      (trim(lin.typ) <> 'Gx') then
      continue; // filter big object (only open cluster)
    break;
  until not Result;
  if Result then
  begin
    FormatSAC(lin, rec);
  end;
end;

procedure Tcatalog.FindSAC(id: string; var ra, Dec: double; var ok: boolean);
var
  lin: SACrec;
  rec: GCatrec;
begin
  InitRec(sac);
  rec := EmptyRec;
  FindNumSAC(id, lin, ok);
  if ok then
  begin
    FormatSAC(lin, rec);
    ra := rad2deg * rec.ra / 15;
    Dec := rad2deg * rec.Dec;
    FFindId := rec.neb.id;
    FFindRecOK := True;
    FFindRec := rec;
  end;
end;

function Tcatalog.IsNGCpath(path: string): boolean;
begin
  Result := FileExists(slash(path) + 'ongc.hdr');
end;

function Tcatalog.OpenNGC: boolean;
var
  GcatH: TCatHeader;
  info: TCatHdrInfo;
  v: integer;
begin
  CurGCat := 0;
  SetGcatPath(cfgcat.nebcatpath[ngc - BaseNeb], 'ongc');
  GetGCatInfo(GcatH, info, v, GCatFilter, Result);
  CheckMessierColumn;
  if Result then
    Result := (v = rtNeb);
  if Result then
    OpenGCatWin(Result);
end;

procedure Tcatalog.OpenNGCPos(ar1, ar2, de1, de2: double; var ok: boolean);
var
  GcatH: TCatHeader;
  info: TCatHdrInfo;
  v: integer;
begin
  CurGCat := 0;
  SetGcatPath(cfgcat.nebcatpath[ngc - BaseNeb], 'ongc');
  GetGCatInfo(GcatH, info, v, GCatFilter, ok);
  CheckMessierColumn;
  if ok then
    ok := (v = rtNeb);
  if ok then
    OpenGCat(ar1, ar2, de1, de2, ok);
end;

function Tcatalog.CloseNGC: boolean;
begin
  CloseGcat;
  Result := True;
end;

function Tcatalog.GetNGC(var rec: GcatRec): boolean;
begin
  Result := GetGCatN(rec);
end;

procedure Tcatalog.FindNGC(id: shortstring; var ar, de: double; var ok: boolean);
var
  H: TCatHeader;
  info: TCatHdrInfo;
  rec: GCatrec;
  version: integer;
  iid: string;
begin
  ok := False;
  iid := id;
  if fileexists(slash(cfgcat.nebcatpath[ngc - BaseNeb]) + 'ongc' + '.ixr') then
  begin
    SetGcatPath(cfgcat.nebcatpath[ngc - BaseNeb], 'ongc');
    GetGCatInfo(H, info, version, GCatFilter, ok);
    CheckMessierColumn;
    if ok then
      FindNumGcatRec(cfgcat.nebcatpath[ngc - BaseNeb], 'ongc', iid, H.ixkeylen, rec, ok);
    if ok then
    begin
      ar := rec.ra / 15;
      de := rec.Dec;
      FormatGCatN(rec);
      FFindId := id;
      FFindRecOK := True;
      FFindRec := rec;
    end;
  end
  else
    ok := False;
end;

function Tcatalog.IsSH2path(path: string): boolean;
begin
  Result := FileExists(slash(path) + 'sh 2.hdr');
end;

function Tcatalog.OpenSH2: boolean;
var
  GcatH: TCatHeader;
  info: TCatHdrInfo;
  v: integer;
begin
  CurGCat := 0;
  MessierStrPos := -1;
  SetGcatPath(cfgcat.nebcatpath[sh2 - BaseNeb], 'sh 2');
  GetGCatInfo(GcatH, info, v, GCatFilter, Result);
  if Result then
    Result := (v = rtNeb);
  if Result then
    OpenGCatWin(Result);
end;

procedure Tcatalog.OpenSH2Pos(ar1, ar2, de1, de2: double; var ok: boolean);
var
  GcatH: TCatHeader;
  info: TCatHdrInfo;
  v: integer;
begin
  CurGCat := 0;
  MessierStrPos := -1;
  SetGcatPath(cfgcat.nebcatpath[sh2 - BaseNeb], 'sh 2');
  GetGCatInfo(GcatH, info, v, GCatFilter, ok);
  if ok then
    ok := (v = rtNeb);
  if ok then
    OpenGCat(ar1, ar2, de1, de2, ok);
end;

function Tcatalog.CloseSH2: boolean;
begin
  CloseGcat;
  Result := True;
end;

function Tcatalog.GetSH2(var rec: GcatRec): boolean;
begin
  Result := GetGCatN(rec);
end;

procedure Tcatalog.FindSH2(id: shortstring; var ar, de: double; var ok: boolean);
var
  H: TCatHeader;
  info: TCatHdrInfo;
  rec: GCatrec;
  version: integer;
  iid: string;
begin
  ok := False;
  iid := id;
  if fileexists(slash(cfgcat.nebcatpath[sh2 - BaseNeb]) + 'sh 2' + '.ixr') then
  begin
    SetGcatPath(cfgcat.nebcatpath[sh2 - BaseNeb], 'sh 2');
    GetGCatInfo(H, info, version, GCatFilter, ok);
    MessierStrPos := -1;
    if ok then
      FindNumGcatRec(cfgcat.nebcatpath[sh2 - BaseNeb], 'sh 2', iid, H.ixkeylen, rec, ok);
    if ok then
    begin
      ar := rec.ra / 15;
      de := rec.Dec;
      FormatGCatN(rec);
      FFindId := id;
      FFindRecOK := True;
      FFindRec := rec;
    end;
  end
  else
    ok := False;
end;

function Tcatalog.IsDRKpath(path: string): boolean;
begin
  Result := FileExists(slash(path) + 'b.hdr');
end;

function Tcatalog.OpenDRK: boolean;
var
  GcatH: TCatHeader;
  info: TCatHdrInfo;
  v: integer;
begin
  CurGCat := 0;
  MessierStrPos := -1;
  SetGcatPath(cfgcat.nebcatpath[drk - BaseNeb], 'b');
  GetGCatInfo(GcatH, info, v, GCatFilter, Result);
  if Result then
    Result := (v = rtNeb);
  if Result then
    OpenGCatWin(Result);
end;

procedure Tcatalog.OpenDRKPos(ar1, ar2, de1, de2: double; var ok: boolean);
var
  GcatH: TCatHeader;
  info: TCatHdrInfo;
  v: integer;
begin
  CurGCat := 0;
  MessierStrPos := -1;
  SetGcatPath(cfgcat.nebcatpath[drk - BaseNeb], 'b');
  GetGCatInfo(GcatH, info, v, GCatFilter, ok);
  if ok then
    ok := (v = rtNeb);
  if ok then
    OpenGCat(ar1, ar2, de1, de2, ok);
end;

function Tcatalog.CloseDRK: boolean;
begin
  CloseGcat;
  Result := True;
end;

function Tcatalog.GetDRK(var rec: GcatRec): boolean;
begin
  Result := GetGCatN(rec);
  rec.neb.mag := 11;  // for mag filter
  rec.neb.valid[vnMag] := True;
  rec.options.flabel[5] := 'DrkMagFilter';
end;

procedure Tcatalog.FindDRK(id: shortstring; var ar, de: double; var ok: boolean);
var
  H: TCatHeader;
  info: TCatHdrInfo;
  rec: GCatrec;
  version: integer;
  iid: string;
begin
  ok := False;
  iid := id;
  if fileexists(slash(cfgcat.nebcatpath[drk - BaseNeb]) + 'b' + '.ixr') then
  begin
    SetGcatPath(cfgcat.nebcatpath[drk - BaseNeb], 'b');
    GetGCatInfo(H, info, version, GCatFilter, ok);
    MessierStrPos := -1;
    if ok then
      FindNumGcatRec(cfgcat.nebcatpath[drk - BaseNeb], 'b', iid, H.ixkeylen, rec, ok);
    if ok then
    begin
      ar := rec.ra / 15;
      de := rec.Dec;
      FormatGCatN(rec);
      FFindId := id;
      FFindRecOK := True;
      FFindRec := rec;
    end;
  end
  else
    ok := False;
end;

procedure Tcatalog.FormatLBN(lin: LBNrec; var rec: GcatRec);
begin
  rec.ra := deg2rad * lin.ar / 100000;
  rec.Dec := deg2rad * lin.de / 100000;
  rec.neb.dim2 := lin.d2;
  if rec.neb.dim1 <= 0 then
    rec.neb.dim1 := 1;
  case lin.bright of
    0..1: rec.neb.mag := 8;
    2: rec.neb.mag := 13;
    3: rec.neb.mag := 15;
    4: rec.neb.mag := 16;
    else
      rec.neb.mag := 18;
  end;
  if (rec.neb.mag > 70) or (rec.neb.mag < -70) then
  begin
    rec.neb.mag := 99;     // undefined magnitude
    rec.neb.sbr := 99;
  end
  else
  begin
    ;
    rec.neb.sbr := rec.neb.mag + 5 * log10(rec.neb.dim1) - 0.26;
  end;
  rec.neb.id := lin.Name;
  rec.str[1] := IntToStr(lin.num);
  rec.num[1] := lin.id;
  rec.num[2] := lin.bright;
  rec.num[3] := lin.color;
  rec.num[4] := lin.area;
end;

function Tcatalog.GetLBN(var rec: GcatRec): boolean;
var
  lin: LBNrec;
begin
  rec := EmptyRec;
  Result := True;
  repeat
    ReadLBN(lin, Result);
    if not Result then
      break;
    rec.neb.dim1 := lin.d1;
    if cfgshr.NebFilter and (rec.neb.dim1 < cfgcat.NebSizeMin) then
      continue;
    case lin.bright of
      0..1: rec.neb.mag := 8;
      2: rec.neb.mag := 13;
      3: rec.neb.mag := 15;
      4: rec.neb.mag := 16;
      else
        rec.neb.mag := 18;
    end;
    if cfgshr.NebFilter and (rec.neb.mag > cfgcat.NebMagMax) then
      continue;
    break;
  until not Result;
  if Result then
  begin
    FormatLBN(lin,rec);
  end;
end;

procedure Tcatalog.FindLBN(id : string ;var ar,de:double; var ok:boolean);
var lin: LBNrec;
    rok: boolean;
    buf:string;
    n: integer;
begin
  ok:=false;
  buf:=trim(copy(id,4,9));
  n:=StrToIntDef(buf,-1);
  if n>=0 then begin
    try
    SetLBNpath(cfgcat.nebcatpath[lbn - BaseNeb]);
    OpenLBNAll(rok);
    if not rok then
      exit;
    repeat
      ReadLBN(lin, rok);
      if not rok then
        break;
      if n=lin.num then begin
        ok:=true;
        InitRec(lbn);
        FFindRec := EmptyRec;
        FormatLBN(lin,FFindRec);
        ar := rad2deg*FFindRec.ra/15;
        de := rad2deg*FFindRec.Dec;
        FFindId := id;
        FFindRecOK := True;
        break;
      end;
    until not rok;
    finally
      CloseLBN;
    end;
  end;
end;

function Tcatalog.GetRC3(var rec: GcatRec): boolean;
var
  lin: RC3rec;
begin
  rec := EmptyRec;
  Result := True;
  repeat
    ReadRC3(lin, Result);
    if not Result then
      break;
    rec.neb.mag := min(90, abs(lin.mb / 100));
    if cfgshr.NebFilter and (rec.neb.mag > cfgcat.NebMagMax) then
      continue;
    if lin.d25 >= 0 then
      rec.neb.dim1 := power(10, lin.d25 / 100) / 10
    else
      rec.neb.dim1 := 0;
    if cfgshr.NebFilter and (rec.neb.dim1 < cfgcat.NebSizeMin) then
      continue;
    break;
  until not Result;
  if Result then
  begin
    rec.ra := deg2rad * lin.ar / 100000;
    rec.Dec := deg2rad * lin.de / 100000;
    rec.neb.id := lin.nom;
    rec.str[1] := lin.pgc;
    rec.neb.morph := lin.typ;
    if lin.r25 >= 0 then
      rec.neb.dim2 := rec.neb.dim1 / power(10, lin.r25 / 100)
    else
      rec.neb.dim2 := rec.neb.dim1;
    if lin.ae >= 0 then
      rec.num[1] := power(10, lin.ae / 100) / 10
    else
      rec.num[1] := 0;
    if lin.pa = 255 then
      rec.neb.pa := 90
    else
      rec.neb.pa := lin.pa;
    rec.num[2] := lin.b_vt / 100;
    rec.num[3] := lin.b_ve / 100;
    if lin.m25 > -9000 then
      rec.neb.sbr := lin.m25 / 100
    else
      rec.neb.sbr := -99;
    if lin.vgsr > -999999 then
      rec.neb.rv := lin.vgsr;
    rec.num[4] := lin.stage / 10;
    rec.num[5] := lin.lumcl / 10;
  end;
end;

function Tcatalog.IsPGCpath(path: string): boolean;
begin
  Result := FileExists(slash(path) + 'pgc.hdr');
  PgcLeda := Result;
  if not Result then
    Result := pgcunit.IsPGCpath(path);
end;

function Tcatalog.OpenPGC: boolean;
var
  GcatH: TCatHeader;
  info: TCatHdrInfo;
  v: integer;
begin
  IsPGCpath(cfgcat.nebcatpath[pgc - BaseNeb]);
  if PgcLeda then
  begin
    CurGCat := 0;
    SetGcatPath(cfgcat.nebcatpath[pgc - BaseNeb], 'pgc');
    GetGCatInfo(GcatH, info, v, GCatFilter, Result);
    if Result then
      Result := (v = rtNeb);
    if Result then
      OpenGCatWin(Result);
  end
  else
  begin
    pgcunit.SetpgcPath(cfgcat.nebcatpath[pgc - BaseNeb]);
    pgcunit.Openpgcwin(Result);
  end;
end;

procedure Tcatalog.OpenPGCPos(ar1, ar2, de1, de2: double; var ok: boolean);
var
  GcatH: TCatHeader;
  info: TCatHdrInfo;
  v: integer;
begin
  IsPGCpath(cfgcat.nebcatpath[pgc - BaseNeb]);
  if PgcLeda then
  begin
    CurGCat := 0;
    SetGcatPath(cfgcat.nebcatpath[pgc - BaseNeb], 'pgc');
    GetGCatInfo(GcatH, info, v, GCatFilter, ok);
    if ok then
      ok := (v = rtNeb);
    if ok then
      OpenGCat(ar1, ar2, de1, de2, ok);
  end
  else
  begin
    pgcunit.OpenPGC(ar1, ar2, de1, de2, ok);
  end;
end;

function Tcatalog.ClosePGC: boolean;
begin
  if PgcLeda then
  begin
    CloseGcat;
    PgcLeda := False;
    Result := True;
  end
  else
  begin
    pgcunit.ClosePGC;
    Result := True;
  end;
end;

function Tcatalog.GetPGC(var rec: GcatRec): boolean;
begin
  if PgcLeda then
    Result := GetGCatN(rec)
  else
    Result := GetOldPGC(rec);
end;

procedure Tcatalog.FindPGC(id: shortstring; var ar, de: double; var ok: boolean);
var
  H: TCatHeader;
  info: TCatHdrInfo;
  rec: GCatrec;
  version: integer;
  iid: string;
begin
  if PgcLeda then
  begin
    ok := False;
    iid := id;
    if fileexists(slash(cfgcat.nebcatpath[pgc - BaseNeb]) + 'pgc' + '.ixr') then
    begin
      SetGcatPath(cfgcat.nebcatpath[pgc - BaseNeb], 'pgc');
      GetGCatInfo(H, info, version, GCatFilter, ok);
      if ok then
        FindNumGcatRec(cfgcat.nebcatpath[pgc - BaseNeb], 'pgc', iid, H.ixkeylen, rec, ok);
      if ok then
      begin
        ar := rec.ra / 15;
        de := rec.Dec;
        FormatGCatN(rec);
        FFindId := id;
        FFindRecOK := True;
        FFindRec := rec;
      end;
    end
    else
      ok := False;
  end
  else
  begin
    pgcunit.SetPGCPath(cfgcat.NebCatPath[pgc - BaseNeb]);
    FindOldPGC(strtointdef(id, 0), ar, de, ok);
  end;
end;

procedure Tcatalog.FormatPGC(lin: PGCrec; var rec: GcatRec);
begin
  rec.neb.mag := min(99, abs(lin.mb / 100));
  if lin.maj >= 0 then
    rec.neb.dim1 := lin.maj / 100
  else
    rec.neb.dim1 := 0;
  rec.ra := deg2rad * lin.ar / 100000;
  rec.Dec := deg2rad * lin.de / 100000;
  rec.neb.id := lin.nom;
  rec.str[1] := IntToStr(lin.pgc);
  rec.neb.morph := lin.typ;
  if lin.min >= 0 then
    rec.neb.dim2 := lin.min / 100
  else
    rec.neb.dim2 := rec.neb.dim1;
  if lin.pa = 255 then
    rec.neb.pa := 90
  else
    rec.neb.pa := lin.pa;
  if lin.hrv > -999999 then
    rec.neb.rv := lin.hrv;
end;

function Tcatalog.GetOldPGC(var rec: GcatRec): boolean;
var
  lin: PGCrec;
  ma, sz: double;
begin
  rec := EmptyRec;
  Result := True;
  repeat
    pgcunit.ReadPGC(lin, Result);
    if not Result then
      break;
    ma := min(99, abs(lin.mb / 100));
    if cfgshr.NebFilter and (ma > cfgcat.NebMagMax) then
      continue;
    if lin.maj >= 0 then
      sz := lin.maj / 100
    else
      sz := 0;
    if cfgshr.NebFilter and (sz < cfgcat.NebSizeMin) then
      continue;
    break;
  until not Result;
  if Result then
  begin
    FormatPGC(lin, rec);
  end;
end;

procedure Tcatalog.FindOldPGC(id: integer; var ra, Dec: double; var ok: boolean);
var
  lin: PGCrec;
  rec: GCatrec;
begin
  InitRec(pgc);
  rec := EmptyRec;
  findunit.FindNumPGC(id, lin, ok);
  if ok then
  begin
    FormatPGC(lin, rec);
    ra := rad2deg * rec.ra / 15;
    Dec := rad2deg * rec.Dec;
    FFindId := 'PGC' + IntToStr(id);
    FFindRecOK := True;
    FFindRec := rec;
  end;
end;

function Tcatalog.GetOCL(var rec: GcatRec): boolean;
var
  lin: OCLrec;
begin
  rec := EmptyRec;
  Result := True;
  repeat
    ReadOCL(lin, Result);
    if not Result then
      break;
    rec.neb.dim1 := lin.dim / 10;
    if cfgshr.NebFilter and (rec.neb.dim1 < cfgcat.NebSizeMin) then
      continue;
    rec.neb.mag := lin.mt / 100;
    if cfgshr.NebFilter and (rec.neb.mag > cfgcat.NebMagMax) then
      continue;
    break;
  until not Result;
  if Result then
  begin
    rec.ra := deg2rad * lin.ar / 100000;
    rec.Dec := deg2rad * lin.de / 100000;
    case lin.cat of
      1: rec.neb.id := 'NGC';
      2: rec.neb.id := 'IC ';
      else
        str(lin.cat: 3, rec.neb.id);
    end;
    rec.neb.id := rec.neb.id + IntToStr(lin.num);
    rec.str[1] := IntToStr(lin.ocl);
    rec.neb.morph := lin.conc + lin.range + lin.rich + lin.neb;
    rec.num[1] := parsec2ly * lin.dist;
    if lin.age > 0 then
      rec.num[2] := power(10, frac(lin.age / 100));
    rec.num[3] := lin.b_v / 100;
    rec.num[4] := lin.ns;
    rec.num[5] := lin.ms / 100;
  end;
end;

function Tcatalog.GetGCM(var rec: GcatRec): boolean;
var
  lin: GCMrec;
begin
  rec := EmptyRec;
  Result := True;
  repeat
    ReadGCM(lin, Result);
    if not Result then
      break;
    rec.neb.mag := lin.vt / 100;
    if cfgshr.NebFilter and (rec.neb.mag > cfgcat.NebMagMax) then
      continue;
    rec.neb.dim1 := (lin.rc / 100) * power(10, (lin.c / 100));
    if cfgshr.NebFilter and (rec.neb.dim1 < cfgcat.NebSizeMin) then
      continue;
    break;
  until not Result;
  if Result then
  begin
    rec.ra := deg2rad * lin.ar / 100000;
    rec.Dec := deg2rad * lin.de / 100000;
    rec.neb.id := lin.Name;
    if trim(rec.neb.id) = '' then
      rec.neb.id := lin.id;
    rec.str[1] := lin.id;
    rec.str[2] := lin.spt;
    rec.num[1] := lin.b_vt / 100;
    rec.num[2] := (lin.muv / 100) - 8.89; // sec->min
    rec.num[3] := lin.rc / 100;
    rec.num[4] := lin.rh / 100;
    rec.num[5] := 3261.6 * lin.rsun / 10;
  end;
end;

function Tcatalog.IsGPNpath(path: string): boolean;
begin
  Result := FileExists(slash(path) + 'gpn.hdr');
  GpnNew := Result;
  if not Result then
    Result := gpnunit.IsGPNpath(path);
end;

function Tcatalog.OpenGPN: boolean;
var
  GcatH: TCatHeader;
  info: TCatHdrInfo;
  v: integer;
begin
  IsGPNpath(cfgcat.nebcatpath[gpn - BaseNeb]);
  if GpnNew then
  begin
    CurGCat := 0;
    SetGcatPath(cfgcat.nebcatpath[gpn - BaseNeb], 'gpn');
    GetGCatInfo(GcatH, info, v, GCatFilter, Result);
    if Result then
      Result := (v = rtNeb);
    if Result then
      OpenGCatWin(Result);
  end
  else
  begin
    gpnunit.SetgpnPath(cfgcat.nebcatpath[gpn - BaseNeb]);
    gpnunit.Opengpnwin(Result);
  end;
end;

procedure Tcatalog.OpenGPNPos(ar1, ar2, de1, de2: double; var ok: boolean);
var
  GcatH: TCatHeader;
  info: TCatHdrInfo;
  v: integer;
begin
  IsGPNpath(cfgcat.nebcatpath[gpn - BaseNeb]);
  if GpnNew then
  begin
    CurGCat := 0;
    SetGcatPath(cfgcat.nebcatpath[gpn - BaseNeb], 'gpn');
    GetGCatInfo(GcatH, info, v, GCatFilter, ok);
    if ok then
      ok := (v = rtNeb);
    if ok then
      OpenGCat(ar1, ar2, de1, de2, ok);
  end
  else
  begin
    gpnunit.OpenGPN(ar1, ar2, de1, de2, ok);
  end;
end;

function Tcatalog.CloseGPN: boolean;
begin
  if GpnNew then
  begin
    CloseGcat;
    GpnNew := False;
    Result := True;
  end
  else
  begin
    gpnunit.CloseGPN;
    Result := True;
  end;
end;

function Tcatalog.GetGPN(var rec: GcatRec): boolean;
begin
  if GpnNew then
    Result := GetGCatN(rec)
  else
    Result := GetGPNold(rec);
end;

procedure Tcatalog.FindGPN(id: shortstring; var ar, de: double; var ok: boolean);
var
  H: TCatHeader;
  info: TCatHdrInfo;
  rec: GCatrec;
  version: integer;
  iid: string;
begin
  if GpnNew then
  begin
    ok := False;
    iid := id;
    if fileexists(slash(cfgcat.nebcatpath[gpn - BaseNeb]) + 'gpn' + '.ixr') then
    begin
      SetGcatPath(cfgcat.nebcatpath[gpn - BaseNeb], 'gpn');
      GetGCatInfo(H, info, version, GCatFilter, ok);
      if ok then
        FindNumGcatRec(cfgcat.nebcatpath[gpn - BaseNeb], 'gpn', iid, H.ixkeylen, rec, ok);
      if ok then
      begin
        ar := rec.ra / 15;
        de := rec.Dec;
        FormatGCatN(rec);
        FFindId := id;
        FFindRecOK := True;
        FFindRec := rec;
      end;
    end
    else
      ok := False;
  end
  else
  begin
    ok := False;
  end;
end;

function Tcatalog.GetGPNold(var rec: GcatRec): boolean;
var
  lin: GPNrec;
begin
  rec := EmptyRec;
  Result := True;
  repeat
    gpnunit.ReadGPN(lin, Result);
    if not Result then
      break;
    rec.neb.mag := lin.mv / 100;
    if cfgshr.NebFilter and (rec.neb.mag > cfgcat.NebMagMax) then
      continue;
    rec.neb.dim1 := lin.dim / 10;
    if cfgshr.NebFilter and (rec.neb.dim1 / 60 < cfgcat.NebSizeMin) then
      continue;
    break;
  until not Result;
  if Result then
  begin
    rec.ra := deg2rad * lin.ar / 100000;
    rec.Dec := deg2rad * lin.de / 100000;
    rec.neb.id := lin.Name;
    rec.str[1] := lin.pk;
    rec.str[2] := lin.png;
    rec.num[1] := lin.mHb / 100;
    rec.num[2] := lin.cs_v / 100;
    rec.num[3] := lin.cs_b / 100;
  end;
end;

function Tcatalog.FindNum(cat: integer; id: string; var ra, Dec: double): boolean;
begin
  Result := False;
  while lockcat do
  begin
    sleep(10);
    application.ProcessMessages;
  end;
  try
    lockcat := True;
    FFindId := '';
    case cat of
      S_Messier: if IsNGCPath(cfgcat.NebCatPath[ngc - BaseNeb]) then
        begin
          FindNGC(id, ra, Dec, Result);
        end;
      S_NGC: if IsNGCPath(cfgcat.NebCatPath[ngc - BaseNeb]) then
        begin
          FindNGC(id, ra, Dec, Result);
        end;
      S_IC: if IsNGCPath(cfgcat.NebCatPath[ngc - BaseNeb]) then
        begin
          FindNGC(id, ra, Dec, Result);
        end;
      S_PGC: if IsPGCPath(cfgcat.NebCatPath[pgc - BaseNeb]) then
        begin
          FindPGC(id, ra, Dec, Result);
        end;
      S_GCVS: if IsGCVPath(cfgcat.VarStarCatPath[gcvs - BaseVar]) then
        begin
          SetGCVPath(cfgcat.VarStarCatPath[gcvs - BaseVar]);
          FindGCVS(id, ra, Dec, Result);
        end;
      S_GC: if IsBSCPath(cfgcat.StarCatPath[bsc - BaseStar]) then
        begin
          SetBSCPath(cfgcat.StarCatPath[bsc - BaseStar]);
          FindNumGC(strtointdef(id, 0), ra, Dec, Result);
        end;
      S_GSC:
      begin
        SetGSCPath(cfgcat.StarCatPath[gsc - BaseStar]);
        SetGSCCPath(cfgcat.StarCatPath[gscc - BaseStar]);
        SetGSCFPath(cfgcat.StarCatPath[gscf - BaseStar]);
        if cfgcat.StarCatDef[gsc - BaseStar] then
          FindNumGSC(id, ra, Dec, Result)
        else if cfgcat.StarCatDef[gscf - BaseStar] then
          FindNumGSCF(id, ra, Dec, Result)
        else if cfgcat.StarCatDef[gscc - BaseStar] then
          FindNumGSCC(id, ra, Dec, Result);
      end;
      S_SAO: if IsBSCPath(cfgcat.StarCatPath[bsc - BaseStar]) then
        begin
          SetBSCPath(cfgcat.StarCatPath[bsc - BaseStar]);
          FindNumSAO(strtointdef(id, 0), ra, Dec, Result);
        end;
      S_HD: if IsBSCPath(cfgcat.StarCatPath[bsc - BaseStar]) then
        begin
          SetBSCPath(cfgcat.StarCatPath[bsc - BaseStar]);
          FindNumHD(strtointdef(id, 0), ra, Dec, Result);
        end;
      S_BD: if IsBSCPath(cfgcat.StarCatPath[bsc - BaseStar]) then
        begin
          SetBSCPath(cfgcat.StarCatPath[bsc - BaseStar]);
          FindNumBD(id, ra, Dec, Result);
        end;
      S_CD: if IsBSCPath(cfgcat.StarCatPath[bsc - BaseStar]) then
        begin
          SetBSCPath(cfgcat.StarCatPath[bsc - BaseStar]);
          FindNumCD(id, ra, Dec, Result);
        end;
      S_CPD: if IsBSCPath(cfgcat.StarCatPath[bsc - BaseStar]) then
        begin
          SetBSCPath(cfgcat.StarCatPath[bsc - BaseStar]);
          FindNumCPD(id, ra, Dec, Result);
        end;
      S_HR:
      begin
        SetXHIPPath(cfgcat.StarCatPath[DefStar - BaseStar]);
        FindNumHR(strtointdef(id, 0), ra, Dec, Result);
      end;
      S_Bayer:
      begin
        SetXHIPPath(cfgcat.StarCatPath[DefStar - BaseStar]);
        FindNumBayer(id, ra, Dec, Result);
      end;
      S_Flam:
      begin
        SetXHIPPath(cfgcat.StarCatPath[DefStar - BaseStar]);
        FindNumFlam(id, ra, Dec, Result);
      end;
      S_SAC: if IsSACPath(cfgcat.NebCatPath[sac - BaseNeb]) then
        begin
          SetSACPath(cfgcat.NebCatPath[sac - BaseNeb]);
          FindSAC(id, ra, Dec, Result);
        end;
      S_WDS: if IsWDSPath(cfgcat.DblStarCatPath[wds - BaseDbl]) then
        begin
          SetWDSPath(cfgcat.DblStarCatPath[wds - BaseDbl]);
          FindWDS(id, ra, Dec, Result);
        end;
      S_GCat:
      begin
        FindNGcat(id, ra, Dec, Result);
      end;
      S_TYC2: if IsTY2Path(cfgcat.StarCatPath[tyc2 - BaseStar]) then
        begin
          SetTY2Path(cfgcat.StarCatPath[tyc2 - BaseStar]);
          FindTYC2(id, ra, Dec, Result);
        end;
      S_UNA: if IsUSNOApath(cfgcat.StarCatPath[usnoa - BaseStar]) then
        begin
          SetUSNOApath(cfgcat.StarCatPath[usnoa - BaseStar]);
          FindNumUSNOA(id, ra, Dec, Result);
        end;
      S_UNB: if IsUSNOBpath(cfgcat.StarCatPath[usnob - BaseStar]) then
        begin
          SetUSNOBpath(cfgcat.StarCatPath[usnob - BaseStar]);
          FindNumUSNOB(id, ra, Dec, Result);
        end;
      S_SH2: if IsSH2path(cfgcat.NebCatPath[sh2 - BaseNeb]) then
        begin
          FindSH2(id, ra, Dec, Result);
        end;
      S_DRK: if IsDRKpath(cfgcat.NebCatPath[drk - BaseNeb]) then
        begin
          FindDRK(id, ra, Dec, Result);
        end;
      S_GPN: if IsGPNpath(cfgcat.NebCatPath[gpn - BaseNeb]) then
        begin
          FindGPN(id, ra, Dec, Result);
        end;
      S_LBN: if IsLBNpath(cfgcat.NebCatPath[lbn - BaseNeb]) then
        begin
          FindLBN(id, ra, Dec, Result);
        end;
    end;
    if Result and (FFindId = '') then
      FFindId := id;
    ra := deg2rad * 15 * ra;
    Dec := deg2rad * Dec;
  finally
    lockcat := False;
  end;
end;

function Tcatalog.SearchNebulae(Num: string; var ar1, de1: double): boolean;
var
  buf: string;
  i: integer;
  rec: Gcatrec;
  ok: boolean;
begin
  // search user object first
  if cfgcat.nebcatdef[uneb - BaseNeb] then
  begin
    buf := uppercase(Num);
    for i := 0 to Length(cfgcat.UserObjects) - 1 do
    begin
      if cfgcat.UserObjects[i].active and
        (pos(buf, UpperCase(cfgcat.UserObjects[i].oname)) > 0) then
      begin
        ar1 := cfgcat.UserObjects[i].ra;
        de1 := cfgcat.UserObjects[i].Dec;
        Result := True;
        exit;
      end;
    end;
  end;
  // search VO data
  if cfgcat.nebcatdef[voneb - BaseNeb] then
  begin
    buf := uppercase(Num);
    VOobject := 'dso';
    SetVOCatpath(slash(VODir));
    OpenVOCatwin(ok);
    Result := False;
    if ok then
      repeat
        ok := GetVOcatN(rec, False);
        if ok and (pos(buf, UpperCase(rec.neb.id)) > 0) then
        begin
          ar1 := rec.ra;
          de1 := rec.Dec;
          FFindId := rec.star.id;
          FFindRecOK := True;
          FFindRec := rec;
          Result := True;
          if SampConnected then
          begin
            cfgcat.SampFindTable := vocat.SAMPid;
            cfgcat.SampFindURL := vocat.SAMPurl;
            cfgcat.SampFindRec := vocat.VOcatrec;
          end
          else
            cfgcat.SampFindTable := '';
        end;
      until Result or (not ok);
    CloseVOCat;
    if Result then
      exit;
  end;
  // search other catgen catalog
  FindNGcat(Num, ar1, de1, Result, rtNeb);
  if Result then
  begin
    ar1 := deg2rad * 15 * ar1;
    de1 := deg2rad * de1;
    exit;
  end;
  // Messier
  if uppercase(copy(Num, 1, 1)) = 'M' then
  begin
    if cfgcat.nebcaton[sac - BaseNeb] then
      Result := FindNum(S_SAC, Num, ar1, de1)
    else
      Result := FindNum(S_messier, Num, ar1, de1);
    if Result then
      exit;
  end;
  // NGC
  if uppercase(copy(Num, 1, 3)) = 'NGC' then
  begin
    if cfgcat.nebcaton[sac - BaseNeb] then
      Result := FindNum(S_SAC, Num, ar1, de1)
    else
      Result := FindNum(S_NGC, Num, ar1, de1);
    if Result then
      exit;
  end;
  // IC
  if uppercase(copy(Num, 1, 2)) = 'IC' then
  begin
    if cfgcat.nebcaton[sac - BaseNeb] then
      Result := FindNum(S_SAC, Num, ar1, de1)
    else
      Result := FindNum(S_IC, Num, ar1, de1);
    if Result then
      exit;
  end;
  // SH 2
  if uppercase(copy(Num, 1, 2)) = 'SH' then
  begin
    Result := FindNum(S_SH2, Num, ar1, de1);
    if Result then
      exit;
  end;
  // Barnard
  if uppercase(copy(Num, 1, 1)) = 'B' then
  begin
    Result := FindNum(S_DRK, Num, ar1, de1);
    if Result then
      exit;
  end;
  // Planetary neb
  Result := FindNum(S_GPN, Num, ar1, de1);
  if Result then
    exit;
  // PGC
  if uppercase(copy(Num, 1, 3)) = 'PGC' then
  begin
    buf := StringReplace(Num, 'pgc', '', [rfReplaceAll, rfIgnoreCase]);
    Result := FindNum(S_PGC, buf, ar1, de1);
    if Result then
      exit;
  end;
  // LBN
  if uppercase(copy(Num, 1, 3)) = 'LBN' then
  begin
    Result := FindNum(S_LBN, Num, ar1, de1);
    if Result then
      exit;
  end;
  // finally try various id in OpenNGC and SAC
  Result := FindNum(S_NGC, Num, ar1, de1);
  if Result then
    exit;
  Result := FindNum(S_SAC, Num, ar1, de1);
end;

function Tcatalog.SearchStarNameExact(Num: string; var ar1, de1: double): boolean;
var
  i, j, l, p: integer;
  buf, sn: string;
  snl: TStringList;
begin
  snl := TStringList.Create;
  buf := uppercase(Num);
  Result := False;
  l := MaxInt;
  for i := 0 to cfgshr.StarNameNum - 1 do
  begin
    Splitarg(uppercase(cfgshr.StarName[i]), ';', snl);
    for j := 0 to snl.Count - 1 do
    begin
      sn := trim(snl[j]);
      if buf=sn then
      begin
        if j < l then
        begin
          Num := 'HR' + IntToStr(cfgshr.StarNameHR[i]);
          Result := SearchStar(Num, ar1, de1);
          if buf = sn then
            l := j;
        end;
      end;
    end;
  end;
  snl.Free;
end;

function Tcatalog.SearchStarNameGeneric(Num: string; var ar1, de1: double): boolean;
var
  i, j, l, p: integer;
  buf, sn: string;
  snl: TStringList;
begin
  snl := TStringList.Create;
  buf := uppercase(Num);
  Result := False;
  l := MaxInt;
  for i := 0 to cfgshr.StarNameNum - 1 do
  begin
    Splitarg(uppercase(cfgshr.StarName[i]), ';', snl);
    for j := 0 to snl.Count - 1 do
    begin
      sn := trim(snl[j]);
      p := pos(buf, sn);
      if p = 1 then
      begin
        if j < l then
        begin
          Num := 'HR' + IntToStr(cfgshr.StarNameHR[i]);
          Result := SearchStar(Num, ar1, de1);
          if buf = sn then
            l := j;
        end;
      end;
    end;
  end;
  snl.Free;
end;

function Tcatalog.SearchStar(Num: string; var ar1, de1: double): boolean;
var
  buf: string;
  rec: Gcatrec;
  ok: boolean;
begin
  // first the VO catalog
  if cfgcat.StarCatDef[vostar - BaseStar] then
  begin
    buf := uppercase(Num);
    VOobject := 'star';
    SetVOCatpath(slash(VODir));
    OpenVOCatwin(ok);
    Result := False;
    if ok then
      repeat
        ok := GetVOcatN(rec, False);
        if ok and (pos(buf, UpperCase(rec.star.id)) > 0) then
        begin
          ar1 := rec.ra;
          de1 := rec.Dec;
          FFindId := rec.star.id;
          FFindRecOK := True;
          FFindRec := rec;
          Result := True;
        end;
      until Result or (not ok);
    CloseVOCat;
    if Result then
      exit;
  end;
  // then the id not in the default catalog
  if uppercase(copy(Num, 1, 4)) = 'GAIA' then
  begin
    // Use GetGaiaVersion because the Gaia catalog is maybe inactive
    if GetGaiaVersion='' then SetGaiaPath(slash(cfgcat.starcatpath[gaia - BaseStar])+slash('gaia1'), 'gaia');
    buf := StringReplace(Num, GetGaiaVersion, '', [rfReplaceAll, rfIgnoreCase]);
    Result := FindGaia(buf, ar1, de1);
    if Result then
      exit;
  end;
  if uppercase(copy(Num, 1, 2)) = 'GC' then
  begin
    buf := StringReplace(Num, 'gc', '', [rfReplaceAll, rfIgnoreCase]);
    Result := FindNum(S_GC, buf, ar1, de1);
    if Result then
      exit;
  end;
  if uppercase(copy(Num, 1, 3)) = 'GSC' then
  begin
    buf := StringReplace(Num, 'gsc', '', [rfReplaceAll, rfIgnoreCase]);
    Result := FindNum(S_GSC, buf, ar1, de1);
    if Result then
      exit;
  end;
  if uppercase(copy(Num, 1, 3)) = 'UNA' then
  begin
    buf := StringReplace(Num, 'una', '', [rfReplaceAll, rfIgnoreCase]);
    Result := FindNum(S_UNA, buf, ar1, de1);
    if Result then
      exit;
  end;
  if uppercase(copy(Num, 1, 6)) = 'USNO-A' then
  begin
    buf := StringReplace(Num, 'usno-a', '', [rfReplaceAll, rfIgnoreCase]);
    Result := FindNum(S_UNA, buf, ar1, de1);
    if Result then
      exit;
  end;
  if uppercase(copy(Num, 1, 3)) = 'UNB' then
  begin
    buf := StringReplace(Num, 'unb', '', [rfReplaceAll, rfIgnoreCase]);
    Result := FindNum(S_UNB, buf, ar1, de1);
    if Result then
      exit;
  end;
  if uppercase(copy(Num, 1, 6)) = 'USNO-B' then
  begin
    buf := StringReplace(Num, 'usno-b', '', [rfReplaceAll, rfIgnoreCase]);
    Result := FindNum(S_UNB, buf, ar1, de1);
    if Result then
      exit;
  end;
  if uppercase(copy(Num, 1, 3)) = 'TYC' then
  begin
    buf := StringReplace(Num, 'tyc', '', [rfReplaceAll, rfIgnoreCase]);
    Result := FindNum(S_TYC2, buf, ar1, de1);
    if Result then
      exit;
  end;
  if uppercase(copy(Num, 1, 3)) = 'SAO' then
  begin
    buf := StringReplace(Num, 'sao', '', [rfReplaceAll, rfIgnoreCase]);
    Result := FindNum(S_SAO, buf, ar1, de1);
    if Result then
      exit;
  end;
  // the default catalog
  FindDefaultStars(Num, ar1, de1, Result, rtStar);
  if Result then
  begin
    ar1 := deg2rad * 15 * ar1;
    de1 := deg2rad * de1;
    exit;
  end;
  // other catgen catalog
  FindNGcat(Num, ar1, de1, Result, rtStar);
  if Result then
  begin
    ar1 := deg2rad * 15 * ar1;
    de1 := deg2rad * de1;
    exit;
  end;
  // then the id that duplicate some default catalog entries
  if uppercase(copy(Num, 1, 2)) = 'HD' then
  begin
    buf := StringReplace(Num, 'hd', '', [rfReplaceAll, rfIgnoreCase]);
    Result := FindNum(S_HD, buf, ar1, de1);
    if Result then
      exit;
  end;
  if uppercase(copy(Num, 1, 2)) = 'BD' then
  begin
    buf := StringReplace(Num, 'bd', '', [rfReplaceAll, rfIgnoreCase]);
    Result := FindNum(S_BD, buf, ar1, de1);
    if Result then
      exit;
  end;
  if uppercase(copy(Num, 1, 2)) = 'CD' then
  begin
    buf := StringReplace(Num, 'cd', '', [rfReplaceAll, rfIgnoreCase]);
    Result := FindNum(S_CD, buf, ar1, de1);
    if Result then
      exit;
  end;
  if uppercase(copy(Num, 1, 3)) = 'CPD' then
  begin
    buf := StringReplace(Num, 'cpd', '', [rfReplaceAll, rfIgnoreCase]);
    Result := FindNum(S_CPD, buf, ar1, de1);
    if Result then
      exit;
  end;
  if uppercase(copy(Num, 1, 2)) = 'HR' then
  begin
    buf := StringReplace(Num, 'hr', '', [rfReplaceAll, rfIgnoreCase]);
    Result := FindNum(S_HR, buf, ar1, de1);
    if Result then
      exit;
  end;
  Result := FindNum(S_Bayer, Num, ar1, de1); // also do Flamsteed
  if Result then
    exit;
end;

function Tcatalog.SearchDblStar(Num: string; var ar1, de1: double): boolean;
begin
  Result := False;
  if fileexists(slash(cfgcat.DblStarCatPath[wds - BaseDbl]) + 'wds.ixr') then
  begin
    Result := FindNum(S_WDS, Num, ar1, de1);
    if Result then
      exit;
  end;
  FindNGcat(Num, ar1, de1, Result, rtDbl);
  if Result then
  begin
    ar1 := deg2rad * 15 * ar1;
    de1 := deg2rad * de1;
    exit;
  end;
end;

function Tcatalog.SearchVarStar(Num: string; var ar1, de1: double): boolean;
begin
  Result := False;
  if fileexists(slash(cfgcat.VarStarCatPath[gcvs - BaseVar]) + 'gcvs.ixr') then
  begin
    Result := FindNum(S_GCVS, Num, ar1, de1);
    if Result then
      exit;
  end;
  FindNGcat(Num, ar1, de1, Result, rtVar);
  if Result then
  begin
    ar1 := deg2rad * 15 * ar1;
    de1 := deg2rad * de1;
    exit;
  end;
end;

function Tcatalog.SearchLines(Num: string; var ar1, de1: double): boolean;
begin
  FindNGcat(Num, ar1, de1, Result, rtLin);
  if Result then
  begin
    ar1 := deg2rad * 15 * ar1;
    de1 := deg2rad * de1;
    exit;
  end;
end;

function Tcatalog.SearchConstellation(Num: string; var ar1, de1: double): boolean;
var
  i: integer;
begin
  Result := False;
  for i := 0 to cfgshr.ConstelNum - 1 do
    if trim(cfgshr.ConstelName[i, 2]) = trim(Num) then
    begin
      Result := True;
      ar1 := cfgshr.ConstelPos[i].ra;
      de1 := cfgshr.ConstelPos[i].de;
      break;
    end;
end;

function Tcatalog.SearchConstAbrev(Num: string; var ar1, de1: double): boolean;
var
  i: integer;
begin
  Result := False;
  for i := 0 to cfgshr.ConstelNum - 1 do
    if uppercase(trim(cfgshr.ConstelName[i, 1])) = uppercase(trim(Num)) then
    begin
      Result := True;
      ar1 := cfgshr.ConstelPos[i].ra;
      de1 := cfgshr.ConstelPos[i].de;
      break;
    end;
end;

function Tcatalog.FindAtPos(cat: integer; x1, y1, x2, y2: double;
  nextobj, truncate, searchcenter: boolean; cfgsc: Tconf_skychart; var rec: Gcatrec): boolean;
var
  xx1, xx2, yy1, yy2, xxc, yyc, cyear, dyear, radius, rac, epoch: double;
  p: coordvector;
  ok, found, fullmotion: boolean;
begin
  if x2 > pi2 then
    rac := pi2
  else
    rac := 0;
  xxc := (x1 + x2) / 2;
  yyc := (y1 + y2) / 2;
  if cfgsc.YPmon = 0 then
    cyear := cfgsc.CurYear + DayofYear(cfgsc.CurYear, cfgsc.CurMonth, cfgsc.CurDay) / 365.25
  else
    cyear := cfgsc.YPmon;
  xx1 := x1;
  xx2 := x2;
  yy1 := y1;
  yy2 := y2;
  if not ((abs(xx1) < musec) and (abs(xx2 - pi2) < musec)) then
  begin
    if cfgsc.ApparentPos then
      mean_equatorial(xx1, yy1, cfgsc, True, True);
    if cfgsc.ApparentPos then
      mean_equatorial(xx2, yy2, cfgsc, True, True);
  end;
  xx1 := rad2deg * xx1 / 15;
  xx2 := rad2deg * xx2 / 15;
  yy1 := rad2deg * yy1;
  yy2 := rad2deg * yy2;
  if not nextobj then
  begin
    InitRec(cat);
    case cat of
      DefStar: OpenDefaultStarsPos(xx1, xx2, yy1, yy2, ok);
      sky2000: OpenSky(xx1, xx2, yy1, yy2, ok);
      tyc: OpenTYC(xx1, xx2, yy1, yy2, ok);
      tyc2: OpenTY2(xx1, xx2, yy1, yy2, 2, ok);
      tic: OpenTIC(xx1, xx2, yy1, yy2, ok);
      gscf: OpenGSCF(xx1, xx2, yy1, yy2, ok);
      gscc: OpenGSCC(xx1, xx2, yy1, yy2, ok);
      gsc: OpenGSC(xx1, xx2, yy1, yy2, ok);
      usnoa: OpenUSNOA(xx1, xx2, yy1, yy2, ok);
      usnob: OpenUSNOB(xx1, xx2, yy1, yy2, ok);
      hn290: Open290(xx1, xx2, yy1, yy2, ok);
      gaia: OpenGaiaPos(xx1, xx2, yy1, yy2, ok);
      microcat: OpenMCT(xx1, xx2, yy1, yy2, 3, ok);
      dsbase: OpenDSbase(xx1, xx2, yy1, yy2, ok);
      dstyc: OpenDSTyc(xx1, xx2, yy1, yy2, ok);
      dsgsc: OpenDSGsc(xx1, xx2, yy1, yy2, ok);
      bsc: OpenBSC(xx1, xx2, yy1, yy2, ok);
      gcvs: OpenGCV(xx1, xx2, yy1, yy2, ok);
      wds: OpenWDS(xx1, xx2, yy1, yy2, ok);
      sac: OpenSAC(xx1, xx2, yy1, yy2, ok);
      ngc: OpenNGCPos(xx1, xx2, yy1, yy2, ok);
      lbn: OpenLBN(xx1, xx2, yy1, yy2, ok);
      sh2: OpenSH2Pos(xx1, xx2, yy1, yy2, ok);
      drk: OpenDRKPos(xx1, xx2, yy1, yy2, ok);
      rc3: OpenRC3(xx1, xx2, yy1, yy2, ok);
      pgc: OpenPGCPos(xx1, xx2, yy1, yy2, ok);
      ocl: OpenOCL(xx1, xx2, yy1, yy2, ok);
      gcm: OpenGCM(xx1, xx2, yy1, yy2, ok);
      gpn: OpenGPNPos(xx1, xx2, yy1, yy2, ok);
      vostar:
      begin
        VOobject := 'star';
        SetVOCatpath(slash(VODir));
        OpenVOCat(ok);
      end;
      voneb:
      begin
        VOobject := 'dso';
        SetVOCatpath(slash(VODir));
        OpenVOCat(ok);
      end;
      uneb:
      begin
        CurrentUserObj := -1;
        ok := True;
      end;
      gcstar:
      begin
        VerGCat := rtStar;
        CurGCat := 0;
        ok := False;
        while NewGCat do
        begin
          OpenGCat(xx1, xx2, yy1, yy2, ok);
          if ok then
            break;
        end;
      end;
      gcvar:
      begin
        VerGCat := rtVar;
        CurGCat := 0;
        ok := False;
        while NewGCat do
        begin
          OpenGCat(xx1, xx2, yy1, yy2, ok);
          if ok then
            break;
        end;
      end;
      gcdbl:
      begin
        VerGCat := rtDbl;
        CurGCat := 0;
        ok := False;
        while NewGCat do
        begin
          OpenGCat(xx1, xx2, yy1, yy2, ok);
          if ok then
            break;
        end;
      end;
      gcneb:
      begin
        VerGCat := rtNeb;
        CurGCat := 0;
        ok := False;
        while NewGCat do
        begin
          OpenGCat(xx1, xx2, yy1, yy2, ok);
          CheckMessierColumn;
          if ok then
            break;
        end;
      end;
      else
        ok := False;
    end;
    if not ok then
    begin
      Result := False;
      exit;
    end;
  end;
  repeat
    radius := 0;
    case cat of
      DefStar: ok := GetDefaultStars(rec);
      sky2000: ok := GetSky2000(rec);
      tyc: ok := GetTYC(rec);
      tyc2: ok := GetTYC2(rec);
      tic: ok := GetTIC(rec);
      gscf: ok := GetGSCF(rec);
      gscc: ok := GetGSCC(rec);
      gsc: ok := GetGSC(rec);
      usnoa: ok := GetUSNOA(rec);
      usnob: ok := GetUSNOB(rec);
      hn290: ok := Get290(rec);
      gaia: ok := GetGaia(rec);
      microcat: ok := GetMCT(rec);
      dsbase: ok := GetDSbase(rec);
      dstyc: ok := GetDSTyc(rec);
      dsgsc: ok := GetDSGsc(rec);
      bsc: ok := GetBSC(rec);
      gcvs: ok := GetGCVS(rec);
      wds: ok := GetWDS(rec);
      sac:
      begin
        ok := GetSAC(rec);
        radius := GetRadius(rec);
      end;
      ngc:
      begin
        ok := GetNGC(rec);
        radius := GetRadius(rec);
      end;
      lbn:
      begin
        ok := GetLBN(rec);
        radius := GetRadius(rec);
      end;
      sh2:
      begin
        ok := GetSH2(rec);
        radius := GetRadius(rec);
      end;
      drk:
      begin
        ok := GetDRK(rec);
        radius := GetRadius(rec);
      end;
      rc3:
      begin
        ok := GetRC3(rec);
        radius := GetRadius(rec);
      end;
      pgc:
      begin
        ok := GetPGC(rec);
        radius := GetRadius(rec);
      end;
      ocl:
      begin
        ok := GetOCL(rec);
        radius := GetRadius(rec);
      end;
      gcm:
      begin
        ok := GetGCM(rec);
        radius := GetRadius(rec);
      end;
      gpn:
      begin
        ok := GetGPN(rec);
        radius := GetRadius(rec);
      end;
      vostar:
      begin
        ok := GetVOcatS(rec);
      end;
      voneb:
      begin
        ok := GetVOcatN(rec);
      end;
      uneb:
      begin
        ok := GetUObjN(rec);
      end;
      gcstar:
      begin
        ok := GetGcatS(rec);
        while not ok do
        begin
          ok := NewGcat;
          if not ok then
            break;
          OpenGCat(xx1, xx2, yy1, yy2, ok);
          ok := GetGcatS(rec);
        end;
      end;
      gcvar:
      begin
        ok := GetGcatV(rec);
        while not ok do
        begin
          ok := NewGcat;
          if not ok then
            break;
          OpenGCat(xx1, xx2, yy1, yy2, ok);
          ok := GetGcatV(rec);
        end;
      end;
      gcdbl:
      begin
        ok := GetGcatD(rec);
        while not ok do
        begin
          ok := NewGcat;
          if not ok then
            break;
          OpenGCat(xx1, xx2, yy1, yy2, ok);
          ok := GetGcatD(rec);
        end;
      end;
      gcneb:
      begin
        ok := GetGcatN(rec);
        while not ok do
        begin
          ok := NewGcat;
          if not ok then
            break;
          OpenGCat(xx1, xx2, yy1, yy2, ok);
          CheckMessierColumn;
          ok := GetGcatN(rec);
        end;
        radius := GetRadius(rec);
      end;
      else
        ok := False;
    end;
    if not ok then
      break;
    cfgsc.FindStarPM := False;
    epoch := 0;
    fullmotion := False;
    if cfgsc.PMon and (rec.options.rectype = rtStar) and rec.star.valid[vsPmra] and
      rec.star.valid[vsPmdec] then
    begin
      if rec.star.valid[vsEpoch] then
        epoch := rec.star.epoch
      else
        epoch := rec.options.Epoch;
      dyear := cyear - epoch;
      fullmotion := (rec.star.valid[vsPx] and(rec.star.px>0)and(rec.star.px<0.8) and (trim(rec.options.flabel[26]) = 'RV'));
      propermotion(rec.ra, rec.Dec, dyear, rec.star.pmra, rec.star.pmdec,
        fullmotion, rec.star.px, rec.num[1]);
      cfgsc.FindStarPM := True;
    end;
    cfgsc.FindRA2000 := rec.ra;
    cfgsc.FindDec2000 := rec.Dec;
    Precession(rec.options.EquinoxJD, jd2000, cfgsc.FindRA2000, cfgsc.FindDec2000);
    sofa_S2C(rec.ra, rec.Dec, p);
    PrecessionV(rec.options.EquinoxJD, cfgsc.JDChart, p);
    if cfgsc.ApparentPos then
      apparent_equatorialV(p, cfgsc, True, True);
    sofa_c2s(p, rec.ra, rec.Dec);
    rec.ra := rmod(rec.ra + pi2, pi2);
    if (rec.ra < pid4) then
      rec.ra := rec.ra + rac;
    found := True;
    if truncate then
    begin
      if (rec.ra < x1) or (rec.ra > x2) then
        found := False;
      if (rec.Dec < y1) or (rec.Dec > y2) then
        found := False;
      if (not searchcenter) and (not found) and (radius > 0) then
      begin
        if AngularDistance(xxc, yyc, rec.ra, rec.Dec) < radius then
          found := True;
      end;
      if not found then
        continue;
    end;
    if SampConnected and (cat = voneb) then
    begin
      cfgcat.SampFindTable := vocat.SAMPid;
      cfgcat.SampFindURL := vocat.SAMPurl;
      cfgcat.SampFindRec := vocat.VOcatrec;
    end
    else
      cfgcat.SampFindTable := '';
    if (rec.options.rectype = rtStar) and rec.star.valid[vsB_v] then
      cfgsc.FindBV := rec.star.b_v
    else
      cfgsc.FindBV := 0;
    if (rec.options.rectype = rtStar) and rec.star.valid[vsMagv] then
      cfgsc.FindMag := rec.star.magv
    else
      cfgsc.FindBV := 0;
    if cfgsc.FindStarPM then
    begin
      cfgsc.FindPMra := rec.star.pmra;
      cfgsc.FindPMde := rec.star.pmdec;
      cfgsc.FindPMEpoch := epoch;
      if (rec.star.px>0)and(rec.star.px<0.8) then cfgsc.FindPMpx := rec.star.px;
      cfgsc.FindPMrv := rec.num[1];
      cfgsc.FindPMfullmotion := fullmotion;
    end
    else
    begin
      cfgsc.FindPMra := 0;
      cfgsc.FindPMde := 0;
      cfgsc.FindPMEpoch := 0;
      cfgsc.FindPMpx := 0;
      cfgsc.FindPMrv := 0;
      cfgsc.FindPMfullmotion := False;
    end;
    break;
  until False;
  Result := ok;
end;

function Tcatalog.FindInWin(cat: integer; nextobj: boolean; cfgsc: Tconf_skychart; var rec: Gcatrec): boolean;
var
  xx1, yy1, cyear, dyear, radius, epoch: double;
  xx, yy: single;
  p: coordvector;
  ok, found, fullmotion: boolean;
begin
  if cfgsc.YPmon = 0 then
    cyear := cfgsc.CurYear + DayofYear(cfgsc.CurYear, cfgsc.CurMonth, cfgsc.CurDay) / 365.25
  else
    cyear := cfgsc.YPmon;
  if not nextobj then
  begin
    InitRec(cat);
    case cat of
      DefStar: ok:=OpenDefaultStars;
      sky2000: OpenSKYwin(ok);
      tyc: OpenTYCwin(ok);
      tyc2: OpenTY2win(2, ok);
      tic: OpenTICwin(ok);
      gscf: OpenGSCFwin(ok);
      gscc: OpenGSCCwin(ok);
      gsc: OpenGSCwin(ok);
      usnoa: OpenUSNOAwin(ok);
      usnob: OpenUSNOBwin(ok);
      hn290: Open290win(ok);
      gaia: ok:=OpenGaia;
      microcat: OpenMCTwin(3, ok);
      dsbase: OpenDSbasewin(ok);
      dstyc: OpenDSTYCwin(ok);
      dsgsc: OpenDSGSCwin(ok);
      bsc: OpenBSCwin(ok);
      gcvs: OpenGCVwin(ok);
      wds: OpenWDSwin(ok);
      sac: OpenSACwin(ok);
      ngc: ok:=OpenNGC;
      lbn: OpenLBNwin(ok);
      sh2: ok:=OpenSH2;
      drk: ok:=OpenDRK;
      rc3: OpenRC3win(ok);
      pgc: OpenPGCwin(ok);
      ocl: OpenOCLwin(ok);
      gcm: OpenGCMwin(ok);
      gpn: OpenGPNwin(ok);
      vostar:
      begin
        VOobject := 'star';
        SetVOCatpath(slash(VODir));
        OpenVOCatwin(ok);
      end;
      voneb:
      begin
        VOobject := 'dso';
        SetVOCatpath(slash(VODir));
        OpenVOCatwin(ok);
      end;
      uneb:
      begin
        CurrentUserObj := -1;
        ok := True;
      end;
      gcstar:
      begin
        VerGCat := rtStar;
        CurGCat := 0;
        ok := False;
        while NewGCat do
        begin
          OpenGCatwin(ok);
          if ok then
            break;
        end;
      end;
      gcvar:
      begin
        VerGCat := rtVar;
        CurGCat := 0;
        ok := False;
        while NewGCat do
        begin
          OpenGCatwin(ok);
          if ok then
            break;
        end;
      end;
      gcdbl:
      begin
        VerGCat := rtDbl;
        CurGCat := 0;
        ok := False;
        while NewGCat do
        begin
          OpenGCatwin(ok);
          if ok then
            break;
        end;
      end;
      gcneb:
      begin
        VerGCat := rtNeb;
        CurGCat := 0;
        ok := False;
        while NewGCat do
        begin
          OpenGCatwin(ok);
          CheckMessierColumn;
          if ok then
            break;
        end;
      end;
      else
        ok := False;
    end;
    if not ok then
    begin
      Result := False;
      exit;
    end;
  end;
  repeat
    radius := 0;
    case cat of
      DefStar: ok := GetDefaultStars(rec);
      sky2000: ok := GetSky2000(rec);
      tyc: ok := GetTYC(rec);
      tyc2: ok := GetTYC2(rec);
      tic: ok := GetTIC(rec);
      gscf: ok := GetGSCF(rec);
      gscc: ok := GetGSCC(rec);
      gsc: ok := GetGSC(rec);
      usnoa: ok := GetUSNOA(rec);
      usnob: ok := GetUSNOB(rec);
      hn290: ok := Get290(rec);
      gaia: ok := GetGaia(rec);
      microcat: ok := GetMCT(rec);
      dsbase: ok := GetDSbase(rec);
      dstyc: ok := GetDSTyc(rec);
      dsgsc: ok := GetDSGsc(rec);
      bsc: ok := GetBSC(rec);
      gcvs: ok := GetGCVS(rec);
      wds: ok := GetWDS(rec);
      sac:
      begin
        ok := GetSAC(rec);
        radius := GetRadius(rec);
      end;
      ngc:
      begin
        ok := GetNGC(rec);
        radius := GetRadius(rec);
      end;
      lbn:
      begin
        ok := GetLBN(rec);
        radius := GetRadius(rec);
      end;
      sh2:
      begin
        ok := GetSH2(rec);
        radius := GetRadius(rec);
      end;
      drk:
      begin
        ok := GetDRK(rec);
        radius := GetRadius(rec);
      end;
      rc3:
      begin
        ok := GetRC3(rec);
        radius := GetRadius(rec);
      end;
      pgc:
      begin
        ok := GetPGC(rec);
        radius := GetRadius(rec);
      end;
      ocl:
      begin
        ok := GetOCL(rec);
        radius := GetRadius(rec);
      end;
      gcm:
      begin
        ok := GetGCM(rec);
        radius := GetRadius(rec);
      end;
      gpn:
      begin
        ok := GetGPN(rec);
        radius := GetRadius(rec);
      end;
      vostar:
      begin
        ok := GetVOcatS(rec);
      end;
      voneb:
      begin
        ok := GetVOcatN(rec);
      end;
      uneb:
      begin
        ok := GetUObjN(rec);
      end;
      gcstar:
      begin
        ok := GetGcatS(rec);
        while not ok do
        begin
          ok := NewGcat;
          if not ok then
            break;
          OpenGCatwin(ok);
          ok := GetGcatS(rec);
        end;
      end;
      gcvar:
      begin
        ok := GetGcatV(rec);
        while not ok do
        begin
          ok := NewGcat;
          if not ok then
            break;
          OpenGCatwin(ok);
          ok := GetGcatV(rec);
        end;
      end;
      gcdbl:
      begin
        ok := GetGcatD(rec);
        while not ok do
        begin
          ok := NewGcat;
          if not ok then
            break;
          OpenGCatwin(ok);
          ok := GetGcatD(rec);
        end;
      end;
      gcneb:
      begin
        ok := GetGcatN(rec);
        while not ok do
        begin
          ok := NewGcat;
          if not ok then
            break;
          OpenGCatwin(ok);
          CheckMessierColumn;
          ok := GetGcatN(rec);
        end;
        radius := GetRadius(rec);
      end;
      else
        ok := False;
    end;
    if not ok then
      break;
    cfgsc.FindStarPM := False;
    epoch := 0;
    fullmotion := False;
    if cfgsc.PMon and (rec.options.rectype = rtStar) and rec.star.valid[vsPmra] and
      rec.star.valid[vsPmdec] then
    begin
      if rec.star.valid[vsEpoch] then
        epoch := rec.star.epoch
      else
        epoch := rec.options.Epoch;
      dyear := cyear - epoch;
      fullmotion := (rec.star.valid[vsPx] and(rec.star.px>0)and(rec.star.px<0.8) and (trim(rec.options.flabel[26]) = 'RV'));
      propermotion(rec.ra, rec.Dec, dyear, rec.star.pmra, rec.star.pmdec,
        fullmotion, rec.star.px, rec.num[1]);
      cfgsc.FindStarPM := True;
    end;
    cfgsc.FindRA2000 := rec.ra;
    cfgsc.FindDec2000 := rec.Dec;
    Precession(rec.options.EquinoxJD, jd2000, cfgsc.FindRA2000, cfgsc.FindDec2000);
    sofa_S2C(rec.ra, rec.Dec, p);
    PrecessionV(rec.options.EquinoxJD, cfgsc.JDChart, p);
    if cfgsc.ApparentPos then
      apparent_equatorialV(p, cfgsc, True, True);
    sofa_c2s(p, rec.ra, rec.Dec);
    rec.ra := rmod(rec.ra + pi2, pi2);
    projection(rec.ra, rec.Dec, xx1, yy1, True, cfgsc);
    WindowXY(xx1, yy1, xx, yy, cfgsc);
    found:=((xx > cfgsc.Xmin) and (xx < cfgsc.Xmax) and (yy > cfgsc.Ymin) and (yy < cfgsc.Ymax));
    if not found then
       continue;
    if SampConnected and (cat = voneb) then
    begin
      cfgcat.SampFindTable := vocat.SAMPid;
      cfgcat.SampFindURL := vocat.SAMPurl;
      cfgcat.SampFindRec := vocat.VOcatrec;
    end
    else
      cfgcat.SampFindTable := '';
    if (rec.options.rectype = rtStar) and rec.star.valid[vsB_v] then
      cfgsc.FindBV := rec.star.b_v
    else
      cfgsc.FindBV := 0;
    if (rec.options.rectype = rtStar) and rec.star.valid[vsMagv] then
      cfgsc.FindMag := rec.star.magv
    else
      cfgsc.FindBV := 0;
    if cfgsc.FindStarPM then
    begin
      cfgsc.FindPMra := rec.star.pmra;
      cfgsc.FindPMde := rec.star.pmdec;
      cfgsc.FindPMEpoch := epoch;
      if (rec.star.px>0)and(rec.star.px<0.8) then cfgsc.FindPMpx := rec.star.px;
      cfgsc.FindPMrv := rec.num[1];
      cfgsc.FindPMfullmotion := fullmotion;
    end
    else
    begin
      cfgsc.FindPMra := 0;
      cfgsc.FindPMde := 0;
      cfgsc.FindPMEpoch := 0;
      cfgsc.FindPMpx := 0;
      cfgsc.FindPMrv := 0;
      cfgsc.FindPMfullmotion := False;
    end;
    break;
  until False;
  Result := ok;
end;

function Tcatalog.FindObj(x1, y1, x2, y2: double;
  searchcenter: boolean; cfgsc: Tconf_skychart;
  var rec: Gcatrec; ftype: integer = ftAll): boolean;
var
  ok, nextobj: boolean;
begin
  ok := False;
  nextobj := False;
  if cfgcat.NebCatOn[uneb - BaseNeb] then
    ok := FindAtPos(uneb, x1, y1, x2, y2, nextobj, True, searchcenter, cfgsc, rec);
  if (not ok) and cfgcat.NebCatOn[voneb - BaseNeb] then
  begin
    ok := FindAtPos(voneb, x1, y1, x2, y2, nextobj, True, searchcenter, cfgsc, rec);
    CloseVOCat;
  end;
  if cfgsc.shownebulae and ((ftype = ftAll) or (ftype = ftNeb)) then
  begin
    if (not ok) then
    begin
      ok := FindAtPos(gcneb, x1, y1, x2, y2, nextobj, True, searchcenter, cfgsc, rec);
      CloseGcat;
    end;
    if (not ok) and cfgcat.nebcaton[sac - BaseNeb] then
    begin
      ok := FindAtPos(sac, x1, y1, x2, y2, nextobj, True, searchcenter, cfgsc, rec);
      CloseSAC;
    end;
    if (not ok) and cfgcat.nebcaton[ngc - BaseNeb] then
    begin
      ok := FindAtPos(ngc, x1, y1, x2, y2, nextobj, True, searchcenter, cfgsc, rec);
      CloseNGC;
    end;
    if (not ok) and cfgcat.nebcaton[lbn - BaseNeb] then
    begin
      ok := FindAtPos(lbn, x1, y1, x2, y2, nextobj, True, searchcenter, cfgsc, rec);
      CloseLBN;
    end;
    if (not ok) and cfgcat.nebcaton[sh2 - BaseNeb] then
    begin
      ok := FindAtPos(sh2, x1, y1, x2, y2, nextobj, True, searchcenter, cfgsc, rec);
      CloseSH2;
    end;
    if (not ok) and cfgcat.nebcaton[drk - BaseNeb] then
    begin
      ok := FindAtPos(drk, x1, y1, x2, y2, nextobj, True, searchcenter, cfgsc, rec);
      CloseDRK;
    end;
    if (not ok) and cfgcat.nebcaton[rc3 - BaseNeb] then
    begin
      ok := FindAtPos(rc3, x1, y1, x2, y2, nextobj, True, searchcenter, cfgsc, rec);
      CloseRC3;
    end;
    if (not ok) and cfgcat.nebcaton[pgc - BaseNeb] then
    begin
      ok := FindAtPos(pgc, x1, y1, x2, y2, nextobj, True, searchcenter, cfgsc, rec);
      ClosePGC;
    end;
    if (not ok) and cfgcat.nebcaton[ocl - BaseNeb] then
    begin
      ok := FindAtPos(ocl, x1, y1, x2, y2, nextobj, True, searchcenter, cfgsc, rec);
      CloseOCL;
    end;
    if (not ok) and cfgcat.nebcaton[gcm - BaseNeb] then
    begin
      ok := FindAtPos(gcm, x1, y1, x2, y2, nextobj, True, searchcenter, cfgsc, rec);
      CloseGCM;
    end;
    if (not ok) and cfgcat.nebcaton[gpn - BaseNeb] then
    begin
      ok := FindAtPos(gpn, x1, y1, x2, y2, nextobj, True, searchcenter, cfgsc, rec);
      CloseGPN;
    end;
  end;
  if cfgsc.showstars and ((ftype = ftAll) or (ftype = ftStar) or (ftype = ftVar) or (ftype = ftDbl)) then
  begin
    if (not ok) and cfgcat.starcaton[vostar - BaseStar] then
    begin
      ok := FindAtPos(vostar, x1, y1, x2, y2, nextobj, True, searchcenter, cfgsc, rec);
      CloseVOCat;
    end;
    if (not ok) and ((ftype = ftAll) or (ftype = ftVar)) then
    begin
      ok := FindAtPos(gcvar, x1, y1, x2, y2, nextobj, True, searchcenter, cfgsc, rec);
      CloseGcat;
    end;
    if (not ok) and ((ftype = ftAll) or (ftype = ftVar)) and
      cfgcat.varstarcaton[gcvs - BaseVar] then
    begin
      ok := FindAtPos(gcvs, x1, y1, x2, y2, nextobj, True, searchcenter, cfgsc, rec);
      CloseGCV;
    end;
    if (not ok) and ((ftype = ftAll) or (ftype = ftDbl)) then
    begin
      ok := FindAtPos(gcdbl, x1, y1, x2, y2, nextobj, True, searchcenter, cfgsc, rec);
      CloseGcat;
    end;
    if (not ok) and ((ftype = ftAll) or (ftype = ftDbl)) and
      cfgcat.dblstarcaton[wds - BaseDbl] then
    begin
      ok := FindAtPos(wds, x1, y1, x2, y2, nextobj, True, searchcenter, cfgsc, rec);
      CloseWDS;
    end;
    if (not ok) and cfgcat.starcaton[DefStar - BaseStar] then
    begin
      ok := FindAtPos(DefStar, x1, y1, x2, y2, nextobj, True, searchcenter, cfgsc, rec);
      CloseDefaultStars;
    end;
    if (not ok) then
    begin
      ok := FindAtPos(gcstar, x1, y1, x2, y2, nextobj, True, searchcenter, cfgsc, rec);
      CloseGcat;
    end;
    if (not ok) and cfgcat.starcaton[dsbase - BaseStar] then
    begin
      ok := FindAtPos(dsbase, x1, y1, x2, y2, nextobj, True, searchcenter, cfgsc, rec);
      CloseDSbase;
    end;
    if (not ok) and cfgcat.starcaton[sky2000 - BaseStar] then
    begin
      ok := FindAtPos(sky2000, x1, y1, x2, y2, nextobj, True, searchcenter, cfgsc, rec);
      CloseSky;
    end;
    if (not ok) and cfgcat.starcaton[tyc - BaseStar] then
    begin
      ok := FindAtPos(tyc, x1, y1, x2, y2, nextobj, True, searchcenter, cfgsc, rec);
      CloseTYC;
    end;
    if (not ok) and cfgcat.starcaton[tyc2 - BaseStar] then
    begin
      ok := FindAtPos(tyc2, x1, y1, x2, y2, nextobj, True, searchcenter, cfgsc, rec);
      CloseTY2;
    end;
    if (not ok) and cfgcat.starcaton[tic - BaseStar] then
    begin
      ok := FindAtPos(tic, x1, y1, x2, y2, nextobj, True, searchcenter, cfgsc, rec);
      CloseTIC;
    end;
    if (not ok) and cfgcat.starcaton[dstyc - BaseStar] then
    begin
      ok := FindAtPos(dstyc, x1, y1, x2, y2, nextobj, True, searchcenter, cfgsc, rec);
      CloseDStyc;
    end;
    if (not ok) and cfgcat.starcaton[gsc - BaseStar] then
    begin
      ok := FindAtPos(gsc, x1, y1, x2, y2, nextobj, True, searchcenter, cfgsc, rec);
      CloseGSC;
    end;
    if (not ok) and cfgcat.starcaton[gscf - BaseStar] then
    begin
      ok := FindAtPos(gscf, x1, y1, x2, y2, nextobj, True, searchcenter, cfgsc, rec);
      CloseGSCF;
    end;
    if (not ok) and cfgcat.starcaton[gscc - BaseStar] then
    begin
      ok := FindAtPos(gscc, x1, y1, x2, y2, nextobj, True, searchcenter, cfgsc, rec);
      CloseGSCC;
    end;
    if (not ok) and cfgcat.starcaton[dsgsc - BaseStar] then
    begin
      ok := FindAtPos(dsgsc, x1, y1, x2, y2, nextobj, True, searchcenter, cfgsc, rec);
      CloseDSgsc;
    end;
    if (not ok) and cfgcat.starcaton[usnoa - BaseStar] then
    begin
      ok := FindAtPos(usnoa, x1, y1, x2, y2, nextobj, True, searchcenter, cfgsc, rec);
      CloseUSNOA;
    end;
    if (not ok) and cfgcat.starcaton[usnob - BaseStar] then
    begin
      ok := FindAtPos(usnob, x1, y1, x2, y2, nextobj, True, searchcenter, cfgsc, rec);
      CloseUSNOB;
    end;
    if (not ok) and cfgcat.starcaton[hn290 - BaseStar] then
    begin
      ok := FindAtPos(hn290, x1, y1, x2, y2, nextobj, True, searchcenter, cfgsc, rec);
      Close290;
    end;
    if (not ok) and cfgcat.starcaton[gaia - BaseStar] then
    begin
      ok := FindAtPos(gaia, x1, y1, x2, y2, nextobj, True, searchcenter, cfgsc, rec);
      CloseGaia;
    end;
    if (not ok) and cfgcat.starcaton[microcat - BaseStar] then
    begin
      ok := FindAtPos(microcat, x1, y1, x2, y2, nextobj, True, searchcenter, cfgsc, rec);
      CloseMCT;
    end;
    if (not ok) and cfgcat.starcaton[bsc - BaseStar] then
    begin
      ok := FindAtPos(bsc, x1, y1, x2, y2, nextobj, True, searchcenter, cfgsc, rec);
      CloseBSC;
    end;
  end;
{ if (not ok) and Catalog1Show then FindCatalogue1(ar,de,dx,dx,nextobj,ok,nom,ma,desc);
  if (not ok) and Catalog2Show then FindCatalogue2(ar,de,dx,dx,nextobj,ok,nom,ma,desc,notes);
  if (not ok) and ArtSatOn then FindSatellite(ar,de,dx,dx,nextobj,ok,nom,ma,desc);}
  Result := ok;
  cfgsc.FindOK := ok;
end;

procedure Tcatalog.GetAltName(rec: GCatrec; var txt: string);
var
  i: integer;
begin
  for i := 1 to 10 do
  begin
    if (rec.vstr[i]) and (rec.options.altname[i]) then
    begin
      txt := rec.str[i];
      if trim(txt) > '' then
      begin
        if (rec.options.UsePrefix = 1) or ((rec.options.UsePrefix = 2) and
          (rec.options.altprefix[i])) then
          txt := trim(rec.options.flabel[15 + i]) + txt;
        break;
      end;
    end;
  end;
  if trim(txt) = '' then
    txt := rec.options.ShortName;
  if trim(txt) = '' then
    txt := rec.options.LongName;
  if trim(txt) = '' then
    txt := '?';
end;

function Tcatalog.CheckPath(cat: integer; catpath: string): boolean;
begin
  case cat of
    DefStar: Result := IsDefaultStarspath(catpath);
    bsc: Result := IsBSCPath(catpath);
    sky2000: Result := IsSkyPath(catpath);
    tyc: Result := IsTYCPath(catpath);
    tyc2: Result := IsTY2Path(catpath);
    tic: Result := IsTICPath(catpath);
    gscf: Result := IsGSCFPath(catpath);
    gscc: Result := IsGSCCPath(catpath);
    gsc: Result := IsGSCPath(catpath);
    usnoa: Result := IsUSNOAPath(catpath);
    usnob: Result := IsUSNOBPath(catpath);
    hn290: Result := Is290Path(catpath);
    gaia: Result := IsGaiaPath(catpath);
    microcat: Result := IsMCTPath(catpath);
    dsbase: Result := IsDSbasePath(catpath);
    dstyc: Result := IsDSTycPath(catpath);
    dsgsc: Result := IsDSGscPath(catpath);
    gcvs: Result := IsGCVPath(catpath);
    wds: Result := IsWDSPath(catpath);
    sac: Result := IsSACPath(catpath);
    ngc: Result := IsNGCPath(catpath);
    lbn: Result := IsLBNPath(catpath);
    sh2: Result := IsSH2Path(catpath);
    drk: Result := IsDRKPath(catpath);
    rc3: Result := IsRC3Path(catpath);
    pgc: Result := IsPGCPath(catpath);
    ocl: Result := IsOCLPath(catpath);
    gcm: Result := IsGCMPath(catpath);
    gpn: Result := IsGPNPath(catpath);
    else
      Result := False;
  end;
end;

procedure Tcatalog.LoadConstellation(fpath, lang: string);
var
  f: textfile;
  i, n, p: integer;
  fname, txt: string;
begin
  fname := slash(fpath) + 'constlabel_' + lang + '.cla';
  if not FileExists(fname) then
    fname := slash(fpath) + 'constlabel.cla';
  if not FileExists(fname) then
  begin
    cfgshr.ConstelNum := 0;
    setlength(cfgshr.ConstelName, 0);
    setlength(cfgshr.ConstelPos, 0);
    exit;
  end;
  Filemode := 0;
  assignfile(f, fname);
  try
    reset(f);
    n := 0;
    // first loop to get the size
    repeat
      readln(f, txt);
      txt := trim(txt);
      if (txt = '') or (copy(txt, 1, 1) = ';') then
        continue;
      Inc(n);
    until EOF(f);
    setlength(cfgshr.ConstelName, n);
    setlength(cfgshr.ConstelPos, n);
    // read the file now
    reset(f);
    i := 0;
    repeat
      readln(f, txt);
      txt := Condutf8decode(trim(txt));
      if (txt = '') or (copy(txt, 1, 1) = ';') then
        continue;
      p := pos(';', txt);
      if p = 0 then
      begin
        ShowMessage(txt);
        continue;
      end;
      if not isnumber(trim(copy(txt, 1, p - 1))) then
        continue;
      cfgshr.ConstelPos[i].ra := deg2rad * 15 * strtofloat(trim(copy(txt, 1, p - 1)));
      Delete(txt, 1, p);
      p := pos(';', txt);
      if p = 0 then
      begin
        ShowMessage(txt);
        continue;
      end;
      cfgshr.ConstelPos[i].de := deg2rad * strtofloat(trim(copy(txt, 1, p - 1)));
      Delete(txt, 1, p);
      p := pos(';', txt);
      if p = 0 then
      begin
        ShowMessage(txt);
        continue;
      end;
      cfgshr.ConstelName[i, 1] := trim(copy(txt, 1, p - 1));
      Delete(txt, 1, p);
      cfgshr.ConstelName[i, 2] := trim(txt);
      Inc(i);
    until EOF(f) or (i >= n);
    cfgshr.ConstelNum := n;
  finally
    closefile(f);
  end;
end;

procedure Tcatalog.LoadConstL(fname: string);
var
  f: textfile;
  i, n: integer;
  ra1, ra2, de1, de2: single;
  buf, h1, h2: string;
  filter, ok: boolean;
  ver, ctype: integer;
  rec: GCatrec;
  h: TCatHeader;
  info: TCatHdrInfo;
begin
  if not FileExists(fname) then
  begin
    cfgshr.ConstLNum := 0;
    setlength(cfgshr.ConstL, 0);
    exit;
  end;
  Filemode := 0;
  assignfile(f, fname);
  try
    // get file type
    reset(f);
    readln(f, buf);
    if Copy(buf, 1, 1) = ';' then
      ctype := 0
    else
      ctype := 1;
    // first loop to get the size
    reset(f);
    n := 0;
    repeat
      readln(f, buf);
      if trim(buf) = '' then
        continue;
      if copy(buf, 1, 1) = ';' then
        continue;
      Inc(n);
    until EOF(f);
    setlength(cfgshr.ConstL, n);
    // read the file now
    reset(f);
    case ctype of
      0:
      begin    // HR number
        i := 0;
        SetGCatpath(cfgcat.StarCatPath[DefStar - BaseStar], 'star');
        GetGCatInfo(h, info, ver, filter, ok);
        cfgshr.ConstLepoch := 0;
        repeat
          readln(f, buf);
          if trim(buf) = '' then
            continue;
          if copy(buf, 1, 1) = ';' then
            continue;
          h1 := trim(copy(buf, 6, 5));
          h2 := trim(copy(buf, 13, 5));
          FindNumGcatRec(cfgcat.StarCatPath[DefStar - BaseStar],
            'star', 'HR' + h1, 11, rec, ok);
          if not ok then
            continue;
          if cfgshr.ConstLepoch = 0 then
          begin
            if rec.star.valid[vsEpoch] then
              cfgshr.ConstLepoch := rec.star.epoch
            else
              cfgshr.ConstLepoch := rec.options.Epoch;
          end;
          cfgshr.ConstL[i].pm := True;
          cfgshr.ConstL[i].ra1 := deg2rad * rec.ra;
          cfgshr.ConstL[i].de1 := deg2rad * rec.Dec;
          cfgshr.ConstL[i].pmra1 := deg2rad * rec.star.pmra / 3600;
          cfgshr.ConstL[i].pmde1 := deg2rad * rec.star.pmdec / 3600;
          cfgshr.ConstL[i].pxrv1 :=
            (rec.star.valid[vsPx] and (rec.star.px>0)and(rec.star.px<0.8) and (trim(rec.options.flabel[26]) = 'RV'));
          cfgshr.ConstL[i].px1 := rec.star.px;
          cfgshr.ConstL[i].rv1 := rec.num[1];
          FindNumGcatRec(cfgcat.StarCatPath[DefStar - BaseStar],
            'star', 'HR' + h2, 11, rec, ok);
          if not ok then
            continue;
          cfgshr.ConstL[i].ra2 := deg2rad * rec.ra;
          cfgshr.ConstL[i].de2 := deg2rad * rec.Dec;
          cfgshr.ConstL[i].pmra2 := deg2rad * rec.star.pmra / 3600;
          cfgshr.ConstL[i].pmde2 := deg2rad * rec.star.pmdec / 3600;
          cfgshr.ConstL[i].pxrv2 :=
            (rec.star.valid[vsPx] and (rec.star.px>0)and(rec.star.px<0.8) and (trim(rec.options.flabel[26]) = 'RV'));
          cfgshr.ConstL[i].px2 := rec.star.px;
          cfgshr.ConstL[i].rv2 := rec.num[1];
          Inc(i);
        until EOF(f);
      end;
      1:
      begin   // Coordinates
        cfgshr.ConstLepoch := jd2000;
        for i := 0 to n - 1 do
        begin
            {$I-}
          readln(f, ra1, de1, ra2, de2);
          ok := (IOResult = 0);
            {$I+}
          if not ok then
          begin
            if VerboseMsg then
              WriteTrace('Error in file ' + fname + ' , row ' + IntToStr(i + 1));
            continue;
          end;
          cfgshr.ConstL[i].ra1 := deg2rad * ra1 * 15;
          cfgshr.ConstL[i].de1 := deg2rad * de1;
          cfgshr.ConstL[i].ra2 := deg2rad * ra2 * 15;
          cfgshr.ConstL[i].de2 := deg2rad * de2;
          cfgshr.ConstL[i].pm := False;
        end;
      end;
    end;
    cfgshr.ConstLNum := n;
  finally
    closefile(f);
  end;
end;

procedure Tcatalog.LoadConstB(fname: string);
var
  f: textfile;
  i, n: integer;
  ra, de: double;
  constel, curconst: string;
begin
  if not FileExists(fname) then
  begin
    cfgshr.ConstBNum := 0;
    setlength(cfgshr.ConstB, 0);
    exit;
  end;
  Filemode := 0;
  assignfile(f, fname);
  try
    reset(f);
    n := 0;
    // first loop to get the size
    repeat
      readln(f, constel);
      Inc(n);
    until EOF(f);
    setlength(cfgshr.ConstB, n);
    // read the file now
    reset(f);
    curconst := '';
    for i := 0 to n - 1 do
    begin
      readln(f, ra, de, constel);
      cfgshr.ConstB[i].ra := deg2rad * ra * 15;
      cfgshr.ConstB[i].de := deg2rad * de;
      cfgshr.ConstB[i].newconst := (constel <> curconst);
      curconst := constel;
    end;
    cfgshr.ConstBNum := n;
  finally
    closefile(f);
  end;
end;

procedure Tcatalog.LoadMilkywaydot(fname: string);
var
  f: textfile;
  i, n: integer;
  ra, de: single;
  val: byte;
begin
  if not FileExists(fname) then
  begin
    cfgshr.MilkywaydotNum := 0;
    setlength(cfgshr.Milkywaydot, 0);
    exit;
  end;
  Filemode := 0;
  assignfile(f, fname);
  try
    reset(f);
    n := 0;
    // first loop to get the size
    readln(f);
    repeat
      readln(f);
      Inc(n);
    until EOF(f);
    setlength(cfgshr.Milkywaydot, n);
    // read the file now
    reset(f);
    readln(f, cfgshr.Milkywaydotradius);
    for i := 0 to n - 1 do
    begin
      readln(f, ra, de, val);
      cfgshr.Milkywaydot[i].ra := deg2rad * ra * 15;
      cfgshr.Milkywaydot[i].de := deg2rad * de;
      cfgshr.Milkywaydot[i].val := val;
    end;
    cfgshr.MilkywaydotNum := n;
  finally
    closefile(f);
  end;
end;


procedure Tcatalog.LoadStarName(fpath, lang: string);

var

  buf, fname, hr: string;
  f: TextFile;
  n, i: integer;
begin
  fname := slash(fpath) + 'StarsNames_' + lang + '.txt';

  if not fileexists(fname) then
    fname := slash(fpath) + 'StarsNames.txt';

  cfgshr.StarNameNum := 0;

  if not FileExists(fname) then
  begin
    setlength(cfgshr.StarName, 0);
    setlength(cfgshr.StarNameHR, 0);
    exit;
  end;

  assignfile(f, fname);
  FileMode := 0;

  try
    reset(f);
    n := 0;

    // first loop to get the size
    repeat
      readln(f, buf);
      if copy(buf, 1, 1) = ';' then
        continue;
      Inc(n);
    until EOF(f);

    setlength(cfgshr.StarName, n);
    setlength(cfgshr.StarNameHR, n);
    // read the file now
    reset(f);
    i := 0;

    repeat
      Readln(f, buf);
      buf := CondUTF8Decode(buf);
      if copy(buf, 1, 1) = ';' then
        continue;
      hr := trim(copy(buf, 1, 6));
      buf := trim(copy(buf, 10, 999));
      cfgshr.StarName[i] := buf;
      cfgshr.StarNameHR[i] := strtointdef(hr, 0);
      Inc(i);
    until EOF(f);

    cfgshr.StarNameNum := n;
  finally
    CloseFile(f);
  end;
end;


function Tcatalog.LongLabelObj(txt: string): string;
begin
  if txt = 'OC' then
    txt := rsOpenCluster
  else if txt = 'Gb' then
    txt := rsGlobularClus
  else if txt = 'Gx' then
    txt := rsGalaxy
  else if txt = 'Nb' then
    txt := rsBrightNebula
  else if txt = 'Pl' then
    txt := rsPlanetaryNeb
  else if txt = 'C+N' then
    txt := rsClusterAndNe
  else if txt = 'N' then
    txt := rsBrightNebula
  else if txt = '*' then
    txt := rsStar
  else if txt = 'DS*' then
    txt := rsStar
  else if txt = '**' then
    txt := rsDoubleStar
  else if txt = '***' then
    txt := rsTripleStar
  else if txt = 'D*' then
    txt := rsDoubleStar
  else if txt = 'V*' then
    txt := rsVariableStar
  else if txt = 'DSV*' then
    txt := rsVariableStar
  else if txt = 'Ast' then
    txt := rsAsterism
  else if txt = 'Kt' then
    txt := rsKnot
  else if txt = '?' then
    txt := rsUnknowObject
  else if txt = '' then
    txt := rsUnknowObject
  else if txt = '-' then
    txt := rsPlateDefect
  else if txt = 'PD' then
    txt := rsPlateDefect
  else if txt = 'Dup' then
    txt := rsDuplicate
  else if txt = 'S*' then
    txt := rsStar
  else if txt = 'P' then
    txt := rsPlanet
  else if txt = 'DSP' then
    txt := rsPlanet
  else if txt = 'Ps' then
    txt := rsPlanetarySat
  else if txt = 'As' then
    txt := rsAsteroid
  else if txt = 'DSAs' then
    txt := rsAsteroid
  else if txt = 'Cm' then
    txt := rsComet
  else if txt = 'DSCm' then
    txt := rsComet
  else if txt = 'Sat' then
    txt := rsArtificialSa2
  else if txt = 'C1' then
    txt := rsExternalCata
  else if txt = 'C2' then
    txt := rsExternalCata
  else if txt = 'OSR' then
    txt := rsOnlineSearch2;
  Result := txt;
end;

function Tcatalog.LongLabel(txt: string): string;
var
  key, Value: string;
  i: integer;
const
  d = ': ';
begin
  i := pos(':', txt);
  if i > 0 then
  begin
    key := uppercase(trim(copy(txt, 1, i - 1)));
    Value := copy(txt, i + 1, 9999);
    if key = 'MB' then
      Result := rsBlueMagnitud + d + Value
    else if key = 'MV' then
      Result := rsVisualMagnit + d + Value
    else if key = 'MR' then
      Result := rsRedMagnitude + d + Value
    else if key = 'M' then
      Result := rsMagnitude + d + Value
    else if key = 'MI' then
      Result := rsMagnitude + ' ' + 'I' + d + Value
    else if key = 'MJ' then
      Result := rsMagnitude + ' ' + 'J' + d + Value
    else if key = 'MH' then
      Result := rsMagnitude + ' ' + 'H' + d + Value
    else if key = 'MK' then
      Result := rsMagnitude + ' ' + 'K' + d + Value
    else if key = 'MBP' then
      Result := rsMagnitude + ' ' + 'BP' + d + Value
    else if key = 'MRP' then
      Result := rsMagnitude + ' ' + 'RP' + d + Value
    else if key = 'MG' then
      Result := rsMagnitude + ' ' + 'G' + d + Value
    else if key = 'BT' then
      Result := rsMagnitudeTyc + d + Value
    else if key = 'VT' then
      Result := rsMagnitudeTyc2 + d + Value
    else if key = 'B-V' then
      Result := rsColorIndex + ' ' + 'B-V' + d + Value
    else if key = 'SP' then
      Result := rsSpectralClas + d + Value
    else if key = 'PM' then
      Result := rsAnnualProper + d + Value
    else if key = 'CLASS' then
      Result := rsClass + d + Value
    else if key = 'NAME' then
      Result := rsName + d + Value
    else if key = 'N' then
      Result := rsNote + d + Value
    else if key = 'T' then
      Result := rsTypeOfVariab + d + Value
    else if key = 'P' then
      Result := rsPeriod + d + Value
    else if key = 'BAND' then
      Result := rsMagnitudeBan + d + Value
    else if key = 'PLATE' then
      Result := rsPhotographic + d + Value
    else if key = 'MULT' then
      Result := rsMultipleFlag + d + Value
    else if key = 'FIELD' then
      Result := rsFieldNumber + d + Value
    else if key = 'Q' then
      Result := rsMagnitudeErr + d + Value
    else if key = 'S' then
      Result := rsCorrelated + d + Value
    else if key = 'DIM' then
      Result := rsDimension + d + Value
    else if key = 'CONST' then
      Result := rsConstellatio + d + longlabelconst(Value)
    else if key = 'SBR' then
      Result := rsSurfaceBrigh + d + Value
    else if key = 'DESC' then
      Result := rsDescription + d + Value
    else if key = 'RV' then
      Result := rsRadialVeloci + d + Value
    else if key = 'SURFACE' then
      Result := rsSurface + d + Value
    else if key = 'COLOR' then
      Result := rsColor + d + Value
    else if key = 'BRIGHT' then
      Result := rsBrightness + d + Value
    else if key = 'TR' then
      Result := rsTrumplerClas + d + Value
    else if key = 'DIST' then
      Result := rsDistance + d + Value
    else if key = 'M*' then
      Result := rsBrightestSta + d + Value
    else if key = 'N*' then
      Result := rsNumberOfStar + d + Value
    else if key = 'AGE' then
      Result := rsAge + d + Value
    else if key = 'RT' then
      Result := rsTotalRadius + d + Value
    else if key = 'RH' then
      Result := rsHalfMassRadi + d + Value
    else if key = 'RC' then
      Result := rsCoreRadius + d + Value
    else if key = 'MHB' then
      Result := rsHbetaMagnitu + d + Value
    else if key = 'C*B' then
      Result := rsCentralStarB + d + Value
    else if key = 'C*V' then
      Result := rsCentralStarV + d + Value
    else if key = 'DIAM' then
      Result := rsDiameter + d + Value
    else if key = 'ILLUM' then
      Result := rsIlluminatedF + d + Value
    else if key = 'PHASE' then
      Result := rsPhase + d + Value
    else if key = 'TL' then
      Result := rsEstimatedTai + d + Value
    else if key = 'EL' then
      Result := rsSolarElongat + d + Value
    else if key = 'RSOL' then
      Result := rsSolarDistanc + d + Value
    else if key = 'VEL' then
      Result := rsVelocity + d + Value
    else if key = 'D1' then
      Result := rsDescription + ' 1' + d + Value
    else if key = 'D2' then
      Result := rsDescription + ' 2' + d + Value
    else if key = 'D3' then
      Result := rsDescription + ' 3' + d + Value
    else if key = 'FL' then
      Result := rsFlamsteedNum + d + Value
    else if key = 'BA' then
      Result := rsBayerLetter + d + LongLabelGreek(Value)
    else if key = 'PX' then
      Result := rsParallax + d + Value
    else if key = 'PA' then
      Result := rsPositionAngl + d + Value
    else if key = 'PMRA' then
      Result := rsProperMotion + d + Value
    else if key = 'PMDE' then
      Result := rsProperMotion2 + d + Value
    else if key = 'MMAX' then
      Result := rsMagnitudeAtM + d + Value
    else if key = 'MMIN' then
      Result := rsMagnitudeAtM2 + d + Value
    else if key = 'MEPOCH' then
      Result := rsEpochOfMaxim + d + Value
    else if key = 'RISE' then
      Result := rsRiseTime + d + Value
    else if key = 'COMP' then
      Result := rsComponent + d + Value
    else if key = 'COMPID' then
      Result := rsDoubleStar + d + Value
    else if key = 'M1' then
      Result := rsComponent1Ma + d + Value
    else if key = 'M2' then
      Result := rsComponent2Ma + d + Value
    else if key = 'SEP' then
      Result := rsSeparation + d + Value
    else if key = 'DATE' then
      Result := rsDate + d + Value
    else if key = 'POLEINCL' then
      Result := rsPoleInclinat + d + Value
    else if key = 'SUNINCL' then
      Result := rsSunInclinati + d + Value
    else if key = 'CM' then
      Result := rsCentralMerid + d + Value
    else if key = 'CMI' then
      Result := rsCentralMerid + ' I' + d + Value
    else if key = 'CMII' then
      Result := rsCentralMerid + ' II' + d + Value
    else if key = 'CMIII' then
      Result := rsCentralMerid + ' III' + d + Value
    else if key = 'GRSTR' then
      Result := rsGRSTransit + d + Value
    else if key = 'LLAT' then
      Result := rsLibrationInL + d + Value
    else if key = 'LLON' then
      Result := rsLibrationInL2 + d + Value
    else if key = 'EPHEMERIS' then
      Result := rsEphemeris + d + Value
    else if key = 'D' then
      Result := Value
    else
      Result := txt;
  end
  else
    Result := txt;
end;

function Tcatalog.LongLabelConst(txt: string): string;
var
  i: integer;
begin
  txt := uppercase(trim(txt));
  for i := 0 to cfgshr.ConstelNum - 1 do
  begin
    if txt = UpperCase(cfgshr.ConstelName[i, 1]) then
    begin
      txt := cfgshr.ConstelName[i, 2];
      break;
    end;
  end;
  Result := txt;
end;

function Tcatalog.GenitiveConst(txt: string): string;
var
  i: integer;
begin
  txt := uppercase(trim(txt));
  for i := 1 to maxconst do
  begin
    if txt = constel[i, 1] then
    begin
      txt := capitalize(constel[i, 3]);
      break;
    end;
  end;
  Result := txt;
end;

function Tcatalog.LongLabelGreek(txt: string): string;
var
  i: integer;
begin
  txt := uppercase(trim(txt));
  for i := 1 to 24 do
  begin
    if txt = UpperCase(trim(greek[2, i])) then
    begin
      txt := greek[1, i];
      break;
    end;
  end;
  Result := txt;
end;

Procedure Tcatalog.Open290(ar1,ar2,de1,de2: double ; var ok : boolean);
begin
if Is290Path(slash(cfgcat.StarCatPath[hn290 - BaseStar])) then begin
  ar1 := deg2rad * 15 * ar1;
  ar2 := deg2rad * 15 * ar2;
  de1 := deg2rad * de1;
  de2 := deg2rad * de2;
  u_290.RA_290 := (ar2+ar1)/2;
  u_290.DE_290 := (de1+de2)/2;
  u_290.FOV_290 := 1.1 *  max(deg2rad*1,AngularDistance(ar1,de1,ar2,de2));
  if cfgshr.StarFilter then
     u_290.maxmag := round(10 * cfgcat.StarMagMax)
  else
     u_290.maxmag := 999;
  u_290.catalog_path := slash(cfgcat.StarCatPath[hn290 - BaseStar]);
  u_290.name_star:=cfgcat.Name290;
  reset290index;
  EmptyRec.options.ShortName:=u_290.name_star;
  ok:=true;
end
else ok:=false;
end;

Procedure Tcatalog.Open290win(var ok : boolean);
begin
if Is290Path(slash(cfgcat.StarCatPath[hn290 - BaseStar])) then begin
  u_290.RA_290 := deg2rad * 15 * skylibcat.arcentre;
  u_290.DE_290 := deg2rad * skylibcat.decentre;
  u_290.FOV_290 := deg2rad * max(1,skylibcat.fov);
  if cfgshr.StarFilter then
     u_290.maxmag := round(10 * cfgcat.StarMagMax)
  else
     u_290.maxmag := 999;
  u_290.catalog_path := slash(cfgcat.StarCatPath[hn290 - BaseStar]);
  u_290.name_star:=cfgcat.Name290;
  reset290index;
  EmptyRec.options.ShortName:=u_290.name_star;
  ok:=true;
end
else ok:=false;
end;

function  Tcatalog.Get290MagMax: double;
var buf: string;
begin
  {HNSKY catalog max magnitude}
  buf := UpperCase(Trim(cfgcat.Name290));
  if buf='TYC' then result:=12.5
  else if buf='TUC' then result:=15
  else if buf='G15' then result:=15
  else if buf='G16' then result:=16
  else if buf='G17' then result:=17
  else if buf='G18' then result:=18
  else if buf='V15' then result:=15
  else if buf='V16' then result:=16
  else if buf='V17' then result:=17
  else if buf='V18' then result:=18
  else result:=15;
end;

Procedure Tcatalog.Close290;
begin
  reset290index;
end;

function Tcatalog.Is290Path(path : string) : Boolean;
var
  fs: TSearchRec;
  i: integer;
begin
  i := findfirst(slash(path) + '*.290', 0, fs);
  result := i=0;
  findclose(fs);
end;

function Tcatalog.Get290(var rec: GcatRec): boolean;
var
  ra2,dec2 : double;
begin
  rec := EmptyRec;
  Bp_Rp_290 := -999;
  Result := readdatabase290('S', RA_290, DE_290, FOV_290, ra2,dec2, MAG_290, Bp_Rp_290);
  if Result then
  begin
    rec.ra:=ra2;
    rec.dec:=dec2;
    rec.star.magv:=MAG_290/10;
    if Bp_Rp_290<>-999 then begin  // color database
      if Bp_Rp_290>-128 then begin
       rec.options.flabel[lOffset + vsMagv]:='mV';
       rec.vnum[1]:=true;
       rec.num[1]:=Bp_Rp_290/10;
       rec.options.flabel[lOffsetNum+1]:='Bp-Rp';
       rec.star.b_v:=GaiaBRtoBV(rec.num[1]);
       rec.star.valid[vsB_v]:=true;
       end
       else begin  // unknow Bp-Rp
         rec.star.b_v:=0;
         rec.star.valid[vsB_v]:=false;
         rec.vnum[1]:=false;
       end;
    end
    else begin  // Bp only database
       rec.star.b_v:=0;
       rec.star.valid[vsB_v]:=false;
       rec.vnum[1]:=false;
    end;
    rec.options.LongName:=trim(copy(u_290.database2,1,108));
    if u_290.naam2='' then
      rec.star.id:=prepare_IAU_designation(ra2,dec2)
    else
      rec.star.id:=u_290.naam2;
  end;
end;

function Tcatalog.OpenGaia: boolean;
var h : TCatHeader;
    info:TCatHdrInfo;
    version : integer;
    filter,ok : boolean;
begin
  cfgcat.GaiaLevel:=1;
  SetGaiaPath(slash(cfgcat.starcatpath[gaia - BaseStar])+slash('gaia'+inttostr(cfgcat.GaiaLevel)), 'gaia');
  GetGaiaInfo(h,info,version,filter,ok);
  OpenGaiawin(Result);
end;

procedure Tcatalog.OpenGaiaPos(ar1, ar2, de1, de2: double; var ok: boolean);
begin
  cfgcat.GaiaLevel:=1;
  SetGaiaPath(slash(cfgcat.starcatpath[gaia - BaseStar])+slash('gaia'+inttostr(cfgcat.GaiaLevel)), 'gaia');
  OpenGaiap(ar1, ar2, de1, de2, ok);
end;

function  Tcatalog.GetGaiaMagMax: double;
begin
  result:=15;
  if DirectoryExists(slash(cfgcat.starcatpath[gaia - BaseStar])+slash('gaia2')) then begin
    result:=18;
    if DirectoryExists(slash(cfgcat.starcatpath[gaia - BaseStar])+slash('gaia3')) then
       result:=21;
  end;
end;

function Tcatalog.GaiaBRtoBV(br:double):double;
begin
  if GaiaVersion='Gaia DR2' then
    result:=GaiaBRtoBV_DR2(br)
  else if GaiaVersion='Gaia EDR3' then
    result:=GaiaBRtoBV_EDR3(br)
  else
    result:=GaiaBRtoBV_EDR3(br);
end;

function Tcatalog.GaiaBRtoBV_DR2(br:double):double;
begin
  // Compute approximate B-V from the Gaia magnitudes
  // First try if we can use the color transformation relation given
  // in the paper: Gaia Data Release 2 Photometric content and validation
  // We use the relation for G-Vt and G-Bt to get a Tycho2 Bt-VT :
  // validity : VT: −0.3 < (GBP−GRP) < 4.0 ; BT: 0 < (GBP−GRP) < 2.5
  // G − VT = -0.01842 - 0.06629 * (GBP−GRP) - 0.2346 * (GBP−GRP)**2 + 0.02157 * (GBP−GRP)**3
  // G − BT = -0.02441 - 0.4899  * (GBP−GRP) - 0.9740 * (GBP−GRP)**2 + 0.2496  * (GBP−GRP)**3
  // thus:
  // VT = G + 0.01842 + 0.06629 * (GBP−GRP) + 0.2346 * (GBP−GRP)**2 - 0.02157 * (GBP−GRP)**3
  // BT = G + 0.02441 + 0.4899  * (GBP−GRP) + 0.9740 * (GBP−GRP)**2 - 0.2496  * (GBP−GRP)**3
  // So for the color index:
  // validity : 0 < (GBP−GRP) < 2.5
  // BT-VT = 0.00599 + 0.42361 * (GBP−GRP) + 0.7394 * (GBP−GRP)**2 - 0.22803 * (GBP−GRP)**3
  //
  // Then convert Tycho2 BT-VT to B-V using the following relation:
  // http://adsabs.harvard.edu/cgi-bin/nph-bib_query?bibcode=2006AJ....131.2360M&db_key=AST&data_type=HTML&format=&high=4447a24b6f18601
  // for  -0.25 < (BT-VT) < 0.5  :
  // B-V = (BT-VT) - 0.006 - 0.1069 * (BT-VT) + 0.1459 * (BT-VT)**2
  // for 0.5 < (BT-VT) < 2.0  :
  // B-V = (BT-VT) - 0.007813 * (BT-VT) - 0.1489 * (BT-VT)**2 + 0.03384 * (BT-VT)**3
  // out of this range :
  // B-V = 0.850 * (BT-VT)

  // test in range for the standard Gaia relation
  if ((br)>0) and ((br) < 2.5) then begin
    // transform Gb-Gr to Bt-Vt
    result := 0.00599 + 0.42361 * (br) + 0.7394 * (br*br) - 0.22803 * (br*br*br);
    if (result>-0.25)and(result<0.5) then
       // use Tycho2 relation for first range
       result := result - 0.006 - 0.1069 * result  + 0.1459 * result*result
    else if (result>0.5)and(result<2.0) then
       // use Tycho2 relation for second range
       result := result - 0.007813 * result - 0.1489 * result*result + 0.03384 * result*result*result
    else
       // Out of range for the Tycho2 relation, use a safe value
       result := 0.850 * result;
  end
  else
    // Out of range for the standard Gaia relation, use a safe value.
    result:=0.5 * br;
  // round result
  result := Round(result*100)/100;
end;

function Tcatalog.GaiaBRtoBV_EDR3(br:double):double;
begin
  // Compute approximate B-V from the Gaia magnitudes
  // First try if we can use the color transformation relation given
  // in the paper: GaiaEDR3  Documentation chapter 5.5
  // We use the relation for G-Vt and G-Bt to get a Tycho2 Bt-VT :
  // validity : VT: −0.35 < (GBP−GRP) < 4.0 ; BT: -0.3 < (GBP−GRP) < 3.0
  // G - VT = -0.01077 - 0.0682 * (GBP−GRP) - 0.2387 * (GBP−GRP)**2 + 0.02342 * (GBP−GRP)**3
  // G − BT = -0.004288 -0.8547 * (GBP−GRP) + 0.1244 * (GBP−GRP)**2 - 0.9085  * (GBP−GRP)**3 + 0.4843 * (GBP−GRP)**4 - 0.06814 * (GBP−GRP)**5
  // thus:
  // VT = G + 0.01077 + 0.0682 * (GBP−GRP) + 0.2387 * (GBP−GRP)**2 - 0.02342 * (GBP−GRP)**3
  // BT = G + 0.004288 +0.8547 * (GBP−GRP) - 0.1244 * (GBP−GRP)**2 + 0.9085  * (GBP−GRP)**3 - 0.4843 * (GBP−GRP)**4 + 0.06814 * (GBP−GRP)**5
  // So for the color index:
  // validity : -0.3 < (GBP−GRP) < 3.0
  // BT-VT = -0.006482 + 0.7865 * (GBP−GRP) -0.3631 * (GBP−GRP)**2 + 0.93192 * (GBP−GRP)**3 - 0.4843 * (GBP−GRP)**4 + 0.06814 * (GBP−GRP)**5
  //
  // Then convert Tycho2 BT-VT to B-V using the following relation:
  // http://adsabs.harvard.edu/cgi-bin/nph-bib_query?bibcode=2006AJ....131.2360M&db_key=AST&data_type=HTML&format=&high=4447a24b6f18601
  // for  -0.25 < (BT-VT) < 0.5  :
  // B-V = (BT-VT) - 0.006 - 0.1069 * (BT-VT) + 0.1459 * (BT-VT)**2
  // for 0.5 < (BT-VT) < 2.0  :
  // B-V = (BT-VT) - 0.007813 * (BT-VT) - 0.1489 * (BT-VT)**2 + 0.03384 * (BT-VT)**3
  // out of this range :
  // B-V = 0.850 * (BT-VT)

  // test in range for the standard Gaia relation
  if ((br)>-0.3) and ((br) < 3.0) then begin
    // transform Gb-Gr to Bt-Vt
    result := -0.006482 + 0.7865 * (br) -0.3631 * (br)**2 + 0.93192 * (br)**3 - 0.4843 * (br)**4 + 0.06814 * (br)**5;
    if (result>-0.25)and(result<0.5) then
       // use Tycho2 relation for first range
       result := result - 0.006 - 0.1069 * result  + 0.1459 * result*result
    else if (result>0.5)and(result<2.0) then
       // use Tycho2 relation for second range
       result := result - 0.007813 * result - 0.1489 * result*result + 0.03384 * result*result*result
    else
       // Out of range for the Tycho2 relation, use a safe value
       result := 0.850 * result;
  end
  else
    // Out of range for the standard Gaia relation, use a safe value.
    result:=0.5 * br;
  // round result
  result := Round(result*100)/100;
end;

function Tcatalog.GaiaGtoV(g,br:double):double;
begin
  if GaiaVersion='Gaia DR2' then
    result:=GaiaGtoV_DR2(g,br)
  else if GaiaVersion='Gaia EDR3' then
    result:=GaiaGtoV_EDR3(g,br)
  else
    result:=GaiaGtoV_EDR3(g,br);
end;

function Tcatalog.GaiaGtoV_DR2(g,br:double):double;
begin
  // G−V =  -0.01760  -0.006860 * (GBP−GRP) -0.1732 * (GBP−GRP)**2
  // Validity: −0.5 < (GBP−GRP) < 2.75
  if (br>-0.5)and(br<2.75) then
    result := g + 0.01760 + 0.006860 * br + 0.1732 * br*br
  else
    // Out of range, use safe value
    result := g + 0.0176 + 0.1 * br;
  // round result
  result := Round(result*100)/100;
end;

function Tcatalog.GaiaGtoV_EDR3(g,br:double):double;
begin
  // Use the color relation for Johnson-Cousins given in the paper:
  // GaiaEDR3  Documentation chapter 5.5
  // G−V = -0.02704 + 0.01424 * (GBP−GRP) - 0.2156 * (GBP−GRP)**2 + 0.01426 * (GBP−GRP)**3
  // V = G +0.02704 - 0.01424 * (GBP−GRP) + 0.2156 * (GBP−GRP)**2 - 0.01426 * (GBP−GRP)**3
  // Validity: −0.5 < (GBP−GRP) < 5.0
  if (br>-0.5)and(br<5.0) then
    result := g + 0.02704 - 0.01424 * br + 0.2156 * br**2 - 0.01426 * br**3
  else
    // Out of range, use safe value
    result := g + 0.0176 + 0.1 * br;
  // round result
  result := Round(result*100)/100;
end;

procedure Tcatalog.FormatGaia(var rec: GcatRec);
var br: double;
begin
  rec.ra := deg2rad * rec.ra;
  rec.Dec := deg2rad * rec.Dec;
  rec.star.pmra := deg2rad * rec.star.pmra / 3600;
  rec.star.pmdec := deg2rad * rec.star.pmdec / 3600;
  rec.star.id:=rec.options.flabel[lOffset+vsId]+' '+rec.star.id;
  if (rec.star.magb<90)and(rec.star.magr<90) //and
     // Gaia EDR3 BP/RP flux excess, see EDR3 documentation chapter 5.4.2.1
     // (((10**((25-rec.star.magb)/2.5) + 10**((25-rec.star.magr)/2.5) ) /  10**((25-rec.star.magv)/2.5)) < 4)
  then begin
    br:=(rec.star.magb-rec.star.magr);
    rec.star.b_v:=GaiaBRtoBV(br);
    rec.num[2]:=GaiaGtoV(rec.star.magv,br);
    // mark V and b-v as valid
    rec.star.valid[vsB_v]:=true;
    rec.vnum[2]:=true;
    rec.options.flabel[lOffsetNum+2]:='mV';
  end
  else begin
    rec.star.b_v:=0;
    rec.num[2]:=0;
    rec.star.valid[vsB_v]:=false;
    rec.vnum[2]:=false;
  end;
end;

function Tcatalog.NextGaiaLevel: boolean;
begin
  inc(cfgcat.GaiaLevel);
  if (cfgcat.GaiaLevel=2)or((not cfgcat.Quick)and(cfgcat.GaiaLevel=3)) then  begin
     SetGaiaPath(slash(cfgcat.starcatpath[gaia - BaseStar])+slash('gaia'+inttostr(cfgcat.GaiaLevel)), 'gaia');
     OpenGaiawin(Result);
     if (cfgcat.LimitGaiaCount)and(cfgcat.GaiaLevel=3) then
       MaxGaiaRec:=1000000  // truncate only level 3
     else
       MaxGaiaRec:=MaxInt;
  end
  else
     result:=false;
end;

function Tcatalog.GetGaia(var rec: GcatRec): boolean;
begin
  Result := True;
  repeat
    ReadGaia(rec, Result);
    if not Result then
    begin
      Result:=NextGaiaLevel;
      if Result then
        continue;
    end;
    if cfgshr.StarFilter and (rec.star.magv > cfgcat.StarMagMax) then
    begin
      NextGaia(Result);
      if Result then
        continue;
    end;
    FormatGaia(rec);
    break;
  until not Result;
end;

function Tcatalog.FindGaia(id: string; var ar, de: double):boolean;
// search Gaia sourceid using the healpix part to find the file to search for.
var
  rec: GCatrec;
  sid: QWord;
  ipix,nside: int64;
  theta,phi,ar1,ar2,de1,de2: double;
begin
  Result := False;
  if @pix2ang_nest64=nil then exit;
  id:=trim(id);
  sid:=StrToQWordDef(id,0);
  if sid=0 then exit;
  // Get pixel number for level 12
  ipix:=sid div HealpixFilter12;
  // sides level 12
  nside:=round(2**12);
  // find coordinates from pixel
  pix2ang_nest64(nside,ipix,theta,phi);
  // theta is from north pole
  theta:=rad2deg*(pid2-theta);
  phi:=rad2deg*phi/15;
  // small search area
  ar1:=phi-0.001;
  ar2:=phi+0.001;
  de1:=theta-0.01;
  de2:=theta+0.01;
  // open catalog
  OpenGaiaPos(ar1, ar2, de1, de2,Result);
  if not Result then exit;
  Result:=false;
  repeat
    ReadGaia(rec, Result);
    if not Result then
    begin
      Result:=NextGaiaLevel;
      if Result then
        continue;
    end;
    if not Result then
      break;
    // test id
    if trim(rec.star.id)=id then
    begin
      Result:=true;
      break;
    end;
  until false;
  CloseGaia;
  if Result then
  begin
      FormatGaia(rec);
      ar := rec.ra;
      de := rec.Dec;
      FFindId := rec.star.id;
      FFindRecOK := True;
      FFindRec := rec;
  end;
end;


end.
