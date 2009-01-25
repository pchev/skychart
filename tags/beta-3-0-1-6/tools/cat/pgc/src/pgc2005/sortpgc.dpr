program sortpgc;

uses
  Forms,
  sortpgc1 in 'sortpgc1.pas' {Form1};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
