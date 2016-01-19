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

uses indiapi, indicom, DOM, contnrs, base64,
  Classes, SysUtils;

type

  // derived from indiproperty.h
  BaseDevice = class;
  IndiProperty = class;


  TIndiDeviceEvent = procedure(dp: Basedevice) of object;
  TIndiMessageEvent = procedure(msg: string) of object;
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
      destructor Destroy;override;
      procedure setProperty(p: TObject);
      procedure setType(t:INDI_TYPE);
      procedure setRegistered(r:Boolean);
      procedure setDynamic(d:Boolean);
      procedure setBaseDevice(idp:BaseDevice);
      function  getType():INDI_TYPE;
      function  getRegistered(): Boolean;
      function  isDynamic():Boolean;
      function  getBaseDevice():BaseDevice;

      function getName(): string;
      function getLabel(): string;
      function getGroupName(): string;
      function getDeviceName(): string;
      function getState():IPState;
      function getPermission():IPerm;

      function getNumber():INumberVectorProperty;
      function getText():ITextVectorProperty;
      function getSwitch():ISwitchVectorProperty;
      function getLight():ILightVectorProperty;
      function getBLOB():IBLOBVectorProperty;
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
      destructor Destroy;override;
      function getDeviceName(): string;
      procedure setDeviceName(value:string);
      function getProperty(name: string; typ: INDI_TYPE=INDI_UNKNOWN):IndiProperty;
      function getRawProperty(name: string; typ: INDI_TYPE=INDI_UNKNOWN):TObject;
      function getNumber(name: string):INumberVectorProperty;
      function getText(name: string):ITextVectorProperty;
      function getSwitch(name: string):ISwitchVectorProperty;
      function getLight(name: string):ILightVectorProperty;
      function getBlob(name: string):IBLOBVectorProperty;
      function buildProp(root: TDOMNode; out errmsg: string):integer;
      function removeProperty(pname: string; out errmsg: string):integer;
      function setValue(root: TDOMNode; out errmsg: string):integer;
      function setBLOB(bvp: IBLOBVectorProperty; root: TDOMNode; out errmsg:string): integer;
      procedure checkMessage(root: TDOMNode);

      property onNewMessage  : TIndiMessageEvent read FIndiMessageEvent write FIndiMessageEvent;
      property onNewProperty : TIndiPropertyEvent read FIndiPropertyEvent write FIndiPropertyEvent;
      property onDeleteProperty : TIndiPropertyEvent read FIndiDeletePropertyEvent write FIndiDeletePropertyEvent;
      property onNewNumber : TIndiNumberEvent read FIndiNumberEvent write FIndiNumberEvent;
      property onNewText   : TIndiTextEvent read FIndiTextEvent write FIndiTextEvent;
      property onNewSwitch : TIndiSwitchEvent read FIndiSwitchEvent write FIndiSwitchEvent;
      property onNewLight  : TIndiLightEvent read FIndiLightEvent write FIndiLightEvent;
      property onNewBlob   : TIndiBlobEvent read FIndiBlobEvent write FIndiBlobEvent;
  end;


implementation

////////////////////// BaseDevice /////////////////////////////

constructor BaseDevice.Create;
begin
 inherited Create;
 deviceID:='';
 pAll:=TObjectList.Create;
end;

destructor BaseDevice.Destroy;
begin
 if Ftrace then writeln('BaseDevice.Destroy');
 FreeAndNil(pAll);
 inherited Destroy;
end;

function BaseDevice.getDeviceName(): string;
begin
  if pAll<>nil then result:=deviceID;
end;

procedure BaseDevice.setDeviceName(value:string);
begin
  deviceID:=value;
end;

function BaseDevice.getProperty(name: string; typ: INDI_TYPE=INDI_UNKNOWN):IndiProperty;
var i: integer;
begin
  for i:=0 to pAll.Count-1 do begin
    if (IndiProperty(pAll.Items[i]).getName = name) and
       ((typ=INDI_UNKNOWN)or(IndiProperty(pAll.Items[i]).getType = typ))
       then
           exit(IndiProperty(pAll.Items[i]));
  end;
  result:=nil;
end;

