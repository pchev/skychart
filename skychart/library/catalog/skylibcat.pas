unit skylibcat;
{
Copyright (C) 2000 Patrick Chevalley

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
Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
}
{$mode delphi}{$H+}
interface
uses  gscconst,SysUtils,Math;

type
     coordvector = array[1..3] of double;
     rotmatrix = array[1..3,1..3] of double;

Procedure InitCatWin(ax,ay,bx,by,st,ct,ac,dc,azc,hc,jdt,jdc,sidt,lat : double;
                     pjp,xs,ys,xi,xa,yi,ya : integer; projt : char; np,sp : boolean;
                     peqc: boolean;hax,hay: double);
procedure GetADxy(x,y:Integer ; var a,d : Double);
PROCEDURE Precession(ti,tf : double; VAR ari,dei : double);
Function sgn(x:Double):Double ;
Function PadZeros(x : string ; l :integer) : string;
function Jd(annee,mois,jour :INTEGER; Heure:double):double;
function ecliptic(j:double):double;
Procedure Ecl2Eq(l,b,e: double; var ar,de : double);
Procedure Eq2Ecl(ar,de,e: double; var l,b: double);
Procedure Gal2Eq(l,b: double; var ar,de : double);
Procedure Eq2Gal(ar,de : double; var l,b: double);
function words(str,sep : string; p,n : integer) : string;
procedure FindRegionListWin(var Nsm : integer ;
                            var zonelst,SMlst : array of integer ;
                            var hemislst : array of char;
                          const sN: char='n'; const sS: char='s' );
procedure FindRegionAllWin(var Nsm : integer ;
                            var zonelst,SMlst : array of integer ;
                            var hemislst : array of char;
                          const sN: char='n'; const sS: char='s' );
procedure FindRegionList(x1,x2,y1,y2:Double ;
                          var Nsm : integer ;
                          var zonelst,SMlst : array of integer ;
                          var hemislst : array of char;
                          const sN: char='n'; const sS: char='s' );
procedure FindRegionAll(x1,x2,y1,y2:Double ;
                          var Nsm : integer ;
                          var zonelst,SMlst : array of integer ;
                          var hemislst : array of char;
                          const sN: char='n'; const sS: char='s' );
procedure FindRegionListWin2(var Nsm : integer ;
                            var zonelst,SMlst : array of integer ;
                            var hemislst : array of char;
                            const sN: char='n'; const sS: char='s' );
procedure FindRegionList2(x1,x2,y1,y2:Double ;
                          var Nsm : integer ;
                          var zonelst,SMlst : array of integer ;
                          var hemislst : array of char;
                          const sN: char='n'; const sS: char='s' );
procedure FindRegionListWin7(var Nsm : integer ;
                             var zonelst,SMlst : array of integer ;
                             var hemislst : array of char );
procedure FindRegionList7(x1,x2,y1,y2:Double ;
                          var Nsm : integer ;
                          var zonelst,SMlst : array of integer ;
                          var hemislst : array of char );
procedure FindRegionAllWin7(var Nsm : integer ;
                            var zonelst,SMlst : array of integer ;
                            var hemislst : array of char );
procedure FindRegionAll7(x1,x2,y1,y2:Double ;
                          var Nsm : integer ;
                          var zonelst,SMlst : array of integer ;
                          var hemislst : array of char );
procedure FindRegionList15(x1,x2,y1,y2:Double ;
                          var Nsm : integer ;
                          var SMlst : array of integer );
procedure FindRegionAll15(x1,x2,y1,y2:Double ;
                          var Nsm : integer ;
                          var SMlst : array of integer );
procedure FindRegionListWin15(var Nsm : integer ;var SMlst : array of integer );
procedure FindRegionAllWin15(var Nsm : integer ;var SMlst : array of integer );
procedure FindRegionList30(x1,x2,y1,y2:Double ;
                          var Nsm : integer ;
                          var SMlst : array of integer );
procedure FindRegionListWin30(var Nsm : integer ;var SMlst : array of integer );
procedure FindRegionListWinDS(var Nsm : integer ;
                            var zonelst : array of string) ;
procedure FindRegionListDS(x1,x2,y1,y2:Double ;
                          var Nsm : integer ;
                          var zonelst : array of string);
function InvertI32(X : LongWord) : LongInt;
Function NoSlash(nom : string) : string;
Function Slash(nom : string) : string;
Procedure Precession_rad(j0,j1: double; var ra,de: double);

{$ifdef linux}
const slashchar='/';
{$endif}
{$ifdef darwin}
const slashchar='/';
{$endif}
{$ifdef mswindows}
const slashchar='\';
{$endif}

Const
    tab=#09;
    deg2rad = pi/180;
    rad2deg = 180/pi;
    pi2 = 2*pi;
    pid2 = pi/2;
    secarc = deg2rad/3600;
    jd2000 : double =2451545.0 ;
    jd1950 : double =2433282.4235;
    lg_reg_x7 : array [0..23,1..2] of integer = (
(   3,  730),(   9,  721),(  15,  706),(  21,  685),(  27,  658),(  32,  626),
(  36,  590),(  40,  550),(  43,  507),(  45,  462),(  47,  415),(  48,  367),
(  48,    1),(  47,   49),(  45,   96),(  43,  141),(  40,  184),(  36,  224),
(  32,  260),(  27,  292),(  21,  319),(  15,  340),(   9,  355),(   3,  364));
    lg_reg_x15 : array [0..11,1..2] of integer = (
(  3, 182),(  9, 173),( 15, 158),
( 19, 139),( 22, 117),( 24,  93),
( 24,   1),( 22,  25),( 19,  47),
( 15,  66),(  9,  81),(  3,  90) );
    lg_reg_x30 : array [0..5,1..2] of integer = (
(   4, 47),(  9, 38),( 12, 26),
(  12,  1),(  9, 13),(  4, 22));

var
  arcentre,decentre,acentre,hcentre,CurrentJD,JDChart,JDcatalog,CurrentST,ObsLatitude: Double;
  lcentre,bcentre,lecentre,becentre,ecl: Double;
  xmin,xmax,ymin,ymax,Xshift,Yshift,ProjPole : Integer;
  BxGlb,ByGlb,AxGlb,AyGlb,sintheta,costheta: Double;
  projtype : char;
  Northpoleinmap,Southpoleinmap,ProjEquatorCentered : boolean;
  appcaption : string;
  UseCache : Boolean = True;
  prec_r : rotmatrix;
  prec_j0, prec_j1: double;
  EqpMAT, EqtMAT: rotmatrix;
  haicx, haicy: double;

implementation

function  Rmod(x,y:Double):Double;
BEGIN
    Rmod := x - Int(x/y) * y ;
END  ;

////// Required functions adapted from the SOFA library

procedure sofa_S2C(theta,phi: double; var c: coordvector);
// Convert spherical coordinates to Cartesian.
// THETA    d         longitude angle (radians)
// PHI      d         latitude angle (radians)
var sa,ca,sd,cd: extended;
begin
sincos(theta,sa,ca);
sincos(phi,sd,cd);
c[1]:=ca*cd;
c[2]:=sa*cd;
c[3]:=sd;
end;

procedure sofa_c2s(p: coordvector; var theta,phi: double);
// P-vector to spherical coordinates.
// THETA    d         longitude angle (radians)
// PHI      d         latitude angle (radians)
var x,y,z,d2: double;
begin
X := P[1];
Y := P[2];
Z := P[3];
D2 := X*X + Y*Y;
IF ( D2 = 0 ) THEN
   theta := 0
ELSE
   theta := arctan2(Y,X);
IF ( Z = 0 ) THEN
   phi := 0
ELSE
   phi := arctan2(Z,SQRT(D2));
end;

procedure sofa_cp(p: coordvector; var c: coordvector);
// Copy a p-vector.
var i: integer;
begin
for i:=1 to 3 do c[i]:=p[i];
end;

