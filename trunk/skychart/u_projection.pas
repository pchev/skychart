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

interface
uses u_constant, u_util,
     Math, Types, Inifiles, SysUtils,
{$ifdef linux}
    QGraphics;
{$endif}
{$ifdef mswindows}
    Graphics;
{$endif}

Procedure ScaleWindow(var c:conf_skychart);
Procedure WindowXY(x,y:Double; var WindowX,WindowY: Integer; var c:conf_skychart);
Procedure XYWindow( x,y: Integer; var Xwindow,Ywindow: double; var c:conf_skychart);
PROCEDURE Projection(ar,de : Double ; VAR X,Y : Double; clip:boolean; var c:conf_skychart);
PROCEDURE Proj2(ar,de,ac,dc : Double ; VAR X,Y : Double; var c:conf_skychart );
Procedure InvProj (xx,yy : Double ; VAR ar,de : Double; var c:conf_skychart );
Procedure InvProj2 (xx,yy,ac,dc : Double ; VAR ar,de : Double; var c:conf_skychart );
procedure GetADxy(x,y:Integer ; var a,d : Double; var c:conf_skychart);
procedure GetAHxy(x,y:Integer ; var a,h : Double; var c:conf_skychart);
procedure GetAHxyF(x,y:Integer ; var a,h : Double; var c:conf_skychart);
function NorthPoleInMap(var c:conf_skychart) : Boolean;
function SouthPoleInMap(var c:conf_skychart) : Boolean;
function NorthPole2000InMap(var c:conf_skychart) : Boolean;
function SouthPole2000InMap(var c:conf_skychart) : Boolean;
function ZenithInMap(var c:conf_skychart) : Boolean;
function NadirInMap(var c:conf_skychart) : Boolean;
Function AngularDistance(ar1,de1,ar2,de2 : Double) : Double;
function PositionAngle(ac,dc,ar,de:double):double;
function Jd(annee,mois,jour :INTEGER; Heure:double):double;
PROCEDURE Djd(jd:Double;VAR annee,mois,jour:INTEGER; VAR Heure:double);
function SidTim(jd0,ut,long : double): double;
procedure Paralaxe(SideralTime,dist,ar1,de1 : double; var ar,de,q : double; var c:conf_skychart);
function SetCurrentTime(var cfgsc:conf_skychart):boolean;
function DTminusUT(annee : integer; var c:conf_skychart) : double;
PROCEDURE PrecessionFK4(ti,tf : double; VAR ari,dei : double);
PROCEDURE Precession(ti,tf : double; VAR ari,dei : double);
procedure PrecessionEcl(ti,tf : double; VAR l,b : double);
PROCEDURE HorizontalGeometric(HH,DE : double ; VAR A,h : double; var c:conf_skychart);
PROCEDURE Eq2Hz(HH,DE : double ; VAR A,h : double; var c:conf_skychart );
Procedure Hz2Eq(A,h : double; var hh,de : double; var c:conf_skychart);
Procedure Ecl2Eq(l,b,e: double; var ar,de : double);
Procedure Eq2Ecl(ar,de,e: double; var l,b: double);
Procedure Gal2Eq(l,b: double; var ar,de : double; var c:conf_skychart);
{Procedure RiseSet(typobj:integer; jd0,ar,de:double; var hr,ht,hs,azr,azs:double;var irc:integer);
          (* typeobj = 1 etoile ; typeobj = 2 soleil,lune
            irc = 0 lever et coucher
            irc = 1 circumpolaire
            irc = 2 invisible
          *)
Procedure HeurePo(jd,ar,de,h :Double; VAR hp1,hp2 :Double );
          (*
             Heure a laquel un astre est a un hauteur donnee sur l'horizon .
             jd       :  date julienne desiree a 0H TU
             ar       :  ascension droite
             de       :  declinaison
             h        :  hauteur sur l'horizon
                         crepuscule nautique h=-12
                         crepuscule astronomique h=-18
             hp1      :  heure matin
             hp2      :  heure soir
           *)
procedure RiseSetInt(typobj:integer; jd0,ar1,de1,ar2,de2,ar3,de3:double; var hr,ht,hs,azr,azs:double;var irc:integer);
}
Function YearADBC(year : integer) : string;


