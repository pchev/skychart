unit BGRACanvas2D;

{ To do :

  linear gradient any transformation
  clearPath clipping
  createRadialGradient
  text functions
  globalCompositeOperation
  drawImage(in image, in double sx, in double sy, in double sw, in double sh, in double dx, in double dy, in double dw, in double dh)
  image data functions
}

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Graphics, BGRABitmapTypes, BGRATransform, BGRAGradientScanner;

type
  IBGRACanvasTextureProvider2D = interface
    function getTexture: IBGRAScanner;
    property texture: IBGRAScanner read GetTexture;
  end;

  IBGRACanvasGradient2D = interface(IBGRACanvasTextureProvider2D)
    procedure addColorStop(APosition: single; AColor: TBGRAPixel);
    procedure addColorStop(APosition: single; AColor: TColor);
    procedure addColorStop(APosition: single; AColor: string);
    procedure setColors(ACustomGradient: TBGRACustomGradient);
  end;

  { TBGRACanvasTextureProvider2D }

  TBGRACanvasTextureProvider2D = class(TInterfacedObject,IBGRACanvasTextureProvider2D)
    function getTexture: IBGRAScanner; virtual; abstract;
  end;

  { TBGRACanvasState2D }

  TBGRACanvasState2D = class
    strokeColor: TBGRAPixel;
    strokeTextureProvider: IBGRACanvasTextureProvider2D;
    fillColor: TBGRAPixel;
    fillTextureProvider: IBGRACanvasTextureProvider2D;
    globalAlpha: byte;

    lineWidth: single;
    lineCap: TPenEndCap;
    lineJoin: TPenJoinStyle;
    lineStyle: TBGRAPenStyle;
    miterLimit: single;

    shadowOffsetX,shadowOffsetY,shadowBlur: single;
    shadowColor: TBGRAPixel;

    matrix: TAffineMatrix;
    clipMask: TBGRACustomBitmap;
    constructor Create(AMatrix: TAffineMatrix; AClipMask: TBGRACustomBitmap);
    function Duplicate: TBGRACanvasState2D;
    destructor Destroy; override;
  end;

  { TBGRACanvas2D }

  TBGRACanvas2D = class
  private
    FSurface: TBGRACustomBitmap;
    StateStack: TList;
    currentState: TBGRACanvasState2D;
    FCanvasOffset: TPointF;
    FPixelCenteredCoordinates: boolean;
    FPathPoints: array of TPointF;
    FPathPointCount: integer;
    function GetGlobalAlpha: single;
    function GetHasShadow: boolean;
    function GetHeight: Integer;
    function GetLineCap: string;
    function GetlineJoin: string;
    function GetLineWidth: single;
    function GetMiterLimit: single;
    function GetPixelCenteredCoordinates: boolean;
    function GetShadowBlur: single;
    function GetShadowOffset: TPointF;
    function GetShadowOffsetX: single;
    function GetShadowOffsetY: single;
    function GetWidth: Integer;
    procedure SetGlobalAlpha(const AValue: single);
    procedure SetLineCap(const AValue: string);
    procedure SetLineJoin(const AValue: string);
    procedure FillPoly(const points: array of TPointF);
    procedure SetLineWidth(const AValue: single);
    procedure SetMiterLimit(const AValue: single);
    procedure SetPixelCenteredCoordinates(const AValue: boolean);
    procedure SetShadowBlur(const AValue: single);
    procedure SetShadowOffset(const AValue: TPointF);
    procedure SetShadowOffsetX(const AValue: single);
    procedure SetShadowOffsetY(const AValue: single);
    procedure StrokePoly(const points: array of TPointF);
    procedure DrawShadow(const points: array of TPointF);
    procedure ClearPoly(const points: array of TPointF);
    function ApplyTransform(const points: array of TPointF; matrix: TAffineMatrix): ArrayOfTPointF; overload;
    function ApplyTransform(const points: array of TPointF): ArrayOfTPointF; overload;
    function ApplyTransform(point: TPointF): TPointF; overload;
    function GetPenPos: TPointF;
    procedure AddPoint(point: TPointF);
    procedure AddPoints(const points: array of TPointF);
    procedure AddPointsRev(const points: array of TPointF);
    function ApplyGlobalAlpha(color: TBGRAPixel): TBGRAPixel;
  public
    constructor Create(ASurface: TBGRACustomBitmap);
    destructor Destroy; override;

    function toDataURL(mimeType: string = 'image/png'): string;

    procedure save;
    procedure restore;
    procedure scale(x,y: single);
    procedure rotate(angleRad: single);
    procedure translate(x,y: single);
    procedure transform(a,b,c,d,e,f: single);
    procedure setTransform(a,b,c,d,e,f: single);
    procedure resetTransform;
    procedure strokeStyle(color: TBGRAPixel); overload;
    procedure strokeStyle(color: TColor); overload;
    procedure strokeStyle(color: string); overload;
    procedure strokeStyle(texture: IBGRAScanner); overload;
    procedure strokeStyle(provider: IBGRACanvasTextureProvider2D); overload;
    procedure fillStyle(color: TBGRAPixel); overload;
    procedure fillStyle(color: TColor); overload;
    procedure fillStyle(color: string); overload;
    procedure fillStyle(texture: IBGRAScanner); overload;
    procedure fillStyle(provider: IBGRACanvasTextureProvider2D); overload;
    procedure shadowColor(color: TBGRAPixel); overload;
    procedure shadowColor(color: TColor); overload;
    procedure shadowColor(color: string); overload;
    function getShadowColor: TBGRAPixel;
    function createLinearGradient(x0,y0,x1,y1: single): IBGRACanvasGradient2D; overload;
    function createLinearGradient(p0,p1: TPointF): IBGRACanvasGradient2D; overload;
    function createLinearGradient(x0,y0,x1,y1: single; Colors: TBGRACustomGradient): IBGRACanvasGradient2D; overload;
    function createLinearGradient(p0,p1: TPointF; Colors: TBGRACustomGradient): IBGRACanvasGradient2D; overload;
    function createPattern(image: TBGRACustomBitmap; repetition: string): IBGRACanvasTextureProvider2D; overload;
    function createPattern(texture: IBGRAScanner): IBGRACanvasTextureProvider2D; overload;

    procedure fillRect(x,y,w,h: single);
    procedure strokeRect(x,y,w,h: single);
    procedure clearRect(x,y,w,h: single);

    procedure beginPath;
    procedure closePath;
    procedure moveTo(x,y: single); overload;
    procedure lineTo(x,y: single); overload;
    procedure moveTo(pt: TPointF); overload;
    procedure lineTo(pt: TPointF); overload;
    procedure quadraticCurveTo(cpx,cpy,x,y: single);
    procedure bezierCurveTo(cp1x,cp1y,cp2x,cp2y,x,y: single);
    procedure rect(x,y,w,h: single);
    procedure roundRect(x,y,w,h,radius: single);
    procedure spline(const pts: array of TPointF; style: TSplineStyle= ssOutside);
    procedure splineTo(const pts: array of TPointF; style: TSplineStyle= ssOutside);
    procedure arc(x, y, radius, startAngle, endAngle: single; anticlockwise: boolean); overload;
    procedure arc(x, y, radius, startAngle, endAngle: single); overload;
    procedure arcTo(x1, y1, x2, y2, radius: single); overload;
    procedure arcTo(p1,p2: TPointF; radius: single); overload;
    procedure fill;
    procedure stroke;
    procedure clearPath;
    procedure clip;
    procedure unclip;
    function isPointInPath(x,y: single): boolean; overload;
    function isPointInPath(pt: TPointF): boolean; overload;

    procedure drawImage(image: TBGRACustomBitmap; dx,dy: single); overload;
    procedure drawImage(image: TBGRACustomBitmap; dx,dy,dw,dh: single); overload;

    function getLineStyle: TBGRAPenStyle;
    procedure lineStyle(const AValue: array of single);

    property surface: TBGRACustomBitmap read FSurface;
    property width: Integer read GetWidth;
    property height: Integer read GetHeight;
    property pixelCenteredCoordinates: boolean read GetPixelCenteredCoordinates write SetPixelCenteredCoordinates;
    property globalAlpha: single read GetGlobalAlpha write SetGlobalAlpha;

    property lineWidth: single read GetLineWidth write SetLineWidth;
    property lineCap: string read GetLineCap write SetLineCap;
    property lineJoin: string read GetlineJoin write SetLineJoin;
    property miterLimit: single read GetMiterLimit write SetMiterLimit;

    property shadowOffsetX: single read GetShadowOffsetX write SetShadowOffsetX;
    property shadowOffsetY: single read GetShadowOffsetY write SetShadowOffsetY;
    property shadowOffset: TPointF read GetShadowOffset write SetShadowOffset;
    property shadowBlur: single read GetShadowBlur write SetShadowBlur;
    property hasShadow: boolean read GetHasShadow;
  end;

