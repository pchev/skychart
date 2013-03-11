unit ds2cdc1;

{$MODE Delphi}

//{$define trace_debug}

{
   This software is free of any right.
   It can be used or modified as you want at your sole responsibility.

   Program author : Patrick Chevalley
                    Switzerland
                    pch@ap-i.net
}
interface

uses Sky_DDE_util, cu_tcpclient, ExtCtrls, Registry, fileutil,
  Windows, Messages, SysUtils, Classes, Forms, Dialogs;

Procedure DrawChart(rah,ram,Decd,decm : Double; FOV,Comport,LX200Delay : smallint;
                    TCaption,DSappname,HGCPath,STychoPath,ScopeType : ansistring; forceBW,MW : Byte) ;stdcall;
Procedure CenterOnConst(conname,TCaption,DSappname,HGCPath,STychoPath,ScopeType : ansistring;
                        Comport,LX200Delay : integer; forceBW,MW : Byte) ;stdcall;
Procedure PlotDSO(rah,ram,Decd,decm : Double; DecSign,ObjType : byte; ObjSize : smallint;
                  DSOLabel,DSODesc,DSONotes,ChartImagePath : ansistring; Observed,LastObject : Byte); stdcall;
Procedure CloseChart; stdcall;
Procedure CDC_SetObservatory(Latitude,Longitude,TimeZone : Double; ObsName : AnsiString); stdcall;
Procedure CDC_SetDate(Year,Month,Day,Hour,Minute : SmallInt); stdcall;
Procedure CDC_PlotDSS(DssDir,ImagePath,ImageName : ansistring; UseExistingImage : byte); stdcall;
Procedure CDC_ShowDSS(rah,ram,Decd,decm,FOV : Double; DssDir,ImagePath,ImageName : ansistring; UseExistingImage : byte); stdcall;
Procedure CDC_Redraw; stdcall;
Procedure CDC_PlotVar(VarName,VarType : ansistring; MagMax, MagMin, Epoch, Period, RiseTime : Double; LastObject : byte); stdcall;
Procedure CDC_CloseVarObs; stdcall;

type Tds2cdc= class(TObject)
public
ConnectTimer: TTimer;
InitTimer: TTimer;
DrawTimer: TTimer;
DSSTimer: TTimer;
client : TClientThrd;
c,v : textfile;
arc : double;
dec : double;
la : double;
CielInstalled : boolean;
VarInstalled : boolean;
param,paramcmd : string;
vparam : string;
InitOK: boolean;
FileIsOpen : boolean;
VarIsOpen : boolean;
SkyChartStarting : boolean;
CielHnd : Thandle;
DSScmd : string;
lastcmd : string;
tcpport : string;
blank256 : string;
StartedByDS : Boolean;
Constructor Create;
Destructor Destroy;
procedure ConnectTimerTimer(Sender: TObject);
procedure InitTimerTimer(Sender: TObject);
procedure DrawTimerTimer(Sender: TObject);
procedure DSSTimerTimer(Sender: TObject);
procedure InitTcpIp;
Procedure InitSkyChart;
function Executecmd(cmd: string):string;
procedure SetForground;
procedure ShowInfo(Sender: TObject; const messagetext:string);
procedure ReceiveData(Sender : TObject; const data : string);
Procedure Redraw;
Procedure OpenCatalogFile;
Procedure CloseCatalogFile;

Procedure FDrawChart(rah,ram,Decd,decm : Double; FOV,Comport,LX200Delay : smallint;
                    TCaption,DSappname,HGCPath,STychoPath,ScopeType : ansistring; forceBW,MW : Byte) ;
Procedure FCenterOnConst(conname,TCaption,DSappname,HGCPath,STychoPath,ScopeType : ansistring;
                        Comport,LX200Delay : integer; forceBW,MW : Byte) ;
Procedure FPlotDSO(rah,ram,Decd,decm : Double; DecSign,ObjType : byte; ObjSize : smallint;
                  DSOLabel,DSODesc,DSONotes,ChartImagePath : ansistring; Observed,LastObject : Byte);
