unit lx2001;

{
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
}

{------------- interface for LX200 system. ----------------------------
Contribution from :
PJ Pallez Nov 1999
Patrick Chevalley Oct 2000
Renato Bonomini Jul 2004

will work with all systems using same protocol
(LX200,AutoStar,..)

-------------------------------------------------------------------------------}

interface

uses
  Windows,  Messages, SysUtils, Classes, Graphics, Controls,
  Forms, Dialogs, ShellAPI,
  StdCtrls, Buttons, inifiles, ComCtrls, Menus, ExtCtrls,
  enhedits, HiResTim;

type
  Tpop_scope = class(TForm)
    PageControl1: TPageControl;
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
    Timer1: THiResTimer;
     SpeedButton4: TSpeedButton;
     SpeedButton8: TSpeedButton;
     SpeedButton9: TSpeedButton;
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
     {Utility and form functions}
     procedure formcreate(Sender: TObject);
     procedure kill(Sender: TObject; var CanClose: Boolean);
     procedure Timer1Timer(Sender: TObject);
     procedure setresClick(Sender: TObject);
     function str2ra(s:string):double;
     function str2dec(s:string):double;
     procedure SaveButton1Click(Sender: TObject);
     procedure ReadIntBoxChange(Sender: TObject);
     procedure latChange(Sender: TObject);
     procedure longChange(Sender: TObject);
     procedure SpeedButton5Click(Sender: TObject);
     procedure SpeedButton2Click(Sender: TObject);
     procedure TopBtnMouseDown(Sender: TObject; Button: TMouseButton;
       Shift: TShiftState; X, Y: Integer);
     procedure TopBtnMouseUp(Sender: TObject; Button: TMouseButton;
       Shift: TShiftState; X, Y: Integer);
     procedure BotBtnMouseDown(Sender: TObject; Button: TMouseButton;
       Shift: TShiftState; X, Y: Integer);
     procedure LeftBtnMouseDown(Sender: TObject; Button: TMouseButton;
       Shift: TShiftState; X, Y: Integer);
     procedure RightBtnMouseDown(Sender: TObject; Button: TMouseButton;
       Shift: TShiftState; X, Y: Integer);
     procedure StopBtnMouseDown(Sender: TObject; Button: TMouseButton;
       Shift: TShiftState; X, Y: Integer);
     procedure RadioGroup2Click(Sender: TObject);
     procedure RightBtnMouseUp(Sender: TObject; Button: TMouseButton;
       Shift: TShiftState; X, Y: Integer);
     procedure BotBtnMouseUp(Sender: TObject; Button: TMouseButton;
       Shift: TShiftState; X, Y: Integer);
     procedure LeftBtnMouseUp(Sender: TObject; Button: TMouseButton;
       Shift: TShiftState; X, Y: Integer);
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
       Shift: TShiftState; X, Y: Integer);
     procedure SpeedButton6MouseDown(Sender: TObject; Button: TMouseButton;
       Shift: TShiftState; X, Y: Integer);
     procedure SpeedButton7MouseDown(Sender: TObject; Button: TMouseButton;
       Shift: TShiftState; X, Y: Integer);
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

{$R *.DFM}
 uses
    lx200_lib,
    serial;
//    skylib;

var CoordLock : boolean = false;
    Initial : boolean = true;
    Appdir : string;

const crlf=chr(10)+chr(13);

{-------------------------------------------------------------------------------

                       Cartes du Ciel Dll functions

--------------------------------------------------------------------------------}
Procedure ShowCoordinates;
var s1,s2,s3 : string;
begin
with pop_scope do begin
   if ScopeInitialized then begin
      LX200_QueryEQ(Curdeg_x,Curdeg_y);
      if ShowAltAz.checked then LX200_QueryAz(Cur_az,Cur_alt);
      case RadioGroup2.ItemIndex of
      0: begin
         pos_x.text := armtostr(Curdeg_x/15,s1,s2);
         pos_y.text := demtostr(Curdeg_y,s1,s2);
         if ShowAltAz.checked then begin
            az_x.text  := demtostr(Cur_az,s1,s2);
            alt_y.text := demtostr(Cur_alt,s1,s2);
            end else begin
            az_x.text  := '';
            alt_y.text := '';
            end;
         end;
      1: begin
         pos_x.text := artostr(Curdeg_x/15,s1,s2,s3);
         pos_y.text := detostr(Curdeg_y,s1,s2,s3);
         if ShowAltAz.checked then begin
            az_x.text  := detostr(Cur_az,s1,s2,s3);
            alt_y.text := detostr(Cur_alt,s1,s2,s3);
            end else begin
            az_x.text  := '';
            alt_y.text := '';
            end;
         end;
      end;
      if ShowAltAz.checked and (Cur_alt<0) then alt_y.Color:=clRed else alt_y.Color:=clWindow;
   end else begin
      pos_x.text := '';
      pos_y.text := '';
      az_x.text  := '';
      alt_y.text := '';
   end;
{   pos_x.refresh;
   pos_y.refresh;
   az_x.refresh;
   alt_y.refresh;}
