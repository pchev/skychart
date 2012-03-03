unit convpgc1;

{$MODE Delphi}

{
extraction du fichier depuis Hyperleda  avec la requete:
psql -c "CREATE OR REPLACE FUNCTION cdc_name(integer) RETURNS character varying AS 'SELECT design FROM designation WHERE PGC = \$1 and iref in (1,2,3,4,5,6,7,67,88) order by iref asc;' LANGUAGE SQL" hl
psql -o pgc.txt -c "select pgc, cdc_name(pgc), al2000, de2000, bt, bvt, brief, objtype, type, to_char((10 ^ logd25)/10,9990.99), to_char((10 ^ logd25)/10 / (10 ^ logr25),9990.99), pa, v from meandata where (objtype in ('G','Q','g') or (objtype='M' and multiple='M'))" hl

}

interface

uses
  LCLIntf, LCLType, LMessages, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
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

{$R *.lfm}
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
    maj,min : double;
begin
buf:=pathi;
Assignfile(F,buf);
Reset(F);
if not DirectoryExists(patho) then ForceDirectories(patho);
for lgnum:=1 to 50 do begin
  buf:=patho+PathDelim+padzeros(inttostr(lgnum),2)+'.dat';
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
  de := strtofloat(copy(buf,43,11));
  ar := strtofloat(copy(buf,30,10));
  ar:=15*ar;
  findregion(ar,de,zone);
  inc(i);
  outl.de:=round(de*100000);
  outl.ar:=round(ar*100000);
  // NOM
  move(blank16,outl.nom,sizeof(outl.nom));
  v:=copy(buf,12,16);
  if copy(v,1,3)='PGC' then v:=blank16; // pas de repetition du nom 
  w:='';
  for j:=1 to length(v) do if (v[j]<>' ') then w:=w+v[j];
  w:=w+blank16;
  for j:=1 to 16 do outl.nom[j]:=w[j];
  // TYPE
  move(blank4,outl.typ,sizeof(outl.typ));
  v:=copy(buf,94,4);
  if v=blank4 then v:=copy(buf,84,1);
  for j:=1 to length(v) do outl.typ[j]:=v[j];
  // PA
  v:=copy(buf,123,6);
  if (v)<>'      ' then outl.pa:=round(strtofloat(v))
                else outl.pa:=255;
  // MAJ axis
  v:=trim(copy(buf,101,8));
  if (v)<>'' then begin
     maj:=strtofloat(v);
     outl.maj:=round(maj*100);
     end
  else begin
     maj:=0;
     outl.maj:=0;
  end;
  // Min axis
  v:=trim(copy(buf,112,8));
  if (v)<>'' then begin
     min:=strtofloat(v);
     outl.min:=round(min*100)
  end else
     outl.min:=round(maj*100);
  // Mag
  v:=trim(copy(buf,57,6));
  if (v)<>'' then outl.mb:=round(strtofloat(v)*100)
                        else outl.mb:=-9990;
  // RV
  v:=trim(copy(buf,132,12));
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
