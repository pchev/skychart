unit BGRATransform;

{$mode objfpc}

interface

{ This unit contains bitmap transformations as classes and the TAffineMatrix record and functions. }

uses
  Classes, SysUtils, BGRABitmapTypes;

type
  { Contains an affine matrix, i.e. a matrix to transform linearly and translate TPointF coordinates }
  TAffineMatrix = array[1..2,1..3] of single;

  { TBGRAAffineScannerTransform allow to transform any scanner. To use it,
    create this object with a scanner as parameter, call transformation
    procedures, and finally, use the newly created object as a scanner.

    You can transform a gradient or a bitmap. See TBGRAAffineBitmapTransform
    for bitmap specific transformation. }

  { TBGRAAffineScannerTransform }

  TBGRAAffineScannerTransform = class(TBGRACustomScanner)
  protected
    FScanner: IBGRAScanner;
    FCurX,FCurY: Single;
    FEmptyMatrix: Boolean;
    FMatrix: TAffineMatrix;
    procedure SetMatrix(AMatrix: TAffineMatrix);
    function InternalScanCurrentPixel: TBGRAPixel; virtual;
  public
    constructor Create(AScanner: IBGRAScanner);
    procedure Reset;
    procedure Invert;
    procedure Translate(OfsX,OfsY: Single);
    procedure RotateDeg(Angle: Single);
    procedure RotateRad(Angle: Single);
    procedure MultiplyBy(AMatrix: TAffineMatrix);
    procedure Fit(Origin,HAxis,VAxis: TPointF); virtual;
    procedure Scale(sx,sy: single); overload;
    procedure Scale(factor: single); overload;
    procedure ScanMoveTo(X, Y: Integer); override;
    procedure ScanMoveToF(X, Y: single); inline;
    function ScanNextPixel: TBGRAPixel; override;
    function ScanAt(X, Y: Single): TBGRAPixel; override;
    property Matrix: TAffineMatrix read FMatrix write SetMatrix;
  end;

  { If you don't want the bitmap to repeats itself, or want to specify the
    resample filter, or want to fit easily the bitmap on axes,
    use TBGRAAffineBitmapTransform instead of TBGRAAffineScannerTransform }

  { TBGRAAffineBitmapTransform }

  TBGRAAffineBitmapTransform = class(TBGRAAffineScannerTransform)
  protected
    FBitmap: TBGRACustomBitmap;
    FRepeatImage: boolean;
    FResampleFilter : TResampleFilter;
  public
    constructor Create(ABitmap: TBGRACustomBitmap; ARepeatImage: Boolean= false; AResampleFilter: TResampleFilter = rfLinear);
    function InternalScanCurrentPixel: TBGRAPixel; override;
    procedure Fit(Origin, HAxis, VAxis: TPointF); override;
  end;

{---------------------- Affine matrix functions -------------------}
//fill a matrix
function AffineMatrix(m11,m12,m13,m21,m22,m23: single): TAffineMatrix;

//matrix multiplication
operator *(M,N: TAffineMatrix): TAffineMatrix;

//matrix multiplication by a vector (apply transformation to that vector)
operator *(M: TAffineMatrix; V: TPointF): TPointF;

//check if matrix is inversible
function IsAffineMatrixInversible(M: TAffineMatrix): boolean;

//compute inverse (check if inversible before)
function AffineMatrixInverse(M: TAffineMatrix): TAffineMatrix;

//define a translation matrix
function AffineMatrixTranslation(OfsX,OfsY: Single): TAffineMatrix;

//define a scaling matrix
function AffineMatrixScale(sx,sy: single): TAffineMatrix;

//define a rotation matrix (positive radians are counter clock wise)
function AffineMatrixRotationRad(Angle: Single): TAffineMatrix;

//Positive degrees are clock wise
function AffineMatrixRotationDeg(Angle: Single): TAffineMatrix;

//define the identity matrix (that do nothing)
function AffineMatrixIdentity: TAffineMatrix;

