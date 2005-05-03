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
uses u_util, u_projection;

const maxstep = 100;
      MonthLst : array [1..12] of string = ('Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec');

procedure Tf_calendar.FormCreate(Sender: TObject);
var yy,mm,dd: word;
begin
ShowImage:=Tf_image.Create(self);
db:=TMyDB.create(self);
decodedate(now,yy,mm,dd);
date1.Year:=yy;
date1.Month:=mm;
date1.day:=dd;
date2.JD:=date1.JD+5;
time.Time:=now;
initial:=true;
end;
                       
procedure Tf_calendar.FormDestroy(Sender: TObject);
begin
ShowImage.Free;
db.Free;
end;

procedure Tf_calendar.FormShow(Sender: TObject);
begin
if initial then begin
  date1.Year:=c.CurYear;
  date1.Month:=c.CurMonth;
  date1.day:=c.CurDay;
  date2.JD:=date1.JD+5;
  time.Time:=c.CurTime/24;
  CometFilter.Text:='C/'+inttostr(c.CurYear);
  RefreshAll;
  initial:=false;
end;
end;

Procedure Tf_calendar.SetLang(languagefile:string);
var section : string;
    inifile : Tmeminifile;
    i : integer;
const blank = '        ';
const deftxt = '?';
begin
inifile:=Tmeminifile.create(languagefile);
section:='calendar';
with inifile do begin
    Caption:=ReadString(section,'title',deftxt);
    label1.caption:=ReadString(section,'t_1',deftxt);
    label2.caption:=ReadString(section,'t_2',deftxt);
    label5.caption:=ReadString(section,'t_3',deftxt);
    label3.caption:=ReadString(section,'t_4',deftxt);
    label4.caption:=ReadString(section,'t_5',deftxt);
    twilight.caption:=ReadString(section,'t_6',deftxt);
    planets.caption:=ReadString(section,'t_7',deftxt);
    comet.caption:=ReadString(section,'t_8',deftxt);
    solar.caption:=ReadString(section,'t_9',deftxt);
    lunar.caption:=ReadString(section,'t_10',deftxt);
    Satellites.caption:=ReadString(section,'t_11',deftxt);
    label7.caption:=ReadString(section,'t_12',deftxt);
    label8.caption:=ReadString(section,'t_13',deftxt);
    label6.caption:=ReadString(section,'t_14',deftxt);
    SatChartBox.caption:=ReadString(section,'t_15',deftxt);
    IridiumBox.caption:=ReadString(section,'t_16',deftxt);
    ResetBtn.Caption:=ReadString(section,'t_17',deftxt);
//    TLEbtn.hint:=ReadString(section,'t_18',deftxt)+' '+slash(appdir)+satpath;
    tz:=ReadString(section,'t_19',deftxt);
    west:=ReadString(section,'t_20',deftxt);
    east:=ReadString(section,'t_21',deftxt);
    EcliPanel.Hint:=ReadString(section,'t_22',deftxt);
    BitBtn5.Caption:=ReadString(section,'t_23',deftxt);
    BitBtn1.Caption:=ReadString('buttons','refresh',deftxt);
    BitBtn2.Caption:=ReadString('buttons','close',deftxt);
    BitBtn3.Caption:=ReadString('buttons','help',deftxt);
    BitBtn4.Caption:=ReadString('buttons','print',deftxt);
    mercure.caption:=pla[1];
    venus.caption:=pla[2];
    mars.caption:=pla[4];
    jupiter.caption:=pla[5];
    saturne.caption:=pla[6];
    uranus.caption:=pla[7];
    neptune.caption:=pla[8];
    pluton.caption:=pla[9];
    psoleil.caption:=pla[10];
    plune.caption:=pla[11];
    for i:=1 to nummsg do begin
       appmsg[i]:=ReadString(section,'m_'+trim(inttostr(i)),deftxt);
    end;
end;
inifile.free;
title:=caption;
crepusculetitle;
cometetitle;
asteroidtitle;
planettitle;
Solartitle;
LunarTitle;
SatTitle; 
end;

Procedure Tf_calendar.cometetitle;
begin
with cometgrid do begin
cells[9,0]:=appmsg[14];
cells[10,0]:=appmsg[15];
cells[11,0]:=appmsg[14];
cells[12,0]:=appmsg[16];
cells[0,1]:=appmsg[11];
cells[1,1]:=appmsg[1];
cells[2,1]:=appmsg[2];
cells[3,1]:=appmsg[3];
cells[4,1]:=appmsg[17];
cells[5,1]:=appmsg[18];
cells[6,1]:=appmsg[6];
cells[7,1]:=appmsg[7];
cells[8,1]:=appmsg[8];
cells[9,1]:=appmsg[12];
cells[10,1]:=appmsg[13];
cells[11,1]:=appmsg[13];
cells[12,1]:=appmsg[12];
end;
end;

Procedure Tf_calendar.asteroidtitle;
begin
with asteroidgrid do begin
cells[9,0]:=appmsg[14];
cells[10,0]:=appmsg[15];
cells[11,0]:=appmsg[14];
cells[12,0]:=appmsg[16];
cells[0,1]:=appmsg[11];
cells[1,1]:=appmsg[1];
cells[2,1]:=appmsg[2];
cells[3,1]:=appmsg[3];
cells[4,1]:=appmsg[17];
cells[5,1]:=appmsg[18];
cells[6,1]:=appmsg[6];
cells[7,1]:=appmsg[7];
cells[8,1]:=appmsg[8];
end;
end;

Procedure Tf_calendar.crepusculetitle;
begin
with twilightgrid do begin
cells[1,0]:=appmsg[9];
cells[2,0]:='';
cells[3,0]:=appmsg[10];
cells[4,0]:='';
cells[0,1]:=appmsg[11];
cells[1,1]:=appmsg[12];
cells[2,1]:=appmsg[13];
cells[3,1]:=appmsg[13];
cells[4,1]:=appmsg[12];
end;
end;

Procedure Tf_calendar.planettitle;
begin
with Soleilgrid do begin
cells[1,1]:=appmsg[1];
cells[2,1]:=appmsg[2];
cells[3,1]:=appmsg[3];
cells[4,1]:=appmsg[4];
cells[5,1]:=appmsg[5];
cells[6,1]:=appmsg[6];
cells[7,1]:=appmsg[7];
cells[8,1]:=appmsg[8];
cells[9,1]:=appmsg[21];
cells[10,1]:=appmsg[22];
end;
with Mercuregrid do begin
cells[1,1]:=appmsg[1];
cells[2,1]:=appmsg[2];
cells[3,1]:=appmsg[3];
cells[4,1]:=appmsg[4];
cells[5,1]:=appmsg[5];
cells[6,1]:=appmsg[6];
cells[7,1]:=appmsg[7];
cells[8,1]:=appmsg[8];
cells[9,1]:=appmsg[21];
cells[10,1]:=appmsg[22];
end;
with venusgrid do begin
cells[1,1]:=appmsg[1];
cells[2,1]:=appmsg[2];
cells[3,1]:=appmsg[3];
cells[4,1]:=appmsg[4];
cells[5,1]:=appmsg[5];
cells[6,1]:=appmsg[6];
cells[7,1]:=appmsg[7];
cells[8,1]:=appmsg[8];
cells[9,1]:=appmsg[21];
cells[10,1]:=appmsg[22];
end;
with lunegrid do begin
cells[1,1]:=appmsg[1];
cells[2,1]:=appmsg[2];
cells[3,1]:=appmsg[3];
cells[4,1]:=appmsg[4];
cells[5,1]:=appmsg[5];
cells[6,1]:=appmsg[6];
cells[7,1]:=appmsg[7];
cells[8,1]:=appmsg[8];
cells[9,1]:=appmsg[21];
cells[10,1]:=appmsg[22];
end;
with Marsgrid do begin
cells[1,1]:=appmsg[1];
cells[2,1]:=appmsg[2];
cells[3,1]:=appmsg[3];
cells[4,1]:=appmsg[4];
cells[5,1]:=appmsg[5];
cells[6,1]:=appmsg[6];
cells[7,1]:=appmsg[7];
cells[8,1]:=appmsg[8];
cells[9,1]:=appmsg[21];
cells[10,1]:=appmsg[22];
end;
with jupitergrid do begin
cells[1,1]:=appmsg[1];
cells[2,1]:=appmsg[2];
cells[3,1]:=appmsg[3];
cells[4,1]:=appmsg[4];
cells[5,1]:=appmsg[5];
cells[6,1]:=appmsg[6];
cells[7,1]:=appmsg[7];
cells[8,1]:=appmsg[8];
cells[9,1]:=appmsg[21];
cells[10,1]:=appmsg[22];
end;
with saturnegrid do begin
cells[1,1]:=appmsg[1];
cells[2,1]:=appmsg[2];
cells[3,1]:=appmsg[3];
cells[4,1]:=appmsg[4];
cells[5,1]:=appmsg[5];
cells[6,1]:=appmsg[6];
cells[7,1]:=appmsg[7];
cells[8,1]:=appmsg[8];
cells[9,1]:=appmsg[21];
cells[10,1]:=appmsg[22];
end;
with uranusgrid do begin
cells[1,1]:=appmsg[1];
cells[2,1]:=appmsg[2];
cells[3,1]:=appmsg[3];
cells[4,1]:=appmsg[4];
cells[5,1]:=appmsg[5];
cells[6,1]:=appmsg[6];
cells[7,1]:=appmsg[7];
cells[8,1]:=appmsg[8];
cells[9,1]:=appmsg[21];
cells[10,1]:=appmsg[22];
end;
with neptunegrid do begin
cells[1,1]:=appmsg[1];
cells[2,1]:=appmsg[2];
cells[3,1]:=appmsg[3];
cells[4,1]:=appmsg[4];
cells[5,1]:=appmsg[5];
cells[6,1]:=appmsg[6];
cells[7,1]:=appmsg[7];
cells[8,1]:=appmsg[8];
cells[9,1]:=appmsg[21];
cells[10,1]:=appmsg[22];
end;
with plutongrid do begin
cells[1,1]:=appmsg[1];
cells[2,1]:=appmsg[2];
cells[3,1]:=appmsg[3];
cells[4,1]:=appmsg[4];
cells[5,1]:=appmsg[5];
cells[6,1]:=appmsg[6];
cells[7,1]:=appmsg[7];
cells[8,1]:=appmsg[8];
cells[9,1]:=appmsg[21];
cells[10,1]:=appmsg[22];
end;
end;

