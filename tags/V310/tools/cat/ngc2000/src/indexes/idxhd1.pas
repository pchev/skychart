unit idxhd1;

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
var
  Form1: TForm1;

implementation

{$R *.DFM}
const
maxl = 400000;

var
   fi   : textfile;
   fo   : file of filidx;
   inp : array[1..maxl] of filidx;
   nl : integer;
   pathi,patho : string;

procedure Lecture;
var i,n,p :integer;
  lin : filidx;
  rec,buf : string;
  jd1900,jd2000,ar,de : double;
begin
jd1900:=jd(1900,1,1,0);
jd2000:=2451545;
assignfile(fi,pathi+'\hd.dat');
Reset(fi);
i:=0;
repeat
{hd}
  Readln(Fi,rec);
  buf:=trim(copy(rec,1,6));
  if buf='' then continue ;
  inc(i);
  if (i mod 1000)=0 then begin form1.edit3.text:=inttostr(i);form1.update;end;
  lin.clef:=strtoint(buf);
  buf:=trim(copy(rec,24,1));
  de := strtofloat(buf+trim(copy(rec,25,2)))+strtofloat(buf+trim(copy(rec,27,2)))/60;
  ar := strtofloat(copy(rec,19,2))+strtofloat(copy(rec,21,3))/600;
  Precession(jd1900,jd2000,ar,de);
  lin.ar:=15*ar;
  lin.de:=de;
  inp[i]:=lin;
until eof(Fi);
CloseFile(Fi);
assignfile(fi,pathi+'\hde.dat');
Reset(fi);
repeat
{hdec}
  Readln(Fi,rec);
  buf:=trim(copy(rec,1,6));
  if buf='' then continue ;
  inc(i);
  if (i mod 1000)=0 then begin form1.edit3.text:=inttostr(i);form1.update;end;
  lin.clef:=strtoint(buf);
  buf:=trim(copy(rec,33,1));
  de := strtofloat(buf+trim(copy(rec,34,2)))+strtofloat(buf+trim(copy(rec,37,2)))/60+strtofloat(buf+trim(copy(rec,40,4)))/3600;
  ar := strtofloat(copy(rec,21,2))+strtofloat(copy(rec,24,2))/60+strtofloat(copy(rec,27,5))/3600;
  lin.ar:=15*ar;
  lin.de:=de;
  inp[i]:=lin;
until eof(Fi);
nl:=i;
CloseFile(Fi);
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
form1.edit3.text:='Tri '+inttostr(nl);form1.update;
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
