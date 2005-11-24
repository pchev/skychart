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

constructor Tf_config_display.Create(AOwner:TComponent);
begin
 csc:=@mycsc;
 ccat:=@myccat;
 cshr:=@mycshr;
 cplot:=@mycplot;
 cmain:=@mycmain;
 inherited Create(AOwner);
end;

procedure Tf_config_display.FormShow(Sender: TObject);
begin
ShowDisplay;
ShowFonts;
ShowColor;
ShowSkyColor;
// changes for DSO Colors
ShowDSOColor;
ShowNebColor;
ShowLine;
Showlabel;
ShowCircle;
ShowRectangle;
end;

procedure Tf_config_display.ShowDisplay;
begin
 stardisplay.itemindex:=cplot.starplot;
 nebuladisplay.itemindex:=cplot.nebplot;
 StarSizeBar.position:=round(cplot.partsize*10);
 StarContrastBar.position:=cplot.contrast;
 SaturationBar.position:=cplot.saturation;
 starvisual.visible:= (cplot.starplot=2);
 SizeContrastBar.position:=round(cplot.magsize*10);
end;

procedure Tf_config_display.ShowFonts;
begin
 SetFonts(gridfont,1);
 SetFonts(labelfont,2);
 SetFonts(legendfont,3);
 SetFonts(statusfont,4);
 SetFonts(listfont,5);
 SetFonts(prtfont,6);
 SetFonts(symbfont,7);
end;

procedure Tf_config_display.ShowColor;
begin
 bg1.color:=cplot.bgColor;
 bg2.color:=cplot.bgColor;
 bg3.color:=cplot.bgColor;
 bg4.color:=cplot.bgColor;
 shape1.brush.color:=cplot.color[1];
 shape2.brush.color:=cplot.color[2];
 shape3.brush.color:=cplot.color[3];
 shape4.brush.color:=cplot.color[4];
 shape5.brush.color:=cplot.color[5];
 shape6.brush.color:=cplot.color[6];
 shape7.brush.color:=cplot.color[7];
 shape8.pen.color:=cplot.color[8];
 shape8.brush.color:=cplot.bgColor;
 shape9.pen.color:=cplot.color[9];
 shape9.brush.color:=cplot.bgColor;
 shape10.pen.color:=cplot.color[10];
 shape10.brush.color:=cplot.bgColor;
 shape11.pen.color:=cplot.color[12];
 shape11.brush.color:=cplot.bgColor;
 shape12.pen.color:=cplot.color[13];
 shape12.brush.color:=cplot.bgColor;
 shape13.pen.color:=cplot.color[14];
 shape13.brush.color:=cplot.bgColor;
 shape14.pen.color:=cplot.color[15];
 shape14.brush.color:=cplot.bgColor;
 shape15.pen.color:=cplot.color[16];
 shape15.brush.color:=cplot.bgColor;
 shape16.pen.color:=cplot.color[17];
 shape16.brush.color:=cplot.bgColor;
 shape17.pen.color:=cplot.color[18];
 shape17.brush.color:=cplot.bgColor;
 shape25.brush.color:=cplot.color[19];
 shape26.brush.color:=cplot.color[20];
 shape27.brush.color:=cplot.color[21];
 shape28.brush.color:=cplot.color[22];
end;

procedure Tf_config_display.ShowSkyColor;
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

procedure Tf_config_display.ShowNebColor;
begin
NebGrayBar.position:=cplot.NebGray;
NebBrightBar.position:=cplot.NebBright;
UpdNebColor;
end;

// ---dso color -----------------------
procedure Tf_config_display.ShowDSOColor;
var vTCBStateChecked,vTCBStateUnChecked: TCheckBoxState;
begin
{
  Now show those objects for the active base catalogs
  Allow user to change the colours of the objects that are active
}

//  if f_config_catalog1.pa_catalog.t_cdcneb.sacbox.Checked then   shpAst.Visible = False;


