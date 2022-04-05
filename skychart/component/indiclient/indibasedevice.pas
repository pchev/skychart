unit indibasedevice;

{
Copyright (C) 2014 Patrick Chevalley

http://www.ap-i.net
pch@ap-i.net

This program is free software; you can redistribute it and/or
modify it under the terms of the GNU General Public License
as published by the Free Software Foundation; either version 2

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software
Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
}
{
   Pascal Indi client library freely inspired by libindiclient.
   See: http://www.indilib.org/
}

{$mode objfpc}{$H+}

interface

uses
  indiapi, indicom, DOM, contnrs, base64,
  Classes, SysUtils;

type

  // derived from indiproperty.h
  BaseDevice = class;
  IndiProperty = class;

  TIndiDeviceEvent = procedure(dp: Basedevice) of object;
  TIndiMessageEvent = procedure(mp: IMessage) of object;
  TIndiPropertyEvent = procedure(indiProp: IndiProperty) of object;
  TIndiNumberEvent = procedure(nvp: INumberVectorProperty) of object;
  TIndiTextEvent = procedure(tvp: ITextVectorProperty) of object;
  TIndiSwitchEvent = procedure(svp: ISwitchVectorProperty) of object;
  TIndiLightEvent = procedure(lvp: ILightVectorProperty) of object;
  TIndiBlobEvent = procedure(bp: IBLOB) of object;

  IndiProperty = class(TObject)
  private
    pPtr: TObject;
    dp: BaseDevice;
    pType: INDI_TYPE;
    pRegistered: boolean;
    pDynamic: boolean;
  public
    constructor Create;
    destructor Destroy; override;
    procedure setProperty(p: TObject);
    procedure setType(t: INDI_TYPE);
    procedure setRegistered(r: boolean);
    procedure setDynamic(d: boolean);
    procedure setBaseDevice(idp: BaseDevice);
    function getType(): INDI_TYPE;
    function getRegistered(): boolean;
    function isDynamic(): boolean;
    function getBaseDevice(): BaseDevice;

    function getName(): string;
    function getLabel(): string;
    function getGroupName(): string;
    function getDeviceName(): string;
    function getState(): IPState;
    function getPermission(): IPerm;

    function getNumber(): INumberVectorProperty;
    function getText(): ITextVectorProperty;
    function getSwitch(): ISwitchVectorProperty;
    function getLight(): ILightVectorProperty;
    function getBLOB(): IBLOBVectorProperty;
  end;

  // minimal basedevice for use as a client
  // derived from basedevice.h
  BaseDevice = class(TObject)
  private
    FIndiMessageEvent: TIndiMessageEvent;
    FIndiPropertyEvent: TIndiPropertyEvent;
    FIndiDeletePropertyEvent: TIndiPropertyEvent;
    FIndiNumberEvent: TIndiNumberEvent;
    FIndiTextEvent: TIndiTextEvent;
    FIndiSwitchEvent: TIndiSwitchEvent;
    FIndiLightEvent: TIndiLightEvent;
    FIndiBlobEvent: TIndiBlobEvent;
    deviceID: string;
    pAll: TObjectList;
  public
    constructor Create;
    destructor Destroy; override;
    function getDeviceName(): string;
    procedure setDeviceName(Value: string);
    function getProperty(Name: string; typ: INDI_TYPE = INDI_UNKNOWN): IndiProperty;
    function getRawProperty(Name: string; typ: INDI_TYPE = INDI_UNKNOWN): TObject;
    function getNumber(Name: string): INumberVectorProperty;
    function getText(Name: string): ITextVectorProperty;
    function getSwitch(Name: string): ISwitchVectorProperty;
    function getLight(Name: string): ILightVectorProperty;
    function getBlob(Name: string): IBLOBVectorProperty;
    function buildProp(root: TDOMNode; out errmsg: string): integer;
    function removeProperty(pname: string; out errmsg: string): integer;
    function setValue(root: TDOMNode; out errmsg: string): integer;
    function setBLOB(bvp: IBLOBVectorProperty; root: TDOMNode;
      out errmsg: string): integer;
    procedure checkMessage(root: TDOMNode);
    function getDriverInterface(): word;

    property onNewMessage: TIndiMessageEvent
      read FIndiMessageEvent write FIndiMessageEvent;
    property onNewProperty: TIndiPropertyEvent
      read FIndiPropertyEvent write FIndiPropertyEvent;
    property onDeleteProperty: TIndiPropertyEvent
      read FIndiDeletePropertyEvent write FIndiDeletePropertyEvent;
    property onNewNumber: TIndiNumberEvent
      read FIndiNumberEvent write FIndiNumberEvent;
    property onNewText: TIndiTextEvent read FIndiTextEvent write FIndiTextEvent;
    property onNewSwitch: TIndiSwitchEvent
      read FIndiSwitchEvent write FIndiSwitchEvent;
    property onNewLight: TIndiLightEvent read FIndiLightEvent write FIndiLightEvent;
    property onNewBlob: TIndiBlobEvent read FIndiBlobEvent write FIndiBlobEvent;
  end;


