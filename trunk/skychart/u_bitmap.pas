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

interface

uses u_util, u_constant, Math, SysUtils, Classes,
{$ifdef mswindows}
Windows, Graphics;
{$endif}
{$ifdef linux}
Types, QGraphics;
{$endif}

Procedure BitmapRotation(bmp,rbmp: TBitmap; Rotation:double);
procedure BitmapRotMask(imamask,rbmp,bmp: tbitmap; Rotation:double);
procedure BitmapBlackMask(imamask,bmp: tbitmap);

implementation

///////////////////////////////////////////////////////////////////////////////
// General LIbrary routines for ease of portability
///////////////////////////////////////////////////////////////////////////////

{
   	(c)har*GIS L.L.C.,2000
      	Please email questions to jim@har-gis.com
        for updates, see site  http://www.efg2.com/Lab/ImageProcessing/
  	You are free to use this in any way, but please retain this comment block
        with any section of code you extract.
}
{
   adjust to work with Kylix.
    - remove pf4bit, pf15bit, pf24bit, pfDevice, pfCustom
   01/02/05  P. Chevalley
}
// the following is missing from Kylix
type  TRGBQuad = record rgbBlue,rgbGreen,rgbRed,rgbReserved : byte; end;

//specify which real format we want
type RealType = Single;
type AngleType= RealType;
//specify the format we want for Points
type PointType = TPoint;
type CoordType = Integer;
//a structure to hold sine,cosine,distance (faster than angle)
type SiCoDiType=
  record
	 si, co, di:RealType; {sine, cosine, distance 6/29/98}
  end;

//reduce angle to 0..360
function mod360( const angle:AngleType ):AngleType;
begin
	RESULT := FRAC( angle/360 )*360;
	if RESULT<0 then RESULT := RESULT+360;
end;

