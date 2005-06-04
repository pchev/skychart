*     ***************************************************************

*     Natural Satellites Ephemerides

*     diffpos.f:
*     Example of a Main Program using the xyfm routine for the 
*     computation of differential tangential 
*     coordinates of natural satellites


*     Anonymous Server: ftp.bdl.fr

*     ***************************************************************

*     (c) copyright Bureau des longitudes 1995
*
*     J.-E. Arlot, Ch. Ruatti, D.T. Vu, W. Thuillot
*     Bureau des longitudes
*     77 av. Denfert Rochereau  F-75014 PARIS

*     ***************************************************************


      implicit double precision (a-h,o-z)
      character*20 infile
      character*7 nompla(4)
*****      character*2 ext(3)
      character*1 irep

      dimension xx(8),yy(8)
      data nompla /'marsbin','jupibin','satubin','uranbin'/

1000  continue

*     write(*,*) 
*    .'jour mois an h m s (TT) : (ex.: 2 10 1995 3 45 49.15) ? :'

      write(*,*) 
     .'day month year h m s (TT) : (ex.: 2 10 1995 3 45 49.15) ? :' 

      read(*,*) ij,im,ian,jh,jm,s

      call datejj(ij,im,ian,jh,jm,s,djc)

      write(*,'(5x,a,f15.6)') 'Julian date: ',djc

*     write(*,*) 'Nombre de pas et valeur de ce pas (jours)'
      write(*,*) 'Number of steps and value of this step (in days):'
      read(*,*)  npas,xlon

      write(*,*)
      write(*,*) 'Mars    : 4'
      write(*,*) 'Jupiter : 5'
      write(*,*) 'Saturn  : 6'
      write(*,*) 'Uranus  : 7'
      write(*,*)
*     write(*,*) 'Numero de la planete: '
      write(*,*) 'Number of the planet concerned ?'
      read(*,*)   ipla

      jj1= int((ian-1900)/10)
      xj2= ((ian-1900)/10. - jj1)*10.
      jj1= mod(jj1,10)
      jj2= nint(xj2)
    
      infile = nompla(ipla-3)//'.'//char(jj1+48)//char(jj2+48)
      write(*,*) 'Name of the file: ',infile

*     Open the file infile with number of unit=num

      num=10
      open (num,file=infile,access='direct',recl=184,
     .      iostat=ios3,status='old')
      if (ios3.ne.0) then
        write(*,*) ' beware: ',infile,' does not exist...'
*       write(*,*) ' attention le fichier ',infile,' n''existe pas'
        go to 1000
      endif


*     =============================================================

      do i=1,npas

          call xyfm(num,djc,ipla,xx,yy)

         
          if (ipla.eq.4) then
             if (mod(i,60).eq.1) write(*,444) 
             write(*,400) ij,im,ian,jh,jm,s,(xx(k),k=1,2)
             write(*,401) ij,im,ian,jh,jm,s,(yy(k),k=1,2)
