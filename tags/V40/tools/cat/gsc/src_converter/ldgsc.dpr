program ldgsc;

uses
  Forms,
  ldgsc1 in 'ldgsc1.pas' {Form1};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