//  Tf_config_catalog.sacbox.Checked then shpAst.Visible = False;
{
    pa_catalog: TPageControl;
    t_catalog: TTabSheet;


ngcbox.Checked:=ccat.NebCatDef[ngc-BaseNeb];
lbnbox.Checked:=ccat.NebCatDef[lbn-BaseNeb];
rc3box.Checked:=ccat.NebCatDef[rc3-BaseNeb];
pgcbox.Checked:=ccat.NebCatDef[pgc-BaseNeb];
oclbox.Checked:=ccat.NebCatDef[ocl-BaseNeb];
gcmbox.Checked:=ccat.NebCatDef[gcm-BaseNeb];
gpnbox.Checked:=ccat.NebCatDef[gpn-BaseNeb];
}


    shpAst.Brush.Color:=cplot.DSOColorAst;
    shpOCl.Brush.Color:=cplot.DSOColorOCl;
    shpGCl.Brush.Color:=cplot.DSOColorGCl;
    shpPNe.Brush.Color:= cplot.DSOColorPNe;
    shpDN.Brush.Color:=cplot.DSOColorDN;
    shpEN.Brush.Color:=cplot.DSOColorEN;
    shpRN.Brush.Color:=cplot.DSOColorRN;
    shpSN.Brush.Color:=cplot.DSOColorSN;
    shpGxy.Brush.Color:=cplot.DSOColorGxy;
    shpGxyCl.Brush.Color:=cplot.DSOColorGxyCL;
    shpQ.Brush.Color:=cplot.DSOColorQ;
    shpGL.Brush.Color:=cplot.DSOColorGL;
    shpNE.Brush.Color:=cplot.DSOColorNE;

    vTCBStateChecked:=cbChecked;
    vTCBStateUnChecked:=cbUnchecked;

    If (cplot.DSOColorFillAst=true)
       then chkFillAst.State:=vTCBStateChecked
       else chkFillAst.State:=vTCBStateUnChecked;
    If (cplot.DSOColorFillOCl=true)
        then chkFillOCl.State:=vTCBStateChecked
        else chkFillOCl.State:=vTCBStateUnChecked;
    If (cplot.DSOColorFillGCl=true)
        then chkFillGCl.State:=vTCBStateChecked
        else chkFillGCl.State:=vTCBStateUnChecked;
    If (cplot.DSOColorFillPNe=true)
        then chkFillPNe.State:=vTCBStateChecked
        else chkFillPNe.State:=vTCBStateUnChecked;
    If (cplot.DSOColorFillDN=true)
        then chkFillDN.State:=vTCBStateChecked
        else chkFillDN.State:=vTCBStateUnChecked;
    If (cplot.DSOColorFillEN=true)
        then chkFillEN.State:=vTCBStateChecked
        else chkFillEN.State:=vTCBStateUnChecked;
    If (cplot.DSOColorFillRN=true)
        then chkFillRN.State:=vTCBStateChecked
        else chkFillRN.State:=vTCBStateUnChecked;
    If (cplot.DSOColorFillSN=true)
        then chkFillSN.State:=vTCBStateChecked
        else chkFillSN.State:=vTCBStateUnChecked;
    If (cplot.DSOColorFillGxy=true)
        then chkFillGxy.State:=vTCBStateChecked
        else chkFillGxy.State:=vTCBStateUnChecked;
    If (cplot.DSOColorFillGxyCl=true)
        then chkFillGxyCl.State:=vTCBStateChecked
        else chkFillGxyCl.State:=vTCBStateUnChecked;
    If (cplot.DSOColorFillQ=true)
        then chkFillQ.State:=vTCBStateChecked
        else chkFillQ.State:=vTCBStateUnChecked;
    If (cplot.DSOColorFillGL=true)
        then chkFillGL.State:=vTCBStateChecked
        else chkFillGL.State:=vTCBStateUnChecked;
    If (cplot.DSOColorFillNE=true)
        then chkFillNE.State:=vTCBStateChecked
        else chkFillNE.State:=vTCBStateUnChecked;
end;

// ------------------------------------

procedure Tf_config_display.ShowLine;
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

procedure Tf_config_display.showlabelcolor;
begin

 labelcolorStar.brush.color:=cplot.labelcolor[1];
 labelcolorVar.brush.color:=cplot.labelcolor[2];
 labelcolorMult.brush.color:=cplot.labelcolor[3];
 labelcolorNeb.brush.color:=cplot.labelcolor[4];
 labelcolorSol.brush.color:=cplot.labelcolor[5];
 labelcolorConst.brush.color:=cplot.labelcolor[6];
 labelcolorMisc.brush.color:=cplot.labelcolor[7];
 labelcolorChartInfo.brush.color:=cplot.labelcolor[8];
end;