procedure sofa_cr(r:rotmatrix; var c: rotmatrix);
// Copy an r-matrix.
var i,j: integer;
begin
for j:=1 to 3 do
  for i:=1 to 3 do c[j,i]:=r[j,i];
end;

procedure sofa_rxp(r: rotmatrix; p: coordvector; var rp: coordvector);
// Multiply a p-vector by an r-matrix.
var w: double;
    wrp: coordvector;
    i,j: integer;
begin
// Matrix R * vector P.
for j:=1 to 3 do begin
   W := 0;
   for i:=1 to 3 do begin
      W := W + R[J,I]*P[I];
   end; //i
   WRP[J] := W;
end; //j
// Return the result.
sofa_CP ( WRP, RP );
end;

procedure sofa_tr(r: rotmatrix; var rt: rotmatrix);
// Transpose an r-matrix.
var wm: rotmatrix;
    i,j: integer;
begin
for i:=1 to 3 do begin
   for j:=1 to 3 do begin
      wm[i,j] := r[j,i];
   end;
end;
sofa_cr ( wm, rt );
end;

procedure sofa_rxr(a,b: rotmatrix; var atb: rotmatrix);
// Multiply two r-matrices.
var i,j,k: integer;
    w: double;
    wm: rotmatrix;
begin
for i:=1 to 3 do begin
   for j:=1 to 3 do begin
      W := 0;
      for k:=1 to 3 do begin
         W := W + A[I,K]*B[K,J];
      end; //k
      WM[I,J] := W;
   end; //j
end; //i
sofa_CR ( WM, ATB );
end;

procedure sofa_Zr(var r: rotmatrix);
// Initialize an r-matrix to the null matrix.
var i,j: integer;
begin
for i:=1 to 3 do
  for j:=1 to 3 do
     r[i,j]:=0;
end;

procedure sofa_Ir(var r: rotmatrix);
//   Initialize an r-matrix to the identity matrix.
begin
sofa_Zr(r);
r[1,1] := 1.0;
r[2,2] := 1.0;
r[3,3] := 1.0;
end;

procedure sofa_Rz(psi: double; var r: rotmatrix);
//  Rotate an r-matrix about the z-axis.
var s,c : extended;
    a,w : rotmatrix;
begin
// Matrix representing new rotation.
   sincos(psi,s,c);
   sofa_Ir(a);
   a[1,1] :=  c;
   a[2,1] := -s;
   a[1,2] :=  s;
   a[2,2] :=  c;
// Rotate.
   sofa_Rxr(a, r, w);
// Return result.
   sofa_Cr(w, r);
end;

procedure sofa_Ry(theta: double; var r: rotmatrix);
//  Rotate an r-matrix about the y-axis.
var s,c : extended;
    a,w : rotmatrix;
begin
// Matrix representing new rotation.
   sincos(theta,s,c);
   sofa_Ir(a);
   a[1,1] :=  c;
   a[3,1] :=  s;
   a[1,3] := -s;
   a[3,3] :=  c;
// Rotate.
   sofa_Rxr(a, r, w);
// Return result.
   sofa_Cr(w, r);
end;

Procedure InitCatWin(ax,ay,bx,by,st,ct,ac,dc,azc,hc,jdt,jdc,sidt,lat : double;
                     pjp,xs,ys,xi,xa,yi,ya : integer; projt : char; np,sp : boolean;
                     peqc: boolean;hax,hay: double);
var acc,dcc: double;
begin
   BxGlb:= bx;
   ByGlb:= by;
   AxGlb:= ax;
   AyGlb:=  ay;
   sintheta:=st;
   costheta:=ct;
   arcentre:=ac;
   decentre:=dc;
   CurrentST:=sidt;
   CurrentJD:=jdt;
   JDChart:=jdc;
   ObsLatitude:=lat;
   ProjPole:=pjp;
   Xshift:=xs;
   Yshift:=ys;
   xmin:=xi;
   xmax:=xa;
   ymin:=yi;
   ymax:=ya;
   projtype:=projt;
   Northpoleinmap:=np;
   Southpoleinmap:=sp;
   ProjEquatorCentered:=peqc;
   haicx:=hax;
   haicy:=hay;
   case ProjPole of
   0: begin
      acentre:=azc;    // equat
      hcentre:=hc;
      acc:=arcentre*15;
      dcc:=decentre;
      end;
   1: begin
      acentre:=azc;    // alt-az
      hcentre:=hc;
      acc:=-acentre;
      dcc:=hcentre;
      end;
   2: begin
      lcentre:=azc;    // galactic
      bcentre:=hc;
      acc:=lcentre;
      dcc:=bcentre;
      end;
   3: begin
      lecentre:=azc;   // ecliptic
      becentre:=hc;
      ecl:=ecliptic(JDChart);
      acc:=lecentre;
      dcc:=becentre;
      end;
   end;
   sofa_Ir(EqpMAT);
   sofa_Rz(deg2rad*acc, EqpMAT);
   sofa_Ry(-deg2rad*dcc, EqpMAT);
   sofa_tr(EqpMAT,EqtMAT);
end;

Function PadZeros(x : string ; l :integer) : string;
const zero = '000000000000';
var p : integer;
begin
x:=trim(x);
p:=l-length(x);
result:=copy(zero,1,p)+x;
end;

Procedure XYWindow( x,y: Integer; var Xwindow,Ywindow: double);
Begin
   xwindow:= (x-xshift-Axglb)/BxGlb ;
   ywindow:= (y-yshift-AyGlb)/ByGlb;
end ;

PROCEDURE Precession(ti,tf : double; VAR ari,dei : double);
var ra,de : double ;
//RA en degre!
BEGIN
 ra:=deg2rad*ari;
 de:=deg2rad*dei;
 Precession_rad(ti,tf,ra,de);
 ari:=rad2deg*ra;
 dei:=rad2deg*de;
 ARI:=RMOD(ARI+360.0,360.0);
END  ;

PROCEDURE Eq2Hz(HH,DE : double ; VAR A,h : double );
var l1,d1,h1 : double;
BEGIN
l1:=degtorad(ObsLatitude);
d1:=degtorad(DE);
h1:=degtorad(HH);
h:= radtodeg(arcsin( sin(l1)*sin(d1)+cos(l1)*cos(d1)*cos(h1) ))  ;
A:= radtodeg(arctan2(sin(h1),cos(h1)*sin(l1)-tan(d1)*cos(l1)));
A:=Rmod(A+360,360);
{ refraction meeus91 15.4 }
if h>-1 then h:=minvalue([90.0,h+(1.02/tan(degtorad(h+10.3/(h+5.11))))/60])
        else h:=h+0.64658062088*(h+90)/89;
END ;

Procedure Hz2Eq(A,h : double; var hh,de : double);
var l1,a1,h1 : double;
BEGIN
l1:=degtorad(ObsLatitude);
a1:=degtorad(A);
{ refraction meeus91 15.3 }
if h>-0.3534193791 then h:=minvalue([90.0,h-(1/tan(degtorad(h+(7.31/(h+4.4)))))/60])
        else h:=h-0.65705159*(h+90)/89.64658;
h1:=degtorad(h);
de:= radtodeg(arcsin( sin(l1)*sin(h1)-cos(l1)*cos(h1)*cos(a1) ))  ;
hh:= radtodeg(arctan2(sin(a1),cos(a1)*sin(l1)+tan(h1)*cos(l1)));
hh:=Rmod(hh+360,360);
END ;

function ecliptic(j:double):double;
var u : double;
begin
{meeus91 21.3}
u:=(j-jd2000)/3652500;
result:=23.439291111 +(
        -4680.93*u
        -1.55*u*u
        +1999.25*intpower(u,3)
        -51.38*intpower(u,4)
        -249.67*intpower(u,5)
        -39.05*intpower(u,6)
        +7.12*intpower(u,7)
        +27.87*intpower(u,8)
        +5.79*intpower(u,9)
        +2.45*intpower(u,10)
        )/3600;
result:=deg2rad*result;        
end;