type
  { TBGRATriangleLinearMapping is a scanner that provides
    an optimized transformation for linear texture mapping
    on triangles }

  { TBGRATriangleLinearMapping }

  TBGRATriangleLinearMapping = class(TBGRACustomScanner)
  protected
    FScanner: IBGRAScanner;
    FMatrix: TAffineMatrix;
    FTexCoord1,FDiff2,FDiff3,FStep: TPointF;
    FCurTexCoord: TPointF;
  public
    constructor Create(AScanner: IBGRAScanner; pt1,pt2,pt3: TPointF; tex1,tex2,tex3: TPointF);
    procedure ScanMoveTo(X,Y: Integer); override;
    procedure ScanMoveToF(X,Y: Single);
    function ScanAt(X,Y: Single): TBGRAPixel; override;
    function ScanNextPixel: TBGRAPixel; override;
  end;

type
  { TBGRATwirlScanner applies a twirl transformation.

    Note : this scanner handles integer coordinates only, so
    any further transformation applied after this one may not
    render correctly. }

  { TBGRATwirlScanner }

  TBGRATwirlScanner = Class(TBGRACustomScanner)
  protected
    FScanner: IBGRAScanner;
    FCenter: TPoint;
    FTurn, FRadius, FExponent: Single;
  public
    constructor Create(AScanner: IBGRAScanner; ACenter: TPoint; ARadius: single; ATurn: single = 1; AExponent: single = 3);
    function ScanAt(X, Y: Single): TBGRAPixel; override;
  end;

implementation

function AffineMatrix(m11, m12, m13, m21, m22, m23: single): TAffineMatrix;
begin
  result[1,1] := m11;
  result[1,2] := m12;
  result[1,3] := m13;
  result[2,1] := m21;
  result[2,2] := m22;
  result[2,3] := m23;
end;

operator *(M, N: TAffineMatrix): TAffineMatrix;
begin
  result[1,1] := M[1,1]*N[1,1] + M[1,2]*N[2,1];
  result[1,2] := M[1,1]*N[1,2] + M[1,2]*N[2,2];
  result[1,3] := M[1,1]*N[1,3] + M[1,2]*N[2,3] + M[1,3];

  result[2,1] := M[2,1]*N[1,1] + M[2,2]*N[2,1];
  result[2,2] := M[2,1]*N[1,2] + M[2,2]*N[2,2];
  result[2,3] := M[2,1]*N[1,3] + M[2,2]*N[2,3] + M[2,3];
end;

operator*(M: TAffineMatrix; V: TPointF): TPointF;
begin
  result.X := V.X*M[1,1]+V.Y*M[1,2]+M[1,3];
  result.Y := V.X*M[2,1]+V.Y*M[2,2]+M[2,3];
end;

function IsAffineMatrixInversible(M: TAffineMatrix): boolean;
begin
  result := M[1,1]*M[2,2]-M[1,2]*M[2,1] <> 0;
end;

function AffineMatrixInverse(M: TAffineMatrix): TAffineMatrix;
var det,f: single;
    linearInverse: TAffineMatrix;
begin
  det := M[1,1]*M[2,2]-M[1,2]*M[2,1];
  if det = 0 then
    raise Exception.Create('Not inversible');
  f := 1/det;
  linearInverse := AffineMatrix(M[2,2]*f,-M[1,2]*f,0,
                         -M[2,1]*f,M[1,1]*f,0);
  result := linearInverse * AffineMatrixTranslation(-M[1,3],-M[2,3]);
end;

function AffineMatrixTranslation(OfsX, OfsY: Single): TAffineMatrix;
begin
  result := AffineMatrix(1, 0, OfsX,
                         0, 1, OfsY);
end;

function AffineMatrixScale(sx, sy: single): TAffineMatrix;
begin
  result := AffineMatrix(sx, 0,    0,
                         0,  sy, 0);
end;

function AffineMatrixRotationRad(Angle: Single): TAffineMatrix;
begin
  result := AffineMatrix(cos(Angle),  sin(Angle), 0,
                         -sin(Angle), cos(Angle), 0);
end;

function AffineMatrixRotationDeg(Angle: Single): TAffineMatrix;
begin
  result := AffineMatrixRotationRad(-Angle*Pi/180);
