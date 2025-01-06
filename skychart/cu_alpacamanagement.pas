unit cu_alpacamanagement;

{$mode objfpc}{$H+}

{
Copyright (C) 2019 Patrick Chevalley

http://www.ap-i.net
pch@ap-i.net

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.

}
{
  Implement the ASCOM Alpaca Management and Discovery API
  https://ascom-standards.org
}

interface

uses
 {$IFDEF WINDOWS}
 Variants, comobj, ActiveX,
 {$ENDIF}
  cu_ascomrest, u_util, synaip,
  httpsend, synautil, fpjson, jsonparser, blcksock, synsock,
  process, Forms, Dialogs, Classes, SysUtils;

const AlpacaCurrentVersion = 1;
      DefaultPort = 32227;
      AlpacaDiscStr = 'alpacadiscovery1';
      DiscoverTimeout = 1000;

Type
  TAlpacaDevice = record
    DeviceName, DeviceType, DeviceId: string;
    DeviceNumber: integer;
  end;
  TAlpacaDeviceList = array of TAlpacaDevice;
  TAlpacaServer = record
     ip,port: string;
     servername,manufacturer,version,location,errormsg: string;
     apiversion, devicecount: integer;
     devices: TAlpacaDeviceList;
  end;
  TAlpacaServerList = array of TAlpacaServer;

  TDiscoverThread = class(TThread)
  public
    working: boolean;
    port: integer;
    ServerList: TAlpacaServerList;
    procedure Execute; override;
    constructor Create(CreateSuspended: boolean);
  end;


var
    AlpacaDiscPort: string;
    FClientId: integer = 1;
    FClientTransactionID: integer =0;
    FLastErrorCode: integer;
    FLastError: string;

function AlpacaDiscover(dport:integer=DefaultPort): TAlpacaServerList;
function AlpacaDiscoverServer: TAlpacaServerList;
procedure AlpacaServerDescription(var srv:TAlpacaServer);
function AlpacaApiVersions(ip,port: string): IIntArray;
function AlpacaDevices(ip,port,apiversion: string):TAlpacaDeviceList;
procedure AlpacaServerSetup(srv: TAlpacaServer);
procedure AlpacaDeviceSetup(srv: TAlpacaServer; dev:TAlpacaDevice);

implementation

function AlpacaDiscover(dport:integer=DefaultPort): TAlpacaServerList;
var thread:TDiscoverThread;
    timelimit: double;
begin
  thread:=TDiscoverThread.Create(true);
  thread.port:=dport;
  thread.Start;
  timelimit:=now+15/SecsPerDay;
  repeat
    sleep(50);
    Application.ProcessMessages;
  until (not thread.working) or (now > timelimit);
  result:=thread.ServerList;
  thread.Free;
end;

function AlpacaDiscoverBlocking(dport:integer=DefaultPort): TAlpacaServerList;
var apiversions: array of integer;
    i,j: integer;
begin
  AlpacaDiscPort:=inttostr(dport);
  result:=AlpacaDiscoverServer;
  for i:=0 to Length(result)-1 do begin
    result[i].apiversion:=-1;
    result[i].devicecount:=0;
    SetLength(result[i].devices,0);
    SetLength(apiversions,0);
    try
    apiversions:=AlpacaApiVersions(result[i].ip,result[i].port);
    for j:=0 to Length(apiversions)-1 do begin
      if apiversions[j]=AlpacaCurrentVersion then result[i].apiversion:=AlpacaCurrentVersion;
    end;
    except
      result[i].apiversion:=-1;
    end;
    if result[i].apiversion=AlpacaCurrentVersion then begin
      try
      AlpacaServerDescription(result[i]);
      result[i].devices:=AlpacaDevices(result[i].ip,result[i].port,IntToStr(result[i].apiversion));
      result[i].devicecount:=length(result[i].devices);
      except
        on E: Exception do result[i].errormsg:=E.Message;
      end;
    end;
  end;
