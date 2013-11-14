#!/bin/bash

rm -rf doc_ca doc_en doc_es doc_fr doc_it doc_nl doc_ru doc_tr doc_uk 

wget -E -r -p -np -nH --cut-dirs=2 -X */*detail,*/*export,*/playground -R *do=index* -P doc_ca --cache=off --restrict-file-names=windows -k  http://ap-i.net/static/skychart/ca/documentation/start http://ap-i.net/static/skychart/ca/news/start

wget -E -r -p -np -nH --cut-dirs=2 -X */*detail,*/*export,*/playground -R *do=index* -P doc_en --cache=off --restrict-file-names=windows -k  http://ap-i.net/static/skychart/en/documentation/start http://ap-i.net/static/skychart/en/news/start

wget -E -r -p -np -nH --cut-dirs=2 -X */*detail,*/*export,*/playground -R *do=index* -P doc_es --cache=off --restrict-file-names=windows -k http://ap-i.net/static/skychart/es/documentation/start http://ap-i.net/static/skychart/es/news/start

wget -E -r -p -np -nH --cut-dirs=2 -X */*detail,*/*export,*/playground -R *do=index* -P doc_fr --cache=off --restrict-file-names=windows -k http://ap-i.net/static/skychart/fr/documentation/start http://ap-i.net/static/skychart/fr/news/start

wget -E -r -p -np -nH --cut-dirs=2 -X */*detail,*/*export,*/playground -R *do=index* -P doc_it --cache=off --restrict-file-names=windows -k http://ap-i.net/static/skychart/it/documentation/start http://ap-i.net/static/skychart/it/news/start

wget -E -r -p -np -nH --cut-dirs=2 -X */*detail,*/*export,*/playground -R *do=index* -P doc_nl --cache=off --restrict-file-names=windows -k http://ap-i.net/static/skychart/nl/documentation/start http://ap-i.net/static/skychart/nl/news/start

wget -E -r -p -np -nH --cut-dirs=2 -X */*detail,*/*export,*/playground -R *do=index* -P doc_ru --cache=off --restrict-file-names=windows -k http://ap-i.net/static/skychart/ru/documentation/start http://ap-i.net/static/skychart/ru/news/start

wget -E -r -p -np -nH --cut-dirs=2 -X */*detail,*/*export,*/playground -R *do=index* -P doc_tr --cache=off --restrict-file-names=windows -k http://ap-i.net/static/skychart/tr/documentation/start http://ap-i.net/static/skychart/tr/news/start

wget -E -r -p -np -nH --cut-dirs=2 -X */*detail,*/*export,*/playground -R *do=index* -P doc_uk --cache=off --restrict-file-names=windows -k http://ap-i.net/static/skychart/uk/documentation/start http://ap-i.net/static/skychart/uk/news/start