unit astrolabe1;

{$MODE Delphi}

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
Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
}
{
  Example of a TCP/IP client for Cartes du Ciel
}

interface

uses
{$ifdef mswindows}
  Registry,
{$endif}
  cu_tcpclient, IniFiles,
  SysUtils, Types, Classes, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, LResources, ComCtrls;

type

  { Tf_astrolabe }

  Tf_astrolabe = class(TForm)
    Edit1: TEdit;
    Edit2: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Edit3: TEdit;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Memo1: TMemo;
    ConnectRetryTimer: TTimer;
    ExitTimer: TTimer;
    Panel1: TPanel;
    Panel2: TPanel;
    TrackBarH: TTrackBar;
    TrackBarD: TTrackBar;
    procedure ConnectRetryTimerTimer(Sender: TObject);
    procedure ExitTimerTimer(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormShow(Sender: TObject);
    procedure PosChange(Sender: TObject);
  private
    { Private declarations }
    CdCconfig,CdC,CdCDir,ServerIPaddr,ServerIPport: string;
    CdCfound, StartCDC,Connecting,lockpos : boolean;
    ConnectRetry: integer;
    Function  GetTcpPort:string;
    procedure GetCdCInfo;
    procedure OpenCDC(param:string);
    function CdCCmd(cmd:string):string;
    procedure Connect;
    procedure DoConnect;
    procedure Disconnect;
  public
    { Public declarations }
    client : TClientThrd;
    procedure ShowInfo(Sender: TObject; const messagetext:string);
    procedure ReceiveData(Sender : TObject; const data : string);
  end;

var
  f_astrolabe: Tf_astrolabe;

const
  {$ifdef linux}
        DefaultCdC='skychart';
        DefaultCdCconfig='~/.skychart/skychart.ini';
  {$endif}
  {$ifdef darwin}
        DefaultCdC='skychart';
        DefaultCdCconfig='~/.skychart/skychart.ini';
  {$endif}
  {$ifdef mswindows}
        DefaultCdC='skychart.exe';
        DefaultCdCconfig='Skychart\skychart.ini';
  {$endif}

implementation

{$ifdef mswindows}
 uses  Windows, ShlObj;
{$endif}
{$ifdef unix}
 uses unix,baseunix;
{$endif}

{$R *.lfm}


// some useful functions
Function Slash(nom : string) : string;
begin
result:=trim(nom);
if copy(result,length(nom),1)<>PathDelim then result:=result+PathDelim;
end;

procedure ExecNoWait(cmd: string; title:string=''; hide: boolean=true);
{$ifdef unix}
begin
 fpSystem(cmd+' &');
end;
{$endif}
{$ifdef mswindows}
var
   bchExec: array[0..1024] of char;
   pchEXEC: Pchar;
   si: TStartupInfo;
   pi: TProcessInformation;
begin
   pchExec := @bchExec;
   StrPCopy(pchExec,cmd);
   FillChar(si,sizeof(si),0);
   FillChar(pi,sizeof(pi),0);
   si.dwFlags:=STARTF_USESHOWWINDOW;
   if title<>'' then si.lpTitle:=Pchar(title);
   if hide then si.wShowWindow:=SW_SHOWMINIMIZED
           else si.wShowWindow:=SW_SHOWNORMAL;
   si.cb := sizeof(si);
   try
     CreateProcess(Nil,pchExec,Nil,Nil,false,CREATE_NEW_CONSOLE or NORMAL_PRIORITY_CLASS, Nil,Nil,si,pi);
    except;
    end;
end;
{$endif}

function Tf_astrolabe.GetTcpPort:string;
var
{$ifdef mswindows}
Registry1: TRegistry;
{$else}
   f: textfile;
{$endif}
begin
{$ifdef mswindows}
Registry1 := TRegistry.Create;
with Registry1 do begin
  if Openkey('Software\Astro_PC\Ciel\Status',false) then begin
    if ValueExists('TcpPort') then result:=ReadString('TcpPort')
       else result:='0';
    CloseKey;
  end;
end;
Registry1.Free;
{$else}
AssignFile(f,ExpandFileName('~/.skychart/tmp/tcpport'));
Reset(f);
read(f,result);
CloseFile(f);
{$endif}
end;


////////////////////////////////

procedure Tf_astrolabe.GetCdCInfo;
var
  buf,cdir: string;
  inif: TMemIniFile;
{$ifdef mswindows}
  buf1: string;
  PIDL:   PItemIDList;
  Folder: array[0..MAX_PATH] of char;
const
  CSIDL_APPDATA  = $001a;   // <user name>\Application Data
  CSIDL_LOCAL_APPDATA = $001c; // <user name>\Local Settings\Applicaiton Data (non roaming)
{$endif}
begin
{$ifdef unix}
  CdCconfig  := ExpandFileName(DefaultCdCconfig);
{$endif}
{$ifdef mswindows}
  SHGetSpecialFolderLocation(0, CSIDL_LOCAL_APPDATA, PIDL);
  SHGetPathFromIDList(PIDL, Folder);
  buf1 := trim(Folder);
  SHGetSpecialFolderLocation(0, CSIDL_APPDATA, PIDL);
  SHGetPathFromIDList(PIDL, Folder);
  buf := trim(Folder);
  if buf1 = '' then
    buf1     := buf;  // old windows version
  CdCconfig  := slash(buf1) + DefaultCdCconfig;
{$endif}
cdir:=GetCurrentDir;
if FileExists(slash(cdir)+'astrolabe.ini') then
  CdCconfig:=slash(cdir)+'astrolabe.ini';
CdCdir := '';
if fileexists(CdCconfig) then
begin
  inif := TMeminifile.Create(CdCconfig);
  try
    buf := inif.ReadString('main', 'AppDir', '');
    if DirectoryExists(buf) then
      CdCdir := buf;
    ServerIPaddr:=inif.ReadString('main','ServerIPaddr','127.0.0.1');
    ServerIPport:=inif.ReadString('main','ServerIPport','3292');

  finally
    inif.Free;
  end;
  CdC := slash(CdCdir) + DefaultCdC;
  if not FileExists(CdC) then begin
     CdC :=ExpandFileName(slash(CdCdir)+slash('..')+slash('..')+slash('bin') + DefaultCdC);
  end;
  CdCfound:=FileExists(CdC);
end;
end;

procedure Tf_astrolabe.OpenCDC(param:string);
begin
    Execnowait(CdC+' '+param);
end;

procedure Tf_astrolabe.ShowInfo(Sender: TObject; const messagetext:string);
begin
// process here socket status message.
  edit3.Text:=messagetext;
  edit3.Invalidate;
end;

procedure Tf_astrolabe.ReceiveData(Sender : TObject; const data : string);
begin
// process here unattended message from Cartes du Ciel.
  memo1.Lines.Add(Data);
end;

procedure Tf_astrolabe.Connect;
begin
edit2.Text:=GetTcpPort;
if edit2.Text<>'0' then DoConnect
else begin
   edit3.Text:='Launching Skychart ...';
   edit3.Invalidate;
   OpenCDC('--unique --nosplash --config='+CdCconfig);
   StartCDC:=true;
   ConnectRetryTimer.Enabled:=true;
end;
end;

procedure Tf_astrolabe.ConnectRetryTimerTimer(Sender: TObject);
begin
  ConnectRetryTimer.Enabled:=false;
  edit3.Text:='Wait Skychart startup ...';
  edit3.Invalidate;
  edit2.Text:=GetTcpPort;
  if edit2.Text<>'0' then DoConnect
     else ConnectRetryTimer.Enabled:=true;
end;

procedure Tf_astrolabe.DoConnect;
begin
if (client=nil)or(client.Terminated) then
   client:=TClientThrd.Create
   else exit;
client.TargetHost:=edit1.Text;
client.TargetPort:=edit2.Text;
client.Timeout := 100;    // tcp/ip timeout [ms] also act as a delay before to send command
client.CmdTimeout := 10;  // cdc response timeout [seconds]
client.onShowMessage:=ShowInfo;
client.onReceiveData:=ReceiveData;
Connecting:=true;
client.Resume;
end;

procedure Tf_astrolabe.Disconnect;
var resp:string;
begin
if (client<>nil)and(not client.Terminated) then begin
   resp:=client.Send('quit');
   memo1.lines.add(resp);
   client.terminate;
end;
end;

procedure Tf_astrolabe.FormClose(Sender: TObject; var Action: TCloseAction);
begin
if StartCDC then begin
  Disconnect;
  ExitTimer.Enabled:=true;
  Action:=caNone;
end;
end;

procedure Tf_astrolabe.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  case key of
  37 : TrackBarH.Position:=TrackBarH.Position-1;
  38 : TrackBarD.Position:=TrackBarD.Position+1;
  39 : TrackBarH.Position:=TrackBarH.Position+1;
  40 : TrackBarD.Position:=TrackBarD.Position-1;
  end;
end;

procedure Tf_astrolabe.ExitTimerTimer(Sender: TObject);
begin
  ExitTimer.Enabled:=false;
  OpenCDC('--unique --quit');
  StartCDC:=false;
  sleep(1000);
  Application.ProcessMessages;
  Close;
end;

procedure Tf_astrolabe.FormShow(Sender: TObject);
begin
  GetCdCInfo;
  edit1.Text:=ServerIPaddr;
  edit2.Text:=ServerIPport;
  ConnectRetry:=0;
  lockpos:=false;
  Connect;
end;

function Tf_astrolabe.CdCCmd(cmd:string):string;
var resp:string;
begin
if (client<>nil)and(not client.Terminated) then begin
   memo1.lines.add(cmd);
   resp:=client.Send(cmd);
   memo1.lines.add(resp);
   result:=resp;
end;
end;

procedure Tf_astrolabe.PosChange(Sender: TObject);
begin
if lockpos then exit;
try
lockpos:=true;
CdCCmd('MOVESCOPEH '+FormatFloat('0.00',TrackBarH.Position/2)+' '+FormatFloat('0.00',TrackBarD.Position/2));
edit3.Text:=CdCCmd('IDSCOPE');
Application.ProcessMessages;
finally
lockpos:=false;
end;
end;


end.
