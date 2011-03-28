unit BGRAGradients;

{$mode objfpc}{$H+}

interface

uses
  Graphics, Classes, BGRADefaultBitmap, BGRABitmap, BGRABitmapTypes;

type
  TnGradientInfo = record
    StartColor,StopColor: TBGRAPixel;
    Direction: TGradientDirection;
    EndPercent : single; // Position from 0 to 1
  end;

function nGradientInfo(StartColor, StopColor: TBGRAPixel; Direction: TGradientDirection; EndPercent: Single): TnGradientInfo;

function nGradientAlphaFill(ARect: TRect; ADir: TGradientDirection; const AGradient: array of TnGradientInfo): TBGRABitmap;
function nGradientAlphaFill(AWidth, AHeight: Integer; ADir: TGradientDirection; const AGradient: array of TnGradientInfo): TBGRABitmap;
procedure nGradientAlphaFill(ACanvas: TCanvas; ARect: TRect; ADir: TGradientDirection; const AGradient: array of TnGradientInfo);
procedure nGradientAlphaFill(ABitmap: TBGRABitmap; ARect: TRect; ADir: TGradientDirection; const AGradient: array of TnGradientInfo);

function DoubleGradientAlphaFill(ARect: TRect; AStart1,AStop1,AStart2,AStop2: TBGRAPixel;
                                 ADirection1,ADirection2,ADir: TGradientDirection; AValue: Single): TBGRABitmap;
function DoubleGradientAlphaFill(AWidth,AHeight: Integer; AStart1,AStop1,AStart2,AStop2: TBGRAPixel;
                                 ADirection1,ADirection2,ADir: TGradientDirection; AValue: Single): TBGRABitmap;
procedure DoubleGradientAlphaFill(ACanvas: TCanvas; ARect: TRect; AStart1,AStop1,AStart2,AStop2: TBGRAPixel;
                                 ADirection1,ADirection2,ADir: TGradientDirection; AValue: Single);
procedure DoubleGradientAlphaFill(ABitmap: TBGRABitmap; ARect: TRect; AStart1,AStop1,AStart2,AStop2: TBGRAPixel;
                                 ADirection1,ADirection2,ADir: TGradientDirection; AValue: Single);

type
  TRectangleMapOption = (rmoNoLeftBorder,rmoNoTopBorder,rmoNoRightBorder,rmoNoBottomBorder);
  TRectangleMapOptions = set of TRectangleMapOption;

  { TPhongShading }

  TPhongShading = class
    LightSourceIntensity : Double;
    LightSourceDistanceTerm : Double;
    LightColor: TBGRAPixel;
    AmbientFactor, DiffusionFactor, NegativeDiffusionFactor : Double;
    SpecularFactor, SpecularIndex : Double;
    LightPosition : TPoint;
    LightPositionZ : Integer;
    constructor Create;
    procedure Draw(dest: TBGRABitmap; map: TBGRABitmap; mapAltitude: integer; ofsX,ofsY: integer;
                   Color : TBGRAPixel);
    procedure Draw(dest: TBGRABitmap; map: TBGRABitmap; mapAltitude: integer; ofsX,ofsY: integer;
                   ColorMap : TBGRABitmap);
    procedure DrawCone(dest: TBGRABitmap; X,Y,Size,Altitude: Integer; Color: TBGRAPixel);
    procedure DrawSphere(dest: TBGRABitmap; bounds: TRect; Altitude: Integer; Color: TBGRAPixel);
    procedure DrawRectangle(dest: TBGRABitmap; bounds: TRect; Border,Altitude: Integer; Color: TBGRAPixel; RoundCorners: Boolean; Options: TRectangleMapOptions);
  private
    procedure normalize(var x, y, z: double);
    procedure vectproduct(u1, u2, u3, v1, v2, v3: integer; out w1, w2, w3: double); overload;
    procedure vectproduct(u1, u2, u3, v1, v2, v3: double; out w1, w2, w3: double); overload;
  end;

function CreateConeMap(size: integer): TBGRABitmap;
function CreateSphereMap(width,height: integer): TBGRABitmap;
function CreateRectangleMap(width,height,border: integer; options: TRectangleMapOptions = []): TBGRABitmap;
function CreateRoundRectangleMap(width,height,border: integer; options: TRectangleMapOptions = []): TBGRABitmap;
function CreatePerlinNoiseMap(AWidth, AHeight: integer; HorizontalPeriod: Single = 1;
  VerticalPeriod: Single = 1; Exponent: Double = 1): TBGRABitmap;

procedure BGRAGradientFill(bmp: TBGRADefaultBitmap; x, y, x2, y2: integer;
  c1, c2: TBGRAPixel; gtype: TGradientType; o1, o2: TPointF; mode: TDrawMode;
  gammaColorCorrection: boolean = True; Sinus: Boolean=False);

implementation

uses BGRABlend;

procedure BGRAGradientFill(bmp: TBGRADefaultBitmap; x, y, x2, y2: integer;
  c1, c2: TBGRAPixel; gtype: TGradientType; o1, o2: TPointF; mode: TDrawMode;
  gammaColorCorrection: boolean = True; Sinus: Boolean=False);
