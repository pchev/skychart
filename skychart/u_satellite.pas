unit u_satellite;

{
Copyright (C) 2010 Patrick Chevalley

http://www.ap-i.net
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

{$mode objfpc}{$H+}

interface

uses u_translation, u_util, u_projection, u_constant, math, FileUtil,
  Classes, SysUtils, Dialogs;

Procedure SatelliteList(y,m,startd,endd,maglimit,tle,tmpdir,prgdir,timezone,ObsName : string; ObsLatitude,ObsLongitude,ObsAltitude,boxra1,boxra2,boxde1,boxde2:double; fullday:boolean=false; boxsearch:boolean=false);
Procedure DetailSat(jds,ObsLatitude,ObsLongitude,ObsAltitude,boxra1,boxra2,boxde1,boxde2 : double; maglimit,tle,tmpdir,prgdir,timezone,ObsName : string; boxsearch:boolean=false);
Procedure Iridium(y,mm,d,dt,timezone,tmpdir,ObsName : string; ObsLatitude,ObsLongitude,ObsAltitude: double);
Function CheckWine: boolean;
function CheckDosbox: boolean;

const
  {$ifdef mswindows}
    doscmd='cmd.exe /C';
    {$ifdef win64}
      dosbox='dosbox -exit -conf dosbox.conf';
    {$else}
      dosbox=doscmd;
    {$endif}
  {$else}
    doscmd='wine';
    dosbox='dosbox -exit -conf dosbox.conf';
  {$endif}

implementation

function CheckWine: boolean;
var cmd,buf: string;
    i,j: integer;
    r: Tstringlist;
begin
r:=Tstringlist.Create;
cmd:='wine --version';
i:=execprocess(cmd,r);
result:=(i=0);
if not result then begin
    if r.Count>0 then begin
     buf:='';
     for j:=0 to r.Count-1 do  buf:=buf+r[j];
   end else buf:='';
   ShowMessage(rsPleaseInstWine+crlf+rsIfItIsNotIns+crlf+'apt-get install wine'+crlf
     +'yum install wine'+crlf+'wine return: '+buf);
end;
r.free;
end;

function CheckDosbox: boolean;
var cmd,buf: string;
    i,j: integer;
    r: Tstringlist;
begin
r:=Tstringlist.Create;
cmd:='dosbox --version';
i:=execprocess(cmd,r);
result:=(i=0);
if not result then begin
    if r.Count>0 then begin
     buf:='';
     for j:=0 to r.Count-1 do  buf:=buf+r[j];
   end else buf:='';
   ShowMessage(rsPleaseInstDosbox+crlf+rsIfItIsNotIns+crlf+'apt-get install dosbox'
     +crlf+'yum '
       +'install dosbox'+crlf+'dosbox return: '+buf);
end;
r.free;
end;

Procedure SatelliteList(y,m,startd,endd,maglimit,tle,tmpdir,prgdir,timezone,ObsName : string; ObsLatitude,ObsLongitude,ObsAltitude,boxra1,boxra2,boxde1,boxde2:double; fullday:boolean=false; boxsearch:boolean=false);
var i : integer;
    satctl : textfile;
    buf,s1,s2,s3,curdir,dcmd : string;
    a1,a2,d1,d2,d,decentre,dummy_double : double;
const b = '          ';
begin
if isWin98 then dcmd:='command.com /C'
   else dcmd:=doscmd;
curdir:=GetCurrentDir;
buf:=slash(tmpdir)+'satlist.txt';
deletefile(buf);
try
buf:=slash(tmpdir)+'quicksat.ctl';
assignfile(satctl,buf);
rewrite(satctl);
buf:=copy(y+b,1,4)+' '+copy(m+b,1,2); // 2001  4 Year, month number
writeln(satctl,buf);
buf:=copy(startd+b,1,2)+' '+copy(endd+b,1,2);  //24 0 Start date, end date
writeln(satctl,buf);
if fullday then buf:='0 24 A'       //-0.3 +0.3   Start time, end time, "A" flag
           else buf:='-0.3 +0.3';   //-0.3 +0.3   Start time, end time, "A" flag
writeln(satctl,buf);
//46.1  -6.2  1125.  Geneve
str(ObsLatitude:8:4,s1); buf:=s1;
str(ObsLongitude:8:4,s1); buf:=buf+' '+s1;
str(ObsAltitude*3.281:6:1,s1); buf:=buf+' '+s1+' '+ObsName;
writeln(satctl,buf);
buf:=timezone+' '+'XXX 24';   //2 HEC 24 correction for UT to time zone, time zone name, 12/24 flag
writeln(satctl,buf);
buf:='2000 ';  //2000 Epoch of predicted RA, Dec
writeln(satctl,buf);
buf:=maglimit;  //6.5 Magnitude limit
writeln(satctl,buf);
buf:='5  ';  //5 Altitude cut-off value
writeln(satctl,buf);
buf:='0.2 '; //0.2 The search/step parameter value
writeln(satctl,buf);
buf:='F ';   //F True means store all elements in memory (limit 2000)
writeln(satctl,buf);
buf:='T ';   //T True means accept only the most recent elements for each object
writeln(satctl,buf);
buf:='F ';   //F True means ignore shadow test
writeln(satctl,buf);
buf:='F  99 '; //F  99 True means generate multiple prediction points, how many each way
writeln(satctl,buf);
buf:='F ';   //F True means output distance values in miles
writeln(satctl,buf);
buf:='F ';   //F True means generate a blank line before each object's prediction.
writeln(satctl,buf);
//           Up to 5 non-blank flags to select class(es) of objects
{$IFNDEF CALENDAR}
if boxsearch then begin
   buf:='RD         ';
   writeln(satctl,buf);
   a1:=boxra1; a2:=boxra2; d1:=boxde1; d2:=boxde2;
   d:=AngularDistance(15*a1,d1,15*a2,d1);
   if d<15 then begin // recherche dans un champ de 15d min.
      d:= sqrt((15-d)*(15-d)/2)/2;
      d1:=maxvalue([d1-d,-90]);
      d2:=minvalue([d2+d,90]);
      decentre:=(boxde1+boxde2)/2;
      if abs(decentre)<89 then begin
         d:=d/15/cos(degtorad(decentre));
         a1:=a1-d;
         a2:=a2+d;
      end;
   end;
   artostr2(a1,s1,s2,s3);  buf:=s1+' '+s2;
   artostr2(a2,s1,s2,s3);  buf:=buf+' '+s1+' '+s2;
   str(d1:5:1,s1);  buf:=buf+' '+s1;
   str(d2:5:1,s1);  buf:=buf+' '+s1;
end else {$ENDIF} buf:='           ';
writeln(satctl,buf);
buf:='B   N        ';  //B   N        Output format flag, R/P option, D/C/N option, Azimuth option
writeln(satctl,buf);
buf:='quicksat.mag';  //quicksat.mag      Intrinsic magnitudes input file
writeln(satctl,buf);
buf:='none        ';  //none              Intrinsic magnitudes override file
writeln(satctl,buf);
buf:='satlist.txt';    //output.txt        Output file
writeln(satctl,buf);
s1:=tle;
i:=pos(',',s1);
if i>0 then repeat
   buf:=copy(s1,1,i-1);
   s1:=copy(s1,i+1,9999);
   writeln(satctl,buf);
   i:=pos(',',s1);
until i=0;
buf:=s1;                // visual.txt        Elements input file
writeln(satctl,buf);
buf:='EOF'; //EOF               End of input file list
writeln(satctl,buf);
Closefile(satctl);
chdir(slash(tmpdir));
exec(dcmd +' "'+slash(prgdir)+'quicksat.exe'+'" '+slash('.')+'quicksat.ctl',true);
chdir(curdir);
except
{$I-}
Closefile(satctl);
dummy_double:=ioresult;
{$I+}
chdir(curdir);
raise;
end;
end;

Procedure DetailSat(jds,ObsLatitude,ObsLongitude,ObsAltitude,boxra1,boxra2,boxde1,boxde2 : double; maglimit,tle,tmpdir,prgdir,timezone,ObsName : string; boxsearch:boolean=false);
var
    satctl : textfile;
    buf,s1,s2,s3,s4,curdir,dcmd : string;
    x1 : double;
    i1,i2,i3 : integer;
    a1,a2,d1,d2,d,decentre : double;
const b = '          ';
      dt = 0.1 ; // heures
begin
if isWin98 then dcmd:='command.com /C'
   else dcmd:=doscmd;
curdir:=GetCurrentDir;
buf:=slash(tmpdir)+'satdetail.txt';
deletefile(buf);
try
buf:=slash(tmpdir)+'quicksat.ctl';
assignfile(satctl,buf);
rewrite(satctl);
// start time
djd(jds-dt/24,i1,i2,i3,x1);
buf:=copy(inttostr(i1)+b,1,4)+' '+copy(inttostr(i2)+b,1,2); // 2001  4 Year, month number
writeln(satctl,buf);
s1:=copy(inttostr(i3)+b,1,2);
str(x1:4:1,s2);
str(x1+2*dt:4:1,s4);
{djd(jds+dt/24,i1,i2,i3,x1);
s3:=copy(inttostr(i3)+b,1,2);
str(x1:4:1,s4);}
//buf:=s1+' '+s3;          //24 0 Start date, end date
buf:=s1+' '+s1;          //24 0 Start date, end date
writeln(satctl,buf);
buf:=s2+' '+s4+' A ';  //-0.3 +0.3   Start time, end time, "A" flag
writeln(satctl,buf);
//46.1  -6.2  1125.  Geneve
//str(ObsLatitude:4:1,s1); buf:=s1;
//str(ObsLongitude:6:1,s1); buf:=buf+' '+s1;
str(ObsLatitude:8:4,s1); buf:=s1;
str(ObsLongitude:8:4,s1); buf:=buf+' '+s1;
str(ObsAltitude*3.281:6:1,s1); buf:=buf+' '+s1+' '+ObsName;
writeln(satctl,buf);
buf:=timezone+' '+'XXX 24';   //2 HEC 24 correction for UT to time zone, time zone name, 12/24 flag
writeln(satctl,buf);
buf:='2000 ';  //2000 Epoch of predicted RA, Dec
writeln(satctl,buf);
buf:=maglimit;  //6.5 Magnitude limit
writeln(satctl,buf);
buf:='5  ';  //5 Altitude cut-off value
writeln(satctl,buf);
buf:='0.2 '; //0.2 The search/step parameter value
writeln(satctl,buf);
buf:='F ';   //F True means store all elements in memory (limit 2000)
writeln(satctl,buf);
buf:='T ';   //T True means accept only the most recent elements for each object
writeln(satctl,buf);
buf:='F ';   //F True means ignore shadow test
writeln(satctl,buf);
buf:='T  99 '; //F  99 True means generate multiple prediction points, how many each way
writeln(satctl,buf);
buf:='F ';   //F True means output distance values in miles
writeln(satctl,buf);
buf:='F ';   //F True means generate a blank line before each object's prediction.
writeln(satctl,buf);
//           Up to 5 non-blank flags to select class(es) of objects
{$IFNDEF CALENDAR}
if boxsearch then begin
   buf:='RD         ';
   writeln(satctl,buf);
   a1:=boxra1; a2:=boxra2; d1:=boxde1; d2:=boxde2;
   d:=AngularDistance(15*a1,d1,15*a2,d1);
   if d<15 then begin // recherche dans un champ de 15d min.
      d:= sqrt((15-d)*(15-d)/2)/2;
      d1:=maxvalue([d1-d,-90]);
      d2:=minvalue([d2+d,90]);
      decentre:=(boxde1+boxde2)/2;
      if abs(decentre)<89 then begin
         d:=d/15/cos(degtorad(decentre));
         a1:=a1-d;
         a2:=a2+d;
      end;
   end;
   artostr2(a1,s1,s2,s3);  buf:=s1+' '+s2;
   artostr2(a2,s1,s2,s3);  buf:=buf+' '+s1+' '+s2;
   str(d1:5:1,s1);  buf:=buf+' '+s1;
   str(d2:5:1,s1);  buf:=buf+' '+s1;
end else {$ENDIF} buf:='           ';
writeln(satctl,buf);
buf:='B   N        ';  //B   N        Output format flag, R/P option, D/C/N option, Azimuth option
writeln(satctl,buf);
buf:='quicksat.mag';  //quicksat.mag      Intrinsic magnitudes input file
writeln(satctl,buf);
buf:='none        ';  //none              Intrinsic magnitudes override file
writeln(satctl,buf);
buf:='satdetail.txt';    //output.txt        Output file
writeln(satctl,buf);
s1:=tle;
i1:=pos(',',s1);
if i1>0 then repeat
   buf:=copy(s1,1,i1-1);
   s1:=copy(s1,i1+1,9999);
   writeln(satctl,buf);
   i1:=pos(',',s1);
until i1=0;
buf:=s1;                // visual.txt        Elements input file
writeln(satctl,buf);
buf:='EOF'; //EOF               End of input file list
writeln(satctl,buf);
Closefile(satctl);
chdir(slash(tmpdir));
exec(dcmd +' "'+slash(prgdir)+'quicksat.exe'+'" '+slash('.')+'quicksat.ctl',true);
chdir(curdir);
except
{$I-}
Closefile(satctl);
i1:=ioresult;
{$I+}
chdir(curdir);
raise;
end;
end;

Procedure Iridium(y,mm,d,dt,timezone,tmpdir,ObsName : string; ObsLatitude,ObsLongitude,ObsAltitude: double);
var irictl : textfile;
    buf : string;
    curdir,dcmd : string;
    i1: integer;
{$ifdef unix}
const doslf = chr(13);
{$else}
const doslf = '';
{$endif}
begin
if isWin98 then dcmd:='command.com /C'
   else dcmd:=dosbox;
curdir:=GetCurrentDir;
deletefile(slash(tmpdir)+'IRIDFLAR.OUT');
try
assignfile(irictl,slash(tmpdir)+'IRIDFLAR.CFG');
rewrite(irictl);
buf:='[IRIDFLAR]';
writeln(irictl,buf+doslf);
buf:='EphemFile=iridium.tle';
writeln(irictl,buf+doslf);
buf:='CityFile=skymap.cty';
writeln(irictl,buf+doslf);
buf:='SiteName='+Obsname;
writeln(irictl,buf+doslf);
buf:='ReportFile=iridflar.out';
writeln(irictl,buf+doslf);
buf:='StartDate='+y+'/'+mm+'/'+d;
writeln(irictl,buf+doslf);
buf:='StartTime=12:00:00';
writeln(irictl,buf+doslf);
buf:='Lat='+floattostr(Obslatitude);
writeln(irictl,buf+doslf);
buf:='Long='+floattostr(-Obslongitude);
writeln(irictl,buf+doslf);
buf:='Alt='+floattostr(Obsaltitude);
writeln(irictl,buf+doslf);
buf:='Zone='+timezone;
writeln(irictl,buf+doslf);
buf:='SearchDur='+dt;
writeln(irictl,buf+doslf);
buf:='SunAng= -6.00';
writeln(irictl,buf+doslf);
buf:='MinElev=10.00';
writeln(irictl,buf+doslf);
buf:='MaxMirror= 4.00';
writeln(irictl,buf+doslf);
buf:='DayMagLim=-6.0';
writeln(irictl,buf+doslf);
buf:='NightMagLim= 2.0';
writeln(irictl,buf+doslf);
buf:='Units=Metric';
writeln(irictl,buf+doslf);
buf:='Source=Sun';
writeln(irictl,buf+doslf);
buf:='Batch=Yes';
writeln(irictl,buf+doslf);
buf:='Brief=No';
writeln(irictl,buf+doslf);
buf:='LocalStart=Yes';
writeln(irictl,buf+doslf);
buf:='AutoDate=No';
writeln(irictl,buf+doslf);
buf:='ThreeLines=No';
writeln(irictl,buf+doslf);
buf:='Report=Yes';
writeln(irictl,buf+doslf);
Closefile(irictl);
chdir(slash(tmpdir));
exec(dcmd +' IRIDFLAR.EXE',false);
chdir(curdir);
except
{$I-}
Closefile(irictl);
i1:=ioresult;
{$I+}
chdir(curdir);
raise;
end;
end;

end.

