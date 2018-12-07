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
  Variants, comobj, Windows, ShlObj, ShellAPI, math,
  {$endif}
  LCLIntf, u_util, u_constant, u_help, u_translation,
  Messages, SysUtils, Classes, Graphics, Controls,
  Forms, Dialogs, UScaleDPI,
  StdCtrls, Buttons, inifiles, ComCtrls, Menus, ExtCtrls;

type

  { Tpop_scope }

  Tpop_scope = class(TForm)
    ButtonGetLocation: TSpeedButton;
    ButtonPark: TSpeedButton;
    elev: TEdit;
    GroupBox3: TGroupBox;
    ButtonAdvSetting: TSpeedButton;
    Label2: TLabel;
    parkled: TEdit;
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
    procedure ButtonGetLocationClick(Sender: TObject);
    procedure ButtonParkClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure kill(Sender: TObject; var CanClose: boolean);
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
    procedure UpdParkButton;
    procedure ButtonAboutClick(Sender: TObject);
  private
    { Private declarations }
    feqsys: TCheckBox;
    leqsys: TComboBox;
    FConfig: string;
    CoordLock: boolean;
    Initialized: boolean;
    ForceEqSys: boolean;
    FConnected: boolean;
    FCanSetTracking: boolean;
    FCanParkUnpark: boolean;
    FScopeEqSys: double;
    EqSysVal: integer;
    T: variant;
    FLongitude: double;                // Observatory longitude (Positive East of Greenwich}
    FLatitude: double;                 // Observatory latitude
    FElevation: double;                // Observatory elevation
    {$ifdef mswindows}
    curdeg_x, curdeg_y: double;        // current equatorial position in degrees
    cur_az, cur_alt: double;           // current alt-az position in degrees
    {$endif}
    FObservatoryCoord: TNotifyEvent;
    procedure SetDef(Sender: TObject);
    function ScopeConnectedReal: boolean;
    procedure ScopeGetEqSysReal(var EqSys: double);
  public
    { Public declarations }
    procedure SetLang;
    function ReadConfig(ConfigPath: shortstring): boolean;
    procedure SetRefreshRate(rate: integer);
    procedure ShowCoordinates;
    procedure ScopeShow;
    procedure ScopeShowModal(var ok: boolean);
    procedure ScopeConnect(var ok: boolean);
    procedure ScopeDisconnect(var ok: boolean);
    procedure ScopeGetInfo(var scName: shortstring;
      var QueryOK, SyncOK, GotoOK: boolean; var refreshrate: integer);
    procedure ScopeGetEqSys(var EqSys: double);
    procedure ScopeSetObs(la, lo, alt: double);
    procedure ScopeAlign(Source: string; ra, Dec: single);
    procedure ScopeGetRaDec(var ar, de: double; var ok: boolean);
    procedure ScopeGetAltAz(var alt, az: double; var ok: boolean);
    procedure ScopeGoto(ar, de: single; var ok: boolean);
    procedure ScopeAbortSlew;
    procedure ScopeReset;
    function ScopeInitialized: boolean;
    function ScopeConnected: boolean;
    procedure ScopeClose;
    function ScopeInterfaceVersion: integer;
    procedure ScopeReadConfig(ConfigPath: shortstring);
    procedure GetScopeRates(var nrates0, nrates1: integer;
      axis0rates, axis1rates: Pdoublearray);
    procedure ScopeMoveAxis(axis: integer; rate: double);
    property Longitude: double read FLongitude;
    property Latitude: double read FLatitude;
    property Elevation: double read FElevation;
    property onObservatoryCoord: TNotifyEvent read FObservatoryCoord write FObservatoryCoord;
  end;


implementation

{$R *.lfm}

{-------------------------------------------------------------------------------

           Cartes du Ciel Dll compatibility functions

--------------------------------------------------------------------------------}

procedure Tpop_scope.SetRefreshRate(rate: integer);
begin
  Timer1.Interval := rate;
  ReadIntBox.Text := IntToStr(rate);
end;

