unit BGRALayers;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Types, Graphics, BGRABitmapTypes, BGRABitmap;

type
  TBGRACustomLayeredBitmap = class;
  TBGRACustomLayeredBitmapClass = class of TBGRACustomLayeredBitmap;

  TBGRALayeredBitmap = class;
  TBGRALayeredBitmapClass = class of TBGRALayeredBitmap;

  { TBGRACustomLayeredBitmap }

  TBGRACustomLayeredBitmap = class
  private
    FFrozenRange: array of record
      firstLayer,lastLayer: integer;
      image: TBGRABitmap;
      linearBlend: boolean;
    end;
    FLinearBlend: boolean;
    function GetDefaultBlendingOperation: TBlendOperation;
    function GetLinearBlend: boolean;
    procedure SetLinearBlend(AValue: boolean);

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
    function GetLayerFrozenRange(layer: integer): integer;
    function GetLayerFrozen(layer: integer): boolean; virtual;
    procedure SetLayerFrozen(layer: integer; AValue: boolean); virtual;
    function RangeIntersect(first1,last1,first2,last2: integer): boolean;
    procedure RemoveFrozenRange(index: integer);

  public
    procedure LoadFromFile(filename: string); virtual; abstract;
    procedure LoadFromStream(stream: TStream); virtual; abstract;
    procedure SaveToFile(filename: string); virtual;
    constructor Create; virtual;
    destructor Destroy; override;
    procedure Clear; virtual; abstract;
    function ToString: ansistring; override;
    function GetLayerBitmapCopy(layer: integer): TBGRABitmap; virtual; abstract;
    function ComputeFlatImage: TBGRABitmap; overload;
    function ComputeFlatImage(firstLayer, lastLayer: integer): TBGRABitmap; overload;
    procedure Draw(Canvas: TCanvas; x,y: integer); overload;
    procedure Draw(Canvas: TCanvas; x,y: integer; firstLayer, lastLayer: integer); overload;
    procedure Draw(Dest: TBGRABitmap; x,y: integer); overload;
    procedure Draw(Dest: TBGRABitmap; AX,AY: integer; firstLayer, lastLayer: integer); overload;

    procedure FreezeExceptOneLayer(layer: integer); overload;
    procedure Freeze(firstLayer, lastLayer: integer); overload;
    procedure Freeze; overload;
    procedure Unfreeze; overload;
    procedure Unfreeze(layer: integer); overload;
    procedure Unfreeze(firstLayer, lastLayer: integer); overload;

    property Width : integer read GetWidth;
    property Height: integer read GetHeight;
    property NbLayers: integer read GetNbLayers;
    property BlendOperation[layer: integer]: TBlendOperation read GetBlendOperation;
    property LayerVisible[layer: integer]: boolean read GetLayerVisible;
    property LayerOpacity[layer: integer]: byte read GetLayerOpacity;
    property LayerName[layer: integer]: string read GetLayerName;
    property LayerOffset[layer: integer]: TPoint read GetLayerOffset;
    property LayerFrozen[layer: integer]: boolean read GetLayerFrozen;
    property LinearBlend: boolean read GetLinearBlend write SetLinearBlend; //use linear blending unless specified
    property DefaultBlendingOperation: TBlendOperation read GetDefaultBlendingOperation;
  end;

  TBGRALayerInfo = record
    UniqueId: integer;
    Name: string;
    x, y: integer;
    Source: TBGRABitmap;
    blendOp: TBlendOperation;
    Opacity: byte;
    Visible: boolean;
    Owner: boolean;
    Frozen: boolean;
  end;

  { TBGRALayeredBitmap }

  TBGRALayeredBitmap = class(TBGRACustomLayeredBitmap)
  private
    FNbLayers: integer;
    FLayers: array of TBGRALayerInfo;
    FWidth,FHeight: integer;
    function GetLayerUniqueId(layer: integer): integer;
    procedure SetLayerUniqueId(layer: integer; AValue: integer);

  protected
    function GetWidth: integer; override;
    function GetHeight: integer; override;
    function GetNbLayers: integer; override;
    function GetBlendOperation(Layer: integer): TBlendOperation; override;
    function GetLayerVisible(layer: integer): boolean; override;
    function GetLayerOpacity(layer: integer): byte; override;
    function GetLayerOffset(layer: integer): TPoint; override;
    function GetLayerName(layer: integer): string; override;
    function GetLayerFrozen(layer: integer): boolean; override;
    procedure SetBlendOperation(Layer: integer; op: TBlendOperation);
    procedure SetLayerVisible(layer: integer; AValue: boolean);
    procedure SetLayerOpacity(layer: integer; AValue: byte);
    procedure SetLayerOffset(layer: integer; AValue: TPoint);
    procedure SetLayerName(layer: integer; AValue: string);
    procedure SetLayerFrozen(layer: integer; AValue: boolean); override;
    function GetLayerBitmapDirectly(layer: integer): TBGRABitmap; override;

  public
    procedure LoadFromFile(filename: string); override;
    procedure LoadFromStream(stream: TStream); override;
    procedure SetSize(AWidth, AHeight: integer); virtual;
    procedure Clear; override;
    procedure RemoveLayer(index: integer);
    procedure InsertLayer(index: integer; fromIndex: integer);
    procedure Assign(ASource: TBGRACustomLayeredBitmap; ASharedLayerIds: boolean = false);
    function MoveLayerUp(index: integer): integer;
    function MoveLayerDown(index: integer): integer;
    function AddLayer(Source: TBGRABitmap; Opacity: byte = 255): integer; overload;
    function AddLayer(Source: TBGRABitmap; Position: TPoint; BlendOp: TBlendOperation; Opacity: byte = 255; Shared: boolean = false): integer; overload;
    function AddLayer(Source: TBGRABitmap; Position: TPoint; Opacity: byte = 255): integer; overload;
    function AddLayer(Source: TBGRABitmap; BlendOp: TBlendOperation; Opacity: byte = 255): integer; overload;
    function AddLayer(AName: string; Source: TBGRABitmap; Opacity: byte = 255): integer; overload;
    function AddLayer(AName: string; Source: TBGRABitmap; Position: TPoint; BlendOp: TBlendOperation; Opacity: byte = 255; Shared: boolean = false): integer; overload;
    function AddLayer(AName: string; Source: TBGRABitmap; Position: TPoint; Opacity: byte = 255): integer; overload;
    function AddLayer(AName: string; Source: TBGRABitmap; BlendOp: TBlendOperation; Opacity: byte = 255): integer; overload;
    function AddSharedLayer(Source: TBGRABitmap; Opacity: byte = 255): integer; overload;
    function AddSharedLayer(Source: TBGRABitmap; Position: TPoint; BlendOp: TBlendOperation; Opacity: byte = 255): integer; overload;
    function AddSharedLayer(Source: TBGRABitmap; Position: TPoint; Opacity: byte = 255): integer; overload;
    function AddSharedLayer(Source: TBGRABitmap; BlendOp: TBlendOperation; Opacity: byte = 255): integer; overload;
    function AddLayerFromFile(AFileName: string; Opacity: byte = 255): integer; overload;
    function AddLayerFromFile(AFileName: string; Position: TPoint; BlendOp: TBlendOperation; Opacity: byte = 255): integer; overload;
    function AddLayerFromFile(AFileName: string; Position: TPoint; Opacity: byte = 255): integer; overload;
    function AddLayerFromFile(AFileName: string; BlendOp: TBlendOperation; Opacity: byte = 255): integer; overload;
    function AddOwnedLayer(ABitmap: TBGRABitmap; Opacity: byte = 255): integer; overload;
    function AddOwnedLayer(ABitmap: TBGRABitmap; Position: TPoint; BlendOp: TBlendOperation; Opacity: byte = 255): integer; overload;
    function AddOwnedLayer(ABitmap: TBGRABitmap; Position: TPoint; Opacity: byte = 255): integer; overload;
    function AddOwnedLayer(ABitmap: TBGRABitmap; BlendOp: TBlendOperation; Opacity: byte = 255): integer; overload;
    destructor Destroy; override;
    constructor Create; override;
    constructor Create(AWidth, AHeight: integer);
    function GetLayerBitmapCopy(layer: integer): TBGRABitmap; override;
    function GetLayerIndexFromId(AIdentifier: integer): integer;
    function Duplicate(ASharedLayerIds: boolean = false): TBGRALayeredBitmap;

    procedure RotateCW;
    procedure RotateCCW;
    procedure HorizontalFlip;
    procedure VerticalFlip;
    procedure Resample(AWidth, AHeight: integer; AResampleMode: TResampleMode; AFineResampleFilter: TResampleFilter = rfLinear);
    procedure SetLayerBitmap(layer: integer; ABitmap: TBGRABitmap; AOwned: boolean);

    property Width : integer read GetWidth;
    property Height: integer read GetHeight;
    property NbLayers: integer read GetNbLayers;
    property BlendOperation[layer: integer]: TBlendOperation read GetBlendOperation write SetBlendOperation;
    property LayerVisible[layer: integer]: boolean read GetLayerVisible write SetLayerVisible;
    property LayerOpacity[layer: integer]: byte read GetLayerOpacity write SetLayerOpacity;
    property LayerName[layer: integer]: string read GetLayerName write SetLayerName;
    property LayerBitmap[layer: integer]: TBGRABitmap read GetLayerBitmapDirectly;
    property LayerOffset[layer: integer]: TPoint read GetLayerOffset write SetLayerOffset;
    property LayerUniqueId[layer: integer]: integer read GetLayerUniqueId write SetLayerUniqueId;
  end;

