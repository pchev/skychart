unit cu_indiprotocol;
{                                        
Copyright (C) 2004 Patrick Chevalley

http://www.ap-i.net
pch@ap-i.net

This program is free software; you can redistribute it and/or
modify it under the terms of the GNU General Public License
as published by the Free Software Foundation; either version 2
of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software
Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
}
{
  Minimal INDI client object thread for Cartes du Ciel
}
{$mode objfpc}{$H+}

interface

uses
  {$ifdef mswindows}
    Windows,
  {$endif}
  {$ifdef unix}
    baseunix,
  {$endif}
  u_translation, u_constant, u_util, blcksock, LibXmlParser, LibXmlComps,
  Classes, SysUtils, Messages,Forms;

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

  TIndiDataEvent = procedure(Sender : TObject; const data : string) of object;
  TIndiSource = (Server,Telescope,Coord);
  TIndiStatus = (Ok,Busy,Idle,Alert);
  TStatusInfo = procedure(Sender : Tobject; source: TIndiSource; status: TIndistatus) of object;

  TIndiClient = class(TThread)
  private
    FTargetHost,FTargetPort,FErrorDesc,FRecvData,Fsendbuffer : string;
    FIndiserver,FIndiDriver: string;
    FTimeout,FIndiServerPid : integer;
    Fserverstatus,Ftelescopestatus,Fcoordstatus: TIndiStatus;
    FTag,FCurrentTag,FDevice,FCurrentDevice,FName,FPerm,FCurrentName,FMessage,FDevicePort,FRa,FDec,FCOORD_REQUEST: string;
    FWantDevice,FWantDevicePort,FWantRA,FWantDec: string;
    FAutoconnect,FAutoStart,Ftrace,FServerStartedByMe,EOD,Fexiting,FDeviceFound,FCanSlew,FCanSync :boolean;
    XmlScanner: TEasyXmlScanner;
    procedure DisplayMessagesyn;
    procedure ProcessDataSyn;
    procedure DisplayMessage(msg:string);
    procedure ProcessData(line:string);
    procedure SetStatus(source: TIndiSource; status: TIndistatus);
    procedure XmlStartTag(Sender: TObject; TagName: String; Attributes: TAttrList);
    procedure XmlContent(Sender: TObject; Content: String);
    procedure XmlEndTag(Sender: TObject; TagName: String);
    procedure XmlEmptyTag(Sender: TObject; TagName: String; Attributes: TAttrList);
  public
    onSocketInfo: TIndiDataEvent;
    onReceiveData: TIndiDataEvent;
    FonMessage: TIndiDataEvent;
    FonStatusChange: TStatusInfo;
    FonCoordChange: TNotifyEvent;
    TcpClient : TTcpclient;
    Constructor Create;
    procedure Execute; override;
    procedure Send(const Value: string);
    procedure getProperties;
    procedure SetPort(Value:string);
  public
    procedure Connect;
    procedure Disconnect;
    procedure Sync;
    procedure Slew;
    procedure AbortSlew;
    property Terminated;
    property TargetHost : string read FTargetHost write FTargetHost;
    property TargetPort : string read FTargetPort write FTargetPort;
    property Timeout : integer read FTimeout write FTimeout;
    property ErrorDesc : string read FErrorDesc;
    property RecvData : string read FRecvData;
    property TelescopePort : string read FDevicePort write FWantDevicePort;
    property Device : string read FWantDevice write FWantDevice;
    property AutoStart : boolean read FAutoStart write FAutoStart;
    property Autoconnect : boolean read FAutoconnect write FAutoconnect;
    property CanSync : boolean read FCanSync write FCanSync;
    property CanSlew : boolean read FCanSlew write FCanSlew;
    property ServerStatus: TIndiStatus read FServerstatus;
    property TelescopeStatus: TIndiStatus read Ftelescopestatus;
    property CoordStatus: TIndiStatus read FCoordstatus;
    property EquatorialOfDay: boolean read EOD;
    property RA : string read FRa write FWantRA;
    property Dec : string read FDec write FWantDec;
    property IndiServer : string read FIndiServer write FIndiServer;
    property IndiDriver : string read FIndiDriver write FIndiDriver;
    property exiting : boolean read Fexiting write Fexiting;
    property onCoordChange: TNotifyEvent read FonCoordChange write FonCoordChange;
    property onStatusChange: TStatusInfo read FonStatusChange write FonStatusChange;
    property onMessage: TIndiDataEvent read FonMessage write FonMessage;
  end;

