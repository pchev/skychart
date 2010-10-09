program tstdde;

uses
  Forms,
  tstdde1 in 'tstdde1.pas' {Form1},
  Sky_DDE_Util in 'Sky_DDE_Util.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
