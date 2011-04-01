unit BGRAPen;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Graphics, BGRABitmapTypes;

var
  SolidPenStyle, DashPenStyle, DotPenStyle, DashDotPenStyle, DashDotDotPenStyle, ClearPenStyle: TBGRAPenStyle;

type
  TBGRAPolyLineOption = (plRoundCapOpen, plCycle);
  TBGRAPolyLineOptions = set of TBGRAPolyLineOption;

procedure BGRAPolyLine(bmp: TBGRACustomBitmap; const linepts: array of TPointF;
     width: single; pencolor: TBGRAPixel; linecap: TPenEndCap; joinstyle: TPenJoinStyle; const penstyle: TBGRAPenStyle;
     options: TBGRAPolyLineOptions; texture: TBGRACustomBitmap= nil);

procedure BGRADrawLineAliased(dest: TBGRACustomBitmap; x1, y1, x2, y2: integer; c: TBGRAPixel; DrawLastPixel: boolean);
procedure BGRADrawLineAntialias(dest: TBGRACustomBitmap; x1, y1, x2, y2: integer;
  c: TBGRAPixel; DrawLastPixel: boolean);
procedure BGRADrawLineAntialias(dest: TBGRACustomBitmap; x1, y1, x2, y2: integer;
  c1, c2: TBGRAPixel; dashLen: integer; DrawLastPixel: boolean);
function GetAlphaJoinFactor(alpha: byte): single;

function CreateBrushTexture(prototype: TBGRACustomBitmap; brushstyle: TBrushStyle; PatternColor, BackgroundColor: TBGRAPixel;
    width: integer = 8; height: integer = 8; penwidth: single = 1): TBGRACustomBitmap;

implementation

uses math, BGRABlend;

procedure BGRAPolyLine(bmp: TBGRACustomBitmap; const linepts: array of TPointF;
  width: single; texture: TBGRACustomBitmap; linecap: TPenEndCap;
  joinstyle: TPenJoinStyle; const penstyle: TBGRAPenStyle;
  options: TBGRAPolyLineOptions);
begin

end;

procedure BGRADrawLineAliased(dest: TBGRACustomBitmap; x1, y1, x2, y2: integer;
  c: TBGRAPixel; DrawLastPixel: boolean);
var
  Y, X: integer;
  DX, DY, SX, SY, E: integer;
begin

  if (Y1 = Y2) and (X1 = X2) then
  begin
    if DrawLastPixel then
      dest.DrawPixel(X1, Y1, c);
    Exit;
  end;

  DX := X2 - X1;
  DY := Y2 - Y1;

  if DX < 0 then
  begin
    SX := -1;
    DX := -DX;
  end
  else
    SX := 1;

  if DY < 0 then
  begin
    SY := -1;
    DY := -DY;
  end
  else
    SY := 1;

  DX := DX shl 1;
  DY := DY shl 1;

  X := X1;
  Y := Y1;
  if DX > DY then
  begin
    E := DY - DX shr 1;

    while X <> X2 do
    begin
      dest.DrawPixel(X, Y, c);
      if E >= 0 then
      begin
        Inc(Y, SY);
        Dec(E, DX);
      end;
      Inc(X, SX);
      Inc(E, DY);
    end;
  end
  else
  begin
    E := DX - DY shr 1;

    while Y <> Y2 do
    begin
      dest.DrawPixel(X, Y, c);
      if E >= 0 then
      begin
        Inc(X, SX);
        Dec(E, DY);
      end;
      Inc(Y, SY);
      Inc(E, DX);
    end;
  end;

  if DrawLastPixel then
    dest.DrawPixel(X2, Y2, c);
end;

procedure BGRADrawLineAntialias(dest: TBGRACustomBitmap; x1, y1, x2, y2: integer;
  c: TBGRAPixel; DrawLastPixel: boolean);
var
  Y, X:  integer;
  DX, DY, SX, SY, E: integer;
  alpha: single;
begin

  if (Y1 = Y2) and (X1 = X2) then
  begin
    if DrawLastPixel then
      dest.DrawPixel(X1, Y1, c);
    Exit;
  end;

  DX := X2 - X1;
  DY := Y2 - Y1;

  if DX < 0 then
  begin
    SX := -1;
    DX := -DX;
  end
  else
    SX := 1;

  if DY < 0 then
  begin
    SY := -1;
    DY := -DY;
  end
  else
    SY := 1;

  DX := DX shl 1;
  DY := DY shl 1;

  X := X1;
  Y := Y1;

  if DX > DY then
  begin
    E := 0;

    while X <> X2 do
    begin
      alpha := 1 - E / DX;
      dest.DrawPixel(X, Y, BGRA(c.red, c.green, c.blue, round(c.alpha * sqrt(alpha))));
      dest.DrawPixel(X, Y + SY, BGRA(c.red, c.green, c.blue,
        round(c.alpha * sqrt(1 - alpha))));
      Inc(E, DY);
      if E >= DX then
      begin
        Inc(Y, SY);
        Dec(E, DX);
      end;
      Inc(X, SX);
    end;
  end
  else
  begin
    E := 0;

    while Y <> Y2 do
    begin
      alpha := 1 - E / DY;
      dest.DrawPixel(X, Y, BGRA(c.red, c.green, c.blue, round(c.alpha * sqrt(alpha))));
      dest.DrawPixel(X + SX, Y, BGRA(c.red, c.green, c.blue,
        round(c.alpha * sqrt(1 - alpha))));
      Inc(E, DX);
      if E >= DY then
      begin
        Inc(X, SX);
        Dec(E, DY);
      end;
      Inc(Y, SY);
    end;
  end;
  if DrawLastPixel then
    dest.DrawPixel(X2, Y2, c);
