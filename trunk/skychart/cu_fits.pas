unit cu_fits;

interface

uses u_util, u_constant, u_projection, SysUtils, Classes, Math, passql, pasmysql, passqlite, StrUtils,
{$ifdef mswindows}
Windows,  Graphics;
{$endif}
{$ifdef linux}
Types, QGraphics;
{$endif}

type Tfitsheader = record
                bitpix,naxis,naxis1,naxis2,naxis3 : integer;
                bzero,bscale,dmax,dmin,blank,equinox : double;
                ctype1,ctype2,radecsys : string;
                rotaok,cdok,pcok,valid,coordinate_valid : boolean;
                crpix1,crpix2,crval1,crval2,cdelt1,cdelt2,crota1,crota2 : double;
                cd1_1,cd1_2,cd2_1,cd2_2 : double;
                pc : array[1..2,1..2] of double;
                end;
Timai8 = array of array of array of byte; TPimai8 = ^Timai8;
Timai16 = array of array of array of smallint; TPimai16 = ^Timai16;
Timai32 = array of array of array of longint; TPimai32 = ^Timai32;
Timar32 = array of array of array of single; TPimar32 = ^Timar32;
Timar64 = array of array of array of double; TPimar64 = ^Timar64;

const    maxl = 4000;

type
  TFits = class(TComponent)
  private
    d8  : array[1..2880] of byte;
    d16 : array[1..1440] of word;
    d32 : array[1..720] of Longword;
    d64 : array[1..360] of Int64;
    imai8 : Timai8;
    imai16 : Timai16;
    imai32 : Timai32;
    imar32 : Timar32;
    imar64 : Timar64;
    Fheader : Tfitsheader;
    FFileName : String;
    n_axis,cur_axis,Fwidth,Fheight,hdr_end,colormode,current_result : Integer;
    Fimg_width,Fimg_Height,Fra,Fde,Frotation : double;
    Fprojection : string;
    Fmean,Fsigma,dmin,dmax,Fmin_sigma,Fmax_sigma : double;
    itt : array[0..255] of byte;
    procedure SetFile(value:string);
    procedure Readfitsheader;
    Procedure FITSCoord ;
    Procedure ReadFitsImage;
    procedure SetITT;
  protected
    { Protected declarations }
  public
    { Public declarations }
    db1 : TSqlDB;
     dbconnected, invertx, inverty : boolean;
     constructor Create(AOwner:TComponent); override;
     destructor  Destroy; override;
     Function ConnectDB(host,db,user,pass:string; port:integer):boolean;
     Function OpenDB(catalogname:string; ra1,ra2,dec1,dec2:double):boolean;
     Function GetDB(var filename,objname:string; var ra,de,width,height,rot:double):boolean;
     Function DeleteDB(cname,oname: string):boolean;
     Function InsertDB(fname,cname,oname: string; ra,de,width,height,rotation:double):boolean;
     Function GetFileName(catname,objectname:string; var filename:string):boolean;
     Procedure GetAllHeader(var result:Tstringlist);
     procedure GetBitmap(var imabmp:Tbitmap);
     Property Header : Tfitsheader read Fheader;
     Property FileName : string read FFileName write SetFile;
     Property Center_RA : double read Fra;
     Property Center_DE : double read Fde;
     Property Img_Width : double read Fimg_width;
     Property Img_Height : double read Fimg_Height;
     Property Rotation  : double read Frotation;
     Property Projection : string read Fprojection;
     Property min_sigma  : double read Fmin_sigma write Fmin_sigma;
     Property max_sigma  : double read Fmax_sigma write Fmax_sigma;
  end;

implementation

constructor TFits.Create(AOwner:TComponent);
begin
inherited Create(AOwner);
SetITT;
if DBtype=mysql then
   db1:=TMyDB.create(self)
else if DBtype=sqlite then
   db1:=TLiteDB.create(self);
dbconnected:=false;
end;

destructor  TFits.Destroy; 
begin
db1.Free;
setlength(imar64,0,0,0);
setlength(imar32,0,0,0);
setlength(imai8,0,0,0);
setlength(imai16,0,0,0);
setlength(imai32,0,0,0);
inherited destroy;
end;

