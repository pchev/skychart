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
Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.

-------------------------------------------------------------------------------}

interface

uses
  u_help, u_translation, indibaseclient, indibasedevice, indiapi, indicom, pu_indigui,
  LCLIntf, u_util, u_constant, Messages, SysUtils, Classes, Graphics,
  Controls, UScaleDPI,
  Forms, Dialogs, StdCtrls, Buttons, inifiles, process, ComCtrls, Menus,
  ExtCtrls;

type

  { Tpop_indi }

  Tpop_indi = class(TForm)
    BtnIndiGui: TButton;
    ButtonGetLocation: TSpeedButton;
    ButtonSetLocation: TSpeedButton;
    Elev: TEdit;
    GroupBox5: TGroupBox;
    Label1: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    lat: TEdit;
    long: TEdit;
    ProtocolTrace: TCheckBox;
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
    InitTimer: TTimer;
    ConnectTimer: TTimer;
    {Utility and form functions}
    procedure BtnIndiGuiClick(Sender: TObject);
    procedure ButtonGetLocationClick(Sender: TObject);
    procedure ButtonSetLocationClick(Sender: TObject);
    procedure ConnectTimerTimer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure InitTimerTimer(Sender: TObject);
    procedure kill(Sender: TObject; var CanClose: boolean);
    procedure ConnectClick(Sender: TObject);
    procedure ProtocolTraceChange(Sender: TObject);
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
    coord_ra: INumber;
    coord_dec: INumber;
    oncoordset_prop: ISwitchVectorProperty;
    setslew_prop: ISwitch;
    settrack_prop: ISwitch;
    setsync_prop: ISwitch;
    abortmotion_prop: ISwitchVectorProperty;
    abort_prop: ISwitch;
    GeographicCoord_prop: INumberVectorProperty;
    geo_lat: INumber;
    geo_lon: INumber;
    geo_elev: INumber;
    SlewRate_prop: ISwitchVectorProperty;
    moveNS_prop: ISwitchVectorProperty;
    moveN_prop: ISwitch;
    moveS_prop: ISwitch;
    moveEW_prop: ISwitchVectorProperty;
    moveE_prop: ISwitch;
    moveW_prop: ISwitch;
    eod_coord: boolean;
    ready, connected: boolean;
    SlewRateList: TStringList;
    FLongitude: double;                 // Observatory longitude (Positive East of Greenwich}
    FLatitude: double;                  // Observatory latitude
    FElevation: double;                 // Observatory elevation
    FObservatoryCoord: TNotifyEvent;
    procedure ClearStatus;
    procedure CheckStatus;
    procedure NewDevice(dp: Basedevice);
    procedure NewMessage(mp: IMessage);
    procedure NewProperty(indiProp: IndiProperty);
    procedure NewNumber(nvp: INumberVectorProperty);
    procedure NewText(tvp: ITextVectorProperty);
    procedure NewSwitch(svp: ISwitchVectorProperty);
    procedure NewLight(lvp: ILightVectorProperty);
    procedure DeleteDevice(dp: Basedevice);
    procedure DeleteProperty(indiProp: IndiProperty);
    procedure ServerConnected(Sender: TObject);
    procedure ServerDisconnected(Sender: TObject);
    procedure IndiGUIdestroy(Sender: TObject);
  public
    { Public declarations }
    csc: Tconf_skychart;
    procedure SetLang;
    function ReadConfig(ConfigPath: shortstring): boolean;
    procedure SetRefreshRate(rate: integer);
    procedure ScopeShow;
    procedure ScopeShowModal(var ok: boolean);
    procedure ScopeConnect(var ok: boolean);
    procedure ScopeDisconnect(var ok: boolean; updstatus: boolean = True);
    procedure ScopeGetInfo(var scName: shortstring;
      var QueryOK, SyncOK, GotoOK: boolean; var refreshrate: integer);
    procedure ScopeGetEqSys(var EqSys: double);
    procedure ScopeSetObs(la, lo, el: double);
    procedure ScopeAlign(Source: string; ra, Dec: single);
    procedure ScopeGetRaDec(var ra, de: double; var ok: boolean);
    procedure ScopeGetAltAz(var alt, az: double; var ok: boolean);
    procedure ScopeGoto(ra, de: single; var ok: boolean);
    procedure ScopeAbortSlew;
    procedure ScopeReset;
    function ScopeInitialized: boolean;
    function ScopeConnected: boolean;
    procedure ScopeClose;
    procedure ScopeReadConfig(ConfigPath: shortstring);
    procedure GetScopeRates(var nrates: integer; var srate: TStringList);
    procedure ScopeMoveAxis(axis: integer; rate: string);
    property Longitude: double read FLongitude;
    property Latitude: double read FLatitude;
    property Elevation: double read FElevation;
    property onObservatoryCoord: TNotifyEvent read FObservatoryCoord write FObservatoryCoord;
  end;

