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
 

GCVrec = record ar,de,num :longint ;
                period : single;
                max,min : smallint;
                lmax,lmin,mcode : char;
                gcvs,vartype : array[1..10] of char;
                end;


const
    lg_reg_x : array [0..5,1..2] of integer = (
(   4, 47),(  9, 38),( 12, 26),
(  12,  1),(  9, 13),(  4, 22));

var
   F: textfile;
   lin1 : gcvtxt;
    fb : file of gcvrec;
   out : gcvrec;
   inp : array[0..100000] of gcvrec;
   nl : integer;
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


procedure Lecture;
var i,p :integer;
    ar,de,sde,jd1,jd2 : double;
    buf,buf1 : shortstring;
const blanc='                                                                  ';
begin
writeln('gcvs_cat.dat');
Assignfile(F,pathi+PathDelim+'gcvs_cat.dat');
Reset(F);
i:=0;
jd1:=jd(1950,1,1,0);
jd2:=jd(2000,1,1,0);
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

nl:=i;
end;

procedure wrt_lg(lgnum:integer);
var i,n,zone :integer;
    ar,de : double;
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
  inc(i);
  write(fb,out);
  end;
end;
close(fb);
end;

begin
pathi:='./';
patho:='./gcvs';
CreateDir(patho);
Lecture;
for lgnum:=1 to 50 do begin
  wrt_lg(lgnum);
end;

end.
