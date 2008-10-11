program convwds;

uses
  Forms,
  convwds1 in 'convwds1.pas' {Form1};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
