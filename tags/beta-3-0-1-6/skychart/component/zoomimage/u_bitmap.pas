unit u_bitmap;
{
Copyright (C) 2005 Patrick Chevalley

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
 Bitmap functions
}
{$mode objfpc}{$H+}
interface

uses
  Math, SysUtils, Graphics, Classes, FPImage, LCLType, IntfGraphics;

Procedure BitmapRotation(var bmp,rbmp: TBitmap; Rotation:double; WhiteBg:boolean);
Procedure BitmapResize(img1:Tbitmap; var img2:Tbitmap; zoom:double; pixelized: boolean=false);
Procedure BitmapFlip(img:Tbitmap; flipx,flipy: boolean);
Procedure BitmapSubstract(var img1:Tbitmap; img2:Tbitmap);
Procedure BitmapLumCon(var img: TBitmap; Luminosity, Contrast: integer);

Procedure RotateImage(OriginalIntfImg, RotatedIntfImg:TLazIntfImage; theta:Double; oldAxis:TPOINT;var   newAxis:TPOINT;TransparentColor: TFPColor;RevertImage : Boolean);
Procedure ResizeImage(OriginalIntfImg, ResizedIntfImg:TLazIntfImage; zoom:double; pixelized: boolean=false);
Procedure FlipImage(OriginalIntfImg,FlipIntfImg:TLazIntfImage; flipx,flipy: boolean);
Procedure SubstractImage(IntfImg1, IntfImg2:TLazIntfImage);
Procedure LumConImage(OriginalIntfImg,IntfImg:TLazIntfImage; Luminosity, Contrast: integer);

implementation

const
      pi2 = 2*pi;
      
function  Rmod(x,y:Double):Double;
BEGIN
    Rmod := x - Int(x/y) * y ;
END  ;

//a structure to hold sine,cosine,distance (faster than angle)
type SiCoDiType=
  record
	 si, co, di:Double; {sine, cosine, distance 6/29/98}
  end;


{	Calculate sine/cosine/distance from INTEGER coordinates}
function SiCoDiPoint ( const p1, p2: TPoint ): SiCoDiType; {out}
{	This is MUCH faster than using angle functions such as arctangent}
{11.96    Jim Hargis  original SiCoDi for rotations. }
{11/22/96 modified for Zero length check, and replace SiCodi}
{6/14/98  modified  for Delphi}
{6/29/98  renamed from SiCo point}
{8/3/98	  set Zero angle for Zero length line}
{10/24/99 use hypot from math.pas}
var
   dx, dy: Integer;
begin
     dx := ( p2.x - p1.x ); 	dy := ( p2.y - p1.y );
     with RESULT do
          begin
	       di := HYPOT( dx, dy ); //10/24/99 	di := Sqrt( dx * dx + dy * dy );
	       if abs( di )<1
                   then begin si := 0.0; co := 1.0 end  //Zero length line
		   else begin si := dy/di; co := dx/di end;
	  end;
end;

///////////////////////////////////////////////////////////////////////////////
//Rotate  a bitmap about an arbritray center point;
///////////////////////////////////////////////////////////////////////////////
{
  (c) har*GIS L.L.C., 1999
  	You are free to use this in any way, but please retain this comment block.
  	Please email questions to jim@har-gis.com .
  Doc & Updates: http://www.efg2.com/Lab/ImageProcessing/RotateScanline.htm
  and http://www.efg2.com/Lab/Library/Delphi/Graphics/JimHargis_RotateBitMap.zip
}

{ Lazarus version using TLazIntfImage.
  now very loosely related to the original.
  29/12/2005 P. Chevalley
}
Procedure RotateImage(OriginalIntfImg, RotatedIntfImg:TLazIntfImage; theta:Double; oldAxis:TPOINT;var   newAxis:TPOINT;TransparentColor: TFPColor;RevertImage : Boolean);
VAR
		cosTheta       :  Double;
		sinTheta       :  Double;
		i              :  INTEGER;
		iOriginal      :  INTEGER;
		iPrime         :  INTEGER;
		j              :  INTEGER;
		jOriginal      :  INTEGER;
		jPrime         :  INTEGER;
		NewWidth,NewHeight:INTEGER;
		Oht,Owi,Rht,Rwi: Integer;//Original and Rotated subscripts to bottom/right
 var
    col : TFPColor;
    SiCoPhi: SiCoDiType; //sine,cosine, distance

begin

//COUNTERCLOCKWISE rotation angle in radians. 12/10/99
	 sinTheta := SIN( theta ); cosTheta := COS( theta );