procedure TFits.SetFile(value:string);
begin
try
Fheader.valid:=false;
Fheader.coordinate_valid:=false;
if fileexists(value) and (rightstr(value,1)<>PathDelim) then begin
 cur_axis:=1;
 setlength(imar64,0,0,0);
 setlength(imar32,0,0,0);
 setlength(imai8,0,0,0);
 setlength(imai16,0,0,0);
 setlength(imai32,0,0,0);
 FFileName:=value;
 Readfitsheader;
 if Fheader.valid then FITSCoord;
end; 
except
Fheader.valid:=false;
end;
end;

Procedure TFits.GetAllHeader(var result:Tstringlist);
var   header : array[1..36,1..80] of char;
      i,n,p1 : integer;
      eoh,ItsFits : boolean;
      keyword,value : string;
      f : file;
begin
ItsFits:=false;
filemode:=0;
assignfile(f,FFileName);
reset(f,1);
result.Clear;
eoh:=false;
repeat
   blockread(f,header,sizeof(header),n);
   for i:=1 to 36 do begin
      p1:=pos('=',header[i]);
      if p1=0 then p1:=9;
      keyword:=trim(copy(header[i],1,p1-1));
      value:=trim(copy(header[i],p1+1,99))+' ';
      if (not ItsFits) and (keyword='SIMPLE') and (value[1]='T') then itsFits:=true;
      if (keyword='END') then eoh:=true;
      result.add(header[i]);
   end;
   if not ItsFits then begin result.Add('Not a FITS file, "SIMPLE = T" keyword missing');Closefile(f);Exit;end;
until eoh;
Closefile(f);
end;

procedure TFits.Readfitsheader;
var   header : array[1..36,1..80] of char;
      i,n,p1,p2 : integer;
      eoh : boolean;
      keyword,buf : string;
      f : file;
begin
filemode:=0;
assignfile(f,FFileName);
reset(f,1);
with FHeader do begin
coordinate_valid:=false;
valid:=false;eoh:=false; naxis1:=0 ; naxis2:=0 ; naxis3:=1; bitpix:=0 ; dmin:=0 ; dmax := 0; blank:=0;
bzero:=0 ; bscale:=1;
ctype1:='' ;ctype2:='';
crpix1:=0;crpix2:=0;crval1:=0;crval2:=0;cdelt1:=0;cdelt2:=0;crota1:=0;crota2:=0;
cd1_1:=0;cd2_2:=0;cd1_2:=0;cd2_1:=0;
pc[1,1]:=1;pc[1,2]:=0;pc[2,1]:=0;pc[2,2]:=1;
rotaok:=false;cdok:=false;pcok:=false;
equinox:=0.0;
radecsys:='';
repeat
   blockread(f,header,sizeof(header),n);
   if n<>sizeof(header) then exit;
   for i:=1 to 36 do begin
      p1:=pos('=',header[i]);
      if p1=0 then p1:=9;
      p2:=pos('/',header[i]);
      if p2=0 then p2:=80;
      keyword:=trim(copy(header[i],1,p1-1));
      buf:=trim(copy(header[i],p1+1,p2-p1-1));
      if (keyword='SIMPLE') then if (copy(buf,1,1)<>'T') then begin valid:=false;Break;end
                                                         else valid:=true;
      if (keyword='BITPIX') then bitpix:=strtoint(buf);
      if (keyword='NAXIS')  then naxis:=strtoint(buf);
      if (keyword='NAXIS1') then naxis1:=strtoint(buf);
      if (keyword='NAXIS2') then naxis2:=strtoint(buf);
      if (keyword='NAXIS3') then naxis3:=strtoint(buf);
      if (keyword='BZERO') then bzero:=strtofloat(buf);
      if (keyword='BSCALE') then bscale:=strtofloat(buf);
      if (keyword='DATAMAX') then dmax:=strtofloat(buf);
      if (keyword='DATAMIN') then dmin:=strtofloat(buf);
      if (keyword='THRESH') then dmax:=strtofloat(buf);
      if (keyword='THRESL') then dmin:=strtofloat(buf);
      if (keyword='BLANK') then blank:=strtofloat(buf);
      if (keyword='CTYPE1') then ctype1:=buf;
      if (keyword='CTYPE2') then ctype2:=buf;
      if (keyword='CRPIX1') then crpix1:=strtofloat(buf);
      if (keyword='CRPIX2') then crpix2:=strtofloat(buf);
      if (keyword='CRVAL1') then crval1:=strtofloat(buf);
      if (keyword='CRVAL2') then crval2:=strtofloat(buf);
      if (keyword='CDELT1') then begin cdelt1:=strtofloat(buf); rotaok:=true;end;
      if (keyword='CDELT2') then begin cdelt2:=strtofloat(buf); rotaok:=true;end;
      if (keyword='CROTA1') then crota1:=strtofloat(buf);
      if (keyword='CROTA2') then begin crota2:=strtofloat(buf); rotaok:=true;end;
      if (keyword='CD1_1') then begin cd1_1:=strtofloat(buf); cdok:=true; end;
      if (keyword='CD1_2') then begin cd1_2:=strtofloat(buf); cdok:=true; end;
      if (keyword='CD2_1') then begin cd2_1:=strtofloat(buf); cdok:=true; end;
      if (keyword='CD2_2') then begin cd2_2:=strtofloat(buf); cdok:=true; end;
      if (keyword='PC001001') then begin pc[1,1]:=strtofloat(buf); pcok:=true; end;
      if (keyword='PC001002') then begin pc[1,2]:=strtofloat(buf); pcok:=true; end;
      if (keyword='PC002001') then begin pc[2,1]:=strtofloat(buf); pcok:=true; end;
      if (keyword='PC002002') then begin pc[2,2]:=strtofloat(buf); pcok:=true; end;
      if (keyword='EPOCH')or(keyword='EQUINOX') then begin
                   if copy(buf,3,4)='2000' then equinox:=2000
                   else if copy(buf,3,4)='1950' then equinox:=1950
                   else equinox:=strtofloat(buf);
                   end;
      if (keyword='RADECSYS') then radecsys:=buf;
      if (keyword='END') then eoh:=true;
   end;
   if bitpix=0 then Break;
   if not valid then Break;
