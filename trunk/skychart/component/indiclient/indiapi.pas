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
Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
}
{
   Pascal Indi client library freely inspired by libindiclient.
   See: http://www.indilib.org/
}

{$mode objfpc}{$H+}

interface

uses contnrs,
  Classes, SysUtils;


// derived from indiapi.h
type
  ISState = (ISS_OFF, ISS_ON);
  IPState = (IPS_IDLE, IPS_OK, IPS_BUSY, IPS_ALERT);
  ISRule  = (ISR_1OFMANY, ISR_ATMOST1, ISR_NOFMANY);
  IPerm   = (IP_RO,IP_WO,IP_RW);
  INDI_TYPE = (INDI_NUMBER,INDI_SWITCH,INDI_TEXT,INDI_LIGHT,INDI_BLOB,INDI_UNKNOWN);
  BLOBHandling = (B_NEVER, B_ALSO, B_ONLY);

var
  Ftrace: boolean = false;

const
INDIV = '1.7';
MAXINDINAME     =64;
MAXINDILABEL	=64;
MAXINDIDEVICE	=64;
MAXINDIGROUP	=64;
MAXINDIFORMAT	=64;
MAXINDIBLOBFMT	=64;
MAXINDITSTAMP	=64;
INDI_DEVICE_NOT_FOUND=-1;
INDI_PROPERTY_INVALID=-2;
INDI_PROPERTY_DUPLICATED = -3;
INDI_DISPATCH_ERROR=-4;

type
  ITextVectorProperty=class;
  IText = class(TObject)
  public
      name: string;
      lbl:  string;
      text: string;
      tvp:  ITextVectorProperty;
      aux0: LongInt;
      aux1: LongInt;
  end;

  ITextList = class(TObjectList)
  private
    function GetItem(Index: Integer): IText;
    procedure SetItem(Index: Integer; AValue: IText);
  public
    property Items[Index: Integer]: IText read GetItem write SetItem; default;
  end;

  ITextVectorProperty = class(TObject)
  public
      constructor Create;
      destructor Destroy; override;
  public
      device: string;
      name:   string;
      lbl:    string;
      group:  string;
      p:      IPerm;
      timeout: double;
      s:      IPState;
      tp:     ITextList;
      ntp:    integer;
      timestamp: string;
      aux:    LongInt;
  end;

  INumberVectorProperty= class;
  INumber = class(TObject)
  public
      name:   string;
      lbl :   string;
      format: string;
      min, max: double;
      step:  double;
      value: double;
      nvp:   INumberVectorProperty;
      aux0, aux1: LongInt;
  end;

  INumberList = class(TObjectList)
  private
    function GetItem(Index: Integer): INumber;
    procedure SetItem(Index: Integer; AValue: INumber);
  public
    property Items[Index: Integer]: INumber read GetItem write SetItem; default;
  end;

  INumberVectorProperty = class(TObject)
  public
      constructor Create;
      destructor Destroy; override;
  public
      device: string;
      name:   string;
      lbl:    string;
      group:  string;
      p:      IPerm;
      timeout: double;
      s:      IPState;
      np:     INumberList;
      nnp:    integer;
      timestamp: string;
      aux:    LongInt;
  end;

  ISwitchVectorProperty = class;
  ISwitch = class(TObject)
  public
      name:   string;
      lbl :   string;
      s:      ISState;
      svp:    ISwitchVectorProperty;
      aux:    LongInt;
  end;

  ISwitchList = class(TObjectList)
  private
    function GetItem(Index: Integer): ISwitch;
    procedure SetItem(Index: Integer; AValue: ISwitch);
  public
    property Items[Index: Integer]: ISwitch read GetItem write SetItem; default;
  end;

  ISwitchVectorProperty = class(TObject)
  public
      constructor Create;
      destructor Destroy; override;
  public
      device: string;
      name:   string;
      lbl:    string;
      group:  string;
      p:      IPerm;
      r:      ISRule;
      timeout: double;
      s:      IPState;
      sp:     ISwitchList;
      nsp:    integer;
      timestamp: string;
      aux:    LongInt;
  end;

  ILightVectorProperty = class;
  ILight = class(TObject)
  public
      name:   string;
      lbl :   string;
      s:      IPState;
      lvp:    ILightVectorProperty;
      aux:    LongInt;
  end;

  ILightList = class(TObjectList)
  private
    function GetItem(Index: Integer): ILight;
    procedure SetItem(Index: Integer; AValue: ILight);
  public
    property Items[Index: Integer]: ILight read GetItem write SetItem; default;
  end;

  ILightVectorProperty = class(TObject)
  public
      constructor Create;
      destructor Destroy; override;
  public
      device: string;
      name:   string;
      lbl:    string;
      group:  string;
      s:      IPState;
      lp:     ILightList;
      nlp:    integer;
      timestamp: string;
      aux:    LongInt;
  end;

  IBLOBVectorProperty = class;
  IBLOB = class(TObject)
  public
      name:   string;
      lbl :   string;
      format: string;
      blob:   string;
      bloblen:integer;
      size:   integer;
      bvp:    IBLOBVectorProperty;
      aux0,aux1,aux2: LongInt;
  end;

  IBLOBList = class(TObjectList)
  private
    function GetItem(Index: Integer): IBLOB;
    procedure SetItem(Index: Integer; AValue: IBLOB);
  public
    property Items[Index: Integer]: IBLOB read GetItem write SetItem; default;
  end;

  IBLOBVectorProperty = class(TObject)
  public
      constructor Create;
      destructor Destroy; override;
  public
      device: string;
      name:   string;
      lbl:    string;
      group:  string;
      p:      IPerm;
      timeout: double;
      s:      IPState;
      bp:     IBLOBList;
      nbp     : integer;
      timestamp: string;
      aux:    LongInt;
  end;


