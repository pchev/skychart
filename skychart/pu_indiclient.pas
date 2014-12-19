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

uses u_help, u_translation, indibaseclient, indibasedevice,
  indiapi, indicom, LCLIntf, u_util, u_constant,
  Messages, SysUtils, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, Buttons, inifiles, ComCtrls, Menus, ExtCtrls;

type

  { Tpop_indi }

  Tpop_indi = class(TForm)
    GroupBox3: TGroupBox;
    Connect: TButton;
    Memomsg: TMemo;
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
    {Utility and form functions}
    procedure FormCreate(Sender: TObject);
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
    CoordLock : boolean;
    connected: boolean;
    TelescopeJD: double;
    Longitude : single;                 // Observatory longitude (Negative East of Greenwich}
    Latitude : single;                  // Observatory latitude
    curdeg_x,  curdeg_y :double;        // current equatorial position in degrees
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
    Procedure ScopeGetRaDec(var ar,de : double; var ok : boolean);
    Procedure ScopeGetAltAz(var alt,az : double; var ok : boolean);
    Procedure ScopeGoto(ar,de : single; var ok : boolean);
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

procedure Tpop_indi.ServerConnected(Sender: TObject);
begin
  Memomsg.Lines.Add('Server connected');
  // csc.IndiPort;
  client.connectDevice(csc.IndiDevice);
end;

procedure Tpop_indi.ServerDisconnected(Sender: TObject);
begin
  Memomsg.Lines.Add('Server disconnected');
  connected:=false;
  led.color:=clRed;
end;

procedure Tpop_indi.NewDevice(dp: Basedevice);
begin
//  Memomsg.Lines.Add('Newdev: '+dp.getDeviceName);
  if dp.getDeviceName=csc.IndiDevice then begin
     connected:=true;
     led.color:=clLime;
     TelescopeDevice:=dp;
  end;
end;

procedure Tpop_indi.NewMessage(msg: string);
begin
  if Memomsg.Lines.Count>4 then Memomsg.Lines.Delete(0);
  Memomsg.Lines.Add('Message: '+msg);
end;

procedure Tpop_indi.NewProperty(indiProp: IndiProperty);
begin
//  Memomsg.Lines.Add('Newprop: '+indiProp.getDeviceName+' '+indiProp.getName+' '+indiProp.getLabel);
  if indiProp.getType = INDI_NUMBER then NewNumber(indiProp.getNumber);
end;

procedure Tpop_indi.NewNumber(nvp: INumberVectorProperty);
var n: INumber;
begin
//  Memomsg.Lines.Add('NewNumber: '+nvp.name+' '+FloatToStr(nvp.np[0].value));
  if nvp.name='EQUATORIAL_EOD_COORD' then begin
     n:=IUFindNumber(nvp,'RA');
     Curdeg_x:=n.value*15;
     n:=IUFindNumber(nvp,'DEC');
     Curdeg_y:=n.value;
     pos_x.text := artostr(Curdeg_x/15);
     pos_y.text := detostr(Curdeg_y);
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
begin
pos_x.text:='';
pos_y.text:='';
if trim(edit1.text)='' then exit;
if (client<>nil) then begin
   client.Terminate;
end;
ok:=true;
end;

Procedure Tpop_indi.ScopeConnect(var ok : boolean);
begin
if not connected then begin
  led.color:=clRed;
  Memomsg.Clear;
  led.refresh;
  TelescopeJD:=0;
   if (client=nil)or(client.Terminated) then begin
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
  ok:=true;
end;
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

Procedure Tpop_indi.ScopeGetRaDec(var ar,de : double; var ok : boolean);
begin
   if ScopeConnected then begin
         ar:=Curdeg_x/15;
         de:=Curdeg_y;
         ok:=true;
   end else ok:=false;
end;

Procedure Tpop_indi.ScopeGetAltAz(var alt,az : double; var ok : boolean);
begin
 ok:=false;
end;

