unit BGRAPolygon;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, BGRADefaultBitmap, BGRABitmapTypes;

type
  ArrayOfSingle = array of single;

  { TFillShapeInfo }

  TFillShapeInfo = class
    function GetBounds: TRect; virtual;
    function NbMaxIntersection: integer; virtual;
    procedure ComputeIntersection(cury: single; var inter: ArrayOfSingle;
      var nbInter: integer); virtual;
  end;

procedure FillShapeAntialias(bmp: TBGRADefaultBitmap; shapeInfo: TFillShapeInfo;
  c: TBGRAPixel; EraseMode: boolean);

type
  { TFillPolyInfo }

  TFillPolyInfo = class(TFillShapeInfo)
  private
    FPoints:      array of TPointF;
    FSlopes:      array of single;
    FEmptyPt, FChangedir: array of boolean;
    FNext, FPrev: array of integer;
  public
    constructor Create(points: array of TPointF);
    function GetBounds: TRect; override;
    function NbMaxIntersection: integer; override;
    procedure ComputeIntersection(cury: single; var inter: ArrayOfSingle;
      var nbInter: integer); override;
  end;

procedure FillPolyAntialias(bmp: TBGRADefaultBitmap; points: array of TPointF;
  c: TBGRAPixel; EraseMode: boolean);

type
  { TFillEllipseInfo }

  TFillEllipseInfo = class(TFillShapeInfo)
  private
    FX, FY, FRX, FRY: single;
  public
    constructor Create(x, y, rx, ry: single);
    function GetBounds: TRect; override;
    function NbMaxIntersection: integer; override;
    procedure ComputeIntersection(cury: single; var inter: ArrayOfSingle;
      var nbInter: integer); override;
  end;

procedure FillEllipseAntialias(bmp: TBGRADefaultBitmap; x, y, rx, ry: single;
  c: TBGRAPixel; EraseMode: boolean);

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
      var nbInter: integer); override;
    destructor Destroy; override;
  end;

procedure BorderEllipseAntialias(bmp: TBGRADefaultBitmap; x, y, rx, ry, w: single;
  c: TBGRAPixel; EraseMode: boolean);

implementation

uses Math, bgrablend;

procedure FillShapeAntialias(bmp: TBGRADefaultBitmap; shapeInfo: TFillShapeInfo;
  c: TBGRAPixel; EraseMode: boolean);
const
  precision = 11;
var
  bounds: TRect;
  miny, maxy, minx, maxx: integer;

  inter:   array of single;
  nbInter: integer;
  density: packed array of single;

  xb, yb, yc, i, j: integer;

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
  setlength(density, maxx - minx + 2); //one more for safety

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
      shapeInfo.ComputeIntersection(cury, inter, nbInter);
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
          Dec(j);
        end;
      end;

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

procedure FillPolyAntialias(bmp: TBGRADefaultBitmap; points: array of TPointF;
  c: TBGRAPixel; EraseMode: boolean);
var
  info: TFillPolyInfo;
begin
  if length(points) < 3 then
    exit;

  info := TFillPolyInfo.Create(points);
  FillShapeAntialias(bmp, info, c, EraseMode);
  info.Free;
end;

procedure FillEllipseAntialias(bmp: TBGRADefaultBitmap; x, y, rx, ry: single;
  c: TBGRAPixel; EraseMode: boolean);
var
  info: TFillEllipseInfo;
begin
  if (rx = 0) or (ry = 0) then
    exit;

  info := TFillEllipseInfo.Create(x, y, rx, ry);
  FillShapeAntialias(bmp, info, c, EraseMode);
  info.Free;
end;

procedure BorderEllipseAntialias(bmp: TBGRADefaultBitmap; x, y, rx, ry, w: single;
  c: TBGRAPixel; EraseMode: boolean);
var
  info: TFillBorderEllipseInfo;
begin
  if (rx = 0) or (ry = 0) then
    exit;
  info := TFillBorderEllipseInfo.Create(x, y, rx, ry, w);
  FillShapeAntialias(bmp, info, c, EraseMode);
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
  var inter: ArrayOfSingle; var nbInter: integer);
begin

end;

{$hints on}

{ TFillPolyInfo }

constructor TFillPolyInfo.Create(points: array of TPointF);
var
  i, j: integer;
  First, cur, nbP: integer;
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
  setlength(FChangedir, length(FPoints));

  //compute slopes
  for i := 0 to high(FPoints) do
    if not FEmptyPt[i] then
    begin
      j := FNext[i];

      if FPoints[i].y <> FPoints[j].y then
        FSlopes[i] := (FPoints[j].x - FPoints[i].x) / (FPoints[j].y - FPoints[i].y)
      else
        FSlopes[i] := EmptySingle;

      FChangedir[i] := ((FPoints[i].y - FPoints[j].y > 0) and
        (FPoints[FPrev[i]].y - FPoints[i].y < 0)) or
        ((FPoints[i].y - FPoints[j].y < 0) and (FPoints[FPrev[i]].y - FPoints[i].y > 0));
    end
    else
    begin
      FSlopes[i]    := EmptySingle;
      FChangedir[i] := False;
    end;

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
  var inter: ArrayOfSingle; var nbInter: integer);
var
  i, j: integer;
begin
  for i := 0 to high(FPoints) do
    if not FEmptyPt[i] then
    begin
      if cury = FPoints[i].y then
      begin
        if not FChangedir[i] then
        begin
          inter[nbinter] := FPoints[i].x;
          Inc(nbinter);
        end;
      end
      else
      if (FSlopes[i] <> EmptySingle) then
      begin
        j := FNext[i];
        if (((cury >= FPoints[i].y) and (cury < FPoints[j].y)) or
          ((cury > FPoints[j].y) and (cury <= FPoints[i].y))) then
        begin
          inter[nbinter] := (cury - FPoints[i].y) * FSlopes[i] + FPoints[i].x;
          Inc(nbinter);
        end;
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
  var inter: ArrayOfSingle; var nbInter: integer);
var
  d: single;
begin
  d := sqr((cury - FY) / FRY);
  if d < 1 then
  begin
    d := sqrt(1 - d) * FRX;
    inter[nbinter] := FX - d;
    Inc(nbinter);
    inter[nbinter] := FX + d;
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
    innerBorder := TFillEllipseInfo.Create(x, y, rx - w / 2, ry - w / 2)
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
  var inter: ArrayOfSingle; var nbInter: integer);
begin
  outerBorder.ComputeIntersection(cury, inter, nbInter);
  if innerBorder <> nil then
    innerBorder.ComputeIntersection(cury, inter, nbInter);
end;

destructor TFillBorderEllipseInfo.Destroy;
begin
  outerBorder.Free;
  if innerBorder <> nil then
    innerBorder.Free;
  inherited Destroy;
end;

end.

