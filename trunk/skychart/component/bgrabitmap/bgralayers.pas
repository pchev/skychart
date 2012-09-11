unit BGRALayers;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Types, Graphics, BGRABitmapTypes, BGRABitmap;

type

  { TBGRACustomLayeredBitmap }

  TBGRACustomLayeredBitmap = class
  protected
    function GetWidth: integer; virtual; abstract;
    function GetHeight: integer; virtual; abstract;
    function GetNbLayers: integer; virtual; abstract;
    function GetBlendOperation(Layer: integer): TBlendOperation; virtual; abstract;
    function GetLayerVisible(layer: integer): boolean; virtual; abstract;
    function GetLayerOpacity(layer: integer): byte; virtual; abstract;
    function GetLayerName(layer: integer): string; virtual;
    function GetLayerOffset(layer: integer): TPoint; virtual;
    function GetLayerBitmapDirectly(layer: integer): TBGRABitmap; virtual;

  public
    procedure LoadFromFile(filename: string); virtual; abstract;
    procedure LoadFromStream(stream: TStream); virtual; abstract;
    destructor Destroy; override;
    procedure Clear; virtual; abstract;
    function ToString: ansistring; virtual;
    function GetLayerBitmapCopy(layer: integer): TBGRABitmap; virtual; abstract;
    function ComputeFlatImage: TBGRABitmap;
    procedure Draw(Canvas: TCanvas; x,y: integer); overload;
    procedure Draw(Dest: TBGRABitmap; x,y: integer); overload;

    property Width : integer read GetWidth;
    property Height: integer read GetHeight;
    property NbLayers: integer read GetNbLayers;
    property BlendOperation[layer: integer]: TBlendOperation read GetBlendOperation;
    property LayerVisible[layer: integer]: boolean read GetLayerVisible;
    property LayerOpacity[layer: integer]: byte read GetLayerOpacity;
    property LayerName[layer: integer]: string read GetLayerName;
    property LayerOffset[layer: integer]: TPoint read GetLayerOffset;
  end;

  TBGRALayerInfo = record
    Name: string;
    x, y: integer;
    Source: TBGRABitmap;
    blendOp: TBlendOperation;
    Opacity: byte;
    Visible: boolean;
    Owner: boolean;
  end;

  { TBGRALayeredBitmap }

  TBGRALayeredBitmap = class(TBGRACustomLayeredBitmap)
  private
    FNbLayers: integer;
    FLayers: array of TBGRALayerInfo;
    FWidth,FHeight: integer;

  protected
    function GetWidth: integer; override;
    function GetHeight: integer; override;
    function GetNbLayers: integer; override;
    function GetBlendOperation(Layer: integer): TBlendOperation; override;
    function GetLayerVisible(layer: integer): boolean; override;
    function GetLayerOpacity(layer: integer): byte; override;
    function GetLayerOffset(layer: integer): TPoint; override;
    function GetLayerName(layer: integer): string; override;
    procedure SetBlendOperation(Layer: integer; op: TBlendOperation);
    procedure SetLayerVisible(layer: integer; AValue: boolean);
    procedure SetLayerOpacity(layer: integer; AValue: byte);
    procedure SetLayerOffset(layer: integer; AValue: TPoint);
    procedure SetLayerName(layer: integer; AValue: string);
    function GetLayerBitmapDirectly(layer: integer): TBGRABitmap; override;

  public
    procedure LoadFromFile(filename: string); override;
    procedure LoadFromStream(stream: TStream); override;
    procedure Clear; override;
    procedure RemoveLayer(index: integer);
    procedure InsertLayer(index: integer; fromIndex: integer);
    function AddLayer(Source: TBGRABitmap; Opacity: byte = 255): integer; overload;
    function AddLayer(Source: TBGRABitmap; Position: TPoint; BlendOp: TBlendOperation = boTransparent; Opacity: byte = 255; Shared: boolean = false): integer; overload;
    function AddLayer(Source: TBGRABitmap; Position: TPoint; Opacity: byte): integer; overload;
    function AddLayer(Source: TBGRABitmap; BlendOp: TBlendOperation; Opacity: byte = 255): integer; overload;
    function AddLayer(AName: string; Source: TBGRABitmap; Opacity: byte = 255): integer; overload;
    function AddLayer(AName: string; Source: TBGRABitmap; Position: TPoint; BlendOp: TBlendOperation = boTransparent; Opacity: byte = 255; Shared: boolean = false): integer; overload;
    function AddLayer(AName: string; Source: TBGRABitmap; Position: TPoint; Opacity: byte): integer; overload;
    function AddLayer(AName: string; Source: TBGRABitmap; BlendOp: TBlendOperation; Opacity: byte = 255): integer; overload;
    function AddSharedLayer(Source: TBGRABitmap; Opacity: byte = 255): integer; overload;
    function AddSharedLayer(Source: TBGRABitmap; Position: TPoint; BlendOp: TBlendOperation = boTransparent; Opacity: byte = 255): integer; overload;
    function AddSharedLayer(Source: TBGRABitmap; Position: TPoint; Opacity: byte): integer; overload;
    function AddSharedLayer(Source: TBGRABitmap; BlendOp: TBlendOperation; Opacity: byte = 255): integer; overload;
    function AddLayerFromFile(AFileName: string; Opacity: byte = 255): integer; overload;
    function AddLayerFromFile(AFileName: string; Position: TPoint; BlendOp: TBlendOperation = boTransparent; Opacity: byte = 255): integer; overload;
    function AddLayerFromFile(AFileName: string; Position: TPoint; Opacity: byte): integer; overload;
    function AddLayerFromFile(AFileName: string; BlendOp: TBlendOperation; Opacity: byte = 255): integer; overload;
    function AddOwnedLayer(ABitmap: TBGRABitmap; Opacity: byte = 255): integer; overload;
    function AddOwnedLayer(ABitmap: TBGRABitmap; Position: TPoint; BlendOp: TBlendOperation = boTransparent; Opacity: byte = 255): integer; overload;
    function AddOwnedLayer(ABitmap: TBGRABitmap; Position: TPoint; Opacity: byte): integer; overload;
    function AddOwnedLayer(ABitmap: TBGRABitmap; BlendOp: TBlendOperation; Opacity: byte = 255): integer; overload;
    destructor Destroy; override;
    constructor Create;
    constructor Create(AWidth, AHeight: integer);
    function GetLayerBitmapCopy(layer: integer): TBGRABitmap; override;

    property Width : integer read GetWidth;
    property Height: integer read GetHeight;
    property NbLayers: integer read GetNbLayers;
    property BlendOperation[layer: integer]: TBlendOperation read GetBlendOperation write SetBlendOperation;
    property LayerVisible[layer: integer]: boolean read GetLayerVisible write SetLayerVisible;
    property LayerOpacity[layer: integer]: byte read GetLayerOpacity write SetLayerOpacity;
    property LayerName[layer: integer]: string read GetLayerName write SetLayerName;
    property LayerBitmap[layer: integer]: TBGRABitmap read GetLayerBitmapDirectly;
    property LayerOffset[layer: integer]: TPoint read GetLayerOffset write SetLayerOffset;
  end;

