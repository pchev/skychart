unit BGRAWriteLzp;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FPimage, BGRALzpCommon, BGRABitmapTypes, BGRABitmap;

type
  { TBGRAWriterLazPaint }

  TBGRAWriterLazPaint = class(TFPCustomImageWriter)
  private
    function GetCompression: TLzpCompression;
    function GetIncludeThumbnail: boolean;
    procedure SetCompression(AValue: TLzpCompression);
    procedure SetIncludeThumbnail(AValue: boolean);
    function WriteThumbnail(Str: TStream; Img: TFPCustomImage): boolean;
    protected
      CompressionMode: DWord;
      procedure InternalWrite(Str: TStream; Img: TFPCustomImage); override;
      function InternalWriteLayers({%H-}Str: TStream; {%H-}Img: TFPCustomImage): boolean; virtual;
      function GetNbLayers: integer; virtual;
    public
      Caption: string;
      constructor Create; override;
      class procedure WriteRLEImage(Str: TStream; Img: TFPCustomImage; ACaption: string= '');
      property Compression: TLzpCompression read GetCompression write SetCompression;
      property IncludeThumbnail: boolean read GetIncludeThumbnail write SetIncludeThumbnail;
  end;

implementation

uses BGRACompressableBitmap, FPWritePNG;

{ TBGRAWriterLazPaint }

function TBGRAWriterLazPaint.WriteThumbnail(Str: TStream; Img: TFPCustomImage): boolean;
var w,h: integer;
  thumbStream: TStream;
  OldResampleFilter: TResampleFilter;
  thumbnail: TBGRACustomBitmap;
  p: PBGRAPixel;
  n: integer;
begin
  result := false;
  if not (Img is TBGRACustomBitmap) then exit;
  if (Img.Width > LazpaintThumbMaxWidth) or
   (Img.Height > LazpaintThumbMaxHeight) then
  begin
    if Img.Width > LazpaintThumbMaxWidth then
    begin
      w := LazpaintThumbMaxWidth;
      h := round(Img.Height* (w/Img.Width));
    end else
    begin
      w := Img.Width;
      h := Img.Height;
    end;
    if h > LazpaintThumbMaxHeight then
    begin
      h := LazpaintThumbMaxHeight;
      w := round(Img.Width* (h/Img.Height));
    end;
    OldResampleFilter:= TBGRACustomBitmap(Img).ResampleFilter;
    TBGRACustomBitmap(Img).ResampleFilter:= rfMitchell;
    thumbnail := TBGRACustomBitmap(Img).Resample(w,h,rmFineResample);
    TBGRACustomBitmap(Img).ResampleFilter := OldResampleFilter;

    p := thumbnail.data; //avoid PNG bug with black color transformed into transparent
    for n := thumbnail.NbPixels-1 downto 0 do
    begin
      if (p^.alpha <> 0) and (p^.red = 0) and (p^.green = 0) and (p^.blue = 0) then
        p^.blue := 1;
      inc(p);
    end;

    try
      thumbStream := TMemoryStream.Create;
      try
        thumbnail.SaveToStreamAsPng(thumbStream);
        thumbStream.Position:= 0;
        Str.CopyFrom(thumbStream, thumbStream.Size);
        result := true;
      finally
        thumbStream.Free;
      end;
    finally
      thumbnail.Free;
    end;
  end;
end;

function TBGRAWriterLazPaint.GetCompression: TLzpCompression;
begin
  if (CompressionMode and LAZPAINT_COMPRESSION_MASK) = LAZPAINT_COMPRESSION_MODE_ZSTREAM then
    result := lzpZStream
  else
    result := lzpRLE;
end;

function TBGRAWriterLazPaint.GetIncludeThumbnail: boolean;
begin
  result := (CompressionMode and LAZPAINT_THUMBNAIL_PNG) <> 0;
end;

procedure TBGRAWriterLazPaint.SetCompression(AValue: TLzpCompression);
begin
  if AValue = lzpZStream then
    CompressionMode := (CompressionMode and not LAZPAINT_COMPRESSION_MASK) or LAZPAINT_COMPRESSION_MODE_ZSTREAM
  else
    CompressionMode := (CompressionMode and not LAZPAINT_COMPRESSION_MASK) or LAZPAINT_COMPRESSION_MODE_RLE;
end;

procedure TBGRAWriterLazPaint.SetIncludeThumbnail(AValue: boolean);
begin
  if AValue then
    CompressionMode := CompressionMode or LAZPAINT_THUMBNAIL_PNG else
    CompressionMode := CompressionMode and not LAZPAINT_THUMBNAIL_PNG;
end;

procedure TBGRAWriterLazPaint.InternalWrite(Str: TStream; Img: TFPCustomImage);
var {%H-}header: TLazPaintImageHeader;
  compBmp: TBGRACompressableBitmap;
  startPos, endPos: int64;
