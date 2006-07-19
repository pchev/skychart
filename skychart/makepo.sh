#!/bin/bash

# Run this script to update all the translations after modification of a 
# resource string in u_translation.pas and compilation of the program.

# Update first the path to your Lazarus installation and run "make" in lazarus/tools

~/lazarus/pp/bin/rstconv -i units/u_translation.rst -o language/skychart.po
~/lazarus/tools/updatepofiles language/skychart.po
