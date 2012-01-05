   
   Plan404 by Steve Moshier
   steve@moshier.net
   http://www.moshier.net/index.html
----------------------------------------------------------------------
   
   Converted to DLL for use with Cartes du Ciel
   Patrick Chevalley
   November 6 1999
   pch@fresurf.ch
   http://astrosurf.com/astropc

   Compute heliocentric equatorial J2000 rectangular coordinates
   and heliocentric ecliptic J2000 polar coordinates
   Planet number are :
                 1 : Mercury.
                 2 : Venus.
                 3 : Earth.
                 4 : Mars.
                 5 : Jupiter.
                 6 : Saturn.
                 7 : Uranus.
                 8 : Neptune.
                 9 : Pluto.
----------------------------------------------------------------------
   
   January 2 2003
   Small change for .so library.

   Add Moon : planet number = 11

   !BEWARE that all Moon coordinates are for the equinox of the date !

----------------------------------------------------------------------

   Look at plan404.h for parameters details.

   plan404.dsw is the workspace to build the dll with MS Visual C.

   use Makefile to build the library with gcc.

   makefile.example is the original makefile to build the C example.

   demo404.dpr is a sample program that show how to use the library
   with Delphi / Kylix.


