unit fu_config_observatory;

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

interface

uses
  u_unzip, pu_observatory_db, IniFiles, LCLType, BGRABitmap, BGRABitmapTypes,
  u_help, u_translation, u_constant, u_util, cu_database, Math, dynlibs, UScaleDPI,
  LCLIntf, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, FileUtil,
  Buttons, StdCtrls, ExtCtrls, cu_zoomimage, enhedits, ComCtrls, LResources,
  Spin, downloaddialog, EditBtn, LazHelpHTML_fix;

type

  { Tf_config_observatory }

  Tf_config_observatory = class(TFrame)
    altmeter: TFloatEdit;
    AirmassMagnitude: TCheckBox;
    DarkenHorizon: TCheckBox;
    GroupBox4: TGroupBox;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    pictureelevation: TFloatEdit;
    HorizonRise: TCheckBox;
    Label10: TLabel;
    Label11: TLabel;
    ShowHorizon0: TCheckBox;
    HorizonQuality: TCheckBox;
    displayhorizonpicture: TCheckBox;
    picturerotation: TFloatEdit;
    horizonpicturefile: TFileNameEdit;
    Label9: TLabel;
    RefDefault: TButton;
    Button5: TButton;
    Button6: TButton;
    Button7: TButton;
    Button8: TButton;
    ComboBox1: TComboBox;
    countrylist: TComboBox;
    CountryTZ: TCheckBox;
    DownloadDialog1: TDownloadDialog;
    humidity: TFloatEdit;
    Label5: TLabel;
    tlrate: TFloatEdit;
    Label4: TLabel;
    latsec: TFloatEdit;
    longsec: TFloatEdit;
    Label2: TLabel;
    Label3: TLabel;
    ObsName: TEdit;
    TZComboBox: TComboBox;
    fillhorizon: TCheckBox;
    horizonfile: TFileNameEdit;
    Label82: TLabel;
    Label83: TLabel;
    OpenDialog1: TOpenDialog;
    pressure: TFloatEdit;
    refraction: TGroupBox;
    temperature: TFloatEdit;
    MainPanel: TPanel;
    Page1: TTabSheet;
    Page2: TTabSheet;
    Latitude: TGroupBox;
    Label58: TLabel;
    hemis: TComboBox;
    latdeg: TFloatEdit;
    latmin: TLongEdit;
    Longitude: TGroupBox;
    Label61: TLabel;
    long: TComboBox;
    longdeg: TFloatEdit;
    longmin: TLongEdit;
    Altitude: TGroupBox;
    Label70: TLabel;
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
    displayhorizon: TCheckBox;
    GroupBox3: TGroupBox;
    horizondepression: TCheckBox;
    Label1: TLabel;
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure Button8Click(Sender: TObject);
    procedure AirmassMagnitudeClick(Sender: TObject);
    procedure DarkenHorizonChange(Sender: TObject);
    procedure HorizonRiseClick(Sender: TObject);
    procedure latKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
    procedure longKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
    procedure PageControl1Changing(Sender: TObject; var AllowChange: boolean);
    procedure pictureelevationChange(Sender: TObject);
    procedure ShowHorizon0Click(Sender: TObject);
    procedure ComboBox1Select(Sender: TObject);
    procedure countrylistSelect(Sender: TObject);
    procedure CountryTZChange(Sender: TObject);
    procedure displayhorizonpictureClick(Sender: TObject);
    procedure horizonfileAcceptFileName(Sender: TObject; var Value: string);
    procedure horizonpicturefileAcceptFileName(Sender: TObject; var Value: string);
    procedure horizonpicturefileChange(Sender: TObject);
    procedure HorizonQualityClick(Sender: TObject);
    procedure HScrollBarScroll(Sender: TObject; ScrollCode: TScrollCode;
      var ScrollPos: integer);
    procedure humidityChange(Sender: TObject);
    procedure ObsNameChange(Sender: TObject);
    procedure picturerotationChange(Sender: TObject);
    procedure RefDefaultClick(Sender: TObject);
    procedure tlrateChange(Sender: TObject);
    procedure TZComboBoxChange(Sender: TObject);
    procedure fillhorizonClick(Sender: TObject);
    procedure latdegChange(Sender: TObject);
    procedure longdegChange(Sender: TObject);
    procedure altmeterChange(Sender: TObject);
    procedure pressureChange(Sender: TObject);
    procedure temperatureChange(Sender: TObject);
    procedure VScrollBarScroll(Sender: TObject; ScrollCode: TScrollCode;
      var ScrollPos: integer);
    procedure ZoomImage1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: integer);
    procedure ZoomImage1Paint(Sender: TObject);
    procedure ZoomImage1PosChange(Sender: TObject);
    procedure ObszpClick(Sender: TObject);
    procedure ObszmClick(Sender: TObject);
    procedure ObsmapClick(Sender: TObject);
    procedure horizonopaqueClick(Sender: TObject);
    procedure horizonfileChange(Sender: TObject);
    procedure displayhorizonClick(Sender: TObject);
    procedure horizondepressionClick(Sender: TObject);
  private
    { Private declarations }
    FApplyConfig: TNotifyEvent;
    scrolllock, obslock, LockChange, lockscrollbar: boolean;
    Obsposx, Obsposy: integer;
    scrollw, scrollh: integer;
    ObsMapFile: string;
    countrycode: TStringList;
    procedure SetScrollBar;
    procedure SetObsPos;
    procedure ShowObsCoord;
    procedure CenterObs;
    procedure LoadMap(fn: string);
    procedure ShowHorizon;
    procedure ShowObservatory;
    procedure ShowCountryList;
    procedure UpdTZList(Sender: TObject);
    procedure UpdTZList1(Sender: TObject);
    procedure UpdFavList;
    procedure CountryChange(Sender: TObject);
    procedure ObsChange(Sender: TObject);
    procedure GetPictureRotation;
  public
    { Public declarations }
    cdb: Tcdcdb;
    mycsc: Tconf_skychart;
    myccat: Tconf_catalog;
    mycshr: Tconf_shared;
    mycplot: Tconf_plot;
    mycmain: Tconf_main;
    csc: Tconf_skychart;
    ccat: Tconf_catalog;
    cshr: Tconf_shared;
    cplot: Tconf_plot;
    cmain: Tconf_main;
    procedure Init; // old FormShow
    procedure Lock; // old FormClose
    procedure SetLang;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property onApplyConfig: TNotifyEvent read FApplyConfig write FApplyConfig;
  end;

