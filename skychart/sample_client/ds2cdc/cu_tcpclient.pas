unit cu_tcpclient;
{                                        
Copyright (C) 2003 Patrick Chevalley

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
Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
}
{
  TCP/IP client object thread for Cartes du Ciel
}

{$MODE Delphi}
interface

uses blcksock, Classes, SysUtils,
    Forms;

type
  TTCPclient = class(TSynaClient)
  private
    FSock: TTCPBlockSocket;
    FSendBuffer,FResultBuffer: string;
  public
    constructor Create;
    destructor Destroy; override;
    function Connect: Boolean;
    procedure Disconnect;
    function RecvString: string;
    function GetErrorDesc: string;
  published
    property Sock: TTCPBlockSocket read FSock;
    property SendBuffer: string read FSendBuffer write FSendBuffer;
    property ResultBuffer: string read FResultBuffer write FResultBuffer;
  end;

  TDataEvent = procedure(Sender : TObject; const data : string) of object;

  TClientThrd = class(TThread)
  private
    FTargetHost,FTargetPort,FErrorDesc,FRecvData,FClientId,FClientName : string;
    FTimeout : integer;
    FCmdTimeout : double;
    FInitializing : boolean;
    FReady : boolean;
    procedure SetCmdTimeout(value:double);
    function GetCmdTimeout:double;
    procedure DisplayMessagesyn;
    procedure ProcessDataSyn;
    procedure DisplayMessage(msg:string);
    procedure ProcessData(line:string);
  public
    onShowMessage: TDataEvent;
    onReceiveData: TDataEvent;
    TcpClient : TTcpclient;
    Constructor Create;
    procedure Execute; override;
    function Send(const Value: string):string;
  published
    property Terminated;
    property Ready : boolean read FReady;
    property Initializing : boolean read FInitializing;
    property TargetHost : string read FTargetHost write FTargetHost;
    property TargetPort : string read FTargetPort write FTargetPort;
    property Timeout : integer read FTimeout write FTimeout;
    property CmdTimeout: double read GetCmdTimeout write SetCmdTimeout;
    property ErrorDesc : string read FErrorDesc;
    property RecvData : string read FRecvData;
    property ClientId : string read FClientId;
    property ClientName : string read FClientName;
  end;

const msgTimeout='Timeout!';
      msgOK='OK';
      msgFailed='Failed!';
      msgBye='Bye!';

implementation

constructor TTCPclient.Create;
begin
  inherited Create;
  FSock := TTCPBlockSocket.Create;
  Fsendbuffer:='';
  Fresultbuffer:='';
end;

destructor TTCPclient.Destroy;
begin
  FSock.Free;
  inherited Destroy;
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
begin
  Result := FSock.RecvTerminated(FTimeout, crlf);
end;

function TTCPclient.GetErrorDesc: string;
begin
  Result := FSock.GetErrorDesc(FSock.LastError);
end;

procedure TClientThrd.SetCmdTimeout(value:double);
begin
 FCmdTimeout := value / 86400;  // store timeout value in days
end;

function TClientThrd.GetCmdTimeout:double;
begin
 result := FCmdTimeout * 86400;
end;

Constructor TClientThrd.Create ;
begin
freeonterminate:=true;
FInitializing:=false;
FReady:=false;
// start suspended to let time to the main thread to set the parameters
inherited create(true);
end;

procedure TClientThrd.Execute;
var buf:string;
    dateto : double;
    i : integer;
    ending : boolean;
begin
ending:=false;
FInitializing:=true;
FReady:=false;
tcpclient:=TTCPClient.Create;
try
 tcpclient.TargetHost:=FTargetHost;
 tcpclient.TargetPort:=FTargetPort;
 tcpclient.Timeout := FTimeout;
 // connect
 if tcpclient.Connect then begin
    // wait connect message
    dateto:=now+Fcmdtimeout;
    repeat
      buf:=tcpclient.recvstring;
      if (buf='')or(buf='.') then continue;  // keepalive
      if copy(buf,1,1)='>' then ProcessData(buf) // mouse click
      else
        if copy(buf,1,2)=msgOK then begin
           // success, parse response
           ProcessData(buf);
           i:=pos('id=',buf);
           Fclientid:=trim(copy(buf,i+3,2));
           i:=pos('chart=',buf);
           buf:=copy(buf,i+6,999)+' ';
           i:=pos(' ',buf);
           FclientName:=trim(copy(buf,1,i-1));
           break;
        end else begin
           // failure, close thread
           ProcessData(buf);
           terminate;
           break;
        end;
   until now>dateto;
   if tcpclient.resultbuffer='' then tcpclient.resultbuffer:=msgTimeout;
   DisplayMessage(tcpclient.GetErrorDesc);
   // main loop
   repeat
     if terminated then break;
     FReady:=true;
     FInitializing:=false;
     // handle unattended messages (mouseclick...)
     buf:=tcpclient.recvstring;
     if buf=msgBye then ending:=true;
     if ending then break;
     if (tcpclient.FSock.LastError<>10060)and(tcpclient.FSock.LastError<>0) then break;
     if (buf<>'')and(buf<>'.') then ProcessData(buf);
     // handle synchronous command and response
     if tcpclient.sendbuffer<>'' then begin
        tcpclient.resultbuffer:='';
        // send command
        tcpclient.Sock.SendString(tcpclient.sendbuffer+crlf);
        if tcpclient.FSock.LastError<>0 then begin
           terminate;
           break;
        end;
        tcpclient.sendbuffer:='';
        // wait response
        dateto:=now+Fcmdtimeout;
        repeat
          buf:=tcpclient.recvstring;
          if (buf='')or(buf='.') then continue;  // keepalive
          if copy(buf,1,1)='>' then ProcessData(buf) // mouse click
             else tcpclient.resultbuffer:=buf;   // set result
        until (tcpclient.resultbuffer>'')or(now>dateto);
        if tcpclient.resultbuffer='' then tcpclient.resultbuffer:=msgTimeout;
     end;
   until false;
 end;
//DisplayMessage(tcpclient.GetErrorDesc);
finally
FReady:=false;
terminate;
tcpclient.Disconnect;
tcpclient.Free;
end;
end;

procedure TClientThrd.DisplayMessage(msg:string);
begin
FErrorDesc:=msg;
Synchronize(DisplayMessageSyn);
end;

procedure TClientThrd.DisplayMessageSyn;
begin
if assigned(onShowMessage) then onShowMessage(self,FErrorDesc);
end;

procedure TClientThrd.ProcessData(line:string);
begin
FRecvData:=line;
Synchronize(ProcessDataSyn);
end;

procedure TClientThrd.ProcessDataSyn;
begin
if assigned(onReceiveData) then onReceiveData(self,FRecvData);
end;

function TClientThrd.Send(const Value: string):string;
// this function is called in the main thread only!
var dateto:double;
begin
 tcpclient.resultbuffer:='';
 if Value>'' then begin
   tcpclient.sendbuffer:=Value;
   // set a double timeout just in case Execute is no more running.
   dateto:=now+2*Fcmdtimeout;
   while (tcpclient.resultbuffer='')and(now<dateto) do application.ProcessMessages;
 end;
 if tcpclient.resultbuffer='' then tcpclient.resultbuffer:=msgTimeout;
 result:=tcpclient.resultbuffer;
end;

end.
