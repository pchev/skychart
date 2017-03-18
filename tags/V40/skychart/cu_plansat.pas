unit cu_plansat;
{
Copyright Xplanet project & Patrick Chevalley

http://xplanet.sourceforge.net
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
Rewrite for Pascal language of libmoons from the Xplanet project.
As Xplanet itself is used for the planet disk rendering this
ensure the satellites positions computed in Skychart and Xplanet
are the same.
}

interface

uses Math, u_util, cu_smallsat;

type
double20 = array[1..20] of double;

function MarSatAll(jde: double; var xsat,ysat,zsat : double20):integer;
function JupSatAll(jde: double; smallsat: boolean; var xsat,ysat,zsat : double20):integer;
function SatSatAll(jde: double; smallsat: boolean; var xsat,ysat,zsat : double20):integer;
function UraSatAll(jde: double; smallsat: boolean; var xsat,ysat,zsat : double20):integer;
function NepSatAll(jde: double; smallsat: boolean; var xsat,ysat,zsat : double20):integer;
function PluSatAll(jde: double; var xsat,ysat,zsat : double20):integer;
function MarSatOne(jde: double; isat:integer; var xs,ys,zs : double):integer;
function JupSatOne(jde: double; isat:integer; var xs,ys,zs : double):integer;
function SatSatOne(jde: double; isat:integer; var xs,ys,zs : double):integer;
function UraSatOne(jde: double; isat:integer; var xs,ys,zs : double):integer;
function NepSatOne(jde: double; isat:integer; var xs,ys,zs : double):integer;
function PluSatOne(jde: double; isat:integer; var xs,ys,zs : double):integer;


implementation

{$I tass17.inc}

type
Tbody =(
    SUN,
    MERCURY,
    VENUS,
    EARTH, MOON,
    MARS, PHOBOS, DEIMOS,
    JUPITER, IO, EUROPA, GANYMEDE, CALLISTO,
    SATURN, MIMAS, ENCELADUS, TETHYS, DIONE, RHEA, TITAN, HYPERION, IAPETUS, PHOEBE,
    URANUS, MIRANDA, ARIEL, UMBRIEL, TITANIA, OBERON,
    NEPTUNE, TRITON, NEREID,
    PLUTO, CHARON,
    RANDOM_BODY,    // RANDOM_BODY needs to be after the last "real" body
    ABOVE_ORBIT, ALONG_PATH, BELOW_ORBIT, DEFAULT, MAJOR_PLANET, NAIF, NORAD, SAME_SYSTEM, UNKNOWN_BODY
    );

const deg_to_rad = pi/180.0;
      TWO_PI = 2*pi;
      AU_to_km = 149597870.66;

procedure rotateX(var X, Y, Z: double; theta:double);
var st,ct,X0,Y0,Z0: double;
begin
    st := sin(theta);
    ct := cos(theta);
    X0 := X;
    Y0 := Y;
    Z0 := Z;

    X := X0;
    Y := Y0 * ct + Z0 * st;
    Z := Z0 * ct - Y0 * st;
end;

procedure rotateZ(var X, Y, Z: double; theta:double);
var st,ct,X0,Y0,Z0: double;
begin
    st := sin(theta);
    ct := cos(theta);
    X0 := X;
    Y0 := Y;
    Z0 := Z;

    X := X0 * ct + Y0 * st;
    Y := Y0 * ct - X0 * st;
    Z := Z0;
end;

//  Precess rectangular coordinates in B1950 frame to J2000 using
//  Standish precession matrix from Lieske (1998)
procedure precessB1950J2000(var X, Y, Z:double);
const p: array[0..2,0..2] of double =
        ( ( 0.9999256791774783, -0.0111815116768724, -0.0048590038154553 ),
          ( 0.0111815116959975,  0.9999374845751042, -0.0000271625775175 ),
          ( 0.0048590037714450, -0.0000271704492210,  0.9999881946023742 ) );
var newX,newY,newZ: double;
begin
    newX := p[0][0] * X + p[0][1] * Y + p[0][2] * Z;
    newY := p[1][0] * X + p[1][1] * Y + p[1][2] * Z;
    newZ := p[2][0] * X + p[2][1] * Y + p[2][2] * Z;

    X := newX;
    Y := newY;
    Z := newZ;
end;

function kepler(e,M: double):double;
var delta: double;
begin
    M:=rmod(M,2*pi);
    result:=M;
    delta := 1;
    while (abs(delta) > 1E-10) do begin
        delta := (M + e * sin(result) - result)/(1 - e * cos(result));
        result += delta;
    end;
end;

function solveKepler(L,K,H: double): double;
var F,E,F0,E0,eps,SF,CF,FF0,FPF0,SDIR,denom : double;
    i : integer;
begin
    if (L = 0) then begin
      result:=0;
      exit;
    end;

    F := L;
    F0 := L;
    E0 := abs(L);

    eps := 1e-16;
    for i := 0 to 19 do begin
        SF := sin(F0);
        CF := cos(F0);
        FF0 := F0 - K*SF + H*CF - L;
        FPF0 := 1 - K*CF - H*SF;
        SDIR := FF0/FPF0;

        denom := 1;
        while true do begin
            F := F0 - SDIR / denom;
            E := abs(F-F0);
            if (E <= E0) then break;
            denom *= 2;
        end;

        if (denom = 1)and(E <= eps)and(FF0 <= eps) then begin
          result:=F;
          exit;
        end;
        F0 := F;
        E0 := E;
    end;
    result:=F;
end;


function marsat(jd:double; b:Tbody; var X,Y,Z: double):boolean;
{
  Ephemerides for Phobos and Deimos are described in Sinclair,
  Astron. Astrophys. 220, 321-328 (1989)
}
var td,ty,dL,ma,EE,omega: double;
    a: double;        // semimajor axis
    e: double;        // eccentricity
    I: double;        // inclination of orbit to Laplacian plane

    L: double;        // mean longitude
    P: double;        // longitude of pericenter
    K: double;        // longitude of node of orbit on Laplacian plane

    N: double;        // node of the Laplacian plane on the Earth
                      // equator B1950
    J: double;        // inclination of Laplacian plane with respect to
                      // the Earth equator B1950
begin
    td := jd - 2441266.5;
    ty := td/365.25;


    case b of
    PHOBOS: begin
        a := 9379.40;
        e := 0.014979;
        I := 1.1029 * deg_to_rad;
        L := (232.412 + 1128.8445566 * td + 0.001237 * ty * ty) * deg_to_rad;
        P := (278.96 + 0.435258 * td) * deg_to_rad;
        K := (327.90 - 0.435330 * td) * deg_to_rad;
        N := (47.386 - 0.00140 * ty) * deg_to_rad;
        J := (37.271 + 0.00080 * ty) * deg_to_rad;
        result:=true;
       end;
    DEIMOS: begin
        a := 23461.13;
        e := 0.000391;
        I := 1.7901 * deg_to_rad;
        P := (111.7 + 0.017985 * td) * deg_to_rad;
        L := (28.963 + 285.1618875 * td) * deg_to_rad;
        K := (240.38 - 0.018008 * td) * deg_to_rad;
        N := (46.367 - 0.00138 * ty) * deg_to_rad;
        J := (36.623 + 0.00079 * ty) * deg_to_rad;
        dL := -0.274 * sin(K - 43.83 * deg_to_rad) * deg_to_rad;
        L += dL;
        result:=true;
        end;
    else begin
        result:=false;
        a:=0;L:=0;e:=0;P:=0;I:=0;K:=0;N:=0;J:=0;
        end;
    end;
    if result then begin
      ma := L - P;
      EE := kepler(e, ma);

      // convert semi major axis from km to AU
      a /= AU_to_km;

      // rectangular coordinates on the orbit plane, x-axis is toward
      // pericenter
      X := a * (cos(EE) - e);
      Y := a * sqrt(1 - e*e) * sin(EE);
      Z := 0;

      // longitude of pericenter measured from ascending node of the
      // orbit on the Laplacian plane
      omega := P - (K + N);

      // rotate towards ascending node of the orbit on the Laplacian
      // plane
      rotateZ(X, Y, Z, -omega);

      // rotate towards Laplacian plane
      rotateX(X, Y, Z, -I);

      // rotate towards ascending node of the Laplacian plane on the
      // Earth equator B1950
      rotateZ(X, Y, Z, -K);

      // rotate towards Earth equator B1950
      rotateX(X, Y, Z, -J);

      // rotate to vernal equinox
      rotateZ(X, Y, Z, -N);

      // precess to J2000
      precessB1950J2000(X, Y, Z);
    end;
end;


function jupsat(jd:double; b:Tbody; var X,Y,Z: double):boolean;
{
  The Galilean satellite ephemerides E5 are described in Lieske,
  Astron. Astrophys. Suppl. Ser., 129, 205-217 (1998)
}
  procedure computeArguments(t:double; var l1,l2,l3,l4,om1,om2,om3,om4,psi,Gp,G : double);
  begin
      // mean longitudes
      l1 := (106.077187 + 203.48895579033 * t) * deg_to_rad;
      l2 := (175.731615 + 101.37472473479 * t) * deg_to_rad;
      l3 := (120.558829 +  50.31760920702 * t) * deg_to_rad;
      l4 := ( 84.444587 +  21.57107117668 * t) * deg_to_rad;

      // proper nodes
      om1 := (312.334566 - 0.13279385940 * t) * deg_to_rad;
      om2 := (100.441116 - 0.03263063731 * t) * deg_to_rad;
      om3 := (119.194241 - 0.00717703155 * t) * deg_to_rad;
      om4 := (322.618633 - 0.00175933880 * t) * deg_to_rad;

      // longitude of origin of coordingate (Jupiter's pole)
      psi := (316.518203 - 2.08362E-06 * t) * deg_to_rad;

      // mean anomaly of Saturn
      Gp := (31.978528 + 0.03345973390 * t) * deg_to_rad;

      // mean anomaly of Jupiter
      G := (30.237557 + 0.08309257010 * t) * deg_to_rad;
  end;

var t: double;
    phi,pi1,pi2,pi3,pi4,PIj,phi1,phi2,phi3,phi4: double;
    axis1,axis2,axis3,axis4,PIG2: double;
    xi,upsilon,zeta,radius,lon,n,I,OM,J,eps : double;
    // mean longitudes
    l1, l2, l3, l4: double;
    // proper nodes
    om1, om2, om3, om4: double;
    // longitude of origin of coordinates (Jupiter's pole)
    psi: double;
    // mean anomaly of Saturn
    Gp: double;
    // mean anomaly of Jupiter
    G: double;

