ping -c1 ap-i.net
echo delete doc_en, doc_fr, ...
echo change ap-i.net to 127.0.0.1
echo ready ?
read

wget -E -r -p -np -nH --cut-dirs=1 -X */*detail,*/*export,*/playground -R *do=index* -P doc_ca --cache=off --restrict-file-names=windows -k  http://ap-i.net/skychart/ca/documentation/start http://ap-i.net/skychart/ca/news/start

wget -E -r -p -np -nH --cut-dirs=1 -X */*detail,*/*export,*/playground -R *do=index* -P doc_en --cache=off --restrict-file-names=windows -k  http://ap-i.net/skychart/en/documentation/start http://ap-i.net/skychart/en/news/start

wget -E -r -p -np -nH --cut-dirs=1 -X */*detail,*/*export,*/playground -R *do=index* -P doc_es --cache=off --restrict-file-names=windows -k http://ap-i.net/skychart/es/documentation/start http://ap-i.net/skychart/es/news/start

wget -E -r -p -np -nH --cut-dirs=1 -X */*detail,*/*export,*/playground -R *do=index* -P doc_fr --cache=off --restrict-file-names=windows -k http://ap-i.net/skychart/fr/documentation/start http://ap-i.net/skychart/fr/nouvelles/start

wget -E -r -p -np -nH --cut-dirs=1 -X */*detail,*/*export,*/playground -R *do=index* -P doc_it --cache=off --restrict-file-names=windows -k http://ap-i.net/skychart/it/documentation/start http://ap-i.net/skychart/it/news/start

wget -E -r -p -np -nH --cut-dirs=1 -X */*detail,*/*export,*/playground -R *do=index* -P doc_nl --cache=off --restrict-file-names=windows -k http://ap-i.net/skychart/nl/documentation/start http://ap-i.net/skychart/nl/nieuws/start

wget -E -r -p -np -nH --cut-dirs=1 -X */*detail,*/*export,*/playground -R *do=index* -P doc_ru --cache=off --restrict-file-names=windows -k http://ap-i.net/skychart/ru/documentation/start http://ap-i.net/skychart/ru/news/start

wget -E -r -p -np -nH --cut-dirs=1 -X */*detail,*/*export,*/playground -R *do=index* -P doc_tr --cache=off --restrict-file-names=windows -k http://ap-i.net/skychart/tr/documentation/start http://ap-i.net/skychart/tr/news/start

wget -E -r -p -np -nH --cut-dirs=1 -X */*detail,*/*export,*/playground -R *do=index* -P doc_uk --cache=off --restrict-file-names=windows -k http://ap-i.net/skychart/uk/documentation/start http://ap-i.net/skychart/uk/news/start
