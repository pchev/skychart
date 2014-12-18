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
Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
}
{
   Pascal Indi client library freely inspired by libindiclient.
   See: http://www.indilib.org/
}

{$mode objfpc}{$H+}

interface

uses indiapi, indicom, DOM, contnrs, base64, zstream,
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
      destructor Destroy;
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
      FIndiNumberEvent: TIndiNumberEvent;
      FIndiTextEvent: TIndiTextEvent;
      FIndiSwitchEvent: TIndiSwitchEvent;
      FIndiLightEvent: TIndiLightEvent;
      FIndiBlobEvent: TIndiBlobEvent;
      deviceID: string;
      pAll: TObjectList;
  public
      constructor Create;
      destructor Destroy;
      function getDeviceName(): string;
      procedure setDeviceName(value:string);
      function getProperty(name: string; typ: INDI_TYPE=INDI_UNKNOWN):IndiProperty;
      function getRawProperty(name: string; typ: INDI_TYPE=INDI_UNKNOWN):TObject;
      function getNumber(name: string):INumberVectorProperty;
      function getText(name: string):ITextVectorProperty;
      function getSwitch(name: string):ISwitchVectorProperty;
      function getLight(name: string):ILightVectorProperty;
      function getBlob(name: string):IBLOBVectorProperty;
      function buildProp(root: TDOMNode; errmsg: string):integer;
      function setValue(root: TDOMNode; errmsg: string):integer;
      function setBLOB(bvp: IBLOBVectorProperty; root: TDOMNode; errmsg:string): integer;
      procedure checkMessage(root: TDOMNode);

      property onNewMessage  : TIndiMessageEvent read FIndiMessageEvent write FIndiMessageEvent;
      property onNewProperty : TIndiPropertyEvent read FIndiPropertyEvent write FIndiPropertyEvent;
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
 pAll.Free;
 inherited Destroy;
end;

function BaseDevice.getDeviceName(): string;
begin
  result:=deviceID;
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

