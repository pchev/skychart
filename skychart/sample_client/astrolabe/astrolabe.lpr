program astrolabe;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, synapse, cu_tcpclient, astrolabe1;

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(Tf_astrolabe, f_astrolabe);
  Application.Run;
end.

