unit cu_fits;

{
Copyright (C) 2005 Patrick Chevalley

http://www.ap-i.net
pch@ap-i.net

This program is free software; you can redistribute it and/or
modify it under the terms of the GNU General Public License
as published by the Free Software Foundation; either version 2
of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software
Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
}

{$mode delphi}{$H+}

interface

uses
  u_translation, UScaleDPI, BGRABitmap, BGRABitmapTypes,
  u_util, u_constant, u_projection, SysUtils, Classes, passql,
  passqlite, LazUTF8, LazFileUtils,
  Graphics, Math, FPImage, Controls, LCLType, Forms, StdCtrls, ComCtrls,
  ExtCtrls, Buttons, IntfGraphics;

type

  Tfitsheader = record
    bitpix, naxis, naxis1, naxis2, naxis3: integer;
    bzero, bscale, dmax, dmin, blank, equinox: double;
    ctype1, ctype2, radecsys, objects: string;
    rotaok, cdok, pcok, valid, coordinate_valid: boolean;
    crpix1, crpix2, crval1, crval2, cdelt1, cdelt2, crota1, crota2: double;
    cd1_1, cd1_2, cd2_1, cd2_2: double;
    pc: array[1..2, 1..2] of double;
  end;

  Timai8 = array of array of array of byte;
  TPimai8 = ^Timai8;
  Timai16 = array of array of array of smallint;
  TPimai16 = ^Timai16;
  Timai32 = array of array of array of longint;
  TPimai32 = ^Timai32;
  Timar32 = array of array of array of single;
  TPimar32 = ^Timar32;
  Timar64 = array of array of array of double;
  TPimar64 = ^Timar64;

  TDrawProjThread = class(TThread)
  // not used for now
  public
    IntfImg, ProjImg: TLazIntfImage;
    ra_offset, de_offset, imgjd: double;
    cfgsc: Tconf_skychart;
    working, smallfov: boolean;
    num, id, Fw, Fh: integer;
    procedure Execute; override;
    constructor Create(CreateSuspended: boolean);
  end;

  TDrawListImg = array[0..maxfitslist] of TLazIntfImage;
  TDrawListDouble = array[0..maxfitslist] of double;
  TDrawListInteger = array[0..maxfitslist] of integer;

  TDrawListThread = class(TThread)
  public
    IntfImg: TDrawListImg;
    ProjImg: TLazIntfImage;
    ra_offset, de_offset: TDrawListDouble;
    imgjd, scaling: double;
    lstjd: TDrawListDouble;
    cfgsc: Tconf_skychart;
    working: boolean;
    smallfov, samejd: boolean;
    Fw, Fh: TDrawListInteger;
    num, id, filecount: integer;
    procedure Execute; override;
    constructor Create(CreateSuspended: boolean);
  end;

  Tfitslistlabel = record
    lid: longword;
    lra, lde, rot: single;
  end;

const
  maxl = 20000;
  Cittsqrt = MaxWord / sqrt(MaxWord);
  Cittlog = MaxWord / ln(MaxWord);
  Cittsqrt8 = MAXBYTE / sqrt(MaxWord);
  Cittlog8 = MAXBYTE / ln(MaxWord);

type
  TFits = class(TComponent)
  private
    d8: array[1..2880] of byte;
    d16: array[1..1440] of word;
    d32: array[1..720] of longword;
    d64: array[1..360] of int64;
    imai8: Timai8;
    imai16: Timai16;
    imai32: Timai32;
    imar32: Timar32;
    imar64: Timar64;
    Fheader: Tfitsheader;
    FFileName: string;
    n_axis, cur_axis, Fwidth, Fheight, hdr_end, colormode, current_result: integer;
    Fimg_width, Fimg_Height, Fjd, Fra, Fde, Frotation: double;
    FWCSvalid: boolean;
    FImageLoaded: boolean;
    Fprojection: string;
    Fmean, Fsigma, dmin, dmax, Fmin_sigma, Fmax_sigma: double;
    Fitt: Titt;
    procedure SetFile(Value: string);
    procedure Readfitsheader;
    procedure FITSCoord;
    procedure ReadFitsImage;
    function Citt(Value: word): word;
    function Citt8(Value: word): byte;
  protected
    { Protected declarations }
  public
    { Public declarations }
    db1: TSqlDB;
    dbconnected: boolean;
    fitslist: TStringList;
    fitslistactive: array of boolean;
    fitslistlabel: array of Tfitslistlabel;
    fitslistcenterdist: array of double;
    fitslistmodified: boolean;
    fitslistra, fitslistdec: double;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function ConnectDB(db: string): boolean;
    function OpenDB(catalogname: string; ra1, ra2, dec1, dec2: double): boolean;
    function GetDB(var filename, objname: string;
      var ra, de, Width, Height, rot: double): boolean;
    function DeleteDB(cname, oname: string): boolean;
    function InsertDB(fname, cname, oname: string;
      ra, de, Width, Height, rotation: double): boolean;
    function ImagesForCatalog(catname: string): boolean;
    procedure GetImagesCatalog(var imgcatlist: tstringlist);
    function GetFileName(catname, objectname: string; var filename: string): boolean;
    procedure GetAllHeader(var Result: TStringList);
    procedure ViewHeaders;
    procedure GetBitmap(var imabmp: Tbitmap);
    procedure GetIntfImg(var IntfImg: TLazIntfImage);
    procedure GetBGRABitmap(var bgra: TBGRAbitmap);
    procedure InfoWCScoord;
    procedure GetProjBitmap(var imabmp: Tbitmap; c: Tconf_skychart);
    procedure GetProjList(var imabmp: Tbitmap; c: Tconf_skychart);
    property Header: Tfitsheader read Fheader;
    property FileName: string read FFileName write SetFile;
    property Center_RA: double read Fra;
    property Center_DE: double read Fde;
    property Img_Width: double read Fimg_width;
    property Img_Height: double read Fimg_Height;
    property WCSvalid: boolean read FWCSvalid;
    property Rotation: double read Frotation;
    property Projection: string read Fprojection;
    property min_sigma: double read Fmin_sigma write Fmin_sigma;
    property max_sigma: double read Fmax_sigma write Fmax_sigma;
    property itt: Titt read Fitt write Fitt;
  end;

implementation

constructor TFits.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Fitt := ittramp;
  db1 := TLiteDB.Create(self);
  dbconnected := False;
  fitslist := TStringList.Create;
  fitslistmodified := False;
  FImageLoaded := False;
end;

destructor TFits.Destroy;
begin
  try
    fitslist.Free;
    db1.Free;
    setlength(imar64, 0, 0, 0);
    setlength(imar32, 0, 0, 0);
    setlength(imai8, 0, 0, 0);
    setlength(imai16, 0, 0, 0);
    setlength(imai32, 0, 0, 0);
    inherited Destroy;
  except
    writetrace('error destroy ' + Name);
  end;
end;

