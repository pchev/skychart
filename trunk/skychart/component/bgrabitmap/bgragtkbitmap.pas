{
 /**************************************************************************\
                             bgragtkbitmap.pas
                             -----------------
                 This unit should NOT be added to the 'uses' clause.
                 It contains patches for Gtk.

 ****************************************************************************
 *                                                                          *
 *  This file is part of BGRABitmap library which is distributed under the  *
 *  modified LGPL.                                                          *
 *                                                                          *
 *  See the file COPYING.modifiedLGPL.txt, included in this distribution,   *
 *  for details about the copyright.                                        *
 *                                                                          *
 *  This program is distributed in the hope that it will be useful,         *
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of          *
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.                    *
 *                                                                          *
 ****************************************************************************
}

unit BGRAGtkBitmap;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, BGRADefaultBitmap, Graphics,
  GraphType;

type
  { TBGRAGtkBitmap }

  TBGRAGtkBitmap = class(TBGRADefaultBitmap)
  private
    FPixBuf: Pointer;
    procedure SlowDrawTransparent(ABitmap: TBGRADefaultBitmap;
      ACanvas: TCanvas; ARect: TRect);
  protected
    procedure ReallocData; override;
    procedure FreeData; override;
    procedure DrawOpaque(ACanvas: TCanvas; Rect: TRect);
  public
    procedure DataDrawTransparent(ACanvas: TCanvas; Rect: TRect;
      AData: Pointer; ALineOrder: TRawImageLineOrder; AWidth, AHeight: integer);
      override;
    procedure Draw(ACanvas: TCanvas; x, y: integer; Opaque: boolean = True); override;
    procedure Draw(ACanvas: TCanvas; Rect: TRect; Opaque: boolean = True); override;
    procedure DataDrawOpaque(ACanvas: TCanvas; Rect: TRect; AData: Pointer;
      ALineOrder: TRawImageLineOrder; AWidth, AHeight: integer);
      override;
    procedure GetImageFromCanvas(CanvasSource: TCanvas; x, y: integer); override;
  end;

implementation

uses BGRABitmapTypes, LCLType,
  LCLIntf, IntfGraphics,
  {$IFDEF LCLgtk2}
  gdk2, gtk2def, gdk2pixbuf, glib2,
  {$ENDIF}
  {$IFDEF LCLgtk}
  gdk, gtkdef, gtkProc, gdkpixbuf, glib,
  {$ENDIF}
  FPImage;

{$IFDEF LCLgtk2}
type TGtkDeviceContext = TGtk2DeviceContext;
{$ENDIF}

procedure TBGRAGtkBitmap.SlowDrawTransparent(ABitmap: TBGRADefaultBitmap;
  ACanvas: TCanvas; ARect: TRect);
var
  background, temp: TBGRACustomBitmap;
  w, h: integer;

begin
  w := ARect.Right - ARect.Left;
  h := ARect.Bottom - ARect.Top;
  background := NewBitmap(w, h);
  background.GetImageFromCanvas(ACanvas, ARect.Left, ARect.Top);
  if (ABitmap.Width = w) and (ABitmap.Height = h) then
    background.PutImage(0, 0, ABitmap, dmDrawWithTransparency)
  else
  begin
    temp := ABitmap.Resample(w, h, rmSimpleStretch);
    background.PutImage(0, 0, temp, dmDrawWithTransparency);
    temp.Free;
  end;
  background.Draw(ACanvas, ARect.Left, ARect.Top, True);
  background.Free;
end;

procedure TBGRAGtkBitmap.ReallocData;
begin
  inherited ReallocData;
  FPixbuf := gdk_pixbuf_new_from_data(pguchar(FData),
    GDK_COLORSPACE_RGB, True, 8, Width, Height, Width*Sizeof(TBGRAPixel), nil, nil);
  if FPixbuf = nil then
    raise Exception.Create('Error initializing Pixbuf');
end;

procedure TBGRAGtkBitmap.FreeData;
begin
  {$IFDEF LCLgtk2}
  If FPixBuf <> nil then g_object_unref(FPixBuf);
  {$ELSE}
  If FPixBuf <> nil then gdk_pixbuf_unref(FPixBuf);
  {$ENDIF}
  FPixBuf := nil;
  inherited FreeData;
end;

procedure TBGRAGtkBitmap.DrawOpaque(ACanvas: TCanvas; Rect: TRect);
var DrawWidth,DrawHeight: integer;
    stretched: TBGRAGtkBitmap;
begin
  DrawWidth := Rect.Right-Rect.Left;
  DrawHeight := Rect.Bottom-Rect.Top;
  if (Height = 0) or (Width = 0) or (DrawWidth <= 0) or (DrawHeight <= 0) then
    exit;

  if (DrawWidth <> Width) or (DrawHeight <> Height) then
  begin
    stretched := Resample(DrawWidth,DrawHeight,rmSimpleStretch) as TBGRAGtkBitmap;
    stretched.DrawOpaque(ACanvas,Rect);
    stretched.Free;
    exit;
  end;

  SwapRedBlue;
  gdk_pixbuf_render_to_drawable(FPixBuf,
    TGtkDeviceContext(ACanvas.Handle).Drawable,
    TGtkDeviceContext(ACanvas.Handle).GC,
    0,0,
    TGtkDeviceContext(ACanvas.Handle).Offset.X+Rect.Left,
    TGtkDeviceContext(ACanvas.Handle).Offset.Y+Rect.Top,
    Width,Height,
    GDK_RGB_DITHER_NORMAL,0,0);
  SwapRedBlue;
end;

procedure TBGRAGtkBitmap.DataDrawTransparent(ACanvas: TCanvas; Rect: TRect;
  AData: Pointer; ALineOrder: TRawImageLineOrder; AWidth, AHeight: integer);
var
  Temp: TBGRAPtrBitmap;
begin
  Temp := TBGRAPtrBitmap.Create(AWidth, AHeight, AData);
  Temp.LineOrder := ALineOrder;
  SlowDrawTransparent(Temp, ACanvas, Rect);
  Temp.Free;
end;

procedure TBGRAGtkBitmap.Draw(ACanvas: TCanvas; x, y: integer; Opaque: boolean);
begin
  if self = nil then
    exit;
  if Opaque then
    DrawOpaque(ACanvas, Rect(X, Y, X + Width, Y + Height))
  else
    SlowDrawTransparent(Self, ACanvas, Rect(X, Y, X + Width, Y + Height));
end;

procedure TBGRAGtkBitmap.Draw(ACanvas: TCanvas; Rect: TRect; Opaque: boolean);
begin
  if self = nil then
    exit;
  if Opaque then
    DrawOpaque(ACanvas, Rect)
  else
    SlowDrawTransparent(Self, ACanvas, Rect);
end;

procedure TBGRAGtkBitmap.DataDrawOpaque(ACanvas: TCanvas; Rect: TRect;
  AData: Pointer; ALineOrder: TRawImageLineOrder; AWidth, AHeight: integer);
var stretched: TBGRACustomBitmap;
begin
  if (AHeight = 0) or (AWidth = 0) then
    exit;

  if (AWidth <> Width) or (AHeight <> Height) then
  begin
    stretched := Resample(AWidth,AHeight,rmSimpleStretch);
    stretched.DataDrawOpaque(ACanvas,Rect,AData,stretched.LineOrder,AWidth,AHeight)
  end;

  If ALineOrder = riloBottomToTop then VerticalFlip;
  SwapRedBlue;
  gdk_pixbuf_render_to_drawable(FPixBuf,
    TGtkDeviceContext(ACanvas.Handle).Drawable,
    TGtkDeviceContext(ACanvas.Handle).GC,
    0,0,Rect.Left,Rect.Top,AWidth,AHeight,
    GDK_RGB_DITHER_NORMAL,0,0);
  SwapRedBlue;
  If ALineOrder = riloBottomToTop then VerticalFlip;
end;

procedure TBGRAGtkBitmap.GetImageFromCanvas(CanvasSource: TCanvas; x, y: integer);
var
  subBmp: TBGRACustomBitmap;
  subRect: TRect;
  cw,ch: integer;
begin
  cw := CanvasSource.Width;
  ch := CanvasSource.Height;
  if (x < 0) or (y < 0) or (x+Width > cw) or
    (y+Height > ch) then
  begin
    FillTransparent;
    if (x+Width <= 0) or (y+Height <= 0) or
      (x >= cw) or (y >= ch) then
      exit;

    if (x > 0) then subRect.Left := x else subRect.Left := 0;
    if (y > 0) then subRect.Top := y else subRect.Top := 0;
    if (x+Width > cw) then subRect.Right := cw else
      subRect.Right := x+Width;
    if (y+Height > ch) then subRect.Bottom := ch else
      subRect.Bottom := y+Height;

    subBmp := NewBitmap(subRect.Right-subRect.Left,subRect.Bottom-subRect.Top);
    subBmp.GetImageFromCanvas(CanvasSource,subRect.Left,subRect.Top);
    PutImage(subRect.Left-x,subRect.Top-y,subBmp,dmSet);
    subBmp.Free;
    exit;
  end;

  gdk_pixbuf_get_from_drawable(FPixBuf,
    TGtkDeviceContext(CanvasSource.Handle).Drawable,
    nil,
    TGtkDeviceContext(CanvasSource.Handle).Offset.X+x,
    TGtkDeviceContext(CanvasSource.Handle).Offset.Y+y,0,0,Width,Height);
  SwapRedBlue;
  InvalidateBitmap;
end;


end.