implementation

{$R *.lfm}

procedure Tf_config_observatory.SetLang;
begin
  Caption := rsObservatory;
  Page1.Caption := rsObservatory;
  Latitude.Caption := rsLatitude;
  Longitude.Caption := rsLongitude;
  Altitude.Caption := Format(rsObsAltitude, ['']);
  Label58.Caption := rsDegreesMinut;
  Label61.Caption := rsDegreesMinut;
  Label70.Caption := rsMeters;
  timezone.Caption := rsTimeZone;
  CountryTZ.Caption := rsCountryTimez;
  Obsmap.Caption := rsMap;
  refraction.Caption := rsAtmosphericR;
  Label82.Caption := rsPressureMill;
  Label83.Caption := rsTemperatureC;
  label4.Caption := rsHumidity;
  label5.Caption := rsTroposphereT;
  RefDefault.Caption := rsDefault;
  Page2.Caption := rsHorizon;
  GroupBox2.Caption := rsWantToTrackA;
  horizonopaque.Caption := rsShowObjectBe;
  GroupBox1.Caption := rsLocalHorizon;
  displayhorizon.Caption := rsDisplayTheLo;
  displayhorizonpicture.Caption := rsDisplayTheHo;
  HorizonQuality.Caption := rsHighQuality;
  label9.Caption := rsPictureAngle;
  fillhorizon.Caption := rsFillWithHori;
  ShowHorizon0.Caption := rsShow0Horizon;
  HorizonRise.Caption := rsComputeRiseS;
  GroupBox3.Caption := rsDepressionOf;
  Label1.Caption := rsYouLiveOnABi;
  horizondepression.Caption := rsDrawTheAppar;
  SetHelp(self, hlpCfgObs);
  DownloadDialog1.msgDownloadFile := rsDownloadFile;
  DownloadDialog1.msgCopyfrom := rsCopyFrom;
  DownloadDialog1.msgtofile := rsToFile;
  DownloadDialog1.msgDownloadBtn := rsDownload;
  DownloadDialog1.msgCancelBtn := rsCancel;
  Button6.Caption := rsSave;
  Button7.Caption := rsDelete;
  label2.Caption := rsFavorite;
  Button5.Caption := rsObservatoryD;
  Button8.Caption := rsInternetLoca;
  Label3.Caption := rsName;
end;

constructor Tf_config_observatory.Create(AOwner: TComponent);
begin
  mycsc := Tconf_skychart.Create;
  myccat := Tconf_catalog.Create;
  mycshr := Tconf_shared.Create;
  mycplot := Tconf_plot.Create;
  mycmain := Tconf_main.Create;
  csc := mycsc;
  ccat := myccat;
  cshr := mycshr;
  cplot := mycplot;
  cmain := mycmain;
  inherited Create(AOwner);
  SetLang;
  LockChange := True;
  f_observatory_db := Tf_observatory_db.Create(self);
  f_observatory_db.onCountryChange := CountryChange;
  f_observatory_db.onObsChange := ObsChange;
  countrycode := TStringList.Create;
end;

destructor Tf_config_observatory.Destroy;
begin
  mycsc.Free;
  myccat.Free;
  mycshr.Free;
  mycplot.Free;
  mycmain.Free;
  countrycode.Free;
  inherited Destroy;
end;

procedure Tf_config_observatory.Init;
begin
  LockChange := True;
  f_observatory_db.cdb := cdb;
  f_observatory_db.cmain := cmain;
  f_observatory_db.csc := csc;
  f_observatory_db.ShowObservatory;
  ShowHorizon;
  ShowObservatory;
  LockChange := False;
  VScrollBar.Top := ZoomImage1.Top;
  VScrollBar.Left := ZoomImage1.Left + ZoomImage1.Width;
  VScrollBar.Height := ZoomImage1.Height;
  HScrollBar.Left := ZoomImage1.Left;
  HScrollBar.Top := ZoomImage1.Top + ZoomImage1.Height;
  HScrollBar.Width := ZoomImage1.Width;
  hemis.Height := latdeg.Height;
  long.Height := latdeg.Height;
