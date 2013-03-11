program tstdll;

{$MODE Delphi}

uses
  Forms, Interfaces,
  tstdll1 in 'tstdll1.pas' {Form1};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