begin
    t := jd - 2443000.5;

    computeArguments(t, l1, l2, l3, l4, om1, om2, om3, om4, psi, Gp, G);
    
    // free libration
    phi := (199.676608 + 0.17379190461 * t) * deg_to_rad;

    // periapse longitudes
    pi1 := ( 97.088086 + 0.16138586144 * t) * deg_to_rad;
    pi2 := (154.866335 + 0.04726306609 * t) * deg_to_rad;
    pi3 := (188.184037 + 0.00712733949 * t) * deg_to_rad;
    pi4 := (335.286807 + 0.00183999637 * t) * deg_to_rad;

    // longitude of perihelion of jupiter
    PIj := 13.469942 * deg_to_rad;
    
    // phase angles
    phi1 := 188.374346 * deg_to_rad;
    phi2 :=  52.224824 * deg_to_rad;
    phi3 := 257.184000 * deg_to_rad;
    phi4 := 149.152605 * deg_to_rad;

    // semimajor axes, in AU
    axis1 :=  2.819353E-3;
    axis2 :=  4.485883E-3;
    axis3 :=  7.155366E-3;
    axis4 := 12.585464E-3;

    // common factors
    PIG2 := (PIj + G) * 2;

    xi := 0;
    upsilon := 0;
    zeta := 0;

    case b of
    IO: begin
        lon := l1;

        xi += 170 * cos(l1 - l2);
        xi += 106 * cos(l1 - l3);
        xi += -2 * cos(l1 - pi1);
        xi += -2 * cos(l1 - pi2);
        xi += -387 * cos(l1 - pi3);
        xi += -214 * cos(l1 - pi4);
        xi += -66 * cos(l1 + pi3 - PIG2);
        xi += -41339 * cos(2*(l1 - l2));
        xi += 3 * cos(2*(l1 - l3));
        xi += -131 * cos(4*(l1-l2));
        xi *= 1e-7;

        radius := axis1 * (1 + xi);

        upsilon +=    -26 * sin( 2 * psi - PIG2 );
        upsilon +=   -553 * sin( 2*(psi - PIj) );
        upsilon +=   -240 * sin( om3 + psi - PIG2 );
        upsilon +=     92 * sin( psi - om2 );
        upsilon +=    -72 * sin( psi - om3 );
        upsilon +=    -49 * sin( psi - om4 );
        upsilon +=   -325 * sin( G );
        upsilon +=     65 * sin( 2*G );
        upsilon +=    -33 * sin( 5*Gp - 2*G + phi2 );
        upsilon +=    -27 * sin( om3 - om4 );
        upsilon +=    145 * sin( om2 - om3 );
        upsilon +=     30 * sin( om2 - om4 );
        upsilon +=    -38 * sin( pi4 - PIj );
        upsilon +=  -6071 * sin( pi3 - pi4 );
        upsilon +=    282 * sin( pi2 - pi3 );
        upsilon +=    156 * sin( pi2 - pi4 );
        upsilon +=    -38 * sin( pi1 - pi3 );
        upsilon +=    -25 * sin( pi1 - pi4 );
        upsilon +=    -27 * sin( pi1 + pi4 - PIG2 );
        upsilon +=  -1176 * sin( pi1 + pi3 - PIG2 );
        upsilon +=   1288 * sin( phi );
        upsilon +=     39 * sin( 3*l3 - 7*l4 + 4*pi4 );
        upsilon +=    -32 * sin( 3*l3 - 7*l4 + pi3 + 3*pi4 );
        upsilon +=  -1162 * sin( l1 - 2*l2 + pi4 );
        upsilon +=  -1887 * sin( l1 - 2*l2 + pi3 );
        upsilon +=  -1244 * sin( l1 - 2*l2 + pi2 );
        upsilon +=     38 * sin( l1 - 2*l2 + pi1 );
        upsilon +=   -617 * sin( l1 - l2 );
        upsilon +=   -270 * sin( l1 - l3 );
        upsilon +=    -26 * sin( l1 - l4 );
        upsilon +=      4 * sin( l1 - pi1 );
        upsilon +=      5 * sin( l1 - pi2 );
        upsilon +=    776 * sin( l1 - pi3 );
        upsilon +=    462 * sin( l1 - pi4 );
        upsilon +=    149 * sin( l1 + pi3 - PIG2 );
        upsilon +=     21 * sin( 2*l1 - 4*l2 + om2 + om3 );
        upsilon +=   -200 * sin( 2*l1 - 4*l2 + 2*om2 );
        upsilon +=  82483 * sin( 2*(l1 - l2) );
        upsilon +=    -35 * sin( 2*(l1 - l3) );
        upsilon +=     -3 * sin( 3*l1 - 4*l2 + pi3 );
        upsilon +=    276 * sin( 4*(l1 - l2) );
        upsilon *= 1e-7;

        // now use the "time completed" series
        n := 203.48895579033 * deg_to_rad;
        computeArguments(t + upsilon/n, l1, l2, l3, l4,
                         om1, om2, om3, om4, psi, Gp, G);

        zeta +=    46 * sin( l1 + psi - 2*PIj - 2*G);
        zeta +=  6393 * sin( l1 - om1 );
        zeta +=  1825 * sin( l1 - om2 );
        zeta +=   329 * sin( l1 - om3 );
        zeta +=    93 * sin( l1 - om4 );
        zeta +=  -311 * sin( l1 - psi );
        zeta +=    75 * sin( 3*l1 - 4*l2 + om2 );
        zeta *= 1e-7;
        result:=true;
    end;

    EUROPA: begin
        lon := l2;

        xi +=    -18 * cos( om2 - om3 );
        xi +=    -27 * cos( 2*l3 - PIG2 );
        xi +=    553 * cos( l2 - l3 );
        xi +=     45 * cos( l2 - l4 );
        xi +=   -102 * cos( l2 - pi1 );
        xi +=  -1442 * cos( l2 - pi2 );
        xi +=  -3116 * cos( l2 - pi3 );
        xi +=  -1744 * cos( l2 - pi4 );
        xi +=    -15 * cos( l2 - PIj - G );
        xi +=    -64 * cos( 2*(l2 - l4) );
        xi +=    164 * cos( 2*(l2 - om2) );
        xi +=     18 * cos( 2*l2 - om2 - om3 );
        xi +=    -54 * cos( 5*(l2 - l3) );
        xi +=    -30 * cos( l1 - 2*l2 + pi4 );
        xi +=    -67 * cos( l1 - 2*l2 + pi3 );
        xi +=  93848 * cos( l1 - l2 );
        xi +=     48 * cos( l1 - 2*l3 + pi4 );
        xi +=    107 * cos( l1 - 2*l3 + pi3 );
        xi +=    -19 * cos( l1 - 2*l3 + pi2 );
        xi +=    523 * cos( l1 - l3 );
        xi +=     30 * cos( l1 - pi3 );
        xi +=   -290 * cos( 2*(l1 - l2) );
        xi +=    -91 * cos( 2*(l1 - l3) );
        xi +=     22 * cos( 4*(l1 - l2) );
        xi *= 1e-7;

        radius := axis2 * (1 + xi);

        upsilon +=       98 * sin( 2*psi - PIG2 );
        upsilon +=    -1353 * sin( 2*(psi - PIj) );
        upsilon +=      551 * sin( psi + om3 - PIG2 );
        upsilon +=       26 * sin( psi + om2 - PIG2 );
        upsilon +=       31 * sin( psi - om2 );
        upsilon +=      255 * sin( psi - om3 );
        upsilon +=      218 * sin( psi - om4 );
        upsilon +=    -1845 * sin( G);
        upsilon +=     -253 * sin( 2*G );
        upsilon +=       18 * sin( 2*(Gp - G) + phi4 );
        upsilon +=       19 * sin( 2*Gp - G + phi1 );
        upsilon +=      -15 * sin( 5*Gp - 3*G + phi1 );
        upsilon +=     -150 * sin( 5*G - 2*G + phi2 );
        upsilon +=      102 * sin( om3 - om4 );
        upsilon +=       56 * sin( om2 - om3 );
        upsilon +=       72 * sin( pi4 - PIj );
        upsilon +=     2259 * sin( pi3 - pi4 );
        upsilon +=      -24 * sin( pi3 - pi4 + om3 - om4 );
        upsilon +=      -23 * sin( pi2 - pi3 );
        upsilon +=      -36 * sin( pi2 - pi4 );
        upsilon +=      -31 * sin( pi1 - pi2 );
        upsilon +=        4 * sin( pi1 - pi3 );
        upsilon +=      111 * sin( pi1 - pi4 );
        upsilon +=     -354 * sin( pi1 + pi3 - PIG2 );
        upsilon +=    -3103 * sin( phi );
        upsilon +=       55 * sin( 2*l3 - PIG2 );
        upsilon +=     -111 * sin( 3*l3 - 7*l4 + 4*pi4 );
        upsilon +=       91 * sin( 3*l3 - 7*l4 + pi3 + 3*pi4 );
        upsilon +=      -25 * sin( 3*l3 - 7*l4 + 2*pi3 + 2*pi4 );
        upsilon +=    -1994 * sin( l2 - l3 );
        upsilon +=     -137 * sin( l2 - l4 );
        upsilon +=        1 * sin( l2 - pi1 );
        upsilon +=     2886 * sin( l2 - pi2 );
        upsilon +=     6250 * sin( l2 - pi3 );
        upsilon +=     3463 * sin( l2 - pi4 );
        upsilon +=       30 * sin( l2 - PIj - G );
        upsilon +=      -18 * sin( 2*l2 - 3*l3 + pi4 );
        upsilon +=      -39 * sin( 2*l2 - 3*l3 + pi3 );
        upsilon +=       98 * sin( 2*(l2 - l4) );
        upsilon +=     -164 * sin( 2*(l2 - om2) );
        upsilon +=      -18 * sin( 2*l2 - om2 - om3 );
        upsilon +=       72 * sin( 5*(l2 - l3) );
        upsilon +=       30 * sin( l1 - 2*l2 - pi3 + PIG2 );
        upsilon +=     4180 * sin( l1 - 2*l2 + pi4 );
        upsilon +=     7428 * sin( l1 - 2*l2 + pi3 );
        upsilon +=    -2329 * sin( l1 - 2*l2 + pi2 );
        upsilon +=      -19 * sin( l1 - 2*l2 + pi1 );
        upsilon +=  -185835 * sin( l1 - l2 );
        upsilon +=     -110 * sin( l1 - 2*l3 + pi4 );
        upsilon +=     -200 * sin( l1 - 2*l3 + pi3 );
        upsilon +=       39 * sin( l1 - 2*l3 + pi2 );
        upsilon +=      -16 * sin( l1 - 2*l3 + pi1 );
        upsilon +=     -803 * sin( l1 - l3 );
        upsilon +=      -19 * sin( l1 - pi2 );
        upsilon +=      -75 * sin( l1 - pi3 );
        upsilon +=      -31 * sin( l1 - pi4 );
        upsilon +=       -9 * sin( 2*l1 - 4*l2 + om3 + psi );
        upsilon +=        4 * sin( 2*l1 - 4*l2 + 2*om3 );
        upsilon +=      -14 * sin( 2*l1 - 4*l2 + om2 + om3 );
        upsilon +=      150 * sin( 2*l1 - 4*l2 + 2*om2 );
        upsilon +=      -11 * sin( 2*l1 - 4*l2 + PIG2 );
        upsilon +=       -9 * sin( 2*l1 - 4*l2 + pi3 + pi4 );
        upsilon +=       -8 * sin( 2*l1 - 4*l2 + 2*pi3 );
        upsilon +=      915 * sin( 2*(l1 - l2) );
        upsilon +=       96 * sin( 2*(l1 - l3) );
        upsilon +=      -18 * sin( 4*(l1 - l2) );
        upsilon *= 1e-7;

        // now use the "time completed" series
        n := 101.37472473479 * deg_to_rad;
        computeArguments(t + upsilon/n, l1, l2, l3, l4,
                         om1, om2, om3, om4, psi, Gp, G);

        zeta +=     17 * sin( l2 + psi - 2*(PIj - G) - G );
        zeta +=    143 * sin( l2 + psi - 2*(PIj - G) );
        zeta +=   -144 * sin( l2 - om1 );
        zeta +=  81004 * sin( l2 - om2 );
        zeta +=   4512 * sin( l2 - om3 );
        zeta +=   1160 * sin( l2 - om4 );
        zeta +=    -19 * sin( l2 - psi - G );
        zeta +=  -3284 * sin( l2 - psi );
        zeta +=     35 * sin( l2 - psi + G );
        zeta +=    -28 * sin( l1 - 2*l3 + om3 );
        zeta +=    272 * sin( l1 - 2*l3 + om2 );
        zeta *= 1e-7;
        result:=true;
      end;
    GANYMEDE: begin
        lon := l3;

        xi +=      24 * cos( psi - om3 );
        xi +=      -9 * cos( om3 - om4 );
        xi +=      10 * cos( pi3 - pi4 );
        xi +=     294 * cos( l3 - l4 );
        xi +=      18 * cos( l3 - pi2 );
        xi +=  -14388 * cos( l3 - pi3 );
        xi +=   -7919 * cos( l3 - pi4 );
        xi +=     -23 * cos( l3 - PIj - G );
        xi +=     -20 * cos( l3 + pi4 - PIG2 );
        xi +=     -51 * cos( l3 + pi3 - PIG2 );
        xi +=      39 * cos( 2*l3 - 3*l4 + pi4 );
        xi +=   -1761 * cos( 2*(l3 - l4) );
        xi +=     -11 * cos( 2*(l3 - pi3) );
        xi +=     -10 * cos( 2*(l3 - pi3 - pi4) );
        xi +=     -27 * cos( 2*l3 - PIG2 );
        xi +=      24 * cos( 2*(l3 - om3) );
        xi +=       9 * cos( 2 * l3 - om3 - om4 );
        xi +=     -24 * cos( 2 * l3 - om3 - psi );
        xi +=     -16 * cos( 3*l3 - 4*l4 + pi4 );
        xi +=    -156 * cos( 3*(l3 - l4) );
        xi +=     -42 * cos( 4*(l3 - l4) );
        xi +=     -11 * cos( 5*(l3 - l4) );
        xi +=    6342 * cos( l2 - l3 );
        xi +=       9 * cos( l2 - pi3 );
        xi +=      39 * cos( 2*l2 - 3*l3 + pi4 );
        xi +=      70 * cos( 2*l2 - 3*l3 + pi3 );
        xi +=      10 * cos( l1 - 2*l2 + pi4 );
        xi +=      20 * cos( l1 - 2*l2 + pi3 );
        xi +=    -153 * cos( l1 - l2 );
        xi +=     156 * cos( l1 - l3 );
        xi +=      11 * cos( 2*(l1 - l2) );
        xi *= 1e-7;

        radius := axis3 * (1 + xi);

        upsilon +=     10 * sin( psi - pi3 + pi4 - om3 );
        upsilon +=     28 * sin( 2*psi - PIG2 );
        upsilon +=  -1770 * sin( 2*(psi - PIj) );
        upsilon +=    -48 * sin( psi + om3 - PIG2 );
        upsilon +=     14 * sin( psi - om2 );
        upsilon +=    411 * sin( psi - om3 );
        upsilon +=    345 * sin( psi - om4 );
        upsilon +=  -2338 * sin( G );
        upsilon +=    -66 * sin( 2*G );
        upsilon +=     10 * sin( Gp - G + phi3 );
        upsilon +=     22 * sin( 2*(Gp - G) + phi4 );
        upsilon +=     26 * sin( 2*Gp - G + phi1 );
        upsilon +=     11 * sin( 3*Gp - 2*G + phi2 + phi3 );
        upsilon +=      9 * sin(  3*Gp - G + phi1 - phi2 );
        upsilon +=    -19 * sin( 5*Gp - 3*G + phi1 );
        upsilon +=   -208 * sin( 5*Gp - 2*G + phi2 );
        upsilon +=    159 * sin( om3 - om4 );
        upsilon +=     21 * sin( om2 - om3 );
        upsilon +=    121 * sin( pi4 - PIj );
        upsilon +=   6604 * sin( pi3 - pi4 );
        upsilon +=    -65 * sin( pi3 - pi4 + om3 - om4 );
        upsilon +=    -88 * sin( pi2 - pi3 );
        upsilon +=    -72 * sin( pi2 - pi4 );
        upsilon +=    -26 * sin( pi1 - pi3 );
        upsilon +=     -9 * sin( pi1 - pi4 );
        upsilon +=     16 * sin( pi1 + pi4 - PIG2 );
        upsilon +=    125 * sin( pi1 + pi3 - PIG2 );
        upsilon +=    307 * sin( phi );
        upsilon +=    -10 * sin( l4 - pi4 );
        upsilon +=   -100 * sin( l3 - 2*l4 + pi4 );
        upsilon +=     83 * sin( l3 - 2*l4 + pi3 );
        upsilon +=   -944 * sin( l3 - l4 );
        upsilon +=    -37 * sin( l3 - pi2 );
        upsilon +=  28780 * sin( l3 - pi3 );
        upsilon +=  15849 * sin( l3 - pi4 );
        upsilon +=      7 * sin( l3 - pi4 + om3 - om4 );
        upsilon +=     46 * sin( l3 - PIj - G );
        upsilon +=     51 * sin( l3 + pi4 - PIG2 );
        upsilon +=     11 * sin( l3 + pi3 - PIG2 - G );
        upsilon +=     97 * sin( l3 + pi3 - PIG2 );
        upsilon +=      1 * sin( l3 + pi1 - PIG2 );
        upsilon +=   -101 * sin( 2*l3 - 3*l4 + pi4 );
        upsilon +=     13 * sin( 2*l3 - 3*l4 + pi3 );
        upsilon +=   3222 * sin( 2*(l3 - l4) );
        upsilon +=     29 * sin( 2*(l3 - pi3) );
        upsilon +=     25 * sin( 2*l3 - pi3 - pi4 );
        upsilon +=     37 * sin( 2*l3 - PIG2 );
        upsilon +=    -24 * sin( 2*(l3 - om3) );
        upsilon +=     -9 * sin( 2*l3 - om3 - om4 );
        upsilon +=     24 * sin( 2*l3 - om3 - psi );
        upsilon +=   -174 * sin( 3*l3 - 7*l4 + 4*pi4 );
        upsilon +=    140 * sin( 3*l3 - 7*l4 + pi3 + 3*pi4 );
        upsilon +=    -55 * sin( 3*l3 - 7*l4 + 2*pi3 + 2*pi4 );
        upsilon +=     27 * sin( 3*l3 - 4*l4 + pi4 );
        upsilon +=    227 * sin( 3*(l3 - l4) );
        upsilon +=     53 * sin( 4*(l3 - l4) );
        upsilon +=     13 * sin( 5*(l3 - l4) );
        upsilon +=     42 * sin( l2 - 3*l3 + 2*l4 );
        upsilon += -12055 * sin( l2 - l3 );
        upsilon +=    -24 * sin( l2 - pi3 );
        upsilon +=    -10 * sin( l2 - pi4 );
        upsilon +=    -79 * sin( 2*l2 - 3*l3 + pi4 );
        upsilon +=   -131 * sin( 2*l2 - 3*l3 + pi3 );
        upsilon +=   -665 * sin( l1 - 2*l2 + pi4 ); 
        upsilon +=  -1228 * sin( l1 - 2*l2 + pi3 ); 
        upsilon +=   1082 * sin( l1 - 2*l2 + pi2 ); 
        upsilon +=     90 * sin( l1 - 2*l2 + pi1 ); 
        upsilon +=    190 * sin( l1 - l2 );
        upsilon +=    218 * sin( l1 - l3 );
        upsilon +=      2 * sin( 2*l1 - 4*l2 + om3 + psi );
        upsilon +=     -4 * sin( 2*l1 - 4*l2 + 2*om3 );
        upsilon +=      3 * sin( 2*l1 - 4*l2 + 2*om2 );
        upsilon +=      2 * sin( 2*l1 - 4*l2 + pi3 + pi4 );
        upsilon +=      2 * sin( 2*l1 - 4*l2 + 2*pi3 );
        upsilon +=    -13 * sin( 2*(l1 - l2) );
        upsilon *= 1e-7;

        // now use the "time completed" series
        n := 50.31760920702 * deg_to_rad;
        computeArguments(t + upsilon/n, l1, l2, l3, l4, 
                         om1, om2, om3, om4, psi, Gp, G);

        zeta +=     37 * sin( l2 + psi - 2*(PIj - G) - G );
        zeta +=    321 * sin( l2 + psi - 2*(PIj - G) );
        zeta +=    -15 * sin( l2 + psi - 2*PIj - G );
        zeta +=    -45 * sin( l3 - 2*PIj + psi );
        zeta +=  -2797 * sin( l3 - om2 );
        zeta +=  32402 * sin( l3 - om3 );
        zeta +=   6847 * sin( l3 - om4 );
        zeta +=    -45 * sin( l3 - psi - G );
        zeta += -16911 * sin( l3 - psi );
        zeta +=     51 * sin( l3 - psi + G );
        zeta +=     10 * sin( 2*l2 - 3*l3 + psi );
        zeta +=    -21 * sin( 2*l2 - 3*l3 + om3 );
        zeta +=     30 * sin( 2*l2 - 3*l3 + om2 );
        zeta *= 1e-7;

        result:=true;
    end;

    CALLISTO: begin
        lon := l4;

        xi +=    -19 * cos( psi - om3 );
        xi +=    167 * cos( psi - om4 );
        xi +=     11 * cos( G );
        xi +=     12 * cos( om3 - om4 );
        xi +=    -13 * cos( pi3 - pi4 );
        xi +=   1621 * cos( l4 - pi3 );
        xi +=    -24 * cos( l4 - pi4 + 2*(psi - PIj) );
        xi +=    -17 * cos( l4 - pi4 - G );
        xi += -73546 * cos( l4 - pi4 );
        xi +=     15 * cos( l4 - pi4 + G );
        xi +=     30 * cos( l4 - pi4 + 2*(PIj - psi) );
        xi +=     -5 * cos( l4 - PIj + 2*G );
        xi +=    -89 * cos( l4 - PIj - G );
        xi +=    182 * cos( l4 - PIj );
        xi +=     -6 * cos( l4 + pi4 - 2*PIj - 4*G );
        xi +=    -62 * cos( l4 + pi4 - 2*PIj - 3*G );
        xi +=   -543 * cos( l4 + pi4 - 2*PIj - 2*G );
        xi +=     27 * cos( l4 + pi4 - 2*PIj - G );
        xi +=      6 * cos( l4 + pi4 - 2*PIj );
        xi +=      6 * cos( l4 + pi4 - om4 - psi );
        xi +=     -9 * cos( l4 + pi3 - 2*pi4 );
        xi +=     14 * cos( l4 + pi3 - PIG2 );
        xi +=     13 * cos( 2*l4 - pi3 - pi4 );
        xi +=   -271 * cos( 2*(l4 - pi4) );
        xi +=    -25 * cos( 2*l4 - PIG2 - G );
        xi +=   -155 * cos( 2*l4 - PIG2 );
        xi +=    -12 * cos( 2*l4 - om3 - om4 );
        xi +=     19 * cos( 2*l4 - om3 - psi );
        xi +=     48 * cos( 2*(l4 - om4) );
        xi +=   -167 * cos( 2*l4 - om4 - psi );
        xi +=    142 * cos( 2*(l4 - psi) );
        xi +=    -22 * cos( l3 - 2*l4 + pi4 );
        xi +=     20 * cos( l3 - 2*l4 + pi3 );
        xi +=    974 * cos( l3 - l4 );
        xi +=     24 * cos( 2*l3 - 3*l4 + pi4 );
        xi +=    177 * cos( 2*(l3 - l4) );
        xi +=      4 * cos( 3*l3 - 4*l4 + pi4 );
        xi +=     42 * cos( 3*(l3 - l4) );
        xi +=     14 * cos( 4*(l3 - l4) );
        xi +=      5 * cos( 5*(l3 - l4) );
        xi +=     -8 * cos( l2 - 3*l3 + 2*l4 );
        xi +=     92 * cos( l2 - l4 );
        xi +=    105 * cos( l1 - l4 );
        xi *= 1e-7;

        radius := axis4 * (1 + xi);

        upsilon +=      8 * sin( 2*psi - pi3 - pi4 );
        upsilon +=     -9 * sin( psi - pi3 - pi4 + om4 );
        upsilon +=     27 * sin( psi - pi3 + pi4 - om4 );
        upsilon +=   -409 * sin( 2*(psi - pi4) );
        upsilon +=    310 * sin( psi - 2*pi4 + om4 );
        upsilon +=    -19 * sin( psi - 2*pi4 + om3 );
        upsilon +=      8 * sin( 2*psi - pi4 - PIj );
        upsilon +=     -5 * sin( psi - pi4 - PIj + om4 );
        upsilon +=     63 * sin( psi - pi4 + PIj - om4 );
        upsilon +=      8 * sin( 2*psi - PIG2 - G );
        upsilon +=     73 * sin( 2*psi - PIG2 );
        upsilon +=  -5768 * sin( 2*(psi - PIj) );
        upsilon +=     16 * sin( psi + om4 - PIG2 );
        upsilon +=    -97 * sin( psi - om3 );
        upsilon +=    152 * sin( 2*(psi - om4) );
        upsilon +=   2070 * sin( psi - om4 );
        upsilon +=  -5604 * sin( G );
        upsilon +=   -204 * sin( 2*G );
        upsilon +=    -10 * sin( 3*G );
        upsilon +=     24 * sin( Gp - G + phi3 );
        upsilon +=     11 * sin( Gp + phi1 - 2*phi2 );
        upsilon +=     52 * sin( 2*(Gp - G) + phi4 );
        upsilon +=     61 * sin( 2*Gp - G + phi1 );
        upsilon +=     25 * sin( 3*Gp - 2*G + phi2 + phi3 );
        upsilon +=     21 * sin( 3*Gp - G + phi1 - phi2 );
        upsilon +=    -45 * sin( 5*Gp - 3*G + phi1 );
        upsilon +=   -495 * sin( 5*Gp - 3*G + phi2 );
        upsilon +=    -44 * sin( om3 - om4 );
        upsilon +=      5 * sin( pi4 - PIj - G );
        upsilon +=    234 * sin( pi4 - PIj );
        upsilon +=     11 * sin( 2*pi4 - PIG2 );
        upsilon +=    -10 * sin( 2*pi4 - om3 - om4 );
        upsilon +=     68 * sin( 2*(pi4 - om4) );
        upsilon +=    -13 * sin( pi3 - pi4 - om4 + psi );
        upsilon +=  -5988 * sin( pi3 - pi4 );
        upsilon +=    -47 * sin( pi3 - pi4 + om3 - om4 );
        upsilon +=  -3249 * sin( l4 - pi3 );
        upsilon +=     48 * sin( l4 - pi4 + 2*(psi - PIj) );
        upsilon +=     10 * sin( l4 - pi4 - om4 + psi );
        upsilon +=     33 * sin( l4 - pi4 - G );
        upsilon += 147108 * sin( l4 - pi4 );
        upsilon +=    -31 * sin( l4 - pi4 + G );
        upsilon +=     -6 * sin( l4 - pi4 + om4 - psi );
        upsilon +=    -61 * sin( l4 - pi4 + 2*(PIj - psi) );
        upsilon +=     10 * sin( l4 - PIj - 2*G );
        upsilon +=    178 * sin( l4 - PIj - G );
        upsilon +=   -363 * sin( l4 - PIj );
        upsilon +=      5 * sin( l4 + pi4 - 2*PIj - 5*Gp + 2*G - phi1 );
        upsilon +=     12 * sin( l4 + pi4 - 2*PIj - 4*G );
        upsilon +=    124 * sin( l4 + pi4 - 2*PIj - 3*G );
        upsilon +=   1088 * sin( l4 + pi4 - 2*PIj - 2*G );
        upsilon +=    -55 * sin( l4 + pi4 - 2*PIj - G );
        upsilon +=    -12 * sin( l4 + pi4 - 2*PIj );
        upsilon +=    -13 * sin( l4 + pi4 - om4 - psi );
        upsilon +=      6 * sin( l4 + pi4 - 2*psi );
        upsilon +=     17 * sin( l4 + pi3 - 2*pi4 );
        upsilon +=    -28 * sin( l4 + pi3 - PIG2 );
        upsilon +=    -33 * sin( 2*l4 - pi3 - pi4 );
        upsilon +=    676 * sin( 2*(l4 - pi4) );
        upsilon +=     36 * sin( 2*(l4 - PIj - G) - G );
        upsilon +=    218 * sin( 2*(l4 - PIj - G) );
        upsilon +=     -5 * sin( 2*(l4 - PIj) - G );
        upsilon +=     12 * sin( 2*l4 - om3 - om4 );
        upsilon +=    -19 * sin( 2*l4 - om3 - psi );
        upsilon +=    -48 * sin( 2*(l4 - om4) );
        upsilon +=    167 * sin( 2*l4 - om4 - psi );
        upsilon +=   -142 * sin( 2*(l4 - psi) );
        upsilon +=    148 * sin( l3 - 2*l4 + pi4 );
        upsilon +=    -94 * sin( l3 - 2*l4 + pi3 );
        upsilon +=   -390 * sin( l3 - l4 );
        upsilon +=      9 * sin( 2*l3 - 4*l4 + 2*pi4 );
        upsilon +=    -37 * sin( 2*l3 - 3*l4 + pi4 );
        upsilon +=      6 * sin( 2*l3 - 3*l4 + pi3 );
        upsilon +=   -195 * sin( 2*(l3 - l4) );
        upsilon +=      6 * sin( 3*l3 - 7*l4 + 2*pi4 + om4 + psi );
        upsilon +=    187 * sin( 3*l3 - 7*l4 + 4*pi4 );
        upsilon +=   -149 * sin( 3*l3 - 7*l4 + pi3 + 3*pi4 );
        upsilon +=     51 * sin( 3*l3 - 7*l4 + 2*(pi3 + pi4) );
        upsilon +=    -10 * sin( 3*l3 - 7*l4 + 3*pi3 + pi4 );
        upsilon +=      6 * sin( 3*(l3 - 2*l4 + pi4) );
        upsilon +=     -8 * sin( 3*l3 - 4*l4 + pi4 );
        upsilon +=    -41 * sin( 3*(l3 - l4) );
        upsilon +=    -13 * sin( 4*(l3 - l4) );
        upsilon +=    -44 * sin( l2 - 3*l3 + 2*l4 );
        upsilon +=     89 * sin( l2 - l4 );
        upsilon +=    106 * sin( l1 - l4 );
        upsilon *= 1e-7;

        // now use the "time completed" series
        n := 21.57107117668 * deg_to_rad;
        computeArguments(t + upsilon/n, l1, l2, l3, l4,
                         om1, om2, om3, om4, psi, Gp, G);

        zeta +=      8 * sin( l4 - 2*PIj - om4 - 2*psi );
        zeta +=      8 * sin( l4 - 2*PIj + psi - 4*G );
        zeta +=     88 * sin( l4 - 2*PIj + psi - 3*G );
        zeta +=    773 * sin( l4 - 2*PIj + psi - 2*G );
        zeta +=    -38 * sin( l4 - 2*PIj + psi - G );
        zeta +=      5 * sin( l4 - 2*PIj + psi );
        zeta +=      9 * sin( l4 - om1 );
        zeta +=    -17 * sin( l4 - om2 );
        zeta +=  -5112 * sin( l4 - om3 );
        zeta +=     -7 * sin( l4 - om4 - G );
        zeta +=  44134 * sin( l4 - om4 );
        zeta +=      7 * sin( l4 - om4 + G );
        zeta +=   -102 * sin( l4 - psi - G );
        zeta += -76579 * sin( l4 - psi );
        zeta +=    104 * sin(  l4 - psi + G );
        zeta +=    -10 * sin( l4 - psi + 5*Gp - 2*G + phi2 );
        zeta +=    -11 * sin( l3 - 2*l4 + psi );
        zeta +=      7 * sin( l3 - 2*l4 + om4 );
        zeta *= 1e-7;

     result:=true;
    end;
    else begin
         result:=false;
         radius:=0;lon:=0;psi:=0;upsilon:=0;zeta:=0;
         end;
    end; // case b
    if result then begin
      // Jupiter equatorial coordinates
      X := radius * cos(lon - psi + upsilon);
      Y := radius * sin(lon - psi + upsilon);
      Z := radius * zeta;

      // rotate to Jupiter's orbital plane
      I := 3.10401 * deg_to_rad;
      rotateX(X, Y, Z, -I);

      // rotate towards ascending node of Jupiter's equator on its
      // orbital plane
      OM := 99.95326 * deg_to_rad;
      rotateZ(X, Y, Z, OM - psi);

      // rotate to ecliptic
      J := 1.30691 * deg_to_rad;
      rotateX(X, Y, Z, -J);

      // rotate towards ascending node of Jupiter's orbit on ecliptic
      rotateZ(X, Y, Z, -OM);

      // rotate to earth equator B1950
      eps := 23.4457889 * deg_to_rad;
      rotateX(X, Y, Z, -eps);

      // precess to J2000
      precessB1950J2000(X, Y, Z);
    end;
