unit BGRAFilters;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, BGRADefaultBitmap, BGRABitmapTypes;

function FilterMedian(bmp: TBGRADefaultBitmap;
  Option: TMedianOption): TBGRADefaultBitmap;
function FilterSmartZoom3(bmp: TBGRADefaultBitmap;
  Option: TMedianOption): TBGRADefaultBitmap;
function FilterSharpen(bmp: TBGRADefaultBitmap): TBGRADefaultBitmap;
function FilterBlurRadialPrecise(bmp: TBGRADefaultBitmap;
  radius: single): TBGRADefaultBitmap;
function FilterBlurRadial(bmp: TBGRADefaultBitmap; radius: integer;
  blurType: TRadialBlurType): TBGRADefaultBitmap;
function FilterBlurMotion(bmp: TBGRADefaultBitmap; distance: single;
  angle: single; oriented: boolean): TBGRADefaultBitmap;
function FilterBlur(bmp: TBGRADefaultBitmap;
  blurMask: TBGRADefaultBitmap): TBGRADefaultBitmap;
function FilterEmboss(bmp: TBGRADefaultBitmap; angle: single): TBGRADefaultBitmap;
function FilterEmbossHighlight(bmp: TBGRADefaultBitmap;
  FillSelection: boolean): TBGRADefaultBitmap;
function FilterNormalize(bmp: TBGRADefaultBitmap;
  eachChannel: boolean = True): TBGRADefaultBitmap;
function FilterRotate(bmp: TBGRADefaultBitmap; origin: TPointF;
  angle: single): TBGRADefaultBitmap;
function FilterGrayscale(bmp: TBGRADefaultBitmap): TBGRADefaultBitmap;
function FilterContour(bmp: TBGRADefaultBitmap): TBGRADefaultBitmap;
function FilterSphere(bmp: TBGRADefaultBitmap): TBGRADefaultBitmap;
function FilterCylinder(bmp: TBGRADefaultBitmap): TBGRADefaultBitmap;
function FilterPlane(bmp: TBGRADefaultBitmap): TBGRADefaultBitmap;

implementation

uses Math;

function FilterSmartZoom3(bmp: TBGRADefaultBitmap;
  Option: TMedianOption): TBGRADefaultBitmap;
type
  TSmartDiff = record
    d, cd, sd, b, a: single;
  end;

var
  xb, yb: integer;
  diag1, diag2, h1, h2, v1, v2: TSmartDiff;
  c:      TBGRAPixel;
  temp, median: TBGRADefaultBitmap;

  function ColorDiff(c1, c2: TBGRAPixel): single;
  var
    max1, max2: integer;
  begin
    if (c1.alpha = 0) and (c2.alpha = 0) then
    begin
      Result := 0;
      exit;
    end
    else
    if (c1.alpha = 0) or (c2.alpha = 0) then
    begin
      Result := 1;
      exit;
    end;
    max1 := c1.red;
    if c1.green > max1 then
      max1 := c1.green;
    if c1.blue > max1 then
      max1 := c1.blue;

    max2 := c2.red;
    if c2.green > max2 then
      max2 := c2.green;
    if c2.blue > max2 then
      max2 := c2.blue;

    if (max1 = 0) or (max2 = 0) then
    begin
      Result := 0;
      exit;
    end;
    Result := (abs(c1.red / max1 - c2.red / max2) +
      abs(c1.green / max1 - c2.green / max2) + abs(c1.blue / max1 - c2.blue / max2)) / 3;
  end;

  function RGBDiff(c1, c2: TBGRAPixel): single;
  begin
    if (c1.alpha = 0) and (c2.alpha = 0) then
    begin
      Result := 0;
      exit;
    end
    else
    if (c1.alpha = 0) or (c2.alpha = 0) then
    begin
      Result := 1;
      exit;
    end;
    Result := (abs(c1.red - c2.red) + abs(c1.green - c2.green) +
      abs(c1.blue - c2.blue)) / 3 / 255;
  end;

  function smartDiff(x1, y1, x2, y2: integer): TSmartDiff;
  var
    c1, c2, c1m, c2m: TBGRAPixel;
  begin
    c1  := bmp.GetPixel(x1, y1);
    c2  := bmp.GetPixel(x2, y2);
    c1m := median.GetPixel(x1, y1);
    c2m := median.GetPixel(x2, y2);
    Result.d := RGBDiff(c1, c2);
    Result.cd := ColorDiff(c1, c2);
    Result.a := c1.alpha / 255 * c2.alpha / 255;
    Result.d := Result.d * Result.a + (1 - Result.a) *
      (1 + abs(c1.alpha - c2.alpha) / 255) / 5;
    Result.b := RGBDiff(c1, c1m) * c1.alpha / 255 * c1m.alpha / 255 +
      RGBDiff(c2, c2m) * c2.alpha / 255 * c2m.alpha / 255 +
      (abs(c1.alpha - c1m.alpha) + abs(c2.alpha - c2m.alpha)) / 255 / 4;
    Result.sd := Result.d + Result.cd * 3;
  end;

var
  diff: single;

