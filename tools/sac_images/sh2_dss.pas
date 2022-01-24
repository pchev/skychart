unit sh2_dss;

{$MODE Delphi}{$H+}

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
{
 Quick and dirty program to extract FITS images from Realsky for every object in the SAC database
 Make use of getdss.dll, see http://www.projectpluto.com/get_dss.htm
}

interface

uses dynlibs, gcatunit, findunit,
  LCLIntf, LCLType, LMessages, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, FileUtil;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Edit6: TEdit;
    Edit2: TEdit;
    Label2: TLabel;
    Edit3: TEdit;
    Label3: TLabel;
    Edit4: TEdit;
    Label4: TLabel;
    Edit5: TEdit;
    Label5: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    ngcH : TCatHeader;
    ngcinfo:TCatHdrInfo;
    ngcversion : integer;
    ngcGCatFilter: Boolean;
 public
    { Public declarations }
  end;

var
  Form1: TForm1;

const b=' ';
      f4='0.0000';
      f5='0.00000';
      f6='0.000000';
      npix=300;
      npix2=600;
      deg2rad = pi/180;
      rad2deg = 180/pi;
      pi2 = 2*pi;
      jd2000 = 2451545.0;

implementation

{$R *.lfm}

uses unix, passql, passqlite, math;

type
  SImageConfig = record
     pDir : Pchar;
     pDrive : Pchar;
     pImageFile : Pchar;
     DataSource : integer;
     PromptForDisk : boolean;
     SubSample : integer;
     Ra : double;
     De : double;
     Width : double;
     Height : double;
     Sender : Thandle;
     pApplication :Pchar;
     pPrompt1 : Pchar;
     pPrompt2 : Pchar;
  end;
  Plate_data = record
   nplate : integer;
   plate_name, gsc_plate_name : array[1..10]of Pchar;
   dist_from_edge, cd_number, is_uk_survey : array[1..10]of integer;
   year_imaged, exposure : array[1..10]of double;
  end;
  PImageConfig = ^SImageConfig;
  PPlate_data = ^Plate_data;
  TImageExtract=function( img : PImageConfig): Integer; cdecl;
  TGetPlateList=function( img : PImageConfig; pl : PPlate_data): Integer; cdecl;
  TImageExtractFromPlate=function( img : PImageConfig; ReqPlateName : Pchar): Integer; cdecl;
  Timai8 =  array of array of byte;
  TPimai8 = ^Timai8;
  Timai16 = array of array of smallint;
  TPimai16 = ^Timai16;

var  ImageExtract: TImageExtract;
     GetPlateList: TGetPlateList;
     ImageExtractFromPlate: TImageExtractFromPlate;
     dsslib : Dword;
     log: textfile;
     imai8 : Timai8;
     imai16 : Timai16;

function InvertI16(X : word) : smallInt;
var  P : PbyteArray;
     temp : word;
begin
    P:=@X;
    temp:=(P[0] shl 8) or (P[1]);
    move(temp,result,2);
end;

function words(str,sep : string; p,n : integer) : string;
var     i,j : Integer;
begin
result:='';
str:=trim(str);
for i:=1 to p-1 do begin
 j:=pos(' ',str);
 if j=0 then j:=length(str)+1;
 str:=trim(copy(str,j,length(str)));
end;
for i:=1 to n do begin
 j:=pos(' ',str);
 if j=0 then j:=length(str)+1;
 result:=result+trim(copy(str,1,j))+sep;
 str:=trim(copy(str,j,length(str)));
end;
end;

Procedure Conv8bit(nam:string);
var   header1,header2 : array[1..36,1..80] of char;
      i,j,n,p,p1,p2,nax1,nax2,dmin,dmax,dmini,dmaxi,npix,d1,d2 : integer;
      eoh : boolean;
      x : double;
      keyword,buf,value,s : string;
      f : file;
      d8  : array[1..2880] of byte;
      d16 : array[1..1440] of word;
