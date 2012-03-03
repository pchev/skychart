#!/bin/bash

lazbuild=/home/compiler/lazarus/lazbuild

rm ds2cdc.dll tstdll.exe ds2cdc.dll.zip

$lazbuild --os=win32 --ws=win32 --cpu=i386 ds2cdc.lpi
mv C\:/Program\ Files/Deepsky\ Astronomy\ Software/ds2cdc.dll .
strip --strip-all ds2cdc.dll
zip ds2cdc.dll.zip ds2cdc.dll

$lazbuild --os=win32 --ws=win32 --cpu=i386 tstdll.lpi
strip --strip-all tstdll.exe
