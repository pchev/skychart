unit cdcclient1;

{$MODE Delphi}

{                                        
Copyright (C) 2003 Patrick Chevalley

http://www.astrosurf.com/astropc
pch@freesurf.ch

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

uses cu_tcpclient, IniFiles,
  SysUtils, Types, Classes, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, LResources;

type

  { TForm1 }

  TForm1 = class(TForm)
    Edit1: TEdit;
    Edit2: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Button1: TButton;
    Button2: TButton;
    Edit3: TEdit;
    Button3: TButton;
    Label3: TLabel;
    Memo1: TMemo;
    ComboBox1: TComboBox;
    Button4: TButton;
    ConnectRetryTimer: TTimer;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure ConnectRetryTimerTimer(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Combobox1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Button4Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    CdCconfig,CdC,CdCDir,ServerIPaddr,ServerIPport: string;
    CdCfound, StartCDC,Connecting: boolean;
    ConnectRetry: integer;
    procedure GetCdCInfo;
    procedure OpenCDC(param:string);
  public
    { Public declarations }
    client : TClientThrd;
    procedure ShowInfo(Sender: TObject; const messagetext:string);
    procedure ReceiveData(Sender : TObject; const data : string);
  end;

var
  Form1: TForm1;

const
  {$ifdef linux}
        DefaultCdC='skychart';
        DefaultCdCconfig='~/.skychart/skychart.ini';
  {$endif}
  {$ifdef darwin}
        DefaultCdC='skychart';
        DefaultCdCconfig='~/.skychart/skychart.ini';
  {$endif}
  {$ifdef win32}
        DefaultCdC='skychart.exe';
        DefaultCdCconfig='Skychart\skychart.ini';
  {$endif}

implementation

{$ifdef win32}
 uses  Windows, ShlObj;
{$endif}
{$ifdef unix}
 uses unix,baseunix;
{$endif}


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
{$ifdef win32}
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

procedure TForm1.ShowInfo(Sender: TObject; const messagetext:string);
begin
// process here socket status message.
  if connecting and (messagetext='Connection refused')and(ConnectRetry<10) then begin
     inc(ConnectRetry);
     edit3.Text:='Launching Skychart ...'+inttostr(ConnectRetry);
     edit3.Invalidate;
     if ConnectRetry=1 then OpenCDC('');
     ConnectRetryTimer.Enabled:=true;
  end
  else begin
     edit3.Text:=messagetext;
     edit3.Invalidate;
  end;
end;

procedure TForm1.ConnectRetryTimerTimer(Sender: TObject);
begin
  ConnectRetryTimer.Enabled:=false;
  Button1Click(nil);
end;

procedure TForm1.ReceiveData(Sender : TObject; const data : string);
begin
// process here unattended message from Cartes du Ciel.
  memo1.Lines.Add(Data);
end;

procedure TForm1.Button1Click(Sender: TObject);
// connect button
begin
if (client=nil)or(client.Terminated) then
   client:=TClientThrd.Create
   else exit;
client.TargetHost:=edit1.Text;
client.TargetPort:=edit2.Text;
client.Timeout := 500;    // tcp/ip timeout [ms] also act as a delay before to send command
client.CmdTimeout := 10;  // cdc response timeout [seconds]
client.onShowMessage:=ShowInfo;
client.onReceiveData:=ReceiveData;
Connecting:=true;
client.Resume;
end;

procedure TForm1.Button2Click(Sender: TObject);
// disconnect button
var resp:string;
begin
if (client<>nil)and(not client.Terminated) then begin
   resp:=client.Send('quit');
   memo1.lines.add(resp);
   client.terminate;
end;
end;

procedure TForm1.Button3Click(Sender: TObject);
// send command button
var resp:string;
begin
if (client<>nil)and(not client.Terminated) then begin
   resp:=client.Send(combobox1.Text);
   memo1.lines.add(resp);
end;
end;

procedure TForm1.Combobox1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
if (key=4100)or(key=13) then Button3Click(sender);
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
if client<>nil then begin
   client.terminate;
end;
if StartCDC then OpenCDC('--quit');
end;

procedure TForm1.Button4Click(Sender: TObject);
// example of chained command with process of the result
var resp,cname:string;
    i : integer;
begin
if (client<>nil)and(not client.Terminated) then begin
  cname:='tcpclient';
  resp:=client.Send('NEWCHART '+cname);
  i:=pos(' ',resp);
  if i>0 then begin
    cname:=copy(resp,i+1,999);
    resp:=copy(resp,1,i-1);
  end;
  if resp<>msgOK then raise exception.Create('Cannot create new chart');
  resp:=client.Send('SELECTCHART '+cname);
  if resp<>msgOK then raise exception.Create('Cannot activate '+cname);
  memo1.lines.add(resp+', new chart name is '+cname);
end;
end;

procedure TForm1.FormShow(Sender: TObject);
begin
  GetCdCInfo;
  edit1.Text:=ServerIPaddr;
  edit2.Text:=ServerIPport;
  ConnectRetry:=0;
end;

procedure TForm1.GetCdCInfo;
var
  buf: string;
  inif: TMemIniFile;
{$ifdef win32}
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
{$ifdef win32}
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

procedure TForm1.OpenCDC(param:string);
begin
    param:=param+' --unique --nosplash ';
    Execnowait(CdC+' '+param);
    StartCDC:=true;
end;

initialization
  {$i cdcclient1.lrs}

end.