begin
  median := FilterMedian(bmp, moNone);

  temp   := bmp.Resample(bmp.Width * 3, bmp.Height * 3, rmSimpleStretch);
  Result := FilterMedian(temp, Option);
  temp.Free;

  for yb := 0 to bmp.Height - 2 do
    for xb := 0 to bmp.Width - 2 do
    begin
      diag1 := smartDiff(xb, yb, xb + 1, yb + 1);
      diag2 := smartDiff(xb, yb + 1, xb + 1, yb);

      h1 := smartDiff(xb, yb, xb + 1, yb);
      h2 := smartDiff(xb, yb + 1, xb + 1, yb + 1);
      v1 := smartDiff(xb, yb, xb, yb + 1);
      v2 := smartDiff(xb + 1, yb, xb + 1, yb + 1);

      diff := diag1.sd - diag2.sd;
      if abs(diff) < 3 then
        diff -= (diag1.b - diag2.b) * (3 - abs(diff)) / 2;
      //which diagonal to highlight?
      if abs(diff) < 0.2 then
        diff := 0;

      if diff < 0 then
      begin
        //same color?
        if diag1.cd < 0.3 then
        begin
          c := MergeBGRA(bmp.GetPixel(xb, yb), bmp.GetPixel(xb + 1, yb + 1));
          //restore
          Result.SetPixel(xb * 3 + 2, yb * 3 + 2, bmp.GetPixel(xb, yb));
          Result.SetPixel(xb * 3 + 3, yb * 3 + 3, bmp.GetPixel(xb + 1, yb + 1));

          if (diag1.sd < h1.sd) and (diag1.sd < v2.sd) then
            Result.SetPixel(xb * 3 + 3, yb * 3 + 2, c);
          if (diag1.sd < h2.sd) and (diag1.sd < v1.sd) then
            Result.SetPixel(xb * 3 + 2, yb * 3 + 3, c);
        end;
      end
      else
      if diff > 0 then
      begin
        //same color?
        if diag2.cd < 0.3 then
        begin
          c := MergeBGRA(bmp.GetPixel(xb, yb + 1), bmp.GetPixel(xb + 1, yb));
          //restore
          Result.SetPixel(xb * 3 + 3, yb * 3 + 2, bmp.GetPixel(xb + 1, yb));
          Result.SetPixel(xb * 3 + 2, yb * 3 + 3, bmp.GetPixel(xb, yb + 1));

          if (diag2.sd < h1.sd) and (diag2.sd < v1.sd) then
            Result.SetPixel(xb * 3 + 2, yb * 3 + 2, c);
          if (diag2.sd < h2.sd) and (diag2.sd < v2.sd) then
            Result.SetPixel(xb * 3 + 3, yb * 3 + 3, c);

        end;
      end;
    end;

  median.Free;
end;

function FilterSharpen(bmp: TBGRADefaultBitmap): TBGRADefaultBitmap;
const
  nbpix = 8;
var
  yb, xb:   integer;
  dx, dy, n, j: integer;
  a_pixels: array[0..nbpix - 1] of TBGRAPixel;
  sumR, sumG, sumB, sumA, RGBdiv, nbA: cardinal;
  tempPixel, refPixel: TBGRAPixel;
  pdest:    PBGRAPixel;
  bounds:   TRect;
begin
  Result := bmp.NewBitmap(bmp.Width, bmp.Height);

  bounds := bmp.GetImageBounds;
  if (bounds.Right <= bounds.Left) or (bounds.Bottom <= Bounds.Top) then
    exit;
  bounds.Left   := max(0, bounds.Left - 1);
  bounds.Top    := max(0, bounds.Top - 1);
  bounds.Right  := min(bmp.Width, bounds.Right + 1);
  bounds.Bottom := min(bmp.Height, bounds.Bottom + 1);

  for yb := bounds.Top to bounds.Bottom - 1 do
  begin
    pdest := Result.scanline[yb] + bounds.Left;
    for xb := bounds.Left to bounds.Right - 1 do
    begin
      n := 0;
      for dy := -1 to 1 do
        for dx := -1 to 1 do
          if (dx <> 0) or (dy <> 0) then
          begin
            a_pixels[n] := bmp.GetPixel(xb + dx, yb + dy);
            Inc(n);
          end;

      sumR   := 0;
      sumG   := 0;
      sumB   := 0;
      sumA   := 0;
      RGBdiv := 0;
      nbA    := 0;

       {$hints off}
      for j := 0 to n - 1 do
      begin
        tempPixel := a_pixels[j];
        sumR      += tempPixel.red * tempPixel.alpha;
        sumG      += tempPixel.green * tempPixel.alpha;
        sumB      += tempPixel.blue * tempPixel.alpha;
        RGBdiv    += tempPixel.alpha;
        sumA      += tempPixel.alpha;
        Inc(nbA);
      end;
       {$hints on}

      if (RGBdiv = 0) then
        refPixel := BGRAPixelTransparent
      else
      begin
        refPixel.red   := (sumR + RGBdiv shr 1) div RGBdiv;
        refPixel.green := (sumG + RGBdiv shr 1) div RGBdiv;
        refPixel.blue  := (sumB + RGBdiv shr 1) div RGBdiv;
        refPixel.alpha := (sumA + nbA shr 1) div nbA;
      end;

      tempPixel := bmp.GetPixel(xb, yb);
      if refPixel <> BGRAPixelTransparent then
      begin
        tempPixel.red   := max(0, min(255, tempPixel.red +
          integer(tempPixel.red - refPixel.red)));
        tempPixel.green := max(0, min(255, tempPixel.green +
          integer(tempPixel.green - refPixel.green)));
        tempPixel.blue  := max(0, min(255, tempPixel.blue +
          integer(tempPixel.blue - refPixel.blue)));
        tempPixel.alpha := max(0, min(255, tempPixel.alpha +
          integer(tempPixel.alpha - refPixel.alpha)));
      end;
      pdest^ := tempPixel;
      Inc(pdest);
    end;
  end;
  Result.InvalidateBitmap;
end;

function FilterBlurRadialPrecise(bmp: TBGRADefaultBitmap;
  radius: single): TBGRADefaultBitmap;
var
  blurShape: TBGRADefaultBitmap;
  intRadius: integer;
begin
  intRadius := ceil(radius);
  blurShape := TBGRADefaultBitmap.Create(2 * intRadius + 1, 2 * intRadius + 1);
  blurShape.GradientFill(0, 0, blurShape.Width, blurShape.Height, BGRAWhite,
    BGRABlack, gtRadial, pointF(intRadius, intRadius), pointF(
    intRadius - radius - 1, intRadius), dmSet);
  Result := FilterBlur(bmp, blurShape);
  blurShape.Free;
end;

function FilterBlurRadialNormal(bmp: TBGRADefaultBitmap;
  radius: integer): TBGRADefaultBitmap;
var
  blurShape: TBGRADefaultBitmap;
begin
  blurShape := TBGRADefaultBitmap.Create(2 * radius + 1, 2 * radius + 1);
  blurShape.GradientFill(0, 0, blurShape.Width, blurShape.Height, BGRAWhite,
    BGRABlack, gtRadial, pointF(radius, radius), pointF(-0.5, radius), dmSet);
  Result := FilterBlur(bmp, blurShape);
  blurShape.Free;
