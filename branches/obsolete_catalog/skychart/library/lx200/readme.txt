****************************************************************

	Cartes du Ciel, Sky Charts 

	Patrick Chevalley 

        http://www.astrosurf.com/astropc
	pch@freesurf.ch

****************************************************************

This is the source for the Meade telescope plugin for Cartes du Ciel.
It must be compiled with Borland Delphi Compiler. A free Personnal Edition 
of Delphi is available from www.borland.com.
The DLL as the extention .tid to easily recognize it and list the available
plugin in the program without any specific installation.
I appreciate if you send me the change you do in this code or if you adapts
for any other telescope model. 

Files :
- serial.pas     : serial port I/O
- meade.dpr      : Delphi project to compile the DLL
- lx200_lib.pas  : LX200 protocol functions.
- lx2001.pas     : DLL exported functions and Dialog panel functions.
- lx2001.dfm     : Dialog panel form definition. 

****************************************************************
Copyright (C) 2000 Patrick Chevalley

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
****************************************************************

