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

procedure Tf_config.TreeView1Change(Sender: TObject; Node: TTreeNode);
var i: integer;
begin
 i:=node.AbsoluteIndex;
 if (PageControl1.ActivePageIndex<>i)and(i<PageControl1.PageCount) then PageControl1.ActivePageIndex:=i;
 case PageControl1.ActivePage.Tag of
  1 : ShowProjection;
 end;
end;

procedure Tf_config.nextClick(Sender: TObject);
begin
 if PageControl1.ActivePageIndex<PageControl1.PageCount-2 then // kylix bug? look at the last page
    Treeview1.selected:=Treeview1.items[PageControl1.ActivePageIndex+1];
Treeview1.selected.expand(true);
end;

procedure Tf_config.previousClick(Sender: TObject);
begin
 while PageControl1.ActivePageIndex>0 do begin
    Treeview1.selected:=Treeview1.items[PageControl1.ActivePageIndex-1];
    if Treeview1.selected.level=0 then break;
 end;
Treeview1.selected.expand(true);
end;

procedure Tf_config.PageControl1Change(Sender: TObject);
begin
 Treeview1.selected:=Treeview1.items[PageControl1.ActivePageIndex];
end;

procedure Tf_config.FormCreate(Sender: TObject);
var i : integer;
begin
SetLang('');
LibCities := LoadLibrary(citylib);
if (LibCities>0) then begin
   @SetDirectory     := GetProcAddress (LibCities, 'SetDirectory');
   @ReadCountryFile  := GetProcAddress (LibCities, 'ReadCountryFile');
   @AddCity          := GetProcAddress (LibCities, 'AddCity');
   @ModifyCity       := GetProcAddress (LibCities, 'ModifyCity');
   @RemoveCity       := GetProcAddress (LibCities, 'RemoveCity');
   @ReleaseCities    := GetProcAddress (LibCities, 'ReleaseCities');
   @SearchCity       := GetProcAddress (LibCities, 'SearchCity');
end;
for i:=0 to COUNTRIES-1 do
  countrylist.Items.Add(Country[i]);
actual_country:='';
end;

procedure Tf_config.FormShow(Sender: TObject);
begin
screen.cursor:=crHourGlass;
ShowTime;
ShowChart;
ShowField;
ShowFilter;
ShowGridSpacing;
ShowCDCStar;
ShowCDCNeb;
ShowFonts;
ShowDisplay;
ShowGCat;
ShowPlanet;
ShowLine;
ShowColor;
ShowSkyColor;
ShowServer;
ShowObservatory;
ShowHorizon;
ShowObjList;
TreeView1.TopItem.Expand(false);
Treeview1.selected:=Treeview1.items[cmain.configpage];
screen.cursor:=crDefault;
end;

procedure Tf_config.ShowServer;
begin
ipaddr.text:=cmain.ServerIPaddr;
ipport.text:=cmain.ServerIPport;
useipserver.checked:=cmain.autostartserver;
keepalive.checked:=cmain.keepalive;
RefreshIPClick(nil);
end;

procedure Tf_config.ShowLine;
begin
EqGrid.Checked:=csc.ShowEqGrid;
CGrid.Checked:=csc.ShowGrid;
GridNum.Checked:=csc.ShowGridNum;
Ecliptic.Checked:=csc.ShowEcliptic;
Galactic.Checked:=csc.ShowGalactic;
ConstlFile.Text:=cmain.ConstLfile;
ConstbFile.Text:=cmain.ConstBfile;
ConstL.Checked:=csc.ShowConstl;
ConstB.Checked:=csc.ShowConstb;
milkyway.Checked:=csc.ShowMilkyWay;
fillmilkyway.Checked:=csc.FillMilkyWay;
end;

procedure Tf_config.ShowTime;
var h,n,s:string;
    y,m,d,i,j:integer;
begin
y:=csc.curyear;
m:=csc.curmonth;
d:=csc.curday;
checkbox1.checked:=csc.UseSystemTime;
checkbox2.checked:=csc.AutoRefresh;
longedit2.value:=cmain.AutoRefreshDelay;
if y>0 then begin
  d_year.value:=y;
  adbc.itemindex:=0;
end else begin
  d_year.value:=1-y;
  adbc.itemindex:=1;
end;
d_month.value:=m;
d_day.value:=d;
labeldate.caption:=d_year.text+'-'+d_month.text+'-'+d_day.text;
artostr2(csc.curtime,h,n,s);
t_hour.value:=strtoint(h);
t_min.value:=strtoint(n);
t_sec.value:=strtoint(s);
labeltime.caption:=t_hour.text+':'+t_min.text+':'+t_sec.text;
tz.value:=csc.timezone;
labeltimezone.caption:=tz.text;
Tdt_Ut.caption:=inttostr(round(csc.DT_UT*3600));
checkbox4.checked:=csc.Force_DT_UT;
if not csc.Force_DT_UT then csc.DT_UT_val:=csc.DT_UT;
dt_ut.value:=round(csc.DT_UT_val*3600);
nbstep.value:=csc.Simnb;
if csc.SimD>0 then begin
   stepsize.value:=csc.SimD;
   stepunit.itemindex:=0;
end;
if csc.SimH>0 then begin
   stepsize.value:=csc.SimH;
   stepunit.itemindex:=1;
end;
if csc.SimM>0 then begin
   stepsize.value:=csc.SimM;
   stepunit.itemindex:=2;
end;
if csc.SimS>0 then begin
   stepsize.value:=csc.SimS;
   stepunit.itemindex:=3;
end;
stepline.checked:=csc.SimLine;
for i:=0 to NumSimObject-2 do begin
  j:=i;
  if j=0 then j:=10; // sun
  if j=3 then j:=11; // moon
  SimObj.checked[i]:=csc.SimObject[j];
end;
end;

procedure Tf_config.ShowPlanet;
begin
if csc.PlanetParalaxe then PlaParalaxe.itemindex:=1
                      else PlaParalaxe.itemindex:=0;
PlanetBox.checked:=csc.ShowPlanet;
PlanetMode.itemindex:=cplot.plaplot;
grs.value:=csc.GRSlongitude;
PlanetBox3.checked:=csc.ShowEarthShadow;
PlanetBox2.checked:=cplot.PlanetTransparent;
end;

procedure Tf_config.ShowChart;
var i : integer;
begin
equinox2.text:=stringreplace(stringreplace(stringreplace(cshr.EquinoxChart,'J','',[]),'B','',[]),'Date','2000.0',[]);
equinox1.itemindex:=0;
for i:=0 to equinox1.items.count-1 do
  if equinox1.items[i]=cshr.EquinoxChart then
      equinox1.itemindex:=i;
equinoxtype.itemindex:=cshr.EquinoxType;
PMBox.checked:=csc.PMon;
DrawPMBox.checked:=csc.DrawPMon;
lDrawPMy.value:=csc.DrawPMyear;
Apparenttype.itemindex:=0;
projectiontype.itemindex:=csc.ProjPole;
end;

