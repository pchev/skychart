unit pu_observatory_db;

{$mode objfpc}{$H+}

interface

uses  u_help, u_unzip, u_translation, u_constant, u_util, cu_database, LCLType,
  downloaddialog, enhedits, Classes, SysUtils, FileUtil, LResources, Forms,
  UScaleDPI, Controls, Graphics, Dialogs, StdCtrls, ComCtrls;

type

  { Tf_observatory_db }

  Tf_observatory_db = class(TForm)
    Button1: TButton;
    Button2: TButton;
    cityfilter: TEdit;
    citylist: TComboBox;
    citysearch: TButton;
    countrylist: TComboBox;
    delcity: TButton;
    downloadcity: TButton;
    DownloadDialog1: TDownloadDialog;
    hemis: TComboBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label58: TLabel;
    Label61: TLabel;
    latdeg: TLongEdit;
    Latitude: TGroupBox;
    latmin: TLongEdit;
    latsec: TLongEdit;
    LocCode: TEdit;
    long: TComboBox;
    longdeg: TLongEdit;
    Longitude: TGroupBox;
    longmin: TLongEdit;
    longsec: TLongEdit;
    Memo1: TMemo;
    obsname: TGroupBox;
    updcity: TButton;
    vicinity: TButton;
    vicinityrange: TUpDown;
    vicinityrangeEdit: TEdit;
    procedure cityfilterKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure citylistChange(Sender: TObject);
    procedure citysearchClick(Sender: TObject);
    procedure countrylistChange(Sender: TObject);
    procedure delcityClick(Sender: TObject);
    procedure downloadcityClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure latdegChange(Sender: TObject);
    procedure LocCodeClick(Sender: TObject);
    procedure longdegChange(Sender: TObject);
    procedure updcityClick(Sender: TObject);
    procedure vicinityClick(Sender: TObject);
  private
    { private declarations }
    CurObsId,StartSearch:integer;
    FCountryChange: TNotifyEvent;
    FObsChange: TNotifyEvent;
    procedure DoCitySearch;
  public
    { public declarations }
    countrycode: TStringList;
    citycode: TStringList;
    LockChange,obslock:boolean;
    cdb: Tcdcdb;
    csc : Tconf_skychart;
    cmain : Tconf_main;
    procedure SetLang;
    procedure ShowObservatory;
    Procedure ShowObsCoord;
    property onCountryChange: TNotifyEvent read FCountryChange write FCountryChange;
    property onObsChange: TNotifyEvent read FObsChange write FObsChange;
  end;

var
  f_observatory_db: Tf_observatory_db;

implementation
{$R *.lfm}

{ Tf_observatory_db }

procedure Tf_observatory_db.SetLang;
begin
Caption:=rsObservatoryD;
Label3.caption:=rsKm;
citysearch.caption:=rsSearch;
downloadcity.caption:=rsDownloadCoun;
updcity.caption:=rsUpdate1;
delcity.caption:=rsDelete;
vicinity.caption:=rsVicinity;
DownloadDialog1.msgDownloadFile:=rsDownloadFile;
DownloadDialog1.msgCopyfrom:=rsCopyFrom;
DownloadDialog1.msgtofile:=rsToFile;
DownloadDialog1.msgDownloadBtn:=rsDownload;
DownloadDialog1.msgCancelBtn:=rsCancel;
Label1.Caption:=rsLocationCode;
Latitude.Caption:=rsLatitude;
Longitude.Caption:=rsLongitude;
Label58.caption:=rsDegreesMinut;
hemis.items[0]:=rsNorth;
hemis.items[1]:=rsSouth;
Label61.caption:=rsDegreesMinut;
long.items[0]:=rsWest;
long.items[1]:=rsEast;
Button1.Caption:=rsOK;
Button2.Caption:=rsCancel;
end;

