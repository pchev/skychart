mkdir translation
mkdir translation/skychart
rm translation/skychart/*

echo cp ../skychart.po translation/skychart/skychart.pot

echo '# translation of skychart.po Patrick Chevalley <pch@freesurf.ch>, 2006, 2008.'> translation/skychart/skychart.pot
echo '# Patrick Chevalley <pch@ap-i.net>, 2011.'>> translation/skychart/skychart.pot
echo 'msgid ""'>> translation/skychart/skychart.pot
echo 'msgstr ""'>> translation/skychart/skychart.pot
echo '"PO-Revision-Date: 2011-08-27 14:51+0200\n"'>> translation/skychart/skychart.pot
echo '"Last-Translator: Patrick Chevalley <pch@ap-i.net>\n"'>> translation/skychart/skychart.pot
echo '"Project-Id-Version: skychart.en\n"'>> translation/skychart/skychart.pot
echo '"POT-Creation-Date: \n"'>> translation/skychart/skychart.pot
echo '"Language-Team: French <kde-i18n-doc@kde.org>\n"'>> translation/skychart/skychart.pot
echo '"MIME-Version: 1.0\n"'>> translation/skychart/skychart.pot
echo '"Content-Type: text/plain; charset=UTF-8\n"'>> translation/skychart/skychart.pot
echo '"Content-Transfer-Encoding: 8bit\n"'>> translation/skychart/skychart.pot
echo '"X-Generator: Lokalize 1.2\n"'>> translation/skychart/skychart.pot
echo '"Language: fr\n"'>> translation/skychart/skychart.pot
echo '"Plural-Forms: nplurals=2; plural=(n > 1);\n"'>> translation/skychart/skychart.pot

cat ../skychart.po >> translation/skychart/skychart.pot

tar cvf skychartpot.tar translation