Procedure Tf_calendar.Solartitle;
begin
with solargrid do begin
cells[0,1]:=appmsg[11];
cells[1,1]:=appmsg[47];
cells[2,0]:=appmsg[23];
cells[2,1]:=appmsg[24];
cells[3,1]:=appmsg[25];
cells[4,1]:=appmsg[26];
cells[5,1]:=appmsg[27];
cells[6,1]:=appmsg[28];
cells[7,0]:=appmsg[29];
cells[7,1]:=appmsg[31];
cells[8,0]:=appmsg[30];
cells[8,1]:=appmsg[32];
cells[9,1]:=appmsg[33];
cells[10,1]:=appmsg[34];
cells[11,1]:=appmsg[35];

end;
end;

Procedure Tf_calendar.Lunartitle;
begin
with Lunargrid do begin
cells[0,1]:=appmsg[11];
cells[1,0]:=appmsg[23];
cells[1,1]:=appmsg[24];
cells[2,1]:=appmsg[25];
cells[3,1]:=appmsg[26];
cells[4,1]:=appmsg[27];
cells[5,0]:=appmsg[36];
cells[5,1]:=appmsg[28];
cells[6,0]:=appmsg[37];
cells[6,1]:=appmsg[28];
cells[7,0]:=appmsg[38];
cells[7,1]:=appmsg[40];
cells[8,0]:=appmsg[39];
cells[8,1]:=appmsg[41];
end;
end;

Procedure Tf_calendar.Sattitle;
begin
with Satgrid do begin
cells[0,1]:=appmsg[11];
cells[1,1]:=appmsg[42];
cells[2,1]:=appmsg[3];
cells[3,1]:=appmsg[21];
cells[4,1]:=appmsg[22];
cells[5,1]:=appmsg[43];
cells[6,1]:=appmsg[1];
cells[7,1]:=appmsg[2];
cells[8,1]:=appmsg[44];
cells[9,1]:=appmsg[45];
end;
end;

function Tf_calendar.SetObjCoord(jd,ra,dec: double) : Tobject;
var p : TObjCoord;
begin
  p:=TObjCoord.Create;
  p.jd:=jd;
  p.ra:=ra;
  p.dec:=dec;
  result:=p;
end;

Procedure Tf_calendar.FreeCoord(var gr : Tstringgrid);
var i,j : integer;
begin
try
if gr<>nil then with gr as Tstringgrid do
  if rowcount>=3 then
    for i:=2 to rowcount-1 do
      for j:=0 to colcount-1 do
        if Objects[j,i]<>nil then Objects[j,i].Free;
except
  gr.Cells[0,0]:='';
end;
end;

Procedure Tf_calendar.InitRiseCell(var gr : Tstringgrid);
var i : integer;
begin
with gr do
    for i:=2 to rowcount-1 do begin
        cells[6,i]:=''; cells[7,i]:=''; cells[8,i]:='';
        end;
end;

Procedure Tf_calendar.PlanetRiseCell(var gr : Tstringgrid; i,irc : integer; hr,ht,hs,azr,azs,jda,h,ar,de : double);
var ir,ic,it : integer;
    jdcor : double;
begin
with gr do begin
  ir:=i;
  jdcor:=0;
  if hr<0 then begin ir:=i-1 ; hr:=hr+24; jdcor:=-1; end;
  if hr>24 then begin ir:=i+1; hr:=hr-24; jdcor:=1; end;
  it:=i;
  if ht<0 then begin  it:=i-1; ht:=ht+24; jdcor:=-1; end;
  if ht>24 then begin it:=i+1; ht:=ht-24; jdcor:=1; end;
  ic:=i;
  if hs<0 then begin ic:=i-1; hs:=hs+24; jdcor:=-1; end;
  if hs>24 then begin ic:=i+1; hs:=hs-24; jdcor:=-1; end;
  case irc of
       0 : begin
           if (ir>1)and(ir<rowcount) then cells[6,ir]:=armtostr(hr);
           if (it>1)and(it<rowcount) then cells[7,it]:=armtostr(ht);
           if (ic>1)and(ic<rowcount) then cells[8,ic]:=armtostr(hs);
           objects[6,ir]:=SetObjCoord(jda+jdcor+(hr-c.timezone-h)/24,ar,de);
           objects[7,it]:=SetObjCoord(jda+jdcor+(ht-c.timezone-h)/24,ar,de);
           objects[8,ic]:=SetObjCoord(jda+jdcor+(hs-c.timezone-h)/24,ar,de);
           end;
       1 : begin
           if (ir>1)and(ir<rowcount) then cells[6,ir]:='-';
           if (it>1)and(it<rowcount) then cells[7,it]:=armtostr(ht);
           if (ic>1)and(ic<rowcount) then cells[8,ic]:='-';
           objects[7,ir].free;
           objects[7,it]:=SetObjCoord(jda+jdcor+(ht-c.timezone-h)/24,ar,de);
           objects[7,ic].free;
           end;
       2 : begin
           if (ir>1)and(ir<rowcount) then cells[6,ir]:='-';
           if (it>1)and(it<rowcount) then cells[7,it]:='-';
           if (ic>1)and(ic<rowcount) then cells[8,ic]:='-';
           objects[7,ir].free;
           objects[7,it].free;
           objects[7,ic].free;
           end;
  end;
end;
end;

procedure Tf_calendar.RefreshSolarEclipse;
var f : textfile;
    buf,mm,century,pathimage : string;
    h,jda : double;
    i,n,a,m,j : integer;
begin
dat41:=date1.JD;
j:=date1.year;
if j>0 then begin
  j:=j-1;
  century:=padzeros(inttostr(1+((abs(j)) div 100)),2);
end else begin
  century:=padzeros(inttostr(((abs(j)) div 100)),2);
  century:='-'+century;
end;
if century_Solar<>century then begin // lire le fichier la premiere fois
FreeCoord(Solargrid);
solargrid.RowCount:=3;
for i:=0 to solargrid.ColCount do solargrid.Cells[i,2]:='';
if not fileexists(slash(Feclipsepath)+'solar'+century+'.txt') then exit;
screen.cursor:=crHourglass;
try
Filemode:=0;
Assignfile(f,slash(Feclipsepath)+'solar'+century+'.txt');
reset(f);
i:=2;
solargrid.visible:=false;
repeat
Readln(f,buf);
with solargrid do begin
  RowCount:=i+1;
  cells[0,i]:=copy(buf,1,12);
  cells[2,i]:=copy(buf,15,5);
  cells[3,i]:=copy(buf,23,3);
  cells[4,i]:=copy(buf,26,4);
  cells[5,i]:=copy(buf,31,6);
  cells[6,i]:=copy(buf,39,5);
  cells[7,i]:=copy(buf,46,5);
  cells[8,i]:=copy(buf,52,6);
  cells[9,i]:=copy(buf,60,2);
  cells[10,i]:=copy(buf,63,4);
  cells[11,i]:=copy(buf,69,6);
  pathimage:=slash(Feclipsepath)+'SE'+stringreplace(cells[0,i],' ','',[rfReplaceAll])+copy(cells[3,i],1,1)+'.png';
  if fileexists(pathimage) then cells[1,i]:=appmsg[47]
                           else cells[1,i]:='';
  a:=strtointdef(copy(cells[0,i],1,5),-9999);
  mm:=copy(cells[0,i],7,3);
  m:=0;
  for n:=1 to 12 do
      if mm=monthlst[n] then begin
         m:=n;
         break;
      end;
  j:=strtointdef(copy(cells[0,i],11,2),0);
  if (a<>-9999)and(m<>0)and(j<>0) then begin
     h:=strtofloat(copy(cells[2,i],1,2))+strtofloat(copy(cells[2,i],4,2))/60;
     jda:=jd(a,m,j,h);
     objects[0,i]:=SetObjCoord(jda,-1000,-1000);
  end;
end;
i:=i+1;
until eof(f);
century_Solar:=century;
finally
solargrid.visible:=true;
Closefile(f);
screen.cursor:=crDefault;
end;
end; // fin lecture fichier
a:=date1.year;
with solargrid do begin
  for i:=2 to rowcount-1 do begin
     if strtoint(copy(cells[0,i],1,5))=a then begin
        toprow:=i;
        break;
     end;
     if strtoint(copy(cells[0,i],1,5))>a then begin
        toprow:=i-1;
        break;
     end;
  end;
end;
end;

procedure Tf_calendar.RefreshLunarEclipse;
var f : textfile;
    buf,mm,century : string;
    h,jda : double;
    i,n,a,m,j : integer;
begin
dat51:=date1.jd;
j:=date1.year;
if j>0 then begin
  j:=j-1;
  century:=padzeros(inttostr(1+((abs(j)) div 100)),2);
end else begin
  century:=padzeros(inttostr(((abs(j)) div 100)),2);
  century:='-'+century;
end;
if century_Lunar<>century then begin // lire le fichier la premiere fois
FreeCoord(Lunargrid);
lunargrid.RowCount:=3;
for i:=0 to lunargrid.ColCount do lunargrid.Cells[i,2]:='';
if not fileexists(slash(Feclipsepath)+'lunar'+century+'.txt') then exit;
screen.cursor:=crHourglass;
try
Filemode:=0;
Assignfile(f,slash(Feclipsepath)+'lunar'+century+'.txt');
reset(f);
i:=2;
lunargrid.visible:=false;
repeat
Readln(f,buf);
with lunargrid do begin
  RowCount:=i+1;
  cells[0,i]:=copy(buf,1,12);
  cells[1,i]:=copy(buf,15,5);
  cells[2,i]:=copy(buf,21,3);
  cells[3,i]:=copy(buf,25,3);
  cells[4,i]:=copy(buf,30,6);
  cells[5,i]:=copy(buf,38,5);
  cells[6,i]:=copy(buf,44,6);
  cells[7,i]:=copy(buf,51,4);
  cells[8,i]:=copy(buf,56,4);
  a:=strtointdef(copy(cells[0,i],1,5),-9999);
  mm:=copy(cells[0,i],7,3);
  m:=0;
  for n:=1 to 12 do
      if mm=monthlst[n] then begin
         m:=n;
         break;
      end;
  j:=strtointdef(copy(cells[0,i],11,2),0);
  if (a<>-9999)and(m<>0)and(j<>0) then begin
     h:=strtofloat(copy(cells[1,i],1,2))+strtofloat(copy(cells[1,i],4,2))/60;
     jda:=jd(a,m,j,h);
     objects[0,i]:=SetObjCoord(jda,-1000,-1000);
  end;
