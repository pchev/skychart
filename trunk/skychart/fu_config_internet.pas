unit fu_config_internet;

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

uses u_help, u_translation, u_constant, u_util,
  LCLIntf, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, CheckLst, Buttons, Spin, ExtCtrls, enhedits, ComCtrls, LResources,
  ButtonPanel, Grids, LazHelpHTML;

type

  { Tf_config_internet }

  Tf_config_internet = class(TFrame)
    astcdc: TButton;
    astcdcneo: TButton;
    GroupBox3: TGroupBox;
    GroupBox4: TGroupBox;
    GroupBox5: TGroupBox;
    GroupBox6: TGroupBox;
    tlemanual: TButton;
    CheckBox1: TCheckBox;
    tleinfo: TButton;
    TLEUrlList: TMemo;
    tlecelestrack: TButton;
    SocksProxy: TCheckBox;
    SocksType: TComboBox;
    DefaultDSS: TButton;
    comhttp: TButton;
    comdefault: TButton;
    astdefault: TButton;
    mpcorb: TButton;
    ftppassive: TCheckBox;
    httpproxy: TCheckBox;
    anonpass: TEdit;
    CometUrlList: TMemo;
    AsteroidUrlList: TMemo;
    Page3: TTabSheet;
    Panel2: TPanel;
    proxyhost: TEdit;
    proxyport: TEdit;
    proxyuser: TEdit;
    proxypass: TEdit;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    MainPanel: TPanel;
    Page1: TTabSheet;
    PageControl1: TPageControl;
    Page2: TTabSheet;
    DSSpictures: TStringGrid;
    Page4: TTabSheet;
    procedure astcdcneoClick(Sender: TObject);
    procedure CheckBox1Click(Sender: TObject);
    procedure anonpassChange(Sender: TObject);
    procedure astcdcClick(Sender: TObject);
    procedure AsteroidUrlListExit(Sender: TObject);
    procedure comdefaultClick(Sender: TObject);
    procedure astdefaultClick(Sender: TObject);
    procedure comhttpClick(Sender: TObject);
    procedure DefaultDSSClick(Sender: TObject);
    procedure DSSpicturesEditingDone(Sender: TObject);
    procedure mpcorbClick(Sender: TObject);
    procedure CometUrlListExit(Sender: TObject);
    procedure ftppassiveClick(Sender: TObject);
    procedure httpproxyClick(Sender: TObject);
    procedure PageControl1Changing(Sender: TObject; var AllowChange: Boolean);
    procedure proxyhostChange(Sender: TObject);
    procedure proxypassChange(Sender: TObject);
    procedure proxyportChange(Sender: TObject);
    procedure proxyuserChange(Sender: TObject);
    procedure SocksProxyClick(Sender: TObject);
    procedure SocksTypeChange(Sender: TObject);
    procedure tlecelestrackClick(Sender: TObject);
    procedure tleinfoClick(Sender: TObject);
    procedure tlemanualClick(Sender: TObject);
    procedure TLEUrlListExit(Sender: TObject);
  private
    { Private declarations }
    FApplyConfig: TNotifyEvent;
    LockChange: boolean;
    procedure ShowProxy;
    procedure ShowOrbitalElements;
    procedure ShowTle;
    procedure ShowDSS;
  public
    { Public declarations }
    mycmain : Tconf_main;
    mycdss : Tconf_dss;
    cmain : Tconf_main;
    cdss : Tconf_dss;
    procedure Init; // old FormShow
    procedure Lock; // old FormClose
    procedure SetLang;
    constructor Create(AOwner:TComponent); override;
    Destructor Destroy; override;
    property onApplyConfig: TNotifyEvent read FApplyConfig write FApplyConfig;
  end;

implementation
{$R *.lfm}

procedure Tf_config_internet.SetLang;
begin
Caption:=rsInternet;
Page1.caption:=rsProxy;
GroupBox1.caption:=rsHTTPProxy;
httpproxy.caption:=rsUseHTTPProxy;
SocksProxy.Caption:=rsUseSocksProx;
Label2.caption:=rsProxyHost;
Label3.caption:=rsProxyPort;
Label4.caption:=rsUserName;
Label5.caption:=rsPassword;
GroupBox2.caption:=rsFTP;
Label1.caption:=rsAnonymousPas;
ftppassive.caption:=rsFTPPassiveMo;
CheckBox1.Caption:=rsAskConfirmat;
Page2.caption:=rsOrbitalEleme;
GroupBox3.caption:=rsCometElement;
GroupBox4.caption:=rsAsteroidElem;
comdefault.caption:=rsDefault;
astdefault.caption:=rsDefault;
comhttp.caption:=rsMPCHttp;
astcdc.caption:=rsFirst5000;
astcdcneo.Caption:=rsFirst5000+' NEO + TNO';
Page3.caption:=rsOnlineDSS;
GroupBox5.caption:=rsOnlinePictur;
DefaultDSS.caption:=rsDefault;
Page4.Caption:=rsArtificialSa;
GroupBox6.Caption:=rsArtificialSa3;
tlemanual.Caption:=rsManual;
SetHelp(self,hlpCfgInt);
end;

constructor Tf_config_internet.Create(AOwner:TComponent);
begin
 mycmain:=Tconf_main.Create;
 mycdss:=Tconf_dss.Create;
 cmain:=mycmain;
 cdss:=mycdss;
 inherited Create(AOwner);
  LockChange:=true;
  SetLang;
end;

Destructor Tf_config_internet.Destroy;
begin
  mycmain.Free;
  mycdss.Free;
  inherited Destroy;
end;

