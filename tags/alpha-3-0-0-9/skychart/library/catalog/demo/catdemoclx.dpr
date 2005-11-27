program catdemoclx;

uses
  QForms,
  demo1 in 'demo1.pas' {Form1};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
