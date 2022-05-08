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
  cu_ascomrest, math, LCLIntf, u_util, u_constant, u_help, u_translation,
  Messages, SysUtils, Classes, Graphics, Controls,
  Forms, Dialogs, UScaleDPI, LazSysUtils, cu_alpacamanagement,
  StdCtrls, Buttons, inifiles, ComCtrls, Menus, ExtCtrls, Arrow, Spin;

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
    ButtonConnect: TButton;
    ButtonGetLocation: TSpeedButton;
    ButtonPark: TSpeedButton;
    CheckBoxOnTop: TCheckBox;
    elev: TEdit;
    GroupBox3: TGroupBox;
    ButtonAdvSetting: TSpeedButton;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label34: TLabel;
    Label35: TLabel;
    Label36: TLabel;
    Label39: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    PageControl1: TPageControl;
    Handpad: TPanel;
    PanelCredential: TPanel;
    Panel3: TPanel;
    parkled: TShape;
    ASCOMLocal: TTabSheet;
    ASCOMRemote: TTabSheet;
    FlipNS: TRadioGroup;
    ReadIntBox: TComboBox;
    StopMoveTimer: TTimer;
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
    Edit1: TEdit;
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
    procedure ARestProtocolChange(Sender: TObject);
    procedure ArrowMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure ArrowMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure ArrowStopClick(Sender: TObject);
    procedure BtnDiscoverClick(Sender: TObject);
    procedure ButtonGetLocationClick(Sender: TObject);
    procedure ButtonParkClick(Sender: TObject);
    procedure CheckBoxOnTopChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure kill(Sender: TObject; var CanClose: boolean);
    procedure ButtonAdvSettingClick(Sender: TObject);
    procedure PageControl1Changing(Sender: TObject; var AllowChange: Boolean);
    procedure StopMoveTimerTimer(Sender: TObject);
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
    procedure trackingledChangeBounds(Sender: TObject);
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
    hasSync: Boolean;
    FScopeEqSys: double;
    EqSysVal: integer;
    FScopeInterfaceVersion: integer;
    {$ifdef mswindows}
    T: variant;
    {$endif}
    TR: TAscomRest;
    Remote: boolean;
    FLongitude: double;                // Observatory longitude (Positive East of Greenwich}
    FLatitude: double;                 // Observatory latitude
    FElevation: double;                // Observatory elevation
    curdeg_x, curdeg_y: double;        // current equatorial position in degrees
    cur_az, cur_alt: double;           // current alt-az position in degrees
    FSlewing: boolean;
    FLastArrow: integer;
    FObservatoryCoord: TNotifyEvent;
    AlpacaServerList: TAlpacaServerList;
    DriverMsg: string;
    procedure SetDef(Sender: TObject);
    function ScopeConnectedReal: boolean;
    procedure ScopeGetAscomEquatorialSystem(var EqSys: double);
    procedure ScopeGetEqSysReal(var EqSys: double);
    function GetSlewing:boolean;
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
    procedure ScopeAlign(Source: string; ra, Dec: double);
    procedure ScopeGetRaDec(var ar, de: double; var ok: boolean);
    procedure ScopeGetAltAz(var alt, az: double; var ok: boolean);
    procedure ScopeGoto(ar, de: double; var ok: boolean);
    procedure ScopeAbortSlew;
    procedure ScopeReset;
    function ScopeInitialized: boolean;
    function ScopeConnected: boolean;
    procedure ScopeClose;
    function ScopeInterfaceVersion: integer;
    procedure ScopeReadConfig(ConfigPath: shortstring);
    procedure GetScopeRates(var nrates0, nrates1: integer; axis0rates, axis1rates: Pdoublearray); overload;
    procedure GetScopeRates(var nrates: integer; var rates: TStringList); overload;
    procedure ScopeMoveAxis(axis: integer; rate: double);
    property Longitude: double read FLongitude;
    property Latitude: double read FLatitude;
    property Elevation: double read FElevation;
    property Slewing: boolean read FSlewing;
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
var ok: boolean;
begin
  if ScopeInitialized then
  begin
    try
      {$ifdef mswindows}
      if not Remote then begin
        Curdeg_x := T.RightAscension * 15;
        Curdeg_y := T.Declination;
      end
      else
      {$endif}
      begin
        Curdeg_x:=TR.Get('rightascension').AsFloat * 15;
        Curdeg_y:=TR.Get('declination').AsFloat;
      end;
    except
      on E: Exception do begin
        MessageDlg(DriverMsg + ': ' + E.Message, mtWarning, [mbOK], 0);
        exit;
        end;
    end;
    if ShowAltAz.Checked then
    begin
      try
        {$ifdef mswindows}
        if not Remote then begin
          Cur_az := T.Azimuth;
          Cur_alt := T.Altitude;
        end
        else
        {$endif}
        begin
          Cur_az:=TR.Get('azimuth').AsFloat;
          Cur_alt:=TR.Get('altitude').AsFloat;
        end;
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

