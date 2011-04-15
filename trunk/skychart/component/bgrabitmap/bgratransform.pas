unit BGRATransform;

{$mode objfpc}

interface

uses
  Classes, SysUtils, BGRABitmapTypes, BGRAPolygon;

type
  TAffineMatrix = array[1..2,1..3] of single;

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
    procedure Scale(sx,sy: single); overload;
    procedure Scale(factor: single); overload;
    procedure ScanMoveTo(X, Y: Integer); override;
    procedure ScanMoveToF(X, Y: single); inline;
    function ScanNextPixel: TBGRAPixel; override;
    function ScanAt(X, Y: Single): TBGRAPixel; override;
    property Matrix: TAffineMatrix read FMatrix write SetMatrix;
  end;

  { TBGRAAffineBitmapTransform }

  TBGRAAffineBitmapTransform = class(TBGRAAffineScannerTransform)
  protected
    FBitmap: TBGRACustomBitmap;
    FRepeatImage,FFineInterpolation: boolean;
  public
    constructor Create(ABitmap: TBGRACustomBitmap; ARepeatImage: Boolean= false; AFineInterpolation: boolean= false);
    function InternalScanCurrentPixel: TBGRAPixel; override;
    procedure Fit(Origin, HAxis, VAxis: TPointF);
  end;

function AffineMatrix(m11,m12,m13,m21,m22,m23: single): TAffineMatrix;
function AffineMatrixMultiply(M,N: TAffineMatrix): TAffineMatrix;
function IsAffineMatrixInversible(M: TAffineMatrix): boolean;
function AffineMatrixInverse(M: TAffineMatrix): TAffineMatrix;
function AffineMatrixTranslation(OfsX,OfsY: Single): TAffineMatrix;

type

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

type
  TLinearTextureInfo = record
    TexCoord: TPointF;
    TexCoordSlopes: TPointF;
  end;
  PLinearTextureInfo = ^TLinearTextureInfo;

  { TPolygonLinearTextureMappingInfo }

  TPolygonLinearTextureMappingInfo = class(TFillPolyInfo)
  protected
    FTexCoords: array of TPointF;
  public
    constructor Create(const points: array of TPointF; const texCoords: array of TPointF);
    function CreateData(numPt,nextPt: integer; x,y: single): pointer; override;
    procedure ComputeIntersection(cury: single; var inter: ArrayOfSingle;
      var winding: arrayOfInteger; var texCoord: ArrayOfTPointF; var nbInter: integer); overload;
  end;

procedure PolygonLinearTextureMapping(bmp: TBGRACustomBitmap; polyInfo: TPolygonLinearTextureMappingInfo;
  texture: IBGRAScanner; TextureInterpolation: Boolean; NonZeroWinding: boolean); overload;
procedure PolygonLinearTextureMapping(bmp: TBGRACustomBitmap; const points: array of TPointF; texture: IBGRAScanner;
  const texCoords: array of TPointF; TextureInterpolation: Boolean; NonZeroWinding: boolean); overload;

type
  TPerspectiveTextureInfo = record
    InvZ,InvZSlope: Single;
    TexCoordDivByZ: TPointF;
    TexCoordDivByZSlopes: TPointF;
  end;
  PPerspectiveTextureInfo = ^TPerspectiveTextureInfo;

  { TPolygonPerspectiveTextureMappingInfo }

  TPolygonPerspectiveTextureMappingInfo = class(TFillPolyInfo)
  protected
    FTexCoords: array of TPointF;
    FPointsZ: array of single;
  public
    constructor Create(const points: array of TPointF; const pointsZ: array of single; const texCoords: array of TPointF);
    function CreateData(numPt,nextPt: integer; x,y: single): pointer; override;
    procedure ComputeIntersection(cury: single; var inter: ArrayOfSingle;
      var winding: arrayOfInteger; var coordInvZ: ArrayOfSingle; var texCoordDivByZ: ArrayOfTPointF; var nbInter: integer); overload;
  end;

procedure PolygonPerspectiveTextureMapping(bmp: TBGRACustomBitmap; polyInfo: TPolygonPerspectiveTextureMappingInfo;
         texture: IBGRAScanner; TextureInterpolation: Boolean; NonZeroWinding: boolean); overload;
