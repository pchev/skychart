unit pu_ascomclient;

{$MODE objfpc}{$H+}

{------------- interface for ASCOM telescope driver. ----------------------------

Copyright (C) 2000 Patrick Chevalley

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
Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.

-------------------------------------------------------------------------------}

interface

uses
  {$ifdef mswindows}
    Variants, comobj, Windows, ShlObj, ShellAPI,
  {$endif}
  LCLIntf, u_util, u_constant, u_help, u_translation,
  Messages, SysUtils, Classes, Graphics, Controls,
  Forms, Dialogs, UScaleDPI,
  StdCtrls, Buttons, inifiles, ComCtrls, Menus, ExtCtrls;

type

  { Tpop_scope }

  Tpop_scope = class(TForm)
    GroupBox3: TGroupBox;
    ButtonAdvSetting: TSpeedButton;
    WarningLabel: TLabel;
    trackingled: TEdit;
    ButtonConnect: TSpeedButton;
    ButtonTracking: TSpeedButton;
    ButtonHide: TSpeedButton;
    ButtonDisconnect: TSpeedButton;
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
    ButtonSelect: TSpeedButton;
    ReadIntBox: TComboBox;
    Label1: TLabel;
    ButtonConfigure: TSpeedButton;
    ButtonAbort: TSpeedButton;
    ButtonSetTime: TSpeedButton;
    ButtonSetLocation: TSpeedButton;
    ButtonHelp: TSpeedButton;
    ButtonAbout: TSpeedButton;
    {Utility and form functions}
    procedure FormCreate(Sender: TObject);
    procedure kill(Sender: TObject; var CanClose: Boolean);
    procedure ButtonAdvSettingClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure ButtonConnectClick(Sender: TObject);
    procedure SaveConfig;
    procedure ReadIntBoxChange(Sender: TObject);
    procedure ButtonDisconnectClick(Sender: TObject);
    procedure ButtonHideClick(Sender: TObject);
    procedure ButtonHelpClick(Sender: TObject);
    procedure ButtonAbortClick(Sender: TObject);
    procedure ButtonSelectClick(Sender: TObject);
    procedure ButtonConfigureClick(Sender: TObject);
    procedure ButtonSetLocationClick(Sender: TObject);
    procedure ButtonSetTimeClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure ButtonTrackingClick(Sender: TObject);
    procedure UpdTrackingButton;
    procedure ButtonAboutClick(Sender: TObject);
  private
    { Private declarations }
    feqsys: TCheckBox;
    leqsys: TComboBox;
    FConfig: string;
    CoordLock : boolean;
    Initialized : boolean;
    ForceEqSys : boolean;
    FConnected : boolean;
    FCanSetTracking: boolean;
    FScopeEqSys : double;
    EqSysVal: integer;
    T : Variant;
    Longitude : single;                 // Observatory longitude (Negative East of Greenwich}
    Latitude : single;                  // Observatory latitude
    {$ifdef mswindows}
    curdeg_x,  curdeg_y :double;        // current equatorial position in degrees
    cur_az,  cur_alt :double;           // current alt-az position in degrees
    {$endif}
    procedure SetDef(Sender: TObject);
    Function  ScopeConnectedReal : boolean ;
    Procedure ScopeGetEqSysReal(var EqSys : double);
  public
    { Public declarations }
    procedure SetLang;
    function  ReadConfig(ConfigPath : shortstring):boolean;
    procedure SetRefreshRate(rate:integer);
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
    procedure GetScopeRates(var nrates0,nrates1:integer; axis0rates,axis1rates: Pdoublearray);
    procedure ScopeMoveAxis(axis:Integer; rate: double);
  end;


implementation
{$R *.lfm}

{-------------------------------------------------------------------------------

           Cartes du Ciel Dll compatibility functions

--------------------------------------------------------------------------------}

procedure Tpop_scope.SetRefreshRate(rate:integer);
begin
  Timer1.Interval:=rate;
  ReadIntBox.text:=inttostr(rate);
end;

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
timer1.enabled:=false;
Initialized:=false;
FConnected:=false;
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
ButtonConnect.enabled:=true;
ButtonSelect.enabled:=true;
ButtonConfigure.enabled:=true;
ButtonSetTime.enabled:=false;
ButtonSetLocation.enabled:=false;
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
ButtonSelect.enabled:=true;
ok:=false;
if trim(edit1.text)='' then exit;
try
T:=Unassigned;
T := CreateOleObject(widestring(edit1.text));
T.connected:=true;
if T.connected then begin
   FConnected:=true;
   Initialized:=true;
   FCanSetTracking:=T.CanSetTracking;
   ScopeGetEqSysReal(FScopeEqSys);
   ShowCoordinates;
   led.color:=clLime;
   ok:=true;
   timer1.enabled:=true;
   ButtonConnect.enabled:=false;
   ButtonSelect.enabled:=false;
   ButtonConfigure.enabled:=false;
   ButtonSetTime.enabled:=true;
   ButtonSetLocation.enabled:=true;
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
  result:=FConnected;