end;

function AffineMatrixIdentity: TAffineMatrix;
begin
  result := AffineMatrix(1, 0, 0,
                         0, 1, 0);
end;

{ TBGRATriangleLinearMapping }

constructor TBGRATriangleLinearMapping.Create(AScanner: IBGRAScanner; pt1, pt2,
  pt3: TPointF; tex1, tex2, tex3: TPointF);
begin
  FScanner := AScanner;

  FMatrix := AffineMatrix(pt2.X-pt1.X, pt3.X-pt1.X, 0,
                          pt2.Y-pt1.Y, pt3.Y-pt1.Y, 0);
  if not IsAffineMatrixInversible(FMatrix) then
    FMatrix := AffineMatrix(0,0,0,0,0,0)
  else
    FMatrix := AffineMatrixInverse(FMatrix) * AffineMatrixTranslation(-pt1.x,-pt1.y);

  FTexCoord1 := tex1;
  FDiff2 := tex2-tex1;
  FDiff3 := tex3-tex1;
  FStep := FDiff2*FMatrix[1,1]+FDiff3*FMatrix[2,1];
end;

procedure TBGRATriangleLinearMapping.ScanMoveTo(X, Y: Integer);
begin
  ScanMoveToF(X, Y);
end;

procedure TBGRATriangleLinearMapping.ScanMoveToF(X, Y: Single);
var
  Cur: TPointF;
begin
  Cur := FMatrix*PointF(X,Y);
  FCurTexCoord := FTexCoord1+FDiff2*Cur.X+FDiff3*Cur.Y;
end;

function TBGRATriangleLinearMapping.ScanAt(X, Y: Single): TBGRAPixel;
begin
  ScanMoveToF(X,Y);
  result := ScanNextPixel;
end;

function TBGRATriangleLinearMapping.ScanNextPixel: TBGRAPixel;
begin
  result := FScanner.ScanAt(FCurTexCoord.X,FCurTexCoord.Y);
  FCurTexCoord += FStep;
end;

{ TBGRAAffineScannerTransform }

constructor TBGRAAffineScannerTransform.Create(AScanner: IBGRAScanner);
begin
  FScanner := AScanner;
  Reset;
end;

procedure TBGRAAffineScannerTransform.Reset;
begin
  FMatrix := AffineMatrixIdentity;
  FEmptyMatrix := False;
end;

procedure TBGRAAffineScannerTransform.Invert;
begin
  if not FEmptyMatrix and IsAffineMatrixInversible(FMatrix) then
    FMatrix := AffineMatrixInverse(FMatrix) else
      FEmptyMatrix := True;
end;

procedure TBGRAAffineScannerTransform.SetMatrix(AMatrix: TAffineMatrix);
begin
  FEmptyMatrix := False;
  FMatrix := AMatrix;
end;

procedure TBGRAAffineScannerTransform.Translate(OfsX, OfsY: Single);
begin
  MultiplyBy(AffineMatrixTranslation(-OfsX,-OfsY));
end;

procedure TBGRAAffineScannerTransform.RotateDeg(Angle: Single);
begin
  MultiplyBy(AffineMatrixRotationDeg(-Angle));
end;

procedure TBGRAAffineScannerTransform.RotateRad(Angle: Single);
begin
  MultiplyBy(AffineMatrixRotationRad(-Angle));
end;

procedure TBGRAAffineScannerTransform.MultiplyBy(AMatrix: TAffineMatrix);
begin
  FMatrix *= AMatrix;
end;

procedure TBGRAAffineScannerTransform.Fit(Origin, HAxis, VAxis: TPointF);
begin
  SetMatrix(AffineMatrix(HAxis.X-Origin.X, VAxis.X-Origin.X, 0,
                         HAxis.Y-Origin.Y, VAxis.Y-Origin.Y, 0));
  Invert;
  Translate(Origin.X,Origin.Y);
end;

procedure TBGRAAffineScannerTransform.Scale(sx, sy: single);
begin
  if (sx=0) or (sy=0) then
  begin
    FEmptyMatrix := True;
    exit;
  end;

  MultiplyBy(AffineMatrixScale(1/sx,1/sy));