implementation

uses Math, BGRAPen, BGRAFillInfo, BGRAPolygon, BGRABlend, FPWriteJPEG, FPWriteBMP, base64;

type
  TColorStop = record
    position: single;
    color: TBGRAPixel;
  end;

  TGradientArrayOfColors = array of TBGRAPixel;
  TGradientArrayOfPositions = array of single;

  { TBGRACanvasGradient2D }

  TBGRACanvasGradient2D = class(TBGRACanvasTextureProvider2D, IBGRACanvasGradient2D)
  private
    colorStops: array of TColorStop;
    nbColorStops: integer;
    FCustomGradient: TBGRACustomGradient;
  protected
    scanner: TBGRAGradientScanner;
    procedure CreateScanner; virtual; abstract;
    function getColorArray: TGradientArrayOfColors;
    function getPositionArray: TGradientArrayOfPositions;
  public
    function getTexture: IBGRAScanner; override;
    destructor Destroy; override;
    procedure addColorStop(APosition: single; AColor: TBGRAPixel);
    procedure addColorStop(APosition: single; AColor: TColor);
    procedure addColorStop(APosition: single; AColor: string);
    procedure setColors(ACustomGradient: TBGRACustomGradient);
    property texture: IBGRAScanner read GetTexture;
    property colorStopCount: integer read nbColorStops;
  end;

  { TBGRACanvasLinearGradient2D }

  TBGRACanvasLinearGradient2D = class(TBGRACanvasGradient2D)
  protected
    o1,o2: TPointF;
    procedure CreateScanner; override;
  public
    constructor Create(x0,y0,x1,y1: single);
    constructor Create(p0,p1: TPointF);
  end;

  { TBGRACanvasPattern2D }

  TBGRACanvasPattern2D = class(TBGRACanvasTextureProvider2D)
  protected
    scanner: TBGRACustomScanner;
    foreignInterface: IBGRAScanner;
    ownScanner: boolean;
  public
    function getTexture: IBGRAScanner; override;
    constructor Create(source: TBGRACustomBitmap; repeatX,repeatY: boolean; Origin, HAxis, VAxis: TPointF);
    constructor Create(source: IBGRAScanner; transformation: TAffineMatrix);
    destructor Destroy; override;
  end;

{ TBGRACanvasPattern2D }

function TBGRACanvasPattern2D.GetTexture: IBGRAScanner;
begin
  if ownScanner then
    result := scanner
  else
    result := foreignInterface;
end;

constructor TBGRACanvasPattern2D.Create(source: TBGRACustomBitmap; repeatX,
  repeatY: boolean; Origin, HAxis, VAxis: TPointF);
var
  affine: TBGRAAffineBitmapTransform;
begin
  if (abs(Origin.X-round(Origin.X)) < 1e-6) and
     (abs(Origin.Y-round(Origin.Y)) < 1e-6) and
     (HAxis = Origin+PointF(1,0)) and
     (VAxis = Origin+PointF(0,1)) then
  begin
    if (round(Origin.X)=0) and (round(Origin.Y)=0) and repeatX and repeatY then
    begin
      foreignInterface := source;
      ownScanner:= false;
    end else
    begin
      scanner := TBGRABitmapScanner.Create(source,repeatX,repeatY,Point(round(Origin.X),round(Origin.Y)));
      ownScanner := true;
    end;
  end
  else
  begin
    affine := TBGRAAffineBitmapTransform.Create(source,repeatX,repeatY);
    affine.Fit(Origin,HAxis,VAxis);
    scanner := affine;
    ownScanner:= true;
  end;
