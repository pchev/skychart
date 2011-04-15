unit BGRAResample;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, BGRABitmapTypes;

function FineResample(bmp: TBGRACustomBitmap;
  NewWidth, NewHeight: integer): TBGRACustomBitmap;
function SimpleStretch(bmp: TBGRACustomBitmap;
  NewWidth, NewHeight: integer): TBGRACustomBitmap;

function FineInterpolation(t: single): single;

implementation

uses GraphType, Math;

function FineResampleLarger(bmp: TBGRACustomBitmap;
  newWidth, newHeight: integer): TBGRACustomBitmap;
var
  yb, xb: integer;
  pdest:  PBGRAPixel;
  xsrc, ysrc, xfactor, yfactor: double;
  ixsrc1, ixsrc2, iysrc1, iysrc2: integer;
  cUpLeft, cUpRight, cLowLeft, cLowRight: TBGRAPixel;
  factHoriz, factVert, factCorrX, factCorrY, Sum, fUpLeft, fUpRight,
  fLowLeft, fLowRight, faUpLeft, faUpRight, faLowLeft, faLowRight: single;
  rSum, gSum, bSum, aSum: single;
  temp:   TBGRACustomBitmap;
begin
  if (newWidth < bmp.Width) or (newHeight < bmp.Height) then
    raise ERangeError.Create('FineResampleLarger: New dimensions must be greater or equal ('+IntToStr(bmp.Width)+'x'+IntToStr(bmp.Height)+'->'+IntToStr(newWidth)+'x'+IntToStr(newHeight)+')');

  Result := bmp.NewBitmap(NewWidth, NewHeight);
  if (newWidth = 0) or (newHeight = 0) then
    exit;

  bmp.LoadFromBitmapIfNeeded;

  if (bmp.Width = 1) and (bmp.Height = 1) then
  begin
    Result.Fill(bmp.GetPixel(0, 0));
    exit;
  end
  else
  if bmp.Width = 1 then
  begin
    temp := bmp.NewBitmap(2, bmp.Height);
    temp.PutImage(0, 0, bmp, dmSet);
    temp.PutImage(1, 0, bmp, dmSet);
    Result := FineResampleLarger(temp, 2, newHeight);
    temp.Free;
    temp := Result;
    Result := SimpleStretch(temp, 1,temp.Height);
    temp.Free;
    exit;
  end
  else
  if bmp.Height = 1 then
  begin
    temp := bmp.NewBitmap(bmp.Width, 2);
    temp.PutImage(0, 0, bmp, dmSet);
    temp.PutImage(0, 1, bmp, dmSet);
    Result := FineResampleLarger(temp, newWidth, 2);
    temp.Free;
    temp := Result;
    Result := SimpleStretch(temp, temp.Width,1);
    temp.Free;
    exit;
  end;

  yfactor := (bmp.Height - 1) / (newHeight - 1);
  xfactor := (bmp.Width - 1) / (newWidth - 1);
  for yb := 0 to newHeight - 1 do
  begin
    pdest    := Result.Scanline[yb];
    ysrc     := yb * yfactor;
    iysrc1   := floor(ysrc);
    factVert := frac(ysrc);
    if (factVert = 0) then
      iysrc2 := iysrc1
    else
      iysrc2 := ceil(ysrc);
    factCorrY := FineInterpolation(factVert);
    for xb := 0 to newWidth - 1 do
    begin
      xsrc      := xb * xfactor;
      ixsrc1    := floor(xsrc);
      factHoriz := frac(xsrc);
      if (factHoriz = 0) then
        ixsrc2 := ixsrc1
      else
        ixsrc2 := ceil(xsrc);
      factCorrX := FineInterpolation(factHoriz);

      cUpLeft   := bmp.GetPixel(ixsrc1, iysrc1);
      cUpRight  := bmp.GetPixel(ixsrc2, iysrc1);
      cLowLeft  := bmp.GetPixel(ixsrc1, iysrc2);
      cLowRight := bmp.GetPixel(ixsrc2, iysrc2);

      fUpLeft   := (1 - factCorrX) * (1 - factCorrY);
      fUpRight  := factCorrX * (1 - factCorrY);
      fLowLeft  := (1 - factCorrX) * factCorrY;
      fLowRight := factCorrX * factCorrY;

      faUpLeft   := fUpLeft * cUpLeft.alpha;
      faUpRight  := fUpRight * cUpRight.alpha;
      faLowLeft  := fLowLeft * cLowLeft.alpha;
      faLowRight := fLowRight * cLowRight.alpha;

      Sum  := fUpLeft + fUpRight + fLowLeft + fLowRight;
      rSum := cUpLeft.red * faUpLeft + cUpRight.red * faUpRight +
        cLowLeft.red * faLowLeft + cLowRight.red * faLowRight;
      gSum := cUpLeft.green * faUpLeft + cUpRight.green * faUpRight +
        cLowLeft.green * faLowLeft + cLowRight.green * faLowRight;
      bSum := cUpLeft.blue * faUpLeft + cUpRight.blue * faUpRight +
        cLowLeft.blue * faLowLeft + cLowRight.blue * faLowRight;
      aSum := cUpLeft.alpha * fUpLeft + cUpRight.alpha * fUpRight +
        cLowLeft.alpha * fLowLeft + cLowRight.alpha * fLowRight;

      if aSum = 0 then
        pdest^ := BGRAPixelTransparent
      else
        pdest^ := BGRA(round(rSum / aSum), round(gSum / aSum),
          round(bSum / aSum), round(aSum / Sum));
      Inc(pdest);

    end;
  end;