end;
i:=i+1;
until eof(f);
century_Lunar:=century;
finally
lunargrid.visible:=true;
Closefile(f);
screen.cursor:=crDefault;
end;
end; // fin lecture fichier
a:=date1.year;
with lunargrid do begin
  for i:=2 to rowcount-1 do begin
     if strtoint(copy(cells[0,i],1,5))=a then begin
        toprow:=i;
        break;
     end;
     if strtoint(copy(cells[0,i],1,5))>a then begin
        toprow:=i-1;
        break;
     end;
  end;
end;
end;

procedure Tf_calendar.RefreshAll;
var d: string;
begin
  RefreshTwilight;
  RefreshPlanet;
  RefreshSolarEclipse;
  RefreshLunarEclipse;
  if c.timezone=0 then d:=''
   else
    if c.timezone<0 then d:=east
      else d:=west;
  caption:=title+' '+c.Obsname+' '+tz+'='+timtostr(abs(c.timezone))+' '+d;
end;

procedure Tf_calendar.RefreshTwilight;
var jda,jd0,jd1,jd2,h : double;
    hp1,hp2,ars,des,dist,diam :Double;
    a,m,d,s,i,nj : integer;
begin
screen.cursor:=crHourglass;
try
TwilightGrid.Visible:=false;
FreeCoord(TwilightGrid);
dat11:=date1.JD;
dat12:=date2.JD;
dat13:=time.time;
dat14:=step.text;
s:=strtoint(step.text);
a:=date1.year;
m:=date1.month;
d:=date1.day;
h:=12-c.timezone;
jd1:=jd(a,m,d,h);
a:=date2.year;
m:=date2.month;
d:=date2.day;
jd2:=jd(a,m,d,h);
nj:=round((jd2-jd1)/s);
if nj>maxstep then if MessageDlg(appmsg[19]+' '+inttostr(nj)+' '+appmsg[20],
    mtConfirmation,[mbOk, mbCancel], 0) <> mrOK then exit;
jda:=jd1;
i:=2;
repeat
djd(jda,a,m,d,h);
jd0:=jd(a,m,d,0);
with TwilightGrid do begin
  RowCount:=i+1;
  cells[0,i]:=isodate(a,m,d);
  Fplanet.Sun(jd0+0.5,ars,des,dist,diam);
  if (ars<0) then ars:=ars+pi2;
  objects[0,i]:=SetObjCoord(jda,-999,-999);
  // crepuscule nautique
  Time_Alt(jd0,ars,des,-12,hp1,hp2,c);
  if hp1>-99 then begin
     cells[2,i]:=armtostr(rmod(hp1+c.timezone+24,24));
     objects[2,i]:=SetObjCoord(jda+(hp1-h)/24,-999,-999);
  end else  begin
     cells[2,i]:='-';
     objects[2,i]:=nil;
  end;
  if hp1>-99 then begin
     cells[3,i]:=armtostr(rmod(hp2+c.timezone+24,24));
     objects[3,i]:=SetObjCoord(jda+(hp2-h)/24,-999,-999);
  end else  begin
     cells[3,i]:='-';
     objects[3,i]:=nil;
  end;
  // crepuscule astro
  Time_Alt(jd0,ars,des,-18,hp1,hp2,c);
  if hp1>-99 then begin
     cells[1,i]:=armtostr(rmod(hp1+c.timezone+24,24));
     objects[1,i]:=SetObjCoord(jda+(hp1-h)/24,-999,-999);
  end else begin
     cells[1,i]:='-';
     objects[1,i]:=nil;
  end;
  if hp1>-99 then begin
     cells[4,i]:=armtostr(rmod(hp2+c.timezone+24,24));
     objects[4,i]:=SetObjCoord(jda+(hp2-h)/24,-999,-999);
  end else begin
     cells[4,i]:='-';
     objects[4,i]:=nil;
  end;
end;
jda:=jda+s;
i:=i+1;
until jda>jd2;
finally
TwilightGrid.Visible:=true;
screen.cursor:=crDefault;
end;
end;

procedure Tf_calendar.RefreshPlanet;
var ar,de,dist,illum,phase,diam,jda,magn,dkm,q,az,ha,dp : double;
    err,i,ipla,nj: integer;
    s,a,m,d,irc,ierr : integer;
    jd1,jd2,jd0,h,hr,ht,hs,azr,azs,st0,jdcor : double;
    am1,am2,dm1,dm2,am3,dm3 : double;
    jdt_ut : double;
    mr,mt,ms : string;
begin
screen.cursor:=crHourGlass;
try
SoleilGrid.Visible:=false;
MercureGrid.Visible:=false;
VenusGrid.Visible:=false;
LuneGrid.Visible:=false;
MarsGrid.Visible:=false;
JupiterGrid.Visible:=false;
SaturneGrid.Visible:=false;
UranusGrid.Visible:=false;
NeptuneGrid.Visible:=false;
PlutonGrid.Visible:=false;
dat21:=date1.JD;
dat22:=date2.JD;
dat23:=time.time;
dat24:=step.text;
s:=strtoint(step.text);
a:=date1.year;
m:=date1.month;
d:=date1.day;
h:=frac(Time.time)*24-c.TimeZone;
jd1:=jd(a,m,d,h);
a:=date2.year;
m:=date2.month;
d:=date2.day;
jd2:=jd(a,m,d,h);
nj:=round((jd2-jd1)/s);
if nj>maxstep then if MessageDlg(appmsg[19]+' '+inttostr(nj)+' '+appmsg[20],
    mtConfirmation,[mbOk, mbCancel], 0) <> mrOK then exit;
jda:=jd1;
i:=2;
InitRiseCell(SoleilGrid);
InitRiseCell(MercureGrid);
InitRiseCell(VenusGrid);
InitRiseCell(LuneGrid);
InitRiseCell(MarsGrid);
InitRiseCell(JupiterGrid);
InitRiseCell(SaturneGrid);
InitRiseCell(UranusGrid);
InitRiseCell(NeptuneGrid);
InitRiseCell(PlutonGrid);
FreeCoord(SoleilGrid);
FreeCoord(MercureGrid);
FreeCoord(VenusGrid);
FreeCoord(LuneGrid);
FreeCoord(MarsGrid);
FreeCoord(JupiterGrid);
FreeCoord(SaturneGrid);
FreeCoord(UranusGrid);
FreeCoord(NeptuneGrid);
FreeCoord(PlutonGrid);
repeat
djd(jda,a,m,d,h);
jd0:=jd(a,m,d,0);
jdt_ut:=DTminusUT(a,c)/24;
st0:=SidTim(jd0,h,c.ObsLongitude);
for ipla:=1 to 11 do begin
 if ipla=3 then continue;