procedure Tf_config.ShowGCat;
var i,j:integer;
begin
stringgrid3.RowCount:=2;
stringgrid3.cells[0,1]:='';
stringgrid3.cells[1,1]:='';
stringgrid3.cells[2,1]:='';
stringgrid3.cells[3,1]:='';
stringgrid3.cells[4,1]:='';
CatalogEmpty:=true;
for j:=0 to ccat.GCatnum-1 do begin
  if catalogempty then catalogempty:=false
                  else stringgrid3.rowcount:=stringgrid3.rowcount+1;
  i:=stringgrid3.rowcount-1;
  stringgrid3.cells[1,i]:=ccat.GCatLst[j].shortname;
  stringgrid3.cells[2,i]:=floattostr(ccat.GCatLst[j].min);
  stringgrid3.cells[3,i]:=floattostr(ccat.GCatLst[j].max);
  stringgrid3.cells[4,i]:=ccat.GCatLst[j].path;
  if ccat.GCatLst[j].actif then stringgrid3.cells[0,i]:='1'
                           else stringgrid3.cells[0,i]:='0';
end;
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
sac3.Text:=ccat.NebCatPath[sac-BaseNeb]+b;
ngc3.Text:=ccat.NebCatPath[ngc-BaseNeb]+b;
lbn3.Text:=ccat.NebCatPath[lbn-BaseNeb]+b;
rc33.Text:=ccat.NebCatPath[rc3-BaseNeb]+b;
pgc3.Text:=ccat.NebCatPath[pgc-BaseNeb]+b;
ocl3.Text:=ccat.NebCatPath[ocl-BaseNeb]+b;
gcm3.Text:=ccat.NebCatPath[gcm-BaseNeb]+b;
gpn3.Text:=ccat.NebCatPath[gpn-BaseNeb]+b;
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
bsc3.Text:=ccat.StarCatPath[bsc-BaseStar]+b;
sky3.Text:=ccat.StarCatPath[sky2000-BaseStar]+b;
tyc3.Text:=ccat.StarCatPath[tyc-BaseStar]+b;
ty23.Text:=ccat.StarCatPath[tyc2-BaseStar]+b;
tic3.Text:=ccat.StarCatPath[tic-BaseStar]+b;
gscf3.Text:=ccat.StarCatPath[gscf-BaseStar]+b;
gscc3.Text:=ccat.StarCatPath[gscc-BaseStar]+b;
gsc3.Text:=ccat.StarCatPath[gsc-BaseStar]+b;
usn3.Text:=ccat.StarCatPath[usnoa-BaseStar]+b;
mct3.Text:=ccat.StarCatPath[microcat-BaseStar]+b;
gcv3.Text:=ccat.VarStarCatPath[gcvs-BaseVar]+b;
wds3.Text:=ccat.DblStarCatPath[wds-BaseDbl]+b;
dsbase3.Text:=ccat.StarCatPath[dsbase-BaseStar]+b;
dstyc3.Text:=ccat.StarCatPath[dstyc-BaseStar]+b;
dsgsc3.Text:=ccat.StarCatPath[dsgsc-BaseStar]+b;
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
fBigNebLimit.value:=round(cshr.BigNebLimit);
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

procedure Tf_config.ShowGridSpacing;
begin
  MaskEdit1.text:=DEToStr3(cshr.DegreeGridSpacing[0]);
  MaskEdit2.text:=DEToStr3(cshr.DegreeGridSpacing[1]);
  MaskEdit3.text:=DEToStr3(cshr.DegreeGridSpacing[2]);
  MaskEdit4.text:=DEToStr3(cshr.DegreeGridSpacing[3]);
  MaskEdit5.text:=DEToStr3(cshr.DegreeGridSpacing[4]);
  MaskEdit6.text:=DEToStr3(cshr.DegreeGridSpacing[5]);
  MaskEdit7.text:=DEToStr3(cshr.DegreeGridSpacing[6]);
  MaskEdit8.text:=DEToStr3(cshr.DegreeGridSpacing[7]);
  MaskEdit9.text:=DEToStr3(cshr.DegreeGridSpacing[8]);
  MaskEdit10.text:=DEToStr3(cshr.DegreeGridSpacing[9]);
  MaskEdit11.text:=DEToStr3(cshr.DegreeGridSpacing[10]);
  MaskEdit12.text:=ArToStr3(cshr.HourGridSpacing[0]);
  MaskEdit13.text:=ArToStr3(cshr.HourGridSpacing[1]);
  MaskEdit14.text:=ArToStr3(cshr.HourGridSpacing[2]);
  MaskEdit15.text:=ArToStr3(cshr.HourGridSpacing[3]);
  MaskEdit16.text:=ArToStr3(cshr.HourGridSpacing[4]);
  MaskEdit17.text:=ArToStr3(cshr.HourGridSpacing[5]);
  MaskEdit18.text:=ArToStr3(cshr.HourGridSpacing[6]);
  MaskEdit19.text:=ArToStr3(cshr.HourGridSpacing[7]);
  MaskEdit20.text:=ArToStr3(cshr.HourGridSpacing[8]);
  MaskEdit21.text:=ArToStr3(cshr.HourGridSpacing[9]);
  MaskEdit22.text:=ArToStr3(cshr.HourGridSpacing[10]);
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
fw4b.value:=fw4.value;
fw5b.value:=fw5.value;
end;

procedure Tf_config.SetFieldHint(var lab:Tlabel; n:integer);
const ff='0.0';
begin
case n of
0 : lab.hint:='0 - '+formatfloat(ff,cshr.fieldnum[n]);
1..(MaxField) : lab.hint:=formatfloat(ff,cshr.fieldnum[n-1])+' - '+formatfloat(ff,cshr.fieldnum[n]);
end;
lab.showhint:=true;
end;

procedure Tf_config.ShowProjection;
   procedure setprojrange(var cb:Tcombobox;n:integer);
   begin
     cb.items.clear;
     cb.items.add('ARC');
//     if cshr.fieldnum[n]<=270 then cb.items.add('ARC');
     if cshr.fieldnum[n]<=89 then begin
        cb.items.add('TAN');
        cb.items.add('SIN');
     end;
     cb.items.add('CAR');
     cb.text:=csc.projname[n]
   end;
begin
setprojrange(combobox1,0);
setprojrange(combobox2,1);
setprojrange(combobox3,2);
setprojrange(combobox4,3);
setprojrange(combobox5,4);
setprojrange(combobox6,5);
setprojrange(combobox7,6);
setprojrange(combobox8,7);
setprojrange(combobox9,8);
setprojrange(combobox10,9);
setprojrange(combobox11,10);
setfieldhint(labelp0,0); combobox1.hint:=labelp0.hint;
setfieldhint(labelp1,1); combobox2.hint:=labelp1.hint;
setfieldhint(labelp2,2); combobox3.hint:=labelp2.hint;
setfieldhint(labelp3,3); combobox4.hint:=labelp3.hint;
setfieldhint(labelp4,4); combobox5.hint:=labelp4.hint;
setfieldhint(labelp5,5); combobox6.hint:=labelp5.hint;
setfieldhint(labelp6,6); combobox7.hint:=labelp6.hint;
setfieldhint(labelp7,7); combobox8.hint:=labelp7.hint;
setfieldhint(labelp8,8); combobox9.hint:=labelp8.hint;
setfieldhint(labelp9,9); combobox10.hint:=labelp9.hint;
setfieldhint(labelp10,10); combobox11.hint:=labelp10.hint;
end;