implementation

{$R *.lfm}

procedure Tpop_indi.SetRefreshRate(rate: integer);
begin
  // nothing to do as INDI is event driven
end;

procedure Tpop_indi.ClearStatus;
begin
  coord_prop := nil;
  abortmotion_prop := nil;
  SlewRate_prop := nil;
  moveNS_prop := nil;
  moveEW_prop := nil;
  oncoordset_prop := nil;
  GeographicCoord_prop := nil;
  TelescopeDevice := nil;
  scope_port := nil;
  ready := False;
  connected := False;
  eod_coord := True;
  led.color := clRed;
  SlewRateList.Clear;
end;

procedure Tpop_indi.CheckStatus;
begin
  if connected and (coord_prop <> nil) and (oncoordset_prop <> nil) then
  begin
    ready := True;
    led.color := clLime;
  end;
end;


procedure Tpop_indi.ServerConnected(Sender: TObject);
begin
  Memomsg.Lines.Add('Server connected');
  ConnectTimer.Enabled := True;
end;

procedure Tpop_indi.ConnectTimerTimer(Sender: TObject);
begin
  ConnectTimer.Enabled := False;
  client.connectDevice(csc.IndiDevice);
end;


procedure Tpop_indi.ServerDisconnected(Sender: TObject);
begin
  ConnectTimer.Enabled := False;
  if InitTimer.Enabled then
  begin
    if csc.IndiAutostart then
    begin
      InitTimer.Enabled := False;
      ExecNoWait('nohup indistarter');
    end
    else
    begin
      Memomsg.Lines.Add('Server disconnected');
    end;
  end
  else
  begin
    Memomsg.Lines.Add('Server disconnected');
  end;
  ClearStatus;
  led.color := clRed;
end;

procedure Tpop_indi.NewDevice(dp: Basedevice);
begin
  //  Memomsg.Lines.Add('Newdev: '+dp.getDeviceName);
  if dp.getDeviceName = csc.IndiDevice then
  begin
    connected := True;
    TelescopeDevice := dp;
  end;
end;

procedure Tpop_indi.DeleteDevice(dp: Basedevice);
var
  ok: boolean;
begin
  if dp.getDeviceName = csc.indidevice then
  begin
    ScopeDisconnect(ok);
  end;
end;

procedure Tpop_indi.DeleteProperty(indiProp: IndiProperty);
begin
  { TODO :  check if a vital property is removed ? }
end;

procedure Tpop_indi.NewMessage(mp: IMessage);
begin
  if Memomsg.Lines.Count > 40 then
    Memomsg.Lines.Delete(0);
  Memomsg.Lines.Add(mp.msg);
  mp.Free;
end;

procedure Tpop_indi.NewProperty(indiProp: IndiProperty);
var
  propname: string;
  proptype: INDI_TYPE;
  i: integer;