case ipla of
 1 : with Mercuregrid do begin
  planet.Planet(ipla,jda+jdt_ut,ar,de,dist,illum,phase,diam,magn,dp);
  precession(jd2000,c.jdchart,ar,de);
  if c.PlanetParalaxe then Paralaxe(st0,dist,ar,de,ar,de,q,c);
  if c.ApparentPos then apparent_equatorial(ar,de,c);
  ar:=rmod(ar+pi2,pi2);
  objects[0,i]:=SetObjCoord(jda,ar,de);
  Eq2Hz((st0-ar),de,az,ha,c);
  az:=rmod(az+pi,pi2);
  RowCount:=i+1;
  cells[0,0]:=pla[ipla];
  cells[1,0]:=trim(c.EquinoxName)+' '+appmsg[46];
  cells[0,1]:=trim(armtostr(h))+' UT';
  cells[0,i]:=isodate(a,m,d);
  cells[1,i]:=artostr(rad2deg*ar/15);
  cells[2,i]:=detostr(rad2deg*de);
  cells[3,i]:=floattostrf(magn,ffFixed,5,1);
  cells[4,i]:=floattostrf(diam,ffFixed,6,1);
  cells[5,i]:=floattostrf(illum,ffFixed,6,2);
  cells[9,i]:=demtostr(rad2deg*az);
  cells[10,i]:=demtostr(rad2deg*ha);
  RiseSet(1,jd0,ar,de,hr,ht,hs,azr,azs,irc,c);
  case irc of
       0 : begin
           cells[6,i]:=armtostr(hr); cells[7,i]:=armtostr(ht); cells[8,i]:=armtostr(hs);
           objects[6,i]:=SetObjCoord(jda+(hr-c.timezone-h)/24,ar,de);
           objects[7,i]:=SetObjCoord(jda+(ht-c.timezone-h)/24,ar,de);
           objects[8,i]:=SetObjCoord(jda+(hs-c.timezone-h)/24,ar,de);
           end;
       1 : begin
           cells[6,i]:='-'; cells[7,i]:=armtostr(ht); cells[8,i]:='-';
           objects[6,i]:=nil;
           objects[7,i]:=SetObjCoord(jda+(ht-c.timezone-h)/24,ar,de);
           objects[8,i]:=nil;
           end;
       2 : begin
           cells[6,i]:='-'; cells[7,i]:='-'; cells[8,i]:='-';
           objects[6,i]:=nil;
           objects[7,i]:=nil;
           objects[8,i]:=nil;
           end;
  end;
 end;
 2 : with Venusgrid do begin
  planet.Planet(ipla,jda+jdt_ut,ar,de,dist,illum,phase,diam,magn,dp);
  precession(jd2000,c.jdchart,ar,de);
  if c.PlanetParalaxe then Paralaxe(st0,dist,ar,de,ar,de,q,c);
  if c.ApparentPos then apparent_equatorial(ar,de,c);
  ar:=rmod(ar+pi2,pi2);
  objects[0,i]:=SetObjCoord(jda,ar,de);
  Eq2Hz((st0-ar),de,az,ha,c);
  az:=rmod(az+pi,pi2);
  RowCount:=i+1;
  cells[0,0]:=pla[ipla];
  cells[1,0]:=trim(c.EquinoxName)+' '+appmsg[46];
  cells[0,1]:=trim(armtostr(h))+' UT';
  cells[0,i]:=isodate(a,m,d);
  cells[1,i]:=artostr(rad2deg*ar/15);
  cells[2,i]:=detostr(rad2deg*de);
  cells[3,i]:=floattostrf(magn,ffFixed,5,1);
  cells[4,i]:=floattostrf(diam,ffFixed,6,1);
  cells[5,i]:=floattostrf(illum,ffFixed,6,2);
  cells[9,i]:=demtostr(rad2deg*az);
  cells[10,i]:=demtostr(rad2deg*ha);
  RiseSet(1,jd0,ar,de,hr,ht,hs,azr,azs,irc,c);
  case irc of
       0 : begin
           cells[6,i]:=armtostr(hr); cells[7,i]:=armtostr(ht); cells[8,i]:=armtostr(hs);
           objects[6,i]:=SetObjCoord(jda+(hr-c.timezone-h)/24,ar,de);
           objects[7,i]:=SetObjCoord(jda+(ht-c.timezone-h)/24,ar,de);
           objects[8,i]:=SetObjCoord(jda+(hs-c.timezone-h)/24,ar,de);
           end;
       1 : begin
           cells[6,i]:='-'; cells[7,i]:=armtostr(ht); cells[8,i]:='-';
           objects[7,i]:=SetObjCoord(jda+(ht-c.timezone-h)/24,ar,de);
           objects[6,i]:=nil;
           objects[8,i]:=nil;
           end;
       2 : begin
           cells[6,i]:='-'; cells[7,i]:='-'; cells[8,i]:='-';
           objects[6,i]:=nil;
           objects[7,i]:=nil;
           objects[8,i]:=nil;
           end;
  end;
 end;
 4 : with Marsgrid do begin
  planet.Planet(ipla,jda+jdt_ut,ar,de,dist,illum,phase,diam,magn,dp);
  precession(jd2000,c.jdchart,ar,de);
  if c.PlanetParalaxe then Paralaxe(st0,dist,ar,de,ar,de,q,c);
  if c.ApparentPos then apparent_equatorial(ar,de,c);
  ar:=rmod(ar+pi2,pi2);
  objects[0,i]:=SetObjCoord(jda,ar,de);
  Eq2Hz((st0-ar),de,az,ha,c);
  az:=rmod(az+pi,pi2);
  RowCount:=i+1;
  cells[0,0]:=pla[ipla];
  cells[1,0]:=trim(c.EquinoxName)+' '+appmsg[46];
  cells[0,1]:=trim(armtostr(h))+' UT';
  cells[0,i]:=isodate(a,m,d);
  cells[1,i]:=artostr(rad2deg*ar/15);
  cells[2,i]:=detostr(rad2deg*de);
  cells[3,i]:=floattostrf(magn,ffFixed,5,1);
  cells[4,i]:=floattostrf(diam,ffFixed,6,1);
  cells[5,i]:=floattostrf(illum,ffFixed,6,2);
  cells[9,i]:=demtostr(rad2deg*az);
  cells[10,i]:=demtostr(rad2deg*ha);
  RiseSet(1,jd0,ar,de,hr,ht,hs,azr,azs,irc,c);
  case irc of
       0 : begin
           cells[6,i]:=armtostr(hr); cells[7,i]:=armtostr(ht); cells[8,i]:=armtostr(hs);
           objects[6,i]:=SetObjCoord(jda+(hr-c.timezone-h)/24,ar,de);
           objects[7,i]:=SetObjCoord(jda+(ht-c.timezone-h)/24,ar,de);
           objects[8,i]:=SetObjCoord(jda+(hs-c.timezone-h)/24,ar,de);
           end;
       1 : begin
           cells[6,i]:='-'; cells[7,i]:=armtostr(ht); cells[8,i]:='-';
           objects[7,i]:=SetObjCoord(jda+(ht-c.timezone-h)/24,ar,de);
           objects[6,i]:=nil;
           objects[8,i]:=nil;
           end;
       2 : begin
           cells[6,i]:='-'; cells[7,i]:='-'; cells[8,i]:='-';
           objects[6,i]:=nil;
           objects[7,i]:=nil;
           objects[8,i]:=nil;
           end;
  end;
 end;
 5 : with Jupitergrid do begin
  planet.Planet(ipla,jda+jdt_ut,ar,de,dist,illum,phase,diam,magn,dp);
  precession(jd2000,c.jdchart,ar,de);
  if c.PlanetParalaxe then Paralaxe(st0,dist,ar,de,ar,de,q,c);
  if c.ApparentPos then apparent_equatorial(ar,de,c);
  ar:=rmod(ar+pi2,pi2);
  objects[0,i]:=SetObjCoord(jda,ar,de);
  Eq2Hz((st0-ar),de,az,ha,c);
  az:=rmod(az+pi,pi2);
  RowCount:=i+1;
  cells[0,0]:=pla[ipla];
  cells[1,0]:=trim(c.EquinoxName)+' '+appmsg[46];
  cells[0,1]:=trim(armtostr(h))+' UT';
  cells[0,i]:=isodate(a,m,d);
  cells[1,i]:=artostr(rad2deg*ar/15);
  cells[2,i]:=detostr(rad2deg*de);
  cells[3,i]:=floattostrf(magn,ffFixed,5,1);
  cells[4,i]:=floattostrf(diam,ffFixed,6,1);
  cells[5,i]:=floattostrf(illum,ffFixed,6,2);
  cells[9,i]:=demtostr(rad2deg*az);
  cells[10,i]:=demtostr(rad2deg*ha);
  RiseSet(1,jd0,ar,de,hr,ht,hs,azr,azs,irc,c);
  case irc of
       0 : begin
           cells[6,i]:=armtostr(hr); cells[7,i]:=armtostr(ht); cells[8,i]:=armtostr(hs);
           objects[6,i]:=SetObjCoord(jda+(hr-c.timezone-h)/24,ar,de);
           objects[7,i]:=SetObjCoord(jda+(ht-c.timezone-h)/24,ar,de);
           objects[8,i]:=SetObjCoord(jda+(hs-c.timezone-h)/24,ar,de);
           end;
       1 : begin
           cells[6,i]:='-'; cells[7,i]:=armtostr(ht); cells[8,i]:='-';
           objects[7,i]:=SetObjCoord(jda+(ht-c.timezone-h)/24,ar,de);
           objects[6,i]:=nil;
           objects[8,i]:=nil;
           end;
       2 : begin
           cells[6,i]:='-'; cells[7,i]:='-'; cells[8,i]:='-';
           objects[6,i]:=nil;
           objects[7,i]:=nil;
           objects[8,i]:=nil;
           end;
  end;
 end;
 6 : with Saturnegrid do begin
  planet.Planet(ipla,jda+jdt_ut,ar,de,dist,illum,phase,diam,magn,dp);
  precession(jd2000,c.jdchart,ar,de);
  if c.PlanetParalaxe then Paralaxe(st0,dist,ar,de,ar,de,q,c);
  if c.ApparentPos then apparent_equatorial(ar,de,c);
  ar:=rmod(ar+pi2,pi2);
  objects[0,i]:=SetObjCoord(jda,ar,de);
  Eq2Hz((st0-ar),de,az,ha,c);
  az:=rmod(az+pi,pi2);
  RowCount:=i+1;
  cells[0,0]:=pla[ipla];
  cells[1,0]:=trim(c.EquinoxName)+' '+appmsg[46];
  cells[0,1]:=trim(armtostr(h))+' UT';
  cells[0,i]:=isodate(a,m,d);
  cells[1,i]:=artostr(rad2deg*ar/15);
  cells[2,i]:=detostr(rad2deg*de);
  cells[3,i]:=floattostrf(magn,ffFixed,5,1);
  cells[4,i]:=floattostrf(diam,ffFixed,6,1);
  cells[5,i]:=floattostrf(illum,ffFixed,6,2);
  cells[9,i]:=demtostr(rad2deg*az);
  cells[10,i]:=demtostr(rad2deg*ha);
  RiseSet(1,jd0,ar,de,hr,ht,hs,azr,azs,irc,c);
  case irc of
       0 : begin
           cells[6,i]:=armtostr(hr); cells[7,i]:=armtostr(ht); cells[8,i]:=armtostr(hs);
           objects[6,i]:=SetObjCoord(jda+(hr-c.timezone-h)/24,ar,de);
           objects[7,i]:=SetObjCoord(jda+(ht-c.timezone-h)/24,ar,de);
           objects[8,i]:=SetObjCoord(jda+(hs-c.timezone-h)/24,ar,de);
           end;
       1 : begin
           cells[6,i]:='-'; cells[7,i]:=armtostr(ht); cells[8,i]:='-';
           objects[7,i]:=SetObjCoord(jda+(ht-c.timezone-h)/24,ar,de);
           objects[6,i]:=nil;
           objects[8,i]:=nil;
           end;
       2 : begin
           cells[6,i]:='-'; cells[7,i]:='-'; cells[8,i]:='-';
           objects[6,i]:=nil;
           objects[7,i]:=nil;
           objects[8,i]:=nil;
           end;
  end;
 end;
 7 : with Uranusgrid do begin
  planet.Planet(ipla,jda+jdt_ut,ar,de,dist,illum,phase,diam,magn,dp);
  precession(jd2000,c.jdchart,ar,de);
  if c.PlanetParalaxe then Paralaxe(st0,dist,ar,de,ar,de,q,c);
  if c.ApparentPos then apparent_equatorial(ar,de,c);
  ar:=rmod(ar+pi2,pi2);
  objects[0,i]:=SetObjCoord(jda,ar,de);
  Eq2Hz((st0-ar),de,az,ha,c);
  az:=rmod(az+pi,pi2);
  RowCount:=i+1;
  cells[0,0]:=pla[ipla];
  cells[1,0]:=trim(c.EquinoxName)+' '+appmsg[46];
  cells[0,1]:=trim(armtostr(h))+' UT';
  cells[0,i]:=isodate(a,m,d);
  cells[1,i]:=artostr(rad2deg*ar/15);
  cells[2,i]:=detostr(rad2deg*de);
  cells[3,i]:=floattostrf(magn,ffFixed,5,1);
  cells[4,i]:=floattostrf(diam,ffFixed,6,1);
  cells[5,i]:=floattostrf(illum,ffFixed,6,2);
  cells[9,i]:=demtostr(rad2deg*az);
  cells[10,i]:=demtostr(rad2deg*ha);
  RiseSet(1,jd0,ar,de,hr,ht,hs,azr,azs,irc,c);
  case irc of
       0 : begin
           cells[6,i]:=armtostr(hr); cells[7,i]:=armtostr(ht); cells[8,i]:=armtostr(hs);
           objects[6,i]:=SetObjCoord(jda+(hr-c.timezone-h)/24,ar,de);
           objects[7,i]:=SetObjCoord(jda+(ht-c.timezone-h)/24,ar,de);
           objects[8,i]:=SetObjCoord(jda+(hs-c.timezone-h)/24,ar,de);
           end;
       1 : begin
           cells[6,i]:='-'; cells[7,i]:=armtostr(ht); cells[8,i]:='-';
           objects[7,i]:=SetObjCoord(jda+(ht-c.timezone-h)/24,ar,de);
           objects[6,i]:=nil;
           objects[8,i]:=nil;
           end;
       2 : begin
           cells[6,i]:='-'; cells[7,i]:='-'; cells[8,i]:='-';
           objects[6,i]:=nil;
           objects[7,i]:=nil;
           objects[8,i]:=nil;
           end;
  end;
 end;
 8 : with Neptunegrid do begin
  planet.Planet(ipla,jda+jdt_ut,ar,de,dist,illum,phase,diam,magn,dp);
  precession(jd2000,c.jdchart,ar,de);
  if c.PlanetParalaxe then Paralaxe(st0,dist,ar,de,ar,de,q,c);
  if c.ApparentPos then apparent_equatorial(ar,de,c);
  ar:=rmod(ar+pi2,pi2);
  objects[0,i]:=SetObjCoord(jda,ar,de);
  Eq2Hz((st0-ar),de,az,ha,c);
  az:=rmod(az+pi,pi2);
  RowCount:=i+1;
  cells[0,0]:=pla[ipla];
  cells[1,0]:=trim(c.EquinoxName)+' '+appmsg[46];
  cells[0,1]:=trim(armtostr(h))+' UT';
  cells[0,i]:=isodate(a,m,d);
  cells[1,i]:=artostr(rad2deg*ar/15);
  cells[2,i]:=detostr(rad2deg*de);
  cells[3,i]:=floattostrf(magn,ffFixed,5,1);
  cells[4,i]:=floattostrf(diam,ffFixed,6,1);
  cells[5,i]:=floattostrf(illum,ffFixed,6,2);
  cells[9,i]:=demtostr(rad2deg*az);
  cells[10,i]:=demtostr(rad2deg*ha);
  RiseSet(1,jd0,ar,de,hr,ht,hs,azr,azs,irc,c);
  case irc of
       0 : begin
           cells[6,i]:=armtostr(hr); cells[7,i]:=armtostr(ht); cells[8,i]:=armtostr(hs);
           objects[6,i]:=SetObjCoord(jda+(hr-c.timezone-h)/24,ar,de);
           objects[7,i]:=SetObjCoord(jda+(ht-c.timezone-h)/24,ar,de);
           objects[8,i]:=SetObjCoord(jda+(hs-c.timezone-h)/24,ar,de);
           end;
       1 : begin
           cells[6,i]:='-'; cells[7,i]:=armtostr(ht); cells[8,i]:='-';
           objects[7,i]:=SetObjCoord(jda+(ht-c.timezone-h)/24,ar,de);
           objects[6,i]:=nil;
           objects[8,i]:=nil;
           end;
       2 : begin
           cells[6,i]:='-'; cells[7,i]:='-'; cells[8,i]:='-';
           objects[6,i]:=nil;
           objects[7,i]:=nil;
           objects[8,i]:=nil;
           end;
  end;
 end;
 9 : with Plutongrid do begin
  planet.Planet(ipla,jda+jdt_ut,ar,de,dist,illum,phase,diam,magn,dp);
  precession(jd2000,c.jdchart,ar,de);
  if c.PlanetParalaxe then Paralaxe(st0,dist,ar,de,ar,de,q,c);
  if c.ApparentPos then apparent_equatorial(ar,de,c);
  ar:=rmod(ar+pi2,pi2);
  objects[0,i]:=SetObjCoord(jda,ar,de);
  Eq2Hz((st0-ar),de,az,ha,c);
  az:=rmod(az+pi,pi2);
  RowCount:=i+1;
  cells[0,0]:=pla[ipla];
  cells[1,0]:=trim(c.EquinoxName)+' '+appmsg[46];
  cells[0,1]:=trim(armtostr(h))+' UT';
  cells[0,i]:=isodate(a,m,d);
  cells[1,i]:=artostr(rad2deg*ar/15);
  cells[2,i]:=detostr(rad2deg*de);
  cells[3,i]:=floattostrf(magn,ffFixed,5,1);
  cells[4,i]:=floattostrf(diam,ffFixed,6,1);
  cells[5,i]:=floattostrf(illum,ffFixed,6,2);
  cells[9,i]:=demtostr(rad2deg*az);
  cells[10,i]:=demtostr(rad2deg*ha);
  RiseSet(1,jd0,ar,de,hr,ht,hs,azr,azs,irc,c);
  case irc of
       0 : begin
           cells[6,i]:=armtostr(hr); cells[7,i]:=armtostr(ht); cells[8,i]:=armtostr(hs);
           objects[6,i]:=SetObjCoord(jda+(hr-c.timezone-h)/24,ar,de);
           objects[7,i]:=SetObjCoord(jda+(ht-c.timezone-h)/24,ar,de);
           objects[8,i]:=SetObjCoord(jda+(hs-c.timezone-h)/24,ar,de);
           end;
       1 : begin
           cells[6,i]:='-'; cells[7,i]:=armtostr(ht); cells[8,i]:='-';
           objects[7,i]:=SetObjCoord(jda+(ht-c.timezone-h)/24,ar,de);
           objects[6,i]:=nil;
           objects[8,i]:=nil;
          end;
       2 : begin
           cells[6,i]:='-'; cells[7,i]:='-'; cells[8,i]:='-';
           objects[6,i]:=nil;
           objects[7,i]:=nil;
           objects[8,i]:=nil;
           end;
  end;
 end;