begin
  startPos := str.Position;
  fillchar({%H-}header,sizeof(header),0);
  header.magic := LAZPAINT_MAGIC_HEADER;
  header.zero1 := 0;
  header.headerSize:= sizeof(header);
  header.width := Img.Width;
  header.height := img.Height;
  header.nbLayers:= GetNbLayers;
  header.previewOffset:= 0;
  header.zero2 := 0;
  header.compressionMode:= CompressionMode;
  header.reserved1:= 0;
  header.layersOffset:= 0;
  LazPaintImageHeader_SwapEndianIfNeeded(header);
  str.WriteBuffer(header,sizeof(header));
  LazPaintImageHeader_SwapEndianIfNeeded(header);

  if IncludeThumbnail then
    if not WriteThumbnail(Str, Img) then
    begin
      IncludeThumbnail := false;
      header.compressionMode:= CompressionMode;
    end;

  header.previewOffset:= Str.Position - startPos;
  if Compression = lzpRLE then
    WriteRLEImage(Str, Img)
  else
  begin
    compBmp := TBGRACompressableBitmap.Create(Img as TBGRABitmap);
    compBmp.WriteToStream(Str);
    compBmp.Free;
  end;

  endPos := str.Position;
  if InternalWriteLayers(Str, Img) then
  begin
    header.layersOffset := endPos - startPos;
    endPos := str.Position;
  end;

  str.Position:= startPos;
  LazPaintImageHeader_SwapEndianIfNeeded(header);
  str.WriteBuffer(header,sizeof(header));
  str.Position:= endPos;
end;

function TBGRAWriterLazPaint.InternalWriteLayers(Str: TStream;
  Img: TFPCustomImage): boolean;
begin
  result := false;
end;

function TBGRAWriterLazPaint.GetNbLayers: integer;
begin
  result := 1;
end;

constructor TBGRAWriterLazPaint.Create;
begin
  inherited Create;
  CompressionMode:= LAZPAINT_COMPRESSION_MODE_RLE;
end;

class procedure TBGRAWriterLazPaint.WriteRLEImage(Str: TStream;
  Img: TFPCustomImage; ACaption: string);
const PossiblePlanes = 4;
var
  PPlane,PPlaneCur: array[0..PossiblePlanes-1] of PByte;
  CompressedPlane: array[0..PossiblePlanes-1] of TMemoryStream;
  NbPixels, NbNonTranspPixels, NbOpaquePixels: integer;

  procedure OutputPlane(AIndex: integer);
  begin
    str.WriteDWord(NtoLE(DWord(CompressedPlane[AIndex].Size)));
    CompressedPlane[AIndex].Position:= 0;
    str.CopyFrom(CompressedPlane[AIndex],CompressedPlane[AIndex].Size);
  end;

var
  i,x,y: integer;
  PlaneFlags: Byte;
  a: NativeInt;

begin
  NbPixels := Img.Width*img.Height;

  for i := 0 to PossiblePlanes-1 do
  begin
    getmem(PPlane[i],NbPixels);
    PPlaneCur[i] := PPlane[i];
    CompressedPlane[i] := nil;
  end;

  NbNonTranspPixels := 0;
  NbOpaquePixels:= 0;
  for y := 0 to img.Height-1 do
    for x := 0 to img.Width-1 do
    begin
      with img.Colors[x,y] do
      begin
        a := alpha shr 8;
        PPlaneCur[3]^ := a;
        inc(PPlaneCur[3]);
        if a = 0 then continue;
        if a = 255 then inc(NbOpaquePixels);

        inc(NbNonTranspPixels);
        PPlaneCur[0]^ := red shr 8;
        PPlaneCur[1]^ := green shr 8;
        PPlaneCur[2]^ := blue shr 8;
        inc(PPlaneCur[0]);
        inc(PPlaneCur[1]);
        inc(PPlaneCur[2]);
      end;
    end;

  PlaneFlags := 0;
  if NbOpaquePixels = NbPixels then PlaneFlags := PlaneFlags or LazpaintChannelNoAlpha;
  if CompareMem(PPlane[1],PPlane[0],NbNonTranspPixels) then PlaneFlags := PlaneFlags or LazpaintChannelGreenFromRed;
  if CompareMem(PPlane[2],PPlane[0],NbNonTranspPixels) then PlaneFlags := PlaneFlags or LazpaintChannelBlueFromRed else
  if CompareMem(PPlane[2],PPlane[1],NbNonTranspPixels) then PlaneFlags := PlaneFlags or LazpaintChannelBlueFromGreen;
  if (PlaneFlags and LazpaintChannelGreenFromRed) <> 0 then ReAllocMem(PPlane[1],0);
  if (PlaneFlags and (LazpaintChannelBlueFromRed or LazpaintChannelBlueFromGreen)) <> 0 then ReAllocMem(PPlane[2],0);

  for i := 0 to PossiblePlanes-1 do
    if PPlane[i] <> nil then
    begin
      CompressedPlane[i] := TMemoryStream.Create;
      if i = 3 then
        EncodeLazRLE(PPlane[i]^, NbPixels,CompressedPlane[i])
      else
        EncodeLazRLE(PPlane[i]^, NbNonTranspPixels,CompressedPlane[i]);
    end;

  str.WriteDWord(NtoLE(DWord(img.width)));
  str.WriteDWord(NtoLE(DWord(img.Height)));
  str.WriteDWord(NtoLE(DWord(length(ACaption))));
  str.WriteBuffer(ACaption[1],length(ACaption));
  str.WriteByte(PlaneFlags);

  if (PlaneFlags and LazpaintChannelNoAlpha) = 0 then OutputPlane(3);
  OutputPlane(0);
  if (PlaneFlags and LazpaintChannelGreenFromRed) = 0 then OutputPlane(1);
  if (PlaneFlags and (LazpaintChannelBlueFromRed or LazpaintChannelBlueFromGreen)) = 0 then OutputPlane(2);

  for i := 0 to PossiblePlanes-1 do
  begin
    freemem(PPlane[i]);
    CompressedPlane[i].Free;
  end;
end;

initialization

  DefaultBGRAImageWriter[ifLazPaint] := TBGRAWriterLazPaint;

end.
