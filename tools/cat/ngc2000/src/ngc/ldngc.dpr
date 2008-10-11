program ldngc;

uses
  Forms,
  ldngc1 in 'ldngc1.pas' {Form1};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