until eoh;
hdr_end:=filepos(f);
colormode:=1;
if (naxis=3)and(naxis1=3) then begin // contiguous color
  naxis1:=naxis2;
  naxis2:=naxis3;
  naxis3:=3;
  colormode:=2;
end;
if (naxis=3)and(naxis3=3) then n_axis:=3 else n_axis:=1;
if radecsys='' then radecsys:='''FK4''';
if (equinox=0) then if (copy(radecsys,2,3)='FK4') then equinox:=1950
                                                  else equinox:=2000;
end;
Closefile(f);
end;

Procedure TFits.FITSCoord ;
var   cmethod : integer;
      ic,jc,x,y : double;
      cosr,sinr : extended;
      buf : string;
begin
Fheader.coordinate_valid:=false;
Fimg_width:=0; Fimg_Height:=0;
if (copy(Fheader.ctype1,2,4)='RA--')and(copy(Fheader.ctype2,2,4)='DEC-') then begin
  buf:=copy(Fheader.ctype1,6,4);
  if buf='-TAN' then Fprojection:='TAN'
  else if buf='-SIN' then Fprojection:='SIN'
  else if buf='-ARC' then Fprojection:='ARC'
  else if buf='-CAR' then Fprojection:='CAR'
  else Fprojection:='ARC';
  if Fheader.pcok then cmethod:=1
  else
  if Fheader.cdok then cmethod:=2
  else
  if Fheader.rotaok then cmethod:=3
  else cmethod:=99;
  ic:=Fheader.naxis1/2 - Fheader.crpix1+0.5;
  jc:=Fheader.naxis2/2 - Fheader.crpix2+0.5;
  case cmethod of
  1 : begin
        x:=Fheader.pc[1,1]*ic + Fheader.pc[1,2]*jc;
        y:=Fheader.pc[2,1]*ic + Fheader.pc[2,2]*jc;
        Fde:=deg2rad*(Fheader.crval2 + y*Fheader.cdelt2);
        Fra:=deg2rad*(Fheader.crval1 + x*Fheader.cdelt1/cos(Fde) );
        x:= arctan( (Fheader.cdelt2/Fheader.cdelt1)*(Fheader.pc[2,1]/Fheader.pc[1,1]) ) ;
        y:= arctan(-(Fheader.cdelt1/Fheader.cdelt2)*(Fheader.pc[1,2]/Fheader.pc[2,2]) ) ;
        Frotation:=-(x+y)/2;
        Fimg_width:=deg2rad*abs(Fheader.naxis1*Fheader.cdelt1);
        Fimg_Height:=deg2rad*abs(Fheader.naxis2*Fheader.cdelt2);
        Fheader.coordinate_valid:=true;
      end;
  2 : begin
        x:=Fheader.cd1_1*ic + Fheader.cd1_2*jc;
        y:=Fheader.cd2_1*ic + Fheader.cd2_2*jc;
        Fde:=deg2rad*(Fheader.crval2 + y);
        Fra:=deg2rad*(Fheader.crval1 + x/cos(Fde) );
     //   x:=arctan2(Fheader.cd2_1,Fheader.cd1_1);
        y:=arctan2(-Fheader.cd1_2,Fheader.cd2_2);
     //   Frotation:=-(x+y)/2;
        Frotation:=-y;
        Fimg_width:=deg2rad*abs(Fheader.naxis1*Fheader.cd1_1);
        Fimg_Height:=deg2rad*abs(Fheader.naxis2*Fheader.cd2_2);
        Fheader.coordinate_valid:=true;
      end;
  3 : begin
        Frotation:=-Fheader.crota2*deg2rad;
        sincos(Frotation,sinr,cosr);
        x:=Fheader.cdelt1*ic*cosr+Fheader.cdelt2*jc*sinr;
        y:=Fheader.cdelt2*jc*cosr-Fheader.cdelt1*ic*sinr;
        Fde:=deg2rad*(Fheader.crval2 + y);
        Fra:=deg2rad*(Fheader.crval1 + x/cos(Fde) );
        Fimg_width:=deg2rad*abs(Fheader.naxis1*Fheader.cdelt1);
        Fimg_Height:=deg2rad*abs(Fheader.naxis2*Fheader.cdelt2);
        Fheader.coordinate_valid:=true;
      end;
  else Fimg_width:=0;
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
if Fheader.equinox<>2000 then
   if (copy(Fheader.radecsys,2,3)='FK4') then
       precessionFK4(jd(trunc(Fheader.equinox),round(frac(Fheader.equinox)*12),1,0),jd2000,Fra,Fde)
   else
       precession(jd(trunc(Fheader.equinox),round(frac(Fheader.equinox)*12),1,0),jd2000,Fra,Fde);
