{                                        
Copyright (C) 2002 Patrick Chevalley

http://www.astrosurf.com/astropc
pch@freesurf.ch

This program is free software; you can redistribute it and/or
modify it under the terms of the GNU General Public License
as published by the Free Software Foundation; either version 2
of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software
Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
}
unit cu_zoomimage;
{
 Very simple, not polished component to zoom an image.
}

interface

uses
    SysUtils, Classes,
{$ifdef linux}
    QControls, QExtCtrls, QGraphics ;
{$endif}
{$ifdef mswindows}
    jpeg, pngimage, Controls, ExtCtrls, Graphics ;
{$endif}


type
  {
   Very simple, not polished component to zoom an image.
  }
  TZoomImage = class(TCustomControl)
  private
     FBitmap: TBitmap;   // zoomed image ready to paint to the canvas
     FPicture: TPicture; // original image
     lockPicture:boolean;
     Fzoom, FZoomMin, FZoomMax : double;
     FXcentre, FYcentre, FSizeX, FSizeY, FXo, FYo, FXc, FYc, Fw, Fh  : integer;
     FOnPaint: TNotifyEvent;
     FOnPosChange: TNotifyEvent;
     { Assign a new picture to the original image
       ~param Value a valid TPicture }
     procedure SetPicture(Value: TPicture);
  protected
    procedure Paint; override;
  public
     constructor Create(Aowner:Tcomponent); override;
     destructor Destroy; override;
     procedure PictureChange(Sender: TObject); // Initialize the zoom after a new image is loaded
  published
     { Draw the zooomed image using the zoom properties }
     procedure Draw;
     { Get X screen coordinate from original image X coordinate 
       ~param X image coordinate (pixel) 
       ~result X screen coordinate (pixel) }
     function Wrld2ScrX(X: integer): integer;
     { Get Y screen coordinate from original image Y coordinate 
       ~param Y image coordinate (pixel) 
       ~result Y screen coordinate (pixel) }
     function Wrld2ScrY(Y: integer): integer;
     { Get original image X coordinate from X screen coordinate 
       ~param X screen coordinate (pixel) 
       ~result X image coordinate (pixel) }
     function Scr2WrldX(X: integer): integer;
     { Get original image Y coordinate from Y screen coordinate 
       ~param Y screen coordinate (pixel) 
       ~result Y image coordinate (pixel) }
     function Scr2WrldY(Y: integer): integer;
     property Canvas; // The canvas where the image is draw, published to allow further drawing (reticle)
     property Picture: TPicture read FPicture write SetPicture; // The original image
     property Zoom : double read Fzoom  write Fzoom  ; // The zoom factor
     property ZoomMin : double read FZoomMin; // The minimal zoom factor (default is adjusted to display the full image)
     property ZoomMax : double read FZoomMax write FZoomMax; // The maximal zoom factor (default=4)
     property Xcentre : integer read FXcentre  write FXcentre  ; // Desired image X coordinate of the center of the zoom window 
     property Ycentre : integer read FYcentre  write FYcentre  ; // Desired image Y coordinate of the center of the zoom window 
     property Xc : integer read FXc; // Actual image Y coordinate of the center of the zoom window 
     property Yc : integer read FYc; // Actual image Y coordinate of the center of the zoom window 
     property SizeX : integer read FSizeX; // Width of the original image
     property SizeY : integer read FSizeY; // Height of the original image
     property OnClick;
     property OnDblClick;
     property OnMouseDown;
     property OnMouseMove;
     property OnMouseUp;
     property OnPaint: TNotifyEvent read FOnPaint write FOnPaint; // Raise at each repaint of the canvas
     property OnPosChange: TNotifyEvent read FOnPosChange write FOnPosChange; // Raise after position of the window change
  end;

procedure Register;

implementation

// Register the component to Delphi IDE
procedure Register;
begin
  RegisterComponents('CDC', [TZoomImage]);
end;

