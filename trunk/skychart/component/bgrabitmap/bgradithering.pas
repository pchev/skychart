unit BGRADithering;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, BGRAFilters, BGRAPalette, BGRABitmapTypes;

type
  TOutputPixelProc = procedure(X,Y: NativeInt; AColorIndex: NativeInt; AColor: TBGRAPixel) of object;

  { TDitheringTask }

  TDitheringTask = class(TFilterTask)
  private
    function GetInplace: boolean;
    procedure SetInplace(AValue: boolean);
  protected
    FBounds: TRect;
    FIgnoreAlpha: boolean;
    FPalette: TBGRACustomApproxPalette;
    FCurrentOutputScanline: PBGRAPixel;
    FCurrentOutputY: NativeInt;
    FOutputPixel : TOutputPixelProc;
    procedure OutputPixel(X,Y: NativeInt; {%H-}AColorIndex: NativeInt; AColor: TBGRAPixel); virtual;
  public
    constructor Create(bmp: TBGRACustomBitmap; APalette: TBGRACustomApproxPalette; AInPlace: boolean; AIgnoreAlpha: boolean; ABounds: TRect); overload;
    constructor Create(bmp: TBGRACustomBitmap; APalette: TBGRACustomApproxPalette; AInPlace: boolean; AIgnoreAlpha: boolean); overload;
    property OnOutputPixel: TOutputPixelProc read FOutputPixel write FOutputPixel;
    property Inplace: boolean read GetInplace write SetInplace;
  end;

  { TNearestColorTask }

  TNearestColorTask = class(TDitheringTask)
  protected
    procedure DoExecute; override;
  end;

  { TFloydSteinbergDitheringTask }

  TFloydSteinbergDitheringTask = class(TDitheringTask)
  protected
    procedure DoExecute; override;
  end;

  { TDitheringToIndexedImage }

  TDitheringToIndexedImage = class
  protected
    FBitOrder: TRawImageBitOrder;
    FByteOrder: TRawImageByteOrder;
    FBitsPerPixel: integer;
    FLineOrder: TRawImageLineOrder;
    FPalette: TBGRACustomApproxPalette;
    FIgnoreAlpha: boolean;
    FTransparentColorIndex: NativeInt;

    //following variables are used during dithering
    FCurrentScanlineSize: PtrInt;
    FCurrentData: PByte;
    FCurrentOutputY: NativeInt;
    FCurrentOutputScanline: PByte;
    FCurrentBitOrderMask: NativeInt;
    FCurrentMaxY: NativeInt;

    procedure SetPalette(AValue: TBGRACustomApproxPalette);
    procedure SetIgnoreAlpha(AValue: boolean);
    procedure SetLineOrder(AValue: TRawImageLineOrder);
    procedure SetBitOrder(AValue: TRawImageBitOrder); virtual;
    procedure SetBitsPerPixel(AValue: integer); virtual;
    procedure SetByteOrder(AValue: TRawImageByteOrder); virtual;
    procedure OutputPixelSubByte(X,Y: NativeInt; AColorIndex: NativeInt; {%H-}AColor: TBGRAPixel); virtual;
    procedure OutputPixelFullByte(X,Y: NativeInt; AColorIndex: NativeInt; {%H-}AColor: TBGRAPixel); virtual;
    function GetScanline(Y: NativeInt): Pointer; virtual;
    function GetTransparentColorIndex: integer;
    procedure SetTransparentColorIndex(AValue: integer);
  public
    constructor Create(APalette: TBGRACustomApproxPalette; AIgnoreAlpha: boolean; ABitsPerPixelForIndices: integer); //use platform byte order
    constructor Create(APalette: TBGRACustomApproxPalette; AIgnoreAlpha: boolean; ABitsPerPixelForIndices: integer; AByteOrder: TRawImageByteOrder); //maybe necessary if larger than 8 bits per pixel

    function DitherImage(AAlgorithm: TDitheringAlgorithm; AImage: TBGRACustomBitmap): Pointer; overload; //use minimum scanline size
    function DitherImage(AAlgorithm: TDitheringAlgorithm; AImage: TBGRACustomBitmap; AScanlineSize: PtrInt): Pointer; overload;
    procedure DitherImageTo(AAlgorithm: TDitheringAlgorithm; AImage: TBGRACustomBitmap; AData: Pointer); overload; //use minimum scanline size
    procedure DitherImageTo(AAlgorithm: TDitheringAlgorithm; AImage: TBGRACustomBitmap; AData: Pointer; AScanlineSize: PtrInt); overload;
    function ComputeMinimumScanlineSize(AWidthInPixels: integer): PtrInt;
    function AllocateSpaceForIndexedData(AImage: TBGRACustomBitmap; AScanlineSize: PtrInt): pointer;

    //optional customization of format
    property BitsPerPixel: integer read FBitsPerPixel write SetBitsPerPixel;
    property BitOrder: TRawImageBitOrder read FBitOrder write SetBitOrder;
    property ByteOrder: TRawImageByteOrder read FByteOrder write SetByteOrder;
    property LineOrder: TRawImageLineOrder read FLineOrder write SetLineOrder;

    property Palette: TBGRACustomApproxPalette read FPalette write SetPalette;
    property IgnoreAlpha: boolean read FIgnoreAlpha write SetIgnoreAlpha;

    //when there is no transparent color in the palette, or that IgnoreAlpha is set to True,
    //this allows to define the index for the fully transparent color
    property DefaultTransparentColorIndex: integer read GetTransparentColorIndex write SetTransparentColorIndex;
  end;