Procedure FCloseChart;
Procedure FCDC_SetObservatory(Latitude,Longitude,TimeZone : Double; ObsName : AnsiString);
Procedure FCDC_SetDate(Year,Month,Day,Hour,Minute : SmallInt);
Procedure FCDC_PlotDSS(DssDir,ImagePath,ImageName : ansistring; UseExistingImage : byte);
Procedure FCDC_ShowDSS(rah,ram,Decd,decm,FOV : Double; DssDir,ImagePath,ImageName : ansistring; UseExistingImage : byte);
Procedure FCDC_Redraw;
Procedure FCDC_PlotVar(VarName,VarType : ansistring; MagMax, MagMin, Epoch, Period, RiseTime : Double; LastObject : byte);
Procedure FCDC_CloseVarObs;

end;

const
      constel : array[1..89] of string = ('AND','ANT','APS','AQR','AQL','ARA','ARI','AUR','BOO','CAE','CAM','CNC','CVN','CMA','CMI','CAP','CAR','CAS','CEN','CEP','CET','CHA','CIR','COL','COM','CRA','CRB','CRV','CRT','CRU','CYG','DEL','DOR','DRA','EQU','ERI','FOR','GEM','GRU','HER','HOR','HYA','HYI','IND','LAC','LEO','LMI','LEP','LIB','LUP','LYN','LYR','MEN','MIC','MON','MUS','NOR','OCT','OPH','ORI','PAV','PEG','PER','PHE','PIC','PSC','PSA','PUP','PYX','RET','SGE','SGR','SCO','SCL','SCT','SER','SER','SEX','TAU','TEL','TRI','TRA','TUC','UMA','UMI','VEL','VIR','VOL','VUL');
      tab : char = chr($9);
      crlf : array[1..2] of char =(chr($D),chr($A));
      blank20='                    ';
      blank=' ';

var ds2c : Tds2cdc;

implementation

constructor Tds2cdc.Create;
var i: integer;
begin
{$ifdef trace_debug}
inittrace;
writetrace('Enter ds2cdc');
{$endif}
inherited Create;
arc := 0.0;
dec := 0.0;
la := 35;
param :='';
vparam :='';
tcpport:='0';
InitOK:=false;
FileIsOpen := false;
VarIsOpen := false;
SkyChartStarting := false;
StartedByDS := false;
ConnectTimer:=TTimer.Create(nil);
ConnectTimer.Enabled:=false;
ConnectTimer.Interval:=2000;
ConnectTimer.OnTimer:=ConnectTimerTimer;
InitTimer:=TTimer.Create(nil);
InitTimer.Enabled:=false;
InitTimer.Interval:=1000;
InitTimer.OnTimer:=InitTimerTimer;
DrawTimer:=TTimer.Create(nil);
DrawTimer.Enabled:=false;
DrawTimer.Interval:=2000;
DrawTimer.OnTimer:=DrawTimerTimer;
DSSTimer:=TTimer.Create(nil);
DSSTimer.Enabled:=false;
DSSTimer.Interval:=1000;
DSSTimer.OnTimer:=DSSTimerTimer;
blank256:='';
for i:=1 to 256 do blank256:=blank256+' ';
end;

destructor Tds2cdc.Destroy;
begin
{$ifdef trace_debug}
writetrace('Exit ds2cdc');
{$endif}
try
  ConnectTimer.Free;
  InitTimer.Free;
  DrawTimer.Free;
  DSSTimer.Free;
  FCloseChart;
  FCDC_CloseVarObs;
  inherited Destroy;
except
end;
end;

Procedure Tds2cdc.InitSkyChart;
var Registry1: TRegistry;
    timeout: TDateTime;
begin
{$ifdef trace_debug}
writetrace('InitSkyChart');
{$endif}
InitOK:=false;
Registry1 := TRegistry.Create;
with Registry1 do begin
  if Openkey('Software\Astro_PC\Ciel\Status',false) then begin
    if ValueExists('TcpPort') then tcpport:=ReadString('TcpPort')
       else tcpport:='0';
    CloseKey;
  end;
end;
Registry1.Free;
skychartok := SkyChartRunning and (tcpport<>'0');  // is app already running
if skychartok then begin
  InitTcpIp;                   // start communication
