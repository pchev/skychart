unit renderform;

interface

uses
   SysUtils, Classes, Graphics, Forms, GLWin32Viewer,
   GLScene, Math, Jpeg, GLTexture, GLMisc, GLObjects, Dialogs, Controls;

type
  TForm1 = class(TForm)
    GLScene1: TGLScene;
    GLCamera1: TGLCamera;
    GLLightSource1: TGLLightSource;
    Sphere1: TSphere;
    DummyCube1: TDummyCube;
    Diskinf: TDisk;
    Disksup: TDisk;
    GLMaterialLibrary1: TGLMaterialLibrary;
    GLMemoryViewer1: TGLMemoryViewer;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Déclarations privées }
    Procedure ResetSphere;
    Procedure OrientLightSource(phase,sunincl: double);
    Procedure OrientCamera(pa,poleincl,mult: double);
    Procedure SetTexture(i:integer; fn:string);
  public
    { Déclarations publiques }
    Image1: TPicture;
  end;
  Procedure SetTexturePath(path : shortstring);stdcall;
  Procedure RenderMercury(cm,phase,pa,poleincl,sunincl,mult : double; size : integer; bmp : tbitmap); stdcall;
  Procedure RenderVenus(cm,phase,pa,poleincl,sunincl,mult : double; size : integer; bmp : tbitmap); stdcall;
  Procedure RenderMoon(cm,phase,pa,poleincl,sunincl,mult : double; size : integer; bmp : tbitmap); stdcall;
  Procedure RenderMars(cm,phase,pa,poleincl,sunincl,mult : double; size : integer; bmp : tbitmap); stdcall;
  Procedure RenderJupiter(cm,phase,pa,poleincl,sunincl,mult : double; size : integer; bmp : tbitmap); stdcall;
  Procedure RenderSaturn(cm,phase,pa,poleincl,sunincl,mult : double; size : integer; bmp : tbitmap); stdcall;
  Procedure RenderUranus(cm,phase,pa,poleincl,sunincl,mult : double; size : integer; bmp : tbitmap); stdcall;
  Procedure RenderNeptune(cm,phase,pa,poleincl,sunincl,mult : double; size : integer; bmp : tbitmap); stdcall;
  Procedure RenderPluto(cm,phase,pa,poleincl,sunincl,mult : double; size : integer; bmp : tbitmap); stdcall;
  Procedure RenderSun(cm,pa,poleincl,mult : double; size : integer; bmp : tbitmap); stdcall;
  Procedure CloseLib;stdcall;

var
  Form1: TForm1;

  Const  LightDist=1;
         cameradist=200;

implementation

var texturepath : string ='.\';

{$R *.DFM}

procedure TForm1.FormCreate(Sender: TObject);
begin
Image1:=TPicture.Create;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
Image1.Free;
end;

Procedure Tform1.ResetSphere;
begin
sphere1.Slices:=72;
sphere1.Stacks:=31;
sphere1.Scale.x:=1;
sphere1.Scale.y:=1;
sphere1.Scale.z:=1;
sphere1.radius:=0.5;
sphere1.Bottom:=-90;
Sphere1.TurnAngle:=0;
Sphere1.RollAngle:=0;
Sphere1.PitchAngle:=0;
sphere1.direction.z:=1;
sphere1.direction.x:=0;
sphere1.direction.y:=0;
sphere1.Up.y:=1;
sphere1.Up.x:=0;
sphere1.Up.z:=0;
disksup.Visible:=false;
diskinf.Visible:=false;
end;

Function sgn(x:Double):Double ;
begin
if x<0 then
   sgn:= -1
else
   sgn:=  1 ;          
end ;

Procedure Tform1.OrientLightSource(phase,sunincl: double);
begin
 GLLightSource1.Position.z:=-LightDist*cos(degtorad(phase));
 GLLightSource1.Position.x:=-LightDist*sin(degtorad(phase));
 if abs(sunincl)>89.9 then sunincl:=sgn(sunincl)*89.9;
 GLLightSource1.Position.y:=-LightDist*tan(degtorad(-sunincl));
 GLLightSource1.SpotDirection.x:=GLLightSource1.Position.x;
 GLLightSource1.SpotDirection.y:=GLLightSource1.Position.y;
 GLLightSource1.SpotDirection.z:=GLLightSource1.Position.z;
