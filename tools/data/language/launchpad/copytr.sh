# Copy the translation from download to source tree

cd download

for f in $(ls -1 skychart/skychart-*.po)
 do 
 fg="${f#*-}"
 echo cp $f ../../skychart.$fg 
 cp $f ../../skychart.$fg
done

for f in $(ls -1 translation/skychart/skychart-*.po)
 do 
 fg="${f#*-}"
 echo cp $f ../../skychart.$fg 
 cp $f ../../skychart.$fg
done
