program convgcvs;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  SysUtils, Classes, Math;

Type
 GCVtxt = record     l : byte;
                     num : array[1..6] of char;
                     s1  : char;
                     s1a  : char;
                     gcvs: array[1..10]of char;
                     s2  : char;
                     s2a  : char;
                     arh : array[1..2] of char;
                     arm : array[1..2] of char;
                     ars : array[1..4] of char;
                     sde : char;
                     ded : array[1..2] of char;
                     dem : array[1..2] of char;
                     des : array[1..2] of char;
                     s3  : char;
                     s3a  : char;
                     vartype : array[1..10] of char;
                     s3b  : char;
                     lmax : char;
                     max : array[1..6] of char;
                     s4 : char;
                     s5 : char;
                     s5a : char;
                     lmin : char;
                     min : array[1..6] of char;
                     s7  : char;
                     s8  : char;
                     s8a  : char;
                     fmin:char;
                     s8b  : char;
                     mcode : char;
                     s8c  : char;
                     s9  : array[1..16] of char;
                     ynova : array[1..4] of char;
                     s10  : char;
                     s10a  : char;
                     s10b  : char;
                     period : array[1..16] of char;
                     s11  : array [1..1024] of char;
                     end;
 NSVtxt = record     l : byte;
                     num : array[1..5] of char;
                     s1  : array[1..3] of char;
                     s1a  : char;
                     arh5 : array[1..2] of char;
                     arm5 : array[1..2] of char;
                     ars5 : array[1..4] of char;
                     sde5 : char;
                     ded5 : array[1..2] of char;
                     dem5 : array[1..2] of char;
                     des5 : array[1..2] of char;
                     s2  : char;
                     s2a  : char;
                     arh : array[1..2] of char;
                     arm : array[1..2] of char;
                     ars : array[1..4] of char;
                     sde : char;
                     ded : array[1..2] of char;
                     dem : array[1..2] of char;
                     des : array[1..2] of char;
                     s2b  : char;
                     s2c  : char;
                     vartype : array[1..6] of char;
                     s3  : char;
                     lmax : char;
                     max : array[1..5] of char;
                     s3b : char;
                     s3c  : char;
                     fmin : char;
                     lmin : char;
                     min : array[1..6] of char;
                     s5 : array [1..4]of char;
                     mcode : char;
                     s9  : array[1..14] of char;
                     desig : array[1..15] of char;
                     s11  : array [1..1024] of char;
                     end;
 EVStxt = record     l : byte;
                     num : array[1..7] of char;
                     s1  : char;
                     gcvs : array[1..12] of char;
                     s11  : char;
                     arh5 : array[1..2] of char;
                     arm5 : array[1..2] of char;
                     ars5 : array[1..5] of char;
                     sde5 : char;
                     ded5 : array[1..2] of char;
                     dem5 : array[1..2] of char;
                     des5 : array[1..4] of char;
                     s2  : char;
                     vartype : array[1..8] of char;
                     max : array[1..5] of char;
                     lmax : char;
                     lmin : char;
                     min : array[1..6] of char;
                     s5 :  char;
                     fmin : char;
                     mcode : char;
                     s9  : array[1..91] of char;
                     ynova : array[1..4] of char;
                     s10  : char;
                     cr  :  char;
                     end;

GCVrec = record ar,de,num :longint ;
                period : single;
                max,min : smallint;
                lmax,lmin,mcode : char;
                gcvs,vartype : array[1..10] of char;
                end;

filixr = packed record n: smallint;
                r: integer;
                key: array[1..12] of char; 
         end;

const
    lg_reg_x : array [0..5,1..2] of integer = (
(   4, 47),(  9, 38),( 12, 26),
(  12,  1),(  9, 13),(  4, 22));

var
   F: textfile;
   lin1 : gcvtxt;
   lin2 : nsvtxt;
   lin3 : evstxt;
   fb : file of gcvrec;
   fo   : file of filixr;
   out : gcvrec;
   inp : array[0..200000] of gcvrec;
   ixr : array[1..200000] of filixr;
   nl,nixr : integer;
   pathi,patho : string;
   lgnum : integer;