procedure RegisterLayeredBitmapWriter(AExtension: string; AWriter: TBGRALayeredBitmapClass);
procedure RegisterLayeredBitmapReader(AExtension: string; AReader: TBGRACustomLayeredBitmapClass);

implementation

var
  NextLayerUniqueId: cardinal;
  LayeredBitmapReaders: array of record
     extension: string;
     theClass: TBGRACustomLayeredBitmapClass;
  end;
  LayeredBitmapWriters: array of record
     extension: string;
     theClass: TBGRALayeredBitmapClass;
  end;

{ TBGRALayeredBitmap }

function TBGRALayeredBitmap.GetLayerUniqueId(layer: integer): integer;
begin
  if (layer < 0) or (layer >= NbLayers) then
    raise Exception.Create('Index out of bounds')
  else
    Result:= FLayers[layer].UniqueId;
end;

procedure TBGRALayeredBitmap.SetLayerUniqueId(layer: integer; AValue: integer);
var i: integer;
begin
  if (layer < 0) or (layer >= NbLayers) then
    raise Exception.Create('Index out of bounds')
  else
  begin
    for i := 0 to NbLayers-1 do
      if (i <> layer) and (FLayers[layer].UniqueId = AValue) then
        raise Exception.Create('Another layer has the same identifier');
    FLayers[layer].UniqueId := AValue;
  end;