end;

procedure BGRADrawLineAntialias(dest: TBGRACustomBitmap; x1, y1, x2, y2: integer;
  c1, c2: TBGRAPixel; dashLen: integer; DrawLastPixel: boolean);
var
  Y, X:  integer;
  DX, DY, SX, SY, E: integer;
  alpha: single;
  c:     TBGRAPixel;
  DashPos: integer;
begin

  c := c1;
  DashPos := 0;

  if (Y1 = Y2) and (X1 = X2) then
  begin
    if DrawLastPixel then
      dest.DrawPixel(X1, Y1, c);
    Exit;
  end;

  DX := X2 - X1;
  DY := Y2 - Y1;

  if DX < 0 then
  begin
    SX := -1;
    DX := -DX;
  end
  else
    SX := 1;

  if DY < 0 then
  begin
    SY := -1;
    DY := -DY;
  end
  else
    SY := 1;

  DX := DX shl 1;
  DY := DY shl 1;

  X := X1;
  Y := Y1;

  if DX > DY then
  begin
    E := 0;

    while X <> X2 do
    begin
      alpha := 1 - E / DX;
      dest.DrawPixel(X, Y, BGRA(c.red, c.green, c.blue, round(c.alpha * sqrt(alpha))));
      dest.DrawPixel(X, Y + SY, BGRA(c.red, c.green, c.blue,
        round(c.alpha * sqrt(1 - alpha))));
      Inc(E, DY);
      if E >= DX then
      begin
        Inc(Y, SY);
        Dec(E, DX);
      end;
      Inc(X, SX);

      Inc(DashPos);
      if DashPos = DashLen then
        c := c2
      else
      if DashPos = DashLen + DashLen then
      begin
        c := c1;
        DashPos := 0;
      end;
    end;
  end
  else
  begin
    E := 0;

    while Y <> Y2 do
    begin
      alpha := 1 - E / DY;
      dest.DrawPixel(X, Y, BGRA(c.red, c.green, c.blue, round(c.alpha * sqrt(alpha))));
      dest.DrawPixel(X + SX, Y, BGRA(c.red, c.green, c.blue,
        round(c.alpha * sqrt(1 - alpha))));
      Inc(E, DX);
      if E >= DY then
      begin
        Inc(X, SX);
        Dec(E, DY);
      end;
      Inc(Y, SY);

      Inc(DashPos);
      if DashPos = DashLen then
        c := c2
      else
      if DashPos = DashLen + DashLen then
      begin
        c := c1;
        DashPos := 0;
      end;
    end;
  end;
  if DrawLastPixel then
    dest.DrawPixel(X2, Y2, c);
end;

function GetAlphaJoinFactor(alpha: byte): single;
var t: single;
begin
  if alpha = 255 then result := 1 else
  begin
    result := (power(20,alpha/255)-1)/19*0.5;
    t := power(alpha/255,40);
    result := result*(1-t)+t*0.82;
  end;
end;

function CreateBrushTexture(prototype: TBGRACustomBitmap; brushstyle: TBrushStyle;
  PatternColor, BackgroundColor: TBGRAPixel; width: integer = 8; height: integer = 8; penwidth: single = 1): TBGRACustomBitmap;
begin
  result := prototype.NewBitmap(width,height);
  if brushstyle <> bsClear then
  begin
    result.Fill(BackgroundColor);
    if brushstyle in[bsDiagCross,bsBDiagonal] then
    begin
      result.DrawLineAntialias(-1,height,width,-1,PatternColor,penwidth);
      result.DrawLineAntialias(-1-penwidth,0+penwidth,0+penwidth,-1-penwidth,PatternColor,penwidth);
      result.DrawLineAntialias(width-1-penwidth,height+penwidth,width+penwidth,height-1-penwidth,PatternColor,penwidth);
    end;
    if brushstyle in[bsDiagCross,bsFDiagonal] then
    begin
      result.DrawLineAntialias(-1,-1,width,height,PatternColor,penwidth);
      result.DrawLineAntialias(width-1-penwidth,-1-penwidth,width+penwidth,0+penwidth,PatternColor,penwidth);
      result.DrawLineAntialias(-1-penwidth,height-1-penwidth,0+penwidth,height+penwidth,PatternColor,penwidth);
    end;
    if brushstyle in[bsHorizontal,bsCross] then
      result.DrawLineAntialias(-1,height div 2,width,height div 2,PatternColor,penwidth);
    if brushstyle in[bsVertical,bsCross] then
      result.DrawLineAntialias(width div 2,-1,width div 2,height,PatternColor,penwidth);
  end;
end;

procedure ApplyPenStyle(const leftPts, rightPts: array of TPointF; const penstyle: TBGRAPenStyle;
    width: single; var posstyle: single; out styledPts: ArrayOfTPointF);