procedure Tpop_scope.ScopeDisconnect(var ok: boolean);
begin

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
    {$ifdef mswindows}
    if not Remote then begin
    if not VarIsEmpty(T) then
    begin
      T.connected := False;
      T := Unassigned;
    end;
    end
    else
    {$endif}
    begin
      // Send a disconnect, the server manage if it really disconnect the device or not
      TR.Put('Connected',false);
    end;
    ok := True;
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
  except
    on E: Exception do
      MessageDlg(DriverMsg + ': ' + E.Message, mtWarning, [mbOK], 0);
  end;

end;

procedure Tpop_scope.ScopeConnect(var ok: boolean);
var
  dis_ok,c_ok: boolean;
  nrates: integer;
  rates: TStringList;
  axis0rates, axis1rates: array of double;
begin
  led.brush.color := clRed;
  led.refresh;
  timer1.Enabled := False;
  ButtonSelect.Enabled := True;
  ok := False;
  CoordLock := False;
  Remote := (PageControl1.ActivePageIndex=1);
  try
    {$ifdef mswindows}
    if not Remote then begin
      DriverMsg:=rsFrom + ' ' + edit1.Text+':'+crlf+rsASCOMDriverE;
      if trim(edit1.Text) = '' then
         exit;
      T := Unassigned;
      T := CreateOleObject(WideString(edit1.Text));
      T.connected := True;
      c_ok := T.connected;
    end
    else
    {$endif}
    begin
      DriverMsg:=StringReplace(rsASCOMDriverE,' ASCOM ',' Alpaca ',[]);
      TR.Host:=ARestHost.Text;
      TR.Port:=ARestPort.Text;
      case ARestProtocol.ItemIndex of
        0: TR.Protocol:='http:';
        1: TR.Protocol:='https:';
      end;
      if (ARestUser.Text<>'')and(ARestPass.Text<>'') then begin
         TR.User:=ARestUser.Text;
         TR.Password:=ARestPass.Text;
      end;
      TR.Device:='telescope/'+ARestDevice.Text;
      TR.Timeout:=2000;
      TR.Put('Connected',true);
      c_ok := TR.Get('connected').AsBool;
      TR.Timeout:=60000;
    end;
    if c_ok then
    begin
      FConnected := True;
      Initialized := True;
      try
      FScopeInterfaceVersion:=ScopeInterfaceVersion;
      FCanSetTracking := false;
      FCanParkUnpark := false;
      hasSync := false;
      Handpad.Visible:=false;
      {$ifdef mswindows}
      if not Remote then begin
        if FScopeInterfaceVersion>1 then begin
          FCanSetTracking := T.CanSetTracking;
          FCanParkUnpark := T.CanPark and T.CanUnpark;
          Handpad.Visible:=T.CanMoveAxis(0) and T.CanMoveAxis(1);
        end;
        hasSync := T.CanSync;
      end
      else
      {$endif}
      begin
        if FScopeInterfaceVersion>1 then begin
          FCanSetTracking := TR.Get('cansettracking').AsBool;
          FCanParkUnpark := TR.Get('canpark').AsBool and TR.Get('canunpark').AsBool;
          Handpad.Visible:=TR.Get('canmoveaxis','Axis=0').AsBool and TR.Get('canmoveaxis','Axis=1').AsBool;
        end;
        hasSync := TR.Get('cansync').AsBool;
      end;
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
      ScopeGetEqSysReal(FScopeEqSys);
      ShowCoordinates;
      FSlewing:=GetSlewing;
      led.brush.color := clLime;
      ok := True;
      timer1.Enabled := True;
      ButtonConnect.Enabled := False;
      ButtonDisconnect.Enabled := True;
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
    on E: Exception do
      MessageDlg(DriverMsg + ': ' + E.Message, mtWarning, [mbOK], 0);
  end;
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
  try
    {$ifdef mswindows}
    if not Remote then begin
      Result := T.InterfaceVersion;
    end
    else
    {$endif}
    begin
      Result := TR.Get('interfaceversion').AsInt;
    end;
  except
    Result := 1;
  end;
