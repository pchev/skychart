program mergegaiahip;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}
  cthreads,
  {$ENDIF}
  propermotion,
  math, Classes, SysUtils;

const
  sep = '|';
  blank = '                         ';
  maxname=26;

var
  buf, bufout, gdr3,g,bp,rp: string;
  fhip, fgaia, fout: textfile;
  gaiahip,xhip: TStringList;
  gid:qword;
  gdr3flag: byte;
  gra,gdec,gparallax,gpmra,gpmdec,gmagg,gmagbp,gmagrp,grv,gmagv: double;
  ghip,hip:integer;
  ra,de,px,pmra,pmde,rv,mv,deltay,distfact,rra,rde,rpmra,rpmde,rpx:double;
  matchok: boolean;

function copyp(t1: string; First, last: integer): string;
begin
  Result := copy(t1, First, last - First + 1);
end;

function copy1(t1: string; First, last: integer): string;
begin
 Result := copy(t1 + blank, 1, last - First + 1);
end;

function GaiaGtoV_DR3(g,br:double):double;
begin
  // Use the color relation for Johnson-Cousins given in the paper:
  // GaiaDR3  Documentation chapter 5.5
  // G−V = -0.02704 + 0.01424 * (GBP−GRP) - 0.2156 * (GBP−GRP)**2 + 0.01426 * (GBP−GRP)**3
  // V = G +0.02704 - 0.01424 * (GBP−GRP) + 0.2156 * (GBP−GRP)**2 - 0.01426 * (GBP−GRP)**3
  // Validity: −0.5 < (GBP−GRP) < 5.0
  if (br>-0.5)and(br<5.0) then
    result := g + 0.02704 - 0.01424 * br + 0.2156 * br**2 - 0.01426 * br**3
  else
    // Out of range, use safe value
    result := g + 0.0176 + 0.1 * br;
  // round result
  result := Round(result*100)/100;
end;

procedure nextgaia;
var r:string;
begin
  if eof(fgaia) then
    ghip:=0
  else begin
    readln(fgaia,r);
    gaiahip.Clear;
    ExtractStrings([' '], [' '], PChar(r),gaiahip,true);
    gid:=StrToQWord(gaiahip[0]);
    gra:=StrToFloatDef(gaiahip[1],MaxDouble);
    gdec:=StrToFloatDef(gaiahip[2],MaxDouble);
    gparallax:=StrToFloatDef(gaiahip[3],MaxDouble);
    gpmra:=StrToFloatDef(gaiahip[4],MaxDouble);
    gpmdec:=StrToFloatDef(gaiahip[5],MaxDouble);
    gmagg:=StrToFloatDef(gaiahip[6],MaxDouble);
    gmagbp:=StrToFloatDef(gaiahip[7],MaxDouble);
    gmagrp:=StrToFloatDef(gaiahip[8],MaxDouble);
    if (gmagg<MaxDouble)and(gmagbp<MaxDouble)and(gmagrp<MaxDouble) then
      gmagv:=GaiaGtoV_DR3(gmagg,gmagbp-gmagrp)
    else
      gmagv:=gmagg;
    grv:=StrToFloatDef(gaiahip[9],MaxDouble);
    ghip:=StrToInt(gaiahip[10]);
  end;

end;

