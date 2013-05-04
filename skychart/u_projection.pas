unit u_projection;
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
Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
}
{
 Projection functions

 Portion by Patrick Wallace, RAL Space, UK
}
{$mode objfpc}{$H+}
interface
uses u_constant, u_util,
     Math, SysUtils, Graphics;

const refmethod=1;    // Refraction method: 0=norefraction, 1=Bennett, 2=slalib
                      // Use 1 by default because of better reversability and performance for drawing.
                      // 2 is used as parameter for higher accuracy in detail form.

Procedure ScaleWindow(c: Tconf_skychart);
Function RotationAngle(x1,y1,x2,y2: double; c: Tconf_skychart): double;
Procedure WindowXY(x,y:Double; out WindowX,WindowY: single; c: Tconf_skychart);
Procedure XYWindow( x,y: Integer; var Xwindow,Ywindow: double; c: Tconf_skychart);
function Projection(ar,de : Double ; VAR X,Y : Double; clip:boolean; c: Tconf_skychart; tohrz:boolean=false):boolean;
function Proj2(ar,de,ac,dc : Double ; VAR X,Y : Double; c: Tconf_skychart; rot:boolean=true; inithai:boolean=false ):boolean;
Procedure InvProj (xx,yy : Double ; VAR ar,de : Double; c: Tconf_skychart );
Procedure InvProj2 (xx,yy,ac,dc : Double ; VAR ar,de : Double; c: Tconf_skychart );
procedure GetCoordxy(x,y:Integer ; var l,b : Double; c: Tconf_skychart);
procedure GetADxy(x,y:Integer ; var a,d : Double; c: Tconf_skychart);
procedure GetAHxy(x,y:Integer ; var a,h : Double; c: Tconf_skychart);
procedure GetAHxyF(x,y:Integer ; var a,h : Double; c: Tconf_skychart);
procedure GetLBxy(x,y:Integer ; var l,b : Double; c: Tconf_skychart);
procedure GetLBExy(x,y:Integer ; var le,be : Double; c: Tconf_skychart);
function ObjectInMap(ra,de:double; c: Tconf_skychart) : Boolean;
function NorthPoleInMap(c:Tconf_skychart) : Boolean;
function SouthPoleInMap(c:Tconf_skychart) : Boolean;
function NorthPole2000InMap(c:Tconf_skychart) : Boolean;
function SouthPole2000InMap(c:Tconf_skychart) : Boolean;
function ZenithInMap(c: Tconf_skychart) : Boolean;
function NadirInMap(c: Tconf_skychart) : Boolean;
Function AngularDistance(ar1,de1,ar2,de2 : Double) : Double;
function PositionAngle(ac,dc,ar,de:double):double;
function Jd(annee,mois,jour :INTEGER; Heure:double):double;
PROCEDURE Djd(jd:Double;VAR annee,mois,jour:INTEGER; VAR Heure:double);
function SidTim(jd0,ut,long : double; eqeq: double=0 ): double;
procedure ProperMotion(var r0,d0: double; t,pr,pd: double; fullmotion: boolean;px,rv:double);
procedure Paralaxe(SideralTime,dist,ar1,de1 : double; var ar,de,q : double; c: Tconf_skychart);
PROCEDURE PrecessionFK4(ti,tf : double; VAR ari,dei : double);
PROCEDURE PrecessionFK5(ti,tf : double; VAR ari,dei : double);
PROCEDURE Precession(j0,j1 : double; VAR ra,de : double);
Procedure PrecessionV(j0,j1: double; var p: coordvector);
procedure PrecessionEcl(ti,tf : double; VAR l,b : double);
PROCEDURE HorizontalGeometric(HH,DE : double ; VAR A,h : double; c: Tconf_skychart);
PROCEDURE Eq2Hz(HH,DE : double ; VAR A,h : double; c: Tconf_skychart; method:smallint=refmethod);
Procedure Hz2Eq(A,h : double; var hh,de : double; c: Tconf_skychart; method:smallint=refmethod);
Procedure Refraction(var h : double; flag:boolean; c: Tconf_skychart; method:smallint);
function ecliptic(j:double; nuto:double=0):double;
procedure nutationme(j:double; var nutl,nuto:double);
procedure aberrationme(j:double; var abe,abp:double);
procedure apparent_equatorial(var ra,de:double; c: Tconf_skychart; aberration,lightdeflection:boolean);
procedure apparent_equatorialV(var p1:coordvector; c: Tconf_skychart; aberration,lightdeflection:boolean);
procedure mean_equatorial(var ra,de:double; c: Tconf_skychart; aberration,lightdeflection:boolean);
Procedure StarParallax(var ra,de:double; px:double; eb: coordvector);
Procedure Ecl2Eq(l,b,e: double; var ar,de : double);
Procedure Eq2Ecl(ar,de,e: double; var l,b: double);
Procedure Gal2Eq(l,b: double; var ar,de : double; c: Tconf_skychart);
Procedure Eq2Gal(ar,de : double; var l,b: double; c: Tconf_skychart);
//Function int3(n,y1,y2,y3 : double): double;
Procedure int4(y1,y2,y3:double; var n: integer; var x1,x2,xmax,ymax: double);
Procedure RiseSet(typobj:integer; jd0,ar,de:double; var hr,ht,hs,azr,azs:double;var irc:integer; c: Tconf_skychart; dho:double=9999);
          (* typeobj = 1 etoile ; typeobj = 2 soleil,lune
            ar,de equinox of the date
            irc = 0 lever et coucher
            irc = 1 circumpolaire
            irc = 2 invisible
          *)

Procedure Time_Alt(jd,ar,de,h :Double; VAR hp1,hp2 :Double; ObsLatitude,ObsLongitude: double );
          (*
             Heure a laquel un astre est a un hauteur donnee sur l'horizon .
             jd       :  date julienne desiree a 0H TU
             ar       :  ascension droite  radiant
             de       :  declinaison
             h        :  hauteur sur l'horizon   degres
                         crepuscule nautique h=-12
                         crepuscule astronomique h=-18
             hp1      :  heure matin
             hp2      :  heure soir
           *)

//procedure RiseSetInt(typobj:integer; jd0,ar1,de1,ar2,de2,ar3,de3:double; var hr,ht,hs,azr,azs,rar,der,rat,det,ras,des:double;var irc:integer; c: Tconf_skychart);
Procedure ltp_PMAT(epj: double; var rp: rotmatrix );
procedure sofa_PM(p:coordvector; var r:double);
procedure sofa_S2C(theta,phi: double; var c: coordvector);
procedure sofa_C2S(p: coordvector; var theta,phi: double);
procedure sofa_CP(p: coordvector; var c: coordvector);
Procedure sofa_SXP(s: double; p: coordvector;  var sp: coordvector);
Procedure sofa_PN(p:coordvector; var r:double; var u:coordvector);
Procedure sofa_PMP(a,b:coordvector; var amb:coordvector);
Procedure sofa_PPP(a,b:coordvector; var apb:coordvector);
function sofa_PDP(a,b: coordvector):double;
procedure sofa_RXP(r: rotmatrix; p: coordvector; var rp: coordvector);
procedure sofa_TR(r: rotmatrix; var rt: rotmatrix);
procedure sofa_RXR(a,b: rotmatrix; var atb: rotmatrix);
procedure sofa_Ir(var r: rotmatrix);
procedure sofa_Rz(psi: double; var r: rotmatrix);
procedure sofa_Ry(theta: double; var r: rotmatrix);
procedure sofa_Rx(phi: double; var r: rotmatrix);
Function ltp_Ecliptic(epj: double):double;
procedure GCRS2J2000(var ra, de: double);
procedure J20002GCRS(var ra, de: double);
procedure sla_REFCO ( HM, TDK, PMB, RH, WL, PHI, TLR, EPS: double; var REFA, REFB: double );
procedure cdc_REFCO ( HM, TDK, PMB, RH, WL, PHI, TLR, EPS,H1,H2: double; var REFA, REFB: double );
procedure sla_REFRO ( ZOBS, HM, TDK, PMB, RH, WL, PHI, TLR, EPS: double; var REF: double );
Procedure sla_REFCOQ (TDK, PMB, RH, WL: double; var REFA, REFB: double );
Procedure sla_REFZ (ZU, REFA, REFB: double; var ZR:double);
Procedure sla_GEOC (P,H: double; var R, Z: double);
Procedure sla_POLMO ( ELONGM, PHIM, XP, YP: Double; var ELONG, PHI, DAZ: Double );

implementation

var prec_r : rotmatrix;
    prec_j0, prec_j1: double;

Procedure ScaleWindow(c: Tconf_skychart);
var X1,x2,Y1,Y2 : Integer;
begin
   c.fov:=max(c.fov,secarc);
   c.fov:=min(c.fov,pi2);
   X1 := c.Xmin ; X2 := c.Xmax;
   Y1 := c.Ymin ; Y2 := c.Ymax;
   c.WindowRatio := double(X2-X1) / double(Y2-Y1) ;
   c.Xcentre:=round(double(x2-x1)/2);
   c.Ycentre:=round(double(y2-y1)/2);
   c.Xwrldmin := -c.fov/2;
   c.Ywrldmin := -c.fov/c.WindowRatio/2;
   c.Xwrldmax := c.fov/2;
   c.Ywrldmax := c.fov/c.WindowRatio/2;
   c.BxGlb:= c.FlipX * (X2-X1) / (c.Xwrldmax-c.Xwrldmin) ;
   c.ByGlb:= c.FlipY * (Y1-Y2) / (c.Ywrldmax-c.Ywrldmin) ;
   c.AxGlb:= c.FlipX * (- c.Xwrldmin * c.BxGlb) ;
   c.AyGlb:=  c.FlipY * ( c.Ywrldmin * c.ByGlb) ;
   if abs(c.theta)<1e-6 then c.theta:=0;
   c.sintheta:=sin(c.theta);
   c.costheta:=cos(c.theta);
   if c.fov>pid2 then
      if c.WindowRatio>1 then c.x2:=double(intpower(y2-y1,2))
                         else c.x2:=double(intpower(x2-x1,2))
   else c.x2:=double(intpower(c.BxGlb*pid2,2));
end;

Function RotationAngle(x1,y1,x2,y2: double; c: Tconf_skychart): double;
begin
x1:=c.BxGlb*x1;
y1:=c.ByGlb*y1;
x2:=c.BxGlb*x2;
y2:=c.ByGlb*y2;
result:=double(arctan2((x1-x2),(y1-y2)));
if c.FlipY<0 then result:=result-pi;
end;

Procedure WindowXY(x,y:Double; out WindowX,WindowY: single; c: Tconf_skychart);
BEGIN
 WindowX:=c.AxGlb+c.BxGlb*x+c.Xshift;
 WindowY:=c.AyGlb+c.ByGlb*y+c.Yshift;
END ;

Procedure XYWindow( x,y: Integer; var Xwindow,Ywindow: double; c: Tconf_skychart);
Begin
   xwindow:= (x-c.xshift-c.Axglb)/c.BxGlb ;
   ywindow:= (y-c.yshift-c.AyGlb)/c.ByGlb;
end ;

function Proj2(ar,de,ac,dc : Double ; VAR X,Y : Double; c: Tconf_skychart; rot:boolean=true; inithai:boolean=false ):boolean;
Var r,hh,g,s1,s2,s3,c1,c2,c3 : Extended ;
    xx,yy: double;
    p,pr: coordvector;
BEGIN
result:=false;
s1:=0;s2:=0;s3:=0;c1:=0;c2:=0;c3:=0;
case c.projtype of              // AIPS memo 27
'A' : begin                   //  ARC
    hh := ac-ar ;
    sincos(dc,s1,c1);
    sincos(de,s2,c2);
    sincos(hh,s3,c3);
    r:=s1*s2 + c1*c2*c3;
    if r>1 then r:=1;
    r:= arccos(r)  ;
    if r<>0 then r:= (r/sin(r));
    xx:= r*c2*s3;
    yy:= r*(s2*c1-c2*s1*c3);
    result:=true;
    end;
