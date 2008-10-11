program convpgc;

uses
  Forms,
  convpgc1 in 'convpgc1.pas' {Form1};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
