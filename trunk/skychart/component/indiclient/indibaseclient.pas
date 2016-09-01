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
    function Connect: Boolean;
    procedure Disconnect;
    function RecvString: string;
    function GetErrorDesc: string;
  published
    property Sock: TTCPBlockSocket read FSock;
  end;

  TIndiBaseClient = class(TThread)
  private
    FTargetHost,FTargetPort,FErrorDesc,FRecvData,Fsendbuffer : string;
    FTimeout : integer;
    FConnected: boolean;
    Fdevices: TObjectlist;
    FwatchDevices: TStringlist;
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
    SyncindiMessage: string;
    SyncindiProp: IndiProperty;
    SyncindiNumber: INumberVectorProperty;
    SyncindiText: ITextVectorProperty;
    SyncindiSwitch: ISwitchVectorProperty;
    SyncindiLight: ILightVectorProperty;
    SyncindiBlob: IBLOB;
    MessageCriticalSection: TRTLCriticalSection;
    SendCriticalSection: TRTLCriticalSection;
    procedure IndiDeviceEvent(dp: Basedevice);
    procedure IndiDeleteDeviceEvent(dp: Basedevice);
    procedure IndiMessageEvent(msg: string);
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
    procedure ASyncMessageEvent(Data: PtrInt);
    procedure SyncPropertyEvent;
    procedure SyncDeletePropertyEvent;
    procedure SyncNumberEvent;
    procedure SyncTextEvent;
    procedure SyncSwitchEvent;
    procedure SyncLightEvent;
    procedure SyncBlobEvent;
    function findDev(root: TDOMNode; createifnotexist: boolean; out errmsg: string):BaseDevice;
    function findDev(root: TDOMNode; out errmsg: string):BaseDevice;
    function ProcessData(line: string):boolean;
    procedure setDriverConnection(status: boolean; deviceName: string);
  public
    TcpClient : TTcpclient;
    constructor Create;
    destructor Destroy; override;
    procedure RefreshProps;
    procedure Execute; override;
    procedure SetServer(host,port: string);
    procedure watchDevice(devicename: string);
    procedure setBLOBMode(blobH: BLOBHandling; dev: string; prop:string='');
    procedure ConnectServer;
    procedure DisconnectServer;
    procedure connectDevice(deviceName: string);
    procedure disconnectDevice(deviceName: string);
    procedure Send(const Value: string);
    property devices: TObjectlist read Fdevices;
    function getDevice(deviceName: string): Basedevice;
    procedure deleteDevice(deviceName: string; out errmsg: string);
    procedure sendNewNumber(nvp: INumberVectorProperty);
    procedure sendNewText(tvp: ITextVectorProperty);
    procedure sendNewSwitch(svp: ISwitchVectorProperty);
    function WaitBusy(nvp: INumberVectorProperty; timeout:integer=5000;minwait:integer=0):boolean;
    function WaitBusy(tvp: ITextVectorProperty; timeout:integer=5000;minwait:integer=0):boolean;
    function WaitBusy(svp: ISwitchVectorProperty; timeout:integer=5000;minwait:integer=0):boolean;
    property Timeout : integer read FTimeout write FTimeout;
    property Terminated;
    property Connected: boolean read FConnected;
    property ErrorDesc : string read FErrorDesc;
    property RecvData : string read FRecvData;
    property onServerConnected: TNotifyEvent read FServerConnected write FServerConnected;
    property onServerDisconnected: TNotifyEvent read FServerDisconnected write FServerDisconnected;
    property onNewDevice: TIndiDeviceEvent read FIndiDeviceEvent write FIndiDeviceEvent;
    property onDeleteDevice: TIndiDeviceEvent read FIndiDeleteDeviceEvent write FIndiDeleteDeviceEvent;
    property onNewMessage : TIndiMessageEvent read FIndiMessageEvent write FIndiMessageEvent;
    property onNewProperty : TIndiPropertyEvent read FIndiPropertyEvent write FIndiPropertyEvent;
    property onDeleteProperty : TIndiPropertyEvent read FIndiDeletePropertyEvent write FIndiDeletePropertyEvent;
    property onNewNumber : TIndiNumberEvent read FIndiNumberEvent write FIndiNumberEvent;
    property onNewText   : TIndiTextEvent read FIndiTextEvent write FIndiTextEvent;
    property onNewSwitch : TIndiSwitchEvent read FIndiSwitchEvent write FIndiSwitchEvent;
    property onNewLight  : TIndiLightEvent read FIndiLightEvent write FIndiLightEvent;
    property onNewBlob   : TIndiBlobEvent read FIndiBlobEvent write FIndiBlobEvent;
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