function BaseDevice.getRawProperty(name: string; typ: INDI_TYPE=INDI_UNKNOWN):TObject;
var i: integer;
begin
  for i:=0 to pAll.Count-1 do begin
    if (IndiProperty(pAll.Items[i]).getName = name) and
       ((typ=INDI_UNKNOWN)or(IndiProperty(pAll.Items[i]).getType = typ))
       then
           exit(IndiProperty(pAll.Items[i]).pPtr);
  end;
  result:=nil;
end;

function BaseDevice.getNumber(name: string):INumberVectorProperty;
begin
   result:=INumberVectorProperty(getRawProperty(name,INDI_NUMBER));
end;

function BaseDevice.getText(name: string):ITextVectorProperty;
begin
   result:=ITextVectorProperty(getRawProperty(name,INDI_TEXT));
end;

function BaseDevice.getSwitch(name: string):ISwitchVectorProperty;
begin
   result:=ISwitchVectorProperty(getRawProperty(name,INDI_SWITCH));
end;

function BaseDevice.getLight(name: string):ILightVectorProperty;
begin
   result:=ILightVectorProperty(getRawProperty(name,INDI_LIGHT));
end;

function BaseDevice.getBlob(name: string):IBLOBVectorProperty;
begin
   result:=IBLOBVectorProperty(getRawProperty(name,INDI_BLOB));
end;

function BaseDevice.buildProp(root: TDOMNode; out errmsg: string):integer;
var perm: IPerm;
    state: IPState;
    timeout: double;
    rtag,rname,rdev: string;
    node,cnode: TDOMNode;
    indiProp: IndiProperty;
    nvp: INumberVectorProperty;
    np:  INumber;
    svp: ISwitchVectorProperty;
    sp:  ISwitch;
    tvp: ITextVectorProperty;
    tp:  IText;
    lvp: ILightVectorProperty;
    lp:  ILight;
    bvp: IBLOBVectorProperty;
    bp:  IBLOB;
