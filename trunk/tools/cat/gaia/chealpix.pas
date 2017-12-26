unit chealpix;
interface

  const
    {$IFDEF mswindows}
    External_library='libchealpix.dll';
    {$else}
    External_library='libchealpix.so.0';
    {$ENDIF}

 Type

  hpint64 = int64;
  Phpint64  = ^hpint64;

{$IFDEF FPC}
{$PACKRECORDS C}
{$ENDIF}


  { -----------------------------------------------------------------------------
   *
   *  Copyright (C) 1997-2012 Krzysztof M. Gorski, Eric Hivon, Martin Reinecke,
   *                          Benjamin D. Wandelt, Anthony J. Banday,
   *                          Matthias Bartelmann,
   *                          Reza Ansari & Kenneth M. Ganga
   *
   *
   *  This file is part of HEALPix.
   *
   *  HEALPix is free software; you can redistribute it and/or modify
   *  it under the terms of the GNU General Public License as published by
   *  the Free Software Foundation; either version 2 of the License, or
   *  (at your option) any later version.
   *
   *  HEALPix is distributed in the hope that it will be useful,
   *  but WITHOUT ANY WARRANTY; without even the implied warranty of
   *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   *  GNU General Public License for more details.
   *
   *  You should have received a copy of the GNU General Public License
   *  along with HEALPix; if not, write to the Free Software
   *  Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
   *
   *  For more information about HEALPix see http://healpix.sourceforge.net
   *
   *---------------------------------------------------------------------------- }
  {
   * chealpix.h
    }
{$ifndef CHEALPIX_H}
{ C++ extern C conditionnal removed }
  {! \defgroup chealpix HEALPix C interface
      All angles are in radian, all \a theta values are colatitudes, i.e. counted
      downwards from the North Pole. \a Nside can be any positive number for
      pixelisations in RING scheme; in NEST scheme, they must be powers of 2.
      The maximum \a Nside for the traditional interface is 8192; for the
      64bit interface it is 2^29.
    }
  {! \  }
  { --------------------  }
  { Constant Definitions  }
  { --------------------  }
{$ifndef HEALPIX_NULLVAL}

  const
    HEALPIX_NULLVAL = -(1.6375e30);    
{$endif}
  { HEALPIX_NULLVAL  }
  { pixel operations  }
  { ----------------  }
  {! Sets \a *ipix to the pixel number in NEST scheme at resolution \a nside,
      which contains the position \a theta, \a phi.  }

  procedure ang2pix_nest(nside:longint; theta:double; phi:double; var ipix:longint);cdecl;external External_library name 'ang2pix_nest';

  {! Sets \a *ipix to the pixel number in RING scheme at resolution \a nside,
      which contains the position \a theta, \a phi.  }
  procedure ang2pix_ring(nside:longint; theta:double; phi:double; var ipix:longint);cdecl;external External_library name 'ang2pix_ring';

  {! Sets \a theta and \a phi to the angular position of the center of pixel
      \a ipix in NEST scheme at resolution \a nside.  }
  procedure pix2ang_nest(nside:longint; ipix:longint; var theta:double; var phi:double);cdecl;external External_library name 'pix2ang_nest';

  {! Sets \a theta and \a phi to the angular position of the center of pixel
      \a ipix in NEST scheme at resolution \a nside.  }
  procedure pix2ang_ring(nside:longint; ipix:longint; var theta:double; var phi:double);cdecl;external External_library name 'pix2ang_ring';

  {! Computes the RING pixel index of pixel \a ipnest at resolution \a nside
      and returns it in \a *ipring. On error, \a *ipring is set to -1.  }
  procedure nest2ring(nside:longint; ipnest:longint; var ipring:longint);cdecl;external External_library name 'nest2ring';

  {! Computes the NEST pixel index of pixel \a ipring at resolution \a nside
      and returns it in \a *ipring. On error, \a *ipnest is set to -1.  }
  procedure ring2nest(nside:longint; ipring:longint; var ipnest:longint);cdecl;external External_library name 'ring2nest';

  {! Returns \a 12*nside*nside.  }
  function nside2npix(nside:longint):longint;cdecl;external External_library name 'nside2npix';

  {! Returns \a sqrt(npix/12) if this is an integer number, otherwise \a -1.  }
  function npix2nside(npix:longint):longint;cdecl;external External_library name 'npix2nside';

  {! Computes a normalized Cartesian vector pointing in the same direction as
      \a theta, \a phi, and stores it in \a vec. \a vec must point to storage
      sufficient for at least three doubles.  }
  procedure ang2vec(theta:double; phi:double; var vec:double);cdecl;external External_library name 'ang2vec';

  {! Computes the angles \a *theta and \a *phi describing the same directions
      as the Cartesian vector \a vec. \a vec need not be normalized.  }
(* Const before type ignored *)
  procedure vec2ang(var vec:double; var theta:double; var phi:double);cdecl;external External_library name 'vec2ang';

  {! Sets \a *ipix to the pixel number in NEST scheme at resolution \a nside,
      which contains the direction described the Cartesian vector \a vec.  }
