unit convocl1;

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
 OCLtxt = record     cat : array[1..2] of char;
                     num : array[1..4]of char;
                     s1 : char;
                     arh : array[1..2] of char;
                     arm : array[1..4] of char;
                     sde : char;
                     ded : array[1..2] of char;
                     dem : array[1..2] of char;
                     s2  : array[1..36]of char;
                     ocl : array[1..4] of char;
                     dim2 : array [1..6] of char;
                     s3 : array[1..4] of char;
                     dist : array[1..4]of char;
                     s4 : array[1..4]of char;
                     age : array[1..5]of char;
                     s5 : array[1..113]of char;
                     s51:char;
                     conc2 : char;
                     s52:char;
                     range2 : char;
                     s6 : char;
                     rich2 : char;
                     s7 : char;
                     neb2 :char;
                     s8 : array [1..12]of char;
                     ms : array[1..4] of char;
                     s9 : array [1..6]of char;
                     mt1: array[1..4] of char;
                     s10 : array[1..6]of char;
                     mt2 : array[1..4]of char;
                     b_v : array[1..4]of char;
                     ns2 : array[1..4]of char;
                     s11 : array[1..31]of char;
                     conc1: char;
                     s12 :char;
                     range1 : char;
                     s13 :char;
                     rich1:char;
                     s14 :char;
                     neb1 :char;
                     s15:char;
                     ns1 : array[1..3]of char;
                     s16 : char;
                     dim1 : array[1..5]of char;
                     s17 : array[1..220]of char;
                     cr  :  char;
                     end;
OCLrec = record ar,de :longint ;
                cat,num,ocl,dim,dist,age,ms,mt,b_v,ns : smallint;
                conc,range,rich,neb : char;
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
   F: file of ocltxt;
   lin : ocltxt;
   fb : file of oclrec;
   out : oclrec;
   inp : array[1..2000] of oclrec;
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

procedure Lecture;
var i,n,p,zone :integer;
    ar,de,sde : double;
begin
Assignfile(F,pathi);
Reset(F);
i:=0;
repeat
  Read(F,lin);
  sde:=strtofloat(lin.sde+'1');
  de := sde*strtofloat(lin.ded)+sde*strtofloat(lin.dem)/60 ;
  ar := strtofloat(lin.arh)+strtofloat(lin.arm)/60;
  ar:=15*ar;
  inc(i);
  out.de:=round(de*100000);
  out.ar:=round(ar*100000);
  out.cat:=strtoint(lin.cat);
  out.num:=strtoint(lin.num);
  if trim(lin.ocl)>'' then out.ocl:=strtoint(trim(lin.ocl))
                     else out.ocl:=0;
  if trim(lin.dim1)>'' then out.dim:=round(strtofloat(trim(lin.dim1))*10)
        else if trim(lin.dim2)>'' then out.dim:=round(strtofloat(trim(lin.dim2))*10)
             else out.dim:=0;
  if trim(lin.dist)>'' then out.dist:=strtoint(trim(lin.dist))
                     else out.dist:=0;
  if trim(lin.age)>'' then out.age:=round(strtofloat(trim(lin.age))*100)
                     else out.age:=0;
  if trim(lin.ms)>'' then out.ms:=round(strtofloat(trim(lin.ms))*100)
                     else out.ms:=9900;
  if trim(lin.mt1)>'' then out.mt:=round(strtofloat(trim(lin.mt1))*100)
        else if trim(lin.mt2)>'' then out.mt:=round(strtofloat(trim(lin.mt2))*100)
             else out.mt:=9900;
  if trim(lin.b_v)>'' then out.b_v:=round(strtofloat(trim(lin.b_v))*100)
                     else out.b_v:=9900;
  if trim(lin.ns1)>'' then out.ns:=strtoint(trim(lin.ns1))
        else if trim(lin.ns2)>'' then out.ns:=strtoint(trim(lin.ns2))
             else out.ns:=0;
  if trim(lin.conc1)>'' then out.conc:=lin.conc1
        else if trim(lin.conc2)>'' then out.conc:=lin.conc2
             else out.conc:=' ';
  if trim(lin.range1)>'' then out.range:=lin.range1
        else if trim(lin.range2)>'' then out.range:=lin.range2
             else out.range:=' ';
  if trim(lin.rich1)>'' then out.rich:=lin.rich1
        else if trim(lin.rich2)>'' then out.rich:=lin.rich2
             else out.rich:=' ';
  if trim(lin.neb1)>'' then out.neb:=lin.neb1
        else if trim(lin.neb2)>'' then out.neb:=lin.neb2
             else out.neb:=' ';
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