procedure PolygonPerspectiveTextureMapping(bmp: TBGRACustomBitmap; const points: array of TPointF; const pointsZ: array of single; texture: IBGRAScanner;
           const texCoords: array of TPointF; TextureInterpolation: Boolean; NonZeroWinding: boolean); overload;

implementation

uses BGRABlend;

function AffineMatrix(m11, m12, m13, m21, m22, m23: single): TAffineMatrix;
begin
  result[1,1] := m11;
  result[1,2] := m12;
  result[1,3] := m13;
  result[2,1] := m21;
  result[2,2] := m22;
  result[2,3] := m23;
end;

function AffineMatrixMultiply(M, N: TAffineMatrix): TAffineMatrix;
begin
  result[1,1] := M[1,1]*N[1,1] + M[1,2]*N[2,1];
  result[1,2] := M[1,1]*N[1,2] + M[1,2]*N[2,2];
  result[1,3] := M[1,1]*N[1,3] + M[1,2]*N[2,3] + M[1,3];

  result[2,1] := M[2,1]*N[1,1] + M[2,2]*N[2,1];
  result[2,2] := M[2,1]*N[1,2] + M[2,2]*N[2,2];
  result[2,3] := M[2,1]*N[1,3] + M[2,2]*N[2,3] + M[2,3];
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
  result := AffineMatrixMultiply(linearInverse,AffineMatrixTranslation(-M[1,3],-M[2,3]));
end;

function AffineMatrixTranslation(OfsX, OfsY: Single): TAffineMatrix;
begin
  result := AffineMatrix(1, 0, OfsX,
                         0, 1, OfsY);
end;

{ TBGRAAffineScannerTransform }

constructor TBGRAAffineScannerTransform.Create(AScanner: IBGRAScanner);
begin
  FScanner := AScanner;
  Reset;
end;

procedure TBGRAAffineScannerTransform.Reset;
begin
  FMatrix := AffineMatrix(1, 0, 0,
                         0, 1, 0);
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
var
  TranslateMatrix: TAffineMatrix;
begin
  TranslateMatrix := AffineMatrixTranslation(-OfsX,-OfsY);
  MultiplyBy(TranslateMatrix);
end;

procedure TBGRAAffineScannerTransform.RotateDeg(Angle: Single);
begin
  RotateRad(-Angle*Pi/180);
end;

procedure TBGRAAffineScannerTransform.RotateRad(Angle: Single);
var
  RotateMatrix: TAffineMatrix;
begin
  Angle := -Angle;
  RotateMatrix := AffineMatrix(cos(Angle),  sin(Angle), 0,
                               -sin(Angle), cos(Angle), 0);
  MultiplyBy(RotateMatrix);
end;

procedure TBGRAAffineScannerTransform.MultiplyBy(AMatrix: TAffineMatrix);
begin
  FMatrix := AffineMatrixMultiply(FMatrix,AMatrix);
end;

procedure TBGRAAffineScannerTransform.Scale(sx, sy: single);
var ScaleMatrix: TAffineMatrix;
begin
  if (sx=0) or (sy=0) then
  begin
    FEmptyMatrix := True;
    exit;
  end;

  ScaleMatrix := AffineMatrix(1/sx, 0,    0,
                              0,    1/sy, 0);
  MultiplyBy(ScaleMatrix);
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
begin
  FCurX := X*FMatrix[1,1]+Y*FMatrix[1,2]+FMatrix[1,3];
  FCurY := X*FMatrix[2,1]+Y*FMatrix[2,2]+FMatrix[2,3];
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
  ARepeatImage: Boolean; AFineInterpolation: boolean);
begin
  if (ABitmap.Width = 0) or (ABitmap.Height = 0) then
    raise Exception.Create('Empty image');
  inherited Create(ABitmap);
  FBitmap := ABitmap;
  FRepeatImage := ARepeatImage;
  FFineInterpolation := AFineInterpolation;
end;

function TBGRAAffineBitmapTransform.InternalScanCurrentPixel: TBGRAPixel;
begin
  if FRepeatImage then
    result := FBitmap.GetPixelCycle(FCurX,FCurY,FFineInterpolation) else
    result := FBitmap.GetPixel(FCurX,FCurY,FFineInterpolation);
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