Procedure Ecl2Eq(l,b,e: double; var ar,de : double);
begin
l:=deg2rad*l;
b:=deg2rad*b;
ar:=rad2deg*arctan2(sin(l)*cos(e)-tan(b)*sin(e),cos(l));
de:=rad2deg*arcsin(sin(b)*cos(e)+cos(b)*sin(e)*sin(l));
end;

Procedure Eq2Ecl(ar,de,e: double; var l,b: double);
begin
ar:=deg2rad*ar;
de:=deg2rad*de;
l:=rad2deg*arctan2(sin(ar)*cos(e)+tan(de)*sin(e),cos(ar));
b:=rad2deg*arcsin(sin(de)*cos(e)-cos(de)*sin(e)*sin(ar));
end;

Procedure Gal2Eq(l,b: double; var ar,de : double);
var dp : double;
begin
l:=deg2rad*(l-123);
b:=deg2rad*b;
dp:=deg2rad*27.4;
ar:=12.25+rad2deg*arctan2(sin(l),cos(l)*sin(dp)-tan(b)*cos(dp));
de:=rad2deg*arcsin(sin(b)*sin(dp)+cos(b)*cos(dp)*cos(l));
precession(jd1950,JDchart,ar,de);
end;

Procedure Eq2Gal(ar,de : double; var l,b: double);
var dp : double;
begin
precession(JDchart,jd1950,ar,de);
ar:=deg2rad*(192.25-ar);
dp:=deg2rad*27.4;
l:=303-rad2deg*arctan2(sin(ar),cos(ar)*sin(dp)-tan(de)*cos(dp));
l:=rmod(l+360,360);
b:=rad2deg*arcsin(sin(de)*sin(dp)+cos(de)*cos(dp)*cos(ar));
end;

// Same function as in u_projection.pas
// must be copied every time it is changed
Procedure InvProj2 (xx,yy,ac,dc : Double ; VAR ar,de : Double);
Var a,r,hh,s1,c1,s2,c2,s3,c3,x,y,z : Extended ;
    p,pr: coordvector;
Begin
s1:=0;c1:=0;s2:=0;c2:=0;s3:=0;c3:=0;
x:=(xx*costheta-yy*sintheta) ;     // AIPS memo 27
y:=(-yy*costheta-xx*sintheta);
case projtype of
'A' : begin
    r :=(pid2-sqrt(x*x+y*y)) ;
    a := arctan2(x,y) ;
    sincos(a,s1,c1);
    sincos(dc,s2,c2);
    sincos(r,s3,c3);
    de:=(arcsin( s2*s3 - c2*c3*c1)) + 1E-9 ;
    hh:=(arctan2((c3*s1),(c2*s3+s2*c3*c1) ));
    ar := ac - hh - 1E-9 ;
   end;
'C' : begin                 // CAR
    if ProjEquatorCentered then begin
      sofa_S2C(-x,-y,p);
      sofa_rxp(EqtMAT,p,pr);
      sofa_c2s(pr,ar,de);
    end else begin
      ar:=ac-x;
      de:=dc-y;
    end;
    if de>0 then de:=(min(de,pid2-0.00002)) else de:=(max(de,-pid2-0.00002));
    end;
'H' : begin                 // Hammer-Aitoff
    if ProjEquatorCentered then begin
      z:=1-(x/4)*(x/4)-(y/2)*(y/2);
      if z>=0 then z:=sqrt(z)
              else z:=0;
      x:=pi+2*arctan2(2*z*z-1,z*x/2);
      y:=-arcsin(y*z);
      sofa_S2C(x,y,p);
      sofa_rxp(EqtMAT,p,pr);
      sofa_c2s(pr,ar,de);
    end else begin
      x:=x+haicx;
      y:=y+haicy;
      z:=1-(x/4)*(x/4)-(y/2)*(y/2);
      if z>=0 then z:=sqrt(z)
              else z:=0;
      ar:=rmod(ac+pi+2*arctan2(2*z*z-1,z*x/2)+pi2,pi2);
      y:=(-y*z);
      if abs(y)<=1 then de:=arcsin(y)
                   else de:=0;
    end;
    if de>0 then de:=(min(de,pid2-0.00002)) else de:=(max(de,-pid2-0.00002));
    end;
'M' : begin                 // MER
    if ProjEquatorCentered then begin
      y:=2*arctan(exp(y))-pid2;
      sofa_S2C(-x,-y,p);
      sofa_rxp(EqtMAT,p,pr);
      sofa_c2s(pr,ar,de);
    end else begin
      y:=2*arctan(exp(-y+ln(tan((pid2+dc)/2))))-pid2;
      ar:=ac-x;
      de:=y;
    end;
    if de>0 then de:=(min(de,pid2-0.00002)) else de:=(max(de,-pid2-0.00002));
    end;
'S' : begin
    sincos(dc,s1,c1);
    x:=-(x);
    y:=-(y);
    r:=sqrt(1-x*x-y*y);
    ar:=ac+(arctan2(x,(c1*r-y*s1)));
    de:=(arcsin(y*c1+s1*r));
    end;
'T' : begin
    sincos(dc,s1,c1);
    x:=-(x);
    y:=-(y);
    ar:=ac+(arctan2(x,(c1-y*s1)));
    de:=(arctan((cos(ar-ac)*(y*c1+s1))/(c1-y*s1)));
    end;
else begin
    projtype:='A';
    r :=(pid2-sqrt(x*x+y*y)) ;
    a := arctan2(x,y) ;
    de:=(arcsin( sin(dc)*sin(r) - cos(dc)*cos(r)*cos(a) )) + 1E-9 ;
    hh:=(arctan2((cos(r)*sin(a)),(cos(dc)*sin(r)+sin(dc)*cos(r)*cos(a)) ));
    ar := ac - hh - 1E-9 ;
    end;
end;
end ;

Procedure InvProj (xx,yy : Double ; VAR ar,de : Double );
Var a,r,hh,s1,c1,x,y,ac,dc : Double ;
    p,pr: coordvector;
Begin
case Projpole of
   0 : begin
       ac:=arcentre*15;
       dc:=decentre;
       end;
   1 : begin
       ac:=-acentre;
       dc:=hcentre;
       end;
   2 : begin
       ac:=lcentre;
       dc:=bcentre;
       end;
   3 : begin
       ac:=lecentre;
       dc:=becentre;
       end;
end;
InvProj2(xx*deg2rad,yy*deg2rad,ac*deg2rad,dc*deg2rad,ar,de);
ar:=rad2deg*ar;
de:=rad2deg*de;
case Projpole of
   1 : begin
       Hz2Eq(-ar,de,a,hh) ;
       ar:=15*CurrentST-a;
       de:=hh;
       precession(currentjd,jdChart,ar,de);
       end;
   2 : begin
       Gal2Eq(ar,de,a,hh) ;
       ar:=a;
       de:=hh;
       end;
   3 : begin
       Ecl2Eq(ar,de,ecl,a,hh) ;
       ar:=a;
       de:=hh;
       end;
end;
end ;

procedure GetADxy(x,y:Integer ; var a,d : Double);
var
   x1,y1: Double;
begin
  XYwindow(x,y,x1,y1);
  InvProj (x1,y1,a,d);
  a:=a/15.0;
end;

Procedure FindRegion7(ar,de : double; var hemis : char ; var zone,S : integer);
var i1,i2,N,L1,L : integer;
    del : double;
begin
if de>0 then hemis:='n'
        else hemis:='s';
i1 := Trunc((de+90)/7.5) ;
N  := lg_reg_x7[i1,1];
L1 := lg_reg_x7[i1,2];
i2 := Trunc(ar/(360/N));
L  := L1+i2;
del:= Trunc(de/7.5)*7.5;
S  := L;
zone := Trunc(abs(del))*100 + Trunc(Frac(abs(del))*60) ;
end;

procedure FindRegionList7(x1,x2,y1,y2:Double ;
                          var Nsm : integer ;
                          var zonelst,SMlst : array of integer ;
                          var hemislst : array of char );
