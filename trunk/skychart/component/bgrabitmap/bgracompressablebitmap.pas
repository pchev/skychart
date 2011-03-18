unit bgracompressablebitmap;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, BGRABitmap;

type

   { TBGRACompressableBitmap }

   TBGRACompressableBitmap = class
   private
     FWidth,FHeight: integer;
     FCaption: String;
     FCompressedDataArray: array of TMemoryStream;
     FUncompressedData: TMemoryStream;
     FCompressionProgress: Int64;
     procedure Decompress;
     procedure FreeData;
   public
     constructor Create;
     constructor Create(Source: TBGRABitmap);
     function GetBitmap: TBGRABitmap;
     function Compress: boolean;
     function UsedMemory: Int64;
     procedure Assign(Source: TBGRABitmap);
     destructor Destroy; override;
     property Width : Integer read FWidth;
     property Height: Integer read FHeight;
     property Caption : string read FCaption;
   end;

implementation

uses zstream, BGRABitmapTypes;

const maxPartSize = 1048576;

{ TBGRACompressedBitmap }

constructor TBGRACompressableBitmap.Create;
begin
  FUncompressedData := nil;
  FCompressedDataArray := nil;
  FWidth := 0;
  FHeight := 0;
  FCaption := '';
  FCompressionProgress := 0;
end;

constructor TBGRACompressableBitmap.Create(Source: TBGRABitmap);
begin
  FUncompressedData := nil;
  FCompressedDataArray := nil;
  FWidth := 0;
  FHeight := 0;
  FCaption := '';
  FCompressionProgress := 0;
  Assign(Source);
end;

function TBGRACompressableBitmap.GetBitmap: TBGRABitmap;
begin
  Decompress;
  if FUncompressedData = nil then
  begin
    result := nil;
    exit;
  end;
  result := TBGRABitmap.Create(FWidth,FHeight);
  result.Caption := FCaption;
  FUncompressedData.Position := 0;
  FUncompressedData.Read(result.Data^,result.NbPixels*Sizeof(TBGRAPixel));
end;

function TBGRACompressableBitmap.UsedMemory: Int64;
var i: integer;
begin
  result := 0;
  for i := 0 to high(FCompressedDataArray) do
    result += FCompressedDataArray[i].Size;
  if FUncompressedData <> nil then result += FUncompressedData.Size;
end;

function TBGRACompressableBitmap.Compress: boolean;
var comp: Tcompressionstream;
    partSize: integer;
begin
  if FCompressedDataArray = nil then FCompressionProgress := 0;
  if FUncompressedData = nil then
  begin
    result := false;
    exit;
  end;
  if FCompressionProgress < FUncompressedData.Size then
  begin
    setlength(FCompressedDataArray, length(FCompressedDataArray)+1);
    FCompressedDataArray[high(FCompressedDataArray)] := TMemoryStream.Create;
    FUncompressedData.Position := FCompressionProgress;
    if FUncompressedData.Size - FCompressionProgress > maxPartSize then
      partSize := maxPartSize else
        partSize := integer(FUncompressedData.Size - FCompressionProgress);
    comp := Tcompressionstream.Create(clfastest,FCompressedDataArray[high(FCompressedDataArray)]);
    comp.write(partSize,sizeof(partSize));
    comp.CopyFrom(FUncompressedData,partSize);
    comp.Free;
    inc(FCompressionProgress, partSize);
  end;
  if FCompressionProgress >= FUncompressedData.Size then
    FreeAndNil(FUncompressedData);
  result := true;
end;

procedure TBGRACompressableBitmap.Decompress;
var decomp: Tdecompressionstream;
    i: integer;
    partSize: integer;
begin
  if (FUncompressedData <> nil) or (FCompressedDataArray = nil) then exit;
  FUncompressedData := TMemoryStream.Create;
  for i := 0 to high(FCompressedDataArray) do
  begin
    FCompressedDataArray[i].Position := 0;
    decomp := Tdecompressionstream.Create(FCompressedDataArray[i]);
    {$hints off}
    decomp.read(partSize,sizeof(partSize));
    {$hints on}
    FUncompressedData.CopyFrom(decomp,partSize);
    decomp.Free;
    FreeAndNil(FCompressedDataArray[i]);
  end;
  FCompressedDataArray := nil;
end;

procedure TBGRACompressableBitmap.FreeData;
var i: integer;
begin
  if FCompressedDataArray <> nil then
  begin
    for i := 0 to high(FCompressedDataArray) do
      FCompressedDataArray[I].Free;
    FCompressedDataArray := nil;
  end;
  if FUncompressedData <> nil then FreeAndNil(FUncompressedData);
end;

procedure TBGRACompressableBitmap.Assign(Source: TBGRABitmap);
begin
  FreeData;
  if Source = nil then
  begin
    FWidth := 0;
    FHeight := 0;
    FCaption := '';
    exit;
  end;
  FWidth := Source.Width;
  FHeight := Source.Height;
  FCaption := Source.Caption;
  FUncompressedData := TMemoryStream.Create;
  FUncompressedData.Write(Source.Data^,Source.NbPixels*Sizeof(TBGRAPixel));
end;

destructor TBGRACompressableBitmap.Destroy;
begin
  FreeData;
  inherited Destroy;
end;

end.

