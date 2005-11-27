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
{
 Interface to GetDSS to extract DSS images from Realsky CDrom.
}

procedure Tf_getdss.FormCreate(Sender: TObject);
begin
  dsslib := LoadLibrary(dsslibname);
  if dsslib<>0 then begin
    ImageExtract:= TImageExtract(GetProcAddress(dsslib, 'ImageExtract'));
    GetPlateList:= TGetPlateList(GetProcAddress(dsslib, 'GetPlateList'));
    ImageExtractFromPlate:= TImageExtractFromPlate(GetProcAddress(dsslib, 'ImageExtractFromPlate'));
    Fenabled:=true;
  end else begin
    Fenabled:=false;
    writetrace(dsslibname+' not found');
  end;
end;

procedure Tf_getdss.FormDestroy(Sender: TObject);
begin
Fenabled:=false;
ImageExtract:=nil;
GetPlateList:=nil;
ImageExtractFromPlate:=nil;
if dsslib<>0 then Freelibrary(dsslib);
end;


procedure Tf_getdss.FormShow(Sender: TObject);
begin

end;

function Tf_getdss.GetDss(ra,de,fov,ratio:double):boolean;
var i : SImageConfig;
    pl: Plate_data;
    rc,datasource,subsample,n : integer;
    width,height,npix,imgsize : double;
    ima,app,platename,buf : string;
begin
try
  result:=false;
  if not Fenabled then exit;
  datasource:=0;
  if cfgdss.dss102 then datasource:=3
  else if cfgdss.dssnorth and cfgdss.dsssouth then datasource:=4
  else if cfgdss.dssnorth then datasource:=1
  else if cfgdss.dsssouth then datasource:=2;
  if datasource=0 then begin ShowMessage('Please configure your DSS file path first.'); exit; end;
  ima:=ExpandFileName(cfgdss.dssfile);
  i.pDir:=Pchar(slash(expandfilename(cfgdss.dssdir)));
  i.pDrive:=Pchar(slash(cfgdss.dssdrive));
  i.pImageFile:=Pchar(ima);
  i.DataSource:=datasource;
  i.PromptForDisk:=true;
  width:=fov*rad2deg*60;
  height:=width/ratio;
  if min(width,height) > 420 then begin ShowMessage('Field too width! Maximum is 7'+ldeg); exit; end;
  width:=min(width,400);
  height:=min(height,400);
  if cfgdss.dsssampling then begin
    npix:=max(width,height)*60/1.7;
    n:=trunc(npix/cfgdss.dssmaxsize);
    case n of
         0    : subsample:=1;
         1    : subsample:=2;
         2..3 : subsample:=4;
         4    : subsample:=5;
         5..9 : subsample:=10;
        10..19: subsample:=20;
        20..24: subsample:=25;
           else subsample:=50;
    end;
  end else begin
      subsample:=1;
      imgsize:=(width*60/1.7/subsample)*(height*60/1.7/subsample)*2/1024/1024;
      if imgsize>8 then begin
         if MessageDlg('Estimated file size: '+floattostrf(imgsize,ffFixed,6,0)+'MB '+crlf+'Do you want to continue ?',
            mtWarning,[mbOk, mbCancel],0)<>mrOK then exit;
      end;
  end;
  i.SubSample:=subsample;
  i.Ra:=ra;
  i.De:=de;
  i.Width:=width;
  i.Height:=height;
  i.Sender:=integer(handle);
  app:=application.title;
  i.pApplication:=Pchar(app);
  i.pPrompt1:=Pchar('Please mount RealSky® CD number');
  i.pPrompt2:=Pchar('in drive');
  {$ifdef linux}
  exec('export LC_ALL=C');
  chdir(TempDir);
  {$endif}
  if cfgdss.dssplateprompt then begin
    rc:=GetPlateList(addr(i),addr(pl));
    if (rc<>0) then exit;
      listbox1.clear;
      label1.caption:='Plate Id.    Date   Exp.  Margin  CD  Observatory';
      if pl.nplate>10 then pl.nplate:=10;
      for n:=1 to pl.nplate do begin
        buf:=copy(pl.plate_name[n]+'   ',1,5)+' '+
             copy(pl.gsc_plate_name[n]+'   ',1,5)+'  '+
             Formatfloat('0000',pl.year_imaged[n])+'   '+
             Formatfloat('000',pl.exposure[n])+'   '+
             Formatfloat('"+"00000;"-"00000',pl.dist_from_edge[n])+'  '+
             Formatfloat('000',pl.cd_number[n])+'   ';
        if pl.is_uk_survey[n]=0 then buf:=buf+'PAL'
                                else buf:=BUF+'UK';
        listbox1.items.Add(buf);
      end;
      listbox1.itemindex:=0;
      showmodal;
      if ModalResult<>mrOK then exit;
      platename:=pl.plate_name[listbox1.itemindex+1];
    {$ifdef linux}
    repeat
    {$endif}
    rc:=ImageExtractFromPlate(addr(i),Pchar(platename));
    {$ifdef linux}
    if rc>0 then begin
      if (MessageDlg(i.pPrompt1+blank+inttostr(rc)+crlf+i.pPrompt2+blank+cfgdss.dssdrive,mtConfirmation,[mbOK, mbCancel],0)<>mrOK) then
         rc:=-999;
    end;
    until rc<=0;
    {$endif}
  end
  else begin
   {$ifdef linux}
    repeat
    {$endif}
     rc:=ImageExtract(addr(i));
    {$ifdef linux}
    if rc>0 then begin
      if (MessageDlg(i.pPrompt1+blank+inttostr(rc)+crlf+i.pPrompt2+blank+cfgdss.dssdrive,mtConfirmation,[mbOK, mbCancel],0)<>mrOK) then
         rc:=-999;
    end;
    until rc<=0;
    {$endif}
  end;
  result:=(rc=0);
finally
  chdir(appdir);
end;
end;

