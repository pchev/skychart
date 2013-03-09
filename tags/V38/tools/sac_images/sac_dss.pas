unit sac_dss;
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
Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
}
{
 Quick and dirty program to extract FITS images from Realsky for every object in the SAC database
 Make use of getdss.dll, see http://www.projectpluto.com/get_dss.htm
}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TForm1 = class(TForm)
    Button1: TButton;
    Label1: TLabel;
    Edit1: TEdit;
    Edit2: TEdit;
    Label2: TLabel;
    Edit3: TEdit;
    Label3: TLabel;
    Edit4: TEdit;
    Label4: TLabel;
    Edit5: TEdit;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

uses passql, pasmysql, libcatalog, math;

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
  Plate_data = packed record
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
      i,j,n,p,p1,p2,nax1,nax2,dmin,dmax,dmini,dmaxi,npix : integer;
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
      if keyword='CONTRAS4' then 
           try
             dmin:=strtoint(words(value,'',1,1));   // low value for good contrast 
           except
             dmin:=dmini;
         end;
      if keyword='CONTRAS9' then
           try
             dmax:=strtoint(words(value,'',9,1));   // high value for good contrast
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
  deletefile(nam);
  exit;
end;
s:='DATAMIN =   0'; move(s[1],header2[p,1],length(s));inc(p);
s:='DATAMAX = 255'; move(s[1],header2[p,1],length(s));inc(p);
s:='Based on photographic data obtained using The UK Schmidt Telescope.'; move(s[1],header2[p,1],length(s));inc(p);
s:='The UK Schmidt Telescope was operated by the Royal Observatory'; move(s[1],header2[p,1],length(s));inc(p);
s:='Edinburgh, with funding from the UK Science and Engineering Research'; move(s[1],header2[p,1],length(s));inc(p);
s:='Council, until 1988 June, and thereafter by the Anglo-Australian'; move(s[1],header2[p,1],length(s));inc(p);
s:='Observatory.  Original plate material is copyright (c) the Royal'; move(s[1],header2[p,1],length(s));inc(p);
s:='Observatory Edinburgh and the Anglo-Australian Observatory.  The'; move(s[1],header2[p,1],length(s));inc(p);
s:='plates were processed into the present compressed digital form with'; move(s[1],header2[p,1],length(s));inc(p);
s:='their permission.  The Digitized Sky Survey was produced at the Space'; move(s[1],header2[p,1],length(s));inc(p);
s:='Telescope Science Institute under US Government grant NAG W-2166.'; move(s[1],header2[p,1],length(s));inc(p);
s:='Investigators using these scans are requested to include the above'; move(s[1],header2[p,1],length(s));inc(p);
s:='acknowledgements in any publications.'; move(s[1],header2[p,1],length(s));inc(p);
s:='Copyright (c) 1993, 1994, 1997, Association of Universities for'; move(s[1],header2[p,1],length(s));inc(p);
s:='Research in Astronomy, Inc.  All rights reserved.'; move(s[1],header2[p,1],length(s));inc(p);
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

Procedure Magouille(nam:string; var sac:SACrec);
begin
if nam='IC434' then begin sac.s1:=80; sac.s2:=80;end
else if nam='NGC2237' then begin sac.s1:=120; sac.s2:=120 ; end
else if nam='NGC2238' then begin sac.s1:=1; sac.s2:=1  ; end
else if nam='IC5070' then begin sac.s1:=120; sac.s2:=120 ; end
else if nam='NGC6960' then begin sac.s1:=100; sac.s2:=100 ; sac.ar:=312.255; sac.de:=30.993; end
else if nam='M16' then begin sac.s1:=75; sac.s2:=75 ; end
else if nam='NGC1499' then begin sac.s1:=180; sac.s2:=180 ; sac.ar:=60.22083; sac.de:=36.41444;  end
else if nam='IC2118' then begin sac.s1:=140; sac.s2:=140 ; sac.ar:=76.12917; sac.de:=-6.960;  end
else if nam='Sh2-240' then begin sac.s1:=180; sac.s2:=180 ; sac.ar:=85.250; sac.de:=28.30;  end
else if nam='NGC7000' then begin sac.s1:=170; sac.s2:=170 ; end;
end;

procedure TForm1.Button1Click(Sender: TObject);
var sac : SACrec;
    ok : boolean;
    size,sub,i : integer;
    outdir,cmd: string;
    db:TmyDB;
    img : SImageConfig;
    pl: Plate_data;
    rc,datasource,n,margin : integer;
    exposure : double;
    dir,drv,ima,app,platename,nam : string;
const b=' ';
      f5='0.00000';
      f6='0.000000';
      npix=200;
      npix2=400;
      deg2rad = pi/180;
