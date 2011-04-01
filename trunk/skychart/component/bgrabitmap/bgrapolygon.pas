unit BGRAPolygon;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, BGRABitmapTypes;

type
  ArrayOfSingle = array of single;
  ArrayOfInteger = array of integer;

  { TFillShapeInfo }

  TFillShapeInfo = class
    function GetBounds: TRect; virtual;
    function NbMaxIntersection: integer; virtual;
    procedure ComputeIntersection(cury: single; var inter: ArrayOfSingle;
      var winding: arrayOfInteger; var nbInter: integer); virtual;
  end;

procedure FillShapeAntialias(bmp: TBGRACustomBitmap; shapeInfo: TFillShapeInfo;
  c: TBGRAPixel; EraseMode: boolean; NonZeroWinding: boolean);
procedure FillShapeAntialiasWithTexture(bmp: TBGRACustomBitmap; shapeInfo: TFillShapeInfo;
  texture: TBGRACustomBitmap; NonZeroWinding: boolean);

type
  TPolySlice = record
    y1,y2: single;
    segments: array of record
                y1,x1: single;
                slope: single;
                winding: integer;
              end;
  end;

  { TFillPolyInfo }

  TFillPolyInfo = class(TFillShapeInfo)
  private
    FPoints:      array of TPointF;
    FSlopes:      array of single;
    FEmptyPt:     array of boolean;
    FNext, FPrev: array of integer;

    FSlices:   array of TPolySlice;
    FCurSlice: integer;
  public
    constructor Create(points: array of TPointF);
    function GetBounds: TRect; override;
    function NbMaxIntersection: integer; override;
    procedure ComputeIntersection(cury: single; var inter: ArrayOfSingle;
      var winding: arrayOfInteger; var nbInter: integer); override;
  end;

procedure FillPolyAntialias(bmp: TBGRACustomBitmap; points: array of TPointF;
  c: TBGRAPixel; EraseMode: boolean; NonZeroWinding: boolean);
procedure FillPolyAntialiasWithTexture(bmp: TBGRACustomBitmap; points: array of TPointF;
  texture: TBGRACustomBitmap; NonZeroWinding: boolean);

type
  { TFillEllipseInfo }

  TFillEllipseInfo = class(TFillShapeInfo)
  private
    FX, FY, FRX, FRY: single;
  public
    WindingFactor: integer;
    constructor Create(x, y, rx, ry: single);
    function GetBounds: TRect; override;
    function NbMaxIntersection: integer; override;
    procedure ComputeIntersection(cury: single; var inter: ArrayOfSingle;
      var winding: arrayOfInteger; var nbInter: integer); override;
  end;

procedure FillEllipseAntialias(bmp: TBGRACustomBitmap; x, y, rx, ry: single;
  c: TBGRAPixel; EraseMode: boolean);
procedure FillEllipseAntialiasWithTexture(bmp: TBGRACustomBitmap; x, y, rx, ry: single;
  texture: TBGRACustomBitmap);

type
  { TFillBorderEllipseInfo }

  TFillBorderEllipseInfo = class(TFillShapeInfo)
  private
    innerBorder, outerBorder: TFillEllipseInfo;
  public
    constructor Create(x, y, rx, ry, w: single);
    function GetBounds: TRect; override;
    function NbMaxIntersection: integer; override;
    procedure ComputeIntersection(cury: single; var inter: ArrayOfSingle;
      var winding: arrayOfInteger; var nbInter: integer); override;
    destructor Destroy; override;
  end;

procedure BorderEllipseAntialias(bmp: TBGRACustomBitmap; x, y, rx, ry, w: single;
  c: TBGRAPixel; EraseMode: boolean);
procedure BorderEllipseAntialiasWithTexture(bmp: TBGRACustomBitmap; x, y, rx, ry, w: single;
  texture: TBGRACustomBitmap);

type
  { TFillRoundRectangleInfo }

  TFillRoundRectangleInfo = class(TFillShapeInfo)
  private
    FX1, FY1, FX2, FY2, FRX, FRY: single;
    FOptions: TRoundRectangleOptions;
  public
    WindingFactor: integer;
    constructor Create(x1, y1, x2, y2, rx, ry: single; options: TRoundRectangleOptions);
    function GetBounds: TRect; override;
    function NbMaxIntersection: integer; override;
    procedure ComputeIntersection(cury: single; var inter: ArrayOfSingle;
      var winding: arrayOfInteger; var nbInter: integer); override;
  end;

procedure FillRoundRectangleAntialias(bmp: TBGRACustomBitmap; x1, y1, x2, y2, rx, ry: single;
  options: TRoundRectangleOptions; c: TBGRAPixel; EraseMode: boolean);
procedure FillRoundRectangleAntialiasWithTexture(bmp: TBGRACustomBitmap; x1, y1, x2, y2, rx, ry: single;
  options: TRoundRectangleOptions; texture: TBGRACustomBitmap);

type
  { TFillBorderRoundRectInfo }

  TFillBorderRoundRectInfo = class(TFillShapeInfo)
    innerBorder, outerBorder: TFillRoundRectangleInfo;
    constructor Create(x1, y1, x2, y2, rx, ry, w: single; options: TRoundRectangleOptions);
    function GetBounds: TRect; override;
    function NbMaxIntersection: integer; override;
    procedure ComputeIntersection(cury: single; var inter: ArrayOfSingle;
      var winding: arrayOfInteger; var nbInter: integer); override;
    destructor Destroy; override;
  end;