'C' : begin                 // CAR
    if c.ProjEquatorCentered then begin
      sofa_S2C(ar,de,p);
      sofa_rxp(c.EqpMAT,p,pr);
      sofa_c2s(pr,xx,yy);
    end else begin
      xx:=ar-ac;
      if abs(xx)>pi then xx:=xx-sgn(xx)*pi2;
      yy:=de-dc;
    end;
    xx:=-xx;
    result:=true;
    end;
'H' : begin                 // Hammer-Aitoff
    if c.ProjEquatorCentered then begin
      sofa_S2C(ar,de,p);
      sofa_rxp(c.EqpMAT,p,pr);
      sofa_c2s(pr,xx,yy);
      g:=sqrt(2/(1+(cos(yy)*cos(xx/2))));
      xx:=2*g*cos(yy)*sin(xx/2);
      yy:=g*sin(yy);
    end else begin
      xx:=ar-ac;
      if abs(xx)>pi then xx:=xx-sgn(xx)*pi2;
      yy:=de;
      g:=sqrt(2/(1+(cos(yy)*cos(xx/2))));
      if inithai then c.haicy:=-g*sin(dc);
      xx:=2*g*cos(yy)*sin(xx/2);
      yy:=g*sin(yy)+c.haicy;
    end;
    xx:=-xx;
    result:=true;
    end;
'M' : begin                 // MER
    if c.ProjEquatorCentered then begin
      sofa_S2C(ar,de,p);
      sofa_rxp(c.EqpMAT,p,pr);
      sofa_c2s(pr,xx,yy);
      yy:=pid2+yy;
      yy:=ln(tan((yy)/2));
    end else begin
      xx:=ar-ac;
      if abs(xx)>pi then xx:=xx-sgn(xx)*pi2;
      yy:=pid2+de;
      yy:=ln(tan((yy)/2))-ln(tan((pid2+dc)/2));
    end;
    xx:=-xx;
    result:=true;
    end;
'S' : begin                 // SIN
    hh := ar-ac ;
    sincos(dc,s1,c1);
    sincos(de,s2,c2);
    sincos(hh,s3,c3);
    r:=s1*s2+c2*c1*c3;  // cos the
    if r<=0 then begin  // > 90�
      xx:=200;
      yy:=200;
    end else begin
      xx:= -(c2*s3);
      yy:= s2*c1-c2*s1*c3;
      result:=true;
    end;
    if xx>200 then xx:=200
     else if xx<-200 then xx:=-200;
    if yy>200 then yy:=200
     else if yy<-200 then yy:=-200;
    end;
'T' : begin                  //  TAN
    hh := ar-ac ;
    sincos(dc,s1,c1);
    sincos(de,s2,c2);
    sincos(hh,s3,c3);
    r:=s1*s2+c2*c1*c3;     // cos the
    if r<=0 then begin  // > 90�
      xx:=200;
      yy:=200;
    end else begin
      xx := -( c2*s3/r );
      yy := (s2*c1-c2*s1*c3)/r ;
      result:=true;
  end;
    if xx>200 then xx:=200
     else if xx<-200 then xx:=-200;
    if yy>200 then yy:=200
     else if yy<-200 then yy:=-200;
    end;
else begin
    c.projtype:='A';
    hh := ac-ar ;
    s1:=sin(dc);
    s2:=sin(de);
    c1:=cos(dc);
    c2:=cos(de);
    c3:=cos(hh);
    r:= (arccos( s1*s2 + c1*c2*c3-1e-12 ))  ;
    r:= (r/sin(r));
    xx:= r*c2*sin(hh);
    yy:= r*(s2*c1-c2*s1*c3);
    result:=true;
    end;
end;
if rot then begin
  X:=xx*c.costheta+yy*c.sintheta;
  Y:=yy*c.costheta-xx*c.sintheta;
end else begin
  X:=xx;
  Y:=yy;
end;
END ;

function Projection(ar,de : Double ; VAR X,Y : Double; clip:boolean; c: Tconf_skychart; tohrz:boolean=false):boolean;
Var a,h,ac,dc,d1,d2 : Double ;
    a1,a2,i1,i2 : integer;
BEGIN
a:=0;h:=0;
result:=false;
case c.Projpole of
AltAz: begin
       Eq2Hz(c.CurST-ar,de,a,h,c) ;
       ar:=-a;
       de:=h;
       ac:=-c.acentre;
       dc:=c.hcentre;
       end;
Equat: begin
       ac:=c.racentre;
       dc:=c.decentre;
       end;
Gal:   begin
       Eq2Gal(ar,de,a,h,c) ;
       ar:=a;
       de:=h;
       ac:=c.lcentre;
       dc:=c.bcentre;
       end;
Ecl:   begin
       Eq2Ecl(ar,de,c.ecl,a,h) ;
       ar:=a;
       de:=h;
       ac:=c.lecentre;
       dc:=c.becentre;
       end;
  else raise exception.Create('Bad projection type');
end;
if clip and (c.projpole=AltAz) and c.horizonopaque and (h<=c.HorizonMax) then begin


  if (h<(c.ObsHorizonDepression-musec)) then begin
     if tohrz and (h>(-30*deg2rad)) then begin
       de:=-secarc;
       result:=Proj2(ar,de,ac,dc,X,Y,c);
     end else begin
       X:=200;
       Y:=200;
     end;
  end else begin
    if (not c.ShowHorizon) or (c.horizonlist=nil) then
       if c.ShowHorizonDepression then h:=c.ObsHorizonDepression
          else h:=0
    else begin
      a:=rmod(-rad2deg*ar+181+360,360);
      a1:=trunc(a);
      if a1=0 then i1:=360 else i1:=a1;
      a2:=a1+1;
      if a2=361 then i2:=1 else i2:=a2;
      d1:=c.horizonlist^[i1];
      d2:=c.horizonlist^[i2];
      h:=d1+(a-a1)*(d2-d1)/(a2-a1);
    end;
    if de<h-musec then begin
     if tohrz then begin
        de:=h-secarc;
        result:=Proj2(ar,de,ac,dc,X,Y,c);
     end else begin
        X:=200;
        Y:=200;
     end;
    end else result:=Proj2(ar,de,ac,dc,X,Y,c);
  end;
end else result:=Proj2(ar,de,ac,dc,X,Y,c);
END ;

// This function must be copied every time it is changed
// to library/catalog/skylibcat.pas
// But without reference to c: Tconf_skychart.
// Every necessary parameters must be added to InitCatwin
Procedure InvProj2 (xx,yy,ac,dc : Double ; VAR ar,de : Double; c: Tconf_skychart);
Var a,r,hh,s1,c1,s2,c2,s3,c3,x,y,z : Extended ;
    p,pr: coordvector;
Begin
s1:=0;c1:=0;s2:=0;c2:=0;s3:=0;c3:=0;
x:=(xx*c.costheta-yy*c.sintheta) ;     // AIPS memo 27
y:=(-yy*c.costheta-xx*c.sintheta);
case c.projtype of
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
    if c.ProjEquatorCentered then begin
      sofa_S2C(-x,-y,p);
      sofa_rxp(c.EqtMAT,p,pr);
      sofa_c2s(pr,ar,de);
    end else begin
      ar:=ac-x;
      de:=dc-y;
    end;
    if de>0 then de:=(min(de,pid2-0.00002)) else de:=(max(de,-pid2-0.00002));
    end;
'H' : begin                 // Hammer-Aitoff
    if c.ProjEquatorCentered then begin
      z:=1-(x/4)*(x/4)-(y/2)*(y/2);
      if z>=0 then z:=sqrt(z)
              else z:=0;
      x:=pi+2*arctan2(2*z*z-1,z*x/2);
      y:=-arcsin(y*z);
      sofa_S2C(x,y,p);
      sofa_rxp(c.EqtMAT,p,pr);
      sofa_c2s(pr,ar,de);
    end else begin
      x:=x+c.haicx;
      y:=y+c.haicy;
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
    if c.ProjEquatorCentered then begin
      y:=2*arctan(exp(y))-pid2;
      sofa_S2C(-x,-y,p);
      sofa_rxp(c.EqtMAT,p,pr);
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
    c.projtype:='A';
    r :=(pid2-sqrt(x*x+y*y)) ;
    a := arctan2(x,y) ;
    de:=(arcsin( sin(dc)*sin(r) - cos(dc)*cos(r)*cos(a) )) + 1E-9 ;
    hh:=(arctan2((cos(r)*sin(a)),(cos(dc)*sin(r)+sin(dc)*cos(r)*cos(a)) ));
    ar := ac - hh - 1E-9 ;
    end;
end;
end ;

Procedure InvProj (xx,yy : Double ; VAR ar,de : Double; c: Tconf_skychart);
Var a,hh,ac,dc : Double ;
Begin
a:=0;hh:=0;
case c.Projpole of
Altaz: begin
       ac:=-c.acentre;
       dc:=c.hcentre;
       end;
Equat: begin
       ac:=c.racentre;
       dc:=c.decentre;
       end;
Gal:   begin
       ac:=c.lcentre;
       dc:=c.bcentre;
       end;
Ecl:   begin
       ac:=c.lecentre;
       dc:=c.becentre;
       end;
  else raise exception.Create('Bad projection type');
end;
InvProj2 (xx,yy,ac,dc,ar,de,c);
case c.Projpole of
Altaz: begin
       Hz2Eq(-ar,de,a,hh,c) ;
       ar:=c.CurST-a;
       de:=hh;
       end;
Gal:   begin
       Gal2Eq(ar,de,a,hh,c) ;
       ar:=a;
       de:=hh;
       end;
Ecl:   begin
       Ecl2Eq(ar,de,c.ecl,a,hh) ;
       ar:=a;
       de:=hh;
       end;
end;
end ;

procedure GetCoordxy(x,y:Integer ; var l,b : Double; c: Tconf_skychart);
begin
case c.Projpole of
Altaz: begin
       GetAHxy(x,y,l,b,c);
       end;
Equat: begin
       GetADxy(x,y,l,b,c);
       end;
Gal:   begin
       GetLBxy(x,y,l,b,c);
       end;
Ecl:   begin
       GetLBExy(x,y,l,b,c);
       end;
  else raise exception.Create('Bad projection type');
end;
end;

procedure GetADxy(x,y:Integer ; var a,d : Double; c: Tconf_skychart);
var
   x1,y1: Double;
begin
x1:=0;y1:=0;
  XYwindow(x,y,x1,y1,c);
  InvProj (x1,y1,a,d,c);
  a:=rmod(pi4+a,pi2);
end;

procedure GetAHxy(x,y:Integer ; var a,h : Double; c: Tconf_skychart);
var
   x1,y1: Double;
begin
x1:=0;y1:=0;
  XYwindow(x,y,x1,y1,c);
  InvProj2 (x1,y1,-c.acentre,c.hcentre,a,h,c);
  a:=rmod(pi4-a,pi2);
end;

procedure GetAHxyF(x,y:Integer ; var a,h : Double; c: Tconf_skychart);
var
   x1,y1: Double;
begin
x1:=0;y1:=0;
  XYwindow(x,y,x1,y1,c);
  InvProj2 (x1,y1,-c.acentre,c.hcentre,a,h,c);
  a:=-a;
end;

procedure GetLBxy(x,y:Integer ; var l,b : Double; c: Tconf_skychart);
var
   x1,y1: Double;
begin
x1:=0;y1:=0;
  XYwindow(x,y,x1,y1,c);
  InvProj2 (x1,y1,c.lcentre,c.bcentre,l,b,c);
  l:=rmod(pi4+l,pi2);
end;

procedure GetLBExy(x,y:Integer ; var le,be : Double; c: Tconf_skychart);
var
   x1,y1: Double;
begin
x1:=0;y1:=0;
  XYwindow(x,y,x1,y1,c);
  InvProj2 (x1,y1,c.lecentre,c.becentre,le,be,c);
  le:=rmod(pi4+le,pi2);
