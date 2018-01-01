unit idxic1;

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
    ngcRec = Record   ic     : char;
                      id     : array [1..4] of char;
                      s2     : char;
                      typ    : array [1..3] of char;
                      s3     : char;
                      rah    : array [1..2] of char;
                      s4     : char;
                      ram    : array [1..4] of char;
                      s5     : char;
                      s6     : char;
                      decsig : char;
                      decd   : array [1..2] of char;
                      s7     : char;
                      decm   : array [1..2] of char;
                      s8     : char;
                      source : char;
                      s9     : char;
                      s10    : char;
                      cons   : array [1..3] of char;
                      l_dim  : char;
                      dim    : array [1..5] of char;
                      s12    : char;
                      s13    : char;
                      ma     : array [1..4] of char;
                      n_ma   : char;
                      s14    : char;
                      desc   : array [1..50] of char;
                      cr     : char;
              end;
var
  Form1: TForm1;

implementation

{$R *.DFM}
const
maxl = 30000;

var
   fi   : file of ngcrec;
   fo   : file of filidx;
   inp : array[1..maxl] of filidx;
   nl : integer;
   pathi,patho : string;

procedure Lecture;
var i,n,p :integer;
  lin : filidx;
  ngcl : ngcrec;
begin
assignfile(fi,pathi);
Reset(fi);
i:=0;
repeat
  Read(Fi,ngcl);
  if ngcl.ic<>'I' then continue;
  inc(i);
  lin.de := strtofloat(trim(ngcl.decsig)+trim(ngcl.decd))+strtofloat(trim(ngcl.decsig)+trim(ngcl.decm))/60;
  lin.ar := strtofloat(ngcl.rah)+strtofloat(ngcl.ram)/60;
  lin.ar:=15*lin.ar;
  lin.clef := strToInt(ngcl.id);
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
