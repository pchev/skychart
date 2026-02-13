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

uses httpsend, synautil, synsock, fpjson, jsonparser, base64,
     ctypes, Forms, Classes, SysUtils;

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

  TImageBytesInfo = record
    MetadataVersion: cint;         // Bytes 0..3 - Metadata version = 1
    ErrorNumber: cint;             // Bytes 4..7 - Alpaca error number or zero for success
    ClientTransactionID: cuint;    // Bytes 8..11 - Client's transaction ID
    ServerTransactionID: cuint;    // Bytes 12..15 - Device's transaction ID
    DataStart: cint;               // Bytes 16..19 - Offset of the start of the data bytes = 36 for version 1
    ImageElementType: cint;        // Bytes 20..23 - Element type of the source image array
    TransmissionElementType: cint; // Bytes 24..27 - Element type as sent over the network
    Rank: cint;                    // Bytes 28..31 - Image array rank
    Dimension1: cint;              // Bytes 32..35 - Length of image array first dimension
    Dimension2: cint;              // Bytes 36..39 - Length of image array second dimension
    Dimension3: cint;              // Bytes 40..43 - Length of image array third dimension (0 for 2D array)
  end;
  TArrayByte = array of byte;
  TArrayInt16 = array of cint16;
  TArrayInt32 = array of cint32;
  TArrayUInt16 = array of cuint16;
  TArrayUInt32 = array of cuint32;

  TAscomResult= class(TObject)
     protected
       Fdata: TJSONObject;
       FImageBytesInfo: TImageBytesInfo;
       FArrayByte: TArrayByte;
       FArrayInt16: TArrayInt16;
       FArrayInt32: TArrayInt32;
       FArrayUInt16: TArrayUInt16;
       FArrayUInt32: TArrayUInt32;
       function GetAsFloat: double;
       function GetAsInt: integer;
       function GetAsBool: boolean;
       function GetAsString: string;
       function GetAsStringArray: IStringArray;
       function GetIntArray: IIntArray;
     public
       base64handoff: boolean;
       imagebytes: boolean;
       constructor Create;
       destructor Destroy; override;
       function GetName(name: string): TJSONData;
       property ImageBytesInfo: TImageBytesInfo read FImageBytesInfo;
       property ArrayByte: TArrayByte read FArrayByte;
       property ArrayInt16: TArrayInt16 read FArrayInt16;
       property ArrayInt32: TArrayInt32 read FArrayInt32;
       property ArrayUInt16: TArrayUInt16 read FArrayUInt16;
       property ArrayUInt32: TArrayUInt32 read FArrayUInt32;
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
    function PutR(method: string; params: array of string):TAscomResult;
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

  const StdTimeout = 5000;     // 5 seconds for standard request
        LongTimeout = 120000;  // 2 minutes for long synchronous request


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
  Fhttp.KeepAlive:=false;              // always close connection
  Fhttp.Sock.ConnectionTimeout:=StdTimeout;
  Fhttp.Timeout:=StdTimeout;
  Fhttp.UserAgent:='';
end;

destructor THTTPthread.Destroy;
begin
   Fhttp.Free;
   inherited Destroy;
end;

procedure THTTPthread.Execute;
var retry: integer;
begin
  retry:=0;
  repeat
    Fok:=Fhttp.HTTPMethod(method, fURL);
    if not Fok then begin
      if Fhttp.Sock.LastError=WSAECONNREFUSED then begin
        sleep(1000);
      end
      else begin
         break;
      end;
    end;
    inc(retry);
  until Fok or (retry>10);
end;


{ TAscomResult }

constructor TAscomResult.Create;
begin
  inherited Create;
  data:=nil;
  base64handoff:=false;
  imagebytes:=false;
end;