begin
  //  Memomsg.Lines.Add('Newprop: '+indiProp.getDeviceName+' '+indiProp.getName+' '+indiProp.getLabel);
  propname := indiProp.getName;
  proptype := indiProp.getType;

  if (proptype = INDI_TEXT) and (propname = 'DEVICE_PORT') then
  begin
    scope_port := indiProp.getText;
  end
  else if (proptype = INDI_NUMBER) and (propname = 'EQUATORIAL_EOD_COORD') then
  begin
    coord_prop := indiProp.getNumber;
    coord_ra := IUFindNumber(coord_prop, 'RA');
    coord_dec := IUFindNumber(coord_prop, 'DEC');
    eod_coord := True;
    NewNumber(coord_prop);
  end
  else if (proptype = INDI_NUMBER) and (coord_prop = nil) and (propname = 'EQUATORIAL_COORD') then
  begin
    coord_prop := indiProp.getNumber;
    coord_ra := IUFindNumber(coord_prop, 'RA');
    coord_dec := IUFindNumber(coord_prop, 'DEC');
    eod_coord := False;
    NewNumber(coord_prop);
  end
  else if (proptype = INDI_SWITCH) and (propname = 'ON_COORD_SET') then
  begin
    oncoordset_prop := indiProp.getSwitch;
    setslew_prop := IUFindSwitch(oncoordset_prop, 'SLEW');
    settrack_prop := IUFindSwitch(oncoordset_prop, 'TRACK');
    setsync_prop := IUFindSwitch(oncoordset_prop, 'SYNC');
  end
  else if (proptype = INDI_SWITCH) and (propname = 'TELESCOPE_ABORT_MOTION') then
  begin
    abortmotion_prop := indiProp.getSwitch;
    abort_prop := IUFindSwitch(abortmotion_prop, 'ABORT');
    if abort_prop = nil then
      abort_prop := IUFindSwitch(abortmotion_prop, 'ABORT_MOTION');
  end
  else if (proptype = INDI_NUMBER) and (propname = 'GEOGRAPHIC_COORD') then
  begin
    GeographicCoord_prop := indiProp.getNumber();
    geo_lat := IUFindNumber(GeographicCoord_prop, 'LAT');
    geo_lon := IUFindNumber(GeographicCoord_prop, 'LONG');
    geo_elev := IUFindNumber(GeographicCoord_prop, 'ELEV');
  end
  else if (proptype = INDI_SWITCH) and ((propname = 'TELESCOPE_SLEW_RATE') or
    (propname = 'SLEWMODE')) then
  begin
    SlewRateList.Clear;
    SlewRate_prop := indiProp.getSwitch;
    for i := 0 to SlewRate_prop.nsp - 1 do
    begin
      SlewRateList.Add(SlewRate_prop.sp[i].Name);
    end;
  end
  else if (proptype = INDI_SWITCH) and (propname = 'TELESCOPE_MOTION_NS') then
  begin
    moveNS_prop := indiProp.getSwitch;
    moveN_prop := IUFindSwitch(moveNS_prop, 'MOTION_NORTH');
    moveS_prop := IUFindSwitch(moveNS_prop, 'MOTION_SOUTH');
  end
  else if (proptype = INDI_SWITCH) and (propname = 'TELESCOPE_MOTION_WE') then
  begin
    moveEW_prop := indiProp.getSwitch;
    moveE_prop := IUFindSwitch(moveEW_prop, 'MOTION_EAST');
    moveW_prop := IUFindSwitch(moveEW_prop, 'MOTION_WEST');
  end
  else if (proptype = INDI_SWITCH) and (propname = 'CONNECTION') then
  begin

  end;
  CheckStatus;
end;

procedure Tpop_indi.NewNumber(nvp: INumberVectorProperty);
begin
  //  Memomsg.Lines.Add('NewNumber: '+nvp.name+' '+FloatToStr(nvp.np[0].value));
  if nvp = coord_prop then
  begin
    pos_x.Text := artostr(coord_ra.Value);
    pos_y.Text := detostr(coord_dec.Value);
  end;
end;

procedure Tpop_indi.NewText(tvp: ITextVectorProperty);
begin
  //  Memomsg.Lines.Add('NewText: '+tvp.name+' '+tvp.tp[0].text);
end;

procedure Tpop_indi.NewSwitch(svp: ISwitchVectorProperty);
var
  propname: string;
  sw: ISwitch;
  ok: boolean;
begin
  //  writeln('NewSwitch: '+svp.name);
  propname := svp.Name;
  if (propname = 'CONNECTION') then
  begin
    sw := IUFindOnSwitch(svp);
    if (sw <> nil) and (sw.Name = 'DISCONNECT') then
    begin
      ScopeDisconnect(ok);
    end;
  end;
end;