end;

function FilterBlurDisk(bmp: TBGRADefaultBitmap; radius: integer): TBGRADefaultBitmap;
var
  blurShape: TBGRADefaultBitmap;
begin
  blurShape := TBGRADefaultBitmap.Create(2 * radius + 1, 2 * radius + 1);
  blurShape.Fill(BGRABlack);
  blurShape.FillEllipseAntialias(radius, radius, radius + 0.5, radius + 0.5, BGRAWhite);
  Result := FilterBlur(bmp, blurShape);
  blurShape.Free;
end;

function FilterBlurCorona(bmp: TBGRADefaultBitmap; radius: integer): TBGRADefaultBitmap;
var
  blurShape: TBGRADefaultBitmap;
begin
  blurShape := TBGRADefaultBitmap.Create(2 * radius + 1, 2 * radius + 1);
  blurShape.Fill(BGRABlack);
  blurShape.EllipseAntialias(radius, radius, radius, radius, BGRAWhite, 1);
  Result := FilterBlur(bmp, blurShape);
  blurShape.Free;
end;

function FilterBlurRadial(bmp: TBGRADefaultBitmap; radius: integer;
  blurType: TRadialBlurType): TBGRADefaultBitmap;
begin
  case blurType of
    rbCorona: Result  := FilterBlurCorona(bmp, radius);
    rbDisk: Result    := FilterBlurDisk(bmp, radius);
    rbNormal: Result  := FilterBlurRadialNormal(bmp, radius);
    rbPrecise: Result := FilterBlurRadialPrecise(bmp, radius / 10);
    else
      Result := nil;
  end;
end;

function FilterBlurMotion(bmp: TBGRADefaultBitmap; distance: single;
  angle: single; oriented: boolean): TBGRADefaultBitmap;
var
  blurShape: TBGRADefaultBitmap;
  intRadius: integer;
  dx, dy, d: single;
begin
  intRadius := ceil(distance / 2);
  blurShape := TBGRADefaultBitmap.Create(2 * intRadius + 1, 2 * intRadius + 1);
  d  := distance / 2;
  dx := cos(angle * Pi / 180);
  dy := sin(angle * Pi / 180);
  blurShape.Fill(BGRABlack);
  blurShape.DrawLineAntialias(intRadius - dx * d, intRadius - dy *
    d, intRadius + dx * d, intRadius + dy * d, BGRAWhite, 1, True);
  if oriented then
    blurShape.GradientFill(0, 0, blurShape.Width, blurShape.Height,
      BGRAPixelTransparent, BGRABlack, gtRadial, pointF(intRadius -
      dx * d, intRadius - dy * d),
      pointF(intRadius + dx * (d + 0.5), intRadius + dy * (d + 0.5)),
      dmFastBlend, False);
  Result := FilterBlur(bmp, blurShape);
  blurShape.Free;
end;

function FilterBlur(bmp: TBGRADefaultBitmap;
  blurMask: TBGRADefaultBitmap): TBGRADefaultBitmap;
var
  yb, xb:      integer;
  dx, dy, mindx, maxdx, mindy, maxdy, n, j: integer;
  a_pixels:    array of TBGRAPixel;
  weights:     array of integer;
  sumR, sumG, sumB, sumA, Adiv, RGBdiv: cardinal;
  RGBweight:   byte;
  tempPixel, refPixel: TBGRAPixel;
  shapeMatrix: array of array of byte;
  pdest, psrc: PBGRAPixel;
  blurOfs:     TPoint;
  bounds:      TRect;
begin
  blurOfs := point(blurMask.Width shr 1, blurMask.Height shr 1);

  setlength(shapeMatrix, blurMask.Width, blurMask.Height);
  n := 0;
  for yb := 0 to blurMask.Height - 1 do
    for xb := 0 to blurMask.Width - 1 do
    begin
      shapeMatrix[yb, xb] := blurMask.GetPixel(xb, yb).red;
      if shapeMatrix[yb, xb] <> 0 then
        Inc(n);
    end;

  setlength(a_pixels, n);
  setlength(weights, n);

  Result := bmp.NewBitmap(bmp.Width, bmp.Height);
  bounds := bmp.GetImageBounds;
  if (bounds.Right <= bounds.Left) or (bounds.Bottom <= Bounds.Top) then
    exit;
  bounds.Left   := max(0, bounds.Left - blurOfs.X);
  bounds.Top    := max(0, bounds.Top - blurOfs.Y);
  bounds.Right  := min(bmp.Width, bounds.Right + blurMask.Width - 1 - blurOfs.X);
  bounds.Bottom := min(bmp.Height, bounds.Bottom + blurMask.Height - 1 - blurOfs.Y);

  for yb := bounds.Top to bounds.Bottom - 1 do
  begin
    pdest := Result.ScanLine[yb] + bounds.Left;
    for xb := bounds.Left to Bounds.Right - 1 do
    begin
      n     := 0;
      mindx := max(-blurOfs.X, -xb);
      mindy := max(-blurOfs.Y, -yb);
      maxdx := min(blurMask.Width - 1 - blurOfs.X, bmp.Width - 1 - xb);
      maxdy := min(blurMask.Height - 1 - blurOfs.Y, bmp.Height - 1 - yb);
      for dy := mindy to maxdy do
      begin
        psrc := bmp.scanline[yb + dy] + (xb + mindx);
        for dx := mindx to maxdx do
        begin
          j := shapeMatrix[dy + blurOfs.Y, dx + blurOfs.X];
          if j <> 0 then
          begin
            a_pixels[n] := psrc^;
            weights[n]  := (a_pixels[n].alpha * j + 127) shr 8;
            Inc(n);
          end;
          Inc(psrc);
        end;
      end;
      sumR   := 0;
      sumG   := 0;
      sumB   := 0;
      sumA   := 0;
      Adiv   := 0;
      RGBdiv := 0;

       {$hints off}
      for j := 0 to n - 1 do
      begin
        tempPixel := a_pixels[j];
        RGBweight := (weights[j] * tempPixel.alpha + 128) div 255;
        sumR      += tempPixel.red * RGBweight;
        sumG      += tempPixel.green * RGBweight;
        sumB      += tempPixel.blue * RGBweight;
        RGBdiv    += RGBweight;
        sumA      += tempPixel.alpha;
        Adiv      += 1;
      end;
       {$hints on}

      if (Adiv = 0) or (RGBdiv = 0) then
        refPixel := BGRAPixelTransparent
      else
      begin
        refPixel.alpha := (sumA + Adiv shr 1) div Adiv;
        if refPixel.alpha = 0 then
          refPixel := BGRAPixelTransparent
        else
        begin
          refPixel.red   := (sumR + RGBdiv shr 1) div RGBdiv;
          refPixel.green := (sumG + RGBdiv shr 1) div RGBdiv;
          refPixel.blue  := (sumB + RGBdiv shr 1) div RGBdiv;
        end;
      end;

      pdest^ := refPixel;
      Inc(pdest);
    end;
  end;
  Result.InvalidateBitmap;
