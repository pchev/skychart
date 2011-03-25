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
Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
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
Type Array_5B = array [0..5] of Byte;
Type Array_11i = array[0..11]of Smallint;
Type array_12_2i = array[0..12,0..2] of integer;
Type Array_1D = array [0..1] of double;
Type Array_5D = array [0..5] of double;
Type Array_17D = array [0..17]of double;
Type Array_12_5D = array[0..12,0..5] of double;


type   //data info required for process
  piinfo = ^iinfo;
  iinfo = record
    pc : Array_17D;
    vc : Array_17D;
    twot : double;
    np : Smallint;
    nv : Smallint;
end;

type  //use for data from file and process
    pephdata = ^ephdata;
  ephdata = record
    ephem_start : double;
    ephem_end : double;
    ephem_step : double;
    ncon : integer;
    auinkm : double;
    emrat : double;
    ipt : array_12_2i;
    de_version : integer;
    kernel_size : integer;
    recsize : integer;
    ncoeff : integer;
    swap_bytes : boolean;
    curr_cache_loc : integer;
    cache : array of double;
    pvsun : array_5D;
    de_file : string
  end;


//procedure to use in program to get planet position
function Calc_Planet_de(julian_date: double; planet_id: integer; var planet_arr: Array_5D;
                        in_au: boolean; planet_center: integer; velocity: boolean): boolean;

//first must load the de file
function load_de_file(jd: double; de_folder: string; de_type: integer): boolean;

//init the file into the stream
function init_de_file(ephemeris_filename: string): boolean;

//close de stream.
procedure close_de_file;

function SwapLong(i1:Integer):Integer;
function SwapDouble(i1: double): double;
function jpl_pleph(eph: pephdata; ephinfo: piinfo; et: double; ntarg, ncent: integer;
                  var rrd: Array_5D; calc_velocity: boolean): integer;
function jpl_state( ephs: pephdata; ephinfos: piinfo; et: double; list: array_11i;
                    var pvs: Array_12_5D; var nut: array_5D; bary: integer): integer;
procedure interp(ephint: pephdata; iinfo: piinfo; bufi: pdouble; t: Array_1D;
            ncf, ncm, na, ifl: integer; var posvel: array_5D);

var
    de_stream   : TMemoryStream;  //serve as cache for DE405 file.
    de_eph      : ephdata;        //init DE405
    de_iinfo  : iinfo;          //info on calc steps as part of DE405
    de_created  : boolean;

implementation  //all functions and procedure to use de.

function Calc_Planet_de(julian_date: double; planet_id: integer; var planet_arr: Array_5D;
                        in_au: boolean; planet_center: integer; velocity: boolean): boolean;

var
    rval : byte;
begin

    //set if output in au or km
    if in_au then de_eph.auinkm := 149597870.691 else de_eph.auinkm := 1;

    rval := jpl_pleph( @de_eph, @de_iinfo, julian_date, planet_id, planet_center, planet_arr, velocity);

    {Results are transfered to vector in array 0..2 and velocity 3..5
     to find range do - val_range := sqrt(sqr(planet_arr[0]) +  sqr(planet_arr[1]) + sqr(planet_arr[2]))
     Maintain result using barycenter
     }
    if rval = 1 then begin
        result:=true;
    end
    else result:=false;
end;

PROCEDURE Djd(jd:Double;VAR annee,mois,jour:INTEGER; VAR Heure:double);
var u0,u1,u2,u3,u4 : double;
  gregorian : boolean;
begin
u0:=jd+0.5;
if int(u0)>=2299161 then gregorian:=true else gregorian:=false;
u0:=jd+32082.5;
if gregorian then begin
   u1:=u0+floor(u0/36525)-floor(u0/146100)-38;
   if jd>=1830691.5 then u1:=u1+1;
   u0:=u0+floor(u1/36525)-floor(u1/146100)-38;
end;
u2:=floor(u0+123);
u3:=floor((u2-122.2)/365.25);
u4:=floor((u2-floor(365.25*u3))/30.6001);
mois:=round(u4-1);
if mois>12 then mois:=mois-12;
jour:=round(u2-floor(365.25*u3)-floor(30.6001*u4));
annee:=round(u3+floor((u4-2)/12)-4800);
heure:=(jd-floor(jd+0.5)+0.5)*24;
end;

