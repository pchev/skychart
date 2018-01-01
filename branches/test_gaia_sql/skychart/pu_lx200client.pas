unit pu_lx200client;

{$MODE Objfpc}{$H+}

{
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
}

{------------- interface for LX200 system. ----------------------------
Contribution from :
PJ Pallez Nov 1999
Patrick Chevalley Oct 2000
Renato Bonomini Jul 2004
Lazarus version, Patrick Chevalley Jun 2011
Tomas Mandys Apr 2013

will work with all systems using same protocol
(LX200,AutoStar,..)

-------------------------------------------------------------------------------}

interface

uses
  u_help, u_translation, UScaleDPI,
  Messages, SysUtils, Classes, Graphics, Controls,
  Forms, Dialogs, u_constant, u_util,
  StdCtrls, Buttons, inifiles, ComCtrls, Menus, ExtCtrls,
  enhedits;

type

  { Tpop_lx200 }

  Tpop_lx200 = class(TForm)
    ipaddr: TEdit;
    tcpport: TEdit;
    tcptimeout: TEdit;
    GroupBox9: TGroupBox;
    Label22: TLabel;
    Label23: TLabel;
    Label24: TLabel;
    RadioGroup6: TRadioGroup;
    UTCBox: TCheckBox;
    PageControl1: TPageControl;
    SpeedButton8: TSpeedButton;
    TabSheet1: TTabSheet;
    Panel1: TPanel;
    LabelAlpha: TLabel;
    LabelDelta: TLabel;
    pos_x: TEdit;
    pos_y: TEdit;
    GroupBox1: TGroupBox;
    TabSheet2: TTabSheet;
    GroupBox3: TGroupBox;
    led: TEdit;
    SpeedButton1: TSpeedButton;
    SaveButton1: TButton;
    TabSheet3: TTabSheet;
    GroupBox4: TGroupBox;
    Label5: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    PortSpeedbox: TComboBox;
    cbo_port: TComboBox;
    Paritybox: TComboBox;
    DatabitBox: TComboBox;
    StopbitBox: TComboBox;
    Label13: TLabel;
    TimeOutBox: TComboBox;
    Button2: TButton;
    GroupBox5: TGroupBox;
    Label15: TLabel;
    Label16: TLabel;
    lat: TEdit;
    long: TEdit;
    Panel2: TPanel;
    Label17: TLabel;
    SpeedButton2: TSpeedButton;
    SpeedButton5: TSpeedButton;
    GroupBox2: TGroupBox;
    cbo_type: TComboBox;
    Label1: TLabel;
    ReadIntBox: TComboBox;
    Label2: TLabel;
    TopBtn: TSpeedButton;
    LeftBtn: TSpeedButton;
    RightBtn: TSpeedButton;
    BotBtn: TSpeedButton;
    StopBtn: TSpeedButton;
    RadioGroup1: TRadioGroup;
    Shape1: TShape;
    Label3: TLabel;
    Label4: TLabel;
    Label6: TLabel;
    Label14: TLabel;
    RadioGroup2: TRadioGroup;
    GroupBox7: TGroupBox;
    CheckBox1: TCheckBox;
    Button3: TButton;
    HPP: TEdit;
    GroupBox6: TGroupBox;
    SpeedButton3: TSpeedButton;
    Label11: TLabel;
    az_x: TEdit;
    Label12: TLabel;
    alt_y: TEdit;
    ShowAltAz: TCheckBox;
    CheckBox2: TCheckBox;
    GroupBox8: TGroupBox;
    CheckBox3: TCheckBox;
    CheckBox4: TCheckBox;
    IntTimeOutBox: TComboBox;
    Label18: TLabel;
    CheckBox5: TCheckBox;
    Focus: TTabSheet;
    SpeedButton6: TSpeedButton;
    SpeedButton7: TSpeedButton;
    RadioGroup3: TRadioGroup;
    RadioGroup4: TRadioGroup;
    RadioGroup5: TRadioGroup;
    CheckBox6: TCheckBox;
    LongEdit1: TLongEdit;
    Label19: TLabel;
    Label20: TLabel;
    Bevel1: TBevel;
    Button1: TButton;
    SpeedButton4: TSpeedButton;
    SpeedButton9: TSpeedButton;
    ProductInfoBox: TGroupbox;
    QueryFirmwareButton: TButton;
    VirtHP: TTabSheet;
    LeftModeButton: TButton;
    RightModeButton: TButton;
    VHPTitleLabel: TLabel;
    LRModeGroup: TGroupBox;
    HandPadModeSelection: TRadioGroup;
    Adv: TTabSheet;
    ADVTitleLabel: TLabel;
    ScopeSpeeds: TGroupBox;
    MsArcSec: TLongEdit;
    GuideArcSec: TLongEdit;
    GetMsArcSec: TButton;
    GetGuideArcSec: TButton;
    SetMsArcSec: TButton;
    SetGuideArcSec: TButton;
    MsArcSecLabel: TLabel;
    GuideArcSecLabel: TLabel;
    FieldRotation: TCheckBox;
    ScopeInit: TGroupBox;
    ScopeInit1: TButton;
    ScopeInit2: TButton;
    ScopeInit3: TButton;
    VirtHpHelp: TButton;
    AdvHelp: TButton;
    FieldRotationGroup: TGroupBox;
    FRQuery: TButton;
    FRLabel: TLabel;
    FRAngle: TFloatEdit;
    MotorTab: TTabSheet;
    TrackingGroup: TGroupBox;
    TrackingDefaultButton: TButton;
    TrackingLunarButton: TButton;
    TrackingCustomButton: TButton;
    TrackingGetButton: TButton;
    TrackingRateLabel: TLabel;
    TrackingDecreaseLabel: TLabel;
    TrackingIncreaseLabel: TLabel;
    TrackingRateEdit: TFloatEdit;
    TrackingSetRateButton: TButton;
    LxPecToggle: TButton;
    TrackingRateDecrease: TButton;
    TrackingRateIncrease: TButton;
    Lx200GPSMotorSpeeds: TGroupBox;
    LabelGuideSpeed: TLabel;
    LxGuideRate: TFloatEdit;
    LxGuideRateSet: TBitBtn;
    LabelRaAzSpeed: TLabel;
    RASlewRate: TFloatEdit;
    RASlewRateSet: TBitBtn;
    LabelDecSlewRate: TLabel;
    DECSlewRate: TFloatEdit;
    DECSlewRateSet: TBitBtn;
    LX200GPSRate: TCheckBox;
    PEC: TTabSheet;
    RAPEC: TGroupBox;
    DECPEC: TGroupBox;
    RAPECOn: TButton;
    RAPECOff: TButton;
    DECPECOn: TButton;
    DECPECOff: TButton;
    FanControl: TCheckBox;
    SlewSpeedBar: TTrackBar;
    SlewSpeedGroup: TGroupBox;
    LabelSetSlewSpeed: TLabel;
    Timer1: TTimer;
    EqSys1: TComboBox;
    Label21: TLabel;
    {Utility and form functions}
    procedure FormCreate(Sender: TObject);
    procedure kill(Sender: TObject; var CanClose: boolean);
    procedure RadioGroup6Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure setresClick(Sender: TObject);
    function str2ra(s: string): double;
    function str2dec(s: string): double;
    procedure SaveButton1Click(Sender: TObject);
    procedure ReadIntBoxChange(Sender: TObject);
    procedure latChange(Sender: TObject);
    procedure longChange(Sender: TObject);
    procedure SpeedButton5Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure TopBtnMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: integer);
    procedure TopBtnMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: integer);
    procedure BotBtnMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: integer);
    procedure LeftBtnMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: integer);
    procedure RightBtnMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: integer);
    procedure StopBtnMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: integer);
    procedure RadioGroup2Click(Sender: TObject);
    procedure RightBtnMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: integer);
    procedure BotBtnMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: integer);
    procedure LeftBtnMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: integer);
    procedure cbo_typeChange(Sender: TObject);
    procedure CheckBox1Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure CheckBox2Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure CheckBox3Click(Sender: TObject);
    procedure CheckBox4Click(Sender: TObject);
    procedure CheckBox5Click(Sender: TObject);
    procedure SpeedButton4Click(Sender: TObject);
    procedure RadioGroup5Click(Sender: TObject);
    procedure SpeedButton6MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: integer);
    procedure SpeedButton6MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: integer);
    procedure SpeedButton7MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: integer);
    procedure CheckBox6Click(Sender: TObject);
    procedure SpeedButton8Click(Sender: TObject);
    procedure SpeedButton9Click(Sender: TObject);
    procedure VHpLeftClick(Sender: TObject);
    procedure VHRightClick(Sender: TObject);
    procedure QueryFirmwareButtonClick(Sender: TObject);
    procedure HandPadModeSelectionClick(Sender: TObject);
    procedure GetMsArcSecClick(Sender: TObject);
    procedure GetGuideArcSecClick(Sender: TObject);
    procedure PecToggleClick(Sender: TObject);
    procedure ScopeFieldRotationClick(Sender: TObject);
    procedure SetGuideArcSecClick(Sender: TObject);
    procedure SetMsArcSecClick(Sender: TObject);
    procedure ScopeInit1Click(Sender: TObject);
    procedure ScopeInit2Click(Sender: TObject);
    procedure ScopeInit3Click(Sender: TObject);
    procedure AdvHelpClick(Sender: TObject);
    procedure VirtHpHelpClick(Sender: TObject);
    procedure FRQueryClick(Sender: TObject);
    procedure TrackingDefaultButtonClick(Sender: TObject);
    procedure TrackingLunarButtonClick(Sender: TObject);
    procedure TrackingCustomButtonClick(Sender: TObject);
    procedure TrackingRateChangerClick(Sender: TObject; Button: TUDBtnType);
    procedure TrackingSetRateButtonClick(Sender: TObject);
    procedure TrackingGetButtonClick(Sender: TObject);
    procedure TrackingRateDecreaseClick(Sender: TObject);
    procedure TrackingRateIncreaseClick(Sender: TObject);
    procedure LX200GPSRateClick(Sender: TObject);
    procedure LxGuideRateSetClick(Sender: TObject);
    procedure RASlewRateSetClick(Sender: TObject);
    procedure DECSlewRateSetClick(Sender: TObject);
    procedure FanControlClick(Sender: TObject);
    procedure SlewSpeedBarChange(Sender: TObject);
  private
    { Private declarations }
    FConfig: string;
    CoordLock: boolean;
    Initial: boolean;
  public
    { Public declarations }
    csc: Tconf_skychart;
    {Current values}
    curdeg_x, curdeg_y: double;        // current equatorial position in degrees
    cur_az, cur_alt: double;           // current alt-az position in degrees
    Sideral_Time: double;              // Current sideral time
    Longitude: double;
    // Observatory longitude (Negative East of Greenwich}
    Latitude: double;                  // Observatory latitude
    Timezone: double;                  // Observatory timezone
    procedure SetLang;
    function ReadConfig(ConfigPath: shortstring): boolean;
    procedure SetRefreshRate(rate: integer);
    procedure ShowCoordinates;
    procedure ChangeButton(onoff: boolean);
    procedure ScopeChangeButton(onoff: boolean);
    procedure ScopeShow;
    procedure ScopeShowModal(var ok: boolean);
    procedure ScopeConnect(var ok: boolean);
    procedure ScopeDisconnect(var ok: boolean);
    procedure ScopeGetInfo(var Nam: shortstring; var QueryOK, SyncOK, GotoOK: boolean;
      var refreshrate: integer);
    procedure ScopeSetObs(la, lo, tz: double);
    procedure ScopeAlign(Source: string; ra, Dec: double);
    procedure ScopeGetRaDec(var ar, de: double; var ok: boolean);
    procedure ScopeGetAltAz(var alt, az: double; var ok: boolean);
    procedure ScopeGoto(ar, de: double; var ok: boolean);
    procedure ScopeAbortSlew;
    procedure ScopeReset;
    function ScopeInitialized: boolean;
    function ScopeConnected: boolean;
    procedure ScopeClose;
    procedure ScopeGetEqSys(var EqSys: double);
    procedure ScopeReadConfig(ConfigPath: shortstring);
    procedure GetScopeRates(var nrates: integer; var srate: TStringList);
    procedure ScopeMoveAxis(axis: integer; rate: string);
  end;