end;

function ObjectInMap(ra,de:double; c: Tconf_skychart) : Boolean;
var x1,y1: Double; xx,yy : single;
begin
x1:=0;y1:=0;xx:=0;yy:=0;
projection(ra,de,x1,y1,false,c) ;
windowxy(x1,y1,xx,yy,c);
Result:=(xx>=c.xmin) and (xx<=c.xmax) and (yy>=c.ymin) and (yy<=c.ymax);
end;

function NorthPoleInMap(c: Tconf_skychart) : Boolean;
begin
result:=ObjectInMap(0,pid2,c);
end;

function SouthPoleInMap(c: Tconf_skychart) : Boolean;
begin
result:=ObjectInMap(0,-pid2,c);
end;

function NorthPole2000InMap(c: Tconf_skychart) : Boolean;
begin
result:=ObjectInMap(c.rap2000,c.dep2000,c);
end;

function SouthPole2000InMap(c: Tconf_skychart) : Boolean;
var a,d: Double;
begin
a:=0;
d:=-pid2;
precession(jd2000,c.JDChart,a,d);
result:=ObjectInMap(a,d,c);
end;

function ZenithInMap(c: Tconf_skychart) : Boolean;
var x1,y1: Double; xx,yy : single;
begin
x1:=0;y1:=0;xx:=0;yy:=0;
proj2(1.0,pid2,c.acentre,c.hcentre,x1,y1,c) ;
windowxy(x1,y1,xx,yy,c);
Result:=(xx>=c.xmin) and (xx<=c.xmax) and (yy>=c.ymin) and (yy<=c.ymax);
end;

function NadirInMap(c: Tconf_skychart) : Boolean;
var x1,y1: Double; xx,yy : single;
begin
x1:=0;y1:=0;xx:=0;yy:=0;
proj2(1.0,-pid2,c.acentre,c.hcentre,x1,y1,c) ;
windowxy(x1,y1,xx,yy,c);
Result:=(xx>=c.xmin) and (xx<=c.xmax) and (yy>=c.ymin) and (yy<=c.ymax);
end;

Function AngularDistance(ar1,de1,ar2,de2 : Double) : Double;
var s1,s2,c1,c2,c3: extended;
begin
s1:=0;s2:=0;c1:=0;c2:=0;
try
if (ar1=ar2) and (de1=de2) then result:=0.0
else begin
    sincos(de1,s1,c1);
    sincos(de2,s2,c2);
    c3:=(s1*s2)+(c1*c2*cos((ar1-ar2)));
    if abs(c3)<=1 then
       result:=double(arccos(c3))
    else
       result:=pi2;
end;    
except
  result:=pi2;
end;
end;

function PositionAngle(ac,dc,ar,de:double):double;
var hh,s1,s2,s3,c1,c2,c3 : extended;
begin
s1:=0;s2:=0;s3:=0;c1:=0;c2:=0;c3:=0;
    hh := (ac-ar) ;
    sincos(dc,s1,c1);
    sincos(de,s2,c2);
    sincos(hh,s3,c3);
    result:= rmod(pi2+pi+arctan2((c2*s3) , (-c1*s2+s1*c2*c3) ),pi2);
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

function SidTim(jd0,ut,long : double; eqeq: double=0): double;
 VAR t,te: double;
BEGIN
 t:=(jd0-2451545.0)/36525;
 te:=100.46061837 + 36000.770053608*t + 0.000387933*t*t - t*t*t/38710000;
 te:=te+rad2deg*eqeq;
 result := deg2rad*Rmod(te - long + 1.00273790935*ut*15,360) ;
END ;

procedure ProperMotion(var r0,d0: double; t,pr,pd: double; fullmotion: boolean;px,rv:double);
var w: extended;
    cr0,sr0,cd0,sd0: extended;
    i: integer;
    p,em: coordvector;
begin
if fullmotion then begin
  // "communicated by Patrick Wallace, RAL Space, UK"
  sincos(r0,sr0,cr0);
  sincos(d0,sd0,cd0);
  pr:=pr/cd0;
  sofa_S2C(r0,d0,p);
  w := vfr*rv*px;
  em[1] := - pr*p[2] - pd*cr0*sd0 + w*p[1];
  em[2] :=   pr*p[1] - pd*sr0*sd0 + w*p[2];
  em[3] :=             pd*cd0     + w*p[3];
  for i:=1 to 3 do
     p[i] := p[i]+t*em[i];
  sofa_C2S(p,r0,d0);
end else begin
  r0:=r0+(pr/cos(d0))*t;
  d0:=d0+(pd)*t;
end;
r0:=rmod(r0+pi2,pi2);
end;

procedure Paralaxe(SideralTime,dist,ar1,de1 : double; var ar,de,q : double; c: Tconf_skychart);
var
   sinpi,H,a,b,d : double;
const
     desinpi = 4.26345151e-5;
begin
if dist>1e-5 then begin
// AR, DE may be standard epoch but paralaxe is to be computed with coordinates of the date.
precession(c.JDchart,c.CurJDUT,ar1,de1);
H:=(SideralTime-ar1);
//rde:=de1;
sinpi:=desinpi/dist;
a := cos(de1)*sin(H);
b := cos(de1)*cos(H)-c.ObsRoCosPhi*sinpi;
d := sin(de1)-c.ObsRoSinPhi*sinpi;
q := sqrt(a*a+b*b+d*d);
ar:=SideralTime-arctan2(a,b);
de:=double(arcsin(d/q));
precession(c.CurJDUT,c.JDchart,ar,de);
end else begin
  ar:=ar1;
  de:=de1;
  q:=1;
end;
end;

PROCEDURE PrecessionFK4(ti,tf : double; VAR ari,dei : double);
var i1,i2,i3,i4,i5,i6,i7 : double ;
   BEGIN
      I1:=(TI-2415020.3135)/36524.2199 ;
      I2:=(TF-TI)/36524.2199 ;
      I3:=deg2rad*((1.8E-2*I2+3.02E-1)*I2+(2304.25+1.396*I1))*I2/3600.0 ;
      I4:=deg2rad*I2*I2*(7.91E-1+I2/1000.0)/3600.0+I3 ;
      I5:=deg2rad*((2004.682-8.35E-1*I1)-(4.2E-2*I2+4.26E-1)*I2)*I2/3600.0 ;
      I6:=COS(DEI)*SIN(ARI+I3) ;
      I7:=COS(I5)*COS(DEI)*COS(ARI+I3)-SIN(I5)*SIN(DEI) ;
      DEI:=double(ArcSIN(SIN(I5)*COS(DEI)*COS(ARI+I3)+COS(I5)*SIN(DEI))) ;
      ARI:=double(ARCTAN2(I6,I7)) ;
      ARI:=ARI+I4   ;
      ARI:=RMOD(ARI+pi2,pi2);
   END  ;

PROCEDURE PrecessionFK5(ti,tf : double; VAR ari,dei : double);  // Lieske 77
var i1,i2,i3,i4,i5,i6,i7 : double ;
   BEGIN
   if abs(ti-tf)<0.01 then exit;
      I1:=(TI-2451545.0)/36525 ;
      I2:=(TF-TI)/36525;
      I3:=deg2rad*((2306.2181+1.39656*i1-1.39e-4*i1*i1)*i2+(0.30188-3.44e-4*i1)*i2*i2+1.7998e-2*i2*i2*i2)/3600 ;
      I4:=deg2rad*((2306.2181+1.39656*i1-1.39e-4*i1*i1)*i2+(1.09468+6.6e-5*i1)*i2*i2+1.8203e-2*i2*i2*i2)/3600 ;
      I5:=deg2rad*((2004.3109-0.85330*i1-2.17e-4*i1*i1)*i2-(0.42665+2.17e-4*i1)*i2*i2-4.1833e-2*i2*i2*i2)/3600 ;
      I6:=COS(DEI)*SIN(ARI+I3) ;
      I7:=COS(I5)*COS(DEI)*COS(ARI+I3)-SIN(I5)*SIN(DEI) ;
      i1:=(SIN(I5)*COS(DEI)*COS(ARI+I3)+COS(I5)*SIN(DEI));
      if i1>1 then i1:=1;
      if i1<-1 then i1:=-1;
      DEI:=double(ArcSIN(i1));
      ARI:=double(ARCTAN2(I6,I7)) ;
      ARI:=ARI+I4;
      ARI:=RMOD(ARI+pi2,pi2);
   END  ;

procedure PrecessionEcl(ti,tf : double; VAR l,b : double);  // l,b in radian !
var i1,i2,i3,i4,i5,i6,i7,i8 : double ;
begin
i1:=(ti-2451545.0)/36525 ;
i2:=(tf-ti)/36525;
i3:=deg2rad*(((47.0029-0.06603*i1+0.000598*i1*i1)*i2+(-0.03302+0.000598*i1)*i2*i2+0.000060*i2*i2*i2)/3600);
i4:=deg2rad*((174.876384*3600+3289.4789*i1+0.60622*i1*i1-(869.8089+0.50491*i1)*i2+0.03536*i2*i2)/3600);
i5:=deg2rad*(((5029.0966+2.22226*i1-0.000042*i1*i1)*i2+(1.11113-0.000042*i1)*i2*i2-0.000006*i2*i2*i2)/3600);
i6:=cos(i3)*cos(b)*sin(i4-l)-sin(i3)*sin(b);
i7:=cos(b)*cos(i4-l);
i8:=cos(i3)*sin(b)+sin(i3)*cos(b)*sin(i4-l);
l:=i5+i4-arctan2(i6,i7);
b:=double(arcsin(i8));
l:=rmod(l+pi2,pi2);
end;

PROCEDURE HorizontalGeometric(HH,DE : double ; VAR A,h : double; c: Tconf_skychart);
var l1,d1,h1 : double;
BEGIN
l1:=deg2rad*c.ObsLatitude;
d1:=DE;
h1:=HH;
h:= double(arcsin( sin(l1)*sin(d1)+cos(l1)*cos(d1)*cos(h1) ));
A:= double(arctan2(sin(h1),cos(h1)*sin(l1)-tan(d1)*cos(l1)));
A:=Rmod(A+pi2,pi2);
END ;

Procedure DiurnalAberration(var A,h: double; c: Tconf_skychart);
// from Slalib aopqk.f
var p: coordvector;
    XHD,YHD,ZHD,XHDT,YHDT,ZHDT,DIURAB,F: double;
begin
sofa_S2C(A,h,p);
XHD := p[1];
YHD := p[2];
ZHD := p[3];
DIURAB := c.Diurab;
F := (1-DIURAB*YHD);
XHDT := F*XHD;
YHDT := F*(YHD+DIURAB);
ZHDT := F*ZHD;
p[1] := XHDT;
p[2] := YHDT;
p[3] := ZHDT;
sofa_c2s(p,A,h);
A:=rmod(A+pi2,pi2);
end;

PROCEDURE Eq2Hz(HH,DE : double ; VAR A,h : double; c: Tconf_skychart; method:smallint=refmethod);
var l1,d1,h1 : double;
BEGIN
l1:=deg2rad*c.ObsLatitude;
d1:=DE;
h1:=HH;
h:= double(arcsin( sin(l1)*sin(d1)+cos(l1)*cos(d1)*cos(h1) ));
A:= double(arctan2(sin(h1),cos(h1)*sin(l1)-tan(d1)*cos(l1)));
A:=Rmod(A+pi2,pi2);
if method=2 then DiurnalAberration(A,h,c);
Refraction(h,true,c,method);
if method=2 then A:=A+c.ObsDAZ;
END ;

Procedure Hz2Eq(A,h : double; var hh,de : double; c: Tconf_skychart; method:smallint=refmethod);
var l1,a1,h1 : double;
BEGIN
if method=2 then A:=A-c.ObsDAZ;
Refraction(h,false,c,method);
//if method=2 then Reverse_DiurnalAberration(A,h,c);
l1:=deg2rad*c.ObsLatitude;
a1:=A;
h1:=h;
de:= double(arcsin( sin(l1)*sin(h1)-cos(l1)*cos(h1)*cos(a1) ));
hh:= double(arctan2(sin(a1),cos(a1)*sin(l1)+tan(h1)*cos(l1)));
hh:=Rmod(hh+pi2,pi2);
END ;