procedure writeheader;
begin
  bufout := '';
  buf := copyp('HIP' + blank, 1, 6); //HIP
  bufout := bufout + buf + sep;
  buf := copyp('GAIA DR3'+blank,1,22); // source_id
  bufout := bufout + buf + sep;
  buf := copyp('f'+blank,1,3); // cross identification flag
  bufout := bufout + buf + sep;
  buf := copy('HD' + blank, 1, 6); //HD
  bufout := bufout + buf + sep;
  buf := copy('BD' + blank, 1, 11); //BD
  bufout := bufout + buf + sep;
  buf := copy('HR' + blank, 1, 4); //HR
  bufout := bufout + buf + sep;
  buf := copy('Fl' + blank, 1, 3); //Flamsteed
  bufout := bufout + buf + sep;
  buf := copy('Bayer' + blank, 1, 5); // Bayer
  bufout := bufout + buf + sep;
  //    buf:=copy('Cst',1,3); // Constellation
  //    bufout:=bufout+buf+sep;
  buf := copy1('Comp', 8, 13); //Comp
  bufout := bufout + buf + sep;
  buf := copy1('RA', 59, 70); //RA ICRS J1991.25
  bufout := bufout + buf + sep;
  buf := copy1('Dec', 72, 83); //DEC ICRS J1991.25
  bufout := bufout + buf + sep;
  buf := copy1('Px', 85, 90); //Px
  bufout := bufout + buf + sep;
  buf := copy1('pmRA', 92, 99); //pmRA
  bufout := bufout + buf + sep;
  buf := copy1('pmDe', 101, 108); //pmDe
  bufout := bufout + buf + sep;
  buf := copy1('SpType', 238, 263); //sptype
  bufout := bufout + buf + sep;
  buf := copy1('RV', 271, 277); //RV
  bufout := bufout + buf + sep;
  //    buf:=copy1('Per',37,42); //Var per
  //    bufout:=bufout+buf+sep;
  buf := copy1('mB', 53, 58); //mB
  bufout := bufout + buf + sep;
  buf := copy1('mV', 60, 64); //mV
  bufout := bufout + buf + sep;
  //    buf:=copy1('mR',66,70); //mR
  //    bufout:=bufout+buf+sep;
  buf := copy1('mI', 72, 77); //mI
  bufout := bufout + buf + sep;
  //    buf:=copy1('mJ',79,84); //mJ
  //    bufout:=bufout+buf+sep;
  //    buf:=copy1('mH',86,91); //mH
  //    bufout:=bufout+buf+sep;
  //    buf:=copy1('mK',93,98); //mK
  //    bufout:=bufout+buf+sep;
  buf := copy1('B-V', 140, 145); //B-V
  bufout := bufout + buf + sep;
  buf := copy('mG'+blank, 1, 6); //G
  bufout := bufout + buf + sep;
  buf := copy('mBp'+blank, 1, 6); //Bp
  bufout := bufout + buf + sep;
  buf := copy('mRp'+blank, 1, 6); //Rp
  bufout := bufout + buf + sep;
  buf := copy1('Cst', 8, 10); //Const
  bufout := bufout + buf + sep;
  //    buf:=copy1('Name'+blank+blank,28,75); //Name
  //    bufout:=bufout+buf+sep;
  //    buf:=copy1('CompId',184,199); //CompId
  //    bufout:=bufout+buf+sep;
  buf := copy('Star name' + blank + blank, 1, maxname); //star  name
  bufout := bufout + buf + sep;
  buf := 'FlN    ' + sep + 'BaN      ';
  bufout := bufout + buf + sep;
  writeln(fout, bufout);
end;

