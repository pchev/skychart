program idxic;

uses
  Forms,
  idxic1 in 'idxic1.pas' {Form1};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
