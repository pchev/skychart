unit BGRAScene3D;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, BGRABitmapTypes;

type
  TMatrix3D = array[1..3,1..4] of single;

  TProjection3D = record
    Zoom, Center: TPointF;
  end;

  TLightingNormal3D = (lnNone, lnFace, lnVertex, lnFaceVertexMix);
  TLightingInterpolation3D = (liGouraud, liPhong);

  { IBGRALight3D }

  IBGRALight3D = interface
    procedure ComputeLight(APosition: TPoint3D; ANormal: TPoint3D; out multiplyColor,addColor: TColorF; out lightness: single);
  end;

  IBGRAColorLight3D = interface(IBGRALight3D)
    function GetColor: TBGRAPixel;
    procedure SetColor(const AValue: TBGRAPixel);
    property Color: TBGRAPixel read GetColor write SetColor;
    function GetMinIntensity: single;
    procedure SetMinIntensity(const AValue: single);
    property MinIntensity: single read GetMinIntensity write SetMinIntensity;
  end;

  IBGRALightnessLight3D = interface(IBGRALight3D)
    function GetLightness: single;
    procedure SetLightness(const AValue: single);
    property Lightness: single read GetLightness write SetLightness;
    function GetMinLightness: single;
    procedure SetMinLightness(const AValue: single);
    property MinLightness: single read GetMinLightness write SetMinLightness;
  end;

  IBGRAPointColorLight3D = interface(IBGRAColorLight3D)
    function GetIntensity: single;
    procedure SetIntensity(const AValue: single);
    property Intensity: single read GetIntensity write SetIntensity;
  end;

  IBGRADirectionalLightnessLight3D = interface(IBGRALightnessLight3D)
    function GetDirection: TPoint3D;
    procedure SetDirection(const AValue: TPoint3D);
    property Direction: TPoint3D read GetDirection write SetDirection;
  end;

  IBGRADirectionalColorLight3D = interface(IBGRAColorLight3D)
    function GetDirection: TPoint3D;
    procedure SetDirection(const AValue: TPoint3D);
    property Direction: TPoint3D read GetDirection write SetDirection;
  end;

  IBGRAPhongLight3D = interface(IBGRAPointColorLight3D)
    function GetSpecularIndex: single;
    procedure SetSpecularIndex(const AValue: single);
    property SpecularIndex: single read GetSpecularIndex write SetSpecularIndex;

    function GetSpecularIntensity: single;
    procedure SetSpecularIntensity(const AValue: single);
    property SpecularIntensity: single read GetSpecularIntensity write SetSpecularIntensity;
  end;

  { IBGRAVertex3D }

  IBGRAVertex3D = interface
    function GetColor: TBGRAPixel;
    function GetLight: Single;
    function GetProjectedCoord: TPointF;
    function GetViewNormal: TPoint3D;
    function GetParentColor: Boolean;
    function GetSceneCoord: TPoint3D;
    function GetTexCoord: TPointF;
    function GetViewCoord: TPoint3D;
    procedure SetColor(const AValue: TBGRAPixel);
    procedure SetLight(const AValue: Single);
    procedure SetProjectedCoord(const AValue: TPointF);
    procedure SetViewNormal(const AValue: TPoint3D);
    procedure SetParentColor(const AValue: Boolean);
    procedure SetSceneCoord(const AValue: TPoint3D);
    procedure SetTexCoord(const AValue: TPointF);
    procedure SetViewCoord(const AValue: TPoint3D);
    property SceneCoord: TPoint3D read GetSceneCoord write SetSceneCoord;
    property ViewCoord: TPoint3D read GetViewCoord write SetViewCoord;
    property ProjectedCoord: TPointF read GetProjectedCoord write SetProjectedCoord;
    property TexCoord: TPointF read GetTexCoord write SetTexCoord;
    property Color: TBGRAPixel read GetColor write SetColor;
    property ParentColor: Boolean read GetParentColor write SetParentColor;
    property Light: Single read GetLight write SetLight;
    property ViewNormal: TPoint3D read GetViewNormal write SetViewNormal;
  end;

  arrayOfIBGRAVertex3D = array of IBGRAVertex3D;

  { IBGRAPart3D }

  IBGRAPart3D = interface
    function Add(x,y,z: single): IBGRAVertex3D;
    function Add(pt: TPoint3D): IBGRAVertex3D;
    function Add(const coords: array of single): arrayOfIBGRAVertex3D;
    function Add(const pts: array of TPoint3D): arrayOfIBGRAVertex3D;
    procedure Add(const pts: array of IBGRAVertex3D);
    function GetMatrix: TMatrix3D;
    function GetPart(AIndex: Integer): IBGRAPart3D;
    function GetPartCount: integer;
    function GetVertex(AIndex: Integer): IBGRAVertex3D;
    function GetVertexCount: integer;
    procedure ResetTransform;
    procedure Scale(size: single);
    procedure Scale(x,y,z: single);
    procedure Scale(size: TPoint3D);
    procedure SetMatrix(const AValue: TMatrix3D);
    procedure Translate(x,y,z: single);
    procedure Translate(ofs: TPoint3D);
    procedure RotateXDeg(angle: single);
    procedure RotateYDeg(angle: single);
    procedure RotateZDeg(angle: single);
    procedure RotateXRad(angle: single);
    procedure RotateYRad(angle: single);
    procedure RotateZRad(angle: single);
    procedure ComputeWithMatrix(const AMatrix: TMatrix3D; const AProjection: TProjection3D);
    procedure NormalizeViewNormal;
    function CreatePart: IBGRAPart3D;
    property VertexCount: integer read GetVertexCount;
    property Vertex[AIndex: Integer]: IBGRAVertex3D read GetVertex;
    property Matrix: TMatrix3D read GetMatrix write SetMatrix;
    property PartCount: integer read GetPartCount;
    property Part[AIndex: Integer]: IBGRAPart3D read GetPart;
  end;

  IBGRAObject3D = interface;

  { IBGRAFace3D }

  IBGRAFace3D = interface
    procedure AddVertex(AVertex: IBGRAVertex3D);
    function GetBiface: boolean;
    function GetObject3D: IBGRAObject3D;
    function GetParentTexture: boolean;
    function GetTexCoord(AIndex: Integer): TPointF;
    function GetTexCoordOverride(AIndex: Integer): boolean;
    function GetTexture: IBGRAScanner;
    function GetVertex(AIndex: Integer): IBGRAVertex3D;
    function GetVertexColor(AIndex: Integer): TBGRAPixel;
    function GetVertexColorOverride(AIndex: Integer): boolean;
    function GetVertexCount: integer;
    function GetViewCenter: TPoint3D;
    function GetViewNormal: TPoint3D;
    procedure SetBiface(const AValue: boolean);
    procedure SetParentTexture(const AValue: boolean);
    procedure SetTexCoord(AIndex: Integer; const AValue: TPointF);
    procedure SetTexCoordOverride(AIndex: Integer; const AValue: boolean);
    procedure SetTexture(const AValue: IBGRAScanner);
    procedure SetVertexColor(AIndex: Integer; const AValue: TBGRAPixel);
    procedure SetVertexColorOverride(AIndex: Integer; const AValue: boolean);
    procedure ComputeViewNormalAndCenter;
    property Texture: IBGRAScanner read GetTexture write SetTexture;
    property ParentTexture: boolean read GetParentTexture write SetParentTexture;
    property VertexCount: integer read GetVertexCount;
    property Vertex[AIndex: Integer]: IBGRAVertex3D read GetVertex;
    property VertexColor[AIndex: Integer]: TBGRAPixel read GetVertexColor write SetVertexColor;
    property VertexColorOverride[AIndex: Integer]: boolean read GetVertexColorOverride write SetVertexColorOverride;
    property TexCoord[AIndex: Integer]: TPointF read GetTexCoord write SetTexCoord;
    property TexCoordOverride[AIndex: Integer]: boolean read GetTexCoordOverride write SetTexCoordOverride;
    property ViewNormal: TPoint3D read GetViewNormal;
    property ViewCenter: TPoint3D read GetViewCenter;
    property Object3D: IBGRAObject3D read GetObject3D;
    property Biface: boolean read GetBiface write SetBiface;
  end;

  { IBGRAObject3D }

  IBGRAObject3D = interface
    function GetColor: TBGRAPixel;
    function GetFace(AIndex: integer): IBGRAFace3D;
    function GetFaceCount: integer;
    function GetLight: Single;
    function GetLightingNormal: TLightingNormal3D;
    function GetParentLighting: boolean;
    function GetTexture: IBGRAScanner;
    function GetVertices: IBGRAPart3D;
    procedure SetColor(const AValue: TBGRAPixel);
    procedure SetLight(const AValue: Single);
    procedure SetLightingNormal(const AValue: TLightingNormal3D);
    procedure SetParentLighting(const AValue: boolean);
    procedure SetTexture(const AValue: IBGRAScanner);
    procedure ComputeWithMatrix(const AMatrix: TMatrix3D; const AProjection: TProjection3D);
    function AddFaceReversed(const AVertices: array of IBGRAVertex3D): IBGRAFace3D;
    function AddFace(const AVertices: array of IBGRAVertex3D): IBGRAFace3D;
    function AddFace(const AVertices: array of IBGRAVertex3D; ABiface: boolean): IBGRAFace3D;
    function AddFace(const AVertices: array of IBGRAVertex3D; ATexture: IBGRAScanner): IBGRAFace3D;
    function AddFace(const AVertices: array of IBGRAVertex3D; AColor: TBGRAPixel): IBGRAFace3D;
    function AddFace(const AVertices: array of IBGRAVertex3D; AColors: array of TBGRAPixel): IBGRAFace3D;
    property Vertices: IBGRAPart3D read GetVertices;
    property Texture: IBGRAScanner read GetTexture write SetTexture;
    property Light: Single read GetLight write SetLight;
    property Color: TBGRAPixel read GetColor write SetColor;
    property Face[AIndex: integer]: IBGRAFace3D read GetFace;
    property FaceCount: integer read GetFaceCount;
    property LightingNormal: TLightingNormal3D read GetLightingNormal write SetLightingNormal;
    property ParentLighting: boolean read GetParentLighting write SetParentLighting;
  end;

  TBGRAScene3D = class;

  { TBGRAScene3D }

  TBGRAScene3D = class
  private
    FSurface: TBGRACustomBitmap;
    FViewCenter: TPointF;
    FAutoViewCenter: boolean;
    FObjects: array of IBGRAObject3D;
    FObjectCount: integer;
    FMatrix: TMatrix3D;
    FLookWhere, FTopDir: TPoint3D;
    FZoom: TPointF;
    FAutoZoom: Boolean;
    FLights: TList;
    FAmbiantLightness: single;
    FAmbiantLightColor: TColorF;
    function GetAmbiantLightness: single;
    function GetAmbiantLightColor: TBGRAPixel;
    function GetObject(AIndex: integer): IBGRAObject3D;
    function GetViewCenter: TPointF;
    function GetZoom: TPointF;
    procedure SetAmbiantLightness(const AValue: single);
    procedure SetAmbiantLightColor(const AValue: TBGRAPixel);
    procedure SetAutoViewCenter(const AValue: boolean);
    procedure SetAutoZoom(const AValue: boolean);
    procedure SetViewCenter(const AValue: TPointF);
    procedure ComputeView;
    procedure ComputeLight;
    procedure ComputeMatrix;
    procedure AddObject(AObj: IBGRAObject3D);
    procedure Init;
    function ApplyLighting(APosition,ANormal: TPoint3D; Color: TBGRAPixel): TBGRAPixel;

  public
    ViewPoint: TPoint3D;
    TextureInterpolation, PerspectiveMapping, Antialiasing: boolean;
    LightingNormal: TLightingNormal3D;
    LightingInterpolation: TLightingInterpolation3D;
    constructor Create;
    constructor Create(ASurface: TBGRACustomBitmap);
    destructor Destroy; override;
    procedure LookAt(AWhere: TPoint3D; ATopDir: TPoint3D);
    procedure Render; virtual;
    function CreateObject: IBGRAObject3D; overload;
    function CreateObject(ATexture: IBGRAScanner): IBGRAObject3D; overload;
    function CreateObject(AColor: TBGRAPixel): IBGRAObject3D; overload;
    procedure RemoveObject(AObject: IBGRAObject3D);
    function AddDirectionalLight(ADirection: TPoint3D; ALightness: single = 1; AMinLightness : single = 0): IBGRADirectionalLightnessLight3D;
    function AddPointLight(AVertex: IBGRAVertex3D; AOptimalDistance: single; ALightness: single = 1; AMinLightness : single = 0): IBGRALightnessLight3D;
    function AddDirectionalLight(ADirection: TPoint3D; AColor: TBGRAPixel; AMinIntensity : single = 0): IBGRADirectionalColorLight3D;
    function AddPointLight(AVertex: IBGRAVertex3D; AOptimalDistance: single; AColor: TBGRAPixel; AMinIntensity : single = 0): IBGRAPointColorLight3D;
    function AddPhongLight(AVertex: IBGRAVertex3D; AOptimalDistance: single; AColor: TBGRAPixel; AMinIntensity : single = 0; ASpecularIndex: single = 9; ASpecularIntensity: single = 2): IBGRAPhongLight3D;
    procedure RemoveLight(ALight: IBGRALight3D);
    procedure SetZoom(value: Single); overload;
    procedure SetZoom(value: TPointF); overload;
    property ViewCenter: TPointF read GetViewCenter write SetViewCenter;
    property AutoViewCenter: boolean read FAutoViewCenter write SetAutoViewCenter;
    property AutoZoom: boolean read FAutoZoom write SetAutoZoom;
    property Surface: TBGRACustomBitmap read FSurface write FSurface;
    property Object3D[AIndex: integer]: IBGRAObject3D read GetObject;
    property Object3DCount: integer read FObjectCount;
    property Zoom: TPointF read GetZoom write SetZoom;
    property AmbiantLightness: single read GetAmbiantLightness write SetAmbiantLightness;
    property AmbiantLight: TBGRAPixel read GetAmbiantLightColor write SetAmbiantLightColor;
  end;

