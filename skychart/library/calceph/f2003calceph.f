!/*-----------------------------------------------------------------*/
!/*! 
!  \file f2003calceph.f 
!  \brief fortran 2003 binding interface
!         requires a fortran compiler with the standard fortran 2003.
!
!  \author  M. Gastineau 
!           Astronomie et Systemes Dynamiques, IMCCE, CNRS, Observatoire de Paris. 
!
!   Copyright, 2008-2019,  CNRS
!   email of the author : Mickael.Gastineau@obspm.fr
! 
!
!*/
!/*-----------------------------------------------------------------*/

!/*-----------------------------------------------------------------*/
!/* License  of this file :
!  This file is "triple-licensed", you have to choose one  of the three licenses 
!  below to apply on this file.
!  
!     CeCILL-C
!     	The CeCILL-C license is close to the GNU LGPL.
!     	( http://www.cecill.info/licences/Licence_CeCILL-C_V1-en.html )
!   
!  or CeCILL-B
!        The CeCILL-B license is close to the BSD.
!        (http://www.cecill.info/licences/Licence_CeCILL-B_V1-en.txt)
!  
!  or CeCILL v2.1
!       The CeCILL license is compatible with the GNU GPL.
!       ( http://www.cecill.info/licences/Licence_CeCILL_V2.1-en.html )
!  
! 
! This library is governed by the CeCILL-C, CeCILL-B or the CeCILL license under 
! French law and abiding by the rules of distribution of free software.  
! You can  use, modify and/ or redistribute the software under the terms 
! of the CeCILL-C,CeCILL-B or CeCILL license as circulated by CEA, CNRS and INRIA  
! at the following URL "http://www.cecill.info". 
!
! As a counterpart to the access to the source code and  rights to copy,
! modify and redistribute granted by the license, users are provided only
! with a limited warranty  and the software's author,  the holder of the
! economic rights,  and the successive licensors  have only  limited
! liability. 
!
! In this respect, the user's attention is drawn to the risks associated
! with loading,  using,  modifying and/or developing or reproducing the
! software by the user in light of its specific status of free software,
! that may mean  that it is complicated to manipulate,  and  that  also
! therefore means  that it is reserved for developers  and  experienced
! professionals having in-depth computer knowledge. Users are therefore
! encouraged to load and test the software's suitability as regards their
! requirements in conditions enabling the security of their systems and/or 
! data to be ensured and,  more generally, to use and operate it in the 
! same conditions as regards security. 
!
! The fact that you are presently reading this means that you have had
! knowledge of the CeCILL-C,CeCILL-B or CeCILL license and that you accept its terms.
! */
! /*-----------------------------------------------------------------*/

        MODULE calceph
! /*----------------------------------------------------------------------------------------------*/
! /* definition of the CALCEPH library version */
! /*----------------------------------------------------------------------------------------------*/
! version : major number of CALCEPH library
       integer, parameter ::  CALCEPH_VERSION_MAJOR=3
! version : minor number of CALCEPH library
       integer, parameter ::  CALCEPH_VERSION_MINOR=4
!  version : patch number of CALCEPH library 
       integer, parameter ::  CALCEPH_VERSION_PATCH=6
!  version : string of characters
       character(*), parameter :: CALCEPH_VERSION_STRING='3.4.6'

       
!/*----------------------------------------------------------------------------------------------*/
!/* definition of some constants */
!/*----------------------------------------------------------------------------------------------*/
!/*! define the maximum number of characters (including the trailing '\0') 
! that the name of a constant could contain. */
        INTEGER, parameter :: CALCEPH_MAX_CONSTANTNAME=33

!/*! define the maximum number of characters (includeing the trailing '\0')
! that the value of a constant could contain. */
        INTEGER, parameter :: CALCEPH_MAX_CONSTANTVALUE=1024

!/*! define the offset value for asteroid for calceph_?compute */
        INTEGER, parameter :: CALCEPH_ASTEROID=2000000

!/* unit for the output */
!/*! outputs are in Astronomical Unit */
        INTEGER, parameter :: CALCEPH_UNIT_AU=1
!/*! outputs are in kilometers */
        INTEGER, parameter :: CALCEPH_UNIT_KM=2
!/*! outputs are in day */
        INTEGER, parameter :: CALCEPH_UNIT_DAY=4
!/*! outputs are in seconds */
        INTEGER, parameter :: CALCEPH_UNIT_SEC=8
!/*! outputs are in radians */
        INTEGER, parameter :: CALCEPH_UNIT_RAD=16

!/*! use the NAIF body identification numbers for target and center integers */
        INTEGER, parameter :: CALCEPH_USE_NAIFID=32

!/* kind of output */
!/*! outputs are the euler angles */
        INTEGER, parameter :: CALCEPH_OUTPUT_EULERANGLES=64
!/*! outputs are the nutation angles */
        INTEGER, parameter :: CALCEPH_OUTPUT_NUTATIONANGLES=128


!/*! NAIF identification numbers for the Sun and planetary barycenters (table 2 of reference 1) */
        INTEGER, parameter :: NAIFID_SOLAR_SYSTEM_BARYCENTER= 0        
        INTEGER, parameter :: NAIFID_MERCURY_BARYCENTER     = 1  
        INTEGER, parameter :: NAIFID_VENUS_BARYCENTER       = 2  
        INTEGER, parameter :: NAIFID_EARTH_MOON_BARYCENTER  = 3  
        INTEGER, parameter :: NAIFID_MARS_BARYCENTER        = 4  
        INTEGER, parameter :: NAIFID_JUPITER_BARYCENTER     = 5  
        INTEGER, parameter :: NAIFID_SATURN_BARYCENTER      = 6  
        INTEGER, parameter :: NAIFID_URANUS_BARYCENTER      = 7  
        INTEGER, parameter :: NAIFID_NEPTUNE_BARYCENTER     = 8  
        INTEGER, parameter :: NAIFID_PLUTO_BARYCENTER       = 9  
        INTEGER, parameter :: NAIFID_SUN                   = 10 

!/*! NAIF identification numbers for the Coordinate Time ephemerides */
!/*! value to set as the center to get any Coordinate Time */
        INTEGER, parameter :: NAIFID_TIME_CENTER = 1000000000        
!/*! value to set as the target to get the Coordinate Time TT-TDB */
        INTEGER, parameter :: NAIFID_TIME_TTMTDB = 1000000001        
