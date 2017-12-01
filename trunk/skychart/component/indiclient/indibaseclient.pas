unit indibaseclient;

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
}

{$mode objfpc}{$H+}

interface

uses
  {$ifdef UNIX}
  netdb,
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

  TDataBuffer = class(TObject)
  public
    dataptr: PtrInt;
  end;

  TProcessDataProc = procedure(s: TMemoryStream) of object;

  TProcessData = class(TThread)
  private
    dataqueue: TObjectList;
    FProcessData: TProcessDataProc;
    function getCount: integer;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Add(Data: TMemoryStream);
    procedure Execute; override;
    property Count: integer read getCount;
    property onProcessData: TProcessDataProc read FProcessData write FProcessData;
  end;

  TIndiBaseClient = class(TThread)
  private
    FinitProps: boolean;
    FTargetHost, FTargetPort, FErrorDesc, FRecvData, Fsendbuffer: string;
    FTimeout: integer;
    FConnected: boolean;
    FProtocolTrace: boolean;
    FProtocolTraceFile, FProtocolErrorFile: string;
    FPTlog, FPTerr: textfile;
    Fdevices: TObjectList;
    FwatchDevices: TStringList;
    FMissedFrameCount: cardinal;
    FlockBlobEvent: boolean;
    FServerConnected: TNotifyEvent;
    FServerDisconnected: TNotifyEvent;
    FIndiDeviceEvent: TIndiDeviceEvent;
    FIndiDeleteDeviceEvent: TIndiDeviceEvent;
    FIndiMessageEvent: TIndiMessageEvent;
    FIndiPropertyEvent: TIndiPropertyEvent;
    FIndiDeletePropertyEvent: TIndiPropertyEvent;
    FIndiNumberEvent: TIndiNumberEvent;
    FIndiTextEvent: TIndiTextEvent;
    FIndiSwitchEvent: TIndiSwitchEvent;
    FIndiLightEvent: TIndiLightEvent;
    FIndiBlobEvent: TIndiBlobEvent;
    SyncindiDev: Basedevice;
    SyncindiProp: IndiProperty;
    {$ifdef withCriticalsection}
    SendCriticalSection: TRTLCriticalSection;
    {$endif}
    FProcessData: TProcessData;
    procedure IndiDeviceEvent(dp: Basedevice);
    procedure IndiDeleteDeviceEvent(dp: Basedevice);
    procedure IndiMessageEvent(mp: IMessage);
    procedure IndiPropertyEvent(indiProp: IndiProperty);
    procedure IndiDeletePropertyEvent(indiProp: IndiProperty);
    procedure IndiNumberEvent(nvp: INumberVectorProperty);
    procedure IndiTextEvent(tvp: ITextVectorProperty);
    procedure IndiSwitchEvent(svp: ISwitchVectorProperty);
    procedure IndiLightEvent(lvp: ILightVectorProperty);
    procedure IndiBlobEvent(bp: IBLOB);
    procedure SyncServerConnected;
    procedure SyncServerDisonnected;
    procedure SyncDeviceEvent;
    procedure SyncDeleteDeviceEvent;
    procedure SyncPropertyEvent;
    procedure SyncDeletePropertyEvent;
    procedure ASyncNumberEvent(Data: PtrInt);
    procedure ASyncTextEvent(Data: PtrInt);
    procedure ASyncSwitchEvent(Data: PtrInt);
    procedure ASyncLightEvent(Data: PtrInt);
    procedure ASyncBlobEvent(Data: PtrInt);
    procedure ASyncMessageEvent(Data: PtrInt);
    function findDev(root: TDOMNode; createifnotexist: boolean;
      out errmsg: string): BaseDevice;
    function findDev(root: TDOMNode; out errmsg: string): BaseDevice;
    function ProcessData(s: TMemoryStream): boolean;
    procedure ProcessDataThread(s: TMemoryStream);
    procedure ProcessDataAsync(Data: PtrInt);
    procedure setDriverConnection(status: boolean; deviceName: string);
    procedure OpenProtocolTrace(fnlog, fnerr: string);
    procedure CloseProtocolTrace;
    procedure WriteProtocolTrace(buf: string);
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
    procedure connectDevice(deviceName: string);
    procedure disconnectDevice(deviceName: string);
    procedure Send(const Value: string);
    property devices: TObjectList read Fdevices;
    function getDevice(deviceName: string): Basedevice;
    procedure deleteDevice(deviceName: string; out errmsg: string);
    procedure sendNewNumber(nvp: INumberVectorProperty);
    procedure sendNewText(tvp: ITextVectorProperty);
    procedure sendNewSwitch(svp: ISwitchVectorProperty);
    function WaitBusy(nvp: INumberVectorProperty; timeout: integer = 5000;
      minwait: integer = 0): boolean;
    function WaitBusy(tvp: ITextVectorProperty; timeout: integer = 5000;
      minwait: integer = 0): boolean;
    function WaitBusy(svp: ISwitchVectorProperty; timeout: integer = 5000;
      minwait: integer = 0): boolean;
    property Timeout: integer read FTimeout write FTimeout;
    property ProtocolTrace: boolean read FProtocolTrace write FProtocolTrace;
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
    property onNewMessage: TIndiMessageEvent
      read FIndiMessageEvent write FIndiMessageEvent;
    property onNewProperty: TIndiPropertyEvent
      read FIndiPropertyEvent write FIndiPropertyEvent;
    property onDeleteProperty: TIndiPropertyEvent
      read FIndiDeletePropertyEvent write FIndiDeletePropertyEvent;
    property onNewNumber: TIndiNumberEvent read FIndiNumberEvent write FIndiNumberEvent;
    property onNewText: TIndiTextEvent read FIndiTextEvent write FIndiTextEvent;
    property onNewSwitch: TIndiSwitchEvent read FIndiSwitchEvent write FIndiSwitchEvent;
    property onNewLight: TIndiLightEvent read FIndiLightEvent write FIndiLightEvent;
    property onNewBlob: TIndiBlobEvent read FIndiBlobEvent write FIndiBlobEvent;
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
  Result := FSock.GetErrorDesc(FSock.LastError);
