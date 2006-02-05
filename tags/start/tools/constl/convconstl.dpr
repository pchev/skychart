program convconstl;

uses
  Forms,
  convconstlUnit1 in 'convconstlUnit1.pas' {Form1};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
