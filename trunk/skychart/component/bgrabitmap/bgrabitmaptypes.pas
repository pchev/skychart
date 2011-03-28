{
 /**************************************************************************\
                                bgrabitmaptypes.pas
                                -------------------
                   This unit defines basic types and it must be
                   included in the 'uses' clause.

       --> Include BGRABitmap and BGRABitmapTypes in the 'uses' clause.

 ****************************************************************************
 *                                                                          *
 *  This file is part of BGRABitmap library which is distributed under the  *
 *  modified LGPL.                                                          *
 *                                                                          *
 *  See the file COPYING.modifiedLGPL.txt, included in this distribution,   *
 *  for details about the copyright.                                        *
 *                                                                          *
 *  This program is distributed in the hope that it will be useful,         *
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of          *
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.                    *
 *                                                                          *
 ****************************************************************************
}

unit BGRABitmapTypes;

{$mode objfpc}{$H+}

interface

uses
  Classes, Graphics;

type
  PBGRAPixel = ^TBGRAPixel;

  TBGRAPixel = packed record
    blue, green, red, alpha: byte;
  end;

  TExpandedPixel = packed record
    red, green, blue, alpha: word;
  end;

  THSLAPixel = packed record
    hue, saturation, lightness, alpha: word;
  end;

  TDrawMode = (dmSet, dmSetExceptTransparent, dmLinearBlend, dmDrawWithTransparency);
  TFloodfillMode = (fmSet, fmDrawWithTransparency, fmProgressive);
  TResampleMode = (rmSimpleStretch, rmFineResample);
  TMedianOption = (moNone, moLowSmooth, moMediumSmooth, moHighSmooth);
  TGradientType = (gtLinear, gtReflected, gtDiamond, gtRadial);
  TBGRAPenStyle = Array Of Single;
  TRoundRectangleOption = (rrTopLeftSquare,rrTopRightSquare,rrBottomRightSquare,rrBottomLeftSquare,
                               rrTopLeftBevel,rrTopRightBevel,rrBottomRightBevel,rrBottomLeftBevel);
  TRoundRectangleOptions = set of TRoundRectangleOption;

const
  GradientTypeStr : array[TGradientType] of string =
  ('Linear','Reflected','Diamond','Radial');

type
  TRadialBlurType = (rbNormal, rbDisk, rbCorona, rbPrecise, rbFast);
  TChannel = (cRed, cGreen, cBlue, cAlpha);
  TBlendOperation = (boLinearBlend, boTransparent, boMultiply,
    boLinearMultiply, boAdditive, boLinearAdd, boColorBurn, boColorDodge, boReflect,
    boGlow, boOverlay, boDifference, boLinearDifference, boNegation,
    boLinearNegation, boLighten, boDarken, boScreen, boXor);

  TPointF = record
    x, y: single;
  end;
  ArrayOfTPointF = array of TPointF;

const
  dmFastBlend = dmLinearBlend;

const
  EmptySingle: single = -3.402823e38;

const
  EmptyPointF: TPointF = (x: -3.402823e38; y: -3.402823e38);

const
  BGRAPixelTransparent: TBGRAPixel = (blue: 0; green: 0; red: 0; alpha: 0);

const
  BGRAWhite: TBGRAPixel = (blue: 255; green: 255; red: 255; alpha: 255);

const
  BGRABlack: TBGRAPixel = (blue: 0; green: 0; red: 0; alpha: 255);

const
  clBlackOpaque = TColor($010000);

function isEmptyPointF(pt: TPointF): boolean;
function BGRAPenStyle(dash1, space1: single; dash2: single=0; space2: single = 0; dash3: single=0; space3: single = 0; dash4 : single = 0; space4 : single = 0): TBGRAPenStyle;

function GetIntensity(c: TExpandedPixel): word; inline;
function SetIntensity(c: TExpandedPixel; intensity: word): TExpandedPixel;
function GetLightness(c: TExpandedPixel): word; inline;
function SetLightness(c: TExpandedPixel; lightness: word): TExpandedPixel;
function BGRAToHSLA(c: TBGRAPixel): THSLAPixel;
function HSLAToBGRA(c: THSLAPixel): TBGRAPixel;
function GammaExpansion(c: TBGRAPixel): TExpandedPixel; inline;
function GammaCompression(ec: TExpandedPixel): TBGRAPixel; inline;
function BGRAToGrayscale(c: TBGRAPixel): TBGRAPixel;
function MergeBGRA(c1, c2: TBGRAPixel): TBGRAPixel;
function BGRA(red, green, blue, alpha: byte): TBGRAPixel; overload; inline;
function BGRA(red, green, blue: byte): TBGRAPixel; overload; inline;
function ColorToBGRA(color: TColor): TBGRAPixel; overload;
function ColorToBGRA(color: TColor; opacity: byte): TBGRAPixel; overload;
function BGRAToColor(c: TBGRAPixel): TColor;
operator = (const c1, c2: TBGRAPixel): boolean; inline;

function BGRADiff(c1, c2: TBGRAPixel): byte;
function PointF(x, y: single): TPointF;

function PtInRect(pt: TPoint; r: TRect): boolean;

function StrToGradientType(str: string): TGradientType;
function BGRAToStr(c: TBGRAPixel): string;
function StrToBGRA(str: string): TBGRAPixel;

var
  GammaExpansionTab:   packed array[0..255] of word;
  GammaCompressionTab: packed array[0..65535] of byte;

implementation

uses Math, SysUtils;

function isEmptyPointF(pt: TPointF): boolean;
begin
  Result := (pt.x = EmptySingle) and (pt.y = EmptySingle);
end;

function BGRAPenStyle(dash1, space1: single; dash2: single; space2: single;
  dash3: single; space3: single; dash4: single; space4: single): TBGRAPenStyle;
var
  i: Integer;
begin
  if dash4 <> 0 then
  begin
    setlength(result,8);
    result[6] := dash4;
    result[7] := space4;
    result[4] := dash3;
    result[5] := space3;
    result[2] := dash2;
    result[3] := space2;
  end else
  if dash3 <> 0 then
  begin
    setlength(result,6);
    result[4] := dash3;
    result[5] := space3;
    result[2] := dash2;
    result[3] := space2;
  end else
  if dash2 <> 0 then
  begin
    setlength(result,4);
    result[2] := dash2;
    result[3] := space2;
  end else
  begin
    setlength(result,2);
  end;
  result[0] := dash1;
  result[1] := space1;
  for i := 0 to high(result) do
    if result[i]=0 then
      raise exception.Create('Zero is not a valid value');
end;

const
  GammaExpFactor   = 1.7;
{  redWeight = 0.299;
  greenWeight = 0.587;
  blueWeight = 0.114;}
  redWeightShl10   = 306;
  greenWeightShl10 = 601;
  blueWeightShl10  = 117;

var
  GammaLinearFactor: single;

procedure InitGamma;
var
  i: integer; {t: textfile; prevval,val: byte; }
begin
  GammaLinearFactor := 65535 / power(255, GammaExpFactor);
  for i := 0 to 255 do
    GammaExpansionTab[i] := round(power(i, GammaExpFactor) * GammaLinearFactor);

  for i := 0 to 65535 do
    GammaCompressionTab[i] := round(power(i / GammaLinearFactor, 1 / GammaExpFactor));

  GammaExpansionTab[1]   := 1; //to avoid information lost
  GammaCompressionTab[1] := 1;
{
     assignfile(t,'gammaout.txt');
     rewrite(t);
     prevval := 255;
     for i := 0 to 255 do
     begin
       val := GammaCompressionTab[i*256+128];
       if val <> prevval then writeln(t,val);
       prevval := val;
     end;
     closefile(t);}
end;

{$hints off}

function GetIntensity(c: TExpandedPixel): word; inline;
begin
  Result := c.red;
  if c.green > Result then
    Result := c.green;
  if c.blue > Result then
    Result := c.blue;
end;

function SetIntensity(c: TExpandedPixel; intensity: word): TExpandedPixel;
var
  curIntensity: word;
begin
  curIntensity := GetIntensity(c);
  if curIntensity = 0 then
    Result := c
  else
  begin
    Result.red   := (c.red * intensity + (curIntensity shr 1)) div curIntensity;
    Result.green := (c.green * intensity + (curIntensity shr 1)) div curIntensity;
    Result.blue  := (c.blue * intensity + (curIntensity shr 1)) div curIntensity;
    Result.alpha := c.alpha;
  end;
end;

function GetLightness(c: TExpandedPixel): word; inline;
begin
  Result := (c.red * redWeightShl10 + c.green * greenWeightShl10 +
    c.blue * blueWeightShl10 + 512) shr 10;
end;

function SetLightness(c: TExpandedPixel; lightness: word): TExpandedPixel;
var
  curLightness: word;
  AddedWhiteness, maxBeforeWhite: word;
  clip: boolean;
begin
  curLightness := GetLightness(c);
  if lightness = curLightness then
  begin //no change
    Result := c;
    exit;
  end;
  if lightness = 65535 then //set to white
  begin
    Result.red   := 65535;
    Result.green := 65535;
    Result.blue  := 65535;
    Result.alpha := c.alpha;
    exit;
  end;
  if lightness = 0 then  //set to black
  begin
    Result.red   := 0;
    Result.green := 0;
    Result.blue  := 0;
    Result.alpha := c.alpha;
    exit;
  end;
  if curLightness = 0 then  //set from black
  begin
    Result.red   := lightness;
    Result.green := lightness;
    Result.blue  := lightness;
    Result.alpha := c.alpha;
    exit;
  end;
  if lightness < curLightness then //darker is easy
  begin
    Result := SetIntensity(c, (GetIntensity(c) * lightness + (curLightness shr 1)) div
      curLightness);
    exit;
  end;
  //lighter and grayer
  Result := c;
  AddedWhiteness := lightness - curLightness;
  maxBeforeWhite := 65535 - AddedWhiteness;
  clip   := False;
  if Result.red <= maxBeforeWhite then
    Inc(Result.red, AddedWhiteness)
  else
  begin
    Result.red := 65535;
    clip := True;
  end;
  if Result.green <= maxBeforeWhite then
    Inc(Result.green, AddedWhiteness)
  else
  begin
    Result.green := 65535;
    clip := True;
  end;
  if Result.blue <= maxBeforeWhite then
    Inc(Result.blue, AddedWhiteness)
  else
  begin
    Result.blue := 65535;
    clip := True;
  end;

  if clip then //light and whiter
  begin
    curLightness   := GetLightness(Result);
    addedWhiteness := lightness - curLightness;
    maxBeforeWhite := 65535 - curlightness;
    Result.red     := Result.red + addedWhiteness * (65535 - Result.red) div
      maxBeforeWhite;
    Result.green   := Result.green + addedWhiteness * (65535 - Result.green) div
      maxBeforeWhite;
    Result.blue    := Result.blue + addedWhiteness * (65535 - Result.blue) div
      maxBeforeWhite;
  end;
end;

function BGRAToHSLA(c: TBGRAPixel): THSLAPixel;
const
  deg60  = 8192;
  deg120 = deg60 * 2;
  deg240 = deg60 * 4;
  deg360 = deg60 * 6;
var
  ec: TExpandedPixel;
  min, max, minMax: integer;
  twiceLightness: integer;
begin
  ec  := GammaExpansion(c);
  min := ec.red;
  max := ec.red;
  if ec.green > max then
    max := ec.green
  else
  if ec.green < min then
    min := ec.green;
  if ec.blue > max then
    max := ec.blue
  else
  if ec.blue < min then
    min  := ec.blue;
  minMax := max - min;

  if minMax = 0 then
    Result.hue := 0
  else
  if max = ec.red then
    Result.hue := (((ec.green - ec.blue) * deg60 + (minMax shr 1)) div
      minMax + deg360) mod deg360
  else
  if max = ec.green then
    Result.hue := ((ec.blue - ec.red) * deg60 + (minMax shr 1)) div minMax + deg120
  else
    {max = ec.blue} Result.hue :=
      ((ec.red - ec.green) * deg60 + (minMax shr 1)) div minMax + deg240;
  twiceLightness := max + min;
  if min = max then
    Result.saturation := 0
  else
  if twiceLightness < 65536 then
    Result.saturation := (int64(minMax) shl 16) div (twiceLightness + 1)
  else
    Result.saturation := (int64(minMax) shl 16) div (131072 - twiceLightness);
  Result.lightness := twiceLightness shr 1;
  Result.alpha := ec.alpha;
  Result.hue   := Result.hue * 65536 div deg360;
end;

function HSLAToBGRA(c: THSLAPixel): TBGRAPixel;
const
  deg30  = 4096;
  deg60  = 8192;
  deg120 = deg60 * 2;
  deg180 = deg60 * 3;
  deg240 = deg60 * 4;
  deg360 = deg60 * 6;

  function ComputeColor(p, q: integer; h: integer): word; inline;
  begin
    if h > deg360 then
      Dec(h, deg360);
    if h < deg60 then
      Result := p + ((q - p) * h + deg30) div deg60
    else
    if h < deg180 then
      Result := q
    else
    if h < deg240 then
      Result := p + ((q - p) * (deg240 - h) + deg30) div deg60
    else
      Result := p;
  end;

var
  q, p: integer;
  ec:   TExpandedPixel;
begin
  c.hue := c.hue * deg360 shr 16;
  if c.saturation = 0 then  //gray
  begin
    ec.red   := c.lightness;
    ec.green := c.lightness;
    ec.blue  := c.lightness;
    ec.alpha := c.alpha;
    Result   := GammaCompression(ec);
    exit;
  end;
  if c.lightness < 32768 then
    q := (c.lightness shr 1) * ((65535 + c.saturation) shr 1) shr 14
  else
    q := c.lightness + c.saturation - ((c.lightness shr 1) *
      (c.saturation shr 1) shr 14);
  if q > 65535 then
    q := 65535;
  p   := c.lightness * 2 - q;
  if p > 65535 then
    p      := 65535;
  ec.red   := ComputeColor(p, q, c.hue + deg120);
  ec.green := ComputeColor(p, q, c.hue);
  ec.blue  := ComputeColor(p, q, c.hue + deg240);
  ec.alpha := c.alpha;
  Result   := GammaCompression(ec);
end;

function GammaExpansion(c: TBGRAPixel): TExpandedPixel;
begin
  Result.red   := GammaExpansionTab[c.red];
  Result.green := GammaExpansionTab[c.green];
  Result.blue  := GammaExpansionTab[c.blue];
  Result.alpha := c.alpha shl 8 + c.alpha;
end;

{$hints on}

function GammaCompression(ec: TExpandedPixel): TBGRAPixel;
begin
  Result.red   := GammaCompressionTab[ec.red];
  Result.green := GammaCompressionTab[ec.green];
  Result.blue  := GammaCompressionTab[ec.blue];
  Result.alpha := ec.alpha shr 8;
end;

function BGRAToGrayscale(c: TBGRAPixel): TBGRAPixel;
var
  ec:    TExpandedPixel;
  gray:  word;
  cgray: byte;
begin
  //gamma expansion
  ec    := GammaExpansion(c);
  //gray composition
  gray  := (ec.red * redWeightShl10 + ec.green * greenWeightShl10 +
    ec.blue * blueWeightShl10 + 512) shr 10;
  //gamma compression
  cgray := GammaCompressionTab[gray];
  Result.red := cgray;
  Result.green := cgray;
  Result.blue := cgray;
  Result.alpha := c.alpha;
end;

function MergeBGRA(c1, c2: TBGRAPixel): TBGRAPixel;
begin
  if (c1.alpha = 0) then
    Result := c2
  else
  if (c2.alpha = 0) then
    Result := c1
  else
  begin
    Result.red   := round((c1.red * c1.alpha + c2.red * c2.alpha) /
      (c1.alpha + c2.alpha));
    Result.green := round((c1.green * c1.alpha + c2.green * c2.alpha) /
      (c1.alpha + c2.alpha));
    Result.blue  := round((c1.blue * c1.alpha + c2.blue * c2.alpha) /
      (c1.alpha + c2.alpha));
    Result.alpha := (c1.alpha + c2.alpha + 1) div 2;
  end;
end;

function BGRA(red, green, blue, alpha: byte): TBGRAPixel;
begin
  Result.red   := red;
  Result.green := green;
  Result.blue  := blue;
  Result.alpha := alpha;
end;

function BGRA(red, green, blue: byte): TBGRAPixel; overload;
begin
  Result.red   := red;
  Result.green := green;
  Result.blue  := blue;
  Result.alpha := 255;
end;

{$PUSH}{$R-}
function ColorToBGRA(color: TColor): TBGRAPixel; overload;
begin
  Result.red   := color;
  Result.green := color shr 8;
  Result.blue  := color shr 16;
  Result.alpha := 255;
end;

function ColorToBGRA(color: TColor; opacity: byte): TBGRAPixel; overload;
begin
  Result.red   := color;
  Result.green := color shr 8;
  Result.blue  := color shr 16;
  Result.alpha := opacity;
end;
{$POP}

{$hints off}
function BGRAToColor(c: TBGRAPixel): TColor;
begin
  Result := c.red + (c.green shl 8) + (c.blue shl 16);
end;

{$hints on}

operator = (const c1, c2: TBGRAPixel): boolean;
begin
  if (c1.alpha = 0) and (c2.alpha = 0) then
    Result := True
  else
    Result := (c1.alpha = c2.alpha) and (c1.red = c2.red) and
      (c1.green = c2.green) and (c1.blue = c2.blue);
end;

function BGRADiff(c1, c2: TBGRAPixel): byte;
var
  CompRedAlpha1, CompGreenAlpha1, CompBlueAlpha1, CompRedAlpha2,
  CompGreenAlpha2, CompBlueAlpha2: integer;
  DiffAlpha: byte;
begin
    {$hints off}
  CompRedAlpha1 := c1.red * c1.alpha;
  CompGreenAlpha1 := c1.green * c1.alpha;
  CompBlueAlpha1 := c1.blue * c1.alpha;
  CompRedAlpha2 := c2.red * c2.alpha;
  CompGreenAlpha2 := c2.green * c2.alpha;
  CompBlueAlpha2 := c2.blue * c2.alpha;
    {$hints on}
  Result    := (Abs(CompRedAlpha2 - CompRedAlpha1) +
    Abs(CompBlueAlpha2 - CompBlueAlpha1) + Abs(CompGreenAlpha2 - CompGreenAlpha1)) div
    (3 * 255);
  DiffAlpha := Abs(c2.Alpha - c1.Alpha) * 3 shr 2;
  if DiffAlpha > Result then
    Result := DiffAlpha;
end;

function PointF(x, y: single): TPointF;
begin
  Result.x := x;
  Result.y := y;
end;

function PtInRect(pt: TPoint; r: TRect): boolean;
var
  temp: integer;
begin
  if r.right < r.left then
  begin
    temp    := r.left;
    r.left  := r.right;
    r.Right := temp;
  end;
  if r.bottom < r.top then
  begin
    temp     := r.top;
    r.top    := r.bottom;
    r.bottom := temp;
  end;
  Result := (pt.X >= r.left) and (pt.Y >= r.top) and (pt.X < r.right) and
    (pt.y < r.bottom);
end;

function StrToGradientType(str: string): TGradientType;
var gt: TGradientType;
begin
  result := gtLinear;
  str := LowerCase(str);
  for gt := low(TGradientType) to high(TGradientType) do
    if str = LowerCase(GradientTypeStr[gt]) then
    begin
      result := gt;
      exit;
    end;
end;

function BGRAToStr(c: TBGRAPixel): string;
begin
  result := IntToHex(c.red,2)+IntToHex(c.green,2)+IntToHex(c.Blue,2)+IntToHex(c.Alpha,2);
end;

{$hints off}
{$notes off}
function StrToBGRA(str: string): TBGRAPixel;
var errPos: integer;
begin
  if length(str)=6 then str += 'FF';
  if length(str)=3 then str += 'F';
  if length(str)=8 then
  begin
    val('$'+copy(str,1,2),result.red,errPos);
    val('$'+copy(str,3,2),result.green,errPos);
    val('$'+copy(str,5,2),result.blue,errPos);
    val('$'+copy(str,7,2),result.alpha,errPos);
  end else
  if length(str)=4 then
  begin
    val('$'+copy(str,1,1),result.red,errPos);
    val('$'+copy(str,2,1),result.green,errPos);
    val('$'+copy(str,3,1),result.blue,errPos);
    val('$'+copy(str,4,1),result.alpha,errPos);
    result.red *= $11;
    result.green *= $11;
    result.blue *= $11;
    result.alpha *= $11;
  end else
    result := BGRAPixelTransparent;
end;
{$notes on}
{$hints on}

initialization

  InitGamma;

end.