end;

function FilterEmboss(bmp: TBGRADefaultBitmap; angle: single): TBGRADefaultBitmap;
var
  yb, xb: integer;
  dx, dy: single;
  idx1, idy1, idx2, idy2, idx3, idy3, idx4, idy4: integer;
  w:      array[1..4] of single;
  iw:     integer;
  c:      array[0..4] of TBGRAPixel;

  i:     integer;
  sumR, sumG, sumB, sumA, RGBdiv, Adiv: cardinal;
  tempPixel, refPixel: TBGRAPixel;
  pdest: PBGRAPixel;

  bounds: TRect;
begin
  dx   := cos(angle * Pi / 180);
  dy   := sin(angle * Pi / 180);
  idx1 := floor(dx);
  idy1 := floor(dy);
  idx2 := ceil(dx);
  idy2 := ceil(dy);
  idx3 := idx1;
  idy3 := idy2;
  idx4 := idx2;
  idy4 := idy1;

  w[1] := (1 - abs(idx1 - dx)) * (1 - abs(idy1 - dy));
  w[2] := (1 - abs(idx2 - dx)) * (1 - abs(idy2 - dy));
  w[3] := (1 - abs(idx3 - dx)) * (1 - abs(idy3 - dy));
  w[4] := (1 - abs(idx4 - dx)) * (1 - abs(idy4 - dy));

  Result := bmp.NewBitmap(bmp.Width, bmp.Height);
  Result.Fill(BGRA(128, 128, 128, 255));

  bounds := bmp.GetImageBounds;
  if (bounds.Right <= bounds.Left) or (bounds.Bottom <= Bounds.Top) then
    exit;
  bounds.Left   := max(0, bounds.Left - 1);
  bounds.Top    := max(0, bounds.Top - 1);
  bounds.Right  := min(bmp.Width, bounds.Right + 1);
  bounds.Bottom := min(bmp.Height, bounds.Bottom + 1);

  for yb := bounds.Top to bounds.bottom - 1 do
  begin
    pdest := Result.scanline[yb] + bounds.Left;
    for xb := bounds.Left to bounds.Right - 1 do
    begin
      c[0] := bmp.getPixel(xb, yb);
      c[1] := bmp.getPixel(xb + idx1, yb + idy1);
      c[2] := bmp.getPixel(xb + idx2, yb + idy2);
      c[3] := bmp.getPixel(xb + idx3, yb + idy3);
      c[4] := bmp.getPixel(xb + idx4, yb + idy4);

      sumR   := 0;
      sumG   := 0;
      sumB   := 0;
      sumA   := 0;
      Adiv   := 0;
      RGBdiv := 0;

       {$hints off}
      for i := 1 to 4 do
      begin
        tempPixel := c[i];
        if tempPixel.alpha = 0 then
          tempPixel := c[0];
        iw     := round(w[i] * tempPixel.alpha);
        sumR   += tempPixel.red * iw;
        sumG   += tempPixel.green * iw;
        sumB   += tempPixel.blue * iw;
        RGBdiv += iw;
        sumA   += iw;
        Adiv   += round(w[i] * 255);
      end;
       {$hints on}

      if (Adiv = 0) or (RGBdiv = 0) then
        refPixel := c[0]
      else
      begin
        refPixel.red   := (sumR + RGBdiv shr 1) div RGBdiv;
        refPixel.green := (sumG + RGBdiv shr 1) div RGBdiv;
        refPixel.blue  := (sumB + RGBdiv shr 1) div RGBdiv;
        refPixel.alpha := (sumA * 255 + Adiv shr 1) div Adiv;
      end;
       {$hints off}
      tempPixel.red := max(0, min(512 * 255, 65536 + refPixel.red *
        refPixel.alpha - c[0].red * c[0].alpha)) shr 9;
      tempPixel.green := max(0, min(512 * 255, 65536 + refPixel.green *
        refPixel.alpha - c[0].green * c[0].alpha)) shr 9;
      tempPixel.blue := max(0, min(512 * 255, 65536 + refPixel.blue *
        refPixel.alpha - c[0].blue * c[0].alpha)) shr 9;
       {$hints on}
      tempPixel.alpha := 255;
      pdest^ := tempPixel;
      Inc(pdest);
    end;
  end;
  Result.InvalidateBitmap;
end;

function FilterEmbossHighlight(bmp: TBGRADefaultBitmap;
  FillSelection: boolean): TBGRADefaultBitmap;
var
  yb, xb: integer;
  w:      array[1..6] of integer;
  c:      array[0..6] of TBGRAPixel;

  i, bmpWidth, bmpHeight: integer;
  slope, h: byte;
  sum:      integer;
  tempPixel, highlight: TBGRAPixel;
  pdest, psrcUp, psrc, psrcDown: PBGRAPixel;

  bounds: TRect;
