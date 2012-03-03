#!/bin/sh
lazdir=~/lazarus
if ! [ -e $lazdir ] 
then
  lazdir=/usr/local/share/lazarus
fi
if [ `arch` = "ppc" ]
then
  proc=powerpc
else
  proc=i386
fi
lclunits=$lazdir/lcl/units/$proc-darwin
/usr/local/bin/fpc -dLCL -Sda -gl -O1 -dDebugIt -Fu$lclunits -Fu$lazdir/components/printers/lib/$proc-darwin/carbon frambrwz.pas