end;

function FastSimpleStretchLarger(bmp: TBGRACustomBitmap;
  xFactor, yFactor: integer): TBGRACustomBitmap;
var
  y_src, yb, y_dest: integer;

  x_src, xb: integer;
  srcColor:  TBGRAPixel;

  PSrc:  PBGRAPixel;
  PDest: array of PBGRAPixel;
  temp:  PBGRAPixel;

begin
  if (xFactor < 1) or (yFactor < 1) then
    raise ERangeError.Create('FastSimpleStretchLarger: New dimensions must be greater or equal (*'+IntToStr(xFactor)+'x*'+IntToStr(yFactor)+')');

  Result := bmp.NewBitmap(bmp.Width * xFactor, bmp.Height * yFactor);
  if (Result.Width = 0) or (Result.Height = 0) then
    exit;

  bmp.LoadFromBitmapIfNeeded;

  SetLength(PDest, yFactor);
  y_dest := 0;
  for y_src := 0 to bmp.Height - 1 do
  begin
    PSrc := bmp.Scanline[y_src];
    for yb := 0 to yFactor - 1 do
      PDest[yb] := Result.scanLine[y_dest + yb];

    for x_src := 0 to bmp.Width - 1 do
    begin
      srcColor := PSrc^;
      Inc(PSrc);

      for yb := 0 to yFactor - 1 do
      begin
        temp := PDest[yb];
        for xb := 0 to xFactor - 1 do
        begin
          temp^ := srcColor;
          Inc(temp);
        end;
        PDest[yb] := temp;
      end;
    end;
    Inc(y_dest, yFactor);
  end;

  Result.InvalidateBitmap;
end;

function SimpleStretchLarger(bmp: TBGRACustomBitmap;
  newWidth, newHeight: integer): TBGRACustomBitmap;
var
  x_src, y_src: integer;
  inc_x_dest, mod_x_dest, acc_x_dest, inc_y_dest, mod_y_dest, acc_y_dest: integer;
  x_dest, y_dest, prev_x_dest, prev_y_dest: integer;

  xb, yb:      integer;
  srcColor:    TBGRAPixel;
  PDest, PSrc: PBGRAPixel;
  delta, lineDelta: integer;