end;
end;

procedure ChangeButton(onoff : boolean);
begin
with pop_scope do begin
CheckBox1.enabled:=onoff;
Button3.enabled:=onoff;
SpeedButton3.enabled:=onoff;
RadioGroup1.enabled:=onoff;
LeftBtn.enabled:=onoff;
TopBtn.enabled:=onoff;
RightBtn.enabled:=onoff;
BotBtn.enabled:=onoff;
StopBtn.enabled:=onoff;
// RB: Lx200 16"GPS and others
LxPecToggle.Enabled:=onoff;
TrackingGroup.Enabled:=onoff;
TrackingDefaultButton.Enabled:=onoff;
TrackingLunarButton.Enabled:=onoff;
TrackingCustomButton.Enabled:=onoff;
TrackingGetButton.Enabled:=onoff;
TrackingSetRateButton.Enabled:=onoff;
TrackingRateEdit.Enabled:=onoff;
TrackingRateIncrease.Enabled:=onoff;
TrackingRateDecrease.Enabled:=onoff;
DECPECOn.Enabled:=onoff;
DECPECOff.Enabled:=onoff;
RAPECOn.Enabled:=onoff;
RAPECOff.Enabled:=onoff;
DECSlewRate.Enabled:=onoff;
DECSlewRateSet.Enabled:=onoff;
LxGuideRate.Enabled:=onoff;
LxGuideRateSet.Enabled:=onoff;
RASlewRate.Enabled:=onoff;
RASlewRateSet.Enabled:=onoff;
SlewSpeedGroup.Enabled:=onoff;
SlewSpeedBar.Enabled:=onoff;
end;
end;

procedure ScopeChangeButton(onoff : boolean);
begin
with pop_scope do begin
// Virthp
HandPadModeSelection.Enabled:=onoff;
LRModeGroup.Enabled:=onoff;
// Speeds
ScopeSpeeds.Enabled:=onoff;
if onoff = true then
begin
        MsArcSec.Value:=LX200_Scope_GetMsArcSec;
        GuideArcSec.Value:=LX200_Scope_GetGuideArcSec;
end;
MsArcSec.Enabled:=onoff;
GuideArcSec.Enabled:=onoff;
// Init
ScopeInit.Enabled:=onoff;
// FR
FieldRotationGroup.Enabled:=onoff;
FieldRotation.Enabled:=onoff;
FRQuery.Enabled:=onoff;
end;
end;

Procedure ScopeConnect(var ok : boolean); stdcall;
begin
pop_scope.led.color:=clRed;
pop_scope.led.refresh;
pop_scope.timer1.enabled:=false;
ok:=false;
if LX200_Open(trim(pop_scope.cbo_type.text),trim(pop_scope.cbo_port.text),pop_scope.PortSpeedbox.text,pop_scope.Paritybox.text,pop_scope.DatabitBox.text,pop_scope.StopbitBox.text,pop_scope.TimeOutBox.text,pop_scope.IntTimeOutBox.text) then begin
   LX200_SetFormat(pop_scope.radiogroup2.ItemIndex);
   ShowCoordinates;
   pop_scope.led.color:=clLime;
   ok:=true;
   pop_scope.timer1.enabled:=true;
   ChangeButton(true);
   pop_scope.cbo_type.enabled:=false;
   if pop_scope.checkBox1.Checked then pop_scope.HPP.text:=LX200_QueryHighPrecision;
   if LX200_UseHPP then begin
     pop_scope.GroupBox6.visible:=true;
   end else begin
     pop_scope.GroupBox6.visible:=false;
   end;
   // Renato Bonomini:
   if pop_scope.cbo_type.Text = 'Scope.exe' then ScopeChangeButton(true);
end else begin
    LX200_Close;
    pop_scope.formstyle:=fsNormal;
    ShowMessage('Error opening '+pop_scope.cbo_type.text+' on port '+pop_scope.cbo_port.text+crlf+'Check if device is connected and power on');
    pop_scope.formstyle:=fsStayOnTop;
    ChangeButton(false);
    // Renato Bonomini:
    if pop_scope.cbo_type.Text = 'Scope.exe' then ScopeChangeButton(false);
    pop_scope.cbo_type.enabled:=true;
end;
end;

Procedure ScopeDisconnect(var ok : boolean); stdcall;
begin
pop_scope.pos_x.text:='';
pop_scope.pos_y.text:='';
pop_scope.az_x.text:='';
pop_scope.alt_y.text:='';
ok:=LX200_Close;
pop_scope.led.color:=clRed;
ChangeButton(false);
pop_scope.cbo_type.enabled:=true;
// Renato Bonomini:
if pop_scope.cbo_type.Text = 'Scope.exe' then ScopeChangeButton(false);
end;

Procedure ScopeClose; stdcall;
begin
//pop_scope.close;
pop_scope.release;
end;

Function  ScopeConnected : boolean ; stdcall;
begin
result:=LX200_opened;
end;

