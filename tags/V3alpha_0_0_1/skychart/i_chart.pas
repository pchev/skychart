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
 Cross-platform common code for Chart form.
}

procedure Tf_chart.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure Tf_chart.FormCreate(Sender: TObject);
begin
 sc:=Tskychart.Create(self);
 // set initial value
 sc.cfgsc.racentre:=1.4;
 sc.cfgsc.decentre:=0;
 sc.cfgsc.fov:=1;
 sc.cfgsc.theta:=0;
 sc.cfgsc.projtype:='A';
 sc.cfgsc.ProjPole:=0;
 sc.cfgsc.FlipX:=1;
 sc.cfgsc.FlipY:=1;
 sc.plot.cnv:=Image1.canvas;
 sc.InitChart;
 movefactor:=4;
 zoomfactor:=2;
end;

procedure Tf_chart.FormDestroy(Sender: TObject);
begin
 sc.free;
end;

procedure Tf_chart.Refresh;
begin
 screen.cursor:=crHourGlass;
 Image1.width:=clientwidth;
 Image1.height:=clientheight;
 Image1.Picture.Bitmap.Width:=Image1.width;
 Image1.Picture.Bitmap.Height:=Image1.Height;
 sc.plot.init(Image1.width,Image1.height);
 sc.Refresh;
 screen.cursor:=crDefault;
end;

procedure Tf_chart.FormResize(Sender: TObject);
begin
RefreshTimer.Enabled:=false;
RefreshTimer.Enabled:=true;
Image1.Picture.Bitmap.Width:=Image1.width;
Image1.Picture.Bitmap.Height:=Image1.Height;
if sc<>nil then sc.plot.init(Image1.width,Image1.height);
end;

procedure Tf_chart.RefreshTimerTimer(Sender: TObject);
begin
RefreshTimer.Enabled:=false;
{ maximize a new window now to avoid a Kylix bug
  if WindowState is set to wsMaximized at creation }
if maximize then begin
 { beware to pass here only for the first refresh to avoid to loop}
 maximize:=false;
 windowstate:=wsMaximized;
 setfocus;
end;
Image1.Picture.Bitmap.Width:=Image1.width;
Image1.Picture.Bitmap.Height:=Image1.Height;
if sc<>nil then sc.plot.init(Image1.width,Image1.height);
Refresh;
end;

procedure Tf_chart.PrintChart(Sender: TObject);
begin
 Printer.Orientation:=poLandscape;
 Printer.BeginDoc;
 sc.plot.cnv:=Printer.canvas;
 sc.plot.cfgchart.onprinter:=true;
 sc.plot.init(Printer.pagewidth,Printer.pageheight);
 sc.Refresh;
 Printer.EndDoc;
 sc.plot.cnv:=Image1.canvas;
 sc.plot.cfgchart.onprinter:=false;
 Image1.Picture.Bitmap.Width:=Image1.width;
 Image1.Picture.Bitmap.Height:=Image1.Height;
 sc.plot.init(Image1.width,Image1.height);
 sc.Refresh;
end;

procedure Tf_chart.FormShow(Sender: TObject);
begin
{ update the chart after it is show a first time (part of the wsMaximized bug bypass) }
RefreshTimer.enabled:=true;
end;

procedure Tf_chart.FormActivate(Sender: TObject);
begin
f_main.updatebtn(sc.cfgsc.flipx,sc.cfgsc.flipy);
end;

procedure Tf_chart.FlipxExecute(Sender: TObject);
begin
 sc.cfgsc.FlipX:=-sc.cfgsc.FlipX;
 f_main.updatebtn(sc.cfgsc.flipx,sc.cfgsc.flipy);
 Refresh;
end;

procedure Tf_chart.FlipyExecute(Sender: TObject);
begin
 sc.cfgsc.FlipY:=-sc.cfgsc.FlipY;
 f_main.updatebtn(sc.cfgsc.flipx,sc.cfgsc.flipy);
 Refresh;
end;

procedure Tf_chart.zoomplusExecute(Sender: TObject);
begin
sc.zoom(zoomfactor);
Refresh;
end;

procedure Tf_chart.zoomminusExecute(Sender: TObject);
begin
sc.zoom(1/zoomfactor);
Refresh;
end;

procedure Tf_chart.zoomplusmoveExecute(Sender: TObject);
begin
sc.zoom(zoomfactor);
sc.MovetoXY(xcursor,ycursor);
Refresh;
end;

