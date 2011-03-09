program ldbsc5;

uses
  Forms,
  ldbsc51 in 'ldbsc51.pas' {Form1};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