Function  ScopeInitialized : boolean ; stdcall;
begin
result:= ScopeConnected;
end;

Procedure ScopeAlign(source : string; ra,dec : double); stdcall;
begin
LX200_SyncPos(RA*15,DEC);
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
   ar:=Curdeg_x/15;
   de:=Curdeg_y;
   ok:=true;
//      ok:=LX200_QueryEQ(ar,de);
//      ar:=ar/15;
end else ok:=false;
end;

Procedure ScopeGetAltAz(var alt,az : double; var ok : boolean); stdcall;
begin
if ScopeConnected then begin
   az:=cur_az;
   alt:=cur_alt;
   ok:=true;
//   ok:=LX200_QueryAZ(az,alt);
end else ok:=false;
end;

Procedure ScopeGetInfo(var Name : shortstring; var QueryOK,SyncOK,GotoOK : boolean; var refreshrate : integer); stdcall;
begin
if (pop_scope=nil)or(pop_scope.pos_x=nil) then begin
   decimalseparator:='.';
   pop_scope:=Tpop_scope.Create(nil);
end;
// Renato added model 5
if (pop_scope.cbo_type.text=validModel[1])or(pop_scope.cbo_type.text=validModel[2])or(pop_scope.cbo_type.text=validModel[5]) then begin // lx200, autostar, scope.exe
       name:=pop_scope.cbo_type.text;
       QueryOK:=true;
       SyncOK:=true;
       GotoOK:=true;
end else if (pop_scope.cbo_type.text=validModel[3])or(pop_scope.cbo_type.text=validModel[4]) then begin  // magellan
       name:=pop_scope.cbo_type.text;
       QueryOK:=true;
       SyncOK:=false;
       GotoOK:=false;
end;
refreshrate:=pop_scope.timer1.interval;
end;

Procedure ScopeReset; stdcall;
begin
end;

Procedure ScopeSetObs(la,lo : double); stdcall;
begin
pop_scope.lat.text:=floattostr(la);
pop_scope.long.text:=floattostr(lo);
latitude:=la;
//ObsLatitude:=la;
longitude:=lo;
//ObsLongitude:=lo;
LX200_SetObs( La,Lo,1,now);
end;

Procedure ScopeGoto(ar,de : double; var ok : boolean); stdcall;
begin
ok:=LX200_Goto(ar*15,de);
end;

{-------------------------------------------------------------------------------

                                  Utility functions

--------------------------------------------------------------------------------}

function tpop_scope.str2ra(s:string):double;
var
h,m,ss:integer;
begin
     h:=strtoint(copy(s,19,2));
     m:=strtoint(copy(s,22,2));
     ss:=strtoint(copy(s,25,1)); // tenth of minute
     result:=15*((h)+(m/60)+(ss/600));
end;

function tpop_scope.str2dec(s:string):double;
var
sgn,d,m :integer;
begin
     d:=strtoint(copy(s,27,3)); if d < 0 then sgn:=-1 else sgn:= 1;
     m:=strtoint(copy(s,31,2));
     result:=sgn*(abs(d)+(m/60));
end;

{-------------------------------------------------------------------------------

                                  Form functions

--------------------------------------------------------------------------------}

procedure Tpop_scope.formcreate(Sender: TObject);
var ini:tinifile;
    buf,nom : string;
    av : boolean;
begin
     Getdir(0,appdir);
     buf:=extractfilepath(paramstr(0));
     ini:=tinifile.create(buf+'scope.ini');
     nom:= ini.readstring('lx200','name','LX200');
     cbo_type.text:=nom;
     cbo_type.ItemIndex:=ini.readinteger('lx200','model',0);
     ReadIntBox.text:=ini.readstring('lx200','read_interval','1000');
     cbo_port.text:=ini.readstring('lx200','comport','COM1');
     if strtoint(copy(cbo_port.text,4,1))>4 then cbo_port.text:='COM1';
     PortSpeedbox.text:=ini.readstring('lx200','baud','9600');
     DatabitBox.text:=ini.readstring('lx200','databits','8');
     Paritybox.text:=ini.readstring('lx200','parity','N');
     StopbitBox.text:=ini.readstring('lx200','stopbits','1');
     TimeOutBox.text:=ini.readstring('lx200','timeout','1000');
     IntTimeOutBox.text:=ini.readstring('lx200','inttimeout','100');
     checkBox1.Checked:=ini.ReadBool('lx200','hpp',false);
     ShowAltAz.Checked:=ini.ReadBool('lx200','AltAz',false);
     av:=ini.ReadBool('lx200','AlwaysVisible',true);
     checkBox3.Checked:=ini.ReadBool('lx200','SwapNS',false);
     checkBox4.Checked:=ini.ReadBool('lx200','SwapEW',false);
     lat.text:=ini.readstring('observatory','latitude','0');
     long.text:=ini.readstring('observatory','longitude','0');
     radiogroup5.ItemIndex:=ini.readinteger('lx200','focusmodel',0);
     radiogroup3.ItemIndex:=ini.readinteger('lx200','focusspeed1',0);
     radiogroup4.ItemIndex:=ini.readinteger('lx200','focusspeed2',1);
     checkbox6.Checked:=ini.ReadBool('lx200','focuspulse',false);
     longedit1.Value:=ini.readinteger('lx200','focusduration',100);
     ini.free;
     Timer1.Interval:=strtointdef(ReadIntBox.text,500);
     // Renato Bonomini:
     MsArcSecLabel.Caption:='Microstep'#13#10'[arc"/s]';
     GuideArcSecLabel.Caption:='Guide'#13#10'[arc"/s]';