Procedure Refraction(var h : double; flag:boolean; c: Tconf_skychart; method:smallint);
const ZBREAK=0.242535625;
var h1,R,DZD : double;
    I : Integer;
begin
if flag then begin   // true -> apparent
   case method of
   0: begin  { no refraction for testing}
       h:=h;
      end;
   1: begin  { Bennett 2010, meeus91 15.3, 15.4 }
       h1:=rad2deg*h;
       if h1>-1 then begin
          R:=cotan(deg2rad*(h1+9.48/(h1+4.8)));
          R:=R-0.06*sin(deg2rad*(14.7*R+13));
          h:=double(minvalue([pid2,h+deg2rad*c.ObsRefractionCor*(R)/60]))
       end
        else h:=h+deg2rad*c.ObsRefractionCor*0.64658062088*(h1+90)/89;
      end;
   2: begin  { slalib }
       if (rad2deg*h)>-1 then begin
          h1:=pid2-h;
          sla_REFZ(h1,c.ObsRefA,c.ObsRefB,h);
          IF (COS(h)<ZBREAK) THEN begin // from aopqk.f
            I := 1;
            DZD := 1E1;
            WHILE (ABS(DZD)>1E-10)AND(I<=10) do begin
             // Compute refraction using current estimate of observed ZD
              sla_REFRO(h, c.ObsAltitude, 273+c.ObsTemperature, c.ObsPressure,0.5,0.55, deg2rad*c.ObsLatitude, 0.0065,1E-8,R);
             // Remaining discrepancy
              DZD := h+R-h1;
             // Update the estimate
              h := h-DZD;
             // Increment the iteration counter
              I := I+1;
            END;
          END;
          h:=pid2-h;
       end
        else h:=h+deg2rad*c.ObsRefractionCor*0.64658062088*(h1+90)/89;
      end;
   end;
end
else begin      // apparent -> true
   case method of
   0: begin  { no refraction for testing}
       h:=h;
      end;
   1: begin   { Bennett 2010, meeus91 15.3, 15.4 }
       h:=h-c.RefractionOffset; // correction for the refraction equation reversibility at the chart center
       h1:=rad2deg*h;
       if h1>-0.347259404573 then begin
          R:=cotan(deg2rad*(0.99914*h1+(7.31/(h1+4.4))));
          R:=R-0.06*sin(deg2rad*(14.7*R+13));
          h:=double(minvalue([pid2,h-deg2rad*c.ObsRefractionCor*(R)/60]))
       end
        else h:=h-deg2rad*c.ObsRefractionCor*0.65705159*(h1+90)/89.64658;
     end;
   2: begin   { slalib }
       if (rad2deg*h)>-0.327565049146 then begin
          h1:=pid2-h;
          sla_REFRO ( h1, c.ObsAltitude, 273+c.ObsTemperature, c.ObsPressure,0.5,0.55, deg2rad*c.ObsLatitude, 0.0065,1E-8,R);
          h1:=h1+R;
          h:=pid2-h1;
       end
        else h:=h-deg2rad*c.ObsRefractionCor*0.65705159*(h1+90)/89.64658;
      end;
   end;
end;
end;

function ecliptic(j:double; nuto:double=0):double;
begin
result:=ltp_Ecliptic(j)+nuto;
end;

procedure nutationme(j:double; var nutl,nuto:double);
var t,om,me,mas,mam,al : double;
begin
if (j>minjdnut)and(j<maxjdnut) then begin
// use this function only if cu_planet.nutation cannot get nutation from JPL ephemeris
t:=(j-jd2000)/36525;
// high precision. using meeus91 table 21.A
//longitude of the asc.node of the Moon's mean orbit on the ecliptic
om:=deg2rad*(125.04452-1934.136261*t+0.0020708*t*t+t*t*t/4.5e+5);
//mean elongation of the Moon from Sun
me:=deg2rad*(297.85036+445267.11148*t-0.0019142*t*t+t*t*t/189474);
//mean anomaly of the Sun (Earth)
mas:=deg2rad*(357.52772+35999.05034*t-1.603e-4*t*t-t*t*t/3e+5);
//mean anomaly of the Moon
mam:=deg2rad*(134.96298+477198.867398*t+0.0086972*t*t+t*t*t/56250);
//Moon's argument of latitude
al:=deg2rad*(93.27191+483202.017538*t- 0.0036825*t*t+t*t*t/327270);
//periodic terms for the nutation in longitude.The unit is 0".0001.
nutl:=secarc*((-171996-174.2*t)*sin(1*om)
                +(-13187-1.6*t)*sin(-2*me+2*al+2*om)
                +(-2274-0.2*t)*sin(2*al+2*om)
                +(2062+0.2*t)*sin(2*om)
                +(1426-3.4*t)*sin(1*mas)
                +(712+0.1*t)*sin(1*mam)
                +(-517+1.2*t)*sin(-2*me+1*mas+2*al+2*om)
                +(-386-0.4*t)*sin(2*al+1*om)
                -301*sin(1*mam+2*al+2*om)
                +(217-0.5*t)*sin(-2*me-1*mas+2*al+2*om)
                -158*sin(-2*me+1*mam)
                +(129+0.1*t)*sin(-2*me+2*al+1*om)
                +123*sin(-1*mam+2*al+2*om)
                +63*sin(2*me)
                +(63+0.1*t)*sin(1*mam+1*om)
                -59*sin(2*me-1*mam+2*al+2*om)
                +(-58-0.1*t)*sin(-1*mam+1*om)
                -51*sin(1*mam+2*al+1*om)
                +48*sin(-2*me+2*mam)
                +46*sin(-2*mam+2*al+1*om)
                -38*sin(2*me+2*al+2*om)
                -31*sin(2*mam+2*al+2*om)
                +29*sin(2*mam)
                +29*sin(-2*me+1*mam+2*al+2*om)
                +26*sin(2*al)
                -22*sin(-2*me+2*al)
                +21*sin(-1*mam+2*al+1*om)
                +(17-0.1*t)*sin(2*mas)
                +16*sin(2*me-1*mam+1*om)
                -16*sin(-2*me+2*mas+2*al+2*om)
                -15*sin(1*mas+1*om)
                -13*sin(-2*me+1*mam+1*om)
                -12*sin(-1*mas+1*om)
                +11*sin(2*mam-2*al)
                -10*sin(2*me-1*mam+2*al+1*om)
                -8*sin(2*me+1*mam+2*al+2*om)
                +7*sin(1*mas+2*al+2*om)
                -7*sin(-2*me+1*mas+1*mam)
                -7*sin(-1*mas+2*al+2*om)
                -7*sin(2*me+2*al+1*om)
                +6*sin(2*me+1*mam)
                +6*sin(-2*me+2*mam+2*al+2*om)
                +6*sin(-2*me+1*mam+2*al+1*om)
                -6*sin(2*me-2*mam+1*om)
                -6*sin(2*me+1*om)
                +5*sin(-1*mas+1*mam)
                -5*sin(-2*me-1*mas+2*al+1*om)
                -5*sin(-2*me+1*om)
                -5*sin(2*mam+2*al+1*om)
                +4*sin(-2*me+2*mam+1*om)
                +4*sin(-2*me+1*mas+2*al+1*om)
                +4*sin(1*mam-2*al)
                -4*sin(-1*me+1*mam)
                -4*sin(-2*me+1*mas)
                -4*sin(1*me)
                +3*sin(1*mam+2*al)
                -3*sin(-2*mam+2*al+2*om)
                -3*sin(-1*me-1*mas+1*mam)
                -3*sin(1*mas+1*mam)
                -3*sin(-1*mas+1*mam+2*al+2*om)
                -3*sin(2*me-1*mas-1*mam+2*al+2*om)
                -3*sin(3*mam+2*al+2*om)
                -3*sin(2*me-1*mas+2*al+2*om));
nutl:=nutl*0.0001;
// periodic terms for the nutation in obliquity
nuto:=secarc*((92025+8.9*t)*cos(1*om)
                +(5736-3.1*t)*cos(-2*me+2*al+2*om)
                +(977-0.5*t)*cos(2*al+2*om)
                +(-895+0.5*t)*cos(2*om)
                +(54-0.1*t)*cos(1*mas)
                -7*cos(1*mam)
                +(224-0.6*t)*cos(-2*me+1*mas+2*al+2*om)
                +200*cos(2*al+1*om)
                +(129-0.1*t)*cos(1*mam+2*al+2*om)
                +(-95+0.3*t)*cos(-2*me+-1*mas+2*al+2*om)
                -70*cos(-2*me+2*al+1*om)
                -53*cos(-1*mam+2*al+2*om)
                -33*cos(1*mam+1*om)
                +26*cos(2*me+-1*mam+2*al+2*om)
                +32*cos(-1*mam+1*om)
                +27*cos(1*mam+2*al+1*om)
                -24*cos(-2*mam+2*al+1*om)
                +16*cos(2*me+2*al+2*om)
                +13*cos(2*mam+2*al+2*om)
                -12*cos(-2*me+1*mam+2*al+2*om)
                -10*cos(-1*mam+2*al+1*om)
                 -8*cos(2*me-1*mam+1*om)
                 +7*cos(-2*me+2*mas+2*al+2*om)
                 +9*cos(1*mas+1*om)
                 +7*cos(-2*me+1*mam+1*om)
                 +6*cos(-1*mas+1*om)
                 +5*cos(2*me-1*mam+2*al+1*om)
                 +3*cos(2*me+1*mam+2*al+2*om)
                 -3*cos(1*mas+2*al+2*om)
                 +3*cos(-1*mas+2*al+2*om)
                 +3*cos(2*me+2*al+1*om)
                 -3*cos(-2*me+2*mam+2*al+2*om)
                 -3*cos(-2*me+1*mam+2*al+1*om)
                 +3*cos(2*me-2*mam+1*om)
                 +3*cos(2*me+1*om)
                 +3*cos(-2*me-1*mas+2*al+1*om)
                 +3*cos(-2*me+1*om)
                 +3*cos(2*mam+2*al+1*om));
nuto:=nuto*0.0001;
end else begin
   nutl:=0;
   nuto:=0;
end;
end;

procedure aberrationme(j:double; var abe,abp:double);
var t : double;
begin
if (j>minjdabe)and(j<maxjdabe) then begin
  t:=(j-jd2000)/36525;
  abe:=0.016708617-4.2037e-5*t-1.236e-7*t*t;
  abp:=deg2rad*(102.93735+1.71953*t+4.6e-4*t*t);
end else begin
  abe:=0;
  abp:=0;
end;
end;

procedure apparent_equatorial(var ra,de:double; c: Tconf_skychart; aberration,lightdeflection:boolean);
var p: coordvector;
begin
sofa_S2C(ra,de,p);
apparent_equatorialV(p,c,aberration,lightdeflection);
sofa_c2s(p,ra,de);
ra:=rmod(ra+pi2,pi2);
end;

procedure apparent_equatorialV(var p1:coordvector; c: Tconf_skychart; aberration,lightdeflection:boolean);
var ra,de,da,dd,p1dv,pde,pdep1,w: double;
    cra,sra,cde,sde,ce,se,te,cp,sp,cls,sls: extended;
    p2: coordvector;
    i: integer;
begin
// nutation
if (c.nutl<>0)or(c.nuto<>0) then begin
    // rotate using nutation matrix
    sofa_RXP(c.NutMAT,p1,p2);
    sofa_CP(p2,p1);