10 : with Soleilgrid do begin
  Planet.Sun(jda+jdt_ut,ar,de,dist,diam);
  precession(jd2000,c.jdchart,ar,de);
  if c.PlanetParalaxe then Paralaxe(st0,dist,ar,de,ar,de,q,c);
  if c.ApparentPos then apparent_equatorial(ar,de,c);
  ar:=rmod(ar+pi2,pi2);
  objects[0,i]:=SetObjCoord(jda,ar,de);
  Eq2Hz((st0-ar),de,az,ha,c);
  az:=rmod(az+pi,pi2);
  illum:=1;
  RowCount:=i+1;
  cells[0,0]:=pla[ipla];
  cells[1,0]:=trim(c.EquinoxName)+' '+appmsg[46];
  cells[0,1]:=trim(armtostr(h))+' UT';
  cells[0,i]:=isodate(a,m,d);
  cells[1,i]:=artostr(rad2deg*ar/15);
  cells[2,i]:=detostr(rad2deg*de);
  cells[3,i]:='-';
  cells[4,i]:=floattostrf(diam,ffFixed,6,1);
  cells[5,i]:=floattostrf(illum,ffFixed,6,2);
  cells[9,i]:=demtostr(rad2deg*az);
  cells[10,i]:=demtostr(rad2deg*ha);
  RiseSet(2,jd0,ar,de,hr,ht,hs,azr,azs,irc,c);
  case irc of
       0 : begin
           cells[6,i]:=armtostr(hr); cells[7,i]:=armtostr(ht); cells[8,i]:=armtostr(hs);
           objects[6,i]:=SetObjCoord(jda+(hr-c.timezone-h)/24,ar,de);
           objects[7,i]:=SetObjCoord(jda+(ht-c.timezone-h)/24,ar,de);
           objects[8,i]:=SetObjCoord(jda+(hs-c.timezone-h)/24,ar,de);
           end;
       1 : begin
           cells[6,i]:='-'; cells[7,i]:=armtostr(ht); cells[8,i]:='-';
           objects[7,i]:=SetObjCoord(jda+(ht-c.timezone-h)/24,ar,de);
           objects[6,i]:=nil;
           objects[8,i]:=nil;
           end;
       2 : begin
           cells[6,i]:='-'; cells[7,i]:='-'; cells[8,i]:='-';
           objects[6,i]:=nil;
           objects[7,i]:=nil;
           objects[8,i]:=nil;
           end;
  end;
 end;
11 : with Lunegrid do begin
  planet.Moon(jda+jdt_ut,ar,de,dist,dkm,diam,phase,illum);
  precession(jd2000,c.jdchart,ar,de);
  if c.PlanetParalaxe then begin
     Paralaxe(st0,dist,ar,de,ar,de,q,c);
     diam:=diam/q;
  end;
  if c.ApparentPos then apparent_equatorial(ar,de,c);
  ar:=rmod(ar+pi2,pi2);
  magn:=planet.MoonMag(phase);
  objects[0,i]:=SetObjCoord(jda,ar,de);
  Eq2Hz((st0-ar),de,az,ha,c);
  az:=rmod(az+pi,pi2);
  RowCount:=i+2;
  cells[0,0]:=pla[ipla];
  cells[1,0]:=trim(c.EquinoxName)+' '+appmsg[46];
  cells[0,1]:=trim(armtostr(h))+' UT';
  cells[0,i]:=isodate(a,m,d);
  cells[1,i]:=artostr(rad2deg*ar/15);
  cells[2,i]:=detostr(rad2deg*de);
  cells[3,i]:=floattostrf(magn,ffFixed,5,1);
  cells[4,i]:=floattostrf(diam,ffFixed,6,1);
  cells[5,i]:=floattostrf(illum,ffFixed,6,2);
  cells[9,i]:=demtostr(rad2deg*az);
  cells[10,i]:=demtostr(rad2deg*ha);
  planet.Moon(jd0-c.timezone/24-1,am1,dm1,dist,dkm,diam,phase,illum);
  precession(jd2000,c.jdchart,am1,dm1);
  if (am1<0) then am1:=am1+pi2;
  planet.Moon(jd0-c.timezone/24,am2,dm2,dist,dkm,diam,phase,illum);
  precession(jd2000,c.jdchart,am2,dm2);
  if (am2<0) then am2:=am2+pi2;
  planet.Moon(jd0-c.timezone/24+1,am3,dm3,dist,dkm,diam,phase,illum);
  precession(jd2000,c.jdchart,am3,dm3);
  if (am3<0) then am3:=am3+pi2;
  RiseSetInt(3,jd0,am1,dm1,am2,dm2,am3,dm3,hr,ht,hs,azr,azs,irc,c);
  if s=1 then begin
    PlanetRiseCell(Lunegrid,i,irc,hr,ht,hs,azr,azs,jda,h,ar,de);
  end else begin
    jdcor:=0;
    mr:='   ';mt:='   ';ms:='   ';
    if hr<0 then begin mr:='d-1'; hr:=hr+24; jdcor:=-1; end;
    if hr>24 then begin mr:='d+1'; hr:=hr-24; jdcor:=1; end;
    if ht<0 then begin mt:='d-1'; ht:=ht+24; jdcor:=-1; end;
    if ht>24 then begin mt:='d+1'; ht:=ht-24; jdcor:=1; end;
    if hs<0 then begin ms:='d-1'; hs:=hs+24; jdcor:=-1; end;
    if hs>24 then begin ms:='d+1'; hs:=hs-24; jdcor:=1; end;
    case irc of
       0 : begin
           cells[6,i]:=mr+' '+armtostr(hr);
           cells[7,i]:=mt+' '+armtostr(ht);
           cells[8,i]:=ms+' '+armtostr(hs);
           objects[6,i]:=SetObjCoord(jda+jdcor+(hr-c.timezone-h)/24,ar,de);
           objects[7,i]:=SetObjCoord(jda+jdcor+(ht-c.timezone-h)/24,ar,de);
           objects[8,i]:=SetObjCoord(jda+jdcor+(hs-c.timezone-h)/24,ar,de);
           end;
       1 : begin
           cells[6,i]:='-';
           cells[7,i]:=mt+' '+armtostr(ht);
           cells[8,i]:='-';
           objects[7,i]:=SetObjCoord(jda+jdcor+(ht-c.timezone-h)/24,ar,de);
           objects[6,i]:=nil;
           objects[8,i]:=nil;
           end;
       2 : begin
           cells[6,i]:='-';
           cells[7,i]:='-';
           cells[8,i]:='-';
           objects[6,i]:=nil;
           objects[7,i]:=nil;
           objects[8,i]:=nil;
           end;
    end;
  end;
 end;    