end;

procedure Tf_config_observatory.ShowObsCoord;
var
  d, m, s: string;
begin
  try
    obslock := True;
    altmeter.Value := csc.obsaltitude;
    ArToStr4(abs(csc.ObsLatitude), f1, d, m, s);
    latdeg.Text := d;
    latmin.Text := m;
    latsec.Text := s;
    ArToStr4(abs(csc.ObsLongitude), f1, d, m, s);
    longdeg.Text := d;
    longmin.Text := m;
    longsec.Text := s;
    if csc.ObsLatitude >= 0 then
      hemis.ItemIndex := 0
    else
      hemis.ItemIndex := 1;
    if csc.ObsLongitude >= 0 then
      long.ItemIndex := 0
    else
      long.ItemIndex := 1;
  finally
    obslock := False;
  end;
end;

procedure Tf_config_observatory.SetObsPos;
begin
  Obsposx := round(ZoomImage1.SizeX * (180 - csc.ObsLongitude) / 360);
  Obsposy := round(ZoomImage1.SizeY * (90 - csc.ObsLatitude) / 180);
  ZoomImage1.Xcentre := Obsposx;
  ZoomImage1.Ycentre := Obsposy;
end;

procedure Tf_config_observatory.CenterObs;
begin
  ZoomImage1.Xcentre := Obsposx;
  ZoomImage1.Ycentre := Obsposy;
  ZoomImage1.Draw;
  SetScrollBar;
end;

procedure Tf_config_observatory.ShowCountryList;
var
  i: integer;
begin
  CountryTZ.Checked := csc.countrytz;
  if countrylist.Items.Count = 0 then
    cdb.GetCountryList(countrycode, countrylist.Items);
  for i := 0 to countrylist.items.Count - 1 do
    if uppercase(trim(countrylist.Items[i])) = uppercase(trim(csc.obscountry)) then
    begin
      countrylist.ItemIndex := i;
      break;
    end;
end;

procedure Tf_config_observatory.ShowObservatory;
begin
  try
    pressure.Value := csc.obspressure;
    temperature.Value := csc.obstemperature;
    humidity.Value := csc.ObsRH * 100;
    tlrate.Value := csc.ObsTlr * 1000;
    ShowObsCoord;
    ShowCountryList;
    UpdTZList(self);
    ObsName.Text := csc.obsname;
    UpdFavList;
    Obsposx := 0;
    Obsposy := 0;
    ZoomImage1.Xcentre := Obsposx;
    ZoomImage1.Ycentre := Obsposy;
    ZoomImage1.ZoomMax := 3;
    LoadMap(cmain.EarthMapFile);
    ZoomImage1.Zoom := ZoomImage1.ZoomMin;
    SetScrollBar;
    Hscrollbar.Position := ZoomImage1.SizeX div 2;
    Vscrollbar.Position := ZoomImage1.SizeY div 2;
    SetObsPos;
    CenterObs;
  except
  end;
end;

procedure Tf_config_observatory.LoadMap(fn: string);
var
  bmp: TBGRABitmap;
  coln: TBGRAPixel;
begin
  if fileexists(fn) and (fn <> ObsMapfile) then
  begin
    ObsMapfile := fn;
    bmp := TBGRABitmap.Create(ObsMapfile);
    if nightvision then
    begin
      coln := ColorToBGRA($101040, $c0);
      bmp.FillRect(0, 0, bmp.Width, bmp.Height, coln, dmDrawWithTransparency);
    end;
    ZoomImage1.Picture.Assign(bmp);
    bmp.Free;
  end
  else
    ZoomImage1.PictureChange(self);
end;

procedure Tf_config_observatory.ObsChange(Sender: TObject);
begin
  csc.ObsCountry := f_observatory_db.csc.ObsCountry;
  csc.ObsName := f_observatory_db.csc.ObsName;
  csc.ObsLatitude := f_observatory_db.csc.ObsLatitude;
  csc.ObsLongitude := f_observatory_db.csc.ObsLongitude;
  ObsName.Text := csc.ObsName;
  ShowObsCoord;
  SetObsPos;
  CenterObs;
end;

procedure Tf_config_observatory.CountryChange(Sender: TObject);
begin
  csc.ObsCountry := f_observatory_db.csc.ObsCountry;
  UpdTZList(Sender);
  ShowCountryList;
end;

procedure Tf_config_observatory.UpdTZList(Sender: TObject);
var
  code, isocode, buf: string;
  i, j: integer;
