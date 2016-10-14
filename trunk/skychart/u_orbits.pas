unit u_orbits;

{$mode objfpc}{$H+}

interface

uses
  {$ifdef mswindows}
    Windows,
  {$endif}
  Classes, SysUtils, fileutil,
  BGRABitmap, BGRABitmapTypes, BGRADefaultBitmap,Graphics,
  u_constant, u_translation, cu_planet;

const
  //SZ Around Solar eclipse in August 1999, seen GRS on Jupiter
  JDBase1999 = 2451402.086111;

const
   C_Mercury  =  1;
   C_Venus    =  2;
   C_Earth    =  3;
   C_Mars     =  4;
   C_Jupiter  =  5;
   C_Saturn   =  6;
   C_Uranus   =  7;
   C_Neptune  =  8;
   C_Pluto    =  9;
   C_Sun      = 10;
   C_Moon     = 11;

   ///////////////////////////
   // Satelittes
   ///////////////////////////

    // Mars
   C_Phobos   = 29;
   C_Deimos   = 30;

   // Jupiter
   C_Io       = 12;
   C_Europa   = 13;
   C_Ganymede = 14;
   C_Callisto = 15;
   C_Amalthea = 37;
   C_Thebe    = 38;
   C_Adrastea   = 39;
   C_Metis      = 40;

   // Saturn
   C_Mimas     = 16;
   C_Enceladus = 17;
   C_Tethys    = 18;
   C_Dione     = 19;
   C_Rhea      = 20;
   C_Titan     = 21;
   C_Hyperion  = 22;
   C_Iapetus   = 23;
   C_Phoebe     = 33;
   C_Janus      = 41;
   C_Epimetheus = 42;
   C_Helene     = 43;
   C_Telesto    = 44;
   C_Calypso    = 45;
   C_Atlas      = 46;
   C_Prometheus = 47;
   C_Pandora    = 48;
   C_Pan        = 49;
   C_Daphnis    = 50;
   //
   C_SatRing  = 31;
   C_EShadow  = 32;


   // Uranus
   C_Miranda   = 24;
   C_Ariel     = 25;
   C_Umbriel   = 26;
   C_Titania   = 27;
   C_Oberon    = 28;
   C_Puck       = 60;
   C_Cordelia   = 51;
   C_Ophelia    = 52;
   C_Belinda    = 59;
   C_Perdita    = 61;
   C_Bianca     = 53;
   C_Cressida   = 54;
   C_Desdemona  = 55;
   C_Juliet     = 56;
   C_Portia     = 57;
   C_Rosalind   = 58;
   C_Cupid      = 63;

   // Meptune
   C_Triton   = 34;
   C_Nereid     = 35;
   C_Naiad      = 64;
   C_Thalassa   = 65;
   C_Despina    = 66;
   C_Galatea    = 67;
   C_Larissa    = 68;
   C_Proteus    = 69;

   // Pluto
   C_Charon   = 36;

   //SZ Patrick, on what should refer this one?
   C_Mab        = 62;

   //SZ Planets and main sattelites

//type
//  TArrInt= array of integer;

const
  Earth_Sat   : array [1..1] of integer =
                (C_Moon);

  Mars_Sat    : array [1..2] of integer =
                (C_Phobos,   C_Deimos);

 Jupiter_Sat : array [1..4] of integer =
               (C_Io,       C_Europa,     C_Ganymede,   C_Callisto);
                {,C_Amalthea, C_Thebe,      C_Adrastea,   C_Metis}

 Saturn_Sat  : array [1..8] of integer =
               (C_Mimas,     C_Enceladus,  C_Tethys,     C_Dione,
                C_Rhea,      C_Titan,      C_Hyperion,   C_Iapetus);

                {
                C_Phoebe,    C_Janus,      C_Epimetheus, C_Helene     ,
                C_Telesto,   C_Calypso,    C_Atlas,      C_Prometheus ,
                C_Pandora,   C_Pan,        C_Daphnis   }

 Uranus_Sat  : array [1..5] of integer =
               (C_Miranda,   C_Ariel,   C_Umbriel,  C_Titania,
                 C_Oberon);

                 {,    C_Puck,    C_Cordelia, C_Ophelia,
                 C_Belinda,   C_Perdita, C_Bianca,   C_Cressida,
                 C_Desdemona, C_Juliet,  C_Portia,   C_Rosalind,
                 C_Cupid];}


 Neptune_Sat : array [1..1] of integer =
               (C_Triton);

               {,  C_Nereid,  C_Naiad  ,  C_Thalassa,
                C_Despina, C_Galatea, C_Larissa,  C_Proteus];}

 Pluto_Sat   : array [1..1] of integer =
               (C_Charon);


