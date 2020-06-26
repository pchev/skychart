#!/bin/bash

# minor fix for wcstools

# correct FSF address
sed -i 's/51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA/51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA/' *

# fix name conflict with mingw
sed -i 's/wcsrev1(/wcsrev1(/g' *
sed -i 's/wcsset1(/wcsset1(/g' *
sed -i 's/wcsrev1 (/wcsrev1 (/g' *
sed -i 's/wcsset1 (/wcsset1 (/g' *