end;

function GetBroadcastAddrList: TStringList;
var
  sl: TStringList;
  s: string;
  i: integer;
  f_loopback,f_broadcast: boolean;
  {$IFDEF UNIX}
  AProcess: TProcess;
  processok,newformat: boolean;
  buf: string;
  jl,ja,jf: TJSONData;
  j,n,l: integer;
  {$ENDIF}
  {$IFDEF WINDOWS}
  ip,mask: string;
  ipb,maskb,br: Integer;
  hasIP, hasMask: boolean;
  FSWbemLocator : OLEVariant;
  FWMIService   : OLEVariant;
  FWbemObjectSet: OLEVariant;
  FWbemObject   : OLEVariant;
  oEnum         : IEnumvariant;
  iValue        : LongWord;
const
  wbemFlagForwardOnly = $00000020;
  {$ENDIF}
begin
  Result:=TStringList.Create;
  sl:=TStringList.Create();
  {$IFDEF WINDOWS}
  FSWbemLocator := CreateOleObject('WbemScripting.SWbemLocator');
  FWMIService   := FSWbemLocator.ConnectServer('localhost', 'root\CIMV2', '', '');
  FWbemObjectSet:= FWMIService.ExecQuery('SELECT IPAddress,IPSubnet FROM Win32_NetworkAdapterConfiguration','WQL',wbemFlagForwardOnly);
  oEnum         := IUnknown(FWbemObjectSet._NewEnum) as IEnumVariant;
  // loop all interfaces
  while oEnum.Next(1, FWbemObject, iValue) = 0 do
  begin
    hasIP:=false;
    hasMask:=false;
    if not VarIsClear(FWbemObject.IPAddress) and not VarIsNull(FWbemObject.IPAddress) then begin
     // this interface address is assigned
     for i := VarArrayLowBound(FWbemObject.IPAddress, 1) to VarArrayHighBound(FWbemObject.IPAddress, 1) do begin
       ip:=String(FWbemObject.IPAddress[i]);
       if pos(':',ip)>0 then continue; // TODO: IPv6
       hasIP:=true;
       break;
     end;
     if not VarIsClear(FWbemObject.IPSubnet) and not VarIsNull(FWbemObject.IPSubnet) then begin
      // mask assigned
      for i := VarArrayLowBound(FWbemObject.IPSubnet, 1) to VarArrayHighBound(FWbemObject.IPSubnet, 1) do begin
        mask:=String(FWbemObject.IPSubnet[i]);
        if pos('.',mask)=0 then continue; // TODO: IPv6
        hasMask:=true;
        break;
      end;
     end;
     if hasIP and hasMask then begin
       ipb:=StrToIp(ip);
       maskb:=StrToIp(mask);
       br:=(ipb and maskb) or (not maskb);
       s:=IpToStr(br);
       Result.Add(Trim(s));
     end;
    end;
    FWbemObject:=Unassigned;
  end;
  {$ENDIF}
  {$IFDEF UNIX}
  // Try to use ip with json output
  AProcess:=TProcess.Create(nil);
  AProcess.Executable := '/sbin/ip';
  AProcess.Parameters.Add('-json');
  AProcess.Parameters.Add('address');
  AProcess.Options := AProcess.Options + [poUsePipes, poWaitOnExit];
  try
    try
    AProcess.Execute();
    processok:=(AProcess.ExitStatus=0);
    except
      processok:=false;
    end;
    sl.LoadFromStream(AProcess.Output);
  finally
    AProcess.Free();
  end;
  if processok then begin
    buf:='';
    for i:=0 to sl.Count-1 do
      buf:=buf+sl[i];
    jl:=GetJSON(buf);
    try
    for i:=0 to jl.Count-1 do begin
      f_loopback:=false; f_broadcast:=false;
      if jl.Items[i].FindPath('flags')<>nil then begin
        jf:=jl.Items[i].FindPath('flags');
        for j:=0 to jf.Count-1 do begin
          buf:=jf.Items[j].AsString;
          if buf='LOOPBACK' then f_loopback:=true;
          if buf='BROADCAST' then f_broadcast:=true;
        end;
      end;
      ja:=jl.Items[i].FindPath('addr_info');
      if ja<>nil then for j:=0 to ja.Count-1 do begin
        if ja.Items[j].FindPath('family')=nil then Continue;
        buf:=ja.Items[j].FindPath('family').AsString;
        if buf='inet' then begin
         if f_loopback then begin
          if ja.Items[j].FindPath('local')=nil then Continue;
          s:=ja.Items[j].FindPath('local').AsString;
          Result.Add(Trim(s));
         end
         else if f_broadcast then begin
          if ja.Items[j].FindPath('broadcast')=nil then Continue;
          s:=ja.Items[j].FindPath('broadcast').AsString;
          Result.Add(Trim(s));
         end;
        end;
      end;
    end;
    finally
      jl.Free;
    end;
  end
  else begin
    // try to use ifconfig
    AProcess:=TProcess.Create(nil);
    AProcess.Executable := '/sbin/ifconfig';
    AProcess.Parameters.Add('-a');
    AProcess.Options := AProcess.Options + [poUsePipes, poWaitOnExit];
    try
      try
      AProcess.Execute();
      processok:=(AProcess.ExitStatus=0);
      except
        processok:=false;
      end;
      sl.LoadFromStream(AProcess.Output);
    finally
      AProcess.Free();
    end;
    if sl.Count>0 then begin
      newformat:=pos('Link encap:',sl[0])=0;
      if newformat then begin // new ifconfig format
        for i:=0 to sl.Count-1 do
        begin
          n:=pos('flags=',sl[i]);
          if n>0 then begin // new interface
            f_loopback:=pos('LOOPBACK',sl[i])>0;
            f_broadcast:=pos('BROADCAST',sl[i])>0;
          end;
          if f_broadcast then begin
            n:=Pos('broadcast ', sl[i]);
            if n=0 then Continue;
            s:=Copy(sl[i], n+10, 999);
            n:=Pos(' ', s);
            if n>0 then s:=Copy(s, 1, n);
            Result.Add(Trim(s));
          end;
          if f_loopback then begin
            n:=Pos('inet ', sl[i]);
            if n=0 then Continue;
            s:=Copy(sl[i], n+5, 999);
            n:=Pos(' ', s);
            if n>0 then s:=Copy(s, 1, n);
            Result.Add(Trim(s));
          end;
        end;
      end
      else begin // old format
        for i:=0 to sl.Count-1 do
        begin
          n:=pos('Link encap:',sl[i]);
          if n>0 then begin // new interface
            f_loopback:=pos('Local Loopback',sl[i])>0;
            f_broadcast:=not f_loopback;
          end;
          if f_broadcast then begin
            n:=Pos('Bcast:', sl[i]);
            if n=0 then Continue;
            s:=Copy(sl[i], n+6, 999);
            n:=Pos(' ', s);
            if n>0 then s:=Copy(s, 1, n);
            Result.Add(Trim(s));
          end;
          if f_loopback then begin
            n:=Pos('inet addr:', sl[i]);
            if n=0 then Continue;
            s:=Copy(sl[i], n+10, 999);
            n:=Pos(' ', s);
            if n>0 then s:=Copy(s, 1, n);
            Result.Add(Trim(s));
          end;
        end;
      end;
    end;
  end;
  {$ENDIF}
  sl.Free();
  f_loopback:=false;
  for i:=0 to Result.Count-1 do begin
    if copy(Result[i],1,3)='127' then f_loopback:=true;
  end;
  if not f_loopback then Result.Add('127.0.0.1');