procedure Tf_config_display.showlabel;
begin
 showlabelStar.checked:=csc.showlabel[1];
 showlabelVar.checked:=csc.showlabel[2];
 showlabelMult.checked:=csc.showlabel[3];
 showlabelNeb.checked:=csc.showlabel[4];
 showlabelSol.checked:=csc.showlabel[5];
 showlabelConst.checked:=csc.showlabel[6];
 showlabelMisc.checked:=csc.showlabel[7];
 showlabelChartInfo.checked:=csc.showlabel[8];
 labelmagStar.value:=round(csc.labelmagdiff[1]);
 labelmagVar.value:=round(csc.labelmagdiff[2]);
 labelmagMult.value:=round(csc.labelmagdiff[3]);
 labelmagNeb.value:=round(csc.labelmagdiff[4]);
 labelmagSol.value:=round(csc.labelmagdiff[5]);
 labelsizeStar.value:=cplot.labelsize[1];
 labelsizeVar.value:=cplot.labelsize[2];
 labelsizeMult.value:=cplot.labelsize[3];
 labelsizeNeb.value:=cplot.labelsize[4];
 labelsizeSol.value:=cplot.labelsize[5];
 labelsizeConst.value:=cplot.labelsize[6];
 labelsizeMisc.value:=cplot.labelsize[7];
 labelsizeChartInfo.value:=cplot.labelsize[8];
 showlabelcolor;
 if csc.NameLabel then MagLabel.ItemIndex:=1
 else if csc.MagLabel then MagLabel.ItemIndex:=2
                      else MagLabel.itemindex:=0;
 if csc.ConstFullLabel then constlabel.ItemIndex:=0
                       else constlabel.ItemIndex:=1;
 Showlabelall.checked:=csc.Showlabelall;
 ShowChartInfo.checked:=cmain.ShowChartInfo;
end;

procedure Tf_config_display.ShowCircle;

var i:integer;
begin
cb1.checked:=csc.circleok[1];
cb2.checked:=csc.circleok[2];
cb3.checked:=csc.circleok[3];
cb4.checked:=csc.circleok[4];
cb5.checked:=csc.circleok[5];
cb6.checked:=csc.circleok[6];
cb7.checked:=csc.circleok[7];
cb8.checked:=csc.circleok[8];
cb9.checked:=csc.circleok[9];
cb10.checked:=csc.circleok[10];
circlegrid.ColWidths[0]:=60;
circlegrid.ColWidths[1]:=60;
circlegrid.ColWidths[2]:=60;
circlegrid.ColWidths[3]:=circlegrid.clientwidth-185;
circlegrid.Cells[0,0]:='FOV';
circlegrid.Cells[1,0]:='Rotation';
circlegrid.Cells[2,0]:='Offset';
circlegrid.Cells[3,0]:='Description';
for i:=1 to 10 do begin
  circlegrid.Cells[0,i]:=formatfloat(f2,csc.circle[i,1]);
  circlegrid.Cells[1,i]:=formatfloat(f2,csc.circle[i,2]);
  circlegrid.Cells[2,i]:=formatfloat(f2,csc.circle[i,3]);
  circlegrid.Cells[3,i]:=csc.circlelbl[i];
end;
CenterMark1.checked:=csc.ShowCircle;
end;

procedure Tf_config_display.ShowRectangle;
var i:integer;
begin
rb1.checked:=csc.rectangleok[1];
rb2.checked:=csc.rectangleok[2];
rb3.checked:=csc.rectangleok[3];
rb4.checked:=csc.rectangleok[4];
rb5.checked:=csc.rectangleok[5];
rb6.checked:=csc.rectangleok[6];
rb7.checked:=csc.rectangleok[7];
rb8.checked:=csc.rectangleok[8];
rb9.checked:=csc.rectangleok[9];
rb10.checked:=csc.rectangleok[10];
rectanglegrid.ColWidths[0]:=60;
rectanglegrid.ColWidths[1]:=60;
rectanglegrid.ColWidths[2]:=60;
rectanglegrid.ColWidths[3]:=60;
rectanglegrid.ColWidths[4]:=rectanglegrid.clientwidth-245;
rectanglegrid.Cells[0,0]:='Width';
rectanglegrid.Cells[1,0]:='Height';
rectanglegrid.Cells[2,0]:='Rotation';
rectanglegrid.Cells[3,0]:='Offset';
rectanglegrid.Cells[4,0]:='Description';
for i:=1 to 10 do begin
  rectanglegrid.Cells[0,i]:=formatfloat(f2,csc.rectangle[i,1]);
  rectanglegrid.Cells[1,i]:=formatfloat(f2,csc.rectangle[i,2]);
  rectanglegrid.Cells[2,i]:=formatfloat(f2,csc.rectangle[i,3]);
  rectanglegrid.Cells[3,i]:=formatfloat(f2,csc.rectangle[i,4]);
  rectanglegrid.Cells[4,i]:=csc.rectanglelbl[i];
end;
CenterMark2.checked:=csc.ShowCircle;
end;

procedure Tf_config_display.nebuladisplayClick(Sender: TObject);
begin
 cplot.nebplot:=nebuladisplay.itemindex;