operator*(const A: TMatrix3D; const M: TPoint3D): TPoint3D;
operator*(A,B: TMatrix3D): TMatrix3D;

function MatrixIdentity3D: TMatrix3D;
function Matrix3D(m11,m12,m13,m14, m21,m22,m23,m24, m31,m32,m33,m34: single): TMatrix3D;
function MatrixInverse3D(A: TMatrix3D): TMatrix3D;
function Matrix3D(vx,vy,vz,ofs: TPoint3D): TMatrix3D;
function MatrixTranslation3D(ofs: TPoint3D): TMatrix3D;
function MatrixScale3D(size: TPoint3D): TMatrix3D;
function MatrixRotateX(angle: single): TMatrix3D;
function MatrixRotateY(angle: single): TMatrix3D;
function MatrixRotateZ(angle: single): TMatrix3D;

implementation

uses BGRAPolygon, BGRAPolygonAliased;

type

  { TBGRAColorLight3D }

  TBGRAColorLight3D = class(TInterfacedObject,IBGRAColorLight3D)
  protected
    FMinIntensity: single;
    FColorF: TColorF;
  public
    constructor Create;
    function GetColor: TBGRAPixel;
    procedure SetColor(const AValue: TBGRAPixel);
    function GetMinIntensity: single;
    procedure SetMinIntensity(const AValue: single);
    procedure ComputeLight(APosition: TPoint3D; ANormal: TPoint3D; out multiplyColor,addColor: TColorF; out lightness: single); virtual; abstract;
  end;

  { TBGRALightnessLight3D }

  TBGRALightnessLight3D = class(TInterfacedObject,IBGRALightnessLight3D)
  protected
    FMinLightness: single;
    FLightness: single;
  public
    constructor Create;
    function GetLightness: single;
    procedure SetLightness(const AValue: single);
    function GetMinLightness: single;
    procedure SetMinLightness(const AValue: single);
    procedure ComputeLight(APosition: TPoint3D; ANormal: TPoint3D; out multiplyColor,addColor: TColorF; out lightness: single); virtual; abstract;
  end;

  { TBGRADirectionalLightnessLight3D }

  TBGRADirectionalLightnessLight3D = class(TBGRALightnessLight3D,IBGRADirectionalLightnessLight3D)
  protected
    FDirection: TPoint3D;
  public
    constructor Create(ADirection: TPoint3D);
    function GetDirection: TPoint3D;
    procedure SetDirection(const AValue: TPoint3D);
    procedure ComputeLight(APosition: TPoint3D; ANormal: TPoint3D; out multiplyColor,addColor: TColorF; out lightness: single); override;
  end;

  { TBGRADirectionalColorLight3D }

  TBGRADirectionalColorLight3D = class(TBGRAColorLight3D,IBGRADirectionalColorLight3D)
  protected
    FDirection: TPoint3D;
  public
    constructor Create(ADirection: TPoint3D);
    function GetDirection: TPoint3D;
    procedure SetDirection(const AValue: TPoint3D);
    procedure ComputeLight(APosition: TPoint3D; ANormal: TPoint3D; out multiplyColor,addColor: TColorF; out lightness: single); override;
  end;

  { TBGRAPointColorLight3D }

  TBGRAPointColorLight3D = class(TBGRAColorLight3D,IBGRAPointColorLight3D)
  protected
    FVertex: IBGRAVertex3D;
    FIntensity: single;
  public
    constructor Create(AVertex: IBGRAVertex3D; AIntensity: single);
    procedure ComputeLight(APosition: TPoint3D; ANormal: TPoint3D; out multiplyColor,addColor: TColorF; out lightness: single); override;
    function GetIntensity: single;
    procedure SetIntensity(const AValue: single);
  end;

  { TBGRAPointLightnessLight3D }

  TBGRAPointLightnessLight3D = class(TBGRALightnessLight3D)
  protected
    FVertex: IBGRAVertex3D;
  public
    constructor Create(AVertex: IBGRAVertex3D; ALightness: single);
    procedure ComputeLight(APosition: TPoint3D; ANormal: TPoint3D; out multiplyColor,addColor: TColorF; out lightness: single); override;
  end;

  { TBGRAPhongLight3D }

  TBGRAPhongLight3D = class(TBGRAPointColorLight3D,IBGRAPhongLight3D)
  protected
    FSpecularIndex, FSpecularIntensity: single;
    FViewVector : TPoint3D;
  public
    constructor Create(AVertex: IBGRAVertex3D; AIntensity: Single; ASpecularIndex: single);

    function GetSpecularIndex: single;
    procedure SetSpecularIndex(const AValue: single);

    function GetSpecularIntensity: single;
    procedure SetSpecularIntensity(const AValue: single);

    procedure ComputeLight(APosition: TPoint3D; ANormal: TPoint3D; out multiplyColor,addColor: TColorF; out lightness: single); override;
  end;

  { TBGRAObject3D }

  TBGRAObject3D = class(TInterfacedObject,IBGRAObject3D)
  private
    FColor: TBGRAPixel;
    FLight: Single;
    FTexture: IBGRAScanner;
    FVertices: IBGRAPart3D;
    FFaces: array of IBGRAFace3D;
    FFaceCount: integer;
    FLightingNormal : TLightingNormal3D;
    FParentLighting: boolean;
    procedure AddFace(AFace: IBGRAFace3D);
  public
    constructor Create(AScene: TBGRAScene3D);
    destructor Destroy; override;
    function GetColor: TBGRAPixel;
    function GetLight: Single;
    function GetTexture: IBGRAScanner;
    function GetVertices: IBGRAPart3D;
    procedure SetColor(const AValue: TBGRAPixel);
    procedure SetLight(const AValue: Single);
    procedure SetTexture(const AValue: IBGRAScanner);
    function GetLightingNormal: TLightingNormal3D;
    function GetParentLighting: boolean;
    procedure SetLightingNormal(const AValue: TLightingNormal3D);
    procedure SetParentLighting(const AValue: boolean);
    procedure ComputeWithMatrix(const AMatrix: TMatrix3D; const AProjection: TProjection3D);
    function AddFaceReversed(const AVertices: array of IBGRAVertex3D): IBGRAFace3D;
    function AddFace(const AVertices: array of IBGRAVertex3D): IBGRAFace3D;
    function AddFace(const AVertices: array of IBGRAVertex3D; ABiface: boolean): IBGRAFace3D;
    function AddFace(const AVertices: array of IBGRAVertex3D; ATexture: IBGRAScanner): IBGRAFace3D;
    function AddFace(const AVertices: array of IBGRAVertex3D; AColor: TBGRAPixel): IBGRAFace3D;
    function AddFace(const AVertices: array of IBGRAVertex3D; AColors: array of TBGRAPixel): IBGRAFace3D;
    function GetFace(AIndex: integer): IBGRAFace3D;
    function GetFaceCount: integer;
  end;

  { TBGRAPart3D }

  TBGRAPart3D = class(TInterfacedObject,IBGRAPart3D)
  private
    FVertices: array of IBGRAVertex3D;
    FVertexCount: integer;
    FMatrix: TMatrix3D;
    FParts: array of IBGRAPart3D;
    FPartCount: integer;
    procedure Add(AVertex: IBGRAVertex3D);
  public
    constructor Create;
    function Add(x,y,z: single): IBGRAVertex3D;
    function Add(pt: TPoint3D): IBGRAVertex3D;
    function Add(const coords: array of single): arrayOfIBGRAVertex3D;
    function Add(const pts: array of TPoint3D): arrayOfIBGRAVertex3D;
    procedure Add(const pts: array of IBGRAVertex3D);
    function GetMatrix: TMatrix3D;
    function GetPart(AIndex: Integer): IBGRAPart3D;
    function GetPartCount: integer;
    function GetVertex(AIndex: Integer): IBGRAVertex3D;
    function GetVertexCount: integer;
    procedure ResetTransform;
    procedure Translate(x,y,z: single);
    procedure Translate(ofs: TPoint3D);
    procedure Scale(size: single);
    procedure Scale(x,y,z: single);
    procedure Scale(size: TPoint3D);
    procedure RotateXDeg(angle: single);
    procedure RotateYDeg(angle: single);
    procedure RotateZDeg(angle: single);
    procedure RotateXRad(angle: single);
    procedure RotateYRad(angle: single);
    procedure RotateZRad(angle: single);
    procedure SetMatrix(const AValue: TMatrix3D);
    procedure ComputeWithMatrix(const AMatrix: TMatrix3D; const AProjection: TProjection3D);
    procedure NormalizeViewNormal;
    function CreatePart: IBGRAPart3D;
  end;

  { TBGRAFace3D }

  TBGRAFace3D = class(TInterfacedObject,IBGRAFace3D)
  private
    FVertices: array of record
                 Vertex: IBGRAVertex3D;
                 Color: TBGRAPixel;
                 ColorOverride: boolean;
                 TexCoord: TPointF;
                 TexCoordOverride: boolean;
               end;
    FVertexCount: integer;
    FTexture: IBGRAScanner;
    FParentTexture: boolean;
    FViewNormal: TPoint3D;
    FViewCenter: TPoint3D;
    FObject3D : IBGRAObject3D;
    FBiface: boolean;
  public
    function GetObject3D: IBGRAObject3D;
    constructor Create(AObject3D: IBGRAObject3D; AVertices: array of IBGRAVertex3D);
    destructor Destroy; override;
    procedure AddVertex(AVertex: IBGRAVertex3D);
    function GetParentTexture: boolean;
    function GetTexture: IBGRAScanner;
    function GetVertex(AIndex: Integer): IBGRAVertex3D;
    function GetVertexColor(AIndex: Integer): TBGRAPixel;
    function GetVertexColorOverride(AIndex: Integer): boolean;
    function GetVertexCount: integer;
    procedure SetParentTexture(const AValue: boolean);
    procedure SetTexture(const AValue: IBGRAScanner);
    procedure SetVertexColor(AIndex: Integer; const AValue: TBGRAPixel);
    procedure SetVertexColorOverride(AIndex: Integer; const AValue: boolean);
    function GetTexCoord(AIndex: Integer): TPointF;
    function GetTexCoordOverride(AIndex: Integer): boolean;
    procedure SetTexCoord(AIndex: Integer; const AValue: TPointF);
    procedure SetTexCoordOverride(AIndex: Integer; const AValue: boolean);
    function GetViewNormal: TPoint3D;
    function GetViewCenter: TPoint3D;
    function GetBiface: boolean;
    procedure SetBiface(const AValue: boolean);
    procedure ComputeViewNormalAndCenter;
  end;

  { TBGRAVertex3D }

  TBGRAVertex3D = class(TInterfacedObject,IBGRAVertex3D)
  private
    FColor: TBGRAPixel;
    FParentColor: boolean;
    FLight: Single;
    FViewNormal: TPoint3D;
    FSceneCoord: TPoint3D;
    FTexCoord: TPointF;
    FViewCoord: TPoint3D;
    FProjectedCoord: TPointF;
  public
    constructor Create(ASceneCoord: TPoint3D);
    function GetColor: TBGRAPixel;
    function GetLight: Single;
    function GetViewNormal: TPoint3D;
    function GetSceneCoord: TPoint3D;
    function GetTexCoord: TPointF;
    function GetViewCoord: TPoint3D;
    procedure SetColor(const AValue: TBGRAPixel);
    procedure SetLight(const AValue: Single);
    procedure SetViewNormal(const AValue: TPoint3D);
    procedure SetSceneCoord(const AValue: TPoint3D);
    procedure SetTexCoord(const AValue: TPointF);
    procedure SetViewCoord(const AValue: TPoint3D);
    function GetParentColor: Boolean;
    procedure SetParentColor(const AValue: Boolean);
    function GetProjectedCoord: TPointF;
    procedure SetProjectedCoord(const AValue: TPointF);
  end;