implementation

{$R *.lfm}
uses
  cu_lx200protocol,
  cu_serial;

{-------------------------------------------------------------------------------

                       Cartes du Ciel Dll functions

--------------------------------------------------------------------------------}

procedure Tpop_lx200.SetRefreshRate(rate: integer);
begin
  Timer1.Interval := rate;
  ReadIntBox.Text := IntToStr(rate);
end;

procedure Tpop_lx200.ShowCoordinates;
var
  s1, s2, s3: string;
begin
  if ScopeInitialized then
  begin
    LX200_QueryEQ(Curdeg_x, Curdeg_y);
    if ShowAltAz.Checked then
      LX200_QueryAz(Cur_az, Cur_alt);
    case RadioGroup2.ItemIndex of
      0:
      begin
        pos_x.Text := armtostr(Curdeg_x / 15, s1, s2);
        pos_y.Text := demtostr(Curdeg_y, s1, s2);
        if ShowAltAz.Checked then
        begin
          az_x.Text := demtostr(Cur_az, s1, s2);
          alt_y.Text := demtostr(Cur_alt, s1, s2);
        end
        else
        begin
          az_x.Text := '';
          alt_y.Text := '';
        end;
      end;
      1:
      begin
        pos_x.Text := artostr(Curdeg_x / 15, s1, s2, s3);
        pos_y.Text := detostr(Curdeg_y, s1, s2, s3);
        if ShowAltAz.Checked then
        begin
          az_x.Text := detostr(Cur_az, s1, s2, s3);
          alt_y.Text := detostr(Cur_alt, s1, s2, s3);
        end
        else
        begin
          az_x.Text := '';
          alt_y.Text := '';
        end;
      end;
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
end;

procedure Tpop_lx200.ChangeButton(onoff: boolean);
begin
  CheckBox1.Enabled := onoff;
  Button3.Enabled := onoff;
  SpeedButton3.Enabled := onoff;
  RadioGroup1.Enabled := onoff;
  LeftBtn.Enabled := onoff;
  TopBtn.Enabled := onoff;
  RightBtn.Enabled := onoff;
  BotBtn.Enabled := onoff;
  StopBtn.Enabled := onoff;
  // RB: Lx200 16"GPS and others
  LxPecToggle.Enabled := onoff;
  TrackingGroup.Enabled := onoff;
  TrackingDefaultButton.Enabled := onoff;
  TrackingLunarButton.Enabled := onoff;
  TrackingCustomButton.Enabled := onoff;
  TrackingGetButton.Enabled := onoff;
  TrackingSetRateButton.Enabled := onoff;
  TrackingRateEdit.Enabled := onoff;
  TrackingRateIncrease.Enabled := onoff;
  TrackingRateDecrease.Enabled := onoff;
  DECPECOn.Enabled := onoff;
  DECPECOff.Enabled := onoff;
  RAPECOn.Enabled := onoff;
  RAPECOff.Enabled := onoff;
  DECSlewRate.Enabled := onoff;
  DECSlewRateSet.Enabled := onoff;
  LxGuideRate.Enabled := onoff;
  LxGuideRateSet.Enabled := onoff;
  RASlewRate.Enabled := onoff;
  RASlewRateSet.Enabled := onoff;
  SlewSpeedGroup.Enabled := onoff;
  SlewSpeedBar.Enabled := onoff;