procedure BorderRoundRectangleAntialias(bmp: TBGRACustomBitmap; x1, y1, x2, y2, rx, ry, w: single;
  options: TRoundRectangleOptions; c: TBGRAPixel; EraseMode: boolean);
procedure BorderRoundRectangleAntialiasWithTexture(bmp: TBGRACustomBitmap; x1, y1, x2, y2, rx, ry, w: single;
  options: TRoundRectangleOptions; texture: TBGRACustomBitmap);

procedure BorderAndFillRoundRectangleAntialias(bmp: TBGRACustomBitmap; x1, y1, x2, y2, rx, ry, w: single;
  options: TRoundRectangleOptions; bordercolor,fillcolor: TBGRAPixel; EraseMode: boolean);

{----------------------- Spline ------------------}

function Spline(y0, y1, y2, y3: single; t: single): single;
function ComputeBezierCurve(const curve: TCubicBezierCurve): ArrayOfTPointF; overload;
function ComputeBezierCurve(const curve: TQuadraticBezierCurve): ArrayOfTPointF; overload;
function ComputeBezierSpline(const spline: array of TCubicBezierCurve): ArrayOfTPointF; overload;
function ComputeBezierSpline(const spline: array of TQuadraticBezierCurve): ArrayOfTPointF; overload;
function ComputeClosedSpline(const points: array of TPointF): ArrayOfTPointF;
function ComputeOpenedSpline(const points: array of TPointF): ArrayOfTPointF;
procedure BGRARoundRectAliased(dest: TBGRACustomBitmap; X1, Y1, X2, Y2: integer;
  RX, RY: integer; BorderColor, FillColor: TBGRAPixel);

implementation

uses Math, bgrablend;

