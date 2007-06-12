unit u_projection;
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
 Projection functions
}
{$mode objfpc}{$H+}
interface
uses u_constant, u_util,
     Math, SysUtils, Graphics;

Procedure ScaleWindow(c: Tconf_skychart);
Function RotationAngle(x1,y1,x2,y2: double; c: Tconf_skychart): double;
Procedure WindowXY(x,y:Double; out WindowX,WindowY: single; c: Tconf_skychart);
Procedure XYWindow( x,y: Integer; var Xwindow,Ywindow: double; c: Tconf_skychart);
function Projection(ar,de : Double ; VAR X,Y : Double; clip:boolean; c: Tconf_skychart; tohrz:boolean=false):boolean;
function Proj2(ar,de,ac,dc : Double ; VAR X,Y : Double; c: Tconf_skychart ):boolean;
PROCEDURE Proj3(ar,de,ac,dc : Double ; VAR X,Y : Double; c: Tconf_skychart );
Procedure InvProj (xx,yy : Double ; VAR ar,de : Double; c: Tconf_skychart );
Procedure InvProj2 (xx,yy,ac,dc : Double ; VAR ar,de : Double; c: Tconf_skychart );
procedure GetADxy(x,y:Integer ; var a,d : Double; c: Tconf_skychart);
procedure GetAHxy(x,y:Integer ; var a,h : Double; c: Tconf_skychart);
procedure GetAHxyF(x,y:Integer ; var a,h : Double; c: Tconf_skychart);
procedure GetLBxy(x,y:Integer ; var l,b : Double; c: Tconf_skychart);
procedure GetLBExy(x,y:Integer ; var le,be : Double; c: Tconf_skychart);
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
function SidTim(jd0,ut,long : double): double;
procedure Paralaxe(SideralTime,dist,ar1,de1 : double; var ar,de,q : double; c: Tconf_skychart);
PROCEDURE PrecessionFK4(ti,tf : double; VAR ari,dei : double);
PROCEDURE Precession(ti,tf : double; VAR ari,dei : double);
procedure PrecessionEcl(ti,tf : double; VAR l,b : double);
PROCEDURE HorizontalGeometric(HH,DE : double ; VAR A,h : double; c: Tconf_skychart);
PROCEDURE Eq2Hz(HH,DE : double ; VAR A,h : double; c: Tconf_skychart );
Procedure Hz2Eq(A,h : double; var hh,de : double; c: Tconf_skychart);
function ecliptic(j:double):double;
procedure nutation(j:double; var nutl,nuto:double);
procedure aberration(j:double; var abe,abp:double);
procedure apparent_equatorial(var ra,de:double; c: Tconf_skychart);
procedure mean_equatorial(var ra,de:double; c: Tconf_skychart);
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

Procedure Time_Alt(jd,ar,de,h :Double; VAR hp1,hp2 :Double; c: Tconf_skychart );
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


implementation


Procedure ScaleWindow(c: Tconf_skychart);
var X1,x2,Y1,Y2 : Integer;
begin
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

function Proj2(ar,de,ac,dc : Double ; VAR X,Y : Double; c: Tconf_skychart ):boolean;
Var r,hh,s1,s2,s3,c1,c2,c3,xx,yy : Extended ;
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
    ar:=rmod(ar+pi4,pi2);
    hh:=rmod(ac+pi,pi2);
    if ar>hh then ar:=ar-hh
             else ar:=ar+pi2-hh;
    ac:=rmod(hh-ac+pi2,pi2);
    xx:=ac-ar;
    yy:=de-dc;
    result:=true;
    end;
'S' : begin                 // SIN
    hh := ar-ac ;
    sincos(dc,s1,c1);
    sincos(de,s2,c2);
    sincos(hh,s3,c3);
    r:=s1*s2+c2*c1*c3;  // cos the
    if r<=0 then begin  // > 90°
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
    if r<=0 then begin  // > 90°
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
X:=xx*c.costheta+yy*c.sintheta;
Y:=yy*c.costheta-xx*c.sintheta;
END ;

