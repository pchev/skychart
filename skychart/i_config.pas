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
 Cross-platform common code for Config form.
}

procedure Tf_config.SetLang(lang:string);
var i,n: integer;
begin
n:=minintvalue([TreeView1.Items.Count,PageControl1.PageCount]);
for i:=0 to n-1 do begin
  PageControl1.Pages[i].Caption:=TreeView1.Items[i].Text;
end;
end;

function Tf_config.SelectPage(txt:string):boolean;
var i: integer;
begin
result:=false;
for i:=0 to PageControl1.PageCount-1 do
  if PageControl1.Pages[i].Caption=txt then begin
     PageControl1.ActivePageIndex:=i;
     result:=true;
  end;
end;

procedure Tf_config.TreeView1Change(Sender: TObject; Node: TTreeNode);
begin
 SelectPage(node.Text);
end;

procedure Tf_config.FormCreate(Sender: TObject);
begin
SetLang('');
end;

procedure Tf_config.FormShow(Sender: TObject);
begin
ShowField;
ShowFilter;
ShowCDCStar;
ShowCDCNeb;
ShowFonts;
ShowDisplay;
TreeView1.FullExpand;
Treeview1.selected:=Treeview1.items[cmain.configpage];
end;

procedure Tf_config.ShowCDCNeb;
begin
sacbox.Checked:=ccat.NebCatDef[sac-BaseNeb];
ngcbox.Checked:=ccat.NebCatDef[ngc-BaseNeb];
lbnbox.Checked:=ccat.NebCatDef[lbn-BaseNeb];
rc3box.Checked:=ccat.NebCatDef[rc3-BaseNeb];
pgcbox.Checked:=ccat.NebCatDef[pgc-BaseNeb];
oclbox.Checked:=ccat.NebCatDef[ocl-BaseNeb];
gcmbox.Checked:=ccat.NebCatDef[gcm-BaseNeb];
gpnbox.Checked:=ccat.NebCatDef[gpn-BaseNeb];
fsac1.Value:=ccat.NebCatField[sac-BaseNeb,1];
fngc1.Value:=ccat.NebCatField[ngc-BaseNeb,1];
flbn1.Value:=ccat.NebCatField[lbn-BaseNeb,1];
frc31.Value:=ccat.NebCatField[rc3-BaseNeb,1];
fpgc1.Value:=ccat.NebCatField[pgc-BaseNeb,1];
focl1.Value:=ccat.NebCatField[ocl-BaseNeb,1];
fgcm1.Value:=ccat.NebCatField[gcm-BaseNeb,1];
fgpn1.Value:=ccat.NebCatField[gpn-BaseNeb,1];
fsac2.Value:=ccat.NebCatField[sac-BaseNeb,2];
fngc2.Value:=ccat.NebCatField[ngc-BaseNeb,2];
flbn2.Value:=ccat.NebCatField[lbn-BaseNeb,2];
frc32.Value:=ccat.NebCatField[rc3-BaseNeb,2];
fpgc2.Value:=ccat.NebCatField[pgc-BaseNeb,2];
focl2.Value:=ccat.NebCatField[ocl-BaseNeb,2];
fgcm2.Value:=ccat.NebCatField[gcm-BaseNeb,2];
fgpn2.Value:=ccat.NebCatField[gpn-BaseNeb,2];
sac3.Text:=ccat.NebCatPath[sac-BaseNeb];
ngc3.Text:=ccat.NebCatPath[ngc-BaseNeb];
lbn3.Text:=ccat.NebCatPath[lbn-BaseNeb];
rc33.Text:=ccat.NebCatPath[rc3-BaseNeb];
pgc3.Text:=ccat.NebCatPath[pgc-BaseNeb];
ocl3.Text:=ccat.NebCatPath[ocl-BaseNeb];
gcm3.Text:=ccat.NebCatPath[gcm-BaseNeb];
gpn3.Text:=ccat.NebCatPath[gpn-BaseNeb];
end;