{	Calculate sine/cosine/distance from INTEGER coordinates}
function SiCoDiPoint ( const p1, p2: PointType ): SiCoDiType; {out}
{	This is MUCH faster than using angle functions such as arctangent}
{11.96    Jim Hargis  original SiCoDi for rotations.
{11/22/96 modified for Zero length check, and replace SiCodi}
{6/14/98  modified  for Delphi}
{6/29/98  renamed from SiCo point}
{8/3/98	  set Zero angle for Zero length line}
{10/24/99 use hypot from math.pas}
	var
		dx, dy: CoordType;
	begin
		dx := ( p2.x - p1.x ); 	dy := ( p2.y - p1.y ); 
		with RESULT do
			begin
				di := HYPOT( dx, dy ); //10/24/99 	di := Sqrt( dx * dx + dy * dy );
				if abs( di )<1
          then begin si := 0.0; co := 1.0 end//Zero length line
					else begin si := dy/di; co := dx/di end;
			end;
	end;

// read time stamp in CPU Cycles for Pentium
function RDTSC: Int64;
asm
  DB 0FH, 31H   //allows out-of-sequence execution, caching
end;

///////////////////////////////////////////////////////////////////////////////
//Rotate  a bitmap about an arbritray center point;
///////////////////////////////////////////////////////////////////////////////
	PROCEDURE RotateBitmap(
		const BitmapOriginal:TBitMap;//input bitmap (possibly converted)
		out   BitMapRotated:TBitMap; //output bitmap
		const theta:AngleType;  // rotn angle in radians counterclockwise in windows
		const oldAxis:TPOINT; 	// center of rotation in pixels, rel to bmp origin
		var   newAxis:TPOINT);  // center of rotated bitmap, relative to bmp origin
{
  (c) har*GIS L.L.C., 1999
  	You are free to use this in any way, but please retain this comment block.
  	Please email questions to jim@har-gis.com .
  Doc & Updates: http://www.efg2.com/Lab/ImageProcessing/RotateScanline.htm
  and http://www.efg2.com/Lab/Library/Delphi/Graphics/JimHargis_RotateBitMap.zip
}
{Notes...
  Coordinates and rotation are adjusted for 'flipped' Y axis (+Y is down)
  Bitmap origins are (0,0) in top-left.
  BitMapRotated is enlarged to contain the rotated bitmap
  BitMapOriginal may be changed from 1,2,4 bit to pf8Bit, if needed.
//	rotate about center, Oldaxis:=POINT( bmp.width div 2, bmp.height div 2 );
//  rotate about origin top-left, Oldaxis:=POINT( 0,0 );
//  rotate about bottom-center, Oldaxis:=POINT( bmp.width div 2, bmp.height )
  NewAxis: is the new center of rotation for BitMapRotated;
}
{Usage...
  var Inbmp,Newbmp:TbitMap;
  var Center, NewCenter: TPoint;
  begin  //draw at 45 degrees rotated about center
    inbmp:=Tbitmap.Create; Newbmp:=Tbitmap.Create;
    InBMP.LoadFromFile( '..\Athena.bmp'); InBMP.Transparent:=True;
    Center:=POINT( inbmp.width div 2, inbmp.height div 2 );
    RotateBitMap( inBMP, 45*pi/180, NewBMP, Center, NewCenter );
    //place the bmp rotation axis at 100,100...
    Canvas.Draw( 100-NewCenter.x, 100-NewCenter.y, NewBMP );
    inbmp.free; newbmp.free;
  end;
}
{Features/ improvements over original EFG RotateBitMap:
  This is generalized procedure; application independent.
  Does NOT clip corners; Enlarges Output bmp if needed.
  Output keeps same transparency and pallette as set by BitMapOriginal.
	Handles all pixel formats, format converted to least one byte per pixel.
	Axis of rotation specified by caller, but new axis will differ from oldaxis.
	Minor Delphi performance optimizations (about 8 instructions per pixel)
  Skips "null" angles which have no discernable effect.
}
{Restrictions:
	Caller responsible for create/destroy bitmaps.  This improves perfc in loops.
  Caller must provide the following:
    AngleType: the user-specified float format for real angle.
      can be single, double or extended; you won't see any difference.
    function min( const i,j:integer ):integer;  // from Math.pas
    procedure sincos(const theta:real; var sine,cosine:Extended );//from Math.pas
	Uses nearest neighbor sampling, no antialiasing: poor quality;
	Not optimized for Pentium;  no MMX. (see Intel Image Processing Library)
}
{Revisions...
12/1/99 original code extracted from Earl F. Glynn
		Copyright (C) 1997-1998 Earl F. Glynn, Overland Park, KS  USA.
		All Rights Reserved.
12/10/99 new code added to make a standalone method. Original in (*comments*)
		Copyright (c) 1999-2000 har*GIS LLC, Englewood CO USA; jim@har-gis.com
    V1.0.0 release
12/15/99 add rotation axis to be specified
		add transparent color, add rotated rectangle output (non-clipped).
12/25/99  recomputed  new rotation axis.
1/6/2000  allow multibyte pixel formats. Translate 1bit and 4bit to 8bit.
10/31/00  add support for pixel formats pfDevice, pfCustom (from Rob Rossmair);
  drop err and debug message I/O;
  deleted the changed code from EFG; use "with" for efficiency;
  add check for nil angle (rotates less than 1 pizel;
  publish as general function, not a method.
11/5/00 allow variable real formats (but only need single precision);
  drop temp bitmap (BM8),  OriginalBitmap is converted if needed.
  fix BUG which ignored OldAxis, always rotated about center, set bad NewAxis
  fix BUG in false optimization for angle zero, which overwrote the input bmp)
11/12/00 fix BUG in calc of NewAxis; simplify math for center rotation.
  V1.0.5 release}
{ToDo.. use pointer arithmetic instead of type subscripting for faster pixels.
  Test pfDevice and pfCustom, test palettes. <no data>. }
		VAR
		cosTheta       :  Single;   {in windows}
		sinTheta       :  Single;
		i              :  INTEGER;
		iOriginal      :  INTEGER;
		iRotationAxis  :  INTEGER;// Axis of rotation is normally center of image
		iPrime         :  INTEGER;
//		iPrimeRotated  :  INTEGER; use width if doubled
		j              :  INTEGER;
		jOriginal      :  INTEGER;
		jRotationAxis  :  INTEGER;
		jPrime         :  INTEGER;
//		jPrimeRotated  :  INTEGER; use height if doubled
		NewWidth,NewHeight:INTEGER;
		nBytes, nBits: Integer;//no. bytes per pixelformat
		Oht,Owi,Rht,Rwi: Integer;//Original and Rotated subscripts to bottom/right
//The variant pixel formats for subscripting       1/6/00
	type // from Delphi
		//TRGBTripleArray = array [0..32767] of TRGBTriple; //allow integer subscript
		//pRGBTripleArray = ^TRGBTripleArray;
		TRGBQuadArray = array [0..32767]  of TRGBQuad;//allow integer subscript
		pRGBQuadArray = ^TRGBQuadArray;
	var //each of the following points to the same scanlines
		RowRotatedB: pByteArray; 			//1 byte
		RowRotatedW: pWordArray;  		//2 bytes
		//RowRotatedT: pRGBtripleArray;	//3 bytes
		RowRotatedQ: pRGBquadArray;  	//4 bytes
	var //a single pixel for each format 	1/8/00
		TransparentB: Byte;
		TransparentW: Word;
		//TransparentT: TRGBTriple;
		TransparentQ: TRGBQuad;
  var
   // DIB: TDIBSection;//10/31/00
    Center:  TPOINT; //the middle of the bmp relative to bmp origin.
    SiCoPhi: SiCoDiType;//sine,cosine, distance
{=======================================}
begin

with BitMapOriginal do begin

//Decipher the appropriate pixelformat to use Delphi byte subscripting 1/6/00
//pfDevice, pf1bit, pf4bit, pf8bit, pf15bit, pf16bit, pf24bit, pf32bit,pfCustom;
		case pixelformat of
//    pfDevice: begin //handle only pixelbits= 1..8,16,24,32 //10/31/00
//      nbits :=  GetDeviceCaps( Canvas.Handle,BITSPIXEL )+1 ;
//      nbytes := nbits div 8; //no. bytes for bits per pixel
//      if (nbytes>0)and(nbits mod 8 <> 0) then exit;//ignore if invalid
//      end;
			pf1bit:  nBytes:=0;// 1bit, TByteArray      //2 color pallete , re-assign byte value to 8 pixels, for entire scan line
//	pf4bit:	 nBytes:=0;// 4bit, PByteArray     // 16 color pallette; build nibble for pixel pallette index; convert to 8 pixels
			pf8bit:  nBytes:=1;// 8bit, PByteArray     // byte pallette, 253 out of 256 colors; depends on display mode, needs truecolor ;
//	pf15bit: nBytes:=2;// 15bit,PWordArrayType // 0rrrrr ggggg bbbbb  0+5+5+5
			pf16bit: nBytes:=2;// 16bit,PWordArrayType // rrrrr gggggg bbbbb  5+6+5
//	pf24bit: nBytes:=3;// 24bit,pRGBtripleArray// bbbbbbbb gggggggg rrrrrrrr  8+8+8
			pf32bit: nBytes:=4;// 32bit,pRGBquadArray  // bbbbbbbb gggggggg rrrrrrrr aaaaaaaa 8+8+8+alpha
											   // can assign 'Single' reals to this for generating displays/plasma!
//    pfCustom: begin  //handle only pixelbits= 1..8,16,24,32  //10/31/00
//        GetObject( Handle, SizeOf(DIB), @DIB );
//        nbits := DIB.dsBmih.biSizeImage;
//        nbytes := nbits div 8;
//        if (nbytes>0)and(nbits mod 8 <> 0) then exit;//ignore if invalid
//      end;// pfcustom

			else exit;// 10/31/00 ignore invalid formats
		end;// case

// BitmapRotated.PixelFormat is the same as BitmapOriginal.PixelFormat;
// IF PixelFormat is less than 8 bit, then BitMapOriginal.PixelFormat = pf8Bit,
//  because Delphi can't index to bits, just bytes;
// The next time BitMapOriginal is used it will already be converted.
//( bmp storage may increase by factor of n*n, where n=8/(no. bits per pixel)  )
	if nBytes=0 then PixelFormat := pf8bit; //note that input bmp is changed

//assign copies all properties, including pallette and transparency   11/7/00
//fix bug 1/30/00 where BitMapOriginal was overwritten bec. pointer was copied
  BitmapRotated.Assign( BitMapOriginal);

//COUNTERCLOCKWISE rotation angle in radians. 12/10/99
	 sinTheta := SIN( theta ); cosTheta := COS( theta );
//SINCOS( theta, sinTheta, cosTheta ) ; math.pas requires extended reals.

//calculate the enclosing rectangle  12/15/00
	NewWidth  := ABS( ROUND( Height*sinTheta) ) + ABS( ROUND( Width*cosTheta ) );
	NewHeight := ABS( ROUND( Width*sinTheta ) ) + ABS( ROUND( Height*cosTheta) );

//diff size bitmaps have diff resolution of angle, ie r*sin(theta)<1 pixel
//use the small angle approx: sin(theta) ~~ theta   //11/7/00
  if ( ABS(theta)*MAX( width,height ) ) > 1 then
  begin//non-zero rotation

//set output bitmap formats; we do not assume a fixed format or size 1/6/00
	BitmapRotated.Width  := NewWidth;   //resize it for rotation
	BitmapRotated.Height := NewHeight;
//center of rotation is center of bitmap
  iRotationAxis := width div 2;
  jRotationAxis := height div 2;

//local constants for loop, each was hit at least width*height times   1/8/00
	Rwi := NewWidth - 1; //right column index
	Rht := NewHeight - 1;//bottom row index
	Owi := Width - 1;    //transp color column index
	Oht := Height - 1;   //transp color row  index

//Transparent pixel color used for out of range pixels 1/8/00
//how to translate a Bitmap.TransparentColor=Canvas.Pixels[0, Height - 1];
// from Tcolor into pixelformat..
        // force transparent to black
        PWordArray  ( Scanline[ Oht ] )[0]:=0;
        if nBytes>2 then PWordArray  ( Scanline[ Oht ] )[1]:=0;
	case nBytes of
		0,1:TransparentB := PByteArray     ( Scanline[ Oht ] )[0];
		2:	TransparentW := PWordArray     ( Scanline[ Oht ] )[0];
//		3:	TransparentT := pRGBtripleArray( Scanline[ Oht ] )[0];
		4:	TransparentQ := pRGBquadArray  ( Scanline[ Oht ] )[0];
	end;//case *)

// Step through each row of rotated image.
	FOR j := Rht DOWNTO 0 DO   //1/8/00
	BEGIN //for j

		case nBytes of  //1/6/00
		0,1:RowRotatedB := BitmapRotated.Scanline[ j ] ;
		2:	RowRotatedW := BitmapRotated.Scanline[ j ] ;
//		3:	RowRotatedT := BitmapRotated.Scanline[ j ] ;
		4:	RowRotatedQ := BitmapRotated.Scanline[ j ] ;
		end;//case

	// offset origin by the growth factor     //12/25/99
	//	jPrime := 2*(j - (NewHeight - Height) div 2 - jRotationAxis) + 1 ;
		jPrime := 2*j - NewHeight + 1 ;

	// Step through each column of rotated image
		FOR i := Rwi DOWNTO 0 DO   //1/8/00
		BEGIN //for i

			// offset origin by the growth factor  //12/25/99
			//iPrime := 2*(i - (NewWidth - Width) div 2 - iRotationAxis ) + 1;
      iPrime := 2*i - NewWidth   + 1;

			// Rotate (iPrime, jPrime) to location of desired pixel	(iPrimeRotated,jPrimeRotated)
			// Transform back to pixel coordinates of image, including translation
			// of origin from axis of rotation to origin of image.
//iOriginal := ( ROUND( iPrime*CosTheta - jPrime*sinTheta ) - 1) DIV 2 + iRotationAxis;
//jOriginal := ( ROUND( iPrime*sinTheta + jPrime*cosTheta ) - 1) DIV 2 + jRotationAxis;
			iOriginal := ( ROUND( iPrime*CosTheta - jPrime*sinTheta ) -1 + width ) DIV 2;
			jOriginal := ( ROUND( iPrime*sinTheta + jPrime*cosTheta ) -1 + height) DIV 2 ;

			// Make sure (iOriginal, jOriginal) is in BitmapOriginal.  If not,
			// assign background color to corner points.
			IF   ( iOriginal >= 0 ) AND ( iOriginal <= Owi ) AND
					 ( jOriginal >= 0 ) AND ( jOriginal <= Oht )    //1/8/00
			THEN BEGIN //inside
				// Assign pixel from rotated space to current pixel in BitmapRotated
				//( nearest neighbor interpolation)
				case nBytes of  //get pixel bytes according to pixel format   1/6/00
				0,1:RowRotatedB[i] := pByteArray(      scanline[joriginal] )[iOriginal];
				2:	RowRotatedW[i] := pWordArray(      Scanline[jOriginal] )[iOriginal];
//				3:	RowRotatedT[i] := pRGBtripleArray( Scanline[jOriginal] )[iOriginal];
				4:	RowRotatedQ[i] := pRGBquadArray(   Scanline[jOriginal] )[iOriginal];
				end;//case
			END //inside
			ELSE	BEGIN //outside

//12/10/99 set background corner color to transparent (lower left corner)
//	RowRotated[i]:=tpixelformat(BitMapOriginal.TRANSPARENTCOLOR) ; wont work
				case nBytes of
				0,1:RowRotatedB[i] := TransparentB;
				2:	RowRotatedW[i] := TransparentW;
//				3:	RowRotatedT[i] := TransparentT;
				4:	RowRotatedQ[i] := TransparentQ;
				end;//case
			END //if inside

		END //for i
	END;//for j
  end;//non-zero rotation

//offset to the apparent center of rotation   11/12/00 12/25/99
//rotate/translate the old bitmap origin to the new bitmap origin,FIXED 11/12/00
  sicoPhi := sicodiPoint(  POINT( width div 2, height div 2 ),oldaxis );
  //sine/cosine/dist of axis point from center point
  with sicoPhi do begin
//NewAxis := NewCenter + dist* <sin( theta+phi ),cos( theta+phi )>
    NewAxis.x := newWidth div 2 + ROUND( di*(CosTheta*co - SinTheta*si) );
    NewAxis.y := newHeight div 2- ROUND( di*(SinTheta*co + CosTheta*si) );//flip yaxis
  end;

end;//with

END; {RotateImage}

{=============================================================================}

Procedure BitmapRotation(bmp,rbmp: TBitmap; Rotation:double);
var np :tpoint;
begin
Rotation:=rmod(Rotation+pi2,pi2);
RotateBitmap(bmp,rbmp,Rotation,point(bmp.Width div 2, bmp.Height div 2),np);
end;

procedure BitmapRotMask(imamask,rbmp,bmp: tbitmap; Rotation:double);
// prepare a mask for the rotated part of the bitmap, allow transparency of the new bitmap edges.
var ci,si:extended;
    p: array[0..3] of Tpoint;
begin
imamask.Width:=rbmp.width;
imamask.Height:=rbmp.height;
imamask.canvas.brush.style:=bssolid;
imamask.canvas.pen.width:=1;
imamask.canvas.pen.color:=clwhite;
imamask.canvas.brush.color:=clwhite;
imamask.canvas.rectangle(0,0,imamask.Width,imamask.Height);
imamask.canvas.pen.color:=clblack;
imamask.canvas.brush.color:=clblack;
sincos(Rotation,si,ci);
ci:=abs(ci);
si:=abs(si);
if rmod(Rotation+pi2,pi2)>pi then begin
p[0].X:=round(bmp.height*si);
p[0].Y:=0;
p[1].X:=imamask.width;
p[1].Y:=round(bmp.width*si);
p[2].X:=round(bmp.width*ci);
p[2].Y:=imamask.height;
p[3].X:=0;
p[3].Y:=round(bmp.height*ci);
end else begin
p[0].X:=round(bmp.width*ci);
p[0].Y:=0;
p[1].X:=imamask.width;
p[1].Y:=round(bmp.height*ci);
p[2].X:=round(bmp.height*si);
p[2].Y:=imamask.height;
p[3].X:=0;
p[3].Y:=round(bmp.width*si);
end;
imamask.canvas.polygon(p);
end;

procedure BitmapBlackMask(imamask,bmp: tbitmap);
// prepare a mask with the part of the original bitmap that are really black (rbg=0), for background transparency
type TRGBQuadArray = array [0..32767]  of TRGBQuad;
     pRGBQuadArray = ^TRGBQuadArray;
var i,j : integer;
    P,Q : pRGBQuadArray ;
begin
imamask.PixelFormat:=bmp.PixelFormat;
imamask.Width:=bmp.width;
imamask.Height:=bmp.height;
for i:=0 to bmp.Height-1 do begin
    P:=bmp.ScanLine[i];
    Q:=imamask.ScanLine[i];
    for j:=0 to bmp.width-1 do begin
      if (P[j].rgbBlue<1)and(P[j].rgbGreen<1)and(P[j].rgbRed<1)
        then begin
           Q[j].rgbBlue:=255;
           Q[j].rgbGreen:=255;
           Q[j].rgbRed:=255;
        end else begin
           Q[j].rgbBlue:=0;
           Q[j].rgbGreen:=0;
           Q[j].rgbRed:=0;
        end;
    end;
end;
end;


end.