procedure TFits.SetFile(Value: string);
begin
  try
{$ifdef mswindows}// Windows sometime do not accept \\ as path delimiter
    Value := StringReplace(Value, '\\', '\', [rfReplaceAll]);
{$endif}
    FWCSvalid := False;
    FImageLoaded := False;
    Fheader.valid := False;
    Fheader.coordinate_valid := False;
    FFileName := '';
    if fileexists(Value) and (rightstr(Value, 1) <> PathDelim) then
    begin
      cur_axis := 1;
      setlength(imar64, 0, 0, 0);
      setlength(imar32, 0, 0, 0);
      setlength(imai8, 0, 0, 0);
      setlength(imai16, 0, 0, 0);
      setlength(imai32, 0, 0, 0);
      FFileName := Value;
      Readfitsheader;
      if Fheader.valid then
        FITSCoord;
    end;
  except
    Fheader.valid := False;
  end;
end;

procedure TFits.ViewHeaders;
var
  hdr: TStringList;
  f: TForm;
  m: TMemo;
  p: TPanel;
  b: TButton;
begin
  if not Fheader.valid then
    exit;
  f := TForm.Create(self);
  m := Tmemo.Create(f);
  p := TPanel.Create(f);
  b := TButton.Create(f);
  hdr := TStringList.Create;
  try
    f.Width := 600;
    f.Height := 450;
    p.Parent := f;
    p.Caption := '';
    p.Height := b.Height + 8;
    p.Align := alBottom;
    m.Parent := f;
    m.Align := alClient;
    m.font.Name := 'courier';
    m.ReadOnly := True;
    m.WordWrap := False;
    m.ScrollBars := ssAutoBoth;
    b.Parent := p;
    b.Caption := rsClose;
    b.Top := 4;
    b.Left := 40;
    b.ModalResult := mrOk;
    b.Default := True;
    GetAllHeader(hdr);
    m.Lines := hdr;
    FormPos(f, mouse.CursorPos.X, mouse.CursorPos.Y);
    f.Caption := SysToUTF8(FFileName);
    ScaleDPI(f);
    f.ShowModal;
  finally
    hdr.Free;
    b.Free;
    p.Free;
    m.Free;
    f.Free;
  end;
end;

procedure TFits.GetAllHeader(var Result: TStringList);
var
  header: array[1..36, 1..80] of char;
  i, n, p1: integer;
  eoh, ItsFits: boolean;
  keyword, Value: string;
  f: file;
begin
  ItsFits := False;
  filemode := 0;
  assignfile(f, FFileName);
  reset(f, 1);
  Result.Clear;
  eoh := False;
  repeat
    blockread(f, header, sizeof(header), n);
    for i := 1 to 36 do
    begin
      p1 := pos('=', header[i]);
      if p1 = 0 then
        p1 := 9;
      keyword := trim(copy(header[i], 1, p1 - 1));
      Value := trim(copy(header[i], p1 + 1, 99)) + blank;
      if (not ItsFits) and (keyword = 'SIMPLE') and (Value[1] = 'T') then
        itsFits := True;
      if (keyword = 'END') then
        eoh := True;
      Result.add(header[i]);
    end;
    if not ItsFits then
    begin
      Result.Add(rsNotAFITSFile);
      Closefile(f);
      Exit;
    end;
  until eoh;
  Closefile(f);
end;

procedure TFits.Readfitsheader;
var
  header: array[1..36, 1..80] of char;
  i, n, p1, p2: integer;
  eoh: boolean;
  keyword, buf: string;
  f: file;
begin
  filemode := fmShareDenyNone;
  assignfile(f, FFileName);
  reset(f, 1);
  try
    with FHeader do
    begin
      coordinate_valid := False;
      valid := False;
      eoh := False;
      naxis1 := 0;
      naxis2 := 0;
      naxis3 := 1;
      bitpix := 0;
      dmin := 0;
      dmax := 0;
      blank := 0;
      bzero := 0;
      bscale := 1;
      ctype1 := '';
      ctype2 := '';
      objects := '';
      crpix1 := 0;
      crpix2 := 0;
      crval1 := 0;
      crval2 := 0;
      cdelt1 := 0;
      cdelt2 := 0;
      crota1 := 0;
      crota2 := 0;
      cd1_1 := 0;
      cd2_2 := 0;
      cd1_2 := 0;
      cd2_1 := 0;
      pc[1, 1] := 1;
      pc[1, 2] := 0;
      pc[2, 1] := 0;
      pc[2, 2] := 1;
      rotaok := False;
      cdok := False;
      pcok := False;
      equinox := 0.0;
      radecsys := '';
      repeat
        blockread(f, header, sizeof(header), n);
        if n <> sizeof(header) then
          exit;
        for i := 1 to 36 do
        begin
          p1 := pos('=', header[i]);
          if p1 = 0 then
            p1 := 9;
          p2 := pos('/', header[i]);
          if p2 = 0 then
            p2 := 80;
          keyword := trim(copy(header[i], 1, p1 - 1));
          buf := trim(copy(header[i], p1 + 1, p2 - p1 - 1));
          if (keyword = 'SIMPLE') then
            if (copy(buf, 1, 1) <> 'T') then
            begin
              valid := False;
              Break;
            end
            else
            begin
              valid := True;
            end;
          if (keyword = 'BITPIX') then
            bitpix := StrToInt(buf);
          if (keyword = 'NAXIS') then
            naxis := StrToInt(buf);
          if (keyword = 'NAXIS1') then
            naxis1 := StrToInt(buf);
          if (keyword = 'NAXIS2') then
            naxis2 := StrToInt(buf);
          if (keyword = 'NAXIS3') then
            naxis3 := StrToInt(buf);
          if (keyword = 'BZERO') then
            bzero := strtofloat(buf);
          if (keyword = 'BSCALE') then
            bscale := strtofloat(buf);
          if (keyword = 'DATAMAX') then
            dmax := strtofloat(buf);
          if (keyword = 'DATAMIN') then
            dmin := strtofloat(buf);
          if (keyword = 'THRESH') then
            dmax := strtofloat(buf);
          if (keyword = 'THRESL') then
            dmin := strtofloat(buf);
          if (keyword = 'BLANK') then
            blank := strtofloat(buf);
          if (keyword = 'OBJECT') then
            objects := trim(buf);
          if (keyword = 'CTYPE1') then
            ctype1 := buf;
          if (keyword = 'CTYPE2') then
            ctype2 := buf;
          if (keyword = 'CRPIX1') then
            crpix1 := strtofloat(buf);
          if (keyword = 'CRPIX2') then
            crpix2 := strtofloat(buf);
          if (keyword = 'CRVAL1') then
            crval1 := strtofloat(buf);
          if (keyword = 'CRVAL2') then
            crval2 := strtofloat(buf);
          if (keyword = 'CDELT1') then
          begin
            cdelt1 := strtofloat(buf);
            rotaok := True;
          end;
          if (keyword = 'CDELT2') then
          begin
            cdelt2 := strtofloat(buf);
            rotaok := True;
          end;
          if (keyword = 'CROTA1') then
            crota1 := strtofloat(buf);
          if (keyword = 'CROTA2') then
          begin
            crota2 := strtofloat(buf);
            rotaok := True;
          end;
          if (keyword = 'CD1_1') then
          begin
            cd1_1 := strtofloat(buf);
            cdok := True;
          end;
          if (keyword = 'CD1_2') then
          begin
            cd1_2 := strtofloat(buf);
            cdok := True;
          end;
          if (keyword = 'CD2_1') then
          begin
            cd2_1 := strtofloat(buf);
            cdok := True;
          end;
          if (keyword = 'CD2_2') then
          begin
            cd2_2 := strtofloat(buf);
            cdok := True;
          end;
          if (keyword = 'PC001001') then
          begin
            pc[1, 1] := strtofloat(buf);
            pcok := True;
          end;
          if (keyword = 'PC001002') then
          begin
            pc[1, 2] := strtofloat(buf);
            pcok := True;
          end;
          if (keyword = 'PC002001') then
          begin
            pc[2, 1] := strtofloat(buf);
            pcok := True;
          end;
          if (keyword = 'PC002002') then
          begin
            pc[2, 2] := strtofloat(buf);
            pcok := True;
          end;
          if (keyword = 'EPOCH') or (keyword = 'EQUINOX') then
          begin
            if copy(buf, 3, 4) = '2000' then
              equinox := 2000
            else if copy(buf, 3, 4) = '1950' then
              equinox := 1950
            else
              equinox := strtofloat(buf);
            if (equinox<minyeardt)or(equinox>maxyeardt) then begin
              equinox:=2000;
              valid:=false;
            end;
          end;
          if (keyword = 'RADECSYS') then
            radecsys := buf;
          if keyword = 'CONTRAS1' then
            try
              dmin := StrToInt(words(buf, '', 1, 1));   // low value for good contrast
            except
            end;
          if keyword = 'CONTRAS9' then
            try
              dmax := StrToInt(words(buf, '', 9, 1));   // high value for good contrast
            except
            end;
          if (keyword = 'END') then
            eoh := True;
        end;
        if bitpix = 0 then
          Break;
        if not valid then
          Break;
      until eoh;
      hdr_end := filepos(f);
      colormode := 1;
      if (naxis = 3) and (naxis1 = 3) then
      begin // contiguous color
        naxis1 := naxis2;
        naxis2 := naxis3;
        naxis3 := 3;
        colormode := 2;
      end;
      if (naxis = 3) and (naxis3 = 3) then
        n_axis := 3
      else
        n_axis := 1;
      if radecsys = '' then
        radecsys := '''FK4''';
      if (equinox = 0) then
        if (copy(radecsys, 2, 3) = 'FK4') then
          equinox := 1950
        else
          equinox := 2000;
    end;
  finally
    Closefile(f);
  end;
end;

procedure TFits.InfoWCScoord;
var
  n: integer;
  y, m, d: word;
  i: TcdcWCSinfo;
  fn: string;
begin
  try
    if (FFileName <> '')and(Header.valid) then
    begin
      fn := FFileName;
  {$ifdef mswindows}
      fn := UTF8ToWinCP(fn);
  {$endif}
      n := cdcwcs_initfitsfile(PChar(fn), 0);
      n := cdcwcs_getinfo(addr(i), 0);
      if VerboseMsg then
        WriteTrace('cdcwcs_getinfo ' + IntToStr(n) + ' ra:' + formatfloat(f5, i.cra) +
          ' de:' + formatfloat(f5, i.cdec) + ' w:' + IntToStr(i.wp) + ' h:' + IntToStr(
          i.hp) + ' s:' + formatfloat(f6, i.secpix));
      if (n = 0) and (i.secpix <> 0) then
      begin
        Fra := deg2rad * i.cra;
        Fde := deg2rad * i.cdec;
        y := trunc(i.eqout);
        m := trunc(frac(i.eqout) * 12) + 1;
        d := trunc(frac(frac(i.eqout) * 12) * 30) + 1;
        Fjd := jd(y, m, d, 12.0);
        Fimg_width := deg2rad * i.wp * i.secpix / 3600;
        Fimg_Height := deg2rad * i.hp * i.secpix / 3600;
        Frotation := deg2rad * i.rot;
        FWCSvalid := True;
      end
      else
      begin
        FWCSvalid := False;
        WriteTrace('Invalid WCS in file');
      end;
    end;
  except
    FWCSvalid := False;
  end;
end;

procedure TFits.FITSCoord;
var
  cmethod: integer;
  ic, jc, x, y: double;
  cosr, sinr: extended;
  buf: string;
begin
  Fheader.coordinate_valid := False;
  Fimg_width := 0;
  Fimg_Height := 0;
  if (copy(Fheader.ctype1, 2, 4) = 'RA--') and (copy(Fheader.ctype2, 2, 4) = 'DEC-') then
  begin
    buf := copy(Fheader.ctype1, 6, 4);
    if buf = '-TAN' then
      Fprojection := 'TAN'
    else if buf = '-SIN' then
      Fprojection := 'SIN'
    else if buf = '-ARC' then
      Fprojection := 'ARC'
    else if buf = '-CAR' then
      Fprojection := 'CAR'
    else
      Fprojection := 'ARC';
    if Fheader.pcok then
      cmethod := 1
    else
    if Fheader.cdok then
      cmethod := 2
    else
    if Fheader.rotaok then
      cmethod := 3
    else
      cmethod := 99;
    ic := Fheader.naxis1 / 2 - Fheader.crpix1 + 0.5;
    jc := Fheader.naxis2 / 2 - Fheader.crpix2 + 0.5;
    case cmethod of
      1:
      begin
        x := Fheader.pc[1, 1] * ic + Fheader.pc[1, 2] * jc;
        y := Fheader.pc[2, 1] * ic + Fheader.pc[2, 2] * jc;
        Fde := deg2rad * (Fheader.crval2 + y * Fheader.cdelt2);
        Fra := deg2rad * (Fheader.crval1 + x * Fheader.cdelt1 / cos(Fde));
        x := arctan((Fheader.cdelt2 / Fheader.cdelt1) * (Fheader.pc[2, 1] / Fheader.pc[1, 1]));
        y := arctan(-(Fheader.cdelt1 / Fheader.cdelt2) * (Fheader.pc[1, 2] / Fheader.pc[2, 2]));
        Frotation := -(x + y) / 2;
        Fimg_width := deg2rad * abs(Fheader.naxis1 * Fheader.cdelt1);
        Fimg_Height := deg2rad * abs(Fheader.naxis2 * Fheader.cdelt2);
        Fheader.coordinate_valid := True;
      end;
      2:
      begin
        x := Fheader.cd1_1 * ic + Fheader.cd1_2 * jc;
        y := Fheader.cd2_1 * ic + Fheader.cd2_2 * jc;
        Fde := deg2rad * (Fheader.crval2 + y);
        Fra := deg2rad * (Fheader.crval1 + x / cos(Fde));
        //   x:=arctan2(Fheader.cd2_1,Fheader.cd1_1);
        y := arctan2(-Fheader.cd1_2, Fheader.cd2_2);
        //   Frotation:=-(x+y)/2;
        Frotation := -y;
        Fimg_width := deg2rad * abs(Fheader.naxis1 * Fheader.cd1_1);
        Fimg_Height := deg2rad * abs(Fheader.naxis2 * Fheader.cd2_2);
        Fheader.coordinate_valid := True;
      end;
      3:
      begin
        Frotation := -Fheader.crota2 * deg2rad;
        sincos(Frotation, sinr, cosr);
        x := Fheader.cdelt1 * ic * cosr + Fheader.cdelt2 * jc * sinr;
        y := Fheader.cdelt2 * jc * cosr - Fheader.cdelt1 * ic * sinr;
        Fde := deg2rad * (Fheader.crval2 + y);
        Fra := deg2rad * (Fheader.crval1 + x / cos(Fde));
        Fimg_width := deg2rad * abs(Fheader.naxis1 * Fheader.cdelt1);
        Fimg_Height := deg2rad * abs(Fheader.naxis2 * Fheader.cdelt2);
        Fheader.coordinate_valid := True;
      end;
      else
        Fimg_width := 0;
    end;
  end;
{if (copy(ctype1,2,4)='GLON')and(copy(ctype2,2,4)='GLAT') then begin
  buf:=copy(ctype1,6,4);
  if buf='-TAN' then projfits:='T'
  else if buf='-SIN' then projfits:='S'
  else if buf='-ARC' then projfits:='A'
  else if buf='-CAR' then projfits:='C'
  else projfits:='A';
  if pcok then cmethod:=1
  else
  if cdok then cmethod:=2
  else
  if rotaok then cmethod:=3
  else cmethod:=99;
  ic:=(x1+(wa/2))-crpix1;
  jc:=(hi-y1-(ha/2))-crpix2;
  case cmethod of
  1 : begin
        x:=pc[1,1]*ic + pc[1,2]*jc;
        y:=pc[2,1]*ic + pc[2,2]*jc;
        de:=(crval2 + y*cdelt2);
        ar:=(crval1 + x*cdelt1/cos(degtorad(de)) );
        x:=radtodeg( arctan( (cdelt2/cdelt1)*(pc[2,1]/pc[1,1]) ) );
        y:=radtodeg( arctan(-(cdelt1/cdelt2)*(pc[1,2]/pc[2,2]) ) );
        rot1:=-(x+y)/2;
        la:=abs(wa*cdelt1);
      end;
  2 : begin
        x:=cd1_1*ic + cd1_2*jc;
        y:=cd2_1*ic + cd2_2*jc;
        de:=(crval2 + y);
        ar:=(crval1 + x/cos(degtorad(de)) );
        x:=radtodeg(arctan(cd2_1/cd1_1));
        y:=radtodeg(arctan(-cd1_2/cd2_2));
        rot1:=-(x+y)/2;
        la:=abs(wa*cd1_1);
      end;
  3 : begin
        rot1:=-crota2;
        cosr:=cos(degtorad(rot1));
        sinr:=sin(degtorad(rot1));
        x:=cdelt1*ic*cosr+cdelt2*jc*sinr;
        y:=cdelt2*jc*cosr-cdelt1*ic*sinr;
        de:=(crval2 + y);
        ar:=(crval1 + x/cos(degtorad(de)) );
        la:=abs(wa*cdelt1);
      end;
  else la:=0;
  end;
  GalacticToEquator(ar,de,ar,de,R);
  rot1:=rot1-R;
end;  }
  if Fheader.equinox <> 2000 then
    if (copy(Fheader.radecsys, 2, 3) = 'FK4') then
      precessionFK4(jd(trunc(Fheader.equinox), round(frac(Fheader.equinox) * 12), 1, 0),
        jd2000, Fra, Fde)
    else
      precession(jd(trunc(Fheader.equinox), round(frac(Fheader.equinox) * 12), 1, 0),
        jd2000, Fra, Fde);
end;

procedure TFits.ReadFitsImage;
var
  i, ii, j, n, npix, k: integer;
  x: double;
  f: file;
  ni, sum, sum2: extended;
begin

  if Fheader.naxis1 = 0 then
    exit;

  filemode := fmShareDenyNone;
  assignfile(f, FFileName);
  reset(f, 1);
  dmin := 1.0E100;
  dmax := -1.0E100;
  sum := 0;
  sum2 := 0;
  ni := 0;

  if n_axis = 3 then
    cur_axis := 1
  else
  begin
    cur_axis := trunc(min(cur_axis, Fheader.naxis3));
    cur_axis := trunc(max(cur_axis, 1));
  end;

  Fheight := trunc(min(maxl, Fheader.naxis2));
  Fwidth := trunc(min(maxl, Fheader.naxis1));

  case Fheader.bitpix of
    -64:
    begin
      setlength(imar64, n_axis, Fheight, Fwidth);
      seek(f, hdr_end + Fheader.naxis2 * Fheader.naxis1 * 8 * (cur_axis - 1));
    end;
    -32:
    begin
      setlength(imar32, n_axis, Fheight, Fwidth);
      seek(f, hdr_end + Fheader.naxis2 * Fheader.naxis1 * 4 * (cur_axis - 1));
    end;
    8:
    begin
      setlength(imai8, n_axis, Fheight, Fwidth);
      seek(f, hdr_end + Fheader.naxis2 * Fheader.naxis1 * (cur_axis - 1));
    end;
    16:
    begin
      setlength(imai16, n_axis, Fheight, Fwidth);
      seek(f, hdr_end + Fheader.naxis2 * Fheader.naxis1 * 2 * (cur_axis - 1));
    end;
    32:
    begin
      setlength(imai32, n_axis, Fheight, Fwidth);
      seek(f, hdr_end + Fheader.naxis2 * Fheader.naxis1 * 4 * (cur_axis - 1));
    end;
  end;

  npix := 0;

  case Fheader.bitpix of
    -64: for k := cur_axis - 1 to cur_axis + n_axis - 2 do
      begin
        for i := 0 to Fheader.naxis2 - 1 do
        begin
          ii := Fheader.naxis2 - 1 - i;
          for j := 0 to Fheader.naxis1 - 1 do
          begin
            if (npix mod 360 = 0) then
            begin
              BlockRead(f, d64, sizeof(d64), n);
              npix := 0;
            end;
            Inc(npix);
            x := InvertF64(d64[npix]);
            if x = Fheader.blank then
              x := 0;
            if (ii <= maxl - 1) and (j <= maxl - 1) then
              imar64[k, ii, j] := x;
            x := Fheader.bzero + Fheader.bscale * x;
            dmin := min(x, dmin);
            dmax := max(x, dmax);
            sum := sum + x;
            sum2 := sum2 + x * x;
            ni := ni + 1;
          end;
        end;
      end;
    -32: for k := cur_axis - 1 to cur_axis + n_axis - 2 do
      begin
        for i := 0 to Fheader.naxis2 - 1 do
        begin
          ii := Fheader.naxis2 - 1 - i;
          for j := 0 to Fheader.naxis1 - 1 do
          begin
            if (npix mod 720 = 0) then
            begin
              BlockRead(f, d32, sizeof(d32), n);
              npix := 0;
            end;
            Inc(npix);
            x := InvertF32(d32[npix]);
            if x = Fheader.blank then
              x := 0;
            if (ii <= maxl - 1) and (j <= maxl - 1) then
              imar32[k, ii, j] := x;
            x := Fheader.bzero + Fheader.bscale * x;
            dmin := min(x, dmin);
            dmax := max(x, dmax);
            sum := sum + x;
            sum2 := sum2 + x * x;
            ni := ni + 1;
          end;
        end;
      end;
    8: if colormode = 1 then
        for k := cur_axis - 1 to cur_axis + n_axis - 2 do
        begin
          for i := 0 to Fheader.naxis2 - 1 do
          begin
            ii := Fheader.naxis2 - 1 - i;
            for j := 0 to Fheader.naxis1 - 1 do
            begin
              if (npix mod 2880 = 0) then
              begin
                BlockRead(f, d8, sizeof(d8), n);
                npix := 0;
              end;
              Inc(npix);
              x := d8[npix];
              if x = Fheader.blank then
                x := 0;
              if (ii <= maxl - 1) and (j <= maxl - 1) then
                imai8[k, ii, j] := round(x);
              x := Fheader.bzero + Fheader.bscale * x;
              dmin := min(x, dmin);
              dmax := max(x, dmax);
              sum := sum + x;
              sum2 := sum2 + x * x;
              ni := ni + 1;
            end;
          end;
        end
      else
        for i := 0 to Fheader.naxis2 - 1 do
        begin
          ii := Fheader.naxis2 - 1 - i;
          for j := 0 to Fheader.naxis1 - 1 do
          begin
            for k := cur_axis + n_axis - 2 downto cur_axis - 1 do
            begin
              if (npix mod 2880 = 0) then
              begin
                BlockRead(f, d8, sizeof(d8), n);
                npix := 0;
              end;
              Inc(npix);
              x := d8[npix];
              if x = Fheader.blank then
                x := 0;
              if (ii <= maxl - 1) and (j <= maxl - 1) then
                imai8[k, ii, j] := round(x);
              x := Fheader.bzero + Fheader.bscale * x;
              dmin := min(x, dmin);
              dmax := max(x, dmax);
              sum := sum + x;
              sum2 := sum2 + x * x;
              ni := ni + 1;
            end;
          end;
        end;

    16: for k := cur_axis - 1 to cur_axis + n_axis - 2 do
      begin
        for i := 0 to Fheader.naxis2 - 1 do
        begin
          ii := Fheader.naxis2 - 1 - i;
          for j := 0 to Fheader.naxis1 - 1 do
          begin
            if (npix mod 1440 = 0) then
            begin
              BlockRead(f, d16, sizeof(d16), n);
              npix := 0;
            end;
            Inc(npix);
            x := InvertI16(d16[npix]);
            if x = Fheader.blank then
              x := 0;
            if (ii <= maxl - 1) and (j <= maxl - 1) then
              imai16[k, ii, j] := round(x);
            x := Fheader.bzero + Fheader.bscale * x;
            dmin := min(x, dmin);
            dmax := max(x, dmax);
            sum := sum + x;
            sum2 := sum2 + x * x;
            ni := ni + 1;
          end;
        end;
      end;
    32: for k := cur_axis - 1 to cur_axis + n_axis - 2 do
      begin
        for i := 0 to Fheader.naxis2 - 1 do
        begin
          ii := Fheader.naxis2 - 1 - i;
          for j := 0 to Fheader.naxis1 - 1 do
          begin
            if (npix mod 720 = 0) then
            begin
              BlockRead(f, d32, sizeof(d32), n);
              npix := 0;
            end;
            Inc(npix);
            x := InvertI32(d32[npix]);
            if x = Fheader.blank then
              x := 0;
            if (ii <= maxl - 1) and (j <= maxl - 1) then
              imai32[k, ii, j] := round(x);
            x := Fheader.bzero + Fheader.bscale * x;
            dmin := min(x, dmin);
            dmax := max(x, dmax);
            sum := sum + x;
            sum2 := sum2 + x * x;
            ni := ni + 1;
          end;
        end;
      end;
    //     else begin msg:=appmsg[1]+' "BITPIX = '+inttostr(px)+'" ?'; end;
  end;
  closefile(f);
  Fmean := sum / ni;
  Fsigma := sqrt((sum2 / ni) - (Fmean * Fmean));
  if (Fheader.dmin = 0) and (Fheader.dmax = 0) then
  begin
    if Fitt = ittramp then
    begin
      Fheader.dmin := max(dmin, Fmean - 5 * Fsigma);
      Fheader.dmax := min(dmax, Fmean + 5 * Fsigma);
    end
    else
    begin
      Fheader.dmin := dmin;
      Fheader.dmax := dmax;
    end;
  end;
  FImageLoaded := True;
end;

function TFits.Citt(Value: word): word;
begin
  case Fitt of
    ittlinear:
    begin
      // Linear
      Result := Value;
    end;
    ittramp:
    begin
      // Ramp
      Result := Value;
    end;
    ittsqrt:
    begin
      // sqrt
      if Value = 0 then
        Result := 0
      else
        Result := round(Cittsqrt * sqrt(Value));
    end;
    ittlog:
    begin
      // Log
      if Value = 0 then
        Result := 0
      else
        Result := round(Cittlog * ln(Value));
    end;
    else
      Result := Value;
  end;
end;

function TFits.Citt8(Value: word): byte;
begin
  case Fitt of
    ittlinear:
    begin
      // Linear
      Result := Value div 256;
    end;
    ittramp:
    begin
      // Ramp
      Result := Value div 256;
    end;
    ittsqrt:
    begin
      // sqrt
      if Value = 0 then
        Result := 0
      else
        Result := round(Cittsqrt8 * sqrt(Value));
    end;
    ittlog:
    begin
      // Log
      if Value = 0 then
        Result := 0
      else
        Result := round(Cittlog8 * ln(Value));
    end;
    else
      Result := Value div 256;
  end;
end;

procedure TFits.GetIntfImg(var IntfImg: TLazIntfImage);
var
  i, j, row: integer;
  x: word;
  xx: extended;
  c: double;
  color: TFPColor;
begin
  if not FImageLoaded then
    ReadFitsImage;
  IntfImg.SetSize(Fwidth, Fheight);
  dmin := Fheader.dmin + Fmin_sigma * Fsigma;
  dmax := Fheader.dmax - Fmax_sigma * Fsigma;
  if dmin >= dmax then
    dmax := dmin + 1;
  c := MaxWord / (dmax - dmin);
  color.alpha := 65535;
  case Fheader.bitpix of
    -64: for i := 0 to Fheight - 1 do
      begin
        row := i;
        for j := 0 to Fwidth - 1 do
        begin
          xx := Fheader.bzero + Fheader.bscale * imar64[0, i, j];
          x := trunc(max(0, min(MaxWord, (xx - dmin) * c)));
          color.red := Citt(x);
          if n_axis = 3 then
          begin
            xx := Fheader.bzero + Fheader.bscale * imar64[1, i, j];
            x := trunc(max(0, min(MaxWord, (xx - dmin) * c)));
            color.green := Citt(x);
            xx := Fheader.bzero + Fheader.bscale * imar64[2, i, j];
            x := trunc(max(0, min(MaxWord, (xx - dmin) * c)));
            color.blue := Citt(x);
          end
          else
          begin
            color.green := color.red;
            color.blue := color.red;
          end;
          IntfImg.Colors[j, row] := color;
        end;
      end;
    -32: for i := 0 to Fheight - 1 do
      begin
        row := i;
        for j := 0 to Fwidth - 1 do
        begin
          xx := Fheader.bzero + Fheader.bscale * imar32[0, i, j];
          x := trunc(max(0, min(MaxWord, (xx - dmin) * c)));
          color.red := Citt(x);
          if n_axis = 3 then
          begin
            xx := Fheader.bzero + Fheader.bscale * imar32[1, i, j];
            x := trunc(max(0, min(MaxWord, (xx - dmin) * c)));
            color.green := Citt(x);
            xx := Fheader.bzero + Fheader.bscale * imar32[2, i, j];
            x := trunc(max(0, min(MaxWord, (xx - dmin) * c)));
            color.blue := Citt(x);
          end
          else
          begin
            color.green := color.red;
            color.blue := color.red;
          end;
          IntfImg.Colors[j, row] := color;
        end;
      end;
    8: for i := 0 to Fheight - 1 do
      begin
        row := i;
        for j := 0 to Fwidth - 1 do
        begin
          xx := Fheader.bzero + Fheader.bscale * imai8[0, i, j];
          x := trunc(max(0, min(MaxWord, (xx - dmin) * c)));
          color.red := Citt(x);
          if n_axis = 3 then
          begin
            xx := Fheader.bzero + Fheader.bscale * imai8[1, i, j];
            x := trunc(max(0, min(MaxWord, (xx - dmin) * c)));
            color.green := Citt(x);
            xx := Fheader.bzero + Fheader.bscale * imai8[2, i, j];
            x := trunc(max(0, min(MaxWord, (xx - dmin) * c)));
            color.blue := Citt(x);
          end
          else
          begin
            color.green := color.red;
            color.blue := color.red;
          end;
          IntfImg.Colors[j, row] := color;
        end;
      end;
    16: for i := 0 to Fheight - 1 do
      begin
        row := i;
        for j := 0 to Fwidth - 1 do
        begin
          xx := Fheader.bzero + Fheader.bscale * imai16[0, i, j];
          x := trunc(max(0, min(MaxWord, (xx - dmin) * c)));
          color.red := Citt(x);
          if n_axis = 3 then
          begin
            xx := Fheader.bzero + Fheader.bscale * imai16[1, i, j];
            x := trunc(max(0, min(MaxWord, (xx - dmin) * c)));
            color.green := Citt(x);
            xx := Fheader.bzero + Fheader.bscale * imai16[2, i, j];
            x := trunc(max(0, min(MaxWord, (xx - dmin) * c)));
            color.blue := Citt(x);
          end
          else
          begin
            color.green := color.red;
            color.blue := color.red;
          end;
          IntfImg.Colors[j, row] := color;
        end;
      end;
    32: for i := 0 to Fheight - 1 do
      begin
        row := i;
        for j := 0 to Fwidth - 1 do
        begin
          xx := Fheader.bzero + Fheader.bscale * imai32[0, i, j];
          x := trunc(max(0, min(MaxWord, (xx - dmin) * c)));
          color.red := Citt(x);
          if n_axis = 3 then
          begin
            xx := Fheader.bzero + Fheader.bscale * imai32[1, i, j];
            x := trunc(max(0, min(MaxWord, (xx - dmin) * c)));
            color.green := Citt(x);
            xx := Fheader.bzero + Fheader.bscale * imai32[2, i, j];
            x := trunc(max(0, min(MaxWord, (xx - dmin) * c)));
            color.blue := Citt(x);
          end
          else
          begin
            color.green := color.red;
            color.blue := color.red;
          end;
          IntfImg.Colors[j, row] := color;
        end;
      end;
  end;
end;

procedure TFits.GetBitmap(var imabmp: Tbitmap);
var
  IntfImg: TLazIntfImage;
  ImgHandle, ImgMaskHandle: HBitmap;
begin
  imabmp.freeimage;
  imabmp.Height := 1;
  imabmp.Width := 1;
  if Fheader.naxis1 > 0 then
  begin
    IntfImg := TLazIntfImage.Create(0, 0);
    IntfImg.LoadFromBitmap(imabmp.Handle, 0);
    GetIntfImg(IntfImg);
    IntfImg.CreateBitmaps(ImgHandle, ImgMaskHandle, False);
    imabmp.freeimage;
    imabmp.SetHandles(ImgHandle, ImgMaskHandle);
    IntfImg.Free;
  end;
end;

procedure TFits.GetBGRABitmap(var bgra: TBGRABitmap);
var
  i, j: integer;
  x: word;
  xx: extended;
  c: double;
  p: PBGRAPixel;
begin
  if not FImageLoaded then
    ReadFitsImage;
  bgra.SetSize(Fwidth, Fheight);
  dmin := Fheader.dmin + Fmin_sigma * Fsigma;
  dmax := Fheader.dmax - Fmax_sigma * Fsigma;
  if dmin >= dmax then
    dmax := dmin + 1;
  c := MaxWord / (dmax - dmin);
  case Fheader.bitpix of
    -64: for i := 0 to Fheight - 1 do
      begin
        p := bgra.Scanline[i];
        for j := 0 to Fwidth - 1 do
        begin
          xx := Fheader.bzero + Fheader.bscale * imar64[0, i, j];
          x := trunc(max(0, min(MaxWord, (xx - dmin) * c)));
          p^.red := Citt8(x);
          if n_axis = 3 then
          begin
            xx := Fheader.bzero + Fheader.bscale * imar64[1, i, j];
            x := trunc(max(0, min(MaxWord, (xx - dmin) * c)));
            p^.green := Citt8(x);
            xx := Fheader.bzero + Fheader.bscale * imar64[2, i, j];
            x := trunc(max(0, min(MaxWord, (xx - dmin) * c)));
            p^.blue := Citt8(x);
          end
          else
          begin
            p^.green := p^.red;
            p^.blue := p^.red;
          end;
          p^.alpha := 255;
          Inc(p);
        end;
      end;
    -32: for i := 0 to Fheight - 1 do
      begin
        p := bgra.Scanline[i];
        for j := 0 to Fwidth - 1 do
        begin
          xx := Fheader.bzero + Fheader.bscale * imar32[0, i, j];
          x := trunc(max(0, min(MaxWord, (xx - dmin) * c)));
          p^.red := Citt8(x);
          if n_axis = 3 then
          begin
            xx := Fheader.bzero + Fheader.bscale * imar32[1, i, j];
            x := trunc(max(0, min(MaxWord, (xx - dmin) * c)));
            p^.green := Citt8(x);
            xx := Fheader.bzero + Fheader.bscale * imar32[2, i, j];
            x := trunc(max(0, min(MaxWord, (xx - dmin) * c)));
            p^.blue := Citt8(x);
          end
          else
          begin
            p^.green := p^.red;
            p^.blue := p^.red;
          end;
          p^.alpha := 255;
          Inc(p);
        end;
      end;
    8: for i := 0 to Fheight - 1 do
      begin
        p := bgra.Scanline[i];
        for j := 0 to Fwidth - 1 do
        begin
          xx := Fheader.bzero + Fheader.bscale * imai8[0, i, j];
          x := trunc(max(0, min(MaxWord, (xx - dmin) * c)));
          p^.red := Citt8(x);
          if n_axis = 3 then
          begin
            xx := Fheader.bzero + Fheader.bscale * imai8[1, i, j];
            x := trunc(max(0, min(MaxWord, (xx - dmin) * c)));
            p^.green := Citt8(x);
            xx := Fheader.bzero + Fheader.bscale * imai8[2, i, j];
            x := trunc(max(0, min(MaxWord, (xx - dmin) * c)));
            p^.blue := Citt8(x);
          end
          else
          begin
            p^.green := p^.red;
            p^.blue := p^.red;
          end;
          p^.alpha := 255;
          Inc(p);
        end;
      end;
    16: for i := 0 to Fheight - 1 do
      begin
        p := bgra.Scanline[i];
        for j := 0 to Fwidth - 1 do
        begin
          xx := Fheader.bzero + Fheader.bscale * imai16[0, i, j];
          x := trunc(max(0, min(MaxWord, (xx - dmin) * c)));
          p^.red := Citt8(x);
          if n_axis = 3 then
          begin
            xx := Fheader.bzero + Fheader.bscale * imai16[1, i, j];
            x := trunc(max(0, min(MaxWord, (xx - dmin) * c)));
            p^.green := Citt8(x);
            xx := Fheader.bzero + Fheader.bscale * imai16[2, i, j];
            x := trunc(max(0, min(MaxWord, (xx - dmin) * c)));
            p^.blue := Citt8(x);
          end
          else
          begin
            p^.green := p^.red;
            p^.blue := p^.red;
          end;
          p^.alpha := 255;
          Inc(p);
        end;
      end;
    32: for i := 0 to Fheight - 1 do
      begin
        p := bgra.Scanline[i];
        for j := 0 to Fwidth - 1 do
        begin
          xx := Fheader.bzero + Fheader.bscale * imai32[0, i, j];
          x := trunc(max(0, min(MaxWord, (xx - dmin) * c)));
          p^.red := Citt8(x);
          if n_axis = 3 then
          begin
            xx := Fheader.bzero + Fheader.bscale * imai32[1, i, j];
            x := trunc(max(0, min(MaxWord, (xx - dmin) * c)));
            p^.green := Citt8(x);
            xx := Fheader.bzero + Fheader.bscale * imai32[2, i, j];
            x := trunc(max(0, min(MaxWord, (xx - dmin) * c)));
            p^.blue := Citt8(x);
          end
          else
          begin
            p^.green := p^.red;
            p^.blue := p^.red;
          end;
          p^.alpha := 255;
          Inc(p);
        end;
      end;
  end;
  bgra.InvalidateBitmap;
end;

procedure pixelatcoord(ra, de: double; var x, y: integer; wcsnum: integer = 0);
var
  p: TcdcWCScoord;
begin
  try
    p.ra := rad2deg * ra;
    p.Dec := rad2deg * de;
    cdcwcs_sky2xy(addr(p), wcsnum);
    if p.n = 0 then
    begin
      x := round(p.x - 0.5);
      y := round(p.y + 0.5);
    end
    else
    begin
      x := -1;
      y := -1;
    end;
  except
    x := -1;
    y := -1;
  end;
end;

constructor TDrawProjThread.Create(CreateSuspended: boolean);
begin
  FreeOnTerminate := True;
  inherited Create(CreateSuspended);
  working := True;
end;

procedure TDrawProjThread.Execute;
// not used for now
var
  ra, Dec: double;
  i, j, startline, endline, x, y: integer;
begin
  i := cfgsc.ymax div num;
  startline := id * i;
  if id = (num - 1) then
    endline := cfgsc.ymax - 1
  else
    endline := (id + 1) * i - 1;
  for i := startline to endline do
  begin
    for j := 0 to cfgsc.xmax - 1 do
    begin
      if Terminated then
        exit;
      getadxy(j, i, ra, Dec, cfgsc);
      if smallfov then
      begin
        ra := ra + ra_offset;
        Dec := Dec + de_offset;
      end
      else
      begin
        if cfgsc.ApparentPos then
          mean_equatorial(ra, Dec, cfgsc, True, True);
        Precession(cfgsc.JDChart, imgjd, ra, Dec);
      end;
      pixelatcoord(ra, Dec, x, y);
      if (x >= 0) and (x < Fw) and (y >= 0) and (y < Fh) then
        ProjImg.Colors[j, i] := IntfImg.Colors[x, Fh - y]
      else
        ProjImg.Colors[j, i] := colTransparent;
    end;
  end;
  working := False;
end;

procedure TFits.GetProjBitmap(var imabmp: Tbitmap; c: Tconf_skychart);
// not used for now
var
  IntfImg, ProjImg: TLazIntfImage;
  ImgHandle, ImgMaskHandle: HBitmap;
  i, n: integer;
  ra_offset, de_offset: double;
  working, timeout: boolean;
  timelimit: TDateTime;
  thread: array[0..3] of TDrawProjThread;
begin
  try
    imabmp.freeimage;
    imabmp.Height := 1;
    imabmp.Width := 1;
    InfoWCScoord;
    if FWCSvalid and (Fheader.naxis1 > 0) then
    begin
      IntfImg := TLazIntfImage.Create(0, 0);
      ProjImg := TLazIntfImage.Create(0, 0);
      IntfImg.LoadFromBitmap(imabmp.Handle, 0);
      ProjImg.LoadFromBitmap(imabmp.Handle, 0);
      GetIntfImg(IntfImg);
      ProjImg.SetSize(c.xmax, c.ymax);
      ra_offset := Fra;
      de_offset := Fde;
      if c.ApparentPos then
        mean_equatorial(ra_offset, de_offset, c, True, True);
      Precession(c.JDChart, Fjd, ra_offset, de_offset);
      ra_offset := ra_offset - Fra;
      de_offset := de_offset - Fde;
      n := min(4, MaxThreadCount);
      for i := 0 to n - 1 do
      begin
        thread[i] := TDrawProjThread.Create(True);
        thread[i].IntfImg := IntfImg;
        thread[i].ProjImg := ProjImg;
        thread[i].ra_offset := ra_offset;
        thread[i].de_offset := de_offset;
        thread[i].imgjd := Fjd;
        thread[i].Fw := Fwidth;
        thread[i].Fh := Fheight;
        thread[i].smallfov := (rad2deg * Fimg_width) < 1;
        thread[i].cfgsc := c;
        thread[i].num := n;
        thread[i].id := i;
        thread[i].Start;
      end;
      timelimit := now + 10 / secday;
      repeat
        sleep(10);
        working := False;
        for i := 0 to n - 1 do
          working := working or thread[i].working;
        timeout := (now > timelimit);
      until (not working) or timeout;
      if timeout then
      begin
        for i := 0 to n - 1 do
          thread[i].Terminate;
        sleep(10);
      end;
      ProjImg.CreateBitmaps(ImgHandle, ImgMaskHandle, False);
      imabmp.freeimage;
      imabmp.SetHandles(ImgHandle, ImgMaskHandle);
      IntfImg.Free;
      ProjImg.Free;
      cdcwcs_release(0);
    end;
  except
  end;
end;


constructor TDrawListThread.Create(CreateSuspended: boolean);
begin
  FreeOnTerminate := True;
  inherited Create(CreateSuspended);
  working := True;
end;

procedure TDrawListThread.Execute;
var
  ra, Dec, ra0, dec0: double;
  i, j, k, startline, endline, x, y,xs,ys: integer;
begin
  xs:= ProjImg.Width;
  ys:= ProjImg.Height;
  ra := 0;
  Dec := 0;
  i := ys div num;
  startline := id * i;
  if id = (num - 1) then
    endline := ys - 1
  else
    endline := (id + 1) * i - 1;
  for i := startline to endline do
  begin
    for j := 0 to xs - 1 do
    begin
      if Terminated then
        exit;
      getadxy(round(j*scaling) , round(i*scaling) , ra0, dec0, cfgsc);
      if samejd and (not smallfov) then
      begin
        ra := ra0;
        Dec := dec0;
        if cfgsc.ApparentPos then
          mean_equatorial(ra, Dec, cfgsc, True, True);
        Precession(cfgsc.JDChart, imgjd, ra, Dec);
      end;
      for k := 0 to filecount - 1 do
      begin
        if k > maxfitslist then
          break;
        if smallfov then
        begin
          ra := ra0 + ra_offset[k];
          Dec := dec0 + de_offset[k];
        end
        else if (not samejd) then
        begin
          ra := ra0;
          Dec := dec0;
          if cfgsc.ApparentPos then
            mean_equatorial(ra, Dec, cfgsc, True, True);
          Precession(cfgsc.JDChart, imgjd, ra, Dec);
        end;
        pixelatcoord(ra, Dec, x, y, k);
        if (x >= 0) and (x < Fw[k]) and (y >= 0) and (y < Fh[k]) then
          ProjImg.Colors[j, i] := IntfImg[k].Colors[x, Fh[k] - y];
      end;
    end;
  end;
  working := False;
end;

procedure TFits.GetProjList(var imabmp: Tbitmap; c: Tconf_skychart);
var
  IntfImg: TDrawListImg;
  ra_offset, de_offset, ljd: TDrawListdouble;
  iwidth, iheight: TDrawListInteger;
  iwcs: TcdcWCSinfo;
  smallfov, samejd: boolean;
  ijd, scaling,nsc: double;
  ProjImg: TLazIntfImage;
  ImgHandle, ImgMaskHandle: HBitmap;
  i, n, r, tc, imgloaded, timeout: integer;
  y, m, d: word;
  working, timingout: boolean;
  timelimit: TDateTime;
  thread: array[0..15] of TDrawListThread;
  fn: string;
begin
  try
    imabmp.freeimage;
    imabmp.Height := 1;
    imabmp.Width := 1;
    smallfov := True;
    samejd := True;

    n := 0;
    for i := 0 to fitslist.Count - 1 do
    begin
      if n > maxfitslist then
        break;
      if fitslistactive[i] then
      begin
        fn := fitslist[i];
   {$ifdef mswindows}
        fn := UTF8ToWinCP(fn);
   {$endif}
        r := cdcwcs_initfitsfile(PChar(fn), n);
        r := cdcwcs_getinfo(addr(iwcs), n);
        if (r = 0) and (iwcs.secpix <> 0) then
        begin
          if VerboseMsg then
            WriteTrace('SkyChart ' + c.chartname + ': load ' + fitslist[i]);
          FileName := fitslist[i];
          IntfImg[n] := TLazIntfImage.Create(0, 0);
          IntfImg[n].LoadFromBitmap(imabmp.Handle, 0);
          GetIntfImg(IntfImg[n]);
          y := trunc(iwcs.eqout);
          m := trunc(frac(iwcs.eqout) * 12) + 1;
          d := trunc(frac(frac(iwcs.eqout) * 12) * 30) + 1;
          ljd[n] := jd(y, m, d, 12.0);
          if n = 0 then
            ijd := ljd[n]
          else
          if ijd <> ljd[n] then
            samejd := False;
          ra_offset[n] := c.racentre;
          de_offset[n] := c.decentre;
          if c.ApparentPos then
            mean_equatorial(ra_offset[n], de_offset[n], c, True, True);
          Precession(c.JDChart, ljd[n], ra_offset[n], de_offset[n]);
          ra_offset[n] := ra_offset[n] - c.racentre;
          de_offset[n] := de_offset[n] - c.decentre;
          iwidth[n] := Fwidth;
          iheight[n] := Fheight;
          smallfov := smallfov and ((iwcs.wp * iwcs.secpix / 3600) < 1) and (abs(iwcs.cdec)<80);
          Inc(n);
        end;
      end;
    end;
    imgloaded := n;

    // number of thread
    tc := max(1,min(16, MaxThreadCount)); // based on number of core
    tc := max(1,min(tc,c.ymax div 100));  // do not split the image too much
    // limit size of computed image
    nsc:=max(1,1+(imgloaded-3)/15);       // factor for number of simultaneous images
    scaling:=min(6,nsc*(c.xmax*c.ymax)/1E6/tc/0.5);  // compute max 0.5 million pixel per core
    if scaling<1.1 then scaling:=1;       // for 10% it is not worth rescaling
    // initialize image
    ProjImg := TLazIntfImage.Create(0, 0);
    ProjImg.LoadFromBitmap(imabmp.Handle, 0);
    ProjImg.SetSize(round(c.xmax/scaling), round(c.ymax/scaling));
    ProjImg.FillPixels(colTransparent);

    timeout := round(max(10, c.xmax * c.ymax / tc / 50000));
    if VerboseMsg then
      WriteTrace('SkyChart ' + c.chartname + ': start FITS thread, timeout:' + IntToStr(timeout));
    for i := 0 to tc - 1 do
    begin
      thread[i] := TDrawListThread.Create(True);
      thread[i].IntfImg := IntfImg;
      thread[i].ProjImg := ProjImg;
      thread[i].ra_offset := ra_offset;
      thread[i].de_offset := de_offset;
      thread[i].imgjd := ijd;
      thread[i].lstjd := ljd;
      thread[i].samejd := samejd;
      thread[i].Fw := iwidth;
      thread[i].Fh := iheight;
      thread[i].smallfov := smallfov;
      thread[i].filecount := imgloaded;
      thread[i].cfgsc := c;
      thread[i].num := tc;
      thread[i].id := i;
      thread[i].scaling := scaling;
      thread[i].Start;
    end;
    timelimit := now + timeout / secday;
    repeat
      sleep(100);
      working := False;
      for i := 0 to tc - 1 do
        working := working or thread[i].working;
      timingout := (now > timelimit);
    until (not working) or timingout;
    if VerboseMsg then
      WriteTrace('SkyChart ' + c.chartname + ': end thread');
    if timingout then
    begin
      for i := 0 to tc - 1 do
        thread[i].Terminate;
      sleep(10);
      WriteTrace('FITS Image timeout');
    end;
    ProjImg.CreateBitmaps(ImgHandle, ImgMaskHandle, False);
    imabmp.freeimage;
    imabmp.SetHandles(ImgHandle, ImgMaskHandle);
    for i := 0 to imgloaded - 1 do
    begin
      if i > maxfitslist then
        break;
      IntfImg[i].Free;
      cdcwcs_release(i);
    end;
    ProjImg.Free;
  except
  end;
end;

function TFits.ConnectDB(db: string): boolean;
begin
  try
    db := UTF8Encode(db);
    if db1.database <> db then
      db1.Use(db);
    dbconnected := db1.Active;
    Result := dbconnected;
    DB1.Query('PRAGMA journal_mode = MEMORY');
    DB1.Query('PRAGMA synchronous = OFF');
    DB1.Query('PRAGMA case_sensitive_like = 1');
    DB1.Query('PRAGMA cache_size = -102400');
    DB1.Query('PRAGMA temp_store = MEMORY');
  except
    dbconnected := False;
    Result := False;
  end;
end;

function TFits.OpenDB(catalogname: string; ra1, ra2, dec1, dec2: double): boolean;
var
  qry, r1, r2, d1, d2: string;
begin
  if not db1.Active then
    Result := False
  else
  begin
    r1 := formatfloat(f5, ra1);
    r2 := formatfloat(f5, ra2);
    d1 := formatfloat(f5, dec1);
    d2 := formatfloat(f5, dec2);
    qry := 'SELECT filename,objectname,ra,de,width,height,rotation from cdc_fits where ' +
      'catalogname="' + uppercase(catalogname) + '" and ';
    if ra2 > ra1 then
    begin
      qry := qry + ' ra>' + r1 + ' and ' + ' ra<' + r2;
    end
    else
    begin
      qry := qry + ' (ra>' + r1 + ' or ' + ' ra<' + r2 + ')';
    end;
    qry := qry + ' and de>' + d1 + ' and ' + ' de<' + d2 + ' order by width desc';
    db1.Query(qry);
    Result := db1.RowCount > 0;
    current_result := -1;
  end;
end;

function TFits.GetDB(var filename, objname: string;
  var ra, de, Width, Height, rot: double): boolean;
begin
  Inc(current_result);
  try
    if current_result < db1.RowCount then
    begin
      filename := db1.Results[current_result][0];
      objname := db1.Results[current_result][1];
      ra := strtofloat(string(trim(db1.Results[current_result][2])));
      de := strtofloat(string(trim(db1.Results[current_result][3])));
      Width := strtofloat(string(trim(db1.Results[current_result][4])));
      Height := strtofloat(string(trim(db1.Results[current_result][5])));
      rot := strtofloat(string(trim(db1.Results[current_result][6])));
      Result := True;
    end
    else
      Result := False;
  except
    Result := False;
  end;
end;

function TFits.ImagesForCatalog(catname: string): boolean;
var
  i: integer;
begin
  if not db1.Active then
    Result := False
  else
  begin
    i := strtointdef(db1.QueryOne('select count(*) from cdc_fits where catalogname="' +
      uppercase(trim(catname)) + '"'), 0);
    Result := (i > 0);
  end;
end;

procedure TFits.GetImagesCatalog(var imgcatlist: tstringlist);
var i: integer;
begin
  imgcatlist.clear;
  db1.query('select distinct catalogname from cdc_fits');
  for i:=0 to db1.RowCount-1 do begin
    imgcatlist.Add(db1.Results[i][0]);
  end;
end;

function TFits.GetFileName(catname, objectname: string; var filename: string): boolean;
begin
  if not db1.Active then
    Result := False
  else
  begin
    filename := db1.QueryOne('SELECT filename from cdc_fits where ' +
      'catalogname="' + uppercase(trim(catname)) + '" and ' +
      'objectname="' + uppercase(stringreplace(objectname, blank, '',
      [rfReplaceAll])) + '" ');
    Result := filename <> '';
  end;
end;

function TFits.InsertDB(fname, cname, oname: string;
  ra, de, Width, Height, rotation: double): boolean;
var
  cmd: string;
begin
  if not db1.Active then
    Result := False
  else
  begin
    oname := uppercase(stringreplace(oname, blank, '', [rfReplaceAll]));
    cmd := 'INSERT INTO cdc_fits (filename,catalogname,objectname,ra,de,width,height,rotation) VALUES ('
      + '"' + stringreplace(fname, '\', '\\', [rfReplaceAll]) + '"' +
      ',"' + uppercase(cname) + '"' + ',"' + uppercase(oname) + '"' +
      ',"' + formatfloat(f5, ra) + '"' + ',"' + formatfloat(f5, de) + '"' +
      ',"' + formatfloat(f5, Width) + '"' + ',"' + formatfloat(f5, Height) +
      '"' + ',"' + formatfloat(f5, rotation) + '"' + ')';
    Result := db1.query(cmd);
  end;
end;

function TFits.DeleteDB(cname, oname: string): boolean;
var
  cmd: string;
begin
  if not db1.Active then
    Result := False
  else
  begin
    oname := uppercase(stringreplace(oname, blank, '', [rfReplaceAll]));
    cname := uppercase(cname);
    cmd := 'DELETE FROM cdc_fits WHERE catalogname="' + cname +
      '" AND objectname="' + oname + '"';
    Result := db1.query(cmd);
  end;
end;

end.