!/*! value to set as the target to get the Coordinate Time TCG-TCB */
        INTEGER, parameter :: NAIFID_TIME_TCGMTCB = 1000000002        

!/*! NAIF identification numbers for the planet centers and satellites (table= 3 of reference= 1)  */
        INTEGER, parameter :: NAIFID_MERCURY       = 199        
        INTEGER, parameter :: NAIFID_VENUS         = 299  
        INTEGER, parameter :: NAIFID_EARTH         = 399  
        INTEGER, parameter :: NAIFID_MOON          = 301
  
        INTEGER, parameter :: NAIFID_MARS          = 499  
        INTEGER, parameter :: NAIFID_PHOBOS        = 401     
        INTEGER, parameter :: NAIFID_DEIMOS        = 402 
    
        INTEGER, parameter :: NAIFID_JUPITER       = 599  
        INTEGER, parameter :: NAIFID_IO            = 501     
        INTEGER, parameter :: NAIFID_EUROPA        = 502     
        INTEGER, parameter :: NAIFID_GANYMEDE      = 503     
        INTEGER, parameter :: NAIFID_CALLISTO      = 504     
        INTEGER, parameter :: NAIFID_AMALTHEA      = 505     
        INTEGER, parameter :: NAIFID_HIMALIA       = 506     
        INTEGER, parameter :: NAIFID_ELARA         = 507     
        INTEGER, parameter :: NAIFID_PASIPHAE      = 508     
        INTEGER, parameter :: NAIFID_SINOPE        = 509     
        INTEGER, parameter :: NAIFID_LYSITHEA      = 510     
        INTEGER, parameter :: NAIFID_CARME         = 511     
        INTEGER, parameter :: NAIFID_ANANKE        = 512     
        INTEGER, parameter :: NAIFID_LEDA          = 513     
        INTEGER, parameter :: NAIFID_THEBE         = 514     
        INTEGER, parameter :: NAIFID_ADRASTEA      = 515     
        INTEGER, parameter :: NAIFID_METIS         = 516     
        INTEGER, parameter :: NAIFID_CALLIRRHOE    = 517     
        INTEGER, parameter :: NAIFID_THEMISTO      = 518     
        INTEGER, parameter :: NAIFID_MAGACLITE     = 519     
        INTEGER, parameter :: NAIFID_TAYGETE       = 520     
        INTEGER, parameter :: NAIFID_CHALDENE      = 521     
        INTEGER, parameter :: NAIFID_HARPALYKE     = 522     
        INTEGER, parameter :: NAIFID_KALYKE        = 523     
        INTEGER, parameter :: NAIFID_IOCASTE       = 524     
        INTEGER, parameter :: NAIFID_ERINOME       = 525     
        INTEGER, parameter :: NAIFID_ISONOE        = 526     
        INTEGER, parameter :: NAIFID_PRAXIDIKE     = 527     
        INTEGER, parameter :: NAIFID_AUTONOE       = 528     
        INTEGER, parameter :: NAIFID_THYONE        = 529     
        INTEGER, parameter :: NAIFID_HERMIPPE      = 530     
        INTEGER, parameter :: NAIFID_AITNE         = 531     
        INTEGER, parameter :: NAIFID_EURYDOME      = 532     
        INTEGER, parameter :: NAIFID_EUANTHE       = 533     
        INTEGER, parameter :: NAIFID_EUPORIE       = 534     
        INTEGER, parameter :: NAIFID_ORTHOSIE      = 535     
        INTEGER, parameter :: NAIFID_SPONDE        = 536     
        INTEGER, parameter :: NAIFID_KALE          = 537     
        INTEGER, parameter :: NAIFID_PASITHEE      = 538     
        INTEGER, parameter :: NAIFID_HEGEMONE      = 539  
        INTEGER, parameter :: NAIFID_MNEME         = 540  
        INTEGER, parameter :: NAIFID_AOEDE         = 541  
        INTEGER, parameter :: NAIFID_THELXINOE     = 542  
        INTEGER, parameter :: NAIFID_ARCHE         = 543  
        INTEGER, parameter :: NAIFID_KALLICHORE    = 544  
        INTEGER, parameter :: NAIFID_HELIKE        = 545  
        INTEGER, parameter :: NAIFID_CARPO         = 546  
        INTEGER, parameter :: NAIFID_EUKELADE      = 547  
        INTEGER, parameter :: NAIFID_CYLLENE       = 548  
        INTEGER, parameter :: NAIFID_KORE          = 549  
        INTEGER, parameter :: NAIFID_HERSE         = 550 
        INTEGER, parameter :: NAIFID_DIA           = 553 
 
        INTEGER, parameter :: NAIFID_SATURN        = 699  
        INTEGER, parameter :: NAIFID_MIMAS         = 601     
        INTEGER, parameter :: NAIFID_ENCELADUS     = 602     
        INTEGER, parameter :: NAIFID_TETHYS        = 603     
        INTEGER, parameter :: NAIFID_DIONE         = 604     
        INTEGER, parameter :: NAIFID_RHEA          = 605     
        INTEGER, parameter :: NAIFID_TITAN         = 606     
        INTEGER, parameter :: NAIFID_HYPERION      = 607     
        INTEGER, parameter :: NAIFID_IAPETUS       = 608     
        INTEGER, parameter :: NAIFID_PHOEBE        = 609     
        INTEGER, parameter :: NAIFID_JANUS         = 610     
        INTEGER, parameter :: NAIFID_EPIMETHEUS    = 611     
        INTEGER, parameter :: NAIFID_HELENE        = 612     
        INTEGER, parameter :: NAIFID_TELESTO       = 613     
        INTEGER, parameter :: NAIFID_CALYPSO       = 614     
        INTEGER, parameter :: NAIFID_ATLAS         = 615     
        INTEGER, parameter :: NAIFID_PROMETHEUS    = 616     
        INTEGER, parameter :: NAIFID_PANDORA       = 617     
        INTEGER, parameter :: NAIFID_PAN           = 618     
        INTEGER, parameter :: NAIFID_YMIR          = 619     
        INTEGER, parameter :: NAIFID_PAALIAQ       = 620     
        INTEGER, parameter :: NAIFID_TARVOS        = 621     
        INTEGER, parameter :: NAIFID_IJIRAQ        = 622     
        INTEGER, parameter :: NAIFID_SUTTUNGR      = 623     
        INTEGER, parameter :: NAIFID_KIVIUQ        = 624     
        INTEGER, parameter :: NAIFID_MUNDILFARI    = 625     
        INTEGER, parameter :: NAIFID_ALBIORIX      = 626     
        INTEGER, parameter :: NAIFID_SKATHI        = 627    
        INTEGER, parameter :: NAIFID_ERRIAPUS      = 628    
        INTEGER, parameter :: NAIFID_SIARNAQ       = 629    
        INTEGER, parameter :: NAIFID_THRYMR        = 630    
        INTEGER, parameter :: NAIFID_NARVI         = 631    
        INTEGER, parameter :: NAIFID_METHONE       = 632    
        INTEGER, parameter :: NAIFID_PALLENE       = 633    
        INTEGER, parameter :: NAIFID_POLYDEUCES    = 634    
        INTEGER, parameter :: NAIFID_DAPHNIS       = 635  
        INTEGER, parameter :: NAIFID_AEGIR         = 636  
        INTEGER, parameter :: NAIFID_BEBHIONN      = 637  
        INTEGER, parameter :: NAIFID_BERGELMIR     = 638  
        INTEGER, parameter :: NAIFID_BESTLA        = 639  
        INTEGER, parameter :: NAIFID_FARBAUTI      = 640  
        INTEGER, parameter :: NAIFID_FENRIR        = 641  
        INTEGER, parameter :: NAIFID_FORNJOT       = 642  
        INTEGER, parameter :: NAIFID_HATI          = 643  
        INTEGER, parameter :: NAIFID_HYROKKIN      = 644  
        INTEGER, parameter :: NAIFID_KARI          = 645  
        INTEGER, parameter :: NAIFID_LOGE          = 646  
        INTEGER, parameter :: NAIFID_SKOLL         = 647  
        INTEGER, parameter :: NAIFID_SURTUR        = 648  
        INTEGER, parameter :: NAIFID_ANTHE         = 649  
        INTEGER, parameter :: NAIFID_JARNSAXA      = 650  
        INTEGER, parameter :: NAIFID_GREIP         = 651  
        INTEGER, parameter :: NAIFID_TARQEQ        = 652  
        INTEGER, parameter :: NAIFID_AEGAEON       = 653  

        INTEGER, parameter :: NAIFID_URANUS        = 799  
        INTEGER, parameter :: NAIFID_ARIEL         = 701     
        INTEGER, parameter :: NAIFID_UMBRIEL       = 702     
        INTEGER, parameter :: NAIFID_TITANIA       = 703     
        INTEGER, parameter :: NAIFID_OBERON        = 704     
        INTEGER, parameter :: NAIFID_MIRANDA       = 705     
        INTEGER, parameter :: NAIFID_CORDELIA      = 706     
        INTEGER, parameter :: NAIFID_OPHELIA       = 707     
        INTEGER, parameter :: NAIFID_BIANCA        = 708     
        INTEGER, parameter :: NAIFID_CRESSIDA      = 709     
        INTEGER, parameter :: NAIFID_DESDEMONA     = 710     
        INTEGER, parameter :: NAIFID_JULIET        = 711     
        INTEGER, parameter :: NAIFID_PORTIA        = 712     
        INTEGER, parameter :: NAIFID_ROSALIND      = 713     
        INTEGER, parameter :: NAIFID_BELINDA       = 714     
        INTEGER, parameter :: NAIFID_PUCK          = 715     
        INTEGER, parameter :: NAIFID_CALIBAN       = 716     
        INTEGER, parameter :: NAIFID_SYCORAX       = 717     
        INTEGER, parameter :: NAIFID_PROSPERO      = 718     
        INTEGER, parameter :: NAIFID_SETEBOS       = 719     
        INTEGER, parameter :: NAIFID_STEPHANO      = 720     
        INTEGER, parameter :: NAIFID_TRINCULO      = 721     
        INTEGER, parameter :: NAIFID_FRANCISCO     = 722  
        INTEGER, parameter :: NAIFID_MARGARET      = 723  
        INTEGER, parameter :: NAIFID_FERDINAND     = 724  
        INTEGER, parameter :: NAIFID_PERDITA       = 725  
        INTEGER, parameter :: NAIFID_MAB           = 726  
        INTEGER, parameter :: NAIFID_CUPID         = 727 
 
        INTEGER, parameter :: NAIFID_NEPTUNE       = 899  
        INTEGER, parameter :: NAIFID_TRITON        = 801     
        INTEGER, parameter :: NAIFID_NEREID        = 802     
        INTEGER, parameter :: NAIFID_NAIAD         = 803     
        INTEGER, parameter :: NAIFID_THALASSA      = 804     
        INTEGER, parameter :: NAIFID_DESPINA       = 805     
        INTEGER, parameter :: NAIFID_GALATEA       = 806     
        INTEGER, parameter :: NAIFID_LARISSA       = 807     
        INTEGER, parameter :: NAIFID_PROTEUS       = 808     
        INTEGER, parameter :: NAIFID_HALIMEDE      = 809  
        INTEGER, parameter :: NAIFID_PSAMATHE      = 810  
        INTEGER, parameter :: NAIFID_SAO           = 811  
        INTEGER, parameter :: NAIFID_LAOMEDEIA     = 812  
        INTEGER, parameter :: NAIFID_NESO          = 813  

        INTEGER, parameter :: NAIFID_PLUTO         = 999  
        INTEGER, parameter :: NAIFID_CHARON        = 901     
        INTEGER, parameter :: NAIFID_NIX           = 902  
        INTEGER, parameter :: NAIFID_HYDRA         = 903  
        INTEGER, parameter :: NAIFID_KERBEROS      = 904  
        INTEGER, parameter :: NAIFID_STYX          = 905  

