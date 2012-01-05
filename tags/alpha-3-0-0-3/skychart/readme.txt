How to install the source code to compile with Delphi/Kylix
-----------------------------------------------------------

The simplest way is to add a ./dev directory to your existing cdc binary directory or
to a new directory if you want to keep a separated stable version.

Download the source file skychart_v3_alpha001_source.tar.gz to this directory 
and extract the file here. 
On Linux the command is : tar xzf skychart_v3_alpha001_source.tar.gz

Create a directory dev/dcu to hold the compilation result separated from the source.

Finally you must have something like that :

cdc -|                                    < base directory containing the executable 
     |- dev -|                            < devel directory 
             |- skychart |                < skychart module
                         |- component     < project component
                         |- library       < project library
                         |- ...
             |- dcu                       < all compilation .dcu object go here


Launch Delphi or Kylix and go first to the dev/skychart/component directory to install
the required component. 

For Delphi install :
             zoomimage\cu_zoomimageD6.dpk
             enhedits\enheditsD6.dpk
             foldrdg\FoldrDlgD6.dpk
             pngimage\  (extract zip file first)
             synapse\  (extract zip file first)

For Kylix install:
             zoomimage/zoomimageK3.dpk
             enhedits/enheditsK3.dpk
             synapse/  (extract zip file first)

Now compile the library. 
Open skychart/library/catalog/catalog.dpr, check in the project options the path for 
the destination and the destination of the units.
Compile the library and check that the file libcatalog.so for Linux or libcatalog.dll
for Windows is created in your base cdc directory.

You can now open the main project file.
For Windows this is skychart\cdc_vcl.dpr
For Linux this is skychart/cdc_clx.dpr

Also check the path in the project options. After that you can compile and run the
program from the IDE.



Naming convention for the program source.
----------------------------------------

The following naming convention is use for the main project source code
to allow to quickly recognise the destination of a unit.

Some of this different file name are necessary to distinguish the Linux
and the Windows files.
This is because I choose to use the CLX only for the Linux project, the
Windows project use the VCL.

There is a few advantage for that:
- We can use the cheap or even free Delphi or Kylix Personal Edition.
- The native VCL Windows executable do not require to install Qt for Windows.
- This clearly separate the code that depend of a specific GUI implementation,
  a port to another compiler is simplified.

The inconvenience is to maintain two version of the visual control, but with
the proposed structure the extra work is keep at a minimum.

Linux specific files:

cdc_clx.dpr     : The main project
fu_*.pas        : Form units with specific code only
fu_*.xfm        : Form definition

Windows specific files:

cdc_vcl.dpr     : The main project
pu_*.pas        : Form units with specific code only
pu_*.dfm        : Form definition

Common files:

i_*.pas         : Include file with common form code.
cu_*.pas        : Unit containing non-visual object.
u_*.pas         : Unit with generic code.

As most of the event declared in the fu_ or pu_ files are handled in the i_ file
many automatic function of the IDE are not working. To solve this problem you 
can temporarily copy the code from the i_ file at the indicated place in the fu_
or pu_ file.
 
