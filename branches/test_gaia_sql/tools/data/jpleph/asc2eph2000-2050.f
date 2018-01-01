      PROGRAM ASC2EPH
C
C      ASC2EPH creates a binary format JPL Planetary Ephemeris file from
C      one or more ascii text files.
C
C$ Disclaimer
C
C     THIS SOFTWARE AND ANY RELATED MATERIALS WERE CREATED BY THE
C     CALIFORNIA INSTITUTE OF TECHNOLOGY (CALTECH) UNDER A U.S.
C     GOVERNMENT CONTRACT WITH THE NATIONAL AERONAUTICS AND SPACE
C     ADMINISTRATION (NASA). THE SOFTWARE IS TECHNOLOGY AND SOFTWARE
C     PUBLICLY AVAILABLE UNDER U.S. EXPORT LAWS AND IS PROVIDED "AS-IS"
C     TO THE RECIPIENT WITHOUT WARRANTY OF ANY KIND, INCLUDING ANY
C     WARRANTIES OF PERFORMANCE OR MERCHANTABILITY OR FITNESS FOR A
C     PARTICULAR USE OR PURPOSE (AS SET FORTH IN UNITED STATES UCC
C     SECTIONS 2312-2313) OR FOR ANY PURPOSE WHATSOEVER, FOR THE
C     SOFTWARE AND RELATED MATERIALS, HOWEVER USED.
C
C     IN NO EVENT SHALL CALTECH, ITS JET PROPULSION LABORATORY, OR NASA
C     BE LIABLE FOR ANY DAMAGES AND/OR COSTS, INCLUDING, BUT NOT
C     LIMITED TO, INCIDENTAL OR CONSEQUENTIAL DAMAGES OF ANY KIND,
C     INCLUDING ECONOMIC DAMAGE OR INJURY TO PROPERTY AND LOST PROFITS,
C     REGARDLESS OF WHETHER CALTECH, JPL, OR NASA BE ADVISED, HAVE
C     REASON TO KNOW, OR, IN FACT, SHALL KNOW OF THE POSSIBILITY.
C
C     RECIPIENT BEARS ALL RISK RELATING TO QUALITY AND PERFORMANCE OF
C     THE SOFTWARE AND ANY RELATED MATERIALS, AND AGREES TO INDEMNIFY
C     CALTECH AND NASA FOR ALL THIRD-PARTY CLAIMS RESULTING FROM THE
C     ACTIONS OF RECIPIENT IN THE USE OF THE SOFTWARE.
C
C
C      This program, 'asc2eph', requires (via standard input) an ascii
C      header file ('header.XXX'), followed by one or more ascii ephemeris 
C      data files ('ascSYYYY.XXX').  All files must have the same ephemeris
C      number, XXX.  Further, the data files must be consecutive in time
C      with no gaps between them. 
C
C      By default, the output ephemeris will span the same interval as the input
C      text file(s).  If you are interested in only a portion of data, set the
C      below T1 and T2 to the begin and end times of the span you desire.  T1
C      and T2 must be specified in  Julian Ephemeris Days (ET).
C
C      A sample sequence of files might be:
C
C        header.405  asc+1920.405 asc+1940.405 asc+1960.405 asc+1980.405  
C
C      This program is written in standard Fortran-77.  
C
C **********************************************************************************
C
C                                    *** NOTE ***
C
C      However, the units in which the length of a direct access record is specified 
C      are PROCESSOR DEPENDENT.  The parameter NRECL, the number of units per word, 
C      controls the length of a record in the direct access ephemeris.
C      The user MUST select the correct value of NRECL by editing one of the 
C      comemnted lines defining PARAMETER (NRECL) below.
C
C **********************************************************************************
C
C     Updated 02 March  2013 to accommodate more than 400 dynamical parameters
C     Updated 02 August 2013 to accommodate reading of TT-TDB
C     Updated 15 August 2013 to accommodate negative Julian dates
C
C **********************************************************************************

      IMPLICIT NONE

      INTEGER NRECL

C *****  The user must choose one of the following statements  *****
C            ( Usually NRECL = 4 is used on Unix platforms)

      PARAMETER ( NRECL = 4 )
C      PARAMETER ( NRECL = 1 )

      INTEGER OLDMAX
      PARAMETER ( OLDMAX = 400)
      INTEGER NMAX
      PARAMETER ( NMAX = 1000)

C **********************************************************************************

       CHARACTER*6  CNAM (NMAX)
       CHARACTER*6  TTL  (14,3)
       CHARACTER*12 HEADER

       DOUBLE PRECISION  AU
       DOUBLE PRECISION  CVAL (NMAX)
       DOUBLE PRECISION  DB(3000)
       DOUBLE PRECISION  DB2Z
       DOUBLE PRECISION  EMRAT
       DOUBLE PRECISION  SS   (3)
       DOUBLE PRECISION  T1, T2

       INTEGER  I, IRECSZ, IN
       INTEGER  J
       INTEGER  K,KK,KP2,KSIZE
       INTEGER  IPT (3,12)                         ! Pointers to number of coefficients for bodies
       INTEGER  LPT(3)                             ! Pointer to number of coefficients for lunar librations
       INTEGER  RPT(3)                             ! Pointer to number of coefficients for lunar euler angel rates
       INTEGER  TPT(3)                             ! Pointer to number of coefficients for TT-TDB
       INTEGER  N, NCON, NROUT, NCOEFF, NRW, NUMDE
       INTEGER  OUT

       LOGICAL  FIRST
       DATA     FIRST / .TRUE. /