end;

///////////////////////  TProcessData //////////////////////////

constructor TProcessData.Create;
begin
  inherited Create(False);
  FreeOnTerminate := True;
  dataqueue := TObjectList.Create;
end;

destructor TProcessData.Destroy;
begin
  dataqueue.Free;
  {$ifndef mswindows}
  inherited Destroy;
  {$endif}
end;

procedure TProcessData.Add(Data: TMemoryStream);
var
  buf: TDataBuffer;
begin
try
  buf := TDataBuffer.Create;
  buf.dataptr := PtrInt(Data);
  try
    dataqueue.Add(buf);
  finally
  end;
except
end;
end;

function TProcessData.getCount: integer;
begin
  Result := dataqueue.Count;
end;

procedure TProcessData.Execute;
var
  s: TMemoryStream;
begin
  while not Terminated do
  begin
    sleep(100);
    while dataqueue.Count > 0 do
    begin
      try
        s:=TMemoryStream.Create;
        s.Position:=0;
        TMemoryStream(TDataBuffer(dataqueue.Items[0]).dataptr).Position:=0;
        s.CopyFrom(TMemoryStream(TDataBuffer(dataqueue.Items[0]).dataptr),TMemoryStream(TDataBuffer(dataqueue.Items[0]).dataptr).Size);
        TMemoryStream(TDataBuffer(dataqueue.Items[0]).dataptr).Free;
        dataqueue.Delete(0);
        FProcessData(s);
      except
      end;
    end;
  end;
end;

///////////////////////  TIndiBaseClient //////////////////////////

constructor TIndiBaseClient.Create;
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
  FProtocolTraceFile := '';
  FProtocolErrorFile := '';
  FreeOnTerminate := True;
  FlockBlobEvent := False;
  FMissedFrameCount := 0;
  Ftrace := False;  // for debuging only
  Fdevices := TObjectList.Create;
  FwatchDevices := TStringList.Create;
  FProcessData := TProcessData.Create;
  FProcessData.onProcessData := @ProcessDataThread;
end;

destructor TIndiBaseClient.Destroy;
begin
  if Ftrace then
    writeln('TIndiBaseClient.Destroy');
  FProcessData.Terminate;
  Fdevices.Free;
  FwatchDevices.Free;
{$ifndef mswindows}
  inherited Destroy;
{$endif}
end;