implementation

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
writetrace('error destroy TCPclient');
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
  Result := FSock.RecvPacket(FTimeout);
  repeat
    buf:=FSock.RecvPacket(50);
    Result := Result+buf;
  until buf='';  
end;

function TTCPclient.GetErrorDesc: string;
begin
  Result := FSock.GetErrorDesc(FSock.LastError);
end;

Constructor TIndiClient.Create ;
begin
Fexiting:=false;
freeonterminate:=true;
Ftrace:=false;  // for debuging only
FIndiServerPid:=0;
FServerStartedByMe:=false;
FDeviceFound:=false;
Ftelescopestatus:=Idle;
FCOORD_REQUEST:='_REQUEST';
EOD:=true;
// start suspended to let time to the main thread to set the parameters
inherited create(true);
end;

procedure TIndiClient.Execute;
var buf,plugin:string;
    i : integer;
    connected,localplugin: boolean;
begin
try
XmlScanner:=TEasyXmlScanner.Create(nil);
XmlScanner.OnStartTag:=@XmlStartTag;
XmlScanner.OnContent:=@XmlContent;
XmlScanner.OnEndTag:=@XmlEndTag;
XmlScanner.OnEmptyTag:=@XmlEmptyTag;
tcpclient:=TTCPClient.Create;
try
 tcpclient.TargetHost:=FTargetHost;
 tcpclient.TargetPort:=FTargetPort;
 tcpclient.Timeout := FTimeout;
 connected:=tcpclient.Connect;
 if (not connected) and FAutoStart then begin
    buf:=getcurrentdir;
    try
      plugin:=slash('plugins');
      localplugin:=directoryexists(plugin);
      {$ifdef linux}
      plugin:=expandfilename(plugin);
      if localplugin then chdir(plugin);
      localplugin:=localplugin and fileexists(plugin+FIndiServer) and fileexists(plugin+FIndiDriver);
      if localplugin then begin
         FIndiServer:='./'+FIndiServer;
         FIndiDriver:='./'+FIndiDriver;
      end;
      FIndiServerPid:=ExecFork(FIndiServer,'-p',FTargetPort,FIndiDriver);
      {$endif}
      {$ifdef darwin}
      FIndiServerPid:=ExecFork(FIndiServer,'-p',FTargetPort,FIndiDriver);
      {$endif}
      {$ifdef mswindows}
      if localplugin then chdir(plugin);
      ExecNoWait(FIndiServer+' -p '+FTargetPort+' '+FIndiDriver,'IndiServer');
      {$endif}
    finally
      chdir(buf);
    end;
    i:=0;
    repeat
       inc(i);
       sleep(1000);
       connected:=tcpclient.Connect;
    until connected or (i>=10);
    FServerStartedByMe:=true;
 end;
 if connected then begin
   DisplayMessage(tcpclient.GetErrorDesc);
   // main loop
   repeat
     if terminated then break;
     buf:=tcpclient.recvstring;
     if buf<>'' then ProcessData(buf);
     if Fsendbuffer<>'' then begin
        buf:=Fsendbuffer; Fsendbuffer:='';
        if Ftrace then writetrace('Send to telescope: '+buf);
        tcpclient.Sock.SendString(buf);
        if tcpclient.Sock.lastError<>0 then break;
     end;
     if FAutoconnect then begin
        {$ifdef darwin}
        Connect;
        {$else}
        Synchronize(@Connect);
        {$endif}
        FAutoconnect:=false;
     end;
   until false;
 end;
