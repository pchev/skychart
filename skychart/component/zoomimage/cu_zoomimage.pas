unit cu_zoomimage;
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
  TZoomImage = class(TCustomControl)
  private
    { Private declarations }
     FBitmap: TBitmap;
     FPicture: TPicture;
     Fzoom, FZoomMin, FZoomMax : double;
     FXcentre, FYcentre, FSizeX, FSizeY, FXo, FYo, FXc, FYc, Fw, Fh  : integer;
     FOnPaint: TNotifyEvent;
     FOnPosChange: TNotifyEvent;
     procedure SetPicture(Value: TPicture);
     procedure PictureChange(Sender: TObject);
  protected
    { Protected declarations }
    procedure Paint; override;
  public
    { Public declarations }
     constructor Create(Aowner:Tcomponent); override;
     destructor Destroy; override;
  published
    { Published declarations }
     procedure Draw;
     function Wrld2ScrX(X: integer): integer;
     function Wrld2ScrY(Y: integer): integer;
     function Scr2WrldX(X: integer): integer;
     function Scr2WrldY(Y: integer): integer;
     property Canvas;
     property Picture: TPicture read FPicture write SetPicture;
     property Zoom : double read Fzoom  write Fzoom  ;
     property ZoomMin : double read FZoomMin;
     property ZoomMax : double read FZoomMax write FZoomMax;
     property Xcentre : integer read FXcentre  write FXcentre  ;
     property Ycentre : integer read FYcentre  write FYcentre  ;
     property Xc : integer read FXc;
     property Yc : integer read FYc;
     property SizeX : integer read FSizeX;
     property SizeY : integer read FSizeY;
     property OnClick;
     property OnDblClick;
     property OnMouseDown;
     property OnMouseMove;
     property OnMouseUp;
     property OnPaint: TNotifyEvent read FOnPaint write FOnPaint;
     property OnPosChange: TNotifyEvent read FOnPosChange write FOnPosChange;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('CDC', [TZoomImage]);
end;

constructor TZoomImage.Create(Aowner:Tcomponent);
begin
inherited create(Aowner);
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
FPicture.Assign(Value);
if FPicture.Width=0 then raise exception.create('Invalid image!');
FSizeX:=FPicture.Width;
FSizeY:=FPicture.Height;
FZoomMin:=Width / FSizeX;
end;

procedure TZoomImage.PictureChange(Sender: TObject);
begin
if FPicture.Width=0 then raise exception.create('Invalid image!');
FSizeX:=FPicture.Width;
FSizeY:=FPicture.Height;
{$ifdef mswindows}
// Windows Copyrect require a bitmap
FBitmap.Width:=FSizeX;
FBitmap.Height:=FSizeY;
FBitmap.Canvas.Draw(0,0,FPicture.Graphic);
{$endif}
FZoomMin:=Width / FSizeX;
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
{$ifdef linux}
// Kylix Copyrect do not stretch the image
FBitmap.Width:=Fw;
FBitmap.Height:=Fh;
FBitmap.Canvas.CopyRect(Rect(0, 0, Fw, Fh),FPicture.Bitmap.Canvas,Rect(FXo, FYo, FXo+Fw, FYo+Fh));
{$endif}
Paint;
if Assigned(FOnPosChange) then FOnPosChange(Self);
end;
end;

procedure TZoomImage.Paint;
begin
if assigned(FPicture.Graphic) then begin
{$ifdef linux}
// Stretch the image here
Canvas.StretchDraw(rect(0,0,Width,Height),FBitmap);
{$endif}
{$ifdef mswindows}
// Clip and stretch here
Canvas.CopyRect(Rect(0, 0, Width, Height),FBitmap.Canvas,Rect(FXo, FYo, FXo+Fw, FYo+Fh));
{$endif}
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
