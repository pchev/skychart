I/259           The Tycho-2 Catalogue              (Hog+ 2000)
================================================================================
The Tycho-2 Catalogue of the 2.5 Million Brightest Stars
    Hog E., Fabricius C., Makarov V.V., Urban S., Corbin T.,
    Wycoff G., Bastian U., Schwekendiek P., Wicenec A.
   <Astron. Astrophys. (2000)>
   =2000A&A..in.press.H
================================================================================
ADC_Keywords: Positional data ; Proper motions ; Surveys ;
              Photometry ; Stars, double and multiple
Mission_Name: Hipparcos
Keywords: astrometry - stars: fundamental parameters - catalogs

Abstract:
    The Tycho-2 Catalogue is an astrometric reference catalogue containing
    positions  and proper motions  as well as  two-colour photometric data
    for the 2.5 million brightest stars in the sky.  The Tycho-2 positions
    and magnitudes are  based on  precisely the  same observations  as the
    original  Tycho  Catalogue  (hereafter  Tycho-1;  see  Cat.  <I/239>))
    collected  by the  star mapper  of the  ESA Hipparcos  satellite,  but
    Tycho-2 is much bigger  and slightly  more precise,   owing to  a more
    advanced   reduction  technique.   Components  of  double  stars  with
    separations down to 0.8 arcsec are included. Proper motions precise to
    about 2.5 mas/yr are given as  derived  from  a  comparison  with  the
    Astrographic   Catalogue  and   143  other   ground-based  astrometric
    catalogues,  all reduced to the Hipparcos celestial coordinate system.
    Tycho-2  supersedes in most applications Tycho-1,   as well as the ACT
    (Cat.  <I/246>)  and TRC  (Cat. <I/250>)  catalogues based on Tycho-1.
    Supplement-1  lists stars  from the  Hipparcos and  Tycho-1 Catalogues
    which are not in Tycho-2.  Supplement-2 lists 1146 Tycho-1 stars which
    are probably either false or heavily disturbed.

    For more information, please consult the Tycho-2 home page:
    http://www.astro.ku.dk/~erik/Tycho-2

Catalogue Characteristics:

    The principal characteristics of the Tycho-2 Catalogue are
    summarized below. By means of proper motions the positions
    are transferred to the year 2000.0, the epoch of the catalogue.
    The median values of internal standard errors are given.
    ------------------------------------------------------------
    Mean satellite observation epoch      ~J1991.5
    Epoch of the Tycho-2 Catalogue         J2000.0
    Reference system                       ICRS
      coincidence with ICRS (1)             +/-0.6 mas
      deviation from inertial (1)           +/-0.25 mas/yr
    Number of entries                      2,539,913
    Astrometric standard errors (2)
      V_T_ < 9 mag                           7 mas
      all stars, positions                   60 mas
      all stars, proper motions              2.5 mas/yr
    Photometric std. errors (3) on V_T_
      V_T_ < 9 mag                           0.013 mag
      all stars                              0.10 mag
    Star density
      b= 0 deg                             150 stars/sq.deg.
      b= +/-30 deg                          50 stars/sq.deg.
      b= +/-90 deg                          25 stars/sq.deg.
    Completeness to 90 per cent            V ~ 11.5 mag
    Completeness to 99 per cent            V ~ 11.0 mag
    Number of Tycho observations           ~300 10^6^
    ------------------------------------------------------------
    Note (1): about all 3 axes
    Note (2):
        ratio of external to internal standard errors is ~1.0
        for positions and for proper motions. Systematic errors
        are less than 1 mas and 0.5 mas/yr
    Note (3):
        ratio of photometric external to internal standard errors
        at V_T_ > 9 mag is below 1.5
    ------------------------------------------------------------

File Summary:
--------------------------------------------------------------------------------
 FileName     Lrecl    Records    Explanations
--------------------------------------------------------------------------------
ReadMe           80          .    This file
tyc2.dat        206    2539913   *The Tycho-2 main catalogue
suppl_1.dat     122      17588    The Tycho-2 supplement-1
suppl_2.dat     115       1146    The Tycho-2 supplement-2
index.dat        42       9538    Index to Tycho-2 and supplement-1
guide.ps        120       7837    Guide to Tycho-2 (postscript)
guide.pdf         1     428724    Guide to Tycho-2 (pdf)
sample.dat      206       2000    Sample first 2000 records from tyc2.dat  
--------------------------------------------------------------------------------
Note on tyc2.dat:
    This huge file is split into 20 smaller files named tyc2.dat.00,
    tyc2.dat.01, ... tyc2.dat.18, each containing 127000 lines,
    and tyc2.dat.19 which contains the last 126913 lines.
