unit SkyLib2;

{****************************************************************
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
****************************************************************}

interface
uses Math, Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs;

Function AngularDistance(ar1,de1,ar2,de2 : Double) : Double;
Function ARtoStr(ar: Double) : string;
Function DEmToStr(de: Double) : string;
Function DEdToStr(de: Double) : string;
Function ARmtoStr(ar: Double) : string;
Function DEpToStr(de: Double) : string;
Function ARptoStr(ar: Double) : string;
Function TimToStr(de: Double) : string;
Function DEToStr(de: Double) : string;
Function ARToStr2(ar: Double; var d,m,s : string) : string;
Function DEToStr2(de: Double; var d,m,s : string) : string;
Function DEToStr3(de: Double) : string;
Function DEToStr4(de: Double) : string;
function  Rmod(x,y:Double):Double;
Function sgn(x:Double):Double ;
function Jd(annee,mois,jour :INTEGER; Heure:double):double;
PROCEDURE Djd(jd:Double;VAR annee,mois,jour:INTEGER; VAR Heure:double);
function SidTim(jd0,ut,long : double): double;
PROCEDURE Eq2Hz(HH,DE : double ; VAR A,h : double );
Procedure Hz2Eq(A,h : double; var hh,de : double);

const
      jd2000 : double =2451545.0 ;
      jd1950 : double =2433282.4235;
      ldeg = '°';
      lmin = '''';
      lsec = '"';

var
  ObsLatitude,ObsLongitude,ObsAltitude,SaveObsLatitude,SaveObsLongitude : double;
  ObsRoSinPhi,ObsRoCosPhi,ObsTemperature,ObsPressure,ObsRefractionCor : Double;
  AppDir : string;

implementation



function  Rmod(x,y:Double):Double;
BEGIN
    Rmod := x - Int(x/y) * y ;
END  ;

Function sgn(x:Double):Double ;
begin
if x<0 then
   sgn:= -1
else
   sgn:=  1 ;
end ;

Function AngularDistance(ar1,de1,ar2,de2 : Double) : Double;
begin
try
if (ar1=ar2) and (de1=de2) then result:=0.0
else
    result:=RadToDeg(arccos((sin(DegToRad(de1))*sin(DegToRad(de2)))+(cos(DegToRad(de1))*cos(DegToRad(de2))*cos(DegToRad((ar1-ar2))))));
except
  result:=0;
end;
end;

Function DEToStr(de: Double) : string;
var dd,min1,min,sec: Double;
    d,m,s : string;
begin
    dd:=Int(de);
    min1:=abs(de-dd)*60;
    if min1>=59.99 then begin
       dd:=dd+sgn(de);
       min1:=0.0;
    end;
    min:=Int(min1);
    sec:=(min1-min)*60;
    if sec>=59.5 then begin
       min:=min+1;
       sec:=0.0;
    end;
    str(abs(dd):2:0,d);
    if abs(dd)<10 then d:='0'+trim(d);
    if de<0 then d:='-'+d else d:='+'+d;
    str(min:2:0,m);
    if abs(min)<10 then m:='0'+trim(m);
    str(sec:2:0,s);
    if abs(sec)<9.5 then s:='0'+trim(s);
    result := d+ldeg+m+lmin+s+lsec;
end;

Function DEToStr3(de: Double) : string;
var dd,min1,min,sec: Double;
    d,m,s : string;
begin
    dd:=Int(de);
    min1:=abs(de-dd)*60;
    if min1>=59.99 then begin
       dd:=dd+sgn(de);
       min1:=0.0;
    end;
    min:=Int(min1);
    sec:=(min1-min)*60;
    if sec>=59.5 then begin
       min:=min+1;
       sec:=0.0;
    end;
    str(abs(dd):2:0,d);
    if abs(dd)<10 then d:='0'+trim(d);
    if de<0 then d:='-'+d else d:='+'+d;
    str(min:2:0,m);
    if abs(min)<10 then m:='0'+trim(m);
    str(sec:2:0,s);
    if abs(sec)<9.5 then s:='0'+trim(s);
    result := d+'d'+m+'m'+s+'s';
end;

Function DEToStr4(de: Double) : string;
var dd,min1,min,sec: Double;
    d,m,s : string;
begin
    dd:=Int(de);
    min1:=abs(de-dd)*60;
    if min1>=59.99 then begin
       dd:=dd+sgn(de);
       min1:=0.0;
    end;
    min:=Int(min1);
    sec:=(min1-min)*60;
    if sec>=59.5 then begin
       min:=min+1;
       sec:=0.0;
    end;
    str(abs(dd):2:0,d);
    if abs(dd)<10 then d:='0'+trim(d);
    if de<0 then d:='-'+d else d:='+'+d;
    str(min:2:0,m);
    if abs(min)<10 then m:='0'+trim(m);
    str(sec:2:0,s);
    if abs(sec)<9.5 then s:='0'+trim(s);
    result := d+'°'+m+''''+s+'"';