begin
  for i := 1 to 3 do
  begin
    w[i]     := -1;
    w[i + 3] := 1;
  end;

  bmpWidth  := bmp.Width;
  bmpHeight := bmp.Height;
  Result    := bmp.NewBitmap(bmpWidth, bmpHeight);

  bounds := bmp.GetImageBounds(cRed);
  if (bounds.Right <= bounds.Left) or (bounds.Bottom <= Bounds.Top) then
    exit;
  bounds.Left   := max(0, bounds.Left - 1);
  bounds.Top    := max(0, bounds.Top - 1);
  bounds.Right  := min(bmpWidth, bounds.Right + 1);
  bounds.Bottom := min(bmpHeight, bounds.Bottom + 1);

  for yb := bounds.Top to bounds.Bottom - 1 do
  begin
    pdest := Result.scanline[yb] + bounds.Left;

    if yb > 0 then
      psrcUp := bmp.Scanline[yb - 1] + bounds.Left
    else
      psrcUp := nil;
    psrc := bmp.scanline[yb] + bounds.Left;
    if yb < bmpHeight - 1 then
      psrcDown := bmp.scanline[yb + 1] + bounds.Left
    else
      psrcDown := nil;

    for xb := bounds.Left to bounds.Right - 1 do
    begin
      c[0] := psrc^;
      if (xb = 0) then
      begin
        c[1] := c[0];
        c[2] := c[0];
      end
      else
      begin
        if psrcUp <> nil then
          c[1] := (psrcUp - 1)^
        else
          c[1] := c[0];
        c[2] := (psrc - 1)^;
      end;
      if psrcUp <> nil then
      begin
        c[3] := psrcUp^;
        Inc(psrcUp);
      end
      else
        c[3] := c[0];

      if (xb = bmpWidth - 1) then
      begin
        c[4] := c[0];
        c[5] := c[0];
      end
      else
      begin
        if psrcDown <> nil then
          c[4] := (psrcDown + 1)^
        else
          c[4] := c[0];
        c[5] := (psrc + 1)^;
      end;
      if psrcDown <> nil then
      begin
        c[6] := psrcDown^;
        Inc(psrcDown);
      end
      else
        c[6] := c[0];
      Inc(psrc);

     { c[1] := bmp.getPixel(xb-1,yb-1);
       c[2] := bmp.getPixel(xb-1,yb);
       c[3] := bmp.getPixel(xb,yb-1);
       c[4] := bmp.getPixel(xb+1,yb+1);
       c[5] := bmp.getPixel(xb+1,yb);
       c[6] := bmp.getPixel(xb,yb+1); }

      sum := 0;
      for i := 1 to 6 do
        sum += (c[i].red - c[0].red) * w[i];

      sum := 128 + sum div 3;
      if sum > 255 then
        slope := 255
      else
      if sum < 1 then
        slope := 1
      else
        slope := sum;
      h := c[0].red;

      tempPixel.red   := slope;
      tempPixel.green := slope;
      tempPixel.blue  := slope;
      tempPixel.alpha := abs(slope - 128) * 2;

      if fillSelection then
      begin
        highlight := BGRA(h shr 2, h shr 1, h, h shr 1);
        if tempPixel.red < highlight.red then
          tempPixel.red := highlight.red;
        if tempPixel.green < highlight.green then
          tempPixel.green := highlight.green;
        if tempPixel.blue < highlight.blue then
          tempPixel.blue := highlight.blue;
        if tempPixel.alpha < highlight.alpha then
          tempPixel.alpha := highlight.alpha;
      end;

      pdest^ := tempPixel;
      Inc(pdest);
    end;
  end;
  Result.InvalidateBitmap;
end;

function FilterNormalize(bmp: TBGRADefaultBitmap;
  eachChannel: boolean = True): TBGRADefaultBitmap;
var
  psrc, pdest: PBGRAPixel;
  c: TExpandedPixel;
  n: integer;
  minValRed, maxValRed, minValGreen, maxValGreen, minValBlue, maxValBlue,
  minAlpha, maxAlpha, addValRed, addValGreen, addValBlue, addAlpha: word;
  factorValRed, factorValGreen, factorValBlue, factorAlpha: integer;
begin
  Result := bmp.NewBitmap(bmp.Width, bmp.Height);
  bmp.LoadFromBitmapIfNeeded;
  psrc      := bmp.Data;
  maxValRed := 0;
  minValRed := 65535;
  maxValGreen := 0;
  minValGreen := 65535;
  maxValBlue := 0;
  minValBlue := 65535;
  maxAlpha  := 0;
  minAlpha  := 65535;
  for n := bmp.Width * bmp.Height - 1 downto 0 do
  begin
    c := GammaExpansion(psrc^);
    Inc(psrc);
    if c.red > maxValRed then
      maxValRed := c.red;
    if c.green > maxValGreen then
      maxValGreen := c.green;
    if c.blue > maxValBlue then
      maxValBlue := c.blue;
    if c.red < minValRed then
      minValRed := c.red;
    if c.green < minValGreen then
      minValGreen := c.green;
    if c.blue < minValBlue then
      minValBlue := c.blue;

    if c.alpha > maxAlpha then
      maxAlpha := c.alpha;
    if c.alpha < minAlpha then
      minAlpha := c.alpha;
  end;
  if not eachChannel then
  begin
    minValRed   := min(min(minValRed, minValGreen), minValBlue);
    maxValRed   := max(max(maxValRed, maxValGreen), maxValBlue);
    minValGreen := minValRed;
    maxValGreen := maxValRed;
    minValBlue  := minValBlue;
    maxValBlue  := maxValBlue;
  end;
  if maxValRed > minValRed then
  begin
    factorValRed := 268431360 div (maxValRed - minValRed);
    addValRed    := 0;
  end
  else
  begin
    factorValRed := 0;
    if minValRed = 0 then
      addValRed := 0
    else
      addValRed := 65535;
  end;
  if maxValGreen > minValGreen then
  begin
    factorValGreen := 268431360 div (maxValGreen - minValGreen);
    addValGreen    := 0;
  end
  else
  begin
    factorValGreen := 0;
    if minValGreen = 0 then
      addValGreen := 0
    else
      addValGreen := 65535;
  end;
  if maxValBlue > minValBlue then
  begin
    factorValBlue := 268431360 div (maxValBlue - minValBlue);
    addValBlue    := 0;
  end
  else
  begin
    factorValBlue := 0;
    if minValBlue = 0 then
      addValBlue := 0
    else
      addValBlue := 65535;
  end;
  if maxAlpha > minAlpha then
  begin
    factorAlpha := 268431360 div (maxAlpha - minAlpha);
    addAlpha    := 0;
  end
  else
  begin
    factorAlpha := 0;
    if minAlpha = 0 then
      addAlpha := 0
    else
      addAlpha := 65535;
  end;

  psrc  := bmp.Data;
  pdest := Result.Data;
  for n := bmp.Width * bmp.Height - 1 downto 0 do
  begin
    c := GammaExpansion(psrc^);
    Inc(psrc);
    c.red   := ((c.red - minValRed) * factorValRed + 2047) shr 12 + addValRed;
    c.green := ((c.green - minValGreen) * factorValGreen + 2047) shr 12 + addValGreen;
    c.blue  := ((c.blue - minValBlue) * factorValBlue + 2047) shr 12 + addValBlue;
    c.alpha := ((c.alpha - minAlpha) * factorAlpha + 2047) shr 12 + addAlpha;
    pdest^  := GammaCompression(c);
    Inc(pdest);
  end;
  Result.InvalidateBitmap;
