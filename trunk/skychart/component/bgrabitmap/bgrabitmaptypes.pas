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
  Classes, Types, Graphics, FPImage, FPImgCanv, GraphType;

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

  TCubicBezierCurve = record
    p1,c1,c2,p2: TPointF;
  end;
  TQuadraticBezierCurve = record
    p1,c,p2: TPointF;
  end;

function BezierCurve(origin, control1, control2, destination: TPointF) : TCubicBezierCurve; overload;
function BezierCurve(origin, control, destination: TPointF) : TQuadraticBezierCurve; overload;

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

type

  { TBGRACustomBitmap }

  TBGRACustomBitmap = class(TFPCustomImage)
  protected
     function GetHeight: integer; virtual; abstract;
     function GetWidth: integer; virtual; abstract;
     function GetDataPtr: PBGRAPixel; virtual; abstract;
     function GetNbPixels: integer; virtual; abstract;
     function CheckEmpty: boolean; virtual; abstract;
     function GetHasTransparentPixels: boolean; virtual; abstract;
     function GetAverageColor: TColor; virtual; abstract;
     function GetAveragePixel: TBGRAPixel; virtual; abstract;
     procedure SetCanvasOpacity(AValue: byte); virtual; abstract;
     function GetScanLine(y: integer): PBGRAPixel; virtual; abstract;
     function GetRefCount: integer; virtual; abstract;
     function GetBitmap: TBitmap; virtual; abstract;
     function GetLineOrder: TRawImageLineOrder; virtual; abstract;
     function GetCanvasFP: TFPImageCanvas; virtual; abstract;
     function GetCanvasDrawModeFP: TDrawMode; virtual; abstract;
     procedure SetCanvasDrawModeFP(const AValue: TDrawMode); virtual; abstract;
     function GetCanvas: TCanvas; virtual; abstract;
     function GetCanvasOpacity: byte; virtual; abstract;
     function GetCanvasAlphaCorrection: boolean; virtual; abstract;
     procedure SetCanvasAlphaCorrection(const AValue: boolean); virtual; abstract;
     function GetFontHeight: integer; virtual; abstract;
     procedure SetFontHeight(AHeight: integer); virtual; abstract;
     function GetPenStyle: TPenStyle; virtual; abstract;
     procedure SetPenStyle(const AValue: TPenStyle); virtual; abstract;
     function GetCustomPenStyle: TBGRAPenStyle; virtual; abstract;
     procedure SetCustomPenStyle(const AValue: TBGRAPenStyle); virtual; abstract;

  public
     Caption:   string;  //user defined caption

     function NewBitmap(AWidth, AHeight: integer): TBGRACustomBitmap; virtual; abstract;
     function NewBitmap(Filename: string): TBGRACustomBitmap; virtual; abstract;

     procedure LoadFromFile(const filename: string); virtual;
     procedure LoadFromStream(Str: TStream); virtual;
     procedure LoadFromStream(Str: TStream; Handler: TFPCustomImageReader); virtual;
     procedure SaveToFile(const filename: string); virtual;
     procedure SaveToFile(const filename: string; Handler:TFPCustomImageWriter); virtual;
     procedure Assign(ABitmap: TBitmap); virtual; abstract; overload;
     procedure Assign(MemBitmap: TBGRACustomBitmap); virtual; abstract; overload;

     {Pixel functions}
     procedure SetPixel(x, y: integer; c: TColor); virtual; abstract; overload;
     procedure SetPixel(x, y: integer; c: TBGRAPixel); virtual; abstract; overload;
     procedure DrawPixel(x, y: integer; c: TBGRAPixel); virtual; abstract;
     procedure FastBlendPixel(x, y: integer; c: TBGRAPixel); virtual; abstract;
     procedure ErasePixel(x, y: integer; alpha: byte); virtual; abstract;
     procedure AlphaPixel(x, y: integer; alpha: byte); virtual; abstract;
     function GetPixel(x, y: integer): TBGRAPixel; virtual; abstract; overload;
     function GetPixel(x, y: single): TBGRAPixel; virtual; abstract; overload;
     function GetPixelCycle(x, y: integer): TBGRAPixel; virtual;

     {Line primitives}
     procedure SetHorizLine(x, y, x2: integer; c: TBGRAPixel); virtual; abstract;
     procedure DrawHorizLine(x, y, x2: integer; c: TBGRAPixel); virtual; abstract;
     procedure FastBlendHorizLine(x, y, x2: integer; c: TBGRAPixel); virtual; abstract;
     procedure AlphaHorizLine(x, y, x2: integer; alpha: byte); virtual; abstract;
     procedure SetVertLine(x, y, y2: integer; c: TBGRAPixel); virtual; abstract;
     procedure DrawVertLine(x, y, y2: integer; c: TBGRAPixel); virtual; abstract;
     procedure AlphaVertLine(x, y, y2: integer; alpha: byte); virtual; abstract;
     procedure FastBlendVertLine(x, y, y2: integer; c: TBGRAPixel); virtual; abstract;
     procedure DrawHorizLineDiff(x, y, x2: integer; c, compare: TBGRAPixel;
       maxDiff: byte); virtual; abstract;

     {Shapes}
     procedure DrawLine(x1, y1, x2, y2: integer; c: TBGRAPixel; DrawLastPixel: boolean); virtual; abstract;
     procedure DrawLineAntialias(x1, y1, x2, y2: integer; c: TBGRAPixel; DrawLastPixel: boolean); virtual; abstract; overload;
     procedure DrawLineAntialias(x1, y1, x2, y2: integer; c1, c2: TBGRAPixel; dashLen: integer; DrawLastPixel: boolean); virtual; abstract; overload;
     procedure DrawLineAntialias(x1, y1, x2, y2: single; c: TBGRAPixel; w: single); virtual; abstract; overload;
     procedure DrawLineAntialias(x1, y1, x2, y2: single; texture: TBGRACustomBitmap; w: single); virtual; abstract; overload;
     procedure DrawLineAntialias(x1, y1, x2, y2: single; c: TBGRAPixel; w: single; Closed: boolean); virtual; abstract; overload;
     procedure DrawLineAntialias(x1, y1, x2, y2: single; texture: TBGRACustomBitmap; w: single; Closed: boolean); virtual; abstract; overload;
     procedure DrawPolyLineAntialias(const points: array of TPoint; c: TBGRAPixel; DrawLastPixel: boolean); virtual; overload;
     procedure DrawPolyLineAntialias(const points: array of TPoint; c1, c2: TBGRAPixel; dashLen: integer; DrawLastPixel: boolean); virtual; overload;
     procedure DrawPolyLineAntialias(const points: array of TPointF; c: TBGRAPixel; w: single); virtual; abstract; overload;
     procedure DrawPolyLineAntialias(const points: array of TPointF; texture: TBGRACustomBitmap; w: single); virtual; abstract; overload;
     procedure DrawPolyLineAntialias(const points: array of TPointF; c: TBGRAPixel; w: single; Closed: boolean); virtual; abstract; overload;
     procedure DrawPolygonAntialias(const points: array of TPointF; c: TBGRAPixel; w: single); virtual; abstract; overload;
     procedure DrawPolygonAntialias(const points: array of TPointF; texture: TBGRACustomBitmap; w: single); virtual; abstract; overload;
     procedure EraseLineAntialias(x1, y1, x2, y2: single; alpha: byte; w: single); virtual; abstract; overload;
     procedure EraseLineAntialias(x1, y1, x2, y2: single; alpha: byte; w: single; Closed: boolean); virtual; abstract; overload;
     procedure ErasePolyLineAntialias(const points: array of TPointF; alpha: byte; w: single); virtual; abstract; overload;
     procedure FillPolyAntialias(const points: array of TPointF; c: TBGRAPixel); virtual; abstract;
     procedure FillPolyAntialias(const points: array of TPointF; texture: TBGRACustomBitmap); virtual; abstract;
     procedure ErasePolyAntialias(const points: array of TPointF; alpha: byte); virtual; abstract;
     procedure EllipseAntialias(x, y, rx, ry: single; c: TBGRAPixel; w: single); virtual; abstract;
     procedure EllipseAntialias(x, y, rx, ry: single; texture: TBGRACustomBitmap; w: single); virtual; abstract;
     procedure FillEllipseAntialias(x, y, rx, ry: single; c: TBGRAPixel); virtual; abstract;
     procedure FillEllipseAntialias(x, y, rx, ry: single; texture: TBGRACustomBitmap); virtual; abstract;
     procedure EraseEllipseAntialias(x, y, rx, ry: single; alpha: byte); virtual; abstract;
     procedure Rectangle(x, y, x2, y2: integer; c: TBGRAPixel; mode: TDrawMode); virtual; abstract; overload;
     procedure Rectangle(x, y, x2, y2: integer; BorderColor, FillColor: TBGRAPixel;
       mode: TDrawMode); virtual; abstract; overload;
     procedure Rectangle(x, y, x2, y2: integer; c: TColor); virtual; overload;
     procedure Rectangle(r: TRect; c: TBGRAPixel; mode: TDrawMode); virtual; overload;
     procedure Rectangle(r: TRect; BorderColor, FillColor: TBGRAPixel;
       mode: TDrawMode); virtual;overload;
     procedure Rectangle(r: TRect; c: TColor); virtual; overload;
     procedure RectangleAntialias(x, y, x2, y2: single; c: TBGRAPixel;
       w: single); virtual; overload;
     procedure RectangleAntialias(x, y, x2, y2: single; c: TBGRAPixel;
       w: single; back: TBGRAPixel); virtual; abstract; overload;
     procedure RectangleAntialias(x, y, x2, y2: single; texture: TBGRACustomBitmap;
       w: single); virtual; abstract; overload;
     procedure RoundRectAntialias(x,y,x2,y2,rx,ry: single; c: TBGRAPixel; w: single; options: TRoundRectangleOptions = []); virtual; abstract;
     procedure RoundRectAntialias(x,y,x2,y2,rx,ry: single; pencolor: TBGRAPixel; w: single; fillcolor: TBGRAPixel; options: TRoundRectangleOptions = []); virtual; abstract;
     procedure RoundRectAntialias(x,y,x2,y2,rx,ry: single; texture: TBGRACustomBitmap; w: single; options: TRoundRectangleOptions = []); virtual; abstract;
     procedure FillRect(r: TRect; c: TColor); virtual;
     procedure FillRect(r: TRect; c: TBGRAPixel; mode: TDrawMode); virtual;
     procedure FillRect(x, y, x2, y2: integer; c: TColor); virtual;
     procedure FillRect(x, y, x2, y2: integer; c: TBGRAPixel; mode: TDrawMode); virtual; abstract;
     procedure FillRect(x, y, x2, y2: integer; texture: TBGRACustomBitmap; mode: TDrawMode); virtual; abstract;
     procedure FillRectAntialias(x, y, x2, y2: single; c: TBGRAPixel); virtual; abstract;
     procedure FillRectAntialias(x, y, x2, y2: single; texture: TBGRACustomBitmap); virtual; abstract;
     procedure FillRoundRectAntialias(x,y,x2,y2,rx,ry: single; c: TBGRAPixel; options: TRoundRectangleOptions = []); virtual; abstract;
     procedure FillRoundRectAntialias(x,y,x2,y2,rx,ry: single; texture: TBGRACustomBitmap; options: TRoundRectangleOptions = []); virtual; abstract;
     procedure EraseRoundRectAntialias(x,y,x2,y2,rx,ry: single; alpha: byte; options: TRoundRectangleOptions = []); virtual; abstract;
     procedure AlphaFillRect(x, y, x2, y2: integer; alpha: byte); virtual; abstract;
     procedure RoundRect(X1, Y1, X2, Y2: integer; RX, RY: integer;
       BorderColor, FillColor: TBGRAPixel); virtual; abstract;
     procedure TextOut(x, y: integer; s: string; c: TBGRAPixel;
       align: TAlignment); virtual; abstract; overload;
     procedure TextOutAngle(x, y, orientation: integer; s: string; c: TBGRAPixel;
       align: TAlignment); virtual; abstract;
     procedure TextOut(x, y: integer; s: string; c: TBGRAPixel); virtual; overload;
     procedure TextOut(x, y: integer; s: string; c: TColor); virtual; overload;
     procedure TextRect(ARect: TRect; x, y: integer; s: string;
       style: TTextStyle; c: TBGRAPixel); virtual; abstract; overload;
     procedure TextRect(ARect: TRect; s: string;
       halign: TAlignment; valign: TTextLayout; c: TBGRAPixel); virtual; overload;
     function TextSize(s: string): TSize; virtual; abstract;

     {Spline}
     function ComputeClosedSpline(const points: array of TPointF): ArrayOfTPointF; virtual; abstract;
     function ComputeOpenedSpline(const points: array of TPointF): ArrayOfTPointF; virtual; abstract;
     function ComputeBezierCurve(const curve: TCubicBezierCurve): ArrayOfTPointF; virtual; abstract;
     function ComputeBezierCurve(const curve: TQuadraticBezierCurve): ArrayOfTPointF; virtual; abstract;
     function ComputeBezierSpline(const spline: array of TCubicBezierCurve): ArrayOfTPointF; virtual; abstract;
     function ComputeBezierSpline(const spline: array of TQuadraticBezierCurve): ArrayOfTPointF; virtual; abstract;

     {Filling}
     procedure FillTransparent; virtual;
     procedure ApplyGlobalOpacity(alpha: byte); virtual; abstract;
     procedure Fill(c: TColor); virtual; overload;
     procedure Fill(c: TBGRAPixel); virtual; overload;
     procedure Fill(texture: TBGRACustomBitmap); virtual; abstract; overload;
     procedure Fill(c: TBGRAPixel; start, Count: integer); virtual; abstract; overload;
     procedure DrawPixels(c: TBGRAPixel; start, Count: integer); virtual; abstract;
     procedure AlphaFill(alpha: byte); virtual; overload;
     procedure AlphaFill(alpha: byte; start, Count: integer); virtual; abstract; overload;
     procedure ReplaceColor(before, after: TColor); virtual; abstract; overload;
     procedure ReplaceColor(before, after: TBGRAPixel); virtual; abstract; overload;
     procedure ReplaceTransparent(after: TBGRAPixel); virtual; abstract; overload;
     procedure FloodFill(X, Y: integer; Color: TBGRAPixel;
       mode: TFloodfillMode; Tolerance: byte = 0); virtual;
     procedure ParallelFloodFill(X, Y: integer; Dest: TBGRACustomBitmap; Color: TBGRAPixel;
       mode: TFloodfillMode; Tolerance: byte = 0); virtual; abstract;
     procedure GradientFill(x, y, x2, y2: integer; c1, c2: TBGRAPixel;
       gtype: TGradientType; o1, o2: TPointF; mode: TDrawMode;
       gammaColorCorrection: boolean = True; Sinus: Boolean=False); virtual; abstract;
     function CreateBrushTexture(ABrushStyle: TBrushStyle; APatternColor, ABackgroundColor: TBGRAPixel;
                AWidth: integer = 8; AHeight: integer = 8; APenWidth: single = 1): TBGRACustomBitmap; virtual; abstract;

     {Canvas drawing functions}
     procedure DataDrawTransparent(ACanvas: TCanvas; Rect: TRect;
       AData: Pointer; ALineOrder: TRawImageLineOrder; AWidth, AHeight: integer); virtual; abstract;
     procedure DataDrawOpaque(ACanvas: TCanvas; Rect: TRect; AData: Pointer;
       ALineOrder: TRawImageLineOrder; AWidth, AHeight: integer); virtual; abstract;
     procedure GetImageFromCanvas(CanvasSource: TCanvas; x, y: integer); virtual; abstract;
     procedure Draw(ACanvas: TCanvas; x, y: integer; Opaque: boolean = True); virtual; abstract;
     procedure Draw(ACanvas: TCanvas; Rect: TRect; Opaque: boolean = True); virtual; abstract;
     procedure DrawPart(ARect: TRect; Canvas: TCanvas; x, y: integer; Opaque: boolean); virtual;
     function GetPart(ARect: TRect): TBGRACustomBitmap; virtual; abstract;
     procedure InvalidateBitmap; virtual; abstract;         //call if you modify with Scanline
     procedure LoadFromBitmapIfNeeded; virtual; abstract;   //call to ensure that bitmap data is up to date

     {BGRA bitmap functions}
     procedure PutImage(x, y: integer; Source: TBGRACustomBitmap; mode: TDrawMode); virtual; abstract;
     procedure BlendImage(x, y: integer; Source: TBGRACustomBitmap;
       operation: TBlendOperation); virtual; abstract;
     function Duplicate(DuplicateProperties: Boolean = False): TBGRACustomBitmap; virtual; abstract;
     function Equals(comp: TBGRACustomBitmap): boolean; virtual; abstract;
     function Equals(comp: TBGRAPixel): boolean; virtual; abstract;
     function Resample(newWidth, newHeight: integer;
       mode: TResampleMode = rmFineResample): TBGRACustomBitmap; virtual; abstract;
     procedure VerticalFlip; virtual; abstract;
     procedure HorizontalFlip; virtual; abstract;
     function RotateCW: TBGRACustomBitmap; virtual; abstract;
     function RotateCCW: TBGRACustomBitmap; virtual; abstract;
     procedure Negative; virtual; abstract;
     procedure LinearNegative; virtual; abstract;
     procedure SwapRedBlue; virtual; abstract;
     procedure GrayscaleToAlpha; virtual; abstract;
     procedure AlphaToGrayscale; virtual; abstract;
     procedure ApplyMask(mask: TBGRACustomBitmap); virtual; abstract;
     function GetImageBounds(Channel: TChannel = cAlpha): TRect; virtual; abstract;
     function MakeBitmapCopy(BackgroundColor: TColor): TBitmap; virtual; abstract;

     {Filters}
     function FilterSmartZoom3(Option: TMedianOption): TBGRACustomBitmap; virtual; abstract;
     function FilterMedian(Option: TMedianOption): TBGRACustomBitmap; virtual; abstract;
     function FilterSmooth: TBGRACustomBitmap; virtual; abstract;
     function FilterSharpen: TBGRACustomBitmap; virtual; abstract;
     function FilterContour: TBGRACustomBitmap; virtual; abstract;
     function FilterBlurRadial(radius: integer;
       blurType: TRadialBlurType): TBGRACustomBitmap; virtual; abstract;
     function FilterBlurMotion(distance: integer; angle: single;
       oriented: boolean): TBGRACustomBitmap; virtual; abstract;
     function FilterCustomBlur(mask: TBGRACustomBitmap): TBGRACustomBitmap; virtual; abstract;
     function FilterEmboss(angle: single): TBGRACustomBitmap; virtual; abstract;
     function FilterEmbossHighlight(FillSelection: boolean): TBGRACustomBitmap; virtual; abstract;
     function FilterGrayscale: TBGRACustomBitmap; virtual; abstract;
     function FilterNormalize(eachChannel: boolean = True): TBGRACustomBitmap; virtual; abstract;
     function FilterRotate(origin: TPointF; angle: single): TBGRACustomBitmap; virtual; abstract;
     function FilterSphere: TBGRACustomBitmap; virtual; abstract;
     function FilterCylinder: TBGRACustomBitmap; virtual; abstract;
     function FilterPlane: TBGRACustomBitmap; virtual; abstract;

     property Data: PBGRAPixel Read GetDataPtr;
     property Width: integer Read GetWidth;
     property Height: integer Read GetHeight;
     property NbPixels: integer Read GetNbPixels;
     property Empty: boolean Read CheckEmpty;

     property ScanLine[y: integer]: PBGRAPixel Read GetScanLine;
     property RefCount: integer Read GetRefCount;
     property Bitmap: TBitmap Read GetBitmap; //don't forget to call InvalidateBitmap before if you changed something with Scanline
     property HasTransparentPixels: boolean Read GetHasTransparentPixels;
     property AverageColor: TColor Read GetAverageColor;
     property AveragePixel: TBGRAPixel Read GetAveragePixel;
     property LineOrder: TRawImageLineOrder Read GetLineOrder;
     property CanvasFP: TFPImageCanvas read GetCanvasFP;
     property CanvasDrawModeFP: TDrawMode read GetCanvasDrawModeFP write SetCanvasDrawModeFP;
     property Canvas: TCanvas Read GetCanvas;
     property CanvasOpacity: byte Read GetCanvasOpacity Write SetCanvasOpacity;
     property CanvasAlphaCorrection: boolean
       Read GetCanvasAlphaCorrection Write SetCanvasAlphaCorrection;

     property FontHeight: integer Read GetFontHeight Write SetFontHeight;
     property PenStyle: TPenStyle read GetPenStyle Write SetPenStyle;
     property CustomPenStyle: TBGRAPenStyle read GetCustomPenStyle write SetCustomPenStyle;
   end;

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
function BGRAToFPColor(AValue: TBGRAPixel): TFPColor; inline;
function FPColorToBGRA(AValue: TFPColor): TBGRAPixel;
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

