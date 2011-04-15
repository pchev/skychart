unit BGRAGradientScanner;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, BGRABitmapTypes;

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

implementation

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