implementation


Procedure ScaleWindow(var c:conf_skychart);
var X1,x2,Y1,Y2 : Integer;
begin
   X1 := c.Xmin+c.LeftMargin ; X2 := c.Xmax-c.RightMargin;
   Y1 := c.Ymin+c.TopMargin ; Y2 := c.Ymax-c.BottomMargin;
   c.WindowRatio := (X2-X1) / (Y2-Y1) ;
   c.Xcentre:=round((x2-x1)/2);
   c.Ycentre:=round((y2-y1)/2);
   c.Xwrldmin := -c.fov/2;
   c.Ywrldmin := -c.fov/c.WindowRatio/2;
   c.Xwrldmax := c.fov/2;
   c.Ywrldmax := c.fov/c.WindowRatio/2;
   c.BxGlb:= c.FlipX * (X2-X1) / (c.Xwrldmax-c.Xwrldmin) ;
   c.ByGlb:= c.FlipY * (Y1-Y2) / (c.Ywrldmax-c.Ywrldmin) ;
   c.AxGlb:= c.FlipX * (- c.Xwrldmin * c.BxGlb) ;
   c.AyGlb:=  c.FlipY * ( c.Ywrldmin * c.ByGlb) ;
   c.sintheta:=sin(c.theta);
   c.costheta:=cos(c.theta);
end;

Procedure WindowXY(x,y:Double; var WindowX,WindowY: Integer; var c:conf_skychart);
BEGIN
    WindowX:=round(c.AxGlb+c.BxGlb*x)+c.Xshift;
    WindowY:=round(c.AyGlb+c.ByGlb*y)+c.Yshift;
END ;

Procedure XYWindow( x,y: Integer; var Xwindow,Ywindow: double; var c:conf_skychart);
Begin
   xwindow:= (x-c.xshift-c.Axglb)/c.BxGlb ;
   ywindow:= (y-c.yshift-c.AyGlb)/c.ByGlb;
end ;

PROCEDURE Proj2(ar,de,ac,dc : Double ; VAR X,Y : Double; var c:conf_skychart );
Var r,hh,s1,s2,s3,c1,c2,c3,xx,yy : Extended ;
BEGIN
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
      xx:=9999;
      yy:=9999;
    end else begin
      xx:= -(c2*s3);
      yy:= s2*c1-c2*s1*c3;
    end;
    if xx>10000 then xx:=10000
     else if xx<-10000 then xx:=-10000;
    if yy>10000 then yy:=10000
     else if yy<-10000 then yy:=-10000;
    end;
'T' : begin                  //  TAN
    hh := ar-ac ;
    sincos(dc,s1,c1);
    sincos(de,s2,c2);
    sincos(hh,s3,c3);
    r:=s1*s2+c2*c1*c3;     // cos the
    if r<=0 then begin  // > 90°
      xx:=9999;
      yy:=9999;
    end else begin
      xx := -( c2*s3/r );
      yy := (s2*c1-c2*s1*c3)/r ;
    end;
    if xx>10000 then xx:=10000
     else if xx<-10000 then xx:=-10000;
    if yy>10000 then yy:=10000
     else if yy<-10000 then yy:=-10000;
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
X:=xx*c.costheta+yy*c.sintheta;
Y:=yy*c.costheta-xx*c.sintheta;
END ;

PROCEDURE Projection(ar,de : Double ; VAR X,Y : Double; clip:boolean; var c:conf_skychart);
Var a,h,ac,dc,d1,d2 : Double ;
    a1,a2,i1,i2 : integer;
BEGIN
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
  else raise exception.Create('Bad projection type');
