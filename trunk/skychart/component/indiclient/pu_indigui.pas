unit pu_indigui;

{$mode objfpc}{$H+}

{
Copyright (C) 2015 Patrick Chevalley

http://www.ap-i.net
pch@ap-i.net

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>. 

}

interface

uses indibaseclient, indibasedevice, indiapi, indicom,
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ComCtrls,
  StdCtrls, ExtCtrls, Buttons;

type

  TSwitchType=(SWITCH_CHECKBOX,SWITCH_BUTTON,SWITCH_COMBOBOX);

  TIpsLed = class(TShape)
    private
      Fstate: IPState;
      procedure SetState(value:IPState);
    public
      constructor Create(aOwner: TComponent); override;
      destructor Destroy;override;
      property State: IPState read Fstate write SetState;
  end;

  TIndiDev = class(TObject)
    public
      page: TPageControl;
      dp: BaseDevice;
      group: TStringList;
      props: TStringList;
      constructor Create;
      destructor Destroy;override;
  end;

  TIndiProp = class(TObject)
    public
      ctrl: TStringList;
      entry: TStringList;
      widget: TStringList;
      state: TIpsLed;
      lbl:   TLabel;
      name: string;
      page: TScrollBox;
      dp: BaseDevice;
      iprop: IndiProperty;
      idev: TIndiDev;
      constructor Create;
      destructor Destroy;override;
  end;

  { Tf_indigui }

  Tf_indigui = class(TForm)
    msg: TMemo;
    dev: TPageControl;
    NoConnection: TPanel;
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { private declarations }
    indiclient: TIndiBaseClient;
    devlist: Tstringlist;
    FIndiServer,FIndiPort,FIndiDevice: string;
    FonDestroy: TNotifyEvent;
    FButtonGroup: integer;
    indiclosing: boolean;
    procedure NewDevice(dp: Basedevice);
    procedure DeleteDevice(dp: Basedevice);
    procedure NewMessage(txt: string);
    procedure NewProperty(indiProp: IndiProperty);
    procedure DeleteProperty(indiProp: IndiProperty);
    procedure NewNumber(nvp: INumberVectorProperty);
    procedure NewText(tvp: ITextVectorProperty);
    procedure NewSwitch(svp: ISwitchVectorProperty);
    procedure NewLight(lvp: ILightVectorProperty);
    procedure ServerConnected(Sender: TObject);
    procedure ServerDisconnected(Sender: TObject);
    procedure AddSpacer(iprop:TIndiProp);
    procedure CreateTextWidget(iprop:TIndiProp);
    procedure CreateSwitchWidget(iprop:TIndiProp);
    procedure CreateNumberWidget(iprop:TIndiProp);
    procedure CreateLightWidget(iprop:TIndiProp);
    procedure CreateBlobWidget(iprop:TIndiProp);
    procedure CreateUnknowWidget(iprop:TIndiProp);
    function  GetSwitchType(svp:ISwitchVectorProperty):TSwitchType;
    procedure CreateSwitchCheckbox(svp:ISwitchVectorProperty; iprop:TIndiProp);
    procedure CreateSwitchButton(svp:ISwitchVectorProperty; iprop:TIndiProp);
    procedure CreateSwitchCombobox(svp:ISwitchVectorProperty; iprop:TIndiProp);
    procedure SetButtonClick(Sender: TObject);
    procedure SetSwitchButtonClick(Sender: TObject);
    procedure SetSwitchCheckClick(Sender: TObject; Index: integer);
    procedure SetSwitchComboChange(Sender: TObject);
  public
    { public declarations }
    property IndiServer: string read FIndiServer write FIndiServer;
    property IndiPort: string read FIndiPort write FIndiPort;
    property IndiDevice: string read FIndiDevice write FIndiDevice;
    property onDestroy: TNotifyEvent read FonDestroy write FonDestroy;
  end;

var
  f_indigui: Tf_indigui;

implementation

{$R *.lfm}

/////  TIndiDev //////
constructor TIndiDev.Create;
begin
  group:=TStringList.Create;
  props:=TStringList.Create;
end;

