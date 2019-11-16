unit fu_config_system;

{$MODE Delphi}{$H+}

{
Copyright (C) 2005 Patrick Chevalley

http://www.ap-i.net
pch@ap-i.net

This program is free software; you can redistribute it and/or
modify it under the terms of the GNU General Public License
as published by the Free Software Foundation; either version 2

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
  u_help, u_translation, u_constant, cu_database,
  indibaseclient, indibasedevice, indiapi,
  Dialogs, Controls, Buttons, enhedits, ComCtrls, Classes,
  LCLIntf, SysUtils, Graphics, Forms, LazUTF8, LazFileUtils, Math,
  ExtCtrls, StdCtrls, LResources, EditBtn, LazHelpHTML_fix, CheckLst, Types;

type

  { Tf_config_system }

  Tf_config_system = class(TFrame)
    IndiMsg: TLabel;
    INDILabel2: TLabel;
    LanguageList: TCheckListBox;
    ServerCoordSys: TRadioGroup;
    UseScaling: TCheckBox;
    CheckBox1: TCheckBox;
    GroupBox2: TGroupBox;
    InternalIndiGui: TCheckBox;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    CheckBox4: TCheckBox;
    CheckBox5: TCheckBox;
    CheckBox6: TCheckBox;
    CheckBox7: TCheckBox;
    CheckBox8: TCheckBox;
    CheckBox9: TCheckBox;
    InterfaceLabel: TLabel;
    InterfacePanel: TPanel;
    INDILabel: TLabel;
    ASCOMLabel: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    MysqlBoxLabel: TLabel;
    MysqlBox: TPanel;
    ASCOMPanel: TPanel;
    PageControl2: TPageControl;
    PageControl3: TPageControl;
    ExternalControlPanel: TPanel;
    SqliteBoxLabel: TLabel;
    SqliteBox: TPanel;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    TabSheet4: TTabSheet;
    TabSheet5: TTabSheet;
    TabSheet6: TTabSheet;
    Page5: TTabSheet;
    TelescopeManualLabel: TLabel;
    Label14: TLabel;
    Language: TTabSheet;
    Page1: TTabSheet;
    TelescopeManual: TPanel;
    INDI: TPanel;
    persdir: TDirectoryEdit;
    Label12: TLabel;
    LinuxCmd: TEdit;
    LinuxDesktopBox: TComboBox;
    GroupBoxLinux: TGroupBox;
    MainPanel: TPanel;
    Page3: TTabSheet;
    Page4: TTabSheet;
    Page2: TTabSheet;
    Label153: TLabel;
    Label77: TLabel;
    Label84: TLabel;
    Label85: TLabel;
    Label86: TLabel;
    Label133: TLabel;
    dbname: TEdit;
    dbport: TLongEdit;
    dbhost: TEdit;
    dbuser: TEdit;
    dbpass: TEdit;
    GroupBoxDir: TGroupBox;
    Label157: TLabel;
    GroupBox3: TGroupBox;
    Label54: TLabel;
    Label55: TLabel;
    UseIPserver: TCheckBox;
    ipaddr: TEdit;
    ipport: TEdit;
    keepalive: TCheckBox;
    Label13: TLabel;
    TelescopeSelect: TRadioGroup;
    GroupBox1: TGroupBox;
    chkdb: TButton;
    credb: TButton;
    dropdb: TButton;
    CometDB: TButton;
    AstDB: TButton;
    Label1: TLabel;
    dbnamesqlite: TEdit;
    DBtypeGroup: TRadioGroup;
    Label2: TLabel;
    PanelCmd: TEdit;
    Label7: TLabel;
    EquatorialMount: TPanel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    TurnsRa: TFloatEdit;
    TurnsDec: TFloatEdit;
    RevertTurnsRa: TCheckBox;
    RevertTurnDec: TCheckBox;
    ManualMountType: TRadioGroup;
    AltAzMount: TPanel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    TurnsAz: TFloatEdit;
    TurnsAlt: TFloatEdit;
    RevertTurnsAz: TCheckBox;
    RevertTurnsAlt: TCheckBox;
    PageControl1: TPageControl;
    procedure LanguageListItemClick(Sender: TObject; Index: integer);
    procedure PageControl1Changing(Sender: TObject; var AllowChange: boolean);
    procedure ServerCoordSysClick(Sender: TObject);
    procedure UseScalingChange(Sender: TObject);
    procedure CheckBox1Change(Sender: TObject);
    procedure CheckBox2Change(Sender: TObject);
    procedure CheckBox3Change(Sender: TObject);
    procedure CheckBox4Change(Sender: TObject);
    procedure CheckBox5Change(Sender: TObject);
    procedure CheckBox6Change(Sender: TObject);
    procedure CheckBox7Change(Sender: TObject);
    procedure CheckBox8Change(Sender: TObject);
    procedure CheckBox9Change(Sender: TObject);
    procedure InternalIndiGuiClick(Sender: TObject);
    procedure Label18Click(Sender: TObject);
    procedure LinuxCmdChange(Sender: TObject);
    procedure LinuxDesktopBoxChange(Sender: TObject);
    procedure dbnameChange(Sender: TObject);
    procedure dbhostChange(Sender: TObject);
    procedure dbportChange(Sender: TObject);
    procedure dbuserChange(Sender: TObject);
    procedure dbpassChange(Sender: TObject);
    procedure chkdbClick(Sender: TObject);
    procedure credbClick(Sender: TObject);
    procedure dropdbClick(Sender: TObject);
    procedure UseIPserverClick(Sender: TObject);
    procedure keepaliveClick(Sender: TObject);
    procedure ipaddrChange(Sender: TObject);
    procedure ipportChange(Sender: TObject);
    procedure TelescopeSelectClick(Sender: TObject);
    procedure persdirChange(Sender: TObject);
    procedure AstDBClick(Sender: TObject);
    procedure CometDBClick(Sender: TObject);
    procedure ActivateDBchange;
    procedure DBtypeGroupClick(Sender: TObject);
    procedure dbnamesqliteChange(Sender: TObject);
    procedure PanelCmdChange(Sender: TObject);
    procedure TurnsRaChange(Sender: TObject);
    procedure TurnsDecChange(Sender: TObject);
    procedure ManualMountTypeClick(Sender: TObject);
    procedure TurnsAzChange(Sender: TObject);
    procedure TurnsAltChange(Sender: TObject);
  private
    { Private declarations }
    FShowAsteroid: TNotifyEvent;
    FShowComet: TNotifyEvent;
    FLoadMPCSample: TNotifyEvent;
    FDBChange: TNotifyEvent;
    FSaveAndRestart: TNotifyEvent;
    FApplyConfig: TNotifyEvent;
    dbchanged, skipDBtypeGroupClick, LockChange, LockMsg: boolean;
    procedure ShowSYS;
    procedure ShowServer;
    procedure ShowTelescope;
    procedure ShowLanguage;
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
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Init; // FormShow
    procedure Lock; // FormClose
    procedure SetLang;
    property onShowAsteroid: TNotifyEvent read FShowAsteroid write FShowAsteroid;
    property onShowComet: TNotifyEvent read FShowComet write FShowComet;
    property onLoadMPCSample: TNotifyEvent read FLoadMPCSample write FLoadMPCSample;
    property onDBChange: TNotifyEvent read FDBChange write FDBChange;
    property onSaveAndRestart: TNotifyEvent read FSaveAndRestart write FSaveAndRestart;
    property onApplyConfig: TNotifyEvent read FApplyConfig write FApplyConfig;
  end;

implementation

uses u_util;

{$R *.lfm}

procedure Tf_config_system.SetLang;
begin
  Caption := rsGeneral;
  Page1.Caption := rsLanguage2;
  Page2.Caption := rsTelescope;
  Page3.Caption := rsGeneral;
  Page4.Caption := rsServer;
  Page5.Caption := 'SAMP';
  Label153.Caption := rsGeneralSetti;
  MysqlBoxLabel.Caption := rsMySQLDatabas;
  Label77.Caption := rsDBName;
  Label84.Caption := rsHostName;
  Label85.Caption := rsPort;
  Label86.Caption := rsUserid;
  Label133.Caption := rsPassword;
  SqliteBoxLabel.Caption := rsSqliteDataba;
  Label1.Caption := rsDatabaseFile;
  GroupBoxDir.Caption := rsDirectory;
  Label157.Caption := rsPersonalData;
  chkdb.Caption := rsCheck;
  credb.Caption := rsCreateDataba;
  dropdb.Caption := rsDropDatabase;
  CometDB.Caption := rsCometSetting;
  AstDB.Caption := rsAsteroidSett;
  DBtypeGroup.Caption := rsDatabaseType;
  DBtypeGroup.Hint := rsWarning + crlf + rsChangeToThis;
  GroupBoxLinux.Caption := rsDesktopEnvir;
  Label12.Caption := rsURLLaunchCom;
  GroupBox2.Caption := rsScreenResolu;
  UseScaling.Caption := rsAdjustTheWin;
  UseScaling.Hint := rsWarning + crlf + rsChangeToThis;
  LinuxDesktopBox.items[1] := rsOther;
  GroupBox3.Caption := rsTCPIPServer;
  Label54.Caption := rsServerIPInte;
  Label55.Caption := rsServerIPPort;
  UseIPserver.Caption := rsUseTCPIPServ;
  keepalive.Caption := rsClientConnec;
  ServerCoordSys.Caption:=rsCooordinateS;
  Label13.Caption := rsTelescopeSet;
  TelescopeManualLabel.Caption := rsManualMount;
  Label7.Caption := rsSetHowTheMou;
  Label3.Caption := rsRightAscensi;
  Label4.Caption := rsDeclination;
  Label5.Caption := rsTurnsHour;
  Label6.Caption := rsTurnsDegree;
  RevertTurnsRa.Caption := rsRevertRAKnob;
  RevertTurnDec.Caption := rsRevertDECKno;
  Label8.Caption := rsAzimuth;
  Label9.Caption := rsAltitude;
  Label10.Caption := rsTurnsDegree;
  Label11.Caption := rsTurnsDegree;
  RevertTurnsAz.Caption := rsRevertAzKnob;
  RevertTurnsAlt.Caption := rsRevertAltKno;
  INDILabel.Caption := rsINDIDriverSe;
  INDILabel2.Caption := Format(rsUseTheMenuOr, [rsConnectTeles]);
  Label2.Caption := rsControlPanel2;
  InternalIndiGui.Caption:=rsUseTheIntern;
  Label14.Caption := rsLanguageSele;
  ManualMountType.Items[0] := rsEquatorialMo;
  ManualMountType.Items[1] := rsAltAzMount;
  TelescopeSelect.Caption := rsSelectTheTel;
  TelescopeSelect.Items[0] := rsINDIDriver;
  TelescopeSelect.Items[1] := rsManualMount;
  TelescopeSelect.Items[2] := 'ASCOM';
  label15.Caption := rsVOSAMPSettin;
  label16.Caption := Format(rsSAMPIsAMessa, [crlf]);
  label17.Caption := rsForMoreInfor;
  label18.Caption := URL_IVOASAMP;
  CheckBox1.Caption := rsAskForConfir;
  CheckBox2.Caption := rsAskForConfir2;
  CheckBox3.Caption := rsAskForConfir3;
  CheckBox4.Caption := rsReceiveCoord;
  CheckBox5.Caption := rsReceiveFITSI;
  CheckBox6.Caption := rsReceiveVOTab;
  CheckBox7.Caption := rsTryToAutoCon;
  CheckBox8.Caption := rsKeepTablesOn;
  CheckBox9.Caption := rsKeepImagesOn;
  ASCOMLabel.Caption := rsASCOMTelesc + crlf + Format(rsUseTheMenuOr, [rsConnectTeles]);
  {$ifndef mswindows}
  ASCOMLabel.Caption := ASCOMLabel.Caption + crlf + crlf + Format(rsASCOMRemote, [compile_system]);
  {$endif}
  InterfaceLabel.Caption := rsObsolete + crlf + crlf + rsIntTelesco + crlf + crlf +
    rsThisDirectDr + crlf + crlf + Format(rsUseTheMenuOr, [rsConnectTeles]);
  SetHelp(self, hlpCfgSys);
end;

constructor Tf_config_system.Create(AOwner: TComponent);
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
  LockMsg := False;
end;

destructor Tf_config_system.Destroy;
begin
  mycsc.Free;
  myccat.Free;
  mycshr.Free;
  mycplot.Free;
  mycmain.Free;
  inherited Destroy;
end;

procedure Tf_config_system.ActivateDBchange;
begin
  if dbchanged and Assigned(FDBChange) then
    FDBChange(self);
end;

procedure Tf_config_system.Init;
begin
  LockChange := True;
  dbchanged := False;
  IndiMsg.Caption:='';
{$if defined(mswindows) or defined(darwin)}
  GroupBoxLinux.Visible := False;
{$endif}
  ShowLanguage;
  ShowSYS;
  ShowServer;
  ShowTelescope;
  LockChange := False;
end;

procedure Tf_config_system.ShowLanguage;
var
  i: integer;
  f: textfile;
  dir, buf, buf1, buf2: string;
begin
  LanguageList.Clear;
  GetDefaultLanguage(buf1, buf2);
  LanguageList.Items.Add(blank + rsDefault + ' (' + buf1 + ')');
  LanguageList.ItemIndex := 0;
  dir := slash(appdir) + slash('data') + slash('language');
  if not fileexists(dir + 'skychart.lang') then
    writetrace('File ' + dir + 'skychart.lang' + ' not found!');
  try
    Filemode := 0;
    AssignFile(f, dir + 'skychart.lang');
    Reset(f);
    repeat
      Readln(f, buf);
      buf1 := words(buf, '', 1, 1);
      buf2 := CondUTF8Decode(words(buf, '', 2, 1));
      if fileexists(dir + 'skychart.' + buf1 + '.po') then
      begin
        LanguageList.items.Add(buf1 + blank + '-' + blank + buf2);
      end
      else
        writetrace('  file not found: ' + dir + 'skychart.' + buf1 + '.po');
    until EOF(f);
    CloseFile(f);
  except
  end;
  for i := 0 to LanguageList.Items.Count - 1 do
  begin
    LanguageList.Checked[i] := (((cmain.language = '') and (i = 0)) or
      (cmain.language = words(LanguageList.Items[i], '', 1, 1)));
    if LanguageList.Checked[i] then
    begin
      LanguageList.Selected[i] := True;
      LanguageList.TopIndex := i;
    end;
  end;
end;

procedure Tf_config_system.ShowSYS;
begin
  skipDBtypeGroupClick := True;
  case DBtype of
    sqlite:
    begin
      DBtypeGroup.ItemIndex := 0;
      MysqlBox.Visible := True;
      MysqlBox.Visible := False;
      SqliteBox.Visible := False;
      SqliteBox.Visible := True;
      dropdb.Visible := False;
    end;
    mysql:
    begin
      DBtypeGroup.ItemIndex := 1;
      MysqlBox.Visible := False;
      MysqlBox.Visible := True;
      SqliteBox.Visible := True;
      SqliteBox.Visible := False;
      dropdb.Visible := True;
    end;
  end;
  skipDBtypeGroupClick := False;
  dbnamesqlite.Text := SysToUTF8(cmain.db);
  dbname.Text := cmain.db;
  dbhost.Text := cmain.dbhost;
  dbport.Value := cmain.dbport;
  dbuser.Text := cmain.dbuser;
  dbpass.Text := cmain.dbpass;
  persdir.Text := SysToUTF8(cmain.persdir);
  UseScaling.Checked := cmain.ScreenScaling;
{$if defined(linux) or defined(freebsd)}
  LinuxDesktopBox.ItemIndex := min(1, LinuxDesktop);
  LinuxCmd.Text := OpenFileCMD;
  if LinuxDesktopBox.ItemIndex < 1 then
    LinuxCmd.Enabled := False;
{$endif}
end;

procedure Tf_config_system.ShowServer;
begin
  ipaddr.Text := cmain.ServerIPaddr;
  ipport.Text := cmain.ServerIPport;
  useipserver.Checked := cmain.autostartserver;
  ServerCoordSys.ItemIndex:=cmain.ServerCoordSys;
  keepalive.Checked := cmain.keepalive;
  CheckBox1.Checked := cmain.SampConfirmCoord;
  CheckBox2.Checked := cmain.SampConfirmImage;
  CheckBox3.Checked := cmain.SampConfirmTable;
  CheckBox4.Checked := cmain.SampSubscribeCoord;
  CheckBox5.Checked := cmain.SampSubscribeImage;
  CheckBox6.Checked := cmain.SampSubscribeTable;
  CheckBox7.Checked := cmain.SampAutoconnect;
  CheckBox8.Checked := cmain.SampKeepTables;
  CheckBox9.Checked := cmain.SampKeepImages;
  CheckBox1.Enabled := cmain.SampSubscribeCoord;
  CheckBox2.Enabled := cmain.SampSubscribeImage;
  CheckBox9.Enabled := cmain.SampSubscribeImage;
  CheckBox3.Enabled := cmain.SampSubscribeTable;
  CheckBox8.Enabled := cmain.SampSubscribeTable;
end;

procedure Tf_config_system.ShowTelescope;
begin
  InternalIndiGui.Checked := cmain.InternalIndiPanel;
  PanelCmd.Text := cmain.IndiPanelCmd;
  ExternalControlPanel.Visible := (not cmain.InternalIndiPanel);
  TurnsRa.Value := abs(csc.TelescopeTurnsX);
  TurnsDec.Value := abs(csc.TelescopeTurnsY);
  RevertTurnsRa.Checked := csc.TelescopeTurnsX < 0;
  RevertTurnDec.Checked := csc.TelescopeTurnsY < 0;
  TurnsAz.Value := abs(csc.TelescopeTurnsX);
  TurnsAlt.Value := abs(csc.TelescopeTurnsY);
  RevertTurnsAz.Checked := csc.TelescopeTurnsX < 0;
  RevertTurnsAlt.Checked := csc.TelescopeTurnsY < 0;
  ManualMountType.ItemIndex := csc.ManualTelescopeType;
  ManualMountTypeClick(nil);
  if csc.IndiTelescope then
    Telescopeselect.ItemIndex := 0
  else if csc.ASCOMTelescope then
    Telescopeselect.ItemIndex := 2
  else
    Telescopeselect.ItemIndex := 1;
  TelescopeselectClick(self);
end;

procedure Tf_config_system.DBtypeGroupClick(Sender: TObject);
var
  dbpath: string;
begin
  if skipDBtypeGroupClick then
  begin
    skipDBtypeGroupClick := False;
    exit;
  end;

  if DBtypeGroup.ItemIndex>0 then begin
     ShowMessage('Mysql support is deprecated and will be removed in a future version');
     skipDBtypeGroupClick:=True;
     DBtypeGroup.ItemIndex:=0;
     exit;
  end;

  if messageDlg(Format(rsAlsoBeSureTh, [DBtypeGroup.hint + crlf + crlf, crlf, crlf]),
    mtConfirmation, [mbYes, mbNo], 0) = mrYes then
  begin
    case DBtypeGroup.ItemIndex of
      0:
      begin
        DBtype := sqlite;
        MysqlBox.Visible := False;
        SqliteBox.Visible := True;
        dbnamesqlite.Text := SysToUTF8(slash(dbdir) + defaultSqliteDB);
        dbpath := extractfilepath(dbnamesqlite.Text);
        if not directoryexists(dbpath) then
          CreateDir(dbpath);
        if not directoryexists(dbpath) then
          forcedirectories(dbpath);
      end;
      1:
      begin
        DBtype := mysql;
        MysqlBox.Visible := True;
        SqliteBox.Visible := False;
        dbname.Text := defaultMySqlDB;
      end;
    end;
    if Assigned(FSaveAndRestart) then
      FSaveAndRestart(self);
  end
  else
  begin
    skipDBtypeGroupClick := True;
    case DBtype of
      sqlite: DBtypeGroup.ItemIndex := 0;
      mysql: DBtypeGroup.ItemIndex := 1;
    end;
  end;
end;

procedure Tf_config_system.dbnamesqliteChange(Sender: TObject);
begin
  if LockChange then
    exit;
  cmain.db := utf8tosys(dbnamesqlite.Text);
end;

procedure Tf_config_system.dbnameChange(Sender: TObject);
begin
  if LockChange then
    exit;
  if cmain.db <> dbname.Text then
    dbchanged := True;
  cmain.db := dbname.Text;
end;

procedure Tf_config_system.dbhostChange(Sender: TObject);
begin
  if LockChange then
    exit;
  if cmain.dbhost <> dbhost.Text then
    dbchanged := True;
  cmain.dbhost := dbhost.Text;
end;

procedure Tf_config_system.dbportChange(Sender: TObject);
begin
  if LockChange then
    exit;
  if cmain.dbport <> dbport.Value then
    dbchanged := True;
  cmain.dbport := dbport.Value;
end;

procedure Tf_config_system.dbuserChange(Sender: TObject);
begin
  if LockChange then
    exit;
  if cmain.dbuser <> dbuser.Text then
    dbchanged := True;
  cmain.dbuser := dbuser.Text;
end;

procedure Tf_config_system.dbpassChange(Sender: TObject);
begin
  if LockChange then
    exit;
  if cmain.dbpass <> dbpass.Text then
    dbchanged := True;
  cmain.dbpass := dbpass.Text;
end;

procedure Tf_config_system.chkdbClick(Sender: TObject);
var
  msg: string;
begin
  msg := cdb.checkdbconfig(cmain);
  ShowMessage(msg);
end;

procedure Tf_config_system.credbClick(Sender: TObject);
var
  ok: boolean;
begin
  screen.cursor := crHourGlass;
  cdb.createdb(cmain, ok);
  if ok then
  begin
    // signal new database
    if Assigned(FDBChange) then
      FDBChange(self);
    // load sample data
    if Assigned(FLoadMPCSample) then
      FLoadMPCSample(self);
  end;
  screen.cursor := crDefault;
  chkdbClick(Sender);
end;

procedure Tf_config_system.dropdbClick(Sender: TObject);
var
  msg: string;
begin
  if messagedlg(Format(rsWarningYouAr, [crlf, cmain.db, crlf]),
    mtWarning, [mbYes, mbNo], 0) = mrYes then
  begin
    msg := cdb.dropdb(cmain);
    if msg <> '' then
      ShowMessage(msg);
    // signal database no more exists
    if Assigned(FDBChange) then
      FDBChange(self);
  end;
end;

procedure Tf_config_system.AstDBClick(Sender: TObject);
begin
  if Assigned(FShowAsteroid) then
    FShowAsteroid(self);
end;

procedure Tf_config_system.CometDBClick(Sender: TObject);
begin
  if Assigned(FShowComet) then
    FShowComet(self);
end;

procedure Tf_config_system.persdirChange(Sender: TObject);
begin
  if LockChange then
    exit;
  cmain.persdir := utf8tosys(persdir.Text);
  dbnamesqlite.Text := systoutf8(slash(cmain.persdir) + slash('database') + 'cdc.db');
  dbchanged := True;
end;

procedure Tf_config_system.UseScalingChange(Sender: TObject);
begin
  if LockChange then
    exit;
  if messageDlg(rsWarning + crlf + rsChangeToThis, mtConfirmation,
    [mbYes, mbNo], 0) = mrYes then
  begin
    cmain.ScreenScaling := UseScaling.Checked;
    if Assigned(FSaveAndRestart) then
      FSaveAndRestart(self);
  end
  else
  begin
    LockChange := True;
    UseScaling.Checked := not UseScaling.Checked;
    LockChange := False;
  end;
end;

procedure Tf_config_system.PageControl1Changing(Sender: TObject;
  var AllowChange: boolean);
begin
  if parent is TForm then
    TForm(Parent).ActiveControl := PageControl1;
end;

procedure Tf_config_system.LinuxDesktopBoxChange(Sender: TObject);
begin
  if LockChange then
    exit;
  case LinuxDesktopBox.ItemIndex of
    0:
    begin  // FreeDesktop.org
      LinuxCmd.Text := 'xdg-open';
      LinuxCmd.Enabled := False;
    end;
    1:
    begin  // Other
      LinuxCmd.Enabled := True;
    end;
  end;
  LinuxDesktop := LinuxDesktopBox.ItemIndex;
end;

procedure Tf_config_system.LinuxCmdChange(Sender: TObject);
begin
  if LockChange then
    exit;
  OpenFileCMD := LinuxCmd.Text;
end;

procedure Tf_config_system.InternalIndiGuiClick(Sender: TObject);
begin
  cmain.InternalIndiPanel := InternalIndiGui.Checked;
  ExternalControlPanel.Visible := (not cmain.InternalIndiPanel);
end;

procedure Tf_config_system.Label18Click(Sender: TObject);
begin
  ExecuteFile(Label18.Caption);
end;

procedure Tf_config_system.LanguageListItemClick(Sender: TObject; Index: integer);
var
  i: integer;
begin
  if LockChange then
    exit;
  if LeftStr(LanguageList.Items[Index], 1) = blank then
    cmain.language := ''
  else
    cmain.language := words(LanguageList.Items[Index], '', 1, 1);
  for i := 0 to LanguageList.Items.Count - 1 do
  begin
    LanguageList.Checked[i] := (((cmain.language = '') and (i = 0)) or
      (cmain.language = words(LanguageList.Items[i], '', 1, 1)));
    if LanguageList.Checked[i] then
    begin
      LanguageList.Selected[i] := True;
    end;
  end;
end;

procedure Tf_config_system.Lock;
begin
  LockChange := True;
end;

procedure Tf_config_system.CheckBox1Change(Sender: TObject);
begin
  cmain.SampConfirmCoord := CheckBox1.Checked;
end;

procedure Tf_config_system.CheckBox2Change(Sender: TObject);
begin
  cmain.SampConfirmImage := CheckBox1.Checked;
end;

procedure Tf_config_system.CheckBox3Change(Sender: TObject);
begin
  cmain.SampConfirmTable := CheckBox1.Checked;
end;

procedure Tf_config_system.CheckBox4Change(Sender: TObject);
begin
  cmain.SampSubscribeCoord := CheckBox4.Checked;
  CheckBox1.Enabled := cmain.SampSubscribeCoord;
end;

procedure Tf_config_system.CheckBox5Change(Sender: TObject);
begin
  cmain.SampSubscribeImage := CheckBox5.Checked;
  CheckBox2.Enabled := cmain.SampSubscribeImage;
  CheckBox9.Enabled := cmain.SampSubscribeImage;
end;

procedure Tf_config_system.CheckBox6Change(Sender: TObject);
begin
  cmain.SampSubscribeTable := CheckBox6.Checked;
  CheckBox3.Enabled := cmain.SampSubscribeTable;
  CheckBox8.Enabled := cmain.SampSubscribeTable;
end;

procedure Tf_config_system.CheckBox7Change(Sender: TObject);
begin
  cmain.SampAutoconnect := CheckBox7.Checked;
end;

procedure Tf_config_system.CheckBox8Change(Sender: TObject);
begin
  cmain.SampKeepTables := CheckBox8.Checked;
end;

procedure Tf_config_system.CheckBox9Change(Sender: TObject);
begin
  cmain.SampKeepImages := CheckBox9.Checked;
end;

procedure Tf_config_system.UseIPserverClick(Sender: TObject);
begin
  cmain.AutostartServer := UseIPserver.Checked;
end;

procedure Tf_config_system.keepaliveClick(Sender: TObject);
begin
  cmain.keepalive := keepalive.Checked;
end;

procedure Tf_config_system.ipaddrChange(Sender: TObject);
begin
  if LockChange then
    exit;
  cmain.ServerIPaddr := ipaddr.Text;
end;

procedure Tf_config_system.ipportChange(Sender: TObject);
begin
  if LockChange then
    exit;
  cmain.ServerIPport := ipport.Text;
end;

procedure Tf_config_system.ServerCoordSysClick(Sender: TObject);
begin
  if LockChange then
    exit;
  cmain.ServerCoordSys := ServerCoordSys.ItemIndex;
end;

procedure Tf_config_system.TelescopeSelectClick(Sender: TObject);
begin
  csc.IndiTelescope := Telescopeselect.ItemIndex = 0;
  csc.ManualTelescope := Telescopeselect.ItemIndex = 1;
  csc.ASCOMTelescope := Telescopeselect.ItemIndex = 2;
  if csc.IndiTelescope then
    PageControl2.ActivePage := TabSheet1;
  if csc.ManualTelescope then
    PageControl2.ActivePage := TabSheet2;
  if csc.ASCOMTelescope then
    PageControl2.ActivePage := TabSheet4;
end;

procedure Tf_config_system.PanelCmdChange(Sender: TObject);
begin
  if LockChange then
    exit;
  cmain.IndiPanelCmd := PanelCmd.Text;
end;

procedure Tf_config_system.TurnsRaChange(Sender: TObject);
begin
  if LockChange then
    exit;
  if RevertTurnsRa.Checked then
    csc.TelescopeTurnsX := -TurnsRa.Value
  else
    csc.TelescopeTurnsX := TurnsRa.Value;
end;

procedure Tf_config_system.TurnsDecChange(Sender: TObject);
begin
  if LockChange then
    exit;
  if RevertTurnDec.Checked then
    csc.TelescopeTurnsY := -TurnsDec.Value
  else
    csc.TelescopeTurnsY := TurnsDec.Value;
end;

procedure Tf_config_system.TurnsAzChange(Sender: TObject);
begin
  if LockChange then
    exit;
  if RevertTurnsAz.Checked then
    csc.TelescopeTurnsX := -TurnsAz.Value
  else
    csc.TelescopeTurnsX := TurnsAz.Value;
end;

procedure Tf_config_system.TurnsAltChange(Sender: TObject);
begin
  if LockChange then
    exit;
  if RevertTurnsAlt.Checked then
    csc.TelescopeTurnsY := -TurnsAlt.Value
  else
    csc.TelescopeTurnsY := TurnsAlt.Value;
end;

procedure Tf_config_system.ManualMountTypeClick(Sender: TObject);
begin
  csc.ManualTelescopeType := ManualMountType.ItemIndex;
  case csc.ManualTelescopeType of
    0:
    begin
      PageControl3.ActivePage := TabSheet5;
      TurnsDecChange(Sender);
      TurnsRaChange(Sender);
    end;
    1:
    begin
      PageControl3.ActivePage := TabSheet6;
      TurnsAzChange(Sender);
      TurnsAltChange(Sender);
    end;
  end;
end;

end.
