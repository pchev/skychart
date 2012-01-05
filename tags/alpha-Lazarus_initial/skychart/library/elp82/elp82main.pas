unit elp82main;

interface

uses sysutils,
     elp;

Procedure ELP82B(tjj,prec : double; var v : array of double; var ierr : integer);

implementation

function  Rmod(x,y:Double):Double;
BEGIN
    Rmod := x - Int(x/y) * y ;
END  ;

Procedure ELP82B(tjj,prec : double; var v : array of double; var ierr : integer);
{      subroutine ELP82B (tjj,prec,nulog,r,ierr)
*-----------------------------------------------------------------------

          Translation pour Delphi : P. Chevalley 31 mars 1998

*
*     Reference : Bureau des Logitudes - MCTJCGF9502.
*
*     Object :
*     Computation of geocentric lunar coordinates from ELP 2000-82 and
*     ELP2000-85 theories (M. Chapront-Touze and J. Chapront).
*     Constants fitted to JPL's ephemerides DE200/LE200.
*
*     Input :
*     tjj    julian date TDB (real double precision).
*     prec   truncation level in radian (real double precision).
*     nulog  number of logical unit for reading the files (integer).
*
*     Output :
*     r(3)   table of rectangular coordinates (real double precision).
*            reference frame : mean dynamical ecliptic and inertial
*            equinox of J2000 (JD 2451545.0).
*            r(1) : X (kilometer).
*            r(2) : Y (kilometer).
*            r(3) : Z (kilometer).
*     ierr   error index (integer).
*            ierr=0 : no error.
*            ierr=1 : error in elp 2000-82 files (end of file).
*            ierr=2 : error in elp 2000-82 files (reading error).
*
*     Remarks :
*     36 data files include the series related to various components of
*     the theory for the 3 spherical coordinates : longitude, latitude
*     and distance.
*     Files, series, constants and coordinate systems are described in
*     the notice LUNAR SOLUTION ELP 2000-82B.
*
*-----------------------------------------------------------------------
*
*     Declarations.
*
*      implicit double precision (a-h,o-z)
}

var
     w : array[1..3,1..5] of double;
     eart,peri,t : array[1..5] of double;
     p : array[1..8,1..2] of double;
     del : array[1..4,1..5] of double;
     zeta: array[1..2] of double;
     r,pre : array[1..3] of double;
     i,ific,iv : integer;
     cpi,cpi2,pis2,rad,deg,c1,c2,ath,a0,am,alfa,dtasm,preces : double;
     delnu,dele,delg,delnp,delep : double;
     p1,p2,p3,p4,p5,q1,q2,q3,q4,q5,tgv,y : double;
     x1,x2,x3,pw,qw,ra,pwqw,pw2,qw2 : double;
     fin : Boolean;

Procedure MainProblem;
var i,k,l,m : integer;
    x : double;
    lin : MainBin;
begin
{*
*     Main problem.
*}
iv := ((ific-1) mod 3)+1;
case ific of
     1 : m:= length(main_1);
     2 : m:= length(main_2);
     3 : m:= length(main_3);
else m:=0;
end;
l:=0;
repeat
      inc(l);
      case ific of
           1 : lin:= main_1[l];
           2 : lin:= main_2[l];
           3 : lin:= main_3[l];
      end;
      x:=lin.coef[1];
      if abs(x) < pre[iv] then continue;
      tgv:=lin.coef[2]+dtasm*lin.coef[6];
      if ific=3 then lin.coef[1]:=lin.coef[1]-2.0*lin.coef[1]*delnu/3.0;
      x:=lin.coef[1]+tgv*(delnp-am*delnu)+lin.coef[3]*delg+lin.coef[4]*dele+lin.coef[5]*delep;
      y:=0.0;
      for k:=1 to 5 do begin
        for i:=1 to 4 do begin
          y:=y+lin.ilu[i]*del[i,k]*t[k];
        end;
      end;
      if iv=3 then y:=y+pis2;
      y:=rmod(y,cpi2);
      r[iv]:=r[iv]+x*sin(y);
