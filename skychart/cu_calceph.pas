unit cu_calceph;

{
Copyright (C) 2020 Patrick Chevalley

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

interface
{$mode objfpc}{$H+}

{
  Use library Calceph for planetary satellite position
}

uses calceph, math, dynlibs, u_constant, u_util, LazFileUtils, Classes,sysutils;

  const
    {$ifdef linux}
    libname = 'libcalceph.so.1';
    {$endif}
    {$ifdef freebsd}
    libname = 'libcalceph.so.1';
    {$endif}
    {$ifdef darwin}
    libname = 'libcalceph.dylib';
    {$endif}
    {$ifdef mswindows}
    libname = 'libcalceph.dll';
    {$endif}

    MaxSpkFiles = 100;

  Procedure Load_LibCalceph;
  Procedure InitCalcephSat(n: integer; eph_files: array of string);
  Procedure CloseCalcephSat;
  Function CalcephComputeSat(jdt: double; target, center: integer; out pv: TDoubleArray): boolean;
  Function InitCalcephBody(csc: Tconf_skychart):boolean;
  Procedure CloseCalcephBody;
  Function CalcephComputeBody(jdt: double; target, center: integer; out pv: TDoubleArray): boolean;
  Procedure ListContent(out targets: TTargetArray);

  var
    libcalceph: TLibHandle;
    errproc                          : Terrproc;
    calceph_seterrorhandler          : Tcalceph_seterrorhandler;
    calceph_sopen                    : Tcalceph_sopen;
    calceph_sgetfileversion          : Tcalceph_sgetfileversion;
    calceph_scompute                 : Tcalceph_scompute;
    calceph_sgetconstant             : Tcalceph_sgetconstant;
    calceph_sgetconstantcount        : Tcalceph_sgetconstantcount;
    calceph_sgetconstantindex        : Tcalceph_sgetconstantindex;
    calceph_sgettimescale            : Tcalceph_sgettimescale;
    calceph_sgettimespan             : Tcalceph_sgettimespan;
    calceph_sclose                   : Tcalceph_sclose;
    calceph_open                     : Tcalceph_open;
    calceph_open_array               : Tcalceph_open_array;
    calceph_getfileversion           : Tcalceph_getfileversion;
    calceph_prefetch                 : Tcalceph_prefetch;
    calceph_isthreadsafe             : Tcalceph_isthreadsafe;
    calceph_compute                  : Tcalceph_compute;
    calceph_compute_unit             : Tcalceph_compute_unit;
    calceph_orient_unit              : Tcalceph_orient_unit;
    calceph_rotangmom_unit           : Tcalceph_rotangmom_unit;
    calceph_compute_order            : Tcalceph_compute_order;
    calceph_orient_order             : Tcalceph_orient_order;
    calceph_rotangmom_order          : Tcalceph_rotangmom_order;
    calceph_getconstant              : Tcalceph_getconstant;
    calceph_getconstantsd            : Tcalceph_getconstantsd;
    calceph_getconstantvd            : Tcalceph_getconstantvd;
    calceph_getconstantss            : Tcalceph_getconstantss;
    calceph_getconstantvs            : Tcalceph_getconstantvs;
    calceph_getconstantcount         : Tcalceph_getconstantcount;
    calceph_getconstantindex         : Tcalceph_getconstantindex;
    calceph_gettimescale             : Tcalceph_gettimescale;
    calceph_gettimespan              : Tcalceph_gettimespan;
    calceph_getpositionrecordcount   : Tcalceph_getpositionrecordcount;
    calceph_getpositionrecordindex   : Tcalceph_getpositionrecordindex;
    calceph_getorientrecordcount     : Tcalceph_getorientrecordcount;
    calceph_getorientrecordindex     : Tcalceph_getorientrecordindex;
    calceph_close                    : Tcalceph_close;
    calceph_getversion_str           : Tcalceph_getversion_str;

var ephsat,ephbody: Pt_calcephbin;
    LastError: string;
    CalcephFolder: string;
    CalcephBaseOk, CalcephExtOk: boolean;

implementation

const
  clight = 299792.458;
  secday = 3600 * 24;

Procedure ErrorHandler(msg: Pchar);
begin
  LastError:=msg;
end;

Procedure Load_LibCalceph;
begin
  try
  libcalceph := LoadLibrary(libname);
  except
    libcalceph:=0;
  end;
  try
  if libcalceph <> 0 then  begin
    errproc                          := Terrproc(GetProcAddress(libcalceph, 'errproc'));
    calceph_seterrorhandler          := Tcalceph_seterrorhandler(GetProcAddress(libcalceph, 'calceph_seterrorhandler'));
    calceph_sopen                    := Tcalceph_sopen(GetProcAddress(libcalceph, 'calceph_sopen'));
    calceph_sgetfileversion          := Tcalceph_sgetfileversion(GetProcAddress(libcalceph, 'calceph_sgetfileversion'));
    calceph_scompute                 := Tcalceph_scompute(GetProcAddress(libcalceph, 'calceph_scompute'));
    calceph_sgetconstant             := Tcalceph_sgetconstant(GetProcAddress(libcalceph, 'calceph_sgetconstant'));
    calceph_sgetconstantcount        := Tcalceph_sgetconstantcount(GetProcAddress(libcalceph, 'calceph_sgetconstantcount'));
    calceph_sgetconstantindex        := Tcalceph_sgetconstantindex(GetProcAddress(libcalceph, 'calceph_sgetconstantindex'));
    calceph_sgettimescale            := Tcalceph_sgettimescale(GetProcAddress(libcalceph, 'calceph_sgettimescale'));
    calceph_sgettimespan             := Tcalceph_sgettimespan(GetProcAddress(libcalceph, 'calceph_sgettimespan'));
    calceph_sclose                   := Tcalceph_sclose(GetProcAddress(libcalceph, 'calceph_sclose'));
    calceph_open                     := Tcalceph_open(GetProcAddress(libcalceph, 'calceph_open'));
    calceph_open_array               := Tcalceph_open_array(GetProcAddress(libcalceph, 'calceph_open_array'));
    calceph_getfileversion           := Tcalceph_getfileversion(GetProcAddress(libcalceph, 'calceph_getfileversion'));
    calceph_prefetch                 := Tcalceph_prefetch(GetProcAddress(libcalceph, 'calceph_prefetch'));
    calceph_isthreadsafe             := Tcalceph_isthreadsafe(GetProcAddress(libcalceph, 'calceph_isthreadsafe'));
    calceph_compute                  := Tcalceph_compute(GetProcAddress(libcalceph, 'calceph_compute'));
    calceph_compute_unit             := Tcalceph_compute_unit(GetProcAddress(libcalceph, 'calceph_compute_unit'));
    calceph_orient_unit              := Tcalceph_orient_unit(GetProcAddress(libcalceph, 'calceph_orient_unit'));
    calceph_rotangmom_unit           := Tcalceph_rotangmom_unit(GetProcAddress(libcalceph, 'calceph_rotangmom_unit'));
    calceph_compute_order            := Tcalceph_compute_order(GetProcAddress(libcalceph, 'calceph_compute_order'));
    calceph_orient_order             := Tcalceph_orient_order(GetProcAddress(libcalceph, 'calceph_orient_order'));
    calceph_rotangmom_order          := Tcalceph_rotangmom_order(GetProcAddress(libcalceph, 'calceph_rotangmom_order'));
    calceph_getconstant              := Tcalceph_getconstant(GetProcAddress(libcalceph, 'calceph_getconstant'));
    calceph_getconstantsd            := Tcalceph_getconstantsd(GetProcAddress(libcalceph, 'calceph_getconstantsd'));
    calceph_getconstantvd            := Tcalceph_getconstantvd(GetProcAddress(libcalceph, 'calceph_getconstantvd'));
    calceph_getconstantss            := Tcalceph_getconstantss(GetProcAddress(libcalceph, 'calceph_getconstantss'));
    calceph_getconstantvs            := Tcalceph_getconstantvs(GetProcAddress(libcalceph, 'calceph_getconstantvs'));
    calceph_getconstantcount         := Tcalceph_getconstantcount(GetProcAddress(libcalceph, 'calceph_getconstantcount'));
    calceph_getconstantindex         := Tcalceph_getconstantindex(GetProcAddress(libcalceph, 'calceph_getconstantindex'));
    calceph_gettimescale             := Tcalceph_gettimescale(GetProcAddress(libcalceph, 'calceph_gettimescale'));
    calceph_gettimespan              := Tcalceph_gettimespan(GetProcAddress(libcalceph, 'calceph_gettimespan'));
    calceph_getpositionrecordcount   := Tcalceph_getpositionrecordcount(GetProcAddress(libcalceph, 'calceph_getpositionrecordcount'));
    calceph_getpositionrecordindex   := Tcalceph_getpositionrecordindex(GetProcAddress(libcalceph, 'calceph_getpositionrecordindex'));
    calceph_getorientrecordcount     := Tcalceph_getorientrecordcount(GetProcAddress(libcalceph, 'calceph_getorientrecordcount'));
    calceph_getorientrecordindex     := Tcalceph_getorientrecordindex(GetProcAddress(libcalceph, 'calceph_getorientrecordindex'));
    calceph_close                    := Tcalceph_close(GetProcAddress(libcalceph, 'calceph_close'));
    calceph_getversion_str           := Tcalceph_getversion_str(GetProcAddress(libcalceph, 'calceph_getversion_str'));
  end;
  if (calceph_compute_order=nil) then
     libcalceph:=0;
  if libcalceph<>0 then begin
    calceph_seterrorhandler(3,@ErrorHandler);
  end;
  except
    libcalceph:=0;
  end;
end;

Procedure InitCalcephSat(n: integer; eph_files: array of string);
var i: integer;
    fileeph: array [0..9] of Pchar;
begin
try
  if libcalceph=0 then exit;
  CloseCalcephSat;
  n:=min(10,n);
  for i:=0 to n-1 do
    fileeph[i]:=Pchar(eph_files[i]);
  ephsat:=calceph_open_array(n,fileeph);
  if ephsat=nil then
    libcalceph:=0;
except
  libcalceph:=0;
end;
end;

Procedure CloseCalcephSat;
begin
  if libcalceph=0 then exit;
  if ephsat<>nil then
    calceph_close(ephsat);
  ephsat:=nil;
end;

Function CalcephComputeSat(jdt: double; target, center: integer; out pv: TDoubleArray): boolean;
var pvo,pvt: TDoubleArray;
    jd0,t,r,lt: double;
    res: integer;
begin
  result:=false;
  if libcalceph=0 then exit;
  try
  jd0:=jdt;
  t := 0.0;
  res := calceph_compute_order(ephsat, jd0, t, center, 0, CALCEPH_USE_NAIFID+CALCEPH_UNIT_KM+CALCEPH_UNIT_SEC, 0, pvo);
  if res=0 then exit;
  res := calceph_compute_order(ephsat, jd0, t, target, 0, CALCEPH_USE_NAIFID+CALCEPH_UNIT_KM+CALCEPH_UNIT_SEC, 0, pvt);
  if res=0 then exit;

  pv[0] := pvt[0]-pvo[0];
  pv[1] := pvt[1]-pvo[1];
  pv[2] := pvt[2]-pvo[2];
  r := sqrt(pv[0]*pv[0]+pv[1]*pv[1]+pv[2]*pv[2]);
  lt := r / clight;
  jd0 := jd0-(lt/secday);

  res := calceph_compute_order(ephsat, jd0, t , target, 0, CALCEPH_USE_NAIFID+CALCEPH_UNIT_KM+CALCEPH_UNIT_SEC, 0, pvt);
  if res=0 then exit;

  pv[0] := pvt[0]-pvo[0];
  pv[1] := pvt[1]-pvo[1];
  pv[2] := pvt[2]-pvo[2];

  result:=true;

  except
  end;
end;

function InitCalcephBody(csc:Tconf_skychart):boolean;
var i,n: integer;
    fileeph: array [0..MaxSpkFiles-1] of Pchar;
    eph_files: array of string;
begin
try
  result:=false;
  if libcalceph=0 then exit;
  CloseCalcephBody;
  n:=min(MaxSpkFiles,csc.SPKlist.Count);
  SetLength(eph_files,n);
  for i:=0 to n-1 do begin
    eph_files[i]:=slash(SPKdir)+csc.SPKlist[i];
    fileeph[i]:=Pchar(eph_files[i]);
  end;
  ephbody:=calceph_open_array(n,fileeph);
  result := ephbody<>nil;
  if result then begin
    ListContent(csc.SPKBodies);
    SetLength(csc.SPKNames,Length(csc.SPKBodies));
    if Length(csc.SPKBodies)=n then begin
      for i:=0 to Length(csc.SPKBodies)-1 do
        csc.SPKNames[i]:=ExtractFileNameOnly(csc.SPKlist[i]);
    end
    else begin
      for i:=0 to Length(csc.SPKBodies)-1 do
        csc.SPKNames[i]:='SPK'+IntToStr(csc.SPKBodies[i]);
    end;
  end
  else begin
    SetLength(csc.SPKBodies,0);
    SetLength(csc.SPKNames,0);
  end;
except
end;
end;

Procedure CloseCalcephBody;
begin
  if libcalceph=0 then exit;
  if ephbody<>nil then
    calceph_close(ephbody);
  ephbody:=nil;
end;

Function CalcephComputeBody(jdt: double; target, center: integer; out pv: TDoubleArray): boolean;
var jd0,t: double;
    res,i: integer;
begin
  result:=false;
  if libcalceph=0 then exit;
  try
  jd0:=jdt;
  t := 0.0;
  res := calceph_compute_order(ephbody, jd0, t, target, center, CALCEPH_USE_NAIFID+CALCEPH_UNIT_KM+CALCEPH_UNIT_SEC, 0, pv);
  if res=0 then
    exit;
  for i:=0 to 2 do
    pv[i]:=pv[i] / km_au; // AU not available in Horizon spk file
  result:=true;
  except
  end;
end;

procedure ListContent(out targets: TTargetArray);
var
  i,j,k,n: integer;
  firsttime, lasttime: double;
  itarget, icenter, iframe: integer;
  dup: boolean;
begin
  if libcalceph=0 then exit;
  n:= calceph_getpositionrecordcount(ephbody);
  SetLength(targets,n);
  k:=0;
  for i:=1 to n do begin
    calceph_getpositionrecordindex(ephbody, i, itarget, icenter, firsttime, lasttime, iframe);
    dup:=false;
    for j:=0 to Length(targets)-1 do begin
       if targets[j]=itarget then dup:=true;
    end;
    if not dup then begin
      targets[k]:=itarget;
      inc(k);
    end;
  end;
  SetLength(targets,k);
end;

initialization
 ephsat:=nil;
 ephbody:=nil;

end.
