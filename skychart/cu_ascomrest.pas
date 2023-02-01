unit cu_ascomrest;

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
  Implement a client for the ASCOM Alpaca REST API
  https://ascom-standards.org
}

interface

uses httpsend, synautil, fpjson, jsonparser, base64,
  Forms, Classes, SysUtils;

type

  { THTTPthread }

  THTTPthread = class(TThread)
    private
      Fhttp: THTTPSend;
      Furl,Fmethod: String;
      Fok: boolean;
    public
      constructor Create;
      destructor Destroy; override;
      procedure Execute; override;
      property http: THTTPSend read Fhttp write Fhttp;
      property url: String read Furl write Furl;
      property method: String read Fmethod write Fmethod;
      property ok: boolean read Fok;
  end;

  { TAscomRest }

  EAscomException = class(Exception);
  EApiException = class(Exception);
  ESocketException = class(Exception);

  ITrackingRates = array of integer;
  IRate = class(TObject)
      Minimum, Maximum: double;
  end;
  IAxisRates = array of IRate;
  TImageArray = class(Tobject)
    nplane: integer;
    height,width: integer;
    img: array of array of array of integer;  // nplane, height, width
  end;
  IStringArray = array of string;
  IIntArray = array of integer;

  TAscomResult= class(TObject)
     protected
       Fdata: TJSONObject;
       function GetAsFloat: double;
       function GetAsInt: integer;
       function GetAsBool: boolean;
       function GetAsString: string;
       function GetAsStringArray: IStringArray;
       function GetIntArray: IIntArray;
     public
       base64handoff: boolean;
       constructor Create;
       destructor Destroy; override;
       function GetName(name: string): TJSONData;
       property data: TJSONObject read Fdata write Fdata;
       property AsFloat: double read GetAsFloat;
       property AsInt: Integer read GetAsInt;
       property AsBool: boolean read GetAsBool;
       property AsString: string read GetAsString;
       property AsStringArray: IStringArray read GetAsStringArray;
       property AsIntArray: IIntArray read GetIntArray;
  end;

  TAscomRest = class(TComponent)
  protected
    Fhost, Fport, Fprotocol, FDevice, FbaseUrl, FApiVersion, FRemoteIP: string;
    Fuser, Fpassword: string;
    FClientId,FClientTransactionID: LongWord;
    FTimeout: integer;
    FLastError: string;
    FLastErrorCode: integer;
    procedure SetBaseUrl;
    procedure SetHost(host: string);
    procedure SetPort(port: string);
    procedure SetProtocol(protocol: string);
    procedure SetApiVersion(v: string);
    procedure SetUser(u: string);
    procedure SetPassword(p: string);
    procedure SetClientId(i: LongWord);
    function GetTimeout: integer;
    procedure SetTimeout(value:integer);
    function GetImagearrayBase64:TMemoryStream;
    procedure WaitRequest(req: THTTPthread);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function Get(method:string; param: string=''; hdr: string=''):TAscomResult;
    function GetTrackingRates: ITrackingRates;
    function GetAxisRates(axis:string): IAxisRates;
    function GetImageArray: TImageArray;
    procedure Put(method: string; params:array of string); overload;
    procedure Put(method:string); overload;
    procedure Put(method,value:string); overload;
    procedure Put(method:string;value:double); overload;
    procedure Put(method:string;value:Boolean); overload;
    function PutR(method: string; params:array of string):TAscomResult;
    property Host: string read Fhost write SetHost;
    property Port: string read Fport write SetPort;
    property Protocol: string read Fprotocol write SetProtocol;
    property Device: string read FDevice write FDevice;
    property ApiVersion: string read FApiVersion write SetApiVersion;
    property User: string read Fuser write SetUser;
    property Password: string read Fpassword write SetPassword;
    property ClientId: LongWord read FClientId write SetClientId;
    property ClientTransactionID: LongWord read FClientTransactionID;
    property Timeout: integer read GetTimeout write SetTimeout;
    property LastError: string read FLastError;
    property LastErrorCode: integer read FLastErrorCode;
    property RemoteIP: string read FRemoteIP;

  end;


implementation

{ THTTPthread }

constructor THTTPthread.Create;
begin
  inherited Create(True);
  FreeOnTerminate:=False;
  Furl:='';
  Fmethod:='';
  Fok:=False;
  Fhttp:=THTTPSend.Create;
  Fhttp.Sock.ConnectionTimeout:=5000;  // not too long if service is not available
  Fhttp.Timeout:=5000;
  Fhttp.UserAgent:='';
