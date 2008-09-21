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

uses u_help, u_translation, u_constant, u_util, cu_database, Math, dynlibs, unzip,
  LCLIntf, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Buttons, StdCtrls, ExtCtrls, cu_zoomimage, enhedits, ComCtrls, LResources,
  Spin, downloaddialog, EditBtn, LazHelpHTML;

type

  { Tf_config_observatory }

  Tf_config_observatory = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    CountryTZ: TCheckBox;
    HTMLBrowserHelpViewer1: THTMLBrowserHelpViewer;
    HTMLHelpDatabase1: THTMLHelpDatabase;
    TZComboBox: TComboBox;
    fillhorizon: TCheckBox;
    DownloadDialog1: TDownloadDialog;
    horizonfile: TFileNameEdit;
    Label82: TLabel;
    Label83: TLabel;
    Memo1: TMemo;
    OpenDialog1: TOpenDialog;
    Panel1: TPanel;
    pressure: TFloatEdit;
    refraction: TGroupBox;
    temperature: TFloatEdit;
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
    vicinityrange: TSpinEdit;
    timezone: TGroupBox;
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
    procedure FormDestroy(Sender: TObject);
    procedure CountryTZChange(Sender: TObject);
    procedure TZComboBoxChange(Sender: TObject);
    procedure fillhorizonClick(Sender: TObject);
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
    procedure UpdTZList(Sender: TObject);
  public
    { Public declarations }
    cdb: Tcdcdb;
    mycsc : Tconf_skychart;
    myccat : Tconf_catalog;
    mycshr : Tconf_shared;
    mycplot : Tconf_plot;
    mycmain : Tconf_main;
    csc : Tconf_skychart;
    ccat : Tconf_catalog;
    cshr : Tconf_shared;
    cplot : Tconf_plot;
    cmain : Tconf_main;
    procedure SetLang;
    constructor Create(AOwner:TComponent); override;
    property onApplyConfig: TNotifyEvent read FApplyConfig write FApplyConfig;
  end;

implementation

procedure Tf_config_observatory.SetLang;
begin
Caption:=rsObservatory;
Page1.caption:=rsObservatory;
Latitude.Caption:=rsLatitude;
Longitude.Caption:=rsLongitude;
Altitude.Caption:=rsAltitude;
Label58.caption:=rsDegree;
Label59.caption:=rsMin3;
Label60.caption:=rsSec2;
hemis.items[0]:=rsNorth;
hemis.items[1]:=rsSouth;
Label61.caption:=rsDegree;
Label62.caption:=rsMin3;
Label63.caption:=rsSec2;
long.items[0]:=rsWest;
long.items[1]:=rsEast;
Label70.caption:=rsMeters;
timezone.caption:=rsTimeZone;
CountryTZ.Caption:=rsCountryTimez;
Obsmap.caption:=rsLoad;
obsname.caption:=rsObservatoryD;
Label3.caption:=rsKm;
citysearch.caption:=rsSearch;
downloadcity.caption:=rsDownloadCoun;
updcity.caption:=rsUpdate1;
delcity.caption:=rsDelete;
vicinity.caption:=rsVicinity;
refraction.caption:=rsAtmosphericR;
Label82.caption:=rsPressureMill;
Label83.caption:=rsTemperatureC;
Page2.caption:=rsHorizon;
GroupBox2.caption:=rsWantToTrackA;
horizonopaque.caption:=rsShowObjectBe;
GroupBox1.caption:=rsLocalHorizon;
hor_l1.caption:=rsLocalHorizon2;
displayhorizon.caption:=rsDisplayTheLo;
fillhorizon.caption:=rsFillWithHori;
GroupBox3.caption:=rsDepressionOf;
Label1.caption:=rsYouLiveOnABi;
horizondepression.caption:=rsDrawTheAppar;
Button1.caption:=rsOK;
Button2.caption:=rsApply;
Button3.caption:=rsCancel;
SetHelpDB(HTMLHelpDatabase1);
SetHelp(self,hlpCfgObs);
end;

constructor Tf_config_observatory.Create(AOwner:TComponent);
begin
 mycsc:=Tconf_skychart.Create;
 myccat:=Tconf_catalog.Create;
 mycshr:=Tconf_shared.Create;
 mycplot:=Tconf_plot.Create;
 mycmain:=Tconf_main.Create;
 csc:=mycsc;
 ccat:=myccat;
 cshr:=mycshr;
 cplot:=mycplot;
 cmain:=mycmain;
 inherited Create(AOwner);
end;

procedure Tf_config_observatory.FormDestroy(Sender: TObject);
begin
mycsc.Free;
end;

