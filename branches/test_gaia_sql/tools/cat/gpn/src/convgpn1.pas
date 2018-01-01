unit convgpn1;

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
 GPNmain = record
                     png : array[1..10] of char;
                     s1  : array[1..2]of char;
                     arh5 : array[1..2] of char;
                     s2 : char;
                     arm5 : array[1..2] of char;
                     s3 : char;
                     ars5 : array[1..5]of char;
                     sde5 : char;
                     ded5 : array[1..2] of char;
                     s4 : char;
                     dem5 : array[1..2] of char;
                     s5  : char;
                     des5 : array[1..4] of char;
                     s6 : array[1..11] of char;
                     name : array[1..13]of char;
                     s7 : char;
                     pk : array[1..9] of char;
                     s8 : array[1..156] of char;
                     cr  :  char;
                     end;
GPNdiam = record
                     png : array[1..10] of char;
                     s1  : array[1..2]of char;
                     ldim : char;
                     dim : array[1..6] of char;
                     s2 : array[1..47] of char;
                     cr : char;
                     end;
GPNcstar = record
                     png : array[1..10] of char;
                     s1  : array[1..17]of char;
                     cs_lb: char;
                     cs_b : array[1..5]of char;
                     s2  : array[1..2]of char;
                     cs_lv: char;
                     cs_v : array[1..5]of char;
                     s3 : array[1..244] of char;
                     cr : char;
                     end;
GPNhbeta = record
                     png : array[1..10] of char;
                     s1  : array[1..2]of char;
                     Fhb : array[1..6]of char;
                     s2  : array[1..46] of char;
                     cr  : char;
                     end;
PLNtxt = record      pk : array[1..9] of char;
                     s1 : array[1..18] of char;
                     lv : char;
                     mV : array[1..4]of char;
                     s2 : char;
                     morph:char;
                     s3 : array [1..18] of char;
                     cr : char;
                     end;
GPNrec = record ar,de :longint ;
                dim,mv,mHb,cs_b,cs_v : smallint;
                ldim,lv,morph,cs_lb,cs_lv : char;
                png : array[1..10] of char;
                pk  : array[1..9] of char;
                name: array[1..13] of char;
                end;
const blankrec :GPNrec = (ar:0;de:0;dim:0;mv:9900;mHb:9900;cs_b:9900;cs_v:9900;
                         ldim:' ';lv:' ';morph:' ';cs_lb:' ';cs_lv:' ';
                         png:'          ';pk:'         ';name:'             ');
var
  Form1: TForm1;

implementation

{$R *.DFM}
const
    lg_reg_x : array [0..5,1..2] of integer = (
(   4, 47),(  9, 38),( 12, 26),
(  12,  1),(  9, 13),(  4, 22));

var
   F1: file of GPNmain;
   lin1 : GPNmain;
   F2: file of GPNdiam;
   lin2 : GPNdiam;
   F3: file of GPNcstar;
   lin3 : GPNcstar;
   F5: file of GPNhbeta;
   lin5 : GPNhbeta;
   F4: file of PLNtxt;
   lin4 : PLNtxt;
   fb : file of GPNrec;
   out : GPNrec;
   inp : array[1..2000] of GPNrec;
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
    ok : boolean;
begin
Assignfile(F1,pathi+'\main.txt');
Reset(F1);
i:=0;
jd1:=jd(1950,1,1,0);
jd2:=jd(2000,1,1,0);
repeat
  Read(F1,lin1);
  sde:=strtofloat(lin1.sde5+'1');
  de := sde*strtofloat(lin1.ded5)+sde*strtofloat(lin1.dem5)/60 ;
  if trim(lin1.des5)>'' then de:=de+sde*strtofloat(lin1.des5)/3600;
  ar := strtofloat(lin1.arh5)+strtofloat(lin1.arm5)/60+strtofloat(lin1.ars5)/3600;
  ar:=15*ar;
  precession(jd1,jd2,ar,de);
  inc(i);
  out:=blankrec;
  out.de:=round(de*100000);
  out.ar:=round(ar*100000);
  move(lin1.png,out.png,sizeof(out.png));
  lin1.pk[7]:='.';
  move(lin1.pk,out.pk,sizeof(out.pk));
  move(lin1.name,out.name,sizeof(out.name));
  inp[i]:=out;
until eof(F1);
nl:=i;
form1.Edit3.Text:='diam';
Form1.Update;
Close(F1);
Assignfile(F2,pathi+'\diam.txt');
Reset(F2);
repeat
  Read(F2,lin2);
  ok:=false;
  for i:=1 to nl do begin
      if inp[i].png=lin2.png then begin
         ok:=true;
         break;
      end;
  end;
  if ok then begin
    inp[i].ldim:=lin2.ldim;
    if trim(lin2.dim)>'' then inp[i].dim:=round(strtofloat(lin2.dim)*10);
  end;
until eof(F2);
Close(F2);
form1.Edit3.Text:='cstar';
Form1.Update;
Assignfile(F3,pathi+'\cstar.txt');
Reset(F3);
repeat
  Read(F3,lin3);
  ok:=false;
  for i:=1 to nl do begin
      if inp[i].png=lin3.png then begin
         ok:=true;
         break;
      end;
  end;
  if ok then begin
    inp[i].cs_lb:=lin3.cs_lb;
    inp[i].cs_lv:=lin3.cs_lv;
    if trim(lin3.cs_b)>'' then inp[i].cs_b:=round(strtofloat(lin3.cs_b)*100);
    if trim(lin3.cs_v)>'' then inp[i].cs_v:=round(strtofloat(lin3.cs_v)*100);
  end;
until eof(F3);
Close(F3);
form1.Edit3.Text:='hbeta';
Form1.Update;
Assignfile(F5,pathi+'\hbeta.txt');
Reset(F5);
repeat
  Read(F5,lin5);
  ok:=false;
  for i:=1 to nl do begin
      if inp[i].png=lin5.png then begin
         ok:=true;
         break;
      end;
  end;
  if ok then begin
    inp[i].mHb:=round((10 + 2.5*(-10 - strtofloat(lin5.Fhb)))*100) ;
  end;
until eof(F5);
Close(F5);
form1.Edit3.Text:='pln';
Form1.Update;
Assignfile(F4,pathi+'\pln.txt');
Reset(F4);
repeat
  Read(F4,lin4);
  if lin4.pk[5]=' ' then lin4.pk[5]:='0';
  ok:=false;
  for i:=1 to nl do begin
      if inp[i].pk=lin4.pk then begin
         ok:=true;
         break;
      end;
  end;
  if ok then begin
    inp[i].lv:=lin4.lv;
    inp[i].morph:=lin4.morph;
    if trim(lin4.mv)>'' then inp[i].mv:=round(strtofloat(lin4.mv)*100);
  end;
until eof(F4);
Close(F4);
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
if i=0 then begin
   out:=blankrec;
   out.ar:=99999999;out.de:=99999999;
   write(fb,out);
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