end;

Procedure Tform1.OrientCamera(pa,poleincl,mult: double);
begin
GLCamera1.Up.x:=sin(degtorad(-pa));
GLCamera1.Up.y:=cos(degtorad(-pa));
GLCamera1.Position.y:=cameradist*sin(degtorad(poleincl));
GLCamera1.Position.z:=cameradist*(1-cos(degtorad(poleincl)));
GLCamera1.FocalLength:=100*mult;
end;

Procedure Tform1.SetTexture(i:integer; fn:string);
begin
try
with GLMaterialLibrary1 do begin
  if Materials[i].Material.Texture.disabled then begin
     image1.LoadFromFile(texturepath+fn);
     Materials[i].Material.Texture.Image.Assign(Image1);
     Image1.bitmap.FreeImage;
     Materials[i].Material.Texture.disabled:=false;
  end;
end;
except
 ShowMessage('Error loading '+texturepath+fn);
end;
end;

Function Slash(nom : string) : string;
begin
result:=trim(nom);
if copy(result,length(nom),1)<>PathDelim then result:=result+PathDelim;
end;

Procedure SetTexturePath(path : shortstring);stdcall;
begin
texturepath:=slash(path);
end;

Procedure RenderMercury(cm,phase,pa,poleincl,sunincl,mult : double; size : integer; bmp : tbitmap); stdcall;
begin
with form1 do begin
ResetSphere;
SetTexture(0,'mercury.jpg');
Sphere1.Material.LibMaterialName:='mercury';
Sphere1.TurnAngle:=cm;
OrientCamera(pa,poleincl,mult);
OrientLightSource(phase,sunincl);
bmp.width:=size;
bmp.height:=size;
bmp.PixelFormat:=pf24bit;
GLMemoryViewer1.Buffer.RenderToBitmap(bmp,96);
end;
end;

Procedure RenderVenus(cm,phase,pa,poleincl,sunincl,mult : double; size : integer; bmp : tbitmap); stdcall;
begin
with form1 do begin
ResetSphere;
SetTexture(1,'venus.jpg');
Sphere1.Material.LibMaterialName:='venus';
Sphere1.TurnAngle:=cm;
OrientCamera(pa,poleincl,mult);
OrientLightSource(phase,sunincl);;
bmp.width:=size;
bmp.height:=size;
bmp.PixelFormat:=pf24bit;
GLMemoryViewer1.Buffer.RenderToBitmap(bmp,96);
end;
end;

Procedure RenderMoon(cm,phase,pa,poleincl,sunincl,mult : double; size : integer; bmp : tbitmap); stdcall;
begin
with form1 do begin
ResetSphere;
if size>1000 then begin
  sphere1.Slices:=360;
  sphere1.Stacks:=180;
end;
SetTexture(2,'moon.jpg');
Sphere1.Material.LibMaterialName:='moon';
Sphere1.TurnAngle:=cm;
OrientCamera(pa,poleincl,mult);
OrientLightSource(phase,sunincl);
bmp.width:=size;
bmp.height:=size;
bmp.PixelFormat:=pf24bit;
GLMemoryViewer1.Buffer.RenderToBitmap(bmp,96);
end;
end;

Procedure RenderMars(cm,phase,pa,poleincl,sunincl,mult : double; size : integer; bmp : tbitmap); stdcall;
begin
with form1 do begin
ResetSphere;
SetTexture(3,'mars.jpg');
Sphere1.Material.LibMaterialName:='mars';
Sphere1.TurnAngle:=cm;
OrientCamera(pa,poleincl,mult);
OrientLightSource(phase,sunincl);
bmp.width:=size;
bmp.height:=size;
bmp.PixelFormat:=pf24bit;
GLMemoryViewer1.Buffer.RenderToBitmap(bmp,96);
end;
end;