implementation

////////////////////// BaseDevice /////////////////////////////

constructor BaseDevice.Create;
begin
  inherited Create;
  deviceID := '';
  pAll := TObjectList.Create;
end;

destructor BaseDevice.Destroy;
begin
  if Ftrace then
    writeln('BaseDevice.Destroy');
  FreeAndNil(pAll);
  inherited Destroy;
end;

function BaseDevice.getDeviceName(): string;
begin
  if pAll <> nil then
    Result := deviceID
  else
    Result := '';
end;

procedure BaseDevice.setDeviceName(Value: string);
begin
  deviceID := Value;
end;

function BaseDevice.getProperty(Name: string; typ: INDI_TYPE = INDI_UNKNOWN): IndiProperty;
var
  i: integer;
begin
  for i := 0 to pAll.Count - 1 do
  begin
    if (IndiProperty(pAll.Items[i]).getName = Name) and
      ((typ = INDI_UNKNOWN) or (IndiProperty(pAll.Items[i]).getType = typ)) then
      exit(IndiProperty(pAll.Items[i]));
  end;
  Result := nil;
end;

function BaseDevice.getRawProperty(Name: string; typ: INDI_TYPE = INDI_UNKNOWN): TObject;
var
  i: integer;
begin
  for i := 0 to pAll.Count - 1 do
  begin
    if (IndiProperty(pAll.Items[i]).getName = Name) and
      ((typ = INDI_UNKNOWN) or (IndiProperty(pAll.Items[i]).getType = typ)) then
      exit(IndiProperty(pAll.Items[i]).pPtr);
  end;
  Result := nil;
end;

function BaseDevice.getNumber(Name: string): INumberVectorProperty;
begin
  Result := INumberVectorProperty(getRawProperty(Name, INDI_NUMBER));
end;

function BaseDevice.getText(Name: string): ITextVectorProperty;
begin
  Result := ITextVectorProperty(getRawProperty(Name, INDI_TEXT));
end;

function BaseDevice.getSwitch(Name: string): ISwitchVectorProperty;
begin
  Result := ISwitchVectorProperty(getRawProperty(Name, INDI_SWITCH));
end;

function BaseDevice.getLight(Name: string): ILightVectorProperty;
begin
  Result := ILightVectorProperty(getRawProperty(Name, INDI_LIGHT));
end;

function BaseDevice.getBlob(Name: string): IBLOBVectorProperty;
begin
  Result := IBLOBVectorProperty(getRawProperty(Name, INDI_BLOB));
end;

function BaseDevice.buildProp(root: TDOMNode; out errmsg: string): integer;
var
  perm: IPerm = IP_RW;
  state: IPState;
  timeout: double;
  rtag, rname, rdev: string;
  node, cnode: TDOMNode;
  indiProp: IndiProperty;
  nvp: INumberVectorProperty;
  np: INumber;
  svp: ISwitchVectorProperty;
  sp: ISwitch;
  tvp: ITextVectorProperty;
  tp: IText;
  lvp: ILightVectorProperty;
  lp: ILight;
  bvp: IBLOBVectorProperty;
  bp: IBLOB;
