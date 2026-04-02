
# Based on https://github.com/cyschneck/iau-star-names/blob/main/data/web_scrape_iau_catalog.py
# Main change is to use Sesame to get the additional data
# Kepp only the Origin column with unicode character so it can be processed as a fixed column file by Catgen

import sys
import time
import random
import lxml.etree as ET 
import re
from bs4 import BeautifulSoup
import pandas as pd
from urllib import request, error

user_agents = [
        'Mozilla/6.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/109.0.0.0 Safari/537.36',
        'Mozilla/6.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/109.0.0.0 Safari/537.36',
        'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/108.0.0.0 Safari/537.36',
        'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/108.0.0.0 Safari/537.36',
        'Mozilla/6.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/108.0.0.0 Safari/537.36',
        'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/16.1 Safari/605.1.15',
        'Mozilla/5.0 (Macintosh; Intel Mac OS X 13_1) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/16.1 Safari/605.1.15'
]

def IAU_CSN(sesame=True):
    # get all valid named stars
    random_agent = random.choice(user_agents)
    iau_catalog_url = "https://exopla.net/star-names/modern-iau-star-names/"
    print(f"Retrieving from full IAU list from {iau_catalog_url}")
    req_with_headers = request.Request(url=iau_catalog_url, headers={'User-Agent': random_agent})

    catalog_html = request.urlopen(req_with_headers).read()   
    
    full_body = BeautifulSoup(catalog_html, 'html.parser')

    table_body = full_body.find(id="table_1")
    rows = table_body.find_all("tr")
    
    count = 0
    all_rows = []
    for i, row in enumerate(rows):
        columns = row.find_all(["th", "td"])
        row_data = [column.text.strip() for column in columns]
        NAME = row_data[0]
        ID = row_data[1]
        DES = row_data[2]
        DES = DES.replace('* ','')
        DES = DES.replace('*','')
        HIP = row_data[3]
        BAYER = row_data[4]
        SIMBAD = row_data[5]
        SIMBAD=SIMBAD.replace('í','i') 
        SIMBAD=SIMBAD.replace('ì','i') 
        CONST = row_data[6]
        ORIG = row_data[7]
        ORIG = ORIG.replace('\n', ' ')
        ORIG = ORIG.replace('"', '')
        ETNI = row_data[8]
        REF = row_data[9]
        DATE = row_data[10]
        IMG = row_data[11]
        IMGS = row_data[12]
        RA = row_data[13]
        DEC = row_data[14]
        MAG = re.sub("[^0-9.]", "", row_data[15])
        BAYER = BAYER.replace(u"\u03b1","alp") 
        BAYER = BAYER.replace(u"\u03b2","bet")
        BAYER = BAYER.replace(u"\u03b3","gam")
        BAYER = BAYER.replace(u"\u03b4","del")
        BAYER = BAYER.replace(u"\u03b5","eps")
        BAYER = BAYER.replace(u"\u03b6","zet")
        BAYER = BAYER.replace(u"\u03b7","eta")
        BAYER = BAYER.replace(u"\u03b8","the")
        BAYER = BAYER.replace(u"\u03b9","iot")
        BAYER = BAYER.replace(u"\u03ba","kap")
        BAYER = BAYER.replace(u"\u03bb","lam")
        BAYER = BAYER.replace(u"\u03bc","mu")
        BAYER = BAYER.replace(u"\u03bd","nu")
        BAYER = BAYER.replace(u"\u03be","ksi")
        BAYER = BAYER.replace(u"\u03bf","omi")
        BAYER = BAYER.replace(u"\u03c0","pi")
        BAYER = BAYER.replace(u"\u03c1","rho")
        BAYER = BAYER.replace(u"\u03c3","sig")
        BAYER = BAYER.replace(u"\u03c4","tau")
        BAYER = BAYER.replace(u"\u03c5","ups")
        BAYER = BAYER.replace(u"\u03c6","phi")
        BAYER = BAYER.replace(u"\u03c7","chi")
        BAYER = BAYER.replace(u"\u03c8","psi")
        BAYER = BAYER.replace(u"\u03c9","ome")      
        # other encoding for Aldu, Garnet Star, Elgafar ?? 
        BAYER = BAYER.replace("ϵ","eps")
        BAYER = BAYER.replace("µ","mu")
        BAYER = BAYER.replace("ϕ","phi")
        
        if SIMBAD=='' :
           continue   # Unurgunite

        if sesame: 
          if "proper names" not in row_data:  
           print(str(count)+' =='+SIMBAD+'==')
           if (DES!='') and (DES!='-'):
             search=DES
           elif HIP!='':
             search='HIP '+HIP
           else:
             search=SIMBAD
           print(search)  
           count+=1
           fn='sesame.xml'
           url='https://cds.unistra.fr/cgi-bin/nph-sesame/-ofxp/S?'+search.replace(' ', '%20')
           request.urlretrieve(url,fn)
           tree = ET.parse(fn)
           try:
              Sname=tree.xpath("/Sesame/Target/name")[0].text
              Sra=tree.xpath("/Sesame/Target/Resolver/jradeg")[0].text
              Sde=tree.xpath("/Sesame/Target/Resolver/jdedeg")[0].text
              try:
                 Spmra=tree.xpath("/Sesame/Target/Resolver/pm/pmRA")[0].text
                 Spmde=tree.xpath("/Sesame/Target/Resolver/pm/pmDE")[0].text
              except:
                 Spmra=0
                 Spmde=0
              try:
                 Smag=tree.xpath('/Sesame/Target/Resolver/mag[@band="V"]/v')[0].text
              except:
                 try:
                    Smag=tree.xpath('/Sesame/Target/Resolver/mag/v')[0].text
                 except:
                    Smag=MAG 
           except:
              print('Not found in Sesame =====================================================') 
              Sname=''
              Sra=RA
              Sde=DEC
              Spmra=0
              Spmde=0
              Smag=MAG 
        
           RA=Sra
           DEC=Sde
           PMRA=Spmra
           PMDE=Spmde
           MAG=Smag
          else:
           SIMBAD='NAME'
           RA='RA'
           DEC='DEC'
           MAG='MAG'
           PMRA='PMRA'
           PMDE='PMDE'
           ORIG='ORIG'
        else:
          PMRA=0
          PMDE=0
           
        row_data[0]=f'{SIMBAD:<20}'
        row_data[1]=f'{HIP:<20}'
        row_data[2]=f'{DES:<20}'
        row_data[3]=f'{BAYER:<20}'
        row_data[4]=f'{RA:<20}'
        row_data[5]=f'{DEC:<20}'
        row_data[6]=f'{MAG:<20}'
        row_data[7]=f'{PMRA:<20}'
        row_data[8]=f'{PMDE:<20}'
        row_data[9]=f'{ORIG:<2000}'
        row_data.pop(15)
        row_data.pop(14)
        row_data.pop(13)
        row_data.pop(12)
        row_data.pop(11)
        row_data.pop(10)

        all_rows.append(row_data)
        
    # save to csv
    column_names = all_rows[0]
    #column_names[0] = column_names[0].title() # capitalize "Proper Names"
    iau_stars = pd.DataFrame(all_rows[1:], columns=column_names)
    iau_stars = iau_stars.sort_values(iau_stars.columns[0], ascending=True)
    iau_stars.to_csv("1_iau_stars.csv", sep='|', index=False)
    return
    

if __name__ == '__main__':

    # Collect dta from IAU WSGN 
    IAU_CSN(sesame=True)                  # retrieve official list of IAU names -> saved to iau_stars.csv
    
