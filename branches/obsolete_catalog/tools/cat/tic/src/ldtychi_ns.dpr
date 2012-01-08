program ldtychi_ns;

uses
  Forms,
  ldtychi_ns1 in 'ldtychi_ns1.pas' {Form1};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