Procedure FindRegion(ar,de : double; var lg : integer);
var i1,i2,N,L1 : integer;
begin
i1 := Trunc((de+90)/30) ;
N  := lg_reg_x[i1,1];
L1 := lg_reg_x[i1,2];
i2 := Trunc(ar/(360/N));
Lg := L1+i2;
end;

Function PadZeros(x : string ; l :integer) : string;
const zero = '000000000000';
var p : integer;
begin
x:=trim(x);
p:=l-length(x);
result:=copy(zero,1,p)+x;
end;

function  Rmod(x,y:Double):Double;
BEGIN
    Rmod := x - Int(x/y) * y ;
END  ;

PROCEDURE Precession(ti,tf : double; VAR ari,dei : double);
CONST DR : double = 1.74532925199433e-2 ;
var i1,i2,i3,i4,i5,i6,i7 : double ;
   BEGIN
      I1:=(TI-2415020.313)/36524.2199 ;
      I2:=(TF-TI)/36524.2199 ;
      I3:=((1.8E-2*I2+3.02E-1)*I2+(2304.25+1.396*I1))*I2/3600.0 ;
      I4:=I2*I2*(7.91E-1+I2/1000.0)/3600.0+I3 ;
      I5:=((2004.682-8.35E-1*I1)-(4.2E-2*I2+4.26E-1)*I2)*I2/3600.0 ;
      I6:=COS(DEI*DR)*SIN((ARI+I3)*DR) ;
      I7:=COS(I5*DR)*COS(DEI*DR)*COS((ARI+I3)*DR)-SIN(I5*DR)*SIN(DEI*DR) ;
      DEI:=ArcSIN(SIN(I5*DR)*COS(DEI*DR)*COS((ARI+I3)*DR)+COS(I5*DR)*SIN(DEI*DR))/DR ;
      ARI:=ARCTAN2(I6,I7)/DR ;
      ARI:=ARI+I4   ;
      ARI:=RMOD(ARI+360.0,360.0)
   END  ;

function Jd(annee,mois,jour :INTEGER; Heure:double):double;
 VAR siecle,cor:INTEGER ;
     jd1:double;
 BEGIN
    IF mois<=2 THEN
    begin
      annee:=annee-1;
      mois:=mois+12;
    end ;
    (* IF (annee>1582) OR ((annee=1582) AND ((mois*100+jour)>=1015)) THEN *)
    IF annee > 1582 THEN
    begin
       siecle:=annee DIV 100;
       cor:=2 - siecle + siecle DIV 4;
       end
        ELSE
        cor:=0;
    IF annee<0 THEN
       jd1:=Int(365.25*annee-0.75)
     ELSE
       jd1:=Int(365.25*annee);
    jd := jd1 + Int(30.6001*(mois+1)) + jour
               + 1720994.5 + cor + Heure/24.0;
 END ;


procedure ReadData;
var i,ii,p :integer;
    ar,de,sde,jd1,jd2 : double;
    buf,buf1 : shortstring;
