unit uDE;

{
Copyright (C) 2009  Denis Boucher

boucherd@telusplanet.net

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
JPL ephemeris computation.
Data files are available from:
ftp://ssd.jpl.nasa.gov/pub/eph/planets/

first load_de_file with time in julian date, name of the file with folder location, de type (200 or 403 or 405 or 406)
if we return true than we are good
when we close the program call close_de_file to free the stream.

to call for planet position

use Calc_Planet_de(
                julian_date     - full julian date not jdm
                planet_id       - planet 1..11 (Moon = 10) planet_center = 11 from the Sun, planet_center = 3 from earth
                var planet_arr  - planet output array with velocity if true or 14. 15.
                in_au           - results in au or km
                planet_center   - which planet is the center of the vector (normally earth unless calc the Sun
                velocity        - true / false calc or not )

}
{$mode delphi}{$H+}
interface

uses
  Math,
  SysUtils,
  DateUtils,
  Classes;

//generate type to make transfer easier;
type
  Array_5B = array [0..5] of byte;

type
  Array_11i = array[0..11] of smallint;

type
  array_12_2i = array[0..12, 0..2] of integer;

type
  Array_1D = array [0..1] of double;

type
  Array_5D = array [0..5] of double;

type
  Array_17D = array [0..17] of double;

type
  Array_12_5D = array[0..12, 0..5] of double;


type   //data info required for process
  piinfo = ^iinfo;

  iinfo = record
    pc: Array_17D;
    vc: Array_17D;
    twot: double;
    np: smallint;
    nv: smallint;
  end;

type  //use for data from file and process
  pephdata = ^ephdata;

  ephdata = record
    ephem_start: double;
    ephem_end: double;
    ephem_step: double;
    ncon: integer;
    auinkm: double;
    emrat: double;
    ipt: array_12_2i;
    de_version: integer;
    kernel_size: integer;
    recsize: integer;
    ncoeff: integer;
    swap_bytes: boolean;
    curr_cache_loc: integer;
    cache: array of double;
    pvsun: array_5D;
    de_file: string
  end;


//procedure to use in program to get planet position
function Calc_Planet_de(julian_date: double; planet_id: integer;
  var planet_arr: Array_5D; in_au: boolean;
  planet_center: integer; velocity: boolean): boolean;

//first must load the de file
function load_de_file(jd: double; de_folder: string; de_type: integer;
  var de_filename: string; var jdstart, jdend: double): boolean;

//init the file into the stream
function init_de_file(ephemeris_filename: string): boolean;

//close de stream.
procedure close_de_file;

function SwapLong(i1: integer): integer;
function SwapDouble(i1: double): double;
function jpl_pleph(eph: pephdata; ephinfo: piinfo; et: double;
  ntarg, ncent: integer; var rrd: Array_5D;
  calc_velocity: boolean): integer;
function jpl_state(ephs: pephdata; ephinfos: piinfo; et: double;
  list: array_11i; var pvs: Array_12_5D; var nut: array_5D;
  bary: integer): integer;
procedure interp(ephint: pephdata; iinfo: piinfo; bufi: pdouble;
  t: Array_1D; ncf, ncm, na, ifl: integer; var posvel: array_5D);

var
  de_stream: TFileStream;  //serve as cache for DE405 file.
  de_eph: ephdata;        //init DE405
  de_iinfo: iinfo;          //info on calc steps as part of DE405
  de_created: boolean;

implementation  //all functions and procedure to use de.

function Calc_Planet_de(julian_date: double; planet_id: integer;
  var planet_arr: Array_5D; in_au: boolean;
  planet_center: integer; velocity: boolean): boolean;

var
  rval: byte;
begin
  try
    //set if output in au or km
    if in_au then
      de_eph.auinkm := 149597870.691
    else
      de_eph.auinkm := 1;

    rval := jpl_pleph(@de_eph, @de_iinfo, julian_date, planet_id,
      planet_center, planet_arr, velocity);

    {Results are transferred to vector in array 0..2 and velocity 3..5
     to find range do - val_range := sqrt(sqr(planet_arr[0]) +  sqr(planet_arr[1]) + sqr(planet_arr[2]))
     Maintain result using barycenter
     }
    if rval = 1 then
    begin
      Result := True;
    end
    else
      Result := False;
  except
    Result := False;
  end;
end;

procedure Djd(jd: double; var annee, mois, jour: integer; var Heure: double);
var
  u0, u1, u2, u3, u4: double;
  gregorian: boolean;
begin
  u0 := jd + 0.5;
  if int(u0) >= 2299161 then
    gregorian := True
  else
    gregorian := False;
  u0 := jd + 32082.5;
  if gregorian then
  begin
    u1 := u0 + floor(u0 / 36525) - floor(u0 / 146100) - 38;
    if jd >= 1830691.5 then
      u1 := u1 + 1;
    u0 := u0 + floor(u1 / 36525) - floor(u1 / 146100) - 38;
  end;
  u2 := floor(u0 + 123);
  u3 := floor((u2 - 122.2) / 365.25);
  u4 := floor((u2 - floor(365.25 * u3)) / 30.6001);
  mois := round(u4 - 1);
  if mois > 12 then
    mois := mois - 12;
  jour := round(u2 - floor(365.25 * u3) - floor(30.6001 * u4));
  annee := round(u3 + floor((u4 - 2) / 12) - 4800);
  heure := (jd - floor(jd + 0.5) + 0.5) * 24;
end;

function load_de_file(jd: double; de_folder: string; de_type: integer;
  var de_filename: string; var jdstart, jdend: double): boolean;
var
  fs: TSearchRec;
  i: integer;
begin
  Result := False;
  // search for all file with .de_type extension ( *.431 )
  i := FindFirst(de_folder + DirectorySeparator + '*.' + IntToStr(de_type), 0, fs);
  while i = 0 do
  begin
    de_filename := de_folder + DirectorySeparator + fs.Name;
    // open the ephemeris file
    if init_de_file(de_filename) then
    begin
      // check the jd range for this file
      if (jd > (de_eph.ephem_start + de_eph.ephem_step))  and
        (jd < (de_eph.ephem_end - de_eph.ephem_step)) then
      begin
        // OK use this one
        de_eph.de_file := de_filename;
        jdstart := de_eph.ephem_start + de_eph.ephem_step;
        jdend := de_eph.ephem_end - de_eph.ephem_step;
        Result := True;
        break;
      end;
    end;
    i := FindNext(fs);
  end;
  FindClose(fs);
end;


// here we will use a file stream to load and extract coef.

function init_de_file(ephemeris_filename: string): boolean;
var
  i, j: integer;
  Title: array[0..83] of AnsiChar;
  itemp: integer;
begin
  for j := 0 to 2 do
    for i := 0 to 12 do
      de_eph.ipt[i, j] := 0;
  //check if stream is created
  if de_created then
  begin
    de_stream.Free;
  end;
  de_stream := TFileStream.Create(ephemeris_filename, fmOpenRead + fmShareDenyNone);
  de_created := True;
  //Seek - soCurrent - soBeginning - soEnd force to use the 64-bit version
  de_stream.Read(Title, Sizeof(Title));
  de_stream.Seek(2568, soCurrent);
  de_stream.Read(de_eph, 28);
  if de_eph.ephem_start = 0 then
  begin  // protect again empty or corrupt file
    de_stream.Free;
    de_created := False;
    Result := False;
    exit;
  end;
  de_stream.Read(de_eph.auinkm, 8);
  de_stream.Read(de_eph.emrat, 8);
  de_stream.Read(de_eph.ipt, 144);
  de_stream.Read(de_eph.de_version, 4);
  de_stream.Read(de_eph.ipt[12], 12);
  de_iinfo.np := 2;
  de_iinfo.nv := 3;
  de_iinfo.pc[0] := 1.0;
  de_iinfo.pc[1] := 0.0;
  de_iinfo.vc[1] := 1.0;
  de_eph.curr_cache_loc := -1;
  if (de_eph.ncon < 0) or (de_eph.ncon > 65536) then
    de_eph.swap_bytes := True
  else
    de_eph.swap_bytes := False;
  if de_eph.swap_bytes then
  begin //byte order is wrong for current platform
    de_eph.ephem_start := SwapDouble(de_eph.ephem_start);
    de_eph.ephem_end := SwapDouble(de_eph.ephem_end);
    de_eph.ephem_step := SwapDouble(de_eph.ephem_step);
    de_eph.ncon := SwapLong(de_eph.ncon);
    de_eph.auinkm := SwapDouble(de_eph.auinkm);
    de_eph.emrat := SwapDouble(de_eph.emrat);
    de_eph.de_version := SwapLong(de_eph.de_version);
    for j := 0 to 2 do
      for i := 0 to 12 do
        de_eph.ipt[i, j] := SwapLong(de_eph.ipt[i, j]);
  end;
  de_eph.kernel_size := 4;
  for i := 0 to 12 do
  begin
    if i = 11 then
      itemp := 4
    else
      itemp := 6;
    de_eph.kernel_size := de_eph.kernel_size + de_eph.ipt[i, 1] *
      de_eph.ipt[i, 2] * itemp;
  end;
  de_eph.recsize := de_eph.kernel_size * 4;
  de_eph.ncoeff := de_eph.kernel_size div 2;
  Result := True;
end;

procedure close_de_file;
begin
  de_stream.Free;
  de_created := False;
end;


//swap longint

function SwapLong(i1: integer): integer;
type
  Array_3B = array [0..3] of byte;
var
  Tmp: ^Array_3B;
  it: byte;
  i: integer;
begin
  Tmp := @i1;
  for i := 0 to 1 do
  begin
    it := Tmp^[i];
    Tmp^[i] := Tmp^[3 - i];
    Tmp^[3 - i] := it;
  end;
  Result := i1;
end;

//swap double

function SwapDouble(i1: double): double;
type
  Array_7B = array [0..7] of byte;
var
  Tmp: ^Array_7B;
  it: byte;
  i: integer;
begin
  Tmp := @i1;
  for i := 0 to 3 do
  begin
    it := Tmp^[i];
    Tmp^[i] := Tmp^[7 - i];
    Tmp^[7 - i] := it;
  end;
  Result := i1;
end;




{*****************************************************************************
**           jpl_pleph( ephem,et,ntar,ncent,rrd,calc_velocity)              **
******************************************************************************
**                                                                          **
**    This subroutine reads the jpl planetary ephemeris                     **
**    and gives the position and velocity of the point 'ntarg'              **
**    with respect to 'ncent'.                                              **
**                                                                          **
**    Calling sequence parameters:                                          **
**                                                                          **
**      et = julian ephemeris date at which interpolation Calc_Planet_de    **
**                                                                          **
**                                                                          **
**    ntarg = integer number of 'target' point.                             **
**                                                                          **
**    ncent = integer number of center point.                               **
**                                                                          **
**    The numbering convention for 'ntarg' and 'ncent' is:                  **
**                                                                          **
**            1 = mercury           8 = neptune                             **
**            2 = venus             9 = pluto                               **
**            3 = earth            10 = moon                                **
**            4 = mars             11 = sun                                 **
**            5 = jupiter          12 = solar-system barycenter             **
**            6 = saturn           13 = earth-moon barycenter               **
**            7 = uranus           14 = nutations (longitude and obliq)     **
**                                 15 = librations, if on eph. file         **
**                                                                          **
**            (If nutations are wanted, set ntarg = 14.                     **
**             For librations, set ntarg = 15. set ncent= 0)                **
**                                                                          **
**     rrd = output 6-element,  array of position and velocity              **
**           of point 'ntarg' relative to 'ncent'. The units are au and     **
**           au/day. For librations the units are radians and radians       **
**           per day. In the case of nutations the first four words of      **
**           rrd will be set to nutations and rates, having units of        **
**           radians and radians/day.                                       **
**                                                                          **
**           The option is available to have the units in km and km/sec.    **
**           for this, set km=TRUE at the beginning of the program.         **
**                                                                          **
**     calc_velocity = boolean ;  if true,  velocities will be              **
**           computed,  otherwise not.                                      **
**                                                                          **
*****************************************************************************}

function jpl_pleph(eph: pephdata; ephinfo: piinfo; et: double;
  ntarg, ncent: integer; var rrd: Array_5D; calc_velocity: boolean): integer;
var
  pv: Array_12_5D;
  i: smallint;
  k: smallint;
  lista: Array_11i;
  list_val: smallint;
begin
  Result := 0;
  try
    //zero result to avoid NAN
    for i := 0 to 5 do
      rrd[i] := 0;
    for i := 0 to 5 do
      for k := 0 to 12 do
        pv[k, i] := 0;
    if ntarg = ncent then
      exit;
    //zero value in list
    for i := 0 to 11 do
      lista[i] := 0;
    //set value for list if velocity
    if calc_velocity then
      list_val := 2
    else
      list_val := 1;
    // check for nutation call
    if ntarg = 14 then
    begin
      if eph.ipt[11, 1] > 0 then
      begin //there is nutation on ephemeris
        lista[10] := list_val;
        if jpl_state(eph, ephinfo, et, lista, pv, rrd, 0) <> 0 then
          Result := 1;
      end
      else
        Result := 0;          //no nutations on the ephemeris file
      exit;
    end;
    //  check for librations
    if ntarg = 15 then
    begin
      if eph.ipt[12, 1] > 0 then
      begin //librations on ephemeris file
        lista[11] := list_val;
        if jpl_state(eph, ephinfo, et, lista, pv, rrd, 0) <> 0 then
          Result := 1;
        for i := 0 to 5 do
          rrd[i] := pv[10, i]; //librations
      end
      else
        Result := 0;   //no librations on the ephemeris file
      exit;
    end;
    //  force barycentric output by 'state'
    //  set up proper entries in 'list' array for state call
    for i := 0 to 1 do
    begin // list[] IS NUMBERED FROM ZERO !
      k := ntarg - 1;
      if i = 1 then
        k := ncent - 1;        //same for ntarg & ncent
      if k <= 9 then
        lista[k] := list_val; //Major planets
      if k = 9 then
        lista[2] := list_val;  //for moon,  earth state is needed
      if k = 2 then
        lista[9] := list_val;  //for earth,  moon state is needed
      if k = 12 then
        lista[2] := list_val; //EMBary state additionally
    end;
    //make call to state
    jpl_state(eph, ephinfo, et, lista, pv, rrd, 1);
    //Solar System barycentric Sun state goes to pv[10][]
    if (ntarg = 11) or (ncent = 11) then
      for i := 0 to 5 do
        pv[10, i] := eph.pvsun[i];
    //Solar System Barycenter coordinates & velocities equal to zero
    if (ntarg = 12) or (ncent = 12) then
      for i := 0 to 5 do
        pv[11, i] := 0;
    //Solar System barycentric EMBary state: /
    if (ntarg = 13) or (ncent = 13) then
      for i := 0 to 5 do
        pv[12, i] := pv[2, i];
    //if moon from earth or earth from moon .....
    if (ntarg * ncent = 30) and (ntarg + ncent = 13) then
      for i := 0 to 5 do
        pv[2, i] := 0
    else
    begin
      if lista[2] >= 1 then    //calculate earth state from EMBary
        for i := 0 to (lista[2] * 3) - 1 do
          pv[2, i] := pv[2, i] - pv[9, i] / (1.0 + eph.emrat);
      if lista[9] >= 1 then   //calculate Solar System barycentric moon state
        for i := 0 to (lista[9] * 3) - 1 do
          pv[9, i] := pv[9, i] + pv[2, i];
    end;
    for i := 0 to (list_val * 3) - 1 do
      rrd[i] := pv[ntarg - 1, i] - pv[ncent - 1, i];
    Result := 1;
  except
    Result := 0;
  end;
end;


{
**              the designation of the astronomical bodies by i is:         **
**                                                                          **
**                        i = 0: mercury                                    **
**                          = 1: venus                                      **
**                          = 2: earth-moon barycenter                      **
**                          = 3: mars                                       **
**                          = 4: jupiter                                    **
**                          = 5: saturn                                     **
**                          = 6: uranus                                     **
**                          = 7: neptune                                    **
**                          = 8: pluto                                      **
**                          = 9: geocentric moon                            **
**                          =10: nutations in longitude and obliquity       **
**                          =11: lunar librations (if on file)              **
**                                                                          **
**    output:                                                               **
**                                                                          **
**                                                                          **
**              All output vectors are referenced to the earth mean         **
**              equator and equinox of epoch. The moon state is always      **
**              geocentric; the other nine states are either heliocentric   **
**              or solar-system barycentric, depending on the setting of    **
**              global variables (see below).                               **
**                                                                          **
**              Lunar librations, if on file, are put into pv if list[11]   **
**              is 1 or 2.                                                  **
**                                                                          **
**        nut   dp 4-word array that will contain nutations and rates,      **
**              depending on the setting of list[10].  the order of         **
**              quantities in nut is:                                       **
**                                                                          **
**                       d psi  (nutation in longitude)                     **
**                       d epsilon (nutation in obliquity)                  **
**                       d psi dot                                          **
**                       d epsilon dot                                      **
**                                                                          **
*****************************************************************************}

function jpl_state(ephs: pephdata; ephinfos: piinfo; et: double;
  list: array_11i; var pvs: Array_12_5D; var nut: array_5D;
  bary: integer): integer;
var
  i, j, q: smallint;
  n_intervals: smallint;
  flag: integer;
  nr: int64;
  aufac, block_loc: double;
  dest: Array_5D;
  t: Array_1D;
  pefau: Array_5D;
begin
  //  ********** main entry point **********

  //error return for epoch out of range
  if (et < ephs.ephem_start) or (et > ephs.ephem_end) then
  begin
    Result := 0;
    exit;
  end;
  //calculate record # and relative time in interval
  block_loc := (et - ephs.ephem_start) / ephs.ephem_step;
  nr := trunc(block_loc);
  t[0] := block_loc - nr;
  if (et = ephs.ephem_end) then
  begin
    Dec(nr);
    t[0] := 1.0 - 1e-16;
  end;

  //read correct record if not in core (static vector buf[])
  if (nr <> ephs.curr_cache_loc) then
  begin
    SetLength(ephs.cache, ephs.ncoeff);
    ephs.curr_cache_loc := nr;
    de_stream.Seek((nr + 2) * ephs.recsize, soBeginning);
    // soBeginning force to use the 64-bit version
    for i := 0 to ephs.ncoeff - 1 do
    begin
      de_stream.Read(ephs.cache[i], SizeOf(double));
      if ephs.swap_bytes then
        ephs.cache[i] := SwapDouble(ephs.cache[i]);
    end;
  end;
  t[1] := ephs.ephem_step;
  aufac := 1 / ephs.auinkm;

  n_intervals := 1;
  while n_intervals <= 8 do
  begin
    for i := 0 to 10 do
    begin
      if (n_intervals = ephs.ipt[i, 2]) and
        ((list[i] >= 1) or (i = 10)) then
      begin
        if i = 10 then
          flag := 2
        else
          flag := list[i];
        interp(ephs, ephinfos, @ephs.cache[ephs.ipt[i, 0] - 1], t,
          ephs.ipt[i, 1], 3, n_intervals, flag, dest);
        for j := 0 to (flag * 3) - 1 do
          dest[j] := dest[j] * aufac;
        if i = 10 then
          for q := 0 to 5 do
            ephs.pvsun[q] := dest[q]
        else
          for q := 0 to 5 do
            pvs[i, q] := dest[q];
      end;
    end;
    n_intervals := n_intervals * 2;
  end;
  if bary <> 1 then
  begin
    for i := 0 to 8 do
    begin
      for j := 0 to ((list[i] * 3) - 1) do
        pvs[i, j] := pvs[i, j] - ephs.pvsun[j];
    end;
  end;
  //do nutations if requested (and if on file)
  if (list[10] > 0) and (ephs.ipt[11, 1] > 0) then
  begin
    interp(ephs, ephinfos, @ephs.cache[ephs.ipt[11, 0] - 1], t,
      ephs.ipt[11, 1], 2, ephs.ipt[11, 2], list[10], nut);
  end;
  //get librations if requested (and if on file)
  if (list[11] > 0) and (ephs.ipt[12, 1] > 0) then
  begin
    interp(ephs, ephinfos, @ephs.cache[ephs.ipt[12, 0] - 1], t,
      ephs.ipt[12, 1], 3, ephs.ipt[12, 2], list[11], pefau);
    for j := 0 to 5 do
      pvs[10, j] := pefau[j];
  end;
  Result := 1;
end;


procedure interp(ephint: pephdata; iinfo: piinfo; bufi: pdouble;
  t: Array_1D; ncf, ncm, na, ifl: integer; var posvel: array_5D);
var
  dna, temp, tc, vfac, tval: double;
  a, l, i, j, itemp: smallint;
  buf_ptr: pdouble;
begin
  //entry point. get correct sub-interval number for this set
  //of coefficients and then get normalized chebyshev time
  //within that subinterval.
  dna := na;
  temp := dna * t[0];
  l := trunc(temp);
  tc := 2.0 * frac(temp) - 1.0;

  //check to see whether chebyshev time has changed,
  //and compute new polynomial values if it has.
  //(the element iinfo->pc[1] is the value of t1[tc] and hence
  //contains the value of tc on the previous call.
  if tc <> iinfo.pc[1] then
  begin
    iinfo.np := 2;
    iinfo.nv := 3;
    iinfo.pc[1] := tc;
    iinfo.twot := tc + tc;
  end;
  //be sure that at least 'ncf' polynomials have been evaluated
  //and are stored in the array 'iinfo->pc'
  if iinfo.np < ncf then
  begin
    a := iinfo.np;
    itemp := ncf - iinfo.np;
    for i := itemp downto 1 do
    begin
      iinfo.pc[a] := iinfo.twot * iinfo.pc[a - 1] - iinfo.pc[a - 2];
      Inc(a);
    end;
    iinfo.np := ncf;
  end;
  //interpolate to get position for each component
  for i := 0 to ncm - 1 do
  begin     // ncm is a number of coordinates  + ncf * (i + l * ncm + 1);
    posvel[i] := 0;
    buf_ptr := bufi;
    Inc(buf_ptr, ncf * (i + l * ncm + 1));
    Dec(buf_ptr);
    for j := ncf downto 1 do
    begin
      posvel[i] := posvel[i] + iinfo.pc[j - 1] * buf_ptr^;
      Dec(buf_ptr);
    end;
  end;
  if ifl <= 1 then
    exit;

  //if velocity interpolation is wanted, be sure enough
  //derivative polynomials have been generated and stored.
  iinfo.vc[2] := iinfo.twot + iinfo.twot;
  if iinfo.nv < ncf then
  begin
    a := iinfo.nv;
    itemp := ncf - iinfo.nv;
    for i := itemp downto 1 do
    begin
      iinfo.vc[a] := iinfo.twot * iinfo.vc[a - 1] +
        iinfo.pc[a - 1] + iinfo.pc[a - 1] - iinfo.vc[a - 2];
      Inc(a);
    end;
    iinfo.nv := ncf;
  end;
  //interpolate to get velocity for each component  ncf * (i + l * ncm + 1);
  vfac := (dna + dna) / t[1];
  for i := 0 to ncm - 1 do
  begin
    tval := 0;
    buf_ptr := bufi;
    Inc(buf_ptr, ncf * (i + l * ncm + 1));
    Dec(buf_ptr);
    for j := ncf downto 1 do
    begin
      tval := tval + iinfo.vc[j - 1] * buf_ptr^;
      Dec(buf_ptr);
    end;
    posvel[i + ncm] := tval * vfac;
  end;
end;




//*************************** THE END ***************************************/




end.