function TTCPclient.Connect: Boolean;
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

function TTCPclient.RecvString: string;
var buf: string;
begin
  Result:='';
  repeat
    buf:=FSock.RecvPacket(FTimeout);
    if (FSock.lastError<>0)and(FSock.lastError<>WSAETIMEDOUT) then break;
    Result := Result+buf;
  until buf='';
end;

function TTCPclient.GetErrorDesc: string;
begin
  Result := FSock.GetErrorDesc(FSock.LastError);
end;

///////////////////////  TIndiBaseClient //////////////////////////

Constructor TIndiBaseClient.Create ;
begin
// start suspended to let time to the main thread to set the parameters
inherited create(true);
FTargetHost:='localhost';
FTargetPort:='7624';
FTimeout:=100;
FConnected:=false;
FreeOnTerminate:=true;
SyncindiMessage:='';
Ftrace:=false;  // for debuging only
Fdevices:=TObjectList.Create;
FwatchDevices:=TStringlist.Create;
end;

destructor TIndiBaseClient.Destroy;
begin
if Ftrace then writeln('TIndiBaseClient.Destroy');
Fdevices.Free;
FwatchDevices.Free;
{$ifndef mswindows}
Inherited destroy;
{$endif}
end;

procedure TIndiBaseClient.Execute;
var buf,buf1:string;
    init,initProps:boolean;
    bufretry: integer;
begin
try
tcpclient:=TTCPClient.Create;
try
 InitCriticalSection(MessageCriticalSection);
 InitCriticalSection(SendCriticalSection);
 init:=true;
 initProps:=false;
 tcpclient.TargetHost:=FTargetHost;
 tcpclient.TargetPort:=FTargetPort;
 tcpclient.Timeout := FTimeout;
 FConnected:=tcpclient.Connect;
 if Ftrace then writeln(tcpclient.GetErrorDesc);
 if FConnected then begin
   RefreshProps;
   // main loop
   buf:='';
   bufretry:=0;
   repeat
     if terminated then break;
     buf1:=tcpclient.recvstring;
     buf:=buf+buf1;
     if terminated then break;
     if (tcpclient.Sock.lastError<>0)and(tcpclient.Sock.lastError<>WSAETIMEDOUT) then break;
     if buf<>'' then begin
        if not ProcessData(buf) then begin
          inc(bufretry);
          if bufretry>100 then begin
             IndiMessageEvent('INDI message not received completly after 100*timeout. Please increase the Timeout value.');
          end else
             Continue; // incomplete buffer, read next part
        end;
        initProps:=true;
        buf:='';
        bufretry:=0;
     end;
     if initProps and init then begin
        if assigned(FServerConnected) then Synchronize(@SyncServerConnected);
        init:=false;
     end;
     EnterCriticalsection(SendCriticalSection);
     try
     buf:=Fsendbuffer;
     Fsendbuffer:='';
     finally
     LeaveCriticalsection(SendCriticalSection);
     end;
     if buf<>'' then begin
        if Ftrace then WriteLn('Send : '+buf);
        tcpclient.Sock.SendString(buf);
        if tcpclient.Sock.lastError<>0 then break;
     end;
   until false;
 end;
finally
FConnected:=false;
terminate;
tcpclient.Disconnect;
tcpclient.Free;
DoneCriticalsection(MessageCriticalSection);
DoneCriticalsection(SendCriticalSection);
if assigned(FServerDisconnected) then Synchronize(@SyncServerDisonnected);
if Ftrace then writeln('Indi client stopped');
end;
except
end;
end;