//calculate the enclosing rectangle  12/15/00
	NewWidth  := ABS( ROUND( OriginalIntfImg.Height*sinTheta) ) + ABS( ROUND( OriginalIntfImg.Width*cosTheta ) );
	NewHeight := ABS( ROUND( OriginalIntfImg.Width*sinTheta ) ) + ABS( ROUND( OriginalIntfImg.Height*cosTheta) );

//diff size bitmaps have diff resolution of angle, ie r*sin(theta)<1 pixel
//use the small angle approx: sin(theta) ~~ theta   //11/7/00
// NO! we just compute the real sintheta above! and 6.28 is a small angle ! // pch 07/15/2005 
  if (abs(sinTheta*MAX( OriginalIntfImg.width,OriginalIntfImg.height)) ) > 1 then
  begin//non-zero rotation

//set output bitmap formats; we do not assume a fixed format or size 1/6/00
        RotatedIntfImg.SetSize(NewWidth,NewHeight);

//local constants for loop, each was hit at least width*height times   1/8/00
	Rwi := NewWidth - 1; //right column index
	Rht := NewHeight - 1;//bottom row index
	Owi := OriginalIntfImg.Width - 1;    //transp color column index
	Oht := OriginalIntfImg.Height - 1;   //transp color row  index

// Step through each row of rotated image.
	FOR j := 0 to Rht DO   //1/8/00
//	FOR j := Rht DOWNTO 0 DO   //1/8/00
	BEGIN //for j
	// offset origin by the growth factor     //12/25/99
     	     jPrime := 2*j - NewHeight + 1 ;

	// Step through each column of rotated image
	     FOR i := 0 to Rwi DO   //1/8/00
//	     FOR i := Rwi DOWNTO 0 DO   //1/8/00
 	     BEGIN //for i

		// offset origin by the growth factor  //12/25/99
                iPrime := 2*i - NewWidth   + 1;

		// Rotate (iPrime, jPrime) to location of desired pixel	(iPrimeRotated,jPrimeRotated)
		// Transform back to pixel coordinates of image, including translation
		// of origin from axis of rotation to origin of image.
		iOriginal := ( ROUND( iPrime*CosTheta - jPrime*sinTheta ) -1 + OriginalIntfImg.width ) DIV 2;
		jOriginal := ( ROUND( iPrime*sinTheta + jPrime*cosTheta ) -1 + OriginalIntfImg.height) DIV 2;

		// Make sure (iOriginal, jOriginal) is in BitmapOriginal.  If not,
		// assign background color to corner points.
		IF   ( iOriginal >= 0 ) AND ( iOriginal <= Owi ) AND
	   	     ( jOriginal >= 0 ) AND ( jOriginal <= Oht )    //1/8/00
	 	      THEN BEGIN //inside
				// Assign pixel from rotated space to current pixel in BitmapRotated
				//( nearest neighbor interpolation)
                                col:=OriginalIntfImg.Colors[iOriginal,joriginal];
                                if RevertImage then begin
                                   col.red:=65535-col.red;
                                   col.green:=65535-col.green;
                                   col.blue:=65535-col.blue;
                                end;
                                RotatedIntfImg.Colors[i,j]:=col;
                      END //inside
		      ELSE BEGIN //outside
                                RotatedIntfImg.Colors[i,j]:=TransparentColor;
		      END //if inside

		END //for i
	END;//for j
  end;//non-zero rotation

//offset to the apparent center of rotation   11/12/00 12/25/99
//rotate/translate the old bitmap origin to the new bitmap origin,FIXED 11/12/00
  sicoPhi := sicodiPoint(  POINT( OriginalIntfImg.width div 2, OriginalIntfImg.height div 2 ),oldaxis );
  //sine/cosine/dist of axis point from center point
  with sicoPhi do begin
    NewAxis.x := newWidth div 2 + ROUND( di*(CosTheta*co - SinTheta*si) );
    NewAxis.y := newHeight div 2- ROUND( di*(SinTheta*co + CosTheta*si) );//flip yaxis
  end;

END; {RotateImage}

{=============================================================================}

Procedure BitmapRotation(var bmp,rbmp: TBitmap; Rotation:double; WhiteBg :boolean);
var np :tpoint;
    TransparentColor : TFPColor;
    OriginalIntfImg, RotatedIntfImg : TLazIntfImage;
    ImgHandle,ImgMaskHandle: HBitmap;

begin
// Create raw image interface
OriginalIntfImg:=bmp.CreateIntfImage;
RotatedIntfImg:=bmp.CreateIntfImage;

