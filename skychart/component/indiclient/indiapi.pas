unit indiapi;

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
  contnrs, Classes, SysUtils;

// derived from indiapi.h
type
  ISState = (ISS_OFF, ISS_ON);
  IPState = (IPS_IDLE, IPS_OK, IPS_BUSY, IPS_ALERT);
  ISRule = (ISR_1OFMANY, ISR_ATMOST1, ISR_NOFMANY);
  IPerm = (IP_RO, IP_WO, IP_RW);
  INDI_TYPE = (INDI_NUMBER, INDI_SWITCH, INDI_TEXT, INDI_LIGHT, INDI_BLOB, INDI_UNKNOWN);
  BLOBHandling = (B_NEVER, B_ALSO, B_ONLY);
  TDeviceStatus = (devDisconnected, devConnecting, devConnected);
  TPierSide = (pierEast, pierWest, pierUnknown, pierNotImplemented);

var
  Ftrace: boolean = False;

const
  INDIV = '1.7';

  MAXINDINAME = 64;
  MAXINDILABEL = 64;
  MAXINDIDEVICE = 64;
  MAXINDIGROUP = 64;
  MAXINDIFORMAT = 64;
  MAXINDIBLOBFMT = 64;
  MAXINDITSTAMP = 64;

  INDI_DEVICE_NOT_FOUND = -1;
  INDI_PROPERTY_INVALID = -2;
  INDI_PROPERTY_DUPLICATED = -3;
  INDI_DISPATCH_ERROR = -4;

  // DRIVER_INTERFACE
  GENERAL_INTERFACE = 0;             // Default interface for all INDI devices
  TELESCOPE_INTERFACE = (1 shl 0);   // Telescope interface, must subclass INDI::Telescope
  CCD_INTERFACE = (1 shl 1);         // CCD interface, must subclass INDI::CCD
  GUIDER_INTERFACE = (1 shl 2);      // Guider interface, must subclass INDI::GuiderInterface
  FOCUSER_INTERFACE = (1 shl 3);     // Focuser interface, must subclass INDI::FocuserInterface
  FILTER_INTERFACE = (1 shl 4);      // Filter interface, must subclass INDI::FilterInterface
  DOME_INTERFACE = (1 shl 5);        // Dome interface, must subclass INDI::Dome
  GPS_INTERFACE = (1 shl 6);         // GPS interface, must subclass INDI::GPS
  WEATHER_INTERFACE = (1 shl 7);     // Weather interface, must subclass INDI::Weather
  AO_INTERFACE = (1 shl 8);          // Adaptive Optics Interface
  DUSTCAP_INTERFACE = (1 shl 9);     // Dust Cap Interface
  LIGHTBOX_INTERFACE = (1 shl 10);   // Light Box Interface
  DETECTOR_INTERFACE  = (1 << 11);   // Detector interface, must subclass INDI::Detector
  ROTATOR_INTERFACE   = (1 << 12);   // Rotator interface, must subclass INDI::RotatorInterface
  AUX_INTERFACE = (1 shl 15);        // Auxiliary interface

type
  ITextVectorProperty = class;

  IText = class(TObject)
  public
    Name: string;
    lbl: string;
    Text: string;
    tvp: ITextVectorProperty;
    aux0: longint;
    aux1: longint;
  end;

  ITextList = class(TObjectList)
  private
    function GetItem(Index: integer): IText;
    procedure SetItem(Index: integer; AValue: IText);
  public
    property Items[Index: integer]: IText read GetItem write SetItem; default;
  end;

  ITextVectorProperty = class(TObject)
  public
    constructor Create;
    destructor Destroy; override;
  public
    device: string;
    Name: string;
    lbl: string;
    group: string;
    p: IPerm;
    timeout: double;
    s: IPState;
    tp: ITextList;
    ntp: integer;
    timestamp: string;
    aux: longint;
  end;

  INumberVectorProperty = class;

  INumber = class(TObject)
  public
    Name: string;
    lbl: string;
    format: string;
    min: double;
    max: double;
    step: double;
    Value: double;
    nvp: INumberVectorProperty;
    aux0: longint;
    aux1: longint;
  end;

  INumberList = class(TObjectList)
  private
    function GetItem(Index: integer): INumber;
    procedure SetItem(Index: integer; AValue: INumber);
  public
    property Items[Index: integer]: INumber read GetItem write SetItem; default;
  end;

  INumberVectorProperty = class(TObject)
  public
    constructor Create;
    destructor Destroy; override;
  public
    device: string;
    Name: string;
    lbl: string;
    group: string;
    p: IPerm;
    timeout: double;
    s: IPState;
    np: INumberList;
    nnp: integer;
    timestamp: string;
    aux: longint;
  end;

  ISwitchVectorProperty = class;

  ISwitch = class(TObject)
  public
    Name: string;
    lbl: string;
    s: ISState;
    svp: ISwitchVectorProperty;
    aux: longint;
  end;

  ISwitchList = class(TObjectList)
  private
    function GetItem(Index: integer): ISwitch;
    procedure SetItem(Index: integer; AValue: ISwitch);
  public
    property Items[Index: integer]: ISwitch read GetItem write SetItem; default;
  end;

  ISwitchVectorProperty = class(TObject)
  public
    constructor Create;
    destructor Destroy; override;
  public
    device: string;
    Name: string;
    lbl: string;
    group: string;
    p: IPerm;
    r: ISRule;
    timeout: double;
    s: IPState;
    sp: ISwitchList;
    nsp: integer;
    timestamp: string;
    aux: longint;
  end;

  ILightVectorProperty = class;

  ILight = class(TObject)
  public
    Name: string;
    lbl: string;
    s: IPState;
    lvp: ILightVectorProperty;
    aux: longint;
  end;

  ILightList = class(TObjectList)
  private
    function GetItem(Index: integer): ILight;
    procedure SetItem(Index: integer; AValue: ILight);
  public
    property Items[Index: integer]: ILight read GetItem write SetItem; default;
  end;

  ILightVectorProperty = class(TObject)
  public
    constructor Create;
    destructor Destroy; override;
  public
    device: string;
    Name: string;
    lbl: string;
    group: string;
    s: IPState;
    lp: ILightList;
    nlp: integer;
    timestamp: string;
    aux: longint;
  end;

  IBLOBVectorProperty = class;

  IBLOB = class(TObject)
  public
    Name: string;
    lbl: string;
    format: string;
    blob: TMemoryStream;
    bloblen: integer;
    size: integer;
    bvp: IBLOBVectorProperty;
    aux0: longint;
    aux1: longint;
    aux2: longint;
    constructor Create;
    destructor Destroy; override;
  end;

  IBLOBList = class(TObjectList)
  private
    function GetItem(Index: integer): IBLOB;
    procedure SetItem(Index: integer; AValue: IBLOB);
  public
    property Items[Index: integer]: IBLOB read GetItem write SetItem; default;
  end;

  IBLOBVectorProperty = class(TObject)
  public
    constructor Create;
    destructor Destroy; override;
  public
    device: string;
    Name: string;
    lbl: string;
    group: string;
    p: IPerm;
    timeout: double;
    s: IPState;
    bp: IBLOBList;
    nbp: integer;
    timestamp: string;
    aux: longint;
  end;

  IMessage = class(TObject)
  public
    constructor Create;
    destructor Destroy; override;
  public
    msg: string;
  end;