begin
  rtag:=GetNodeName(root);
  node:=GetAttrib(root,'name');
  if node=nil then begin
     errmsg:='INDI: <'+rtag+'> unable to find name attribute';
     if ftrace then writeln(errmsg);
     exit(-1);
  end else
    rname:=GetNodeValue(node);
  node:=GetAttrib(root,'device');
  if node=nil then begin
     errmsg:='INDI: <'+rtag+'> unable to find device attribute';
     if ftrace then writeln(errmsg);
     exit(-1);
  end else
     rdev:=GetNodeValue(node);
  if deviceID='' then deviceID:=rdev;
  if (getProperty(rname)<>nil) then
        exit(INDI_PROPERTY_DUPLICATED);
  if (rtag<>'defLightVector') then begin
    cnode:=GetAttrib(root,'perm');
    if (cnode=nil)or(not crackIPerm(GetNodeValue(cnode),perm)) then  begin
        if ftrace then writeln('no perm');
        exit(-1);
    end;
  end;
  cnode:=GetAttrib(root,'timeout');
  if cnode<>nil then timeout:=StrToFloatDef(GetNodeValue(cnode),0) else timeout:=0;
  cnode:=GetAttrib(root,'state');
  if (cnode=nil)or(not crackIPState(GetNodeValue(cnode),state)) then begin
       if ftrace then writeln('no state');
       exit(-1);
  end;
  if rtag='defNumberVector' then begin
    indiProp:=IndiProperty.Create;
    nvp:=INumberVectorProperty.Create;
    np:=nil;
    nvp.nnp:=0;
    nvp.device:= deviceID;
    nvp.name  := rname;
    if ftrace then writeln(rname);
    cnode:=GetAttrib(root,'label');
    if cnode<>nil then nvp.lbl:= GetNodeValue(cnode);
    cnode:=GetAttrib(root,'group');
    if cnode<>nil then nvp.group:= GetNodeValue(cnode);
    nvp.p     := perm;
    nvp.s     := state;
    nvp.timeout := timeout;
    node:=root.FirstChild;
    while node<> nil do begin
      if node.NodeName='defNumber' then begin
        np:=INumber.Create;
        np.nvp:=nvp;
        cnode:=node.FirstChild;
        if (cnode=nil) then np.value:=0
           else f_scansexa(GetNodeValue(cnode),np.value);
        cnode:=GetAttrib(node,'name');
        if cnode=nil then exit(-1);
        np.name:=GetNodeValue(cnode);
        cnode:=GetAttrib(node,'label');
        if cnode<>nil then np.lbl :=GetNodeValue(cnode);
        cnode:=GetAttrib(node,'format');
        if cnode<>nil then np.format:=GetNodeValue(cnode);
        cnode:=GetAttrib(node,'min');
        np.min:=StrToFloatDef(GetNodeValue(cnode),0);
        cnode:=GetAttrib(node,'max');
        np.max:=StrToFloatDef(GetNodeValue(cnode),0);
        cnode:=GetAttrib(node,'step');
        np.step:=StrToFloatDef(GetNodeValue(cnode),0);
        nvp.np.Add(np);
        inc(nvp.nnp);
      end;
      node:=node.NextSibling;
    end;
    indiProp.setBaseDevice(self);
    indiProp.setProperty(nvp);
    indiProp.setDynamic(true);
    indiProp.setType(INDI_NUMBER);
    pAll.Add(indiProp);
    if assigned(FIndiPropertyEvent) then FIndiPropertyEvent(indiProp);
  end
  else if rtag='defSwitchVector' then begin
    indiProp:=IndiProperty.Create;
    svp:=ISwitchVectorProperty.Create;
    sp:=nil;
    svp.nsp:=0;
    svp.device:= deviceID;
    svp.name  := rname;
    cnode:=GetAttrib(root,'label');
    if cnode<>nil then svp.lbl:= GetNodeValue(cnode);
    cnode:=GetAttrib(root,'group');
    if cnode<>nil then svp.group:= GetNodeValue(cnode);
    cnode:=GetAttrib(root,'rule');
    if (cnode=nil)or(not crackISRule(GetNodeValue(cnode), svp.r)) then svp.r:=ISR_1OFMANY;
    svp.p     := perm;
    svp.s     := state;
    svp.timeout := timeout;
    node:=root.FirstChild;
    while node<> nil do begin
      if node.NodeName='defSwitch' then begin
        sp:=ISwitch.Create;
        sp.svp:=svp;
        cnode:=GetAttrib(node,'name');
        if cnode=nil then exit(-1);
        sp.name:=GetNodeValue(cnode);
        cnode:=GetAttrib(node,'label');
        if cnode<>nil then sp.lbl :=GetNodeValue(cnode);
        cnode:=node.FirstChild;
        if (cnode<>nil) then
            crackISState(GetNodeValue(cnode),sp.s);
        svp.sp.Add(sp);
        inc(svp.nsp);
      end;
      node:=node.NextSibling;
    end;
    indiProp.setBaseDevice(self);
    indiProp.setProperty(svp);
    indiProp.setDynamic(true);
    indiProp.setType(INDI_SWITCH);
    pAll.Add(indiProp);
    if assigned(FIndiPropertyEvent) then FIndiPropertyEvent(indiProp);
  end
  else if rtag='defTextVector' then begin
    indiProp:=IndiProperty.Create;
    tvp:=ITextVectorProperty.Create;
    tp:=nil;
    tvp.ntp:=0;
    tvp.device:= deviceID;
    tvp.name  := rname;
    cnode:=GetAttrib(root,'label');
    if cnode<>nil then tvp.lbl:= GetNodeValue(cnode);
    cnode:=GetAttrib(root,'group');
    if cnode<>nil then tvp.group:= GetNodeValue(cnode);
    tvp.p     := perm;
    tvp.s     := state;
    tvp.timeout := timeout;
    node:=root.FirstChild;
    while node<> nil do begin
      if node.NodeName='defText' then begin
        tp:=IText.Create;
        tp.tvp:=tvp;
        cnode:=GetAttrib(node,'name');
        if cnode=nil then exit(-1);
        tp.name:=GetNodeValue(cnode);
        cnode.Free;
        cnode:=GetAttrib(node,'label');
        if cnode<>nil then tp.lbl :=GetNodeValue(cnode);
        cnode:=node.FirstChild;
        if (cnode=nil) then tp.text:=''
           else tp.text:=GetNodeValue(cnode);
        tvp.tp.Add(tp);
        inc(tvp.ntp);
      end;
      node:=node.NextSibling;
    end;
    indiProp.setBaseDevice(self);
    indiProp.setProperty(tvp);
    indiProp.setDynamic(true);
    indiProp.setType(INDI_TEXT);
    pAll.Add(indiProp);
    if assigned(FIndiPropertyEvent) then FIndiPropertyEvent(indiProp);
  end
  else if rtag='defLightVector' then begin
    indiProp:=IndiProperty.Create;
    lvp:=ILightVectorProperty.Create;
    lp:=nil;
    lvp.nlp:=0;
    lvp.device:= deviceID;
    lvp.name  := rname;
    cnode:=GetAttrib(root,'label');
    if cnode<>nil then lvp.lbl:= GetNodeValue(cnode);
    cnode:=GetAttrib(root,'group');
    if cnode<>nil then lvp.group:= GetNodeValue(cnode);
    lvp.s     := state;
    node:=root.FirstChild;
    while node<> nil do begin
      if node.NodeName='defLight' then begin
        lp:=ILight.Create;
        lp.lvp:=lvp;
        cnode:=GetAttrib(node,'name');
        if cnode=nil then exit(-1);
        lp.name:=GetNodeValue(cnode);
        cnode:=GetAttrib(node,'label');
        if cnode<>nil then lp.lbl :=GetNodeValue(cnode);
        cnode:=node.FirstChild;
        if (cnode<>nil) then
            crackIPState(GetNodeValue(cnode), lp.s);
        lvp.lp.Add(lp);
        inc(lvp.nlp);
      end;
      node:=node.NextSibling;
    end;
    indiProp.setBaseDevice(self);
    indiProp.setProperty(lvp);
    indiProp.setDynamic(true);
    indiProp.setType(INDI_LIGHT);
    pAll.Add(indiProp);
    if assigned(FIndiPropertyEvent) then FIndiPropertyEvent(indiProp);
  end
  else if rtag='defBLOBVector' then begin
    indiProp:=IndiProperty.Create;
    bvp:=IBLOBVectorProperty.Create;
    bp:=nil;
    bvp.nbp:=0;
    bvp.device:= deviceID;
    bvp.name  := rname;
    cnode:=GetAttrib(root,'label');
    if cnode<>nil then bvp.lbl:= GetNodeValue(cnode);
    cnode:=GetAttrib(root,'group');
    if cnode<>nil then bvp.group:= GetNodeValue(cnode);
    bvp.p     := perm;
    bvp.s     := state;
    bvp.timeout := timeout;
    node:=root.FirstChild;
    while node<> nil do begin
      if node.NodeName='defBLOB' then begin
        bp:=IBLOB.Create;
        bp.bvp:=bvp;
        cnode:=GetAttrib(node,'name');
        if cnode=nil then exit(-1);
        bp.name:=GetNodeValue(cnode);
        cnode:=GetAttrib(node,'label');
        if cnode<>nil then bp.lbl :=GetNodeValue(cnode);
        cnode:=GetAttrib(node,'format');
        if cnode<>nil then bp.format :=GetNodeValue(cnode);
        bp.blob.Clear;
        bp.size:=0;
        bp.bloblen:=0;
        bvp.bp.Add(bp);
        inc(bvp.nbp);
      end;
      node:=node.NextSibling;
    end;
    indiProp.setBaseDevice(self);
    indiProp.setProperty(bvp);
    indiProp.setDynamic(true);
    indiProp.setType(INDI_BLOB);
    pAll.Add(indiProp);
    if assigned(FIndiPropertyEvent) then FIndiPropertyEvent(indiProp);
  end;

