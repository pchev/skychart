unit cu_sampserver;

{$mode objfpc}{$H+}
interface

uses
  Classes, blcksock, sockets, Synautil, SysUtils;

type

  TProcessNotification = function(data:TMemoryStream):boolean of object;

  TTCPHttpDaemon = class(TThread)
  private
    Sock:TTCPBlockSocket;
    Flistenport: integer;
    FProcessNotification:TProcessNotification;
  public
    Constructor Create;
    Destructor Destroy; override;
    procedure Execute; override;
    property ListenPort : integer read Flistenport;
    property onProcessNotification:TProcessNotification read FProcessNotification write FProcessNotification;
  end;

  TTCPHttpThrd = class(TThread)
  private
    Sock:TTCPBlockSocket;
    FProcessNotification:TProcessNotification;
    ok: boolean;
  public
    Headers: TStringList;
    InputData, OutputData: TMemoryStream;
    Constructor Create (hsock:tSocket);
    Destructor Destroy; override;
    procedure Execute; override;
    function ProcessHttpRequest(Request, URI: string): integer;
    procedure ProcessNotification;
    property onProcessNotification:TProcessNotification read FProcessNotification write FProcessNotification;
  end;


implementation

{ TTCPHttpDaemon }

Constructor TTCPHttpDaemon.Create;
begin
  inherited create(false);
  sock:=TTCPBlockSocket.create;
  FreeOnTerminate:=true;
end;

Destructor TTCPHttpDaemon.Destroy;
begin
  Sock.free;
  inherited Destroy;
end;

procedure TTCPHttpDaemon.Execute;
var
  ClientSock:TSocket;
  TCPHttpThrd:TTCPHttpThrd;
begin
  with sock do
    begin
      CreateSocket;
      setLinger(true,10000);
      bind('127.0.0.1','1500');
      listen;
      GetSins;
      Flistenport:=sock.GetLocalSinPort;
      repeat
        if terminated then break;
        if canread(1000) then
          begin
            ClientSock:=accept;
            if lastError=0 then begin
                TCPHttpThrd:=TTCPHttpThrd.create(ClientSock);
                TCPHttpThrd.onProcessNotification:=FProcessNotification;
            end;
          end;
      until false;
    end;
end;

{ TTCPHttpThrd }

Constructor TTCPHttpThrd.Create(Hsock:TSocket);
begin
  sock:=TTCPBlockSocket.create;
  Headers := TStringList.Create;
  InputData := TMemoryStream.Create;
  OutputData := TMemoryStream.Create;
  Sock.socket:=HSock;
  FreeOnTerminate:=true;
  Priority:=tpNormal;
  inherited create(false);
end;

Destructor TTCPHttpThrd.Destroy;
begin
  Sock.free;
  Headers.Free;
  InputData.Free;
  OutputData.Free;
  inherited Destroy;
end;

procedure TTCPHttpThrd.Execute;
var
  timeout: integer;
  s: string;
  method, uri, protocol: string;
  size: integer;
  x, n: integer;
  resultcode: integer;
  close: boolean;
begin
  timeout := 120000;
  repeat
    //read request line
    s := sock.RecvString(timeout);
    if sock.lasterror <> 0 then
      Exit;
    if s = '' then
      Exit;
    method := fetch(s, ' ');
    if (s = '') or (method = '') then
      Exit;
    uri := fetch(s, ' ');
    if uri = '' then
      Exit;
    protocol := fetch(s, ' ');
    headers.Clear;
    size := -1;
    close := false;
    //read request headers
    if protocol <> '' then
    begin
      if pos('HTTP/', protocol) <> 1 then
        Exit;
      if pos('HTTP/1.1', protocol) <> 1 then
        close := true;
      repeat
        s := sock.RecvString(Timeout);
        if sock.lasterror <> 0 then
          Exit;
        if s <> '' then
          Headers.add(s);
        if Pos('CONTENT-LENGTH:', Uppercase(s)) = 1 then
          Size := StrToIntDef(SeparateRight(s, ' '), -1);
        if Pos('CONNECTION: CLOSE', Uppercase(s)) = 1 then
          close := true;
      until s = '';
    end;
    //recv document...
    InputData.Clear;
    if size >= 0 then
    begin
      InputData.SetSize(Size);
      x := Sock.RecvBufferEx(InputData.Memory, Size, Timeout);
      InputData.SetSize(x);
      if sock.lasterror <> 0 then
        Exit;
    end;
    OutputData.Clear;
    ResultCode := ProcessHttpRequest(method, uri);
    sock.SendString(protocol + ' ' + IntTostr(ResultCode) + CRLF);
    if protocol <> '' then
    begin
      headers.Add('Content-length: ' + IntTostr(OutputData.Size));
      if close then
        headers.Add('Connection: close');
      headers.Add('Date: ' + Rfc822DateTime(now));
      headers.Add('Server: Synapse HTTP server demo');
      headers.Add('');
      for n := 0 to headers.count - 1 do
        sock.sendstring(headers[n] + CRLF);
    end;
    if sock.lasterror <> 0 then
      Exit;
    Sock.SendBuffer(OutputData.Memory, OutputData.Size);
    if close then
      Break;
  until Sock.LastError <> 0;
end;

function TTCPHttpThrd.ProcessHttpRequest(Request, URI: string): integer;
var
  l: TStringlist;
begin
//sample of precessing HTTP request:
// InputData is uploaded document, headers is stringlist with request headers.
// Request is type of request and URI is URI of request
// OutputData is document with reply, headers is stringlist with reply headers.
// Result is result code

  result := 404;
  if request = 'GET' then
  begin
    headers.Clear;
    headers.Add('Content-type: Text/Html');
    l := TStringList.Create;
    try
      l.Add('<html>');
      l.Add('<head></head>');
      l.Add('<body>');
      l.Add('Request Uri: ' + uri);
      l.Add('<br>');
      l.Add('404');
      l.Add('</body>');
      l.Add('</html>');
      l.SaveToStream(OutputData);
    finally
      l.free;
    end;
    Result := 404;
  end
  else   if request = 'POST' then
  begin
    Synchronize(@ProcessNotification);
    headers.Clear;
    headers.Add('Content-type: text/xml');
    l := TStringList.Create;
    try
      l.Add('<?xml version=''1.0'' encoding=''UTF-8''?>');
      l.Add('<methodResponse>');
      l.Add('<params>');
      l.Add('<param>');
      l.Add('<value></value>');
      l.Add('</param>');
      l.Add('</params>');
      l.Add('</methodResponse>');
      l.SaveToStream(OutputData);
    finally
      l.free;
    end;
    if ok then Result := 200
          else Result := 501;
  end
end;

Procedure TTCPHttpThrd.ProcessNotification;
begin
  ok:=false;
  if Assigned(FProcessNotification) then
     ok:=FProcessNotification(InputData);
end;

end.