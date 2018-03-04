#!/bin/bash

vcount=$(git rev-list --count --first-parent HEAD)
vnum=$(git log -n 1 --pretty=format:"%h")

echo "// git revision" > skychart/revision.inc
echo "const RevisionStr = '$vcount-$vnum';" >> skychart/revision.inc