procedure Tf_observatory_db.ShowObservatory;
var i:integer;
begin
if countrylist.Items.Count=0 then cdb.GetCountryList(countrycode,countrylist.Items);
countrylist.itemindex:=0;
for i:=0 to countrylist.items.count-1 do
  if uppercase(trim(countrylist.Items[i]))=uppercase(trim(csc.obscountry)) then begin
    countrylist.itemindex:=i;
    break;
  end;
citylist.text:=csc.obsname;
end;

procedure Tf_observatory_db.countrylistChange(Sender: TObject);
begin
  if lockChange then exit;
  if countrylist.ItemIndex<0 then exit;
  try
  csc.obscountry:=countrylist.text;
  cityfilter.Text:='';
  citysearchClick(Sender);
  if assigned(FCountryChange) then FCountryChange(self);
  except
  end;
end;

procedure Tf_observatory_db.delcityClick(Sender: TObject);
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

procedure Tf_observatory_db.downloadcityClick(Sender: TObject);
var country,state,fn,fnzip,buf:string;
begin
if countrylist.ItemIndex<0 then exit;
if MessageDlg(Format(rsThisActionRe, [countrylist.Text, crlf, crlf]),
  mtWarning, [mbYes, mbNo], 0) = mrYes
  then begin
    country:=countrycode[countrylist.ItemIndex];
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
    DownloadDialog1.ConfirmDownload:=cmain.ConfirmDownload;
    if copy(country,1,3)='US-' then begin // US States
       state:=uppercase(copy(country,4,2));
       fnzip:=state+'_DECI.zip';
       fn:=ChangeFileExt(fnzip,'.txt');
       DownloadDialog1.URL:=baseurl_us+fnzip;
       fnzip:=slash(TempDir)+fnzip;
       DownloadDialog1.SaveToFile:=fnzip;
       if not FileExists(fnzip) then begin
          if not DownloadDialog1.Execute then Showmessage(Format(rsCancel2, [DownloadDialog1.ResponseText]));
       end else
          ShowMessage(Format(rsUsingExistin, [fnzip]));
       if FileExists(fnzip) then begin
          if FileUnzip(pchar(fnzip), pchar(TempDir), pchar(fn)) then begin
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
         ShowMessage(Format(rsNotFound, [fnzip]));
    end else begin  // World
       fnzip:=lowercase(country)+'.zip';
       fn:=ChangeFileExt(fnzip,'.txt');
       DownloadDialog1.URL:=baseurl_world+fnzip;
       fnzip:=slash(TempDir)+fnzip;
       DownloadDialog1.SaveToFile:=fnzip;
       if not FileExists(fnzip) then begin
          if not DownloadDialog1.Execute then Showmessage(Format(rsCancel2, [DownloadDialog1.ResponseText]));
       end else
          ShowMessage(Format(rsUsingExistin, [fnzip]));
       if FileExists(fnzip) then begin
          if FileUnzip(pchar(fnzip), pchar(TempDir), pchar(fn)) then begin
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
         ShowMessage(Format(rsNotFound, [fnzip]));
    end;
end;
end;

procedure Tf_observatory_db.FormCreate(Sender: TObject);
begin
ScaleDPI(Self);
SetLang;
countrycode:=TStringList.Create;
citycode:=TStringList.Create;
LockChange:=true;
obslock:=false;
end;

procedure Tf_observatory_db.FormDestroy(Sender: TObject);
begin
  countrycode.Free;
  citycode.Free;
end;

procedure Tf_observatory_db.FormShow(Sender: TObject);
var cntrychange: boolean;
begin
  LockChange:=true;
  cityfilter.text:=copy(csc.obsname,1,3);
  cntrychange:=(countrylist.Items.Count>0)and(uppercase(trim(countrylist.Text))<>uppercase(trim(csc.obscountry)));
  ShowObservatory;
  showobscoord;
  if cntrychange then begin
    cityfilter.Text:='';
    citysearchClick(Sender);
  end;
  if cityfilter.Text='-' then begin
     cityfilter.Text:='';
     citysearchClick(Sender);
  end;
  LockChange:=false;