end;

Function TimToStr(de: Double) : string;
var dd,min1,min,sec: Double;
    d,m,s : string;
begin
    dd:=Int(de);
    min1:=abs(de-dd)*60;
    if min1>=59.99 then begin
       dd:=dd+sgn(de);
       min1:=0.0;
    end;
    min:=Int(min1);
    sec:=(min1-min)*60;
    if sec>=59.5 then begin
       min:=min+1;
       sec:=0.0;
    end;
    str(abs(dd):2:0,d);
    if abs(dd)<10 then d:='0'+trim(d);
    str(min:2:0,m);
    if abs(min)<10 then m:='0'+trim(m);
    str(sec:2:0,s);
    if abs(sec)<9.5 then s:='0'+trim(s);
    result := d+':'+m+':'+s;
end;

Function ARToStr(ar: Double) : string;
var dd,min1,min,sec: Double;
    d,m,s : string;
begin
    dd:=Int(ar);
    min1:=abs(ar-dd)*60;
    if min1>=59.999 then begin
       dd:=dd+sgn(ar);
       min1:=0.0;
    end;
    min:=Int(min1);
    sec:=(min1-min)*60;
    if sec>=59.95 then begin
       min:=min+1;
       sec:=0.0;
    end;
    str(dd:3:0,d);
    str(min:2:0,m);
    if abs(min)<10 then m:='0'+trim(m);
    str(sec:4:1,s);
    if abs(sec)<9.95 then s:='0'+trim(s);
    result := d+'h'+m+'m'+s+'s';
end;

Function DEpToStr(de: Double) : string;
var dd,min1,min,sec: Double;
    d,m,s : string;
begin
    dd:=Int(de);
    min1:=abs(de-dd)*60;
    if min1>=59.99 then begin
       dd:=dd+sgn(de);
       min1:=0.0;
    end;
    min:=Int(min1);
    sec:=(min1-min)*60;
    if sec>=59.995 then begin
       min:=min+1;
       sec:=0.0;
    end;
    str(abs(dd):2:0,d);
    if abs(dd)<10 then d:='0'+trim(d);
    if de<0 then d:='-'+d else d:='+'+d;
    str(min:2:0,m);
    if abs(min)<10 then m:='0'+trim(m);
    str(sec:4:1,s);
    if abs(sec)<9.95 then s:='0'+trim(s);
    result := d+ldeg+m+lmin+s+lsec;
end;

Function ARpToStr(ar: Double) : string;
var dd,min1,min,sec: Double;
    d,m,s : string;
begin
    dd:=Int(ar);
    min1:=abs(ar-dd)*60;
    if min1>=59.999 then begin
       dd:=dd+sgn(ar);
       min1:=0.0;
    end;
    min:=Int(min1);
    sec:=(min1-min)*60;
    if sec>=59.995 then begin
       min:=min+1;
       sec:=0.0;
    end;
    str(dd:3:0,d);
    str(min:2:0,m);
    if abs(min)<10 then m:='0'+trim(m);
    str(sec:5:2,s);
    if abs(sec)<9.995 then s:='0'+trim(s);
   result := d+'h'+m+'m'+s+'s';
end;

Function DEmToStr(de: Double) : string;
var dd,min: Double;
    d,m : string;
begin
    dd:=Int(de);
    min:=abs(de-dd)*60;
    if min>=59.5 then begin
       dd:=dd+sgn(de);
       min:=0.0;
    end;
    min:=Round(min);
    str(abs(dd):2:0,d);
    if abs(dd)<10 then d:='0'+trim(d);
    if de<0 then d:='-'+d else d:='+'+d;
    str(min:2:0,m);
    if abs(min)<10 then m:='0'+trim(m);
    result := d+ldeg+m+lmin;
end;

Function DEdToStr(de: Double) : string;
var dd: Double;
    d : string;
begin
    dd:=round(de);
    str(abs(dd):2:0,d);
    if abs(dd)<10 then d:='0'+trim(d);
    if de<0 then d:='-'+d else d:='+'+d;
    result := d+ldeg;
end;

Function ARmToStr(ar: Double) : string;
var dd,min: Double;
    d,m: string;
