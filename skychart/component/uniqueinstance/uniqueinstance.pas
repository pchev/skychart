unit UniqueInstance;

{
  UniqueInstance is a component to allow only a instance by program

  Copyright (C) 2006 Luiz Americo Pereira Camara
  pascalive@bol.com.br

  This library is free software; you can redistribute it and/or modify it
  under the terms of the GNU Library General Public License as published by
  the Free Software Foundation; either version 2 of the License, or (at your
  option) any later version with the following modification:

  As a special exception, the copyright holders of this library give you
  permission to link this library with independent modules to produce an
  executable, regardless of the license terms of these independent modules,and
  to copy and distribute the resulting executable under terms of your choice,
  provided that you also meet, for each linked independent module, the terms
  and conditions of the license of that module. An independent module is a
  module which is not derived from or based on this library. If you modify
  this library, you may extend this exception to your version of the library,
  but you are not obligated to do so. If you do not wish to do so, delete this
  exception statement from your version.

  This program is distributed in the hope that it will be useful, but WITHOUT
  ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
  FITNESS FOR A PARTICULAR PURPOSE. See the GNU Library General Public License
  for more details.

  You should have received a copy of the GNU Library General Public License
  along with this library; if not, write to the Free Software Foundation,
  Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
}


{$mode objfpc}{$H+}

interface

uses
{$ifdef unix}
  process, math,
  cdcsimpleipc,
{$else}
  simpleipc,
{$endif}
  Forms, Classes, SysUtils,  ExtCtrls;

type

  TOnOtherInstance = procedure (Sender : TObject; ParamCount: Integer; Parameters: array of String) of object;

  { TUniqueInstance }

  TUniqueInstance = class(TComponent)
  private
    FEnabled: Boolean;
    FIdentifier: String;
    FIPCServer: TSimpleIPCServer;
    FIPCClient: TSimpleIPCClient;
    FOnOtherInstance: TOnOtherInstance;
    FOnInstanceRunning: TNotifyEvent;
    {$ifdef unix}
    FTimer: TTimer;
    {$endif}
    FUpdateInterval: Cardinal;
    function GetServerId: String;
    procedure ReceiveMessage(Sender: TObject);
    procedure SetUpdateInterval(const AValue: Cardinal);
    procedure Loaded; override;
    {$ifdef unix}
    procedure CheckMessage(Sender: TObject);
    {$endif}
  public
    constructor Create(AOwner: TComponent); override;
  published
    property Enabled: Boolean read FEnabled write FEnabled;
    property Identifier: String read FIdentifier write FIdentifier;
    property UpdateInterval: Cardinal read FUpdateInterval write SetUpdateInterval;
    property OnOtherInstance: TOnOtherInstance read FOnOtherInstance write FOnOtherInstance;
    property OnInstanceRunning: TNotifyEvent read FOnInstanceRunning write FOnInstanceRunning;
  end;

  { TCdCUniqueInstance }

  TCdCUniqueInstance = class(TUniqueInstance)
  private
    retrycount: integer;
   {$ifdef unix}
    Process1: TProcess;
    function  GetPid:string;
    function  OtherRunning:boolean;
    procedure DeleteLock;
   {$endif}
  public
    constructor Create(AOwner: TComponent); override;
    procedure RetryOrHalt;
    procedure Loaded; override;
  end;

implementation

uses
  StrUtils;

const
  BaseServerId = 'tuniqueinstance_';
  Separator = '|';

{ TUniqueInstance }

procedure TUniqueInstance.ReceiveMessage(Sender: TObject);
var
  TempArray: array of String;
  Count,i: Integer;

  procedure GetParams(const AStr: String);
  var
    pos1,pos2:Integer;
  begin
    SetLength(TempArray, Count);
    //fill params
    i := 0;
    pos1:=1;
    pos2:=pos(Separator, AStr);
    while pos1 < pos2 do
    begin
      TempArray[i] := Copy(AStr, pos1, pos2 - pos1);
      pos1 := pos2+1;
      pos2 := posex(Separator, AStr, pos1);
      inc(i);
    end;
  end;

begin
  if Assigned(FOnOtherInstance) then
  begin
    //MsgType stores ParamCount
    Count := FIPCServer.MsgType;
    GetParams(FIPCServer.StringMessage);
    FOnOtherInstance(Self, Count, TempArray);
    SetLength(TempArray, 0);
  end;
end;

