unit ldtycho1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  DB, DBTables, StdCtrls;

type
  TForm1 = class(TForm)
    Button1: TButton;
    Ttyc: TTable;
    Edit1: TEdit;
    Edit2: TEdit;
    astrotyc: TDatabase;
    procedure Button1Click(Sender: TObject);
    procedure astrotycLogin(Database: TDatabase; LoginParams: TStrings);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}
type Tycrec = record s1  : array[1..2] of char;
                     id1 : array[1..4] of char;
                     id2 : array[1..6] of char;
                     id3 : array[1..2] of char;
                     s2  : array[1..37] of char;
                     ar  : array[1..12] of char;
                     s3  : char;
                     de  : array[1..12] of char;
                     s4  : array[1..141] of char;
                     bt  : array[1..6] of char;
                     s5  : array[1..7] of char;
                     vt  : array [1..6] of char;
                     s6  : array[1..9] of char;
                     b_v : array[1..6] of char;
                     s7  : array[1..58] of char;
                     hd  : array[1..6] of char;
                     s8  : array[1..35] of char;
                     cr  : char;
                     end;
var
  f : File of tycrec;
  lin : tycrec;

procedure TForm1.Button1Click(Sender: TObject);
var i,n:integer;
    ar,de,vt,bt,b_v : extended ;
    id1,id2,id3,hd :integer;
    nom : string;
begin
nom:='tyc_main.dat';
Edit1.Text:=nom;
Form1.Update;
System.Assign(f,'E:\'+nom);
System.Reset(f);
with Ttyc do begin
active:=true;
astrotyc.starttransaction;
i:=0;
repeat
  System.Read(f,lin);
  inc(i);
  de := strtofloat(lin.de);
  ar := strtofloat(lin.ar);
  ar:=ar/15.0;
  if trim(lin.bt)>'' then bt:=strtofloat(lin.bt)
                     else bt:=99;
  if trim(lin.vt)>'' then vt:=strtofloat(lin.vt)
                     else vt:=99;
  if trim(lin.b_v)>'' then b_v:=strtofloat(lin.b_v)
                      else b_v:=99;
  if trim(lin.hd)>'' then hd:=strtoint(lin.hd)
                     else hd:=0;
  id1:=strtoint(lin.id1);
  id2:=strtoint(lin.id2);
  id3:=strtoint(lin.id3);
  AppendRecord([ar,de,bt,vt,b_v,id1,id2,id3,hd]);
  if (i mod 1000)=0 then begin
     Edit2.Text:=inttostr(i);
     Form1.Update;
  end;
  if (i mod 20000)=0 then begin
     Edit2.Text:=inttostr(i)+' Commit';
     Form1.Update;
     astrotyc.commit;
     astrotyc.connected:=false;
     Edit2.Text:=inttostr(i)+' Commited';
     Form1.Update;
     active:=true;
     astrotyc.starttransaction;
  end;
until system.eof(f);
Edit2.Text:=inttostr(i);
Form1.Update;
astrotyc.commit;
astrotyc.connected:=false;
System.Close(f);
Edit2.Text:=inttostr(i)+' Commited';
end;
end;

procedure TForm1.astrotycLogin(Database: TDatabase; LoginParams: TStrings);
begin
  LoginParams.Values['USER NAME'] := 'STARS';
  LoginParams.Values['PASSWORD'] := 'stars';
end;

end.