end;

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

function TBGRALayeredBitmap.GetLayerFrozen(layer: integer): boolean;
begin
  if (layer < 0) or (layer >= NbLayers) then
    raise Exception.Create('Index out of bounds')
  else
    Result:= FLayers[layer].Frozen;
end;

procedure TBGRALayeredBitmap.SetBlendOperation(Layer: integer;
  op: TBlendOperation);
begin
  if (layer < 0) or (layer >= NbLayers) then
    raise Exception.Create('Index out of bounds')
  else
  begin
    if FLayers[layer].blendOp <> op then
    begin
      FLayers[layer].blendOp := op;
      Unfreeze(layer);
    end;
  end;
end;

procedure TBGRALayeredBitmap.SetLayerVisible(layer: integer; AValue: boolean);
begin
  if (layer < 0) or (layer >= NbLayers) then
    raise Exception.Create('Index out of bounds')
  else
  begin
    if FLayers[layer].Visible <> AValue then
    begin
      FLayers[layer].Visible := AValue;
      Unfreeze(layer);
    end;
  end;
end;

procedure TBGRALayeredBitmap.SetLayerOpacity(layer: integer; AValue: byte);
begin
  if (layer < 0) or (layer >= NbLayers) then
    raise Exception.Create('Index out of bounds')
  else
  begin
    if FLayers[layer].Opacity <> AValue then
    begin
      FLayers[layer].Opacity := AValue;
      Unfreeze(layer);
    end;
  end;
end;

procedure TBGRALayeredBitmap.SetLayerOffset(layer: integer; AValue: TPoint);
begin
  if (layer < 0) or (layer >= NbLayers) then
    raise Exception.Create('Index out of bounds')
  else
  begin
    if (FLayers[layer].x <> AValue.x) or
      (FLayers[layer].y <> AValue.y) then
    begin
      FLayers[layer].x := AValue.x;
      FLayers[layer].y := AValue.y;
      Unfreeze(layer);
    end;
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

