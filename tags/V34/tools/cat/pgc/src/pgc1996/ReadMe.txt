VII/119             Catalogue of Principal Galaxies (PGC)   (Paturel+ 1989)
================================================================================
Catalogue of Principal Galaxies (PGC)
     Paturel G., Fouque P., Bottinelli L., Gouguenheim L.
    <Astron. Astrophys. Suppl. Ser. 80, 299 (1989)>
    =1989A&AS...80..299P
================================================================================
ADC_Keywords: Galaxy catalogs

Description:
    This "catalog of principal galaxies" constitutes the basis of the
    "Third Reference Catalogue of Bright Galaxies" (RC3). It lists
    equatorial coordinates for the equinoxes 1950 and 2000 and cross
    identifications for 73197 galaxies. Of the 73197 galaxies, 40932 have
    coordinates with standard deviations of less than ten arcsec. Listed
    are 131,601 names from the 38 most common sources. These data are
    given when available: morphological descriptions, apparent major and
    minor axes, apparent magnitudes, radial velocities, and position
    angles.


Related data:
    VII/137B : Third Reference Catalogue of bright galaxies (RC3)

File Summary:
--------------------------------------------------------------------------------
 FileName    Lrecl    Records    Explanations
--------------------------------------------------------------------------------
ReadMe          80          .    This file
pgc            142      77141    The PGC catalogue
--------------------------------------------------------------------------------

Byte-by-byte Description of file: pgc
--------------------------------------------------------------------------------
   Bytes Format  Units   Label     Explanations
--------------------------------------------------------------------------------
   1-  5  I5     ---     PGC       [1/73197]?+ PGC Number (1)
   7-  8  I2     h       RAh       []? Right Ascension 2000 (hours) (1)
   9- 10  I2     min     RAm       []? Right Ascension 2000 (minutes) (1)
  11- 14  F4.1   s       RAs       []? Right Ascension 2000 (seconds) (1)
      15  A1     ---     DE-       Declination 2000 (sign) (1)
  16- 17  I2     deg     DEd       []? Declination 2000 (degrees) (1)
  18- 19  I2     arcmin  DEm       []? Declination 2000 (minutes) (1)
  20- 21  I2     arcsec  DEs       []? Declination 2000 (seconds) (1)
  23- 24  I2     h       RAh1950   []? Right Ascension 1950 (hours) (1)
  25- 26  I2     min     RAm1950   []? Right Ascension 1950 (minutes) (1)
  27- 30  F4.1   s       RAs1950   []? Right Ascension 1950 (seconds) (1)
      31  A1     ---     DE-1950   Declination 1950 (sign) (1)
  32- 33  I2     deg     DEd1950   []? Declination 1950 (degrees) (1)
  34- 35  I2     arcmin  DEm1950   []? Declination 1950 (minutes) (1)
  36- 37  I2     arcsec  DEs1950   []? Declination 1950 (seconds) (1)
      38  A1     ---     u_DEs     [*] An asterisk indicates coordinates
                                       with standard deviations less than
                                       10arcsec (1)
  40- 43  A4     ---     MType     Morphological type class; see section 3.1 of
                                       the publication for details (1)
  44- 49  F6.1   arcmin  MajAxis   []? Major axis diameter at 25mag/arcsec2 (1)
      50  A1     ---     u_MajAxis [:?*] Uncertainty (:?) or accuracy (*) flag
                                       on MajAxis (1)
      51  A1     ---     times     [x] separation character (1)
  52- 56  F5.1   arcmin  MinAxis   []? Minor axis diameter at 25mag/arcsec2 (1)
      57  A1     ---     u_MinAxis [:?*] Uncertainty (:?) or accuracy (*) flag
                                         on MinAxis (1)
  60- 63  F4.1   mag     Btot      []? Apparent total magnitude; see section 3.3
                                      of the publication for details (1)
      64  A1     ---     u_Btot    [*] An asterisk indicates magnitudes with
                                       accuracy less than 0.3mag (1)
  67- 71  I5     km/s    HRV       []? Heliocentric Radial Velocity (1)
      72  A1     ---     u_HRV     [*] An asterisk indicates velocities with
                                      standard deviations less than 30km/s (1)
  74- 76  I3     deg     PA        [0/180[? Position Angle from North eastward
                                      in 1950 frame (1)
  78- 93  A16    ---     Name1     Name of galaxy in other sources (2)
  94-109  A16    ---     Name2     Name of galaxy in other sources (2)
 110-125  A16    ---     Name3     Name of galaxy in other sources (2)
 126-141  A16    ---     Name4     Name of galaxy in other sources (2)
     142  A1     ---     Cont      [+] if a continuation record exists (1)
--------------------------------------------------------------------------------
Note (1): field empty for continuation lines, i.e. preceding line has a
    '+' in byte 142
Note (2): acronyms and references for designations are given in Table 2
    of the publication
--------------------------------------------------------------------------------

Historical Notes:
  * A copy of the catalogue on magnetic tape was provided to CDS by
    G. Paturel
  * 03-Oct-1995: description standardized at CDS
================================================================================
(End)                                     Francois Ochsenbein [CDS]  03-Oct-1995