procedure TIndiBaseClient.Send(const Value: string);
begin
 if Value>'' then begin
   EnterCriticalsection(SendCriticalSection);
   try
   Fsendbuffer:=Fsendbuffer+Value+crlf;
   finally
   LeaveCriticalsection(SendCriticalSection);
   end;
 end;
end;

function TIndiBaseClient.findDev(root: TDOMNode; out errmsg: string):BaseDevice;
var i: integer;
    buf: string;
begin
 result:=nil;
 errmsg:='Device not found';
 buf:=GetNodeValue(GetAttrib(root,'device'));
 for i:=0 to Fdevices.Count-1 do begin
     if BaseDevice(Fdevices[i]).getDeviceName=buf then begin
        result:= BaseDevice(Fdevices[i]);
        errmsg:='';
        break;
     end;
 end;
end;

function TIndiBaseClient.findDev(root: TDOMNode; createifnotexist: boolean; out errmsg: string):BaseDevice;
var buf: string;
begin
 result:=findDev(root,errmsg);
 if (result=nil) and createifnotexist then begin
   buf:=GetNodeValue(GetAttrib(root,'device'));
   if buf<>'' then begin
     result:=BaseDevice.Create;
     result.setDeviceName(buf);
     result.onNewMessage:=@IndiMessageEvent;
     result.onNewProperty:=@IndiPropertyEvent;
     result.onDeleteProperty:=@IndiDeletePropertyEvent;
     result.onNewNumber:=@IndiNumberEvent;
     result.onNewText:=@IndiTextEvent;
     result.onNewSwitch:=@IndiSwitchEvent;
     result.onNewLight:=@IndiLightEvent;
     result.onNewBlob:=@IndiBlobEvent;
     Fdevices.Add(result);
     if assigned(FIndiDeviceEvent) then IndiDeviceEvent(result);
   end else begin
     errmsg:='No device name';
   end;
 end;
end;

function TIndiBaseClient.getDevice(deviceName: string): Basedevice;
var i: integer;
begin
  for i:=0 to Fdevices.Count-1 do
     if (deviceName = BaseDevice(Fdevices[i]).getDeviceName) then
            exit (BaseDevice(Fdevices[i]));
    exit(nil);
end;

procedure TIndiBaseClient.deleteDevice(deviceName: string; out errmsg: string);
var dp: BaseDevice;
    i: integer;
begin
  errmsg:='Device '+deviceName+' not found!';
  for i:=0 to Fdevices.Count-1 do
     if (deviceName = BaseDevice(Fdevices[i]).getDeviceName) then begin
        dp:=(BaseDevice(Fdevices[i]));
        if assigned(FIndiDeleteDeviceEvent) then IndiDeleteDeviceEvent(dp);
        Fdevices.Delete(i);
        errmsg:='';
        break;
     end;
end;

function TIndiBaseClient.ProcessData(line:string):boolean;
var Doc: TXMLDocument;
    Node: TDOMNode;
    dp: BaseDevice;
    s: TStringStream;
    buf,errmsg,dname,pname: string;
begin
//if Ftrace then writeln(line);
FRecvData:='<INDIMSG>'+line+'</INDIMSG>';
s:=TStringStream.Create(FRecvData);
result:=true;
try
ReadXMLFile(Doc,s);
except
  on E: Exception do begin
    result:=false;
    exit;
  end;
end;
try
Node:=Doc.DocumentElement.FirstChild;
while Node<>nil do begin
   if terminated then break;
   dp:=findDev(Node,true,errmsg);
   if Node.NodeName='message' then begin
      dp.checkMessage(Node);
   end;
   if Node.NodeName='delProperty' then begin
      dname:=GetNodeValue(GetAttrib(Node,'device'));
      if dname='' then dname:='Unnamed_device';
      pname:=GetNodeValue(GetAttrib(Node,'name'));
      if pname='' then begin
         deleteDevice(dname,errmsg)
      end
      else begin
         dp.removeProperty(pname,errmsg);
      end;
   end;
   buf:=copy(GetNodeName(Node),1,3);
   if buf='set' then dp.setValue(Node,errmsg)
   else if buf='def' then  dp.buildProp(Node,errmsg);
   Node:=Node.NextSibling;