end;

function Tpop_scope.ScopeConnectedReal: boolean;
begin
  Result := False;
  if not initialized then
    exit;
  Result := False;
  {$ifdef mswindows}
  if not Remote then begin
    if VarIsEmpty(T) then
       exit;
  end;
  {$endif}
  try
    {$ifdef mswindows}
    if not Remote then begin
       Result := T.connected;
    end
    else
    {$endif}
    begin
       Result := TR.Get('connected').AsBool;
    end;
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
      {$ifdef mswindows}
      if not Remote then begin
        if not T.tracking then
        begin
          if FCanSetTracking then
            T.tracking := True;
          UpdTrackingButton;
        end;
        T.SyncToCoordinates(Ra, Dec);
      end
      else
      {$endif}
      begin
        if not TR.Get('tracking').AsBool then
        begin
          if FCanSetTracking then
            TR.Put('Tracking',True);
          UpdTrackingButton;
        end;
        TR.Put('synctocoordinates',['RightAscension',FormatFloat(f6,Ra),'Declination',FormatFloat(f6,Dec)]);
      end;
    except
      on E: Exception do
        MessageDlg(DriverMsg + ': ' + E.Message, mtWarning, [mbOK], 0);
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

procedure Tpop_scope.ScopeGetAltAz(var alt, az: double; var ok: boolean);
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

procedure Tpop_scope.ScopeGetInfo(var scName: shortstring;
  var QueryOK, SyncOK, GotoOK: boolean; var refreshrate: integer);
begin
  if ScopeConnected then
  begin
    try
      {$ifdef mswindows}
      if not Remote then begin
        scname := T.Name;
        QueryOK := True;
        SyncOK := T.CanSync;
        GotoOK := T.CanSlew;
      end
      else
      {$endif}
      begin
        scname := TR.Get('name').AsString;
        QueryOK := True;
        SyncOK := TR.Get('cansync').AsBool;
        GotoOK := TR.Get('canslew').AsBool;
      end;
    except
      on E: Exception do
        MessageDlg(DriverMsg + ': ' + E.Message, mtWarning, [mbOK], 0);
    end;
  end
  else
  begin
    scname := '';
    QueryOK := False;
    SyncOK := False;
    GotoOK := False;
  end;
  refreshrate := timer1.interval
end;

procedure Tpop_scope.ScopeGetAscomEquatorialSystem(var EqSys: double);
var
  i: integer;
