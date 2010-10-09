program idxngc;

uses
  Forms,
  idxngc1 in 'idxngc1.pas' {Form1};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