var
  u, p:   TPointF;
  len, a,a2: single;
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
  if x2 > bmp.width then x2 := bmp.width;
  if y < 0 then y := 0;
  if y2 > bmp.height then y2 := bmp.height;
  if (x2 <= x) or (y2 <= y) then exit;

  case mode of
    dmSet, dmSetExceptTransparent: pixelProc := @bmp.SetPixel;
    dmDrawWithTransparency: pixelProc := @bmp.DrawPixel;
    dmFastBlend: pixelProc := @bmp.FastBlendPixel;
  end;
  //handles transparency
  if (c1.alpha = 0) and (c2.alpha = 0) then
  begin
    bmp.FillRect(x, y, x2, y2, BGRAPixelTransparent, mode);
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
    bmp.FillRect(x, y, x2, y2, MergeBGRA(c1, c2), mode);
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
              b      := round(a / len * 16384);
              ec.red := (ec1.red * (16384 - b) + ec2.red * b + 8191) shr 14;
              ec.green := (ec1.green * (16384 - b) + ec2.green * b + 8191) shr 14;
              ec.blue := (ec1.blue * (16384 - b) + ec2.blue * b + 8191) shr 14;
              ec.alpha := (ec1.alpha * (16384 - b) + ec2.alpha * b + 8191) shr 14;
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
              b      := round(a / len * 16384);
              ec.red := (ec1.red * (16384 - b) + ec2.red * b + 8191) shr 14;
              ec.green := (ec1.green * (16384 - b) + ec2.green * b + 8191) shr 14;
              ec.blue := (ec1.blue * (16384 - b) + ec2.blue * b + 8191) shr 14;
              ec.alpha := (ec1.alpha * (16384 - b) + ec2.alpha * b + 8191) shr 14;
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
            a   := abs(p.x * u.x + p.y * u.y);
            a2  := abs(p.x * u.y - p.y * u.x);
            if a2 > a then a := a2;
            if Sinus then a := (sin(a*2*Pi/len)+1)*len/2;
            if a < 0 then
              c := c1
            else
            if a > len then
              c := c2
            else
            begin
              b      := round(a / len * 16384);
              ec.red := (ec1.red * (16384 - b) + ec2.red * b + 8191) shr 14;
              ec.green := (ec1.green * (16384 - b) + ec2.green * b + 8191) shr 14;
              ec.blue := (ec1.blue * (16384 - b) + ec2.blue * b + 8191) shr 14;
              ec.alpha := (ec1.alpha * (16384 - b) + ec2.alpha * b + 8191) shr 14;
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
              b      := round(a / len * 16384);
              ec.red := (ec1.red * (16384 - b) + ec2.red * b + 8191) shr 14;
              ec.green := (ec1.green * (16384 - b) + ec2.green * b + 8191) shr 14;
              ec.blue := (ec1.blue * (16384 - b) + ec2.blue * b + 8191) shr 14;
              ec.alpha := (ec1.alpha * (16384 - b) + ec2.alpha * b + 8191) shr 14;
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
              b      := round(a / len * 1024);
              c.red  := (c1.red * (1024 - b) + c2.red * b + 511) shr 10;
              c.green := (c1.green * (1024 - b) + c2.green * b + 511) shr 10;
              c.blue := (c1.blue * (1024 - b) + c2.blue * b + 511) shr 10;
              c.alpha := (c1.alpha * (1024 - b) + c2.alpha * b + 511) shr 10;
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
              b      := round(a / len * 1024);
              c.red  := (c1.red * (1024 - b) + c2.red * b + 511) shr 10;
              c.green := (c1.green * (1024 - b) + c2.green * b + 511) shr 10;
              c.blue := (c1.blue * (1024 - b) + c2.blue * b + 511) shr 10;
              c.alpha := (c1.alpha * (1024 - b) + c2.alpha * b + 511) shr 10;
            end;
            pixelProc(xb, yb, c);
          end;

      gtDiamond:
        for yb := y to y2 - 1 do
          for xb := x to x2 - 1 do
          begin
            p.x := xb - o1.x;
            p.y := yb - o1.y;
            a   := abs(p.x * u.x + p.y * u.y);
            a2  := abs(p.x * u.y - p.y * u.x);
            if a2 > a then a := a2;
            if Sinus then a := (sin(a*2*Pi/len)+1)*len/2;
            if a < 0 then
              c := c1
            else
            if a > len then
              c := c2
            else
            begin
              b      := round(a / len * 1024);
              c.red  := (c1.red * (1024 - b) + c2.red * b + 511) shr 10;
              c.green := (c1.green * (1024 - b) + c2.green * b + 511) shr 10;
              c.blue := (c1.blue * (1024 - b) + c2.blue * b + 511) shr 10;
              c.alpha := (c1.alpha * (1024 - b) + c2.alpha * b + 511) shr 10;
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
              b      := round(a / len * 1024);
              c.red  := (c1.red * (1024 - b) + c2.red * b + 511) shr 10;
              c.green := (c1.green * (1024 - b) + c2.green * b + 511) shr 10;
              c.blue := (c1.blue * (1024 - b) + c2.blue * b + 511) shr 10;
              c.alpha := (c1.alpha * (1024 - b) + c2.alpha * b + 511) shr 10;
            end;
            pixelProc(xb, yb, c);
          end;
    end;
  end;