implementation

{ TBGRALayeredBitmap }

function TBGRALayeredBitmap.GetWidth: integer;
begin
  Result:= FWidth;
end;

function TBGRALayeredBitmap.GetHeight: integer;
begin
  Result:= FHeight;
end;

function TBGRALayeredBitmap.GetNbLayers: integer;
begin
  Result:= FNbLayers;
end;

function TBGRALayeredBitmap.GetBlendOperation(Layer: integer): TBlendOperation;
begin
  if (layer < 0) or (layer >= NbLayers) then
    raise Exception.Create('Index out of bounds')
  else
    Result:= FLayers[layer].blendOp;
end;

function TBGRALayeredBitmap.GetLayerVisible(layer: integer): boolean;
begin
  if (layer < 0) or (layer >= NbLayers) then
    raise Exception.Create('Index out of bounds')
  else
    Result:= FLayers[layer].Visible;
end;

function TBGRALayeredBitmap.GetLayerOpacity(layer: integer): byte;
begin
  if (layer < 0) or (layer >= NbLayers) then
    raise Exception.Create('Index out of bounds')
  else
    Result:= FLayers[layer].Opacity;
end;

function TBGRALayeredBitmap.GetLayerOffset(layer: integer): TPoint;
begin
  if (layer < 0) or (layer >= NbLayers) then
    raise Exception.Create('Index out of bounds')
  else
    with FLayers[layer] do
      Result:= Point(x,y);