checkbox2.checked:=av;

if cbo_type.text='LX200' then begin
  PortSpeedbox.itemindex:=5;
  ShowAltAz.checked:=false;
  ShowAltAz.enabled:=true;
  GroupBox1.visible:=true;
  RadioGroup2.visible:=true;
  GroupBox5.visible:=true;
  GroupBox7.visible:=true;
  if LX200_UseHPP then GroupBox6.visible:=true;
  SpeedButton8.visible:=true;
  SpeedButton9.visible:=true;
  Radiogroup1.Items.Clear;
  Radiogroup1.Items.Add('Slew');
  Radiogroup1.Items.Add('Find');
  Radiogroup1.Items.Add('Centering');
  Radiogroup1.Items.Add('Guide');
  Radiogroup1.ItemIndex:=1;
// Renato Bonomini:
end else if cbo_type.text='Scope.exe' then begin
  PortSpeedbox.itemindex:=5;
  ShowAltAz.checked:=true;
  ShowAltAz.enabled:=true;
  GroupBox1.visible:=true;
  RadioGroup2.visible:=true;
  GroupBox5.visible:=true;
  GroupBox7.visible:=false;
  // if LX200_UseHPP then GroupBox6.visible:=true; //
  Radiogroup1.Items.Clear;
  Radiogroup1.Items.Add('Slew');
  Radiogroup1.Items.Add('Find');
  Radiogroup1.Items.Add('Centering');
  Radiogroup1.Items.Add('Guide');
  Radiogroup1.ItemIndex:=1;
  VirtHP.TabVisible:=True;
  Adv.TabVisible:=True;
  FRAngle.Visible:=True;
  FRQuery.Visible:=True;
  FRLabel.Visible:=True;
  SpeedButton8.visible:=true;
  SpeedButton9.visible:=true;
end else if cbo_type.text='AutoStar' then begin
  PortSpeedbox.itemindex:=5;
  ShowAltAz.checked:=false;
  ShowAltAz.enabled:=true;
  GroupBox1.visible:=true;
  RadioGroup2.visible:=true;
  GroupBox5.visible:=true;
  GroupBox7.visible:=false;
  GroupBox6.visible:=false;
  LX200_UseHPP:=false;
  SpeedButton8.visible:=true;
  SpeedButton9.visible:=true;
  Radiogroup1.Items.Clear;
  Radiogroup1.Items.Add('Highest');
  Radiogroup1.Items.Add('Middle');
  Radiogroup1.Items.Add('Slowest');
  Radiogroup1.ItemIndex:=1;
end else if cbo_type.text='Magellan-II' then begin
  PortSpeedbox.itemindex:=1;
  ShowAltAz.checked:=false;
  ShowAltAz.enabled:=false;
  GroupBox1.visible:=false;
  RadioGroup2.visible:=false;
  GroupBox5.visible:=false;
  GroupBox7.visible:=false;
  GroupBox6.visible:=false;
  LX200_UseHPP:=false;
  SpeedButton8.visible:=false;
  SpeedButton9.visible:=false;
end else if cbo_type.text='Magellan-I' then begin
  PortSpeedbox.itemindex:=2;
  ShowAltAz.checked:=false;
  ShowAltAz.enabled:=false;
  GroupBox1.visible:=false;
  RadioGroup2.visible:=false;
  GroupBox5.visible:=false;
  GroupBox7.visible:=false;
  GroupBox6.visible:=false;
  LX200_UseHPP:=false;
  SpeedButton8.visible:=false;
  SpeedButton9.visible:=false;
end;
initial:=false;
end;

procedure InitLib;
var ini:tinifile;
    buf : string;
    av : boolean;
begin
     decimalseparator:='.';
     buf:=extractfilepath(paramstr(0));
     ini:=tinifile.create(buf+'scope.ini');
     av:=ini.ReadBool('lx200','AlwaysVisible',true);
     ini.free;
     if av then pop_scope.FormStyle:=fsStayOnTop
           else pop_scope.FormStyle:=fsNormal;
end;

procedure Tpop_scope.kill(Sender: TObject; var CanClose: Boolean);
begin
if port_opened then begin
   canclose:=false;
   pop_scope.hide;
end;
end;

procedure Tpop_scope.Timer1Timer(Sender: TObject);
begin
//if port_opened and pop_scope.visible and (not CoordLock) then begin
if port_opened and (not CoordLock) then begin
   CoordLock := true;
   try
   ShowCoordinates;
   finally
   CoordLock := false;
   end;
