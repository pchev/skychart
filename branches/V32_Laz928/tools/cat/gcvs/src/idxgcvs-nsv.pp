program idxgcvs1;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  SysUtils, Classes, Math;

Type
 filidx = record clef : array[1..12] of char;     
                 ar,de :single;
          end;


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

const
maxl = 100000;

var
   F: textfile;
   lin1 : gcvtxt;
   lin2 : nsvtxt;
   lin3 : evstxt;
   fo   : file of filidx;
   inp : array[1..maxl] of filidx;
   nl : integer;
   pathi,patho : string;


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
var i :integer;
    ar,de,sde,jd1,jd2 : double;
    buf : shortstring;
const blanc='                                                                  ';
begin
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
  inp[i].de:=de;
  inp[i].ar:=ar;
  buf:=uppercase(lin1.gcvs)+blanc;
  move(buf[1],inp[i].clef,sizeof(inp[i].clef));
until eof(F);
Close(F);

Assignfile(F,pathi+PathDelim+'nsv_cat.dat');
Reset(F);
jd1:=jd(1950,1,1,0);
jd2:=jd(2000,1,1,0);
repeat
  Readln(F,buf);
  buf:=buf+blanc;
  move(buf,lin2,sizeof(lin2));
  if lin2.arh='  ' then continue;
  sde:=strtofloat(lin2.sde+'1');
  de := sde*strtofloat(lin2.ded)+sde*strtofloat(lin2.dem)/60 ;
  if trim(lin2.des)>'' then de:=de+sde*strtofloat(lin2.des)/3600;
  ar := strtofloat(lin2.arh)+strtofloat(lin2.arm)/60+strtofloat(lin2.ars)/3600;
  ar:=15*ar;
  inc(i);
  inp[i].de:=de;
  inp[i].ar:=ar;
  buf:='NSV   '+lin2.num+blanc;
  move(buf[1],inp[i].clef,sizeof(inp[i].clef));
until eof(F);
Close(F);

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
     precession(jd1,jd2,ar,de);
     ar:=15*ar;
  inc(i);
  inp[i].de:=de;
  inp[i].ar:=ar;
  buf:=uppercase(lin3.gcvs)+blanc;
  move(buf[1],inp[i].clef,sizeof(inp[i].clef));
until eof(F);
Close(F);
nl:=i;
end;

procedure Ecriture ;
var i :integer;
  lin : filidx;
begin
assignfile(fo,patho+PathDelim+'gcvs.idx');
Rewrite(fo);
for i:=1 to nl do begin
  lin:=inp[i];
  Write(Fo,lin);
end;
CloseFile(Fo);
end;

Procedure Tshell(g,d:integer);
var pas,i,j,k : integer;
    lin : filidx;
begin
pas:=1;
while pas < ((d-g+1) div 9) do pas :=pas*3+1;
repeat
  for k:=g to pas do begin
    i:=k+pas; if i<d then
    repeat
      lin:=inp[i];
      j:=i-pas;
      while (j>=k+pas) and (inp[j].clef > lin.clef) do begin
        inp[j+pas] := inp[j];
        j:=j-pas ;
      end;
      if inp[k].clef > lin.clef then begin
        j:=k-pas;
        inp[k+pas]:=inp[k];
      end;
      inp[j+pas]:=lin;
      i:=i+pas;
    until i>d;
  end;
  pas:=pas div 3;
until pas=0;
end;

begin
pathi:='./';
patho:='./gcvs-nsv';
  Lecture;
  Tshell(1,nl);
  Ecriture;

end.