{$ifdef unix}
procedure TUniqueInstance.CheckMessage(Sender: TObject);
begin
  FIPCServer.PeekMessage(1, True);
end;
{$endif}

procedure TUniqueInstance.SetUpdateInterval(const AValue: Cardinal);
begin
  if FUpdateInterval = AValue then
    Exit;
  FUpdateInterval := AValue;
  {$ifdef unix}
  FTimer.Interval := AValue;
  {$endif}
end;

function TUniqueInstance.GetServerId: String;
begin
  if FIdentifier <> '' then
    Result := BaseServerId + FIdentifier
  else
    Result := BaseServerId + ExtractFileName(ParamStr(0));
end;


procedure TUniqueInstance.Loaded;
var
  TempStr: String;
  i: Integer;
begin
try
  if not (csDesigning in ComponentState) and FEnabled then
  begin
    FIPCClient.ServerId := GetServerId;
    if FIPCClient.ServerRunning then
    begin
      //A instance is already running
      //Send a message and then exit
      if Assigned(FOnOtherInstance) then
      begin
        TempStr := '';
        for i := 1 to ParamCount do
          TempStr := TempStr + ParamStr(i) + Separator;
        FIPCClient.Active := True;
        FIPCClient.SendStringMessage(ParamCount, TempStr);
      end;
      if Assigned(FOnInstanceRunning) then
        FOnInstanceRunning(self)
      else begin
        Application.ShowMainForm := False;
        Application.Terminate;
      end;
    end
    else
    begin
      //It's the first instance. Init the server
      if FIPCServer = nil then
        FIPCServer := TSimpleIPCServer.Create(Self);
      with FIPCServer do
      begin
        ServerID := FIPCClient.ServerId;
        Global := True;
        OnMessage := @ReceiveMessage;
        StartServer;
      end;
      //there's no more need for FIPCClient
      FIPCClient.Free;
      {$ifdef unix}
      if Assigned(FOnOtherInstance) then
        FTimer.Enabled := True;
      {$endif}
    end;
  end;//if
  inherited;

except
halt(1);
end;
end;

constructor TUniqueInstance.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FIPCClient := TSimpleIPCClient.Create(Self);
  FUpdateInterval := 1000;
  {$ifdef unix}
  FTimer := TTimer.Create(Self);
  FTimer.Enabled := false;
  FTimer.OnTimer := @CheckMessage;
  {$endif}
end;

////////////// TCdCUniqueInstance ////////////////////

constructor TCdCUniqueInstance.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  retrycount:=0;
end;

procedure  TCdCUniqueInstance.Loaded;
begin
{$ifdef unix}
  if not OtherRunning then
     DeleteLock;
{$endif}
  inherited;
end;

Procedure TCdCUniqueInstance.RetryOrHalt;
var i : integer;
    s:string;
begin
{$ifdef unix}
  inc(retrycount);
  if retrycount<=1 then begin
    if OtherRunning then
       Halt(1)
    else begin
       DeleteLock;
       Loaded;
    end;
  end;
{$else}
  Halt(1);
{$endif}
end;

{$ifdef unix}
procedure TCdCUniqueInstance.DeleteLock;
var D : String;
begin
  D:='/tmp/'; // See fcl-process/src/unix/simpleipc.inc  TPipeServerComm.Create
  DeleteFile(D+GetServerId);
end;

function TCdCUniqueInstance.GetPid:string;
var i: integer;
    s: array[0..1024] of char;
begin
result:='';
try
  Process1:=TProcess.Create(nil);
  FillChar(s,sizeof(s),' ');
  Process1.CommandLine:='pidof '+ExtractFileName(Application.ExeName);
{$ifdef darwin}
  Process1.CommandLine:='killall -s '+ExtractFileName(Application.ExeName);
{$endif}
  Process1.Options:=[poWaitOnExit,poUsePipes,poNoConsole];
  Process1.Execute;
  if Process1.ExitStatus=0 then begin
     i:=Min(1024,process1.Output.NumBytesAvailable);
     process1.Output.Read(s,i);
     result:=Trim(s);
  end;
  Process1.Free;
except
end;
end;

function TCdCUniqueInstance.OtherRunning:boolean;
var i : integer;
    s:string;
const
{$ifdef darwin}
  sep=#10;
{$else}
  sep=' ';
{$endif}
begin
  s:=GetPid;
  i:=pos(sep,s);
  result:= i>0;
end;

{$endif}

end.