end;

Function  Tpop_scope.ScopeConnectedReal : boolean ;
begin
result:=false;
{$ifdef mswindows}
if not initialized then exit;
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
            if FCanSetTracking then T.tracking:=true;
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

Procedure Tpop_scope.ScopeGetEqSysReal(var EqSys : double);
var i: integer;
begin
if ForceEqSys then begin
  case EqSysVal of
  0 : EqSys:=0;
  1 : EqSys:=1950;
  2 : EqSys:=2000;
  3 : EqSys:=2050;
  end;
end else begin
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
end;

Procedure Tpop_scope.ScopeGetEqSys(var EqSys : double);
begin
  EqSys:=FScopeEqSys;
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

procedure Tpop_scope.GetScopeRates(var nrates0,nrates1:integer; axis0rates,axis1rates: Pdoublearray);
{$ifdef mswindows}
var rate,irate: Variant;
    i,j,k: integer;
    min,max:double;
{$endif}
begin
{$ifdef mswindows}
SetLength(axis0rates^,0);
SetLength(axis1rates^,0);
nrates0:=0;
nrates1:=0;
if ScopeConnected then begin
//  First axis
  k:=0;
  if T.CanMoveAxis(k) then begin
    rate:=T.AxisRates(k);
    j:=rate.count;
    for i:=1 to j do begin
      irate:=rate.item[i];
      inc(nrates0,2);
      SetLength(axis0rates^,nrates0);
      axis0rates^[nrates0-2]:=irate.Minimum;
      axis0rates^[nrates0-1]:=irate.Maximum;
    end;
  end;
//  Second axis
  k:=1;
  if T.CanMoveAxis(k) then begin
    rate:=T.AxisRates(k);
    j:=rate.count;
    for i:=1 to j do begin
      irate:=rate.item[i];
      inc(nrates1,2);
      SetLength(axis1rates^,nrates1);
      axis1rates^[nrates1-2]:=irate.Minimum;
      axis1rates^[nrates1-1]:=irate.Maximum;
    end;
  end;
end;
{$endif}
end;

procedure Tpop_scope.ScopeMoveAxis(axis:Integer; rate: double);
begin
if ScopeConnected then begin
  if T.CanMoveAxis(axis) then begin
     T.MoveAxis(axis,rate);
  end;
end;
end;


{-------------------------------------------------------------------------------

                       Form functions

--------------------------------------------------------------------------------}

procedure Tpop_scope.SetLang;
begin
caption:=rsASCOMTelesc;
GroupBox1.Caption:=rsDriverSelect;
Label1.Caption:=rsRefreshRate;
ButtonSelect.Caption:=rsSelect;
ButtonConfigure.Caption:=rsConfigure;
ButtonAbout.Caption:=rsAbout;
GroupBox5.Caption:=rsObservatory;
Label15.Caption:=rsLatitude;
Label16.Caption:=rsLongitude;
ButtonSetLocation.Caption:=rsSetLocation;
ButtonSetTime.Caption:=rsSetTime;
ButtonTracking.Caption:=rsTracking;
ButtonAbort.Caption:=rsAbortSlew;
ButtonHelp.Caption:=rsHelp;
ButtonConnect.Caption:=rsConnect;
ButtonDisconnect.Caption:=rsDisconnect;
ButtonHide.Caption:=rsHide;
ButtonAdvSetting.Caption:=rsAdvancedSett2;

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
EqSysVal:=ini.ReadInteger('Ascom','EqSys',0);
ForceEqSys:=ini.ReadBool('Ascom','ForceEqSys',false);
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

procedure Tpop_scope.ButtonAdvSettingClick(Sender: TObject);
var f: TForm;
    l: Tlabel;
    btok,btcan,btdef: Tbutton;
