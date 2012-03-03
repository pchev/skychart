program convocl;

uses
  Forms,
  convocl1 in 'convocl1.pas' {Form1};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