procedure Tpop_scope.ShowCoordinates;
begin
{$ifdef mswindows}
  if ScopeInitialized then
  begin
    try
      Curdeg_x := T.RightAscension * 15;
      Curdeg_y := T.Declination;
    except
      on E: EOleException do
        MessageDlg(rsError + ': ' + E.Message, mtWarning, [mbOK], 0);
    end;
    if ShowAltAz.Checked then
    begin
      try
        Cur_az := T.Azimuth;
        Cur_alt := T.Altitude;
      except
        ShowAltAz.Checked := False;
      end;
    end;
    pos_x.Text := artostr(Curdeg_x / 15);
    pos_y.Text := detostr(Curdeg_y);
    if ShowAltAz.Checked then
    begin
      az_x.Text := detostr(Cur_az);
      alt_y.Text := detostr(Cur_alt);
    end
    else
    begin
      az_x.Text := '';
      alt_y.Text := '';
    end;
    if ShowAltAz.Checked and (Cur_alt < 0) then
      alt_y.Color := clRed
    else
      alt_y.Color := clWindow;
  end
  else
  begin
    pos_x.Text := '';
    pos_y.Text := '';
    az_x.Text := '';
    alt_y.Text := '';
  end;
{$endif}
end;

procedure Tpop_scope.ScopeDisconnect(var ok: boolean);
begin
{$ifdef mswindows}
  timer1.Enabled := False;
  Initialized := False;
  FConnected := False;
  pos_x.Text := '';
  pos_y.Text := '';
  az_x.Text := '';
  alt_y.Text := '';
  if trim(edit1.Text) = '' then
    exit;
  try
    if not VarIsEmpty(T) then
    begin
      T.connected := False;
      T := Unassigned;
    end;
    ok := True;
    led.color := clRed;
    ButtonConnect.Enabled := True;
    ButtonSelect.Enabled := True;
    ButtonConfigure.Enabled := True;
    ButtonSetTime.Enabled := False;
    ButtonSetLocation.Enabled := False;
    ButtonGetLocation.Enabled := False;
    UpdTrackingButton;
    UpdParkButton;
  except
    on E: EOleException do
      MessageDlg(rsError + ': ' + E.Message, mtWarning, [mbOK], 0);
  end;
{$endif}
end;

procedure Tpop_scope.ScopeConnect(var ok: boolean);
{$ifdef mswindows}
var
  dis_ok: boolean;
{$endif}
begin
{$ifdef mswindows}
  led.color := clRed;
  led.refresh;
  timer1.Enabled := False;
  ButtonSelect.Enabled := True;
  ok := False;
  if trim(edit1.Text) = '' then
    exit;
  try
    T := Unassigned;
    T := CreateOleObject(WideString(edit1.Text));
    T.connected := True;
    if T.connected then
    begin
      FConnected := True;
      Initialized := True;
      try
      FCanSetTracking := T.CanSetTracking;
      FCanParkUnpark := T.CanPark and T.CanUnpark;
      except
        FCanSetTracking := false;
        FCanParkUnpark := false;
      end;
      ScopeGetEqSysReal(FScopeEqSys);
      ShowCoordinates;
      led.color := clLime;
      ok := True;
      timer1.Enabled := True;
      ButtonConnect.Enabled := False;
      ButtonSelect.Enabled := False;
      ButtonConfigure.Enabled := False;
      ButtonSetTime.Enabled := True;
      ButtonSetLocation.Enabled := True;
      ButtonGetLocation.Enabled := True;
    end
    else
      scopedisconnect(dis_ok);
    UpdTrackingButton;
  except
    on E: EOleException do
      MessageDlg(rsError + ': ' + E.Message, mtWarning, [mbOK], 0);
  end;
{$endif}
end;

procedure Tpop_scope.ScopeClose;
begin
  Release;
end;

function Tpop_scope.ScopeConnected: boolean;
begin
  Result := FConnected;
end;

function Tpop_scope.ScopeInterfaceVersion: integer;
begin
  result:=1;
  {$ifdef mswindows}
  try
    Result := T.InterfaceVersion;
  except
    Result := 1;
  end;
 {$endif}
end;

function Tpop_scope.ScopeConnectedReal: boolean;
begin
  Result := False;
{$ifdef mswindows}
  if not initialized then
    exit;
  Result := False;
  if VarIsEmpty(T) then
    exit;
  try
    Result := T.connected;
  except
    Result := False;
  end;
{$endif}
end;