end;

procedure Tpop_lx200.ScopeChangeButton(onoff: boolean);
begin
  // Virthp
  HandPadModeSelection.Enabled := onoff;
  LRModeGroup.Enabled := onoff;
  // Speeds
  ScopeSpeeds.Enabled := onoff;
  if onoff = True then
  begin
    MsArcSec.Value := LX200_Scope_GetMsArcSec;
    GuideArcSec.Value := LX200_Scope_GetGuideArcSec;
  end;
  MsArcSec.Enabled := onoff;
  GuideArcSec.Enabled := onoff;
  // Init
  ScopeInit.Enabled := onoff;
  // FR
  FieldRotationGroup.Enabled := onoff;
  FieldRotation.Enabled := onoff;
  FRQuery.Enabled := onoff;
end;

procedure Tpop_lx200.ScopeConnect(var ok: boolean);
begin
  led.color := clRed;
  led.refresh;
  timer1.Enabled := False;
  ok := False;
  case RadioGroup6.ItemIndex of
    0: ok := LX200_Open(trim(cbo_type.Text), trim(cbo_port.Text), PortSpeedbox.Text,
        Paritybox.Text, DatabitBox.Text, StopbitBox.Text, TimeOutBox.Text, IntTimeOutBox.Text);
    1: ok := LX200_Open(trim(cbo_type.Text), trim(ipaddr.Text), tcpport.Text, TcpTimeOut.Text);
  end;
  if ok then
  begin
    LX200_SetFormat(radiogroup2.ItemIndex);
    if not CoordLock then   // TMa
      ShowCoordinates;
    led.color := clLime;
    timer1.Enabled := True;
    ChangeButton(True);
    cbo_type.Enabled := False;
    if checkBox1.Checked then
      HPP.Text := LX200_QueryHighPrecision;
    if LX200_UseHPP then
    begin
      GroupBox6.Visible := True;
    end
    else
    begin
      GroupBox6.Visible := False;
    end;
    // Renato Bonomini:
    if cbo_type.Text = 'Scope.exe' then
      ScopeChangeButton(True);
  end
  else
  begin
    LX200_Close;
    formstyle := fsNormal;
    case RadioGroup6.ItemIndex of
      0: ShowMessage(Format(rsErrorOpening3, [cbo_type.Text, cbo_port.Text + crlf]));
      1: ShowMessage(Format(rsErrorOpening3,
          ['tcp/ip', ipaddr.Text + ':' + tcpport.Text + crlf]));
    end;

    formstyle := fsStayOnTop;
    ChangeButton(False);
    // Renato Bonomini:
    if cbo_type.Text = 'Scope.exe' then
      ScopeChangeButton(False);
    cbo_type.Enabled := True;
  end;
end;

procedure Tpop_lx200.ScopeDisconnect(var ok: boolean);
begin
  pos_x.Text := '';
  pos_y.Text := '';
  az_x.Text := '';
  alt_y.Text := '';
  ok := LX200_Close;
  led.color := clRed;
  ChangeButton(False);
  cbo_type.Enabled := True;
  // Renato Bonomini:
  if cbo_type.Text = 'Scope.exe' then
    ScopeChangeButton(False);
end;

procedure Tpop_lx200.ScopeClose;
begin
  Release;
end;

function Tpop_lx200.ScopeConnected: boolean;
begin
  Result := LX200_opened;
end;

function Tpop_lx200.ScopeInitialized: boolean;
begin
  Result := ScopeConnected;
end;

procedure Tpop_lx200.ScopeAlign(Source: string; ra, Dec: double);
begin
  LX200_SyncPos(RA * 15, Dec);
end;

procedure Tpop_lx200.ScopeShowModal(var ok: boolean);
begin
  showmodal;
  ok := (modalresult = mrOk);
end;

procedure Tpop_lx200.ScopeShow;
begin
  Show;
  PageControl1.ActivePageIndex := 0;
  PageControl1.Invalidate;
end;

procedure Tpop_lx200.ScopeGetRaDec(var ar, de: double; var ok: boolean);
begin
  if ScopeConnected then
  begin
    ar := Curdeg_x / 15;
    de := Curdeg_y;
    ok := True;
  end
  else
    ok := False;
end;

procedure Tpop_lx200.ScopeGetAltAz(var alt, az: double; var ok: boolean);
begin
  if ScopeConnected then
  begin
    az := cur_az;
    alt := cur_alt;
    ok := True;
  end
  else
    ok := False;
end;

procedure Tpop_lx200.ScopeGetEqSys(var EqSys: double);
begin
  case EqSys1.ItemIndex of
    0: EqSys := 0;
    1: EqSys := 1950;
    2: EqSys := 2000;
    3: EqSys := 2050;
  end;
end;

procedure Tpop_lx200.ScopeGetInfo(var Nam: shortstring;
  var QueryOK, SyncOK, GotoOK: boolean; var refreshrate: integer);
begin
  // Renato added model 5
  if (cbo_type.Text = validModel[1]) or (cbo_type.Text = validModel[2]) or
    (cbo_type.Text = validModel[5]) then
  begin // lx200, autostar, scope.exe
    nam := cbo_type.Text;
    QueryOK := True;
    SyncOK := True;
    GotoOK := True;
  end
  else if (cbo_type.Text = validModel[3]) or (cbo_type.Text = validModel[4]) then
  begin  // magellan
    nam := cbo_type.Text;
    QueryOK := True;
    SyncOK := False;
    GotoOK := False;
  end;
  refreshrate := timer1.interval;
end;

procedure Tpop_lx200.ScopeReset;
begin
end;

procedure Tpop_lx200.ScopeSetObs(la, lo, tz: double);
begin
  latitude := la;
  longitude := lo;
  if longitude < 0 then
    longitude := 360 + longitude;
  timezone := -tz;
  lat.Text := floattostr(Latitude);
  long.Text := floattostr(Longitude);
end;

procedure Tpop_lx200.ScopeGoto(ar, de: double; var ok: boolean);
begin
  ok := LX200_Goto(ar * 15, de);
end;

procedure Tpop_lx200.ScopeAbortSlew;
begin
  LX200_StopMove;
end;

procedure Tpop_lx200.GetScopeRates(var nrates: integer; var srate: TStringList);
begin
  srate.Clear;
  srate.Assign(RadioGroup1.Items);
  nrates := srate.Count;
end;

procedure Tpop_lx200.ScopeMoveAxis(axis: integer; rate: string);
var
  i: integer;
  positive: boolean;
begin
  positive := (copy(rate, 1, 1) <> '-');
  if not positive then
    Delete(rate, 1, 1);
  for i := 0 to RadioGroup1.Items.Count - 1 do
  begin
    if RadioGroup1.Items[i] = rate then
    begin
      RadioGroup1.ItemIndex := i;
      LX200_SetSpeed(i);
    end;
  end;
  case axis of
    0:
    begin  //  alpha
      if positive then
      begin
        LX200_Move(east);
      end
      else
      begin
        LX200_Move(west);
      end;
    end;
    1:
    begin  // delta
      if positive then
      begin
        LX200_Move(north);
      end
      else
      begin
        LX200_Move(south);
      end;
    end;
  end;

