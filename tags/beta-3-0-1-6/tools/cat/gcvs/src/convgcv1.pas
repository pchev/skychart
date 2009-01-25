unit convgcv1;

interface

uses
  math,
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  DB, DBTables, StdCtrls;

type
  TForm1 = class(TForm)
    Button1: TButton;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    procedure Button1Click(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;
Type
 GCVtxt = record     l : byte;
                     num : array[1..7] of char;
                     s1  : char;
                     gcvs: array[1..10]of char;
                     s2  : char;
                     arh5 : array[1..2] of char;
                     arm5 : array[1..2] of char;
                     ars5 : array[1..4] of char;
                     sde5 : char;
                     ded5 : array[1..2] of char;
                     dem5 : array[1..2] of char;
                     des5 : array[1..2] of char;
                     s3  : char;
                     vartype : array[1..10] of char;
                     lmax : char;
                     max : array[1..6] of char;
                     s4 : char;
                     s5 : char;
                     lmin : char;
                     s6 : char;
                     min : array[1..6] of char;
                     s7  : char;
                     s8  : char;
                     fmin:char;
                     mcode : char;
                     s9  : array[1..16] of char;
                     ynova : array[1..4] of char;
                     s10  : char;
                     period : array[1..16] of char;
                     s11  : array [1..52] of char;
                     arh : array[1..2] of char;
                     arm : array[1..2] of char;
                     ars : array[1..4] of char;
                     sde : char;
                     ded : array[1..2] of char;
                     dem : array[1..2] of char;
                     des : array[1..2] of char;
                     cr  :  char;
                     end;
 NSVtxt = record     l : byte;
                     num : array[1..5] of char;
                     s1  : array[1..3] of char;
                     arh5 : array[1..2] of char;
                     arm5 : array[1..2] of char;
                     ars5 : array[1..4] of char;
                     sde5 : char;
                     ded5 : array[1..2] of char;
                     dem5 : array[1..2] of char;
                     des5 : array[1..2] of char;
                     s2  : char;
                     vartype : array[1..5] of char;
                     s3  : char;
                     max : array[1..5] of char;
                     lmax : char;
                     s4 : array [1..2]of char;
                     lmin : char;
                     min : array[1..6] of char;
                     s5 : array [1..2]of char;
                     fmin : char;
                     mcode : char;
                     s9  : array[1..9] of char;
                     desig : array[1..9] of char;
                     s11  : array [1..22] of char;
                     cr  :  char;
                     end;
 NSVStxt = record     l : byte;
                     num : array[1..5] of char;
                     s1  : array[1..19] of char;
                     arh : array[1..2] of char;
                     arm : array[1..2] of char;
                     ars : array[1..4] of char;
                     sde : char;
                     ded : array[1..2] of char;
                     dem : array[1..2] of char;
                     des : array[1..2] of char;
                     s2  : char;
                     vartype : array[1..6] of char;
                     s3  : char;
                     lmax : char;
                     max : array[1..5] of char;
                     s4 : array [1..2]of char;
                     s7 : char;
                     lmin : char;
                     min : array[1..6] of char;
                     s5 :  char;
                     fmin : char;
                     s6  : array[1..2] of char;
                     mcode : char;
                     s11  : array [1..44] of char;
                     cr  :  char;
                     end;
 EVStxt = record     l : byte;
                     num : array[1..7] of char;
                     s1  : char;
                     ngal : array[1..6] of char;
                     s12  : char;
                     nvar : array[1..5] of char;
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
                     min : array[1..5] of char;
                     s5 :  char;
                     fmin : char;
                     mcode : char;
                     s9  : array[1..86] of char;
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
var
  Form1: TForm1;

implementation

{$R *.DFM}
const
    lg_reg_x : array [0..5,1..2] of integer = (
(   4, 47),(  9, 38),( 12, 26),
(  12,  1),(  9, 13),(  4, 22));

blank14 : array [1..14] of char = '              ';

var
   F: textfile;
   lin1 : gcvtxt;
   lin2 : nsvtxt;
   lin3 : evstxt;
   lin4 : nsvstxt;
   fb : file of gcvrec;
   out : gcvrec;
   inp : array[0..100000] of gcvrec;
   nl : integer;
   pathi,patho : string;

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
var i,n,p,zone :integer;
    ar,de,sde,jd1,jd2 : double;
    buf : shortstring;
const blanc='                                                                  ';
begin
Assignfile(F,pathi+'\gcvs.dat');
Reset(F);
i:=0;
jd1:=jd(1950,1,1,0);
jd2:=jd(2000,1,1,0);
repeat
  Readln(F,buf);
  buf:=buf+blanc;
  move(buf,lin1,sizeof(lin1));
  if lin1.arh5='  ' then continue;
  if lin1.arh='  ' then begin
     sde:=strtofloat(lin1.sde5+'1');
     de := sde*strtofloat(lin1.ded5)+sde*strtofloat(lin1.dem5)/60 ;
     if trim(lin1.des5)>'' then de:=de+sde*strtofloat(lin1.des5)/3600;
     ar := strtofloat(lin1.arh5)+strtofloat(lin1.arm5)/60+strtofloat(lin1.ars5)/3600;
     ar:=15*ar;
     precession(jd1,jd2,ar,de);
     end
  else begin
     sde:=strtofloat(lin1.sde+'1');
     de := sde*strtofloat(lin1.ded)+sde*strtofloat(lin1.dem)/60 ;
     if trim(lin1.des)>'' then de:=de+sde*strtofloat(lin1.des)/3600;
     ar := strtofloat(lin1.arh)+strtofloat(lin1.arm)/60+strtofloat(lin1.ars)/3600;
     ar:=15*ar;
  end;
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
Assignfile(F,pathi+'\nsv.dat');
Reset(F);
jd1:=jd(1950,1,1,0);
jd2:=jd(2000,1,1,0);
repeat
  Readln(F,buf);
  buf:=buf+blanc;
  move(buf,lin2,sizeof(lin2));
  if lin2.arh5='  ' then continue;
     sde:=strtofloat(lin2.sde5+'1');
     de := sde*strtofloat(lin2.ded5)+sde*strtofloat(lin2.dem5)/60 ;
     if trim(lin2.des5)>'' then de:=de+sde*strtofloat(lin2.des5)/3600;
     ar := strtofloat(lin2.arh5)+strtofloat(lin2.arm5)/60+strtofloat(lin2.ars5)/3600;
     ar:=15*ar;
     precession(jd1,jd2,ar,de);
  inc(i);
  out.de:=round(de*100000);
  out.ar:=round(ar*100000);
  out.num:=strtoint(lin2.num);
  move(lin2.desig,out.gcvs,sizeof(out.gcvs));
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
Assignfile(F,pathi+'\nsvs.dat');
Reset(F);
repeat
  Readln(F,buf);
  buf:=buf+blanc;
  move(buf,lin4,sizeof(lin4));
  if lin4.arh='  ' then continue;
     sde:=strtofloat(lin4.sde+'1');
     de := sde*strtofloat(lin4.ded)+sde*strtofloat(lin4.dem)/60 ;
     if trim(lin4.des)>'' then de:=de+sde*strtofloat(lin4.des)/3600;
     ar := strtofloat(lin4.arh)+strtofloat(lin4.arm)/60+strtofloat(lin4.ars)/3600;
     ar:=15*ar;
  inc(i);
  out.de:=round(de*100000);
  out.ar:=round(ar*100000);
  out.num:=strtoint(lin4.num);
  move(blanc[1],out.gcvs,sizeof(out.gcvs));
  move(lin4.vartype,out.vartype,sizeof(lin4.vartype));
     p:=6;
     out.vartype[p+1]:='N';
     out.vartype[p+2]:='S';
     out.vartype[p+3]:='V';
     out.vartype[p+4]:=' ';
  out.lmax:=lin4.lmax;
  out.lmin:=lin4.lmin;
  if trim(lin4.max)>'' then out.max:=round(strtofloat(trim(lin4.max))*100)
                      else out.max:=9900;
  if trim(lin4.min)>'' then out.min:=round(strtofloat(trim(lin4.min))*100)
                      else out.min:=9900;
  if lin4.fmin=')' then out.min:=out.min+out.max;
  out.mcode:=lin4.mcode;
  out.period:=0;
  inp[i]:=out;
until eof(F);
Close(F);
Assignfile(F,pathi+'\evs_cat.dat');
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
  buf:=trim(lin3.ngal);
  if length(buf)<5 then buf:=buf+' ';
  if length(buf)>5 then buf:=copy(buf,2,5);
  buf:=buf+lin3.nvar+blanc;
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
nl:=i;
form1.Edit3.Text:=inttostr(i);
Form1.Update;
end;

procedure wrt_lg(lgnum:integer);
var i,n,p,zone :integer;
    ar,de,sde,jd1,jd2 : double;
begin
assignfile(fb,patho+'\'+padzeros(inttostr(lgnum),2)+'.dat');
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
  if (i mod 100)=0 then begin
     form1.Edit3.Text:=inttostr(i);
     Form1.Update;
  end;
  end;
end;
form1.Edit3.Text:=inttostr(i);
Form1.Update;
close(fb);
end;

procedure TForm1.Button1Click(Sender: TObject);
var lgnum : integer;
begin
pathi:=edit1.text;
patho:=edit2.text;
Lecture;
for lgnum:=1 to 50 do begin
  Edit1.Text:=inttostr(lgnum);
  wrt_lg(lgnum);
end;
end;

end.