destructor TAscomResult.Destroy;
begin
  if data<>nil then data.free;
  SetLength(FArrayByte,0);
  SetLength(FArrayInt16,0);
  SetLength(FArrayInt32,0);
  SetLength(FArrayUInt16,0);
  SetLength(FArrayUInt32,0);
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
  FTimeout:=StdTimeout;
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
     errmsg: array[0..1024] of char;
     i: integer;
     RESTRequest: THTTPthread;
 begin
   RESTRequest:=THTTPthread.Create;
   try
   RESTRequest.http.Document.Clear;
   RESTRequest.http.Headers.Clear;
   RESTRequest.http.Timeout:=FTimeout;
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
   while not RESTRequest.Finished do begin
     sleep(5);
     if GetCurrentThreadId=MainThreadID then Application.ProcessMessages;
   end;
   ok := RESTRequest.ok;
   if ok then begin
     if (RESTRequest.http.ResultCode=200) then begin
       Result:=TAscomResult.Create;
       if hdr<>'' then begin
         for i:=0 to RESTRequest.http.Headers.Count-1 do
           if Pos('content-type', lowercase(RESTRequest.http.Headers[i])) = 1 then
           begin
             buf:=lowercase(trim(SeparateRight(RESTRequest.http.Headers[i], ':')));
             Result.imagebytes:=pos('application/imagebytes',buf)>=0;
           end;
       end;
       if Result.imagebytes then begin
         /// ImageBytes
         RESTRequest.http.Document.Position:=0;
         try
         RESTRequest.http.Document.Read(Result.FImageBytesInfo,SizeOf(Result.FImageBytesInfo));
         except
           FLastErrorCode:=500;
           FLastError:='Unknown error response from server';
           Result.Free;
           raise EApiException.Create(FLastError);
         end;
         if Result.FImageBytesInfo.MetadataVersion<>1 then begin
           FLastErrorCode:=500;
           FLastError:='Unsupported Alpaca ImageBytes MetadataVersion='+inttostr(Result.FImageBytesInfo.MetadataVersion);
           Result.Free;
           raise EApiException.Create(FLastError);
         end;
         FLastErrorCode:=Result.FImageBytesInfo.ErrorNumber;
         FLastError:='';
         if FLastErrorCode<>0 then begin
            RESTRequest.http.Document.Position:=Result.FImageBytesInfo.DataStart;
            RESTRequest.http.Document.Read(errmsg, 1024);
            FLastError:=string(UTF8Decode(errmsg));
            Result.Free;
            raise EAscomException.Create(FLastError);
         end;
         RESTRequest.http.Document.Position:=Result.FImageBytesInfo.DataStart;
         i:=Result.FImageBytesInfo.dimension1*Result.FImageBytesInfo.dimension2;
         if Result.FImageBytesInfo.dimension3<>0 then i:=i*Result.FImageBytesInfo.dimension3;
         case Result.FImageBytesInfo.TransmissionElementType of
           1: begin
              SetLength(Result.FArrayInt16,i);
              RESTRequest.http.Document.Read(Result.FArrayInt16[0], i*SizeOf(cint16));
              end;
           2: begin
              SetLength(Result.FArrayInt32,i);
              RESTRequest.http.Document.Read(Result.FArrayInt32[0], i*SizeOf(cint32));
              end;
           6: begin
              SetLength(Result.FArrayByte,i);
              RESTRequest.http.Document.Read(Result.FArrayByte[0],i*SizeOf(byte));
              end;
           8: begin
              SetLength(Result.FArrayUInt16,i);
              RESTRequest.http.Document.Read(Result.FArrayUInt16[0],i*SizeOf(cuint16));
              end;
           9: begin
              SetLength(Result.FArrayUInt32,i);
              RESTRequest.http.Document.Read(Result.FArrayUInt32[0],i*SizeOf(cuint32));
              end;
           else
              raise exception.create('Not implemented Alpaca image array type '+inttostr(Result.FImageBytesInfo.TransmissionElementType));
           end;
       end
       else begin
         // JSON document
         try
         RESTRequest.http.Document.Position:=0;
         Result.data:=TJSONObject(GetJSON(RESTRequest.http.Document));
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
   while not RESTRequest.Finished do begin
     sleep(5);
     if GetCurrentThreadId=MainThreadID then Application.ProcessMessages;
   end;
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
    x,y,i,k: integer;
