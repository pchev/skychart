program idxhd;

uses
  Forms,
  idxhd1 in 'idxhd1.pas' {Form1};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