const oneOver255 = 1/255;

function BGRAToColorF(AColor: TBGRAPixel): TColorF;
begin
  result[1] := AColor.red*oneOver255;
  result[2] := AColor.green*oneOver255;
  result[3] := AColor.blue*oneOver255;
  result[4] := AColor.alpha*oneOver255;
end;

function ColorFToBGRA(AColor: TColorF): TBGRAPixel;
begin
  if AColor[1] < 0 then result.red := 0 else
  if AColor[1] > 1 then result.red := 255 else
    result.red := round(AColor[1]*255);

  if AColor[2] < 0 then result.green := 0 else
  if AColor[2] > 1 then result.green := 255 else
    result.green := round(AColor[2]*255);

  if AColor[3] < 0 then result.blue := 0 else
  if AColor[3] > 1 then result.blue := 255 else
    result.blue := round(AColor[3]*255);

  if AColor[4] < 0 then result.alpha := 0 else
  if AColor[4] > 1 then result.alpha := 255 else
    result.alpha := round(AColor[4]*255);
end;

procedure multiplyVectInline(const A : TMatrix3D; const vx,vy,vz,vt: single; out outx,outy,outz: single);
begin
  outx := vx * A[1,1] + vy * A[1,2] + vz * A[1,3] + vt * A[1,4];
  outy := vx * A[2,1] + vy * A[2,2] + vz * A[2,3] + vt * A[2,4];
  outz := vx * A[3,1] + vy * A[3,2] + vz * A[3,3] + vt * A[3,4];
end;

operator*(const A: TMatrix3D; const M: TPoint3D): TPoint3D;
begin
  multiplyVectInline(A, M.x,M.y,M.z,1, result.x,result.y,result.z);
end;

operator*(A,B: TMatrix3D): TMatrix3D;
begin
  multiplyVectInline(A, B[1,1],B[2,1],B[3,1],0, result[1,1],result[2,1],result[3,1]);
  multiplyVectInline(A, B[1,2],B[2,2],B[3,2],0, result[1,2],result[2,2],result[3,2]);
  multiplyVectInline(A, B[1,3],B[2,3],B[3,3],0, result[1,3],result[2,3],result[3,3]);
  multiplyVectInline(A, B[1,4],B[2,4],B[3,4],1, result[1,4],result[2,4],result[3,4]);
end;

function MatrixIdentity3D: TMatrix3D;
begin
  result := Matrix3D( 1,0,0,0,
                      0,1,0,0,
                      0,0,1,0);
end;

function Matrix3D(m11, m12, m13, m14, m21, m22, m23, m24, m31, m32, m33,
  m34: single): TMatrix3D;
begin
  result[1,1] := m11;
  result[1,2] := m12;
  result[1,3] := m13;
  result[1,4] := m14;

  result[2,1] := m21;
  result[2,2] := m22;
  result[2,3] := m23;
  result[2,4] := m24;

  result[3,1] := m31;
  result[3,2] := m32;
  result[3,3] := m33;
  result[3,4] := m34;
end;

function MatrixInverse3D(A: TMatrix3D): TMatrix3D;
var ofs: TPoint3D;
begin
  ofs := Point3D(A[1,4],A[2,4],A[3,4]);

  result[1,1] := A[1,1];
  result[1,2] := A[2,1];
  result[1,3] := A[3,1];
  result[1,4] := 0;

  result[2,1] := A[1,2];
  result[2,2] := A[2,2];
  result[2,3] := A[3,2];
  result[2,4] := 0;

  result[3,1] := A[1,3];
  result[3,2] := A[2,3];
  result[3,3] := A[3,3];
  result[3,4] := 0;

  result := result*MatrixTranslation3D(-ofs);
end;

