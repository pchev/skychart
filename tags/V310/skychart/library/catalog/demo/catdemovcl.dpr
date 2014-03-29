program catdemovcl;

uses
  Forms,
  demovcl1 in 'demovcl1.pas' {Form1};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
