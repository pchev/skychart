program convgsc;

uses
  Forms,
  convgsc1 in 'convgsc1.pas' {Form1},
  sortgsc1 in 'sortgsc1.pas' {FormSort};

{$R *.RES}

begin
  Application.Initialize;    
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TFormSort, FormSort);
  Application.Run;
end.
