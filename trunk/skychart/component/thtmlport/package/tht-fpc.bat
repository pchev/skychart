set lazpath="c:\tools\lazarus"
if not exist %lazpath% (set lazpath="c:\lazarus")
set fpcpath=%lazpath%\fpc\2.2.2
if not exist %fpcpath% (set fpcpath=%lazpath%\fpc\2.2.4)
set lclunits=%lazpath%\lcl\units\i386-win32
"%fpcpath%\bin\i386-win32\fpc.exe" -dLCL -dDebugIt -Sda -O1 -vx -gl -Fu"%lclunits%;%lazpath%\components\printers\lib\i386-win32\win32" frambrwz.pas %1 %2 %3