end;

{-------------------------------------------------------------------------------

                                  Utility functions

--------------------------------------------------------------------------------}

function Tpop_lx200.str2ra(s: string): double;
var
  h, m, ss: integer;
begin
  h := StrToInt(copy(s, 19, 2));
  m := StrToInt(copy(s, 22, 2));
  ss := StrToInt(copy(s, 25, 1)); // tenth of minute
  Result := 15 * ((h) + (m / 60) + (ss / 600));
end;

function Tpop_lx200.str2dec(s: string): double;
var
  sgn, d, m: integer;
begin
  d := StrToInt(copy(s, 27, 3));
  if d < 0 then
    sgn := -1
  else
    sgn := 1;
  m := StrToInt(copy(s, 31, 2));
  Result := sgn * (abs(d) + (m / 60));
end;

procedure Tpop_lx200.ScopeReadConfig(ConfigPath: shortstring);
begin
  ReadConfig(ConfigPath);
end;

{-------------------------------------------------------------------------------

                                  Form functions

--------------------------------------------------------------------------------}

procedure Tpop_lx200.SetLang;
begin
  TabSheet1.Caption := rsCoordinates2;
  GroupBox1.Caption := rsMove;
  RadioGroup1.Caption := rsSpeed;
  RadioGroup1.Items[0] := rsSlew;
  RadioGroup1.Items[1] := rsFind;
  RadioGroup1.Items[2] := rsCentering;
  RadioGroup1.Items[3] := rsGuide;
  GroupBox8.Caption := rsSwapButton;
  GroupBox6.Caption := rsHighPrecisio;
  SpeedButton3.Caption := rsResumeGoTo;
  SpeedButton8.Caption := rsSetTelescope;
  SpeedButton9.Caption := rsParkTelescop;
  SpeedButton1.Caption := rsConnect;
  SpeedButton5.Caption := rsDisconnect;
  SpeedButton2.Caption := rsHide;
  SpeedButton4.Caption := rsHelp;
  StopBtn.Caption := rsStop;
  MotorTab.Caption := rsMotor;
  TrackingGroup.Caption := rsTracking;
  TrackingDefaultButton.Caption := rsDefault;
  TrackingLunarButton.Caption := rsLunar;
  TrackingCustomButton.Caption := rsCustom;
  TrackingGetButton.Caption := rsGet;
  TrackingSetRateButton.Caption := rsSet;
  TrackingDecreaseLabel.Caption := rsDecrease + crlf + '0.1 Hz';
  TrackingIncreaseLabel.Caption := rsIncrease + crlf + '0.1 Hz';
  FieldRotationGroup.Caption := rsFieldRotatio;
  FieldRotation.Caption := rsMotor;
  FRLabel.Caption := rsFRAngle;
  FRQuery.Caption := rsUpdate1;
  FanControl.Caption := rsFan;
  LX200GPSRate.Caption := rsGps16AdvSett;
  LxPecToggle.Caption := rsPecToggle;
  SlewSpeedGroup.Caption := rsSlewSpeed;
  LabelSetSlewSpeed.Caption := rsSetSlewing + crlf + rsSpeed + ' (2..4)';
  Lx200GPSMotorSpeeds.Caption := rsMotorSpeeds;
  LabelGuideSpeed.Caption := rsGuideRate + ' [arc"/s]';
  LabelRaAzSpeed.Caption := rsRAAzSlewRate + ' [°/s]';
  LabelDecSlewRate.Caption := rsDECElSlewRat + ' [°/s]';
  Focus.Caption := rsFocus;
  RadioGroup5.Caption := rsSpeedSelecti;
  RadioGroup3.Caption := 'Autostar ' + rsFocusSpeed;
  RadioGroup4.Caption := 'LX200 ' + rsFocusSpeed;
  RadioGroup4.Items[0] := rsSlow;
  RadioGroup4.Items[1] := rsFast;
  CheckBox6.Caption := rsPulseMode;
  Label19.Caption := rsPulseDuratio;
  Button1.Caption := rsSaveSetting;
  VirtHP.Caption := 'VirtHP';
  VHPTitleLabel.Caption := rsVirtualHandP;
  LRModeGroup.Caption := rsModeButtonSi;
  LeftModeButton.Caption := rsLeftMode;
  RightModeButton.Caption := rsRightMode;
  HandPadModeSelection.Caption := rsHandPadModeS;
  Adv.Caption := rsScopeAdv;
  ADVTitleLabel.Caption := rsAdvancedSett;
  ScopeSpeeds.Caption := rsSpeedSetting;
  GetMsArcSec.Caption := rsGet;
  SetMsArcSec.Caption := rsSet;
  ScopeInit.Caption := rsInitialize;
  GuideArcSecLabel.Caption := rsGuideArcsec;
  GetGuideArcSec.Caption := rsGet;
  SetGuideArcSec.Caption := rsSet;
  PEC.Caption := rsPEC;
  RAPEC.Caption := rsRAAZPECCompe;
  RAPECOn.Caption := rsOn;
  RAPECOff.Caption := rsOff;
  DECPEC.Caption := rsDECELPECComp;
  DECPECOn.Caption := rsOn;
  DECPECOff.Caption := rsOff;
  TabSheet2.Caption := rsConfiguratio;
  Label1.Caption := rsModel;
  Label2.Caption := rsRefreshRate;
  Label21.Caption := rsEquatorialSy;
  QueryFirmwareButton.Caption := rsQuery;
  ProductInfoBox.Caption := rsProductInfo;
  RadioGroup2.Caption := rsDisplayPreci;
  RadioGroup2.Items[0] := rsLow + '( ddd:mm )';
  RadioGroup2.Items[1] := rsHigh + '( ddd:mm:ss )';
  GroupBox7.Caption := rsHighPrecisio;
  CheckBox1.Caption := rsUseHPP;
  Button3.Caption := rsSwitchHPP;
  GroupBox5.Caption := rsObservatory;
  Label15.Caption := rsLatitude;
  Label16.Caption := rsLongitude + crlf + rsNegativeEast;
  CheckBox5.Caption := rsRecordProtoc;
  CheckBox2.Caption := rsFormAlwaysVi;
  SaveButton1.Caption := rsSaveSetting;
  TabSheet3.Caption := rsPortConfigur;
  RadioGroup6.Caption := rsCommunicatio;
  GroupBox4.Caption := rsPortConfigur;
  Label5.Caption := rsSerialPort;
  Label7.Caption := rsSpeed;
  Label9.Caption := rsDataBits;
  Label8.Caption := rsParity;
  Label10.Caption := rsStopBits;
  Label13.Caption := rsTimeoutMs;
  Label18.Caption := rsIntervalTime;
  GroupBox9.Caption := rsSocketConfig;
  Label22.Caption := rsIPAddress;
  Label23.Caption := rsTCPPort;
  Label24.Caption := rsTimeoutMs;
  Button2.Caption := rsSaveSetting;

  SetHelp(self, hlpLX200);
end;

function Tpop_lx200.ReadConfig(ConfigPath: shortstring): boolean;
var
  ini: tinifile;
  nom: string;
  av: boolean;