procedure Tf_config.SetFonts(ctrl:Tedit;num:integer);
begin
 ctrl.Text:=cplot.FontName[num];
 ctrl.Font.Name:=cplot.FontName[num];
 ctrl.Font.Size:=cplot.FontSize[num];
 if cplot.FontBold[num] then ctrl.Font.Style:=[fsBold]
                        else ctrl.Font.Style:=[];
 if cplot.FontItalic[num] then ctrl.Font.Style:=ctrl.Font.Style+[fsItalic];
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

procedure Tf_config.ShowColor;
begin
 bg1.color:=cplot.bgColor;
 bg2.color:=cplot.bgColor;
 bg3.color:=cplot.bgColor;
 shape1.brush.color:=cplot.color[1];
 shape2.brush.color:=cplot.color[2];
 shape3.brush.color:=cplot.color[3];
 shape4.brush.color:=cplot.color[4];
 shape5.brush.color:=cplot.color[5];
 shape6.brush.color:=cplot.color[6];
 shape7.brush.color:=cplot.color[7];
 shape8.pen.color:=cplot.color[8];
 shape9.pen.color:=cplot.color[9];
 shape10.pen.color:=cplot.color[10];
 shape11.pen.color:=cplot.color[12];
 shape12.pen.color:=cplot.color[13];
 shape13.pen.color:=cplot.color[14];
 shape14.pen.color:=cplot.color[15];
 shape15.pen.color:=cplot.color[16];
 shape16.pen.color:=cplot.color[17];
 shape17.pen.color:=cplot.color[18];
 shape25.brush.color:=cplot.color[19];
end;

procedure Tf_config.ShowSkyColor;
begin
 if cplot.autoskycolor then skycolorbox.itemindex:=1
                       else skycolorbox.itemindex:=0;
 shape18.pen.color:=cplot.skycolor[1];
 shape18.brush.color:=cplot.skycolor[1];
 shape19.pen.color:=cplot.skycolor[2];
 shape19.brush.color:=cplot.skycolor[2];
 shape20.pen.color:=cplot.skycolor[3];
 shape20.brush.color:=cplot.skycolor[3];
 shape21.pen.color:=cplot.skycolor[4];
 shape21.brush.color:=cplot.skycolor[4];
 shape22.pen.color:=cplot.skycolor[5];
 shape22.brush.color:=cplot.skycolor[5];
 shape23.pen.color:=cplot.skycolor[6];
 shape23.brush.color:=cplot.skycolor[6];
 shape24.pen.color:=cplot.skycolor[7];
 shape24.brush.color:=cplot.skycolor[7];
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
Fontdialog1.Font.Name:=cplot.FontName[i];
Fontdialog1.Font.Size:=cplot.FontSize[i];
if cplot.FontBold[i] then Fontdialog1.Font.Style:=[fsBold]
                     else Fontdialog1.Font.Style:=[];
if cplot.FontItalic[i] then Fontdialog1.Font.Style:=Fontdialog1.Font.Style+[fsItalic];
if Fontdialog1.Execute then begin
   cplot.FontName[i]:=Fontdialog1.Font.Name;
   cplot.FontSize[i]:=Fontdialog1.Font.Size;
   cplot.FontBold[i]:=fsBold in Fontdialog1.Font.Style;
   cplot.FontItalic[i]:=fsItalic in Fontdialog1.Font.Style;
end;
ShowFonts;
end;

procedure Tf_config.DefaultFontClick(Sender: TObject);
var i : integer;
begin
for i:=1 to 6 do begin
    cplot.FontName[i]:=DefaultFontName;
    cplot.FontSize[i]:=DefaultFontSize;
    cplot.FontBold[i]:=false;
    cplot.FontItalic[i]:=false;
end;
ShowFonts;
end;
                 
procedure Tf_config.FWChange(Sender: TObject);
begin
if sender is TFloatEdit then with sender as TFloatEdit do begin
  cshr.fieldnum[tag]:=Value;
  if (fw4<>nil)and(fw4b<>nil) then fw4b.value:=fw4.value;
  if (fw5<>nil)and(fw5b<>nil) then fw5b.value:=fw5.value;
end;
end;

procedure Tf_config.CDCStarSelClick(Sender: TObject);
begin
if sender is TCheckBox then with sender as TCheckBox do begin
  ccat.StarCatDef[tag]:=Checked;
  ShowCDCStar;
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
  Text:=trim(Text);
  ccat.StarCatPath[tag]:=Text;
  if ccat.StarCatDef[tag] then
     if f_main.catalog.checkpath(tag+BaseStar,text)
        then color:=clWindow
        else color:=clRed
     else color:=clWindow;
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

procedure Tf_config.fBigNebLimitChange(Sender: TObject);
begin
cshr.BigNebLimit:=fBigNebLimit.value;
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
  ShowCDCNeb;
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
  Text:=trim(Text);
  ccat.NebCatPath[tag]:=Text;
  if ccat.NebCatDef[tag] then
     if f_main.catalog.checkpath(tag+BaseNeb,text)
        then color:=clWindow
        else color:=clRed
     else color:=clWindow;
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
ShowCDCStar;
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
  gcv3.Text:=trim(gcv3.Text);
  ccat.VarStarCatPath[gcvs-BaseVar]:=gcv3.Text;
  if ccat.VarStarCatDef[gcvs-BaseVar] then
     if f_main.catalog.checkpath(gcvs,gcv3.text)
        then gcv3.color:=clWindow
        else gcv3.color:=clRed
     else gcv3.color:=clWindow;
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
ShowCDCStar;
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
  wds3.Text:=trim(wds3.Text);
  ccat.DblStarCatPath[wds-BaseDbl]:=wds3.Text;
  if ccat.DblStarCatDef[wds-BaseDbl] then
     if f_main.catalog.checkpath(wds,wds3.text)
        then wds3.color:=clWindow
        else wds3.color:=clRed
     else wds3.color:=clWindow;
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
                  
procedure Tf_config.StringGrid3DrawCell(Sender: TObject; ACol,
  ARow: Integer; Rect: TRect; State: TGridDrawState);
begin
with Sender as TStringGrid do begin
if (Acol=0)and(Arow>0) then begin
  Canvas.Brush.style := bssolid;
  if (cells[acol,arow]='1')then begin
    Canvas.Brush.Color := clLime;
    Canvas.FillRect(Rect);
  end else if (cells[acol,arow]='0')then begin
    Canvas.Brush.Color := clRed;
    Canvas.FillRect(Rect);
  end;
  end;
if (Acol=1)and(Arow>0) then
  if not fileexists(slash(cells[4,arow])+cells[1,arow]+'.hdr') then begin
    Canvas.Pen.Color := clRed;
    Canvas.Brush.style := bsclear;
    Canvas.rectangle(Rect);
    cells[0,arow]:='0';
  end;