end;

function FilterRotate(bmp: TBGRADefaultBitmap; origin: TPointF;
  angle: single): TBGRADefaultBitmap;
var
  bounds:     TRect;
  pdest:      PBGRAPixel;
  xsrc, ysrc: single;
  savexysrc, pt: TPointF;
  dx, dy:     single;
  xb, yb:     integer;
  minx, miny, maxx, maxy: single;

  function RotatePos(x, y: single): TPointF;
  var
    px, py: single;
  begin
    px     := x - origin.x;
    py     := y - origin.y;
    Result := PointF(origin.x + px * dx + py * dy, origin.y - px * dy + py * dx);
  end;

begin
  Result := bmp.NewBitmap(bmp.Width, bmp.Height);
  bounds := bmp.GetImageBounds;
  if (bounds.Right <= bounds.Left) or (bounds.Bottom <= Bounds.Top) then
    exit;

  //compute new bounding rectangle
  dx   := cos(angle * Pi / 180);
  dy   := -sin(angle * Pi / 180);
  pt   := RotatePos(bounds.left, bounds.top);
  minx := pt.x;
  miny := pt.y;
  maxx := pt.x;
  maxy := pt.y;
  pt   := RotatePos(bounds.Right - 1, bounds.top);
  if pt.x < minx then
    minx := pt.x
  else
  if pt.x > maxx then
    maxx := pt.x;
  if pt.y < miny then
    miny := pt.y
  else
  if pt.y > maxy then
    maxy := pt.y;
  pt     := RotatePos(bounds.Right - 1, bounds.bottom - 1);
  if pt.x < minx then
    minx := pt.x
  else
  if pt.x > maxx then
    maxx := pt.x;
  if pt.y < miny then
    miny := pt.y
  else
  if pt.y > maxy then
    maxy := pt.y;
  pt     := RotatePos(bounds.left, bounds.bottom - 1);
  if pt.x < minx then
    minx := pt.x
  else
  if pt.x > maxx then
    maxx := pt.x;
  if pt.y < miny then
    miny := pt.y
  else
  if pt.y > maxy then
    maxy := pt.y;

  bounds.left   := max(0, floor(minx));
  bounds.top    := max(0, floor(miny));
  bounds.right  := min(bmp.Width, ceil(maxx) + 1);
  bounds.bottom := min(bmp.Height, ceil(maxy) + 1);

  //reciproqual
  dy   := -dy;
  pt   := RotatePos(bounds.left, bounds.top);
  xsrc := pt.x;
  ysrc := pt.y;
  for yb := bounds.Top to bounds.bottom - 1 do
  begin
    pdest     := Result.scanline[yb] + bounds.left;
    savexysrc := pointf(xsrc, ysrc);
    for xb := bounds.left to bounds.right - 1 do
    begin
      pdest^ := bmp.GetPixel(xsrc, ysrc);
      Inc(pdest);
      xsrc += dx;
      ysrc -= dy;
    end;
    xsrc := savexysrc.x + dy;
    ysrc := savexysrc.y + dx;
  end;
  Result.InvalidateBitmap;
end;

function FilterGrayscale(bmp: TBGRADefaultBitmap): TBGRADefaultBitmap;
var
  bounds:      TRect;
  pdest, psrc: PBGRAPixel;
  xb, yb:      integer;

begin
  Result := bmp.NewBitmap(bmp.Width, bmp.Height);
  bounds := bmp.GetImageBounds;
  if (bounds.Right <= bounds.Left) or (bounds.Bottom <= Bounds.Top) then
    exit;

  for yb := bounds.Top to bounds.bottom - 1 do
  begin
    pdest := Result.scanline[yb] + bounds.left;
    psrc  := bmp.scanline[yb] + bounds.left;
    for xb := bounds.left to bounds.right - 1 do
    begin
      pdest^ := BGRAToGrayscale(psrc^);
      Inc(pdest);
      Inc(psrc);
    end;
  end;
  Result.InvalidateBitmap;
end;

function FilterContour(bmp: TBGRADefaultBitmap): TBGRADefaultBitmap;
var
  yb, xb: integer;
  c:      array[0..8] of TBGRAPixel;

  i, bmpWidth, bmpHeight: integer;
  slope: byte;
  sum:   integer;
  tempPixel: TBGRAPixel;
  pdest, psrcUp, psrc, psrcDown: PBGRAPixel;

  bounds: TRect;
  gray:   TBGRADefaultBitmap;
