unit pu_planetinfo;

{$mode objfpc}{$H+}

interface

uses u_constant, u_translation, Math, u_util, cu_planet, u_projection, process,
  BGRABitmap, BGRABitmapTypes, Classes, SysUtils, FileUtil, Forms, Controls,
  UScaleDPI, Types, Graphics, Dialogs, ComCtrls, ExtCtrls, Buttons, StdCtrls;

type
  TChartDrawingControl = class(TCustomControl)
  public
    procedure Paint; override;
    property onMouseDown;
    property onMouseMove;
    property onMouseUp;
  end;


type

  { Tf_planetinfo }

  Tf_planetinfo = class(TForm)
    CheckBox1: TCheckBox;
    HeaderControl1: THeaderControl;
    Next2: TStaticText;
    Next3: TStaticText;
    Next4: TStaticText;
    Next5: TStaticText;
    Next6: TStaticText;
    Next7: TStaticText;
    Next8: TStaticText;
    Next1: TStaticText;
    PageControl1: TPageControl;
    Panel1: TPanel;
    PanelTop: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    Panel5: TPanel;
    Panel6: TPanel;
    Panel7: TPanel;
    Panel8: TPanel;
    Panel9: TPanel;
    Prev2: TStaticText;
    Prev3: TStaticText;
    Prev4: TStaticText;
    Prev5: TStaticText;
    Prev6: TStaticText;
    Prev7: TStaticText;
    Prev8: TStaticText;
    Prev9: TStaticText;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    TabSheet4: TTabSheet;
    TabSheet5: TTabSheet;
    TabSheet6: TTabSheet;
    TabSheet7: TTabSheet;
    TabSheet8: TTabSheet;
    TabSheet9: TTabSheet;
    procedure CheckBox1Change(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure HeaderControl1SectionClick(HeaderControl: TCustomHeaderControl;
      Section: THeaderSection);
    procedure SetPage(Sender: TObject);
  private
    { private declarations }
    Image1,Image2,Image3,Image4,Image5,Image6,Image7,Image8,Image9 : TChartDrawingControl;
    Fplanet : Tplanet;
    xmin,xmax,ymin,ymax: integer;
    Initialized, ActiveNoon: boolean;
    ActiveDate, ActiveSizeX,ActiveSizeY: integer;
    TextZoom: single;
    procedure ImgPaint(Sender: TObject);
  public
    { public declarations }
    config: Tconf_skychart;
    plbmp: TBGRABitmap;
    CenterAtNoon, ShowCurrentObject: boolean;
    ActivePage: integer;
    Procedure SetLang;
    Procedure RefreshInfo;
    procedure PlotLine(bmp:TBGRABitmap; lbl:string; y:integer; des,h1,h2,ht:double);
    Procedure PlotTwilight(bmp:TBGRABitmap);
    Procedure PlotPlanet(bmp:TBGRABitmap);
    Procedure PlotSelection(bmp:TBGRABitmap);
    Procedure PlotFrame(bmp:TBGRABitmap);
    Procedure PlotPlanetImage(bmp:TBGRABitmap; ipla:integer);
    Procedure PlotOrbit1(bmp:TBGRABitmap);
    Procedure PlotOrbit2(bmp:TBGRABitmap);
    Procedure PlotHeader(bmp:TBGRABitmap; title:string; showobs,showtime: boolean);
    property planet: Tplanet read Fplanet write Fplanet;
  end;

var
  f_planetinfo: Tf_planetinfo;

const
  marginleft=90;
  marginright=90;
  margintop=100;
  marginbottom=40;

implementation

{$R *.lfm}

procedure TChartDrawingControl.Paint;
begin
  inherited Paint;
end;

{ Tf_planetinfo }

procedure Tf_planetinfo.SetLang;
begin
caption:=rsSolarSystemI;
Next1.caption:=rsNext;
Next2.caption:=rsNext;
Next3.caption:=rsNext;
Next4.caption:=rsNext;
Next5.caption:=rsNext;
Next6.caption:=rsNext;
Next7.caption:=rsNext;
Next8.caption:=rsNext;
Prev2.caption:=rsPrev;
Prev3.caption:=rsPrev;
Prev4.caption:=rsPrev;
Prev5.caption:=rsPrev;
Prev6.caption:=rsPrev;
Prev7.caption:=rsPrev;
Prev8.caption:=rsPrev;
Prev9.caption:=rsPrev;
CheckBox1.Caption:=rsStartGraphAt;
HeaderControl1.Sections[0].Text:=rsPlanetVisibi;
HeaderControl1.Sections[1].Text:=pla[11];
HeaderControl1.Sections[2].Text:=pla[1];
HeaderControl1.Sections[3].Text:=pla[2];
HeaderControl1.Sections[4].Text:=pla[4];
HeaderControl1.Sections[5].Text:=pla[5];
HeaderControl1.Sections[6].Text:=pla[6];
HeaderControl1.Sections[7].Text:=rsInnerSolarSy;
HeaderControl1.Sections[8].Text:=rsOuterSolarSy;
HeaderControl1.Invalidate;
FormResize(self);
end;

procedure Tf_planetinfo.SetPage(Sender: TObject);
var p: integer;
begin
  p:=TStaticText(sender).tag;
  PageControl1.ActivePageIndex:=p;
  RefreshInfo;
end;

procedure Tf_planetinfo.FormCreate(Sender: TObject);
procedure InitImg(var img:TChartDrawingControl;par:TPanel);
begin
Img:= TChartDrawingControl.Create(Self);
Img.Parent := par;
Img.Align:=alClient;
Img.DoubleBuffered := true;
Img.OnPaint:=@ImgPaint;
end;
begin
  ScaleDPI(Self,96);
  Initialized:=false;
  config:=Tconf_skychart.Create;
  plbmp:=TBGRABitmap.Create;
  CenterAtNoon:=true;
  ShowCurrentObject:=true;
  setlang;
  ActivePage:=-1;
  ActiveDate:=-1;
  ActiveSizeX:=-1;
  ActiveSizeY:=-1;
  ActiveNoon:=false;
  TextZoom:=1;
  InitImg(Image1,Panel1);
  InitImg(Image2,Panel2);
  InitImg(Image3,Panel3);
  InitImg(Image4,Panel4);
  InitImg(Image5,Panel5);
  InitImg(Image6,Panel6);
  InitImg(Image7,Panel7);
  InitImg(Image8,Panel8);
  InitImg(Image9,Panel9);
end;

procedure Tf_planetinfo.CheckBox1Change(Sender: TObject);
begin
  CenterAtNoon := not CheckBox1.Checked;
  RefreshInfo;
end;

procedure Tf_planetinfo.FormDestroy(Sender: TObject);
begin
  plbmp.Free;
  config.Free;
  Image1.Free;
  Image2.Free;
  Image3.Free;
  Image4.Free;
  Image5.Free;
  Image6.Free;
  Image7.Free;
  Image8.Free;
  Image9.Free;
end;

procedure Tf_planetinfo.ImgPaint(Sender: TObject);
begin
  case PageControl1.ActivePageIndex of
     0: plbmp.Draw(Image1.Canvas, 0, 0, false);
     1: plbmp.Draw(Image2.Canvas, 0, 0, false);
     2: plbmp.Draw(Image3.Canvas, 0, 0, false);
     3: plbmp.Draw(Image4.Canvas, 0, 0, false);
     4: plbmp.Draw(Image5.Canvas, 0, 0, false);
     5: plbmp.Draw(Image6.Canvas, 0, 0, false);
     6: plbmp.Draw(Image7.Canvas, 0, 0, false);
     7: plbmp.Draw(Image8.Canvas, 0, 0, false);
     8: plbmp.Draw(Image9.Canvas, 0, 0, false);
  end;
end;

procedure Tf_planetinfo.FormResize(Sender: TObject);
var i:integer;
    ts: tsize;
begin
for i:=0 to HeaderControl1.Sections.Count-1 do begin
  ts:=canvas.TextExtent(HeaderControl1.Sections[i].Text);
  HeaderControl1.Sections[i].MinWidth:=ts.cx+8;
end;
plbmp.SetSize(PageControl1.ClientWidth,PageControl1.ClientHeight);
if Initialized then RefreshInfo;
end;

procedure Tf_planetinfo.FormShow(Sender: TObject);
begin
    ActivePage:=-1;
end;

procedure Tf_planetinfo.HeaderControl1SectionClick(
  HeaderControl: TCustomHeaderControl; Section: THeaderSection);
begin
  PageControl1.ActivePageIndex:=Section.OriginalIndex;
  RefreshInfo;
end;

procedure Tf_planetinfo.RefreshInfo;
var yy: integer;
begin
if (ActivePage=PageControl1.ActivePageIndex) and
   (ActiveDate=trunc(config.CurJDTT)) and
   (ActiveNoon=CenterAtNoon) and
   (ActiveSizeX=PageControl1.ClientWidth) and
   (ActiveSizeY=PageControl1.ClientHeight) and
   (ActiveSizeX=plbmp.Width) and
   (ActiveSizeY=plbmp.Height) then begin
     BringToFront;
     Exit;
   end;

try
Initialized:=false;
plbmp.SetSize(PageControl1.ClientWidth,PageControl1.ClientHeight);
plbmp.Fill(ColorToBGRA(clBlack));
TextZoom:=TabSheet1.ClientWidth/800;
xmin:=round(marginleft*TextZoom);
xmax:=plbmp.Width-round(marginright*TextZoom);
if  PageControl1.ClientWidth>PageControl1.ClientHeight then begin
  ymin:=margintop;
  ymax:=plbmp.Height-marginbottom;
end else begin
  yy:=(PageControl1.ClientHeight-PageControl1.ClientWidth) div 2;
  ymin:=margintop+yy;
  ymax:=plbmp.Height-marginbottom-yy;
end;
ActivePage:=PageControl1.ActivePageIndex;
ActiveDate:=trunc(config.CurJDTT);
ActiveNoon:=CenterAtNoon;
ActiveSizeX:=PageControl1.ClientWidth;
ActiveSizeY:=PageControl1.ClientHeight;
case PageControl1.ActivePageIndex of
   0: begin
      PlotHeader(plbmp, rsPlanetVisibi, true, false);
      PlotTwilight(plbmp);
      PlotPlanet(plbmp);
      PlotSelection(plbmp);
      PlotFrame(plbmp);
   end;
   1: begin
      PlotHeader(plbmp,pla[11], false, true);
      PlotPlanetImage(plbmp,11);
      end;
   2: begin
      PlotHeader(plbmp,pla[1], false, true);
      PlotPlanetImage(plbmp,1);
      end;
   3: begin
      PlotHeader(plbmp,pla[2], false, true);
      PlotPlanetImage(plbmp,2);
      end;
   4: begin
      PlotHeader(plbmp,pla[4], false, true);
      PlotPlanetImage(plbmp,4);
      end;
   5: begin
      PlotHeader(plbmp,pla[5], false, true);
      PlotPlanetImage(plbmp,5);
      end;
   6: begin
      PlotHeader(plbmp,pla[6], false, true);
      PlotPlanetImage(plbmp,6);
      end;
   7: begin
      PlotHeader(plbmp, rsInnerSolarSy, false, false);
      PlotOrbit1(plbmp);
      end;
   8: begin
      PlotHeader(plbmp, rsOuterSolarSy, false, false);
      PlotOrbit2(plbmp);
      end;
end;
CheckBox1.Checked:=not CenterAtNoon;
CheckBox1.Visible:=PageControl1.ActivePageIndex=0;
finally
Initialized:=true;
Invalidate;
BringToFront;
end;
end;

Procedure Tf_planetinfo.PlotTwilight(bmp:TBGRABitmap);
var ars,des,dist,diam,hp1,hp2,h : double;

  procedure PlotRect(de,hh,h1,h2:double; color: integer);
  var x1,x2: integer;
  begin
  if h1>-99 then begin
    if CenterAtNoon then begin
      h1:=rmod(h1+config.timezone+24,24);
      h2:=rmod(h2+config.timezone+24,24);
    end else begin
      h1:=rmod(h1+config.timezone+24+12,24);
      h2:=rmod(h2+config.timezone+24+12,24);
    end;
    x1:=xmin+round((h1/24)*(xmax-xmin));
    x2:=xmin+round((h2/24)*(xmax-xmin));
    if h2>=h1 then begin
      bmp.FillRect(x1,ymin,x2,ymax,ColorToBGRA(dfskycolor[color]),dmSet);
    end else begin
      bmp.FillRect(xmin,ymin,x2,ymax,ColorToBGRA(dfskycolor[color]),dmSet);
      bmp.FillRect(x1,ymin,xmax,ymax,ColorToBGRA(dfskycolor[color]),dmSet);
    end;
  end else begin
    if config.ObsLatitude-90+rad2deg*de-hh>0 then begin
       bmp.FillRect(xmin,ymin,xmax,ymax,ColorToBGRA(dfskycolor[color]),dmSet);
    end;
  end;
  end;

begin
  Fplanet.Sun(config.CurJDTT,ars,des,dist,diam);
  precession(jd2000,config.CurJDUT,ars,des);
  if (ars<0) then ars:=ars+pi2;
  // astro twilight
  h:=-18;
  Time_Alt(config.jd0,ars,des,h,hp1,hp2,config.ObsLatitude,config.ObsLongitude);
  PlotRect(des,h,hp1,hp2,5);
  // nautical twilight
  h:=-12;
  Time_Alt(config.jd0,ars,des,h,hp1,hp2,config.ObsLatitude,config.ObsLongitude);
  PlotRect(des,h,hp1,hp2,4);
  // civil twilight
  h:=-6;
  Time_Alt(config.jd0,ars,des,h,hp1,hp2,config.ObsLatitude,config.ObsLongitude);
  PlotRect(des,h,hp1,hp2,3);
  // sun rise
  h:=0;
  Time_Alt(config.jd0,ars,des,h,hp1,hp2,config.ObsLatitude,config.ObsLongitude);
  PlotRect(des,h,hp1,hp2,2);
end;

procedure Tf_planetinfo.PlotLine(bmp:TBGRABitmap; lbl:string; y:integer; des,h1,h2,ht:double);
var x1,x2,xt:integer;
    ts : Tsize;
begin
  if h1>-99 then begin
    if (h1<>0)or(h2<>24) then begin
      if CenterAtNoon then begin
        h1:=rmod(h1+24,24);
        h2:=rmod(h2+24,24);
      end else begin
        h1:=rmod(h1+24+12,24);
        h2:=rmod(h2+24+12,24);
      end;
    end;
    x1:=xmin+round((h1/24)*(xmax-xmin));
    x2:=xmin+round((h2/24)*(xmax-xmin));
    if h2>=h1 then begin
      bmp.DrawLineAntialias(x1,y,x2,y,ColorToBGRA(clYellow),3);
    end else begin
      bmp.DrawLineAntialias(xmin,y,x2,y,ColorToBGRA(clYellow),3);
      bmp.DrawLineAntialias(x1,y,xmax,y,ColorToBGRA(clYellow),3);
    end;
  end else begin
    if config.ObsLatitude-90+rad2deg*des>0 then begin
       bmp.DrawLineAntialias(xmin,y,xmax,y,ColorToBGRA(clYellow),3);
    end;
  end;
  if ht>-99 then begin
    if CenterAtNoon then begin
      ht:=rmod(ht+24,24);
    end else begin
      ht:=rmod(ht+24+12,24);
    end;
    xt:=xmin+round((ht/24)*(xmax-xmin));
    bmp.DrawVertLine(xt,y,y-5,ColorToBGRA(clYellow));
  end;
  bmp.FontHeight:=round(16*TextZoom);
  bmp.FontStyle:=[fsBold];
  repeat
    ts:=bmp.TextSize(lbl);
    if (ts.cx>xmin-5) then bmp.FontHeight:=bmp.FontHeight-1;
  until (ts.cx<=xmin-5)or(bmp.FontHeight<8);
  bmp.TextOut(xmin-5,y-6,lbl,ColorToBGRA(clWhite),taRightJustify);
  bmp.TextOut(xmax+5,y-5,lbl,ColorToBGRA(clWhite),taLeftJustify);
end;

Procedure Tf_planetinfo.PlotPlanet(bmp:TBGRABitmap);
var ipla,yc,ys,i:integer;
    ar,de,dist,diam,dkm,phase,illum,magn,dp,xp,yp,zp,vel,hp1,hp2,ht,azr,azs: double;
begin
if ShowCurrentObject and config.FindOK and (config.FindType<>ftPla) then
  ys:=trunc((ymax-ymin)/11)
else
  ys:=trunc((ymax-ymin)/10);
yc:=ymin+ys;
// sun first
ipla:=10;
Fplanet.Sun(config.CurJDTT,ar,de,dist,diam);
precession(jd2000,config.CurJDUT,ar,de);
if (ar<0) then ar:=ar+pi2;
RiseSet(config.jd0,ar,de,hp1,ht,hp2,azr,azs,i,config);
case i of
  0: PlotLine(bmp,pla[ipla],yc,de,hp1,hp2,ht);
  1: PlotLine(bmp,pla[ipla],yc,de,0,24,ht);
  2: PlotLine(bmp,pla[ipla],yc,de,-100,-100,-100);
end;
// moon second
ipla:=11;
yc:=yc+ys;
Fplanet.Moon(config.CurJDTT,ar,de,dist,dkm,diam,phase,illum);
precession(jd2000,config.CurJDUT,ar,de);
if (ar<0) then ar:=ar+pi2;
RiseSet(config.jd0,ar,de,hp1,ht,hp2,azr,azs,i,config);
case i of
  0: PlotLine(bmp,pla[ipla],yc,de,hp1,hp2,ht);
  1: PlotLine(bmp,pla[ipla],yc,de,0,24,ht);
  2: PlotLine(bmp,pla[ipla],yc,de,-100,-100,-100);
end;
// other planets
for ipla:=1 to 8 do begin
  if ipla=3 then continue; // skip earth
  yc:=yc+ys;
  Fplanet.Planet(ipla,config.CurJDTT,ar,de,dist,illum,phase,diam,magn,dp,xp,yp,zp,vel);
  precession(jd2000,config.CurJDUT,ar,de);
  if (ar<0) then ar:=ar+pi2;
  RiseSet(config.jd0,ar,de,hp1,ht,hp2,azr,azs,i,config);
  case i of
    0: PlotLine(bmp,pla[ipla],yc,de,hp1,hp2,ht);
    1: PlotLine(bmp,pla[ipla],yc,de,0,24,ht);
    2: PlotLine(bmp,pla[ipla],yc,de,-100,-100,-100);
  end;
end;
end;

Procedure Tf_planetinfo.PlotSelection(bmp:TBGRABitmap);
var yc,ys,i:integer;
    hp1,hp2,ht,azr,azs: double;

begin
if ShowCurrentObject and config.FindOK and (config.FindType<>ftPla) then begin
  ys:=trunc((ymax-ymin)/11);
  yc:=ymax-ys;
  RiseSet(config.jd0,config.FindRA,config.FindDec,hp1,ht,hp2,azr,azs,i,config);
  case i of
    0: PlotLine(bmp,config.FindName,yc,config.FindDec,hp1,hp2,ht);
    1: PlotLine(bmp,config.FindName,yc,config.FindDec,0,24,ht);
    2: PlotLine(bmp,config.FindName,yc,config.FindDec,-100,-100,-100);
  end;
end;
end;

Procedure Tf_planetinfo.PlotHeader(bmp:TBGRABitmap; title:String; showobs,showtime: boolean);
var c:TBGRAPixel;
    buf: string;
begin
  c:=ColorToBGRA(clWhite);
  bmp.FontHeight:=round(24*TextZoom);
  bmp.FontStyle:=[fsBold];
  bmp.TextOut(bmp.Width div 2,10,title,c,taCenter);
  bmp.FontHeight:=round(16*TextZoom);
  buf:=Date2Str(config.CurYear,config.CurMonth,config.CurDay)+blank+'  ( '+TzGMT2UTC(config.tz.ZoneName)+' )';
  bmp.TextOut(20,40,buf,c,taLeftJustify);
  if showobs then begin
    buf:=config.ObsName;
    bmp.TextOut(bmp.Width-20,40,buf,c,taRightJustify);
  end else
   if showtime then begin
     buf:=ArmToStr(config.CurTime);
     bmp.TextOut(bmp.Width-20,40,buf,c,taRightJustify);
   end;
end;

Procedure Tf_planetinfo.PlotFrame(bmp:TBGRABitmap);
var x,y,i: integer;
    l: string;
    c:TBGRAPixel;
begin
  c:=ColorToBGRA(clWhite);
  bmp.FontHeight:=round(12*TextZoom);
  bmp.FontStyle:=[fsBold];
  bmp.Rectangle(xmin,ymin,xmax,ymax,c,dmSet);
  for i:=0 to 24 do begin
      x:=xmin+trunc(i*((xmax-xmin)/24));
      y:=ymin-round(5*TextZoom);
      bmp.DrawVertLine(x,y,ymin,c);
      if CenterAtNoon then l:=inttostr(i)
         else l:=inttostr((i+12) mod 24);
      if (i mod 2)=0 then bmp.TextOut(x,y-15,l,c,taCenter);
  end;
  if CenterAtNoon then x:=xmin+trunc(config.CurTime*((xmax-xmin)/24))
                  else x:=xmin+trunc(rmod(config.CurTime+12,24)*((xmax-xmin)/24));
  bmp.DrawVertLine(x,ymin,ymax,ColorToBGRA(clRed));
end;

Procedure Tf_planetinfo.PlotPlanetImage(bmp:TBGRABitmap; ipla:integer);
var searchdir,sz,buf : string;
    s,irc,j: integer;
    gw: double;
    b: TBGRABitmap;
    r:TStringList;
begin
  s:=min((xmax-xmin),(ymax-xmin));
  s:=min(s,600);
  sz:=inttostr(s)+'x'+inttostr(s);
  searchdir:=slash(appdir)+slash('data')+'planet';
  r:=TStringList.Create;
  if ipla=5 then gw:=planet.JupGRS(config.GRSlongitude,config.GRSdrift,config.GRSjd,config.CurJDTT)
            else gw:=0;
  GetXplanet(Xplanetversion,'',searchdir,sz,slash(Tempdir)+'info2.png',ipla,0,gw,config.CurJDTT,irc,r );
  if (irc=0)and(FileExists(slash(Tempdir)+'info2.png')) then begin
    b:=TBGRABitmap.Create(slash(Tempdir)+'info2.png');
    bmp.PutImage(xmin+((xmax-xmin-s)div 2),ymin+((ymax-ymin-s)div 2),b,dmSet);
    b.Free;
  end else begin // something go wrong with xplanet
     buf:='';
     if r.Count>0 then for j:=0 to r.Count-1 do begin
      buf:=buf+r[j]+crlf;
     end;
     writetrace('Return code '+inttostr(irc)+' from xplanet');
     writetrace(buf);
 end;
 r.Free;
end;

Procedure Tf_planetinfo.PlotOrbit1(bmp:TBGRABitmap);
var p: ArrayOfTPointF;
    s,ipla,txtp,txts,ps,ss: integer;
    cx,cy,fx: single;
    jdt,sd:double;
    pl: TPlanData;
const nbstep=100;
      per: array[1..4] of integer = (88,225,365,687);
      col: array[1..4] of TColor = (clGray,clWhite,clAqua,clRed);

  Procedure PlanetOrbit;
  var i:integer;
      px,py: double;
  begin
    sd:=per[ipla]/nbstep;
    jdt:=config.CurJDTT;
    for i:=0 to nbstep do begin
      planet.Plan(ipla,jdt,pl);
      // rotate equatorial to ecliptic
      px:=pl.x;
      py:= coseps2k*pl.y + sineps2k*pl.z;
      p[i].x:=fx*px+cx;
      p[i].y:=-fx*py+cy;
      jdt:=jdt+sd;
    end;
    bmp.DrawPolyLineAntialias(p,ColorToBGRA(clGray),0.5,true);
    bmp.FillEllipseAntialias(p[0].x,p[0].y,ps,ps,ColorToBGRA(col[ipla]));
    if ipla=3 then bmp.TextOut(20, txtp+txts*ipla, rsEarth, ColorToBGRA(col[ipla]), taLeftJustify)
              else bmp.TextOut(20,txtp+txts*ipla,pla[ipla],ColorToBGRA(col[ipla]),taLeftJustify);
  end;

begin
s:=min((xmax-xmin),(ymax-xmin));
cx:=xmin+(xmax-xmin)/2;
cy:=ymin+(ymax-ymin)/2;
fx:=s/3.5;
ps:=round(5*TextZoom);
ss:=round(8*TextZoom);
txts:=round(30*TextZoom);
txtp:=ymax-6*txts;
bmp.FillEllipseAntialias(cx,cy,ss,ss,ColorToBGRA(clYellow));  // sun
bmp.FontHeight:=round(24*TextZoom);
bmp.TextOut(20,txtp,pla[10],ColorToBGRA(clYellow),taLeftJustify);
SetLength(p,nbstep+1);
for ipla:=1 to 4 do PlanetOrbit;
end;

Procedure Tf_planetinfo.PlotOrbit2(bmp:TBGRABitmap);
var p: ArrayOfTPointF;
    s,ipla,txtp,txts,ps,ss: integer;
    cx,cy,fx: single;
    jdt,sd:double;
    pl: TPlanData;
const nbstep=100;
      per: array[1..6] of integer = (687,4332,10760,30590,59799,90553);
      col: array[1..6] of TColor = (clred,clOlive,clWhite,clAqua,clBlue,clGray);

  Procedure PlanetOrbit;
  var i:integer;
      px,py: double;
  begin
    sd:=per[ipla]/nbstep;
    jdt:=config.CurJDTT;
    for i:=0 to nbstep do begin
      planet.Plan(ipla+3,jdt,pl);
      // rotate equatorial to ecliptic
      px:=pl.x;
      py:= coseps2k*pl.y + sineps2k*pl.z;
      p[i].x:=fx*px+cx;
      p[i].y:=-fx*py+cy;
      jdt:=jdt+sd;
    end;
    bmp.DrawPolyLineAntialias(p,ColorToBGRA(clGray),0.5,true);
    bmp.FillEllipseAntialias(p[0].x,p[0].y,ps,ps,ColorToBGRA(col[ipla]));
    bmp.TextOut(20,txtp+txts*ipla,pla[ipla+3],ColorToBGRA(col[ipla]),taLeftJustify);
  end;

begin
s:=min((xmax-xmin),(ymax-xmin));
cx:=xmin+(xmax-xmin)/2;
cy:=ymin+(ymax-ymin)/2;
fx:=s/65;
ps:=round(5*TextZoom);
ss:=round(8*TextZoom);
txts:=round(30*TextZoom);
txtp:=ymax-7*txts;
bmp.FillEllipseAntialias(cx,cy,ss,ss,ColorToBGRA(clYellow));  // sun
bmp.FontHeight:=round(24*TextZoom);
bmp.TextOut(20,txtp,pla[10],ColorToBGRA(clYellow),taLeftJustify);
SetLength(p,nbstep+1);
for ipla:=1 to 6 do PlanetOrbit;
end;

end.

