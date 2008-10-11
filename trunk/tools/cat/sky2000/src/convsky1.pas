unit convsky1;

interface

uses math, 
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
     Skyrec = record id  : array[1..35] of char;
                     hd  : array[1..6] of char;
                     s1  : array[1..2] of char;
                     sao : array[1..6] of char;
                     s2  : char;
                     dm_cat: array[1..2] of char;
                     dms : char;
                     dm_z: array[1..2] of char;
                     dm_n: array[1..5] of char;
                     s3  : array [1..58] of char;
                     arh : array[1..2] of char;
                     arm : array[1..2] of char;
                     ars : array[1..7] of char;
                     sde : char;
                     ded : array[1..2] of char;
                     dem : array[1..2] of char;
                     des : array[1..6] of char;
                     s31 : array[1..9]of char;
                     pmar: array[1..8]of char;
                     pmdes: char;
                     pmde: array[1..7]of char;
                     s4  : array[1..67] of char;
                     vo  : array[1..6] of char;
                     vd  : array[1..5] of char;
                     s5  : array[1..9] of char;
                     bo  : array[1..6] of char;
                     b_v : array[1..6] of char;
                     s6  : array[1..34] of char;
                     bp  : array[1..4] of char;
                     s7  : array[1..34] of char;
                     sp  : array[1..3] of char;
                     s8  : array[1..2] of char;
                     sep : array[1..7] of char;
                     d_m : array[1..5] of char;
                     s9  : array[1..167] of char;
//                     cr  : char;
                     end;
SKYbin = record ar,de :longint ;
         mv,b_v,d_m,pmar,pmde :smallint;
         sep      : word;
         sp       : array [1..3] of char;
         dm_cat   : array[1..2]of char;
         dm     : longint;
         hd,sao   :longint ;
         end;
var
  Form1: TForm1;

implementation

{$R *.DFM}
const
    lg_reg_x : array [0..11,1..2] of integer = (
(  3, 182),(  9, 173),( 15, 158),
( 19, 139),( 22, 117),( 24,  93),
( 24,   1),( 22,  25),( 19,  47),
( 15,  66),(  9,  81),(  3,  90) );

var
   F: textfile;
   lin : skyrec;
   fb : array[1..184] of file of skybin;
   out : skybin;
   pathi,patho : string;
   ar0,ar1 : integer;

Procedure FindRegion(ar,de : double; var lg : integer);
var i1,i2,N,L1 : integer;
begin
i1 := Trunc((de+90)/15) ;
N  := lg_reg_x[i1,1];
L1 := lg_reg_x[i1,2];
i2 := Trunc(ar/(360/N));
Lg := L1+i2;
end;

Procedure InitRegion(lg : integer);
var i1,i2,N,L1,i,j : integer;
ok : boolean;
begin
ok:=false;
for i:=0 to 5 do begin
  l1:=lg_reg_x[i,2];
  if lg>=L1 then begin ok:=true ;break;end;
end;
if not ok then for j:=0 to 5 do begin
  i:=11-j;
  l1:=lg_reg_x[i,2];
  if lg>=L1 then begin ok:=true ;break;end;
end;
N  := lg_reg_x[i,1];
i2 := lg-L1;
ar0:= trunc(i2*(360/N)/15);
ar1:= trunc((i2+1)*(360/N)/15)+1;
end;

Function PadZeros(x : string ; l :integer) : string;
const zero = '000000000000';
var p : integer;
begin
x:=trim(x);
p:=l-length(x);
result:=copy(zero,1,p)+x;
end;

procedure wrt_lg(skyh:integer);
var i,n,s,zone,sdm :integer;
    ar,de,sde : extended;
    b,buf : string;
begin
b:=StringOfChar(' ', 300);
i:=0;
filemode:=0;
if skyh<0 then  begin   // single file
   Assignfile(F,pathi+'\sky2kv3.cat');
end else begin          // multi file
   Assignfile(F,pathi+'\sky'+padzeros(inttostr(skyh),2)+'.dat');
end;
reset(f);
repeat
  Readln(F,buf);
  buf:=buf+b;
  move(buf[1],lin,sizeof(lin));
  sde:=strtofloat(lin.sde+'1');
  de := sde*strtofloat(lin.ded)+sde*strtofloat(lin.dem)/60;
  if trim(lin.des)>'' then de:=de+sde*strtofloat(lin.des)/3600 ;
  ar := strtofloat(lin.arh)+strtofloat(lin.arm)/60+strtofloat(lin.ars)/3600;
  ar:=15*ar;
  findregion(ar,de,zone);
  inc(i);
  out.de:=round(de*100000);
  out.ar:=round(ar*100000);
  if trim(lin.pmar)>'' then out.pmar:=round(strtofloat(lin.pmar)*15*cos(degtorad(de))*1000)
                       else out.pmar:=0;
  s:=strtoint(trim(lin.pmdes+'1'));
  if trim(lin.pmde)>'' then out.pmde:=s*round(strtofloat(lin.pmde)*1000)
                       else out.pmde:=0;
  out.mv := 9900;
  if trim(lin.vo)>'' then out.mv:=round(strtofloat(lin.vo)*100);
  if (out.mv=9900) and (trim(lin.vd)>'') then out.mv:=round(strtofloat(lin.vd)*100);
  out.b_v := 9900;
  if trim(lin.b_v)>'' then out.b_v:=round(strtofloat(lin.b_v)*100);
  if trim(lin.sep)>'' then out.sep:=round(strtofloat(lin.sep)*100)
                      else out.sep:=0;
  if trim(lin.d_m)>'' then out.d_m:=round(strtofloat(lin.d_m)*100)
                      else out.d_m:=0;
  if trim(lin.hd)>'' then out.hd:=strtoint(lin.hd)
                     else out.hd:=0;
  if trim(lin.sao)>'' then out.sao:=strtoint(lin.sao)
                      else out.sao:=0;
  if lin.dms>' ' then begin
     sdm:=strtoint(lin.dms+'1');
     out.dm:=sdm*strtoint(lin.dm_z)*100000+sdm*strtoint(trim(lin.dm_n));
     end
     else out.dm := 0;
  move(lin.sp,out.sp,sizeof(out.sp));
  move(lin.dm_cat,out.dm_cat,sizeof(out.dm_cat));
  write(fb[zone],out);
  if (i mod 100)=0 then begin
     form1.Edit3.Text:=inttostr(i);
     Form1.Update;
  end;
until eof(F);
Closefile(F);
form1.Edit3.Text:=inttostr(i);
Form1.Update;
end;

procedure TForm1.Button1Click(Sender: TObject);
var lgnum : integer;
begin
pathi:=edit1.text;
patho:=edit2.text;
for lgnum:=1 to 184 do begin
   assignfile(fb[lgnum],patho+'\'+padzeros(inttostr(lgnum),3)+'.dat');
   Rewrite(fb[lgnum]);
end;
{for lgnum:=0 to 23 do begin    // multi file from CDS
  Edit1.Text:=inttostr(lgnum);
  wrt_lg(lgnum);
end;}

wrt_lg(-1);  // single file

for lgnum:=1 to 184 do closefile(fb[lgnum]);
end;

end.