const blanc='                                                                  ';
begin
writeln('gcvs_cat.dat');
Assignfile(F,pathi+PathDelim+'gcvs_cat.dat');
Reset(F);
i:=0;
repeat
  Readln(F,buf);
  buf:=buf+blanc;
  move(buf,lin1,sizeof(lin1));
  if lin1.arh='  ' then continue;
  sde:=strtofloat(lin1.sde+'1');
  de := sde*strtofloat(lin1.ded)+sde*strtofloat(lin1.dem)/60 ;
  if trim(lin1.des)>'' then de:=de+sde*strtofloat(lin1.des)/3600;
  ar := strtofloat(lin1.arh)+strtofloat(lin1.arm)/60+strtofloat(lin1.ars)/3600;
  ar:=15*ar;
  inc(i);
  out.de:=round(de*100000);
  out.ar:=round(ar*100000);
  out.num:=strtoint(lin1.num);
  move(lin1.gcvs,out.gcvs,sizeof(out.gcvs));
  move(lin1.vartype,out.vartype,sizeof(out.vartype));
  if trim(lin1.ynova)>'' then begin
     p:=length(trim(lin1.vartype))+1;
     out.vartype[p+1]:=lin1.ynova[1];
     out.vartype[p+2]:=lin1.ynova[2];
     out.vartype[p+3]:=lin1.ynova[3];
     out.vartype[p+4]:=lin1.ynova[4];
  end;
  out.lmax:=lin1.lmax;
  out.lmin:=lin1.lmin;
  if trim(lin1.max)>'' then out.max:=round(strtofloat(trim(lin1.max))*100)
                      else out.max:=9900;
  if trim(lin1.min)>'' then out.min:=round(strtofloat(trim(lin1.min))*100)
                      else out.min:=9900;
  if lin1.fmin=')' then out.min:=out.min+out.max;
  out.mcode:=lin1.mcode;
  if trim(lin1.period)>'' then out.period:=strtofloat(lin1.period)
                         else out.period:=0;
  inp[i]:=out;
until eof(F);
Close(F);
writeln('tot stars '+inttostr(i));

writeln('nsv_cat.dat');
Assignfile(F,pathi+PathDelim+'nsv_cat.dat');
ii:=0;
Reset(F);
repeat
inc(ii);
  Readln(F,buf);
  buf:=buf+blanc;
  move(buf,lin2,sizeof(lin2));
if ii=8 then begin
writeln(lin2.num,lin2.arh,lin2.ded,lin2.vartype,lin2.max,lin2.min,lin2.mcode);
halt;
end;
  if lin2.arh='  ' then continue;
  sde:=strtofloat(lin2.sde+'1');
  de := sde*strtofloat(lin2.ded)+sde*strtofloat(lin2.dem)/60 ;
  if trim(lin2.des)>'' then de:=de+sde*strtofloat(lin2.des)/3600;
  ar := strtofloat(lin2.arh)+strtofloat(lin2.arm)/60+strtofloat(lin2.ars)/3600;
  ar:=15*ar;
  inc(i);
  out.de:=round(de*100000);
  out.ar:=round(ar*100000);
  out.num:=strtoint(lin2.num);
  buf1:='NSV '+lin2.num+blanc;
  move(buf1[1],out.gcvs,sizeof(out.gcvs));
  move(lin2.vartype,out.vartype,sizeof(lin2.vartype));
     p:=6;
     out.vartype[p]:=' ';
     out.vartype[p+1]:='N';
     out.vartype[p+2]:='S';
     out.vartype[p+3]:='V';
     out.vartype[p+4]:=' ';
  out.lmax:=lin2.lmax;
  out.lmin:=lin2.lmin;
  if trim(lin2.max)>'' then out.max:=round(strtofloat(trim(lin2.max))*100)
                      else out.max:=9900;
  if trim(lin2.min)>'' then out.min:=round(strtofloat(trim(lin2.min))*100)
                      else out.min:=9900;
  if lin2.fmin=')' then out.min:=out.min+out.max;
  out.mcode:=lin2.mcode;
  out.period:=0;
  inp[i]:=out;
until eof(F);
Close(F);
writeln('tot stars '+inttostr(i));