function Matrix3D(vx, vy, vz, ofs: TPoint3D): TMatrix3D;
begin
  result := Matrix3D(vx.x, vy.x, vz.x, ofs.x,
                     vx.y, vy.y, vz.y, ofs.y,
                     vx.z, vy.z, vz.z, ofs.z);
end;

function MatrixTranslation3D(ofs: TPoint3D): TMatrix3D;
begin
  result := Matrix3D(1,0,0,ofs.x,
                     0,1,0,ofs.Y,
                     0,0,1,ofs.z);
end;

function MatrixScale3D(size: TPoint3D): TMatrix3D;
begin
  result := Matrix3D(size.x,0,0,0,
                     0,size.y,0,0,
                     0,0,size.z,0);
end;

function MatrixRotateX(angle: single): TMatrix3D;
begin
  result := Matrix3D( 1,       0,           0,       0,
                      0,   cos(angle), sin(angle),   0,
                      0,  -sin(angle), cos(angle),   0);
end;

function MatrixRotateY(angle: single): TMatrix3D;
begin
  result := Matrix3D(  cos(angle), 0, -sin(angle),  0,
                           0,      1,      0,       0,
                       sin(angle), 0,  cos(angle),  0);
end;

function MatrixRotateZ(angle: single): TMatrix3D;
begin
  result := Matrix3D(  cos(angle), sin(angle),   0,    0,
                      -sin(angle), cos(angle),   0,    0,
                          0,            0,       1,    0);
end;

{ TBGRAPhongLight3D }

constructor TBGRAPhongLight3D.Create(AVertex: IBGRAVertex3D; AIntensity: Single; ASpecularIndex: single);
begin
  inherited Create(AVertex, AIntensity);
  FViewVector := Point3D(0,0,-1);
  SetSpecularIndex(ASpecularIndex);
  SetSpecularIntensity(1);
end;

function TBGRAPhongLight3D.GetSpecularIndex: single;
begin
  result := FSpecularIndex;
end;

procedure TBGRAPhongLight3D.SetSpecularIndex(const AValue: single);
begin
  FSpecularIndex:= AValue;
end;

function TBGRAPhongLight3D.GetSpecularIntensity: single;
begin
  result := FSpecularIntensity;
end;

procedure TBGRAPhongLight3D.SetSpecularIntensity(const AValue: single);
begin
  FSpecularIntensity := AValue;
end;

procedure TBGRAPhongLight3D.ComputeLight(APosition: TPoint3D;
  ANormal: TPoint3D; out multiplyColor, addColor: TColorF; out lightness: single
  );
var vL,vD,vLS, vH: TPoint3D;
  dist2,distfactor,LdotN,NH,NnH,value: single;
begin
  vLS := FVertex.ViewCoord;
  vD := vLS- APosition;
  dist2 := vD*vD;
  vL := vD;
  Normalize3D(vL);

  //compute bisector of angle between light and observer
  vH := vL + FViewVector;
  Normalize3D(vH);

  //Calculate LdotN and NnH
  LdotN := ANormal * vL;

  NH := vH * ANormal;
  if NH <= 0 then
    NnH := 0
  else
    NnH := exp(FSpecularIndex*ln(NH));

  if dist2 = 0 then
    distfactor := 0
  else
    distfactor := FIntensity / dist2;

  value := distfactor* LdotN;
  if value < FMinIntensity then value := FMinIntensity;
  multiplyColor := FColorF*value;

  value := distfactor* NnH * FSpecularIntensity;
  addColor := FColorF*value;

  lightness := 0;
end;

{ TBGRAPointLightnessLight3D }

constructor TBGRAPointLightnessLight3D.Create(AVertex: IBGRAVertex3D;
  ALightness: single);
begin
  inherited Create;
  FVertex := AVertex;
  FLightness := ALightness;
end;

procedure TBGRAPointLightnessLight3D.ComputeLight(APosition: TPoint3D;
  ANormal: TPoint3D; out multiplyColor, addColor: TColorF; out lightness: single
  );
var
  vect: TPoint3D;
  dist2: single;
begin
  vect := FVertex.ViewCoord - APosition;
  dist2 := vect*vect;
  if dist2 = 0 then
    lightness := 100
  else
  begin
    lightness := (vect * ANormal)/(dist2*sqrt(dist2))*FLightness;
    if lightness > 100 then lightness := 100;
    if lightness < FMinLightness then lightness := FMinLightness;
  end;
  multiplyColor := ColorF(0,0,0,1);
  addColor := ColorF(0,0,0,1);
end;

{ TBGRAPointColorLight3D }

constructor TBGRAPointColorLight3D.Create(AVertex: IBGRAVertex3D; AIntensity: single
  );
begin
  inherited Create;
  FVertex := AVertex;
  FIntensity := AIntensity;
end;

procedure TBGRAPointColorLight3D.ComputeLight(APosition: TPoint3D;
  ANormal: TPoint3D; out multiplyColor, addColor: TColorF; out lightness: single
  );
var
  vect: TPoint3D;
  intensity,dist2: single;
begin
  vect := FVertex.ViewCoord - APosition;
  dist2 := vect*vect;
  if dist2 = 0 then
    intensity := 100
  else
  begin
    intensity := (vect * ANormal)/(dist2*sqrt(dist2))*FIntensity;
    if intensity > 100 then intensity := 100;
    if intensity < FMinIntensity then intensity := FMinIntensity;
  end;
  multiplyColor := FColorF * intensity;
  addColor := ColorF(0,0,0,1);
  lightness := 0;
end;

function TBGRAPointColorLight3D.GetIntensity: single;
begin
  result := FIntensity;
end;

procedure TBGRAPointColorLight3D.SetIntensity(const AValue: single);
begin
  FIntensity:= AValue;
end;

{ TBGRADirectionalColorLight3D }

constructor TBGRADirectionalColorLight3D.Create(ADirection: TPoint3D);
begin
  inherited Create;
  SetDirection(ADirection);
end;

function TBGRADirectionalColorLight3D.GetDirection: TPoint3D;
begin
  result := FDirection;
end;

procedure TBGRADirectionalColorLight3D.SetDirection(const AValue: TPoint3D);
begin
  FDirection := AValue;
  Normalize3D(FDirection);
end;

{$hints off}
procedure TBGRADirectionalColorLight3D.ComputeLight(APosition: TPoint3D;
  ANormal: TPoint3D; out multiplyColor, addColor: TColorF; out lightness: single
  );
var
  intensity: single;
begin
  intensity:= -ANormal * FDirection;
  if intensity < FMinIntensity then intensity := FMinIntensity;
  multiplyColor := FColorF*intensity;
  addColor := ColorF(0,0,0,1);
  lightness := 0;
end;
{$hints on}

{ TBGRADirectionalLightnessLight3D }

constructor TBGRADirectionalLightnessLight3D.Create(ADirection: TPoint3D);
begin
  inherited Create;
  SetDirection(ADirection);
end;

function TBGRADirectionalLightnessLight3D.GetDirection: TPoint3D;
begin
  result := FDirection;
end;

procedure TBGRADirectionalLightnessLight3D.SetDirection(const AValue: TPoint3D
  );
begin
  FDirection := AValue;
  Normalize3D(FDirection);
end;

{$hints off}
procedure TBGRADirectionalLightnessLight3D.ComputeLight(APosition: TPoint3D;
  ANormal: TPoint3D; out multiplyColor, addColor: TColorF; out lightness: single
  );
begin
  lightness:= -(ANormal * FDirection)*FLightness;
  if lightness < FMinLightness then lightness := FMinLightness;
  multiplyColor := ColorF(0,0,0,1);
  addColor := ColorF(0,0,0,1);
end;
{$hints on}

{ TBGRALightnessLight3D }

constructor TBGRALightnessLight3D.Create;
begin
  SetMinLightness(0);
  SetLightness(1);
end;

function TBGRALightnessLight3D.GetLightness: single;
begin
  result := FLightness;
end;

procedure TBGRALightnessLight3D.SetLightness(const AValue: single);
begin
  FLightness := AValue;
end;

function TBGRALightnessLight3D.GetMinLightness: single;
begin
  result := FMinLightness;
end;

procedure TBGRALightnessLight3D.SetMinLightness(const AValue: single);
begin
  FMinLightness:= AValue;
end;

{ TBGRAColorLight3D }

constructor TBGRAColorLight3D.Create;
begin
  SetMinIntensity(0);
  SetColor(BGRAWhite);
end;

function TBGRAColorLight3D.GetColor: TBGRAPixel;
begin
  result := ColorFToBGRA(FColorF);
end;

procedure TBGRAColorLight3D.SetColor(const AValue: TBGRAPixel);
begin
  FColorF := BGRAToColorF(AValue);
end;

function TBGRAColorLight3D.GetMinIntensity: single;
begin
  result := FMinIntensity;
end;

procedure TBGRAColorLight3D.SetMinIntensity(const AValue: single);
begin
  FMinIntensity:= AValue;
end;

{ TBGRAVertex3D }

constructor TBGRAVertex3D.Create(ASceneCoord: TPoint3D);
begin
  FColor := BGRAWhite;
  FParentColor := True;
  FLight := 1;
  FSceneCoord := ASceneCoord;
end;

function TBGRAVertex3D.GetColor: TBGRAPixel;
begin
  result := FColor;
end;

function TBGRAVertex3D.GetLight: Single;
begin
  result := FLight;
end;

function TBGRAVertex3D.GetViewNormal: TPoint3D;
begin
  result := FViewNormal;
end;

function TBGRAVertex3D.GetSceneCoord: TPoint3D;
begin
  result := FSceneCoord;
end;

function TBGRAVertex3D.GetTexCoord: TPointF;
begin
  result := FTexCoord;
end;

function TBGRAVertex3D.GetViewCoord: TPoint3D;
begin
  result := FViewCoord;
end;

procedure TBGRAVertex3D.SetColor(const AValue: TBGRAPixel);
begin
  FColor := AValue;
  FParentColor := false;