begin
  if f_observatory_db.countrylist.ItemIndex < 0 then
    exit;
  if CountryTZ.Checked then
  begin
    code := f_observatory_db.countrycode[f_observatory_db.countrylist.ItemIndex];
    cdb.GetCountryISOCode(code, isocode);
    countrylist.Visible := True;
  end
  else
  begin
    isocode := 'ZZ';
    countrylist.Visible := False;
  end;
  TZComboBox.Clear;
  for i := 0 to csc.tz.ZoneTabCnty.Count - 1 do
  begin
    if csc.tz.ZoneTabCnty[i] = isocode then
    begin
      buf := csc.tz.ZoneTabZone[i];
      if csc.tz.ZoneTabComment[i] > '' then
        buf := buf + ' (' + csc.tz.ZoneTabComment[i] + ')';
      if (isocode = 'ZZ') then
        buf := TzGMT2UTC(buf);
      j:=TZComboBox.Items.Add(buf);
      if (csc.tz.ZoneTabZone[i] = csc.ObsTZ) then
        TZComboBox.ItemIndex := j;
    end;
  end;
  if (TZComboBox.ItemIndex = -1) then
  begin
    if isocode = 'ZZ' then
      TZComboBox.ItemIndex := 12
    else
      TZComboBox.ItemIndex := 0;
  end;
  TZComboBoxChange(Sender);
end;

procedure Tf_config_observatory.UpdTZList1(Sender: TObject);
// same as UpdTZList but using local country selection
var
  code, isocode, buf: string;
  i, j: integer;
begin
  if countrylist.ItemIndex < 0 then
    exit;
  if CountryTZ.Checked then
  begin
    code := countrycode[countrylist.ItemIndex];
    cdb.GetCountryISOCode(code, isocode);
    countrylist.Visible := True;
  end
  else
  begin
    isocode := 'ZZ';
    countrylist.Visible := False;
  end;
  TZComboBox.Clear;
  for i := 0 to csc.tz.ZoneTabCnty.Count - 1 do
  begin
    if csc.tz.ZoneTabCnty[i] = isocode then
    begin
      buf := csc.tz.ZoneTabZone[i];
      if csc.tz.ZoneTabComment[i] > '' then
        buf := buf + ' (' + csc.tz.ZoneTabComment[i] + ')';
      if (isocode = 'ZZ') then
        buf := TzGMT2UTC(buf);
      j:=TZComboBox.Items.Add(buf);
      if (csc.tz.ZoneTabZone[i] = csc.ObsTZ) then
        TZComboBox.ItemIndex := j;
      Inc(j);
    end;
  end;
  if (TZComboBox.ItemIndex = -1) then
  begin
    if isocode = 'ZZ' then
      TZComboBox.ItemIndex := 12
    else
      TZComboBox.ItemIndex := 0;
  end;
  TZComboBoxChange(Sender);
end;

procedure Tf_config_observatory.TZComboBoxChange(Sender: TObject);
var
  buf: string;
  i: integer;
begin
  buf := trim(TZComboBox.Text);
  if buf = '' then
    exit;
  i := pos(' ', buf);
  if i > 0 then
    buf := copy(buf, 1, i - 1);
  if copy(buf, 1, 3) = 'UTC' then
    buf := TzUTC2GMT(buf);
  csc.ObsTZ := buf;
  csc.tz.Longitude:=csc.ObsLongitude;
  csc.tz.TimeZoneFile := ZoneDir + StringReplace(buf, '/', PathDelim, [rfReplaceAll]);
  csc.timezone := csc.tz.SecondsOffset / 3600;
end;

procedure Tf_config_observatory.CountryTZChange(Sender: TObject);
begin
  if LockChange then
    exit;
  csc.countrytz := CountryTZ.Checked;
  UpdTZList(Sender);
end;

procedure Tf_config_observatory.displayhorizonpictureClick(Sender: TObject);
begin
  csc.ShowHorizonPicture := displayhorizonpicture.Checked;
  if csc.ShowHorizonPicture then
    displayhorizon.Checked := False;
end;

procedure Tf_config_observatory.ObsNameChange(Sender: TObject);
begin
  csc.ObsName := ObsName.Text;
end;

procedure Tf_config_observatory.Button5Click(Sender: TObject);
var
  savename, savecountry: string;
  savelat, savelon: double;
begin
  savecountry := csc.ObsCountry;
  savename := csc.ObsName;
  savelat := csc.ObsLatitude;
  savelon := csc.ObsLongitude;
  FormPos(f_observatory_db, Mouse.CursorPos.X, Mouse.CursorPos.Y);
  ShowModalForm(f_observatory_db, True);
  if f_observatory_db.ModalResult = mrOk then
  begin
    csc.ObsCountry := f_observatory_db.csc.ObsCountry;
    csc.ObsName := f_observatory_db.csc.ObsName;
    csc.ObsLatitude := f_observatory_db.csc.ObsLatitude;
    csc.ObsLongitude := f_observatory_db.csc.ObsLongitude;
  end
  else
  begin
    csc.ObsCountry := savecountry;
    csc.ObsName := savename;
    csc.ObsLatitude := savelat;
    csc.ObsLongitude := savelon;
    f_observatory_db.csc.ObsCountry := csc.ObsCountry;
    f_observatory_db.ShowObservatory;
  end;
  ObsName.Text := csc.ObsName;
  ShowCountryList;
  UpdTZList(nil);
  ShowObsCoord;
  SetObsPos;
  CenterObs;
