library Encoder;
{****************************************************************
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
****************************************************************}

uses
  encoder1 in 'encoder1.pas' {pop_scope},
  u_types in 'u_types.pas',
  encoder_lib in 'encoder_lib.pas',
  Taki in 'taki.pas';

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
       ScopeGetInfo,
       ScopeReadConfig;

end.
