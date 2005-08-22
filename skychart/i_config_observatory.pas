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

var
   SetDirectory : function(dir:pchar): integer; stdcall;
   ReadCountryFile: function (country:pchar; var City: PCities; var cfile:array of char): integer; stdcall;
   AddCity: function(City: PCity): integer; stdcall;
   ModifyCity: function(index: integer; City: PCity): integer; stdcall;
   RemoveCity: function(index: integer; City: PCity): integer; stdcall;
   ReleaseCities: function(): integer; stdcall;
   SearchCity: function(str: pchar): integer; stdcall;
   libCities : THandle;

var c : Pcities;
    total,first: integer;
    actual_country: string;

constructor Tf_config_observatory.Create(AOwner:TComponent);
var i : integer;
begin
 csc:=@mycsc;
 ccat:=@myccat;
 cshr:=@mycshr;
 cplot:=@mycplot;
 cmain:=@mycmain;
 inherited Create(AOwner);
 LibCities := LoadLibrary(citylib);
 if (LibCities>0) then begin
   @SetDirectory     := GetProcAddress (LibCities, 'SetDirectory');
   @ReadCountryFile  := GetProcAddress (LibCities, 'ReadCountryFile');
   @AddCity          := GetProcAddress (LibCities, 'AddCity');
   @ModifyCity       := GetProcAddress (LibCities, 'ModifyCity');
   @RemoveCity       := GetProcAddress (LibCities, 'RemoveCity');
   @ReleaseCities    := GetProcAddress (LibCities, 'ReleaseCities');
   @SearchCity       := GetProcAddress (LibCities, 'SearchCity');
 end;
 for i:=0 to COUNTRIES-1 do
  countrylist.Items.Add(Country[i]);
 actual_country:='';
end;

Procedure Tf_config_observatory.ShowObsCoord;
var d,m,s : string;
begin
try
obslock:=true;
ArToStr2(abs(csc.ObsLatitude),d,m,s);
latdeg.Text:=d;
latmin.Text:=m;
latsec.Text:=s;
ArToStr2(abs(csc.ObsLongitude),d,m,s);
longdeg.Text:=d;
longmin.Text:=m;
longsec.Text:=s;
if csc.ObsLatitude>=0 then hemis.Itemindex:=0
                      else hemis.Itemindex:=1;
if csc.ObsLongitude>=0 then long.Itemindex:=0
                       else long.Itemindex:=1;
finally
obslock:=false;
end;
end;

Procedure Tf_config_observatory.SetObsPos;
begin
Obsposx:=round(ZoomImage1.SizeX*(180-csc.ObsLongitude)/360);
Obsposy:=round(ZoomImage1.SizeY*(90-csc.ObsLatitude)/180);
ZoomImage1.Xcentre:=Obsposx;
ZoomImage1.Ycentre:=Obsposy;
end;

procedure Tf_config_observatory.CenterObs;
begin
ZoomImage1.Xcentre:=Obsposx;
ZoomImage1.Ycentre:=Obsposy;
ZoomImage1.Draw;
SetScrollBar;
end;

procedure Tf_config_observatory.countrylistClick(Sender: TObject);
begin
try
csc.obscountry:=countrylist.text;
citysearch.click;
except
end;
end;

procedure Tf_config_observatory.citysearchClick(Sender: TObject);
begin
try
UpdCityList(true);
except
end;
end;

procedure Tf_config_observatory.citylistChange(Sender: TObject);
begin
csc.obsname:=citylist.text;
end;

procedure Tf_config_observatory.citylistClick(Sender: TObject);
var i:integer;
    x,xx:double;
begin
csc.obsname:=citylist.text;
if (c=nil)or(total<=0) then exit;
i := citylist.ItemIndex+first;
x:=abs(c^[i].m_Coord[0]/10000);
xx:=trunc(x);
csc.ObsLatitude:=xx;
x:=(x-xx)*100;
xx:=trunc(x);
csc.ObsLatitude:=csc.ObsLatitude+xx/60;
x:=(x-xx)*100;
csc.ObsLatitude:=csc.ObsLatitude+x/3600;
if c^[i].m_Coord[0]<0 then csc.ObsLatitude:=-csc.ObsLatitude;
x:=abs(c^[i].m_Coord[1]/10000);
xx:=trunc(x);
csc.ObsLongitude:=xx;
x:=(x-xx)*100;
xx:=trunc(x);
csc.ObsLongitude:=csc.ObsLongitude+xx/60;
x:=(x-xx)*100;
csc.ObsLongitude:=csc.ObsLongitude+x/3600;
if c^[i].m_Coord[1]>0 then csc.ObsLongitude:=-csc.ObsLongitude;
ShowObsCoord;
SetObsPos;
CenterObs;
end;

