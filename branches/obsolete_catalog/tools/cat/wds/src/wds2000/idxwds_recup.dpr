program idxwds_recup;

uses
  Forms,
  idxwds2 in 'idxwds2.pas' {Form1};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