end;

function GetInsensitivePath(src:TJSONData; path:string):TJSONData;
var i: integer;
begin
  i:=TJSONObject(src).IndexOfName(path,true);
  if i>=0 then
     result:=TJSONObject(src).Items[i].GetPath('')
  else
     result:=nil;
end;

function AlpacaDiscoverServer: TAlpacaServerList;
var sock : TUDPBlockSocket;
    brip,ip,port,id:string;
    data: array[0..1024] of char;
    p: pointer;
    i,n,k: integer;
    ok,duplicate: boolean;
    blist: TStringList;
    Fjson: TJSONData;
begin
  blist:=GetBroadcastAddrList;
  sock := TUDPBlockSocket.create;
  sock.enablebroadcast(true);
  setlength(result,0);
  k:=0;
  for n:=0 to blist.Count-1 do begin
    brip:=blist[n];
    sock.Connect(brip, AlpacaDiscPort);
    data:=AlpacaDiscStr;
    p:=@data;
    sock.SendBuffer(p,length(AlpacaDiscStr));
    sock.SendBuffer(p,length(AlpacaDiscStr));
    repeat
      ok:=sock.CanRead(DiscoverTimeout);
      if ok then begin
        i:=sock.RecvBuffer(p,1024);
        if i<=0 then Continue;
        ip:=''; port:=''; id:=''; duplicate:=false;
        {$IFDEF WINDOWS}
        for i:=0 to 3 do   // TODO: synapse or rtl bug?
        {$ELSE}
        for i:=1 to 4 do
        {$ENDIF}
          ip:=ip+inttostr(sock.RemoteSin.sin_addr.s_bytes[i])+'.';
        delete(ip,length(ip),1);
        Fjson:=GetJSON(data);
        if Fjson<>nil then begin
            try
            port:=GetInsensitivePath(Fjson,'AlpacaPort').AsString;
            except
              // not a alpaca response
              Fjson.Free;
              continue;
            end;
        end;
        Fjson.Free;
        for i:=0 to Length(result)-1 do begin
           if (result[i].ip=ip)and(result[i].port=port) then duplicate:=true;
        end;
        if not duplicate then begin
          inc(k);
          SetLength(result,k);
          result[k-1].ip:=ip;
          result[k-1].port:=port;
        end;
      end;
    until not ok;
  end;
  sock.Free;
  blist.Free;