end;
//aberration
if aberration and(c.abm or(c.abp<>0)or(c.abe<>0)) then begin
   if c.abm then begin
     // "communicated by Patrick Wallace, RAL Space, UK"
     // relativistic term
     p1dv := sofa_Pdp ( p1, c.abv );
     w := 1.0 + p1dv / ( c.ab1 + 1.0 );
     // add Earth velocity vector to star vector
     for i:=1 to 3 do
        p2[i] := c.ab1*p1[i] + w*c.abv[i];
     sofa_CP(p2,p1);
   end else begin
    sofa_C2S(p1,ra,de);
    //meeus91 22.3
    sincos(ra,sra,cra);
    sincos(de,sde,cde);
    sincos(c.ecl,se,ce);
    sincos(c.sunl,sls,cls);
    sincos(c.abp,sp,cp);
    te:=tan(c.ecl);
    da:=-abek*(cra*cls*ce+sra*sls)/cde + c.abe*abek*(cra*cp*ce+sra*sp)/cde;
    dd:=-abek*(cls*ce*(te*cde-sra*sde)+cra*sde*sls) + c.abe*abek*(cp*ce*(te*cde-sra*sde)+cra*sde*sp);
    ra:=ra+da;
    de:=de+dd;
    sofa_S2C(ra,de,p1);
  end;
end;
// Sun light deflection
if lightdeflection and c.asl then begin
  // "communicated by Patrick Wallace, RAL Space, UK"
  pde := sofa_Pdp( p1, c.ehn );
  pdep1 := 1.0 + pde;
  w := c.gr2e / max ( pdep1, 1.0e-5 );
  for i:=1 to 3 do
     p2[i] := p1[i] + ( w * ( c.ehn[i] - pde * p1[i] ) );
  sofa_CP(p2,p1);
end;
end;

procedure mean_equatorial(var ra,de:double; c: Tconf_skychart; aberration:boolean=true; lightdeflection:boolean=true);
var da,dd,p1dv,pde,pdep1,w: double;
    cra,sra,cde,sde,ce,se,te,cp,sp,cls,sls: extended;
    p1,p2: coordvector;
    NutMATR : rotmatrix;
    i: integer;
begin
sofa_S2C(ra,de,p1);
// Sun light deflection
if lightdeflection and c.asl then begin
  // "communicated by Patrick Wallace, RAL Space, UK"
  pde := sofa_Pdp( p1, c.ehn );
  pdep1 := 1.0 + pde;
  w := c.gr2e / max ( pdep1, 1.0e-5 );
  for i:=1 to 3 do
     p2[i] := p1[i] - ( w * ( c.ehn[i] - pde * p1[i] ) );
  sofa_CP(p2,p1);
end;
//aberration
if aberration and(c.abm or(c.abp<>0)or(c.abe<>0)) then begin
   if c.abm then begin
     // "communicated by Patrick Wallace, RAL Space, UK"
     // relativistic term
     p1dv := sofa_Pdp ( p1, c.abv );
     w := 1.0 + p1dv / ( c.ab1 + 1.0 );
     // substract Earth velocity vector from star vector
     for i:=1 to 3 do
        p2[i] := p1[i]/c.ab1 - w*c.abv[i];
     sofa_CP(p2,p1);
   end else begin
      sofa_C2S(p1,ra,de);
      //meeus91 22.3
      sincos(ra,sra,cra);
      sincos(de,sde,cde);
      sincos(c.ecl,se,ce);
      sincos(c.sunl,sls,cls);
      sincos(c.abp,sp,cp);
      te:=tan(c.ecl);
      da:=-abek*(cra*cls*ce+sra*sls)/cde + c.abe*abek*(cra*cp*ce+sra*sp)/cde;
      dd:=-abek*(cls*ce*(te*cde-sra*sde)+cra*sde*sls) + c.abe*abek*(cp*ce*(te*cde-sra*sde)+cra*sde*sp);
      ra:=ra-da;
      de:=de-dd;
      sofa_S2C(ra,de,p1);
   end;
end;
// nutation
if (c.nutl<>0)or(c.nuto<>0) then begin
  // rotate using transposed nutation matrix
  sofa_TR(c.NutMAT,NutMATR);
  sofa_RXP(NutMATR,p1,p2);
  sofa_CP(p2,p1);
end;
sofa_C2S(p1,ra,de);
ra:=rmod(ra+pi2,pi2);
end;

Procedure StarParallax(var ra,de:double; px:double; eb: coordvector);
// "communicated by Patrick Wallace, RAL Space, UK"
//  star ra,de in radiant
//  parallax px in arcsec
//  Earth barycentric vector eb in parsec
var x: double;
    s,sp: coordvector;
begin
if px>(1/3600000) then begin  //milli-arcsec
  // star barycentric unit vector
  sofa_S2C(ra,de,s);
  // divide by parallax to get in parsec
  sofa_SXP(1/px,s,sp);
  // substract Earth barycenter position in parsec
  sofa_PMP(sp,eb,s);
  // star unit vector from Earth
  sofa_PN(s,x,sp);
  // return spherical coord.
  sofa_C2S(sp,ra,de);
  // avoid negative RA
  ra:=rmod(ra+pi2,pi2)
end;
end;

Procedure Ecl2Eq(l,b,e: double; var ar,de : double);
begin
ar:=double(arctan2(sin(l)*cos(e)-tan(b)*sin(e),cos(l)));
de:=double(arcsin(sin(b)*cos(e)+cos(b)*sin(e)*sin(l)));
end;

Procedure Eq2Ecl(ar,de,e: double; var l,b: double);
begin
l:=double(arctan2(sin(ar)*cos(e)+tan(de)*sin(e),cos(ar)));
b:=double(arcsin(sin(de)*cos(e)-cos(de)*sin(e)*sin(ar)));
end;

Procedure Gal2Eq(l,b: double; var ar,de : double; c: Tconf_skychart);
var dp : double;
begin
l:=l-deg2rad*123;
dp:=deg2rad*27.4;
ar:=deg2rad*12.25+arctan2(sin(l),cos(l)*sin(dp)-tan(b)*cos(dp));
de:=double(arcsin(sin(b)*sin(dp)+cos(b)*cos(dp)*cos(l)));
precession(jd1950,c.JDchart,ar,de);
end;

Procedure Eq2Gal(ar,de : double; var l,b: double; c: Tconf_skychart);
var dp : double;
begin
precession(c.JDchart,jd1950,ar,de);
ar:=deg2rad*192.25-ar;
dp:=deg2rad*27.4;
l:=deg2rad*303-arctan2(sin(ar),cos(ar)*sin(dp)-tan(de)*cos(dp));
l:=rmod(l+pi2,pi2);
b:=double(arcsin(sin(de)*sin(dp)+cos(de)*cos(dp)*cos(ar)));
end;

procedure RiseSet(typobj:integer; jd0,ar,de:double; var hr,ht,hs,azr,azs:double;var irc:integer; c: Tconf_skychart; dho:double=9999);
const ho : array[1..3] of Double = (-0.5667,-0.8333,0.125) ;
var hoo,hs0,chh0,hh0,m0,m1,m2,a0 : double;
    hsg,hl,h,dm,longref : double;
begin
if (typobj=3)and(dho<9999) then hoo:=dho
   else hoo:=ho[typobj];
longref:=-c.timezone*15;
hs0 := sidtim(jd0,-c.timezone,longref);
chh0 :=(sin(deg2rad*hoo)-sin(deg2rad*c.ObsLatitude)*sin(de))/(cos(deg2rad*c.ObsLatitude)*cos(de)) ;
if abs(chh0)<=1 then begin
   hh0:=double(arccos(chh0));
   m0:=(ar+deg2rad*c.ObsLongitude-deg2rad*longref-hs0)/pi2;
   m1:=m0-hh0/pi2;
   m2:=m0+hh0/pi2;
   if m0<0 then m0:=m0+1;
   if m0>1 then m0:=m0-1;
   if m1<0 then m1:=m1+1;
   if m1>1 then m1:=m1-1;
   if m2<0 then m2:=m2+1;
   if m2>1 then m2:=m2-1;
   // rise
   hsg:= hs0 + deg2rad*360.985647 * m1;
   hl:= hsg - deg2rad*c.Obslongitude + deg2rad*longref - ar;
   h:= rad2deg*(arcsin(sin(deg2rad*c.Obslatitude) * sin(de) + cos(deg2rad*c.Obslatitude) * cos(de) * cos(hl) ));
   dm:= (h - hoo) / (360 * cos(de) * cos(deg2rad*c.Obslatitude) * sin(hl) );
   hr:=(m1+dm)*24;
   // transit
   hsg:= hs0 + deg2rad*360.985647 * m0;
   hl:= hsg - deg2rad*c.Obslongitude + deg2rad*longref - ar;
   dm:= -(hl / pi2);
   ht:=rmod((m0+dm)*24+24,24);
   if (ht<10)and(m0>0.6) then ht:=ht+24;
   if (ht>14)and(m0<0.4) then ht:=ht-24;
   // set
   hsg:= hs0 + deg2rad*360.985647 * m2;
   hl:= hsg - deg2rad*c.Obslongitude + deg2rad*longref - ar;
   h:= rad2deg*(arcsin(sin(deg2rad*c.Obslatitude) * sin(de) + cos(deg2rad*c.Obslatitude) * cos(de) * cos(hl) ));
   dm:= (h - hoo) / (360 * cos(de) * cos(deg2rad*c.Obslatitude) * sin(hl) );
   hs:=(m2+dm)*24;
   // azimuth
   a0:= double(arctan2(sin(hh0),cos(hh0)*sin(deg2rad*c.Obslatitude)-tan(de)*cos(deg2rad*c.Obslatitude)));
   azr:=pi2-a0;
   azs:=a0;
   irc:=0;
end else begin
   hr:=0;hs:=0;azr:=0;azs:=0;
   if sgn(de)=sgn(c.ObsLatitude) then begin
      m0:=(ar+deg2rad*c.ObsLongitude-hs0)/pi2;     (* circumpolar *)
      if m0<0 then m0:=m0+1;
      if m0>1 then m0:=m0-1;
      hsg:= hs0 + deg2rad*360.985647 * m0;
      hl:= hsg - deg2rad*c.ObsLongitude - ar;
      dm:= -(hl / pi2);
      ht:=rmod((m0+dm)*24+c.Timezone+24,24);
      irc:=1 ;
    end else begin
      ht:=0;      (* invisible *)
      irc:=2;
    end;
end;
end;

{Function int3(n,y1,y2,y3 : double): double;
var a,b,c : double;
begin
a:= y2 - y1;
b:= y3 - y2;
c:= b - a;
result:= y2 + n/2*(a + b + n*c);
end;}

procedure int4(y1,y2,y3:double; var n: integer; var x1,x2,xmax,ymax: double);
var a, b, c, d, dx: double;
begin
n:=0;
a:=(y1+y3)/2-y2;
b:=(y3-y1)/2;
c:=y2;
xmax:=-b/(2*a);
ymax:=(a*xmax+b)*xmax+c;
d:=b*b-4.0*a*c;
if (d>0) then begin
   dx:=sqrt(d)/abs(a)/2;
   x1:=xmax-dx;
   x2:=xmax+dx;
   if (abs(x1)<=1) then inc(n);
   if (abs(x2)<=1) then inc(n);
   if (x1<-1) then x1:=x2;
end;
end;

