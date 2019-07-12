unit indiblobclient;

{
Copyright (C) 2014 Patrick Chevalley

http://www.ap-i.net
pch@ap-i.net

This program is free software; you can redistribute it and/or
modify it under the terms of the GNU General Public License
as published by the Free Software Foundation; either version 2

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software
Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
}
{
   Pascal Indi client library freely inspired by libindiclient.
   See: http://www.indilib.org/

   Same as indibaseclient but specialized to receive blob
   using a big buffer size.
}


{$mode objfpc}{$H+}

interface

uses
  {$ifdef UNIX}
  netdb, dnssend,
  {$endif}
  indiapi, indibasedevice, indicom, blcksock, synsock, XMLRead, DOM, contnrs,
  Forms, Classes, SysUtils;

type
  TTCPclient = class(TSynaClient)
  private
    FSock: TTCPBlockSocket;
  public
    constructor Create;
    destructor Destroy; override;
    function Connect: boolean;
    procedure Disconnect;
    function GetErrorDesc: string;
  published
    property Sock: TTCPBlockSocket read FSock;
  end;

  TIndiBlobClient = class(TThread)
  private
    FinitProps: boolean;
    FTargetHost, FTargetPort, FErrorDesc, FRecvData, Fsendbuffer: string;
    FTimeout: integer;
    FConnected: boolean;
    FProtocolTrace: boolean;
    FProtocolRawFile, FProtocolTraceFile, FProtocolErrorFile: string;
    FPTlog, FPTraw, FPTerr: textfile;
    Fdevices: TObjectList;
    FwatchDevices: TStringList;
    FMissedFrameCount: cardinal;
    FlockBlobEvent: boolean;
    FServerConnected: TNotifyEvent;
    FServerDisconnected: TNotifyEvent;
    FIndiDeviceEvent: TIndiDeviceEvent;
    FIndiDeleteDeviceEvent: TIndiDeviceEvent;
    FIndiPropertyEvent: TIndiPropertyEvent;
    FIndiDeletePropertyEvent: TIndiPropertyEvent;
    FIndiBlobEvent: TIndiBlobEvent;
    SyncindiDev: Basedevice;
    SyncindiProp: IndiProperty;
    FIndiMessageEvent: TIndiMessageEvent;
    {$ifdef withCriticalsection}
    SendCriticalSection: TRTLCriticalSection;
    {$endif}
    procedure IndiDeviceEvent(dp: Basedevice);
    procedure IndiDeleteDeviceEvent(dp: Basedevice);
    procedure IndiMessageEvent(mp: IMessage);
    procedure IndiPropertyEvent(indiProp: IndiProperty);
    procedure IndiDeletePropertyEvent(indiProp: IndiProperty);
    procedure IndiBlobEvent(bp: IBLOB);
    procedure SyncServerConnected;
    procedure SyncServerDisonnected;
    procedure SyncDeviceEvent;
    procedure SyncDeleteDeviceEvent;
    procedure SyncPropertyEvent;
    procedure SyncDeletePropertyEvent;
    procedure ASyncMessageEvent(Data: PtrInt);
    procedure ASyncBlobEvent(Data: PtrInt);
    function findDev(root: TDOMNode; createifnotexist: boolean;
      out errmsg: string): BaseDevice;
    function findDev(root: TDOMNode; out errmsg: string): BaseDevice;
    function ProcessData(s: TMemoryStream): boolean;
    procedure ProcessDataThread(s: TMemoryStream);
    procedure ProcessDataAsync(Data: PtrInt);
    procedure OpenProtocolTrace(fnraw, fnlog, fnerr: string);
    procedure CloseProtocolTrace;
    procedure WriteProtocolTrace(buf: string);
    procedure WriteProtocolRaw(buf: string);
    procedure WriteProtocolError(buf: string);
  public
    TcpClient: TTcpclient;
    constructor Create;
    destructor Destroy; override;
    procedure RefreshProps;
    procedure Execute; override;
    procedure SetServer(host, port: string);
    procedure watchDevice(devicename: string);
    procedure setBLOBMode(blobH: BLOBHandling; dev: string; prop: string = '');
    procedure ConnectServer;
    procedure DisconnectServer;
    procedure Send(const Value: string);
    property devices: TObjectList read Fdevices;
    function getDevice(deviceName: string): Basedevice;
    procedure deleteDevice(deviceName: string; out errmsg: string);
    property Timeout: integer read FTimeout write FTimeout;
    property ProtocolTrace: boolean read FProtocolTrace write FProtocolTrace;
    property ProtocolRawFile: string read FProtocolRawFile write FProtocolRawFile;
    property ProtocolTraceFile: string read FProtocolTraceFile write FProtocolTraceFile;
    property ProtocolErrorFile: string read FProtocolErrorFile write FProtocolErrorFile;
    property Terminated;
    property Connected: boolean read FConnected;
    property ErrorDesc: string read FErrorDesc;
    property RecvData: string read FRecvData;
    property MissedFrameCount: cardinal read FMissedFrameCount;
    property onServerConnected: TNotifyEvent read FServerConnected
      write FServerConnected;
    property onServerDisconnected: TNotifyEvent
      read FServerDisconnected write FServerDisconnected;
    property onNewDevice: TIndiDeviceEvent read FIndiDeviceEvent write FIndiDeviceEvent;
    property onDeleteDevice: TIndiDeviceEvent
      read FIndiDeleteDeviceEvent write FIndiDeleteDeviceEvent;
    property onNewProperty: TIndiPropertyEvent
      read FIndiPropertyEvent write FIndiPropertyEvent;
    property onDeleteProperty: TIndiPropertyEvent
      read FIndiDeletePropertyEvent write FIndiDeletePropertyEvent;
    property onNewBlob: TIndiBlobEvent read FIndiBlobEvent write FIndiBlobEvent;
    property onNewMessage: TIndiMessageEvent read FIndiMessageEvent write FIndiMessageEvent;
  end;

