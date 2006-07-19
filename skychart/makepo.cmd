REM run this script to update all the translations after modification of u_translation.pas   

C:\appli\lazarus\pp\bin\i386-win32\rstconv -i units\u_translation.rst -o language\skychart.po
C:\appli\lazarus\tools\updatepofiles language\skychart.po

pause