end;

Procedure TFits.ReadFitsImage;
var i,ii,j,n,npix,k : integer;
    x : double;
    f : file;
    ni,sum,sum2 : extended;
begin
if Fheader.naxis1=0 then exit;
filemode:=0;
assignfile(f,FFileName);
reset(f,1);
dmin:=1.0E100;
dmax:=-1.0E100;
sum:=0; sum2:=0; ni:=0;
if n_axis=3 then cur_axis:=1
else begin
  cur_axis:=trunc(minvalue([cur_axis,Fheader.naxis3]));
  cur_axis:=trunc(maxvalue([cur_axis,1]));
end;
Fheight:=trunc(minvalue([maxl,Fheader.naxis2]));
Fwidth:=trunc(minvalue([maxl,Fheader.naxis1]));
case Fheader.bitpix of
  -64 : begin
        setlength(imar64,n_axis,Fheight,Fwidth);
        seek(f,hdr_end+Fheader.naxis2*Fheader.naxis1*8*(cur_axis-1));
        end;
  -32 : begin
        setlength(imar32,n_axis,Fheight,Fwidth);
        seek(f,hdr_end+Fheader.naxis2*Fheader.naxis1*4*(cur_axis-1));
        end;
    8 : begin
        setlength(imai8,n_axis,Fheight,Fwidth);
        seek(f,hdr_end+Fheader.naxis2*Fheader.naxis1*(cur_axis-1));
        end;
   16 : begin
        setlength(imai16,n_axis,Fheight,Fwidth);
        seek(f,hdr_end+Fheader.naxis2*Fheader.naxis1*2*(cur_axis-1));
        end;
   32 : begin
        setlength(imai32,n_axis,Fheight,Fwidth);
        seek(f,hdr_end+Fheader.naxis2*Fheader.naxis1*4*(cur_axis-1));
        end;