end;

procedure Tf_config_observatory.Button6Click(Sender: TObject);
var
  obsdetail: TObsDetail;
  i: integer;
begin
  obsdetail := TObsDetail.Create;
  obsdetail.country := csc.ObsCountry;
  obsdetail.countrytz := csc.countrytz;
  obsdetail.tz := csc.ObsTZ;
  obsdetail.lat := csc.ObsLatitude;
  obsdetail.lon := csc.ObsLongitude;
  obsdetail.alt := csc.ObsAltitude;
  obsdetail.horizonfn := csc.HorizonFile;
  obsdetail.horizonpictfn := csc.HorizonPictureFile;
  obsdetail.pictureangleoffset := csc.HorizonPictureRotate;
  obsdetail.showhorizonline := csc.ShowHorizon;
  obsdetail.showhorizonpicture := csc.ShowHorizonPicture;
  if cmain.ObsNameList.Find(csc.ObsName, i) then
  begin
    cmain.ObsNameList.Objects[i].Free;
    cmain.ObsNameList.Objects[i] := obsdetail;
  end
  else
  begin
    cmain.ObsNameList.AddObject(csc.ObsName, obsdetail);
  end;
  UpdFavList;
end;

procedure Tf_config_observatory.Button7Click(Sender: TObject);
var
  i: integer;
begin
  i := ComboBox1.ItemIndex;
  if i >= 0 then
  begin
    cmain.ObsNameList.Objects[i].Free;
    cmain.ObsNameList.Delete(i);
    ComboBox1.Items.Delete(i);
  end;
end;

procedure Tf_config_observatory.Button8Click(Sender: TObject);
var
  fn, buf, country: string;
  loc: TStringList;
  f: textfile;
  i: integer;
begin
  DownloadDialog1.ScaleDpi:=UScaleDPI.scale;
  if cmain.HttpProxy then
  begin
    DownloadDialog1.SocksProxy := '';
    DownloadDialog1.SocksType := '';
    DownloadDialog1.HttpProxy := cmain.ProxyHost;
    DownloadDialog1.HttpProxyPort := cmain.ProxyPort;
    DownloadDialog1.HttpProxyUser := cmain.ProxyUser;
    DownloadDialog1.HttpProxyPass := cmain.ProxyPass;
  end
  else if cmain.SocksProxy then
  begin
    DownloadDialog1.HttpProxy := '';
    DownloadDialog1.SocksType := cmain.SocksType;
    DownloadDialog1.SocksProxy := cmain.ProxyHost;
    DownloadDialog1.HttpProxyPort := cmain.ProxyPort;
    DownloadDialog1.HttpProxyUser := cmain.ProxyUser;
    DownloadDialog1.HttpProxyPass := cmain.ProxyPass;
  end
  else
  begin
    DownloadDialog1.SocksProxy := '';
    DownloadDialog1.SocksType := '';
    DownloadDialog1.HttpProxy := '';
    DownloadDialog1.HttpProxyPort := '';
    DownloadDialog1.HttpProxyUser := '';
    DownloadDialog1.HttpProxyPass := '';
  end;
  DownloadDialog1.URL := location_url;
  fn := slash(TempDir) + 'iploc.txt';
  DownloadDialog1.SaveToFile := fn;
  DownloadDialog1.ConfirmDownload := False;
  if DownloadDialog1.Execute and FileExists(fn) then
  begin
    AssignFile(f, fn);
    reset(f);
    Read(f, buf);
    closefile(f);
    loc := TStringList.Create;
    Splitarg(buf, tab, loc);
    if (loc.Count >= 6) and (trim(loc[1]) > '') and (trim(loc[3]) > '') and
      (trim(loc[4]) > '') and (trim(loc[5]) > '') then
    begin
      cdb.GetCountryFromISO(trim(loc[1]), country);
      csc.ObsCountry := country;
      csc.ObsName := trim(loc[3]);
      csc.ObsLatitude := StrToFloatDef(trim(loc[4]), csc.ObsLatitude);
      csc.ObsLongitude := -StrToFloatDef(trim(loc[5]), -csc.ObsLongitude);
      f_observatory_db.csc.ObsCountry := csc.ObsCountry;
      f_observatory_db.ShowObservatory;
      ShowObservatory;
      if TZComboBox.Items.Count>1 then begin
        // country use more than one timezone, because it is not possible to select the right one
        // based on the iploc information we set the offset using the current OS setting
        i:=12+round(GetLocalTimeOffset/60);
        CountryTZ.Checked:=false;
        if (i>=0) and (i<TZComboBox.Items.Count) then begin
          TZComboBox.ItemIndex:=i;
          TZComboBoxChange(nil);
        end;
      end;
    end
    else
      ShowMessage(rsCannotGetYou + crlf + rsServerRespon + buf);
    loc.Free;
  end
  else
    ShowMessage(rsCannotGetYou + crlf + DownloadDialog1.ResponseText);
end;