end;

function TBGRALayeredBitmap.GetLayerName(layer: integer): string;
begin
  if (layer < 0) or (layer >= NbLayers) then
    raise Exception.Create('Index out of bounds')
  else
  begin
    if not FLayers[layer].Owner and (FLayers[layer].Source <> nil) then
      Result := FLayers[layer].Source.Caption
    else
      Result:= FLayers[layer].Name;
    if Result = '' then
      result := inherited GetLayerName(layer);
  end;
end;

procedure TBGRALayeredBitmap.SetBlendOperation(Layer: integer;
  op: TBlendOperation);
begin
  if (layer < 0) or (layer >= NbLayers) then
    raise Exception.Create('Index out of bounds')
  else
    FLayers[layer].blendOp := op;
end;

procedure TBGRALayeredBitmap.SetLayerVisible(layer: integer; AValue: boolean);
begin
  if (layer < 0) or (layer >= NbLayers) then
    raise Exception.Create('Index out of bounds')
  else
    FLayers[layer].Visible := AValue;
end;

procedure TBGRALayeredBitmap.SetLayerOpacity(layer: integer; AValue: byte);
begin
  if (layer < 0) or (layer >= NbLayers) then
    raise Exception.Create('Index out of bounds')
  else
    FLayers[layer].Opacity := AValue;
end;

procedure TBGRALayeredBitmap.SetLayerOffset(layer: integer; AValue: TPoint);
begin
  if (layer < 0) or (layer >= NbLayers) then
    raise Exception.Create('Index out of bounds')
  else
  begin
    FLayers[layer].x := AValue.x;
    FLayers[layer].y := AValue.y;
  end;
end;

procedure TBGRALayeredBitmap.SetLayerName(layer: integer; AValue: string);
begin
  if (layer < 0) or (layer >= NbLayers) then
    raise Exception.Create('Index out of bounds')
  else
  begin
    if not FLayers[layer].Owner and (FLayers[layer].Source <> nil) then
      FLayers[layer].Source.Caption := AValue
    else
      FLayers[layer].Name := AValue;
  end;
end;

function TBGRALayeredBitmap.GetLayerBitmapDirectly(layer: integer
  ): TBGRABitmap;
begin
  if (layer < 0) or (layer >= NbLayers) then
    result := nil
  else
    Result:= FLayers[layer].Source;
end;

procedure TBGRALayeredBitmap.LoadFromFile(filename: string);
var bmp: TBGRABitmap;
    index: integer;
begin
  Clear;
  bmp := TBGRABitmap.Create(filename);
  index := AddSharedLayer(bmp);
  FLayers[index].Owner:= true;
  FWidth := bmp.Width;
  FHeight := bmp.Height;
end;

procedure TBGRALayeredBitmap.LoadFromStream(stream: TStream);
var bmp: TBGRABitmap;
   index: integer;
begin
  Clear;
  bmp := TBGRABitmap.Create(stream);
  index := AddSharedLayer(bmp);
  FLayers[index].Owner:= true;
  FWidth := bmp.Width;
  FHeight := bmp.Height;
end;

procedure TBGRALayeredBitmap.Clear;
var i: integer;
begin
  for i := NbLayers-1 downto 0 do
    RemoveLayer(i);
end;

procedure TBGRALayeredBitmap.RemoveLayer(index: integer);
var i: integer;
begin
  if (index < 0) or (index >= NbLayers) then exit;
  if FLayers[index].Owner then FLayers[index].Source.Free;
  for i := index to FNbLayers-2 do
    FLayers[i] := FLayers[i+1];
  Dec(FNbLayers);
end;

procedure TBGRALayeredBitmap.InsertLayer(index: integer; fromIndex: integer);
var info: TBGRALayerInfo;
    i: integer;
