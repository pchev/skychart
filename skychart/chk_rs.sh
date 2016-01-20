# show missing string in script translation

grep "  rs" u_translation.pas |awk '{print $1}'| sort > tr1.txt
grep AddConstantN upsi_translation.pas| cut -d\' -f2 | sort > tr2.txt
diff -u0 tr2.txt tr1.txt|grep -v @@