{ TPolygonPerspectiveTextureMappingInfo }

constructor TPolygonPerspectiveTextureMappingInfo.Create(
  const points: array of TPointF; const pointsZ: array of single;
  const texCoords: array of TPointF);
var
  i: Integer;
  lPoints: array of TPointF;
  nbP: integer;
begin
  if (length(texCoords) <> length(points)) or (length(pointsZ) <> length(points)) then
    raise Exception.Create('Dimensions mismatch');

  setlength(lPoints, length(points));
  SetLength(FTexCoords, length(points));
  SetLength(FPointsZ, length(points));
  nbP := 0;
  for i := 0 to high(points) do
  if (i=0) or (points[i].x<>points[i-1].X) or (points[i].y<>points[i-1].y) then
  begin
    lPoints[nbP] := points[i];
    FTexCoords[nbP] := texCoords[i];
    FPointsZ[nbP] := abs(pointsZ[i]);
    inc(nbP);
  end;
  if (nbP>0) and (lPoints[nbP-1].X = lPoints[0].X) and (lPoints[nbP-1].Y = lPoints[0].Y) then dec(NbP);
  setlength(lPoints, nbP);
  SetLength(FTexCoords, nbP);
  SetLength(FPointsZ, nbP);

  inherited Create(lPoints);
end;

{$hints off}
function TPolygonPerspectiveTextureMappingInfo.CreateData(numPt,
  nextPt: integer; x, y: single): pointer;
var
  info: PPerspectiveTextureInfo;
  ty,dy: single;
  CurInvZ,NextInvZ: single;
  CurTexCoordDivByZ: TPointF;
  NextTexCoordDivByZ: TPointF;
begin
  New(info);
  CurInvZ := 1/FPointsZ[numPt];
  CurTexCoordDivByZ := FTexCoords[numPt]*CurInvZ;
  NextInvZ := 1/FPointsZ[nextPt];
  NextTexCoordDivByZ := FTexCoords[nextPt]*NextInvZ;
  ty := FPoints[nextPt].y-FPoints[numPt].y;
  info^.TexCoordDivByZSlopes := (NextTexCoordDivByZ - CurTexCoordDivByZ)*(1/ty);
  dy := y-FPoints[numPt].y;
  info^.TexCoordDivByZ := CurTexCoordDivByZ + info^.TexCoordDivByZSlopes*dy;
  info^.InvZSlope := (NextInvZ-CurInvZ)/ty;
  info^.InvZ := CurInvZ+dy*info^.InvZSlope;
  Result:= info;
end;
{$hints on}

procedure TPolygonPerspectiveTextureMappingInfo.ComputeIntersection(
  cury: single; var inter: ArrayOfSingle; var winding: arrayOfInteger;
  var coordInvZ: ArrayOfSingle; var texCoordDivByZ: ArrayOfTPointF;
  var nbInter: integer);
var
  j: integer;
  dy: single;
  info: PPerspectiveTextureInfo;
begin
  if length(FSlices)=0 then exit;

  while (cury < FSlices[FCurSlice].y1) and (FCurSlice > 0) do dec(FCurSlice);
  while (cury > FSlices[FCurSlice].y2) and (FCurSlice < high(FSlices)) do inc(FCurSlice);
  with FSlices[FCurSlice] do
  if (cury >= y1) and (cury <= y2) then
  begin
    for j := 0 to nbSegments-1 do
    begin
      dy := cury - segments[j].y1;
      inter[nbinter] := dy * segments[j].slope + segments[j].x1;
      winding[nbinter] := segments[j].winding;
      info := PPerspectiveTextureInfo(segments[j].data);
      coordInvZ[nbinter] := dy*info^.InvZSlope + info^.InvZ;
      texCoordDivByZ[nbinter] := info^.TexCoordDivByZ + info^.TexCoordDivByZSlopes*dy;
      Inc(nbinter);
    end;
  end;
end;

{ TPolygonLinearTextureMappingInfo }

constructor TPolygonLinearTextureMappingInfo.Create(const points: array of TPointF;
  const texCoords: array of TPointF);