begin
  Result := DirectoryExists(ConfigPath);
  if Result then
    FConfig := slash(ConfigPath) + 'scope.ini'
  else
    FConfig := slash(extractfilepath(ParamStr(0))) + 'scope.ini';
  ini := tinifile.Create(FConfig);
  if ini.SectionExists('lx200') then
    PageControl1.ActivePage := TabSheet1
  else
    PageControl1.ActivePage := TabSheet2;
  // get configured model
  nom := ini.readstring('lx200', 'name', 'LX200');
  cbo_type.Text := nom;
  cbo_type.ItemIndex := ini.readinteger('lx200', 'model', 0);

  // set default based on model
  if cbo_type.Text = 'LX200' then
  begin
    PortSpeedbox.ItemIndex := 5;
    ShowAltAz.Checked := False;
    ShowAltAz.Enabled := True;
    GroupBox1.Visible := True;
    RadioGroup2.Visible := True;
    GroupBox5.Visible := True;
    GroupBox7.Visible := True;
    if LX200_UseHPP then
      GroupBox6.Visible := True;
    SpeedButton8.Visible := True;
    SpeedButton9.Visible := True;
    Radiogroup1.Items.Clear;
    Radiogroup1.Items.Add(rsSlew);
    Radiogroup1.Items.Add(rsFind);
    Radiogroup1.Items.Add(rsCentering);
    Radiogroup1.Items.Add(rsGuide);
    Radiogroup1.ItemIndex := 1;
    // Renato Bonomini:
  end
  else if cbo_type.Text = 'Scope.exe' then
  begin
    PortSpeedbox.ItemIndex := 5;
    ShowAltAz.Checked := True;
    ShowAltAz.Enabled := True;
    GroupBox1.Visible := True;
    RadioGroup2.Visible := True;
    GroupBox5.Visible := True;
    GroupBox7.Visible := False;
    // if LX200_UseHPP then GroupBox6.visible:=true; //
    Radiogroup1.Items.Clear;
    Radiogroup1.Items.Add(rsSlew);
    Radiogroup1.Items.Add(rsFind);
    Radiogroup1.Items.Add(rsCentering);
    Radiogroup1.Items.Add(rsGuide);
    Radiogroup1.ItemIndex := 1;
    VirtHP.TabVisible := True;
    Adv.TabVisible := True;
    FRAngle.Visible := True;
    FRQuery.Visible := True;
    FRLabel.Visible := True;
    SpeedButton8.Visible := True;
    SpeedButton9.Visible := True;
  end
  else if cbo_type.Text = 'AutoStar' then
  begin
    PortSpeedbox.ItemIndex := 5;
    ShowAltAz.Checked := False;
    ShowAltAz.Enabled := True;
    GroupBox1.Visible := True;
    RadioGroup2.Visible := True;
    GroupBox5.Visible := True;
    GroupBox7.Visible := False;
    GroupBox6.Visible := False;
    LX200_UseHPP := False;
    SpeedButton8.Visible := True;
    SpeedButton9.Visible := True;
    Radiogroup1.Items.Clear;
    Radiogroup1.Items.Add(rsHighest);
    Radiogroup1.Items.Add(rsMiddle);
    Radiogroup1.Items.Add(rsSlowest);
    Radiogroup1.ItemIndex := 1;
  end
  else if cbo_type.Text = 'Magellan-II' then
  begin
    PortSpeedbox.ItemIndex := 1;
    ShowAltAz.Checked := False;
    ShowAltAz.Enabled := False;
    GroupBox1.Visible := False;
    RadioGroup2.Visible := False;
    GroupBox5.Visible := False;
    GroupBox7.Visible := False;
    GroupBox6.Visible := False;
    LX200_UseHPP := False;
    SpeedButton8.Visible := False;
    SpeedButton9.Visible := False;
  end
  else if cbo_type.Text = 'Magellan-I' then
  begin
    PortSpeedbox.ItemIndex := 2;
    ShowAltAz.Checked := False;
    ShowAltAz.Enabled := False;
    GroupBox1.Visible := False;
    RadioGroup2.Visible := False;
    GroupBox5.Visible := False;
    GroupBox7.Visible := False;
    GroupBox6.Visible := False;
    LX200_UseHPP := False;
    SpeedButton8.Visible := False;
    SpeedButton9.Visible := False;
  end;

  // Get configured values
  RadioGroup6.ItemIndex := ini.readinteger('lx200', 'comproto', 0);
  RadioGroup6Click(nil);
  ReadIntBox.Text := ini.readstring('lx200', 'read_interval', '1000');
  cbo_port.Text := ini.readstring('lx200', 'comport', DefaultSerialPort);
  PortSpeedbox.Text := ini.readstring('lx200', 'baud', '9600');
  DatabitBox.Text := ini.readstring('lx200', 'databits', '8');
  Paritybox.Text := ini.readstring('lx200', 'parity', 'N');
  StopbitBox.Text := ini.readstring('lx200', 'stopbits', '1');
  TimeOutBox.Text := ini.readstring('lx200', 'timeout', '1000');
  IntTimeOutBox.Text := ini.readstring('lx200', 'inttimeout', '400');
  ipaddr.Text := ini.readstring('lx200', 'ipaddr', '127.0.0.1');
  tcpport.Text := ini.readstring('lx200', 'tcpport', '999');
  tcptimeout.Text := ini.readstring('lx200', 'tcptimeout', '1000');
  checkBox1.Checked := ini.ReadBool('lx200', 'hpp', False);
  ShowAltAz.Checked := ini.ReadBool('lx200', 'AltAz', False);
  av := ini.ReadBool('lx200', 'AlwaysVisible', True);
  checkBox3.Checked := ini.ReadBool('lx200', 'SwapNS', False);
  checkBox4.Checked := ini.ReadBool('lx200', 'SwapEW', False);
  lat.Text := ini.readstring('observatory', 'latitude', '0');
  long.Text := ini.readstring('observatory', 'longitude', '0');
  radiogroup2.ItemIndex := ini.readinteger('lx200', 'precision', 0);
  radiogroup5.ItemIndex := ini.readinteger('lx200', 'focusmodel', 0);
  radiogroup3.ItemIndex := ini.readinteger('lx200', 'focusspeed1', 0);
  radiogroup4.ItemIndex := ini.readinteger('lx200', 'focusspeed2', 1);
  checkbox6.Checked := ini.ReadBool('lx200', 'focuspulse', False);
  longedit1.Value := ini.readinteger('lx200', 'focusduration', 100);
  eqsys1.ItemIndex := ini.readinteger('lx200', 'eqsys', 0);
  UTCBox.Checked := ini.readBool('lx200', 'utctime', False);
  ini.Free;
  Timer1.Interval := strtointdef(ReadIntBox.Text, 1000);

  // Renato Bonomini:
  MsArcSecLabel.Caption := 'Microstep'#13#10'[arc"/s]';
  GuideArcSecLabel.Caption := 'Guide'#13#10'[arc"/s]';

  checkbox2.Checked := av;

  initial := False;
end;

procedure Tpop_lx200.kill(Sender: TObject; var CanClose: boolean);
begin
  if port_opened then
  begin
    canclose := False;
    hide;
  end;
end;

procedure Tpop_lx200.RadioGroup6Click(Sender: TObject);
begin
  case RadioGroup6.ItemIndex of
    0:
    begin
      GroupBox4.Visible := True;
      GroupBox9.Visible := False;
    end;
    1:
    begin
      GroupBox4.Visible := False;
      GroupBox9.Visible := True;
    end;
  end;
end;

procedure Tpop_lx200.FormCreate(Sender: TObject);
begin
  ScaleDPI(Self);
  CoordLock := False;
  Initial := True;