end;
end;
jda:=jda+s;
i:=i+1;
until jda>jd2;
LuneGrid.RowCount:=LuneGrid.Rowcount-1;
finally
screen.cursor:=crDefault;
SoleilGrid.Visible:=true;
MercureGrid.Visible:=true;
VenusGrid.Visible:=true;
LuneGrid.Visible:=true;
MarsGrid.Visible:=true;
JupiterGrid.Visible:=true;
SaturneGrid.Visible:=true;
UranusGrid.Visible:=true;
NeptuneGrid.Visible:=true;
PlutonGrid.Visible:=true;
end;
end;

procedure Tf_calendar.BitBtn1Click(Sender: TObject);
var d: string;
begin
chdir(appdir);
if c.timezone=0 then d:=''
  else
   if c.timezone<0 then d:=east
     else d:=west;
caption:=title+' '+c.Obsname+' '+tz+'='+timtostr(abs(c.timezone))+' '+d;
case pagecontrol1.ActivePage.TabIndex of
     0 : RefreshTwilight;
     1 : RefreshPlanet;
     2 : RefreshComet;
     3 : RefreshAsteroid;
     4 : RefreshSolarEclipse;
     5 : RefreshLunarEclipse;
//     6 : RefreshSat;
end;
end;

procedure Tf_calendar.BitBtn2Click(Sender: TObject);
begin
Close;
end;

procedure Tf_calendar.GridMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  Column, Row: Longint;
  csc: conf_skychart;
  p : TObjCoord;
  gr : Tstringgrid;
  pathimage: string;
  a,d: double;
begin
try
gr:=Tstringgrid(sender);
gr.MouseToCell(X, Y, Column, Row);
if (row>=0)and(Column>=0) then begin
  p:=TObjCoord(gr.Objects[Column,row]);
  if p=nil then p:=TObjCoord(gr.Objects[0,row]);
  if p<>nil then begin
    if assigned(FGetChartConfig) then FGetChartConfig(csc)
                                 else csc:=c;
    csc.UseSystemTime:=false;
    csc.ObsTZ:=csc.Timezone;
    djd(p.jd+c.timezone/24,csc.CurYear,csc.CurMonth,csc.CurDay,csc.CurTime);
    if gr = solargrid then  begin      // Solar eclipse
       if (Column=1) then begin   // image map
         pathimage:=slash(Feclipsepath)+'SE'+stringreplace(gr.cells[0,row],' ','',[rfReplaceAll])+copy(gr.cells[3,row],1,1)+'.png';
         if fileexists(pathimage) then begin
            ShowImage.labeltext:=eclipanel.caption;
            ShowImage.titre:=solar.Caption+' '+inttostr(csc.CurMonth)+'/'+inttostr(csc.CurYear);
            ShowImage.LoadImage(pathimage);
            ShowImage.ClientHeight:=min(screen.Height-80,ShowImage.imageheight+ShowImage.Panel1.Height+ShowImage.HScrollBar.Height);
            ShowImage.ClientWidth:=min(screen.Width-50,ShowImage.imagewidth+ShowImage.VScrollBar.Width);
            ShowImage.image1.ZoomMin:=1;
            ShowImage.Init;
            ShowImage.Show;
         end;
         exit;
       end;
       csc.TrackOn:=true;     // set tracking to the Sun
       csc.TrackType:=1;
       csc.TrackObj:=10;
       csc.PlanetParalaxe:=true;
       csc.ShowPlanet:=true;
       if (Column=6)or(Column=7) then begin         // change location to eclipse maxima
         d:=strtofloat(copy(gr.cells[7,row],1,4));
         if copy(gr.cells[7,row],5,1)='S' then d:=-d;
         a:=strtofloat(copy(gr.cells[8,row],1,5));
         if copy(gr.cells[8,row],6,1)='E' then a:=-a;
         csc.ObsLatitude:=d;
         csc.ObsLongitude:=a;
         csc.ObsName:='Max. Solar Eclipse '+inttostr(csc.CurMonth)+'/'+inttostr(csc.CurYear);
       end;
       if assigned(Fupdchart) then Fupdchart(csc);
    end else if gr = lunargrid then begin
       csc.TrackOn:=true;         // Lunar eclipse
       csc.TrackType:=1;          // set tracking to the Moon
       csc.TrackObj:=11;
       csc.PlanetParalaxe:=true;
       csc.ShowPlanet:=true;
       csc.ShowEarthShadow:=true;
       if assigned(Fupdchart) then Fupdchart(csc);
    end else if gr = Satgrid then begin    // Satellites
           // .....
    end else begin  // other grid
       if p.ra>-900 then csc.racentre:=p.ra;
       if p.dec>-900 then csc.decentre:=p.dec
       else begin
         csc.TrackOn:=true;
         csc.TrackType:=4;
       end;
       if assigned(Fupdchart) then Fupdchart(csc);
    end;
  end; // p<>nil
end; // row>=0..
except
end;
end;

procedure Tf_calendar.PageControl1Change(Sender: TObject);
   procedure Dategroup1(onoff : boolean);
   begin
   label2.visible:=onoff;
   date2.visible:=onoff;
   end;

   procedure Dategroup2(onoff : boolean);
   begin
   label3.visible:=onoff;
   label4.visible:=onoff;
   label5.visible:=onoff;
   step.visible:=onoff;
   time.visible:=onoff;
   EcliPanel.visible:=false;
   SatPanel.visible:=false;
   Resetbtn.visible:=true;
   end;
begin
case pagecontrol1.ActivePage.TabIndex of
     0 : begin
         Dategroup1(true);
         Dategroup2(true);
         if (dat11<>date1.jd)or(dat12<>date2.jd)or(dat13<>time.time)or(dat14<>step.text) then
            RefreshTwilight;
         end;
     1 : begin
         Dategroup1(true);
         Dategroup2(true);
         if (dat21<>date1.jd)or(dat22<>date2.jd)or(dat23<>time.time)or(dat24<>step.text) then
            RefreshPlanet;
         end;
     2 : begin
         Dategroup1(true);
         Dategroup2(true);
         if (cometgrid.Cells[0,2]<>'')and((dat31<>date1.jd)or(dat32<>date2.jd)or(dat33<>time.time)or(dat34<>step.text)) then
            RefreshComet;
         end;
     3 : begin
         Dategroup1(true);
         Dategroup2(true);
         if (asteroidgrid.Cells[0,2]<>'')and((dat71<>date1.jd)or(dat72<>date2.jd)or(dat73<>time.time)or(dat74<>step.text)) then
            RefreshAsteroid;
         end;
     4 : begin
         Dategroup1(false);
         Dategroup2(false);
         EcliPanel.Visible:=true;
         if (dat41<>date1.jd) then RefreshSolarEclipse;
         end;
     5 : begin
         Dategroup1(false);
         Dategroup2(false);
         EcliPanel.Visible:=true;
         if (dat51<>date1.jd) then RefreshLunarEclipse;
         end;
     6 : begin
         Dategroup1(true);
         Dategroup2(false);
         SatPanel.Visible:=true;
         end;

end;
end;

Procedure Tf_calendar.SaveGrid(grid : tstringgrid);
var buf,d : string;
    i,j : integer;
    x : double;
begin
memo1.clear;
buf:='"'+c.ObsName+'";"';
x:=abs(c.ObsLongitude);
if c.ObsLongitude>0 then d:=east else d:=west;
buf:=buf+appmsg[32]+'='+stringreplace(copy(detostr(x),2,99),'"','""',[rfReplaceAll])+d+'";"'+appmsg[31]+'='+stringreplace(detostr(c.ObsLatitude),'"','""',[rfReplaceAll])+'";"';
x:=abs(c.TimeZone);
if c.TimeZone<0 then d:=east else d:=west;
buf:=buf+tz+'='+timtostr(x)+d+'"';
memo1.Lines.add(buf);
for i:=0 to grid.RowCount-1 do begin
  for j:=0 to grid.ColCount-1 do begin
    if j=0 then buf:= '"'+stringreplace(grid.cells[j,i],'"','""',[rfReplaceAll])
           else buf:=buf+'";"'+stringreplace(grid.cells[j,i],'"','""',[rfReplaceAll]);
  end;
  buf:=buf+'"';
  memo1.Lines.add(buf);
end;
try
Savedialog1.DefaultExt:='.csv';
Savedialog1.filter:='Tab Separated File (*.csv)|*.csv';
Savedialog1.Initialdir:=privatedir;
if SaveDialog1.Execute then
   memo1.Lines.SavetoFile(savedialog1.Filename);
finally
ChDir(appdir);
end;
memo1.clear;
end;