end;

destructor THTTPthread.Destroy;
begin
   Fhttp.Free;
   inherited Destroy;
end;

procedure THTTPthread.Execute;
begin
  Fok:=Fhttp.HTTPMethod(method, fURL);
end;

{ TAscomResult }

constructor TAscomResult.Create;
begin
  inherited Create;
  data:=nil;
  base64handoff:=false;
end;

destructor TAscomResult.Destroy;
begin
  if data<>nil then data.free;
  inherited Destroy;
end;

function TAscomResult.GetName(name: string): TJSONData;
var i: integer;
begin
  result:=nil;
  if Fdata<>nil then begin
    i:=Fdata.IndexOfName(name,true);
    if i>=0 then
      Result:=Fdata.Items[i].GetPath('');
  end;
end;

function TAscomResult.GetAsFloat: Double;
begin
 Result:=GetName('Value').AsFloat;
 Free;
end;

function TAscomResult.GetAsInt: Integer;
begin
 Result:=GetName('Value').AsInteger;
 Free;
end;

function TAscomResult.GetAsBool: Boolean;
begin
  Result:=GetName('Value').AsBoolean;
  Free;
end;

function TAscomResult.GetAsString: string;
begin
   Result:=GetName('Value').AsString;
   Free;
end;

function TAscomResult.GetAsStringArray: IStringArray;
var i: integer;
begin
  with TJSONArray(GetName('Value')) do begin
    SetLength(Result,Count);
    for i:=0 to Count-1 do
      Result[i]:=Strings[i];
  end;
  Free;
end;

function TAscomResult.GetIntArray: IIntArray;
var i: integer;
begin
  with TJSONArray(GetName('Value')) do begin
    SetLength(Result,Count);
    for i:=0 to Count-1 do
      Result[i]:=Integers[i];
  end;
  Free;
end;

{ TAscomRest }

constructor TAscomRest.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Fprotocol:='http:';
  Fhost:='localhost';
  Fport:='11111';
  FRemoteIP:='';
  FTimeout:=5000;
  FDevice:='';
  Fuser:='';
  Fpassword:='';
  FClientId:=Random(High(LongWord));
  FClientTransactionID:=0;
  FApiVersion:='1';
  SetBaseUrl;
end;

destructor  TAscomRest.Destroy;
begin
  inherited Destroy;
end;

function TAscomRest.GetTimeout: integer;
begin
  result:=FTimeout;
end;

procedure TAscomRest.SetTimeout(value:integer);
begin
  FTimeout:=value;
end;

procedure TAscomRest.WaitRequest(req: THTTPthread);
var endt: double;
    aborted: boolean;
begin
  // ensure request time do not excess timeout
  endt:=now+FTimeout/MSecsPerDay;
  aborted:=false;
  while (not req.Finished)and(not aborted) do begin
    aborted:=(now>endt);
    sleep(10);
  end;
  if aborted then
     req.http.Abort;
end;

procedure TAscomRest.SetBaseUrl;
begin
  if (Fuser='')or(Fpassword='') then
     FbaseUrl:=Fprotocol+'//'+Fhost+':'+Fport+'/api/v'+FApiVersion+'/'
  else
     FbaseUrl:=Fprotocol+'//'+Fuser+':'+Fpassword+'@'+Fhost+':'+Fport+'/api/v'+FApiVersion+'/'
end;

procedure TAscomRest.SetProtocol(protocol: string);
begin
  if (protocol='http:')or(protocol='https:') then Fprotocol:=protocol;
  SetBaseUrl;
end;

procedure TAscomRest.SetApiVersion(v: string);
begin
  FApiVersion:=v;
  SetBaseUrl;
end;

procedure TAscomRest.SetHost(host: string);
begin
   Fhost:=host;
   SetBaseUrl;
end;

procedure TAscomRest.SetPort(port: string);
begin
   Fport:=port;
   SetBaseUrl;
end;

procedure TAscomRest.SetUser(u: string);
begin
   Fuser:=u;
   SetBaseUrl;
end;

procedure TAscomRest.SetPassword(p: string);
begin
   Fpassword:=p;
   SetBaseUrl;
end;