end;

procedure TBGRAVertex3D.SetLight(const AValue: Single);
begin
  FLight := AValue;
end;

procedure TBGRAVertex3D.SetViewNormal(const AValue: TPoint3D);
begin
  FViewNormal := AValue;
end;

procedure TBGRAVertex3D.SetSceneCoord(const AValue: TPoint3D);
begin
  FSceneCoord := AValue;
end;

procedure TBGRAVertex3D.SetTexCoord(const AValue: TPointF);
begin
  FTexCoord := AValue;
end;

procedure TBGRAVertex3D.SetViewCoord(const AValue: TPoint3D);
begin
  FViewCoord := AValue;
end;

function TBGRAVertex3D.GetParentColor: Boolean;
begin
  result := FParentColor;
end;

procedure TBGRAVertex3D.SetParentColor(const AValue: Boolean);
begin
  FParentColor := AValue;
end;

function TBGRAVertex3D.GetProjectedCoord: TPointF;
begin
  result := FProjectedCoord;
end;

procedure TBGRAVertex3D.SetProjectedCoord(const AValue: TPointF);
begin
  FProjectedCoord := AValue;
end;

{ TBGRAFace3D }

function TBGRAFace3D.GetObject3D: IBGRAObject3D;
begin
  result := FObject3D;
end;

constructor TBGRAFace3D.Create(AObject3D: IBGRAObject3D;
  AVertices: array of IBGRAVertex3D);
var
  i: Integer;
begin
  SetLength(FVertices, length(AVertices));
  for i:= 0 to high(AVertices) do
    AddVertex(AVertices[i]);
  FObject3D := AObject3D;
  FBiface := false;
  FParentTexture := True;
end;

destructor TBGRAFace3D.Destroy;
begin
  fillchar(FTexture,sizeof(FTexture),0);
  inherited Destroy;
end;

procedure TBGRAFace3D.AddVertex(AVertex: IBGRAVertex3D);
begin
  if FVertexCount = length(FVertices) then
    setlength(FVertices, FVertexCount*2+3);
  with FVertices[FVertexCount] do
  begin
    Color := BGRAWhite;
    ColorOverride := false;
    TexCoord := PointF(0,0);
    TexCoordOverride := false;
    Vertex := AVertex;
  end;
  inc(FVertexCount);
end;

function TBGRAFace3D.GetParentTexture: boolean;
begin
  result := FParentTexture;
end;

function TBGRAFace3D.GetTexture: IBGRAScanner;
begin
  result := FTexture;
end;

function TBGRAFace3D.GetVertex(AIndex: Integer): IBGRAVertex3D;
begin
  if (AIndex < 0) or (AIndex >= FVertexCount) then
    raise Exception.Create('Index out of bounds');
  result := FVertices[AIndex].Vertex;
end;

function TBGRAFace3D.GetVertexColor(AIndex: Integer): TBGRAPixel;
begin
  if (AIndex < 0) or (AIndex >= FVertexCount) then
    raise Exception.Create('Index out of bounds');
  result := FVertices[AIndex].Color;
end;

function TBGRAFace3D.GetVertexColorOverride(AIndex: Integer): boolean;
begin
  if (AIndex < 0) or (AIndex >= FVertexCount) then
    raise Exception.Create('Index out of bounds');
  result := FVertices[AIndex].ColorOverride;
end;

function TBGRAFace3D.GetVertexCount: integer;
begin
  result := FVertexCount;
end;

procedure TBGRAFace3D.SetParentTexture(const AValue: boolean);
begin
  FParentTexture := AValue;
end;

procedure TBGRAFace3D.SetTexture(const AValue: IBGRAScanner);
begin
  FTexture := AValue;
  FParentTexture := false;
end;

procedure TBGRAFace3D.SetVertexColor(AIndex: Integer; const AValue: TBGRAPixel
  );
begin
  if (AIndex < 0) or (AIndex >= FVertexCount) then
    raise Exception.Create('Index out of bounds');
  with FVertices[AIndex] do
  begin
    Color := AValue;
    ColorOverride := true;
  end;
end;

procedure TBGRAFace3D.SetVertexColorOverride(AIndex: Integer;
  const AValue: boolean);
begin
  if (AIndex < 0) or (AIndex >= FVertexCount) then
    raise Exception.Create('Index out of bounds');
  FVertices[AIndex].ColorOverride := AValue;
end;

function TBGRAFace3D.GetTexCoord(AIndex: Integer): TPointF;
begin
  if (AIndex < 0) or (AIndex >= FVertexCount) then
    raise Exception.Create('Index out of bounds');
  result := FVertices[AIndex].TexCoord;
end;

function TBGRAFace3D.GetTexCoordOverride(AIndex: Integer): boolean;
begin
  if (AIndex < 0) or (AIndex >= FVertexCount) then
    raise Exception.Create('Index out of bounds');
  result := FVertices[AIndex].TexCoordOverride;
end;

procedure TBGRAFace3D.SetTexCoord(AIndex: Integer; const AValue: TPointF);
begin
  if (AIndex < 0) or (AIndex >= FVertexCount) then
    raise Exception.Create('Index out of bounds');
  FVertices[AIndex].TexCoord := AValue;
  FVertices[AIndex].TexCoordOverride := true;
end;

procedure TBGRAFace3D.SetTexCoordOverride(AIndex: Integer; const AValue: boolean
  );
begin
  if (AIndex < 0) or (AIndex >= FVertexCount) then
    raise Exception.Create('Index out of bounds');
  FVertices[AIndex].TexCoordOverride := AValue;
end;

function TBGRAFace3D.GetViewNormal: TPoint3D;
begin
  result := FViewNormal;
end;

function TBGRAFace3D.GetViewCenter: TPoint3D;
begin
  result := FViewCenter;
end;

function TBGRAFace3D.GetBiface: boolean;
begin
  result := FBiface;
end;

procedure TBGRAFace3D.SetBiface(const AValue: boolean);
begin
  FBiface := AValue;
end;

procedure TBGRAFace3D.ComputeViewNormalAndCenter;
var v1,v2: TPoint3D;
  i: Integer;
begin
  if FVertexCount < 3 then
    FViewNormal := Point3D(0,0,0)
  else
  begin
    v1 := FVertices[1].Vertex.ViewCoord - FVertices[0].Vertex.ViewCoord;
    v2 := FVertices[2].Vertex.ViewCoord - FVertices[1].Vertex.ViewCoord;
    VectProduct3D(v2,v1,FViewNormal);
    Normalize3D(FViewNormal);
    for i := 0 to FVertexCount-1 do
      FVertices[i].Vertex.ViewNormal := FVertices[i].Vertex.ViewNormal + FViewNormal;
  end;
  FViewCenter := Point3D(0,0,0);
  if FVertexCount > 0 then
  begin
    for i := 0 to FVertexCount-1 do
      FViewCenter += FVertices[i].Vertex.ViewCoord;
    FViewCenter *= 1/FVertexCount;
  end;
end;

{ TBGRAPart3D }

constructor TBGRAPart3D.Create;
begin
  FMatrix := MatrixIdentity3D;
end;

procedure TBGRAPart3D.Add(AVertex: IBGRAVertex3D);
begin
  if FVertexCount = length(FVertices) then
    setlength(FVertices, FVertexCount*2+3);
  FVertices[FVertexCount] := AVertex;
  inc(FVertexCount);
end;

function TBGRAPart3D.Add(x, y, z: single): IBGRAVertex3D;
begin
  result := TBGRAVertex3D.Create(Point3D(x,y,z));
  Add(result);
end;

function TBGRAPart3D.Add(pt: TPoint3D): IBGRAVertex3D;
begin
  result := TBGRAVertex3D.Create(pt);
  Add(result);
end;

function TBGRAPart3D.Add(const coords: array of single
  ): arrayOfIBGRAVertex3D;
var pts: array of TPoint3D;
    CoordsIdx: integer;
    i: Integer;
begin
  if length(coords) mod 3 <> 0 then
    raise exception.Create('Array size must be a multiple of 3');
  setlength(pts, length(coords) div 3);
  coordsIdx := 0;
  for i := 0 to high(pts) do
  begin
    pts[i] := Point3D(coords[CoordsIdx],coords[CoordsIdx+1],coords[CoordsIdx+2]);
    inc(coordsIdx,3);
  end;
  result := Add(pts);
end;

function TBGRAPart3D.Add(const pts: array of TPoint3D): arrayOfIBGRAVertex3D;
var
  i: Integer;
begin
  setlength(result, length(pts));
  for i := 0 to high(pts) do
    result[i] := TBGRAVertex3D.Create(pts[i]);
  Add(result);
end;

procedure TBGRAPart3D.Add(const pts: array of IBGRAVertex3D);
var
  i: Integer;
begin
  if FVertexCount + length(pts) > length(FVertices) then
    setlength(FVertices, (FVertexCount*2 + length(pts))+1);
  for i := 0 to high(pts) do
  begin
    FVertices[FVertexCount] := pts[i];
    inc(FVertexCount);
  end;
end;

function TBGRAPart3D.GetMatrix: TMatrix3D;
begin
  result := FMatrix;
end;

function TBGRAPart3D.GetPart(AIndex: Integer): IBGRAPart3D;
begin
  if (AIndex < 0) or (AIndex >= FPartCount) then
    raise exception.Create('Index of out bounds');
  result := FParts[AIndex];
end;

function TBGRAPart3D.GetPartCount: integer;
begin
  result := FPartCount;
end;

function TBGRAPart3D.GetVertex(AIndex: Integer): IBGRAVertex3D;
begin
  if (AIndex < 0) or (AIndex >= FVertexCount) then
    raise exception.Create('Index of out bounds');
  result := FVertices[AIndex];
end;

function TBGRAPart3D.GetVertexCount: integer;
begin
  result := FVertexCount;
end;

procedure TBGRAPart3D.ResetTransform;
begin
  FMatrix := MatrixIdentity3D;
