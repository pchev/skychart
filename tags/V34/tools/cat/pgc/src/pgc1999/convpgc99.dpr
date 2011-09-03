program convpgc99;

uses
  Forms,
  convpgc991 in 'convpgc991.pas' {Form1};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
