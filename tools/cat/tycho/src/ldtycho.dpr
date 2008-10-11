program ldtycho;

uses
  Forms,
  ldtycho1 in 'ldtycho1.pas' {Form1};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