begin
  if (index < 0) or (index > NbLayers) or (index = fromIndex) then exit;
  if (fromIndex < 0) or (fromIndex >= NbLayers) then exit;
  info := FLayers[fromIndex];
  for i := fromIndex to FNbLayers-2 do
    FLayers[i] := FLayers[i+1];
  for i := FNbLayers-1 downto index+1 do
    FLayers[i] := FLayers[i-1];
  FLayers[index] := info;
end;

function TBGRALayeredBitmap.AddLayer(Source: TBGRABitmap; Opacity: byte
  ): integer;
begin
  result := AddLayer(Source, Point(0,0), boTransparent, Opacity, False);
end;

function TBGRALayeredBitmap.AddLayer(Source: TBGRABitmap; Position: TPoint;
  BlendOp: TBlendOperation; Opacity: byte; Shared: boolean): integer;
begin
  result := AddLayer(Source.Caption,Source,Position,BlendOp,Opacity,Shared);
end;

function TBGRALayeredBitmap.AddLayer(Source: TBGRABitmap; Position: TPoint;
  Opacity: byte): integer;
begin
  result := AddLayer(Source,Position,boTransparent,Opacity);
end;

function TBGRALayeredBitmap.AddLayer(Source: TBGRABitmap;
  BlendOp: TBlendOperation; Opacity: byte): integer;
begin
  result := AddLayer(Source,Point(0,0),BlendOp,Opacity);
end;

function TBGRALayeredBitmap.AddLayer(AName: string; Source: TBGRABitmap;
  Opacity: byte): integer;
begin
  result := AddLayer(AName,Source,Point(0,0),Opacity);
end;

function TBGRALayeredBitmap.AddLayer(AName: string; Source: TBGRABitmap;
  Position: TPoint; BlendOp: TBlendOperation; Opacity: byte; Shared: boolean): integer;
begin
  if length(FLayers) = FNbLayers then
    setlength(FLayers, length(FLayers)*2+1);
  FLayers[FNbLayers].Name := AName;
  FLayers[FNbLayers].X := Position.X;
  FLayers[FNbLayers].Y := Position.Y;
  FLayers[FNbLayers].blendOp := BlendOp;
  FLayers[FNbLayers].Opacity := Opacity;
  FLayers[FNbLayers].Visible := true;
  if Shared then
  begin
    FLayers[FNbLayers].Source := Source;
    FLayers[FNbLayers].Owner := false;
  end else
  begin
    FLayers[FNbLayers].Source := Source.Duplicate as TBGRABitmap;
    FLayers[FNbLayers].Owner := true;
  end;
  result := FNbLayers;
  inc(FNbLayers);
  if (FNbLayers = 1) and (FWidth = 0) and (FHeight = 0) and (Source <> nil) then
  begin
    FWidth := Source.Width;
    FHeight := Source.Height;
  end;
end;

function TBGRALayeredBitmap.AddLayer(AName: string; Source: TBGRABitmap;
  Position: TPoint; Opacity: byte): integer;
begin
  result := AddLayer(AName, Source, Position, boTransparent, Opacity);
end;

function TBGRALayeredBitmap.AddLayer(AName: string; Source: TBGRABitmap;
  BlendOp: TBlendOperation; Opacity: byte): integer;
begin
  result := AddLayer(AName, Source, Point(0,0), blendOp, Opacity);
end;

function TBGRALayeredBitmap.AddSharedLayer(Source: TBGRABitmap; Opacity: byte
  ): integer;
begin
  result := AddSharedLayer(Source, Point(0,0), boTransparent, Opacity);
end;

function TBGRALayeredBitmap.AddSharedLayer(Source: TBGRABitmap;
  Position: TPoint; BlendOp: TBlendOperation; Opacity: byte): integer;
begin
  result := AddLayer(Source, Position, BlendOp, Opacity, True);
end;

function TBGRALayeredBitmap.AddSharedLayer(Source: TBGRABitmap;
  Position: TPoint; Opacity: byte): integer;
begin
  result := AddSharedLayer(Source, Position, boTransparent, Opacity);
end;

function TBGRALayeredBitmap.AddSharedLayer(Source: TBGRABitmap;
  BlendOp: TBlendOperation; Opacity: byte): integer;
begin
  result := AddSharedLayer(Source, Point(0,0), blendOp, Opacity);
end;

