{
 /**************************************************************************\
                                bgrabitmap.pas
                                --------------
                 Free easy-to-use memory bitmap 32-bit,
                 8-bit for each channel, transparency.
                 Channels in that order : B G R A

                 - Drawing primitives
                 - Resample
                 - Reference counter
                 - Drawing on LCL canvas
                 - Loading and saving images

                 Note : line order can change, so if you access
                 directly to bitmap data, check LineOrder value
                 or use Scanline to compute position.


       --> Include BGRABitmap and BGRABitmapTypes in the 'uses' clause.

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

unit BGRABitmap;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils,
{$IFDEF LCLwin32}
  BGRAWinBitmap,
{$ELSE}
  {$IFDEF LCLgtk}
  BGRAGtkBitmap,
  {$ELSE}
    {$IFDEF LCLgtk2}
  BGRAGtkBitmap,
    {$ELSE}
      {$IFDEF LCLqt}
  BGRAQtBitmap,
      {$ELSE}
  BGRADefaultBitmap,
      {$ENDIF} 
    {$ENDIF}
  {$ENDIF}
{$ENDIF}
  Graphics;

type
{$IFDEF LCLwin32}
  TBGRABitmap = TBGRAWinBitmap;
{$ELSE}
  {$IFDEF LCLgtk}
  TBGRABitmap = TBGRAGtkBitmap;
  {$ELSE}
    {$IFDEF LCLgtk2}
  TBGRABitmap = TBGRAGtkBitmap;
    {$ELSE}
      {$IFDEF LCLqt}
  TBGRABitmap = TBGRAQtBitmap;
      {$ELSE}
  TBGRABitmap = TBGRADefaultBitmap;
      {$ENDIF}
    {$ENDIF}
  {$ENDIF}
{$ENDIF}


procedure BGRABitmapDraw(ACanvas: TCanvas; Rect: TRect; AData: Pointer;
  VerticalFlip: boolean; AWidth, AHeight: integer; Opaque: boolean);
procedure BGRAReplace(var Destination: TBGRABitmap; Temp: TObject);

implementation

uses GraphType;

var
  bmp: TBGRABitmap;

procedure BGRABitmapDraw(ACanvas: TCanvas; Rect: TRect; AData: Pointer;
  VerticalFlip: boolean; AWidth, AHeight: integer; Opaque: boolean);
var
  LineOrder: TRawImageLineOrder;
begin
  if VerticalFlip then
    LineOrder := riloBottomToTop
  else
    LineOrder := riloTopToBottom;
  if Opaque then
    bmp.DataDrawOpaque(ACanvas, Rect, AData, LineOrder, AWidth, AHeight)
  else
    bmp.DataDrawTransparent(ACanvas, Rect, AData, LineOrder, AWidth, AHeight);
end;

procedure BGRAReplace(var Destination: TBGRABitmap; Temp: TObject);
begin
  Destination.Free;
  Destination := Temp as TBGRABitmap;
end;

initialization

  bmp := TBGRABitmap.Create(0, 0);

finalization

  bmp.Free;

end.