!/*! NAIF identification numbers for the comets (table= 4 of reference= 1)  */
        INTEGER, parameter :: NAIFID_AREND                  = 1000001
        INTEGER, parameter :: NAIFID_AREND_RIGAUX           = 1000002
        INTEGER, parameter :: NAIFID_ASHBROOK_JACKSON       = 1000003
        INTEGER, parameter :: NAIFID_BOETHIN                = 1000004
        INTEGER, parameter :: NAIFID_BORRELLY               = 1000005
        INTEGER, parameter :: NAIFID_BOWELL_SKIFF           = 1000006
        INTEGER, parameter :: NAIFID_BRADFIELD              = 1000007
        INTEGER, parameter :: NAIFID_BROOKS_2               = 1000008
        INTEGER, parameter :: NAIFID_BRORSEN_METCALF        = 1000009
        INTEGER, parameter :: NAIFID_BUS                    = 1000010
        INTEGER, parameter :: NAIFID_CHERNYKH               = 1000011
        INTEGER, parameter :: NAIFID_CHURYUMOV_GERASIMENKO  = 1000012
        INTEGER, parameter :: NAIFID_CIFFREO                = 1000013
        INTEGER, parameter :: NAIFID_CLARK                  = 1000014
        INTEGER, parameter :: NAIFID_COMAS_SOLA             = 1000015
        INTEGER, parameter :: NAIFID_CROMMELIN              = 1000016
        INTEGER, parameter :: NAIFID_D__ARREST              = 1000017
        INTEGER, parameter :: NAIFID_DANIEL                 = 1000018
        INTEGER, parameter :: NAIFID_DE_VICO_SWIFT          = 1000019
        INTEGER, parameter :: NAIFID_DENNING_FUJIKAWA       = 1000020
        INTEGER, parameter :: NAIFID_DU_TOIT_1              = 1000021
        INTEGER, parameter :: NAIFID_DU_TOIT_HARTLEY        = 1000022
        INTEGER, parameter :: NAIFID_DUTOIT_NEUJMIN_DELPORTE= 1000023
        INTEGER, parameter :: NAIFID_DUBIAGO                = 1000024
        INTEGER, parameter :: NAIFID_ENCKE                  = 1000025
        INTEGER, parameter :: NAIFID_FAYE                   = 1000026
        INTEGER, parameter :: NAIFID_FINLAY                 = 1000027
        INTEGER, parameter :: NAIFID_FORBES                 = 1000028
        INTEGER, parameter :: NAIFID_GEHRELS_1              = 1000029
        INTEGER, parameter :: NAIFID_GEHRELS_2              = 1000030
        INTEGER, parameter :: NAIFID_GEHRELS_3              = 1000031
        INTEGER, parameter :: NAIFID_GIACOBINI_ZINNER       = 1000032
        INTEGER, parameter :: NAIFID_GICLAS                 = 1000033
        INTEGER, parameter :: NAIFID_GRIGG_SKJELLERUP       = 1000034
        INTEGER, parameter :: NAIFID_GUNN                   = 1000035
        INTEGER, parameter :: NAIFID_HALLEY                 = 1000036
        INTEGER, parameter :: NAIFID_HANEDA_CAMPOS          = 1000037
        INTEGER, parameter :: NAIFID_HARRINGTON             = 1000038
        INTEGER, parameter :: NAIFID_HARRINGTON_ABELL       = 1000039
        INTEGER, parameter :: NAIFID_HARTLEY_1              = 1000040
        INTEGER, parameter :: NAIFID_HARTLEY_2              = 1000041
        INTEGER, parameter :: NAIFID_HARTLEY_IRAS           = 1000042
        INTEGER, parameter :: NAIFID_HERSCHEL_RIGOLLET      = 1000043
        INTEGER, parameter :: NAIFID_HOLMES                 = 1000044
        INTEGER, parameter :: NAIFID_HONDA_MRKOS_PAJDUSAKOVA= 1000045
        INTEGER, parameter :: NAIFID_HOWELL                 = 1000046
        INTEGER, parameter :: NAIFID_IRAS                   = 1000047
        INTEGER, parameter :: NAIFID_JACKSON_NEUJMIN        = 1000048
        INTEGER, parameter :: NAIFID_JOHNSON                = 1000049
        INTEGER, parameter :: NAIFID_KEARNS_KWEE            = 1000050
        INTEGER, parameter :: NAIFID_KLEMOLA                = 1000051
        INTEGER, parameter :: NAIFID_KOHOUTEK               = 1000052
        INTEGER, parameter :: NAIFID_KOJIMA                 = 1000053
        INTEGER, parameter :: NAIFID_KOPFF                  = 1000054
        INTEGER, parameter :: NAIFID_KOWAL_1                = 1000055
        INTEGER, parameter :: NAIFID_KOWAL_2                = 1000056
        INTEGER, parameter :: NAIFID_KOWAL_MRKOS            = 1000057
        INTEGER, parameter :: NAIFID_KOWAL_VAVROVA          = 1000058
        INTEGER, parameter :: NAIFID_LONGMORE               = 1000059
        INTEGER, parameter :: NAIFID_LOVAS_1                = 1000060
        INTEGER, parameter :: NAIFID_MACHHOLZ               = 1000061
        INTEGER, parameter :: NAIFID_MAURY                  = 1000062
        INTEGER, parameter :: NAIFID_NEUJMIN_1              = 1000063
        INTEGER, parameter :: NAIFID_NEUJMIN_2              = 1000064
        INTEGER, parameter :: NAIFID_NEUJMIN_3              = 1000065
        INTEGER, parameter :: NAIFID_OLBERS                 = 1000066
        INTEGER, parameter :: NAIFID_PETERS_HARTLEY         = 1000067
        INTEGER, parameter :: NAIFID_PONS_BROOKS            = 1000068
        INTEGER, parameter :: NAIFID_PONS_WINNECKE          = 1000069
        INTEGER, parameter :: NAIFID_REINMUTH_1             = 1000070
        INTEGER, parameter :: NAIFID_REINMUTH_2             = 1000071
        INTEGER, parameter :: NAIFID_RUSSELL_1              = 1000072
        INTEGER, parameter :: NAIFID_RUSSELL_2              = 1000073
        INTEGER, parameter :: NAIFID_RUSSELL_3              = 1000074
        INTEGER, parameter :: NAIFID_RUSSELL_4              = 1000075
        INTEGER, parameter :: NAIFID_SANGUIN                = 1000076
        INTEGER, parameter :: NAIFID_SCHAUMASSE             = 1000077
        INTEGER, parameter :: NAIFID_SCHUSTER               = 1000078
        INTEGER, parameter :: NAIFID_SCHWASSMANN_WACHMANN_1 = 1000079
        INTEGER, parameter :: NAIFID_SCHWASSMANN_WACHMANN_2 = 1000080
        INTEGER, parameter :: NAIFID_SCHWASSMANN_WACHMANN_3 = 1000081
        INTEGER, parameter :: NAIFID_SHAJN_SCHALDACH        = 1000082
        INTEGER, parameter :: NAIFID_SHOEMAKER_1            = 1000083
        INTEGER, parameter :: NAIFID_SHOEMAKER_2            = 1000084
        INTEGER, parameter :: NAIFID_SHOEMAKER_3            = 1000085
        INTEGER, parameter :: NAIFID_SINGER_BREWSTER        = 1000086
        INTEGER, parameter :: NAIFID_SLAUGHTER_BURNHAM      = 1000087
        INTEGER, parameter :: NAIFID_SMIRNOVA_CHERNYKH      = 1000088
        INTEGER, parameter :: NAIFID_STEPHAN_OTERMA         = 1000089
        INTEGER, parameter :: NAIFID_SWIFT_GEHRELS          = 1000090
        INTEGER, parameter :: NAIFID_TAKAMIZAWA             = 1000091
        INTEGER, parameter :: NAIFID_TAYLOR                 = 1000092
        INTEGER, parameter :: NAIFID_TEMPEL_1               = 1000093
        INTEGER, parameter :: NAIFID_TEMPEL_2               = 1000094
        INTEGER, parameter :: NAIFID_TEMPEL_TUTTLE          = 1000095
        INTEGER, parameter :: NAIFID_TRITTON                = 1000096
        INTEGER, parameter :: NAIFID_TSUCHINSHAN_1          = 1000097
        INTEGER, parameter :: NAIFID_TSUCHINSHAN_2          = 1000098
        INTEGER, parameter :: NAIFID_TUTTLE                 = 1000099
        INTEGER, parameter :: NAIFID_TUTTLE_GIACOBINI_KRESAK= 1000100
        INTEGER, parameter :: NAIFID_VAISALA_1              = 1000101
        INTEGER, parameter :: NAIFID_VAN_BIESBROECK         = 1000102
        INTEGER, parameter :: NAIFID_VAN_HOUTEN             = 1000103
        INTEGER, parameter :: NAIFID_WEST_KOHOUTEK_IKEMURA  = 1000104
        INTEGER, parameter :: NAIFID_WHIPPLE                = 1000105
        INTEGER, parameter :: NAIFID_WILD_1                 = 1000106
        INTEGER, parameter :: NAIFID_WILD_2                 = 1000107
        INTEGER, parameter :: NAIFID_WILD_3                 = 1000108
        INTEGER, parameter :: NAIFID_WIRTANEN               = 1000109
        INTEGER, parameter :: NAIFID_WOLF                   = 1000110
        INTEGER, parameter :: NAIFID_WOLF_HARRINGTON        = 1000111
        INTEGER, parameter :: NAIFID_LOVAS_2                = 1000112
        INTEGER, parameter :: NAIFID_URATA_NIIJIMA          = 1000113
        INTEGER, parameter :: NAIFID_WISEMAN_SKIFF          = 1000114
        INTEGER, parameter :: NAIFID_HELIN                  = 1000115
        INTEGER, parameter :: NAIFID_MUELLER                = 1000116
        INTEGER, parameter :: NAIFID_SHOEMAKER_HOLT_1       = 1000117
        INTEGER, parameter :: NAIFID_HELIN_ROMAN_CROCKETT   = 1000118
        INTEGER, parameter :: NAIFID_HARTLEY_3              = 1000119
        INTEGER, parameter :: NAIFID_PARKER_HARTLEY         = 1000120
        INTEGER, parameter :: NAIFID_HELIN_ROMAN_ALU_1      = 1000121
        INTEGER, parameter :: NAIFID_WILD_4                 = 1000122
        INTEGER, parameter :: NAIFID_MUELLER_2              = 1000123
        INTEGER, parameter :: NAIFID_MUELLER_3              = 1000124
        INTEGER, parameter :: NAIFID_SHOEMAKER_LEVY_1       = 1000125
        INTEGER, parameter :: NAIFID_SHOEMAKER_LEVY_2       = 1000126
        INTEGER, parameter :: NAIFID_HOLT_OLMSTEAD          = 1000127
        INTEGER, parameter :: NAIFID_METCALF_BREWINGTON     = 1000128
        INTEGER, parameter :: NAIFID_LEVY                   = 1000129
        INTEGER, parameter :: NAIFID_SHOEMAKER_LEVY_9       = 1000130
        INTEGER, parameter :: NAIFID_HYAKUTAKE              = 1000131
        INTEGER, parameter :: NAIFID_HALE_BOPP              = 1000132
        INTEGER, parameter :: NAIFID_SIDING_SPRING          = 1003228

        INTERFACE
 
