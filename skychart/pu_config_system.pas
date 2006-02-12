unit pu_config_system;

{$MODE Delphi}

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

uses u_constant, u_util, cu_database,
  Dialogs, Controls, Buttons, enhedits, ComCtrls, Classes,
  LCLIntf, SysUtils, Graphics, Forms,
  ExtCtrls, StdCtrls, LResources, WizardNotebook;

type

  { Tf_config_system }

  Tf_config_system = class(TForm)
    Label12: TLabel;
    LinuxCmd: TEdit;
    LinuxDesktopBox: TComboBox;
    GroupBoxLinux: TGroupBox;
    MainPanel: TPanel;
    Page1: TPage;
    Page2: TPage;
    Page3: TPage;
    SelectDirectoryDialog1: TSelectDirectoryDialog;
    Label153: TLabel;
    MysqlBox: TGroupBox;
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
    prgdir: TEdit;
    persdir: TEdit;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    GroupBox3: TGroupBox;
    Label54: TLabel;
    Label55: TLabel;
    UseIPserver: TCheckBox;
    ipaddr: TEdit;
    ipport: TEdit;
    keepalive: TCheckBox;
    Label13: TLabel;
    INDI: TGroupBox;
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
    TelescopePlugin: TGroupBox;
    Label155: TLabel;
    telescopepluginlist: TComboBox;
    GroupBox1: TGroupBox;
    chkdb: TButton;
    credb: TButton;
    dropdb: TButton;
    CometDB: TButton;
    AstDB: TButton;
    SqliteBox: TGroupBox;
    Label1: TLabel;
    dbnamesqlite: TEdit;
    DBtypeGroup: TRadioGroup;
    Label2: TLabel;
    PanelCmd: TEdit;
    TelescopeManual: TGroupBox;
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
    WizardNotebook1: TWizardNotebook;
    procedure FormCreate(Sender: TObject);
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
    procedure FrameExit(Sender: TObject);
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
    dbchanged,skipDBtypeGroupClick,LockChange: boolean;
    procedure ShowSYS;
    procedure ShowServer;
    procedure ShowTelescope;
  public
    { Public declarations }
    cdb:Tcdcdb;
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
    property onShowAsteroid: TNotifyEvent read FShowAsteroid write FShowAsteroid;
    property onShowComet: TNotifyEvent read FShowComet write FShowComet;
    property onLoadMPCSample: TNotifyEvent read FLoadMPCSample write FLoadMPCSample;
    property onDBChange: TNotifyEvent read FDBChange write FDBChange;
    property onSaveAndRestart: TNotifyEvent read FSaveAndRestart write FSaveAndRestart;
  end;

implementation



constructor Tf_config_system.Create(AOwner:TComponent);
begin
 csc:=@mycsc;
 ccat:=@myccat;
 cshr:=@mycshr;
 cplot:=@mycplot;
 cmain:=@mycmain;
 inherited Create(AOwner);
end;

procedure Tf_config_system.FrameExit(Sender: TObject);
begin
 if dbchanged and Assigned(FDBChange) then FDBChange(self);
end;

procedure Tf_config_system.FormShow(Sender: TObject);
begin
LockChange:=true;
dbchanged:=false;
ShowSYS;
ShowServer;
ShowTelescope;
LockChange:=false;
{$ifdef mswindows}
GroupBoxLinux.Visible:=false;
{$endif}
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
dbnamesqlite.Text:=cmain.db;
dbname.Text:=cmain.db;
dbhost.Text:=cmain.dbhost;
dbport.value:=cmain.dbport;
dbuser.Text:=cmain.dbuser;
dbpass.Text:=cmain.dbpass;
prgdir.text:=cmain.prgdir;
persdir.text:=cmain.persdir;
{$ifdef unix}
LinuxDesktopBox.itemIndex:=LinuxDesktop;
LinuxCmd.Text:=OpenFileCMD;
if LinuxDesktopBox.itemIndex<>2 then LinuxCmd.Enabled:=false;
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
if csc.IndiTelescope then Telescopeselect.itemindex:=0
   else if csc.PluginTelescope then Telescopeselect.itemindex:=2
   else Telescopeselect.itemindex:=1;
TelescopeselectClick(self);
{$ifdef linux}
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
begin
if skipDBtypeGroupClick then begin
   skipDBtypeGroupClick:=false;
   exit;
end;
if messageDlg(DBtypeGroup.hint+crlf+crlf+'Also be sure the require database software is installed.'+crlf+'Please consult the documentation if you are unsure.'+crlf+'Do you want to continue?',mtConfirmation,[mbYes,mbNo],0)=mrYes then begin
 case DBtypeGroup.ItemIndex of
  0 : begin
        DBtype:=sqlite;
        MysqlBox.visible:=false;
        SqliteBox.visible:=true;
        dbnamesqlite.text:=slash(privatedir)+StringReplace(defaultSqliteDB,'/',PathDelim,[rfReplaceAll]);
        forcedirectories(extractfilepath(dbnamesqlite.text));
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
msg:=cdb.checkdbconfig(cmain^);
ShowMessage(msg);
end;

procedure Tf_config_system.credbClick(Sender: TObject);
var ok:boolean;
begin
screen.cursor:=crHourGlass;
cdb.createdb(cmain^,ok);
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
if messagedlg('Warning!'+crlf+'You are about to destroy the database '+cmain.db+' and all it''s content, even if this content is not related to this program.'+crlf+'Are you sure you want to continue?',
              mtWarning, [mbYes,mbNo], 0)=mrYes then begin
  msg:=cdb.dropdb(cmain^);
  if msg<>'' then showmessage(msg);
  // signal database no more exists
  if Assigned(FDBChange) then FDBChange(self);
end;
end;

procedure Tf_config_system.AstDBClick(Sender: TObject);
begin
 if Assigned(FShowAsteroid) then FShowAsteroid(self);
end;

procedure Tf_config_system.CometDBClick(Sender: TObject);
begin
 if Assigned(FShowComet) then FShowComet(self);
end;

procedure Tf_config_system.BitBtn1Click(Sender: TObject);
begin
  SelectDirectoryDialog1.InitialDir:=expandfilename(prgdir.Text);
  if SelectDirectoryDialog1.execute then
     prgdir.Text:=SelectDirectoryDialog1.Filename;
end;

procedure Tf_config_system.BitBtn2Click(Sender: TObject);
begin
  SelectDirectoryDialog1.InitialDir:=expandfilename(persdir.Text);
  if SelectDirectoryDialog1.execute then
     persdir.Text:=SelectDirectoryDialog1.Filename;
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
end;

procedure Tf_config_system.LinuxDesktopBoxChange(Sender: TObject);
begin
if LockChange then exit;
case LinuxDesktopBox.itemIndex of
  0:  begin  // KDE
        LinuxCmd.Text:='kfmclient exec';
        LinuxCmd.Enabled:=false;
      end;
  1:  begin  // GNOME
        LinuxCmd.Text:='gnome-open';
        LinuxCmd.Enabled:=false;
      end;
  2:  begin  // Other
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
  LockChange:=true;
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
INDI.visible:=csc.IndiTelescope;
TelescopePlugin.visible:=csc.PluginTelescope;
TelescopeManual.visible:=csc.ManualTelescope;
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
{$ifdef linux}
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

