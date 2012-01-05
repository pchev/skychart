****************************************************************

	Cartes du Ciel, Sky Charts 

	Patrick Chevalley 

        http://www.astrosurf.com/astropc
	pch@freesurf.ch

****************************************************************

This is the source for the ASCOM telescope plugin for Cartes du Ciel.
It must be compiled with Borland Delphi Compiler. A free Personnal Edition 
of Delphi is available from www.borland.com.
The DLL as the extention .tid to easily recognize it and list the available
plugin in the program without any specific installation.
I appreciate if you send me the change you do in this code.

Files :
- ascomtel1.pas   : DLL functions for ASCOM telescope interface.
- ascomtel1.dfm   : Dialog panel form definition. 
- ascom.dpr       : Delphi project to compile the DLL
- unit1.pas       : Very simple demo to start with OLEObject in Delphi. 
- unit1.dfm       : Demo panel form definition. 
- project1.dpr    : Delphi project to compile the demo.

You must also install the latest ASCOM Platform available from 
http://ascom-standards.org

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