end;

procedure Tf_config_display.stardisplayClick(Sender: TObject);
begin
 cplot.starplot:=stardisplay.itemindex;
 starvisual.visible:= (cplot.starplot=2);
end;

procedure Tf_config_display.StarSizeBarChange(Sender: TObject);
begin
cplot.partsize:= StarSizeBar.position/10;
end;

procedure Tf_config_display.SizeContrastBarChange(Sender: TObject);
begin
cplot.magsize:= SizeContrastBar.position/10;
end;

procedure Tf_config_display.StarContrastBarChange(Sender: TObject);
begin
cplot.contrast:= StarContrastBar.position;
end;

procedure Tf_config_display.SaturationBarChange(Sender: TObject);
begin
cplot.saturation:= SaturationBar.position;
end;

procedure Tf_config_display.StarButton1Click(Sender: TObject);
begin
StarSizeBar.Position:=12;
SizeContrastBar.Position:=40;
StarContrastBar.Position:=400;
SaturationBar.Position:=192;
end;

procedure Tf_config_display.StarButton2Click(Sender: TObject);
begin
StarSizeBar.Position:=12;
SizeContrastBar.Position:=10;
StarContrastBar.Position:=400;
SaturationBar.Position:=192;
end;

procedure Tf_config_display.StarButton3Click(Sender: TObject);
begin
StarSizeBar.Position:=25;
SizeContrastBar.Position:=40;
StarContrastBar.Position:=300;
SaturationBar.Position:=255;
end;

procedure Tf_config_display.StarButton4Click(Sender: TObject);
begin
StarSizeBar.Position:=12;
SizeContrastBar.Position:=40;
StarContrastBar.Position:=500;
SaturationBar.Position:=0;
end;

procedure Tf_config_display.SetFonts(ctrl:Tedit;num:integer);
begin
 ctrl.Text:=cplot.FontName[num];
 ctrl.Font.Name:=cplot.FontName[num];
 ctrl.Font.Size:=cplot.FontSize[num];
 if cplot.FontBold[num] then ctrl.Font.Style:=[fsBold]
                        else ctrl.Font.Style:=[];
 if cplot.FontItalic[num] then ctrl.Font.Style:=ctrl.Font.Style+[fsItalic];
end;

procedure Tf_config_display.SelectFontClick(Sender: TObject);
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

procedure Tf_config_display.DefaultFontClick(Sender: TObject);
var i : integer;
begin
for i:=1 to numfont do begin
    cplot.FontName[i]:=DefaultFontName;
    cplot.FontSize[i]:=DefaultFontSize;
    cplot.FontBold[i]:=false;
    cplot.FontItalic[i]:=false;
end;
cplot.FontName[7]:='Symbol';
ShowFonts;
end;

procedure Tf_config_display.ShapeMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
if sender is TShape then with sender as TShape do begin
   ColorDialog1.color:=cplot.Color[tag];
   if ColorDialog1.Execute then begin
      cplot.Color[tag]:=ColorDialog1.Color;
      ShowColor;
   end;
end;
end;

procedure Tf_config_display.DefColorClick(Sender: TObject);
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

procedure Tf_config_display.skycolorboxClick(Sender: TObject);
begin
cplot.autoskycolor:=(skycolorbox.itemindex=1);
end;

procedure Tf_config_display.ShapeSkyMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
if sender is TShape then with sender as TShape do begin
   ColorDialog1.color:=cplot.SkyColor[tag];
   if ColorDialog1.Execute then begin
      cplot.SkyColor[tag]:=ColorDialog1.Color;
      ShowSkyColor;
   end;
end;
end;

procedure Tf_config_display.Button3Click(Sender: TObject);
begin
cplot.SkyColor:=dfSkyColor;
ShowSkyColor;
end;


procedure Tf_config_display.ShapeDSOMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
if sender is TShape then
   with sender as TShape do begin
   ColorDialog1.color:=cplot.DSOColorAst;
   if ColorDialog1.Execute then begin
      if sender = shpAst then begin
         cplot.DSOColorAst:=ColorDialog1.Color;
         shpAst.Brush.Color:= cplot.DSOColorAst
//         ShowSkyColor;
      end;
      if sender = shpOCl then begin
          cplot.DSOColorOCl:=ColorDialog1.Color;
          shpOCl.Brush.Color:= cplot.DSOColorOCl;
//         ShowSkyColor;
      end;
      if sender = shpGCl then begin
          cplot.DSOColorGCl:=ColorDialog1.Color;
          shpGCl.Brush.Color:= cplot.DSOColorGCl;