function BaseDevice.buildProp(root: TDOMNode; errmsg: string):integer;
var perm: IPerm;
    state: IPState;
    timeout: double;
    rtag,rname,rdev,buf: string;
    n: integer;
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
  rtag:=root.NodeName;
  node:=root.Attributes.GetNamedItem('name');
  if node=nil then begin
     errmsg:='INDI: <'+rtag+'> unable to find name attribute';
     if ftrace then writeln(errmsg);
     exit(-1);
  end else
    rname:=trim(node.NodeValue);
  node:=root.Attributes.GetNamedItem('device');
  if node=nil then begin
     errmsg:='INDI: <'+rtag+'> unable to find device attribute';
     if ftrace then writeln(errmsg);
     exit(-1);
  end else
     rdev:=trim(node.NodeValue);
  if deviceID='' then deviceID:=rdev;
  if (getProperty(rname)<>nil) then
        exit(INDI_PROPERTY_DUPLICATED);
  if (rtag<>'defLightVector') then begin
    cnode:=root.Attributes.GetNamedItem('perm');
    if (cnode=nil)or(not crackIPerm(trim(cnode.NodeValue),perm)) then  begin
        if ftrace then writeln('no perm');
        exit(-1);
    end;
  end;
  cnode:=root.Attributes.GetNamedItem('timeout');
  if cnode<>nil then timeout:=StrToFloatDef(trim(cnode.NodeValue),0) else timeout:=0;
  cnode:=root.Attributes.GetNamedItem('state');
  if (cnode=nil)or(not crackIPState(trim(cnode.NodeValue),state)) then begin
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
    cnode:=root.Attributes.GetNamedItem('label');
    if cnode<>nil then nvp.lbl:= trim(cnode.NodeValue);
    cnode:=root.Attributes.GetNamedItem('group');
    if cnode<>nil then nvp.group:= trim(cnode.NodeValue);
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
           else f_scansexa(trim(cnode.NodeValue),np.value);
        cnode:=node.Attributes.GetNamedItem('name');
        if cnode=nil then exit(-1);
        np.name:=trim(cnode.NodeValue);
        cnode:=node.Attributes.GetNamedItem('label');
        if cnode<>nil then np.lbl :=trim(cnode.NodeValue);
        cnode:=node.Attributes.GetNamedItem('format');
        if cnode<>nil then np.format:=trim(cnode.NodeValue);
        cnode:=node.Attributes.GetNamedItem('min');
        np.min:=StrToFloatDef(trim(cnode.NodeValue),0);
        cnode:=node.Attributes.GetNamedItem('max');
        np.max:=StrToFloatDef(trim(cnode.NodeValue),0);
        cnode:=node.Attributes.GetNamedItem('step');
        np.step:=StrToFloatDef(trim(cnode.NodeValue),0);
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
    cnode:=root.Attributes.GetNamedItem('label');
    if cnode<>nil then svp.lbl:= trim(cnode.NodeValue);
    cnode:=root.Attributes.GetNamedItem('group');
    if cnode<>nil then svp.group:= trim(cnode.NodeValue);
    cnode:=root.Attributes.GetNamedItem('rule');
    if (cnode=nil)or(not crackISRule(trim(cnode.NodeValue), svp.r)) then svp.r:=ISR_1OFMANY;
    svp.p     := perm;
    svp.s     := state;
    svp.timeout := timeout;
    node:=root.FirstChild;
    while node<> nil do begin
      if node.NodeName='defSwitch' then begin
        sp:=ISwitch.Create;
        sp.svp:=svp;
        cnode:=node.Attributes.GetNamedItem('name');
        if cnode=nil then exit(-1);
        sp.name:=trim(cnode.NodeValue);
        cnode:=node.Attributes.GetNamedItem('label');
        if cnode<>nil then sp.lbl :=trim(cnode.NodeValue);
        cnode:=node.FirstChild;
        if (cnode<>nil) then
            crackISState(trim(cnode.NodeValue),sp.s);
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
    cnode:=root.Attributes.GetNamedItem('label');
    if cnode<>nil then tvp.lbl:= trim(cnode.NodeValue);
    cnode:=root.Attributes.GetNamedItem('group');
    if cnode<>nil then tvp.group:= trim(cnode.NodeValue);
    tvp.p     := perm;
    tvp.s     := state;
    tvp.timeout := timeout;
    node:=root.FirstChild;
    while node<> nil do begin
      if node.NodeName='defText' then begin
        tp:=IText.Create;
        tp.tvp:=tvp;
        cnode:=node.Attributes.GetNamedItem('name');
        if cnode=nil then exit(-1);
        tp.name:=trim(cnode.NodeValue);
        cnode:=node.Attributes.GetNamedItem('label');
        if cnode<>nil then tp.lbl :=trim(cnode.NodeValue);
        cnode:=node.FirstChild;
        if (cnode=nil) then tp.text:=''
           else tp.text:=trim(cnode.NodeValue);
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
    cnode:=root.Attributes.GetNamedItem('label');
    if cnode<>nil then lvp.lbl:= trim(cnode.NodeValue);
    cnode:=root.Attributes.GetNamedItem('group');
    if cnode<>nil then lvp.group:= trim(cnode.NodeValue);
    lvp.s     := state;
    node:=root.FirstChild;
    while node<> nil do begin
      if node.NodeName='defLight' then begin
        lp:=ILight.Create;
        lp.lvp:=lvp;
        cnode:=node.Attributes.GetNamedItem('name');
        if cnode=nil then exit(-1);
        lp.name:=trim(cnode.NodeValue);
        cnode:=node.Attributes.GetNamedItem('label');
        if cnode<>nil then lp.lbl :=trim(cnode.NodeValue);
        cnode:=node.FirstChild;
        if (cnode<>nil) then
            crackIPState(trim(cnode.NodeValue), lp.s);
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
    cnode:=root.Attributes.GetNamedItem('label');
    if cnode<>nil then bvp.lbl:= trim(cnode.NodeValue);
    cnode:=root.Attributes.GetNamedItem('group');
    if cnode<>nil then bvp.group:= trim(cnode.NodeValue);
    bvp.p     := perm;
    bvp.s     := state;
    bvp.timeout := timeout;
    node:=root.FirstChild;
    while node<> nil do begin
      if node.NodeName='defBLOB' then begin
        bp:=IBLOB.Create;
        bp.bvp:=bvp;
        cnode:=node.Attributes.GetNamedItem('name');
        if cnode=nil then exit(-1);
        bp.name:=trim(cnode.NodeValue);
        cnode:=node.Attributes.GetNamedItem('label');
        if cnode<>nil then bp.lbl :=trim(cnode.NodeValue);
        cnode:=node.Attributes.GetNamedItem('format');
        if cnode<>nil then bp.format :=trim(cnode.NodeValue);
        bp.blob:='';
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

