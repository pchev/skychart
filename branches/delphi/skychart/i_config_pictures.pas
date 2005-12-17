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
 cdss:=@mycdss;
 inherited Create(AOwner);
end;

procedure Tf_config_pictures.FormShow(Sender: TObject);
begin
ShowImages;
end;

procedure Tf_config_pictures.ShowImages;
var save:boolean;
begin
imgpath.text:=cmain.ImagePath;
ImgLumBar.position:=-round(10*cmain.ImageLuminosity);
ImgContrastBar.position:=round(10*cmain.ImageContrast);
ImgLumBar2.position:=-round(10*cmain.ImageLuminosity);
ImgContrastBar2.position:=round(10*cmain.ImageContrast);
ShowImagesBox.checked:=csc.ShowImages;
nimages.caption:=inttostr(cdb.CountImages);
save:=csc.ShowBackgroundImage;
backimg.text:=csc.BackgroundImage;
ShowBackImg.checked:=save;
cmain.NewBackgroundImage:=false;
ImageTimer1.enabled:=false;
RealSkyNorth.Checked:=cdss.dssnorth;
RealSkySouth.Checked:=cdss.dsssouth;
DSS102CD.Checked:=cdss.dss102;
realskydir.text:=cdss.dssdir;
realskydrive.text:=cdss.dssdrive;
realskyfile.text:=cdss.dssfile;
reallist.checked:=cdss.dssplateprompt;
usesubsample.checked:=cdss.dsssampling;
realskymax.value:=cdss.dssmaxsize;
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
begin
screen.cursor:=crHourGlass;
ProgressPanel.visible:=true;
Cdb.ScanImagesDirectory(cmain.ImagePath,ProgressCat,ProgressBar1 );
ShowImagesBox.checked:=true;
screen.cursor:=crDefault;
ProgressPanel.visible:=false;
nimages.caption:=inttostr(cdb.CountImages);
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

procedure Tf_config_pictures.ImgContrastBar2Change(Sender: TObject);
begin
cmain.ImageContrast:=ImgContrastBar2.position/10;
FFits.max_sigma:=cmain.ImageContrast;
ImageTimer1.enabled:=true;
end;

procedure Tf_config_pictures.ImgLumBar2Change(Sender: TObject);
begin
cmain.ImageLuminosity:=-ImgLumBar2.position/10;
FFits.min_sigma:=cmain.ImageLuminosity;
ImageTimer1.enabled:=true;
end;

procedure Tf_config_pictures.ImageTimer1Timer(Sender: TObject);
begin
ImageTimer1.enabled:=false;
RefreshImage;
end;

{$ifdef linux}
procedure Tf_config_pictures.pa_imagesPageChanging(Sender: TObject; NewPage: TTabSheet; var AllowChange: Boolean);
begin
if (newpage.pageindex=1) then
    backimgChange(Sender);
AllowChange:=true;
end;
{$endif}

procedure Tf_config_pictures.backimgChange(Sender: TObject);
begin
csc.BackgroundImage:=backimg.text;
Ffits.filename:=csc.BackgroundImage;
if Ffits.header.coordinate_valid then begin
  cmain.NewBackgroundImage:=true;
  ShowBackImg.checked:=true;
  backimginfo.caption:=extractfilename(csc.BackgroundImage)+' RA:'+ARtoStr(Ffits.center_ra*rad2deg/15)+' DEC:'+DEtoStr(Ffits.center_de*rad2deg)+' FOV:'+DEtoStr(Ffits.img_width*rad2deg);
  RefreshImage;
end
else begin
  backimginfo.caption:='No picture';
  ShowBackImg.checked:=false;
  Image1.canvas.brush.color:=clBlack;
  Image1.canvas.pen.color:=clBlack;
  Image1.canvas.rectangle(0,0,Image1.width,Image1.Height);
end;
end;

Procedure  Tf_config_pictures.RefreshImage;
var bmp: TBitmap;
    c1,c2:double;
    x,y,dx,dy:integer;
begin
  bmp:=Tbitmap.create;
  FFits.GetBitmap(bmp);
  c1:=Image1.width/Image1.Height;
  c2:=bmp.width/bmp.Height;
  if c1>c2 then begin
    dy:=Image1.Height;
    dx:=round(c2*dy);
    y:=0;
    x:=round((Image1.width-dx)/2);
  end else begin
    dx:=Image1.width;
    dy:=round(dx/c2);
    x:=0;
    y:=round((Image1.Height-dy)/2);
  end;
  Image1.canvas.brush.color:=clBlack;
  Image1.canvas.pen.color:=clBlack;
  Image1.canvas.rectangle(0,0,Image1.width,Image1.Height);
  Image1.canvas.stretchdraw(rect(x,y,x+dx,y+dy),bmp);
  bmp.Free;
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

procedure Tf_config_pictures.DSS102CDClick(Sender: TObject);
begin
cdss.dss102:=DSS102CD.Checked;
if DSS102CD.Checked then begin
   RealSkyNorth.Checked:=false;
   RealSkySouth.Checked:=false;
end;
end;

procedure Tf_config_pictures.RealSkyNorthClick(Sender: TObject);
begin
cdss.dssnorth:=RealSkyNorth.Checked;
if RealSkyNorth.Checked then begin
   DSS102CD.Checked:=false;
end;
end;

procedure Tf_config_pictures.RealSkySouthClick(Sender: TObject);
begin
cdss.dsssouth:=RealSkySouth.Checked;
if RealSkySouth.Checked then begin
   DSS102CD.Checked:=false;
end;
end;

procedure Tf_config_pictures.realskymaxChange(Sender: TObject);
begin
cdss.dssmaxsize:=realskymax.value;
realskymb.value:=round(sqr(realskymax.value)*2/1024/1024);
end;


procedure Tf_config_pictures.realskydirChange(Sender: TObject);
begin
cdss.dssdir:=realskydir.text;
if fileexists(slash(cdss.dssdir)+'hi_comp.lis') then
   realskydir.color:=realskydrive.color
else
   realskydir.color:=clRed;
end;

procedure Tf_config_pictures.realskydriveChange(Sender: TObject);
begin
cdss.dssdrive:=realskydrive.text;
end;

procedure Tf_config_pictures.realskyfileChange(Sender: TObject);
begin
cdss.dssfile:=realskyfile.text;
end;

procedure Tf_config_pictures.reallistClick(Sender: TObject);
begin
cdss.dssplateprompt:=reallist.checked;
end;

procedure Tf_config_pictures.usesubsampleClick(Sender: TObject);
begin
cdss.dsssampling:=usesubsample.checked;
end;