if (Acol=2)and(Arow>0) then
  if not IsNumber(cells[acol,arow]) then begin
    Canvas.Pen.Color := clRed;
    Canvas.Brush.style := bsclear;
    Canvas.rectangle(Rect);
    cells[0,arow]:='0';
  end;
if (Acol=3)and(Arow>0) then
  if not IsNumber(cells[acol,arow]) then begin
    Canvas.Pen.Color := clRed;
    Canvas.Brush.style := bsclear;
    Canvas.rectangle(Rect);
    cells[0,arow]:='0';
  end;
if (Acol=4)and(Arow>0) then
  if not fileexists(slash(cells[4,arow])+cells[1,arow]+'.hdr') then begin
    Canvas.Pen.Color := clRed;
    Canvas.Brush.style := bsclear;
    Canvas.rectangle(Rect);
    cells[0,arow]:='0';
  end;
if (Acol=5)and(Arow>0) then begin
    Canvas.draw(Rect.left,Rect.top,BitBtn9.Glyph);
  end;
end;
end;

Procedure Tf_config.EditGCatPath(row : integer);
var buf : string;
    p : integer;
begin
    if trim(stringgrid3.Cells[4,row])<>'' then opendialog1.InitialDir:=stringgrid3.Cells[4,row]
                                          else opendialog1.InitialDir:=slash(appdir)+'cat';
    if trim(stringgrid3.Cells[1,row])<>'' then opendialog1.filename:=trim(stringgrid3.Cells[1,row])+'.hdr';
    opendialog1.Filter:='Catalog header|*.hdr';
    opendialog1.DefaultExt:='.hdr';
    try
    if opendialog1.execute then begin
       buf:=extractfilename(opendialog1.FileName);
       p:=pos('.',buf);
       stringgrid3.Cells[1,row]:=copy(buf,1,p-1);
       stringgrid3.Cells[4,row]:=extractfilepath(opendialog1.filename);
       stringgrid3.Cells[2,row]:='0';
       stringgrid3.Cells[3,row]:=f_main.catalog.GetMaxField(stringgrid3.Cells[4,row],stringgrid3.Cells[1,row]);
    end;
    finally
    chdir(appdir);
    end;
end;

Procedure Tf_config.DeleteGCatRow(p : integer);
var i : integer;
begin
if p<1 then exit;
if stringgrid3.rowcount=2 then begin
 stringgrid3.cells[0,1]:='';
 stringgrid3.cells[1,1]:='';
 stringgrid3.cells[2,1]:='';
 stringgrid3.cells[3,1]:='';
 stringgrid3.cells[4,1]:='';
 CatalogEmpty:=true;
end else begin
for i:=p to stringgrid3.RowCount-2 do begin
 stringgrid3.cells[0,i]:=stringgrid3.cells[0,i+1];
 stringgrid3.cells[1,i]:=stringgrid3.cells[1,i+1];
 stringgrid3.cells[2,i]:=stringgrid3.cells[2,i+1];
 stringgrid3.cells[3,i]:=stringgrid3.cells[3,i+1];
 stringgrid3.cells[4,i]:=stringgrid3.cells[4,i+1];
end;
stringgrid3.RowCount:=stringgrid3.RowCount-1;
end;
end;

procedure Tf_config.StringGrid3MouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var col,row:integer;
begin
StringGrid3.MouseToCell(X, Y, Col, Row);
if row=0 then exit;
case col of
0 : begin
    if stringgrid3.Cells[col,row]='1' then stringgrid3.Cells[col,row]:='0'
       else
       if fileexists(slash(stringgrid3.cells[4,row])+stringgrid3.cells[1,row]+'.hdr') then stringgrid3.Cells[col,row]:='1'
          else  stringgrid3.Cells[col,row]:='0';
    end;
5 : begin
    EditGCatPath(row);
    end;
end;
end;

procedure Tf_config.StringGrid3SelectCell(Sender: TObject; ACol,
  ARow: Integer; var CanSelect: Boolean);
begin
if Acol=5 then canselect:=false else canselect:=true;
end;

procedure Tf_config.StringGrid3SetEditText(Sender: TObject; ACol,
  ARow: Integer; const Value: WideString);
begin
if (Acol=4)and(Arow>0) then
  if not fileexists(slash(value)+StringGrid3.cells[1,arow]+'.hdr') then begin
    StringGrid3.Canvas.Brush.Color := clRed;
    StringGrid3.Canvas.FillRect(StringGrid3.CellRect(ACol, ARow));
    StringGrid3.cells[0,arow]:='0';
  end;
if ((Acol=2)or(Acol=3))and(Arow>0)and(value>'') then begin
  if not IsNumber(value) then begin
    StringGrid3.Canvas.Brush.Color := clRed;
    StringGrid3.Canvas.FillRect(StringGrid3.CellRect(ACol, ARow));
    StringGrid3.cells[0,arow]:='0';
  end;
end;
end;

procedure Tf_config.AddCatClick(Sender: TObject);
begin
catalogempty:=false;
stringgrid3.rowcount:=stringgrid3.rowcount+1;
stringgrid3.cells[2,stringgrid3.rowcount-1]:='0';
stringgrid3.cells[3,stringgrid3.rowcount-1]:='10';
EditGCatPath(stringgrid3.rowcount-1);
end;

procedure Tf_config.DelCatClick(Sender: TObject);
var p : integer;
begin
p:=stringgrid3.selection.top;
stringgrid3.cells[1,p]:='';
stringgrid3.cells[2,p]:='';
stringgrid3.cells[3,p]:='';
stringgrid3.cells[4,p]:='';
DeleteGCatRow(p);
end;

procedure Tf_config.FormClose(Sender: TObject; var Action: TCloseAction);
var i,x,v:integer;
begin
ccat.GCatNum:=stringgrid3.RowCount-1;
SetLength(ccat.GCatLst,ccat.GCatNum);
for i:=0 to ccat.GCatNum-1 do begin
   ccat.GCatLst[i].shortname:=stringgrid3.cells[1,i+1];
   ccat.GCatLst[i].path:=stringgrid3.cells[4,i+1];
   val(stringgrid3.cells[2,i+1],x,v);
   if v=0 then ccat.GCatLst[i].min:=x
          else ccat.GCatLst[i].min:=0;
   val(stringgrid3.cells[3,i+1],x,v);
   if v=0 then ccat.GCatLst[i].max:=x
          else ccat.GCatLst[i].max:=0;
   ccat.GCatLst[i].Actif:=stringgrid3.cells[0,i+1]='1';
   ccat.GCatLst[i].magmax:=0;
   ccat.GCatLst[i].name:='';
   ccat.GCatLst[i].cattype:=0;
   if ccat.GCatLst[i].Actif then begin
      if not
      f_main.catalog.GetInfo(ccat.GCatLst[i].path,
                      ccat.GCatLst[i].shortname,
                      ccat.GCatLst[i].magmax,
                      ccat.GCatLst[i].cattype,
                      ccat.GCatLst[i].version,
                      ccat.GCatLst[i].name)
      then ccat.GCatLst[i].Actif:=false;
   end;
end;
end;

