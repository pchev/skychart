get_dss.exe:  get_dss.obj dss.obj extr_fit.obj getpiece.obj &
      hdcmprss.obj bitinput.obj decode.obj dodecode.obj hinv.obj &
      platelst.obj qtreedec.obj
   wlink name get_dss.exe @get_dss.lnk >> err
   type err

CFLAGS=-w4 -oxt -j

.cpp.obj:
   wcc386 $(CFLAGS) $< >> err
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

