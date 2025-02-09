Minimal Xplanet version for use with Cartes du Ciel

Xplanet source code is available from http://xplanet.sourceforge.net/

The macos version for Cartes du Ciel is build the following way:

If not already done install MacPort: 
- in /opt/local/etc/macports/macports.conf add:
  macosx_deployment_target 11.0
port install jpeg libpng automake autoconf

svn co https://svn.code.sf.net/p/xplanet/code/trunk xplanet
cd xplanet

autoreconf -vfi
./configure --with-x=no --with-aqua=no --with-xscreensaver=no --with-freetype=no --with-pango=no --with-gif=no --with-tiff=no CPPFLAGS="-I/opt/local/include" LDFLAGS="-L/opt/local/lib"
make clean all

mkdir xplanet-cdc
cp src/xplanet xplanet-cdc/
strip xplanet-cdc/xplanet
cp xplanet/fonts/FreeMonoBold.ttf xplanet-cdc/
cp xplanet/rgb.txt xplanet-cdc/
cp /opt/local/lib/libpng16.16.dylib xplanet-cdc/
cp /opt/local/lib/libjpeg.9.dylib xplanet-cdc/
cp /opt/local/lib/libz.1.dylib xplanet-cdc/
cd xplanet-cdc
otool -L xplanet
install_name_tool -change /opt/local/libexec/jpeg/lib/libjpeg.9.dylib @executable_path/libjpeg.9.dylib  xplanet
install_name_tool -change /opt/local/lib/libpng16.16.dylib @executable_path/libpng16.16.dylib  xplanet
install_name_tool -change /opt/local/lib/libz.1.dylib @executable_path/libz.1.dylib xplanet
install_name_tool -change /opt/local/lib/libz.1.dylib @rpath/libz.1.dylib libpng16.16.dylib
install_name_tool -id @rpath/libjpeg.9.dylib libjpeg.9.dylib
install_name_tool -id @rpath/libpng16.16.dylib libpng16.16.dylib
install_name_tool -id @rpath/libz.1.dylib libz.1.dylib          

tar the files in xplanet-cdc/ to include with the package
 