end;

procedure Tpop_lx200.Timer1Timer(Sender: TObject);
begin
  //if port_opened and pop_lx200.visible and (not CoordLock) then begin
  if port_opened and (not CoordLock) then
  begin
    CoordLock := True;
    try
      ShowCoordinates;
    finally
      CoordLock := False;
    end;
  end;
end;

procedure Tpop_lx200.setresClick(Sender: TObject);
var
  ok: boolean;
begin
  ScopeConnect(ok);
end;

procedure Tpop_lx200.SaveButton1Click(Sender: TObject);
var
  ini: tinifile;
begin
  ini := tinifile.Create(FConfig);
  ini.writestring('lx200', 'name', cbo_type.Text);
  ini.writeinteger('lx200', 'model', cbo_type.ItemIndex);
  ini.writestring('lx200', 'read_interval', ReadIntBox.Text);
  ini.writeinteger('lx200', 'comproto', radiogroup6.ItemIndex);
  ini.writestring('lx200', 'comport', cbo_port.Text);
  ini.writestring('lx200', 'baud', PortSpeedbox.Text);
  ini.writestring('lx200', 'databits', DatabitBox.Text);
  ini.writestring('lx200', 'parity', Paritybox.Text);
  ini.writestring('lx200', 'stopbits', StopbitBox.Text);
  ini.writestring('lx200', 'timeout', TimeOutBox.Text);
  ini.writestring('lx200', 'inttimeout', IntTimeOutBox.Text);
  ini.writestring('lx200', 'ipaddr', ipaddr.Text);
  ini.writestring('lx200', 'tcpport', tcpport.Text);
  ini.writestring('lx200', 'tcptimeout', tcptimeout.Text);
  ini.writeBool('lx200', 'hpp', checkBox1.Checked);
  ini.writeBool('lx200', 'AltAz', ShowAltAz.Checked);
  ini.writeBool('lx200', 'AlwaysVisible', checkbox2.Checked);
  ini.writeBool('lx200', 'SwapNS', checkbox3.Checked);
  ini.writeBool('lx200', 'SwapEW', checkbox4.Checked);
  ini.writestring('observatory', 'latitude', lat.Text);
  ini.writestring('observatory', 'longitude', long.Text);
  ini.writeinteger('lx200', 'precision', radiogroup2.ItemIndex);
  ini.writeinteger('lx200', 'focusmodel', radiogroup5.ItemIndex);
  ini.writeinteger('lx200', 'focusspeed1', radiogroup3.ItemIndex);
  ini.writeinteger('lx200', 'focusspeed2', radiogroup4.ItemIndex);
  ini.writeBool('lx200', 'focuspulse', checkbox6.Checked);
  ini.writeinteger('lx200', 'focusduration', longedit1.Value);
  ini.writeinteger('lx200', 'eqsys', eqsys1.ItemIndex);
  ini.writeBool('lx200', 'utctime', UTCBox.Checked);
  ini.Free;
end;

procedure Tpop_lx200.ReadIntBoxChange(Sender: TObject);
begin
  Timer1.Interval := strtointdef(ReadIntBox.Text, 500);
end;

procedure Tpop_lx200.latChange(Sender: TObject);
var
  x: double;
  i: integer;
begin
  val(lat.Text, x, i);
  if i = 0 then
    latitude := x;
end;

procedure Tpop_lx200.longChange(Sender: TObject);
var
  x: double;
  i: integer;
begin
  val(long.Text, x, i);
  if i = 0 then
    longitude := x;
end;

procedure Tpop_lx200.SpeedButton5Click(Sender: TObject);
var
  ok: boolean;
begin
  ScopeDisconnect(ok);
end;

procedure Tpop_lx200.SpeedButton2Click(Sender: TObject);
begin
  Hide;
end;

procedure Tpop_lx200.TopBtnMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: integer);
begin
  LX200_SetSpeed(RadioGroup1.ItemIndex);
  if checkBox3.Checked then
    LX200_Move(south)
  else
    LX200_Move(north);
end;

procedure Tpop_lx200.BotBtnMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: integer);
begin
  LX200_SetSpeed(RadioGroup1.ItemIndex);
  if checkBox3.Checked then
    LX200_Move(north)
  else
    LX200_Move(south);
end;

procedure Tpop_lx200.LeftBtnMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: integer);
begin
  LX200_SetSpeed(RadioGroup1.ItemIndex);
  if checkBox4.Checked then
    LX200_Move(west)
  else
    LX200_Move(east);
end;

procedure Tpop_lx200.RightBtnMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: integer);
begin
  LX200_SetSpeed(RadioGroup1.ItemIndex);
  if checkBox4.Checked then
    LX200_Move(east)
  else
    LX200_Move(west);
end;

procedure Tpop_lx200.TopBtnMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: integer);
begin
  if checkBox3.Checked then
    LX200_StopDir(south)
  else
    LX200_StopDir(north);
end;

procedure Tpop_lx200.RightBtnMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: integer);
begin
  if checkBox4.Checked then
    LX200_StopDir(east)
  else
    LX200_StopDir(west);
end;

procedure Tpop_lx200.BotBtnMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: integer);
begin
  if checkBox3.Checked then
    LX200_StopDir(north)
  else
    LX200_StopDir(south);
end;

procedure Tpop_lx200.LeftBtnMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: integer);
begin
  if checkBox4.Checked then
    LX200_StopDir(west)
  else
    LX200_StopDir(east);
end;

procedure Tpop_lx200.StopBtnMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: integer);
begin
  LX200_StopMove;
end;

procedure Tpop_lx200.RadioGroup2Click(Sender: TObject);
begin
  LX200_SetFormat(radiogroup2.ItemIndex);
end;