end;

constructor TBGRACanvasPattern2D.Create(source: IBGRAScanner;
  transformation: TAffineMatrix);
var
  affine : TBGRAAffineScannerTransform;
begin
  if (abs(transformation[1,1]-1) < 1e-6) and
     (abs(transformation[2,2]-1) < 1e-6) and
     (abs(transformation[1,2]) < 1e-6) and
     (abs(transformation[2,1]) < 1e-6) and
     (abs(transformation[1,3]-round(transformation[1,3])) < 1e-6) and
     (abs(transformation[2,3]-round(transformation[2,3])) < 1e-6) then
  begin
    if (abs(transformation[1,3]) < 1e-6) and
      (abs(transformation[2,3]) < 1e-6) then
    begin
      foreignInterface := source;
      ownScanner := false;
    end else
    begin
     scanner := TBGRAScannerOffset.Create(source,Point(round(transformation[1,3]),round(transformation[2,3])));
     ownScanner := true;
    end;
  end else
  begin
    affine := TBGRAAffineScannerTransform.Create(source);
    affine.Matrix := transformation;
    affine.Invert;
    scanner := affine;
    ownScanner:= true;
  end;
end;

destructor TBGRACanvasPattern2D.Destroy;
begin
  fillchar(foreignInterface,sizeof(foreignInterface),0);
  if ownScanner then FreeAndNil(scanner);
  inherited Destroy;
end;

{ TBGRACanvasLinearGradient2D }

procedure TBGRACanvasLinearGradient2D.CreateScanner;
var GradientOwner: boolean;
    GradientColors: TBGRACustomGradient;
begin
  if FCustomGradient = nil then
  begin
    GradientColors := TBGRAMultiGradient.Create(getColorArray,getPositionArray,False,False);
    GradientOwner := true;
  end else
  begin
    GradientColors := FCustomGradient;
    GradientOwner := false;
  end;
  scanner := TBGRAGradientScanner.Create(GradientColors,gtLinear,o1,o2,False,GradientOwner);
end;

constructor TBGRACanvasLinearGradient2D.Create(x0, y0, x1, y1: single);
begin
  o1 := PointF(x0,y0);
  o2 := PointF(x1,y1);
end;

constructor TBGRACanvasLinearGradient2D.Create(p0, p1: TPointF);
begin
  o1 := p0;
  o2 := p1;
end;

{ TBGRACanvasGradient2D }

function TBGRACanvasGradient2D.GetTexture: IBGRAScanner;
begin
  if scanner = nil then CreateScanner;
  result := scanner;
end;

function TBGRACanvasGradient2D.getColorArray: TGradientArrayOfColors;
var
  i: Integer;
begin
  setlength(result, nbColorStops);
  for i := 0 to nbColorStops-1 do
    result[i] := colorStops[i].color;
end;

function TBGRACanvasGradient2D.getPositionArray: TGradientArrayOfPositions;
var
  i: Integer;
begin
  setlength(result, nbColorStops);
  for i := 0 to nbColorStops-1 do
    result[i] := colorStops[i].position;
end;

destructor TBGRACanvasGradient2D.Destroy;
begin
  FreeAndNil(scanner);
  inherited Destroy;
end;

procedure TBGRACanvasGradient2D.addColorStop(APosition: single;
  AColor: TBGRAPixel);
begin
  FreeAndNil(scanner);
  if nbColorStops = length(colorStops) then
    setlength(colorStops, (length(colorStops)+1)*2);

  with colorStops[nbColorStops] do
  begin
    position := APosition;
    color := AColor;
  end;
  inc(nbColorStops);
end;

procedure TBGRACanvasGradient2D.addColorStop(APosition: single; AColor: TColor
  );
begin
  addColorStop(APosition, ColorToBGRA(ColorToRGB(AColor)));
end;

procedure TBGRACanvasGradient2D.addColorStop(APosition: single; AColor: string
  );
begin
  addColorStop(APosition, StrToBGRA(AColor));
end;

procedure TBGRACanvasGradient2D.setColors(ACustomGradient: TBGRACustomGradient
  );
begin
  FCustomGradient := ACustomGradient;
end;

{ TBGRACanvasState2D }

constructor TBGRACanvasState2D.Create(AMatrix: TAffineMatrix;
  AClipMask: TBGRACustomBitmap);
begin
  strokeColor := BGRABlack;
  fillColor := BGRABlack;
  globalAlpha := 255;

  lineWidth := 1;
  lineCap := pecFlat;
  lineJoin := pjsMiter;
  lineStyle := DuplicatePenStyle(SolidPenStyle);
  miterLimit := 10;

  shadowOffsetX := 0;
  shadowOffsetY := 0;
  shadowBlur := 0;
  shadowColor := BGRAPixelTransparent;

  matrix := AMatrix;
  if AClipMask = nil then
    clipMask := nil
  else
    clipMask := AClipMask.Duplicate;
end;

function TBGRACanvasState2D.Duplicate: TBGRACanvasState2D;
begin
  result := TBGRACanvasState2D.Create(matrix,clipMask);
  result.strokeColor := strokeColor;
  result.strokeTextureProvider := strokeTextureProvider;
  result.fillColor := fillColor;
  result.fillTextureProvider := fillTextureProvider;
  result.globalAlpha := globalAlpha;

  result.lineWidth := lineWidth;
  result.lineCap := lineCap;
  result.lineJoin := lineJoin;
  result.lineStyle := DuplicatePenStyle(lineStyle);
  result.miterLimit := miterLimit;

  result.shadowOffsetX := shadowOffsetX;
  result.shadowOffsetY := shadowOffsetY;
  result.shadowBlur := shadowBlur;
  result.shadowColor := shadowColor;
end;

destructor TBGRACanvasState2D.Destroy;
begin
  clipMask.Free;
  inherited Destroy;
end;

{ TBGRACanvas2D }

function TBGRACanvas2D.GetHeight: Integer;
begin
  result := Surface.Height;
end;