begin
  errmsg := '';
  rtag := GetNodeName(root);
  node := GetAttrib(root, 'name');
  if node = nil then
  begin
    errmsg := 'INDI: <' + rtag + '> unable to find name attribute';
    if ftrace then
      writeln(errmsg);
    exit(-1);
  end
  else
    rname := GetNodeValue(node);
  node := GetAttrib(root, 'device');
  if node = nil then
  begin
    errmsg := 'INDI: <' + rtag + '> unable to find device attribute';
    if ftrace then
      writeln(errmsg);
    exit(-1);
  end
  else
    rdev := GetNodeValue(node);
  if deviceID = '' then
    deviceID := rdev;
  if (getProperty(rname) <> nil) then
    exit(INDI_PROPERTY_DUPLICATED);
  if (rtag <> 'defLightVector') then
  begin
    cnode := GetAttrib(root, 'perm');
    if (cnode = nil) or (not crackIPerm(GetNodeValue(cnode), perm)) then
    begin
      if ftrace then
        writeln('no perm');
      exit(-1);
    end;
  end;
  cnode := GetAttrib(root, 'timeout');
  if cnode <> nil then
    timeout := StrToFloatDef(GetNodeValue(cnode), 0)
  else
    timeout := 0;
  cnode := GetAttrib(root, 'state');
  if (cnode = nil) or (not crackIPState(GetNodeValue(cnode), state)) then
  begin
    if ftrace then
      writeln('no state');
    exit(-1);
  end;
  if rtag = 'defNumberVector' then
  begin
    indiProp := IndiProperty.Create;
    nvp := INumberVectorProperty.Create;
    np := nil;
    nvp.nnp := 0;
    nvp.device := deviceID;
    nvp.Name := rname;
    if ftrace then
      writeln(rname);
    cnode := GetAttrib(root, 'label');
    if cnode <> nil then
      nvp.lbl := GetNodeValue(cnode);
    cnode := GetAttrib(root, 'group');
    if cnode <> nil then
      nvp.group := GetNodeValue(cnode);
    nvp.p := perm;
    nvp.s := state;
    nvp.timeout := timeout;
    node := root.FirstChild;
    while node <> nil do
    begin
      if node.NodeName = 'defNumber' then
      begin
        np := INumber.Create;
        np.nvp := nvp;
        cnode := node.FirstChild;
        if (cnode = nil) then
          np.Value := 0
        else
          f_scansexa(GetNodeValue(cnode), np.Value);
        cnode := GetAttrib(node, 'name');
        if cnode = nil then
          exit(-1);
        np.Name := GetNodeValue(cnode);
        cnode := GetAttrib(node, 'label');
        if cnode <> nil then
          np.lbl := GetNodeValue(cnode);
        cnode := GetAttrib(node, 'format');
        if cnode <> nil then
          np.format := GetNodeValue(cnode);
        cnode := GetAttrib(node, 'min');
        np.min := StrToFloatDef(GetNodeValue(cnode), 0);
        cnode := GetAttrib(node, 'max');
        np.max := StrToFloatDef(GetNodeValue(cnode), 0);
        cnode := GetAttrib(node, 'step');
        np.step := StrToFloatDef(GetNodeValue(cnode), 0);
        nvp.np.Add(np);
        Inc(nvp.nnp);
      end;
      node := node.NextSibling;
    end;
    indiProp.setBaseDevice(self);
    indiProp.setProperty(nvp);
    indiProp.setDynamic(True);
    indiProp.setType(INDI_NUMBER);
    pAll.Add(indiProp);
    if assigned(FIndiPropertyEvent) then
      FIndiPropertyEvent(indiProp);
  end
  else if rtag = 'defSwitchVector' then
  begin
    indiProp := IndiProperty.Create;
    svp := ISwitchVectorProperty.Create;
    sp := nil;
    svp.nsp := 0;
    svp.device := deviceID;
    svp.Name := rname;
    cnode := GetAttrib(root, 'label');
    if cnode <> nil then
      svp.lbl := GetNodeValue(cnode);
    cnode := GetAttrib(root, 'group');
    if cnode <> nil then
      svp.group := GetNodeValue(cnode);
    cnode := GetAttrib(root, 'rule');
    if (cnode = nil) or (not crackISRule(GetNodeValue(cnode), svp.r)) then
      svp.r := ISR_1OFMANY;
    svp.p := perm;
    svp.s := state;
    svp.timeout := timeout;
    node := root.FirstChild;
    while node <> nil do
    begin
      if node.NodeName = 'defSwitch' then
      begin
        sp := ISwitch.Create;
        sp.svp := svp;
        cnode := GetAttrib(node, 'name');
        if cnode = nil then
          exit(-1);
        sp.Name := GetNodeValue(cnode);
        cnode := GetAttrib(node, 'label');
        if cnode <> nil then
          sp.lbl := GetNodeValue(cnode);
        cnode := node.FirstChild;
        if (cnode <> nil) then
          crackISState(GetNodeValue(cnode), sp.s);
        svp.sp.Add(sp);
        Inc(svp.nsp);
      end;
      node := node.NextSibling;
    end;
    indiProp.setBaseDevice(self);
    indiProp.setProperty(svp);
    indiProp.setDynamic(True);
    indiProp.setType(INDI_SWITCH);
    pAll.Add(indiProp);
    if assigned(FIndiPropertyEvent) then
      FIndiPropertyEvent(indiProp);
  end
  else if rtag = 'defTextVector' then
  begin
    indiProp := IndiProperty.Create;
    tvp := ITextVectorProperty.Create;
    tp := nil;
    tvp.ntp := 0;
    tvp.device := deviceID;
    tvp.Name := rname;
    cnode := GetAttrib(root, 'label');
    if cnode <> nil then
      tvp.lbl := GetNodeValue(cnode);
    cnode := GetAttrib(root, 'group');
    if cnode <> nil then
      tvp.group := GetNodeValue(cnode);
    tvp.p := perm;
    tvp.s := state;
    tvp.timeout := timeout;
    node := root.FirstChild;
    while node <> nil do
    begin
      if node.NodeName = 'defText' then
      begin
        tp := IText.Create;
        tp.tvp := tvp;
        cnode := GetAttrib(node, 'name');
        if cnode = nil then
          exit(-1);
        tp.Name := GetNodeValue(cnode);
        cnode.Free;
        cnode := GetAttrib(node, 'label');
        if cnode <> nil then
          tp.lbl := GetNodeValue(cnode);
        cnode := node.FirstChild;
        if (cnode = nil) then
          tp.Text := ''
        else
          tp.Text := GetNodeValue(cnode);
        tvp.tp.Add(tp);
        Inc(tvp.ntp);
      end;
      node := node.NextSibling;
    end;
    indiProp.setBaseDevice(self);
    indiProp.setProperty(tvp);
    indiProp.setDynamic(True);
    indiProp.setType(INDI_TEXT);
    pAll.Add(indiProp);
    if assigned(FIndiPropertyEvent) then
      FIndiPropertyEvent(indiProp);
  end
  else if rtag = 'defLightVector' then
  begin
    indiProp := IndiProperty.Create;
    lvp := ILightVectorProperty.Create;
    lp := nil;
    lvp.nlp := 0;
    lvp.device := deviceID;
    lvp.Name := rname;
    cnode := GetAttrib(root, 'label');
    if cnode <> nil then
      lvp.lbl := GetNodeValue(cnode);
    cnode := GetAttrib(root, 'group');
    if cnode <> nil then
      lvp.group := GetNodeValue(cnode);
    lvp.s := state;
    node := root.FirstChild;
    while node <> nil do
    begin
      if node.NodeName = 'defLight' then
      begin
        lp := ILight.Create;
        lp.lvp := lvp;
        cnode := GetAttrib(node, 'name');
        if cnode = nil then
          exit(-1);
        lp.Name := GetNodeValue(cnode);
        cnode := GetAttrib(node, 'label');
        if cnode <> nil then
          lp.lbl := GetNodeValue(cnode);
        cnode := node.FirstChild;
        if (cnode <> nil) then
          crackIPState(GetNodeValue(cnode), lp.s);
        lvp.lp.Add(lp);
        Inc(lvp.nlp);
      end;
      node := node.NextSibling;
    end;
    indiProp.setBaseDevice(self);
    indiProp.setProperty(lvp);
    indiProp.setDynamic(True);
    indiProp.setType(INDI_LIGHT);
    pAll.Add(indiProp);
    if assigned(FIndiPropertyEvent) then
      FIndiPropertyEvent(indiProp);
  end
  else if rtag = 'defBLOBVector' then
  begin
    indiProp := IndiProperty.Create;
    bvp := IBLOBVectorProperty.Create;
    bp := nil;
    bvp.nbp := 0;
    bvp.device := deviceID;
    bvp.Name := rname;
    cnode := GetAttrib(root, 'label');
    if cnode <> nil then
      bvp.lbl := GetNodeValue(cnode);
    cnode := GetAttrib(root, 'group');
    if cnode <> nil then
      bvp.group := GetNodeValue(cnode);
    bvp.p := perm;
    bvp.s := state;
    bvp.timeout := timeout;
    node := root.FirstChild;
    while node <> nil do
    begin
      if node.NodeName = 'defBLOB' then
      begin
        bp := IBLOB.Create;
        bp.bvp := bvp;
        cnode := GetAttrib(node, 'name');
        if cnode = nil then
          exit(-1);
        bp.Name := GetNodeValue(cnode);
        cnode := GetAttrib(node, 'label');
        if cnode <> nil then
          bp.lbl := GetNodeValue(cnode);
        cnode := GetAttrib(node, 'format');
        if cnode <> nil then
          bp.format := GetNodeValue(cnode);
        bp.blob.Clear;
        bp.size := 0;
        bp.bloblen := 0;
        bvp.bp.Add(bp);
        Inc(bvp.nbp);
      end;
      node := node.NextSibling;
    end;
    indiProp.setBaseDevice(self);
    indiProp.setProperty(bvp);
    indiProp.setDynamic(True);
    indiProp.setType(INDI_BLOB);
    pAll.Add(indiProp);
    if assigned(FIndiPropertyEvent) then
      FIndiPropertyEvent(indiProp);
  end;
  Result := 0;
