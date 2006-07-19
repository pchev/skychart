REM Run this script to update all the translations after modification of a
REM resource string in u_translation.pas and compilation of the program.

REM Update first the path to your Lazarus installation and run "make" in lazarus/tools


C:\appli\lazarus\pp\bin\i386-win32\rstconv -i units\u_translation.rst -o language\skychart.po
C:\appli\lazarus\tools\updatepofiles language\skychart.po

pause