end;

function BaseDevice.removeProperty(pname: string; out errmsg: string):integer;
var indiProp: IndiProperty;
    i: integer;
begin
 indiProp:=getProperty(pname);
 if indiProp<>nil then begin
  if assigned(FIndiDeletePropertyEvent) then FIndiDeletePropertyEvent(indiProp);
  for i:=0 to pAll.Count do begin
     if pAll[i]=indiProp then begin
        pAll.Delete(i);
        break;
     end;
  end;
  exit(0);
 end
 else begin
   errmsg:=format('Error: Property %s not found in device %s.',[pname,deviceID]);
   exit(-1);
 end;

end;

function BaseDevice.setValue(root: TDOMNode; out errmsg: string):integer;
var state: IPState;
    timeout: double;
    swState: ISState;
    lState: IPState;
    stateSet: boolean = false;
    timeoutSet: boolean = false;
    rtag,rname: string;
    node,pnode,cnode: TDOMNode;
    nvp: INumberVectorProperty;
    np:  INumber;
    svp: ISwitchVectorProperty;
    sp:  ISwitch;
    tvp: ITextVectorProperty;
    tp:  IText;
    lvp: ILightVectorProperty;
    lp:  ILight;
    bvp: IBLOBVectorProperty;
begin
  rtag:=GetNodeName(root);
  node:=GetAttrib(root,'name');
  if node=nil then begin
     errmsg:='INDI: <'+rtag+'> unable to find name attribute';
     exit(-1);
  end else
    rname:=GetNodeValue(node);
  node:=GetAttrib(root,'state');
  if node<>nil then begin
     if (not crackIPState(GetNodeValue(node),state)) then begin
        errmsg:='INDI: <'+rtag+'> '+rname+'bogus state';
        exit(-1);
     end;
     stateSet := true;
  end;
  node:=GetAttrib(root,'timeout');
  if node<>nil then begin
    timeout:=StrToFloatDef(GetNodeValue(node),0);
    timeoutSet := true;
  end;

  checkMessage(root);

  if rtag='setNumberVector' then begin
    nvp := getNumber(rname);
    if nvp=nil then begin
       errmsg:='INDI: Could not find property '+rname+' in '+deviceID;
       exit(-1);
    end;
    if (stateSet) then nvp.s := state;
    if (timeoutSet) then nvp.timeout := timeout;
    node:=root.FirstChild;
    while node<> nil do begin
      cnode:=GetAttrib(node,'name');
      if cnode=nil then continue;
      np:=IUFindNumber(nvp,GetNodeValue(cnode));
      if np=nil then continue;
      cnode:=node.FirstChild;
      if (cnode=nil) then np.value:=0
         else f_scansexa(GetNodeValue(cnode),np.value);
      pnode:=GetAttrib(node,'min');
      if pnode<>nil then np.min:=StrToFloatDef(GetNodeValue(pnode),0);
      pnode:=GetAttrib(node,'max');
      if pnode<>nil then np.max:=StrToFloatDef(GetNodeValue(pnode),0);
      node:=node.NextSibling;
    end;
    if assigned(FIndiNumberEvent) then FIndiNumberEvent(nvp);
    exit(0);
  end
  else if rtag='setTextVector' then begin
    tvp := getText(rname);
    if tvp=nil then begin
       errmsg:='INDI: Could not find property '+rname+' in '+deviceID;
       exit(-1);
    end;
    if (stateSet) then tvp.s := state;
    if (timeoutSet) then tvp.timeout := timeout;
    node:=root.FirstChild;
    while node<> nil do begin
      cnode:=GetAttrib(node,'name');
      if cnode=nil then continue;
      tp:=IUFindText(tvp,GetNodeValue(cnode));
      if tp=nil then continue;
      cnode:=node.FirstChild;
      if (cnode=nil) then tp.text:=''
         else tp.text:=GetNodeValue(cnode);
      node:=node.NextSibling;
    end;
    if assigned(FIndiTextEvent) then FIndiTextEvent(tvp);
    exit(0);
  end
  else if rtag='setSwitchVector' then begin
    svp := getSwitch(rname);
    if svp=nil then begin
       errmsg:='INDI: Could not find property '+rname+' in '+deviceID;
       exit(-1);
    end;
    if (stateSet) then svp.s := state;
    if (timeoutSet) then svp.timeout := timeout;
    node:=root.FirstChild;
    while node<> nil do begin
      cnode:=GetAttrib(node,'name');
      if cnode=nil then continue;
      sp:=IUFindSwitch(svp,GetNodeValue(cnode));
      if sp=nil then continue;
      cnode:=node.FirstChild;
      if (cnode<>nil) then
          if crackISState(GetNodeValue(cnode),swState) then sp.s:=swState;
      node:=node.NextSibling;
    end;
    if assigned(FIndiSwitchEvent) then FIndiSwitchEvent(svp);
    exit(0);
  end
  else if rtag='setLightVector' then begin
    lvp := getLight(rname);
    if lvp=nil then begin
       errmsg:='INDI: Could not find property '+rname+' in '+deviceID;
       exit(-1);
    end;
    if (stateSet) then lvp.s := state;
    node:=root.FirstChild;
    while node<> nil do begin
      cnode:=GetAttrib(node,'name');
      if cnode=nil then continue;
      lp:=IUFindLight(lvp,GetNodeValue(cnode));
      if lp=nil then continue;
      cnode:=node.FirstChild;
      if (cnode<>nil) then
          if crackIPState(GetNodeValue(cnode), lState) then lp.s:=lState;
      node:=node.NextSibling;
    end;
    if assigned(FIndiLightEvent) then FIndiLightEvent(lvp);
    exit(0);
  end
  else if rtag='setBLOBVector' then begin
    bvp := getBlob(rname);
    if bvp=nil then begin
       errmsg:='INDI: Could not find property '+rname+' in '+deviceID;
       exit(-1);
    end;
    if (stateSet) then bvp.s := state;
    if (timeoutSet) then bvp.timeout := timeout;
    result:=setBLOB(bvp, root, errmsg);
    exit;
  end;
  exit(-1);