--------------------------------------------------------------------------------

See also:
    I/239 : The Hipparcos and Tycho Catalogues (ESA 1997)
    I/211 : CCDM (Components of Double and Multiple stars) (Dommanget+ 1994)
    I/246 : The ACT Reference Catalog (Urban+ 1997)
    I/250 : The Tycho Reference Catalogue (Hog+ 1998)
    http://www.astro.ku.dk/~erik/Tycho-2 : Tycho-2 home page

Nomenclature Notes:
    The TYC identifier is constructed from the GSC region number (TYC1),
    the running number within the region (TYC2) and a component identifier
    (TYC3) which is normally 1. Some non-GSC running numbers were
    constructed for the first Tycho Catalogue and for Tycho-2.
    The recommended star designation contains a hyphen between the TYC
    numbers, e.g. TYC 1-13-1.

Field separator in the data files:
    In the data files, the fields in each record are separated by
    a vertical bar, |. In this connection the TYC identifier (TYC1, TYC2
    and TYC3) constitutes one field and the pair of a HIP number with a
    CCDM identifier is also considered one field.


Byte-by-byte Description of file: tyc2.dat
--------------------------------------------------------------------------------
   Bytes Format   Units   Label    Explanations
--------------------------------------------------------------------------------
   1-  4  I4      ---     TYC1     [1,9537]+= TYC1 from TYC or GSC (1)
   6- 10  I5      ---     TYC2     [1,12121]  TYC2 from TYC or GSC (1)
      12  I1      ---     TYC3     [1,3]      TYC3 from TYC (1)
      14  A1      ---     pflag    [ PX] mean position flag (2)
  16- 27  F12.8   deg     RAmdeg   []? Mean Right Asc, ICRS, epoch=J2000 (3)
  29- 40  F12.8   deg     DEmdeg   []? Mean Decl, ICRS, at epoch=J2000 (3)
  42- 48  F7.1    mas/yr  pmRA     [-4418.0,6544.2]? prop. mot. in RA*cos(dec)
  50- 56  F7.1    mas/yr  pmDE     [-5774.3,10277.3]? prop. mot. in Dec
  58- 60  I3      mas   e_RAmdeg   [3,183]? s.e. RA*cos(dec),at mean epoch (5)
  62- 64  I3      mas   e_DEmdeg   [1,184]? s.e. of Dec at mean epoch (5)
  66- 69  F4.1   mas/yr e_pmRA     [0.2,11.5]? s.e. prop mot in RA*cos(dec)(5)
  71- 74  F4.1   mas/yr e_pmDE     [0.2,10.3]? s.e. of proper motion in Dec(5)
  76- 82  F7.2    yr      EpRAm    [1915.95,1992.53]? mean epoch of RA (4)
  84- 90  F7.2    yr      EpDEm    [1911.94,1992.01]? mean epoch of Dec (4)
  92- 93  I2      ---     Num      [2,36]? Number of positions used
  95- 97  F3.1    ---   q_RAmdeg   [0.0,9.9]? Goodness of fit for mean RA (6)
  99-101  F3.1    ---   q_DEmdeg   [0.0,9.9]? Goodness of fit for mean Dec (6)
 103-105  F3.1    ---   q_pmRA     [0.0,9.9]? Goodness of fit for pmRA (6)
 107-109  F3.1    ---   q_pmDE     [0.0,9.9]? Goodness of fit for pmDE (6)
 111-116  F6.3    mag     BTmag    [2.183,16.581]? Tycho-2 BT magnitude (7)
 118-122  F5.3    mag   e_BTmag    [0.014,1.977]? s.e. of BT (7)
 124-129  F6.3    mag     VTmag    [1.905,15.193]? Tycho-2 VT magnitude (7)
 131-135  F5.3    mag   e_VTmag    [0.009,1.468]? s.e. of VT (7)
 137-139  I3      ---     prox     [3,999] proximity indicator (8)
     141  A1      ---     TYC      [T] Tycho-1 star (9)
 143-148  I6      ---     HIP      [1,120404]? Hipparcos number
 149-151  A3      ---     CCDM     CCDM component identifier for HIP stars(10)
 153-164  F12.8   deg     RAdeg    Observed Tycho-2 Right Ascension, ICRS
 166-177  F12.8   deg     DEdeg    Observed Tycho-2 Declination, ICRS
 179-182  F4.2    yr    EpRA-1990  [0.81,2.13]  epoch-1990 of RAdeg
 184-187  F4.2    yr    EpDE-1990  [0.72,2.36]  epoch-1990 of DEdeg
 189-193  F5.1    mas   e_RAdeg    s.e.RA*cos(dec), of observed Tycho-2 RA (5)
 195-199  F5.1    mas   e_DEdeg    s.e. of observed Tycho-2 Dec (5)
     201  A1      ---     posflg   [ DP] type of Tycho-2 solution (11)
 203-206  F4.1    ---     corr     [-1,1] correlation (RAdeg,DEdeg)