C ***********************************************************************
C
C     By default, the output ephemeris will span the same interval as the
C     input ascii data file(s).  The user may reset these to other JED's.
C
       DB2Z = -99999999.d0
       T1   =  2451512.5   ! 2000.0 - 32d
       T2   =  2470224.5   ! 2051.0 + 32d

       IF(NRECL .NE. 1 .AND. NRECL .NE. 4) THEN
         WRITE(*,*)'*** ERROR: User did not set NRECL ***'
         STOP
       ENDIF

C      Write a fingerprint to the screen.

       WRITE(*,*) ' JPL ASCII-TO-DIRECT-I/O program. ' //
     &            ' Last modified 15-Aug-2013.'

C      Read the size and number of main ephemeris records.
C        (from header.xxx)

       READ  (*,'(6X,I6)')  KSIZE
       WRITE (*,100)              KSIZE
100    FORMAT(/'KSIZE =',I6)

       IRECSZ = NRECL * KSIZE

C      Now for the alphameric heading records (GROUP 1010)

       CALL  NXTGRP ( HEADER )

       IF (HEADER .NE. 'GROUP   1010')  THEN
          CALL  ERRPRT ( 1010, 'NOT HEADER' )
       ENDIF

       READ (*,'(14A6)')    TTL
       WRITE(*,'(/(14A6))') TTL

c      Read start, end and record span  (GROUP 1030)

       CALL  NXTGRP ( HEADER )

       IF ( HEADER .NE. 'GROUP   1030' ) THEN
          CALL ERRPRT ( 1030, 'NOT HEADER' )
       ENDIF

       READ (*,'(3D12.0)')  SS

c      Read number of constants and names of constants (GROUP 1040/4).

       CALL  NXTGRP ( HEADER )

       IF ( HEADER .NE. 'GROUP   1040 ') THEN
          CALL ERRPRT ( 1040, 'NOT HEADER' )
       ENDIF

       READ (*,'(I6)')    N
       READ (*,'(10A8)') (CNAM(I),I=1,N)

       NCON = N

C      Read number of values and values (GROUP 1041/4)

       CALL  NXTGRP ( HEADER )

       IF ( HEADER .NE. 'GROUP   1041' ) THEN
          CALL ERRPRT ( 1041, 'NOT HEADER' )
       ENDIF

       READ (*,'(I6)')       N
       READ (*,*)  (CVAL(I),I=1,N)

       DO  I = 1, N
           IF ( CNAM(I) .EQ. 'AU    ' )  AU    = CVAL(I)
           IF ( CNAM(I) .EQ. 'EMRAT ' )  EMRAT = CVAL(I)
           IF ( CNAM(I) .EQ. 'DENUM ' )  NUMDE = CVAL(I)
       END DO

       WRITE (*,'(500(/2(A8,D24.16)))') (CNAM(I),CVAL(I),I=1,N)

c      Zero out pointer arrays

       DO I = 1,3
         DO J = 1,12
           IPT(I,J) = 0
         ENDDO
         LPT(I) = 0
         RPT(I) = 0
         TPT(I) = 0
       ENDDO

C      Read pointers needed by INTERP (GROUP 1050)

       CALL  NXTGRP ( HEADER )

       IF ( HEADER .NE. 'GROUP   1050' ) THEN
          CALL ERRPRT ( 1050, 'NOT HEADER' )
       ENDIF

       WRITE(*,'(/)')

       DO I=1,3
         READ (*,'(15I6)') (IPT(I,J),J=1,12),LPT(I),RPT(I),TPT(I)
         WRITE(*,'(15I5)')(IPT(I,J),J=1,12),LPT(I),RPT(I),TPT(I)
       ENDDO

C      Open direct-access output file ('JPLEPH')

       OPEN ( UNIT   = 12,
     .        FILE   = 'JPLEPH',
     .        ACCESS = 'DIRECT',
     .        FORM   = 'UNFORMATTED',
     .        RECL   = IRECSZ,
     .        STATUS = 'NEW' )

C     Read and write the ephemeris data records (GROUP 1070).

      CALL  NXTGRP ( HEADER )

      IF ( HEADER .NE. 'GROUP   1070' ) CALL ERRPRT(1070,'NOT HEADER')

      NROUT  = 0
      IN     = 0
      OUT    = 0

   1  continue

      READ(*,'(2I6)')NRW,NCOEFF
      IF(NRW .EQ. 0) GO TO 1

      DO K=1,NCOEFF,3
        KP2 = MIN(K+2,NCOEFF)
        READ(*,*,IOSTAT = IN)(DB(KK),KK=K,KP2)
        IF(IN. NE. 0)STOP ' Error reading 1st set of coeffs'
      ENDDO

      DO WHILE (       ( IN    .EQ. 0 )
     .           .AND. ( DB(2) .LT. T2) )

          IF ( 2*NCOEFF .NE. KSIZE ) THEN
             CALL ERRPRT(NCOEFF,' 2*NCOEFF not equal to KSIZE')
          ENDIF