procedure Tf_chart.zoomminusmoveExecute(Sender: TObject);
begin
sc.zoom(1/zoomfactor);
sc.MovetoXY(xcursor,ycursor);
Refresh;
end;


procedure Tf_chart.MoveWestExecute(Sender: TObject);
begin
 sc.MoveChart(0,-1,movefactor);
 Refresh;
end;

procedure Tf_chart.MoveEastExecute(Sender: TObject);
begin
 sc.MoveChart(0,1,movefactor);
 Refresh;
end;

procedure Tf_chart.MoveNorthExecute(Sender: TObject);
begin
 sc.MoveChart(1,0,movefactor);
 Refresh;
end;

procedure Tf_chart.MoveSouthExecute(Sender: TObject);
begin
 sc.MoveChart(-1,0,movefactor);
 Refresh;
end;

procedure Tf_chart.MoveNorthWestExecute(Sender: TObject);
begin
 sc.MoveChart(1,-1,movefactor);
 Refresh;
end;

procedure Tf_chart.MoveNorthEastExecute(Sender: TObject);
begin
 sc.MoveChart(1,1,movefactor);
 Refresh;
end;

procedure Tf_chart.MoveSouthWestExecute(Sender: TObject);
begin
 sc.MoveChart(-1,-1,movefactor);
 Refresh;
end;

procedure Tf_chart.MoveSouthEastExecute(Sender: TObject);
begin
 sc.MoveChart(-1,1,movefactor);
 Refresh;
end;

procedure Tf_chart.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
if Shift = [ssShift] then begin
   movefactor:=8;
   zoomfactor:=1.5;
end;
if Shift = [ssCtrl] then begin
   movefactor:=2;
   zoomfactor:=3;
end;
case key of
{$ifdef linux}
43 : Zoomplus.execute;
45 : Zoomminus.execute;
4112 : MoveNorthEast.execute;
4113 : MoveSouthEast.execute;
4114 : MoveEast.execute;
4115 : MoveNorth.execute;
4116 : MoveWest.execute;
4117 : MoveSouth.execute;
4118 : MoveNorthWest.execute;
4119 : MoveSouthWest.execute;
{$endif}
{$ifdef mswindows}
33 : MoveNorthWest.execute;
34 : MoveSouthWest.execute;
35 : MoveSouthEast.execute;
36 : MoveNorthEast.execute;
37 : MoveEast.execute;
38 : MoveNorth.execute;
39 : MoveWest.execute;
40 : MoveSouth.execute;
107 : Zoomplus.execute;
109 : Zoomminus.execute;
{$endif}
end;
movefactor:=4;
zoomfactor:=2;
end;

procedure Tf_chart.PopupMenu1Popup(Sender: TObject);
begin
 xcursor:=ScreenToClient(mouse.cursorpos).x;
 ycursor:=ScreenToClient(mouse.cursorpos).y;
end;

procedure Tf_chart.CentreExecute(Sender: TObject);
begin
  sc.MovetoXY(xcursor,ycursor);
  Refresh;
end;

procedure Tf_chart.FormMouseWheel(Sender: TObject; Shift: TShiftState;
  WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
begin
handled:=true;
if skip_wheel then begin   // why two events for each wheel turn ?
   skip_wheel:=false;
   exit;
end;
   skip_wheel:=true;
   lock_TrackCursor:=true;
   if wheeldelta>0 then sc.Zoom(1.25)
                   else sc.Zoom(0.8);
   Refresh;
end;

procedure Tf_chart.Image1MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
var ra,dec:double;
    txt:string;
begin
{ activate the chart with the mouse }
setfocus;
{show the coordinates}
sc.GetCoord(x,y,ra,dec);
ra:=rmod(ra+pi2,pi2);
txt:='Ra:'+arptostr(rad2deg*ra/15)+' '+deptostr(rad2deg*dec);
f_main.SetLpanel0(txt);
end;

procedure Tf_chart.Image1MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var ra,dec,dx:double;
    txt,ltxt:string;
begin
sc.GetCoord(x,y,ra,dec);
ra:=rmod(ra+pi2,pi2);
dx:=5/sc.cfgsc.BxGlb; // search a 5 pixel radius
sc.FindatRaDec(ra,dec,dx,txt,ltxt);
f_main.SetLpanel1(txt);
end;


