library satxy;

//
// Modified 02-Sep-2000, J. Burton
//
// The following line should be included when processing the elsat and
// ixsat files generated using the high-precision data files.  If the
// low precision data was used, comment out the following line.
//
//{$DEFINE HIGHPREC}

uses
  elsat in 'elsat.pas',   // fichier generer par mkposxy
  ixsat in 'ixsat.pas';

  {$LIBPREFIX 'lib'}

// fichier generer par mkposxy

type double8 = array[1..8] of double;
     Pdouble8 = ^double8;

// date julienne -> annee,mois,jour
PROCEDURE Djd(jd:Double;VAR annee,mois,jour:INTEGER; VAR Heure:double);
 VAR z,f,a,al,b,c,d,e:double;
 BEGIN
    z := Int(jd+0.5);
    f := jd + 0.5 - z ;
    IF z<2299161.0 THEN
       a := z
      ELSE
      begin
       al:= Int((z-1867216.25)/36524.25);
        a := z + 1.0 + al - Int(al/4.0);
    END;
    b := a + 1524.0;
    c := Int((b-122.1)/365.25);
    d := Int(365.25*c);
    e := Int((b-d)/30.6001);
    jour := Trunc(b-d-Int(30.6001*e)+f);
    IF e<13.5 THEN
        mois:=Trunc(e)-1
      ELSE
        mois:=Trunc(e)-13;
    IF mois>2 THEN
        annee:=Trunc(c)-4716
      ELSE
        annee:=Trunc(c)-4715;
    IF (annee MOD 4 <> 0) AND (mois=2) AND (jour=29) THEN
    begin
            mois:=3;
            jour:=1;
    END;
    Heure:=24.0*f ;
 END ;

Function Satxyfm(djc : double; ipla : integer; Px,Py : Pdouble8):integer; stdcall;
{     Translation en Pascal pour Delphi par Patrick Chevalley le 10 novembre 1999

      Exemple d'appel depuis Delphi :

      type double8 = array[1..8] of double;
           Pdouble8 = ^double8;
      Function Satxyfm(djc : double; ipla : integer; Pxx,Pyy : Pdouble8):integer; stdcall; external 'SATXY.DLL';
      var i,j : integer;
      xsat,ysat : double8;
      jde : double;
      begin
         jde:=2451494.0
         i:=satxyfm(jde,6,addr(xsat),addr(ysat));
      end;

*     =============================================================
*     POSITIONS OF THE SATELLITES OF  MARS, JUPITER, SATURN, URANUS

*     (c) copyright Bureau des longitudes 1995
*     =============================================================
*     Astrometric differential tangential coordinates J2000

*     Input  data:
*     djc    : julian date of computation
*     ipla   : number of the planet
               mars = 4
               jupiter = 5
               saturn = 6
               uranus = 7

*     Output data:
*     Astrometric differential tangential coordinates J2000:
*     Px^[<=8]  : differential coordinates in arcsec (towards East)
*     Py^[<=8]  : differential coordinates in arcsec (towards North)

*     =============================================================
}

var
      ninter : array [1..8] of integer;
      year,mm,dd,isat,ksat,id : integer;
      hh,t1,t2,tau,x,y,at : double;

const  nsat : array [1..4] of integer =(2,4,8,5);

begin
result:=1;
ipla:=ipla-3;
djd(djc,year,mm,dd,hh);

{$IFDEF HIGHPREC}
if (year<1995) or (year>2020) then exit;
{$ELSE}
if (year<1997) or (year>2020) then exit;
{$ENDIF}

//     Read the number of satellites and number of the planet on the first record
{$IFDEF HIGHPREC}
with ixelem[ipla,year-1994] do begin
{$ELSE}
with ixelem[ipla,year-1996] do begin
{$ENDIF}

//     Number of intervals for each satellite
for isat:=1 to nsat[ipla] do begin
    if isat<nsat[ipla] then ninter[isat]:= idn[isat+1]-idn[isat];
    if isat=nsat[ipla] then ninter[isat]:= ienrf-idn[isat]+1;
end;

for ksat:=1 to nsat[ipla] do begin
//  Control of the validity of the date DJC
    if ((djc-djori+1)/(dellt[ksat])) > ninter[ksat] then exit ;
//  computation of the number of record id for satellite ksat
    id:=trunc((djc-djori)/dellt[ksat])+idn[ksat]+ixa-1;
    with elem[id] do begin
//      control of the interval
        t1:= trunc(t0) + 0.5;
        t2:= t1+trunc(dellt[ksat]);
        if (djc<t1)or(djc>t2) then exit;
//      computation of the differential positions at djc
//      tau is the time elapsed from t1
        tau := djc-t1;
        at  := tau*freq[ksat];
        x := cmx[1]+cmx[2]*tau+cmx[3]*sin(at+cfx[1]);
        y := cmy[1]+cmy[2]*tau+cmy[3]*sin(at+cfy[1]);
        x := x + cmx[4]*tau*sin(at+cfx[2])
              + cmx[5]*tau*tau*sin(at+cfx[3])
              + cmx[6]*sin(2.0*at+cfx[4]);
        y := y + cmy[4]*tau*sin(at+cfy[2])
              + cmy[5]*tau*tau*sin(at+cfy[3])
              + cmy[6]*sin(2.0*at+cfy[4]);
        Px^[ksat]:=x;
        Py^[ksat]:=y;
end;
end;
end;              
result:=0;
end;

{$ifdef linux}
exports  Satxyfm ;
{$endif}
{$ifdef mswindows}
exports  Satxyfm index 1 ;
{$endif}


begin
end.
