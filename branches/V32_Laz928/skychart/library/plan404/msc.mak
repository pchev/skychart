# Microsoft C MSDOS make file
CFLAGS=/c /AL

mer404.obj: mer404.c plantbl.h
	cl $(CFLAGS) mer404.c

ven404.obj: ven404.c plantbl.h
	cl $(CFLAGS) ven404.c
 
ear404.obj: ear404.c plantbl.h
	cl $(CFLAGS) ear404.c

cmoon.obj: cmoon.c 
	cl $(CFLAGS) /Od cmoon.c

mar404.obj: mar404.c plantbl.h
	cl $(CFLAGS) mar404.c

jup404.obj: jup404.c plantbl.h
	cl $(CFLAGS) jup404.c

sat404.obj: sat404.c plantbl.h
	cl $(CFLAGS) sat404.c

ura404.obj: ura404.c plantbl.h
	cl $(CFLAGS) ura404.c

nep404.obj: nep404.c plantbl.h
	cl $(CFLAGS) nep404.c

plu404.obj: plu404.c plantbl.h
	cl $(CFLAGS) plu404.c

gplan.obj: gplan.c plantbl.h
	cl $(CFLAGS) gplan.c

cmoon.obj: cmoon.c
	cl $(CFLAGS) cmoon.c

precess.obj: precess.c
	cl $(CFLAGS) precess.c

epsiln.obj: epsiln.c
	cl $(CFLAGS) epsiln.c

nutate.obj: nutate.c
	cl $(CFLAGS) nutate.c

example.obj: example.c
	cl $(CFLAGS) example.c

example.exe: example.obj mer404.obj ven404.obj ear404.obj mar404.obj \
jup404.obj sat404.obj ura404.obj nep404.obj plu404.obj gplan.obj \
cmoon.obj precess.obj epsiln.obj nutate.obj
	link example mer404 ven404 ear404 mar404 jup404 sat404 ura404 nep404 plu404 gplan cmoon precess epsiln nutate;

