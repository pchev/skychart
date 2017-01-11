Create a local HyperLeda mirror, see  http://leda.univ-lyon1.fr/install/mirror.html
"make install-hyperleda" without the web interface is sufficient.

The following query is used to create the data file:

pleinpot/bin/exe/psql -o leda.txt -c "select pgc, objname, al2000, de2000, bt, bvt as vt, brief as sbr, objtype, type, round(cast((10 ^ logd25)/10 as numeric),2) as amax,round(cast((10 ^ logd25)/10 / (10 ^ logr25) as numeric),2) as amin , pa, v from meandata where objtype  in ('g','G','M2','M3','MC','MG','Q') " hl 

Then use leda.prj with Catgen to make the CdC catalog.