until l=m;
end;

Procedure FiguresTides;
var i,k,l,m : integer;
    lin : FigurBin;
begin
{*
*     Figures - Tides - Relativity - Solar eccentricity.
*}
iv:=((ific-1) mod 3)+1;
case ific of
     4 : m:= length(figur_4);
     5 : m:= length(figur_5);
     6 : m:= length(figur_6);
     7 : m:= length(figur_7);
     8 : m:= length(figur_8);
     9 : m:= length(figur_9);
     22 : m:= length(figur_22);
     23 : m:= length(figur_23);
     24 : m:= length(figur_24);
     25 : m:= length(figur_25);
     26 : m:= length(figur_26);
     27 : m:= length(figur_27);
     28 : m:= length(figur_28);
     29 : m:= length(figur_29);
     30 : m:= length(figur_30);
     31 : m:= length(figur_31);
     32 : m:= length(figur_32);
     33 : m:= length(figur_33);
     34 : m:= length(figur_34);
     35 : m:= length(figur_35);
     36 : m:= length(figur_36);
else m:=0;
end;
l:=0;
repeat
      inc(l);
      case ific of
           4 : lin:=figur_4[l];
           5 : lin:=figur_5[l];
           6 : lin:=figur_6[l];
           7 : lin:=figur_7[l];
           8 : lin:=figur_8[l];
           9 : lin:=figur_9[l];
           22 : lin:=figur_22[l];
           23 : lin:=figur_23[l];
           24 : lin:=figur_24[l];
           25 : lin:=figur_25[l];
           26 : lin:=figur_26[l];
           27 : lin:=figur_27[l];
           28 : lin:=figur_28[l];
           29 : lin:=figur_29[l];
           30 : lin:=figur_30[l];
           31 : lin:=figur_31[l];
           32 : lin:=figur_32[l];
           33 : lin:=figur_33[l];
           34 : lin:=figur_34[l];
           35 : lin:=figur_35[l];
           36 : lin:=figur_36[l];
      end;
      if abs(lin.x)<pre[iv] then continue;
      if (ific>=7) and (ific<=9) then  lin.x:=lin.x*t[2];
      if (ific>=25) and (ific<=27) then lin.x:=lin.x*t[2];
      if (ific>=34) and (ific<=36) then lin.x:=lin.x*t[3];
      y:=lin.pha*deg;
      for k:=1 to 2 do begin
        y:=y+lin.iz*zeta[k]*t[k];
        for i:=1 to 4 do begin
          y:=y+lin.ilu[i]*del[i,k]*t[k];
        end;
      end;
      y:=rmod(y,cpi2);
      r[iv]:=r[iv]+lin.x*sin(y);
until l=m;
end;

Procedure PlanetaryPerturbations;
var i,k,l,m : integer;
    lin : PlanPerBin;
begin
{*
*     Planetary perturbations.
*}
iv:=((ific-1) mod 3)+1;
case ific of
     10 : m:= length(planper_10);
     11 : m:= length(planper_11);
     12 : m:= length(planper_12);
     13 : m:= length(planper_13);
     14 : m:= length(planper_14);
     15 : m:= length(planper_15);
     16 : m:= length(planper_16);
     17 : m:= length(planper_17);
     18 : m:= length(planper_18);
     19 : m:= length(planper_19);
     20 : m:= length(planper_20);
     21 : m:= length(planper_21);
