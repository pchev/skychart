program convgcm;

uses
  Forms,
  convgcm1 in 'convgcm1.pas' {Form1};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
