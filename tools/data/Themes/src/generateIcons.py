# A script to generate png icons from svgs
# Probably not the best, but it does the work
# It needs Inkscape installed on the system

import os

currDir = os.path.dirname(os.path.realpath(__file__))
svgDir = currDir + os.sep + "svg"
pngDir = currDir + os.sep + "icons"

with open('corrispondenze.txt', 'r') as indexFile :
	for line in indexFile :
		record = line.split('\t')
		
		for style in ("daylight","night-vision") :
			for svgSize in ("16","22") :
				svgFile = svgDir + os.sep + style + os.sep + svgSize+"x"+svgSize + os.sep + record[1].strip() + ".svg"
				#Check files existence
				if not os.path.isfile(svgFile) :
					print(svgFile + " not found")
					sys.exit()
				#Use 16px SVGs only for 16px icons and 22px SVGs for upscale
				if svgSize == "22" :
					for pngSize in ("22","32","64") :
						#Check png directory existence
						if not os.path.exists(pngDir + os.sep + style + os.sep + pngSize+"x"+pngSize) :
							os.makedirs(pngDir + os.sep + style + os.sep + pngSize+"x"+pngSize)
						pngFile = pngDir + os.sep + style + os.sep + pngSize+"x"+pngSize + os.sep + record[0].strip() + ".png"
						os.system("inkscape -z -f \"" + svgFile +"\" -w " + pngSize + " -e \"" + pngFile + "\"")
				else :
					#Check png directory existence
					if not os.path.exists(pngDir + os.sep + style + os.sep + svgSize+"x"+svgSize) :
						os.makedirs(pngDir + os.sep + style + os.sep + svgSize+"x"+svgSize)
					pngFile = pngDir + os.sep + style + os.sep + svgSize+"x"+svgSize + os.sep + record[0].strip() + ".png"
					os.system("inkscape -z -f \"" + svgFile +"\" -w " + svgSize + " -e \"" + pngFile + "\"")
