ping -c1 ap-i.net
echo delete doc_en, doc_fr, ...
echo change ap-i.net to 127.0.0.1
echo ready ?
read

wget -E -r -p -np -nH --cut-dirs=1 -X */*detail,*/*export,*/playground -R *@do=index* -P doc_en --cache=off --restrict-file-names=windows -k  http://ap-i.net/skychart/en/documentation/start http://ap-i.net/skychart/en/news/start

wget -E -r -p -np -nH --cut-dirs=1 -X */*detail,*/*export,*/playground -R *@do=index* -P doc_fr --cache=off --restrict-file-names=windows -k http://ap-i.net/skychart/fr/documentation/start http://ap-i.net/skychart/fr/nouvelles/start