function BaseDevice.setValue(root: TDOMNode; errmsg: string):integer;
var perm: IPerm;
    state: IPState;
    timeout: double;
    swState: ISState;
    lState: IPState;
    stateSet: boolean = false;
    timeoutSet: boolean = false;
    rtag,rname,rdev,buf: string;
    n: integer;
    node,pnode,cnode: TDOMNode;
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
  rtag:=root.NodeName;
  node:=root.Attributes.GetNamedItem('name');
  if node=nil then begin
     errmsg:='INDI: <'+rtag+'> unable to find name attribute';
     exit(-1);
  end else
    rname:=trim(node.NodeValue);
  node:=root.Attributes.GetNamedItem('state');
  if node<>nil then begin
     if (not crackIPState(trim(node.NodeValue),state)) then begin
        errmsg:='INDI: <'+rtag+'> '+rname+'bogus state';
        exit(-1);
     end;
     stateSet := true;
  end;
  node:=root.Attributes.GetNamedItem('timeout');
  if node<>nil then begin
    timeout:=StrToFloatDef(trim(node.NodeValue),0);
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
      cnode:=node.Attributes.GetNamedItem('name');
      if cnode=nil then continue;
      np:=IUFindNumber(nvp,trim(cnode.NodeValue));
      if np=nil then continue;
      cnode:=node.FirstChild;
      if (cnode=nil) then np.value:=0
         else f_scansexa(trim(cnode.NodeValue),np.value);
      pnode:=node.Attributes.GetNamedItem('min');
      if pnode<>nil then np.min:=StrToFloatDef(trim(pnode.NodeValue),0);
      pnode:=node.Attributes.GetNamedItem('max');
      if pnode<>nil then np.max:=StrToFloatDef(trim(pnode.NodeValue),0);
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
      cnode:=node.Attributes.GetNamedItem('name');
      if cnode=nil then continue;
      tp:=IUFindText(tvp,trim(cnode.NodeValue));
      if tp=nil then continue;
      cnode:=node.FirstChild;
      if (cnode=nil) then tp.text:=''
         else tp.text:=trim(cnode.NodeValue);
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
      cnode:=node.Attributes.GetNamedItem('name');
      if cnode=nil then continue;
      sp:=IUFindSwitch(svp,trim(cnode.NodeValue));
      if sp=nil then continue;
      cnode:=node.FirstChild;
      if (cnode<>nil) then
          if crackISState(trim(cnode.NodeValue),swState) then sp.s:=swState;
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
      cnode:=node.Attributes.GetNamedItem('name');
      if cnode=nil then continue;
      lp:=IUFindLight(lvp,trim(cnode.NodeValue));
      if lp=nil then continue;
      cnode:=node.FirstChild;
      if (cnode<>nil) then
          if crackIPState(trim(cnode.NodeValue), lState) then lp.s:=lState;
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

function BaseDevice.setBLOB(bvp: IBLOBVectorProperty; root: TDOMNode; errmsg:string): integer;
var n,r: integer;
    blobEL: IBLOB;
    str1,str2,str3:TStringStream;
    b64str: TBase64DecodingStream;
    unzstr: Tdecompressionstream;
    node,cnode,na,fa,sa: TDOMNode;
    dataBuffer: Pchar;
    dataSize: LongInt;
begin
  node:=root.FirstChild;
  while node<> nil do begin
    if node.NodeName='oneBLOB' then begin
      na := node.Attributes.GetNamedItem('name');
      blobEL := IUFindBLOB(bvp, trim(na.NodeValue));
      fa := node.Attributes.GetNamedItem('format');
      sa := node.Attributes.GetNamedItem('size');
      if (na<>nil)and(fa<>nil)and(sa<>nil) then begin
        blobEL.size:=StrToInt(trim(sa.NodeValue));
        if (blobEL.size = 0) then begin
            if assigned(FIndiBlobEvent) then FIndiBlobEvent(blobEL);
            continue;
        end;
        cnode:=node.FirstChild;
        if cnode<>nil then begin
          str1:=TStringStream.Create(cnode.NodeValue);
          str2:=TStringStream.Create('');
          b64str:=TBase64DecodingStream.Create(str1);
          str2.CopyFrom(b64str,b64str.Size);
          blobEL.format:=trim(fa.NodeValue);
          if pos('.z',blobEL.format)>0 then begin
             unzstr:=Tdecompressionstream.create(str2);
             str3:=TStringStream.Create('');
             str3.CopyFrom(unzstr,unzstr.Size);
             blobEL.blob:=str3.DataString;
             blobEL.bloblen:=str3.Size;
             unzstr.Free;
             str3.Free;
          end else begin
             blobEL.blob:=str2.DataString;
             blobEL.bloblen:=str2.Size;
          end;
          str1.Free;
          str2.Free;
          b64str.Free;
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
  node:=root.Attributes.GetNamedItem('message');
  if node <> nil then begin
     buf:=node.NodeValue;
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