var
  i: Integer;
  lPoints: array of TPointF;
  nbP: integer;
begin
  if length(texCoords) <> length(points) then
    raise Exception.Create('Dimensions mismatch');

  setlength(lPoints, length(points));
  SetLength(FTexCoords, length(points));
  nbP := 0;
  for i := 0 to high(points) do
  if (i=0) or (points[i]<>points[i-1]) then
  begin
    lPoints[nbP] := points[i];
    FTexCoords[nbP] := texCoords[i];
    inc(nbP);
  end;
  if (nbP>0) and (lPoints[nbP-1] = lPoints[0]) then dec(NbP);
  setlength(lPoints, nbP);
  SetLength(FTexCoords, nbP);

  inherited Create(lPoints);
end;

{$hints off}
function TPolygonLinearTextureMappingInfo.CreateData(numPt, nextPt: integer; x,
  y: single): pointer;
var
  info: PLinearTextureInfo;
  ty,dy: single;
begin
  New(info);
  ty := FPoints[nextPt].y-FPoints[numPt].y;
  info^.TexCoordSlopes := (FTexCoords[nextPt] - FTexCoords[numPt])*(1/ty);
  dy := y-FPoints[numPt].y;
  info^.TexCoord := FTexCoords[numPt] + info^.TexCoordSlopes*dy;
  Result:= info;
end;
{$hints on}

procedure TPolygonLinearTextureMappingInfo.ComputeIntersection(cury: single;
  var inter: ArrayOfSingle; var winding: arrayOfInteger; var texCoord: ArrayOfTPointF; var nbInter: integer);
var
  j: integer;
  dy: single;
  info: PLinearTextureInfo;
begin
  if length(FSlices)=0 then exit;

  while (cury < FSlices[FCurSlice].y1) and (FCurSlice > 0) do dec(FCurSlice);
  while (cury > FSlices[FCurSlice].y2) and (FCurSlice < high(FSlices)) do inc(FCurSlice);
  with FSlices[FCurSlice] do
  if (cury >= y1) and (cury <= y2) then
  begin
    for j := 0 to nbSegments-1 do
    begin
      dy := cury - segments[j].y1;
      inter[nbinter] := dy * segments[j].slope + segments[j].x1;
      winding[nbinter] := segments[j].winding;
      info := PLinearTextureInfo(segments[j].data);
      texCoord[nbinter] := info^.TexCoord + info^.TexCoordSlopes*dy;
      Inc(nbinter);
    end;
  end;
end;

procedure PolygonLinearTextureMapping(bmp: TBGRACustomBitmap; polyInfo: TPolygonLinearTextureMappingInfo;
  texture: IBGRAScanner; TextureInterpolation: Boolean; NonZeroWinding: boolean);
var
  inter:    array of single;
  winding:  array of integer;
  texCoord: array of TPointF;
  nbInter:  integer;

  procedure DrawTextureLine(yb: integer; ix1: integer; ix2: integer;
    x1: Single; t1: TPointF; x2: Single; t2: TPointF; WithInterpolation: boolean);
  var
    texPos: TPointF;
    texStep: TPointF;
    t: single;
    pdest: PBGRAPixel;
    i: LongInt;
  begin
    t := ((ix1+0.5)-x1)/(x2-x1);
    texPos := t1 + (t2-t1)*t;
    texStep := (t2-t1)*(1/(x2-x1));
    pdest := bmp.ScanLine[yb]+ix1;
    if WithInterpolation then
    begin
      for i := ix1 to ix2 do
      begin
        DrawPixelInline(pdest, texture.ScanAt(texPos.x,texPos.y));
        texPos += texStep;
        inc(pdest);
      end;
    end else
    begin
      for i := ix1 to ix2 do
      begin
        DrawPixelInline(pdest, texture.ScanAt(round(texPos.x),round(texPos.y)));
        texPos += texStep;
        inc(pdest);
      end;
    end;
  end;

  procedure ConvertFromNonZeroWinding; inline;
  var windingSum,prevSum,i,nbAlternate: integer;
  begin
    windingSum := 0;
    nbAlternate := 0;
    for i := 0 to nbInter-1 do
    begin
      prevSum := windingSum;
      windingSum += winding[i];
      if (windingSum = 0) xor (prevSum = 0) then
      begin
        inter[nbAlternate] := inter[i];
        texCoord[nbAlternate] := texCoord[i];
        inc(nbAlternate);
      end;
    end;
    nbInter := nbAlternate;
  end;