const
  per  : array[1..9] of integer = (88,225,365,687,4332,10760,30590,59799,90553);
  col  : array[1..9] of TColor  = (clGray,clWhite,clAqua,clRed,clOlive,clWhite,clAqua,clBlue,clGray);

  //SZ real planets diameter ratio
  diam_real : array[1..9] of double  = (0.38, 0.95, 1.00, 0.53, 11.19, 9.40, 4.04, 3.88, 0.18);

  //SZ fake diameter ratio for display
  //diam_fake : array[1..9] of double  = (0.38, 0.95, 1.00, 0.70, 1.3, 1.5, 1.2, 1.2, 0.18);

  diam_fake : array[1..9] of double  = (0.80, 0.95, 1.00, 0.80, 1.20, 2.00, 1.00, 0.90, 0.80);

  Earth_Radius = 6371; // in km
var
  nbstep: integer;

  Distance: array [1..9] of record
    FromSun   : Double;
    FromEarth : Double;
    r: TPointF;
  end;

type

  TOrbits = class

    constructor Create (Aplbmp:TBGRABitmap; ATextZoom: Double);
    destructor Destroy; override;

    private
      FCurrJDTT : double;

      FTextZoom: Double;

      bmp:TBGRABitmap;

      cx,cy,fx: single;
      ps,ss: integer;

      Fplanet : Tplanet;
      Fconfig: Tconf_skychart;
      pl: TPlanData;

      FTextlabels: integer;

      procedure RecalculateOrbit(ipla: integer);

    public

      PlanetImage: array of TBGRABitmap;

      TypeOfOrbit : integer;

      IsShowLabels: Boolean;
      IsDisplayDistance: Boolean;

      Orbit_bmp:TBGRABitmap;
      RefreshOrbit : Boolean;

      xmax, xmin, ymax, ymin: integer;

      procedure PlotOrbit(ACurrJDTT: double);

      function PointXY( ipla: integer; jdt:double):TPointF;

      procedure SetPlanet(Aplanet : TPlanet);
      procedure SetConfig(AConfig : Tconf_skychart);

      procedure SetShowLabel(AShowLabels: Boolean);

      procedure SetDrawnRegion(Axmax, Axmin, Aymax, Aymin: integer);
      function PlanetDistance(pla1,pla2: integer; JD: double): double;

  end;

  function GetPlanetName(Aipla: integer): string;
  function GetPlanetParent(Aipla: integer): integer;
  function GetPlanetParentName(Aipla: integer): string;
  function GetPlanetNameLang(Aipla: integer): string;


procedure GetXplanet_Plain(Xplanetversion, searchdir,bsize,outfile : string;
  pa,grsl,jd : double; var irc:integer; var r:TStringList;
  AProjection: string; AFov: double;

  AUseOrigFile, AUseLatLong,
  AUseOrigin: Boolean; AOrigin: string;
  AUseTarget: Boolean; ATarget: string;

  AOriginLat, AOriginLong: double;
  ATargetLat, ATargetLong: double;
  ANorth: string;
  ARadius: string;
  AConfig: string;
  AUseLabels: Boolean
);

 function GetXplanet_Image(
      //Asearchdir : string;
      ABMP: TBGRABitmap;
      Aplanet:TPlanet;
      Aconfig: Tconf_skychart;
      W, H: integer;
      pa, grsl, jd : double;
      AFov: double;
      AUseOrigFile, AUseLatLong: Boolean;
      AUseOrigin: Boolean; AOrigin: Integer;
      AUseTarget: Boolean; ATarget: Integer;
      AOriginLat, AOriginLong: double;
      ATargetLat, ATargetLong: double;
      AProjection: string;
      ANorth: string;
      ARadius: string;
      AConfig_File: string;
      AUseLabels: Boolean
   ): Boolean;

  function ScaledPlanetMapDir (Aipla, ADiameter: integer): string;


implementation

uses
  math,u_util, process;

//SZ Scale planet body map and saving in dedicated tmp dir, then call xplanet from it
// TODO

function ScaledPlanetMapDir_Individual (Aipla, ADiameter: integer): string;
// As result, temp dir is returned
// ADiameter - Diameter of the resulted planet image
const
  resY : array [0..7] of integer = (32, 64, 120, 240, 320, 480, 512, 1024);
