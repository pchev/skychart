program cdcicon;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms
  { you can add units after this }, pu_tray, pu_clock, cdccatalog, enhedit,
  Printer4Lazarus, satxy, libsql, pu_calendar,
  CDCjdcalendar, zoomimage;

{$R *.res}

begin
  Application.Initialize;
  Application.ShowMainForm:=false;
  Application.CreateForm(Tf_tray, f_tray);
  Application.CreateForm(Tf_clock, f_clock);
  f_tray.Init;
  Application.Run;
end.

