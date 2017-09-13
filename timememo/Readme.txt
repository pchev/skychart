****************************************************************

	Time Memo version 2.0
	September 8 2017

	Patrick Chevalley 

        http://www.ap-i.net
	pch@ap-i.net

****************************************************************

Time Memo is a software to periodically control the time offset 
between your computer and a NTP server and eventually adjust the
computer clock (on Windows only).

Time Memo is free software, it is distributed under the terms of 
the GNU General Public License, Version 2.
The source code can be found at https://sourceforge.net/p/skychart/code/HEAD/tree/timememo/
The source code for the Synapse component is at http://www.ararat.cz/synapse/
Compile with Free Pascal and Lazarus available from https://www.lazarus-ide.org/


Installation :
--------------
- Windows : copy timememo.exe and timeserver.lst to any directory.

- Linux : copy timememo and timeserver.lst to any directory.
  Adjusting the computer clock is not available on Linux, use ntpd for that.        

Instruction :
-------------
Connect your computer to the Internet and run the program. 
Usage is straightforward, simply select the query rate and if you 
want or not to adjust your computer clock (on Windows only). 
If using an external ntp server you must not set a too small query rate.

When ready press the "Start" button.
All the query and action are logged to the file you indicate.
The "Immediat action" are available at any time, even during normal
recording.
The setting is saved when you exit the program.

Normally pool.ntp.org is all what you need but you can add a new NTP server 
by editing the file timeserver.lst.
Look at http://www.ntp.org/ for more server address and up to date information.

Command line options :
----------------------
-s : start immediately the recording using previously saved setting.
-d : run as daemon and start immediately. (on Windows use Ctrl+Alt+Del to kill it).

Remarks :
---------
If you use a firewall you must authorize traffic on port 123.
SNTP protocol details are available in RFC-1769.