function BezierCurve(origin, control1, control2, destination: TPointF
  ): TCubicBezierCurve;
begin
  result.p1 := origin;
  result.c1 := control1;
  result.c2 := control2;
  result.p2 := destination;
end;

function BezierCurve(origin, control, destination: TPointF
  ): TQuadraticBezierCurve;
begin
  result.p1 := origin;
  result.c := control;
  result.p2 := destination;
end;

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

function FPColorToBGRA(AValue: TFPColor): TBGRAPixel;
begin
  with AValue do
    Result := BGRA(red shr 8, green shr 8, blue shr 8, alpha shr 8);
end;

function BGRAToFPColor(AValue: TBGRAPixel): TFPColor; inline;
begin
  result.red := AValue.red shl 8 + AValue.red;
  result.green := AValue.green shl 8 + AValue.green;
  result.blue := AValue.blue shl 8 + AValue.blue;
  result.alpha := AValue.alpha shl 8 + AValue.alpha;
end;

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

{ TBGRACustomBitmap }

procedure TBGRACustomBitmap.LoadFromFile(const filename: string);
begin
  inherited LoadFromFile(filename);
end;

procedure TBGRACustomBitmap.LoadFromStream(Str: TStream);
var
  OldDrawMode: TDrawMode;
begin
  OldDrawMode := CanvasDrawModeFP;
  CanvasDrawModeFP := dmSet;
  try
    inherited LoadFromStream(Str);
  finally
    CanvasDrawModeFP := OldDrawMode;
  end;