procedure Tf_config.ShowCDCStar;
begin
bscbox.Checked:=ccat.StarCatDef[bsc-BaseStar];
skybox.Checked:=ccat.StarCatDef[sky2000-BaseStar];
tycbox.Checked:=ccat.StarCatDef[tyc-BaseStar];
ty2box.Checked:=ccat.StarCatDef[tyc2-BaseStar];
ticbox.Checked:=ccat.StarCatDef[tic-BaseStar];
gscfbox.Checked:=ccat.StarCatDef[gscf-BaseStar];
gsccbox.Checked:=ccat.StarCatDef[gscc-BaseStar];
gscbox.Checked:=ccat.StarCatDef[gsc-BaseStar];
usnbox.Checked:=ccat.StarCatDef[usnoa-BaseStar];
usnbright.Checked:=ccat.UseUSNOBrightStars;
mctbox.Checked:=ccat.StarCatDef[microcat-BaseStar];
gcvbox.Checked:=ccat.VarStarCatDef[gcvs-BaseVar];
irvar.Checked:=ccat.UseGSVSIr;
wdsbox.Checked:=ccat.DblStarCatDef[wds-BaseDbl];
dsbasebox.Checked:=ccat.StarCatDef[dsbase-BaseStar];
dstycbox.Checked:=ccat.StarCatDef[dstyc-BaseStar];
dsgscbox.Checked:=ccat.StarCatDef[dsgsc-BaseStar];
fbsc1.Value:=ccat.StarCatField[bsc-BaseStar,1];
fbsc2.Value:=ccat.StarCatField[bsc-BaseStar,2];
fsky1.Value:=ccat.StarCatField[sky2000-BaseStar,1];
fsky2.Value:=ccat.StarCatField[sky2000-BaseStar,2];
ftyc1.Value:=ccat.StarCatField[tyc-BaseStar,1];
ftyc2.Value:=ccat.StarCatField[tyc-BaseStar,2];
fty21.Value:=ccat.StarCatField[tyc2-BaseStar,1];
fty22.Value:=ccat.StarCatField[tyc2-BaseStar,2];
ftic1.Value:=ccat.StarCatField[tic-BaseStar,1];
ftic2.Value:=ccat.StarCatField[tic-BaseStar,2];
fgscf1.Value:=ccat.StarCatField[gscf-BaseStar,1];
fgscf2.Value:=ccat.StarCatField[gscf-BaseStar,2];
fgscc1.Value:=ccat.StarCatField[gscc-BaseStar,1];
fgscc2.Value:=ccat.StarCatField[gscc-BaseStar,2];
fgsc1.Value:=ccat.StarCatField[gsc-BaseStar,1];
fgsc2.Value:=ccat.StarCatField[gsc-BaseStar,2];
fusn1.Value:=ccat.StarCatField[usnoa-BaseStar,1];
fusn2.Value:=ccat.StarCatField[usnoa-BaseStar,2];
fmct1.Value:=ccat.StarCatField[microcat-BaseStar,1];
fmct2.Value:=ccat.StarCatField[microcat-BaseStar,2];
fgcv1.Value:=ccat.VarStarCatField[gcvs-BaseVar,1];
fgcv2.Value:=ccat.VarStarCatField[gcvs-BaseVar,2];
fwds1.Value:=ccat.DblStarCatField[wds-BaseDbl,1];
fwds2.Value:=ccat.DblStarCatField[wds-BaseDbl,2];
dsbase1.Value:=ccat.StarCatField[dsbase-BaseStar,1];
dsbase2.Value:=ccat.StarCatField[dsbase-BaseStar,2];
dstyc1.Value:=ccat.StarCatField[dstyc-BaseStar,1];
dstyc2.Value:=ccat.StarCatField[dstyc-BaseStar,2];
dsgsc1.Value:=ccat.StarCatField[dsgsc-BaseStar,1];
dsgsc2.Value:=ccat.StarCatField[dsgsc-BaseStar,2];
bsc3.Text:=ccat.StarCatPath[bsc-BaseStar];
sky3.Text:=ccat.StarCatPath[sky2000-BaseStar];
tyc3.Text:=ccat.StarCatPath[tyc-BaseStar];
ty23.Text:=ccat.StarCatPath[tyc2-BaseStar];
tic3.Text:=ccat.StarCatPath[tic-BaseStar];
gscf3.Text:=ccat.StarCatPath[gscf-BaseStar];
gscc3.Text:=ccat.StarCatPath[gscc-BaseStar];
gsc3.Text:=ccat.StarCatPath[gsc-BaseStar];
usn3.Text:=ccat.StarCatPath[usnoa-BaseStar];
mct3.Text:=ccat.StarCatPath[microcat-BaseStar];
gcv3.Text:=ccat.VarStarCatPath[gcvs-BaseVar];
wds3.Text:=ccat.DblStarCatPath[wds-BaseDbl];
dsbase3.Text:=ccat.StarCatPath[dsbase-BaseStar];
dstyc3.Text:=ccat.StarCatPath[dstyc-BaseStar];
dsgsc3.Text:=ccat.StarCatPath[dsgsc-BaseStar];
end;

