unit cu_tcpserver;

{
Copyright (C) 2010 Patrick Chevalley

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
{ TCP/IP Connexion, based on Synapse Echo demo }

{$MODE Delphi}{$H+}

interface

uses
  u_constant, u_util, blcksock, synsock,
  Dialogs, LazUTF8, LazFileUtils, LCLIntf, SysUtils, Classes;

type

  TStringProc = procedure(var S: string) of object;
  TIntProc = procedure(var i: integer) of object;
  TExCmd = function(S: string; L: TStringList): string of object;

  TTCPThrd = class(TThread)
  private
    FSock: TTCPBlockSocket;
    CSock: TSocket;
    cmd: TStringList;
    cmdresult: string;
    FConnectTime: double;
    FTerminate: TIntProc;
    FExecuteCmd: TExCmd;
  public
    id: integer;
    abort, lockexecutecmd, stoping: boolean;
    active_chart, remoteip, remoteport: string;
    constructor Create(hsock: tSocket);
    procedure Execute; override;
    procedure SendData(str: string);
    procedure ExecuteCmd;
    property sock: TTCPBlockSocket read FSock;
    property ConnectTime: double read FConnectTime;
    property Terminated;
    property onTerminate: TIntProc read FTerminate write FTerminate;
    property onExecuteCmd: TExCmd read FExecuteCmd write FExecuteCmd;
  end;

  TTCPDaemon = class(TThread)
  private
    Sock: TTCPBlockSocket;
    active_chart: string;
    FGetActiveChart: TStringProc;
    FErrorMsg: TStringProc;
    FShowSocket: TStringProc;
    FIPaddr, FIPport: string;
    FExecuteCmd: TExCmd;
    procedure ShowError;
    procedure ThrdTerminate(var i: integer);
  public
    stoping: boolean;
    TCPThrd: array [1..Maxwindow] of TTCPThrd;
    ThrdActive: array [1..Maxwindow] of boolean;
    constructor Create;
    procedure Execute; override;
    procedure ShowSocket;
    procedure GetActiveChart;
    property Terminated;
    property IPaddr: string read FIPaddr write FIPaddr;
    property IPport: string read FIPport write FIPport;
    property onGetACtiveChart: TStringProc read FGetActiveChart write FGetActiveChart;
    property onErrorMsg: TStringProc read FErrorMsg write FErrorMsg;
    property onShowSocket: TStringProc read FShowSocket write FShowSocket;
    property onExecuteCmd: TExCmd read FExecuteCmd write FExecuteCmd;
  end;

implementation

{$ifdef darwin}
uses BaseUnix;       //  to catch SIGPIPE

var
  NewSigRec, OldSigRec: SigActionRec;
  res: integer;

{$endif}

constructor TTCPDaemon.Create;
begin
  FreeOnTerminate := True;
  inherited Create(True);
end;

procedure TTCPDaemon.ShowError;
var
  msg: string;
begin
  msg := IntToStr(sock.lasterror) + ' ' + sock.GetErrorDesc(sock.lasterror);
  if assigned(FErrorMsg) then
    FErrorMsg(msg);
end;

procedure TTCPDaemon.ShowSocket;
var
  locport: string;
begin
  sock.GetSins;
  locport := IntToStr(sock.GetLocalSinPort);
  if assigned(FShowSocket) then
    FShowSocket(locport);
end;

procedure TTCPDaemon.ThrdTerminate(var i: integer);
begin
  ThrdActive[i] := False;
end;

procedure TTCPDaemon.GetActiveChart;
begin
  if assigned(FGetActiveChart) then
    FGetActiveChart(active_chart);
end;

procedure TTCPDaemon.Execute;
var
  ClientSock: TSocket;
  i, n: integer;
begin
  //writetrace('start tcp deamon');
  stoping := False;
  for i := 1 to MaxWindow do
    ThrdActive[i] := False;
  sock := TTCPBlockSocket.Create;
  //writetrace('blocksocked created');
  try
    with sock do
    begin
      //writetrace('create socket');
      CreateSocket;
      if lasterror <> 0 then
        Synchronize(ShowError);
      MaxLineLength := 1024;
      //writetrace('setlinger');
      setLinger(True, 0);
      if lasterror <> 0 then
        Synchronize(ShowError);
      //writetrace('bind to '+fipaddr+' '+fipport);
      bind(FIPaddr, FIPport);
      if lasterror <> 0 then
        Synchronize(ShowError);
      //writetrace('listen');
      listen;
      if lasterror <> 0 then
        Synchronize(ShowError);
      Synchronize(ShowSocket);
      //writetrace('start main loop');
      repeat
        if stoping or terminated then
          break;
        if canread(500) and (not terminated) and (not stoping) then
        begin
          ClientSock := accept;
          if lastError = 0 then
          begin
            n := -1;
            for i := 1 to Maxwindow do
              if (not ThrdActive[i]) or
                (TCPThrd[i] = nil) or (TCPThrd[i].Fsock = nil) or
                (TCPThrd[i].terminated) then
              begin
                n := i;
                break;
              end;
            if n > 0 then
            begin
              TCPThrd[n] := TTCPThrd.Create(ClientSock);
              TCPThrd[n].onTerminate := ThrdTerminate;
              TCPThrd[n].onExecuteCmd := FExecuteCmd;
              TCPThrd[n].id := n;
              TCPThrd[n].Start;
              i := 0;
              while (TCPThrd[n].Fsock = nil) and (i < 100) do
              begin
                sleep(100);
                Inc(i);
              end;
              if not TCPThrd[n].terminated then
              begin
                TCPThrd[n].id := n;
                ThrdActive[n] := True;
                Synchronize(GetActiveChart);
                if active_chart = msgFailed then
                  TCPThrd[n].senddata(msgFailed + ' Cannot activate a chart.')
                else
                begin
                  TCPThrd[n].active_chart := active_chart;
                  TCPThrd[n].senddata(msgOK + ' id=' + IntToStr(
                    n) + ' chart=' + active_chart);
                end;
              end;
            end
            else
              with TTCPThrd.Create(ClientSock) do
              begin
                i := 0;
                while (sock = nil) and (i < 100) do
                begin
                  sleep(100);
                  Inc(i);
                end;
                if not terminated then
                begin
                  if Sock <> nil then
                    Sock.SendString(msgFailed + ' Maximum connection reach!' + CRLF);
                  terminate;
                end;
              end;
          end
          else
            Synchronize(ShowError);
        end;
      until False;
    end;
  finally
    //  Suspended:=true;
    Sock.AbortSocket;
    Sock.Free;
    //  terminate;
  end;
end;

constructor TTCPThrd.Create(Hsock: TSocket);
begin
  FreeOnTerminate := True;
  inherited Create(True);
  Csock := Hsock;
  cmd := TStringList.Create;
  abort := False;
  lockexecutecmd := False;
end;

procedure TTCPThrd.Execute;
var
  s, msg: string;
  i: integer;
begin
  try
    Fsock := TTCPBlockSocket.Create;
    FConnectTime := now;
    stoping := False;
    try
      Fsock.socket := CSock;
      Fsock.GetSins;
      Fsock.MaxLineLength := 1024;
      remoteip := Fsock.GetRemoteSinIP;
      remoteport := IntToStr(Fsock.GetRemoteSinPort);
      with Fsock do
      begin
        repeat
          if stoping or terminated then
            break;
          msg := 'RecvString';
          s := RecvString(500);
          //if s<>'' then writetrace(s);   // for debugging only, not thread safe!
          if lastError = 0 then
          begin
            if (uppercase(s) = 'QUIT') or (uppercase(s) = 'EXIT') then
              break;
            splitarg(s, blank, cmd);
            for i := cmd.Count to MaxCmdArg do
              cmd.add('');
            msg := 'ExecuteCmd ' + s;
            Synchronize(ExecuteCmd);
            msg := 'SendString ' + cmdresult;
            SendString(cmdresult + crlf);
            if lastError <> 0 then
              break;
            if (cmdresult = msgOK) and (uppercase(cmd[0]) = 'SELECTCHART') then
              active_chart := cmd[1];
            if (copy(cmdresult,1,3) = msgOK) and (uppercase(cmd[0]) = 'NEWCHART') then
              active_chart := trim(copy(cmdresult,4,9999));
          end
          else
          begin
            if LastError<>WSAETIMEDOUT then begin
              terminate;
              break;
            end;
          end;
        until False;
      end;
    finally
      if VerboseMsg then
      begin
        WriteTrace('Stop tcp/ip server:' + crlf + msg + crlf + s + crlf + IntToStr(
          fsock.LastError) + ' ' + FSock.LastErrorDesc);
      end;
      if assigned(FTerminate) then
        FTerminate(id);
      Fsock.SendString(msgBye + crlf);
      Fsock.CloseSocket;
      Fsock.Free;
      cmd.Free;
    end;
  except
  end;
end;

procedure TTCPThrd.Senddata(str: string);
begin
  try
    if Fsock <> nil then
      with Fsock do
      begin
        if terminated then
          exit;
        SendString(UTF8ToSys(str) + CRLF);
        if LastError <> 0 then
          terminate;
      end;
  except
    terminate;
  end;
end;

procedure TTCPThrd.ExecuteCmd;
begin
  if lockexecutecmd then
    exit;
  lockexecutecmd := True;
  try
    if Assigned(FExecuteCmd) then
      cmdresult := FExecuteCmd(active_chart, cmd);
    lockexecutecmd := False;
  except
    lockexecutecmd := False;
    cmdresult := msgFailed + blank + cmdresult;
  end;
end;

initialization

 {$ifdef darwin}//  ignore SIGPIPE
 {$ifdef CPU32}
  with NewSigRec do
  begin
    integer(@Sa_Handler) := SIG_IGN; // ignore signal
    Sa_Mask[0] := 0;
    Sa_Flags := 0;
  end;
  res := fpsigaction(SIGPIPE, @NewSigRec, @OldSigRec);
 {$endif}
 {$endif}
end.
