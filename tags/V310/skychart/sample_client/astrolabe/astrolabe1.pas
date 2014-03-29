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
  {$ifndef astrolabe_static}
  cu_tcpclient,
  {$else}
  pu_main, u_util, u_constant,
  {$endif}
  IniFiles,
  SysUtils, Types, Classes, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, LResources, ComCtrls;

type

  { Tf_astrolabe }

  Tf_astrolabe = class(TForm)
    CheckBox1: TCheckBox;
    Edit1: TEdit;
    Edit2: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Edit3: TEdit;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    LabelX: TLabel;
    LabelY: TLabel;
    Memo1: TMemo;
    ConnectRetryTimer: TTimer;
    ExitTimer: TTimer;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    PosTimer: TTimer;
    TimerBlankScreen: TTimer;
    TimerHide: TTimer;
    TrackBarH: TTrackBar;
    TrackBarD: TTrackBar;
    procedure CheckBox1Change(Sender: TObject);
    procedure ConnectRetryTimerTimer(Sender: TObject);
    procedure ExitTimerTimer(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormShow(Sender: TObject);
    procedure PosTimerTimer(Sender: TObject);
    procedure TimerBlankScreenTimer(Sender: TObject);
    procedure TimerHideTimer(Sender: TObject);
  private
    { Private declarations }
    ServerIPaddr,ServerIPport: string;
    CdCfound, StartCDC,Connecting,Closing,Restarting : boolean;
    ConnectRetry, ScreenTimeout: integer;
    LastPosX, LastPosY, LastMenu, InactiveLoop: integer;
    EncoderX,EncoderY,Hflip,Dflip : integer;
    card: SmallInt;
    RealEncoder:boolean;
    ScreenOn: boolean;
    cmdarg:Tstringlist;
    Function  GetTcpPort:string;
    procedure GetCdCInfo;
    procedure GetDaskInfo;
    procedure OpenCDC(param:string);
    function CdCCmd(cmd:string):string;
    procedure Connect;
    procedure DoConnect;
    procedure Disconnect;
    procedure Restart;
    procedure GetEncoder;
    function InitEncoder: boolean;
    procedure TurnScreen(onoff:boolean);
  public
    { Public declarations }
    {$ifndef astrolabe_static}
    client : TClientThrd;
    {$endif}
    CdC,CdCDir,CdCconfig: string;
    procedure Init;
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
   var  cardModel: integer = 9;
        cardNum: integer = 0;
        Hoffset: integer = 0;           // Encoder offset, hour angle
        Doffset: integer = 0;           // Encoder offset, declination
        Hdirection: string = '+';       // Encoder rotation direction, hour angle
        Ddirection: string = '+';       // Encoder rotation direction, declination
  {$endif}
  {$ifdef darwin}
        DefaultCdC='skychart';
        DefaultCdcDir='/Applications/Cartes du Ciel/skychart.app/Contents/MacOS';
        DefaultCdCconfig='~/Library/Application Support/skychart/skychart.ini';
   var  cardModel: integer = 9;
        cardNum: integer = 0;
        Hoffset: integer = 0;           // Encoder offset, hour angle
        Doffset: integer = 0;           // Encoder offset, declination
        Hdirection: string = '+';       // Encoder rotation direction, hour angle
        Ddirection: string = '+';       // Encoder rotation direction, declination
  {$endif}
  {$ifdef mswindows}
        DefaultCdC='skychart.exe';
        DefaultCdcDir='C:\Program Files\Ciel';
        DefaultCdCconfig='Skychart\skychart.ini';
   var
        // Default DASK card, can be replaced in dask.ini
        cardModel: integer = PCI_7248;  // ADLINK PCI 7248
        cardNum: integer = 0;           // First card
        Hoffset: integer = 0;           // Encoder offset, hour angle
        Doffset: integer = 0;           // Encoder offset, declination
        Hdirection: string = '+';       // Encoder rotation direction, hour angle
        Ddirection: string = '+';       // Encoder rotation direction, declination
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

procedure Tf_astrolabe.GetDaskInfo;
var cdir,daskconfig: string;
    inif: TMemIniFile;
begin
cdir:=GetCurrentDir;
daskconfig:=slash(cdir)+'dask.ini';
if FileExists(daskconfig) then begin
  inif := TMeminifile.Create(daskconfig);
  try
    cardModel := inif.ReadInteger('dask', 'model', cardModel);
    cardNum   := inif.ReadInteger('dask', 'number', cardNum);
    Hoffset   := inif.ReadInteger('encoder', 'Hoffset', Hoffset);
    Doffset   := inif.ReadInteger('encoder', 'Doffset', Doffset);
    Hdirection:= inif.ReadString('encoder', 'Hdirection', Hdirection);
    Ddirection:= inif.ReadString('encoder', 'Ddirection', Ddirection);
    ScreenTimeout:=inif.ReadInteger('screen', 'ScreenTimeout', ScreenTimeout);
  finally
    inif.Free;
  end;
  if Hdirection='+' then Hflip:=1 else Hflip:=-1;
  if Ddirection='+' then Dflip:=1 else Dflip:=-1;
end;
end;

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
  CdCDir:=ExtractFilePath(CdC);
  CdCfound:=FileExists(CdC);
end;
end;

procedure Tf_astrolabe.OpenCDC(param:string);
begin
{$ifndef astrolabe_static}
    Execnowait(CdC+' '+param);
{$endif}
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
{$ifndef astrolabe_static}
  if CheckBox1.Checked then memo1.Lines.Add(Data);
  if (data='Bye!')and(not closing) then   // unexpected failure in CdC
    Restart;
{$endif}
end;

procedure Tf_astrolabe.Connect;
begin
//Initial connection to CdC
//Check if CdC is already running
{$ifndef astrolabe_static}
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
{$endif}
end;

procedure Tf_astrolabe.ConnectRetryTimerTimer(Sender: TObject);
begin
  // wait CdC is started and ready for connection
{$ifndef astrolabe_static}
  ConnectRetryTimer.Enabled:=false;
  edit3.Text:='Wait Skychart startup ...';
  edit3.Invalidate;
  edit2.Text:=GetTcpPort;
  if edit2.Text<>'0' then DoConnect
     else ConnectRetryTimer.Enabled:=true;
{$endif}
end;

procedure Tf_astrolabe.CheckBox1Change(Sender: TObject);
begin
memo1.Visible:=CheckBox1.Checked;
memo1.clear;
end;

procedure Tf_astrolabe.DoConnect;
begin
// initialize connection to CdC after it is started
{$ifndef astrolabe_static}
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
{$endif}
end;

procedure Tf_astrolabe.Restart;
begin
{$ifndef astrolabe_static}
Restarting:=true;
Close;
{$endif}
end;

procedure Tf_astrolabe.Disconnect;
var resp:string;
begin
// disconnect from CdC
{$ifndef astrolabe_static}
PosTimer.Enabled:=False;
Closing:=true;
if (client<>nil)and(not client.Terminated) then begin
   resp:=client.Send('quit');
   if CheckBox1.Checked then memo1.lines.add(resp);
   client.terminate;
end;
{$endif}
end;

procedure Tf_astrolabe.FormClose(Sender: TObject; var Action: TCloseAction);
begin
{$ifndef astrolabe_static}
if not Closing then begin
  Disconnect;                // stop the connection before to close
  ExitTimer.Enabled:=true;
  Action:=caNone;
end;
{$endif}
if not ScreenOn then TurnScreen(true);
end;

procedure Tf_astrolabe.FormCreate(Sender: TObject);
begin
// program initialisation
DefaultFormatSettings.DecimalSeparator:='.';
DefaultFormatSettings.ThousandSeparator:=',';
DefaultFormatSettings.DateSeparator:='/';
DefaultFormatSettings.TimeSeparator:=':';
ScreenTimeout:=-1;
ScreenOn:=true;
Hflip:=1;
Dflip:=1;
GetCdCInfo;
GetDaskInfo;
edit1.Text:=ServerIPaddr;
edit2.Text:=ServerIPport;
PosTimer.Interval:=EncoderPooling;
ConnectRetry:=0;
InactiveLoop:=0;
LastPosX:=MaxInt;
LastPosY:=MaxInt;
LastMenu:=-1;
Closing:=false;
Restarting:=false;
RealEncoder:=InitEncoder;
Top:=0;
Left:=0;
WideLine:=5;
MarkWidth:=3;
MarkType:=2;
memo1.Visible:=false;
Panel2.Visible:=not RealEncoder;
Panel3.Visible:=true;
{$ifdef astrolabe_static}
Panel1.Visible:=false;
{$endif}
cmdarg:=Tstringlist.Create;
end;

procedure Tf_astrolabe.FormDestroy(Sender: TObject);
begin
cmdarg.free;
{$ifndef astrolabe_static}
  if Restarting then ExecNoWait(paramstr(0));
{$endif}
end;

procedure Tf_astrolabe.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
{$ifndef astrolabe_static}
  // help small trackbar movement
  case key of
  37 : TrackBarH.Position:=TrackBarH.Position-1;
  38 : TrackBarD.Position:=TrackBarD.Position+1;
  39 : TrackBarH.Position:=TrackBarH.Position+1;
  40 : TrackBarD.Position:=TrackBarD.Position-1;
  end;
{$endif}
end;

procedure Tf_astrolabe.ExitTimerTimer(Sender: TObject);
begin
{$ifndef astrolabe_static}
  ExitTimer.Enabled:=false;
  if StartCDC then begin
     OpenCDC('--unique --quit');  // close CdC if we start it
  end;
  StartCDC:=false;
  sleep(1000);
  Application.ProcessMessages;
  Close;                          // return to really close this time
{$endif}
end;

procedure Tf_astrolabe.FormShow(Sender: TObject);
begin
TimerHide.Enabled:=true;
if ScreenTimeout>0 then begin
  TimerBlankScreen.Interval:=1000*ScreenTimeout;
  TimerBlankScreen.Enabled:=true;
end;
end;

procedure Tf_astrolabe.Init;
begin
{$ifndef astrolabe_static}
  // automatic connection at startup
  Connect;
{$else}
  f_main.Show;
  PosTimer.Enabled:=True;
{$endif}
end;

function Tf_astrolabe.CdCCmd(cmd:string):string;
var resp:string;
    i: integer;
begin
// Send command to CdC and wait for response
{$ifndef astrolabe_static}
if (client<>nil)and(not client.Terminated) then begin
   if CheckBox1.Checked then memo1.lines.add(cmd);
   resp:=client.Send(cmd);
   if CheckBox1.Checked then memo1.lines.add(resp);
   result:=resp;
end;
{$else}
   if CheckBox1.Checked then memo1.lines.add(cmd);
   splitarg(cmd,blank,cmdarg);
   for i:=cmdarg.count to MaxCmdArg do cmdarg.add('');
   resp:=f_main.ExecuteCmd('',cmdarg);
   if CheckBox1.Checked then memo1.lines.add(resp);
   result:=resp;
{$endif}
end;

procedure Tf_astrolabe.GetEncoder;
var PA,PB,PC,x1,x2,x3: word;
    va,vb,vc: Cardinal;
procedure FixRange;
begin
  // apply offset from ini file
  EncoderX:=(Hflip*EncoderX+Hoffset+720) mod 360;
  EncoderY:=(Dflip*EncoderY+Doffset+720+90) mod 360;
  // convert 0-360 range to valid HA/DEC
  if (EncoderY>90) then begin
    if (EncoderY<=270) then begin
     EncoderY:=180-EncoderY;
     EncoderX:=EncoderX+180;
  end else begin
     EncoderY:=EncoderY-360;
  end;
  end;
  EncoderX:=((EncoderX+720) mod 360)-180;
end;
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
  EncoderX:=x1 + 10*x2 + 100*x3;
  x1:=(PC AND $F);
  x2:=(PC AND $F0) SHR 4;
  x3:=PB SHR 6;
  EncoderY:=x1 + 10*x2 + 100*x3;
  FixRange;
  LabelX.Caption:=inttostr(EncoderX);
  LabelY.Caption:=inttostr(EncoderY);
  {$endif}
end else begin
 // simulation using two trackbar:
 EncoderX:=TrackBarH.Position;
 EncoderY:=TrackBarD.Position;
 FixRange;
 LabelX.Caption:=inttostr(EncoderX);
 LabelY.Caption:=inttostr(EncoderY);
end;
end;

procedure Tf_astrolabe.PosTimerTimer(Sender: TObject);
var inactivity,menuup: boolean;
    menu: integer;
begin
{$ifdef astrolabe_static}
 if f_main.Closing then Close
   else begin
{$endif}
try
PosTimer.Enabled:=false;
inc(InactiveLoop);
GetEncoder;
if (ScreenTimeout>0) and
   ((EncoderX<>LastPosX) or
   (EncoderY<>LastPosY))
  then begin
    TimerBlankScreen.Enabled:=false;
    TimerBlankScreen.Enabled:=true;
    if not ScreenOn then TurnScreen(true);
end;
inactivity:=(InactiveLoop*PosTimer.Interval/1000>60);
if (EncoderX<>LastPosX)or           // moved AH coder
  (EncoderY<>LastPosY) or           // moved Dec coder
  inactivity                        // one minute inactive,
  then begin
    // menu area
    if (EncoderX>=85)and(EncoderX<=110)and(EncoderY>=20)and(EncoderY<=50) then begin
      if (abs(EncoderX-LastPosX)>=2)or(abs(EncoderY-LastPosY)>=2) then begin
        menuup:=(EncoderX>LastPosX)or(EncoderY>LastPosY);
        if menuup then menu:=LastMenu+1
                  else menu:=LastMenu-1;
        if menu>8 then menu:=0;
        if menu<0 then menu:=8;
        CdCCmd('PLANETINFO '+inttostr(menu));
        LastPosX := EncoderX;
        LastPosY := EncoderY;
        LastMenu:=menu;
      end;
    end else begin
      CdCCmd('PLANETINFO OFF');
      CdCCmd('MOVESCOPEH '+FormatFloat('0.00',EncoderX/15)+' '+FormatFloat('0.00',EncoderY));
      CdCCmd('IDSCOPE');
      LastMenu:=-1;
      LastPosX := EncoderX;
      LastPosY := EncoderY;
    end;
    InactiveLoop:=0;
    Application.ProcessMessages;
end;
finally
PosTimer.Enabled:=true;
end;
{$ifdef astrolabe_static}
end;
{$endif}
end;

procedure Tf_astrolabe.TimerHideTimer(Sender: TObject);
begin
  TimerHide.Enabled:=false;
  f_main.BringToFront;
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

procedure Tf_astrolabe.TimerBlankScreenTimer(Sender: TObject);
begin
TurnScreen(false);
end;

procedure Tf_astrolabe.TurnScreen(onoff:boolean);
const SC_MONITORPOWER = $F170;
      WM_SYSCOMMAND = $0112;
      MONITOR_ON = -1;
      MONITOR_OFF = 2;
begin
{$ifdef mswindows}
if onoff then begin
 ScreenOn:=true;
 SendMessage(f_astrolabe.Handle,WM_SYSCOMMAND, SC_MONITORPOWER, MONITOR_ON);
end else begin
  ScreenOn:=false;
  SendMessage(f_astrolabe.Handle,WM_SYSCOMMAND, SC_MONITORPOWER, MONITOR_OFF);
end;
Application.ProcessMessages;
{$endif}
end;

end.
