program idxmes;

uses
  Forms,
  idxmes1 in 'idxmes1.pas' {Form1};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