var
   hemis : char;
   zone,Sm,i,j,k : integer;
   ar,de,dar,dde,arp,dep : double;
   def : boolean;
begin
dar:=(x2-x1)/9;
dde:=(y2-y1)/9;
nSM:=0;
for i:=0 to 9 do begin
  ar:=x1+i*dar ;
  if ar>=360 then ar:=ar-360;
  if ar<0 then ar:=ar+360;
  for j:=0 to 9 do begin
    de:=y1+j*dde ;
    if abs(de) >= 90 then continue;
    arp:=ar; dep:=de;
    precession(JDChart,JDCatalog,arp,dep);
    Findregion7(arp,dep,hemis,zone,Sm);
    def:=true ;
    for k:=0 to nSM-1 do begin
      if Sm=Smlst[k] then def:=false
    end;
    if def then begin
      Smlst[nSm]:=Sm;
      zonelst[nSM]:=zone;
      hemislst[nSM]:=hemis;
      inc(nSM);
    end;
  end;
end;
end;

procedure FindRegionListWin7(var Nsm : integer ;
                            var zonelst,SMlst : array of integer ;
                            var hemislst : array of char );
var
   hemis : char;
   xx,yy,dx,dy,Sm,zone,i,j,k : integer;
   ar,de,arp,dep : double;
   def : boolean;
begin
dx:=Trunc((xmax-xmin)/9);
dy:=Trunc((ymax-ymin)/9);
nSM:=0;
for i:=0 to 9 do begin
  xx:=xmin+i*dx ;
  for j:=0 to 9 do begin
    yy:=ymin+j*dy ;
    GetADxy(xx,yy,ar,de);
    ar:=ar*15;
    if ar>=360 then ar:=ar-360;
    if ar<0 then ar:=ar+360;
    arp:=ar; dep:=de;
    precession(JDChart,JDCatalog,arp,dep);
    Findregion7(arp,dep,hemis,zone,Sm);
    def:=true ;
    for k:=0 to nSM-1 do begin
      if Sm=Smlst[k] then def:=false
    end;
    if def then begin
      Smlst[nSm]:=Sm;
      zonelst[nSM]:=zone;
      hemislst[nSM]:=hemis;
      inc(nSM);
    end;
  end;
end;
end;

procedure FindRegionAllWin7(var Nsm : integer ;
                            var zonelst,SMlst : array of integer ;
                            var hemislst : array of char );
var
   hemis : char;
   xx,yy,dx,dy,Sm,zone,k : integer;
   ar,de,arp,dep : double;
   def : boolean;
const step = 6;
begin
if xmax<xmin then begin xx:=xmax; xmax:=xmin; xmin:=xx; end;
if ymax<ymin then begin xx:=ymax; ymax:=ymin; ymin:=xx; end;
nSM:=0;
k:=(xmax-xmin) div 5;
dx:=minintvalue([k,abs(Trunc(step*BxGlb))]);
k:=(ymax-ymin) div 5;
dy:=minintvalue([k,abs(Trunc(step*ByGlb))]);
yy:=ymin;
repeat
  xx:=xmin;
  repeat
    GetADxy(xx,yy,ar,de);
    ar:=ar*15;
    if ar>=360 then ar:=ar-360;
    if ar<0 then ar:=ar+360;
    arp:=ar; dep:=de;
    precession(JDChart,JDCatalog,arp,dep);
    Findregion7(arp,dep,hemis,zone,Sm);
    def:=true ;
    for k:=0 to nSM-1 do begin
      if Sm=Smlst[k] then def:=false
    end;
    if def then begin
      Smlst[nSm]:=Sm;
      zonelst[nSM]:=zone;
      hemislst[nSM]:=hemis;
      inc(nSM);
    end;
    xx:=xx+dx ;
  until xx>xmax;
  yy:=yy+dy ;
until yy>ymax;
end;

procedure FindRegionAll7(x1,x2,y1,y2:Double ;
                          var Nsm : integer ;
                          var zonelst,SMlst : array of integer ;
                          var hemislst : array of char );
var
   hemis : char;
   zone,Sm,k : integer;
   step,ar,de,ra,arp,dep : double;
   def : boolean;
begin
if x2<x1 then begin ra:=x2; x2:=x1; x1:=ra; end;
if y2<y1 then begin ra:=y2; y2:=y1; y1:=ra; end;
step:= 5;
ra:=(x2-x1)/5;
de:=(y2-y1)/5;
step:=minvalue([ra,de,step]);
nSM:=0;
de:=y1;
repeat
  if abs(de) >= 90 then continue;
  ra:=x1;
  repeat
    ar:=ra;
    if ar>=360 then ar:=ar-360;
    if ar<0 then ar:=ar+360;
    arp:=ar; dep:=de;
    precession(JDChart,JDCatalog,arp,dep);
    Findregion7(arp,dep,hemis,zone,Sm);
    def:=true ;
    for k:=0 to nSM-1 do begin
      if Sm=Smlst[k] then def:=false
    end;
    if def then begin
      Smlst[nSm]:=Sm;
      zonelst[nSM]:=zone;
      hemislst[nSM]:=hemis;
      inc(nSM);
    end;
    ra:=ra+step/cos(degtorad(de));
  until ra>x2;
  de:=de+step;
until de>y2;
end;

Procedure FindRegion15(ar,de : double; var lg : integer);
var i1,i2,N,L1 : integer;
begin
i1 := Trunc((de+90)/15) ;
N  := lg_reg_x15[i1,1];
L1 := lg_reg_x15[i1,2];
i2 := Trunc(ar/(360/N));
Lg := L1+i2;
end;

procedure FindRegionList15(x1,x2,y1,y2:Double ;
                          var Nsm : integer ;
                          var SMlst : array of integer );
var
   Sm,i,j,k : integer;
   ar,de,dar,dde,arp,dep : double;
   def : boolean;
begin
dar:=(x2-x1)/5;
dde:=(y2-y1)/5;
nSM:=0;
for i:=0 to 5 do begin
  ar:=x1+i*dar ;
  if ar>=360 then ar:=ar-360;
  if ar<0 then ar:=ar+360;
  for j:=0 to 5 do begin
    de:=y1+j*dde ;
    if abs(de) >= 90 then continue;
    arp:=ar; dep:=de;
    precession(JDChart,JDCatalog,arp,dep);
    Findregion15(arp,dep,Sm);
    def:=true ;
    for k:=0 to nSM-1 do begin
      if Sm=Smlst[k] then def:=false
    end;
    if def then begin
      Smlst[nSm]:=Sm;
      inc(nSM);
    end;
  end;
end;
end;

procedure FindRegionAll15(x1,x2,y1,y2:Double ;
                          var Nsm : integer ;
                          var SMlst : array of integer );
var
   Sm,k : integer;
   step,ar,de,ra,arp,dep : double;
   def : boolean;
begin
if x2<x1 then begin ra:=x2; x2:=x1; x1:=ra; end;
if y2<y1 then begin ra:=y2; y2:=y1; y1:=ra; end;
nSM:=0;
step:= 10;
ra:=(x2-x1)/5;
de:=(y2-y1)/5;
step:=minvalue([ra,de,step]);
de:=y1;
repeat
  if abs(de) >= 90 then continue;
  ra:=x1;
  repeat
    ar:=ra;
    if ar>=360 then ar:=ar-360;
    if ar<0 then ar:=ar+360;
    arp:=ar; dep:=de;
    precession(JDChart,JDCatalog,arp,dep);
    Findregion15(arp,dep,Sm);
    def:=true ;
    for k:=0 to nSM-1 do begin
      if Sm=Smlst[k] then def:=false
    end;
    if def then begin
      Smlst[nSm]:=Sm;
      inc(nSM);
    end;
    ra:=ra+step/cos(degtorad(de));
  until ra>x2;
  de:=de+step;
until de>y2;
end;