end;

procedure TBGRACustomBitmap.LoadFromStream(Str: TStream;
  Handler: TFPCustomImageReader);
var
  OldDrawMode: TDrawMode;
begin
  OldDrawMode := CanvasDrawModeFP;
  CanvasDrawModeFP := dmSet;
  try
    inherited LoadFromStream(Str, Handler);
  finally
    CanvasDrawModeFP := OldDrawMode;
  end;
end;

procedure TBGRACustomBitmap.SaveToFile(const filename: string);
begin
  inherited SaveToFile(filename);
end;

procedure TBGRACustomBitmap.SaveToFile(const filename: string;
  Handler: TFPCustomImageWriter);
begin
  inherited SaveToFile(filename, Handler);
end;

function TBGRACustomBitmap.GetPixelCycle(x, y: integer): TBGRAPixel;
begin
  if (Width = 0) or (Height = 0) then
    Result := BGRAPixelTransparent
  else
  begin
    x := x mod Width;
    if x < 0 then
      Inc(x, Width);
    y := y mod Height;
    if y < 0 then
      Inc(y, Height);
    Result := (Scanline[y] + x)^;
  end;
end;

procedure TBGRACustomBitmap.DrawPolyLineAntialias(const points: array of TPoint;
  c: TBGRAPixel; DrawLastPixel: boolean);