var
   fn,searchdir, tmpdir, body_in, body_out: string;
   x,y,i,idx: integer;

   bmp, bmpnew: TBGRABitmap;
   JPG : TJpegImage;
   pass: Boolean;

begin

  idx := -1;

  searchdir :=slash(appdir)+slash('data')+'planet';

  //SZ JPG only exists?
  if Aipla = C_Earth then
  begin
    body_in  := 'earth.jpg';
    body_out := body_in;
  end
  else
  if Aipla = C_Enceladus then
  begin
    body_in := 'enceladus.jpg';
    body_out := body_in;
  end
  else
  begin
    body_in := GetPlanetName(Aipla);
    body_out := body_in;

    if body_in = 'jupiter' then
      body_in := 'jupiter-0';

    //SZ It seem that xplanet require map 'jupiter.jpg' to be 'jupiter-0.jpg'

    body_in  := body_in  + '.jpg';
    body_out := body_out + '.jpg';
  end;

  i := 0;
  while  i < high(ResY) do
  begin

     if resY[i] >= ADiameter then
     begin
       idx := i;
       break;
     end;

    inc(i)
  end;

  pass := idx >= 0;

  if pass then
  begin
    tmpdir := slash(Tempdir) + inttostr(resY[idx]);

    //SZ process execution check
    pass := DirectoryExistsUTF8(tmpdir);
    if not pass then
      CreateDirUTF8(tmpdir);

    pass := DirectoryExistsUTF8(tmpdir);

    if pass then
    begin

      fn :=slash(searchdir)+'xplanet.config';

      if FileExistsUTF8(fn) then
        CopyFile( fn , slash(tmpdir) +'xplanet.config' );

      //SZ This is full variant show labels from satellites,
      //   have full magnitude for Sun and jupiter-0 does not exists

      fn :=slash(searchdir)+'xplanet2.config';

      if FileExistsUTF8(fn) then
         CopyFile( fn , slash(tmpdir) +'xplanet2.config' );


      pass :=
        FileExistsUTF8(slash(searchdir) + body_in) and
        FileExistsUTF8(slash(tmpdir)    + body_out);

      if not pass then
      begin
        fn := slash(searchdir) + body_in ;

        pass := FileExistsUTF8(fn);

        if pass then
        begin

          bmp := TBGRABitmap.Create(fn);

          if bmp.Height = 0 then
            x := 0
          else
            x := trunc(bmp.Width * resY[idx]/bmp.Height);

          y := resY[idx];

          pass := (x>0) and (y>0);

          if pass then
          begin
            bmpnew:=TBGRABitmap.Create(x,y);
            bmpnew.CanvasBGRA.StretchDraw(Rect(0,0,x,y),bmp);

            JPG := TJpegImage.Create;
            try
              JPG.CompressionQuality := 95;
              JPG.Assign(bmpnew);

              fn := slash(tmpdir) + body_out;
              JPG.SaveToFile(fn);

              //SZ for jupiter, copy to jupiter-0 as well

              if Aipla=C_Jupiter then
              begin
                fn := slash(tmpdir) + 'jupiter-0.jpg';
                JPG.SaveToFile(fn);
              end;

              pass := FileExistsUTF8(fn);

            finally

             JPG.Free;
              bmpnew.Free;
              bmp.Free;
            end;

          end;

        end;

      end

    end;
  end;

  if pass then
    result := tmpdir
  else
    result := searchdir;

end;


function ScaledPlanetMapDir(Aipla, ADiameter: integer): string;
begin

  //SZ If look on Erath, ensure Moon exists
  if Aipla = C_Earth then
    ScaledPlanetMapDir_Individual (C_Moon, ADiameter);

  if Aipla = C_moon then
    ScaledPlanetMapDir_Individual (C_Earth, ADiameter);

  //SZ If look on Jupiter, ensure 4 main sattelites exists
  if Aipla = C_Jupiter then
  begin
    ScaledPlanetMapDir_Individual (C_Io,       ADiameter);
    ScaledPlanetMapDir_Individual (C_Europa,   ADiameter);
    ScaledPlanetMapDir_Individual (C_Ganymede, ADiameter);
    ScaledPlanetMapDir_Individual (C_Callisto, ADiameter);
  end;

  //SZ If look on Saturn, ensure 5 main sattelites exists
  if Aipla = C_Saturn then
  begin
    ScaledPlanetMapDir_Individual (C_Mimas,     ADiameter);
    ScaledPlanetMapDir_Individual (C_Enceladus, ADiameter);
    ScaledPlanetMapDir_Individual (C_Tethys,    ADiameter);
    ScaledPlanetMapDir_Individual (C_Dione,     ADiameter);
    ScaledPlanetMapDir_Individual (C_Rhea,      ADiameter);
    ScaledPlanetMapDir_Individual (C_Titan,     ADiameter);
    ScaledPlanetMapDir_Individual (C_Hyperion,  ADiameter);
    ScaledPlanetMapDir_Individual (C_Iapetus,   ADiameter);
  end;

  result := ScaledPlanetMapDir_Individual (Aipla, ADiameter);