procedure TIndiBaseClient.OpenProtocolTrace(fnlog, fnerr: string);
begin
  try
    if not FProtocolTrace then
      exit;
    if fnlog <> '' then
      fnlog := expandfilename(fnlog);
    if fnerr <> '' then
      fnerr := expandfilename(fnerr);
    Filemode := 2;
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
    CloseFile(FPTerr);
    IOResult;
{$I+}
  end;
end;

procedure TIndiBaseClient.CloseProtocolTrace;
begin
  if not FProtocolTrace then
    exit;
  try
    FProtocolTrace := False;
    CloseFile(FPTlog);
    CloseFile(FPTerr);
  except
 {$I-}
    IOResult;
 {$I+}
  end;
end;

procedure TIndiBaseClient.WriteProtocolTrace(buf: string);
begin
  try
    if not FProtocolTrace then
      exit;
    WriteLn(FPTlog, FormatDateTime('yyyy"-"mm"-"dd"T"hh":"nn":"ss.zzz', Now) +
      '  ' + buf);
  except
{$I-}
    FProtocolTrace := False;
    CloseFile(FPTlog);
    CloseFile(FPTerr);
    IOResult;
{$I+}
  end;
end;

procedure TIndiBaseClient.WriteProtocolError(buf: string);
begin
  try
    if not FProtocolTrace then
      exit;
    WriteLn(FPTerr, FormatDateTime('yyyy"-"mm"-"dd"T"hh":"nn":"ss.zzz', Now) +
      '  ' + buf);
  except
{$I-}
    FProtocolTrace := False;
    CloseFile(FPTlog);
    CloseFile(FPTerr);
    IOResult;
{$I+}
  end;
end;

procedure TIndiBaseClient.Execute;
const
  buffersize = 8192;
var
  buf: string;
  init: boolean;
  buffer: array[0..buffersize] of char;
  tbuf: array[0..120] of char;
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
    try
      OpenProtocolTrace(FProtocolTraceFile, FProtocolErrorFile);
      {$ifdef withCriticalsection}
      InitCriticalSection(SendCriticalSection);
      {$endif}
      init := True;
      FinitProps := False;
      if FProtocolTrace then
        WriteProtocolTrace('Connect host=' + FTargetHost + ' port=' +
          FTargetPort + ' timeout=' + IntToStr(FTimeout));
      tcpclient.TargetHost := FTargetHost;
      tcpclient.TargetPort := FTargetPort;
      tcpclient.Timeout := FTimeout;
      FConnected := tcpclient.Connect;
      if FProtocolTrace then
        WriteProtocolTrace('Connection result=' + tcpclient.GetErrorDesc);
      if FConnected then
      begin
        RefreshProps;
        // main loop
        buf := '';
        level := 0;
        s := TMemoryStream.Create;
        s.WriteBuffer('<INDIMSG>', 9);
        c := 0;
        repeat
          if terminated then
            break;
          n := tcpclient.Sock.RecvBufferEx(@buffer, buffersize, FTimeout);
          if (tcpclient.Sock.lastError <> 0) and
            (tcpclient.Sock.lastError <> WSAETIMEDOUT) then
            break;
          if n > 0 then
          begin
            if FProtocolTrace then
              WriteProtocolTrace('Receive buffer size=' + IntToStr(n) +
                ' data=' + buffer);
            for i := 0 to n - 1 do
            begin
              if ReadElement(buffer[i]) then
              begin
                if FProtocolTrace then
                begin
                  s.Position := 0;
                  tl := s.Read(tbuf, 120);
                  WriteProtocolTrace('Process data=' + StringReplace(
                    StringReplace(copy(tbuf, 1, tl), cr, '', [rfReplaceAll]),
                    lf, '', [rfReplaceAll]) + '...');
                end;
                FProcessData.Add(s);
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

procedure TIndiBaseClient.Send(const Value: string);
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

function TIndiBaseClient.findDev(root: TDOMNode; out errmsg: string): BaseDevice;
var
  i: integer;
  buf: string;
begin
  Result := nil;
  buf := GetNodeValue(GetAttrib(root, 'device'));
  errmsg := 'Device not found ' + buf;
  for i := 0 to Fdevices.Count - 1 do
  begin
    if BaseDevice(Fdevices[i]).getDeviceName = buf then
    begin
      Result := BaseDevice(Fdevices[i]);
      errmsg := '';
      break;
    end;
  end;
end;

