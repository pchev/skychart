{
Copyright (C) 2002 Patrick Chevalley

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
{
 Cross-platform common code for Main form.
}

procedure Tf_main.CreateMDIChild(const Name: string);
var
  Child: Tf_chart;
  cfg1 : conf_skychart;
  copyactive: boolean;
begin
  { allow a reasonable number of chart }
  if (MDIChildCount>=9) then exit;
  { copy active child config }
  if ActiveMDIchild is Tf_chart then with ActiveMDIchild as Tf_chart do begin
    cfg1:=sc.cfgsc;
    copyactive:=true;
  end
  else  copyactive:=false;
  { create a new MDI child window }
  Child := Tf_chart.Create(Application);
  if (MDIChildCount=1)or((MDIChildCount>1)and(MDIChildren[0].windowstate=wsMaximized))
     then Child.maximize:=true
     else Child.maximize:=false;
  Child.Caption:=name;
  Child.sc.catalog:=catalog;
  Child.sc.plot.cfgplot:=def_cfgplot;
  Child.sc.plot.starshape:=starshape.Picture.Bitmap;
  Child.sc.plot.cfgplot.starshapesize:=starshape.Picture.bitmap.Width div 11;
  Child.sc.plot.cfgplot.starshapew:=Child.sc.plot.cfgplot.starshapesize div 2;
  if copyactive then begin
    Child.sc.cfgsc:=cfg1;
  end else begin
    Child.sc.cfgsc:=def_cfgsc;
  end;
  {$ifdef linux}
  {require to switch the focus to work with the right child. Kylix bug?}
  try
  if MDIChildCount>2 then MDIChildren[1].setfocus // MDIChildren[0] already as focus
                     else quicksearch.setfocus;
  except
    // here if quicksearch is hiden, do nothing.
  end;
  {$endif}
  Child.setfocus;
  UpdateBtn(Child.sc.cfgsc.flipx,Child.sc.cfgsc.flipy);
end;

procedure Tf_main.RefreshAllChild;
var i: integer;
begin
for i:=0 to MDIChildCount-1 do
  if MDIChildren[i] is Tf_chart then
     with MDIChildren[i] as Tf_chart do begin
      sc.plot.cfgplot:=def_cfgplot;
      Refresh;
     end;
end;

procedure Tf_main.FileNew1Execute(Sender: TObject);
begin
  CreateMDIChild('Chart ' + IntToStr(MDIChildCount + 1));
end;

procedure Tf_main.FileOpen1Execute(Sender: TObject);
begin
  if OpenDialog.Execute then begin
    CreateMDIChild(OpenDialog.FileName);
    // load the saved chart
  end;
end;

procedure Tf_main.HelpAbout1Execute(Sender: TObject);
begin
  f_about.ShowModal;
end;

procedure Tf_main.FileExit1Execute(Sender: TObject);
begin
  Close;
end;

procedure Tf_main.FormCreate(Sender: TObject);
begin
DecimalSeparator:='.';
appdir:=getcurrentdir;
catalog:=Tcatalog.Create(self);
end;

procedure Tf_main.FormShow(Sender: TObject);
begin
 SetDefault;
 ReadDefault;
 InitFonts;
 SetLpanel1('');
 FileNewItem.click;
end;

procedure Tf_main.FormDestroy(Sender: TObject);
begin
catalog.free;
end;

procedure Tf_main.FormClose(Sender: TObject; var Action: TCloseAction);
begin
SaveDefault;
end;

procedure Tf_main.Print1Execute(Sender: TObject);
begin
if ActiveMdiChild is Tf_chart then with ActiveMdiChild as Tf_chart do PrintChart(Sender);
end;

procedure Tf_main.zoomplusExecute(Sender: TObject);
begin
if ActiveMdiChild is Tf_chart then with ActiveMdiChild as Tf_chart do zoomplusExecute(Sender);
end;

procedure Tf_main.zoomminusExecute(Sender: TObject);
begin
if ActiveMdiChild is Tf_chart then with ActiveMdiChild as Tf_chart do zoomminusExecute(Sender);
end;

procedure Tf_main.FlipxExecute(Sender: TObject);
begin
if ActiveMdiChild is Tf_chart then with ActiveMdiChild as Tf_chart do FlipxExecute(Sender);
end;

procedure Tf_main.FlipyExecute(Sender: TObject);

begin
if ActiveMdiChild is Tf_chart then with ActiveMdiChild as Tf_chart do FlipyExecute(Sender);
end;

procedure Tf_main.SetFOVExecute(Sender: TObject);
var f : double;
begin
with Sender as TToolButton do f:=deg2rad*tag/60;
if ActiveMdiChild is Tf_chart then with ActiveMdiChild as Tf_chart do begin
   sc.SetFOV(f);
   Refresh;
end;
end;


procedure Tf_main.OpenConfigExecute(Sender: TObject);
begin
f_config:=Tf_config.Create(application);
try
 f_config.ccat:=catalog.cfgcat;
 f_config.cshr:=catalog.cfgshr;
// f_config.cskyc:=def_cfgsc;
 f_config.cplot:=def_cfgplot;
 f_config.cmain:=cfgm;
 f_config.showmodal;
 if f_config.ModalResult=mrOK then begin
    cfgm:=f_config.cmain;
    catalog.cfgcat:=f_config.ccat;
    catalog.cfgshr:=f_config.cshr;
//    def_cfgsc:=f_config.cskyc;
    def_cfgplot:=f_config.cplot;
    def_cfgplot.starshapesize:=starshape.Picture.bitmap.Width div 11;
    def_cfgplot.starshapew:=def_cfgplot.starshapesize div 2;
    InitFonts;
    RefreshAllChild;
 end;
 cfgm.configpage:=f_config.Pagecontrol1.activepageindex;
finally
 f_config.free;
end;
end;

procedure Tf_main.ViewBarExecute(Sender: TObject);
begin
PanelTop.visible:=not PanelTop.visible;
PanelLeft.visible:=PanelTop.visible;
PanelRight.visible:=PanelTop.visible;
end;

Procedure Tf_main.InitFonts;
begin
   font.name:=cfgm.fontname[4];
   font.size:=cfgm.fontsize[4];
   if cfgm.FontBold[4] then font.style:=[fsBold] else font.style:=[];
   if cfgm.FontItalic[4] then font.style:=font.style+[fsItalic];
   LPanels0.Caption:='Ra:22h22m22.22s +22°22''22"22';
   Ppanels0.ClientWidth:=LPanels0.width+8;
   Lpanels0.Caption:='';
   Ppanels1.left:=Ppanels0.left+Ppanels0.width;
   Ppanels1.width:=PanelBottom.ClientWidth-Ppanels1.left;
end;

Procedure Tf_main.SetLPanel1(txt:string);
begin
LPanels1.width:=PPanels1.ClientWidth;
LPanels1.Caption:=txt;
PPanels1.ClientHeight:=LPanels1.Height+8;
end;

Procedure Tf_main.SetLPanel0(txt:string);
begin
LPanels0.Caption:=txt;
PPanels0.ClientHeight:=LPanels0.Height+8;
end;

procedure Tf_main.FormResize(Sender: TObject);
begin
   Ppanels1.width:=PanelBottom.ClientWidth-Ppanels1.left;
end;

procedure Tf_main.SetDefault;
var i:integer;
begin
u_util.ldeg:='°';
u_util.lmin:='''';
u_util.lsec:='"';
cfgm.language:='UK';
cfgm.prtname:='';
cfgm.configpage:=0;
cfgm.PrinterResolution:=300;
for i:=1 to 6 do begin
    cfgm.FontName[i]:=DefaultFontName;
    cfgm.FontSize[i]:=DefaultFontSize;
    cfgm.FontBold[i]:=false;
    cfgm.FontItalic[i]:=false;
end;
def_cfgplot.invisible:=false;
def_cfgplot.color:=dfColor;
def_cfgplot.backgroundcolor:=def_cfgplot.color[0];
def_cfgplot.Nebgray:=55;
def_cfgplot.NebBright:=180;
def_cfgplot.stardyn:=65;
def_cfgplot.starsize:=13;
def_cfgplot.starplot:=1;
def_cfgplot.nebplot:=1;
def_cfgsc.racentre:=1.4;
def_cfgsc.decentre:=0;
def_cfgsc.fov:=1;
def_cfgsc.theta:=0;
def_cfgsc.projtype:='A';
def_cfgsc.ProjPole:=0;
def_cfgsc.FlipX:=1;
def_cfgsc.FlipY:=1;
def_cfgsc.WindowRatio:=1;
def_cfgsc.BxGlb:=1;
def_cfgsc.ByGlb:=1;
def_cfgsc.AxGlb:=0;
def_cfgsc.AyGlb:=0;
def_cfgsc.xmin:=0;
def_cfgsc.xmax:=100;
def_cfgsc.ymin:=0;
def_cfgsc.ymax:=100;
catalog.cfgshr.StarFilter:=true;
catalog.cfgshr.AutoStarFilter:=false;
catalog.cfgshr.AutoStarFilterMag:=6.5;
catalog.cfgcat.StarmagMax:=12;
catalog.cfgshr.NebFilter:=true;
catalog.cfgshr.BigNebFilter:=false;
catalog.cfgcat.NebmagMax:=12;
catalog.cfgcat.NebSizeMin:=1;
catalog.cfgcat.UseUSNOBrightStars:=false;
catalog.cfgcat.UseGSVSIr:=false;
for i:=1 to maxstarcatalog do begin
   catalog.cfgcat.starcatpath[i]:=slash(appdir)+'cat';
   catalog.cfgcat.starcatdef[i]:=false;
   catalog.cfgcat.starcaton[i]:=false;
   catalog.cfgcat.starcatfield[i,1]:=0;
   catalog.cfgcat.starcatfield[i,2]:=0;
end;
catalog.cfgcat.starcatpath[bsc-BaseStar]:=slash(appdir)+'cat'+PathDelim+'bsc5';
catalog.cfgcat.starcatdef[bsc-BaseStar]:=true;
catalog.cfgcat.starcatfield[bsc-BaseStar,2]:=10;
for i:=1 to maxvarstarcatalog do begin
   catalog.cfgcat.varstarcatpath[i]:=slash(appdir)+'cat';
   catalog.cfgcat.varstarcatdef[i]:=false;
   catalog.cfgcat.varstarcaton[i]:=false;
   catalog.cfgcat.varstarcatfield[i,1]:=0;
   catalog.cfgcat.varstarcatfield[i,2]:=0;
end;
for i:=1 to maxdblstarcatalog do begin
   catalog.cfgcat.dblstarcatpath[i]:=slash(appdir)+'cat';
   catalog.cfgcat.dblstarcatdef[i]:=false;
   catalog.cfgcat.dblstarcaton[i]:=false;
   catalog.cfgcat.dblstarcatfield[i,1]:=0;
   catalog.cfgcat.dblstarcatfield[i,2]:=0;
end;
for i:=1 to maxnebcatalog do begin
   catalog.cfgcat.nebcatpath[i]:=slash(appdir)+'cat';
   catalog.cfgcat.nebcatdef[i]:=false;
   catalog.cfgcat.nebcaton[i]:=false;
   catalog.cfgcat.nebcatfield[i,1]:=0;
   catalog.cfgcat.nebcatfield[i,2]:=0;
end;
catalog.cfgcat.nebcatpath[sac-BaseNeb]:=slash(appdir)+'cat'+PathDelim+'sac';
catalog.cfgcat.nebcatdef[sac-BaseNeb]:=true;
catalog.cfgcat.nebcatfield[sac-BaseNeb,2]:=10;
catalog.cfgcat.nebcatpath[ngc-BaseNeb]:=slash(appdir)+'cat'+PathDelim+'ngc2000';
catalog.cfgshr.FieldNum[0]:=0.5;
catalog.cfgshr.FieldNum[1]:=1;
catalog.cfgshr.FieldNum[2]:=2;
catalog.cfgshr.FieldNum[3]:=5;
catalog.cfgshr.FieldNum[4]:=10;
catalog.cfgshr.FieldNum[5]:=15;
catalog.cfgshr.FieldNum[6]:=25;
catalog.cfgshr.FieldNum[7]:=45;
catalog.cfgshr.FieldNum[8]:=90;
catalog.cfgshr.FieldNum[9]:=180;
catalog.cfgshr.FieldNum[10]:=360;
catalog.cfgshr.StarMagFilter[0]:=99;
catalog.cfgshr.StarMagFilter[1]:=99;
catalog.cfgshr.StarMagFilter[2]:=15;
catalog.cfgshr.StarMagFilter[3]:=13;
catalog.cfgshr.StarMagFilter[4]:=12;
catalog.cfgshr.StarMagFilter[5]:=11;
catalog.cfgshr.StarMagFilter[6]:=10;
catalog.cfgshr.StarMagFilter[7]:=9;
catalog.cfgshr.StarMagFilter[8]:=6.5;
catalog.cfgshr.StarMagFilter[9]:=6;
catalog.cfgshr.StarMagFilter[10]:=5;
catalog.cfgshr.NebMagFilter[0]:=99;
catalog.cfgshr.NebMagFilter[1]:=99;
catalog.cfgshr.NebMagFilter[2]:=99;
catalog.cfgshr.NebMagFilter[3]:=99;
catalog.cfgshr.NebMagFilter[4]:=16;
catalog.cfgshr.NebMagFilter[5]:=13;
catalog.cfgshr.NebMagFilter[6]:=11;
catalog.cfgshr.NebMagFilter[7]:=10;
catalog.cfgshr.NebMagFilter[8]:=9;
catalog.cfgshr.NebMagFilter[9]:=6;
catalog.cfgshr.NebMagFilter[10]:=6;
catalog.cfgshr.NebSizeFilter[0]:=0;
catalog.cfgshr.NebSizeFilter[1]:=0;
catalog.cfgshr.NebSizeFilter[2]:=0;
catalog.cfgshr.NebSizeFilter[3]:=1;
catalog.cfgshr.NebSizeFilter[4]:=2;
catalog.cfgshr.NebSizeFilter[5]:=4;
catalog.cfgshr.NebSizeFilter[6]:=6;
catalog.cfgshr.NebSizeFilter[7]:=10;
catalog.cfgshr.NebSizeFilter[8]:=20;
catalog.cfgshr.NebSizeFilter[9]:=30;
catalog.cfgshr.NebSizeFilter[10]:=60;
{ platform specific default values }
{$ifdef linux}
configfile:=expandfilename(Defaultconfigfile);
{$endif}
{$ifdef mswindows}
configfile:=Defaultconfigfile;
{$endif}
end;

procedure Tf_main.ReadDefault;
var i,j:integer;
    inif: TIniFile;
    section,buf : string;
begin
inif:=Tinifile.create(configfile);
try
with inif do begin
section:='util';
u_util.ldeg:=ReadString(section,'ldeg',u_util.ldeg);
u_util.lmin:=ReadString(section,'lmin',u_util.lmin);
u_util.lsec:=ReadString(section,'lsec',u_util.lsec);
section:='main';
cfgm.language:=ReadString(section,'language',cfgm.language);
cfgm.prtname:=ReadString(section,'prtname',cfgm.prtname);
cfgm.PrinterResolution:=ReadInteger(section,'PrinterResolution',cfgm.PrinterResolution);
for i:=0 to MaxField do catalog.cfgshr.FieldNum[i]:=ReadFloat(section,'FieldNum'+inttostr(i),catalog.cfgshr.FieldNum[i]);
f_main.Top := ReadInteger(section,'WinTop',f_main.Top);
f_main.Left := ReadInteger(section,'WinLeft',f_main.Left);
f_main.Width := ReadInteger(section,'WinWidth',f_main.Width);
f_main.Height := ReadInteger(section,'WinHeight',f_main.Height);
if (ReadBool(section,'WinMaximize',false)) then f_main.WindowState:=wsMaximized;
section:='font';
for i:=1 to 6 do begin
   cfgm.FontName[i]:=ReadString(section,'FontName'+inttostr(i),cfgm.FontName[i]);
   cfgm.FontSize[i]:=ReadInteger(section,'FontSize'+inttostr(i),cfgm.FontSize[i]);
   cfgm.FontBold[i]:=ReadBool(section,'FontBold'+inttostr(i),cfgm.FontBold[i]);
   cfgm.FontItalic[i]:=ReadBool(section,'FontItalic'+inttostr(i),cfgm.FontItalic[i]);
end;
section:='filter';
catalog.cfgshr.StarFilter:=ReadBool(section,'StarFilter',catalog.cfgshr.StarFilter);
catalog.cfgshr.AutoStarFilter:=ReadBool(section,'AutoStarFilter',catalog.cfgshr.AutoStarFilter);
catalog.cfgshr.AutoStarFilterMag:=ReadFloat(section,'AutoStarFilterMag',catalog.cfgshr.AutoStarFilterMag);
catalog.cfgshr.NebFilter:=ReadBool(section,'NebFilter',catalog.cfgshr.NebFilter);
catalog.cfgshr.BigNebFilter:=ReadBool(section,'BigNebFilter',catalog.cfgshr.BigNebFilter);
for i:=1 to maxfield do begin
   catalog.cfgshr.StarMagFilter[i]:=ReadFloat(section,'StarMagFilter'+inttostr(i),catalog.cfgshr.StarMagFilter[i]);
   catalog.cfgshr.NebMagFilter[i]:=ReadFloat(section,'NebMagFilter'+inttostr(i),catalog.cfgshr.NebMagFilter[i]);
   catalog.cfgshr.NebSizeFilter[i]:=ReadFloat(section,'NebSizeFilter'+inttostr(i),catalog.cfgshr.NebSizeFilter[i]);
end;
section:='catalog';
catalog.cfgcat.StarmagMax:=ReadFloat(section,'StarmagMax',catalog.cfgcat.StarmagMax);
catalog.cfgcat.NebmagMax:=ReadFloat(section,'NebmagMax',catalog.cfgcat.NebmagMax);
catalog.cfgcat.NebSizeMin:=ReadFloat(section,'NebSizeMin',catalog.cfgcat.NebSizeMin);
catalog.cfgcat.UseUSNOBrightStars:=ReadBool(section,'UseUSNOBrightStars',catalog.cfgcat.UseUSNOBrightStars);
catalog.cfgcat.UseGSVSIr:=ReadBool(section,'UseGSVSIr',catalog.cfgcat.UseGSVSIr);
for i:=1 to maxstarcatalog do begin
   catalog.cfgcat.starcatpath[i]:=ReadString(section,'starcatpath'+inttostr(i),catalog.cfgcat.starcatpath[i]);
   catalog.cfgcat.starcatdef[i]:=ReadBool(section,'starcatdef'+inttostr(i),catalog.cfgcat.starcatdef[i]);
   catalog.cfgcat.starcaton[i]:=ReadBool(section,'starcaton'+inttostr(i),catalog.cfgcat.starcaton[i]);
   catalog.cfgcat.starcatfield[i,1]:=ReadInteger(section,'starcatfield1'+inttostr(i),catalog.cfgcat.starcatfield[i,1]);
   catalog.cfgcat.starcatfield[i,2]:=ReadInteger(section,'starcatfield2'+inttostr(i),catalog.cfgcat.starcatfield[i,2]);
end;
for i:=1 to maxvarstarcatalog do begin
   catalog.cfgcat.varstarcatpath[i]:=ReadString(section,'varstarcatpath'+inttostr(i),catalog.cfgcat.varstarcatpath[i]);
   catalog.cfgcat.varstarcatdef[i]:=ReadBool(section,'varstarcatdef'+inttostr(i),catalog.cfgcat.varstarcatdef[i]);
   catalog.cfgcat.varstarcaton[i]:=ReadBool(section,'varstarcaton'+inttostr(i),catalog.cfgcat.varstarcaton[i]);
   catalog.cfgcat.varstarcatfield[i,1]:=ReadInteger(section,'varstarcatfield1'+inttostr(i),catalog.cfgcat.varstarcatfield[i,1]);
   catalog.cfgcat.varstarcatfield[i,2]:=ReadInteger(section,'varstarcatfield2'+inttostr(i),catalog.cfgcat.varstarcatfield[i,2]);
end;
for i:=1 to maxdblstarcatalog do begin
   catalog.cfgcat.dblstarcatpath[i]:=ReadString(section,'dblstarcatpath'+inttostr(i),catalog.cfgcat.dblstarcatpath[i]);
   catalog.cfgcat.dblstarcatdef[i]:=ReadBool(section,'dblstarcatdef'+inttostr(i),catalog.cfgcat.dblstarcatdef[i]);
   catalog.cfgcat.dblstarcaton[i]:=ReadBool(section,'dblstarcaton'+inttostr(i),catalog.cfgcat.dblstarcaton[i]);
   catalog.cfgcat.dblstarcatfield[i,1]:=ReadInteger(section,'dblstarcatfield1'+inttostr(i),catalog.cfgcat.dblstarcatfield[i,1]);
   catalog.cfgcat.dblstarcatfield[i,2]:=ReadInteger(section,'dblstarcatfield2'+inttostr(i),catalog.cfgcat.dblstarcatfield[i,2]);
end;
for i:=1 to maxnebcatalog do begin
   catalog.cfgcat.nebcatpath[i]:=ReadString(section,'nebcatpath'+inttostr(i),catalog.cfgcat.nebcatpath[i]);
   catalog.cfgcat.nebcatdef[i]:=ReadBool(section,'nebcatdef'+inttostr(i),catalog.cfgcat.nebcatdef[i]);
   catalog.cfgcat.nebcaton[i]:=ReadBool(section,'nebcaton'+inttostr(i),catalog.cfgcat.nebcaton[i]);
   catalog.cfgcat.nebcatfield[i,1]:=ReadInteger(section,'nebcatfield1'+inttostr(i),catalog.cfgcat.nebcatfield[i,1]);
   catalog.cfgcat.nebcatfield[i,2]:=ReadInteger(section,'nebcatfield2'+inttostr(i),catalog.cfgcat.nebcatfield[i,2]);
end;
section:='quicksearch';
j:=ReadInteger(section,'count',0);
for i:=1 to j do quicksearch.Items.Add(ReadString(section,'item'+inttostr(i),''));
section:='display';
def_cfgplot.starplot:=ReadInteger(section,'starplot',def_cfgplot.starplot);
def_cfgplot.nebplot:=ReadInteger(section,'nebplot',def_cfgplot.nebplot);
section:='default_chart';
def_cfgsc.racentre:=ReadFloat(section,'racentre',def_cfgsc.racentre);
def_cfgsc.decentre:=ReadFloat(section,'decentre',def_cfgsc.decentre);
def_cfgsc.fov:=ReadFloat(section,'fov',def_cfgsc.fov);
def_cfgsc.theta:=ReadFloat(section,'theta',def_cfgsc.theta);
buf:=trim(ReadString(section,'projtype',def_cfgsc.projtype))+'A';
def_cfgsc.projtype:=buf[1];
def_cfgsc.ProjPole:=ReadInteger(section,'ProjPole',def_cfgsc.ProjPole);
def_cfgsc.FlipX:=ReadInteger(section,'FlipX',def_cfgsc.FlipX);
def_cfgsc.FlipY:=ReadInteger(section,'FlipY',def_cfgsc.FlipY);
end;
finally
inif.Free;
end;
end;

procedure Tf_main.SaveDefault;
var i:integer;
    inif: TIniFile;
    section : string;
begin
{ save the config file }
inif:=Tinifile.create(configfile);
try
with inif do begin
section:='util';
WriteString(section,'ldeg',u_util.ldeg);
WriteString(section,'lmin',u_util.lmin);
WriteString(section,'lsec',u_util.lsec);
section:='main';
WriteString(section,'language',cfgm.language);
WriteString(section,'prtname',cfgm.prtname);
WriteInteger(section,'PrinterResolution',cfgm.PrinterResolution);
for i:=0 to MaxField do WriteFloat(section,'FieldNum'+inttostr(i),catalog.cfgshr.FieldNum[i]);
WriteInteger(section,'WinTop',f_main.Top);
WriteInteger(section,'WinLeft',f_main.Left);
WriteInteger(section,'WinWidth',f_main.Width);
WriteInteger(section,'WinHeight',f_main.Height);
WriteBool(section,'WinMaximize',(f_main.WindowState=wsMaximized));
section:='font';
for i:=1 to 6 do begin
    WriteString(section,'FontName'+inttostr(i),cfgm.FontName[i]);
    WriteInteger(section,'FontSize'+inttostr(i),cfgm.FontSize[i]);
    WriteBool(section,'FontBold'+inttostr(i),cfgm.FontBold[i]);
    WriteBool(section,'FontItalic'+inttostr(i),cfgm.FontItalic[i]);
end;
section:='filter';
WriteBool(section,'StarFilter',catalog.cfgshr.StarFilter);
WriteBool(section,'AutoStarFilter',catalog.cfgshr.AutoStarFilter);
WriteFloat(section,'AutoStarFilterMag',catalog.cfgshr.AutoStarFilterMag);
WriteBool(section,'NebFilter',catalog.cfgshr.NebFilter);
WriteBool(section,'BigNebFilter',catalog.cfgshr.BigNebFilter);
for i:=1 to maxfield do begin
   WriteFloat(section,'StarMagFilter'+inttostr(i),catalog.cfgshr.StarMagFilter[i]);
   WriteFloat(section,'NebMagFilter'+inttostr(i),catalog.cfgshr.NebMagFilter[i]);
   WriteFloat(section,'NebSizeFilter'+inttostr(i),catalog.cfgshr.NebSizeFilter[i]);
end;
section:='catalog';
WriteFloat(section,'StarmagMax',catalog.cfgcat.StarmagMax);
WriteFloat(section,'NebmagMax',catalog.cfgcat.NebmagMax);
WriteFloat(section,'NebSizeMin',catalog.cfgcat.NebSizeMin);
WriteBool(section,'UseUSNOBrightStars',catalog.cfgcat.UseUSNOBrightStars);
WriteBool(section,'UseGSVSIr',catalog.cfgcat.UseGSVSIr);
for i:=1 to maxstarcatalog do begin
   WriteString(section,'starcatpath'+inttostr(i),catalog.cfgcat.starcatpath[i]);
   WriteBool(section,'starcatdef'+inttostr(i),catalog.cfgcat.starcatdef[i]);
   WriteBool(section,'starcaton'+inttostr(i),catalog.cfgcat.starcaton[i]);
   WriteInteger(section,'starcatfield1'+inttostr(i),catalog.cfgcat.starcatfield[i,1]);
   WriteInteger(section,'starcatfield2'+inttostr(i),catalog.cfgcat.starcatfield[i,2]);
end;
for i:=1 to maxvarstarcatalog do begin
   WriteString(section,'varstarcatpath'+inttostr(i),catalog.cfgcat.varstarcatpath[i]);
   WriteBool(section,'varstarcatdef'+inttostr(i),catalog.cfgcat.varstarcatdef[i]);
   WriteBool(section,'varstarcaton'+inttostr(i),catalog.cfgcat.varstarcaton[i]);
   WriteInteger(section,'varstarcatfield1'+inttostr(i),catalog.cfgcat.varstarcatfield[i,1]);
   WriteInteger(section,'varstarcatfield2'+inttostr(i),catalog.cfgcat.varstarcatfield[i,2]);
end;
for i:=1 to maxdblstarcatalog do begin
   WriteString(section,'dblstarcatpath'+inttostr(i),catalog.cfgcat.dblstarcatpath[i]);
   WriteBool(section,'dblstarcatdef'+inttostr(i),catalog.cfgcat.dblstarcatdef[i]);
   WriteBool(section,'dblstarcaton'+inttostr(i),catalog.cfgcat.dblstarcaton[i]);
   WriteInteger(section,'dblstarcatfield1'+inttostr(i),catalog.cfgcat.dblstarcatfield[i,1]);
   WriteInteger(section,'dblstarcatfield2'+inttostr(i),catalog.cfgcat.dblstarcatfield[i,2]);
end;
for i:=1 to maxnebcatalog do begin
   WriteString(section,'nebcatpath'+inttostr(i),catalog.cfgcat.nebcatpath[i]);
   WriteBool(section,'nebcatdef'+inttostr(i),catalog.cfgcat.nebcatdef[i]);
   WriteBool(section,'nebcaton'+inttostr(i),catalog.cfgcat.nebcaton[i]);
   WriteInteger(section,'nebcatfield1'+inttostr(i),catalog.cfgcat.nebcatfield[i,1]);
   WriteInteger(section,'nebcatfield2'+inttostr(i),catalog.cfgcat.nebcatfield[i,2]);
end;
section:='quicksearch';
WriteInteger(section,'count',quicksearch.Items.count);
for i:=1 to quicksearch.Items.count do WriteString(section,'item'+inttostr(i),quicksearch.Items[i-1]);
section:='display';
WriteInteger(section,'starplot',def_cfgplot.starplot);
WriteInteger(section,'nebplot',def_cfgplot.nebplot);
section:='default_chart';
if ActiveMDIchild is Tf_chart then with ActiveMDIchild as Tf_chart do begin
  def_cfgsc:=sc.cfgsc;
end;
WriteFloat(section,'racentre',def_cfgsc.racentre);
WriteFloat(section,'decentre',def_cfgsc.decentre);
WriteFloat(section,'fov',def_cfgsc.fov);
WriteFloat(section,'theta',def_cfgsc.theta);
WriteString(section,'projtype',def_cfgsc.projtype);
WriteInteger(section,'ProjPole',def_cfgsc.ProjPole);
WriteInteger(section,'FlipX',def_cfgsc.FlipX);
WriteInteger(section,'FlipY',def_cfgsc.FlipY);
end;
finally
 inif.Free;
end;
end;

procedure Tf_main.quicksearchClick(Sender: TObject);
var key:word;
begin
 key:=key_cr;
 quicksearchKeyDown(Sender,key,[]);
end;

procedure Tf_main.quicksearchKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var ar1,de1 : Double;
    ok : Boolean;
    num,buf,desc,notes : string;
    i : integer;
label findit;
begin
if key<>key_cr then exit;  // wait press Enter
if ActiveMdiChild is Tf_chart then with ActiveMdiChild as Tf_chart do begin
   Num:=trim(quicksearch.text);
   if trim(num)='' then exit;
   if uppercase(copy(Num,1,1))='M' then begin
      buf:=StringReplace(Num,'m','',[rfReplaceAll,rfIgnoreCase]);
      ok:=catalog.FindNum(S_messier,buf,ar1,de1) ;
      if ok then goto findit;
   end;
   if uppercase(copy(Num,1,3))='NGC' then begin
      buf:=StringReplace(Num,'ngc','',[rfReplaceAll,rfIgnoreCase]);
      ok:=catalog.FindNum(S_NGC,buf,ar1,de1) ;
      if ok then goto findit;
   end;
   if uppercase(copy(Num,1,2))='IC' then begin
      buf:=StringReplace(Num,'ic','',[rfReplaceAll,rfIgnoreCase]);
      ok:=catalog.FindNum(S_IC,buf,ar1,de1) ;
      if ok then goto findit;
   end;
   if uppercase(copy(Num,1,3))='PGC' then begin
      buf:=StringReplace(Num,'pgc','',[rfReplaceAll,rfIgnoreCase]);
      ok:=catalog.FindNum(S_PGC,buf,ar1,de1) ;
      if ok then goto findit;
   end;
   if uppercase(copy(Num,1,2))='GC' then begin
      buf:=StringReplace(Num,'gc','',[rfReplaceAll,rfIgnoreCase]);
      ok:=catalog.FindNum(S_GC,buf,ar1,de1) ;
      if ok then goto findit;
   end;
   if uppercase(copy(Num,1,3))='GSC' then begin
      buf:=StringReplace(Num,'gsc','',[rfReplaceAll,rfIgnoreCase]);
      ok:=catalog.FindNum(S_GSC,buf,ar1,de1) ;
      if ok then goto findit;
   end;
   if uppercase(copy(Num,1,3))='TYC' then begin
      buf:=StringReplace(Num,'tyc','',[rfReplaceAll,rfIgnoreCase]);
      ok:=catalog.FindNum(S_TYC2,buf,ar1,de1) ;
      if ok then goto findit;
   end;
   if uppercase(copy(Num,1,3))='SAO' then begin
      buf:=StringReplace(Num,'sao','',[rfReplaceAll,rfIgnoreCase]);
      ok:=catalog.FindNum(S_SAO,buf,ar1,de1) ;
      if ok then goto findit;
   end;
   if uppercase(copy(Num,1,2))='HD' then begin
      buf:=StringReplace(Num,'hd','',[rfReplaceAll,rfIgnoreCase]);
      ok:=catalog.FindNum(S_HD,buf,ar1,de1) ;
      if ok then goto findit;
   end;
   if uppercase(copy(Num,1,2))='BD' then begin
      buf:=StringReplace(Num,'bd','',[rfReplaceAll,rfIgnoreCase]);
      ok:=catalog.FindNum(S_BD,buf,ar1,de1) ;
      if ok then goto findit;
   end;
   if uppercase(copy(Num,1,2))='CD' then begin
      buf:=StringReplace(Num,'cd','',[rfReplaceAll,rfIgnoreCase]);
      ok:=catalog.FindNum(S_CD,buf,ar1,de1) ;
      if ok then goto findit;
   end;
   if uppercase(copy(Num,1,3))='CPD' then begin
      buf:=StringReplace(Num,'cpd','',[rfReplaceAll,rfIgnoreCase]);
      ok:=catalog.FindNum(S_CPD,buf,ar1,de1) ;
      if ok then goto findit;
   end;
   if uppercase(copy(Num,1,2))='HR' then begin
      buf:=StringReplace(Num,'hr','',[rfReplaceAll,rfIgnoreCase]);
      ok:=catalog.FindNum(S_HR,buf,ar1,de1) ;
      if ok then goto findit;
   end;
{   for i:=1 to 11 do begin
     if (uppercase(trim(Num))=uppercase(trim(pla[i]))) then begin
         FindNumPla(i,ar1,de1,ok);
         if ok and beingfollow then begin
               FollowOn:=true;
               FollowType:=1;
               FollowObj:=i;
         end;
         break;
     end;
   end;
   if ok then goto findit;
   buf:=trim(uppercase(num));
   j:=length(buf);
   if j>3 then for i:=1 to CometNb do begin
     if uppercase(copy(CometNLst[i],1,j))=buf then begin
         Findnumcom(i,ar1,de1,ok);
         if ok and beingfollow then begin
               FollowOn:=true;
               FollowType:=2;
               FollowObj:=i;
         end;
         break;
     end;
   end;
   if ok then goto findit;  }
   if fileexists(slash(catalog.cfgcat.VarStarCatPath[gcvs-BaseVar])+'gcvs.idx') then begin
      ok:=catalog.FindNum(S_GCVS,buf,ar1,de1) ;
      if ok then goto findit;
   end;
   ok:=catalog.FindNum(S_SAC,buf,ar1,de1) ;
   if ok then goto findit;
   ok:=catalog.FindNum(S_Bayer,buf,ar1,de1) ;
   if ok then goto findit;
   ok:=catalog.FindNum(S_Flam,buf,ar1,de1) ;
   if ok then goto findit;
   if fileexists(slash(catalog.cfgcat.DblStarCatPath[wds-BaseDbl])+'wds.idx') then begin
      ok:=catalog.FindNum(S_WDS,buf,ar1,de1) ;
      if ok then goto findit;
   end;
   ok:=catalog.FindNum(S_Gcat,buf,ar1,de1) ;
   if ok then goto findit;
   ok:=catalog.FindNum(S_Ext,buf,ar1,de1) ;
   if ok then goto findit;
Findit:
   if ok then begin
      sc.movetoradec(ar1,de1);
      Refresh;
      sc.FindatRaDec(ar1,de1,0.0001,desc,notes);
      f_main.SetLpanel1(desc);
      i:=quicksearch.Items.IndexOf(Num);
      if i=-1 then i:=MaxQuickSearch-1;
      quicksearch.Items.Delete(i);
      quicksearch.Items.Insert(0,Num);
      quicksearch.ItemIndex:=0;
   end
   else begin
      ShowMessage('Not found'+' '+Num);
   end;
end;
end;

procedure Tf_main.UpdateBtn(fx,fy:integer);
begin
  if fx>0 then FlipButtonX.ImageIndex:=15
          else FlipButtonX.ImageIndex:=16;
  if fy>0 then FlipButtonY.ImageIndex:=17
          else FlipButtonY.ImageIndex:=18;
end;


