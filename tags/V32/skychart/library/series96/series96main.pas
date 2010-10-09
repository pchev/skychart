unit series96main;

interface

uses Math, SysUtils,
     series, coscoeff, sincoeff;

type double6 = array[0..5] of double;
     Pdouble6 = ^double6;

Procedure Plan96(tjd:double;ipla:integer; velocities:boolean ; Pr : Pdouble6; var ierr:integer) stdcall;
Procedure Earth96(tjd:double; Pr : Pdouble6 ) stdcall;

implementation

var
     v,w,ws : array [1..3] of double;

Procedure Plan96(tjd:double;ipla:integer; velocities:boolean ; Pr : Pdouble6; var ierr:integer) stdcall;
{*
          Translation FORTRAN - PASCAL pour Delphi : P. Chevalley 22 mars 1998
          + calcul des vitesses facultatif
          + évite de lire les fichiers plusieurs fois .

          Version DLL 5 novembre 1999

      subroutine SERIES (tjd,ipla,lu,r,ierr)
*     ======================================
*
*     Ref : Bureau des Longitudes - 96.12
*           J. Chapront, G. Francou (BDL)
*
*
*     Object
*     ------
*
*     Compute planetary ephemerides with series built by a method of
*     representation using frequency analysis.
*     Ref : J. Chapront, 1995, Astron. Atrophys. Sup. Ser., 109, 181.
*
*     Planetary Ephemerides : rectangular heliocentric coordinates.
*     Source : DE403 (Jet Propulsion Laboratory).
*     Frame : Dynamical Mean Equinox and Equator J2000 (DE403).
*     Time  : Barycentric Dynamical Time (TDB).
*
*     Input
*     -----
*
*     tjd :       Julian date TDB (double real).
*
*     ipla :      Planet index (integer).
*                 1 : Mercury.
*                 2 : Venus.
*                 3 : Earth-Moon Barycenter.
*                 4 : Mars.
*                 5 : Jupiter.
*                 6 : Saturn.
*                 7 : Uranus.
*                 8 : Neptune.
*                 9 : Pluto.
*
*     Output
*     ------
*
*     r(6) :      Table of rectangular coordinates (double real).
*                 r(1) : X  position (au).
*                 r(2) : Y  position (au).
*                 r(3) : Z  position (au).
*                 r(4) : X' velocity (au/day).
*                 r(5) : Y' velovity (au/day).
*                 r(6) : Z' velocity (au/day).
*
*     ierr :      Error index (integer).
*                 0 : no error.
*                 1 : date error.
*                 2 : planet index error.
*
*     Declarations
*     ------------
*}

var
      i,nb,m,iv,max,nw : integer;
      tmax,tdeb,x,fx,wx,f,cf,sf,wt,fw,stw,ctw,wy : double;

begin
{*
*     Check up planet
*     ---------------
*}
      ierr:=2;
      if (ipla<1) or (ipla>9) then exit;
{*
*     Clear results table
*     -------------------
*}
      for i:=0 to 5 do begin
         Pr^[i]:=0;
      end;

{*
*
*     Check up date
*     -------------
*}
      ierr:=1;
      tmax:=tzero[ipla]+dt[ipla]*iblock[ipla];
      if (tjd<tzero[ipla]-0.5) or (tjd>tmax+0.5) then exit;
      nb:=trunc((tjd-tzero[ipla])/dt[ipla])+1;
      if (tjd<=tzero[ipla]) then nb:=1;
      if (tjd>=tmax) then nb:=iblock[ipla];

