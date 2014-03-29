unit constbUnit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons;

type
  TForm1 = class(TForm)
    BitBtn1: TBitBtn;
    procedure BitBtn1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.BitBtn1Click(Sender: TObject);
type tconstb = record ar,de : Single; end;
var fi : textfile;
    fo : file of tconstb;
    buf,c,cp,a,d,s : string;
    r : tconstb;
begin
cp:='';
assignfile(fi,'bound_20.dat');
reset(fi);
assignfile(fo,'constb.dat');
rewrite(fo);
repeat
  readln(fi,buf);
  a:=copy(buf,1,10);
  s:=copy(buf,12,1);
  d:=copy(buf,13,10);
  c:=copy(buf,24,4);
  r.ar:=strtofloat(a);
  r.de:=strtofloat(d)*strtofloat(s+'1');
  if c<>cp then r.ar:=-r.ar;
  write(fo,r);
  cp:=c;
until eof(fi);
closefile(fi);
closefile(fo);
form1.close;
end;

end.
