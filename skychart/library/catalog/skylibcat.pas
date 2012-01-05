unit skylibcat;
{
Copyright (C) 2000 Patrick Chevalley

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

interface
uses   gscconst,SysUtils,Math;

Procedure SetCatLang(msg1,msg2,msg3,capt : shortstring); stdcall;
Procedure InitCat(hnd : Cardinal ;Cache : boolean); stdcall;
Procedure InitCatWin(ax,ay,bx,by,st,ct,ac,dc,azc,hc,jdt,jdc,sidt,lat : double; pjp,xs,ys,xi,xa,yi,ya : integer; projt : char; np,sp : boolean); stdcall;
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
                            var hemislst : array of char );
procedure FindRegionAllWin(var Nsm : integer ;
                            var zonelst,SMlst : array of integer ;
                            var hemislst : array of char );
procedure FindRegionList(x1,x2,y1,y2:Double ;
                          var Nsm : integer ;
                          var zonelst,SMlst : array of integer ;
                          var hemislst : array of char );
procedure FindRegionAll(x1,x2,y1,y2:Double ;
                          var Nsm : integer ;
                          var zonelst,SMlst : array of integer ;
                          var hemislst : array of char );
procedure FindRegionListWin2(var Nsm : integer ;
                            var zonelst,SMlst : array of integer ;
                            var hemislst : array of char );
procedure FindRegionList2(x1,x2,y1,y2:Double ;
                          var Nsm : integer ;
                          var zonelst,SMlst : array of integer ;
                          var hemislst : array of char );
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

{$ifdef linux}
const slashchar='/';
{$endif}
{$ifdef mswindows}
const slashchar='\';
{$endif}

Const
    deg2rad = pi/180;
    rad2deg = 180/pi;
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
  Northpoleinmap,Southpoleinmap : boolean;
  appcaption : string;
  UseCache : Boolean = True;

implementation

function  Rmod(x,y:Double):Double;
BEGIN
    Rmod := x - Int(x/y) * y ;
END  ;

Procedure InitCat(hnd : Cardinal ;Cache : boolean); stdcall;
begin
UseCache:=Cache;
// HND is no more used, keep for compatibility with previous version
end;

Procedure InitCatWin(ax,ay,bx,by,st,ct,ac,dc,azc,hc,jdt,jdc,sidt,lat : double; pjp,xs,ys,xi,xa,yi,ya : integer; projt : char; np,sp : boolean); stdcall;
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
   case ProjPole of
   0..1: begin
      acentre:=azc;    // alt-az
      hcentre:=hc;
      end;
   2: begin
      lcentre:=azc;    // galactic
      bcentre:=hc;
      end;
   3: begin
      lecentre:=azc;   // ecliptic
      becentre:=hc;
      ecl:=ecliptic(JDChart);
      end;
   end;
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

PROCEDURE Precession(ti,tf : double; VAR ari,dei : double);  // ICRS
var i1,i2,i3,i4,i5,i6,i7 : double ;
//RA en degre!
   BEGIN
      if ti=tf then exit;
      I1:=(TI-2451545.0)/36525 ;
      I2:=(TF-TI)/36525;
      I3:=((2306.2181+1.39656*i1-1.39e-4*i1*i1)*i2+(0.30188-3.44e-4*i1)*i2*i2+1.7998e-2*i2*i2*i2)/3600 ;
      I4:=((2306.2181+1.39656*i1-1.39e-4*i1*i1)*i2+(1.09468+6.6e-5*i1)*i2*i2+1.8203e-2*i2*i2*i2)/3600 ;
      I5:=((2004.3109-0.85330*i1-2.17e-4*i1*i1)*i2-(0.42665+2.17e-4*i1)*i2*i2-4.1833e-2*i2*i2*i2)/3600 ;
      I6:=COS(degtorad(DEI))*SIN(degtorad(ARI+I3)) ;
      I7:=COS(degtorad(I5))*COS(degtorad(DEI))*COS(degtorad(ARI+I3))-SIN(degtorad(I5))*SIN(degtorad(DEI)) ;
      DEI:=radtodeg(ArcSIN(SIN(degtorad(I5))*COS(degtorad(DEI))*COS(degtorad(ARI+I3))+COS(degtorad(I5))*SIN(degtorad(DEI)))) ;
      ARI:=radtodeg(ARCTAN2(I6,I7)) ;
      ARI:=ARI+I4   ;
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
h:=minvalue([90,h+(1.02/tan(degtorad(h+10.3/(h+5.11))))/60]);
END ;