end;
npix:=0;
case Fheader.bitpix of
    -64:for k:=cur_axis-1 to cur_axis+n_axis-2 do begin
        for i:=0 to Fheader.naxis2-1 do begin
         ii:=Fheader.naxis2-1-i;
         for j := 0 to Fheader.naxis1-1 do begin
           if (npix mod 360 = 0) then begin
             BlockRead(f,d64,sizeof(d64),n);
             npix:=0;
           end;
           inc(npix);
           x:=InvertF64(d64[npix]);
           if x=Fheader.blank then x:=0;
           if (ii<=maxl-1) and (j<=maxl-1) then imar64[k,ii,j] := x ;
           x:=Fheader.bzero+Fheader.bscale*x;
           dmin:=minvalue([x,dmin]);
           dmax:=maxvalue([x,dmax]);
           sum:=sum+x;
           sum2:=sum2+x*x;
           ni:=ni+1;
          end;
         end;
         end;
    -32: for k:=cur_axis-1 to cur_axis+n_axis-2 do begin
        for i:=0 to Fheader.naxis2-1 do begin
         ii:=Fheader.naxis2-1-i;
         for j := 0 to Fheader.naxis1-1 do begin
           if (npix mod 720 = 0) then begin
             BlockRead(f,d32,sizeof(d32),n);
             npix:=0;
           end;
           inc(npix);
           x:=InvertF32(d32[npix]);
           if x=Fheader.blank then x:=0;
           if (ii<=maxl-1) and (j<=maxl-1) then imar32[k,ii,j] := x ;
           x:=Fheader.bzero+Fheader.bscale*x;
           dmin:=minvalue([x,dmin]);
           dmax:=maxvalue([x,dmax]);
           sum:=sum+x;
           sum2:=sum2+x*x;
           ni:=ni+1;
         end;
         end;
         end;
     8 : if colormode=1 then
        for k:=cur_axis-1 to cur_axis+n_axis-2 do begin
        for i:=0 to Fheader.naxis2-1 do begin
         ii:=Fheader.naxis2-1-i;
         for j := 0 to Fheader.naxis1-1 do begin
           if (npix mod 2880 = 0) then begin
             BlockRead(f,d8,sizeof(d8),n);
             npix:=0;
           end;
           inc(npix);
           x:=d8[npix];
           if x=Fheader.blank then x:=0;
           if (ii<=maxl-1) and (j<=maxl-1) then imai8[k,ii,j] := round(x);
           x:=Fheader.bzero+Fheader.bscale*x;
           dmin:=minvalue([x,dmin]);
           dmax:=maxvalue([x,dmax]);
           sum:=sum+x;
           sum2:=sum2+x*x;
           ni:=ni+1;
         end;
         end;
         end else
        for i:=0 to Fheader.naxis2-1 do begin
         ii:=Fheader.naxis2-1-i;
         for j := 0 to Fheader.naxis1-1 do begin
           for k:=cur_axis+n_axis-2 downto cur_axis-1 do begin
           if (npix mod 2880 = 0) then begin
             BlockRead(f,d8,sizeof(d8),n);
             npix:=0;
           end;
           inc(npix);
           x:=d8[npix];
           if x=Fheader.blank then x:=0;
           if (ii<=maxl-1) and (j<=maxl-1) then imai8[k,ii,j] := round(x);
           x:=Fheader.bzero+Fheader.bscale*x;
           dmin:=minvalue([x,dmin]);
           dmax:=maxvalue([x,dmax]);
           sum:=sum+x;
           sum2:=sum2+x*x;
           ni:=ni+1;
           end;
         end;
         end;

     16 : for k:=cur_axis-1 to cur_axis+n_axis-2 do begin
        for i:=0 to Fheader.naxis2-1 do begin
         ii:=Fheader.naxis2-1-i;
         for j := 0 to Fheader.naxis1-1 do begin
           if (npix mod 1440 = 0) then begin
             BlockRead(f,d16,sizeof(d16),n);
             npix:=0;
           end;
           inc(npix);
           x:=InvertI16(d16[npix]);
           if x=Fheader.blank then x:=0;
           if (ii<=maxl-1) and (j<=maxl-1) then imai16[k,ii,j] := round(x);
           x:=Fheader.bzero+Fheader.bscale*x;
           dmin:=minvalue([x,dmin]);
           dmax:=maxvalue([x,dmax]);
           sum:=sum+x;
           sum2:=sum2+x*x;
           ni:=ni+1;
         end;
         end;
         end;
     32 : for k:=cur_axis-1 to cur_axis+n_axis-2 do begin
        for i:=0 to Fheader.naxis2-1 do begin
         ii:=Fheader.naxis2-1-i;
         for j := 0 to Fheader.naxis1-1 do begin
           if (npix mod 720 = 0) then begin
             BlockRead(f,d32,sizeof(d32),n);
             npix:=0;
           end;
           inc(npix);
           x:=InvertI32(d32[npix]);
           if x=Fheader.blank then x:=0;
           if (ii<=maxl-1) and (j<=maxl-1) then imai32[k,ii,j] := round(x);
           x:=Fheader.bzero+Fheader.bscale*x;
           dmin:=minvalue([x,dmin]);
           dmax:=maxvalue([x,dmax]);
           sum:=sum+x;
           sum2:=sum2+x*x;
           ni:=ni+1;
         end;
         end;
         end;