end;

function BaseDevice.removeProperty(pname: string; out errmsg: string): integer;
var
  indiProp: IndiProperty;
  i: integer;
begin
  errmsg := '';
  indiProp := getProperty(pname);
  if indiProp <> nil then
  begin
    if assigned(FIndiDeletePropertyEvent) then
      FIndiDeletePropertyEvent(indiProp);
    for i := 0 to pAll.Count do
    begin
      if pAll[i] = indiProp then
      begin
        pAll.Delete(i);
        break;
      end;
    end;
    exit(0);
  end
  else
  begin
    errmsg := format('Error: Property %s not found in device %s.', [pname, deviceID]);
    exit(-1);
  end;

end;

function BaseDevice.setValue(root: TDOMNode; out errmsg: string): integer;
var
  state: IPState = IPS_IDLE;
  timeout: double = 0;
  swState: ISState;
  lState: IPState;
  stateSet: boolean = False;
  timeoutSet: boolean = False;
  rtag, rname: string;
  node, pnode, cnode: TDOMNode;
  nvp: INumberVectorProperty;
  np: INumber;
  svp: ISwitchVectorProperty;
  sp: ISwitch;
  tvp: ITextVectorProperty;
  tp: IText;
  lvp: ILightVectorProperty;
  lp: ILight;
  bvp: IBLOBVectorProperty;