end;






procedure SatcalcLon(jd: double; var lon: array of double);
var t: double;
    ii,i: integer;
begin
    t := (jd - 2444240)/365.25;

    for ii := 0 to 6 do begin
        lon[ii] := 0;
        for i := 0 to ntr[ii,4]-1 do
            lon[ii] += series[ii][1][i][0] * sin(series[ii][1][i][1] + t * series[ii][1][i][2]);
    end;
end;

procedure SatcalcElem(jd: double; ii: integer; lon: array of double; var elem: array of double);
var t,s,phase,s1,s2: double;
    i,j: integer;
begin

    t := (jd - 2444240)/365.25;

    s := 0;

    for i := 0 to ntr[ii][0]-1 do begin
        phase := series[ii][0][i][1];
        for j := 0 to 6 do
            phase += iks[ii][0][i][j] * lon[j];
        s += series[ii][0][i][0] * cos(phase + t*series[ii][0][i][2]);
    end;

    elem[0] := s;

    s := lon[ii] + al0[ii];
    for i := ntr[ii][4] to ntr[ii][1]-1 do begin
        phase := series[ii][1][i][1];
        for j := 0 to 6 do
            phase += iks[ii][1][i][j] * lon[j];
        s += series[ii][1][i][0] * sin(phase + t*series[ii][1][i][2]);
    end;
    s += an0[ii]*t;
    elem[1] := arctan2(sin(s), cos(s));

    s1 := 0;
    s2 := 0;
    for i := 0 to ntr[ii][2]-1 do begin
        phase := series[ii][2][i][1];
        for j := 0 to 6 do
            phase += iks[ii][2][i][j] * lon[j];
        s1 += series[ii][2][i][0] * cos(phase + t*series[ii][2][i][2]);
        s2 += series[ii][2][i][0] * sin(phase + t*series[ii][2][i][2]);
    end;
    elem[2] := s1;
    elem[3] := s2;

    s1 := 0;
    s2 := 0;
    for i := 0 to ntr[ii][3]-1 do begin
        phase := series[ii][3][i][1];
        for j := 0 to 6 do
            phase += iks[ii][3][i][j] * lon[j];
        s1 += series[ii][3][i][0] * cos(phase + t*series[ii][3][i][2]);
        s2 += series[ii][3][i][0] * sin(phase + t*series[ii][3][i][2]);
    end;
    elem[4] := s1;
    elem[5] := s2;