{procedure RiseSetInt(typobj:integer; jd0,ar1,de1,ar2,de2,ar3,de3:double; var hr,ht,hs,azr,azs,rar,der,rat,det,ras,des:double;var irc:integer; c: Tconf_skychart);
const ho : array[1..3] of Double = (-0.5667,-0.8733,0.125) ;
var hs0,chh0,hh0,m0,m1,m2,a0,n,hsg,aa,dd,hl,h,dm,longref : double;
begin
if ar1>pi then begin
   if ar2<pi then ar2:=ar2+pi2;
   if ar3<pi then ar3:=ar3+pi2;
end;
rar:=ar2; der:=de2;
rat:=ar2; det:=de2;
ras:=ar2; des:=de2;
longref:=-c.timezone*15;
hs0 := sidtim(jd0,-c.timezone,longref);
chh0 :=(sin(deg2rad*ho[typobj])-sin(deg2rad*c.ObsLatitude)*sin(de2))/(cos(deg2rad*c.ObsLatitude)*cos(de2)) ;
if abs(chh0)<=1 then begin
   hh0:=double(arccos(chh0));
   m0:=(ar2+deg2rad*c.ObsLongitude-deg2rad*longref-hs0)/pi2;
   m1:=m0-hh0/pi2;
   m2:=m0+hh0/pi2;
   if m0<0 then m0:=m0+1;
   if m0>1 then m0:=m0-1;
   if m1<0 then m1:=m1+1;
   if m1>1 then m1:=m1-1;
   if m2<0 then m2:=m2+1;
   if m2>1 then m2:=m2-1;
   // rise
   hsg:= hs0 + deg2rad*360.985647 * m1;
   n:= m1 ;
   aa:=int3(n,ar1,ar2,ar3);
   dd:=int3(n,de1,de2,de3);
   rar:=aa; der:=dd;
   hl:= hsg - deg2rad*c.Obslongitude + deg2rad*longref - aa;
   h:= rad2deg*(arcsin(sin(deg2rad*c.Obslatitude) * sin(dd) + cos(deg2rad*c.Obslatitude) * cos(dd) * cos(hl) ));
   dm:= (h - ho[typobj]) / (360 * cos(dd) * cos(deg2rad*c.Obslatitude) * sin(hl) );
   hr:=(m1+dm)*24;
   a0:= double(arctan2(sin(hh0),cos(hh0)*sin(deg2rad*c.Obslatitude)-tan(dd)*cos(deg2rad*c.Obslatitude)));
   azr:=pi2-a0;
   // transit
   hsg:= hs0 + deg2rad*360.985647 * m0;
   n:= m0 ;
   aa:=int3(n,ar1,ar2,ar3);
   dd:=int3(n,de1,de2,de3);
   rat:=aa; det:=dd;
   hl:= hsg - deg2rad*c.Obslongitude + deg2rad*longref - aa;
   dm:= -(hl / pi2);
   ht:=rmod((m0+dm)*24+24,24);
   if (ht<10)and(m0>0.6) then ht:=ht+24;
   if (ht>14)and(m0<0.4) then ht:=ht-24;
   // set
   hsg:= hs0 + deg2rad*360.985647 * m2;
   n:= m2 ;
   aa:=int3(n,ar1,ar2,ar3);
   dd:=int3(n,de1,de2,de3);
   ras:=aa; des:=dd;
   hl:= hsg - deg2rad*c.Obslongitude + deg2rad*longref - aa;
   h:= rad2deg*(arcsin(sin(deg2rad*c.Obslatitude) * sin(dd) + cos(deg2rad*c.Obslatitude) * cos(dd) * cos(hl) ));
   dm:= (h - ho[typobj]) / (360 * cos(dd) * cos(deg2rad*c.Obslatitude) * sin(hl) );
   hs:=(m2+dm)*24;
   a0:= double(arctan2(sin(hh0),cos(hh0)*sin(deg2rad*c.Obslatitude)-tan(dd)*cos(deg2rad*c.Obslatitude)));
   azs:=a0;
   irc:=0;
end else begin
   hr:=0;hs:=0;azr:=0;azs:=0;
   if sgn(de1)=sgn(c.ObsLatitude) then begin
      m0:=(ar2+deg2rad*c.ObsLongitude-hs0)/pi2;     (* circumpolar *)
      hsg:= hs0 + deg2rad*360.985647 * m0;
      n:= m0 + c.DT_UT / 24;
      aa:=int3(n,ar1,ar2,ar3);
      dd:=int3(n,de1,de2,de3);
      rat:=aa; det:=dd;
      hl:= hsg - deg2rad*c.ObsLongitude - aa;
      dm:= -(hl / pi2);
      ht:=rmod((m0+dm)*24+c.Timezone+24,24);
      irc:=1 ;
    end else begin
      ht:=0;      (* invisible *)
      irc:=2;
    end;
end;
end;}

Procedure Time_Alt(jd,ar,de,h :Double; VAR hp1,hp2 :Double; ObsLatitude,ObsLongitude: double);
VAR hh,st,st0 : Double ;
BEGIN
hh := (sin(deg2rad*h)-sin(deg2rad*ObsLatitude)*sin(de))/(cos(deg2rad*ObsLatitude)*cos(de)) ;
if abs(hh)<=1 then begin
     hh := double(arccos(hh)) ;
     st0 := rad2deg*sidtim(jd,0.0,ObsLongitude)/15 ;
     st := rad2deg*(ar-hh)/15 ;
     hp1 := rmod((st-st0)/1.002737908+24,24) ;
     st := rad2deg*(ar+hh)/15 ;
     hp2 := rmod((st-st0)/1.002737908+24,24) ;
end else begin
     hp1:=-99;
     hp2:=-99;
end;
END;

//////   New precession expressions, valid for long time intervals
//////   J. Vondrak , N. Capitaine , and P. Wallace
//////   A&A 2011

////// Required functions adapted from the SOFA library

Procedure sofa_PXP(a,b: coordvector; var axb: coordvector);
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

procedure sofa_PM(p:coordvector; var r:double);
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

Procedure sofa_ZP(var p:coordvector);
// Zero a p-vector.
var i: integer;
begin
for i:=1 to 3 do p[i]:=0;
end;

Procedure sofa_SXP(s: double; p: coordvector;  var sp: coordvector);
//  Multiply a p-vector by a scalar.
var i: integer;
begin
for i:=1 to 3 do sp[i]:=s*p[i];
end;

Procedure sofa_PMP(a,b:coordvector; var amb:coordvector);
//  P-vector subtraction.
var i: integer;
begin
for i:=1 to 3 do amb[i]:=a[i]-b[i];
end;

Procedure sofa_PPP(a,b:coordvector; var apb:coordvector);
//  P-vector addition.
var i: integer;
begin
for i:=1 to 3 do apb[i]:=a[i]+b[i];
end;

Procedure sofa_PN(p:coordvector; var r:double; var u:coordvector);
// Convert a p-vector into modulus and unit vector.
var w: double;
begin
// Obtain the modulus and test for zero.
sofa_PM ( P, W );
IF ( W = 0 ) THEN
//  Null vector.
    sofa_ZP ( U )
ELSE
//  Unit vector.
    sofa_SXP ( 1/W, P, U );
//  Return the modulus.
R := W;
end;

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

function sofa_PDP(a,b: coordvector):double;
// p-vector inner (=scalar=dot) product.
begin
result:= a[1]*b[1] +
         a[2]*b[2] +
         a[3]*b[3];
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

procedure sofa_Rx(phi: double; var r: rotmatrix);
//  Rotate an r-matrix about the x-axis.
var s,c : extended;
    a,w : rotmatrix;
begin
// Matrix representing new rotation.
   sincos(phi,s,c);
   sofa_Ir(a);
   a[2,2] :=  c;
   a[3,2] := -s;
   a[2,3] :=  s;
   a[3,3] :=  c;
// Rotate.
   sofa_Rxr(a, r, w);
// Return result.
   sofa_Cr(w, r);
end;

procedure sofa_Bi00(var dpsibi, depsbi, dra: double);
// Frame bias components of IAU 2000 precession-nutation models
// The frame bias corrections in longitude and obliquity
   const DPBIAS = -0.041775  * secarc;
         DEBIAS = -0.0068192 * secarc;
// The ICRS RA of the J2000.0 equinox (Chapront et al., 2002)
   const DRA0 = -0.0146 * secarc;
begin
// Return the results (which are fixed).
   dpsibi := DPBIAS;
   depsbi := DEBIAS;
   dra := DRA0;
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
             (-684.66156,2446.28388,399.671049,-356.652376,-186.387003,-316.80007,198.296701,101.135679),
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
sofa_PXP(peqr,pecl,v);
sofa_pn(v,w,eqx);
sofa_PXP(peqr,eqx,v);
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

Procedure Precession(j0,j1: double; var ra,de: double);
var p: coordvector;
begin
if abs(j0-j1)<0.01 then exit; // no change
sofa_S2C(ra,de,p);
PrecessionV(j0,j1,p);
sofa_c2s(p,ra,de);
ra:=rmod(ra+pi2,pi2);
end;

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

Function ltp_Ecliptic(epj: double):double;
// Obliquity of the ecliptic
// Using equation 9, table 3.
// Only the obliquity is computed here but the term in longitude are kept for clarity.
const npol=4;
      nper=10;
      // Polynomials
      pepol: array[1..npol,1..2] of double = (
             (+8134.017132,84028.206305),
             (+5043.0520035,+0.3624445),
             (-0.00710733,-0.00004039),
             (+0.000000271,-0.000000110));
      // Periodics
      peper: array[1..5,1..nper] of double = (
             (409.90,396.15,537.22,402.90,417.15,288.92,4043.00,306.00,277.00,203.00),
             (-6908.287473,-3198.706291,1453.674527,-857.748557,1173.231614,-156.981465,371.836550,-216.619040,193.691479,11.891524),
             (753.872780,-247.805823,379.471484,-53.880558,-90.109153,-353.600190,-63.115353,-28.248187,17.703387,38.911307),
             (-2845.175469,449.844989,-1255.915323,886.736783,418.887514,997.912441,-240.979710,76.541307,-36.788069,-170.964086),
             (-1704.720302,-862.308358,447.832178,-889.571909,190.402846,-56.564991,-296.222622,-75.859952,67.473503,3.014055));
var as2r, d2pi, t, e, w, a, s, c : extended;
    i : integer;
begin
d2pi:=pi2;
//Arcseconds to radians
as2r:=secarc;
// Centuries since J2000.
t:=(epj-jd2000)/36525;
//p:=0;
e:=0;
// Periodic terms.
for i:=1 to nper do begin
   W := D2PI*T;
   A := W/peper[1,I];
   sincos(A,S,C);
//   p := p + C*peper[2,I] + S*peper[4,I];
   e := e + C*peper[3,I] + S*peper[5,I];
end;
//Polynomial terms.
W := 1;
for i:=1 to npol do begin
//  p := p + pepol[I,1]*W;
  e := e + pepol[I,2]*W;
  W := W*T;
end;
// in radiant.
//p := p*AS2R;
result := e*AS2R;
end;

///////////////////////

procedure GCRS2J2000_MAT(var rb: rotmatrix);
var rbw: rotmatrix;
    dra0,dpsibi,depsbi,eps0: double;
begin
// Frame bias matrix: GCRS to J2000.0.
   eps0:= 84381.448 * secarc;
   sofa_Bi00(dpsibi,depsbi,dra0);
   sofa_Ir(rbw);
   sofa_Rz(dra0, rbw);
   sofa_Ry(dpsibi * sin(EPS0), rbw);
   sofa_Rx(-depsbi, rbw);
   sofa_Cr(rbw, rb);
end;

procedure GCRS2J2000(var ra, de: double);
var r : rotmatrix;
    p,rp : coordvector;
begin
GCRS2J2000_MAT(r);
sofa_S2C(ra,de,p);
sofa_rxp(r,p,rp);
sofa_c2s(rp,ra,de);
ra:=rmod(ra+pi2,pi2);
end;

procedure J20002GCRS(var ra, de: double);
var r,rt : rotmatrix;
    p,rp : coordvector;
begin
GCRS2J2000_MAT(rt);
sofa_tr(rt,r);
sofa_S2C(ra,de,p);
sofa_rxp(r,p,rp);
sofa_c2s(rp,ra,de);
ra:=rmod(ra+pi2,pi2);
end;

/////////////////////////////////////////
// Refraction from slalib
// P.T.Wallace   Starlink
// License: GPL
// converted from Fortran to Pascal
/////////////////////////////////////////

