  var
    xLen: single;       //horizontal length in pixels
    t: single;          //initial horizontal position in [0..1]
    pos: record
           texPos: TPointF;    //texture start position
           zPos: single;       //depth start position
         {$IFDEF PARAM_USESHADER}
           pos3D, normal3D: TPoint3D;
         {$endif}
         end;
    step: record
           texStep: TPointF;   //texture step
           zStep: single;      //depth step
         {$IFDEF PARAM_USESHADER}
           pos3DStep, normal3DStep: TPoint3D;
         {$endif}
         end;

    texVect: TPointF;   //texture vector between start and end of line
    zLen: single;       //depth difference
  {$IFDEF PARAM_USESHADER}
    tempVect3D: TPoint3D;
  {$ENDIF}

    //loop variables
    pdest: PBGRAPixel;
    i: LongInt;

  {$IFDEF PARAM_USELIGHTING}
    light,lightStep,lightDiff,lightAcc,lightMod: word;
    lightLen: integer;

    procedure NextLight; inline;
    begin
      inc(light,lightStep);
      inc(lightAcc,lightDiff);
      if lightAcc >= lightMod then
      begin
        dec(lightAcc,lightMod);
        inc(light);
      end;
    end;
  {$ENDIF}

  begin
    xLen := info2.interX - info1.interX;
    t := ((ix1+0.5)-info1.interX)/xLen;

    texVect := info2.texCoordDivByZ-info1.texCoordDivByZ;
    pos.texPos := info1.texCoordDivByZ + texVect*t;
    step.texStep := texVect*(1/xLen);
    zLen := info2.coordInvZ-info1.coordInvZ;
    pos.zPos := info1.coordInvZ+t*zLen;
    step.zStep := zLen/xLen;

  {$IFDEF PARAM_USESHADER}
    tempVect3D := info2.Position3D - info1.Position3D;
    pos.pos3D := info1.Position3D + tempVect3D*t;
    step.pos3DStep := tempVect3D*(1/xlen);

    tempVect3D := info2.Normal3D - info1.Normal3D;
    pos.normal3D := info1.Normal3D + tempVect3D*t;
    step.normal3DStep := tempVect3D*(1/xlen);
  {$endif}

    pdest := bmp.ScanLine[yb]+ix1;

  {$IFDEF PARAM_USELIGHTING}
    if ix2 = ix1 then
    begin
      light := (info1.lightness+info2.lightness) div 2;
      lightStep := 0;
      lightDiff := 0;
      lightMod := 1;
    end
    else
    begin
      light := info1.lightness;
      lightLen := info2.lightness-info1.lightness;
      lightStep := lightLen div (ix2-ix1);
      lightMod := ix2-ix1;
      lightDiff := lightLen - lightStep*(ix2-ix1);
    end;
    lightAcc := lightDiff div 2;
  {$ENDIF}

    if WithInterpolation then
    begin
      for i := ix1 to ix2 do
      begin
        DrawPixelInlineWithAlphaCheck(pdest,
          {$IFDEF PARAM_USESHADER} ShaderFunction(
            pos.pos3D*(1/pos.zPos),pos.normal3D*(1/pos.zPos),
          {$ENDIF}
          {$IFDEF PARAM_USELIGHTING} ApplyLightnessFast( {$ENDIF}
            {$IFDEF PARAM_USESOLIDCOLOR}
              solidColor
            {$ELSE}
              scanAtFunc(pos.texPos.x/pos.zPos,pos.texPos.y/pos.zPos)
            {$ENDIF}
          {$IFDEF PARAM_USELIGHTING} ,light) {$ENDIF}
          {$IFDEF PARAM_USESHADER} ) {$ENDIF}
          );
        pos.texPos += step.texStep;
        pos.zPos += step.zStep;
        {$IFDEF PARAM_USESHADER}
          pos.pos3D += step.pos3DStep;
          pos.normal3D += step.normal3DStep;
        {$ENDIF}
        {$IFDEF PARAM_USELIGHTING}
          NextLight;
        {$ENDIF}
        inc(pdest);
      end;
    end else
    begin
      for i := ix1 to ix2 do
      begin
        DrawPixelInlineWithAlphaCheck(pdest,
          {$IFDEF PARAM_USESHADER} ShaderFunction(
            pos.pos3D*(1/pos.zPos),pos.normal3D*(1/pos.zPos),
          {$ENDIF}
          {$IFDEF PARAM_USELIGHTING} ApplyLightnessFast( {$ENDIF}
            {$IFDEF PARAM_USESOLIDCOLOR}
              solidColor
            {$ELSE}
              scanAtFunc(round(pos.texPos.x/pos.zPos),round(pos.texPos.y/pos.zPos))
            {$ENDIF}
          {$IFDEF PARAM_USELIGHTING} ,light) {$ENDIF}
          {$IFDEF PARAM_USESHADER} ) {$ENDIF}
          );
        pos.texPos += step.texStep;
        pos.zPos += step.zStep;
        {$IFDEF PARAM_USESHADER}
          pos.pos3D += step.pos3DStep;
          pos.normal3D += step.normal3DStep;
        {$ENDIF}
        {$IFDEF PARAM_USELIGHTING}
          NextLight;
        {$ENDIF}
        inc(pdest);
      end;
    end;
  end;
{$undef PARAM_USELIGHTING}
{$undef PARAM_USESHADER}
{$undef PARAM_USESOLIDCOLOR}
