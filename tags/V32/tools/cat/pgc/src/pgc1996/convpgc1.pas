unit convpgc1;

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
PGCrec = record
                pgc,ar,de,hrv   : Longint;
                nom   : array [1..16] of char;
                typ   : array [1..4] of char;
                pa    : byte;
                maj,min,mb : smallint;
                end;
var
  Form1: TForm1;

implementation

{$R *.DFM}
const
    lg_reg_x : array [0..5,1..2] of integer = (
(   4, 47),(  9, 38),( 12, 26),
(  12,  1),(  9, 13),(  4, 22));

blank16 : array [1..16] of char = '                ';
blank4 = '    ';

var
   F: textfile;
   fb : file of pgcrec;
   outl : pgcrec;
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
var i,j,n,zone :integer;
    ar,de,sde : extended;
    buf,v,b : string;
begin
buf:=pathi+'\pgc.dat';
Assignfile(F,buf);
Reset(F);
buf:=patho+'\'+padzeros(inttostr(lgnum),2)+'.dat';
assignfile(fb,buf);
Rewrite(fb);
i:=0;
b:=blank16+blank16+blank16+blank16+blank16+blank16+blank16+blank16+blank16+blank16;
repeat
  Readln(F,buf);
  buf:=buf+b;
  if copy(buf,1,5)='     ' then continue;
  outl.pgc:=strtoint(copy(buf,1,5));
  sde:=strtofloat(copy(buf,15,1)+'1');
  de := sde*strtofloat(copy(buf,16,2))+sde*strtofloat(copy(buf,18,2))/60 ;
  if trim(copy(buf,20,2))>'' then de:=de+sde*strtofloat(copy(buf,20,2))/3600;
  ar := strtofloat(copy(buf,7,2))+strtofloat(copy(buf,9,2))/60+strtofloat(copy(buf,11,4))/3600;
  ar:=15*ar;
  findregion(ar,de,zone);
  if zone=lgnum then begin
  inc(i);
  outl.de:=round(de*100000);
  outl.ar:=round(ar*100000);
  move(blank16,outl.nom,sizeof(outl.nom));
  v:=copy(buf,78,16);
  for j:=1 to length(v) do outl.nom[j]:=v[j];
  move(blank4,outl.typ,sizeof(outl.typ));
  v:=copy(buf,40,4);
  for j:=1 to length(v) do outl.typ[j]:=v[j];
  v:=copy(buf,74,3);
  if trim(v)>'' then outl.pa:=round(strtofloat(v))
                else outl.pa:=255;
  v:='0'+trim(copy(buf,44,6));
  if trim(v)<>'0' then outl.maj:=round(strtofloat(v)*100)
                else outl.maj:=-9990;
  v:='0'+trim(copy(buf,52,5));
  if trim(v)<>'0' then outl.min:=round(strtofloat(v)*100)
                else outl.min:=-9990;
  v:=trim(copy(buf,60,4));
  if trim(v)>'' then outl.mb:=round(strtofloat(v)*100)
                        else outl.mb:=-9990;
  v:=trim(copy(buf,67,5));
  if trim(v)>'' then outl.hrv:=strtoint(v)
                        else outl.hrv:=-999999;
  write(fb,outl);
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