begin
  if (newWidth < bmp.Width) or (newHeight < bmp.Height) then
    raise ERangeError.Create('SimpleStretchLarger: New dimensions must be greater or equal ('+IntToStr(bmp.Width)+'x'+IntToStr(bmp.Height)+'->'+IntToStr(newWidth)+'x'+IntToStr(newHeight)+')');

  if ((newWidth div bmp.Width) * bmp.Width = newWidth) and
    ((newHeight div bmp.Height) * bmp.Height = newHeight) then
  begin
    Result := FastSimpleStretchLarger(bmp, newWidth div bmp.Width,
      newHeight div bmp.Height);
    exit;
  end;

  Result := bmp.NewBitmap(NewWidth, NewHeight);
  if (newWidth = 0) or (newHeight = 0) then
    exit;

  bmp.LoadFromBitmapIfNeeded;

  inc_x_dest := newwidth div bmp.Width;
  mod_x_dest := newwidth mod bmp.Width;
  inc_y_dest := newheight div bmp.Height;
  mod_y_dest := newheight mod bmp.Height;

  y_dest     := 0;
  acc_y_dest := bmp.Height div 2;
  if Result.LineOrder = riloTopToBottom then
    lineDelta := newWidth
  else
    lineDelta := -newWidth;
  for y_src := 0 to bmp.Height - 1 do
  begin
    prev_y_dest := y_dest;
    Inc(y_dest, inc_y_dest);
    Inc(acc_y_dest, mod_y_dest);
    if acc_y_dest >= bmp.Height then
    begin
      Dec(acc_y_dest, bmp.Height);
      Inc(y_dest);
    end;

    PSrc := bmp.Scanline[y_src];

    x_dest     := 0;
    acc_x_dest := bmp.Width div 2;
    for x_src := 0 to bmp.Width - 1 do
    begin
      prev_x_dest := x_dest;
      Inc(x_dest, inc_x_dest);
      Inc(acc_x_dest, mod_x_dest);
      if acc_x_dest >= bmp.Width then
      begin
        Dec(acc_x_dest, bmp.Width);
        Inc(x_dest);
      end;

      srcColor := PSrc^;
      Inc(PSrc);

      PDest := Result.scanline[prev_y_dest] + prev_x_dest;
      delta := lineDelta - (x_dest - prev_x_dest);
      for yb := prev_y_dest to y_dest - 1 do
      begin
        for xb := prev_x_dest to x_dest - 1 do
        begin
          PDest^ := srcColor;
          Inc(PDest);
        end;
        Inc(PDest, delta);
      end;
    end;
  end;
  Result.InvalidateBitmap;
end;

function SimpleStretchSmaller(bmp: TBGRACustomBitmap;
  newWidth, newHeight: integer): TBGRACustomBitmap;
var
  x_dest, y_dest: integer;
  inc_x_src, mod_x_src, acc_x_src, inc_y_src, mod_y_src, acc_y_src: integer;
  x_src, y_src, prev_x_src, prev_y_src: integer;
  x_src2, y_src2: integer;

  xb, yb: integer;
  v1, v2, v3, v4, v4shr1: int64;
  nb:     integer;
  c:      TBGRAPixel;
  pdest, psrc: PBGRAPixel;
  lineDelta, delta: integer;
begin
  if (newWidth > bmp.Width) or (newHeight > bmp.Height) then
    raise ERangeError.Create('SimpleStretchSmaller: New dimensions must be smaller or equal ('+IntToStr(bmp.Width)+'x'+IntToStr(bmp.Height)+'->'+IntToStr(newWidth)+'x'+IntToStr(newHeight)+')');
  Result := bmp.NewBitmap(NewWidth, NewHeight);
  if (newWidth = 0) or (newHeight = 0) or (bmp.Width = 0) or (bmp.Height = 0) then
    exit;

  bmp.LoadFromBitmapIfNeeded;

  inc_x_src := bmp.Width div newWidth;
  mod_x_src := bmp.Width mod newWidth;
  inc_y_src := bmp.Height div newHeight;
  mod_y_src := bmp.Height mod newHeight;

  if bmp.lineOrder = riloTopToBottom then
    lineDelta := bmp.Width
  else
    lineDelta := -bmp.Width;

  y_src     := 0;
  acc_y_src := 0;
  for y_dest := 0 to newHeight - 1 do
  begin
    PDest := Result.ScanLine[y_dest];

    prev_y_src := y_src;
    Inc(y_src, inc_y_src);
    Inc(acc_y_src, mod_y_src);
    if acc_y_src >= newHeight then
    begin
      Dec(acc_y_src, newHeight);
      Inc(y_src);
    end;
    if y_src > prev_y_src then
      y_src2 := y_src - 1
    else
      y_src2 := y_src;

    x_src     := 0;
    acc_x_src := 0;
    for x_dest := 0 to newWidth - 1 do
    begin
      prev_x_src := x_src;
      Inc(x_src, inc_x_src);
      Inc(acc_x_src, mod_x_src);
      if acc_x_src >= newWidth then
      begin
        Dec(acc_x_src, newWidth);
        Inc(x_src);
      end;
      if x_src > prev_x_src then
        x_src2 := x_src - 1
      else
        x_src2 := x_src;

      v1    := 0;
      v2    := 0;
      v3    := 0;
      v4    := 0;
      nb    := 0;
      delta := lineDelta - (x_src2 - prev_x_src + 1);
      PSrc  := bmp.Scanline[prev_y_src] + prev_x_src;
      for yb := prev_y_src to y_src2 do
      begin
        for xb := prev_x_src to x_src2 do
        begin
          c := PSrc^;
          Inc(PSrc);
                  {$HINTS OFF}
          v1 += integer(c.red) * integer(c.alpha);
          v2 += integer(c.green) * integer(c.alpha);
          v3 += integer(c.blue) * integer(c.alpha);
                  {$HINTS ON}
          v4 += c.alpha;
          Inc(nb);
        end;
        Inc(PSrc, delta);
      end;

      if (v4 <> 0) and (nb <> 0) then
      begin
        v4shr1  := v4 shr 1;
        c.red   := (v1 + v4shr1) div v4;
        c.green := (v2 + v4shr1) div v4;
        c.blue  := (v3 + v4shr1) div v4;
        c.alpha := (v4 + (nb shr 1)) div nb;
      end
      else
      begin
        c.alpha := 0;
        c.red   := 0;
        c.green := 0;
        c.blue  := 0;
      end;
      PDest^ := c;
      Inc(PDest);
    end;
  end;
  Result.InvalidateBitmap;
