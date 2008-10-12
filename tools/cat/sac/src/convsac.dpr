program convsac;

uses
  Forms,
  convsac1 in 'convsac1.pas' {Form1};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