function TBGRACanvas2D.GetLineCap: string;
begin
  case currentState.lineCap of
    pecRound: result := 'round';
    pecSquare: result := 'square';
    else result := 'butt';
  end;
end;

function TBGRACanvas2D.GetlineJoin: string;
begin
  case currentState.lineJoin of
    pjsBevel: result := 'bevel';
    pjsRound: result := 'round';
    else result := 'miter';
  end;
end;

function TBGRACanvas2D.getLineStyle: TBGRAPenStyle;
begin
  result := DuplicatePenStyle(currentState.lineStyle);
end;

function TBGRACanvas2D.GetLineWidth: single;
begin
  result := currentState.lineWidth;
end;

function TBGRACanvas2D.GetMiterLimit: single;
begin
  result := currentState.miterLimit;
end;

function TBGRACanvas2D.GetPixelCenteredCoordinates: boolean;
begin
  result := FPixelCenteredCoordinates;
end;

function TBGRACanvas2D.GetShadowBlur: single;
begin
  result := currentState.shadowBlur;
end;

function TBGRACanvas2D.GetShadowOffset: TPointF;
begin
  result := PointF(shadowOffsetX,shadowOffsetY);
end;

function TBGRACanvas2D.GetShadowOffsetX: single;
begin
  result := currentState.shadowOffsetX;
end;

function TBGRACanvas2D.GetShadowOffsetY: single;
begin
  result := currentState.shadowOffsetY;
end;

function TBGRACanvas2D.GetGlobalAlpha: single;
begin
  result := currentState.globalAlpha/255;
end;

function TBGRACanvas2D.GetHasShadow: boolean;
begin
  result := (ApplyGlobalAlpha(currentState.shadowColor).alpha <> 0) and
    ( (currentState.shadowBlur <> 0) or (currentState.shadowOffsetX <> 0)
      or (currentState.shadowOffsetY <> 0) );
end;

function TBGRACanvas2D.GetWidth: Integer;
begin
  result := Surface.Width;
end;

procedure TBGRACanvas2D.SetGlobalAlpha(const AValue: single);
begin
  if AValue < 0 then currentState.globalAlpha:= 0 else
  if AValue > 1 then currentState.globalAlpha:= 255 else
    currentState.globalAlpha:= round(AValue*255);
end;

procedure TBGRACanvas2D.SetLineCap(const AValue: string);
begin
  if CompareText(AValue,'round')=0 then
    currentState.lineCap := pecRound else
  if CompareText(AValue,'square')=0 then
    currentState.lineCap := pecSquare
  else
    currentState.lineCap := pecFlat;
end;

procedure TBGRACanvas2D.SetLineJoin(const AValue: string);
begin
  if CompareText(AValue,'round')=0 then
    currentState.lineJoin := pjsRound else
  if CompareText(AValue,'bevel')=0 then
    currentState.lineJoin := pjsBevel
  else
    currentState.lineJoin := pjsMiter;
end;

procedure TBGRACanvas2D.FillPoly(const points: array of TPointF);
var
  tempScan: TBGRACustomScanner;
begin
  if length(points) = 0 then exit;
  If hasShadow then DrawShadow(points);
  if currentState.clipMask <> nil then
  begin
    if currentState.fillTextureProvider <> nil then
      tempScan := TBGRATextureMaskScanner.Create(currentState.clipMask,Point(0,0),currentState.fillTextureProvider.texture,currentState.globalAlpha)
    else
      tempScan := TBGRASolidColorMaskScanner.Create(currentState.clipMask,Point(0,0),ApplyGlobalAlpha(currentState.fillColor));
    BGRAPolygon.FillPolyAntialiasWithTexture(surface, points, tempScan, true);
    tempScan.free;
  end else
  begin
    if currentState.fillTextureProvider <> nil then
    begin
      if currentState.globalAlpha <> 255 then
      begin
        tempScan := TBGRAOpacityScanner.Create(currentState.fillTextureProvider.texture, currentState.globalAlpha);
        BGRAPolygon.FillPolyAntialiasWithTexture(surface, points, tempScan, true);
        tempScan.Free;
      end else
        BGRAPolygon.FillPolyAntialiasWithTexture(surface, points, currentState.fillTextureProvider.texture, true)
    end
    else
      BGRAPolygon.FillPolyAntialias(surface, points, ApplyGlobalAlpha(currentState.fillColor), false, true);
  end;
end;

procedure TBGRACanvas2D.lineStyle(const AValue: array of single);
begin
  currentState.lineStyle := DuplicatePenStyle(AValue);
end;

procedure TBGRACanvas2D.SetLineWidth(const AValue: single);
begin
  currentState.lineWidth := AValue;
end;

procedure TBGRACanvas2D.SetMiterLimit(const AValue: single);
begin
  currentState.miterLimit := AValue;
end;

procedure TBGRACanvas2D.SetPixelCenteredCoordinates(const AValue: boolean);
begin
  FPixelCenteredCoordinates:= AValue;
  if AValue then
    FCanvasOffset := PointF(0,0)
  else
    FCanvasOffset := PointF(-0.5,-0.5);
end;

procedure TBGRACanvas2D.SetShadowBlur(const AValue: single);
begin
  currentState.shadowBlur := AValue;
end;

procedure TBGRACanvas2D.SetShadowOffset(const AValue: TPointF);
begin
  shadowOffsetX := AValue.X;
  shadowOffsetY := AValue.Y;
end;

procedure TBGRACanvas2D.SetShadowOffsetX(const AValue: single);
begin
  currentState.shadowOffsetX := AValue;
end;

procedure TBGRACanvas2D.SetShadowOffsetY(const AValue: single);
begin
  currentState.shadowOffsetY := AValue;
end;

procedure TBGRACanvas2D.StrokePoly(const points: array of TPointF);
var
  texture: IBGRAScanner;
  tempScan: TBGRACustomScanner;
  contour: array of TPointF;