end;

procedure PrepareFileForXplanet(AFilename: string; AJD, Alat, Along: double);
var
 ft : textfile;
 buf: string;
begin

  buf:=jddate2(AJD);
  buf:=buf+' 1.0 '+formatfloat(f6,Alat)+blank+formatfloat(f6,Along);
  AssignFile(ft,Afilename);
  rewrite(ft);
  writeln(ft,buf);
  CloseFile(ft);

end;

//SZ New plain version, additional options
procedure GetXplanet_Plain(Xplanetversion, searchdir,bsize,outfile : string;
  pa,grsl,jd : double; var irc:integer; var r:TStringList;
  AProjection: string; AFov: double;

  AUseOrigFile, AUseLatLong,
  AUseOrigin: Boolean; AOrigin: string;
  AUseTarget: Boolean; ATarget: string;

  AOriginLat, AOriginLong: double;
  ATargetLat, ATargetLong: double;
  ANorth: string;
  ARadius: string;
  AConfig: string;
  AUseLabels: Boolean
);

var

 t,originfile: string;

 p:TProcess;
  {$ifdef mswindows}
  shorttmp: array[0..1024] of char;
  {$endif}
begin
 p:=TProcess.Create(nil);
 {$ifdef linux}
   p.Environment.Add('LC_ALL=C');
   p.Executable:='xplanet';
 {$endif}
 {$ifdef freebsd}
   p.Environment.Add('LC_ALL=C');
   p.Executable:='xplanet';
 {$endif}
 {$ifdef darwin}
   p.Environment.Add('LC_ALL=C');
   p.Executable:=slash(appdir)+slash(xplanet_dir)+'xplanet';
 {$endif}
 {$ifdef mswindows}
   p.Executable:=slash(appdir)+slash(xplanet_dir)+'xplanet.exe';
   if not isANSItmpdir then begin
     GetShortPathName(pchar(TempDir),@shorttmp,1024);
     outfile:=slash(shorttmp)+extractfilename(outfile);
     if (originfile<>'') and FileExists(originfile) then
         originfile:=slash(shorttmp)+extractfilename(originfile);
   end;
 {$endif}

 //SZ prepare origin lat/long

  if AUseOrigFile then
  begin
    originfile:= slash(Tempdir) + 'Orbit_xplanet.txt';

    DeleteFileUTF8(originfile);

    //SZ prepare observer's position for xplanet
    PrepareFileForXplanet(
      originfile, jd,
      AOriginLat, AOriginLong
     );

  end;

  //SZ Determinate target

// if (ipla = C_Earth) and  (AProjection = '') then
//   origin := 'sun';

//and (Aorigin <> Atarget)

  if AUseOrigin then
  begin
    p.Parameters.Add('-origin');
    p.Parameters.Add(Aorigin);
  end;

  if (AUseOrigFile) and FileExists(originfile) then
    begin
      p.Parameters.Add('-origin_file');
      p.Parameters.Add(originfile);
    end;

  //SZ Lon/Lat of observer
  if AUseLatLong then
  begin
    //SZ This lat/lon of target object

    p.Parameters.Add('-latitude');
    t:=formatfloat(f6,ATargetLat);
    p.Parameters.Add(t);

    p.Parameters.Add('-longitude');
    t:=formatfloat(f6,ATargetLong);
    p.Parameters.Add(t);

  end;

 //SZ If target is not Earth
 if AUseTarget then
 begin
   p.Parameters.Add('-body');
   p.Parameters.Add(Atarget)
 end;

 if Anorth<> '' then
 begin
   p.Parameters.Add('-north');
   p.Parameters.Add(Anorth);
 end;

 p.Parameters.Add('-rotate');
 p.Parameters.Add(formatfloat(f6,pa));
 p.Parameters.Add('-light_time');
 p.Parameters.Add('-tt');
 p.Parameters.Add('-num_times');
 p.Parameters.Add('1');
 p.Parameters.Add('-jd');
 p.Parameters.Add(formatfloat(f6,jd));
 p.Parameters.Add('-searchdir');
 p.Parameters.Add(searchdir);

 //SZ Revert this in order not to display planet/satellite labels by xplanet

 if trim(AConfig) <> '' then
 begin
   p.Parameters.Add('-config');
   p.Parameters.Add(AConfig);  // 'xplanet.config'
 end;

 p.Parameters.Add('-verbosity');
 p.Parameters.Add('-1');

 if trim(ARadius) <> '' then
 begin
   p.Parameters.Add('-radius');
   p.Parameters.Add(ARadius);  // '50'
 end;

 p.Parameters.Add('-geometry');
 p.Parameters.Add(bsize);

 p.Parameters.Add('-output');
 p.Parameters.Add(outfile);