Procedure RenderJupiter(cm,phase,pa,poleincl,sunincl,mult : double; size : integer; bmp : tbitmap); stdcall;
begin
with form1 do begin
ResetSphere;
sphere1.Scale.y:=0.9352;     // oblate=0.06481
SetTexture(4,'jupiter.jpg');
Sphere1.Material.LibMaterialName:='jupiter';
Sphere1.TurnAngle:=cm;
OrientCamera(pa,poleincl,mult);
OrientLightSource(phase,sunincl);
bmp.width:=size;
bmp.height:=size;
bmp.PixelFormat:=pf24bit;
GLMemoryViewer1.Buffer.RenderToBitmap(bmp,96);
end;
end;

Procedure RenderSaturn(cm,phase,pa,poleincl,sunincl,mult : double; size : integer; bmp : tbitmap); stdcall;
begin
with form1 do begin
ResetSphere;
disksup.Visible:=true; diskinf.Visible:=true;
sphere1.Scale.x:=0.4413;
sphere1.Scale.z:=0.4413;
sphere1.Scale.y:=0.8924*0.4413;  // oblate=0.1076
SetTexture(5,'saturn.jpg');
SetTexture(6,'saturn_ring.jpg');
Sphere1.Material.LibMaterialName:='saturn';
disksup.Material.LibMaterialName:='saturn_ring';
diskinf.Material.LibMaterialName:='saturn_ring';
Sphere1.TurnAngle:=cm;
OrientCamera(pa,poleincl,mult);
OrientLightSource(phase,sunincl);
bmp.width:=size;
bmp.height:=size;
bmp.PixelFormat:=pf24bit;
GLMemoryViewer1.Buffer.RenderToBitmap(bmp,96);
end;
end;

Procedure RenderUranus(cm,phase,pa,poleincl,sunincl,mult : double; size : integer; bmp : tbitmap); stdcall;
begin
with form1 do begin
ResetSphere;
sphere1.Scale.y:=0.9700;    // oblate=0.030
SetTexture(7,'uranus.jpg');
Sphere1.Material.LibMaterialName:='uranus';
Sphere1.TurnAngle:=cm;
OrientCamera(pa,poleincl,mult);
OrientLightSource(phase,sunincl);
bmp.width:=size;
bmp.height:=size;
bmp.PixelFormat:=pf24bit;
GLMemoryViewer1.Buffer.RenderToBitmap(bmp,96);
end;
end;

Procedure RenderNeptune(cm,phase,pa,poleincl,sunincl,mult : double; size : integer; bmp : tbitmap); stdcall;
begin
with form1 do begin
ResetSphere;
sphere1.Scale.y:=0.974;  // oblate=0.026
SetTexture(8,'neptune.jpg');
Sphere1.Material.LibMaterialName:='neptune';
Sphere1.TurnAngle:=cm;
OrientCamera(pa,poleincl,mult);
OrientLightSource(phase,sunincl);
bmp.width:=size;
bmp.height:=size;
bmp.PixelFormat:=pf24bit;
GLMemoryViewer1.Buffer.RenderToBitmap(bmp,96);
end;
end;

Procedure RenderPluto(cm,phase,pa,poleincl,sunincl,mult : double; size : integer; bmp : tbitmap); stdcall;
begin
with form1 do begin
ResetSphere;
SetTexture(9,'pluto.jpg');
Sphere1.Material.LibMaterialName:='pluto';
Sphere1.TurnAngle:=cm;
OrientCamera(pa,poleincl,mult);
OrientLightSource(phase,sunincl);
bmp.width:=size;
bmp.height:=size;
bmp.PixelFormat:=pf24bit;
GLMemoryViewer1.Buffer.RenderToBitmap(bmp,96);
end;
end;

Procedure RenderSun(cm,pa,poleincl,mult : double; size : integer; bmp : tbitmap); stdcall;
begin
with form1 do begin
ResetSphere;
SetTexture(10,'sun.jpg');
Sphere1.Material.LibMaterialName:='sun';
Sphere1.TurnAngle:=cm;
OrientCamera(pa,poleincl,mult);
OrientLightSource(0,poleincl);
bmp.width:=size;
bmp.height:=size;
bmp.PixelFormat:=pf24bit;
GLMemoryViewer1.Buffer.RenderToBitmap(bmp,96);
end;
end;

Procedure CloseLib;stdcall;
begin
Form1.Release;
end;

end.