!/*-----------------------------------------------------------------*/
!/* error handler */
!/*-----------------------------------------------------------------*/
        ! set the error handler 
        SUBROUTINE calceph_seterrorhandler(typeh,userfunch) BIND(C)
          USE, INTRINSIC :: ISO_C_BINDING
          IMPLICIT NONE
          integer(C_INT), VALUE, intent(in) :: typeh
          type(c_funptr), VALUE, intent(in) :: userfunch
        END SUBROUTINE calceph_seterrorhandler

!/*-----------------------------------------------------------------*/
!/* single access API per thread/process */
!/*-----------------------------------------------------------------*/
        ! open an ephemeris data file 
        FUNCTION calceph_sopen(filename) BIND(C)
          USE, INTRINSIC :: ISO_C_BINDING
          IMPLICIT NONE
          character(len=1,kind=C_CHAR), intent(in) :: filename
          integer(C_INT) :: calceph_sopen
        END FUNCTION calceph_sopen


        ! compute the position <x,y,z> and velocity <xdot,ydot,zdot>
        !    for a given target and center 
       FUNCTION calceph_scompute(JD0,time,target1,center,PV) BIND(C)
          USE, INTRINSIC :: ISO_C_BINDING
          IMPLICIT NONE
          INTEGER(C_INT), VALUE, intent(in) :: target1, center
          REAL(C_DOUBLE), VALUE, intent(in) :: JD0, time
          REAL(C_DOUBLE), intent(out) :: PV(6)
          INTEGER(C_INT) :: calceph_scompute
       END FUNCTION calceph_scompute
   
        ! get constant value from the specified name
        FUNCTION calceph_sgetconstant(name, value) BIND(C)
          USE, INTRINSIC :: ISO_C_BINDING
          IMPLICIT NONE
          character(len=1,kind=C_CHAR), intent(in) :: name
          REAL(C_DOUBLE), intent(out) :: value
          integer(C_INT) :: calceph_sgetconstant
        END FUNCTION calceph_sgetconstant

        ! get the number of constants available in the ephemeris file
        FUNCTION calceph_sgetconstantcount() BIND(C)
          USE, INTRINSIC :: ISO_C_BINDING
          IMPLICIT NONE
          integer(C_INT) :: calceph_sgetconstantcount
        END FUNCTION calceph_sgetconstantcount

        ! get the name and its value of the constant available at some index in the ephemeris file
        FUNCTION calceph_sgetconstantindex(index, name, value)          &
     &   BIND(C, NAME='f2003calceph_sgetconstantindex')
          USE, INTRINSIC :: ISO_C_BINDING
          IMPLICIT NONE
          integer(C_INT), VALUE, intent(in) :: index
          character(len=1,kind=C_CHAR),dimension(33),intent(out)::name
          REAL(C_DOUBLE), intent(out) :: value
          integer(C_INT) :: calceph_sgetconstantindex
        END FUNCTION calceph_sgetconstantindex

        ! get the time scale of the ephemeris file
        FUNCTION calceph_sgettimescale() BIND(C)
          USE, INTRINSIC :: ISO_C_BINDING
          IMPLICIT NONE
          INTEGER(C_INT) :: calceph_sgettimescale
        END FUNCTION calceph_sgettimescale

        ! get the time span of the ephemeris file
        FUNCTION calceph_sgettimespan(firsttime, lasttime,              &
     &     continuous) BIND(C)
          USE, INTRINSIC :: ISO_C_BINDING
          IMPLICIT NONE
          INTEGER(C_INT) :: calceph_sgettimespan
          REAL(C_DOUBLE), intent(out) :: firsttime
          REAL(C_DOUBLE), intent(out) :: lasttime
          INTEGER(C_INT), intent(out) :: continuous
        END FUNCTION calceph_sgettimespan

        ! get the file version of the ephemeris file
        FUNCTION calceph_sgetfileversion(vers)                          &
     &   BIND(C, NAME='f2003calceph_sgetfileversion')
          USE, INTRINSIC :: ISO_C_BINDING
          IMPLICIT NONE
        character(len=1,kind=C_CHAR),dimension(1024),intent(out)::vers
          integer(C_INT) :: calceph_sgetfileversion
        END FUNCTION calceph_sgetfileversion

        ! close an ephemeris data file 
       SUBROUTINE calceph_sclose() BIND(C)
          USE, INTRINSIC :: ISO_C_BINDING
          IMPLICIT NONE
       END SUBROUTINE calceph_sclose