function CreateDitheringTask(AAlgorithm: TDitheringAlgorithm; ABitmap: TBGRACustomBitmap; APalette: TBGRACustomApproxPalette;
  AIgnoreAlpha: boolean): TDitheringTask; overload;
function CreateDitheringTask(AAlgorithm: TDitheringAlgorithm; ABitmap: TBGRACustomBitmap; APalette: TBGRACustomApproxPalette;
  AIgnoreAlpha: boolean; ABounds: TRect): TDitheringTask; overload;

implementation

function AbsRGBADiff(const c1, c2: TExpandedPixel): NativeInt;
begin
  result := abs(c1.alpha-c2.alpha);
  result += abs(c1.red-c2.red);
  result += abs(c1.green-c2.green);
  result += abs(c1.blue-c2.blue);
end;

function CreateDitheringTask(AAlgorithm: TDitheringAlgorithm; ABitmap: TBGRACustomBitmap; APalette: TBGRACustomApproxPalette;
  AIgnoreAlpha: boolean): TDitheringTask;
begin
  result := CreateDitheringTask(AAlgorithm, ABitmap, APalette, AIgnoreAlpha, rect(0,0,ABitmap.width, ABitmap.Height));
end;

function CreateDitheringTask(AAlgorithm: TDitheringAlgorithm; ABitmap: TBGRACustomBitmap; APalette: TBGRACustomApproxPalette;
  AIgnoreAlpha: boolean; ABounds: TRect): TDitheringTask;
begin
  result := nil;
  case AAlgorithm of
    daNearestNeighbor: result := TNearestColorTask.Create(ABitmap, APalette, False, AIgnoreAlpha, ABounds);
    daFloydSteinberg: result := TFloydSteinbergDitheringTask.Create(ABitmap, APalette, False, AIgnoreAlpha, ABounds);
    else raise exception.Create('Unknown algorithm');
  end;
end;

{ TDitheringToIndexedImage }

procedure TDitheringToIndexedImage.SetBitsPerPixel(AValue: integer);
begin
  if not (AValue in [1,2,4,8,16,32]) then
    raise exception.Create('Invalid value for bits per pixel. Allowed values: 1,2,4,8,16,32.');
  if FBitsPerPixel=AValue then Exit;
  FBitsPerPixel:=AValue;
end;

procedure TDitheringToIndexedImage.SetByteOrder(AValue: TRawImageByteOrder);
begin
  if FByteOrder=AValue then Exit;
  FByteOrder:=AValue;
end;

procedure TDitheringToIndexedImage.OutputPixelSubByte(X, Y: NativeInt;
  AColorIndex: NativeInt; AColor: TBGRAPixel);
var p: PByte;
begin
  if y <> FCurrentOutputY then
  begin
    FCurrentOutputY := y;
    FCurrentOutputScanline := GetScanline(Y);
  end;
  if AColorIndex = -1 then AColorIndex := FTransparentColorIndex;
  case FBitsPerPixel of
    1: begin
         p := FCurrentOutputScanline+(x shr 3);
         p^ := p^ or ((AColorIndex and 1) shl ((x xor FCurrentBitOrderMask) and 7));
       end;
    2: begin
         p := FCurrentOutputScanline+(x shr 2);
         p^ := p^ or ((AColorIndex and 1) shl (((x xor FCurrentBitOrderMask) and 3) shl 1));
       end;
    4: begin
         p := FCurrentOutputScanline+(x shr 1);
         p^ := p^ or ((AColorIndex and 1) shl (((x xor FCurrentBitOrderMask) and 1) shl 2));
       end;
  end;