begin
  if (length(points)= 0) or (currentState.lineWidth = 0) then exit;
  contour := ComputeWidePolylinePoints(points,currentState.lineWidth,BGRAPixelTransparent,
      currentState.lineCap,currentState.lineJoin,currentState.lineStyle,[plAutoCycle],miterLimit);

  If hasShadow then DrawShadow(contour);
  if currentState.clipMask <> nil then
  begin
    if currentState.strokeTextureProvider <> nil then
      tempScan := TBGRATextureMaskScanner.Create(currentState.clipMask,Point(0,0),currentState.strokeTextureProvider.texture,currentState.globalAlpha)
    else
      tempScan := TBGRASolidColorMaskScanner.Create(currentState.clipMask,Point(0,0),ApplyGlobalAlpha(currentState.strokeColor));
    BGRAPolygon.FillPolyAntialiasWithTexture(Surface,contour,tempScan,True);
    tempScan.free;
  end else
  begin
    if currentState.strokeTextureProvider <> nil then
      texture := currentState.strokeTextureProvider.texture else
      texture := nil;
    if texture = nil then
      BGRAPolygon.FillPolyAntialias(Surface,contour,ApplyGlobalAlpha(currentState.strokeColor),false,True)
    else
      BGRAPolygon.FillPolyAntialiasWithTexture(Surface,contour,texture,True);
  end;
end;

procedure TBGRACanvas2D.DrawShadow(const points: array of TPointF);
var ofsPts: array of TPointF;
    offset: TPointF;
    i: Integer;
    tempBmp,blurred: TBGRACustomBitmap;
begin
  if not hasShadow then exit;
  offset := PointF(shadowOffsetX,shadowOffsetY);
  setlength(ofsPts, length(points));
  for i := 0 to high(ofsPts) do
    ofsPts[i] := points[i]+offset;
  tempBmp := surface.NewBitmap(width,height,BGRAPixelTransparent);
  tempBmp.FillPolyAntialias(ofsPts, ApplyGlobalAlpha(getShadowColor));
  if shadowBlur > 0 then
  begin
    if (shadowBlur < 5) and (abs(shadowBlur-round(shadowBlur)) > 1e-6) then
      blurred := tempBmp.FilterBlurRadial(round(shadowBlur*10),rbPrecise)
    else
      blurred := tempBmp.FilterBlurRadial(round(shadowBlur),rbFast);
    tempBmp.Free;
    tempBmp := blurred;
  end;
  if currentState.clipMask <> nil then
    tempBmp.ApplyMask(currentState.clipMask);
  surface.PutImage(0,0,tempBmp,dmDrawWithTransparency);
  tempBmp.Free;
end;

procedure TBGRACanvas2D.ClearPoly(const points: array of TPointF);
begin
  BGRAPolygon.FillPolyAntialias(surface, points, BGRA(0,0,0,255), true, true)
end;

function TBGRACanvas2D.ApplyTransform(const points: array of TPointF;
  matrix: TAffineMatrix): ArrayOfTPointF;
var
  i: Integer;
begin
  setlength(result,length(points));
  for i := 0 to high(result) do
    if isEmptyPointF(points[i]) then
      result[i] := EmptyPointF
    else
      result[i] := matrix*points[i]+FCanvasOffset;
end;

function TBGRACanvas2D.ApplyTransform(const points: array of TPointF
  ): ArrayOfTPointF;
var
  i: Integer;
begin
  setlength(result,length(points));
  for i := 0 to high(result) do
    if isEmptyPointF(points[i]) then
      result[i] := EmptyPointF
    else
      result[i] := currentState.matrix*points[i]+FCanvasOffset;
end;

function TBGRACanvas2D.ApplyTransform(point: TPointF): TPointF;
begin
  result := currentState.matrix*point+FCanvasOffset;
end;

function TBGRACanvas2D.GetPenPos: TPointF;
begin
  if FPathPointCount = 0 then
    result := PointF(0,0)
  else
    result := FPathPoints[FPathPointCount-1];
end;

procedure TBGRACanvas2D.AddPoint(point: TPointF);
begin
  if FPathPointCount = length(FPathPoints) then
    setlength(FPathPoints, (length(FPathPoints)+1)*2);
  FPathPoints[FPathPointCount] := point;
  inc(FPathPointCount);
end;

procedure TBGRACanvas2D.AddPoints(const points: array of TPointF);
var i: integer;
begin
  if FPathPointCount+length(points) > length(FPathPoints) then
    setlength(FPathPoints, max( (length(FPathPoints)+1)*2, FPathPointCount+length(points) ) );
  for i := 0 to high(points) do
  begin
    FPathPoints[FPathPointCount] := points[i];
    inc(FPathPointCount);
  end;
end;

procedure TBGRACanvas2D.AddPointsRev(const points: array of TPointF);
var i: integer;
begin
  if FPathPointCount+length(points) > length(FPathPoints) then
    setlength(FPathPoints, max( (length(FPathPoints)+1)*2, FPathPointCount+length(points) ) );
  for i := high(points) downto 0 do
  begin
    FPathPoints[FPathPointCount] := points[i];
    inc(FPathPointCount);
  end;
end;

function TBGRACanvas2D.ApplyGlobalAlpha(color: TBGRAPixel): TBGRAPixel;
begin
  result := BGRA(color.red,color.green,color.blue,ApplyOpacity(color.alpha, currentState.globalAlpha));
end;

constructor TBGRACanvas2D.Create(ASurface: TBGRACustomBitmap);
begin
  FSurface := ASurface;
  StateStack := TList.Create;
  FPathPointCount := 0;
  currentState := TBGRACanvasState2D.Create(AffineMatrixIdentity,nil);
  pixelCenteredCoordinates := false;
end;

destructor TBGRACanvas2D.Destroy;
var
  i: Integer;
begin
  for i := 0 to StateStack.Count-1 do
    TObject(StateStack[i]).Free;
  StateStack.Free;
  currentState.Free;
  inherited Destroy;
end;

function TBGRACanvas2D.toDataURL(mimeType: string): string;
var
  stream: TMemoryStream;
  jpegWriter: TFPWriterJPEG;
  bmpWriter: TFPWriterBMP;
  output: TStringStream;
  encode64: TBase64EncodingStream;