{*
*
*     Change variable
*     ---------------
*}
      tdeb:=tzero[ipla]+(nb-1)*dt[ipla];
      x:=2*(tjd-tdeb)/dt[ipla]-1;
      fx:=x*dt[ipla]/2;
{*
*     Compute positions (secular terms)
*     ---------------------------------
*}

      for iv:=1 to 3 do begin
         v[iv]:=0;
         wx:=1;
         max:=2*imax[ipla]-1;
         for i:=0 to max do begin
            case ipla of
                1:v[iv]:=v[iv]+mersec[nb,i,iv]*wx;
                2:v[iv]:=v[iv]+vensec[nb,i,iv]*wx;
                3:v[iv]:=v[iv]+embsec[nb,i,iv]*wx;
                4:v[iv]:=v[iv]+marsec[nb,i,iv]*wx;
                5:v[iv]:=v[iv]+jupsec[nb,i,iv]*wx;
                6:v[iv]:=v[iv]+satsec[nb,i,iv]*wx;
                7:v[iv]:=v[iv]+urasec[nb,i,iv]*wx;
                8:v[iv]:=v[iv]+nepsec[nb,i,iv]*wx;
                9:v[iv]:=v[iv]+plusec[nb,i,iv]*wx;
            end;
            wx:=wx*x;
         end;
      end;

{*
*     Compute positions (Poisson terms)
*     ---------------------------------
*}
      wx:=1;
      for m:=0 to mx[ipla] do begin
         nw:=nf[ipla,m];
         for iv:=1 to 3 do begin
            ws[iv]:=0;
         end;
         for i:=1 to nw do begin
            case ipla of
                1:f:=merfq[i,m]*fx;
                2:f:=venfq[i,m]*fx;
                3:f:=embfq[i,m]*fx;
                4:f:=marfq[i,m]*fx;
                5:f:=jupfq[i,m]*fx;
                6:f:=satfq[i,m]*fx;
                7:f:=urafq[i,m]*fx;
                8:f:=nepfq[i,m]*fx;
                9:f:=plufq[i,m]*fx;
            else
                f:=embfq[i,m]*fx;
            end;
            cf:=cos(f);
            sf:=sin(f);
            for iv:=1 to 3 do begin
               case ipla of
                  1:ws[iv]:=ws[iv]+merct[nb,i,m,iv]*cf+merst[nb,i,m,iv]*sf;
                  2:ws[iv]:=ws[iv]+venct[nb,i,m,iv]*cf+venst[nb,i,m,iv]*sf;
                  3:ws[iv]:=ws[iv]+embct[nb,i,m,iv]*cf+embst[nb,i,m,iv]*sf;
                  4:ws[iv]:=ws[iv]+marct[nb,i,m,iv]*cf+marst[nb,i,m,iv]*sf;
                  5:ws[iv]:=ws[iv]+jupct[nb,i,m,iv]*cf+jupst[nb,i,m,iv]*sf;
                  6:ws[iv]:=ws[iv]+satct[nb,i,m,iv]*cf+satst[nb,i,m,iv]*sf;
                  7:ws[iv]:=ws[iv]+uract[nb,i,m,iv]*cf+urast[nb,i,m,iv]*sf;
                  8:ws[iv]:=ws[iv]+nepct[nb,i,m,iv]*cf+nepst[nb,i,m,iv]*sf;
                  9:ws[iv]:=ws[iv]+pluct[nb,i,m,iv]*cf+plust[nb,i,m,iv]*sf;
               else
                  ws[iv]:=ws[iv]+embct[nb,i,m,iv]*cf+embst[nb,i,m,iv]*sf;
               end;
            end;
         end;
         for iv:=1 to 3 do begin
            v[iv]:=v[iv]+ws[iv]*wx;
         end;
         wx:=wx*x;
      end;