procedure Tf_config.ShowFilter;
begin
starbox.Checked:=cshr.StarFilter;
StarAutoBox.Checked:=cshr.AutoStarFilter;
fsmagvis.Value:=cshr.AutoStarFilterMag;
fsmag0.Value:=cshr.StarMagFilter[0];
fsmag1.Value:=cshr.StarMagFilter[1];
fsmag2.Value:=cshr.StarMagFilter[2];
fsmag3.Value:=cshr.StarMagFilter[3];
fsmag4.Value:=cshr.StarMagFilter[4];
fsmag5.Value:=cshr.StarMagFilter[5];
fsmag6.Value:=cshr.StarMagFilter[6];
fsmag7.Value:=cshr.StarMagFilter[7];
fsmag8.Value:=cshr.StarMagFilter[8];
fsmag9.Value:=cshr.StarMagFilter[9];
nebbox.Checked:=cshr.NebFilter;
bignebbox.Checked:=cshr.BigNebFilter;
fmag0.Value:=cshr.NebMagFilter[0];
fmag1.Value:=cshr.NebMagFilter[1];
fmag2.Value:=cshr.NebMagFilter[2];
fmag3.Value:=cshr.NebMagFilter[3];
fmag4.Value:=cshr.NebMagFilter[4];
fmag5.Value:=cshr.NebMagFilter[5];
fmag6.Value:=cshr.NebMagFilter[6];
fmag7.Value:=cshr.NebMagFilter[7];
fmag8.Value:=cshr.NebMagFilter[8];
fmag9.Value:=cshr.NebMagFilter[9];
fdim0.Value:=cshr.NebSizeFilter[0];
fdim1.Value:=cshr.NebSizeFilter[1];
fdim2.Value:=cshr.NebSizeFilter[2];
fdim3.Value:=cshr.NebSizeFilter[3];
fdim4.Value:=cshr.NebSizeFilter[4];
fdim5.Value:=cshr.NebSizeFilter[5];
fdim6.Value:=cshr.NebSizeFilter[6];
fdim7.Value:=cshr.NebSizeFilter[7];
fdim8.Value:=cshr.NebSizeFilter[8];
fdim9.Value:=cshr.NebSizeFilter[9];
panel4.Visible:=cshr.StarFilter;
panel3.visible:=cshr.AutoStarFilter;
panel2.Visible:=not cshr.AutoStarFilter;
Panel5.visible:=cshr.NebFilter;
BigNebBox.visible:=cshr.NebFilter;
end;