destructor TIndiDev.Destroy;
var i: integer;
begin
  for i:=0 to group.Count-1 do if group.Objects[i]<>nil then group.Objects[i].Free;
  for i:=0 to props.Count-1 do if props.Objects[i]<>nil then props.Objects[i].Free;
  group.Free;
  props.Free;
end;

/////  TIndiProp //////
constructor TIndiProp.Create;
begin
  ctrl:=TStringList.Create;
  entry:=TStringList.Create;
  widget:=TStringList.Create;
end;

destructor TIndiProp.Destroy;
begin
  // objects are destroyed by TForms
  ctrl.Free;
  entry.Free;
  widget.Free;
end;

/////  TIpsLed //////

constructor TIpsLed.Create(aOwner: TComponent);
begin
  inherited Create(aOwner);
  Fstate:=IPS_IDLE;
  Hint:='Idle';
  ShowHint:=true;
  Shape:=stCircle;
  AutoSize:=false;
  Constraints.MaxHeight:=14;
  Constraints.MaxWidth:=14;
  height:=14;
  width:=14;
  pen.Color:=clBlack;
  brush.Color:=clGray;
end;

destructor TIpsLed.Destroy;
begin
  inherited Destroy;
end;

procedure TIpsLed.SetState(value:IPState);
begin
  Fstate:=value;
  case Fstate of
     IPS_IDLE  : begin
                  Hint:='Idle';
                  pen.Color:=clBlack;
                  brush.Color:=clGray;
                 end;
     IPS_OK    : begin
                  Hint:='OK';
                  pen.Color:=clWhite;
                  brush.Color:=clGreen;
                 end;
     IPS_BUSY  : begin
                  Hint:='Busy';
                  pen.Color:=clWhite;
                  brush.Color:=clYellow;
                 end;
     IPS_ALERT : begin
                  Hint:='Alert';
                  pen.Color:=clWhite;
                  brush.Color:=clRed;
                 end;
  end;
end;


{ Tf_indigui }

procedure Tf_indigui.FormShow(Sender: TObject);
begin
  indiclient.SetServer(FIndiServer,FIndiPort);
  if FIndiDevice<>'' then indiclient.watchDevice(FIndiDevice);
  indiclient.ConnectServer;
end;

procedure Tf_indigui.FormCreate(Sender: TObject);
begin
  indiclosing:=false;
  FButtonGroup:=1;
  FIndiServer:='localhost';
  FIndiPort:='7624';
  FIndiDevice:='';
  indiclient:=TIndiBaseClient.Create;
  devlist:=Tstringlist.Create;
  indiclient.onNewDevice:=@NewDevice;
  indiclient.onDeleteDevice:=@DeleteDevice;
  indiclient.onNewMessage:=@NewMessage;
  indiclient.onNewProperty:=@NewProperty;
  indiclient.onDeleteProperty:=@DeleteProperty;
  indiclient.onNewNumber:=@NewNumber;
  indiclient.onNewText:=@NewText;
  indiclient.onNewSwitch:=@NewSwitch;
  indiclient.onNewLight:=@NewLight;
  indiclient.onServerConnected:=@ServerConnected;
  indiclient.onServerDisconnected:=@ServerDisconnected;
end;

procedure Tf_indigui.FormDestroy(Sender: TObject);
var i:integer;
begin
  if assigned(FonDestroy) then FonDestroy(self);
  indiclient.Terminate;
  for i:=0 to devlist.Count-1 do if devlist.Objects[i]<>nil then devlist.Objects[i].Free;
  devlist.Free;
end;

procedure Tf_indigui.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  indiclosing:=true;
  CloseAction:=caFree;
end;

procedure Tf_indigui.ServerConnected(Sender: TObject);
begin
  NoConnection.Visible:=false;
  indiclient.setBLOBMode(B_NEVER, '');
  NewMessage('Server connected');
end;

procedure Tf_indigui.ServerDisconnected(Sender: TObject);
begin
  if not indiclosing then Close;
end;

procedure Tf_indigui.NewDevice(dp: Basedevice);
var idev: TIndiDev;
    tb: TTabSheet;
    devname:string;
