unit idxcd1;

interface

uses SkyLib,
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
 filidx = record clef :longint ;
                 ar,de :single;
          end;
 bdrec =  record cat : array[1..2]of char;
                 zones : char;
                 zone : array[1..2]of char;
                 num  : array[1..5]of char;
                 sup  : char;
                 mag  : array[1..4]of char;
                 arh  : array[1..2]of char;
                 arm  : array[1..2]of char;
                 ars  : array[1..4]of char;
                 sde  : char;
                 ded  : array[1..2]of char;
                 dem  : array[1..6]of char;
                 cr   : char;
          end;
var
  Form1: TForm1;

implementation

{$R *.DFM}
const
maxl = 650000;

var
   fi   : file of bdrec;
   fo   : file of filidx;
   inp : array[1..maxl] of filidx;
   nl : integer;
   pathi,patho : string;

procedure Lecture;
var i,n,p :integer;
  lin : filidx;
  buf : string;
  rec : bdrec;
  ar,de:double;
  jd1875,jd2000 : double;
begin
jd1875:=jd(1875,1,1,0);
jd2000:=2451545;
assignfile(fi,pathi+'\cd\cd.dat');
Reset(fi);
i:=0;
repeat
  Read(Fi,rec);
  inc(i);
  if (i mod 1000)=0 then begin form1.edit3.text:=inttostr(i);form1.update;end;
  buf:=trim(rec.zones);
  lin.clef:=strtoint(buf+trim(rec.zone))*100000+strtoint(buf+trim(rec.num));
  buf:=trim(rec.sde);
  de := strtofloat(buf+trim(rec.ded))+strtofloat(buf+trim(rec.dem))/60;
  ar := strtofloat(rec.arh)+strtofloat(rec.arm)/60+strtofloat(rec.ars)/3600;
  Precession(jd1875,jd2000,ar,de);
  lin.ar:=15*ar;
  lin.de:=de;
  inp[i]:=lin;
until eof(Fi);
CloseFile(Fi);
nl:=i;
end;

procedure Ecriture ;
var i,j :integer;
  lin : filidx;
begin
assignfile(fo,patho);
Rewrite(fo);
for i:=1 to nl do begin
  lin:=inp[i];
  Write(Fo,lin);
end;
CloseFile(Fo);
end;

Procedure Tshell(g,d:integer);
var pas,i,j,k : integer;
    lin : filidx;
begin
form1.edit3.text:='Tri';form1.update;
pas:=1;
while pas < ((d-g+1) div 9) do pas :=pas*3+1;
repeat
  for k:=g to pas do begin
    i:=k+pas; if i<d then
    repeat
      lin:=inp[i];
      j:=i-pas;
      while (j>=k+pas) and (inp[j].clef > lin.clef) do begin
        inp[j+pas] := inp[j];
        j:=j-pas ;
      end;
      if inp[k].clef > lin.clef then begin
        j:=k-pas;
        inp[k+pas]:=inp[k];
      end;
      inp[j+pas]:=lin;
      i:=i+pas;
    until i>d;
  end;
  pas:=pas div 3;
until pas=0;
end;

procedure TForm1.Button1Click(Sender: TObject);
var lgnum : integer;
begin
pathi:=edit1.text;
patho:=edit2.text;
  Lecture;
  edit3.text:=inttostr(nl);
  form1.update;
  Tshell(1,nl);
  Ecriture;
edit3.text:='terminé';
end;

end.