procedure TBGRALayeredBitmap.SetLayerFrozen(layer: integer; AValue: boolean);
begin
  if (layer < 0) or (layer >= NbLayers) then
    raise Exception.Create('Index out of bounds')
  else
    FLayers[layer].Frozen := AValue;
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
    ext: string;
    temp: TBGRACustomLayeredBitmap;
    i: integer;
begin
  ext := lowercase(ExtractFileExt(filename));
  for i := 0 to high(LayeredBitmapReaders) do
    if '.'+LayeredBitmapReaders[i].extension = ext then
    begin
      temp := LayeredBitmapReaders[i].theClass.Create;
      try
        temp.LoadFromFile(filename);
        Assign(temp);
      finally
        temp.Free;
      end;
      exit;
    end;

  bmp := TBGRABitmap.Create(filename);
  Clear;
  SetSize(bmp.Width,bmp.Height);
  index := AddSharedLayer(bmp);
  FLayers[index].Owner:= true;
end;

procedure TBGRALayeredBitmap.LoadFromStream(stream: TStream);
var bmp: TBGRABitmap;
   index: integer;
begin
  bmp := TBGRABitmap.Create(stream);
  Clear;
  SetSize(bmp.Width,bmp.Height);
  index := AddSharedLayer(bmp);
  FLayers[index].Owner:= true;
end;

procedure TBGRALayeredBitmap.SetSize(AWidth, AHeight: integer);
begin
  Unfreeze;
  FWidth := AWidth;
  FHeight := AHeight;
end;

procedure TBGRALayeredBitmap.Clear;
var i: integer;
begin
  Unfreeze;
  for i := NbLayers-1 downto 0 do
    RemoveLayer(i);
end;

procedure TBGRALayeredBitmap.RemoveLayer(index: integer);
var i: integer;
begin
  if (index < 0) or (index >= NbLayers) then exit;
  Unfreeze;
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
  Unfreeze;
  info := FLayers[fromIndex];
  for i := fromIndex to FNbLayers-2 do
    FLayers[i] := FLayers[i+1];
  for i := FNbLayers-1 downto index+1 do
    FLayers[i] := FLayers[i-1];
  FLayers[index] := info;
end;

procedure TBGRALayeredBitmap.Assign(ASource: TBGRACustomLayeredBitmap; ASharedLayerIds: boolean);
var i,idx: integer;
begin
  Clear;
  SetSize(ASource.Width,ASource.Height);
  LinearBlend:= ASource.LinearBlend;
  for i := 0 to ASource.NbLayers-1 do
  begin
    idx := AddOwnedLayer(ASource.GetLayerBitmapCopy(i),ASource.LayerOffset[i],ASource.BlendOperation[i],ASource.LayerOpacity[i]);
    LayerName[idx] := ASource.LayerName[i];
    LayerVisible[idx] := ASource.LayerVisible[i];
    if ASharedLayerIds and (ASource is TBGRALayeredBitmap) then
      LayerUniqueId[idx] := TBGRALayeredBitmap(ASource).LayerUniqueId[idx];
  end;
end;

function TBGRALayeredBitmap.MoveLayerUp(index: integer): integer;
begin
  if (index >= 0) and (index <= NbLayers-2) then
  begin
    InsertLayer(index+1,index);
    result := index+1;
  end else
    result := -1;
end;

function TBGRALayeredBitmap.MoveLayerDown(index: integer): integer;
begin
  if (index > 0) and (index <= NbLayers-1) then
  begin
    InsertLayer(index-1,index);
    result := index-1;
  end else
    result := -1;
end;

function TBGRALayeredBitmap.AddLayer(Source: TBGRABitmap; Opacity: byte
  ): integer;
begin
  result := AddLayer(Source, Point(0,0), DefaultBlendingOperation, Opacity, False);
end;

function TBGRALayeredBitmap.AddLayer(Source: TBGRABitmap; Position: TPoint;
  BlendOp: TBlendOperation; Opacity: byte; Shared: boolean): integer;
begin
  result := AddLayer(Source.Caption,Source,Position,BlendOp,Opacity,Shared);
end;

function TBGRALayeredBitmap.AddLayer(Source: TBGRABitmap; Position: TPoint;
  Opacity: byte): integer;