begin
    dd:=Int(ar);
    min:=abs(ar-dd)*60;
    if min>=59.5 then begin
       dd:=dd+sgn(ar);
       min:=0.0;
    end;
    min:=Round(min);
    str(dd:3:0,d);
    str(min:2:0,m);
    if abs(min)<9.5 then m:='0'+trim(m);
    result := d+'h'+m+'m';
end;

Function DEToStr2(de: Double; var d,m,s : string) : string;
var dd,min1,min,sec: Double;
begin
    dd:=Int(de);
    min1:=abs(de-dd)*60;
    if min1>=59.99 then begin
       dd:=dd+sgn(de);
       min1:=0.0;
    end;
    min:=Int(min1);
    sec:=(min1-min)*60;
    if sec>=59.5 then begin
       min:=min+1;
       sec:=0.0;
    end;
    str(abs(dd):2:0,d);
    if abs(dd)<10 then d:='0'+trim(d);
    if de<0 then d:='-'+d else d:='+'+d;
    str(min:2:0,m);
    if abs(min)<10 then m:='0'+trim(m);
    str(sec:2:0,s);
    if abs(sec)<9.5 then s:='0'+trim(s);
    result := d+ldeg+m+lmin+s+lsec;
end;

Function ARToStr2(ar: Double; var d,m,s : string) : string;
var dd,min1,min,sec: Double;
begin
    dd:=Int(ar);
    min1:=abs(ar-dd)*60;
    if min1>=59.999 then begin
       dd:=dd+sgn(ar);
       min1:=0.0;
    end;
    min:=Int(min1);
    sec:=(min1-min)*60;
    if sec>=59.95 then begin
       min:=min+1;
       sec:=0.0;
    end;
    str(dd:2:0,d);
    if abs(dd)<10 then d:='0'+trim(d);
    str(min:2:0,m);
    if abs(min)<10 then m:='0'+trim(m);
    str(sec:2:0,s);
    if abs(sec)<9.95 then s:='0'+trim(s);
    result := d+'h'+m+'m'+s+'s';
end;

function Jd(annee,mois,jour :INTEGER; Heure:double):double;
 VAR siecle,cor:INTEGER ;
 begin
    if mois<=2 then begin
      annee:=annee-1;
      mois:=mois+12;
    end ;
    if annee*10000+mois*100+jour >= 15821015 then begin
       siecle:=annee div 100;
       cor:=2 - siecle + siecle div 4;
    end else cor:=0;
    jd:=int(365.25*(annee+4716))+int(30.6001*(mois+1))+jour+cor-1524.5 + heure/24;
 END ;

PROCEDURE Djd(jd:Double;VAR annee,mois,jour:INTEGER; VAR Heure:double);
 VAR z,f,a,al,b,c,d,e:double;
 BEGIN
    a:=jd+0.5;
    z := int(a);
    f := frac(a);
    if z<2299161.0 then a := z
       else begin
            al:= Int((z-1867216.25)/36524.25);
            a := z + 1.0 + al - Int(al/4.0);
    end;
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

 function SidTim(jd0,ut,long : double): double;
 VAR t,te: double;
 BEGIN
{    t:= (jd0-2415020.0)/36525.0;
    te:= 6.6460656 + 2400.051262*t + 2.581E-5*t*t ;}
    t:=(jd0-2451545.0)/36525;
    te:=100.46061837 + 36000.770053608*t + 0.000387933*t*t - t*t*t/38710000;
    result :=  Rmod(te/15 - long/15 + 1.002737908*ut,24) ;
//    result := rmod(result+24,24);
 END ;


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
if h>-1 then h:=minvalue([90,h+ObsRefractionCor*(1.02/tan(degtorad(h+10.3/(h+5.11))))/60])
        else h:=h+0.64658062088;
END ;

Procedure Hz2Eq(A,h : double; var hh,de : double);
var l1,a1,h1 : double;
BEGIN
l1:=degtorad(ObsLatitude);
a1:=degtorad(A);
{ refraction meeus91 15.3 }
if h>-0.3534193791 then h:=minvalue([90,h-ObsRefractionCor*(1/tan(degtorad(h+(7.31/(h+4.4)))))/60])
                else h:=h-0.64658062088;
h1:=degtorad(h);
de:= radtodeg(arcsin( sin(l1)*sin(h1)-cos(l1)*cos(h1)*cos(a1) ))  ;
hh:= radtodeg(arctan2(sin(a1),cos(a1)*sin(l1)+tan(h1)*cos(l1)));
hh:=Rmod(hh+360,360);
END ;

end.

