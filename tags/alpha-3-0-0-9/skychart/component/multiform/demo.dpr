program demo;

uses
  Forms,
  demo1 in 'demo1.pas' {Form1},
  demo_child in 'demo_child.pas' {f_child};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(Tf_child, f_child);
  Application.Run;
end.