begin
  result := AddLayer(Source,Position,DefaultBlendingOperation,Opacity);
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
  FLayers[FNbLayers].Frozen := false;
  FLayers[FNbLayers].UniqueId := InterLockedIncrement(NextLayerUniqueId);
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
    SetSize(Source.Width,Source.Height);
end;

function TBGRALayeredBitmap.AddLayer(AName: string; Source: TBGRABitmap;
  Position: TPoint; Opacity: byte): integer;
begin
  result := AddLayer(AName, Source, Position, DefaultBlendingOperation, Opacity);
end;

function TBGRALayeredBitmap.AddLayer(AName: string; Source: TBGRABitmap;
  BlendOp: TBlendOperation; Opacity: byte): integer;
begin
  result := AddLayer(AName, Source, Point(0,0), blendOp, Opacity);
end;

function TBGRALayeredBitmap.AddSharedLayer(Source: TBGRABitmap; Opacity: byte
  ): integer;
begin
  result := AddSharedLayer(Source, Point(0,0), DefaultBlendingOperation, Opacity);
end;

function TBGRALayeredBitmap.AddSharedLayer(Source: TBGRABitmap;
  Position: TPoint; BlendOp: TBlendOperation; Opacity: byte): integer;
begin
  result := AddLayer(Source, Position, BlendOp, Opacity, True);
end;

function TBGRALayeredBitmap.AddSharedLayer(Source: TBGRABitmap;
  Position: TPoint; Opacity: byte): integer;
begin
  result := AddSharedLayer(Source, Position, DefaultBlendingOperation, Opacity);
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
  inherited Create;
  FWidth := 0;
  FHeight := 0;
  FNbLayers:= 0;
end;

constructor TBGRALayeredBitmap.Create(AWidth, AHeight: integer);
begin
  inherited Create;
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

function TBGRALayeredBitmap.GetLayerIndexFromId(AIdentifier: integer): integer;
var i: integer;
begin
  for i := 0 to NbLayers-1 do
    if FLayers[i].UniqueId = AIdentifier then
    begin
      result := i;
      exit;
    end;
  result := -1; //not found
end;

function TBGRALayeredBitmap.Duplicate(ASharedLayerIds: boolean): TBGRALayeredBitmap;
begin
  result := TBGRALayeredBitmap.Create;
  result.Assign(self, ASharedLayerIds);
end;

procedure TBGRALayeredBitmap.RotateCW;
var i: integer;
begin
  SetSize(Height,Width); //unfreeze
  for i := 0 to NbLayers-1 do
    SetLayerBitmap(i, LayerBitmap[i].RotateCW as TBGRABitmap, True);
end;

procedure TBGRALayeredBitmap.RotateCCW;
var i: integer;
begin
  SetSize(Height,Width); //unfreeze
  for i := 0 to NbLayers-1 do
    SetLayerBitmap(i, LayerBitmap[i].RotateCCW as TBGRABitmap, True);
end;

procedure TBGRALayeredBitmap.HorizontalFlip;
var i: integer;
begin
  Unfreeze;
  for i := 0 to NbLayers-1 do
  begin
    if FLayers[i].Owner then
      FLayers[i].Source.HorizontalFlip
    else
    begin
      FLayers[i].Source := FLayers[i].Source.Duplicate(True) as TBGRABitmap;
      FLayers[i].Source.HorizontalFlip;
      FLayers[i].Owner := true;
    end;
  end;
end;

procedure TBGRALayeredBitmap.VerticalFlip;
var i: integer;
begin
  Unfreeze;
  for i := 0 to NbLayers-1 do
  begin
    if FLayers[i].Owner then
      FLayers[i].Source.VerticalFlip
    else
    begin
      FLayers[i].Source := FLayers[i].Source.Duplicate(True) as TBGRABitmap;
      FLayers[i].Source.VerticalFlip;
      FLayers[i].Owner := true;
    end;
  end;
end;

procedure TBGRALayeredBitmap.Resample(AWidth, AHeight: integer;
  AResampleMode: TResampleMode; AFineResampleFilter: TResampleFilter);
var i: integer;
    resampled: TBGRABitmap;
    oldFilter : TResampleFilter;
