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
 sc:=Tskychart.Create(Image1);
 // set initial value
 sc.cfgsc.racentre:=1.4;
 sc.cfgsc.decentre:=0;
 sc.cfgsc.fov:=1;
 sc.cfgsc.theta:=0;
 sc.cfgsc.projtype:='A';
 sc.cfgsc.ProjPole:=Equat;
 sc.cfgsc.FlipX:=1;
 sc.cfgsc.FlipY:=1;
 sc.onShowDetailXY:=IdentDetail;
 sc.InitChart;
 sc.plot.init(Image1.width,Image1.height);
 movefactor:=4;
 zoomfactor:=2;
 lastundo:=0;
 validundo:=0;
 {$ifdef mswindows}
 Image1.Cursor := crRetic;
 {$endif}
 lock_refresh:=false;
end;

procedure Tf_chart.FormDestroy(Sender: TObject);
begin
 sc.free;
end;

procedure Tf_chart.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
CKeyDown(Key,Shift);
end;

procedure Tf_chart.Image1Click(Sender: TObject);
begin
// to restore focus to the chart that as no text control
// it is also mandatory to keep the keydown and mousewheel
// event to the main form.
if assigned(FImageSetFocus) then FImageSetFocus(Sender);
end;

procedure Tf_chart.AutoRefresh;
begin
if locked then exit;
if (not sc.cfgsc.TrackOn)and(sc.cfgsc.Projpole=Altaz) then begin
  sc.cfgsc.TrackOn:=true;
  sc.cfgsc.TrackType:=4;
end;
Refresh;
end;

procedure Tf_chart.Refresh;
begin
try
if locked then exit;
if lock_refresh then exit;
 lock_refresh:=true;
 lastquick:=sc.cfgsc.quick;
 if not lastquick then screen.cursor:=crHourGlass;
 zoomstep:=0;
 identlabel.visible:=false;
 Image1.width:=clientwidth;
 Image1.height:=clientheight;
 Image1.Picture.Bitmap.Width:=Image1.width;
 Image1.Picture.Bitmap.Height:=Image1.Height;
 sc.plot.init(Image1.width,Image1.height);
 sc.Refresh;
 if not lastquick then begin
    inc(lastundo); inc(validundo);
    if lastundo>maxundo then lastundo:=1;
    undolist[lastundo]:=sc.cfgsc;
    curundo:=lastundo;
    Identlabel.color:=sc.plot.cfgplot.color[0];
    Identlabel.font.color:=sc.plot.cfgplot.color[11];
    Panel1.color:=sc.plot.cfgplot.color[0];
    if sc.cfgsc.FindOk then ShowIdentLabel;
    if assigned(fshowtopmessage) then fshowtopmessage(GetChartInfo);
 end;
finally
 lock_refresh:=false;
 screen.cursor:=crDefault;
end;
end;

function Tf_chart.GetChartInfo:string;
var cep,dat:string;
begin
    cep:=trim(sc.cfgsc.EquinoxName);
    if cep='Date' then cep:=sc.cfgsc.EquinoxDate;
    dat:=YearADBC(sc.cfgsc.CurYear)+'-'+inttostr(sc.cfgsc.curmonth)+'-'+inttostr(sc.cfgsc.curday)+blank+ArToStr3(sc.cfgsc.Curtime)+' (+'+trim(ArmtoStr(sc.cfgsc.TimeZone))+')';
    case sc.cfgsc.projpole of
    Equat : result:='Equatorial Coord. '+cep+blank+dat;
    AltAz : result:='Alt/AZ Coord. '+trim(sc.cfgsc.ObsName)+blank+dat;
    Gal :   result:='Galactic Coordinates'+blank+dat;
    Ecl :   result:='Ecliptic Coord. '+cep+blank+dat+', Inclination='+detostr(sc.cfgsc.e*rad2deg);
    else result:='';
    end;
    result:=result+' Mag:'+formatfloat(f1,sc.plot.cfgchart.min_ma)+' FOV:'+detostr(sc.cfgsc.fov*rad2deg);
end;

procedure Tf_chart.UndoExecute(Sender: TObject);
var i,j : integer;
begin
if locked then exit;
zoomstep:=0;
i:=curundo-1;
j:=lastundo+1;
if i<1 then i:=maxundo;
if j>maxundo then j:=1;
if (i<=validundo)and(i<>lastundo)and((i<lastundo)or(i>=j)) then begin
  curundo:=i;
  sc.cfgsc:=undolist[curundo];
  sc.plot.init(Image1.width,Image1.height);
  sc.Refresh;
  if assigned(fshowtopmessage) then fshowtopmessage(GetChartInfo);
end;
end;

procedure Tf_chart.RedoExecute(Sender: TObject);
var i,j : integer;
begin
if locked then exit;
zoomstep:=0;
i:=curundo+1;
j:=lastundo+1;
if i>maxundo then i:=1;
if j>maxundo then j:=1;
if (i<=validundo)and(i<>j)and((i<=lastundo)or(i>j)) then begin
  curundo:=i;
  sc.cfgsc:=undolist[curundo];
  sc.plot.init(Image1.width,Image1.height);
  sc.Refresh;
  if assigned(fshowtopmessage) then fshowtopmessage(GetChartInfo);
end;
end;

procedure Tf_chart.FormResize(Sender: TObject);
begin
if locked then exit;
RefreshTimer.Enabled:=false;
RefreshTimer.Enabled:=true;
Image1.Picture.Bitmap.Width:=Image1.width;
Image1.Picture.Bitmap.Height:=Image1.Height;
if sc<>nil then sc.plot.init(Image1.width,Image1.height);
end;

procedure Tf_chart.RefreshTimerTimer(Sender: TObject);
begin
RefreshTimer.Enabled:=false;
if locked then exit;
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

procedure Tf_chart.PrintChart(printlandscape:boolean; printcolor,printmethod,printresol:integer ;printcmd1,printcmd2,printpath:string);
var savecolor: Starcolarray;
    savesplot,savenplot,savepplot,savebgcolor,resol: integer;
    saveskycolor: boolean;
    prtname:string;
    prtbmp:Tbitmap;
    fname:WideString;
    cmd:string;
    i:integer;
 begin
 zoomstep:=0;
 // save current state
 savecolor:=sc.plot.cfgplot.color;
 savesplot:=sc.plot.cfgplot.starplot;
 savenplot:=sc.plot.cfgplot.nebplot;
 savepplot:=sc.plot.cfgplot.plaplot;
 saveskycolor:=sc.plot.cfgplot.autoskycolor;
 savebgcolor:=sc.plot.cfgplot.bgColor;
 prtbmp:=Tbitmap.create;
