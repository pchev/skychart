Minimal Xplanet version for use with Cartes du Ciel

Xplanet source code is available from http://xplanet.sourceforge.net/

The Windows version for Cartes du Ciel is build the following way:

If not already done install cygwin with all the development packages.
From cygwin shell:
svn co https://xplanet.svn.sourceforge.net/svnroot/xplanet/trunk xplanet
cd xplanet
Apply the following patch:
Index: configure.ac
===================================================================
--- configure.ac	(revision 173)
+++ configure.ac	(working copy)
@@ -42,7 +42,7 @@
      if test "$with_cygwin" != 'no'; then
        AC_DEFINE(HAVE_CYGWIN,,Define if compiling under cygwin)
        have_cygwin='yes'
-       xplanet_LDFLAGS="-static"
+       xplanet_LDFLAGS="-static -static-libgcc"
        separator="\\\\\\\\"
      fi
      ;;

./configure --with-x=no --with-pango=no --with-xscreensaver=no --with-tiff=no --with-gif=no --with-pnm=no --with-cspice=no --with-cygwin
make
mkdir xplanet-cdc
cp /usr/bin/cygwin1.dll xplanet-cdc/
cp scr/xplanet.exe xplanet-cdc/
strip xplanet-cdc/xplanet.exe
cp xplanet/fonts/FreeMonoBold.ttf xplanet-cdc/
cp xplanet/rgb.txt xplanet-cdc/

zip the files in xplanet-cdc/ to include with the package