else m:=0;
end;
l:=0;
repeat
      inc(l);
      case ific of
           10 : lin:=planper_10[l];
           11 : lin:=planper_11[l];
           12 : lin:=planper_12[l];
           13 : lin:=planper_13[l];
           14 : lin:=planper_14[l];
           15 : lin:=planper_15[l];
           16 : lin:=planper_16[l];
           17 : lin:=planper_17[l];
           18 : lin:=planper_18[l];
           19 : lin:=planper_19[l];
           20 : lin:=planper_20[l];
           21 : lin:=planper_21[l];
      end;
      if abs(lin.x)<pre[iv] then continue;
      if (ific>=13) and (ific<=15) then lin.x:=lin.x*t[2];
      if (ific>=19) and (ific<=21) then lin.x:=lin.x*t[2];
      y:=lin.pha*deg;
      if (ific<16) then begin
        for k:=1 to 2 do begin
          y:=y+(lin.ipla[9]*del[1,k]+lin.ipla[10]*del[3,k]+lin.ipla[11]*del[4,k])*t[k];
          for i:=1 to 8 do begin
            y:=y+lin.ipla[i]*p[i,k]*t[k];
          end;
        end;
      end
      else begin
        for k:=1 to 2 do begin
          for i:=1 to 4 do begin
            y:=y+lin.ipla[i+7]*del[i,k]*t[k];
          end;
          for i:=1 to 7 do begin
            y:=y+lin.ipla[i]*p[i,k]*t[k];
          end;
        end;
      end;
      y:=rmod(y,cpi2);
      r[iv]:=r[iv]+lin.x*sin(y);
until l=m;
end;

begin
{*
*     Initialisation.
*}
      r[1]:=0.0;
      r[2]:=0.0;
      r[3]:=0.0;
         cpi:=3.141592653589793;
         cpi2:=2.0*cpi;
         pis2:=cpi/2.0;
         rad:=648000.0/cpi;
         deg:=cpi/180.0;
         c1:=60.0;
         c2:=3600.0;
         ath:=384747.9806743165;
         a0:=384747.9806448954;
         am:=0.074801329518;
         alfa:=0.002571881335;
         dtasm:=2.0*alfa/(3.0*am);
{*
*     Lunar arguments.
*}
         w[1,1]:=(218+18/c1+59.95571/c2)*deg;
         w[2,1]:=(83+21/c1+11.67475/c2)*deg;
         w[3,1]:=(125+2/c1+40.39816/c2)*deg;
         eart[1]:=(100+27/c1+59.22059/c2)*deg;
         peri[1]:=(102+56/c1+14.42753/c2)*deg;
         w[1,2]:=1732559343.73604/rad;
         w[2,2]:=14643420.2632/rad;
         w[3,2]:=-6967919.3622/rad;
         eart[2]:=129597742.2758/rad;
         peri[2]:=1161.2283/rad;
         w[1,3]:=-5.8883/rad;
         w[2,3]:=-38.2776/rad;
         w[3,3]:=6.3622/rad;
         eart[3]:=-0.0202/rad;
         peri[3]:=0.5327/rad;
         w[1,4]:=0.6604e-2/rad;
         w[2,4]:=-0.45047e-1/rad;
         w[3,4]:=0.7625e-2/rad;
         eart[4]:=0.9e-5/rad;
         peri[4]:=-0.138e-3/rad;
         w[1,5]:=-0.3169e-4/rad;
         w[2,5]:=0.21301e-3/rad;
         w[3,5]:=-0.3586e-4/rad;
         eart[5]:=0.15e-6/rad;
         peri[5]:=0.0;
{*
*     Planetary arguments.
*}
         preces:=5029.0966/rad;
         p[1,1]:=(252+15/c1+3.25986/c2)*deg;
         p[2,1]:=(181+58/c1+47.28305/c2)*deg;
         p[3,1]:=eart[1];
         p[4,1]:=(355+25/c1+59.78866/c2)*deg;
         p[5,1]:=(34+21/c1+5.34212/c2)*deg;
         p[6,1]:=(50+4/c1+38.89694/c2)*deg;
         p[7,1]:=(314+3/c1+18.01841/c2)*deg;
         p[8,1]:=(304+20/c1+55.19575/c2)*deg;
         p[1,2]:=538101628.68898/rad;
         p[2,2]:=210664136.43355/rad;
         p[3,2]:=eart[2];
         p[4,2]:=68905077.59284/rad;
         p[5,2]:=10925660.42861/rad;
         p[6,2]:=4399609.65932/rad;
         p[7,2]:=1542481.19393/rad;
         p[8,2]:=786550.32074/rad;
{*
*     Corrections of the constants (fit to DE200/LE200).
*}
         delnu:=+0.55604/rad/w[1,2];
         dele:=+0.01789/rad;
         delg:=-0.08066/rad;
         delnp:=-0.06424/rad/w[1,2];
         delep:=-0.12879/rad;
{*
*     Delaunay's arguments.
*}
         for i:=1 to 5 do begin
            del[1,i]:=w[1,i]-eart[i];
            del[4,i]:=w[1,i]-w[3,i];
            del[3,i]:=w[1,i]-w[2,i];
            del[2,i]:=eart[i]-peri[i];
         end;
         del[1,1]:=del[1,1]+cpi;
         zeta[1]:=w[1,1];
         zeta[2]:=w[1,2]+preces;
{*
*     Precession matrix.
*}
         p1:=0.10180391e-4;
         p2:=0.47020439e-6;
         p3:=-0.5417367e-9;
         p4:=-0.2507948e-11;
         p5:=0.463486e-14;
         q1:=-0.113469002e-3;
         q2:=0.12372674e-6;
         q3:=0.1265417e-8;
         q4:=-0.1371808e-11;
         q5:=-0.320334e-14;

         t[1]:=1.0;

      t[2]:=(tjj-2451545.0)/36525.0;
      t[3]:=t[2]*t[2];
      t[4]:=t[3]*t[2];
      t[5]:=t[4]*t[2];
      pre[1]:=prec*rad;
      pre[2]:=prec*rad;
      pre[3]:=prec*ath;
      ific:=1;
      ierr:=0;
{*
*     Distribution of files.
*}
fin:=false;
repeat
case ific of
      1..3  : MainProblem;
      4..9  : FiguresTides;
     10..21 : PlanetaryPerturbations;
     22..36 : FiguresTides;
     else     fin:=true;
