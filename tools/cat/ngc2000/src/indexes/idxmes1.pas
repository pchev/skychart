unit idxmes1;

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
 filidx = record clef :longint ;
                 ar,de :single;
                 end;
var
  Form1: TForm1;

implementation

{$R *.DFM}
const
maxl = 30000;

var
   fi   : TextFile;
   fo   : file of filidx;
   inp : array[1..maxl] of filidx;
   nl : integer;
   pathi,patho : string;

Function sgn(x:Double):Double ;
begin
if x<0 then
   sgn:= -1
else
   sgn:=  1 ;
end ;

procedure Lecture;
var i,n,p :integer;
  lin : filidx;
  rec,buf : string;
begin
assignfile(fi,pathi);
Reset(fi);
i:=0;
repeat
  inc(i);
  Readln(Fi,rec);
  p:=pos(',',rec)-2;
  buf:=copy(rec,2,p);
  lin.clef:=strtoint(trim(buf));
  for n:=1 to 4 do rec:=copy(rec,pos(',',rec)+1,length(rec));
  p:=pos('h',rec);
  buf:=copy(rec,1,p-1);
  lin.ar:=strtofloat(trim(buf));
  rec:=copy(rec,p+1,length(rec));
  p:=pos('m',rec);
  buf:=copy(rec,1,p-1);
  lin.ar:=15*(lin.ar+strtofloat(trim(buf))/60);
  rec:=copy(rec,pos(',',rec)+1,length(rec));
  p:=pos('°',rec);
  buf:=copy(rec,1,p-1);
  lin.de:=strtofloat(trim(buf));
  rec:=copy(rec,p+1,length(rec));
  p:=pos('''',rec);
  buf:=copy(rec,1,p-1);
  lin.de:=lin.de+sgn(lin.de)*strtofloat(trim(buf))/60;
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
  Tshell(1,nl);
  Ecriture;
edit3.text:='terminé';
end;

end.