// p.Parameters.Add('-transpng');
// p.Parameters.Add(outfile);


 if AUseLabels then
   p.Parameters.Add('-label');

 if Atarget='jupiter' then begin
    p.Parameters.Add('-grs_longitude');
    p.Parameters.Add(formatfloat(f1,grsl));
 end;

 //SZ Projection
 if trim(AProjection) <> '' then
 begin
   p.Parameters.Add('-projection');
   p.Parameters.Add(AProjection);
 end;

 //SZ Fov
 if (AFov) <> 0 then
 begin
   p.Parameters.Add('-fov');
   p.Parameters.Add(formatfloat(f6,Afov) );
 end;

 if (de_type>0)and(Xplanetversion>='1.3.0') then begin
     p.Parameters.Add('-ephemeris_file');
     p.Parameters.Add(de_filename);
 end;

 DeleteFileUTF8(SysToUTF8(outfile));

 p.Options:=[poWaitOnExit,poUsePipes,poNoConsole, poStdErrToOutput];

 try
   p.Execute;

   if (p.ExitStatus<>0)and(de_type>0)and(Xplanetversion>='1.3.0') then begin
     p.Parameters.Delete(p.Parameters.Count-1);
     p.Parameters.Delete(p.Parameters.Count-1);
     p.Execute;
   end;

 except
 end;

 r.LoadFromStream(p.Output);

 irc:=p.ExitStatus;
 p.free;
end;

function GetXplanet_Image(
    //Asearchdir : string;
    ABMP: TBGRABitmap;
    Aplanet:TPlanet;
    Aconfig: Tconf_skychart;
    W, H: integer;
    pa, grsl, jd : double;
    AFov: double;
    AUseOrigFile, AUseLatLong: Boolean;
    AUseOrigin: Boolean; AOrigin: Integer;
    AUseTarget: Boolean; ATarget: Integer;
    AOriginLat, AOriginLong: double;
    ATargetLat, ATargetLong: double;
    AProjection: string;
    ANorth: string;
    ARadius: string;
    AConfig_File: string;
    AUseLabels: Boolean
 ): Boolean;

var
  irc, j: integer;
  searchdir,sz,buf : string;
  gw: double;
  r: TStringList;
  targetLat, targetLong: double;
  originLat, originLong: double;
  origin, target: string;
  UseOrigin, UseLatLong, UseTarget, UseOriginFile:Boolean;

  OutputFile: string;
begin

  result := false;

  sz := inttostr(W)+'x'+inttostr(H);

  searchdir:=slash(appdir)+slash('data')+'planet';

  r:=TStringList.Create;

  try

    if ATarget = C_Jupiter then
       gw := Aplanet.JupGRS(
         Aconfig.GRSlongitude,
         Aconfig.GRSdrift,
         Aconfig.GRSjd,
         Aconfig.CurJDTT
       )
    else
      gw:=0;

    //SZ with small sattelites, it is mandatory to use maps for parent planet if
    //   it is background, otherwise
    // TODO: determinate planet is a background or not.

    searchdir := ScaledPlanetMapDir (ATarget,  H);

    //SZ determinate target
    target := GetPlanetName(ATarget);
    origin := GetPlanetParentName(AOrigin);

    originLat  :=  Aconfig.ObsLatitude;
    originLong := -Aconfig.ObsLongitude;

    targetLat  :=  Aconfig.ObsLatitude;
    targetLong := -Aconfig.ObsLongitude;

    //SZ Autoset
    if trim(AProjection) <> '' then
    begin
      UseOriginFile := false;
      UseOrigin     := false;
      UseTarget     := true;
      UseLatLong    := false;
    end
    else
    begin
      if origin=target then
      begin
        UseOriginFile := false;
        UseOrigin     := false;
        UseTarget     := true;

        if target = 'earth' then
          UseLatLong    := true
        else
          UseLatLong    := false;
      end
      else

      if origin='earth' then
      begin
        UseOriginFile := true;
        UseOrigin     := true;
        UseTarget     := true;
        UseLatLong    := false;
      end
      else

      if (origin='sun') then
      begin
        UseOriginFile := false;
        UseOrigin     := true;
        UseTarget     := true;

        if (target='earth') then
          UseLatLong    := true
        else;
          UseLatLong    := false
      end
      else

      begin
        UseOriginFile := false;
        UseOrigin     := true;
        UseTarget     := true;
        UseLatLong    := false;
      end;

    end;

    OutputFile := slash(Tempdir)+'info2.png';

    GetXplanet_Plain(
      Xplanetversion,searchdir,sz,OutputFile,
        0,gw,Aconfig.CurJDTT,irc,r,AProjection, Afov,
        UseOriginFile, UseLatLong,
        UseOrigin, origin,
        UseTarget, target,
        originLat, originLong,
        targetLat, targetLong,
        ANorth,
        ARadius,
        AConfig_File,
        AUseLabels
      );

    if (irc=0)and (FileExistsUTF8(OutputFile)) then
    begin

      ABMP.LoadFromFileUTF8(OutputFile);

      result := true;
    end else
    begin // something go wrong with xplanet
       buf:='';
       if r.Count>0 then for j:=0 to r.Count-1 do begin
        buf:=buf+r[j]+crlf;
       end;
       writetrace('Return code '+inttostr(irc)+' from xplanet');
       writetrace(buf);
    end;

  finally
    r.Free;
  end