end;

procedure SatelemHyperion(jd: double; var elem: array of double);
var T0,AMM7,T,wt : double;
    i: integer;
begin
    T0 := 2451545.0;
    AMM7 := 0.2953088138695055;

    T := jd - T0;

    elem[0] := -0.1574686065780747e-02;
    for i := 0 to NBTP-1 do begin
        wt := T*P[i][2] + P[i][1];
        elem[0] += P[i][0] * cos(wt);
    end;

    elem[1] := 0.4348683610500939e+01;
    for i := 0 to NBTQ-1 do begin
        wt := T*Q[i][2] + Q[i][1];
        elem[1] += Q[i][0] * sin(wt);
    end;

    elem[1] += AMM7*T;
    elem[1] := rmod(elem[1], 2*PI);
    if (elem[1] < 0) then elem[1] += 2*PI;

    for i := 0 to NBTZ-1 do begin
        wt := T*Z[i][2] + Z[i][1];
        elem[2] += Z[i][0] * cos(wt);
        elem[3] += Z[i][0] * sin(wt);
    end;

    for i := 0 to NBTZT-1 do begin
        wt := T*ZT[i][2] + ZT[i][1];
        elem[4] += ZT[i][0] * cos(wt);
        elem[5] += ZT[i][0] * sin(wt);
    end;