procedure Tpop_lx200.cbo_typeChange(Sender: TObject);
begin
  VirtHP.TabVisible := False;
  Adv.TabVisible := False;
  FRAngle.Visible := False;
  FRQuery.Visible := False;
  FRLabel.Visible := False;
  if cbo_type.Text = 'LX200' then
  begin
    PortSpeedbox.ItemIndex := 5;
    DatabitBox.ItemIndex := 4;
    Paritybox.ItemIndex := 0;
    StopbitBox.ItemIndex := 0;
    ShowAltAz.Checked := False;
    ShowAltAz.Enabled := True;
    GroupBox1.Visible := True;
    RadioGroup2.Visible := True;
    GroupBox5.Visible := True;
    GroupBox7.Visible := True;
    SpeedButton8.Visible := True;
    SpeedButton9.Visible := False;
    if LX200_UseHPP then
      GroupBox6.Visible := True;
    Radiogroup1.Items.Clear;
    Radiogroup1.Items.Add(rsSlew);
    Radiogroup1.Items.Add(rsFind);
    Radiogroup1.Items.Add(rsCentering);
    Radiogroup1.Items.Add(rsGuide);
    Radiogroup1.ItemIndex := 1;
    // Renato Bonomini:
  end
  else if cbo_type.Text = 'Scope.exe' then
  begin
    PortSpeedbox.ItemIndex := 5;
    ShowAltAz.Checked := True;
    ShowAltAz.Enabled := True;
    GroupBox1.Visible := True;
    RadioGroup2.Visible := True;
    GroupBox5.Visible := True;
    GroupBox7.Visible := False;
    // if LX200_UseHPP then GroupBox6.visible:=true; //
    Radiogroup1.Items.Clear;
    Radiogroup1.Items.Add(rsSlew);
    Radiogroup1.Items.Add(rsFind);
    Radiogroup1.Items.Add(rsCentering);
    Radiogroup1.Items.Add(rsGuide);
    Radiogroup1.ItemIndex := 1;
    VirtHP.TabVisible := True;
    Adv.TabVisible := True;
    FRAngle.Visible := True;
    FRQuery.Visible := True;
    FRLabel.Visible := True;
    SpeedButton8.Visible := True;
    SpeedButton9.Visible := True;
  end
  else if cbo_type.Text = 'AutoStar' then
  begin
    PortSpeedbox.ItemIndex := 5;
    DatabitBox.ItemIndex := 4;
    Paritybox.ItemIndex := 0;
    StopbitBox.ItemIndex := 0;
    ShowAltAz.Checked := False;
    ShowAltAz.Enabled := True;
    GroupBox1.Visible := True;
    RadioGroup2.Visible := True;
    GroupBox5.Visible := True;
    GroupBox7.Visible := False;
    SpeedButton8.Visible := True;
    SpeedButton9.Visible := True;
    GroupBox6.Visible := False;
    LX200_UseHPP := False;
    Radiogroup1.Items.Clear;
    Radiogroup1.Items.Add(rsHighest);
    Radiogroup1.Items.Add(rsMiddle);
    Radiogroup1.Items.Add(rsSlowest);
    Radiogroup1.ItemIndex := 1;
  end
  else if cbo_type.Text = 'Magellan-II' then
  begin
    PortSpeedbox.ItemIndex := 1;
    DatabitBox.ItemIndex := 4;
    Paritybox.ItemIndex := 0;
    StopbitBox.ItemIndex := 0;
    ShowAltAz.Checked := False;
    ShowAltAz.Enabled := False;
    GroupBox1.Visible := False;
    RadioGroup2.Visible := False;
    RadioGroup2.ItemIndex := 0;
    GroupBox5.Visible := False;
    GroupBox7.Visible := False;
    GroupBox6.Visible := False;
    LX200_UseHPP := False;
    SpeedButton8.Visible := False;
    SpeedButton9.Visible := False;
  end
  else if cbo_type.Text = 'Magellan-I' then
  begin
    PortSpeedbox.ItemIndex := 2;
    DatabitBox.ItemIndex := 4;
    Paritybox.ItemIndex := 0;
    StopbitBox.ItemIndex := 0;
    ShowAltAz.Checked := False;
    ShowAltAz.Enabled := False;
    GroupBox1.Visible := False;
    RadioGroup2.Visible := False;
    RadioGroup2.ItemIndex := 0;
    GroupBox5.Visible := False;
    GroupBox7.Visible := False;
    GroupBox6.Visible := False;
    LX200_UseHPP := False;
    SpeedButton8.Visible := False;
    SpeedButton9.Visible := False;
  end;
  Caption := rsObsolete + ': ' + cbo_type.Text;
end;

procedure Tpop_lx200.CheckBox1Click(Sender: TObject);
begin
  if ScopeConnected then
  begin
    if checkBox1.Checked then
      HPP.Text := LX200_QueryHighPrecision;
    if LX200_UseHPP then
    begin
      GroupBox6.Visible := True;
    end
    else
    begin
      GroupBox6.Visible := False;
    end;
  end;
end;

procedure Tpop_lx200.Button3Click(Sender: TObject);
begin
  HPP.Text := LX200_SwitchHighPrecision;
  if LX200_UseHPP then
  begin
    GroupBox6.Visible := True;
  end
  else
  begin
    GroupBox6.Visible := False;
  end;
end;

procedure Tpop_lx200.SpeedButton3Click(Sender: TObject);
begin
  LX200_Slew;
end;

procedure Tpop_lx200.CheckBox2Click(Sender: TObject);
begin
  if initial then
    exit;
  if checkbox2.Checked then
    FormStyle := fsStayOnTop
  else
    FormStyle := fsNormal;
end;

procedure Tpop_lx200.FormShow(Sender: TObject);
begin
  Caption := rsObsolete + ': ' + cbo_type.Text;
  GetSerialPorts(cbo_port);
end;

procedure Tpop_lx200.CheckBox3Click(Sender: TObject);
begin
  if checkbox3.Checked then
  begin
    Label3.Caption := 'S';
    Label6.Caption := 'N';
  end
  else
  begin
    Label3.Caption := 'N';
    Label6.Caption := 'S';
  end;
end;

procedure Tpop_lx200.CheckBox4Click(Sender: TObject);
begin
  if checkbox4.Checked then
  begin
    Label14.Caption := 'W';
    Label4.Caption := 'E';
  end
  else
  begin
    Label14.Caption := 'E';
    Label4.Caption := 'W';
  end;
end;

procedure Tpop_lx200.CheckBox5Click(Sender: TObject);
begin
  if CheckBox5.Checked then
  begin
    Initserialdebug(slash(PrivateDir) + 'lx200_trace.txt');
    debug := True;
  end
  else
  begin
    CloseSerialDebug;
  end;
end;

procedure Tpop_lx200.SpeedButton4Click(Sender: TObject);
begin
  ShowHelp;
end;

procedure Tpop_lx200.RadioGroup5Click(Sender: TObject);
begin
  RadioGroup3.Visible := (radiogroup5.ItemIndex = 1);
  RadioGroup4.Visible := not RadioGroup3.Visible;
end;

procedure Tpop_lx200.SpeedButton6MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: integer);
begin
  LX200_StopFocus;
end;

procedure Tpop_lx200.SpeedButton6MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: integer);
var
  c: char;
begin
  // set speed
  c := 'S';
  case radiogroup5.ItemIndex of
    0: if radiogroup4.ItemIndex = 0 then
        c := 'S'
      else
        c := 'F';
    1: c := IntToStr(radiogroup3.ItemIndex + 1)[1];
  end;
  LX200_SetFocusSteep(c);
  // start focus
  LX200_StartFocus('+');
  if checkbox6.Checked then
  begin
    sleep(longedit1.Value);
    LX200_StopFocus;
  end;
end;

procedure Tpop_lx200.SpeedButton7MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: integer);
var
  c: char;
begin
  // set speed
  c := 'S';
  case radiogroup5.ItemIndex of
    0: if radiogroup4.ItemIndex = 0 then
        c := 'S'
      else
        c := 'F';
    1: c := IntToStr(radiogroup3.ItemIndex + 1)[1];
  end;
  LX200_SetFocusSteep(c);
  // start focus
  LX200_StartFocus('-');
  if checkbox6.Checked then
  begin
    sleep(longedit1.Value);
    LX200_StopFocus;
  end;
end;

procedure Tpop_lx200.CheckBox6Click(Sender: TObject);
begin
  longedit1.Enabled := CheckBox6.Checked;
end;

procedure Tpop_lx200.SpeedButton8Click(Sender: TObject);
var
  datim: TdateTime;
begin
  if ScopeConnected and not CoordLock then
  begin
    CoordLock := True;
    try
      datim := now;
      if UTCBox.Checked then
        datim := datim + timezone / 24;
      if not LX200_SetObs(Latitude, Longitude, timezone, datim) then
        ShowMessage(rsDateAndOrTim);
    finally
      CoordLock := False;
    end;
  end;
end;

procedure Tpop_lx200.SpeedButton9Click(Sender: TObject);
var
  ok: boolean;
begin
  if ScopeConnected then
  begin
    if MessageDlg(rsREALLYParkAn, mtConfirmation, [mbYes, mbNo], 0) = mrYes then
      if LX200_ParkScope then
      begin
        ScopeDisconnect(ok);
        ShowMessage(rsParkingAndDi);
      end;
  end;