procedure Tf_config.ShowField;
begin
fw0.Value:=cshr.fieldnum[0];
fw1.Value:=cshr.fieldnum[1];
fw2.Value:=cshr.fieldnum[2];
fw3.Value:=cshr.fieldnum[3];
fw4.Value:=cshr.fieldnum[4];
fw5.Value:=cshr.fieldnum[5];
fw6.Value:=cshr.fieldnum[6];
fw7.Value:=cshr.fieldnum[7];
fw8.Value:=cshr.fieldnum[8];
fw9.Value:=cshr.fieldnum[9];
end;

procedure Tf_config.SetFonts(ctrl:Tedit;num:integer);
begin
 ctrl.Text:=cmain.FontName[num];
 ctrl.Font.Name:=cmain.FontName[num];
 ctrl.Font.Size:=cmain.FontSize[num];
 if cmain.FontBold[num] then ctrl.Font.Style:=[fsBold]
                        else ctrl.Font.Style:=[];
 if cmain.FontItalic[num] then ctrl.Font.Style:=ctrl.Font.Style+[fsItalic];
end;

procedure Tf_config.ShowFonts;
begin
 SetFonts(gridfont,1);
 SetFonts(labelfont,2);
 SetFonts(legendfont,3);
 SetFonts(statusfont,4);
 SetFonts(listfont,5);
 SetFonts(prtfont,6);
end;

procedure Tf_config.ShowDisplay;
begin
 stardisplay.itemindex:=cplot.starplot;
 nebuladisplay.itemindex:=cplot.nebplot;
end;

procedure Tf_config.SelectFontClick(Sender: TObject);
var i : integer;
begin
if sender is Tspeedbutton then with sender as Tspeedbutton do i:=tag
   else exit;
Fontdialog1.Font.Name:=cmain.FontName[i];
Fontdialog1.Font.Size:=cmain.FontSize[i];
if cmain.FontBold[i] then Fontdialog1.Font.Style:=[fsBold]
                     else Fontdialog1.Font.Style:=[];
if cmain.FontItalic[i] then Fontdialog1.Font.Style:=Fontdialog1.Font.Style+[fsItalic];
if Fontdialog1.Execute then begin
   cmain.FontName[i]:=Fontdialog1.Font.Name;
   cmain.FontSize[i]:=Fontdialog1.Font.Size;
   cmain.FontBold[i]:=fsBold in Fontdialog1.Font.Style;
   cmain.FontItalic[i]:=fsItalic in Fontdialog1.Font.Style;
end;
ShowFonts;
end;

procedure Tf_config.DefaultFontClick(Sender: TObject);
var i : integer;
begin
for i:=1 to 6 do begin
    cmain.FontName[i]:=DefaultFontName;
    cmain.FontSize[i]:=DefaultFontSize;
    cmain.FontBold[i]:=false;
    cmain.FontItalic[i]:=false;
end;
ShowFonts;
end;

procedure Tf_config.FWChange(Sender: TObject);
begin
if sender is TFloatEdit then with sender as TFloatEdit do begin
  cshr.fieldnum[tag]:=Value;
end;
end;

procedure Tf_config.CDCStarSelClick(Sender: TObject);
begin
if sender is TCheckBox then with sender as TCheckBox do begin
  ccat.StarCatDef[tag]:=Checked;
end;
end;

procedure Tf_config.CDCStarField1Change(Sender: TObject);
begin
if sender is TLongEdit then with sender as TLongEdit do begin
  ccat.StarCatField[tag,1]:=Value;
end;
end;

procedure Tf_config.CDCStarField2Change(Sender: TObject);
begin
if sender is TLongEdit then with sender as TLongEdit do begin
  ccat.StarCatField[tag,2]:=Value;
end;
end;

procedure Tf_config.CDCStarPathChange(Sender: TObject);
begin
if sender is TEdit then with sender as TEdit do begin
  if f_main.catalog.checkpath(tag+BaseStar,text) then begin
     ccat.StarCatPath[tag]:=Text;
     color:=clWindow;
  end else color:=clRed;
