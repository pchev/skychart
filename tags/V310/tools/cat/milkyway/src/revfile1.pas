unit revfile1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TForm1 = class(TForm)
    Edit1: TEdit;
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
var fi,fo:textfile;
    buf:string;
    l:tstringlist;
    i:integer;
begin
l:=tstringlist.Create;
assignfile(fi,edit1.text);
reset(fi);
repeat
  readln(fi,buf);
  l.Add(buf);
until eof(fi);
closefile(fi);
assignfile(fo,edit1.text+'.rev');
rewrite(fo);
for i:=l.Count-1 downto 0 do begin
  writeln(fo,l[i]);
end;
closefile(fo);
end;

end.
