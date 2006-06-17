unit pu_config_observatory;

{$MODE Delphi}{$H+}

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

interface

uses  u_constant, u_util, cu_database, Math, dynlibs, lazjpeg, unzip,
  LCLIntf, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Buttons, StdCtrls, ExtCtrls, cu_zoomimage, enhedits, ComCtrls, LResources,
  Spin, downloaddialog, EditBtn;

type

  { Tf_config_observatory }

  Tf_config_observatory = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    DownloadDialog1: TDownloadDialog;
    horizonfile: TFileNameEdit;
    Memo1: TMemo;
    OpenDialog1: TOpenDialog;
    Panel1: TPanel;
    vicinity: TButton;
    LocCode: TEdit;
    Label2: TLabel;
    Label3: TLabel;
    MainPanel: TPanel;
    Page1: TPage;
    Page2: TPage;
    Latitude: TGroupBox;
    Label58: TLabel;
    Label59: TLabel;
    Label60: TLabel;
    hemis: TComboBox;
    latdeg: TLongEdit;
    latmin: TLongEdit;
    latsec: TLongEdit;
    Longitude: TGroupBox;
    Label61: TLabel;
    Label62: TLabel;
    Label63: TLabel;
    long: TComboBox;
    longdeg: TLongEdit;
    longmin: TLongEdit;
    longsec: TLongEdit;
    Altitude: TGroupBox;
    Label70: TLabel;
    altmeter: TFloatEdit;
    refraction: TGroupBox;
    Label82: TLabel;
    Label83: TLabel;
    pressure: TFloatEdit;
    vicinityrange: TSpinEdit;
    temperature: TFloatEdit;
    timezone: TGroupBox;
    Label81: TLabel;
    timez: TFloatEdit;
    Obszp: TButton;
    Obszm: TButton;
    Obsmap: TButton;
    Notebook1: TNotebook;
    ZoomImage1: TZoomImage;
    HScrollBar: TScrollBar;
    VScrollBar: TScrollBar;
    obsname: TGroupBox;
    citylist: TComboBox;
    citysearch: TButton;
    countrylist: TComboBox;
    cityfilter: TEdit;
    downloadcity: TButton;
    updcity: TButton;
    delcity: TButton;
    GroupBox2: TGroupBox;
    horizonopaque: TCheckBox;
    GroupBox1: TGroupBox;
    hor_l1: TLabel;
    displayhorizon: TCheckBox;
    GroupBox3: TGroupBox;
    horizondepression: TCheckBox;
    Label1: TLabel;
    procedure Button2Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure cityfilterKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure countrylistChange(Sender: TObject);
    procedure citysearchClick(Sender: TObject);
    procedure citylistChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure delcityClick(Sender: TObject);
    procedure latdegChange(Sender: TObject);
    procedure LocCodeClick(Sender: TObject);
    procedure longdegChange(Sender: TObject);
    procedure altmeterChange(Sender: TObject);
    procedure downloadcityClick(Sender: TObject);
    procedure pressureChange(Sender: TObject);
    procedure temperatureChange(Sender: TObject);
    procedure timezChange(Sender: TObject);
    procedure ZoomImage1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ZoomImage1Paint(Sender: TObject);
    procedure ZoomImage1PosChange(Sender: TObject);
    procedure HScrollBarChange(Sender: TObject);
    procedure VScrollBarChange(Sender: TObject);
    procedure ObszpClick(Sender: TObject);
    procedure ObszmClick(Sender: TObject);
    procedure ObsmapClick(Sender: TObject);
    procedure horizonopaqueClick(Sender: TObject);
    procedure horizonfileChange(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure displayhorizonClick(Sender: TObject);
    procedure horizondepressionClick(Sender: TObject);
    procedure updcityClick(Sender: TObject);
    procedure vicinityClick(Sender: TObject);
  private
    { Private declarations }
    FApplyConfig: TNotifyEvent;
    scrolllock,obslock,LockChange:boolean;
    Obsposx,Obsposy : integer;
    scrollw, scrollh : integer;
    ObsMapFile:string;
    countrycode: TStringList;
    citycode: TStringList;
    CurObsId:integer;
    Procedure SetScrollBar;
    Procedure SetObsPos;
    Procedure ShowObsCoord;
    procedure CenterObs;
    procedure ShowHorizon;
    procedure ShowObservatory;
  public
    { Public declarations }
    cdb: Tcdcdb;
    mycsc : conf_skychart;
    myccat : conf_catalog;
    mycshr : conf_shared;
    mycplot : conf_plot;
    mycmain : conf_main;
    csc : ^conf_skychart;
    ccat : ^conf_catalog;
    cshr : ^conf_shared;
    cplot : ^conf_plot;
    cmain : ^conf_main;
    constructor Create(AOwner:TComponent); override;
    property onApplyConfig: TNotifyEvent read FApplyConfig write FApplyConfig;
  end;

implementation

constructor Tf_config_observatory.Create(AOwner:TComponent);
begin
 csc:=@mycsc;
 ccat:=@myccat;
 cshr:=@mycshr;
 cplot:=@mycplot;
 cmain:=@mycmain;
 inherited Create(AOwner);
end;

procedure Tf_config_observatory.FormCreate(Sender: TObject);
begin
  countrycode:=TStringList.Create;
  citycode:=TStringList.Create;
  LockChange:=true;
end;

procedure Tf_config_observatory.FormShow(Sender: TObject);
begin
LockChange:=true;
VScrollBar.Height:=ZoomImage1.Height;
VScrollBar.Top:=ZoomImage1.Top;
VScrollBar.Left:=ZoomImage1.Left+ZoomImage1.Width;
HScrollBar.Width:=ZoomImage1.Width;
HScrollBar.Left:=ZoomImage1.Left;
HScrollBar.Top:=ZoomImage1.Top+ZoomImage1.Height;
if countrylist.Items.Count=0 then cdb.GetCountryList(countrycode,countrylist.Items);
ShowHorizon;
ShowObservatory;
cityfilter.text:=copy(csc.obsname,1,3);
LockChange:=false;
end;

Procedure Tf_config_observatory.ShowObsCoord;
var d,m,s : string;
begin
try
obslock:=true;
altmeter.value:=csc.obsaltitude;
timez.value:=csc.obstz;
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

procedure Tf_config_observatory.ShowObservatory;
var i:integer;
begin
try
pressure.value:=csc.obspressure;
temperature.value:=csc.obstemperature;
ShowObsCoord;
countrylist.itemindex:=0;
for i:=0 to countrylist.items.count-1 do
  if uppercase(trim(countrylist.Items[i]))=uppercase(trim(csc.obscountry)) then begin
    countrylist.itemindex:=i;
    break;
  end;
citylist.text:=csc.obsname;
Obsposx:=0;
Obsposy:=0;
ZoomImage1.Xcentre:=Obsposx;
ZoomImage1.Ycentre:=Obsposy;
ZoomImage1.ZoomMax:=3;
if fileexists(cmain.EarthMapFile)and(cmain.EarthMapFile<>ObsMapfile) then begin
   ObsMapfile:=cmain.EarthMapFile;
   ZoomImage1.Picture.LoadFromFile(ObsMapfile);
end else ZoomImage1.PictureChange(self);
SetScrollBar;
Hscrollbar.Position:=ZoomImage1.SizeX div 2;
Vscrollbar.Position:=ZoomImage1.SizeY div 2;
SetObsPos;
CenterObs;
except
end;
end;

procedure Tf_config_observatory.countrylistChange(Sender: TObject);
begin
if lockChange then exit;
if countrylist.ItemIndex<0 then exit;
try
csc.obscountry:=countrylist.text;
cityfilter.Text:='';
citysearchClick(Sender);
except
end;
end;

procedure Tf_config_observatory.cityfilterKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
 if key=key_cr then citysearchClick(Sender);
end;

procedure Tf_config_observatory.Button2Click(Sender: TObject);
begin
 if assigned(FApplyConfig) then FApplyConfig(Self);
end;

procedure Tf_config_observatory.FormClose(Sender: TObject;
  var CloseAction: TCloseAction);
begin
  LockChange:=true;
end;

procedure Tf_config_observatory.citysearchClick(Sender: TObject);
var code,filter: string;
begin
screen.Cursor:=crHourGlass;
try
if countrylist.ItemIndex<0 then exit;
lockChange:=true;
code:=countrycode[countrylist.ItemIndex];
filter:=cityfilter.Text;
if filter<>'' then filter:=filter+'%';
cdb.GetCityList(code,filter,citycode,citylist.Items,MaxCityList);
if citylist.Items.Count>0 then citylist.Text:=citylist.Items[0];
lockChange:=false;
citylistChange(self);
finally
screen.Cursor:=crDefault;
end;
end;

procedure Tf_config_observatory.citylistChange(Sender: TObject);
var id,loctype,latitude,longitude,elevation,timezone:string;
begin
if LockChange then exit;
csc.obsname:=citylist.text;
if citylist.ItemIndex<0 then begin curobsid:=0; exit; end;
id:=citycode[citylist.ItemIndex];
if cdb.GetCityLoc(id,loctype,latitude,longitude,elevation,timezone) then begin
   curobsid:=strtoint(citycode[citylist.ItemIndex]);
   LocCode.text:=loctype;
   csc.ObsLatitude:=strtofloat(latitude);
   csc.ObsLongitude:=-strtofloat(longitude);
   csc.ObsAltitude:=strtofloat(elevation);
   csc.ObsTZ:=strtofloat(timezone);
   ShowObsCoord;
   SetObsPos;
   CenterObs;
end
else curobsid:=0;
end;

procedure Tf_config_observatory.updcityClick(Sender: TObject);
var country,location,lat,lon,elev,tz,buf: string;
begin
if countrylist.ItemIndex<0 then exit;
if MessageDlg('Update or add the current location to the database ?',mtWarning,[mbYes,mbNo],0) = mrYes
  then begin
    lat:=floattostr(csc.ObsLatitude);
    lon:=floattostr(-csc.ObsLongitude);
    elev:=floattostr(csc.ObsAltitude);
    tz:=floattostr(csc.ObsTZ);
    country:=countrycode[countrylist.ItemIndex];
    location:=citylist.Text;
    buf:=cdb.UpdateCity(curobsid,country,location,'user',lat,lon,elev,tz);
    if buf='' then buf:='Updated successfully!';
    vicinityClick(Sender);
    showmessage(buf);
  end;
end;

procedure Tf_config_observatory.delcityClick(Sender: TObject);
var buf: string;
begin
if curobsid=0 then exit;
if MessageDlg('Delete the current location from the database ?',mtWarning,[mbYes,mbNo],0) = mrYes
  then begin
      buf:=cdb.DeleteCity(curobsid);
      if buf='' then buf:='Deleted successfully!';
      vicinityClick(Sender);
      if citylist.items.count=0 then citysearchClick(Sender);
      showmessage(buf);
  end;
end;


procedure Tf_config_observatory.vicinityClick(Sender: TObject);
var lon,lat,dd:double;
    country,oldcity:string;
    i: integer;
begin
if countrylist.ItemIndex<0 then exit;
oldcity:=trim(citylist.Text);
lockChange:=true;
citylist.Clear;
citycode.Clear;
country:=countrycode[countrylist.ItemIndex];
dd:=vicinityrange.Value/kmperdegree;
lat:=csc.ObsLatitude;
lon:=-csc.ObsLongitude;
cdb.GetCityRange(country,lat-dd,lat+dd,lon-dd,lon+dd, citycode,citylist.Items,MaxCityList);
citylist.itemindex:=0;
for i:=0 to citylist.items.count-1 do
  if trim(citylist.Items[i])=oldcity then begin
    citylist.itemindex:=i;
    break;
  end;
lockChange:=false;
citylistChange(self);
end;

procedure Tf_config_observatory.downloadcityClick(Sender: TObject);
var country,fn,fnzip,buf:string;
begin
if countrylist.ItemIndex<0 then exit;
if MessageDlg('This action replace all the database content for the country '+countrylist.Text+' using fresh data from NGA and GNIS.'+crlf+
              'All your editing for this country will be lost except the location you added with a new name that will be kept.'+crlf+
              'Do you want to continue ?',mtWarning,[mbYes,mbNo],0) = mrYes
  then begin
    country:=countrycode[countrylist.ItemIndex];
    if copy(country,1,3)='US-' then begin // US States
       fn:=uppercase(copy(country,4,2))+'_DECI.TXT';
       DownloadDialog1.URL:=baseurl_us+fn;
       fn:=slash(TempDir)+fn;
       DownloadDialog1.SaveToFile:=fn;
       if DownloadDialog1.Execute then begin
          memo1.Visible:=true;
          memo1.BringToFront;
          application.ProcessMessages;
          buf:=cdb.DeleteCountry(country,false);
          memo1.Lines.Add(buf);
          application.ProcessMessages;
          cdb.LoadUSLocation(fn,false,memo1);
          application.ProcessMessages;
          sleep(2000);
          memo1.Visible:=false;
       end else
          Showmessage('Cancel '+DownloadDialog1.ResponseText);
    end else begin  // World
       fnzip:=lowercase(country)+'.zip';
       fn:=ChangeFileExt(fnzip,'.txt');
       DownloadDialog1.URL:=baseurl_world+fnzip;
       fnzip:=slash(TempDir)+fnzip;
       DownloadDialog1.SaveToFile:=fnzip;
       if DownloadDialog1.Execute then begin
          if 1=FileUnzipEx(pchar(fnzip), pchar(TempDir), pchar(fn)) then begin
             memo1.Visible:=true;
             memo1.BringToFront;
             application.ProcessMessages;
             fn:=slash(TempDir)+fn;
             buf:=cdb.DeleteCountry(country,false);
             memo1.Lines.Add(buf);
             application.ProcessMessages;
             cdb.LoadWorldLocation(fn,country,false,memo1);
             application.ProcessMessages;
             sleep(2000);
             memo1.Visible:=false;
          end
          else Showmessage('Cancel, wrong zip file ?? '+fnzip);
       end else
          Showmessage('Cancel '+DownloadDialog1.ResponseText);
    end;
end;
end;

procedure Tf_config_observatory.latdegChange(Sender: TObject);
begin
if LockChange then exit;
if obslock then exit;
csc.ObsLatitude:=latdeg.value+latmin.value/60+latsec.value/3600;
if hemis.Itemindex>0 then csc.ObsLatitude:=-csc.ObsLatitude;
SetObsPos;
CenterObs;
end;

procedure Tf_config_observatory.LocCodeClick(Sender: TObject);
var us: boolean;
    country: string;
begin
us:=false;
if countrylist.ItemIndex>=0 then begin
   country:=countrycode[countrylist.ItemIndex];
   if copy(country,1,3)='US-' then us:=true;
end;
if us then ExecuteFile(slash(helpdir)+'Location_US_Designations.html')
      else ExecuteFile(slash(helpdir)+'Location_World_Designations.html');
end;

procedure Tf_config_observatory.longdegChange(Sender: TObject);
begin
if LockChange then exit;
if obslock then exit;
csc.ObsLongitude:=longdeg.value+longmin.value/60+longsec.value/3600;
if long.Itemindex>0 then csc.ObsLongitude:=-csc.ObsLongitude;
SetObsPos;
CenterObs;
end;

procedure Tf_config_observatory.altmeterChange(Sender: TObject);
begin
if LockChange then exit;
csc.obsaltitude:=altmeter.value;
end;

procedure Tf_config_observatory.pressureChange(Sender: TObject);
begin
if LockChange then exit;
csc.obsaltitude:=altmeter.value;
end;

procedure Tf_config_observatory.temperatureChange(Sender: TObject);
begin
if LockChange then exit;
csc.obstemperature:=temperature.value;
end;

procedure Tf_config_observatory.timezChange(Sender: TObject);
begin
if LockChange then exit;
with sender as Tfloatedit do begin
  csc.obstz:=value;
end;
// same value in Time and Observatory panel
csc.timezone:=csc.obstz;
if csc.DST then csc.timezone:=csc.timezone+1 ;
end;

procedure Tf_config_observatory.ZoomImage1MouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
if ZoomImage1.SizeX>0 then begin
  Obsposx:=ZoomImage1.scr2wrldx(x);
  Obsposy:=ZoomImage1.scr2wrldy(y);
  ZoomImage1.Invalidate;
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
if LockChange then exit;
ScrollLock:=true;
Hscrollbar.Position:=ZoomImage1.Xc;
Vscrollbar.Position:=ZoomImage1.Yc;
application.processmessages;
ScrollLock:=false;
end;

procedure Tf_config_observatory.HScrollBarChange(Sender: TObject);
begin
if LockChange then exit;
if scrolllock then exit;
ZoomImage1.Xcentre:=HScrollBar.Position;
ZoomImage1.Draw;
end;

procedure Tf_config_observatory.VScrollBarChange(Sender: TObject);
begin
if LockChange then exit;
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
var posmax: integer;
begin
try
ScrollLock:=true;
scrollw:=round(ZoomImage1.Width/ZoomImage1.zoom/2);
posmax:=max(scrollw,ZoomImage1.SizeX-scrollw);
Hscrollbar.SetParams(Hscrollbar.Position, scrollw, posmax);
Hscrollbar.LargeChange:=scrollw;
Hscrollbar.SmallChange:=scrollw div 10;
scrollh:=round(ZoomImage1.Height/ZoomImage1.zoom/2);
posmax:=max(scrollh,ZoomImage1.SizeY-scrollh);
Vscrollbar.SetParams(Vscrollbar.Position, scrollh, posmax);
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
horizonfile.InitialDir:=slash(appdir)+'data'+pathdelim+'horizon';
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
if LockChange then exit;
cmain.horizonfile:=horizonfile.text;
end;

initialization
  {$i pu_config_observatory.lrs}

end.
