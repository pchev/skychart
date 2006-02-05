CFLAGS=		/DEBUG/NOLIST
hfiles=		kep.h-
		planet.h-

ofiles=		example.obj-
		epsiln.obj-
		cmoon.obj-
		nutate.obj-
		ear404.obj-
		jup404.obj-
		mar404.obj-
		mer404.obj-
		nep404.obj-
		sat404.obj-
		ura404.obj-
		ven404.obj-
		precess.obj-

example.exe : $(ofiles)
	LINK  example/option
example.obj : example.c,$(HFILES)
    CC $(CFLAGS) aa
epsiln.obj : epsiln.c,$(HFILES)
    CC $(CFLAGS) epsiln
cmoon.obj : cmoon.c,$(HFILES)
    CC $(CFLAGS) cmoon
nutate.obj : nutate.c,$(HFILES)
    CC $(CFLAGS) nutate
ear404.obj : ear404.c,$(HFILES)
    CC $(CFLAGS) ear404
jup404.obj : jup404.c,$(HFILES)
    CC $(CFLAGS) jup404
mar404.obj : mar404.c,$(HFILES)
    CC $(CFLAGS) mar404
mer404.obj : mer404.c,$(HFILES)
    CC $(CFLAGS) mer404
nep404.obj : nep404.c,$(HFILES)
    CC $(CFLAGS) nep404
sat404.obj : sat404.c,$(HFILES)
    CC $(CFLAGS) sat404
ura404.obj : ura404.c,$(HFILES)
    CC $(CFLAGS) ura404
ven404.obj : ven404.c,$(HFILES)
    CC $(CFLAGS) ven404
precess.obj : precess.c,$(HFILES)
    CC $(CFLAGS) precess
