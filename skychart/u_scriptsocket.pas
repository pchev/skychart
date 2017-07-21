unit u_scriptsocket;

{$mode objfpc}{$H+}

interface

uses
  blcksock, synsock,
  Classes, SysUtils;

type
  TScriptSocket = class(TObject)
  private
    FSock: TTCPBlockSocket;
    FTcpip_opened: boolean;
    FTcp_timout: integer;
  public
    constructor Create;
    destructor Destroy; override;
    function Connect(ipaddr, port: string; Timeout: integer = 100): boolean;
    function Disconnect: boolean;
    function ReadCount(var buf: string; var Count: integer): boolean;
    function Read(var buf: string; termchar: string = CRLF): boolean;
    function Write(var buf: string; var Count: integer): boolean;
    procedure PurgeBuffer;
    property Tcpip_opened: boolean read FTcpip_opened;
  end;

implementation

constructor TScriptSocket.Create;
begin
  inherited Create;
  FTcpip_opened := False;
  FTcp_timout := 100;
end;

destructor TScriptSocket.Destroy;
begin
  if FSock <> nil then
    FreeAndNil(FSock);
  inherited Destroy;
end;

function TScriptSocket.Connect(ipaddr, port: string; Timeout: integer = 100): boolean;
begin
  FSock := TTCPBlockSocket.Create;
  FSock.Connect(ipaddr, port);
  Result := FSock.LastError = 0;
  FTcpip_opened := Result;
  FTcp_timout := Timeout;
  if FTcpip_opened then
    FSock.SetTimeout(FTcp_timout);
end;

function TScriptSocket.Disconnect: boolean;
begin
  if FSock <> nil then
    FreeAndNil(FSock);
  FTcpip_opened := False;
  Result := True;
end;

function TScriptSocket.ReadCount(var buf: string; var Count: integer): boolean;
begin
  Result := False;
  if FTcpip_opened then
  begin
    buf := FSock.RecvBufferStr(Count, FTcp_timout);
    Result := (FSock.LastError = 0) or (FSock.LastError = WSAETIMEDOUT);
  end;
end;

function TScriptSocket.Read(var buf: string; termchar: string = CRLF): boolean;
begin
  Result := False;
  if termchar = '' then
    termchar := CRLF;
  if FTcpip_opened then
  begin
    buf := FSock.RecvTerminated(FTcp_timout, termchar);
    Result := (FSock.LastError = 0);
  end;
end;

function TScriptSocket.Write(var buf: string; var Count: integer): boolean;
begin
  Result := False;
  if FTcpip_opened then
  begin
    Fsock.SendString(buf + CRLF);
    Result := (FSock.LastError = 0);
  end;
end;

procedure TScriptSocket.PurgeBuffer;
begin
  if FTcpip_opened then
  begin
    FSock.Purge;
  end;
end;

end.
