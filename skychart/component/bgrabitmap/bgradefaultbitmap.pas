{
 /**************************************************************************\
                             bgradefaultbitmap.pas
                             ---------------------
                 This unit defines basic operations on bitmaps.
                 It should NOT be added to the 'uses' clause.
                 Some operations may be slow, so there are
                 accelerated versions for some routines.

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

unit BGRADefaultBitmap;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Types, FPImage, Graphics, BGRABitmapTypes, GraphType;

type
  TBGRADefaultBitmap = class;
  TBGRABitmapAny     = class of TBGRADefaultBitmap;

  { TBGRADefaultBitmap }

  TBGRADefaultBitmap = class(TFPCustomImage)
  private
    FEraseMode: boolean;
    FBitmapModified: boolean; //if TBitmap has changed
    FFontHeightSign: integer;
    FFont: TFont;
    FFontHeight: integer;
    function GetCanvasAlphaCorrection: boolean;
    procedure SetCanvasAlphaCorrection(const AValue: boolean);
    procedure UpdateFont;
    procedure SetFontHeight(AHeight: integer);
    function GetScanlineFast(y: integer): PBGRAPixel; inline;
  protected
    FBitmap:   TBitmap; //LCL bitmap object
    FRefCount: integer; //reference counter

    {Pixel data}
    FData:      PBGRAPixel;
    FWidth, FHeight, FNbPixels: integer;
    FDataModified: boolean; //if data image has changed
    FLineOrder: TRawImageLineOrder;
    FCanvasOpacity: byte;
    FAlphaCorrectionNeeded: boolean;

    function GetScanLine(y: integer): PBGRAPixel;
    //don't forget to call InvalidateBitmap after modifications
    function GetBitmap: TBitmap;
    function GetCanvas: TCanvas;
    procedure DiscardBitmapChange; inline;
    procedure LoadFromRawImage(ARawImage: TRawImage; DefaultOpacity: byte;
      AlwaysReplaceAlpha: boolean = False);

    {Allocation routines}
    procedure ReallocData; virtual;
    procedure FreeData; virtual;

    procedure RebuildBitmap; virtual;
    procedure FreeBitmap; virtual;

    procedure Init; virtual;
    {TFPCustomImage}
    procedure SetInternalColor(x, y: integer; const Value: TFPColor); override;
    function GetInternalColor(x, y: integer): TFPColor; override;
    procedure SetInternalPixel(x, y: integer; Value: integer); override;
    function GetInternalPixel(x, y: integer): integer; override;

    {resample}
    function FineResample(NewWidth, NewHeight: integer): TBGRADefaultBitmap;
    function SimpleStretch(NewWidth, NewHeight: integer): TBGRADefaultBitmap;

    function CheckEmpty: boolean;
    function GetHasTransparentPixels: boolean;
    function GetAverageColor: TColor;
    function GetAveragePixel: TBGRAPixel;
    procedure SetCanvasOpacity(AValue: byte);
    function GetDataPtr: PBGRAPixel;
    procedure DoAlphaCorrection;
    procedure ClearTransparentPixels;

    {Spline}
    function Spline(y0, y1, y2, y3: single; t: single): single;

  public
    Caption:   string;
    FontName:  string;
    FontStyle: TFontStyles;

    {Reference counter functions}
    function NewReference: TBGRADefaultBitmap;
    procedure FreeReference;
    function GetUnique: TBGRADefaultBitmap;
    function NewBitmap(AWidth, AHeight: integer): TBGRADefaultBitmap;
    function NewBitmap(Filename: string): TBGRADefaultBitmap;

    {TFPCustomImage override}
    constructor Create(AWidth, AHeight: integer); override;
    procedure SetSize(AWidth, AHeight: integer); override;

    {Constructors}
    constructor Create;
    constructor Create(ABitmap: TBitmap);
    constructor Create(AWidth, AHeight: integer; Color: TColor);
    constructor Create(AWidth, AHeight: integer; Color: TBGRAPixel);
    destructor Destroy; override;

    {Loading functions}
    procedure LoadFromFile(const filename: string);
    procedure SaveToFile(const filename: string);
    constructor Create(AFilename: string);
    constructor Create(AStream: TStream);
    procedure Assign(Bitmap: TBitmap); overload;
    procedure Assign(MemBitmap: TBGRADefaultBitmap); overload;

    {Pixel functions}
    procedure SetPixel(x, y: integer; c: TColor); overload;
    procedure SetPixel(x, y: integer; c: TBGRAPixel); overload;
    procedure DrawPixel(x, y: integer; c: TBGRAPixel);
    procedure FastBlendPixel(x, y: integer; c: TBGRAPixel);
    procedure ErasePixel(x, y: integer; alpha: byte);
    procedure AlphaPixel(x, y: integer; alpha: byte);
    function GetPixel(x, y: integer): TBGRAPixel; overload;
    function GetPixel(x, y: single): TBGRAPixel; overload;
    function GetPixelCycle(x, y: integer): TBGRAPixel;

    {Line primitives}
    procedure SetHorizLine(x, y, x2: integer; c: TBGRAPixel);
    procedure DrawHorizLine(x, y, x2: integer; c: TBGRAPixel);
    procedure FastBlendHorizLine(x, y, x2: integer; c: TBGRAPixel);
    procedure AlphaHorizLine(x, y, x2: integer; alpha: byte);
    procedure SetVertLine(x, y, y2: integer; c: TBGRAPixel);
    procedure DrawVertLine(x, y, y2: integer; c: TBGRAPixel);
    procedure AlphaVertLine(x, y, y2: integer; alpha: byte);
    procedure FastBlendVertLine(x, y, y2: integer; c: TBGRAPixel);
    procedure DrawHorizLineDiff(x, y, x2: integer; c, compare: TBGRAPixel;
      maxDiff: byte);

    {Shapes}
    procedure DrawLine(x1, y1, x2, y2: integer; c: TBGRAPixel; DrawLastPixel: boolean);
    procedure DrawLineAntialias(x1, y1, x2, y2: integer; c: TBGRAPixel;
      DrawLastPixel: boolean); overload;
    procedure DrawPolyLineAntialias(points: array of TPoint; c: TBGRAPixel;
      DrawLastPixel: boolean); overload;
    procedure DrawLineAntialias(x1, y1, x2, y2: integer; c1, c2: TBGRAPixel;
      dashLen: integer; DrawLastPixel: boolean); overload;
    procedure DrawPolyLineAntialias(points: array of TPoint; c1, c2: TBGRAPixel;
      dashLen: integer; DrawLastPixel: boolean); overload;
    procedure DrawLineAntialias(x1, y1, x2, y2: single; c: TBGRAPixel;
      w: single; Closed: boolean); overload;
    procedure DrawPolyLineAntialias(points: array of TPointF; c: TBGRAPixel;
      w: single; Closed: boolean); overload;
    procedure DrawPolygonAntialias(points: array of TPointF; c: TBGRAPixel;
      w: single); overload;
    procedure EraseLineAntialias(x1, y1, x2, y2: single; alpha: byte;
      w: single; Closed: boolean); overload;
    procedure FillPolyAntialias(points: array of TPointF; c: TBGRAPixel);
    procedure ErasePolyAntialias(points: array of TPointF; alpha: byte);
    procedure EllipseAntialias(x, y, rx, ry: single; c: TBGRAPixel; w: single);
    procedure FillEllipseAntialias(x, y, rx, ry: single; c: TBGRAPixel);
    procedure EraseEllipseAntialias(x, y, rx, ry: single; alpha: byte);
    procedure Rectangle(x, y, x2, y2: integer; c: TBGRAPixel; mode: TDrawMode);
    procedure Rectangle(x, y, x2, y2: integer; BorderColor, FillColor: TBGRAPixel;
      mode: TDrawMode);
    procedure Rectangle(x, y, x2, y2: integer; c: TColor);
    procedure Rectangle(r: TRect; c: TBGRAPixel; mode: TDrawMode);
    procedure Rectangle(r: TRect; BorderColor, FillColor: TBGRAPixel;
      mode: TDrawMode);
    procedure Rectangle(r: TRect; c: TColor);
    procedure RectangleAntialias(x, y, x2, y2: single; c: TBGRAPixel;
      w: single); overload;
    procedure RectangleAntialias(x, y, x2, y2: single; c: TBGRAPixel;
      w: single; back: TBGRAPixel); overload;
    procedure FillRect(r: TRect; c: TColor);
    procedure FillRect(r: TRect; c: TBGRAPixel; mode: TDrawMode);
    procedure FillRect(x, y, x2, y2: integer; c: TColor);
    procedure FillRect(x, y, x2, y2: integer; c: TBGRAPixel; mode: TDrawMode);
    procedure FillRectAntialias(x, y, x2, y2: single; c: TBGRAPixel);
    procedure AlphaFillRect(x, y, x2, y2: integer; alpha: byte);
    procedure RoundRect(X1, Y1, X2, Y2: integer; RX, RY: integer;
      BorderColor, FillColor: TBGRAPixel);
    procedure TextOut(x, y: integer; s: string; c: TBGRAPixel;
      align: TAlignment); overload;
    procedure TextOut(x, y: integer; s: string; c: TBGRAPixel); overload;
    procedure TextOut(x, y: integer; s: string; c: TColor); overload;
    procedure TextRect(ARect: TRect; x, y: integer; s: string;
      style: TTextStyle; c: TBGRAPixel); overload;
    function TextSize(s: string): TSize;

    {Spline}
    function ComputeClosedSpline(points: array of TPointF): ArrayOfTPointF;
    function ComputeOpenedSpline(points: array of TPointF): ArrayOfTPointF;

    {Filling}
    procedure FillTransparent;
    procedure ApplyGlobalOpacity(alpha: byte);
    procedure Fill(c: TColor); overload;
    procedure Fill(c: TBGRAPixel); overload;
    procedure Fill(c: TBGRAPixel; start, Count: integer); overload;
    procedure DrawPixels(c: TBGRAPixel; start, Count: integer);
    procedure AlphaFill(alpha: byte); overload;
    procedure AlphaFill(alpha: byte; start, Count: integer); overload;
    procedure ReplaceColor(before, after: TColor); overload;
    procedure ReplaceColor(before, after: TBGRAPixel); overload;
    procedure ReplaceTransparent(after: TBGRAPixel); overload;
    procedure FloodFill(X, Y: integer; Color: TBGRAPixel;
      mode: TFloodfillMode; Tolerance: byte = 0);
    procedure ParallelFloodFill(X, Y: integer; Dest: TBGRADefaultBitmap; Color: TBGRAPixel;
      mode: TFloodfillMode; Tolerance: byte = 0);
    procedure GradientFill(x, y, x2, y2: integer; c1, c2: TBGRAPixel;
      gtype: TGradientType; o1, o2: TPointF; mode: TDrawMode;
      gammaColorCorrection: boolean = True; Sinus: Boolean=False);

    {Canvas drawing functions}
    procedure DataDrawTransparent(ACanvas: TCanvas; Rect: TRect;
      AData: Pointer; ALineOrder: TRawImageLineOrder; AWidth, AHeight: integer); virtual;
    procedure DataDrawOpaque(ACanvas: TCanvas; Rect: TRect; AData: Pointer;
      ALineOrder: TRawImageLineOrder; AWidth, AHeight: integer); virtual;
    procedure GetImageFromCanvas(CanvasSource: TCanvas; x, y: integer); virtual;
    procedure Draw(ACanvas: TCanvas; x, y: integer; Opaque: boolean = True); virtual;
    procedure Draw(ACanvas: TCanvas; Rect: TRect; Opaque: boolean = True); virtual;
    procedure DrawPart(ARect: TRect; Canvas: TCanvas; x, y: integer; Opaque: boolean);
    function GetPart(ARect: TRect): TBGRADefaultBitmap;
    procedure InvalidateBitmap; inline; //call if you modify with Scanline
    procedure LoadFromBitmapIfNeeded;   //call to ensure that bitmap data is up to date

    {BGRA bitmap functions}
    procedure PutImage(x, y: integer; Source: TBGRADefaultBitmap; mode: TDrawMode);
    procedure BlendImage(x, y: integer; Source: TBGRADefaultBitmap;
      operation: TBlendOperation);
    function Duplicate: TBGRADefaultBitmap; virtual;
    function Equals(comp: TBGRADefaultBitmap): boolean;
    function Equals(comp: TBGRAPixel): boolean;
    function Resample(newWidth, newHeight: integer;
      mode: TResampleMode = rmFineResample): TBGRADefaultBitmap;
    procedure VerticalFlip;
    procedure HorizontalFlip;
    function RotateCW: TBGRADefaultBitmap;
    function RotateCCW: TBGRADefaultBitmap;
    procedure Negative;
    procedure LinearNegative;
    procedure SwapRedBlue;
    procedure GrayscaleToAlpha;
    procedure AlphaToGrayscale;
    procedure ApplyMask(mask: TBGRADefaultBitmap);
    function GetImageBounds(Channel: TChannel = cAlpha): TRect;
    function MakeBitmapCopy(BackgroundColor: TColor): TBitmap;

    {Filters}
    function FilterSmartZoom3(Option: TMedianOption): TBGRADefaultBitmap;
    function FilterMedian(Option: TMedianOption): TBGRADefaultBitmap;
    function FilterSmooth: TBGRADefaultBitmap;
    function FilterSharpen: TBGRADefaultBitmap;
    function FilterContour: TBGRADefaultBitmap;
    function FilterBlurRadial(radius: integer;
      blurType: TRadialBlurType): TBGRADefaultBitmap;
    function FilterBlurMotion(distance: integer; angle: single;
      oriented: boolean): TBGRADefaultBitmap;
    function FilterCustomBlur(mask: TBGRADefaultBitmap): TBGRADefaultBitmap;
    function FilterEmboss(angle: single): TBGRADefaultBitmap;
    function FilterEmbossHighlight(FillSelection: boolean): TBGRADefaultBitmap;
    function FilterGrayscale: TBGRADefaultBitmap;
    function FilterNormalize(eachChannel: boolean = True): TBGRADefaultBitmap;
    function FilterRotate(origin: TPointF; angle: single): TBGRADefaultBitmap;
    function FilterSphere: TBGRADefaultBitmap;
    function FilterCylinder: TBGRADefaultBitmap;
    function FilterPlane: TBGRADefaultBitmap;

    property Data: PBGRAPixel Read GetDataPtr;
    property Width: integer Read FWidth;
    property Height: integer Read FHeight;
    property NbPixels: integer Read FNbPixels;
    property Empty: boolean Read CheckEmpty;

    property ScanLine[y: integer]: PBGRAPixel Read GetScanLine;
    property RefCount: integer Read FRefCount;
    property Bitmap: TBitmap Read GetBitmap;
    //don't forget to call InvalidateBitmap before if you changed something with Scanline
    property HasTransparentPixels: boolean Read GetHasTransparentPixels;
    property AverageColor: TColor Read GetAverageColor;
    property AveragePixel: TBGRAPixel Read GetAveragePixel;
    property LineOrder: TRawImageLineOrder Read FLineOrder;
    property Canvas: TCanvas Read GetCanvas;
    property CanvasOpacity: byte Read FCanvasOpacity Write SetCanvasOpacity;
    property CanvasAlphaCorrection: boolean
      Read GetCanvasAlphaCorrection Write SetCanvasAlphaCorrection;

    property FontHeight: integer Read FFontHeight Write SetFontHeight;
  end;

type
  { TBGRAPtrBitmap }

  TBGRAPtrBitmap = class(TBGRADefaultBitmap)
  protected
    procedure ReallocData; override;
    procedure FreeData; override;
  public
    constructor Create(AWidth, AHeight: integer; AData: Pointer); overload;
    function Duplicate: TBGRADefaultBitmap; override;
    procedure SetDataPtr(AData: Pointer);
    property LineOrder: TRawImageLineOrder Read FLineOrder Write FLineOrder;
  end;

var
  DefaultTextStyle: TTextStyle;

implementation

uses FPWritePng, Math, LCLIntf, LCLType, BGRAPolygon, BGRAResample,
  BGRAFilters, BGRABlend, BGRAPaintNet,
  FPReadPcx, FPWritePcx, FPReadXPM, FPWriteXPM;

type
  TBitmapTracker = class(TBitmap)
  protected
    FUser: TBGRADefaultBitmap;
    procedure Changed(Sender: TObject); override;
  public
    constructor Create(AUser: TBGRADefaultBitmap); overload;
  end;

constructor TBitmapTracker.Create(AUser: TBGRADefaultBitmap);
begin
  FUser := AUser;
  inherited Create;
end;

procedure TBitmapTracker.Changed(Sender: TObject);
begin
  FUser.FBitmapModified := True;
  inherited Changed(Sender);
end;

{ TBGRADefaultBitmap }

function TBGRADefaultBitmap.CheckEmpty: boolean;
var
  i: integer;
  p: PBGRAPixel;
begin
  p := Data;
  for i := NbPixels - 1 downto 0 do
  begin
    if p^.alpha <> 0 then
    begin
      Result := False;
      exit;
    end;
    Inc(p);
  end;
  Result := True;
end;

function TBGRADefaultBitmap.GetCanvasAlphaCorrection: boolean;
begin
  Result := (FCanvasOpacity <> 0);
end;

procedure TBGRADefaultBitmap.SetCanvasAlphaCorrection(const AValue: boolean);
begin
  if AValue then
  begin
    if FCanvasOpacity = 0 then
      FCanvasOpacity := 255;
  end
  else
    FCanvasOpacity := 0;
end;

procedure TBGRADefaultBitmap.UpdateFont;
begin
  if FFont.Name <> FontName then
    FFont.Name := FontName;
  if FFont.Style <> FontStyle then
    FFont.Style := FontStyle;
  if FFont.Height <> FFontHeight * FFontHeightSign then
    FFont.Height := FFontHeight * FFontHeightSign;
end;

procedure TBGRADefaultBitmap.SetFontHeight(AHeight: integer);
begin
  if AHeight < 0 then
    raise ERangeError.Create('Font height must be positive');
  FFontHeight := AHeight;
end;

function TBGRADefaultBitmap.GetScanlineFast(y: integer): PBGRAPixel; inline;
begin
  Result := FData;
  if FLineOrder = riloBottomToTop then
    y := Height - 1 - y;
  Inc(Result, Width * y);
end;

function TBGRADefaultBitmap.GetScanLine(y: integer): PBGRAPixel;
begin
  if (y < 0) or (y >= Height) then
    raise ERangeError.Create('Scanline: out of bounds')
  else
  begin
    LoadFromBitmapIfNeeded;
    Result := GetScanLineFast(y);
  end;
end;

{------------------------- Reference counter functions ------------------------}

function TBGRADefaultBitmap.NewReference: TBGRADefaultBitmap;
begin
  Inc(FRefCount);
  Result := self;
end;

procedure TBGRADefaultBitmap.FreeReference;
begin
  if self = nil then
    exit;

  if FRefCount > 0 then
  begin
    Dec(FRefCount);
    if FRefCount = 0 then
    begin
      self.Destroy;
    end;
  end;
end;

function TBGRADefaultBitmap.GetUnique: TBGRADefaultBitmap;
begin
  if FRefCount > 1 then
  begin
    Dec(FRefCount);
    Result := self.Duplicate;
  end
  else
    Result := self;
end;

function TBGRADefaultBitmap.NewBitmap(AWidth, AHeight: integer): TBGRADefaultBitmap;
var
  BGRAClass: TBGRABitmapAny;
begin
  BGRAClass := TBGRABitmapAny(self.ClassType);
  if BGRAClass = TBGRAPtrBitmap then
    BGRAClass := TBGRADefaultBitmap;
  Result      := BGRAClass.Create(AWidth, AHeight);
end;

function TBGRADefaultBitmap.NewBitmap(Filename: string): TBGRADefaultBitmap;
var
  BGRAClass: TBGRABitmapAny;
begin
  BGRAClass := TBGRABitmapAny(self.ClassType);
  Result    := BGRAClass.Create(Filename);
end;

{----------------------- TFPCustomImage override ------------------------------}

constructor TBGRADefaultBitmap.Create(AWidth, AHeight: integer);
begin
  Init;
  inherited Create(AWidth, AHeight);
  if FData <> nil then
    FillTransparent;
end;


procedure TBGRADefaultBitmap.SetSize(AWidth, AHeight: integer);
begin
  if (AWidth = Width) and (AHeight = Height) then
    exit;
  inherited SetSize(AWidth, AHeight);
  if AWidth < 0 then
    AWidth := 0;
  if AHeight < 0 then
    AHeight := 0;
  FWidth    := AWidth;
  FHeight   := AHeight;
  FNbPixels := AWidth * AHeight;
  if FNbPixels < 0 then
    raise EOutOfMemory.Create('Image too big');
  FreeBitmap;
  ReallocData;
end;

{---------------------- Constructors ---------------------------------}

constructor TBGRADefaultBitmap.Create;
begin
  Init;
  inherited Create(0, 0);
end;

constructor TBGRADefaultBitmap.Create(ABitmap: TBitmap);
begin
  Init;
  inherited Create(ABitmap.Width, ABitmap.Height);
  LoadFromRawImage(ABitmap.RawImage,0);
end;

constructor TBGRADefaultBitmap.Create(AWidth, AHeight: integer; Color: TColor);
begin
  Init;
  inherited Create(AWidth, AHeight);
  Fill(Color);
end;

constructor TBGRADefaultBitmap.Create(AWidth, AHeight: integer; Color: TBGRAPixel);
begin
  Init;
  inherited Create(AWidth, AHeight);
  Fill(Color);
end;

destructor TBGRADefaultBitmap.Destroy;
begin
  FreeData;
  FBitmap.Free;
  inherited Destroy;
end;

{------------------------- Loading functions ----------------------------------}

constructor TBGRADefaultBitmap.Create(AFilename: string);
begin
  Init;
  LoadFromFile(Afilename);
end;

constructor TBGRADefaultBitmap.Create(AStream: TStream);
begin
  Init;
  LoadFromStream(AStream);
end;

procedure TBGRADefaultBitmap.Assign(Bitmap: TBitmap);
begin
  DiscardBitmapChange;
  SetSize(Bitmap.Width, bitmap.Height);
  GetImageFromCanvas(Bitmap.Canvas, 0, 0);
end;

procedure TBGRADefaultBitmap.Assign(MemBitmap: TBGRADefaultBitmap);
begin
  DiscardBitmapChange;
  SetSize(MemBitmap.Width, MemBitmap.Height);
  PutImage(0, 0, MemBitmap, dmSet);
end;

procedure TBGRADefaultBitmap.LoadFromFile(const filename: string);
var
  tempBitmap: TBGRADefaultBitmap;
begin
  if IsPaintDotNetFile(filename) then
  begin
    tempBitmap := LoadPaintDotNetFile(filename);
    Assign(tempBitmap);
    tempBitmap.Free;
  end
  else
  begin
    inherited LoadFromfile(filename);
    ClearTransparentPixels;
  end;
end;

procedure TBGRADefaultBitmap.SaveToFile(const filename: string);
var
  ext:    string;
  writer: TFPCustomImageWriter;
  pngWriter: TFPWriterPNG;
begin
  ext := AnsiLowerCase(ExtractFileExt(filename));

  if ext = '.png' then
  begin
    pngWriter := TFPWriterPNG.Create;
    pngWriter.Indexed := False;
    pngWriter.UseAlpha := HasTransparentPixels;
    pngWriter.WordSized := false;
    writer    := pngWriter;
  end else
  if (ext='.xpm') and (Width*Height > 32768) then
    raise exception.Create('Image is too big to be saved as XPM') else
      writer := nil;

  if writer <> nil then
  begin
    inherited SaveToFile(Filename, writer);
    writer.Free;
  end
  else
    inherited SaveToFile(Filename);
end;

{-------------------------- Pixel functions -----------------------------------}

procedure TBGRADefaultBitmap.SetPixel(x, y: integer; c: TBGRAPixel);
begin
  if (x < 0) or (x >= Width) or (y < 0) or (y >= Height) then
    exit;
  (Scanline[y] +x)^ := c;
  InvalidateBitmap;
end;

procedure TBGRADefaultBitmap.SetPixel(x, y: integer; c: TColor);
var
  p: PByte;
begin
  if (x < 0) or (x >= Width) or (y < 0) or (y >= Height) then
    exit;
  p  := PByte(Scanline[y] + x);
  p^ := c shr 16;
  Inc(p);
  p^ := c shr 8;
  Inc(p);
  p^ := c;
  Inc(p);
  p^ := 255;
  InvalidateBitmap;
end;

procedure TBGRADefaultBitmap.DrawPixel(x, y: integer; c: TBGRAPixel);
begin
  if (x < 0) or (x >= Width) or (y < 0) or (y >= Height) then
    exit;
  DrawPixelInline(Scanline[y] + x, c);
  InvalidateBitmap;
end;

procedure TBGRADefaultBitmap.FastBlendPixel(x, y: integer; c: TBGRAPixel);
begin
  if (x < 0) or (x >= Width) or (y < 0) or (y >= Height) then
    exit;
  FastBlendPixelInline(Scanline[y] + x, c);
  InvalidateBitmap;
end;

procedure TBGRADefaultBitmap.ErasePixel(x, y: integer; alpha: byte);
begin
  if (x < 0) or (x >= Width) or (y < 0) or (y >= Height) then
    exit;
  ErasePixelInline(Scanline[y] + x, alpha);
  InvalidateBitmap;
end;

procedure TBGRADefaultBitmap.AlphaPixel(x, y: integer; alpha: byte);
begin
  if (x < 0) or (x >= Width) or (y < 0) or (y >= Height) then
    exit;
  if alpha = 0 then
    (Scanline[y] +x)^ := BGRAPixelTransparent
  else
    (Scanline[y] +x)^.alpha := alpha;
  InvalidateBitmap;
end;

function TBGRADefaultBitmap.GetPixel(x, y: integer): TBGRAPixel;
begin
  if (x < 0) or (x >= Width) or (y < 0) or (y >= Height) then
    Result := BGRAPixelTransparent
  else
    Result := (Scanline[y] + x)^;
end;

{$hints off}
function TBGRADefaultBitmap.GetPixel(x, y: single): TBGRAPixel;
var
  ix, iy, w: integer;
  rSum, gSum, bSum, rgbDiv: cardinal;
  aSum, aDiv: cardinal;
  c:    TBGRAPixel;
  scan: PBGRAPixel;
begin
  if (frac(x) = 0) and (frac(y) = 0) then
  begin
    Result := GetPixel(round(x), round(y));
    exit;
  end;
  LoadFromBitmapIfNeeded;

  rSum   := 0;
  gSum   := 0;
  bSum   := 0;
  rgbDiv := 0;
  aSum   := 0;
  aDiv   := 0;

  ix := floor(x);
  iy := floor(y);

  if (iy >= 0) and (iy < Height) then
  begin
    scan := GetScanlineFast(iy);

    if (ix >= 0) and (ix < Width) then
    begin
      c      := (scan + ix)^;
      w      := round((1 - (x - ix)) * (1 - (y - iy)) * 255);
      aDiv   += w;
      aSum   += c.alpha * w;
      c.alpha := c.alpha * w div 255;
      rSum   += c.red * c.alpha;
      gSum   += c.green * c.alpha;
      bSum   += c.blue * c.alpha;
      rgbDiv += c.alpha;
    end;

    Inc(ix);
    if (ix >= 0) and (ix < Width) then
    begin
      c      := (scan + ix)^;
      w      := round((1 - (ix - x)) * (1 - (y - iy)) * 255);
      aDiv   += w;
      aSum   += c.alpha * w;
      c.alpha := c.alpha * w div 255;
      rSum   += c.red * c.alpha;
      gSum   += c.green * c.alpha;
      bSum   += c.blue * c.alpha;
      rgbDiv += c.alpha;
    end;
  end
  else
    Inc(ix);

  Inc(iy);
  if (iy >= 0) and (iy < Height) then
  begin
    scan := GetScanlineFast(iy);

    if (ix >= 0) and (ix < Width) then
    begin
      c      := (scan + ix)^;
      w      := round((1 - (ix - x)) * (1 - (iy - y)) * 255);
      aDiv   += w;
      aSum   += c.alpha * w;
      c.alpha := c.alpha * w div 255;
      rSum   += c.red * c.alpha;
      gSum   += c.green * c.alpha;
      bSum   += c.blue * c.alpha;
      rgbDiv += c.alpha;
    end;

    Dec(ix);
    if (ix >= 0) and (ix < Width) then
    begin
      c      := (scan + ix)^;
      w      := round((1 - (x - ix)) * (1 - (iy - y)) * 255);
      aDiv   += w;
      aSum   += c.alpha * w;
      c.alpha := c.alpha * w div 255;
      rSum   += c.red * c.alpha;
      gSum   += c.green * c.alpha;
      bSum   += c.blue * c.alpha;
      rgbDiv += c.alpha;
    end;
  end;

  if (rgbDiv = 0) or (aDiv = 0) then
    Result := BGRAPixelTransparent
  else
  begin
    Result.red   := (rSum + rgbDiv shr 1) div rgbDiv;
    Result.green := (gSum + rgbDiv shr 1) div rgbDiv;
    Result.blue  := (bSum + rgbDiv shr 1) div rgbDiv;
    Result.alpha := (aSum + aDiv shr 1) div aDiv;
  end;
end;

{$hints on}

function TBGRADefaultBitmap.GetPixelCycle(x, y: integer): TBGRAPixel;
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

procedure TBGRADefaultBitmap.InvalidateBitmap;
begin
  FDataModified := True;
end;

function TBGRADefaultBitmap.GetBitmap: TBitmap;
begin
  if FAlphaCorrectionNeeded and CanvasAlphaCorrection then
    LoadFromBitmapIfNeeded;
  if FDataModified or (FBitmap = nil) then
  begin
    RebuildBitmap;
    FDataModified := False;
  end;
  Result := FBitmap;
end;

function TBGRADefaultBitmap.GetCanvas: TCanvas;
begin
  Result := Bitmap.Canvas;
end;

procedure TBGRADefaultBitmap.LoadFromRawImage(ARawImage: TRawImage;
  DefaultOpacity: byte; AlwaysReplaceAlpha: boolean);
var
  psource_byte, pdest_byte: PByte;
  n, x, y, delta: integer;
  psource_pix, pdest_pix: PBGRAPixel;
  sourceval:      longword;
  OpacityOrMask:  longword;
begin
  if (ARawImage.Description.Width <> cardinal(Width)) or
    (ARawImage.Description.Height <> cardinal(Height)) then
  begin
    raise Exception.Create('Bitmap size is inconsistant');
  end
  else
  if (ARawImage.Description.BitsPerPixel = 32) and
    (ARawImage.DataSize = longword(NbPixels) * sizeof(TBGRAPixel)) then
  begin
    if (ARawImage.Description.AlphaPrec = 8) and not AlwaysReplaceAlpha then
    begin
      psource_pix := PBGRAPixel(ARawImage.Data);
      pdest_pix   := FData;
      if DefaultOpacity = 0 then
        move(psource_pix^, pdest_pix^, NbPixels * sizeof(TBGRAPixel))
      else
      begin
        OpacityOrMask := longword(DefaultOpacity) shl 24;
        for n := NbPixels - 1 downto 0 do
        begin
          sourceval := plongword(psource_pix)^ and $FFFFFF;
          if (sourceval <> 0) and (psource_pix^.alpha = 0) then
          begin
            plongword(pdest_pix)^ := sourceval or OpacityOrMask;
            InvalidateBitmap;
          end
          else
            pdest_pix^ := psource_pix^;
          Inc(pdest_pix);
          Inc(psource_pix);
        end;
      end;
    end
    else
    begin
      psource_byte := ARawImage.Data;
      pdest_byte   := PByte(FData);
      for n := NbPixels - 1 downto 0 do
      begin
        PWord(pdest_byte)^ := PWord(psource_byte)^;
        Inc(pdest_byte, 2);
        Inc(psource_byte, 2);
        pdest_byte^ := psource_byte^;
        Inc(pdest_byte);
        Inc(psource_byte, 2);
        pdest_byte^ := DefaultOpacity;
        Inc(pdest_byte);
      end;
    end;
  end
  else
  if (ARawImage.Description.BitsPerPixel = 24) then
  begin
    psource_byte := ARawImage.Data;
    pdest_byte := PByte(FData);
    delta := integer(ARawImage.Description.BytesPerLine) - FWidth * 3;
    for y := 0 to FHeight - 1 do
    begin
      for x := 0 to FWidth - 1 do
      begin
        PWord(pdest_byte)^ := PWord(psource_byte)^;
        Inc(pdest_byte, 2);
        Inc(psource_byte, 2);
        pdest_byte^ := psource_byte^;
        Inc(pdest_byte);
        Inc(psource_byte);
        pdest_byte^ := DefaultOpacity;
        Inc(pdest_byte);
      end;
      Inc(psource_byte, delta);
    end;
  end
  else
    raise Exception.Create('Invalid raw image format (' + IntToStr(
      ARawImage.Description.Depth) + ' found)');
  DiscardBitmapChange;
  if (ARawImage.Description.RedShift = 0) and
    (ARawImage.Description.BlueShift = 16) then
    SwapRedBlue;
  if ARawImage.Description.LineOrder <> FLineOrder then
    VerticalFlip;
end;

procedure TBGRADefaultBitmap.LoadFromBitmapIfNeeded;
begin
  if FBitmapModified then
  begin
    if FBitmap <> nil then
      LoadFromRawImage(FBitmap.RawImage, FCanvasOpacity);
    DiscardBitmapChange;
  end;
  if FAlphaCorrectionNeeded then
  begin
    DoAlphaCorrection;
  end;
end;

procedure TBGRADefaultBitmap.DiscardBitmapChange; inline;
begin
  FBitmapModified := False;
end;

procedure TBGRADefaultBitmap.Init;
var
  HeightP1, HeightM1: integer;
begin
  FRefCount  := 1;
  FBitmap    := nil;
  FData      := nil;
  FWidth     := 0;
  FHeight    := 0;
  FLineOrder := riloTopToBottom;
  FCanvasOpacity := 255;
  FAlphaCorrectionNeeded := False;
  FEraseMode := False;

  FFont     := TFont.Create;
  FontName  := 'Arial';
  FontStyle := [];
  FFontHeight := 20;
  FFontHeightSign := 1;
  HeightP1  := TextSize('Hg').cy;
  FFontHeightSign := -1;
  HeightM1  := TextSize('Hg').cy;

  if HeightP1 > HeightM1 then
    FFontHeightSign := 1
  else
    FFontHeightSign := -1;
end;

procedure TBGRADefaultBitmap.SetInternalColor(x, y: integer; const Value: TFPColor);
var
  p: PByte;
begin
  if (x < 0) or (y < 0) or (x >= Width) or (y >= Height) then
    exit;
  p  := PByte(Scanline[y] + x);
  p^ := Value.blue shr 8;
  Inc(p);
  p^ := Value.green shr 8;
  Inc(p);
  p^ := Value.red shr 8;
  Inc(p);
  p^ := Value.alpha shr 8;
  InvalidateBitmap;
end;

{$hints off}
function TBGRADefaultBitmap.GetInternalColor(x, y: integer): TFPColor;
var
  p: PByte;
  v: byte;
begin
  if (x < 0) or (y < 0) or (x >= Width) or (y >= Height) then
    exit;
  p := PByte(Scanline[y] + x);
  v := p^;
  Result.blue := v shl 8 + v;
  Inc(p);
  v := p^;
  Result.green := v shl 8 + v;
  Inc(p);
  v := p^;
  Result.red := v shl 8 + v;
  Inc(p);
  v := p^;
  Result.alpha := v shl 8 + v;
end;

{$hints on}

procedure TBGRADefaultBitmap.SetInternalPixel(x, y: integer; Value: integer);
var
  p: PByte;
  c: TFPColor;
begin
  if (x < 0) or (y < 0) or (x >= Width) or (y >= Height) then
    exit;
  c  := Palette.Color[Value];
  p  := PByte(Scanline[y] + x);
  p^ := c.blue shr 8;
  Inc(p);
  p^ := c.green shr 8;
  Inc(p);
  p^ := c.red shr 8;
  Inc(p);
  p^ := c.alpha shr 8;
  InvalidateBitmap;
end;

{$hints off}
function TBGRADefaultBitmap.GetInternalPixel(x, y: integer): integer;
var
  p: PByte;
  v: byte;
  c: TFPColor;
begin
  if (x < 0) or (y < 0) or (x >= Width) or (y >= Height) then
    exit;
  p      := PByte(Scanline[y] + x);
  v      := p^;
  c.blue := v shl 8 + v;
  Inc(p);
  v := p^;
  c.green := v shl 8 + v;
  Inc(p);
  v     := p^;
  c.red := v shl 8 + v;
  Inc(p);
  v      := p^;
  c.alpha := v shl 8 + v;
  Result := palette.IndexOf(c);
end;

{$hints on}

procedure TBGRADefaultBitmap.Draw(ACanvas: TCanvas; x, y: integer; Opaque: boolean);
begin
  if self = nil then
    exit;
  if Opaque then
    DataDrawOpaque(ACanvas, Rect(X, Y, X + Width, Y + Height), Data,
      FLineOrder, FWidth, FHeight)
  else
  begin
    LoadFromBitmapIfNeeded;
    if Empty then
      exit;
    ACanvas.Draw(X, Y, Bitmap);
  end;
end;

procedure TBGRADefaultBitmap.Draw(ACanvas: TCanvas; Rect: TRect; Opaque: boolean);
begin
  if self = nil then
    exit;
  if Opaque then
    DataDrawOpaque(ACanvas, Rect, Data, FLineOrder, FWidth, FHeight)
  else
  begin
    LoadFromBitmapIfNeeded;
    if Empty then
      exit;
    ACanvas.StretchDraw(Rect, Bitmap);
  end;
end;

{---------------------------- Line primitives ---------------------------------}

procedure TBGRADefaultBitmap.SetHorizLine(x, y, x2: integer; c: TBGRAPixel);
var
  temp: integer;
begin
  if (x2 < x) then
  begin
    temp := x;
    x    := x2;
    x2   := temp;
  end;
  if (x >= Width) or (x2 < 0) or (y < 0) or (y >= Height) then
    exit;
  if x < 0 then
    x := 0;
  if x2 >= Width then
    x2 := Width - 1;
  FillInline(scanline[y] + x, c, x2 - x + 1);
  InvalidateBitmap;
end;

procedure TBGRADefaultBitmap.DrawHorizLine(x, y, x2: integer; c: TBGRAPixel);
var
  temp: integer;
begin
  if (x2 < x) then
  begin
    temp := x;
    x    := x2;
    x2   := temp;
  end;
  if (x >= Width) or (x2 < 0) or (y < 0) or (y >= Height) then
    exit;
  if x < 0 then
    x := 0;
  if x2 >= Width then
    x2 := Width - 1;
  DrawPixelsInline(scanline[y] + x, c, x2 - x + 1);
  InvalidateBitmap;
end;

procedure TBGRADefaultBitmap.FastBlendHorizLine(x, y, x2: integer; c: TBGRAPixel);
var
  temp: integer;
begin
  if (x2 < x) then
  begin
    temp := x;
    x    := x2;
    x2   := temp;
  end;
  if (x >= Width) or (x2 < 0) or (y < 0) or (y >= Height) then
    exit;
  if x < 0 then
    x := 0;
  if x2 >= Width then
    x2 := Width - 1;
  FastBlendPixelsInline(scanline[y] + x, c, x2 - x + 1);
  InvalidateBitmap;
end;

procedure TBGRADefaultBitmap.AlphaHorizLine(x, y, x2: integer; alpha: byte);
var
  temp: integer;
begin
  if alpha = 0 then
  begin
    SetHorizLine(x, y, x2, BGRAPixelTransparent);
    exit;
  end;
  if (x2 < x) then
  begin
    temp := x;
    x    := x2;
    x2   := temp;
  end;
  if (x >= Width) or (x2 < 0) or (y < 0) or (y >= Height) then
    exit;
  if x < 0 then
    x := 0;
  if x2 >= Width then
    x2 := Width - 1;
  AlphaFillInline(scanline[y] + x, alpha, x2 - x + 1);
  InvalidateBitmap;
end;

procedure TBGRADefaultBitmap.SetVertLine(x, y, y2: integer; c: TBGRAPixel);
var
  temp, n, delta: integer;
  p: PBGRAPixel;
begin
  if (y2 < y) then
  begin
    temp := y;
    y    := y2;
    y2   := temp;
  end;
  if (y >= Height) or (y2 < 0) or (x < 0) or (x >= Width) then
    exit;
  if y < 0 then
    y := 0;
  if y2 >= Height then
    y2 := Height - 1;
  p    := scanline[y] + x;
  if FLineOrder = riloBottomToTop then
    delta := -Width
  else
    delta := Width;
  for n := y2 - y downto 0 do
  begin
    p^ := c;
    Inc(p, delta);
  end;
  InvalidateBitmap;
end;

procedure TBGRADefaultBitmap.DrawVertLine(x, y, y2: integer; c: TBGRAPixel);
var
  temp, n, delta: integer;
  p: PBGRAPixel;
begin
  if (y2 < y) then
  begin
    temp := y;
    y    := y2;
    y2   := temp;
  end;
  if (y >= Height) or (y2 < 0) or (x < 0) or (x >= Width) then
    exit;
  if y < 0 then
    y := 0;
  if y2 >= Height then
    y2 := Height - 1;
  p    := scanline[y] + x;
  if FLineOrder = riloBottomToTop then
    delta := -Width
  else
    delta := Width;
  for n := y2 - y downto 0 do
  begin
    DrawPixelInline(p, c);
    Inc(p, delta);
  end;
  InvalidateBitmap;
end;

procedure TBGRADefaultBitmap.AlphaVertLine(x, y, y2: integer; alpha: byte);
var
  temp, n, delta: integer;
  p: PBGRAPixel;
begin
  if alpha = 0 then
  begin
    SetVertLine(x, y, y2, BGRAPixelTransparent);
    exit;
  end;
  if (y2 < y) then
  begin
    temp := y;
    y    := y2;
    y2   := temp;
  end;
  if (y >= Height) or (y2 < 0) or (x < 0) or (x >= Width) then
    exit;
  if y < 0 then
    y := 0;
  if y2 >= Height then
    y2 := Height - 1;
  p    := scanline[y] + x;
  if FLineOrder = riloBottomToTop then
    delta := -Width
  else
    delta := Width;
  for n := y2 - y downto 0 do
  begin
    p^.alpha := alpha;
    Inc(p, delta);
  end;
  InvalidateBitmap;
end;

procedure TBGRADefaultBitmap.FastBlendVertLine(x, y, y2: integer; c: TBGRAPixel);
var
  temp, n, delta: integer;
  p: PBGRAPixel;
begin
  if (y2 < y) then
  begin
    temp := y;
    y    := y2;
    y2   := temp;
  end;
  if (y >= Height) or (y2 < 0) or (x < 0) or (x >= Width) then
    exit;
  if y < 0 then
    y := 0;
  if y2 >= Height then
    y2 := Height - 1;
  p    := scanline[y] + x;
  if FLineOrder = riloBottomToTop then
    delta := -Width
  else
    delta := Width;
  for n := y2 - y downto 0 do
  begin
    FastBlendPixelInline(p, c);
    Inc(p, delta);
  end;
  InvalidateBitmap;
end;

procedure TBGRADefaultBitmap.DrawHorizLineDiff(x, y, x2: integer;
  c, compare: TBGRAPixel; maxDiff: byte);
var
  temp: integer;
begin
  if (x2 < x) then
  begin
    temp := x;
    x    := x2;
    x2   := temp;
  end;
  if (x >= Width) or (x2 < 0) or (y < 0) or (y >= Height) then
    exit;
  if x < 0 then
    x := 0;
  if x2 >= Width then
    x2 := Width - 1;
  DrawPixelsInlineDiff(scanline[y] + x, c, x2 - x + 1, compare, maxDiff);
  InvalidateBitmap;
end;

{---------------------------- Shapes ---------------------------------}

procedure TBGRADefaultBitmap.DrawLine(x1, y1, x2, y2: integer;
  c: TBGRAPixel; DrawLastPixel: boolean);
var
  Y, X: integer;
  DX, DY, SX, SY, E: integer;
begin

  if (Y1 = Y2) and (X1 = X2) then
  begin
    if DrawLastPixel then
      DrawPixel(X1, Y1, c);
    Exit;
  end;

  DX := X2 - X1;
  DY := Y2 - Y1;

  if DX < 0 then
  begin
    SX := -1;
    DX := -DX;
  end
  else
    SX := 1;

  if DY < 0 then
  begin
    SY := -1;
    DY := -DY;
  end
  else
    SY := 1;

  DX := DX shl 1;
  DY := DY shl 1;

  X := X1;
  Y := Y1;
  if DX > DY then
  begin
    E := DY - DX shr 1;

    while X <> X2 do
    begin
      DrawPixel(X, Y, c);
      if E >= 0 then
      begin
        Inc(Y, SY);
        Dec(E, DX);
      end;
      Inc(X, SX);
      Inc(E, DY);
    end;
  end
  else
  begin
    E := DX - DY shr 1;

    while Y <> Y2 do
    begin
      DrawPixel(X, Y, c);
      if E >= 0 then
      begin
        Inc(X, SX);
        Dec(E, DY);
      end;
      Inc(Y, SY);
      Inc(E, DX);
    end;
  end;

  if DrawLastPixel then
    DrawPixel(X2, Y2, c);
end;

procedure TBGRADefaultBitmap.DrawLineAntialias(x1, y1, x2, y2: integer;
  c: TBGRAPixel; DrawLastPixel: boolean);
var
  Y, X:  integer;
  DX, DY, SX, SY, E: integer;
  alpha: single;
begin

  if (Y1 = Y2) and (X1 = X2) then
  begin
    if DrawLastPixel then
      DrawPixel(X1, Y1, c);
    Exit;
  end;

  DX := X2 - X1;
  DY := Y2 - Y1;

  if DX < 0 then
  begin
    SX := -1;
    DX := -DX;
  end
  else
    SX := 1;

  if DY < 0 then
  begin
    SY := -1;
    DY := -DY;
  end
  else
    SY := 1;

  DX := DX shl 1;
  DY := DY shl 1;

  X := X1;
  Y := Y1;

  if DX > DY then
  begin
    E := 0;

    while X <> X2 do
    begin
      alpha := 1 - E / DX;
      DrawPixel(X, Y, BGRA(c.red, c.green, c.blue, round(c.alpha * sqrt(alpha))));
      DrawPixel(X, Y + SY, BGRA(c.red, c.green, c.blue,
        round(c.alpha * sqrt(1 - alpha))));
      Inc(E, DY);
      if E >= DX then
      begin
        Inc(Y, SY);
        Dec(E, DX);
      end;
      Inc(X, SX);
    end;
  end
  else
  begin
    E := 0;

    while Y <> Y2 do
    begin
      alpha := 1 - E / DY;
      DrawPixel(X, Y, BGRA(c.red, c.green, c.blue, round(c.alpha * sqrt(alpha))));
      DrawPixel(X + SX, Y, BGRA(c.red, c.green, c.blue,
        round(c.alpha * sqrt(1 - alpha))));
      Inc(E, DX);
      if E >= DY then
      begin
        Inc(X, SX);
        Dec(E, DY);
      end;
      Inc(Y, SY);
    end;
  end;
  if DrawLastPixel then
    DrawPixel(X2, Y2, c);
end;

procedure TBGRADefaultBitmap.DrawPolyLineAntialias(points: array of TPoint;
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

procedure TBGRADefaultBitmap.DrawLineAntialias(x1, y1, x2, y2: integer;
  c1, c2: TBGRAPixel; dashLen: integer; DrawLastPixel: boolean);
var
  Y, X:  integer;
  DX, DY, SX, SY, E: integer;
  alpha: single;
  c:     TBGRAPixel;
  DashPos: integer;
begin

  c := c1;
  DashPos := 0;

  if (Y1 = Y2) and (X1 = X2) then
  begin
    if DrawLastPixel then
      DrawPixel(X1, Y1, c);
    Exit;
  end;

  DX := X2 - X1;
  DY := Y2 - Y1;

  if DX < 0 then
  begin
    SX := -1;
    DX := -DX;
  end
  else
    SX := 1;

  if DY < 0 then
  begin
    SY := -1;
    DY := -DY;
  end
  else
    SY := 1;

  DX := DX shl 1;
  DY := DY shl 1;

  X := X1;
  Y := Y1;

  if DX > DY then
  begin
    E := 0;

    while X <> X2 do
    begin
      alpha := 1 - E / DX;
      DrawPixel(X, Y, BGRA(c.red, c.green, c.blue, round(c.alpha * sqrt(alpha))));
      DrawPixel(X, Y + SY, BGRA(c.red, c.green, c.blue,
        round(c.alpha * sqrt(1 - alpha))));
      Inc(E, DY);
      if E >= DX then
      begin
        Inc(Y, SY);
        Dec(E, DX);
      end;
      Inc(X, SX);

      Inc(DashPos);
      if DashPos = DashLen then
        c := c2
      else
      if DashPos = DashLen + DashLen then
      begin
        c := c1;
        DashPos := 0;
      end;
    end;
  end
  else
  begin
    E := 0;

    while Y <> Y2 do
    begin
      alpha := 1 - E / DY;
      DrawPixel(X, Y, BGRA(c.red, c.green, c.blue, round(c.alpha * sqrt(alpha))));
      DrawPixel(X + SX, Y, BGRA(c.red, c.green, c.blue,
        round(c.alpha * sqrt(1 - alpha))));
      Inc(E, DX);
      if E >= DY then
      begin
        Inc(X, SX);
        Dec(E, DY);
      end;
      Inc(Y, SY);

      Inc(DashPos);
      if DashPos = DashLen then
        c := c2
      else
      if DashPos = DashLen + DashLen then
      begin
        c := c1;
        DashPos := 0;
      end;
    end;
  end;
  if DrawLastPixel then
    DrawPixel(X2, Y2, c);
end;

procedure TBGRADefaultBitmap.DrawPolyLineAntialias(points: array of TPoint; c1,
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

procedure TBGRADefaultBitmap.DrawLineAntialias(x1, y1, x2, y2: single;
  c: TBGRAPixel; w: single; closed: boolean);
var
  dx, dy, d, hx, hy, wx, wy, t, t2, t3: single;
  nbInter, i: integer;

  poly: array of tpointf;
  alphaFactor: single;
begin
  if (w <= 0) then
    exit;
  if (w = 1) and (frac(x1) = 0) and (frac(y1) = 0) and (frac(x2) = 0) and
    (frac(y2) = 0) then
  begin
    DrawLineAntialias(round(x1), round(y1), round(x2), round(y2), c, closed);
    exit;
  end;

  dx := x2 - x1;
  dy := y2 - y1;
  if (dx = 0) and (dy = 0) then
  begin
    if closed then
      FillEllipseAntialias(x1, y1, w / 2, w / 2, c);
    exit;
  end;

  d  := sqrt(sqr(dx) + sqr(dy));
  dx /= d;
  dy /= d;
  hx := dy * w / 2;
  hy := -dx * w / 2;
  wx := dx * w / 2;
  wy := dy * w / 2;

  nbInter := (ceil(w) + 1) * 2;
  setlength(poly, 4 + nbInter * 2);
  poly[0] := pointf(x1 + hx, y1 + hy);
  poly[1] := pointf(x2 + hx, y2 + hy);

  if closed then
  begin
    for i := 0 to nbInter - 1 do
    begin
      t  := 1 - (i + 1) / (nbInter + 1) * 2;
      t2 := sqrt(1 - sqr(t));
      poly[2 + i] := pointf(x2 + t * hx + t2 * wx, y2 + t * hy + t2 * wy);
    end;
  end
  else
  begin
    if c.alpha=255 then alphaFactor := 1 else
    begin
      alphaFactor := sqr(c.alpha / 255) / 2.5;
      if (c.alpha > 220) then
      begin
        t := sqr(sqr((c.alpha-220)/(255-220)));
        alphaFactor := alphaFactor*(1-t)+0.8*t;
      end;
    end;
    for i := 0 to nbInter - 1 do
    begin
      t  := 1 - (i + 1) / (nbInter + 1) * 2;
      t2 := sqrt(1 - sqr(t));
      t3 := (1 - t2) * 0.7;
      poly[2 + i] := pointf(x2 + t * hx - t2 * wx + dx * (alphaFactor + t3),
        y2 + t * hy - t2 * wy + dy * (alphaFactor + t3));
    end;
  end;

  poly[2 + nbinter] := pointf(x2 - hx, y2 - hy);
  poly[3 + nbinter] := pointf(x1 - hx, y1 - hy);

  for i := 0 to nbInter - 1 do
  begin
    t  := (i + 1) / (nbInter + 1) * 2 - 1;
    t2 := sqrt(1 - sqr(t));
    poly[4 + nbinter + i] := pointf(x1 + t * hx - t2 * wx, y1 + t * hy - t2 * wy);
  end;

  FillPolyAntialias(poly, c);
end;

procedure TBGRADefaultBitmap.DrawPolyLineAntialias(points: array of TPointF;
  c: TBGRAPixel; w: single; Closed: boolean);
var i: integer;
begin
   if length(points) = 1 then
   begin
     if Closed then DrawLineAntialias(points[0].x,points[0].y,points[0].x,points[0].y,c,w,true);
   end
   else
     for i := 0 to high(points)-1 do
       DrawLineAntialias(points[i].x,points[i].Y,points[i+1].x,points[i+1].y,c,w,Closed and (i=high(points)-1));
end;

procedure TBGRADefaultBitmap.DrawPolygonAntialias(points: array of TPointF;
  c: TBGRAPixel; w: single);
var i: integer;
begin
   if length(points) = 1 then
   begin
     DrawLineAntialias(points[0].x,points[0].y,points[0].x,points[0].y,c,w,true);
   end
   else
   if length(points) > 1 then
   begin
     for i := 0 to high(points)-1 do
       DrawLineAntialias(points[i].x,points[i].Y,points[i+1].x,points[i+1].y,c,w,False);
     DrawLineAntialias(points[high(points)].x,points[high(points)].Y,points[0].x,points[0].y,c,w,False);
   end;
end;

procedure TBGRADefaultBitmap.EraseLineAntialias(x1, y1, x2, y2: single;
  alpha: byte; w: single; Closed: boolean);
begin
  FEraseMode := True;
  DrawLineAntialias(x1, y1, x2, y2, BGRA(0, 0, 0, alpha), w, Closed);
  FEraseMode := False;
end;

procedure TBGRADefaultBitmap.FillPolyAntialias(points: array of TPointF; c: TBGRAPixel);
begin
  BGRAPolygon.FillPolyAntialias(self, points, c, FEraseMode);
end;

procedure TBGRADefaultBitmap.ErasePolyAntialias(points: array of TPointF; alpha: byte);
begin
  FEraseMode := True;
  FillPolyAntialias(points, BGRA(0, 0, 0, alpha));
  FEraseMode := False;
end;

procedure TBGRADefaultBitmap.EllipseAntialias(x, y, rx, ry: single;
  c: TBGRAPixel; w: single);
begin
  BGRAPolygon.BorderEllipseAntialias(self, x, y, rx, ry, w, c, FEraseMode);
end;

procedure TBGRADefaultBitmap.FillEllipseAntialias(x, y, rx, ry: single; c: TBGRAPixel);
begin
  BGRAPolygon.FillEllipseAntialias(self, x, y, rx, ry, c, FEraseMode);
end;

procedure TBGRADefaultBitmap.EraseEllipseAntialias(x, y, rx, ry: single; alpha: byte);
begin
  FEraseMode := True;
  FillEllipseAntialias(x, y, rx, ry, BGRA(0, 0, 0, alpha));
  FEraseMode := False;
end;

{------------------------ Shapes ----------------------------------------------}

procedure TBGRADefaultBitmap.Rectangle(x, y, x2, y2: integer; c: TColor);
begin
  Rectangle(x, y, x2, y2, ColorToBGRA(c), dmSet);
end;

procedure TBGRADefaultBitmap.Rectangle(r: TRect; c: TBGRAPixel; mode: TDrawMode);
begin
  Rectangle(r.left, r.top, r.right, r.bottom, c, mode);
end;

procedure TBGRADefaultBitmap.Rectangle(r: TRect; BorderColor, FillColor: TBGRAPixel;
  mode: TDrawMode);
begin
  Rectangle(r.left, r.top, r.right, r.bottom, BorderColor, FillColor, mode);
end;

procedure TBGRADefaultBitmap.Rectangle(r: TRect; c: TColor);
begin
  Rectangle(r.left, r.top, r.right, r.bottom, c);
end;

procedure TBGRADefaultBitmap.RectangleAntialias(x, y, x2, y2: single;
  c: TBGRAPixel; w: single);
begin
  RectangleAntialias(x, y, x2, y2, c, w, BGRAPixelTransparent);
end;

procedure TBGRADefaultBitmap.RectangleAntialias(x, y, x2, y2: single;
  c: TBGRAPixel; w: single; back: TBGRAPixel);
var
  poly: array of TPointF;
  temp: single;
begin
  if (x > x2) then
  begin
    temp := x;
    x    := x2;
    x2   := temp;
  end;
  if (y > y2) then
  begin
    temp := y;
    y    := y2;
    y2   := temp;
  end;

  if (x2 - x <= w) or (y2 - y <= w) then
  begin
    FillRectAntialias(x - w / 2, y - w / 2, x2 + w / 2, y2 + w / 2, c);
    exit;
  end;
  w /= 2;

  setlength(poly, 9);
  poly[0] := pointf(x - w, y - w);
  poly[1] := pointf(x2 + w, y - w);
  poly[2] := pointf(x2 + w, y2 + w);
  poly[3] := pointf(x - w, y2 + w);
  poly[4] := EmptyPointF;
  poly[5] := pointf(x + w, y + w);
  poly[6] := pointf(x2 - w, y + w);
  poly[7] := pointf(x2 - w, y2 - w);
  poly[8] := pointf(x + w, y2 - w);
  FillPolyAntialias(poly, c);

  if back.alpha <> 0 then
    FillRectAntialias(x + w, y + w, x2 - w, y2 - w, back);
end;

procedure TBGRADefaultBitmap.FillRect(r: TRect; c: TColor);
begin
  FillRect(r.Left, r.top, r.right, r.bottom, c);
end;

procedure TBGRADefaultBitmap.FillRect(r: TRect; c: TBGRAPixel; mode: TDrawMode);
begin
  FillRect(r.Left, r.top, r.right, r.bottom, c, mode);
end;

procedure TBGRADefaultBitmap.Rectangle(x, y, x2, y2: integer;
  c: TBGRAPixel; mode: TDrawMode);
var
  temp: integer;
begin
  if (x > x2) then
  begin
    temp := x;
    x    := x2;
    x2   := temp;
  end;
  if (y > y2) then
  begin
    temp := y;
    y    := y2;
    y2   := temp;
  end;
  if (x2 - x <= 1) or (y2 - y <= 1) then
    exit;
  case mode of
    dmFastBlend:
    begin
      FastBlendHorizLine(x, y, x2 - 1, c);
      FastBlendHorizLine(x, y2 - 1, x2 - 1, c);
      if y2 - y > 2 then
      begin
        FastBlendVertLine(x, y + 1, y2 - 2, c);
        FastBlendVertLine(x2 - 1, y + 1, y2 - 2, c);
      end;
    end;
    dmDrawWithTransparency:
    begin
      DrawHorizLine(x, y, x2 - 1, c);
      DrawHorizLine(x, y2 - 1, x2 - 1, c);
      if y2 - y > 2 then
      begin
        DrawVertLine(x, y + 1, y2 - 2, c);
        DrawVertLine(x2 - 1, y + 1, y2 - 2, c);
      end;
    end;
    dmSet:
    begin
      SetHorizLine(x, y, x2 - 1, c);
      SetHorizLine(x, y2 - 1, x2 - 1, c);
      if y2 - y > 2 then
      begin
        SetVertLine(x, y + 1, y2 - 2, c);
        SetVertLine(x2 - 1, y + 1, y2 - 2, c);
      end;
    end;
    dmSetExceptTransparent: if (c.alpha = 255) then
        Rectangle(x, y, x2, y2, c, dmSet);
  end;
end;

procedure TBGRADefaultBitmap.Rectangle(x, y, x2, y2: integer;
  BorderColor, FillColor: TBGRAPixel; mode: TDrawMode);
var
  temp: integer;
begin
  if (x > x2) then
  begin
    temp := x;
    x    := x2;
    x2   := temp;
  end;
  if (y > y2) then
  begin
    temp := y;
    y    := y2;
    y2   := temp;
  end;
  if (x2 - x <= 1) or (y2 - y <= 1) then
    exit;

  Rectangle(x, y, x2, y2, BorderColor, mode);
  FillRect(x + 1, y + 1, x2 - 1, y2 - 1, FillColor, mode);
end;

procedure TBGRADefaultBitmap.FillRect(x, y, x2, y2: integer; c: TColor);
begin
  FillRect(x, y, x2, y2, ColorToBGRA(c), dmSet);
end;

procedure TBGRADefaultBitmap.FillRect(x, y, x2, y2: integer; c: TBGRAPixel;
  mode: TDrawMode);
var
  temp, yb, tx, delta: integer;
  p: PBGRAPixel;
begin
  if (x > x2) then
  begin
    temp := x;
    x    := x2;
    x2   := temp;
  end;
  if (y > y2) then
  begin
    temp := y;
    y    := y2;
    y2   := temp;
  end;
  if (x >= Width) or (x2 <= 0) or (y >= Height) or (y2 <= 0) then
    exit;
  if x < 0 then
    x := 0;
  if x2 > Width then
    x2 := Width;
  if y < 0 then
    y := 0;
  if y2 > Height then
    y2 := Height;
  if (x2 - x <= 0) or (y2 - y <= 0) then
    exit;
  tx := x2 - x;
  Dec(x2);
  Dec(y2);

  case mode of
    dmFastBlend:
    begin
      p := Scanline[y] + x;
      if FLineOrder = riloBottomToTop then
        delta := -Width
      else
        delta := Width;
      for yb := y2 - y downto 0 do
      begin
        FastBlendPixelsInline(p, c, tx);
        Inc(p, delta);
      end;
      InvalidateBitmap;
    end;
    dmDrawWithTransparency:
    begin
      p := Scanline[y] + x;
      if FLineOrder = riloBottomToTop then
        delta := -Width
      else
        delta := Width;
      for yb := y2 - y downto 0 do
      begin
        DrawPixelsInline(p, c, tx);
        Inc(p, delta);
      end;
      InvalidateBitmap;
    end;
    dmSet:
    begin
      p := Scanline[y] + x;
      if FLineOrder = riloBottomToTop then
        delta := -Width
      else
        delta := Width;
      for yb := y2 - y downto 0 do
      begin
        FillInline(p, c, tx);
        Inc(p, delta);
      end;
      InvalidateBitmap;
    end;
    dmSetExceptTransparent: if (c.alpha = 255) then
        FillRect(x, y, x2, y2, c, dmSet);
  end;
end;

procedure TBGRADefaultBitmap.FillRectAntialias(x, y, x2, y2: single; c: TBGRAPixel);
var
  poly: array of TPointF;
begin
  setlength(poly, 4);
  poly[0] := pointf(x, y);
  poly[1] := pointf(x2, y);
  poly[2] := pointf(x2, y2);
  poly[3] := pointf(x, y2);
  FillPolyAntialias(poly, c);
end;

procedure TBGRADefaultBitmap.AlphaFillRect(x, y, x2, y2: integer; alpha: byte);
var
  temp, yb, tx, delta: integer;
  p: PBGRAPixel;
begin
  if alpha = 0 then
  begin
    FillRect(x, y, x2, y2, BGRAPixelTransparent, dmSet);
    exit;
  end;

  if (x > x2) then
  begin
    temp := x;
    x    := x2;
    x2   := temp;
  end;
  if (y > y2) then
  begin
    temp := y;
    y    := y2;
    y2   := temp;
  end;
  if (x >= Width) or (x2 <= 0) or (y >= Height) or (y2 <= 0) then
    exit;
  if x < 0 then
    x := 0;
  if x2 > Width then
    x2 := Width;
  if y < 0 then
    y := 0;
  if y2 > Height then
    y2 := Height;
  if (x2 - x <= 0) or (y2 - y <= 0) then
    exit;
  tx := x2 - x;
  Dec(x2);
  Dec(y2);

  p := Scanline[y] + x;
  if FLineOrder = riloBottomToTop then
    delta := -Width
  else
    delta := Width;
  for yb := y2 - y downto 0 do
  begin
    AlphaFillInline(p, alpha, tx);
    Inc(p, delta);
  end;
  InvalidateBitmap;
end;

procedure TBGRADefaultBitmap.RoundRect(X1, Y1, X2, Y2: integer;
  RX, RY: integer; BorderColor, FillColor: TBGRAPixel);
var
  CX, CY, CX1, CY1, A, B, NX, NY: single;
  X, Y, EX, EY: integer;
  LX1, LY1: integer;
  LX2, LY2: integer;
  DivSqrA, DivSqrB: single;
  I, J, S: integer;
  EdgeList: array of TPoint;
  temp:   integer;
  LX, LY: integer;

  procedure AddEdge(X, Y: integer);
  begin
    if (EdgeList[Y].X = -1) or (X < EdgeList[Y].X) then
      EdgeList[Y].X := X;
    if (EdgeList[Y].Y = -1) or (X > EdgeList[Y].Y) then
      EdgeList[Y].Y := X;
  end;

begin
  if (x1 > x2) then
  begin
    temp := x1;
    x1   := x2;
    x2   := temp;
  end;
  if (y1 > y2) then
  begin
    temp := y1;
    y1   := y2;
    y2   := temp;
  end;
  if (x2 - x1 <= 0) or (y2 - y1 <= 0) then
    exit;
  LX := x2 - x1 - RX;
  LY := y2 - y1 - RY;
  Dec(x2);
  Dec(y2);

  if (X1 = X2) and (Y1 = Y2) then
  begin
    DrawPixel(X1, Y1, BorderColor);
    Exit;
  end;

  if (X2 - X1 = 1) or (Y2 - Y1 = 1) then
  begin
    FillRect(X1, Y1, X2 + 1, Y2 + 1, BorderColor, dmDrawWithTransparency);
    Exit;
  end;

  if (LX > X2 - X1) or (LY > Y2 - Y1) then
  begin
    Rectangle(X1, Y1, X2 + 1, Y2 + 1, BorderColor, dmDrawWithTransparency);
    FillRect(X1 + 1, Y1 + 1, X2, Y2, FillColor, dmDrawWithTransparency);
    Exit;
  end;

  SetLength(EdgeList, Ceil((Y2 - Y1 + 1) / 2));
  for I := 0 to Pred(High(EdgeList)) do
    EdgeList[I] := Point(-1, -1);
  EdgeList[High(EdgeList)] := Point(0, 0);

  A  := (X2 - X1 + 1 - LX) / 2;
  B  := (Y2 - Y1 + 1 - LY) / 2;
  CX := (X2 + X1 + 1) / 2;
  CY := (Y2 + Y1 + 1) / 2;

  CX1 := X2 + 1 - A - Floor(CX);
  CY1 := Y2 + 1 - B - Floor(CY);

  EX := Floor(Sqr(A) / Sqrt(Sqr(A) + Sqr(B)) + Frac(A));
  EY := Floor(Sqr(B) / Sqrt(Sqr(A) + Sqr(B)) + Frac(B));

  DivSqrA := 1 / Sqr(A);
  DivSqrB := 1 / Sqr(B);

  NY := B;
  AddEdge(Floor(CX1), Round(CY1 + B) - 1);
  for X := 1 to Pred(EX) do
  begin
    NY := B * Sqrt(1 - Sqr(X + 0.5 - Frac(A)) * DivSqrA);

    AddEdge(Floor(CX1) + X, Round(CY1 + NY) - 1);
  end;

  LX1 := Floor(CX1) + Pred(EX);
  LY1 := Round(CY1 + NY) - 1;

  NX := A;
  AddEdge(Round(CX1 + A) - 1, Floor(CY1));
  for Y := 1 to Pred(EY) do
  begin
    NX := A * Sqrt(1 - Sqr(Y + 0.5 - Frac(B)) * DivSqrB);

    AddEdge(Round(CX1 + NX) - 1, Floor(CY1) + Y);
  end;

  LX2 := Round(CX1 + NX) - 1;
  LY2 := Floor(CY1) + Pred(EY);

  if Abs(LX1 - LX2) > 1 then
  begin
    if Abs(LY1 - LY2) > 1 then
      AddEdge(LX1 + 1, LY1 - 1)
    else
      AddEdge(LX1 + 1, LY1);
  end
  else
  if Abs(LY1 - LY2) > 1 then
    AddEdge(LX2, LY1 - 1);

  for I := 0 to High(EdgeList) do
  begin
    if EdgeList[I].X = -1 then
      EdgeList[I] := Point(Round(CX1 + A) - 1, Round(CX1 + A) - 1)
    else
      Break;
  end;

  for J := 0 to High(EdgeList) do
  begin
    if (J = 0) and (Frac(CY) > 0) then
    begin
      for I := EdgeList[J].X to EdgeList[J].Y do
      begin
        DrawPixel(Floor(CX) + I, Floor(CY) + J, BorderColor);
        DrawPixel(Ceil(CX) - Succ(I), Floor(CY) + J, BorderColor);
      end;

      DrawHorizLine(Ceil(CX) - EdgeList[J].X, Floor(CY) + J, Floor(CX) +
        Pred(EdgeList[J].X), FillColor);
    end
    else
    if (J = High(EdgeList)) then
    begin
      if Frac(CX) > 0 then
        S := -EdgeList[J].Y
      else
        S := -Succ(EdgeList[J].Y);

      for I := S to EdgeList[J].Y do
      begin
        DrawPixel(Floor(CX) + I, Floor(CY) + J, BorderColor);
        DrawPixel(Floor(CX) + I, Ceil(CY) - Succ(J), BorderColor);
      end;
    end
    else
    begin
      for I := EdgeList[J].X to EdgeList[J].Y do
      begin
        DrawPixel(Floor(CX) + I, Floor(CY) + J, BorderColor);
        DrawPixel(Floor(CX) + I, Ceil(CY) - Succ(J), BorderColor);
        if Floor(CX) + I <> Ceil(CX) - Succ(I) then
        begin
          DrawPixel(Ceil(CX) - Succ(I), Floor(CY) + J, BorderColor);
          DrawPixel(Ceil(CX) - Succ(I), Ceil(CY) - Succ(J), BorderColor);
        end;
      end;

      DrawHorizLine(Ceil(CX) - EdgeList[J].X, Floor(CY) + J,
        Floor(CX) + Pred(EdgeList[J].X), FillColor);
      DrawHorizLine(Ceil(CX) - EdgeList[J].X, Ceil(CY) - Succ(J),
        Floor(CX) + Pred(EdgeList[J].X), FillColor);
    end;
  end;
end;

procedure TBGRADefaultBitmap.TextOut(x, y: integer; s: string; c: TBGRAPixel);
begin
  TextOut(x, y, s, c, taLeftJustify);
end;


{$HINTS OFF}
procedure TBGRADefaultBitmap.TextOut(x, y: integer; s: string;
  c: TBGRAPixel; align: TAlignment);
var
  size:  TSize;
  temp:  TBGRADefaultBitmap;
  P:     PBGRAPixel;
  n:     integer;
  alpha: integer;
begin
  UpdateFont;

  size := TextSize(s);
  if (size.cx = 0) or (size.cy = 0) then
    exit;

  case align of
    taLeftJustify: ;
    taCenter: Dec(x, size.cx div 2);
    taRightJustify: Dec(x, size.cx);
  end;

  temp := NewBitmap(size.cx, size.cy);
  temp.Fill(clBlack);
  temp.Canvas.Font := FFont;
  temp.Canvas.Font.Color := clWhite;
  temp.Canvas.Brush.Style := bsClear;
  temp.Canvas.TextOut(0, 0, s);
  p := temp.Data;
  for n := temp.NbPixels - 1 downto 0 do
  begin
    alpha    := P^.green;
    p^.red   := c.red;
    p^.green := c.green;
    p^.blue  := c.blue;
    p^.alpha := (c.alpha * alpha) div 255;
    Inc(p);
  end;
  PutImage(x, y, temp, dmDrawWithTransparency);
  temp.Free;
end;

{$HINTS ON}

procedure TBGRADefaultBitmap.TextOut(x, y: integer; s: string; c: TColor);
begin
  TextOut(x, y, s, ColorToBGRA(c));
end;

procedure TBGRADefaultBitmap.TextRect(ARect: TRect; x, y: integer;
  s: string; style: TTextStyle; c: TBGRAPixel);
var
  tx, ty: integer;
  temp:   TBGRADefaultBitmap;
  P:      PBGRAPixel;
  n:      integer;
  alpha:  integer;
begin
  UpdateFont;

  if ARect.Left < 0 then
    ARect.Left := 0;
  if ARect.Top < 0 then
    ARect.Top := 0;
  if ARect.Right > Width then
    ARect.Right := Width;
  if ARect.Bottom > Height then
    ARect.Bottom := Height;

  tx := ARect.Right - ARect.Left;
  ty := ARect.Bottom - ARect.Top;
  if (tx <= 0) or (ty <= 0) then
    exit;
  temp := NewBitmap(tx, ty);
  temp.Fill(clBlack);
  temp.Canvas.Font := FFont;
  temp.Canvas.Font.Color := clWhite;
  temp.Canvas.Brush.Style := bsClear;
  temp.Canvas.TextRect(rect(0, 0, tx, ty), x - ARect.Left, y - ARect.Top, s, style);
  p := temp.Data;
  for n := tx * ty - 1 downto 0 do
  begin
    alpha    := P^.green;
    p^.red   := c.red;
    p^.green := c.green;
    p^.blue  := c.blue;
    p^.alpha := (c.alpha * alpha) div 255;
    Inc(p);
  end;
  PutImage(ARect.Left, ARect.Top, temp, dmDrawWithTransparency);
  temp.Free;
end;

{$hints off}
function TBGRADefaultBitmap.TextSize(s: string): TSize;
var
  temp: TBitmap;
begin
  UpdateFont;

  temp := TBitmap.Create;
  temp.Canvas.Font := FFont;
  temp.Canvas.Font.GetTextSize(s, Result.cx, Result.cy);
  temp.Free;
end;

{$hints on}

{----------------------- Spline ------------------}

function TBGRADefaultBitmap.Spline(y0, y1, y2, y3: single; t: single): single;
var
  a0, a1, a2, a3: single;
  t2: single;
begin
  t2     := t * t;
  a0     := y3 - y2 - y0 + y1;
  a1     := y0 - y1 - a0;
  a2     := y2 - y0;
  a3     := y1;
  Result := a0 * t * t2 + a1 * t2 + a2 * t + a3;
end;

function TBGRADefaultBitmap.ComputeClosedSpline(points: array of TPointF):
ArrayOfTPointF;

  function computePrecision(pt1, pt2, pt3, pt4: TPointF): integer;
  var
    len: single;
  begin
    len    := sqrt(sqr(pt1.x - pt2.x) + sqr(pt1.y - pt2.y));
    len    := max(len, sqrt(sqr(pt3.x - pt2.x) + sqr(pt3.y - pt2.y)));
    len    := max(len, sqrt(sqr(pt3.x - pt4.x) + sqr(pt3.y - pt4.y)));
    Result := round(sqrt(len) * 2);
  end;

var
  i, j, nb, idx, pre: integer;
  ptPrev, ptPrev2, ptNext, ptNext2: TPointF;

begin
  if length(points) = 2 then
  begin
    setlength(Result, 2);
    Result[0] := points[0];
    Result[1] := points[1];
    exit;
  end;

  nb := 1;
  for i := 0 to high(points) do
  begin
    ptPrev2 := points[(i + length(points) - 1) mod length(points)];
    ptPrev  := points[i];
    ptNext  := points[(i + 1) mod length(points)];
    ptNext2 := points[(i + 2) mod length(points)];
    nb      += computePrecision(ptPrev2, ptPrev, ptNext, ptNext2);
  end;

  setlength(Result, nb);
  Result[0] := points[0];
  idx := 1;
  for i := 0 to high(points) do
  begin
    ptPrev2 := points[(i + length(points) - 1) mod length(points)];
    ptPrev  := points[i];
    ptNext  := points[(i + 1) mod length(points)];
    ptNext2 := points[(i + 2) mod length(points)];
    pre     := computePrecision(ptPrev2, ptPrev, ptNext, ptNext2);
    for j := 1 to pre - 1 do
    begin
      Result[idx] := pointF(spline(ptPrev2.x, ptPrev.X, ptNext.X, ptNext2.X, j / pre),
        spline(ptPrev2.y, ptPrev.y, ptNext.y, ptNext2.y, j / pre));
      Inc(idx);
    end;
    if pre <> 0 then
    begin
      Result[idx] := ptNext;
      Inc(idx);
    end;
  end;
end;

function TBGRADefaultBitmap.ComputeOpenedSpline(points: array of TPointF):
ArrayOfTPointF;

  function computePrecision(pt1, pt2, pt3, pt4: TPointF): integer;
  var
    len: single;
  begin
    len    := sqrt(sqr(pt1.x - pt2.x) + sqr(pt1.y - pt2.y));
    len    := max(len, sqrt(sqr(pt3.x - pt2.x) + sqr(pt3.y - pt2.y)));
    len    := max(len, sqrt(sqr(pt3.x - pt4.x) + sqr(pt3.y - pt4.y)));
    Result := round(sqrt(len) * 2);
  end;

var
  i, j, nb, idx, pre: integer;
  ptPrev, ptPrev2, ptNext, ptNext2: TPointF;

begin
  if length(points) = 2 then
  begin
    setlength(Result, 2);
    Result[0] := points[0];
    Result[1] := points[1];
    exit;
  end;

  nb := 1;
  for i := 0 to high(points) - 1 do
  begin
    ptPrev2 := points[max(0, i - 1)];
    ptPrev  := points[i];
    ptNext  := points[i + 1];
    ptNext2 := points[min(high(points), i + 2)];
    nb      += computePrecision(ptPrev2, ptPrev, ptNext, ptNext2);
  end;

  setlength(Result, nb);
  Result[0] := points[0];
  idx := 1;
  for i := 0 to high(points) - 1 do
  begin
    ptPrev2 := points[max(0, i - 1)];
    ptPrev  := points[i];
    ptNext  := points[i + 1];
    ptNext2 := points[min(high(points), i + 2)];
    pre     := computePrecision(ptPrev2, ptPrev, ptNext, ptNext2);
    for j := 1 to pre - 1 do
    begin
      Result[idx] := pointF(spline(ptPrev2.x, ptPrev.X, ptNext.X, ptNext2.X, j / pre),
        spline(ptPrev2.y, ptPrev.y, ptNext.y, ptNext2.y, j / pre));
      Inc(idx);
    end;
    if pre <> 0 then
    begin
      Result[idx] := ptNext;
      Inc(idx);
    end;
  end;
end;

{---------------------------------- Fill ---------------------------------}

procedure TBGRADefaultBitmap.FillTransparent;
begin
  Fill(BGRAPixelTransparent);
end;

procedure TBGRADefaultBitmap.ApplyGlobalOpacity(alpha: byte);
var
  p: PBGRAPixel;
  i: integer;
begin
  if alpha = 0 then
    FillTransparent
  else
  if alpha <> 255 then
  begin
    p := Data;
    for i := NbPixels - 1 downto 0 do
    begin
      p^.alpha := (p^.alpha * alpha + 128) shr 8;
      Inc(p);
    end;
  end;
end;

procedure TBGRADefaultBitmap.Fill(c: TColor);
begin
  Fill(ColorToBGRA(c));
end;

procedure TBGRADefaultBitmap.Fill(c: TBGRAPixel);
begin
  Fill(c, 0, Width * Height);
end;

procedure TBGRADefaultBitmap.Fill(c: TBGRAPixel; start, Count: integer);
begin
  if start < 0 then
  begin
    Count += start;
    start := 0;
  end;
  if start >= nbPixels then
    exit;
  if start + Count > nbPixels then
    Count := nbPixels - start;

  FillInline(Data + start, c, Count);
  InvalidateBitmap;
end;

procedure TBGRADefaultBitmap.AlphaFill(alpha: byte);
begin
  AlphaFill(alpha, 0, NbPixels);
end;

procedure TBGRADefaultBitmap.AlphaFill(alpha: byte; start, Count: integer);
begin
  if alpha = 0 then
    Fill(BGRAPixelTransparent, start, Count);
  if start < 0 then
  begin
    Count += start;
    start := 0;
  end;
  if start >= nbPixels then
    exit;
  if start + Count > nbPixels then
    Count := nbPixels - start;

  AlphaFillInline(Data + start, alpha, Count);
  InvalidateBitmap;
end;

procedure TBGRADefaultBitmap.ReplaceColor(before, after: TColor);
const
  colorMask = $00FFFFFF;
var
  p: PLongWord;
  n: integer;
  beforeBGR, afterBGR: longword;
begin
  beforeBGR := (before and $FF shl 16) + (before and $FF00) + (before shr 16 and $FF);
  afterBGR  := (after and $FF shl 16) + (after and $FF00) + (after shr 16 and $FF);

  p := PLongWord(Data);
  for n := NbPixels - 1 downto 0 do
  begin
    if p^ and colorMask = beforeBGR then
      p^ := (p^ and not ColorMask) or afterBGR;
    Inc(p);
  end;
  InvalidateBitmap;
end;

procedure TBGRADefaultBitmap.ReplaceColor(before, after: TBGRAPixel);
var
  p: PBGRAPixel;
  n: integer;
begin
  if before.alpha = 0 then
  begin
    ReplaceTransparent(after);
    exit;
  end;
  p := Data;
  for n := NbPixels - 1 downto 0 do
  begin
    if p^ = before then
      p^ := after;
    Inc(p);
  end;
  InvalidateBitmap;
end;

procedure TBGRADefaultBitmap.ReplaceTransparent(after: TBGRAPixel);
var
  p: PBGRAPixel;
  n: integer;
begin
  p := Data;
  for n := NbPixels - 1 downto 0 do
  begin
    if p^.alpha = 0 then
      p^ := after;
    Inc(p);
  end;
  InvalidateBitmap;
end;

procedure TBGRADefaultBitmap.FloodFill(X, Y: integer; Color: TBGRAPixel;
  mode: TFloodfillMode; Tolerance: byte = 0);
begin
  ParallelFloodFill(X,Y,Self,Color,mode,Tolerance);
end;

procedure TBGRADefaultBitmap.ParallelFloodFill(X, Y: integer;
  Dest: TBGRADefaultBitmap; Color: TBGRAPixel; mode: TFloodfillMode;
  Tolerance: byte);
var
  S:     TBGRAPixel;
  SX, EX, I: integer;
  Added: boolean;

  Visited: array of longword;
  VisitedLineSize: integer;

  Stack:      array of integer;
  StackCount: integer;

  function CheckPixel(AX, AY: integer): boolean; inline;
  var
    ComparedColor: TBGRAPixel;
  begin
    if Visited[AX shr 5 + AY * VisitedLineSize] and (1 shl (AX and 31)) <> 0 then
      Result := False
    else
    begin
      ComparedColor := GetPixel(AX, AY);
      Result := BGRADiff(ComparedColor, S) <= Tolerance;
    end;
  end;

  procedure SetVisited(X1, AY, X2: integer);
  var
    StartMask, EndMask: longword;
    StartPos, EndPos:   integer;
  begin
    if X2 < X1 then
      exit;
    StartMask := $FFFFFFFF shl (X1 and 31);
    if X2 and 31 = 31 then
      EndMask := $FFFFFFFF
    else
      EndMask := 1 shl ((X2 and 31) + 1) - 1;
    StartPos := X1 shr 5 + AY * VisitedLineSize;
    EndPos := X2 shr 5 + AY * VisitedLineSize;
    if StartPos = EndPos then
      Visited[StartPos] := Visited[StartPos] or (StartMask and EndMask)
    else
    begin
      Visited[StartPos] := Visited[StartPos] or StartMask;
      Visited[EndPos]   := Visited[EndPos] or EndMask;
      if EndPos - StartPos > 1 then
        FillDWord(Visited[StartPos + 1], EndPos - StartPos - 1, $FFFFFFFF);
    end;
  end;

  procedure Push(AX, AY: integer); inline;
  begin
    if StackCount + 1 >= High(Stack) then
      SetLength(Stack, Length(Stack) shl 1);

    Stack[StackCount] := AX;
    Inc(StackCount);
    Stack[StackCount] := AY;
    Inc(StackCount);
  end;

  procedure Pop(var AX, AY: integer); inline;
  begin
    Dec(StackCount);
    AY := Stack[StackCount];
    Dec(StackCount);
    AX := Stack[StackCount];
  end;

begin
  if (X >= 0) and (X < Width) and (Y >= 0) and (Y < Height) then
  begin
    S := GetPixel(X, Y);

    VisitedLineSize := (Width + 31) shr 5;
    SetLength(Visited, VisitedLineSize * Height);
    FillDWord(Visited[0], Length(Visited), 0);

    SetLength(Stack, 2);
    StackCount := 0;

    Push(X, Y);
    repeat
      Pop(X, Y);
      if not CheckPixel(X, Y) then
        Continue;

      SX := X;
      while (SX > 0) and CheckPixel(Pred(SX), Y) do
        Dec(SX);
      EX := X;
      while (EX < Pred(Width)) and CheckPixel(Succ(EX), Y) do
        Inc(EX);

      SetVisited(SX, Y, EX);
      if mode = fmSet then
        dest.SetHorizLine(SX, Y, EX, Color)
      else
      if mode = fmDrawWithTransparency then
        dest.DrawHorizLine(SX, Y, EX, Color)
      else
        dest.DrawHorizLineDiff(SX, Y, EX, Color, S, Tolerance);

      Added := False;
      if Y > 0 then
        for I := SX to EX do
          if CheckPixel(I, Pred(Y)) then
          begin
            if Added then
              Continue;
            Push(I, Pred(Y));
            Added := True;
          end
          else
            Added := False;

      Added := False;
      if Y < Pred(Height) then
        for I := SX to EX do
          if CheckPixel(I, Succ(Y)) then
          begin
            if Added then
              Continue;
            Push(I, Succ(Y));
            Added := True;
          end
          else
            Added := False;
    until StackCount <= 0;
  end;
end;

procedure TBGRADefaultBitmap.GradientFill(x, y, x2, y2: integer;
  c1, c2: TBGRAPixel; gtype: TGradientType; o1, o2: TPointF; mode: TDrawMode;
  gammaColorCorrection: boolean = True; Sinus: Boolean=False);
var
  u, p:   TPointF;
  len, a: single;
  xb, yb, temp: integer;
  b:      integer;
  c:      TBGRAPixel;
  ec, ec1, ec2: TExpandedPixel;
  pixelProc: procedure(x, y: integer; col: TBGRAPixel) of object;
begin
  if (x > x2) then
  begin
    temp := x;
    x    := x2;
    x2   := temp;
  end;
  if (y > y2) then
  begin
    temp := y;
    y    := y2;
    y2   := temp;
  end;
  if x < 0 then x := 0;
  if x2 > width then x2 := width;
  if y < 0 then y := 0;
  if y2 > height then y2 := height;
  if (x2 <= x) or (y2 <= y) then exit;

  case mode of
    dmSet, dmSetExceptTransparent: pixelProc := @SetPixel;
    dmDrawWithTransparency: pixelProc := @DrawPixel;
    dmFastBlend: pixelProc := @FastBlendPixel;
  end;
  //handles transparency
  if (c1.alpha = 0) and (c2.alpha = 0) then
  begin
    FillRect(x, y, x2, y2, BGRAPixelTransparent, mode);
    exit;
  end;
  if c1.alpha = 0 then
  begin
    c1.red   := c2.red;
    c1.green := c2.green;
    c1.blue  := c2.blue;
  end
  else
  if c2.alpha = 0 then
  begin
    c2.red   := c1.red;
    c2.green := c1.green;
    c2.blue  := c1.blue;
  end;

  //compute vector
  u.x := o2.x - o1.x;
  u.y := o2.y - o1.y;
  len := sqrt(sqr(u.x) + sqr(u.y));
  if len = 0 then
  begin
    FillRect(x, y, x2, y2, MergeBGRA(c1, c2), mode);
    exit;
  end;
  u.x /= len;
  u.y /= len;

  ec1 := GammaExpansion(c1);
  ec2 := GammaExpansion(c2);
  if gammaColorCorrection then
  begin
    //render with gamma correction
    case gtype of
      gtLinear:
        for yb := y to y2 - 1 do
          for xb := x to x2 - 1 do
          begin
            p.x := xb - o1.x;
            p.y := yb - o1.y;
            a   := p.x * u.x + p.y * u.y;
            if Sinus then a := (sin(a*2*Pi/len)+1)*len/2;
            if a < 0 then
              c := c1
            else
            if a > len then
              c := c2
            else
            begin
              b      := round(a / len * 256);
              ec.red := (ec1.red * (256 - b) + ec2.red * b + 127) shr 8;
              ec.green := (ec1.green * (256 - b) + ec2.green * b + 127) shr 8;
              ec.blue := (ec1.blue * (256 - b) + ec2.blue * b + 127) shr 8;
              ec.alpha := (ec1.alpha * (256 - b) + ec2.alpha * b + 127) shr 8;
              c      := GammaCompression(ec);
            end;
            pixelProc(xb, yb, c);
          end;

      gtReflected:
        for yb := y to y2 - 1 do
          for xb := x to x2 - 1 do
          begin
            p.x := xb - o1.x;
            p.y := yb - o1.y;
            a   := abs(p.x * u.x + p.y * u.y);
            if Sinus then a := (sin(a*2*Pi/len)+1)*len/2;
            if a < 0 then
              c := c1
            else
            if a > len then
              c := c2
            else
            begin
              b      := round(a / len * 256);
              ec.red := (ec1.red * (256 - b) + ec2.red * b + 127) shr 8;
              ec.green := (ec1.green * (256 - b) + ec2.green * b + 127) shr 8;
              ec.blue := (ec1.blue * (256 - b) + ec2.blue * b + 127) shr 8;
              ec.alpha := (ec1.alpha * (256 - b) + ec2.alpha * b + 127) shr 8;
              c      := GammaCompression(ec);
            end;
            pixelProc(xb, yb, c);
          end;

      gtDiamond:
        for yb := y to y2 - 1 do
          for xb := x to x2 - 1 do
          begin
            p.x := xb - o1.x;
            p.y := yb - o1.y;
            a   := max(abs(p.x * u.x + p.y * u.y), abs(p.x * u.y - p.y * u.x));
            if Sinus then a := (sin(a*2*Pi/len)+1)*len/2;
            if a < 0 then
              c := c1
            else
            if a > len then
              c := c2
            else
            begin
              b      := round(a / len * 256);
              ec.red := (ec1.red * (256 - b) + ec2.red * b + 127) shr 8;
              ec.green := (ec1.green * (256 - b) + ec2.green * b + 127) shr 8;
              ec.blue := (ec1.blue * (256 - b) + ec2.blue * b + 127) shr 8;
              ec.alpha := (ec1.alpha * (256 - b) + ec2.alpha * b + 127) shr 8;
              c      := GammaCompression(ec);
            end;
            pixelProc(xb, yb, c);
          end;

      gtRadial:
        for yb := y to y2 - 1 do
          for xb := x to x2 - 1 do
          begin
            p.x := xb - o1.x;
            p.y := yb - o1.y;
            a   := sqrt(sqr(p.x * u.x + p.y * u.y) + sqr(p.x * u.y - p.y * u.x));
            if Sinus then a := (sin(a*2*Pi/len)+1)*len/2;
            if a < 0 then
              c := c1
            else
            if a > len then
              c := c2
            else
            begin
              b      := round(a / len * 256);
              ec.red := (ec1.red * (256 - b) + ec2.red * b + 127) shr 8;
              ec.green := (ec1.green * (256 - b) + ec2.green * b + 127) shr 8;
              ec.blue := (ec1.blue * (256 - b) + ec2.blue * b + 127) shr 8;
              ec.alpha := (ec1.alpha * (256 - b) + ec2.alpha * b + 127) shr 8;
              c      := GammaCompression(ec);
            end;
            pixelProc(xb, yb, c);
          end;
    end;
  end
  else
  begin
    //render without gamma correction
    case gtype of
      gtLinear:
        for yb := y to y2 - 1 do
          for xb := x to x2 - 1 do
          begin
            p.x := xb - o1.x;
            p.y := yb - o1.y;
            a   := p.x * u.x + p.y * u.y;
            if Sinus then a := (sin(a*2*Pi/len)+1)*len/2;
            if a < 0 then
              c := c1
            else
            if a > len then
              c := c2
            else
            begin
              b      := round(a / len * 256);
              c.red  := (c1.red * (256 - b) + c2.red * b + 127) shr 8;
              c.green := (c1.green * (256 - b) + c2.green * b + 127) shr 8;
              c.blue := (c1.blue * (256 - b) + c2.blue * b + 127) shr 8;
              c.alpha := (c1.alpha * (256 - b) + c2.alpha * b + 127) shr 8;
            end;
            pixelProc(xb, yb, c);
          end;

      gtReflected:
        for yb := y to y2 - 1 do
          for xb := x to x2 - 1 do
          begin
            p.x := xb - o1.x;
            p.y := yb - o1.y;
            a   := abs(p.x * u.x + p.y * u.y);
            if Sinus then a := (sin(a*2*Pi/len)+1)*len/2;
            if a < 0 then
              c := c1
            else
            if a > len then
              c := c2
            else
            begin
              b      := round(a / len * 256);
              c.red  := (c1.red * (256 - b) + c2.red * b + 127) shr 8;
              c.green := (c1.green * (256 - b) + c2.green * b + 127) shr 8;
              c.blue := (c1.blue * (256 - b) + c2.blue * b + 127) shr 8;
              c.alpha := (c1.alpha * (256 - b) + c2.alpha * b + 127) shr 8;
            end;
            pixelProc(xb, yb, c);
          end;

      gtDiamond:
        for yb := y to y2 - 1 do
          for xb := x to x2 - 1 do
          begin
            p.x := xb - o1.x;
            p.y := yb - o1.y;
            a   := max(abs(p.x * u.x + p.y * u.y), abs(p.x * u.y - p.y * u.x));
            if Sinus then a := (sin(a*2*Pi/len)+1)*len/2;
            if a < 0 then
              c := c1
            else
            if a > len then
              c := c2
            else
            begin
              b      := round(a / len * 256);
              c.red  := (c1.red * (256 - b) + c2.red * b + 127) shr 8;
              c.green := (c1.green * (256 - b) + c2.green * b + 127) shr 8;
              c.blue := (c1.blue * (256 - b) + c2.blue * b + 127) shr 8;
              c.alpha := (c1.alpha * (256 - b) + c2.alpha * b + 127) shr 8;
            end;
            pixelProc(xb, yb, c);
          end;

      gtRadial:
        for yb := y to y2 - 1 do
          for xb := x to x2 - 1 do
          begin
            p.x := xb - o1.x;
            p.y := yb - o1.y;
            a   := sqrt(sqr(p.x * u.x + p.y * u.y) + sqr(p.x * u.y - p.y * u.x));
            if Sinus then a := (sin(a*2*Pi/len)+1)*len/2;
            if a < 0 then
              c := c1
            else
            if a > len then
              c := c2
            else
            begin
              b      := round(a / len * 256);
              c.red  := (c1.red * (256 - b) + c2.red * b + 127) shr 8;
              c.green := (c1.green * (256 - b) + c2.green * b + 127) shr 8;
              c.blue := (c1.blue * (256 - b) + c2.blue * b + 127) shr 8;
              c.alpha := (c1.alpha * (256 - b) + c2.alpha * b + 127) shr 8;
            end;
            pixelProc(xb, yb, c);
          end;
    end;
  end;
end;

procedure TBGRADefaultBitmap.DrawPixels(c: TBGRAPixel; start, Count: integer);
var
  p: PBGRAPixel;
begin
  if c.alpha = 0 then
    exit;

  if start < 0 then
  begin
    Count += start;
    start := 0;
  end;
  if start >= nbPixels then
    exit;
  if start + Count > nbPixels then
    Count := nbPixels - start;

  p := Data + start;
  while Count > 0 do
  begin
    DrawPixelInline(p, c);
    Inc(p);
    Dec(Count);
  end;
  InvalidateBitmap;
end;

{------------------------- End fill ------------------------------}

procedure TBGRADefaultBitmap.DoAlphaCorrection;
var
  p: PBGRAPixel;
  n: integer;
begin
  if CanvasAlphaCorrection then
  begin
    p := FData;
    for n := NbPixels - 1 downto 0 do
    begin
      if (longword(p^) and $FFFFFF <> 0) and (p^.alpha = 0) then
        p^.alpha := FCanvasOpacity;
      Inc(p);
    end;
  end;
  FAlphaCorrectionNeeded := False;
  InvalidateBitmap;
end;

procedure TBGRADefaultBitmap.ClearTransparentPixels;
var
  p: PBGRAPixel;
  n: integer;
begin
  p := FData;
  for n := NbPixels - 1 downto 0 do
  begin
    if (p^.alpha = 0) then
      p^ := BGRAPixelTransparent;
    Inc(p);
  end;
  InvalidateBitmap;
end;

procedure TBGRADefaultBitmap.PutImage(x, y: integer; Source: TBGRADefaultBitmap;
  mode: TDrawMode);
var
  x2, y2, yb, minxb, minyb, maxxb, ignoreleft, copycount, sourcewidth,
  i, delta_source, delta_dest: integer;
  psource, pdest: PBGRAPixel;
begin
  sourcewidth := Source.Width;

  if (x >= Width) or (y >= Height) or (x <= -sourcewidth) or
    (y <= -Source.Height) or (Height = 0) or (Source.Height = 0) then
    exit;

  x2 := x + sourcewidth - 1;
  y2 := y + Source.Height - 1;

  if y < 0 then
    minyb := 0
  else
    minyb := y;
  if y2 >= Height then
    y2 := Height - 1;

  if x < 0 then
  begin
    ignoreleft := -x;
    minxb      := 0;
  end
  else
  begin
    ignoreleft := 0;
    minxb      := x;
  end;
  if x2 >= Width then
    maxxb := Width - 1
  else
    maxxb := x2;

  copycount := maxxb - minxb + 1;

  psource := Source.ScanLine[minyb - y] + ignoreleft;
  if Source.FLineOrder = riloBottomToTop then
    delta_source := -sourcewidth
  else
    delta_source := sourcewidth;

  pdest := Scanline[minyb] + minxb;
  if FLineOrder = riloBottomToTop then
    delta_dest := -Width
  else
    delta_dest := Width;

  case mode of
    dmSet:
    begin
      copycount *= sizeof(TBGRAPixel);
      for yb := minyb to y2 do
      begin
        move(psource^, pdest^, copycount);
        Inc(psource, delta_source);
        Inc(pdest, delta_dest);
      end;
      InvalidateBitmap;
    end;
    dmSetExceptTransparent:
    begin
      Dec(delta_source, copycount);
      Dec(delta_dest, copycount);
      for yb := minyb to y2 do
      begin
        for i := copycount - 1 downto 0 do
        begin
          if psource^.alpha = 255 then
            pdest^ := psource^;
          Inc(pdest);
          Inc(psource);
        end;
        Inc(psource, delta_source);
        Inc(pdest, delta_dest);
      end;
      InvalidateBitmap;
    end;
    dmDrawWithTransparency:
    begin
      Dec(delta_source, copycount);
      Dec(delta_dest, copycount);
      for yb := minyb to y2 do
      begin
        for i := copycount - 1 downto 0 do
        begin
          DrawPixelInline(pdest, psource^);
          Inc(pdest);
          Inc(psource);
        end;
        Inc(psource, delta_source);
        Inc(pdest, delta_dest);
      end;
      InvalidateBitmap;
    end;
    dmFastBlend:
    begin
      Dec(delta_source, copycount);
      Dec(delta_dest, copycount);
      for yb := minyb to y2 do
      begin
        for i := copycount - 1 downto 0 do
        begin
          FastBlendPixelInline(pdest, psource^);
          Inc(pdest);
          Inc(psource);
        end;
        Inc(psource, delta_source);
        Inc(pdest, delta_dest);
      end;
      InvalidateBitmap;
    end;
  end;
end;

procedure TBGRADefaultBitmap.BlendImage(x, y: integer; Source: TBGRADefaultBitmap;
  operation: TBlendOperation);
var
  x2, y2, yb, minxb, minyb, maxxb, ignoreleft, copycount, sourcewidth,
  delta_source, delta_dest: integer;
  psource, pdest: PBGRAPixel;
begin
  sourcewidth := Source.Width;

  if (x >= Width) or (y >= Height) or (x <= -sourcewidth) or
    (y <= -Source.Height) or (Height = 0) or (Source.Height = 0) then
    exit;

  x2 := x + sourcewidth - 1;
  y2 := y + Source.Height - 1;

  if y < 0 then
    minyb := 0
  else
    minyb := y;
  if y2 >= Height then
    y2 := Height - 1;

  if x < 0 then
  begin
    ignoreleft := -x;
    minxb      := 0;
  end
  else
  begin
    ignoreleft := 0;
    minxb      := x;
  end;
  if x2 >= Width then
    maxxb := Width - 1
  else
    maxxb := x2;

  copycount := maxxb - minxb + 1;

  psource := Source.ScanLine[minyb - y] + ignoreleft;
  if Source.FLineOrder = riloBottomToTop then
    delta_source := -sourcewidth
  else
    delta_source := sourcewidth;

  pdest := Scanline[minyb] + minxb;
  if FLineOrder = riloBottomToTop then
    delta_dest := -Width
  else
    delta_dest := Width;

  for yb := minyb to y2 do
  begin
    BlendPixels(pdest, psource, operation, copycount);
    Inc(psource, delta_source);
    Inc(pdest, delta_dest);
  end;
  InvalidateBitmap;
end;

function TBGRADefaultBitmap.Duplicate: TBGRADefaultBitmap;
begin
  LoadFromBitmapIfNeeded;
  Result := NewBitmap(Width, Height);
  Result.PutImage(0, 0, self, dmSet);
  Result.Caption := self.Caption;
end;

function TBGRADefaultBitmap.Equals(comp: TBGRADefaultBitmap): boolean;
var
  yb, xb: integer;
  pself, pcomp: PBGRAPixel;
begin
  if comp = nil then
    Result := False
  else
  if (comp.Width <> Width) or (comp.Height <> Height) then
    Result := False
  else
  begin
    Result := True;
    for yb := 0 to Height - 1 do
    begin
      pself := ScanLine[yb];
      pcomp := comp.Scanline[yb];
      for xb := 0 to Width - 1 do
      begin
        if pself^ <> pcomp^ then
        begin
          Result := False;
          exit;
        end;
        Inc(pself);
        Inc(pcomp);
      end;
    end;
  end;
end;

function TBGRADefaultBitmap.Equals(comp: TBGRAPixel): boolean;
var
  i: integer;
  p: PBGRAPixel;
begin
  p := Data;
  for i := NbPixels - 1 downto 0 do
  begin
    if p^ <> comp then
    begin
      Result := False;
      exit;
    end;
    Inc(p);
  end;
  Result := True;
end;

function TBGRADefaultBitmap.FilterSmartZoom3(Option: TMedianOption): TBGRADefaultBitmap;
begin
  Result := BGRAFilters.FilterSmartZoom3(self, Option);
end;

function TBGRADefaultBitmap.FilterMedian(Option: TMedianOption): TBGRADefaultBitmap;
begin
  Result := BGRAFilters.FilterMedian(self, option);
end;

function TBGRADefaultBitmap.FilterSmooth: TBGRADefaultBitmap;
begin
  Result := BGRAFilters.FilterBlurRadialPrecise(self, 0.3);
end;

function TBGRADefaultBitmap.FilterSphere: TBGRADefaultBitmap;
begin
  Result := BGRAFilters.FilterSphere(self);
end;

function TBGRADefaultBitmap.FilterCylinder: TBGRADefaultBitmap;
begin
  Result := BGRAFilters.FilterCylinder(self);
end;

function TBGRADefaultBitmap.FilterPlane: TBGRADefaultBitmap;
begin
  Result := BGRAFilters.FilterPlane(self);
end;

function TBGRADefaultBitmap.FilterSharpen: TBGRADefaultBitmap;
begin
  Result := BGRAFilters.FilterSharpen(self);
end;

function TBGRADefaultBitmap.FilterContour: TBGRADefaultBitmap;
begin
  Result := BGRAFilters.FilterContour(self);
end;

function TBGRADefaultBitmap.FilterBlurRadial(radius: integer;
  blurType: TRadialBlurType): TBGRADefaultBitmap;
begin
  Result := BGRAFilters.FilterBlurRadial(self, radius, blurType);
end;

function TBGRADefaultBitmap.FilterBlurMotion(distance: integer;
  angle: single; oriented: boolean): TBGRADefaultBitmap;
begin
  Result := BGRAFilters.FilterBlurMotion(self, distance, angle, oriented);
end;

function TBGRADefaultBitmap.FilterCustomBlur(mask: TBGRADefaultBitmap):
TBGRADefaultBitmap;
begin
  Result := BGRAFilters.FilterBlur(self, mask);
end;

function TBGRADefaultBitmap.FilterEmboss(angle: single): TBGRADefaultBitmap;
begin
  Result := BGRAFilters.FilterEmboss(self, angle);
end;

function TBGRADefaultBitmap.FilterEmbossHighlight(FillSelection: boolean):
TBGRADefaultBitmap;
begin
  Result := BGRAFilters.FilterEmbossHighlight(self, FillSelection);
end;

function TBGRADefaultBitmap.FilterGrayscale: TBGRADefaultBitmap;
begin
  Result := BGRAFilters.FilterGrayscale(self);
end;

function TBGRADefaultBitmap.FilterNormalize(eachChannel: boolean = True):
TBGRADefaultBitmap;
begin
  Result := BGRAFilters.FilterNormalize(self, eachChannel);
end;

function TBGRADefaultBitmap.FilterRotate(origin: TPointF;
  angle: single): TBGRADefaultBitmap;
begin
  Result := BGRAFilters.FilterRotate(self, origin, angle);
end;

function TBGRADefaultBitmap.GetHasTransparentPixels: boolean;
var
  p: PBGRAPixel;
  n: integer;
begin
  p := Data;
  for n := NbPixels - 1 downto 0 do
  begin
    if p^.alpha <> 255 then
    begin
      Result := True;
      exit;
    end;
    Inc(p);
  end;
  Result := False;
end;

function TBGRADefaultBitmap.GetAverageColor: TColor;
var
  pix: TBGRAPixel;
begin
  pix := GetAveragePixel;
  {$hints off}
  if pix.alpha = 0 then
    result := clNone else
     result := pix.red + pix.green shl 8 + pix.blue shl 16;
  {$hints on}
end;

function TBGRADefaultBitmap.GetAveragePixel: TBGRAPixel;
var
  n:     integer;
  p:     PBGRAPixel;
  r, g, b, sum: double;
  alpha: double;
begin
  sum := 0;
  r   := 0;
  g   := 0;
  b   := 0;
  p   := Data;
  for n := NbPixels - 1 downto 0 do
  begin
    alpha := p^.alpha / 255;
    sum   += alpha;
    r     += p^.red * alpha;
    g     += p^.green * alpha;
    b     += p^.blue * alpha;
    Inc(p);
  end;
  if sum = 0 then
    Result := BGRAPixelTransparent
  else
    Result := BGRA(round(r / sum),round(g / sum),round(b / sum),round(sum*255/NbPixels));
end;

procedure TBGRADefaultBitmap.SetCanvasOpacity(AValue: byte);
begin
  LoadFromBitmapIfNeeded;
  FCanvasOpacity := AValue;
end;

function TBGRADefaultBitmap.GetDataPtr: PBGRAPixel;
begin
  LoadFromBitmapIfNeeded;
  Result := FData;
end;

{----------------------------- Resample ---------------------------------------}

function TBGRADefaultBitmap.FineResample(NewWidth, NewHeight: integer):
TBGRADefaultBitmap;
begin
  Result := BGRAResample.FineResample(self, NewWidth, NewHeight);
end;

function TBGRADefaultBitmap.SimpleStretch(NewWidth, NewHeight: integer):
TBGRADefaultBitmap;
begin
  Result := BGRAResample.SimpleStretch(self, NewWidth, NewHeight);
end;

function TBGRADefaultBitmap.Resample(newWidth, newHeight: integer;
  mode: TResampleMode): TBGRADefaultBitmap;
begin
  case mode of
    rmFineResample: Result  := FineResample(newWidth, newHeight);
    rmSimpleStretch: Result := SimpleStretch(newWidth, newHeight);
    else
      Result := nil;
  end;
end;

{-------------------------------- Data functions ------------------------}

procedure TBGRADefaultBitmap.VerticalFlip;
var
  yb:     integer;
  line:   PBGRAPixel;
  linesize: integer;
  PStart: PBGRAPixel;
  PEnd:   PBGRAPixel;
begin
  if FData = nil then
    exit;

  linesize := Width * sizeof(TBGRAPixel);
  line     := nil;
  getmem(line, linesize);
  PStart := Data;
  PEnd   := Data + (Height - 1) * Width;
  for yb := 0 to (Height div 2) - 1 do
  begin
    move(PStart^, line^, linesize);
    move(PEnd^, PStart^, linesize);
    move(line^, PEnd^, linesize);
    Inc(PStart, Width);
    Dec(PEnd, Width);
  end;
  freemem(line);
  InvalidateBitmap;
end;

procedure TBGRADefaultBitmap.HorizontalFlip;
var
  yb, xb: integer;
  PStart: PBGRAPixel;
  PEnd:   PBGRAPixel;
  temp:   TBGRAPixel;
begin
  if FData = nil then
    exit;

  for yb := 0 to Height - 1 do
  begin
    PStart := Scanline[yb];
    PEnd   := PStart + Width;
    for xb := 0 to (Width div 2) - 1 do
    begin
      Dec(PEnd);
      temp    := PStart^;
      PStart^ := PEnd^;
      PEnd^   := temp;
      Inc(PStart);
    end;
  end;
  InvalidateBitmap;
end;

function TBGRADefaultBitmap.RotateCW: TBGRADefaultBitmap;
var
  psrc, pdest: PBGRAPixel;
  yb, xb: integer;
  delta: integer;
begin
  Result := NewBitmap(Height, Width);
  if Result.LineOrder = riloTopToBottom then
    delta := Result.Width
  else
    delta := -Result.Width;
  for yb := 0 to Height - 1 do
  begin
    psrc  := Scanline[yb];
    pdest := Result.Scanline[0] + (Height - 1 - yb);
    for xb := 0 to Width - 1 do
    begin
      pdest^ := psrc^;
      Inc(psrc);
      Inc(pdest, delta);
    end;
  end;
end;

function TBGRADefaultBitmap.RotateCCW: TBGRADefaultBitmap;
var
  psrc, pdest: PBGRAPixel;
  yb, xb: integer;
  delta: integer;
begin
  Result := NewBitmap(Height, Width);
  if Result.LineOrder = riloTopToBottom then
    delta := Result.Width
  else
    delta := -Result.Width;
  for yb := 0 to Height - 1 do
  begin
    psrc  := Scanline[yb];
    pdest := Result.Scanline[Width - 1] + yb;
    for xb := 0 to Width - 1 do
    begin
      pdest^ := psrc^;
      Inc(psrc);
      Dec(pdest, delta);
    end;
  end;
end;

procedure TBGRADefaultBitmap.Negative;
var
  p: PBGRAPixel;
  n: integer;
begin
  p := Data;
  for n := NbPixels - 1 downto 0 do
  begin
    if p^.alpha <> 0 then
    begin
      p^.red   := GammaCompressionTab[not GammaExpansionTab[p^.red]];
      p^.green := GammaCompressionTab[not GammaExpansionTab[p^.green]];
      p^.blue  := GammaCompressionTab[not GammaExpansionTab[p^.blue]];
    end;
    Inc(p);
  end;
  InvalidateBitmap;
end;

procedure TBGRADefaultBitmap.LinearNegative;
var
  p: PBGRAPixel;
  n: integer;
begin
  p := Data;
  for n := NbPixels - 1 downto 0 do
  begin
    if p^.alpha <> 0 then
    begin
      p^.red   := not p^.red;
      p^.green := not p^.green;
      p^.blue  := not p^.blue;
    end;
    Inc(p);
  end;
  InvalidateBitmap;
end;

procedure TBGRADefaultBitmap.SwapRedBlue;
var
  n:    integer;
  temp: longword;
  p:    PLongword;
begin
  p := PLongword(Data);
  n := NbPixels;
  if n = 0 then
    exit;
  repeat
    temp := p^;
    p^   := ((temp and $FF) shl 16) or ((temp and $FF0000) shr 16) or
      temp and $FF00FF00;
    Inc(p);
    Dec(n);
  until n = 0;
  InvalidateBitmap;
end;

procedure TBGRADefaultBitmap.GrayscaleToAlpha;
var
  n:    integer;
  temp: longword;
  p:    PLongword;
begin
  p := PLongword(Data);
  n := NbPixels;
  if n = 0 then
    exit;
  repeat
    temp := p^;
    p^   := (temp and $FF) shl 24;
    Inc(p);
    Dec(n);
  until n = 0;
  InvalidateBitmap;
end;

procedure TBGRADefaultBitmap.AlphaToGrayscale;
var
  n:    integer;
  temp: longword;
  p:    PLongword;
begin
  p := PLongword(Data);
  n := NbPixels;
  if n = 0 then
    exit;
  repeat
    temp := p^ shr 24;
    p^   := temp or (temp shl 8) or (temp shl 16) or $FF000000;
    Inc(p);
    Dec(n);
  until n = 0;
  InvalidateBitmap;
end;

procedure TBGRADefaultBitmap.ApplyMask(mask: TBGRADefaultBitmap);
var
  p, pmask: PBGRAPixel;
  yb, xb:   integer;
begin
  if (Mask.Width <> Width) or (Mask.Height <> Height) then
    exit;

  for yb := 0 to Height - 1 do
  begin
    p     := Scanline[yb];
    pmask := Mask.Scanline[yb];
    for xb := Width - 1 downto 0 do
    begin
      p^.alpha := (p^.alpha * pmask^.red + 128) div 255;
      Inc(p);
      Inc(pmask);
    end;
  end;
  InvalidateBitmap;
end;

function TBGRADefaultBitmap.GetImageBounds(Channel: TChannel = cAlpha): TRect;
var
  minx, miny, maxx, maxy: integer;
  xb, yb: integer;
  p:      pbyte;
  offset: integer;
begin
  maxx := -1;
  maxy := -1;
  minx := self.Width;
  miny := self.Height;
  case Channel of
    cBlue: offset  := 0;
    cGreen: offset := 1;
    cRed: offset   := 2;
    else
      offset := 3;
  end;
  for yb := 0 to self.Height - 1 do
  begin
    p := PByte(self.ScanLine[yb]) + offset;
    for xb := 0 to self.Width - 1 do
    begin
      if p^ <> 0 then
      begin
        if xb < minx then
          minx := xb;
        if yb < miny then
          miny := yb;
        if xb > maxx then
          maxx := xb;
        if yb > maxy then
          maxy := yb;
      end;
      Inc(p, sizeof(TBGRAPixel));
    end;
  end;
  if minx > maxx then
  begin
    Result.left   := 0;
    Result.top    := 0;
    Result.right  := 0;
    Result.bottom := 0;
  end
  else
  begin
    Result.left   := minx;
    Result.top    := miny;
    Result.right  := maxx + 1;
    Result.bottom := maxy + 1;
  end;
end;

function TBGRADefaultBitmap.MakeBitmapCopy(BackgroundColor: TColor): TBitmap;
var
  opaqueCopy: TBGRADefaultBitmap;
begin
  Result     := TBitmap.Create;
  Result.Width := Width;
  Result.Height := Height;
  opaqueCopy := NewBitmap(Width, Height);
  opaqueCopy.Fill(BackgroundColor);
  opaqueCopy.PutImage(0, 0, self, dmDrawWithTransparency);
  opaqueCopy.Draw(Result.canvas, 0, 0, True);
  opaqueCopy.Free;
end;

procedure TBGRADefaultBitmap.DrawPart(Arect: TRect; Canvas: TCanvas;
  x, y: integer; Opaque: boolean);
var
  partial: TBGRADefaultBitmap;
begin
  partial := GetPart(ARect);
  if partial <> nil then
  begin
    partial.Draw(Canvas, x, y, Opaque);
    partial.Free;
  end;
end;

function TBGRADefaultBitmap.GetPart(ARect: TRect): TBGRADefaultBitmap;
var
  copywidth, copyheight, widthleft, heightleft, curxin, curyin, xdest,
  ydest, tx, ty: integer;
begin
  tx := ARect.Right - ARect.Left;
  ty := ARect.Bottom - ARect.Top;

  if (tx <= 0) or (ty <= 0) then
  begin
    result := nil;
    exit;
  end;

  LoadFromBitmapIfNeeded;
  if ARect.Left >= Width then
    ARect.Left := ARect.Left mod Width
  else
  if ARect.Left < 0 then
    ARect.Left := Width - ((-ARect.Left) mod Width);
  ARect.Right  := ARect.Left + tx;

  if ARect.Top >= Height then
    ARect.Top := ARect.Top mod Height
  else
  if ARect.Top < 0 then
    ARect.Top  := Height - ((-ARect.Top) mod Height);
  ARect.Bottom := ARect.Top + ty;

  if (ARect.Left = 0) and (ARect.Top = 0) and
     (ARect.Right = Width) and
    (ARect.Bottom = Height) then
  begin
    result := Duplicate;
    exit;
  end;

  result     := NewBitmap(tx, ty);
  heightleft := result.Height;
  curyin     := ARect.Top;
  ydest      := -ARect.Top;
  while heightleft > 0 do
  begin
    if curyin + heightleft > Height then
      copyheight := Height - curyin
    else
      copyheight := heightleft;

    widthleft := result.Width;
    curxin    := ARect.Left;
    xdest     := -ARect.Left;
    while widthleft > 0 do
    begin
      if curxin + widthleft > Width then
        copywidth := Width - curxin
      else
        copywidth := widthleft;

      result.PutImage(xdest, ydest, self, dmSet);

      curxin := 0;
      Dec(widthleft, copywidth);
      Inc(xdest, Width);
    end;
    curyin := 0;
    Dec(heightleft, copyheight);
    Inc(ydest, Height);
  end;
end;

procedure TBGRADefaultBitmap.DataDrawTransparent(ACanvas: TCanvas;
  Rect: TRect; AData: Pointer; ALineOrder: TRawImageLineOrder; AWidth, AHeight: integer);
var
  Temp:     TBitmap;
  RawImage: TRawImage;
  BitmapHandle, MaskHandle: HBitmap;
begin
  RawImage.Init;
  RawImage.Description.Init_BPP32_B8G8R8A8_BIO_TTB(AWidth, AHeight);
  RawImage.Description.LineOrder := ALineOrder;
  RawImage.Data     := PByte(AData);
  RawImage.DataSize := AWidth * AHeight * sizeof(TBGRAPixel);
  if not RawImage_CreateBitmaps(RawImage, BitmapHandle, MaskHandle, False) then
    raise FPImageException.Create('Failed to create bitmap handle');
  Temp := TBitmap.Create;
  Temp.Handle := BitmapHandle;
  Temp.MaskHandle := MaskHandle;
  ACanvas.StretchDraw(Rect, Temp);
  Temp.Free;
end;

procedure TBGRADefaultBitmap.DataDrawOpaque(ACanvas: TCanvas;
  Rect: TRect; AData: Pointer; ALineOrder: TRawImageLineOrder; AWidth, AHeight: integer);
var
  Temp:      TBitmap;
  RawImage:  TRawImage;
  BitmapHandle, MaskHandle: HBitmap;
  TempData:  Pointer;
  x, y:      integer;
  PTempData: PByte;
  PSource:   PByte;
  ADataSize: integer;
  ALineEndMargin: integer;
  CreateResult: boolean;
{$IFDEF DARWIN}
  TempShift: byte;
{$ENDIF}
begin
  if (AHeight = 0) or (AWidth = 0) then
    exit;

  ALineEndMargin := (4 - ((AWidth * 3) and 3)) and 3;
  ADataSize      := (AWidth * 3 + ALineEndMargin) * AHeight;

     {$HINTS OFF}
  GetMem(TempData, ADataSize);
     {$HINTS ON}
  PTempData := TempData;
  PSource   := AData;
     {$IFDEF DARWIN}
  SwapRedBlue; //swap red and blue values
     {$ENDIF}
  for y := 0 to AHeight - 1 do
  begin
    for x := 0 to AWidth - 1 do
    begin
      PWord(PTempData)^ := PWord(PSource)^;
      Inc(PTempData, 2);
      Inc(PSource, 2);
      PTempData^ := PSource^;
      Inc(PTempData);
      Inc(PSource, 2);
    end;
    Inc(PTempData, ALineEndMargin);
  end;
     {$IFDEF DARWIN}
  SwapRedBlue; //swap red and blue values
     {$ENDIF}

  RawImage.Init;
  RawImage.Description.Init_BPP24_B8G8R8_BIO_TTB(AWidth, AHeight);
     {$IFDEF DARWIN}
  //swap red and blue positions
  TempShift := RawImage.Description.RedShift;
  RawImage.Description.RedShift := RawImage.Description.BlueShift;
  RawImage.Description.BlueShift := TempShift;
     {$ENDIF}
  RawImage.Description.LineOrder := ALineOrder;
  RawImage.Description.LineEnd := rileDWordBoundary;
  if integer(RawImage.Description.BytesPerLine) <> AWidth * 3 + ALineEndMargin then
  begin
    FreeMem(TempData);
    raise FPImageException.Create('Line size is inconsistant');
  end;
  RawImage.Data     := PByte(TempData);
  RawImage.DataSize := ADataSize;

  CreateResult := RawImage_CreateBitmaps(RawImage, BitmapHandle, MaskHandle, False);
  FreeMem(TempData);

  if not CreateResult then
    raise FPImageException.Create('Failed to create bitmap handle');

  Temp := TBitmap.Create;
  Temp.Handle := BitmapHandle;
  Temp.MaskHandle := MaskHandle;
  ACanvas.StretchDraw(Rect, Temp);
  Temp.Free;
end;

{-------------------------- Allocation routines -------------------------------}

procedure TBGRADefaultBitmap.ReallocData;
begin
  FreeBitmap;
  ReAllocMem(FData, NbPixels * sizeof(TBGRAPixel));
  if (NbPixels > 0) and (FData = nil) then
    raise EOutOfMemory.Create('TBGRADefaultBitmap: Not enough memory');
  InvalidateBitmap;
end;

procedure TBGRADefaultBitmap.FreeData;
begin
  freemem(FData);
  FData := nil;
end;

procedure TBGRADefaultBitmap.RebuildBitmap;
var
  RawImage: TRawImage;
  BitmapHandle, MaskHandle: HBitmap;
begin
  if FBitmap <> nil then
    FBitmap.Free;

  FBitmap := TBitmapTracker.Create(self);

  if (FWidth > 0) and (FHeight > 0) then
  begin
    RawImage.Init;
    RawImage.Description.Init_BPP32_B8G8R8A8_BIO_TTB(FWidth, FHeight);
    RawImage.Description.LineOrder := FLineOrder;
    RawImage.Data     := PByte(FData);
    RawImage.DataSize := FWidth * FHeight * sizeof(TBGRAPixel);
    if not RawImage_CreateBitmaps(RawImage, BitmapHandle, MaskHandle, False) then
      raise FPImageException.Create('Failed to create bitmap handle');
    FBitmap.Handle     := BitmapHandle;
    FBitmap.MaskHandle := MaskHandle;
  end;

  FBitmap.Canvas.AntialiasingMode := amOff;
  FBitmapModified := False;
end;

procedure TBGRADefaultBitmap.FreeBitmap;
begin
  FreeAndNil(FBitmap);
end;

procedure TBGRADefaultBitmap.GetImageFromCanvas(CanvasSource: TCanvas; x, y: integer);
var
  bmp: TBitmap;
  subBmp: TBGRADefaultBitmap;
  subRect: TRect;
  cw,ch: integer;
begin
  DiscardBitmapChange;
  cw := CanvasSource.Width;
  ch := CanvasSource.Height;
  if (x < 0) or (y < 0) or (x+Width > cw) or
    (y+Height > ch) then
  begin
    FillTransparent;
    if (x+Width <= 0) or (y+Height <= 0) or
      (x >= cw) or (y >= ch) then
      exit;

    if (x > 0) then subRect.Left := x else subRect.Left := 0;
    if (y > 0) then subRect.Top := y else subRect.Top := 0;
    if (x+Width > cw) then subRect.Right := cw else
      subRect.Right := x+Width;
    if (y+Height > ch) then subRect.Bottom := ch else
      subRect.Bottom := y+Height;

    subBmp := NewBitmap(subRect.Right-subRect.Left,subRect.Bottom-subRect.Top);
    subBmp.GetImageFromCanvas(CanvasSource,subRect.Left,subRect.Top);
    PutImage(subRect.Left-x,subRect.Top-y,subBmp,dmSet);
    subBmp.Free;
    exit;
  end;
  bmp := TBitmap.Create;
  bmp.PixelFormat := pf24bit;
  bmp.Width := Width;
  bmp.Height := Height;
  bmp.Canvas.CopyRect(Classes.rect(0, 0, Width, Height), CanvasSource,
    Classes.rect(x, y, x + Width, y + Height));
  LoadFromRawImage(bmp.RawImage, 255, True);
  bmp.Free;
  InvalidateBitmap;
end;

{ TBGRAPtrBitmap }

procedure TBGRAPtrBitmap.ReallocData;
begin
  //nothing
end;

procedure TBGRAPtrBitmap.FreeData;
begin
  FData := nil;
end;

constructor TBGRAPtrBitmap.Create(AWidth, AHeight: integer; AData: Pointer);
begin
  inherited Create(AWidth, AHeight);
  SetDataPtr(AData);
end;

function TBGRAPtrBitmap.Duplicate: TBGRADefaultBitmap;
begin
  Result := NewBitmap(Width, Height);
  TBGRAPtrBitmap(Result).SetDataPtr(FData);
end;

procedure TBGRAPtrBitmap.SetDataPtr(AData: Pointer);
begin
  FData := AData;
end;

initialization

  with DefaultTextStyle do
  begin
    Alignment  := taLeftJustify;
    Layout     := tlTop;
    WordBreak  := True;
    SingleLine := True;
    Clipping   := True;
    ShowPrefix := False;
    Opaque     := False;
  end;

  ImageHandlers.RegisterImageWriter ('Personal Computer eXchange', 'pcx', TFPWriterPcx);
  ImageHandlers.RegisterImageReader ('Personal Computer eXchange', 'pcx', TFPReaderPcx);

  ImageHandlers.RegisterImageWriter ('X Pixmap', 'xpm', TFPWriterXPM);
  ImageHandlers.RegisterImageReader ('X Pixmap', 'xpm', TFPReaderXPM);

end.