begin
  bmpWidth  := bmp.Width;
  bmpHeight := bmp.Height;
  Result    := bmp.NewBitmap(bmpWidth, bmpHeight);
  gray      := bmp.FilterGrayscale;

  bounds := rect(0, 0, bmp.Width, bmp.Height);
  for yb := bounds.Top to bounds.Bottom - 1 do
  begin
    pdest := Result.scanline[yb] + bounds.Left;

    if yb > 0 then
      psrcUp := gray.Scanline[yb - 1] + bounds.Left
    else
      psrcUp := nil;
    psrc := gray.scanline[yb] + bounds.Left;
    if yb < bmpHeight - 1 then
      psrcDown := gray.scanline[yb + 1] + bounds.Left
    else
      psrcDown := nil;

    for xb := bounds.Left to bounds.Right - 1 do
    begin
      c[0] := psrc^;
      if (xb = 0) then
      begin
        c[1] := c[0];
        c[2] := c[0];
        c[4] := c[0];
      end
      else
      begin
        if psrcUp <> nil then
          c[1] := (psrcUp - 1)^
        else
          c[1] := c[0];
        c[2] := (psrc - 1)^;
        if psrcDown <> nil then
          c[4] := (psrcDown - 1)^
        else
          c[4] := c[0];
      end;
      if psrcUp <> nil then
      begin
        c[3] := psrcUp^;
        Inc(psrcUp);
      end
      else
        c[3] := c[0];

      if (xb = bmpWidth - 1) then
      begin
        c[5] := c[0];
        c[6] := c[0];
        c[8] := c[0];
      end
      else
      begin
        if psrcDown <> nil then
          c[5] := (psrcDown + 1)^
        else
          c[5] := c[0];
        c[6] := (psrc + 1)^;
        if psrcUp <> nil then
          c[8] := psrcUp^
        else //+1 before
          c[8] := c[0];
      end;
      if psrcDown <> nil then
      begin
        c[7] := psrcDown^;
        Inc(psrcDown);
      end
      else
        c[7] := c[0];
      Inc(psrc);

      sum := 0;
      for i := 1 to 4 do
        sum += abs(c[i].red - c[i + 4].red) + abs(c[i].alpha - c[i + 4].alpha);

      if sum > 255 then
        slope := 255
      else
      if sum < 0 then
        slope := 0
      else
        slope := sum;

      tempPixel.red := 255 - slope;
      tempPixel.green := 255 - slope;
      tempPixel.blue := 255 - slope;
      tempPixel.alpha := 255;
      pdest^ := tempPixel;
      Inc(pdest);
    end;
  end;
  Result.InvalidateBitmap;
  gray.Free;
end;

function FilterSphere(bmp: TBGRADefaultBitmap): TBGRADefaultBitmap;
var
  cx, cy, x, y, len, fact: single;
  xb, yb: integer;
  mask:   TBGRADefaultBitmap;
begin
  Result := bmp.NewBitmap(bmp.Width, bmp.Height);
  cx     := bmp.Width / 2 - 0.5;
  cy     := bmp.Height / 2 - 0.5;
  for yb := 0 to Result.Height - 1 do
    for xb := 0 to Result.Width - 1 do
    begin
      x   := (xb - cx) / (cx + 0.5);
      y   := (yb - cy) / (cy + 0.5);
      len := sqrt(sqr(x) + sqr(y));
      if (len <= 1) then
      begin
        if (len > 0) then
        begin
          fact := 1 / len * arcsin(len) / (Pi / 2);
          x    *= fact;
          y    *= fact;
        end;
        Result.setpixel(xb, yb, bmp.Getpixel(x * cx + cx, y * cy + cy));
      end;
    end;
  mask := bmp.NewBitmap(bmp.Width, bmp.Height);
  Mask.Fill(BGRABlack);
  Mask.FillEllipseAntialias(cx, cy, cx, cy, BGRAWhite);
  Result.ApplyMask(mask);
  Mask.Free;
end;

function FilterCylinder(bmp: TBGRADefaultBitmap): TBGRADefaultBitmap;
var
  cx, cy, x, y, len, fact: single;
  xb, yb: integer;
begin
  Result := bmp.NewBitmap(bmp.Width, bmp.Height);
  cx     := bmp.Width / 2 - 0.5;
  cy     := bmp.Height / 2 - 0.5;
  for yb := 0 to Result.Height - 1 do
    for xb := 0 to Result.Width - 1 do
    begin
      x   := (xb - cx) / (cx + 0.5);
      y   := (yb - cy) / (cy + 0.5);
      len := abs(x);
      if (len <= 1) then
      begin
        if (len > 0) then
        begin
          fact := 1 / len * arcsin(len) / (Pi / 2);
          x    *= fact;
        end;
        Result.setpixel(xb, yb, bmp.Getpixel(x * cx + cx, y * cy + cy));
      end;
    end;
end;

function FilterPlane(bmp: TBGRADefaultBitmap): TBGRADefaultBitmap;
const resampleGap=0.6;
var
  cy, x1, x2, y1, y2, z1, z2, h: single;
  yb: integer;
  resampledBmp: TBGRADefaultBitmap;
  resampledBmpWidth: integer;
  resampledFactor,newResampleFactor: single;
  sub,resampledSub: TBGRADefaultBitmap;
  partRect: TRect;
  resampleSizeY : integer;
begin
  resampledBmp := bmp.Resample(bmp.Width*2,bmp.Height*2,rmSimpleStretch);
  resampledBmpWidth := resampledBmp.Width;
  resampledFactor := 2;
  Result := bmp.NewBitmap(bmp.Width, bmp.Height*2);
  cy     := result.Height / 2 - 0.5;
  h      := 1;
  for yb := 0 to ((Result.Height-1) div 2) do
  begin
    y1 := (cy - (yb-0.5)) / (cy+0.5);
    y2 := (cy - (yb+0.5)) / (cy+0.5);
    if y2 <= 0 then continue;
    z1 := h/y1;
    z2 := h/y2;
    newResampleFactor := 1/(z2-z1)*1.5;

    x1 := (z1+1)/2;
    x2 := (z2+1)/2;
    if newResampleFactor <= resampledFactor*resampleGap then
    begin
      resampledFactor := newResampleFactor;
      if resampledBmp <> bmp then resampledBmp.Free;
      if (x2-x1 >= 1) then resampleSizeY := 1 else
        resampleSizeY := round(1+((x2-x1)-1)/(1/bmp.Height-1)*(bmp.Height-1));
      resampledBmp := bmp.Resample(max(1,round(bmp.Width*resampledFactor)),resampleSizeY,rmSimpleStretch);
      resampledBmpWidth := resampledBmp.Width;
    end;

    partRect := Rect(round(-resampledBmpWidth/2*z1+resampledBmpWidth/2),floor(x1*resampledBmp.Height),
       round(resampledBmpWidth/2*z1+resampledBmpWidth/2),floor(x2*resampledBmp.Height)+1);
    if x2-x1 > 1 then
    begin
      partRect.Top := 0;
      partRect.Bottom := 1;
    end;
    sub := resampledBmp.GetPart(partRect);
    if sub <> nil then
    begin
      resampledSub := sub.Resample(bmp.Width,1,rmFineResample);
      result.PutImage(0,yb,resampledSub,dmSet);
      result.PutImage(0,Result.Height-1-yb,resampledSub,dmSet);
      resampledSub.free;
      sub.free;
    end;
  end;
  if resampledBmp <> bmp then resampledBmp.Free;

  if result.Height <> bmp.Height then
  begin
    resampledBmp := result.Resample(bmp.Width,bmp.Height,rmSimpleStretch);
    result.free;
    result := resampledBmp;
  end;