begin
// Read header
assignfile(f,nam);
reset(f,1);
eoh:=false;
FillChar(header2, SizeOf(header2), ' ');
p:=1;
repeat
   blockread(f,header1,sizeof(header1),n);
   for i:=1 to 36 do begin
      p1:=pos('=',header1[i]);
      if p1=0 then p1:=9;
      p2:=pos('/',header1[i]);
      if p2=0 then p2:=80;
      keyword:=trim(copy(header1[i],1,p1-1));
      value:=trim(copy(header1[i],p1+1,p2-p1-1));
      if keyword='SIMPLE' then begin header2[p]:=header1[i]; inc(p);end;
      if keyword='BITPIX' then begin
         s:='BITPIX  =                    8'; move(s[1],header2[p,1],length(s));inc(p);
         end;
      if keyword='NAXIS' then begin header2[p]:=header1[i]; inc(p);end;
      if keyword='NAXIS1' then begin nax1:=strtoint(value);header2[p]:=header1[i]; inc(p);end;
      if keyword='NAXIS2' then begin nax2:=strtoint(value);header2[p]:=header1[i]; inc(p);end;
      if keyword='DATE-OBS' then begin header2[p]:=header1[i]; inc(p);end;
      if (keyword='EQUINOX')and (value='2000.0') then begin header2[p]:=header1[i]; inc(p);end;
      if keyword='EXPOSURE' then begin header2[p]:=header1[i]; inc(p);end;
      if keyword='TELESCOP' then begin header2[p]:=header1[i]; inc(p);end;
      if keyword='RADESYS' then begin header2[p]:=header1[i]; inc(p);end;
      if keyword='CTYPE1' then begin header2[p]:=header1[i]; inc(p);end;
      if keyword='CTYPE2' then begin header2[p]:=header1[i]; inc(p);end;
      if keyword='CRVAL1' then begin header2[p]:=header1[i]; inc(p);end;
      if keyword='CRVAL2' then begin header2[p]:=header1[i]; inc(p);end;
      if keyword='CRPIX1' then begin header2[p]:=header1[i]; inc(p);end;
      if keyword='CRPIX2' then begin header2[p]:=header1[i]; inc(p);end;
      if keyword='CDELT1' then begin header2[p]:=header1[i]; inc(p);end;
      if keyword='CDELT2' then begin header2[p]:=header1[i]; inc(p);end;
      if keyword='CROTA2' then begin header2[p]:=header1[i]; inc(p);end;
      if keyword='DATAMIN' then dmini:=strtoint(value);
      if keyword='DATAMAX' then dmaxi:=strtoint(value);
      if keyword='CONTRAS1' then
           try
             dmin:=strtoint(words(value,'',1,1));   // low value for good contrast 
           except
             dmin:=dmini;
         end;
      if keyword='CONTRAS9' then
           try
             d1:=strtoint(words(value,'',9,1));
             d2:=strtoint(words(value,'',10,1));
             dmax:=d1;   // high value for good contrast
           except
             dmax:=dmaxi;
         end;
      if (keyword='END') then begin
         eoh:=true;
      end;
   end;
until eoh;
if dmin=dmax then begin
  Closefile(f);
  writeln(log,'DATAMIN=DATAMAX : '+nam);
  DeleteFile(nam);
  exit;
end;
s:='DATAMIN =   0'; move(s[1],header2[p,1],length(s));inc(p);
s:='DATAMAX = 255'; move(s[1],header2[p,1],length(s));inc(p);
s:='COMMENT Extracted from Digitized Sky Survey 101 CD-ROMs.'; move(s[1],header2[p,1],length(s));inc(p);
s:='END'; move(s[1],header2[p,1],length(s));

// Read 16 bit image
setlength(imai16,nax1,nax2);
npix:=1440;
for i:=0 to nax2-1 do begin
  for j := 0 to nax1-1 do begin
     if (npix = 1440) then begin
         BlockRead(f,d16,sizeof(d16),n);
         npix:=0;
     end;
     inc(npix);
     imai16[i,j] := round(InvertI16(d16[npix]));
   end;
end;
Closefile(f);

// Write 8 bit FITS
assignfile(f,nam);
rewrite(f,1);
blockwrite(f,header2,sizeof(header2),n);
npix:=0;
for i:=0 to nax2-1 do begin
  for j := 0 to nax1-1 do begin
     inc(npix);
     x:=max(0,(imai16[i,j]-dmin));
     d8[npix]:=round(min(255,255*x/(dmax-dmin)));
     if npix=2880 then begin
        blockwrite(f,d8,sizeof(d8),n);
        npix:=0;
     end;
   end;
end;
if npix>0 then begin
  for i:=npix+1 to 2880 do d8[i]:=0;
  blockwrite(f,d8,sizeof(d8),n);
end;
Closefile(f);
end;

Procedure Pseudofile(n:string);
var f : file;
    header : array [1..36,1..80] of char;
    s : shortstring;
    i : integer;
