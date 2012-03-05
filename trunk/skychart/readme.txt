How to install the source code to compile with Lazarus/Freepascal
-----------------------------------------------------------------

See also: http://www.ap-i.net/skychart/en/documentation/installation_and_compilation_of_the_source_code

Get the source code

Create a new directory for the source code. You have two ways to get the code:

    Download the source file skychart_v3_xxx_source.tar.gz
    to this directory and extract the files.
    On Linux use : tar xzf skychart_v3_xxx_source.tar.gz
    On Windows use 7-zip available from: http://sourceforge.net/projects/sevenzip/

    Or better use a Subversion client to ease the update of daily changes.
    The command is:

    svn co apt-get -f https://svn.origo.ethz.ch/skychart/trunk .

Automated Compilation and installation

If you just want to compile the software without using the Lazarus interactive environment you can use the scripts available in the base directory.

Before running these scripts be sure to have the Free Pascal binaries in your PATH environment, this is where you find the fpcmake command.

In the base directory you also found the daily_build.sh script I use to automatically build the packages for Linux and Windows.
For Linux and Mac

./configure [fpc=free_pascal_path] [lazarus=lazarus_path] [prefix=installation_path]
make
make install
make install_data

For example to install the complete software from source on Ubuntu 11.10:

sudo apt-get install build-essential lazarus subversion
svn co https://svn.origo.ethz.ch/skychart/trunk skychart
cd skychart
./configure fpc=/usr/lib/fpc/2.4.4 lazarus=/usr/lib/lazarus/0.9.30 prefix=/usr/local
make
sudo make install
sudo make install_data
sudo make install_cat1
sudo make install_cat2
sudo make install_pict

For Windows

    Beware not to have another make command than the Free Pascal one in your path.
    Manually compile the library getdss and plan404 with Mingw.
    Install the command sed for Windows.
    Edit the file configure.cmd to adjust the values for sed=, fpc=, lazarus=, prefix=
    You may have to adjust the scripts according to the Linux version because I not use them and they are probably out of date.

configure.cmd 
make
make install
make install_data

Interactive compilation

First, install the required components from src/skychart/component directory.

Click “Open Package”, select “component/cdccomponents.lpk”, click “Compile”, “Install”.
When the install tells you to rebuild Lazarus say Yes.

You can now open the main project files skychart/cdc.lpi and compile.

To run in debug adjust Run-Run Parameters-Working Directory to your CDC directory.

To reduce the executable size for production, use strip and upx.

The library getdss and plan404 are written in C language. To compile them, install the gcc compiler (Mingw on Windows) and run make from each library folder.

A few Windows specific libraries and plugins are not yet ported to Lazarus, please use Delphi if you want to compile them.
Install Lazarus

To know which version of Lazarus is require for a specific version of Skychart, install the binary version and look at the menu Help / About. There is a line that show the FPC and Lazarus version used.

Install Lazarus from http://lazarus.freepascal.org. See http://wiki.lazarus.freepascal.org/Installing_Lazarus for more information.

Launch Lazarus and open Components-Configure, Installed Packages.

Check that Printer4Lazarus and TurboPowerIPro are installed, this is normally the case.
If not, install them from lazarus/component :

    printers/printer4lazarus.lpk
    turbopower_ipro/turbopoweripro.lpk

I use the following procedure to install or update Free Pascal and Lazarus on Linux with the cross compiler for Windows:

cd ~/fpc
# svn co http://svn.freepascal.org/svn/fpc/branches/fixes_2_2 .
svn up
make clean
make build
sudo make install
make clean OS_TARGET=win32 CPU_TARGET=i386
make build OS_TARGET=win32 CPU_TARGET=i386
sudo make crossinstall OS_TARGET=win32 CPU_TARGET=i386
ver=`fpc -iV`
sudo ln -f -s /usr/local/lib/fpc/$ver/ppc386 /usr/local/bin
sudo ln -f -s /usr/local/lib/fpc/$ver/ppcross386 /usr/local/bin
cd ~/lazarus
# svn co http://svn.freepascal.org/svn/lazarus/trunk .
svn up
make clean
make OS_TARGET=win32 CPU_TARGET=i386 clean
make bigide
make OS_TARGET=win32 CPU_TARGET=i386 bigide

Naming convention for the program source

The following naming convention is used for the main project source code to enable quick recognition of the destination of the units.

cdc.lpi         : The main project
pu_*.pas        : Form units with specific code only
pu_*.lfm        : Form definition
cu_*.pas        : Unit containing non-visual object.
u_*.pas         : Unit with generic code.

Directory structure

     |- src -|                            < base directory, compilation scripts 
             |- skychart |                < skychart module
                         |- component     < project component
                         |- library       < project library
                         |- ...
                         |- units         < all compilation object go here

             |- varobs   |                < varobs module 

             |- tools | - data            < the "data" directory structure require to run the progran
                      | - cat             < the basic catalogs, the program used to build them
                      | - ...             < other data files