if velocities then begin
{*
*
*     Compute velocities (secular terms)
*     ----------------------------------
*}
      wt:=2/dt[ipla];
      for iv:=1 to 3 do begin
         w[iv]:=0;
         wx:=1;
         max:=2*imax[ipla]-1;
         for i:=1 to max do begin
            case ipla of
                1:w[iv]:=w[iv]+i*mersec[nb,i,iv]*wx;
                2:w[iv]:=w[iv]+i*vensec[nb,i,iv]*wx;
                3:w[iv]:=w[iv]+i*embsec[nb,i,iv]*wx;
                4:w[iv]:=w[iv]+i*marsec[nb,i,iv]*wx;
                5:w[iv]:=w[iv]+i*jupsec[nb,i,iv]*wx;
                6:w[iv]:=w[iv]+i*satsec[nb,i,iv]*wx;
                7:w[iv]:=w[iv]+i*urasec[nb,i,iv]*wx;
                8:w[iv]:=w[iv]+i*nepsec[nb,i,iv]*wx;
                9:w[iv]:=w[iv]+i*plusec[nb,i,iv]*wx;
            end;
            wx:=wx*x;
         end;
         w[iv]:=wt*w[iv];
      end;
{*
*
*     Compute velocities (Poisson terms)
*     ----------------------------------
*}
      wx:=1; wy:=1;
      for m:=0 to mx[ipla] do begin
         nw:=nf[ipla,m];
         for i:=1 to nw do begin
            case ipla of
                1:fw:=merfq[i,m];
                2:fw:=venfq[i,m];
                3:fw:=embfq[i,m];
                4:fw:=marfq[i,m];
                5:fw:=jupfq[i,m];
                6:fw:=satfq[i,m];
                7:fw:=urafq[i,m];
                8:fw:=nepfq[i,m];
                9:fw:=plufq[i,m];
            else
                fw:=embfq[i,m];
           end;
            f:=fw*fx;
            cf:=cos(f);
            sf:=sin(f);
            for iv:=1 to 3 do begin
               case ipla of
                   1:begin
                        stw:=merst[nb,i,m,iv];
                        ctw:=merct[nb,i,m,iv];
                     end;
                   2:begin
                        stw:=venst[nb,i,m,iv];
                        ctw:=venct[nb,i,m,iv];
                     end;
                   3:begin
                        stw:=embst[nb,i,m,iv];
                        ctw:=embct[nb,i,m,iv];
                     end;
                   4:begin
                        stw:=marst[nb,i,m,iv];
                        ctw:=marct[nb,i,m,iv];
                     end;
                   5:begin
                        stw:=jupst[nb,i,m,iv];
                        ctw:=jupct[nb,i,m,iv];
                     end;
                   6:begin
                        stw:=satst[nb,i,m,iv];
                        ctw:=satct[nb,i,m,iv];
                     end;
                   7:begin
                        stw:=urast[nb,i,m,iv];
                        ctw:=uract[nb,i,m,iv];
                     end;
                   8:begin
                        stw:=nepst[nb,i,m,iv];
                        ctw:=nepct[nb,i,m,iv];
                     end;
                   9:begin
                        stw:=plust[nb,i,m,iv];
                        ctw:=pluct[nb,i,m,iv];
                     end;
               else
                   stw:=embst[nb,i,m,iv];
                   ctw:=embct[nb,i,m,iv];
               end;
               w[iv]:=w[iv]+fw*(stw*cf-ctw*sf)*wx;
               if m>0 then w[iv]:=w[iv]+m*wt*(ctw*cf+stw*sf)*wy;
            end;
         end;
         wy:=wx;
         wx:=wx*x;
      end;
end
{ no velocities }
else begin
for iv:=1 to 3 do begin
     w[iv]:=0;
end;
end;
{*
*     Stock results
*     -------------
*}
      for iv:=1 to 3 do begin
         Pr^[iv-1]:=v[iv]/1e10;
         Pr^[iv+3-1]:=w[iv]/1e10;
      end;
{*
*     Exit
*     ----
*}
      ierr:=0;
end;