begin
  if (AWidth < 0) or (AHeight < 0) then
    raise exception.Create('Invalid size');
  SetSize(AWidth, AHeight); //unfreeze
  for i := 0 to NbLayers-1 do
  begin
    oldFilter := LayerBitmap[i].ResampleFilter;
    LayerBitmap[i].ResampleFilter := AFineResampleFilter;
    resampled := LayerBitmap[i].Resample(AWidth,AHeight, AResampleMode) as TBGRABitmap;
    LayerBitmap[i].ResampleFilter := oldFilter;
    SetLayerBitmap(i, resampled, True);
  end;
end;

procedure TBGRALayeredBitmap.SetLayerBitmap(layer: integer;
  ABitmap: TBGRABitmap; AOwned: boolean);
begin
  if (layer < 0) or (layer >= NbLayers) then
    raise Exception.Create('Index out of bounds')
  else
  begin
    if ABitmap = FLayers[layer].Source then exit;
    Unfreeze(layer);
    if FLayers[layer].Owner then FLayers[layer].Source.Free;
    FLayers[layer].Source := ABitmap;
    FLayers[layer].Owner := AOwned;
  end;
end;

{ TBGRACustomLayeredBitmap }

function TBGRACustomLayeredBitmap.GetLinearBlend: boolean;
begin
  result := FLinearBlend;
end;

function TBGRACustomLayeredBitmap.GetDefaultBlendingOperation: TBlendOperation;
begin
  result := boTransparent;
end;

procedure TBGRACustomLayeredBitmap.SetLinearBlend(AValue: boolean);
begin
  Unfreeze;
  FLinearBlend := AValue;
end;

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

function TBGRACustomLayeredBitmap.GetLayerFrozenRange(layer: integer): integer;
var i: integer;
begin
  for i := 0 to high(FFrozenRange) do
    if (layer >= FFrozenRange[i].firstLayer) and (layer <= FFrozenRange[i].lastLayer) then
    begin
      result := i;
      exit;
    end;
  result := -1;
end;

function TBGRACustomLayeredBitmap.GetLayerFrozen(layer: integer): boolean;
var i: integer;
begin
  for i := 0 to high(FFrozenRange) do
    if (layer >= FFrozenRange[i].firstLayer) and (layer <= FFrozenRange[i].lastLayer) then
    begin
      result := true;
      exit;
    end;
  result := false;
end;

procedure TBGRACustomLayeredBitmap.SetLayerFrozen(layer: integer;
  AValue: boolean);
begin
  //nothing
end;

function TBGRACustomLayeredBitmap.RangeIntersect(first1, last1, first2,
  last2: integer): boolean;
begin
  result := (first1 <= last2) and (last1 >= first2);
end;

procedure TBGRACustomLayeredBitmap.RemoveFrozenRange(index: integer);
var j,i: integer;
begin
  for j := FFrozenRange[index].firstLayer to FFrozenRange[index].lastLayer do
    SetLayerFrozen(j,False);
  FFrozenRange[index].image.Free;
  for i := index to high(FFrozenRange)-1 do
    FFrozenRange[i] := FFrozenRange[i+1];
  setlength(FFrozenRange,length(FFrozenRange)-1);
end;

procedure TBGRACustomLayeredBitmap.SaveToFile(filename: string);
var bmp: TBGRABitmap;
    ext: string;
    temp: TBGRALayeredBitmap;
    i: integer;
begin
  ext := lowercase(ExtractFileExt(filename));
  for i := 0 to high(LayeredBitmapWriters) do
    if '.'+LayeredBitmapWriters[i].extension = ext then
    begin
      temp := LayeredBitmapWriters[i].theClass.Create;
      try
        temp.Assign(self);
        temp.SaveToFile(filename);
      finally
        temp.Free;
      end;
      exit;
    end;

  bmp := ComputeFlatImage;
  try
    bmp.SaveToFile(filename);
  finally
    bmp.Free;
  end;
end;

constructor TBGRACustomLayeredBitmap.Create;
begin
  FFrozenRange := nil;
  FLinearBlend:= True;
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

function TBGRACustomLayeredBitmap.ComputeFlatImage: TBGRABitmap;
begin
  result := ComputeFlatImage(0, NbLayers - 1);
end;

destructor TBGRACustomLayeredBitmap.Destroy;
begin
  Clear;
end;

function TBGRACustomLayeredBitmap.ComputeFlatImage(firstLayer, lastLayer: integer): TBGRABitmap;
var
  tempLayer: TBGRABitmap;
  i,j: integer;
  mustFreeCopy: boolean;
  op: TBlendOperation;