begin
  errmsg := '';
  rtag := GetNodeName(root);
  node := GetAttrib(root, 'name');
  if node = nil then
  begin
    errmsg := 'INDI: <' + rtag + '> unable to find name attribute';
    exit(-1);
  end
  else
    rname := GetNodeValue(node);
  node := GetAttrib(root, 'state');
  if node <> nil then
  begin
    if (not crackIPState(GetNodeValue(node), state)) then
    begin
      errmsg := 'INDI: <' + rtag + '> ' + rname + 'bogus state';
      exit(-1);
    end;
    stateSet := True;
  end;
  node := GetAttrib(root, 'timeout');
  if node <> nil then
  begin
    timeout := StrToFloatDef(GetNodeValue(node), 0);
    timeoutSet := True;
  end;

  checkMessage(root);

  if rtag = 'setNumberVector' then
  begin
    nvp := getNumber(rname);
    if nvp = nil then
    begin
      errmsg := 'INDI: Could not find property ' + rname + ' in ' + deviceID;
      exit(-1);
    end;
    if (stateSet) then
      nvp.s := state;
    if (timeoutSet) then
      nvp.timeout := timeout;
    node := root.FirstChild;
    while node <> nil do
    begin
      cnode := GetAttrib(node, 'name');
      if cnode = nil then begin
        node := node.NextSibling;
        continue;
      end;
      np := IUFindNumber(nvp, GetNodeValue(cnode));
      if np = nil then begin
        node := node.NextSibling;
        continue;
      end;
      cnode := node.FirstChild;
      if (cnode = nil) then
        np.Value := 0
      else
        f_scansexa(GetNodeValue(cnode), np.Value);
      pnode := GetAttrib(node, 'min');
      if pnode <> nil then
        np.min := StrToFloatDef(GetNodeValue(pnode), 0);
      pnode := GetAttrib(node, 'max');
      if pnode <> nil then
        np.max := StrToFloatDef(GetNodeValue(pnode), 0);
      node := node.NextSibling;
    end;
    if assigned(FIndiNumberEvent) then
      FIndiNumberEvent(nvp);
    exit(0);
  end
  else if rtag = 'setTextVector' then
  begin
    tvp := getText(rname);
    if tvp = nil then
    begin
      errmsg := 'INDI: Could not find property ' + rname + ' in ' + deviceID;
      exit(-1);
    end;
    if (stateSet) then
      tvp.s := state;
    if (timeoutSet) then
      tvp.timeout := timeout;
    node := root.FirstChild;
    while node <> nil do
    begin
      cnode := GetAttrib(node, 'name');
      if cnode = nil then begin
        node := node.NextSibling;
        continue;
      end;
      tp := IUFindText(tvp, GetNodeValue(cnode));
      if tp = nil then begin
        node := node.NextSibling;
        continue;
      end;
      cnode := node.FirstChild;
      if (cnode = nil) then
        tp.Text := ''
      else
        tp.Text := GetNodeValue(cnode);
      node := node.NextSibling;
    end;
    if assigned(FIndiTextEvent) then
      FIndiTextEvent(tvp);
    exit(0);
  end
  else if rtag = 'setSwitchVector' then
  begin
    svp := getSwitch(rname);
    if svp = nil then
    begin
      errmsg := 'INDI: Could not find property ' + rname + ' in ' + deviceID;
      exit(-1);
    end;
    if (stateSet) then
      svp.s := state;
    if (timeoutSet) then
      svp.timeout := timeout;
    node := root.FirstChild;
    while node <> nil do
    begin
      cnode := GetAttrib(node, 'name');
      if cnode = nil then begin
        node := node.NextSibling;
        continue;
      end;
      sp := IUFindSwitch(svp, GetNodeValue(cnode));
      if sp = nil then begin
        node := node.NextSibling;
        continue;
      end;
      cnode := node.FirstChild;
      if (cnode <> nil) then
        if crackISState(GetNodeValue(cnode), swState) then
          sp.s := swState;
      node := node.NextSibling;
    end;
    if assigned(FIndiSwitchEvent) then
      FIndiSwitchEvent(svp);
    exit(0);
  end
  else if rtag = 'setLightVector' then
  begin
    lvp := getLight(rname);
    if lvp = nil then
    begin
      errmsg := 'INDI: Could not find property ' + rname + ' in ' + deviceID;
      exit(-1);
    end;
    if (stateSet) then
      lvp.s := state;
    node := root.FirstChild;
    while node <> nil do
    begin
      cnode := GetAttrib(node, 'name');
      if cnode = nil then begin
        node := node.NextSibling;
        continue;
      end;
      lp := IUFindLight(lvp, GetNodeValue(cnode));
      if lp = nil then begin
        node := node.NextSibling;
        continue;
      end;
      cnode := node.FirstChild;
      if (cnode <> nil) then
        if crackIPState(GetNodeValue(cnode), lState) then
          lp.s := lState;
      node := node.NextSibling;
    end;
    if assigned(FIndiLightEvent) then
      FIndiLightEvent(lvp);
    exit(0);
  end
  else if rtag = 'setBLOBVector' then
  begin
    bvp := getBlob(rname);
    if bvp = nil then
    begin
      errmsg := 'INDI: Could not find property ' + rname + ' in ' + deviceID;
      exit(-1);
    end;
    if (stateSet) then
      bvp.s := state;
    if (timeoutSet) then
      bvp.timeout := timeout;
    Result := setBLOB(bvp, root, errmsg);
    exit;
  end;
  exit(-1);
