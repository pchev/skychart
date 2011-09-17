unit idxpgc1;

{$MODE Delphi}

interface

uses
  LCLIntf, LCLType, LMessages, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
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
 filidx = record clef :longint ;
                 ar,de :single;
          end;
var
  Form1: TForm1;

implementation

{$R *.lfm}
const
maxl = 5000000; // max number of pgc objects ( 3356319 by 2011)

var
   fi   : textfile;
   fo   : file of filidx;
   inp : array[1..maxl] of filidx;
   nl : integer;
   pathi,patho : string;

procedure Lecture;
var i,n,p :integer;
  lin : filidx;
  buf : string;
  ar,de:double;
begin
assignfile(fi,pathi);
Reset(fi);
Readln(Fi,buf);
Readln(Fi,buf);
i:=0;
repeat
  Readln(Fi,buf);
  if copy(buf,1,1)='(' then break;
  inc(i);
  if (i mod 1000)=0 then begin form1.edit3.text:=inttostr(i);form1.update;end;
  // PGC
  lin.clef:=strtoint(copy(buf,1,8));
  // RA DEC
  lin.de := strtofloat(copy(buf,43,11));
  lin.ar := 15*strtofloat(copy(buf,30,10));
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
form1.edit3.text:='Sorting...';form1.update;
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
edit3.text:='End.';
end;

end.