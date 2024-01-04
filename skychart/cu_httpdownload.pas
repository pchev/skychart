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

uses  fphttpclient, opensslsockets,
  Classes, SysUtils;

type   THTTPBigDownload = class(TThread)
  private
    http: TFPHTTPClient;
    FUpdateSize: int64;
    FMillis: QWord;
    Furl,Ffn: string;
    FHttpResult: boolean;
    FHttpErr: string;
    FProgressText: string;
    FDownloadComplete, FDownloadError, FProgress: TThreadMethod;
    function GetProxy: TProxyData;
    procedure SetProxy(value: TProxyData);
    procedure HttpProgress(Sender: TObject; const ContentLength, CurrentPos: Int64);
  public
    constructor Create(CreateSuspended: boolean);
    procedure Execute; override;
    procedure Abort;
    property url: string read Furl write Furl;
    property filename: string read Ffn write Ffn;
    property ProgressText: string read FProgressText;
    property HttpResult: boolean read FHttpResult;
    property HttpErr: string read FHttpErr;
    Property Proxy : TProxyData Read GetProxy Write SetProxy;
    property onProgress: TThreadMethod read FProgress write FProgress;
    property onDownloadComplete: TThreadMethod read FDownloadComplete write FDownloadComplete;
    property onDownloadError: TThreadMethod read FDownloadError write FDownloadError;
  end;

implementation

constructor THTTPBigDownload.Create(CreateSuspended: boolean);
begin
 inherited Create(CreateSuspended);
 FreeOnTerminate := True;
 http:=TFPHTTPClient.Create(nil);
 http.AllowRedirect:=true;
 http.OnDataReceived:=@HttpProgress;
end;

function THTTPBigDownload.GetProxy: TProxyData;
begin
  result:=http.Proxy;
end;

procedure THTTPBigDownload.SetProxy(value: TProxyData);
begin
  http.Proxy.Assign(value);
end;

procedure THTTPBigDownload.Execute;
begin
try
  FHttpErr:='';
  FHttpResult:=true;
  FMillis := GetTickCount64;
  http.Get(Furl, Ffn);
  if assigned(FDownloadComplete) then Synchronize(FDownloadComplete);
  FreeAndNil(http);
except
  on E: Exception do begin
    FHttpErr:=E.Message;
    FHttpResult:=false;
    if assigned(FDownloadError) then Synchronize(FDownloadError);
  end;
end;
end;

procedure THTTPBigDownload.HttpProgress(Sender: TObject; const ContentLength, CurrentPos: Int64);
var dsize,dt: int64;
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
        FProgressText := FProgressText + format(', %.0n Bytes/Seconds', [speed])
      else if speed<(1024*1024) then
        FProgressText := FProgressText + format(', %.1f KB/Seconds', [speed/1024])
      else
        FProgressText := FProgressText + format(', %.1f MB/Seconds', [speed/1024/1024]);
    end;
    if assigned(FProgress) then Synchronize(FProgress);
    FMillis := GetTickCount64;
  end;
end;

procedure THTTPBigDownload.Abort;
begin
  FHttpErr:='Aborted by user';
  FHttpResult:=false;
  http.Terminate;
end;

end.

