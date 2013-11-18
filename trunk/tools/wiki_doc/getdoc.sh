#!/bin/bash

rm -rf doc_ca doc_en doc_es doc_fr doc_it doc_nl doc_ru doc_tr doc_uk 

wget -E -r -p -np -nH --timeout=15 --cut-dirs=1 -X */*detail,*/*export,*/playground -R *do=index* -P doc_ca --cache=off --restrict-file-names=windows -k http://ap-i.net/skychart/ca/documentation/start http://ap-i.net/skychart/ca/news/start --header="X-DokuWiki-Do: export_xhtml"

wget -E -r -p -np -nH --timeout=15 --cut-dirs=1 -X */*detail,*/*export,*/playground -R *do=index* -P doc_en --cache=off --restrict-file-names=windows -k http://ap-i.net/skychart/en/documentation/start http://ap-i.net/skychart/en/news/start --header="X-DokuWiki-Do: export_xhtml"

wget -E -r -p -np -nH --timeout=15 --cut-dirs=1 -X */*detail,*/*export,*/playground -R *do=index* -P doc_es --cache=off --restrict-file-names=windows -k http://ap-i.net/skychart/es/documentation/start http://ap-i.net/skychart/es/news/start --header="X-DokuWiki-Do: export_xhtml"

wget -E -r -p -np -nH --timeout=15 --cut-dirs=1 -X */*detail,*/*export,*/playground -R *do=index* -P doc_fr --cache=off --restrict-file-names=windows -k http://ap-i.net/skychart/fr/documentation/start http://ap-i.net/skychart/fr/news/start --header="X-DokuWiki-Do: export_xhtml"

wget -E -r -p -np -nH --timeout=15 --cut-dirs=1 -X */*detail,*/*export,*/playground -R *do=index* -P doc_it --cache=off --restrict-file-names=windows -k http://ap-i.net/skychart/it/documentation/start http://ap-i.net/skychart/it/news/start --header="X-DokuWiki-Do: export_xhtml"

wget -E -r -p -np -nH --timeout=15 --cut-dirs=1 -X */*detail,*/*export,*/playground -R *do=index* -P doc_nl --cache=off --restrict-file-names=windows -k http://ap-i.net/skychart/nl/documentation/start http://ap-i.net/skychart/nl/news/start --header="X-DokuWiki-Do: export_xhtml"

wget -E -r -p -np -nH --timeout=15 --cut-dirs=1 -X */*detail,*/*export,*/playground -R *do=index* -P doc_ru --cache=off --restrict-file-names=windows -k http://ap-i.net/skychart/ru/documentation/start http://ap-i.net/skychart/ru/news/start --header="X-DokuWiki-Do: export_xhtml"

wget -E -r -p -np -nH --timeout=15 --cut-dirs=1 -X */*detail,*/*export,*/playground -R *do=index* -P doc_tr --cache=off --restrict-file-names=windows -k http://ap-i.net/skychart/tr/documentation/start http://ap-i.net/skychart/tr/news/start --header="X-DokuWiki-Do: export_xhtml"

wget -E -r -p -np -nH --timeout=15 --cut-dirs=1 -X */*detail,*/*export,*/playground -R *do=index* -P doc_uk --cache=off --restrict-file-names=windows -k http://ap-i.net/skychart/uk/documentation/start http://ap-i.net/skychart/uk/news/start --header="X-DokuWiki-Do: export_xhtml"