implementation

///////////////////////  TTCPclient //////////////////////////

constructor TTCPclient.Create;
begin
  inherited Create;
  FSock := TTCPBlockSocket.Create;
end;

destructor TTCPclient.Destroy;
begin
  try
    FSock.Free;
    inherited Destroy;
  except
  end;
end;

function TTCPclient.Connect: boolean;
begin
  FSock.CloseSocket;
  FSock.LineBuffer := '';
  FSock.Bind(FIPInterface, cAnyPort);
  FSock.Connect(FTargetHost, FTargetPort);
  Result := FSock.LastError = 0;
end;

procedure TTCPclient.Disconnect;
begin
  FSock.CloseSocket;
end;

function TTCPclient.GetErrorDesc: string;
begin
  Result := IntToStr(FSock.LastError) + ' ' + FSock.GetErrorDesc(FSock.LastError);
end;

///////////////////////  TIndiBlobClient //////////////////////////

constructor TIndiBlobClient.Create;
begin
  // start suspended to let time to the main thread to set the parameters
  inherited Create(True);
  FTargetHost := 'localhost';
  FTargetPort := '7624';
{$ifdef darwin}
  FTimeout := 400;
{$else}
  FTimeout := 200;
{$endif}
  FConnected := False;
  FProtocolTrace := False;
  FProtocolRawFile := '';
  FProtocolTraceFile := '';
  FProtocolErrorFile := '';
  FreeOnTerminate := True;
  FlockBlobEvent := False;
  FMissedFrameCount := 0;
  Ftrace := False;  // for debuging only
  Fdevices := TObjectList.Create;
  FwatchDevices := TStringList.Create;
end;

destructor TIndiBlobClient.Destroy;
begin
  if Ftrace then
    writeln('TIndiBlobClient.Destroy');
  Fdevices.Free;
  FwatchDevices.Free;
{$ifndef mswindows}
  inherited Destroy;
{$endif}
end;

