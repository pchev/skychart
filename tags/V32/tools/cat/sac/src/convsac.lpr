program convsac;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, convsac1, LResources
  { you can add units after this };

{$IFDEF WINDOWS}{$R convsac.rc}{$ENDIF}

begin
  {$I convsac.lrs}
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.