//     else begin msg:=appmsg[1]+' "BITPIX = '+inttostr(px)+'" ?'; end;
end;
closefile(f);
Fmean:=sum/ni;
Fsigma:=sqrt( (sum2/ni)-(Fmean*Fmean) );
if (Fheader.dmin=0)and(Fheader.dmax=0) then begin
  Fheader.dmin:=dmin;
  Fheader.dmax:=dmax;
end;
end;

procedure TFits.SetITT;
var
  i: Integer;
begin

// Ramp
  for i := 0 to 255 do begin
       itt[i]:=i;
  end;

end;

procedure TFits.GetBitmap(var imabmp:Tbitmap);
var i,j : integer;
    x,R,G,B : integer;
    xx: extended;
    P : PbyteArray;
    c : double;
begin
ReadFitsImage;
imabmp.freeimage;
imabmp.height:=Fheight;
imabmp.width:=Fwidth;
imabmp.pixelformat:=pf32bit;
dmin:=Fheader.dmin+Fmin_sigma*Fsigma;
dmax:=Fheader.dmax-Fmax_sigma*Fsigma;
c:=255/(dmax-dmin);
case Fheader.bitpix of
     -64 : for i:=0 to Fheight-1 do begin
           if invertY then P:=imabmp.ScanLine[Fheight-1-i]
                      else P:=imabmp.ScanLine[i];
           for j := 0 to Fwidth-1 do begin
               xx:=Fheader.bzero+Fheader.bscale*imar64[0,i,j];
               x:=trunc(maxvalue([0,minvalue([255,(xx-dmin) * c ])]) );
               R:=itt[x];
               if n_axis=3 then begin
                 xx:=Fheader.bzero+Fheader.bscale*imar64[1,i,j];
                 x:=trunc(maxvalue([0,minvalue([255,(xx-dmin) * c ])]) );
                 G:=itt[x];
                 xx:=Fheader.bzero+Fheader.bscale*imar64[2,i,j];
                 x:=trunc(maxvalue([0,minvalue([255,(xx-dmin) * c ])]) );
                 B:=itt[x];
               end else begin
                 G:=R;
                 B:=R;
               end;
               if invertX then begin
                  P[4*(Fwidth-j)-1] := R;
                  P[4*(Fwidth-j)-1+1] := G;
                  P[4*(Fwidth-j)-1+2] := B;
               end else begin
                  P[4*j] := R ;
                  P[4*j+1] := G ;
                  P[4*j+2] := B ;
               end;
           end;
           end;
     -32 : for i:=0 to Fheight-1 do begin
           if invertY then P:=imabmp.ScanLine[Fheight-1-i]
                      else P:=imabmp.ScanLine[i];
           for j := 0 to Fwidth-1 do begin
               xx:=Fheader.bzero+Fheader.bscale*imar32[0,i,j];
               x:=trunc(maxvalue([0,minvalue([255,(xx-dmin) * c ])]) );
               R:=itt[x];
               if n_axis=3 then begin
                 xx:=Fheader.bzero+Fheader.bscale*imar32[1,i,j];
                 x:=trunc(maxvalue([0,minvalue([255,(xx-dmin) * c ])]) );
                 G:=itt[x];
                 xx:=Fheader.bzero+Fheader.bscale*imar32[2,i,j];
                 x:=trunc(maxvalue([0,minvalue([255,(xx-dmin) * c ])]) );
                 B:=itt[x];
               end else begin
                 G:=R;
                 B:=R;
               end;
               if invertX then begin
                  P[4*(Fwidth-j)-1] := R;
                  P[4*(Fwidth-j)-1+1] := G;
                  P[4*(Fwidth-j)-1+2] := B;
               end else begin
                  P[4*j] := R ;
                  P[4*j+1] := G ;
                  P[4*j+2] := B ;
               end;
           end;
           end;
       8 : for i:=0 to Fheight-1 do begin
           if invertY then P:=imabmp.ScanLine[Fheight-1-i]
                      else P:=imabmp.ScanLine[i];
           for j := 0 to Fwidth-1 do begin
               xx:=Fheader.bzero+Fheader.bscale*imai8[0,i,j];
               x:=trunc(maxvalue([0,minvalue([255,(xx-dmin) * c ])]) );
               R:=itt[x];
               if n_axis=3 then begin
                 xx:=Fheader.bzero+Fheader.bscale*imai8[1,i,j];
                 x:=trunc(maxvalue([0,minvalue([255,(xx-dmin) * c ])]) );
                 G:=itt[x];
                 xx:=Fheader.bzero+Fheader.bscale*imai8[2,i,j];
                 x:=trunc(maxvalue([0,minvalue([255,(xx-dmin) * c ])]) );
                 B:=itt[x];
               end else begin
                 G:=R;
                 B:=R;
               end;
               if invertX then begin
                  P[4*(Fwidth-j)-1] := R;
                  P[4*(Fwidth-j)-1+1] := G;
                  P[4*(Fwidth-j)-1+2] := B;
               end else begin
                  P[4*j] := R ;
                  P[4*j+1] := G ;
                  P[4*j+2] := B ;
               end;
           end;
           end;
      16 : for i:=0 to Fheight-1 do begin
           if invertY then P:=imabmp.ScanLine[Fheight-1-i]
                      else P:=imabmp.ScanLine[i];
           for j := 0 to Fwidth-1 do begin
               xx:=Fheader.bzero+Fheader.bscale*imai16[0,i,j];
               x:=trunc(maxvalue([0,minvalue([255,(xx-dmin) * c ])]) );
               R:=itt[x];
               if n_axis=3 then begin
                 xx:=Fheader.bzero+Fheader.bscale*imai16[1,i,j];
                 x:=trunc(maxvalue([0,minvalue([255,(xx-dmin) * c ])]) );
                 G:=itt[x];
                 xx:=Fheader.bzero+Fheader.bscale*imai16[2,i,j];
                 x:=trunc(maxvalue([0,minvalue([255,(xx-dmin) * c ])]) );
                 B:=itt[x];
               end else begin
                 G:=R;
                 B:=R;
               end;
               if invertX then begin
                  P[4*(Fwidth-j)-1] := R;
                  P[4*(Fwidth-j)-1+1] := G;
                  P[4*(Fwidth-j)-1+2] := B;
               end else begin
                  P[4*j] := R ;
                  P[4*j+1] := G ;
                  P[4*j+2] := B ;
               end;
           end;
           end;
      32 : for i:=0 to Fheight-1 do begin
           if invertY then P:=imabmp.ScanLine[Fheight-1-i]
                      else P:=imabmp.ScanLine[i];
           for j := 0 to Fwidth-1 do begin
               xx:=Fheader.bzero+Fheader.bscale*imai32[0,i,j];
               x:=trunc(maxvalue([0,minvalue([255,(xx-dmin) * c ])]) );
               R:=itt[x];
               if n_axis=3 then begin
                 xx:=Fheader.bzero+Fheader.bscale*imai32[1,i,j];
                 x:=trunc(maxvalue([0,minvalue([255,(xx-dmin) * c ])]) );
                 G:=itt[x];
                 xx:=Fheader.bzero+Fheader.bscale*imai32[2,i,j];
                 x:=trunc(maxvalue([0,minvalue([255,(xx-dmin) * c ])]) );
                 B:=itt[x];
               end else begin
                 G:=R;
                 B:=R;
               end;
               if invertX then begin
                  P[4*(Fwidth-j)-1] := R;
                  P[4*(Fwidth-j)-1+1] := G;
                  P[4*(Fwidth-j)-1+2] := B;
               end else begin
                  P[4*j] := R ;
                  P[4*j+1] := G ;
                  P[4*j+2] := B ;
               end;
           end;
           end;
      end;
