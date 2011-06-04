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
  LCLIntf, u_util,
  Messages, SysUtils, Classes, Graphics, Controls,
  Forms, Dialogs,
  StdCtrls, Buttons, inifiles, ComCtrls, Menus, ExtCtrls;

type

  { Tpop_scope }

  Tpop_scope = class(TForm)
    GroupBox3: TGroupBox;
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
  public
    { Public declarations }
    function  ReadConfig(ConfigPath : shortstring):boolean;
  end;


Procedure ScopeShow;
Procedure ScopeShowModal(var ok : boolean);
Procedure ScopeConnect(var ok : boolean);
Procedure ScopeDisconnect(var ok : boolean);
Procedure ScopeGetInfo(var Name : shortstring; var QueryOK,SyncOK,GotoOK : boolean; var refreshrate : integer);
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

var
  pop_scope: Tpop_scope;

implementation
{$R *.lfm}

var CoordLock : boolean = false;
   Initialized : boolean = false;
  T : Variant;
  Longitude : single;                 // Observatory longitude (Negative East of Greenwich}
  Latitude : single;                  // Observatory latitude
  {$ifdef mswindows}
    Appdir : string;
  curdeg_x,  curdeg_y :double;        // current equatorial position in degrees
  cur_az,  cur_alt :double;           // current alt-az position in degrees
  {$endif}

const crlf=chr(10)+chr(13);

{-------------------------------------------------------------------------------

           Cartes du Ciel Dll compatibility functions

--------------------------------------------------------------------------------}
Procedure ShowCoordinates;
begin
{$ifdef mswindows}
with pop_scope do begin
   if ScopeInitialized then begin
      try
         Curdeg_x:=T.RightAscension*15;
         Curdeg_y:=T.Declination;
      except
         on E: EOleException do MessageDlg('Error: ' + E.Message, mtWarning, [mbOK], 0);
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
   end;
{$endif}
end;

Procedure ScopeDisconnect(var ok : boolean);
begin
{$ifdef mswindows}
Initialized:=false;
pop_scope.pos_x.text:='';
pop_scope.pos_y.text:='';
pop_scope.az_x.text:='';
pop_scope.alt_y.text:='';
if trim(pop_scope.edit1.text)='' then exit;
try
if not VarIsEmpty(T) then begin
  T.connected:=false;
  T:=Unassigned;
end;
ok:=true;
pop_scope.led.color:=clRed;
pop_scope.speedbutton1.enabled:=true;
pop_scope.speedbutton3.enabled:=true;
pop_scope.speedbutton7.enabled:=true;
pop_scope.speedbutton8.enabled:=false;
pop_scope.speedbutton9.enabled:=false;
pop_scope.UpdTrackingButton;
except
 on E: EOleException do MessageDlg('Error: ' + E.Message, mtWarning, [mbOK], 0);
end;
{$endif}
end;

Procedure ScopeConnect(var ok : boolean);
{$ifdef mswindows}
var dis_ok : boolean;
{$endif}
begin
{$ifdef mswindows}
pop_scope.led.color:=clRed;
pop_scope.led.refresh;
pop_scope.timer1.enabled:=false;
pop_scope.speedbutton3.enabled:=true;
ok:=false;
if trim(pop_scope.edit1.text)='' then exit;
try
T:=Unassigned;
T := CreateOleObject(pop_scope.edit1.text);
T.connected:=true;
if T.connected then begin
   Initialized:=true;
   ShowCoordinates;
   pop_scope.led.color:=clLime;
   ok:=true;
   pop_scope.timer1.enabled:=true;
   pop_scope.speedbutton1.enabled:=false;
   pop_scope.speedbutton3.enabled:=false;
   pop_scope.speedbutton7.enabled:=false;
   pop_scope.speedbutton8.enabled:=true;
   pop_scope.speedbutton9.enabled:=true;
end else scopedisconnect(dis_ok);
pop_scope.UpdTrackingButton;
except
 on E: EOleException do MessageDlg('Error: ' + E.Message, mtWarning, [mbOK], 0);
end;
{$endif}
end;

Procedure ScopeClose;
begin
pop_scope.release;
end;

Function  ScopeConnected : boolean ;
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

Function  ScopeInitialized : boolean ;
begin
result:= ScopeConnected;
end;

Procedure ScopeAlign(source : string; ra,dec : single);
begin
{$ifdef mswindows}
   if not ScopeConnected then exit;
   if T.CanSync then begin
      try                 
         if not T.tracking then begin
            T.tracking:=true;
            pop_scope.UpdTrackingButton;
         end;
         T.SyncToCoordinates(Ra,Dec);
      except
         on E: EOleException do MessageDlg('Error: ' + E.Message, mtWarning, [mbOK], 0);
      end;
   end
{$endif}
end;

Procedure ScopeShowModal(var ok : boolean);
begin
pop_scope.showmodal;
ok:=(pop_scope.modalresult=mrOK);
end;

Procedure ScopeShow;
begin
pop_scope.show
end;

Procedure ScopeGetRaDec(var ar,de : double; var ok : boolean);
begin
{$ifdef mswindows}
   if ScopeConnected then begin
      try
         ar:=Curdeg_x/15;
         de:=Curdeg_y;
         ok:=true;
      except
         on E: EOleException do begin
            MessageDlg('Error: ' + E.Message, mtWarning, [mbOK], 0);
            ok:=false;
         end;
      end;
   end else ok:=false;
{$endif}
end;