end;

function satsat(jd:double; b:Tbody; var X,Y,Z: double):boolean;
{
  The TASS theory of motion by Vienne and Duriez is described in
  (1995, A&A 297, 588-605) for the inner six satellites and Iapetus
  and in (1997, A&A 324, 366-380) for Hyperion.  Much of this code is
  translated from the TASS17 FORTRAN code which is at
  ftp://ftp.bdl.fr/pub/ephem/satel/tass17

  Orbital elements for Phoebe are from the Explanatory Supplement and
  originally come from Zadunaisky (1954).
}
var elem: array [0..5] of double = ( 0, 0, 0, 0, 0, 0 );
    lon: array [0..6] of double;
    aam: double;   // mean motion, in radians per day
    tmas: double;  // mass, in Saturn masses
    t,TT,axis,lambda,e,lp,i,omega : double;
    M,EE,eps : double;
    GK,TAS,GK1,amo,rmu,dga,rl,rk,rh,corf,fle,cf,sf: double;
    dlf,phi,psi,x1,y1,dwho,rtp,rtq,rdg,XX1,YY1,ZZ1: double;
    //rsam1,asr,vx1,vy1: double;
    AIA,OMA,ci,si,co,so: double;
    index: integer;
begin
    aam:=0;tmas:=0;
    if (b = PHOEBE) then begin
        t := jd - 2433282.5;
        TT := t/365.25;

        axis := 0.0865752;
        lambda := (277.872 - 0.6541068 * t) * deg_to_rad;
        e := 0.16326;
        lp := (280.165 - 0.19586 * TT) * deg_to_rad;
        i := (173.949 - 0.020 * TT) * deg_to_rad - PI;  // retrograde orbit
        omega := (245.998 - 0.41353 * TT) * deg_to_rad;

        M := lambda - lp;
        EE := kepler(e, M);

        // rectangular coordinates on the orbit plane, x-axis is toward
        // pericenter
        X := axis * (cos(EE) - e);
        Y := axis * sqrt(1 - e*e) * sin(EE);
        Z := 0;

        // rotate towards ascending node of the orbit on the ecliptic
        // and equinox of 1950
        rotateZ(X, Y, Z, -(lp - omega));

        // rotate towards ecliptic
        rotateX(X, Y, Z, -i);

        // rotate to vernal equinox
        rotateZ(X, Y, Z, -omega);

        // rotate to earth equator B1950
        eps := 23.4457889 * deg_to_rad;
        rotateX(X, Y, Z, -eps);

        // precess to J2000
        precessB1950J2000(X, Y, Z);
        result:=true;
    end
    else if (b = HYPERION) then begin
        SatelemHyperion(jd, elem);
        aam := 0.2953088138695000E+00 * 365.25;
        tmas := 1/0.3333333333333000E+08;
        result:=true;
    end
    else begin
        index := 0;
        result:=true;
        case b of
         MIMAS:       index := 0;
         ENCELADUS:   index := 1;
         TETHYS:      index := 2;
         DIONE:       index := 3;
         RHEA:        index := 4;
         TITAN:       index := 5;
         IAPETUS:     index := 6;
        else
            result:=false;
        end;

        SatcalcLon(jd, lon);
        SatcalcElem(jd, index, lon, elem);

        aam := am[index] * 365.25;
        tmas := 1/tam[index];
    end;

    if (b <> PHOEBE) then begin
        GK := 0.01720209895;
        TAS := 3498.790;
        GK1 := (GK * 365.25) * (GK * 365.25) / TAS;

        amo := aam * (1 + elem[0]);
        rmu := GK1 * (1 + tmas);
        dga := power(rmu/(amo*amo), 1.0/3.0);
        rl := elem[1];
        rk := elem[2];
        rh := elem[3];

        corf := 1;
        fle := rl - rk * sin(rl) + rh * cos(rl);
        while (abs(corf) > 1e-14) do begin
            cf := cos(fle);
            sf := sin(fle);
            corf := (rl - fle + rk*sf - rh*cf)/(1 - rk*cf - rh*sf);
            fle += corf;
        end;

        cf := cos(fle);
        sf := sin(fle);

        dlf := -rk * sf + rh * cf;
        //rsam1 := -rk * cf - rh * sf;
        //asr := 1/(1 + rsam1);
        phi := sqrt(1 - rk*rk - rh*rh);
        psi := 1/(1+phi);

        x1 := dga * (cf - rk - psi * rh * dlf);
        y1 := dga * (sf - rh + psi * rk * dlf);
        //vx1 := amo * asr * dga * (-sf - psi * rh * rsam1);
        //vy1 := amo * asr * dga * ( cf + psi * rk * rsam1);

        dwho := 2 * sqrt(1 - elem[5] * elem[5] - elem[4] * elem[4]);
        rtp := 1 - 2 * elem[5] * elem[5];
        rtq := 1 - 2 * elem[4] * elem[4];
        rdg := 2 * elem[5] * elem[4];

        XX1 := x1 * rtp + y1 * rdg;
        YY1 := x1 * rdg + y1 * rtq;
        ZZ1 := (-x1 * elem[5] + y1 * elem[4]) * dwho;

        AIA := 28.0512 * deg_to_rad;
        OMA := 169.5291 * deg_to_rad;

        ci := cos(AIA);
        si := sin(AIA);
        co := cos(OMA);
        so := sin(OMA);

        X := co * XX1 - so * ci * YY1 + so * si * ZZ1;
        Y := so * XX1 + co * ci * YY1 - co * si * ZZ1;
        Z := si * YY1 + ci * ZZ1;

        // rotate to earth equator J2000
        eps := 23.4392911 * deg_to_rad;
        rotateX(X, Y, Z, -eps);

    end;
end;


procedure UracalcRectangular(N,L,K,H,Q,P,GMS: double; var X,Y,Z: double);
var A,PHI,PSI,RKI,F,SF,CF,RLMF: double;
    rot: array[0..2,0..1] of double;
    TX : array [0..1] of double;