procedure TAscomRest.SetClientId(i: LongWord);
begin
  if i<10000 then i:=1000*i+Random(99); // program id + random id
  FClientId:=i;
end;

function TAscomRest.Get(method:string; param: string=''; hdr: string=''):TAscomResult;
 var ok: boolean;
     url,buf: string;
     i: integer;
     RESTRequest: THTTPthread;
 begin
   RESTRequest:=THTTPthread.Create;
   try
   RESTRequest.http.Document.Clear;
   RESTRequest.http.Headers.Clear;
   RESTRequest.http.Timeout:=FTimeout;
   RESTRequest.http.sock.SocksTimeout:=FTimeout;
   url:=FbaseUrl+LowerCase(Fdevice)+'/'+LowerCase(method);
   if param>'' then begin
      url:=url+'?'+param+'&ClientID='+IntToStr(FClientId);
   end
   else begin
      url:=url+'?ClientID='+IntToStr(FClientId);
   end;
   inc(FClientTransactionID);
   url:=url+'&ClientTransactionID='+IntToStr(FClientTransactionID);
   RESTRequest.url:=url;
   if hdr<>'' then RESTRequest.http.Headers.Add(hdr);
   RESTRequest.method:='GET';
   RESTRequest.Start;
   WaitRequest(RESTRequest);
   ok := RESTRequest.ok;
   if ok then begin
     if (RESTRequest.http.ResultCode=200) then begin
       try
       RESTRequest.http.Document.Position:=0;
       Result:=TAscomResult.Create;
       Result.data:=TJSONObject(GetJSON(RESTRequest.http.Document));
       if hdr<>'' then begin
         for i:=0 to RESTRequest.http.Headers.Count-1 do
           if Pos('base64handoff:', lowercase(RESTRequest.http.Headers[i])) = 1 then
           begin
             buf:=lowercase(trim(SeparateRight(RESTRequest.http.Headers[i], ':')));
             Result.base64handoff:=(buf='true');
           end;
       end;
       except
         FLastErrorCode:=500;
         FLastError:='Unknown error response from server';
         Result.Free;
         raise EApiException.Create(FLastError);
       end;
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
     raise ESocketException.Create(Fhost+':'+Fport+' '+FLastError);
   end;
   finally
     RESTRequest.Free;
   end;
 end;

function TAscomRest.GetTrackingRates: ITrackingRates;
var J: TAscomResult;
    i: integer;
begin
  J:=Get('trackingrates');
  try
  with TJSONArray(J.GetName('Value')) do begin
    SetLength(Result,Count);
    for i:=0 to Count-1 do
      Result[i]:=Integers[i];
  end;
  finally
    J.Free;
  end;
end;

function TAscomRest.GetAxisRates(axis:string): IAxisRates;
var J: TAscomResult;
    i,k,n: integer;
    r: IRate;
begin
  J:=Get('axisrates','axis='+axis);
  try
  with TJSONArray(J.GetName('Value')) do begin
    n:=Count;
    SetLength(Result,n);
    for i:=0 to n-1 do begin
      r:=IRate.Create;
      r.Minimum:=0;
      r.Maximum:=0;
      k:=Objects[i].IndexOfName('Maximum',true);
      if k>=0 then
        r.Maximum:=Objects[i].Items[k].GetPath('').AsFloat;
      k:=Objects[i].IndexOfName('Minimum',true);
      if k>=0 then
        r.Minimum:=Objects[i].Items[k].GetPath('').AsFloat;
      Result[i]:=r;
    end;
  end;
  finally
    J.Free;
  end;
end;

function TAscomRest.GetImagearrayBase64:TMemoryStream;
 var ok: boolean;
     i: integer;
     url: string;
     RESTRequest: THTTPthread;
 begin
   result:=nil;
   RESTRequest:=THTTPthread.Create;
   try
   RESTRequest.http.Document.Clear;
   RESTRequest.http.Headers.Clear;
   RESTRequest.http.Timeout:=FTimeout;
   url:=FbaseUrl+LowerCase(Fdevice)+'/imagearraybase64';
   RESTRequest.url:=url;
   RESTRequest.method:='GET';
   RESTRequest.Start;
   WaitRequest(RESTRequest);
   ok := RESTRequest.ok;
   if ok then begin
     if (RESTRequest.http.ResultCode=200) then begin
       RESTRequest.http.Document.Position:=0;
       Result:=TMemoryStream.Create;
       Result.CopyFrom(RESTRequest.http.Document,RESTRequest.http.Document.Size);
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
     raise ESocketException.Create(Fhost+':'+Fport+' '+FLastError);
   end;
   finally
     RESTRequest.Free;
   end;
 end;