procedure sla__ATMS (RT, TT, DNT, GAMAL, R: double; var DN, RDNDR: double);
//  Internal routine used by REFRO
//
//  Refractive index and derivative with respect to height for the
//  stratosphere.
//
//  Given:
//    RT      d    height of tropopause from centre of the Earth (metre)
//    TT      d    temperature at the tropopause (K)
//    DNT     d    refractive index at the tropopause
//    GAMAL   d    constant of the atmospheric model = G*MD/R
//    R       d    current distance from the centre of the Earth (metre)
//
//  Returned:
//    DN      d    refractive index at R
//    RDNDR   d    R * rate the refractive index is changing at R
//

var
      B,W: double;

begin
      B := GAMAL/TT;
      W := (DNT-1)*EXP(-B*(R-RT));
      DN := 1+W;
      RDNDR := -R*B*W;
END;

procedure sla__ATMT (R0, T0, ALPHA, GAMM2, DELM2, C1, C2, C3, C4, C5, C6, R: double; var T, DN, RDNDR: double);
//  Internal routine used by REFRO
//
//  Refractive index and derivative with respect to height for the
//  troposphere.
//
//  Given:
//    R0      d    height of observer from centre of the Earth (metre)
//    T0      d    temperature at the observer (K)
//    ALPHA   d    alpha          )
//    GAMM2   d    gamma minus 2  ) see HMNAO paper
//    DELM2   d    delta minus 2  )
//    C1      d    useful term  )
//    C2      d    useful term  )
//    C3      d    useful term  ) see source
//    C4      d    useful term  ) of sla_REFRO
//    C5      d    useful term  )
//    C6      d    useful term  )
//    R       d    current distance from the centre of the Earth (metre)
//
//  Returned:
//    T       d    temperature at R (K)
//    DN      d    refractive index at R
//    RDNDR   d    R * rate the refractive index is changing at R
//
//  Note that in the optical case C5 and C6 are zero.


var
     TT0,TT0GM2,TT0DM2: double;

begin
      T := MAX(MIN(T0-ALPHA*(R-R0),320),100);
      TT0 := T/T0;
      TT0GM2 := TT0**GAMM2;
      TT0DM2 := TT0**DELM2;
      DN := 1+(C1*TT0GM2-(C2-C5/T)*TT0DM2)*TT0;
      RDNDR := R*(-C3*TT0GM2+(C4-C6/TT0)*TT0DM2);
END;

procedure sla_REFRO ( ZOBS, HM, TDK, PMB, RH, WL, PHI, TLR, EPS: double; var REF: double );
//  Atmospheric refraction for radio and optical/IR wavelengths.
//
//  Given:
//    ZOBS    d  observed zenith distance of the source (radian)
//    HM      d  height of the observer above sea level (metre)
//    TDK     d  ambient temperature at the observer (K)
//    PMB     d  pressure at the observer (millibar)
//    RH      d  relative humidity at the observer (range 0-1)
//    WL      d  effective wavelength of the source (micrometre)
//    PHI     d  latitude of the observer (radian, astronomical)
//    TLR     d  temperature lapse rate in the troposphere (K/metre)
//    EPS     d  precision required to terminate iteration (radian)
//
//  Returned:
//    REF     d  refraction: in vacuo ZD minus observed ZD (radian)


//
//  Fixed parameters
//
const
//  93 degrees in radians
      D93=1.623156204;
//  Universal gas constant
      GCR=8314.32;
//  Molecular weight of dry air
      DMD=28.9644;
//  Molecular weight of water vapour
      DMW=18.0152;
//  Mean Earth radius (metre)
      S=6378120.0;
//  Exponent of temperature dependence of water vapour pressure
      DELTA=18.36;
//  Height of tropopause (metre)
      HT=11000.0;
//  Upper limit for refractive effects (metre)
      HS=80000.0;
//  Numerical integration: maximum number of strips.
      ISMAX=16384;

var
      IS1,K,N,I,J: integer;
      OPTIC,LOOP: boolean;
      ZOBS1,ZOBS2,HMOK,TDKOK,PMBOK,RHOK,WLOK,ALPHA,
      TOL,WLSQ,GB,A,GAMAL,GAMMA,GAMM2,DELM2,
      TDC,PSAT,PWO,W,
      C1,C2,C3,C4,C5,C6,R0,TEMPO,DN0,RDNDR0,SK0,F0,
      RT,TT,DNT,RDNDRT,SINE,ZT,FT,DNTS,RDNDRP,ZTS,FTS,
      RS,DNS,RDNDRS,ZS,FS,REFOLD,Z0,ZRANGE,FB,FF,FO,FE,
      H,R,SZ,RG,DR,TG,DN,RDNDR,T,F,REFP,REFT : double;

//  Normalize angle into range +/- pi  (double precision)
function  sla_DRANGE (ANGLE: double): double;
const
     DPI=3.141592653589793238462643;
     D2PI=6.283185307179586476925287;
begin
     sla_DRANGE:=RMOD(ANGLE,D2PI);
     IF (ABS(sla_DRANGE)>=DPI) then
             sla_DRANGE:=sla_DRANGE-D2PI*SIGN(ANGLE);
end;

//  The refraction integrand
function REFI(DN,RDNDR:double): double;
begin
      REFI := RDNDR/(DN+RDNDR);
end;

begin
//  Transform ZOBS into the normal range.
      ZOBS1 := sla_DRANGE(ZOBS);
      ZOBS2 := MIN(ABS(ZOBS1),D93);

//  Keep other arguments within safe bounds.
      HMOK := MIN(MAX(HM,-1E3),HS);
      TDKOK := MIN(MAX(TDK,100),500);
      PMBOK := MIN(MAX(PMB,0),10000);
      RHOK := MIN(MAX(RH,0),1);
      WLOK := MAX(WL,0.1);
      ALPHA := MIN(MAX(ABS(TLR),0.001),0.01);

//  Tolerance for iteration.
      TOL := MIN(MAX(ABS(EPS),1E-12),0.1)/2;

//  Decide whether optical/IR or radio case - switch at 100 microns.
      OPTIC := (WLOK<=100);

//  Set up model atmosphere parameters defined at the observer.
      WLSQ := WLOK*WLOK;
      GB := 9.784*(1-0.0026*COS(PHI+PHI)-0.00000028*HMOK);
      IF (OPTIC) THEN
         A := (287.6155+(1.62887+0.01360/WLSQ)/WLSQ)*273.15E-6/1013.25
      ELSE
         A := 77.6890E-6;
      GAMAL := (GB*DMD)/GCR;
      GAMMA := GAMAL/ALPHA;
      GAMM2 := GAMMA-2;
      DELM2 := DELTA-2;
      TDC := TDKOK-273.15;
      PSAT := 10**((0.7859+0.03477*TDC)/(1+0.00412*TDC))*(1+PMBOK*(4.5E-6+6E-10*TDC*TDC));
      IF (PMBOK > 0) THEN
         PWO := RHOK*PSAT/(1-(1-RHOK)*PSAT/PMBOK)
      ELSE
         PWO := 0;
      W := PWO*(1-DMW/DMD)*GAMMA/(DELTA-GAMMA);
      C1 := A*(PMBOK+W)/TDKOK;
      IF (OPTIC) THEN
         C2 := (A*W+11.2684E-6*PWO)/TDKOK
      ELSE
         C2 := (A*W+6.3938E-6*PWO)/TDKOK;
      C3 := (GAMMA-1)*ALPHA*C1/TDKOK;
      C4 := (DELTA-1)*ALPHA*C2/TDKOK;
      IF (OPTIC) THEN begin
         C5 := 0;
         C6 := 0;
      end ELSE begin
         C5 := 375463E-6*PWO/TDKOK;
         C6 := C5*DELM2*ALPHA/(TDKOK*TDKOK);
      END;

//  Conditions at the observer.
      R0 := S+HMOK;
      sla__ATMT(R0,TDKOK,ALPHA,GAMM2,DELM2,C1,C2,C3,C4,C5,C6,R0,TEMPO,DN0,RDNDR0);
      SK0 := DN0*R0*SIN(ZOBS2);
      F0 := REFI(DN0,RDNDR0);

//  Conditions in the troposphere at the tropopause.
      RT := S+MAX(HT,HMOK);
      sla__ATMT(R0,TDKOK,ALPHA,GAMM2,DELM2,C1,C2,C3,C4,C5,C6,RT,TT,DNT,RDNDRT);
      SINE := SK0/(RT*DNT);
      ZT := ArcTAN2(SINE,SQRT(MAX(1-SINE*SINE,0)));
      FT := REFI(DNT,RDNDRT);

//  Conditions in the stratosphere at the tropopause.
      sla__ATMS(RT,TT,DNT,GAMAL,RT,DNTS,RDNDRP);
      SINE := SK0/(RT*DNTS);
      ZTS := ArcTAN2(SINE,SQRT(MAX(1-SINE*SINE,0)));
      FTS := REFI(DNTS,RDNDRP);

//  Conditions at the stratosphere limit.
      RS := S+HS;
      sla__ATMS(RT,TT,DNT,GAMAL,RS,DNS,RDNDRS);
      SINE := SK0/(RS*DNS);
      ZS := ArcTAN2(SINE,SQRT(MAX(1-SINE*SINE,0)));
      FS := REFI(DNS,RDNDRS);

//  Variable initialization to avoid compiler warning.
      REFT := 0;

//  Integrate the refraction integral in two parts;  first in the
//  troposphere (K=1), then in the stratosphere (K=2).

      for K := 1 to 2 do begin

//     Initialize previous refraction to ensure at least two iterations.
         REFOLD := 1;

//     Start off with 8 strips.
         IS1 := 8;

//     Start Z, Z range, and start and end values.
         IF (K=1) THEN begin
            Z0 := ZOBS2;
            ZRANGE := ZT-Z0;
            FB := F0;
            FF := FT;
         end ELSE begin
            Z0 := ZTS;
            ZRANGE := ZS-Z0;
            FB := FTS;
            FF := FS;
         END;

//     Sums of odd and even values.
         FO := 0;
         FE := 0;

//     First time through the loop we have to do every point.
         N := 1;

//     Start of iteration loop (terminates at specified precision).
         LOOP := TRUE;
         WHILE LOOP do begin

//        Strip width.
            H := ZRANGE/IS1;

//        Initialize distance from Earth centre for quadrature pass.
            IF (K=1) THEN
               R := R0
            ELSE
               R := RT;

//        One pass (no need to compute evens after first time).
            I:=1;
            while I<IS1 do begin  // replace for loop with variable increment

//           Sine of observed zenith distance.
               SZ := SIN(Z0+H*I);

//           Find R (to the nearest metre, maximum four iterations).
               IF (SZ>1E-20) THEN begin
                  W := SK0/SZ;
                  RG := R;
                  DR := 1E6;
                  J := 0;
                  WHILE ((ABS(DR)>1)AND(J<4)) do begin
                     J:=J+1;
                     IF (K=1) THEN
                        sla__ATMT(R0,TDKOK,ALPHA,GAMM2,DELM2,C1,C2,C3,C4,C5,C6,RG,TG,DN,RDNDR)
                     ELSE
                        sla__ATMS(RT,TT,DNT,GAMAL,RG,DN,RDNDR);
                     DR := (RG*DN-W)/(DN+RDNDR);
                     RG := RG-DR;
                  END; // while
                  R := RG;
               END;

//           Find the refractive index and integrand at R.
               IF (K=1) THEN
                  sla__ATMT(R0,TDKOK,ALPHA,GAMM2,DELM2,C1,C2,C3,C4,C5,C6,R,T,DN,RDNDR)
               ELSE
                  sla__ATMS(RT,TT,DNT,GAMAL,R,DN,RDNDR);
               F := REFI(DN,RDNDR);

//           Accumulate odd and (first time only) even values.
               IF ((N=1)AND((I mod 2)=0)) THEN
                  FE := FE+F
               ELSE
                  FO := FO+F;

               inc(I,N);
            END; // while I // for I

//        Evaluate the integrand using Simpson's Rule.
            REFP := H*(FB+4*FO+2*FE+FF)/3;

