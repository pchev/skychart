library Meade;
{
Copyright (C) 2000 Patrick Chevalley

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

{------------- interface for LX200 system. ----------------------------
Contribution from :
PJ Pallez Nov 1999
Patrick Chevalley Oct 2000
Renato Bonomini Jul 2004

will work with all systems using same protocol
(LX200,AutoStar,..)
-------------------------------------------------------------------------------}

uses
  lx2001 in 'lx2001.pas' {pop_scope},
  lx200_lib in 'lx200_lib.pas',
  EnhEdits in '..\enhedits\EnhEdits.pas';

{$E .tid}

Exports
       ScopeConnect,
       ScopeDisconnect,
       ScopeClose,
       ScopeSetObs,
       ScopeReset,
       ScopeAlign,
       ScopeShow,
       ScopeShowModal,
       ScopeGetRaDec,
       ScopeGetAltAz,
       ScopeGoto,
       ScopeInitialized,
       ScopeConnected,
       ScopeGetInfo;

begin
  InitLib;
end.