function Tpop_scope.ScopeInitialized: boolean;
begin
  Result := ScopeConnected;
end;

procedure Tpop_scope.ScopeAlign(Source: string; ra, Dec: single);
begin
{$ifdef mswindows}
  if not ScopeConnected then
    exit;
  if T.CanSync then
  begin
    try
      if not T.tracking then
      begin
        if FCanSetTracking then
          T.tracking := True;
        UpdTrackingButton;
      end;
      T.SyncToCoordinates(Ra, Dec);
    except
      on E: EOleException do
        MessageDlg(rsError + ': ' + E.Message, mtWarning, [mbOK], 0);
    end;
  end;
{$endif}
end;

procedure Tpop_scope.ScopeShowModal(var ok: boolean);
begin
  showmodal;
  ok := (modalresult = mrOk);
end;

procedure Tpop_scope.ScopeShow;
begin
  Show;
end;

procedure Tpop_scope.ScopeGetRaDec(var ar, de: double; var ok: boolean);
begin
{$ifdef mswindows}
  if ScopeConnected then
  begin
    try
      ar := Curdeg_x / 15;
      de := Curdeg_y;
      ok := True;
    except
      on E: EOleException do
      begin
        MessageDlg(rsError + ': ' + E.Message, mtWarning, [mbOK], 0);
        ok := False;
      end;
    end;
  end
  else
    ok := False;
{$endif}
end;

procedure Tpop_scope.ScopeGetAltAz(var alt, az: double; var ok: boolean);
begin
{$ifdef mswindows}
  if ScopeConnected then
  begin
    try
      az := cur_az;
      alt := cur_alt;
      ok := True;
    except
      on E: EOleException do
      begin
        MessageDlg(rsError + ': ' + E.Message, mtWarning, [mbOK], 0);
        ok := False;
      end;
    end;
  end
  else
    ok := False;
{$endif}
end;

procedure Tpop_scope.ScopeGetInfo(var scName: shortstring;
  var QueryOK, SyncOK, GotoOK: boolean; var refreshrate: integer);
begin
{$ifdef mswindows}
  if ScopeConnected then
  begin
    try
      scname := T.Name;
      QueryOK := True;
      SyncOK := T.CanSync;
      GotoOK := T.CanSlew;
    except
      on E: EOleException do
        MessageDlg(rsError + ': ' + E.Message, mtWarning, [mbOK], 0);
    end;
  end
  else
  begin
    scname := '';
    QueryOK := False;
    SyncOK := False;
    GotoOK := False;
  end;
  refreshrate := timer1.interval;
{$endif}
end;

procedure Tpop_scope.ScopeGetEqSysReal(var EqSys: double);
var
  i: integer;
begin
  if ForceEqSys then
  begin
    case EqSysVal of
      0: EqSys := 0;
      1: EqSys := 1950;
      2: EqSys := 2000;
      3: EqSys := 2050;
    end;
  end
  else
  begin
    if ScopeConnected then
    begin
      try
        i := T.EquatorialSystem;
      except
        i := 0;
      end;
    end
    else
      i := 0;
    case i of
      0: EqSys := 0;
      1: EqSys := 0;
      2: EqSys := 2000;
      3: EqSys := 2050;
      4: EqSys := 1950;
    end;
  end;
end;

procedure Tpop_scope.ScopeGetEqSys(var EqSys: double);
begin
  EqSys := FScopeEqSys;
end;

procedure Tpop_scope.ScopeReset;
begin
end;

procedure Tpop_scope.ScopeSetObs(la, lo, alt: double);
begin
  Flatitude := la;
  Flongitude := lo;
  FElevation := alt;
  lat.Text := detostr(Flatitude);
  long.Text := detostr(Flongitude);
  elev.Text := FormatFloat(f1,FElevation);
end;

procedure Tpop_scope.ScopeGoto(ar, de: single; var ok: boolean);
begin
{$ifdef mswindows}
  if not ScopeConnected then
    exit;
  try
    if not T.tracking then
    begin
      T.tracking := True;
      UpdTrackingButton;
    end;
    if T.CanSlewAsync then
      T.SlewToCoordinatesAsync(ar, de)
    else
      T.SlewToCoordinates(ar, de);
  except
    on E: EOleException do
      MessageDlg(rsError + ': ' + E.Message, mtWarning, [mbOK], 0);
  end;
{$endif}
end;