procedure Tf_config_internet.Init;
begin
LockChange:=true;
ShowProxy;
ShowOrbitalElements;
ShowTle;
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
SocksProxy.Checked:=cmain.SocksProxy;
if cmain.SocksType='Socks4' then SocksType.ItemIndex:=1 else SocksType.ItemIndex:=0;
ftppassive.Checked:=cmain.FtpPassive;
CheckBox1.Checked:=cmain.ConfirmDownload;
anonpass.Text:=cmain.AnonPass;
panel2.Visible:=cmain.HttpProxy or cmain.SocksProxy;
SocksType.Visible:=SocksProxy.Checked;
end;

procedure Tf_config_internet.ShowOrbitalElements;
begin
CometUrlList.Lines.Assign(cmain.CometUrlList);
AsteroidUrlList.Lines.Assign(cmain.AsteroidUrlList);
end;

procedure Tf_config_internet.ShowTle;
begin
TLEUrlList.Lines.Assign(cmain.TleUrlList);
end;

procedure Tf_config_internet.ShowDSS;
var i:integer;
begin
DSSpictures.RowCount:=MaxDSSurl+1;
DSSpictures.ColWidths[1]:=DSSpictures.ClientWidth-20;
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
if cmain.HttpProxy then SocksProxy.Checked:=false;
panel2.Visible:=cmain.HttpProxy or cmain.SocksProxy;
SocksType.Visible:=SocksProxy.Checked;
end;

procedure Tf_config_internet.PageControl1Changing(Sender: TObject;
  var AllowChange: Boolean);
begin
  if parent is TForm then TForm(Parent).ActiveControl:=PageControl1;
end;

procedure Tf_config_internet.SocksProxyClick(Sender: TObject);
begin
if lockchange then exit;
cmain.SocksProxy:=SocksProxy.Checked;
if cmain.SocksProxy then httpproxy.Checked:=false;
panel2.Visible:=cmain.HttpProxy or cmain.SocksProxy;
SocksType.Visible:=SocksProxy.Checked;
end;

procedure Tf_config_internet.SocksTypeChange(Sender: TObject);
begin
if lockchange then exit;
cmain.SocksType:=SocksType.Text;
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

procedure Tf_config_internet.CheckBox1Click(Sender: TObject);
begin
if lockchange then exit;
cmain.ConfirmDownload:=CheckBox1.Checked;
end;


procedure Tf_config_internet.Lock;
begin
LockChange:=true;
end;

procedure Tf_config_internet.astcdcneoClick(Sender: TObject);
begin
AsteroidUrlList.Clear;
AsteroidUrlList.Lines.Add(URL_CDCAsteroidElements);
AsteroidUrlList.Lines.Add(URL_HTTPAsteroidElements1);
AsteroidUrlList.Lines.Add(URL_HTTPAsteroidElements2);
AsteroidUrlList.Lines.Add(URL_HTTPAsteroidElements3);
AsteroidUrlListExit(Sender);
end;

procedure Tf_config_internet.astcdcClick(Sender: TObject);
begin
AsteroidUrlList.Clear;
AsteroidUrlList.Lines.Add(URL_CDCAsteroidElements);
AsteroidUrlListExit(Sender);
end;

procedure Tf_config_internet.comdefaultClick(Sender: TObject);
begin
comhttpClick(Sender);
end;

procedure Tf_config_internet.astdefaultClick(Sender: TObject);
begin
astcdcClick(Sender);
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
cdss.DSSurl[10,0]:=URL_DSS_NAME10;
cdss.DSSurl[10,1]:=URL_DSS10;
cdss.DSSurl[11,0]:=URL_DSS_NAME11;
cdss.DSSurl[11,1]:=URL_DSS11;
cdss.DSSurl[12,0]:=URL_DSS_NAME12;
cdss.DSSurl[12,1]:=URL_DSS12;
cdss.DSSurl[13,0]:=URL_DSS_NAME13;
cdss.DSSurl[13,1]:=URL_DSS13;
cdss.DSSurl[14,0]:=URL_DSS_NAME14;
cdss.DSSurl[14,1]:=URL_DSS14;
cdss.DSSurl[15,0]:=URL_DSS_NAME15;
cdss.DSSurl[15,1]:=URL_DSS15;
cdss.DSSurl[16,0]:=URL_DSS_NAME16;
cdss.DSSurl[16,1]:=URL_DSS16;
cdss.DSSurl[17,0]:=URL_DSS_NAME17;
cdss.DSSurl[17,1]:=URL_DSS17;
cdss.DSSurl[18,0]:=URL_DSS_NAME18;
cdss.DSSurl[18,1]:=URL_DSS18;
cdss.DSSurl[19,0]:=URL_DSS_NAME19;
cdss.DSSurl[19,1]:=URL_DSS19;
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


procedure Tf_config_internet.tlecelestrackClick(Sender: TObject);
begin
TLEUrlList.Clear;
TLEUrlList.Lines.Add(URL_CELESTRAK1);
TLEUrlList.Lines.Add(URL_CELESTRAK2);
TLEUrlList.Lines.Add(URL_QSMAG);
TLEUrlListExit(Sender);
end;

procedure Tf_config_internet.tleinfoClick(Sender: TObject);
begin
TLEUrlList.Clear;
TLEUrlList.Lines.Add(URL_TLEINFO1);
TLEUrlList.Lines.Add(URL_TLEINFO2);
TLEUrlList.Lines.Add(URL_TLEINFO3);
TLEUrlList.Lines.Add(URL_QSMAG);
TLEUrlListExit(Sender);
end;

procedure Tf_config_internet.tlemanualClick(Sender: TObject);
begin
TLEUrlList.Clear;
TLEUrlListExit(Sender);
end;

procedure Tf_config_internet.TLEUrlListExit(Sender: TObject);
begin
if lockchange then exit;
cmain.TleUrlList.Assign(TLEUrlList.Lines);
end;

end.