end;

Function TFits.ConnectDB(host,db,user,pass:string; port:integer):boolean;
begin
try
if DBtype=mysql then begin
  db1.SetPort(port);
  db1.Connect(host,user,pass,db);
end;
if db1.database<>db then db1.Use(db);
dbconnected:=db1.Active;
result:=dbconnected;
except
  dbconnected:=false;
  result:=false;
end;
end;

Function TFits.OpenDB(catalogname:string; ra1,ra2,dec1,dec2:double):boolean;
var qry,r1,r2,d1,d2 : string;
begin
if not db1.Active then result:=false
else begin
   r1:=formatfloat(f5,ra1);
   r2:=formatfloat(f5,ra2);
   d1:=formatfloat(f5,dec1);
   d2:=formatfloat(f5,dec2);
   qry:='SELECT filename,objectname,ra,de,width,height,rotation from cdc_fits where '+
        'catalogname="'+uppercase(catalogname)+'" and ';
   if ra2>ra1 then begin
      qry:=qry+' ra>'+r1+' and '+
               ' ra<'+r2;
   end else begin
      qry:=qry+' (ra>'+r1+' or '+
               ' ra<'+r2+')';
   end;
   qry:=qry+' and de>'+d1+' and '+
        ' de<'+d2+
        ' order by width desc';
   db1.Query(qry);
   result:=db1.RowCount>0;
   current_result:=-1;