(* Const before type ignored *)
  procedure vec2pix_nest(nside:longint; var vec:double; var ipix:longint);cdecl;external External_library name 'vec2pix_nest';

  {! Sets \a *ipix to the pixel number in RING scheme at resolution \a nside,
      which contains the direction described the Cartesian vector \a vec.  }
(* Const before type ignored *)
  procedure vec2pix_ring(nside:longint; var vec:double; var ipix:longint);cdecl;external External_library name 'vec2pix_ring';

  {! Sets \a vec to the Cartesian vector pointing in the direction of the center
      of pixel \a ipix in NEST scheme at resolution \a nside.  }
  procedure pix2vec_nest(nside:longint; ipix:longint; var vec:double);cdecl;external External_library name 'pix2vec_nest';

  {! Sets \a vec to the Cartesian vector pointing in the direction of the center
      of pixel \a ipix in RING scheme at resolution \a nside.  }
  procedure pix2vec_ring(nside:longint; ipix:longint; var vec:double);cdecl;external External_library name 'pix2vec_ring';

  { operations on Nside values up to 2^29  }
  {! 64bit integer type
      \note We are not using \c int64_t, since this type is not part of the C++
      standard, and we want the header to be usable from C++.  }

  {! Sets \a *ipix to the pixel number in NEST scheme at resolution \a nside,
      which contains the position \a theta, \a phi.  }

  procedure ang2pix_nest64(nside:hpint64; theta:double; phi:double; var ipix:hpint64);cdecl;external External_library name 'ang2pix_nest64';

  {! Sets \a *ipix to the pixel number in RING scheme at resolution \a nside,
      which contains the position \a theta, \a phi.  }
  procedure ang2pix_ring64(nside:hpint64; theta:double; phi:double; var ipix:hpint64);cdecl;external External_library name 'ang2pix_ring64';

  {! Sets \a theta and \a phi to the angular position of the center of pixel
      \a ipix in NEST scheme at resolution \a nside.  }
  procedure pix2ang_nest64(nside:hpint64; ipix:hpint64; var theta:double; var phi:double);cdecl;external External_library name 'pix2ang_nest64';

  {! Sets \a theta and \a phi to the angular position of the center of pixel
      \a ipix in RING scheme at resolution \a nside.  }
  procedure pix2ang_ring64(nside:hpint64; ipix:hpint64; var theta:double; var phi:double);cdecl;external External_library name 'pix2ang_ring64';

  {! Computes the RING pixel index of pixel \a ipnest at resolution \a nside
      and returns it in \a *ipring. On error, \a *ipring is set to -1.  }
  procedure nest2ring64(nside:hpint64; ipnest:hpint64; var ipring:hpint64);cdecl;external External_library name 'nest2ring64';

  {! Computes the NEST pixel index of pixel \a ipring at resolution \a nside
      and returns it in \a *ipring. On error, \a *ipnest is set to -1.  }
  procedure ring2nest64(nside:hpint64; ipring:hpint64; var ipnest:hpint64);cdecl;external External_library name 'ring2nest64';

  {! Returns \a 12*nside*nside.  }
  function nside2npix64(nside:hpint64):hpint64;cdecl;external External_library name 'nside2npix64';

  {! Returns \a sqrt(npix/12) if this is an integer number, otherwise \a -1.  }
  function npix2nside64(npix:hpint64):longint;cdecl;external External_library name 'npix2nside64';

  {! Sets \a *ipix to the pixel number in NEST scheme at resolution \a nside,
      which contains the direction described the Cartesian vector \a vec.  }
(* Const before type ignored *)
  procedure vec2pix_nest64(nside:hpint64; var vec:double; var ipix:hpint64);cdecl;external External_library name 'vec2pix_nest64';

  {! Sets \a *ipix to the pixel number in RING scheme at resolution \a nside,
      which contains the direction described the Cartesian vector \a vec.  }
(* Const before type ignored *)
  procedure vec2pix_ring64(nside:hpint64; var vec:double; var ipix:hpint64);cdecl;external External_library name 'vec2pix_ring64';

  {! Sets \a vec to the Cartesian vector pointing in the direction of the center
      of pixel \a ipix in NEST scheme at resolution \a nside.  }
  procedure pix2vec_nest64(nside:hpint64; ipix:hpint64; var vec:double);cdecl;external External_library name 'pix2vec_nest64';

  {! Sets \a vec to the Cartesian vector pointing in the direction of the center
      of pixel \a ipix in RING scheme at resolution \a nside.  }
  procedure pix2vec_ring64(nside:hpint64; ipix:hpint64; var vec:double);cdecl;external External_library name 'pix2vec_ring64';

  { FITS operations  }
  { ---------------  }
(* Const before type ignored *)
  function read_healpix_map(infile:Pchar; var nside:longint; coordsys:Pchar; ordering:Pchar):Psingle;cdecl;external External_library name 'read_healpix_map';

(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
  procedure write_healpix_map(var signal:single; nside:longint; filename:Pchar; nest:char; coordsys:Pchar);cdecl;external External_library name 'write_healpix_map';

(* Const before type ignored *)
  function get_fits_size(filename:Pchar; var nside:longint; ordering:Pchar):longint;cdecl;external External_library name 'get_fits_size';

  {! \  }
{$endif}
  { CHEALPIX_H  }

implementation


end.
