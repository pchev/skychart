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
     function  GetValue(const APath: String; const ADefault: String): String; overload;
     function  GetValue(const APath: String; const ADefault: Double): Double; overload;
     function  GetValue(const APath: String; const ADefault: Boolean): Boolean; overload;
     procedure SetValue(const APath: String; const AValue: String); overload;
     procedure SetValue(const APath: String; const AValue: Double); overload;
     procedure SetValue(const APath: String; const AValue: Boolean); overload;
  end;

implementation

/////////////////////  TCCDconfig  /////////////////////////////////

function  TCCDconfig.GetValue(const APath: String; const ADefault: String): String;
begin
   Result:=string(GetValue(DOMString(APath),DOMString(ADefault)));
end;

procedure TCCDconfig.SetValue(const APath: String; const AValue: String);
begin
  SetValue(DOMString(APath),DOMString(AValue));
end;

function  TCCDconfig.GetValue(const APath: String; const ADefault: Double): Double; overload;
begin
  Result:=StrToFloatDef(String(GetValue(DOMString(APath),DOMString(FloatToStr(ADefault)))),ADefault);
end;

procedure TCCDconfig.SetValue(const APath: String; const AValue: Double); overload;
begin
  SetValue(DOMString(APath),DOMString(FloatToStr(AValue)));
end;

function  TCCDconfig.GetValue(const APath: String; const ADefault: Boolean): Boolean; overload;
var
  s: String;
begin
  s := String(GetValue(DOMString(APath), DOMString('')));
  if SameText(s, 'TRUE') then
    Result := True
  else if SameText(s, 'FALSE') then
    Result := False
  else
    Result := ADefault;
end;

procedure TCCDconfig.SetValue(const APath: String; const AValue: Boolean); overload;
begin
if AValue then
  SetValue(DOMString(APath),DOMString('True'))
else
  SetValue(DOMString(APath),DOMString('False'));
end;

end.