procedure Tf_config_observatory.AirmassMagnitudeClick(Sender: TObject);
begin
  csc.AirmassMagnitude:=AirmassMagnitude.Checked;
end;

procedure Tf_config_observatory.ComboBox1Select(Sender: TObject);
var
  i: integer;
begin
  i := ComboBox1.ItemIndex;
  csc.ObsName := cmain.ObsNameList[i];
  csc.ObsCountry := TObsDetail(cmain.ObsNameList.Objects[i]).country;
  csc.countrytz := TObsDetail(cmain.ObsNameList.Objects[i]).countrytz;
  csc.ObsTZ := TObsDetail(cmain.ObsNameList.Objects[i]).tz;
  csc.ObsLatitude := TObsDetail(cmain.ObsNameList.Objects[i]).lat;
  csc.ObsLongitude := TObsDetail(cmain.ObsNameList.Objects[i]).lon;
  csc.ObsAltitude := TObsDetail(cmain.ObsNameList.Objects[i]).alt;
  csc.HorizonFile := TObsDetail(cmain.ObsNameList.Objects[i]).horizonfn;
  csc.HorizonPictureFile := TObsDetail(cmain.ObsNameList.Objects[i]).horizonpictfn;
  csc.HorizonPictureRotate := TObsDetail(cmain.ObsNameList.Objects[i]).pictureangleoffset;
  csc.HorizonPictureElevation := TObsDetail(cmain.ObsNameList.Objects[i]).pictureelevation;
  csc.ShowHorizon := TObsDetail(cmain.ObsNameList.Objects[i]).showhorizonline;
  csc.ShowHorizonPicture := TObsDetail(cmain.ObsNameList.Objects[i]).showhorizonpicture;
  f_observatory_db.csc.ObsCountry := csc.ObsCountry;
  f_observatory_db.ShowObservatory;
  ObsName.Text := csc.obsname;
  ShowObsCoord;
  ShowHorizon;
  SetObsPos;
  CenterObs;
  ShowCountryList;
  UpdTZList(Sender);
end;

procedure Tf_config_observatory.countrylistSelect(Sender: TObject);
begin
  if lockChange then
    exit;
  if countrylist.ItemIndex < 0 then
    exit;
  try
    csc.obscountry := countrylist.Text;
    UpdTZList1(self);
  except
  end;
end;

procedure Tf_config_observatory.UpdFavList;
var
  i: integer;
begin
  ComboBox1.Clear;
  if cmain.ObsNameList.Count > 0 then
    for i := 0 to cmain.ObsNameList.Count - 1 do
    begin
      ComboBox1.Items.Add(cmain.ObsNameList[i]);
      if cmain.ObsNameList[i] = ObsName.Text then
        ComboBox1.ItemIndex := i;
    end;
end;

procedure Tf_config_observatory.Lock;
begin
  LockChange := True;
end;

procedure Tf_config_observatory.latdegChange(Sender: TObject);
begin
  if LockChange then
    exit;
  if obslock then
    exit;
  if frac(latdeg.Value) > 0 then
    csc.ObsLatitude := latdeg.Value
  else
    csc.ObsLatitude := latdeg.Value + latmin.Value / 60 + latsec.Value / 3600;
  if hemis.ItemIndex > 0 then
    csc.ObsLatitude := -csc.ObsLatitude;
  ShowObsCoord;
  SetObsPos;
  CenterObs;
end;

procedure Tf_config_observatory.longdegChange(Sender: TObject);
begin
  if LockChange then
    exit;
  if obslock then
    exit;
  if frac(longdeg.Value) > 0 then
    csc.ObsLongitude := longdeg.Value
  else
    csc.ObsLongitude := longdeg.Value + longmin.Value / 60 + longsec.Value / 3600;
  if long.ItemIndex > 0 then
    csc.ObsLongitude := -csc.ObsLongitude;
  ShowObsCoord;
  SetObsPos;
  CenterObs;
end;

procedure Tf_config_observatory.latKeyDown(Sender: TObject; var Key: word;
  Shift: TShiftState);
begin
  if key = VK_RETURN then
    latdegChange(Sender);
end;

procedure Tf_config_observatory.longKeyDown(Sender: TObject; var Key: word;
  Shift: TShiftState);
begin
  if key = VK_RETURN then
    longdegChange(Sender);
end;

procedure Tf_config_observatory.PageControl1Changing(Sender: TObject;
  var AllowChange: boolean);
begin
  if parent is TForm then
    TForm(Parent).ActiveControl := PageControl1;
end;

procedure Tf_config_observatory.altmeterChange(Sender: TObject);
begin
  if LockChange then
    exit;
  csc.obsaltitude := altmeter.Value;
end;

procedure Tf_config_observatory.pressureChange(Sender: TObject);
begin
  if LockChange then
    exit;
  csc.ObsPressure := pressure.Value;
end;

procedure Tf_config_observatory.temperatureChange(Sender: TObject);
begin
  if LockChange then
    exit;
  csc.obstemperature := temperature.Value;
end;