procedure TIndiBlobClient.OpenProtocolTrace(fnraw, fnlog, fnerr: string);
begin
  try
    if not FProtocolTrace then
      exit;
    if fnraw <> '' then
      fnraw := expandfilename(fnraw);
    if fnlog <> '' then
      fnlog := expandfilename(fnlog);
    if fnerr <> '' then
      fnerr := expandfilename(fnerr);
    Filemode := 2;
    assignfile(FPTraw, fnraw);
    rewrite(FPTraw);
    writeln(FPTraw, FormatDateTime('yyyy"-"mm"-"dd"T"hh":"nn":"ss.zzz', Now) +
      '  Start trace');
    assignfile(FPTlog, fnlog);
    rewrite(FPTlog);
    writeln(FPTlog, FormatDateTime('yyyy"-"mm"-"dd"T"hh":"nn":"ss.zzz', Now) +
      '  Start trace');
    assignfile(FPTerr, fnerr);
    rewrite(FPTerr);
    writeln(FPTerr, FormatDateTime('yyyy"-"mm"-"dd"T"hh":"nn":"ss.zzz', Now) +
      '  Start trace');
  except
{$I-}
    FProtocolTrace := False;
    CloseFile(FPTlog);
    CloseFile(FPTraw);
    CloseFile(FPTerr);
    IOResult;
{$I+}
  end;
end;

procedure TIndiBlobClient.CloseProtocolTrace;
begin
  if not FProtocolTrace then
    exit;
  try
    FProtocolTrace := False;
    CloseFile(FPTlog);
    CloseFile(FPTraw);
    CloseFile(FPTerr);
  except
 {$I-}
    IOResult;
 {$I+}
  end;
end;

procedure TIndiBlobClient.WriteProtocolTrace(buf: string);
begin
  try
    if FProtocolTrace then begin
       WriteLn(FPTlog, FormatDateTime('yyyy"-"mm"-"dd"T"hh":"nn":"ss.zzz', Now) + '  ' + buf);
    end;
  except
{$I-}
    FProtocolTrace := False;
    CloseFile(FPTlog);
    CloseFile(FPTraw);
    CloseFile(FPTerr);
    IOResult;
{$I+}
  end;
end;

procedure TIndiBlobClient.WriteProtocolRaw(buf: string);
begin
  try
    if FProtocolTrace then begin
       WriteLn(FPTraw, FormatDateTime('yyyy"-"mm"-"dd"T"hh":"nn":"ss.zzz', Now) + '  ' + buf);
    end;
  except
{$I-}
    FProtocolTrace := False;
    CloseFile(FPTlog);
    CloseFile(FPTraw);
    CloseFile(FPTerr);
    IOResult;
{$I+}
  end;
end;

procedure TIndiBlobClient.WriteProtocolError(buf: string);
begin
  try
    if FProtocolTrace then begin
      WriteLn(FPTerr, FormatDateTime('yyyy"-"mm"-"dd"T"hh":"nn":"ss.zzz', Now) + '  ' + buf);
    end;
  except
{$I-}
    FProtocolTrace := False;
    CloseFile(FPTlog);
    CloseFile(FPTraw);
    CloseFile(FPTerr);
    IOResult;
{$I+}
  end;
end;

procedure TIndiBlobClient.Execute;
const
  buffersize = 10240;
var
  buf: string;
  init: boolean;
  buffer: array[0..buffersize-1] of char;
  tbuf: array[0..1024] of char;
  s: TMemoryStream;
  i, n, level, c, tl: integer;
  closing: boolean;
  lastc: char;

  function ReadElement(newc: char): boolean; inline;
  begin
    Result := False;
    case newc of
      chr(0):
      begin
        s.Clear;
        s.WriteBuffer('<INDIMSG>', 9);
        level := 0;
      end;
      '/':
      begin
        s.Write(newc, 1);
        if (lastc = '<') then
        begin
          Dec(level);
          closing := True;
        end;
      end;
      '<':
      begin
        Inc(level);
        closing := False;
        s.Write(newc, 1);
      end;
      '>':
      begin
        s.Write(newc, 1);
        if (lastc = '/') or closing then
        begin
          Dec(level);
          if level = 0 then
          begin
            s.WriteBuffer('</INDIMSG>', 10);
            Result := True;
          end;
        end;
      end;
      else
      begin
        s.Write(newc, 1);
      end;
    end;
    lastc := newc;
  end;