PROCEDURE Proj3(ar,de,ac,dc : Double ; VAR X,Y : Double; c: Tconf_skychart );
Var r,hh,s1,s2,s3,c1,c2,c3,xx,yy : Extended ;
BEGIN
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
    end;
'C' : begin                 // CAR
    ar:=rmod(ar+pi4,pi2);
    hh:=rmod(ac+pi,pi2);
    if ar>hh then ar:=ar-hh
             else ar:=ar+pi2-hh;
    ac:=rmod(hh-ac+pi2,pi2);
    xx:=ac-ar;
    yy:=de-dc;
    end;
'S' : begin                 // SIN
    hh := ar-ac ;
    sincos(dc,s1,c1);
    sincos(de,s2,c2);
    sincos(hh,s3,c3);
    r:=s1*s2+c2*c1*c3;  // cos the
    if r<=0 then begin  // > 90°
      xx:=200;
      yy:=200;
    end else begin
      xx:= -(c2*s3);
      yy:= s2*c1-c2*s1*c3;
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
    if r<=0 then begin  // > 90°
      xx:=200;
      yy:=200;
    end else begin
      xx := -( c2*s3/r );
      yy := (s2*c1-c2*s1*c3)/r ;
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
    end;
end;
X:=double(xx);
Y:=double(yy);
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
       Eq2Ecl(ar,de,c.e,a,h) ;
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

Procedure InvProj2 (xx,yy,ac,dc : Double ; VAR ar,de : Double; c: Tconf_skychart);
Var a,r,hh,s1,c1,s2,c2,s3,c3,x,y : Extended ;
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
'C' : begin
    ar:=ac-x;
    de:=dc-y;
    if de>0 then de:=double(min(de,pid2-0.00002)) else de:=double(max(de,-pid2-0.00002));
    end;
'S' : begin
    sincos(dc,s1,c1);
    x:=-(x);
    y:=-(y);
    r:=sqrt(1-x*x-y*y);
    ar:=ac+(arctan2(x,(c1*r-y*s1)));
    de:=double(arcsin(y*c1+s1*r));
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
       Ecl2Eq(ar,de,c.e,a,hh) ;
       ar:=a;
       de:=hh;
       end;
end;
end ;

procedure GetADxy(x,y:Integer ; var a,d : Double; c: Tconf_skychart);
var
   x1,y1: Double;
begin
x1:=0;y1:=0;
  XYwindow(x,y,x1,y1,c);
  InvProj (x1,y1,a,d,c);
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

function NorthPoleInMap(c: Tconf_skychart) : Boolean;
var a,d,x1,y1: Double; xx,yy : single;
begin
a:=0 ; d:=pid2;
x1:=0;y1:=0;xx:=0;yy:=0;
projection(a,d,x1,y1,false,c) ;
windowxy(x1,y1,xx,yy,c);
Result:=(xx>=c.xmin) and (xx<=c.xmax) and (yy>=c.ymin) and (yy<=c.ymax);
end;

function SouthPoleInMap(c: Tconf_skychart) : Boolean;
var a,d,x1,y1: Double; xx,yy : single;
begin
a:=0 ; d:=-pid2;
x1:=0;y1:=0;xx:=0;yy:=0;
projection(a,d,x1,y1,false,c) ;
windowxy(x1,y1,xx,yy,c);
Result:=(xx>=c.xmin) and (xx<=c.xmax) and (yy>=c.ymin) and (yy<=c.ymax);
end;

function NorthPole2000InMap(c: Tconf_skychart) : Boolean;
var a,d,x1,y1: Double; xx,yy : single;
begin
a:=c.rap2000 ; d:=c.dep2000;
x1:=0;y1:=0;xx:=0;yy:=0;
projection(a,d,x1,y1,false,c) ;
windowxy(x1,y1,xx,yy,c);
Result:=(xx>=c.xmin) and (xx<=c.xmax) and (yy>=c.ymin) and (yy<=c.ymax);
end;