procedure Tpop_indi.NewLight(lvp: ILightVectorProperty);
begin
  //  Memomsg.Lines.Add('NewLight: '+lvp.name);
end;

procedure Tpop_indi.ScopeDisconnect(var ok: boolean; updstatus: boolean = True);
begin
  InitTimer.Enabled := False;
  pos_x.Text := '';
  pos_y.Text := '';
  if (client <> nil) then
  begin
    client.Terminate;
  end;
  ClearStatus;
  ok := True;
end;

procedure Tpop_indi.ScopeConnect(var ok: boolean);
begin
  if not connected then
  begin
    led.color := clRed;
    Memomsg.Clear;
    led.refresh;
    if (client = nil) or (client.Terminated) or (not client.Connected) then
    begin
      client := TIndiBaseClient.Create;
      client.onNewDevice := @NewDevice;
      client.onNewMessage := @NewMessage;
      client.onNewProperty := @NewProperty;
      client.onNewNumber := @NewNumber;
      client.onNewText := @NewText;
      client.onNewSwitch := @NewSwitch;
      client.onNewLight := @NewLight;
      client.onDeleteDevice := @DeleteDevice;
      client.onDeleteProperty := @DeleteProperty;
      client.onServerConnected := @ServerConnected;
      client.onServerDisconnected := @ServerDisconnected;
    end
    else
    begin
      Memomsg.Lines.Add('Already connected');
      exit;
    end;

    client.ProtocolTraceFile := slash(HomeDir) + 'cdc_inditrace.log';
    client.ProtocolErrorFile := slash(HomeDir) + 'cdc_indierror.log';
    client.ProtocolTrace := ProtocolTrace.Checked;
    if client.ProtocolTrace then
      Memomsg.Lines.Add('Trace started to file: ' + client.ProtocolTraceFile);

    client.SetServer(csc.IndiServerHost, csc.IndiServerPort);
    client.watchDevice(csc.IndiDevice);
    client.ConnectServer;
    led.color := clYellow;
    InitTimer.Enabled := True;
    ok := True;
  end
  else
    Memomsg.Lines.Add('Already connected');
end;


procedure Tpop_indi.ScopeClose;
begin
  Release;
end;

function Tpop_indi.ScopeConnected: boolean;
begin
  Result := connected;
end;

function Tpop_indi.ScopeInitialized: boolean;
begin
  Result := connected;
end;

procedure Tpop_indi.ScopeShowModal(var ok: boolean);
begin
  showmodal;
  ok := (modalresult = mrOk);
end;

procedure Tpop_indi.ScopeGetRaDec(var ra, de: double; var ok: boolean);
begin
  if ScopeConnected and (coord_prop <> nil) then
  begin
    ra := coord_ra.Value;
    de := coord_dec.Value;
    ok := True;
  end
  else
    ok := False;
end;

procedure Tpop_indi.ScopeGetAltAz(var alt, az: double; var ok: boolean);
begin
  ok := False;
end;

procedure Tpop_indi.ScopeGetInfo(var scName: shortstring;
  var QueryOK, SyncOK, GotoOK: boolean; var refreshrate: integer);
begin
  if ScopeConnected and ready then
  begin
    scname := TelescopeDevice.getDeviceName;
    QueryOK := (coord_prop <> nil);
    SyncOK := (coord_prop <> nil) and (oncoordset_prop <> nil) and (setsync_prop <> nil);
    GotoOK := (coord_prop <> nil) and (oncoordset_prop <> nil) and (setslew_prop <> nil);
  end
  else
  begin
    scname := '';
    QueryOK := False;
    SyncOK := False;
    GotoOK := False;
  end;
  refreshrate := 1;
end;

procedure Tpop_indi.ScopeGetEqSys(var EqSys: double);
begin
  if ScopeConnected and ready then
  begin
    if eod_coord then
      EqSys := 0
    else
      EqSys := 2000;
  end;
end;

procedure Tpop_indi.ScopeReset;
begin
end;

procedure Tpop_indi.ScopeSetObs(la, lo, el: double);
begin
  Flatitude := la;
  Flongitude := lo;
  FElevation := el;
  lat.Text := detostr(Flatitude);
  long.Text := detostr(Flongitude);
  Elev.Text := FormatFloat(f1,FElevation);
