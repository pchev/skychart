unit cu_httpdownload;
{
Copyright (C) 2024 Patrick Chevalley

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
  download a file, directly to disk file, in a non-blocking thread
}

{$mode ObjFPC}{$H+}

interface

uses  u_util, blcksock, HTTPsend, FTPSend, ssl_openssl3,
  Classes, SysUtils;

const FSpeedPosMax=50;

type   THTTPBigDownload = class(TThread)
  private
    http: THTTPSend;
    FMillis: QWord;
    Furl,Ffirsturl,Ffn: string;
    FHttpResult: boolean;
    FHttpErr: string;
    FProgressText: string;
    Fproxy, Fproxyport, Fproxyuser, Fproxypass: string;
    FSocksproxy, FSockstype: string;
    Fsockreadcount, Fsockwritecount, FUpdateSize: Int64;
    FFileSize: int64;
    FfileStream: TFileStream;
    FDownloadComplete, FDownloadError, FProgress: TThreadMethod;
    FSpeed: array[0..FSpeedPosMax] of double;
    FSpeedPos, FSpeedNum: integer;
    procedure HttpProgress(Sender: TObject; const ContentLength, CurrentPos: Int64);
    procedure SockStatus(Sender: TObject; Reason: THookSocketReason;const Value: string);
    procedure SockMonitor(Sender: TObject; Writing: boolean;const Buffer: Pointer; Len: integer);

  public
    ok: boolean;
    constructor Create(CreateSuspended: boolean);
    procedure Execute; override;
    procedure Abort;
    procedure AbortForce;
    property HttpProxy: string read Fproxy write Fproxy;
    property HttpProxyPort: string read Fproxyport write Fproxyport;
    property HttpProxyUser: string read Fproxyuser write Fproxyuser;
    property HttpProxyPass: string read Fproxypass write Fproxypass;
    property SocksProxy: string read FSocksproxy write FSocksproxy;
    property SocksType: string read FSockstype write FSockstype;
    property url: string read Furl write Furl;
    property filename: string read Ffn write Ffn;
    property ProgressText: string read FProgressText;
    property HttpResult: boolean read FHttpResult;
    property HttpErr: string read FHttpErr;
    property onProgress: TThreadMethod read FProgress write FProgress;
    property onDownloadComplete: TThreadMethod read FDownloadComplete write FDownloadComplete;
    property onDownloadError: TThreadMethod read FDownloadError write FDownloadError;
  end;

implementation

function HTTP_FileSize(AHTTP: THTTPSend; AURL: string): int64;
{
  //SZ To get size of the file on HTTP request
  AHTTP - HTTP instance
  AURL  - URL of the file
}
var
  head: string;
  i: integer;
  Size: int64;
