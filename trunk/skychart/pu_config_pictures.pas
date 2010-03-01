unit pu_config_pictures;

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

uses u_help, u_translation, u_constant, u_util, cu_fits, cu_database,
  LCLIntf, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, FileUtil,
  StdCtrls, ComCtrls, ExtCtrls, Buttons, enhedits, LResources,
  EditBtn, LazHelpHTML;

type

  { Tf_config_pictures }

  Tf_config_pictures = class(TForm)
    backimg: TFileNameEdit;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    HTMLBrowserHelpViewer1: THTMLBrowserHelpViewer;
    HTMLHelpDatabase1: THTMLHelpDatabase;
    ResetLum: TButton;
    OnlineDSS: TCheckBox;
    OnlineDSSList: TComboBox;
    GroupBox1: TGroupBox;
    imgpath: TDirectoryEdit;
    MainPanel: TPanel;
    Page1: TPage;
    Page2: TPage;
    Page3: TPage;
    Label50: TLabel;
    Label264: TLabel;
    nimages: TLabel;
    Panel2: TPanel;
    ScanImages: TButton;
    Panel11: TPanel;
    Label266: TLabel;
    Label268: TLabel;
    ImgLumBar: TTrackBar;
    ImgContrastBar: TTrackBar;
    ProgressPanel: TPanel;
    ProgressCat: TLabel;
    ProgressBar1: TProgressBar;
    ShowImagesBox: TCheckBox;
    Label270: TLabel;
    Label271: TLabel;
    backimginfo: TLabel;
    ShowBackImg: TCheckBox;
    Panel1: TPanel;
    ImgLumBar2: TTrackBar;
    Image1: TImage;
    ImgContrastBar2: TTrackBar;
    Label1: TLabel;
    Label2: TLabel;
    ImageTimer1: TTimer;
    GroupBox3: TGroupBox;
    Label72: TLabel;
    Label73: TLabel;
    Label74: TLabel;
    Label75: TLabel;
    Label77: TLabel;
    realskydir: TEdit;
    realskydrive: TEdit;
    realskyfile: TEdit;
    RealSkyNorth: TCheckBox;
    RealSkySouth: TCheckBox;
    DSS102CD: TCheckBox;
    usesubsample: TCheckBox;
    reallist: TCheckBox;
    realskymax: TLongEdit;
    realskymb: TLongEdit;
    Notebook1: TNotebook;
    procedure Button2Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure ResetLumClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure Notebook1PageChanged(Sender: TObject);
    procedure imgpathChange(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure OnlineDSSChange(Sender: TObject);
    procedure OnlineDSSListChange(Sender: TObject);
    procedure ScanImagesClick(Sender: TObject);
    procedure ImgLumBarChange(Sender: TObject);
    procedure ImgContrastBarChange(Sender: TObject);
    procedure ShowImagesBoxClick(Sender: TObject);
    procedure backimgChange(Sender: TObject);
    procedure ShowBackImgClick(Sender: TObject);
    procedure ImgLumBar2Change(Sender: TObject);
    procedure ImgContrastBar2Change(Sender: TObject);
    procedure ImageTimer1Timer(Sender: TObject);
    procedure RealSkyNorthClick(Sender: TObject);
    procedure DSS102CDClick(Sender: TObject);
    procedure RealSkySouthClick(Sender: TObject);
    procedure realskymaxChange(Sender: TObject);
    procedure realskydirChange(Sender: TObject);
    procedure realskydriveChange(Sender: TObject);
    procedure realskyfileChange(Sender: TObject);
    procedure reallistClick(Sender: TObject);
    procedure usesubsampleClick(Sender: TObject);
  private
    { Private declarations }
    LockChange: boolean;
    FFits: TFits;
    FApplyConfig: TNotifyEvent;
    procedure ShowImages;
    procedure RefreshImage;
  public
    { Public declarations }
    cdb: Tcdcdb;
    mycsc : Tconf_skychart;
    myccat : Tconf_catalog;
    mycshr : Tconf_shared;
    mycplot : Tconf_plot;
    mycmain : Tconf_main;
    mycdss : Tconf_dss;
    csc : Tconf_skychart;
    ccat : Tconf_catalog;
    cshr : Tconf_shared;
    cplot : Tconf_plot;
    cmain : Tconf_main;
    cdss : Tconf_dss;
    procedure SetLang;
    constructor Create(AOwner:TComponent); override;
    property Fits: TFits read FFits write FFits;
    property onApplyConfig: TNotifyEvent read FApplyConfig write FApplyConfig;
  end;

implementation

procedure Tf_config_pictures.SetLang;
begin
Caption:=rsPictures;
Page1.caption:=rsObjects;
Label50.caption:=rsDisplayImage;
Label264.caption:=rsImageDirecto;
ScanImages.caption:=rsScanDirector;
Label266.caption:=rsLuminosity;
Label268.caption:=rsContrast;
ResetLum.caption:=rsReset;
ShowImagesBox.caption:=rsShowObjectPi;
ProgressCat.caption:=rsOther;
Page2.caption:=rsBackground;
Label270.caption:=rsBackgroundPi;
Label271.caption:=rsFITSFile;
ShowBackImg.caption:=rsShowThisPict;
Label1.caption:=rsLuminosity;
Label2.caption:=rsContrast;
Page3.caption:=rsDSSRealsky;
Label72.caption:=rsAuxiliaryFil;
Label73.caption:=rsDataFilesCDr;
Label74.caption:=rsTemporaryFil;
Label75.caption:=rsPixels;
Label77.caption:=rsMBytes;
RealSkyNorth.caption:=rsRealSkyNorth;
RealSkySouth.caption:=rsRealSkySouth;
DSS102CD.caption:=rs102CDDSS;
usesubsample.caption:=rsUseSubsampli;
reallist.caption:=rsSelectPlateF;
GroupBox1.caption:=rsOnlineDSS;
OnlineDSS.caption:=rsUseOnlineDSS;
Button1.caption:=rsOK;
Button2.caption:=rsApply;
Button3.caption:=rsCancel;
Button4.caption:=rsHelp;
SetHelpDB(HTMLHelpDatabase1);
SetHelp(self,hlpCfgPict);
end;

constructor Tf_config_pictures.Create(AOwner:TComponent);
begin
 mycsc:=Tconf_skychart.Create;
 myccat:=Tconf_catalog.Create;
 mycshr:=Tconf_shared.Create;
 mycplot:=Tconf_plot.Create;
 mycmain:=Tconf_main.Create;
 mycdss:=Tconf_DSS.Create;
 csc:=mycsc;
 ccat:=myccat;
 cshr:=mycshr;
 cplot:=mycplot;
 cmain:=mycmain;
 cdss:=mycdss;
 inherited Create(AOwner);
end;

procedure Tf_config_pictures.FormShow(Sender: TObject);
begin
LockChange:=true;
ShowImages;
LockChange:=false;
ImageTimer1.Interval:=100;
ImageTimer1.enabled:=true;
end;

procedure Tf_config_pictures.ShowImages;
var save:boolean;
  i: Integer;
begin
imgpath.text:=cmain.ImagePath;
ImgLumBar.position:=-round(10*cmain.ImageLuminosity);
ImgContrastBar.position:=round(10*cmain.ImageContrast);
ImgLumBar2.position:=-round(10*cmain.ImageLuminosity);
ImgContrastBar2.position:=round(10*cmain.ImageContrast);
ShowImagesBox.checked:=csc.ShowImages;
nimages.caption:=Format(rsThereAreCata, [inttostr(cdb.CountImages)]);
save:=csc.ShowBackgroundImage;
backimg.text:=SysToUTF8(csc.BackgroundImage);
ShowBackImg.checked:=save;
cmain.NewBackgroundImage:=false;
ImageTimer1.enabled:=false;
RealSkyNorth.Checked:=cdss.dssnorth;
RealSkySouth.Checked:=cdss.dsssouth;
DSS102CD.Checked:=cdss.dss102;
realskydir.text:=cdss.dssdir;
realskydrive.text:=cdss.dssdrive;
realskyfile.text:=cdss.dssfile;
reallist.checked:=cdss.dssplateprompt;
usesubsample.checked:=cdss.dsssampling;
realskymax.value:=cdss.dssmaxsize;
OnlineDSS.Checked:=cdss.OnlineDSS;
OnlineDSSList.Clear;
for i:=1 to MaxDSSurl do
  if cdss.DSSurl[i,1]<>'' then
     OnlineDSSList.Items.Add(cdss.DSSurl[i,0]);
OnlineDSSList.ItemIndex:=cdss.OnlineDSSid-1;
end;

procedure Tf_config_pictures.imgpathChange(Sender: TObject);
begin
if LockChange then exit;
cmain.ImagePath:=imgpath.text;
end;

procedure Tf_config_pictures.FormCreate(Sender: TObject);
begin
 SetLang;
  LockChange:=true;
  backimginfo.caption:=rsNoPicture;
  ShowBackImg.checked:=false;
  Image1.canvas.brush.color:=clBlack;
  Image1.canvas.pen.color:=clBlack;
  Image1.canvas.rectangle(0,0,Image1.width,Image1.Height);
end;

procedure Tf_config_pictures.Button2Click(Sender: TObject);
begin
  if assigned(FApplyConfig) then FApplyConfig(Self);
end;

procedure Tf_config_pictures.Button4Click(Sender: TObject);
begin
  ShowHelp;
end;

procedure Tf_config_pictures.FormDestroy(Sender: TObject);
begin
mycsc.Free;
myccat.Free;
mycshr.Free;
mycplot.Free;
mycmain.Free;
mycdss.free;
end;

procedure Tf_config_pictures.ResetLumClick(Sender: TObject);
begin
LockChange:=true;
try
ImgContrastBar.position:=0;
ImgLumBar.position:=0;
cmain.ImageContrast:=0;
cmain.ImageLuminosity:=0;
FFits.max_sigma:=0;
FFits.min_sigma:=0;
ImageTimer1.enabled:=true;
finally
LockChange:=false;
end;
end;

procedure Tf_config_pictures.FormClose(Sender: TObject;
  var CloseAction: TCloseAction);
begin
 LockChange:=true;
end;

procedure Tf_config_pictures.Notebook1PageChanged(Sender: TObject);
begin
if Notebook1.PageIndex=1 then backimgChange(Sender);
end;

procedure Tf_config_pictures.ScanImagesClick(Sender: TObject);
begin
if DirectoryExists(cmain.ImagePath) then begin
screen.cursor:=crHourGlass;
ProgressPanel.visible:=true;
Cdb.ScanImagesDirectory(cmain.ImagePath,ProgressCat,ProgressBar1 );
ShowImagesBox.checked:=true;
screen.cursor:=crDefault;
ProgressPanel.visible:=false;
nimages.caption:=Format(rsThereAreCata, [inttostr(cdb.CountImages)]);
end else begin
  nimages.Caption:='Directory not found! Please install the Skychart Pictures package.';
end;
end;

procedure Tf_config_pictures.ImgLumBarChange(Sender: TObject);
begin
if LockChange then exit;
cmain.ImageLuminosity:=-ImgLumBar.position/10;
end;

procedure Tf_config_pictures.ImgContrastBarChange(Sender: TObject);
begin
if LockChange then exit;
cmain.ImageContrast:=ImgContrastBar.position/10;
end;

procedure Tf_config_pictures.ShowImagesBoxClick(Sender: TObject);
begin
csc.ShowImages:=ShowImagesBox.checked;
end;

procedure Tf_config_pictures.ImgContrastBar2Change(Sender: TObject);
begin
if LockChange then exit;
cmain.ImageContrast:=ImgContrastBar2.position/10;
FFits.max_sigma:=cmain.ImageContrast;
ImageTimer1.enabled:=true;
end;

procedure Tf_config_pictures.ImgLumBar2Change(Sender: TObject);
begin
if LockChange then exit;
cmain.ImageLuminosity:=-ImgLumBar2.position/10;
FFits.min_sigma:=cmain.ImageLuminosity;
ImageTimer1.enabled:=true;
end;

procedure Tf_config_pictures.ImageTimer1Timer(Sender: TObject);
begin
ImageTimer1.enabled:=false;
ImageTimer1.Interval:=500;
RefreshImage;
end;

procedure Tf_config_pictures.backimgChange(Sender: TObject);
begin
if LockChange or (not Fileexists(backimg.text)) then exit;
csc.BackgroundImage:=backimg.text;
Ffits.filename:=csc.BackgroundImage;
if Ffits.header.coordinate_valid then begin
  cmain.NewBackgroundImage:=true;
  if Sender=backimg then ShowBackImg.checked:=true;
  backimginfo.caption:=extractfilename(csc.BackgroundImage)+blank+rsRA+':'+
    ARtoStr(Ffits.center_ra*rad2deg/15)+blank+''+rsDEC+''+':'+DEtoStr(
      Ffits.center_de*
    rad2deg)+blank+rsFOV+':'+DEtoStr(Ffits.img_width*rad2deg);
  RefreshImage;
end
else begin
  backimginfo.caption:=rsNoPicture;
  ShowBackImg.checked:=false;
  Image1.canvas.brush.color:=clBlack;
  Image1.canvas.pen.color:=clBlack;
  Image1.canvas.rectangle(0,0,Image1.width,Image1.Height);
end;
end;

Procedure  Tf_config_pictures.RefreshImage;
var bmp: TBitmap;
    c1,c2:double;
    x,y,dx,dy:integer;
begin
bmp:=Tbitmap.create;
FFits.GetBitmap(bmp);
if bmp.Width>1 then begin
  c1:=Image1.width/Image1.Height;
  c2:=bmp.width/bmp.Height;
  if c1>c2 then begin
    dy:=Image1.Height;
    dx:=round(c2*dy);
    y:=0;
    x:=round((Image1.width-dx)/2);
  end else begin
    dx:=Image1.width;
    dy:=round(dx/c2);
    x:=0;
    y:=round((Image1.Height-dy)/2);
  end;
  Image1.canvas.brush.color:=clBlack;
  Image1.canvas.pen.color:=clBlack;
  Image1.canvas.rectangle(0,0,Image1.width,Image1.Height);
  Image1.canvas.stretchdraw(rect(x,y,x+dx,y+dy),bmp);
end;
bmp.Free;
end;

procedure Tf_config_pictures.ShowBackImgClick(Sender: TObject);
begin
csc.ShowBackgroundImage:=ShowBackImg.checked;
cmain.NewBackgroundImage:=csc.ShowBackgroundImage;
backimgChange(Sender);
end;

procedure Tf_config_pictures.DSS102CDClick(Sender: TObject);
begin
cdss.dss102:=DSS102CD.Checked;
if DSS102CD.Checked then begin
   RealSkyNorth.Checked:=false;
   RealSkySouth.Checked:=false;
end;
end;

procedure Tf_config_pictures.RealSkyNorthClick(Sender: TObject);
begin
cdss.dssnorth:=RealSkyNorth.Checked;
if RealSkyNorth.Checked then begin
   DSS102CD.Checked:=false;
end;
end;

procedure Tf_config_pictures.RealSkySouthClick(Sender: TObject);
begin
cdss.dsssouth:=RealSkySouth.Checked;
if RealSkySouth.Checked then begin
   DSS102CD.Checked:=false;
end;
end;

procedure Tf_config_pictures.realskymaxChange(Sender: TObject);
begin
if LockChange then exit;
cdss.dssmaxsize:=realskymax.value;
realskymb.value:=round(sqr(realskymax.value)*2/1024/1024);
end;


procedure Tf_config_pictures.realskydirChange(Sender: TObject);
begin
if LockChange then exit;
cdss.dssdir:=realskydir.text;
if fileexists(slash(cdss.dssdir)+'hi_comp.lis') then
   realskydir.color:=realskydrive.color
else
   realskydir.color:=clRed;
end;

procedure Tf_config_pictures.realskydriveChange(Sender: TObject);
begin
if LockChange then exit;
cdss.dssdrive:=realskydrive.text;
end;

procedure Tf_config_pictures.realskyfileChange(Sender: TObject);
begin
if LockChange then exit;
cdss.dssfile:=realskyfile.text;
end;

procedure Tf_config_pictures.reallistClick(Sender: TObject);
begin
if LockChange then exit;
cdss.dssplateprompt:=reallist.checked;
end;

procedure Tf_config_pictures.usesubsampleClick(Sender: TObject);
begin
if LockChange then exit;
cdss.dsssampling:=usesubsample.checked;
end;

procedure Tf_config_pictures.OnlineDSSChange(Sender: TObject);
begin
if LockChange then exit;
cdss.OnlineDSS:=OnlineDSS.Checked;
end;

procedure Tf_config_pictures.OnlineDSSListChange(Sender: TObject);
begin
if LockChange then exit;
cdss.OnlineDSSid:=OnlineDSSList.ItemIndex+1;
end;

initialization
  {$i pu_config_pictures.lrs}

end.