begin
 devname:=dp.getDeviceName;
 tb:=dev.AddTabSheet;
 tb.Caption:=devname;
 idev:=TIndiDev.Create;
 idev.page:=TPageControl.Create(self);
 idev.page.Parent:=tb;
 idev.page.Align:=alClient;
 devlist.AddObject(devname,idev);
end;

procedure Tf_indigui.DeleteDevice(dp: Basedevice);
var devname:string;
    i,j:integer;
begin
  devname:=dp.getDeviceName;
  for i:=0 to dev.PageCount-1 do begin
    if dev.Pages[i].Caption=devname then begin
      for j:=0 to devlist.Count-1 do begin
        if TIndiDev(devlist.Objects[j]).page.Parent=dev.Pages[i] then begin
          dev.Pages[i].Free;
          devlist.Delete(j);
          break;
        end;
      end;
      break;
    end;
  end;
end;

procedure Tf_indigui.NewMessage(txt: string);
begin
  msg.Lines.Add(txt);
end;

procedure Tf_indigui.NewProperty(indiProp: IndiProperty);
var devname,groupname,propname,proplbl: string;
    proptype: INDI_TYPE;
    iprop: TIndiProp;
    tb: TTabSheet;
    sb: TScrollBox;
    led: TIpsLed;
    lbl:Tlabel;
    i:integer;
begin
  devname:=indiProp.getDeviceName;
  groupname:=indiProp.getGroupName;
  propname:=indiProp.getName;
  proplbl:=indiProp.getLabel;
  if proplbl='' then proplbl:=propname;
  proptype:=indiProp.getType;
  iprop:=TIndiProp.Create;
  i:=devlist.IndexOf(devname);
  if i<0 then exit;
  iprop.idev:=TIndiDev(devlist.Objects[i]);
  i:=iprop.idev.group.IndexOf(groupname);
  if i>=0 then begin
    sb:=TScrollBox(iprop.idev.group.Objects[i]);
  end else begin
    tb:=iprop.idev.page.AddTabSheet;
    tb.Caption:=groupname;
    sb:=TScrollBox.Create(self);
    sb.Parent:=tb;
    sb.Align:=alClient;
    sb.AutoSize:=true;
    sb.ChildSizing.ControlsPerLine:=6;
    sb.ChildSizing.Layout:=cclLeftToRightThenTopToBottom;
    sb.ChildSizing.HorizontalSpacing:=8;
    sb.ChildSizing.LeftRightSpacing:=8;
    sb.ChildSizing.TopBottomSpacing:=8;
    sb.ChildSizing.VerticalSpacing:=4;
    iprop.idev.group.AddObject(groupname,sb);
  end;
  iprop.page:=sb;
  led:=TIpsLed.Create(self);
  led.State:=indiProp.getState;
  led.Parent:=iprop.page;
  lbl:=TLabel.Create(self);
  lbl.Caption:=proplbl;
  lbl.Parent:=iprop.page;
  iprop.state:=led;
  iprop.lbl:=lbl;
  iprop.name:=propname;
  iprop.iprop:=indiProp;
  case proptype of
     INDI_TEXT: CreateTextWidget(iprop);
     INDI_SWITCH: CreateSwitchWidget(iprop);
     INDI_NUMBER: CreateNumberWidget(iprop);
     INDI_LIGHT: CreateLightWidget(iprop);
     INDI_BLOB: CreateBlobWidget(iprop);
     else CreateUnknowWidget(iprop);
  end;
  iprop.idev.props.AddObject(propname,iprop);
end;

procedure Tf_indigui.DeleteProperty(indiProp: IndiProperty);
var devname,groupname,propname,proplbl: string;
    sb: TScrollBox;
    tb: TTabSheet;
    iprop: TIndiProp;
    idev: TIndiDev;
    ip,ig,i,gcount: integer;