Procedure Hz2Eq(A,h : double; var hh,de : double);
var l1,a1,h1 : double;
BEGIN
l1:=degtorad(ObsLatitude);
a1:=degtorad(A);
{ refraction meeus91 15.3 }
h:=minvalue([90,h-(1/tan(degtorad(h+(7.31/(h+4.4)))))/60]);
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


Procedure InvProj (xx,yy : Double ; VAR ar,de : Double );
Var a,r,hh,s1,c1,x,y,ac,dc : Double ;
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
x:=(xx*costheta-yy*sintheta) ;     // AIPS memo 27
y:=(-yy*costheta-xx*sintheta);
case projtype of
'A' : begin
    r :=DegToRad(90-sqrt(x*x+y*y)) ;
    a := arctan2(x,y) ;
    dc:= DegToRad(dc) ;
    de:=RadToDeg(arcsin( sin(dc)*sin(r) - cos(dc)*cos(r)*cos(a) )) + 1E-7 ;
    hh:=RadToDeg(arctan2((cos(r)*sin(a)),(cos(dc)*sin(r)+sin(dc)*cos(r)*cos(a)) ));
    ar := ac - hh - 1E-7 ;
   end;
'C' : begin
    ar:=ac-x;
    de:=dc-y;
    if de>0 then de:=minvalue([de,89.999]) else de:=maxvalue([de,-89.999]);
    end;
'S' : begin
    dc:=degtorad(dc);
    s1:=sin(dc);
    c1:=cos(dc);
    x:=-degtorad(x);
    y:=-degtorad(y);
    r:=sqrt(1-x*x-y*y);
    ar:=ac+radtodeg(arctan2(x,(c1*r-y*s1)));
    de:=radtodeg(arcsin(y*c1+s1*r));
    end;
'T' : begin
    dc:=degtorad(dc);
    s1:=sin(dc);
    c1:=cos(dc);
    x:=-degtorad(x);
    y:=-degtorad(y);
    ar:=ac+radtodeg(arctan2(x,(c1-y*s1)));
    de:=radtodeg(arctan((cos(degtorad(ar-ac))*(y*c1+s1))/(c1-y*s1)));
    end;
else begin
    projtype:='A';
    r :=DegToRad(90-sqrt(x*x+y*y)) ;
    a := arctan2(x,y) ;
    dc:= DegToRad(dc) ;
    de:=RadToDeg(arcsin( sin(dc)*sin(r) - cos(dc)*cos(r)*cos(a) )) + 1E-7 ;
    hh:=RadToDeg(arctan2((cos(r)*sin(a)),(cos(dc)*sin(r)+sin(dc)*cos(r)*cos(a)) ));
    ar := ac - hh - 1E-7 ;
    end;
end;
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
    if abs(de) >= 89.9 then continue;
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

Procedure FindRegion(ar,de : double; var hemis : char ; var zone,S : integer);
var i1,i2,j1,j2,N,L1,L,S1,k : integer;
    arl,del,dar,dde : double;
begin
if de>0 then hemis:='n'
        else hemis:='s';
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
    arp:=ar; dep:=de;
    precession(JDChart,JDCatalog,arp,dep);
    if abs(dep) >= 90 then continue;
    Findregion(arp,dep,hemis,zone,Sm);
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
                          var hemislst : array of char );
var
   hemis : char;
   zone,Sm,k : integer;
   step,ar,de,ra,arp,dep : double;
   def : boolean;
begin
if x2<x1 then begin ra:=x2; x2:=x1; x1:=ra; end;
if y2<y1 then begin ra:=y2; y2:=y1; y1:=ra; end;
step:= 1;
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
    if abs(dep) >= 90 then continue;
    Findregion(arp,dep,hemis,zone,Sm);
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

procedure FindRegionListWin(var Nsm : integer ;
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
    Findregion(arp,dep,hemis,zone,Sm);
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
                            var hemislst : array of char );
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
    Findregion(arp,dep,hemis,zone,Sm);
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
dar:=minvalue([10,(x2-x1)/2]); // plus petit que 15 pour etre sur de tout avoir
dde:=minvalue([8,(y2-y1)/2]);  // ==
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
                          var hemislst : array of char );
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
    Findregion(arp,dep,hemis,zone,Sm);
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
                            var hemislst : array of char );
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
    Findregion(arp,dep,hemis,zone,Sm);
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

Procedure SetCatLang(msg1,msg2,msg3,capt : shortstring); stdcall;
begin
// no more used, added for compatibility with previous version
end;

Initialization
  JDChart:=jd2000;
  JDcatalog:=jd2000;
end.

