unit idxwds2;

interface

uses  catalogues,
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  DB, DBTables, StdCtrls;

type
  TForm1 = class(TForm)
    Button1: TButton;
    Edit2: TEdit;
    Edit3: TEdit;
    Edit1: TEdit;
    procedure Button1Click(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;
Type
 filidx = record clef : array[1..12] of char;
                 ar,de :single;
                 end;
var
  Form1: TForm1;

implementation

{$R *.DFM}
const
maxl = 300000;

var
   fi   : file of filidx;
   fo   : file of filidx;
   inp : array[1..maxl] of filidx;
   nl : integer;
   pathi,patho : string;

procedure Lecture ;
var i,j :integer;
  lin : filidx;
begin
assignfile(fi,pathi);
Reset(fi);
i:=0;
repeat
  Read(Fi,lin);
  inc(i);
  inp[i]:=lin;
until eof(fi);
nl:=i;
CloseFile(Fi);
end;

{procedure Lecture;
var i,j,n,p :integer;
  lin : filidx;
  buf : string;
 x1,x2,y1,y2 : double;
    wdsrok : boolean;
    rec : wdsrec;
    ok : boolean;
const bl : array[1..12]of char =(' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ');
begin
x1 := 0;
x2 := 24;
y1 := -89.9997;
y2 := 89.9997;
SetWdsPath(pathi);
OpenWDS(x1,x2,y1,y2,WDSrok);
if not WDSrok then begin ok:=false; exit; end;
ok := false;
i:=0;
repeat
  ReadWDS(rec,WDSrok);
  if WDSrok then begin
  inc(i);
  move(bl,lin.clef,sizeof(lin.clef));
  buf:=uppercase(stringreplace(rec.id,' ','',[rfReplaceAll]));
  for j:=1 to length(buf) do begin
    lin.clef[j]:=buf[j];
  end;
  lin.ar:=rec.ar/100000;
  lin.de:=rec.de/100000;
  inp[i]:=lin;
  end;
until not wdsrok;
nl:=i;
CloseWDS;
end;}

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
  edit3.text:=inttostr(nl);
  form1.update;
  Tshell(1,nl);
  Ecriture;
edit3.text:='terminé';
end;

end.
