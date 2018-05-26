unit u_290;
{HNSKY reads star databases type .290}
{Copyright (C) 2017,2018 by Han Kleijn, www.hnsky.org
 email: han.k.. at...hnsky.org

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
}

{$mode delphi}

interface

uses
  Classes, SysUtils, math;


var
  area290:integer;           {290 files, should be set at 290+1 for before any read series}
  cos_telescope_dec : double;{store here the cos(telescope_dec) value before and read series}
  database2         : array[0..(11*10)] of ansichar;{info star database, length 110 char equals 10x11 bytes}
  naam2             : string; {contains star designation after read for records size above 7}
  catalog_path      : string; {path to the .290 files}
  RA_290,DE_290,FOV_290,MAG_290: double;

const
   maxmag   : integer=999; {magnitude*10, limiting magnitude can be set lower for mouse click search}


// searchmode [S,T] specify S = screen update within FOV or T for full (designation text) database access.
// telescope_ra, telescope_dec [radians], contains to center position of the field of interest
// field_diameter [radians], FOV diameter of field of interest. This is ignored in searchmode=T}
// ra, dec [radians],   reported star position
// mag2 [magnitude*10]  reported star magnitude
// result [true/false]  if reported true more stars available. If false no more stars available
// extra outputs:
//          naam2,  string containing the star Tycho/UCAC4 designation for record size above 7
//          database2  : array[0..(11*10)] of ansichar;{text info star database used}
// preconditions:
//   area290 should be set at 290+1 before any read series
//   cos_telescope_dec, double variable should contains the cos(telescope_dec) to detect if star read is within the FOV diameter}
//   maxmag [magnitude*10], double variable which specifies the maximum magnitude to be read. This is typical used in HNSKY if a star designation needs to be reported after a mouse click on it

function readdatabase290(searchmode:char; telescope_ra,telescope_dec, field_diameter:double; var ra2,dec2, mag2 : double): boolean;{star 290 file database search}



//The format of the 290 star databases is described in the HNSKY help file
//
//The sky is divided in 290 areas of equal surface except for the poles which are half of that size.
//The stars are stored in these 290 separate files and sorted from bright to faint. Each file starts with a header of 110 bytes of which the first part contains a textual description and the last byte contains the record size, 6, 7, 10 or 11 bytes.
//The source of the utility program to make star databases is provided.
//
//The 290 area's:
//The areas are based on an mathematical method described in a paper of the PHILLIPS LABORATORY called "THE DIVISION OF A CIRCLE OR SPHERICAL SURFACE INTO EQUAL-AREA CELLS OR PIXELS" by Irving I. Gringorten Penelope J. Yepez on 30 June 1992
//First circles of constant declination are assumed. The first sphere segment defined by circle with number 1 has a height h1 from the pole and a surface of 2*pi*h1.
//If the second circle of constant declination has a sphere segment with a height of 9*h1 then the surface area of the second sphere segment is nine times higher equal 2*pi*9*h1.
//If the area between circle 1 en 2 is divided in 8 segments then these eight have the same area as the area of the first segment.
//The same is possible for the third circle by diving it in 16 segments, then in 24, 32, 40, 48, 56, 64 segments.
//The area of the third segment is 2*pi*25*h1, where 25 equals 1+8+16. So the sphere segments have a height of h1, 9*h1, 25*h1, 49*h1.
//The height of h1=1-sin(declination). All areas are equal area but rectangle.
//In HNSKY all area's are a combination of two except for the polar areas to have a more square shape especially around the equator.
//The south pole is stored in file 0101.290 Area A2 and A3 are stored in file 02_01.290, area A4 and A5 are stored in file 0202.290.
//The distances between the circles is pretty constant and around 10 to 12 degrees. The distance between the area centres is around 15 degrees maximum.
//The declinations are calculated by arcsin (1-1/289), arcsin(1-(1+8)/289), arcsin (1-(1+8+16)/289), arcsin(1-(1+8+16+24)/289)...