end;

procedure TDitheringToIndexedImage.OutputPixelFullByte(X, Y: NativeInt;
  AColorIndex: NativeInt; AColor: TBGRAPixel);
begin
  if y <> FCurrentOutputY then
  begin
    FCurrentOutputY := y;
    FCurrentOutputScanline := GetScanline(Y);
  end;
  if AColorIndex = -1 then AColorIndex := FTransparentColorIndex;
  case FBitsPerPixel of
    8: (FCurrentOutputScanline+x)^ := AColorIndex;
    16: (PWord(FCurrentOutputScanline)+x)^ := AColorIndex;
    32: (PDWord(FCurrentOutputScanline)+x)^ := AColorIndex;
  end;
end;

function TDitheringToIndexedImage.GetScanline(Y: NativeInt): Pointer;
begin
  if FLineOrder = riloTopToBottom then
    result := FCurrentData + Y*FCurrentScanlineSize
  else
    result := FCurrentData + (FCurrentMaxY-Y)*FCurrentScanlineSize
end;

procedure TDitheringToIndexedImage.SetIgnoreAlpha(AValue: boolean);
begin
  if FIgnoreAlpha=AValue then Exit;
  FIgnoreAlpha:=AValue;
end;

procedure TDitheringToIndexedImage.SetTransparentColorIndex(AValue: integer);
begin
  if FTransparentColorIndex=AValue then Exit;
  FTransparentColorIndex:=AValue;
end;

function TDitheringToIndexedImage.GetTransparentColorIndex: integer;
begin
  result := FTransparentColorIndex;
end;

procedure TDitheringToIndexedImage.SetPalette(AValue: TBGRACustomApproxPalette);
begin
  if FPalette=AValue then Exit;
  FPalette:=AValue;
end;

procedure TDitheringToIndexedImage.SetLineOrder(AValue: TRawImageLineOrder);
begin
  if FLineOrder=AValue then Exit;
  FLineOrder:=AValue;
end;

procedure TDitheringToIndexedImage.SetBitOrder(AValue: TRawImageBitOrder);
begin
  if FBitOrder=AValue then Exit;
  FBitOrder:=AValue;
end;

constructor TDitheringToIndexedImage.Create(APalette: TBGRACustomApproxPalette; AIgnoreAlpha: boolean; ABitsPerPixelForIndices: integer);
begin
  BitsPerPixel:= ABitsPerPixelForIndices;
  BitOrder := riboReversedBits; //convention in BMP format
  {$IFDEF ENDIAN_LITTLE}
  ByteOrder:= riboLSBFirst;
  {$ELSE}
  ByteOrder:= riboMSBFirst;
  {$ENDIF}
  Palette := APalette;
  IgnoreAlpha:= AIgnoreAlpha;
end;

constructor TDitheringToIndexedImage.Create(APalette: TBGRACustomApproxPalette; AIgnoreAlpha: boolean; ABitsPerPixelForIndices: integer;
  AByteOrder: TRawImageByteOrder);
begin
  BitsPerPixel:= ABitsPerPixelForIndices;
  BitOrder := riboReversedBits; //convention in BMP format
  ByteOrder:= AByteOrder;
  Palette := APalette;
  IgnoreAlpha:= AIgnoreAlpha;
end;

function TDitheringToIndexedImage.ComputeMinimumScanlineSize(
  AWidthInPixels: integer): PtrInt;
begin
  result := (AWidthInPixels*FBitsPerPixel+7) shr 3;
end;

function TDitheringToIndexedImage.AllocateSpaceForIndexedData(AImage: TBGRACustomBitmap;
  AScanlineSize: PtrInt): pointer;
var size: integer;
begin
  size := AScanlineSize * AImage.Height;
  GetMem(result, size);
  Fillchar(result^, size, 0);
end;

function TDitheringToIndexedImage.DitherImage(AAlgorithm: TDitheringAlgorithm;
  AImage: TBGRACustomBitmap): Pointer;
begin
  result := DitherImage(AAlgorithm, AImage, ComputeMinimumScanlineSize(AImage.Width));