function load_de_file(jd: double; de_folder: string; de_type: integer): boolean;
var
    de_file, de_filename : string;
    de_y,y,m,d : integer;
    hour: double;
begin
    //first we need to extract the year
    result := false;
    djd(jd,y,m,d,hour);
    //using the year to find the file and name it.
    Case de_type of
         200: begin  //1600 to 2200 - 50 years steps
                  if InRange(y, 1600, 2200) then begin
                      de_y := 1600 + floor((y - 1600) / 50) * 50;
                      de_file := 'unxp' + floatToStr(de_y) + '.200';
                  end else exit;
              end;
        403:  begin  //1950 to 2025 - 25 years step
                    if InRange(y, 1950, 2025) then begin
                      de_y := 1950 + floor((y - 1950) / 25) * 25;
                      de_file := 'linx' + floatToStr(de_y) + '.403';
                      if not fileexists(de_folder +DirectorySeparator+ de_file) then begin
                         de_file := 'unxp' + floatToStr(de_y) + '.403';
                      end;
                    end else exit;
              end;
        405:  begin  //1600 to 2200 - 150 or 50 years step
                  if InRange(y, 1600, 2200) then begin
                          de_y := 1600 + floor((y - 1600) / 150) * 150;
                          de_file := 'linx' + floatToStr(de_y) + '.405';
                          if not fileexists(de_folder +DirectorySeparator+ de_file) then begin
                             de_y := 1600 + floor((y - 1600) / 50) * 50;
                             de_file := 'unxp' + floatToStr(de_y) + '.405';
                          end;
                  end else exit;
              end;
        406:  begin  // -3000 to 3000 - 1 file or 300 years step
                  if InRange(y, -3000, 3000) then begin
                      de_file := 'linxm3000p3000.406';
                      if not fileexists(de_folder +DirectorySeparator+ de_file) then begin
                        de_y := -3000 + floor((y - (-3000)) / 300) * 300;
                        if de_y < 0 then
                           de_file := 'unxm' + FormatFloat('0000',abs(de_y)) + '.406'
                        else
                           de_file := 'unxp' + FormatFloat('0000',de_y) + '.406';
                      end;
                  end else exit;
              end;
        421:  begin  //1900 to 2050 - 1 file
                    if InRange(y, 1900, 2049) then begin
                      de_y := 1900;
                      de_file := 'linx' + floatToStr(de_y) + '.421';
                      if not fileexists(de_folder +DirectorySeparator+ de_file) then begin
                         de_file := 'unxp' + floatToStr(de_y) + '.421';
                      end;
                    end else exit;
              end;
        423:  begin  //1900 to 2200 - 150 years step
                  if InRange(y, 1900, 2200) then begin
                          de_y := 1900 + floor((y - 1900) / 150) * 150;
                          de_file := 'linx' + floatToStr(de_y) + '.423';
                          if not fileexists(de_folder +DirectorySeparator+ de_file) then begin
                             de_file := 'unxp' + floatToStr(de_y) + '.423';
                          end;
                  end else exit;
              end;
    end;

    //check if stream is created
    if de_created then else
    begin
        de_stream := TMemoryStream.Create;
        de_created := true;
    end;

    //if file is not already loaded then load
    if de_eph.de_file <> de_file then begin
      //add folder location
      de_filename := de_folder +DirectorySeparator+ de_file;
      //see if file is there, set DE return true if it works
      if fileexists(de_filename) then begin
            if init_de_file(PChar(de_filename)) then begin
              de_eph.de_file := de_file;
              result := true;
            end;
      end;
    end else result := true;
end;

// here we will use a memory stream to load and file and extract coef.

function init_de_file(ephemeris_filename: string): boolean;
var
  i, j : integer;
    Title : array[0..83] of Char;
    itemp : integer;