--------------------------------------------------------------------------------

Note (1): The TYC identifier is constructed from the GSC region number
    (TYC1), the running number within the region (TYC2) and a component
    identifier (TYC3) which is normally 1. Some non-GSC running numbers
    were constructed for the first Tycho Catalogue and for Tycho-2.
    The recommended star designation contains a hyphen between the
    TYC numbers, e.g. TYC 1-13-1.

Note (2):
    ' ' = normal mean position and proper motion.
    'P' = the mean position, proper motion, etc., refer to the
          photocentre of two Tycho-2 entries, where the BT magnitudes
          were used in weighting the positions.
    'X' = no mean position, no proper motion.

Note (3):
    The mean position is a weighted mean for the catalogues contributing
    to the proper motion determination. This mean has then been brought to
    epoch 2000.0 by the computed proper motion. See Note(2) above for
    details. Tycho-2 is one of the several catalogues used to determine
    the mean position and proper motion. The observed Tycho-2 position is
    given in the fields RAdeg and DEdeg.

Note (4):
    The mean epochs are given in Julian years.

Note (5):
    The errors are based on error models.

Note (6):
    This goodness of fit is the ratio of the scatter-based and the
    model-based error. It is only defined when Num > 2. Values
    exceeding 9.9 are truncated to 9.9.

Note (7):
    Blank when no magnitude is available. Either BTmag or VTmag is
    always given. Approximate Johnson photometry may be obtained as:
    V   = VT -0.090*(BT-VT)
    B-V = 0.850*(BT-VT)
    Consult Sect 1.3 of Vol 1 of "The Hipparcos and Tycho Catalogues",
    ESA SP-1200, 1997, for details.

Note (8):
    Distance in units of 100 mas to the nearest entry in the Tycho-2
    main catalogue or supplement. The distance is computed for the
    epoch 1991.25. A value of 999 (i.e. 99.9 arcsec) is given if the
    distance exceeds 99.9 arcsec.

Note (9):
    ' ' = no Tycho-1 star was found within 0.8 arcsec (quality 1-8)
          or 2.4 arcsec (quality 9).
    'T' = this is a Tycho-1 star. The Tycho-1 identifier is given in the
          beginning of the record. For Tycho-1 stars, resolved in
          Tycho-2 as a close pair, both components are flagged as
          a Tycho-1 star and the Tycho-1 TYC3 is assigned to the
          brightest (VT) component.
    The HIP-only stars given in Tycho-1 are not flagged as Tycho-1 stars.

Note (10):
    The CCDM component identifiers for double or multiple Hipparcos stars
    contributing to this Tycho-2 entry. For photocentre solutions, all
    components within 0.8 arcsec contribute. For double star solutions any
    unresolved component within 0.8 arcsec contributes. For single star
    solutions, the predicted signal from close stars were normally
    subtracted in the analysis of the photon counts and such stars
    therefore do not contribute to the solution. The components are given
    in lexical order.

Note (11):
    ' ' = normal treatment, close stars were subtracted when possible.
    'D' = double star treatment. Two stars were found. The companion is
          normally included as a separate Tycho-2 entry, but may have
          been rejected.
    'P' = photocentre treatment, close stars were not subtracted. This
          special treatment was applied to known or suspected doubles
          which were not successfully (or reliably) resolved in the
          Tycho-2 double star processing.
--------------------------------------------------------------------------------