end;

function GetPlanetNameLang(Aipla: integer): string;
begin

  result := '';

  if
    ( Aipla < Low(epla) ) or
    ( Aipla > High(epla) )
  then
    exit;

  try

    if Aipla <> C_Earth then
      result := trim(pla[Aipla])
    else
      result := rsEarth;

  finally
  end;

end;

function GetPlanetName(Aipla: integer): string;
begin

  result := '';

  if
    ( Aipla < Low(epla) ) or
    ( Aipla > High(epla) )
  then
    exit;

  try

    if Aipla <> C_Earth then
      result := LowerCase(trim(epla[Aipla]))
    else
      result := 'earth';

    //SZ not the same name in CDC and xplanet
    if result = 'encelade' then
      result := 'enceladus';

  finally
  end;

end;

function  IsInArray(val: integer; arr: array of integer): Boolean;
var
  i: integer;
begin

  result:= false;

  for i := low(arr) to high(arr) do
  begin
    if val = arr[i] then
    begin
      result:= true;
      break
    end;

  end;

end;

function GetPlanetParent(Aipla: integer): integer;
begin
  result := Aipla;

  if IsInArray( Aipla, Earth_Sat   ) then result := C_Earth;
  if IsInArray( Aipla, Mars_Sat    ) then result := C_Mars;
  if IsInArray( Aipla, Jupiter_Sat ) then result := C_Jupiter;
  if IsInArray( Aipla, Saturn_Sat  ) then result := C_Saturn;
  if IsInArray( Aipla, Uranus_Sat  ) then result := C_Uranus;
  if IsInArray( Aipla, Neptune_Sat ) then result := C_Neptune;
  if IsInArray( Aipla, Pluto_Sat   ) then result := C_Pluto;
end;

function GetPlanetParentName(Aipla: integer): string;
var
  ipla: integer;
begin

  ipla := GetPlanetParent(Aipla);
  result := GetPlanetName(ipla);

end;

constructor TOrbits.Create(Aplbmp:TBGRABitmap; ATextZoom: Double);
var
   i: integer;
begin

  TypeOfOrbit:= 0;

  FCurrJDTT := 0;

  FPlanet := nil;
  Fconfig := nil;

  FTextZoom := ATextZoom;

  bmp := Aplbmp;

  Orbit_bmp := TBGRABitmap.Create;

  IsShowLabels := true;
  IsDisplayDistance := true;

  RefreshOrbit := true;

  SetLength(PlanetImage, C_Callisto+1);

  for i := low(PlanetImage) to high(PlanetImage) do
    PlanetImage[i] := nil;

end;

destructor TOrbits.Destroy;
var
   i: integer;
begin

 Orbit_bmp.Free;

  for i := low(PlanetImage) to high(PlanetImage) do
  begin

    if PlanetImage[i] <> nil then
    begin
      PlanetImage[i].Free;
      PlanetImage[i] :=nil;
    end;

  end;

  SetLength(PlanetImage, 0);

end;

function TOrbits.PointXY( ipla: integer; jdt:double):TPointF;
var
  px,py: double;
