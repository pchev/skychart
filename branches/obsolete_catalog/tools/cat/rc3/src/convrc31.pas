unit convrc31;

interface

uses
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
 Rc3rec = record arh : array[1..2] of char;
                     arm : array[1..2] of char;
                     ars : array[1..4] of char;
                     s3  : char;
                     sde : char;
                     ded : array[1..2] of char;
                     dem : array[1..2] of char;
                     des : array[1..2] of char;
                     s6  : array [1..46] of char;
                     name : array[1..12] of char;
                     s61 : char;
                     altn: array[1..14] of char;
                     s62 : char;
                     desig: array[1..14] of char;
                     s7  : char;
                     pgct: array[1..3] of char;
                     pgc : array[1..8] of char;
                     s8  : char;
                     typ : array[1..7] of char;
                     s9  : array [1..7] of char;
                     stage: array[1..4] of char;
                     s10 : array [1..6] of char;
                     lumcl: array[1..4] of char;
                     s11 : array[1..6] of char;
                     d25 : array[1..4] of char;
                     s12 : array [1..6] of char;
                     r25 : array[1..4] of char;
                     s13 : array[1..11] of char;
                     ae  : array[1..4] of char;
                     s15 : array [1..5] of char;
                     pa  : array[1..3] of char;
                     s16 : char;
                     bt  : array[1..5] of char;
                     s17 : array[1..6] of char;
                     mb  : array[1..5] of char;
                     s18 : array[1..11] of char;
                     m25 : array[1..5] of char;
                     s19 :array[1..6] of char;
                     me  :array [1..5] of char;
                     s20 :array[1..20] of char;
                     b_vt:array[1..4] of char;
                     s21 :array[1..5] of char;
                     b_ve:array[1..4]of char;
                     s22 :array[1..87]of char;
                     vgsr:array[1..5] of char;
                     s23 :array[1..7]of char;
                     end;
RC3bin = record ar,de,vgsr :longint ;
                pgc   : array[1..8] of char;
                nom   : array [1..14] of char;
                typ   : array [1..7] of char;
                pa    : byte;
                stage,lumcl,d25,r25,Ae,mb,b_vt,b_ve,m25,me : smallint;
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
   F: file of rc3rec;
   rc3 : rc3rec;
   fb : file of rc3bin;
   out : rc3bin;
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

procedure wrt_lg(lgnum:integer);
var i,n,zone :integer;
    ar,de,sde : extended;
begin
Assignfile(F,pathi+'\rc3.txt');
Reset(F);
assignfile(fb,patho+'\'+padzeros(inttostr(lgnum),2)+'.dat');
Rewrite(fb);
i:=0;
repeat
  Read(F,rc3);
  sde:=strtofloat(rc3.sde+'1');
  de := sde*strtofloat(rc3.ded)+sde*strtofloat(rc3.dem)/60 ;
  if trim(rc3.des)>'' then de:=de+sde*strtofloat(rc3.des)/3600;
  ar := strtofloat(rc3.arh)+strtofloat(rc3.arm)/60+strtofloat(rc3.ars)/3600;
  ar:=15*ar;
  findregion(ar,de,zone);
  if zone=lgnum then begin
  inc(i);
  out.de:=round(de*100000);
  out.ar:=round(ar*100000);
  move(rc3.pgc,out.pgc,sizeof(out.pgc));
  move(blank14,out.nom,sizeof(out.nom));
  move(rc3.name,out.nom,sizeof(rc3.name));
  if trim(out.nom)='' then move(rc3.altn,out.nom,sizeof(out.nom));
  if trim(out.nom)='' then move(rc3.desig,out.nom,sizeof(out.nom));
  move(rc3.typ,out.typ,sizeof(out.typ));
  if trim(rc3.pa)>'' then out.pa:=round(strtofloat(rc3.pa))
                     else out.pa:=255;
  if trim(rc3.stage)>'' then out.stage:=round(strtofloat(rc3.stage)*10)
                        else out.stage:=-9990;
  if trim(rc3.lumcl)>'' then out.lumcl:=round(strtofloat(rc3.lumcl)*10)
                        else out.lumcl:=-9990;
  if trim(rc3.d25)>'' then out.d25:=round(strtofloat(rc3.d25)*100)
                      else out.d25:=-9990;
  if trim(rc3.r25)>'' then out.r25:=round(strtofloat(rc3.r25)*100)
                      else out.r25:=-9990;
  if trim(rc3.ae)>'' then out.ae:=round(strtofloat(rc3.ae)*100)
                      else out.ae:=-9990;
  if trim(rc3.bt)>'' then out.mb:=round(strtofloat(rc3.bt)*100)
                        else out.mb:=-9990;
  if (out.mb=-9990) and (trim(rc3.mb)>'') then out.mb:=round(strtofloat(rc3.mb)*100);
  if trim(rc3.m25)>'' then out.m25:=round(strtofloat(rc3.m25)*100)
                     else out.m25:=-9990;
  if trim(rc3.me)>'' then out.me:=round(strtofloat(rc3.me)*100)
                     else out.me:=-9990;
  if trim(rc3.b_vt)>'' then out.b_vt:=round(strtofloat(rc3.b_vt)*100)
                        else out.b_vt:=-9990;
  if trim(rc3.b_ve)>'' then out.b_ve:=round(strtofloat(rc3.b_ve)*100)
                        else out.b_ve:=-9990;
  if trim(rc3.vgsr)>'' then out.vgsr:=strtoint(rc3.vgsr)
                        else out.vgsr:=-999999;
  write(fb,out);
  if (i mod 100)=0 then begin
     form1.Edit3.Text:=inttostr(i);
     Form1.Update;
  end;
  end;
until eof(F);        
form1.Edit3.Text:=inttostr(i);
Form1.Update;
close(fb);
Close(F);
end;

procedure TForm1.Button1Click(Sender: TObject);
var lgnum : integer;
begin
pathi:=edit1.text;
patho:=edit2.text;
for lgnum:=1 to 50 do begin
  Edit1.Text:=inttostr(lgnum);
  wrt_lg(lgnum);
end;
end;

end.