end;

function nGradientInfo(StartColor, StopColor: TBGRAPixel;
  Direction: TGradientDirection; EndPercent: Single): TnGradientInfo;
begin
  result.StartColor := StartColor;
  result.StopColor := StopColor;
  result.Direction := Direction;
  result.EndPercent := EndPercent;
end;

function DoubleGradientAlphaFill(ARect: TRect; AStart1,AStop1,AStart2,AStop2: TBGRAPixel;
  ADirection1,ADirection2,ADir: TGradientDirection; AValue: Single): TBGRABitmap;
var
  ABitmap: TBGRABitmap;
  ARect1,ARect2: TRect;
  APoint1,APoint2,APoint3,APoint4: TPointF;
begin
  Dec(ARect.Right, ARect.Left);
  ARect.Left := 0;
  Dec(ARect.Bottom,ARect.Top);
  ARect.Top := 0;

  ABitmap := TBGRABitmap.Create(ARect.Right,ARect.Bottom);

  if AValue <> 0 then ARect1:=ARect;
  if AValue <> 1 then ARect2:=ARect;

  if ADir = gdVertical then begin
    ARect1.Bottom:=Round(ARect1.Bottom * AValue);
    ARect2.Top:=ARect1.Bottom;
  end
  else if ADir = gdHorizontal then begin
    ARect1.Right:=Round(ARect1.Right * AValue);
    ARect2.Left:=ARect1.Right;
  end;
  if ADirection1 = gdVertical then begin
    APoint1:=PointF(ARect1.Left,ARect1.Top);
    APoint2:=PointF(ARect1.Left,ARect1.Bottom);
  end
  else if ADirection1 = gdHorizontal then begin
    APoint1:=PointF(ARect1.Left,ARect1.Top);
    APoint2:=PointF(ARect1.Right,ARect1.Top);
  end;
  if ADirection2 = gdVertical then begin
    APoint3:=PointF(ARect2.Left,ARect2.Top);
    APoint4:=PointF(ARect2.Left,ARect2.Bottom);
  end
  else if ADirection2 = gdHorizontal then begin
    APoint3:=PointF(ARect2.Left,ARect2.Top);
    APoint4:=PointF(ARect2.Right,ARect2.Top);
  end;

  if AValue <> 0 then
    ABitmap.GradientFill(ARect1.Left,ARect1.Top,ARect1.Right,ARect1.Bottom,
    AStart1,AStop1,gtLinear,APoint1,APoint2,dmSet,True);
  if AValue <> 1 then
    ABitmap.GradientFill( ARect2.Left,ARect2.Top,ARect2.Right,ARect2.Bottom,
    AStart2,AStop2,gtLinear,APoint3,APoint4,dmSet,True);

  Result:=ABitmap;
end;

function DoubleGradientAlphaFill(AWidth, AHeight: Integer; AStart1, AStop1,
  AStart2, AStop2: TBGRAPixel; ADirection1, ADirection2,
  ADir: TGradientDirection; AValue: Single): TBGRABitmap;
begin
  result := DoubleGradientAlphaFill(Rect(0,0,AWidth,AHeight),
    AStart1,AStop1,AStart2,AStop2,
    ADirection1,ADirection2, ADir, AValue);
end;

procedure DoubleGradientAlphaFill(ACanvas: TCanvas; ARect: TRect; AStart1,
  AStop1, AStart2, AStop2: TBGRAPixel; ADirection1, ADirection2,
  ADir: TGradientDirection; AValue: Single);
var
  bmp: TBGRABitmap;
begin
  bmp := DoubleGradientAlphaFill(ARect,AStart1,AStop1,AStart2,AStop2,ADirection1,ADirection2,ADir,AValue);
  bmp.Draw(ACanvas,ARect.Left,ARect.Top,not bmp.HasTransparentPixels);
  bmp.Free;
end;

procedure DoubleGradientAlphaFill(ABitmap: TBGRABitmap; ARect: TRect; AStart1,
  AStop1, AStart2, AStop2: TBGRAPixel; ADirection1, ADirection2,
  ADir: TGradientDirection; AValue: Single);
var
  bmp: TBGRABitmap;
begin
  bmp := DoubleGradientAlphaFill(ARect,AStart1,AStop1,AStart2,AStop2,ADirection1,ADirection2,ADir,AValue);
  ABitmap.PutImage(ARect.Left,ARect.Top,bmp,dmDrawWithTransparency);
  bmp.Free;
end;

function nGradientAlphaFill(ARect: TRect; ADir: TGradientDirection;
  const AGradient: array of TnGradientInfo): TBGRABitmap;
var
  i:integer;
  AnRect, OldRect: TRect;
  Point1, Point2: TPointF;