begin
  try
    tcpclient := TTCPClient.Create;
    s := TMemoryStream.Create;
    try
      OpenProtocolTrace(FProtocolRawFile, FProtocolTraceFile, FProtocolErrorFile);
      {$ifdef withCriticalsection}
      InitCriticalSection(SendCriticalSection);
      {$endif}
      init := True;
      FinitProps := False;
      if FProtocolTrace then
        WriteProtocolTrace('Connect host=' + FTargetHost + ' port=' +
          FTargetPort + ' timeout=' + IntToStr(2*FTimeout));
      tcpclient.TargetHost := FTargetHost;
      tcpclient.TargetPort := FTargetPort;
      tcpclient.Timeout := 2*FTimeout;
      FConnected := tcpclient.Connect;
      if FProtocolTrace then
        WriteProtocolTrace('Connection result=' + tcpclient.GetErrorDesc);
      if FConnected then
      begin
        RefreshProps;
        // main loop
        buf := '';
        level := 0;
        s.WriteBuffer('<INDIMSG>', 9);
        c := 0;
        repeat
          if terminated then
            break;
          n := tcpclient.Sock.RecvBufferEx(@buffer, buffersize, 2*FTimeout);
          if (tcpclient.Sock.lastError <> 0) and
            (tcpclient.Sock.lastError <> WSAETIMEDOUT) then
            break;
          if n > 0 then
          begin
            if FProtocolTrace then
              WriteProtocolRaw('Receive buffer size=' + IntToStr(n) +
                crlf + Copy(buffer,1,n));
            for i := 0 to n - 1 do
            begin
              if ReadElement(buffer[i]) then
              begin
                if FProtocolTrace then
                begin
                  s.Position := 0;
                  tl := s.Read(tbuf, 1024);
                  if tl<=1024 then
                    WriteProtocolTrace('Process data=' + StringReplace(
                      StringReplace(copy(tbuf, 1, tl), cr, '', [rfReplaceAll]),
                      lf, '', [rfReplaceAll]))
                  else
                    WriteProtocolTrace('Process data=' + StringReplace(
                      StringReplace(copy(tbuf, 1, tl), cr, '', [rfReplaceAll]),
                      lf, '', [rfReplaceAll]) + '...');
                end;
                ProcessDataThread(s);
                s := TMemoryStream.Create;
                s.WriteBuffer('<INDIMSG>', 9);
              end;
            end;
          end;
          if init then
          begin
            Inc(c);
            if c > 50 then
              FinitProps := True;  // no response? continue
            if FinitProps then
            begin
              if FProtocolTrace then
                WriteProtocolTrace('Initialized');
              if assigned(FServerConnected) then
                Synchronize(@SyncServerConnected);
              init := False;
            end;
          end;
          try
          {$ifdef withCriticalsection}
          EnterCriticalsection(SendCriticalSection);
          {$endif}
          try
            buf := Fsendbuffer;
            Fsendbuffer := '';
          finally
            {$ifdef withCriticalsection}
            LeaveCriticalsection(SendCriticalSection);
           {$endif}
          end;
          except
          end;
          if buf <> '' then
          begin
            if FProtocolTrace then
              WriteProtocolTrace('Send buffer=' + buf);
            tcpclient.Sock.SendString(buf);
            if tcpclient.Sock.lastError <> 0 then
              break;
          end;
        until False;
      end;
    finally
      if FProtocolTrace then
        WriteProtocolTrace('Disconnect, socket status=' + tcpclient.Sock.LastErrorDesc);
      FConnected := False;
      terminate;
      s.Free;
      tcpclient.Disconnect;
      tcpclient.Free;
      {$ifdef withCriticalsection}
      DoneCriticalsection(SendCriticalSection);
      {$endif}
      if assigned(FServerDisconnected) then
        Synchronize(@SyncServerDisonnected);
      if FProtocolTrace then
        WriteProtocolTrace('Indi client stopped');
      CloseProtocolTrace;
    end;
  except
    CloseProtocolTrace;
  end;
end;

procedure TIndiBlobClient.Send(const Value: string);
begin
  if Value > '' then
  begin
    try
   {$ifdef withCriticalsection}
    EnterCriticalsection(SendCriticalSection);
   {$endif}
    try
      Fsendbuffer := Fsendbuffer + Value + crlf;
    finally
      {$ifdef withCriticalsection}
      LeaveCriticalsection(SendCriticalSection);
      {$endif}
    end;
    except
    end;
  end;
