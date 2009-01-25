Unit MathLib ;

(*---------------------------------------------------------------------*)
(*                                                                     *)
(*   Fonctions mathematique utile                                      *)
(*                                                                     *)
(*   Version 1.1                   6 mai 1991                          *)
(*   Version 2                     2 dec 1997                          *)
(*                                                                     *)
(*   Auteur :  Patrick Chevalley                                       *)
(*             Societe Astronomique de Geneve                          *)
(*                                                                     *)
(*---------------------------------------------------------------------*)

Interface

type Float = double ;
     ShortFloat = single ;

CONST DR : Float = 1.74532925199433e-2 ;

Function  Log(x:Float):Float;
          (*
             logaritme decimal de x
          *)
Function  Tan(x:Float):Float;
          (*
             tangente de x
          *)
Function  ATan2(x,y:Float):Float;      (* arctan ( x/y )        *)
          (*
             arc tangente de x/y dans le bon quadrant
          *)
Function  ArcCos(x:Float):Float;
          (*
             arc cosinus de x
          *)
Function  ArcSin(x:Float):Float;
          (*
             arc sinus de x
          *)
Function  Rmod(x,y:Float):Float;
          (*
             x modulo y pour toute valeur reel
          *)
Function  S2D(x:Float):Float ;
          (*
             conversion sexagecimal => decimal ( DD.MMSSss => DD.dddddd )
          *)
Function  D2S(x:Float):Float;
          (*
             conversion decimal => sexagecimal ( DD.dddddd => DD.MMSSss )
          *)
Function  Sgn(x:Float):Float;
          (*
             signe de x   ( +1 si x>=0  , -1 si x<0 )
          *)
function Max(x1,x2 :Float ) :Float ;
          (*
             Maxima de x1 et x2
          *)
function Min(x1,x2 :Float ) :Float ;
          (*
             Minima de x1 et x2
          *)


Implementation

function  log(x:Float):Float;
  BEGIN
    log := ln(x)/2.3025850929940457;
 end ;

function tan(x:Float):Float;
 BEGIN
  tan := sin(x)/cos(x);
 END   ;

function  atan2(x,y:Float):Float;      (* arctan ( x/y )        *)
 VAR sgn :Float;
 BEGIN
      sgn := 1.0;
      IF x<0.0 THEN
       begin
        sgn:=-1.0 ;
        x := -x ;
      END ;
      IF (y=0.0) OR (ABS(x/y)>1.0E30) THEN
                 atan2:=sgn * Pi/2.0
         else IF (y<0.0) AND (ABS(x/y)<1.0E-30) THEN
                   atan2:=sgn *Pi
           else IF (y>0.0) THEN
                      atan2:=sgn * arctan(ABS(x/y))
                ELSE
                      atan2:=sgn * ( Pi - arctan(ABS(x/y)) );
 END;

function  arccos(x:Float):Float;
 BEGIN
   if x=1 then arccos := 0
          else if x=-1 then arccos:=Pi
              else arccos:= -arctan(x/sqrt(-x*x+1.0))+Pi/2.0;
 END  ;

function arcsin(x:Float):Float;
 BEGIN
   if x=1 then arcsin := Pi/2.0
          else if x=-1 then arcsin:=-Pi/2.0
                 else arcsin := arctan(x/sqrt(-x*x+1.0)) ;
 END  ;

function  Rmod(x,y:Float):Float;
BEGIN
    Rmod := x - Int(x/y) * y ;
END  ;

function S2D(x:Float):Float;
 VAR dd,min1,min,sec:Float;
  BEGIN
    dd:=Int(x) ;
    min1:=frac(x)*100.000 ;
    min:=Int(min1+sgn(min1)*1e-2);
    sec:=(min1-min)*100.000 ;
    S2D := dd + (min/60.0) + (sec/3600.0) ;
  END  ;

function D2S(x:Float):Float;
 VAR dd,min1,min,sec:Float;
 BEGIN
    dd:=Int(x);
    min1:=frac(x)*60.0;
    min:=Int(min1+sgn(min1)*1e-2);
    sec:=(min1-min)*60.0;
    D2S:= dd + min/100.0 + sec/10000.0;
 END  ;

Function sgn(x:Float):Float ;
begin
    if x<0 then
            sgn:= -1
       else
            sgn:=  1 ;
end ;

function Max(x1,x2 :Float ) :Float ;
begin
if x1>x2 then max:=x1
         else max:=x2 ;
end ;

function Min(x1,x2 :Float ) :Float ;
begin
if x1<x2 then min:=x1
         else min:=x2 ;
end ;

end.