Byte-by-byte Description of file: suppl_1.dat, suppl_2.dat
--------------------------------------------------------------------------------
   Bytes Format   Units   Label    Explanations
--------------------------------------------------------------------------------
   1-  4  I4      ---     TYC1     [2,9529]+= TYC1 from TYC (1)
   6- 10  I5      ---     TYC2     [1,12112]  TYC2 from TYC (1)
      12  I1      ---     TYC3     [1,4]      TYC3 from TYC (1)
      14  A1      ---     flag     [HT] data from Hipparcos or Tycho-1 (2)
  16- 27  F12.8   deg     RAdeg    Right Asc, ICRS, at epoch=J1991.25
  29- 40  F12.8   deg     DEdeg    Decl, ICRS, at epoch=J1991.25
  42- 48  F7.1    mas/yr  pmRA     []? prop. mot. in RA*cos(dec)
  50- 56  F7.1    mas/yr  pmDE     []? prop. mot. in Dec
  58- 62  F5.1    mas   e_RAdeg    s.e. RA*cos(dec)
  64- 68  F5.1    mas   e_DEdeg    s.e. of Dec
  70- 74  F5.1   mas/yr e_pmRA     []? s.e. prop mot in RA * cos(dec)
  76- 80  F5.1   mas/yr e_pmDE     []? s.e. of proper motion in Dec
      82  A1      ---     mflag    [ BVH] (3)
  84- 89  F6.3    mag     BTmag    []? Tycho-1 BT magnitude (4)
  91- 95  F5.3    mag   e_BTmag    []? s.e. of BT (4)
  97-102  F6.3    mag     VTmag    []?  Tycho-1 VT or Hp magnitude (4)
 104-108  F5.3    mag   e_VTmag    []? s.e. of VT (4)
 110-112  I3      ---     prox     [1,999] proximity indicator (5)
     114  A1      ---     TYC      [ T] Tycho-1 star
 116-121  I6      ---     HIP      [1,120404]? Hipparcos number
     122  A1      ---     CCDM     CCDM component identifier for HIP stars
--------------------------------------------------------------------------------

Note (1): The TYC identifier is constructed from the GSC region number (TYC1),
    the running number within the region (TYC2) and a component identifier
    (TYC3) which is normally 1. The numbers are copied from Tycho-1.
    (see the "Nomenclature Notes" section above)

Note (2):
    'H' = data are from Hipparcos and include proper motion.
    'T' = data are from Tycho-1. No proper motion is given.

Note (3):
    ' ' = both BT and VT given.
    'B' = only BT given.
    'V' = only VT given.
    'H' = Hp is given instead of VT. BT is blank.

Note (4):
    Blank when no magnitude is available.
    For Hipparcos stars with no VT, Hp is given instead of VT, and BT is blank.

Note (5):
    Distance in units of 100 mas to nearest Tycho-2 main or supplement
    entry. (Computed for the epoch 1991.25). A value of 999 (i.e. 99.9
    arcsec) is given if the distance exceeds 99.9 arcsec.
--------------------------------------------------------------------------------

Byte-by-byte Description of file: index.dat
--------------------------------------------------------------------------------
   Bytes Format  Units   Label     Explanations
--------------------------------------------------------------------------------
   1-  7  I7     ---     rec_t2    +  Tycho-2 rec. of 1st star in region (1)
   9- 14  I6     ---     rec_s1    += Suppl-1 rec. of 1st star in region (1)
  16- 21  F6.2   deg     RAmin     [-0.01,] smallest RA in region (2)
  23- 28  F6.2   deg     RAmax     [,360.00] largest RA in region (2)
  30- 35  F6.2   deg     DEmin     smallest Dec in this region (2)
  37- 42  F6.2   deg     DEmax     largest Dec in this region (2)
--------------------------------------------------------------------------------

Note (1): The catalogue is sorted according to the GSC region numbers.
    The line i of the index file gives the record number in Tycho-2 of
    the first star in GSC region i. Line i+1 gives the record number +1
    of the last star in GSC region i. For Supplement-1, some regions are
    empty and line i and line i+1 give the same record number.

Note (2): a safe rounding was applied. Minimum values are always
    rounded down and maximum values up.
--------------------------------------------------------------------------------

================================================================================
(End)                       C. Fabricius  [Niels Bohr Institute]     19-Jan-2000
