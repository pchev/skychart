program idxcd;

uses
  Forms,
  idxcd1 in 'idxcd1.pas' {Form1};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
