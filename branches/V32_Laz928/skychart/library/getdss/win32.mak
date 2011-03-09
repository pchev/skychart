get_dss.exe: get_dss.obj dss.obj extr_fit.obj getpiece.obj \
      hdcmprss.obj bitinput.obj decode.obj dodecode.obj hinv.obj \
      platelst.obj qtreedec.obj
   link      get_dss.obj dss.obj extr_fit.obj getpiece.obj \
      hdcmprss.obj bitinput.obj decode.obj dodecode.obj hinv.obj \
      platelst.obj qtreedec.obj >> err
   type err

CFLAGS=-W3 -Ox -c -D_CONSOLE
DLL_CFLAGS=-W3 -Ox -c -LD

.cpp.obj:
   cl $(CFLAGS) $< >> err
   type err

bitinput.obj:

decode.obj:

dodecode.obj:

dss.obj:

extr_fit.obj:

getpiece.obj:

get_dss.obj:

hdcmprss.obj:

hinv.obj:

platelst.obj:

qtreedec.obj:

