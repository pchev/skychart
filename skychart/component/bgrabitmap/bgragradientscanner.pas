unit BGRAGradientScanner;

{$mode objfpc}{$H+}

interface

{ This unit contains scanners that generate gradients }

uses
  Classes, SysUtils, BGRABitmapTypes, BGRATransform;

type

  { TBGRAGradientScanner }

  TBGRAGradientScanner = class(TBGRACustomScanner)
    FCurX,FCurY: integer;
    FColor1,FColor2: TBGRAPixel;
    FGradientType: TGradientType;
    FOrigin1,FOrigin2: TPointF;
    FGammaCorrection: Boolean;
    FSinus: Boolean;
    u: TPointF;
    len: single;
    ec1,ec2: TExpandedPixel;
    mergedColor: TBGRAPixel;
  public
    constructor Create(c1, c2: TBGRAPixel; gtype: TGradientType; o1, o2: TPointF;
                       gammaColorCorrection: boolean = True; Sinus: Boolean=False);
    procedure ScanMoveTo(X, Y: Integer); override;
    function ScanNextPixel: TBGRAPixel; override;
    function ScanAt(X, Y: Single): TBGRAPixel; override;
  end;

  { TBGRAGradientTriangleScanner }

  TBGRAGradientTriangleScanner= class(TBGRACustomScanner)
  protected
    FMatrix: TAffineMatrix;
    FColor1,FDiff2,FDiff3,FStep: TColorF;
    FCurColor: TColorF;
  public
    constructor Create(pt1,pt2,pt3: TPointF; c1,c2,c3: TBGRAPixel);
    procedure ScanMoveTo(X,Y: Integer); override;
    procedure ScanMoveToF(X,Y: Single);
    function ScanAt(X,Y: Single): TBGRAPixel; override;
    function ScanNextPixel: TBGRAPixel; override;
  end;

implementation

{ TBGRAGradientTriangleScanner }

constructor TBGRAGradientTriangleScanner.Create(pt1, pt2, pt3: TPointF; c1, c2,
  c3: TBGRAPixel);
var ec1,ec2,ec3: TExpandedPixel;
begin
  FMatrix := AffineMatrix(pt2.X-pt1.X, pt3.X-pt1.X, 0,
                          pt2.Y-pt1.Y, pt3.Y-pt1.Y, 0);
  if not IsAffineMatrixInversible(FMatrix) then
    FMatrix := AffineMatrix(0,0,0,0,0,0)
  else
    FMatrix := AffineMatrixInverse(FMatrix) * AffineMatrixTranslation(-pt1.x,-pt1.y);

  ec1 := GammaExpansion(c1);
  ec2 := GammaExpansion(c2);
  ec3 := GammaExpansion(c3);
  FColor1[1] := ec1.red;
  FColor1[2] := ec1.green;
  FColor1[3] := ec1.blue;
  FColor1[4] := ec1.alpha;
  FDiff2[1] := ec2.red - ec1.red;
  FDiff2[2] := ec2.green - ec1.green;
  FDiff2[3] := ec2.blue - ec1.blue;
  FDiff2[4] := ec2.alpha - ec1.alpha;
  FDiff3[1] := ec3.red - ec1.red;
  FDiff3[2] := ec3.green - ec1.green;
  FDiff3[3] := ec3.blue - ec1.blue;
  FDiff3[4] := ec3.alpha - ec1.alpha;
  FStep := FDiff2*FMatrix[1,1]+FDiff3*FMatrix[2,1];
end;

procedure TBGRAGradientTriangleScanner.ScanMoveTo(X, Y: Integer);
begin
  ScanMoveToF(X, Y);
end;

procedure TBGRAGradientTriangleScanner.ScanMoveToF(X, Y: Single);
var
  Cur: TPointF;
begin
  Cur := FMatrix*PointF(X,Y);
  FCurColor := FColor1+FDiff2*Cur.X+FDiff3*Cur.Y;
end;

function TBGRAGradientTriangleScanner.ScanAt(X, Y: Single): TBGRAPixel;
begin
  ScanMoveToF(X,Y);
  result := ScanNextPixel;
end;

function TBGRAGradientTriangleScanner.ScanNextPixel: TBGRAPixel;
var r,g,b,a: int64;
begin
  r := round(FCurColor[1]);
  g := round(FCurColor[2]);
  b := round(FCurColor[3]);
  a := round(FCurColor[4]);
  if r > 65535 then r := 65535 else
  if r < 0 then r := 0;
  if g > 65535 then g := 65535 else
  if g < 0 then g := 0;
  if b > 65535 then b := 65535 else
  if b < 0 then b := 0;
  if a > 65535 then a := 65535 else
  if a < 0 then a := 0;
  result.red := GammaCompressionTab[r];
  result.green := GammaCompressionTab[g];
  result.blue := GammaCompressionTab[b];
  result.alpha := a shr 8;
  FCurColor += FStep;
end;

{ TBGRAGradientScanner }

constructor TBGRAGradientScanner.Create(c1, c2: TBGRAPixel;
  gtype: TGradientType; o1, o2: TPointF; gammaColorCorrection: boolean;
  Sinus: Boolean);
var eMergedColor: TExpandedPixel;
begin
  //transparent pixels have no color so
  //take it from other color
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

  FColor1 := c1;
  FColor2 := c2;
  FGradientType:= gtype;
  FOrigin1 := o1;
  FOrigin2 := o2;
  FGammaCorrection:= gammaColorCorrection;
  FSinus := Sinus;

  //compute vector
  u.x := o2.x - o1.x;
  u.y := o2.y - o1.y;
  len := sqrt(sqr(u.x) + sqr(u.y));
  u.x /= len;
  u.y /= len;

  if FGammaCorrection then
  begin
    ec1 := GammaExpansion(c1);
    ec2 := GammaExpansion(c2);
    eMergedColor.red := (ec1.red+ec2.red) div 2;
    eMergedColor.green := (ec1.green+ec2.green) div 2;
    eMergedColor.blue := (ec1.blue+ec2.blue) div 2;
    eMergedColor.alpha := (ec1.alpha+ec2.alpha) div 2;
    mergedColor := GammaCompression(eMergedColor);
  end else
    mergedColor := MergeBGRA(c1,c2);
end;

procedure TBGRAGradientScanner.ScanMoveTo(X, Y: Integer);
begin
  FCurX := X;
  FCurY := Y;
end;

function TBGRAGradientScanner.ScanNextPixel: TBGRAPixel;
begin
  result := ScanAt(FCurX,FCurY);
  Inc(FCurX);
end;

function TBGRAGradientScanner.ScanAt(X, Y: Single): TBGRAPixel;
var p: TPointF;
    b,b2: cardinal;
    a,a2: single;
    ec: TExpandedPixel;
    ai: int64;
begin
  if len = 0 then
  begin
    result := mergedColor;
    exit;
  end;

  p.x := X - FOrigin1.x;
  p.y := Y - FOrigin1.y;
  case FGradientType of
    gtLinear:    a := p.x * u.x + p.y * u.y;
    gtReflected: a := abs(p.x * u.x + p.y * u.y);
    gtDiamond:
        begin
          a   := abs(p.x * u.x + p.y * u.y);
          a2  := abs(p.x * u.y - p.y * u.x);
          if a2 > a then a := a2;
        end;
    gtRadial:    a := sqrt(sqr(p.x * u.x + p.y * u.y) + sqr(p.x * u.y - p.y * u.x));
  end;
  ai := round(a/len*65536);
  if FSinus then ai := Sin65536(ai);

  if ai <= 0 then
    result := FColor1
  else
  if ai >= 65536 then
    result := FColor2
  else
  if FGammaCorrection then
  begin
    b      := ai;
    b2     := 65536-b;
    ec.red := (ec1.red * b2 + ec2.red * b + 32767) shr 16;
    ec.green := (ec1.green * b2 + ec2.green * b + 32767) shr 16;
    ec.blue := (ec1.blue * b2 + ec2.blue * b + 32767) shr 16;
    ec.alpha := (ec1.alpha * b2 + ec2.alpha * b + 32767) shr 16;
    result := GammaCompression(ec);
  end else
  begin
    b      := ai shr 6;
    b2     := 1024-b;
    result.red  := (FColor1.red * b2 + FColor2.red * b + 511) shr 10;
    result.green := (FColor1.green * b2 + FColor2.green * b + 511) shr 10;
    result.blue := (FColor1.blue * b2 + FColor2.blue * b + 511) shr 10;
    result.alpha := (FColor1.alpha * b2 + FColor2.alpha * b + 511) shr 10;
  end;
end;

end.

