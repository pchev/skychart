How to install the source code to compile with Lazarus/Freepascal
-----------------------------------------------------------------

The simplest way is to add a ./src directory to your existing cdc binary directory or
to a new directory if you want to keep a separated stable version.

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
             |- units                     < all compilation .dcu object go here

Install Lazarus using a recent snapshot from http://lazarus.freepascal.org

There is a lot of package to install, do not compile Lazarus at each!
To install each package in Lazarus use File-Open to open the .lpk
Click "Open Package", "Compile", "Install".
When the install tell you to rebuild Lazarus say NO.

Launch Lazarus and go first to lazarus/component to install the following 
standard packages:

      printers/printer4lazarus.lpk
      jpeg/jpegforlazarus.lpk
      turbopower_ipro/turbopoweripro.lpk

Then from src/skychart/component directory install
the packages for the required component:

      enhedits/enhedit.lpk
      jdcalendar/cdcjdcalendar.lpk
      multidoc/multidocpackage.lpk
      radec/radec.lpk
      winxp/winxpstyle.lpk ( for Windows only )
      xmlparser/xmlparser.lpk
      zoomimage/zoomimage.lpk
      wizardntb/wizardntb.lpk
      libsql/libsql.lpk

And the packages for the library src/skychart/library :
(compile only)

      catalog/cdccatalog.lpk
      elp82/elp82.lpk
      satxy/satxy.lpk
      series96/series96.lpk

After all are installed click Tools-Build Lazarus.

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