end;

procedure Tpop_indi.ScopeAlign(Source: string; ra, Dec: single);
begin
  if ready then
  begin
    if (oncoordset_prop <> nil) and (setsync_prop <> nil) then
    begin
      IUResetSwitch(oncoordset_prop);
      setsync_prop.s := ISS_ON;
      client.sendNewSwitch(oncoordset_prop);
      coord_ra.Value := ra;
      coord_dec.Value := Dec;
      client.sendNewNumber(coord_prop);
    end
    else
      Memomsg.Lines.Add('SYNC ' + rsNotAvailable);
  end;
end;

procedure Tpop_indi.ScopeGoto(ra, de: single; var ok: boolean);
begin
  if ready then
  begin
    if (oncoordset_prop <> nil) and (settrack_prop <> nil) then
    begin
      IUResetSwitch(oncoordset_prop);
      settrack_prop.s := ISS_ON;
      client.sendNewSwitch(oncoordset_prop);
      coord_ra.Value := ra;
      coord_dec.Value := de;
      client.sendNewNumber(coord_prop);
    end
    else
      Memomsg.Lines.Add('GOTO ' + rsNotAvailable);
  end;
end;

procedure Tpop_indi.ScopeReadConfig(ConfigPath: shortstring);
begin
  ReadConfig(ConfigPath);
end;

procedure Tpop_indi.ScopeAbortSlew;
begin
  if (abortmotion_prop <> nil) then
  begin
    IUResetSwitch(abortmotion_prop);
    abort_prop.s := ISS_ON;
    client.sendNewSwitch(abortmotion_prop);
  end;
end;

procedure Tpop_indi.GetScopeRates(var nrates: integer; var srate: TStringList);
begin
  srate.Clear;
  if SlewRate_prop <> nil then
  begin
    srate.Assign(SlewRateList);
  end;
  if srate.Count = 0 then
    srate.Add('N/A');
  nrates := srate.Count;
end;

procedure Tpop_indi.ScopeMoveAxis(axis: integer; rate: string);
var
  positive: boolean;
  sw: ISwitch;
begin
  if (moveNS_prop <> nil) and (moveEW_prop <> nil) then
  begin
    if rate = '0' then
    begin
      case axis of
        0:
        begin  //  alpha
          IUResetSwitch(moveEW_prop);
          client.sendNewSwitch(moveEW_prop);
        end;
        1:
        begin  // delta
          IUResetSwitch(moveNS_prop);
          client.sendNewSwitch(moveNS_prop);
        end;
      end;
    end
    else
    begin
      positive := (copy(rate, 1, 1) <> '-');
      if not positive then
        Delete(rate, 1, 1);
      if SlewRate_prop <> nil then
      begin
        if pos('N/A', rate) = 0 then
        begin
          sw := IUFindSwitch(SlewRate_prop, rate);
          if sw <> nil then
          begin
            IUResetSwitch(SlewRate_prop);
            sw.s := ISS_ON;
            client.sendNewSwitch(SlewRate_prop);
          end;
        end;
      end;
      case axis of
        0:
        begin  //  alpha
          IUResetSwitch(moveEW_prop);
          if positive then
            moveW_prop.s := ISS_ON
          else
            moveE_prop.s := ISS_ON;
          client.sendNewSwitch(moveEW_prop);
        end;
        1:
        begin  // delta
          IUResetSwitch(moveNS_prop);
          if positive then
            moveN_prop.s := ISS_ON
          else
            moveS_prop.s := ISS_ON;
          client.sendNewSwitch(moveNS_prop);
        end;
      end;
    end;
  end;
end;

procedure Tpop_indi.ButtonGetLocationClick(Sender: TObject);
begin
  if ready then
  begin
    if (GeographicCoord_prop <> nil) and (geo_lon <> nil) and (geo_lat <> nil) then
    begin
      FLongitude := geo_lon.Value;
      FLatitude  := geo_lat.Value;
      FElevation := geo_elev.Value;
      lat.Text := detostr(Flatitude);
      long.Text := detostr(Flongitude);
      Elev.Text := FormatFloat(f1,FElevation);
      if assigned(FObservatoryCoord) then
        FObservatoryCoord(self);
    end
    else
      Memomsg.Lines.Add('Geographic Coord ' + rsNotAvailable);
  end;