if FServerStartedByMe then begin
  {$ifdef mswindows}
    FIndiServerPid:=findwindow(nil,Pchar('IndiServer'));
    writetrace('Kill indi server '+inttostr(FIndiServerPid));
    if FIndiServerPid<>0 then PostMessage(FIndiServerPid,WM_CLOSE,0,0);
  {$endif}
  {$ifdef darwin}
  // todo: darwin
  {$endif}
  {$ifdef linux}
    writetrace('Kill indi server '+inttostr(FIndiServerPid));
    if FIndiServerPid<>0 then fpKill(FIndiServerPid,SIGKILL);
  {$endif}
end;
if not Fexiting then begin
  if terminated then DisplayMessage(rsClosingConne)
                else DisplayMessage(tcpclient.GetErrorDesc);
end;
finally
terminate;
tcpclient.Disconnect;
tcpclient.Free;
XmlScanner.Free;
writetrace('Indi client stoped');
end;
except
end;
end;

procedure TIndiClient.DisplayMessage(msg:string);
begin
FErrorDesc:=msg;
if FErrorDesc='' then tcpclient.Sock.SendString('<getProperties version="1.7"></getProperties>');
{$ifdef darwin}
DisplayMessageSyn;
{$else}
Synchronize(@DisplayMessageSyn);
{$endif}
end;

procedure TIndiClient.DisplayMessageSyn;
begin
try
if FErrorDesc='OK' then begin
     setstatus(server,Ok);
  end else begin
     setstatus(server,Idle);
end;
if assigned(onSocketInfo) then onSocketInfo(self,FErrorDesc);
except
end;
end;

procedure TIndiClient.SetStatus(source: TIndiSource; status: TIndistatus);
begin
try
if (source=coord)and((FTelescopeStatus=Idle)or(FTelescopeStatus=Alert)) then status:=Idle;
if (source=coord)and(status=Idle)and(FTelescopeStatus=Ok) then status:=Ok;
case source of
  server: Fserverstatus:=status;
  telescope: Ftelescopestatus:=status;
  coord: Fcoordstatus:=status;
end;
if assigned(FonStatusChange) then FonStatusChange(self,source,status);
if (source=server)and((status=Idle)or(Status=Alert)) then SetStatus(Telescope,status);
if (source=Telescope)and((status=Idle)or(Status=Alert)) then SetStatus(Coord,status);
except

end;
end;

procedure TIndiClient.ProcessData(line:string);
begin
FRecvData:=line;
{$ifdef darwin}
ProcessDataSyn;
{$else}
Synchronize(@ProcessDataSyn);
{$endif}
end;

procedure TIndiClient.ProcessDataSyn;
begin
try
//if Ftrace then  writetrace('Receive from telescope: '+FRecvData);;
XmlScanner.LoadFromBuffer(pchar(FRecvData));
XmlScanner.Execute;
if assigned(onReceiveData) then onReceiveData(self,FRecvData);
except
end;
end;

procedure TIndiClient.Send(const Value: string);
begin
 if Value>'' then begin
   Fsendbuffer:=Fsendbuffer+Value;
 end;
end;

procedure TIndiClient.XmlStartTag(Sender: TObject; TagName: String; Attributes: TAttrList);
var status:string;
    stat:TIndiStatus;
begin
FTag:=TagName;
FDevice:=Attributes.Value('device');
if (FDevice<>'') then begin
   if (FWantDevice<>'')and(pos(FWantDevice,FDevice)=0) then begin
      FDevice:='';
      FName:='';
      FCurrentDevice:='';
      FCurrentName:='';
      exit;
   end else begin
     FDeviceFound:=true;
     FCurrentDevice:=FDevice;
     FCurrentTag:=FTag;
     if (FDevice<>FWantDevice) then FWantDevice:=FDevice;
   end;