444          format(/1x,45('-')/
     .       1x,' dd mm yyyy hh mm ss.s',6x,
     .       'Phobos   Deimos'//1x,45('-'))
400          format(1x,2i3,i5,2i3,f4.1,' x: ',2f9.3)
401          format(1x,2i3,i5,2i3,f4.1,' y: ',2f9.3)
             write(*,*) 
          endif

          if (ipla.eq.5) then
             if (mod(i,60).eq.1)  write(*,555)
555          format(/1x,65('-')/
     .       1x,' dd mm yyyy hh mm ss.s',10x,
     .       'Io   Europa Ganymede Callisto'//1x,65('-'))
             write(*,500) ij,im,ian,jh,jm,s,(xx(k),k=1,4)
             write(*,501) ij,im,ian,jh,jm,s,(yy(k),k=1,4)
500          format(1x,2i3,i5,2i3,f4.1,' x: ',4f9.3)
501          format(1x,2i3,i5,2i3,f4.1,' y: ',4f9.3)
             write(*,*) 
          endif

          if (ipla.eq.6) then
             if (mod(i,60).eq.1)  write(*,666)
666          format(/1x,100('-')/
     .       1x,' dd mm yyyy hh mm ss.s',7x,
     .       'Mimas Encelade   Tethys    Dione     Rhea',
     .       '    Titan Hyperion  Iapetus'//1x,100('-'))
             write(*,600) ij,im,ian,jh,jm,s,(xx(k),k=1,8)
             write(*,601) ij,im,ian,jh,jm,s,(yy(k),k=1,8)
600          format(1x,2i3,i5,2i3,f4.1,' x: ',8f9.3)
601          format(1x,2i3,i5,2i3,f4.1,' y: ',8f9.3)
             write(*,*)
          endif

          if (ipla.eq.7) then
             if (mod(i,60).eq.1)  write(*,777)
777          format(/1x,75('-')/
     .       1x,' dd mm yyyy hh mm ss.s',5x,
     .       'Miranda    Ariel  Umbriel  Titania   Oberon'//1x,75('-'))
             write(*,700) ij,im,ian,jh,jm,s,(xx(k),k=1,5)
             write(*,701) ij,im,ian,jh,jm,s,(yy(k),k=1,5)
700          format(1x,2i3,i5,2i3,f4.1,' x: ',5f9.3)
701          format(1x,2i3,i5,2i3,f4.1,' y: ',5f9.3)
             write(*,*)
          endif

          djc=djc+xlon  
    
          call jjdate(djc,ij,im,ian,jh,jm,s)

      enddo

      close (num)

      write(*,*) 'Other computation (y/n)'
      read(*,'(a)') irep
      if(irep.eq.'y'.or.irep.eq.'Y') go to 1000

      stop
      end

      subroutine xyfm(num,djc,ipla,xx,yy)
*     =============================================================
*     POSITIONS OF THE SATELLITES OF  MARS, JUPITER, SATURN, URANUS

*     (c) copyright Bureau des longitudes 1995
*     =============================================================
*     Astrometric differential tangential coordinates J2000

*     Input  data:
*     djc    : julian date of computation
*     ipla   : number of the planet
*     infile : name of the file where the coefficients will be read

*     Output data:
*     Astrometric differential tangential coordinates J2000:
*     xx(<=8)  : differential coordinates in arcsec (towards East)
*     yy(<=8)  : differential coordinates in arcsec (towards North)

*     =============================================================

      implicit real*8  (A-H,O-Z)
      character*20 infile

      dimension freq(8),idn(8),dellt(8),xx(8),yy(8)
      dimension cmx(6),cfx(4),cmy(6),cfy(4),ninter(8)


*     Read the number of satellites and number of the planet on the first record

      read (num,rec=1) npla,nsat


*     the first record contains also various data and comments:

*     idn    : number of the first record for the satellite nsat
*     freq   : associated frequency of the satellite
*     dellt  : length of the interval of validity of the coefficients 
*     ienrf  : number of the last record of the file
*     djori  : julian date of the beginning of the first interval of validity 
*     jan    : number of the year

      read (num,rec=1) npla,isat,(idn(i),i=1,nsat),(freq(i),i=1,nsat)
     .,(dellt(i),i=1,nsat),ienrf,djori,jan


*     control of the agreement between file name and number of planet

      if(ipla.ne.npla) then
        write(*,*)
     .  'Beware: ',infile,'do not correspond to the planet number '
     .  ,ipla,' but to the planet number ',npla
 
*    .  ' attention le fichier ',infile,' ne correspond pas a la planete'
*    .  ,ipla,'mais a la planete',npla

        return 
      endif

*     Number of intervals for each satellite

      do isat=1,nsat
      if(isat.lt.nsat) ninter(isat)= idn(isat+1)-idn(isat)
      if(isat.eq.nsat) ninter(isat)= ienrf-idn(isat)+1
      enddo

      do ksat=1,nsat
        icode=0

*       Control of the validity of the date DJC 

        if((djc-djori+1)/dfloat(idint(dellt(ksat))).gt.ninter(ksat))then
          icode=1
          write(*,*) 'Beware: the date ',djc,
     .    ' is not inside the time interval of the file ',infile
          stop 'We stop here...'

*         write(*,*) 'Attention: la date',djc,
*    .    'n''est pas couverte par le fichier ',infile
*         stop 'on arrete...'

        endif   

*       computation of the number of record id for satellite ksat

        id=idint((djc-djori)/dellt(ksat))+idn(ksat)                
        read (num,rec=id) isat,idx,ldat1,ldat2,t0,cmx,cfx,cmy,cfy                 

*       control of the interval

        t1= dint(t0) + 0.5d0
        t2= t1+dint(dellt(ksat))

        if(djc.lt.t1.or.djc.gt.t2) then

          write(*,*) ' date:',djc,' interval: from ',t1,' to ',t2
          write(*,*) ' number of record: ',id
          write(*,*) ' out of the interval'

*         write(*,*) ' date:',djc,' intervalle: de ',t1,' a ',t2
*         write(*,*) ' numero d enregistrement :',id
*         write(*,*) ' en dehors de l''intervalle'

          return
        endif

*       computation of the differential positions at djc
*       tau is the time elapsed from t1

        tau = djc-t1
        at  = tau*freq(ksat)

        x = cmx(1)+cmx(2)*tau+cmx(3)*sin(at+cfx(1))
        y = cmy(1)+cmy(2)*tau+cmy(3)*sin(at+cfy(1))

        x = x + cmx(4)*tau*sin(at+cfx(2))
     .        + cmx(5)*tau**2*sin(at+cfx(3))
     .        + cmx(6)*sin(2.d0*at+cfx(4))

        y = y + cmy(4)*tau*sin(at+cfy(2))
     .        + cmy(5)*tau**2*sin(at+cfy(3))
     .        + cmy(6)*sin(2.d0*at+cfy(4))

        xx(ksat)=x
        yy(ksat)=y

      enddo

      return
      end

      SUBROUTINE JJDATE (DJJ,JR,MS,LAN,LH,MN,SEC)
*     =============================================================
*     Julian date => Gregorian date

*     (c) copyright Bureau des longitudes 1995
*     =============================================================


*     CONVERSION D'UNE DATE  DE LA PERIODE JULIENNE EN DATE  GREGORIENNE
*     DATES POSTERIEURS AU 1 JANVIER 1601   ( 2305813.5  JOURS JULIENS )
*     DJ EST INITIALISE SELON LA VALEUR DE DJJ

      IMPLICIT REAL*8 (D-D,R-S)

      INI=1
      CALL INITI(DJJ,DJ,IAN,LAN,INI)
      DDI=0.D0
      IF(DJJ-DJ) 8,8,9
  9   IAN=IAN+1
      DJ=DJ+FLOAT(NJA(IAN-1))
      IF(DJJ-DJ) 7,8,9
   7  LAN=IAN-1
      DI=DJJ-(DJ-FLOAT(NJA(LAN)))
      DDI=DI-FLOAT(IDINT(DI))
      IDI=IDINT(DI)
      IM=0
      NJE=0
  12  IM=IM+1
      NJE=NJE+NJM(IM,LAN)
      IF(IDI-NJE) 10,11,12
  10  MS=IM
      IF(MS-1) 18,18,19
  18  JR=IDI+1
      GO TO 20
  19  JR=IDI- NJE+NJM(IM,LAN)+1
  20  LH=IDINT(DDI*24.D0+0.000001D0)
      RH=DDI*24.D0-FLOAT(LH)
      MN=IDINT(RH*60.D0+0.00001D0)
      RM=RH*60.D0-FLOAT(MN)
      SEC=RM*60.D0
      SEC=DABS(SEC)
      GO TO 3
   8  LAN=IAN
      MS=1
      GO TO 13
  11  MS=IM+1
  13  JR=1
      IF(DDI.NE.0.D0) GO TO 20
      LH=0
      MN=0
      SEC=0.
   3  RETURN
      END

      SUBROUTINE INITI(DJJ,DJ,IAN,LAN,I)
*     =============================================================
*     Initial date for the computation of Gregorian dates or Julian dates

*     (c) copyright Bureau des longitudes 1995
*     =============================================================


*     DETERMINATION DE LA DATE DE DEPART POUR LE CALCUL DE LA DATE
*     GREGORIENNE ( I=1 )  OU DE LA DATE JULIENNE ( I=2 )

      IMPLICIT REAL *8 (D-D)
      DIMENSION INI(16)

      DATA INI/5813,24075,42337,60599,78861,97123,115385,133647,151910,
     &  170172,188434,206696,224958,243220,261482,279744/
      GO TO (10,20),I
  10  IDI=IDINT(DJJ-2300000.5D0)
      DO 1 I=1,16
      IF(IDI.LT.INI(I)) GO TO 1
      DJ=2300000.5D0+FLOAT(INI(I))
      IAN=1601+(I-1)*50
   1  CONTINUE
      RETURN
  20  CONTINUE
      DO 2 I=1,16
      JAN=1601+(I-1)*50
      IF(LAN.LT.JAN) GO TO 2
      DJ=2300000.5D0+FLOAT(INI(I))
      IAN=JAN
   2  CONTINUE
      RETURN
      END

      FUNCTION NJM(IM,LAN)
      DIMENSION NJOURS(12)
      DATA NJOURS/31,28,31,30,31,30,31,31,30,31,30,31/
      NJM=NJOURS(IM)
      IF(IM.NE.2) RETURN
      A=FLOAT(LAN)
      IE=INT(A/4.+0.0001)
      IE=IE*4
      IF((LAN-IE).EQ.0) NJM=29
      IE=INT(A/100.+0.00001)
      IE=IE*100
      IF((LAN-IE).NE.0) RETURN
      IE=IE/100
      E=FLOAT(IE)
      JE=INT(E/4.+0.0001)
      JE=JE*4
      IF((IE-JE).EQ.0) RETURN
      NJM=28
      RETURN
      END

      FUNCTION NJA(LAN)
      NJA=337+NJM(2,LAN)
      RETURN
      END


      SUBROUTINE DATEJJ(JR,MS,LAN,LH,MN,SEC,DJJ)
*     =============================================================
*     Gregorian date => Julian date

*     (c) copyright Bureau des longitudes 1995
*     =============================================================

*     CONVERSION D'UNE DATE GREGORIENNE EN DATE EN JOURS DE LA PERIODE JULIENNE
*     DATES POSTERIEURS AU 1 JANVIER 1601

*     DJ EST INITIALISE SELON LA VALEUR DE LAN

      DOUBLE PRECISION DJJ,SEC,DJ

      INI=2
      CALL INITI(DJJ,DJ,IAN,LAN,INI)
      NAN=LAN-1
      DJJ=DJ
      IF(IAN.EQ.LAN) GO TO 2
      DO 6 I=IAN,NAN
      NJ=NJA(I)
      DJJ=DJJ+FLOAT(NJ)
   6  CONTINUE
   2  CONTINUE
      IF(MS.EQ.1) GO TO 3
      MSM=MS-1
      DO 16 IM=1,MSM
      NJ=NJM(IM,LAN)
      DJJ=DJJ+FLOAT(NJ)
  16  CONTINUE
  3   DJJ=DJJ+FLOAT(JR-1)
      DJJ=DJJ+FLOAT(LH)/24.D0
      DJJ=DJJ+FLOAT(MN)/1440.D0
      DJJ=DJJ+SEC/86400.D0
      RETURN
      END