end;


procedure Tpop_lx200.VHpLeftClick(Sender: TObject);
// Renato Bonomini:
begin
  LX200_Scope_HpLm;
end;

procedure Tpop_lx200.VHRightClick(Sender: TObject);
// Renato Bonomini:
begin
  LX200_Scope_HpRm;
end;

procedure Tpop_lx200.QueryFirmwareButtonClick(Sender: TObject);
// Renato Bonomini:
var
  ok: boolean;
  alreadyconnected: boolean;
begin
  if CoordLock then
    Exit;
  CoordLock := True;
  try   // TMa not to interfere with Timer's show coordinates
    alreadyconnected := ScopeConnected;
    if alreadyconnected <> True then
    begin
      ScopeConnect(ok);
    end;
    ShowMessage('Controller returned' + crlf + crlf + 'Product Id : ' +
      LX200_QueryProductID + crlf + 'Firmware ID-Revision : ' + LX200_QueryFirmwareID + ' ' +
      LX200_QueryFirmwareNumber + crlf + 'Firmware Date-Time : ' + LX200_QueryFirmwareTime +
      ' ' + LX200_QueryFirmwareDate);

    if alreadyconnected <> True then
    begin
      ScopeDisconnect(ok);
    end;
  finally
    CoordLock := False;
  end;
end;

procedure Tpop_lx200.HandPadModeSelectionClick(Sender: TObject);
// Renato Bonomini:
const
  hpmodes: array[1..19] of char =
    ('a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's');
var
  selectedmode: char;
begin
  // Get the index from the radiogroup
  selectedmode := hpmodes[HandPadModeSelection.ItemIndex + 1];
  // showmessage('Selected HandPad mode : '+selectedmode);
  LX200_Scope_Hp_Mode(selectedmode);
end;

procedure Tpop_lx200.GetMsArcSecClick(Sender: TObject);
//var arcsec: string;
begin
  MsArcSec.Value := LX200_Scope_GetMsArcSec;
  //arcsec:=IntToStr(MsArcSec.Value);
  // showmessage('MsArcSec:'+arcsec);
end;

procedure Tpop_lx200.GetGuideArcSecClick(Sender: TObject);
//var arcsec: string;
begin
  GuideArcSec.Value := LX200_Scope_GetGuideArcSec;
  //arcsec:=IntToStr(GuideArcSec.Value);
  // showmessage('MsArcSec:'+arcsec);
end;

procedure Tpop_lx200.PecToggleClick(Sender: TObject);
begin
  LX200_PecToggle;
end;

procedure Tpop_lx200.ScopeFieldRotationClick(Sender: TObject);
begin
  if cbo_type.Text = 'Scope.exe' then
    FRAngle.Value := LX200_Scope_GetFRAngle;
  if FieldRotation.State = cbUnchecked then
    LX200_FieldRotationOff
  else
    LX200_FieldRotationOn;
end;

procedure Tpop_lx200.SetGuideArcSecClick(Sender: TObject);
begin
  LX200_Scope_SetGuideArcSec(GuideArcSec.Value);
  GuideArcSec.Value := LX200_Scope_GetGuideArcSec;
end;

procedure Tpop_lx200.SetMsArcSecClick(Sender: TObject);
begin
  LX200_Scope_SetMsArcSec(MsArcSec.Value);
  MsArcSec.Value := LX200_Scope_GetMsArcSec;
end;

procedure Tpop_lx200.ScopeInit1Click(Sender: TObject);
begin
  LX200_SimpleCmd('#:XI1#');
end;

procedure Tpop_lx200.ScopeInit2Click(Sender: TObject);
begin
  LX200_SimpleCmd('#:XI2#');
end;

procedure Tpop_lx200.ScopeInit3Click(Sender: TObject);
begin
  LX200_SimpleCmd('#:XI3#');
end;

procedure Tpop_lx200.AdvHelpClick(Sender: TObject);
begin
  ShowMessage('Scope.exe accepts custom LX-200 commands to ' + crlf +
    '1) Set or get msarcsec and guidespeed' + crlf + '2) Init 1->3 ' + crlf +
    crlf + 'Please check Scope website for additional info' + crlf + crlf +
    'R.Bonomini <renato@linux.eubia.it>');
end;

procedure Tpop_lx200.VirtHpHelpClick(Sender: TObject);
begin
  ShowMessage('Scope.exe accepts custom LX-200 commands to ' + crlf +
    '1) Simulate selection of Right or Left mode' + crlf + '2) Select handpad mode' +
    crlf + 'Please check Scope website for additional info' + crlf + crlf +
    'R.Bonomini <renato@linux.eubia.it>');
end;

procedure Tpop_lx200.FRQueryClick(Sender: TObject);
begin
  FRAngle.Value := LX200_Scope_GetFRAngle;
end;

procedure Tpop_lx200.TrackingDefaultButtonClick(Sender: TObject);
begin
  LX200_TrackingDefaultRate;
end;

procedure Tpop_lx200.TrackingLunarButtonClick(Sender: TObject);
begin
  LX200_TrackingLunarRate;
end;

procedure Tpop_lx200.TrackingCustomButtonClick(Sender: TObject);
begin
  LX200_TrackingCustomRate;
end;

procedure Tpop_lx200.TrackingRateChangerClick(Sender: TObject; Button: TUDBtnType);
begin
  LX200_TrackingIncreaseRate;
  LX200_TrackingDecreaseRate;
end;

procedure Tpop_lx200.TrackingSetRateButtonClick(Sender: TObject);
var
  rate: single;
begin
  rate := TrackingRateEdit.Value;
  if LX200_SetTrackingRateT(rate) = False then
    LX200_SetTrackingRateS(rate);
end;

procedure Tpop_lx200.TrackingGetButtonClick(Sender: TObject);
begin
  TrackingRateEdit.Value := LX200_GetTrackingRate;
end;

procedure Tpop_lx200.TrackingRateDecreaseClick(Sender: TObject);
begin
  LX200_TrackingDecreaseRate;
end;

procedure Tpop_lx200.TrackingRateIncreaseClick(Sender: TObject);
begin
  LX200_TrackingIncreaseRate;
end;

procedure Tpop_lx200.LX200GPSRateClick(Sender: TObject);
begin
  if not LX200GPSRate.Checked then
  begin
    Lx200GPSMotorSpeeds.Visible := False;
    PEC.TabVisible := False;
    LxPecToggle.Visible := True;
    FanControl.Visible := False;
  end;
  if LX200GPSRate.Checked then
  begin
    Lx200GPSMotorSpeeds.Visible := True;
    PEC.TabVisible := True;
    LxPecToggle.Visible := False;
    FanControl.Visible := True;
  end;
end;

procedure Tpop_lx200.LxGuideRateSetClick(Sender: TObject);
begin
  LX200_GPS_SetGuideRate(LxGuideRate.Value);
end;

procedure Tpop_lx200.RASlewRateSetClick(Sender: TObject);
begin
  LX200_GPS_RASlewRate(RASlewRate.Value);
end;

procedure Tpop_lx200.DECSlewRateSetClick(Sender: TObject);
begin
  LX200_GPS_DECSlewRate(DECSlewRate.Value);
end;

procedure Tpop_lx200.FanControlClick(Sender: TObject);
begin
  if FanControl.Checked then
    LX200_FanOn
  else
    LX200_FanOff;
end;

procedure Tpop_lx200.SlewSpeedBarChange(Sender: TObject);
begin
  LX200_SlewSpeed(SlewSpeedBar.Position);
end;

end.