procedure Tf_config_observatory.FormCreate(Sender: TObject);
begin
SetLang;
  countrycode:=TStringList.Create;
  citycode:=TStringList.Create;
  LockChange:=true;
end;

procedure Tf_config_observatory.FormShow(Sender: TObject);
begin
LockChange:=true;
if countrylist.Items.Count=0 then cdb.GetCountryList(countrycode,countrylist.Items);
ShowHorizon;
ShowObservatory;
cityfilter.text:=copy(csc.obsname,1,3);
LockChange:=false;
VScrollBar.Top:=ZoomImage1.Top;
VScrollBar.Left:=ZoomImage1.Left+ZoomImage1.Width;
VScrollBar.Height:=ZoomImage1.Height;
HScrollBar.Left:=ZoomImage1.Left;
HScrollBar.Top:=ZoomImage1.Top+ZoomImage1.Height;
HScrollBar.Width:=ZoomImage1.Width;
end;

Procedure Tf_config_observatory.ShowObsCoord;
var d,m,s : string;
begin
try
obslock:=true;
altmeter.value:=csc.obsaltitude;
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
    img:TJPEGImage;
    pict:TPicture;
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
CountryTZ.checked:=csc.countrytz;
UpdTZList(self);
citylist.text:=csc.obsname;
Obsposx:=0;
Obsposy:=0;
ZoomImage1.Xcentre:=Obsposx;
ZoomImage1.Ycentre:=Obsposy;
ZoomImage1.ZoomMax:=3;
if fileexists(cmain.EarthMapFile)and(cmain.EarthMapFile<>ObsMapfile) then begin
   ObsMapfile:=cmain.EarthMapFile;
   img:=TJPEGImage.Create;
   pict:=TPicture.Create;
   img.LoadFromFile(ObsMapfile);
//   ZoomImage1.Picture.LoadFromFile(ObsMapfile);
   pict.Assign(img);
   ZoomImage1.Picture:=pict;
   img.Free;
   pict.free;
end else ZoomImage1.PictureChange(self);
ZoomImage1.Zoom:=ZoomImage1.ZoomMin;
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
UpdTZList(Sender);
except
end;
end;

procedure Tf_config_observatory.UpdTZList(Sender: TObject);
var code, isocode,buf: string;
    i,j: integer;
begin
if countrylist.ItemIndex<0 then exit;
if CountryTZ.Checked then begin
   code:=countrycode[countrylist.ItemIndex];
   cdb.GetCountryISOCode(code,isocode);
end else begin
   isocode:='ZZ';
end;
TZComboBox.Clear;
j:=0;
for i:=0 to csc.tz.ZoneTabCnty.Count-1 do begin
  if csc.tz.ZoneTabCnty[i]=isocode then begin
     buf:=csc.tz.ZoneTabZone[i];
     if csc.tz.ZoneTabComment[i]>'' then buf:=buf+' ('+csc.tz.ZoneTabComment[i]+')';
     TZComboBox.Items.Add(buf);
     if (j=0)or(csc.tz.ZoneTabZone[i]=csc.ObsTZ) then TZComboBox.ItemIndex:=j;
     inc(j);
  end;
end;
TZComboBoxChange(Sender);
end;

procedure Tf_config_observatory.TZComboBoxChange(Sender: TObject);
var buf: string;
    i: integer;
begin
  buf:=trim(TZComboBox.Text);
  if buf='' then exit;
  i:=pos(' ',buf);
  if i>0 then Delete(buf,i,9999);
  csc.ObsTZ:=buf;
  csc.tz.TimeZoneFile:=ZoneDir+StringReplace(buf,'/',PathDelim,[rfReplaceAll]);
  csc.timezone:=csc.tz.SecondsOffset/3600;
end;

procedure Tf_config_observatory.CountryTZChange(Sender: TObject);
begin
 if LockChange then exit;
 csc.countrytz:=CountryTZ.checked;
 UpdTZList(Sender);
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
    p:integer;
begin
if LockChange then exit;
csc.obsname:=citylist.text;
p:=pos(' -- ',csc.obsname);
if p>0 then delete(csc.obsname,p,99);
if citylist.ItemIndex<0 then begin curobsid:=0; exit; end;
id:=citycode[citylist.ItemIndex];
if cdb.GetCityLoc(id,loctype,latitude,longitude,elevation,timezone) then begin
   curobsid:=strtoint(citycode[citylist.ItemIndex]);
   LocCode.text:=loctype;
   csc.ObsLatitude:=strtofloat(latitude);
   csc.ObsLongitude:=-strtofloat(longitude);
   csc.ObsAltitude:=strtofloat(elevation);
   ShowObsCoord;
   SetObsPos;
   CenterObs;