procedure Tpop_scope.ScopeReadConfig(ConfigPath: shortstring);
begin
  ReadConfig(ConfigPath);
end;

procedure Tpop_scope.ScopeAbortSlew;
begin
{$ifdef mswindows}
  if ScopeConnected then
  begin
    try
      T.AbortSlew;
    except
      on E: EOleException do
        MessageDlg(rsError + ': ' + E.Message, mtWarning, [mbOK], 0);
    end;
  end;
{$endif}
end;

procedure Tpop_scope.GetScopeRates(var nrates0, nrates1: integer;
  axis0rates, axis1rates: Pdoublearray);
{$ifdef mswindows}
var
  rate, irate: variant;
  i, j, k: integer;
  min, max: double;
{$endif}
begin
{$ifdef mswindows}
  SetLength(axis0rates^, 0);
  SetLength(axis1rates^, 0);
  nrates0 := 0;
  nrates1 := 0;
  if ScopeConnected then
  begin
    try
    //  First axis
    k := 0;
    if T.CanMoveAxis(k) then
    begin
      rate := T.AxisRates(k);
      j := rate.Count;
      for i := 1 to j do
      begin
        irate := rate.item[i];
        Inc(nrates0, 2);
        SetLength(axis0rates^, nrates0);
        axis0rates^[nrates0 - 2] := irate.Minimum;
        axis0rates^[nrates0 - 1] := irate.Maximum;
      end;
    end;
    //  Second axis
    k := 1;
    if T.CanMoveAxis(k) then
    begin
      rate := T.AxisRates(k);
      j := rate.Count;
      for i := 1 to j do
      begin
        irate := rate.item[i];
        Inc(nrates1, 2);
        SetLength(axis1rates^, nrates1);
        axis1rates^[nrates1 - 2] := irate.Minimum;
        axis1rates^[nrates1 - 1] := irate.Maximum;
      end;
    end;
    except
      // unsupported by interface V1
    end;
  end;
{$endif}
end;

procedure Tpop_scope.ScopeMoveAxis(axis: integer; rate: double);
begin
{$ifdef mswindows}
  if ScopeConnected then
  begin
    try
    if T.CanMoveAxis(axis) then
    begin
      T.MoveAxis(axis, rate);
    end;
    except
      // unsupported by interface V1
    end;
  end;
{$endif}
end;


{-------------------------------------------------------------------------------

                       Form functions

--------------------------------------------------------------------------------}

procedure Tpop_scope.SetLang;
begin
  Caption := rsASCOMTelesc;
  GroupBox1.Caption := rsDriverSelect;
  Label1.Caption := rsRefreshRate;
  ButtonSelect.Caption := rsSelect;
  ButtonConfigure.Caption := rsConfigure;
  ButtonAbout.Caption := rsAbout;
  GroupBox5.Caption := rsObservatory;
  Label15.Caption := rsLatitude;
  Label16.Caption := rsLongitude;
  label2.Caption:=rsAltitude;
  ButtonSetLocation.Caption := rsSetToTelesco;
  ButtonGetLocation.Caption := rsGetFromTeles;
  ButtonSetTime.Caption := rsSetTime;
  ButtonTracking.Caption := rsTracking;
  ButtonAbort.Caption := rsAbortSlew;
  ButtonHelp.Caption := rsHelp;
  ButtonConnect.Caption := rsConnect;
  ButtonDisconnect.Caption := rsDisconnect;
  ButtonHide.Caption := rsHide;
  ButtonAdvSetting.Caption := rsAdvancedSett2;

{$ifdef mswindows}
  WarningLabel.Caption := '';
{$else}
  WarningLabel.Caption := Format(rsNotAvailon, [compile_system]);
{$endif}
  SetHelp(self, hlpASCOM);
end;

function Tpop_scope.ReadConfig(ConfigPath: shortstring): boolean;
var
  ini: tinifile;
  nom: string;