begin
  Result := TBGRABitmap.Create(ARect.Right-ARect.Left,ARect.Bottom-ARect.Top);
  Dec(ARect.Right, ARect.Left);
  ARect.Left := 0;
  Dec(ARect.Bottom,ARect.Top);
  ARect.Top := 0;

  OldRect := ARect;

  if ADir = gdVertical then
    OldRect.Bottom := ARect.Top
  else
    OldRect.Right := ARect.Left;

  for i := 0 to high(AGradient) do
  begin
    AnRect:=OldRect;
    if ADir = gdVertical then
    begin
      AnRect.Bottom:=Round((ARect.Bottom-ARect.Top) * AGradient[i].endPercent + ARect.Top);
      AnRect.Top:=OldRect.Bottom;
      Point1:=PointF(AnRect.Left,AnRect.Top);
      Point2:=PointF(AnRect.Left,AnRect.Bottom);
    end
    else
    begin
     AnRect.Right:=Round((ARect.Right-ARect.Left) * AGradient[i].endPercent + ARect.Left);
     AnRect.Left:=OldRect.Right;
     Point1:=PointF(AnRect.Left,AnRect.Top);
     Point2:=PointF(AnRect.Right,AnRect.Top);
    end;
    Result.GradientFill(AnRect.Left,AnRect.Top,AnRect.Right,AnRect.Bottom,
      AGradient[i].StartColor,AGradient[i].StopColor,gtLinear,Point1,Point2,dmSet,True);
    OldRect := AnRect;
  end;
end;

function nGradientAlphaFill(AWidth, AHeight: Integer; ADir: TGradientDirection;
  const AGradient: array of TnGradientInfo): TBGRABitmap;
begin
  result := nGradientAlphaFill(Rect(0,0,AWidth,AHeight),ADir,AGradient);
end;

procedure nGradientAlphaFill(ACanvas: TCanvas; ARect: TRect;
  ADir: TGradientDirection; const AGradient: array of TnGradientInfo);
var
  bmp: TBGRABitmap;
begin
  bmp := nGradientAlphaFill(ARect, ADir, AGradient);
  bmp.Draw(ACanvas,ARect.Left,ARect.Top,not bmp.HasTransparentPixels);
  bmp.Free;
end;

procedure nGradientAlphaFill(ABitmap: TBGRABitmap; ARect: TRect;
  ADir: TGradientDirection; const AGradient: array of TnGradientInfo);
var
  bmp: TBGRABitmap;
begin
  bmp := nGradientAlphaFill(ARect, ADir, AGradient);
  ABitmap.PutImage(ARect.Left,ARect.Top,bmp,dmDrawWithTransparency);
  bmp.Free;
end;

{ TPhongShading }

constructor TPhongShading.Create;
begin
  LightSourceIntensity := 500;
  LightSourceDistanceTerm := 150;
  LightColor := BGRAWhite;
  AmbientFactor := 0.3;
  DiffusionFactor := 0.9;
  NegativeDiffusionFactor := 0.1;
  SpecularFactor := 0.6;
  SpecularIndex := 10;
  LightPosition := Point(-100,-100);
  LightPositionZ := -100;
end;

procedure TPhongShading.normalize(var x,y,z: double);
var len: double;
begin
  len := x*x+y*y+z*z;
  if len = 0 then exit;
  len := sqrt(len);
  x /= len;
  y /= len;
  z /= len;
end;

procedure TPhongShading.vectproduct(u1,u2,u3,v1,v2,v3: integer; out w1,w2,w3: double);
begin
  w1 := u2*v3-u3*v2;
  w2 := u3*v1-u1*v3;
  w3 := u1*v2-u2*v1;
end;

procedure TPhongShading.vectproduct(u1, u2, u3, v1, v2, v3: double; out w1, w2,
  w3: double);
begin
  w1 := u2*v3-u3*v2;
  w2 := u3*v1-u1*v3;
  w3 := u1*v2-u2*v1;
end;

procedure TPhongShading.Draw(dest: TBGRABitmap; map: TBGRABitmap; mapAltitude: integer; ofsX,ofsY: integer;
                             Color : TBGRAPixel);
var
  //Light source normal.
  Lx,Ly,Lz: double;
  //Light source position.
  dx,dy,dz: integer;
  //Vector H is the unit normal to the hypothetical surface oriented
  //halfway between the light direction vector (L) and the viewing vector (V).
  Hx,Hy,Hz: double;

  procedure CalculateLNandNnH( x,y: integer; z: double;
                        xn,yn,zn: double; out LdotN, dist, NnH: double); inline;
  var
    NH: Double;
  begin
    LdotN := xn*Lx + yn*Ly + zn*Lz;
    dist := sqrt((dx - x)*(dx - x) + (dy - y)*(dy - y) + (dz - z)*(dz - z));

    if LdotN > 0 then
    begin
      NH := Hx*xn + Hy*yn + Hz*zn;
      if NH < 0 then
      begin
        NH := 0;
        NnH := 0;
      end else
        NnH := exp(SpecularIndex*ln(NH));
    end else
    begin
      NH := 0;
      NnH := 0;
    end;
  end;

var
  Iw, Ic: integer; // Ir = intensity of Red, Igb = intensity of green/blue.
  x,y : integer;  // Coordinates of point on sphere surface.
  z, xn, yn, zn, LdotN, NnH,
  dist, distfactor, diffuseterm, specularterm: double;
  eColor,eLight,ec: TExpandedPixel;
  mc,mcLeft,mcRight,mcTop,mcBottom: TBGRAPixel;
  v1x,v1y,v1z,v2x,v2y,v2z: integer;

  minx,miny,maxx,maxy: integer;
  pmap: PBGRAPixel;
  pdest: PBGRAPixel;