end
else curobsid:=0;
end;

procedure Tf_config_observatory.updcityClick(Sender: TObject);
var country,location,lat,lon,elev,ltz,buf: string;
    p: integer;
begin
if countrylist.ItemIndex<0 then exit;
if MessageDlg(rsUpdateOrAddT, mtWarning, [mbYes, mbNo], 0) = mrYes
  then begin
    lat:=floattostr(csc.ObsLatitude);
    lon:=floattostr(-csc.ObsLongitude);
    elev:=floattostr(csc.ObsAltitude);
    ltz:='0';
    country:=countrycode[countrylist.ItemIndex];
    location:=citylist.Text;
    p:=pos(' -- ',location);
    if p>0 then delete(location,p,99);
    buf:=cdb.UpdateCity(curobsid,country,location,'user',lat,lon,elev,ltz);
    if buf='' then buf:=rsUpdatedSucce;
    vicinityClick(Sender);
    showmessage(buf);
  end;
end;

procedure Tf_config_observatory.delcityClick(Sender: TObject);
var buf: string;
begin
if curobsid=0 then exit;
if MessageDlg(rsDeleteTheCur, mtWarning, [mbYes, mbNo], 0) = mrYes
  then begin
      buf:=cdb.DeleteCity(curobsid);
      if buf='' then buf:=rsDeletedSucce;
      vicinityClick(Sender);
      if citylist.items.count=0 then citysearchClick(Sender);
      showmessage(buf);
  end;
end;


procedure Tf_config_observatory.vicinityClick(Sender: TObject);
var lon,lat,dd:double;
    country,oldcity:string;
    i,p: integer;
begin
if countrylist.ItemIndex<0 then exit;
oldcity:=trim(citylist.Text);
p:=pos(' -- ',oldcity);
if p>0 then delete(oldcity,p,99);
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
var country,state,fn,fnzip,buf:string;
begin
if countrylist.ItemIndex<0 then exit;
if MessageDlg(Format(rsThisActionRe, [countrylist.Text, crlf, crlf]),
  mtWarning, [mbYes, mbNo], 0) = mrYes
  then begin
    country:=countrycode[countrylist.ItemIndex];
    if copy(country,1,3)='US-' then begin // US States
       state:=uppercase(copy(country,4,2));
       fnzip:=state+'_DECI.zip';
       fn:=ChangeFileExt(fnzip,'.txt');
       DownloadDialog1.URL:=baseurl_us+fnzip;
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
            cdb.LoadUSLocation(fn,false,memo1,state);
            application.ProcessMessages;
            sleep(2000);
            memo1.Visible:=false;
          end
          else Showmessage(Format(rsCancelWrongZ, [fnzip]));
       end else
          Showmessage(Format(rsCancel2, [DownloadDialog1.ResponseText]));
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
          else Showmessage(Format(rsCancelWrongZ, [fnzip]));
       end else
          Showmessage(Format(rsCancel2, [DownloadDialog1.ResponseText]));
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
    country,desigfile: string;
begin
us:=false;
if countrylist.ItemIndex>=0 then begin
   country:=countrycode[countrylist.ItemIndex];
   if copy(country,1,3)='US-' then us:=true;
end;
if us then country:='Location_US_Designations.html'
      else country:='Location_World_Designations.html';
desigfile:=slash(helpdir)+slash('html_doc')+slash(lang)+country;
if not FileExists(desigfile) then
   desigfile:=slash(helpdir)+slash('html_doc')+slash('en')+country;
ExecuteFile(desigfile);
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
csc.ObsPressure:=pressure.value;
end;

procedure Tf_config_observatory.temperatureChange(Sender: TObject);
begin
if LockChange then exit;
csc.obstemperature:=temperature.value;
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
Hscrollbar.SetParams(Hscrollbar.Position, scrollw, posmax,1);
Hscrollbar.LargeChange:=scrollw;
Hscrollbar.SmallChange:=scrollw div 10;
scrollh:=round(ZoomImage1.Height/ZoomImage1.zoom/2);
posmax:=max(scrollh,ZoomImage1.SizeY-scrollh);
Vscrollbar.SetParams(Vscrollbar.Position, scrollh, posmax,1);
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
fillhorizon.Checked:=csc.FillHorizon;
horizondepression.Checked:=csc.ShowHorizonDepression;
end;

procedure Tf_config_observatory.displayhorizonClick(Sender: TObject);
begin
csc.ShowHorizon:=displayhorizon.Checked;
end;

procedure Tf_config_observatory.fillhorizonClick(Sender: TObject);
begin
csc.FillHorizon:=fillhorizon.Checked;
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