function TAscomRest.GetImageArray: TImageArray;
var J: TAscomResult;
    str1,img: TMemoryStream;
    b64str: TBase64DecodingStream;
    x,y,k: integer;
begin
   J:=Get('imagearray','','base64handoff: true');
   try
   x:=J.GetName('Type').AsInteger;
   if x<>2 then
      raise EApiException.Create('Invalid ImageArray Type '+inttostr(x));

   Result:=TImageArray.Create;
   if J.base64handoff then begin
     str1:=GetImagearrayBase64;
     if (str1<>nil)and(str1.Size>0) then begin
       try
       img:=TMemoryStream.Create;
       try
       str1.Position:=0;
       b64str:=TBase64DecodingStream.Create(str1);
       img.CopyFrom(b64str, b64str.Size);
       finally
         str1.Free;
         b64str.Free;
       end;
       Result.nplane:=J.GetName('Rank').AsInteger;
       Result.width:=J.GetName('Dimension0Length').AsInteger;
       Result.height:=J.GetName('Dimension1Length').AsInteger;
       img.Position:=0;
       if result.nplane=2 then begin
         SetLength(Result.img,1,Result.height,Result.width);
         for x:=0 to Result.width-1 do begin
           for y:=0 to Result.height-1 do begin
              img.Read(Result.img[0,y,x],sizeof(integer));
           end;
         end;
       end
       else
       if result.nplane=3 then begin
         SetLength(Result.img,3,Result.height,Result.width);
         for x:=0 to Result.width-1 do begin
           for y:=0 to Result.height-1 do begin
             for k:=0 to 2 do begin
              img.Read(Result.img[k,y,x],sizeof(integer));
             end;
           end;
         end;
       end;
       finally
         img.free;
       end;
     end
     else begin
       FLastErrorCode:=500;
       FLastError:='Error: empty imagearraybase64';
       raise EApiException.Create(FLastError);
     end;
   end
   else begin
     Result.nplane:=J.GetName('Rank').AsInteger;
     if result.nplane=2 then begin
       with TJSONArray(J.GetName('Value')) do begin
         Result.width:=Count;
         Result.height:=Arrays[0].Count;
         SetLength(Result.img,1,Result.height,Result.width);
         for x:=0 to Count-1 do begin
           with Arrays[x] do begin
             for y:=0 to Count-1 do begin
                Result.img[0,y,x]:=Integers[y];
             end;
           end;
         end;
       end;
     end
     else
     if result.nplane=3 then begin
       with TJSONArray(J.GetName('Value')) do begin
         Result.width:=Count;
         Result.height:=Arrays[0].Count;
         SetLength(Result.img,3,Result.height,Result.width);
         for x:=0 to Count-1 do begin
           with Arrays[x] do begin
             for y:=0 to Count-1 do begin
               with Arrays[y] do begin
                 for k:=0 to 2 do begin
                   Result.img[k,y,x]:=Integers[k];
                 end; //k
               end;
             end; // y
           end;
         end; //x
       end;
     end;
   end;
   finally
     J.Free;
   end;
end;

function TAscomRest.PutR(method: string; params:array of string):TAscomResult;
var url,data: string;
    ok: boolean;
    i,n: integer;
    RESTRequest: THTTPthread;
begin
  RESTRequest:=THTTPthread.Create;
  try
  RESTRequest.http.Document.Clear;
  RESTRequest.http.Headers.Clear;
  RESTRequest.http.Timeout:=FTimeout;
  n:=Length(params);
  if n=0 then begin
    data:='ClientID='+IntToStr(FClientId)
  end
  else if n=1 then begin
    data:=params[0];
    data:=data+'&ClientID='+IntToStr(FClientId);
  end
  else begin
     i:=0;
     data:='';
     repeat
       data:=data+params[i]+'='+params[i+1]+'&';
       inc(i,2);
     until (i+1)>(n-1);
     if odd(n) then data:=data+params[n-1];
     if copy(data,length(data),1)='&' then data:=copy(data,1,length(data)-1);
     data:=data+'&ClientID='+IntToStr(FClientId);
  end;
  inc(FClientTransactionID);
  data:=data+'&ClientTransactionID='+IntToStr(FClientTransactionID);
  WriteStrToStream(RESTRequest.http.Document, data);
  RESTRequest.http.MimeType := 'application/x-www-form-urlencoded';
  url := FbaseUrl+LowerCase(Fdevice)+'/'+LowerCase(method);
  RESTRequest.url:=url;
  RESTRequest.method:='PUT';
  RESTRequest.Start;
  WaitRequest(RESTRequest);
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
    raise ESocketException.Create(Fhost+':'+Fport+' '+FLastError);
  end;
  finally
    RESTRequest.Free;
  end;