end;

procedure Tpop_indi.ButtonSetLocationClick(Sender: TObject);
begin
  if ready then
  begin
    if (GeographicCoord_prop <> nil) and (geo_lon <> nil) and (geo_lat <> nil) and (geo_elev <> nil) then
    begin
      geo_lon.Value := FLongitude;
      geo_lat.Value := FLatitude;
      geo_elev.Value := FElevation;
      client.sendNewNumber(GeographicCoord_prop);
    end
    else
      Memomsg.Lines.Add('Geographic Coord ' + rsNotAvailable);
  end;
end;


{-------------------------------------------------------------------------------

                       Form functions

--------------------------------------------------------------------------------}

procedure Tpop_indi.SetLang;
begin
  Caption := rsINDIDriver;
  GroupBox1.Caption := rsCurrentDrive;
  Connect.Caption := rsConnect;
  Disconnect.Caption := rsDisconnect;
  SpeedButton6.Caption := rsAbortSlew;
  SpeedButton2.Caption := rsHide;
  SpeedButton4.Caption := rsHelp;
  SetHelp(self, hlpINDI);
end;

function Tpop_indi.ReadConfig(ConfigPath: shortstring): boolean;
begin
  // config managed in main program
  Result := True;
end;

procedure Tpop_indi.ScopeShow;
begin
  Edit1.Caption := csc.IndiDevice;
  ActiveControl := Connect;
  Show;
end;

procedure Tpop_indi.kill(Sender: TObject; var CanClose: boolean);
begin
  Saveconfig;
  if ScopeConnected then
  begin
    canclose := False;
    hide;
  end;
end;

procedure Tpop_indi.FormCreate(Sender: TObject);
begin
  ScaleDPI(Self);
  SlewRateList := TStringList.Create;
  ClearStatus;
end;

procedure Tpop_indi.BtnIndiGuiClick(Sender: TObject);
begin
  if not IndiGUIready then
  begin
    f_indigui := Tf_indigui.Create(self);
    f_indigui.onDestroy := @IndiGUIdestroy;
    f_indigui.IndiServer := csc.IndiServerHost;
    f_indigui.IndiPort := csc.IndiServerPort;
    f_indigui.IndiDevice := '';
    IndiGUIready := True;
  end;
  f_indigui.Show;
end;

procedure Tpop_indi.IndiGUIdestroy(Sender: TObject);
begin
  IndiGUIready := False;
end;

procedure Tpop_indi.InitTimerTimer(Sender: TObject);
var
  ok: boolean;
begin
  InitTimer.Enabled := False;
  if TelescopeDevice = nil then
  begin
    ScopeDisconnect(ok);
    if csc.IndiAutostart then
    begin
      ExecNoWait('nohup indistarter');
    end
    else
    begin
      Memomsg.Lines.Add('No response from server');
      Memomsg.Lines.Add('Is driver"' + csc.IndiDevice + '" running?');
    end;
  end;
end;

procedure Tpop_indi.ConnectClick(Sender: TObject);
var
  ok: boolean;
begin
  ScopeConnect(ok);
end;

procedure Tpop_indi.ProtocolTraceChange(Sender: TObject);
begin
  if (client <> nil) and ScopeConnected then
  begin
    if (ProtocolTrace.Checked <> client.ProtocolTrace) then
      Memomsg.Lines.Add('Cannot change protocol trace when the telescope is connected');
    ProtocolTrace.Checked := client.ProtocolTrace;
  end
  else
  begin
    if ProtocolTrace.Checked then
      Memomsg.Lines.Add('Warning! the trace file can be very big.');
  end;
end;

procedure Tpop_indi.SaveConfig;
begin
  // config managed in main program
end;

procedure Tpop_indi.DisconnectClick(Sender: TObject);
var
  ok: boolean;
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
  if ScopeConnected then
    ScopeAbortSlew;
end;

procedure Tpop_indi.FormDestroy(Sender: TObject);
begin
  SaveConfig;
  SlewRateList.Free;
end;

end.