begin
n:=changefileext(n,'.nil');
FillChar(header, SizeOf(header), ' ');
i:=1;
s:='SIMPLE  =                    F'; move(s[1],header[i,1],length(s));inc(i);
s:='BITPIX  =                    8'; move(s[1],header[i,1],length(s));inc(i);
s:='NAXIS   =                    0'; move(s[1],header[i,1],length(s));inc(i);
s:=' DUMMY FILE USED AS A PLACE HOLDER TO AVOID TO DRAW A SYMBOL'; move(s[1],header[i,1],length(s));inc(i);
s:=' BECAUSE THE IMAGE IS GIVEN BY A VERY NEARBY OTHER OBJECT'; move(s[1],header[i,1],length(s));inc(i);
s:='END      ' ; move(s[1],header[i,1],length(s));
assignfile(f,n);
rewrite(f,1);
blockwrite(f,header,sizeof(header),i);
closefile(f);
end;

Function Exec(cmd: string; hide: boolean=true): integer;
begin
 result:=fpSystem(cmd);
end;

function Rmod(x, y: double): double;
begin
  Rmod := x - Int(x / y) * y;
end;

procedure PrecessionFK5(ti, tf: double; var ari, dei: double);  // Lieske 77
var
  i1, i2, i3, i4, i5, i6, i7: double;
begin
  if abs(ti - tf) < 0.01 then
    exit;
  I1 := (TI - 2451545.0) / 36525;
  I2 := (TF - TI) / 36525;
  I3 := deg2rad * ((2306.2181 + 1.39656 * i1 - 1.39e-4 * i1 * i1) *
    i2 + (0.30188 - 3.44e-4 * i1) * i2 * i2 + 1.7998e-2 * i2 * i2 * i2) / 3600;
  I4 := deg2rad * ((2306.2181 + 1.39656 * i1 - 1.39e-4 * i1 * i1) *
    i2 + (1.09468 + 6.6e-5 * i1) * i2 * i2 + 1.8203e-2 * i2 * i2 * i2) / 3600;
  I5 := deg2rad * ((2004.3109 - 0.85330 * i1 - 2.17e-4 * i1 * i1) *
    i2 - (0.42665 + 2.17e-4 * i1) * i2 * i2 - 4.1833e-2 * i2 * i2 * i2) / 3600;
  I6 := COS(DEI) * SIN(ARI + I3);
  I7 := COS(I5) * COS(DEI) * COS(ARI + I3) - SIN(I5) * SIN(DEI);
  i1 := (SIN(I5) * COS(DEI) * COS(ARI + I3) + COS(I5) * SIN(DEI));
  if i1 > 1 then
    i1 := 1;
  if i1 < -1 then
    i1 := -1;
  DEI := ArcSIN(i1);
  ARI := ARCTAN2(I6, I7);
  ARI := ARI + I4;
  ARI := RMOD(ARI + pi2, pi2);
end;

procedure TForm1.Button1Click(Sender: TObject);
var rec : GCatrec;
    ok : boolean;
    sub,i : integer;
    outdir,cmd,dbn: string;
    db:TLiteDB;
    img : SImageConfig;
    pl: Plate_data;
    rc,datasource,n,margin,marg,retry : integer;
    size,exposure,ra,de : double;
    dir,drv,ima,app,platename,nam : string;
begin
{$ifdef unix}
  exec('export LC_ALL=C');
{$endif}
datasource:=3;
dir:=edit3.Text;
drv:=edit4.Text;
app:=application.title;

outdir:=Edit2.text;
if not DirectoryExists(outdir) then ForceDirectories(outdir);
db:=TLiteDB.create(self);
try
screen.cursor:=crHourGlass;
dbn:=ExpandFileName('~/.skychart/database/cdc.db');
dbn:=UTF8Encode(dbn);
db.Use(dbn);
if not db.TruncateTable('cdc_fits') then begin // table must already be created by first running skychart
  ShowMessage(db.ErrorMessage);
  exit;
end;
i:=0;
assignfile(log,'error.log');
rewrite(log);
SetGcatPath(edit6.text,'sh 2');
GetGCatInfo(ngcH,ngcinfo,ngcversion,ngcGCatFilter,ok);
if not ok then begin
  edit5.text:='Wrong Sh2 path';
  exit;