var i: integer;
begin
   if length(points) = 1 then
   begin
     if DrawLastPixel then DrawPixel(points[0].x,points[0].y,c);
   end
   else
     for i := 0 to high(points)-1 do
       DrawLineAntialias(points[i].x,points[i].Y,points[i+1].x,points[i+1].y,c,DrawLastPixel and (i=high(points)-1));
end;

procedure TBGRACustomBitmap.DrawPolyLineAntialias(const points: array of TPoint; c1,
  c2: TBGRAPixel; dashLen: integer; DrawLastPixel: boolean);
var i: integer;
begin
   if length(points) = 1 then
   begin
     if DrawLastPixel then DrawPixel(points[0].x,points[0].y,c1);
   end
   else
     for i := 0 to high(points)-1 do
       DrawLineAntialias(points[i].x,points[i].Y,points[i+1].x,points[i+1].y,c1,c2,dashLen,DrawLastPixel and (i=high(points)-1));
end;

procedure TBGRACustomBitmap.Rectangle(x, y, x2, y2: integer; c: TColor);
begin
  Rectangle(x, y, x2, y2, ColorToBGRA(c), dmSet);
end;

procedure TBGRACustomBitmap.Rectangle(r: TRect; c: TBGRAPixel; mode: TDrawMode
  );
