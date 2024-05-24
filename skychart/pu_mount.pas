unit pu_mount;

{$MODE objfpc}{$H+}

{------------- interface for ASCOM telescope driver. ----------------------------

Copyright (C) 2000, 2024 Patrick Chevalley

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
  cu_mount, cu_ascommount,cu_ascomrestmount,cu_indimount, u_projection, indiapi, pu_indigui,
  indibaseclient, indibasedevice, cu_ascomrest, math, LCLIntf, u_util, u_constant, u_help, u_translation,
  Messages, SysUtils, Classes, Graphics, Controls,
  Forms, Dialogs, UScaleDPI, LazSysUtils, cu_alpacamanagement,
  StdCtrls, Buttons, ComCtrls, Menus, ExtCtrls, Arrow, Spin;

type

  { Tpop_scope }

  Tpop_scope = class(TForm)
    AlpacaDiscoveryPort: TSpinEdit;
    AlpacaMountList: TComboBox;
    ARestDevice: TSpinEdit;
    ARestPass: TEdit;
    ARestPort: TSpinEdit;
    ARestUser: TEdit;
    ArrowLeft: TArrow;
    ArrowRight: TArrow;
    ArrowDown: TArrow;
    ArrowStop: TButton;
    ArrowUp: TArrow;
    AxisRates: TComboBox;
    BtnDiscover: TButton;
    BtnGet: TButton;
    BtnIndiGui: TButton;
    ButtonConnect: TButton;
    ButtonGetLocation: TSpeedButton;
    ButtonPark: TSpeedButton;
    CheckBoxOnTop: TCheckBox;
    elev: TEdit;
    GroupBox2: TGroupBox;
    GroupBox3: TGroupBox;
    GroupBox4: TGroupBox;
    IndiServerHost: TEdit;
    IndiServerPort: TEdit;
    IndiTimer: TTimer;
    Label1: TLabel;
    Label130: TLabel;
    Label2: TLabel;
    Label260: TLabel;
    Label3: TLabel;
    Label34: TLabel;
    Label35: TLabel;
    Label36: TLabel;
    Label39: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label75: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Memomsg: TMemo;
    MountIndiDevice: TComboBox;
    PageControl1: TPageControl;
    Handpad: TPanel;
    Pagecontrol2: TPageControl;
    PanelCredential: TPanel;
    Panel3: TPanel;
    parkled: TShape;
    ASCOMLocal: TTabSheet;
    ASCOMRemote: TTabSheet;
    FlipNS: TRadioGroup;
    ReadIntBox: TComboBox;
    StopMoveTimer: TTimer;
    INDIpage: TTabSheet;
    Log: TTabSheet;
    Observatory: TTabSheet;
    trackingled: TShape;
    ButtonTracking: TSpeedButton;
    ButtonHide: TButton;
    ButtonDisconnect: TButton;
    led: TShape;
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
    AscomDevice: TEdit;
    ButtonSelect: TSpeedButton;
    ButtonConfigure: TSpeedButton;
    ButtonAbort: TSpeedButton;
    ButtonSetTime: TSpeedButton;
    ButtonSetLocation: TSpeedButton;
    ButtonHelp: TButton;
    ButtonAbout: TSpeedButton;
    ARestHost: TEdit;
    ARestProtocol: TComboBox;
    {Utility and form functions}
    procedure AlpacaMountListChange(Sender: TObject);
    procedure ARestDeviceChange(Sender: TObject);
    procedure ARestHostChange(Sender: TObject);
    procedure ARestPassChange(Sender: TObject);
    procedure ARestPortChange(Sender: TObject);
    procedure ARestProtocolChange(Sender: TObject);
    procedure ARestUserChange(Sender: TObject);
    procedure ArrowMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure ArrowMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure ArrowStopClick(Sender: TObject);
    procedure AscomDeviceChange(Sender: TObject);
    procedure BtnDiscoverClick(Sender: TObject);
    procedure BtnGetClick(Sender: TObject);
    procedure BtnIndiGuiClick(Sender: TObject);
    procedure ButtonGetLocationClick(Sender: TObject);
    procedure ButtonParkClick(Sender: TObject);
    procedure CheckBoxOnTopChange(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure IndiServerHostChange(Sender: TObject);
    procedure IndiServerPortChange(Sender: TObject);
    procedure IndiTimerTimer(Sender: TObject);
    procedure MountIndiDeviceSelect(Sender: TObject);
    procedure PageControl1Change(Sender: TObject);
    procedure PageControl1Changing(Sender: TObject; var AllowChange: Boolean);
    procedure ShowAltAzChange(Sender: TObject);
    procedure StopMoveTimerTimer(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure ButtonConnectClick(Sender: TObject);
    procedure ReadIntBoxChange(Sender: TObject);
    procedure ButtonDisconnectClick(Sender: TObject);
    procedure ButtonHideClick(Sender: TObject);
    procedure ButtonHelpClick(Sender: TObject);
    procedure ButtonAbortClick(Sender: TObject);
    procedure ButtonSelectClick(Sender: TObject);
    procedure ButtonConfigureClick(Sender: TObject);
    procedure ButtonSetLocationClick(Sender: TObject);
    procedure ButtonSetTimeClick(Sender: TObject);
    procedure ButtonTrackingClick(Sender: TObject);
    procedure UpdTrackingButton;
    procedure UpdParkButton;
    procedure ButtonAboutClick(Sender: TObject);
  private
    { Private declarations }
    Fmount: T_mount;
    feqsys: TCheckBox;
    leqsys: TComboBox;
    CoordLock: boolean;
    Initialized: boolean;
    FConnected: boolean;
    FCanSetTracking: boolean;
    FCanParkUnpark: boolean;
    hasSync: Boolean;
    MountType: integer;  // 0: ascom, 1: alpaca, 2: indi
    FLongitude: double;                // Log longitude (Positive East of Greenwich}
    FLatitude: double;                 // Log latitude
    FElevation: double;                // Log elevation
    curdeg_x, curdeg_y: double;        // current equatorial position in degrees
    cur_az, cur_alt: double;           // current alt-az position in degrees
    FSlewing: boolean;
    FLastArrow: integer;
    FObservatoryCoord: TNotifyEvent;
    AlpacaServerList: TAlpacaServerList;
    mountsavedev: string;
    receiveindidevice: boolean;
    indiclient: TIndiBaseClient;
    f_indigui: Tf_indigui;
    DriverMsg: string;
    procedure SetDef(Sender: TObject);
    function ScopeConnectedReal: boolean;
    procedure ScopeGetEquatorialSystem(var EqSys: double);
    function GetSlewing:boolean;
    Procedure MountStatus(Sender: TObject);
    procedure MountMessage(msg:string; level: integer=1);
    procedure IndiNewDevice(dp: Basedevice);
    procedure IndiDisconnected(Sender: TObject);
    procedure IndiGUIdestroy(Sender: TObject);
  public
    { Public declarations }
    csc: Tconf_skychart;
    procedure SetLang;
    procedure ScopeLoadConfig;
    procedure SetRefreshRate(rate: integer);
    procedure ShowCoordinates;
    procedure ScopeShow;
    procedure ScopeShowModal(var ok: boolean);
    procedure ScopeConnect(var ok: boolean);
    procedure ScopeDisconnect(var ok: boolean; doDisconnect:boolean=true);
    procedure ScopeGetEqSys(var EqSys: double);
    procedure ScopeSetObs(la, lo, alt: double);
    procedure ScopeAlign(Source: string; ra, Dec: double);
    procedure ScopeGetRaDec(var ar, de: double; var ok: boolean);
    procedure ScopeGoto(ar, de: double; var ok: boolean);
    procedure ScopeAbortSlew;
    function ScopeInitialized: boolean;
    function ScopeConnected: boolean;
    procedure GetScopeRates(var nrates: integer; var rates: TStringList);
    procedure ScopeMoveAxis(axis: integer; rate: string);
    property Longitude: double read FLongitude;
    property Latitude: double read FLatitude;
    property Elevation: double read FElevation;
    property Slewing: boolean read FSlewing;
    property onObservatoryCoord: TNotifyEvent read FObservatoryCoord write FObservatoryCoord;
  end;


implementation

{$R *.lfm}

procedure Tpop_scope.SetRefreshRate(rate: integer);
begin
  Timer1.Interval := rate;
  ReadIntBox.Text := IntToStr(rate);
end;

procedure Tpop_scope.ShowCoordinates;
var ok: boolean;
begin
  if ScopeInitialized then
  begin
    try
      Curdeg_x := Fmount.RA * 15;
      Curdeg_y := Fmount.Dec;
    except
      on E: Exception do begin
        MessageDlg(format(DriverMsg,[E.Message]), mtWarning, [mbOK], 0);
        ScopeDisconnect(ok);
        exit;
        end;
    end;
    if ShowAltAz.Checked then
    begin
      try
        Eq2Hz(csc.CurST - deg2rad*Curdeg_x, deg2rad*Curdeg_y, Cur_az, Cur_alt, csc);
        Cur_az:=rad2deg*rmod(cur_az + pi, pi2);
        Cur_alt:=rad2deg*cur_alt;
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
end;

procedure Tpop_scope.ScopeDisconnect(var ok: boolean; doDisconnect:boolean=true);
begin

  timer1.Enabled := False;
  Initialized := False;
  FConnected := False;
  pos_x.Text := '';
  pos_y.Text := '';
  az_x.Text := '';
  alt_y.Text := '';
  try
    Fmount.Disconnect;
    Fmount.Free;
    ok := True;
    except
      on E: Exception do
        MessageDlg(format(DriverMsg,[E.Message]), mtWarning, [mbOK], 0);
    end;
    led.brush.color := clRed;
    ButtonConnect.Enabled := True;
    ButtonDisconnect.Enabled := False;
    ButtonSelect.Enabled := True;
    ButtonConfigure.Enabled := True;
    ButtonSetTime.Enabled := False;
    ButtonSetLocation.Enabled := False;
    ButtonGetLocation.Enabled := False;
    UpdTrackingButton;
    UpdParkButton;
end;

procedure Tpop_scope.ScopeConnect(var ok: boolean);
var
  dis_ok: boolean;
begin
  led.brush.color := clRed;
  led.refresh;
  timer1.Enabled := False;
  ButtonSelect.Enabled := True;
  ok := False;
  CoordLock := False;
  MountType:=PageControl1.ActivePageIndex;
  try
    case MountType of
      0: begin
         DriverMsg:=rsFrom + ' ' + AscomDevice.Text+':'+crlf+StringReplace(rsASCOMDriverE, 'ASCOM', 'telescope', [])+': '+'%s'+crlf+rsIfYouCannotF;
         Fmount:=T_ascommount.Create(self);
         Fmount.onStatusChange:=@MountStatus;
         Fmount.onMsg:=@MountMessage;
         Fmount.Connect(AscomDevice.Text);
      end;
      1: begin
         DriverMsg:=rsFrom + ' ' + 'telescope/'+ARestDevice.Text+':'+crlf+StringReplace(rsASCOMDriverE, 'ASCOM', 'telescope', [])+': '+'%s'+crlf+rsIfYouCannotF;
         Fmount:=T_ascomrestmount.Create(self);
         Fmount.onStatusChange:=@MountStatus;
         Fmount.onMsg:=@MountMessage;
         Fmount.Connect(ARestHost.Text,ARestPort.Text,ARestProtocol.Text,'telescope/'+ARestDevice.Text,ARestUser.Text,ARestPass.Text);
      end;
      2: begin
         DriverMsg:=rsFrom + ' ' + csc.IndiDevice+': '+'%s'+crlf+rsIfYouCannotF;
         Fmount:=T_indimount.Create(self);
         Fmount.onStatusChange:=@MountStatus;
         Fmount.onMsg:=@MountMessage;
         Fmount.AutoLoadConfig:=true;
         Fmount.Connect(csc.IndiServerHost,csc.IndiServerPort,csc.IndiDevice);
      end;
     end;
     ok:=true;
  except
    on E: Exception do begin
      MessageDlg(format(DriverMsg,[E.Message]), mtWarning, [mbOK], 0);
      scopedisconnect(dis_ok);
    end;
  end;
end;

Procedure Tpop_scope.MountStatus(Sender: TObject);
var nrates: integer;
  rates: TStringList;
begin
  case  Fmount.Status of
    devConnected:  begin
      FConnected := True;
      Initialized := True;
      try
      FCanSetTracking := pos('CanSetTracking;',Fmount.Capability)>=0;
      FCanParkUnpark := pos('CanPark;',Fmount.Capability)>=0;
      hasSync := pos('CanSync;',Fmount.Capability)>=0;
      Handpad.Visible:=pos('CanMoveAxis;',Fmount.Capability)>=0;
      if handpad.Visible then begin
        try
        rates:=TStringList.Create;
        GetScopeRates(nrates, rates);
        if (nrates>0) then begin
           AxisRates.Items.Assign(rates);
           if  AxisRates.Items.Count>0 then AxisRates.ItemIndex:=0;
        end;
        rates.Free;
        FlipNS.ItemIndex:=0;
        except
          Handpad.Visible:=false;
        end;
      end;
      except
        FCanSetTracking := false;
        FCanParkUnpark := false;
        hasSync := false;
        Handpad.Visible:=false;
      end;
      FlipNS.Visible:=Handpad.Visible;
      Label4.Visible:=Handpad.Visible;
      AxisRates.Visible:=Handpad.Visible;
      ShowCoordinates;
      FSlewing:=GetSlewing;
      led.brush.color := clLime;
      timer1.Enabled := True;
      ButtonConnect.Enabled := False;
      ButtonDisconnect.Enabled := True;
      ButtonSelect.Enabled := False;
      ButtonConfigure.Enabled := False;
      ButtonSetTime.Enabled := True;
      ButtonSetLocation.Enabled := True;
      ButtonGetLocation.Enabled := True;
      UpdTrackingButton;
    end;
    devConnecting:  begin
      led.brush.color := clYellow;

    end;
    devDisconnected:  begin
      led.brush.color := clRed;
      ButtonConnect.Enabled := True;
      ButtonDisconnect.Enabled := False;
      ButtonSelect.Enabled := True;
      ButtonConfigure.Enabled := True;
      ButtonSetTime.Enabled := False;
      ButtonSetLocation.Enabled := False;
      ButtonGetLocation.Enabled := False;
      UpdTrackingButton;
      UpdParkButton;
    end;
  end;
end;

procedure Tpop_scope.MountMessage(msg:string; level: integer=1);
begin
  if Memomsg.Lines.Count > 40 then
    Memomsg.Lines.Delete(0);
  Memomsg.Lines.Add(msg);
  Memomsg.SelStart:=Memomsg.GetTextLen-1;
  Memomsg.SelLength:=0;
end;

function Tpop_scope.ScopeConnected: boolean;
begin
  Result := FConnected;
end;

function Tpop_scope.ScopeConnectedReal: boolean;
begin
  Result := False;
  if not initialized then
    exit;
  try
  Result := Fmount.Status=devConnected;
  except
    Result := False;
  end;
end;

function Tpop_scope.ScopeInitialized: boolean;
begin
  Result := ScopeConnected;
end;

procedure Tpop_scope.ScopeAlign(Source: string; ra, Dec: double);
begin
  if not ScopeConnected then
    exit;
  if hasSync then
  begin
    try
      Fmount.Sync(ra,dec);
    except
      on E: Exception do
        MessageDlg(format(DriverMsg,[E.Message]), mtWarning, [mbOK], 0);
    end;
  end;
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
  if ScopeConnected then
  begin
      ar := Curdeg_x / 15;
      de := Curdeg_y;
      ok := True;
  end
  else
    ok := False;
end;

procedure Tpop_scope.ScopeGetEquatorialSystem(var EqSys: double);
begin
  try
  EqSys:=Fmount.Equinox;
  except
    EqSys := 0;
  end;
end;

procedure Tpop_scope.ScopeGetEqSys(var EqSys: double);
begin
  ScopeGetEquatorialSystem(eqsys);
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

procedure Tpop_scope.ScopeGoto(ar, de: double; var ok: boolean);
begin
  if not ScopeConnected then
    exit;
  try
    Fmount.Slew(ar,de);
  except
    on E: Exception do
      MessageDlg(format(DriverMsg,[E.Message]), mtWarning, [mbOK], 0);
  end;
end;

function Tpop_scope.GetSlewing:boolean;
begin
 result:=false;
 try
  result:=Fmount.MountSlewing;
 except
  on E: Exception do
    MessageDlg(format(DriverMsg,[E.Message]), mtWarning, [mbOK], 0);
  end;
end;

procedure Tpop_scope.ScopeAbortSlew;
begin
  if ScopeConnected then
  begin
    try
      Fmount.AbortSlew;
    except
      on E: Exception do
        MessageDlg(format(DriverMsg,[E.Message]), mtWarning, [mbOK], 0);
    end;
  end;
end;

procedure Tpop_scope.GetScopeRates(var nrates: integer; var rates: TStringList);
var
  r: TStringList;
begin
  rates.Clear;
  r:=fmount.SlewRates;
  rates.Assign(r);
  r.Free;
  nrates := rates.Count;
end;

procedure Tpop_scope.ScopeMoveAxis(axis: integer; rate: string);
begin
  if ScopeConnected then
  begin
    try
    Fmount.MoveAxis(axis,rate);
    except
    end;
  end;
end;


{-------------------------------------------------------------------------------

                       Form functions

--------------------------------------------------------------------------------}

procedure Tpop_scope.SetLang;
begin
  Caption := rsASCOMTelesc;
  GroupBox1.Caption := rsDriverSelect;
  if compile_cpu = 'x86_64' then
    GroupBox1.Caption := GroupBox1.Caption + ' 64 bit';
  Label1.Caption := rsRefreshRate;
  ButtonSelect.Caption := rsSelect;
  ButtonConfigure.Caption := rsConfigure;
  ButtonAbout.Caption := rsAbout;
  Label75.Caption := rsINDIServerHo;
  Label130.Caption := rsINDIServerPo;
  Label260.Caption := rsTelescopeNam;
  BtnGet.Caption := rsGet;
  Observatory.Caption := rsObservatory;
  Log.Caption:=rsMessages2;
  Label15.Caption := rsLatitude;
  Label16.Caption := rsLongitude;
  label2.Caption:=rsAltitude;
  ButtonSetLocation.Caption := rsSetToTelesco;
  ButtonGetLocation.Caption := rsGetFromTeles;
  ButtonSetTime.Caption := rsSetTime;
  ButtonTracking.Caption := rsTracking;
  ButtonAbort.Caption := rsAbortSlew;
  ButtonHelp.Caption := rsHelp;
  CheckBoxOnTop.Caption := rsAlwaysOnTop;
  ButtonConnect.Caption := rsConnect;
  ButtonDisconnect.Caption := rsDisconnect;
  ButtonHide.Caption := rsHide;
  Label4.Caption:=rsSpeed;
  flipns.Hint:=rsFlipNSMoveme;
  SetHelp(self, hlpASCOM);
end;

procedure Tpop_scope.ScopeLoadConfig;
begin
 if csc <> nil then begin
  IndiServerHost.Caption := csc.IndiServerHost;
  IndiServerPort.Caption := csc.IndiServerPort;
  MountIndiDevice.items.Clear;
  if csc.IndiDevice <> '' then
  begin
    MountIndiDevice.items.add(csc.IndiDevice);
    MountIndiDevice.ItemIndex := 0;
  end;
  AscomDevice.Text := csc.AscomDevice;
  ShowAltAz.Checked := csc.TelescopeAltAz;
  ReadIntBox.Text := IntToStr(csc.TelescopeInterval);
  PageControl1.ActivePageIndex := csc.TelescopeInterface;
  ARestProtocol.ItemIndex := csc.AlpacaProtocol;
  PanelCredential.Visible:=(ARestProtocol.ItemIndex=1);
  ARestHost.Text := csc.AlpacaHost;
  ARestPort.Value := csc.AlpacaPort;
  ARestUser.Text := csc.AlpacaUser;
  ARestPass.Text := csc.AlpacaPass;
  ARestDevice.Value := csc.AlpacaDevice;
  lat.Text := detostr(csc.ObsLatitude);
  long.Text := detostr(csc.ObsLongitude);
  elev.Text := FormatFloat(f1,csc.ObsAltitude);
  if csc.TelescopeLeft=0 then csc.TelescopeLeft:=left;
  if csc.TelescopeTop=0 then csc.TelescopeTop:=top;
  FormPos(self, csc.TelescopeLeft, csc.TelescopeTop, False);
  Timer1.Interval := strtointdef(ReadIntBox.Text, 1000);
 end;
end;

procedure Tpop_scope.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  if ScopeConnected then
  begin
    canclose := False;
    hide;
  end;
end;

procedure Tpop_scope.MountIndiDeviceSelect(Sender: TObject);
begin
  csc.IndiDevice := MountIndiDevice.Text;
end;

procedure Tpop_scope.PageControl1Change(Sender: TObject);
begin
  csc.TelescopeInterface:=PageControl1.ActivePageIndex;
  BtnIndiGui.Visible:=PageControl1.ActivePageIndex=2;
end;

procedure Tpop_scope.PageControl1Changing(Sender: TObject; var AllowChange: Boolean);
begin
  AllowChange:=not FConnected;
end;

procedure Tpop_scope.ShowAltAzChange(Sender: TObject);
begin
  csc.TelescopeAltAz              := ShowAltAz.Checked;
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
  FSlewing := false;
  FLastArrow:=0;
  DriverMsg:=rsASCOMDriverE+': %s';
  {$ifndef mswindows}
  ASCOMLocal.TabVisible:=false;
  {$endif}
end;

procedure Tpop_scope.FormShow(Sender: TObject);
begin
 if ButtonConnect.Enabled then ActiveControl:=ButtonConnect;
 BtnIndiGui.Visible:=PageControl1.ActivePageIndex=2;
end;

procedure Tpop_scope.IndiServerHostChange(Sender: TObject);
begin
  csc.IndiServerHost := IndiServerHost.Text;
end;

procedure Tpop_scope.IndiServerPortChange(Sender: TObject);
begin
  csc.IndiServerPort := IndiServerPort.Text;
end;

procedure Tpop_scope.Timer1Timer(Sender: TObject);
var ok: boolean;
begin
  FConnected := ScopeConnectedReal;
  if not FConnected then begin
    ScopeDisconnect(ok,false);
    ShowMessage('Telescope disconnected on its own!');
    exit;
  end;
  try
    if (not CoordLock) then
    begin
      CoordLock := True;
      timer1.Enabled := False;
      ShowCoordinates;
      if not FConnected then raise Exception.Create('Telescope disconnected on its own!');
      FSlewing:=GetSlewing;
      UpdTrackingButton;
      UpdParkButton;
      CoordLock := False;
      timer1.Enabled := True;
    end;
  except
    on E:Exception do begin
      ShowMessage('Telescope connection error: '+E.Message);
      ScopeDisconnect(ok,false);
    end;
  end;
end;

procedure Tpop_scope.ButtonConnectClick(Sender: TObject);
var
  ok: boolean;
begin
  ScopeConnect(ok);
end;

procedure Tpop_scope.ReadIntBoxChange(Sender: TObject);
begin
  csc.TelescopeInterval           := StrToIntDef(ReadIntBox.Text,csc.TelescopeInterval);
  Timer1.Interval := csc.TelescopeInterval;
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
  if PageControl1.ActivePageIndex=2 then
    SetHelp(self, hlpINDI)
  else
    SetHelp(self, hlpASCOM);
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
    AscomDevice.Text := WideString(V.Choose(WideString(AscomDevice.Text)));
    V := Unassigned;
    csc.AscomDevice:=AscomDevice.Text;
    UpdTrackingButton;
  except
    on E: Exception do
    begin
      err := 'ASCOM Chooser exception:' + E.Message;
      ShowMessage(err + crlf + rsPleaseEnsure + crlf + Format(
        rsSeeHttpAscom, ['http://ascom-standards.org']));
    end;
  end;
{$endif}
end;

procedure Tpop_scope.ButtonConfigureClick(Sender: TObject);
{$ifdef mswindows}
var T: Variant;
{$endif}
begin
{$ifdef mswindows}
  try
    if (AscomDevice.Text > '') and (not Scopeconnected) then
    begin
      if VarIsEmpty(T) then
      begin
        T := CreateOleObject(WideString(AscomDevice.Text));
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
    on E: Exception do
      MessageDlg(format(DriverMsg,[E.Message]), mtWarning, [mbOK], 0);
  end;
{$endif}
end;

procedure Tpop_scope.ButtonGetLocationClick(Sender: TObject);
begin
  if ScopeConnected then
  begin
    try
      Fmount.GetSite(Flongitude,FLatitude,FElevation);
      lat.Text := detostr(Flatitude);
      long.Text := detostr(Flongitude);
      elev.Text := FormatFloat(f1,FElevation);
      if assigned(FObservatoryCoord) then
        FObservatoryCoord(self);
    except
      on E: Exception do
        MessageDlg(format(DriverMsg,[E.Message]), mtWarning, [mbOK], 0);
    end;
  end;
end;

procedure Tpop_scope.ARestProtocolChange(Sender: TObject);
begin
  csc.AlpacaProtocol              := ARestProtocol.ItemIndex;
  case ARestProtocol.ItemIndex of
    0: ARestPort.Value:=11111;
    1: ARestPort.Value:=443;
  end;
  PanelCredential.Visible:=(ARestProtocol.ItemIndex=1);
end;

procedure Tpop_scope.ARestUserChange(Sender: TObject);
begin
  csc.AlpacaUser                  := ARestUser.Text;
end;

procedure Tpop_scope.ArrowMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var flip: double;
    rate: string;
begin
  rate:=trim(AxisRates.Text);  // deg/sec
  if FlipNS.ItemIndex=0 then
    flip:=1
  else
    flip:=-1;
  if sender is TArrow then begin
    with Sender as TArrow do begin
      ArrowColor:=clRed;
      FSlewing:=true;
      FLastArrow:=tag;
      case Tag of
         1: ScopeMoveAxis(0,'-'+rate);//Left
         2: ScopeMoveAxis(0,rate);    //Right
         3: begin                     // Up
            if flip>0 then
              ScopeMoveAxis(1,rate)
            else
              ScopeMoveAxis(1,'-'+rate);
         end;
         4: begin                    //Down
            if flip>0 then
              ScopeMoveAxis(1,'-'+rate)
            else
              ScopeMoveAxis(1,rate);
            end;
      end;
    end;
  end;
end;

procedure Tpop_scope.ArrowMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  // let enough time if moveaxis is still not started
  if csc.TelescopeInterface=1 then StopMoveTimer.Interval:=1000
            else StopMoveTimer.Interval:=100;
  StopMoveTimer.Enabled:=true;
end;

procedure Tpop_scope.StopMoveTimerTimer(Sender: TObject);
begin
  StopMoveTimer.Enabled:=false;
  ScopeMoveAxis(0,'0');
  ScopeMoveAxis(1,'0');
  ScopeAbortSlew;
  case FLastArrow of
    1: ArrowLeft.ArrowColor:=clBtnText;
    2: ArrowRight.ArrowColor:=clBtnText;
    3: ArrowUp.ArrowColor:=clBtnText;
    4: ArrowDown.ArrowColor:=clBtnText;
  end;
  FLastArrow:=0;
end;

procedure Tpop_scope.ArrowStopClick(Sender: TObject);
begin
 ScopeMoveAxis(0,'0');
 ScopeMoveAxis(1,'0');
 ScopeAbortSlew;
end;

procedure Tpop_scope.AscomDeviceChange(Sender: TObject);
begin
  csc.AscomDevice                 := AscomDevice.Text;
end;

procedure Tpop_scope.BtnDiscoverClick(Sender: TObject);
var i,j,n:integer;
    devtype: string;
begin
try
  Screen.Cursor:=crHourGlass;
  AlpacaServerList:=AlpacaDiscover(AlpacaDiscoveryPort.Value);
  n:=length(AlpacaServerList);
  AlpacaMountList.Clear;
  if n>0 then begin
    AlpacaMountList.Items.Add('Discovered telescope...');
    for i:=0 to length(AlpacaServerList)-1 do begin
      for j:=0 to AlpacaServerList[i].devicecount-1 do begin
        devtype:=UpperCase(AlpacaServerList[i].devices[j].DeviceType);
        if devtype='TELESCOPE' then begin
          AlpacaMountList.Items.Add(AlpacaServerList[i].devices[j].DeviceName+tab+AlpacaServerList[i].ip+tab+AlpacaServerList[i].port+tab+'telescope/'+tab+IntToStr(AlpacaServerList[i].devices[j].DeviceNumber));
        end;
      end;
    end;
    AlpacaMountList.ItemIndex:=0;
  end;
  if AlpacaMountList.Items.Count<2 then begin
    AlpacaMountList.Clear;
    AlpacaMountList.Items.Add('No Alpaca server found');
    AlpacaMountList.ItemIndex:=0;
  end;
finally
  Screen.Cursor:=crDefault;
end;
end;

procedure Tpop_scope.BtnGetClick(Sender: TObject);
begin
  mountsavedev := MountIndiDevice.Text;
  MountIndiDevice.Clear;
  receiveindidevice := False;
  indiclient := TIndiBaseClient.Create;
  indiclient.onNewDevice := @IndiNewDevice;
  indiclient.onServerDisconnected:=@IndiDisconnected;
  indiclient.SetServer(IndiServerHost.Text, IndiServerPort.Text);
  indiclient.ConnectServer;
  IndiTimer.Interval:=5000; // wait 5 sec for initial connection
  IndiTimer.Enabled := True;
  Screen.Cursor := crHourGlass;
end;

procedure Tpop_scope.BtnIndiGuiClick(Sender: TObject);
begin
  if not IndiGUIready then
  begin
    f_indigui := Tf_indigui.Create(self);
    ScaleDPI(f_indigui);
    f_indigui.onDestroy := @IndiGUIdestroy;
    f_indigui.IndiServer := csc.IndiServerHost;
    f_indigui.IndiPort := csc.IndiServerPort;
    f_indigui.IndiDevice := '';
    IndiGUIready := True;
  end;
  f_indigui.Show;
end;

procedure Tpop_scope.IndiNewDevice(dp: Basedevice);
begin
  IndiTimer.Interval:=1000; // wait for next device
  IndiTimer.Enabled:=false;
  IndiTimer.Enabled:=true;
  receiveindidevice := True;
end;

procedure Tpop_scope.IndiDisconnected(Sender: TObject);
begin
  IndiTimer.Interval:=100; // not connect, stop immediatelly
  IndiTimer.Enabled:=false;
  IndiTimer.Enabled:=true;
end;

procedure Tpop_scope.IndiGUIdestroy(Sender: TObject);
begin
  IndiGUIready := False;
end;

procedure Tpop_scope.IndiTimerTimer(Sender: TObject);
var
  i: integer;
  drint: word;
  var ok: boolean;
begin
  if not receiveindidevice then
  begin
    receiveindidevice := True;  // only one retry if no response
    exit;
  end;
  try
  IndiTimer.Enabled := False;
  try
  ok:= not ((indiclient=nil)or indiclient.Finished or indiclient.Terminated or (not indiclient.Connected));
  if ok then begin
  for i := 0 to indiclient.devices.Count - 1 do
  begin
    drint := BaseDevice(indiclient.devices[i]).getDriverInterface();
    if (drint and TELESCOPE_INTERFACE) <> 0 then
      MountIndiDevice.Items.Add(BaseDevice(indiclient.devices[i]).getDeviceName);
  end;
  if indiclient.Connected then
  begin
    Memomsg.Lines.Add(rsINDIready);
    indiclient.onServerDisconnected:=nil;
    indiclient.DisconnectServer;
    if MountIndiDevice.Items.Count > 0 then
      MountIndiDevice.ItemIndex := 0; // set first entry
    for i := 0 to MountIndiDevice.Items.Count - 1 do
      if MountIndiDevice.Items[i] = mountsavedev then
        MountIndiDevice.ItemIndex := i; // reset last entry
    csc.IndiDevice := MountIndiDevice.Text;
  end;
  ok:=MountIndiDevice.Items.Count > 0;
  end;
  if not ok then
  begin
    Memomsg.Lines.Add(rsConnectionTo);
    MountIndiDevice.Items.Add(mountsavedev);
    MountIndiDevice.ItemIndex := 0;
  end;
  except
  end;
  finally
    Screen.Cursor := crDefault;
  end;
end;

procedure Tpop_scope.AlpacaMountListChange(Sender: TObject);
var i: integer;
    lst:TStringList;
begin
  i:=AlpacaMountList.ItemIndex;
  if i>0 then begin
    lst:=TStringList.Create;
    SplitRec(AlpacaMountList.Items[i],tab,lst);
    ARestHost.Text:=lst[1];
    ARestPort.Text:=lst[2];
    ARestDevice.Value:=StrToInt(lst[4]);
    ARestProtocol.ItemIndex:=0;
    PanelCredential.Visible:=(ARestProtocol.ItemIndex=1);
    lst.Free;
  end;
end;

procedure Tpop_scope.ARestDeviceChange(Sender: TObject);
begin
  csc.AlpacaDevice                := ARestDevice.Value;
end;

procedure Tpop_scope.ARestHostChange(Sender: TObject);
begin
  csc.AlpacaHost                  := ARestHost.Text;
end;

procedure Tpop_scope.ARestPassChange(Sender: TObject);
begin
  csc.AlpacaPass                  := ARestPass.Text;
end;

procedure Tpop_scope.ARestPortChange(Sender: TObject);
begin
  csc.AlpacaPort                  := ARestPort.Value;
end;

procedure Tpop_scope.ButtonSetLocationClick(Sender: TObject);
begin
  if ScopeConnected then
  begin
    try
      Fmount.SetSite(Flongitude,Flatitude,FElevation);
    except
      on E: Exception do
        MessageDlg(format(DriverMsg,[E.Message]), mtWarning, [mbOK], 0);
    end;
  end;
end;

procedure Tpop_scope.ButtonSetTimeClick(Sender: TObject);
begin
  if ScopeConnected then
  begin
    try
      Fmount.SetDate(NowUTC,0);
    except
      on E: Exception do
        MessageDlg(format(DriverMsg,[E.Message]), mtWarning, [mbOK], 0);
    end;
  end;
end;

procedure Tpop_scope.UpdParkButton;
var ispark: boolean;
begin
  try
    if (not ScopeConnected) or (not FCanParkUnpark) then
    begin
      ButtonPark.Enabled := False;
      parkled.brush.color := clGray;
    end
    else
    begin
      ButtonPark.Enabled := True;
    end;
    if ScopeConnected and FCanParkUnpark then
    begin
      ispark:=Fmount.Park;
      if ispark then begin
        parkled.brush.color := clRed;
        ButtonPark.Caption := rsUnpark;
      end
      else begin
        parkled.brush.color := clLime;
        ButtonPark.Caption := rsPark;
      end;
    end;
  except
    on E: Exception do
      MessageDlg(format(DriverMsg,[E.Message]), mtWarning, [mbOK], 0);
  end;
end;

procedure Tpop_scope.UpdTrackingButton;
var tracking: boolean;
begin
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
      tracking := Fmount.Tracking;
      if tracking then
        Trackingled.brush.color := clLime
      else
        Trackingled.brush.color := clRed;
      if not FSlewing then begin
        ArrowLeft.ArrowColor:=clBtnText;
        ArrowRight.ArrowColor:=clBtnText;
        ArrowUp.ArrowColor:=clBtnText;
        ArrowDown.ArrowColor:=clBtnText;
      end;
    end
    else
      Trackingled.brush.color := clRed;
  except
    on E: Exception do
      MessageDlg(format(DriverMsg,[E.Message]), mtWarning, [mbOK], 0);
  end;
end;

procedure Tpop_scope.ButtonParkClick(Sender: TObject);
begin
  if ScopeConnected and FCanParkUnpark then
  begin
    try
      if ButtonPark.Caption = rsUnpark then begin
        Fmount.Park:=false;
      end
      else if ButtonPark.Caption = rsPark then begin
        if (MessageDlg(rsDoYouReallyW, mtConfirmation, mbYesNo, 0)=mrYes)
        then
           Fmount.Park:=true;
      end;
      UpdParkButton;
    except
      on E: Exception do
        MessageDlg(format(DriverMsg,[E.Message]), mtWarning, [mbOK], 0);
    end;
  end;
end;

procedure Tpop_scope.CheckBoxOnTopChange(Sender: TObject);
begin
 if CheckBoxOnTop.Checked then
   FormStyle:=fsStayOnTop
 else
   FormStyle:=fsNormal;
end;

procedure Tpop_scope.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  csc.TelescopeLeft               := left;
  csc.TelescopeTop                := top;
end;

procedure Tpop_scope.ButtonTrackingClick(Sender: TObject);
var tracking: boolean;
begin
  if ScopeConnected then
  begin
    try
      tracking:=Fmount.Tracking;
      if tracking then
        Fmount.AbortMotion
      else
        Fmount.Track;
      UpdTrackingButton;
    except
      on E: Exception do
        MessageDlg(format(DriverMsg,[E.Message]), mtWarning, [mbOK], 0);
    end;
  end;
end;

procedure Tpop_scope.ButtonAboutClick(Sender: TObject);
var
  buf: string;
  eq:double;
begin
  if ScopeConnected then begin
    try
      buf := Fmount.DeviceName;
      ScopeGetEqSys(eq);
      if eq=0 then buf := buf + crlf + 'EquatorialSystem=Jnow'
              else buf := buf + crlf + 'EquatorialSystem=J'+FormatFloat(f0,eq);
      buf:=buf+crlf+'Capabilities: '+Fmount.Capability;
    except
      on E: Exception do begin
        buf:=buf+crlf+'Error: ' + E.Message;
      end;
    end;
    ShowMessage(buf);
  end;
end;

initialization
{$ifdef mswindows}
{$if defined(cpui386) or defined(cpux86_64)}
// some Ascom driver raise this exceptions
SetExceptionMask([exInvalidOp, exDenormalized, exZeroDivide,exOverflow, exUnderflow, exPrecision]);
{$endif}
{$endif}

end.
