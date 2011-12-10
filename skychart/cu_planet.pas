unit cu_planet;
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
 Planet computation component.
}
{$mode objfpc}{$H+}
interface

uses
  satxymain,    // satxy statically linked
  uDE,
  u_translation, cu_database, u_constant, u_util, u_projection,
  Classes, Sysutils, passql, pasmysql, passqlite, Forms, Math;

type Tastelem = record
  Oaa,Obb,Occ,Oa,Ob,Oc,Ot,Oq,Oe,Oomi : Double;     (* parametres de l'orbite   *)
  At,Am,Aa,Ah,Ag,equinox : double;
  AsterName: string;
  end;
type Tcomelem = record
  Oaa,Obb,Occ,Oa,Ob,Oc,equinox,Ot,Oq,Oe,Oomi,Oh,Og : Double;
  CometName: string;
  end;

type
  TPlanet = class(TComponent)
  private
    { Private declarations }
    db1,db2 : TSqlDB;
    LockPla,LockDB : boolean;
    SolT0,XSol,YSol,ZSol : double;
    jdnew,jdchart,com_limitmag:double;
    ast_daypos,com_daypos: string;
    Feph_method: string;
    smsg:Tstrings;
    SolAstrometric, SolBarycenter : boolean;
    CurrentStep,CurrentPlanet,n_com,n_ast : integer;
    CurrentAstStep,CurrentAsteroid : integer;
    CurrentComStep,CurrentComet : integer;
    astelem : Tastelem;
    comelem : Tcomelem;
{    satxyok : boolean;
    satxyfm : TSatxyfm;
    satxylib: TLibHandle;}
  protected
    { Protected declarations }
     Procedure JupSatInt(jde : double;var P : double; var xsat,ysat : array of double; var supconj : array of boolean);
  public
    { Public declarations }
     cdb: TCdcDb;
     constructor Create(AOwner:TComponent); override;
     destructor  Destroy; override;
     procedure SetDE(folder:string);
     function load_de(t: double): boolean;
     Procedure ComputePlanet(cfgsc: Tconf_skychart);
     Procedure FindNumPla(id: Integer ;var ar,de:double; var ok:boolean;cfgsc: Tconf_skychart);
     function  FindPlanetName(planetname: String; var ra,de:double; cfgsc: Tconf_skychart):boolean;
     function  FindPlanet(x1,y1,x2,y2:double; nextobj:boolean; cfgsc: Tconf_skychart; var nom,ma,date,desc:string;trunc:boolean=true):boolean;
     Procedure Plan(ipla: integer; t: double ; var p: TPlanData);
     Procedure Planet(ipla : integer; t0 : double ; var alpha,delta,distance,illum,phase,diameter,magn,dp,xp,yp,zp,vel : double);
     Procedure SunRect(t0 : double ; astrometric : boolean; var x,y,z : double;barycenter:boolean=true);
     Procedure Sun(t0 : double; var alpha,delta,dist,diam : double);
     Procedure SunEcl(t0 : double ; var l,b : double);
     Function MarSat(jde,diam : double; var xsat,ysat : double8; var supconj : array of boolean):integer;
     Function JupSat(jde,diam : double; var xsat,ysat : double8; var supconj : array of boolean):integer;
     Function SatSat(jde,diam : double; var xsat,ysat : double8; var supconj : array of boolean):integer;
     Function UraSat(jde,diam : double; var xsat,ysat : double8; var supconj : array of boolean):integer;
     Procedure SatRing(jde : double; var P,a,b,be : double);
     Function JupGRS(lon,drift,jdref,jdnow: double):double;
     Procedure Moon(t0 : double; var alpha,delta,dist,dkm,diam,phase,illum : double);
     Procedure MoonIncl(Lar,Lde,Sar,Sde : double; var incl : double);
     Function MoonMag(phase:double):double;
     Procedure PlanetOrientation(jde:double; ipla:integer; var P,De,Ds,w1,w2,w3 : double);
     Procedure MoonOrientation(jde,ra,dec,d:double; var P,llat,lats,llong : double);
     Procedure ComputeAsteroid(cfgsc: Tconf_skychart);
     Procedure ComputeComet(cfgsc: Tconf_skychart);
     PROCEDURE OrbRect(jd :Double ; VAR xc,yc,zc,rs :Double );
     PROCEDURE InitComet(tp,q,ec,ap,an,ic,mh,mg,eq: double; nam:string);
     PROCEDURE Comet(jd :Double; lightcor:boolean; VAR ar,de,dist,r,elong,phase,magn,diam,lc,car,cde,rc,xc,yc,zc : Double);
     PROCEDURE InitAsteroid(epoch,mh,mg,ma,ap,an,ic,ec,sa,eq: double; nam:string);
     PROCEDURE Asteroid(jd :Double; highprec:boolean; VAR ar,de,dist,r,elong,phase,magn,xc,yc,zc : Double);
     Function ConnectDB(host,db,user,pass:string; port:integer):boolean;
     Function NewAstDay(newjd,limitmag:double; cfgsc: Tconf_skychart):boolean;
     Procedure NewAstDayCallback(Sender:TObject; Row:TResultRow);
     function  FindAsteroid(x1,y1,x2,y2:double; nextobj:boolean; cfgsc: Tconf_skychart; var nom,mag,date,desc:string; trunc:boolean=true):boolean;
     function  FindAsteroidName(astname: String; var ra,de:double; cfgsc: Tconf_skychart):boolean;
     function PrepareAsteroid(jdt:double; msg:Tstrings):boolean;
     Procedure PrepareAsteroidCallback(Sender:TObject; Row:TResultRow);
     Function NewComDay(newjd,limitmag:double; cfgsc: Tconf_skychart):boolean;
     Procedure NewComDayCallback(Sender:TObject; Row:TResultRow);
     function FindComet(x1,y1,x2,y2:double; nextobj:boolean; cfgsc: Tconf_skychart; var nom,mag,date,desc:string; trunc:boolean=true):boolean;
     function FindCometName(comname: String; var ra,de:double; cfgsc: Tconf_skychart):boolean;
     procedure PlanetRiseSet(pla:integer; jd0:double; AzNorth:boolean; var thr,tht,ths,tazr,tazs: string; var jdr,jdt,jds,rar,der,rat,det,ras,des:double ; var i: integer; cfgsc: Tconf_skychart);
     procedure PlanetAltitude(pla: integer; jd0,hh:double; cfgsc: Tconf_skychart; var har,sina: double);
     procedure Twilight(jd0,obslat,obslon: double; out astrom,nautm,civm,cive,naute,astroe: double);
     procedure nutation(j:double; var nutl,nuto:double);
     procedure aberration(j:double; var abv,ehn: coordvector; var ab1,abe,abp,gr2e: double; var abm,asl:boolean );
     property eph_method: string read Feph_method;
  end;

implementation

constructor TPlanet.Create(AOwner:TComponent);
begin
 inherited Create(AOwner);
 lockpla:=false;
 lockdb:=false;
 Feph_method:='';
 de_type:=0;
 de_year:=-999999;
{ satxyok:=true;
 satxylib:=LoadLibrary(libsatxy);
 if satxylib<>0 then begin
    satxyfm:= TSatxyfm(GetProcedureAddress(satxylib,libsatxyfm));
   if addr(satxyfm)<>nil then satxyok:=true;
 end;}
 if DBtype=mysql then begin
   db1:=TMyDB.create(self);
   db2:=TMyDB.create(self);
 end else if DBtype=sqlite then begin
   db1:=TLiteDB.create(self);
   db2:=TLiteDB.create(self);
 end;
end;

destructor TPlanet.Destroy;
begin
try
// if satxyok then dlclose(satxylib);
 db1.Free;
 db2.Free;
 if de_created then close_de_file;
 inherited destroy;
except
writetrace('error destroy '+name);
end;
end;

Procedure TPlanet.Plan(ipla: integer; t: double ; var p: TPlanData);
var v2: Array_5D;
    pl :TPlanetData;
    x,y,z,qr: double;
begin
if load_de(t) then begin    // use jpl DE-
  Calc_Planet_de(t, ipla, v2,true,12,false);
  p.x:=v2[0];
  p.y:=v2[1];
  p.z:=v2[2];
  // rotate equatorial to ecliptic
  x:=p.x;
  y:= coseps2k*p.y + sineps2k*p.z;
  z:= -sineps2k*p.y + coseps2k*p.z;
  // convert to polar
  p.r:=sqrt(x*x+y*y+z*z);
  p.l:=arctan2(y,x);
  if (p.l<0) then p.l:=p.l+2*pi;
  qr:=sqrt(x*x+y*y);
  if qr<>0 then p.b:=arctan(z/qr);
  Feph_method:='DE'+inttostr(de_type);
end
else if (t>jdmin404)and(t<jdmax404) then begin               // use Plan404
  pl.ipla:=ipla;
  pl.JD:=t;
  Plan404(addr(pl));
  p.x:=pl.x;
  p.y:=pl.y;
  p.z:=pl.z;
  p.l:=pl.l;
  p.b:=pl.b;
  p.r:=pl.r;
  Feph_method:='plan404';
end else begin
  p.x:=0;
  p.y:=0;
  p.z:=0;
  p.l:=0;
  p.b:=0;
  p.r:=0;
  Feph_method:='';
end;
end;

Procedure TPlanet.Planet(ipla : integer; t0 : double ; var alpha,delta,distance,illum,phase,diameter,magn,dp,xp,yp,zp,vel : double);
const
      sa : array[1..9] of double =(0.38709893,0.72333199,1.00000011,1.52366231,5.20336301,9.53707032,19.19126393,30.06896348,39.48168677);
      s0 : array[1..9] of double =(3.34,8.41,0,4.68,98.47,83.33,34.28,36.56,1.57);
      V0 : array[1..9] of double =(-0.42,-4.40,0,-1.52,-9.40,-8.88,-7.19,-6.87,-1.0);

var  v1: double6;
     w : array[1..3] of double;
     tjd,t : double;
     pl :TPlanData;
     lt,rt,dt,lp,rp,lsol,pha,qr,xt,yt,zt : double;
begin
if (ipla<1) or (ipla=3) or (ipla>9) then exit;
// always do this computation for phase sign
  // Earth position
  Plan(3,t0-tlight,pl);
  lt:=pl.l; rt:=pl.r;
  xt:=pl.x; yt:=pl.y; zt:=pl.z;
  dt:=rt;
  // planet position
  Plan(ipla,t0,pl);
  lp:=pl.l; rp:=pl.r;
  dp:=rp;
 // get distance for light time correction
 xt:=pl.x-xt;
 yt:=pl.y-yt;
 zt:=pl.z-zt;
 distance:=sqrt(xt*xt+yt*yt+zt*zt);
 // planet using light correction
 tjd:=t0;
 SunRect(tjd,false,v1[1],v1[2],v1[3]);
 dt:=sqrt(v1[1]*v1[1]+v1[2]*v1[2]+v1[3]*v1[3]);
 t:=tjd-distance*tlight;
 Plan(ipla,t,pl);
 w[1]:=pl.x+v1[1];
 w[2]:=pl.y+v1[2];
 w[3]:=pl.z+v1[3];
 alpha:=arctan2(w[2],w[1]);
 if (alpha<0) then alpha:=alpha+2*pi;
 qr:=sqrt(w[1]*w[1]+w[2]*w[2]);
 if qr<>0 then delta:=arctan(w[3]/qr);
 xp:=pl.x;
 yp:=pl.y;
 zp:=pl.z;
 // velocity
 vel:=42.1219*sqrt(1/dp-1/(2*sa[ipla]));
{
  illuminated fraction
  correct the phase sign with the difference of longitude with the sun.
}
 qr:=(2*dp*distance);
 if qr<>0 then phase:=(dp*dp+distance*distance-dt*dt)/qr //=cos(phase)
          else phase:=1;
 illum:=(1+phase)/2;
 phase:=radtodeg(arccos(phase));
 // lt and lp must be computed!
 lsol:=rmod(pi4+pi+lt,pi2); // be sure to obtain a positive value
 lp:=rmod(lp+pi2,pi2);
 lp:=rmod(lsol-lp+pi2,pi2);
 if (lp>0)and(lp<=pi) then phase:=-phase;
{
  apparent diameter
}
 if distance<>0 then diameter:=2*s0[ipla]/distance;
{
  magnitude
}
magn:=V0[ipla]+5*log10(dp*distance); {meeus91 40. }
pha:=abs(phase);
case ipla of
    1 : magn:=magn+pha*(0.0380+pha*(-0.000273+pha*2e-6));
    2 : magn:=magn+pha*(0.0009+pha*(0.000239-pha*6.5e-7));
    4 : magn:=magn+0.016*pha;
    5 : magn:=magn+0.005*pha;
    6 : magn:=magn+0.044*pha;
end;
end;

Procedure TPlanet.SunRect(t0 : double ; astrometric : boolean; var x,y,z : double;barycenter:boolean=true);
var p :TPlanetData;
    planet_arr: Array_5D;
    tjd : double;
    i,sol : integer;
begin
if (t0=SolT0)and(astrometric=Solastrometric)and(SolBarycenter=barycenter) then begin
   x:=XSol;
   y:=YSol;
   z:=ZSol;
   end
else begin
if astrometric then tjd:=t0-tlight
               else tjd:=t0;
if load_de(tjd) then begin    // use jpl DE-
  if barycenter then sol:=12
     else sol:=11;
  Calc_Planet_de(tjd, sol, planet_arr,true,3,false);
  x:=planet_arr[0];
  y:=planet_arr[1];
  z:=planet_arr[2];
  Feph_method:='DE'+inttostr(de_type);
end
else if (t0>jdmin404)and(t0<jdmax404) then begin    // use Plan404
     p.ipla:=3;
     p.JD:=tjd;
     i:=Plan404(addr(p));
     if (i<>0) then exit;
     x:=-p.x;
     y:=-p.y;
     z:=-p.z;
     Feph_method:='plan404';
end else begin
  x:=0;
  y:=0;
  z:=0;
  Feph_method:='';
end;
// save result for repetitive call
SolBarycenter:=barycenter;
Solastrometric:=astrometric;
SolT0:=t0;
XSol:=x;
YSol:=y;
ZSol:=z;
end;
end;

Procedure TPlanet.Sun(t0 : double; var alpha,delta,dist,diam : double);
var x,y,z,qr : double;
begin
  SunRect(t0,false,x,y,z,true);
  dist:=sqrt(x*x+y*y+z*z);
  alpha:=arctan2(y,x);
  if (alpha<0) then alpha:=alpha+pi2;
  qr:=sqrt(x*x+y*y);
  if qr<>0 then delta:=arctan(z/qr);
  if dist<>0 then diam:=2*959.63/dist;
end;

Procedure TPlanet.SunEcl(t0 : double ; var l,b : double);
var x1,y1,z1,x,y,z,qr : double;
begin
SunRect(t0,false,x1,y1,z1,true);
// rotate equatorial to ecliptic
x:=x1;
y:= coseps2k*y1 + sineps2k*z1;
z:= -sineps2k*y1 + coseps2k*z1;
// convert to polar
l:=arctan2(y,x);
if (l<0) then l:=l+2*pi;
qr:=sqrt(x*x+y*y);
if qr<>0 then b:=arctan(z/qr);
end;

function to360(x:double):double;
begin
result:=rmod(x+3600000000,360);
end;

Procedure TPlanet.JupSatInt(jde : double;var P : double; var xsat,ysat : array of double; var supconj : array of boolean);
var pl :TPlanData;
    d,V1,M1,N1,J1,A1,B1,K1,Re,Rj,pha : double;
    d2,T0,T1,A0,D0,l0,b0,r0,l,b,r,x,y,z,del,eps,ceps,seps,u,v,aa,dd,DE : double;
    u1,u2,u3,u4,G,H,r1,r2,r3,r4,sDe : double;
begin
//  meeus 42.low
d := jde - 2451545.0;
V1 := to360(172.74 + 0.00111588 * d);
M1 := to360(357.529 + 0.9856003 * d);
N1 := to360(20.020 + 0.0830853 * d + 0.329 * sin(degtorad(V1)));
J1 := to360(66.115 + 0.9025179 * d - 0.329 * sin(degtorad(V1)));
A1 := to360(1.915 * sin(degtorad(M1)) + 0.020 * sin(degtorad(2*M1)));
B1 := to360(5.555 * sin(degtorad(N1)) + 0.168 * sin(degtorad(2*N1)));
K1 := J1 + A1 - B1;
Re := 1.00014 - 0.01671 * cos(degtorad(M1)) - 0.00014 * cos(degtorad(2*M1));
Rj := 5.20872 - 0.25208 * cos(degtorad(N1)) - 0.00611 * cos(degtorad(2*N1));
del := sqrt(Rj*Rj + Re*Re - 2*Rj*Re * cos(degtorad(K1)));
pha := radtodeg(arcsin(Re * sin(degtorad(K1)) / del));
//  meeus 42.
d2 := jde - 2433282.5;
T1 := d2/36525;
T0 := (jde - 2451545.0)/36525;
A0 := 268.00 + 0.1061 * T1;
D0 := 64.50 - 0.0164 * T1;
//WW1 := to360(17.710 + 877.90003539 * d2);
//WW2 := to360(16.838 + 870.27003539 * d2);
Plan(3,jde,pl);
l0:=pl.l; b0:=pl.b; r0:=pl.r;
Plan(5,jde,pl);
l:=pl.l; b:=pl.b; r:=pl.r;
x := r * cos(b) * cos(l) - r0 * cos(l0);
y := r * cos(b) * sin(l) - r0 * sin(l0);
z := r * sin(b) - r0 * sin(b0);
del := sqrt( x*x + y*y + z*z);
l := l - degtorad(0.012990 * del / (r*r) );
x := r * cos(b) * cos(l) - r0 * cos(l0);
y := r * cos(b) * sin(l) - r0 * sin(l0);
z := r * sin(b) - r0 * sin(b0);
del := sqrt( x*x + y*y + z*z);
eps := 23.439291111 - 0.0130042 * T0 - 1.64e-7 * T0*T0 + 5.036e-7 *T0*T0*T0;
ceps := cos(degtorad(eps));
seps := sin(degtorad(eps));
//AlpS := radtodeg(arctan2(ceps*sin(l)-seps*tan(b),cos(l)));
//DelS := radtodeg(arcsin(ceps*sin(b)+seps*cos(b)*sin(l)));
//DS := radtodeg(arcsin(-sin(degtorad(D0))*sin(degtorad(DelS))-cos(degtorad(D0))*cos(degtorad(DelS))*cos(degtorad(A0-AlpS))));
u := y * ceps - z * seps;
v := y * seps + z * ceps;
aa := radtodeg(arctan2(u,x));
dd := radtodeg(arctan(v/sqrt(x*x+u*u)));
//k := radtodeg(arctan2(sin(degtorad(D0))*cos(degtorad(dd))*cos(degtorad(A0-aa))-sin(degtorad(dd))*cos(degtorad(D0)),cos(degtorad(dd))*sin(degtorad(A0-aa))));
DE := radtodeg(arcsin(-sin(degtorad(D0))*sin(degtorad(dd))-cos(degtorad(d0))*cos(degtorad(dd))*cos(degtorad(A0-aa))));
//w1 := to360(WW1 - k - 5.07033 * del);
//w2 := to360(WW2 - k - 5.02626 * del);
P := radtodeg(arctan2(cos(degtorad(D0))*sin(degtorad(A0-aa)),sin(degtorad(D0))*cos(degtorad(dd))-cos(degtorad(D0))*sin(degtorad(dd))*cos(degtorad(A0-aa))));
// meeus 43.low
u1 := to360(163.8067 + 203.4058643 * (d-del/173) + pha - B1);
u2 := to360(358.4108 + 101.2916334 * (d-del/173) + pha - B1);
u3 := to360(5.7129 + 50.2345179 * (d-del/173) + pha - B1);
u4 := to360(224.8151 + 21.4879801 * (d-del/173) + pha - B1);
G := to360(331.18 + 50.310482 * (d -del/173));
H := to360(87.40 + 21.569231 * (d -del/173));
r1 := 5.9073 - 0.0244 * cos(degtorad(2*(u1-u2)));
r2 := 9.3991 - 0.0882 * cos(degtorad(2*(u2-u3)));
r3 := 14.9924 - 0.0216 * cos(degtorad(G));
r4 := 26.3699 - 0.1935 * cos(degtorad(H));
u1 := degtorad(u1 + 0.473 * sin(degtorad(2*(u1-u2))));
u2 := degtorad(u2 + 1.0653 * sin(degtorad(2*(u2-u3))));
u3 := degtorad(u3 + 0.165 * sin(degtorad(G)));
u4 := degtorad(u4 + 0.841 * sin(degtorad(H)));
sDe:=sin(degtorad(De));
xsat[0] := r1 * sin(u1);
ysat[0] := -r1 * cos(u1)*sDe;
xsat[1] := r2 * sin(u2);
ysat[1] := -r2 * cos(u2)*sDe;
xsat[2] := r3 * sin(u3);
ysat[2] := -r3 * cos(u3)*sDe;
xsat[3] := r4 * sin(u4);
ysat[3] := -r4 * cos(u4)*sDe;
supconj[0] := (u1>(pi/2))and(u1<(3*pi/2));
supconj[1] := (u2>(pi/2))and(u2<(3*pi/2));
supconj[2] := (u3>(pi/2))and(u3<(3*pi/2));
supconj[3] := (u4>(pi/2))and(u4<(3*pi/2));
end;


Function TPlanet.JupSat(jde,diam : double; var xsat,ysat : double8; var supconj : array of boolean):integer;
var i : integer;
    sp,cp,xs,ys,P : double;
    x2,y2 : double8;
begin
{if not satxyok then result:=1
               else }result:=satxyfm(jde,5,addr(xsat),addr(ysat));
if result>0 then begin
   jupsatInt(jde,P,xsat,ysat,supconj);
   sp:=sin(degtorad(P));
   cp:=cos(degtorad(P));
   for i:=1 to 4 do begin
       xs:=xsat[i]*diam/2;
       ys:=ysat[i]*diam/2;
       xsat[i]:=-xs*cp+ys*sp;
       ysat[i]:=+xs*sp+ys*cp;
   end;
   result:=0;
end else begin
   satxyfm(jde+0.02,5,addr(x2),addr(y2));
   for i:=1 to 4 do begin
   supconj[i-1] := xsat[i]<x2[i];
   end;
end;
end;

Function TPlanet.SatSat(jde,diam : double; var xsat,ysat : double8; var supconj : array of boolean):integer;
var i : integer;
    x2,y2 : double8;
begin
//if not satxyok then begin result:=1; exit; end;
result:=satxyfm(jde,6,addr(xsat),addr(ysat));
if result=0 then begin
satxyfm(jde+0.02,6,addr(x2),addr(y2));
for i:=1 to 8 do begin
  supconj[i-1] := xsat[i]<x2[i];
end;
end;
end;

Function TPlanet.UraSat(jde,diam : double; var xsat,ysat : double8; var supconj : array of boolean):integer;
var i : integer;
    x2,y2 : double8;
begin
//if not satxyok then begin result:=1; exit; end;
result:=satxyfm(jde,7,addr(xsat),addr(ysat));
if result=0 then begin
satxyfm(jde+0.02,7,addr(x2),addr(y2));
for i:=1 to 5 do begin
  supconj[i-1] := xsat[i]<x2[i];
end;
end;
end;

Function TPlanet.MarSat(jde,diam : double; var xsat,ysat : double8; var supconj : array of boolean):integer;
var i : integer;
    x2,y2 : double8;
begin
//if not satxyok then begin result:=1; exit; end;
result:=satxyfm(jde,4,addr(xsat),addr(ysat));
if result=0 then begin
satxyfm(jde+0.02,4,addr(x2),addr(y2));
for i:=1 to 2 do begin
  supconj[i-1] := xsat[i]<x2[i];
end;
end;
end;


Procedure TPlanet.PlanetOrientation(jde:double; ipla:integer; var P,De,Ds,w1,w2,w3 : double);
const VP : array[1..10,1..4] of double = (
          (281.01,-0.033,61.54,-0.005),   //mercure
          (272.6,0,67.16,0),              //venus
          (0,-0.641,90,-0.557),           //earth
          (317.681,-0.108,52.886,-0.061), //mars
          (268.05,-0.009,64.49,0.003),    //jupiter
          (40.589,-0.036,83.537,-0.004),  //saturn
          (257.311,0,-15.175,0),          //uranus
          (299.36,0.70,43.46,-0.51),      //neptune !
          (313.02,0,9.09,0),              //pluto
          (286.13,0,63.87,0));            //sun
      W : array[1..10,1..2] of double =(
          (329.68,6.1385025),
          (160.20,-1.4813688),
          (190.16,360.9856235),
          (176.901,350.8919830),
          (67.1,877.90003539),
          (38.90,810.7939024),
          (203.81,-501.1600928),
          (253.18,536.3128492),
          (236.77,-56.3623195),
          (84.10,14.1844000));
var d,T,N,a0,d0,l0,b0,r0,l1,b1,r1,x,y,z,del,eps,als,des,u,v,al,dl,f,th,k,i : double;
    pl :TPlanData;
begin
d := (jde-jd2000);
T := d/36525;
if ipla=10 then begin  // sun
  th:=(jde-2398220)*360/25.38;
  i:=deg2rad*7.25;
  k:=deg2rad*(73.6667+1.3958333*(jde-2396758)/36525);
  Plan(3,jde,pl);
  PrecessionEcl(jd2000,jde,pl.l,pl.b);
  l0:=pl.l+pi;
  eps := deg2rad*(23.439291111 - 0.0130042 * T - 1.64e-7 * T*T + 5.036e-7 *T*T*T);
  x:=arctan(-cos(l0)*tan(eps));
  y:=arctan(-cos(l0-k)*tan(i));
  P:=rad2deg*(x+y);
  De:=rad2deg*(arcsin(sin(l0-k)*sin(i)));
  n:=arctan2(-sin(l0-k)*cos(i),-cos(l0-k));
  w1:=to360(rad2deg*n-th);
end else begin
if ipla=8 then N:=sin(357.85+52.316*T)  // Neptune
          else N:=T;
a0:=deg2rad*(VP[ipla,1]+VP[ipla,2]*N);
if ipla=8 then N:=cos(357.85+52.316*T)
          else N:=T;
d0:=deg2rad*(VP[ipla,3]+VP[ipla,4]*N);
precession(jd2000,jde,a0,d0);
w1:=W[ipla,1]+W[ipla,2]*d;
if ipla=5 then begin
   w2:=43.3+870.27003539*d;
   w3:=284.95+870.5360000*d;
end else begin
   w2:=-999;
   w3:=-999;
end;
Plan(3,jde,pl);
PrecessionEcl(jd2000,jde,pl.l,pl.b);
l0:=pl.l; b0:=pl.b; r0:=pl.r;
Plan(ipla,jde,pl);
PrecessionEcl(jd2000,jde,pl.l,pl.b);
l1:=pl.l; b1:=pl.b; r1:=pl.r;
x := r1 * cos(b1) * cos(l1) - r0 * cos(l0);
y := r1 * cos(b1) * sin(l1) - r0 * sin(l0);
z := r1 * sin(b1) - r0 * sin(b0);
del := sqrt( x*x + y*y + z*z);
Plan(ipla,jde-del*tlight,pl);
PrecessionEcl(jd2000,jde,pl.l,pl.b);
l1:=pl.l; b1:=pl.b; r1:=pl.r;
x := r1 * cos(b1) * cos(l1) - r0 * cos(l0);
y := r1 * cos(b1) * sin(l1) - r0 * sin(l0);
z := r1 * sin(b1) - r0 * sin(b0);
del := sqrt( x*x + y*y + z*z);
eps := deg2rad*(23.439291111 - 0.0130042 * T - 1.64e-7 * T*T + 5.036e-7 *T*T*T);
als:=arctan2(cos(eps)*sin(l1)-sin(eps)*tan(b1),cos(l1));
des:=arcsin(cos(eps)*sin(b1)+sin(eps)*cos(b1)*sin(l1));
Ds:=rad2deg*(arcsin(-sin(d0)*sin(des)-cos(d0)*cos(des)*cos(a0-als)));
u:=y*cos(eps)-z*sin(eps);
v:=y*sin(eps)+z*cos(eps);
al:=arctan2(u,x);
dl:=arctan(v/sqrt(x*x+u*u));
f:=rad2deg*(arctan2(sin(d0)*cos(dl)*cos(a0-al)-sin(dl)*cos(d0),cos(dl)*sin(a0-al)));
De:=rad2deg*(arcsin(-sin(d0)*sin(dl)-cos(d0)*cos(dl)*cos(a0-al)));
w1:=to360(w1-f-del*tlight*W[ipla,2]);
if ipla=5 then begin
   w2:=to360(w2-f-del*tlight*870.27003539);
   w3:=to360(w3-f-del*tlight*870.5360000);
end;
P:=to360(rad2deg*(arctan2(cos(d0)*sin(a0-al),sin(d0)*cos(dl)-cos(d0)*sin(dl)*cos(a0-al))));
end;
end;

Procedure TPlanet.MoonOrientation(jde,ra,dec,d:double; var P,llat,lats,llong : double);
var lp,l,b,f,om,w,T,a,i,lh,bh,e,v,x,y,l0 {,cel,sel,asol,dsol} : double;
    pl :TPlanData;
begin
{ P: position angle  (degree)
  llat: libration latitude (degree)
  llong: libration longitude  (degree)
  lats:  sun inclination (degree) }
T := (jde-2451545)/36525;
e:=deg2rad*23.4392911;
eq2ecl(ra,dec,e,lp,b);
// libration
F:=93.2720993+483202.0175273*t-0.0034029*t*t-t*t*t/3526000+t*t*t*t/863310000;
om:=125.0445550-1934.1361849*t+0.0020762*t*t+t*t*t/467410-t*t*t*t/60616000;
w:=lp-deg2rad*om;
i:=deg2rad*1.54242;
l:=lp;
a:=rad2deg*(arctan2(sin(w)*cos(b)*cos(i)-sin(b)*sin(i),cos(w)*cos(b)));
llong:=to360(a-F);
if llong>180 then llong:=llong-360;
llat:=arcsin(-sin(w)*cos(b)*sin(i)-sin(b)*cos(i));
// position
Plan(3,jde-tlight,pl);
PrecessionEcl(jd2000,jde,pl.l,pl.b);
l0:=rad2deg*(pl.l)-180;
lh:=l0+180+(d/pl.r)*rad2deg*cos(b)*sin(pl.l-pi-l);
bh:=(d/pl.r)*pl.b;
w:=deg2rad*(lh-om);
lats:=rad2deg*(arcsin(-sin(w)*cos(bh)*sin(i)-sin(bh)*cos(i)));
v:=deg2rad*(om);
x:=sin(i)*sin(v);
y:=sin(i)*cos(v)*cos(e)-cos(i)*sin(e);
w:=arctan2(x,y);
P:=rad2deg*(arcsin(sqrt(x*x+y*y)*cos(ra-w)/cos(llat)));
llat:=rad2deg*(llat);
end;

Function TPlanet.JupGRS(lon,drift,jdref,jdnow: double):double;
begin
result:=rmod(360000+lon+(jdnow-jdref)*drift,360);
end;

Procedure TPlanet.SatRing(jde : double; var P,a,b,be : double);
var T,i,om,l0,b0,r0,l1,b1,r1,x,y,z,del,lam,bet,sinB,eps,ceps,seps,lam0,bet0,al,de,al0,de0,j : double;
    pl :TPlanData;
begin
{ meeus 44. }
T := (jde-2451545)/36525;
i := 28.075216 - 0.012998 * T + 0.000004 *T*T;
om := 169.508470 + 1.394681 * T + 0.000412 *T*T;
j:=jde-9*0.0057755183; // aprox. light time
Plan(3,j,pl);
l0:=pl.l; b0:=pl.b; r0:=pl.r;
Plan(6,j,pl);
l1:=pl.l; b1:=pl.b; r1:=pl.r;
x := r1 * cos(b1) * cos(l1) - r0 * cos(l0);
y := r1 * cos(b1) * sin(l1) - r0 * sin(l0);
z := r1 * sin(b1) - r0 * sin(b0);
del := sqrt( x*x + y*y + z*z);
lam:=radtodeg(arctan2(y,x));
bet:=radtodeg(arctan(z/sqrt(x*x+y*y)));
sinB := sin(degtorad(i))*cos(degtorad(bet))*sin(degtorad(lam-om))-cos(degtorad(i))*sin(degtorad(bet));
be:=radtodeg(arcsin(sinB));
a:=375.35/del;
b:=a*abs(sinB);
eps := 23.439291111 - 0.0130042 * T - 1.64e-7 * T*T + 5.036e-7 *T*T*T;
ceps := cos(degtorad(eps));
seps := sin(degtorad(eps));
lam0 := degtorad(om - 90);
bet0 := degtorad(90 - i);
lam:=degtorad(lam);
bet:=degtorad(bet);
al := (arctan2(ceps*sin(lam)-seps*tan(bet),cos(lam)));
de := (arcsin(ceps*sin(bet)+seps*cos(bet)*sin(lam)));
al0 := (arctan2(ceps*sin(lam0)-seps*tan(bet0),cos(lam0)));
de0 := (arcsin(ceps*sin(bet0)+seps*cos(bet0)*sin(lam0)));
P := to360(90+radtodeg(arctan2(cos(de0)*sin(al0-al),sin(de0)*cos(de)-cos(de0)*sin(de)*cos(al0-al))));
end;

Function TPlanet.MoonMag(phase:double):double;
// The following table of lunar magnitudes is derived from relative
// intensities in Table 1 of M. Minnaert (1961),
// Phase  Frac.            Phase  Frac.            Phase  Frac.
// angle  ill.   Mag       angle  ill.   Mag       angle  ill.   Mag
//  0    1.00  -12.7        60   0.75  -11.0       120   0.25  -8.7
// 10    0.99  -12.4        70   0.67  -10.8       130   0.18  -8.2
// 20    0.97  -12.1        80   0.59  -10.4       140   0.12  -7.6
// 30    0.93  -11.8        90   0.50  -10.0       150   0.07  -6.7
// 40    0.88  -11.5       100   0.41   -9.6       160   0.03  -3.4
// 50    0.82  -11.2       110   0.33   -9.2
const mma : array[0..18]of double=(-12.7,-12.4,-12.1,-11.8,-11.5,-11.2,
                                   -11.0,-10.8,-10.4,-10.0,-9.6,-9.2,
                                   -8.7,-8.2,-7.6,-6.7,-3.4,0,0);
var i,j,k,p : integer;
begin
p:=(round(phase)+360) mod 360;
if p>180 then p:=360-p;
i:=p div 10;
k:=p-10*i;
j:=minintvalue([18,i+1]);
result:=mma[i]+((mma[j]-mma[i])*k/10);
end;

Procedure TPlanet.Moon(t0 : double; var alpha,delta,dist,dkm,diam,phase,illum : double);
{
	t0      :  julian date DT
	alpha   :  Moon RA J2000
        delta   :  Moon DEC J2000
	dist    :  Earth-Moon distance UA
	dkm     :  Earth-Moon distance Km
	diam    :  Apparent diameter (arcseconds)
	phase   :  Phase angle  (degree)
	illum	:  Illuminated percentage
}
var
   p :TPlanetData;
   q : double;
   t,sm,mm,md : double;
   w : array[1..3] of double;
   planet_arr: Array_5D;
   i : integer;
   pp : double;
begin
t0:=t0-(1.27/3600/24); // mean lighttime
if load_de(t0) then begin
   Calc_Planet_de(t0, 10, planet_arr,false,3,false);
   for i:=0 to 2 do w[i+1]:=planet_arr[i];
   dkm:=sqrt(w[1]*w[1]+w[2]*w[2]+w[3]*w[3]);
   alpha:=arctan2(w[2],w[1]);
   if (alpha<0) then alpha:=alpha+2*pi;
   pp:=sqrt(w[1]*w[1]+w[2]*w[2]);
   delta:=arctan(w[3]/pp);
   dist:=dkm/km_au;
   Feph_method:='DE'+inttostr(de_type);
end
else  if (t0>jdmin404)and(t0<jdmax404) then  begin  // use plan404
   p.JD:=t0;
   p.ipla:=11;
   Plan404(addr(p));
   dist:=sqrt(p.x*p.x+p.y*p.y+p.z*p.z);
   alpha:=arctan2(p.y,p.x);
   if (alpha<0) then alpha:=alpha+pi2;
   q:=sqrt(p.x*p.x+p.y*p.y);
   delta:=arctan(p.z/q);
   // plan404 give equinox of the date for the moon.
   precession(t0,jd2000,alpha,delta);
   dkm:=dist*km_au;
   Feph_method:='plan404';
end else begin
  Feph_method:='';
  exit;
end;
diam:=2*358482800/dkm;
t:=(t0-2415020)/36525;  { meeus 15.1 }
sm:=degtorad(358.475833+35999.0498*t-0.000150*t*t-0.0000033*t*t*t);  {meeus 30. }
mm:=degtorad(296.104608+477198.8491*t+0.009192*t*t+0.0000144*t*t*t);
md:=rmod(350.737486+445267.1142*t-0.001436*t*t+0.0000019*t*t*t,360);
phase:=180-md ;     { meeus 31.4 }
md:=degtorad(md);
phase:=rmod(phase-6.289*sin(mm)+2.100*sin(sm)-1.274*sin(2*md-mm)-0.658*sin(2*md)-0.214*sin(2*mm)-0.112*sin(md)+360,360);
illum:=(1+cos(degtorad(phase)))/2;
end;

Procedure TPlanet.MoonIncl(Lar,Lde,Sar,Sde : double; var incl : double);
{
	Lar  :  Moon RA
	Lde  :  Moon Dec
	Sar  :  Sun RA
	Sde  :  Sun Dec

	incl :  Position angle of the bright limb.
}
begin
{meeus 46.5 }
incl:=arctan2(cos(Sde)*sin(Sar-Lar),cos(Lde)*sin(Sde)-sin(Lde)*cos(Sde)*cos(Sar-Lar) );
end;

Procedure TPlanet.ComputePlanet(cfgsc: Tconf_skychart);
var ar,de,dist,illum,phase,diam,jdt,magn,st0,dkm,q,P,a,b,be,dp,sb,pha,xp,yp,zp,vel : double;
  ipla,j,i,ierr: integer;
  satx,saty : double8;
  supconj : array[1..8] of boolean;
  ars,des : double;
begin
try
while lockpla do application.ProcessMessages; lockpla:=true;
cfgsc.SimNb:=min(cfgsc.SimNb,MaxPlSim);
for j:=0 to cfgsc.SimNb-1 do begin
 jdt:=cfgsc.CurJD+j*cfgsc.SimD+j*cfgsc.SimH/24+j*cfgsc.SimM/60/24+j*cfgsc.SimS/3600/24;
 st0:=Rmod(cfgsc.CurST+ 1.00273790935*(j*cfgsc.SimD*24+j*cfgsc.SimH+j*cfgsc.SimM/60+j*cfgsc.SimS/3600)*15*deg2rad,pi2);
 // Sun first
 ipla:=10;
 Sun(jdt,ar,de,dist,diam);
 if eph_method='' then exit;
 precession(jd2000,cfgsc.JDChart,ar,de);     // equinox require for the chart
 cfgsc.PlanetLst[j,32,1]:=rmod(ar+pi,pi2);   // use geocentrique position for earth umbra
 cfgsc.PlanetLst[j,32,2]:=-de;
 cfgsc.PlanetLst[j,32,3]:=dist;
 if cfgsc.PlanetParalaxe then Paralaxe(st0,dist,ar,de,ar,de,q,cfgsc);
 if cfgsc.ApparentPos then apparent_equatorial(ar,de,cfgsc);
 ar:=rmod(ar,pi2);
 cfgsc.PlanetLst[j,ipla,1]:=ar;
 cfgsc.PlanetLst[j,ipla,2]:=de;
 cfgsc.PlanetLst[j,ipla,3]:=jdt;
 cfgsc.PlanetLst[j,ipla,4]:=diam;
 cfgsc.PlanetLst[j,ipla,5]:=-26;
 cfgsc.PlanetLst[j,ipla,6]:=dist;
 cfgsc.PlanetLst[j,ipla,7]:=0;        //phase
 if j=0 then begin
   Eq2HZ(cfgsc.CurST-ar,de,a,cfgsc.curSunH,cfgsc);
 end;
 for ipla:=1 to 9 do begin
   if ipla=3 then continue;
   Planet(ipla,jdt,ar,de,dist,illum,phase,diam,magn,dp,xp,yp,zp,vel);
   precession(jd2000,cfgsc.JDChart,ar,de);     // equinox require for the chart
   if cfgsc.PlanetParalaxe then Paralaxe(st0,dist,ar,de,ar,de,q,cfgsc);
   if cfgsc.ApparentPos then apparent_equatorial(ar,de,cfgsc);
   ar:=rmod(ar,pi2);
   cfgsc.PlanetLst[j,ipla,1]:=ar;
   cfgsc.PlanetLst[j,ipla,2]:=de;
   cfgsc.PlanetLst[j,ipla,3]:=jdt;
   cfgsc.PlanetLst[j,ipla,4]:=diam;
   cfgsc.PlanetLst[j,ipla,5]:=magn;
   cfgsc.PlanetLst[j,ipla,6]:=dist;
   cfgsc.PlanetLst[j,ipla,7]:=phase;
   pha:=abs(phase);
    if ipla=4 then begin
       ierr:=Marsat(jdt,diam,satx,saty,supconj);
       if ierr>0 then for i:=1 to 2 do cfgsc.PlanetLst[j,i+28,6]:=99
       else for i:=1 to 2 do begin
           ars:=ar+secarc*satx[i]/cos(de);
           des:=de+secarc*saty[i];
           cfgsc.PlanetLst[j,i+28,1]:=ars;
           cfgsc.PlanetLst[j,i+28,2]:=des;
           cfgsc.PlanetLst[j,i+28,3]:=jdt;
           cfgsc.PlanetLst[j,i+28,4]:=rad2deg*(2*D0mar[i]/km_au/dist)*3600;
           cfgsc.PlanetLst[j,i+28,5]:=V0mar[i]+5*log10(dp*dist)+pha*(0.0380+pha*(-0.000273+pha*2e-6));
           if supconj[i] then cfgsc.PlanetLst[j,i+28,6]:=10
                         else cfgsc.PlanetLst[j,i+28,6]:=0;
       end;
    end;
    if ipla=5 then begin
       ierr:=jupsat(jdt,diam,satx,saty,supconj);
       if ierr>0 then for i:=1 to 4 do cfgsc.PlanetLst[j,i+11,6]:=99
       else for i:=1 to 4 do begin
           ars:=ar+secarc*satx[i]/cos(de);
           des:=de+secarc*saty[i];
           cfgsc.PlanetLst[j,i+11,1]:=ars;
           cfgsc.PlanetLst[j,i+11,2]:=des;
           cfgsc.PlanetLst[j,i+11,3]:=jdt;
           cfgsc.PlanetLst[j,i+11,4]:=rad2deg*(2*D0jup[i]/km_au/dist)*3600;
           cfgsc.PlanetLst[j,i+11,5]:=V0jup[i]+5*log10(dp*dist)+0.005*pha;
           if supconj[i] then cfgsc.PlanetLst[j,i+11,6]:=10
                         else cfgsc.PlanetLst[j,i+11,6]:=0;
       end;
    end;
    if ipla=6 then begin
       ierr:=Satsat(jdt,diam,satx,saty,supconj);
       if ierr>0 then for i:=1 to 8 do cfgsc.PlanetLst[j,i+15,6]:=99
       else for i:=1 to 8 do begin
           ars:=ar+secarc*satx[i]/cos(de);
           des:=de+secarc*saty[i];
           cfgsc.PlanetLst[j,i+15,1]:=ars;
           cfgsc.PlanetLst[j,i+15,2]:=des;
           cfgsc.PlanetLst[j,i+15,3]:=jdt;
           cfgsc.PlanetLst[j,i+15,4]:=rad2deg*(2*D0sat[i]/km_au/dist)*3600;
           cfgsc.PlanetLst[j,i+15,5]:=V0sat[i]+5*log10(dp*dist)+0.044*pha;
           if supconj[i] then cfgsc.PlanetLst[j,i+15,6]:=10
                         else cfgsc.PlanetLst[j,i+15,6]:=0;
       end;
       SatRing(jdt,P,a,b,be);
       cfgsc.PlanetLst[j,31,1]:=P;
       cfgsc.PlanetLst[j,31,2]:=a;
       cfgsc.PlanetLst[j,31,3]:=b;
       cfgsc.PlanetLst[j,31,4]:=be;
       // ring magn. correction
       sb:=sin(deg2rad*abs(be));
       cfgsc.PlanetLst[j,ipla,5]:=cfgsc.PlanetLst[j,ipla,5]-2.6*sb+1.25*sb*sb;
    end;
    if ipla=7 then begin
       ierr:=Urasat(jdt,diam,satx,saty,supconj);
       if ierr>0 then for i:=1 to 5 do cfgsc.PlanetLst[j,i+23,6]:=99
       else for i:=1 to 5 do begin
           ars:=ar+secarc*satx[i]/cos(de);
           des:=de+secarc*saty[i];
           cfgsc.PlanetLst[j,i+23,1]:=ars;
           cfgsc.PlanetLst[j,i+23,2]:=des;
           cfgsc.PlanetLst[j,i+23,3]:=jdt;
           cfgsc.PlanetLst[j,i+23,4]:=rad2deg*(2*D0ura[i]/km_au/dist)*3600;
           cfgsc.PlanetLst[j,i+23,5]:=V0ura[i]+5*log10(dp*dist);
           if supconj[i] then cfgsc.PlanetLst[j,i+23,6]:=10
                         else cfgsc.PlanetLst[j,i+23,6]:=0;
       end;
    end;
 end;
 ipla:=11;
 Moon(jdt,ar,de,dist,dkm,diam,phase,illum);
 precession(jd2000,cfgsc.JDChart,ar,de);     // equinox require for the chart
 cfgsc.PlanetLst[j,32,4]:=dist;
 cfgsc.PlanetLst[j,32,5]:=dkm;
 // for the Moon always apply nutation but not aberration
 apparent_equatorial(ar,de,cfgsc,false);
 //if not cfgsc.ApparentPos then mean_equatorial(ar,de,cfgsc);
 if cfgsc.PlanetParalaxe then begin
    Paralaxe(st0,dist,ar,de,ar,de,q,cfgsc);
    diam:=diam/q;
    dist:=dist*q;
    dkm:=dkm*q;
    cfgsc.PlanetLst[j,32,5]:=dkm;
    cfgsc.PlanetLst[j,32,4]:=dist;
    Paralaxe(st0,dist,cfgsc.PlanetLst[j,32,1],cfgsc.PlanetLst[j,32,2],cfgsc.PlanetLst[j,32,1],cfgsc.PlanetLst[j,32,2],q,cfgsc);
 end;
 ar:=rmod(ar,pi2);
 cfgsc.PlanetLst[j,ipla,1]:=ar;
 cfgsc.PlanetLst[j,ipla,2]:=de;
 cfgsc.PlanetLst[j,ipla,3]:=jdt;
 cfgsc.PlanetLst[j,ipla,4]:=diam;
 cfgsc.PlanetLst[j,ipla,5]:=illum;
 cfgsc.PlanetLst[j,ipla,6]:=dist;
 cfgsc.PlanetLst[j,ipla,7]:=phase;
 if j=0 then begin
   Eq2HZ(cfgsc.CurST-ar,de,a,cfgsc.curMoonH,cfgsc);
   cfgsc.curMoonIllum:=illum;
 end;
end;
finally
  lockpla:=false;
end;
end;

Procedure TPlanet.FindNumPla(id: Integer ;var ar,de:double; var ok:boolean;cfgsc: Tconf_skychart);
begin
ok:=false;
if (not cfgsc.ephvalid) or (id<1) or (id>30) then exit;
ok:=true;
ar:=cfgsc.Planetlst[0,id,1];
de:=cfgsc.Planetlst[0,id,2];
// back to j2000
if cfgsc.ApparentPos then mean_equatorial(ar,de,cfgsc);
precession(cfgsc.JDchart,jd2000,ar,de);
end;

function TPlanet.FindPlanetName(planetname: String; var ra,de:double; cfgsc: Tconf_skychart):boolean;
var i : integer;
begin
result:=false;
if cfgsc.ephvalid then  for i:=1 to 30 do begin
     if (i=9) and (not cfgsc.ShowPluto) then continue;
     if (uppercase(trim(planetname))=uppercase(trim(pla[i]))) then begin
         FindNumPla(i,ra,de,result,cfgsc);
         break;
     end;
   end;
end;

function TPlanet.FindPlanet(x1,y1,x2,y2:double; nextobj:boolean; cfgsc: Tconf_skychart; var nom,ma,date,desc:string;trunc:boolean=true):boolean;
var
   yy,mm,dd,i : integer;
   tar,tde,ar,de : double;
   dist,illum,phase,diam,jdt,magn,dkm,hh,dp,p,pde,pds,w1,w2,w3,jd0,st0,q,distmin,xp,yp,zp,vel : double;
   sar,sde,sdist,sillum,sphase,sdiam,smagn,shh,sdp : string;
   directfind: boolean;
   distancetocenter: array[1..31] of double;
const d1='0.0'; d2='0.00';
begin
ar:=(x2+x1)/2;
de:=(y2+y1)/2;
if not nextobj then  begin
   CurrentStep:=0;
   CurrentPlanet:=0;
   for i:=1 to 31 do distancetocenter[i]:=maxdouble;
end;
result := false;
directfind := false;
desc:='';tar:=1;tde:=1;jdt:=0;
if cfgsc.ephvalid then repeat
  inc(CurrentPlanet);
  if (CurrentStep>0)and(CurrentPlanet<=11)and(not cfgsc.SimObject[CurrentPlanet]) then continue;
  if CurrentPlanet=3 then continue;    // skip Earth
  if (CurrentPlanet=9) and (not cfgsc.ShowPluto) then continue; // skip Pluto
  if CurrentPlanet=31 then continue;   // skip Saturn ring
  if (CurrentPlanet=32)and not cfgsc.ShowEarthShadowValid then continue;
  if CurrentPlanet>32 then begin
     inc(CurrentStep);
     if nextobj or (CurrentStep>=cfgsc.SimNb) then begin
        dec(CurrentStep);
        break;
     end else begin
        CurrentPlanet:=0;
        continue;
     end;
  end;
  // not planetary satellites for large field of vision or if hiden by the planet
  if (currentplanet>11) and (currentplanet<32) and((rad2deg*cfgsc.fov>1.5) or (cfgsc.PlanetLst[CurrentStep,CurrentPlanet,6]>90)) then continue;
  tar:=NormRa(cfgsc.PlanetLst[CurrentStep,CurrentPlanet,1]);
  tde:=cfgsc.PlanetLst[CurrentStep,CurrentPlanet,2];
  // search if this planet center is at the position
  if ( trunc ) and (
     (tar<x1) or (tar>x2) or
     (tde<y1) or (tde>y2) or
     ((CurrentPlanet>11)and (currentplanet<32)and(cfgsc.PlanetLst[CurrentStep,CurrentPlanet,6]>90))or
     ((CurrentPlanet>11)and (currentplanet<32)and cfgsc.StarFilter and (cfgsc.PlanetLst[CurrentStep,CurrentPlanet,5]>cfgsc.StarMagMax)) )
     then begin
        // no
        // but ok if the cursor is inside the planetary disk
        if (CurrentPlanet<32) then begin
           distancetocenter[CurrentPlanet]:=3600*rad2deg*angulardistance(ar,de,tar,tde);
           if distancetocenter[CurrentPlanet]<=(cfgsc.PlanetLst[CurrentStep,CurrentPlanet,4]/2)
              then result:=true
              else distancetocenter[CurrentPlanet]:=maxdouble;
        end;
     end
     else begin
        result := true;
        directfind:=true;
     end;
until directfind;
st0:=0;
cfgsc.FindOK:=result;
if result then begin
  if not directfind then begin // search the planet nearest to position
     distmin:=maxdouble;
     for i:=1 to 31 do begin
       if distancetocenter[i]<distmin then begin
          distmin:=distancetocenter[i];
          CurrentPlanet:=i;
       end;
     end;
  end;
  cfgsc.FindSize:=deg2rad*cfgsc.Planetlst[CurrentStep,CurrentPlanet,4]/3600;
  cfgsc.FindRA:=NormRa(cfgsc.PlanetLst[CurrentStep,CurrentPlanet,1]);
  cfgsc.FindDec:=cfgsc.PlanetLst[CurrentStep,CurrentPlanet,2];
  cfgsc.FindPM:=false;
  cfgsc.FindType:=ftPla;
  cfgsc.FindX:=0;
  cfgsc.FindY:=0;
  cfgsc.FindZ:=0;
  cfgsc.TrackRA:=cfgsc.FindRA;
  cfgsc.TrackDec:=cfgsc.FindDec;
  sar := ARpToStr(rad2deg*cfgsc.FindRA/15) ;
  sde := DEpToStr(rad2deg*cfgsc.FindDec) ;
  jdt:=cfgsc.PlanetLst[CurrentStep,CurrentPlanet,3];
  cfgsc.FindSimjd:=jdt;
//  str(jdt:12:4,sjd);
  djd(jdt+(cfgsc.TimeZone-cfgsc.DT_UT)/24,yy,mm,dd,hh);
  shh := ARtoStr3(rmod(hh,24));
  date:=Date2Str(yy,mm,dd)+blank+shh;
  jd0:=jd(yy,mm,dd,0);
  st0:=SidTim(jd0,hh-cfgsc.TimeZone,cfgsc.ObsLongitude);
end;
//if result and (currentplanet<=11) then begin
if result then begin
  cfgsc.TrackType:=1;
  cfgsc.TrackObj:=CurrentPlanet;
  cfgsc.TrackName:=trim(pla[CurrentPlanet]);
end;
if result and (currentplanet<10) then begin
  Planet(CurrentPlanet,jdt,ar,de,dist,illum,phase,diam,magn,dp,xp,yp,zp,vel);
  cfgsc.FindX:=xp;
  cfgsc.FindY:=yp;
  cfgsc.FindZ:=zp;
  str(dp:7:4,sdp);
  str(illum:5:3,sillum);
  str(cfgsc.PlanetLst[CurrentStep,CurrentPlanet,6]:7:4,sdist);
  str(cfgsc.PlanetLst[CurrentStep,CurrentPlanet,7]:4:0,sphase);
  str(cfgsc.PlanetLst[CurrentStep,CurrentPlanet,4]:5:1,sdiam);
  str(cfgsc.PlanetLst[CurrentStep,CurrentPlanet,5]:5:1,smagn);
  nom:=pla[CurrentPlanet];
  ma:=smagn;
  Desc := sar+tab+sde+tab
          +'  P'+tab+nom+tab
          +'m:'+smagn+tab
          +'diam:'+sdiam+blank+lsec+tab
          +'illum:'+sillum+tab
          +'phase:'+sphase+blank+ldeg+tab
          +'dist:'+sdist+' au'+tab
          +'rsol:'+sdp+' au'+tab;
  if vel<>0 then Desc:=Desc+'vel:'+formatfloat(f1,vel)+'km/s'+tab;
  PlanetOrientation(jdt,CurrentPlanet,p,pde,pds,w1,w2,w3);
  Desc:=Desc+'pa:'+formatfloat(d1,p)+tab
          +'PoleIncl:'+formatfloat(d1,pde)+tab
          +'SunIncl:'+formatfloat(d1,pds)+tab;
  if Currentplanet=5 then begin
     Desc:=Desc+'CMI:'+formatfloat(d2,w1)+tab
          +'CMII:'+formatfloat(d2,w2)+tab
          +'CMIII:'+formatfloat(d2,w3)+tab;
     jd0:=jd(yy,mm,dd,0-cfgsc.TimeZone+cfgsc.DT_UT);
     PlanetOrientation(jd0,CurrentPlanet,p,pde,pds,w1,w2,w3);
     w1:=(JupGRS(cfgsc.GRSlongitude,cfgsc.GRSdrift,cfgsc.GRSjd,jdt)-w2)*24/870.27003539;
     shh:='';
     if w1>0 then shh:=ARmtoStr(w1);
     repeat
        w1:=w1+24*360/870.27003539;
        if (w1>0)and(w1<24) then shh:=shh+blank+ARmtoStr(w1);
     until w1>24;
     Desc:=Desc+'GRStr:'+shh+tab;
     Desc:=Desc+'GRSLon:'+FormatFloat(f1,JupGRS(cfgsc.GRSlongitude,cfgsc.GRSdrift,cfgsc.GRSjd,jdt))+tab;
  end else begin
     Desc:=Desc+'CM:'+formatfloat(d2,w1)+tab
  end;
  Desc:=Desc+'ephemeris:'+eph_method+tab;
  Desc:=Desc+'date:'+date;
end;
if result and (currentplanet=10) then begin
 Sun(jdt,ar,de,dist,diam);
  str(dist:7:4,sdist);
  str(diam/60:5:1,sdiam);
  nom:=pla[CurrentPlanet];
  ma:='-26';
  Desc := sar+tab+sde+tab
          +'  S*'+tab+nom+tab
          +'m:-26'+tab
          +'diam:'+sdiam+blank+lmin+tab
          +'dist:'+sdist+' au'+tab;
  PlanetOrientation(jdt,CurrentPlanet,p,pde,pds,w1,w2,w3);
  Desc:=Desc+'pa:'+formatfloat(d1,p)+tab
          +'PoleIncl:'+formatfloat(d1,pde)+tab
          +'CM:'+formatfloat(d1,w1)+tab
          +'ephemeris:'+eph_method+tab
          +'date:'+date;
end;
if result and (currentplanet=11) then begin
  Moon(jdt,ar,de,dist,dkm,diam,phase,illum);
  precession(jd2000,cfgsc.JDChart,ar,de);
  if cfgsc.PlanetParalaxe then begin   // correct distance for paralaxe
    Paralaxe(st0,dist,ar,de,ar,de,q,cfgsc);
    diam:=diam/q;
    dist:=dist*q;
    dkm:=dkm*q;
  end;
  ar:=cfgsc.FindRA ; de:=cfgsc.FindDEC;    // reset original position value
  str(dkm:8:1,sdist);
  str(diam/60:5:1,sdiam);
  str(illum:5:3,sillum);
  str(phase:4:0,sphase);
  nom:=pla[CurrentPlanet];
  magn:=MoonMag(phase);
  str(magn:5:2,smagn);
  ma:=smagn;
  Desc := sar+tab+sde+tab
          +'  Ps'+tab+nom+tab
          +'m:'+smagn+tab
          +'diam:'+sdiam+blank+lmin+tab
          +'illum:'+sillum+tab
          +'phase:'+sphase+blank+ldeg+tab
          +'dist:'+sdist+' km'+tab;
  MoonOrientation(jdt,ar,de,dist,p,pde,pds,w1);
  Desc := Desc+'pa:'+formatfloat(d1,p)+tab
          +'llat:'+formatfloat(d2,pde)+tab
          +'llon:'+formatfloat(d2,w1)+tab
          +'SunIncl:'+formatfloat(d2,pds)+tab
          +'ephemeris:'+eph_method+tab
          +'date:'+date;
end;
if result and (currentplanet=32) then begin   // Earth umbra
  jdt:=cfgsc.PlanetLst[CurrentStep,10,3];  // date from the Sun
  cfgsc.FindSimjd:=jdt;
//  str(jdt:12:4,sjd);
  djd(jdt+(cfgsc.TimeZone-cfgsc.DT_UT)/24,yy,mm,dd,hh);
  shh := ARmtoStr(rmod(hh,24));
  date:=Date2Str(yy,mm,dd)+blank+shh;
  cfgsc.TrackType:=1;
  cfgsc.TrackObj:=CurrentPlanet;
  cfgsc.TrackName:=rsEarthShadow;
  nom:=cfgsc.Trackname;
  ma:='';
  Desc := sar+tab+sde+tab
          +'  P'+tab+nom+tab
          +date+tab;
end;
if result and (currentplanet>11) and (currentplanet<=15) then begin
  nom:=pla[CurrentPlanet];
  str(cfgsc.PlanetLst[CurrentStep,CurrentPlanet,5]:5:1,smagn);
  str(cfgsc.PlanetLst[CurrentStep,CurrentPlanet,4]:5:3,sdiam);
  ma:=smagn;
  Desc := sar+tab+sde+tab
          +' Ps'+tab+nom+tab
          +'m:'+smagn+tab
          +'diam:'+sdiam+blank+lsec+tab
          +date+tab;
end;
if result and (currentplanet>15) and (currentplanet<=23) then begin
  nom:=pla[CurrentPlanet];
  str(cfgsc.PlanetLst[CurrentStep,CurrentPlanet,5]:5:1,smagn);
  str(cfgsc.PlanetLst[CurrentStep,CurrentPlanet,4]:5:3,sdiam);
  ma:=smagn;
  Desc := sar+tab+sde+tab
          +' Ps'+tab+nom+tab
          +'m:'+smagn+tab
          +'diam:'+sdiam+blank+lsec+tab
          +date+tab;
end;
if result and (currentplanet>23) and (currentplanet<=28) then begin
  nom:=pla[CurrentPlanet];
  str(cfgsc.PlanetLst[CurrentStep,CurrentPlanet,5]:5:1,smagn);
  str(cfgsc.PlanetLst[CurrentStep,CurrentPlanet,4]:5:3,sdiam);
  ma:=smagn;
  Desc := sar+tab+sde+tab
          +' Ps'+tab+nom+tab
          +'m:'+smagn+tab
          +'diam:'+sdiam+blank+lsec+tab
          +date+tab;
end;
if result and (currentplanet>28) and (currentplanet<=30) then begin
  nom:=pla[CurrentPlanet];
  str(cfgsc.PlanetLst[CurrentStep,CurrentPlanet,5]:5:1,smagn);
  str(cfgsc.PlanetLst[CurrentStep,CurrentPlanet,4]:5:3,sdiam);
  ma:=smagn;
  Desc := sar+tab+sde+tab
          +' Ps'+tab+nom+tab
          +'m:'+smagn+tab
          +'diam:'+sdiam+blank+lsec+tab
          +date+tab;
end;
cfgsc.FindName:=nom;
cfgsc.FindDesc:=Desc;
cfgsc.FindNote:='';
end;

PROCEDURE Kepler(VAR E1:Double; e,m:Double; precision:double=1.0E-11);
 VAR a,b,c,qr,s0,s,z:Double;
     n: integer;
 BEGIN
{ meeus91  29.8 }
  if (e>0.97)and(abs(m)<0.55) then begin
    a:=(1-e)/(4*e+0.5);
    b:=m/(8*e+1);
    qr:=b + sign(b)*sqrt(b*b+a*a*a);
    if qr>0 then begin
      z:=power(qr,1/3);
      s0:=z-a/2;
      s:=s0 - (0.078*intpower(s0,5))/(1+e);
      E1:=m + e*(3*s-4*s*s*s);
    end
    else E1:=m;
   end
   else E1:=m;
{ meeus91  29.7 }
    n:=0;
    REPEAT
      c := (m + e*sin(E1) - E1) / (1.0 - e*cos(E1)) ;
      E1:= E1 + c ;
      inc(n);
      if n>10000 then raise exception.Create('Kepler equation not solved after 10000 loop. e='+floattostr(e)+' M='+floattostr(m));
    UNTIL ABS(c) < precision ;
 END ;
 
Procedure RectToPol(x,y : double; var r,alpha : double);
begin
r:=sqrt(x*x+y*y);
alpha:=arctan2(y,x);
end;

Procedure PrecessElem(annee : double; var i,oomi,oma : double);
var t,tau0,tau,eta,theta,theta0,i0,oma0,x,y,r,alpha,cosi : double;
const final = 2000.0;
begin
tau0:=(annee-1900)/1000;    { meeus 17. }
tau:=(final-1900)/1000;
t := tau-tau0;
eta := ((471.07-6.75*tau0+0.57*tau0*tau0)*t+(-3.37+0.57*tau0)*t*t+0.05*t*t*t)/3600;
theta0:=173.950833+(32869*tau0+56*tau0*tau0-(8694+55*tau0)*t+3*t*t)/3600;
theta:=theta0+((50256.41+222.29*tau0+0.26*tau0*tau0)*t+(111.15+0.26*tau0)*t*t+0.1*t*t*t)/3600;
i0:=i; oma0:=oma;
eta:=deg2rad*eta; theta:=deg2rad*theta; theta0:=deg2rad*theta0;
cosi:=cos(i0)*cos(eta)+sin(i0)*sin(eta)*cos(oma0-theta0);
y:=sin(i0)*sin(oma0-theta0);        { meeus 17.2 }
x:=-sin(eta)*cos(i0)+cos(eta)*sin(i0)*cos(oma0-theta0);
RectToPol(x,y,r,alpha);
i:=arcsin(r);
if cosi<0 then i:=pi-i ;
oma:=alpha+theta;
y:=-sin(eta)*sin(oma0-theta0);      { meeus 17.3 }
x:=sin(i0)*cos(eta)-cos(i0)*sin(eta)*cos(oma0-theta0);
RectToPol(x,y,r,alpha);
oomi:=oomi+alpha;
end;

PROCEDURE TPlanet.InitComet(tp,q,ec,ap,an,ic,mh,mg,eq: double; nam:string);
VAR
  i,Oma,ff,g,h,p,qq,r,ooe : Double;
  sOma,cOma,soe,coe,si,ci : extended;
BEGIN
comelem.CometName:=nam;
comelem.equinox:=eq ;
comelem.Ot:=tp;
comelem.Oq:=q;
comelem.Oe:=ec;
comelem.Oomi:=deg2rad*ap;
Oma:=deg2rad*an;
i:=deg2rad*ic;
comelem.Oh:=mh;
comelem.Og:=mg;
if comelem.equinox<>2000 then PrecessElem(comelem.equinox,i,comelem.oomi,oma);
ooe := deg2rad*23.43929111; {J2000}
sincos(Oma,sOma,cOma);
sincos(ooe,soe,coe);
sincos(i,si,ci);
ff:= cOma;  { meus 25.13 }
g := sOma * coe;
h := sOma * soe;
p := -sOma * ci;
qq:= cOma*ci*coe-si*soe;
r := cOma*ci*soe+si*coe;
comelem.Oaa := arctan2(ff,p) ;
comelem.Obb := arctan2(g,qq);
comelem.Occ := arctan2(h,r) ;
comelem.Oa := sqrt(ff*ff+p*p);
comelem.Ob := sqrt(g*g+qq*qq);
comelem.Oc := sqrt(h*h+r*r) ;
END  ;

PROCEDURE TPlanet.OrbRect(jd :Double ; VAR xc,yc,zc,rs :Double );
  VAR nu :Double ;

procedure eliptique ;
  VAR da,n0,m,ex,num,den :Double ;
   begin
     da:=comelem.Oq/(1.0-comelem.Oe);                     { meeus 25.12 }
     n0:=0.01720209895/(da*sqrt(da));
     m:=n0*(jd-comelem.Ot);
     Kepler(ex,comelem.Oe,m) ;
     num:=sqrt(1.0+comelem.Oe)*tan(ex/2.0);  { meeus 25.1 }
     den:=sqrt(1.0-comelem.Oe);
     nu:=2.0*arctan2(num,den);
     rs:=da*(1.0-comelem.Oe*cos(ex));   { meeus 25.2 }
  END;

procedure parabolique ;
  VAR w,s1,s :Double ;
   begin
      w :=3.649116245E-2*(jd-comelem.Ot)/(comelem.Oq*sqrt(comelem.Oq));  { meeus 26.1 }
      s1 := 0.0;
      REPEAT                                    { meeus 26.4 }
        s:=s1;
        s1:=(2.0*s*s*s+w)/(3.0*(s*s+1.0));
      UNTIL ABS(s1-s)<1.0E-9 ;
      s:=s1;
      nu:=2.0*arctan(s) ;       { meeus 26.2 }
      rs:=comelem.Oq*(1.0+s*s) ;
   end;

procedure hyperbolique ;
  VAR da,n0,m,U,U0,num,den :Double;
begin
    da:=comelem.Oq/abs(1.0-comelem.Oe);
    n0:=0.01720209895/(da*sqrt(da));
    m:=n0*(jd-comelem.Ot);
    U:=0.5 ;
    Repeat
      U0:=U ;
      U:=(2*U0*(comelem.Oe-U0*(1-m-ln(abs(U0)))))/(comelem.Oe*(U0*U0+1)-2*U0);
    until abs(U-U0) < 1E-9 ;
    num:=sqrt(comelem.Oe*comelem.Oe-1)*(U*U-1)/(2*U) ;
    den:=comelem.Oe-(U*U+1)/(2*U) ;
    nu:=arctan2(num,den);
    rs:=da*((comelem.Oe*(U*U+1)/(2*U))-1) ;
end ;

BEGIN
  if comelem.oe<1 then eliptique ;
  if comelem.oe=1 then parabolique;
  if comelem.oe>1 then hyperbolique;
  xc:=rs*comelem.Oa*sin(comelem.Oaa+comelem.Oomi+nu); { meeus 25.14 }
  yc:=rs*comelem.Ob*sin(comelem.Obb+comelem.Oomi+nu);
  zc:=rs*comelem.Oc*sin(comelem.Occ+comelem.Oomi+nu);
END ;

PROCEDURE TPlanet.Comet(jd :Double; lightcor:boolean; VAR ar,de,dist,r,elong,phase,magn,diam,lc,car,cde,rc,xc,yc,zc : Double);
VAR xs,ys,zs,rr,cxc,cyc,czc,n1 :Double;
BEGIN
SunRect(jd,false,xs,ys,zs);
OrbRect(jd,xc,yc,zc,r);
dist:=sqrt((xc+xs)*(xc+xs)+(yc+ys)*(yc+ys)+(zc+zs)*(zc+zs));
if lightcor then begin
   jd:=jd-dist*tlight;
   OrbRect(jd,xc,yc,zc,r);
   dist:=sqrt((xc+xs)*(xc+xs)+(yc+ys)*(yc+ys)+(zc+zs)*(zc+zs));
end;
ar:=arctan2((yc+ys),(xc+xs)) ;   { meeus 25.15 }
ar:=Rmod(ar+pi2,pi2);
de:=arcsin((zc+zs)/dist);
rr:=sqrt(xs*xs+ys*ys+zs*zs);
n1:=(rr*rr+dist*dist-r*r)/(2.0*rr*dist);
if abs(n1)<=1 then elong:=arccos(n1)
         else elong:=0;
n1:=(r*r+dist*dist-rr*rr)/(2.0*r*dist);
if abs(n1)<=1 then phase:=arccos(n1)
         else phase:=0;
magn:=comelem.Oh+5.0*log10(dist)+2.5*comelem.Og*log10(r);  { meeus 25.16 }
{ estimated coma diameter arcmin, personal empirical formula }
diam:=(max(0,1-ln(r))/max(1,comelem.Oh-2))*30/dist;
{ estimated tail length UA, personal empirical formula }
Lc:= max(0,1-ln(r))/power(max(1,comelem.Oh),1.5);
{ apparent position of tail end}
cxc:=xc+Lc*xc/r;
cyc:=yc+Lc*yc/r;
czc:=zc+Lc*zc/r;
car:=arctan2((ys+cyc),(xs+cxc)) ;
car:=Rmod(car+pi2,pi2);
rc:=sqrt((cxc+xs)*(cxc+xs)+(cyc+ys)*(ys+cyc)+(czc+zs)*(czc+zs));
cde:=arcsin((czc+zs)/rc);
END ;

PROCEDURE TPlanet.InitAsteroid(epoch,mh,mg,ma,ap,an,ic,ec,sa,eq: double; nam:string);
VAR
   i,Oma,ff,g,h,p,qq,r,ooe : Double;
   sOma,cOma,soe,coe,si,ci : extended;
BEGIN
astelem.AsterName:=nam;
astelem.equinox:=eq ;
astelem.At:=epoch;
astelem.Am:=deg2rad*ma;
astelem.Oomi:=deg2rad*ap;
Oma:=deg2rad*an;
i:=deg2rad*ic;
astelem.Oe:=ec;
astelem.Aa:=sa;
astelem.Ah:=mh;
astelem.Ag:=mg;
if astelem.equinox<>2000 then PrecessElem(astelem.equinox,i,astelem.oomi,oma);
ooe := deg2rad*23.43929111; {j2000 meeus91 32.7}
sincos(Oma,sOma,cOma);
sincos(ooe,soe,coe);
sincos(i,si,ci);
ff:= cOma;              { meus 25.13 }
g := sOma * coe;
h := sOma * soe;
p := -sOma * ci;
qq:= cOma*ci*coe-si*soe;
r := cOma*ci*soe+si*coe;
astelem.Oaa := arctan2(ff,p) ;
astelem.Obb := arctan2(g,qq);
astelem.Occ := arctan2(h,r) ;
astelem.Oa := sqrt(ff*ff+p*p);
astelem.Ob := sqrt(g*g+qq*qq);
astelem.Oc := sqrt(h*h+r*r) ;
END  ;

PROCEDURE TPlanet.Asteroid(jd :Double; highprec:boolean; VAR ar,de,dist,r,elong,phase,magn,xc,yc,zc : Double);
VAR xs,ys,zs,rr,phi1,phi2 :Double;
    nu,da,n0,m,ex,num,den :Double ;

Procedure AstGeom ;
begin
m:=rmod(astelem.am+n0*(jd-astelem.At),pi2);
if highprec then Kepler(ex,astelem.Oe,m)
            else Kepler(ex,astelem.Oe,m,1e-5);
num:=sqrt(1.0+astelem.Oe)*tan(ex/2.0);  { meeus 25.1 }
den:=sqrt(1.0-astelem.Oe);
nu:=2.0*arctan2(num,den);
r:=da*(1.0-astelem.Oe*cos(ex));   { meeus 25.2 }
xc:=r*astelem.Oa*sin((astelem.Oaa+astelem.Oomi+nu)); { meeus 25.14 }
yc:=r*astelem.Ob*sin((astelem.Obb+astelem.Oomi+nu));
zc:=r*astelem.Oc*sin((astelem.Occ+astelem.Oomi+nu));
dist:=sqrt((xc+xs)*(xc+xs)+(yc+ys)*(ys+yc)+(zc+zs)*(zc+zs));
end;

BEGIN
da:=astelem.Aa ;                     { meeus 25.12 }
n0:=0.01720209895/(da*sqrt(da));
SunRect(jd,false,xs,ys,zs);
AstGeom;
if highprec then begin
   jd:=jd-dist*tlight;
   AstGeom;
end;
ar:=arctan2((ys+yc),(xs+xc)) ;   { meeus 25.15 }
ar:=Rmod(ar+pi2,pi2);
de:=arcsin((zc+zs)/dist);
rr:=sqrt(xs*xs+ys*ys+zs*zs);
elong:=arccos((rr*rr+dist*dist-r*r)/(2.0*rr*dist));
phase:=arccos((r*r+dist*dist-rr*rr)/(2.0*r*dist));
phi1:=exp(-3.33*power(tan(phase/2),0.63));  { meeus91 32.14 }
phi2:=exp(-1.87*power(tan(phase/2),1.22));
magn:=astelem.Ah+5.0*log10(dist*r)-2.5*log10((1-astelem.Ag)*phi1+astelem.Ag*phi2);
end ;

Function TPlanet.ConnectDB(host,db,user,pass:string; port:integer):boolean;
begin
try
 if DBtype=mysql then begin
   db1.SetPort(port);
   db1.Connect(host,user,pass,db);
   db2.SetPort(port);
   db2.Connect(host,user,pass,db);
  end else if DBtype=sqlite then begin
   db:=UTF8Encode(db);
  end;
 if db1.database<>db then db1.Use(db);
 if db2.database<>db then db2.Use(db);
 result:=db1.Active and db2.Active;
except
  result:=false;
end;
end;

Function TPlanet.NewAstDay(newjd,limitmag:double; cfgsc: Tconf_skychart):boolean;
var qry : string;
    currentjd,jd1,dt,t : double;
    currentmag,lmag:integer;
    i: integer;
begin
try
// check for old table version
qry:='select distinct(near_earth) from '+cfgsc.ast_daypos;
db1.Query(qry);
if db1.Rowcount=0 then begin
  qry:='drop table '+cfgsc.ast_daypos;
  db1.Query(qry);
  qry:='drop table '+cfgsc.ast_day;
  db1.Query(qry);
end;
/////
lmag:=round(limitmag*10);
qry:='SELECT jd,limit_mag from '+cfgsc.ast_day;
db1.Query(qry);
if db1.Rowcount>0 then begin
   currentjd:=strtoint(db1.Results[0][0]);
   currentmag:=strtoint(db1.Results[0][1]);
end else begin
  currentjd:=-99999999;
  currentmag:=-999;
end;
if (currentjd=trunc(newjd))and(currentmag=lmag) then result:=true
 else begin
     if cfgsc.ast_day<>db1.QueryOne(showtable[DBtype]+' "'+cfgsc.ast_day+'"') then
        db1.Query('CREATE TABLE '+cfgsc.ast_day+create_table_ast_day);
     if cfgsc.ast_daypos<>db1.QueryOne(showtable[DBtype]+' "'+cfgsc.ast_daypos+'"') then begin
        db1.Query('CREATE TABLE '+cfgsc.ast_daypos+create_table_ast_day_pos);
        db1.Query('CREATE UNIQUE INDEX IDX_'+cfgsc.ast_daypos+' ON '+cfgsc.ast_daypos+' (id,epoch)');
        db1.Query('CREATE INDEX IDX2_'+cfgsc.ast_daypos+' ON '+cfgsc.ast_daypos+' (near_earth)');
     end;
     qry:='SELECT distinct(jd) from cdc_ast_mag';
     db1.Query(qry);
     if db1.Rowcount>0 then begin
        jd1:=strtofloat(trim(db1.Results[0][0]));
        dt:=abs(newjd-jd1);
        i:=1;
        while i<db1.Rowcount do begin
           t:=strtofloat(trim(db1.Results[i][0]));
           if abs(newjd-t)<dt then begin
              jd1:=t;
              dt:=abs(newjd-t);
           end;
           inc(i);
        end;
        if dt>16 then begin
           result:=false;
           exit;
        end;
        qry:='SELECT a.id,a.h,a.g,a.epoch,a.mean_anomaly,a.arg_perihelion,a.asc_node,a.inclination,a.eccentricity,a.semi_axis,a.ref,a.name,a.equinox'
            +' FROM cdc_ast_elem a, cdc_ast_mag b'
            +' where b.mag<='+inttostr(lmag)
            +' and b.jd='+formatfloat(f1,jd1)
            +' and a.id=b.id'
            +' and a.epoch=b.epoch';
        db1.CallBackOnly:=true;
        db1.OnFetchRow:=@NewAstDayCallback;
        db2.UnLockTables;
        db2.StartTransaction;
        db2.TruncateTable(cfgsc.ast_day);
        db2.TruncateTable(cfgsc.ast_daypos);
        db2.LockTables(cfgsc.ast_day+' WRITE, '+cfgsc.ast_daypos+' WRITE');
        jdnew:=newjd;
        jdchart:=cfgsc.JDChart;
        ast_daypos:=cfgsc.ast_daypos;
        db1.Query(qry);
        db1.CallBackOnly:=false;
        db1.OnFetchRow:=nil;
        qry:='INSERT INTO '+cfgsc.ast_day+' (jd,limit_mag)'
            +' VALUES ("'+inttostr(trunc(newjd))+'","'+inttostr(lmag)+'")';
        db2.Query(qry);
        db2.UnLockTables;
        db2.Commit;
        db2.flush('tables');
        result:=true;
     end else begin
       result:=false;
       exit;
     end;
 end;
except
  result:=false;
  db1.CallBackOnly:=false;
  db1.OnFetchRow:=nil;
end;
end;

Procedure TPlanet.NewAstDayCallback(Sender:TObject; Row:TResultRow);
var qry,id : string;
    imag,ira,idec,nea:integer;
    dist,r,elong,phase,h,g,ma,ap,an,ic,ec,sa,eq,epoch,ra,dec,mag,xc,yc,zc: double;
    nam:string;
begin
             id:=row[0];
             h:=StrToFloatDef(trim(row[1]),20);
             g:=StrToFloatDef(trim(row[2]),0.15);
             epoch:=strtofloat(trim(row[3]));
             ma:=strtofloat(trim(row[4]));
             ap:=strtofloat(trim(row[5]));
             an:=strtofloat(trim(row[6]));
             ic:=strtofloat(trim(row[7]));
             ec:=strtofloat(trim(row[8]));
             sa:=strtofloat(trim(row[9]));
 //            ref:=row[10];
             nam:=row[11];
             eq:=strtofloat(trim(row[12]));
             InitAsteroid(epoch,h,g,ma,ap,an,ic,ec,sa,eq,nam);
             Asteroid(jdnew,false,ra,dec,dist,r,elong,phase,mag,xc,yc,zc);
             precession(jd2000,jdchart,ra,dec);
             ira:=round(ra*1000);
             idec:=round(dec*1000);
             imag:=round(mag*10);
             if dist<NEO_dist then nea:=1 else nea:=0;
             qry:='INSERT INTO '+ast_daypos+' (id,epoch,ra,de,mag,near_earth) VALUES ('
                 +'"'+id+'"'
                 +',"'+formatfloat(f1,epoch)+'"'
                 +',"'+inttostr(ira)+'"'
                 +',"'+inttostr(idec)+'"'
                 +',"'+inttostr(imag)+'"'
                 +',"'+inttostr(nea)+'")';
             db2.Query(qry);
end;

Function TPlanet.NewComDay(newjd,limitmag:double; cfgsc: Tconf_skychart):boolean;
var qry : string;
    currentjd : double;
    currentmag,lmag:integer;
begin
try
// check for old table version
qry:='select distinct(near_earth) from '+cfgsc.com_daypos;
db1.Query(qry);
if db1.Rowcount=0 then begin
  qry:='drop table '+cfgsc.com_daypos;
  db1.Query(qry);
  qry:='drop table '+cfgsc.com_day;
  db1.Query(qry);
end;
/////
lmag:=round(limitmag*10);
qry:='SELECT jd,limit_mag from '+cfgsc.com_day;
db1.Query(qry);
if db1.Rowcount>0 then begin
   currentjd:=strtoint(db1.Results[0][0]);
   currentmag:=strtoint(db1.Results[0][1]);
end else begin
  currentjd:=-99999999;
  currentmag:=-999;
end;
if (currentjd=trunc(newjd))and(currentmag=lmag) then result:=true
 else begin
     if cfgsc.com_day<>db1.QueryOne(showtable[DBtype]+' "'+cfgsc.com_day+'"') then
        db1.Query('CREATE TABLE '+cfgsc.com_day+create_table_com_day);
     if cfgsc.com_daypos<>db1.QueryOne(showtable[DBtype]+' "'+cfgsc.com_daypos+'"') then begin
        db1.Query('CREATE TABLE '+cfgsc.com_daypos+create_table_com_day_pos);
        db1.Query('CREATE UNIQUE INDEX IDX_'+cfgsc.com_daypos+' ON '+cfgsc.com_daypos+' (id,epoch)');
        db1.Query('CREATE INDEX IDX2_'+cfgsc.com_daypos+' ON '+cfgsc.com_daypos+' (near_earth)');
     end;
     db1.UnLockTables;
     db1.StartTransaction;
     db1.TruncateTable(cfgsc.com_day);
     db1.TruncateTable(cfgsc.com_daypos);
     db1.LockTables(cfgsc.com_day+' WRITE, '+cfgsc.com_daypos+' WRITE, cdc_com_elem READ');
     qry:='SELECT distinct(id) from cdc_com_elem';
     db2.CallBackOnly:=true;
     db2.OnFetchRow:=@NewComDayCallback;
     jdnew:=newjd;
     jdchart:=cfgsc.JDChart;
     com_daypos:=cfgsc.com_daypos;
     com_limitmag:=limitmag;
     n_com:=0;
     db2.Query(qry);
     db2.CallBackOnly:=false;
     db2.OnFetchRow:=nil;
     if n_com>0 then begin
       result:=true;
       qry:='INSERT INTO '+cfgsc.com_day+' (jd,limit_mag)'
           +' VALUES ("'+inttostr(trunc(newjd))+'","'+inttostr(lmag)+'")';
       db1.Query(qry);
       db1.UnLockTables;
       db1.Commit;
       db1.flush('tables');
     end else begin
       result:=false;
       db1.UnLockTables;
       db1.Commit;
       db1.flush('tables');
       end;
end;
except
  result:=false;
  db2.CallBackOnly:=false;
  db2.OnFetchRow:=nil;
end;
end;

Procedure TPlanet.NewComDayCallback(Sender:TObject; Row:TResultRow);
var qry,id,elem_id : string;
    imag,ira,idec,neo:integer;
    dist,r,elong,phase,h,g,ap,an,ic,ec,eq,epoch,ra,dec,mag,tp,q,diam,lc,car,cde,rc,xc,yc,zc: double;
    nam:string;
begin
       id:=row[0];
       if cdb.GetComElemEpoch(id,jdnew,epoch,tp,q,ec,ap,an,ic,h,g,eq,nam,elem_id) then begin
         inc(n_com);
         InitComet(tp,q,ec,ap,an,ic,h,g,eq,nam);
         Comet(jdnew,false,ra,dec,dist,r,elong,phase,mag,diam,lc,car,cde,rc,xc,yc,zc);
         if mag<com_limitmag then begin
            precession(jd2000,jdchart,ra,dec);
            ira:=round(ra*1000);
            idec:=round(dec*1000);
            imag:=round(mag*10);
            if dist<NEO_dist then neo:=1 else neo:=0;
            qry:='INSERT INTO '+com_daypos+' (id,epoch,ra,de,mag,near_earth) VALUES ('
                +'"'+id+'"'
                +',"'+formatfloat(f1,epoch)+'"'
                +',"'+inttostr(ira)+'"'
                +',"'+inttostr(idec)+'"'
                +',"'+inttostr(imag)+'"'
                +',"'+inttostr(neo)+'")';
            db1.Query(qry);
         end;
       end;
end;

Procedure TPlanet.ComputeAsteroid(cfgsc: Tconf_skychart);
var ra,dec,dist,r,elong,phase,magn,jdt,st0,q : double;
  epoch,h,g,ma,ap,an,ic,ec,sa,eq,d,da,xc,yc,zc : double;
  qry,id,ref,nam,elem_id :string;
  j,i,SimNb: integer;
begin
try
while lockdb do application.ProcessMessages; lockdb:=true;
cdb.AstMsg:='';
cfgsc.ast_day:='cdc_ast_day_'+cfgsc.chartname;
cfgsc.ast_daypos:='cdc_ast_day_pos_'+cfgsc.chartname;
cfgsc.AsteroidNb:=0;
if not db1.Active then cfgsc.ShowAsteroid:=false;
if not cfgsc.ShowAsteroidValid then exit;
if not NewAstDay(cfgsc.CurJD,cfgsc.AstmagMax,cfgsc) then begin
   cfgsc.ShowAsteroid:=false;
   exit;
end;
d:=maxvalue([0.6*cfgsc.fov,0.09]);
da:=d/cos(cfgsc.decentre);
qry:='SELECT id,epoch from '+cfgsc.ast_daypos+' where';
qry:=qry+' (mag<='+inttostr(round((cfgsc.StarMagMax+cfgsc.AstMagDiff)*10))+' and';
if cfgsc.NP or cfgsc.SP then
   qry:=qry+' (ra>0 and ra<'+inttostr(round(1000*(pi2)))+')'
else if (cfgsc.racentre+da)>pi2 then
   qry:=qry+' (ra>'+inttostr(round(1000*(cfgsc.racentre-da)))
           +' or ra<'+inttostr(round(1000*(cfgsc.racentre+da-pi2)))+')'
else if (cfgsc.racentre-da)<0 then
   qry:=qry+' (ra>'+inttostr(round(1000*(cfgsc.racentre-da+pi2)))
           +' or ra<'+inttostr(round(1000*(cfgsc.racentre+da)))+')'
else
   qry:=qry+' (ra>'+inttostr(round(1000*(cfgsc.racentre-da)))
           +' and ra<'+inttostr(round(1000*(cfgsc.racentre+da)))+')';

qry:=qry+' and (de>'+inttostr(round(1000*(cfgsc.decentre-d)))
    +' and de<'+inttostr(round(1000*(cfgsc.decentre+d)))+')) or (near_earth=1)'
    +' limit '+inttostr(MaxAsteroid) ;
db2.Query(qry);
if db2.Rowcount>0 then begin
  if db2.Rowcount=MaxAsteroid then cfgsc.msg:=cfgsc.msg+'More than '+inttostr(MaxAsteroid)+' asteroids, result truncated!';
  cfgsc.Simnb:=min(cfgsc.Simnb,MaxAstSim);
  if cfgsc.SimObject[12] then SimNb:=cfgsc.SimNb
                         else SimNb:=1;
  if SimNb>cfgsc.AsteroidLstSize then begin
     SetLength(cfgsc.AsteroidLst,SimNb);
     SetLength(cfgsc.AsteroidName,SimNb);
     cfgsc.AsteroidLstSize:=SimNb;
  end;
  for j:=0 to SimNb-1 do begin
    jdt:=cfgsc.CurJD+j*cfgsc.SimD+j*cfgsc.SimH/24+j*cfgsc.SimM/60/24+j*cfgsc.SimS/3600/24;
    st0:=Rmod(cfgsc.CurST+ 1.00273790935*(j*cfgsc.SimD*24+j*cfgsc.SimH+j*cfgsc.SimM/60+j*cfgsc.SimS/3600)*15*deg2rad,pi2);
    for i:=0 to db2.Rowcount-1 do begin
       id:=db2.Results[i][0];
       epoch:=strtofloat(trim(db2.Results[i][1]));
       if cdb.GetAstElem(id,epoch,h,g,ma,ap,an,ic,ec,sa,eq,ref,nam,elem_id) then begin
          InitAsteroid(epoch,h,g,ma,ap,an,ic,ec,sa,eq,nam);
          Asteroid(jdt,true,ra,dec,dist,r,elong,phase,magn,xc,yc,zc);
          precession(jd2000,cfgsc.jdchart,ra,dec);
          if cfgsc.PlanetParalaxe then Paralaxe(st0,dist,ra,dec,ra,dec,q,cfgsc);
          if cfgsc.ApparentPos then apparent_equatorial(ra,dec,cfgsc);
          cfgsc.AsteroidName[j,i+1,1]:=id;
          cfgsc.AsteroidName[j,i+1,2]:=nam;
          cfgsc.AsteroidLst[j,i+1,1]:=ra;
          cfgsc.AsteroidLst[j,i+1,2]:=dec;
          cfgsc.AsteroidLst[j,i+1,3]:=magn;
          cfgsc.AsteroidLst[j,i+1,4]:=jdt;
          cfgsc.AsteroidLst[j,i+1,5]:=epoch;
       end;
    end;
  end;
end;
cfgsc.AsteroidNb:=db2.Rowcount;
cfgsc.msg:=cfgsc.msg+blank+cdb.AstMsg;
finally
  lockdb:=false;
end;
end;

Procedure TPlanet.ComputeComet(cfgsc: Tconf_skychart);
var ra,dec,dist,r,elong,phase,magn,jdt,st0,q : double;
  epoch,h,g,ap,an,ic,ec,eq,d,da,tp,diam,lc,car,cde,rc,xc,yc,zc : double;
  qry,id,nam,elem_id :string;
  j,i,SimNb: integer;
begin
try
while lockdb do application.ProcessMessages; lockdb:=true;
cdb.ComMsg:='';
cfgsc.com_day:='cdc_com_day_'+cfgsc.chartname;
cfgsc.com_daypos:='cdc_com_day_pos_'+cfgsc.chartname;
cfgsc.CometNb:=0;
if not db1.Active then cfgsc.ShowComet:=false;
if not cfgsc.ShowCometValid then exit;
if not NewComDay(cfgsc.CurJD,cfgsc.CommagMax,cfgsc) then begin
   cfgsc.ShowComet:=false;
   exit;
end;
d:=maxvalue([0.6*cfgsc.fov,0.09]);
da:=d/cos(cfgsc.decentre);
qry:='SELECT id,epoch from '+cfgsc.com_daypos+' where';
if cfgsc.StarFilter then qry:=qry+' (mag<='+inttostr(round((cfgsc.StarMagMax+cfgsc.ComMagDiff)*10))+' and';
if cfgsc.NP or cfgsc.SP then
   qry:=qry+' (ra>0 and ra<'+inttostr(round(1000*(pi2)))+')'
else if (cfgsc.racentre+da)>pi2 then
   qry:=qry+' (ra>'+inttostr(round(1000*(cfgsc.racentre-da)))
           +' or ra<'+inttostr(round(1000*(cfgsc.racentre+da-pi2)))+')'
else if (cfgsc.racentre-da)<0 then
   qry:=qry+' (ra>'+inttostr(round(1000*(cfgsc.racentre-da+pi2)))
           +' or ra<'+inttostr(round(1000*(cfgsc.racentre+da)))+')'
else
   qry:=qry+' (ra>'+inttostr(round(1000*(cfgsc.racentre-da)))
           +' and ra<'+inttostr(round(1000*(cfgsc.racentre+da)))+')';

qry:=qry+' and (de>'+inttostr(round(1000*(cfgsc.decentre-d)))
    +' and de<'+inttostr(round(1000*(cfgsc.decentre+d)))+')) or (near_earth=1)'
    +' limit '+inttostr(MaxComet) ;
db2.Query(qry);
if db2.Rowcount>0 then begin
  cfgsc.Simnb:=min(cfgsc.Simnb,MaxAstSim);
  if cfgsc.SimObject[13] then SimNb:=cfgsc.SimNb
                         else SimNb:=1;
  if SimNb>cfgsc.CometLstSize then begin
     SetLength(cfgsc.CometLst,SimNb);
     SetLength(cfgsc.CometName,SimNb);
     cfgsc.CometLstSize:=SimNb;
  end;
  for j:=0 to SimNb-1 do begin
    jdt:=cfgsc.CurJD+j*cfgsc.SimD+j*cfgsc.SimH/24+j*cfgsc.SimM/60/24+j*cfgsc.SimS/3600/24;
    st0:=Rmod(cfgsc.CurST+ 1.00273790935*(j*cfgsc.SimD*24+j*cfgsc.SimH+j*cfgsc.SimM/60+j*cfgsc.SimS/3600)*15*deg2rad,pi2);
    for i:=0 to db2.Rowcount-1 do begin
       id:=db2.Results[i][0];
       epoch:=strtofloat(trim(db2.Results[i][1]));
       if cdb.GetComElem(id,epoch,tp,q,ec,ap,an,ic,h,g,eq,nam,elem_id) then begin
          InitComet(tp,q,ec,ap,an,ic,h,g,eq,nam);
          Comet(jdt,true,ra,dec,dist,r,elong,phase,magn,diam,lc,car,cde,rc,xc,yc,zc);
          precession(jd2000,cfgsc.jdchart,ra,dec);
          precession(jd2000,cfgsc.jdchart,car,cde);
          if cfgsc.PlanetParalaxe then begin
             Paralaxe(st0,dist,ra,dec,ra,dec,q,cfgsc);
             Paralaxe(st0,rc,car,cde,car,cde,q,cfgsc);
          end;
          if cfgsc.ApparentPos then begin
             apparent_equatorial(ra,dec,cfgsc);
             apparent_equatorial(car,cde,cfgsc);
          end;
          cfgsc.CometName[j,i+1,1]:=id;
          cfgsc.CometName[j,i+1,2]:=nam;
          cfgsc.CometLst[j,i+1,1]:=ra;
          cfgsc.CometLst[j,i+1,2]:=dec;
          cfgsc.CometLst[j,i+1,3]:=magn;
          cfgsc.CometLst[j,i+1,4]:=diam;
          cfgsc.CometLst[j,i+1,5]:=car;
          cfgsc.CometLst[j,i+1,6]:=cde;
          cfgsc.CometLst[j,i+1,7]:=jdt;
          cfgsc.CometLst[j,i+1,8]:=epoch;
       end;
    end;
  end;
end;
cfgsc.CometNb:=db2.Rowcount;
cfgsc.msg:=cfgsc.msg+blank+cdb.ComMsg;
finally
  lockdb:=false;
end;
end;

function TPlanet.FindAsteroidName(astname: String; var ra,de:double; cfgsc: Tconf_skychart):boolean;
var dist,r,elong,phase,magn : double;
  epoch,h,g,ma,ap,an,ic,ec,sa,eq,xc,yc,zc : double;
  qry,id,ref,nam,elem_id :string;
  ira,idec,imag: integer;
begin
result:=false;
if (not db1.Active)or(not cfgsc.ephvalid) then exit;
qry:='SELECT id FROM cdc_ast_name'
    +' where name like "%'+astname+'%"'
    +' limit 1';
id:=db1.QueryOne(qry);
if id='' then exit;
if cdb.GetAstElemEpoch(id,cfgsc.curjd,epoch,h,g,ma,ap,an,ic,ec,sa,eq,ref,nam,elem_id) then begin
   InitAsteroid(epoch,h,g,ma,ap,an,ic,ec,sa,eq,nam);
   Asteroid(cfgsc.curjd,true,ra,de,dist,r,elong,phase,magn,xc,yc,zc);
   precession(jd2000,cfgsc.jdchart,ra,de);
   if cfgsc.PlanetParalaxe then Paralaxe(cfgsc.CurST,dist,ra,de,ra,de,r,cfgsc);
   ira:=round(ra*1000);
   idec:=round(de*1000);
   imag:=round(magn*10);
   qry:='INSERT INTO '+cfgsc.ast_daypos+' (id,epoch,ra,de,mag) VALUES ('
        +'"'+id+'"'
        +',"'+formatfloat(f1,epoch)+'"'
        +',"'+inttostr(ira)+'"'
        +',"'+inttostr(idec)+'"'
        +',"'+inttostr(imag)+'")';
   db1.Query(qry);
   db1.flush('tables');
   precession(cfgsc.JDchart,jd2000,ra,de);
   result:=true;
end
 else result:=false;
end;

function TPlanet.FindCometName(comname: String; var ra,de:double; cfgsc: Tconf_skychart):boolean;
var dist,r,elong,phase,magn : double;
  epoch,h,g,ap,an,ic,ec,eq,tp,q,diam,lc,car,cde,rc,xc,yc,zc : double;
  qry,id,nam,elem_id :string;
  ira,idec,imag: integer;
begin
result:=false;
if (not db1.Active)or(not cfgsc.ephvalid) then exit;
qry:='SELECT id FROM cdc_com_name'
    +' where name like "%'+comname+'%"'
    +' limit 1';
id:=db1.QueryOne(qry);
if id='' then exit;
if cdb.GetComElemEpoch(id,cfgsc.curjd,epoch,tp,q,ec,ap,an,ic,h,g,eq,nam,elem_id) then begin
   InitComet(tp,q,ec,ap,an,ic,h,g,eq,nam);
   Comet(cfgsc.curjd,true,ra,de,dist,r,elong,phase,magn,diam,lc,car,cde,rc,xc,yc,zc);
   precession(jd2000,cfgsc.jdchart,ra,de);
   ira:=round(ra*1000);
   idec:=round(de*1000);
   imag:=round(magn*10);
   qry:='INSERT INTO '+cfgsc.com_daypos+' (id,epoch,ra,de,mag) VALUES ('
        +'"'+id+'"'
        +',"'+formatfloat(f1,epoch)+'"'
        +',"'+inttostr(ira)+'"'
        +',"'+inttostr(idec)+'"'
        +',"'+inttostr(imag)+'")';
   db1.Query(qry);
   db1.flush('tables');
   precession(cfgsc.JDchart,jd2000,ra,de);
   result:=true;
end
 else result:=false;
end;

function TPlanet.FindAsteroid(x1,y1,x2,y2:double; nextobj:boolean; cfgsc: Tconf_skychart; var nom,mag,date,desc:string; trunc:boolean=true):boolean;
var
   yy,mm,dd : integer;
   tar,tde : double;
   h,g,ma,ap,an,ic,ec,sa,eq,ra,dec,dist,r,elong,phase,magn,xc,yc,zc :double;
   ref,nam,elem_id :string;
   jdt,hh: double;
   sar,sde,shh,sdp,sdist,sphase : string;
const d1='0.0'; d2='0.00';
begin
if not nextobj then begin CurrentAstStep:=0;CurrentAsteroid:=0; end;
result := false;
desc:='';tar:=1;tde:=1;
if cfgsc.ephvalid and (cfgsc.AsteroidNb>0) then repeat
  inc(CurrentAsteroid);
  if CurrentAsteroid>cfgsc.AsteroidNb then begin
     inc(CurrentAstStep);
     if (not cfgsc.SimObject[12]) or nextobj or (CurrentAstStep>=cfgsc.SimNb) then
        break
     else begin CurrentAsteroid:=0;continue;end;
  end;
  tar:=NormRa(cfgsc.AsteroidLst[CurrentAstStep,CurrentAsteroid,1]);
  tde:=cfgsc.AsteroidLst[CurrentAstStep,CurrentAsteroid,2];
  // search if this asteroid is at the position
  if trunc then begin
  if (tar<x1) or (tar>x2) or
     (tde<y1) or (tde>y2)
     then begin
        // no
        result:=false;
     end
     else result := true;
  end
  else result := true;
until result;
cfgsc.FindOK:=result;
if result then begin
  cfgsc.FindSize:=0;
  cfgsc.FindRA:=tar;
  cfgsc.FindDec:=tde;
  cfgsc.FindPM:=false;
  cfgsc.FindType:=ftAst;
  cfgsc.TrackRA:=cfgsc.FindRA;
  cfgsc.TrackDec:=cfgsc.FindDec;
  sar := ARpToStr(rad2deg*tar/15) ;
  sde := DEpToStr(rad2deg*tde) ;
  jdt:=cfgsc.AsteroidLst[CurrentAstStep,CurrentAsteroid,4];
  cfgsc.FindSimjd:=jdt;
//  str(jdt:12:4,sjd);
  djd(jdt+(cfgsc.TimeZone-cfgsc.DT_UT)/24,yy,mm,dd,hh);
  shh := ARtoStr3(rmod(hh,24));
  date:=Date2Str(yy,mm,dd)+blank+shh;
  cdb.GetAstElem(cfgsc.AsteroidName[CurrentAstStep,CurrentAsteroid,1],cfgsc.AsteroidLst[CurrentAstStep,CurrentAsteroid,5],h,g,ma,ap,an,ic,ec,sa,eq,ref,nam,elem_id);
  InitAsteroid(cfgsc.AsteroidLst[CurrentAstStep,CurrentAsteroid,5],h,g,ma,ap,an,ic,ec,sa,eq,nam);
  Asteroid(jdt,true,ra,dec,dist,r,elong,phase,magn,xc,yc,zc);
  nom:=nam;
  str(cfgsc.AsteroidLst[CurrentAstStep,CurrentAsteroid,3]:5:1,mag);
  str(r:7:4,sdp);
  str(dist:7:4,sdist);
  str((rad2deg*phase):4:0,sphase);
  Desc := sar+tab+sde+tab
          +' As'+tab+nom+tab
          +'m:'+mag+tab
          +'phase:'+sphase+blank+ldeg+tab
          +'dist:'+sdist+'au'+tab
          +'rsol:'+sdp+'au'+tab
          +'vel:'+ formatfloat(f1,42.1219*sqrt(1/r-1/(2*sa)))+'km/s'+tab
          +'date:'+date+tab
          +'ref:'+ref;
  djd(cfgsc.AsteroidLst[CurrentAstStep,CurrentAsteroid,5],yy,mm,dd,hh);
  Desc := Desc +'/'+Date2Str(yy,mm,dd)+tab; // ephemeris date
  cfgsc.TrackType:=3;
  cfgsc.TrackId:=cfgsc.AsteroidName[CurrentAstStep,CurrentAsteroid,1];
  cfgsc.TrackEpoch:=cfgsc.AsteroidLst[CurrentAstStep,CurrentAsteroid,5];
  cfgsc.TrackName:=nom;
  cfgsc.FindX:=xc;
  cfgsc.FindY:=yc;
  cfgsc.FindZ:=zc;
end;
cfgsc.FindName:=nom;
cfgsc.FindDesc:=Desc;
cfgsc.FindNote:='';
end;

function TPlanet.FindComet(x1,y1,x2,y2:double; nextobj:boolean; cfgsc: Tconf_skychart; var nom,mag,date,desc:string; trunc:boolean=true):boolean;
var
   yy,mm,dd : integer;
   tar,tde : double;
   h,g,ap,an,ic,ec,eq,ra,dec,dist,r,elong,phase,magn,q,tp,diam,lc,car,cde,rc,xc,yc,zc :double;
   nam,elem_id :string;
   jdt,hh: double;
   sar,sde,shh,sdp,sdist,sphase,svel : string;
const d1='0.0'; d2='0.00';
begin
if not nextobj then begin CurrentComStep:=0;CurrentComet:=0; end;
result := false;
desc:='';tar:=1;tde:=1;
if cfgsc.ephvalid and (cfgsc.CometNb>0) then repeat
  inc(CurrentComet);
  if CurrentComet>cfgsc.CometNb then begin
     inc(CurrentComStep);
     if (not cfgsc.SimObject[13]) or nextobj or (CurrentComStep>=cfgsc.SimNb) then
        break
     else begin CurrentComet:=0;continue;end;
  end;
  tar:=NormRa(cfgsc.CometLst[CurrentComStep,CurrentComet,1]);
  tde:=cfgsc.CometLst[CurrentComStep,CurrentComet,2];
  // search if this comet is at the position
  if trunc then begin
  if (tar<x1) or (tar>x2) or
     (tde<y1) or (tde>y2)
     then begin
        // no
        result:=false;
     end
     else result := true;
  end
  else result:=true;
until result;
cfgsc.FindOK:=result;
if result then begin
  cfgsc.FindSize:=0;
  cfgsc.FindRA:=tar;
  cfgsc.FindDec:=tde;
  cfgsc.FindPM:=false;
  cfgsc.FindType:=ftCom;
  cfgsc.TrackRA:=cfgsc.FindRA;
  cfgsc.TrackDec:=cfgsc.FindDec;
  sar := ARpToStr(rad2deg*tar/15) ;
  sde := DEpToStr(rad2deg*tde) ;
  jdt:=cfgsc.CometLst[CurrentComStep,CurrentComet,7];
  cfgsc.FindSimjd:=jdt;
  djd(jdt+(cfgsc.TimeZone-cfgsc.DT_UT)/24,yy,mm,dd,hh);
  shh := ARtoStr3(rmod(hh,24));
  date:=Date2Str(yy,mm,dd)+blank+shh;
  cdb.GetComElem(cfgsc.CometName[CurrentComStep,CurrentComet,1],cfgsc.CometLst[CurrentComStep,CurrentComet,8],tp,q,ec,ap,an,ic,h,g,eq,nam,elem_id);
  InitComet(tp,q,ec,ap,an,ic,h,g,eq,nam);
  Comet(jdt,true,ra,dec,dist,r,elong,phase,magn,diam,lc,car,cde,rc,xc,yc,zc);
  nom:=nam;
  str(cfgsc.CometLst[CurrentComStep,CurrentComet,3]:5:1,mag);
  str(r:7:4,sdp);
  str(dist:7:4,sdist);
  str((rad2deg*phase):4:0,sphase);
  if ec<1 then
     svel:=formatfloat(f1,42.1219*sqrt(1/r-1/(2*q/(1-ec))))+'km/s'
  else
     svel:='n/a';  { TODO : velocity for parabolic and hyperbolic orbits }
  Desc := sar+tab+sde+tab
          +' Cm'+tab+nom+tab
          +'m:'+mag+tab
          +'phase:'+sphase+blank+ldeg+tab
          +'dist:'+sdist+'au'+tab
          +'rsol:'+sdp+'au'+tab
          +'vel:'+svel+tab
          +'tl:'+formatfloat(f2,lc)+'au'+tab
          +'date:'+date+tab
          +'ref:'+elem_id;
  djd(cfgsc.CometLst[CurrentComStep,CurrentComet,8],yy,mm,dd,hh);
  Desc := Desc +'/'+Date2Str(yy,mm,dd)+tab;
  cfgsc.TrackType:=2;
  cfgsc.TrackId:=cfgsc.CometName[CurrentComStep,CurrentComet,1];
  cfgsc.TrackEpoch:=cfgsc.CometLst[CurrentComStep,CurrentComet,8];
  cfgsc.TrackName:=nom;
  cfgsc.FindX:=xc;
  cfgsc.FindY:=yc;
  cfgsc.FindZ:=zc;
end;
cfgsc.FindName:=nom;
cfgsc.FindDesc:=Desc;
cfgsc.FindNote:='';
end;

Function TPlanet.PrepareAsteroid(jdt:double; msg:Tstrings):boolean;
var jds,qry : string;
begin
try
jds:=formatfloat(f1,jdt);
msg.Add(Format(rsBeginProcess, [jds, jddate(jdt)]));
db1.StartTransaction;
db1.LockTables('cdc_ast_mag WRITE, cdc_ast_elem READ');
msg.Add(rsDeletePrevio);
application.processmessages;
db1.Query('DELETE from cdc_ast_mag where jd='+jds);
msg.Add(rsGetAsteroidL);
application.processmessages;
qry:='SELECT distinct(id) from cdc_ast_elem';
db2.CallBackOnly:=true;
db2.OnFetchRow:=@PrepareAsteroidCallback;
n_ast:=0;
jdnew:=jdt;
smsg:=msg;
db2.Query(qry);
db2.CallBackOnly:=false;
db2.OnFetchRow:=nil;
db1.UnLockTables;
db1.Commit;
db1.flush('tables');
cdb.TruncateDailyAsteroid;
msg.Add(Format(rsEndProcessin, [inttostr(n_ast)]));
result:=(n_ast>0);
if not result then begin
   msg.Add(rsErrorPleaseC);
   sleep(3000);
end;
except
  result:=false;
  msg.Add(rsErrorPleaseC);
  db2.CallBackOnly:=false;
end;
end;

Procedure TPlanet.PrepareAsteroidCallback(Sender:TObject; Row:TResultRow);
var id,jds,ref,nam,qry,elem_id : string;
    epoch,h,g,ma,ap,an,ic,ec,sa,eq : double;
    ra,dec,dist,r,elong,phase,magn,xc,yc,zc : Double;
begin
    id:=row[0];
    if cdb.GetAstElemEpoch(id,jdnew,epoch,h,g,ma,ap,an,ic,ec,sa,eq,ref,nam,elem_id) then begin
         inc(n_ast);
         InitAsteroid(epoch,h,g,ma,ap,an,ic,ec,sa,eq,nam);
         Asteroid(jdnew,false,ra,dec,dist,r,elong,phase,magn,xc,yc,zc);
         jds:=formatfloat(f1,jdnew);
         if dist<NEO_dist then magn:=0;
         qry:='INSERT INTO cdc_ast_mag (id,jd,epoch,mag,elem_id) VALUES ('
             +'"'+id+'"'
             +',"'+jds+'"'
             +',"'+formatfloat(f1,epoch)+'"'
             +',"'+inttostr(round(magn*10))+'"'
             +',"'+elem_id+'"'+')';
         db1.Query(qry);
      end;
    if (n_ast mod 10000)=0 then begin smsg.Add(Format(rsProcessing, [inttostr(
      n_ast)])); application.processmessages; end;
end;

Procedure TPlanet.PlanetAltitude(pla: integer; jd0,hh: double; cfgsc: Tconf_skychart; var har,sina: double);
var jdt,ra,de,dm4,dm5,dm6,dm7,dm8,dm9,dm10,dm11,dm12,dm13: double;
begin
jdt:=jd0+(hh-cfgsc.TimeZone-cfgsc.DT_UT)/24;
case pla of
1..9: Planet(pla,jdt,ra,de,dm4,dm5,dm6,dm7,dm8,dm9,dm10,dm11,dm12,dm13);
10 :  Sun(jdt,ra,de,dm4,dm5);
11 :  Moon(jdt,ra,de,dm4,dm5,dm6,dm7,dm8);
end;
precession(jd2000,jd0,ra,de);
har:=rmod(sidtim(jd0, hh-cfgsc.TimeZone, cfgsc.Obslongitude) - ra + pi2, pi2);
sina:=(sin(deg2rad*cfgsc.Obslatitude) * sin(de) + cos(deg2rad*cfgsc.Obslatitude) * cos(de) * cos(har));
end;

procedure TPlanet.PlanetRiseSet(pla:integer; jd0:double; AzNorth:boolean; var thr,tht,ths,tazr,tazs: string; var jdr,jdt,jds,rar,der,rat,det,ras,des:double ;var i: integer; cfgsc: Tconf_skychart);
var hr,ht,hs,h1,h2,azr,azs,dist,q,diam : double;
    ho,sinho,dt,hh,y1,y2,y3,x1,x2,x3,xmax,ymax,xmax2,ymax2,ymax0,ra,de,dm5,dm6,dm7,dm8,dm9,dm10,dm11,dm12,dm13: double;
    frise,fset,ftransit: boolean;
    n: integer;
const  na='      ';
begin
jdr:=0;jdt:=0;jds:=0;ymax0:=0;
frise := false;fset := false;ftransit := false;
case pla of
1..9: ho:=-0.5667;
10 : ho:=-0.8333;
11: begin
    Moon(jd0,ra,de,dist,dm5,diam,dm7,dm8);
    ho:=(8.794/dist/3600)-0.5748*cfgsc.ObsRefractionCor-diam/2/3600-0.04;
    end;
end;
sinho:=sin(deg2rad*ho);
dt := jd0;
hh:=1;
PlanetAltitude(pla,dt,hh-1.0,cfgsc,x1,y1);
if x1>pi then x1:=x1-pi2;
y1:=y1-sinho;
// loop for event
while ( (hh < 25) and ( (fset=false) or (frise=false) or (ftransit=false) )) do begin
   PlanetAltitude(pla,dt,hh,cfgsc,x2,y2);
   if x2>pi then x2:=x2-pi2;
   y2:=y2-sinho;
   PlanetAltitude(pla,dt,hh+1.0,cfgsc,x3,y3);
   if x3>pi then x3:=x3-pi2;
   y3:=y3-sinho;
   int4(y1,y2,y3,n,h1,h2,xmax,ymax);
   // one rise/set
   if (n=1) then begin
      if (y1<0.0) then begin
         hr := hh + h1;
	 frise := true;
      end else begin
         hs := hh + h1;
	 fset := true;
      end;
   end;
   // two rise/set
   if (n = 2) then begin
      if (ymax < 0.0) then begin
         hr := hh + h2;
	 hs := hh + h1;
      end else begin
         hr := hh + h1;
	 hs := hh + h2;
      end;
   end;
   // transit
   if ((abs(xmax)<1) and (ymax>ymax0)) or
      ((hh<23) and (hh>1) and (abs(xmax)<1.5) and (ymax>ymax0)) //this one to correct for some imprecision in the extrema when very near to a time boundary
      then begin
         int4(x1,x2,x3,n,h1,h2,xmax2,ymax2);
         if (n=1) then begin
            ht := hh + h1;
            ymax0:=ymax;
            ftransit := true;
         end;
   end;
   y1 := y3;
   x1 := x3;
   hh:=hh+2;
end;
// format result
if (frise or fset) then begin    // rise (and/or) set and transit
   i:=0;
   if (frise) then begin       // rise
        thr:=armtostr(hr);
        jdr:=jd0+(hr-cfgsc.TimeZone)/24;
        case pla of
        1..9: Planet(pla,jdr,ra,de,dist,dm5,dm6,dm7,dm8,dm9,dm10,dm11,dm12,dm13);
        10 :  Sun(jdr,ra,de,dist,dm5);
        11 :  Moon(jdr,ra,de,dist,dm5,dm6,dm7,dm8);
        end;
        precession(jd2000,jd0,ra,de);
        if cfgsc.PlanetParalaxe then begin
           Paralaxe(SidTim(jd0,hr-cfgsc.TimeZone,cfgsc.ObsLongitude),dist,ra,de,rar,der,q,cfgsc);
        end else begin
           rar:=ra;
           der:=de;
        end;
        Eq2Hz(sidtim(jd0,hr-cfgsc.TimeZone,cfgsc.ObsLongitude)-ra,de,azr,dist,cfgsc);
        if AzNorth then Azr:=rmod(Azr+pi,pi2);
        tazr:=demtostr(rad2deg*Azr);
      end
      else begin
        thr:=na;
        tazr:=na;
      end;
   if (fset) then begin       // set
        ths:=armtostr(hs);
        jds:=jd0+(hs-cfgsc.TimeZone)/24;
        case pla of
        1..9: Planet(pla,jds,ra,de,dist,dm5,dm6,dm7,dm8,dm9,dm10,dm11,dm12,dm13);
        10 :  Sun(jds,ra,de,dist,dm5);
        11 :  Moon(jds,ra,de,dist,dm5,dm6,dm7,dm8);
        end;
        precession(jd2000,jd0,ra,de);
        if cfgsc.PlanetParalaxe then begin
           Paralaxe(SidTim(jd0,hs-cfgsc.TimeZone,cfgsc.ObsLongitude),dist,ra,de,ras,des,q,cfgsc);
        end else begin
           ras:=ra;
           des:=de;
        end;
        Eq2Hz(sidtim(jd0,hs-cfgsc.TimeZone,cfgsc.ObsLongitude)-ra,de,azs,dist,cfgsc);
        if AzNorth then Azs:=rmod(Azs+pi,pi2);
        tazs:=demtostr(rad2deg*Azs);
      end
      else begin
        ths:=na;
        tazs:=na;
      end;
   if (ftransit) then begin      // transit
        tht:=armtostr(ht);
        jdt:=jd0+(ht-cfgsc.TimeZone)/24;
        case pla of
        1..9: Planet(pla,jdt,ra,de,dist,dm5,dm6,dm7,dm8,dm9,dm10,dm11,dm12,dm13);
        10 :  Sun(jdt,ra,de,dist,dm5);
        11 :  Moon(jdt,ra,de,dist,dm5,dm6,dm7,dm8);
        end;
        precession(jd2000,jd0,ra,de);
        if cfgsc.PlanetParalaxe then begin
           Paralaxe(SidTim(jd0,ht-cfgsc.TimeZone,cfgsc.ObsLongitude),dist,ra,de,rat,det,q,cfgsc);
        end else begin
           rat:=ra;
           det:=de;
        end;
      end
      else begin
        tht:=na;
      end;
end else begin
   if (ftransit) then begin   // circumpolar
        i:=1;
        thr:=na;
        ths:=na;
        tazr:=na;
        tazs:=na;
        tht:=armtostr(ht);
        jdt:=jd0+(ht-cfgsc.TimeZone)/24;
        case pla of
        1..9: Planet(pla,jdt,ra,de,dist,dm5,dm6,dm7,dm8,dm9,dm10,dm11,dm12,dm13);
        10 :  Sun(jdt,ra,de,dist,dm5);
        11 :  Moon(jdt,ra,de,dist,dm5,dm6,dm7,dm8);
        end;
        precession(jd2000,jd0,ra,de);
        if cfgsc.PlanetParalaxe then begin
           Paralaxe(SidTim(jd0,ht-cfgsc.TimeZone,cfgsc.ObsLongitude),dist,ra,de,rat,det,q,cfgsc);
        end else begin
           rat:=ra;
           det:=de;
        end;
      end
      else begin  // not visible
        i:=2;
        thr:=na;
        ths:=na;
        tht:=na;
        tazr:=na;
        tazs:=na;
      end;
end;
end;

procedure TPlanet.Twilight(jd0,obslat,obslon: double; out astrom,nautm,civm,cive,naute,astroe: double);
var ars,des,dist,diam: double;
begin
Sun(jd0+0.5,ars,des,dist,diam);
precession(jd2000,jd0,ars,des);
if (ars<0) then ars:=ars+pi2;
Time_Alt(jd0,ars,des,-18,astrom,astroe,obslat,obslon);
Time_Alt(jd0,ars,des,-12,nautm,naute,obslat,obslon);
Time_Alt(jd0,ars,des,-6,civm,cive,obslat,obslon);
end;

procedure TPlanet.SetDE(folder:string);
begin
   de_folder:=folder;
end;

function TPlanet.load_de(t: double): boolean;
var
  i: integer;
  y,m,d : integer;
  hour: double;
begin
djd(t,y,m,d,hour);
if y=de_year then begin
  result:=(de_type<>0);
end else begin
  result:=false;
  de_type:=0;
  for i:=1 to nJPL_DE do begin
     if load_de_file(t,de_folder,JPL_DE[i]) then begin
       result:=true;
       de_type:=JPL_DE[i];
       break;
     end;
  end;
  de_year:=y;
end;
end;

procedure TPlanet.nutation(j:double; var nutl,nuto:double);
var planet_arr: Array_5D;
    ok:boolean;
begin
ok:=false;
if load_de(j) then begin
  ok:=Calc_Planet_de(j, 14, planet_arr,false,0,false);
  if ok then begin
    nutl:=planet_arr[0];
    nuto:=planet_arr[1];
  end;
end;
if not ok then
  nutationMe(j,nutl,nuto);
end;

procedure TPlanet.aberration(j:double; var abv,ehn: coordvector; var ab1,abe,abp,gr2e: double; var abm,asl:boolean );
var planet_arr: Array_5D;
    v,sx,sy,sz: double;
    ps: coordvector;
    ok:boolean;
begin
ok:=false;
// annual aberration
if load_de(j) then begin
  ok:=Calc_Planet_de(j, 3, planet_arr,false,12,true);
  if ok then begin
    // Earth velocity vector divided by c
    abv[1]:=planet_arr[3]/secday/clight;
    abv[2]:=planet_arr[4]/secday/clight;
    abv[3]:=planet_arr[5]/secday/clight;
    sofa_PM(abv,v);
    ab1:=sqrt(1-v*v);
    abm:=true;
  end;
end;
if not ok then begin
  aberrationMe(j,abe,abp);
  abm:=false;
end;
// Sun light deflection
SunRect(j,false,sx,sy,sz,false);
if  Feph_method<>'' then begin
  // twice the gravitational radius of the Sun divided by the Sun-Earth distance
  gr2e:=grsun/(sqr(sx*sx+sy*sy+sz*sz));
  ps[1]:=-sx; ps[2]:=-sy; ps[3]:=-sz;
  // unit vector from the Sun to the Earth
  sofa_PN(ps,v,ehn);
  asl:=true;
end else begin
  asl:=false;
end;
end;


end.