end;
end;

procedure Tf_config.CDCStarSelPathClick(Sender: TObject);
begin
if sender is TBitBtn then with sender as TBitBtn do begin
{$ifdef mswindows}
  FolderDialog1.Directory:=ccat.StarCatPath[tag];
  if FolderDialog1.execute then
     ccat.StarCatPath[tag]:=FolderDialog1.Directory;
{$endif}
{$ifdef linux }
  f_directory.DirectoryTreeView1.Directory:=ccat.StarCatPath[tag];
  f_directory.showmodal;
  if f_directory.modalresult=mrOK then
     ccat.StarCatPath[tag]:=f_directory.DirectoryTreeView1.Directory;
{$endif}
  ShowCDCStar;
end;
end;

procedure Tf_config.StarBoxClick(Sender: TObject);
begin
cshr.StarFilter:=StarBox.Checked;
panel4.Visible:=cshr.StarFilter;
end;

procedure Tf_config.StarAutoBoxClick(Sender: TObject);
begin
cshr.AutoStarFilter:=StarAutoBox.Checked;
panel3.visible:=cshr.AutoStarFilter;
panel2.Visible:=not cshr.AutoStarFilter;
end;

procedure Tf_config.NebBoxClick(Sender: TObject);
begin
cshr.NebFilter:=NebBox.Checked;
Panel5.visible:=cshr.NebFilter;
BigNebBox.visible:=cshr.NebFilter;
end;

procedure Tf_config.BigNebBoxClick(Sender: TObject);
begin
cshr.BigNebFilter:=bignebbox.Checked;
end;

procedure Tf_config.fsmagvisChange(Sender: TObject);
begin
cshr.AutoStarFilterMag:=fsmagvis.Value;
end;

procedure Tf_config.fsmagChange(Sender: TObject);
begin
if sender is TFloatEdit then with sender as TFloatEdit do begin
  cshr.StarMagFilter[tag]:=Value;
end;
end;

procedure Tf_config.fmagChange(Sender: TObject);
begin
if sender is TFloatEdit then with sender as TFloatEdit do begin
  cshr.NebMagFilter[tag]:=Value;
end;
end;

procedure Tf_config.fdimChange(Sender: TObject);
begin
if sender is TFloatEdit then with sender as TFloatEdit do begin
  cshr.NebSizeFilter[tag]:=Value;
end;
end;

procedure Tf_config.CDCNebSelPathClick(Sender: TObject);
begin
if sender is TBitBtn then with sender as TBitBtn do begin
{$ifdef mswindows}
  FolderDialog1.Directory:=ccat.NebCatPath[tag];
  if FolderDialog1.execute then
     ccat.NebCatPath[tag]:=FolderDialog1.Directory;
{$endif}
{$ifdef linux }
  f_directory.DirectoryTreeView1.Directory:=ccat.NebCatPath[tag];
  f_directory.showmodal;
  if f_directory.modalresult=mrOK then
     ccat.NebCatPath[tag]:=f_directory.DirectoryTreeView1.Directory;
{$endif}
  ShowCDCNeb;
end;
end;

procedure Tf_config.CDCNebSelClick(Sender: TObject);
begin
if sender is TCheckBox then with sender as TCheckBox do begin
  ccat.NebCatDef[tag]:=Checked;
end;
end;

procedure Tf_config.CDCNebField1Change(Sender: TObject);
begin
if sender is TLongEdit then with sender as TLongEdit do begin
  ccat.NebCatField[tag,1]:=Value;
end;
end;

procedure Tf_config.CDCNebField2Change(Sender: TObject);
begin
if sender is TLongEdit then with sender as TLongEdit do begin
  ccat.NebCatField[tag,2]:=Value;
end;
end;

