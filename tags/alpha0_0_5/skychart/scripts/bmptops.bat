@echo off
rem convert a bmp to postscript using netpbm
rem put with all the required netpbm files in cdc\plugins\netpbm
bmptopnm %1 | pnmtops -equalpixels -dpi=150 -rle > %2
exit