begin
  Result := TBGRABitmap.Create(Width, Height);
  i := firstLayer;
  while i <= lastLayer do
  begin
    if LayerFrozen[i] then
    begin
      j := GetLayerFrozenRange(i);
      if j <> -1 then
      begin
        if i = 0 then
          Result.PutImage(0,0,FFrozenRange[j].image,dmSet) else
        if not FFrozenRange[j].linearBlend then
          Result.PutImage(0,0,FFrozenRange[j].image,dmDrawWithTransparency)
        else
          Result.PutImage(0,0,FFrozenRange[j].image,dmLinearBlend);
        i := FFrozenRange[j].lastLayer+1;
        continue;
      end;
    end;
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
        if i = firstLayer then
          Result.PutImage(x, y, tempLayer, dmSet, LayerOpacity[i])
        else
        //simple blend operations
        if (op = boLinearBlend) or ((op = boTransparent) and LinearBlend) then
          Result.PutImage(x,y,tempLayer,dmLinearBlend, LayerOpacity[i]) else
        if op = boTransparent then
          Result.PutImage(x,y,tempLayer,dmDrawWithTransparency, LayerOpacity[i])
        else
          //complex blend operations are done in a third bitmap
          result.BlendImageOver(x,y, tempLayer, op, LayerOpacity[i], LinearBlend);
        if mustFreeCopy then tempLayer.Free;
      end;
    end;
    inc(i);
  end;
end;

procedure TBGRACustomLayeredBitmap.Draw(Canvas: TCanvas; x, y: integer);
begin
  Draw(Canvas,x,y,0,NbLayers-1);
end;

procedure TBGRACustomLayeredBitmap.Draw(Canvas: TCanvas; x, y: integer; firstLayer, lastLayer: integer);
var temp: TBGRABitmap;
begin
  temp := ComputeFlatImage(firstLayer,lastLayer);
  temp.Draw(Canvas,x,y,False);
  temp.Free;
end;

procedure TBGRACustomLayeredBitmap.Draw(Dest: TBGRABitmap; x, y: integer);
begin
  Draw(Dest,x,y,0,NbLayers-1);
end;

procedure TBGRACustomLayeredBitmap.Draw(Dest: TBGRABitmap; AX, AY: integer; firstLayer, lastLayer: integer);
var
  temp: TBGRABitmap;
  i,j: integer;
  tempLayer: TBGRABitmap;
  mustFreeCopy: boolean;
  OldClipRect: TRect;
  NewClipRect: TRect;
begin
  for i := firstLayer to lastLayer do
    if LayerVisible[i] and not (BlendOperation[i] in[boTransparent,boLinearBlend]) then
    begin
      temp := ComputeFlatImage;
      if self.LinearBlend then
        Dest.PutImage(AX,AY,temp,dmLinearBlend)
      else
        Dest.PutImage(AX,AY,temp,dmDrawWithTransparency);
      temp.Free;
      exit;
    end;
  OldClipRect := Dest.ClipRect;
  NewClipRect := rect(0,0,0,0);
  if IntersectRect(NewClipRect,rect(AX,AY,AX+Width,AY+Height),Dest.ClipRect) then
  begin
    Dest.ClipRect := NewClipRect;
    i := firstLayer;
    while i <= lastLayer do
    begin
      if LayerFrozen[i] then
      begin
        j := GetLayerFrozenRange(i);
        if j <> -1 then
        begin
          if not FFrozenRange[j].linearBlend then
            Dest.PutImage(AX,AY,FFrozenRange[j].image,dmDrawWithTransparency)
          else
            Dest.PutImage(AX,AY,FFrozenRange[j].image,dmLinearBlend);
          i := FFrozenRange[j].lastLayer+1;
          continue;
        end;
      end;
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
          if (BlendOperation[i] = boTransparent) and not self.LinearBlend then //here it is specified not to use linear blending
            Dest.PutImage(AX+x,AY+y,GetLayerBitmapDirectly(i),dmDrawWithTransparency, LayerOpacity[i])
          else
            Dest.PutImage(AX+x,AY+y,GetLayerBitmapDirectly(i),dmLinearBlend, LayerOpacity[i]);
          if mustFreeCopy then tempLayer.Free;
        end;
      end;
      inc(i);
    end;
    Dest.ClipRect := OldClipRect;
  end;