begin
  if ScopeConnected then
  begin
    try
    if FScopeInterfaceVersion>1 then begin
      {$ifdef mswindows}
      if not Remote then begin
         i := T.EquatorialSystem;
      end
      else
      {$endif}
      begin
        i := TR.Get('equatorialsystem').AsInt;
      end;
    end
    else i := 0;
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
      if FScopeInterfaceVersion>1 then begin
        {$ifdef mswindows}
        if not Remote then begin
           i := T.EquatorialSystem;
        end
        else
        {$endif}
        begin
          i := TR.Get('equatorialsystem').AsInt;
        end;
      end
      else i := 0;
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

procedure Tpop_scope.ScopeGoto(ar, de: double; var ok: boolean);
begin
  if not ScopeConnected then
    exit;
  try
    {$ifdef mswindows}
    if not Remote then begin
      if not T.tracking then
      begin
        T.tracking := True;
        UpdTrackingButton;
      end;
      if T.CanSlewAsync then begin
        FSlewing:=true;
        T.SlewToCoordinatesAsync(ar, de)
      end
      else
        T.SlewToCoordinates(ar, de);
    end
    else
    {$endif}
    begin
      if not TR.Get('tracking').AsBool then
      begin
        TR.Put('Tracking',True);
        UpdTrackingButton;
      end;
      if TR.Get('canslewasync').AsBool then begin
        FSlewing:=true;
        TR.Put('slewtocoordinatesasync',['RightAscension',FormatFloat(f6,ar),'Declination',FormatFloat(f6,de)])
      end
      else
        TR.Put('slewtocoordinates',['RightAscension',FormatFloat(f6,ar),'Declination',FormatFloat(f6,de)]);
    end;
  except
    on E: Exception do
      MessageDlg(DriverMsg + ': ' + E.Message, mtWarning, [mbOK], 0);
  end;
end;

function Tpop_scope.GetSlewing:boolean;
begin
 result:=false;
 try
 {$ifdef mswindows}
  if not Remote then begin
    if T.CanSlewAsync then
      result:=T.Slewing
    else
      result:=false;
  end
  else
  {$endif}
  begin
    if TR.Get('canslewasync').AsBool then
      result:=TR.Get('slewing').AsBool
    else
      result:=false;
  end;
  except
    on E: Exception do
      MessageDlg(DriverMsg + ': ' + E.Message, mtWarning, [mbOK], 0);
  end;
end;

procedure Tpop_scope.ScopeReadConfig(ConfigPath: shortstring);
begin
  ReadConfig(ConfigPath);
end;

procedure Tpop_scope.ScopeAbortSlew;
begin
  if ScopeConnected then
  begin
    try
      {$ifdef mswindows}
      if not Remote then begin
         T.AbortSlew;
      end
      else
      {$endif}
      begin
        TR.Put('abortslew');
      end;
    except
      on E: Exception do
        MessageDlg(DriverMsg + ': ' + E.Message, mtWarning, [mbOK], 0);
    end;
  end;
end;

procedure Tpop_scope.GetScopeRates(var nrates0, nrates1: integer;
  axis0rates, axis1rates: Pdoublearray);
var
  {$ifdef mswindows}
  rate, irate: variant;
  j, k: integer;
  {$endif}
  i : integer;
  x: IAxisRates;
begin
  SetLength(axis0rates^, 0);
  SetLength(axis1rates^, 0);
  nrates0 := 0;
  nrates1 := 0;
  if ScopeConnected then
  begin
    try
    {$ifdef mswindows}
    if not Remote then begin
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
    end else
    {$endif}
    begin
      x:=TR.GetAxisRates('0');
      nrates0:=Length(x);
      SetLength(axis0rates^, 2*nrates0);
      for i:=0 to nrates0-1 do begin
        axis0rates^[2*i]   := x[i].Minimum;
        axis0rates^[2*i+1] := x[i].Maximum;
        x[i].Free;
      end;
      x:=TR.GetAxisRates('1');
      nrates1:=Length(x);
      SetLength(axis1rates^, 2*nrates1);
      for i:=0 to nrates1-1 do begin
        axis1rates^[2*i]   := x[i].Minimum;
        axis1rates^[2*i+1] := x[i].Maximum;
        x[i].Free;
      end;
    end;
    except
      // unsupported by interface V1
    end;
  end;