procedure Tf_config.CDCNebPathChange(Sender: TObject);
begin
if sender is TEdit then with sender as TEdit do begin
  if f_main.catalog.checkpath(tag+BaseNeb,text) then begin
     ccat.NebCatPath[tag]:=Text;
     color:=clWindow;
  end else color:=clRed;
end;
end;

procedure Tf_config.USNBrightClick(Sender: TObject);
begin
ccat.UseUSNOBrightStars:=usnbright.Checked;
end;

procedure Tf_config.IRVarClick(Sender: TObject);
begin
ccat.UseGSVSIr:=irvar.Checked;
end;

procedure Tf_config.GCVBoxClick(Sender: TObject);
begin
ccat.VarStarCatDef[gcvs-BaseVar]:=GCVBox.Checked;
end;

procedure Tf_config.Fgcv1Change(Sender: TObject);
begin
ccat.VarStarCatField[gcvs-BaseVar,1]:=Fgcv1.Value;
end;

procedure Tf_config.Fgcv2Change(Sender: TObject);
begin
ccat.VarStarCatField[gcvs-BaseVar,2]:=Fgcv2.Value;
end;

procedure Tf_config.gcv3Change(Sender: TObject);
begin
if f_main.catalog.checkpath(gcvs,gcv3.text) then begin
   ccat.VarStarCatPath[gcvs-BaseVar]:=gcv3.Text;
   gcv3.color:=clWindow;
end else gcv3.color:=clRed;
end;

procedure Tf_config.BitBtn14Click(Sender: TObject);
begin
{$ifdef mswindows}
  FolderDialog1.Directory:=ccat.VarStarCatPath[gcvs-BaseVar];
  if FolderDialog1.execute then
     ccat.VarStarCatPath[gcvs-BaseVar]:=FolderDialog1.Directory;
{$endif}
{$ifdef linux }
  f_directory.DirectoryTreeView1.Directory:=ccat.VarStarCatPath[gcvs-BaseVar];
  f_directory.showmodal;
  if f_directory.modalresult=mrOK then
     ccat.VarStarCatPath[gcvs-BaseVar]:=f_directory.DirectoryTreeView1.Directory;
{$endif}
  ShowCDCStar;
end;

procedure Tf_config.WDSboxClick(Sender: TObject);
begin
ccat.DblStarCatDef[wds-BaseDbl]:=WDSbox.Checked;
end;

procedure Tf_config.Fwds1Change(Sender: TObject);
begin
ccat.DblStarCatField[wds-BaseDbl,1]:=Fwds1.Value;
end;

procedure Tf_config.Fwds2Change(Sender: TObject);
begin
ccat.DblStarCatField[wds-BaseDbl,2]:=Fwds2.Value;
end;

procedure Tf_config.wds3Change(Sender: TObject);
begin
if f_main.catalog.checkpath(wds,wds3.text) then begin
   ccat.DblStarCatPath[wds-BaseDbl]:=wds3.Text;
   wds3.color:=clWindow;
end else wds3.color:=clRed;
end;

procedure Tf_config.BitBtn15Click(Sender: TObject);
begin
{$ifdef mswindows}
  FolderDialog1.Directory:=ccat.DblStarCatPath[wds-BaseDbl];
  if FolderDialog1.execute then
     ccat.DblStarCatPath[wds-BaseDbl]:=FolderDialog1.Directory;
{$endif}
{$ifdef linux }
  f_directory.DirectoryTreeView1.Directory:=ccat.DblStarCatPath[wds-BaseDbl];
  f_directory.showmodal;
  if f_directory.modalresult=mrOK then
     ccat.DblStarCatPath[wds-BaseDbl]:=f_directory.DirectoryTreeView1.Directory;
{$endif}
  ShowCDCStar;
end;

procedure Tf_config.stardisplayClick(Sender: TObject);
begin
 cplot.starplot:=stardisplay.itemindex;
end;

procedure Tf_config.nebuladisplayClick(Sender: TObject);
begin
 cplot.nebplot:=nebuladisplay.itemindex;
end;