end else begin
  SkyChartStarting:=true;
  StartSkyChart(param);        // if not start it with parameters
  param:='';
  StartedByDS:=true;
  ConnectTimer.Enabled:=true;  // wait app start
end;
timeout:=now+90/3600/24; // 90 seconds
repeat
 sleep(100);
 Application.processmessages;
until initOK or (now>timeout);
ConnectTimer.Enabled:=false;  // stop to try after timeout
InitTimer.Enabled:=false;
end;

procedure Tds2cdc.InitTcpIp;
begin
if ((client=nil)or not((client.Initializing)or(client.Ready))  ) then begin
  {$ifdef trace_debug}
  writetrace('InitTcpIp');
  {$endif}
  client:=TClientThrd.Create;
  client.TargetHost:='localhost';
  client.TargetPort:=tcpport;
  client.Timeout := 500;    // tcp/ip timeout [ms] also act as a delay before to send command
  client.CmdTimeout := 3;  // cdc response timeout [seconds]
  client.onShowMessage:=ShowInfo;
  client.onReceiveData:=ReceiveData;
  client.Resume;
  SkyChartStarting:=false;
  InitTimer.Enabled:=true;
end;
end;

procedure Tds2cdc.InitTimerTimer(Sender: TObject);
begin
{$ifdef trace_debug}
writetrace('InitTimer '+lastcmd);
{$endif}
  InitTimer.Enabled:=false;
  if lastcmd='' then lastcmd:='listchart';
  Executecmd(lastcmd);  // first command is expected to timeout
  sleep(100);
  Executecmd(lastcmd);
  InitOK:=true;
end;

procedure Tds2cdc.ConnectTimerTimer(Sender: TObject);
var Registry1: TRegistry;
begin
{$ifdef trace_debug}
writetrace('ConnectTimer');
{$endif}
ConnectTimer.Enabled:=false;                            // stop timer to avoid multiple call
Registry1 := TRegistry.Create;
with Registry1 do begin
  if Openkey('Software\Astro_PC\Ciel\Status',false) then begin
    if ValueExists('TcpPort') then tcpport:=ReadString('TcpPort')
       else tcpport:='0';
    CloseKey;
  end;
end;
Registry1.Free;
if SkyChartRunning and (tcpport<>'0') then begin       // is app running
   sleep(500);                                   // a litle more time to initialize
   InitTcpIp;                                     // start communication
   skychartok:=true;
end
else ConnectTimer.Enabled:=true;
end;

function Tds2cdc.Executecmd(cmd: string):string;
// send command to skychart by tcp/ip
begin
{$ifdef trace_debug}
writetrace('Executecmd '+cmd);
{$endif}
lastcmd:=cmd;
if (skychartok)and(client<>nil){and(client.Ready)}and(not client.Terminated) then begin
   if SkyChartRunning then
      result:=client.Send(cmd)
   else begin
     param:='--unique --nosave --loaddef="'+workdir+'\ds2000.cdc3" '+paramcmd;
     InitSkyChart;
   end;
end else begin
  if cmd<>'REDRAW' then begin
    param:='--unique --nosave --loaddef="'+workdir+'\ds2000.cdc3" '+paramcmd;
    InitSkyChart;
  end;
end;
end;

procedure Tds2cdc.SetForground;
begin
CielHnd:=findwindow(nil,Pchar(skychartcaption));
if cielhnd<>0 then begin
  SendMessage(CielHnd, WM_SYSCOMMAND, SC_RESTORE, 0);
  SetForegroundWindow(CielHnd);
end;
end;

procedure Tds2cdc.ShowInfo(Sender: TObject; const messagetext:string);
var buf: string;
begin
// process here socket status message.
  buf:=messagetext;
end;

procedure Tds2cdc.ReceiveData(Sender : TObject; const data : string);
var buf: string;
begin
// process here unattended message from Cartes du Ciel.
  buf:=data;
end;


Procedure Tds2cdc.OpenCatalogFile;
begin
try
if FileIsOpen then Closefile(c);
finally
assignfile(c,workdir+'\ds2000.dat');
rewrite(c);
FileIsOpen:=true;
end;
end;