end;

procedure Tpop_scope.GetScopeRates(var nrates: integer; var rates: TStringList);
var
  i, j, n0, n1: integer;
  ax0r, ax1r: array of double;
  min, max, step, rate, x: double;
begin
  n0 := 0;
  n1 := 0;
  if ScopeInterfaceVersion>1 then begin
    GetScopeRates(n0, n1, @ax0r, @ax1r);
    if n0 >= 1 then
    begin
      for i := 0 to (n0 div 2) - 1 do
      begin
        min := ax0r[2 * i];
        max := ax0r[2 * i + 1];
        if min = max then
          rates.Add(formatfloat(f4s, min))
        else
        begin
          step := (max - min) / 3;
          for j := 0 to 3 do
          begin
            rate := min + j * step;
            if (i=0) and (rate = 0) and (max > 0.15) then
            begin  // add slow speed 2x ->32x sidereal
              rates.add('0.0083');  // 2x
              rates.add('0.0333');  // 8x
              rates.add('0.1333');  //32x
              x := step / 2;
              if step > 0.3 then
                rates.add(formatfloat('0.0000', x));
            end
            else if rate > 0 then
              rates.add(formatfloat('0.0000', rate));
          end;
        end;
      end;
    end
    else begin
      rates.add('Error getting supported rates!');
    end;
  end
  else begin
    rates.add('Unsupported by V1 driver!');
  end;
  nrates := rates.Count;
end;

procedure Tpop_scope.ScopeMoveAxis(axis: integer; rate: double);
begin
  if ScopeConnected then
  begin
    try
    {$ifdef mswindows}
    if not Remote then begin
      if T.CanMoveAxis(axis) then
      begin
        T.MoveAxis(axis, rate);
      end;
    end
    else
    {$endif}
    begin
      if TR.Get('canmoveaxis','Axis='+IntToStr(axis)).AsBool then
      begin
        TR.Put('moveaxis',['Axis',IntToStr(axis),'Rate',FormatFloat(f6,rate)]);
      end;
    end;
    except
      // unsupported by interface V1
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
  CheckBoxOnTop.Caption := rsAlwaysOnTop;
  ButtonConnect.Caption := rsConnect;
  ButtonDisconnect.Caption := rsDisconnect;
  ButtonHide.Caption := rsHide;
  ButtonAdvSetting.Caption := rsAdvancedSett2;
  Label4.Caption:=rsSpeed;
  flipns.Hint:=rsFlipNSMoveme;

  SetHelp(self, hlpASCOM);
end;

function Tpop_scope.ReadConfig(ConfigPath: shortstring): boolean;
var
  ini: tinifile;
  nom: string;
const
  {$ifdef mswindows}
  default_remote=0;
  {$else}
  default_remote=1;
  {$endif}
