procedure BGRAGradientFill(bmp: TBGRACustomBitmap; x, y, x2, y2: integer;
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