begin
  Result := DirectoryExists(ConfigPath);
  if Result then
    FConfig := slash(ConfigPath) + 'scope.ini'
  else
    FConfig := slash(extractfilepath(ParamStr(0))) + 'scope.ini';
  ini := tinifile.Create(FConfig);
  nom := ini.readstring('Ascom', 'name', '');
  if trim(nom) = '' then
    nom := 'POTH.Telescope';
  edit1.Text := nom;
  EqSysVal := ini.ReadInteger('Ascom', 'EqSys', 0);
  ForceEqSys := ini.ReadBool('Ascom', 'ForceEqSys', False);
  ShowAltAz.Checked := ini.ReadBool('Ascom', 'AltAz', False);
  ReadIntBox.Text := ini.readstring('Ascom', 'read_interval', '1000');
  lat.Text := ini.readstring('observatory', 'latitude', '0');
  long.Text := ini.readstring('observatory', 'longitude', '0');
  ini.Free;
  Timer1.Interval := strtointdef(ReadIntBox.Text, 1000);
end;


procedure Tpop_scope.kill(Sender: TObject; var CanClose: boolean);
begin
  Saveconfig;
  if ScopeConnected then
  begin
    canclose := False;
    hide;
  end;
end;

procedure Tpop_scope.ButtonAdvSettingClick(Sender: TObject);
var
  f: TForm;
  l: Tlabel;
  btok, btcan, btdef: TButton;
begin
  f := TForm.Create(self);
  f.AutoSize := False;
  f.Caption := 'ASCOM ' + rsAdvancedSett2;
  l := TLabel.Create(f);
  l.WordWrap := True;
  l.AutoSize := False;
  l.Width := 350;
  l.Height := round(2.2 * l.Height);
  l.Caption := rsDoNotChangeA;
  l.ParentFont := True;
  l.Top := 8;
  l.Left := 8;
  feqsys := TCheckBox.Create(l);
  leqsys := TComboBox.Create(l);
  feqsys.Caption := rsForceEqSys;
  feqsys.Left := 8;
  feqsys.Top := l.Top + l.Height + 8;
  leqsys.Left := feqsys.Left + feqsys.Width + 8;
  leqsys.Top := feqsys.Top;
  leqsys.Items.Add('Local');
  leqsys.Items.Add('1950');
  leqsys.Items.Add('2000');
  leqsys.Items.Add('2050');
  btok := TButton.Create(f);
  btcan := TButton.Create(f);
  btdef := TButton.Create(f);
  btok.ModalResult := mrOk;
  btok.Caption := rsOK;
  btcan.ModalResult := mrCancel;
  btcan.Caption := rsCancel;
  btdef.OnClick := @SetDef;
  btdef.Caption := rsDefault;
  btok.Left := 8;
  btok.Top := leqsys.Top + leqsys.Height + 8;
  btcan.Left := btok.Left + btok.Width + 8;
  btcan.Top := btok.Top;
  btdef.Left := btcan.Left + btcan.Width + 8;
  btdef.Top := btok.Top;
  l.Parent := f;
  feqsys.Parent := f;
  leqsys.Parent := f;
  btok.Parent := f;
  btcan.Parent := f;
  btdef.Parent := f;
  f.AutoSize := True;
  FormPos(f, mouse.cursorpos.x, mouse.cursorpos.y);
  feqsys.Checked := ForceEqSys;
  leqsys.ItemIndex := EqSysVal;
  ScaleDPI(f);
  f.showmodal;
  if f.ModalResult = mrOk then
  begin
    ForceEqSys := feqsys.Checked;
    EqSysVal := leqsys.ItemIndex;
  end;
  btok.Free;
  btcan.Free;
  btdef.Free;
  feqsys.Free;
  leqsys.Free;
  l.Free;
  f.Free;
  leqsys := nil;
  feqsys := nil;
end;

procedure Tpop_scope.SetDef(Sender: TObject);
begin
  if (feqsys <> nil) and (leqsys <> nil) then
  begin
    feqsys.Checked := False;
    leqsys.ItemIndex := 0;
  end;
end;

procedure Tpop_scope.FormCreate(Sender: TObject);
begin
  ScaleDPI(Self);
  CoordLock := False;
  Initialized := False;
  FConnected := False;
  FCanSetTracking := False;
  FCanParkUnpark := False;
  FScopeEqSys := 0;