Rotation:=rmod(Rotation+pi2,pi2);
TransparentColor.red:= 0;
TransparentColor.green:=0;
TransparentColor.blue:= 0;
TransparentColor.alpha:=65535;

RotateImage(OriginalIntfImg,RotatedIntfImg,Rotation,point(bmp.Width div 2, bmp.Height div 2),np,TransparentColor,WhiteBg);

// create bitmap from rotated raw image
rbmp.FreeImage;
RotatedIntfImg.CreateBitmaps(ImgHandle,ImgMaskHandle,false);
rbmp.Handle:=ImgMaskHandle;
rbmp.FreeImage;
rbmp.Handle:=ImgHandle;
// free the raw images
RotatedIntfImg.Free;
OriginalIntfImg.Free;

end;

Procedure ResizeImage(OriginalIntfImg, ResizedIntfImg:TLazIntfImage; zoom:double; pixelized: boolean=false);
var i,j,k,k2,l,nw,nh:integer;
    x,y,a,b:double;
    color,color1,color2,color3,color4: TFPColor;
begin
   nh:=round(OriginalIntfImg.Height*zoom);
   nw:=round(OriginalIntfImg.Width*zoom);
   ResizedIntfImg.SetSize(nw,nh);
   if zoom<=1 then pixelized:=true;
   for i:=0 to nh-1 do begin
      y:=i/zoom;
      k:=trunc(y);
      b:=y-k;
      if k<(OriginalIntfImg.Height-1) then k2:=k+1
         else k2:=k;                                  // last row, duplicate the previous one
      for l:=0 to nw-1 do begin
         x:=l/zoom;
         j:=trunc(x);
         a:=x-j;
         if pixelized or ((abs(a)<1e-3)and(abs(b)<1e-3)) then        // pixel center, use the original value
                ResizedIntfImg.Colors[l,i]:=OriginalIntfImg.Colors[j,k]
            else
            if j<(OriginalIntfImg.Width-1) then begin
               color1:=OriginalIntfImg.Colors[j,k];
               color2:=OriginalIntfImg.Colors[j+1,k];
               color3:=OriginalIntfImg.Colors[j,k2];
               color4:=OriginalIntfImg.Colors[j+1,k2];
               color.red:=round((1-a)*(1-b)*color1.red +a*(1-b)*color2.red +b*(1-a)*color3.red +a*b*color4.red);
               color.green:=round((1-a)*(1-b)*color1.green +a*(1-b)*color2.green +b*(1-a)*color3.green +a*b*color4.green);
               color.blue:=round((1-a)*(1-b)*color1.blue +a*(1-b)*color2.blue +b*(1-a)*color3.blue +a*b*color4.blue);
               color.alpha:=color1.alpha;
               ResizedIntfImg.Colors[l,i]:=color;
            end
            else  begin                             // last column, use the original last column
                ResizedIntfImg.Colors[l,i]:=OriginalIntfImg.Colors[j,k]
            end;
      end;
   end;
end;

Procedure BitmapResize(img1:Tbitmap; var img2:Tbitmap; zoom:double; pixelized: boolean=false);
var
    OriginalIntfImg, ResizedIntfImg : TLazIntfImage;
    ImgHandle,ImgMaskHandle: HBitmap;

begin
if zoom=1 then img2.Assign(img1)
else begin
  // Create raw image interface
  OriginalIntfImg:=img1.CreateIntfImage;
  ResizedIntfImg:=img1.CreateIntfImage;

  ResizeImage(OriginalIntfImg,ResizedIntfImg,zoom,pixelized);

  // create bitmap from rotated raw image
  img2.FreeImage;
  ResizedIntfImg.CreateBitmaps(ImgHandle,ImgMaskHandle,false);
  img2.Handle:=ImgMaskHandle;
  img2.FreeImage;
  img2.Handle:=ImgHandle;
  // free the raw images
  ResizedIntfImg.Free;
  OriginalIntfImg.Free;
end;
end;

Procedure FlipImage(OriginalIntfImg,FlipIntfImg:TLazIntfImage; flipx,flipy: boolean);
var i,j,ii,jj:integer;
    col: TFPColor;
begin
if (not flipx) and (not flipy) then exit;
FlipIntfImg.SetSize(OriginalIntfImg.Width,OriginalIntfImg.Height);
  for i:=0 to OriginalIntfImg.Height-1 do begin
    if flipy then ii:=OriginalIntfImg.Height-1-i
             else ii:=i;
    for j:=0 to OriginalIntfImg.Width-1 do begin
       if flipx then jj:=OriginalIntfImg.Width-1-j
                else jj:=j;
       col:=OriginalIntfImg.Colors[jj,ii];
       FlipIntfImg.Colors[j,i]:=col;
    end;
  end;