function SouthPole2000InMap(c: Tconf_skychart) : Boolean;
var a,d,x1,y1: Double; xx,yy : single;
begin
a:=0;
d:=-pid2;
x1:=0;y1:=0;xx:=0;yy:=0;
precession(jd2000,c.JDChart,a,d);
projection(a,d,x1,y1,false,c) ;
windowxy(x1,y1,xx,yy,c);
Result:=(xx>=c.xmin) and (xx<=c.xmax) and (yy>=c.ymin) and (yy<=c.ymax);
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
    result:= pi+arctan2((c2*s3) , (-c1*s2+s1*c2*c3) );
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

function SidTim(jd0,ut,long : double): double;
 VAR t,te: double;
BEGIN
 t:=(jd0-2451545.0)/36525;
 te:=100.46061837 + 36000.770053608*t + 0.000387933*t*t - t*t*t/38710000;
 result := deg2rad*Rmod(te - long + 1.00273790935*ut*15,360) ;
END ;

procedure Paralaxe(SideralTime,dist,ar1,de1 : double; var ar,de,q : double; c: Tconf_skychart);
var
   sinpi,H,a,b,d : double;
const
     desinpi = 4.26345151e-5;
begin
// AR, DE may be standard epoch but paralaxe is to be computed with coordinates of the date.
precession(c.JDchart,c.curjd,ar1,de1);
H:=(SideralTime-ar1);
//rde:=de1;
sinpi:=desinpi/dist;
a := cos(de1)*sin(H);
b := cos(de1)*cos(H)-c.ObsRoCosPhi*sinpi;
d := sin(de1)-c.ObsRoSinPhi*sinpi;
q := sqrt(a*a+b*b+d*d);
ar:=SideralTime-arctan2(a,b);
de:=double(arcsin(d/q));
precession(c.curjd,c.JDchart,ar,de);
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

PROCEDURE Precession(ti,tf : double; VAR ari,dei : double);  // ICRS
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

PROCEDURE Eq2Hz(HH,DE : double ; VAR A,h : double; c: Tconf_skychart);
var l1,d1,h1 : double;
BEGIN
l1:=deg2rad*c.ObsLatitude;
d1:=DE;
h1:=HH;
h:= double(arcsin( sin(l1)*sin(d1)+cos(l1)*cos(d1)*cos(h1) ));
A:= double(arctan2(sin(h1),cos(h1)*sin(l1)-tan(d1)*cos(l1)));
A:=Rmod(A+pi2,pi2);
{ refraction meeus91 15.4 }
h1:=rad2deg*h;
if h1>-1 then h:=double(minvalue([pid2,h+deg2rad*c.ObsRefractionCor*(1.02/tan(deg2rad*(h1+10.3/(h1+5.11))))/60]))
         else h:=h+deg2rad*c.ObsRefractionCor*0.64658062088*(h1+90)/89;
END ;

Procedure Hz2Eq(A,h : double; var hh,de : double; c: Tconf_skychart);
var l1,a1,h1 : double;
BEGIN
l1:=deg2rad*c.ObsLatitude;
a1:=A;
h:=h-c.RefractionOffset; // correction for the refraction equation reversibility at the chart center
{ refraction meeus91 15.3 }
h1:=rad2deg*h;
if h1>-0.3534193791 then h:=double(minvalue([pid2,h-deg2rad*c.ObsRefractionCor*(1/tan(deg2rad*(h1+(7.31/(h1+4.4)))))/60]))
                    else h:=h-deg2rad*c.ObsRefractionCor*0.65705159*(h1+90)/89.64658;
h1:=h;
de:= double(arcsin( sin(l1)*sin(h1)-cos(l1)*cos(h1)*cos(a1) ));
hh:= double(arctan2(sin(a1),cos(a1)*sin(l1)+tan(h1)*cos(l1)));
hh:=Rmod(hh+pi2,pi2);
END ;

