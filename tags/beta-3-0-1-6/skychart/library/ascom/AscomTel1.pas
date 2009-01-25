unit AscomTel1;

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
  Windows,  Messages, SysUtils, Classes, Graphics, Controls,
  Forms, Dialogs, ShellAPI,
  StdCtrls, Buttons, inifiles, ComCtrls, Menus, ExtCtrls;

type
  Tpop_scope = class(TForm)                
    GroupBox3: TGroupBox;
    SpeedButton1: TSpeedButton;
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
    SpeedButton10: TSpeedButton;
    SpeedButton4: TSpeedButton;
    SpeedButton11: TSpeedButton;
    {Utility and form functions}
    procedure formcreate(Sender: TObject);
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
    procedure SpeedButton10Click(Sender: TObject);
    procedure UpdTrackingButton;
    procedure SpeedButton11Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

procedure InitLib;

{ Cartes du Ciel Dll export }
Procedure ScopeShow; stdcall;
Procedure ScopeShowModal(var ok : boolean); stdcall;
Procedure ScopeConnect(var ok : boolean); stdcall;
Procedure ScopeDisconnect(var ok : boolean); stdcall;
Procedure ScopeGetInfo(var Name : shortstring; var QueryOK,SyncOK,GotoOK : boolean; var refreshrate : integer); stdcall;
Procedure ScopeGetEqSys(var EqSys : double); stdcall;
Procedure ScopeSetObs(la,lo : double); stdcall;
Procedure ScopeAlign(source : string; ra,dec : double); stdcall;
Procedure ScopeGetRaDec(var ar,de : double; var ok : boolean); stdcall;
Procedure ScopeGetAltAz(var alt,az : double; var ok : boolean); stdcall;
Procedure ScopeGoto(ar,de : double; var ok : boolean); stdcall;
Procedure ScopeReset; stdcall;
Function  ScopeInitialized : boolean ; stdcall;
Function  ScopeConnected : boolean ; stdcall;
Procedure ScopeClose; stdcall;

var
  pop_scope: Tpop_scope;

implementation

uses comobj, variants;

{$R *.DFM}

var CoordLock : boolean = false;
    Initialized : boolean = false;
    Initial : boolean = true;
    Appdir : string;
    T : Variant;
  curdeg_x,  curdeg_y :double;        // current equatorial position in degrees
  cur_az,  cur_alt :double;           // current alt-az position in degrees
  Longitude : Double;                 // Observatory longitude (Negative East of Greenwich}
  Latitude : Double;                  // Observatory latitude

    
const crlf=chr(10)+chr(13);

{-------------------------------------------------------------------------------

                       Utility functions

--------------------------------------------------------------------------------}
Function sgn(x:Double):Double ;
begin
if x<0 then
   sgn:= -1
else
   sgn:=  1 ;
end ;

function  Rmod(x,y:Double):Double;
BEGIN
    Rmod := x - Int(x/y) * y ;
END  ;

Function DEToStr(de: Double) : string;
var dd,min1,min,sec: Double;
    d,m,s : string;
begin
    dd:=Int(de);
    min1:=abs(de-dd)*60;
    if min1>=59.99 then begin
       dd:=dd+sgn(de);
       min1:=0.0;
    end;
    min:=Int(min1);
    sec:=(min1-min)*60;
    if sec>=59.5 then begin
       min:=min+1;
       sec:=0.0;
    end;
    str(abs(dd):2:0,d);
    if abs(dd)<10 then d:='0'+trim(d);
    if de<0 then d:='-'+d else d:='+'+d;
    str(min:2:0,m);
    if abs(min)<10 then m:='0'+trim(m);
    str(sec:2:0,s);
    if abs(sec)<9.5 then s:='0'+trim(s);
    result := d+'°'+m+chr(39)+s+'"';
end;

Function ARToStr(ar: Double) : string;
var dd,min1,min,sec: Double;
    d,m,s : string;
