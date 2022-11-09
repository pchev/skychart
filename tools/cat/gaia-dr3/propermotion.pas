unit propermotion;
{$mode objfpc}{$H+}
interface

uses Math, SysUtils;

type
  coordvector = array[1..3] of double;

const
  km_au = 149597870.691;
  rad2deg = 180 / pi;
  deg2rad = pi / 180;
  pi2=2*pi;
  secarc = deg2rad / 3600;
  vfr = (365.25 * 86400.0 / km_au) * secarc;

//propermotion(rec.ra, rec.Dec, dyear, rec.star.pmra, rec.star.pmdec,
//((abs(dyear)>50)and rec.star.valid[vsPx] and(rec.star.px>0)and(rec.star.px<0.8) and (trim(rec.options.flabel[26]) = 'RV')),
//rec.star.px, rec.num[1], distfact);
procedure ProperMotion(var r0, d0: double; t, pr, pd: double; fullmotion: boolean; px, rv: double; out distfact:double);
  
implementation   
  
function Rmod(x, y: double): double;
begin
  Rmod := x - Int(x / y) * y;
end;

procedure sofa_S2C(theta, phi: double; var c: coordvector);
// Convert spherical coordinates to Cartesian.
// THETA    d         longitude angle (radians)
// PHI      d         latitude angle (radians)
var
  sa, ca, sd, cd: extended;
begin
  sincos(theta, sa, ca);
  sincos(phi, sd, cd);
  c[1] := ca * cd;
  c[2] := sa * cd;
  c[3] := sd;
end;

procedure sofa_c2s(p: coordvector; var theta, phi: double);
// P-vector to spherical coordinates.
// THETA    d         longitude angle (radians)
// PHI      d         latitude angle (radians)
var
  x, y, z, d2: double;
begin
  X := P[1];
  Y := P[2];
  Z := P[3];
  D2 := X * X + Y * Y;
  if (D2 = 0) then
    theta := 0
  else
    theta := arctan2(Y, X);
  if (Z = 0) then
    phi := 0
  else
    phi := arctan2(Z, SQRT(D2));
end;             

procedure sofa_PM(p: coordvector; var r: double);
// Modulus of p-vector.
var
  i: integer;
  w, c: double;
begin
  W := 0;
  for i := 1 to 3 do
  begin
    C := P[I];
    W := W + C * C;
  end;
  R := SQRT(W);
end;                

procedure ProperMotion(var r0, d0: double; t, pr, pd: double; fullmotion: boolean; px, rv: double; out distfact:double);
var
  w: extended;
  cr0, sr0, cd0, sd0: extended;
  i: integer;
  p, em: coordvector;
begin
  if fullmotion then
  begin
    // "communicated by Patrick Wallace, RAL Space, UK"
    sincos(r0, sr0, cr0);
    sincos(d0, sd0, cd0);
    pr := pr / cd0;
    sofa_S2C(r0, d0, p);
    w := vfr * rv * px;
    em[1] := -pr * p[2] - pd * cr0 * sd0 + w * p[1];
    em[2] := pr * p[1] - pd * sr0 * sd0 + w * p[2];
    em[3] := pd * cd0 + w * p[3];
    for i := 1 to 3 do
      p[i] := p[i] + t * em[i];
    sofa_PM(p,distfact);
    sofa_C2S(p, r0, d0);
  end
  else
  begin
    r0 := r0 + (pr / cos(d0)) * t;
    d0 := d0 + (pd) * t;
    distfact:=1.0;
  end;
  r0 := rmod(r0 + pi2, pi2);
end;
        
end.