begin
  devname:=indiProp.getDeviceName;
  groupname:=indiProp.getGroupName;
  propname:=indiProp.getName;
  proplbl:=indiProp.getLabel;
  if proplbl='' then proplbl:=propname;
  i:=devlist.IndexOf(devname);
  if i<0 then exit;
  idev:=TIndiDev(devlist.Objects[i]);
  ip:=idev.props.IndexOf(propname);
  if ip<0 then exit;
  iprop:=TIndiProp(idev.props.Objects[ip]);
  for i:=0 to iprop.ctrl.Count-1 do begin
    iprop.ctrl.Objects[i].Free;
  end;
  for i:=0 to iprop.entry.Count-1 do begin
    iprop.entry.Objects[i].Free;
  end;
  for i:=0 to iprop.widget.Count-1 do begin
    iprop.widget.Objects[i].Free;
  end;
  iprop.state.Free;
  iprop.lbl.Free;
  iprop.Free;
  idev.props.Delete(ip);
  ig:=idev.group.IndexOf(groupname);
  if ig<0 then exit;
  sb:=TScrollBox(idev.group.Objects[ig]);
  gcount:=0;
  for i:=0 to idev.props.Count-1 do begin
    if TIndiProp(idev.props.Objects[i]).page=sb then inc(gcount);
  end;
  if gcount=0 then begin
    tb:=TTabSheet(sb.Parent);
    tb.Free;
    idev.group.Delete(ig);
  end;
end;

procedure Tf_indigui.AddSpacer(iprop:TIndiProp);
var spacer: TLabel;
begin
   spacer:=TLabel.Create(self);
   spacer.Caption:=' ';
   spacer.Parent:=iprop.page;
   iprop.widget.AddObject('',spacer);
end;

procedure Tf_indigui.CreateTextWidget(iprop:TIndiProp);
var lbl: TLabel;
    txt: TLabel;
    entry: TEdit;
    btn: TButton;
    tvp: ITextVectorProperty;
    i: integer;
    n: string;
    btnok: boolean;
begin
  tvp:=iprop.iprop.getText;
  btnok:=false;
  for i:=0 to tvp.ntp-1 do begin
     if i>0 then begin
       AddSpacer(iprop);
       AddSpacer(iprop);
     end;
     lbl:=TLabel.Create(self);
     lbl.AutoSize:=true;
     n:=tvp.tp[i].lbl;
     if trim(n)='' then n:=tvp.tp[i].name;
     lbl.Caption:=n+':';
     lbl.Parent:=iprop.page;
     iprop.widget.AddObject(lbl.Caption,lbl);
     txt:=TLabel.Create(self);
     txt.AutoSize:=true;
     txt.Caption:=tvp.tp[i].text;
     txt.Parent:=iprop.page;
     iprop.ctrl.AddObject(tvp.tp[i].name,txt);
     if tvp.p<>IP_RO then begin
        entry:=TEdit.Create(self);
        entry.AutoSize:=true;
        entry.Parent:=iprop.page;
        iprop.entry.AddObject(tvp.tp[i].name,entry);
        if not btnok then begin
           btnok:=true;
           btn:=TButton.Create(self);
           btn.AutoSize:=true;
           btn.Caption:='Set';
           btn.OnClick:=@SetButtonClick;
           btn.tag:=PtrInt(iprop);
           btn.Parent:=iprop.page;
           iprop.widget.AddObject(btn.Caption,btn);
        end else begin
           AddSpacer(iprop);
        end;
     end else begin
        AddSpacer(iprop);
        AddSpacer(iprop);
     end;
  end;
end;

Function sgn(x:Double):Double ;
begin
// sign function with zero positive
if x<0 then
   sgn:= -1
else
   sgn:=  1 ;
end ;

Function SXToStr(de: Double) : string;
var dd,min1,min,sec: Double;
    d,m,s : string;
begin
    dd:=Int(de);
    min1:=abs(de-dd)*60;
    if min1>=59.99166667 then begin
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
    if de<0 then d:='-'+d;
    str(min:2:0,m);
    if abs(min)<10 then m:='0'+trim(m);
    str(sec:2:0,s);
    if abs(sec)<9.5 then s:='0'+trim(s);
    result := d+':'+m+':'+s;
end;