procedure FindRegionListWin15(var Nsm : integer ;var SMlst : array of integer );
var
   xx,yy,dx,dy,Sm,i,j,k : integer;
   ar,de,arp,dep : double;
   def : boolean;
begin
dx:=Trunc((xmax-xmin)/5);
dy:=Trunc((ymax-ymin)/5);
nSM:=0;
for i:=0 to 5 do begin
  xx:=xmin+i*dx ;
  for j:=0 to 5 do begin
    yy:=ymin+j*dy ;
    GetADxy(xx,yy,ar,de);
    ar:=ar*15;
    if ar>=360 then ar:=ar-360;
    if ar<0 then ar:=ar+360;
    arp:=ar; dep:=de;
    precession(JDChart,JDCatalog,arp,dep);
    Findregion15(arp,dep,Sm);
    def:=true ;
    for k:=0 to nSM-1 do begin
      if Sm=Smlst[k] then def:=false
    end;
    if def then begin
      Smlst[nSm]:=Sm;
      inc(nSM);
    end;
  end;
end;
end;

procedure FindRegionAllWin15(var Nsm : integer ;var SMlst : array of integer );
var
   xx,yy,dx,dy,Sm,k : integer;
   ar,de,arp,dep : double;
   def : boolean;
const step = 10;
begin
if xmax<xmin then begin xx:=xmax; xmax:=xmin; xmin:=xx; end;
if ymax<ymin then begin xx:=ymax; ymax:=ymin; ymin:=xx; end;
nSM:=0;
k:=(xmax-xmin) div 5;
dx:=minintvalue([k,abs(Trunc(step*BxGlb))]);
k:=(ymax-ymin) div 5;
dy:=minintvalue([k,abs(Trunc(step*ByGlb))]);
yy:=ymin;
repeat
  xx:=xmin;
  repeat
    GetADxy(xx,yy,ar,de);
    ar:=ar*15;
    if ar>=360 then ar:=ar-360;
    if ar<0 then ar:=ar+360;
    arp:=ar; dep:=de;
    precession(JDChart,JDCatalog,arp,dep);
    Findregion15(arp,dep,Sm);
    def:=true ;
    for k:=0 to nSM-1 do begin
      if Sm=Smlst[k] then def:=false
    end;
    if def then begin
      Smlst[nSm]:=Sm;
      inc(nSM);
    end;
    xx:=xx+dx ;
  until xx>xmax;
  yy:=yy+dy ;
until yy>ymax;
end;

Procedure FindRegion30(ar,de : double; var lg : integer);
var i1,i2,N,L1 : integer;
begin
i1 := Trunc((de+90)/30) ;
N  := lg_reg_x30[i1,1];
L1 := lg_reg_x30[i1,2];
i2 := Trunc(ar/(360/N));
Lg := L1+i2;
end;

procedure FindRegionList30(x1,x2,y1,y2:Double ;
                          var Nsm : integer ;
                          var SMlst : array of integer );
var
   Sm,i,j,k : integer;
   ar,de,dar,dde,arp,dep : double;
   def : boolean;
begin
dar:=(x2-x1)/15;
dde:=(y2-y1)/15;
nSM:=0;
for i:=0 to 15 do begin
  ar:=x1+i*dar ;
  if ar>=360 then ar:=ar-360;
  if ar<0 then ar:=ar+360;
  for j:=0 to 15 do begin
    de:=y1+j*dde ;
    if abs(de) >= 89.99999 then continue;
    arp:=ar; dep:=de;
    precession(JDChart,JDCatalog,arp,dep);
    Findregion30(arp,dep,Sm);
    def:=true ;
    for k:=0 to nSM-1 do begin
      if Sm=Smlst[k] then def:=false
    end;
    if def and (sm>0) and (sm<=50) then begin
      Smlst[nSm]:=Sm;
      inc(nSM);
    end;
  end;
end;
end;

procedure FindRegionListWin30(var Nsm : integer ;var SMlst : array of integer );
var
   xx,yy,dx,dy,Sm,i,j,k : integer;
   ar,de,arp,dep : double;
   def : boolean;
begin
dx:=Trunc((xmax-xmin)/15);
dy:=Trunc((ymax-ymin)/15);
nSM:=0;
for i:=0 to 15 do begin
  xx:=xmin+i*dx ;
  for j:=0 to 15 do begin
    yy:=ymin+j*dy ;
    GetADxy(xx,yy,ar,de);
    ar:=ar*15;
    if ar>=360 then ar:=ar-360;
    if ar<0 then ar:=ar+360;
    arp:=ar; dep:=de;
    precession(JDChart,JDCatalog,arp,dep);
    Findregion30(arp,dep,Sm);
    def:=true ;
    for k:=0 to nSM-1 do begin
      if Sm=Smlst[k] then def:=false
    end;
    if def then begin
      Smlst[nSm]:=Sm;
      inc(nSM);
    end;
  end;
end;
end;

Function sgn(x:Double):Double ;
begin
if x<0 then
   sgn:= -1
else
   sgn:=  1 ;
end ;

function InvertI32(X : LongWord) : LongInt;
var  P : PbyteArray;
begin
    P:=@X;
    result:=(P[0] shl 24) or (P[1] shl 16) or (P[2] shl 8) or (P[3]);
end;

function words(str,sep : string; p,n : integer) : string;
var     i,j : Integer;
begin
result:='';
str:=trim(str);
for i:=1 to p-1 do begin
 j:=pos(' ',str);
 if j=0 then j:=length(str)+1;
 str:=trim(copy(str,j,length(str)));
end;
for i:=1 to n do begin
 j:=pos(' ',str);
 if j=0 then j:=length(str)+1;
 result:=result+trim(copy(str,1,j))+sep;
 str:=trim(copy(str,j,length(str)));
end;
end;

Procedure FindRegion(ar,de : double; var hemis : char ; var zone,S : integer;const sN, sS: char);
var i1,i2,j1,j2,N,L1,L,S1,k : integer;
    arl,del,dar,dde : double;
begin
if de>0 then hemis:=sN
        else hemis:=sS;
i1 := Trunc((de+90)/7.5) ;
N  := lg_reg_x[i1,1];
L1 := lg_reg_x[i1,2];
i2 := Trunc(ar/(360/N));
L  := L1+i2;
S1 := sm_reg_x[L,1];
k  := sm_reg_x[L,2];
del:= Trunc((de+1e-12)/7.5)*7.5;
arl:= (360/N)*i2;
dde:= 7.5/k;
dar:= (360/N)/k;
j1 := Trunc(abs(de-del)/dde);
j2 := Trunc((ar-arl)/dar);
S  := S1+j1*k+j2;
zone := Trunc(abs(del))*100 + Trunc(Frac(abs(del))*60) ;
end;

procedure FindRegionList(x1,x2,y1,y2:Double ;
                          var Nsm : integer ;
                          var zonelst,SMlst : array of integer ;
                          var hemislst : array of char;
                          const sN: char='n'; const sS: char='s' );
var
   hemis : char;
   zone,Sm,i,j,k : integer;
   ar,de,dar,dde,arp,dep : double;
   def : boolean;
begin
dar:=(x2-x1)/9;
dde:=(y2-y1)/9;
nSM:=0;
for i:=0 to 9 do begin
  ar:=x1+i*dar ;
  if ar>=360 then ar:=ar-360;
  if ar<0 then ar:=ar+360;
  for j:=0 to 9 do begin
    de:=y1+j*dde ;
    arp:=ar; dep:=de;
    precession(JDChart,JDCatalog,arp,dep);
    if abs(dep) >= 90 then continue;
    Findregion(arp,dep,hemis,zone,Sm,sN,sS);
    def:=true ;
    for k:=0 to nSM-1 do begin
      if Sm=Smlst[k] then def:=false
    end;
    if def then begin
      Smlst[nSm]:=Sm;
      zonelst[nSM]:=zone;
      hemislst[nSM]:=hemis;
      inc(nSM);
    end;
  end;
end;
end;