var
  styleIndex :integer;
  remainingDash: single;

  procedure NextStyleIndex;
  begin
    inc(styleIndex);
    if styleIndex = length(penstyle) then
      styleIndex := 0;
    remainingDash += penstyle[styleindex];
  end;

var
  dashStartIndex: integer;
  dashLeftStartPos,dashRightStartPos : TPointF;
  betweenDash: boolean;

  procedure StartDash(index: integer; t: single);
  begin
    dashStartIndex := index;
    dashLeftStartPos.x := leftPts[index].x + (leftPts[index+1].x-leftPts[index].x)*t;
    dashLeftStartPos.y := leftPts[index].y + (leftPts[index+1].y-leftPts[index].y)*t;
    dashRightStartPos.x := rightPts[index].x + (rightPts[index+1].x-rightPts[index].x)*t;
    dashRightStartPos.y := rightPts[index].y + (rightPts[index+1].y-rightPts[index].y)*t;
    betweenDash := false;
  end;

var
  nbStyled: integer;

  procedure AddPt(pt: TPointF);
  begin
    if nbStyled = length(styledPts) then
      setlength(styledPts,nbStyled*2+4);
    styledPts[nbStyled] := pt;
    inc(nbStyled);
  end;

  procedure StartPolygon;
  begin
    if nbStyled > 0 then AddPt(EmptyPointF);
  end;

  procedure EndDash(index: integer; t: single);
  var dashLeftEndPos,dashRightEndPos: TPointF;
    i: Integer;
  begin
    if t=0 then
    begin
      dashLeftEndPos := leftPts[index];
      dashRightEndPos := rightPts[index];
    end else
    begin
      dashLeftEndPos.x := leftPts[index].x + (leftPts[index+1].x-leftPts[index].x)*t;
      dashLeftEndPos.y := leftPts[index].y + (leftPts[index+1].y-leftPts[index].y)*t;
      dashRightEndPos.x := rightPts[index].x + (rightPts[index+1].x-rightPts[index].x)*t;
      dashRightEndPos.y := rightPts[index].y + (rightPts[index+1].y-rightPts[index].y)*t;
    end;
    StartPolygon;
    AddPt(dashLeftStartPos);
    for i := dashStartIndex+1 to index do
      AddPt(leftPts[i]);
    AddPt(dashLeftEndPos);
    AddPt(dashRightEndPos);
    for i := index downto dashStartIndex+1 do
      AddPt(rightPts[i]);
    AddPt(dashRightStartPos);
    betweenDash := true;
  end;

var
  i,nb: integer;
  styleLength: single;
  len,lenDone: single;

begin
  nbStyled := 0;
  styledPts := nil;
  if (length(penstyle) = 1) and (penstyle[0]=0) then exit; //psClear
  if (penstyle = nil) or (length(penstyle)=1) then //psSolid
  begin
    for i := 0 to high(leftPts) do AddPt(leftPts[i]);
    for i := high(rightPts) downto 0 do AddPt(rightPts[i]);
    setlength(styledPts,nbStyled);
    exit;
  end;
  if length(leftPts) <> length(rightPts) then
    raise Exception.Create('Dimension mismatch');
  nb := length(leftPts);
  if length(penstyle) mod 2 <> 0 then
    raise Exception.Create('Pen style must contain an even number of values');
  styleLength := 0;
  styleIndex := -1;
  for i := 0 to high(penstyle) do
    if penstyle[i] <= 0 then
      raise Exception.Create('Invalid pen dash length')
    else
    begin
      styleLength += penstyle[i];
      if styleLength >= posstyle then
      begin
        styleIndex := i;
        remainingDash := styleLength-posstyle;
        break;
      end;
    end;
  if styleIndex = -1 then
  begin
    styleIndex := 0;
    remainingDash := penstyle[0];
  end;

  if styleIndex mod 2 = 0 then
    StartDash(0, 0) else
      betweenDash := true;
  for i := 0 to nb-2 do
  begin
    len := (sqrt(sqr(leftPts[i+1].x-leftPts[i].x) + sqr(leftPts[i+1].y-leftPts[i].y))+
           sqrt(sqr(rightPts[i+1].x-rightPts[i].x) + sqr(rightPts[i+1].y-rightPts[i].y)))/(2*width);
    lenDone := 0;
    while lenDone < len do
    begin
      if len-lenDone < remainingDash then
      begin
        remainingDash -= len-lenDone;
        if remainingDash = 0 then NextStyleIndex;
        lenDone := len;
      end else
      if betweenDash then
      begin
        lenDone += remainingDash;
        StartDash(i, lenDone/len);
        remainingDash := 0;
        NextStyleIndex;
      end else
      begin
        lenDone += remainingDash;
        EndDash(i, lenDone/len);
        remainingDash := 0;
        NextStyleIndex;
      end;
    end;
  end;
  if not betweenDash then
    EndDash(nb-1,0);
  setlength(styledPts,nbStyled);
end;

type
    TLineDef = record
       origin, dir: TPointF;
    end;

