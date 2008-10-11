program sorttyc;

uses
  Forms,
  sorttyc1 in 'sorttyc1.pas' {Form1};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
