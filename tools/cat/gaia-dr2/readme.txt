Download gaia files:

wget -r -l1 http://cdn.gea.esac.esa.int/Gaia/gdr2/gaia_source/csv/
61234 files
$ du -hs csv
548G    csv

Download Hipparcos cross ref:
https://gaia.aip.de/query/
select "source_id","original_ext_source_id" from "gdr2"."hipparcos2_best_neighbour" order by "source_id"
Submit
Download -> CSV

Compile extractgaia.lpr with Lazarus

Run extractgaia
This produce files by magnitude range with the following column:
source_id, ra, dec, parallax, pmra, pmdec, phot_g_mean_mag, phot_bp_mean_mag, phot_rp_mean_mag, radial_velocity

Process with Catgen : gaia1.prj gaia2.prj gaia3.prj