end;

function BaseDevice.setBLOB(bvp: IBLOBVectorProperty; root: TDOMNode; out errmsg:string): integer;
var blobEL: IBLOB;
    str1:TStringStream;
    b64str: TBase64DecodingStream;
    node,cnode,na,fa,sa: TDOMNode;
begin
  node:=root.FirstChild;
  while node<> nil do begin
    if node.NodeName='oneBLOB' then begin
      na := GetAttrib(node,'name');
      blobEL := IUFindBLOB(bvp, GetNodeValue(na));
      fa := GetAttrib(node,'format');
      sa := GetAttrib(node,'size');
      if (na<>nil)and(fa<>nil)and(sa<>nil) then begin
        blobEL.size:=StrToInt(GetNodeValue(sa));
        if (blobEL.size = 0) then begin
            errmsg:='only blob attribute set';
            if assigned(FIndiBlobEvent) then FIndiBlobEvent(blobEL);
            continue;
        end;
        cnode:=node.FirstChild;
        if cnode<>nil then begin
          // Only base64 decoding. The eventual decompression is done in
          // the final client to avoid a dependency to zlib here.
          str1:=TStringStream.Create(string(cnode.NodeValue));
          b64str:=TBase64DecodingStream.Create(str1);
          try
          blobEL.blob.Clear;
          blobEL.blob.Position:=0;
          blobEL.blob.CopyFrom(b64str,b64str.Size);
          blobEL.bloblen:=blobEL.blob.Size;
          blobEL.format:=GetNodeValue(fa);
          finally
            str1.Free;
            b64str.Free;
          end;
          if assigned(FIndiBlobEvent) then FIndiBlobEvent(blobEL);
        end;
      end;
    end;
    node:=node.NextSibling;
  end;
  exit (0);
