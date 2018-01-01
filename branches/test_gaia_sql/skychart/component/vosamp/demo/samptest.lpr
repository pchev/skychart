program samptest;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, samptest1;

{$R *.res}

begin
  {$ifdef USEHEAPTRC}
  SetHeapTraceOutput('/tmp/samptest_heap.trc');
  {$endif}

  RequireDerivedFormResource := True;
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.