begin
  if ofsX >= dest.Width then exit;
  if ofsY >= dest.Height then exit;
  if ofsX <= -map.Width then exit;
  if ofsY <= -map.Height then exit;
  if (map.width = 0) or (map.Height = 0) then exit;

  minx := 0;
  miny := 0;
  maxx := map.Width-1;
  maxy := map.Height-1;
  if ofsX < 0 then minx := -ofsX;
  if ofsY < 0 then miny := -ofsY;
  if OfsX+maxx > dest.width-1 then maxx := dest.width-1-ofsX;
  if OfsY+maxy > dest.height-1 then maxy := dest.height-1-ofsY;

  dx := LightPosition.X-ofsX;
  dy := LightPosition.Y-ofsY;
  dz := LightPositionZ;

  eLight := GammaExpansion(LightColor);
  eColor := GammaExpansion(color);
  ec.alpha := eColor.alpha;

  v1x := 510;
  v1y := 0;

  v2x := 0;
  v2y := 510;

  dist := 0;
  LdotN := 0;
  NnH := 0;

  for y := miny to maxy do
  begin
    pmap := map.ScanLine[y]+minx;
    mc := BGRAPixelTransparent;
    mcRight := pmap^;
    pdest := dest.ScanLine[y+ofsY]+ofsX+minx;
    for x := minx to maxx do
    begin
      mcLeft := mc;
      mc := mcRight;
      inc(pmap);
      if x < map.width-1 then
        mcRight := pmap^ else
        mcRight := BGRAPixelTransparent;

      if mc.alpha <> 0 then
      begin
        mcTop := map.GetPixel(x,y-1);
        mcBottom := map.GetPixel(x,y+1);
        z := mc.red/255*mapAltitude;
        if mcLeft.alpha = 0 then
        begin
          if mcRight.alpha = 0 then
            v1z := 0
          else
            v1z := (mcRight.red-mc.red)*mapAltitude*2;
        end else
        begin
          if mcRight.alpha = 0 then
            v1z := (mc.red-mcLeft.red)*mapAltitude*2
          else
            v1z := (mcRight.red-mcLeft.red)*mapAltitude;
        end;
        if mcTop.alpha = 0 then
        begin
          if mcBottom.alpha = 0 then
            v2z := 0
          else
            v2z := (mcBottom.red-mc.red)*mapAltitude*2;
        end else
        begin
          if mcBottom.alpha = 0 then
            v2z := (mc.red-mcTop.red)*mapAltitude*2
          else
            v2z := (mcBottom.red-mcTop.red)*mapAltitude;
        end;

        Lx := dx-x;
        Ly := dy-y;
        Lz := dz-z;
        normalize(Lx,Ly,Lz);

        Hx := Lx + 0;
        Hy := Ly + 0;
        Hz := Lz + 1;
        normalize(Hx,Hy,Hz);

        // xn, yn, and zn are unit normals from the surface.
        vectproduct(v1x,v1y,v1z,v2x,v2y,v2z,xn,yn,zn);
        normalize(xn,yn,zn);
        CalculateLNandNnH(x, y, z, xn, yn, zn, LdotN, dist, NnH);
        distfactor := LightSourceIntensity / (dist + LightSourceDistanceTerm);
        if (LdotN <= 0) then
        begin
          //Point is not illuminated by light source.
          //Use only ambient component and negative diffuse for contrast
          diffuseterm := distfactor * NegativeDiffusionFactor * LdotN;
          Ic := round((AmbientFactor + diffuseterm)*256);
          Iw := 0;
        end else
        begin
          diffuseterm := distfactor * DiffusionFactor * LdotN;
          specularterm := distfactor * SpecularFactor * NnH;
          Ic := round((AmbientFactor + diffuseterm)*256);
          Iw := round(specularterm*256);
        end;
        If Ic < 0 then Ic := 0;
        If Ic > 256 then Ic := 256;
        if Iw > 256 then Iw := 256;
        Ic := Ic*(256-Iw) shr 8;

        ec.red := (eColor.Red*Ic+eLight.Red*Iw+128) shr 8;
        ec.green := (eColor.Green*Ic+eLight.Green*Iw+128) shr 8;
        ec.blue := (eColor.Blue*Ic+eLight.Blue*Iw+128) shr 8;
        ec.alpha := mc.alpha shl 8+mc.alpha;
        DrawPixelInline(pdest, GammaCompression(ec));
      end;
      inc(pdest);
    end;
  end;
end;

procedure TPhongShading.Draw(dest: TBGRABitmap; map: TBGRABitmap;
  mapAltitude: integer; ofsX, ofsY: integer; ColorMap: TBGRABitmap);
var
  //Light source normal.
  Lx,Ly,Lz: double;
  //Light source position.
  dx,dy,dz: integer;
  //Vector H is the unit normal to the hypothetical surface oriented
  //halfway between the light direction vector (L) and the viewing vector (V).
  Hx,Hy,Hz: double;

  procedure CalculateLNandNnH( x,y: integer; z: double;
                        xn,yn,zn: double; out LdotN, dist, NnH: double); inline;
  var
    NH: Double;
  begin
    LdotN := xn*Lx + yn*Ly + zn*Lz;
    dist := sqrt((dx - x)*(dx - x) + (dy - y)*(dy - y) + (dz - z)*(dz - z));

    if LdotN > 0 then
    begin
      NH := Hx*xn + Hy*yn + Hz*zn;
      if NH < 0 then
      begin
        NH := 0;
        NnH := 0;
      end else
        NnH := exp(SpecularIndex*ln(NH));
    end else
    begin
      NH := 0;
      NnH := 0;
    end;
  end;