//        Has the required precision been achieved (or can't be)?
            IF ((ABS(REFP-REFOLD)>TOL)AND(IS1<ISMAX)) THEN begin

//           No: prepare for next iteration.

//           Save current value for convergence test.
               REFOLD := REFP;

//           Double the number of strips.
               IS1 := IS1+IS1;

//           Sum of all current values = sum of next pass's even values.
               FE := FE+FO;

//           Prepare for new odd values.
               FO := 0;

//           Skip even values next time.
               N := 2;
            end ELSE begin

//           Yes: save troposphere component and terminate the loop.
               IF (K=1) then REFT := REFP;
               LOOP := FALSE;
            END; // IF
         END; // WHILE LOOP
      END; // for K

//  Result.
      REF := REFT+REFP;
      IF (ZOBS1<0) then REF := -REF;

      END;


procedure sla_REFCO ( HM, TDK, PMB, RH, WL, PHI, TLR, EPS: double; var REFA, REFB: double );
//  Determine the constants A and B in the atmospheric refraction
//  model dZ = A tan Z + B tan**3 Z.
//
//  Z is the "observed" zenith distance (i.e. affected by refraction)
//  and dZ is what to add to Z to give the "topocentric" (i.e. in vacuo)
//  zenith distance.
//
//  Given:
//    HM      d     height of the observer above sea level (metre)
//    TDK     d     ambient temperature at the observer (K)
//    PMB     d     pressure at the observer (millibar)
//    RH      d     relative humidity at the observer (range 0-1)
//    WL      d     effective wavelength of the source (micrometre)
//    PHI     d     latitude of the observer (radian, astronomical)
//    TLR     d     temperature lapse rate in the troposphere (K/metre)
//    EPS     d     precision required to terminate iteration (radian)
//
//  Returned:
//    REFA    d     tan Z coefficient (radian)
//    REFB    d     tan**3 Z coefficient (radian)
//
var
      R1,R2: double;

//  Sample zenith distances: arctan(1) and arctan(4)
const ATN1=0.7853981633974483;
      ATN4=1.325817663668033;

begin
//  Determine refraction for the two sample zenith distances
      sla_REFRO(ATN1,HM,TDK,PMB,RH,WL,PHI,TLR,EPS,R1);
      sla_REFRO(ATN4,HM,TDK,PMB,RH,WL,PHI,TLR,EPS,R2);

//  Solve for refraction constants
      REFA := (64*R1-R2)/60;
      REFB := (R2-4*R1)/60;

END;

procedure cdc_REFCO ( HM, TDK, PMB, RH, WL, PHI, TLR, EPS, H1, H2: double; var REFA, REFB: double );
//  Same function as sla_REFRO but return coefficient adjusted for other zenith distance.
//
//  Determine the constants A and B in the atmospheric refraction
//  model dZ = A tan Z + B tan**3 Z.
//
//  Z is the "observed" zenith distance (i.e. affected by refraction)
//  and dZ is what to add to Z to give the "topocentric" (i.e. in vacuo)
//  zenith distance.
//
//  Given:
//    HM      d     height of the observer above sea level (metre)
//    TDK     d     ambient temperature at the observer (K)
//    PMB     d     pressure at the observer (millibar)
//    RH      d     relative humidity at the observer (range 0-1)
//    WL      d     effective wavelength of the source (micrometre)
//    PHI     d     latitude of the observer (radian, astronomical)
//    TLR     d     temperature lapse rate in the troposphere (K/metre)
//    EPS     d     precision required to terminate iteration (radian)
//    H1      d     first reference Z
//    H2      d     second reference Z   H2>H1
//
//  Returned:
//    REFA    d     tan Z coefficient (radian)
//    REFB    d     tan**3 Z coefficient (radian)
//
var
      R1,R2,a,b,d,e: double;

begin
//  Determine refraction for the two sample zenith distances
      sla_REFRO(H1,HM,TDK,PMB,RH,WL,PHI,TLR,EPS,R1);
      sla_REFRO(H2,HM,TDK,PMB,RH,WL,PHI,TLR,EPS,R2);

//  Solve for refraction constants
      a := tan(H1);
      b := a*a*a;
      d := tan(H2);
      e := d*d*d;
      REFA := (R1*e - R2*b) / (a*e-d*b);
      REFB := (a*R2 - d*R1) / (a*e-d*b);

END;

Procedure sla_REFCOQ (TDK, PMB, RH, WL: double; var REFA, REFB: double );
//
//  Given:
//    TDK      d      ambient temperature at the observer (K)
//    PMB      d      pressure at the observer (millibar)
//    RH       d      relative humidity at the observer (range 0-1)
//    WL       d      effective wavelength of the source (micrometre)
//
//  Returned:
//    REFA     d      tan Z coefficient (radian)
//    REFB     d      tan**3 Z coefficient (radian)

var OPTIC: boolean;
    T,P,R,W,TDC,PS,PW,WLSQ,GAMMA,BETA: double;

begin
//  Decide whether optical/IR or radio case:  switch at 100 microns.
      OPTIC := (WL <= 100);

//  Restrict parameters to safe values.
      T := MIN(MAX(TDK,100),500);
      P := MIN(MAX(PMB,0),10000);
      R := MIN(MAX(RH,0),1);
      W := MIN(MAX(WL,0.1),1E6);

//  Water vapour pressure at the observer.
      IF (P>0) THEN begin
         TDC := T-273.15;
         PS := 10**((0.7859+0.03477*TDC)/(1+0.00412*TDC))*(1+P*(4.5E-6+6E-10*TDC*TDC));
         PW := R*PS/(1-(1-R)*PS/P);
      end
      ELSE begin
         PW := 0;
      END;

//  Refractive index minus 1 at the observer.
      IF OPTIC THEN begin
         WLSQ := W*W;
         GAMMA := ((77.53484E-6+(4.39108E-7+3.666E-9/WLSQ)/WLSQ)*P -11.2684E-6*PW)/T;
      end
      ELSE begin
         GAMMA := (77.6890E-6*P-(6.3938E-6-0.375463E0/T)*PW)/T;
      END;

//  Formula for beta adapted from Stone, with empirical adjustments.
      BETA:=4.4474E-6*T;
      IF (NOT OPTIC) then BETA:=BETA-0.0074*PW*BETA;

//  Refraction constants from Green.
      REFA := GAMMA*(1-BETA);
      REFB := -GAMMA*(BETA-GAMMA/2);

END;

Procedure sla_REFZ (ZU, REFA, REFB: double; var ZR:double);
//
//  Given:
//    ZU    dp    unrefracted zenith distance of the source (radian)
//    REFA  dp    tan Z coefficient (radian)
//    REFB  dp    tan**3 Z coefficient (radian)
//
//  Returned:
//    ZR    dp    refracted zenith distance (radian)

const
//  Radians to degrees
      R2D=57.29577951308232;

//  Largest usable ZD (deg)
      D93=93.0;

//  Coefficients for high ZD model (used beyond ZD 83 deg)
      C1=+0.55445;
      C2=-0.01133;
      C3=+0.00202;
      C4=+0.28385;
      C5=+0.02390;

//  ZD at which one model hands over to the other (radians)
      Z83=83.0/R2D;

//  High-ZD-model prediction (deg) for that point
      REF83=(C1+C2*7+C3*49)/(1+C4*7+C5*49);

var
      ZU1,ZL,S,C,T,TSQ,TCU,REF,E,E2: double;

begin
//  Perform calculations for ZU or 83 deg, whichever is smaller
      ZU1 := MIN(ZU,Z83);

//  Functions of ZD
      ZL := ZU1;
      S := SIN(ZL);
      C := COS(ZL);
      T := S/C;
      TSQ := T*T;
      TCU := T*TSQ;

//  Refracted ZD (mathematically to better than 1 mas at 70 deg)
      ZL := ZL-(REFA*T+REFB*TCU)/(1+(REFA+3*REFB*TSQ)/(C*C));

//  Further iteration
      S := SIN(ZL);
      C := COS(ZL);
      T := S/C;
      TSQ := T*T;
      TCU := T*TSQ;
      REF := ZU1-ZL+(ZL-ZU1+REFA*T+REFB*TCU)/(1+(REFA+3*REFB*TSQ)/(C*C));

// Special handling for large ZU
      IF (ZU>ZU1) THEN begin
         E := 90-MIN(D93,ZU*R2D);
         E2 := E*E;
         REF := (REF/REF83)*(C1+C2*E+C3*E2)/(1+C4*E+C5*E2);
      END;

//  Return refracted ZD
      ZR := ZU-REF;

END;

Procedure sla_GEOC (P,H: double; var R, Z: double);
//
// Convert geodetic position to geocentric (double precision)
//
// Given:
// P dp latitude (geodetic, radians)
// H dp height above reference spheroid (geodetic, metres)
//
// Returned:
// R dp distance from Earth axis (AU)
// Z dp distance from plane of Earth equator (AU)
//
const
// Earth equatorial radius (metres)
      A0=6378140;
// Reference spheroid flattening factor and useful function
      F=1/298.257;
      B=(1-F)*(1-F);
// Astronomical unit in metres
      AU=1.49597870E11;

var SP,CP,C,S: double;
begin
// Geodetic to geocentric conversion
SP := SIN(P);
CP := COS(P);
C := 1/SQRT(CP*CP+B*SP*SP);
S := B*C;
R := (A0*C+H)*CP/AU;
Z := (A0*S+H)*SP/AU;
end;

Procedure sla_POLMO ( ELONGM, PHIM, XP, YP: Double; var ELONG, PHI, DAZ: Double );
//  Polar motion:  correct site longitude and latitude for polar
//  motion and calculate azimuth difference between celestial and
//  terrestrial poles.
//
//  Given:
//     ELONGM   d      mean longitude of the observer (radians, east +ve)
//     PHIM     d      mean geodetic latitude of the observer (radians)
//     XP       d      polar motion x-coordinate (radians)
//     YP       d      polar motion y-coordinate (radians)
//
//  Returned:
//     ELONG    d      true longitude of the observer (radians, east +ve)
//     PHI      d      true geodetic latitude of the observer (radians)
//     DAZ      d      azimuth correction (terrestrial-celestial, radians)
//

var SEL,CEL,SPH,CPH,XM,YM,ZM,XNM,YNM,ZNM,
    SXP,CXP,SYP,CYP,ZW,XT,YT,ZT,XNT,YNT : Double;

begin
//  Site mean longitude and mean geodetic latitude as a Cartesian vector
SEL:=SIN(ELONGM);
CEL:=COS(ELONGM);
SPH:=SIN(PHIM);
CPH:=COS(PHIM);

XM:=CEL*CPH;
YM:=SEL*CPH;
ZM:=SPH;

//  Rotate site vector by polar motion, Y-component then X-component
SXP:=SIN(XP);
CXP:=COS(XP);
SYP:=SIN(YP);
CYP:=COS(YP);

ZW:=(-YM*SYP+ZM*CYP);

XT:=XM*CXP-ZW*SXP;
YT:=YM*CYP+ZM*SYP;
ZT:=XM*SXP+ZW*CXP;

//  Rotate also the geocentric direction of the terrestrial pole (0,0,1)
XNM:=-SXP*CYP;
YNM:=SYP;
ZNM:=CXP*CYP;

CPH:=SQRT(XT*XT+YT*YT);
IF (CPH=0) then XT:=1;
SEL:=YT/CPH;
CEL:=XT/CPH;

//  Return true longitude and true geodetic latitude of site
IF (XT<>0)OR(YT<>0) THEN
   ELONG:=ArcTAN2(YT,XT)
ELSE
   ELONG:=0;
PHI:=ArcTAN2(ZT,CPH);

//  Return current azimuth of terrestrial pole seen from site position
XNT:=(XNM*CEL+YNM*SEL)*ZT-ZNM*CPH;
YNT:=-XNM*SEL+YNM*CEL;
IF (XNT<>0)OR(YNT<>0) THEN
   DAZ:=ArcTAN2(-YNT,-XNT)
ELSE
   DAZ:=0;

END;



end.
