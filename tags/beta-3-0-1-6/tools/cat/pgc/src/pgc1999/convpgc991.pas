unit convpgc991;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Math, StdCtrls;

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

PGCfile = record
                line : array[1..1268] of char;
                cr   : char;
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
   F: file of pgcfile;
   fb : array[1..50] of file of pgcrec;
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

procedure wrt_lg;
var i,j,n,zone,lgnum :integer;
    ar,de,sde : extended;
    buf,v,w,b : string;
    maj : double;
    lin : pgcfile;
begin
buf:=pathi;
Assignfile(F,buf);
Reset(F);
for lgnum:=1 to 50 do begin
  buf:=patho+'\'+padzeros(inttostr(lgnum),2)+'.dat';
  assignfile(fb[lgnum],buf);
  Rewrite(fb[lgnum]);
end;
i:=0;
b:=blank16+blank16+blank16+blank16+blank16+blank16+blank16+blank16+blank16+blank16;
repeat
  Read(F,lin);
  buf:=lin.line+b;
  if copy(buf,5,7)='     ' then continue;
  outl.pgc:=strtoint(copy(buf,5,7));
  de := strtofloat(copy(buf,69,10));
  ar := strtofloat(copy(buf,59,10));
  ar:=15*ar;
  findregion(ar,de,zone);
  inc(i);
  outl.de:=round(de*100000);
  outl.ar:=round(ar*100000);
  move(blank16,outl.nom,sizeof(outl.nom));
  v:=copy(buf,13,25);
  w:='';
  for j:=1 to length(v) do if (v[j]<>' ')and(v[j]<>'-') then w:=w+v[j];
  w:=w+blank16;
  for j:=1 to 16 do outl.nom[j]:=w[j];
  move(blank4,outl.typ,sizeof(outl.typ));
  v:=copy(buf,119,4);
  for j:=1 to length(v) do outl.typ[j]:=v[j];
  v:=copy(buf,209,10);
  if (v)<>'-99999.000' then outl.pa:=round(strtofloat(v))
                else outl.pa:=255;
  v:=trim(copy(buf,169,10));
  if (v)<>'-99999.000' then begin
     maj:=power(10,strtofloat(v))/10;
     outl.maj:=round(maj*100);
     end
  else begin
     maj:=0;
     outl.maj:=0;
  end;
  v:=trim(copy(buf,189,10));
  if (v)<>'-99999.000' then outl.min:=round((maj/power(10,strtofloat(v)))*100)
                else outl.min:=round(maj*100);
  v:=trim(copy(buf,239,10));
  if (v)<>'-99999.000' then outl.mb:=round(strtofloat(v)*100)
                        else outl.mb:=-9990;
  v:=trim(copy(buf,459,10));
  if (v)<>'-99999.000' then outl.hrv:=round(strtofloat(v))
                        else outl.hrv:=-999999;
  write(fb[zone],outl);
  if (i mod 1000)=0 then begin
     form1.Edit3.Text:=inttostr(i);
     Form1.Update;
  end;
until eof(F);
form1.Edit3.Text:=inttostr(i);
Form1.Update;
for lgnum:=1 to 50 do close(fb[lgnum]);
Close(F);
end;

procedure TForm1.Button1Click(Sender: TObject);
var lgnum : integer;
begin
pathi:=edit1.text;
patho:=edit2.text;
wrt_lg;
end;

end.