Procedure Tpop_indi.ScopeGetInfo(var scName : shortstring; var QueryOK,SyncOK,GotoOK : boolean; var refreshrate : integer);
begin
   if ScopeConnected and (client.devices.Count>0) then begin
     scname:=BaseDevice(client.devices[0]).getDeviceName;
     QueryOK:=true;
     SyncOK:=BaseDevice(client.devices[0]).getSwitch('ON_COORD_SET')<>nil;
     GotoOK:=SyncOK;
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
if ScopeConnected  and (client.devices.Count>0) then begin
   if BaseDevice(client.devices[0]).getNumber('EQUATORIAL_EOD_COORD')<>nil then EqSys:=0
      else EqSys:=2000;
end;
end;

Procedure Tpop_indi.ScopeReset;
begin
end;

Procedure Tpop_indi.ScopeSetObs(la,lo : double);
begin
latitude:=la;
longitude:=-lo;
end;

Procedure Tpop_indi.ScopeAlign(source : string; ra,dec : single);
var svp:ISwitchVectorProperty;
    s:ISwitch;
    nvp:INumberVectorProperty;
    np:INumber;
begin
 svp:=TelescopeDevice.getSwitch('ON_COORD_SET');
 IUResetSwitch(svp);
 s:=IUFindSwitch(svp,'SYNC');
 s.s:=ISS_ON;
 client.sendNewSwitch(svp);
 nvp:=TelescopeDevice.getNumber('EQUATORIAL_EOD_COORD');
 np:=IUFindNumber(nvp,'RA');
 np.value:=ra;
 np:=IUFindNumber(nvp,'DEC');
 np.value:=dec;
 client.sendNewNumber(nvp);
end;

Procedure Tpop_indi.ScopeGoto(ar,de : single; var ok : boolean);
var svp:ISwitchVectorProperty;
    s:ISwitch;
    nvp:INumberVectorProperty;
    np:INumber;
begin
 svp:=TelescopeDevice.getSwitch('ON_COORD_SET');
 IUResetSwitch(svp);
 s:=IUFindSwitch(svp,'SLEW');
 s.s:=ISS_ON;
 client.sendNewSwitch(svp);
 nvp:=TelescopeDevice.getNumber('EQUATORIAL_EOD_COORD');
 np:=IUFindNumber(nvp,'RA');
 np.value:=ar;
 np:=IUFindNumber(nvp,'DEC');
 np.value:=de;
 client.sendNewNumber(nvp);
end;

Procedure Tpop_indi.ScopeReadConfig(ConfigPath : shortstring);
begin
  ReadConfig(ConfigPath);
end;

Procedure Tpop_indi.ScopeAbortSlew;
var svp:ISwitchVectorProperty;
    s:ISwitch;
begin
if TelescopeDevice=nil then exit;
svp:=TelescopeDevice.getSwitch('TELESCOPE_ABORT_MOTION');
if svp=nil then exit;
IUResetSwitch(svp);
s:=IUFindSwitch(svp,'ABORT');
if s=nil then s:=IUFindSwitch(svp,'ABORT_MOTION');
if s=nil then exit;
s.s:=ISS_ON;
client.sendNewSwitch(svp);
end;

procedure Tpop_indi.GetScopeRates(var nrates:integer;var srate: TStringList);
begin
{  indi1.GetSlewRate(srate);
  if srate.Count=0 then srate.Add('N/A');
  nrates:=srate.count;}
end;

procedure Tpop_indi.ScopeMoveAxis(axis:Integer; rate: string);
var dir1,dir2: string;
    positive: boolean;
begin
{positive:=(copy(rate,1,1)<>'-');
if not positive then delete(rate,1,1);
case axis of
  0: begin  //  alpha
       if positive then begin
          dir1:='Off';
          dir2:='On';
       end else begin
          dir1:='On';
          dir2:='Off';
       end;
       if pos('N/A',rate)=0 then indi1.SetSlewRate(rate);
       indi1.MotionWE(dir1,dir2);
     end;
  1: begin  // delta
       if positive then begin
          dir1:='On';
          dir2:='Off';
       end else begin
          dir1:='Off';
          dir2:='On';
       end;
       if pos('N/A',rate)=0 then indi1.SetSlewRate(rate);
       indi1.MotionNS(dir1,dir2);
     end;
end;   }
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
CoordLock := false;
connected := false;
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
end;

end.
