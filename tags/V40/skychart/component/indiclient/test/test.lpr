program test;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, Sysutils, test1;

{$R *.res}

begin
  {$ifdef USEHEAPTRC}
  DeleteFile('/tmp/testindi_heap.trc');
  SetHeapTraceOutput('/tmp/testindi_heap.trc');
  {$endif}
  RequireDerivedFormResource := True;
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.