begin
    // Calculate the semi-major axis
    A := power(GMS/(N*N), 1.0/3.0) / AU_to_km;

    PHI := sqrt(1 - K*K - H*H);
    PSI := 1/(1+PHI);

    RKI := sqrt(1 - Q*Q - P*P);

    F := solveKepler(L, K, H);

    SF := sin(F);
    CF := cos(F);

    RLMF := -K*SF + H*CF;

    rot[0][0] := 1 - 2*P*P;
    rot[0][1] := 2*P*Q;
    rot[1][0] := 2*P*Q;
    rot[1][1] := 1 - 2*Q*Q;
    rot[2][0] := -2*P*RKI;
    rot[2][1] := 2*Q*RKI;

    TX[0] := A*(CF - PSI * H * RLMF - K);
    TX[1] := A*(SF + PSI * K * RLMF - H);

    X := rot[0][0] * TX[0] + rot[0][1] * TX[1];
    Y := rot[1][0] * TX[0] + rot[1][1] * TX[1];
    Z := rot[2][0] * TX[0] + rot[2][1] * TX[1];
end;

procedure UranicentricToGeocentricEquatorial(var X,Y,Z : double);
// convert UME50* coordinates to EME50
var alpha0,delta0,sa,sd,ca,cd,oldX,oldY,oldZ: double;
begin
    alpha0 := 76.6067 * deg_to_rad;
    delta0 := 15.0322 * deg_to_rad;

    sa := sin(alpha0);
    sd := sin(delta0);
    ca := cos(alpha0);
    cd := cos(delta0);

    oldX := X;
    oldY := Y;
    oldZ := Z;

    X :=  sa * oldX + ca * sd * oldY + ca * cd * oldZ;
    Y := -ca * oldX + sa * sd * oldY + sa * cd * oldZ;
    Z := -cd * oldY + sd * oldZ;
end;

function urasat(jd:double; b:Tbody; var X,Y,Z: double):boolean;
{
  GUST86 ephemeris is described in Laskar & Jacobson,
  Astron. Astrophys. 188, 212-224 (1987)

  Much of this code is translated from the GUST86 FORTRAN code which
  is at ftp://ftp.bdl.fr/pub/ephem/satel/gust86
}
var t,tcen,N1,N2,N3,N4,N5,E1,E2,E3,E4,E5: double;
    I1,I2,I3,I4,I5,GM1,GM2,GM3,GM4,GM5,GMU,N,L,K,H,Q,P,GMS: double;