end;

procedure Tpop_scope.Timer1Timer(Sender: TObject);
begin
  FConnected := ScopeConnectedReal;
  if not FConnected then
    exit;
  try
    if (not CoordLock) then
    begin
      CoordLock := True;
      timer1.Enabled := False;
      ShowCoordinates;
      UpdTrackingButton;
      UpdParkButton;
      CoordLock := False;
      timer1.Enabled := True;
    end;
  except
    timer1.Enabled := False;
    Initialized := False;
  end;
end;

procedure Tpop_scope.ButtonConnectClick(Sender: TObject);
var
  ok: boolean;
begin
  ScopeConnect(ok);
end;

procedure Tpop_scope.SaveConfig;
var
  ini: tinifile;
begin
  ini := tinifile.Create(FConfig);
  ini.writestring('Ascom', 'name', edit1.Text);
  ini.writestring('Ascom', 'read_interval', ReadIntBox.Text);
  ini.writeInteger('Ascom', 'EqSys', EqSysVal);
  ini.writeBool('Ascom', 'ForceEqSys', ForceEqSys);
  ini.writeBool('Ascom', 'AltAz', ShowAltAz.Checked);
  ini.writestring('observatory', 'latitude', lat.Text);
  ini.writestring('observatory', 'longitude', long.Text);
  ini.Free;
end;

procedure Tpop_scope.ReadIntBoxChange(Sender: TObject);
begin
  Timer1.Interval := strtointdef(ReadIntBox.Text, 1000);
end;

procedure Tpop_scope.ButtonDisconnectClick(Sender: TObject);
var
  ok: boolean;
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
    initialized := False;
    try
      V := CreateOleObject('ASCOM.Utilities.Chooser');
    except
      V := CreateOleObject('DriverHelper.Chooser');
    end;
    V.DeviceType := WideString('Telescope');
    edit1.Text := WideString(V.Choose(WideString(edit1.Text)));
    V := Unassigned;
    SaveConfig;
    UpdTrackingButton;
  except
    on E: Exception do
    begin
      err := 'ASCOM exception:' + E.Message;
      ShowMessage(err + crlf + rsPleaseEnsure + crlf + Format(
        rsSeeHttpAscom, ['http://ascom-standards.org']));
    end;
  end;
{$endif}
end;

procedure Tpop_scope.ButtonConfigureClick(Sender: TObject);
begin
{$ifdef mswindows}
  try
    if (edit1.Text > '') and (not Scopeconnected) then
    begin
      if VarIsEmpty(T) then
      begin
        T := CreateOleObject(WideString(edit1.Text));
        T.SetupDialog;
        T := Unassigned;
      end
      else
      begin
        T.SetupDialog;
      end;
      UpdTrackingButton;
    end;
  except
    on E: EOleException do
      MessageDlg(rsError + ': ' + E.Message, mtWarning, [mbOK], 0);
  end;
{$endif}
end;

procedure Tpop_scope.ButtonGetLocationClick(Sender: TObject);
begin
{$ifdef mswindows}
  if ScopeConnected then
  begin
    try
      Flongitude := T.SiteLongitude;
      Flatitude := T.SiteLatitude;
      FElevation := T.SiteElevation;
      lat.Text := detostr(Flatitude);
      long.Text := detostr(Flongitude);
      elev.Text := FormatFloat(f1,FElevation);
      if assigned(FObservatoryCoord) then
        FObservatoryCoord(self);
    except
      on E: EOleException do
        MessageDlg(rsError + ': ' + E.Message, mtWarning, [mbOK], 0);
    end;
  end;
{$endif}
end;


procedure Tpop_scope.ButtonSetLocationClick(Sender: TObject);
begin
{$ifdef mswindows}
  if ScopeConnected then
  begin
    try
      T.SiteLongitude := Flongitude;
      T.SiteLatitude := Flatitude;
      T.SiteElevation := FElevation;
    except
      on E: EOleException do
        MessageDlg(rsError + ': ' + E.Message, mtWarning, [mbOK], 0);
    end;
  end;
{$endif}
end;

