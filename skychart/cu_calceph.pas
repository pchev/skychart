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
  Procedure Load_Calceph_Files;
  Procedure InitCalcephSat(n: integer; eph_files: array of string);
  Procedure CloseCalcephSat;
  Function CalcephComputeSat(jdt: double; target, center: integer; out pv: TDoubleArray): boolean;
  Function InitCalcephBody(csc: Tconf_skychart):boolean;
  Procedure CloseCalcephBody;
  Function CalcephComputeBody(jdt: double; target, center: integer; out pv: TDoubleArray): boolean;
  procedure ListContent(fn: string; out targets: string; out firsttime,lasttime:double);

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
    CalcephFolder,PrivateCalcephFolder: string;
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

Procedure Load_Calceph_Files;
var fn: array of string;
    i: integer;
begin
  PrivateCalcephFolder:=slash(PrivateCatalogDir) + 'spice_eph';
  CalcephFolder:=slash(Appdir) + slash('data') + 'spice_eph';
  SetLength(fn,2);
  fn[0]:=slash(PrivateCalcephFolder)+'cdcbase.bsp';
  if not FileExistsUTF8(fn[0]) then
    fn[0]:=slash(CalcephFolder)+'cdcbase.bsp';
  fn[1]:=slash(PrivateCalcephFolder)+'cdcext.bsp';
  if not FileExistsUTF8(fn[1]) then
    fn[1]:=slash(CalcephFolder)+'cdcext.bsp';
  if FileExistsUTF8(fn[0]) then begin
    i:=1;
    CalcephBaseOk:=true;
    if FileExistsUTF8(fn[1]) then begin
      i:=2;
      CalcephExtOk:=true;
    end;
    SetLength(fn,i);
    InitCalcephSat(i,fn);
    if libcalceph=0 then begin
      CalcephBaseOk:=false;
      CalcephExtOk:=false;
    end
    else WriteTrace('libcalceph loaded');
  end;
end;

Procedure InitCalcephSat(n: integer; eph_files: array of string);
var i: integer;
    fileeph: array [0..9] of Pchar;
begin
// load ephemeris file for planetary satellite
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
// close planetary satellite
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
// compute planetary satellite
  result:=false;
  if libcalceph=0 then exit;
  try
  jd0:=jdt;
  t := 0.0;
  // earth barycentric position
  res := calceph_compute_order(ephsat, jd0, t, center, 0, CALCEPH_USE_NAIFID+CALCEPH_UNIT_KM+CALCEPH_UNIT_SEC, 0, pvo);
  if res=0 then exit;
  // satellite barycentric position
  res := calceph_compute_order(ephsat, jd0, t, target, 0, CALCEPH_USE_NAIFID+CALCEPH_UNIT_KM+CALCEPH_UNIT_SEC, 0, pvt);
  if res=0 then exit;
  // light time
  pv[0] := pvt[0]-pvo[0];
  pv[1] := pvt[1]-pvo[1];
  pv[2] := pvt[2]-pvo[2];
  r := sqrt(pv[0]*pv[0]+pv[1]*pv[1]+pv[2]*pv[2]);
  lt := r / clight;
  jd0 := jd0-(lt/secday);
  // satelite position with light time
  res := calceph_compute_order(ephsat, jd0, t , target, 0, CALCEPH_USE_NAIFID+CALCEPH_UNIT_KM+CALCEPH_UNIT_SEC, 0, pvt);
  if res=0 then exit;
  // satellite position from earth
  pv[0] := pvt[0]-pvo[0];
  pv[1] := pvt[1]-pvo[1];
  pv[2] := pvt[2]-pvo[2];

  result:=true;

  except
  end;
end;

function InitCalcephBody(csc:Tconf_skychart):boolean;
var i,j,k,n,m: integer;
    fileeph: array [0..MaxSpkFiles-1] of Pchar;
    eph_files: array of string;
    targets: string;
    ft,lt: double;
    targ: TStringList;
