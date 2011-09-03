program sortrc3;

uses
  Forms,
  sortc31 in 'sortc31.pas' {Form1};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
