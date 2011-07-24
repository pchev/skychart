#!/bin/bash

/home/compiler/lazarus/lazbuild --os=win32 --ws=win32 --cpu=i386 ds2cdc.lpi
strip --strip-all ds2cdc.dll

/home/compiler/lazarus/lazbuild --os=win32 --ws=win32 --cpu=i386 tstdll.lpi
strip --strip-all tstdll.exe