procedure Tf_config.SetEquinox;
begin
case cshr.EquinoxType of
0 : begin
     case equinox1.itemindex of
     0 : begin
           cshr.EquinoxChart:='J2000';
           cshr.DefaultJDChart:=jd2000;
         end;
     1 : begin
           cshr.EquinoxChart:='B1950';
           cshr.DefaultJDChart:=jd1950;
         end;
     2 : begin
           cshr.EquinoxChart:='B1900';
           cshr.DefaultJDChart:=jd1900;
         end;
     end;
     equinox1.Visible:=true;
     equinox2.Visible:=false;
    end;
1 : begin
     cshr.EquinoxChart:=equinox2.text;
     cshr.DefaultJDChart:=jd(trunc(equinox2.Value),trunc(frac(equinox2.Value)*12)+1,0,0);
     equinox1.Visible:=false;
     equinox2.Visible:=true;
    end;
2 : begin
     cshr.EquinoxChart:='Date ';
     cshr.DefaultJDChart:=jd2000;
     equinox1.Visible:=false;
     equinox2.Visible:=false;
    end;
end;
end;

procedure Tf_config.equinoxtypeClick(Sender: TObject);
begin
cshr.EquinoxType:=equinoxtype.itemindex;
SetEquinox;
end;

procedure Tf_config.equinox1Change(Sender: TObject);
begin
if (cshr.EquinoxType=0) then SetEquinox;
end;

procedure Tf_config.equinox2Change(Sender: TObject);
begin
if (cshr.EquinoxType=1)and(trim(equinox2.text)>'') then SetEquinox;
end;

procedure Tf_config.PMBoxClick(Sender: TObject);
begin
csc.PMon:=PMBox.checked;
end;

procedure Tf_config.DrawPmBoxClick(Sender: TObject);
begin
csc.DrawPMon:=DrawPMBox.checked;
end;

procedure Tf_config.lDrawPMyChange(Sender: TObject);
begin
csc.DrawPMyear:=lDrawPMy.value;
end;

procedure Tf_config.projectiontypeClick(Sender: TObject);
begin
csc.ProjPole:=projectiontype.itemindex;
end;

procedure Tf_config.CheckBox1Click(Sender: TObject);
begin
csc.UseSystemTime:=checkbox1.checked;
SetCurrentTime(csc);
panel7.visible:=not csc.UseSystemTime;
panel9.visible:=not csc.UseSystemTime;
ShowTime;
end;

procedure Tf_config.CheckBox2Click(Sender: TObject);
begin
csc.AutoRefresh:=checkbox2.checked;
end;

procedure Tf_config.LongEdit2Change(Sender: TObject);
begin
cmain.AutoRefreshDelay:=longedit2.value;
end;

procedure Tf_config.tzChange(Sender: TObject);
begin
with sender as Tfloatedit do begin
  csc.obstz:=value;
end;
// same value in Time and Observatory panel
if tz<>nil then tz.value:=csc.obstz;
if timez<>nil then timez.value:=csc.obstz;
end;

procedure Tf_config.CheckBox4Click(Sender: TObject);
begin
csc.Force_DT_UT:=checkbox4.checked;
dt_ut.enabled:=csc.Force_DT_UT;
csc.DT_UT:=DTminusUT(csc.curyear,csc);
Tdt_Ut.caption:=inttostr(round(csc.DT_UT*3600));
dt_ut.text:=Tdt_Ut.caption;
end;

procedure Tf_config.dt_utChange(Sender: TObject);
begin
csc.DT_UT_val:=dt_ut.value/3600;
csc.DT_UT:=csc.DT_UT_val;
Tdt_ut.caption:=dt_ut.text;
end;

procedure Tf_config.DateChange2(Sender: TObject);
begin
DateChange(Sender,0);
end;

procedure Tf_config.DateChange(Sender: TObject; NewValue: Integer);
begin
// do not use NewValue for VCL compatibility
if adbc.itemindex=0 then
  csc.curyear:=d_year.value
else
  csc.curyear:=1-d_year.value;
csc.curmonth:=d_month.value;
csc.curday:=d_day.value;
csc.DT_UT:=DTminusUT(csc.curyear,csc);
Tdt_Ut.caption:=inttostr(round(csc.DT_UT*3600));
dt_ut.text:=Tdt_Ut.caption;
end;

procedure Tf_config.TimeChange2(Sender: TObject);
begin
TimeChange(Sender,0);
end;

procedure Tf_config.TimeChange(Sender: TObject; NewValue: Integer);
begin
// do not use NewValue for VCL compatibility
csc.curtime:=t_hour.value+t_min.value/60+t_sec.value/3600;
end;

procedure Tf_config.BitBtn4Click(Sender: TObject);
var y,m,d,h,n,s,ms : word;
begin
 ADBC.itemindex:=0;
 decodedate(now,y,m,d);
 decodeTime(now,h,n,s,ms);
 d_year.value:=y;
 d_month.value:=m;
 d_day.value:=d;
 t_hour.value:=h;
 t_min.value:=n;
 t_sec.value:=s;
 tz.value:=GetTimezone;
end;

procedure Tf_config.ProjectionChange(Sender: TObject);
begin
if sender is TComboBox then with sender as TComboBox do
   csc.projname[tag]:=text;
end;

procedure Tf_config.DegSpacingChange(Sender: TObject);
begin
if sender is TMaskEdit then with sender as TMaskEdit do
   cshr.DegreeGridSpacing[tag]:=Str3ToDE(text);
end;

procedure Tf_config.HourSpacingChange(Sender: TObject);
begin
if sender is TMaskEdit then with sender as TMaskEdit do
   cshr.HourGridSpacing[tag]:=Str3ToAr(text);
end;

procedure Tf_config.PlaParalaxeClick(Sender: TObject);
begin
csc.PlanetParalaxe:=(PlaParalaxe.itemindex=1);
end;

procedure Tf_config.PlanetBoxClick(Sender: TObject);
begin
csc.ShowPlanet:=PlanetBox.checked;
end;

procedure Tf_config.PlanetModeClick(Sender: TObject);
begin
cplot.plaplot:=PlanetMode.itemindex;
end;

procedure Tf_config.GRSChange(Sender: TObject);
begin
csc.GRSlongitude:=grs.value;
end;

procedure Tf_config.PlanetBox2Click(Sender: TObject);
begin
cplot.PlanetTransparent:=PlanetBox2.checked;
end;

procedure Tf_config.PlanetBox3Click(Sender: TObject);
begin
csc.ShowEarthShadow:=PlanetBox3.checked;
end;

procedure Tf_config.Button2Click(Sender: TObject);
begin
// Apply change
f_main.activateconfig;
end;

procedure Tf_config.SimObjClickCheck(Sender: TObject);
var i,j:integer;
begin
for i:=0 to NumSimObject-2 do begin
  j:=i;
  if j=0 then j:=10; // sun
  if j=3 then j:=11; // moon
  csc.SimObject[j]:=SimObj.checked[i];
end;
end;

procedure Tf_config.steplineClick(Sender: TObject);
begin
csc.SimLine:=stepline.checked;
end;

