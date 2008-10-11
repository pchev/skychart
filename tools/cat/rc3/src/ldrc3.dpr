program ldrc3;

uses
  Forms,
  ldrc31 in 'ldrc31.pas' {Form1};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