//         ShowSkyColor;
      end;
      if sender = shpPNe then begin
          cplot.DSOColorPNe:=ColorDialog1.Color;
          shpPNe.Brush.Color:= cplot.DSOColorPNe;
//         ShowSkyColor;
      end;
      if sender = shpDN then begin
          cplot.DSOColorDN:=ColorDialog1.Color;
          shpDN.Brush.Color:= cplot.DSOColorDN;
//         ShowSkyColor;
      end;
      if sender = shpEN then begin
          cplot.DSOColorEN:=ColorDialog1.Color;
          shpEN.Brush.Color:= cplot.DSOColorEN;
//         ShowSkyColor;
      end;
      if sender = shpRN then begin
          cplot.DSOColorRN:=ColorDialog1.Color;
          shpRN.Brush.Color:= cplot.DSOColorRN;
//         ShowSkyColor;
      end;
      if sender = shpSN then begin
          cplot.DSOColorSN:=ColorDialog1.Color;
          shpSN.Brush.Color:= cplot.DSOColorSN;
//         ShowSkyColor;
      end;
      if sender = shpGxy then begin
          cplot.DSOColorGxy:=ColorDialog1.Color;
          shpGxy.Brush.Color:= cplot.DSOColorGxy
//         ShowSkyColor;
      end;
      if sender = shpGxyCl then begin
          cplot.DSOColorGxyCl:=ColorDialog1.Color;
          shpGxyCl.Brush.Color:= cplot.DSOColorGxyCl;
//         ShowSkyColor;
      end;
      if sender = shpQ then begin
          cplot.DSOColorQ:=ColorDialog1.Color;
          shpQ.Brush.Color:= cplot.DSOColorQ;
//         ShowSkyColor;
      end;
      if sender = shpGL then begin
          cplot.DSOColorGL:=ColorDialog1.Color;
          shpGL.Brush.Color:= cplot.DSOColorGL;
//         ShowSkyColor;
      end;
      if sender = shpNE then begin
          cplot.DSOColorNE:=ColorDialog1.Color;
          shpNE.Brush.Color:= cplot.DSOColorNE;
//         ShowSkyColor;
      end;
   end;
end;
end;

procedure Tf_config_display.FillDSOMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
if sender is TCheckBox then
   with sender as TCheckBox do begin
   cplot.DSOColorFillOCl:=false;
   if sender = chkFillGCl then cplot.DSOColorFillOCl:=true;
   end;
end;

procedure Tf_config_display.UpdNebColor;
  function SetColor(i,col:integer):Tcolor;
   var r,g,b: byte;
   begin
     r:=cplot.Color[i] and $FF;
     g:=(cplot.Color[i] shr 8) and $FF;
     b:=(cplot.Color[i] shr 16) and $FF;
     result:=(r*col div 255)+256*(g*col div 255)+65536*(b*col div 255);
   end;
begin
NebColorPanel.color:=cplot.Color[0];
shape29.brush.color:=SetColor(8,cplot.NebGray);
shape30.brush.color:=SetColor(8,cplot.NebBright);
end;

procedure Tf_config_display.NebShapeMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
if sender is TShape then with sender as TShape do begin
   ColorDialog1.color:=cplot.Color[tag];
   if ColorDialog1.Execute then begin
      cplot.Color[tag]:=ColorDialog1.Color;
      UpdNebColor;
   end;
end;
end;

procedure Tf_config_display.NebGrayBarChange(Sender: TObject);
begin
if NebGrayBar.position < cplot.NebBright then begin
   cplot.NebGray:=NebGrayBar.position;
   UpdNebColor;
end else begin
   NebGrayBar.position:=cplot.NebBright-1;
end;
end;

procedure Tf_config_display.NebBrightBarChange(Sender: TObject);
begin
if NebBrightBar.position > cplot.NebGray then begin
   cplot.NebBright:=NebBrightBar.position;
   UpdNebColor;
end else begin
   NebBrightBar.position:=cplot.NebGray+1;
end;
end;

procedure Tf_config_display.DefNebColorButtonClick(Sender: TObject);
begin
cplot.Nebgray:=55;
cplot.NebBright:=180;

case DefColor.ItemIndex of

  0 : begin
      cplot.Color[8]:=DfColor[8];
      cplot.Color[9]:=DfColor[9];
      cplot.Color[10]:=DfColor[10];
      end;
  1 : begin
      cplot.Color[8]:=DfRedColor[8];
      cplot.Color[9]:=DfRedColor[9];
      cplot.Color[10]:=DfRedColor[10];
      end;
  2 : begin
      cplot.Color[8]:=DfBWColor[8];
      cplot.Color[9]:=DfBWColor[9];
      cplot.Color[10]:=DfBWColor[10];
      end;
  3 : begin
      cplot.Color[8]:=DfWBColor[8];
      cplot.Color[9]:=DfWBColor[9];
      cplot.Color[10]:=DfWBColor[10];
      end;