begin
  Rectangle(r.left, r.top, r.right, r.bottom, c, mode);
end;

procedure TBGRACustomBitmap.Rectangle(r: TRect; BorderColor,
  FillColor: TBGRAPixel; mode: TDrawMode);
begin
  Rectangle(r.left, r.top, r.right, r.bottom, BorderColor, FillColor, mode);
end;

procedure TBGRACustomBitmap.Rectangle(r: TRect; c: TColor);
begin
  Rectangle(r.left, r.top, r.right, r.bottom, c);
end;

procedure TBGRACustomBitmap.RectangleAntialias(x, y, x2, y2: single;
  c: TBGRAPixel; w: single);
begin
  RectangleAntialias(x, y, x2, y2, c, w, BGRAPixelTransparent);
end;

procedure TBGRACustomBitmap.FillRect(r: TRect; c: TColor);
begin
  FillRect(r.Left, r.top, r.right, r.bottom, c);
end;

procedure TBGRACustomBitmap.FillRect(r: TRect; c: TBGRAPixel; mode: TDrawMode);
begin
  FillRect(r.Left, r.top, r.right, r.bottom, c, mode);
end;

procedure TBGRACustomBitmap.FillRect(x, y, x2, y2: integer; c: TColor);
begin
  FillRect(x, y, x2, y2, ColorToBGRA(c), dmSet);
