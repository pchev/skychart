program idxgcvs;

uses
  Forms,
  idxgcvs1 in 'idxgcvs1.pas' {Form1};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
