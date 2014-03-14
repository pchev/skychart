Unit cu_taki;

{$MODE Delphi}

{****************************************************************
Two stars alignment method based on the article 
by Toshimi Taki in February 1989 S&T.

This Pascal implementation is Copyright (C) 2000 Patrick Chevalley

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
****************************************************************}

interface

Procedure Reset(az1,az2,az3 : double);
Procedure AddStar(b,d,t,f,h : double);
//        RA, DEC, Time, Az, Alt
//
Procedure Equ2Tel(b,d,t : double; var f,h : double);
//        RA, DEC, Time ->  Az, Alt
//
Procedure Tel2Equ(f,h,t : double; var b,d : double);
//        Az, Alt, Time ->  RA, DEC
//

Implementation
var
   q,v,r,x,y : array [0..3,0..3] of double;
   ist : integer=0;
   z1 : double =0;
   z2 : double =0;
   z3 : double =0;
const
   k=1.002738;
   g=57.2958;

Procedure Reset(az1,az2,az3 : double);
begin
ist:=0;
z1:=az1;
z2:=az2;
z3:=az3;
end;

Procedure sub_cy(f,h : double); // 750
begin
y[1,0]:=cos(f)*cos(h)-sin(f)*(z2/g)
       +sin(f)*sin(h)*(z1/g);
y[2,0]:=sin(f)*cos(h)+cos(f)*(z2/g)
       -cos(f)*sin(h)*(z1/g);
y[3,0]:=sin(h);
end;

Procedure sub_y(f,h : double); // 785
begin
y[1,1]:=cos(f)*cos(h)+sin(f)*(z2/g)
       -sin(f)*sin(h)*(z1/g);
y[2,1]:=sin(f)*cos(h)-cos(f)*(z2/g)
       +cos(f)*sin(h)*(z1/g);
y[3,1]:=sin(h);
end;

Procedure sub_det(var w : double); // 650
begin
w:=v[1,1]*v[2,2]*v[3,3]+v[1,2]*v[2,3]*v[3,1];
w:=w+v[1,3]*v[3,2]*v[2,1];
w:=w-v[1,3]*v[2,2]*v[3,1]-v[1,1]*v[3,2]*v[2,3];
w:=w-v[1,2]*v[2,1]*v[3,3];
end;

Procedure sub_angl(var f,h: double);  // 685
var c : double;
begin
c:=sqrt(y[1,1]*y[1,1]+y[2,1]*y[2,1]);
if (c=0)and(y[3,1]>0) then h:=90;
if (c=0)and(y[3,1]<0) then h:=-90;
if c<>0 then h:=arctan(y[3,1]/c)*g;
if c=0 then f:=1000;
if (c<>0)and(y[1,1]=0)and(y[2,1]>0) then f:=90;
if (c<>0)and(y[1,1]=0)and(y[2,1]<0) then f:=270;
if y[1,1]>0 then f:=arctan(y[2,1]/y[1,1])*g;
if y[1,1]<0 then f:=arctan(y[2,1]/y[1,1])*g+180;
f:=f-int(f/360)*360;
end;

Procedure AddStar(b,d,t,f,h : double); // 160
//        RA, DEC, Time, Az, Alt
var a,e,w : double;
    i,j,m,n,l : integer;
begin
inc(ist);
d:=d/g;
b:=(b-k*t*0.25)/g;
x[1,ist]:=cos(d)*cos(b);
x[2,ist]:=cos(d)*sin(b);
x[3,ist]:=sin(d);
f:=f/g;
h:=(h+z3)/g;
sub_cy(f,h);
y[1,ist]:=y[1,0];
y[2,ist]:=y[2,0];
y[3,ist]:=y[3,0];
if ist=2 then begin  // 250
  x[1,3]:=x[2,1]*x[3,2]-x[3,1]*x[2,2];
  x[2,3]:=x[3,1]*x[1,2]-x[1,1]*x[3,2];
  x[3,3]:=x[1,1]*x[2,2]-x[2,1]*x[1,2];
  a:=sqrt(x[1,3]*x[1,3]+x[2,3]*x[2,3]+x[3,3]*x[3,3]);
  for i:=1 to 3 do x[i,3]:=x[i,3]/a;
  y[1,3]:=y[2,1]*y[3,2]-y[3,1]*y[2,2];
  y[2,3]:=y[3,1]*y[1,2]-y[1,1]*y[3,2];
  y[3,3]:=y[1,1]*y[2,2]-y[2,1]*y[1,2];
  a:=sqrt(y[1,3]*y[1,3]+y[2,3]*y[2,3]+y[3,3]*y[3,3]);
  for i:=1 to 3 do y[i,3]:=y[i,3]/a;
  // 310
  for i:=1 to 3 do
    for j:=1 to 3 do
      v[i,j]:=x[i,j];
  sub_det(w);
  e:=w;
  // 340
  for m:=1 to 3 do begin
    for i:=1 to 3 do
      for j:=1 to 3 do
        v[i,j]:=x[i,j];
    for n:=1 to 3 do begin
      v[1,m]:=0;
      v[2,m]:=0;
      v[3,m]:=0;
      v[n,m]:=1;
      sub_det(w);
      q[m,n]:=w/e;
    end;
  end;
  // 385
  for i:=1 to 3 do
    for j:=1 to 3 do
      r[i,j]:=0;
  for i:=1 to 3 do
    for j:=1 to 3 do
      for l:=1 to 3 do
        r[i,j]:=r[i,j]+y[i,l]*q[l,j];
  for m:=1 to 3 do begin
    for i:=1 to 3 do
      for j:=1 to 3 do
        v[i,j]:=r[i,j];
    sub_det(w);
    e:=w;
    for n:=1 to 3 do begin
      v[1,m]:=0;
      v[2,m]:=0;
      v[3,m]:=0;
      v[n,m]:=1;
      sub_det(w);
      q[m,n]:=w/e;
    end;
  end;
  //  460
end;
end;

Procedure Equ2Tel(b,d,t : double; var f,h : double);
var i,j : integer;
begin
d:=d/g;
b:=(b-k*t*0.25)/g;
x[1,1]:=cos(d)*cos(b);
x[2,1]:=cos(d)*sin(b);
x[3,1]:=sin(d);
y[1,1]:=0;
y[2,1]:=0;
y[3,1]:=0;
for i:=1 to 3 do
  for j:=1 to 3 do
    y[i,1]:=y[i,1]+r[i,j]*x[j,1];
sub_angl(f,h);
f:=f/g;
h:=h/g;
sub_y(f,h);
sub_angl(f,h);
h:=h-z3;
end;

Procedure Tel2Equ(f,h,t : double; var b,d : double);
//        Az, Alt, Time ->  RA, DEC
var i,j : integer;
begin
f:=f/g;
h:=(h+z3)/g;
sub_cy(f,h);
x[1,1]:=y[1,0];
x[2,1]:=y[2,0];
x[3,1]:=y[3,0];
y[1,1]:=0;
y[2,1]:=0;
y[3,1]:=0;
for i:=1 to 3 do
  for j:=1 to 3 do
    y[i,1]:=y[i,1]+q[i,j]*x[j,1];
sub_angl(f,h);
f:=f+k*t*0.25;
f:=f-int(f/360)*360;
b:=f;
d:=h;
end;
end.