end;

function BaseDevice.setBLOB(bvp: IBLOBVectorProperty; root: TDOMNode;
  out errmsg: string): integer;
var
  blobEL: IBLOB;
  str1: TStringStream;
  b64str: TBase64DecodingStream;
  node, cnode, na, fa, sa: TDOMNode;
begin
  node := root.FirstChild;
  while node <> nil do
  begin
    if node.NodeName = 'oneBLOB' then
    begin
      na := GetAttrib(node, 'name');
      blobEL := IUFindBLOB(bvp, GetNodeValue(na));
      fa := GetAttrib(node, 'format');
      sa := GetAttrib(node, 'size');
      if (na <> nil) and (fa <> nil) and (sa <> nil) then
      begin
        blobEL.size := StrToInt(GetNodeValue(sa));
        if (blobEL.size = 0) then
        begin
          errmsg := 'only blob attribute set';
          if assigned(FIndiBlobEvent) then
            FIndiBlobEvent(blobEL);
          node := node.NextSibling;
          continue;
        end;
        cnode := node.FirstChild;
        if cnode <> nil then
        begin
          // Only base64 decoding. The eventual decompression is done in
          // the final client to avoid a dependency to zlib here.
          str1 := TStringStream.Create(string(cnode.NodeValue));
          b64str := TBase64DecodingStream.Create(str1);
          try
            blobEL.blob.Clear;
            blobEL.blob.Position := 0;
            blobEL.blob.CopyFrom(b64str, b64str.Size);
            blobEL.bloblen := blobEL.blob.Size;
            blobEL.format := GetNodeValue(fa);
          finally
            str1.Free;
            b64str.Free;
          end;
          if assigned(FIndiBlobEvent) then
            FIndiBlobEvent(blobEL);
        end;
      end;
    end;
    node := node.NextSibling;
  end;
  exit(0);