begin

  Fplanet.Plan(ipla,jdt,pl);

  px:=pl.x;
  py:= coseps2k*pl.y + sineps2k*pl.z;

  result.x :=  fx * px + cx;
  result.y := -fx * py + cy;

end;

procedure TOrbits.RecalculateOrbit(ipla: integer);
var
  i:integer;

  jdt,sd:double;
  p: ArrayOfTPointF;

  r: TPointF;

begin
  SetLength(p,nbstep+1);

  sd := per[ipla]/(nbstep-1);

  jdt:=JDBase1999; //FCurrJDTT;

  for i:=0 to nbstep do
  begin
    //Fplanet.Plan(ipla,jdt,pl);

    // rotate equatorial to ecliptic

    r := PointXY(ipla,jdt);

    p[i].x:= r.x;
    p[i].y:= r.y;

    jdt:=jdt+sd;
  end;

  Orbit_bmp.DrawPolyLineAntialias(p,ColorToBGRA(clGray),0.5,true);

  for i := low(PlanetImage) to high(PlanetImage) do
  begin
    if PlanetImage[i] <> nil then
    begin
       PlanetImage[i].Free;
       PlanetImage[i]:= nil
    end;
  end;

end;

//SZ Distance from desired planets/satelittes in AU
function TOrbits.PlanetDistance(pla1,pla2: integer; JD: double): double;
var
  p1,p2: TPlanData;
begin

  Fplanet.Plan(pla1, JD, p1);
  Fplanet.Plan(pla2, JD, p2);

  if (pla1 = pla2) then
    result := 0
  else
  if pla1 = C_Sun then
     result := sqr(p2.x) + sqr(p2.y) + sqr(p2.z)
  else
  if pla2 = C_Sun then
    result := sqr(p1.x) + sqr(p1.y) + sqr(p1.z)
  else
    result := sqr(p1.x-p2.x) + sqr(p1.y-p2.y) + sqr(p1.z-p2.z) ;

  result := sqrt(result);

end;

procedure TOrbits.PlotOrbit(ACurrJDTT: double);

  procedure DisplayDistanceList;
  var
    i: integer;
    s: string;
    x,y: integer;
  begin

     bmp.FontHeight := round(FTextlabels);
     bmp.FontStyle := [];

     bmp.TextOut(xmin +  70, ymin, rsSun,   ColorToBGRA(clWhite), taLeftJustify);
     bmp.TextOut(xmin + 140, ymin, rsEarth, ColorToBGRA(clWhite), taLeftJustify);

     for i := C_Mercury to C_Pluto do
     begin

        x:= xmin;
        y:= ymin + FTextlabels* (i+1);

       if i = C_Earth then
          s := rsEarth
       else
          s := pla[i];

        bmp.TextOut(x,y, s, ColorToBGRA(clWhite), taLeftJustify);

        //Sun distance in  AU
        s:=format('%6.4f',[Distance[i].FromSun]);

        x:= x + 100;
        bmp.TextOut(x, y, s, ColorToBGRA(clGreen), taRightJustify);

        if i <> C_Earth then
        begin
          //Sun distance in  AU
          s:=format('%6.4f',[Distance[i].FromEarth]);

          x:= x + 70;
          bmp.TextOut(x, y, s, ColorToBGRA(clGreen), taRightJustify)
        end;

     end;

  end;

  procedure CalctOrbit (i: integer);
  begin
    distance[i].FromEarth := PlanetDistance(C_Earth, i, ACurrJDTT);
    distance[i].FromSun   := PlanetDistance(C_Sun,   i, ACurrJDTT);

    distance[i].r := PointXY(i,ACurrJDTT);
  end;

  procedure CalcOrbitAll;
  var
    i: integer;
  begin

    for i := C_Mercury to C_Pluto do
      CalctOrbit (i);

  end;

  procedure DisplayPlanet (i: integer);
  var
    r: TPointF;
    r1,r2: integer;
  begin

    //bmp.FontHeight:=round(24*FTextZoom);
    //bmp.FontStyle:=[fsBold];

    {
    if ipla=C_Earth
      then bmp.TextOut(20, txtp+txts*ipla, rsEarth, ColorToBGRA(col[ipla]), taLeftJustify)
      else bmp.TextOut(20, txtp+txts*ipla,pla[ipla],ColorToBGRA(col[ipla]), taLeftJustify);
    }

    r := Distance[i].r;

    //SZ Fake planet image

    r1 := round((ymax-ymin)/20 * diam_fake[i]);

    if PlanetImage[i] = nil then
    begin

      PlanetImage[i] := TBGRABitmap.Create();

      GetXplanet_Image(
        PlanetImage[i],
        Fplanet,Fconfig,
        r1,r1,0,0,
        //Fconfig.CurJDTT,
        JDBase1999,
        0,false,true,
        true,C_Sun,true,i,
        0,0,0,0,
        '','','50',
        'xplanet.config',
        False
      );

    end;

    if PlanetImage[i] = nil then
      bmp.FillEllipseAntialias(r.x,r.y,ps,ps,ColorToBGRA(col[i]))
    else
    begin
      r2 := PlanetImage[i].Height div 2;

      //bmp.PutImage(round(r.x)-r2, round(r.y)-r2, PlanetImage[i], dmDrawWithTransparency);
      bmp.BlendImage(round(r.x)-r2, round(r.y)-r2, PlanetImage[i], boScreen );

    end;

  end;

  procedure DisplayLabels (i: integer);
  var
    s: string;
    x,y: integer;
    r : TPointF;
    r1: integer;
  begin

    r := Distance[i].r;

    if i = C_Earth then
      s := rsEarth
    else
      s := pla[i];

    r1 := round((ymax-ymin)/15 * diam_fake[i]);

    x := round(r.x + (r1 div 2) + 5);
    y := round(r.y - FTextlabels div 2);

    bmp.TextOut(x,y, s, ColorToBGRA(clWhite), taLeftJustify);


  end;