begin
  stream := TMemoryStream.Create;
  if mimeType='image/jpeg' then
  begin
    jpegWriter := TFPWriterJPEG.Create;
    Surface.SaveToStream(stream,jpegWriter);
    jpegWriter.Free;
  end else
  if mimeType='image/bmp' then
  begin
    bmpWriter := TFPWriterBMP.Create;
    Surface.SaveToStream(stream,bmpWriter);
    bmpWriter.Free;
  end else
  begin
    mimeType := 'image/png';
    Surface.SaveToStreamAsPng(stream);
  end;
  output := TStringStream.Create('data:'+mimeType+';base64,');
  output.Position := output.size;
  stream.Position := 0;
  encode64 := TBase64EncodingStream.Create(output);
  encode64.CopyFrom(stream,stream.size);
  encode64.free;
  stream.free;
  result := output.DataString;
  output.free;
end;

procedure TBGRACanvas2D.save;
var cur: TBGRACanvasState2D;
begin
  cur := currentState.Duplicate;
  StateStack.Add(cur);
end;

procedure TBGRACanvas2D.restore;
begin
  if StateStack.Count > 0 then
  begin
    FreeAndNil(currentState);
    currentState := TBGRACanvasState2D(StateStack[StateStack.Count-1]);
    StateStack.Delete(StateStack.Count-1);
  end;
end;

procedure TBGRACanvas2D.scale(x, y: single);
begin
  currentState.matrix *= AffineMatrixScale(x,y);
end;

procedure TBGRACanvas2D.rotate(angleRad: single);
begin
  currentState.matrix *= AffineMatrixRotationRad(-angleRad);
end;

procedure TBGRACanvas2D.translate(x, y: single);
begin
  currentState.matrix *= AffineMatrixTranslation(x,y);
end;

procedure TBGRACanvas2D.transform(a, b, c, d, e, f: single);
begin
  currentState.matrix *= AffineMatrix(a,c,e,b,d,f);
end;

procedure TBGRACanvas2D.setTransform(a, b, c, d, e, f: single);
begin
  currentState.matrix := AffineMatrix(a,c,e,b,d,f);
end;

procedure TBGRACanvas2D.resetTransform;
begin
  currentState.matrix := AffineMatrixIdentity;
end;

procedure TBGRACanvas2D.strokeStyle(color: TBGRAPixel);
begin
  currentState.strokeColor := color;
  currentState.strokeTextureProvider := nil;
end;

procedure TBGRACanvas2D.strokeStyle(color: TColor);
begin
  currentState.strokeColor := ColorToBGRA(ColorToRGB(color));
  currentState.strokeTextureProvider := nil;
end;

procedure TBGRACanvas2D.strokeStyle(color: string);
begin
  currentState.strokeColor := StrToBGRA(color);
  currentState.strokeTextureProvider := nil;
end;

procedure TBGRACanvas2D.strokeStyle(texture: IBGRAScanner);
begin
  strokeStyle(createPattern(texture));
end;

procedure TBGRACanvas2D.strokeStyle(provider: IBGRACanvasTextureProvider2D);
begin
  currentState.strokeColor := BGRAPixelTransparent;
  currentState.strokeTextureProvider := provider;
end;

procedure TBGRACanvas2D.fillStyle(color: TBGRAPixel);
begin
  currentState.fillColor := color;
  currentState.fillTextureProvider := nil;
end;

procedure TBGRACanvas2D.fillStyle(color: TColor);
begin
  currentState.fillColor := ColorToBGRA(ColorToRGB(color));
  currentState.fillTextureProvider := nil;
end;

procedure TBGRACanvas2D.fillStyle(color: string);
begin
  currentState.fillColor := StrToBGRA(color);
  currentState.fillTextureProvider := nil;
end;

procedure TBGRACanvas2D.fillStyle(texture: IBGRAScanner);
begin
  fillStyle(createPattern(texture));
end;

procedure TBGRACanvas2D.fillStyle(provider: IBGRACanvasTextureProvider2D);
begin
  currentState.fillColor := BGRAPixelTransparent;
  currentState.fillTextureProvider := provider;
end;

procedure TBGRACanvas2D.shadowColor(color: TBGRAPixel);
begin
  currentState.shadowColor := color;
end;

procedure TBGRACanvas2D.shadowColor(color: TColor);
begin
  shadowColor(ColorToBGRA(ColorToRGB(color)));
end;

procedure TBGRACanvas2D.shadowColor(color: string);
begin
  shadowColor(StrToBGRA(color));
end;

function TBGRACanvas2D.getShadowColor: TBGRAPixel;
begin
  result := currentState.shadowColor;
end;

function TBGRACanvas2D.createLinearGradient(x0, y0, x1, y1: single
  ): IBGRACanvasGradient2D;
begin
  result := createLinearGradient(ApplyTransform(PointF(x0,y0)), ApplyTransform(PointF(x1,y1)));
end;

function TBGRACanvas2D.createLinearGradient(p0, p1: TPointF
  ): IBGRACanvasGradient2D;
begin
  result := TBGRACanvasLinearGradient2D.Create(p0,p1);
end;

function TBGRACanvas2D.createLinearGradient(x0, y0, x1, y1: single;
  Colors: TBGRACustomGradient): IBGRACanvasGradient2D;
begin
  result := createLinearGradient(x0,y0,x1,y1);
  result.setColors(Colors);
end;

function TBGRACanvas2D.createLinearGradient(p0, p1: TPointF;
  Colors: TBGRACustomGradient): IBGRACanvasGradient2D;
begin
  result := createLinearGradient(p0,p1);
  result.setColors(Colors);
end;

function TBGRACanvas2D.createPattern(image: TBGRACustomBitmap; repetition: string
  ): IBGRACanvasTextureProvider2D;
var
  repeatX,repeatY: boolean;
  origin: TPointF;
begin
  repetition := lowercase(trim(repetition));
  repeatX := true;
  repeatY := true;
  if repetition = 'repeat-x' then repeatY := false else
  if repetition = 'repeat-y' then repeatX := false else
  if repetition = 'no-repeat' then
  begin
    repeatX := false;
    repeatY := false;
  end;
  origin := ApplyTransform(PointF(0,0)) + PointF(0.5,0.5);
  result := TBGRACanvasPattern2D.Create(image,repeatX,repeatY,
     origin, origin+PointF(currentState.matrix[1,1],currentState.matrix[2,1])*image.Width,
     origin+PointF(currentState.matrix[1,2],currentState.matrix[2,2])*image.Height);