end;
ShowNebColor;

end;

procedure Tf_config_display.CGridClick(Sender: TObject);
begin
  csc.ShowGrid:=CGrid.Checked;
end;

procedure Tf_config_display.EqGridClick(Sender: TObject);
begin
  csc.ShowEqGrid:=EqGrid.Checked;
end;

procedure Tf_config_display.GridNumClick(Sender: TObject);
begin
  csc.ShowGridNum:=GridNum.Checked;
end;

procedure Tf_config_display.eclipticClick(Sender: TObject);
begin
  csc.Showecliptic:=ecliptic.Checked;
end;

procedure Tf_config_display.galacticClick(Sender: TObject);
begin
  csc.Showgalactic:=galactic.Checked;
end;

procedure Tf_config_display.ConstlClick(Sender: TObject);
begin
  csc.ShowConstl:=ConstL.Checked;
end;

procedure Tf_config_display.ConstlFileChange(Sender: TObject);
begin
  cmain.ConstLfile:=expandfilename(ConstlFile.Text);
end;

procedure Tf_config_display.ConstlFileBtnClick(Sender: TObject);
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

procedure Tf_config_display.ConstbClick(Sender: TObject);
begin
  csc.ShowConstb:=ConstB.Checked;
end;

procedure Tf_config_display.ConstbFileChange(Sender: TObject);
begin
  cmain.ConstBfile:=expandfilename(ConstbFile.Text);
end;

procedure Tf_config_display.ConstbfileBtnClick(Sender: TObject);
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

procedure Tf_config_display.milkywayClick(Sender: TObject);
begin
  csc.showmilkyway:=milkyway.checked;
end;

procedure Tf_config_display.fillmilkywayClick(Sender: TObject);
begin
  csc.fillmilkyway:=fillmilkyway.checked;
end;

procedure Tf_config_display.showlabelClick(Sender: TObject);
begin
with sender as TCheckBox do csc.ShowLabel[tag]:=checked;
end;

procedure Tf_config_display.showlabelallClick(Sender: TObject);
begin
csc.Showlabelall:=Showlabelall.checked;
end;

procedure Tf_config_display.ShowChartInfoClick(Sender: TObject);
begin
cmain.ShowChartInfo:=ShowChartInfo.checked;
end;

{$ifdef mswindows}
procedure Tf_config_display.labelmagChanged(Sender: TObject);
{$endif}
{$ifdef linux }
procedure Tf_config_display.labelmagChanged(Sender: TObject; NewValue: Integer);
{$endif}
begin
with sender as TSpinEdit do csc.LabelmagDiff[tag]:=value;
end;

procedure Tf_config_display.labelcolorMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
if sender is TShape then with sender as TShape do begin
   ColorDialog1.color:=cplot.LabelColor[tag];
   if ColorDialog1.Execute then begin
      cplot.LabelColor[tag]:=ColorDialog1.Color;
      ShowLabelColor;
   end;
end;
end;

{$ifdef mswindows}
procedure Tf_config_display.labelsizeChanged(Sender: TObject);
{$endif}
{$ifdef linux }
procedure Tf_config_display.labelsizeChanged(Sender: TObject; NewValue: Integer);
{$endif}
begin
with sender as TSpinEdit do cplot.LabelSize[tag]:=value;
end;

procedure Tf_config_display.MagLabelClick(Sender: TObject);
begin
csc.MagLabel:=(MagLabel.ItemIndex=2);
csc.NameLabel:=(MagLabel.ItemIndex=1);
end;

procedure Tf_config_display.constlabelClick(Sender: TObject);
begin
csc.ConstFullLabel:=(constlabel.ItemIndex=0);
end;


procedure Tf_config_display.cbClick(Sender: TObject);
begin
 with Sender as TCheckBox do csc.circleok[tag]:=checked;
end;

{$ifdef mswindows}
procedure Tf_config_display.CirclegridSetEditText(Sender: TObject; ACol,ARow: Integer; const Value: String);
{$endif}
{$ifdef linux }
procedure Tf_config_display.CirclegridSetEditText(Sender: TObject; ACol,ARow: Integer; const Value: WideString);
{$endif}
var x:single;
    n:integer;
begin
case ACol of
0 : begin
    val(value,x,n);
    if n=0 then csc.circle[Arow,1]:=x
           else beep;
    end;
