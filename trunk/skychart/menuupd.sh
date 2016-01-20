# Update the menu item list for scripting reference

grep TMenuItem pu_main.lfm | sed 's/object//'| sed 's/: TMenuItem//' | grep -v N[0123456789]| grep -v MenuItem[0123456789]| grep -v topmessage| grep -v ResetAllLabels1 > menu.txt
