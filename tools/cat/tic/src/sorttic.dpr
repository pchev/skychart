program sorttic;

uses
  Forms,
  sorttic1 in 'sorttic1.pas' {Form1};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