begin
    for j := 0 to 2 do
         for i := 0 to 12 do
            de_eph.ipt[i,j]:= 0;
    de_stream.Clear;
    de_stream.LoadFromFile(ephemeris_filename);
    //Seek - soFromCurrent - soFromBeginning - soFromEnd
    de_stream.Read(Title, Sizeof(Title));
    de_stream.Seek(2568, soFromCurrent);
    de_stream.Read(de_eph, 28);
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
      de_eph.swap_bytes := true
    else
        de_eph.swap_bytes := false;
    if de_eph.swap_bytes then begin //byte order is wrong for current platform
        de_eph.ephem_start := SwapDouble( de_eph.ephem_start);
        de_eph.ephem_end := SwapDouble( de_eph.ephem_end);
        de_eph.ephem_step := SwapDouble( de_eph.ephem_step);
        de_eph.ncon := SwapLong( de_eph.ncon);
        de_eph.auinkm := SwapDouble( de_eph.auinkm);
        de_eph.emrat := SwapDouble( de_eph.emrat);
        de_eph.de_version := SwapLong( de_eph.de_version);
        for j := 0 to 2 do
            for i := 0 to 12 do
                de_eph.ipt[i,j]:= SwapLong( de_eph.ipt[i,j]);
    end;
    de_eph.kernel_size := 4;
    for i := 0 to 12 do begin
        if i = 11 then
          itemp := 4
        else
          itemp := 6; de_eph.kernel_size := de_eph.kernel_size
               + de_eph.ipt[i,1] * de_eph.ipt[i,2] * itemp;
    end;
    de_eph.recsize := de_eph.kernel_size * 4;
    de_eph.ncoeff := de_eph.kernel_size div 2;
    result := true;
end;

procedure close_de_file;
begin
    de_stream.Free;
    de_created := false;
end;


//swap longint

Function SwapLong(i1:Integer):Integer;
  Type Array_3B = Array [0..3] of Byte;
Var
  Tmp: ^Array_3B;
    it : Byte;
    i : Integer;
Begin
    Tmp := @i1;
    For i := 0 to 1 do Begin
        it := Tmp^[i];
        Tmp^[i] := Tmp^[3-i];
        Tmp^[3-i] := it;
    End;
    Result := i1;
End;

//swap double

Function SwapDouble(i1: double): double;
    Type Array_7B = Array [0..7] of Byte;
Var
  Tmp: ^Array_7B;
  it : Byte;
  i : Integer;
Begin
    Tmp := @i1;
    For i := 0 to 3 do Begin
        it := Tmp^[i];
        Tmp^[i] := Tmp^[7-i];
        Tmp^[7-i] := it;
    End;
    Result := i1;
End;





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
**           for this, set km=TRUE at the begining of the program.          **
**                                                                          **
**     calc_velocity = boolean ;  if true,  velocities will be              **
**           computed,  otherwise not.                                      **
**                                                                          **
*****************************************************************************}

function jpl_pleph(eph: pephdata; ephinfo: piinfo; et: double; ntarg,
     ncent: integer; var rrd: Array_5D; calc_velocity: boolean): integer;
var
    pv : Array_12_5D;
    i : Smallint;
    k : Smallint;
    lista : Array_11i;
    list_val : Smallint;
begin
  result := 0;
    //zero result to avoid NAN
    for i := 0 to 5 do rrd[i] := 0;
    for i := 0 to 5 do for k:= 0 to 12 do pv[k,i] := 0;
    if ntarg = ncent then exit;
    //zero value in list
    for i := 0 to 11 do lista[i] := 0;
    //set value for list if velocity
    if calc_velocity then list_val := 2 else list_val := 1;
    // check for nutation call
    if ntarg = 14 then begin
        if eph.ipt[11,1] > 0 then begin //there is nutation on ephemeris
            lista[10] := list_val;
            if jpl_state(eph, ephinfo, et, lista, pv, rrd, 0) <> 0 then
              result := 1;
        end else result := 0;          //no nutations on the ephemeris file
        exit;
    end;
    //  check for librations
    if ntarg = 15 then begin
        if eph.ipt[12,1] > 0 then begin //librations on ephemeris file
            lista[11] := list_val;
            if jpl_state( eph, ephinfo, et, lista, pv, rrd, 0) <> 0 then
              result := 1;
            for i := 0 to 5 do rrd[i] := pv[10,i]; //librations
        end  else result := 0;   //no librations on the ephemeris file
        exit;
    end;
    //  force barycentric output by 'state'
    //  set up proper entries in 'list' array for state call
    for i := 0 to 1 do begin // list[] IS NUMBERED FROM ZERO !
        k := ntarg-1;
        if i = 1 then k := ncent-1;        //same for ntarg & ncent
        if k <= 9 then lista[k] := list_val; //Major planets
        if k = 9 then lista[2] := list_val;  //for moon,  earth state is needed
        if k = 2 then lista[9] := list_val;  //for earth,  moon state is needed
        if k = 12 then lista[2] := list_val; //EMBary state additionaly
    end;
    //make call to state
    jpl_state( eph, ephinfo, et, lista, pv, rrd, 0);
    //Solar System barycentric Sun state goes to pv[10][]
    if (ntarg = 11) or (ncent = 11) then
        for i := 0 to 5 do pv[10,i] := eph.pvsun[i];
    //Solar System Barycenter coordinates & velocities equal to zero
    if (ntarg = 12) or (ncent = 12) then
        for i := 0 to 5 do pv[11,i] := 0;
    //Solar System barycentric EMBary state: /
    if (ntarg = 13) or (ncent = 13) then
        for i := 0 to 5 do pv[12,i] := pv[2,i];
    //if moon from earth or earth from moon .....
    if (ntarg * ncent = 30) and (ntarg + ncent = 13) then
        for i := 0 to 5 do pv[2,i] := 0
    else begin
        if lista[2] = 1 then    //calculate earth state from EMBary
            for i := 0 to lista[2] * 3 do
              pv[2,i] := pv[2,i] - pv[9,i] / (1.0 + eph.emrat);
        if lista[9] = 1 then   //calculate Solar System barycentric moon state
            for i := 0 to lista[9] * 3 do
              pv[9,i] := pv[9,i] + pv[2,i];
    end;
    for i := 0 to (list_val * 3) - 1 do
      rrd[i] := pv[ntarg-1,i] - pv[ncent-1,i];
    result := 1;
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

