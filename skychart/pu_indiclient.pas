unit pu_indiclient;

{$MODE objfpc}{$H+}

{------------- interface for INDI telescope driver. ----------------------------

Copyright (C) 2011 Patrick Chevalley

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

-------------------------------------------------------------------------------}

interface

uses u_translation,
  LCLIntf, u_util, cu_indiprotocol, u_constant,
  Messages, SysUtils, Classes, Graphics, Controls,
  Forms, Dialogs,
  StdCtrls, Buttons, inifiles, ComCtrls, Menus, ExtCtrls;

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
    Timer1: TTimer;
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
    procedure Timer1Timer(Sender: TObject);
  private
    { Private declarations }
    indi1: TIndiClient;
    FConfig: string;
    CoordLock : boolean;
    connected: boolean;
    TelescopeJD: double;
    Longitude : single;                 // Observatory longitude (Negative East of Greenwich}
    Latitude : single;                  // Observatory latitude
    curdeg_x,  curdeg_y :double;        // current equatorial position in degrees
    procedure TelescopeCoordChange(Sender: TObject);
    procedure TelescopeStatusChange(Sender : Tobject; source: TIndiSource; status: TIndistatus);
    procedure TelescopeGetMessage(Sender : TObject; const msg : string);
  public
    { Public declarations }
    csc: Tconf_skychart;
    function  ReadConfig(ConfigPath : shortstring):boolean;
    Procedure ScopeShow;
    Procedure ScopeShowModal(var ok : boolean);
    Procedure ScopeConnect(var ok : boolean);
    Procedure ScopeDisconnect(var ok : boolean);
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
  end;

//var
  //pop_indi: Tpop_indi;

implementation
{$R *.lfm}

procedure Tpop_indi.TelescopeCoordChange(Sender: TObject);
var ra,dec:double;
    i:integer;
begin
try
 if ScopeInitialized then begin
    val(indi1.RA,ra,i);
    if i<>0 then exit;
    val(indi1.Dec,Dec,i);
    if i<>0 then exit;
    Curdeg_x:=ra*15;
    Curdeg_y:=dec;
    pos_x.text := artostr(Curdeg_x/15);
    pos_y.text := detostr(Curdeg_y);
 end else begin
    pos_x.text := '';
    pos_y.text := '';
 end;
except
end;
end;

Procedure Tpop_indi.ScopeDisconnect(var ok : boolean);
begin
pos_x.text:='';
pos_y.text:='';
if trim(edit1.text)='' then exit;
if (indi1<>nil) then begin
   indi1.terminate;
end;
timer1.Enabled:=false;
ok:=true;
end;

Procedure Tpop_indi.ScopeConnect(var ok : boolean);
var dis_ok : boolean;
begin
if not connected then begin
  led.color:=clRed;
  Memomsg.Clear;
  led.refresh;
  TelescopeJD:=0;
  indi1:=TIndiClient.Create;
  indi1.TargetHost:=csc.IndiServerHost;
  indi1.TargetPort:=csc.IndiServerPort;
  indi1.Timeout := 100;
  indi1.TelescopePort:=csc.IndiPort;
  if csc.IndiDevice=rsOther then indi1.Device:=''
     else indi1.Device:=csc.IndiDevice;
  indi1.IndiServer:=csc.IndiServerCmd;
  indi1.IndiDriver:=csc.IndiDriver;
  indi1.AutoStart:=csc.IndiAutostart;
  indi1.Autoconnect:=true;
  indi1.onCoordChange:=@TelescopeCoordChange;
  indi1.onStatusChange:=@TelescopeStatusChange;
  indi1.onMessage:=@TelescopeGetMessage;
  indi1.Start;
  timer1.Enabled:=true;
  ok:=true;
end;
end;

procedure Tpop_indi.TelescopeStatusChange(Sender : Tobject; source: TIndiSource; status: TIndistatus);
var ok: boolean;
begin
  if source=Telescope then begin
     ok:=(status=cu_indiprotocol.Ok)or(status=cu_indiprotocol.Busy);
     if ok then begin
        if ok<>connected then TelescopeGetMessage(Sender,'Connected');
        connected:=true;
     end else begin
        if ok<>connected then TelescopeGetMessage(Sender,'Disconnected');
        connected:=false;
     end;
  end;
  if connected then led.color:=clLime
               else led.color:=clRed;
  Edit1.Caption:=indi1.Device;
end;

procedure Tpop_indi.TelescopeGetMessage(Sender : TObject; const msg : string);
begin
  if Memomsg.Lines.Count>4 then Memomsg.Lines.Delete(0);
  Memomsg.Lines.Add(trim(msg));
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
   if ScopeConnected  then begin
     scname:=indi1.Device;
     QueryOK:=true;
     SyncOK:=indi1.CanSync;
     GotoOK:=indi1.CanSlew;
   end else begin
      scname:='';
      QueryOK:=false;
      SyncOK:=false;
      GotoOK:=false;
   end;
   refreshrate:=1;
end;

Procedure Tpop_indi.ScopeGetEqSys(var EqSys : double);
var i: integer;
begin
if ScopeConnected then begin
   if indi1.EquatorialOfDay then EqSys:=0
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
begin
indi1.RA:=formatfloat(f13,ra);
indi1.Dec:=formatfloat(f13,dec);
indi1.Sync;
end;

Procedure Tpop_indi.ScopeGoto(ar,de : single; var ok : boolean);
begin
indi1.RA:=formatfloat(f13,ar);
indi1.Dec:=formatfloat(f13,de);
indi1.Slew;
end;

Procedure Tpop_indi.ScopeReadConfig(ConfigPath : shortstring);
begin
  ReadConfig(ConfigPath);
end;

Procedure Tpop_indi.ScopeAbortSlew;
begin
indi1.AbortSlew;
end;

{-------------------------------------------------------------------------------

                       Form functions

--------------------------------------------------------------------------------}

function Tpop_indi.ReadConfig(ConfigPath : shortstring):boolean;
var ini:tinifile;
    nom : string;
begin
// config managed in main program
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
var
ini:tinifile;
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

{ TODO : Help file support }
{
Function ExecuteFile(const FileName, Params, DefaultDir: string; ShowCmd: Integer): THandle;
var
  zFileName, zParams, zDir: array[0..79] of Char;
begin
  Result := ShellExecute(pop_indi.Handle, nil, StrPCopy(zFileName, FileName),
                         StrPCopy(zParams, Params), StrPCopy(zDir, DefaultDir), ShowCmd);
end;
}
procedure Tpop_indi.SpeedButton4Click(Sender: TObject);
begin
//ExecuteFile('ascomtel.html','',appdir+'\doc\html_doc\en',SW_SHOWNORMAL);
end;

procedure Tpop_indi.SpeedButton6Click(Sender: TObject);
begin
ScopeAbortSlew;
end;

procedure Tpop_indi.FormDestroy(Sender: TObject);
begin
SaveConfig;
end;

procedure Tpop_indi.Timer1Timer(Sender: TObject);
begin
timer1.Enabled:=false;
if (not connected) and ((indi1.TelescopeStatus=cu_indiprotocol.Idle)or(indi1.TelescopeStatus=cu_indiprotocol.Alert)) then begin
      indi1.Terminate;
end;
end;

end.
