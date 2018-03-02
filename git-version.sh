#!/bin/bash

vcount=$(git rev-list --count --first-parent HEAD)
vnum=$(git describe --always HEAD)

echo "// git revision" > skychart/revision.inc
echo "const RevisionStr = '$vcount-$vnum';" >> skychart/revision.inc