C         Skip this data block if the end of the interval is less
C         than the specified start time or if the it does not begin
C         where the previous block ended.

          IF  ( (DB(2) .GE. T1) .AND. (DB(1) .GE. DB2Z) ) THEN

             IF ( FIRST ) THEN

C               Don't worry about the intervals overlapping
C               or abutting if this is the first applicable
C               interval.

                DB2Z  = DB(1)
                FIRST = .FALSE.
             ENDIF

             IF (DB(1) .NE. DB2Z ) THEN
 
C               Beginning of current interval is past the end
C               of the previous one.

                CALL ERRPRT (NRW, 'Records do not overlap or abut')
             ENDIF

             DB2Z  = DB(2)
             NROUT = NROUT + 1

             WRITE (12,REC=NROUT+2,IOSTAT=OUT) (DB(K),K=1,NCOEFF)

             IF ( OUT .NE. 0 ) THEN
                CALL ERRPRT (NROUT, 
     &                     'th record not written because of error')
             ENDIF

C            Save this block's starting date, its interval span, and its end 
C            date.

             IF (NROUT .EQ. 1) THEN
                SS(1) = DB(1)
                SS(3) = DB(2) - DB(1)
             ENDIF
             SS(2) = DB(2)

C            Update the user as to our progress every 100th block.

             IF ( MOD(NROUT,100) .EQ. 1 ) THEN
                IF ( DB(1) .GE. T1 ) THEN
                   WRITE (*,271) NROUT, DB(2)
                ELSE
                   WRITE (*,*) 
     &           ' Searching for first requested record...'
                ENDIF
             ENDIF
271          FORMAT (I6,
     &              ' EPHEMERIS RECORDS WRITTEN.  LAST JED = ',
     &              F12.2)

          ENDIF

          READ (*,'(2I6)',IOSTAT =IN) NRW, NCOEFF

          IF(IN .EQ. 0)then
            DO K=1,NCOEFF,3
              KP2 = MIN(K+2,NCOEFF)
              READ(*,*,IOSTAT = IN)(DB(KK),KK=K,KP2)
              IF(IN. NE. 0)STOP ' Error reading nth set of coeffs'
            ENDDO
          ENDIF

      END DO

      WRITE (*,275) NROUT, DB(2)
275   FORMAT(I6, ' EPHEMERIS RECORDS WRITTEN.  LAST JED = ',F12.2)

C     Write header records onto output file.

      NROUT = 1

      IF(NCON .LE. OLDMAX)THEN
         WRITE(12,REC=1,IOSTAT=OUT) TTL,(CNAM(I),I=1,OLDMAX),SS,NCON,AU,
     &              EMRAT,IPT,NUMDE,LPT,RPT,TPT
      ELSE
         K = OLDMAX+1
         WRITE(12,REC=1,IOSTAT=OUT) TTL,(CNAM(I),I=1,OLDMAX),SS,NCON,AU,
     &              EMRAT,IPT,NUMDE,LPT,(CNAM(J),J=K,NCON),RPT,TPT
      ENDIF

      IF ( OUT .NE. 0 ) THEN
          CALL ERRPRT ( NROUT, 'st record not written because of error')
      ENDIF

      NROUT = 2

      IF(NCON .LE. OLDMAX) THEN
         WRITE(12,REC=2,IOSTAT=OUT)(CVAL(I),I=1,OLDMAX)
      ELSE
         WRITE(12,REC=2,IOSTAT=OUT)(CVAL(I),I=1,NCON)
      ENDIF

      IF ( OUT .NE. 0 ) THEN
          CALL ERRPRT ( NROUT, 'nd record not written because of error')
      ENDIF

C     We're through.  Wrap it up.

      CLOSE (12)
      STOP ' OK'

      END


      SUBROUTINE  ERRPRT (I, MSG)

      CHARACTER*(*)  MSG
      INTEGER        I

      WRITE (*,200)  I, MSG
200   FORMAT('ERROR #',I8,2X,A50)

      STOP ' ERROR '
      END


      SUBROUTINE  NXTGRP ( HEADER )

      CHARACTER*(*)  HEADER
      CHARACTER*12   BLANK

C     Start with nothing.

      HEADER = ' '

C     The next non-blank line we encounter is a header record.
C     The group header and data are seperated by a blank line.

      DO WHILE ( HEADER .EQ. ' ' )
          READ (*,'(A)') HEADER
      ENDDO

C     Found the header.  Read the blank line so we can get at the data.

      IF ( HEADER .NE. 'GROUP   1070' )READ (*, '(A)') BLANK

      RETURN
      END