end;

function TBGRACanvas2D.createPattern(texture: IBGRAScanner
  ): IBGRACanvasTextureProvider2D;
var
  tempTransform: TAffineMatrix;
begin
  tempTransform := AffineMatrixTranslation(FCanvasOffset.X+0.5,FCanvasOffset.Y+0.5)*currentState.matrix;
  result := TBGRACanvasPattern2D.Create(texture,tempTransform);
end;

procedure TBGRACanvas2D.fillRect(x, y, w, h: single);
begin
  if (w=0) or (h=0) then exit;
  FillPoly(ApplyTransform([PointF(x,y),PointF(x+w,y),PointF(x+w,y+h),PointF(x,y+h)]));
end;

procedure TBGRACanvas2D.strokeRect(x, y, w, h: single);
begin
  if (w=0) or (h=0) then exit;
  StrokePoly(ApplyTransform([PointF(x,y),PointF(x+w,y),PointF(x+w,y+h),PointF(x,y+h),PointF(x,y)]));
end;

procedure TBGRACanvas2D.clearRect(x, y, w, h: single);
begin
  if (w=0) or (h=0) then exit;
  ClearPoly(ApplyTransform([PointF(x,y),PointF(x+w,y),PointF(x+w,y+h),PointF(x,y+h)]));
end;

procedure TBGRACanvas2D.beginPath;
begin
  FPathPointCount := 0;
end;

procedure TBGRACanvas2D.closePath;
var i: integer;
begin
  if FPathPointCount > 0 then
  begin
    i := FPathPointCount-1;
    while (i > 0) and not isEmptyPointF(FPathPoints[i-1]) do dec(i);
    AddPoint(FPathPoints[i]);
  end;
end;

procedure TBGRACanvas2D.moveTo(x, y: single);
begin
  moveTo(PointF(x,y));
end;

procedure TBGRACanvas2D.lineTo(x, y: single);
begin
  lineTo(PointF(x,y));
end;

procedure TBGRACanvas2D.moveTo(pt: TPointF);
begin
  if FPathPointCount <> 0 then
    AddPoint(EmptyPointF);
  AddPoint(ApplyTransform(pt));
end;

procedure TBGRACanvas2D.lineTo(pt: TPointF);
begin
  AddPoint(ApplyTransform(pt));
end;

procedure TBGRACanvas2D.quadraticCurveTo(cpx, cpy, x, y: single);
var
  curve : TQuadraticBezierCurve;
  pts : array of TPointF;
begin
  curve := BezierCurve(GetPenPos,ApplyTransform(PointF(cpx,cpy)),ApplyTransform(PointF(x,y)));
  pts := Surface.ComputeBezierCurve(curve);
  AddPoints(pts);
end;

procedure TBGRACanvas2D.bezierCurveTo(cp1x, cp1y, cp2x, cp2y, x, y: single);
var
  curve : TCubicBezierCurve;
  pts : array of TPointF;
begin
  curve := BezierCurve(GetPenPos,ApplyTransform(PointF(cp1x,cp1y)),
    ApplyTransform(PointF(cp2x,cp2y)),ApplyTransform(PointF(x,y)));
  pts := Surface.ComputeBezierCurve(curve);
  AddPoints(pts);
end;

procedure TBGRACanvas2D.rect(x, y, w, h: single);
begin
  MoveTo(x,y);
  LineTo(x+w,y);
  LineTo(x+w,y+h);
  LineTo(x,y+h);
  LineTo(x,y);
end;

procedure TBGRACanvas2D.roundRect(x, y, w, h, radius: single);
begin
  if radius <= 0 then
  begin
    rect(x,y,w,h);
    exit;
  end;
  if (w <= 0) or (h <= 0) then exit;
  if radius*2 > w then radius := w/2;
  if radius*2 > h then radius := h/2;
  moveTo(x+radius,y);
  arcTo(PointF(x+w,y),PointF(x+w,y+h), radius);
  arcTo(PointF(x+w,y+h),PointF(x,y+h), radius);
  arcTo(PointF(x,y+h),PointF(x,y), radius);
  arcTo(PointF(x,y),PointF(x+w,y), radius);
end;

procedure TBGRACanvas2D.spline(const pts: array of TPointF; style: TSplineStyle);
var transf: array of TPointF;
begin
  if length(pts)=0 then exit;
  transf := ApplyTransform(pts);
  if (pts[0] = pts[high(pts)]) and (length(pts) > 1) then
    transf := surface.ComputeClosedSpline(slice(transf, length(transf)-1),style)
  else
    transf := surface.ComputeOpenedSpline(transf,style);
  AddPoints(transf);
end;

procedure TBGRACanvas2D.splineTo(const pts: array of TPointF;
  style: TSplineStyle);
var transf: array of TPointF;
  i: Integer;
begin
  transf := ApplyTransform(pts);
  if FPathPointCount <> 0 then
  begin
    setlength(transf,length(transf)+1);
    for i := high(transf) downto 1 do
      transf[i]:= transf[i-1];
    transf[0] := GetPenPos;
  end;
  transf := surface.ComputeOpenedSpline(transf,style);
  AddPoints(transf);
end;

procedure TBGRACanvas2D.arc(x, y, radius, startAngle, endAngle: single;
  anticlockwise: boolean);
var pts: array of TPointF;
  temp: single;
  pt: TPointF;
  rx,ry: single;
  len1,len2: single;
  unitAffine: TAffineMatrix;
  v1orig,v2orig,v1ortho,v2ortho: TPointF;
