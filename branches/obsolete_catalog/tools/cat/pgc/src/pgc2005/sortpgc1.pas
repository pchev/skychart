unit sortpgc1;

interface

uses
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
{ clef = maj }
filbin = record
                pgc,ar,de,hrv   : Longint;
                nom   : array [1..16] of char;
                typ   : array [1..4] of char;
                pa    : byte;
                clef,min,mb : smallint;
                end;

var
  Form1: TForm1;

implementation

{$R *.DFM}
const
maxl = 100000;

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

procedure Lecture(lgnum:integer) ;
var i :integer;
  lin : filbin;
begin
assignfile(fi,pathi+'\'+padzeros(inttostr(lgnum),2)+'.dat');
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

procedure Ecriture(lgnum:integer) ;
var i,j :integer;
  lin : filbin;
begin
assignfile(fo,patho+'\'+padzeros(inttostr(lgnum),2)+'.dat');
Rewrite(fo);
for i:=1 to nl do begin
  { sort desc }
  j:=nl-i+1;
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

procedure TForm1.Button1Click(Sender: TObject);
var lgnum : integer;
begin
pathi:=edit1.text;
patho:=edit2.text;
for lgnum:=1 to 50 do begin
  Edit3.Text:=inttostr(lgnum);
  Form1.update;
  Lecture(lgnum);
  Tshell(1,nl);
  Ecriture(lgnum);
end;
end;

end.