end;

procedure BaseDevice.checkMessage(root: TDOMNode);
var node: TDOMNode;
    buf: string;
begin
  node:=GetAttrib(root,'message');
  if node <> nil then begin
     buf:=GetNodeValue(node);
     if assigned(FIndiMessageEvent) then FIndiMessageEvent(buf);
  end;
end;

////////////////////// IndiProperty /////////////////////////////

constructor IndiProperty.Create;
begin
 inherited Create;
 pPtr := nil;
 pRegistered := false;
 pDynamic := false;
 pType := INDI_UNKNOWN;
end;

destructor IndiProperty.Destroy;
begin
  if pPtr<>nil then pPtr.Free;
  inherited Destroy;
end;

procedure IndiProperty.setProperty(p: TObject);
begin
 pRegistered := true;
 pPtr := p;
end;

procedure IndiProperty.setType(t:INDI_TYPE);
begin
  pType:=t;
end;

procedure IndiProperty.setRegistered(r:Boolean);
begin
 pRegistered:=r;
end;

procedure IndiProperty.setDynamic(d:Boolean);
begin
 pDynamic:=d;
end;

procedure IndiProperty.setBaseDevice(idp:BaseDevice);
begin
 dp:=idp;
end;

function  IndiProperty.getType():INDI_TYPE;
begin
  result:=pType;
end;

function  IndiProperty.getRegistered(): Boolean;
begin
 result:=pRegistered;
end;

function  IndiProperty.isDynamic():Boolean;
begin
 result:=pDynamic;
end;

function  IndiProperty.getBaseDevice():BaseDevice;
begin
 result:=dp;
