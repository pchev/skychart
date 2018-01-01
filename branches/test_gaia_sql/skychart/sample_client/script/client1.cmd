Rem Example of command script to automate skychart using the command line interface
Rem Produce 640x480 chart of M1 and Andromeda in user home directory

Rem Install the resource kit sleep command to replace the ping trick to wait 5 seconds


Rem first we need to start the main instance in background
start "" "C:\Program Files\Ciel\skychart.exe" --unique

Rem wait it start
ping localhost -w 1000 -n 5 >nul

Rem set chart size
"C:\Program Files\Ciel\skychart.exe" --unique --resize="640 480"

Rem show a map of Messier 1
"C:\Program Files\Ciel\skychart.exe" --unique --setfov=15 --setproj=EQUAT --search=M1
Rem let some time to look at the result
ping localhost -w 1000 -n 5 >nul
Rem Save chart bitmap
"C:\Program Files\Ciel\skychart.exe" --unique --saveimg="PNG %HOMEPATH%\m1.png 0"

Rem show a map of Andromeda
"C:\Program Files\Ciel\skychart.exe" --unique --setfov=45 --setproj=EQUAT --search="bet AND"
Rem let some time to look at the result
ping localhost -w 1000 -n 5 >nul
Rem Save chart bitmap
"C:\Program Files\Ciel\skychart.exe" --unique --saveimg="PNG %HOMEPATH%\and.png 0"

Rem quit the main instance
"C:\Program Files\Ciel\skychart.exe" --unique --quit

