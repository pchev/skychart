program mkposxy_clx;

uses
  QForms,
  mkposxy1_clx in 'mkposxy1_clx.pas' {Form1};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