constructor TZoomImage.Create(Aowner:Tcomponent);
begin
inherited create(Aowner);
LockPicture:=false;
Height := 105;
Width  := 105;
FZoom  := 1;
FZoomMin  := 1;
FZoomMax  := 4;
FBitmap := TBitmap.Create;
FPicture := TPicture.Create;
FPicture.OnChange := PictureChange;
end;

destructor TZoomImage.Destroy;
begin
FBitmap.free;
FPicture.free;
inherited destroy;
end;

procedure TZoomImage.SetPicture(Value: TPicture);
begin
if Value.Width=0 then raise exception.create('Invalid image!');
FSizeX:=Value.Width;
FSizeY:=Value.Height;
FPicture.Assign(Value);
FZoomMin:=Width / FSizeX;
if FZoomMax<=FZoomMin then FZoomMax:=FZoomMin+1;
end;

procedure TZoomImage.PictureChange(Sender: TObject);
begin
if lockPicture then begin
   // do not loop when replacing the picture by a bitmap (windows only)
   exit;
end;
if FPicture.Width=0 then raise exception.create('Invalid image!');
FSizeX:=FPicture.Width;
FSizeY:=FPicture.Height;
{$ifdef mswindows}
// Windows Copyrect require a bitmap
  try
  // avoid to loop
  lockPicture:=true;
  FBitmap.Width:=FSizeX;
  FBitmap.Height:=FSizeY;
  // copy temporarily to FBitmap
  FBitmap.Canvas.Draw(0,0,FPicture.Graphic);
  // copy the bitmap back to the picture
  FPicture.Bitmap.Assign(FBitmap);
  finally
  lockPicture:=false;
  end;
{$endif}
FZoomMin:=Width / FSizeX;
if FZoomMax<=FZoomMin then FZoomMax:=FZoomMin+1;
FZoom:=ZoomMin;
Draw;
end;

procedure TZoomImage.Draw;
var x0,y0,dx,dy : integer;
begin
if assigned(FPicture.Graphic) then begin
if FZoom<FZoomMin then FZoom:=FZoomMin;
if FZoom>FZoomMax then FZoom:=FZoomMax;
if FZoom=0 then exit;
Fw:=trunc(Width/FZoom);
Fh:=trunc(Height/FZoom);
dx:=round(Fw/2);
x0:=FSizeX-dx-dx;
FXo:=FXcentre-dx;
if FXo<0 then FXo:=0;
if FXo>x0 then FXo:=x0;
dy:=round(Fh/2);
y0:=FSizeY-dy-dy;
FYo:=FYcentre-dy;
if FYo<0 then FYo:=0;
if FYo>y0 then FYo:=y0;
FXc:=FXo+dx;
FYc:=FYo+dy;
// Copy the partial image
FBitmap.Width:=Fw;
FBitmap.Height:=Fh;
FBitmap.Canvas.CopyRect(Rect(0, 0, Fw, Fh),FPicture.Bitmap.Canvas,Rect(FXo, FYo, FXo+Fw, FYo+Fh));
// refresh the image
Paint;
if Assigned(FOnPosChange) then FOnPosChange(Self);
end;
end;

procedure TZoomImage.Paint;
begin
if assigned(FPicture.Graphic) then begin
// Stretch the image here
Canvas.StretchDraw(rect(0,0,Width,Height),FBitmap);
if Assigned(FOnPaint) then FOnPaint(Self);
end;
end;

function TZoomImage.Wrld2ScrX(X: integer): integer;
begin
if assigned(FPicture.Graphic) then begin
result:=round(FZoom*(X - FXo));
end
else result:=0;
end;

function TZoomImage.Wrld2ScrY(Y: integer): integer;
begin
if assigned(FPicture.Graphic) then begin
result:=round(FZoom*(Y - FYo));
end
else result:=0;
end;

function TZoomImage.Scr2WrldX(X: integer): integer;
begin
if (not assigned(FPicture.Graphic))or(FZoom=0) then result:=0
else
  result:=FXo + round(X / FZoom);
end;

function TZoomImage.Scr2WrldY(Y: integer): integer;
begin
if (not assigned(FPicture.Graphic))or(FZoom=0) then result:=0
else
  result:=FYo + round(Y / FZoom);
end;

end.