begin
  Size := 0;
  try
    AHTTP.Headers.Clear;
    AHTTP.Document.Clear;
    AHTTP.HTTPMethod('HEAD', AURL);
    head := AHTTP.Headers.Text;
    i := pos('content-length', LowerCase(head));
    if i > 0 then
    begin
      Inc(i, 14);
      // Skip colon and white space chars
      while i <= length(head) do
      begin
        if not (head[i] in [' ', ':', #9, #10, #13]) then
          break;
        Inc(i);
      end;
      while i <= length(head) do
      begin
        if head[i] in ['0'..'9'] then
          Size := Size * 10 + Ord(head[i]) - 48
        else
          break;
        Inc(i);
      end;
    end;
    AHTTP.Headers.Clear;
    AHTTP.Document.Clear;
  finally
  end;
  Result := Size;
end;

constructor THTTPBigDownload.Create(CreateSuspended: boolean);
begin
 inherited Create(CreateSuspended);
 FreeOnTerminate := True;
 ok := False;
 FMillis := 0;
 http:=THTTPSend.Create;
end;

procedure THTTPBigDownload.Execute;
var newurl: string;
    i: integer;
begin
try
 repeat // to handle redirection
    FfileStream := TFileStream.Create(Ffn,fmCreate or fmShareDenyWrite);
    http.clear;
    Fsockreadcount := 0;
    Fsockwritecount := 0;
    FUpdateSize := 0;

    Ffirsturl := Furl;
    FHttpErr:='';
    FHttpResult:=true;
    FSpeedPos:=0;
    FSpeedNum:=0;

    http.UserAgent:='Wget/1.16.1 (linux-gnu)';
    http.OutputStream := nil;
    FFileSize := HTTP_FileSize(http, Furl);

    http.OutputStream := FfileStream;

    FSockreadcount := 0;
    http.Sock.OnStatus := @SockStatus;
    http.sock.OnMonitor := @SockMonitor;
    http.Sock.ConnectionTimeout:=10000;

    FMillis := GetTickCount64;
    ok := http.HTTPMethod('GET', Furl);

    http.OutputStream:=nil;
    FfileStream.Free;

    if ok and ((http.ResultCode = 200) or (http.ResultCode = 0)) then
    begin  // success
      if ok and assigned(FDownloadComplete) then Synchronize(FDownloadComplete);
      break;
    end
    else if (http.ResultCode = 301) or (http.ResultCode = 302) or (http.ResultCode = 307) then
    begin  // redirect
      newurl:='';
      for i := 0 to http.Headers.Count - 1 do
      begin
        if UpperCase(copy(http.Headers[i], 1, 9)) = 'LOCATION:' then
        begin
          newurl := trim(copy(http.Headers[i], 10, 9999));
          if (newurl = Furl) or (newurl = Ffirsturl) then begin  // redirect recursive loop
            ok := False;
            newurl:='';
            break;
          end
          else
          begin
            FProgressText := 'Redirect to: ' + newurl;
            if assigned(FProgress) then synchronize(FProgress);
            break;
          end;
        end;
      end;
      if newurl<>'' then begin
        Furl := newurl;
        Continue; // retry next redirection
      end
      else
        break; // redirect recursive loop, exit
    end
    else
    begin // error
      FHttpResult := False;
      if ok then begin
        FHttpErr := trim(FHttpErr +' '+ http.ResultString);
      end
      else begin
        FHttpErr := trim(FHttpErr +' '+ http.Sock.LastErrorDesc);
      end;
      if assigned(FDownloadError) then Synchronize(FDownloadError);
      break;
    end;
    break;
  until false;

  FreeAndNil(http);

 except
  on E: Exception do begin
    FHttpErr:=E.Message;
    FHttpResult:=false;
    if assigned(FDownloadError) then Synchronize(FDownloadError);
  end;
end;
end;

procedure THTTPBigDownload.SockStatus(Sender: TObject; Reason: THookSocketReason;
  const Value: string);
begin
  FProgressText := '';
  case reason of
    HR_ResolvingBegin: FProgressText := 'Resolving ' + Value;
    HR_Connect: FProgressText := 'Connect ' + Value;
    HR_Accept: FProgressText := 'Accept ' + Value;
    HR_ReadCount: ; //SZ Dummy
    HR_WriteCount:
      begin
        FSockwritecount := FSockwritecount + StrToInt(Value);
        FProgressText := 'Request sent, waiting response';
      end;
    else
      FProgressText := '';
  end;

  if (FProgressText <> '') and assigned(FProgress) then
  begin
    synchronize(FProgress);
  end;
end;

procedure THTTPBigDownload.SockMonitor(Sender: TObject; Writing: boolean; const Buffer: Pointer; Len: integer);
begin
  if not Writing then
  begin
    FSockreadcount := FSockreadcount + len;
    HttpProgress(sender,FFileSize,FSockreadcount);
  end;
end;

procedure THTTPBigDownload.HttpProgress(Sender: TObject; const ContentLength, CurrentPos: Int64);
var dsize,dt: int64;
    i: integer;
    speed: double;
begin
  dt := GetTickCount64 - FMillis;
  if dt<0 then
    FMillis := GetTickCount64
  else if (ContentLength=CurrentPos)or(dt > 1000) then begin
    dsize:=CurrentPos-FUpdateSize;
    FUpdateSize := CurrentPos;

    if CurrentPos<1024 then
      FProgressText := format('Read Bytes: %.0n', [1.0 * CurrentPos])
    else if CurrentPos<(1024*1024) then
      FProgressText := format('Read KB: %.1f', [CurrentPos / 1024])
    else
      FProgressText := format('Read MB: %.1f', [CurrentPos / 1024 / 1024]);

    if ContentLength > 0 then begin
      if ContentLength<1024 then
        FProgressText := FProgressText + format(' of %.0n (%5.2f%%)', [1.0 * ContentLength, CurrentPos * 100 / ContentLength])
      else if CurrentPos<(1024*1024) then
        FProgressText := FProgressText + format(' of %.1f (%5.2f%%)', [ContentLength/1024, CurrentPos * 100 / ContentLength])
      else
        FProgressText := FProgressText + format(' of %.1f (%5.2f%%)', [ContentLength/1024/1024, CurrentPos * 100 / ContentLength])
    end;

    if (dsize>0)and(dt>0) then begin
      speed := dsize * 1000 / dt;
      if speed<1024 then
        FProgressText := FProgressText + format(', %.0n Bytes/s', [speed])
      else if speed<(1024*1024) then
        FProgressText := FProgressText + format(', %.1f KB/s', [speed/1024])
      else
        FProgressText := FProgressText + format(', %.1f MB/s', [speed/1024/1024]);

      FSpeed[FSpeedPos]:=speed;
      inc(FSpeedPos);
      if FSpeedPos>FSpeedPosMax then FSpeedPos:=0;
      inc(FSpeedNum);
      if FSpeedNum>(FSpeedPosMax+1) then FSpeedNum:=(FSpeedPosMax+1);
      speed:=0;
      for i:=0 to FSpeedNum-1 do speed:=speed+FSpeed[i];
      speed:=speed/FSpeedNum;

      FProgressText := FProgressText + format(', remaining time %s',[ TimeToStrShort((ContentLength-CurrentPos)/speed/SecsPerHour)]);

    end;

    if assigned(FProgress) then Synchronize(FProgress);
    FMillis := GetTickCount64;

  end;
end;

procedure THTTPBigDownload.Abort;
begin
  FHttpErr:='Aborted by user';
  FHttpResult:=false;
  http.Abort;
end;

procedure THTTPBigDownload.AbortForce;
begin
  try
    http.Sock.AbortSocket;
    Terminate;
  except
  end;
end;

end.