begin
  Result := DirectoryExists(ConfigPath);
  if Result then
    FConfig := slash(ConfigPath) + 'scope.ini'
  else
    FConfig := slash(extractfilepath(ParamStr(0))) + 'scope.ini';
  ini := tinifile.Create(FConfig);
  nom := ini.readstring('Ascom', 'name', '');
  edit1.Text := nom;
  EqSysVal := ini.ReadInteger('Ascom', 'EqSys', 0);
  ForceEqSys := ini.ReadBool('Ascom', 'ForceEqSys', False);
  ShowAltAz.Checked := ini.ReadBool('Ascom', 'AltAz', False);
  ReadIntBox.Text := ini.readstring('Ascom', 'read_interval', '1000');
  {$ifdef mswindows}
  PageControl1.ActivePageIndex := ini.ReadInteger('AscomRemote', 'remote', default_remote);
  {$else}
  PageControl1.ActivePageIndex := default_remote;
  {$endif}
  ARestProtocol.ItemIndex := ini.ReadInteger('AscomRemote', 'protocol', 0);
  PanelCredential.Visible:=(ARestProtocol.ItemIndex=1);
  ARestHost.Text := ini.readstring('AscomRemote', 'host', '127.0.0.1');
  ARestPort.Value := ini.ReadInteger('AscomRemote', 'port', 11111);
  ARestUser.Text := DecryptStr(hextostr(ini.readstring('AscomRemote', 'u', '')), encryptpwd);
  ARestPass.Text := DecryptStr(hextostr(ini.readstring('AscomRemote', 'p', '')), encryptpwd);
  ARestDevice.Value := ini.ReadInteger('AscomRemote', 'device', 0);
  lat.Text := ini.readstring('observatory', 'latitude', '0');
  long.Text := ini.readstring('observatory', 'longitude', '0');
  FormPos(self, ini.ReadInteger('Position', 'left', left), ini.ReadInteger('Position', 'top', top), False);
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
    if ScopeConnected then ScopeGetEqSysReal(FScopeEqSys);
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

procedure Tpop_scope.PageControl1Changing(Sender: TObject; var AllowChange: Boolean);
begin
  AllowChange:=not FConnected;
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
  FSlewing := false;
  TR:=TAscomRest.Create(self);
  TR.ClientId:=3292;
  FLastArrow:=0;
  DriverMsg:=rsASCOMDriverE;
  {$ifndef mswindows}
  ASCOMLocal.TabVisible:=false;
  {$endif}
end;

procedure Tpop_scope.FormShow(Sender: TObject);
begin
 if ButtonConnect.Enabled then ActiveControl:=ButtonConnect;
end;

procedure Tpop_scope.Timer1Timer(Sender: TObject);
var ok: boolean;
begin
  FConnected := ScopeConnectedReal;
  if not FConnected then begin
    ScopeDisconnect(ok);
    ShowMessage('Telescope disconnected on it''s own!');
    exit;
  end;
  try
    if (not CoordLock) then
    begin
      CoordLock := True;
      timer1.Enabled := False;
      ShowCoordinates;
      FSlewing:=GetSlewing;
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
  ini.writeinteger('AscomRemote', 'remote', PageControl1.ActivePageIndex);
  ini.writeinteger('AscomRemote', 'protocol', ARestProtocol.ItemIndex);
  ini.writestring('AscomRemote', 'host', ARestHost.Text);
  ini.WriteInteger('AscomRemote', 'port', ARestPort.Value);
  ini.writeinteger('AscomRemote', 'device', ARestDevice.Value);
  ini.writestring('AscomRemote', 'u', strtohex(encryptStr(ARestUser.Text, encryptpwd)));
  ini.writestring('AscomRemote', 'p', strtohex(encryptStr(ARestPass.Text, encryptpwd)));
  ini.writestring('observatory', 'latitude', lat.Text);
  ini.writestring('observatory', 'longitude', long.Text);
  ini.WriteInteger('Position', 'top', top);
  ini.WriteInteger('Position', 'left', left);
  ini.UpdateFile;
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
    on E: Exception do
      MessageDlg(DriverMsg + ': ' + E.Message, mtWarning, [mbOK], 0);
  end;
{$endif}
end;

procedure Tpop_scope.ButtonGetLocationClick(Sender: TObject);
begin
  if ScopeConnected then
  begin
    try
      {$ifdef mswindows}
      if not Remote then begin
        Flongitude := T.SiteLongitude;
        Flatitude := T.SiteLatitude;
        FElevation := T.SiteElevation;
      end
      else
      {$endif}
      begin
        Flongitude := TR.Get('sitelongitude').AsFloat;
        Flatitude := TR.Get('sitelatitude').AsFloat;
        FElevation := TR.Get('siteelevation').AsFloat;
      end;
      lat.Text := detostr(Flatitude);
      long.Text := detostr(Flongitude);
      elev.Text := FormatFloat(f1,FElevation);
      if assigned(FObservatoryCoord) then
        FObservatoryCoord(self);
    except
      on E: Exception do
        MessageDlg(DriverMsg + ': ' + E.Message, mtWarning, [mbOK], 0);
    end;
  end;