function Intersect(ligne1, ligne2: TLineDef): TPointF;
var divFactor: double;
begin
  if ((ligne1.dir.x = ligne2.dir.x) and (ligne1.dir.y = ligne2.dir.y)) or
     ((ligne1.dir.y=0) and (ligne2.dir.y=0)) then
  begin
       result.x := (ligne1.origin.x+ligne2.origin.x)/2;
       result.y := (ligne1.origin.y+ligne2.origin.y)/2;
  end else
  if ligne1.dir.y=0 then
  begin
       result.y := ligne1.origin.y;
       result.x := ligne2.origin.x + (result.y - ligne2.origin.y)
               /ligne2.dir.y*ligne2.dir.x;
  end else
  if ligne2.dir.y=0 then
  begin
       result.y := ligne2.origin.y;
       result.x := ligne1.origin.x + (result.y - ligne1.origin.y)
               /ligne1.dir.y*ligne1.dir.x;
  end else
  begin
       divFactor := ligne1.dir.x/ligne1.dir.y - ligne2.dir.x/ligne2.dir.y;
       if abs(divFactor) < 1e-6 then
       begin
            result.x := (ligne1.origin.x+ligne2.origin.x)/2;
            result.y := (ligne1.origin.y+ligne2.origin.y)/2;
       end else
       begin
         result.y := (ligne2.origin.x - ligne1.origin.x +
                  ligne1.origin.y*ligne1.dir.x/ligne1.dir.y -
                  ligne2.origin.y*ligne2.dir.x/ligne2.dir.y)
                  / divFactor;
         result.x := ligne1.origin.x + (result.y - ligne1.origin.y)
                 /ligne1.dir.y*ligne1.dir.x;
       end;
  end;
end;

procedure BGRAPolyLine(bmp: TBGRACustomBitmap; const linepts: array of TPointF; width: single;
          pencolor: TBGRAPixel; linecap: TPenEndCap; joinstyle: TPenJoinStyle; const penstyle: TBGRAPenStyle;
          options: TBGRAPolyLineOptions; texture: TBGRACustomBitmap= nil);
var
  borders : array of record
              leftSide,rightSide: TLineDef;
              len: single;
              leftDir: TPointF;
            end;
  compPts: array of TPointF;
  nbCompPts: integer;
  revCompPts: array of TPointF;
  nbRevCompPts: integer;
  pts: array of TPointF;
  roundPrecision: integer;
  hw: single; //half-width

  procedure AddPt(normal,rev: TPointF); overload;
  begin
    if (nbCompPts > 0) and (compPts[nbCompPts-1].x=normal.x) and
                           (compPts[nbCompPts-1].y=normal.y) and
       (nbRevCompPts > 0) and (revCompPts[nbRevCompPts-1].x=rev.x) and
                              (revCompPts[nbRevCompPts-1].y=rev.y) then exit;

    if nbCompPts = length(compPts) then
     setlength(compPts, length(compPts)*2);
    compPts[nbCompPts] := normal;
    inc(nbCompPts);

    if nbRevCompPts = length(revCompPts) then
     setlength(revCompPts, length(revCompPts)*2);
    revCompPts[nbRevCompPts] := rev;
    inc(nbRevCompPts);
  end;

  procedure AddPt(xnormal,ynormal: single; xrev,yrev: single); overload;
  begin
    AddPt(PointF(xnormal,ynormal),PointF(xrev,yrev));
  end;

  procedure AddRoundCap(origin: TPointF; dir: TPointF; fromCenter: boolean; flipped: boolean= false);
  var i: integer;
      a,s,c: single;
      offset,flipvalue: single;
  begin
    if fromCenter then offset := 0 else offset := -Pi/2;
    if flipped then flipvalue := -1 else flipvalue := 1;
    for i := 1 to RoundPrecision do
    begin
      a := i/(RoundPrecision+1)*Pi/2 + offset;
      s := sin(a)*hw*flipvalue;
      c := cos(a)*hw;
      AddPt( PointF(origin.x+ dir.x*c - dir.y*s, origin.y + dir.y*c + dir.x*s),
             PointF(origin.x+ dir.x*c + dir.y*s, origin.y + dir.y*c - dir.x*s) );
    end;
  end;

  procedure AddRoundCapAlphaJoin(origin: TPointF; dir: TPointF; fromCenter: boolean; flipped: boolean= false);
  var i: integer;
      a,s,c: single;
      offset,flipvalue: single;
      t,alphaFactor: single; //antialiasing join
  begin
    if fromCenter then offset := 0 else offset := -Pi/2;
    if flipped then flipvalue := -1 else flipvalue := 1;

    alphaFactor := GetAlphaJoinFactor(pencolor.alpha);

    for i := 1 to RoundPrecision do
    begin
      a := i/(RoundPrecision+1)*Pi/2 + offset;
      s := sin(a)*hw*flipvalue;
      c := cos(a);
      t := (1 - c) * 0.7 + alphaFactor;
      c *= hw;
      AddPt( PointF(origin.x+ dir.x*(c-t) - dir.y*s, origin.y + dir.y*(c-t) + dir.x*s),
             PointF(origin.x+ dir.x*(c-t) + dir.y*s, origin.y + dir.y*(c-t) - dir.x*s) );
    end;
  end;

  function ComputeRoundJoin(origin, pt1,pt2: TPointF): ArrayOfTPointF;
  var a1,a2: single;
      da: single;
      precision,i: integer;
  begin
    a1 := arctan2(pt1.y-origin.y,pt1.x-origin.x);
    a2 := arctan2(pt2.y-origin.y,pt2.x-origin.x);
    if a2-a1 > Pi then a2 -= 2*Pi;
    if a1-a2 > Pi then a1 -= 2*Pi;
    if a2=a1 then
    begin
      setlength(result,1);
      result[0] := pt1;
      exit;
    end;
    da := a2-a1;
    precision := round( sqrt( sqr(pt2.x-pt1.x)+sqr(pt2.y-pt1.y) ) ) +2;
    setlength(result,precision);
    for i := 0 to precision-1 do
    begin
      result[i].x := origin.x+cos(a1+i/(precision-1)*da)*hw;
      result[i].y := origin.y+sin(a1+i/(precision-1)*da)*hw;
    end;
  end;