begin
    t := jd - 2444239.5;
    tcen := t/365.25;

    N1 := rmod(4.445190550 * t - 0.238051, TWO_PI);
    N2 := rmod(2.492952519 * t + 3.098046, TWO_PI);
    N3 := rmod(1.516148111 * t + 2.285402, TWO_PI);
    N4 := rmod(0.721718509 * t + 0.856359, TWO_PI);
    N5 := rmod(0.466692120 * t - 0.915592, TWO_PI);

    E1 := (20.082 * deg_to_rad * tcen + 0.611392);
    E2 := ( 6.217 * deg_to_rad * tcen + 2.408974);
    E3 := ( 2.865 * deg_to_rad * tcen + 2.067774);
    E4 := ( 2.078 * deg_to_rad * tcen + 0.735131);
    E5 := ( 0.386 * deg_to_rad * tcen + 0.426767);

    I1 := (-20.309 * deg_to_rad * tcen + 5.702313);
    I2 := ( -6.288 * deg_to_rad * tcen + 0.395757);
    I3 := ( -2.836 * deg_to_rad * tcen + 0.589326);
    I4 := ( -1.843 * deg_to_rad * tcen + 1.746237);
    I5 := ( -0.259 * deg_to_rad * tcen + 4.206896);

    GM1 := 4.4;
    GM2 := 86.1;
    GM3 := 84.0;
    GM4 := 230.0;
    GM5 := 200.0;
    GMU := 5794554.5 - (GM1 + GM2 + GM3 + GM4 + GM5);

    N := 0; L := 0; K := 0; H := 0; Q := 0; P := 0; GMS := 0;

    case b of
    MIRANDA: begin
        N := (4443522.67
             - 34.92 * cos(N1 - 3*N2 + 2*N3)
             +  8.47 * cos(2*N1 - 6*N2 + 4*N3)
             +  1.31 * cos(3*N1 - 9*N2 + 6*N3)
             - 52.28 * cos(N1 - N2)
             -136.65 * cos(2*N1 - 2*N2)) * 1e-6;

        L := (-238051.58
             + 4445190.55 * t
             + 25472.17 * sin(N1 - 3*N2 + 2*N3)
             -  3088.31 * sin(2*N1 - 6*N2 + 4*N3)
             -   318.10 * sin(3*N1 - 9*N2 + 6*N3)
             -    37.49 * sin(4*N1 - 12*N2 + 8*N3)
             -    57.85 * sin(N1 - N2)
             -    62.32 * sin(2*N1 - 2*N2)
             -    27.95 * sin(3*N1 - 3*N2)) * 1e-6;

        K := (1312.38 * cos(E1)
             + 71.81 * cos(E2)
             + 69.77 * cos(E3)
             +  6.75 * cos(E4)
             +  6.27 * cos(E5)
             - 123.31 * cos(-N1 + 2*N2)
             +  39.52 * cos(-2*N1 + 3*N2)
             + 194.10 * cos(N1)) * 1e-6;

        H := (1312.38 * sin(E1)
             + 71.81 * sin(E2)
             + 69.77 * sin(E3)
             +  6.75 * sin(E4)
             +  6.27 * sin(E5)
             - 123.31 * sin(-N1 + 2*N2)
             +  39.52 * sin(-2*N1 + 3*N2)
             + 194.10 * sin(N1)) * 1e-6;

        Q := (37871.71 * cos(I1)
             +  27.01 * cos(I2)
             +  30.76 * cos(I3)
             +  12.18 * cos(I4)
             +   5.37 * cos(I5)) * 1e-6;

        P := (37871.71 * sin(I1)
             +  27.01 * sin(I2)
             +  30.76 * sin(I3)
             +  12.18 * sin(I4)
             +   5.37 * sin(I5)) * 1e-6;

        GMS := GMU + GM1;
        result:=true;
    end;
    ARIEL: begin
        N := (2492542.57
             +   2.55 * cos(N1 - 3*N2 + 2*N3)
             -  42.16 * cos(N2 - N3)
             - 102.56 * cos(2*N2 - 2*N3)) * 1e-6;

        L := (3098046.41
             + 2492952.52 * t
             - 1860.50 * sin(N1 - 3*N2 + 2*N3)
             +  219.99 * sin(2*N1 - 6*N2 + 4*N3)
             +   23.10 * sin(3*N1 - 9*N2 + 6*N3)
             +    4.30 * sin(4*N1 - 12*N2 + 8*N3)
             -   90.11 * sin(N2 - N3)
             -   91.07 * sin(2*(N2 - N3))
             -   42.75 * sin(3*(N2 - N3))
             -   16.49 * sin(2*(N2 - N4))) * 1e-6;

        K := (-    3.35 * cos(E1)
             + 1187.63 * cos(E2)
             +  861.59 * cos(E3)
             +   71.50 * cos(E4)
             +   55.59 * cos(E5)
             -   84.60 * cos(-N2 + 2*N3)
             +   91.81 * cos(-2*N2 + 3*N3)
             +   20.03 * cos(-N2 + 2*N4)
             +   89.77 * cos(N2)) * 1e-6;

        H := (-    3.35 * sin(E1)
             + 1187.63 * sin(E2)
             +  861.59 * sin(E3)
             +   71.50 * sin(E4)
             +   55.59 * sin(E5)
             -   84.60 * sin(-N2 + 2*N3)
             +   91.81 * sin(-2*N2 + 3*N3)
             +   20.03 * sin(-N2 + 2*N4)
             +   89.77 * sin(N2)) * 1e-6;

        Q := (- 121.75 * cos(I1)
             + 358.25 * cos(I2)
             + 290.08 * cos(I3)
             +  97.78 * cos(I4)
             +  33.97 * cos(I5)) * 1e-6;

        P := (- 121.75 * sin(I1)
             + 358.25 * sin(I2)
             + 290.08 * sin(I3)
             +  97.78 * sin(I4)
             +  33.97 * sin(I5)) * 1e-6;

        GMS := GMU + GM2;
        result:=true;
    end;
    UMBRIEL: begin
        N := (1515954.90
             +   9.74 * cos(N3 - 2*N4 + E3)
             - 106.00 * cos(N2 - N3)
             +  54.16 * cos(2*(N2 - N3))
             -  23.59 * cos(N3 - N4)
             -  70.70 * cos(2*(N3 - N4))
             -  36.28 * cos(3*(N3 - N4))) * 1e-6;

        L := (2285401.69
             + 1516148.11 * t
             + 660.57 * sin(  N1 - 3*N2 + 2*N3)
             -  76.51 * sin(2*N1 - 6*N2 + 4*N3)
             -   8.96 * sin(3*N1 - 9*N2 + 6*N3)
             -   2.53 * sin(4*N1 - 12*N2 + 8*N3)
             -  52.91 * sin(N3 - 4*N4 + 3*N5)
             -   7.34 * sin(N3 - 2*N4 + E5)
             -   1.83 * sin(N3 - 2*N4 + E4)
             + 147.91 * sin(N3 - 2*N4 + E3)
             -   7.77 * sin(N3 - 2*N4 + E2)
             +  97.76 * sin(N2 - N3)
             +  73.13 * sin(2*(N2 - N3))
             +  34.71 * sin(3*(N2 - N3))
             +  18.89 * sin(4*(N2 - N3))
             -  67.89 * sin(N3 - N4)
             -  82.86 * sin(2*(N3 - N4))
             -  33.81 * sin(3*(N3 - N4))
             -  15.79 * sin(4*(N3 - N4))
             -  10.21 * sin(N3 - N5)
             -  17.08 * sin(2*(N3 - N5))) * 1e-6;

        K := (-    0.21 * cos(E1)
             -  227.95 * cos(E2)
             + 3904.69 * cos(E3)
             +  309.17 * cos(E4)
             +  221.92 * cos(E5)
             +   29.34 * cos(N2)
             +   26.20 * cos(N3)
             +   51.19 * cos(-N2+2*N3)
             -  103.86 * cos(-2*N2+3*N3)
             -   27.16 * cos(-3*N2+4*N3)
             -   16.22 * cos(N4)
             +  549.23 * cos(-N3 + 2*N4)
             +   34.70 * cos(-2*N3 + 3*N4)
             +   12.81 * cos(-3*N3 + 4*N4)
             +   21.81 * cos(-N3 + 2*N5)
             +   46.25 * cos(N3)) * 1e-6;

        H := (-    0.21 * sin(E1)
             -  227.95 * sin(E2)
             + 3904.69 * sin(E3)
             +  309.17 * sin(E4)
             +  221.92 * sin(E5)
             +   29.34 * sin(N2)
             +   26.20 * sin(N3)
             +   51.19 * sin(-N2+2*N3)
             -  103.86 * sin(-2*N2+3*N3)
             -   27.16 * sin(-3*N2+4*N3)
             -   16.22 * sin(N4)
             +  549.23 * sin(-N3 + 2*N4)
             +   34.70 * sin(-2*N3 + 3*N4)
             +   12.81 * sin(-3*N3 + 4*N4)
             +   21.81 * sin(-N3 + 2*N5)
             +   46.25 * sin(N3)) * 1e-6;

        Q := (-   10.86 * cos(I1)
             -   81.51 * cos(I2)
             + 1113.36 * cos(I3)
             +  350.14 * cos(I4)
             +  106.50 * cos(I5)) * 1e-6;

        P := (-   10.86 * sin(I1)
             -   81.51 * sin(I2)
             + 1113.36 * sin(I3)
             +  350.14 * sin(I4)
             +  106.50 * sin(I5)) * 1e-6;

        GMS := GMU + GM3;
        result:=true;
    end;
    TITANIA: begin
        N := (721663.16
             -  2.64 * cos(N3 - 2*N4 + E3)
             -  2.16 * cos(2*N4 - 3*N5 + E5)
             +  6.45 * cos(2*N4 - 3*N5 + E4)
             -  1.11 * cos(2*N4 - 3*N5 + E3)
             - 62.23 * cos(N2 - N4)
             - 56.13 * cos(N3 - N4)
             - 39.94 * cos(N4 - N5)
             - 91.85 * cos(2*(N4 - N5))
             - 58.31 * cos(3*(N4 - N5))
             - 38.60 * cos(4*(N4 - N5))
             - 26.18 * cos(5*(N4 - N5))
             - 18.06 * cos(6*(N4 - N5))) * 1e-6;

        L := (856358.79
             + 721718.51 * t
             +  20.61 * sin(N3 - 4*N4 + 3*N5)
             -   2.07 * sin(N3 - 2*N4 + E5)
             -   2.88 * sin(N3 - 2*N4 + E4)
             -  40.79 * sin(N3 - 2*N4 + E3)
             +   2.11 * sin(N3 - 2*N4 + E2)
             -  51.83 * sin(2*N4 - 3*N5 + E5)
             + 159.87 * sin(2*N4 - 3*N5 + E4)
             -  35.05 * sin(2*N4 - 3*N5 + E3)
             -   1.56 * sin(3*N4 - 4*N5 + E5)
             +  40.54 * sin(N2 - N4)
             +  46.17 * sin(N3 - N4)
             - 317.76 * sin(N4 - N5)
             - 305.59 * sin(2*(N4 - N5))
             - 148.36 * sin(3*(N4 - N5))
             -  82.92 * sin(4*(N4 - N5))
             -  49.98 * sin(5*(N4 - N5))
             -  31.56 * sin(6*(N4 - N5))
             -  20.56 * sin(7*(N4 - N5))
             -  13.69 * sin(8*(N4 - N5))) * 1e-6;

        K := (-    0.02 * cos(E1)
             -    1.29 * cos(E2)
             -  324.51 * cos(E3)
             +  932.81 * cos(E4)
             + 1120.89 * cos(E5)
             +   33.86 * cos(N2)
             +   17.46 * cos(N4)
             +   16.58 * cos(-N2 + 2*N4)
             +   28.89 * cos(N3)
             -   35.86 * cos(-N3 + 2*N4)
             -   17.86 * cos(N4)
             -   32.10 * cos(N5)
             -  177.83 * cos(-N4 + 2*N5)
             +  793.43 * cos(-2*N4 + 3*N5)
             +   99.48 * cos(-3*N4 + 4*N5)
             +   44.83 * cos(-4*N4 + 5*N5)
             +   25.13 * cos(-5*N4 + 6*N5)
             +   15.43 * cos(-6*N4 + 7*N5)) * 1e-6;

        H := (-    0.02 * sin(E1)
             -    1.29 * sin(E2)
             -  324.51 * sin(E3)
             +  932.81 * sin(E4)
             + 1120.89 * sin(E5)
             +   33.86 * sin(N2)
             +   17.46 * sin(N4)
             +   16.58 * sin(-N2 + 2*N4)
             +   28.89 * sin(N3)
             -   35.86 * sin(-N3 + 2*N4)
             -   17.86 * sin(N4)
             -   32.10 * sin(N5)
             -  177.83 * sin(-N4 + 2*N5)
             +  793.43 * sin(-2*N4 + 3*N5)
             +   99.48 * sin(-3*N4 + 4*N5)
             +   44.83 * sin(-4*N4 + 5*N5)
             +   25.13 * sin(-5*N4 + 6*N5)
             +   15.43 * sin(-6*N4 + 7*N5)) * 1e-6;

        Q := (-   1.43 * cos(I1)
             -   1.06 * cos(I2)
             - 140.13 * cos(I3)
             + 685.72 * cos(I4)
             + 378.32 * cos(I5)) * 1e-6;

        P := (-   1.43 * sin(I1)
             -   1.06 * sin(I2)
             - 140.13 * sin(I3)
             + 685.72 * sin(I4)
             + 378.32 * sin(I5)) * 1e-6;

        GMS := GMU + GM4;
        result:=true;
    end;
    OBERON: begin
        N := (466580.54
             +  2.08 * cos(2*N4 - 3*N5 + E5)
             -  6.22 * cos(2*N4 - 3*N5 + E4)
             +  1.07 * cos(2*N4 - 3*N5 + E3)
             - 43.10 * cos(N2 - N5)
             - 38.94 * cos(N3 - N5)
             - 80.11 * cos(N4 - N5)
             + 59.06 * cos(2*(N4 - N5))
             + 37.49 * cos(3*(N4 - N5))
             + 24.82 * cos(4*(N4 - N5))
             + 16.84 * cos(5*(N4 - N5))) * 1e-6;

        L := (-915591.80
             + 466692.12 * t
             -   7.82 * sin(N3 - 4*N4 + 3*N5)
             +  51.29 * sin(2*N4 - 3*N5 + E5)
             - 158.24 * sin(2*N4 - 3*N5 + E4)
             +  34.51 * sin(2*N4 - 3*N5 + E3)
             +  47.51 * sin(N2 - N5)
             +  38.96 * sin(N3 - N5)
             + 359.73 * sin(N4 - N5)
             + 282.78 * sin(2*(N4 - N5))
             + 138.60 * sin(3*(N4 - N5))
             +  78.03 * sin(4*(N4 - N5))
             +  47.29 * sin(5*(N4 - N5))
             +  30.00 * sin(6*(N4 - N5))
             +  19.62 * sin(7*(N4 - N5))
             +  13.11 * sin(8*(N4 - N5))) * 1e-6;

        K := (        0 * cos(E1)
             -    0.35 * cos(E2)
             +   74.53 * cos(E3)
             -  758.68 * cos(E4)
             + 1397.34 * cos(E5)
             +   39.00 * cos(N2)
             +   17.66 * cos(-N2 + 2*N5)
             +   32.42 * cos(N3)
             +   79.75 * cos(N4)
             +   75.66 * cos(N5)
             +  134.04 * cos(-N4 + 2*N5)
             -  987.26 * cos(-2*N4 + 3*N5)
             -  126.09 * cos(-3*N4 + 4*N5)
             -   57.42 * cos(-4*N4 + 5*N5)
             -   32.41 * cos(-5*N4 + 6*N5)
             -   19.99 * cos(-6*N4 + 7*N5)
             -   12.94 * cos(-7*N4 + 8*N5)) * 1e-6;

        H := (0 * sin(E1)
             -    0.35 * sin(E2)
             +   74.53 * sin(E3)
             -  758.68 * sin(E4)
             + 1397.34 * sin(E5)
             +   39.00 * sin(N2)
             +   17.66 * sin(-N2 + 2*N5)
             +   32.42 * sin(N3)
             +   79.75 * sin(N4)
             +   75.66 * sin(N5)
             +  134.04 * sin(-N4 + 2*N5)
             -  987.26 * sin(-2*N4 + 3*N5)
             -  126.09 * sin(-3*N4 + 4*N5)
             -   57.42 * sin(-4*N4 + 5*N5)
             -   32.41 * sin(-5*N4 + 6*N5)
             -   19.99 * sin(-6*N4 + 7*N5)
             -   12.94 * sin(-7*N4 + 8*N5)) * 1e-6;

        Q := (-   0.44 * cos(I1)
             -   0.31 * cos(I2)
             +  36.89 * cos(I3)
             - 596.33 * cos(I4)
             + 451.69 * cos(I5)) * 1e-6;

        P := (-   0.44 * sin(I1)
             -   0.31 * sin(I2)
             +  36.89 * sin(I3)
             - 596.33 * sin(I4)
             + 451.69 * sin(I5)) * 1e-6;

        GMS := GMU + GM5;
        result:=true;
    end;
    else
        result:=false;
    end;

    if result then begin
      X := 0;
      Y := 0;
      Z := 0;

      N /= 86400;
      L := rmod(L, TWO_PI);

      UracalcRectangular(N, L, K, H, Q, P, GMS, X, Y, Z);

      UranicentricToGeocentricEquatorial(X, Y, Z);

      // precess to J2000
      precessB1950J2000(X, Y, Z);
    end;
end;

function nepsat(jd:double; b:Tbody; var X,Y,Z: double):boolean;
{
  Ephemerides for Triton and Nereid are described in Jacobson,
  Astron. Astrophys. 231, 241-250 (1990)
}
var
    td: double;       // Julian days from reference date
    ty: double;       // Julian years from reference date
    tc: double;       // Julian centuries from reference date

    a: double;        // semimajor axis
    L: double;        // mean longitude
    e: double;        // eccentricity
    w: double;        // longitude of periapse
    i: double;        // inclination of orbit
    o: double;        // longitude of ascending node

    ma: double;       // mean anomaly

    N: double;        // node of the orbital reference plane on the
                      // Earth equator B1950
    J: double;        // inclination of orbital reference plane with
                      // respect to the Earth equator B1950
    EE: double;