begin
// load ephemeris file for solar system body
try
  result:=false;
  if libcalceph=0 then exit;
  // close previous files
  CloseCalcephBody;
  // put all the files in array
  n:=min(MaxSpkFiles-1,csc.SPKlist.Count);
  SetLength(eph_files,n);
  for i:=0 to n-1 do begin
    eph_files[i]:=slash(SPKdir)+csc.SPKlist[i];
    fileeph[i]:=Pchar(eph_files[i]);
  end;
  fileeph[n]:=Pchar(slash(CalcephFolder)+'cdcsun.bsp'); // Add Sun-Barycenter file because Horizon spk can be one or the other
  // open the ephemeris
  ephbody:=calceph_open_array(n+1,fileeph);
  result := ephbody<>nil;
  if result then begin
    // get maximum number of targets
    m:=calceph_getpositionrecordcount(ephbody);
    SetLength(csc.SPKBodies,m);
    SetLength(csc.SPKNames,m);
    j:=0;
    targ:=TStringList.Create;
    try
    // look for target id in each file
    for i:=0 to n-1 do begin
      ListContent(eph_files[i],targets,ft,lt);
      if pos(';',targets)=0 then begin
        // single target in file, use the filename as object name
        inc(j);
        csc.SPKBodies[j-1]:=StrToInt(targets);
        csc.SPKNames[j-1]:=ExtractFileNameOnly(eph_files[i]);
      end
      else begin
        // many targets in file, use spk id as object name
        Splitarg(targets,';',targ);
        for k:=0 to targ.Count-1 do begin
          inc(j);
          csc.SPKBodies[j-1]:=StrToInt(targ[k]);
          csc.SPKNames[j-1]:='SPK'+targ[k];
        end;
      end;
    end;
    // total number can be smaller if more than one record per target
    SetLength(csc.SPKBodies,j);
    SetLength(csc.SPKNames,j);
    finally
    targ.free;
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
// close files
  if libcalceph=0 then exit;
  if ephbody<>nil then
    calceph_close(ephbody);
  ephbody:=nil;
end;

Function CalcephComputeBody(jdt: double; target, center: integer; out pv: TDoubleArray): boolean;
var jd0,t: double;
    res,i: integer;
begin
// compute target body rectangular coordinates
// beware that only center=0 (barycentric) or 10 (Sun) is available if no other planetary spk is loaded
  result:=false;
  if libcalceph=0 then exit;
  try
  jd0:=jdt;
  t := 0.0;
  res := calceph_compute_order(ephbody, jd0, t, target, center, CALCEPH_USE_NAIFID+CALCEPH_UNIT_KM+CALCEPH_UNIT_SEC, 0, pv);
  if res=0 then
    exit;
  // AU not available in Horizon spk file
  for i:=0 to 2 do
    pv[i]:=pv[i] / km_au;
  result:=true;
  except
  end;
end;

procedure ListContent(fn: string; out targets: string; out firsttime,lasttime:double);
var
  eph: Pt_calcephbin;
  fileeph: array[0..1] of Pchar;
  i,n: integer;
  ft, lt: double;
  itarget, icenter, iframe: integer;
  buf:string;
begin
  // return list of target and date range for a specific spk file
  targets:='';
  firsttime:=1E99;
  lasttime:=0;
  if libcalceph=0 then exit;
  // only one file
  fileeph[0]:=PChar(fn);
  eph:=calceph_open_array(1,fileeph);
  if eph=nil then exit;
  // number of records
  n:= calceph_getpositionrecordcount(eph);
  targets:=';';
  for i:=1 to n do begin
    // get record information
    calceph_getpositionrecordindex(eph, i, itarget, icenter, ft, lt, iframe);
    buf:=inttostr(itarget);
    // remove duplicate from same file
    if pos(';'+buf+';',targets)=0 then begin
      targets:=targets+buf+';';
    end;
    // probably right if many contiguous record for the same target,
    // not critical otherwise because the date is only for information
    firsttime:=min(firsttime,ft);
    lasttime:=max(lasttime,lt);
  end;
  // remove first and last ";"
  Delete(targets,1,1);
  if length(targets)>1 then Delete(targets,length(targets),1);
  // close files
  calceph_close(eph);
end;

initialization
 ephsat:=nil;
 ephbody:=nil;

end.
