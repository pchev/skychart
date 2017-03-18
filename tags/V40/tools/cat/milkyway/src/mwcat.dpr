program mwcat;

uses
  QForms,
  mwcat1 in 'mwcat1.pas' {Form1};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