procedure Tf_config_observatory.ZoomImage1MouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: integer);
begin
  if ZoomImage1.SizeX > 0 then
  begin
    Obsposx := ZoomImage1.scr2wrldx(x);
    Obsposy := ZoomImage1.scr2wrldy(y);
    ZoomImage1.Invalidate;
    csc.ObsLongitude := 180 - 360 * Obsposx / ZoomImage1.SizeX;
    csc.ObsLatitude := 90 - 180 * Obsposy / ZoomImage1.SizeY;
    ShowObsCoord;
  end;
end;

procedure Tf_config_observatory.ZoomImage1Paint(Sender: TObject);
var
  x, y: integer;
begin
  with ZoomImage1.Canvas do
  begin
    pen.Color := clred;
    brush.Style := bsClear;
    x := ZoomImage1.Wrld2ScrX(Obsposx);
    y := ZoomImage1.Wrld2ScrY(Obsposy);
    ellipse(x - 3, y - 3, x + 3, y + 3);
  end;
end;

procedure Tf_config_observatory.ZoomImage1PosChange(Sender: TObject);
begin
  if LockChange or lockscrollbar then
    exit;
  ScrollLock := True;
  Hscrollbar.Position := ZoomImage1.Xc;
  Vscrollbar.Position := ZoomImage1.Yc;
  application.ProcessMessages;
  ScrollLock := False;
end;

procedure Tf_config_observatory.HScrollBarScroll(Sender: TObject;
  ScrollCode: TScrollCode; var ScrollPos: integer);
begin
  if LockChange then
    exit;
  if scrolllock then
    exit;
  if lockscrollbar then
    exit;
  lockscrollbar := True;
  try
    ZoomImage1.Xcentre := HScrollBar.Position;
    ZoomImage1.Draw;
  finally
    lockscrollbar := False;
  end;
end;

procedure Tf_config_observatory.humidityChange(Sender: TObject);
begin
  if LockChange then
    exit;
  csc.ObsRH := humidity.Value / 100;
end;

procedure Tf_config_observatory.tlrateChange(Sender: TObject);
begin
  if LockChange then
    exit;
  csc.ObsTlr := tlrate.Value / 1000;
end;

procedure Tf_config_observatory.RefDefaultClick(Sender: TObject);
begin
  csc.ObsTlr := 0.0065;
  csc.ObsRH := 0.5;
  csc.ObsTemperature := 10;
  csc.ObsPressure := 1013;
  ShowObservatory;
end;

procedure Tf_config_observatory.VScrollBarScroll(Sender: TObject;
  ScrollCode: TScrollCode; var ScrollPos: integer);
begin
  if LockChange then
    exit;
  if scrolllock then
    exit;
  if lockscrollbar then
    exit;
  lockscrollbar := True;
  try
    ZoomImage1.Ycentre := VScrollBar.Position;
    ZoomImage1.Draw;
  finally
    lockscrollbar := False;
  end;
end;

procedure Tf_config_observatory.ObszpClick(Sender: TObject);
begin
  ZoomImage1.zoom := 1.5 * ZoomImage1.zoom;
  CenterObs;
end;

procedure Tf_config_observatory.ObszmClick(Sender: TObject);
begin
  ZoomImage1.zoom := ZoomImage1.zoom / 1.5;
  CenterObs;
end;

procedure Tf_config_observatory.ObsmapClick(Sender: TObject);
begin
  if fileexists(cmain.EarthMapFile) then
  begin
    opendialog1.InitialDir := extractfilepath(cmain.EarthMapFile);
    opendialog1.filename := extractfilename(cmain.EarthMapFile);
  end
  else
  begin
    opendialog1.InitialDir := slash(appdir) + 'data' + pathdelim + 'earthmap';
    opendialog1.filename := '';
  end;
  opendialog1.Filter := 'JPEG|*.jpg|PNG|*.png|BMP|*.bmp';
  opendialog1.DefaultExt := '.jpg';
  try
    if opendialog1.Execute and (fileexists(opendialog1.filename)) then
    begin
      cmain.EarthMapFile := opendialog1.filename;
      ZoomImage1.Xcentre := Obsposx;
      ZoomImage1.Ycentre := Obsposy;
      LoadMap(cmain.EarthMapFile);
      SetScrollBar;
      Hscrollbar.Position := ZoomImage1.SizeX div 2;
      Vscrollbar.Position := ZoomImage1.SizeY div 2;
      SetObsPos;
      CenterObs;
    end;
  finally
    chdir(appdir);
  end;
end;

procedure Tf_config_observatory.SetScrollBar;
var
  posmax: integer;
begin
  try
    ScrollLock := True;
    scrollw := round(ZoomImage1.Width / ZoomImage1.zoom / 2);
    posmax := max(scrollw, ZoomImage1.SizeX - scrollw);
    try
    Hscrollbar.SetParams(Hscrollbar.Position, scrollw, posmax, 1);
    Hscrollbar.LargeChange := scrollw;
    Hscrollbar.SmallChange := scrollw div 10;
    scrollh := round(ZoomImage1.Height / ZoomImage1.zoom / 2);
    posmax := max(scrollh, ZoomImage1.SizeY - scrollh);
    Vscrollbar.SetParams(Vscrollbar.Position, scrollh, posmax, 1);
    Vscrollbar.LargeChange := scrollh;
    Vscrollbar.SmallChange := scrollh div 10;
    except
    end;
  finally
    ScrollLock := False;
  end;
