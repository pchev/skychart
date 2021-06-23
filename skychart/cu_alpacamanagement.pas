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

uses cu_ascomrest, u_util,
  httpsend, synautil, fpjson, jsonparser, blcksock, synsock,
  process, Forms, Dialogs, Classes, SysUtils;

const AlpacaCurrentVersion = 1;
      DefaultPort = 32227;
      AlpacaDiscStr = 'alpacadiscovery1';
      DiscoverTimeout = 3000;

Type
  TAlpacaDevice = record
    DeviceName, DeviceType, DeviceId: string;
    DeviceNumber: integer;
  end;
  TAlpacaDeviceList = array of TAlpacaDevice;
  TAlpacaServer = record
     ip,port: string;
     servername,manufacturer,version,location: string;
     apiversion, devicecount: integer;
     devices: TAlpacaDeviceList;
  end;
  TAlpacaServerList = array of TAlpacaServer;

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
      result[i].apiversion:=1;
    end;
    if result[i].apiversion=AlpacaCurrentVersion then begin
      try
      AlpacaServerDescription(result[i]);
      result[i].devices:=AlpacaDevices(result[i].ip,result[i].port,IntToStr(result[i].apiversion));
      result[i].devicecount:=length(result[i].devices);
      except
        on E: Exception do ShowMessage('Alpaca server at '+result[i].ip+':'+result[i].port+' report: '+CRLF+ E.Message);
      end;
    end;
  end;
end;

function GetBroadcastAddrList: TStringList;
var
  AProcess: TProcess;
  s: string;
  sl: TStringList;
  i, n: integer;
  {$IFDEF WINDOWS}
  j: integer;
  ip,mask: string;
  b,b1,b2: byte;
  hasIP, hasMask: boolean;
  {$ENDIF}
begin
  Result:=TStringList.Create;
  sl:=TStringList.Create();
  {$IFDEF WINDOWS}
  Result.Add('127.0.0.1'); // local loopback not listed by ipconfig
  AProcess:=TProcess.Create(nil);
  AProcess.Executable := 'ipconfig.exe';
  AProcess.Options := AProcess.Options + [poUsePipes, poNoConsole];
  try
    AProcess.Execute();
    Sleep(500); // poWaitOnExit not working as expected
    sl.LoadFromStream(AProcess.Output);
  finally
    AProcess.Free();
  end;
  hasIP:=false;
  hasMask:=false;
  for i:=0 to sl.Count-1 do //!response text are localized!
  begin
    if (Pos('IPv4', sl[i])>0) or (Pos('IP-', sl[i])>0) or (Pos('IP Address', sl[i])>0) then begin
      s:=sl[i];
      ip:=Trim(Copy(s, Pos(':', s)+1, 999));
      if Pos(':', ip)>0 then Continue; // TODO: IPv6
      hasIP:=true;
    end;
    if (Pos('Mask', sl[i])>0) or (Pos(': 255', sl[i])>0) then begin
      s:=sl[i];
      mask:=Trim(Copy(s, Pos(':', s)+1, 999));
      if Pos(':', mask)>0 then Continue; // TODO: IPv6
      hasMask:=true;
    end;
    if hasIP and hasMask then begin
      s:='';
      try
      for j:=1 to 4 do begin
        n:=pos('.',ip);
        if n=0 then b1:=strtoint(ip)
               else b1:=strtoint(copy(ip,1,n-1));
        delete(ip,1,n);
        n:=pos('.',mask);
        if n=0 then b2:=strtoint(mask)
               else b2:=strtoint(copy(mask,1,n-1));
        delete(mask,1,n);
        b:=b1 or (not b2);
        s:=s+inttostr(b)+'.';
      end;
      delete(s,length(s),1);
      Result.Add(Trim(s));
      except
      end;
      hasIP:=false;
      hasMask:=false;
    end;
  end;
  {$ENDIF}
  {$IFDEF UNIX}
  AProcess:=TProcess.Create(nil);
  AProcess.Executable := '/sbin/ifconfig';
  AProcess.Parameters.Add('-a');
  AProcess.Options := AProcess.Options + [poUsePipes, poWaitOnExit];
  try
    AProcess.Execute();
    sl.LoadFromStream(AProcess.Output);
  finally
    AProcess.Free();
  end;

  for i:=0 to sl.Count-1 do
  begin
    n:=Pos('broadcast ', sl[i]);
    if n=0 then Continue;
    s:=sl[i];
    s:=Copy(s, n+Length('broadcast '), 999);
    n:=Pos(' ', s);
    if n>0 then s:=Copy(s, 1, n);
    Result.Add(Trim(s));
  end;
  {$ENDIF}
  sl.Free();
  if Result.Count=0 then
    Result.Add('255.255.255.255');
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
    d:=J.GetName('Value');
    srv.servername:=GetInsensitivePath(d,'ServerName').AsString;
    srv.manufacturer:=GetInsensitivePath(d,'Manufacturer').AsString;
    srv.version:=GetInsensitivePath(d,'ManufacturerVersion').AsString;
    srv.location:=GetInsensitivePath(d,'Location').AsString;
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

end.