implementation

//////////////////////// ITextVectorProperty ////////////////////////
function ITextList.GetItem(Index: integer): IText;
begin
  Result := IText(inherited Items[Index]);
end;

procedure ITextList.SetItem(Index: integer; AValue: IText);
begin
  inherited Items[Index] := AValue;
end;

constructor ITextVectorProperty.Create;
begin
  inherited Create;
  tp := ITextList.Create;
end;

destructor ITextVectorProperty.Destroy;
begin
  tp.Free;
  inherited Destroy;
end;

//////////////////////// INumberVectorProperty ////////////////////////
function INumberList.GetItem(Index: integer): INumber;
begin
  Result := INumber(inherited Items[Index]);
end;

procedure INumberList.SetItem(Index: integer; AValue: INumber);
begin
  inherited Items[Index] := AValue;
end;

constructor INumberVectorProperty.Create;
begin
  inherited Create;
  np := INumberList.Create;
end;

destructor INumberVectorProperty.Destroy;
begin
  np.Free;
  inherited Destroy;
end;

//////////////////////// ISwitchVectorProperty ////////////////////////
function ISwitchList.GetItem(Index: integer): ISwitch;
begin
  Result := ISwitch(inherited Items[Index]);
end;

procedure ISwitchList.SetItem(Index: integer; AValue: ISwitch);
begin
  inherited Items[Index] := AValue;
end;

constructor ISwitchVectorProperty.Create;
begin
  inherited Create;
  sp := ISwitchList.Create;
end;

destructor ISwitchVectorProperty.Destroy;
begin
  sp.Free;
  inherited Destroy;
end;

//////////////////////// ILightVectorProperty ////////////////////////
function ILightList.GetItem(Index: integer): ILight;
begin
  Result := ILight(inherited Items[Index]);
end;

procedure ILightList.SetItem(Index: integer; AValue: ILight);
begin
  inherited Items[Index] := AValue;
end;

constructor ILightVectorProperty.Create;
begin
  inherited Create;
  lp := ILightList.Create;
end;

destructor ILightVectorProperty.Destroy;
begin
  lp.Free;
  inherited Destroy;
end;

//////////////////////// IBLOB ////////////////////////

constructor IBLOB.Create;
begin
  inherited Create;
  blob := TMemoryStream.Create;
end;

destructor IBLOB.Destroy;
begin
  blob.Free;
  inherited Destroy;
end;

//////////////////////// IBLOBVectorProperty ////////////////////////
function IBLOBList.GetItem(Index: integer): IBLOB;
begin
  Result := IBLOB(inherited Items[Index]);
end;

procedure IBLOBList.SetItem(Index: integer; AValue: IBLOB);
begin
  inherited Items[Index] := AValue;
end;

constructor IBLOBVectorProperty.Create;
begin
  inherited Create;
  bp := IBLOBList.Create;
end;

destructor IBLOBVectorProperty.Destroy;
begin
  bp.Free;
  inherited Destroy;
end;


//////////////////////// IMessage ////////////////////////

constructor IMessage.Create;
begin
  inherited Create;
  msg:='';
end;

destructor IMessage.Destroy;
begin
  inherited Destroy;
end;


end.