procedure Tf_config_observatory.newcityClick(Sender: TObject);
var nc : City;
begin
if (c=nil)or(total<=0) then begin
  showmessage('Error, country file not initialized: '+inttostr(total));
  exit;
end;
strpcopy(nc.m_Name,utf8encode(citylist.text));
nc.m_Coord[0]:=latsec.value+latmin.value*100+latdeg.value*10000;
if hemis.itemindex=1 then nc.m_Coord[0]:=-nc.m_Coord[0];
nc.m_Coord[1]:=longsec.value+longmin.value*100+longdeg.value*10000;
if long.itemindex=1 then nc.m_Coord[1]:=-nc.m_Coord[1];
if AddCity(@nc)>0 then begin;
   actual_country:='';
   cityfilter.text:=citylist.text;
   citysearch.click;
end else showmessage(citylist.text+' already exist!');
end;

procedure Tf_config_observatory.UpdCityList(changecity:boolean);
var s,cfile : pchar;
    cfilename: array[0..200]of char;
    i,n: integer;
    ci,filter:utf8string;
    savecity:string;
begin
cfile:=nil;
if (countrylist.text<>actual_country)or(total<=0) then begin
  try
  screen.cursor:=crHourGlass;
  s:=pchar(string(slash(appdir)+'data'+pathdelim+'CitiesOfTheWorld'));
  setdirectory(s);
  releasecities();
  total:=readcountryfile(pchar(string(countrylist.text)),c,cfilename);
  cfile:=cfilename;
  actual_country:=countrylist.text;
  finally
   screen.cursor:=crDefault;
  end;
end;
if total<=0 then begin
  if total<>-2 then showmessage('Error reading country file: '+inttostr(total));
  exit;
end;
filter:=utf8encode(cityfilter.text);
if filter<>'' then first:=SearchCity(pchar(filter))
              else first:=0;
if first<0 then first:=total-50;
n:=minintvalue([total-1,first+100]);
savecity:=citylist.text;
citylist.clear;
citylist.ItemIndex:=-1;
citylist.Items.BeginUpdate;
for i:=first to n do begin
  ci:=c^[i].m_Name;
  citylist.items.Add(utf8decode(ci));
end;
citylist.Items.EndUpdate;
if changecity then begin
  citylist.ItemIndex:=0;
  citylistClick(Self);
end
else citylist.text:=savecity;
if (cfile<>nil)then begin
  if (not FileIsReadOnly(cfile)) then begin
     dbreado.sendtoback;
     dbreado.visible:=false;
     updcity.enabled:=true;
     newcity.enabled:=true;
     delcity.enabled:=true
  end else begin
     dbreado.bringtofront;
     dbreado.visible:=true;
     updcity.enabled:=false;
     newcity.enabled:=false;
     delcity.enabled:=false
  end;
end;
end;

procedure Tf_config_observatory.updcityClick(Sender: TObject);
var nc : City;
    i : integer;
begin
if (c=nil)or(total<=0) then begin
  showmessage('Error, country file not initialized: '+inttostr(total));
  exit;
end;
i := citylist.ItemIndex+first;
strpcopy(nc.m_Name,utf8encode(citylist.text));
nc.m_Coord[0]:=latsec.value+latmin.value*100+latdeg.value*10000;
if hemis.itemindex=1 then nc.m_Coord[0]:=-nc.m_Coord[0];
nc.m_Coord[1]:=longsec.value+longmin.value*100+longdeg.value*10000;
if long.itemindex=1 then nc.m_Coord[1]:=-nc.m_Coord[1];
if ModifyCity(i,@nc)>0 then begin;
   actual_country:='';
   cityfilter.text:=citylist.text;
   citysearch.click;
end else showmessage('Failed to update '+citylist.text+'!');
end;

procedure Tf_config_observatory.delcityClick(Sender: TObject);
var nc : City;
    i : integer;
begin
if (c=nil)or(total<=0) then begin
  showmessage('Error, country file not initialized: '+inttostr(total));
  exit;
