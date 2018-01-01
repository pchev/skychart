unit u_ccdconfig;

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

uses XMLConf, DOM,
  Classes, SysUtils;

type
  TCCDconfig = class(TXMLConfig)
    function GetValue(const APath: string; const ADefault: string): string; overload;
    function GetValue(const APath: string; const ADefault: double): double; overload;
    function GetValue(const APath: string; const ADefault: boolean): boolean; overload;
    procedure SetValue(const APath: string; const AValue: string); overload;
    procedure SetValue(const APath: string; const AValue: double); overload;
    procedure SetValue(const APath: string; const AValue: boolean); overload;
  end;

implementation

/////////////////////  TCCDconfig  /////////////////////////////////

function TCCDconfig.GetValue(const APath: string; const ADefault: string): string;
begin
  Result := string(GetValue(DOMString(APath), DOMString(ADefault)));
end;

procedure TCCDconfig.SetValue(const APath: string; const AValue: string);
begin
  SetValue(DOMString(APath), DOMString(AValue));
end;

function TCCDconfig.GetValue(const APath: string; const ADefault: double): double;
  overload;
begin
  Result := StrToFloatDef(string(GetValue(DOMString(APath), DOMString(
    FloatToStr(ADefault)))), ADefault);
end;

procedure TCCDconfig.SetValue(const APath: string; const AValue: double); overload;
begin
  SetValue(DOMString(APath), DOMString(FloatToStr(AValue)));
end;

function TCCDconfig.GetValue(const APath: string; const ADefault: boolean): boolean;
  overload;
var
  s: string;
begin
  s := string(GetValue(DOMString(APath), DOMString('')));
  if SameText(s, 'TRUE') then
    Result := True
  else if SameText(s, 'FALSE') then
    Result := False
  else
    Result := ADefault;
end;

procedure TCCDconfig.SetValue(const APath: string; const AValue: boolean); overload;
begin
  if AValue then
    SetValue(DOMString(APath), DOMString('True'))
  else
    SetValue(DOMString(APath), DOMString('False'));
end;

end.