end;

procedure TBGRAPart3D.Scale(size: single);
begin
  Scale(size,size,size);
end;

procedure TBGRAPart3D.Scale(x, y, z: single);
begin
  Scale(Point3D(x,y,z));
end;

procedure TBGRAPart3D.Scale(size: TPoint3D);
begin
  FMatrix *= MatrixScale3D(size);
end;

procedure TBGRAPart3D.RotateXDeg(angle: single);
begin
  RotateXRad(-angle*Pi/180);
end;

procedure TBGRAPart3D.RotateYDeg(angle: single);
begin
  RotateYRad(-angle*Pi/180);
end;

procedure TBGRAPart3D.RotateZDeg(angle: single);
begin
  RotateZRad(-angle*Pi/180);
end;

procedure TBGRAPart3D.RotateXRad(angle: single);
begin
  FMatrix *= MatrixRotateX(angle);
end;

procedure TBGRAPart3D.RotateYRad(angle: single);
begin
  FMatrix *= MatrixRotateY(angle);
end;

procedure TBGRAPart3D.RotateZRad(angle: single);
begin
  FMatrix *= MatrixRotateZ(angle);
end;

procedure TBGRAPart3D.SetMatrix(const AValue: TMatrix3D);
begin
  FMatrix := AValue;
end;

procedure TBGRAPart3D.ComputeWithMatrix(const AMatrix: TMatrix3D; const AProjection: TProjection3D);
var
  i: Integer;
  Composed: TMatrix3D;
begin
  Composed := AMatrix* self.FMatrix;
  for i := 0 to FVertexCount-1 do
    with FVertices[i] do
    begin
      ViewCoord := Composed*SceneCoord;
      ViewNormal := Point3D(0,0,0);
      if ViewCoord.z > 0 then
      begin
        ProjectedCoord := PointF(ViewCoord.x/ViewCoord.z*AProjection.Zoom.x + AProjection.Center.x,
                                 ViewCoord.y/ViewCoord.z*AProjection.Zoom.Y + AProjection.Center.y);
      end else
        ProjectedCoord := PointF(0,0);
    end;
  for i := 0 to FPartCount-1 do
    FParts[i].ComputeWithMatrix(Composed,AProjection);
end;

procedure TBGRAPart3D.NormalizeViewNormal;
var
  i: Integer;
  TempNormal: TPoint3D;
begin
  for i := 0 to FVertexCount-1 do
  begin
    TempNormal := FVertices[i].ViewNormal;
    Normalize3D(TempNormal);
    FVertices[i].ViewNormal := TempNormal;
  end;
  for i := 0 to FPartCount-1 do
    FParts[i].NormalizeViewNormal;
end;

procedure TBGRAPart3D.Translate(x, y, z: single);
begin
  Translate(Point3D(x,y,z));
end;

procedure TBGRAPart3D.Translate(ofs: TPoint3D);
begin
  FMatrix *= MatrixTranslation3D(ofs);
end;

function TBGRAPart3D.CreatePart: IBGRAPart3D;
begin
  if FPartCount = length(FParts) then
    setlength(FParts, FPartCount*2+1);
  result := TBGRAPart3D.Create;
  FParts[FPartCount] := result;
  inc(FPartCount);
end;

{ TBGRAObject3D }

procedure TBGRAObject3D.AddFace(AFace: IBGRAFace3D);
begin
  if FFaceCount = length(FFaces) then
     setlength(FFaces,FFaceCount*2+3);
  FFaces[FFaceCount] := AFace;
  inc(FFaceCount);
end;

constructor TBGRAObject3D.Create(AScene: TBGRAScene3D);
begin
  FColor := BGRAWhite;
  FLight := 1;
  FTexture := nil;
  FVertices := TBGRAPart3D.Create;
  FLightingNormal:= AScene.LightingNormal;
  FParentLighting:= True;
end;

destructor TBGRAObject3D.Destroy;
begin
  fillchar(FTexture,sizeof(FTexture),0);
  inherited Destroy;
end;

function TBGRAObject3D.GetColor: TBGRAPixel;
begin
  result := FColor;
end;

function TBGRAObject3D.GetLight: Single;
begin
  result := FLight;
end;

function TBGRAObject3D.GetTexture: IBGRAScanner;
begin
  result := FTexture;
end;

function TBGRAObject3D.GetVertices: IBGRAPart3D;
begin
  result := FVertices;
end;

procedure TBGRAObject3D.SetColor(const AValue: TBGRAPixel);
begin
  FColor := AValue;
  FTexture := nil;
end;

procedure TBGRAObject3D.SetLight(const AValue: Single);
begin
  FLight := AValue;
end;

procedure TBGRAObject3D.SetTexture(const AValue: IBGRAScanner);
begin
  FTexture := AValue;
end;

function TBGRAObject3D.GetLightingNormal: TLightingNormal3D;
begin
  result := FLightingNormal;
end;

function TBGRAObject3D.GetParentLighting: boolean;
begin
  result := FParentLighting;
end;

procedure TBGRAObject3D.SetLightingNormal(const AValue: TLightingNormal3D);
begin
  FLightingNormal := AValue;
  FParentLighting:= False;
end;

procedure TBGRAObject3D.SetParentLighting(const AValue: boolean);
begin
  FParentLighting:= AValue;
end;

procedure TBGRAObject3D.ComputeWithMatrix(const AMatrix: TMatrix3D; const AProjection: TProjection3D);
var
  i: Integer;
begin
  FVertices.ComputeWithMatrix(AMatrix,AProjection);
  for i := 0 to FFaceCount-1 do
    FFaces[i].ComputeViewNormalAndCenter;
  FVertices.NormalizeViewNormal;
end;

function TBGRAObject3D.AddFaceReversed(const AVertices: array of IBGRAVertex3D
  ): IBGRAFace3D;
var
  tempVertices: array of IBGRAVertex3D;
  i: Integer;
begin
  setlength(tempVertices,length(AVertices));
  for i := 0 to high(tempVertices) do
    tempVertices[i] := AVertices[high(AVertices)-i];
  result := AddFace(tempVertices);
end;

function TBGRAObject3D.AddFace(const AVertices: array of IBGRAVertex3D): IBGRAFace3D;
begin
  result := TBGRAFace3D.Create(self,AVertices);
  AddFace(result);
end;

function TBGRAObject3D.AddFace(const AVertices: array of IBGRAVertex3D;
  ABiface: boolean): IBGRAFace3D;
begin
  result := TBGRAFace3D.Create(self,AVertices);
  result.Biface := ABiface;
  AddFace(result);
end;

function TBGRAObject3D.AddFace(const AVertices: array of IBGRAVertex3D; ATexture: IBGRAScanner): IBGRAFace3D;
var Face: IBGRAFace3D;
begin
  Face := TBGRAFace3D.Create(self,AVertices);
  Face.Texture := ATexture;
  AddFace(Face);
  result := face;
end;

function TBGRAObject3D.AddFace(const AVertices: array of IBGRAVertex3D;
  AColor: TBGRAPixel): IBGRAFace3D;
var Face: IBGRAFace3D;
  i: Integer;
begin
  Face := TBGRAFace3D.Create(self,AVertices);
  for i := 0 to Face.VertexCount-1 do
    Face.VertexColor[i] := AColor;
  Face.Texture := nil;
  AddFace(Face);
  result := face;
end;

function TBGRAObject3D.AddFace(const AVertices: array of IBGRAVertex3D;
  AColors: array of TBGRAPixel): IBGRAFace3D;
var
  i: Integer;
begin
  if length(AColors) <> length(AVertices) then
    raise Exception.Create('Dimension mismatch');
  result := TBGRAFace3D.Create(self,AVertices);
  for i := 0 to high(AColors) do
    result.VertexColor[i] := AColors[i];
  AddFace(result);
end;

function TBGRAObject3D.GetFace(AIndex: integer): IBGRAFace3D;
begin
  if (AIndex < 0) or (AIndex >= FFaceCount) then
    raise Exception.Create('Index out of bounds');
  result := FFaces[AIndex];
end;

function TBGRAObject3D.GetFaceCount: integer;
begin
  result := FFaceCount;
end;

{ TBGRAScene3D }

function TBGRAScene3D.GetViewCenter: TPointF;
begin
  if FAutoViewCenter then
  begin
    if Surface = nil then
      result := PointF(0,0)
    else
      result := PointF((Surface.Width-1)/2,(Surface.Height-1)/2)
  end
  else
    result := FViewCenter;
end;

function TBGRAScene3D.GetZoom: TPointF;
var size: single;
begin
  if FAutoZoom then
  begin
    if FSurface = nil then
      result := PointF(1,1)
    else
    begin
      Size := sqrt(FSurface.Width*FSurface.Height)*0.8;
      result := PointF(size,size);
    end;
  end else
    result := FZoom;
end;

procedure TBGRAScene3D.SetAmbiantLightness(const AValue: single);
begin
  FAmbiantLightness:= AValue;
end;

procedure TBGRAScene3D.SetAmbiantLightColor(const AValue: TBGRAPixel);
begin
  FAmbiantLightColor := BGRAToColorF(AValue);
end;

function TBGRAScene3D.GetObject(AIndex: integer): IBGRAObject3D;
begin
  if (AIndex < 0) or (AIndex >= FObjectCount) then
    raise exception.Create('Index out of bounds');
  result := FObjects[AIndex];
end;

function TBGRAScene3D.GetAmbiantLightColor: TBGRAPixel;
begin
  result := ColorFToBGRA(FAmbiantLightColor);
end;

function TBGRAScene3D.GetAmbiantLightness: single;
begin
  result := FAmbiantLightness;
end;

procedure TBGRAScene3D.SetAutoViewCenter(const AValue: boolean);
begin
  if FAutoViewCenter=AValue then exit;
  if not AValue then
    FViewCenter := ViewCenter;
  FAutoViewCenter:=AValue;
end;