procedure Tpop_scope.ButtonSetTimeClick(Sender: TObject);
{$ifdef mswindows}
var
  utc: Tsystemtime;
{$endif}
begin
{$ifdef mswindows}
  if ScopeConnected then
  begin
    try
      getsystemtime(utc);
      // does not raise and error but may not be UTC
      T.UTCDate := systemtimetodatetime(utc);
    except
      on E: EOleException do
        MessageDlg(rsError + ': ' + E.Message, mtWarning, [mbOK], 0);
    end;
  end;
{$endif}
end;

procedure Tpop_scope.FormDestroy(Sender: TObject);
begin
  SaveConfig;
end;

procedure Tpop_scope.UpdParkButton;
begin
{$ifdef mswindows}
  try
    if (not ScopeConnected) or (not FCanParkUnpark) then
    begin
      ButtonPark.Enabled := False;
      parkled.color := clRed;
    end
    else
    begin
      ButtonPark.Enabled := True;
    end;
    if ScopeConnected and FCanParkUnpark then
    begin
      if T.AtPark then begin
        parkled.color := clRed;
        ButtonPark.Caption := rsUnpark;
      end
      else begin
        parkled.color := clLime;
        ButtonPark.Caption := rsPark;
      end;
    end;
  except
    on E: EOleException do
      MessageDlg(rsError + ': ' + E.Message, mtWarning, [mbOK], 0);
  end;
{$endif}
end;

procedure Tpop_scope.UpdTrackingButton;
begin
{$ifdef mswindows}
  try
    if (not ScopeConnected) or (not FCanSetTracking) then
    begin
      ButtonTracking.Enabled := False;
    end
    else
    begin
      ButtonTracking.Enabled := True;
    end;
    if ScopeConnected then
    begin
      if T.Tracking then
        Trackingled.color := clLime
      else
        Trackingled.color := clRed;
    end
    else
      Trackingled.color := clRed;
  except
    on E: EOleException do
      MessageDlg(rsError + ': ' + E.Message, mtWarning, [mbOK], 0);
  end;
{$endif}
end;

procedure Tpop_scope.ButtonParkClick(Sender: TObject);
begin
{$ifdef mswindows}
  if ScopeConnected and FCanParkUnpark then
  begin
    try
      if ButtonPark.Caption = rsUnpark then begin
        if T.CanUnpark then
           T.Unpark;
      end;
      if ButtonPark.Caption = rsPark then begin
        if T.CanPark and
        (MessageDlg(rsDoYouReallyW, mtConfirmation, mbYesNo, 0)=mrYes)
        then
           T.Park;
      end;
      UpdParkButton;
    except
      on E: EOleException do
        MessageDlg(rsError + ': ' + E.Message, mtWarning, [mbOK], 0);
    end;
  end;
{$endif}
end;

procedure Tpop_scope.ButtonTrackingClick(Sender: TObject);
begin
{$ifdef mswindows}
  if ScopeConnected then
  begin
    try
      T.Tracking := not T.Tracking;
      UpdTrackingButton;
    except
      on E: EOleException do
        MessageDlg(rsError + ': ' + E.Message, mtWarning, [mbOK], 0);
    end;
  end;
{$endif}
end;

procedure Tpop_scope.ButtonAboutClick(Sender: TObject);
{$ifdef mswindows}
var
  buf: string;
{$endif}
begin
{$ifdef mswindows}
  try
    if (edit1.Text > '') then
    begin
      try
        if VarIsEmpty(T) then
        begin
          T := CreateOleObject(WideString(edit1.Text));
          buf := T.Description;
          buf := buf + crlf + T.DriverInfo;
          T := Unassigned;
          ShowMessage(buf);
        end
        else
        begin
          buf := T.Description;
          buf := buf + crlf + T.DriverInfo;
          ShowMessage(buf);
        end;
        UpdTrackingButton;
      except
      end;
    end;
  except
    on E: EOleException do
      MessageDlg(rsError + ': ' + E.Message, mtWarning, [mbOK], 0);
  end;
{$endif}
end;

initialization
{$ifdef mswindows}
{$if defined(cpui386) or defined(cpux86_64)}
// some Ascom driver raise this exceptions
SetExceptionMask([exInvalidOp, exDenormalized, exZeroDivide,exOverflow, exUnderflow, exPrecision]);
{$endif}
{$endif}

end.
