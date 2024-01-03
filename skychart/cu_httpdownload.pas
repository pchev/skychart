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

{$mode ObjFPC}{$H+}

interface

uses  fphttpclient, opensslsockets,
  Classes, SysUtils;

type   THTTPBigDownload = class(TThread)
  private
    FUpdateSize: int64;
    FMillis: QWord;
    FDownloadComplete, FProgress: TThreadMethod;
  public
    http: TFPHTTPClient;
    url,fn: string;
    HttpErr: string;
    progresstext: string;
    HttpResult: boolean;
    constructor Create(CreateSuspended: boolean);
    procedure Execute; override;
    procedure HttpProgress(Sender: TObject; const ContentLength, CurrentPos: Int64);
    property onProgress: TThreadMethod read FProgress write FProgress;
    property onDownloadComplete: TThreadMethod read FDownloadComplete write FDownloadComplete;
  end;

implementation

constructor THTTPBigDownload.Create(CreateSuspended: boolean);
begin
 inherited Create(CreateSuspended);
 FreeOnTerminate := True;
 http:=TFPHTTPClient.Create(nil);
 http.OnDataReceived:=@HttpProgress;
end;

procedure THTTPBigDownload.Execute;
begin
try
  HttpErr:='';
  HttpResult:=true;
  FMillis := GetTickCount64;
  http.Get(url, fn);
  Synchronize(FDownloadComplete);
  FreeAndNil(http);
except
  on E: Exception do begin
    HttpErr:=E.Message;
    HttpResult:=false;
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
      progresstext := format('Read Bytes: %.0n', [1.0 * CurrentPos])
    else if CurrentPos<(1024*1024) then
      progresstext := format('Read KB: %.1f', [CurrentPos / 1024])
    else
      progresstext := format('Read MB: %.1f', [CurrentPos / 1024 / 1024]);

    if ContentLength > 0 then begin
      if ContentLength<1024 then
        progresstext := progresstext + format(' of %.0n (%5.2f%%)', [1.0 * ContentLength, CurrentPos * 100 / ContentLength])
      else if CurrentPos<(1024*1024) then
        progresstext := progresstext + format(' of %.1f (%5.2f%%)', [ContentLength/1024, CurrentPos * 100 / ContentLength])
      else
        progresstext := progresstext + format(' of %.1f (%5.2f%%)', [ContentLength/1024/1024, CurrentPos * 100 / ContentLength])
    end;

    if (dsize>0)and(dt>0) then begin
      speed := dsize * 1000 / dt;
      if speed<1024 then
        progresstext := progresstext + format(', %.0n Bytes/Seconds', [speed])
      else if speed<(1024*1024) then
        progresstext := progresstext + format(', %.1f KB/Seconds', [speed/1024])
      else
        progresstext := progresstext + format(', %.1f MB/Seconds', [speed/1024/1024]);
    end;
    Synchronize(FProgress);
    FMillis := GetTickCount64;
  end;
end;

end.

