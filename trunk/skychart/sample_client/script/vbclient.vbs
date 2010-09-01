' example program to connect to Skychart from VB script
' it use the free w3Sockets library from Dimac http://www.dimac.net
' http://www.dimac.net/Products/FreeProducts/w3Sockets/start.htm

Dim cdc
set cdc = CreateObject("Socket.TCP")                                                      
cdc.Host = "localhost:3292"
cdc.open
msg = cdc.getline

cdc.sendline "setproj EQUAT"
msg = cdc.getline
cdc.sendline "setfov 15"
msg = cdc.getline
cdc.sendline "search M1"
msgm1 = cdc.getline
cdc.sendline "redraw"
msg = cdc.getline
msgbox msgm1

cdc.sendline "saveimg PNG C:\vbclient.png 0"
msg = cdc.getline

msgbox "Image saved to C:\vbclient.png "+ msg

cdc.Close
