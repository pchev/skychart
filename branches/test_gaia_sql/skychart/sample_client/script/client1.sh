#!/bin/bash

#
# Example of shell script to automate skychart using the command line interface
# Produce 640x480 chart of M1 and Andromeda in /tmp directory
#

# first we need to start the main instance in background
skychart --unique &

# wait it start
sleep 5

# set chart size
skychart --unique --resize="640 480"

# show a map of Messier 1
skychart --unique --setfov=15 --setproj=EQUAT --search=M1
# let some time to look at the result
sleep 5
# Save chart bitmap
skychart --unique --saveimg="PNG /tmp/m1.png 0"

# show a map of Andromeda
skychart --unique --setfov=45 --setproj=EQUAT --search="bet AND"
# let some time to look at the result
sleep 5
# Save chart bitmap
skychart --unique --saveimg="PNG /tmp/and.png 0"

# quit the main instance
skychart --unique --quit