end;
if clip and (c.projpole=AltAz) and c.horizonopaque and (h<=c.HorizonMax) then begin
  if h<0 then begin
       X:=10000;
       Y:=10000;
  end else begin
    a:=rmod(-rad2deg*ar+181+360,360);
    a1:=trunc(a);
    if a1=0 then i1:=360 else i1:=a1;
    a2:=a1+1;
    if a2=361 then i2:=1 else i2:=a2;
    d1:=c.horizonlist[i1];
    d2:=c.horizonlist[i2];
    h:=d1+(a-a1)*(d2-d1)/(a2-a1);
    if de<h then begin
       X:=10000;
       Y:=10000;
    end else Proj2(ar,de,ac,dc,X,Y,c);
  end;
end else Proj2(ar,de,ac,dc,X,Y,c);
END ;

Procedure InvProj2 (xx,yy,ac,dc : Double ; VAR ar,de : Double; var c:conf_skychart);
Var a,r,hh,s1,c1,s2,c2,s3,c3,x,y : Extended ;
Begin
x:=(xx*c.costheta-yy*c.sintheta) ;     // AIPS memo 27
y:=(-yy*c.costheta-xx*c.sintheta);
case c.projtype of
'A' : begin
    r :=(pid2-sqrt(x*x+y*y)) ;
    a := arctan2(x,y) ;
    sincos(a,s1,c1);
    sincos(dc,s2,c2);
    sincos(r,s3,c3);
    de:=(arcsin( s2*s3 - c2*c3*c1)) + 1E-7 ;
    hh:=(arctan2((c3*s1),(c2*s3+s2*c3*c1) ));
    ar := ac - hh - 1E-7 ;
   end;
'C' : begin
    ar:=ac-x;
    de:=dc-y;
    if de>0 then de:=minvalue([de,pid2-0.00002]) else de:=maxvalue([de,-pid2-0.00002]);
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
    de:=(arcsin( sin(dc)*sin(r) - cos(dc)*cos(r)*cos(a) )) + 1E-7 ;
    hh:=(arctan2((cos(r)*sin(a)),(cos(dc)*sin(r)+sin(dc)*cos(r)*cos(a)) ));
    ar := ac - hh - 1E-7 ;
    end;
end;
end ;

Procedure InvProj (xx,yy : Double ; VAR ar,de : Double; var c:conf_skychart);
Var a,hh,ac,dc : Double ;
Begin
case c.Projpole of
Altaz: begin
       ac:=-c.acentre;
       dc:=c.hcentre;
       end;
Equat: begin
       ac:=c.racentre;
       dc:=c.decentre;
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
end;
end ;

procedure GetADxy(x,y:Integer ; var a,d : Double; var c:conf_skychart);
var
   x1,y1: Double;
begin
  XYwindow(x,y,x1,y1,c);
  InvProj (x1,y1,a,d,c);
end;

procedure GetAHxy(x,y:Integer ; var a,h : Double; var c:conf_skychart);
var
   x1,y1: Double;
begin
  XYwindow(x,y,x1,y1,c);
  InvProj2 (x1,y1,-c.acentre,c.hcentre,a,h,c);
  a:=rmod(pi4-a,pi2);
end;

procedure GetAHxyF(x,y:Integer ; var a,h : Double; var c:conf_skychart);
var
   x1,y1: Double;
begin
  XYwindow(x,y,x1,y1,c);
  InvProj2 (x1,y1,-c.acentre,c.hcentre,a,h,c);
  a:=-a;
end;

function NorthPoleInMap(var c:conf_skychart) : Boolean;
var a,d,x1,y1: Double; xx,yy : integer;
begin
a:=0 ; d:=pid2;
projection(a,d,x1,y1,false,c) ;
windowxy(x1,y1,xx,yy,c);
Result:=(xx>=c.xmin) and (xx<=c.xmax) and (yy>=c.ymin) and (yy<=c.ymax);
end;

function SouthPoleInMap(var c:conf_skychart) : Boolean;
var a,d,x1,y1: Double; xx,yy : integer;
begin
a:=0 ; d:=-pid2;
projection(a,d,x1,y1,false,c) ;
windowxy(x1,y1,xx,yy,c);
Result:=(xx>=c.xmin) and (xx<=c.xmax) and (yy>=c.ymin) and (yy<=c.ymax);
end;