var
  Iw, Ic: integer; // Ir = intensity of Red, Igb = intensity of green/blue.
  x,y : integer;  // Coordinates of point on sphere surface.
  z, xn, yn, zn, LdotN, NnH,
  dist, distfactor, diffuseterm, specularterm: double;
  eColor,eLight,ec: TExpandedPixel;
  mc,mcLeft,mcRight,mcTop,mcBottom: TBGRAPixel;
  v1x,v1y,v1z,v2x,v2y,v2z: integer;

  minx,miny,maxx,maxy: integer;
  pmap: PBGRAPixel;
  pdest: PBGRAPixel;

begin
  if ofsX >= dest.Width then exit;
  if ofsY >= dest.Height then exit;
  if ofsX <= -map.Width then exit;
  if ofsY <= -map.Height then exit;
  if (map.width = 0) or (map.Height = 0) then exit;

  minx := 0;
  miny := 0;
  maxx := map.Width-1;
  maxy := map.Height-1;
  if ofsX < 0 then minx := -ofsX;
  if ofsY < 0 then miny := -ofsY;
  if OfsX+maxx > dest.width-1 then maxx := dest.width-1-ofsX;
  if OfsY+maxy > dest.height-1 then maxy := dest.height-1-ofsY;

  dx := LightPosition.X-ofsX;
  dy := LightPosition.Y-ofsY;
  dz := LightPositionZ;

  eLight := GammaExpansion(LightColor);

  v1x := 510;
  v1y := 0;

  v2x := 0;
  v2y := 510;

  dist := 0;
  LdotN := 0;
  NnH := 0;

  for y := miny to maxy do
  begin
    pmap := map.ScanLine[y]+minx;
    mc := BGRAPixelTransparent;
    mcRight := pmap^;
    pdest := dest.ScanLine[y+ofsY]+ofsX+minx;
    for x := minx to maxx do
    begin
      mcLeft := mc;
      mc := mcRight;
      inc(pmap);
      if x < map.width-1 then
        mcRight := pmap^ else
        mcRight := BGRAPixelTransparent;

      if mc.alpha <> 0 then
      begin
        mcTop := map.GetPixel(x,y-1);
        mcBottom := map.GetPixel(x,y+1);
        z := mc.red/255*mapAltitude;
        if mcLeft.alpha = 0 then
        begin
          if mcRight.alpha = 0 then
            v1z := 0
          else
            v1z := (mcRight.red-mc.red)*mapAltitude*2;
        end else
        begin
          if mcRight.alpha = 0 then
            v1z := (mc.red-mcLeft.red)*mapAltitude*2
          else
            v1z := (mcRight.red-mcLeft.red)*mapAltitude;
        end;
        if mcTop.alpha = 0 then
        begin
          if mcBottom.alpha = 0 then
            v2z := 0
          else
            v2z := (mcBottom.red-mc.red)*mapAltitude*2;
        end else
        begin
          if mcBottom.alpha = 0 then
            v2z := (mc.red-mcTop.red)*mapAltitude*2
          else
            v2z := (mcBottom.red-mcTop.red)*mapAltitude;
        end;

        Lx := dx-x;
        Ly := dy-y;
        Lz := dz-z;
        normalize(Lx,Ly,Lz);

        Hx := Lx + 0;
        Hy := Ly + 0;
        Hz := Lz + 1;
        normalize(Hx,Hy,Hz);

        // xn, yn, and zn are unit normals from the surface.
        vectproduct(v1x,v1y,v1z,v2x,v2y,v2z,xn,yn,zn);
        normalize(xn,yn,zn);
        CalculateLNandNnH(x, y, z, xn, yn, zn, LdotN, dist, NnH);
        distfactor := LightSourceIntensity / (dist + LightSourceDistanceTerm);
        if (LdotN <= 0) then
        begin
          //Point is not illuminated by light source.
          //Use only ambient component and negative diffuse for contrast
          diffuseterm := distfactor * NegativeDiffusionFactor * LdotN;
          Ic := round((AmbientFactor + diffuseterm)*256);
          Iw := 0;
        end else
        begin
          diffuseterm := distfactor * DiffusionFactor * LdotN;
          specularterm := distfactor * SpecularFactor * NnH;
          Ic := round((AmbientFactor + diffuseterm)*256);
          Iw := round(specularterm*256);
        end;
        If Ic < 0 then Ic := 0;
        If Ic > 256 then Ic := 256;
        if Iw > 256 then Iw := 256;
        Ic := Ic*(256-Iw) shr 8;

        eColor := GammaExpansion(colorMap.GetPixel(x,y));

        ec.red := (eColor.Red*Ic+eLight.Red*Iw+128) shr 8;
        ec.green := (eColor.Green*Ic+eLight.Green*Iw+128) shr 8;
        ec.blue := (eColor.Blue*Ic+eLight.Blue*Iw+128) shr 8;
        ec.alpha := mc.alpha shl 8+mc.alpha;
        DrawPixelInline(pdest, GammaCompression(ec));
      end;
      inc(pdest);
    end;
  end;