type
  hnskyhdr290_11 = packed record {This format is normally not used}
             nr32: integer; {Star number containing the Tycho/GSC or UCAC4 designation}
             ra7 : byte;    {The RA is stored as a 3 bytes word. The DEC position is stored as a two's complement (=standard), three bytes integer. The resolution of this three byte storage will be for RA: 360*60*60/((256*256*256)-1) = 0.077 arc seconds. For the DEC value it will be: 90*60*60/((128*256*256)-1) = 0.039 arc seconds.}
             ra8 : byte;
             ra9 : byte;
             dec7: byte;
             dec8: byte;    {note with word and smallint, delphi makes longer records !!!}
             dec9: shortint;
             mag0: shortint;

   end;
type
  hnskyhdr290_10 = packed record {This format is used for the Tycho2++ database up to magnitude 12.5}
             nr32: integer; {Star number containing the Tycho/GSC or UCAC4 designation}
             ra7 : byte;
             ra8 : byte;
             ra9 : byte;
             dec7: byte;
             dec8: byte;
             dec9: shortint;
   end;
  hnskyhdr290_9 = packed record  {Used TUC, for Tycho & UCAC4 database up to magnitude 15}
             nr32: integer; {Star number containing the Tycho/GSC or UCAC4 designation}
             ra7 : byte;
             ra8 : byte;
             ra9 : byte;
             dec7: byte;
             dec8: byte;
   end;

  hnskyhdr290_7 = packed record  {This format is normally not used}
             ra7 : byte;
             ra8 : byte;
             ra9 : byte;
             dec7: byte;
             dec8: byte;
             dec9: shortint;
             mag0: shortint;
  end;
  hnskyhdr290_6 = packed record  {Interim format normally not used}
             ra7 : byte; {The RA is stored as a 3 bytes word. The DEC position is stored as a two's complement (=standard), three bytes integer. The resolution of this three byte storage will be for RA: 360*60*60/((256*256*256)-1) = 0.077 arc seconds. For the DEC value it will be: 90*60*60/((128*256*256)-1) = 0.039 arc seconds.}
             ra8 : byte;
             ra9 : byte;
             dec7: byte;
             dec8: byte;
             dec9: shortint;
   end;
  hnskyhdr290_5 = packed record  {Most compact format, used for Gaia}
              ra7 : byte;
              ra8 : byte;
              ra9 : byte;
              dec7: byte;
              dec8: byte;
    end;



var
  nr_records             : integer;
  name_star              : string;
  files_available        : boolean;

const
  file_open: integer=0;
  area2    : double=1*pi/180; {search area}

implementation


Const

AA=  -90.0 * pi/180;
BB=-(85.23224404+75.66348756)/2 * pi/180;
CC=-(75.66348756+65.99286637)/2 * pi/180;
DD=-(65.99286637+56.14497387)/2 * pi/180;
EE=-(56.14497387+46.03163067)/2 * pi/180;
FF=-(46.03163067+35.54307745)/2 * pi/180;
GG=-(35.54307745+24.53348115)/2 * pi/180;
HH=-(24.53348115+12.79440589)/2 * pi/180;
II=-(12.79440589+0	)/2 * pi/180;


centers290 : array[1..290,1..2] of real= {divide sky in 32 area's, 12 pentagon, 20 hexagon figures}

 (( 0 *pi/180, +AA),  {1  south pole }

 (360*0.5/4*pi/180, +BB),  {4 circle segments}
 (360*1.5/4*pi/180, +BB),
 (360*2.5/4*pi/180, +BB),
 (360*3.5/4*pi/180, +BB),

 (360*0.5/8*pi/180, +CC),  {8 circel segments}
 (360*1.5/8*pi/180, +CC),
 (360*2.5/8*pi/180, +CC),
 (360*3.5/8*pi/180, +CC),
 (360*4.5/8*pi/180, +CC),
 (360*5.5/8*pi/180, +CC),
 (360*6.5/8*pi/180, +CC),
 (360*7.5/8*pi/180, +CC),

 (360*0.5/12*pi/180, +DD),  {12 circle segments}
 (360*1.5/12*pi/180, +DD),
 (360*2.5/12*pi/180, +DD),
 (360*3.5/12*pi/180, +DD),
 (360*4.5/12*pi/180, +DD),
 (360*5.5/12*pi/180, +DD),
 (360*6.5/12*pi/180, +DD),
 (360*7.5/12*pi/180, +DD),
 (360*8.5/12*pi/180, +DD),
 (360*9.5/12*pi/180, +DD),
 (360*10.5/12*pi/180, +DD),
 (360*11.5/12*pi/180, +DD),

 (360*0.5/16*pi/180, +EE),  {16 circel segments}
 (360*1.5/16*pi/180, +EE),
 (360*2.5/16*pi/180, +EE),
 (360*3.5/16*pi/180, +EE),
 (360*4.5/16*pi/180, +EE),
 (360*5.5/16*pi/180, +EE),
 (360*6.5/16*pi/180, +EE),
 (360*7.5/16*pi/180, +EE),
 (360*8.5/16*pi/180, +EE),
 (360*9.5/16*pi/180, +EE),
 (360*10.5/16*pi/180, +EE),
 (360*11.5/16*pi/180, +EE),
 (360*12.5/16*pi/180, +EE),
 (360*13.5/16*pi/180, +EE),
 (360*14.5/16*pi/180, +EE),
 (360*15.5/16*pi/180, +EE),

 (360*0.5/20*pi/180, +FF),  {20 circle segments}
 (360*1.5/20*pi/180, +FF),
 (360*2.5/20*pi/180, +FF),
 (360*3.5/20*pi/180, +FF),
 (360*4.5/20*pi/180, +FF),
 (360*5.5/20*pi/180, +FF),
 (360*6.5/20*pi/180, +FF),
 (360*7.5/20*pi/180, +FF),
 (360*8.5/20*pi/180, +FF),
 (360*9.5/20*pi/180, +FF),
 (360*10.5/20*pi/180, +FF),
 (360*11.5/20*pi/180, +FF),
 (360*12.5/20*pi/180, +FF),
 (360*13.5/20*pi/180, +FF),
 (360*14.5/20*pi/180, +FF),
 (360*15.5/20*pi/180, +FF),
 (360*16.5/20*pi/180, +FF),
 (360*17.5/20*pi/180, +FF),
 (360*18.5/20*pi/180, +FF),
 (360*19.5/20*pi/180, +FF),

 (360*0.5/24*pi/180, +GG),  {24circle segments}
 (360*1.5/24*pi/180, +GG),
 (360*2.5/24*pi/180, +GG),
 (360*3.5/24*pi/180, +GG),
 (360*4.5/24*pi/180, +GG),
 (360*5.5/24*pi/180, +GG),
 (360*6.5/24*pi/180, +GG),
 (360*7.5/24*pi/180, +GG),
 (360*8.5/24*pi/180, +GG),
 (360*9.5/24*pi/180, +GG),
 (360*10.5/24*pi/180, +GG),
 (360*11.5/24*pi/180, +GG),
 (360*12.5/24*pi/180, +GG),
 (360*13.5/24*pi/180, +GG),
 (360*14.5/24*pi/180, +GG),
 (360*15.5/24*pi/180, +GG),
 (360*16.5/24*pi/180, +GG),
 (360*17.5/24*pi/180, +GG),
 (360*18.5/24*pi/180, +GG),
 (360*19.5/24*pi/180, +GG),
 (360*20.5/24*pi/180, +GG),
 (360*21.5/24*pi/180, +GG),
 (360*22.5/24*pi/180, +GG),
 (360*23.5/24*pi/180, +GG),


 (360*0.5/28*pi/180, +HH),  {28 circle segments}
 (360*1.5/28*pi/180, +HH),
 (360*2.5/28*pi/180, +HH),
 (360*3.5/28*pi/180, +HH),
 (360*4.5/28*pi/180, +HH),
 (360*5.5/28*pi/180, +HH),
 (360*6.5/28*pi/180, +HH),
 (360*7.5/28*pi/180, +HH),
 (360*8.5/28*pi/180, +HH),
 (360*9.5/28*pi/180, +HH),
 (360*10.5/28*pi/180, +HH),
 (360*11.5/28*pi/180, +HH),
 (360*12.5/28*pi/180, +HH),
 (360*13.5/28*pi/180, +HH),
 (360*14.5/28*pi/180, +HH),
 (360*15.5/28*pi/180, +HH),
 (360*16.5/28*pi/180, +HH),
 (360*17.5/28*pi/180, +HH),
 (360*18.5/28*pi/180, +HH),
 (360*19.5/28*pi/180, +HH),
 (360*20.5/28*pi/180, +HH),
 (360*21.5/28*pi/180, +HH),
 (360*22.5/28*pi/180, +HH),
 (360*23.5/28*pi/180, +HH),
 (360*24.5/28*pi/180, +HH),
 (360*25.5/28*pi/180, +HH),
 (360*26.5/28*pi/180, +HH),
 (360*27.5/28*pi/180, +HH),

 (360*0.5/32*pi/180, +II),  {32 circle segments}
 (360*1.5/32*pi/180, +II),
 (360*2.5/32*pi/180, +II),
 (360*3.5/32*pi/180, +II),
 (360*4.5/32*pi/180, +II),
 (360*5.5/32*pi/180, +II),
 (360*6.5/32*pi/180, +II),
 (360*7.5/32*pi/180, +II),
 (360*8.5/32*pi/180, +II),
 (360*9.5/32*pi/180, +II),
 (360*10.5/32*pi/180, +II),
 (360*11.5/32*pi/180, +II),
 (360*12.5/32*pi/180, +II),
 (360*13.5/32*pi/180, +II),
 (360*14.5/32*pi/180, +II),
 (360*15.5/32*pi/180, +II),
 (360*16.5/32*pi/180, +II),
 (360*17.5/32*pi/180, +II),
 (360*18.5/32*pi/180, +II),
 (360*19.5/32*pi/180, +II),
 (360*20.5/32*pi/180, +II),
 (360*21.5/32*pi/180, +II),
 (360*22.5/32*pi/180, +II),
 (360*23.5/32*pi/180, +II),
 (360*24.5/32*pi/180, +II),
 (360*25.5/32*pi/180, +II),
 (360*26.5/32*pi/180, +II),
 (360*27.5/32*pi/180, +II),
 (360*28.5/32*pi/180, +II),
 (360*29.5/32*pi/180, +II),
 (360*30.5/32*pi/180, +II),
 (360*31.5/32*pi/180, +II),

 (360*0.5/32*pi/180, -II),  {32 circle segments}
 (360*1.5/32*pi/180, -II),
 (360*2.5/32*pi/180, -II),
 (360*3.5/32*pi/180, -II),
 (360*4.5/32*pi/180, -II),
 (360*5.5/32*pi/180, -II),
 (360*6.5/32*pi/180, -II),
 (360*7.5/32*pi/180, -II),
 (360*8.5/32*pi/180, -II),
 (360*9.5/32*pi/180, -II),
 (360*10.5/32*pi/180, -II),
 (360*11.5/32*pi/180, -II),
 (360*12.5/32*pi/180, -II),
 (360*13.5/32*pi/180, -II),
 (360*14.5/32*pi/180, -II),
 (360*15.5/32*pi/180, -II),
 (360*16.5/32*pi/180, -II),
 (360*17.5/32*pi/180, -II),
 (360*18.5/32*pi/180, -II),
 (360*19.5/32*pi/180, -II),
 (360*20.5/32*pi/180, -II),
 (360*21.5/32*pi/180, -II),
 (360*22.5/32*pi/180, -II),
 (360*23.5/32*pi/180, -II),
 (360*24.5/32*pi/180, -II),
 (360*25.5/32*pi/180, -II),
 (360*26.5/32*pi/180, -II),
 (360*27.5/32*pi/180, -II),
 (360*28.5/32*pi/180, -II),
 (360*29.5/32*pi/180, -II),
 (360*30.5/32*pi/180, -II),
 (360*31.5/32*pi/180, -II),

 (360*0.5/28*pi/180, -HH),  {28 circle segments}
 (360*1.5/28*pi/180, -HH),
 (360*2.5/28*pi/180, -HH),
 (360*3.5/28*pi/180, -HH),
 (360*4.5/28*pi/180, -HH),
 (360*5.5/28*pi/180, -HH),
 (360*6.5/28*pi/180, -HH),
 (360*7.5/28*pi/180, -HH),
 (360*8.5/28*pi/180, -HH),
 (360*9.5/28*pi/180, -HH),
 (360*10.5/28*pi/180, -HH),
 (360*11.5/28*pi/180, -HH),
 (360*12.5/28*pi/180, -HH),
 (360*13.5/28*pi/180, -HH),
 (360*14.5/28*pi/180, -HH),
 (360*15.5/28*pi/180, -HH),
 (360*16.5/28*pi/180, -HH),
 (360*17.5/28*pi/180, -HH),
 (360*18.5/28*pi/180, -HH),
 (360*19.5/28*pi/180, -HH),
 (360*20.5/28*pi/180, -HH),
 (360*21.5/28*pi/180, -HH),
 (360*22.5/28*pi/180, -HH),
 (360*23.5/28*pi/180, -HH),
 (360*24.5/28*pi/180, -HH),
 (360*25.5/28*pi/180, -HH),
 (360*26.5/28*pi/180, -HH),
 (360*27.5/28*pi/180, -HH),

 (360*0.5/24*pi/180, -GG),  {24 circle segments}
 (360*1.5/24*pi/180, -GG),
 (360*2.5/24*pi/180, -GG),
 (360*3.5/24*pi/180, -GG),
 (360*4.5/24*pi/180, -GG),
 (360*5.5/24*pi/180, -GG),
 (360*6.5/24*pi/180, -GG),
 (360*7.5/24*pi/180, -GG),
 (360*8.5/24*pi/180, -GG),
 (360*9.5/24*pi/180, -GG),
 (360*10.5/24*pi/180, -GG),
 (360*11.5/24*pi/180, -GG),
 (360*12.5/24*pi/180, -GG),
 (360*13.5/24*pi/180, -GG),
 (360*14.5/24*pi/180, -GG),
 (360*15.5/24*pi/180, -GG),
 (360*16.5/24*pi/180, -GG),
 (360*17.5/24*pi/180, -GG),
 (360*18.5/24*pi/180, -GG),
 (360*19.5/24*pi/180, -GG),
 (360*20.5/24*pi/180, -GG),
 (360*21.5/24*pi/180, -GG),
 (360*22.5/24*pi/180, -GG),
 (360*23.5/24*pi/180, -GG),

 (360*0.5/20*pi/180, -FF),  {20 circle segments}
 (360*1.5/20*pi/180, -FF),
 (360*2.5/20*pi/180, -FF),
 (360*3.5/20*pi/180, -FF),
 (360*4.5/20*pi/180, -FF),
 (360*5.5/20*pi/180, -FF),
 (360*6.5/20*pi/180, -FF),
 (360*7.5/20*pi/180, -FF),
 (360*8.5/20*pi/180, -FF),
 (360*9.5/20*pi/180, -FF),
 (360*10.5/20*pi/180, -FF),
 (360*11.5/20*pi/180, -FF),
 (360*12.5/20*pi/180, -FF),
 (360*13.5/20*pi/180, -FF),
 (360*14.5/20*pi/180, -FF),
 (360*15.5/20*pi/180, -FF),
 (360*16.5/20*pi/180, -FF),
 (360*17.5/20*pi/180, -FF),
 (360*18.5/20*pi/180, -FF),
 (360*19.5/20*pi/180, -FF),

 (360*0.5/16*pi/180, -EE),  {16 circle segments}
 (360*1.5/16*pi/180, -EE),
 (360*2.5/16*pi/180, -EE),
 (360*3.5/16*pi/180, -EE),
 (360*4.5/16*pi/180, -EE),
 (360*5.5/16*pi/180, -EE),
 (360*6.5/16*pi/180, -EE),
 (360*7.5/16*pi/180, -EE),
 (360*8.5/16*pi/180, -EE),
 (360*9.5/16*pi/180, -EE),
 (360*10.5/16*pi/180, -EE),
 (360*11.5/16*pi/180, -EE),
 (360*12.5/16*pi/180, -EE),
 (360*13.5/16*pi/180, -EE),
 (360*14.5/16*pi/180, -EE),
 (360*15.5/16*pi/180, -EE),

 (360*0.5/12*pi/180, -DD),  {12 circle segments}
 (360*1.5/12*pi/180, -DD),
 (360*2.5/12*pi/180, -DD),
 (360*3.5/12*pi/180, -DD),
 (360*4.5/12*pi/180, -DD),
 (360*5.5/12*pi/180, -DD),
 (360*6.5/12*pi/180, -DD),
 (360*7.5/12*pi/180, -DD),
 (360*8.5/12*pi/180, -DD),
 (360*9.5/12*pi/180, -DD),
 (360*10.5/12*pi/180, -DD),
 (360*11.5/12*pi/180, -DD),

 (360*0.5/8*pi/180, -CC),  {8 circle segments}
 (360*1.5/8*pi/180, -CC),
 (360*2.5/8*pi/180, -CC),
 (360*3.5/8*pi/180, -CC),
 (360*4.5/8*pi/180, -CC),
 (360*5.5/8*pi/180, -CC),
 (360*6.5/8*pi/180, -CC),
 (360*7.5/8*pi/180, -CC),

  (360*0.5/4*pi/180, -BB),  {4 circle segments}
 (360*1.5/4*pi/180, -BB),
 (360*2.5/4*pi/180, -BB),
 (360*3.5/4*pi/180, -BB),


 ( 0        , -AA   )); {1 segment}   {north pole }


filenames290 : array[1..290] of string= {}
(('0101.290'),

 ('0201.290'),  {combined cells from 8}
 ('0202.290'),
 ('0203.290'),
 ('0204.290'),

 ('0301.290'),
 ('0302.290'),
 ('0303.290'),
 ('0304.290'),
 ('0305.290'),
 ('0306.290'),
 ('0307.290'),
 ('0308.290'),

 ('0401.290'),
 ('0402.290'),
 ('0403.290'),
 ('0404.290'),
 ('0405.290'),
 ('0406.290'),
 ('0407.290'),
 ('0408.290'),
 ('0409.290'),
 ('0410.290'),
 ('0411.290'),
 ('0412.290'),

 ('0501.290'),
 ('0502.290'),
 ('0503.290'),
 ('0504.290'),
 ('0505.290'),
 ('0506.290'),
 ('0507.290'),
 ('0508.290'),
 ('0509.290'),
 ('0510.290'),
 ('0511.290'),
 ('0512.290'),
 ('0513.290'),
 ('0514.290'),
 ('0515.290'),
 ('0516.290'),

 ('0601.290'),
 ('0602.290'),
 ('0603.290'),
 ('0604.290'),
 ('0605.290'),
 ('0606.290'),
 ('0607.290'),
 ('0608.290'),
 ('0609.290'),
 ('0610.290'),
 ('0611.290'),
 ('0612.290'),
 ('0613.290'),
 ('0614.290'),
 ('0615.290'),
 ('0616.290'),
 ('0617.290'),
 ('0618.290'),
 ('0619.290'),
 ('0620.290'),

 ('0701.290'),
 ('0702.290'),
 ('0703.290'),
 ('0704.290'),
 ('0705.290'),
 ('0706.290'),
 ('0707.290'),
 ('0708.290'),
 ('0709.290'),
 ('0710.290'),
 ('0711.290'),
 ('0712.290'),
 ('0713.290'),
 ('0714.290'),
 ('0715.290'),
 ('0716.290'),
 ('0717.290'),
 ('0718.290'),
 ('0719.290'),
 ('0720.290'),
 ('0721.290'),
 ('0722.290'),
 ('0723.290'),
 ('0724.290'),

 ('0801.290'),
 ('0802.290'),
 ('0803.290'),
 ('0804.290'),
 ('0805.290'),
 ('0806.290'),
 ('0807.290'),
 ('0808.290'),
 ('0809.290'),
 ('0810.290'),
 ('0811.290'),
 ('0812.290'),
 ('0813.290'),
 ('0814.290'),
 ('0815.290'),
 ('0816.290'),
 ('0817.290'),
 ('0818.290'),
 ('0819.290'),
 ('0820.290'),
 ('0821.290'),
 ('0822.290'),
 ('0823.290'),
 ('0824.290'),
 ('0825.290'),
 ('0826.290'),
 ('0827.290'),
 ('0828.290'),

 ('0901.290'),
 ('0902.290'),
 ('0903.290'),
 ('0904.290'),
 ('0905.290'),
 ('0906.290'),
 ('0907.290'),
 ('0908.290'),
 ('0909.290'),
 ('0910.290'),
 ('0911.290'),
 ('0912.290'),
 ('0913.290'),
 ('0914.290'),
 ('0915.290'),
 ('0916.290'),
 ('0917.290'),
 ('0918.290'),
 ('0919.290'),
 ('0920.290'),
 ('0921.290'),
 ('0922.290'),
 ('0923.290'),
 ('0924.290'),
 ('0925.290'),
 ('0926.290'),
 ('0927.290'),
 ('0928.290'),
 ('0929.290'),
 ('0930.290'),
 ('0931.290'),
 ('0932.290'),

 ('1001.290'),
 ('1002.290'),
 ('1003.290'),
 ('1004.290'),
 ('1005.290'),
 ('1006.290'),
 ('1007.290'),
 ('1008.290'),
 ('1009.290'),
 ('1010.290'),
 ('1011.290'),
 ('1012.290'),
 ('1013.290'),
 ('1014.290'),
 ('1015.290'),
 ('1016.290'),
 ('1017.290'),
 ('1018.290'),
 ('1019.290'),
 ('1020.290'),
 ('1021.290'),
 ('1022.290'),
 ('1023.290'),
 ('1024.290'),
 ('1025.290'),
 ('1026.290'),
 ('1027.290'),
 ('1028.290'),
 ('1029.290'),
 ('1030.290'),
 ('1031.290'),
 ('1032.290'),

 ('1101.290'),
 ('1102.290'),
 ('1103.290'),
 ('1104.290'),
 ('1105.290'),
 ('1106.290'),
 ('1107.290'),
 ('1108.290'),
 ('1109.290'),
 ('1110.290'),
 ('1111.290'),
 ('1112.290'),
 ('1113.290'),
 ('1114.290'),
 ('1115.290'),
 ('1116.290'),
 ('1117.290'),
 ('1118.290'),
 ('1119.290'),
 ('1120.290'),
 ('1121.290'),
 ('1122.290'),
 ('1123.290'),
 ('1124.290'),
 ('1125.290'),
 ('1126.290'),
 ('1127.290'),
 ('1128.290'),

 ('1201.290'),
 ('1202.290'),
 ('1203.290'),
 ('1204.290'),
 ('1205.290'),
 ('1206.290'),
 ('1207.290'),
 ('1208.290'),
 ('1209.290'),
 ('1210.290'),
 ('1211.290'),
 ('1212.290'),
 ('1213.290'),
 ('1214.290'),
 ('1215.290'),
 ('1216.290'),
 ('1217.290'),
 ('1218.290'),
 ('1219.290'),
 ('1220.290'),
 ('1221.290'),
 ('1222.290'),
 ('1223.290'),
 ('1224.290'),

 ('1301.290'),
 ('1302.290'),
 ('1303.290'),
 ('1304.290'),
 ('1305.290'),
 ('1306.290'),
 ('1307.290'),
 ('1308.290'),
 ('1309.290'),
 ('1310.290'),
 ('1311.290'),
 ('1312.290'),
 ('1313.290'),
 ('1314.290'),
 ('1315.290'),
 ('1316.290'),
 ('1317.290'),
 ('1318.290'),
 ('1319.290'),
 ('1320.290'),

 ('1401.290'),
 ('1402.290'),
 ('1403.290'),
 ('1404.290'),
 ('1405.290'),
 ('1406.290'),
 ('1407.290'),
 ('1408.290'),
 ('1409.290'),
 ('1410.290'),
 ('1411.290'),
 ('1412.290'),
 ('1413.290'),
 ('1414.290'),
 ('1415.290'),
 ('1416.290'),

 ('1501.290'),
 ('1502.290'),
 ('1503.290'),
 ('1504.290'),
 ('1505.290'),
 ('1506.290'),
 ('1507.290'),
 ('1508.290'),
 ('1509.290'),
 ('1510.290'),
 ('1511.290'),
 ('1512.290'),

 ('1601.290'),
 ('1602.290'),
 ('1603.290'),
 ('1604.290'),
 ('1605.290'),
 ('1606.290'),
 ('1607.290'),
 ('1608.290'),


 ('1701.290'),
 ('1702.290'),
 ('1703.290'),
 ('1704.290'),

 ('1801.290'));

const
   record_size:integer=11;{default}
var
  p11       : ^hnskyhdr290_11;	    { pointer to hns0kyrecord }
  p10       : ^hnskyhdr290_10;	    { pointer to hns0kyrecord }
  p9        : ^hnskyhdr290_9;	    { pointer to hns0kyrecord }
  p7        : ^hnskyhdr290_7;	    { pointer to hns0kyrecord }
  p6        : ^hnskyhdr290_6;       { pointer to hns0kyrecord }
  p5        : ^hnskyhdr290_5;       { pointer to hns0kyrecord }
  dec9_storage: shortint;

  buf2: array[1..11] of byte;  {read buffer stars}
  thefile_stars      : tfilestream;
  Reader_stars       : TReader;

procedure ang_sep(ra1,dec1,ra2,dec2 : double;var sep: double);{version 2018-5-23, calculates angular separation. according formula 9.1 old Meeus or 16.1 new Meeus, version 2018-5-23}
var
  sin_dec1,cos_dec1,sin_dec2,cos_dec2, cos_sep:double;
begin
  sincos(dec1,sin_dec1,cos_dec1);{use sincos function for speed}
  sincos(dec2,sin_dec2,cos_dec2);

  cos_sep:=sin_dec1*sin_dec2+ cos_dec1*cos_dec2*cos(ra1-ra2);
  sep:=arccos(cos_sep);
end;

procedure closedatabase;
begin
  if file_open=2 then
  begin
    Reader_stars.free;  {was till 27.1.2000 destroy}
    thefile_stars.free;
    end;
  file_open:=0;
end;

// searchmode [S,T] specify S = screen update within FOV or T for full (designation text) database access.
// telescope_ra, telescope_dec [radians], contains to center position of the field of interest
// field_diameter [radians], FOV diameter of field of interest. This is ignored in searchmode=T}
// ra, dec [radians],   reported star position
// mag2 [magnitude*10]  reported star magnitude
// result [true/false]  if reported true then more stars are available. If false no more stars available.
// extra outputs:
//          naam2,  string containing the star Tycho/UCAC4 designation for record size above 7
//          database2  : array[0..(11*10)] of ansichar;{text info star database used}
// preconditions:
//   area290 should be set at 290+1 before any read series
//   cos_telescope_dec, double variable should contains the cos(telescope_dec) to detect if star read is within the FOV diameter}
//   maxmag [magnitude*10], double variable which specifies the maximum magnitude to be read. This is typical used in HNSKY if a star designation needs to be reported after a mouse click on it
function readdatabase290(searchmode:char; telescope_ra,telescope_dec, field_diameter:double; var ra2,dec2, mag2 : double): boolean;{star 290 file database search}
            {searchmode=S screen update }
            {searchmode=M mouse click  search}
            {searchmode=T text search}
  var
    nr_regio, nr_star,ra_raw,nr32store : integer;
    name_regio, naamst       : string; //array [0..7] of ansichar;
    delta_ra, sep, required_range  : double;
    nearbyarea,header_record: boolean;
    label      einde;
begin
   {$I-}

  readdatabase290:=true;
  repeat
    if  ( (file_open=0) or
          (nr_records<=0) or {here otherwise star at 0:0}

       ((searchmode<>'T') and (mag2>maxmag))
         )  then    {file_open ohterwise sometimes the file routine gets stucked}
      einde:
      begin
         if file_open<>0 then closedatabase;
         nearbyarea:=false;
         naam2:=''; {clear for 5, 6 and 7 bytes records to prevent ghost names}
         cos_telescope_dec:=cos(telescope_dec);{here to save CPU time}
         required_range:=field_diameter/2+(17.04/2)*pi/180;{maximum distance to next 290 field center is 17.04 degrees}

         while ((area290>1) and (nearbyarea=false)) do
         begin
           dec(area290);
           if searchmode='T' then nearbyarea:=true
           else
           begin {find nearby area's}
             ang_sep(telescope_ra,telescope_dec,centers290[area290,1],centers290[area290,2], sep );
             if sep<required_range then nearbyarea:=true;
           end;
         end; {while}

         if nearbyarea=false then begin
           readdatabase290:=false; exit; end;

         name_star:=copy(name_star,1,3)+'_'+filenames290[area290];{tyc0101.290}
         try
           thefile_stars:=tfilestream.Create( catalog_path+name_star, fmOpenRead );
           Reader_stars := TReader.Create (thefile_stars, 5*6*9*11);{number of hnsky records, multiply off all posible record sizes}
           {thefile_stars.size-reader.position>sizeof(hkyhdr) could also be used but slow down a factor of 2 !!!}
           files_available:=true;
         except
            readdatabase290:=false;
            files_available:=false;
            exit;
         end;
         file_open:=2; {buffer size is .. x 1024}
         reader_stars.read(database2,110); {read header info, 10x11 is 110 bytes}
         if database2[109]=' ' then record_size:=11 {default}
         else
         record_size:=ord(database2[109]);{5,6,7,9,10 or 11 bytes record}

         nr_records:= trunc((thefile_stars.size-110)/record_size);{110 header size, correct for above read}
      end;{einde}
    reader_stars.read(buf2,record_size);
    if file_open=0 then goto einde;
    header_record:=false;

    case record_size of
    5: begin {record size 5}
         with p5^ do
         begin
           ra_raw:=(ra7 + ra8 shl 8 +ra9 shl 16);{always required, fasted method}
           if ra_raw=$FFFFFF  then  {special magnitude record is found}
           begin
             mag2:=dec8-16;{new magn shifted 16 to make sirius and other positive}
             {magnitude is stored in mag2 till new magnitude record is found}
             dec9_storage:=dec7-128;{recover dec9 shortint and put it in storage}
            header_record:=true;
           end
           else
           begin {normal record without magnitude}
             ra2:= ra_raw*(pi*2  /((256*256*256)-1));
             dec2:=((dec9_storage shl 16)+(dec8 shl 8)+dec7)*(pi*0.5/((128*256*256)-1));// dec2:=(dec7+(dec8 shl 8)+(dec9 shl 16))*(pi*0.5/((128*256*256)-1)); {FPC compiler makes mistake, but dec7 behind}
             {The RA is stored as a 3 bytes word. The DEC position is stored as a two's complement (=standard), three bytes integer. The resolution of this three byte storage will be for RA: 360*60*60/((256*256*256)-1) = 0.077 arc seconds. For the DEC value it will be: 90*60*60/((128*256*256)-1) = 0.039 arc seconds.}
           end;
         end;
       end;{record size 5}
    6: begin {record size 6}
         with p6^ do
         begin
           ra_raw:=(ra7 + ra8 shl 8 +ra9 shl 16);{always required, fasted method}
           if ra_raw=$FFFFFF  then  {special magnitude record is found}
           begin
             if dec9>-20 then mag2:=dec9 else  mag2:=256+dec9;{new magn 12.8 is -12.8, 12.9 = -12.7}
            {magnitude is stored in mag2 till new magnitude record is found}
            header_record:=true;
           end
           else
           begin {normal record without magnitude}
             ra2:= ra_raw*(pi*2  /((256*256*256)-1));
             dec2:=((dec9 shl 16)+(dec8 shl 8)+dec7)*(pi*0.5/((128*256*256)-1));// dec2:=(dec7+(dec8 shl 8)+(dec9 shl 16))*(pi*0.5/((128*256*256)-1)); {FPC compiler makes mistake, put dec7 behind}
             {The RA is stored as a 3 bytes word. The DEC position is stored as a two's complement (=standard), three bytes integer. The resolution of this three byte storage will be for RA: 360*60*60/((256*256*256)-1) = 0.077 arc seconds. For the DEC value it will be: 90*60*60/((128*256*256)-1) = 0.039 arc seconds.}
           end;
         end;
       end;{record size 6}
    7: begin {record size 7}
         with p7^ do
         begin
           ra2:= (ra7 + ra8 shl 8 +ra9 shl 16)*(pi*2  /((256*256*256)-1));
           dec2:=((dec9 shl 16)+(dec8 shl 8)+dec7)*(pi*0.5/((128*256*256)-1));// dec2:=(dec7+(dec8 shl 8)+(dec9 shl 16))*(pi*0.5/((128*256*256)-1)); {FPC compiler makes mistake, put dec7 behind}
           if mag0>-20 then mag2:=mag0 else  mag2:=256+mag0;{new magn 12.8 is -12.8, 12.9 = -12.7}
         end;
       end;{record size 7}
    9: begin {record size 9}
          with p9^ do
          begin
            ra_raw:=(ra7 + ra8 shl 8 +ra9 shl 16);{always required, fasted method}
            if ra_raw=$FFFFFF  then  {special magnitude record is found}
            begin
              mag2:=dec8-16;{new magn shifted 16 to make sirius and other positive}
              {magnitude is stored in mag2 till new magnitude record is found}
              dec9_storage:=dec7-128;{recover dec9 shortint and put it in storage}
              header_record:=true;{not a star but a header with values for magnitude and dec9 for the next record}
            end
            else
            begin {normal record without magnitude}
              nr32store:=nr32;{store for later}
              ra2:= ra_raw*(pi*2  /((256*256*256)-1));
              dec2:=((dec9_storage shl 16)+(dec8 shl 8)+dec7)*(pi*0.5/((128*256*256)-1));// dec2:=(dec7+(dec8 shl 8)+(dec9 shl 16))*(pi*0.5/((128*256*256)-1)); {FPC compiler makes mistake, put dec7 behind}
              {The RA is stored as a 3 bytes word. The DEC position is stored as a two's complement (=standard), three bytes integer. The resolution of this three byte storage will be for RA: 360*60*60/((256*256*256)-1) = 0.077 arc seconds. For the DEC value it will be: 90*60*60/((128*256*256)-1) = 0.039 arc seconds.}
            end;{normal record without magnitude}
          end;{with P9^}
        end; {record size 9}

    10: begin {record size 10}
          with p10^ do
          begin
            ra_raw:=(ra7 + ra8 shl 8 +ra9 shl 16);{always required, fasted method}
            if ra_raw=$FFFFFF  then  {special magnitude record is found}
            begin
              if dec9>-20 then mag2:=dec9 else  mag2:=256+dec9;{new magn 12.8 is -12.8, 12.9 = -12.7}
             {magnitude is stored in mag2 till new magnitude record is found}
             header_record:=true;
            end
            else
            begin {normal record without magnitude}
              nr32store:=nr32;{store for later}
              ra2:= ra_raw*(pi*2  /((256*256*256)-1));
              dec2:=((dec9 shl 16)+(dec8 shl 8)+dec7)*(pi*0.5/((128*256*256)-1));// dec2:=(dec7+(dec8 shl 8)+(dec9 shl 16))*(pi*0.5/((128*256*256)-1)); {FPC compiler makes mistake, put dec7 behind}
            end;{normal record without magnitude}
          end;{with P10^}
        end; {record size 10}
   11: begin {record size 11}
         with p11^ do
         begin
           nr32store:=nr32;{store for later}
           ra2:= (ra7 + ra8 shl 8 +ra9 shl 16)*(pi*2  /((256*256*256)-1));
           dec2:=((dec9 shl 16)+(dec8 shl 8)+dec7)*(pi*0.5/((128*256*256)-1));// dec2:=(dec7+(dec8 shl 8)+(dec9 shl 16))*(pi*0.5/((128*256*256)-1)); {FPC compiler makes mistake, put dec7 behind}
           if mag0>-20 then mag2:=mag0 else  mag2:=256+mag0;{new magn 12.8 is -12.8, 12.9 = -12.7}
         end;{with P11^}
       end; {record size 11}
    end;{case}

    delta_ra:=abs(ra2-telescope_ra); if delta_ra>pi then delta_ra:=pi*2-delta_ra;
    dec(nr_records); {faster then  (thefile_stars.size-thefile_stars.position<sizeofhnskyhdr) !!!)}
  until
    (
    {$ifdef mswindows}
    //(getinputstate=true) or  {to be fixed for Linux} {used in HNSKY but not used in ASTAP)
    {$ELSE} {}
    {$endif}
    (
       (header_record=false) and
       ((searchmode='T') or  ( (abs(delta_ra*cos_telescope_dec)<field_diameter/2) and (abs(dec2-telescope_dec)<field_diameter/2))  )
                           {calculate distance and skip when to far from centre screen, {if false then outside screen,go quick to next line}
     ));
             {searchmode=S screen update}
             {searchmode=M mouse click  search}
             {searchmode=T text search}

  {name stars}
  if record_size>7 then {record contains naam/designation}
  begin
    if nr32store>0 then {ucac4 .290 style}
    begin
      {Designation: The star designation is stored in 32 bit integer named NR290. If the NR290 integer is positive, it contains an UCAC4 number. For UCAC4 the star zone is added as a multiply of $100000.  This allows $800 or 2048 zones and  $100000 or 1.048.576 stars. The UCAC4 contains maximum 286.833 stars in a zone and has 900 zones.}
      nr_regio:=(nr32store and $FFF00000) shr 20;{every 00 is 8 bits, so 5 zeros is 20 bits shift}
      nr_star:= (nr32store and $000FFFFF);  {zone is multiply of $100000, maximum nr of UCAC4 stars in a zone is 286.833 This allow 1.048.576 stars in a zone and 4096 zones using a cardinal or 2024 zones  using an integer (Tycho .290 is using negative numbers)}
      str(nr_regio,name_regio);
      str(nr_star+1000000:7,naamst);{add zeros by 1000000 and later remove 1, faster then formatfloat}
      naam2:=name_regio+'-'+naamst[1]+naamst[2]+naamst[3]+naamst[4]+naamst[5]+naamst[6];{naamst[0]contains the "1" and skip this one}
    end
    else
    begin {tycho style}
      {In case the NR290 integer is negative, the integer contains the Tycho/GSC label. After making the integer positive, the regional star number is stored in the lowest 2 bytes, the GSC/Tycho star region (1..9537) is stored in the highest 2 bytes except that if bit $40000000 is true, the Tycho specific extension is 2, else the Tycho extension is 1. The highest bit of star number at $00008000 is used for the Tycho-2 extension 3.}
      nr_regio:=((-nr32store) and $3FFF0000) shr 16;
      nr_star:=(-nr32store) and $7FFF;
      str(nr_regio,name_regio);
      str(nr_star,naamst);
      naam2:=name_regio+'-'+naamst;
      if (((-nr32store) and $40008000)>0) then  {tycho extensions}
      begin
        if (((-nr32store) and $40000000)>0) then
         naam2:=naam2+'-2' {tycho-2 extension}
        else
         naam2:=naam2+'-3'; {tycho-2 extension}
      end;
    end;
  end; {record_size>7}
end;

begin
  p11:= @buf2[1];	{ set pointer }
  p10:= @buf2[1];	{ set pointer }
  p9:= @buf2[1];	{ set pointer }
  p7:= @buf2[1];	{ set pointer }
  p6:= @buf2[1];	{ set pointer }
  p5:= @buf2[1];	{ set pointer }
end.

