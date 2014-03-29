program convlbn;

uses
  Forms,
  convlbn1 in 'convlbn1.pas' {Form1};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