end;

procedure Tf_config_observatory.ShowHorizon;
begin
  horizonopaque.Checked := not csc.horizonopaque;
  horizonfile.Text := csc.horizonfile;
  if csc.horizonfile = '' then
    horizonfile.InitialDir := slash(HomeDir)
  else
    horizonfile.InitialDir := ExtractFilePath(csc.horizonfile);
  displayhorizon.Checked := csc.ShowHorizon;
  horizonpicturefile.Text := csc.HorizonPictureFile;
  if csc.HorizonPictureFile = '' then
    horizonpicturefile.InitialDir := slash(HomeDir)
  else
    horizonpicturefile.InitialDir := ExtractFilePath(csc.HorizonPictureFile);
  if uppercase(ExtractFileExt(csc.HorizonPictureFile)) = '.BMP' then
    horizonpicturefile.FilterIndex := 1
  else
    horizonpicturefile.FilterIndex := 0;
  displayhorizonpicture.Checked := csc.ShowHorizonPicture;
  HorizonQuality.Checked := not csc.HorizonPictureLowQuality;
  DarkenHorizon.Checked := csc.DarkenHorizonPicture;
  picturerotation.Value := csc.HorizonPictureRotate;
  pictureelevation.Value := csc.HorizonPictureElevation;
  fillhorizon.Checked := csc.FillHorizon;
  ShowHorizon0.Checked := csc.ShowHorizon0;
  HorizonRise.Checked := csc.HorizonRise;
  horizondepression.Checked := csc.ShowHorizonDepression;
  AirmassMagnitude.Checked := csc.AirmassMagnitude;
end;

procedure Tf_config_observatory.displayhorizonClick(Sender: TObject);
begin
  csc.ShowHorizon := displayhorizon.Checked;
  if csc.ShowHorizon then
    displayhorizonpicture.Checked := False;
end;

procedure Tf_config_observatory.fillhorizonClick(Sender: TObject);
begin
  csc.FillHorizon := fillhorizon.Checked;
end;

procedure Tf_config_observatory.ShowHorizon0Click(Sender: TObject);
begin
  csc.ShowHorizon0 := ShowHorizon0.Checked;
end;

procedure Tf_config_observatory.HorizonRiseClick(Sender: TObject);
begin
  csc.HorizonRise := HorizonRise.Checked;
end;

procedure Tf_config_observatory.horizondepressionClick(Sender: TObject);
begin
  csc.ShowHorizonDepression := horizondepression.Checked;
end;

procedure Tf_config_observatory.horizonopaqueClick(Sender: TObject);
begin
  csc.horizonopaque := not horizonopaque.Checked;
end;

procedure Tf_config_observatory.horizonfileAcceptFileName(Sender: TObject;
  var Value: string);
begin
  if LockChange then
    exit;
  csc.horizonfile := Value;
end;

procedure Tf_config_observatory.horizonfileChange(Sender: TObject);
begin
  if LockChange then
    exit;
  csc.horizonfile := horizonfile.Text;
end;

procedure Tf_config_observatory.horizonpicturefileAcceptFileName(Sender: TObject;
  var Value: string);
begin
  if LockChange then
    exit;
  csc.HorizonPictureFile := Value;
  GetPictureRotation;
end;

procedure Tf_config_observatory.horizonpicturefileChange(Sender: TObject);
begin
  if LockChange then
    exit;
  csc.HorizonPictureFile := horizonpicturefile.Text;
  GetPictureRotation;
end;

procedure Tf_config_observatory.HorizonQualityClick(Sender: TObject);
begin
  csc.HorizonPictureLowQuality := not HorizonQuality.Checked;
end;

procedure Tf_config_observatory.DarkenHorizonChange(Sender: TObject);
begin
  csc.DarkenHorizonPicture := DarkenHorizon.Checked;
end;

procedure Tf_config_observatory.pictureelevationChange(Sender: TObject);
begin
  csc.HorizonPictureElevation := pictureelevation.Value;
end;

procedure Tf_config_observatory.picturerotationChange(Sender: TObject);
begin
  csc.HorizonPictureRotate := picturerotation.Value;
end;

procedure Tf_config_observatory.GetPictureRotation;
var
  fn, lstype: string;
  rot: single;
  fconfig: TIniFile;
begin
  fn := slash(ExtractFilePath(csc.HorizonPictureFile)) + 'landscape.ini';
  if FileExists(fn) then
  begin
    fconfig := TIniFile.Create(fn);
    lstype := fconfig.ReadString('landscape', 'type', '');
    if lstype = 'spherical' then
    begin
      rot := fconfig.ReadFloat('landscape', 'angle_rotatez', 0);
      rot := rmod(rot + 360, 360);
      csc.HorizonPictureRotate := rot;
      picturerotation.Value := rot;
    end;
    fconfig.Free;
  end;

end;

end.
