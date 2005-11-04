program demoX;

uses
  QForms,
  demoX1 in 'demoX1.pas' {Form1},
  demoX_child in 'demoX_child.pas' {f_child};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(Tf_child, f_child);
  Application.Run;
end.