end;
finally
 s.Free;
 Doc.Free;
end;
end;

procedure TIndiBaseClient.sendNewNumber(nvp: INumberVectorProperty);
var buf: string;
    i: integer;
begin
  nvp.s := IPS_BUSY;
  buf:='<newNumberVector';
  buf:=buf+'  device="'+nvp.device+'"';
  buf:=buf+'  name="'+nvp.name+'">';
  for i:=0 to nvp.nnp-1 do begin
      buf:=buf+'  <oneNumber';
      buf:=buf+'    name="'+nvp.np[i].name+'">';
      buf:=buf+'   '+FloatToStr(nvp.np[i].value);
      buf:=buf+'  </oneNumber>';
  end;
  buf:=buf+'</newNumberVector>';
  Send(buf);
end;

procedure TIndiBaseClient.sendNewText(tvp: ITextVectorProperty);
var buf: string;
    i: integer;
begin
  tvp.s := IPS_BUSY;
  buf:='<newTextVector';
  buf:=buf+'  device="'+tvp.device+'"';
  buf:=buf+'  name="'+tvp.name+'">';
  for i:=0 to tvp.ntp-1 do begin
      buf:=buf+'  <oneText';
      buf:=buf+'    name="'+tvp.tp[i].name+'">';
      buf:=buf+'   '+tvp.tp[i].text;
      buf:=buf+'  </oneText>';
  end;
  buf:=buf+'</newTextVector>';
  Send(buf);
end;

procedure TIndiBaseClient.sendNewSwitch(svp: ISwitchVectorProperty);
var buf: string;
    i: integer;
    onSwitch: ISwitch;
begin
  svp.s := IPS_BUSY;
  onSwitch := IUFindOnSwitch(svp);
  buf:='<newSwitchVector';
  buf:=buf+'  device="'+svp.device+'"';
  buf:=buf+'  name="'+svp.name+'">';
  if (svp.r = ISR_1OFMANY) and (onSwitch<>nil) then begin
    buf:=buf+'  <oneSwitch';
    buf:=buf+'    name="'+onSwitch.name+'">';
    buf:=buf+'      On ';
    buf:=buf+'  </oneSwitch>';
  end else begin
    for i:=0 to svp.nsp-1 do begin
        buf:=buf+'  <oneSwitch';
        buf:=buf+'    name="'+svp.sp[i].name+'">';
        if svp.sp[i].s=ISS_ON then buf:=buf+'    On' else buf:=buf+'    Off';
        buf:=buf+'  </oneSwitch>';
    end;
  end;
  buf:=buf+'</newSwitchVector>';
  Send(buf);
end;

function TIndiBaseClient.WaitBusy(nvp: INumberVectorProperty; timeout:integer=5000;minwait:integer=0):boolean;
var count,maxcount,mincount:integer;
begin
mincount:=minwait div 100;
count:=0;
if mincount>0 then while (count<mincount) do begin
   sleep(100);
   Application.ProcessMessages;
   inc(count);
end;
maxcount:=timeout div 100;
count:=0;
while (nvp.s=IPS_BUSY)and(count<maxcount) do begin
   sleep(100);
   Application.ProcessMessages;
   inc(count);
end;
result:=(count<maxcount);
end;

function TIndiBaseClient.WaitBusy(tvp: ITextVectorProperty; timeout:integer=5000;minwait:integer=0):boolean;
var count,maxcount,mincount:integer;
begin
mincount:=minwait div 100;
count:=0;
if mincount>0 then while (count<mincount) do begin
   sleep(100);
   Application.ProcessMessages;
   inc(count);
end;
maxcount:=timeout div 100;
count:=0;
while (tvp.s=IPS_BUSY)and(count<maxcount) do begin
   sleep(100);
   Application.ProcessMessages;
   inc(count);
end;
result:=(count<maxcount);
end;

function TIndiBaseClient.WaitBusy(svp: ISwitchVectorProperty; timeout:integer=5000;minwait:integer=0):boolean;
var count,maxcount,mincount:integer;
begin
mincount:=minwait div 100;
count:=0;
if mincount>0 then while (count<mincount) do begin
   sleep(100);
   Application.ProcessMessages;
   inc(count);
