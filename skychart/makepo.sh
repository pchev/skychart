#!/bin/bash

# Run this script to update all the translations after modification of a 
# resource string in u_translation.pas and compilation of the program.
#
# The command updatepofiles is run two time to avoid error with comment on top of the file
#
# Update first the path to your Lazarus installation and run "make" in lazarus/tools
#

rstconv -i units/x86_64-linux-qt5/u_translation.rsj -o ../tools/data/language/skychart.pot
/home/compiler/lazarus/tools/updatepofiles ../tools/data/language/skychart.pot
/home/compiler/lazarus/tools/updatepofiles ../tools/data/language/skychart.pot

mv ../tools/data/language/skychart.pot ../tools/data/language/skychart.po