end;

function IndiProperty.getName(): string;
begin
if (pPtr=nil) then result:=''
else begin
  case pType of
    INDI_NUMBER:  result := INumberVectorProperty(pPtr).name;
    INDI_TEXT:    result := ITextVectorProperty(pPtr).name;
    INDI_SWITCH:  result := ISwitchVectorProperty(pPtr).name;
    INDI_LIGHT:   result := ILightVectorProperty(pPtr).name;
    INDI_BLOB:    result := IBLOBVectorProperty(pPtr).name;
    else result := '';
  end;
end;
end;

function IndiProperty.getLabel(): string;
begin
if (pPtr=nil) then result:=''
else begin
  case pType of
    INDI_NUMBER:  result := INumberVectorProperty(pPtr).lbl;
    INDI_TEXT:    result := ITextVectorProperty(pPtr).lbl;
    INDI_SWITCH:  result := ISwitchVectorProperty(pPtr).lbl;
    INDI_LIGHT:   result := ILightVectorProperty(pPtr).lbl;
    INDI_BLOB:    result := IBLOBVectorProperty(pPtr).lbl;
    else result := '';
  end;
end;
end;

function IndiProperty.getGroupName(): string;
begin
if (pPtr=nil) then result:=''
else begin
  case pType of
    INDI_NUMBER:  result := INumberVectorProperty(pPtr).group;
    INDI_TEXT:    result := ITextVectorProperty(pPtr).group;
    INDI_SWITCH:  result := ISwitchVectorProperty(pPtr).group;
    INDI_LIGHT:   result := ILightVectorProperty(pPtr).group;
    INDI_BLOB:    result := IBLOBVectorProperty(pPtr).group;
    else result := '';
  end;
end;
end;

function IndiProperty.getDeviceName(): string;
begin
if (pPtr=nil) then result:=''
else begin
  case pType of
    INDI_NUMBER:  result := INumberVectorProperty(pPtr).device;
    INDI_TEXT:    result := ITextVectorProperty(pPtr).device;
    INDI_SWITCH:  result := ISwitchVectorProperty(pPtr).device;
    INDI_LIGHT:   result := ILightVectorProperty(pPtr).device;
    INDI_BLOB:    result := IBLOBVectorProperty(pPtr).device;
    else result := '';
  end;
end;
end;

function IndiProperty.getState():IPState;
begin
if (pPtr=nil) then result:=IPS_IDLE
else begin
  case pType of
    INDI_NUMBER:  result := INumberVectorProperty(pPtr).s;
    INDI_TEXT:    result := ITextVectorProperty(pPtr).s;
    INDI_SWITCH:  result := ISwitchVectorProperty(pPtr).s;
    INDI_LIGHT:   result := ILightVectorProperty(pPtr).s;
    INDI_BLOB:    result := IBLOBVectorProperty(pPtr).s;
    else result := IPS_IDLE;
  end;
end;
end;

function IndiProperty.getPermission():IPerm;
begin
if (pPtr=nil) then result:=IP_RO
else begin
  case pType of
    INDI_NUMBER:  result := INumberVectorProperty(pPtr).p;
    INDI_TEXT:    result := ITextVectorProperty(pPtr).p;
    INDI_SWITCH:  result := ISwitchVectorProperty(pPtr).p;
    INDI_BLOB:    result := IBLOBVectorProperty(pPtr).p;
    else result := IP_RO;
  end;
end;
end;

function IndiProperty.getNumber():INumberVectorProperty;
begin
if (pType = INDI_NUMBER) then
    result := INumberVectorProperty(pPtr);
end;

function IndiProperty.getText():ITextVectorProperty;
begin
if (pType = INDI_TEXT) then
    result := iTextVectorProperty(pPtr);
end;

function IndiProperty.getSwitch():ISwitchVectorProperty;
begin
if (pType = INDI_SWITCH) then
    result := ISwitchVectorProperty(pPtr);
end;

function IndiProperty.getLight():ILightVectorProperty;
begin
if (pType = INDI_LIGHT) then
    result := ILightVectorProperty(pPtr);
end;

function IndiProperty.getBLOB():IBLOBVectorProperty;
begin
if (pType = INDI_BLOB) then
    result := IBLOBVectorProperty(pPtr);
end;

end.