end;

procedure BaseDevice.checkMessage(root: TDOMNode);
var
  node: TDOMNode;
  mp: IMessage;
begin
  node := GetAttrib(root, 'message');
  if node <> nil then
  begin
    mp:=IMessage.Create;
    mp.msg:=GetNodeValue(node);
    if assigned(FIndiMessageEvent) then
      FIndiMessageEvent(mp);
  end;
end;

function BaseDevice.getDriverInterface(): word;
var
  tvp: ITextVectorProperty;
  tp: IText;
begin
  Result := 0;
  tvp := getText('DRIVER_INFO');
  if tvp = nil then
    exit;
  tp := IUFindText(tvp, 'DRIVER_INTERFACE');
  if tp = nil then
    exit;
  Result := StrToIntDef(tp.Text, 0);
end;

////////////////////// IndiProperty /////////////////////////////

constructor IndiProperty.Create;
begin
  inherited Create;
  pPtr := nil;
  pRegistered := False;
  pDynamic := False;
  pType := INDI_UNKNOWN;
end;

destructor IndiProperty.Destroy;
begin
  if pPtr <> nil then
    pPtr.Free;
  inherited Destroy;
end;

procedure IndiProperty.setProperty(p: TObject);
begin
  pRegistered := True;
  pPtr := p;
end;

procedure IndiProperty.setType(t: INDI_TYPE);
begin
  pType := t;
end;

procedure IndiProperty.setRegistered(r: boolean);
begin
  pRegistered := r;
end;

procedure IndiProperty.setDynamic(d: boolean);
begin
  pDynamic := d;
end;

procedure IndiProperty.setBaseDevice(idp: BaseDevice);
begin
  dp := idp;
end;

function IndiProperty.getType(): INDI_TYPE;
begin
  Result := pType;
end;

function IndiProperty.getRegistered(): boolean;
begin
  Result := pRegistered;
end;

function IndiProperty.isDynamic(): boolean;
begin
  Result := pDynamic;
end;

function IndiProperty.getBaseDevice(): BaseDevice;
begin
  Result := dp;
end;

function IndiProperty.getName(): string;
begin
  if (pPtr = nil) then
    Result := ''
  else
  begin
    case pType of
      INDI_NUMBER: Result := INumberVectorProperty(pPtr).Name;
      INDI_TEXT: Result := ITextVectorProperty(pPtr).Name;
      INDI_SWITCH: Result := ISwitchVectorProperty(pPtr).Name;
      INDI_LIGHT: Result := ILightVectorProperty(pPtr).Name;
      INDI_BLOB: Result := IBLOBVectorProperty(pPtr).Name;
      else
        Result := '';
    end;
  end;
