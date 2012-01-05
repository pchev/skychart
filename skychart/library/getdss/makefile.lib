CPPFLAGS=-I. -DUNIX -D_CONSOLE
#### For Suns and similar wrong-endian computers, use -DWRONG_WAY_BYTE_ORDER.
####(I disagree, Intels etc. _are_ wrong-endian :-) 2001-12-07mn
####
#CPPFLAGS=-I. -DUNIX -D_CONSOLE -DWRONG_WAY_BYTE_ORDER
SO_Name = libgetdss.so
LDFLAGS= -shared -WL,-soname,$(SO_Name)
OBJS = getdss_lib.o dss.o extr_fit.o getpiece.o \
	hdcmprss.o bitinput.o decode.o dodecode.o hinv.o \
	platelst.o qtreedec.o
LIBS = -lm -lstdc++
$(SO_Name):  $(OBJS)
	$(CC) $(LDFLAGS) -o $@ $(OBJS) $(LIBS)
	