end;


procedure TAscomRest.Put(method: string; params:array of string); overload;
var J: TAscomResult;
    url,data: string;
    ok: boolean;
    i,n: integer;
    RESTRequest: THTTPthread;
    buf: array[0..512] of char;
begin
  RESTRequest:=THTTPthread.Create;
  try
  RESTRequest.http.Document.Clear;
  RESTRequest.http.Headers.Clear;
  RESTRequest.http.Timeout:=FTimeout;
  n:=Length(params);
  if n=0 then begin
    data:='ClientID='+IntToStr(FClientId)
  end
  else if n=1 then begin
    data:=params[0];
    data:=data+'&ClientID='+IntToStr(FClientId);
  end
  else begin
     i:=0;
     data:='';
     repeat
       data:=data+params[i]+'='+params[i+1]+'&';
       inc(i,2);
     until (i+1)>(n-1);
     if odd(n) then data:=data+params[n-1];
     if copy(data,length(data),1)='&' then data:=copy(data,1,length(data)-1);
     data:=data+'&ClientID='+IntToStr(FClientId);
  end;
  inc(FClientTransactionID);
  data:=data+'&ClientTransactionID='+IntToStr(FClientTransactionID);
  WriteStrToStream(RESTRequest.http.Document, data);
  RESTRequest.http.MimeType := 'application/x-www-form-urlencoded';
  url := FbaseUrl+LowerCase(Fdevice)+'/'+LowerCase(method);
  RESTRequest.url:=url;
  RESTRequest.method:='PUT';
  RESTRequest.Start;
  WaitRequest(RESTRequest);
  if method='Connected' then
    FRemoteIP:=RESTRequest.http.Sock.GetRemoteSinIP;
  ok := RESTRequest.ok;
  if ok then begin
    if (RESTRequest.http.ResultCode=200) then begin
      RESTRequest.http.Document.Position:=0;
      J:=TAscomResult.Create;
      J.data:=TJSONObject(GetJSON(RESTRequest.http.Document));
      try
      FLastErrorCode:=J.GetName('ErrorNumber').AsInteger;
      FLastError:=J.GetName('ErrorMessage').AsString;
      except
       FLastErrorCode:=0;
       FLastError:='Missing error message from server';
      end;
      J.Free;
      if FLastErrorCode<>0 then begin
         raise EAscomException.Create(FLastError);
      end;
    end
    else begin
      try
      RESTRequest.http.Document.Position:=0;
      n:=RESTRequest.http.Document.Read(buf,sizeof(buf));
      except
        buf:='';
      end;
      FLastErrorCode:=RESTRequest.http.ResultCode;
      FLastError:=RESTRequest.http.ResultString;
      i:=pos('<br>',FLastError);
      if i>0 then FLastError:=copy(FLastError,1,i-1);
      FLastError:=FLastError+trim(copy(buf,1,n));
      raise EApiException.Create(FLastError);
    end;
  end
  else begin
    FLastErrorCode:=RESTRequest.http.Sock.LastError;
    FLastError:=RESTRequest.http.Sock.LastErrorDesc;
    raise ESocketException.Create(Fhost+':'+Fport+' '+FLastError);
  end;
  finally
    RESTRequest.Free;
  end;
end;

procedure TAscomRest.Put(method:string); overload;
begin
  Put(method,[]);
end;

procedure TAscomRest.Put(method,value:string); overload;
begin
  Put(method,[method,value]);
end;

procedure TAscomRest.Put(method:string;value:double);  overload;
begin
  Put(method,[method,FloatToStr(value)]);
end;

procedure TAscomRest.Put(method:string;value:Boolean); overload;
begin
  Put(method,[method,BoolToStr(value,true)]);
end;


end.