procedure FindRegionAll(x1,x2,y1,y2:Double ;
                          var Nsm : integer ;
                          var zonelst,SMlst : array of integer ;
                          var hemislst : array of char;
                          const sN: char='n'; const sS: char='s' );
var
   hemis : char;
   zone,Sm,k : integer;
   stepra,stepde,ar,de,ra,arp,dep : double;
   def : boolean;
begin
if x2<x1 then begin ra:=x2; x2:=x1; x1:=ra; end;
if y2<y1 then begin ra:=y2; y2:=y1; y1:=ra; end;
stepra:=min((x2-x1)/5,1);
if abs(x2-x1)>359 then stepra:=359;
stepde:=min((y2-y1)/5,1);
nSM:=0;
de:=y1;
repeat
  if abs(de) < 90 then begin
  ra:=x1;
  repeat
    ar:=ra;
    if ar>=360 then ar:=ar-360;
    if ar<0 then ar:=ar+360;
    arp:=ar; dep:=de;
    precession(JDChart,JDCatalog,arp,dep);
    if abs(dep) >= 90 then continue;
    Findregion(arp,dep,hemis,zone,Sm,sN,sS);
    def:=true ;
    for k:=0 to nSM-1 do begin
      if Sm=Smlst[k] then def:=false
    end;
    if def then begin
      Smlst[nSm]:=Sm;
      zonelst[nSM]:=zone;
      hemislst[nSM]:=hemis;
      inc(nSM);
    end;
    ra:=ra+stepra; ///cos(degtorad(de));
  until ra>x2;
  end;
  de:=de+stepde;
until de>y2;
end;

procedure FindRegionListWin(var Nsm : integer ;
                            var zonelst,SMlst : array of integer ;
                            var hemislst : array of char;
                            const sN: char='n'; const sS: char='s' );
var
   hemis : char;
   xx,yy,dx,dy,Sm,zone,i,j,k : integer;
   ar,de,arp,dep : double;
   def : boolean;
begin
dx:=Trunc((xmax-xmin)/9);
dy:=Trunc((ymax-ymin)/9);
nSM:=0;
for i:=0 to 9 do begin
  xx:=xmin+i*dx ;
  for j:=0 to 9 do begin
    yy:=ymin+j*dy ;
    GetADxy(xx,yy,ar,de);
    ar:=ar*15;
    if ar>=360 then ar:=ar-360;
    if ar<0 then ar:=ar+360;
    arp:=ar; dep:=de;
    precession(JDChart,JDCatalog,arp,dep);
    Findregion(arp,dep,hemis,zone,Sm,sN,sS);
    def:=true ;
    for k:=0 to nSM-1 do begin
      if Sm=Smlst[k] then def:=false
    end;
    if def then begin
      Smlst[nSm]:=Sm;
      zonelst[nSM]:=zone;
      hemislst[nSM]:=hemis;
      inc(nSM);
    end;
  end;
end;
end;

procedure FindRegionAllWin(var Nsm : integer ;
                            var zonelst,SMlst : array of integer ;
                            var hemislst : array of char;
                            const sN: char='n'; const sS: char='s' );
var
   hemis : char;
   xx,yy,dx,dy,Sm,zone,k : integer;
   ar,de,arp,dep : double;
   def : boolean;
const step = 1;
begin
if xmax<xmin then begin xx:=xmax; xmax:=xmin; xmin:=xx; end;
if ymax<ymin then begin xx:=ymax; ymax:=ymin; ymin:=xx; end;
nSM:=0;
k:=(xmax-xmin) div 5;
dx:=minintvalue([k,abs(Trunc(step*BxGlb))]);
k:=(ymax-ymin) div 5;
dy:=minintvalue([k,abs(Trunc(step*ByGlb))]);
yy:=ymin;
repeat
  xx:=xmin;
  repeat
    GetADxy(xx,yy,ar,de);
    ar:=ar*15;
    if ar>=360 then ar:=ar-360;
    if ar<0 then ar:=ar+360;
    arp:=ar; dep:=de;
    precession(JDChart,JDCatalog,arp,dep);
    Findregion(arp,dep,hemis,zone,Sm,sN,sS);
    def:=true ;
    for k:=0 to nSM-1 do begin
      if Sm=Smlst[k] then def:=false
    end;
    if def then begin
      Smlst[nSm]:=Sm;
      zonelst[nSM]:=zone;
      hemislst[nSM]:=hemis;
      inc(nSM);
    end;
    xx:=xx+dx ;
  until xx>(xmax+dx);
  yy:=yy+dy ;
until yy>(ymax+dy);
end;

Procedure FindRegionDS(ar,de : double; var zone : string);
begin
zone:=padzeros(inttostr(trunc(ar)),2);
if de>=0 then zone:=zone+'N'
        else zone:=zone+'S';
zone:=zone+padzeros(inttostr(10*abs(round((de-5)/10))),2);
end;

procedure FindRegionListDS(x1,x2,y1,y2:Double ;
                          var Nsm : integer ;
                          var zonelst : array of string);
var
   zone : string;
   i,j,k : integer;
   ar,de,dar,dde,arp,dep : double;
   def : boolean;
begin
dar:=min(10.0,(x2-x1)/2); // plus petit que 15 pour etre sur de tout avoir
dde:=min(8.0,(y2-y1)/2);  // ==
nSM:=0;
i:=0;
repeat
  ar:=x1+i*dar ;
  if ar>=360 then ar:=ar-360;
  if ar<0 then ar:=ar+360;
  j:=0;
  repeat
    de:=y1+j*dde ;
    if abs(de) >= 90 then break;
    arp:=ar; dep:=de;
    precession(JDChart,JDCatalog,arp,dep);
    FindregionDS(arp/15,dep,zone);
    def:=true ;
    for k:=0 to nSM-1 do begin
      if zone=zonelst[k] then def:=false
    end;
    if def then begin
      zonelst[nSM]:=zone;
      inc(nSM);
    end;
    inc(j);
  until de>y2;
  inc(i);
until (ar>x2)or(i>24);
end;

procedure FindRegionListWinDS(var Nsm : integer ;
                            var zonelst : array of string) ;
var
   xx,yy,dx,dy,i,j,k,nx,ny : integer;
   ar,de,arp,dep : double;
   zone : string;
   def : boolean;
begin
nx:=maxintvalue([1,round((xmax-xmin)/abs(BxGlb)/5/cos(deg2rad*decentre))]);
if (10*nx)>(xmax-xmin) then nx:=(xmax-xmin)div 10;
ny:=maxintvalue([1,round((ymax-ymin)/abs(ByGlb)/5)]);
dx:=Trunc((xmax-xmin)/nx);
dy:=Trunc((ymax-ymin)/ny);
nSM:=0;
if northpoleinmap {or(decentre>85)} then
  for i:=0 to 23 do begin
    zone:=padzeros(inttostr(i),2);
    zonelst[nSM]:=zone+'N80';
    inc(nSM);
  end;
if southpoleinmap {or(decentre<-85)} then
  for i:=0 to 23 do begin
    zone:=padzeros(inttostr(i),2);
    zonelst[nSM]:=zone+'S90';
    inc(nSM);
  end;
for i:=0 to nx do begin
  xx:=xmin+i*dx ;
  for j:=0 to ny do begin
    yy:=ymin+j*dy ;
    GetADxy(xx,yy,ar,de);
    ar:=ar*15;
    if ar>=360 then ar:=ar-360;
    if ar<0 then ar:=ar+360;
    arp:=ar; dep:=de;
    precession(JDChart,JDCatalog,arp,dep);
    FindregionDS(arp/15,dep,zone);
    def:=true ;
    for k:=0 to nSM-1 do begin
      if zone=zonelst[k] then def:=false
    end;
    if def then begin
      zonelst[nSM]:=zone;
      inc(nSM);
    end;
  end;
end;
end;