function ecliptic(j:double):double;
var u : double;
begin
{meeus91 21.3}
u:=(j-jd2000)/3652500;
result:=eps2000 +(
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

procedure nutation(j:double; var nutl,nuto:double);
var t,om,me,mas,mam,al : double;
begin
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
end;

procedure aberration(j:double; var abe,abp:double);
var t : double;
begin
t:=(j-jd2000)/36525;
abe:=0.016708617-4.2037e-5*t-1.236e-7*t*t;
abp:=deg2rad*(102.93735+1.71953*t+4.6e-4*t*t);
end;

procedure apparent_equatorial(var ra,de:double; c: Tconf_skychart);
var da,dd,l,b: double;
    cra,sra,cde,sde,ce,se,cp,sp,cls,sls: extended;
begin
cra:=0;sra:=0;cde:=0;sde:=0;ce:=0;se:=0;cp:=0;sp:=0;cls:=0;sls:=0;l:=0;b:=0;
sincos(ra,sra,cra);
sincos(de,sde,cde);
sincos(c.e,se,ce);
sincos(c.sunl,sls,cls);
sincos(c.abp,sp,cp);
// nutation
if abs(de)<(89*deg2rad) then begin    // meeus91 22.1
   da:=c.nutl*(ce+se*sra*tan(de))-c.nuto*(cra*tan(de));
   dd:=c.nutl*se*cra+c.nuto*sra;
   ra:=ra+da;
   de:=de+dd;
end else begin
   Eq2Ecl(ra,de,c.e,l,b);
   l:=l+c.nutl;
   b:=b+c.nuto;
   Ecl2Eq(l,b,c.e,ra,de);
end;
//aberration
//meeus91 22.3
da:=-abek*(cra*cls*ce+sra*sls)/cde + c.abe*abek*(cra*cp*ce+sra*sp)/cde;
dd:=-abek*(cls*ce*((se/ce)*cde-sra*sde)+cra*sde*sls) + c.abe*abek*(cp*ce*((se/ce)*cde-sra*sde)+cra*sde*sp);
ra:=ra+da;
de:=de+dd;
end;

procedure mean_equatorial(var ra,de:double; c: Tconf_skychart);
var da,dd,l,b: double;
    cra,sra,cde,sde,ce,se,cp,sp,cls,sls: extended;
begin
cra:=0;sra:=0;cde:=0;sde:=0;ce:=0;se:=0;cp:=0;sp:=0;cls:=0;sls:=0;l:=0;b:=0;
sincos(ra,sra,cra);
sincos(de,sde,cde);
sincos(c.e,se,ce);
sincos(c.sunl,sls,cls);
sincos(c.abp,sp,cp);
// nutation
if abs(de)<(89*deg2rad) then begin    // meeus91 22.1
   da:=c.nutl*(ce+se*sra*tan(de))-c.nuto*(cra*tan(de));
   dd:=c.nutl*se*cra+c.nuto*sra;
   ra:=ra-da;
   de:=de-dd;
end else begin
   Eq2Ecl(ra,de,c.e,l,b);
   l:=l-c.nutl;
   b:=b-c.nuto;
   Ecl2Eq(l,b,c.e,ra,de);
end;
//aberration
//meeus91 22.3
da:=-abek*(cra*cls*ce+sra*sls)/cde + c.abe*abek*(cra*cp*ce+sra*sp)/cde;
dd:=-abek*(cls*ce*(tan(c.e)*cde-sra*sde)+cra*sde*sls) + c.abe*abek*(cp*ce*(tan(c.e)*cde-sra*sde)+cra*sde*sp);
ra:=ra-da;
de:=de-dd;
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

Procedure Time_Alt(jd,ar,de,h :Double; VAR hp1,hp2 :Double; c: Tconf_skychart );
VAR hh,st,st0 : Double ;
BEGIN
hh := (sin(deg2rad*h)-sin(deg2rad*c.ObsLatitude)*sin(de))/(cos(deg2rad*c.ObsLatitude)*cos(de)) ;
if abs(hh)<=1 then begin
     hh := double(arccos(hh)) ;
     st0 := rad2deg*sidtim(jd,0.0,c.ObsLongitude)/15 ;
     st := rad2deg*(ar-hh)/15 ;
     hp1 := rmod((st-st0)/1.002737908+24,24) ;
     st := rad2deg*(ar+hh)/15 ;
     hp2 := rmod((st-st0)/1.002737908+24,24) ;
end else begin
     hp1:=-99;
     hp2:=-99;
end;
END;


end.