try
 screen.cursor:=crHourGlass;
 if printcolor<>2 then begin
   // force line drawing
   sc.plot.cfgplot.starplot:=0;
   sc.plot.cfgplot.nebplot:=0;
   if sc.plot.cfgplot.plaplot=2 then sc.plot.cfgplot.plaplot:=1;
   // ensure white background
   sc.plot.cfgplot.autoskycolor:=false;
   if printcolor=0 then begin
     sc.plot.cfgplot.color[0]:=clWhite;
     sc.plot.cfgplot.color[11]:=clBlack;
   end else begin
     sc.plot.cfgplot.color:=DfWBColor;
   end;
   sc.plot.cfgplot.bgColor:=sc.plot.cfgplot.color[0];
 end;
 Case PrintMethod of
 0: begin
    GetPrinterResolution(prtname,resol);
    if PrintLandscape then Printer.Orientation:=poLandscape
                   else Printer.Orientation:=poPortrait;
    // print
    Printer.BeginDoc;
    sc.plot.cnv:=Printer.canvas;
    sc.plot.cfgchart.onprinter:=true;
    sc.plot.cfgchart.drawpen:=maxintvalue([1,resol div 75]);
    sc.plot.init(Printer.pagewidth,Printer.pageheight);
    sc.Refresh;
    Printer.EndDoc;
    end;
 1: begin
    if assigned(Fshowinfo) then Fshowinfo('Create raster chart at '+inttostr(printresol)+' dpi. Please wait...' ,caption);
    {$ifdef mswindows}prtbmp.pixelformat:=pf24bit;{$endif}
    {$ifdef linux}prtbmp.pixelformat:=pf32bit;{$endif}
    if PrintLandscape then begin
       prtbmp.width:=11*printresol;
       prtbmp.height:=8*printresol;
    end else begin
       prtbmp.width:=8*printresol;
       prtbmp.height:=11*printresol;
    end;
   // draw the chart to the bitmap
    sc.plot.cnv:=prtbmp.canvas;
    sc.plot.cfgchart.onprinter:=true;
    sc.plot.cfgchart.drawpen:=maxintvalue([1,printresol div 75]);
    sc.plot.init(prtbmp.width,prtbmp.height);
    sc.Refresh;
    // convert the bitmap to Postscript
   {$ifdef linux}
      if printcolor=1 then begin
         fname:=slash(printpath)+'cdcprint.pgm';
         QPixMap_save(prtbmp.Handle,@fname,PChar('PGM'));
      end else begin
         fname:=slash(printpath)+'cdcprint.ppm';
         QPixMap_save(prtbmp.Handle,@fname,PChar('PPM'));
      end;
      cmd:='pnmtops -equalpixels -dpi='+inttostr(printresol)+' -rle '+fname+' >'+changefileext(fname,'.ps');
    {$endif}
    {$ifdef mswindows}
      fname:=slash(printpath)+'cdcprint.bmp';
      prtbmp.savetofile(fname);
      //cmd:='bmptopnm '+fname+' | pnmtops -equalpixels -dpi='+inttostr(printresol)+' -rle >'+changefileext(fname,'.ps');
      cmd:='command.com /C bmptops.bat '+fname+' '+changefileext(fname,'.ps');
      chdir(slash(appdir)+'plugins\netpbm');
    {$endif}
    i:=exec(cmd);
    chdir(appdir);
    if i=0 then begin
       if assigned(Fshowinfo) then Fshowinfo('Send chart to printer.' ,caption);
       deletefile(fname);
       execnowait(printcmd1+' '+changefileext(fname,'.ps'));
    end else showmessage('Print failed, return code='+inttostr(i));
    end;
 2: begin
    if assigned(Fshowinfo) then Fshowinfo('Create raster chart at '+inttostr(printresol)+' dpi. Please wait...' ,caption);
    {$ifdef mswindows}prtbmp.pixelformat:=pf24bit;{$endif}
    {$ifdef linux}prtbmp.pixelformat:=pf32bit;{$endif}
    if PrintLandscape then begin
       prtbmp.width:=11*printresol;
       prtbmp.height:=8*printresol;
    end else begin
       prtbmp.width:=8*printresol;
       prtbmp.height:=11*printresol;
    end;
   // draw the chart to the bitmap
    sc.plot.cnv:=prtbmp.canvas;
    sc.plot.cfgchart.onprinter:=true;
    sc.plot.cfgchart.drawpen:=maxintvalue([1,printresol div 75]);
    sc.plot.init(prtbmp.width,prtbmp.height);
    sc.Refresh;
    // save the bitmap
    fname:=slash(printpath)+'cdcprint.bmp';
    prtbmp.savetofile(fname);
    if printcmd2<>'' then begin
       if assigned(Fshowinfo) then Fshowinfo('Open the bitmap.' ,caption);
       execnowait(printcmd2+' '+fname);
    end;
 end;
end;
finally
 chdir(appdir);
 screen.cursor:=crDefault;
 prtbmp.free;
 // restore state
 sc.plot.cfgplot.color:=savecolor;
 sc.plot.cfgplot.starplot:=savesplot;
 sc.plot.cfgplot.nebplot:=savenplot;
 sc.plot.cfgplot.plaplot:=savepplot;
 sc.plot.cfgplot.autoskycolor:=saveskycolor;
 sc.plot.cfgplot.bgColor:=savebgcolor;
 // redraw to screen
 sc.plot.cnv:=Image1.canvas;
 sc.plot.cfgchart.onprinter:=false;
 sc.plot.cfgchart.drawpen:=1;
 Image1.Picture.Bitmap.Width:=Image1.width;
 Image1.Picture.Bitmap.Height:=Image1.Height;
 sc.plot.init(Image1.width,Image1.height);
 sc.Refresh;
end;
end;

procedure Tf_chart.FormShow(Sender: TObject);
begin
{ update the chart after it is show a first time (part of the wsMaximized bug bypass) }
RefreshTimer.enabled:=true;
zoomstep:=0;
end;

procedure Tf_chart.FormActivate(Sender: TObject);
begin
// code to execute when the chart get focus.
if assigned(FUpdateFlipBtn) then FUpdateFlipBtn(sc.cfgsc.flipx,sc.cfgsc.flipy);
if assigned(fshowtopmessage) then fshowtopmessage(GetChartInfo);
if sc.cfgsc.FindOk and assigned(Fshowinfo) then Fshowinfo(sc.cfgsc.FindDesc,caption,false);
end;

procedure Tf_chart.FlipxExecute(Sender: TObject);
begin
 sc.cfgsc.FlipX:=-sc.cfgsc.FlipX;
 if assigned(FUpdateFlipBtn) then FUpdateFlipBtn(sc.cfgsc.flipx,sc.cfgsc.flipy);
 Refresh;
end;

procedure Tf_chart.FlipyExecute(Sender: TObject);
begin
 sc.cfgsc.FlipY:=-sc.cfgsc.FlipY;
 if assigned(FUpdateFlipBtn) then FUpdateFlipBtn(sc.cfgsc.flipx,sc.cfgsc.flipy);
 Refresh;
end;

procedure Tf_chart.rot_plusExecute(Sender: TObject);
begin
 sc.cfgsc.theta:=sc.cfgsc.theta+deg2rad*15;
 Refresh;
end;

procedure Tf_chart.rot_minusExecute(Sender: TObject);
begin
 sc.cfgsc.theta:=sc.cfgsc.theta-deg2rad*15;
 Refresh;
end;

procedure Tf_chart.GridEQExecute(Sender: TObject);
begin
 sc.cfgsc.ShowEqGrid := not sc.cfgsc.ShowEqGrid;
 Refresh;
end;

procedure Tf_chart.GridExecute(Sender: TObject);
begin
 sc.cfgsc.ShowGrid := not sc.cfgsc.ShowGrid;
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

procedure Tf_chart.CKeyDown(var Key: Word; Shift: TShiftState);
var ok:boolean;
begin
if Shift = [ssShift] then begin
   movefactor:=8;
   zoomfactor:=1.5;
end;
if Shift = [ssCtrl] then begin
   movefactor:=2;
   zoomfactor:=3;
end;
ok:=true;
case key of
key_upright   : MoveNorthWest.execute;
key_downright : MoveSouthWest.execute;
key_downleft  : MoveSouthEast.execute;
key_upleft    : MoveNorthEast.execute;
key_left      : MoveEast.execute;
key_up        : MoveNorth.execute;
key_right     : MoveWest.execute;
key_down      : MoveSouth.execute;
key_plus      : Zoomplus.execute;
key_minus     : Zoomminus.execute;
else ok:=false;
end;
if ok then key:=0;
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

