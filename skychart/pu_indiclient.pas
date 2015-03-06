unit pu_indiclient;

{$MODE objfpc}{$H+}

{------------- interface for INDI telescope driver. ----------------------------

Copyright (C) 2011,2014 Patrick Chevalley

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

-------------------------------------------------------------------------------}

interface

uses u_help, u_translation, indibaseclient, indibasedevice, indiapi, indicom,
  LCLIntf, u_util, u_constant, Messages, SysUtils, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, Buttons, inifiles, process, ComCtrls, Menus,
  ExtCtrls;

type

  { Tpop_indi }

  Tpop_indi = class(TForm)
    GroupBox3: TGroupBox;
    Connect: TButton;
    Memomsg: TMemo;
    IndiProcess: TProcess;
    SpeedButton2: TButton;
    Disconnect: TButton;
    led: TEdit;
    Panel1: TPanel;
    LabelAlpha: TLabel;
    LabelDelta: TLabel;
    pos_x: TEdit;
    pos_y: TEdit;
    GroupBox1: TGroupBox;
    Edit1: TEdit;
    SpeedButton6: TButton;
    SpeedButton4: TButton;
    InitTimer: TTimer;
    {Utility and form functions}
    procedure FormCreate(Sender: TObject);
    procedure InitTimerTimer(Sender: TObject);
    procedure kill(Sender: TObject; var CanClose: Boolean);
    procedure ConnectClick(Sender: TObject);
    procedure SaveConfig;
    procedure DisconnectClick(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure SpeedButton4Click(Sender: TObject);
    procedure SpeedButton6Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
    client: TIndiBaseClient;
    TelescopeDevice: Basedevice;
    scope_port: ITextVectorProperty;
    coord_prop: INumberVectorProperty;
    coord_ra:   INumber;
    coord_dec:  INumber;
    oncoordset_prop: ISwitchVectorProperty;
    setslew_prop:    ISwitch;
    settrack_prop:   ISwitch;
    setsync_prop:    ISwitch;
    abortmotion_prop:ISwitchVectorProperty;
    abort_prop:      ISwitch;
    GeographicCoord_prop:INumberVectorProperty;
    SlewRate_prop:   ISwitchVectorProperty;
    MotionRate_prop: INumberVectorProperty;
    moveNS_prop:     ISwitchVectorProperty;
    moveN_prop:      ISwitch;
    moveS_prop:      ISwitch;
    moveEW_prop:     ISwitchVectorProperty;
    moveE_prop:      ISwitch;
    moveW_prop:      ISwitch;
    eod_coord:  boolean;
    ready,connected: boolean;
    SlewRateList: TStringList;
    procedure ClearStatus;
    procedure CheckStatus;
    procedure NewDevice(dp: Basedevice);
    procedure NewMessage(msg: string);
    procedure NewProperty(indiProp: IndiProperty);
    procedure NewNumber(nvp: INumberVectorProperty);
    procedure NewText(tvp: ITextVectorProperty);
    procedure NewSwitch(svp: ISwitchVectorProperty);
    procedure NewLight(lvp: ILightVectorProperty);
    procedure ServerConnected(Sender: TObject);
    procedure ServerDisconnected(Sender: TObject);
  public
    { Public declarations }
    csc: Tconf_skychart;
    procedure SetLang;
    function  ReadConfig(ConfigPath : shortstring):boolean;
    Procedure ScopeShow;
    Procedure ScopeShowModal(var ok : boolean);
    Procedure ScopeConnect(var ok : boolean);
    Procedure ScopeDisconnect(var ok : boolean; updstatus:boolean=true);
    Procedure ScopeGetInfo(var scName : shortstring; var QueryOK,SyncOK,GotoOK : boolean; var refreshrate : integer);
    Procedure ScopeGetEqSys(var EqSys : double);
    Procedure ScopeSetObs(la,lo : double);
    Procedure ScopeAlign(source : string; ra,dec : single);
    Procedure ScopeGetRaDec(var ra,de : double; var ok : boolean);
    Procedure ScopeGetAltAz(var alt,az : double; var ok : boolean);
    Procedure ScopeGoto(ra,de : single; var ok : boolean);
    Procedure ScopeAbortSlew;
    Procedure ScopeReset;
    Function  ScopeInitialized : boolean ;
    Function  ScopeConnected : boolean ;
    Procedure ScopeClose;
    Procedure ScopeReadConfig(ConfigPath : shortstring);
    procedure GetScopeRates(var nrates:integer;var srate: TStringList);
    procedure ScopeMoveAxis(axis:Integer; rate: string);
  end;

implementation
{$R *.lfm}

procedure Tpop_indi.ClearStatus;
begin
    coord_prop:=nil;
    abortmotion_prop:=nil;
    SlewRate_prop:=nil;
    MotionRate_prop:=nil;
    moveNS_prop:=nil;
    moveEW_prop:=nil;
    oncoordset_prop:=nil;
    GeographicCoord_prop:=nil;
    TelescopeDevice:=nil;
    scope_port:=nil;
    ready:=false;
    connected := false;
    eod_coord:=true;
    led.color:=clRed;
    SlewRateList.Clear;
end;

procedure Tpop_indi.CheckStatus;
begin
    if connected and
       (coord_prop<>nil) and
       (oncoordset_prop<>nil)
    then begin
       ready:=true;
       led.color:=clLime;
    end;
end;


procedure Tpop_indi.ServerConnected(Sender: TObject);
begin
   Memomsg.Lines.Add('Server connected');
   if (scope_port<>nil)and(csc.IndiPort<>'') then begin
      scope_port.tp[0].text:=csc.IndiPort;
      client.sendNewText(scope_port);
   end;
   client.connectDevice(csc.IndiDevice);
end;

procedure Tpop_indi.ServerDisconnected(Sender: TObject);
begin
  Memomsg.Lines.Add('Server disconnected');
  ClearStatus;
  led.color:=clRed;
end;

procedure Tpop_indi.NewDevice(dp: Basedevice);
begin
//  Memomsg.Lines.Add('Newdev: '+dp.getDeviceName);
  if dp.getDeviceName=csc.IndiDevice then begin
     connected:=true;
     TelescopeDevice:=dp;
  end;
end;

procedure Tpop_indi.NewMessage(msg: string);
begin
  if Memomsg.Lines.Count>4 then Memomsg.Lines.Delete(0);
  Memomsg.Lines.Add(msg);
end;

procedure Tpop_indi.NewProperty(indiProp: IndiProperty);
var propname: string;
    proptype: INDI_TYPE;
    i: integer;
begin
//  Memomsg.Lines.Add('Newprop: '+indiProp.getDeviceName+' '+indiProp.getName+' '+indiProp.getLabel);
  propname:=indiProp.getName;
  proptype:=indiProp.getType;

  if (proptype=INDI_TEXT)and(propname='DEVICE_PORT') then begin
     scope_port:=indiProp.getText;
  end
  else if (proptype=INDI_NUMBER)and(propname='EQUATORIAL_EOD_COORD') then begin
     coord_prop:=indiProp.getNumber;
     coord_ra:=IUFindNumber(coord_prop,'RA');
     coord_dec:=IUFindNumber(coord_prop,'DEC');
     eod_coord:=true;
     NewNumber(coord_prop);
  end
  else if (proptype=INDI_NUMBER)and(coord_prop=nil)and(propname='EQUATORIAL_COORD') then begin
     coord_prop:=indiProp.getNumber;
     coord_ra:=IUFindNumber(coord_prop,'RA');
     coord_dec:=IUFindNumber(coord_prop,'DEC');
     eod_coord:=false;
     NewNumber(coord_prop);
  end
  else if (proptype=INDI_SWITCH)and(propname='ON_COORD_SET') then begin
     oncoordset_prop:=indiProp.getSwitch;
     setslew_prop:=IUFindSwitch(oncoordset_prop,'SLEW');
     settrack_prop:=IUFindSwitch(oncoordset_prop,'TRACK');
     setsync_prop:=IUFindSwitch(oncoordset_prop,'SYNC');
  end
  else if (proptype=INDI_SWITCH)and(propname='TELESCOPE_ABORT_MOTION') then begin
     abortmotion_prop:=indiProp.getSwitch;
     abort_prop:=IUFindSwitch(abortmotion_prop,'ABORT');
     if abort_prop=nil then abort_prop:=IUFindSwitch(abortmotion_prop,'ABORT_MOTION');
  end
  else if (proptype=INDI_NUMBER)and(propname='GEOGRAPHIC_COORD') then begin

  end
  else if (proptype=INDI_SWITCH)and(propname='Slew Rate') then begin
     SlewRateList.Clear;
     SlewRate_prop:=indiProp.getSwitch;
     for i:=0 to SlewRate_prop.nsp-1 do begin
        SlewRateList.Add(SlewRate_prop.sp[i].name);
     end;
  end
  else if (proptype=INDI_NUMBER)and(propname='TELESCOPE_MOTION_RATE') then begin
     MotionRate_prop:=indiProp.getNumber;
  end
  else if (proptype=INDI_SWITCH)and(propname='TELESCOPE_MOTION_NS') then begin
     moveNS_prop:=indiProp.getSwitch;
     moveN_prop:=IUFindSwitch(moveNS_prop,'MOTION_NORTH');
     moveS_prop:=IUFindSwitch(moveNS_prop,'MOTION_SOUTH');
  end
  else if (proptype=INDI_SWITCH)and(propname='TELESCOPE_MOTION_WE') then begin
     moveEW_prop:=indiProp.getSwitch;
     moveE_prop:=IUFindSwitch(moveEW_prop,'MOTION_EAST');
     moveW_prop:=IUFindSwitch(moveEW_prop,'MOTION_WEST');
  end
  else if (proptype=INDI_SWITCH)and(propname='CONNECTION') then begin

  end;
  CheckStatus;
end;

procedure Tpop_indi.NewNumber(nvp: INumberVectorProperty);
var n: INumber;
begin
//  Memomsg.Lines.Add('NewNumber: '+nvp.name+' '+FloatToStr(nvp.np[0].value));
  if nvp=coord_prop then begin
     pos_x.text := artostr(coord_ra.value);
     pos_y.text := detostr(coord_dec.value);
  end;
end;

procedure Tpop_indi.NewText(tvp: ITextVectorProperty);
begin
//  Memomsg.Lines.Add('NewText: '+tvp.name+' '+tvp.tp[0].text);
end;

procedure Tpop_indi.NewSwitch(svp: ISwitchVectorProperty);
begin
//  Memomsg.Lines.Add('NewSwitch: '+svp.name);
end;

procedure Tpop_indi.NewLight(lvp: ILightVectorProperty);
begin
//  Memomsg.Lines.Add('NewLight: '+lvp.name);
end;

Procedure Tpop_indi.ScopeDisconnect(var ok : boolean; updstatus:boolean=true);
var i: integer;
begin
pos_x.text:='';
pos_y.text:='';
if (client<>nil) then begin
   client.Terminate;
end;
if IndiProcess.Active then begin
   writetrace('Kill indi server');
   IndiProcess.Terminate(i);
   IndiProcess.Executable:='';
   IndiProcess.Parameters.Clear;
end;
ClearStatus;
ok:=true;
end;

Procedure Tpop_indi.ScopeConnect(var ok : boolean);
var buf,plugin,IndiServer,IndiDriver:string;
    i : integer;
    localplugin: boolean;
begin
if not connected then begin
  led.color:=clRed;
  Memomsg.Clear;
  led.refresh;
  if csc.IndiAutostart and (not IndiProcess.Active) then begin
     buf:=GetCurrentDir;
     try
       IndiServer:=csc.IndiServerCmd;
       IndiDriver:=csc.IndiDriver;
       plugin:=slash('plugins');
       localplugin:=DirectoryExists(plugin);
       {$ifdef linux}
         plugin:=ExpandFileName(plugin);
         if localplugin then chdir(plugin);
         localplugin:=localplugin and fileexists(plugin+IndiServer) and fileexists(plugin+IndiDriver);
         if localplugin then begin
            IndiServer:='./'+IndiServer;
            IndiDriver:='./'+IndiDriver;
         end;
       {$endif}
       if localplugin then IndiProcess.CurrentDirectory:=plugin else IndiProcess.CurrentDirectory:='';
       IndiProcess.Executable:=IndiServer;
       IndiProcess.Parameters.Clear;
       IndiProcess.Parameters.add('-p');
       IndiProcess.Parameters.add(csc.IndiServerPort);
       IndiProcess.Parameters.add(IndiDriver);
       IndiProcess.Execute;
     finally
       chdir(buf);
     end;
     ISleep(1000);
  end;
  if (client=nil)or(not client.Connected) then begin
    client:=TIndiBaseClient.Create;
    client.onNewDevice:=@NewDevice;
    client.onNewMessage:=@NewMessage;
    client.onNewProperty:=@NewProperty;
    client.onNewNumber:=@NewNumber;
    client.onNewText:=@NewText;
    client.onNewSwitch:=@NewSwitch;
    client.onNewLight:=@NewLight;
    client.onServerConnected:=@ServerConnected;
    client.onServerDisconnected:=@ServerDisconnected;
  end else begin
    Memomsg.Lines.Add('Already connected');
    exit;
  end;
  client.SetServer(csc.IndiServerHost,csc.IndiServerPort);
  client.watchDevice(csc.IndiDevice);
  client.ConnectServer;
  led.color:=clYellow;
  InitTimer.Enabled:=true;
  ok:=true;
end
else Memomsg.Lines.Add('Already connected');
end;


Procedure Tpop_indi.ScopeClose;
begin
release;
end;

Function  Tpop_indi.ScopeConnected : boolean ;
begin
result:=connected;
end;

Function  Tpop_indi.ScopeInitialized : boolean ;
begin
result:= connected;
end;

Procedure Tpop_indi.ScopeShowModal(var ok : boolean);
begin
showmodal;
ok:=(modalresult=mrOK);
end;

Procedure Tpop_indi.ScopeGetRaDec(var ra,de : double; var ok : boolean);
begin
   if ScopeConnected and (coord_prop<>nil) then begin
         ra:=coord_ra.value;
         de:=coord_dec.value;
         ok:=true;
   end else ok:=false;
end;

Procedure Tpop_indi.ScopeGetAltAz(var alt,az : double; var ok : boolean);
begin
 ok:=false;
end;

Procedure Tpop_indi.ScopeGetInfo(var scName : shortstring; var QueryOK,SyncOK,GotoOK : boolean; var refreshrate : integer);
begin
   if ScopeConnected and ready then begin
     scname:=TelescopeDevice.getDeviceName;
     QueryOK:=(coord_prop<>nil);
     SyncOK:=(coord_prop<>nil)and(oncoordset_prop<>nil)and(setsync_prop<>nil);
     GotoOK:=(coord_prop<>nil)and(oncoordset_prop<>nil)and(setslew_prop<>nil);
   end else begin
      scname:='';
      QueryOK:=false;
      SyncOK:=false;
      GotoOK:=false;
   end;
   refreshrate:=1;
end;

Procedure Tpop_indi.ScopeGetEqSys(var EqSys : double);
begin
if ScopeConnected  and ready then begin
   if eod_coord then EqSys:=0
                else EqSys:=2000;
end;
end;

Procedure Tpop_indi.ScopeReset;
begin
end;

Procedure Tpop_indi.ScopeSetObs(la,lo : double);
begin
//latitude:=la;
//longitude:=-lo;
end;

Procedure Tpop_indi.ScopeAlign(source : string; ra,dec : single);
begin
 if ready then begin
   IUResetSwitch(oncoordset_prop);
   setsync_prop.s:=ISS_ON;
   client.sendNewSwitch(oncoordset_prop);
   coord_ra.value:=ra;
   coord_dec.value:=dec;
   client.sendNewNumber(coord_prop);
 end;
end;

Procedure Tpop_indi.ScopeGoto(ra,de : single; var ok : boolean);
var svp:ISwitchVectorProperty;
    s:ISwitch;
    nvp:INumberVectorProperty;
    np:INumber;
begin
 if ready then begin
   IUResetSwitch(oncoordset_prop);
   settrack_prop.s:=ISS_ON;
   client.sendNewSwitch(oncoordset_prop);
   coord_ra.value:=ra;
   coord_dec.value:=de;
   client.sendNewNumber(coord_prop);
 end;
end;

Procedure Tpop_indi.ScopeReadConfig(ConfigPath : shortstring);
begin
  ReadConfig(ConfigPath);
end;

Procedure Tpop_indi.ScopeAbortSlew;
begin
if (abortmotion_prop<>nil) then begin
   IUResetSwitch(abortmotion_prop);
   abort_prop.s:=ISS_ON;
   client.sendNewSwitch(abortmotion_prop);
end;
end;

procedure Tpop_indi.GetScopeRates(var nrates:integer;var srate: TStringList);
begin
srate.Clear;
if MotionRate_prop<>nil then begin
   // no driver at the moment
end
else if SlewRate_prop<>nil then begin
  srate.Assign(SlewRateList);
end;
if srate.Count=0 then srate.Add('N/A');
nrates:=srate.count;
end;

procedure Tpop_indi.ScopeMoveAxis(axis:Integer; rate: string);
var dir1,dir2: string;
    positive: boolean;
    sw:ISwitch;
begin
if (moveNS_prop<>nil) and (moveEW_prop<>nil) then begin
  positive:=(copy(rate,1,1)<>'-');
  if not positive then delete(rate,1,1);
  if MotionRate_prop<>nil then begin
     // no driver at the moment
  end
  else if SlewRate_prop<>nil then begin
    if pos('N/A',rate)=0 then begin
       sw:=IUFindSwitch(SlewRate_prop,rate);
       if sw<>nil then begin
         IUResetSwitch(SlewRate_prop);
         sw.s:=ISS_ON;
         client.sendNewSwitch(SlewRate_prop);
       end;
    end;
  end;
  case axis of
    0: begin  //  alpha
         IUResetSwitch(moveEW_prop);
         if positive then moveW_prop.s:=ISS_ON
                     else moveE_prop.s:=ISS_ON;
         client.sendNewSwitch(moveEW_prop);
       end;
    1: begin  // delta
         IUResetSwitch(moveNS_prop);
         if positive then moveN_prop.s:=ISS_ON
                     else moveS_prop.s:=ISS_ON;
         client.sendNewSwitch(moveNS_prop);
       end;
  end;
end;
end;

{-------------------------------------------------------------------------------

                       Form functions

--------------------------------------------------------------------------------}

procedure Tpop_indi.SetLang;
begin
caption:=rsINDIDriver;
GroupBox1.Caption:=rsCurrentDrive;
Connect.Caption:=rsConnect;
Disconnect.Caption:=rsDisconnect;
SpeedButton6.Caption:=rsAbortSlew;
SpeedButton2.Caption:=rsHide;
SpeedButton4.Caption:=rsHelp;
SetHelp(self,hlpINDI);
end;

function Tpop_indi.ReadConfig(ConfigPath : shortstring):boolean;
begin
// config managed in main program
result:=true;
end;

procedure Tpop_indi.ScopeShow;
begin
  Edit1.Caption:=csc.IndiDevice;
  ActiveControl:=Connect;
  show;
end;

procedure Tpop_indi.kill(Sender: TObject; var CanClose: Boolean);
begin
Saveconfig;
if ScopeConnected then begin
   canclose:=false;
   hide;
end;
end;

procedure Tpop_indi.FormCreate(Sender: TObject);
begin
SlewRateList:=TStringList.Create;
ClearStatus;
end;

procedure Tpop_indi.InitTimerTimer(Sender: TObject);
var ok:boolean;
begin
  InitTimer.Enabled:=false;
  if TelescopeDevice=nil then begin
     Memomsg.Lines.Add('No response from server');
     Memomsg.Lines.Add('Is driver"'+csc.IndiDevice+'" running?');
     ScopeDisconnect(ok);
  end;
end;

procedure Tpop_indi.ConnectClick(Sender: TObject);
var ok : boolean;
begin
ScopeConnect(ok);
end;

procedure Tpop_indi.SaveConfig;
begin
// config managed in main program
end;

procedure Tpop_indi.DisconnectClick(Sender: TObject);
var ok : boolean;
begin
ScopeDisconnect(ok);
end;

procedure Tpop_indi.SpeedButton2Click(Sender: TObject);
begin
Hide;
end;

procedure Tpop_indi.SpeedButton4Click(Sender: TObject);
begin
ShowHelp;
end;

procedure Tpop_indi.SpeedButton6Click(Sender: TObject);
begin
if ScopeConnected then ScopeAbortSlew;
end;

procedure Tpop_indi.FormDestroy(Sender: TObject);
begin
SaveConfig;
SlewRateList.Free;
end;

end.
