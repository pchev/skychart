program convrc3;

uses
  Forms,
  convrc31 in 'convrc31.pas' {Form1};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
