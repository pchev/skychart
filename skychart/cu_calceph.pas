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

uses calceph, math, dynlibs;

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

  Procedure Load_LibCalceph;
  Procedure InitCalceph(n: integer; eph_files: array of string);
  Function CalcephCompute(jdt: double; target, center: integer; out pv: TDoubleArray): boolean;

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

var eph: Pt_calcephbin;
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

Procedure InitCalceph(n: integer; eph_files: array of string);
var i: integer;
    fileeph: array [0..9] of Pchar;
begin
try
  n:=min(10,n);
  for i:=0 to n-1 do
    fileeph[i]:=Pchar(eph_files[i]);
  eph:=calceph_open_array(n,fileeph);
  if eph=nil then
    libcalceph:=0;
except
end;
end;

Function CalcephCompute(jdt: double; target, center: integer; out pv: TDoubleArray): boolean;
var pvo,pvt: TDoubleArray;
    jd0,t,r,lt: double;
    res: integer;
begin
  result:=false;
  try
  jd0:=jdt;
  t := 0.0;
  res := calceph_compute_order(eph, jd0, t, center, 0, CALCEPH_USE_NAIFID+CALCEPH_UNIT_KM+CALCEPH_UNIT_SEC, 0, pvo);
  if res=0 then exit;
  res := calceph_compute_order(eph, jd0, t, target, 0, CALCEPH_USE_NAIFID+CALCEPH_UNIT_KM+CALCEPH_UNIT_SEC, 0, pvt);
  if res=0 then exit;

  pv[0] := pvt[0]-pvo[0];
  pv[1] := pvt[1]-pvo[1];
  pv[2] := pvt[2]-pvo[2];
  r := sqrt(pv[0]*pv[0]+pv[1]*pv[1]+pv[2]*pv[2]);
  lt := r / clight;
  jd0 := jd0-(lt/secday);

  res := calceph_compute_order(eph, jd0, t , target, 0, CALCEPH_USE_NAIFID+CALCEPH_UNIT_KM+CALCEPH_UNIT_SEC, 0, pvt);
  if res=0 then exit;

  pv[0] := pvt[0]-pvo[0];
  pv[1] := pvt[1]-pvo[1];
  pv[2] := pvt[2]-pvo[2];

  result:=true;

  except
  end;
end;

end.