end;
FName:=Attributes.Value('name');
if (FDevice<>'')and(FName<>'') then begin
   FCurrentName:=FName;
end;
FPerm:=Attributes.Value('perm');
FMessage:=Attributes.Value('message');
if (FMessage<>'') and assigned(FonMessage) then FonMessage(self,FMessage);
status:=Attributes.Value('state');
if status='Ok' then stat:=Ok
else if status='Idle' then stat:=Idle
else if status='Busy' then stat:=Busy
else stat:=Alert;
if (status<>'')and(FCurrentname='CONNECTION') then setstatus(telescope,stat);
if (status<>'')and(FCurrentname='EQUATORIAL_EOD_COORD')and(pos('w',FPerm)>0) then begin FCOORD_REQUEST:=''; EOD:=true; setstatus(coord,stat);end;
if (status<>'')and(FCurrentname='EQUATORIAL_EOD_COORD_REQUEST')and(pos('w',FPerm)>0) then begin FCOORD_REQUEST:='_REQUEST'; EOD:=true; setstatus(coord,stat);end;
if (status<>'')and(FCurrentname='EQUATORIAL_COORD')and(pos('w',FPerm)>0) then begin FCOORD_REQUEST:=''; EOD:=false; setstatus(coord,stat);end;
if (status<>'')and(FCurrentname='EQUATORIAL_COORD_REQUEST')and(pos('w',FPerm)>0) then begin FCOORD_REQUEST:='_REQUEST'; EOD:=false; setstatus(coord,stat);end;
end;

procedure TIndiClient.XmlContent(Sender: TObject; Content: String);
begin
if FCurrentdevice='' then exit;
if (FCurrentname='DEVICE_PORT')and(Fname='PORT') then FDevicePort:=Content;
if (FCurrentname='EQUATORIAL_EOD_COORD')and(Fname='RA') then begin EOD:=true; FRa:=Content; end;
if (FCurrentname='EQUATORIAL_EOD_COORD')and(Fname='DEC') then begin EOD:=true; FDec:=Content; end;
if (FCurrentname='EQUATORIAL_COORD')and(Fname='RA') then begin EOD:=false; FRa:=Content; end;
if (FCurrentname='EQUATORIAL_COORD')and(Fname='DEC') then begin EOD:=false; FDec:=Content; end;
if Ftrace then writetrace(FCurrentdevice+blank+FCurrentname+blank+FName+blank+Content);
end;

procedure TIndiClient.XmlEndTag(Sender: TObject; TagName: String);
begin
if TagName=FTag then FTag:=''
else if TagName=FCurrentTag then begin
     FCurrentTag:='';
     if (FCurrentname='EQUATORIAL_EOD_COORD')and assigned(FonCoordChange) then FonCoordChange(self);
     if (FCurrentname='EQUATORIAL_COORD')and assigned(FonCoordChange) then FonCoordChange(self);
end;
end;

procedure TIndiClient.XmlEmptyTag(Sender: TObject; TagName: String; Attributes: TAttrList);
begin
FMessage:=Attributes.Value('message');
if (FMessage<>'') and assigned(FonMessage) then FonMessage(self,FMessage);
end;

procedure TIndiClient.SetPort(Value:string);
begin
if not FDeviceFound then exit;
FWantDevicePort:=Value;
Send('<newTextVector device="'+FWantDevice+'" name="DEVICE_PORT"><oneText name="PORT">'+FWantDevicePort+'</oneText></newTextVector>');
end;


procedure TIndiClient.getProperties;
begin
Send('<getProperties version="1.7"></getProperties>');
end;