end;

function TIndiBlobClient.findDev(root: TDOMNode; out errmsg: string): BaseDevice;
var
  i: integer;
  buf: string;
begin
  Result := nil;
  if not FConnected then exit;
  buf := GetNodeValue(GetAttrib(root, 'device'));
  errmsg := 'Device not found ' + buf;
  try
  for i := 0 to Fdevices.Count - 1 do
  begin
    if BaseDevice(Fdevices[i]).getDeviceName = buf then
    begin
      Result := BaseDevice(Fdevices[i]);
      errmsg := '';
      break;
    end;
  end;
  except
    result:=nil;
  end;
end;

function TIndiBlobClient.findDev(root: TDOMNode; createifnotexist: boolean;
  out errmsg: string): BaseDevice;
var
  buf: string;
begin
  try
  Result:=nil;
  if not FConnected then exit;
  Result := findDev(root, errmsg);
  if (Result = nil) and createifnotexist then
  begin
    buf := GetNodeValue(GetAttrib(root, 'device'));
    if buf <> '' then
    begin
      errmsg := '';
      Result := BaseDevice.Create;
      Result.setDeviceName(buf);
      Result.onNewMessage := @IndiMessageEvent;
      Result.onNewProperty := @IndiPropertyEvent;
      Result.onDeleteProperty := @IndiDeletePropertyEvent;
      Result.onNewBlob := @IndiBlobEvent;
      Fdevices.Add(Result);
      if assigned(FIndiDeviceEvent) then
        IndiDeviceEvent(Result);
    end
    else
    begin
      errmsg := 'No device name';
    end;
  end;
  except
    result:=nil;
  end;
end;

function TIndiBlobClient.getDevice(deviceName: string): Basedevice;
var
  i: integer;
begin
  try
  for i := 0 to Fdevices.Count - 1 do
    if (deviceName = BaseDevice(Fdevices[i]).getDeviceName) then
      exit(BaseDevice(Fdevices[i]));
  exit(nil);
  except
    result:=nil;
  end;
end;

procedure TIndiBlobClient.deleteDevice(deviceName: string; out errmsg: string);
var
  dp: BaseDevice;
  i: integer;
begin
  errmsg := 'Device ' + deviceName + ' not found!';
  for i := 0 to Fdevices.Count - 1 do
    if (deviceName = BaseDevice(Fdevices[i]).getDeviceName) then
    begin
      dp := (BaseDevice(Fdevices[i]));
      if assigned(FIndiDeleteDeviceEvent) then
        IndiDeleteDeviceEvent(dp);
      Fdevices.Delete(i);
      errmsg := '';
      break;
    end;
end;

procedure TIndiBlobClient.ProcessDataThread(s: TMemoryStream);
begin
  if not terminated then
    Application.QueueAsyncCall(@ProcessDataAsync, PtrInt(s))
  else
    s.Free;
end;

procedure TIndiBlobClient.ProcessDataAsync(Data: PtrInt);
var mp:IMessage;
begin
  try
    if not terminated then
    begin
      ProcessData(TMemoryStream(Data));
    end
    else
      TMemoryStream(Data).Free;
  except
  end;
end;

function TIndiBlobClient.ProcessData(s: TMemoryStream): boolean;
var
  Doc: TXMLDocument;
  Node: TDOMNode;
  dp: BaseDevice;
  isBlob: boolean;
  ebuf: array[0..1024] of char;
  n: integer;
  buf, errmsg, dname, pname: string;