Procedure Earth96(tjd:double; Pr : Pdouble6 ) stdcall;
{*
*
          Translation pour Delphi : P. Chevalley 22 mars 1998

*
      subroutine EARTH (tjd,r)
*     ========================
*
*
*     Ref : Bureau des Longitudes - 96.12
*           J. Chapront, G. Francou (BDL)
*
*
*     Object
*     ------
*
*     Rectangular coordinates of geocentric Earth-Moon barycenter
*     (equinox and equateur J2000).
*
*     Input
*     -----
*
*     tjd :       Julian date TDB (double real).
*
*
*     Output
*     ------
*
*     r(3) :      Table of rectangular coordinates (double real).
*                 r(1) : X  position (au).
*                 r(2) : Y  position (au).
*                 r(3) : Z  position (au).
*
*-----------------------------------------------------------------------
*
*}
const
      n1 : array[1..3] of integer = (01,44,93);
      n2 : array[1..3] of integer = (43,92,138);
      c : array [1..138] of double = (
     -244075.,  -2965.,   8528.,   2345.,  -2486.,   1426.,    527.,
         -43.,   -393.,    394.,   -218.,     73.,     91.,   -173.,
          25.,    -20.,     75.,     72.,      6.,     72.,    -40.,
         -58.,     56.,    -53.,     46.,    -44.,     -5.,      0.,
          -1.,    -12.,     21.,     -4.,     -4.,     -2.,      9.,
           8.,     10.,      2.,    -10.,    -12.,    -11.,     10.,
         -10.,-176962., -23344., -11109.,   -922.,  -4118.,    714.,
       -1135.,   -601.,    299.,    564.,   -311.,    261.,   -251.,
         254.,    229.,    213.,   -179.,     57.,    -19.,   -125.,
        -113.,    -87.,    -52.,     75.,     16.,     -5.,    -42.,
          -4.,    -10.,      8.,    -19.,      9.,     40.,     29.,
         -25.,     11.,     19.,    -12.,     -5.,     18.,    -15.,
         -16.,     13.,     13.,      9.,     -1.,     -3.,     -5.,
          -1., -76714.,  25611., -10120.,   -400.,   1387.,  -1785.,
         310.,    580.,   -492.,   -527.,     44.,    130.,    244.,
        -135.,    113.,    -38.,    110.,     92.,    -78.,     25.,
         -54.,    -26.,    -49.,    -38.,     27.,    -23.,     32.,
           2.,     -2.,      1.,    -18.,     -2.,    -23.,     -4.,
           3.,     -8.,      4.,    -11.,     17.,      3.,    -11.,
          13.,      8.,    -11.,     -7.,      4. );

      s : array [1..138] of double = (
      192874.,  25444.,   1005.,   4489.,   -778.,   1238.,   -326.,
        -614.,    339.,   -285.,   -276.,   -232.,    195.,    -63.,
         136.,    124.,     95.,     57.,    -82.,      5.,     45.,
           4.,     11.,     -9.,     20.,    -10.,    -44.,    -32.,
          27.,    -20.,      6.,    -20.,     17.,     17.,    -14.,
         -14.,      4.,    -11.,    -10.,      3.,      6.,     -7.,
           4.,-223938.,  -2720.,    635.,   7824.,   2151.,  -2281.,
        1309.,   -675.,    483.,    -40.,   -360.,    362.,    327.,
        -200.,    204.,     67.,     84.,   -159.,   -145.,     23.,
         -18.,     69.,     66.,      5.,     65.,     66.,    -36.,
         -53.,     51.,    -48.,     42.,    -40.,     -5.,      0.,
          -1.,    -19.,    -11.,     17.,     20.,     -4.,     -4.,
          -2.,      9.,      7.,     -9.,    -13.,    -11.,    -10.,
          11., -97079.,  -1464.,  -1179.,   3392.,   1557.,    933.,
        -989.,   -754.,    567.,   -470.,    334.,    210.,    -17.,
        -156.,    157.,   -151.,    -87.,     29.,     36.,    -69.,
          10.,     43.,     -8.,     30.,    -39.,     29.,      2.,
          29.,     29.,    -25.,    -16.,    -23.,      3.,     22.,
         -21.,     18.,    -17.,     13.,     -2.,     14.,     -8.,
           0.,     -9.,      0.,     -8.,      9. );

      f : array [1..138] of double = (
      0.2299708345453799, 0.0019436907548255, 0.4579979783362081,
      0.0324605575663244,-0.1955665862245038, 0.4274811115247091,
     -0.2318206046403833, 0.6555082553155372, 0.2127688645204655,
      0.2471728045705681, 0.6860251221267625, 0.2604877013568789,
      0.0496625275912389,-0.1783646161993155, 0.0172021241604381,
      0.0191456607800137,-0.2260834530360027, 0.4102791414995209,
     -0.0152582792703628, 0.4407960083110198, 0.8835353991060917,
      0.1994539677341547, 0.2662248529612594, 0.4751999483613963,
      0.4427395449305955,-0.0037934608495551, 0.6383062852903491,
      0.4637351299405887, 0.1937168161297741, 0.0152585875411362,
     -0.2127685562496920, 0.0000001541352498,-0.4598477484309377,
      0.9140522659175908, 0.2452292679512662, 0.6249913885040383,
      0.2300338378809035,-0.2299078312098563, 0.4446830815498973,
      0.8530185322948665, 0.4885148451477070, 0.0381977091707050,
      0.2147124011397673, 0.2299708345453799, 0.0019436907548255,
      0.2308957195928816, 0.4579979783362081, 0.0324605575663244,
     -0.1955665862245038, 0.4274811115247091,-0.0028685758023272,
     -0.2318206046403833, 0.6555082553155372, 0.2127688645204655,
      0.2471728045705681, 0.1946417011770021, 0.6860251221267625,
      0.4589228633837098, 0.2604877013568789, 0.0496625275912389,
     -0.1783646161993155,-0.0333854426135524, 0.0172021241604381,
      0.0191456607800137,-0.2260834530360027, 0.4102791414995209,
     -0.0152582792703628, 0.4284059965722108, 0.4407960083110198,
      0.8835353991060917, 0.1994539677341547, 0.2662248529612594,
      0.4751999483613963, 0.4427395449305955,-0.0037934608495551,
      0.6383062852903491, 0.4637351299405887, 0.1937168161297741,
      0.6564331403627652, 0.0152585875411362, 0.1774397311520876,
     -0.2127685562496920, 0.0000001541352498,-0.4598477484309377,
      0.9140522659175908, 0.2452292679512662, 0.6249913885040383,
      0.4446830815498973, 0.6869500071742641, 0.8530185322948665,
      0.4885148451477070, 0.2251585679885010, 0.2299708345453799,
      0.2308957195928816, 0.0019436907548255, 0.4579979783362081,
     -0.0028685758023272, 0.0324605575663244,-0.1955665862245038,
      0.1946417011770021, 0.4274811115247091, 0.4589228633837098,
     -0.0333854426135524,-0.2318206046403833, 0.6555082553155372,
      0.2127688645204655, 0.2471728045705681, 0.4284059965722108,
      0.6860251221267625, 0.2604877013568789, 0.0496625275912389,
     -0.1783646161993155, 0.0172021241604381, 0.6564331403627652,
      0.0191456607800137,-0.2260834530360027, 0.1774397311520876,
      0.4102791414995209,-0.0152582792703628, 0.6869500071742641,
      0.4407960083110198, 0.2251585679885010, 0.8835353991060917,
      0.1994539677341547, 0.4226688449678302, 0.2662248529612594,
      0.4751999483613963, 0.4427395449305955,-0.0037934608495551,
      0.2118436712021903, 0.6383062852903491,-0.0505874126387406,
     -0.2614125864043805, 0.4637351299405887, 0.0200705458272416,
      0.1937168161297741, 0.0143333942228611,-0.0181270092079398 );

var
      v : array[1..3] of double;
      t,x,cx,sx : double;
      iv,n : integer;

begin
      t:=tjd-2451545.0;
      for iv:=1 to 3 do begin
         v[iv]:=0;
         for n:=n1[iv] to n2[iv] do begin
            x:=f[n]*t;
            cx:=cos(x);
            sx:=sin(x);
            v[iv]:=v[iv]+c[n]*cx+s[n]*sx;
         end;
         v[iv]:=v[iv]/1e10;
         Pr^[iv-1]:=v[iv];
      end;
end;

end.