var
  i : integer;

begin

  FCurrJDTT := ACurrJDTT;

  //SZ When refresh orbit is required
  if RefreshOrbit then
  begin

    //Orbit_bmp.SetSize(xmax-xmin, ymax-ymin);

    Orbit_bmp.SetSize(xmax, ymax);
    Orbit_bmp.Fill(ColorToBGRA(clBlack));

    if TypeOfOrbit =0 then
    begin

      for i := C_Mercury to C_Mars do
        RecalculateOrbit(i);

    end
    else
    begin

      //SZ Use no Mars orbit here anymore
      for i := C_Jupiter to C_Pluto do
        RecalculateOrbit(i);

    end;

    Orbit_bmp.FillEllipseAntialias(cx,cy,ss,ss,ColorToBGRA(clYellow));  // sun

    RefreshOrbit := false;

  end;

  bmp.Assign(Orbit_bmp);

  //SZ Sun label
  if IsShowLabels then
  begin
    bmp.FontHeight := FTextlabels;
    bmp.FontStyle:=[];
    bmp.TextOut(cx + 10, cy - 5, rsSun, ColorToBGRA(clWhite), taLeftJustify);
  end;

  CalcOrbitAll;

  if TypeOfOrbit = 0 then
  begin

    for i := C_Mercury to C_Mars do
      DisplayPlanet(i);

  end
  else
  begin

    for i := C_Jupiter to C_Pluto do
      DisplayPlanet(i);

  end;

  //SZ Show labels
  if IsShowLabels then
  begin

    if TypeOfOrbit = 0 then
    begin

      for i := C_Mercury to C_Mars do
         DisplayLabels(i);

    end else
    begin
      for i := C_Jupiter to C_Pluto do
        DisplayLabels(i);
    end;

  end;

  if IsDisplayDistance then
    DisplayDistanceList;

end;

procedure TOrbits.SetPlanet(Aplanet : TPlanet);
begin
  Fplanet := Aplanet;
end;

procedure TOrbits.SetConfig(AConfig : Tconf_skychart);
begin
  Fconfig := AConfig;
end;


procedure TOrbits.SetShowLabel(AShowLabels: Boolean);
begin
  IsShowLabels := AShowLabels;
end;

procedure TOrbits.SetDrawnRegion(Axmax, Axmin, Aymax, Aymin: integer);
var
  s: integer;
  W, H: integer;
begin

  xmax := Axmax;
  xmin := Axmin;
  ymax := Aymax;
  ymin := Aymin;

  RefreshOrbit:= true;

  W := xmax-xmin;
  H := ymax-ymin;

  s := min(W,H);

  nbstep := s div 4;

  cx := xmin + (W div 2);
  cy := ymin + (H div 2);

  if TypeOfOrbit = 0 then
    fx:=s/3.5
  else
    fx:=s/70.0;

  ps   := round(5*FTextZoom);
  ss   := round(8*FTextZoom);
  //txts := round(30*FTextZoom);
  //txtp := ymax-6*txts;

  FTextlabels := round(12*FTextZoom);

  RefreshOrbit := true;;

end;

end.