procedure Tf_calendar.BitBtn5Click(Sender: TObject);
begin
case pagecontrol1.ActivePage.TabIndex of
 0 : SaveGrid(TwilightGrid);
 1 : case pagecontrol2.ActivePage.TabIndex of
     0 : SaveGrid(SoleilGrid);
     1 : SaveGrid(MercureGrid);
     2 : SaveGrid(VenusGrid);
     3 : SaveGrid(LuneGrid);
     4 : SaveGrid(MarsGrid);
     5 : SaveGrid(JupiterGrid);
     6 : SaveGrid(SaturneGrid);
     7 : SaveGrid(UranusGrid);
     8 : SaveGrid(NeptuneGrid);
     9 : SaveGrid(PlutonGrid);
     end;
 2 : SaveGrid(CometGrid);
 3 : SaveGrid(AsteroidGrid);
 4 : SaveGrid(SolarGrid);
 5 : SaveGrid(LunarGrid);
 6 : SaveGrid(SatGrid);
 end;
end;

procedure Tf_calendar.Gridtoprinter(grid : tstringgrid);
var buf,d : string;
    i,j : integer;
    x : double;
begin
memo1.clear;
buf:=c.ObsName;
x:=abs(c.ObsLongitude);
if c.ObsLongitude>0 then d:=east else d:=west;
buf:=buf+blank+appmsg[32]+'='+copy(detostr(x),2,99)+d+blank+appmsg[31]+'='+detostr(c.ObsLatitude);
x:=abs(c.TimeZone);
if c.TimeZone<0 then d:=east else d:=west;
buf:=buf+blank+tz+'='+timtostr(x)+d;
memo1.Lines.add(buf);
for i:=0 to grid.RowCount-1 do begin
  for j:=0 to grid.ColCount-1 do begin
    if j=0 then buf:=grid.cells[j,i]
           else buf:=buf+blank+grid.cells[j,i];
  end;
  memo1.Lines.add(buf);
end;
printmemo(memo1);
memo1.clear;
end;

procedure Tf_calendar.BitBtn4Click(Sender: TObject);
begin
case pagecontrol1.ActivePage.TabIndex of
 0 : GridtoPrinter(TwilightGrid);
 1 : case pagecontrol2.ActivePage.TabIndex of
     0 : GridtoPrinter(SoleilGrid);
     1 : GridtoPrinter(MercureGrid);
     2 : GridtoPrinter(VenusGrid);
     3 : GridtoPrinter(LuneGrid);
     4 : GridtoPrinter(MarsGrid);
     5 : GridtoPrinter(JupiterGrid);
     6 : GridtoPrinter(SaturneGrid);
     7 : GridtoPrinter(UranusGrid);
     8 : GridtoPrinter(NeptuneGrid);
     9 : GridtoPrinter(PlutonGrid);
     end;
 2 : GridtoPrinter(CometGrid);
 3 : GridtoPrinter(AsteroidGrid);
 4 : GridtoPrinter(SolarGrid);
 5 : GridtoPrinter(LunarGrid);
 6 : GridtoPrinter(SatGrid);
 end;
end;


procedure Tf_calendar.EcliPanelClick(Sender: TObject);
begin
ExecuteFile(EcliPanel.Hint);
end;

procedure Tf_calendar.ResetBtnClick(Sender: TObject);
begin
if assigned(Fupdchart) then Fupdchart(c);
end;

Function Tf_calendar.ConnectDB(host,dbn,user,pass:string; port:integer):boolean;
begin
try
  db.SetPort(port);
  db.Connect(host,user,pass,dbn);
  result:=db.Active;
except
  result:=false;
end;
end;

procedure Tf_calendar.Button1Click(Sender: TObject);
var qry: string;
    i: integer;
begin
Combobox1.Clear;
qry:='SELECT distinct(id),name FROM cdc_com_elem where name like "%'+trim(CometFilter.Text)+'%" limit '+inttostr(maxcombo);
db.Query(qry);
if db.Rowcount>0 then
  for i:=0 to db.Rowcount-1 do begin
    cometid[i]:=db.Results[i][0];
    Combobox1.Items.Add(db.Results[i][1]);
  end;
Combobox1.ItemIndex:=0;
end;

procedure Tf_calendar.ComboBox1Change(Sender: TObject);
begin
RefreshComet;
end;

procedure Tf_calendar.RefreshComet;
var qry,id,nam,elem_id : string;
    i,a,m,d,s,nj,irc,irc2: integer;
    cjd,diff,dif,epoch: double;
    ra,dec,dist,r,elong,phase,magn,st0,q : double;
    hh,g,ap,an,ic,ec,eq,dd,da,tp,diam,lc,car,cde,rc : double;
    hr,ht,hs,azr,azs,hp1,hp2,ars,des,ds,dds,az,ha :Double;
    jda,jd0,jd1,jd2,jdt,h,st : double;
    hr1,ht1,hs1,hr2,ht2,hs2 : double;
    ra1,dec1,ra2,dec2,ra3,dec3: double;
begin
screen.cursor:=crHourGlass;
try
cjd:=(date1.JD+date2.JD)/2;
diff:=1E10;
epoch:=0;
id:=cometid[ComboBox1.itemindex];
qry:='SELECT epoch FROM cdc_com_elem where id="'+id+'"';
db.Query(qry);
if db.Rowcount>0 then
  for i:=0 to db.Rowcount-1 do begin
      dif:=abs(strtofloat(db.Results[i][0])-cjd);
      if dif<diff then begin
         epoch:=strtofloat(db.Results[i][0]);
         diff:=dif;
      end;
  end;
if Fplanet.GetComElem(id,epoch,tp,q,ec,ap,an,ic,hh,g,eq,nam,elem_id) then begin
   Fplanet.InitComet(tp,q,ec,ap,an,ic,hh,g,eq,nam);
   Cometgrid.Visible:=false;
   FreeCoord(Cometgrid);
   dat31:=date1.jd;
   dat32:=date2.jd;
   dat33:=time.time;
   dat34:=step.text;
   s:=strtoint(step.text);
   a:=date1.year;
   m:=date1.month;
   d:=date1.day;
   h:=frac(Time.time)*24-c.TimeZone;
   jd1:=jd(a,m,d,h);
   a:=date2.year;
   m:=date2.month;
   d:=date2.day;
   jd2:=jd(a,m,d,h);
   nj:=round((jd2-jd1)/s);
   if nj>maxstep then if MessageDlg(appmsg[19]+' '+inttostr(nj)+' '+appmsg[20],
       mtConfirmation,[mbOk, mbCancel], 0) <> mrOK then exit;
   jda:=jd1;
   i:=2;
   Cometgrid.cells[0,0]:=trim(nam);
   Cometgrid.cells[1,0]:=trim(c.EquinoxName)+' '+appmsg[46];
   Cometgrid.cells[0,1]:=trim(armtostr(h))+' UT';
   repeat
      djd(jda,a,m,d,h);
      jd0:=jd(a,m,d,0);
      st0:=SidTim(jd0,h,c.ObsLongitude);
      Fplanet.Comet(jda,true,ra,dec,dist,r,elong,phase,magn,diam,lc,car,cde,rc);
      precession(jd2000,c.jdchart,ra,dec);
      if c.PlanetParalaxe then Paralaxe(st0,dist,ra,dec,ra,dec,q,c);
      if c.ApparentPos then apparent_equatorial(ra,dec,c);
      ra:=rmod(ra+pi2,pi2);
      with Cometgrid do begin
         RowCount:=i+1;
         cells[0,i]:=isodate(a,m,d);
         cells[1,i]:=artostr(rad2deg*ra/15);
         cells[2,i]:=detostr(rad2deg*dec);
         cells[3,i]:=floattostrf(magn,ffFixed,5,1);
         cells[4,i]:=demtostr(rad2deg*elong);
         cells[5,i]:=demtostr(rad2deg*phase);
         objects[0,i]:=SetObjCoord(jda,ra,dec);
         RiseSet(1,jd0,ra,dec,hr1,ht1,hs1,azr,azs,irc,c);
         Fplanet.Comet(jd0+rmod((hr1-c.TimeZone)+24,24)/24,false,ra1,dec1,dist,r,elong,phase,magn,diam,lc,car,cde,rc);
         precession(jd2000,c.jdchart,ra1,dec1);
         RiseSet(1,jd0,ra1,dec1,hr,ht2,hs2,azr,azs,irc2,c);
         Fplanet.Comet(jd0+rmod((ht1-c.TimeZone)+24,24)/24,false,ra2,dec2,dist,r,elong,phase,magn,diam,lc,car,cde,rc);
         precession(jd2000,c.jdchart,ra2,dec2);
         RiseSet(1,jd0,ra2,dec2,hr2,ht,hs2,azr,azs,irc2,c);
         Fplanet.Comet(jd0+rmod((hs1-c.TimeZone)+24,24)/24,false,ra3,dec3,dist,r,elong,phase,magn,diam,lc,car,cde,rc);
         precession(jd2000,c.jdchart,ra3,dec3);
         RiseSet(1,jd0,ra3,dec3,hr2,ht2,hs,azr,azs,irc2,c);
         case irc of
          0 : begin
           cells[6,i]:=armtostr(hr);
           cells[7,i]:=armtostr(ht);
           cells[8,i]:=armtostr(hs);
           objects[6,i]:=SetObjCoord(jda+(hr-c.TimeZone-h)/24,ra1,dec1);
           objects[7,i]:=SetObjCoord(jda+(ht-c.TimeZone-h)/24,ra2,dec2);
           objects[8,i]:=SetObjCoord(jda+(hs-c.TimeZone-h)/24,ra3,dec3);
           end;
          1 : begin
           cells[6,i]:='-';
           cells[7,i]:=armtostr(ht);
           objects[7,i]:=SetObjCoord(jda+(ht-c.TimeZone-h)/24,ra2,dec2);
           cells[8,i]:='-';
           objects[6,i]:=nil;
           objects[8,i]:=nil;
           end;
          2 : begin
           cells[6,i]:='-';
           cells[7,i]:='-';
           cells[8,i]:='-';
           objects[6,i]:=nil;
           objects[7,i]:=nil;
           objects[8,i]:=nil;
           end;
         end;
         Fplanet.Sun(jda,ars,des,ds,dds);
         precession(jd2000,c.jdchart,ars,des);
         // crepuscule nautique
         Time_Alt(jd0,ars,des,-12,hp1,hp2,c);
         if hp1>-99 then begin
            jdt:=jd(a,m,d,hp1);
            Fplanet.Comet(jdt,false,ra,dec,dist,r,elong,phase,magn,diam,lc,car,cde,rc);
            precession(jd2000,c.jdchart,ra,dec);
            st := Sidtim(jd0,hp1,c.ObsLongitude);
            Eq2Hz((st-ra),dec,az,ha,c);
            az:=rmod(az+pi,pi2);
            if ha>0 then cells[10,i]:=dedtostr(rad2deg*ha)+'  '+StringReplace(dedtostr(rad2deg*az),'+','Az',[])
                    else cells[10,i]:=dedtostr(rad2deg*ha);
            objects[10,i]:=SetObjCoord(jdt,ra,dec);
         end else begin
            cells[10,i]:='-';
            objects[10,i]:=nil;
         end;
         if hp2>-99 then begin
            jdt:=jd(a,m,d,hp2);
            Fplanet.Comet(jdt,false,ra,dec,dist,r,elong,phase,magn,diam,lc,car,cde,rc);
            precession(jd2000,c.jdchart,ra,dec);
            st := Sidtim(jd0,hp2,c.ObsLongitude);
            Eq2Hz((st-ra),dec,az,ha,c);
            az:=rmod(az+pi,pi2);
            if ha>0 then cells[11,i]:=dedtostr(rad2deg*ha)+'  '+StringReplace(dedtostr(rad2deg*az),'+','Az',[])
                    else cells[11,i]:=dedtostr(rad2deg*ha);
            objects[11,i]:=SetObjCoord(jdt,ra,dec);
         end else begin
            cells[11,i]:='-';
            objects[11,i]:=nil;
         end;
         // crepuscule astro
         Time_Alt(jd0,ars,des,-18,hp1,hp2,c);
         if hp1>-99 then begin
            jdt:=jd(a,m,d,hp1);
            Fplanet.Comet(jdt,false,ra,dec,dist,r,elong,phase,magn,diam,lc,car,cde,rc);
            precession(jd2000,c.jdchart,ra,dec);
            st := Sidtim(jd0,hp1,c.ObsLongitude);
            Eq2Hz((st-ra),dec,az,ha,c);
            az:=rmod(az+pi,pi2);
            if ha>0 then cells[9,i]:=dedtostr(rad2deg*ha)+'  '+StringReplace(dedtostr(rad2deg*az),'+','Az',[])
                    else cells[9,i]:=dedtostr(rad2deg*ha);
            objects[9,i]:=SetObjCoord(jdt,ra,dec);
         end else begin
            cells[9,i]:='-';
            objects[9,i]:=nil;
         end;
         if hp2>-99 then begin
            jdt:=jd(a,m,d,hp2);
            Fplanet.Comet(jdt,false,ra,dec,dist,r,elong,phase,magn,diam,lc,car,cde,rc);
            precession(jd2000,c.jdchart,ra,dec);
            st := Sidtim(jd0,hp2,c.ObsLongitude);
            Eq2Hz((st-ra),dec,az,ha,c);
            az:=rmod(az+pi,pi2);
            if ha>0 then cells[12,i]:=dedtostr(rad2deg*ha)+'  '+StringReplace(dedtostr(rad2deg*az),'+','Az',[])
                    else cells[12,i]:=dedtostr(rad2deg*ha);
            objects[12,i]:=SetObjCoord(jdt,ra,dec);
         end else begin
            cells[12,i]:='-';
            objects[12,i]:=nil;
         end; 
      end;
      jda:=jda+s;
      i:=i+1;
   until jda>jd2;
