program idxsac;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, LResources, idxsac1
  { you can add units after this };

{$IFDEF WINDOWS}{$R idxsac.rc}{$ENDIF}

begin
  {$I idxsac.lrs}
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.