function TIndiBaseClient.findDev(root: TDOMNode; createifnotexist: boolean;
  out errmsg: string): BaseDevice;
var
  buf: string;
begin
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
      Result.onNewNumber := @IndiNumberEvent;
      Result.onNewText := @IndiTextEvent;
      Result.onNewSwitch := @IndiSwitchEvent;
      Result.onNewLight := @IndiLightEvent;
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
end;

function TIndiBaseClient.getDevice(deviceName: string): Basedevice;
var
  i: integer;
begin
  for i := 0 to Fdevices.Count - 1 do
    if (deviceName = BaseDevice(Fdevices[i]).getDeviceName) then
      exit(BaseDevice(Fdevices[i]));
  exit(nil);
end;

procedure TIndiBaseClient.deleteDevice(deviceName: string; out errmsg: string);
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

procedure TIndiBaseClient.ProcessDataAsync(Data: PtrInt);
var mp:IMessage;
begin
  try
    if not terminated then
    begin
      if not ProcessData(TMemoryStream(Data)) then
      begin
        mp:=IMessage.Create;
        mp.msg:='Bad INDI message';
        IndiMessageEvent(mp);
      end;
    end
    else
      TMemoryStream(Data).Free;
  except
  end;
end;


procedure TIndiBaseClient.ProcessDataThread(s: TMemoryStream);
begin
  if not terminated then
  begin
    Application.QueueAsyncCall(@ProcessDataAsync, PtrInt(s));
  end;
end;

function TIndiBaseClient.ProcessData(s: TMemoryStream): boolean;
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
      if dp=nil then
        break;
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

procedure TIndiBaseClient.sendNewNumber(nvp: INumberVectorProperty);
var
  buf: string;
  i: integer;
begin
  nvp.s := IPS_BUSY;
  buf := '<newNumberVector';
  buf := buf + '  device="' + nvp.device + '"';
  buf := buf + '  name="' + nvp.Name + '">';
  for i := 0 to nvp.nnp - 1 do
  begin
    buf := buf + '  <oneNumber';
    buf := buf + '    name="' + nvp.np[i].Name + '">';
    buf := buf + '   ' + FloatToStr(nvp.np[i].Value);
    buf := buf + '  </oneNumber>';
  end;
  buf := buf + '</newNumberVector>';
  Send(buf);
end;

procedure TIndiBaseClient.sendNewText(tvp: ITextVectorProperty);
var
  buf: string;
  i: integer;
begin
  tvp.s := IPS_BUSY;
  buf := '<newTextVector';
  buf := buf + '  device="' + tvp.device + '"';
  buf := buf + '  name="' + tvp.Name + '">';
  for i := 0 to tvp.ntp - 1 do
  begin
    buf := buf + '  <oneText';
    buf := buf + '    name="' + tvp.tp[i].Name + '">';
    buf := buf + '   ' + tvp.tp[i].Text;
    buf := buf + '  </oneText>';
  end;
  buf := buf + '</newTextVector>';
  Send(buf);
end;

procedure TIndiBaseClient.sendNewSwitch(svp: ISwitchVectorProperty);
var
  buf: string;
  i: integer;
  onSwitch: ISwitch;
begin
  svp.s := IPS_BUSY;
  onSwitch := IUFindOnSwitch(svp);
  buf := '<newSwitchVector';
  buf := buf + '  device="' + svp.device + '"';
  buf := buf + '  name="' + svp.Name + '">';
  if (svp.r = ISR_1OFMANY) and (onSwitch <> nil) then
  begin
    buf := buf + '  <oneSwitch';
    buf := buf + '    name="' + onSwitch.Name + '">';
    buf := buf + '      On ';
    buf := buf + '  </oneSwitch>';
  end
  else
  begin
    for i := 0 to svp.nsp - 1 do
    begin
      buf := buf + '  <oneSwitch';
      buf := buf + '    name="' + svp.sp[i].Name + '">';
      if svp.sp[i].s = ISS_ON then
        buf := buf + '    On'
      else
        buf := buf + '    Off';
      buf := buf + '  </oneSwitch>';
    end;
  end;
  buf := buf + '</newSwitchVector>';
  Send(buf);
end;

function TIndiBaseClient.WaitBusy(nvp: INumberVectorProperty;
  timeout: integer = 5000; minwait: integer = 0): boolean;
