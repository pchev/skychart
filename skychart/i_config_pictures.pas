{
Copyright (C) 2005 Patrick Chevalley

http://www.astrosurf.com/astropc
pch@freesurf.ch

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

constructor Tf_config_pictures.Create(AOwner:TComponent);
begin
 csc:=@mycsc;
 ccat:=@myccat;
 cshr:=@mycshr;
 cplot:=@mycplot;
 cmain:=@mycmain;
 inherited Create(AOwner);
end;

procedure Tf_config_pictures.FormShow(Sender: TObject);
begin
if db=nil then
  if DBtype=mysql then
    db:=TMyDB.create(self)
  else if DBtype=sqlite then
    db:=TLiteDB.create(self);
ShowImages;
end;

procedure Tf_config_pictures.ShowImages;
var save:boolean;
begin
imgpath.text:=cmain.ImagePath;
ImgLumBar.position:=-round(10*cmain.ImageLuminosity);
ImgContrastBar.position:=round(10*cmain.ImageContrast);
ShowImagesBox.checked:=csc.ShowImages;
CountImages;
save:=csc.ShowBackgroundImage;
backimg.text:=csc.BackgroundImage;
ShowBackImg.checked:=save;
cmain.NewBackgroundImage:=false;
end;

procedure Tf_config_pictures.CountImages;
begin
try
if DBtype=mysql then begin
  db.SetPort(cmain.dbport);
  db.database:=cmain.db;
  db.Connect(cmain.dbhost,cmain.dbuser,cmain.dbpass,cmain.db);
end;
if db.database<>cmain.db then db.Use(cmain.db);
if db.Active then begin
  nimages.caption:=db.QueryOne('select count(*) from cdc_fits');
end;
finally
end;
end;

procedure Tf_config_pictures.imgpathChange(Sender: TObject);
begin
cmain.ImagePath:=imgpath.text;
end;

procedure Tf_config_pictures.BitBtn3Click(Sender: TObject);
begin
{$ifdef mswindows}
  FolderDialog1.Directory:=imgpath.text;
  if FolderDialog1.execute then
     imgpath.text:=FolderDialog1.Directory;
{$endif}
{$ifdef linux }
  f_directory.DirectoryTreeView1.Directory:=imgpath.text;
  f_directory.showmodal;
  if f_directory.modalresult=mrOK then
     imgpath.text:=f_directory.DirectoryTreeView1.Directory;
{$endif}
end;



procedure Tf_config_pictures.ScanImagesClick(Sender: TObject);
var c,f : tsearchrec;
    i,j,n,p:integer;
    catdir,objn,fname:string;
    dummyfile : boolean;
    ra,de,w,h,r: double;
begin
try
if DBtype=mysql then begin
  db.SetPort(cmain.dbport);
  db.database:=cmain.db;
  db.Connect(cmain.dbhost,cmain.dbuser,cmain.dbpass,cmain.db);
end;
if db.database<>cmain.db then db.Use(cmain.db);
if db.Active then begin
screen.cursor:=crHourGlass;
ProgressCat.caption:='';
ProgressBar1.position:=0;
ProgressPanel.visible:=true;
if DBtype=mysql then db.Query('UNLOCK TABLES');
db.starttransaction;
db.Query(truncatetable[DBtype]+' cdc_fits');
db.commit;
j:=findfirst(slash(cmain.ImagePath)+'*',faDirectory,c);
while j=0 do begin
  if ((c.attr and faDirectory)<>0)and(c.Name<>'.')and(c.Name<>'..') then begin
  catdir:=slash(cmain.ImagePath)+c.Name;
  ProgressCat.caption:=c.Name;
  ProgressBar1.position:=0;
  ProgressPanel.Refresh;
  Application.processmessages;
  i:=findfirst(slash(catdir)+'*.*',0,f);
  n:=1;
  while i=0 do begin
   inc(n);
   i:=findnext(f);
  end;
  ProgressBar1.min:=0;
  ProgressBar1.max:=n;
  if (ProgressBar1.Max > 25) then
    ProgressBar1.Step := ProgressBar1.Max div 25
  else
    ProgressBar1.Step := 1;
  i:=findfirst(slash(catdir)+'*.*',0,f);
  n:=0;
  while i=0 do begin
    inc(n);
    if (n mod ProgressBar1.step)=0 then begin ProgressBar1.stepit; Application.processmessages; end;
    dummyfile:=(extractfileext(f.Name)='.nil');
    if dummyfile then begin
      ra:=99+random(999999999999999);
      de:=99+random(999999999999999);
      w:=0;
      h:=0;
      r:=0;
      fname:=slash(catdir)+f.Name;
    end else begin
      FFits.FileName:=slash(catdir)+f.Name;
      ra:=FFits.Center_RA;
      de:=FFits.Center_DE;
      w:=FFits.Img_Width;
      h:=FFits.img_Height;
      r:=FFits.Rotation;
      fname:=FFits.FileName;
    end;
    if FFits.header.valid or dummyfile then begin
      objn:=extractfilename(f.Name);
      p:=pos(extractfileext(objn),objn);
      objn:=copy(objn,1,p-1);
      if not FFits.InsertDB(fname,c.Name,objn,ra,de,w,h,r) then
         writetrace('DB insert failed for '+f.Name+' :'+db.ErrorMessage);
    end
    else writetrace('Invalid FITS file: '+f.Name);
    i:=findnext(f);
  end;
  end;
  j:=findnext(c);
end;
db.Query(flushtable[DBtype]);
end;
ShowImagesBox.checked:=true;
finally
  screen.cursor:=crDefault;
  ProgressPanel.visible:=false;
  findclose(c);
  findclose(f);
end;
CountImages;
end;

procedure Tf_config_pictures.ImgLumBarChange(Sender: TObject);
begin
cmain.ImageLuminosity:=-ImgLumBar.position/10;
end;

procedure Tf_config_pictures.ImgContrastBarChange(Sender: TObject);
begin
cmain.ImageContrast:=ImgContrastBar.position/10;
end;

procedure Tf_config_pictures.ShowImagesBoxClick(Sender: TObject);
begin
csc.ShowImages:=ShowImagesBox.checked;
end;

procedure Tf_config_pictures.backimgChange(Sender: TObject);
begin
csc.BackgroundImage:=backimg.text;
Ffits.filename:=csc.BackgroundImage;
if Ffits.header.coordinate_valid then begin
  cmain.NewBackgroundImage:=true;
  ShowBackImg.checked:=true;
  backimginfo.caption:=extractfilename(csc.BackgroundImage)+' RA:'+ARtoStr(Ffits.center_ra*rad2deg/15)+' DEC:'+DEtoStr(Ffits.center_de*rad2deg)+' FOV:'+DEtoStr(Ffits.img_width*rad2deg);
end
else begin
  backimginfo.caption:='No picture';
  ShowBackImg.checked:=false;
end;
end;

procedure Tf_config_pictures.BitBtn5Click(Sender: TObject);
var f : string;
begin
f:=expandfilename(backimg.text);
opendialog1.InitialDir:=extractfilepath(f);
opendialog1.filename:=extractfilename(f);
opendialog1.Filter:='FITS Files|*.fit';
opendialog1.DefaultExt:='';
try
if opendialog1.execute then begin
   backimg.text:=opendialog1.FileName;
end;
finally
 chdir(appdir);
end;
end;

procedure Tf_config_pictures.ShowBackImgClick(Sender: TObject);
begin
csc.ShowBackgroundImage:=ShowBackImg.checked;
cmain.NewBackgroundImage:=csc.ShowBackgroundImage;
end;

