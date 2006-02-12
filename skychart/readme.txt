How to install the source code to compile with Lazarus/Freepascal
-----------------------------------------------------------------

The simplest way is to add a ./src directory to your existing cdc binary directory.

Download the source file skychart_XXX_source.tar.gz to this directory 
and extract the file here. 
On Linux the command is : tar xzf skychart_v3_XXX_source.tar.gz

Finally you must have something like that :

cdc -|                                    < base directory containing the executable 
     |- src -|                            < devel directory 
             |- skychart |                < skychart module
                         |- component     < project component
                         |- library       < project library
                         |- ...
                         |- units         < all compilation object go here

Install Lazarus using at least the version 0.9.12 from http://lazarus.freepascal.org

There is a lot of package to install, do not compile Lazarus for each!
To install each package in Lazarus use File-Open to open the .lpk
Click "Open Package", "Compile", "Install".
When the install tell you to rebuild Lazarus say NO.

Launch Lazarus and open Components-Configure Installed Packages
Check that Printer4Lazarus, JPEGForLazarus and TurboPowerIPro are installed, 
this is normally the case with the version 0.9.12.
If not install them from lazarus/component 
      printers/printer4lazarus.lpk
      jpeg/jpegforlazarus.lpk
      turbopower_ipro/turbopoweripro.lpk

Then from src/skychart/component directory install
the packages for the required component:

      enhedits/enhedit.lpk
      jdcalendar/cdcjdcalendar.lpk
      libsql/libsql.lpk
      multidoc/multidocpackage.lpk
      radec/radec.lpk
      synapse/source/lib/synapse.lpk
      downloaddialog/downldialog.lpk  (after synapse)
      wizardntb/wizardntb.lpk
      xmlparser/xmlparser.lpk
      zoomimage/zoomimage.lpk
For the last one reply YES to rebuild Lazarus.

And the packages for the library src/skychart/library :
(compile only)

      catalog/cdccatalog.lpk
      elp82/elp82.lpk
      satxy/satxy.lpk
      series96/series96.lpk


You can now open the main project files skychart\cdc.lpi and compile.
To run in debug adjust Run-Run Parameters-Working Directory to your CDC directory.
To reduce the executable size for production use strip and upx.

A few Windows specific library and plugin are not yet ported to Lazarus,
please use Delphi if you want to compile them.

Naming convention for the program source.
----------------------------------------
The following naming convention is use for the main project source code
to allow to quickly recognise the destination of a unit.

cdc.lpi         : The main project
pu_*.pas        : Form units with specific code only
pu_*.lfm        : Form definition
cu_*.pas        : Unit containing non-visual object.
u_*.pas         : Unit with generic code.

