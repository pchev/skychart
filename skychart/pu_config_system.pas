unit pu_config_system;

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

uses u_help, u_translation, u_constant, u_util, cu_database,
  Dialogs, Controls, Buttons, enhedits, ComCtrls, Classes,
  LCLIntf, SysUtils, Graphics, Forms, FileUtil,
  ExtCtrls, StdCtrls, LResources, EditBtn, LazHelpHTML;

type

  { Tf_config_system }

  Tf_config_system = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    INDILabel: TLabel;
    ASCOMLabel: TLabel;
    MysqlBoxLabel: TLabel;
    MysqlBox: TPanel;
    ASCOMPanel: TPanel;
    SqliteBoxLabel: TLabel;
    SqliteBox: TPanel;
    TelescopeManualLabel: TLabel;
    TelescopePluginLabel: TLabel;
    LanguageList: TComboBox;
    Label14: TLabel;
    Language: TPage;
    Page4: TPage;
    Panel1: TPanel;
    TelescopeManual: TPanel;
    INDI: TPanel;
    TelescopePlugin: TPanel;
    prgdir: TDirectoryEdit;
    persdir: TDirectoryEdit;
    Label12: TLabel;
    LinuxCmd: TEdit;
    LinuxDesktopBox: TComboBox;
    GroupBoxLinux: TGroupBox;
    MainPanel: TPanel;
    Page1: TPage;
    Page2: TPage;
    Page3: TPage;
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
    Label156: TLabel;
    Label157: TLabel;
    GroupBox3: TGroupBox;
    Label54: TLabel;
    Label55: TLabel;
    UseIPserver: TCheckBox;
    ipaddr: TEdit;
    ipport: TEdit;
    keepalive: TCheckBox;
    Label13: TLabel;
    Label75: TLabel;
    Label130: TLabel;
    Label258: TLabel;
    Label259: TLabel;
    Label260: TLabel;
    Label261: TLabel;
    IndiServerHost: TEdit;
    IndiServerPort: TEdit;
    IndiAutostart: TCheckBox;
    IndiServerCmd: TEdit;
    IndiDriver: TEdit;
    IndiDev: TComboBox;
    IndiPort: TComboBox;
    TelescopeSelect: TRadioGroup;
    Label155: TLabel;
    telescopepluginlist: TComboBox;
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
    Notebook1: TNotebook;
    procedure Button2Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure LanguageListSelect(Sender: TObject);
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
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure UseIPserverClick(Sender: TObject);
    procedure keepaliveClick(Sender: TObject);
    procedure ipaddrChange(Sender: TObject);
    procedure ipportChange(Sender: TObject);
    procedure IndiServerHostChange(Sender: TObject);
    procedure IndiServerPortChange(Sender: TObject);
    procedure IndiAutostartClick(Sender: TObject);
    procedure IndiServerCmdChange(Sender: TObject);
    procedure IndiDevChange(Sender: TObject);
    procedure IndiDriverChange(Sender: TObject);
    procedure IndiPortChange(Sender: TObject);
    procedure TelescopeSelectClick(Sender: TObject);
    procedure telescopepluginlistChange(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure prgdirChange(Sender: TObject);
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
    dbchanged,skipDBtypeGroupClick,LockChange: boolean;
    procedure ShowSYS;
    procedure ShowServer;
    procedure ShowTelescope;
    procedure ShowLanguage;
  public
    { Public declarations }
    cdb:Tcdcdb;
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
    constructor Create(AOwner:TComponent); override;
    procedure SetLang;
    property onShowAsteroid: TNotifyEvent read FShowAsteroid write FShowAsteroid;
    property onShowComet: TNotifyEvent read FShowComet write FShowComet;
    property onLoadMPCSample: TNotifyEvent read FLoadMPCSample write FLoadMPCSample;
    property onDBChange: TNotifyEvent read FDBChange write FDBChange;
    property onSaveAndRestart: TNotifyEvent read FSaveAndRestart write FSaveAndRestart;
    property onApplyConfig: TNotifyEvent read FApplyConfig write FApplyConfig;
  end;

implementation

procedure Tf_config_system.SetLang;
begin
Caption:=rsSystem;
Page1.caption:=rsSystem;
Page2.caption:=rsServer;
Page3.caption:=rsTelescope;
Page4.caption:=rsLanguage2;
Label153.caption:=rsSystemSettin;
MysqlBoxLabel.caption:=rsMySQLDatabas;
Label77.caption:=rsDBName;
Label84.caption:=rsHostName;
Label85.caption:=rsPort;
Label86.caption:=rsUserid;
Label133.caption:=rsPassword;
SqliteBoxLabel.caption:=rsSqliteDataba;
Label1.caption:=rsDatabaseFile;
GroupBoxDir.caption:=rsDirectory;
Label156.caption:=rsProgramData;
Label157.caption:=rsPersonalData;
chkdb.caption:=rsCheck;
credb.caption:=rsCreateDataba;
dropdb.caption:=rsDropDatabase;
CometDB.caption:=rsCometSetting;
AstDB.caption:=rsAsteroidSett;
DBtypeGroup.caption:=rsDatabaseType;
DBtypeGroup.Hint:=rsWarning+crlf+rsChangeToThis;
GroupBoxLinux.caption:=rsDesktopEnvir;
Label12.caption:=rsURLLaunchCom;
LinuxDesktopBox.items[3]:=rsOther;
GroupBox3.caption:=rsTCPIPServer;
Label54.caption:=rsServerIPInte;
Label55.caption:=rsServerIPPort;
UseIPserver.caption:=rsUseTCPIPServ;
keepalive.caption:=rsClientConnec;
Label13.caption:=rsTelescopeSet;
TelescopeManualLabel.caption:=rsManualMount;
Label7.caption:=rsSetHowTheMou;
Label3.caption:=rsRightAscensi;
Label4.caption:=rsDeclination;
Label5.caption:=rsTurnsHour;
Label6.caption:=rsTurnsDegree;
RevertTurnsRa.caption:=rsRevertRAKnob;
RevertTurnDec.caption:=rsRevertDECKno;
Label8.caption:=rsAzimuth;
Label9.caption:=rsAltitude;
Label10.caption:=rsTurnsDegree;
Label11.caption:=rsTurnsDegree;
RevertTurnsAz.caption:=rsRevertAzKnob;
RevertTurnsAlt.caption:=rsRevertAltKno;
TelescopePluginLabel.caption:=rsCDCPluginSet;
Label155.caption:=rsTelescopePlu;
INDILabel.caption:=rsINDIDriverSe;
Label75.caption:=rsINDIServerHo;
Label130.caption:=rsINDIServerPo;
Label258.caption:=rsServerComman;
Label259.caption:=rsDriverName;
Label260.caption:=rsTelescopeTyp;
Label261.caption:=rsDevicePort;
Label2.caption:=rsControlPanel2;
IndiAutostart.caption:=rsAutomaticall;
Label14.caption:=rsLanguageSele;
ManualMountType.Items[0]:=rsEquatorialMo;
ManualMountType.Items[1]:=rsAltAzMount;
TelescopeSelect.Caption:=rsSelectTheTel;
TelescopeSelect.Items[0]:=rsINDIDriver;
TelescopeSelect.Items[1]:=rsManualMount;
{$ifdef mswindows}
TelescopeSelect.Items[2]:=rsCDCPlugin;
{$endif}
ASCOMLabel.Caption:=rsASCOMTelesco+crlf+Format(rsUseTheMenuOr, [rsConnectTeles]);
Button1.caption:=rsOK;
Button2.caption:=rsApply;
Button3.caption:=rsCancel;
Button4.caption:=rsHelp;
SetHelp(self,hlpCfgSys);
end;

constructor Tf_config_system.Create(AOwner:TComponent);
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

procedure Tf_config_system.ActivateDBchange;
begin
 if dbchanged and Assigned(FDBChange) then FDBChange(self);
end;

procedure Tf_config_system.FormShow(Sender: TObject);
begin
LockChange:=true;
dbchanged:=false;
{$if defined(mswindows) or defined(darwin)}
  GroupBoxLinux.Visible:=false;
{$endif}
{$ifdef unix}
  if TelescopeSelect.Items.Count=4 then TelescopeSelect.Items.Delete(3);
  if TelescopeSelect.Items.Count=3 then TelescopeSelect.Items.Delete(2);
  Indiport.Style:= csSimple;
  IndiPort.Items.Clear;
  IndiPort.OnChange:=IndiPortChange;
  IndiPort.OnSelect:=nil;
{$endif}
ShowLanguage;
ShowSYS;
ShowServer;
ShowTelescope;
LockChange:=false;
end;

procedure Tf_config_system.ShowLanguage;
var i: integer;
    f: textfile;
    dir,buf,buf1,buf2: string;
begin
LanguageList.clear;
GetDefaultLanguage(buf1,buf2);
LanguageList.Items.Add(blank+rsDefault+' ('+buf1+')');
LanguageList.itemindex:=0;
dir:=slash(appdir)+slash('data')+slash('language');
if not fileexists(dir+'skychart.lang') then
   writetrace('File '+dir+'skychart.lang'+' not found!');
try
Filemode:=0;
AssignFile(f,dir+'skychart.lang');
Reset(f);
repeat
  Readln(f,buf);
  buf1:=words(buf,'',1,1);
  buf2:=CondUTF8Decode(words(buf,'',2,1));
  if fileexists(dir+'skychart.'+buf1+'.po') then begin
     LanguageList.items.Add(buf1+blank+'-'+blank+buf2);
  end
  else
     writetrace('  file not found: '+dir+'skychart.'+buf1+'.po');
until eof(f);
CloseFile(f);
except
end;
//application.ProcessMessages;
for i:=0 to LanguageList.Items.Count-1 do begin
  if cmain.language=words(LanguageList.Items[i],'',1,1) then LanguageList.itemindex:=i;
end;
end;

procedure Tf_config_system.ShowSYS;
begin
skipDBtypeGroupClick:=true;
case DBtype of
 sqlite : begin
           DBtypeGroup.itemindex:=0;
           MysqlBox.visible:=false;
           SqliteBox.visible:=true;
           dropdb.visible:=false;
          end;
 mysql :  begin
           DBtypeGroup.itemindex:=1;
           MysqlBox.visible:=true;
           SqliteBox.visible:=false;
           dropdb.visible:=true;
          end;
end;
skipDBtypeGroupClick:=false;
dbnamesqlite.Text:=SysToUTF8(cmain.db);
dbname.Text:=cmain.db;
dbhost.Text:=cmain.dbhost;
dbport.value:=cmain.dbport;
dbuser.Text:=cmain.dbuser;
dbpass.Text:=cmain.dbpass;
prgdir.text:=SysToUTF8(cmain.prgdir);
persdir.text:=SysToUTF8(cmain.persdir);
{$ifdef linux}
LinuxDesktopBox.itemIndex:=LinuxDesktop;
LinuxCmd.Text:=OpenFileCMD;
if LinuxDesktopBox.itemIndex<>3 then LinuxCmd.Enabled:=false;
{$endif}
end;

procedure Tf_config_system.ShowServer;
begin
ipaddr.text:=cmain.ServerIPaddr;
ipport.text:=cmain.ServerIPport;
useipserver.checked:=cmain.autostartserver;
keepalive.checked:=cmain.keepalive;
end;

procedure Tf_config_system.ShowTelescope;
var i:integer;
{$ifdef mswindows}
    n:integer;
    fs : TSearchRec;
    buf : string;
{$endif}
begin
IndiServerHost.text:=csc.IndiServerHost;
IndiServerPort.text:=csc.IndiServerPort;
IndiAutostart.checked:=csc.IndiAutostart;
IndiServerCmd.text:=csc.IndiServerCmd;
IndiDriver.text:=csc.IndiDriver;
PanelCmd.text:=cmain.IndiPanelCmd;
TurnsRa.value:=abs(csc.TelescopeTurnsX);
TurnsDec.value:=abs(csc.TelescopeTurnsY);
RevertTurnsRa.checked:=csc.TelescopeTurnsX<0;
RevertTurnDec.checked:=csc.TelescopeTurnsY<0;
TurnsAz.value:=abs(csc.TelescopeTurnsX);
TurnsAlt.value:=abs(csc.TelescopeTurnsY);
RevertTurnsAz.checked:=csc.TelescopeTurnsX<0;
RevertTurnsAlt.checked:=csc.TelescopeTurnsY<0;
ManualMountType.itemindex:=csc.ManualTelescopeType;
ManualMountTypeClick(nil);
if csc.IndiTelescope then Telescopeselect.itemindex:=0
   {$ifdef mswindows}
   else if csc.ASCOMTelescope then Telescopeselect.itemindex:=3
   else if csc.PluginTelescope then Telescopeselect.itemindex:=2
   {$endif}
   else Telescopeselect.itemindex:=1;
TelescopeselectClick(self);
{$ifdef unix}
IndiPort.text:=csc.IndiPort;
{$endif}
{$ifdef mswindows}
val(rightstr(csc.IndiPort,1),i,n);
if n=0 then IndiPort.itemindex:=i
       else IndiPort.itemindex:=0;
i:=findfirst(slash(appdir)+slash('plugins')+slash('telescope')+'*.tid',0,fs);
telescopepluginlist.clear;
n:=0;
while i=0 do begin
  buf:=extractfilename(fs.name);
  telescopepluginlist.items.Add(buf);
  if csc.ScopePlugin=buf then telescopepluginlist.itemindex:=n;
  inc(n);
  i:=findnext(fs);
end;
findclose(fs);
{$endif}
IndiDev.items.clear;
for i:=0 to NumIndiDriver do IndiDev.items.add(IndiDriverLst[i,1]);
for i:=0 to NumIndiDriver do if IndiDriverLst[i,1]=csc.IndiDevice then IndiDev.itemindex:=i;
end;

procedure Tf_config_system.DBtypeGroupClick(Sender: TObject);
var dbpath:string;
begin
if skipDBtypeGroupClick then begin
   skipDBtypeGroupClick:=false;
   exit;
end;
if messageDlg(Format(rsAlsoBeSureTh, [DBtypeGroup.hint+crlf+crlf, crlf, crlf]),
  mtConfirmation, [mbYes, mbNo], 0)=mrYes then begin
 case DBtypeGroup.ItemIndex of
  0 : begin
        DBtype:=sqlite;
        MysqlBox.visible:=false;
        SqliteBox.visible:=true;
        dbnamesqlite.text:=SysToUTF8(slash(privatedir)+StringReplace(defaultSqliteDB,'/',PathDelim,[rfReplaceAll]));
        dbpath:=extractfilepath(dbnamesqlite.text);
        if not directoryexists(dbpath) then CreateDir(dbpath);
        if not directoryexists(dbpath) then forcedirectories(dbpath);
      end;
  1 : begin
        DBtype:=mysql;
        MysqlBox.visible:=true;
        SqliteBox.visible:=false;
        dbname.text:=defaultMySqlDB;
      end;
 end;
 if Assigned(FSaveAndRestart) then FSaveAndRestart(self);
end
else begin
 skipDBtypeGroupClick:=true;
 case DBtype of
  sqlite : DBtypeGroup.itemindex:=0;
  mysql  : DBtypeGroup.itemindex:=1;
 end;
end;
end;

procedure Tf_config_system.dbnamesqliteChange(Sender: TObject);
begin
if LockChange then exit;
cmain.db:=dbnamesqlite.text;
end;

procedure Tf_config_system.dbnameChange(Sender: TObject);
begin
if LockChange then exit;
if cmain.db<>dbname.Text then dbchanged:=true;
cmain.db:=dbname.Text;
end;

procedure Tf_config_system.dbhostChange(Sender: TObject);
begin
if LockChange then exit;
if cmain.dbhost<>dbhost.Text then dbchanged:=true;
cmain.dbhost:=dbhost.Text;
end;

procedure Tf_config_system.dbportChange(Sender: TObject);
begin
if LockChange then exit;
if cmain.dbport<>dbport.Value then dbchanged:=true;
cmain.dbport:=dbport.Value;
end;

procedure Tf_config_system.dbuserChange(Sender: TObject);
begin
if LockChange then exit;
if cmain.dbuser<>dbuser.Text then dbchanged:=true;
cmain.dbuser:=dbuser.Text;
end;

procedure Tf_config_system.dbpassChange(Sender: TObject);
begin
if LockChange then exit;
if cmain.dbpass<>dbpass.Text then dbchanged:=true;
cmain.dbpass:=dbpass.Text;
end;

procedure Tf_config_system.chkdbClick(Sender: TObject);
var msg: string;
begin
msg:=cdb.checkdbconfig(cmain);
ShowMessage(msg);
end;

procedure Tf_config_system.credbClick(Sender: TObject);
var ok:boolean;
begin
screen.cursor:=crHourGlass;
cdb.createdb(cmain,ok);
if ok then begin
  // signal new database
  if Assigned(FDBChange) then FDBChange(self);
  // load sample data
  if Assigned(FLoadMPCSample) then FLoadMPCSample(self);
end;
screen.cursor:=crDefault;
chkdbClick(Sender);
end;

procedure Tf_config_system.dropdbClick(Sender: TObject);
var msg:string;
begin
if messagedlg(Format(rsWarningYouAr, [crlf, cmain.db, crlf]),
              mtWarning, [mbYes,mbNo], 0)=mrYes then begin
  msg:=cdb.dropdb(cmain);
  if msg<>'' then showmessage(msg);
  // signal database no more exists
  if Assigned(FDBChange) then FDBChange(self);
end;
end;

procedure Tf_config_system.BitBtn1Click(Sender: TObject);
begin

end;

procedure Tf_config_system.BitBtn2Click(Sender: TObject);
begin

end;

procedure Tf_config_system.AstDBClick(Sender: TObject);
begin
 if Assigned(FShowAsteroid) then FShowAsteroid(self);
end;

procedure Tf_config_system.CometDBClick(Sender: TObject);
begin
 if Assigned(FShowComet) then FShowComet(self);
end;

procedure Tf_config_system.prgdirChange(Sender: TObject);
begin
if LockChange then exit;
cmain.prgdir:=prgdir.text;
end;

procedure Tf_config_system.persdirChange(Sender: TObject);
begin
if LockChange then exit;
cmain.persdir:=persdir.text;
dbnamesqlite.Text:=slash(cmain.persdir)+slash('database')+'cdc.db';
dbchanged:=true;
end;

procedure Tf_config_system.LinuxDesktopBoxChange(Sender: TObject);
begin
if LockChange then exit;
case LinuxDesktopBox.itemIndex of
  0:  begin  // FreeDesktop.org
        LinuxCmd.Text:='xdg-open';
        LinuxCmd.Enabled:=false;
      end;
  1:  begin  // KDE
        LinuxCmd.Text:='kfmclient exec';
        LinuxCmd.Enabled:=false;
      end;
  2:  begin  // GNOME
        LinuxCmd.Text:='gnome-open';
        LinuxCmd.Enabled:=false;
      end;
  3:  begin  // Other
        LinuxCmd.Text:='/usr/bin/mozilla';
        LinuxCmd.Enabled:=true;
      end;
end;
LinuxDesktop:=LinuxDesktopBox.itemIndex;
end;

procedure Tf_config_system.LinuxCmdChange(Sender: TObject);
begin
if LockChange then exit;
OpenFileCMD:=LinuxCmd.Text;
end;

procedure Tf_config_system.FormCreate(Sender: TObject);
begin
SetLang;
  LockChange:=true;
end;

procedure Tf_config_system.FormDestroy(Sender: TObject);
begin
mycsc.Free;
myccat.Free;
mycshr.Free;
mycplot.Free;
mycmain.Free;
end;

procedure Tf_config_system.LanguageListSelect(Sender: TObject);
begin
if LockChange then exit;
  if LeftStr(LanguageList.Text,1)=blank then cmain.language:=''
     else cmain.language:=words(LanguageList.Text,'',1,1);
end;

procedure Tf_config_system.FormClose(Sender: TObject;
  var CloseAction: TCloseAction);
begin
  LockChange:=true;
end;

procedure Tf_config_system.Button2Click(Sender: TObject);
begin
  if assigned(FApplyConfig) then FApplyConfig(Self);
end;

procedure Tf_config_system.Button4Click(Sender: TObject);
begin
  ShowHelp;
end;

procedure Tf_config_system.UseIPserverClick(Sender: TObject);
begin
cmain.AutostartServer:=UseIPserver.Checked;
end;

procedure Tf_config_system.keepaliveClick(Sender: TObject);
begin
cmain.keepalive:=keepalive.checked;
end;

procedure Tf_config_system.ipaddrChange(Sender: TObject);
begin
if LockChange then exit;
cmain.ServerIPaddr:=ipaddr.Text;
end;

procedure Tf_config_system.ipportChange(Sender: TObject);
begin
if LockChange then exit;
cmain.ServerIPport:=ipport.Text;
end;

procedure Tf_config_system.TelescopeSelectClick(Sender: TObject);
begin
csc.IndiTelescope:=Telescopeselect.itemindex=0;
csc.ManualTelescope:=Telescopeselect.itemindex=1;
csc.PluginTelescope:=Telescopeselect.itemindex=2;
csc.ASCOMTelescope:=Telescopeselect.itemindex=3;
INDI.visible:=csc.IndiTelescope;
TelescopePlugin.visible:=csc.PluginTelescope;
TelescopeManual.visible:=csc.ManualTelescope;
ASCOMPanel.visible:=csc.ASCOMTelescope;
end;

procedure Tf_config_system.IndiServerHostChange(Sender: TObject);
begin
if LockChange then exit;
csc.IndiServerHost:=IndiServerHost.text;
end;

procedure Tf_config_system.IndiServerPortChange(Sender: TObject);
begin
if LockChange then exit;
csc.IndiServerPort:=IndiServerPort.text;
end;

procedure Tf_config_system.IndiAutostartClick(Sender: TObject);
begin
csc.IndiAutostart:=IndiAutostart.checked;
end;

procedure Tf_config_system.IndiServerCmdChange(Sender: TObject);
begin
if LockChange then exit;
csc.IndiServerCmd:=IndiServerCmd.text;
end;

procedure Tf_config_system.IndiDevChange(Sender: TObject);
begin
if LockChange then exit;
csc.IndiDevice:=IndiDriverLst[IndiDev.itemindex,1];
IndiDriver.text:=IndiDriverLst[IndiDev.itemindex,2];
if IndiDev.itemindex=0 then begin
   IndiDriver.enabled:=true;
   IndiDriver.setfocus;
end else begin
   IndiDriver.enabled:=false;
end;
end;

procedure Tf_config_system.IndiDriverChange(Sender: TObject);
begin
if LockChange then exit;
csc.IndiDriver:=IndiDriver.text;
end;

procedure Tf_config_system.IndiPortChange(Sender: TObject);
begin
if LockChange then exit;
{$ifdef unix}
csc.IndiPort:=IndiPort.text;
{$endif}
{$ifdef mswindows}
csc.IndiPort:='/dev/ttyS'+inttostr(IndiPort.itemindex);
{$endif}
end;

procedure Tf_config_system.PanelCmdChange(Sender: TObject);
begin
if LockChange then exit;
cmain.IndiPanelCmd:=PanelCmd.text;
end;

procedure Tf_config_system.TurnsRaChange(Sender: TObject);
begin
if LockChange then exit;
if RevertTurnsRa.checked then csc.TelescopeTurnsX:=-TurnsRa.value
                         else csc.TelescopeTurnsX:=TurnsRa.value;
end;

procedure Tf_config_system.TurnsDecChange(Sender: TObject);
begin
if LockChange then exit;
if RevertTurnDec.checked then csc.TelescopeTurnsY:=-TurnsDec.value
                         else csc.TelescopeTurnsY:=TurnsDec.value;
end;

procedure Tf_config_system.TurnsAzChange(Sender: TObject);
begin
if LockChange then exit;
if RevertTurnsAz.checked then csc.TelescopeTurnsX:=-TurnsAz.value
                         else csc.TelescopeTurnsX:=TurnsAz.value;
end;

procedure Tf_config_system.TurnsAltChange(Sender: TObject);
begin
if LockChange then exit;
if RevertTurnsAlt.checked then csc.TelescopeTurnsY:=-TurnsAlt.value
                          else csc.TelescopeTurnsY:=TurnsAlt.value;
end;

procedure Tf_config_system.ManualMountTypeClick(Sender: TObject);
begin
csc.ManualTelescopeType:=ManualMountType.ItemIndex;
case csc.ManualTelescopeType of
  0 : begin
        AltAzMount.Visible:=false;
        EquatorialMount.Visible:=true;
        TurnsDecChange(Sender);
        TurnsRaChange(Sender);
      end;
  1 : begin
        AltAzMount.Visible:=true;
        EquatorialMount.Visible:=false;
        TurnsAzChange(Sender);
        TurnsAltChange(Sender);
      end;
end;
end;

procedure Tf_config_system.telescopepluginlistChange(Sender: TObject);
begin
if LockChange then exit;
csc.ScopePlugin:=telescopepluginlist.text;
end;

initialization
  {$i pu_config_system.lrs}

end.

