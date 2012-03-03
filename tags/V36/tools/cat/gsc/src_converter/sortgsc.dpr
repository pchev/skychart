program sortgsc;

uses
  Forms,
  sortgsc1 in 'sortgsc1.pas' {Form1};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