end;

function IndiProperty.getLabel(): string;
begin
  if (pPtr = nil) then
    Result := ''
  else
  begin
    case pType of
      INDI_NUMBER: Result := INumberVectorProperty(pPtr).lbl;
      INDI_TEXT: Result := ITextVectorProperty(pPtr).lbl;
      INDI_SWITCH: Result := ISwitchVectorProperty(pPtr).lbl;
      INDI_LIGHT: Result := ILightVectorProperty(pPtr).lbl;
      INDI_BLOB: Result := IBLOBVectorProperty(pPtr).lbl;
      else
        Result := '';
    end;
  end;
end;

function IndiProperty.getGroupName(): string;
begin
  if (pPtr = nil) then
    Result := ''
  else
  begin
    case pType of
      INDI_NUMBER: Result := INumberVectorProperty(pPtr).group;
      INDI_TEXT: Result := ITextVectorProperty(pPtr).group;
      INDI_SWITCH: Result := ISwitchVectorProperty(pPtr).group;
      INDI_LIGHT: Result := ILightVectorProperty(pPtr).group;
      INDI_BLOB: Result := IBLOBVectorProperty(pPtr).group;
      else
        Result := '';
    end;
  end;
end;

function IndiProperty.getDeviceName(): string;
begin
  if (pPtr = nil) then
    Result := ''
  else
  begin
    case pType of
      INDI_NUMBER: Result := INumberVectorProperty(pPtr).device;
      INDI_TEXT: Result := ITextVectorProperty(pPtr).device;
      INDI_SWITCH: Result := ISwitchVectorProperty(pPtr).device;
      INDI_LIGHT: Result := ILightVectorProperty(pPtr).device;
      INDI_BLOB: Result := IBLOBVectorProperty(pPtr).device;
      else
        Result := '';
    end;
  end;
end;

function IndiProperty.getState(): IPState;
begin
  if (pPtr = nil) then
    Result := IPS_IDLE
  else
  begin
    case pType of
      INDI_NUMBER: Result := INumberVectorProperty(pPtr).s;
      INDI_TEXT: Result := ITextVectorProperty(pPtr).s;
      INDI_SWITCH: Result := ISwitchVectorProperty(pPtr).s;
      INDI_LIGHT: Result := ILightVectorProperty(pPtr).s;
      INDI_BLOB: Result := IBLOBVectorProperty(pPtr).s;
      else
        Result := IPS_IDLE;
    end;
  end;
end;

function IndiProperty.getPermission(): IPerm;
begin
  if (pPtr = nil) then
    Result := IP_RO
  else
  begin
    case pType of
      INDI_NUMBER: Result := INumberVectorProperty(pPtr).p;
      INDI_TEXT: Result := ITextVectorProperty(pPtr).p;
      INDI_SWITCH: Result := ISwitchVectorProperty(pPtr).p;
      INDI_BLOB: Result := IBLOBVectorProperty(pPtr).p;
      else
        Result := IP_RO;
    end;
  end;
end;

function IndiProperty.getNumber(): INumberVectorProperty;
begin
  if (pType = INDI_NUMBER) then
    Result := INumberVectorProperty(pPtr)
  else
    Result := nil;
end;

function IndiProperty.getText(): ITextVectorProperty;
begin
  if (pType = INDI_TEXT) then
    Result := iTextVectorProperty(pPtr)
  else
    Result := nil;
end;

function IndiProperty.getSwitch(): ISwitchVectorProperty;
begin
  if (pType = INDI_SWITCH) then
    Result := ISwitchVectorProperty(pPtr)
  else
    Result := nil;
end;

function IndiProperty.getLight(): ILightVectorProperty;
begin
  if (pType = INDI_LIGHT) then
    Result := ILightVectorProperty(pPtr)
  else
    Result := nil;
end;

function IndiProperty.getBLOB(): IBLOBVectorProperty;
begin
  if (pType = INDI_BLOB) then
    Result := IBLOBVectorProperty(pPtr)
  else
    Result := nil;
end;

end.
