unit sortgsc1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  DB, DBTables, StdCtrls;

type
  TFormSort = class(TForm)
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
{ clef = m }
            filbin = record
                     ar,de : longint;
                     gscn: word;
                     pe,clef,me :smallint;
                     mb,cl : shortint;
                     mult : char;
                     end;
var
  FormSort: TFormSort;

Procedure SortFile(fi : string);

implementation

{$R *.DFM}
const
maxl = 30000;
dirlst : array [0..23,1..5] of char =
 ('S8230','S7500','S6730','S6000','S5230','S4500','S3730','S3000','S2230','S1500','S0730','S0000',
 'N0000','N0730','N1500','N2230','N3000','N3730','N4500','N5230','N6000','N6730','N7500','N8230');

var
   fi,fo   : file of filbin;
   inp : array[1..maxl] of filbin;
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

procedure Lecture(fil : string) ;
var i :integer;
  lin : filbin;
begin
assignfile(fi,fil);
Reset(fi);
i:=0;
repeat
  inc(i);
  Read(Fi,lin);
  inp[i]:=lin;
until eof(Fi);
nl:=i;
CloseFile(Fi);
end;

procedure Ecriture(fil : string) ;
var i,j :integer;
  lin : filbin;
begin
assignfile(fo,fil);
Rewrite(fo);
for i:=1 to nl do begin
  { sort asc }
  j:=i;
  lin:=inp[j];
  Write(Fo,lin);
end;
CloseFile(Fo);
end;

Procedure Tshell(g,d:integer);
var pas,i,j,k : integer;
    lin : filbin;
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

procedure TFormSort.Button1Click(Sender: TObject);
var i,rc : integer;
    dir : string;
    SearchRec: TSearchRec;
begin
pathi:=edit1.text;
patho:=edit2.text;
for i:=0 to 23 do begin
  dir := dirlst[i];
  Edit3.Text:=dir;
  FormSort.update;
  Rc := FindFirst(pathi+'\'+dir+'\*.dat', 0, SearchRec);
  while rc=0 do begin;
    Lecture(pathi+'\'+dir+'\'+searchrec.name);
    Tshell(1,nl);
    Ecriture(patho+'\'+dir+'\'+searchrec.name);
    rc:=findnext(searchrec);
  end;
  findclose(searchrec);
end;
Edit3.Text:='Terminé';
FormSort.update;
end;

Procedure SortFile(fi : string);
begin
Lecture(fi);
Tshell(1,nl);
Ecriture(fi);
end;

end.