end;

function FilterMedian(bmp: TBGRADefaultBitmap;
  Option: TMedianOption): TBGRADefaultBitmap;

  function ComparePixLt(p1, p2: TBGRAPixel): boolean;
  begin
    if (p1.red + p1.green + p1.blue = p2.red + p2.green + p2.blue) then
      Result := (integer(p1.red) shl 8) + (integer(p1.green) shl 16) +
        integer(p1.blue) < (integer(p2.red) shl 8) + (integer(p2.green) shl 16) +
        integer(p2.blue)
    else
      Result := (p1.red + p1.green + p1.blue) < (p2.red + p2.green + p2.blue);
  end;

const
  nbpix = 9;
var
  yb, xb:    integer;
  dx, dy, n, i, j, k: integer;
  a_pixels:  array[0..nbpix - 1] of TBGRAPixel;
  tempPixel, refPixel: TBGRAPixel;
  tempValue: byte;
  sumR, sumG, sumB, sumA, BGRAdiv, nbA: cardinal;
  tempAlpha: word;
  bounds:    TRect;
  pdest:     PBGRAPixel;
begin
  Result := bmp.NewBitmap(bmp.Width, bmp.Height);

  bounds := bmp.GetImageBounds;
  if (bounds.Right <= bounds.Left) or (bounds.Bottom <= Bounds.Top) then
    exit;
  bounds.Left   := max(0, bounds.Left - 1);
  bounds.Top    := max(0, bounds.Top - 1);
  bounds.Right  := min(bmp.Width, bounds.Right + 1);
  bounds.Bottom := min(bmp.Height, bounds.Bottom + 1);

  for yb := bounds.Top to bounds.bottom - 1 do
  begin
    pdest := Result.scanline[yb] + bounds.left;
    for xb := bounds.left to bounds.right - 1 do
    begin
      n := 0;
      for dy := -1 to 1 do
        for dx := -1 to 1 do
        begin
          a_pixels[n] := bmp.GetPixel(xb + dx, yb + dy);
          if a_pixels[n].alpha = 0 then
            a_pixels[n] := BGRAPixelTransparent;
          Inc(n);
        end;
      for i := 1 to n - 1 do
      begin
        j := i;
        while (j > 1) and (a_pixels[j].alpha < a_pixels[j - 1].alpha) do
        begin
          tempValue := a_pixels[j].alpha;
          a_pixels[j].alpha := a_pixels[j - 1].alpha;
          a_pixels[j - 1].alpha := tempValue;
          Dec(j);
        end;
        j := i;
        while (j > 1) and (a_pixels[j].red < a_pixels[j - 1].red) do
        begin
          tempValue := a_pixels[j].red;
          a_pixels[j].red := a_pixels[j - 1].red;
          a_pixels[j - 1].red := tempValue;
          Dec(j);
        end;
        j := i;
        while (j > 1) and (a_pixels[j].green < a_pixels[j - 1].green) do
        begin
          tempValue := a_pixels[j].green;
          a_pixels[j].green := a_pixels[j - 1].green;
          a_pixels[j - 1].green := tempValue;
          Dec(j);
        end;
        j := i;
        while (j > 1) and (a_pixels[j].blue < a_pixels[j - 1].blue) do
        begin
          tempValue := a_pixels[j].blue;
          a_pixels[j].blue := a_pixels[j - 1].blue;
          a_pixels[j - 1].blue := tempValue;
          Dec(j);
        end;
      end;

      refPixel := a_pixels[n div 2];

      if option in [moLowSmooth, moMediumSmooth, moHighSmooth] then
      begin
        sumR    := 0;
        sumG    := 0;
        sumB    := 0;
        sumA    := 0;
        BGRAdiv := 0;
        nbA     := 0;

        case option of
          moHighSmooth, moMediumSmooth:
          begin
            j := 2;
            k := 2;
          end;
          else
          begin
            j := 1;
            k := 1;
          end;
        end;

         {$hints off}
        for i := -k to j do
        begin
          tempPixel := a_pixels[n div 2 + i];
          tempAlpha := tempPixel.alpha;
          if (option = moMediumSmooth) and ((i = -k) or (i = j)) then
            tempAlpha := tempAlpha div 2;

          sumR    += tempPixel.red * tempAlpha;
          sumG    += tempPixel.green * tempAlpha;
          sumB    += tempPixel.blue * tempAlpha;
          BGRAdiv += tempAlpha;

          sumA += tempAlpha;
          Inc(nbA);
        end;
         {$hints on}
        if option = moMediumSmooth then
          Dec(nbA);

        if (BGRAdiv = 0) then
          refPixel := BGRAPixelTransparent
        else
        begin
          refPixel.red   := round(sumR / BGRAdiv);
          refPixel.green := round(sumG / BGRAdiv);
          refPixel.blue  := round(sumB / BGRAdiv);
          refPixel.alpha := round(sumA / nbA);
        end;
      end;

      pdest^ := refPixel;
      Inc(pdest);
    end;
  end;
end;

end.

