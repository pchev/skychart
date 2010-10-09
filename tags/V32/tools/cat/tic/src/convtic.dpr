program convtic;

uses
  Forms,
  convtic1 in 'convtic1.pas' {Form1};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