implementation

//////////////////////// ITextVectorProperty ////////////////////////
function ITextList.GetItem(Index: Integer): IText;
begin
  Result := IText(inherited Items[Index]);
end;
procedure ITextList.SetItem(Index: Integer; AValue: IText);
begin
  inherited Items[Index] := AValue;
end;

constructor ITextVectorProperty.Create;
begin
  inherited Create;
  tp:=ITextList.Create;
end;
destructor ITextVectorProperty.Destroy;
begin
  tp.Free;
  inherited Destroy;
end;

//////////////////////// INumberVectorProperty ////////////////////////
function INumberList.GetItem(Index: Integer): INumber;
begin
  Result := INumber(inherited Items[Index]);
end;
procedure INumberList.SetItem(Index: Integer; AValue: INumber);
begin
  inherited Items[Index] := AValue;
end;

constructor INumberVectorProperty.Create;
begin
  inherited Create;
  np:=INumberList.Create;
end;
destructor INumberVectorProperty.Destroy;
begin
  np.Free;
  inherited Destroy;
end;

//////////////////////// ISwitchVectorProperty ////////////////////////
function ISwitchList.GetItem(Index: Integer): ISwitch;
begin
  Result := ISwitch(inherited Items[Index]);
end;
procedure ISwitchList.SetItem(Index: Integer; AValue: ISwitch);
begin
  inherited Items[Index] := AValue;
end;

constructor ISwitchVectorProperty.Create;
begin
  inherited Create;
  sp:=ISwitchList.Create;
end;
destructor ISwitchVectorProperty.Destroy;
begin
  sp.Free;
  inherited Destroy;
end;

//////////////////////// ILightVectorProperty ////////////////////////
function ILightList.GetItem(Index: Integer): ILight;
begin
  Result := ILight(inherited Items[Index]);
end;
procedure ILightList.SetItem(Index: Integer; AValue: ILight);
begin
  inherited Items[Index] := AValue;
end;

constructor ILightVectorProperty.Create;
begin
  inherited Create;
  lp:=ILightList.Create;
end;
destructor ILightVectorProperty.Destroy;
begin
  lp.Free;
  inherited Destroy;
end;

//////////////////////// IBLOBVectorProperty ////////////////////////
function IBLOBList.GetItem(Index: Integer): IBLOB;
begin
  Result := IBLOB(inherited Items[Index]);
end;
procedure IBLOBList.SetItem(Index: Integer; AValue: IBLOB);
begin
  inherited Items[Index] := AValue;
end;

constructor IBLOBVectorProperty.Create;
begin
  inherited Create;
  bp:=IBLOBList.Create;
end;
destructor IBLOBVectorProperty.Destroy;
begin
  bp.Free;
  inherited Destroy;
end;


end.