end;

function FineResampleSmaller(bmp: TBGRACustomBitmap;
  newWidth, newHeight: integer): TBGRACustomBitmap;
var
  yb, xb, yb2, xb2: integer;
  pdest, psrc:      PBGRAPixel;
  lineDelta, delta: integer;
  xsrc1, ysrc1, xsrc2, ysrc2, xfactor, yfactor: double;
  ixsrc1, ixsrc2, iysrc1, iysrc2, ixsrc1p1, ixsrc2m1, iysrc1p1, iysrc2m1: integer;
  cBorder, cFull, cUpLeft, cUpRight, cLowLeft, cLowRight: TBGRAPixel;
  factHoriz1, factHoriz2, factVert1, factVert2, Sum, fUpLeft, fUpRight,
  fLowLeft, fLowRight, faUpLeft, faUpRight, faLowLeft, faLowRight: single;
  rSum, gSum, bSum, aSum: double;
begin
  if (newWidth > bmp.Width) or (newHeight > bmp.Height) then
    raise ERangeError.Create('FineResampleSmaller: New dimensions must be smaller or equal ('+IntToStr(bmp.Width)+'x'+IntToStr(bmp.Height)+'->'+IntToStr(newWidth)+'x'+IntToStr(newHeight)+')');
  Result := bmp.NewBitmap(NewWidth, NewHeight);
  if (newWidth = 0) or (newHeight = 0) or (bmp.Width = 0) or (bmp.Height = 0) then
    exit;

  bmp.LoadFromBitmapIfNeeded;

  if bmp.lineOrder = riloTopToBottom then
    lineDelta := bmp.Width
  else
    lineDelta := -bmp.Width;

  yfactor := bmp.Height / newHeight;
  xfactor := bmp.Width / newWidth;
  for yb := 0 to newHeight - 1 do
  begin
    pdest  := Result.Scanline[yb];
    ysrc1  := yb * yfactor;
    ysrc2  := (yb + 1) * yfactor;
    iysrc1 := trunc(ysrc1);
    if (int(ysrc2) = int(ysrc1)) or (ysrc2 = iysrc1 + 1) then
    begin
      iysrc2    := iysrc1;
      factVert1 := 1;
      factVert2 := 0;
    end
    else
    begin
      iysrc2    := trunc(ysrc2);
      factVert1 := 1 - frac(ysrc1);
      factVert2 := frac(ysrc2);
    end;
    for xb := 0 to newWidth - 1 do
    begin
      xsrc1  := xb * xfactor;
      xsrc2  := (xb + 1) * xfactor;
      ixsrc1 := trunc(xsrc1);
      if (int(xsrc2) = int(xsrc1)) or (xsrc2 = ixsrc1 + 1) then
      begin
        ixsrc2     := ixsrc1;
        factHoriz1 := 1;
        factHoriz2 := 0;
      end
      else
      begin
        ixsrc2     := trunc(xsrc2);
        factHoriz1 := 1 - frac(xsrc1);
        factHoriz2 := frac(xsrc2);
      end;

      cUpLeft   := bmp.GetPixel(ixsrc1, iysrc1);
      cUpRight  := bmp.GetPixel(ixsrc2, iysrc1);
      cLowLeft  := bmp.GetPixel(ixsrc1, iysrc2);
      cLowRight := bmp.GetPixel(ixsrc2, iysrc2);

      fUpLeft   := factHoriz1 * factVert1;
      fUpRight  := factHoriz2 * factVert1;
      fLowLeft  := factHoriz1 * factVert2;
      fLowRight := factHoriz2 * factVert2;

      faUpLeft   := fUpLeft * cUpLeft.alpha;
      faUpRight  := fUpRight * cUpRight.alpha;
      faLowLeft  := fLowLeft * cLowLeft.alpha;
      faLowRight := fLowRight * cLowRight.alpha;

      Sum  := fUpLeft + fUpRight + fLowLeft + fLowRight;
      rSum := cUpLeft.red * faUpLeft + cUpRight.red * faUpRight +
        cLowLeft.red * faLowLeft + cLowRight.red * faLowRight;
      gSum := cUpLeft.green * faUpLeft + cUpRight.green * faUpRight +
        cLowLeft.green * faLowLeft + cLowRight.green * faLowRight;
      bSum := cUpLeft.blue * faUpLeft + cUpRight.blue * faUpRight +
        cLowLeft.blue * faLowLeft + cLowRight.blue * faLowRight;
      aSum := cUpLeft.alpha * fUpLeft + cUpRight.alpha * fUpRight +
        cLowLeft.alpha * fLowLeft + cLowRight.alpha * fLowRight;

      ixsrc1p1 := ixsrc1 + 1;
      ixsrc2m1 := ixsrc2 - 1;
      iysrc1p1 := iysrc1 + 1;
      iysrc2m1 := iysrc2 - 1;

      if ixsrc2m1 >= ixsrc1p1 then
      begin
        psrc := bmp.scanline[iysrc1] + ixsrc1p1;
        for xb2 := ixsrc1p1 to ixsrc2m1 do
        begin
          cBorder := psrc^;
          Inc(psrc);
          rSum += cBorder.red * cBorder.alpha * factVert1;
          gSum += cBorder.green * cBorder.alpha * factVert1;
          bSum += cBorder.blue * cBorder.alpha * factVert1;
          aSum += cBorder.alpha * factVert1;
          Sum  += factVert1;
        end;

        if (factVert2 <> 0) and (iysrc2 < bmp.Height) then
        begin
          psrc := bmp.scanline[iysrc2] + ixsrc1p1;
          for xb2 := ixsrc1p1 to ixsrc2m1 do
          begin
            cBorder := psrc^;
            Inc(psrc);
            rSum += cBorder.red * cBorder.alpha * factVert2;
            gSum += cBorder.green * cBorder.alpha * factVert2;
            bSum += cBorder.blue * cBorder.alpha * factVert2;
            aSum += cBorder.alpha * factVert2;
            Sum  += factVert2;
          end;
        end;
      end;

      if iysrc2m1 >= iysrc1p1 then
      begin
        psrc := bmp.scanline[iysrc1p1] + ixsrc1;
        for yb2 := iysrc1p1 to iysrc2m1 do
        begin
          cBorder := psrc^;
          Inc(psrc, lineDelta);
          rSum += cBorder.red * cBorder.alpha * factHoriz1;
          gSum += cBorder.green * cBorder.alpha * factHoriz1;
          bSum += cBorder.blue * cBorder.alpha * factHoriz1;
          aSum += cBorder.alpha * factHoriz1;
          Sum  += factHoriz1;
        end;

        if (factHoriz2 <> 0) and (ixsrc2 < bmp.Width) then
        begin
          psrc := bmp.scanline[iysrc1p1] + ixsrc2;
          for yb2 := iysrc1p1 to iysrc2m1 do
          begin
            cBorder := psrc^;
            Inc(psrc, lineDelta);
            rSum += cBorder.red * cBorder.alpha * factHoriz2;
            gSum += cBorder.green * cBorder.alpha * factHoriz2;
            bSum += cBorder.blue * cBorder.alpha * factHoriz2;
            aSum += cBorder.alpha * factHoriz2;
            Sum  += factHoriz2;
          end;
        end;
      end;

      if (ixsrc2m1 >= ixsrc1p1) and (iysrc2m1 >= iysrc1p1) then
      begin
        delta := lineDelta - (ixsrc2m1 - ixsrc1p1 + 1);
        psrc  := bmp.scanline[iysrc1p1] + ixsrc1p1;
        for yb2 := iysrc1p1 to iysrc2m1 do
        begin
          for xb2 := ixsrc1p1 to ixsrc2m1 do
          begin
            cFull := psrc^;
            rSum  += cFull.red * cFull.alpha;
            gSum  += cFull.green * cFull.alpha;
            bSum  += cFull.blue * cFull.alpha;
            aSum  += cFull.alpha;
            Sum   += 1;
            Inc(psrc);
          end;
          Inc(psrc, delta);
        end;
      end;

      if aSum = 0 then
        pdest^ := BGRAPixelTransparent
      else
        pdest^ := BGRA(round(rSum / aSum), round(gSum / aSum),
          round(bSum / aSum), round(aSum / Sum));
      Inc(pdest);

    end;
  end;