procedure Tf_config.stepunitClick(Sender: TObject);
begin
case stepunit.ItemIndex of
 0 : begin
       csc.SimD:=stepsize.value;
       csc.SimH:=0;csc.SimM:=0;csc.SimS:=0;
     end;
 1 : begin
       csc.SimH:=stepsize.value;
       csc.SimD:=0;csc.SimM:=0;csc.SimS:=0;
     end;
 2 : begin
       csc.SimM:=stepsize.value;
       csc.SimD:=0;csc.SimH:=0;csc.SimS:=0;
     end;
 3 : begin
       csc.SimS:=stepsize.value;
       csc.SimD:=0;csc.SimH:=0;csc.SimM:=0;
     end;
end;
end;


procedure Tf_config.ConstlFileBtnClick(Sender: TObject);
var f : string;
begin
f:=expandfilename(ConstlFile.Text);
opendialog1.InitialDir:=extractfilepath(f);
opendialog1.filename:=extractfilename(f);
opendialog1.Filter:='Constellation Figure|*.cln';
opendialog1.DefaultExt:='';
try
if opendialog1.execute then begin
   ConstlFile.Text:=opendialog1.FileName;
end;
finally
 chdir(appdir);
end;
end;

procedure Tf_config.ConstlFileChange(Sender: TObject);
begin
  cmain.ConstLfile:=expandfilename(ConstlFile.Text);
end;

procedure Tf_config.EqGridClick(Sender: TObject);
begin
  csc.ShowEqGrid:=EqGrid.Checked;
end;

procedure Tf_config.CGridClick(Sender: TObject);
begin
  csc.ShowGrid:=CGrid.Checked;
end;

procedure Tf_config.GridNumClick(Sender: TObject);
begin
  csc.ShowGridNum:=GridNum.Checked;
end;

procedure Tf_config.eclipticClick(Sender: TObject);
begin
  csc.Showecliptic:=ecliptic.Checked;
end;

procedure Tf_config.galacticClick(Sender: TObject);
begin
  csc.Showgalactic:=galactic.Checked;
end;

procedure Tf_config.ConstlClick(Sender: TObject);
begin
  csc.ShowConstl:=ConstL.Checked;
end;

procedure Tf_config.ConstbClick(Sender: TObject);
begin
  csc.ShowConstb:=ConstB.Checked;
end;


procedure Tf_config.milkywayClick(Sender: TObject);
begin
  csc.showmilkyway:=milkyway.checked;
end;

procedure Tf_config.fillmilkywayClick(Sender: TObject);
begin
  csc.fillmilkyway:=fillmilkyway.checked;
end;

procedure Tf_config.ConstbFileChange(Sender: TObject);
begin
  cmain.ConstBfile:=expandfilename(ConstbFile.Text);
end;

procedure Tf_config.ConstbfileBtnClick(Sender: TObject);
var f : string;
begin
f:=expandfilename(ConstbFile.Text);
opendialog1.InitialDir:=extractfilepath(f);
opendialog1.filename:=extractfilename(f);
opendialog1.Filter:='Constellation Boundary|*.cby';
opendialog1.DefaultExt:='';
try
if opendialog1.execute then begin
   ConstbFile.Text:=opendialog1.FileName;
end;
finally
 chdir(appdir);
end;
end;

procedure Tf_config.ApparentTypeClick(Sender: TObject);
begin
ApparentType.ItemIndex:=0;
end;


procedure Tf_config.bgClick(Sender: TObject);
begin
{ bad idea...
   ColorDialog1.color:=cplot.Color[0];
   if ColorDialog1.Execute then begin
      cplot.Color[0]:=ColorDialog1.Color;
      cplot.color[11]:=not cplot.Color[0];
      cplot.bgcolor:=cplot.color[0];
      ShowColor;
   end;}
end;

procedure Tf_config.ShapeMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
if sender is TShape then with sender as TShape do begin
   ColorDialog1.color:=cplot.Color[tag];
   if ColorDialog1.Execute then begin
      cplot.Color[tag]:=ColorDialog1.Color;
      ShowColor;
   end;
end;
end;

procedure Tf_config.DefColorClick(Sender: TObject);
begin
case DefColor.ItemIndex of
  0 : cplot.Color:=DfColor;
  1 : cplot.Color:=DfRedColor;
  2 : cplot.Color:=DfBWColor;
  3 : cplot.Color:=DfWBColor;
end;
cplot.bgcolor:=cplot.color[0];
ShowColor;
end;

procedure Tf_config.skycolorboxClick(Sender: TObject);
begin
cplot.autoskycolor:=(skycolorbox.itemindex=1);
end;

procedure Tf_config.ShapeSkyMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
if sender is TShape then with sender as TShape do begin
   ColorDialog1.color:=cplot.SkyColor[tag];
   if ColorDialog1.Execute then begin
      cplot.SkyColor[tag]:=ColorDialog1.Color;
      ShowSkyColor;
   end;
end;
end;

procedure Tf_config.Button3Click(Sender: TObject);
begin
cplot.SkyColor:=dfSkyColor;
ShowSkyColor;
end;

procedure Tf_config.refreshIPClick(Sender: TObject);
begin
if f_main.TCPDaemon<>nil then begin
  f_main.TCPDaemon.ShowSocket;
  ipstatus.Text:=f_main.serverinfo;
end else  ipstatus.Text:='Not started.';
end;

procedure Tf_config.UseIPserverClick(Sender: TObject);
begin
cmain.AutostartServer:=UseIPserver.Checked;
end;

procedure Tf_config.keepaliveClick(Sender: TObject);
begin
cmain.keepalive:=keepalive.checked;
end;

procedure Tf_config.ipaddrChange(Sender: TObject);
begin
cmain.ServerIPaddr:=ipaddr.Text;
end;

procedure Tf_config.ipportChange(Sender: TObject);
begin
cmain.ServerIPport:=ipport.Text;
end;

procedure Tf_config.ShowObservatory;
var i:integer;
begin
try
altmeter.value:=csc.obsaltitude;
pressure.value:=csc.obspressure;
temperature.value:=csc.obstemperature;
timez.value:=csc.obstz;
ShowObsCoord;
//countrylist.text:=csc.obscountry;
countrylist.itemindex:=0;
for i:=0 to countrylist.items.count-1 do
  if uppercase(trim(countrylist.Items[i]))=uppercase(trim(csc.obscountry)) then begin
    countrylist.itemindex:=i;
    break;
  end;
citylist.text:=csc.obsname;
cityfilter.text:=copy(csc.obsname,1,3);
Obsposx:=0;
Obsposy:=0;
ZoomImage1.Xcentre:=Obsposx;
ZoomImage1.Ycentre:=Obsposy;
ZoomImage1.ZoomMax:=3;
if fileexists(cmain.EarthMapFile) then
   ZoomImage1.Picture.LoadFromFile(cmain.EarthMapFile)
else  ZoomImage1.PictureChange(self);
SetScrollBar;
Hscrollbar.Position:=ZoomImage1.SizeX div 2;
Vscrollbar.Position:=ZoomImage1.SizeY div 2;
SetObsPos;
CenterObs;
except
end;
end;

