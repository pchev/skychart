unit convlbn1;

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
 LBNtxt = record     s0 : char ;
                     num : array[1..4] of char;
                     s1  : array[1..15]of char;
                     arh5 : array[1..2] of char;
                     s2 : char;
                     arm5 : array[1..2] of char;
                     s3 : array [1..2] of char;
                     sde5 : char;
                     ded5 : array[1..2] of char;
                     s4 : char;
                     dem5 : array[1..2] of char;
                     s5  : array[1..2]of char;
                     d1  : array[1..4] of char;
                     s6 : char;
                     d2 : array[1..3] of char;
                     s7 : char;
                     area : array[1..7]of char;
                     s8 : char;
                     color : char;
                     s9 : char;
                     bright:char;
                     s10 : char;
                     id : array[1..3] of char;
                     s11  : char;
                     name : array[1..8] of char;
                     cr  :  char;
                     end;
LBNrec = record ar,de :longint ;
                area : single;
                num,d1,d2,id : word;
                color,bright : byte;
                name : array[1..8] of char;
                end;
var
  Form1: TForm1;

implementation

{$R *.DFM}
const
    lg_reg_x : array [0..5,1..2] of integer = (
(   4, 47),(  9, 38),( 12, 26),
(  12,  1),(  9, 13),(  4, 22));

var
   F: file of lbntxt;
   lin : lbntxt;
   fb : file of lbnrec;
   out : lbnrec;
   inp : array[1..2000] of lbnrec;
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
begin
Assignfile(F,pathi);
Reset(F);
i:=0;
jd1:=jd(1950,1,1,0);
jd2:=jd(2000,1,1,0);
repeat
  Read(F,lin);
  sde:=strtofloat(lin.sde5+'1');
  de := sde*strtofloat(lin.ded5)+sde*strtofloat(lin.dem5)/60 ;
  ar := strtofloat(lin.arh5)+strtofloat(lin.arm5)/60;
  ar:=15*ar;
  precession(jd1,jd2,ar,de);
  inc(i);
  out.de:=round(de*100000);
  out.ar:=round(ar*100000);
  out.num:=strtoint(lin.num);
  move(lin.name,out.name,sizeof(out.name));
  if trim(lin.d1)>'' then out.d1:=strtoint(trim(lin.d1))
                     else out.d1:=0;
  if trim(lin.d2)>'' then out.d2:=strtoint(trim(lin.d2))
                     else out.d2:=0;
  if trim(lin.bright)>'' then out.bright:=strtoint(trim(lin.bright))
                     else out.bright:=0;
  if trim(lin.color)>'' then out.color:=strtoint(trim(lin.color))
                     else out.color:=0;
  if trim(lin.id)>'' then out.id:=strtoint(trim(lin.id))
                     else out.id:=0;
  if trim(lin.area)>'' then out.area:=strtofloat(trim(lin.area))
                      else out.area:=0;
  inp[i]:=out;
until eof(F);
nl:=i;
form1.Edit3.Text:=inttostr(i);
Form1.Update;
Close(F);
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
   out.ar:=99999999;out.de:=99999999;out.d1:=0;out.d2:=0;
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