end;

function FineResample(bmp: TBGRACustomBitmap;
  NewWidth, NewHeight: integer): TBGRACustomBitmap;
var
  temp, newtemp: TBGRACustomBitmap;
begin
  if (NewWidth = bmp.Width) and (NewHeight = bmp.Height) then
    Result := bmp.Duplicate
  else
  if (NewWidth >= bmp.Width) and (NewHeight >= bmp.Height) then
    Result := FineResampleLarger(bmp, NewWidth, NewHeight)
  else
  if (NewWidth <= bmp.Width) and (NewHeight <= bmp.Height) then
    Result := FineResampleSmaller(bmp, NewWidth, NewHeight)
  else
  begin
    temp := bmp;

    if NewWidth < bmp.Width then
    begin
      newtemp := FineResampleSmaller(temp, NewWidth, temp.Height);
      if (temp <> bmp) then
        temp.Free;
      temp := newtemp;
    end;

    if NewHeight < bmp.Height then
    begin
      newtemp := FineResampleSmaller(temp, temp.Width, NewHeight);
      if (temp <> bmp) then
        temp.Free;
      temp := newtemp;
    end;

    if NewWidth > bmp.Width then
    begin
      newtemp := FineResampleLarger(temp, NewWidth, temp.Height);
      if (temp <> bmp) then
        temp.Free;
      temp := newtemp;
    end;

    if NewHeight > bmp.Height then
    begin
      newtemp := FineResampleLarger(temp, temp.Width, NewHeight);
      if (temp <> bmp) then
        temp.Free;
      temp := newtemp;
    end;

    if temp <> bmp then
      Result := temp
    else
      Result := bmp.Duplicate;
  end;
