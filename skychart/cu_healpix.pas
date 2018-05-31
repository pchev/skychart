unit cu_healpix;
interface

{
  Dynamic interface for libchealpix
}

{$mode objfpc}{$H+}

uses dynlibs;

  const
    {$ifdef mswindows}
    libname='libchealpix.dll';
    {$endif}
    {$ifdef linux}
    libname='libchealpix.so.0';
    {$endif}
    {$ifdef freebsd}
    libname='libchealpix.so.0';
    {$endif}
    {$ifdef darwin}
    libname='libchealpix.dylib';
    {$endif}


type
   {! \defgroup chealpix HEALPix C interface
       All angles are in radian, all \a theta values are colatitudes, i.e. counted
       downwards from the North Pole. \a Nside can be any positive number for
       pixelisations in RING scheme; in NEST scheme, they must be powers of 2.
       The maximum \a Nside for the traditional interface is 8192; for the
       64bit interface it is 2^29.
     }

   {! Sets \a *ipix to the pixel number in NEST scheme at resolution \a nside,
       which contains the position \a theta, \a phi.  }
   Tang2pix_nest64 = procedure (nside:int64; theta:double; phi:double; var ipix:int64);cdecl;

   {! Sets \a theta and \a phi to the angular position of the center of pixel
    \a ipix in NEST scheme at resolution \a nside.  }
   Tpix2ang_nest64 = procedure (nside:int64; ipix:int64; var theta:double; var phi:double);cdecl;

   // Other functions can be copied from chealpix.pas here.

var
   ang2pix_nest64: Tang2pix_nest64;
   pix2ang_nest64: Tpix2ang_nest64;

implementation

var lib: TLibHandle;

initialization

  try
  lib := LoadLibrary(libname);
  if lib <> 0 then
  begin
    ang2pix_nest64 := Tang2pix_nest64(GetProcedureAddress(lib, 'ang2pix_nest64'));
    pix2ang_nest64 := Tpix2ang_nest64(GetProcedureAddress(lib, 'pix2ang_nest64'));
  end
  else
  begin
    ang2pix_nest64 := nil;
    pix2ang_nest64 := nil;
  end;
  except
    ang2pix_nest64 := nil;
    pix2ang_nest64 := nil;
  end;

end.