var
  joinLeft,joinRight: array of TPointF;
  nbJoinLeft,nbJoinRight: integer;

  procedure SetJoinLeft(joinpts: array of TPointF);
  var i: integer;
  begin
    nbJoinLeft := length(joinpts);
    if length(joinLeft) < nbJoinLeft then setlength(joinLeft,length(joinLeft)+nbJoinLeft+2);
    for i := 0 to nbJoinLeft-1 do
      joinLeft[i] := joinpts[i];
  end;

  procedure SetJoinRight(joinpts: array of TPointF);
  var i: integer;
  begin
    nbJoinRight := length(joinpts);
    if length(joinRight) < nbJoinRight then setlength(joinRight,length(joinRight)+nbJoinRight+2);
    for i := 0 to nbJoinRight-1 do
      joinRight[i] := joinpts[i];
  end;

  procedure AddJoin(index: integer);
  var len,i: integer;
  begin
    len := nbJoinLeft;
    if nbJoinRight > len then
      len := nbJoinRight;
    if len = 0 then exit;
    if (len > 1) and (index <> -1) then
    begin
      if nbJoinLeft=1 then
        AddPt(joinLeft[0], PointF(joinLeft[0].x-2*borders[index].leftDir.x,
                                  joinLeft[0].y-2*borders[index].leftDir.y)) else
      if nbJoinRight=1 then
        AddPt(PointF(joinRight[0].x+2*borders[index].leftDir.x,
                     joinRight[0].y+2*borders[index].leftDir.y), joinRight[0]);
    end;
    for i := 0 to len-1 do
    begin
      AddPt(joinLeft[i*nbJoinLeft div len],
            joinRight[i*nbJoinRight div len]);
    end;
    if (len > 1) and (index <> -1) then
    begin
      if nbJoinLeft=1 then
        AddPt(joinLeft[0], PointF(joinLeft[0].x-2*borders[index+1].leftDir.x,
                                  joinLeft[0].y-2*borders[index+1].leftDir.y)) else
      if nbJoinRight=1 then
        AddPt(PointF(joinRight[0].x+2*borders[index+1].leftDir.x,
                     joinRight[0].y+2*borders[index+1].leftDir.y), joinRight[0]);
    end;
  end;

var
  PolyAcc: arrayOfTPointF;
  NbPolyAcc: integer;

  procedure FlushLine(lastPointIndex: integer);
  var
    enveloppe: arrayOfTPointF;
    posstyle: single;
    i,idxInsert: Integer;
  begin
    if lastPointIndex <> -1 then
    begin
      AddPt( pts[lastPointIndex].x+borders[lastPointIndex-1].leftDir.x,
             pts[lastPointIndex].y+borders[lastPointIndex-1].leftDir.y,

             pts[lastPointIndex].x-borders[lastPointIndex-1].leftDir.x,
             pts[lastPointIndex].y-borders[lastPointIndex-1].leftDir.y);
    end;
    if (lastPointIndex = high(pts)) and (linecap = pecRound) then
    begin
      if not (plRoundCapOpen in options) then
        AddRoundCap(pts[high(pts)],borders[high(pts)-1].leftSide.dir,false)
      else
       AddRoundCapAlphaJoin(pts[high(pts)],
         PointF(-borders[high(pts)-1].leftSide.dir.x,
                -borders[high(pts)-1].leftSide.dir.y),false,true);
    end;
    posstyle := 0;
    ApplyPenStyle(slice(compPts,nbCompPts),slice(revCompPts,nbRevCompPts),penstyle,width,posstyle,enveloppe);

    if PolyAcc=nil then
    begin
      polyAcc := enveloppe;
      NbPolyAcc := length(enveloppe);
    end
      else
    if enveloppe <> nil then
    begin
      if NbPolyAcc +1+length(enveloppe) > length(PolyAcc) then
        setlength(PolyAcc, length(PolyAcc)*2+1+length(enveloppe));

      idxInsert := NbPolyAcc+1;
      PolyAcc[idxInsert-1] := EmptyPointF;
      for i := 0 to high(enveloppe) do
        PolyAcc[idxInsert+i]:= enveloppe[i];
      inc(NbPolyAcc, length(enveloppe)+1);
    end;

    nbCompPts := 0;
    nbRevCompPts := 0;
  end;

  procedure CycleFlush;
  var idx: integer;
  begin
    if PolyAcc = nil then
    begin
      if (nbCompPts > 1) and (nbRevCompPts > 1) then
      begin
        compPts[0] := compPts[nbCompPts-1];
        revCompPts[0] := revCompPts[nbRevCompPts-1];
      end;
      FlushLine(-1);
    end else
    begin
      if (nbCompPts >= 1) and (nbRevCompPts >= 1) and (NbPolyAcc >= 2) then
      begin
        PolyAcc[0] := compPts[nbCompPts-1];
        idx := 0;
        while (idx < high(PolyAcc)) and (not isEmptyPointF(PolyAcc[idx+1])) do inc(idx);
        PolyAcc[idx] := revCompPts[nbRevCompPts-1];
      end;
      FlushLine(-1);
    end;
  end;

