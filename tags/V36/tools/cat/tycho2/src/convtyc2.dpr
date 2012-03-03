program convtyc2;

uses
  Forms,
  convtyc21 in 'convtyc21.pas' {Form1};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
