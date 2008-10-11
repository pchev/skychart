unit ldtychi_ns1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  DB, DBTables, StdCtrls;

type
  TForm1 = class(TForm)
    Button1: TButton;
    Ttic: TTable;
    Edit1: TEdit;
    Edit2: TEdit;
    astrotic: TDatabase;
    procedure Button1Click(Sender: TObject);
    procedure astroticLogin(Database: TDatabase; LoginParams: TStrings);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}
type Tycrec = record gscr: array[1..4] of char;
                     s1  : char;
                     gscn: array[1..5] of char;
                     ar  : array[1..10] of char;
                     de  : array[1..9] of char;
                     s2  : char;
                     s3  : array[1..8] of char;
                     mb  : array[1..5] of char;
                     s4  : array [1..4] of char;
                     mv  : array[1..5] of char;
                     s6  : char;
                     s7  : array[1..15] of char;
                     fl16: char;
                     s8  : array[1..11] of char;
                     cr  : char;
                     end;
var
  f : File of tycrec;
  lin : tycrec;

procedure TForm1.Button1Click(Sender: TObject);
var i,n:integer;
    ar,de :extended ;
    gscr,gscn,mb,mv :integer;
    nom : string;
begin
for n:=1 to 4 do begin
nom:='tic'+trim(inttostr(n));
Edit1.Text:=nom;
Form1.Update;
System.Assign(f,'E:\Catalogues\tycho_in\'+nom);
System.Reset(f);
with Ttic do begin
active:=true;
astrotic.starttransaction;
i:=0;
repeat
  System.Read(f,lin);
  if strtoint(lin.fl16)>0 then begin
  inc(i);
  de := strtofloat(lin.de)/360000.0 - 90.0 ;
  ar := strtofloat(lin.ar)/5400000.0 ;
  mb := strtoint(lin.mb);
  if mb=0 then mb:=9900;
  mv := strtoint(lin.mv);
  if mv=0 then mv:=9900;
  gscr:=strtoint(lin.gscr);
  gscn:=strtoint(lin.gscn);
  InsertRecord([ar,de,mb,mv,gscr,gscn,'1']);
  if (i mod 1000)=0 then begin
     Edit2.Text:=inttostr(i);
     Form1.Update;
  end;
  if (i mod 20000)=0 then begin
     Edit2.Text:=inttostr(i)+' Commit';
     Form1.Update;
     astrotic.commit;
     astrotic.connected:=false;
     Edit2.Text:=inttostr(i)+' Commited';
     Form1.Update;
     active:=true;
     astrotic.starttransaction;
  end;
  end;
until system.eof(f);
Edit2.Text:=inttostr(i);
Form1.Update;
astrotic.commit;
astrotic.connected:=false;
System.Close(f);
Edit2.Text:=inttostr(i)+' Commited';
end;
end;
end;

procedure TForm1.astroticLogin(Database: TDatabase; LoginParams: TStrings);
begin
  LoginParams.Values['USER NAME'] := 'STARS';
  LoginParams.Values['PASSWORD'] := 'stars';
end;

end.