end;

function SimpleStretch(bmp: TBGRACustomBitmap;
  NewWidth, NewHeight: integer): TBGRACustomBitmap;
var
  temp, newtemp: TBGRACustomBitmap;
begin
  if (NewWidth = bmp.Width) and (NewHeight = bmp.Height) then
    Result := bmp.Duplicate
  else
  if (NewWidth >= bmp.Width) and (NewHeight >= bmp.Height) then
    Result := SimpleStretchLarger(bmp, NewWidth, NewHeight)
  else
  if (NewWidth <= bmp.Width) and (NewHeight <= bmp.Height) then
    Result := SimpleStretchSmaller(bmp, NewWidth, NewHeight)
  else
  begin
    temp := bmp;

    if NewWidth < bmp.Width then
    begin
      newtemp := SimpleStretchSmaller(temp, NewWidth, temp.Height);
      if (temp <> bmp) then
        temp.Free;
      temp := newtemp;
    end;

    if NewHeight < bmp.Height then
    begin
      newtemp := SimpleStretchSmaller(temp, temp.Width, NewHeight);
      if (temp <> bmp) then
        temp.Free;
      temp := newtemp;
    end;

    if NewWidth > bmp.Width then
    begin
      newtemp := SimpleStretchLarger(temp, NewWidth, temp.Height);
      if (temp <> bmp) then
        temp.Free;
      temp := newtemp;
    end;

    if NewHeight > bmp.Height then
    begin
      newtemp := SimpleStretchLarger(temp, temp.Width, NewHeight);
      if (temp <> bmp) then
        temp.Free;
      temp := newtemp;
    end;

    if temp <> bmp then
      Result := temp
    else
      Result := bmp.Duplicate;
  end;
end;

function FineInterpolation(t: single): single;
begin
  if t <= 0.5 then
    result := t*t*2 else
    result := 1-(1-t)*(1-t)*2;
  result := (result+t)*0.5;
end;

end.