end;
i := citylist.ItemIndex+first;
nc:=c^[i];
if messagedlg('Are you sure you want to remove '+nc.m_Name+' ?',mtConfirmation,[mbYes,mbNo],0)=mrYes then begin
   if RemoveCity(i,@nc)>0 then begin;
      actual_country:='';
      citysearch.click;
   end else showmessage('Failed to delete!');
end;
end;

procedure Tf_config_observatory.latdegChange(Sender: TObject);
begin
if obslock then exit;
csc.ObsLatitude:=latdeg.value+latmin.value/60+latsec.value/3600;
if hemis.Itemindex>0 then csc.ObsLatitude:=-csc.ObsLatitude;
SetObsPos;
CenterObs;
end;

procedure Tf_config_observatory.longdegChange(Sender: TObject);
begin
if obslock then exit;
csc.ObsLongitude:=longdeg.value+longmin.value/60+longsec.value/3600;
if long.Itemindex>0 then csc.ObsLongitude:=-csc.ObsLongitude;
SetObsPos;
CenterObs;
end;

procedure Tf_config_observatory.altmeterChange(Sender: TObject);
begin
csc.obsaltitude:=altmeter.value;
end;

procedure Tf_config_observatory.pressureChange(Sender: TObject);
begin
csc.obsaltitude:=altmeter.value;
end;

procedure Tf_config_observatory.temperatureChange(Sender: TObject);
begin
csc.obstemperature:=temperature.value;
end;

procedure Tf_config_observatory.timezChange(Sender: TObject);
begin
with sender as Tfloatedit do begin
  csc.obstz:=value;
end;
// same value in Time and Observatory panel
//if tz<>nil then tz.value:=csc.obstz;
if timez<>nil then timez.value:=csc.obstz;
end;

procedure Tf_config_observatory.ZoomImage1MouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
if ZoomImage1.SizeX>0 then begin
  Obsposx:=ZoomImage1.scr2wrldx(x);
  Obsposy:=ZoomImage1.scr2wrldy(y);
  ZoomImage1.Refresh;
  csc.ObsLongitude:=180-360*Obsposx/ZoomImage1.SizeX;
  csc.ObsLatitude:=90-180*Obsposy/ZoomImage1.SizeY;
  ShowObsCoord;
end;
end;

procedure Tf_config_observatory.ZoomImage1Paint(Sender: TObject);
var x,y : integer;
begin
  with ZoomImage1.Canvas do begin
     pen.Color:=clred;
     brush.Style:=bsClear;
     x:=ZoomImage1.Wrld2ScrX(Obsposx);
     y:=ZoomImage1.Wrld2ScrY(Obsposy);
     ellipse(x-3,y-3,x+3,y+3);
  end;
end;

procedure Tf_config_observatory.ZoomImage1PosChange(Sender: TObject);
begin
ScrollLock:=true;
Hscrollbar.Position:=ZoomImage1.Xc;
Vscrollbar.Position:=ZoomImage1.Yc;
application.processmessages;
ScrollLock:=false;
end;

procedure Tf_config_observatory.HScrollBarChange(Sender: TObject);
begin
if scrolllock then exit;
ZoomImage1.Xcentre:=HScrollBar.Position;
ZoomImage1.Draw;
end;

procedure Tf_config_observatory.VScrollBarChange(Sender: TObject);
begin
if scrolllock then exit;
ZoomImage1.Ycentre:=VScrollBar.Position;
ZoomImage1.Draw;
end;

procedure Tf_config_observatory.ObszpClick(Sender: TObject);
begin
ZoomImage1.zoom:=1.5*ZoomImage1.zoom;
CenterObs;
end;

procedure Tf_config_observatory.ObszmClick(Sender: TObject);
begin
ZoomImage1.zoom:=ZoomImage1.zoom/1.5;
CenterObs;
end;

procedure Tf_config_observatory.ObsmapClick(Sender: TObject);
begin
if fileexists(cmain.EarthMapFile) then begin
   opendialog1.InitialDir:=extractfilepath(cmain.EarthMapFile);
   opendialog1.filename:=extractfilename(cmain.EarthMapFile);
end else begin
   opendialog1.InitialDir:=slash(appdir)+'data'+pathdelim+'earthmap';
   opendialog1.filename:='';