procedure FindRegionList2(x1,x2,y1,y2:Double ;
                          var Nsm : integer ;
                          var zonelst,SMlst : array of integer ;
                          var hemislst : array of char;
                          const sN: char='n'; const sS: char='s' );
var
   hemis : char;
   zone,Sm,i,j,k : integer;
   ar,de,dar,dde,arp,dep : double;
   def : boolean;
begin
dar:=(x2-x1)/29;
dde:=(y2-y1)/29;
nSM:=0;
for i:=0 to 29 do begin
  ar:=x1+i*dar ;
  if ar>=360 then ar:=ar-360;
  if ar<0 then ar:=ar+360;
  for j:=0 to 29 do begin
    de:=y1+j*dde ;
    arp:=ar; dep:=de;
    precession(JDChart,JDCatalog,arp,dep);
    if abs(dep) >= 90 then continue;
    Findregion(arp,dep,hemis,zone,Sm,sN,sS);
    def:=true ;
    for k:=0 to nSM-1 do begin
      if Sm=Smlst[k] then def:=false
    end;
    if def then begin
      Smlst[nSm]:=Sm;
      zonelst[nSM]:=zone;
      hemislst[nSM]:=hemis;
      inc(nSM);
    end;
  end;
end;
end;

procedure FindRegionListWin2(var Nsm : integer ;
                            var zonelst,SMlst : array of integer ;
                            var hemislst : array of char;
                            const sN: char='n'; const sS: char='s' );
var
   hemis : char;
   xx,yy,dx,dy,Sm,zone,i,j,k : integer;
   ar,de,arp,dep : double;
   def : boolean;
begin
dx:=Trunc((xmax-xmin)/29);
dy:=Trunc((ymax-ymin)/29);
nSM:=0;
for i:=0 to 29 do begin
  xx:=xmin+i*dx ;
  for j:=0 to 29 do begin
    yy:=ymin+j*dy ;
    GetADxy(xx,yy,ar,de);
    ar:=ar*15;
    if ar>=360 then ar:=ar-360;
    if ar<0 then ar:=ar+360;
    arp:=ar; dep:=de;
    precession(JDChart,JDCatalog,arp,dep);
    Findregion(arp,dep,hemis,zone,Sm,sN,sS);
    def:=true ;
    for k:=0 to nSM-1 do begin
      if Sm=Smlst[k] then def:=false
    end;
    if def then begin
      Smlst[nSm]:=Sm;
      zonelst[nSM]:=zone;
      hemislst[nSM]:=hemis;
      inc(nSM);
    end;
  end;
end;
end;

Function NoSlash(nom : string) : string;
begin
result:=trim(nom);
if copy(result,length(nom),1)=slashchar then result:=copy(result,1,length(nom)-1);
end;

Function Slash(nom : string) : string;
begin
result:=trim(nom);
if copy(result,length(nom),1)<>slashchar then result:=result+slashchar;
end;

function Jd(annee,mois,jour :INTEGER; Heure:double):double;
var u,u0,u1,u2 : double;
	gregorian : boolean;
begin
if annee*10000+mois*100+jour >= 15821015 then gregorian:=true else gregorian:=false;
u:=annee;
if mois<3 then u:=u-1;
u0:=u+4712;
u1:=mois+1;
if u1<4 then u1:=u1+12;
result:=floor(u0*365.25)+floor(30.6*u1+0.000001)+jour+heure/24-63.5;
if gregorian then begin
   u2:=floor(abs(u)/100)-floor(abs(u)/400);
   if u<0 then u2:=-u2;
   result:=result-u2+2;
   if (u<0)and((u/100)=floor(u/100))and((u/400)<>floor(u/400)) then result:=result-1;
end;
end;

//////   New precession expressions, valid for long time intervals
//////   J. Vondrak , N. Capitaine , and P. Wallace
//////   A&A 2011

////// Required functions adapted from the SOFA library

Procedure ltp_PXP(a,b: coordvector; var axb: coordvector);
// p-vector outer (=vector=cross) product.
var xa,ya,za,xb,yb,zb: double;
begin
XA := A[1];
YA := A[2];
ZA := A[3];
XB := B[1];
YB := B[2];
ZB := B[3];
AXB[1] := YA*ZB - ZA*YB;
AXB[2] := ZA*XB - XA*ZB;
AXB[3] := XA*YB - YA*XB;
end;

procedure ltp_PM(p:coordvector; var r:double);
// Modulus of p-vector.
var i: integer;
    w,c : double;
begin
W := 0;
for i:=1 to 3 do begin
   C := P[I];
   W := W + C*C;
end;
R := SQRT(W);
end;

Procedure ltp_ZP(var p:coordvector);
// Zero a p-vector.
var i: integer;
begin
for i:=1 to 3 do p[i]:=0;
end;

Procedure ltp_SXP(s: double; p: coordvector;  var sp: coordvector);
//  Multiply a p-vector by a scalar.
var i: integer;
begin
for i:=1 to 3 do sp[i]:=s*p[i];
end;

Procedure ltp_PN(p:coordvector; var r:double; var u:coordvector);
// Convert a p-vector into modulus and unit vector.
var w: double;
begin
// Obtain the modulus and test for zero.
ltp_PM ( P, W );
IF ( W = 0 ) THEN
//  Null vector.
    ltp_ZP ( U )
ELSE
//  Unit vector.
    ltp_SXP ( 1/W, P, U );
//  Return the modulus.
R := W;
end;

procedure ltp_S2C(theta,phi: double; var c: coordvector);
// Convert spherical coordinates to Cartesian.
// THETA    d         longitude angle (radians)
// PHI      d         latitude angle (radians)
var sa,ca,sd,cd: extended;
begin
sincos(theta,sa,ca);
sincos(phi,sd,cd);
c[1]:=ca*cd;
c[2]:=sa*cd;
c[3]:=sd;
end;

procedure ltp_c2s(p: coordvector; var theta,phi: double);
// P-vector to spherical coordinates.
// THETA    d         longitude angle (radians)
// PHI      d         latitude angle (radians)
var x,y,z,d2: double;
begin
X := P[1];
Y := P[2];
Z := P[3];
D2 := X*X + Y*Y;
IF ( D2 = 0 ) THEN
   theta := 0
ELSE
   theta := arctan2(Y,X);
IF ( Z = 0 ) THEN
   phi := 0
ELSE
   phi := arctan2(Z,SQRT(D2));
end;

procedure ltp_cp(p: coordvector; var c: coordvector);
// Copy a p-vector.
var i: integer;
begin
for i:=1 to 3 do c[i]:=p[i];
end;

procedure ltp_cr(r:rotmatrix; var c: rotmatrix);
// Copy an r-matrix.
var i,j: integer;
begin
for j:=1 to 3 do
  for i:=1 to 3 do c[j,i]:=r[j,i];
end;

procedure ltp_rxp(r: rotmatrix; p: coordvector; var rp: coordvector);
// Multiply a p-vector by an r-matrix.
var w: double;
    wrp: coordvector;
    i,j: integer;
begin
// Matrix R * vector P.
for j:=1 to 3 do begin
   W := 0;
   for i:=1 to 3 do begin
      W := W + R[J,I]*P[I];
   end; //i
   WRP[J] := W;
end; //j
// Return the result.
ltp_CP ( WRP, RP );
end;

procedure ltp_tr(r: rotmatrix; var rt: rotmatrix);
// Transpose an r-matrix.
var wm: rotmatrix;
    i,j: integer;
begin
for i:=1 to 3 do begin
   for j:=1 to 3 do begin
      wm[i,j] := r[j,i];
   end;
end;
ltp_cr ( wm, rt );
end;

procedure ltp_rxr(a,b: rotmatrix; var atb: rotmatrix);
// Multiply two r-matrices.
var i,j,k: integer;
    w: double;
    wm: rotmatrix;
begin
for i:=1 to 3 do begin
   for j:=1 to 3 do begin
      W := 0;
      for k:=1 to 3 do begin
         W := W + A[I,K]*B[K,J];
      end; //k
      WM[I,J] := W;
   end; //j