procedure TIndiClient.Connect;
begin
if not FDeviceFound then exit;
if assigned(FonStatusChange) then FonStatusChange(self,telescope,busy);
if trim(FWantDevicePort)<>'' then SetPort(FWantDevicePort);
if Ftelescopestatus<>Ok then Send('<newSwitchVector device="'+ FWantDevice+'" name="CONNECTION"><oneSwitch name="CONNECT">On</oneSwitch></newSwitchVector>');
getProperties;
end;

procedure TIndiClient.Disconnect;
begin
if not FDeviceFound then exit;
if assigned(FonStatusChange) then FonStatusChange(self,telescope,busy);
Send('<newSwitchVector device="'+FWantDevice+'" name="CONNECTION"><oneSwitch name="DISCONNECT">On</oneSwitch></newSwitchVector>');
getProperties;
end;

procedure TIndiClient.Sync;
begin
if not FDeviceFound then exit;
Send('<newSwitchVector device="'+FWantDevice+'" name="ON_COORD_SET"><oneSwitch name="SLEW">Off</oneSwitch><oneSwitch name="TRACK">Off</oneSwitch><oneSwitch name="SYNC">On</oneSwitch></newSwitchVector>');
if EOD then
   Send('<newNumberVector device="'+FWantDevice+'" name="EQUATORIAL_EOD_COORD'+FCOORD_REQUEST+'"><oneNumber name="RA" >'+FWantRa+'</oneNumber><oneNumber name="DEC">'+FWantDec+'</oneNumber></newNumberVector>')
else
   Send('<newNumberVector device="'+FWantDevice+'" name="EQUATORIAL_COORD'+FCOORD_REQUEST+'"><oneNumber name="RA" >'+FWantRa+'</oneNumber><oneNumber name="DEC">'+FWantDec+'</oneNumber></newNumberVector>');
end;

procedure TIndiClient.Slew;
begin
if not FDeviceFound then exit;
Send('<newSwitchVector device="'+FWantDevice+'" name="ON_COORD_SET"><oneSwitch name="TRACK">Off</oneSwitch><oneSwitch name="SYNC">Off</oneSwitch><oneSwitch name="SLEW">On</oneSwitch></newSwitchVector>');
if EOD then
   Send('<newNumberVector device="'+FWantDevice+'" name="EQUATORIAL_EOD_COORD'+FCOORD_REQUEST+'"><oneNumber name="RA" >'+FWantRa+'</oneNumber><oneNumber name="DEC">'+FWantDec+'</oneNumber></newNumberVector>')
else
   Send('<newNumberVector device="'+FWantDevice+'" name="EQUATORIAL_COORD'+FCOORD_REQUEST+'"><oneNumber name="RA" >'+FWantRa+'</oneNumber><oneNumber name="DEC">'+FWantDec+'</oneNumber></newNumberVector>');
if assigned(FonStatusChange) then FonStatusChange(self,coord,busy);
end;

procedure TIndiClient.AbortSlew;
begin
if not FDeviceFound then exit;
Send('<newSwitchVector device="'+FWantDevice+'" name="ON_COORD_SET"><oneSwitch name="TRACK">On</oneSwitch><oneSwitch name="SYNC">Off</oneSwitch><oneSwitch name="SLEW">Off</oneSwitch></newSwitchVector>');
if EOD then
   Send('<newNumberVector device="'+FWantDevice+'" name="EQUATORIAL_EOD_COORD'+FCOORD_REQUEST+'"><oneNumber name="RA" >'+Fra+'</oneNumber><oneNumber name="DEC">'+Fdec+'</oneNumber></newNumberVector>')
else
   Send('<newNumberVector device="'+FWantDevice+'" name="EQUATORIAL_COORD'+FCOORD_REQUEST+'"><oneNumber name="RA" >'+Fra+'</oneNumber><oneNumber name="DEC">'+Fdec+'</oneNumber></newNumberVector>');
Send('<newSwitchVector device="'+FWantDevice+'" name="TELESCOPE_ABORT_MOTION"><oneSwitch name="ABORT">On</oneSwitch></newSwitchVector>');
end;

end.