procedure TBGRAScene3D.SetAutoZoom(const AValue: boolean);
begin
  if FAutoZoom=AValue then exit;
  if not AValue then
    FZoom := Zoom;
  FAutoZoom:=AValue;
end;

procedure TBGRAScene3D.SetViewCenter(const AValue: TPointF);
begin
  FViewCenter := AValue;
  FAutoViewCenter:= False;
end;

procedure TBGRAScene3D.ComputeMatrix;
var ZDir, XDir, YDir: TPoint3D;
begin
  if FTopDir = Point3D(0,0,0) then exit;
  YDir := -FTopDir;
  Normalize3D(YDir);

  ZDir := FLookWhere-ViewPoint;
  if ZDir = Point3D(0,0,0) then exit;
  Normalize3D(ZDir);

  VectProduct3D(YDir,ZDir,XDir);
  VectProduct3D(ZDir,XDir,YDir); //correct Y dir

  FMatrix := Matrix3D(XDir,YDir,ZDir,ViewPoint);
  FMatrix := MatrixInverse3D(FMatrix);
end;

procedure TBGRAScene3D.AddObject(AObj: IBGRAObject3D);
begin
  if FObjectCount = length(FObjects) then
    setlength(FObjects, FObjectCount*2+1);
  FObjects[FObjectCount] := AObj;
  inc(FObjectCount);
end;

procedure TBGRAScene3D.Init;
begin
  FAutoZoom := True;
  FAutoViewCenter := True;
  ViewPoint := Point3D(0,0,-100);
  LookAt(Point3D(0,0,0), Point3D(0,-1,0));
  TextureInterpolation:= True;
  PerspectiveMapping := True;
  Antialiasing := False;
  AmbiantLightness := 1;
  AmbiantLight := BGRAWhite;
  LightingNormal := lnFaceVertexMix;
  LightingInterpolation := liGouraud;
  FLights := TList.Create;
end;

const
  c65535over32768 = 65535/32768;

function TBGRAScene3D.ApplyLighting(APosition, ANormal: TPoint3D;
  Color: TBGRAPixel): TBGRAPixel;
var multiplyColor,addColor,
    multiplyColorTerm,addColorTerm: TColorF;
    i: Integer;
    lightness,lightnessTerm: single;
begin
  multiplyColor := FAmbiantLightColor;
  addColor := ColorF(0,0,0,1);
  lightness := FAmbiantLightness;

  for i := 0 to FLights.Count-1 do
  begin
    IBGRALight3D(FLights[i]).ComputeLight(APosition,ANormal,multiplyColorTerm,addColorTerm,lightnessTerm);
    multiplyColor += multiplyColorTerm;
    addColor += addColorTerm;
    lightness += lightnessTerm;
  end;

  if lightness < 0 then
    result := BGRABlack
  else if lightness > c65535over32768 then
    result := BGRAWhite
  else
    result := ApplyLightnessFast(ColorFToBGRA(BGRAToColorF(Color)*multiplyColor + addColor), round(lightness*32768));

  result.alpha := Color.alpha;
end;

constructor TBGRAScene3D.Create;
begin
  Init;
end;

constructor TBGRAScene3D.Create(ASurface: TBGRACustomBitmap);
begin
  FSurface := ASurface;
  Init;
end;

destructor TBGRAScene3D.Destroy;
var
  i: Integer;
begin
  for i := 0 to FLights.Count-1 do
    IBGRALight3D(FLights[i])._Release;
  FLights.Free;
  inherited Destroy;
end;

procedure TBGRAScene3D.LookAt(AWhere: TPoint3D; ATopDir: TPoint3D);
begin
  FLookWhere := AWhere;
  FTopDir := ATopDir;
end;

procedure TBGRAScene3D.ComputeView;
var
  i: Integer;
  proj : TProjection3D;
begin
  ComputeMatrix;

  proj.Zoom := Zoom;
  proj.Center := ViewCenter;
  for i := 0 to FObjectCount-1 do
    FObjects[i].ComputeWithMatrix(FMatrix, proj);
end;

procedure TBGRAScene3D.ComputeLight;
begin

end;

type
  arrayOfIBGRAFace3D = array of IBGRAFace3D;

procedure InsertionSortFaces(var a: arrayOfIBGRAFace3D);
var i,j: integer;
    temp: IBGRAFace3D;
begin
  for i := 1 to high(a) do
  begin
    Temp := a[i];
    j := i;
    while (j>0) and (a[j-1].ViewCenter.z > Temp.ViewCenter.z) do
    begin
      a[j] := a[j-1];
      dec(j);
    end;
    a[j] := Temp;
  end;
end;

function PartitionFaces(var a: arrayOfIBGRAFace3D; left,right: integer): integer;

  procedure Swap(idx1,idx2: integer); inline;
  var temp: IBGRAFace3D;
  begin
    temp := a[idx1];
    a[idx1] := a[idx2];
    a[idx2] := temp;
  end;

var pivotIndex: integer;
    pivotValue: IBGRAFace3D;
    storeIndex: integer;
    i: integer;

begin
  pivotIndex := left + random(right-left+1);
  pivotValue := a[pivotIndex];
  swap(pivotIndex,right);
  storeIndex := left;
  for i := left to right-1 do
    if a[i].ViewCenter.z <= pivotValue.ViewCenter.z then
    begin
      swap(i,storeIndex);
      inc(storeIndex);
    end;
  swap(storeIndex,right);
  result := storeIndex;
end;

procedure QuickSortFaces(var a: arrayOfIBGRAFace3D; left,right: integer);
var pivotNewIndex: integer;
begin
  if right > left+9 then
  begin
    pivotNewIndex := PartitionFaces(a,left,right);
    QuickSortFaces(a,left,pivotNewIndex-1);
    QuickSortFaces(a,pivotNewIndex+1,right);
  end;
end;

procedure SortFaces(var a: arrayOfIBGRAFace3D);
begin
  if length(a) < 10 then InsertionSortFaces(a) else
  begin
    QuickSortFaces(a,0,high(a));
    InsertionSortFaces(a);
  end;
end;

function IsPolyVisible(const p : array of TPointF; ori: integer = 1) : boolean;
var i: integer;
begin
  i := 0;
  while i<high(p)-2 do
  begin
    if ori*
    ( (p[i+1].x-p[i].x)*(p[i+2].y-p[i].y) -
      (p[i+1].y-p[i].y)*(p[i+2].x-p[i].x)) < 0 then
    begin
        result := false;
        exit;
    end;
    inc(i);
  end;
  result := true;
end;

procedure TBGRAScene3D.Render;
var
  LFaces: array of IBGRAFace3D;
  LFaceCount,LFaceIndex: integer;
  i,j: Integer;
  LTexture: IBGRAScanner;
  SameColor: boolean;
  LVertices: array of IBGRAVertex3D;
  LColors: array of TBGRAPixel;
  LTexCoord: array of TPointF;
  LZ: array of single;
  LProj: array of TPointF;
  LPos3D, LNormal3D: array of TPoint3D;
  LLighting: array of word;
  LLightNormal : TLightingNormal3D;
  LNoLighting: boolean;
  multi: TBGRAMultishapeFiller;
  PhongTempBmp: TBGRACustomBitmap;