begin
  s.Position := 0;
  Result := True;
  try
    ReadXMLFile(Doc, s);
  except
    on E: Exception do
    begin
      if FProtocolTrace then
      begin
        WriteProtocolError('Read XML error:' + e.Message);
        s.Position := 0;
        n := s.Read(ebuf, 1024);
        WriteProtocolError('Error data=' + trim(
          StringReplace(StringReplace(copy(ebuf, 1, n), cr, '', [rfReplaceAll]),
          lf, '', [rfReplaceAll])) + '...');
      end;
      Result := False;
      s.Free;
      exit;
    end;
  end;
  try
    Node := Doc.DocumentElement.FirstChild;
    while Node <> nil do
    begin
      if terminated then
        break;
      dp := findDev(Node, True, errmsg);
      if dp=nil then begin
        Node := Node.NextSibling;
        continue;
      end;
      if FProtocolTrace and (errmsg <> '') then
        WriteProtocolError('FindDev error: ' + errmsg);
      if Node.NodeName = 'message' then
      begin
        dp.checkMessage(Node);
      end;
      if Node.NodeName = 'delProperty' then
      begin
        dname := GetNodeValue(GetAttrib(Node, 'device'));
        if dname = '' then
          dname := 'Unnamed_device';
        pname := GetNodeValue(GetAttrib(Node, 'name'));
        if pname = '' then
        begin
          deleteDevice(dname, errmsg);
          if FProtocolTrace and (errmsg <> '') then
            WriteProtocolError('deleteDevice error: ' + errmsg);
        end
        else
        begin
          dp.removeProperty(pname, errmsg);
          if FProtocolTrace and (errmsg <> '') then
            WriteProtocolError('removeProperty error: ' + errmsg);
        end;
      end;
      buf := copy(GetNodeName(Node), 1, 3);
      if buf = 'set' then
      begin
        isBlob := copy(GetNodeName(Node), 1, 13) = 'setBLOBVector';
        if FlockBlobEvent and isBlob then
        begin  // do not decode blob for nothing
          Inc(FMissedFrameCount);
          if Ftrace then
            writeln('missed frames: ' + IntToStr(FMissedFrameCount));
        end
        else
        begin
          FinitProps := True;
          dp.setValue(Node, errmsg);
          if FProtocolTrace and (errmsg <> '') then
            WriteProtocolError('setValue error: ' + errmsg);
        end;
      end
      else if buf = 'def' then
      begin
        dp.buildProp(Node, errmsg);
        if FProtocolTrace and (errmsg <> '') then
          WriteProtocolError('buildProp error: ' + errmsg);
      end;
      Node := Node.NextSibling;
    end;
  finally
    Doc.Free;
    s.Free;
  end;
end;