function jpl_state( ephs: pephdata; ephinfos: piinfo; et: double; list: array_11i;
                  var pvs: Array_12_5D; var nut: array_5D; bary: integer): integer;
var
  i, j, q : Smallint;
    n_intervals : Smallint;
    flag, nr : integer;
    aufac, s, prev_midnight, time_of_day : double;
    dest : Array_5D;
    t : Array_1D;
    pefau : Array_5D;
begin
//  ********** main entry point **********
    s := et - 0.5;
    prev_midnight := floor(s);
    time_of_day := s - prev_midnight;
    prev_midnight := prev_midnight + 0.5;
  //here prev_midnight contains last midnight before epoch desired(in JED: *.5)
  //and time_of_day contains the remaining, fractional part of the epoch
  //error return for epoch out of range
    if (et < ephs.ephem_start) or (et > ephs.ephem_end) then begin
        result := 0;
        exit;
    end;
  //calculate record # and relative time in interval
    nr := trunc ((prev_midnight-ephs.ephem_start)/ephs.ephem_step) + 2;
  //add 2 to adjust for the first two records containing header data (2 dates)
    if prev_midnight = ephs.ephem_end then dec(nr);
    t[0] :=(prev_midnight - ((nr - 2.0) * ephs.ephem_step + ephs.ephem_start) +
          time_of_day) / ephs.ephem_step;
    //read correct record if not in core (static vector buf[])
    if (nr <> ephs.curr_cache_loc) then begin
        SetLength(ephs.cache, ephs.ncoeff);
      ephs.curr_cache_loc := nr;
      de_stream.Seek(nr * ephs.recsize, soFromBeginning);
      for i:= 0 to ephs.ncoeff-1 do begin
        de_stream.Read(ephs.cache[i], SizeOf( double));
        if ephs.swap_bytes then ephs.cache[i] := SwapDouble(ephs.cache[i]);
      end;
  end;
    t[1] := ephs.ephem_step;
    aufac := 1 / ephs.auinkm;
    n_intervals := 1;
    while n_intervals <= 8 do begin
        for i := 0 to 10 do begin
            if (n_intervals = ephs.ipt[i,2]) and
            ((list[i] = 1) or (i = 10)) then begin
                if i = 10 then flag := 2 else flag := list[i];
                interp(ephs, ephinfos, @ephs.cache[ephs.ipt[i,0]-1], t,
                ephs.ipt[i,1], 3, n_intervals, flag, dest);
                for j := 0 to (flag * 3) - 1 do dest[j] := dest[j] * aufac;
                if i = 10 then
                  for q := 0 to 5 do ephs.pvsun[q]:= dest[q]
                else
                  for q := 0 to 5 do pvs[i,q]:= dest[q];
            end;
        end;
        n_intervals := n_intervals * 2;
    end;
  if bary <> 1 then begin
        for i := 0 to 8 do begin
            for j := 0 to ((list[i] * 3) - 1) do
              pvs[i,j]:= pvs[i,j] - ephs.pvsun[j];
        end;
    end;
    //do nutations if requested (and if on file)
  if(list[10] > 0) and (ephs.ipt[11,1] > 0) then begin
      interp(ephs, ephinfos, @ephs.cache[ephs.ipt[11,0]-1], t,
          ephs.ipt[11,1], 2, ephs.ipt[11,2], list[10], nut);
    end;
    //get librations if requested (and if on file)
  if(list[11] > 0) and (ephs.ipt[12,1] > 0) then begin
        interp(ephs, ephinfos, @ephs.cache[ephs.ipt[12,0]-1], t,
        ephs.ipt[12,1], 3, ephs.ipt[12,2], list[11], pefau);
        for j := 0 to 5 do pvs[10,j]:= pefau[j];
    end;
  result := 1;
