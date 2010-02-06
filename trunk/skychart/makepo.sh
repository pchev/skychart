#!/bin/bash

# Run this script to update all the translations after modification of a 
# resource string in u_translation.pas and compilation of the program.

# Update first the path to your Lazarus installation and run "make" in lazarus/tools

rstconv -i units/i386-linux-gtk2/u_translation.rst -o ../tools/data/language/skychart.po
/home/compiler/lazarus/tools/updatepofiles ../tools/data/language/skychart.po

rstconv -i units/i386-linux-gtk2/u_help.rst -o ../tools/data/language/help.po
/home/compiler/lazarus/tools/updatepofiles ../tools/data/language/help.po
