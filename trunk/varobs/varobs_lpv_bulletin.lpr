program varobs_lpv_bulletin;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms
  { you can add units after this }, aavsob1;

{$ifndef unix}
{$R manifest.res}
{$endif}

begin
  Application.Title:='lpv_bulletin';
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.