writeln('evs_cat.dat');
Assignfile(F,pathi+PathDelim+'evs_cat.dat');
Reset(F);
jd1:=jd(1950,1,1,0);
jd2:=jd(2000,1,1,0);
repeat
  Readln(F,buf);
  buf:=buf+blanc;
  move(buf,lin3,sizeof(lin3));
  if lin3.arh5='  ' then continue;
     sde:=strtofloat(lin3.sde5+'1');
     de := sde*strtofloat(lin3.ded5)+sde*strtofloat(lin3.dem5)/60 ;
     if trim(lin3.des5)>'' then de:=de+sde*strtofloat(lin3.des5)/3600;
     ar := strtofloat(lin3.arh5)+strtofloat(lin3.arm5)/60+strtofloat(lin3.ars5)/3600;
     ar:=15*ar;
     precession(jd1,jd2,ar,de);
  inc(i);
  out.de:=round(de*100000);
  out.ar:=round(ar*100000);
  out.num:=strtoint(lin3.num);
  buf:=trim(lin3.gcvs);
  p:=pos(' ',buf);
  if p>5 then begin
     buf1:=trim(copy(buf,p+1,99));
     buf:=copy(buf,1,p-1);
     if length(buf)>5 then buf:=copy(buf,2,5);
     buf:=buf+buf1+blanc;
  end
  else
    buf:=copy(buf,1,10)+blanc;
  move(buf[1],out.gcvs,sizeof(out.gcvs));
  buf:=lin3.vartype+blanc;
  move(buf[1],out.vartype,sizeof(out.vartype));
  if trim(lin3.ynova)>'' then begin
     p:=length(trim(lin3.vartype))+1;
     out.vartype[p+1]:=lin3.ynova[1];
     out.vartype[p+2]:=lin3.ynova[2];
     out.vartype[p+3]:=lin3.ynova[3];
     out.vartype[p+4]:=lin3.ynova[4];
  end;
  out.lmax:=lin3.lmax;
  out.lmin:=lin3.lmin;
  if trim(lin3.max)>'' then out.max:=round(strtofloat(trim(lin3.max))*100)
                      else out.max:=9900;
  if trim(lin3.min)>'' then out.min:=round(strtofloat(trim(lin3.min))*100)
                      else out.min:=9900;
  if lin3.fmin=')' then out.min:=out.min+out.max;
  out.mcode:=lin3.mcode;
  out.period:=0;
  inp[i]:=out;
until eof(F);
Close(F);
writeln('tot stars '+inttostr(i));
nl:=i;
end;

procedure WrtZone(lgnum:integer);
var i,n,zone :integer;
    ar,de : double;
    buf: shortstring;
const blanc='                                                                  ';
begin
assignfile(fb,patho+PathDelim+padzeros(inttostr(lgnum),2)+'.dat');
Rewrite(fb);
i:=0;
for n:=1 to nl do begin
  out:=inp[n];
  ar:=out.ar/100000;
  de:=out.de/100000;
  findregion(ar,de,zone);
  if zone=lgnum then begin
    inc(nixr);
    buf:=uppercase(stringreplace(out.gcvs,' ','',[rfReplaceAll]))+blanc;
    move(buf[1],ixr[nixr].key,sizeof(ixr[nixr].key));
    ixr[nixr].n:=lgnum;
    ixr[nixr].r:=i;
    write(fb,out);
    inc(i);
  end;
end;
close(fb);
end;

Procedure SortIndex(g,d:integer);
var step,i,j,k : integer;
    lin : filixr;
begin
step:=1;
while step < ((d-g+1) div 9) do step :=step*3+1;
repeat
  for k:=g to step do begin
    i:=k+step; if i<d then
    repeat
      lin:=ixr[i];
      j:=i-step;
      while (j>=k+step) and (ixr[j].key > lin.key) do begin
        ixr[j+step] := ixr[j];
        j:=j-step ;
      end;
      if ixr[k].key > lin.key then begin
        j:=k-step;
        ixr[k+step]:=ixr[k];
      end;
      ixr[j+step]:=lin;
      i:=i+step;
    until i>d;
  end;
  step:=step div 3;
until step=0;
end;

procedure WrtIndex ;
var i :integer;
  lin : filixr;
begin
assignfile(fo,patho+PathDelim+'gcvs.ixr');
Rewrite(fo);
for i:=1 to nixr do begin
  lin:=ixr[i];
  Write(Fo,lin);
end;
CloseFile(Fo);
end;

begin
pathi:='./';
patho:='./gcvs-nsv';
CreateDir(patho);
ReadData;
nixr:=0;
for lgnum:=1 to 50 do begin
  WrtZone(lgnum);
end;
SortIndex(1,nl);
WrtIndex;

end.

