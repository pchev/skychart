#!/bin/bash

#
# Example of shell script to automate skychart using netcat 
# Produce 640x480 chart of M1 in /tmp directory
#

# get CdC host and port
cdchost=localhost
cdcport=$(cat $HOME/.skychart/tmp/tcpport)

# send a single command
echo resize 640 480 | nc -C -w1 $cdchost $cdcport

# send a group of command
nc -C -w1 $cdchost $cdcport << EOF
setfov 15
setproj EQUAT
search M1
redraw
saveimg PNG /tmp/m1.png 0
EOF
