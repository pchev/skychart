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

uses
  u_unzip, pu_observatory_db,
  u_help, u_translation, u_constant, u_util, cu_database, Math, dynlibs,
  LCLIntf, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, FileUtil,
  Buttons, StdCtrls, ExtCtrls, cu_zoomimage, enhedits, ComCtrls, LResources,
  Spin, downloaddialog, EditBtn, LazHelpHTML;

type

  { Tf_config_observatory }

  Tf_config_observatory = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    Button6: TButton;
    Button7: TButton;
    Button8: TButton;
    ComboBox1: TComboBox;
    countrylist: TComboBox;
    CountryTZ: TCheckBox;
    DownloadDialog1: TDownloadDialog;
    Label2: TLabel;
    Label3: TLabel;
    ObsName: TEdit;
    TZComboBox: TComboBox;
    fillhorizon: TCheckBox;
    horizonfile: TFileNameEdit;
    Label82: TLabel;
    Label83: TLabel;
    OpenDialog1: TOpenDialog;
    Panel1: TPanel;
    pressure: TFloatEdit;
    refraction: TGroupBox;
    temperature: TFloatEdit;
    MainPanel: TPanel;
    Page1: TTabSheet;
    Page2: TTabSheet;
    Latitude: TGroupBox;
    Label58: TLabel;
    hemis: TComboBox;
    latdeg: TLongEdit;
    latmin: TLongEdit;
    latsec: TLongEdit;
    Longitude: TGroupBox;
    Label61: TLabel;
    long: TComboBox;
    longdeg: TLongEdit;
    longmin: TLongEdit;
    longsec: TLongEdit;
    Altitude: TGroupBox;
    Label70: TLabel;
    altmeter: TFloatEdit;
    timezone: TGroupBox;
    Obszp: TButton;
    Obszm: TButton;
    Obsmap: TButton;
    PageControl1: TPageControl;
    ZoomImage1: TZoomImage;
    HScrollBar: TScrollBar;
    VScrollBar: TScrollBar;
    GroupBox2: TGroupBox;
    horizonopaque: TCheckBox;
    GroupBox1: TGroupBox;
    hor_l1: TLabel;
    displayhorizon: TCheckBox;
    GroupBox3: TGroupBox;
    horizondepression: TCheckBox;
    Label1: TLabel;
    procedure Button2Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure Button8Click(Sender: TObject);
    procedure ComboBox1Select(Sender: TObject);
    procedure countrylistSelect(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure CountryTZChange(Sender: TObject);
    procedure horizonfileAcceptFileName(Sender: TObject; var Value: String);
    procedure ObsNameChange(Sender: TObject);
    procedure TZComboBoxChange(Sender: TObject);
    procedure fillhorizonClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure latdegChange(Sender: TObject);
    procedure longdegChange(Sender: TObject);
    procedure altmeterChange(Sender: TObject);
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
  private
    { Private declarations }
    FApplyConfig: TNotifyEvent;
    scrolllock,obslock,LockChange:boolean;
    Obsposx,Obsposy : integer;
    scrollw, scrollh : integer;
    ObsMapFile:string;
    countrycode: TStringList;
    Procedure SetScrollBar;
    Procedure SetObsPos;
    Procedure ShowObsCoord;
    procedure CenterObs;
    procedure ShowHorizon;
    procedure ShowObservatory;
    procedure ShowCountryList;
    procedure UpdTZList(Sender: TObject);
    procedure UpdTZList1(Sender: TObject);
    procedure UpdFavList;
    procedure CountryChange(Sender: TObject);
    procedure ObsChange(Sender: TObject);
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
{$R *.lfm}

procedure Tf_config_observatory.SetLang;
begin
Caption:=rsObservatory;
Page1.caption:=rsObservatory;
Latitude.Caption:=rsLatitude;
Longitude.Caption:=rsLongitude;
Altitude.Caption:=rsAltitude;
Label58.caption:=rsDegreesMinut;
hemis.items[0]:=rsNorth;
hemis.items[1]:=rsSouth;
Label61.caption:=rsDegreesMinut;
long.items[0]:=rsWest;
long.items[1]:=rsEast;
Label70.caption:=rsMeters;
timezone.caption:=rsTimeZone;
CountryTZ.Caption:=rsCountryTimez;
Obsmap.caption:=rsMap;
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
Button4.caption:=rsHelp;
SetHelp(self,hlpCfgObs);
DownloadDialog1.msgDownloadFile:=rsDownloadFile;
DownloadDialog1.msgCopyfrom:=rsCopyFrom;
DownloadDialog1.msgtofile:=rsToFile;
DownloadDialog1.msgDownloadBtn:=rsDownload;
DownloadDialog1.msgCancelBtn:=rsCancel;
Button6.Caption:=rsAdd;
Button7.Caption:=rsDelete;
label2.Caption:=rsFavorite;
Button5.Caption:=rsObservatoryD;
Button8.Caption:=rsInternetLoca;
Label3.Caption:=rsName;
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
countrycode.Free;
end;

procedure Tf_config_observatory.FormCreate(Sender: TObject);
begin
SetLang;
LockChange:=true;
f_observatory_db:=Tf_observatory_db.Create(self);
f_observatory_db.onCountryChange:=CountryChange;
f_observatory_db.onObsChange:=ObsChange;
countrycode:=TStringList.Create;
end;

procedure Tf_config_observatory.FormShow(Sender: TObject);
begin
LockChange:=true;
f_observatory_db.cdb:=cdb;
f_observatory_db.cmain:=cmain;
f_observatory_db.csc:=csc;
f_observatory_db.ShowObservatory;
ShowHorizon;
ShowObservatory;
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

procedure Tf_config_observatory.ShowCountryList;
var i: integer;
begin
CountryTZ.checked:=csc.countrytz;
if countrylist.Items.Count=0 then cdb.GetCountryList(countrycode,countrylist.Items);
countrylist.itemindex:=0;
for i:=0 to countrylist.items.count-1 do
  if uppercase(trim(countrylist.Items[i]))=uppercase(trim(csc.obscountry)) then begin
    countrylist.itemindex:=i;
    break;
  end;
end;

procedure Tf_config_observatory.ShowObservatory;
var img:TJPEGImage;
    pict:TPicture;
begin
try
pressure.value:=csc.obspressure;
temperature.value:=csc.obstemperature;
ShowObsCoord;
ShowCountryList;
UpdTZList(self);
ObsName.text:=csc.obsname;
UpdFavList;
Obsposx:=0;
Obsposy:=0;
ZoomImage1.Xcentre:=Obsposx;
ZoomImage1.Ycentre:=Obsposy;
ZoomImage1.ZoomMax:=3;
if fileexists(cmain.EarthMapFile)and(cmain.EarthMapFile<>ObsMapfile) then begin
   ObsMapfile:=cmain.EarthMapFile;
   img:=TJPEGImage.Create;
   pict:=TPicture.Create;
   img.LoadFromFile(SysToUTF8(ObsMapfile));
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

procedure Tf_config_observatory.ObsChange(Sender: TObject);
begin
csc.ObsCountry:=f_observatory_db.csc.ObsCountry;
csc.ObsName:=f_observatory_db.csc.ObsName;
csc.ObsLatitude:=f_observatory_db.csc.ObsLatitude;
csc.ObsLongitude:=f_observatory_db.csc.ObsLongitude;
ObsName.Text:=csc.ObsName;
ShowObsCoord;
SetObsPos;
CenterObs;
end;

procedure Tf_config_observatory.CountryChange(Sender: TObject);
begin
  csc.ObsCountry:=f_observatory_db.csc.ObsCountry;
  UpdTZList(Sender);
end;

procedure Tf_config_observatory.UpdTZList(Sender: TObject);
var code, isocode,buf: string;
    i,j: integer;
begin
if f_observatory_db.countrylist.ItemIndex<0 then exit;
if CountryTZ.Checked then begin
   code:=f_observatory_db.countrycode[f_observatory_db.countrylist.ItemIndex];
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
     if (j=0)or(csc.tz.ZoneTabZone[i]=csc.ObsTZ)or((isocode='ZZ')and(j=12)) then TZComboBox.ItemIndex:=j;
     inc(j);
  end;
end;
TZComboBoxChange(Sender);
end;

procedure Tf_config_observatory.UpdTZList1(Sender: TObject);
// same as UpdTZList but using local country selection
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
     if (j=0)or(csc.tz.ZoneTabZone[i]=csc.ObsTZ)or((isocode='ZZ')and(j=12)) then TZComboBox.ItemIndex:=j;
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
  if i>0 then buf:=copy(buf,1,i-1);
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

procedure Tf_config_observatory.horizonfileAcceptFileName(Sender: TObject;
  var Value: String);
begin
 if LockChange then exit;
 cmain.horizonfile:=value;
end;

procedure Tf_config_observatory.ObsNameChange(Sender: TObject);
begin
  csc.ObsName:=ObsName.Text;
end;

procedure Tf_config_observatory.Button2Click(Sender: TObject);
begin
 if assigned(FApplyConfig) then FApplyConfig(Self);
end;

procedure Tf_config_observatory.Button4Click(Sender: TObject);
begin
  ShowHelp;
end;

procedure Tf_config_observatory.Button5Click(Sender: TObject);
var savename,savecountry:string;
    savelat,savelon:double;
begin
savecountry:=csc.ObsCountry;
savename:=csc.ObsName;
savelat:=csc.ObsLatitude;
savelon:=csc.ObsLongitude;
FormPos(f_observatory_db,Mouse.CursorPos.X,Mouse.CursorPos.Y);
if f_observatory_db.ShowModal=mrOK then begin
  csc.ObsCountry:=f_observatory_db.csc.ObsCountry;
  csc.ObsName:=f_observatory_db.csc.ObsName;
  csc.ObsLatitude:=f_observatory_db.csc.ObsLatitude;
  csc.ObsLongitude:=f_observatory_db.csc.ObsLongitude;
end else begin
  csc.ObsCountry := savecountry;
  csc.ObsName      := savename;
  csc.ObsLatitude  := savelat;
  csc.ObsLongitude := savelon;
  f_observatory_db.csc.ObsCountry := csc.ObsCountry;
  f_observatory_db.ShowObservatory;
end;
ObsName.Text:=csc.ObsName;
ShowCountryList;
UpdTZList(nil);
ShowObsCoord;
SetObsPos;
CenterObs;
end;

procedure Tf_config_observatory.Button6Click(Sender: TObject);
var obsdetail: TObsDetail;
    i: integer;
begin
obsdetail:=TObsDetail.Create;
obsdetail.country:=csc.ObsCountry;
obsdetail.lat:=csc.ObsLatitude;
obsdetail.lon:=csc.ObsLongitude;
if cmain.ObsNameList.Find(csc.ObsName,i) then begin
   cmain.ObsNameList.Objects[i].Free;
   cmain.ObsNameList.Objects[i]:=obsdetail;
end else begin
  cmain.ObsNameList.AddObject(csc.ObsName,obsdetail);
end;
UpdFavList;
end;

procedure Tf_config_observatory.Button7Click(Sender: TObject);
var i: integer;
begin
i:=ComboBox1.ItemIndex;
if i>=0 then begin
  cmain.ObsNameList.Objects[i].Free;
  cmain.ObsNameList.Delete(i);
  ComboBox1.Items.Delete(i);
end;
end;

procedure Tf_config_observatory.Button8Click(Sender: TObject);
var fn,buf,country: string;
    loc:TStringList;
    f: textfile;
begin
  if cmain.HttpProxy then begin
     DownloadDialog1.SocksProxy:='';
     DownloadDialog1.SocksType:='';
     DownloadDialog1.HttpProxy:=cmain.ProxyHost;
     DownloadDialog1.HttpProxyPort:=cmain.ProxyPort;
     DownloadDialog1.HttpProxyUser:=cmain.ProxyUser;
     DownloadDialog1.HttpProxyPass:=cmain.ProxyPass;
  end else if cmain.SocksProxy then begin
     DownloadDialog1.HttpProxy:='';
     DownloadDialog1.SocksType:=cmain.SocksType;
     DownloadDialog1.SocksProxy:=cmain.ProxyHost;
     DownloadDialog1.HttpProxyPort:=cmain.ProxyPort;
     DownloadDialog1.HttpProxyUser:=cmain.ProxyUser;
     DownloadDialog1.HttpProxyPass:=cmain.ProxyPass;
  end else begin
     DownloadDialog1.SocksProxy:='';
     DownloadDialog1.SocksType:='';
     DownloadDialog1.HttpProxy:='';
     DownloadDialog1.HttpProxyPort:='';
     DownloadDialog1.HttpProxyUser:='';
     DownloadDialog1.HttpProxyPass:='';
  end;
  DownloadDialog1.URL:=location_url;
  fn:=slash(TempDir)+'iploc.txt';
  DownloadDialog1.SaveToFile:=fn;
  DownloadDialog1.ConfirmDownload:=false;
  if DownloadDialog1.Execute and FileExists(fn) then begin
     AssignFile(f,fn);
     reset(f);
     read(f,buf);
     closefile(f);
     loc:=TStringList.Create;
     Splitarg(buf,tab,loc);
     if (loc.Count>=6)and(trim(loc[1])>'')and(trim(loc[3])>'')and(trim(loc[4])>'')and(trim(loc[5])>'') then begin
       cdb.GetCountryFromISO(trim(loc[1]),country);
       csc.ObsCountry:=country;
       csc.ObsName:=trim(loc[3]);
       csc.ObsLatitude:=StrToFloatDef(trim(loc[4]),csc.ObsLatitude);
       csc.ObsLongitude:=-StrToFloatDef(trim(loc[5]),-csc.ObsLongitude);
       f_observatory_db.csc.ObsCountry := csc.ObsCountry;
       f_observatory_db.ShowObservatory;
       ShowObservatory;
     end
     else ShowMessage(rsCannotGetYou+crlf+rsServerRespon+buf);
     loc.free;
  end
  else ShowMessage(rsCannotGetYou+crlf+DownloadDialog1.ResponseText);
end;

procedure Tf_config_observatory.ComboBox1Select(Sender: TObject);
var i: integer;
begin
  i:=ComboBox1.ItemIndex;
  csc.ObsName:=cmain.ObsNameList[i];
  csc.ObsCountry   := TObsDetail(cmain.ObsNameList.Objects[i]).country;
  csc.ObsLatitude  := TObsDetail(cmain.ObsNameList.Objects[i]).lat;
  csc.ObsLongitude := TObsDetail(cmain.ObsNameList.Objects[i]).lon;
  f_observatory_db.csc.ObsCountry := csc.ObsCountry;
  f_observatory_db.ShowObservatory;
  ObsName.text:=csc.obsname;
  ShowObsCoord;
  SetObsPos;
  CenterObs;
  UpdTZList(sender);
end;

procedure Tf_config_observatory.countrylistSelect(Sender: TObject);
begin
  if lockChange then exit;
  if countrylist.ItemIndex<0 then exit;
  try
  csc.obscountry:=countrylist.text;
  UpdTZList1(self);
  except
  end;
end;

procedure Tf_config_observatory.UpdFavList;
var i: integer;
begin
ComboBox1.Clear;
if cmain.ObsNameList.Count>0 then for i:=0 to cmain.ObsNameList.Count-1 do begin
  ComboBox1.Items.Add(cmain.ObsNameList[i]);
  if cmain.ObsNameList[i]=ObsName.Text then ComboBox1.ItemIndex:=i;
end;
end;

procedure Tf_config_observatory.FormClose(Sender: TObject;
  var CloseAction: TCloseAction);
begin
  LockChange:=true;
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
   ZoomImage1.Picture.LoadFromFile(SysToUTF8(cmain.EarthMapFile));
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

end.