end;
OpenGCat(0,24,-90,90,ok);
if ok then
  repeat
    ReadGCat(rec,ok);
    if ok then begin

    nam:=stringreplace(rec.neb.id,' ','',[rfReplaceAll]);

    if maxvalue([rec.neb.dim1,rec.neb.dim2])>245 then begin
      writeln(log,'Skip too big:  '+nam);
      continue;
    end;

    // use the following line for selective re-do.
    //if pos(nam+' ',' Sh2-170 ')=0 then continue;

    ra:=deg2rad*rec.ra;
    de:=deg2rad*rec.dec;
    PrecessionFK5(rec.options.EquinoxJD,jd2000,ra,de);

    inc(i);
    edit5.Text:=inttostr(i)+'  '+nam;
    Application.ProcessMessages;
    ima:=ExpandFileName(outdir+nam+'.fit');
    // check unique object at this position (many ngc duplicate)
    cmd:='INSERT INTO cdc_fits (filename,catalogname,objectname,ra,de,width,height,rotation) VALUES ('
        +'"'+stringreplace(nam,'\','\\',[rfReplaceAll])+'"'
        +',"SH 2"'
        +',"'+nam+'"'
        +',"'+formatfloat(f4,ra)+'"'
        +',"'+formatfloat(f4,de)+'"'
        +',"'+formatfloat(f5,0)+'"'
        +',"'+formatfloat(f5,0)+'"'
        +',"'+formatfloat(f5,0)+'"'+')';

    if (not db.query(cmd))and(copy(nam,1,1)<>'M') then begin
      Pseudofile(ima);
      writeln(log,'Non unique:'+nam);
      continue;
    end;

      size:=min(420,maxvalue([3.0,rec.neb.dim1,rec.neb.dim2]));
      size:=1.2*size; // margin for small objects

      if size<30 then
         sub:=trunc(size*60/1.7/npix)
      else
         sub:=trunc(size*60/1.7/npix2);
      if sub <=1 then sub:=1
      else if sub <=3 then sub:=2
      else if sub <=4 then sub:=4
      else if sub <=5 then sub:=5
      else if sub <=15 then sub:=10
      else if sub <=22 then sub:=20
      else if sub <=40 then sub:=25
      else if sub <=75 then sub:=50
      else if sub <=110 then sub:=100
      else if sub <=180 then sub:=125
      else if sub <=300 then sub:=250
      else sub:=500;

      img.pImageFile:=Pchar(ima);
      img.SubSample:=sub;
      img.Ra:=ra;
      img.De:=de;
      img.Width:=size;
      img.Height:=size;
      img.Sender:=integer(handle);
      img.pDir:=Pchar(dir);
      img.pDrive:=Pchar(drv);
      img.DataSource:=datasource;
      img.PromptForDisk:=false;
      img.pApplication:=Pchar(app);
      img.pPrompt1:=Pchar('disk');
      img.pPrompt2:=Pchar('drive');

      exposure:=0;
      margin:=-9999999;
      marg:=-9999999;
      platename:='';
      retry:=0;
      // search a plate with reasonable margin and maximum exposure time
      repeat
        rc:=GetPlateList(@img,@pl);
        if rc=0 then begin
          if pl.nplate>10 then pl.nplate:=10;
          for n:=1 to pl.nplate do begin
             margin:=max(margin,pl.dist_from_edge[n]);
             if (pl.dist_from_edge[n]>170) and
                (((pl.exposure[n]>exposure)and(pl.dist_from_edge[n]>300))or(pl.dist_from_edge[n]>marg))
                then begin
                   platename:=pl.plate_name[n];
                   exposure:=pl.exposure[n];
                   marg:=pl.dist_from_edge[n];
                end;
          end;
        end else begin
          writeln(log,'GetPlateList error:'+inttostr(rc)+' '+nam);
          continue;
        end;
        if platename='' then begin
          inc(retry);
          size:=size/1.5;
          img.Width:=size;
          img.Height:=size;
        end;
      until (platename<>'')or(retry>3);
      if platename='' then begin
        writeln(log,'No Plate found:'+nam+' max margin:'+inttostr(margin));
        continue;
      end;
      // extract image and convert to 8 bit to save space
      rc:=ImageExtractFromPlate(addr(img),Pchar(platename));
      if rc=0 then Conv8bit(ima)
      else begin writeln(log,'ImageExtractFromPlate error:'+inttostr(rc)+' '+nam);continue;end;
    end;
  until not ok;
finally
screen.cursor:=crdefault;
db.TruncateTable('cdc_fits');
db.Free;
CloseGCat;
closefile(log);
end;
end;

procedure TForm1.FormCreate(Sender: TObject);
const
{$ifdef mswindows}
  libname = 'libgetdss.dll';
{$else}
  libname = 'libpasgetdss.so.1';
{$endif}
begin
  dsslib := LoadLibrary(libname);
  if dsslib<>0 then begin
    ImageExtract:= TImageExtract(GetProcedureAddress(dsslib, 'ImageExtract'));
    GetPlateList:= TGetPlateList(GetProcedureAddress(dsslib, 'GetPlateList'));
    ImageExtractFromPlate:= TImageExtractFromPlate(GetProcedureAddress(dsslib, 'ImageExtractFromPlate'));
  end
  else raise exception.Create('Could not load '+libname);
end;

end.
