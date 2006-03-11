unit pu_config_internet;

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

uses u_constant, u_util,
  LCLIntf, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, CheckLst, Buttons, Spin, ExtCtrls, enhedits, ComCtrls, LResources,
  ButtonPanel;

type

  { Tf_config_internet }

  Tf_config_internet = class(TForm)
    astcdc: TButton;
    comhttp: TButton;
    comftp: TButton;
    comdefault: TButton;
    astdefault: TButton;
    brightneo: TButton;
    mpcorb: TButton;
    ftppassive: TCheckBox;
    httpproxy: TCheckBox;
    anonpass: TEdit;
    Label6: TLabel;
    Label7: TLabel;
    CometUrlList: TMemo;
    AsteroidUrlList: TMemo;
    proxyhost: TEdit;
    proxyport: TEdit;
    proxyuser: TEdit;
    proxypass: TEdit;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    GroupBox3: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    MainPanel: TPanel;
    Page1: TPage;
    Notebook1: TNotebook;
    Page2: TPage;
    procedure anonpassChange(Sender: TObject);
    procedure astcdcClick(Sender: TObject);
    procedure AsteroidUrlListExit(Sender: TObject);
    procedure comdefaultClick(Sender: TObject);
    procedure astdefaultClick(Sender: TObject);
    procedure brightneoClick(Sender: TObject);
    procedure comftpClick(Sender: TObject);
    procedure comhttpClick(Sender: TObject);
    procedure mpcorbClick(Sender: TObject);
    procedure CometUrlListExit(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ftppassiveClick(Sender: TObject);
    procedure httpproxyClick(Sender: TObject);
    procedure proxyhostChange(Sender: TObject);
    procedure proxypassChange(Sender: TObject);
    procedure proxyportChange(Sender: TObject);
    procedure proxyuserChange(Sender: TObject);
  private
    { Private declarations }
    LockChange: boolean;
    procedure ShowProxy;
    procedure ShowOrbitalElements;
  public
    { Public declarations }
    mycmain : conf_main;
    cmain : Pconf_main;
    constructor Create(AOwner:TComponent); override;
  end;

implementation

constructor Tf_config_internet.Create(AOwner:TComponent);
begin
 cmain:=@mycmain;
 inherited Create(AOwner);
end;

procedure Tf_config_internet.FormShow(Sender: TObject);
begin
LockChange:=true;
ShowProxy;
ShowOrbitalElements;
LockChange:=false;
end;

procedure Tf_config_internet.ShowProxy;
begin
httpproxy.Checked:=cmain.HttpProxy;
proxyhost.Text:=cmain.ProxyHost;
proxyport.Text:=cmain.ProxyPort;
proxyuser.Text:=cmain.ProxyUser;
proxypass.Text:=cmain.ProxyPass;
ftppassive.Checked:=cmain.FtpPassive;
anonpass.Text:=cmain.AnonPass;
GroupBox3.Visible:=cmain.HttpProxy;
end;

procedure Tf_config_internet.ShowOrbitalElements;
begin
CometUrlList.Lines.Assign(cmain.CometUrlList);
AsteroidUrlList.Lines.Assign(cmain.AsteroidUrlList);
end;

procedure Tf_config_internet.ftppassiveClick(Sender: TObject);
begin
if lockchange then exit;
cmain.FtpPassive:=ftppassive.Checked;
end;

procedure Tf_config_internet.httpproxyClick(Sender: TObject);
begin
if lockchange then exit;
cmain.HttpProxy:=httpproxy.Checked;
GroupBox3.Visible:=cmain.HttpProxy;
end;

procedure Tf_config_internet.proxyhostChange(Sender: TObject);
begin
if lockchange then exit;
cmain.ProxyHost:=proxyhost.Text;
end;

procedure Tf_config_internet.proxypassChange(Sender: TObject);
begin
if lockchange then exit;
cmain.ProxyPass:=proxypass.Text;
end;

procedure Tf_config_internet.proxyportChange(Sender: TObject);
begin
if lockchange then exit;
cmain.ProxyPort:=proxyport.Text;
end;

procedure Tf_config_internet.proxyuserChange(Sender: TObject);
begin
if lockchange then exit;
cmain.ProxyUser:=proxyuser.Text;
end;

procedure Tf_config_internet.anonpassChange(Sender: TObject);
begin
if lockchange then exit;
cmain.AnonPass:=anonpass.text;
end;

procedure Tf_config_internet.astcdcClick(Sender: TObject);
begin
AsteroidUrlList.Clear;
AsteroidUrlList.Lines.Add(URL_CDCAsteroidElements);
AsteroidUrlListExit(Sender);
end;

procedure Tf_config_internet.FormCreate(Sender: TObject);
begin
  LockChange:=true;
end;

procedure Tf_config_internet.comdefaultClick(Sender: TObject);
begin
comhttpClick(Sender);
end;

procedure Tf_config_internet.astdefaultClick(Sender: TObject);
begin
brightneoClick(Sender);
end;

procedure Tf_config_internet.brightneoClick(Sender: TObject);
var buf: string;
begin
AsteroidUrlList.Clear;
buf:=stringreplace(URL_HTTPAsteroidElements1,'$$$$',FormatDateTime('yyyy',now),[]);
AsteroidUrlList.Lines.Add(buf);
buf:=stringreplace(URL_HTTPAsteroidElements2,'$$$$',FormatDateTime('yyyy',now),[]);
AsteroidUrlList.Lines.Add(buf);
AsteroidUrlListExit(Sender);
end;

procedure Tf_config_internet.comftpClick(Sender: TObject);
begin
CometUrlList.Clear;
CometUrlList.Lines.Add(URL_FTPCometElements);
CometUrlListExit(Sender);
end;

procedure Tf_config_internet.comhttpClick(Sender: TObject);
begin
CometUrlList.Clear;
CometUrlList.Lines.Add(URL_HTTPCometElements);
CometUrlListExit(Sender);
end;

procedure Tf_config_internet.mpcorbClick(Sender: TObject);
begin
AsteroidUrlList.Clear;
AsteroidUrlList.Lines.Add(URL_MPCORBAsteroidElements);
AsteroidUrlListExit(Sender);
end;

procedure Tf_config_internet.CometUrlListExit(Sender: TObject);
begin
if lockchange then exit;
cmain.CometUrlList.Assign(CometUrlList.Lines);
end;

procedure Tf_config_internet.AsteroidUrlListExit(Sender: TObject);
begin
if lockchange then exit;
cmain.AsteroidUrlList.Assign(AsteroidUrlList.Lines);
end;

initialization
  {$i pu_config_internet.lrs}

end.