var
  bounds: TRect;
  miny, maxy, minx, maxx: integer;

  yb, i, j, tempInt: integer;
  temp, x1, x2: single;
  tempCoord: TPointF;

  ix1, ix2: integer;

begin
  bounds := polyInfo.GetBounds;
  If not ComputeMinMax(minx,miny,maxx,maxy,bounds,bmp) then exit;

  setlength(inter, polyInfo.NbMaxIntersection);
  setlength(winding, length(inter));
  setlength(texCoord, length(inter));

  //vertical scan
  for yb := miny to maxy do
  begin
    //find intersections
    nbinter := 0;
    polyInfo.ComputeIntersection(yb+0.5001, inter, winding, texCoord, nbInter);
    if nbinter = 0 then
      continue;

    //sort intersections
    for i := 1 to nbinter - 1 do
    begin
      j := i;
      while (j > 0) and (inter[j - 1] > inter[j]) do
      begin
        temp     := inter[j - 1];
        inter[j - 1] := inter[j];
        inter[j] := temp;
        tempInt    := winding[j - 1];
        winding[j - 1] := winding[j];
        winding[j] := tempInt;
        tempCoord  := texCoord[j - 1];
        texCoord[j - 1] := texCoord[j];
        texCoord[j] := tempCoord;
        Dec(j);
      end;
    end;
    if NonZeroWinding then ConvertFromNonZeroWinding;

    for i := 0 to nbinter div 2 - 1 do
    begin
      x1 := inter[i + i];
      x2 := inter[i + i+ 1];

      if x1 <> x2 then
      begin
        ComputeAliasedRowBounds(x1,x2, minx,maxx, ix1,ix2);
        if ix1 <= ix2 then
          DrawTextureLine(yb,ix1,ix2, x1,texCoord[i+i],x2,texCoord[i+i+1],TextureInterpolation);
      end;
    end;
  end;

  bmp.InvalidateBitmap;
end;

procedure PolygonLinearTextureMapping(bmp: TBGRACustomBitmap;
  const points: array of TPointF; texture: IBGRAScanner;
  const texCoords: array of TPointF; TextureInterpolation: Boolean; NonZeroWinding: boolean);
var polyInfo: TPolygonLinearTextureMappingInfo;
begin
  polyInfo := TPolygonLinearTextureMappingInfo.Create(points,texCoords);
  PolygonLinearTextureMapping(bmp,polyInfo,texture,TextureInterpolation,NonZeroWinding);
  polyInfo.Free;
end;

procedure PolygonPerspectiveTextureMapping(bmp: TBGRACustomBitmap;
  polyInfo: TPolygonPerspectiveTextureMappingInfo; texture: IBGRAScanner;
  TextureInterpolation: Boolean; NonZeroWinding: boolean);