!/*-----------------------------------------------------------------*/
!/* multiple access API per thread/process */
!/*-----------------------------------------------------------------*/

        ! open an ephemeris data file
        FUNCTION calceph_open(filename) BIND(C)
          USE, INTRINSIC :: ISO_C_BINDING
          IMPLICIT NONE
          CHARACTER(len=1,kind=C_CHAR), intent(in) :: filename
          TYPE(C_PTR) :: calceph_open
        END FUNCTION calceph_open

        ! open several ephemeris data files
        FUNCTION calceph_open_array(n, array_filename, lenfilename)      &
     &             BIND(C,  name="f2003calceph_open_array")
          USE, INTRINSIC :: ISO_C_BINDING
          IMPLICIT NONE
          INTEGER(C_INT), VALUE, intent(in) :: n
          CHARACTER(len=1,kind=C_CHAR),dimension(*), intent(in) ::       &
     &             array_filename
          INTEGER(C_INT), VALUE, intent(in) :: lenfilename
          TYPE(C_PTR) :: calceph_open_array
        END FUNCTION calceph_open_array

       ! prefetch to memory the ephemeris data files
       FUNCTION calceph_prefetch(eph) BIND(C)
          USE, INTRINSIC :: ISO_C_BINDING
          IMPLICIT NONE
          TYPE(C_PTR), VALUE, intent(in) :: eph
          INTEGER(C_INT) :: calceph_prefetch
       END FUNCTION calceph_prefetch

       ! return non-zero value if the ephemeris data files could be accessed by multiple threads
       FUNCTION calceph_isthreadsafe(eph) BIND(C)
          USE, INTRINSIC :: ISO_C_BINDING
          IMPLICIT NONE
          TYPE(C_PTR), VALUE, intent(in) :: eph
          INTEGER(C_INT) :: calceph_isthreadsafe
       END FUNCTION calceph_isthreadsafe

       ! compute the position <x,y,z> and velocity <xdot,ydot,zdot>
       !    for a given target and center (outputs are expressed in UA and UA/day)
       !    at a single time
       FUNCTION calceph_compute(eph,JD0,time,target1,                    &
     &                             center,PV) BIND(C)
          USE, INTRINSIC :: ISO_C_BINDING
          IMPLICIT NONE
          INTEGER(C_INT), VALUE, intent(in) :: target1, center
          REAL(C_DOUBLE), VALUE, intent(in) :: JD0, time
          REAL(C_DOUBLE), intent(out) :: PV(6)
          TYPE(C_PTR), VALUE, intent(in) :: eph
          INTEGER(C_INT) :: calceph_compute
       END FUNCTION calceph_compute

       ! compute the position <x,y,z> and velocity <xdot,ydot,zdot>
       !    for a given target and center (outputs are expressed in unit)
       !    at a single time
       FUNCTION calceph_compute_unit(eph,JD0,time,target1,               &
     &                             center,unit, PV) BIND(C)
          USE, INTRINSIC :: ISO_C_BINDING
          IMPLICIT NONE
          INTEGER(C_INT), VALUE, intent(in) :: target1, center
          INTEGER(C_INT), VALUE, intent(in) :: unit
          REAL(C_DOUBLE), VALUE, intent(in) :: JD0, time
          REAL(C_DOUBLE), intent(out) :: PV(6)
          TYPE(C_PTR), VALUE, intent(in) :: eph
          INTEGER(C_INT) :: calceph_compute_unit
       END FUNCTION calceph_compute_unit

       ! compute the orientation <euler angles> and their derivatives
       !    for a given target(outputs are expressed in unit)  
       !    at a single time
       FUNCTION calceph_orient_unit(eph,JD0,time,target1,                &
     &                              unit, PV) BIND(C)
          USE, INTRINSIC :: ISO_C_BINDING
          IMPLICIT NONE
          INTEGER(C_INT), VALUE, intent(in) :: target1
          INTEGER(C_INT), VALUE, intent(in) :: unit
          REAL(C_DOUBLE), VALUE, intent(in) :: JD0, time
          REAL(C_DOUBLE), intent(out) :: PV(6)
          TYPE(C_PTR), VALUE, intent(in) :: eph
          INTEGER(C_INT) :: calceph_orient_unit
       END FUNCTION calceph_orient_unit

       ! compute the rotational angular momentum (G/(mR^2)) and their derivatives
       !    for a given target(outputs are expressed in unit)  
       !    at a single time
       FUNCTION calceph_rotangmom_unit(eph,JD0,time,target1,                &
     &                              unit, PV) BIND(C)
          USE, INTRINSIC :: ISO_C_BINDING
          IMPLICIT NONE
          INTEGER(C_INT), VALUE, intent(in) :: target1
          INTEGER(C_INT), VALUE, intent(in) :: unit
          REAL(C_DOUBLE), VALUE, intent(in) :: JD0, time
          REAL(C_DOUBLE), intent(out) :: PV(6)
          TYPE(C_PTR), VALUE, intent(in) :: eph
          INTEGER(C_INT) :: calceph_rotangmom_unit
       END FUNCTION calceph_rotangmom_unit

       ! compute the position <x,y,z> 
       !    and their first, second and third derivatives 
       !    (velocity, acceleration, jerk)
       !    for a given target and center (outputs are expressed in unit)
       !    at a single time
       FUNCTION calceph_compute_order(eph,JD0,time,target1,               &
     &                             center,unit, order, PVAJ) BIND(C)
          USE, INTRINSIC :: ISO_C_BINDING
          IMPLICIT NONE
          INTEGER(C_INT), VALUE, intent(in) :: target1, center
          INTEGER(C_INT), VALUE, intent(in) :: unit
          INTEGER(C_INT), VALUE, intent(in) :: order
          REAL(C_DOUBLE), VALUE, intent(in) :: JD0, time
          REAL(C_DOUBLE), intent(out) :: PVAJ(12)
          TYPE(C_PTR), VALUE, intent(in) :: eph
          INTEGER(C_INT) :: calceph_compute_order
       END FUNCTION calceph_compute_order

       ! compute the orientation <euler angles>
       !    and their first, second and third derivatives 
       !    for a given target(outputs are expressed in unit)  
       !    at a single time
       FUNCTION calceph_orient_order(eph,JD0,time,target1,                &
     &                              unit, order, PVAJ) BIND(C)
          USE, INTRINSIC :: ISO_C_BINDING
          IMPLICIT NONE
          INTEGER(C_INT), VALUE, intent(in) :: target1
          INTEGER(C_INT), VALUE, intent(in) :: unit
          INTEGER(C_INT), VALUE, intent(in) :: order
          REAL(C_DOUBLE), VALUE, intent(in) :: JD0, time
          REAL(C_DOUBLE), intent(out) :: PVAJ(12)
          TYPE(C_PTR), VALUE, intent(in) :: eph
          INTEGER(C_INT) :: calceph_orient_order
       END FUNCTION calceph_orient_order

       ! compute the rotational angular momentum (G/(mR^2)) 
       !    and their first, second and third derivatives 
       !    for a given target(outputs are expressed in unit)  
       !    at a single time
       FUNCTION calceph_rotangmom_order(eph,JD0,time,target1,                &
     &                              unit, order, PVAJ) BIND(C)
          USE, INTRINSIC :: ISO_C_BINDING
          IMPLICIT NONE
          INTEGER(C_INT), VALUE, intent(in) :: target1
          INTEGER(C_INT), VALUE, intent(in) :: unit
          INTEGER(C_INT), VALUE, intent(in) :: order
          REAL(C_DOUBLE), VALUE, intent(in) :: JD0, time
          REAL(C_DOUBLE), intent(out) :: PVAJ(12)
          TYPE(C_PTR), VALUE, intent(in) :: eph
          INTEGER(C_INT) :: calceph_rotangmom_order
       END FUNCTION calceph_rotangmom_order

        ! get the first value of the constant from the specified name
        FUNCTION calceph_getconstant(eph, name, value) BIND(C)
          USE, INTRINSIC :: ISO_C_BINDING
          IMPLICIT NONE
          CHARACTER(len=1,kind=C_CHAR), intent(in) :: name
          REAL(C_DOUBLE), intent(out) :: value
          INTEGER(C_INT) :: calceph_getconstant
          TYPE(C_PTR), VALUE, intent(in) :: eph
        END FUNCTION calceph_getconstant

        ! get the first value of the constant from the specified name
        FUNCTION calceph_getconstantsd(eph, name, value) BIND(C)
          USE, INTRINSIC :: ISO_C_BINDING
          IMPLICIT NONE
          CHARACTER(len=1,kind=C_CHAR), intent(in) :: name
          REAL(C_DOUBLE), intent(out) :: value
          INTEGER(C_INT) :: calceph_getconstantsd
          TYPE(C_PTR), VALUE, intent(in) :: eph
        END FUNCTION calceph_getconstantsd

        ! get the nvalue first values of the constant from the specified name
        FUNCTION calceph_getconstantvd(eph, name, arrayvalue, nvalue)     &
     &    BIND(C)
          USE, INTRINSIC :: ISO_C_BINDING
          IMPLICIT NONE
          CHARACTER(len=1,kind=C_CHAR), intent(in) :: name
          REAL(C_DOUBLE),dimension(1:nvalue),intent(inout)::arrayvalue
          INTEGER(C_INT), VALUE, intent(in) :: nvalue
          INTEGER(C_INT) :: calceph_getconstantvd
          TYPE(C_PTR), VALUE, intent(in) :: eph
        END FUNCTION calceph_getconstantvd

        ! get the first value of the constant from the specified name
        FUNCTION calceph_getconstantss(eph, name, value) BIND(C)
          USE, INTRINSIC :: ISO_C_BINDING
          IMPLICIT NONE
          CHARACTER(len=1,kind=C_CHAR), intent(in) :: name
          CHARACTER(len=1,kind=C_CHAR), intent(inout) :: value
          INTEGER(C_INT) :: calceph_getconstantss
          TYPE(C_PTR), VALUE, intent(in) :: eph
        END FUNCTION calceph_getconstantss

        ! get the nvalue first values of the constant from the specified name
        FUNCTION calceph_getconstantvs(eph, name, arrayvalue, nvalue)     &
     &    BIND(C)
          USE, INTRINSIC :: ISO_C_BINDING
          IMPLICIT NONE
          CHARACTER(len=1,kind=C_CHAR), intent(in) :: name
          CHARACTER(len=1,kind=C_CHAR),                                    &
     &    dimension(1:nvalue),intent(inout)::arrayvalue
          INTEGER(C_INT), VALUE, intent(in) :: nvalue
          INTEGER(C_INT) :: calceph_getconstantvs
          TYPE(C_PTR), VALUE, intent(in) :: eph
        END FUNCTION calceph_getconstantvs

        ! get the number of constants available in the ephemeris file
        FUNCTION calceph_getconstantcount(eph) BIND(C)
          USE, INTRINSIC :: ISO_C_BINDING
          IMPLICIT NONE
          TYPE(C_PTR), VALUE, intent(in) :: eph
          INTEGER(C_INT) :: calceph_getconstantcount
        END FUNCTION calceph_getconstantcount

        ! get the name and its value of the constant available at some index in the ephemeris file
        FUNCTION calceph_getconstantindex(eph, index, name, value)        &
     &          BIND(C, NAME='f2003calceph_getconstantindex')
          USE, INTRINSIC :: ISO_C_BINDING
          IMPLICIT NONE
          TYPE(C_PTR), VALUE, intent(in) :: eph
          INTEGER(C_INT),VALUE, intent(in) :: index
          CHARACTER(len=1,kind=C_CHAR), dimension(33),intent(out)::name
          REAL(C_DOUBLE), intent(out) :: value
          INTEGER(C_INT) :: calceph_getconstantindex
        END FUNCTION calceph_getconstantindex

        ! get the version of the CALCEPH library as a string
        SUBROUTINE calceph_getversion_str(version)                         &
     &   BIND(C, NAME='f2003calceph_getversion_str')
          USE, INTRINSIC :: ISO_C_BINDING
          IMPLICIT NONE
         character(len=1,kind=C_CHAR),dimension(33),intent(out)::version
        END SUBROUTINE calceph_getversion_str

        ! get the time scale of the ephemeris file
        FUNCTION calceph_gettimescale(eph) BIND(C)
          USE, INTRINSIC :: ISO_C_BINDING
          IMPLICIT NONE
          TYPE(C_PTR), VALUE, intent(in) :: eph
          INTEGER(C_INT) :: calceph_gettimescale
        END FUNCTION calceph_gettimescale

        ! get the time span of the ephemeris file
        FUNCTION calceph_gettimespan(eph, firsttime, lasttime,            &
     &     continuous) BIND(C)
          USE, INTRINSIC :: ISO_C_BINDING
          IMPLICIT NONE
          TYPE(C_PTR), VALUE, intent(in) :: eph
          INTEGER(C_INT) :: calceph_gettimespan
          REAL(C_DOUBLE), intent(out) :: firsttime
          REAL(C_DOUBLE), intent(out) :: lasttime
          INTEGER(C_INT), intent(out) :: continuous
        END FUNCTION calceph_gettimespan

        ! return the number of position’s records available in the ephemeris file 
        FUNCTION calceph_getpositionrecordcount(eph) BIND(C)
          USE, INTRINSIC :: ISO_C_BINDING
          IMPLICIT NONE
          TYPE(C_PTR), VALUE, intent(in) :: eph
          INTEGER(C_INT) :: calceph_getpositionrecordcount
        END FUNCTION calceph_getpositionrecordcount

        ! return the target and origin bodies, the first and last time, and the reference frame in the ephemeris file
        FUNCTION calceph_getpositionrecordindex(eph, index, target,        &
     &     center, firsttime, lasttime, frame) BIND(C)
          USE, INTRINSIC :: ISO_C_BINDING
          IMPLICIT NONE
          TYPE(C_PTR), VALUE, intent(in) :: eph
          INTEGER(C_INT),VALUE, intent(in) :: index
          REAL(C_DOUBLE), intent(out) :: firsttime
          REAL(C_DOUBLE), intent(out) :: lasttime
          INTEGER(C_INT), intent(out) :: target
          INTEGER(C_INT), intent(out) :: center
          INTEGER(C_INT), intent(out) :: frame
          INTEGER(C_INT) :: calceph_getpositionrecordindex
        END FUNCTION calceph_getpositionrecordindex

        ! return the number of orientation’s records available in the ephemeris file 
        FUNCTION calceph_getorientrecordcount(eph) BIND(C)
          USE, INTRINSIC :: ISO_C_BINDING
          IMPLICIT NONE
          TYPE(C_PTR), VALUE, intent(in) :: eph
          INTEGER(C_INT) :: calceph_getorientrecordcount
        END FUNCTION calceph_getorientrecordcount

        ! return the target bodies, the first and last time, and the reference frame in the ephemeris file
        FUNCTION calceph_getorientrecordindex(eph, index, target,        &
     &     firsttime, lasttime, frame) BIND(C)
          USE, INTRINSIC :: ISO_C_BINDING
          IMPLICIT NONE
          TYPE(C_PTR), VALUE, intent(in) :: eph
          INTEGER(C_INT),VALUE, intent(in) :: index
          REAL(C_DOUBLE), intent(out) :: firsttime
          REAL(C_DOUBLE), intent(out) :: lasttime
          INTEGER(C_INT), intent(out) :: target
          INTEGER(C_INT), intent(out) :: frame
          INTEGER(C_INT) :: calceph_getorientrecordindex
        END FUNCTION calceph_getorientrecordindex

        ! get the file version of the ephemeris file
        FUNCTION calceph_getfileversion(eph, vers)                       &
     &   BIND(C, NAME='f2003calceph_getfileversion')
          USE, INTRINSIC :: ISO_C_BINDING
          IMPLICIT NONE
          TYPE(C_PTR), VALUE, intent(in) :: eph
        character(len=1,kind=C_CHAR),dimension(1024),intent(out)::vers
          integer(C_INT) :: calceph_getfileversion
        END FUNCTION calceph_getfileversion

        ! close an ephemeris data file 
       SUBROUTINE calceph_close(eph) BIND(C)
          USE, INTRINSIC :: ISO_C_BINDING
          IMPLICIT NONE
          TYPE(C_PTR), VALUE, intent(in) :: eph
       END SUBROUTINE calceph_close


        END INTERFACE
        
        
        END MODULE calceph