function NorthPole2000InMap(var c:conf_skychart) : Boolean;
var a,d,x1,y1: Double; xx,yy : integer;
begin
a:=c.rap2000 ; d:=c.dep2000;
projection(a,d,x1,y1,false,c) ;
windowxy(x1,y1,xx,yy,c);
Result:=(xx>=c.xmin) and (xx<=c.xmax) and (yy>=c.ymin) and (yy<=c.ymax);
end;

function SouthPole2000InMap(var c:conf_skychart) : Boolean;
var a,d,x1,y1: Double; xx,yy : integer;
begin
a:=0;
d:=-pid2;
precession(jd2000,c.JDChart,a,d);
projection(a,d,x1,y1,false,c) ;
windowxy(x1,y1,xx,yy,c);
Result:=(xx>=c.xmin) and (xx<=c.xmax) and (yy>=c.ymin) and (yy<=c.ymax);
end;

function ZenithInMap(var c:conf_skychart) : Boolean;
var x1,y1: Double; xx,yy : integer;
begin
proj2(1.0,pid2,c.acentre,c.hcentre,x1,y1,c) ;
windowxy(x1,y1,xx,yy,c);
Result:=(xx>=c.xmin) and (xx<=c.xmax) and (yy>=c.ymin) and (yy<=c.ymax);
end;

function NadirInMap(var c:conf_skychart) : Boolean;
var x1,y1: Double; xx,yy : integer;
begin
proj2(1.0,-pid2,c.acentre,c.hcentre,x1,y1,c) ;
windowxy(x1,y1,xx,yy,c);
Result:=(xx>=c.xmin) and (xx<=c.xmax) and (yy>=c.ymin) and (yy<=c.ymax);
end;

Function AngularDistance(ar1,de1,ar2,de2 : Double) : Double;
var s1,s2,c1,c2: extended;
begin
try
if (ar1=ar2) and (de1=de2) then result:=0.0
else begin
    sincos(de1,s1,c1);
    sincos(de2,s2,c2);
    result:=arccos((s1*s2)+(c1*c2*cos((ar1-ar2))));
end;    
except
  result:=0;
end;
end;

function PositionAngle(ac,dc,ar,de:double):double;
var hh,s1,s2,s3,c1,c2,c3 : extended;
begin
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
 result :=  Rmod(te/15 - long/15 + 1.002737908*ut,24) ;
END ;

procedure Paralaxe(SideralTime,dist,ar1,de1 : double; var ar,de,q : double; var c:conf_skychart);
var
   sinpi,dar,H,rde,a,b,d : double;
const
     desinpi = 4.26345151e-5;
begin
// AR, DE are standard epoch but paralaxe is to be computed with coordinates of the date.
precession(c.JDchart,c.curjd,ar1,de1);
H:=(SideralTime-ar1);
rde:=de1;
sinpi:=desinpi/dist;
dar:=arctan2(-c.ObsRoCosPhi*sinpi*sin(H),(cos(rde)-c.ObsRoCosPhi*sinpi*cos(H)));
ar :=ar1+dar;
de :=arctan2((sin(rde)-c.ObsRoSinPhi*sinpi)*cos(dar),cos(rde)-c.ObsRoCosPhi*sinpi*cos(H));
a := cos(rde)*sin(H);
b := cos(rde)*cos(H)-c.ObsRoSinPhi*sinpi;
d := sin(rde)-c.ObsRoSinPhi*sinpi;
q := sqrt(a*a+b*b+d*d);
precession(c.curjd,c.JDchart,ar,de);
end;

function SetCurrentTime(var cfgsc:conf_skychart):boolean;
var y,m,d:word;
begin
decodedate(now,y,m,d);
cfgsc.CurYear:=y;
cfgsc.CurMonth:=m;
cfgsc.CurDay:=d;
cfgsc.CurTime:=frac(now)*24;
result:=true;
end;


