program cdc_client;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, synapse, cu_tcpclient, cdcclient1, LResources
  { you can add units after this };

{$IFDEF WINDOWS}{$R cdc_client.rc}{$ENDIF}

begin
  {$I cdc_client.lrs}
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.

