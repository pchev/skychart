program tstdll;

uses
  Forms,
  tstdll1 in 'tstdll1.pas' {Form1};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
