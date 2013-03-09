program idxgc;

uses
  Forms,
  idxgc1 in 'idxgc1.pas' {Form1};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
