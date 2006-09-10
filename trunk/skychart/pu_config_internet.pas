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

uses u_translation, u_constant, u_util,
  LCLIntf, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, CheckLst, Buttons, Spin, ExtCtrls, enhedits, ComCtrls, LResources,
  ButtonPanel, Grids;

type

  { Tf_config_internet }

  Tf_config_internet = class(TForm)
    astcdc: TButton;
    DefaultDSS: TButton;
    comhttp: TButton;
    comftp: TButton;
    comdefault: TButton;
    astdefault: TButton;
    brightneo: TButton;
    Label8: TLabel;
    mpcorb: TButton;
    ftppassive: TCheckBox;
    httpproxy: TCheckBox;
    anonpass: TEdit;
    Label6: TLabel;
    Label7: TLabel;
    CometUrlList: TMemo;
    AsteroidUrlList: TMemo;
    Page3: TPage;
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
    DSSpictures: TStringGrid;
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure anonpassChange(Sender: TObject);
    procedure astcdcClick(Sender: TObject);
    procedure AsteroidUrlListExit(Sender: TObject);
    procedure comdefaultClick(Sender: TObject);
    procedure astdefaultClick(Sender: TObject);
    procedure brightneoClick(Sender: TObject);
    procedure comftpClick(Sender: TObject);
    procedure comhttpClick(Sender: TObject);
    procedure DefaultDSSClick(Sender: TObject);
    procedure DSSpicturesEditingDone(Sender: TObject);
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
    procedure ShowDSS;
  public
    { Public declarations }
    mycmain : conf_main;
    mycdss : conf_dss;
    cmain : Pconf_main;
    cdss : Pconf_dss;
    procedure SetLang;
    constructor Create(AOwner:TComponent); override;
  end;

implementation

procedure Tf_config_internet.SetLang;
begin
Caption:=rsInternet;
Page1.caption:=rsProxy;
GroupBox1.caption:=rsHTTPProxy;
httpproxy.caption:=rsUseHTTPProxy;
Label2.caption:=rsProxyHost;
Label3.caption:=rsProxyPort;
Label4.caption:=rsUserName;
Label5.caption:=rsPassword;
GroupBox2.caption:=rsFTP;
Label1.caption:=rsAnonymousPas;
ftppassive.caption:=rsFTPPassiveMo;
Page2.caption:=rsOrbitalEleme;
Label6.caption:=rsCometElement;
Label7.caption:=rsAsteroidElem;
comdefault.caption:=rsDefault;
astdefault.caption:=rsDefault;
brightneo.caption:=rsBrightNEO;
mpcorb.caption:=rsMPCORB50Mb;
comhttp.caption:=rsMPCHttp;
comftp.caption:=rsMPCFtp;
astcdc.caption:=rsFirst5000;
Page3.caption:=rsOnlineDSS;
Label8.caption:=rsOnlinePictur;
DefaultDSS.caption:=rsDefault;
end;

constructor Tf_config_internet.Create(AOwner:TComponent);
begin
 cmain:=@mycmain;
 cdss:=@mycdss;
 inherited Create(AOwner);
end;

procedure Tf_config_internet.FormShow(Sender: TObject);
begin
LockChange:=true;
ShowProxy;
ShowOrbitalElements;
ShowDSS;
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

procedure Tf_config_internet.ShowDSS;
var i:integer;
begin
DSSpictures.RowCount:=MaxDSSurl+1;
DSSpictures.ColWidths[1]:=DSSpictures.ClientWidth-DSSpictures.ColWidths[0];
DSSpictures.Cells[0, 0]:=rsName;
DSSpictures.Cells[1, 0]:=rsURL;
for i:=1 to MaxDSSurl do begin
  DSSpictures.Cells[0,i]:=cdss.DSSurl[i,0];
  DSSpictures.Cells[1,i]:=cdss.DSSurl[i,1];
end;
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

procedure Tf_config_internet.FormClose(Sender: TObject;
  var CloseAction: TCloseAction);
begin
LockChange:=true;
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
  SetLang;
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
buf:=stringreplace(URL_HTTPAsteroidElements1,'$YYYY',FormatDateTime('yyyy',now),[]);
AsteroidUrlList.Lines.Add(buf);
buf:=stringreplace(URL_HTTPAsteroidElements2,'$YYYY',FormatDateTime('yyyy',now),[]);
AsteroidUrlList.Lines.Add(buf);
buf:=stringreplace(URL_HTTPAsteroidElements3,'$YYYY',FormatDateTime('yyyy',now),[]);
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

procedure Tf_config_internet.DefaultDSSClick(Sender: TObject);
var
  i: Integer;
begin
for i:=1 to MaxDSSurl do begin
  cdss.DSSurl[i,0]:='';
  cdss.DSSurl[i,1]:='';
end;
cdss.DSSurl[1,0]:=URL_DSS_NAME1;
cdss.DSSurl[1,1]:=URL_DSS1;
cdss.DSSurl[2,0]:=URL_DSS_NAME2;
cdss.DSSurl[2,1]:=URL_DSS2;
cdss.DSSurl[3,0]:=URL_DSS_NAME3;
cdss.DSSurl[3,1]:=URL_DSS3;
cdss.DSSurl[4,0]:=URL_DSS_NAME4;
cdss.DSSurl[4,1]:=URL_DSS4;
cdss.DSSurl[5,0]:=URL_DSS_NAME5;
cdss.DSSurl[5,1]:=URL_DSS5;
cdss.DSSurl[6,0]:=URL_DSS_NAME6;
cdss.DSSurl[6,1]:=URL_DSS6;
cdss.DSSurl[7,0]:=URL_DSS_NAME7;
cdss.DSSurl[7,1]:=URL_DSS7;
cdss.DSSurl[8,0]:=URL_DSS_NAME8;
cdss.DSSurl[8,1]:=URL_DSS8;
cdss.DSSurl[9,0]:=URL_DSS_NAME9;
cdss.DSSurl[9,1]:=URL_DSS9;
ShowDSS;
end;

procedure Tf_config_internet.DSSpicturesEditingDone(Sender: TObject);
var
  i: Integer;
begin
for i:=1 to MaxDSSurl do begin
  cdss.DSSurl[i,0]:=DSSpictures.Cells[0,i];
  cdss.DSSurl[i,1]:=DSSpictures.Cells[1,i];
end;
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