end;

function ManagementGet(url:string; param: string=''):TAscomResult;
 var ok: boolean;
     i: integer;
     RESTRequest: THTTPthread;
 begin
   RESTRequest:=THTTPthread.Create;
   try
   RESTRequest.http.Document.Clear;
   RESTRequest.http.Headers.Clear;
   RESTRequest.http.Timeout:=DiscoverTimeout;
   if param>'' then begin
      url:=url+'?'+param+'&ClientID='+IntToStr(FClientId);
   end
   else begin
      url:=url+'?ClientID='+IntToStr(FClientId);
   end;
   inc(FClientTransactionID);
   url:=url+'&ClientTransactionID='+IntToStr(FClientTransactionID);
   RESTRequest.url:=url;
   RESTRequest.method:='GET';
   RESTRequest.Start;
   while not RESTRequest.Finished do begin
     sleep(100);
     if GetCurrentThreadId=MainThreadID then Application.ProcessMessages;
   end;
   ok := RESTRequest.ok;
   if ok then begin
     if (RESTRequest.http.ResultCode=200) then begin
       RESTRequest.http.Document.Position:=0;
       Result:=TAscomResult.Create;
       Result.data:=TJSONObject(GetJSON(RESTRequest.http.Document));
       try
       FLastErrorCode:=Result.GetName('ErrorNumber').AsInteger;
       FLastError:=Result.GetName('ErrorMessage').AsString;
       except
        FLastErrorCode:=0;
        FLastError:='Missing error message from server';
       end;
       if FLastErrorCode<>0 then begin
          Result.Free;
          raise EAscomException.Create(FLastError);
       end;
     end
     else begin
       FLastErrorCode:=RESTRequest.http.ResultCode;
       FLastError:=RESTRequest.http.ResultString;
       i:=pos('<br>',FLastError);
       if i>0 then FLastError:=copy(FLastError,1,i-1);
       raise EApiException.Create(FLastError);
     end;
   end
   else begin
     FLastErrorCode:=RESTRequest.http.Sock.LastError;
     FLastError:=RESTRequest.http.Sock.LastErrorDesc;
     raise ESocketException.Create(url+' '+FLastError);
   end;
   finally
     RESTRequest.Free;
   end;
 end;