end;
opendialog1.Filter:='JPEG|*.jpg|PNG|*.png|BMP|*.bmp';
opendialog1.DefaultExt:='.jpg';
try
if opendialog1.execute
   and(fileexists(opendialog1.filename))
   then begin
   cmain.EarthMapFile:=opendialog1.filename;
   ZoomImage1.Xcentre:=Obsposx;
   ZoomImage1.Ycentre:=Obsposy;
   ZoomImage1.Picture.LoadFromFile(cmain.EarthMapFile);
   SetScrollBar;
   Hscrollbar.Position:=ZoomImage1.SizeX div 2;
   Vscrollbar.Position:=ZoomImage1.SizeY div 2;
   SetObsPos;
   CenterObs;
end;
finally
   chdir(appdir);
end;
end;

Procedure Tf_config_observatory.SetScrollBar;
begin
try
ScrollLock:=true;
scrollw:=round(ZoomImage1.Width/ZoomImage1.zoom/2);
Hscrollbar.SetParams(Hscrollbar.Position, scrollw, ZoomImage1.SizeX-scrollw);
Hscrollbar.LargeChange:=scrollw;
Hscrollbar.SmallChange:=scrollw div 10;
scrollh:=round(ZoomImage1.Height/ZoomImage1.zoom/2);
Vscrollbar.SetParams(Vscrollbar.Position, scrollh, ZoomImage1.SizeY-scrollh);
Vscrollbar.LargeChange:=scrollh;
Vscrollbar.SmallChange:=scrollh div 10;
finally
ScrollLock:=false;
end;
end;

procedure Tf_config_observatory.ShowHorizon;
begin
horizonopaque.checked:=not csc.horizonopaque;
horizonfile.text:=cmain.horizonfile;
displayhorizon.Checked:=csc.ShowHorizon;
horizondepression.Checked:=csc.ShowHorizonDepression;
end;

procedure Tf_config_observatory.displayhorizonClick(Sender: TObject);
begin
csc.ShowHorizon:=displayhorizon.Checked;
end;

procedure Tf_config_observatory.horizondepressionClick(Sender: TObject);
begin
csc.ShowHorizonDepression:=horizondepression.Checked;
end;

procedure Tf_config_observatory.horizonopaqueClick(Sender: TObject);
begin
csc.horizonopaque:=not horizonopaque.checked;
end;

procedure Tf_config_observatory.horizonfileChange(Sender: TObject);
begin
cmain.horizonfile:=horizonfile.text;
end;

procedure Tf_config_observatory.horizonfileBtnClick(Sender: TObject);
begin
if fileexists(cmain.horizonfile) then begin
   opendialog1.InitialDir:=extractfilepath(cmain.horizonfile);
   opendialog1.filename:=extractfilename(cmain.horizonfile);
end else begin
   opendialog1.InitialDir:=slash(appdir)+'data'+pathdelim+'horizon';
   opendialog1.filename:='horizon.txt';
end;
opendialog1.Filter:='All|*.*';
try
if opendialog1.execute
   and(fileexists(opendialog1.filename))
   then begin
   horizonfile.text:=opendialog1.filename;
   cmain.horizonfile:=opendialog1.filename;
end;
finally
   chdir(appdir);
end;
end;

procedure Tf_config_observatory.ShowObservatory;
var i:integer;
begin
try
altmeter.value:=csc.obsaltitude;
pressure.value:=csc.obspressure;
temperature.value:=csc.obstemperature;
timez.value:=csc.obstz;
ShowObsCoord;
//countrylist.text:=csc.obscountry;
countrylist.itemindex:=0;
for i:=0 to countrylist.items.count-1 do
  if uppercase(trim(countrylist.Items[i]))=uppercase(trim(csc.obscountry)) then begin
    countrylist.itemindex:=i;
    break;
  end;
citylist.text:=csc.obsname;
cityfilter.text:=copy(csc.obsname,1,3);
Obsposx:=0;
Obsposy:=0;
ZoomImage1.Xcentre:=Obsposx;
ZoomImage1.Ycentre:=Obsposy;
ZoomImage1.ZoomMax:=3;
if fileexists(cmain.EarthMapFile)and(cmain.EarthMapFile<>ObsMapfile) then begin
   ZoomImage1.Picture.LoadFromFile(cmain.EarthMapFile);
   ObsMapfile:=cmain.EarthMapFile;
end else  ZoomImage1.PictureChange(self);
SetScrollBar;
Hscrollbar.Position:=ZoomImage1.SizeX div 2;
Vscrollbar.Position:=ZoomImage1.SizeY div 2;
SetObsPos;
CenterObs;
except
end;
end;

procedure Tf_config_observatory.FormShow(Sender: TObject);
begin
ShowObservatory;
ShowHorizon;
end;