end;
end;

Function TFits.GetDB(var filename,objname:string; var ra,de,width,height,rot:double):boolean;
begin
inc(current_result);
try
if current_result < db1.RowCount then begin
  filename:=db1.Results[current_result][0];
  objname:=db1.Results[current_result][1];
  ra:=strtofloat(db1.Results[current_result][2]);
  de:=strtofloat(db1.Results[current_result][3]);
  width:=strtofloat(db1.Results[current_result][4]);
  height:=strtofloat(db1.Results[current_result][5]);
  rot:=strtofloat(db1.Results[current_result][6]);
  result:=true;
end
else result:=false;
except
 result:=false;
end;
end;

Function TFits.GetFileName(catname,objectname:string; var filename:string):boolean;
begin
if not db1.Active then result:=false
else begin
  filename:=db1.QueryOne('SELECT filename from cdc_fits where '+
        'catalogname="'+uppercase(trim(catname))+'" and '+
        'objectname="'+uppercase(stringreplace(objectname,' ','',[rfReplaceAll]))+'" ');
  result:=filename<>'';
end;
end;

Function TFits.InsertDB(fname,cname,oname: string; ra,de,width,height,rotation:double):boolean;
var cmd:string;
begin
if not db1.Active then result:=false
else begin
      oname:=uppercase(stringreplace(oname,' ','',[rfReplaceAll]));
      cmd:='INSERT INTO cdc_fits (filename,catalogname,objectname,ra,de,width,height,rotation) VALUES ('
        +'"'+stringreplace(fname,'\','\\',[rfReplaceAll])+'"'
        +',"'+uppercase(cname)+'"'
        +',"'+uppercase(oname)+'"'
        +',"'+formatfloat(f5,ra)+'"'
        +',"'+formatfloat(f5,de)+'"'
        +',"'+formatfloat(f5,width)+'"'
        +',"'+formatfloat(f5,height)+'"'
        +',"'+formatfloat(f5,rotation)+'"'
        +')';
      result:= db1.query(cmd);
end;
end;

Function TFits.DeleteDB(cname,oname: string):boolean;
var cmd:string;
begin
if not db1.Active then result:=false
else begin
      oname:=uppercase(stringreplace(oname,' ','',[rfReplaceAll]));
      cname:=uppercase(cname);
      cmd:='DELETE FROM cdc_fits WHERE catalogname="'+cname+'" AND objectname="'+oname+'"';
      result:= db1.query(cmd);
end;
end;

end.
