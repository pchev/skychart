#!/usr/bin/python
# -*- coding: UTF-8 -*-

# example script that list rise and set azimuth in csv format 
# from the list of object in file rise_set_list.txt
# error messages are directed to stderr
# require Skychart version 4.0
# use : python rise_set.py > rise_set.csv

import os
import sys
import socket

# default values. 
HOST = 'localhost'
PORT = 3292

# Real port values can be read from ~/.skychart/tmp/tcpport when skychart is running
# In Windows change this to read the registry key HKCU\Software\Astro_PC\Ciel\Status\TcpPort
#f = open(HOMEDIR+'/.skychart/tmp/tcpport','r')
#PORT = int(f.read())
#f.close

# set the observation list to use here:
starlist = os.getcwd()+'/rise_set_list.txt'

if PORT==0 :
   sys.stderr.write('Skychart is not running\n')
   exit(1)
   
# function to clear the receive buffer
def purgebuffer():
  s.setblocking(0)
  resp = '.\r\n'
  while resp<>'':
    try:
      resp = s.recv(1024)
    except:
      resp = ''
  s.setblocking(1)
  return resp

# function to send a command and wait for the response
def cdccmd(cmd,prterr=True):
  purgebuffer()
  s.setblocking(1)
  s.send(cmd+'\r\n')
  data = ''
  resp = '.\r\n'
  while True:
    resp = s.recv(1024)
    data = data + resp
    if ("OK!" in resp)or("Failed!" in resp)or("Not found!" in resp):
      break
  if (prterr)and("OK!" not in resp) :
     sys.stderr.write(cmd+' '+data)
  return data
 

#############################################################
#  Start of the main program
#############################################################

def decimaldeg(dms):
    p1 = dms.index("°")
    p2 = dms.index("'")
    sdeg = dms[:p1]
    smin = dms[p1+len("°"):p2]
    ddeg = float(sdeg)
    dmin = float(smin)
    ddeg = ddeg + dmin/60
    return "{:.2f}".format(ddeg)
    

# Connect to Skychart
try:
  s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
  s.connect((HOST, PORT))
  data = s.recv(1024)
except:
  sys.stderr.write('Connection error. Is Skychart running?\n') 
  exit(1)

# Set chart option
cdccmd('SETFOV 90')
cdccmd('SETPROJ EQUAT')
cdccmd('REDRAW')

f = open(starlist,'r')

print 'Object;Name;Magn;AzRise;AzSet'

for l in f:
   obj = l.strip()
   cdccmd('CLEANUPMAP');
   data = cdccmd('SEARCH "'+obj+'"')
   #print data
   try:
      lst = data.split("\t")
      name = lst[5]
      magn = lst[6]
      p = magn.find(":")+1
      magn = magn[p:]
   except:
      magn = ''
      name = ''
   data = cdccmd('GETRISESET')
   #print data
   try:
      p = data.index("Az:")+3
      azr = data[p:p+8]
      azr = decimaldeg(azr)
      buf = data[p:]
      p = buf.index("Az:")+3
      azs = buf[p:p+8]
      azs = decimaldeg(azs)
      print obj+';'+name+';'+magn+';'+azr+';'+azs
      
   except:
      sys.stderr.write('Ignore: '+data) 
      pass

f.close

# Close connexion to Skychart
s.close()