end;

procedure TBGRACustomBitmap.TextOut(x, y: integer; s: string; c: TBGRAPixel);
begin
  TextOut(x, y, s, c, taLeftJustify);
end;

procedure TBGRACustomBitmap.TextOut(x, y: integer; s: string; c: TColor);
begin
  TextOut(x, y, s, ColorToBGRA(c));
end;

procedure TBGRACustomBitmap.TextRect(ARect: TRect; s: string;
  halign: TAlignment; valign: TTextLayout; c: TBGRAPixel);
var
  style: TTextStyle;
begin
  FillChar(style,sizeof(style),0);
  style.Alignment := halign;
  style.Layout := valign;
  style.Wordbreak := true;
  style.ShowPrefix := false;
  style.Clipping := false;
  TextRect(ARect,ARect.Left,ARect.Top,s,style,c);
end;

procedure TBGRACustomBitmap.FillTransparent;
begin
  Fill(BGRAPixelTransparent);
end;

procedure TBGRACustomBitmap.Fill(c: TColor);
begin
  Fill(ColorToBGRA(c));
end;

procedure TBGRACustomBitmap.Fill(c: TBGRAPixel);
begin
  Fill(c, 0, NbPixels);
end;

procedure TBGRACustomBitmap.AlphaFill(alpha: byte);
begin
  AlphaFill(alpha, 0, NbPixels);
end;

procedure TBGRACustomBitmap.FloodFill(X, Y: integer; Color: TBGRAPixel;
  mode: TFloodfillMode; Tolerance: byte);
begin
  ParallelFloodFill(X,Y,Self,Color,mode,Tolerance);
end;

procedure TBGRACustomBitmap.DrawPart(ARect: TRect; Canvas: TCanvas; x,
  y: integer; Opaque: boolean);
var
  partial: TBGRACustomBitmap;
begin
  partial := GetPart(ARect);
  if partial <> nil then
  begin
    partial.Draw(Canvas, x, y, Opaque);
    partial.Free;
  end;
end;

{$notes on}
{$hints on}

initialization

  InitGamma;

end.