function IndiFormatFloat(x: double; fmt:string):string;
begin
  if copy(fmt,Length(fmt),1)='m'
    then result:=SXToStr(x)
  else begin
    try
      fmt:=StringReplace(fmt,'+','',[]); // "%+06.2f" not supported by FPC
      result:=Format(fmt,[x]);
      if result='' then result:=FloatToStr(x);
    except
      result:=FloatToStr(x);
    end;
  end;
end;

procedure Tf_indigui.CreateNumberWidget(iprop:TIndiProp);
var lbl: TLabel;
    txt: TLabel;
    entry: TEdit;
    btn: TButton;
    nvp: INumberVectorProperty;
    i: integer;
    n: string;
    btnok: boolean;
begin
  nvp:=iprop.iprop.getNumber;
  btnok:=false;
  for i:=0 to nvp.nnp-1 do begin
     if i>0 then begin
       AddSpacer(iprop);
       AddSpacer(iprop);
     end;
     lbl:=TLabel.Create(self);
     lbl.AutoSize:=true;
     n:=nvp.np[i].lbl;
     if trim(n)='' then n:=nvp.np[i].name;
     lbl.Caption:=n+':';
     lbl.Parent:=iprop.page;
     iprop.widget.AddObject(lbl.Caption,lbl);
     txt:=TLabel.Create(self);
     txt.AutoSize:=true;
     txt.Caption:=IndiFormatFloat(nvp.np[i].value,nvp.np[i].format);
     txt.Parent:=iprop.page;
     iprop.ctrl.AddObject(nvp.np[i].name,txt);
     if nvp.p<>IP_RO then begin
        entry:=TEdit.Create(self);
        entry.AutoSize:=true;
        entry.Parent:=iprop.page;
        iprop.entry.AddObject(nvp.np[i].name,entry);
        if not btnok then begin
           btnok:=true;
           btn:=TButton.Create(self);
           btn.AutoSize:=true;
           btn.Caption:='Set';
           btn.OnClick:=@SetButtonClick;
           btn.tag:=PtrInt(iprop);
           btn.Parent:=iprop.page;
           iprop.widget.AddObject(btn.Caption,btn);
        end else begin
           AddSpacer(iprop);
        end;
     end else begin
        AddSpacer(iprop);
        AddSpacer(iprop);
     end;
  end;
end;

function Tf_indigui.GetSwitchType(svp:ISwitchVectorProperty):TSwitchType;
begin
  if svp.r=ISR_NOFMANY then
     result:=SWITCH_CHECKBOX
  else if svp.nsp<=4 then
     result:=SWITCH_BUTTON
  else
     result:=SWITCH_COMBOBOX;
end;

procedure Tf_indigui.CreateSwitchWidget(iprop:TIndiProp);
var swtype: TSwitchType;
begin
  swtype:=GetSwitchType(iprop.iprop.getSwitch);
  case swtype of
     SWITCH_CHECKBOX: CreateSwitchCheckbox(iprop.iprop.getSwitch, iprop);
     SWITCH_BUTTON:   CreateSwitchButton(iprop.iprop.getSwitch, iprop);
     SWITCH_COMBOBOX: CreateSwitchCombobox(iprop.iprop.getSwitch, iprop);
  end;
end;

procedure Tf_indigui.CreateSwitchCheckbox(svp:ISwitchVectorProperty; iprop:TIndiProp);
var chk: TCheckGroup;
    i: integer;
    n: string;
begin
   chk:=TCheckGroup.Create(self);
   chk.AutoSize:=true;
   for i:=0 to svp.nsp-1 do begin
     n:=svp.sp[i].lbl;
     if trim(n)='' then n:=svp.sp[i].name;
     chk.Items.Add(n);
     chk.Checked[i]:=(svp.sp[i].s=ISS_ON);
  end;
  chk.Caption:='';
  chk.OnItemClick:=@SetSwitchCheckClick;
  chk.tag:=PtrInt(iprop);
  chk.Parent:=iprop.page;
  iprop.ctrl.AddObject(svp.name,chk);
  for i:=1 to 3 do AddSpacer(iprop);
end;

