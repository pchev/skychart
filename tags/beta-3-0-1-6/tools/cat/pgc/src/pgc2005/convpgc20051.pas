unit convpgc20051;

{
extraction du fichier depuis Hyperleda  avec le requete:
psql -o pgc.txt -c "select pgc, objname, al2000, de2000, bt, bvt, brief, objtype, type, logd25, logr25, pa, v from meandata where (objtype in ('G','Q','g') or (objtype='M' and multiple='M'))" hl
}

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
Readln(F,buf);
Readln(F,buf);
repeat
  Readln(F,buf);
  if copy(buf,1,1)='(' then break;
  // PGC
  outl.pgc:=strtoint(copy(buf,1,8));
  // RA DEC
  de := strtofloat(copy(buf,51,11));
  ar := strtofloat(copy(buf,38,10));
  ar:=15*ar;
  findregion(ar,de,zone);
  inc(i);
  outl.de:=round(de*100000);
  outl.ar:=round(ar*100000);
  // NOM
  move(blank16,outl.nom,sizeof(outl.nom));
  v:=copy(buf,12,23);
  if copy(v,1,3)='PGC' then v:=blank16; // pas de repetition du nom 
  w:='';
  for j:=1 to length(v) do if (v[j]<>' ') then w:=w+v[j];
  w:=w+blank16;
  for j:=1 to 16 do outl.nom[j]:=w[j];
  // TYPE
  move(blank4,outl.typ,sizeof(outl.typ));
  v:=copy(buf,101,4);
  if v=blank4 then v:=copy(buf,91,1);
  for j:=1 to length(v) do outl.typ[j]:=v[j];
  // PA
  v:=copy(buf,126,6);
  if (v)<>'      ' then outl.pa:=round(strtofloat(v))
                else outl.pa:=255;
  // MAJ axis
  v:=trim(copy(buf,108,6));
  if (v)<>'' then begin
     maj:=power(10,strtofloat(v))/10;
     outl.maj:=round(maj*100);
     end
  else begin
     maj:=0;
     outl.maj:=0;
  end;
  // Min axis
  v:=trim(copy(buf,117,6));
  if (v)<>'' then outl.min:=round((maj/power(10,strtofloat(v)))*100)
                else outl.min:=round(maj*100);
  // Mag
  v:=trim(copy(buf,65,6));
  if (v)<>'' then outl.mb:=round(strtofloat(v)*100)
                        else outl.mb:=-9990;
  // RV
  v:=trim(copy(buf,135,7));
  if (v)<>'' then outl.hrv:=round(strtofloat(v))
                        else outl.hrv:=-999999;
  //
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