function DTminusUT(annee : integer; var c:conf_skychart) : double;
var t : double;
begin
if c.Force_DT_UT then result:=c.DT_UT_val
else begin
case annee of
{ Atlas of Historical Eclipse Maps East Asia 1500 BC - AD 1900, Stephenson and Houlden (1986)
     (1) prior to 948 AD
         delta-T (seconds) = 1830 - 405*t + 46.5*t^2
             (t = centuries since 948 AD)

     (2) 948 AD to 1600 AD
         delta-T (seconds) = 22.5*t^2
             (t = centuries since 1850 AD)
}
-99999..948 : begin
              t:=(annee-2000)/100;
              result:=(2715.6 + 573.36 * t + 46.5 * t*t) / 3600;
              end;
  949..1619 : begin
              t:=(annee-1850)/100;
              result:=(22.5*t*t)/3600;
              end;
  1620..1621 : result:=124/3600;
  1622..1623 : result:=115/3600;
  1624..1625 : result:=106/3600;
  1626..1627 : result:= 98/3600;
  1628..1629 : result:= 91/3600;
  1630..1631 : result:= 85/3600;
  1632..1633 : result:= 79/3600;
  1634..1635 : result:= 74/3600;
  1636..1637 : result:= 70/3600;
  1638..1639 : result:= 65/3600;
  1640..1645 : result:= 60/3600;
  1646..1653 : result:= 50/3600;
  1654..1661 : result:= 40/3600;
  1662..1671 : result:= 30/3600;
  1672..1681 : result:= 20/3600;
  1682..1691 : result:= 10/3600;
  1692..1707 : result:=  9/3600;
  1708..1717 : result:= 10/3600;
  1718..1733 : result:= 11/3600;
  1734..1743 : result:= 12/3600;
  1744..1751 : result:= 13/3600;
  1752..1757 : result:= 14/3600;
  1758..1765 : result:= 15/3600;
  1766..1775 : result:= 16/3600;
  1776..1791 : result:= 17/3600;
  1792..1795 : result:= 16/3600;
  1796..1797 : result:= 15/3600;
  1798..1799 : result:= 14/3600;
 1800..1899 : begin
              t:=(annee-1900)/100;
              result:=(-1.4e-5+t*(1.148e-3+t*(3.357e-3+t*(-1.2462e-2+t*(-2.2542e-2+t*(6.2971e-2+t*(7.9441e-2+t*(-0.146960+t*(-0.149279+t*(0.161416+t*(0.145932+t*(-6.7471e-2+t*(-5.8091e-2))))))))))))  )*24;
              end;
 1900..1987 : begin
              t:=(annee-1900)/100;
              result:=(-2e-5+t*(2.97e-4+t*(2.5184e-2+t*(-0.181133+t*(0.553040+t*(-0.861938+t*(0.677066+t*(-0.212591))))))))*24;
              end;
 1988..1996 : begin
              t:=(annee-2000)/100;
              result:=(67+123.5*t+32.5*t*t)/3600;
              end;
       1997 : result:=62/3600;
       1998 : result:=63/3600;
       1999 : result:=63/3600;
       2000 : result:=64/3600;
       2001 : result:=64/3600;
 2002..2020 : begin
              t:=(annee-2000)/100;
              result:=(63+123.5*t+32.5*t*t)/3600;
              end;
 2021..99999 : begin
              t:=(annee-1875.1)/100;
              result:=45.39*t*t/3600;
              end;
 else result:=0;
 end;
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
      DEI:=ArcSIN(SIN(I5)*COS(DEI)*COS(ARI+I3)+COS(I5)*SIN(DEI)) ;
      ARI:=ARCTAN2(I6,I7) ;
      ARI:=ARI+I4   ;
      ARI:=RMOD(ARI+pi2,pi2);
   END  ;

