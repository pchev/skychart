unit convgcm1;

interface

uses
  math,
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

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
 GCMtxt = record     s0 : char ;
                     id : array[1..9] of char;
                     s1  : char;
                     name: array[1..11]of char;
                     s101:char;
                     arh : array[1..2] of char;
                     s2 : char;
                     arm : array[1..2] of char;
                     s21 : char;
                     ars : array [1..4]of char;
                     s3 : array [1..2] of char;
                     sde : char;
                     ded : array[1..2] of char;
                     s4 : char;
                     dem : array[1..2] of char;
                     s5  : char;
                     des : array[1..2] of char;
                     s6 : array [1..16] of char;
                     rsun : array[1..5] of char;
                     s7 : array[1..44] of char;
                     Vt : array[1..5]of char;
                     s8 : array[1..14]of char;
                     b_vt : array[1..5]of char;
                     s9 : array[1..37]of char;
                     Spt: array[1..4] of char;
                     s10 : array [1..20]of char;
                     c : array[1..4] of char;
                     s11  : array[1..3]of char;
                     Rc : array[1..4] of char;
                     s12 :char;
                     Rh : array[1..4]of char;
                     s13 :array[1..15]of char;
                     muV : array[1..5]of char;
                     s14 :array[1..6]of char;
                     cr  :  char;
                     end;
GCMrec = record ar,de :longint ;
                Rsun,Vt,B_Vt,c,Rc,Rh,muV : smallint;
                id   : array[1..9] of char;
                name : array[1..11] of char;
                SpT  : array[1..4] of char;
                end;
var
  Form1: TForm1;

implementation

{$R *.DFM}
var
   F: file of gcmtxt;
   lin : gcmtxt;
   fb : file of gcmrec;
   out : gcmrec;
   inp : array[1..200] of gcmrec;
   nl : integer;
   pathi,patho : string;

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
    ar,de,sde,jd1,jd2 : double;
begin
Assignfile(F,pathi);
Reset(F);
i:=0;
repeat
  Read(F,lin);
  sde:=strtofloat(lin.sde+'1');
  de := sde*strtofloat(lin.ded)+sde*strtofloat(lin.dem)/60+sde*strtofloat(lin.des)/3600 ;
  ar := strtofloat(lin.arh)+strtofloat(lin.arm)/60+strtofloat(lin.ars)/3600;
  ar:=15*ar;
  inc(i);
  out.de:=round(de*100000);
  out.ar:=round(ar*100000);
  move(lin.id,out.id,sizeof(out.id));
  move(lin.name,out.name,sizeof(out.name));
  move(lin.spt,out.spt,sizeof(out.spt));
  if trim(lin.rsun)>'' then out.rsun:=round(strtofloat(trim(lin.rsun))*10)
                     else out.rsun:=0;
  if trim(lin.vt)>'' then out.vt:=round(strtofloat(trim(lin.vt))*100)
                     else out.vt:=9900;
  if trim(lin.b_vt)>'' then out.b_vt:=round(strtofloat(trim(lin.b_vt))*100)
                     else out.b_vt:=9900;
  if trim(lin.c)>'' then out.c:=round(strtofloat(trim(lin.c))*100)
                     else out.c:=0;
  if trim(lin.rc)>'' then out.rc:=round(strtofloat(trim(lin.rc))*100)
                     else out.rc:=0;
  if trim(lin.rh)>'' then out.rh:=round(strtofloat(trim(lin.rh))*100)
                     else out.rh:=0;
  if trim(lin.muv)>'' then out.muv:=round(strtofloat(trim(lin.muv))*100)
                     else out.muv:=9900;
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
  inc(i);
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
lgnum:=1;
  Edit1.Text:=inttostr(lgnum);
  wrt_lg(lgnum);
end;

end.