procedure Tf_indigui.CreateSwitchButton(svp:ISwitchVectorProperty; iprop:TIndiProp);
var btn:TSpeedButton;
    i:integer;
    n:string;
begin
  inc(FButtonGroup);
  for i:=0 to svp.nsp-1 do begin
     btn:=TSpeedButton.Create(self);
     btn.AutoSize:=true;
     btn.Margin:=6;
     btn.GroupIndex:=FButtonGroup;
     btn.Down:=(svp.sp[i].s=ISS_ON);
     n:=svp.sp[i].lbl;
     if trim(n)='' then n:=svp.sp[i].name;
     btn.Caption:=n;
     btn.OnClick:=@SetSwitchButtonClick;
     btn.tag:=PtrInt(iprop);
     btn.Parent:=iprop.page;
     iprop.ctrl.AddObject(svp.sp[i].name,btn);
  end;
  for i:=svp.nsp+1 to 4 do AddSpacer(iprop);
 end;

procedure Tf_indigui.CreateSwitchCombobox(svp:ISwitchVectorProperty; iprop:TIndiProp);
var cmb: TComboBox;
    i,p: integer;
    n: string;
begin
   cmb:=TComboBox.Create(self);
   cmb.AutoSize:=true;
   p:=0;
   for i:=0 to svp.nsp-1 do begin
     n:=svp.sp[i].lbl;
     if trim(n)='' then n:=svp.sp[i].name;
     cmb.Items.Add(n);
     if (svp.sp[i].s=ISS_ON) then p:=i;
  end;
  cmb.ItemIndex:=p;
  cmb.OnChange:=@SetSwitchComboChange;
  cmb.tag:=PtrInt(iprop);
  cmb.Parent:=iprop.page;
  iprop.ctrl.AddObject(svp.name,cmb);
  for i:=1 to 3 do AddSpacer(iprop);
end;

procedure Tf_indigui.CreateLightWidget(iprop:TIndiProp);
var lbl: TLabel;
    lvp: ILightVectorProperty;
    i: integer;
begin
  lvp:=iprop.iprop.getLight;
  for i:=0 to lvp.nlp-1 do begin
     if i>0 then begin
       AddSpacer(iprop);
       AddSpacer(iprop);
     end;
     lbl:=TLabel.Create(self);
     lbl.AutoSize:=true;
     lbl.Caption:=lvp.lp[i].name;
     lbl.Parent:=iprop.page;
     lbl:=TLabel.Create(self);
     lbl.AutoSize:=true;
     lbl.Caption:=lvp.lp[i].lbl;
     lbl.Parent:=iprop.page;
     lbl:=TLabel.Create(self);
     lbl.AutoSize:=true;
     case lvp.lp[i].s of
        IPS_IDLE:  lbl.Caption:='idle';
        IPS_OK:    lbl.Caption:='ok';
        IPS_BUSY:  lbl.Caption:='busy';
        IPS_ALERT: lbl.Caption:='alert';
     end;
     lbl.Parent:=iprop.page;
     iprop.ctrl.AddObject(lvp.lp[i].name,lbl);
     AddSpacer(iprop);
  end;
end;

procedure Tf_indigui.CreateBlobWidget(iprop:TIndiProp);
var lbl: TLabel;
    bvp: IBLOBVectorProperty;
    i: integer;
begin
  bvp:=iprop.iprop.getBLOB;
  for i:=0 to bvp.nbp-1 do begin
     if i>0 then begin
       AddSpacer(iprop);
       AddSpacer(iprop);
     end;
     lbl:=TLabel.Create(self);
     lbl.AutoSize:=true;
     lbl.Caption:=bvp.bp[i].name;
     lbl.Parent:=iprop.page;
     lbl:=TLabel.Create(self);
     lbl.AutoSize:=true;
     lbl.Caption:=bvp.bp[i].lbl;
     lbl.Parent:=iprop.page;
     iprop.widget.AddObject(lbl.Caption,lbl);
     AddSpacer(iprop);
     AddSpacer(iprop);
  end;
end;