end;

procedure Tf_observatory_db.latdegChange(Sender: TObject);
begin
if LockChange then exit;
if obslock then exit;
csc.ObsLatitude:=latdeg.value+latmin.value/60+latsec.value/3600;
if hemis.Itemindex>0 then csc.ObsLatitude:=-csc.ObsLatitude;
if assigned(FObsChange) then FObsChange(self);
end;

procedure Tf_observatory_db.LocCodeClick(Sender: TObject);
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

Procedure Tf_observatory_db.ShowObsCoord;
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

procedure Tf_observatory_db.longdegChange(Sender: TObject);
begin
if LockChange then exit;
if obslock then exit;
csc.ObsLongitude:=longdeg.value+longmin.value/60+longsec.value/3600;
if long.Itemindex>0 then csc.ObsLongitude:=-csc.ObsLongitude;
if assigned(FObsChange) then FObsChange(self);
end;

procedure Tf_observatory_db.updcityClick(Sender: TObject);
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
    if p>0 then location:=copy(location,1,p-1);
    buf:=cdb.UpdateCity(curobsid,country,location,'user',lat,lon,elev,ltz);
    if buf='' then buf:=rsUpdatedSucce;
    vicinityClick(Sender);
    showmessage(buf);
  end;
end;

procedure Tf_observatory_db.vicinityClick(Sender: TObject);
var lon,lat,dd:double;
    country,oldcity:string;
    i,p: integer;
begin
if countrylist.ItemIndex<0 then exit;
oldcity:=trim(citylist.Text);
p:=pos(' -- ',oldcity);
if p>0 then oldcity:=Copy(oldcity,1,p-1);
lockChange:=true;
citylist.Clear;
citycode.Clear;
country:=countrycode[countrylist.ItemIndex];
dd:=vicinityrange.position/kmperdegree;
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

procedure Tf_observatory_db.cityfilterKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
 if key=VK_RETURN then citysearchClick(Sender);
end;

procedure Tf_observatory_db.citylistChange(Sender: TObject);
var id,loctype,lati,longi,elevation,timezone,obs:string;
    p:integer;
begin
if LockChange then exit;
if citylist.ItemIndex>MaxCityList-1 then begin
  citylist.Text:=csc.ObsName;
  StartSearch:=StartSearch+MaxCityList-1;
  DoCitySearch;
  exit;
end;
obs:=citylist.text;
p:=pos(' -- ',obs);
if p>0 then obs:=copy(obs,1,p-1);
csc.obsname:=obs;
if citylist.ItemIndex<0 then begin curobsid:=0; exit; end;
id:=citycode[citylist.ItemIndex];
if cdb.GetCityLoc(id,loctype,lati,longi,elevation,timezone) then begin
   curobsid:=strtoint(citycode[citylist.ItemIndex]);
   LocCode.text:=loctype;
   csc.ObsLatitude:=strtofloat(trim(lati));
   csc.ObsLongitude:=-strtofloat(trim(longi));
   csc.ObsAltitude:=strtofloat(trim(elevation));
   if assigned(FObsChange) then FObsChange(self);
   ShowObsCoord;
end
else curobsid:=0;
end;

procedure Tf_observatory_db.DoCitySearch;
var code,filter: string;
begin
if countrylist.ItemIndex<0 then exit;
lockChange:=true;
code:=countrycode[countrylist.ItemIndex];
filter:=cityfilter.Text;
if filter<>'' then filter:=filter+'%';
cdb.GetCityList(code,filter,citycode,citylist.Items,StartSearch,MaxCityList);
if citylist.Items.Count>0 then citylist.Text:=citylist.Items[0];
lockChange:=false;
citylistChange(self);
end;

procedure Tf_observatory_db.citysearchClick(Sender: TObject);
begin
screen.Cursor:=crHourGlass;
try
StartSearch:=0;
DoCitySearch;
finally
screen.Cursor:=crDefault;
end;
end;

end.