end;
end;

procedure Tpop_scope.setresClick(Sender: TObject);
var ok : boolean;
begin
ScopeConnect(ok);
end;

procedure Tpop_scope.SaveButton1Click(Sender: TObject);
var
ini:tinifile;
begin
ini:=tinifile.create(extractfilepath(paramstr(0))+'scope.ini');
ini.writestring('lx200','name',cbo_type.text);
ini.writeinteger('lx200','model',cbo_type.ItemIndex);
ini.writestring('lx200','read_interval',ReadIntBox.text);
ini.writestring('lx200','comport',cbo_port.text);
ini.writestring('lx200','baud',PortSpeedbox.text);
ini.writestring('lx200','databits',DatabitBox.text);
ini.writestring('lx200','parity',Paritybox.text);
ini.writestring('lx200','stopbits',StopbitBox.text);
ini.writestring('lx200','timeout',TimeOutBox.text);
ini.writestring('lx200','inttimeout',IntTimeOutBox.text);
ini.writeBool('lx200','hpp',checkBox1.Checked);
ini.writeBool('lx200','AltAz',ShowAltAz.Checked);
ini.writeBool('lx200','AlwaysVisible',checkbox2.checked);
ini.writeBool('lx200','SwapNS',checkbox3.checked);
ini.writeBool('lx200','SwapEW',checkbox4.checked);
ini.writestring('observatory','latitude',lat.text);
ini.writestring('observatory','longitude',long.text);
ini.writeinteger('lx200','focusmodel',radiogroup5.ItemIndex);
ini.writeinteger('lx200','focusspeed1',radiogroup3.ItemIndex);
ini.writeinteger('lx200','focusspeed2',radiogroup4.ItemIndex);
ini.writeBool('lx200','focuspulse',checkbox6.Checked);
ini.writeinteger('lx200','focusduration',longedit1.Value);
ini.free;
end;

procedure Tpop_scope.ReadIntBoxChange(Sender: TObject);
begin
     Timer1.Interval:=strtointdef(ReadIntBox.text,500);
end;

procedure Tpop_scope.latChange(Sender: TObject);
var x : double;
    i : integer;
begin
val(lat.text,x,i);
if i=0 then latitude:=x;
//ObsLatitude:=latitude;
end;

procedure Tpop_scope.longChange(Sender: TObject);
var x : double;
    i : integer;
begin
val(long.text,x,i);
if i=0 then longitude:=x;
//ObsLongitude:=longitude;
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

procedure Tpop_scope.TopBtnMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
LX200_SetSpeed(RadioGroup1.itemindex);
if checkBox3.Checked then LX200_Move(south)
                     else LX200_Move(north);
end;

procedure Tpop_scope.BotBtnMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
LX200_SetSpeed(RadioGroup1.itemindex);
if checkBox3.Checked then LX200_Move(north)
                     else LX200_Move(south);
end;

procedure Tpop_scope.LeftBtnMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
LX200_SetSpeed(RadioGroup1.itemindex);
if checkBox4.Checked then LX200_Move(west)
                     else LX200_Move(east);
end;

procedure Tpop_scope.RightBtnMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
LX200_SetSpeed(RadioGroup1.itemindex);
if checkBox4.Checked then LX200_Move(east)
                     else LX200_Move(west);
end;

procedure Tpop_scope.TopBtnMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
if checkBox3.Checked then LX200_StopDir(south)
                     else LX200_StopDir(north);
end;

procedure Tpop_scope.RightBtnMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
if checkBox4.Checked then LX200_StopDir(east)
                     else LX200_StopDir(west);
end;

procedure Tpop_scope.BotBtnMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
if checkBox3.Checked then LX200_StopDir(north)
                     else LX200_StopDir(south);
end;

procedure Tpop_scope.LeftBtnMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
if checkBox4.Checked then LX200_StopDir(west)
                     else LX200_StopDir(east);
end;

procedure Tpop_scope.StopBtnMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
LX200_StopMove;
end;

procedure Tpop_scope.RadioGroup2Click(Sender: TObject);
begin
   LX200_SetFormat(pop_scope.radiogroup2.ItemIndex);
end;

procedure Tpop_scope.cbo_typeChange(Sender: TObject);
begin
  VirtHP.TabVisible:=False;
  Adv.TabVisible:=False;
  FRAngle.Visible:=false;
  FRQuery.Visible:=false;
  FRLabel.Visible:=false;
if cbo_type.text='LX200' then begin
  PortSpeedbox.itemindex:=5;
  DatabitBox.itemindex:=4;
  Paritybox.itemindex:=0;
  StopbitBox.itemindex:=0;
  ShowAltAz.checked:=false;
  ShowAltAz.enabled:=true;
  GroupBox1.visible:=true;
  RadioGroup2.visible:=true;
  GroupBox5.visible:=true;
  GroupBox7.visible:=true;
  SpeedButton8.visible:=true;
  SpeedButton9.visible:=false;
  if LX200_UseHPP then GroupBox6.visible:=true;
  Radiogroup1.Items.Clear;
  Radiogroup1.Items.Add('Slew');
  Radiogroup1.Items.Add('Find');
  Radiogroup1.Items.Add('Centering');
  Radiogroup1.Items.Add('Guide');
  Radiogroup1.ItemIndex:=1;
