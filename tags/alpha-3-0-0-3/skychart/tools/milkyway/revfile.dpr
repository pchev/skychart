program revfile;

uses
  Forms,
  revfile1 in 'revfile1.pas' {Form1};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
