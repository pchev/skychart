# -*- coding:utf-8 -*-
#
# MIT License
#
# Copyright (c) 2019 Mattia Verga <mattia.verga@tiscali.it>
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
#
"""A simple script to generate png icons from svgs.
Probably not the best, but it does the work.
It needs Inkscape installed on the system.
"""

import os
import sys

svgDir = os.path.join(os.path.dirname(__file__), 'svg')
pngDir = os.path.join(os.path.dirname(__file__), 'icons')
styles = ('daylight', 'night-vision')
# Use 16px SVGs only for 16px icons and 22px SVGs for upscale
mapSizes = {'16': ('16', ),
            '22': ('22', '32', '48', '64', )}

with open('corrispondenze.txt', 'r') as indexFile:
    for line in indexFile:
        record = line.split('\t')

        for style in styles:
            for svgSize in mapSizes.keys():
                svgFile = os.path.join(svgDir,
                                       style,
                                       f'{svgSize}x{svgSize}',
                                       f'{record[1].strip()}.svg'
                                       )
                # Check files existence
                if not os.path.isfile(svgFile):
                    print(f'{svgFile} not found')
                    sys.exit()

                for pngSize in mapSizes[svgSize]:
                    # Check png directory existence
                    if not os.path.exists(os.path.join(pngDir,
                                                       style,
                                                       f'{pngSize}x{pngSize}'
                                                       )):
                        os.makedirs(os.path.join(pngDir, style, f'{pngSize}x{pngSize}'))

                    pngFile = os.path.join(pngDir,
                                           style,
                                           f'{pngSize}x{pngSize}',
                                           f'{record[0].strip()}.png'
                                           )
                    # Create icon only if not existent
                    if not os.path.isfile(pngFile):
                        os.system(f'inkscape -z -f "{svgFile}" -w {pngSize} -e "{pngFile}"')
