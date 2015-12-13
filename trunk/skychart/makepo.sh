#!/bin/bash

# Run this script to update all the translations after modification of a 
# resource string in u_translation.pas and compilation of the program.
#
# The command updatepofiles is run two time to avoid error with comment on top of the file
#
# Update first the path to your Lazarus installation and run "make" in lazarus/tools
#

rstconv -i units/x86_64-linux-gtk2/u_translation.rsj -o ../tools/data/language/skychart.po
/home/compiler/lazarus/tools/updatepofiles ../tools/data/language/skychart.po
/home/compiler/lazarus/tools/updatepofiles ../tools/data/language/skychart.po