end;
maxcount:=timeout div 100;
count:=0;
while (svp.s=IPS_BUSY)and(count<maxcount) do begin
   sleep(100);
   Application.ProcessMessages;
   inc(count);
end;
result:=(count<maxcount);
end;

procedure TIndiBaseClient.SetServer(host,port: string);
{$ifdef UNIX}
Var
  H : THostEntry;
  ok:boolean;
  buf:string;
Function FirstWord(Var Line : String) : String;
  Var
    I,J : Integer;
  Const
    Whitespace = [' ',#9];
  begin
    I:=1;
    While (I<=Length(Line)) and (Line[i] in Whitespace) do
      inc(I);
    J:=I;
    While (J<=Length(Line)) and Not (Line[J] in WhiteSpace) do
      inc(j);
    Result:=Copy(Line,I,J-I);
end;
{$endif}
begin
  {$ifdef UNIX}
  if (pos('.',host)=0)and(not ResolveHostByName(host,H)) then begin
    // try to add the default domain
    buf:=FirstWord(DefaultDomainList);
    buf:=host+'.'+buf;
    ok:=ResolveHostByName(buf,H);
    if ok then host:=buf;
  end;
  {$endif}
  FTargetHost:=host;
  FTargetPort:=port;
end;

procedure TIndiBaseClient.watchDevice(devicename: string);
begin
  FwatchDevices.Add(devicename);
end;

procedure TIndiBaseClient.setBLOBMode(blobH: BLOBHandling; dev: string; prop:string='');
var buf: string;
begin
 if (prop<>'') then
    buf:='<enableBLOB device="'+dev+'" name="'+prop+'">'
 else
    buf:='<enableBLOB device="'+dev+'">';
 case blobH of
   B_NEVER:
          buf:=buf+'Never</enableBLOB>';
   B_ALSO:
          buf:=buf+'Also</enableBLOB>';
   B_ONLY:
          buf:=buf+'Only</enableBLOB>';
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
 setDriverConnection(true, deviceName);
end;

procedure TIndiBaseClient.disconnectDevice(deviceName: string);
begin
 setDriverConnection(false, deviceName);
end;

procedure TIndiBaseClient.setDriverConnection(status: boolean; deviceName: string);
var drv: BaseDevice;
    drv_connection: ISwitchVectorProperty;
begin
  drv:=getDevice(deviceName);
  if drv=nil then exit;

  drv_connection := drv.getSwitch('CONNECTION');
  if drv_connection=nil then exit;

  if status then begin
    if (drv_connection.sp[0].s = ISS_ON) then exit;
    IUResetSwitch(drv_connection);
    drv_connection.s := IPS_BUSY;
    drv_connection.sp[0].s := ISS_ON;
    drv_connection.sp[1].s := ISS_OFF;
    sendNewSwitch(drv_connection);
  end else begin
    if (drv_connection.sp[1].s = ISS_ON) then exit;
    IUResetSwitch(drv_connection);
    drv_connection.s := IPS_BUSY;
    drv_connection.sp[0].s := ISS_OFF;
    drv_connection.sp[1].s := ISS_ON;
    sendNewSwitch(drv_connection);
  end;
end;

procedure TIndiBaseClient.RefreshProps;
var i: integer;
begin
  if FwatchDevices.Count=0 then
     Send('<getProperties version="'+INDIV+'"/>')
  else
     for i:=0 to FwatchDevices.Count-1 do
        Send('<getProperties version="'+INDIV+'" device="'+FwatchDevices[i]+'"/>');
end;

procedure TIndiBaseClient.IndiDeviceEvent(dp: Basedevice);
begin
  SyncindiDev:=dp;
  Synchronize(@SyncDeviceEvent);
end;
procedure TIndiBaseClient.IndiDeleteDeviceEvent(dp: Basedevice);
begin
  SyncindiDev:=dp;
  Synchronize(@SyncDeleteDeviceEvent);
end;
procedure TIndiBaseClient.IndiMessageEvent(msg: string);
begin
  EnterCriticalSection(MessageCriticalSection);
  try
  if SyncindiMessage='' then
    SyncindiMessage:=msg
  else
    SyncindiMessage:=SyncindiMessage+crlf+msg;
  finally
  LeaveCriticalsection(MessageCriticalSection);
  end;
  Application.QueueAsyncCall(@ASyncMessageEvent,0);
end;
procedure TIndiBaseClient.IndiPropertyEvent(indiProp: IndiProperty);
begin
  SyncindiProp:=indiProp;
  Synchronize(@SyncPropertyEvent);
end;
procedure TIndiBaseClient.IndiDeletePropertyEvent(indiProp: IndiProperty);
begin
  SyncindiProp:=indiProp;
  Synchronize(@SyncDeletePropertyEvent);
end;
procedure TIndiBaseClient.IndiNumberEvent(nvp: INumberVectorProperty);
begin
  SyncindiNumber:=nvp;
  Synchronize(@SyncNumberEvent);
end;
procedure TIndiBaseClient.IndiTextEvent(tvp: ITextVectorProperty);
begin
  SyncindiText:=tvp;
  Synchronize(@SyncTextEvent);
end;
procedure TIndiBaseClient.IndiSwitchEvent(svp: ISwitchVectorProperty);
begin
  SyncindiSwitch:=svp;
  Synchronize(@SyncSwitchEvent);
end;
procedure TIndiBaseClient.IndiLightEvent(lvp: ILightVectorProperty);
begin
  SyncindiLight:=lvp;
  Synchronize(@SyncLightEvent);
end;
procedure TIndiBaseClient.IndiBlobEvent(bp: IBLOB);
begin
  SyncindiBlob:=bp;
  Synchronize(@SyncBlobEvent);
end;

procedure TIndiBaseClient.SyncServerConnected;
begin
  if assigned(FServerConnected) then FServerConnected(self);
end;
procedure TIndiBaseClient.SyncServerDisonnected;
begin
  if assigned(FServerDisconnected) then FServerDisconnected(self);
end;

procedure TIndiBaseClient.SyncDeviceEvent;
begin
  if assigned(FIndiDeviceEvent) then FIndiDeviceEvent(SyncindiDev);
end;
procedure TIndiBaseClient.SyncDeleteDeviceEvent;
begin
  if assigned(FIndiDeleteDeviceEvent) then FIndiDeleteDeviceEvent(SyncindiDev);
end;
procedure TIndiBaseClient.ASyncMessageEvent(Data: PtrInt);
var msg: string;
begin
  msg:='';
  if not terminated then EnterCriticalSection(MessageCriticalSection);
  try
  if SyncindiMessage<>'' then begin
    msg:=SyncindiMessage;
    SyncindiMessage:='';
  end;
  finally
  if not terminated then LeaveCriticalsection(MessageCriticalSection);
  end;
  if (msg<>'') and assigned(FIndiMessageEvent) then FIndiMessageEvent(Msg);
end;
procedure TIndiBaseClient.SyncPropertyEvent;
begin
  if assigned(FIndiPropertyEvent) then FIndiPropertyEvent(SyncindiProp);
end;
procedure TIndiBaseClient.SyncDeletePropertyEvent;
begin
  if assigned(FIndiDeletePropertyEvent) then FIndiDeletePropertyEvent(SyncindiProp);
end;
procedure TIndiBaseClient.SyncNumberEvent;
begin
  if assigned(FIndiNumberEvent) then FIndiNumberEvent(SyncindiNumber);
end;
procedure TIndiBaseClient.SyncTextEvent;
begin
  if assigned(FIndiTextEvent) then FIndiTextEvent(SyncindiText);
end;
procedure TIndiBaseClient.SyncSwitchEvent;
begin
  if assigned(FIndiSwitchEvent) then FIndiSwitchEvent(SyncindiSwitch);
end;
procedure TIndiBaseClient.SyncLightEvent;
begin
  if assigned(FIndiLightEvent) then FIndiLightEvent(SyncindiLight);
end;
procedure TIndiBaseClient.SyncBlobEvent;
begin
  if assigned(FIndiBlobEvent) then FIndiBlobEvent(SyncindiBlob);
end;

end.

