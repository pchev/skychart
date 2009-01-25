program convgcv;

uses
  Forms,
  convgcv1 in 'convgcv1.pas' {Form1};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
