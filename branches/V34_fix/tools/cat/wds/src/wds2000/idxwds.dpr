program idxwds;

uses
  Forms,
  idxwds1 in 'idxwds1.pas' {Form1};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