end;

procedure TBGRAAffineScannerTransform.Scale(factor: single);
begin
  Scale(factor,factor);
end;

procedure TBGRAAffineScannerTransform.ScanMoveTo(X, Y: Integer);
begin
  ScanMoveToF(X,Y);
end;

procedure TBGRAAffineScannerTransform.ScanMoveToF(X, Y: single);
Var Cur: TPointF;
begin
  Cur := FMatrix * PointF(X,Y);
  FCurX := Cur.X;
  FCurY := Cur.Y;
end;

function TBGRAAffineScannerTransform.InternalScanCurrentPixel: TBGRAPixel;
begin
  if FEmptyMatrix then
  begin
    result := BGRAPixelTransparent;
    exit;
  end;
  result := FScanner.ScanAt(FCurX,FCurY);
end;

function TBGRAAffineScannerTransform.ScanNextPixel: TBGRAPixel;
begin
  result := InternalScanCurrentPixel;
  FCurX += FMatrix[1,1];
  FCurY += FMatrix[2,1];
end;

function TBGRAAffineScannerTransform.ScanAt(X, Y: Single): TBGRAPixel;
begin
  ScanMoveToF(X,Y);
  result := InternalScanCurrentPixel;
end;

{ TBGRAAffineBitmapTransform }

constructor TBGRAAffineBitmapTransform.Create(ABitmap: TBGRACustomBitmap;
  ARepeatImage: Boolean; AResampleFilter: TResampleFilter = rfLinear);
begin
  if (ABitmap.Width = 0) or (ABitmap.Height = 0) then
    raise Exception.Create('Empty image');
  inherited Create(ABitmap);
  FBitmap := ABitmap;
  FRepeatImage := ARepeatImage;
  FResampleFilter:= AResampleFilter;
end;

function TBGRAAffineBitmapTransform.InternalScanCurrentPixel: TBGRAPixel;
begin
  if FRepeatImage then
    result := FBitmap.GetPixelCycle(FCurX,FCurY,FResampleFilter) else
    result := FBitmap.GetPixel(FCurX,FCurY,FResampleFilter);
end;

procedure TBGRAAffineBitmapTransform.Fit(Origin, HAxis, VAxis: TPointF);
begin
  SetMatrix(AffineMatrix((HAxis.X-Origin.X)/FBitmap.Width, (VAxis.X-Origin.X)/FBitmap.Height, 0,
                         (HAxis.Y-Origin.Y)/FBitmap.Width, (VAxis.Y-Origin.Y)/FBitmap.Height, 0));
  Invert;
  Translate(Origin.X,Origin.Y);
end;

{ TBGRATwirlScanner }

constructor TBGRATwirlScanner.Create(AScanner: IBGRAScanner; ACenter: TPoint; ARadius: single; ATurn: single = 1; AExponent: single = 3);
begin
  FScanner := AScanner;
  FCenter := ACenter;
  FTurn := ATurn;
  FRadius := ARadius;
  FExponent := AExponent;
end;

function TBGRATwirlScanner.ScanAt(X, Y: Single): TBGRAPixel;
var p: TPoint;
    d: single;
    a,cosa,sina: integer;
begin
  p := Point(Round(X)-FCenter.X,Round(Y)-FCenter.Y);
  if (abs(p.x) < FRadius) and (abs(p.Y) < FRadius) then
  begin
    d := sqrt(p.x*p.x+p.y*p.y);
    if d < FRadius then
    begin
      d := (FRadius-d)/FRadius;
      if FExponent <> 1 then d := exp(ln(d)*FExponent);
      a := round(d*FTurn*65536);
      cosa := Cos65536(a)-32768;
      sina := Sin65536(a)-32768;
      result := FScanner.ScanAt((p.x*cosa+p.y*sina)/32768 + FCenter.X,
                                (-p.x*sina+p.y*cosa)/32768 + FCenter.Y);
      exit;
    end;
  end;
  result := FScanner.ScanAt(X,Y);
end;

end.