PROCEDURE Precession(ti,tf : double; VAR ari,dei : double);  // ICRS
var i1,i2,i3,i4,i5,i6,i7 : double ;
   BEGIN
   if ti=tf then exit;
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
      DEI:=ArcSIN(i1);
      ARI:=ARCTAN2(I6,I7) ;
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
b:=arcsin(i8);
l:=rmod(l+pi2,pi2);
end;

PROCEDURE HorizontalGeometric(HH,DE : double ; VAR A,h : double; var c:conf_skychart);
var l1,d1,h1 : double;
BEGIN
l1:=deg2rad*c.ObsLatitude;
d1:=DE;
h1:=HH;
h:= arcsin( sin(l1)*sin(d1)+cos(l1)*cos(d1)*cos(h1) );
A:= arctan2(sin(h1),cos(h1)*sin(l1)-tan(d1)*cos(l1));
A:=Rmod(A+pi2,pi2);
END ;

PROCEDURE Eq2Hz(HH,DE : double ; VAR A,h : double; var c:conf_skychart);
var l1,d1,h1 : double;
BEGIN
l1:=deg2rad*c.ObsLatitude;
d1:=DE;
h1:=HH;
h:= arcsin( sin(l1)*sin(d1)+cos(l1)*cos(d1)*cos(h1) );
A:= arctan2(sin(h1),cos(h1)*sin(l1)-tan(d1)*cos(l1));
A:=Rmod(A+pi2,pi2);
{ refraction meeus91 15.4 }
if h>-deg2rad then h:=minvalue([pid2,h+deg2rad*c.ObsRefractionCor*(1.02/tan((h+deg2rad*10.3/(h+deg2rad*5.11))))/60])
        else h:=h+deg2rad*0.64658062088;
END ;

Procedure Hz2Eq(A,h : double; var hh,de : double; var c:conf_skychart);
var l1,a1,h1 : double;
BEGIN
l1:=deg2rad*c.ObsLatitude;
a1:=A;
{ refraction meeus91 15.3 }
if h>-deg2rad*0.3534193791 then h:=minvalue([pid2,h-deg2rad*c.ObsRefractionCor*(1/tan((h+(deg2rad*7.31/(h+deg2rad*4.4)))))/60])
                else h:=h-deg2rad*0.64658062088;
h1:=h;
de:= arcsin( sin(l1)*sin(h1)-cos(l1)*cos(h1)*cos(a1) );
hh:= arctan2(sin(a1),cos(a1)*sin(l1)+tan(h1)*cos(l1));
hh:=Rmod(hh+pi2,pi2);
END ;

Procedure Ecl2Eq(l,b,e: double; var ar,de : double);
begin
ar:=arctan2(sin(l)*cos(e)-tan(b)*sin(e),cos(l));
de:=arcsin(sin(b)*cos(e)+cos(b)*sin(e)*sin(l));
end;

Procedure Eq2Ecl(ar,de,e: double; var l,b: double);
begin
l:=arctan2(sin(ar)*cos(e)+tan(de)*sin(e),cos(ar));
b:=arcsin(sin(de)*cos(e)-cos(de)*sin(e)*sin(ar));
end;

