{+--------------------------------------------------------------------------+
 | Unit:        mwCompFrom
 | Created:     12.97
 | Author:      Martin Waldenburg
 | Copyright    1997, all rights reserved.
 | Description: Several comparisions methods, no range checking is done,
 |              you are fulli responsible for this.
 | Version:     1.0
 | Status       FreeWare
 | It's provided as is, without a warranty of any kind.
 | You use it at your own risc.
 | E-Mail me at Martin.Waldenburg@t-online.de
 +--------------------------------------------------------------------------+}

{$mode Delphi}{$H+}

unit mwCompFrom;

interface

uses
  //Windows,
  SysUtils;
function CompareFrom(Const Item1, Item2; P, Count: Integer): Integer;
function CompareTextFrom(Const Item1, Item2; P, Count: Integer): Integer;
function StrCompfrom(Const Item1, Item2; P, Count: Integer): Integer;
function IStrCompfrom(Const Item1, Item2; P, Count: Integer): Integer;
function CompIntAt(Const Item1, Item2; P: Integer): Integer;
function CompShortAt(Const Item1, Item2; P: Integer): Integer;
function CompSmallAt(Const Item1, Item2; P: Integer): Integer;
function CompDoubleAt(Const Item1, Item2; P: Integer): Integer;
var
  CompTable: array[#0..#255] of Char;
implementation

procedure MakeCompTable;
var
  I: Char;
begin
  for I:= #0 to #255 do
  CompTable[I]:= AnsiLowerCase(I)[1];
end;  { MakeCompTable }

function CompareFrom(Const Item1, Item2; P, Count: Integer): Integer;
Var
  I: Integer;
begin
  For I:= 1 to Count do
  begin
  if String(Item1)[P] <> String(Item2)[P] then break;
  inc(P);
  end;
  if String(Item1)[P] < String(Item2)[P] then Result:= -1 else
  if String(Item1)[P] = String(Item2)[P] then Result:= 0 else
  if String(Item1)[P] > String(Item2)[P] then Result:= 1;
end;  { CompareFrom }

function CompareTextFrom(Const Item1, Item2; P, Count: Integer): Integer;
Var
  I: Integer;
begin
  For I:= 1 to Count do
  begin
  if CompTable[String(Item1)[P]] <> CompTable[String(Item2)[P]] then break;
  inc(P);
  end;
  if CompTable[String(Item1)[P]] < CompTable[String(Item2)[P]] then Result:= -1 else
  if CompTable[String(Item1)[P]] = CompTable[String(Item2)[P]] then Result:= 0 else
  if CompTable[String(Item1)[P]] > CompTable[String(Item2)[P]] then Result:= 1;
end;  { CompareTextFrom }

function StrCompfrom(Const Item1, Item2; P, Count: Integer): Integer;
Var
  I: Integer;
begin
  For I:= 1 to Count do
  begin
  if Char(Pointer(Integer(Item1) + P)^) <> Char(Pointer(Integer(Item2) + P)^) then break;
  inc(P);
  end;
  if Char(Pointer(Integer(Item1) + P)^) < Char(Pointer(Integer(Item2) + P)^) then Result:= -1 else
  if Char(Pointer(Integer(Item1) + P)^) = Char(Pointer(Integer(Item2) + P)^) then Result:= 0 else
  if Char(Pointer(Integer(Item1) + P)^) > Char(Pointer(Integer(Item2) + P)^) then Result:= 1;
end;  { StrCompfrom }

function IStrCompfrom(Const Item1, Item2; P, Count: Integer): Integer;
Var
  I: Integer;
begin
  For I:= 1 to Count do
  begin
  if CompTable[Char(Pointer(Integer(Item1) + P)^)] <> CompTable[Char(Pointer(Integer(Item2) + P)^)] then break;
  inc(P);
  end;
  if CompTable[Char(Pointer(Integer(Item1) + P)^)] < CompTable[Char(Pointer(Integer(Item2) + P)^)] then Result:= -1 else
  if CompTable[Char(Pointer(Integer(Item1) + P)^)] = CompTable[Char(Pointer(Integer(Item2) + P)^)] then Result:= 0 else
  if CompTable[Char(Pointer(Integer(Item1) + P)^)] > CompTable[Char(Pointer(Integer(Item2) + P)^)] then Result:= 1;
end;  { IStrCompfrom }

function CompIntAt(Const Item1, Item2; P: Integer): Integer;
begin
  if Integer(Pointer(Integer(Item1) + P)^) < Integer(Pointer(Integer(Item2) + P)^) then Result:= -1 else
  if Integer(Pointer(Integer(Item1) + P)^) = Integer(Pointer(Integer(Item2) + P)^) then Result:= 0 else
  if Integer(Pointer(Integer(Item1) + P)^) > Integer(Pointer(Integer(Item2) + P)^) then Result:= 1;
end;  { CompIntAt }

function CompShortAt(Const Item1, Item2; P: Integer): Integer;
begin
  if ShortInt(Pointer(Integer(Item1) + P)^) < ShortInt(Pointer(Integer(Item2) + P)^) then Result:= -1 else
  if ShortInt(Pointer(Integer(Item1) + P)^) = ShortInt(Pointer(Integer(Item2) + P)^) then Result:= 0 else
  if ShortInt(Pointer(Integer(Item1) + P)^) > ShortInt(Pointer(Integer(Item2) + P)^) then Result:= 1;
end;  { CompShortAt }

function CompSmallAt(Const Item1, Item2; P: Integer): Integer;
begin
  if SmallInt(Pointer(Integer(Item1) + P)^) < SmallInt(Pointer(Integer(Item2) + P)^) then Result:= -1 else
  if SmallInt(Pointer(Integer(Item1) + P)^) = SmallInt(Pointer(Integer(Item2) + P)^) then Result:= 0 else
  if SmallInt(Pointer(Integer(Item1) + P)^) > SmallInt(Pointer(Integer(Item2) + P)^) then Result:= 1;
end;  { CompSmallAt }

function CompDoubleAt(Const Item1, Item2; P: Integer): Integer;
begin
  if Double(Pointer(Integer(Item1) + P)^) < Double(Pointer(Integer(Item2) + P)^) then Result:= -1 else
  if Double(Pointer(Integer(Item1) + P)^) = Double(Pointer(Integer(Item2) + P)^) then Result:= 0 else
  if Double(Pointer(Integer(Item1) + P)^) > Double(Pointer(Integer(Item2) + P)^) then Result:= 1;
end;

initialization
MakeCompTable;

end.