procedure BGRARoundRectAliased(dest: TBGRACustomBitmap; X1, Y1, X2, Y2: integer;
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
    dest.DrawPixel(X1, Y1, BorderColor);
    Exit;
  end;

  if (X2 - X1 = 1) or (Y2 - Y1 = 1) then
  begin
    dest.FillRect(X1, Y1, X2 + 1, Y2 + 1, BorderColor, dmDrawWithTransparency);
    Exit;
  end;

  if (LX > X2 - X1) or (LY > Y2 - Y1) then
  begin
    dest.Rectangle(X1, Y1, X2 + 1, Y2 + 1, BorderColor, dmDrawWithTransparency);
    dest.FillRect(X1 + 1, Y1 + 1, X2, Y2, FillColor, dmDrawWithTransparency);
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
        dest.DrawPixel(Floor(CX) + I, Floor(CY) + J, BorderColor);
        dest.DrawPixel(Ceil(CX) - Succ(I), Floor(CY) + J, BorderColor);
      end;

      dest.DrawHorizLine(Ceil(CX) - EdgeList[J].X, Floor(CY) + J, Floor(CX) +
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
        dest.DrawPixel(Floor(CX) + I, Floor(CY) + J, BorderColor);
        dest.DrawPixel(Floor(CX) + I, Ceil(CY) - Succ(J), BorderColor);
      end;
    end
    else
    begin
      for I := EdgeList[J].X to EdgeList[J].Y do
      begin
        dest.DrawPixel(Floor(CX) + I, Floor(CY) + J, BorderColor);
        dest.DrawPixel(Floor(CX) + I, Ceil(CY) - Succ(J), BorderColor);
        if Floor(CX) + I <> Ceil(CX) - Succ(I) then
        begin
          dest.DrawPixel(Ceil(CX) - Succ(I), Floor(CY) + J, BorderColor);
          dest.DrawPixel(Ceil(CX) - Succ(I), Ceil(CY) - Succ(J), BorderColor);
        end;
      end;

      dest.DrawHorizLine(Ceil(CX) - EdgeList[J].X, Floor(CY) + J,
        Floor(CX) + Pred(EdgeList[J].X), FillColor);
      dest.DrawHorizLine(Ceil(CX) - EdgeList[J].X, Ceil(CY) - Succ(J),
        Floor(CX) + Pred(EdgeList[J].X), FillColor);
    end;
  end;
end;

procedure FillShapeAntialias(bmp: TBGRACustomBitmap; shapeInfo: TFillShapeInfo;
  c: TBGRAPixel; EraseMode: boolean; NonZeroWinding: boolean);
const
  precision = 11;
var
  inter:   array of single;
  winding: array of integer;
  nbInter: integer;

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
        inc(nbAlternate);
      end;
    end;
    nbInter := nbAlternate;
  end;

var
  bounds: TRect;
  miny, maxy, minx, maxx: integer;

  density: packed array of single;

  xb, yb, yc, i, j, tempInt: integer;

  temp, cury, x1, x2: single;
  ix1, ix2: integer;
  pdest:    PBGRAPixel;
  pdens:    PSingle;

begin
  bounds := shapeInfo.GetBounds;
  if (bounds.Right <= bounds.left) or (bounds.bottom <= bounds.top) then
    exit;

  miny := bounds.top;
  maxy := bounds.bottom - 1;
  minx := bounds.left;
  maxx := bounds.right - 1;

  if minx < 0 then
    minx := 0;
  if maxx < 0 then
    exit;
  if maxx > bmp.Width - 1 then
    maxx := bmp.Width - 1;
  if minx > bmp.Width - 1 then
    exit;
  if miny < 0 then
    miny := 0;
  if miny > bmp.Height - 1 then
    exit;
  if maxy > bmp.Height - 1 then
    maxy := bmp.Height - 1;
  if maxy < 0 then
    exit;

  setlength(inter, shapeInfo.NbMaxIntersection);
  setlength(winding, length(inter));
  setlength(density, maxx - minx + 2); //more for safety

  //vertical scan
  for yb := miny to maxy do
  begin
    //mean density
    for i := 0 to high(density) do
      density[i] := 0;

    //precision scan
    for yc := 0 to precision - 1 do
    begin
      cury := yb + (yc * 2 + 1) / (precision * 2);

      //find intersections
      nbinter := 0;
      shapeInfo.ComputeIntersection(cury, inter, winding, nbInter);
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
          Dec(j);
        end;
      end;
      if NonZeroWinding then ConvertFromNonZeroWinding;

      //fill density
      for i := 0 to nbinter div 2 - 1 do
      begin
        x1 := inter[i + i];
        x2 := inter[i + i + 1];
        if (x1 <> x2) and (x1 < maxx + 1) and (x2 >= minx) then
        begin
          if x1 < minx then
            x1 := minx;
          if x2 >= maxx + 1 then
            x2 := maxx + 1;
          ix1  := floor(x1);
          ix2  := floor(x2);
          if ix1 = ix2 then
            density[ix1 - minx] += x2 - x1
          else
          begin
            density[ix1 - minx] += 1 - (x1 - ix1);
            if (ix2 <= maxx) then
              density[ix2 - minx] += x2 - ix2;
          end;
          if ix2 > ix1 + 1 then
          begin
            for j := ix1 + 1 to ix2 - 1 do
              density[j - minx] += 1;
          end;
        end;
      end;

    end;

    pdest := bmp.ScanLine[yb] + minx;
    pdens := @density[0];
    //render scanline
    if EraseMode then
    begin
      for xb := minx to maxx do
      begin
        temp := pdens^;
        Inc(pdens);
        if temp <> 0 then
          ErasePixelInline(pdest, round(c.alpha * temp / precision));
        Inc(pdest);
      end;
    end
    else
    begin
      for xb := minx to maxx do
      begin
        temp := pdens^;
        Inc(pdens);
        if temp <> 0 then
          DrawPixelInline(pdest, BGRA(c.red, c.green, c.blue, round(
            c.alpha * temp / precision)));
        Inc(pdest);
      end;
    end;
  end;

  bmp.InvalidateBitmap;
end;

procedure FillShapeAntialiasWithTexture(bmp: TBGRACustomBitmap; shapeInfo: TFillShapeInfo;
  texture: TBGRACustomBitmap; NonZeroWinding: boolean);
const
  precision = 11;
var
  inter:   array of single;
  winding: array of integer;
  nbInter: integer;

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
        inc(nbAlternate);
      end;
    end;
    nbInter := nbAlternate;
  end;

var
  bounds: TRect;
  miny, maxy, minx, maxx: integer;

  density: packed array of single;

  xb, yb, yc, i, j, tempInt: integer;

  temp, cury, x1, x2: single;
  ix1, ix2: integer;
  pdest:    PBGRAPixel;
  pdens:    PSingle;
  texScan:  TBGRABitmapScanner;
  c: TBGRAPixel;

begin
  bounds := shapeInfo.GetBounds;
  if (bounds.Right <= bounds.left) or (bounds.bottom <= bounds.top) then
    exit;

  miny := bounds.top;
  maxy := bounds.bottom - 1;
  minx := bounds.left;
  maxx := bounds.right - 1;

  if minx < 0 then
    minx := 0;
  if maxx < 0 then
    exit;
  if maxx > bmp.Width - 1 then
    maxx := bmp.Width - 1;
  if minx > bmp.Width - 1 then
    exit;
  if miny < 0 then
    miny := 0;
  if miny > bmp.Height - 1 then
    exit;
  if maxy > bmp.Height - 1 then
    maxy := bmp.Height - 1;
  if maxy < 0 then
    exit;

  setlength(inter, shapeInfo.NbMaxIntersection);
  setlength(winding, length(inter));
  setlength(density, maxx - minx + 2); //more for safety

  texScan := TBGRABitmapScanner.Create(texture);

  //vertical scan
  for yb := miny to maxy do
  begin
    //mean density
    for i := 0 to high(density) do
      density[i] := 0;

    //precision scan
    for yc := 0 to precision - 1 do
    begin
      cury := yb + (yc * 2 + 1) / (precision * 2);

      //find intersections
      nbinter := 0;
      shapeInfo.ComputeIntersection(cury, inter, winding, nbInter);
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
          Dec(j);
        end;
      end;
      if NonZeroWinding then ConvertFromNonZeroWinding;

      //fill density
      for i := 0 to nbinter div 2 - 1 do
      begin
        x1 := inter[i + i];
        x2 := inter[i + i + 1];
        if (x1 <> x2) and (x1 < maxx + 1) and (x2 >= minx) then
        begin
          if x1 < minx then
            x1 := minx;
          if x2 >= maxx + 1 then
            x2 := maxx + 1;
          ix1  := floor(x1);
          ix2  := floor(x2);
          if ix1 = ix2 then
            density[ix1 - minx] += x2 - x1
          else
          begin
            density[ix1 - minx] += 1 - (x1 - ix1);
            if (ix2 <= maxx) then
              density[ix2 - minx] += x2 - ix2;
          end;
          if ix2 > ix1 + 1 then
          begin
            for j := ix1 + 1 to ix2 - 1 do
              density[j - minx] += 1;
          end;
        end;
      end;

    end;

    pdest := bmp.ScanLine[yb] + minx;
    pdens := @density[0];
    //render scanline
    texScan.MoveTo(minx,yb);
    for xb := minx to maxx do
    begin
      temp := pdens^;
      Inc(pdens);
      c := texScan.GetNextPixel;
      if temp <> 0 then
        DrawPixelInline(pdest, BGRA(c.red, c.green, c.blue, round(
          c.alpha * temp / precision)));
      Inc(pdest);
    end;
  end;
  texScan.Free;

  bmp.InvalidateBitmap;
end;

procedure FillPolyAntialias(bmp: TBGRACustomBitmap; points: array of TPointF;
  c: TBGRAPixel; EraseMode: boolean; NonZeroWinding: boolean);
var
  info: TFillPolyInfo;
begin
  if length(points) < 3 then
    exit;

  info := TFillPolyInfo.Create(points);
  FillShapeAntialias(bmp, info, c, EraseMode, NonZeroWinding);
  info.Free;
end;

procedure FillPolyAntialiasWithTexture(bmp: TBGRACustomBitmap;
  points: array of TPointF; texture: TBGRACustomBitmap; NonZeroWinding: boolean
  );
var
  info: TFillPolyInfo;
begin
  if length(points) < 3 then
    exit;

  info := TFillPolyInfo.Create(points);
  FillShapeAntialiasWithTexture(bmp, info, texture, NonZeroWinding);
  info.Free;
end;

procedure FillEllipseAntialias(bmp: TBGRACustomBitmap; x, y, rx, ry: single;
  c: TBGRAPixel; EraseMode: boolean);
var
  info: TFillEllipseInfo;
begin
  if (rx = 0) or (ry = 0) then
    exit;

  info := TFillEllipseInfo.Create(x, y, rx, ry);
  FillShapeAntialias(bmp, info, c, EraseMode, False);
  info.Free;
end;

procedure FillEllipseAntialiasWithTexture(bmp: TBGRACustomBitmap; x, y, rx,
  ry: single; texture: TBGRACustomBitmap);
var
  info: TFillEllipseInfo;
begin
  if (rx = 0) or (ry = 0) then
    exit;

  info := TFillEllipseInfo.Create(x, y, rx, ry);
  FillShapeAntialiasWithTexture(bmp, info, texture, False);
  info.Free;
end;

procedure BorderEllipseAntialias(bmp: TBGRACustomBitmap; x, y, rx, ry, w: single;
  c: TBGRAPixel; EraseMode: boolean);
var
  info: TFillBorderEllipseInfo;
begin
  if (rx = 0) or (ry = 0) then
    exit;
  info := TFillBorderEllipseInfo.Create(x, y, rx, ry, w);
  FillShapeAntialias(bmp, info, c, EraseMode, False);
  info.Free;
end;

procedure BorderEllipseAntialiasWithTexture(bmp: TBGRACustomBitmap; x, y, rx,
  ry, w: single; texture: TBGRACustomBitmap);
var
  info: TFillBorderEllipseInfo;
begin
  if (rx = 0) or (ry = 0) then
    exit;
  info := TFillBorderEllipseInfo.Create(x, y, rx, ry, w);
  FillShapeAntialiasWithTexture(bmp, info, texture, False);
  info.Free;
end;

{ TFillShapeInfo }

function TFillShapeInfo.GetBounds: TRect;
begin
  Result := rect(0, 0, 0, 0);
end;

function TFillShapeInfo.NbMaxIntersection: integer;
begin
  Result := 0;
end;

{$hints off}
procedure TFillShapeInfo.ComputeIntersection(cury: single;
  var inter: ArrayOfSingle; var winding: arrayOfInteger; var nbInter: integer);
begin

end;

{$hints on}

function ComputeWinding(y1,y2: single): integer;
begin
    if y2 > y1 then result := 1 else
    if y2 < y1 then result := -1 else
      result := 0;
end;

{ TFillPolyInfo }

constructor TFillPolyInfo.Create(points: array of TPointF);
var
  i, j, k: integer;
  First, cur, nbP: integer;
  yList: array of single;
  nbYList,nbSeg: integer;
  Temp: Single;
begin
  setlength(FPoints, length(points));
  nbP := 0;
  for i := 0 to high(points) do
  if (i=0) or (points[i].x<>points[i-1].X) or (points[i].y<>points[i-1].y) then
  begin
    FPoints[nbP] := points[i];
    inc(nbP);
  end;
  if (nbP>0) and (FPoints[nbP-1].X = FPoints[0].X) and (FPoints[nbP-1].Y = FPoints[0].Y) then dec(NbP);
  setlength(FPoints, nbP);

  //look for empty points, correct coordinate and successors
  setlength(FEmptyPt, length(FPoints));
  setlength(FNext, length(FPoints));

  cur   := -1;
  First := -1;
  for i := 0 to high(FPoints) do
    if not isEmptyPointF(FPoints[i]) then
    begin
      FEmptyPt[i]  := False;
      FPoints[i].x += 0.5;
      FPoints[i].y += 0.5;
      if cur <> -1 then
        FNext[cur] := i;
      if First = -1 then
        First := i;
      cur     := i;
    end
    else
    begin
      if (First <> -1) and (cur <> First) then
        FNext[cur] := First;

      FEmptyPt[i] := True;
      FNext[i] := -1;
      cur   := -1;
      First := -1;
    end;
  if (First <> -1) and (cur <> First) then
    FNext[cur] := First;

  setlength(FPrev, length(FPoints));
  for i := 0 to high(FPrev) do
    FPrev[i] := -1;
  for i := 0 to high(FNext) do
    if FNext[i] <> -1 then
      FPrev[FNext[i]] := i;

  setlength(FSlopes, length(FPoints));

  //compute slopes
  for i := 0 to high(FPoints) do
    if not FEmptyPt[i] then
    begin
      j := FNext[i];

      if FPoints[i].y <> FPoints[j].y then
        FSlopes[i] := (FPoints[j].x - FPoints[i].x) / (FPoints[j].y - FPoints[i].y)
      else
        FSlopes[i] := EmptySingle;
    end
    else
      FSlopes[i]    := EmptySingle;

  //slice
  nbYList:= length(FPoints);
  setlength(YList, nbYList);
  for i := 0 to high(FPoints) do
    YList[i] := FPoints[i].y;

  for i := 1 to nbYList-1 do
  begin
    j := i;
    while (j>0) and (YList[j-1]> YList[j]) do
    begin
      Temp := YList[j];
      YList[j] := YList[j-1];
      YList[j-1] := Temp;
      dec(j);
    end;
  end;

  for i := nbYList-1 downto 1 do
    if YList[i-1] = YList[i] then
    begin
      for j := i to nbYList-2 do
        YList[j] := YList[j+1];
      dec(nbYList);
    end;
  setlength(FSlices, nbYList-1);
  for i := 0 to high(FSlices) do
  begin
    FSlices[i].y1 := YList[i];
    FSlices[i].y2 := YList[i+1];
    nbSeg := 0;
    for j := 0 to high(FSlopes) do
      if FSlopes[j]<>EmptySingle then
      begin
        k := FNext[j];
        if ((FPoints[j].y < FSlices[i].y2) and
           (FPoints[k].y > FSlices[i].y1)) or
           ((FPoints[k].y < FSlices[i].y2) and
           (FPoints[j].y > FSlices[i].y1)) then
        begin
          inc(NbSeg);
        end;
      end;
    setlength(FSlices[i].segments, nbSeg);
    nbSeg := 0;
    for j := 0 to high(FSlopes) do
      if FSlopes[j]<>EmptySingle then
      begin
        k := FNext[j];
        if ((FPoints[j].y < FSlices[i].y2) and
           (FPoints[k].y > FSlices[i].y1)) or
           ((FPoints[k].y < FSlices[i].y2) and
           (FPoints[j].y > FSlices[i].y1)) then
        begin
          with FSlices[i].segments[nbSeg] do
          begin
            x1 := (FSlices[i].y1 - FPoints[j].y) * FSlopes[j] + FPoints[j].x;
            y1 := FSlices[i].y1;
            slope := FSlopes[j];
            winding := ComputeWinding(FPoints[j].y,FPoints[k].y);
          end;
          inc(NbSeg);
        end else
        if (FPoints[j].y=FPoints[k].y) and
           (FPoints[j].y >= FSlices[i].y1) and
           (FPoints[j].y <= FSlices[i].y2) then
        begin
          with FSlices[i].segments[nbSeg] do
          begin
            x1 := FPoints[j].x;
            y1 := FPoints[j].y;
            slope := 0;
            winding := ComputeWinding(FPoints[FPrev[j]].y,FPoints[j].y);
          end;
          inc(NbSeg);
        end;
      end;
  end;
  FCurSlice := 0;
end;

function TFillPolyInfo.GetBounds: TRect;
var
  minx, miny, maxx, maxy, i: integer;
begin
  miny := floor(FPoints[0].y);
  maxy := ceil(FPoints[0].y);
  minx := floor(FPoints[0].x);
  maxx := ceil(FPoints[0].x);
  for i := 1 to high(FPoints) do
    if not FEmptyPt[i] then
    begin
      if floor(FPoints[i].y) < miny then
        miny := floor(FPoints[i].y)
      else
      if ceil(FPoints[i].y) > maxy then
        maxy := ceil(FPoints[i].y);

      if floor(FPoints[i].x) < minx then
        minx := floor(FPoints[i].x)
      else
      if ceil(FPoints[i].x) > maxx then
        maxx := ceil(FPoints[i].x);
    end;
  Result := rect(minx, miny, maxx + 1, maxy + 1);
end;

function TFillPolyInfo.NbMaxIntersection: integer;
begin
  Result := length(FPoints);
end;

procedure TFillPolyInfo.ComputeIntersection(cury: single;
  var inter: ArrayOfSingle; var winding: arrayOfInteger; var nbInter: integer);
var
  j: integer;
begin
  if length(FSlices)=0 then exit;

  while (cury < FSlices[FCurSlice].y1) and (FCurSlice > 0) do dec(FCurSlice);
  while (cury > FSlices[FCurSlice].y2) and (FCurSlice < high(FSlices)) do inc(FCurSlice);
  with FSlices[FCurSlice] do
  if (cury >= y1) and (cury <= y2) then
  begin
    for j := 0 to high(segments) do
    begin
      inter[nbinter] := (cury - segments[j].y1) * segments[j].slope + segments[j].x1;
      winding[nbinter] := segments[j].winding;
      Inc(nbinter);
    end;
  end;
end;

{ TFillEllipseInfo }

constructor TFillEllipseInfo.Create(x, y, rx, ry: single);
begin
  FX  := x + 0.5;
  FY  := y + 0.5;
  FRX := abs(rx);
  FRY := abs(ry);
  WindingFactor := 1;
end;

function TFillEllipseInfo.GetBounds: TRect;
begin
  Result := rect(floor(fx - frx), floor(fy - fry), ceil(fx + frx), ceil(fy + fry));
end;

function TFillEllipseInfo.NbMaxIntersection: integer;
begin
  Result := 2;
end;

procedure TFillEllipseInfo.ComputeIntersection(cury: single;
  var inter: ArrayOfSingle; var winding: arrayOfInteger; var nbInter: integer);
var
  d: single;
begin
  d := sqr((cury - FY) / FRY);
  if d < 1 then
  begin
    d := sqrt(1 - d) * FRX;
    inter[nbinter] := FX - d;
    winding[nbinter] := -windingFactor;
    Inc(nbinter);
    inter[nbinter] := FX + d;
    winding[nbinter] := windingFactor;
    Inc(nbinter);
  end;
end;

{ TFillBorderEllipseInfo }

constructor TFillBorderEllipseInfo.Create(x, y, rx, ry, w: single);
begin
  if rx < 0 then
    rx := -rx;
  if ry < 0 then
    ry := -ry;
  outerBorder := TFillEllipseInfo.Create(x, y, rx + w / 2, ry + w / 2);
  if (rx > w / 2) and (ry > w / 2) then
  begin
    innerBorder := TFillEllipseInfo.Create(x, y, rx - w / 2, ry - w / 2);
    innerBorder.WindingFactor := -1;
  end
  else
    innerBorder := nil;
end;

function TFillBorderEllipseInfo.GetBounds: TRect;
begin
  Result := outerBorder.GetBounds;
end;

function TFillBorderEllipseInfo.NbMaxIntersection: integer;
begin
  Result := 4;
end;

procedure TFillBorderEllipseInfo.ComputeIntersection(cury: single;
  var inter: ArrayOfSingle; var winding: arrayOfInteger; var nbInter: integer);
begin
  outerBorder.ComputeIntersection(cury, inter, winding, nbInter);
  if innerBorder <> nil then
    innerBorder.ComputeIntersection(cury, inter, winding, nbInter);
end;

destructor TFillBorderEllipseInfo.Destroy;
begin
  outerBorder.Free;
  if innerBorder <> nil then
    innerBorder.Free;
  inherited Destroy;
end;

{----------- Spline ---------------------------}

procedure FillRoundRectangleAntialias(bmp: TBGRACustomBitmap; x1, y1, x2, y2,
  rx, ry: single; options: TRoundRectangleOptions; c: TBGRAPixel; EraseMode: boolean);
var
  info: TFillRoundRectangleInfo;
begin
  if (x1 = x2) or (y1 = y2) then exit;
  info := TFillRoundRectangleInfo.Create(x1, y1, x2, y2, rx, ry, options);
  FillShapeAntialias(bmp, info, c, EraseMode, False);
  info.Free;
end;

procedure FillRoundRectangleAntialiasWithTexture(bmp: TBGRACustomBitmap; x1,
  y1, x2, y2, rx, ry: single; options: TRoundRectangleOptions;
  texture: TBGRACustomBitmap);
var
  info: TFillRoundRectangleInfo;
begin
  if (x1 = x2) or (y1 = y2) then exit;
  info := TFillRoundRectangleInfo.Create(x1, y1, x2, y2, rx, ry, options);
  FillShapeAntialiasWithTexture(bmp, info, texture, False);
  info.Free;
end;

procedure BorderRoundRectangleAntialias(bmp: TBGRACustomBitmap; x1, y1, x2,
  y2, rx, ry, w: single; options: TRoundRectangleOptions; c: TBGRAPixel;
  EraseMode: boolean);
var
  info: TFillBorderRoundRectInfo;
begin
  if (rx = 0) or (ry = 0) then exit;
  info := TFillBorderRoundRectInfo.Create(x1, y1, x2,y2, rx, ry, w, options);
  FillShapeAntialias(bmp, info, c, EraseMode, False);
  info.Free;
end;

procedure BorderRoundRectangleAntialiasWithTexture(bmp: TBGRACustomBitmap; x1,
  y1, x2, y2, rx, ry, w: single; options: TRoundRectangleOptions;
  texture: TBGRACustomBitmap);
var
  info: TFillBorderRoundRectInfo;
begin
  if (rx = 0) or (ry = 0) then exit;
  info := TFillBorderRoundRectInfo.Create(x1, y1, x2,y2, rx, ry, w, options);
  FillShapeAntialiasWithTexture(bmp, info, texture, False);
  info.Free;
end;

procedure BorderAndFillRoundRectangleAntialias(bmp: TBGRACustomBitmap; x1, y1,
  x2, y2, rx, ry, w: single; options: TRoundRectangleOptions; bordercolor,
  fillcolor: TBGRAPixel; EraseMode: boolean);
var
  info: TFillBorderRoundRectInfo;
begin
  if (rx = 0) or (ry = 0) then exit;
  info := TFillBorderRoundRectInfo.Create(x1, y1, x2,y2, rx, ry, w, options);
  FillShapeAntialias(bmp, info.innerBorder, fillcolor, EraseMode, False);
  FillShapeAntialias(bmp, info, bordercolor, EraseMode, False);
  info.Free;
end;

function Spline(y0, y1, y2, y3: single; t: single): single;
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

function ComputeCurvePrecision(pt1, pt2, pt3, pt4: TPointF): integer;
var
  len: single;
begin
  len    := sqr(pt1.x - pt2.x) + sqr(pt1.y - pt2.y);
  len    := max(len, sqr(pt3.x - pt2.x) + sqr(pt3.y - pt2.y));
  len    := max(len, sqr(pt3.x - pt4.x) + sqr(pt3.y - pt4.y));
  Result := round(sqrt(sqrt(len)) * 2);
end;

function ComputeBezierCurve(const curve: TCubicBezierCurve): ArrayOfTPointF; overload;
var
  t,f1,f2,f3,f4: single;
  i,nb: Integer;
begin
  nb := ComputeCurvePrecision(curve.p1,curve.c1,curve.c2,curve.p2);
  if nb <= 1 then nb := 2;
  setlength(result,nb);
  result[0] := curve.p1;
  result[nb-1] := curve.p2;
  for i := 1 to nb-2 do
  begin
    t := i/(nb-1);
    f1 := (1-t);
    f2 := f1*f1;
    f1 *= f2;
    f2 *= t*3;
    f4 := t*t;
    f3 := f4*(1-t)*3;
    f4 *= t;

    result[i] := PointF(f1*curve.p1.x + f2*curve.c1.x +
                  f3*curve.c2.x + f4*curve.p2.x,
                  f1*curve.p1.y + f2*curve.c1.y +
                  f3*curve.c2.y + f4*curve.p2.y);
  end;
end;

function ComputeBezierCurve(const curve: TQuadraticBezierCurve): ArrayOfTPointF; overload;
var
  t,f1,f2,f3: single;
  i,nb: Integer;
begin
  nb := ComputeCurvePrecision(curve.p1,curve.c,curve.c,curve.p2);
  if nb <= 1 then nb := 2;
  setlength(result,nb);
  result[0] := curve.p1;
  result[nb-1] := curve.p2;
  for i := 1 to nb-2 do
  begin
    t := i/(nb-1);
    f1 := (1-t);
    f3 := t;
    f2 := f1*f3*2;
    f1 *= f1;
    f3 *= f3;
    result[i] := PointF(f1*curve.p1.x + f2*curve.c.x + f3*curve.p2.x,
                  f1*curve.p1.y + f2*curve.c.y + f3*curve.p2.y);
  end;
end;

function ComputeBezierSpline(const spline: array of TCubicBezierCurve): ArrayOfTPointF;
var
  curves: array of array of TPointF;
  nb: integer;
  lastPt: TPointF;
  i: Integer;
  j: Integer;

  procedure AddPt(pt: TPointF); inline;
  begin
    result[nb]:= pt;
    inc(nb);
    lastPt := pt;
  end;

  function EqLast(pt: TPointF): boolean;
  begin
    result := (pt.x = lastPt.x) and (pt.y = lastPt.y);
  end;

begin
  if length(spline)= 0 then
  begin
    setlength(result,0);
    exit;
  end;
  setlength(curves, length(spline));
  for i := 0 to high(spline) do
    curves[i] := ComputeBezierCurve(spline[i]);
  nb := length(curves[0]);
  lastPt := curves[0][high(curves[0])];
  for i := 1 to high(curves) do
  begin
    inc(nb,length(curves[i]));
    if EqLast(curves[i][0]) then dec(nb);
    lastPt := curves[i][high(curves[i])];
  end;
  setlength(result,nb);
  nb := 0;
  for j := 0 to high(curves[0]) do
    AddPt(curves[0][j]);
  for i := 1 to high(curves) do
  begin
    if not EqLast(curves[i][0]) then AddPt(curves[i][0]);
    for j := 1 to high(curves[i]) do
      AddPt(curves[i][j]);
  end;
end;

function ComputeBezierSpline(const spline: array of TQuadraticBezierCurve
  ): ArrayOfTPointF;
var
  curves: array of array of TPointF;
  nb: integer;
  lastPt: TPointF;
  i: Integer;
  j: Integer;

  procedure AddPt(pt: TPointF); inline;
  begin
    result[nb]:= pt;
    inc(nb);
    lastPt := pt;
  end;

  function EqLast(pt: TPointF): boolean;
  begin
    result := (pt.x = lastPt.x) and (pt.y = lastPt.y);
  end;

begin
  if length(spline)= 0 then
  begin
    setlength(result,0);
    exit;
  end;
  setlength(curves, length(spline));
  for i := 0 to high(spline) do
    curves[i] := ComputeBezierCurve(spline[i]);
  nb := length(curves[0]);
  lastPt := curves[0][high(curves[0])];
  for i := 1 to high(curves) do
  begin
    inc(nb,length(curves[i]));
    if EqLast(curves[i][0]) then dec(nb);
    lastPt := curves[i][high(curves[i])];
  end;
  setlength(result,nb);
  nb := 0;
  for j := 0 to high(curves[0]) do
    AddPt(curves[0][j]);
  for i := 1 to high(curves) do
  begin
    if not EqLast(curves[i][0]) then AddPt(curves[i][0]);
    for j := 1 to high(curves[i]) do
      AddPt(curves[i][j]);
  end;
end;

function ComputeClosedSpline(const points: array of TPointF): ArrayOfTPointF;
var
  i, j, nb, idx, pre: integer;
  ptPrev, ptPrev2, ptNext, ptNext2: TPointF;

begin
  if length(points) <= 2 then
  begin
    setlength(result,length(points));
    for i := 0 to high(result) do
      result[i] := points[i];
    exit;
  end;

  nb := 1;
  for i := 0 to high(points) do
  begin
    ptPrev2 := points[(i + length(points) - 1) mod length(points)];
    ptPrev  := points[i];
    ptNext  := points[(i + 1) mod length(points)];
    ptNext2 := points[(i + 2) mod length(points)];
    nb      += ComputeCurvePrecision(ptPrev2, ptPrev, ptNext, ptNext2);
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
    pre     := ComputeCurvePrecision(ptPrev2, ptPrev, ptNext, ptNext2);
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

function ComputeOpenedSpline(const points: array of TPointF): ArrayOfTPointF;
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
    nb      += ComputeCurvePrecision(ptPrev2, ptPrev, ptNext, ptNext2);
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
    pre     := ComputeCurvePrecision(ptPrev2, ptPrev, ptNext, ptNext2);
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

{ TFillRoundRectangleInfo }

constructor TFillRoundRectangleInfo.Create(x1, y1, x2, y2, rx, ry: single; options: TRoundRectangleOptions);
var
  temp: Single;
begin
  if y1 > y2 then
  begin
    temp := y1;
    y1 := y2;
    y2 := temp;
  end;
  if x1 > x2 then
  begin
    temp := x1;
    x1 := x2;
    x2 := temp;
  end;
  FX1  := x1 + 0.5;
  FY1  := y1 + 0.5;
  FX2  := x2 + 0.5;
  FY2  := y2 + 0.5;
  FRX := abs(rx);
  FRY := abs(ry);
  FOptions:= options;
  WindingFactor := 1;
end;

function TFillRoundRectangleInfo.GetBounds: TRect;
begin
  result := rect(floor(fx1),floor(fy1),floor(fx2)+1,floor(fy2)+1);
end;

function TFillRoundRectangleInfo.NbMaxIntersection: integer;
begin
  result := 2;
end;

procedure TFillRoundRectangleInfo.ComputeIntersection(cury: single;
  var inter: ArrayOfSingle; var winding: arrayOfInteger; var nbInter: integer);
var
  d,d2: single;
begin
  if (cury >= FY1) and (cury <= FY2) then
  begin
    if cury < FY1+FRY then
    begin
      d := abs((cury - (FY1+FRY)) / FRY);
      d2 := sqrt(1 - sqr(d)) * FRX;

      if rrTopLeftSquare in FOptions then
        inter[nbinter] := FX1 else
      if rrTopLeftBevel in FOptions then
        inter[nbinter] := FX1 + d*FRX
      else
        inter[nbinter] := FX1 + FRX - d2;
      winding[nbinter] := -windingFactor;
      Inc(nbinter);

      if rrTopRightSquare in FOptions then
        inter[nbinter] := FX2 else
      if rrTopRightBevel in FOptions then
        inter[nbinter] := FX2 - d*FRX
      else
        inter[nbinter] := FX2 - FRX + d2;
      winding[nbinter] := +windingFactor;
      Inc(nbinter);
    end else
    if cury > FY2-FRY then
    begin
      d := abs((cury - (FY2-FRY)) / FRY);
      d2 := sqrt(1 - sqr(d)) * FRX;

      if rrBottomLeftSquare in FOptions then
        inter[nbinter] := FX1 else
      if rrBottomLeftBevel in FOptions then
        inter[nbinter] := FX1 + d*FRX
      else
        inter[nbinter] := FX1 + FRX - d2;
      winding[nbinter] := -windingFactor;
      Inc(nbinter);

      if rrBottomRightSquare in FOptions then
        inter[nbinter] := FX2 else
      if rrBottomRightBevel in FOptions then
        inter[nbinter] := FX2 - d*FRX
      else
        inter[nbinter] := FX2 - FRX + d2;
      winding[nbinter] := +windingFactor;
      Inc(nbinter);
    end else
    begin
      inter[nbinter] := FX1;
      winding[nbinter] := -windingFactor;
      Inc(nbinter);
      inter[nbinter] := FX2;
      winding[nbinter] := +windingFactor;
      Inc(nbinter);
    end;
  end;
end;

{ TFillBorderRoundRectInfo }

constructor TFillBorderRoundRectInfo.Create(x1, y1, x2, y2, rx, ry, w: single; options: TRoundRectangleOptions);
var rdiff: single;
begin
  if rx < 0 then
    rx := -rx;
  if ry < 0 then
    ry := -ry;
  rdiff := w*(sqrt(2)-1);
  outerBorder := TFillRoundRectangleInfo.Create(x1-w/2,y1-w/2,x2+w/2,y2+w/2, rx+rdiff, ry+rdiff, options);
  if (abs(x2-x1) > w) and (abs(y2-y1) > w) then
  begin
    if (rx-rdiff <= 0) or (ry-rdiff <= 0) then
      innerBorder := TFillRoundRectangleInfo.Create(x1+w/2, y1+w/2, x2-w/2, y2-w/2, 0,0, options)
    else
      innerBorder := TFillRoundRectangleInfo.Create(x1+w/2, y1+w/2, x2-w/2, y2-w/2, rx-rdiff, ry-rdiff, options);
    innerBorder.WindingFactor := -1;
  end
  else
    innerBorder := nil;
end;

function TFillBorderRoundRectInfo.GetBounds: TRect;
begin
  result := outerBorder.GetBounds;
end;

function TFillBorderRoundRectInfo.NbMaxIntersection: integer;
begin
  Result := 4;
end;

procedure TFillBorderRoundRectInfo.ComputeIntersection(cury: single;
  var inter: ArrayOfSingle; var winding: arrayOfInteger; var nbInter: integer);
begin
  outerBorder.ComputeIntersection(cury, inter, winding, nbInter);
  if innerBorder <> nil then
    innerBorder.ComputeIntersection(cury, inter, winding, nbInter);
end;

destructor TFillBorderRoundRectInfo.Destroy;
begin
  outerBorder.Free;
  innerBorder.Free;
  inherited Destroy;
end;

end.