end;

procedure TPhongShading.DrawCone(dest: TBGRABitmap; X, Y, Size,
  Altitude: Integer; Color: TBGRAPixel);
var map: TBGRABitmap;
begin
  map := CreateConeMap(Size);
  Draw(dest,map,Altitude,X,Y,Color);
  map.Free;
end;

procedure TPhongShading.DrawSphere(dest: TBGRABitmap; bounds: TRect;
  Altitude: Integer; Color: TBGRAPixel);
var map: TBGRABitmap;
    temp: integer;
begin
  if Bounds.Right < Bounds.Left then
  begin
    temp := Bounds.Left;
    bounds.Left := bounds.Right;
    Bounds.Right := temp;
  end;
  if Bounds.Bottom < Bounds.Top then
  begin
    temp := Bounds.Bottom;
    bounds.Bottom := bounds.Top;
    Bounds.Top := temp;
  end;
  map := CreateSphereMap(Bounds.Right-Bounds.Left,Bounds.Bottom-Bounds.Top);
  Draw(dest,map,Altitude,bounds.Left,bounds.Top,Color);
  map.Free;
end;

procedure TPhongShading.DrawRectangle(dest: TBGRABitmap; bounds: TRect;
  Border,Altitude: Integer; Color: TBGRAPixel; RoundCorners: Boolean; Options: TRectangleMapOptions);
var map: TBGRABitmap;
    temp: integer;
begin
  if Bounds.Right < Bounds.Left then
  begin
    temp := Bounds.Left;
    bounds.Left := bounds.Right;
    Bounds.Right := temp;
  end;
  if Bounds.Bottom < Bounds.Top then
  begin
    temp := Bounds.Bottom;
    bounds.Bottom := bounds.Top;
    Bounds.Top := temp;
  end;
  if RoundCorners then
    map := CreateRoundRectangleMap(Bounds.Right-Bounds.Left,Bounds.Bottom-Bounds.Top,Border,Options)
  else
    map := CreateRectangleMap(Bounds.Right-Bounds.Left,Bounds.Bottom-Bounds.Top,Border,Options);
  Draw(dest,map,Altitude,bounds.Left,bounds.Top,Color);
  map.Free;
end;

{************************ maps ***********************************}

function CreateConeMap(size: integer): TBGRABitmap;
var cx,cy,r: single;
    mask: TBGRABitmap;
begin
  cx := (size-1)/2;
  cy := (size-1)/2;
  r := (size-1)/2;
  result := TBGRABitmap.Create(size,size);
  result.GradientFill(0,0,size,size,BGRAWhite,BGRABlack,gtRadial,PointF(cx,cy),PointF(cx+r,cy),dmSet,False);

  mask := TBGRABitmap.Create(size,size,BGRABlack);
  mask.FillEllipseAntialias(cx,cy,r,r,BGRAWhite);
  result.ApplyMask(mask);
  mask.Free;
end;

function CreateSphereMap(width,height: integer): TBGRABitmap;
var cx,cy,rx,ry,d: single;
    xb,yb: integer;
    p: PBGRAPixel;
    h: integer;
    mask: TBGRABitmap;
begin
  result := TBGRABitmap.Create(width,height);
  cx := (width-1)/2;
  cy := (height-1)/2;
  rx := (width-1)/2;
  ry := (height-1)/2;
  for yb := 0 to height-1 do
  begin
   p := result.scanline[yb];
   for xb := 0 to width-1 do
   begin
     d := sqr((xb-cx)/(rx+1))+sqr((yb-cy)/(ry+1));
     if d >= 1 then
       p^ := BGRAPixelTransparent else
     begin
       h := round(sqrt(1-d)*255);
       p^.red := h;
       p^.green := h;
       p^.blue := h;
       p^.alpha := 255;
     end;
     inc(p);
   end;
  end;
  mask := TBGRABitmap.Create(width,height,BGRABlack);
  mask.FillEllipseAntialias(cx,cy,rx,ry,BGRAWhite);
  result.ApplyMask(mask);
  mask.Free;
end;

function CreateRectangleMap(width,height,border: integer; options: TRectangleMapOptions = []): TBGRABitmap;
var xb,yb: integer;
    p: PBGRAPixel;
    h: integer;