var
  Count, maxcount, mincount: integer;
begin
  mincount := minwait div 100;
  Count := 0;
  if mincount > 0 then
    while (Count < mincount) do
    begin
      sleep(100);
      Application.ProcessMessages;
      Inc(Count);
    end;
  maxcount := timeout div 100;
  Count := 0;
  while (nvp.s = IPS_BUSY) and (Count < maxcount) do
  begin
    sleep(100);
    Application.ProcessMessages;
    Inc(Count);
  end;
  Result := (Count < maxcount);
end;

function TIndiBaseClient.WaitBusy(tvp: ITextVectorProperty;
  timeout: integer = 5000; minwait: integer = 0): boolean;
var
  Count, maxcount, mincount: integer;
begin
  mincount := minwait div 100;
  Count := 0;
  if mincount > 0 then
    while (Count < mincount) do
    begin
      sleep(100);
      Application.ProcessMessages;
      Inc(Count);
    end;
  maxcount := timeout div 100;
  Count := 0;
  while (tvp.s = IPS_BUSY) and (Count < maxcount) do
  begin
    sleep(100);
    Application.ProcessMessages;
    Inc(Count);
  end;
  Result := (Count < maxcount);
end;

function TIndiBaseClient.WaitBusy(svp: ISwitchVectorProperty;
  timeout: integer = 5000; minwait: integer = 0): boolean;
var
  Count, maxcount, mincount: integer;
begin
  mincount := minwait div 100;
  Count := 0;
  if mincount > 0 then
    while (Count < mincount) do
    begin
      sleep(100);
      Application.ProcessMessages;
      Inc(Count);
    end;
  maxcount := timeout div 100;
  Count := 0;
  while (svp.s = IPS_BUSY) and (Count < maxcount) do
  begin
    sleep(100);
    Application.ProcessMessages;
    Inc(Count);
  end;
  Result := (Count < maxcount);
end;

procedure TIndiBaseClient.SetServer(host, port: string);
{$ifdef UNIX}
var
  H: THostEntry;
  ok: boolean;
  buf: string;

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
  if (pos('.', host) = 0) and (not ResolveHostByName(host, H)) then
  begin
    // try to add the default domain
    buf := FirstWord(DefaultDomainList);
    buf := host + '.' + buf;
    ok := ResolveHostByName(buf, H);
    if ok then
      host := buf;
  end;
  {$endif}
  FTargetHost := host;
  FTargetPort := port;
end;

procedure TIndiBaseClient.watchDevice(devicename: string);
begin
  FwatchDevices.Add(devicename);
end;