begin
  v1orig := PointF(currentState.matrix[1,1],currentState.matrix[2,1]);
  v2orig := PointF(currentState.matrix[1,2],currentState.matrix[2,2]);
  len1 := VectLen(v1orig);
  len2 := VectLen(v2orig);
  rx := len1*radius;
  ry := len2*radius;
  if len1 <> 0 then v1ortho := v1orig * (1/len1) else v1ortho := v1orig;
  if len2 <> 0 then v2ortho := v2orig * (1/len2) else v2ortho := v2orig;
  pt := currentState.matrix* PointF(x,y);
  unitAffine := AffineMatrix(v1ortho.x, v2ortho.x, pt.x,
                             v1ortho.y, v2ortho.y, pt.y);
  startAngle := -startAngle;
  endAngle := -endAngle;
  if not anticlockwise then
  begin
    temp := startAngle;
    startAngle := endAngle;
    endAngle := temp;
    pts := surface.ComputeArcRad(0,0,rx,ry,startAngle,endAngle);
    pts := ApplyTransform(pts,unitAffine);
    AddPointsRev(pts);
  end else
  begin
    pts := surface.ComputeArcRad(0,0,rx,ry,startAngle,endAngle);
    pts := ApplyTransform(pts,unitAffine);
    AddPoints(pts);
  end;
end;

procedure TBGRACanvas2D.arc(x, y, radius, startAngle, endAngle: single);
begin
  arc(x,y,radius,startAngle,endAngle,false);
end;

procedure TBGRACanvas2D.arcTo(x1, y1, x2, y2, radius: single);
var p0,p1,p2,p3,p4,an,bn,cn,c: TPointF;
    dir, a2, b2, c2, cosx, sinx, d,
    angle0, angle1: single;
    anticlockwise: boolean;
begin
  if FPathPointCount = 0 then
    moveTo(x1,y1);
  radius := abs(radius);
  p0 := GetPenPos;
  p1 := PointF(x1,y1);
  p2 := PointF(x2,y2);

  if (p0 = p1) or (p1 = p2) or (radius = 0) then
  begin
    lineto(x1,y1);
    exit;
  end;

  dir := (x2-x1)*(p0.y-y1) + (y2-y1)*(x1-p0.x);
  if dir = 0 then
  begin
    lineto(x1,y1);
    exit;
  end;

  a2 := (p0.x-x1)*(p0.x-x1) + (p0.y-y1)*(p0.y-y1);
  b2 := (x1-x2)*(x1-x2) + (y1-y2)*(y1-y2);
  c2 := (p0.x-x2)*(p0.x-x2) + (p0.y-y2)*(p0.y-y2);
  cosx := (a2+b2-c2)/(2*sqrt(a2*b2));

  sinx := sqrt(1 - cosx*cosx);
  if (sinx = 0) or (cosx = 1) then
  begin
    lineto(x1,y1);
    exit;
  end;
  d := radius / ((1 - cosx) / sinx);

  an := (p1-p0)*(1/sqrt(a2));
  bn := (p1-p2)*(1/sqrt(b2));
  p3 := p1 - an*d;
  p4 := p1 - bn*d;
  anticlockwise := (dir < 0);

  cn := PointF(an.y,-an.x)*radius;
  if not anticlockwise then cn := -cn;
  c := p3 + cn;
  angle0 := arctan2((p3.y-c.y), (p3.x-c.x));
  angle1 := arctan2((p4.y-c.y), (p4.x-c.x));

  lineTo(p3.x,p3.y);
  arc(c.x,c.y, radius, angle0, angle1, anticlockwise);
end;

procedure TBGRACanvas2D.arcTo(p1, p2: TPointF; radius: single);
begin
  arcTo(p1.x,p1.y,p2.x,p2.y,radius);
end;

procedure TBGRACanvas2D.fill;
begin
  if FPathPointCount = 0 then exit;
  FillPoly(slice(FPathPoints,FPathPointCount));
end;

procedure TBGRACanvas2D.stroke;
begin
  if FPathPointCount = 0 then exit;
  StrokePoly(slice(FPathPoints,FPathPointCount));
end;

procedure TBGRACanvas2D.clearPath;
begin
  if FPathPointCount = 0 then exit;
  ClearPoly(slice(FPathPoints,FPathPointCount));
end;

procedure TBGRACanvas2D.clip;
var
  tempBmp: TBGRACustomBitmap;
begin
  if FPathPointCount = 0 then
  begin
    currentState.clipMask.Fill(BGRABlack);
    exit;
  end;
  if currentState.clipMask = nil then
    currentState.clipMask := surface.NewBitmap(width,height,BGRAWhite);
  tempBmp := surface.NewBitmap(width,height,BGRABlack);
  tempBmp.FillPolyAntialias(slice(FPathPoints,FPathPointCount),BGRAWhite);
  currentState.clipMask.BlendImage(0,0,tempBmp,boDarken);
  tempBmp.Free;
end;

procedure TBGRACanvas2D.unclip;
begin
  if FPathPointCount = 0 then exit;
  if currentState.clipMask = nil then exit;
  currentState.clipMask.FillPolyAntialias(slice(FPathPoints,FPathPointCount),BGRAWhite);
  if currentState.clipMask.Equals(BGRAWhite) then
    FreeAndNil(currentState.clipMask);
end;

function TBGRACanvas2D.isPointInPath(x, y: single): boolean;
begin
  result := isPointInPath(PointF(x,y));
end;

function TBGRACanvas2D.isPointInPath(pt: TPointF): boolean;
begin
  if FPathPointCount <= 2 then
    result := false
  else
  begin
    setlength(FPathPoints,FPathPointCount);
    result := IsPointInPolygon(FPathPoints,pt+FCanvasOffset,True);
  end;
end;

procedure TBGRACanvas2D.drawImage(image: TBGRACustomBitmap; dx, dy: single);
begin
  Surface.PutImageAffine(ApplyTransform(PointF(dx,dy))+PointF(0.5,0.5),
    ApplyTransform(PointF(dx+image.width,dy))+PointF(0.5,0.5),
    ApplyTransform(PointF(dx,dy+image.height))+PointF(0.5,0.5), image, currentState.globalAlpha);
end;

procedure TBGRACanvas2D.drawImage(image: TBGRACustomBitmap; dx, dy, dw, dh: single);
begin
  Surface.PutImageAffine(ApplyTransform(PointF(dx,dy))+PointF(0.5,0.5),
    ApplyTransform(PointF(dx+dw,dy))+PointF(0.5,0.5),
    ApplyTransform(PointF(dx,dy+dh))+PointF(0.5,0.5), image, currentState.globalAlpha);
end;

end.

