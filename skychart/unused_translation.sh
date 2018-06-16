#!/bin/bash

files=$(ls *.pas | grep -v translation)
trans=$(grep "  rs" u_translation.pas | cut -d = -f1)
for t in $trans ; do
  grep  -w $t $files > /dev/null 2>&1
  if [[ $? != 0 ]]; then
     echo $t
  fi
done