Procedure Gal2Eq(l,b: double; var ar,de : double; var c:conf_skychart);
var dp : double;
begin
l:=l-deg2rad*123;
dp:=deg2rad*27.4;
ar:=deg2rad*12.25+arctan2(sin(l),cos(l)*sin(dp)-tan(b)*cos(dp));
de:=arcsin(sin(b)*sin(dp)+cos(b)*cos(dp)*cos(l));
precession(jd1950,c.JDchart,ar,de);
end;
{
procedure RiseSet(typobj:integer; jd0,ar,de:double; var hr,ht,hs,azr,azs:double;var irc:integer);
const ho : array[1..3] of Double = (-9.89E-3,-1.454E-2,2.18E-3) ;
var hs0,chh0,hh0,m0,m1,m2,a0 : double;
begin
precession(2451545.0,jd0,ar,de); // J2000 coord. to date
hs0 := sidtim(jd0,0.0,0.0)*15 ;
chh0 :=(ho[typobj]-sin(degtorad(ObsLatitude))*sin(degtorad(de)))/(cos(degtorad(ObsLatitude))*cos(degtorad(de))) ;
if abs(chh0)<=1 then begin
   hh0:=radtodeg(arccos(chh0));
   m0:=(ar*15+ObsLongitude-hs0)/360;
   m1:=m0-hh0/360;
   m2:=m0+hh0/360;
   ht:=rmod(rmod(m0+1,1)*24+TimeBias+24,24);
   hr:=rmod(rmod(m1+1,1)*24+TimeBias+24,24);
   hs:=rmod(rmod(m2+1,1)*24+TimeBias+24,24);
   a0:= radtodeg(arctan2(sin(degtorad(hh0)),cos(degtorad(hh0))*sin(degtorad(Obslatitude))-tan(degtorad(de))*cos(degtorad(Obslatitude))));
   azr:=360-a0;
   azs:=a0;
   irc:=0;
end else begin
   hr:=0;hs:=0;azr:=0;azs:=0;
   if sgn(de)=sgn(ObsLatitude) then begin
      m0:=(ar*15+ObsLongitude-hs0)/360;     (* circumpolaire *)
      ht:=rmod(rmod(m0+1,1)*24+TimeBias+24,24);
      irc:=1 ;
    end else begin
      ht:=0;      (* invisible *)
      irc:=2;
    end;
end;
end;

Function int3(n,y1,y2,y3 : double): double;
var a,b,c : double;
begin
a:= y2 - y1;
b:= y3 - y2;
c:= b - a;
result:= y2 + n/2*(a + b + n*c);
end;

procedure RiseSetInt(typobj:integer; jd0,ar1,de1,ar2,de2,ar3,de3:double; var hr,ht,hs,azr,azs:double;var irc:integer);
const ho : array[1..3] of Double = (-0.5667,-0.8333,0.125) ;
var hs0,chh0,hh0,m0,m1,m2,a0,n,hsg,aa,dd,hl,h,dm,longref : double;
begin
precession(2451545.0,jd0,ar1,de1); // J2000 coord. to date
precession(2451545.0,jd0,ar2,de2);
precession(2451545.0,jd0,ar3,de3);
if ar1>12 then begin
   if ar2<12 then ar2:=ar2+24;
   if ar3<12 then ar3:=ar3+24;
end;
longref:=-timebias*15;
//hs0 := sidtim(jd0,0.0,0.0)*15 ;
hs0 := sidtim(jd0,-timebias,longref)*15 ;
chh0 :=(sin(degtorad(ho[typobj]))-sin(degtorad(ObsLatitude))*sin(degtorad(de2)))/(cos(degtorad(ObsLatitude))*cos(degtorad(de2))) ;
if abs(chh0)<=1 then begin
   hh0:=radtodeg(arccos(chh0));
//   m0:=(ar2*15+ObsLongitude-hs0)/360;
   m0:=(ar2*15+Obslongitude-longref-hs0)/360;
   m1:=m0-hh0/360;
   m2:=m0+hh0/360;
  if m0<0 then m0:=m0+1;
  if m0>1 then m0:=m0-1;
  if m1<0 then m1:=m1+1;
  if m1>1 then m1:=m1-1;
  if m2<0 then m2:=m2+1;
  if m2>1 then m2:=m2-1;
   // lever
   hsg:= hs0 + 360.985647 * m1;
   n:= m1 ;
   aa:=int3(n,ar1,ar2,ar3)*15;
   dd:=int3(n,de1,de2,de3);
//   hl:= hsg - ObsLongitude - aa;
   hl:= hsg - Obslongitude + longref - aa;
   h:= radtodeg(arcsin(sin(degtorad(Obslatitude)) * sin(degtorad(dd)) + cos(degtorad(Obslatitude)) * cos(degtorad(dd)) * cos(degtorad(hl)) ));
   dm:= (h - ho[typobj]) / (360 * cos(degtorad(dd)) * cos(degtorad(Obslatitude)) * sin(degtorad(hl)) );
//   hr:=rmod((m1+dm)*24+TimeBias+24,24);
//   hr:=(m1+dm)*24+timebias;
   hr:=(m1+dm)*24;
   a0:= radtodeg(arctan2(sin(degtorad(hh0)),cos(degtorad(hh0))*sin(degtorad(Obslatitude))-tan(degtorad(dd))*cos(degtorad(Obslatitude))));
   azr:=360-a0;
   // culmination
   hsg:= hs0 + 360.985647 * m0;
   n:= m0 ;
   aa:=int3(n,ar1,ar2,ar3)*15;
//   hl:= hsg - ObsLongitude - aa;
   hl:= hsg - Obslongitude + longref - aa;
   dm:= -(hl / 360);
//   ht:=rmod((m0+dm)*24+TimeBias+24,24);
//   ht:=(m0+dm)*24+timebias;
   ht:=rmod((m0+dm)*24+24,24);
   if (ht<10)and(m0>0.6) then ht:=ht+24;
   if (ht>14)and(m0<0.4) then ht:=ht-24;
   // coucher
   hsg:= hs0 + 360.985647 * m2;
   n:= m2 ;
   aa:=int3(n,ar1,ar2,ar3)*15;
   dd:=int3(n,de1,de2,de3);
//   hl:= hsg - ObsLongitude - aa;
   hl:= hsg - Obslongitude + longref - aa;
   h:= radtodeg(arcsin(sin(degtorad(Obslatitude)) * sin(degtorad(dd)) + cos(degtorad(Obslatitude)) * cos(degtorad(dd)) * cos(degtorad(hl)) ));
   dm:= (h - ho[typobj]) / (360 * cos(degtorad(dd)) * cos(degtorad(Obslatitude)) * sin(degtorad(hl)) );
//   hs:=rmod((m2+dm)*24+TimeBias+24,24);
//   hs:=(m2+dm)*24+timebias;
   hs:=(m2+dm)*24;
   a0:= radtodeg(arctan2(sin(degtorad(hh0)),cos(degtorad(hh0))*sin(degtorad(Obslatitude))-tan(degtorad(dd))*cos(degtorad(Obslatitude))));
   azs:=a0;
   irc:=0;
end else begin
   hr:=0;hs:=0;azr:=0;azs:=0;
   if sgn(de1)=sgn(ObsLatitude) then begin
      m0:=(ar2*15+ObsLongitude-hs0)/360;     (* circumpolaire *)
      hsg:= hs0 + 360.985647 * m0;
      n:= m0 + dt_ut / 24;
      aa:=int3(n,ar1,ar2,ar3)*15;
      hl:= hsg - ObsLongitude - aa;
      dm:= -(hl / 360);
      ht:=rmod((m0+dm)*24+TimeBias+24,24);
      irc:=1 ;
    end else begin
      ht:=0;      (* invisible *)
      irc:=2;
    end;
end;
end;

Procedure HeurePo(jd,ar,de,h :Double; VAR hp1,hp2 :Double );
VAR hh,st,st0 : Double ;
BEGIN
hh := (sin(degtorad(h))-sin(degtorad(ObsLatitude))*sin(degtorad(de)))/(cos(degtorad(ObsLatitude))*cos(degtorad(de))) ;
if abs(hh)<=1 then begin
     hh := radtodeg(arccos(hh)) ;
     st0 := sidtim(jd,0.0,ObsLongitude) ;
     st := (ar-hh)/15 ;
     hp1 := rmod((st-st0)/1.002737908+24,24) ;
     st := (ar+hh)/15 ;
     hp2 := rmod((st-st0)/1.002737908+24,24) ;
end else begin
     hp1:=-99;
     hp2:=-99;
end;
END;
 }
Function YearADBC(year : integer) : string;
begin
if year>0 then begin
   result:=inttostr(year);
end else begin
   result:=inttostr(-year+1)+'BC' ;
end;
end;

end.

