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

  Simulate an equatorial mount with HourAngle and Declination encoder.
  The encoder are read from this program and the position show on a simplified chart.
  If the Dec position is below -45° it show the information about the planets.

}

interface

uses
  {$ifdef mswindows}
  Dask,
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
    LabelX: TLabel;
    LabelY: TLabel;
    Memo1: TMemo;
    ConnectRetryTimer: TTimer;
    ExitTimer: TTimer;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    StaticText1: TStaticText;
    PosTimer: TTimer;
    TrackBarH: TTrackBar;
    TrackBarD: TTrackBar;
    procedure ConnectRetryTimerTimer(Sender: TObject);
    procedure ExitTimerTimer(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormShow(Sender: TObject);
    procedure PosTimerTimer(Sender: TObject);
  private
    { Private declarations }
    CdCconfig,CdC,CdCDir,ServerIPaddr,ServerIPport: string;
    CdCfound, StartCDC,Connecting,Closing,Restarting : boolean;
    ConnectRetry: integer;
    LastPosX, LastPosY, InactiveLoop: integer;
    EncoderX,EncoderY : integer;
    card: SmallInt;
    RealEncoder:boolean;
    Function  GetTcpPort:string;
    procedure GetCdCInfo;
    procedure OpenCDC(param:string);
    function CdCCmd(cmd:string):string;
    procedure Connect;
    procedure DoConnect;
    procedure Disconnect;
    procedure Restart;
    procedure GetEncoder;
    function InitEncoder: boolean;
  public
    { Public declarations }
    client : TClientThrd;
    procedure ShowInfo(Sender: TObject; const messagetext:string);
    procedure ReceiveData(Sender : TObject; const data : string);
  end;

var
  f_astrolabe: Tf_astrolabe;

const
  // some critical timing:
  EncoderPooling=200;    // Encoder pooling frequency [ms]
  CdCCmdTimeout=5;       // cdc response timeout [seconds]
  CdCTcpimeout=100;      // tcp/ip timeout [ms] also act as a delay before to send command


  {$ifdef linux}
        DefaultCdC='skychart';
        DefaultCdcDir='/usr/bin';
        DefaultCdCconfig='~/.skychart/skychart.ini';
  {$endif}
  {$ifdef darwin}
        DefaultCdC='skychart';
        DefaultCdcDir='/Applications/Cartes du Ciel/skychart.app/Contents/MacOS';
        DefaultCdCconfig='~/Library/Application Support/skychart/skychart.ini';
  {$endif}
  {$ifdef mswindows}
        DefaultCdC='skychart.exe';
        DefaultCdcDir='C:\Program Files\Ciel';
        DefaultCdCconfig='Skychart\skychart.ini';
        // DASK card
        cardModel=PCI_7248;  // ADLINK PCI 7248
        cardNum=1;           // First card
  {$endif}

implementation

{$ifdef mswindows}
 uses  Windows, ShlObj, Registry;
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
  var Registry1: TRegistry;
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
CdCdir := DefaultCdcDir;
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
  {$ifdef linux}
  if not FileExists(CdC) then begin
     CdC :=ExpandFileName(slash(CdCdir)+slash('..')+slash('..')+slash('bin') + DefaultCdC);
  end;
  if not FileExists(CdC) then begin
    CdC:='/usr/local/bin/'+DefaultCdC;
  end;
  {$endif}
  {$ifdef mswindows}
  if not FileExists(CdC) then begin
    Registry1 := TRegistry.Create;
    with Registry1 do begin
      if Openkey('Software\Astro_PC\Ciel',false) then
       if ValueExists('Install_Dir') then begin
         CdCdir:=ReadString('Install_Dir');
         CdC := slash(CdCdir) + DefaultCdC;
       end;
      CloseKey;
    end;
    Registry1.Free;
  end;
  {$endif}
  CdCfound:=FileExists(CdC);
end;
end;

procedure Tf_astrolabe.OpenCDC(param:string);
begin
    Execnowait(CdC+' '+param);
end;

procedure Tf_astrolabe.ShowInfo(Sender: TObject; const messagetext:string);
begin
// process here socket status message and command response
//  edit3.Text:=messagetext;
//  edit3.Invalidate;
end;

procedure Tf_astrolabe.ReceiveData(Sender : TObject; const data : string);
begin
// process here unattended message from Cartes du Ciel.
  memo1.Lines.Add(Data);
  if (data='Bye!')and(not closing) then   // unexpected failure in CdC
    Restart;
end;

procedure Tf_astrolabe.Connect;
begin
//Initial connection to CdC
//Check if CdC is already running
edit2.Text:=GetTcpPort;
if edit2.Text<>'0' then DoConnect  // yes, connect
else begin
   if CdCfound then begin                   // check CdC is installed
     edit3.Text:='Launching Skychart ...';
     edit3.Invalidate;
     OpenCDC('--unique --nosplash --config='+CdCconfig);  // Launch CdC
     StartCDC:=true;
     ConnectRetryTimer.Enabled:=true;
   end else begin
     ShowMessage('Cannot found skychart directory. Start skychart first.');
     Close;
   end;
end;
end;

procedure Tf_astrolabe.ConnectRetryTimerTimer(Sender: TObject);
begin
  // wait CdC is started and ready for connection
  ConnectRetryTimer.Enabled:=false;
  edit3.Text:='Wait Skychart startup ...';
  edit3.Invalidate;
  edit2.Text:=GetTcpPort;
  if edit2.Text<>'0' then DoConnect
     else ConnectRetryTimer.Enabled:=true;
end;

procedure Tf_astrolabe.DoConnect;
begin
// initialize connection to CdC after it is started
if (client=nil)or(client.Terminated) then
   client:=TClientThrd.Create
   else exit;
client.TargetHost:=edit1.Text;
client.TargetPort:=edit2.Text;
client.Timeout := CdCTcpimeout;    // tcp/ip timeout [ms] also act as a delay before to send command
client.CmdTimeout := CdCCmdTimeout;  // cdc response timeout [seconds]
client.onShowMessage:=ShowInfo;
client.onReceiveData:=ReceiveData;
Connecting:=true;
client.Resume;
sleep(500);
edit3.Text:='Connected';
edit3.Invalidate;
PosTimer.Enabled:=True;
end;

procedure Tf_astrolabe.Restart;
begin
Restarting:=true;
Close;
end;

procedure Tf_astrolabe.Disconnect;
var resp:string;
begin
// disconnect from CdC
PosTimer.Enabled:=False;
Closing:=true;
if (client<>nil)and(not client.Terminated) then begin
   resp:=client.Send('quit');
   memo1.lines.add(resp);
   client.terminate;
end;
end;

procedure Tf_astrolabe.FormClose(Sender: TObject; var Action: TCloseAction);
begin
if not Closing then begin
  Disconnect;                // stop the connection before to close
  ExitTimer.Enabled:=true;
  Action:=caNone;
end;
end;

procedure Tf_astrolabe.FormCreate(Sender: TObject);
begin
// prohgram initialisation
DefaultFormatSettings.DecimalSeparator:='.';
DefaultFormatSettings.ThousandSeparator:=',';
DefaultFormatSettings.DateSeparator:='/';
DefaultFormatSettings.TimeSeparator:=':';
GetCdCInfo;
edit1.Text:=ServerIPaddr;
edit2.Text:=ServerIPport;
PosTimer.Interval:=EncoderPooling;
ConnectRetry:=0;
InactiveLoop:=0;
LastPosX:=MaxInt;
LastPosY:=MaxInt;
Closing:=false;
Restarting:=false;
RealEncoder:=InitEncoder;
Panel2.Visible:=not RealEncoder;
Panel3.Visible:=RealEncoder;
end;

procedure Tf_astrolabe.FormDestroy(Sender: TObject);
begin
  if Restarting then ExecNoWait(paramstr(0));
end;

procedure Tf_astrolabe.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  // help small trackbar movement
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
  if StartCDC then begin
     OpenCDC('--unique --quit');  // close CdC if we start it
  end;
  StartCDC:=false;
  sleep(1000);
  Application.ProcessMessages;
  Close;                          // return to really close this time
end;

procedure Tf_astrolabe.FormShow(Sender: TObject);
begin
  // automatic connection at startup
  Connect;
end;

function Tf_astrolabe.CdCCmd(cmd:string):string;
var resp:string;
begin
// Send command to CdC and wait for response
if (client<>nil)and(not client.Terminated) then begin
   memo1.lines.add(cmd);
   resp:=client.Send(cmd);
   memo1.lines.add(resp);
   result:=resp;
end;
end;

procedure Tf_astrolabe.GetEncoder;
var PA,PB,PC,x1,x2,x3: word;
    va,vb,vc: Cardinal;
begin
if RealEncoder then begin
  // read encoder position here
  {$ifdef mswindows}
  DI_ReadPort(card,Channel_P1A,va);
  PA:=255-va;
  DI_ReadPort(card,Channel_P1B,vb);
  PB:=255-vb;
  DI_ReadPort(card,Channel_P1C,vc);
  PC:=255-vc;
  x1:=(PA AND $F);
  x2:=(PA AND $F0) SHR 4;
  x3:=PB AND $3;
  EncoderX:=x1 + 10*x2 + 100*x3 - 180;
  x1:=(PC AND $F);
  x2:=(PC AND $F0) SHR 4;
  x3:=PB SHR 6;
  EncoderY:=x1 + 10*x2 + 100*x3;
  LabelX.Caption:=inttostr(EncoderX);
  LabelY.Caption:=inttostr(EncoderY);
  {$endif}
end else begin
 // simulation using two trackbar:
 EncoderX:=TrackBarH.Position;
 EncoderY:=TrackBarD.Position;
end;
end;

procedure Tf_astrolabe.PosTimerTimer(Sender: TObject);
var inactivity: boolean;
begin
try
PosTimer.Enabled:=false;
inc(InactiveLoop);
GetEncoder;
inactivity:=(InactiveLoop*PosTimer.Interval/1000>60);
if (EncoderX<>LastPosX)or           // moved AH coder
  (EncoderY<>LastPosY) or           // moved Dec coder
  inactivity                        // one minute inactive,
  then begin
    LastPosX := EncoderX;
    LastPosY := EncoderY;
    InactiveLoop:=0;
    if EncoderY>-45 then begin
      CdCCmd('PLANETINFO OFF');
      CdCCmd('MOVESCOPEH '+FormatFloat('0.00',EncoderX/15)+' '+FormatFloat('0.00',EncoderY));
      CdCCmd('IDSCOPE');
    end
    else if EncoderY>-47 then CdCCmd('PLANETINFO 0') // Visibility
    else if EncoderY>-51 then CdCCmd('PLANETINFO 1') // Moon
    else if EncoderY>-55 then CdCCmd('PLANETINFO 2') // Mercury
    else if EncoderY>-59 then CdCCmd('PLANETINFO 3') // Venus
    else if EncoderY>-63 then CdCCmd('PLANETINFO 4') // Mars
    else if EncoderY>-67 then CdCCmd('PLANETINFO 5') // Jupiter
    else if EncoderY>-71 then CdCCmd('PLANETINFO 6') // Saturn
    else if EncoderY>-75 then CdCCmd('PLANETINFO 7') // Orbit1
    else if EncoderY>-100 then CdCCmd('PLANETINFO 8') // Orbit2
    else;
    Application.ProcessMessages;
end;
finally
PosTimer.Enabled:=true;
end;
end;

function Tf_astrolabe.InitEncoder: boolean;
begin
{$ifdef mswindows}
card:=Register_Card(cardModel, cardNum);
result:=card>=0;
{$else}
result:=false;
{$endif}
end;

end.