Procedure ScopeGetAltAz(var alt,az : double; var ok : boolean);
begin
{$ifdef mswindows}
   if ScopeConnected then begin
      try
         az:=cur_az;
         alt:=cur_alt;
         ok:=true;
      except
         on E: EOleException do begin
            MessageDlg('Error: ' + E.Message, mtWarning, [mbOK], 0);
            ok:=false;
         end;
      end;
   end else ok:=false;
{$endif}
end;

Procedure ScopeGetInfo(var Name : shortstring; var QueryOK,SyncOK,GotoOK : boolean; var refreshrate : integer);
begin
{$ifdef mswindows}
   if (pop_scope=nil)or(pop_scope.pos_x=nil) then begin
      Initialized := false;
      pop_scope:=Tpop_scope.Create(nil);
   end;
   if ScopeConnected  then begin
      try
         name:=T.name;
         QueryOK:=true;
         SyncOK:=T.CanSync;
         GotoOK:=T.CanSlew;
      except
         on E: EOleException do MessageDlg('Error: ' + E.Message, mtWarning, [mbOK], 0);
      end;
   end else begin
      name:='';
      QueryOK:=false;
      SyncOK:=false;
      GotoOK:=false;
   end;
   refreshrate:=pop_scope.timer1.interval;
{$endif}
end;

Procedure ScopeGetEqSys(var EqSys : double);
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

Procedure ScopeReset;
begin
end;

Procedure ScopeSetObs(la,lo : double);
begin
latitude:=la;
longitude:=-lo;
pop_scope.lat.text:=detostr(latitude);
pop_scope.long.text:=detostr(longitude);
end;

Procedure ScopeGoto(ar,de : single; var ok : boolean);
begin
{$ifdef mswindows}
   if not ScopeConnected then exit;
   try
      if not T.tracking then begin
         T.tracking:=true;
         pop_scope.UpdTrackingButton;
      end;
      if T.CanSlewAsync then T.SlewToCoordinatesAsync(ar,de)
      else T.SlewToCoordinates(ar,de);
   except                                                                
      on E: EOleException do MessageDlg('Error: ' + E.Message, mtWarning, [mbOK], 0);
   end;
{$endif}
end;

Procedure ScopeReadConfig(ConfigPath : shortstring);
begin
  pop_scope.ReadConfig(ConfigPath);
end;

Procedure ScopeAbortSlew;
begin
{$ifdef mswindows}
if ScopeConnected then begin
      try
         T.AbortSlew;
      except
         on E: EOleException do MessageDlg('Error: ' + E.Message, mtWarning, [mbOK], 0);
      end;
   end;
{$endif}
end;

{-------------------------------------------------------------------------------

                       Form functions

--------------------------------------------------------------------------------}

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
   pop_scope.hide;
end;
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
pop_scope.Hide;
end;

{$ifdef mswindows}
Function ExecuteFile(const FileName, Params, DefaultDir: string; ShowCmd: Integer): THandle;
var
  zFileName, zParams, zDir: array[0..79] of Char;
begin
  Result := ShellExecute(pop_scope.Handle, nil, StrPCopy(zFileName, FileName),
                         StrPCopy(zParams, Params), StrPCopy(zDir, DefaultDir), ShowCmd);
end;
{$endif}

procedure Tpop_scope.SpeedButton4Click(Sender: TObject);
begin
{$ifdef mswindows}
ExecuteFile('ascomtel.html','',appdir+'\doc\html_doc\en',SW_SHOWNORMAL);
{$endif}
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
  V := CreateOleObject('DriverHelper.Chooser');
  V.devicetype:='Telescope';
  edit1.text:=V.Choose(edit1.text);
  V:=Unassigned;
  SaveConfig;
  UpdTrackingButton;
  except
    {$ifdef  win64}
    Showmessage('The ASCOM telescope chooser do not work correctly from a 64 bits application for now.'+crlf+'Use POTH.Telescope and then select your telescope from the POTH menu.'+crlf+'See http://ascom-standards.org for more information.');
    {$else}
    Showmessage('Please ensure that ASCOM telescope drivers are installed properly.'+crlf+'See http://ascom-standards.org for more information.');
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
   T := CreateOleObject(edit1.text);
   T.SetupDialog;
   T:=Unassigned;
end else begin
   T.SetupDialog;
end;
UpdTrackingButton;
end;
except
  on E: EOleException do MessageDlg('Error: ' + E.Message, mtWarning, [mbOK], 0);
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
         on E: EOleException do MessageDlg('Error: ' + E.Message, mtWarning, [mbOK], 0);
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
         on E: EOleException do MessageDlg('Error: ' + E.Message, mtWarning, [mbOK], 0);
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
  on E: EOleException do MessageDlg('Error: ' + E.Message, mtWarning, [mbOK], 0);
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
         on E: EOleException do MessageDlg('Error: ' + E.Message, mtWarning, [mbOK], 0);
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
            T := CreateOleObject(edit1.text);
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
  on E: EOleException do MessageDlg('Error: ' + E.Message, mtWarning, [mbOK], 0);
end;
{$endif}
end;


end.
