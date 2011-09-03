program convgpn;

uses
  Forms,
  convgpn1 in 'convgpn1.pas' {Form1};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