function TBGRALayeredBitmap.AddLayerFromFile(AFileName: string; Opacity: byte
  ): integer;
begin
  result := AddOwnedLayer(TBGRABitmap.Create(AFilename),Opacity);
  FLayers[result].Name := ExtractFileName(AFilename);
end;

function TBGRALayeredBitmap.AddLayerFromFile(AFileName: string;
  Position: TPoint; BlendOp: TBlendOperation; Opacity: byte): integer;
begin
  result := AddOwnedLayer(TBGRABitmap.Create(AFilename),Position,BlendOp,Opacity);
  FLayers[result].Name := ExtractFileName(AFilename);
end;

function TBGRALayeredBitmap.AddLayerFromFile(AFileName: string;
  Position: TPoint; Opacity: byte): integer;
begin
  result := AddOwnedLayer(TBGRABitmap.Create(AFilename),Position,Opacity);
  FLayers[result].Name := ExtractFileName(AFilename);
end;

function TBGRALayeredBitmap.AddLayerFromFile(AFileName: string;
  BlendOp: TBlendOperation; Opacity: byte): integer;
begin
  result := AddOwnedLayer(TBGRABitmap.Create(AFilename),BlendOp,Opacity);
  FLayers[result].Name := ExtractFileName(AFilename);
end;

function TBGRALayeredBitmap.AddOwnedLayer(ABitmap: TBGRABitmap; Opacity: byte
  ): integer;
begin
  result := AddSharedLayer(ABitmap,Opacity);
  FLayers[result].Owner := True;
end;

function TBGRALayeredBitmap.AddOwnedLayer(ABitmap: TBGRABitmap;
  Position: TPoint; BlendOp: TBlendOperation; Opacity: byte): integer;
begin
  result := AddSharedLayer(ABitmap,Position,BlendOp,Opacity);
  FLayers[result].Owner := True;
end;

function TBGRALayeredBitmap.AddOwnedLayer(ABitmap: TBGRABitmap;
  Position: TPoint; Opacity: byte): integer;
begin
  result := AddSharedLayer(ABitmap,Position,Opacity);
  FLayers[result].Owner := True;
end;

function TBGRALayeredBitmap.AddOwnedLayer(ABitmap: TBGRABitmap;
  BlendOp: TBlendOperation; Opacity: byte): integer;
begin
  result := AddSharedLayer(ABitmap,BlendOp,Opacity);
  FLayers[result].Owner := True;
end;

destructor TBGRALayeredBitmap.Destroy;
begin
  inherited Destroy;
end;

constructor TBGRALayeredBitmap.Create;
begin
  FWidth := 0;
  FHeight := 0;
  FNbLayers:= 0;
end;

constructor TBGRALayeredBitmap.Create(AWidth, AHeight: integer);
begin
  if AWidth < 0 then
    FWidth := 0
  else
    FWidth := AWidth;
  if AHeight < 0 then
    FHeight := 0
  else
    FHeight := AHeight;
  FNbLayers:= 0;
end;

function TBGRALayeredBitmap.GetLayerBitmapCopy(layer: integer): TBGRABitmap;
begin
  result := GetLayerBitmapDirectly(layer).Duplicate as TBGRABitmap;
end;

{ TBGRACustomLayeredBitmap }

function TBGRACustomLayeredBitmap.GetLayerName(layer: integer): string;
begin
  result := 'Layer' + inttostr(layer+1);
end;

{$hints off}
function TBGRACustomLayeredBitmap.GetLayerOffset(layer: integer): TPoint;
begin
  //optional function
  result := Point(0,0);
end;
{$hints on}

{$hints off}
function TBGRACustomLayeredBitmap.GetLayerBitmapDirectly(layer: integer
  ): TBGRABitmap;
begin
  //optional function
  result:= nil;
end;
{$hints on}

function TBGRACustomLayeredBitmap.ToString: ansistring;
var
  i: integer;
begin
  Result := 'LayeredBitmap' + LineEnding + LineEnding;
  for i := 0 to NbLayers - 1 do
  begin
    Result += LineEnding + 'Layer ' + IntToStr(i) + ' : ' + LayerName[i] + LineEnding;
  end;
end;

destructor TBGRACustomLayeredBitmap.Destroy;
begin
  Clear;
