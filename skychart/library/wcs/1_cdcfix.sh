#!/bin/bash

# minor fix for wcstools

# correct FSF address
sed -i 's/51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA/51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA/' *

# fix name conflict with mingw
sed -i 's/wcsrev(/wcsrev1(/g' *.c *.h
sed -i 's/wcsset(/wcsset1(/g' *.c *.h
sed -i 's/wcsrev (/wcsrev1 (/g' *.c *.h
sed -i 's/wcsset (/wcsset1 (/g' *.c *.h