end;
inc(ific);
until fin ;
{*
*     Change of coordinates.
*}
      r[1]:=r[1]/rad+w[1,1]+w[1,2]*t[2]+w[1,3]*t[3]+w[1,4]*t[4]+w[1,5]*t[5];
      r[2]:=r[2]/rad;
      r[3]:=r[3]*a0/ath;
      x1:=r[3]*cos(r[2]);
      x2:=x1*sin(r[1]);
      x1:=x1*cos(r[1]);
      x3:=r[3]*sin(r[2]);
      pw:=(p1+p2*t[2]+p3*t[3]+p4*t[4]+p5*t[5])*t[2];
      qw:=(q1+q2*t[2]+q3*t[3]+q4*t[4]+q5*t[5])*t[2];
      ra:=2.0*sqrt(1-pw*pw-qw*qw);
      pwqw:=2.0*pw*qw;
      pw2:=1-2.0*pw*pw;
      qw2:=1-2.0*qw*qw;
      pw:=pw*ra;
      qw:=qw*ra;
      r[1]:=pw2*x1+pwqw*x2+pw*x3;
      r[2]:=pwqw*x1+qw2*x2-qw*x3;
      r[3]:=-pw*x1+qw*x2+(pw2+qw2-1)*x3;
{
   Equatoriales  coordinates
}
      v[0]:=r[1]+4.37913e-7*r[2]-1.89859e-7*r[3];
      v[1]:=-4.77299e-7*r[1]+0.917482137607*r[2]-0.397776981701*r[3];
      v[2]:=0.397776981701*r[2]+0.917482137607*r[3];
end;

end.