end;

procedure Tpop_scope.ARestProtocolChange(Sender: TObject);
begin
  case ARestProtocol.ItemIndex of
    0: ARestPort.Value:=11111;
    1: ARestPort.Value:=443;
  end;
  PanelCredential.Visible:=(ARestProtocol.ItemIndex=1);
end;

procedure Tpop_scope.ArrowMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var rate,flip: double;
begin
  rate:=StrToFloatDef(AxisRates.Text,0);  // deg/sec
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
         1: ScopeMoveAxis(0,-rate);//Left
         2: ScopeMoveAxis(0,rate); //Right
         3: ScopeMoveAxis(1,flip*rate); //Up
         4: ScopeMoveAxis(1,-flip*rate);//Down
      end;
    end;
  end;
end;

procedure Tpop_scope.ArrowMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  // let enough time if moveaxis is still not started
  if Remote then StopMoveTimer.Interval:=1000
            else StopMoveTimer.Interval:=100;
  StopMoveTimer.Enabled:=true;
end;

procedure Tpop_scope.StopMoveTimerTimer(Sender: TObject);
begin
  StopMoveTimer.Enabled:=false;
  ScopeMoveAxis(0,0);
  ScopeMoveAxis(1,0);
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
 ScopeMoveAxis(0,0);
 ScopeMoveAxis(1,0);
 ScopeAbortSlew;
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

procedure Tpop_scope.ButtonSetLocationClick(Sender: TObject);
begin
  if ScopeConnected then
  begin
    try
      {$ifdef mswindows}
      if not Remote then begin
        T.SiteLongitude := Flongitude;
        T.SiteLatitude := Flatitude;
        T.SiteElevation := FElevation;
      end
      else
      {$endif}
      begin
        TR.Put('SiteLongitude',Flongitude);
        TR.Put('SiteLatitude',Flatitude);
        TR.Put('SiteElevation',FElevation);
      end;
    except
      on E: Exception do
        MessageDlg(DriverMsg + ': ' + E.Message, mtWarning, [mbOK], 0);
    end;
  end;
end;

procedure Tpop_scope.ButtonSetTimeClick(Sender: TObject);
var
  buf: string;
  {$ifdef mswindows}
  dt: TDateTime;
  {$endif}
begin
  if ScopeConnected then
  begin
    try
      {$ifdef mswindows}
      if not Remote then begin
        dt:=NowUTC;
        T.UTCDate :=VarFromDateTime(dt);
      end
      else
      {$endif}
      begin
        buf:=FormatDateTime(dateiso,NowUTC)+'Z';
        TR.Put('UTCDate',buf);
      end;
    except
      on E: Exception do
        MessageDlg(DriverMsg + ': ' + E.Message, mtWarning, [mbOK], 0);
    end;
  end;
end;

procedure Tpop_scope.FormDestroy(Sender: TObject);
begin
  SaveConfig;
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
      {$ifdef mswindows}
      if not Remote then begin
        ispark:=T.AtPark;
      end
      else
      {$endif}
      begin
        ispark:=TR.Get('atpark').AsBool;
      end;
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
      MessageDlg(DriverMsg + ': ' + E.Message, mtWarning, [mbOK], 0);
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
      {$ifdef mswindows}
      if not Remote then begin
        tracking := T.Tracking;
      end
      else
      {$endif}
      begin
        tracking := TR.Get('tracking').AsBool;
      end;
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
      MessageDlg(DriverMsg + ': ' + E.Message, mtWarning, [mbOK], 0);
  end;