begin
  if border*2 > width then border := width div 2;
  if border*2 > height then border := height div 2;

  result := TBGRABitmap.Create(width,height);
  for yb := 0 to height-1 do
  begin
   p := result.scanline[yb];
   for xb := 0 to width-1 do
   begin
     if not (rmoNoLeftBorder in options) and (xb < border) and (yb > xb) and (yb < height-1-xb) then h := xb else
     if not (rmoNoRightBorder in options) and (xb > width-1-border) and (yb > width-1-xb) and (yb < height-1-(width-1-xb)) then h := width-1-xb else
     if not (rmoNoTopBorder in options) and (yb < border) then h := yb else
     if not (rmoNoBottomBorder in options) and (yb > height-1-border) then h := height-1-yb else
     if not (rmoNoLeftBorder in options) and (xb < border) then h := xb else
     if not (rmoNoRightBorder in options) and (xb > width-1-border) then h := width-1-xb else
     begin
       p^ := BGRAWhite;
       inc(p);
       Continue;
     end;

     h := round(sin((h+1/2)/border*Pi/2)*255);
     p^.red := h;
     p^.green := h;
     p^.blue := h;
     p^.alpha := 255;
     inc(p);
   end;
  end;

  if [rmoNoLeftBorder,rmoNoTopBorder]*Options = [] then
  begin
    result.SetPixel(0,0,BGRAPixelTransparent);
    result.ErasePixel(1,0,128);
    result.ErasePixel(0,1,128);
  end;

  if [rmoNoRightBorder,rmoNoTopBorder]*Options = [] then
  begin
    result.SetPixel(width-1,0,BGRAPixelTransparent);
    result.ErasePixel(width-2,0,128);
    result.ErasePixel(width-1,1,128);
  end;

  if [rmoNoRightBorder,rmoNoBottomBorder]*Options = [] then
  begin
    result.SetPixel(width-1,height-1,BGRAPixelTransparent);
    result.ErasePixel(width-2,height-1,128);
    result.ErasePixel(width-1,height-2,128);
  end;

  if [rmoNoLeftBorder,rmoNoBottomBorder]*Options = [] then
  begin
    result.SetPixel(0,height-1,BGRAPixelTransparent);
    result.ErasePixel(1,height-1,128);
    result.ErasePixel(0,height-2,128);
  end;
end;

function CreateRoundRectangleMap(width,height,border: integer; options: TRectangleMapOptions = []): TBGRABitmap;
var d: single;
    xb,yb: integer;
    p: PBGRAPixel;
    h: integer;
begin
  if border*2 > width then border := width div 2;
  if border*2 > height then border := height div 2;
  result := TBGRABitmap.Create(width,height);
  for yb := 0 to height-1 do
  begin
   p := result.scanline[yb];
   for xb := 0 to width-1 do
   begin
     if not (rmoNoLeftBorder in options) and not (rmoNoTopBorder in options) and (xb < border) and (yb < border) then d := border-sqrt(sqr(border-xb)+sqr(border-yb)) else
     if not (rmoNoLeftBorder in options) and not (rmoNoBottomBorder in options) and (xb < border) and (yb > height-1-border) then d := border-sqrt(sqr(border-xb)+sqr(border-(height-1-yb))) else
     if not (rmoNoRightBorder in options) and not (rmoNoTopBorder in options) and (xb > width-1-border) and (yb < border) then d := border-sqrt(sqr(border-(width-1-xb))+sqr(border-yb)) else
     if not (rmoNoRightBorder in options) and not (rmoNoBottomBorder in options) and (xb > width-1-border) and (yb > height-1-border) then d := border-sqrt(sqr(border-(width-1-xb))+sqr(border-(height-1-yb))) else
     if not (rmoNoLeftBorder in options) and (xb < border) then d := xb else
     if not (rmoNoRightBorder in options) and (xb > width-1-border) then d := width-1-xb else
     if not (rmoNoTopBorder in options) and (yb < border) then d := yb else
     if not (rmoNoBottomBorder in options) and (yb > height-1-border) then d := height-1-yb else
     begin
       p^ := BGRAWhite;
       inc(p);
       Continue;
     end;

     if d < 0 then
       p^ := BGRAPixelTransparent else
     begin
       h := round(sin((d+1/2)/border*Pi/2)*255);
       p^.red := h;
       p^.green := h;
       p^.blue := h;
       if d < 1 then p^.alpha := round(d*255) else
         p^.alpha := 255;
     end;
     inc(p);
   end;
  end;
end;

function CreatePerlinNoiseMap(AWidth, AHeight: integer; HorizontalPeriod: Single;
  VerticalPeriod: Single; Exponent: Double = 1): TBGRABitmap;

  procedure AddNoise(frequencyH, frequencyV: integer; amplitude: byte; dest: TBGRABitmap);
  var small,resampled: TBGRABitmap;
      p: PBGRAPixel;
      i: Integer;
  begin
    if (frequencyH = 0) or (frequencyV = 0) then exit;
    small := TBGRABitmap.Create(frequencyH,frequencyV);
    p := small.data;
    for i := 0 to small.NbPixels-1 do
    begin
      p^.red := random(amplitude);
      p^.green := p^.red;
      p^.blue := p^.green;
      p^.alpha := 255;
      inc(p);
    end;
    resampled := small.Resample(dest.Width,dest.Height) as TBGRABitmap;
    dest.BlendImage(0,0,resampled,boAdditive);
    resampled.Free;
    small.Free;
  end;

var
  i: Integer;
  temp: TBGRABitmap;

begin
  result := TBGRABitmap.Create(AWidth,AHeight);
  for i := 0 to 5 do
    AddNoise(round(AWidth / HorizontalPeriod / (32 shr i)),round(AHeight / VerticalPeriod / (32 shr i)), round(exp(ln((128 shr i)/128)*Exponent)*128),result);

  temp := result.FilterNormalize(False) as TBGRABitmap;
  result.Free;
  result := temp;

  temp := result.FilterBlurRadial(1,rbNormal) as TBGRABitmap;
  result.Free;
  result := temp;
end;

end.