1 : begin
    val(value,x,n);
    if n=0 then csc.circle[Arow,2]:=x
           else beep;
    end;
2 : begin
    val(value,x,n);
    if n=0 then csc.circle[Arow,3]:=x
           else beep;
    end;
3 : begin
    csc.circlelbl[ARow]:=Value;
    end;
end;
end;

procedure Tf_config_display.CenterMark1Click(Sender: TObject);
begin
with sender as TCheckbox do begin
 csc.ShowCircle:=checked;
 CenterMark1.checked:=checked;
 CenterMark2.checked:=checked;
end;
end;

{$ifdef mswindows}
procedure Tf_config_display.RectangleGridSetEditText(Sender: TObject; ACol,ARow: Integer; const Value: String);
{$endif}
{$ifdef linux }
procedure Tf_config_display.RectangleGridSetEditText(Sender: TObject; ACol,ARow: Integer; const Value: WideString);
{$endif}
var x:single;
    n:integer;
begin
case ACol of
0 : begin
    val(value,x,n);
    if n=0 then csc.rectangle[Arow,1]:=x
           else beep;
    end;
1 : begin
    val(value,x,n);
    if n=0 then csc.rectangle[Arow,2]:=x
           else beep;
    end;
2 : begin
    val(value,x,n);
    if n=0 then csc.rectangle[Arow,3]:=x
           else beep;
    end;
3 : begin
    val(value,x,n);
    if n=0 then csc.rectangle[Arow,4]:=x
           else beep;
    end;
4 : begin
    csc.rectanglelbl[ARow]:=Value;
    end;
end;
end;

procedure Tf_config_display.rbClick(Sender: TObject);
begin
with Sender as TCheckBox do csc.rectangleok[tag]:=checked;
end;


procedure Tf_config_display.chkFillAstClick(Sender: TObject);
begin
with sender as TCheckbox do begin
  if chkFillAst.Checked
    then cplot.DSOColorFillAst:=true
    else cplot.DSOColorFillAst:=false;
  end;
end;

procedure Tf_config_display.chkFillOClClick(Sender: TObject);
begin
with sender as TCheckbox do begin
  if chkFillOCl.Checked
    then cplot.DSOColorFillOCl:=true
    else cplot.DSOColorFillOCl:=false;
end;
end;

procedure Tf_config_display.chkFillPNeClick(Sender: TObject);
begin
with sender as TCheckbox do begin
  if chkFillPNe.Checked
    then cplot.DSOColorFillPNe:=true
    else cplot.DSOColorFillPNe:=false;
end;
end;

procedure Tf_config_display.chkFillGClClick(Sender: TObject);
begin
with sender as TCheckbox do begin
  if chkFillGCl.Checked
    then cplot.DSOColorFillGCl:=true
    else cplot.DSOColorFillGCl:=false;
end;
end;

procedure Tf_config_display.chkFillDNClick(Sender: TObject);
begin
with sender as TCheckbox do begin
  if chkFillDN.Checked
    then cplot.DSOColorFillDN:=true
    else cplot.DSOColorFillDN:=false;
  end;
end;

procedure Tf_config_display.chkFillENClick(Sender: TObject);
begin
with sender as TCheckbox do begin
  if chkFillEN.Checked
    then cplot.DSOColorFillEN:=true
    else cplot.DSOColorFillEN:=false;
  end;
end;

procedure Tf_config_display.chkFillRNClick(Sender: TObject);
begin
with sender as TCheckbox do begin
  if chkFillRN.Checked
    then cplot.DSOColorFillRN:=true
    else cplot.DSOColorFillRN:=false;
  end;
end;

procedure Tf_config_display.chkFillSNClick(Sender: TObject);
begin
with sender as TCheckbox do begin
  if chkFillSN.Checked
    then cplot.DSOColorFillSN:=true
    else cplot.DSOColorFillSN:=false;
  end;
end;

procedure Tf_config_display.chkFillGxyClick(Sender: TObject);
begin
with sender as TCheckbox do begin
  if chkFillGxy.Checked
    then cplot.DSOColorFillGxy:=true
    else cplot.DSOColorFillGxy:=false;
  end;
end;

procedure Tf_config_display.chkFillGxyClClick(Sender: TObject);
begin
with sender as TCheckbox do begin
  if chkFillGxyCl.Checked
    then cplot.DSOColorFillGxyCl:=true
    else cplot.DSOColorFillGxyCl:=false;
  end;
end;