Procedure Tf_config.ShowObsCoord;
var d,m,s : string;
begin
try
obslock:=true;
ArToStr2(abs(csc.ObsLatitude),d,m,s);
latdeg.Text:=d;
latmin.Text:=m;
latsec.Text:=s;
ArToStr2(abs(csc.ObsLongitude),d,m,s);
longdeg.Text:=d;
longmin.Text:=m;
longsec.Text:=s;
if csc.ObsLatitude>=0 then hemis.Itemindex:=0
                      else hemis.Itemindex:=1;
if csc.ObsLongitude>=0 then long.Itemindex:=0
                       else long.Itemindex:=1;
finally
obslock:=false;
end;
end;

procedure Tf_config.countrylistClick(Sender: TObject);
begin
try
csc.obscountry:=countrylist.text;
citysearch.click;
except
end;
end;

procedure Tf_config.obsnameMouseEnter(Sender: TObject);
begin
try
if (c=nil)or(total<=0)or(countrylist.text<>actual_country) then begin
  csc.obscountry:=countrylist.text;
  UpdCityList(false);
end;
except
end;
end;

procedure Tf_config.citylistChange(Sender: TObject);
begin
csc.obsname:=citylist.text;
end;

procedure Tf_config.citylistClick(Sender: TObject);
var i:integer;
    x,xx:double;
begin
csc.obsname:=citylist.text;
if (c=nil)or(total<=0) then exit;
i := citylist.ItemIndex+first;
x:=abs(c^[i].m_Coord[0]/10000);
xx:=trunc(x);
csc.ObsLatitude:=xx;
x:=(x-xx)*100;
xx:=trunc(x);
csc.ObsLatitude:=csc.ObsLatitude+xx/60;
x:=(x-xx)*100;
csc.ObsLatitude:=csc.ObsLatitude+x/3600;
if c^[i].m_Coord[0]<0 then csc.ObsLatitude:=-csc.ObsLatitude;
x:=abs(c^[i].m_Coord[1]/10000);
xx:=trunc(x);
csc.ObsLongitude:=xx;
x:=(x-xx)*100;
xx:=trunc(x);
csc.ObsLongitude:=csc.ObsLongitude+xx/60;
x:=(x-xx)*100;
csc.ObsLongitude:=csc.ObsLongitude+x/3600;
if c^[i].m_Coord[1]>0 then csc.ObsLongitude:=-csc.ObsLongitude;
ShowObsCoord;
SetObsPos;
CenterObs;
end;

procedure Tf_config.citysearchClick(Sender: TObject);
begin
try
UpdCityList(true);
except
end;
end;

procedure Tf_config.UpdCityList(changecity:boolean);
var s,cfile : pchar;
    cfilename: array[0..200]of char;
    i,n: integer;
    ci,filter:utf8string;
    savecity:string;
begin
cfile:=nil;
if (countrylist.text<>actual_country)or(total<=0) then begin
  try
  screen.cursor:=crHourGlass;
  s:=pchar(string(slash(appdir)+'data'+pathdelim+'CitiesOfTheWorld'));
  setdirectory(s);
  releasecities();
  total:=readcountryfile(pchar(string(countrylist.text)),c,cfilename);
  cfile:=cfilename;
  actual_country:=countrylist.text;
  finally
   screen.cursor:=crDefault;
  end;
end;
if total<=0 then begin
  if total<>-2 then showmessage('Error reading country file: '+inttostr(total));
  exit;
end;
filter:=utf8encode(cityfilter.text);
if filter<>'' then first:=SearchCity(pchar(filter))
              else first:=0;
if first<0 then first:=total-50;
n:=minintvalue([total-1,first+100]);
savecity:=citylist.text;
citylist.clear;
citylist.ItemIndex:=-1;
citylist.Items.BeginUpdate;
for i:=first to n do begin
  ci:=c^[i].m_Name;
  citylist.items.Add(utf8decode(ci));
end;
citylist.Items.EndUpdate;
if changecity then begin
  citylist.ItemIndex:=0;
  citylistClick(Self);
end
else citylist.text:=savecity;
if (cfile<>nil)then begin
  if (not FileIsReadOnly(cfile)) then begin
     dbreado.sendtoback;
     dbreado.visible:=false;
     updcity.enabled:=true;
     newcity.enabled:=true;
     delcity.enabled:=true
  end else begin
     dbreado.bringtofront;
     dbreado.visible:=true;
     updcity.enabled:=false;
     newcity.enabled:=false;
     delcity.enabled:=false
  end;
end;
end;

procedure Tf_config.newcityClick(Sender: TObject);
var nc : City;
begin
if (c=nil)or(total<=0) then begin
  showmessage('Error, country file not initialized: '+inttostr(total));
  exit;
end;
strpcopy(nc.m_Name,utf8encode(citylist.text));
nc.m_Coord[0]:=latsec.value+latmin.value*100+latdeg.value*10000;
if hemis.itemindex=1 then nc.m_Coord[0]:=-nc.m_Coord[0];
nc.m_Coord[1]:=longsec.value+longmin.value*100+longdeg.value*10000;
if long.itemindex=1 then nc.m_Coord[1]:=-nc.m_Coord[1];
if AddCity(@nc)>0 then begin;
   actual_country:='';
   cityfilter.text:=citylist.text;
   citysearch.click;
end else showmessage(citylist.text+' already exist!');
end;

procedure Tf_config.updcityClick(Sender: TObject);
var nc : City;
    i : integer;
begin
if (c=nil)or(total<=0) then begin
  showmessage('Error, country file not initialized: '+inttostr(total));
  exit;
end;
i := citylist.ItemIndex+first;
strpcopy(nc.m_Name,utf8encode(citylist.text));
nc.m_Coord[0]:=latsec.value+latmin.value*100+latdeg.value*10000;
if hemis.itemindex=1 then nc.m_Coord[0]:=-nc.m_Coord[0];
nc.m_Coord[1]:=longsec.value+longmin.value*100+longdeg.value*10000;
if long.itemindex=1 then nc.m_Coord[1]:=-nc.m_Coord[1];
if ModifyCity(i,@nc)>0 then begin;
   actual_country:='';
   cityfilter.text:=citylist.text;
   citysearch.click;
end else showmessage('Failed to update '+citylist.text+'!');
end;

procedure Tf_config.delcityClick(Sender: TObject);
var nc : City;
    i : integer;
begin
if (c=nil)or(total<=0) then begin
  showmessage('Error, country file not initialized: '+inttostr(total));
  exit;
end;
i := citylist.ItemIndex+first;
nc:=c^[i];
if messagedlg('Are you sure you want to remove '+nc.m_Name+' ?',mtConfirmation,[mbYes,mbNo],0)=mrYes then begin
   if RemoveCity(i,@nc)>0 then begin;
      actual_country:='';
      citysearch.click;
   end else showmessage('Failed to delete!');
end;
end;

procedure Tf_config.latdegChange(Sender: TObject);
begin
if obslock then exit;
csc.ObsLatitude:=latdeg.value+latmin.value/60+latsec.value/3600;
if hemis.Itemindex>0 then csc.ObsLatitude:=-csc.ObsLatitude;
SetObsPos;
CenterObs;
end;