begin
    dd:=Int(ar);
    min1:=abs(ar-dd)*60;
    if min1>=59.999 then begin
       dd:=dd+sgn(ar);
       min1:=0.0;
    end;
    min:=Int(min1);
    sec:=(min1-min)*60;
    if sec>=59.95 then begin
       min:=min+1;
       sec:=0.0;
    end;
    str(dd:2:0,d);
    if abs(dd)<10 then d:='0'+trim(d);
    str(min:2:0,m);
    if abs(min)<10 then m:='0'+trim(m);
    str(sec:2:0,s);
    if abs(sec)<9.95 then s:='0'+trim(s);
    result := d+'h'+m+'m'+s+'s';
end;

{-------------------------------------------------------------------------------

                       Cartes du Ciel Dll functions

--------------------------------------------------------------------------------}
Procedure ShowCoordinates;
begin
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
end;

Procedure ScopeDisconnect(var ok : boolean); stdcall;
begin
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
end;

Procedure ScopeConnect(var ok : boolean); stdcall;
var dis_ok : boolean;
begin
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
end;

Procedure ScopeClose; stdcall;
begin
pop_scope.release;
end;

Function  ScopeConnected : boolean ; stdcall;
begin
result:=false;
if not initialized then exit;
if VarIsEmpty(T) then exit;
try
result:=T.connected;
except
 result:=false;
end;
end;

Function  ScopeInitialized : boolean ; stdcall;
begin
result:= ScopeConnected;
end;

Procedure ScopeAlign(source : string; ra,dec : double); stdcall;
begin
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

end;

Procedure ScopeShowModal(var ok : boolean); stdcall;
begin
pop_scope.showmodal;
ok:=(pop_scope.modalresult=mrOK);
end;

Procedure ScopeShow; stdcall;
begin
pop_scope.show
end;

Procedure ScopeGetRaDec(var ar,de : double; var ok : boolean); stdcall;
begin
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
end;

Procedure ScopeGetAltAz(var alt,az : double; var ok : boolean); stdcall;
begin
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
end;

Procedure ScopeGetInfo(var Name : shortstring; var QueryOK,SyncOK,GotoOK : boolean; var refreshrate : integer); stdcall;
begin
   if (pop_scope=nil)or(pop_scope.pos_x=nil) then begin
      Initialized := false;
      Initial := true;
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
end;

Procedure ScopeGetEqSys(var EqSys : double); stdcall;
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

Procedure ScopeReset; stdcall;
begin
end;

Procedure ScopeSetObs(la,lo : double); stdcall;
begin
latitude:=la;
longitude:=-lo;
pop_scope.lat.text:=detostr(latitude);
pop_scope.long.text:=detostr(longitude);
end;

Procedure ScopeGoto(ar,de : double; var ok : boolean); stdcall;
begin
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
end;

{-------------------------------------------------------------------------------

                       Form functions

--------------------------------------------------------------------------------}
procedure Tpop_scope.formcreate(Sender: TObject);
var ini:tinifile;
    buf,nom : string;
begin
     Getdir(0,appdir);
     buf:=extractfilepath(paramstr(0));
     ini:=tinifile.create(buf+'scope.ini');
     nom:= ini.readstring('Ascom','name','');
     edit1.text:=nom;
     ShowAltAz.Checked:=ini.ReadBool('Ascom','AltAz',false);
     ReadIntBox.text:=ini.readstring('Ascom','read_interval','1000');
     lat.text:=ini.readstring('observatory','latitude','0');
     long.text:=ini.readstring('observatory','longitude','0');
     ini.free;
     Timer1.Interval:=strtointdef(ReadIntBox.text,500);
     UpdTrackingButton;
     initial:=false;
end;

procedure InitLib;
begin
     decimalseparator:='.';
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
ini:=tinifile.create(extractfilepath(paramstr(0))+'scope.ini');
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