procedure Tf_chart.CMouseWheel(Shift: TShiftState;WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
begin
handled:=true;
//lock_TrackCursor:=true;
if wheeldelta>0 then sc.Zoom(1.25)
                else sc.Zoom(0.8);
Refresh;
end;

Procedure Tf_chart.ShowIdentLabel;
var x,y : integer;
begin
if locked then exit;
if sc.cfgsc.FindOK then begin
   identlabel.Visible:=false;
   identlabel.font.name:=sc.plot.cfgplot.fontname[2];
   identlabel.font.size:=sc.plot.cfgplot.fontSize[2];
   identlabel.caption:=trim(sc.cfgsc.FindName);
   sc.GetLabPos(sc.cfgsc.FindRA,sc.cfgsc.FindDec,sc.cfgsc.FindSize/2,identlabel.Width,identlabel.Height,x,y);
   identlabel.left:=x;
   identlabel.top:=y;
   identlabel.Visible:=true;
   identlabel.bringtofront;
end
else identlabel.Visible:=false;
end;

function Tf_chart.IdentXY(X, Y: Integer):boolean;
var ra,dec,a,h,l,b,le,be,dx:double;
begin
result:=false;
if locked then exit;
sc.GetCoord(x,y,ra,dec,a,h,l,b,le,be);
ra:=rmod(ra+pi2,pi2);
dx:=2/sc.cfgsc.BxGlb; // search a 2 pixel radius
result:=sc.FindatRaDec(ra,dec,dx);
if (not result) then result:=sc.FindatRaDec(ra,dec,3*dx);  //else 6 pixel
ShowIdentLabel;
if assigned(Fshowinfo) then Fshowinfo(wordspace(sc.cfgsc.FindDesc),caption);
end;

function Tf_chart.ListXY(X, Y: Integer):boolean;
var ra,dec,a,h,l,b,le,be,dx:double;
    buf:widestring;
begin
result:=false;
if locked then exit;
sc.GetCoord(x,y,ra,dec,a,h,l,b,le,be);
ra:=rmod(ra+pi2,pi2);
dx:=12/sc.cfgsc.BxGlb; // search a 12 pixel radius
sc.Findlist(ra,dec,dx,dx,buf,false,true,true);
if assigned(FListInfo) then FListInfo(buf);
end;

procedure Tf_chart.Image1MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
if (button=mbLeft)and(not(ssShift in shift)) then begin
   if zoomstep>0 then
     ZoomBox(3,X,Y)
   else
     IdentXY(x,y);
end
else if (button=mbLeft)and(ssShift in shift)and(not lastquick) then begin
   ZoomBox(4,0,0);
   ListXY(x,y);
end
else if (button=mbMiddle)or((button=mbLeft)and(ssShift in shift)) then begin
   Refresh;
end;
end;


procedure Tf_chart.Image1MouseDown(Sender: TObject; Button: TMouseButton;

  Shift: TShiftState; X, Y: Integer);
begin
lastx:=x;
lasty:=y;
lastyzoom:=y;
case Button of
mbLeft : begin
           ZoomBox(1,X,Y);
         end;
 end;
end;

procedure Tf_chart.Image1MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
var ra,dec,a,h,l,b,le,be,c:double;
    txt:string;
begin
if locked then exit;
if shift = [ssLeft] then begin
   ZoomBox(2,X,Y);
end else if (shift=[ssMiddle])or(shift=[ssLeft,ssShift]) then begin
     TrackCursor(X,Y);
end else if shift=[ssMiddle,ssCtrl] then begin
     c:=abs(y-lastyzoom)/200;
     if c>1 then c:=1;
     if (y-lastyzoom)>0 then ZoomCursor(1+c)
                        else ZoomCursor(1-c/2);
     lastx:=x;
     lasty:=y;
     lastyzoom:=y;
end else begin
   if lastquick then Refresh; //the mouse as leave during a quick refresh
   {show the coordinates}
   sc.GetCoord(x,y,ra,dec,a,h,l,b,le,be);
   case sc.cfgsc.projpole of
   AltAz: begin
          txt:='Az:'+deptostr(rad2deg*a)+' '+deptostr(rad2deg*h)+crlf
              +'Ra:'+arptostr(rad2deg*ra/15)+' '+deptostr(rad2deg*dec);
          end;
   Equat: begin
          ra:=rmod(ra+pi2,pi2);
          txt:='Ra:'+arptostr(rad2deg*ra/15)+' '+deptostr(rad2deg*dec);
          end;
   Gal:   begin
          l:=rmod(l+pi2,pi2);
          txt:='L:'+deptostr(rad2deg*l)+' '+deptostr(rad2deg*b)+crlf
              +'Ra:'+arptostr(rad2deg*ra/15)+' '+deptostr(rad2deg*dec);
          end;
   Ecl:   begin
          le:=rmod(le+pi2,pi2);
          txt:='L:'+deptostr(rad2deg*le)+' '+deptostr(rad2deg*be)+crlf
              +'Ra:'+arptostr(rad2deg*ra/15)+' '+deptostr(rad2deg*dec);
          end;
   end;
   if assigned(Fshowcoord) then Fshowcoord(txt);
end;
end;

Procedure Tf_chart.ZoomBox(action,x,y:integer);
var
   x1,x2,y1,y2,dx,dy,xc,yc,lc : integer;
begin
case action of
1 : begin    // mouse down
   ZoomMove:=0;
   if Zoomstep=0 then begin
     // begin zoom
     XZoom1:=X;
     YZoom1:=Y;
     Zoomstep:=1;
   end else begin
     // move box or confirm click
     DXzoom:=Xzoom1-X;
     DYzoom:=Yzoom1-Y;
     Zoomstep:=4;
   end;
   end;
2 : begin   // mouse move
  if Zoomstep>=3 then  begin
     // move box
     inc(ZoomMove);
     if ZoomMove>2 then zoomstep:=3;
     Image1.picture.bitmap.Canvas.Pen.Width := 1;
     Image1.picture.bitmap.Canvas.Brush.Color:=clWhite;
     Image1.picture.bitmap.Canvas.DrawFocusRect(Rect(XZoomD1,YZoomD1,XZoomD2,YZoomD2));
     dx:=abs(XzoomD2-XzoomD1);
     dy:=abs(YzoomD2-YzoomD1);
     XZoom1:=x+DXZoom;
     YZoom1:=y+DYZoom;
     Xzoom2:=Xzoom1+dx;
     YZoom2:=Yzoom1+dy;
     x1:=round(minvalue([Xzoom1,Xzoom2]));
     x2:=round(maxvalue([Xzoom1,Xzoom2]));
     y1:=round(minvalue([Yzoom1,Yzoom2]));
     y2:=round(maxvalue([Yzoom1,Yzoom2]));
     XzoomD1:=x1;
     XzoomD2:=x2;
     YzoomD1:=y1;
     YzoomD2:=y2;
     Image1.picture.bitmap.Canvas.DrawFocusRect(Rect(XZoomD1,YZoomD1,XZoomD2,YZoomD2));
     if assigned(Fshowcoord) then Fshowcoord(demtostr(rad2deg*abs(dx/sc.cfgsc.Bxglb)));
  end else begin
     // draw zoom box
     inc(ZoomMove);
     if ZoomMove<2 then exit;
     Image1.picture.bitmap.Canvas.Pen.Width := 1;
     Image1.picture.bitmap.Canvas.Brush.Color:=clWhite;
     if Zoomstep>1 then Image1.picture.bitmap.Canvas.DrawFocusRect(Rect(XZoomD1,YZoomD1,XZoomD2,YZoomD2));
     Xzoom2:=x;
     Yzoom2:=Yzoom1+round(sgn(y-Yzoom1)*abs(Xzoom2-Xzoom1)/sc.cfgsc.windowratio);
     x1:=round(minvalue([Xzoom1,Xzoom2]));
     x2:=round(maxvalue([Xzoom1,Xzoom2]));
     y1:=round(minvalue([Yzoom1,Yzoom2]));
     y2:=round(maxvalue([Yzoom1,Yzoom2]));
     XzoomD1:=x1;
     XzoomD2:=x2;
     YzoomD1:=y1;
     YzoomD2:=y2;
     Zoomstep:=2;
     Image1.picture.bitmap.Canvas.DrawFocusRect(Rect(XZoomD1,YZoomD1,XZoomD2,YZoomD2));
     if assigned(Fshowcoord) then Fshowcoord(demtostr(rad2deg*abs((XZoomD2-XZoomD1)/sc.cfgsc.Bxglb)));
     end
    end;
3 : begin   // mouse up
    if zoomstep>=4 then begin
     // final confirmation
     Image1.picture.bitmap.Canvas.DrawFocusRect(Rect(XZoom1,YZoom1,XZoom2,YZoom2));
     Zoomstep:=0;
     //SkipMouseUp:=true;
     x1:=trunc(Minvalue([XZoom1,XZoom2])); x2:=trunc(Maxvalue([XZoom1,XZoom2]));
     y1:=trunc(Minvalue([YZoom1,YZoom2])); y2:=trunc(Maxvalue([YZoom1,YZoom2]));
     if (X>=X1) and (X<=X2) and (Y>=Y1) and (Y<=Y2)
        and (X1<>X2 ) and (Y1<>Y2) and (abs(x2-x1)>5) and (abs(y2-y1)>5) then begin
        // do the zoom
        lc := abs(X2-X1);
        xc := round(X1+lc/2);
        yc := round(Y1+(Y2-Y1)/2);
        sc.setfov(abs(lc/sc.cfgsc.BxGlb));
        sc.MovetoXY(xc,yc);
        Refresh;
     end
     else // zoom aborted, nothing to do.
    end else if zoomstep>=2 then begin
        zoomstep:=4  // box size fixed, wait confirmation or move
    end else begin
        // zoom aborted or not initialized
        // box cleanup if necessary
        if Zoomstep>1 then Image1.picture.bitmap.Canvas.DrawFocusRect(Rect(XZoom1,YZoom1,XZoom2,YZoom2));
        // zoom reset
        Zoomstep:=0;
        // call other mouseup function (identification)
        Image1MouseUp(Self,mbLeft,[],X,Y);
    end;
   end;
4 : begin   // abort
     if Zoomstep>1 then Image1.picture.bitmap.Canvas.DrawFocusRect(Rect(XZoom1,YZoom1,XZoom2,YZoom2));
     Zoomstep:=0;
   end;
end;
end;

Procedure Tf_chart.TrackCursor(X,Y : integer);
var xx,yy : integer;
begin
if LockTrackCursor then exit;
try
   LockTrackCursor:=true;
   xx:=sc.cfgsc.xcentre-(x-lastx);
   yy:=sc.cfgsc.ycentre-(y-lasty);
   lastx:=x;
   lasty:=y;
   lastyzoom:=y;
   GetADxy(xx,yy,sc.cfgsc.racentre,sc.cfgsc.decentre,sc.cfgsc);
   if sc.cfgsc.racentre>pi2 then sc.cfgsc.racentre:=sc.cfgsc.racentre-pi2;
   if sc.cfgsc.racentre<0 then sc.cfgsc.racentre:=sc.cfgsc.racentre+pi2;
   sc.cfgsc.quick:=true;
   Refresh;
   application.processmessages; // very important to empty the mouse event queue before to unlock
finally
LockTrackCursor:=false;
end;
end;

Procedure Tf_chart.ZoomCursor(yy : double);
begin
if LockTrackCursor then exit;
try
   LockTrackCursor:=true;
   yy:=sc.cfgsc.fov*abs(yy);
   if yy<FovMin then yy:=FovMin;
   if yy>FovMax then yy:=FovMax;
   sc.cfgsc.fov:=yy;
   Refresh;
   application.processmessages;
finally
LockTrackCursor:=false;
end;
end;

procedure Tf_chart.identlabelClick(Sender: TObject);
{$ifdef mswindows}
var st : TMemoryStream;
    ss : string;
{$endif}
begin
{$ifdef linux}
 f_detail.memo.text:=FormatDesc;
{$endif}
{$ifdef mswindows}
 // cannot write rich text directly to the Text property
 ss:=FormatDesc;
 st:=TMemoryStream.create;
 try
 st.write(ss[1],length(ss));
 st.Position := 0;
 f_detail.memo.lines.loadfromstream(st);
 finally
 st.free;
 end;
{$endif}
if (sender<>nil)and(not f_detail.visible) then formpos(f_detail,mouse.cursorpos.x,mouse.cursorpos.y);
f_detail.source_chart:=caption;
f_detail.show;
f_detail.setfocus;
end;

function Tf_chart.FormatDesc:string;
var desc,buf,buf2: string;
    i,p,l : integer;
    ra,dec,a,h :double;
function Bold(s:string):string;
var k:integer;
begin
  k:=pos(':',s);
  if k>0 then begin
     insert(htms_b,s,k+1);
     result:=html_b+s;
  end
  else result:=s;
end;
begin
desc:=sc.cfgsc.FindDesc;
result:=html_h;
p:=pos(tab,desc);
p:=pos2(tab,desc,p+1);
l:=pos2(tab,desc,p+1);
buf:=trim(copy(desc,p+1,l-p-1));
//objtype:=trim(buf);
buf:=LongLabelObj(buf);
result:=result+html_h2+buf+htms_h2;
buf:=copy(desc,l+1,9999);
repeat
  i:=pos(tab,buf);
  if i=0 then i:=length(buf)+1;
  buf2:=copy(buf,1,i-1);
  delete(buf,1,i);
  i:=pos(':',buf2);
  if i>0 then begin
     result:=result+bold(LongLabel(copy(buf2,1,i)));
     if copy(buf2,1,5)='desc:' then buf2:=stringreplace(buf2,';',html_br,[rfReplaceAll]);
     delete(buf2,1,i);
  end;
  result:=result+buf2+html_br;
until buf='';
result:=result+html_br+html_ffx;
result:=result+html_b+sc.cfgsc.EquinoxName+html_sp+'RA: '+htms_b+arptostr(rad2deg*sc.cfgsc.FindRA/15)+'   DE:'+deptostr(rad2deg*sc.cfgsc.FindDec)+html_br;
if (sc.cfgsc.EquinoxName<>'J2000') then begin
   ra:=sc.cfgsc.FindRA;
   dec:=sc.cfgsc.FindDec;
   precession(sc.cfgsc.JDChart,jd2000,ra,dec);
   result:=result+html_b+'J2000'+' RA: '+htms_b+arptostr(rad2deg*ra/15)+'   DE:'+deptostr(rad2deg*dec)+html_br;
end;
if (sc.cfgsc.EquinoxName<>'Date ') then begin
   ra:=sc.cfgsc.FindRA;
   dec:=sc.cfgsc.FindDec;
   precession(sc.cfgsc.JDChart,sc.cfgsc.CurJD,ra,dec);
   result:=result+html_b+'Date '+html_sp+'RA: '+htms_b+arptostr(rad2deg*ra/15)+'   DE:'+deptostr(rad2deg*dec)+html_br;
end;
if (sc.cfgsc.EquinoxName='Date ')and(sc.catalog.cfgshr.EquinoxChart<>'J2000')and(sc.cfgsc.EquinoxName<>sc.catalog.cfgshr.EquinoxChart) then begin
   ra:=sc.cfgsc.FindRA;
   dec:=sc.cfgsc.FindDec;
   precession(sc.cfgsc.JDChart,sc.catalog.cfgshr.DefaultJDchart,ra,dec);
   result:=result+html_b+sc.catalog.cfgshr.EquinoxChart+' RA: '+htms_b+arptostr(rad2deg*ra/15)+'   DE:'+deptostr(rad2deg*dec)+html_br;
end;
result:=result+htms_f+html_br;
result:=result+sc.cfgsc.ObsName+' '+YearADBC(sc.cfgsc.CurYear)+'-'+inttostr(sc.cfgsc.curmonth)+'-'+inttostr(sc.cfgsc.curday)+' '+ArToStr3(sc.cfgsc.Curtime)+'  ( UT + '+ArmtoStr(sc.cfgsc.TimeZone)+' )'+html_br;
result:=result+html_ffx;
ra:=sc.cfgsc.FindRA;
dec:=sc.cfgsc.FindDec;
precession(sc.cfgsc.JDChart,sc.cfgsc.CurJD,ra,dec);
Eq2Hz(sc.cfgsc.CurSt-ra,dec,a,h,sc.cfgsc) ;
if sc.catalog.cfgshr.AzNorth then a:=Rmod(a+pi,pi2);
result:=result+html_b+copy(sc.catalog.cfgshr.llabel[99]+blank15,1,17)+':'+htms_b+armtostr(rmod(rad2deg*sc.cfgsc.CurSt/15+24,24))+html_br;
result:=result+html_b+copy(sc.catalog.cfgshr.llabel[100]+blank15,1,17)+':'+htms_b+armtostr(rmod(rad2deg*(sc.cfgsc.CurSt-ra)/15+24,24))+html_br;
result:=result+html_b+copy(sc.catalog.cfgshr.llabel[91]+blank15,1,17)+':'+htms_b+demtostr(rad2deg*a)+html_br;
result:=result+html_b+copy(sc.catalog.cfgshr.llabel[92]+blank15,1,17)+':'+htms_b+demtostr(rad2deg*h)+html_br;
result:=result+html_br;
// here the rise/set time 
//if pos('PA:',f_main.LPanels0.caption)>0
  // then result:=result+html_b+sc.catalog.cfgshr.llabel[98]+' : '+htms_b+f_main.LPanels0.caption+html_br;
buf:=sc.cfgsc.FindNote;
repeat
  i:=pos(tab,buf);
  if i=0 then i:=length(buf)+1;
  buf2:=copy(buf,1,i-1);
  delete(buf,1,i);
  i:=pos(':',buf2);
  if i>0 then begin
     result:=result+bold(copy(buf2,1,i));
     delete(buf2,1,i);
  end;
  result:=result+buf2+html_br;
until buf='';
result:=result+htms_f+html_br+htms_h;
end;

function Tf_chart.LongLabelObj(txt:string):string;
begin
if txt='OC' then txt:=sc.catalog.cfgshr.llabel[45]
else if txt='Gb' then txt:=sc.catalog.cfgshr.llabel[46]
else if txt='Gx' then txt:=sc.catalog.cfgshr.llabel[47]
else if txt='Nb' then txt:=sc.catalog.cfgshr.llabel[48]
else if txt='Pl' then txt:=sc.catalog.cfgshr.llabel[49]
else if txt='C+N' then txt:=sc.catalog.cfgshr.llabel[50]
else if txt='*' then txt:=sc.catalog.cfgshr.llabel[51]
else if txt='**' then txt:=sc.catalog.cfgshr.llabel[52]
else if txt='***' then txt:=sc.catalog.cfgshr.llabel[53]
else if txt='D*' then txt:=sc.catalog.cfgshr.llabel[54]
else if txt='V*' then txt:=sc.catalog.cfgshr.llabel[55]
else if txt='Ast' then txt:=sc.catalog.cfgshr.llabel[56]
else if txt='Kt' then txt:=sc.catalog.cfgshr.llabel[57]
else if txt='?' then txt:=sc.catalog.cfgshr.llabel[58]
else if txt='' then txt:=sc.catalog.cfgshr.llabel[59]
else if txt='-' then txt:=sc.catalog.cfgshr.llabel[60]
else if txt='PD' then txt:=sc.catalog.cfgshr.llabel[61]
else if txt='P' then txt:=sc.catalog.cfgshr.llabel[62]
else if txt='As' then txt:=sc.catalog.cfgshr.llabel[63]
else if txt='Cm' then txt:=sc.catalog.cfgshr.llabel[64]
else if txt='C1' then txt:=sc.catalog.cfgshr.llabel[65]
else if txt='C2' then txt:=sc.catalog.cfgshr.llabel[66];
result:=txt;
end;

function Tf_chart.LongLabel(txt:string):string;
var key,value : string;
    i : integer;
const d=': ';
begin
i:=pos(':',txt);
if i>0 then begin
  key:=uppercase(trim(copy(txt,1,i-1)));
  value:=copy(txt,i+1,9999);
  if key='MB' then result:=sc.catalog.cfgshr.llabel[1]+d+value
  else if key='MV' then result:=sc.catalog.cfgshr.llabel[2]+d+value
  else if key='MR' then result:=sc.catalog.cfgshr.llabel[3]+d+value
  else if key='M' then result:=sc.catalog.cfgshr.llabel[4]+d+value
  else if key='BT' then result:=sc.catalog.cfgshr.llabel[5]+d+value
  else if key='VT' then result:=sc.catalog.cfgshr.llabel[6]+d+value
  else if key='B-V' then result:=sc.catalog.cfgshr.llabel[7]+d+value
  else if key='SP' then result:=sc.catalog.cfgshr.llabel[8]+d+value
  else if key='PM' then result:=sc.catalog.cfgshr.llabel[9]+d+value
  else if key='CLASS' then result:=sc.catalog.cfgshr.llabel[10]+d+value
  else if key='N' then result:=sc.catalog.cfgshr.llabel[11]+d+value
  else if key='T' then result:=sc.catalog.cfgshr.llabel[12]+d+value
  else if key='P' then result:=sc.catalog.cfgshr.llabel[13]+d+value
  else if key='BAND' then result:=sc.catalog.cfgshr.llabel[14]+d+value
  else if key='PLATE' then result:=sc.catalog.cfgshr.llabel[15]+d+value
  else if key='MULT' then result:=sc.catalog.cfgshr.llabel[16]+d+value
  else if key='FIELD' then result:=sc.catalog.cfgshr.llabel[17]+d+value
  else if key='Q' then result:=sc.catalog.cfgshr.llabel[18]+d+value
  else if key='S' then result:=sc.catalog.cfgshr.llabel[19]+d+value
  else if key='DIM' then result:=sc.catalog.cfgshr.llabel[20]+d+value
  else if key='CONST' then result:=sc.catalog.cfgshr.llabel[21]+d+longlabelconst(value)
  else if key='SBR' then result:=sc.catalog.cfgshr.llabel[22]+d+value
  else if key='DESC' then result:=sc.catalog.cfgshr.llabel[23]+d+value
  else if key='RV' then result:=sc.catalog.cfgshr.llabel[24]+d+value
  else if key='SURFACE' then result:=sc.catalog.cfgshr.llabel[25]+d+value
  else if key='COLOR' then result:=sc.catalog.cfgshr.llabel[26]+d+value
  else if key='BRIGHT' then result:=sc.catalog.cfgshr.llabel[27]+d+value
  else if key='TR' then result:=sc.catalog.cfgshr.llabel[28]+d+value
  else if key='DIST' then result:=sc.catalog.cfgshr.llabel[29]+d+value
  else if key='M*' then result:=sc.catalog.cfgshr.llabel[30]+d+value
  else if key='N*' then result:=sc.catalog.cfgshr.llabel[31]+d+value
  else if key='AGE' then result:=sc.catalog.cfgshr.llabel[32]+d+value
  else if key='RT' then result:=sc.catalog.cfgshr.llabel[33]+d+value
  else if key='RH' then result:=sc.catalog.cfgshr.llabel[34]+d+value
  else if key='RC' then result:=sc.catalog.cfgshr.llabel[35]+d+value
  else if key='MHB' then result:=sc.catalog.cfgshr.llabel[36]+d+value
  else if key='C*B' then result:=sc.catalog.cfgshr.llabel[37]+d+value
  else if key='C*V' then result:=sc.catalog.cfgshr.llabel[38]+d+value
  else if key='DIAM' then result:=sc.catalog.cfgshr.llabel[39]+d+value
  else if key='ILLUM' then result:=sc.catalog.cfgshr.llabel[40]+d+value
  else if key='PHASE' then result:=sc.catalog.cfgshr.llabel[41]+d+value
  else if key='QL' then result:=sc.catalog.cfgshr.llabel[42]+d+value
  else if key='EL' then result:=sc.catalog.cfgshr.llabel[43]+d+value
  else if key='RSOL' then result:=sc.catalog.cfgshr.llabel[44]+d+value
  else if key='D1' then result:=sc.catalog.cfgshr.llabel[23]+' 1'+d+value
  else if key='D2' then result:=sc.catalog.cfgshr.llabel[23]+' 2'+d+value
  else if key='D3' then result:=sc.catalog.cfgshr.llabel[23]+' 3'+d+value
  else if key='FL' then result:=sc.catalog.cfgshr.llabel[67]+d+value
  else if key='BA' then result:=sc.catalog.cfgshr.llabel[68]+d+LongLabelGreek(value)
  else if key='PX' then result:=sc.catalog.cfgshr.llabel[69]+d+value
  else if key='PA' then result:=sc.catalog.cfgshr.llabel[70]+d+value
  else if key='PMRA' then result:=sc.catalog.cfgshr.llabel[71]+d+value
  else if key='PMDE' then result:=sc.catalog.cfgshr.llabel[72]+d+value
  else if key='MMAX' then result:=sc.catalog.cfgshr.llabel[73]+d+value
  else if key='MMIN' then result:=sc.catalog.cfgshr.llabel[74]+d+value
  else if key='MEPOCH' then result:=sc.catalog.cfgshr.llabel[75]+d+value
  else if key='RISE' then result:=sc.catalog.cfgshr.llabel[76]+d+value
  else if key='M1' then result:=sc.catalog.cfgshr.llabel[77]+d+value
  else if key='M2' then result:=sc.catalog.cfgshr.llabel[78]+d+value
  else if key='SEP' then result:=sc.catalog.cfgshr.llabel[79]+d+value
  else if key='DATE' then result:=sc.catalog.cfgshr.llabel[80]+d+value
  else if sc.catalog.cfgshr.llabel[85]='?' then result:=txt
  else if key='POLEINCL' then result:=sc.catalog.cfgshr.llabel[85]+d+value
  else if key='SUNINCL' then result:=sc.catalog.cfgshr.llabel[86]+d+value
  else if key='CM' then result:=sc.catalog.cfgshr.llabel[87]+d+value
  else if key='CMI' then result:=sc.catalog.cfgshr.llabel[87]+' I'+d+value
  else if key='CMII' then result:=sc.catalog.cfgshr.llabel[87]+' II'+d+value
  else if key='CMIII' then result:=sc.catalog.cfgshr.llabel[87]+' III'+d+value
  else if key='GRSTR' then result:=sc.catalog.cfgshr.llabel[88]+d+value
  else if key='LLAT' then result:=sc.catalog.cfgshr.llabel[89]+d+value
  else if key='LLON' then result:=sc.catalog.cfgshr.llabel[90]+d+value
  else result:=txt;
end
else result:=txt;
end;

Function Tf_chart.LongLabelConst(txt : string) : string;
var i : integer;
begin
txt:=uppercase(trim(txt));
for i:=1 to sc.catalog.cfgshr.ConstelNum do begin
  if txt=UpperCase(sc.catalog.cfgshr.ConstelName[i,1]) then begin
     txt:=sc.catalog.cfgshr.ConstelName[i,2];
     break;
   end;
end;
result:=txt;
end;

Function Tf_chart.LongLabelGreek(txt : string) : string;
var i : integer;
begin
txt:=uppercase(trim(txt));
for i:=1 to 24 do begin
  if txt=UpperCase(trim(greek[2,i])) then begin
     txt:=greek[1,i];
     break;
   end;
end;
result:=txt;
end;

procedure Tf_chart.switchstarExecute(Sender: TObject);
begin
sc.plot.cfgplot.starplot:=abs(sc.plot.cfgplot.starplot-1);
sc.plot.cfgplot.nebplot:=sc.plot.cfgplot.starplot;
sc.cfgsc.FillMilkyWay:=(sc.plot.cfgplot.nebplot=1);
Refresh;
end;

procedure Tf_chart.switchbackgroundExecute(Sender: TObject);

begin
sc.plot.cfgplot.autoskycolor:=not sc.plot.cfgplot.autoskycolor;
Refresh;
end;


function Tf_Chart.cmd_SetCursorPosition(x,y:integer) :string;

begin

if (x>=0)and(x<=image1.width)and(y>=0)and(y<=image1.height) then begin

  xcursor:=x;

  ycursor:=y;

  result:=msgOK;

end else result:=msgfailed+' Bad position.';

end;


function Tf_Chart.cmd_GetCursorPosition :string;

begin

result:=msgOK+blank+inttostr(xcursor)+blank+inttostr(ycursor);

end;


function Tf_Chart.cmd_SetGridEQ(onoff:string):string;

begin

 sc.cfgsc.ShowEqGrid := (uppercase(onoff)='ON');

 result:=msgOK;

end;

function Tf_Chart.cmd_GetGridEQ:string;
begin

 if sc.cfgsc.ShowEqGrid then result:=msgOK+' ON'

                        else result:=msgOK+' OFF'

end;

function Tf_Chart.cmd_SetGrid(onoff:string):string;
begin

 sc.cfgsc.ShowGrid := (uppercase(onoff)='ON');

 result:=msgOK;

end;


function Tf_Chart.cmd_GetGrid:string;

begin

 if sc.cfgsc.ShowGrid then result:=msgOK+' ON'

                      else result:=msgOK+' OFF'

end;


function Tf_chart.cmd_SetStarMode(i:integer):string;

begin
if (i>=0)and(i<=1) then begin
  sc.plot.cfgplot.starplot:=i;
  result:=msgOK;
end else result:=msgFailed+' Bad star mode.';
end;

function Tf_chart.cmd_GetStarMode:string;
begin
  result:=msgOK+blank+inttostr(sc.plot.cfgplot.starplot);
end;

function Tf_chart.cmd_SetNebMode(i:integer):string;
begin
if (i>=0)and(i<=1) then begin
  sc.plot.cfgplot.nebplot:=i;
  result:=msgOK;
end else result:=msgFailed+' Bad nebula mode.';
end;

function Tf_chart.cmd_GetNebMode:string;
begin
  result:=msgOK+blank+inttostr(sc.plot.cfgplot.nebplot);
end;

function Tf_chart.cmd_SetSkyMode(onoff:string):string;
begin
sc.plot.cfgplot.autoskycolor:=(uppercase(onoff)='ON');
result:=msgOK;
end;

function Tf_chart.cmd_GetSkyMode:string;
begin
 if sc.plot.cfgplot.autoskycolor then result:=msgOK+' ON'
                                 else result:=msgOK+' OFF'

end;

function Tf_chart.cmd_SetProjection(proj:string):string;
begin
result:=msgOK;
proj:=uppercase(proj);
if proj='ALTAZ' then sc.cfgsc.projpole:=altaz
  else if proj='EQUAT' then sc.cfgsc.projpole:=equat
  else if proj='GALACTIC' then sc.cfgsc.projpole:=gal
  else if proj='ECLIPTIC' then sc.cfgsc.projpole:=ecl
  else result:=msgFailed+' Bad projection name.';
sc.cfgsc.FindOk:=false;
end;

function Tf_chart.cmd_GetProjection:string;
begin
case sc.cfgsc.projpole of
equat :  result:='EQUAT';
altaz :  result:='ALTAZ';
gal   :  result:='GALACTIC';
ecl   :  result:='ECLIPTIC';
end;
result:=msgOK+blank+result;
end;

function Tf_chart.cmd_SetFov(fov:string):string;
var f : double;
    p : integer;
begin
result:=msgFailed+' Bad format!';
try
fov:=trim(fov);
p:=pos('d',fov);
if p>0 then begin
  f:=strtofloat(copy(fov,1,p-1));
  fov:=copy(fov,p+1,999);
  p:=pos('m',fov);
  f:=f+strtofloat(copy(fov,1,p-1))/60;
  fov:=copy(fov,p+1,999);
  p:=pos('s',fov);
  f:=f+strtofloat(copy(fov,1,p-1))/3600;
end else begin
  f:=strtofloat(fov);
end;
sc.setfov(deg2rad*f);
result:=msgOK;
except
exit;
end;
end;

function Tf_chart.cmd_GetFov(format:string):string;
begin
if format='F' then begin
 result:=msgOK+blank+formatfloat(f5,rad2deg*sc.cfgsc.fov);
end else begin
 result:=msgOK+blank+detostr3(rad2deg*sc.cfgsc.fov);
end
end;

function Tf_chart.cmd_SetRa(param1:string):string;
var buf : string;
    p : integer;
    ar : double;
begin
result:=msgFailed+' Bad coordinates format!';
try
p:=pos('RA:',param1);
if p>0 then begin
 buf:=copy(param1,p+3,999);
 p:=pos('h',buf);
 ar:=strtofloat(copy(buf,1,p-1));
 buf:=copy(buf,p+1,999);
 p:=pos('m',buf);
 ar:=ar+strtofloat(copy(buf,1,p-1))/60;
 buf:=copy(buf,p+1,999);
 p:=pos('s',buf);
 ar:=ar+strtofloat(copy(buf,1,p-1))/3600;
end else begin
 ar:=strtofloat(param1);
end;
sc.cfgsc.racentre:=rmod(deg2rad*ar*15+pi2,pi2);
result:=msgOK;
except
exit;
end;
end;

function Tf_chart.cmd_SetDec(param1:string):string;
var buf : string;
    p : integer;
    s,de : double;
begin
result:=msgFailed+' Bad coordinates format!';
try
p:=pos('DEC:',param1);
if p>0 then begin
 buf:=copy(param1,p+4,999);
 p:=pos('d',buf);
 de:=strtofloat(copy(buf,1,p-1));
 s:=sgn(de);
 buf:=copy(buf,p+1,999);
 p:=pos('m',buf);
 de:=de+s*strtofloat(copy(buf,1,p-1))/60;
 buf:=copy(buf,p+1,999);
 p:=pos('s',buf);
 de:=de+s*strtofloat(copy(buf,1,p-1))/3600;
end else begin
 de:=strtofloat(param1);
end;
sc.cfgsc.decentre:=deg2rad*de;
result:=msgOK;
except
exit;
end;
end;

function Tf_chart.cmd_GetRA(format:string):string;
begin
if format='F' then begin
 result:=msgOK+blank+formatfloat(f5,rad2deg*sc.cfgsc.racentre/15);
end else begin
 result:=msgOK+blank+artostr3(rad2deg*sc.cfgsc.racentre/15);
end
end;

function Tf_chart.cmd_GetDEC(format:string):string;
begin
if format='F' then begin
 result:=msgOK+blank+formatfloat(f5,rad2deg*sc.cfgsc.decentre);
end else begin
 result:=msgOK+blank+detostr3(rad2deg*sc.cfgsc.decentre);
end
end;

function Tf_chart.cmd_SetDate(dt:string):string;
var p,y,m,d,h,n,s : integer;
begin
result:=msgFailed+' Bad date format!';
try
dt:=trim(dt);
p:=pos('-',dt);
if p=0 then exit;
y:=strtoint(trim(copy(dt,1,p-1)));
dt:=copy(dt,p+1,999);
p:=pos('-',dt);
if p=0 then exit;
m:=strtoint(trim(copy(dt,1,p-1)));
dt:=copy(dt,p+1,999);
p:=pos('T',dt);
if p=0 then exit;
d:=strtoint(trim(copy(dt,1,p-1)));
dt:=copy(dt,p+1,999);
p:=pos(':',dt);
if p=0 then exit;
h:=strtoint(trim(copy(dt,1,p-1)));
dt:=copy(dt,p+1,999);
p:=pos(':',dt);
if p=0 then exit;
n:=strtoint(trim(copy(dt,1,p-1)));
dt:=copy(dt,p+1,999);
s:=strtoint(trim(dt));
sc.cfgsc.UseSystemTime:=false;
sc.cfgsc.CurYear:=y;
sc.cfgsc.CurMonth:=m;
sc.cfgsc.CurDay:=d;
sc.cfgsc.CurTime:=h+n/60+s/3600;
result:=msgOK;
except
exit;
end;
end;

function Tf_chart.cmd_GetDate:string;
begin
result:=msgOK+blank+YearADBC(sc.cfgsc.CurYear)+'-'+inttostr(sc.cfgsc.curmonth)+'-'+inttostr(sc.cfgsc.curday)+'T'+ArToStr3(sc.cfgsc.Curtime);
end;

function Tf_chart.cmd_SetObs(obs:string):string;
var n,buf : string;
    p : integer;
    s,la,lo,al : double;
begin
result:=msgFailed+' Bad observatory format!';
try
p:=pos('LAT:',obs);          
if p=0 then exit;
buf:=copy(obs,p+4,999);
p:=pos('d',buf);
la:=strtofloat(copy(buf,1,p-1));
s:=sgn(la);
buf:=copy(buf,p+1,999);
p:=pos('m',buf);
la:=la+s*strtofloat(copy(buf,1,p-1))/60;
buf:=copy(buf,p+1,999);
p:=pos('s',buf);
la:=la+s*strtofloat(copy(buf,1,p-1))/3600;
p:=pos('LON:',obs);
if p=0 then exit;
buf:=copy(obs,p+4,999);
p:=pos('d',buf);
lo:=strtofloat(copy(buf,1,p-1));
s:=sgn(lo);
buf:=copy(buf,p+1,999);
p:=pos('m',buf);
lo:=lo+s*strtofloat(copy(buf,1,p-1))/60;
buf:=copy(buf,p+1,999);
p:=pos('s',buf);
lo:=lo+s*strtofloat(copy(buf,1,p-1))/3600;
p:=pos('ALT:',obs);
if p=0 then exit;
buf:=copy(obs,p+4,999);
p:=pos('m',buf);
al:=strtofloat(copy(buf,1,p-1));
p:=pos('OBS:',obs);
if p=0 then n:='obs?'
       else n:=trim(copy(obs,p+4,999));
sc.cfgsc.ObsLatitude := la;
sc.cfgsc.ObsLongitude := lo;
sc.cfgsc.ObsAltitude := al;
p:=pos('/',n);
if p>0 then begin
   sc.cfgsc.Obscountry:=trim(copy(n,1,p-1));
   delete(n,1,p);
end else sc.cfgsc.Obscountry:='';
sc.cfgsc.ObsName := n;
result:=msgOK;
except
exit;
end;
end;

function Tf_chart.cmd_GetObs:string;
begin
result:=msgOK+blank+'LAT:'+detostr3(sc.cfgsc.ObsLatitude)+'LON:'+detostr3(sc.cfgsc.ObsLongitude)+'ALT:'+formatfloat(f0,sc.cfgsc.ObsAltitude)+'mOBS:'+sc.cfgsc.Obscountry+'/'+sc.cfgsc.ObsName;
end;

function Tf_chart.cmd_SetTZ(tz:string):string;
begin
try
  sc.cfgsc.ObsTZ:=strtofloat(tz);
  result:=msgOK;
except
  result:=msgFailed;
end
end;

function Tf_chart.cmd_GetTZ:string;
begin
 result:=msgOK+blank+formatfloat(f1,sc.cfgsc.ObsTZ);
end;

function Tf_chart.cmd_IdentCursor:string;
begin
if identxy(xcursor,ycursor) then result:=msgOK
   else result:=msgFailed+' No object found!';
end;

function Tf_chart.cmd_SaveImage(format,fn,quality:string):string;
var i : integer;
begin
i:=strtointdef(quality,75);
if SaveChartImage(format,fn,i) then result:=msgOK
   else result:=msgFailed;
end;

function Tf_chart.ExecuteCmd(arg:Tstringlist):string;
var i,n : integer;
    cmd : string;
begin
cmd:=trim(uppercase(arg[0]));
n:=-1;
for i:=1 to numcmd do
   if cmd=cmdlist[i,1] then begin
      n:=strtointdef(cmdlist[i,2],-1);
      break;
   end;
result:=msgOK;
case n of
 1 : sc.zoom(zoomfactor);
 2 : sc.zoom(1/zoomfactor);
 3 : sc.MoveChart(0,1,movefactor);
 4 : sc.MoveChart(0,-1,movefactor);
 5 : sc.MoveChart(1,0,movefactor);
 6 : sc.MoveChart(-1,0,movefactor);
 7 : sc.MoveChart(1,1,movefactor);
 8 : sc.MoveChart(1,-1,movefactor);
 9 : sc.MoveChart(-1,1,movefactor);
 10 : sc.MoveChart(-1,-1,movefactor);
 11 : begin sc.cfgsc.FlipX:=-sc.cfgsc.FlipX; if assigned(FUpdateFlipBtn) then FUpdateFlipBtn(sc.cfgsc.flipx,sc.cfgsc.flipy);end;
 12 : begin sc.cfgsc.FlipY:=-sc.cfgsc.FlipY; if assigned(FUpdateFlipBtn) then FUpdateFlipBtn(sc.cfgsc.flipx,sc.cfgsc.flipy);end;
 13 : result:=cmd_SetCursorPosition(strtointdef(arg[1],-1),strtointdef(arg[2],-1));
 14 : sc.MovetoXY(xcursor,ycursor);
 15 : begin sc.zoom(zoomfactor);sc.MovetoXY(xcursor,ycursor);end;
 16 : begin sc.zoom(1/zoomfactor);sc.MovetoXY(xcursor,ycursor);end;
 17 : sc.cfgsc.theta:=sc.cfgsc.theta+deg2rad*15;
 18 : sc.cfgsc.theta:=sc.cfgsc.theta-deg2rad*15;
 19 : result:=cmd_SetGridEQ(arg[1]);
 20 : result:=cmd_SetGrid(arg[1]);
 21 : result:=cmd_SetStarMode(strtointdef(arg[1],-1));
 22 : result:=cmd_SetNebMode(strtointdef(arg[1],-1));
 23 : result:=cmd_SetSkyMode(arg[1]);
 24 : UndoExecute(self);
 25 : RedoExecute(self);
 26 : result:=cmd_SetProjection(arg[1]);
 27 : result:=cmd_SetFov(arg[1]);
 28 : result:=cmd_SetRa(arg[1]);
 29 : result:=cmd_SetDec(arg[1]);
 30 : result:=cmd_SetObs(arg[1]);
 31 : result:=cmd_IdentCursor;
 32 : result:=cmd_SaveImage(arg[1],arg[2],arg[3]);
 33 : SetAz(deg2rad*180,false);
 34 : SetAz(0,false);
 35 : SetAz(deg2rad*270,false);
 36 : SetAz(deg2rad*90,false);
 37 : SetZenit(0,false);
 38 : SetZenit(deg2rad*200,false);
 39 : Refresh;
 40 : result:=cmd_GetCursorPosition;
 41 : result:=cmd_GetGridEQ;
 42 : result:=cmd_GetGrid;
 43 : result:=cmd_GetStarMode;
 44 : result:=cmd_GetNebMode;
 45 : result:=cmd_GetSkyMode;
 46 : result:=cmd_GetProjection;
 47 : result:=cmd_GetFov(arg[1]);
 48 : result:=cmd_GetRA(arg[1]);
 49 : result:=cmd_GetDEC(arg[1]);
 50 : result:=cmd_GetDate;
 51 : result:=cmd_GetObs;
 52 : result:=cmd_SetDate(arg[1]);
 53 : result:=cmd_SetTZ(arg[1]);
 54 : result:=cmd_GetTZ;
else result:=msgFailed+' Bad command name';
end;
end;


procedure Tf_chart.FormKeyPress(Sender: TObject; var Key: Char);

begin
case key of
'1' : SetField(deg2rad*sc.catalog.cfgshr.FieldNum[0]);
'2' : SetField(deg2rad*sc.catalog.cfgshr.FieldNum[1]);
'3' : SetField(deg2rad*sc.catalog.cfgshr.FieldNum[2]);
'4' : SetField(deg2rad*sc.catalog.cfgshr.FieldNum[3]);
'5' : SetField(deg2rad*sc.catalog.cfgshr.FieldNum[4]);
'6' : SetField(deg2rad*sc.catalog.cfgshr.FieldNum[5]);
'7' : SetField(deg2rad*sc.catalog.cfgshr.FieldNum[6]);
'8' : SetField(deg2rad*sc.catalog.cfgshr.FieldNum[7]);
'9' : SetField(deg2rad*sc.catalog.cfgshr.FieldNum[8]);
'0' : SetField(deg2rad*sc.catalog.cfgshr.FieldNum[9]);
'a' : SetZenit(deg2rad*200);
'e' : SetAz(deg2rad*270);
//'f' : SpeedButton17Click(Sender);  // find
//'h' : SpeedButton24Click(Sender);  // horizon
//'l' : ToolbarButtonLabelClick(Sender);  // label
//'m' : Coordone1Click(Sender);     // entree des coordonnees
'n' : SetAz(deg2rad*180);
//'p' : popupmenu2.popup(mouse.cursorpos.x,mouse.cursorpos.y);
//'q' : SwitchProj;
//'r' : SetRot(15);
's' : SetAz(0);
//'t' : Heure1Click(Sender);         // date time
'w' : SetAz(deg2rad*90);
'z' : SetZenit(0);
//'P' : SetRecording;
//'R' : SetRot(-15);
//'+' : SpeedButton2Click(Sender);
//'-' : SpeedButton3Click(Sender);
//' ' : HideMenu(not menu_on);
end;
end;

procedure Tf_chart.SetField(field : double);
begin
sc.setfov(field);
Refresh;
end;

procedure Tf_chart.SetZenit(field : double; redraw:boolean=true);
var a,d,az : double;
begin
az:=sc.cfgsc.acentre;
if field>0 then begin
  if sc.cfgsc.windowratio>1  then sc.cfgsc.fov:=field*sc.cfgsc.windowratio
     else sc.cfgsc.fov:=field;
end;
sc.cfgsc.ProjPole:=Altaz;
sc.cfgsc.Acentre:=0;
sc.cfgsc.hcentre:=pid2;
Hz2Eq(sc.cfgsc.acentre,sc.cfgsc.hcentre,a,d,sc.cfgsc);
sc.cfgsc.racentre:=sc.cfgsc.CurST-a;
sc.cfgsc.decentre:=d;
if field>0 then begin
   setaz(az,redraw);
   end
else if redraw then Refresh;
end;

procedure Tf_chart.SetAz(Az : double; redraw:boolean=true);
var a,d : double;
begin
a := minvalue([sc.cfgsc.Fov,sc.cfgsc.Fov/sc.cfgsc.windowratio]);
if sc.cfgsc.Fov<pi then Hz2Eq(Az,a/2.3,a,d,sc.cfgsc)
                   else Hz2Eq(Az,sc.cfgsc.hcentre,a,d,sc.cfgsc);
sc.cfgsc.racentre:=sc.cfgsc.CurST-a;
sc.cfgsc.decentre:=d;
sc.cfgsc.ProjPole:=Altaz;
if redraw then Refresh;
end;

procedure Tf_chart.SetDate(y,m,d,h,n,s:integer);
var jj,hh: double;
begin
hh:=h+n/60+s/3600;
jj:=jd(y,m,d,hh);
djd(jj,y,m,d,hh);
sc.cfgsc.UseSystemTime:=false;
sc.cfgsc.CurYear:=y;
sc.cfgsc.CurMonth:=m;
sc.cfgsc.CurDay:=d;
sc.cfgsc.CurTime:=hh;
sc.cfgsc.TrackOn:=true;
sc.cfgsc.TrackType:=4;
Refresh;
end;

procedure Tf_chart.SetJD(njd:double);
var y,m,d : integer;
    h : double;
begin
djd(njd,y,m,d,h);
sc.cfgsc.UseSystemTime:=false;
sc.cfgsc.CurYear:=y;
sc.cfgsc.CurMonth:=m;
sc.cfgsc.CurDay:=d;
sc.cfgsc.CurTime:=h-sc.cfgsc.DT_UT;
sc.cfgsc.TrackOn:=true;
sc.cfgsc.TrackType:=4;
Refresh;
end;

procedure Tf_chart.Resetalllabels1Click(Sender: TObject);
begin
sc.cfgsc.nummodlabels:=0;
sc.DrawLabels;
end;

procedure Tf_chart.IdentDetail(X, Y: Integer);
var ra,dec,a,h,l,b,le,be,dx:double;
begin
if locked then exit;
sc.GetCoord(x,y,ra,dec,a,h,l,b,le,be);
ra:=rmod(ra+pi2,pi2);
dx:=1/sc.cfgsc.BxGlb; // search a 1 pixel radius
sc.FindatRaDec(ra,dec,dx);
if assigned(Fshowinfo) then Fshowinfo(wordspace(sc.cfgsc.FindDesc),caption);
identlabelClick(Self);
end;
