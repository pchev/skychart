program ldtychi;

uses
  Forms,
  ldtychi1 in 'ldtychi1.pas' {Form1};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