end;

procedure Tpop_scope.ButtonParkClick(Sender: TObject);
begin
  if ScopeConnected and FCanParkUnpark then
  begin
    try
      {$ifdef mswindows}
      if not Remote then begin
        if ButtonPark.Caption = rsUnpark then begin
          if T.CanUnpark then
             T.Unpark;
        end
        else if ButtonPark.Caption = rsPark then begin
          if T.CanPark and (MessageDlg(rsDoYouReallyW, mtConfirmation, mbYesNo, 0)=mrYes)
          then
             T.Park;
        end;
      end
      else
      {$endif}
      begin
        if ButtonPark.Caption = rsUnpark then begin
          if TR.Get('canunpark').AsBool then
             TR.Put('unpark');
        end
        else if ButtonPark.Caption = rsPark then begin
          if TR.Get('canpark').AsBool and (MessageDlg(rsDoYouReallyW, mtConfirmation, mbYesNo, 0)=mrYes)
          then
             TR.Put('park');
        end;
      end;
      UpdParkButton;
    except
      on E: Exception do
        MessageDlg(DriverMsg + ': ' + E.Message, mtWarning, [mbOK], 0);
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

procedure Tpop_scope.ButtonTrackingClick(Sender: TObject);
var tracking: boolean;
begin
  if ScopeConnected then
  begin
    try
      {$ifdef mswindows}
      if not Remote then begin
        tracking := T.Tracking;
        T.Tracking := not tracking;
      end
      else
      {$endif}
      begin
        tracking := TR.Get('tracking').AsBool;
        TR.Put('Tracking',not tracking);
      end;
      UpdTrackingButton;
    except
      on E: Exception do
        MessageDlg(DriverMsg + ': ' + E.Message, mtWarning, [mbOK], 0);
    end;
  end;
end;

procedure Tpop_scope.trackingledChangeBounds(Sender: TObject);
begin

end;

procedure Tpop_scope.ButtonAboutClick(Sender: TObject);
{$ifdef mswindows}
var
  buf: string;
  cleanup: boolean;
  eq:double;
{$endif}
begin
{$ifdef mswindows}
  try
    cleanup:=false;
    if (edit1.Text > '') then
    begin
      try
        if VarIsEmpty(T) then
        begin
          T := CreateOleObject(WideString(edit1.Text));
          cleanup:=true;
        end;
        buf := edit1.text;
        buf := buf + crlf + T.Description;
        buf := buf + crlf + T.DriverInfo;
        if ScopeConnected then begin
          ScopeGetAscomEquatorialSystem(eq);
          if eq=0 then buf := buf + crlf + 'EquatorialSystem=Jnow'
                  else buf := buf + crlf + 'EquatorialSystem=J'+FormatFloat(f0,eq);
          if ForceEqSys then begin
            ScopeGetEqSysReal(eq);
            if eq=0 then buf := buf + ', Forced to Jnow'
                    else buf := buf + ', Forced to J'+FormatFloat(f0,eq);
          end;
          buf:=buf+crlf+'Interface version: '+IntToStr(FScopeInterfaceVersion);
          buf:=buf+crlf+'Capabilities:';
          if FCanSetTracking then buf:=buf+' SetTracking';
          if FCanParkUnpark then buf:=buf+' ParkUnpark';
          if hasSync then buf:=buf+' CanSync';
          if Handpad.Visible then buf:=buf+' MoveAxis';
        end;
        ShowMessage(buf);
        UpdTrackingButton;
        if cleanup then T := Unassigned;
      except
        on E: Exception do begin
          buf:=buf+crlf+'Error: ' + E.Message;
          ShowMessage(buf);
          if cleanup then T := Unassigned;
        end;
      end;
    end;
  except
    on E: Exception do
      MessageDlg(DriverMsg + ': ' + E.Message, mtWarning, [mbOK], 0);
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