procedure Tf_indigui.CreateUnknowWidget(iprop:TIndiProp);
begin
  AddSpacer(iprop);
  AddSpacer(iprop);
  AddSpacer(iprop);
  AddSpacer(iprop);
end;

procedure Tf_indigui.NewNumber(nvp: INumberVectorProperty);
var devname,propname: string;
    idev: TIndiDev;
    iprop: TIndiProp;
    txt: TLabel;
    i,j: integer;
begin
  devname:=nvp.device;
  propname:=nvp.name;
  i:=devlist.IndexOf(devname);
  if i<0 then exit;
  idev:=TIndiDev(devlist.Objects[i]);
  i:=idev.props.IndexOf(propname);
  if i<0 then exit;
  iprop:=TIndiProp(idev.props.Objects[i]);
  for i:=0 to nvp.nnp-1 do begin
     j:=iprop.ctrl.IndexOf(nvp.np[i].name);
     if j<0 then continue;
     txt:=TLabel(iprop.ctrl.Objects[j]);
     txt.Caption:=IndiFormatFloat(nvp.np[i].value,nvp.np[i].format);
  end;
  iprop.state.State:=nvp.s;
end;

procedure Tf_indigui.NewText(tvp: ITextVectorProperty);
var devname,propname: string;
    idev: TIndiDev;
    iprop: TIndiProp;
    txt: TLabel;
    i,j: integer;
begin
  devname:=tvp.device;
  propname:=tvp.name;
  i:=devlist.IndexOf(devname);
  if i<0 then exit;
  idev:=TIndiDev(devlist.Objects[i]);
  i:=idev.props.IndexOf(propname);
  if i<0 then exit;
  iprop:=TIndiProp(idev.props.Objects[i]);
  for i:=0 to tvp.ntp-1 do begin
     j:=iprop.ctrl.IndexOf(tvp.tp[i].name);
     if j<0 then continue;
     txt:=TLabel(iprop.ctrl.Objects[j]);
     txt.Caption:=tvp.tp[i].text;
  end;
  iprop.state.State:=tvp.s;
end;

procedure Tf_indigui.NewSwitch(svp: ISwitchVectorProperty);
var devname,propname: string;
    idev: TIndiDev;
    iprop: TIndiProp;
    swtype: TSwitchType;
    cmb: TComboBox;
    btn: TSpeedButton;
    chk: TCheckGroup;
    i,j: integer;
begin
  devname:=svp.device;
  propname:=svp.name;
  i:=devlist.IndexOf(devname);
  if i<0 then exit;
  idev:=TIndiDev(devlist.Objects[i]);
  i:=idev.props.IndexOf(propname);
  if i<0 then exit;
  iprop:=TIndiProp(idev.props.Objects[i]);
  swtype:=GetSwitchType(iprop.iprop.getSwitch);
  case swtype of
     SWITCH_COMBOBOX: begin
                        i:=iprop.ctrl.IndexOf(svp.name);
                        if i<0 then exit;
                        cmb:=TComboBox(iprop.ctrl.Objects[i]);
                        j:=0;
                        for i:=0 to svp.nsp-1 do begin
                           if svp.sp[i].s=ISS_ON then j:=i;
                        end;
                        cmb.ItemIndex:=j;
                      end;
     SWITCH_CHECKBOX: begin
                        i:=iprop.ctrl.IndexOf(svp.name);
                        if i<0 then exit;
                        chk:=TCheckGroup(iprop.ctrl.Objects[i]);
                        j:=0;
                        for i:=0 to svp.nsp-1 do begin
                           chk.Checked[i]:=(svp.sp[i].s=ISS_ON);
                        end;
                      end;
     SWITCH_BUTTON  : begin
                        for i:=0 to svp.nsp-1 do begin
                           j:=iprop.ctrl.IndexOf(svp.sp[i].name);
                           if j<0 then exit;
                           btn:=TSpeedButton(iprop.ctrl.Objects[j]);
                           btn.Down:=(svp.sp[i].s=ISS_ON);
                        end;
                      end;
  end;

end;

procedure Tf_indigui.NewLight(lvp: ILightVectorProperty);
begin
end;

