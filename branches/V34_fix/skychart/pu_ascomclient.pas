unit pu_ascomclient;

{$MODE objfpc}{$H+}

{------------- interface for ASCOM telescope driver. ----------------------------

Copyright (C) 2000 Patrick Chevalley

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

uses
  {$ifdef mswindows}
    Variants, comobj, Windows, ShlObj, ShellAPI,
  {$endif}
  LCLIntf, u_util, u_constant, u_help, u_translation,
  Messages, SysUtils, Classes, Graphics, Controls,
  Forms, Dialogs,
  StdCtrls, Buttons, inifiles, ComCtrls, Menus, ExtCtrls;

type

  { Tpop_scope }

  Tpop_scope = class(TForm)
    GroupBox3: TGroupBox;
    WarningLabel: TLabel;
    trackingled: TEdit;
    SpeedButton1: TSpeedButton;
    TrackingBtn: TSpeedButton;
    SpeedButton2: TSpeedButton;
    SpeedButton5: TSpeedButton;
    led: TEdit;
    GroupBox5: TGroupBox;
    Label15: TLabel;
    Label16: TLabel;
    lat: TEdit;
    long: TEdit;
    Panel1: TPanel;
    LabelAlpha: TLabel;
    LabelDelta: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    pos_x: TEdit;
    pos_y: TEdit;
    az_x: TEdit;
    alt_y: TEdit;
    ShowAltAz: TCheckBox;
    Timer1: TTimer;
    GroupBox1: TGroupBox;
    Edit1: TEdit;
    SpeedButton3: TSpeedButton;
    ReadIntBox: TComboBox;
    Label1: TLabel;
    SpeedButton7: TSpeedButton;
    SpeedButton6: TSpeedButton;
    SpeedButton8: TSpeedButton;
    SpeedButton9: TSpeedButton;
    SpeedButton4: TSpeedButton;
    SpeedButton11: TSpeedButton;
    {Utility and form functions}
    procedure FormCreate(Sender: TObject);
    procedure kill(Sender: TObject; var CanClose: Boolean);
    procedure Timer1Timer(Sender: TObject);
    procedure setresClick(Sender: TObject);
    procedure SaveConfig;
    procedure ReadIntBoxChange(Sender: TObject);
    procedure SpeedButton5Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure SpeedButton4Click(Sender: TObject);
    procedure SpeedButton6Click(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure SpeedButton7Click(Sender: TObject);
    procedure SpeedButton9Click(Sender: TObject);
    procedure SpeedButton8Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure TrackingBtnClick(Sender: TObject);
    procedure UpdTrackingButton;
    procedure SpeedButton11Click(Sender: TObject);
  private
    { Private declarations }
    FConfig: string;
    CoordLock : boolean;
    Initialized : boolean;
    T : Variant;
    Longitude : single;                 // Observatory longitude (Negative East of Greenwich}
    Latitude : single;                  // Observatory latitude
    curdeg_x,  curdeg_y :double;        // current equatorial position in degrees
    cur_az,  cur_alt :double;           // current alt-az position in degrees
  public
    { Public declarations }
    procedure SetLang;
    function  ReadConfig(ConfigPath : shortstring):boolean;
    Procedure ShowCoordinates;
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


implementation
{$R *.lfm}

{-------------------------------------------------------------------------------

           Cartes du Ciel Dll compatibility functions

--------------------------------------------------------------------------------}
Procedure Tpop_scope.ShowCoordinates;
begin
{$ifdef mswindows}
   if ScopeInitialized then begin
      try
         Curdeg_x:=T.RightAscension*15;
         Curdeg_y:=T.Declination;
      except
         on E: EOleException do MessageDlg(rsError+': ' + E.Message, mtWarning, [mbOK], 0);
      end;
      if ShowAltAz.checked then begin
         try
            Cur_az:=T.Azimuth;
            Cur_alt:=T.Altitude;
         except
            ShowAltAz.checked:=false;
         end;
      end;
      pos_x.text := artostr(Curdeg_x/15);
      pos_y.text := detostr(Curdeg_y);
      if ShowAltAz.checked then begin
          az_x.text  := detostr(Cur_az);
          alt_y.text := detostr(Cur_alt);
      end else begin
          az_x.text  := '';
          alt_y.text := '';
      end;
      if ShowAltAz.checked and (Cur_alt<0) then alt_y.Color:=clRed else alt_y.Color:=clWindow;
   end else begin
      pos_x.text := '';
      pos_y.text := '';
      az_x.text  := '';
      alt_y.text := '';
   end;
{$endif}
end;

Procedure Tpop_scope.ScopeDisconnect(var ok : boolean);
begin
{$ifdef mswindows}
Initialized:=false;
pos_x.text:='';
pos_y.text:='';
az_x.text:='';
alt_y.text:='';
if trim(edit1.text)='' then exit;
try
if not VarIsEmpty(T) then begin
  T.connected:=false;
  T:=Unassigned;
end;
ok:=true;
led.color:=clRed;
speedbutton1.enabled:=true;
speedbutton3.enabled:=true;
speedbutton7.enabled:=true;
speedbutton8.enabled:=false;
speedbutton9.enabled:=false;
UpdTrackingButton;
except
 on E: EOleException do MessageDlg(rsError+': ' + E.Message, mtWarning, [mbOK], 0);
end;
{$endif}
end;

Procedure Tpop_scope.ScopeConnect(var ok : boolean);
{$ifdef mswindows}
var dis_ok : boolean;
{$endif}
begin
{$ifdef mswindows}
led.color:=clRed;
led.refresh;
timer1.enabled:=false;
speedbutton3.enabled:=true;
ok:=false;
if trim(edit1.text)='' then exit;
try
T:=Unassigned;
T := CreateOleObject(widestring(edit1.text));
T.connected:=true;
if T.connected then begin
   Initialized:=true;
   ShowCoordinates;
   led.color:=clLime;
   ok:=true;
   timer1.enabled:=true;
   speedbutton1.enabled:=false;
   speedbutton3.enabled:=false;
   speedbutton7.enabled:=false;
   speedbutton8.enabled:=true;
   speedbutton9.enabled:=true;
end else scopedisconnect(dis_ok);
UpdTrackingButton;
except
 on E: EOleException do MessageDlg(rsError+': ' + E.Message, mtWarning, [mbOK], 0);
end;
{$endif}
end;

Procedure Tpop_scope.ScopeClose;
begin
release;
end;

Function  Tpop_scope.ScopeConnected : boolean ;
begin
result:=false;
if not initialized then exit;
{$ifdef mswindows}
result:=false;
if VarIsEmpty(T) then exit;
try
result:=T.connected;
except
 result:=false;
end;
{$endif}
end;

Function  Tpop_scope.ScopeInitialized : boolean ;
begin
result:= ScopeConnected;
end;

Procedure Tpop_scope.ScopeAlign(source : string; ra,dec : single);
begin
{$ifdef mswindows}
   if not ScopeConnected then exit;
   if T.CanSync then begin
      try                 
         if not T.tracking then begin
            T.tracking:=true;
            UpdTrackingButton;
         end;
         T.SyncToCoordinates(Ra,Dec);
      except
         on E: EOleException do MessageDlg(rsError+': ' + E.Message, mtWarning, [mbOK], 0);
      end;
   end
{$endif}
end;

Procedure Tpop_scope.ScopeShowModal(var ok : boolean);
begin
showmodal;
ok:=(modalresult=mrOK);
end;

Procedure Tpop_scope.ScopeShow;
begin
show
end;

Procedure Tpop_scope.ScopeGetRaDec(var ar,de : double; var ok : boolean);
begin
{$ifdef mswindows}
   if ScopeConnected then begin
      try
         ar:=Curdeg_x/15;
         de:=Curdeg_y;
         ok:=true;
      except
         on E: EOleException do begin
            MessageDlg(rsError+': ' + E.Message, mtWarning, [mbOK], 0);
            ok:=false;
         end;
      end;
   end else ok:=false;
{$endif}
end;

Procedure Tpop_scope.ScopeGetAltAz(var alt,az : double; var ok : boolean);
begin
{$ifdef mswindows}
   if ScopeConnected then begin
      try
         az:=cur_az;
         alt:=cur_alt;
         ok:=true;
      except
         on E: EOleException do begin
            MessageDlg(rsError+': ' + E.Message, mtWarning, [mbOK], 0);
            ok:=false;
         end;
      end;
   end else ok:=false;
{$endif}
end;

Procedure Tpop_scope.ScopeGetInfo(var scName : shortstring; var QueryOK,SyncOK,GotoOK : boolean; var refreshrate : integer);
begin
{$ifdef mswindows}
   if ScopeConnected  then begin
      try
         scname:=T.name;
         QueryOK:=true;
         SyncOK:=T.CanSync;
         GotoOK:=T.CanSlew;
      except
         on E: EOleException do MessageDlg(rsError+': ' + E.Message, mtWarning, [mbOK], 0);
      end;
   end else begin
      scname:='';
      QueryOK:=false;
      SyncOK:=false;
      GotoOK:=false;
   end;
   refreshrate:=timer1.interval;
{$endif}
end;

Procedure Tpop_scope.ScopeGetEqSys(var EqSys : double);
var i: integer;
begin
   if ScopeConnected then begin
      try
         i:=T.EquatorialSystem;
      except
         i:=0;
      end;
   end else i:=0;
   case i of
   0 : EqSys:=0;
   1 : EqSys:=0;
   2 : EqSys:=2000;
   3 : EqSys:=2050;
   4 : EqSys:=1950;
   end;
end;

Procedure Tpop_scope.ScopeReset;
begin
end;

Procedure Tpop_scope.ScopeSetObs(la,lo : double);
begin
latitude:=la;
longitude:=-lo;
lat.text:=detostr(latitude);
long.text:=detostr(longitude);
end;

Procedure Tpop_scope.ScopeGoto(ar,de : single; var ok : boolean);
begin
{$ifdef mswindows}
   if not ScopeConnected then exit;
   try
      if not T.tracking then begin
         T.tracking:=true;
         UpdTrackingButton;
      end;
      if T.CanSlewAsync then T.SlewToCoordinatesAsync(ar,de)
      else T.SlewToCoordinates(ar,de);
   except                                                                
      on E: EOleException do MessageDlg(rsError+': ' + E.Message, mtWarning, [mbOK], 0);
   end;
{$endif}
end;

Procedure Tpop_scope.ScopeReadConfig(ConfigPath : shortstring);
begin
  ReadConfig(ConfigPath);
end;

Procedure Tpop_scope.ScopeAbortSlew;
begin
{$ifdef mswindows}
if ScopeConnected then begin
      try
         T.AbortSlew;
      except
         on E: EOleException do MessageDlg(rsError+': ' + E.Message, mtWarning, [mbOK], 0);
      end;
   end;
{$endif}
end;

{-------------------------------------------------------------------------------

                       Form functions

--------------------------------------------------------------------------------}

procedure Tpop_scope.SetLang;
begin
caption:=rsASCOMTelesc;
GroupBox1.Caption:=rsDriverSelect;
Label1.Caption:=rsRefreshRate;
SpeedButton3.Caption:=rsSelect;
SpeedButton7.Caption:=rsConfigure;
SpeedButton11.Caption:=rsAbout;
GroupBox5.Caption:=rsObservatory;
Label15.Caption:=rsLatitude;
Label16.Caption:=rsLongitude;
SpeedButton9.Caption:=rsSetLocation;
SpeedButton8.Caption:=rsSetTime;
TrackingBtn.Caption:=rsTracking;
SpeedButton6.Caption:=rsAbortSlew;
SpeedButton4.Caption:=rsHelp;
SpeedButton1.Caption:=rsConnect;
SpeedButton5.Caption:=rsDisconnect;
SpeedButton2.Caption:=rsHide;
{$ifdef mswindows}
   WarningLabel.Caption:='';
{$else}
    WarningLabel.Caption:=Format(rsNotAvailon,[compile_system]);
{$endif}
SetHelp(self,hlpASCOM);
end;

function Tpop_scope.ReadConfig(ConfigPath : shortstring):boolean;
var ini:tinifile;
    nom : string;
begin
result:=DirectoryExists(ConfigPath);
if Result then
  FConfig:=slash(ConfigPath)+'scope.ini'
else
  FConfig:=slash(extractfilepath(paramstr(0)))+'scope.ini';
ini:=tinifile.create(FConfig);
nom:= ini.readstring('Ascom','name','');
if trim(nom)='' then nom:='POTH.Telescope';
edit1.text:=nom;
ShowAltAz.Checked:=ini.ReadBool('Ascom','AltAz',false);
ReadIntBox.text:=ini.readstring('Ascom','read_interval','1000');
lat.text:=ini.readstring('observatory','latitude','0');
long.text:=ini.readstring('observatory','longitude','0');
ini.free;
Timer1.Interval:=strtointdef(ReadIntBox.text,1000);
end;


procedure Tpop_scope.kill(Sender: TObject; var CanClose: Boolean);
begin
Saveconfig;
if ScopeConnected then begin
   canclose:=false;
   hide;
end;
end;

procedure Tpop_scope.FormCreate(Sender: TObject);
begin
    CoordLock := false;
    Initialized := false;
end;

procedure Tpop_scope.Timer1Timer(Sender: TObject);
begin
if not ScopeConnected then exit;
try
if T.connected and (not CoordLock) then begin
   CoordLock := true;
   timer1.enabled:=false;
   ShowCoordinates;
   CoordLock := false;
   timer1.enabled:=true;
end;
except
   timer1.enabled:=false;
   Initialized := false;
end;
end;

procedure Tpop_scope.setresClick(Sender: TObject);
var ok : boolean;
begin
ScopeConnect(ok);
end;

procedure Tpop_scope.SaveConfig;
var
ini:tinifile;
begin
ini:=tinifile.create(FConfig);
ini.writestring('Ascom','name',edit1.text);
ini.writestring('Ascom','read_interval',ReadIntBox.text);
ini.writeBool('Ascom','AltAz',ShowAltAz.Checked);
ini.writestring('observatory','latitude',lat.text);
ini.writestring('observatory','longitude',long.text);
ini.free;
end;

procedure Tpop_scope.ReadIntBoxChange(Sender: TObject);
begin
     Timer1.Interval:=strtointdef(ReadIntBox.text,1000);
end;

procedure Tpop_scope.SpeedButton5Click(Sender: TObject);
var ok : boolean;
begin
ScopeDisconnect(ok);
end;

procedure Tpop_scope.SpeedButton2Click(Sender: TObject);
begin
Hide;
end;

procedure Tpop_scope.SpeedButton4Click(Sender: TObject);
begin
ShowHelp;
end;

procedure Tpop_scope.SpeedButton6Click(Sender: TObject);
begin
ScopeAbortSlew;
end;

procedure Tpop_scope.SpeedButton3Click(Sender: TObject);
{$ifdef mswindows}
var
  V: variant;
{$endif}
begin
{$ifdef mswindows}
try
  initialized:=false;
  try
    V := CreateOleObject('ASCOM.Utilities.Chooser');
  except
    V := CreateOleObject('DriverHelper.Chooser');
  end;
  V.DeviceType:=widestring('Telescope');
  {$ifdef  win64}
  edit1.text:=V.Choose('');
  {$else}
  edit1.text:=V.Choose(widestring(edit1.text));
  {$endif}
  V:=Unassigned;
  SaveConfig;
  UpdTrackingButton;
  except
    {$ifdef  win64}
    Showmessage('The ASCOM telescope chooser require ASCOM Platform 6 or better for a 64 bits application.'+crlf+'Even in this case do not try to configure the driver from the chooser. '+crlf+'Download ASCOM Platform 6 from http://ascom-standards.org');
    {$else}
    Showmessage(rsPleaseEnsure+crlf+Format(rsSeeHttpAscom,['http://ascom-standards.org']));
    {$endif}
  end;
{$endif}
end;

procedure Tpop_scope.SpeedButton7Click(Sender: TObject);
begin
{$ifdef mswindows}
try
if (edit1.text>'') and (not Scopeconnected) then begin
if VarIsEmpty(T) then begin
   T := CreateOleObject(widestring(edit1.text));
   T.SetupDialog;
   T:=Unassigned;
end else begin
   T.SetupDialog;
end;
UpdTrackingButton;
end;
except
  on E: EOleException do MessageDlg(rsError+': ' + E.Message, mtWarning, [mbOK], 0);
end;
{$endif}
end;

procedure Tpop_scope.SpeedButton9Click(Sender: TObject);
begin
{$ifdef mswindows}
   if ScopeConnected then begin
      try
         T.SiteLongitude:=longitude;
         T.SiteLatitude:=latitude;
      except
         on E: EOleException do MessageDlg(rsError+': ' + E.Message, mtWarning, [mbOK], 0);
      end;
   end;
{$endif}
end;

procedure Tpop_scope.SpeedButton8Click(Sender: TObject);
{$ifdef mswindows}
var utc: Tsystemtime;
{$endif}
begin
{$ifdef mswindows}
   if ScopeConnected then begin
      try
         getsystemtime(utc);
         // does not raise and error but may not be UTC
         T.UTCDate:=systemtimetodatetime(utc);
      except
         on E: EOleException do MessageDlg(rsError+': ' + E.Message, mtWarning, [mbOK], 0);
      end;
   end;
{$endif}
end;

procedure Tpop_scope.FormDestroy(Sender: TObject);
begin
SaveConfig;
end;

procedure Tpop_scope.UpdTrackingButton;
begin
{$ifdef mswindows}
try
   if not ScopeConnected then exit;
   if (not T.CanSetTracking)or(not T.connected) then begin
      TrackingLed.Enabled:=false;
   end else begin
      TrackingBtn.Enabled:=true;
      if T.Tracking then Trackingled.color:=clLime
      else Trackingled.color:=clRed;
   end;
except
  on E: EOleException do MessageDlg(rsError+': ' + E.Message, mtWarning, [mbOK], 0);
end;
{$endif}
end;

procedure Tpop_scope.TrackingBtnClick(Sender: TObject);
begin
{$ifdef mswindows}
   if ScopeConnected then begin
      try
         T.Tracking:=not T.Tracking;
         UpdTrackingButton;
      except
         on E: EOleException do MessageDlg(rsError+': ' + E.Message, mtWarning, [mbOK], 0);
      end;
   end;
{$endif}
end;

procedure Tpop_scope.SpeedButton11Click(Sender: TObject);
{$ifdef mswindows}
var buf : string;
{$endif}
begin
{$ifdef mswindows}
try
   if (edit1.text>'') then begin
      try
         if VarIsEmpty(T) then begin
            T := CreateOleObject(widestring(edit1.text));
            buf:=T.Description;
            buf:=buf+crlf+T.DriverInfo;
            T:=Unassigned;
            showmessage(buf);
         end else begin
            buf:=T.Description;
            buf:=buf+crlf+T.DriverInfo;
            showmessage(buf);
         end;
         UpdTrackingButton;
      except
      end;
   end;
except
  on E: EOleException do MessageDlg(rsError+': ' + E.Message, mtWarning, [mbOK], 0);
end;
{$endif}
end;


end.