end;

Procedure BitmapFlip(img:Tbitmap; flipx,flipy: boolean);
var ImgHandle,ImgMaskHandle: HBitmap;
    OriginalIntfImg, FlipIntfImg : TLazIntfImage;
begin
if (not flipx) and (not flipy) then exit;
OriginalIntfImg:=img.CreateIntfImage;
FlipIntfImg:=img.CreateIntfImage;

FlipImage(OriginalIntfImg,FlipIntfImg,flipx,flipy);

img.FreeImage;
FlipIntfImg.CreateBitmaps(ImgHandle,ImgMaskHandle,false);
img.Handle:=ImgMaskHandle;
img.FreeImage;
img.Handle:=ImgHandle;
OriginalIntfImg.Free;
FlipIntfImg.Free;
end;

Procedure SubstractImage(IntfImg1, IntfImg2:TLazIntfImage);
var i,j:integer;
    col1,col2: TFPColor;
begin
if (IntfImg2.Width<IntfImg1.Width) or
   (IntfImg2.Height<IntfImg1.Height)
   then exit;
for i:=0 to IntfImg1.Height-1 do begin
  for j:=0 to IntfImg1.Width-1 do begin
    col1:=IntfImg1.Colors[j,i];
    col2:=IntfImg2.Colors[j,i];
    col1.red:=round(max(0,col1.red-col2.red));
    col1.green:=round(max(0,col1.green-col2.green));
    col1.blue:=round(max(0,col1.blue-col2.blue));
    IntfImg1.Colors[j,i]:=col1;
   end;
end;
end;

Procedure BitmapSubstract(var img1:Tbitmap; img2:Tbitmap);
var
    IntfImg1, IntfImg2 : TLazIntfImage;
    ImgHandle,ImgMaskHandle: HBitmap;

begin
  // Create raw image interface
  IntfImg1:=img1.CreateIntfImage;
  IntfImg2:=img2.CreateIntfImage;

  SubstractImage(IntfImg1,IntfImg2);

  // create bitmap from rotated raw image
  img1.FreeImage;
  IntfImg1.CreateBitmaps(ImgHandle,ImgMaskHandle,false);
  img1.Handle:=ImgMaskHandle;
  img1.FreeImage;
  img1.Handle:=ImgHandle;
  // free the raw images
  IntfImg1.Free;
  IntfImg2.Free;
end;

Procedure LumConImage(OriginalIntfImg,IntfImg:TLazIntfImage; Luminosity, Contrast: integer);
var i,j,dmin,dmax:integer;
    c : double;
    col: TFPColor;
begin
if (Luminosity=0) and (Contrast=0) then exit;
dmin:=0+255*Contrast;
dmax:=65535-255*Luminosity;
if dmin>=dmax then dmax:=dmin+1;
c:=65535/(dmax-dmin);
IntfImg.SetSize(OriginalIntfImg.Width,OriginalIntfImg.Height);
  for i:=0 to OriginalIntfImg.Height-1 do begin
    for j:=0 to OriginalIntfImg.Width-1 do begin
       col:=OriginalIntfImg.Colors[j,i];
       col.red:=trunc(max(0,min(65535,(col.red-dmin) * c )) );
       col.green:=trunc(max(0,min(65535,(col.green-dmin) * c )) );
       col.blue:=trunc(max(0,min(65535,(col.blue-dmin) * c )) );
       IntfImg.Colors[j,i]:=col;
    end;
  end;
end;

Procedure BitmapLumCon(var img: TBitmap; Luminosity, Contrast: integer);
var ImgHandle,ImgMaskHandle: HBitmap;
    OriginalIntfImg, IntfImg : TLazIntfImage;
begin
if (Luminosity=0) and (Contrast=0) then exit;
OriginalIntfImg:=img.CreateIntfImage;
IntfImg:=img.CreateIntfImage;

LumConImage(OriginalIntfImg,IntfImg, Luminosity, Contrast);

img.FreeImage;
IntfImg.CreateBitmaps(ImgHandle,ImgMaskHandle,false);
img.Handle:=ImgMaskHandle;
img.FreeImage;
img.Handle:=ImgHandle;
OriginalIntfImg.Free;
IntfImg.Free;
end;

end.