procedure Tf_config.longdegChange(Sender: TObject);
begin
if obslock then exit;
csc.ObsLongitude:=longdeg.value+longmin.value/60+longsec.value/3600;
if long.Itemindex>0 then csc.ObsLongitude:=-csc.ObsLongitude;
SetObsPos;
CenterObs;
end;

procedure Tf_config.altmeterChange(Sender: TObject);
begin
csc.obsaltitude:=altmeter.value;
end;

procedure Tf_config.pressureChange(Sender: TObject);
begin
csc.obspressure:=pressure.value;
end;

procedure Tf_config.temperatureChange(Sender: TObject);
begin
csc.obstemperature:=temperature.value;
end;

Procedure Tf_config.SetScrollBar;
begin
try
ScrollLock:=true;
scrollw:=round(ZoomImage1.Width/ZoomImage1.zoom/2);
Hscrollbar.SetParams(Hscrollbar.Position, scrollw, ZoomImage1.SizeX-scrollw);
Hscrollbar.LargeChange:=scrollw;
Hscrollbar.SmallChange:=scrollw div 10;
scrollh:=round(ZoomImage1.Height/ZoomImage1.zoom/2);
Vscrollbar.SetParams(Vscrollbar.Position, scrollh, ZoomImage1.SizeY-scrollh);
Vscrollbar.LargeChange:=scrollh;
Vscrollbar.SmallChange:=scrollh div 10;
finally
ScrollLock:=false;
end;
end;

procedure Tf_config.ZoomImage1Paint(Sender: TObject);
var x,y : integer;
begin
  with ZoomImage1.Canvas do begin
     pen.Color:=clred;
     brush.Style:=bsClear;
     x:=ZoomImage1.Wrld2ScrX(Obsposx);
     y:=ZoomImage1.Wrld2ScrY(Obsposy);
     ellipse(x-3,y-3,x+3,y+3);
  end;
end;

procedure Tf_config.ZoomImage1MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
if ZoomImage1.SizeX>0 then begin
  Obsposx:=ZoomImage1.scr2wrldx(x);
  Obsposy:=ZoomImage1.scr2wrldy(y);
  ZoomImage1.Refresh;
  csc.ObsLongitude:=180-360*Obsposx/ZoomImage1.SizeX;
  csc.ObsLatitude:=90-180*Obsposy/ZoomImage1.SizeY;
  ShowObsCoord;
end;
end;

Procedure Tf_config.SetObsPos;
begin
Obsposx:=round(ZoomImage1.SizeX*(180-csc.ObsLongitude)/360);
Obsposy:=round(ZoomImage1.SizeY*(90-csc.ObsLatitude)/180);
ZoomImage1.Xcentre:=Obsposx;
ZoomImage1.Ycentre:=Obsposy;
end;

procedure Tf_config.ZoomImage1PosChange(Sender: TObject);
begin
ScrollLock:=true;
Hscrollbar.Position:=ZoomImage1.Xc;
Vscrollbar.Position:=ZoomImage1.Yc;
application.processmessages;
ScrollLock:=false;
end;

procedure Tf_config.HScrollBarChange(Sender: TObject);
begin
if scrolllock then exit;
ZoomImage1.Xcentre:=HScrollBar.Position;
ZoomImage1.Draw;
end;

procedure Tf_config.VScrollBarChange(Sender: TObject);
begin
if scrolllock then exit;
ZoomImage1.Ycentre:=VScrollBar.Position;
ZoomImage1.Draw;
end;

procedure Tf_config.CenterObs;
begin
ZoomImage1.Xcentre:=Obsposx;
ZoomImage1.Ycentre:=Obsposy;
ZoomImage1.Draw;
SetScrollBar;
end;

procedure Tf_config.ObszpClick(Sender: TObject);
begin
ZoomImage1.zoom:=1.5*ZoomImage1.zoom;
CenterObs;
end;

procedure Tf_config.ObszmClick(Sender: TObject);
begin
ZoomImage1.zoom:=ZoomImage1.zoom/1.5;
CenterObs;
end;

procedure Tf_config.ObsmapClick(Sender: TObject);
begin
if fileexists(cmain.EarthMapFile) then begin
   opendialog1.InitialDir:=extractfilepath(cmain.EarthMapFile);
   opendialog1.filename:=extractfilename(cmain.EarthMapFile);
end else begin
   opendialog1.InitialDir:=slash(appdir)+'data'+pathdelim+'earthmap';
   opendialog1.filename:='';
end;
opendialog1.Filter:='PNG|*.png|JPEG|*.jpg|BMP|*.bmp';
opendialog1.DefaultExt:='.png';
try
if opendialog1.execute
   and(fileexists(opendialog1.filename))
   then begin
   cmain.EarthMapFile:=opendialog1.filename;
   ZoomImage1.Xcentre:=Obsposx;
   ZoomImage1.Ycentre:=Obsposy;
   ZoomImage1.Picture.LoadFromFile(cmain.EarthMapFile);
   SetScrollBar;
   Hscrollbar.Position:=ZoomImage1.SizeX div 2;
   Vscrollbar.Position:=ZoomImage1.SizeY div 2;
   SetObsPos;
   CenterObs;
end;
finally
   chdir(appdir);
end;
end;

procedure Tf_config.ShowHorizon;
begin
horizonopaque.checked:=not csc.horizonopaque;
horizonfile.text:=cmain.horizonfile;
end;


procedure Tf_config.horizonopaqueClick(Sender: TObject);
begin
csc.horizonopaque:=not horizonopaque.checked;
end;

procedure Tf_config.horizonfileChange(Sender: TObject);
begin
cmain.horizonfile:=horizonfile.text;
end;

procedure Tf_config.horizonfileBtnClick(Sender: TObject);
begin
if fileexists(cmain.horizonfile) then begin
   opendialog1.InitialDir:=extractfilepath(cmain.horizonfile);
   opendialog1.filename:=extractfilename(cmain.horizonfile);
end else begin
   opendialog1.InitialDir:=slash(appdir)+'data'+pathdelim+'horizon';
   opendialog1.filename:='horizon.txt';
end;
opendialog1.Filter:='All|*.*';
try
if opendialog1.execute
   and(fileexists(opendialog1.filename))
   then begin
   horizonfile.text:=opendialog1.filename;
   cmain.horizonfile:=opendialog1.filename;
end;
finally
   chdir(appdir);
end;
end;

procedure Tf_config.ShowObjList;
begin
 liststar.checked:=cshr.liststar;
 listneb.checked:=cshr.listneb;
 listvar.checked:=cshr.listvar;
 listdbl.checked:=cshr.listdbl;
 listpla.checked:=cshr.listpla;
end;


procedure Tf_config.liststarClick(Sender: TObject);
begin
cshr.liststar:=liststar.checked;
end;

procedure Tf_config.listnebClick(Sender: TObject);
begin
cshr.listneb:=listneb.checked;
end;

procedure Tf_config.listplaClick(Sender: TObject);
begin
cshr.listpla:=listpla.checked;
end;

procedure Tf_config.listvarClick(Sender: TObject);
begin
cshr.listvar:=listvar.checked;
end;

procedure Tf_config.listdblClick(Sender: TObject);
begin
cshr.listdbl:=listdbl.checked;
end;