// Renato Bonomini:
end else if cbo_type.text='Scope.exe' then begin
  PortSpeedbox.itemindex:=5;
  ShowAltAz.checked:=true;
  ShowAltAz.enabled:=true;
  GroupBox1.visible:=true;
  RadioGroup2.visible:=true;
  GroupBox5.visible:=true;
  GroupBox7.visible:=false;
  // if LX200_UseHPP then GroupBox6.visible:=true; //
  Radiogroup1.Items.Clear;
  Radiogroup1.Items.Add('Slew');
  Radiogroup1.Items.Add('Find');
  Radiogroup1.Items.Add('Centering');
  Radiogroup1.Items.Add('Guide');
  Radiogroup1.ItemIndex:=1;
  VirtHP.TabVisible:=True;
  Adv.TabVisible:=True;
  FRAngle.Visible:=True;
  FRQuery.Visible:=True;
  FRLabel.Visible:=True;
  SpeedButton8.visible:=true;
  SpeedButton9.visible:=true;
end else if cbo_type.text='AutoStar' then begin
  PortSpeedbox.itemindex:=5;
  DatabitBox.itemindex:=4;
  Paritybox.itemindex:=0;
  StopbitBox.itemindex:=0;
  ShowAltAz.checked:=false;
  ShowAltAz.enabled:=true;
  GroupBox1.visible:=true;
  RadioGroup2.visible:=true;
  GroupBox5.visible:=true;
  GroupBox7.visible:=false;
  SpeedButton8.visible:=true;
  SpeedButton9.visible:=true;
  GroupBox6.visible:=false;
  LX200_UseHPP:=false;
  Radiogroup1.Items.Clear;
  Radiogroup1.Items.Add('Highest');
  Radiogroup1.Items.Add('Middle');
  Radiogroup1.Items.Add('Slowest');
  Radiogroup1.ItemIndex:=1;
end else if cbo_type.text='Magellan-II' then begin
  PortSpeedbox.itemindex:=1;
  DatabitBox.itemindex:=4;
  Paritybox.itemindex:=0;
  StopbitBox.itemindex:=0;
  ShowAltAz.checked:=false;
  ShowAltAz.enabled:=false;
  GroupBox1.visible:=false;
  RadioGroup2.visible:=false;
  RadioGroup2.itemindex:=0;
  GroupBox5.visible:=false;
  GroupBox7.visible:=false;
  GroupBox6.visible:=false;
  LX200_UseHPP:=false;
  SpeedButton8.visible:=false;
  SpeedButton9.visible:=false;
end else if cbo_type.text='Magellan-I' then begin
  PortSpeedbox.itemindex:=2;
  DatabitBox.itemindex:=4;
  Paritybox.itemindex:=0;
  StopbitBox.itemindex:=0;
  ShowAltAz.checked:=false;
  ShowAltAz.enabled:=false;
  GroupBox1.visible:=false;
  RadioGroup2.visible:=false;
  RadioGroup2.itemindex:=0;
  GroupBox5.visible:=false;
  GroupBox7.visible:=false;
  GroupBox6.visible:=false;
  LX200_UseHPP:=false;
  SpeedButton8.visible:=false;
  SpeedButton9.visible:=false;
end;
pop_scope.Caption:=cbo_type.text;
end;

procedure Tpop_scope.CheckBox1Click(Sender: TObject);
begin
if ScopeConnected then begin
if checkBox1.Checked then HPP.text:=LX200_QueryHighPrecision;
if LX200_UseHPP then begin
  GroupBox6.visible:=true;
end else begin
  GroupBox6.visible:=false;
end;
end;
end;

procedure Tpop_scope.Button3Click(Sender: TObject);
begin
HPP.text:=LX200_SwitchHighPrecision;
if LX200_UseHPP then begin
  GroupBox6.visible:=true;
end else begin
  GroupBox6.visible:=false;
end;
end;

procedure Tpop_scope.SpeedButton3Click(Sender: TObject);
begin
LX200_Slew;
end;

procedure Tpop_scope.CheckBox2Click(Sender: TObject);
begin
if initial then exit;
if checkbox2.checked then pop_scope.FormStyle:=fsStayOnTop
                     else pop_scope.FormStyle:=fsNormal;
end;

procedure Tpop_scope.FormShow(Sender: TObject);
begin
pop_scope.Caption:=cbo_type.text;
end;

procedure Tpop_scope.CheckBox3Click(Sender: TObject);
begin
if checkbox3.checked then begin
  Label3.caption:='S';
  Label6.caption:='N';
end else begin
  Label3.caption:='N';
  Label6.caption:='S';
end;
end;

procedure Tpop_scope.CheckBox4Click(Sender: TObject);
begin
if checkbox4.checked then begin
  Label14.caption:='W';
  Label4.caption:='E';
