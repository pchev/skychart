program idxsao;

uses
  Forms,
  idxsao1 in 'idxsao1.pas' {Form1};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
