unit ldgsc1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  DB, DBTables, StdCtrls;

type
  TForm1 = class(TForm)
    Button1: TButton;
    Tgsc: TTable;
    Edit1: TEdit;
    Edit2: TEdit;
    astroGSC: TDatabase;
    Label1: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure astroGSCLogin(Database: TDatabase; LoginParams: TStrings);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}
type GSCrec = record gscn: array[1..5] of char;
                     s1  : char;
                     ar  : array[1..9] of char;
                     s2  : char;
                     de  : array[1..9] of char;
                     s3  : char;
                     m   : array[1..5] of char;
                     s4  : char;
                     m_b : array[1..2] of char;
                     s5  : char;
                     cla : char;
                     crlf: array[1..2] of char;
                     end;
var
  f : File of GSCrec;
  lin : GSCrec;

procedure TForm1.Button1Click(Sender: TObject);
var i,n:integer;
    ar,de,m :extended ;
    gscr,gscn :integer;
    nom : string;
begin
gscr:=strToInt(Edit1.Text);
System.Assign(f,'D:\Appli\Astro\Gsc\'+Edit1.Text+'.txt');
System.Reset(f);
with Tgsc do begin
active:=true;
astroGSC.starttransaction;
i:=0;
repeat
  inc(i);
  System.Read(f,lin);
  de := strtofloat(lin.de) ;
  ar := strtofloat(lin.ar)/15.0 ;
  m := strtofloat(lin.m);
  if m=0 then m:=99;
  gscn:=strtoint(lin.gscn);
  AppendRecord([ar,de,m,gscr,gscn]);
  if (i mod 100)=0 then begin
     Edit2.Text:=inttostr(i);
     Form1.Update;
  end;
until system.eof(f);
Edit2.Text:=inttostr(i)+' Commiting';
Form1.Update;
astroGSC.commit;
astroGSC.connected:=false;
System.Close(f);
Edit2.Text:=inttostr(i)+' Commited';
end;
end;

procedure TForm1.astroGSCLogin(Database: TDatabase; LoginParams: TStrings);
begin
  LoginParams.Values['USER NAME'] := 'STARS';
  LoginParams.Values['PASSWORD'] := 'stars';
end;

end.
