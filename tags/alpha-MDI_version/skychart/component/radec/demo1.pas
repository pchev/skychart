unit demo1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Mask, cu_radec;

type
  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    RaDec1: TRaDec;
    RaDec2: TRaDec;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
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
begin
showmessage(floattostr(radec1.value));
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
showmessage(floattostr(radec2.value));
end;

end.