Function ExecuteFile(const FileName, Params, DefaultDir: string; ShowCmd: Integer): THandle;
var
  zFileName, zParams, zDir: array[0..79] of Char;
begin
  Result := ShellExecute(pop_scope.Handle, nil, StrPCopy(zFileName, FileName),
                         StrPCopy(zParams, Params), StrPCopy(zDir, DefaultDir), ShowCmd);
end;

procedure Tpop_scope.SpeedButton4Click(Sender: TObject);
begin
ExecuteFile('ascomtel.html','',appdir+'\doc',SW_SHOWNORMAL);
end;

procedure Tpop_scope.SpeedButton6Click(Sender: TObject);
begin
   if ScopeConnected then begin
      try
         T.AbortSlew;
      except
         on E: EOleException do MessageDlg('Error: ' + E.Message, mtWarning, [mbOK], 0);
      end;
   end;
end;

procedure Tpop_scope.SpeedButton3Click(Sender: TObject);
var
  V: variant;
begin
  try
  initialized:=false;
  V := CreateOleObject('DriverHelper.Chooser');
  V.devicetype:='Telescope';
  edit1.text:=V.Choose(edit1.text);
  V:=Unassigned;
  SaveConfig;
  UpdTrackingButton;
  except
    Showmessage('Please ensure that ASCOM telescope drivers are installed properly.'+crlf+'See http://ascom-standards.org for more information.');
  end;
end;

procedure Tpop_scope.SpeedButton7Click(Sender: TObject);
begin
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

end;

procedure Tpop_scope.SpeedButton9Click(Sender: TObject);
begin
   if ScopeConnected then begin
      try
         T.SiteLongitude:=longitude;
         T.SiteLatitude:=latitude;
      except
         on E: EOleException do MessageDlg('Error: ' + E.Message, mtWarning, [mbOK], 0);
      end;
   end;
end;

procedure Tpop_scope.SpeedButton8Click(Sender: TObject);
var utc: Tsystemtime;
    buf : shortstring;
begin
//date='26.01.02 13:13:22'
   if ScopeConnected then begin
      try
         getsystemtime(utc);
         buf:=(Formatdatetime('dd.mm.yy hh:nn:ss',systemtimetodatetime(utc)));
         //T.UTCDate:=buf;
         // does not raise and error but may not be UTC
         T.UTCDate:=systemtimetodatetime(utc);
      except
         on E: EOleException do MessageDlg('Error: ' + E.Message, mtWarning, [mbOK], 0);
      end;
   end;
end;

procedure Tpop_scope.FormDestroy(Sender: TObject);
begin
SaveConfig;
end;

procedure Tpop_scope.UpdTrackingButton;
begin
try
   if not ScopeConnected then exit;
   if (not T.CanSetTracking)or(not T.connected) then begin
      SpeedButton10.Font.Color:=clWindowText;
      SpeedButton10.Font.Style:=[];
      SpeedButton10.Enabled:=false;
   end else begin
      SpeedButton10.Enabled:=true;
      SpeedButton10.Font.Style:=[fsBold];
      if T.Tracking then SpeedButton10.Font.Color:=clGreen
      else SpeedButton10.Font.Color:=clRed;
   end;
except
  on E: EOleException do MessageDlg('Error: ' + E.Message, mtWarning, [mbOK], 0);
end;
end;


procedure Tpop_scope.SpeedButton10Click(Sender: TObject);
begin
   if ScopeConnected then begin
      try
         T.Tracking:=not T.Tracking;
         UpdTrackingButton;
      except
         on E: EOleException do MessageDlg('Error: ' + E.Message, mtWarning, [mbOK], 0);
      end;
   end;
end;

procedure Tpop_scope.SpeedButton11Click(Sender: TObject);
var buf : string;
begin
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
end;

initialization
//decimalseparator:='.';
pop_scope:=Tpop_scope.Create(nil);

end.