Procedure Tds2cdc.CloseCatalogFile;
begin
try
if FileIsOpen then begin
  FileIsOpen:=false;
  closefile(c);
end;
finally
end;
end;

Procedure Tds2cdc.FDrawChart(rah,ram,Decd,decm : Double; FOV,Comport,LX200Delay : smallint;
                    TCaption,DSappname,HGCPath,STychoPath,ScopeType : ansistring; forceBW,MW : Byte) ;
var cmd : string;
begin
if not CielInstalled then exit;
arc:=rah+ram/60;
dec:=decd+sgn(decd)*decm/60;
la:=fov;
cmd := 'MOVE RA:'+trim(artostr(arc))+' DEC:'+trim(detostr(dec))+' FOV:'+trim(detostr(la));
paramcmd :=' --setra='+floattostr(arc)+' --setdec='+floattostr(dec)+' --setfov='+floattostr(la);
CloseCatalogFile;
Executecmd(cmd);
cmd:='REDRAW';
Executecmd(cmd);
Setforground;
end;

Procedure Tds2cdc.FCenterOnConst(conname,TCaption,DSappname,HGCPath,STychoPath,ScopeType : ansistring;
                        Comport,LX200Delay : integer; forceBW,MW : Byte) ;
var n,i : integer;
    cmd : string;
begin
DrawTimer.enabled:=false;
if not CielInstalled then exit;
CloseCatalogFile;
conname:=uppercase(conname);
paramcmd:=' --search='+conname;
cmd := 'FIND 11 '+conname;
Executecmd(cmd);
cmd:='REDRAW';
Executecmd(cmd);
Setforground;
end;

Procedure Tds2cdc.FPlotDSO(rah,ram,Decd,decm : Double; DecSign,ObjType : byte; ObjSize : smallint;
                  DSOLabel,DSODesc,DSONotes,ChartImagePath : ansistring; Observed,LastObject : Byte);
var
desc,notes,cmd : string;
begin
DrawTimer.enabled:=false;
if not CielInstalled then exit;
desc:=DSODesc;
desc:=stringreplace(desc,':',' ',[rfReplaceAll]);
desc:=stringreplace(desc,crlf,tab+'d:',[rfReplaceAll]);
desc:=stringreplace(desc,'\O','',[rfReplaceAll]);
desc:=stringreplace(desc,'\D','',[rfReplaceAll]);
desc:=stringreplace(desc,'\L','',[rfReplaceAll]);
desc:=stringreplace(desc,'\U','',[rfReplaceAll]);
notes:=DSONotes;
notes:=stringreplace(notes,':',' ',[rfReplaceAll]);
notes:=stringreplace(notes,crlf,tab+'n:',[rfReplaceAll]);
if not FileIsOpen then OpenCatalogFile;
writeln(c,copy(DSOLabel+blank20,1,20),blank,
          copy(floattostrf(rah+ram/60,fffixed,10,6)+blank20,1,20),blank,
          copy(floattostrf(decd+sgn(decd)*decm/60,fffixed,10,6)+blank20,1,20),blank,
          copy(inttostr(objtype)+blank20,1,20),blank,
          copy(inttostr(objsize)+blank20,1,20),blank,
          trim(desc),blank,
          notes);
if LastObject=1 then begin
  CloseCatalogFile;
  cmd := 'MOVE RA:'+trim(artostr(arc))+' DEC:'+trim(detostr(dec))+' FOV:'+trim(detostr(la));
  paramcmd :=' --setra='+floattostr(arc)+' --setdec='+floattostr(dec)+' --setfov='+floattostr(la);
  Executecmd(cmd);
  cmd:='SETCAT "'+workdir+'" d2k 1 0 10';
  paramcmd:='--setcat="""'+workdir+'"" d2k 1 0 10"';
  Executecmd(cmd);
  cmd:='REDRAW';
  Executecmd(cmd);
  Setforground;
end;
{else begin
  DrawTimer.interval:=2000;
  DrawTimer.enabled:=true;
end; }
end;

Procedure Tds2cdc.FCloseChart;
begin
DrawTimer.enabled:=false;
if not CielInstalled then exit;
if StartedByDS then begin
   if initok then executecmd('shutdown');
   PostMessage(findwindow(nil,Pchar(skychartcaption)),WM_QUIT,0,0);   // close skychart