begin
datasource:=4;
dir:=edit3.Text;
drv:=edit4.Text;
app:=application.title;

outdir:=Edit2.text+'\';
if not directoryexists(outdir) then forcedirectories(outdir);
db:=TMyDB.create(self);
try
screen.cursor:=crHourGlass;
db.SetPort(3306);
db.database:='cdc';
db.Connect('localhost','root','','cdc');
db.Query('Truncate table cdc_fits');    // table must already be created by first running cdc_vcl
i:=0;
assignfile(log,'error.log');
rewrite(log);
SetSACpath(edit1.Text);
OpenSAC(0,24,-90,90,ok);
if ok then
  repeat
    ReadSAC(sac,ok);
    if ok then begin
    nam:=stringreplace(sac.nom1,' ','',[rfReplaceAll]);
    
    // use the following line for selective re-do.
    //if pos(nam+' ',' Sh2-240  ')=0 then continue;

    magouille(nam,sac);

    inc(i);
    edit5.Text:=inttostr(i)+'  '+sac.nom1;
    Application.ProcessMessages;
    ima:=ExpandFileName(outdir+nam+'.fit');
    // check unique object at this position (many ngc duplicate)
    cmd:='INSERT INTO cdc_fits (filename,catalogname,objectname,ra,de,width,height,rotation) VALUES ('
        +'"'+stringreplace(sac.nom1,'\','\\',[rfReplaceAll])+'"'
        +',"SAC"'
        +',"'+nam+'"'
        +',"'+formatfloat(f5,deg2rad*sac.ar)+'"'
        +',"'+formatfloat(f5,deg2rad*sac.de)+'"'
        +',"'+formatfloat(f5,0)+'"'
        +',"'+formatfloat(f5,0)+'"'
        +',"'+formatfloat(f5,0)+'"'+')';
    if not db.query(cmd) then begin Pseudofile(ima);writeln(log,'Non unique:'+sac.nom1);continue;end;
      size:=round(min(420,maxvalue([2,sac.s1,sac.s2])+1));

      if size<100 then
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

      sac.typ:=trim(sac.typ);
      if (sac.typ='Ast')or(sac.typ='-')or(pos('*',sac.typ)>0)or(sac.typ='Drk')or(sac.typ='Gcl') then continue;
      img.pImageFile:=Pchar(ima);
      img.SubSample:=sub;
      img.Ra:=deg2rad*sac.ar;
      img.De:=deg2rad*sac.de;
      img.Width:=size;
     // if nam='IC5070' then img.Width:=0.58*size; //at plate border
      img.Height:=size;
      img.Sender:=handle;
      img.pDir:=Pchar(dir);
      img.pDrive:=Pchar(drv);
      img.DataSource:=datasource;
      img.PromptForDisk:=false;
      img.pApplication:=Pchar(app);
      img.pPrompt1:=Pchar('disk');
      img.pPrompt2:=Pchar('drive');

      exposure:=0;
      margin:=-9999999;
      platename:='';
     // search a plate with reasonable margin and maximum exposure time
      rc:=GetPlateList(addr(img),addr(pl));
      if rc=0 then begin
        if pl.nplate>10 then pl.nplate:=10;
        for n:=1 to pl.nplate do begin
           margin:=max(margin,pl.dist_from_edge[n]);
           if (pl.dist_from_edge[n]>120)
              and (pl.exposure[n]>exposure)
              then begin
                 platename:=pl.plate_name[n];
                 exposure:=pl.exposure[n];
              end;
        end;
        if platename='' then begin writeln(log,'No Plate found:'+sac.nom1+' max margin:'+inttostr(margin));continue;end;
      end else begin writeln(log,'GetPlateList error:'+inttostr(rc)+' '+sac.nom1);continue;end;

      // extract image an dconvert to 8 bit to save space
      rc:=ImageExtractFromPlate(addr(img),Pchar(platename));
      if rc=0 then Conv8bit(ima)
      else begin writeln(log,'ImageExtractFromPlate error:'+inttostr(rc)+' '+sac.nom1);continue;end;
    end;
  until not ok;
finally
screen.cursor:=crdefault;
db.Query('Truncate table cdc_fits');
db.Free;
CloseSAC;
closefile(log);
end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  dsslib := LoadLibrary('getdss.dll');
  if dsslib<>0 then begin
    ImageExtract:= TImageExtract(GetProcAddress(dsslib, 'ImageExtract'));
    GetPlateList:= TGetPlateList(GetProcAddress(dsslib, 'GetPlateList'));
    ImageExtractFromPlate:= TImageExtractFromPlate(GetProcAddress(dsslib, 'ImageExtractFromPlate'));
  end
  else raise exception.Create('Could not load getdss.dll');
end;

end.