var
  inter:    array of single;
  winding:  array of integer;
  texCoordDivByZ: array of TPointF;
  coordInvZ: array of single;
  nbInter:  integer;

  procedure DrawTextureLine(yb: integer; ix1: integer; ix2: integer;
    x1,invZ1: Single; tDivByZ1: TPointF; x2,invZ2: Single; tDivByZ2: TPointF; WithInterpolation: boolean);
  var
    texPos: TPointF;
    texStep: TPointF;
    zPos: single;
    zStep: single;
    t: single;
    pdest: PBGRAPixel;
    i: LongInt;
  begin
    t := ((ix1+0.5)-x1)/(x2-x1);
    texPos := tDivByZ1 + (tDivByZ2-tDivByZ1)*t;
    texStep := (tDivByZ2-tDivByZ1)*(1/(x2-x1));
    zPos := invZ1+t*(invZ2-invZ1);
    zStep := (invZ2-invZ1)/(x2-x1);
    pdest := bmp.ScanLine[yb]+ix1;
    if WithInterpolation then
    begin
      for i := ix1 to ix2 do
      begin
        DrawPixelInline(pdest, texture.ScanAt(texPos.x/zPos,texPos.y/zPos));
        texPos += texStep;
        zPos += zStep;
        inc(pdest);
      end;
    end else
    begin
      for i := ix1 to ix2 do
      begin
        DrawPixelInline(pdest, texture.ScanAt(round(texPos.x/zPos),round(texPos.y/zPos)));
        texPos += texStep;
        zPos += zStep;
        inc(pdest);
      end;
    end;
  end;

  procedure ConvertFromNonZeroWinding; inline;
  var windingSum,prevSum,i,nbAlternate: integer;
  begin
    windingSum := 0;
    nbAlternate := 0;
    for i := 0 to nbInter-1 do
    begin
      prevSum := windingSum;
      windingSum += winding[i];
      if (windingSum = 0) xor (prevSum = 0) then
      begin
        inter[nbAlternate] := inter[i];
        texCoordDivByZ[nbAlternate] := texCoordDivByZ[i];
        coordInvZ[nbAlternate] := coordInvZ[i];
        inc(nbAlternate);
      end;
    end;
    nbInter := nbAlternate;
  end;

var
  bounds: TRect;
  miny, maxy, minx, maxx: integer;

  yb, i, j, tempInt: integer;
  temp, x1, x2: single;
  tempCoord: TPointF;

  ix1, ix2: integer;

begin
  bounds := polyInfo.GetBounds;
  If not ComputeMinMax(minx,miny,maxx,maxy,bounds,bmp) then exit;

  setlength(inter, polyInfo.NbMaxIntersection);
  setlength(winding, length(inter));
  setlength(texCoordDivByZ, length(inter));
  setlength(coordInvZ, length(inter));

  //vertical scan
  for yb := miny to maxy do
  begin
    //find intersections
    nbinter := 0;
    polyInfo.ComputeIntersection(yb+0.5001, inter, winding, coordInvZ, texCoordDivByZ, nbInter);
    if nbinter = 0 then
      continue;

    //sort intersections
    for i := 1 to nbinter - 1 do
    begin
      j := i;
      while (j > 0) and (inter[j - 1] > inter[j]) do
      begin
        temp     := inter[j - 1];
        inter[j - 1] := inter[j];
        inter[j] := temp;
        tempInt    := winding[j - 1];
        winding[j - 1] := winding[j];
        winding[j] := tempInt;
        temp     := coordInvZ[j - 1];
        coordInvZ[j - 1] := coordInvZ[j];
        coordInvZ[j] := temp;
        tempCoord  := texCoordDivByZ[j - 1];
        texCoordDivByZ[j - 1] := texCoordDivByZ[j];
        texCoordDivByZ[j] := tempCoord;
        Dec(j);
      end;
    end;
    if NonZeroWinding then ConvertFromNonZeroWinding;

    for i := 0 to nbinter div 2 - 1 do
    begin
      x1 := inter[i + i];
      x2 := inter[i + i+ 1];

      if x1 <> x2 then
      begin
        ComputeAliasedRowBounds(x1,x2, minx,maxx, ix1,ix2);
        if ix1 <= ix2 then
          DrawTextureLine(yb,ix1,ix2, x1,coordInvZ[i+i],texCoordDivByZ[i+i], x2,coordInvZ[i+i+1],texCoordDivByZ[i+i+1],TextureInterpolation);
      end;
    end;
  end;

  bmp.InvalidateBitmap;
end;

procedure PolygonPerspectiveTextureMapping(bmp: TBGRACustomBitmap;
  const points: array of TPointF; const pointsZ: array of single;
  texture: IBGRAScanner; const texCoords: array of TPointF;
  TextureInterpolation: Boolean; NonZeroWinding: boolean);
var polyInfo: TPolygonPerspectiveTextureMappingInfo;
begin
  polyInfo := TPolygonPerspectiveTextureMappingInfo.Create(points,pointsZ,texCoords);
  PolygonPerspectiveTextureMapping(bmp,polyInfo,texture,TextureInterpolation, NonZeroWinding);
  polyInfo.Free;
end;

end.