end else begin
  Label14.caption:='E';
  Label4.caption:='W';
end;
end;

procedure Tpop_scope.CheckBox5Click(Sender: TObject);
begin
if CheckBox5.checked then begin
  Initserialdebug('lx200_trace.txt');
  debug:=true;
end else begin
  CloseSerialDebug;
end;
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
ExecuteFile('meade.html','',appdir+'\doc',SW_SHOWNORMAL);
end;

procedure Tpop_scope.RadioGroup5Click(Sender: TObject);
begin
RadioGroup3.visible:=(radiogroup5.itemindex=1);
RadioGroup4.visible:=not RadioGroup3.visible;
end;

procedure Tpop_scope.SpeedButton6MouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
LX200_StopFocus;
end;

procedure Tpop_scope.SpeedButton6MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var c:char;
begin
// set speed
c:='S';
case radiogroup5.ItemIndex of
 0: if radiogroup4.ItemIndex=0 then c:='S' else c:='F';
 1: c:=inttostr(radiogroup3.ItemIndex+1)[1];
end;
LX200_SetFocusSteep(c);
// start focus
LX200_StartFocus('+');
if checkbox6.Checked then begin
  sleep(longedit1.Value);
  LX200_StopFocus;
end;
end;

procedure Tpop_scope.SpeedButton7MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var c:char;
begin
// set speed
c:='S';
case radiogroup5.ItemIndex of
 0: if radiogroup4.ItemIndex=0 then c:='S' else c:='F';
 1: c:=inttostr(radiogroup3.ItemIndex+1)[1];
end;
LX200_SetFocusSteep(c);
// start focus
LX200_StartFocus('-');
if checkbox6.Checked then begin
  sleep(longedit1.Value);
  LX200_StopFocus;
end;
end;

procedure Tpop_scope.CheckBox6Click(Sender: TObject);
begin
longedit1.Enabled:=CheckBox6.Checked;
end;

procedure Tpop_scope.SpeedButton8Click(Sender: TObject);
var ok : boolean;
begin
if not ScopeConnected then ScopeConnect(ok);
  if ScopeConnected then
     CoordLock := true;
     try
     if not LX200_SetTimeDate then
        ShowMessage('Date and/or time cannot be changed')
     finally
     CoordLock := false;
     end;
end;