end;

procedure TDitheringToIndexedImage.DitherImageTo(AAlgorithm: TDitheringAlgorithm;
  AImage: TBGRACustomBitmap; AData: Pointer);
begin
  DitherImageTo(AAlgorithm, AImage, AData, ComputeMinimumScanlineSize(AImage.Width));
end;

function TDitheringToIndexedImage.DitherImage(AAlgorithm: TDitheringAlgorithm;
  AImage: TBGRACustomBitmap; AScanlineSize: PtrInt): Pointer;
begin
  result := AllocateSpaceForIndexedData(AImage, AScanlineSize);
  DitherImageTo(AAlgorithm, AImage, result, AScanlineSize);
end;

procedure TDitheringToIndexedImage.DitherImageTo(AAlgorithm: TDitheringAlgorithm;
  AImage: TBGRACustomBitmap; AData: Pointer; AScanlineSize: PtrInt);
var ditherTask: TDitheringTask;
begin
  FCurrentOutputY := -1;
  FCurrentOutputScanline := nil;
  FCurrentData := AData;
  FCurrentMaxY:= AImage.Height-1;
  FCurrentScanlineSize:= AScanlineSize;

  ditherTask := CreateDitheringTask(AAlgorithm, AImage, FPalette, FIgnoreAlpha);
  try
    ditherTask.Inplace := True; //do not allocate destination
    if BitsPerPixel >= 8 then
      ditherTask.OnOutputPixel := @OutputPixelFullByte
    else
    begin
      ditherTask.OnOutputPixel:= @OutputPixelSubByte;
      if BitOrder = riboBitsInOrder then
        FCurrentBitOrderMask := 0
      else
        FCurrentBitOrderMask := $ff;
    end;
    ditherTask.Execute;
  finally
    ditherTask.Free;
  end;
end;

{ TDitheringTask }

function TDitheringTask.GetInplace: boolean;
begin
  result := Destination = FSource;
end;

procedure TDitheringTask.SetInplace(AValue: boolean);
begin
  if AValue = InPlace then exit;
  Destination := FSource;
end;

procedure TDitheringTask.OutputPixel(X, Y: NativeInt; AColorIndex: NativeInt;
  AColor: TBGRAPixel);
begin
  if Y <> FCurrentOutputY then
  begin
    FCurrentOutputY := Y;
    FCurrentOutputScanline := FDestination.ScanLine[y];
  end;
  (FCurrentOutputScanline+x)^ := AColor;
end;

constructor TDitheringTask.Create(bmp: TBGRACustomBitmap;
  APalette: TBGRACustomApproxPalette; AInPlace: boolean; AIgnoreAlpha: boolean;
  ABounds: TRect);
begin
  FPalette := APalette;
  FSource := bmp;
  FBounds := ABounds;
  FIgnoreAlpha:= AIgnoreAlpha;
  FCurrentOutputY := -1;
  FCurrentOutputScanline:= nil;
  FOutputPixel:= @OutputPixel;
  InPlace := AInPlace;
end;

constructor TDitheringTask.Create(bmp: TBGRACustomBitmap;
  APalette: TBGRACustomApproxPalette; AInPlace: boolean; AIgnoreAlpha: boolean);
begin
  FPalette := APalette;
  FSource := bmp;
  FBounds := rect(0,0,bmp.Width,bmp.Height);
  FIgnoreAlpha:= AIgnoreAlpha;
  FCurrentOutputY := -1;
  FCurrentOutputScanline:= nil;
  FOutputPixel:= @OutputPixel;
  InPlace := AInPlace;
end;

{ TFloydSteinbergDitheringTask }

procedure TFloydSteinbergDitheringTask.DoExecute;
const
  ErrorPrecisionShift = 4;
  MaxColorDiffForDiffusion = 4096;
type
  TAccPixel = record
    red,green,blue,alpha: NativeInt;
  end;
  TLine = array of TAccPixel;

  procedure AddError(var dest: TAccPixel; const src: TAccPixel; factor: NativeInt);
  const maxError = 65536 shl ErrorPrecisionShift;
    minError = -(65536 shl ErrorPrecisionShift);
  begin
    dest.alpha += src.alpha * factor;
    if dest.alpha > maxError then dest.alpha := maxError;
    if dest.alpha < minError then dest.alpha := minError;
    dest.red += src.red * factor;
    if dest.red > maxError then dest.red := maxError;
    if dest.red < minError then dest.red := minError;
    dest.green += src.green * factor;
    if dest.green > maxError then dest.green := maxError;
    if dest.green < minError then dest.green := minError;
    dest.blue += src.blue * factor;
    if dest.blue > maxError then dest.blue := maxError;
    if dest.blue < minError then dest.blue := minError;
  end;

