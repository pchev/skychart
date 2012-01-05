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
{$ifdef linux}
var i:integer;
{$endif}
begin
dbchanged:=false;
ShowSYS;
ShowServer;
ShowTelescope;
{$ifdef linux}
  if color=dark then begin
     for i := 0 to ComponentCount-1 do begin
        if  ( Components[i] is TRightEdit ) then with (Components[i] as TRightEdit) do begin
           if color=clBase   then  color:=black;
           if color=clButton then  color:=dark;
        end;
        if  ( Components[i] is TEdit ) then with (Components[i] as TEdit) do begin
           if color=clBase   then  color:=black;
           if color=clButton then  color:=dark;
        end;
        if  ( Components[i] is TCombobox ) then with (Components[i] as TCombobox) do begin
           if color=clBase   then  color:=black;
           if color=clButton then  color:=dark;
        end;
     end;
  end else begin
     for i := 0 to ComponentCount-1 do begin
        if  ( Components[i] is TRightEdit ) then with (Components[i] as TRightEdit) do begin
           if color=black then color:=clBase;
           if color=dark  then color:=clButton;
        end;
        if  ( Components[i] is TEdit ) then with (Components[i] as TEdit) do begin
           if color=black then color:=clBase;
           if color=dark  then color:=clButton;
        end;
        if  ( Components[i] is TCombobox ) then with (Components[i] as TCombobox) do begin
           if color=black then color:=clBase;
           if color=dark  then color:=clButton;
        end;
     end;
  end;
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
{$ifdef linux}
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
{$ifdef linux}
IndiPort.text:=csc.IndiPort;
{$endif}
{$ifdef mswindows}
if csc.IndiTelescope then Telescopeselect.itemindex:=0
                     else Telescopeselect.itemindex:=1;
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
cmain.db:=dbnamesqlite.text;
end;

procedure Tf_config_system.dbnameChange(Sender: TObject);
begin
if cmain.db<>dbname.Text then dbchanged:=true;
cmain.db:=dbname.Text;
end;

procedure Tf_config_system.dbhostChange(Sender: TObject);
begin
if cmain.dbhost<>dbhost.Text then dbchanged:=true;
cmain.dbhost:=dbhost.Text;
end;

procedure Tf_config_system.dbportChange(Sender: TObject);
begin
if cmain.dbport<>dbport.Value then dbchanged:=true;
cmain.dbport:=dbport.Value;
end;

procedure Tf_config_system.dbuserChange(Sender: TObject);
begin
if cmain.dbuser<>dbuser.Text then dbchanged:=true;
cmain.dbuser:=dbuser.Text;
end;

procedure Tf_config_system.dbpassChange(Sender: TObject);
begin
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
var msg:string;
    ok:boolean;
begin
screen.cursor:=crHourGlass;
msg:=cdb.createdb(cmain^,ok);
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
{$ifdef mswindows}
  FolderDialog1.Directory:=prgdir.Text;
  if FolderDialog1.execute then
     prgdir.Text:=FolderDialog1.Directory;
{$endif}
{$ifdef linux }
  f_directory.DirectoryTreeView1.Directory:=prgdir.Text;
  f_directory.showmodal;
  if f_directory.modalresult=mrOK then
     prgdir.Text:=f_directory.DirectoryTreeView1.Directory;
{$endif}
end;

procedure Tf_config_system.BitBtn2Click(Sender: TObject);
begin
{$ifdef mswindows}
  FolderDialog1.Directory:=persdir.Text;
  if FolderDialog1.execute then
     persdir.Text:=FolderDialog1.Directory;
{$endif}
{$ifdef linux }
  f_directory.DirectoryTreeView1.Directory:=persdir.Text;
  f_directory.showmodal;
  if f_directory.modalresult=mrOK then
     persdir.Text:=f_directory.DirectoryTreeView1.Directory;
{$endif}
end;

procedure Tf_config_system.prgdirChange(Sender: TObject);
begin
cmain.prgdir:=prgdir.text;
end;

procedure Tf_config_system.persdirChange(Sender: TObject);
begin
cmain.persdir:=persdir.text;
end;

{$ifdef linux}
procedure Tf_config_system.LinuxDesktopBoxChange(Sender: TObject);
begin
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
OpenFileCMD:=LinuxCmd.Text;
end;
{$endif}

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
cmain.ServerIPaddr:=ipaddr.Text;
end;

procedure Tf_config_system.ipportChange(Sender: TObject);
begin
cmain.ServerIPport:=ipport.Text;
end;

procedure Tf_config_system.IndiServerHostChange(Sender: TObject);
begin
csc.IndiServerHost:=IndiServerHost.text;
end;

procedure Tf_config_system.IndiServerPortChange(Sender: TObject);
begin
csc.IndiServerPort:=IndiServerPort.text;
end;

procedure Tf_config_system.IndiAutostartClick(Sender: TObject);
begin
csc.IndiAutostart:=IndiAutostart.checked;
end;

procedure Tf_config_system.IndiServerCmdChange(Sender: TObject);
begin
csc.IndiServerCmd:=IndiServerCmd.text;
end;

procedure Tf_config_system.IndiDevChange(Sender: TObject);
begin
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
csc.IndiDriver:=IndiDriver.text;
end;

procedure Tf_config_system.IndiPortChange(Sender: TObject);
begin
{$ifdef linux}
csc.IndiPort:=IndiPort.text;
{$endif}
{$ifdef mswindows}
csc.IndiPort:='/dev/ttyS'+inttostr(IndiPort.itemindex);
{$endif}
end;