end;
end;

Procedure Tds2cdc.FCDC_SetObservatory(Latitude,Longitude,TimeZone : Double; ObsName : AnsiString);
var msg : string;
begin
if not CielInstalled then exit;
msg:='LAT:'+trim(detostr2(Latitude))+' LON:'+trim(detostr2(Longitude))+' ALT:0m TZ:'+trim(floattostr(-1*timezone))+'h OBS:'+trim(ObsName);
paramcmd:=' --setobs="'+msg+'"';
msg:='OBSL '+msg;
Executecmd(msg);
end;

Procedure Tds2cdc.FCDC_SetDate(Year,Month,Day,Hour,Minute : SmallInt);
var msg : string;
begin
if not CielInstalled then exit;
msg:=inttostr(year)+'-'+inttostr(month)+'-'+inttostr(day)+'T'+inttostr(hour)+':'+inttostr(minute)+':00';
paramcmd:='--setdate="'+msg+'"';
msg:='DATE '+msg;
Executecmd(msg);
end;

Procedure Tds2cdc.FCDC_PlotDSS(DssDir,ImagePath,ImageName : ansistring; UseExistingImage : byte);
var p4 : string;
    StartedByMe : boolean;
begin
DrawTimer.enabled:=false;
if not CielInstalled then exit;
CloseCatalogFile;
if trim(DssDir)='' then DssDir:='.';
if trim(ImagePath)='' then ImagePath:='.';
if trim(ImageName)='' then ImageName:='.';
if UseExistingImage=1 then p4:='1' else p4:='0';
paramcmd:=' --dss="'+DssDir+' '+ImagePath+' '+ImageName+' '+p4+'"';
DSScmd := 'PDSS '+DssDir+' '+ImagePath+' '+ImageName+' '+p4;
Executecmd(DSScmd);
Executecmd('REDRAW');
Setforground;
end;

Procedure Tds2cdc.Redraw;
var cmd : string;
begin
DrawTimer.enabled:=false;
if not CielInstalled then exit;
CloseCatalogFile;
paramcmd :=' --setra='+floattostr(arc)+' --setdec='+floattostr(dec)+' --setfov='+floattostr(la);
cmd := 'MOVE RA:'+trim(artostr(arc))+' DEC:'+trim(detostr(dec))+' FOV:'+trim(detostr(la));
Executecmd(cmd);
cmd:='REDRAW';
Executecmd(cmd);
Setforground;
end;

procedure Tds2cdc.DrawTimerTimer(Sender: TObject);
begin
Redraw;
end;

Procedure Tds2cdc.FCDC_Redraw;
begin
Redraw;
end;

procedure Tds2cdc.DSSTimerTimer(Sender: TObject);
begin
if not SkyChartStarting then begin
   DSSTimer.enabled:=false;
   Executecmd(DSScmd);
   Executecmd('REDRAW');
   Setforground;
end;
end;

Procedure Tds2cdc.FCDC_ShowDSS(rah,ram,Decd,decm,FOV : Double; DssDir,ImagePath,ImageName : ansistring; UseExistingImage : byte);
var cmd : string;
begin
if not CielInstalled then exit;
arc:=rah+ram/60;
dec:=decd+sgn(decd)*decm/60;
la:=fov;
paramcmd :=' --setra='+floattostr(arc)+' --setdec='+floattostr(dec)+' --setfov='+floattostr(la);
cmd := 'MOVE RA:'+trim(artostr(arc))+' DEC:'+trim(detostr(dec))+' FOV:'+trim(detostr(la));
Executecmd(cmd);
cmd:='REDRAW';
Executecmd(cmd);
CDC_PlotDSS(DssDir,ImagePath,ImageName,UseExistingImage);
end;

Procedure Tds2cdc.FCDC_PlotVar(VarName,VarType : ansistring; MagMax, MagMin, Epoch, Period, RiseTime : Double; LastObject : byte);
var buf,b1,b2,b3,b4,b5 : string;
begin
if not VarInstalled then exit;
if not VarIsOpen then begin
    assignfile(v,workdir+'\ds2000.var');
    rewrite(v);
    VarIsOpen:=true;
    vparam:=' -c '+workdir+'\ds2000.var'+' -n';