end;

function TBGRACustomLayeredBitmap.ComputeFlatImage: TBGRABitmap;
var
  tempLayer, tempMerge: TBGRABitmap;
  i: integer;
  mustFreeCopy: boolean;
  op: TBlendOperation;
  bounds: TRect;
begin
  Result := TBGRABitmap.Create(Width, Height);
  for i := 0 to NbLayers - 1 do
  if LayerVisible[i] and (LayerOpacity[i]<>0) then
  begin
    tempLayer := GetLayerBitmapDirectly(i);
    if tempLayer <> nil then
      mustFreeCopy := false
    else
    begin
      mustFreeCopy := true;
      tempLayer := GetLayerBitmapCopy(i);
    end;
    if tempLayer <> nil then
    with LayerOffset[i] do
    begin
      op := BlendOperation[i];
      //first layer is simply the background
      if i = 0 then
        Result.PutImage(x, y, tempLayer, dmSet, LayerOpacity[i])
      else
      //simple blend operations
      if op in [boTransparent, boLinearBlend] then
      begin
        if op = boTransparent then
          Result.PutImage(x,y,tempLayer,dmDrawWithTransparency, LayerOpacity[i])
        else
          Result.PutImage(x,y,tempLayer,dmLinearBlend, LayerOpacity[i]);
      end
      else
        //complex blend operations are done in a third bitmap
      begin
        {$hints off}
        if IntersectRect(bounds,rect(0,0,Width,Height),rect(x,y, x+tempLayer.Width,y+tempLayer.Height)) then
        begin
          tempMerge := TBGRABitmap.Create(bounds.Right-bounds.Left,bounds.Bottom-bounds.Top);
          tempMerge.PutImage(-bounds.Left,-bounds.Top,Result,dmSet);
          tempMerge.BlendImage(x - bounds.Left, y - bounds.Top, tempLayer, op);
          Result.PutImage(bounds.Left, bounds.Top, tempMerge, dmFastBlend, LayerOpacity[i]);
          tempMerge.Free;
        end;
        {$hints on}
      end;
      if mustFreeCopy then tempLayer.Free;
    end;
  end;
end;

procedure TBGRACustomLayeredBitmap.Draw(Canvas: TCanvas; x, y: integer);
var temp: TBGRABitmap;
begin
  temp := ComputeFlatImage;
  temp.Draw(Canvas,x,y,False);
  temp.Free;
end;

procedure TBGRACustomLayeredBitmap.Draw(Dest: TBGRABitmap; x, y: integer);
var
  temp: TBGRABitmap;
  i: integer;
  tempLayer: TBGRABitmap;
  mustFreeCopy: boolean;
  OldClipRect: TRect;
  NewClipRect: TRect;
begin
  for i := 0 to NbLayers-1 do
    if LayerVisible[i] and not (BlendOperation[i] in[boTransparent,boLinearBlend]) then
    begin
      temp := ComputeFlatImage;
      Dest.PutImage(x,y,temp,dmDrawWithTransparency);
      temp.Free;
      exit;
    end;
  OldClipRect := Dest.ClipRect;
  NewClipRect := rect(0,0,0,0);
  if IntersectRect(NewClipRect,rect(x,y,x+Width,y+Height),Dest.ClipRect) then
  begin
    Dest.ClipRect := NewClipRect;
    for i := 0 to NbLayers-1 do
    if LayerVisible[i] then
    with LayerOffset[i] do
    begin
      tempLayer := GetLayerBitmapDirectly(i);
      if tempLayer <> nil then
        mustFreeCopy := false
      else
      begin
        mustFreeCopy := true;
        tempLayer := GetLayerBitmapCopy(i);
      end;
      if tempLayer <> nil then
      begin
        if BlendOperation[i] = boTransparent then
          Dest.PutImage(x,y,GetLayerBitmapDirectly(i),dmDrawWithTransparency, LayerOpacity[i])
        else
          Dest.PutImage(x,y,GetLayerBitmapDirectly(i),dmLinearBlend, LayerOpacity[i]);
        if mustFreeCopy then tempLayer.Free;
      end;
    end;
    Dest.ClipRect := OldClipRect;
  end;
end;

end.