procedure Tpop_scope.SpeedButton9Click(Sender: TObject);
var ok : boolean;
begin
if MessageDlg('REALLY park and disconnect the telescope?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
   if LX200_ParkScope then begin
      ScopeDisconnect(ok);
      ShowMessage('Parking and Disconnecting telescope.');
   end;
end;


procedure Tpop_scope.VHpLeftClick(Sender: TObject);
// Renato Bonomini:
begin
LX200_Scope_HpLm;
end;

procedure Tpop_scope.VHRightClick(Sender: TObject);
// Renato Bonomini:
begin
LX200_Scope_HpRm;
end;

procedure Tpop_scope.QueryFirmwareButtonClick(Sender: TObject);
// Renato Bonomini:
var ok : boolean;
    alreadyconnected: boolean;
begin
alreadyconnected:=ScopeConnected;
if alreadyconnected <> true then begin
ScopeConnect(ok);
end;
showmessage('Controller returned'+crlf+crlf+'Product Id : '+LX200_QueryProductID+crlf+'Firmware ID-Revision : '+LX200_QueryFirmwareID+LX200_QueryFirmwareNumber+crlf+'Firmware Date-Time : '+LX200_QueryFirmwareTime+LX200_QueryFirmwareDate);
if alreadyconnected <> true then begin
ScopeDisconnect(ok);
end;
end;

procedure Tpop_scope.HandPadModeSelectionClick(Sender: TObject);
// Renato Bonomini:
const hpmodes : array[1..19] of Char=('a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s');
var selectedmode : Char;
begin
// Get the index from the radiogroup
selectedmode:=hpmodes[HandPadModeSelection.ItemIndex+1];
// showmessage('Selected HandPad mode : '+selectedmode);
LX200_Scope_Hp_Mode(selectedmode);
end;

procedure Tpop_scope.GetMsArcSecClick(Sender: TObject);
var arcsec: string;
begin
MsArcSec.Value:=LX200_Scope_GetMsArcSec;
arcsec:=IntToStr(MsArcSec.Value);
// showmessage('MsArcSec:'+arcsec);
end;

procedure Tpop_scope.GetGuideArcSecClick(Sender: TObject);
var arcsec: string;
begin
GuideArcSec.Value:=LX200_Scope_GetGuideArcSec;
arcsec:=IntToStr(GuideArcSec.Value);
// showmessage('MsArcSec:'+arcsec);
end;

procedure Tpop_scope.PecToggleClick(Sender: TObject);
begin
LX200_PecToggle;
end;

Procedure Tpop_scope.ScopeFieldRotationClick(Sender: TObject);
begin
if pop_scope.cbo_type.text='Scope.exe' then pop_scope.FRAngle.Value:=LX200_Scope_GetFRAngle;
if pop_scope.FieldRotation.State=cbUnchecked then LX200_FieldRotationOff else LX200_FieldRotationOn;
end;

procedure Tpop_scope.SetGuideArcSecClick(Sender: TObject);
begin
LX200_Scope_SetGuideArcSec(pop_scope.GuideArcSec.Value);
GuideArcSec.Value:=LX200_Scope_GetGuideArcSec;
end;

procedure Tpop_scope.SetMsArcSecClick(Sender: TObject);
begin
LX200_Scope_SetMsArcSec(pop_scope.MsArcSec.Value);
MsArcSec.Value:=LX200_Scope_GetMsArcSec;
end;

procedure Tpop_scope.ScopeInit1Click(Sender: TObject);
begin
LX200_SimpleCmd('#:XI1#');
end;

procedure Tpop_scope.ScopeInit2Click(Sender: TObject);
begin
LX200_SimpleCmd('#:XI2#');
end;

procedure Tpop_scope.ScopeInit3Click(Sender: TObject);
begin
LX200_SimpleCmd('#:XI3#');
end;

procedure Tpop_scope.AdvHelpClick(Sender: TObject);
begin
showmessage('Scope.exe accepts custom LX-200 commands to '+crlf+'1) Set or get msarcsec and guidespeed'+crlf+'2) Init 1->3 '+crlf+crlf+'Please check Scope website for additional info'+crlf+crlf+'R.Bonomini <renato@linux.eubia.it>');
end;

procedure Tpop_scope.VirtHpHelpClick(Sender: TObject);
begin
showmessage('Scope.exe accepts custom LX-200 commands to '+crlf+'1) Simulate selection of Right or Left mode'+crlf+'2) Select handpad mode'+crlf+'Please check Scope website for additional info'+crlf+crlf+'R.Bonomini <renato@linux.eubia.it>');
end;

procedure Tpop_scope.FRQueryClick(Sender: TObject);
begin
    FRAngle.Value:=LX200_Scope_GetFRAngle;
end;

procedure Tpop_scope.TrackingDefaultButtonClick(Sender: TObject);
begin
LX200_TrackingDefaultRate;
end;

procedure Tpop_scope.TrackingLunarButtonClick(Sender: TObject);
begin
LX200_TrackingLunarRate;
end;

procedure Tpop_scope.TrackingCustomButtonClick(Sender: TObject);
begin
LX200_TrackingCustomRate;
end;

procedure Tpop_scope.TrackingRateChangerClick(Sender: TObject; Button: TUDBtnType);
begin
LX200_TrackingIncreaseRate;
LX200_TrackingDecreaseRate;
end;

procedure Tpop_scope.TrackingSetRateButtonClick(Sender: TObject);
var rate : Single;
begin
rate:=pop_scope.TrackingRateEdit.Value;
if LX200_SetTrackingRateT(rate) = false then LX200_SetTrackingRateS(rate);
end;

procedure Tpop_scope.TrackingGetButtonClick(Sender: TObject);
begin
pop_scope.TrackingRateEdit.Value:=LX200_GetTrackingRate;
end;

procedure Tpop_scope.TrackingRateDecreaseClick(Sender: TObject);
begin
LX200_TrackingDecreaseRate;
end;

procedure Tpop_scope.TrackingRateIncreaseClick(Sender: TObject);
begin
LX200_TrackingIncreaseRate
end;

procedure Tpop_scope.LX200GPSRateClick(Sender: TObject);
begin
if not LX200GPSRate.Checked then
begin
pop_scope.Lx200GPSMotorSpeeds.Visible:=False;
pop_scope.PEC.TabVisible:=False;
pop_scope.LxPecToggle.Visible:=True;
pop_scope.FanControl.Visible:=False;
end;
if LX200GPSRate.Checked then
begin
pop_scope.Lx200GPSMotorSpeeds.Visible:=True;
pop_scope.PEC.TabVisible:=True;
pop_scope.LxPecToggle.Visible:=False;
pop_scope.FanControl.Visible:=True;
end;
end;

procedure Tpop_scope.LxGuideRateSetClick(Sender: TObject);
begin
LX200_GPS_SetGuideRate(pop_scope.LxGuideRate.Value);
end;

procedure Tpop_scope.RASlewRateSetClick(Sender: TObject);
begin
LX200_GPS_RASlewRate(pop_scope.RASlewRate.Value);
end;

procedure Tpop_scope.DECSlewRateSetClick(Sender: TObject);
begin
LX200_GPS_DECSlewRate(pop_scope.DECSlewRate.Value);
end;

procedure Tpop_scope.FanControlClick(Sender: TObject);
begin
if FanControl.Checked then LX200_FanOn else LX200_FanOff;
end;

procedure Tpop_scope.SlewSpeedBarChange(Sender: TObject);
begin
LX200_SlewSpeed(pop_scope.SlewSpeedBar.Position);
end;

initialization
pop_scope:=Tpop_scope.Create(nil);

end.
