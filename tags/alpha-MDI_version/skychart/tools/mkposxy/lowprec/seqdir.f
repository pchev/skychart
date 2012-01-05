*     ***************************************************************

*     Natural Satellites Ephemerides

*     seqdirn.f:
*     conversion of ASCII files of coefficients
*     in direct access files to be used with 
*     the routines diffpos.f and xyfm in order to 
*     compute differential tangential coordinates of natural satellites

*     Anonymous Server: ftp.bdl.fr

*     ***************************************************************

*     (c) copyright Bureau des longitudes 1995

*     J.-E. Arlot, Ch. Ruatti, D.T. Vu., W. Thuillot
*     Bureau des longitudes
*     77 av. Denfert Rochereau  F-75014 PARIS

*     ***************************************************************


      implicit double precision (a-h,o-z)
      character*7 nompla(4)
      character*20 infile,outfile
      data nompla /'marsbin','jupibin','satubin','uranbin'/
      dimension cmx(6),cmy(6),cfx(4),cfy(4),freq(8),idn(8),dellt(8)

      write(*,*)
      write(*,*) 'Mars    : 4'
      write(*,*) 'Jupiter : 5'
      write(*,*) 'Saturn  : 6'
      write(*,*) 'Uranus  : 7'
      write(*,*)
*     write(*,*) 'Numero de la planete ? '
      write(*,*) 'Number of the planet ?'

      read(*,*) num

*     write(*,*) 'Nom du fichier d''entree'
*     write(*,*) 'Nom du fichier de sortie'

      write(*,*) 'Name of the input file'
      read(*,'(A)') infile
*      write(*,*) 'Name of the output file'
*      read(*,'(A)') outfile
c
	ipla=num
      jj1= int((ian-1900)/10)
      xj2= ((ian-1900)/10. - jj1)*10.
      jj1= mod(jj1,10)
      jj2= nint(xj2)
    
      outfile = nompla(ipla-3)//'.'//char(jj1+48)//char(jj2+48)
      write(*,*) 'Name of the file: ',outfile

*      write(*,*) ' voulez-vous une impression de controle'

      write(*,*) 'printing of control lines? (yes:1 /no: 0)'
      read(*,'(i1)') iecr

      open (10,file=outfile,access='direct',recl=184)
      open (1,file=infile,access='sequential')

      idd=1
      read(1,*) npla,isat
      write(*,*) npla,isat

      rewind 01

*     ================================================================

*     Format of the INPUT ASCII file records:


*     FIRST RECORD:

*     npla : number of the planet
*     nsat : number of satellites
*     idn  : number of the first record for the satellite nsat
*     freq : associated frequency of the satellite
*     dellt: length of the interval of validity of the coefficients 
*     ienrf: number of the last record of the file
*     djj  : julian date of the beginning of the first interval of validity
*     jan  : number of the year


*     OTHER RECORDS:

*     isat : number of satellites
*     idx  : number of record
*     ldat1: date YYYYMMDD of the beginning of the intervall
*     ldat2: date YYYYMMDD of the end of the intervall
*     t0   : julian date of the beginning of the interval of validity
*     cmx  : coefficients in x 
*     cfx  : phases in x
*     cmy  : coefficients in y
*     cfy  : phases in y 

*     ================================================================
*     for the computation of positions x and y at t
*     diffpos program uses these data thanks to the following formular
  
*     if tau is t - t0 

*     where t is a date where we wish to compute the positions
*     and t0 the date of the beginning of the interval of validity

*     x  = cmx(1) + cmx(2) + cmx(3)*       sin(  tau * freq + cfx(1))
*                          + cmx(4)*tau*   sin(  tau * freq + cfx(2))
*                          + cmx(5)*tau**2*sin(  tau * freq + cfx(3))
*                          + cmx(6)*       sin(2*tau * freq + cfx(4))

*     y is given by the same formula in y

*     ================================================================

      if (num.eq.4) then
           read(1,*) npla,nsat,(idn(i),i=1,isat),
     .     (freq(i),i=1,isat),(dellt(i),i=1,isat),ienrf,djj,jan
4	   format(2i2,2i4,2f7.4,2f5.1)
	   write(*,*) ienrf,djj,jan
      endif
      if (num.eq.5) then
           read(1,*) npla,nsat,(idn(i),i=1,isat),
     .     (freq(i),i=1,isat),(dellt(i),i=1,isat),ienrf,djj,jan
5	   format(2i2,4i4,4f7.4,4f5.1)
      endif
      if (num.eq.6) then
           read(1,*) npla,nsat,(idn(i),i=1,isat),
     .     (freq(i),i=1,isat),(dellt(i),i=1,isat),ienrf,djj,jan
6	   format(2i2,8i4,8f7.4,8f5.1)
      endif
      if (num.eq.7) then
           read(1,*) npla,nsat,(idn(i),i=1,isat),
     .     (freq(i),i=1,isat),(dellt(i),i=1,isat),ienrf,djj,jan
7	   format(2i2,5i4,5f7.4,5f5.1)
      endif

      write(*,*) npla,nsat,(idn(i),i=1,isat),
     .     (freq(i),i=1,isat),(dellt(i),i=1,isat),ienrf,djj,jan
            write(10,rec=idd) npla,nsat,(idn(i),i=1,isat),
     .     (freq(i),i=1,isat),(dellt(i),i=1,isat),ienrf,djj,jan

      idd=2

1     continue

      read(1,9,end=2)  isat,idx,ldat1,ldat2,t0,cmx,cfx,cmy,cfy
9     format(i1,i3,2i8,f9.1,20d17.10)

      if (iecr.ne.0) then
          write(*,200) isat,idx,ldat1,ldat2,t0
          write(*,201) cmx,cfx,cmy,cfy
200       format(1x,i1,i4,2i9,f10.1)
201       format(4(d18.10))
      endif

      write(10,rec=idd) isat,idx,ldat1,ldat2,t0,cmx,cfx,cmy,cfy
      idd=idd+1

      go to  1

2     continue

      stop 
      end