end;
finally
Cometgrid.Visible:=true;
screen.cursor:=crDefault;
end;
end;

procedure Tf_calendar.Button2Click(Sender: TObject);
var qry: string;
    i: integer;
begin
Combobox2.Clear;
qry:='SELECT distinct(id),name FROM cdc_ast_elem where name like "%'+trim(AstFilter.Text)+'%" limit '+inttostr(maxcombo);
db.Query(qry);
if db.Rowcount>0 then
  for i:=0 to db.Rowcount-1 do begin
    astid[i]:=db.Results[i][0];
    Combobox2.Items.Add(db.Results[i][1]);
  end;
Combobox2.ItemIndex:=0;
end;

procedure Tf_calendar.ComboBox2Change(Sender: TObject);
begin
RefreshAsteroid;
end;

procedure Tf_calendar.RefreshAsteroid;
var qry,id,nam,elem_id,ref : string;
    i,a,m,d,s,nj,irc,irc2: integer;
    cjd,diff,dif,epoch: double;
    ra,dec,dist,r,elong,phase,magn,st0,q : double;
    hh,g,ma,ap,an,ic,ec,sa,eq : double;
    hr,ht,hs,azr,azs: Double;
    jda,jd0,jd1,jd2,h : double;
    hr1,ht1,hs1,hr2,ht2,hs2 : double;
    ra1,dec1,ra2,dec2,ra3,dec3: double;
begin
screen.cursor:=crHourGlass;
try
cjd:=(date1.JD+date2.JD)/2;
diff:=1E10;
epoch:=0;
id:=astid[ComboBox2.itemindex];
qry:='SELECT epoch FROM cdc_ast_elem where id="'+id+'"';
db.Query(qry);
if db.Rowcount>0 then
  for i:=0 to db.Rowcount-1 do begin
      dif:=abs(strtofloat(db.Results[i][0])-cjd);
      if dif<diff then begin
         epoch:=strtofloat(db.Results[i][0]);
         diff:=dif;
      end;
  end;
if Fplanet.GetAstElem(id,epoch,hh,g,ma,ap,an,ic,ec,sa,eq,ref,nam,elem_id) then begin
   Fplanet.InitAsteroid(epoch,hh,g,ma,ap,an,ic,ec,sa,eq,nam);
   Asteroidgrid.Visible:=false;
   FreeCoord(Asteroidgrid);
   dat71:=date1.jd;
   dat72:=date2.jd;
   dat73:=time.time;
   dat74:=step.text;
   s:=strtoint(step.text);
   a:=date1.year;
   m:=date1.month;
   d:=date1.day;
   h:=frac(Time.time)*24-c.TimeZone;
   jd1:=jd(a,m,d,h);
   a:=date2.year;
   m:=date2.month;
   d:=date2.day;
   jd2:=jd(a,m,d,h);
   nj:=round((jd2-jd1)/s);
   if nj>maxstep then if MessageDlg(appmsg[19]+' '+inttostr(nj)+' '+appmsg[20],
       mtConfirmation,[mbOk, mbCancel], 0) <> mrOK then exit;
   jda:=jd1;
   i:=2;
   Asteroidgrid.cells[0,0]:=trim(nam);
   Asteroidgrid.cells[1,0]:=trim(c.EquinoxName)+' '+appmsg[46];
   Asteroidgrid.cells[0,1]:=trim(armtostr(h))+' UT';
   repeat
      djd(jda,a,m,d,h);
      jd0:=jd(a,m,d,0);
      st0:=SidTim(jd0,h,c.ObsLongitude);
      Fplanet.Asteroid(jda,true,ra,dec,dist,r,elong,phase,magn);
      precession(jd2000,c.jdchart,ra,dec);
      if c.PlanetParalaxe then Paralaxe(st0,dist,ra,dec,ra,dec,q,c);
      if c.ApparentPos then apparent_equatorial(ra,dec,c);
      ra:=rmod(ra+pi2,pi2);
      with Asteroidgrid do begin
         RowCount:=i+1;
         cells[0,i]:=isodate(a,m,d);
         cells[1,i]:=artostr(rad2deg*ra/15);
         cells[2,i]:=detostr(rad2deg*dec);
         cells[3,i]:=floattostrf(magn,ffFixed,5,1);
         cells[4,i]:=demtostr(rad2deg*elong);
         cells[5,i]:=demtostr(rad2deg*phase);
         objects[0,i]:=SetObjCoord(jda,ra,dec);
         RiseSet(1,jd0,ra,dec,hr1,ht1,hs1,azr,azs,irc,c);
         Fplanet.Asteroid(jd0+rmod((hr1-c.TimeZone)+24,24)/24,false,ra1,dec1,dist,r,elong,phase,magn);
         precession(jd2000,c.jdchart,ra1,dec1);
         RiseSet(1,jd0,ra1,dec1,hr,ht2,hs2,azr,azs,irc2,c);
         Fplanet.Asteroid(jd0+rmod((ht1-c.TimeZone)+24,24)/24,false,ra2,dec2,dist,r,elong,phase,magn);
         precession(jd2000,c.jdchart,ra2,dec2);
         RiseSet(1,jd0,ra2,dec2,hr2,ht,hs2,azr,azs,irc2,c);
         Fplanet.Asteroid(jd0+rmod((hs1-c.TimeZone)+24,24)/24,false,ra3,dec3,dist,r,elong,phase,magn);
         precession(jd2000,c.jdchart,ra3,dec3);
         RiseSet(1,jd0,ra3,dec3,hr2,ht2,hs,azr,azs,irc2,c);
         case irc of
          0 : begin
           cells[6,i]:=armtostr(hr);
           cells[7,i]:=armtostr(ht);
           cells[8,i]:=armtostr(hs);
           objects[6,i]:=SetObjCoord(jda+(hr-c.TimeZone-h)/24,ra1,dec1);
           objects[7,i]:=SetObjCoord(jda+(ht-c.TimeZone-h)/24,ra2,dec2);
           objects[8,i]:=SetObjCoord(jda+(hs-c.TimeZone-h)/24,ra3,dec3);
           end;
          1 : begin
           cells[6,i]:='-';
           cells[7,i]:=armtostr(ht);
           objects[7,i]:=SetObjCoord(jda+(ht-c.TimeZone-h)/24,ra2,dec2);
           cells[8,i]:='-';
           objects[6,i]:=nil;
           objects[8,i]:=nil;
           end;
          2 : begin
           cells[6,i]:='-';
           cells[7,i]:='-';
           cells[8,i]:='-';
           objects[6,i]:=nil;
           objects[7,i]:=nil;
           objects[8,i]:=nil;
           end;
         end;
      end;
      jda:=jda+s;
      i:=i+1;
   until jda>jd2;
end;
finally
Asteroidgrid.Visible:=true;
screen.cursor:=crDefault;
end;
end;

procedure Tf_calendar.BitBtn3Click(Sender: TObject);
begin
HelpContents1.Execute;
end;

procedure Tf_calendar.HelpContents1Execute(Sender: TObject);
begin
ExecuteFile(slash(helpdir)+'calendar.html');
end;