end;

procedure TBGRACustomLayeredBitmap.FreezeExceptOneLayer(layer: integer);
begin
  if (layer < 0) or (layer >= NbLayers) then
  begin
    Freeze;
    exit;
  end;
  Unfreeze(layer,layer);
  if layer > 1 then
    Freeze(0,layer-1);
  if layer < NbLayers-2 then
    Freeze(layer+1,NbLayers-1);
end;

procedure TBGRACustomLayeredBitmap.Freeze(firstLayer, lastLayer: integer);

  procedure DoFreeze(first,last: integer; linear: boolean);
  var i,nbVisible: integer;
    computedImage: TBGRABitmap;
  begin
    if last <= first then exit; //at least 2 frozen layers
    nbVisible := 0;
    for i := first to last do
      if LayerVisible[i] and (LayerOpacity[i] > 0) then nbVisible += 1;
    if nbvisible < 2 then exit;  //at least 2 frozen layers

    computedImage := ComputeFlatImage(first,last); //must compute before layers are considered as frozen
    setlength(FFrozenRange, length(FFrozenRange)+1);
    with FFrozenRange[high(FFrozenRange)] do
    begin
      firstLayer := first;
      lastLayer:= last;
      image := computedImage;
      linearBlend := linear;
    end;
    for i := first to last do
      SetLayerFrozen(i,True);
  end;

var i,j: integer;
  start: integer;
  linear,nextLinear: boolean;
begin
  for i := 0 to high(FFrozenRange) do
    if RangeIntersect(firstLayer,lastLayer,FFrozenRange[i].firstLayer,FFrozenRange[i].lastLayer) then
    begin
      if (FFrozenRange[i].firstLayer <> firstLayer) or (FFrozenRange[i].lastLayer <> lastLayer) then
      begin
        Unfreeze(firstLayer,lastLayer);
        break;
      end;
    end;
  start := -1;
  linear := false; //to avoid hint
  for j := firstlayer to lastLayer do
  if not LayerFrozen[j] and ((BlendOperation[j] in [boTransparent,boLinearBlend]) or (start= 0)) then
  begin
    nextLinear := (BlendOperation[j] = boLinearBlend) or self.LinearBlend;
    if start = -1 then
    begin
      start := j;
      linear := nextLinear;
    end else
    begin
      if linear <> nextLinear then
      begin
        DoFreeze(start,j-1,linear);
        start := j;
        linear := nextLinear;
      end;
    end;
  end else
  begin
    if start <> -1 then
    begin
      DoFreeze(start,j-1,linear);
      start := -1;
    end;
  end;
  if start <> -1 then
    DoFreeze(start,lastLayer,linear);
end;

procedure TBGRACustomLayeredBitmap.Freeze;
begin
  Freeze(0,NbLayers-1);
end;

procedure TBGRACustomLayeredBitmap.Unfreeze;
begin
  Unfreeze(0,NbLayers-1);
end;

procedure TBGRACustomLayeredBitmap.Unfreeze(layer: integer);
begin
  Unfreeze(layer,layer);
end;

procedure TBGRACustomLayeredBitmap.Unfreeze(firstLayer, lastLayer: integer);
var i: integer;
begin
  for i := high(FFrozenRange) downto 0 do
    if RangeIntersect(firstLayer,lastLayer,FFrozenRange[i].firstLayer,FFrozenRange[i].lastLayer) then
      RemoveFrozenRange(i);
end;

procedure RegisterLayeredBitmapReader(AExtension: string; AReader: TBGRACustomLayeredBitmapClass);
begin
  setlength(LayeredBitmapReaders,length(LayeredBitmapReaders)+1);
  with LayeredBitmapReaders[high(LayeredBitmapReaders)] do
  begin
    extension:= AExtension;
    theClass := AReader;
  end;
end;

procedure RegisterLayeredBitmapWriter(AExtension: string; AWriter: TBGRALayeredBitmapClass);
begin
  setlength(LayeredBitmapWriters,length(LayeredBitmapWriters)+1);
  with LayeredBitmapWriters[high(LayeredBitmapWriters)] do
  begin
    extension:= AExtension;
    theClass := AWriter;
  end;
end;

initialization

  NextLayerUniqueId := 1;

end.