begin
  if FSurface = nil then
    raise exception.Create('No surface specified');
  ComputeView;
  ComputeLight;

  LFaces := nil;
  LFaceCount := 0;
  for i := 0 to FObjectCount-1 do
  begin
    inc(LFaceCount, FObjects[i].FaceCount);
    if FObjects[i].ParentLighting then
    begin
      FObjects[i].LightingNormal := Self.LightingNormal;
      FObjects[i].ParentLighting := True;
    end;
  end;
  setlength(LFaces, LFaceCount);
  LFaceIndex := 0;
  for i := 0 to FObjectCount-1 do
    with FObjects[i] do
    begin
      for j := 0 to FaceCount-1 do
      begin
        LFaces[LFaceIndex] := Face[j];
        inc(LFaceIndex);
      end;
    end;

  if Antialiasing then
  begin
    multi := TBGRAMultishapeFiller.Create;
    multi.PolygonOrder := poLastOnTop;
  end
  else
    multi := nil;

  if LightingInterpolation = liPhong then
    PhongTempBmp := surface.NewBitmap(2,2)
  else
    PhongTempBmp := nil;

  LVertices := nil;
  SortFaces(LFaces);
  for i := High(LFaces) downto 0 do
  with LFaces[i] do
  begin
    if LFaces[i].VertexCount < 3 then Continue;

    if ParentTexture then
      LTexture := Object3D.Texture
    else
      LTexture := Texture;

    LLightNormal := Object3D.LightingNormal;

    if length(LVertices) < VertexCount then
    begin
      setlength(LVertices, VertexCount*2);
      setlength(LColors, length(LVertices));
      setlength(LTexCoord, length(LVertices));
      setlength(LZ, length(LVertices));
      setlength(LProj, length(LVertices));
      setlength(LPos3D, length(LVertices));
      setlength(LNormal3D, length(LVertices));
      setlength(LLighting, length(LVertices));
    end;

    for j := 0 to VertexCount-1 do
    begin
      LVertices[j] := Vertex[j];

      if LTexture <> nil then
        LColors[j] := BGRA(128,128,128)
      else
        if VertexColorOverride[j] then
          LColors[j] := VertexColor[j]
        else
        begin
          if LVertices[j].ParentColor then
            LColors[j] := Object3D.Color
          else
            LColors[j] := LVertices[j].Color;
        end;

      if TexCoordOverride[j] then
        LTexCoord[j] := TexCoord[j]
      else
        LTexCoord[j] := LVertices[j].TexCoord;

      LProj[j] := LVertices[j].ProjectedCoord;
      LZ[j] := LVertices[j].ViewCoord.z;
    end;

    if not Biface and not IsPolyVisible(slice(LProj,VertexCount)) then Continue;

    //compute normals
    for j := 0 to VertexCount-1 do
    begin
      LPos3D[j] := LVertices[j].ViewCoord;
      LNormal3D[j] := LVertices[j].ViewNormal;
    end;
    case LLightNormal of
      lnFace: for j := 0 to VertexCount-1 do
                LNormal3D[j] := ViewNormal;
      lnFaceVertexMix:
          for j := 0 to VertexCount-1 do
          begin
            LNormal3D[j] += ViewNormal;
            Normalize3D(LNormal3D[j]);
          end;
    end;

    if (LightingInterpolation = liPhong) and (LLightNormal <> lnNone) then
    begin
      if LTexture = nil then
      begin
        SameColor := True;
        for j := 1 to VertexCount-1 do
          if (LColors[j]<>LColors[j-1]) then SameColor := False;
        if SameColor or (VertexCount > 4) then
        begin
          BGRAPolygonAliased.PolygonPerspectiveMappingShaderAliased(surface,
            slice(LProj,VertexCount),slice(LPos3D,VertexCount),slice(LNormal3D,VertexCount),nil,
              slice(LTexCoord,VertexCount),False,@ApplyLighting,True,LColors[0]);
        end else
        if VertexCount = 3 then
        begin
          PhongTempBmp.SetPixel(0,0,LColors[0]);
          PhongTempBmp.SetPixel(1,0,LColors[1]);
          PhongTempBmp.SetPixel(0,1,LColors[2]);
          PhongTempBmp.SetPixel(1,1,MergeBGRA(LColors[1],LColors[2]));
          BGRAPolygonAliased.PolygonPerspectiveMappingShaderAliased(surface,
            slice(LProj,VertexCount),slice(LPos3D,VertexCount),slice(LNormal3D,VertexCount),PhongTempBmp,
              [PointF(0,0),PointF(1,0),PointF(0,1)],True,@ApplyLighting,True, BGRAPixelTransparent);
        end else
        if VertexCount = 4 then
        begin
          PhongTempBmp.SetPixel(0,0,LColors[0]);
          PhongTempBmp.SetPixel(1,0,LColors[1]);
          PhongTempBmp.SetPixel(1,1,LColors[2]);
          PhongTempBmp.SetPixel(0,1,LColors[3]);
          BGRAPolygonAliased.PolygonPerspectiveMappingShaderAliased(surface,
            slice(LProj,VertexCount),slice(LPos3D,VertexCount),slice(LNormal3D,VertexCount),PhongTempBmp,
              [PointF(0,0),PointF(1,0),PointF(1,1),PointF(0,1)],True,@ApplyLighting,True, BGRAPixelTransparent);
        end;
      end else
      begin
        BGRAPolygonAliased.PolygonPerspectiveMappingShaderAliased(surface,
            slice(LProj,VertexCount),slice(LPos3D,VertexCount),slice(LNormal3D,VertexCount),LTexture,
              slice(LTexCoord,VertexCount),True,@ApplyLighting,True, BGRAPixelTransparent);
      end;
      Continue;
    end;

    //Gouraud interpolation
    LNoLighting := True;
    for j := 0 to VertexCount-1 do
    begin
      LColors[j] := ApplyLighting(LPos3D[j],LNormal3D[j],LColors[j]);
      if LColors[j] <> BGRA(128,128,128) then
        LNoLighting := false;
    end;

    if Antialiasing then
    begin
      if LTexture <> nil then
      begin
        if PerspectiveMapping and (VertexCount=4) then
          multi.AddQuadPerspectiveMapping(LProj[0],LProj[1],LProj[2],LProj[3],LTexture,LTexCoord[0],LTexCoord[1],LTexCoord[2],LTexCoord[3])
        else
        if VertexCount>=3 then
        begin
          for j := 0 to VertexCount-3 do
            multi.AddTriangleLinearMapping(LProj[j],LProj[j+1],LProj[j+2],LTexture,LTexCoord[j],LTexCoord[j+1],LTexCoord[j+2]);
        end;
      end
      else
      begin
        SameColor := True;
        for j := 1 to VertexCount-1 do
          if (LColors[j]<>LColors[j-1]) then SameColor := False;

        if SameColor then
          multi.AddPolygon(slice(LProj,VertexCount),LColors[0])
        else
        if VertexCount = 4 then
          multi.AddQuadLinearColor(LProj[0],LProj[1],LProj[2],LProj[3],LColors[0],LColors[1],LColors[2],LColors[3])
        else
        if VertexCount>=3 then
        begin
          for j := 0 to VertexCount-3 do
            multi.AddTriangleLinearColor(LProj[j],LProj[j+1],LProj[j+2],LColors[j],LColors[j+1],LColors[j+2]);
        end;
      end;
    end else
    begin
      if LTexture <> nil then
      begin
        if LNoLighting then
        begin
          if PerspectiveMapping then
            surface.FillPolyPerspectiveMapping(slice(LProj,VertexCount),slice(LZ,VertexCount),LTexture,slice(LTexCoord,VertexCount),TextureInterpolation)
          else
            surface.FillPolyLinearMapping(slice(LProj,VertexCount),LTexture,slice(LTexCoord,VertexCount),TextureInterpolation);
        end else
        begin
          for j := 0 to VertexCount-1 do
            LLighting[j] := LColors[j].green shl 8;
          if PerspectiveMapping then
            surface.FillPolyPerspectiveMappingLightness(slice(LProj,VertexCount),slice(LZ,VertexCount),LTexture,slice(LTexCoord,VertexCount),slice(LLighting,VertexCount),TextureInterpolation)
          else
            surface.FillPolyLinearMappingLightness(slice(LProj,VertexCount),LTexture,slice(LTexCoord,VertexCount),slice(LLighting,VertexCount),TextureInterpolation);
        end;
      end
      else
      begin
        SameColor := True;
        for j := 1 to VertexCount-1 do
          if (LColors[j]<>LColors[j-1]) then SameColor := False;

        if SameColor then
          surface.FillPoly(slice(LProj,VertexCount),LColors[0],dmDrawWithTransparency)
        else
          surface.FillPolyLinearColor(slice(LProj,VertexCount),slice(LColors,VertexCount));
      end;
    end;
  end;

  PhongTempBmp.Free;

  if multi <> nil then
  begin
    multi.Draw(surface);
    multi.Free;
  end;
end;

function TBGRAScene3D.CreateObject: IBGRAObject3D;
begin
  result := TBGRAObject3D.Create(self);
  AddObject(result);
end;

function TBGRAScene3D.CreateObject(ATexture: IBGRAScanner): IBGRAObject3D;
begin
  result := TBGRAObject3D.Create(self);
  result.Texture := ATexture;
  AddObject(result);
end;

function TBGRAScene3D.CreateObject(AColor: TBGRAPixel): IBGRAObject3D;
begin
  result := TBGRAObject3D.Create(self);
  result.Color := AColor;
  AddObject(result);
end;

procedure TBGRAScene3D.RemoveObject(AObject: IBGRAObject3D);
var
  i,j: Integer;
begin
  for i := FObjectCount-1 downto 0 do
    if FObjects[i] = AObject then
    begin
      dec(FObjectCount);
      FObjects[i] := nil;
      for j := i to FObjectCount-1 do
        FObjects[j] := FObjects[j+1];
    end;
end;

function TBGRAScene3D.AddDirectionalLight(ADirection: TPoint3D;
  ALightness: single; AMinLightness: single): IBGRADirectionalLightnessLight3D;
begin
  result := TBGRADirectionalLightnessLight3D.Create(ADirection);
  result.Lightness := ALightness;
  result.MinLightness := AMinLightness;
  result._AddRef;
  FLights.Add(result);
end;

function TBGRAScene3D.AddPointLight(AVertex: IBGRAVertex3D;
  AOptimalDistance: single; ALightness: single; AMinLightness: single
  ): IBGRALightnessLight3D;
begin
  result := TBGRAPointLightnessLight3D.Create(AVertex, ALightness*sqr(AOptimalDistance));
  result.MinLightness := AMinLightness;
  result._AddRef;
  FLights.Add(result);
end;

function TBGRAScene3D.AddDirectionalLight(ADirection: TPoint3D;
  AColor: TBGRAPixel; AMinIntensity: single): IBGRADirectionalColorLight3D;
begin
  result := TBGRADirectionalColorLight3D.Create(ADirection);
  result.MinIntensity := AMinIntensity;
  result.Color := AColor;
  result._AddRef;
  FLights.Add(result);
end;

function TBGRAScene3D.AddPointLight(AVertex: IBGRAVertex3D;
  AOptimalDistance: single; AColor: TBGRAPixel; AMinIntensity: single
  ): IBGRAPointColorLight3D;
begin
  result := TBGRAPointColorLight3D.Create(AVertex,sqr(AOptimalDistance));
  result.Color := AColor;
  result.MinIntensity := AMinIntensity;
  result._AddRef;
  FLights.Add(result);
end;

function TBGRAScene3D.AddPhongLight(AVertex: IBGRAVertex3D;
  AOptimalDistance: single; AColor: TBGRAPixel; AMinIntensity: single;
  ASpecularIndex: single; ASpecularIntensity: single): IBGRAPhongLight3D;
begin
  result := TBGRAPhongLight3D.Create(AVertex,sqr(AOptimalDistance),ASpecularIndex);
  result.SpecularIntensity := ASpecularIntensity;
  result.MinIntensity:= AMinIntensity;
  result.Color := AColor;
  result._AddRef;
  FLights.Add(result);
end;

procedure TBGRAScene3D.RemoveLight(ALight: IBGRALight3D);
var idx: integer;
begin
  idx := FLights.IndexOf(ALight);
  if idx <> -1 then
  begin
    ALight._Release;
    FLights.Delete(Idx);
  end;
end;

procedure TBGRAScene3D.SetZoom(value: Single);
begin
  SetZoom(PointF(value,value));
end;

procedure TBGRAScene3D.SetZoom(value: TPointF);
begin
  FZoom := value;
  FAutoZoom := false;
end;

end.