procedure TIndiBaseClient.setBLOBMode(blobH: BLOBHandling; dev: string;
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

procedure TIndiBaseClient.ConnectServer;
begin
  Start;
end;

procedure TIndiBaseClient.DisconnectServer;
begin
  Terminate;
end;

procedure TIndiBaseClient.connectDevice(deviceName: string);
begin
  setDriverConnection(True, deviceName);
end;

procedure TIndiBaseClient.disconnectDevice(deviceName: string);
begin
  setDriverConnection(False, deviceName);
end;

procedure TIndiBaseClient.setDriverConnection(status: boolean; deviceName: string);
var
  drv: BaseDevice;
  drv_connection: ISwitchVectorProperty;
begin
  drv := getDevice(deviceName);
  if drv = nil then
    exit;

  drv_connection := drv.getSwitch('CONNECTION');
  if drv_connection = nil then
    exit;

  if status then
  begin
    if (drv_connection.sp[0].s = ISS_ON) then
      exit;
    IUResetSwitch(drv_connection);
    drv_connection.s := IPS_BUSY;
    drv_connection.sp[0].s := ISS_ON;
    drv_connection.sp[1].s := ISS_OFF;
    sendNewSwitch(drv_connection);
  end
  else
  begin
    if (drv_connection.sp[1].s = ISS_ON) then
      exit;
    IUResetSwitch(drv_connection);
    drv_connection.s := IPS_BUSY;
    drv_connection.sp[0].s := ISS_OFF;
    drv_connection.sp[1].s := ISS_ON;
    sendNewSwitch(drv_connection);
  end;
end;

procedure TIndiBaseClient.RefreshProps;
var
  i: integer;
begin
  if FwatchDevices.Count = 0 then
    Send('<getProperties version="' + INDIV + '"/>')
  else
    for i := 0 to FwatchDevices.Count - 1 do
      Send('<getProperties version="' + INDIV + '" device="' + FwatchDevices[i] + '"/>');
end;

procedure TIndiBaseClient.SyncServerConnected;
begin
  if assigned(FServerConnected) then
    FServerConnected(self);
end;

procedure TIndiBaseClient.SyncServerDisonnected;
begin
  if assigned(FServerDisconnected) then
    FServerDisconnected(self);
end;

procedure TIndiBaseClient.SyncPropertyEvent;
begin
  if assigned(FIndiPropertyEvent) then
    FIndiPropertyEvent(SyncindiProp);
end;

procedure TIndiBaseClient.SyncDeletePropertyEvent;
begin
  if assigned(FIndiDeletePropertyEvent) then
    FIndiDeletePropertyEvent(SyncindiProp);
end;

procedure TIndiBaseClient.IndiDeviceEvent(dp: Basedevice);
begin
  SyncindiDev := dp;
  // Device event must be processed synchronously
  Synchronize(@SyncDeviceEvent);
end;

procedure TIndiBaseClient.SyncDeviceEvent;
begin
  if assigned(FIndiDeviceEvent) then
    FIndiDeviceEvent(SyncindiDev);
end;

procedure TIndiBaseClient.IndiDeleteDeviceEvent(dp: Basedevice);
begin
  SyncindiDev := dp;
  // Device event must be processed synchronously
  Synchronize(@SyncDeleteDeviceEvent);
end;

procedure TIndiBaseClient.SyncDeleteDeviceEvent;
begin
  if assigned(FIndiDeleteDeviceEvent) then
    FIndiDeleteDeviceEvent(SyncindiDev);
end;

procedure TIndiBaseClient.IndiPropertyEvent(indiProp: IndiProperty);
begin
  SyncindiProp := indiProp;
  Synchronize(@SyncPropertyEvent);
end;

procedure TIndiBaseClient.IndiDeletePropertyEvent(indiProp: IndiProperty);
begin
  SyncindiProp := indiProp;
  Synchronize(@SyncDeletePropertyEvent);
end;

procedure TIndiBaseClient.IndiNumberEvent(nvp: INumberVectorProperty);
begin
  Application.QueueAsyncCall(@ASyncNumberEvent, PtrInt(nvp));
end;

procedure TIndiBaseClient.ASyncNumberEvent(Data: PtrInt);
begin
  if assigned(FIndiNumberEvent) then
    FIndiNumberEvent(INumberVectorProperty(Data));
end;

procedure TIndiBaseClient.IndiTextEvent(tvp: ITextVectorProperty);
begin
  Application.QueueAsyncCall(@ASyncTextEvent, PtrInt(tvp));
end;

procedure TIndiBaseClient.ASyncTextEvent(Data: PtrInt);
begin
  if assigned(FIndiTextEvent) then
    FIndiTextEvent(ITextVectorProperty(Data));
end;

procedure TIndiBaseClient.IndiSwitchEvent(svp: ISwitchVectorProperty);
begin
  Application.QueueAsyncCall(@ASyncSwitchEvent, PtrInt(svp));
end;

procedure TIndiBaseClient.ASyncSwitchEvent(Data: PtrInt);
begin
  if assigned(FIndiSwitchEvent) then
    FIndiSwitchEvent(ISwitchVectorProperty(Data));
end;

procedure TIndiBaseClient.IndiLightEvent(lvp: ILightVectorProperty);
begin
  Application.QueueAsyncCall(@ASyncLightEvent, PtrInt(lvp));
end;

procedure TIndiBaseClient.ASyncLightEvent(Data: PtrInt);
begin
  if assigned(FIndiLightEvent) then
    FIndiLightEvent(ILightVectorProperty(Data));
end;

procedure TIndiBaseClient.IndiBlobEvent(bp: IBLOB);
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

procedure TIndiBaseClient.ASyncBlobEvent(Data: PtrInt);
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

procedure TIndiBaseClient.IndiMessageEvent(mp: IMessage);
begin
  try
  Application.QueueAsyncCall(@ASyncMessageEvent, PtrInt(mp));
  except
  end;
end;


procedure TIndiBaseClient.ASyncMessageEvent(Data: PtrInt);
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