begin
f:=TForm.Create(self);
f.AutoSize:=false;
f.Caption:='ASCOM '+rsAdvancedSett2;
l:=TLabel.Create(f);
l.WordWrap:=true;
l.AutoSize:=false;
l.Width:=350;
l.Height:=round(2.2*l.Height);
l.Caption:=rsDoNotChangeA;
l.ParentFont:=true;
l.Top:=8;
l.Left:=8;
feqsys:=TCheckBox.Create(l);
leqsys:=TComboBox.Create(l);
feqsys.Caption:=rsForceEqSys;
feqsys.Left:=8;
feqsys.Top:=l.Top+l.Height+8;
leqsys.Left:=feqsys.Left+feqsys.Width+8;
leqsys.Top:=feqsys.Top;
leqsys.Items.Add('Local');
leqsys.Items.Add('1950');
leqsys.Items.Add('2000');
leqsys.Items.Add('2050');
btok:=Tbutton.Create(f);
btcan:=Tbutton.Create(f);
btdef:=Tbutton.Create(f);
btok.ModalResult:=mrOK;
btok.Caption:=rsOK;
btcan.ModalResult:=mrCancel;
btcan.Caption:=rsCancel;
btdef.OnClick:=@SetDef;
btdef.Caption:=rsDefault;
btok.Left:=8;
btok.Top:=leqsys.Top+leqsys.Height+8;
btcan.Left:=btok.Left+btok.Width+8;
btcan.Top:=btok.Top;
btdef.Left:=btcan.Left+btcan.Width+8;
btdef.Top:=btok.Top;
l.Parent:=f;
feqsys.Parent:=f;
leqsys.Parent:=f;
btok.Parent:=f;
btcan.Parent:=f;
btdef.Parent:=f;
f.AutoSize:=true;
FormPos(f,mouse.cursorpos.x,mouse.cursorpos.y);
feqsys.Checked:=ForceEqSys;
leqsys.ItemIndex:=EqSysVal;
ScaleDPI(f);
f.showmodal;
if f.ModalResult=mrOK then begin
  ForceEqSys := feqsys.Checked;
  EqSysVal   := leqsys.ItemIndex;
end;
btok.Free;
btcan.Free;
btdef.Free;
feqsys.Free;
leqsys.Free;
l.Free;
f.Free;
leqsys:=nil;
feqsys:=nil;
end;

procedure Tpop_scope.SetDef(Sender: TObject);
begin
if (feqsys<>nil) and (leqsys<>nil) then begin
 feqsys.Checked:=false;
 leqsys.ItemIndex:=0;
end;
end;

procedure Tpop_scope.FormCreate(Sender: TObject);
begin
    ScaleDPI(Self);
    CoordLock := false;
    Initialized := false;
    FConnected:=false;
    FCanSetTracking:=false;
    FScopeEqSys:=0;
end;

procedure Tpop_scope.Timer1Timer(Sender: TObject);
begin
FConnected:=ScopeConnectedReal;
if not FConnected then exit;
try
if (not CoordLock) then begin
   CoordLock := true;
   timer1.enabled:=false;
   ShowCoordinates;
   UpdTrackingButton;
   CoordLock := false;
   timer1.enabled:=true;
end;
except
   timer1.enabled:=false;
   Initialized := false;
end;
end;

procedure Tpop_scope.ButtonConnectClick(Sender: TObject);
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
ini.writeInteger('Ascom','EqSys',EqSysVal);
ini.writeBool('Ascom','ForceEqSys',ForceEqSys);
ini.writeBool('Ascom','AltAz',ShowAltAz.Checked);
ini.writestring('observatory','latitude',lat.text);
ini.writestring('observatory','longitude',long.text);
ini.free;
end;

procedure Tpop_scope.ReadIntBoxChange(Sender: TObject);
begin
     Timer1.Interval:=strtointdef(ReadIntBox.text,1000);
end;

procedure Tpop_scope.ButtonDisconnectClick(Sender: TObject);
var ok : boolean;
begin
ScopeDisconnect(ok);
end;

procedure Tpop_scope.ButtonHideClick(Sender: TObject);
begin
Hide;
end;

procedure Tpop_scope.ButtonHelpClick(Sender: TObject);
begin
ShowHelp;
end;

procedure Tpop_scope.ButtonAbortClick(Sender: TObject);
begin
ScopeAbortSlew;
end;

procedure Tpop_scope.ButtonSelectClick(Sender: TObject);
{$ifdef mswindows}
var
  V: variant;
  err: string;
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
  edit1.text:=widestring(V.Choose(widestring(edit1.text)));
  V:=Unassigned;
  SaveConfig;
  UpdTrackingButton;
  except
    on E: Exception do begin
      err:='ASCOM exception:'+E.Message;
      Showmessage(err+crlf+rsPleaseEnsure+crlf+Format(rsSeeHttpAscom,['http://ascom-standards.org']));
    end;
  end;
{$endif}
end;

procedure Tpop_scope.ButtonConfigureClick(Sender: TObject);
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

procedure Tpop_scope.ButtonSetLocationClick(Sender: TObject);
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

procedure Tpop_scope.ButtonSetTimeClick(Sender: TObject);
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
   if (not ScopeConnected) or (not FCanSetTracking) then begin
      ButtonTracking.Enabled:=false;
   end else begin
      ButtonTracking.Enabled:=true;
   end;
   if ScopeConnected then begin
      if T.Tracking then Trackingled.color:=clLime
      else Trackingled.color:=clRed;
   end;
except
  on E: EOleException do MessageDlg(rsError+': ' + E.Message, mtWarning, [mbOK], 0);
end;
{$endif}
end;

procedure Tpop_scope.ButtonTrackingClick(Sender: TObject);
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

procedure Tpop_scope.ButtonAboutClick(Sender: TObject);
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