end;
if trim(varname)='' then varname:='Var?';
buf:=trim(varname);
b1:=trim(vartype);
b2:=floattostr(magmax)+','+floattostr(magmin);
if epoch>0 then b3:=floattostr(epoch) else b3:='';
if period>0 then b4:=floattostr(period) else b4:='';
if risetime>0 then b5:=floattostr(risetime) else b5:='';
buf:=buf+','+b1+','+b2+','+b3+','+b4+','+b5;
Writeln(v,buf);
if lastobject=1 then begin
   CloseFile(v);
   VarIsOpen:=false;
   StartVarobs(vparam);
end;
end;

Procedure Tds2cdc.FCDC_CloseVarObs;
begin
if not VarInstalled then exit;
PostMessage(findwindow(nil,Pchar('VarObs')),WM_CLOSE,0,0);
end;


//////////////////////////////////////////////////////////////

Procedure DrawChart(rah,ram,Decd,decm : Double; FOV,Comport,LX200Delay : smallint;
                    TCaption,DSappname,HGCPath,STychoPath,ScopeType : ansistring; forceBW,MW : Byte) ;stdcall;
begin
  ds2c.FDrawChart(rah,ram,Decd,decm,FOV,Comport,LX200Delay,TCaption,DSappname,HGCPath,STychoPath,ScopeType,forceBW,MW) ;
end;

Procedure CenterOnConst(conname,TCaption,DSappname,HGCPath,STychoPath,ScopeType : ansistring;
                        Comport,LX200Delay : integer; forceBW,MW : Byte) ;stdcall;
begin
  ds2c.FCenterOnConst(conname,TCaption,DSappname,HGCPath,STychoPath,ScopeType,
                        Comport,LX200Delay,forceBW,MW) ;
end;

Procedure PlotDSO(rah,ram,Decd,decm : Double; DecSign,ObjType : byte; ObjSize : smallint;
                  DSOLabel,DSODesc,DSONotes,ChartImagePath : ansistring; Observed,LastObject : Byte); stdcall;
begin
  ds2c.FPlotDSO(rah,ram,Decd,decm,DecSign,ObjType,ObjSize,
                  DSOLabel,DSODesc,DSONotes,ChartImagePath,Observed,LastObject);
end;

Procedure CloseChart; stdcall;
begin
  ds2c.FCloseChart;
end;

Procedure CDC_SetObservatory(Latitude,Longitude,TimeZone : Double; ObsName : AnsiString); stdcall;
begin
  ds2c.FCDC_SetObservatory(Latitude,Longitude,TimeZone,ObsName);
end;

Procedure CDC_SetDate(Year,Month,Day,Hour,Minute : SmallInt); stdcall;
begin
  ds2c.FCDC_SetDate(Year,Month,Day,Hour,Minute);
end;

Procedure CDC_PlotDSS(DssDir,ImagePath,ImageName : ansistring; UseExistingImage : byte); stdcall;
begin
  ds2c.FCDC_PlotDSS(DssDir,ImagePath,ImageName,UseExistingImage);
end;

Procedure CDC_ShowDSS(rah,ram,Decd,decm,FOV : Double; DssDir,ImagePath,ImageName : ansistring; UseExistingImage : byte); stdcall;
begin
  ds2c.FCDC_ShowDSS(rah,ram,Decd,decm,FOV,DssDir,ImagePath,ImageName,UseExistingImage);
end;

Procedure CDC_Redraw; stdcall;
begin
  ds2c.FCDC_Redraw;
end;

Procedure CDC_PlotVar(VarName,VarType : ansistring; MagMax, MagMin, Epoch, Period, RiseTime : Double; LastObject : byte); stdcall;
begin
  ds2c.FCDC_PlotVar(VarName,VarType,MagMax, MagMin, Epoch, Period, RiseTime,LastObject);
end;

Procedure CDC_CloseVarObs; stdcall;
begin
  ds2c.FCDC_CloseVarObs;
end;

end.
