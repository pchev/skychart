var
  //Light source normal.
  Lx,Ly,Lz: double;
  //Light source position.
  dx,dy,dz: integer;
  //Vector H is the unit normal to the hypothetical surface oriented
  //halfway between the light direction vector (L) and the viewing vector (V).
  Hx,Hy,Hz: double;

  procedure CalculateLNandNnH( x,y: integer; z: double;
                        xn,yn,zn: double; out LdotN, dist, NnH: double); inline;
  var
    NH: Double;
  begin
    LdotN := xn*Lx + yn*Ly + zn*Lz;
    dist := sqrt((dx - x)*(dx - x) + (dy - y)*(dy - y) + (dz - z)*(dz - z));

    if LdotN > 0 then
    begin
      NH := Hx*xn + Hy*yn + Hz*zn;
      if NH < 0 then
      begin
        NH := 0;
        NnH := 0;
      end else
        NnH := exp(SpecularIndex*ln(NH));
    end else
    begin
      NH := 0;
      NnH := 0;
    end;
  end;

var
  Iw, Ic: integer; // Iw: specular intensity, Ic: ambient+diffuse intensity
  x,y : integer;   // Coordinates of point in height map.
  z, xn, yn, zn, LdotN, NnH,
  dist, distfactor, diffuseterm, specularterm: double;
  eLight: TExpandedPixel;
  mc,mcLeft,mcRight,mcTop,mcBottom: TBGRAPixel; ///map values
  v1x,v1y,v1z,v2x,v2y,v2z: single;

  minx,miny,maxx,maxy: integer;
  pmap: PBGRAPixel;
  pdest: PBGRAPixel;

begin
  if ofsX >= dest.Width then exit;
  if ofsY >= dest.Height then exit;
  if ofsX <= -map.Width then exit;
  if ofsY <= -map.Height then exit;
  if (map.width = 0) or (map.Height = 0) then exit;

  minx := 0;
  miny := 0;
  maxx := map.Width-1;
  maxy := map.Height-1;
  if ofsX < 0 then minx := -ofsX;
  if ofsY < 0 then miny := -ofsY;
  if OfsX+maxx > dest.width-1 then maxx := dest.width-1-ofsX;
  if OfsY+maxy > dest.height-1 then maxy := dest.height-1-ofsY;

  eLight := GammaExpansion(LightColor);
  Init;

  //light origin
  dx := LightPosition.X-ofsX;
  dy := LightPosition.Y-ofsY;
  dz := LightPositionZ;

  //surface vectors
  v1x := 1;
  v1y := 0;

  v2x := 0;
  v2y := 1;

  dist := 0;
  LdotN := 0;
  NnH := 0;

  for y := miny to maxy do
  begin
    //read map values
    pmap := map.ScanLine[y]+minx;
    mc := BGRAPixelTransparent;
    mcRight := pmap^;
    pdest := dest.ScanLine[y+ofsY]+ofsX+minx;
    for x := minx to maxx do
    begin
      mcLeft := mc;
      mc := mcRight;
      inc(pmap);
      if x < map.width-1 then
        mcRight := pmap^ else
        mcRight := BGRAPixelTransparent;

      //compute surface vectors
      if mc.alpha <> 0 then
      begin
        mcTop := map.GetPixel(x,y-1);
        mcBottom := map.GetPixel(x,y+1);
        z := MapHeight(mc)*mapAltitude;
        if mcLeft.alpha = 0 then
        begin
          if mcRight.alpha = 0 then
            v1z := 0
          else
            v1z := (MapHeight(mcRight)-MapHeight(mc))*mapAltitude*2;
        end else
        begin
          if mcRight.alpha = 0 then
            v1z := (MapHeight(mc)-MapHeight(mcLeft))*mapAltitude*2
          else
            v1z := (MapHeight(mcRight)-MapHeight(mcLeft))*mapAltitude;
        end;
        if mcTop.alpha = 0 then
        begin
          if mcBottom.alpha = 0 then
            v2z := 0
          else
            v2z := (MapHeight(mcBottom)-MapHeight(mc))*mapAltitude*2;
        end else
        begin
          if mcBottom.alpha = 0 then
            v2z := (MapHeight(mc)-MapHeight(mcTop))*mapAltitude*2
          else
            v2z := (MapHeight(mcBottom)-MapHeight(mcTop))*mapAltitude;
        end;

        //compute light vector
        Lx := dx-x*LightDestFactor;
        Ly := dy-y*LightDestFactor;
        Lz := dz-z*LightDestFactor;
        normalize(Lx,Ly,Lz);

        //compute bisector of angle between light and observer
        Hx := Lx + 0;
        Hy := Ly + 0;
        Hz := Lz + 1;
        normalize(Hx,Hy,Hz);

        // compute normal vector to the surface
        vectproduct(v1x,v1y,v1z,v2x,v2y,v2z,xn,yn,zn);
        normalize(xn,yn,zn);
        CalculateLNandNnH(x, y, z, xn, yn, zn, LdotN, dist, NnH);
        distfactor := LightSourceIntensity / (dist*LightSourceDistanceFactor + LightSourceDistanceTerm);
        if (LdotN <= 0) then
        begin
          //Point is not illuminated by light source.
          //Use only ambient component and negative diffuse for contrast
          diffuseterm := distfactor * NegativeDiffusionFactor * LdotN;
          Ic := round((AmbientFactor + diffuseterm)*256);
          Iw := 0;
        end else
        begin
          diffuseterm := distfactor * DiffusionFactor * LdotN;
          specularterm := distfactor * SpecularFactor * NnH;
          Ic := round((AmbientFactor + diffuseterm)*256);
          Iw := round(specularterm*256);
        end;
        //intensity bounds (0..256)
        If Ic < 0 then Ic := 0;
        If Ic > 256 then
        begin
          If DiffuseSaturation then Iw := Iw+(Ic-256);
          Ic := 256;
        end;
        if Iw > 256 then Iw := 256;
        Ic := Ic*(256-Iw) shr 8;

        DrawPixelInline(pdest, ComputePixel(x,y,eLight,Ic,Iw,mc.alpha));
      end;
      inc(pdest); //go to next pixel
    end;
  end;
end;
