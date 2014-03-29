#!/usr/bin/python

# example script that load an observation list
# and loop on every visible object from this list

import os
import time
import socket

# default values. 
HOST = 'localhost'
PORT = 3292

HOMEDIR = os.environ["HOME"]
# Real port values can be read from ~/.skychart/tmp/tcpport when skychart is running
# In Windows change this to read the registry key HKCU\Software\Astro_PC\Ciel\Status\TcpPort
f = open(HOMEDIR+'/.skychart/tmp/tcpport','r')
PORT = int(f.read())
f.close

# set the observation list to use here:
obslist = os.getcwd()+'/testlist.txt'

if PORT==0 :
   print 'Skychart is not running'
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
    if ("OK!" in resp)or("Failed!" in resp):
      break
  if (prterr)and("OK!" not in resp) :
     print cmd+' '+data
  return data

#############################################################
#  Start of the main program
#############################################################

# Connect to Skychart
s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
s.connect((HOST, PORT))
data = s.recv(1024)
print data 

# Set chart option
cdccmd('SETFOV 90')
cdccmd('SETPROJ ALTAZ')
cdccmd('REDRAW')


# Connect the telescope
cdccmd('CONNECTTELESCOPE')
cdccmd('REDRAW')
time.sleep(2)

# Load the observation list 
print 'Load the observation list: '+obslist
cdccmd('OBSLISTLOAD '+obslist)
# Set limit to observable objects
cdccmd('OBSLISTAIRMASSLIMIT 2')
cdccmd('OBSLISTLIMIT ON')

# Select first object
data = cdccmd('OBSLISTFIRST')
while 'Failed!' not in data:
   obj = ''
   p = data.find('OK!')
   if p>=0 :
     obj = data[p+3:]
   print 'Process object: '+obj
   # Slew the telescope to selected object
   cdccmd('SLEW')
   # wait slew is completed
   data=cdccmd('GETSCOPERADEC')
   prevdata=''
   while data<>prevdata :
     time.sleep(5)
     prevdata=data
     data=cdccmd('GETSCOPERADEC')
     print "Telescope position: "+data.strip(' \t\n\r')
   print 'Telescope pointed on '+obj  
   ##
   ## Insert here the code to command the guider and CCD camera
   ##
   print "Start auto-guider"
   print "Start CCD exposure"
   time.sleep(5)
   print "End CCD exposure"
   print "Stop auto-guider"
   print
   ##
   # refresh limit for current time
   cdccmd('OBSLISTLIMIT ON')
   # Go to next object in list
   data = cdccmd('OBSLISTNEXT',False)

print 'End of observation list'

# Disconnect the telescope
cdccmd('DISCONNECTTELESCOPE')

# Close connexion to Skychart
s.close()


  
  