procedure Tf_config_display.chkFillQClick(Sender: TObject);
begin
with sender as TCheckbox do begin
  if chkFillQ.Checked
    then cplot.DSOColorFillQ:=true
    else cplot.DSOColorFillQ:=false;
  end;
end;

procedure Tf_config_display.chkFillGLClick(Sender: TObject);
begin
with sender as TCheckbox do begin
  if chkFillGL.Checked
    then cplot.DSOColorFillGL:=true
    else cplot.DSOColorFillGL:=false;
  end;
end;

procedure Tf_config_display.chkFillNEClick(Sender: TObject);
begin
with sender as TCheckbox do begin
  if chkFillNE.Checked
    then cplot.DSOColorFillNE:=true
    else cplot.DSOColorFillNE:=false;
  end;
end;

procedure Tf_config_display.lstDSOCSchemeClick(Sender: TObject);
var
  i: Integer;
begin
  for i := 0 to (lstDSOCScheme.Items.Count - 1)
    do begin
      if lstDSOCScheme.Selected[i] then
        case i of
//        CdC v2.nn
          0: begin //CdC v2.nn
              shpAst.Brush.Color:=16776960;
              shpOCl.Brush.Color:=16776960;
              shpGCl.Brush.Color:=16776960;
              shpPNe.Brush.Color:=8454016;
              shpDN.Brush.Color:=12632256;
              shpEN.Brush.Color:=8454016;
              shpRN.Brush.Color:=8454016;
              shpSN.Brush.Color:=0;
              shpGxy.Brush.Color:=255;
              shpGxyCl.Brush.Color:=255;
              shpQ.Brush.Color:=0;
              shpGL.Brush.Color:=0;
              shpNE.Brush.Color:=16777215;
             end;
          1: begin //CdC v3.nn
              shpAst.Brush.Color:=8454143;
              shpOCl.Brush.Color:=8454143;
              shpGCl.Brush.Color:=16777088;
              shpPNe.Brush.Color:=8453888;
              shpDN.Brush.Color:=12632256;
              shpEN.Brush.Color:=255;
              shpRN.Brush.Color:=16744448;
              shpSN.Brush.Color:=0;
              shpGxy.Brush.Color:=255;
              shpGxyCl.Brush.Color:=255;
              shpQ.Brush.Color:=8421631;
              shpGL.Brush.Color:=16711808;
              shpNE.Brush.Color:=16777215;
             end;
          2: begin //Tirion Sky Atlas 2000
              shpAst.Brush.Color:=8454143;
              shpOCl.Brush.Color:=8454143;
              shpGCl.Brush.Color:=65535;
              shpPNe.Brush.Color:=4259584;
              shpDN.Brush.Color:=8421504;
              shpEN.Brush.Color:=16711935;
              shpRN.Brush.Color:=16711935;
              shpSN.Brush.Color:=4227327;
              shpGxy.Brush.Color:=255;
              shpGxyCl.Brush.Color:=255;
              shpQ.Brush.Color:=255;
              shpGL.Brush.Color:=16776960;
              shpNE.Brush.Color:=12632256;
             end;
          3: begin //Megastar
              shpAst.Brush.Color:=4259584;
              shpOCl.Brush.Color:=4259584;
              shpGCl.Brush.Color:=4259584;
              shpPNe.Brush.Color:=4259584;
              shpDN.Brush.Color:=4259584;
              shpEN.Brush.Color:=4259584;
              shpRN.Brush.Color:=4259584;
              shpSN.Brush.Color:=4259584;
              shpGxy.Brush.Color:=4259584;
              shpGxyCl.Brush.Color:=4259584;
              shpQ.Brush.Color:=4259584;
              shpGL.Brush.Color:=4259584;
              shpNE.Brush.Color:=4259584;
             end;
          end;
          cplot.DSOColorAst:=shpAst.Brush.Color;
          cplot.DSOColorOCl:=shpOCl.Brush.Color;
          cplot.DSOColorGCl:=shpGCl.Brush.Color;
          cplot.DSOColorPNe:=shpPNe.Brush.Color;
          cplot.DSOColorDN:=shpDN.Brush.Color;
          cplot.DSOColorEN:=shpEN.Brush.Color;
          cplot.DSOColorRN:=shpRN.Brush.Color;
          cplot.DSOColorSN:=shpSN.Brush.Color;
          cplot.DSOColorGxy:=shpGxy.Brush.Color;
          cplot.DSOColorGxyCL:=shpGxyCl.Brush.Color;
          cplot.DSOColorQ:=shpQ.Brush.Color;
          cplot.DSOColorGL:=shpGL.Brush.Color;
          cplot.DSOColorNE:=shpNE.Brush.Color;
    end;
  end;


