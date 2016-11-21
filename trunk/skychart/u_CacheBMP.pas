unit u_CacheBMP;

{
Copyright (C) 2016 Patrick Chevalley

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
}

{$mode delphi}{$H+}

interface

uses
  //Classes,
  contnrs,  sysutils,
  BGRABitmap, BGRABitmapTypes;

  //Graphics;

type

  PCacheBMP_Data = ^TCacheBMP_Data;
  TCacheBMP_Data = record
    ID       : shortstring;
    BMP      : TBGRABitmap;
    Diameter : integer;
    JD       : double;
    GRS      : double;
    Prot     : double;
  end;


  TCacheBMP = class

    constructor Create;
    destructor Destroy; override;

  private
    FList: TFPHashList;

  public

    function Count: integer;

    procedure Clear;

    function Add(
      AID: shortstring; ABMP: TBGRABitmap;
      ADiameter: integer = 0;
      AJD: double = 0;
      AGRS: double = 0;
      AProt: double = 0
    ): integer;

    procedure Delete(Index: integer);

    function Search(AID: ShortString): integer;

    function GetBMP(Index: integer): TBGRABitmap;
    function GetDiameter(Index: integer): integer;
    function GetJD(Index: integer): double;
    function GetGRS(Index: integer): double;
    function GetProt(Index: integer): double;


  end;

implementation

constructor TCacheBMP.Create;
begin
  FList := TFPHashList.Create;
end;

destructor TCacheBMP.Destroy;
begin
  Self.Clear;
  FList.Free;
end;

function TCacheBMP.Count: integer;
begin
  Result := FList.Count;
end;

procedure TCacheBMP.Delete(Index: integer);
var
  p : PCacheBMP_Data;
begin

  p := FList[Index];

  if p <> nil then
  begin

      if p.BMP <> nil then
        p.BMP.Free;

      Dispose(p);

      FList[Index] := nil;

  end;

  FList.Delete(Index);

end;

function TCacheBMP.Add(
  AID: shortstring; ABMP: TBGRABitmap;
  ADiameter: integer = 0;
  AJD: double = 0;
  AGRS: double = 0;
  AProt: double = 0
): integer;
var
  p : PCacheBMP_Data;
  idx : integer;
begin

  idx := Self.Search(AID);

  if (idx>=0) then
    Self.Delete(idx);

  new(p);

  p.BMP := TBGRABitmap.Create;
  p.BMP.Assign(ABMP);

  p.ID       := AID;
  p.Diameter := ADiameter;
  p.JD       := AJD;
  p.GRS      := AGRS;
  p.Prot     := AProt;

  Result := FList.Add(AID, p);

end;

procedure TCacheBMP.Clear;
begin

  while FList.Count>0 do
    Self.Delete(0);

end;

function TCacheBMP.Search(AID: shortstring): integer;
var
  idx: integer;
  p : PCacheBMP_Data;
begin
  Result := FList.FindIndexOf(AID);
end;

function TCacheBMP.GetBMP(Index: integer): TBGRABitmap;
begin
  Result := PCacheBMP_Data(FList[Index]).BMP
end;


function TCacheBMP.GetDiameter(Index: integer): integer;
begin
  Result := PCacheBMP_Data(FList[Index]).Diameter;
end;

function TCacheBMP.GetJD(Index: integer): double;
begin
  Result := PCacheBMP_Data(FList[Index]).JD
end;

function TCacheBMP.GetGRS(Index: integer): double;
begin
  Result := PCacheBMP_Data(FList[Index]).GRS;
end;

function TCacheBMP.GetProt(Index: integer): double;
begin
  Result := PCacheBMP_Data(FList[Index]).Prot;
end;

end.