var
  w,h: NativeInt;

var
  p,pNext: PBGRAPixel;
  destX,destY: NativeInt;
  orig,cur,approxExp: TExpandedPixel;
  approx: TBGRAPixel;
  approxIndex: integer;
  curPix,diff: TAccPixel;
  i: NativeInt;
  yWrite: NativeInt;
  tempLine, currentLine, nextLine: TLine;

  function ClampWordDiv(AValue: NativeInt): Word; inline;
  begin
    if AValue < 0 then AValue := -((-AValue) shr ErrorPrecisionShift) else AValue := AValue shr ErrorPrecisionShift;
    if AValue < 0 then
      result := 0
    else if AValue > 65535 then
      result := 65535
    else
      result := AValue;
  end;

  function Div16(AValue: NativeInt): NativeInt; inline;
  begin
    if AValue < 0 then
      result := -((-AValue) shr 4)
    else
      result := AValue shr 4;
  end;

begin
  w := FBounds.Right-FBounds.Left;
  h := FBounds.Bottom-FBounds.Top;
  if (w <= 0) or (h <= 0) then exit;
  setlength(currentLine,w);
  setlength(nextLine,w);
  for yWrite := 0 to h-1 do
  begin
    if GetShouldStop(yWrite) then break;
    p := FSource.ScanLine[yWrite+FBounds.Top]+FBounds.Left;
    destX := FBounds.Left;
    destY := yWrite+FBounds.Top;
    if yWrite < h-1 then
      pNext := FSource.ScanLine[yWrite+FBounds.Top+1]+FBounds.Left
    else
      pNext := nil;
    if odd(yWrite) then
    begin
      inc(p, w);
      inc(destX, w);
      if pNext<>nil then inc(pNext, w);
      for i := w-1 downto 0 do
      begin
        dec(p);
        dec(destX);
        if pNext<>nil then dec(pNext);
        if p^.alpha <> 0 then
        begin
          orig := GammaExpansion(p^);
          with currentLine[i] do
          begin
            curPix.alpha := alpha+NativeInt(orig.alpha shl ErrorPrecisionShift);
            curPix.red := red+NativeInt(orig.red shl ErrorPrecisionShift);
            curPix.green := green+NativeInt(orig.green shl ErrorPrecisionShift);
            curPix.blue := blue+NativeInt(orig.blue shl ErrorPrecisionShift);
            cur.alpha := ClampWordDiv(curPix.alpha);
            cur.red := ClampWordDiv(curPix.red);
            cur.green := ClampWordDiv(curPix.green);
            cur.blue := ClampWordDiv(curPix.blue);
          end;
          approxIndex := FPalette.FindNearestColorIndex(GammaCompression(cur), FIgnoreAlpha);
          if approxIndex = -1 then
            approx := BGRAPixelTransparent
          else
            approx := FPalette.Color[approxIndex];
          approxExp := GammaExpansion(approx);
          diff.alpha := Div16(curPix.alpha - (approxExp.alpha shl ErrorPrecisionShift));
          if (approxExp.alpha = 0) or (cur.alpha = 0) then
          begin
            diff.red := 0;
            diff.green := 0;
            diff.blue := 0;
          end else
          begin
            diff.red := Div16(curPix.red - (approxExp.red shl ErrorPrecisionShift));
            diff.green := Div16(curPix.green - (approxExp.green shl ErrorPrecisionShift));
            diff.blue := Div16(curPix.blue - (approxExp.blue shl ErrorPrecisionShift));
          end;
          if i > 0 then
          begin
            if AbsRGBADiff(GammaExpansion((p-1)^),orig) < MaxColorDiffForDiffusion then
              AddError(currentLine[i-1], diff, 7);
          end;
          if nextLine <> nil then
          begin
            if i > 0 then
            begin
              if AbsRGBADiff(GammaExpansion((pNext-1)^),orig) < MaxColorDiffForDiffusion then
                AddError(nextLine[i-1], diff, 1);
            end;
            if AbsRGBADiff(GammaExpansion(pNext^),orig) < MaxColorDiffForDiffusion then
              AddError(nextLine[i], diff, 5);
            if i < w-1 then
            begin
              if AbsRGBADiff(GammaExpansion((pNext+1)^),orig) < MaxColorDiffForDiffusion then
                AddError(nextLine[i+1], diff, 3);
            end;
          end;
          FOutputPixel(destX,destY,approxIndex,approx);
        end;
      end
    end
    else
    for i := 0 to w-1 do
    begin
      if p^.alpha <> 0 then
      begin
        orig := GammaExpansion(p^);
        with currentLine[i] do
        begin
          curPix.alpha := alpha+NativeInt(orig.alpha shl ErrorPrecisionShift);
          curPix.red := red+NativeInt(orig.red shl ErrorPrecisionShift);
          curPix.green := green+NativeInt(orig.green shl ErrorPrecisionShift);
          curPix.blue := blue+NativeInt(orig.blue shl ErrorPrecisionShift);
          cur.alpha := ClampWordDiv(curPix.alpha);
          cur.red := ClampWordDiv(curPix.red);
          cur.green := ClampWordDiv(curPix.green);
          cur.blue := ClampWordDiv(curPix.blue);
        end;
        approxIndex := FPalette.FindNearestColorIndex(GammaCompression(cur), FIgnoreAlpha);
        if approxIndex = -1 then
          approx := BGRAPixelTransparent
        else
          approx := FPalette.Color[approxIndex];
        approxExp := GammaExpansion(approx);
        diff.alpha := Div16(curPix.alpha - (approxExp.alpha shl ErrorPrecisionShift));
        if (approxExp.alpha = 0) or (cur.alpha = 0) then
        begin
          diff.red := 0;
          diff.green := 0;
          diff.blue := 0;
        end else
        begin
          diff.red := Div16(curPix.red - (approxExp.red shl ErrorPrecisionShift));
          diff.green := Div16(curPix.green - (approxExp.green shl ErrorPrecisionShift));
          diff.blue := Div16(curPix.blue - (approxExp.blue shl ErrorPrecisionShift));
        end;
        if i < w-1 then
        begin
          if AbsRGBADiff(GammaExpansion((p+1)^),orig) < MaxColorDiffForDiffusion then
            AddError(currentLine[i+1], diff, 7);
        end;
        if nextLine <> nil then
        begin
          if i > 0 then
          begin
            if AbsRGBADiff(GammaExpansion((pNext-1)^),orig) < MaxColorDiffForDiffusion then
              AddError(nextLine[i-1], diff, 3);
          end;
          if AbsRGBADiff(GammaExpansion(pNext^),orig) < MaxColorDiffForDiffusion then
            AddError(nextLine[i], diff, 5);
          if i < w-1 then
          begin
            if AbsRGBADiff(GammaExpansion((pNext+1)^),orig) < MaxColorDiffForDiffusion then
              AddError(nextLine[i+1], diff, 1);
          end;
        end;
        FOutputPixel(destX,destY,approxIndex,approx);
      end;
      inc(p);
      inc(destX);
      if pNext<>nil then inc(pNext);
    end;
    tempLine := currentLine;
    currentLine := nextLine;
    nextLine := tempLine;
    if yWrite = h-2 then
      nextLine := nil
    else
      for i := 0 to w-1 do
      begin
        nextLine[i].red := 0;
        nextLine[i].green := 0;
        nextLine[i].blue := 0;
        nextLine[i].alpha := 0;
      end;
  end;
  FDestination.InvalidateBitmap;
end;

{ TNearestColorTask }

procedure TNearestColorTask.DoExecute;
var yb,xb: NativeInt;
  psrc: PBGRAPixel;
  colorIndex: NativeInt;
  colorValue: TBGRAPixel;
begin
  for yb := FBounds.Top to FBounds.Bottom - 1 do
  begin
    if GetShouldStop(yb) then break;
    psrc := FSource.ScanLine[yb] + FBounds.Left;
    for xb := FBounds.Left to FBounds.Right-1 do
    begin
      colorIndex := FPalette.FindNearestColorIndex(psrc^, FIgnoreAlpha);
      if colorIndex = -1 then
        colorValue := BGRAPixelTransparent
      else
        colorValue := FPalette.Color[colorIndex];
      FOutputPixel(xb,yb,colorIndex,colorValue);
      inc(psrc);
    end;
  end;
  FDestination.InvalidateBitmap;
end;

end.