begin
   J:=Get('imagearray','','Accept: application/imagebytes');
   try
   Result:=TImageArray.Create;
   if j.imagebytes then begin
     // ImageBytes
     Result.nplane:=J.FImageBytesInfo.Rank;
     Result.width:=J.FImageBytesInfo.Dimension1;
     Result.height:=J.FImageBytesInfo.Dimension2;
     if Result.nplane=2 then begin
        SetLength(Result.img,1,Result.height,Result.width);
        i:=0;
        case J.ImageBytesInfo.TransmissionElementType of
           1: for x:=0 to Result.width-1 do begin
                for y:=0 to Result.height-1 do begin
                  Result.img[0,y,x]:=J.ArrayInt16[i];
                  inc(i);
               end;
             end;
           2: for x:=0 to Result.width-1 do begin
                for y:=0 to Result.height-1 do begin
                  Result.img[0,y,x]:=J.ArrayInt32[i];
                  inc(i);
               end;
             end;
           6: for x:=0 to Result.width-1 do begin
                for y:=0 to Result.height-1 do begin
                  Result.img[0,y,x]:=J.ArrayByte[i];
                  inc(i);
               end;
             end;
           8: for x:=0 to Result.width-1 do begin
                for y:=0 to Result.height-1 do begin
                  Result.img[0,y,x]:=J.ArrayUInt16[i];
                  inc(i);
               end;
             end;
           9: for x:=0 to Result.width-1 do begin
                for y:=0 to Result.height-1 do begin
                  Result.img[0,y,x]:=J.ArrayUInt32[i];
                  inc(i);
               end;
             end;
           else
             raise exception.create('Not implemented Alpaca image array type '+inttostr(J.ImageBytesInfo.TransmissionElementType));
        end;
      end
      else if Result.nplane=3 then begin
        if J.ImageBytesInfo.Dimension3<>3 then
          raise exception.create('Not implemented Alpaca image array dimension3='+inttostr(J.ImageBytesInfo.Dimension3));
        SetLength(Result.img,3,Result.height,Result.width);
        i:=0;
        case J.ImageBytesInfo.TransmissionElementType of
           1: for x:=0 to Result.width-1 do begin
                for y:=0 to Result.height-1 do begin
                  for k:=0 to 2 do begin
                    Result.img[k,y,x]:=J.ArrayInt16[i];
                    inc(i);
                  end;
               end;
             end;
           2: for x:=0 to Result.width-1 do begin
                for y:=0 to Result.height-1 do begin
                  for k:=0 to 2 do begin
                    Result.img[k,y,x]:=J.ArrayInt32[i];
                    inc(i);
                  end;
               end;
             end;
           6: for x:=0 to Result.width-1 do begin
                for y:=0 to Result.height-1 do begin
                  for k:=0 to 2 do begin
                    Result.img[k,y,x]:=J.ArrayByte[i];
                    inc(i);
                  end;
               end;
             end;
           8: for x:=0 to Result.width-1 do begin
                for y:=0 to Result.height-1 do begin
                  for k:=0 to 2 do begin
                    Result.img[k,y,x]:=J.ArrayUInt16[i];
                    inc(i);
                  end;
               end;
             end;
           9: for x:=0 to Result.width-1 do begin
                for y:=0 to Result.height-1 do begin
                  for k:=0 to 2 do begin
                    Result.img[k,y,x]:=J.ArrayUInt32[i];
                    inc(i);
                  end;
               end;
             end;
           else
             raise exception.create('Not implemented Alpaca image array type '+inttostr(J.ImageBytesInfo.TransmissionElementType));
        end;
      end
      else
        raise exception.create('Not implemented Alpaca image array rank '+inttostr(J.ImageBytesInfo.Rank));
   end
   else if J.base64handoff then begin
     // Base64
     x:=J.GetName('Type').AsInteger;
     if x<>2 then
        raise EApiException.Create('Invalid ImageArray Type '+inttostr(x));
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
     // JSON array
     x:=J.GetName('Type').AsInteger;
     if x<>2 then
        raise EApiException.Create('Invalid ImageArray Type '+inttostr(x));
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
  while not RESTRequest.Finished do begin
     sleep(5);
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
    raise ESocketException.Create(Fhost+':'+Fport+' '+FLastError);
  end;
  finally
    RESTRequest.Free;
  end;
end;


procedure TAscomRest.Put(method: string; params: array of string); overload;
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
  while not RESTRequest.Finished do begin
     sleep(5);
     if GetCurrentThreadId=MainThreadID then Application.ProcessMessages;
  end;
  if (method='Connected')or(method='Connect') then
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