end; //i
ltp_CR ( WM, ATB );
end;

/////// Precession expressions

Procedure ltp_PECL(epj: double; var vec: coordvector);
// Precession of the ecliptic
// The Fortran subroutine ltp PECL generates the unit vector for the pole of the ecliptic, using the series for PA , QA (Eq. 8 and Tab. 1)
const npol=4;
      nper=8;
      // Polynomials
      pqpol: array[1..npol,1..2] of double = (
             (+5851.607687,-1600.886300),
             (-0.1189000,+1.1689818),
             (-0.00028913,-0.00000020),
             (+0.000000101,-0.000000437));
      // Periodics
      pqper: array[1..5,1..nper] of double = (
             (708.15,2309,1620,492.2,1183,622,882,547),
             (-5486.751211,-17.127623,-617.517403,413.44294,78.614193,-180.732815,-87.676083,46.140315),
             (-684.66156,2446.28388,399.671049,-356.652376,-186.387003,-316.80007,198.296071,101.135679),
             (667.66673,-2354.886252,-428.152441,376.202861,184.778874,335.321713,-185.138669,-120.97283),
             (-5523.863691,-549.74745,-310.998056,421.535876,-36.776172,-145.278396,-34.74445,22.885731));
var as2r, d2pi, eps0, t, p, q, w, a, s, c, z : extended;
    i : integer;
begin
d2pi:=pi2;
//Arcseconds to radians
as2r:=secarc;
//Obliquity at J2000.0 (radians).
eps0 := 84381.406 * as2r;
// Centuries since J2000.
t:=(epj-jd2000)/36525;
//Initialize P_A and Q_A accumulators.
P := 0;
Q := 0;
// Periodic terms.
for i:=1 to nper do begin
  W := D2PI*T;
  A := W/PQPER[1,I];
  sincos(A,S,C);
  P := P + C*PQPER[2,I] + S*PQPER[4,I];
  Q := Q + C*PQPER[3,I] + S*PQPER[5,I];
end;
// Polynomial terms.
W := 1;
for i:=1 to npol do begin
  P := P + PQPOL[I,1]*W;
  Q := Q + PQPOL[I,2]*W;
  W := W*T;
end;
// P_A and Q_A (radians).
P := P*AS2R;
Q := Q*AS2R;
// Form the ecliptic pole vector.
Z := SQRT(MAX(1-P*P-Q*Q,0));
sincos(eps0,s,c);
VEC[1] := P;
VEC[2] := - Q*C - Z*S;
VEC[3] := - Q*S + Z*C;
end;

Procedure ltp_PEQU(epj: double; var veq: coordvector);
// Precession of the equator
// The Fortran subroutine ltp PEQU generates the unit vector for the pole of the equator, using the series for XA , YA (Eq. 9 and Tab. 2)
const npol=4;
      nper=14;
      // Polynomials
      xypol: array[1..npol,1..2] of double = (
             (+5453.282155,-73750.930350),
             (+0.4252841,-0.7675452),
             (-0.00037173,-0.00018725),
             (-0.000000152,+0.000000231));
      // Periodics
      xyper: array[1..5,1..nper] of double = (
             (256.75,708.15,274.2,241.45,2309,492.2,396.1,288.9,231.1,1610,620,157.87,220.3,1200),
             (-819.940624,-8444.676815,2600.009459,2755.17563,-167.659835,871.855056,44.769698,-512.313065,-819.415595,-538.071099,-189.793622,-402.922932,179.516345,-9.814756),
             (75004.344875,624.033993,1251.136893,-1102.212834,-2660.66498,699.291817,153.16722,-950.865637,499.754645,-145.18821,558.116553,-23.923029,-165.405086,9.344131),
             (81491.287984,787.163481,1251.296102,-1257.950837,-2966.79973,639.744522,131.600209,-445.040117,584.522874,-89.756563,524.42963,-13.549067,-210.157124,-44.919798),
             (1558.515853,7774.939698,-2219.534038,-2523.969396,247.850422,-846.485643,-1393.124055,368.526116,749.045012,444.704518,235.934465,374.049623,-171.33018,-22.899655));
var as2r, d2pi, t, x, y, w, a, s, c : extended;
    i : integer;
begin
d2pi:=pi2;
//Arcseconds to radians
as2r:=secarc;
// Centuries since J2000.
t:=(epj-jd2000)/36525;
x:=0;
y:=0;
// Periodic terms.
for i:=1 to nper do begin
   W := D2PI*T;
   A := W/XYPER[1,I];
   sincos(A,S,C);
   X := X + C*XYPER[2,I] + S*XYPER[4,I];
   Y := Y + C*XYPER[3,I] + S*XYPER[5,I];
end;
//Polynomial terms.
W := 1;
for i:=1 to npol do begin
  X := X + XYPOL[I,1]*W;
  Y := Y + XYPOL[I,2]*W;
  W := W*T;
end;
// X and Y (direction cosines).
X := X*AS2R;
Y := Y*AS2R;
// Form the equator pole vector.
VEQ[1] := X;
VEQ[2] := Y;
W := X*X + Y*Y;
IF ( W < 1 ) THEN
   VEQ[3] := SQRT(1-W)
ELSE
   VEQ[3] := 0;
end;

Procedure ltp_PMAT(epj: double; var rp: rotmatrix );
// Precession matrix, mean J2000.0
// The Fortran subroutine ltp PMAT generates the 3 x 3 rotation matrix P, constructed using Fabri parameterization (i.e. directly from
// the unit vectors for the ecliptic and equator poles  see Sect. 5.4). As well as calling the two previous subroutines, ltp PMAT calls
// subroutines from the IAU SOFA library. The resulting matrix transforms vectors with respect to the mean equator and equinox of
// epoch 2000.0 into mean place of date.
var peqr, pecl, v, eqx : coordvector;
    w :  double;
begin
ltp_PEQU(epj,peqr);
ltp_PECL(epj,pecl);
ltp_PXP(peqr,pecl,v);
ltp_pn(v,w,eqx);
ltp_PXP(peqr,eqx,v);
RP[1,1]:= EQX[1];
RP[1,2]:= EQX[2];
RP[1,3]:= EQX[3];
RP[2,1]:= V[1];
RP[2,2]:= V[2];
RP[2,3]:= V[3];
RP[3,1]:= PEQR[1];
RP[3,2]:= PEQR[2];
RP[3,3]:= PEQR[3];
end;

////////////// Finally the precession function for CdC

Procedure PrecessionV(j0,j1: double; var p: coordvector);
  var rp: coordvector;
      r,wm1,wm2: rotmatrix;
      oncache: boolean;
begin
  if abs(j0-j1)<0.01 then exit; // no change
  oncache:= (prec_j0=j0) and (prec_j1=j1);
  if oncache then begin
    sofa_rxp(prec_r,p,rp);
    sofa_cp(rp,p);
  end else begin
    if j0=jd2000 then begin       // from j2000
      ltp_PMAT(j1,r);
    end
    else if j1=jd2000 then begin  // to j2000
      ltp_PMAT(j0,wm1);
      sofa_tr(wm1,r);
    end
    else begin                    // from date0 to date1
      ltp_PMAT(j0,r);
      sofa_tr(r,wm1);
      ltp_PMAT(j1,wm2);
      sofa_rxr(wm1,wm2,r);
    end;
    sofa_rxp(r,p,rp);
    sofa_cp(rp,p);
    prec_r:=r;
    prec_j0:=j0;
    prec_j1:=j1;
  end;
end;

Procedure Precession_rad(j0,j1: double; var ra,de: double);
  var p: coordvector;
  begin
  if abs(j0-j1)<0.01 then exit; // no change
  sofa_S2C(ra,de,p);
  PrecessionV(j0,j1,p);
  sofa_c2s(p,ra,de);
  ra:=rmod(ra+pi2,pi2);
end;

///////////////////////
Initialization
  JDChart:=jd2000;
  JDcatalog:=jd2000;
end.

