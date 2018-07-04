#!/bin/bash

files=$(find *.pas ../tools/data/script/*.cdcps | grep -v translation)
trans=$(grep "  rs" u_translation.pas | cut -d = -f1)
for t in $trans ; do
  grep -i -w $t $files > /dev/null 2>&1
  if [[ $? != 0 ]]; then
     echo $t
  fi
done