procedure Tf_indigui.SetButtonClick(Sender: TObject);
var iprop: TIndiProp;
    itype: INDI_TYPE;
    tvp: ITextVectorProperty;
    nvp: INumberVectorProperty;
    entry: TEdit;
    value: double;
    buf:string;
    i,j,er:integer;
begin
  iprop:=TIndiProp(TButton(Sender).Tag);
  itype:=iprop.iprop.getType;
  buf:=iprop.name+' ';
  case itype of
     INDI_TEXT: begin
                  tvp:=iprop.iprop.getText;
                  for i:=0 to tvp.ntp-1 do begin
                     j:=iprop.entry.IndexOf(tvp.tp[i].name);
                     if j<0 then continue;
                     entry:=TEdit(iprop.entry.Objects[j]);
                     if entry.Text<>'' then begin
                        tvp.tp[i].text:=entry.Text;
                        entry.Clear;
                        buf:=buf+tvp.tp[i].name+'='+tvp.tp[i].text+' ';
                     end;
                  end;
                  indiclient.sendNewText(tvp);
                end;
     INDI_NUMBER: begin
                  nvp:=iprop.iprop.getNumber;
                  for i:=0 to nvp.nnp-1 do begin
                     j:=iprop.entry.IndexOf(nvp.np[i].name);
                     if j<0 then continue;
                     entry:=TEdit(iprop.entry.Objects[j]);
                     if entry.Text<>'' then begin
                        val(entry.Text,value,er);
                        if er=0 then nvp.np[i].value:=value;
                        entry.Clear;
                        buf:=buf+nvp.np[i].name+'='+FloatToStr(nvp.np[i].value)+' ';
                     end;
                  end;
                  indiclient.sendNewNumber(nvp);
                end;
  end;
  NewMessage(buf);
end;

procedure Tf_indigui.SetSwitchButtonClick(Sender: TObject);
var iprop:TIndiProp;
    svp: ISwitchVectorProperty;
    sp: ISwitch;
    sname: string;
    i:integer;
begin
  sname:='';
  iprop:=TIndiProp(TSpeedButton(Sender).Tag);
  svp:=iprop.iprop.getSwitch;
  for i:=0 to iprop.ctrl.Count-1 do begin
     if iprop.ctrl.Objects[i]=Sender then begin
        sname:=iprop.ctrl[i];
        break;
     end;
  end;
  sp:=IUFindSwitch(svp,sname);
  if sp<>nil then begin
    if svp.r=ISR_1OFMANY then IUResetSwitch(svp);
    sp.s:=ISS_ON;
    NewMessage(iprop.name+' '+sp.name+'=ON');
    indiclient.sendNewSwitch(svp);
  end;
end;

procedure Tf_indigui.SetSwitchCheckClick(Sender: TObject; Index: integer);
var iprop:TIndiProp;
    svp: ISwitchVectorProperty;
    i:integer;
    buf:string;
begin
  iprop:=TIndiProp(TCheckGroup(Sender).Tag);
  svp:=iprop.iprop.getSwitch;
  IUResetSwitch(svp);
  buf:=iprop.name+' ';
  for i:=0 to TCheckGroup(Sender).Items.Count-1 do begin
     if TCheckGroup(Sender).Checked[i] then begin
       svp.sp[i].s:=ISS_ON;
       buf:=buf+svp.sp[i].name+'=ON';
     end;
  end;
  NewMessage(buf);
  indiclient.sendNewSwitch(svp);
end;

procedure Tf_indigui.SetSwitchComboChange(Sender: TObject);
var iprop:TIndiProp;
    svp: ISwitchVectorProperty;
    i:integer;
    buf:string;
begin
  iprop:=TIndiProp(TComboBox(Sender).Tag);
  svp:=iprop.iprop.getSwitch;
  IUResetSwitch(svp);
  buf:=iprop.name+' ';
  i:=TComboBox(Sender).ItemIndex;
  svp.sp[i].s:=ISS_ON;
  buf:=buf+svp.sp[i].name+'=ON';
  NewMessage(buf);
  indiclient.sendNewSwitch(svp);
end;

end.

