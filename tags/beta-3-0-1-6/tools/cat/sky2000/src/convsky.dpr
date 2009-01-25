program convsky;

uses
  Forms,
  convsky1 in 'convsky1.pas' {Form1},
  UnixFile in 'UnixFile.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