procedure AlpacaServerDescription(var srv:TAlpacaServer);
var J: TAscomResult;
    d: TJSONData;
begin
  J:=ManagementGet('http://'+srv.ip+':'+srv.port+'/management/v'+IntToStr(srv.apiversion)+'/description');
  try
    try
      d:=J.GetName('Value');
      try
      srv.servername:=GetInsensitivePath(d,'ServerName').AsString;
      except
       srv.servername:='';
      end;
      try
      srv.manufacturer:=GetInsensitivePath(d,'Manufacturer').AsString;
      except
       srv.manufacturer:='';
      end;
      try
      srv.version:=GetInsensitivePath(d,'ManufacturerVersion').AsString;
      except
       srv.version:='';
      end;
      try
      srv.location:=GetInsensitivePath(d,'Location').AsString;
      except
       srv.location:='';
      end;
    except
     srv.servername:='';
     srv.manufacturer:='';
     srv.version:='';
     srv.location:='';
    end;
  finally
    J.Free;
  end;
end;

function AlpacaApiVersions(ip,port: string): IIntArray;
begin
  result:=ManagementGet('http://'+ip+':'+port+'/management/apiversions').AsIntArray;
end;

function AlpacaDevices(ip,port,apiversion: string):TAlpacaDeviceList;
var J: TAscomResult;
    d: TJSONArray;
    i,n: integer;
begin
  J:=ManagementGet('http://'+ip+':'+port+'/management/v'+apiversion+'/configureddevices');
  try
    d:=TJSONArray(J.GetName('Value'));
    n:=d.Count;
    SetLength(Result,n);
    for i:=0 to n-1 do begin
      Result[i].DeviceName:=GetInsensitivePath(d.Objects[i],'DeviceName').AsString;
      Result[i].DeviceType:=GetInsensitivePath(d.Objects[i],'DeviceType').AsString;
      Result[i].DeviceNumber:=GetInsensitivePath(d.Objects[i],'DeviceNumber').AsInteger;
      Result[i].DeviceId:=GetInsensitivePath(d.Objects[i],'UniqueID').AsString;
    end;
  finally
    J.Free;
  end;
end;

procedure AlpacaServerSetup(srv: TAlpacaServer);
begin
  ExecuteFile('http://'+srv.ip+':'+srv.port+'/setup');
end;

procedure AlpacaDeviceSetup(srv: TAlpacaServer; dev:TAlpacaDevice);
begin
  ExecuteFile('http://'+srv.ip+':'+srv.port+'/setup/v'+IntToStr(srv.apiversion)+'/'+LowerCase(dev.DeviceType)+'/'+IntToStr(dev.DeviceNumber)+'/setup');
end;

//////////////////// TDiscoverThread /////////////////////////

constructor TDiscoverThread.Create(CreateSuspended: boolean);
begin
  FreeOnTerminate := False;
  inherited Create(CreateSuspended);
  working := True;
end;

procedure TDiscoverThread.Execute;
begin
  try
  {$IFDEF WINDOWS}
  CoInitialize(nil);
  {$ENDIF}
  ServerList:=AlpacaDiscoverBlocking(port);
  finally
  working := False;
  {$IFDEF WINDOWS}
  CoUninitialize;
  {$ENDIF}
  end;
end;


end.

