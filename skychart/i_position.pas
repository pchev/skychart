
procedure Tf_position.FormShow(Sender: TObject);
begin
ra.value:=rad2deg*cfgsc.racentre/15;
de.value:=rad2deg*cfgsc.decentre;
fov.value:=rad2deg*cfgsc.fov;
rot.value:=rad2deg*cfgsc.theta;
Equinox.Caption:='Equatorial coordinates, equinox: '+cfgsc.EquinoxName;
case cfgsc.projpole of
    Equat : begin
            Panel1.visible:=false;
            end;
    AltAz : begin
            Panel1.visible:=true;
            coord.Caption:='Alt/AZ Coord. ';
            coord1.caption:='Az';
            coord2.caption:='Alt';
            end;
    Gal :   begin
            Panel1.visible:=true;
            coord.Caption:='Galactic Coord.';
            coord1.caption:='LII';
            coord2.caption:='BII';
            end;
    Ecl :   begin
            Panel1.visible:=true;
            coord.Caption:='Ecliptic Coord. ';
            coord1.caption:='L';
            coord2.caption:='B';
            end;
  else Panel1.visible:=false;
end;
EqChange(self);
end;

procedure Tf_position.EqChange(Sender: TObject);
var a,h: double;
begin
if lock then exit;
lock:=true;
case cfgsc.projpole of
  AltAz : begin
          eq2hz(cfgsc.CurST-deg2rad*15*ra.value,deg2rad*de.value,a,h,cfgsc);
          if AzNorth then a:=Rmod(a+pi,pi2);
          end;
  Gal   : begin
          eq2gal(deg2rad*15*ra.value,deg2rad*de.value,a,h,cfgsc);
          end;
  Ecl   : begin
          eq2ecl(deg2rad*15*ra.value,deg2rad*de.value,cfgsc.e,a,h);
          end;
end;
long.value:=rad2deg*rmod(a+pi2,pi2);
lat.value:=h*rad2deg;
application.ProcessMessages;
lock:=false;
end;

procedure Tf_position.CoordChange(Sender: TObject);
var a,r,d: double;
begin
if lock then exit;
lock:=true;
case cfgsc.projpole of
  AltAz : begin
          a:=deg2rad*long.value;
          if AzNorth then a:=rmod(a+pi,pi2);
          Hz2Eq(a,deg2rad*lat.value,r,d,cfgsc);
          r:=cfgsc.CurST-r;
          end;
  Gal   : begin
          Gal2Eq(deg2rad*long.value,deg2rad*lat.value,r,d,cfgsc);
          end;
  Ecl   : begin
          Ecl2Eq(deg2rad*long.value,deg2rad*lat.value,cfgsc.e,r,d);
          end;
end;
ra.value:=rmod(r+pi2,pi2)*rad2deg/15;
de.value:=rad2deg*d;
application.ProcessMessages;
lock:=false;
end;