procedure TIndiBlobClient.SetServer(host, port: string);
{$ifdef UNIX}
var
  H: THostEntry;
  ok: boolean;
  buf: string;
  dns:TDNSSend;
  resp:TStringList;
  i:integer;

  function FirstWord(var Line: string): string;
  var
    I, J: integer;
  const
    Whitespace = [' ', #9];
  begin
    I := 1;
    while (I <= Length(Line)) and (Line[i] in Whitespace) do
      Inc(I);
    J := I;
    while (J <= Length(Line)) and not (Line[J] in WhiteSpace) do
      Inc(j);
    Result := Copy(Line, I, J - I);
  end;

{$endif}
begin
  {$ifdef UNIX}
  try
  if (pos('.', host) = 0) and (not ResolveHostByName(host, H)) then
  begin
    // try to add the default domain
    buf := FirstWord(DefaultDomainList);
    buf := host + '.' + buf;
    ok := ResolveHostByName(buf, H);
    if ok then
      host := buf;
  end;
  if (pos('.local', host) > 0) and (not ResolveHostByName(host, H)) then
  begin
    // try Avahi/Bonjour mDNS
    dns:=TDNSSend.Create;
    resp:=TStringList.Create;
    try
    dns.TargetHost:='224.0.0.251'; // multicast
    dns.TargetPort:='5353';        // Avahi/Bonjour port
    ok:=dns.DNSQuery(host,QTYPE_A,resp);
    if ok and (resp.Count>0) then
       host := resp[0];
    finally
      resp.Free;
      dns.Free;
    end;
  end;
  except
  end;
  {$endif}
  FTargetHost := host;
  FTargetPort := port;
end;

procedure TIndiBlobClient.watchDevice(devicename: string);
begin
  FwatchDevices.Add(devicename);
end;

procedure TIndiBlobClient.setBLOBMode(blobH: BLOBHandling; dev: string;
  prop: string = '');
var
  buf: string;
begin
  if (prop <> '') then
    buf := '<enableBLOB device="' + dev + '" name="' + prop + '">'
  else
    buf := '<enableBLOB device="' + dev + '">';
  case blobH of
    B_NEVER:
      buf := buf + 'Never</enableBLOB>';
    B_ALSO:
      buf := buf + 'Also</enableBLOB>';
    B_ONLY:
      buf := buf + 'Only</enableBLOB>';
  end;
  send(buf);
end;

procedure TIndiBlobClient.ConnectServer;
begin
  Start;
end;

procedure TIndiBlobClient.DisconnectServer;
begin
  Terminate;
end;

procedure TIndiBlobClient.RefreshProps;
var
  i: integer;
begin
  if FwatchDevices.Count = 0 then
    Send('<getProperties version="' + INDIV + '"/>')
  else
    for i := 0 to FwatchDevices.Count - 1 do
      Send('<getProperties version="' + INDIV + '" device="' + FwatchDevices[i] + '"/>');
end;

procedure TIndiBlobClient.SyncServerConnected;
begin
  if assigned(FServerConnected) then
    FServerConnected(self);
end;

procedure TIndiBlobClient.SyncServerDisonnected;
begin
  if assigned(FServerDisconnected) then
    FServerDisconnected(self);
end;

procedure TIndiBlobClient.SyncPropertyEvent;
begin
  if assigned(FIndiPropertyEvent) then
    FIndiPropertyEvent(SyncindiProp);
end;

procedure TIndiBlobClient.SyncDeletePropertyEvent;
begin
  if assigned(FIndiDeletePropertyEvent) then
    FIndiDeletePropertyEvent(SyncindiProp);
end;

procedure TIndiBlobClient.IndiDeviceEvent(dp: Basedevice);
begin
  SyncindiDev := dp;
  // Device event must be processed synchronously
  Synchronize(@SyncDeviceEvent);
end;

procedure TIndiBlobClient.SyncDeviceEvent;
begin
  if assigned(FIndiDeviceEvent) then
    FIndiDeviceEvent(SyncindiDev);
end;

procedure TIndiBlobClient.IndiDeleteDeviceEvent(dp: Basedevice);
begin
  SyncindiDev := dp;
  // Device event must be processed synchronously
  Synchronize(@SyncDeleteDeviceEvent);
end;

procedure TIndiBlobClient.SyncDeleteDeviceEvent;
begin
  if assigned(FIndiDeleteDeviceEvent) then
    FIndiDeleteDeviceEvent(SyncindiDev);
end;

procedure TIndiBlobClient.IndiPropertyEvent(indiProp: IndiProperty);
begin
  SyncindiProp := indiProp;
  Synchronize(@SyncPropertyEvent);
end;

procedure TIndiBlobClient.IndiDeletePropertyEvent(indiProp: IndiProperty);
begin
  SyncindiProp := indiProp;
  Synchronize(@SyncDeletePropertyEvent);
end;

procedure TIndiBlobClient.IndiBlobEvent(bp: IBLOB);
begin
  if FlockBlobEvent then
  begin
    Inc(FMissedFrameCount);
    if Ftrace then
      writeln('missed frames: ' + IntToStr(FMissedFrameCount));
  end
  else
  begin
    FlockBlobEvent := True; // drop extra frames until we are ready
    Application.QueueAsyncCall(@AsyncBlobEvent, PtrInt(bp));
  end;
end;

procedure TIndiBlobClient.ASyncBlobEvent(Data: PtrInt);
begin
  try
    if not terminated then
    begin
      if assigned(FIndiBlobEvent) then
        FIndiBlobEvent(IBLOB(Data));
    end;
  finally
    // blob processing terminated, we can process next
    FlockBlobEvent := False;
  end;
end;

procedure TIndiBlobClient.IndiMessageEvent(mp: IMessage);
begin
  try
  Application.QueueAsyncCall(@ASyncMessageEvent, PtrInt(mp));
  except
  end;
end;


procedure TIndiBlobClient.ASyncMessageEvent(Data: PtrInt);
begin
  try
  if assigned(FIndiMessageEvent) then
    FIndiMessageEvent(IMessage(data))
  else
    IMessage(data).Free;
  except
  end;
end;
end.