begin
  AssignFile(fhip, 'cdc_xhip_sorted');
  Reset(fhip);
  AssignFile(fgaia, 'cdc_gaia_hipparcos_sorted');
  Reset(fgaia);
  AssignFile(fout, 'catgen_gaiahip.dat');
  Rewrite(fout);
  xhip:=TStringList.Create;
  gaiahip:=TStringList.Create;
  writeheader;
  deltay:=2016.0-1991.25;
  nextgaia;
  repeat
    readln(fhip,buf);
    xhip.Clear;
    ExtractStrings(['|'], [], PChar(buf),xhip,true);
    buf:=xhip[0];
    buf:=xhip[2];
    buf:=xhip[3];
    hip:=StrToInt(xhip[0]);
    gdr3:='';
    gdr3flag:=0;
    ra:=StrToFloat(trim(xhip[7]));
    de:=StrToFloat(trim(xhip[8]));
    px:=StrToFloatDef(trim(xhip[9]),MaxDouble);
    pmra:=StrToFloatDef(trim(xhip[10]),MaxDouble);
    pmde:=StrToFloatDef(trim(xhip[11]),MaxDouble);
    rv:=StrToFloatDef(trim(xhip[13]),MaxDouble);
    mv:=StrToFloatDef(trim(xhip[15]),MaxDouble);
    // change hip coordinates from J1991.25 to J2016
    if (pmra<MaxDouble)and(pmde<MaxDouble) then begin
      rra:=deg2rad*ra;
      rde:=deg2rad*de;
      rpmra:=deg2rad*pmra/1000/3600;
      rpmde:=deg2rad*pmde/1000/3600;
      rpx:=px/1000;
      propermotion.ProperMotion(rra, rde, deltay, rpmra, rpmde,(px<MaxDouble)and(rv<MaxDouble),rpx, rv,distfact);
      ra:=rad2deg*rra;
      de:=rad2deg*rde;
    end;
    if hip=ghip then begin
      // use gaia data
      gdr3:=IntToStr(gid);
      matchok:=true;
      if (mv<MaxDouble)and((gmagv<MaxDouble)) then begin
        if abs(mv-gmagv)>2 then begin
          matchok:=false; // reject on large magnitude difference
          gdr3flag:=gdr3flag+16;
        end;
      end;
      if (pmra<MaxDouble)and(pmde<MaxDouble) then begin
        if (abs(ra-gra)>0.001389)or(abs(de-gdec)>0.001389) then begin
          matchok:=false; // reject on ra,dec diff > 5"
          gdr3flag:=gdr3flag+8;
        end;
      end;
      if matchok then begin  // use gaia data
        ra:=gra;
        de:=gdec;
        if (gpmra<MaxDouble)and(gpmdec<MaxDouble) then begin
          pmra:=gpmra;
          pmde:=gpmdec;
        end
        else begin
          gdr3flag:=gdr3flag+4;
        end;
        if (gparallax<MaxDouble) then begin
          px:=gparallax;
        end
        else begin
          gdr3flag:=gdr3flag+2;
        end;
        if (grv<MaxDouble) then begin
          rv:=grv;
        end
        else begin
          gdr3flag:=gdr3flag+1;
        end;
      end
      else begin  // keep hip data
        if (pmra=MaxDouble)or(pmde=MaxDouble) then begin
          gdr3flag:=gdr3flag+32;  // no gaia, no pm, 1991.25 hip position
        end;
      end;
      if gmagg<MaxDouble then begin
         g:=FormatFloat('0.000',gmagg);
         g:=copy(blank,1,6-length(g))+g;
       end
       else g:=copy(blank,1,6);
       if gmagbp<MaxDouble then begin
         bp:=FormatFloat('0.000',gmagbp);
         bp:=copy(blank,1,6-length(bp))+bp;
       end
       else bp:=copy(blank,1,6);
       if gmagrp<MaxDouble then begin
         rp:=FormatFloat('0.000',gmagrp);
         rp:=copy(blank,1,6-length(rp))+rp;
       end
       else rp:=copy(blank,1,6);
      nextgaia;
    end
    else begin
      gdr3flag:=gdr3flag+64;
      g:=copy(blank,1,6);
      bp:=copy(blank,1,6);
      rp:=copy(blank,1,6);
    end;
    bufout := xhip[0]+sep;                        //HIP
    bufout := bufout+copyp(gdr3+blank,1,22)+sep;  //GAIA
    bufout := bufout+copyp(inttostr(gdr3flag)+blank,1,3)+ sep; //suspect cross identification
    bufout := bufout+xhip[1]+sep;                 //HD
    bufout := bufout+xhip[2]+sep;                 //BD
    bufout := bufout+xhip[3]+sep;                 //HR
    bufout := bufout+xhip[4]+sep;                 //Fl
    bufout := bufout+xhip[5]+sep;                 //Bayer
    bufout := bufout+xhip[6]+sep;                 //Comp
    buf:=FormatFloat('0.00000000',ra);
    buf:=copy(blank,1,12-length(buf))+buf;
    bufout := bufout+buf+sep;                     //RA
    buf:=FormatFloat('0.00000000',de);
    buf:=copy(blank,1,12-length(buf))+buf;
    bufout := bufout+buf+sep;                     //Dec
    if px<MaxDouble then begin
      buf:=FormatFloat('0.00',px);
      buf:=copy(blank,1,6-length(buf))+buf;
    end
    else buf:=copy(blank,1,6);
    bufout := bufout+buf+sep;                     //Px
    if pmra<MaxDouble then begin
      buf:=FormatFloat('0.00',pmra);
      buf:=copy(blank,1,8-length(buf))+buf;
    end
    else buf:=copy(blank,1,8);
    bufout := bufout+buf+sep;                     //pmRA
    if pmde<MaxDouble then begin
      buf:=FormatFloat('0.00',pmde);
      buf:=copy(blank,1,8-length(buf))+buf;
    end
    else buf:=copy(blank,1,8);
    bufout := bufout+buf+sep;                     //pmDec
    bufout := bufout+xhip[12]+sep;                //SpType
    if rv<MaxDouble then begin
      buf:=FormatFloat('0.00',rv);
      buf:=copy(blank,1,7-length(buf))+buf;
    end
    else buf:=copy(blank,1,7);
    bufout := bufout+buf+sep;                     //RV
    bufout := bufout+xhip[14]+sep;                //mB
    bufout := bufout+xhip[15]+sep;                //mV
    bufout := bufout+xhip[16]+sep;                //mI
    bufout := bufout+xhip[17]+sep;                //B-V
    bufout := bufout+g+sep;                       //G
    bufout := bufout+bp+sep;                      //Bp
    bufout := bufout+rp+sep;                      //Rp
    bufout := bufout+xhip[18]+sep;                //Cst
    bufout := bufout+xhip[19]+sep;                //name
    bufout := bufout+xhip[20]+sep;                //FlN
    bufout := bufout+xhip[21]+sep;                //BaN

    writeln(fout, bufout);

  until eof(fhip);

  CloseFile(fout);
  CloseFile(fhip);
  CloseFile(fgaia);
  xhip.free;
  gaiahip.free;
end.

