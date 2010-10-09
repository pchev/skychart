program idxpgc;

uses
  Forms,
  idxpgc1 in 'idxpgc1.pas' {Form1};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
