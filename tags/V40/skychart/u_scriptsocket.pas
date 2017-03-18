unit u_scriptsocket;

{$mode objfpc}{$H+}

interface

uses  blcksock, synsock,
  Classes, SysUtils;

type
TScriptSocket = Class (TObject)
   private
     FSock: TTCPBlockSocket;
     FTcpip_opened: boolean;
     FTcp_timout: integer;
   public
     Constructor Create;
     Destructor Destroy; override;
     function Connect(ipaddr,port:string;Timeout:integer=100): boolean;
     function Disconnect: boolean;
     Function ReadCount(var buf : string; var count : integer) : boolean;
     Function Read(var buf : string; termchar:string = CRLF) : boolean;
     Function Write(var buf : string; var count : integer) : boolean;
     Procedure PurgeBuffer;
     property Tcpip_opened: boolean read FTcpip_opened;
end;

implementation

Constructor TScriptSocket.Create;
begin
  Inherited Create;
  FTcpip_opened:=false;
  FTcp_timout:=100;
end;

Destructor TScriptSocket.Destroy;
begin
  if FSock<>nil then FreeAndNil(FSock);
  Inherited Destroy;
end;

function TScriptSocket.Connect(ipaddr,port:string;Timeout:integer=100): boolean;
begin
  FSock:=TTCPBlockSocket.Create;
  FSock.Connect(ipaddr,port);
  result:=FSock.LastError=0;
  FTcpip_opened:=result;
  FTcp_timout:=Timeout;
  if FTcpip_opened then FSock.SetTimeout(FTcp_timout);
end;

function TScriptSocket.Disconnect: boolean;
begin
  if FSock<>nil then FreeAndNil(FSock);
  FTcpip_opened:=false;
  result:=true;
end;

Function TScriptSocket.ReadCount(var buf : string; var count : integer) : boolean;
begin
result:=false;
if FTcpip_opened then begin
  buf:=FSock.RecvBufferStr(count,FTcp_timout);
  result:=(FSock.LastError=0)or(FSock.LastError=WSAETIMEDOUT);
end;
end;

Function TScriptSocket.Read(var buf : string; termchar:string = CRLF) : boolean;
begin
result:=false;
if termchar='' then termchar:=CRLF;
if FTcpip_opened then begin
  buf:=FSock.RecvTerminated(FTcp_timout,termchar);
  result:=(FSock.LastError=0);
end;
end;

Function TScriptSocket.Write(var buf : string; var count : integer) : boolean;
begin
result:=false;
if FTcpip_opened then begin
  Fsock.SendString(buf+CRLF);
  result:=(FSock.LastError=0);
end;
end;

Procedure TScriptSocket.PurgeBuffer;
begin
if FTcpip_opened then begin
  FSock.Purge;
end;
end;

end.