end;


procedure interp(ephint: pephdata; iinfo: piinfo; bufi: pdouble;
        t: Array_1D;  ncf, ncm, na, ifl: integer; var posvel: array_5D);
var
  dna, dt1, temp, tc, vfac, tval : double;
    a, l, i, j, itemp : Smallint;
  buf_ptr : pdouble;
begin
    //entry point. get correct sub-interval number for this set
    //of coefficients and then get normalized chebyshev time
    //within that subinterval.
    dna := na;
    dt1 := t[0] - frac(t[0]) ;      //modf( t[0], &dt1);
    temp := dna * t[0];
    l := trunc(temp - dt1);
    //tc is the normalized chebyshev time (-1 <= tc <= 1)
    tc := 2.0 * (frac(temp) + dt1) - 1.0;
  //check to see whether chebyshev time has changed,
  //and compute new polynomial values if it has.
  //(the element iinfo->pc[1] is the value of t1[tc] and hence
  //contains the value of tc on the previous call.
    if tc <> iinfo.pc[1] then begin
        iinfo.np := 2;
            iinfo.nv := 3;
            iinfo.pc[1] := tc;
            iinfo.twot := tc + tc;
    end;
    //be sure that at least 'ncf' polynomials have been evaluated
    //and are stored in the array 'iinfo->pc'
    if iinfo.np < ncf then begin
        a := iinfo.np;
          itemp := ncf - iinfo.np;
        for i := itemp downto 1 do begin
              iinfo.pc[a] := iinfo.twot * iinfo.pc[a-1] - iinfo.pc[a-2];
              inc(a);
        end;
        iinfo.np := ncf;
    end;
  //interpolate to get position for each component
  for i := 0 to ncm - 1 do begin     // ncm is a number of coordinates  + ncf * (i + l * ncm + 1);
    posvel[i]:= 0;
        buf_ptr := bufi;
        inc(buf_ptr, ncf * (i + l * ncm + 1));
        dec(buf_ptr);
      for j := ncf downto 1 do begin
          posvel[i] := posvel[i] + iinfo.pc[j-1] * buf_ptr^;
          dec(buf_ptr);
      end;
    end;
    if ifl <= 1 then exit;

        //if velocity interpolation is wanted, be sure enough
    //derivative polynomials have been generated and stored.
    vfac := (dna + dna) / t[1];
    iinfo.vc[2] := iinfo.twot + iinfo.twot;
    if iinfo.nv < ncf then begin
      a := iinfo.nv;
        itemp := ncf - iinfo.nv;
      for i := itemp downto 1 do begin
          iinfo.vc[a] := iinfo.twot * iinfo.vc[a-1] + iinfo.pc[a-1]
                     + iinfo.pc[a-1] - iinfo.vc[a-2];
          inc(a);
      end;
      iinfo.nv := ncf;
   end;
   //interpolate to get velocity for each component  ncf * (i + l * ncm + 1);
   for i := 0 to ncm -1 do begin
      tval := 0;
        buf_ptr := bufi;
        inc(buf_ptr, ncf * (i + l * ncm + 1));
        dec(buf_ptr);
        for j := ncf downto 1 do begin
            tval := tval + iinfo.vc[j-1] * buf_ptr^;
          dec(buf_ptr);
        end;
        posvel[i+ncm] := tval * vfac;
   end;
end;




//*************************** THE END ***************************************/




end.