var
  i: integer;
  dir: TPointF;
  leftInter,rightInter,diff: TPointF;
  len,maxMiter: single;
  littleBorder: TLineDef;
  turn,maxDiff: single;
  nbPts: integer;
  ShouldFlushLine, HasLittleBorder, NormalRestart: Boolean;
  pt1,pt2,pt3,pt4: TPointF;

begin
  if length(linepts)=0 then exit;
  if (length(penstyle)=1) and (penstyle[0]=0) then exit;

  hw := width / 2;
  case joinstyle of
  pjsBevel,pjsRound: maxMiter := hw*1.001;
  pjsMiter: maxMiter := hw*2;
  end;

  roundPrecision := round(hw)+2;

  nbPts := 0;
  setlength(pts, length(linepts)+2);
  for i := 0 to high(linepts) do
    if (nbPts = 0) or (linepts[i].x <> pts[nbPts-1].x) or
      (linepts[i].y <> pts[nbPts-1].y) then
    begin
      pts[nbPts]:= linePts[i];
      inc(nbPts);
    end;
  if (nbPts > 1) and (pts[nbPts-1].x = pts[0].x) and (pts[nbPts-1].y = pts[0].y) then dec(nbPts);
  if (plCycle in options) and (nbPts > 2) then
  begin
    pts[nbPts] := pts[0];
    inc(nbPts);
    pts[nbPts] := pts[1];
    inc(nbPts);
    linecap := pecRound;
  end else
    options -= [plCycle];

  setlength(pts,nbPts);

  if nbPts = 1 then
  begin
    if (linecap <> pecFlat) and ((linecap <> pecRound) or not (plRoundCapOpen in options)) then
      bmp.FillEllipseAntialias(pts[0].x,pts[0].y,hw,hw, pencolor); //orientation unknown
    exit;
  end;

  //init computed points arrays
  setlength(compPts, length(pts)*2+4);
  setlength(revCompPts, length(pts)*2+4); //reverse order array
  nbCompPts := 0;
  nbRevCompPts := 0;
  PolyAcc := nil;
  NbPolyAcc := 0;

  //compute borders
  setlength(borders, length(pts)-1);
  for i := 0 to high(pts)-1 do
  begin
    dir.x := pts[i+1].x-pts[i].x;
    dir.y := pts[i+1].y-pts[i].y;
    len := sqrt(sqr(dir.x)+sqr(dir.y));
    dir.x /= len;
    dir.y /= len;

    if (linecap = pecSquare) and ((i=0) or (i=high(pts)-1)) then //for square cap, just start and end further
    begin
      if i=0 then
      begin
        pts[0].x -= dir.x*hw;
        pts[0].y -= dir.y*hw;
      end;
      if (i=high(pts)-1) then
      begin
        pts[high(pts)].x += dir.x*hw;
        pts[high(pts)].y += dir.y*hw;
      end;
      //length changed
      dir.x := pts[i+1].x-pts[i].x;
      dir.y := pts[i+1].y-pts[i].y;
      len := sqrt(sqr(dir.x)+sqr(dir.y));
      dir.x /= len;
      dir.y /= len;
    end else
    if (linecap = pecRound) and (i=0) and not (plCycle in options) then
      AddRoundCap(pts[0], PointF(-dir.x,-dir.y),true);

    borders[i].len := len;
    borders[i].leftDir := PointF(dir.y*hw,-dir.x*hw);
    borders[i].leftSide.origin := PointF(pts[i].x+borders[i].leftDir.X, pts[i].y+borders[i].leftDir.y);
    borders[i].leftSide.dir := dir;
    borders[i].rightSide.origin := PointF(pts[i].x-borders[i].leftDir.X, pts[i].y-borders[i].leftDir.y);
    borders[i].rightSide.dir := dir;
  end;

  //first points
  AddPt( pts[0].x+borders[0].leftDir.x,
         pts[0].y+borders[0].leftDir.y,

         pts[0].x-borders[0].leftDir.x,
         pts[0].y-borders[0].leftDir.y);

  setlength(joinLeft,1);
  setlength(joinRight,1);
  ShouldFlushLine := False;
  //between first and last points
  for i := 0 to high(pts)-2 do
  begin
    HasLittleBorder := false;

    //determine u-turn
    turn := borders[i].leftSide.dir.x*borders[i+1].leftSide.dir.x + borders[i].leftSide.dir.y*borders[i+1].leftSide.dir.y;
    if turn < -0.99999 then
    begin
      if joinstyle <> pjsRound then
      begin
        littleBorder.origin.x := pts[i+1].x+borders[i].leftSide.dir.x*maxMiter;
        littleBorder.origin.y := pts[i+1].y+borders[i].leftSide.dir.y*maxMiter;
        littleBorder.dir := borders[i].leftDir;
        HasLittleBorder := true;
      end;

      nbJoinLeft := 0;
      nbJoinRight:= 0;

      ShouldFlushLine := True;
    end else
    if turn > 0.99999 then
    begin
      pt1.x := pts[i+1].x + borders[i].leftDir.x;
      pt1.y := pts[i+1].y + borders[i].leftDir.y;
      pt2.x := pts[i+2].x + borders[i+1].leftDir.x;
      pt2.y := pts[i+2].y + borders[i+1].leftDir.y;
      SetJoinLeft([pt1,PointF((pt1.x+pt2.x)/2,(pt1.y+pt2.y)/2),pt2]);

      pt1.x := pts[i+1].x - borders[i].leftDir.x;
      pt1.y := pts[i+1].y - borders[i].leftDir.y;
      pt2.x := pts[i+2].x - borders[i+1].leftDir.x;
      pt2.y := pts[i+2].y - borders[i+1].leftDir.y;
      SetJoinRight([pt1,PointF((pt1.x+pt2.x)/2,(pt1.y+pt2.y)/2),pt2]);
    end else
    begin
      //determine turning left or right
      turn := borders[i].leftSide.dir.x*borders[i+1].leftSide.dir.y - borders[i].leftSide.dir.y*borders[i+1].leftSide.dir.x;

      maxDiff := borders[i].len;
      if borders[i+1].len < maxDiff then
        maxDiff := borders[i+1].len;
      if penstyle <> nil then
        if maxDiff > 2*width then maxDiff := 2*width;
      maxDiff := sqrt(sqr(maxDiff)+sqr(hw));

      //leftside join
      leftInter := Intersect( borders[i].leftSide, borders[i+1].leftSide );
      diff.x := leftInter.x-pts[i+1].x;
      diff.y := leftInter.y-pts[i+1].y;
      len := sqrt(diff.x*diff.x+diff.y*diff.y);
      if (len > maxMiter) and (turn >= 0) then //if miter too far
      begin
        diff.x /= len;
        diff.y /= len;
        if joinstyle <> pjsRound then
        begin
          //compute little border
          littleBorder.origin.x := pts[i+1].x+diff.x*maxMiter;
          littleBorder.origin.y := pts[i+1].y+diff.y*maxMiter;
          littleBorder.dir.x := diff.y;
          littleBorder.dir.y := -diff.x;
          HasLittleBorder := true;

          //intersect with each border
          pt1 := Intersect(borders[i].leftSide, littleBorder);
          pt2 := Intersect(borders[i+1].leftSide, littleBorder);
          SetJoinLeft( [pt1, pt2] );
        end else
        begin
          //perpendicular
          pt1 := PointF(pts[i+1].x+borders[i].leftSide.dir.y*hw,
                        pts[i+1].y-borders[i].leftSide.dir.x*hw);
          pt2 := PointF(pts[i+1].x+borders[i+1].leftSide.dir.y*hw,
                        pts[i+1].y-borders[i+1].leftSide.dir.x*hw);
          SetJoinLeft(ComputeRoundJoin(pts[i+1],pt1,pt2));
        end;
      end else
      if (len > maxDiff) and (turn <= 0) then //if inner intersection too far
      begin
        ShouldFlushLine := True;
        nbJoinLeft := 0;
      end else
      begin
        if (turn > 0) and (len > 1.0001*hw) then
          SetJoinLeft([leftInter,leftInter]) else
        begin
          nbJoinLeft := 1;
          joinLeft[0] := leftInter;
        end;
      end;

      //rightside join
      rightInter := Intersect( borders[i].rightSide, borders[i+1].rightSide );
      diff.x := rightInter.x-pts[i+1].x;
      diff.y := rightInter.y-pts[i+1].y;
      len := sqrt(diff.x*diff.x+diff.y*diff.y);
      if (len > maxMiter) and (turn <= 0) then //if miter too far
      begin
        diff.x /= len;
        diff.y /= len;

        if joinstyle <> pjsRound then
        begin
          //compute little border
          littleBorder.origin.x := pts[i+1].x+diff.x*maxMiter;
          littleBorder.origin.y := pts[i+1].y+diff.y*maxMiter;
          littleBorder.dir.x := diff.y;
          littleBorder.dir.y := -diff.x;
          HasLittleBorder := true;

          //intersect with each border
          pt1 := Intersect(borders[i].rightSide, littleBorder);
          pt2 := Intersect(borders[i+1].rightSide, littleBorder);
          SetJoinRight( [pt1, pt2] );
        end else
        begin
          //perpendicular
          pt1 := PointF(pts[i+1].x-borders[i].rightSide.dir.y*hw,
                        pts[i+1].y+borders[i].rightSide.dir.x*hw);
          pt2 := PointF(pts[i+1].x-borders[i+1].rightSide.dir.y*hw,
                        pts[i+1].y+borders[i+1].rightSide.dir.x*hw);
          SetJoinRight(ComputeRoundJoin(pts[i+1],pt1,pt2));
        end;
      end else
      if (len > maxDiff) and (turn >= 0) then //if inner intersection too far
      begin
        ShouldFlushLine := True;
        nbJoinRight := 0;
      end else
      begin
        if (turn < 0) and (len > 1.0001*hw) then
          SetJoinRight([rightInter,rightInter]) else
        begin
          nbJoinRight := 1;
          joinRight[0] := rightInter;
        end;
      end;
    end;

    if ShouldFlushLine then
    begin
      NormalRestart := True;
      if HasLittleBorder then
      begin
        if turn >= 0 then
        begin
          //intersect with each border
          pt1 := Intersect(borders[i].leftSide, littleBorder);
          pt2 := Intersect(borders[i+1].leftSide, littleBorder);
          pt3 := PointF( pts[i+1].x-borders[i].leftDir.x,
                         pts[i+1].y-borders[i].leftDir.y );
          pt4 := PointF( pts[i+1].x+borders[i].leftDir.x,
                         pts[i+1].y+borders[i].leftDir.y );

          AddPt(pt4,pt3);
          AddPt(pt1,pt2);
        end else
        begin
          //intersect with each border
          pt1 := Intersect(borders[i+1].rightSide, littleBorder);
          pt2 := Intersect(borders[i].rightSide, littleBorder);
          pt3 := PointF( pts[i+1].x+borders[i].leftDir.x,
                         pts[i+1].y+borders[i].leftDir.y);
          pt4 := PointF( pts[i+1].x-borders[i].leftDir.x,
                         pts[i+1].y-borders[i].leftDir.y );

          AddPt(pt3,pt4);
          AddPt(pt1,pt2);
        end;

        FlushLine(-1);

        AddPt(pt2,pt1);
      end else
      if joinstyle = pjsRound then
      begin

        if (penstyle= nil) and (turn > 0) then
        begin
          pt1 := PointF(pts[i+1].x+ borders[i].leftDir.x,
                       pts[i+1].y+ borders[i].leftDir.y);
          pt2 := PointF(pts[i+1].x+ borders[i+1].leftDir.x,
                       pts[i+1].y+ borders[i+1].leftDir.y);
          SetJoinLeft(ComputeRoundJoin(pts[i+1],pt1,pt2));
          nbJoinRight := 1;
          JoinRight[0]:= PointF(pts[i+1].x- borders[i].leftDir.x,
                          pts[i+1].y- borders[i].leftDir.y);
          AddJoin(-1);
          FlushLine(-1);
        end else
        if (penstyle= nil) and (turn < 0) then
        begin
          pt1 := PointF(pts[i+1].x- borders[i].leftDir.x,
                       pts[i+1].y- borders[i].leftDir.y);
          pt2 := PointF(pts[i+1].x- borders[i+1].leftDir.x,
                       pts[i+1].y- borders[i+1].leftDir.y);
          SetJoinRight(ComputeRoundJoin(pts[i+1],pt1,pt2));
          nbJoinLeft := 1;
          JoinLeft[0]:= PointF(pts[i+1].x+ borders[i].leftDir.x,
                          pts[i+1].y+ borders[i].leftDir.y);
          AddJoin(-1);
          FlushLine(-1);
        end else
        if (nbCompPts > 1) and (nbRevCompPts > 1) then
        begin
          pt1 := PointF(pts[i+1].x+ borders[i].leftDir.x,
                       pts[i+1].y+ borders[i].leftDir.y);
          pt2 := PointF(pts[i+1].x- borders[i].leftDir.x,
                       pts[i+1].y- borders[i].leftDir.y);
          AddPt( pt1, pt2 );
          FlushLine(-1);
        end else
        begin
          nbCompPts := 0;
          nbRevCompPts := 0;
        end;


        //AddRoundCap(pts[i+1], borders[i].leftSide.dir,false);


        //NormalRestart := false;

        {if linecap = pecRound then //if linecap is round, we can use opened line
          AddRoundCap(pts[i+1], borders[i+1].leftSide.dir,true,true)
        else}
        {AddRoundCap(pts[i+1], PointF(-borders[i+1].leftSide.dir.x,
                                       -borders[i+1].leftSide.dir.y)
                                          ,true,false);   }
      end else
      begin
        FlushLine(i+1);
        if turn > 0 then
          AddPt( leftInter, PointF(pts[i+1].x+borders[i].leftDir.x,
                                   pts[i+1].y+borders[i].leftDir.y ) ) else
        if turn < 0 then
          AddPt(  PointF(pts[i+1].x-borders[i].leftDir.x,
                         pts[i+1].y-borders[i].leftDir.y ), rightInter );
      end;

      If NormalRestart then
      begin
        AddPt( pts[i+1].x+borders[i+1].leftDir.x,
               pts[i+1].y+borders[i+1].leftDir.y,

               pts[i+1].x-borders[i+1].leftDir.x,
               pts[i+1].y-borders[i+1].leftDir.y);
      end;

      ShouldFlushLine := false;
    end else
      AddJoin(i);
  end;

  if plCycle in options then
    CycleFlush
  else
    FlushLine(high(pts));

  if texture <> nil then
    bmp.FillPolyAntialias(Slice(PolyAcc,NbPolyAcc),texture)
  else
    bmp.FillPolyAntialias(Slice(PolyAcc,NbPolyAcc),pencolor);
end;

initialization

  SolidPenStyle := nil;
  setlength(ClearPenStyle,1);
  ClearPenStyle[0] := 0;
  DashPenStyle := BGRAPenStyle(3,1);
  DotPenStyle := BGRAPenStyle(1,1);
  DashDotPenStyle := BGRAPenStyle(3,1,1,1);
  DashDotDotPenStyle := BGRAPenStyle(3,1,1,1,1,1);

end.