begin

    case b of
    TRITON: begin
        td := jd - 2433282.5;
        ty := td/365.25;
        tc := ty/100;

        a := 354611.773;
        L := (49.85334766 + 61.25726751 * td) * deg_to_rad;
        e := 0.0004102259410;
        i := 157.6852321 * deg_to_rad;
        o := (151.7973992 + 0.5430763965 * ty) * deg_to_rad;

        w := (236.7318362 + 0.5295275852 * ty) * deg_to_rad;

        ma := L - w;

        w += o;

        // inclination and node of the invariable plane on the Earth
        // equator of 1950
        J := (90 - 42.51071244) * deg_to_rad;
        N := (90 + 298.3065940) * deg_to_rad;

        result:=true;
    end;
    NEREID: begin
        td := jd - 2433680.5;
        tc := td/36525;

        a := 5511233.255;
        L := (251.14984688 + 0.9996465329 * td) * deg_to_rad;
        e := 0.750876291;
        i := 6.748231850 * deg_to_rad;
        o := (315.9958928 - 3.650272562 * tc) * deg_to_rad;

        w := (251.7242240 + 0.8696048083 * tc) * deg_to_rad;

        ma := L - w;

        w -= o;

        // inclination and node of Neptune's orbit on the Earth
        // equator of 1950
        J := 22.313 * deg_to_rad;
        N := 3.522 * deg_to_rad;
        result:=true;
    end;
    else begin
        result:=false;
        e:=0;ma:=0;a:=0;N:=0;J:=0;o:=0;i:=0;w:=0;
        end;
    end;

    if result then begin
      EE := kepler(e, ma);

      // convert semi major axis from km to AU
      a /= AU_to_km;

      // rectangular coordinates on the orbit plane, x-axis is toward
      // pericenter
      X := a * (cos(EE) - e);
      Y := a * sqrt(1 - e*e) * sin(EE);
      Z := 0;

      // rotate towards ascending node of the orbit
      rotateZ(X, Y, Z, -w);

      // rotate towards orbital reference plane
      rotateX(X, Y, Z, -i);

      // rotate towards ascending node of the orbital reference plane on
      // the Earth equator B1950
      rotateZ(X, Y, Z, -o);

      // rotate towards Earth equator B1950
      rotateX(X, Y, Z, -J);

      // rotate to vernal equinox
      rotateZ(X, Y, Z, -N);

      // precess to J2000
      precessB1950J2000(X, Y, Z);
    end;
end;

function plusat(jd:double; b:Tbody; var X,Y,Z: double):boolean;
{
  Ephemeris for Charon is from Tholen, D.J. (1985) Astron. J., 90,  2353-2359
}
var td,a,n,E,i,o: double;
begin
    td := jd - 2445000.5;               // Julian days from
                                        // reference date
    a := 19130 / AU_to_km;              // semimajor axis (km)

    n := 360 / 6.38723;                  // mean motion (degrees/day)
    E := (78.6 + n * td) * deg_to_rad;   // eccentric anomaly
    i := 94.3 * deg_to_rad;              // inclination of orbit
    o := 223.7 * deg_to_rad;             // longitude of ascending node

    // rectangular coordinates on the orbit plane, x-axis is toward
    // pericenter
    X := a * cos(E);
    Y := a * sin(E);
    Z := 0;

    // rotate towards Earth equator B1950
    rotateX(X, Y, Z, -i);

    // rotate to vernal equinox
    rotateZ(X, Y, Z, -o);

    // precess to J2000
    precessB1950J2000(X, Y, Z);
    result:=true;
end;



function MarSatAll(jde: double; var xsat,ysat,zsat : double20):integer;
var i: integer;
    X,Y,Z: double;
begin
result:=0;
for i:=1 to 2 do begin
  if marsat(jde, tbody(ord(MARS)+i), X,Y,Z) then begin
    xsat[i]:=X;
    ysat[i]:=Y;
    zsat[i]:=Z;
  end
  else result:=1;
end;
end;

function JupSatAll(jde: double; smallsat: boolean; var xsat,ysat,zsat : double20):integer;
const nrocks=4;
      rocks: array[1..nrocks] of integer = (505,514,515,516);
var i: integer;
    X,Y,Z: double;
    vect: array [0..2] of double;
begin
result:=0;
for i:=1 to 4 do begin
  if jupsat(jde, tbody(ord(JUPITER)+i), X,Y,Z) then begin
    xsat[i]:=X;
    ysat[i]:=Y;
    zsat[i]:=Z;
  end
  else result:=1;
end;
if smallsat then for i:=1 to nrocks do begin
  if evaluate_rock( jde,rocks[i],vect) then begin
    xsat[4+i]:=vect[0]/AU_to_km;
    ysat[4+i]:=vect[1]/AU_to_km;
    zsat[4+i]:=vect[2]/AU_to_km;
  end
  else begin xsat[4+i]:=0;ysat[4+i]:=0;zsat[4+i]:=0;end;
end;
end;

function SatSatAll(jde: double; smallsat: boolean; var xsat,ysat,zsat : double20):integer;
const nrocks=10;
      rocks: array[1..nrocks] of integer = (610,611,612,613,614,615,616,617,618,635);
var i: integer;
    X,Y,Z: double;
    vect: array [0..2] of double;
begin
result:=0;
for i:=1 to 9 do begin
  if satsat(jde, tbody(ord(SATURN)+i), X,Y,Z) then begin
    xsat[i]:=X;
    ysat[i]:=Y;
    zsat[i]:=Z;
  end
  else result:=1;
end;
if smallsat then for i:=1 to nrocks do begin
  if evaluate_rock( jde,rocks[i],vect) then begin
    xsat[9+i]:=vect[0]/AU_to_km;
    ysat[9+i]:=vect[1]/AU_to_km;
    zsat[9+i]:=vect[2]/AU_to_km;
  end
  else begin xsat[9+i]:=0;ysat[9+i]:=0;zsat[9+i]:=0;end;
end;
end;

function UraSatAll(jde: double; smallsat: boolean; var xsat,ysat,zsat : double20):integer;
const nrocks=13;
      rocks: array[1..nrocks] of integer = (706,707,708,709,710,711,712,713,714,715,725,726,727);
var i: integer;
    X,Y,Z: double;
    vect: array [0..2] of double;
begin
result:=0;
for i:=1 to 5 do begin
  if urasat(jde, tbody(ord(URANUS)+i), X,Y,Z) then begin
    xsat[i]:=X;
    ysat[i]:=Y;
    zsat[i]:=Z;
  end
  else result:=1;
end;
if smallsat then for i:=1 to nrocks do begin
  if evaluate_rock( jde,rocks[i],vect) then begin
    xsat[5+i]:=vect[0]/AU_to_km;
    ysat[5+i]:=vect[1]/AU_to_km;
    zsat[5+i]:=vect[2]/AU_to_km;
  end
  else begin xsat[5+i]:=0;ysat[5+i]:=0;zsat[5+i]:=0;end;
end;
end;

function NepSatAll(jde: double; smallsat: boolean; var xsat,ysat,zsat : double20):integer;
const nrocks=6;
      rocks: array[1..nrocks] of integer = (803,804,805,806,807,808);
var i: integer;
    X,Y,Z: double;
    vect: array [0..2] of double;
begin
result:=0;
for i:=1 to 2 do begin
  if nepsat(jde, tbody(ord(NEPTUNE)+i), X,Y,Z) then begin
    xsat[i]:=X;
    ysat[i]:=Y;
    zsat[i]:=Z;
  end
  else result:=1;
end;
if smallsat then for i:=1 to nrocks do begin
  if evaluate_rock( jde,rocks[i],vect) then begin
    xsat[2+i]:=vect[0]/AU_to_km;
    ysat[2+i]:=vect[1]/AU_to_km;
    zsat[2+i]:=vect[2]/AU_to_km;
  end
  else begin xsat[2+i]:=0;ysat[2+i]:=0;zsat[2+i]:=0;end;
end;
end;

function PluSatAll(jde: double; var xsat,ysat,zsat : double20):integer;
var i: integer;
    X,Y,Z: double;
begin
result:=0;
for i:=1 to 1 do begin
  if plusat(jde, tbody(ord(PLUTO)+i), X,Y,Z) then begin
    xsat[i]:=X;
    ysat[i]:=Y;
    zsat[i]:=Z;
  end
  else result:=1;
end;
end;



function MarSatOne(jde: double; isat:integer; var xs,ys,zs : double):integer;
begin
result:=1;
if isat<=2 then begin
if marsat(jde, tbody(ord(MARS)+isat), xs,ys,zs) then
    result:=0;
end;
end;

function JupSatOne(jde: double; isat:integer; var xs,ys,zs : double):integer;
const nrocks=4;
      rocks: array[1..nrocks] of integer = (505,514,515,516);
var vect: array [0..2] of double;
begin
result:=1;
if isat<=4  then begin
  if jupsat(jde, tbody(ord(JUPITER)+isat), xs,ys,zs) then begin
    result:=0;
  end
  else result:=1;
end else begin
  isat:=isat-4;
  if isat<=nrocks then begin
  if evaluate_rock( jde,rocks[isat],vect) then begin
    xs:=vect[0]/AU_to_km;
    ys:=vect[1]/AU_to_km;
    zs:=vect[2]/AU_to_km;
    result:=0;
  end
  else result:=1;
  end;
end;
end;

function SatSatOne(jde: double; isat:integer; var xs,ys,zs : double):integer;
const nrocks=10;
      rocks: array[1..nrocks] of integer = (610,611,612,613,614,615,616,617,618,635);
var vect: array [0..2] of double;
begin
result:=1;
if isat<=9  then begin
  if satsat(jde, tbody(ord(SATURN)+isat), xs,ys,zs) then begin
    result:=0;
  end
  else result:=1;
end else begin
  isat:=isat-9;
  if isat<=nrocks then begin
  if evaluate_rock( jde,rocks[isat],vect) then begin
    xs:=vect[0]/AU_to_km;
    ys:=vect[1]/AU_to_km;
    zs:=vect[2]/AU_to_km;
    result:=0;
  end
  else result:=1;
  end;
end;
end;

function UraSatOne(jde: double; isat:integer; var xs,ys,zs : double):integer;
const nrocks=13;
      rocks: array[1..nrocks] of integer = (706,707,708,709,710,711,712,713,714,715,725,726,727);
var vect: array [0..2] of double;
begin
result:=1;
if isat<=5 then begin
  if urasat(jde, tbody(ord(URANUS)+isat), xs,ys,zs) then begin
    result:=0;
  end
  else result:=1;
end else begin
  isat:=isat-5;
  if isat<=nrocks then begin
  if evaluate_rock( jde,rocks[isat],vect) then begin
    xs:=vect[0]/AU_to_km;
    ys:=vect[1]/AU_to_km;
    zs:=vect[2]/AU_to_km;
    result:=0;
  end
  else result:=1;
  end;
end;
end;

function NepSatOne(jde: double; isat:integer; var xs,ys,zs : double):integer;
const nrocks=6;
      rocks: array[1..nrocks] of integer = (803,804,805,806,807,808);
var vect: array [0..2] of double;
begin
result:=1;
if isat<=2 then begin
  if nepsat(jde, tbody(ord(NEPTUNE)+isat), xs,ys,zs) then begin
    result:=0;
  end
  else result:=1;
end else begin
  isat:=isat-2;
  if isat<=nrocks then begin
  if evaluate_rock( jde,rocks[isat],vect) then begin
    xs:=vect[0]/AU_to_km;
    ys:=vect[1]/AU_to_km;
    zs:=vect[2]/AU_to_km;
    result:=0;
  end
  else result:=1;
  end;
end;
end;

function PluSatOne(jde: double; isat:integer; var xs,ys,zs : double):integer;
begin
result:=1;
if isat=1 then begin
  if plusat(jde, tbody(ord(PLUTO)+isat), xs,ys,zs) then begin
    result:=0;
  end
  else result:=1;
  end;
end;

end.
