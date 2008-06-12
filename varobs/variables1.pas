unit variables1;

{$MODE Delphi}

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

uses
  {$ifdef win32}
    Windows, ShellAPI,
  {$endif}
  {$ifdef unix}
    unix,baseunix,unixutil,
  {$endif}
  Clipbrd, LCLIntf, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, Buttons,IniFiles, Printers,
  Menus, ExtCtrls, LResources, PrintersDlgs, Grids, EditBtn, jdcalendar, u_param;

type

  { TVarForm }

  TVarForm = class(TForm)
    DateEdit1: TDateEdit;
    PrinterSetupDialog1: TPrinterSetupDialog;
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    Exit1: TMenuItem;
    Open1: TMenuItem;
    OpenDialog1: TOpenDialog;
    Grid1: TStringGrid;
    Setting1: TMenuItem;
    Help1: TMenuItem;
    Print1: TMenuItem;
    Printersetup1: TMenuItem;
    N5: TMenuItem;
    N6: TMenuItem;
    PopupMenu1: TPopupMenu;
    Lightcurve1: TMenuItem;
    Enterobservation1: TMenuItem;
    ShowChart1: TMenuItem;
    Edit3: TMenuItem;
    Editcurrentfile1: TMenuItem;
    Editobservationfile1: TMenuItem;
    Newobservation1: TMenuItem;
    Content1: TMenuItem;
    TimePicker1: TTimePicker;
    Timer1: TTimer;
    Panel1: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    BitBtn1: TBitBtn;
    Edit1: TEdit;
    Edit2: TEdit;
    RadioGroup1: TRadioGroup;
    Edit4: TEdit;
    BitBtn3: TBitBtn;
    About1: TMenuItem;
    AAVSOTools1: TMenuItem;
    PrepareLPVBulletin1: TMenuItem;
    Createobservingplan1: TMenuItem;
    AAVSOwebpage1: TMenuItem;
    N1: TMenuItem;
    AAVSOChart1: TMenuItem;
    procedure BitBtn1Click(Sender: TObject);
    procedure DateEdit1Change(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Exit1Click(Sender: TObject);
    procedure Edit1Change(Sender: TObject);
    procedure Edit2Change(Sender: TObject);
    procedure Open1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Grid1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Setting1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Print1Click(Sender: TObject);
    procedure Printersetup1Click(Sender: TObject);
    procedure Lightcurve1Click(Sender: TObject);
    procedure ShowChart1Click(Sender: TObject);
    procedure Editcurrentfile1Click(Sender: TObject);
    procedure Editobservationfile1Click(Sender: TObject);
    procedure Newobservation1Click(Sender: TObject);
    procedure Content1Click(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure About1Click(Sender: TObject);
    procedure PrepareLPVBulletin1Click(Sender: TObject);
    procedure Createobservingplan1Click(Sender: TObject);
    procedure AAVSOwebpage1Click(Sender: TObject);
    procedure AAVSOChart1Click(Sender: TObject);
  private
    Procedure GetAppDir;
    { Private declarations }
  public
    { Public declarations }
  end;

function datef(jdt:double): string;
function Jd(annee,mois,jour :integer; Heure:double):double;
PROCEDURE Djd(jd:Double;VAR annee,mois,jour:integer; VAR Heure:double);
function words(str,sep : string; p,n : integer) : string;
function IsNumber(n : string) : boolean;
Function Slash(nom : string) : string;
Function SetDate(year,month,day : word) : Tdatetime;
Procedure GetDate(d : TDatetime; var year,month,day : word);
Function ExecuteFile(const FileName: string): integer;
Procedure FormPos(form : Tform; x,y : integer);
Function RemoveLastDot(value : string) : string;

Type
    TVarinfo = class(Tobject)
                i : array[1..13] of double;
                end;
var
  VarForm: TVarForm;

implementation

Uses detail1,SettingUnit,ObsUnit, splashunit, aavsochart ;


Procedure FreeInfo(var gr : TStringgrid);
var i : integer;
begin
with gr do
  if rowcount>=2 then
    for i:=2 to rowcount-1 do
        Objects[0,i].Free;
end;

function nextword(var buf : string) : string;
var p : integer;
begin
p:=pos(',',buf);
if p=0 then p:=length(buf)+1;
result:=copy(buf,1,p-1);
buf:=copy(buf,p+1,999);
end;

function words(str,sep : string; p,n : integer) : string;
var     i,j : Integer;
begin
result:='';
str:=trim(str);
for i:=1 to p-1 do begin
 j:=pos(' ',str);
 if j=0 then j:=length(str)+1;
 str:=trim(copy(str,j,length(str)));
end;
for i:=1 to n do begin
 j:=pos(' ',str);
 if j=0 then j:=length(str)+1;
 result:=result+trim(copy(str,1,j))+sep;
 str:=trim(copy(str,j,length(str)));
end;
end;

Procedure FormPos(form : Tform; x,y : integer);
const bot=40; //minimal distance from screen bottom
begin
with Form do begin
  left:=x;
  if left+width>Screen.Width then left:=Screen.Width-width;
  if left<0 then left:=0;
  top:=y;
  if top+height>(Screen.height-bot) then top:=Screen.height-height-bot;
  if top<0 then top:=0;
end;
end;

{$ifdef unix}
function ExecFork(cmd:string;p1:string='';p2:string='';p3:string='';p4:string='';p5:string=''):integer;
var
  parg: array[1..7] of PChar;
begin
  result := fpFork;
  if result = 0 then
  begin
    parg[1] := Pchar(cmd);
    if p1='' then parg[2]:=nil else parg[2] := PChar(p1);
    if p2='' then parg[3]:=nil else parg[3] := PChar(p2);
    if p3='' then parg[4]:=nil else parg[4] := PChar(p3);
    if p4='' then parg[5]:=nil else parg[5] := PChar(p4);
    if p5='' then parg[6]:=nil else parg[6] := PChar(p5);
    parg[7] := nil;
    if fpExecVP(cmd,PPChar(@parg[1])) = -1 then result:=99;
  end;
end;
{$endif}

Function ExecuteFile(const FileName: string): integer;
{$ifdef win32}
var
  zFileName, zParams, zDir: array[0..255] of Char;
begin
  Result := ShellExecute(Application.MainForm.Handle, nil, StrPCopy(zFileName, FileName),
                         StrPCopy(zParams, ''), StrPCopy(zDir, ''), SW_SHOWNOACTIVATE);
{$endif}
{$ifdef unix}
var cmd,p1,p2,p3,p4: string;
begin
  cmd:=trim(words(OpenFileCMD,blank,1,1));
  p1:=trim(words(OpenFileCMD,blank,2,1));
  p2:=trim(words(OpenFileCMD,blank,3,1));
  p3:=trim(words(OpenFileCMD,blank,4,1));
  p4:=trim(words(OpenFileCMD,blank,5,1));
  if p1='' then result:=ExecFork(cmd,FileName)
  else if p2='' then result:=ExecFork(cmd,p1,FileName)
  else if p3='' then result:=ExecFork(cmd,p1,p2,FileName)
  else if p4='' then result:=ExecFork(cmd,p1,p2,p3,FileName)
  else result:=ExecFork(cmd,p1,p2,p3,p4,FileName);
{$endif}
end;

function IsNumber(n : string) : boolean;
var i,dummy : integer;
begin
val(n,dummy,i);
result:= (i=0) ;
end;

Function NoSlash(nom : string) : string;
begin
result:=trim(nom);
if copy(result,length(nom),1)=PathDelim then result:=copy(result,1,length(nom)-1);
end;

Function RemoveLastDot(value : string) : string;
begin
result:=trim(value);
if copy(result,length(result),1)='.' then result:=copy(result,1,length(result)-1);
end;

Function Slash(nom : string) : string;
begin
result:=trim(nom);
if copy(result,length(nom),1)<>PathDelim then result:=result+PathDelim;
end;

function Jd(annee,mois,jour :integer; Heure:double):double;
 VAR siecle,cor:INTEGER ;
     jd1:double;
 BEGIN
    IF mois<=2 THEN
    begin
      annee:=annee-1;
      mois:=mois+12;
    end ;
    (* IF (annee>1582) OR ((annee=1582) AND ((mois*100+jour)>=1015)) THEN *)
    IF annee > 1582 THEN
    begin
       siecle:=annee DIV 100;
       cor:=2 - siecle + siecle DIV 4;
       end
        ELSE
        cor:=0;
    IF annee<0 THEN
       jd1:=Int(365.25*annee-0.75)
     ELSE
       jd1:=Int(365.25*annee);
    jd := jd1 + Int(30.6001*(mois+1)) + jour
               + 1720994.5 + cor + Heure/24.0;
 END ;

PROCEDURE Djd(jd:Double;VAR annee,mois,jour:integer; VAR Heure:double);
 VAR z,f,a,al,b,c,d,e:double;
 BEGIN
    z := Int(jd+0.5);
    f := jd + 0.5 - z ;
    IF z<2299161.0 THEN
       a := z
      ELSE
      begin
       al:= Int((z-1867216.25)/36524.25);
        a := z + 1.0 + al - Int(al/4.0);
    END;
    b := a + 1524.0;
    c := Int((b-122.1)/365.25);
    d := Int(365.25*c);
    e := Int((b-d)/30.6001);
    jour := Trunc(b-d-Int(30.6001*e)+f);
    IF e<13.5 THEN
        mois:=Trunc(e)-1
      ELSE
        mois:=Trunc(e)-13;
    IF mois>2 THEN
        annee:=Trunc(c)-4716
      ELSE
        annee:=Trunc(c)-4715;
    IF (annee MOD 4 <> 0) AND (mois=2) AND (jour=29) THEN
    begin
            mois:=3;
            jour:=1;
    END;
    Heure:=24.0*f ;
 END ;

Procedure GetDate(d : Tdatetime; var year,month,day : word);
var s : TSystemTime;
begin
   DateTimeToSystemTime(d,s);
   year:=word(s.Year);
   month:=word(s.Month);
   day:=word(s.Day);
end;

Function SetDate(year,month,day : word) : Tdatetime;
var s : TsystemTime;
begin
s.Year:=year ;
s.Month:=month ;
s.Day:=day ;
s.Hour:=0 ;
s.Minute:=0 ;
s.Second:=0 ;
// windows
//s.DayOfWeek:=0 ;
//s.Milliseconds:=0 ;
result:=SystemTimeToDateTime(s);
end;

Procedure PulsVar(jdobs,magmax,magmin,jdini,period,rise : double; var actmag,prevmini,prevmaxi,nextmini,nextmaxi,next2mini: double);
var risep : double;
begin
nextmaxi:=jdini;
if jdobs>jdini then begin
   repeat
         nextmaxi:=nextmaxi+period;
   until nextmaxi>jdobs;
end else begin
   repeat
         nextmaxi:=nextmaxi-period;
   until nextmaxi<jdobs;
   nextmaxi:=nextmaxi+period;
end;
risep:=period*rise/100;
nextmini:=nextmaxi-risep;
prevmini:=nextmini-period;
prevmaxi:=nextmaxi-period;
next2mini:=nextmini+period;
if jdobs<nextmini then
     actmag:=magmax+(jdobs-prevmaxi)*(magmin-magmax)/(period-risep)
else
     actmag:=magmin-(jdobs-nextmini)*(magmin-magmax)/risep;
end;

Procedure EcliVar(jdobs,magmax,magmin,jdini,period,rise : double; var actmag,prevmini,prev2maxi,prevmaxi,nextmini,nextmaxi,next2maxi,next2mini: double);
var risep : double;
begin
nextmini:=jdini;
if jdobs>jdini then begin
   repeat
         nextmini:=nextmini+period;
   until nextmini>jdobs;
end else begin
   repeat
         nextmini:=nextmini-period;
   until nextmini<jdobs;
   nextmini:=nextmini+period;
end;
risep:=period*rise/100/2;
prevmini:=nextmini-period;
next2mini:=nextmini+period;
nextmaxi:=nextmini+risep;
prevmaxi:=nextmini-risep;
prev2maxi:=prevmini+risep;
next2maxi:=next2mini-risep;
if (jdobs<prev2maxi) then actmag:=magmin-(jdobs-prevmini)*(magmin-magmax)/risep
else if (jdobs<prevmaxi) then actmag:=magmax
else if (jdobs<nextmini) then actmag:=magmax+(jdobs-prevmaxi)*(magmin-magmax)/risep
else if (jdobs<nextmaxi) then actmag:=magmin-(jdobs-nextmini)*(magmin-magmax)/risep
else if (jdobs<next2maxi) then actmag:=magmax
else actmag:=magmax+(jdobs-next2maxi)*(magmin-magmax)/risep;
end;

function datef(jdt:double): string;
var yy,mm,dd : integer;
    hm : double;
begin
case varform.RadioGroup1.ItemIndex of
0 : begin
    djd(jdt,yy,mm,dd,hm);
    result:=formatdatetime('yyyy-mm-dd hh:mm:ss',encodedate(yy,mm,dd)+hm/24);
    end;
1 : begin
    str(jdt:9:4,result);
    end;
2 : begin
    djd(jdt,yy,mm,dd,hm);
    str((hm/24):1:4,result);
    result:=formatdatetime('yyyymmdd',encodedate(yy,mm,dd))+copy(result,2,9);
    end;
end;
end;

Procedure Errmsg(m1,m2 : string);
begin
showmessage('Missing value for '+m1+'  '+m2);
end;

Procedure CalculVar;
var f : textfile;
  ww,buf,name,vtype,design : string;
  yy,mm,dd,r,curvtype,p : integer;
  hh,mi,ss,mss,y1,m1,d1 : word;
  magmax,magmin,jdini,period,rise,actmag,next2mini,nextmini,nextmaxi,next2maxi,prevmini,prevmaxi,prev2maxi,hm : double;
  aavsodesign,uncertain : boolean;
  varinfo : Tvarinfo;
begin
if not fileexists(planname) then begin
   Showmessage('File not found : '+planname);
   exit;
end;
FreeInfo(VarForm.Grid1);
varform.caption:='Variables Star Observer, current file : '+extractfilename(planname);
VarForm.Grid1.RowCount:=2;
VarForm.Grid1.Cells[0,0]:='Name';
VarForm.Grid1.Cells[1,0]:='Design.';
VarForm.Grid1.Cells[2,0]:='Type';
VarForm.Grid1.Cells[3,0]:='Max.';
VarForm.Grid1.Cells[4,0]:='Min.';
VarForm.Grid1.Cells[5,0]:='Actual';
VarForm.Grid1.Cells[6,0]:='Minima';
VarForm.Grid1.Cells[7,0]:='Maxima';
VarForm.Grid1.Cells[8,0]:='Minima';
VarForm.Grid1.Cells[9,0]:='Maxima';
VarForm.Grid1.Cells[10,0]:='Minima';
aavsodesign:=false;
try
r:=1;
assignfile(f,planname);
reset(f);
getdate(varform.DateEdit1.date,y1,m1,d1);
decodetime(varform.timepicker1.time,hh,mi,ss,mss);
datim:=formatdatetime('yyyy-mm-dd',varform.DateEdit1.date);
datim:=datim+'  '+formatdatetime('hh:mm',varform.timepicker1.time)+' UT';
yy:=y1 ; mm:=m1 ; dd:=d1;
hm:=hh+mi/60+ss/3600;
jdact:=jd(yy,mm,dd,hm);
datact:=datef(jdact);
repeat
uncertain:=false;
readln(f,buf);
if trim(buf)='' then continue;
if buf[1]=';' then continue;
name:=nextword(buf);
if name='ENDOFLIST' then continue;
name:=trim(words(name,'',1,1)+' '+words(name,'',2,1)+' '+words(name,'',3,1)+' '+words(name,'',4,99));
vtype:=trim(nextword(buf));
curvtype:=0;
ww:=vtype;
p:=pos('+',ww);                 // keep only first type
if p>0 then ww:=copy(ww,1,p-1);
p:=pos('/',ww);
if p>0 then ww:=copy(ww,1,p-1);
p:=pos(':',ww);
if p>0 then ww:=copy(ww,1,p-1);
ww:=trim(ww);
if pos(' '+ww+' ',pulslist)>0 then curvtype:=1;
if pos(' '+ww+' ',rotlist)>0 then curvtype:=1;
if pos(' '+ww+' ',ecllist)>0 then curvtype:=2;
ww:=trim(nextword(buf));
if ww<>'' then magmax:=strtofloat(ww)
          else begin magmax:=0; uncertain:=true; end;
ww:=trim(nextword(buf));
if ww<>'' then magmin:=strtofloat(ww)
          else begin magmin:=16; uncertain:=true; end;
ww:=trim(nextword(buf));
if ww<>'' then jdini:=strtofloat(ww)
          else begin
             curvtype:=0;
             jdini:=jdact;
          end;
ww:=trim(nextword(buf));
if ww<>'' then period:=strtofloat(ww)
          else begin
             curvtype:=0;
             period:=100;
          end;
ww:=trim(nextword(buf));
if ww<>'' then rise:=strtofloat(ww)
          else begin
               if copy(vtype,1,1)='E' then rise:=5 else rise:=50;
               uncertain:=true;
               end;
if (length(ww)=3)and(pos('.',ww)=0) then rise:=rise/10; // bizarerie du gcvs pour les EA          
if (vtype='RV') or (vtype='RVA') or (vtype='RVB') then begin  // minima for RV Tau
   jdini:=jdini+period*rise/100;                        // convert to maxima
end;
ww:=trim(nextword(buf));
if ww<>'' then design:=ww
          else design:='';
if magmax=magmin then begin magmin:=magmin+0.001; uncertain:=true; end;
next2maxi:=0; prev2maxi:=0;
case curvtype of
1 : PulsVar(jdact,magmax,magmin,jdini,period,rise,actmag,prevmini,prevmaxi,nextmini,nextmaxi,next2mini);
2 : EcliVar(jdact,magmax,magmin,jdini,period,rise,actmag,prevmini,prev2maxi,prevmaxi,nextmini,nextmaxi,next2maxi,next2mini);
else begin
     actmag:=-9999;
     prevmini:=0;
     prevmaxi:=0;
     nextmini:=0;
     nextmaxi:=0;
     next2mini:=0;
     end;
end;
varform.Grid1.RowCount:=r+1;
buf:=trim(name);
varform.Grid1.Cells[0,r]:=buf;
buf:=trim(design);
if buf<>'' then aavsodesign:=true;
varform.Grid1.Cells[1,r]:=buf;
buf:=trim(vtype);
varform.Grid1.Cells[2,r]:=buf;
str(magmax:5:2,buf);
varform.Grid1.Cells[3,r]:=buf;
str(magmin:5:2,buf);
varform.Grid1.Cells[4,r]:=buf;
varinfo := Tvarinfo.Create;
if actmag>-999 then begin
   str(actmag:2:0,buf);
   if uncertain then buf:=buf+'?';
   varform.Grid1.Cells[5,r]:=buf;
   varinfo.i[3]:=actmag;
end else begin
   varform.Grid1.Cells[5,r]:='-';
   varinfo.i[3]:=magmin;
end;
if prevmini>0 then begin
                   varform.Grid1.Cells[6,r]:=datef(prevmini);
                   varinfo.i[4]:=prevmini;
              end else begin
                  varform.Grid1.Cells[6,r]:='-';
                  varinfo.i[4]:=jdact-period;
              end;
if prev2maxi>0 then begin
                   varinfo.i[12]:=prev2maxi;
              end else begin
                   varinfo.i[12]:=0;
              end;
if prevmaxi>0 then begin
                   varform.Grid1.Cells[7,r]:=datef(prevmaxi);
                   varinfo.i[5]:=prevmaxi;
              end else begin
                   varform.Grid1.Cells[7,r]:='-';
                   varinfo.i[5]:=jdact-period/2;
              end;
if nextmini>0 then begin
                   varform.Grid1.Cells[8,r]:=datef(nextmini);
                   varinfo.i[6]:=nextmini;
              end else begin
                   varform.Grid1.Cells[8,r]:='-';
                   varinfo.i[6]:=jdact;
              end;
if nextmaxi>0 then begin
                   varform.Grid1.Cells[9,r]:=datef(nextmaxi);
                   varinfo.i[7]:=nextmaxi;
              end else begin
                   varform.Grid1.Cells[9,r]:='-';
                   varinfo.i[7]:=jdact+period/2;
              end;
if next2maxi>0 then begin
                   varinfo.i[13]:=next2maxi;
              end else begin
                   varinfo.i[13]:=0;
              end;
if next2mini>0 then begin
                    varform.Grid1.Cells[10,r]:=datef(next2mini);
                    varinfo.i[8]:=next2mini;
              end else begin
                    varform.Grid1.Cells[10,r]:='-';
                    varinfo.i[8]:=jdact+period;
              end;
varinfo.i[1]:=magmax;
varinfo.i[2]:=magmin;
varinfo.i[9]:=period;
varinfo.i[10]:=rise;
varinfo.i[11]:=curvtype;
varform.Grid1.Objects[0,r]:=varinfo;
inc(r);
until eof(f);
if aavsodesign then varform.Grid1.ColWidths[1]:=60
               else varform.Grid1.ColWidths[1]:=0;
finally
closefile(f);
end;
end;

procedure TVarForm.BitBtn1Click(Sender: TObject);
begin
CalculVar;
end;


Procedure ReadParam;
var i : integer;
    buf : string;
begin
i:=0;
while i <= param.count-1 do begin
if param[i]='-c' then begin
     inc(i);
     buf:=param[i];
     if fileexists(buf) then planname:=buf;
end
else if param[i]='-n' then begin
     NoChart:=true;
end
else if pos('.var',param[i])>0 then begin
     buf:=param[i];
     if fileexists(buf) then planname:=buf;
end;
inc(i);
end;
end;

Procedure TVarForm.GetAppDir;
var inif: TMemIniFile;
    buf: string;
{$ifdef darwin}
    i: integer;
{$endif}
{$ifdef win32}
    PIDL : PItemIDList;
    Folder : array[0..MAX_PATH] of Char;
const CSIDL_PERSONAL = $0005;
{$endif}
begin
{$ifdef darwin}
appdir:=getcurrentdir;
if not DirectoryExists(slash(appdir)+slash('const')) then begin
   appdir:=ExtractFilePath(ParamStr(0));
   i:=pos('.app/',appdir);
   if i>0 then begin
     appdir:=ExtractFilePath(copy(appdir,1,i));
   end;
end;
{$else}
appdir:=getcurrentdir;
GetDir(0,appdir);
{$endif}
privatedir:=DefaultPrivateDir;
configfile:=Defaultconfigfile;
{$ifdef unix}
appdir:=expandfilename(appdir);
privatedir:=expandfilename(PrivateDir);
configfile:=expandfilename(configfile);
{$endif}
{$ifdef win32}
SHGetSpecialFolderLocation(0, CSIDL_PERSONAL, PIDL);
SHGetPathFromIDList(PIDL, Folder);
privatedir:=slash(Folder)+privatedir;
configfile:=slash(privatedir)+configfile;
{$endif}
if not directoryexists(privatedir) then CreateDir(privatedir);
if not directoryexists(privatedir) then forcedirectories(privatedir);
if not directoryexists(privatedir) then begin
   MessageDlg('Unable to create '+privatedir,
             mtError, [mbAbort], 0);
   Halt;
end;
if not directoryexists(slash(privatedir)+'quicklook') then CreateDir(slash(privatedir)+'quicklook');
if not directoryexists(slash(privatedir)+'afoevdata') then CreateDir(slash(privatedir)+'afoevdata');
{$ifdef unix}  // allow a shared install
if (not directoryexists(slash(appdir)+'const')) and
   (directoryexists(SharedDir)) then
   appdir:=SharedDir;
{$endif}
end;

procedure TVarForm.FormCreate(Sender: TObject);
begin
lockdate := false;
lockselect := false;
started := false;
StartedByVarobs := false;
NoChart := false;
param:=Tstringlist.Create;
GetAppDir;
decimalseparator:='.';
DateSeparator:='-';
ShortdateFormat:='yyyy-mm-dd';
Grid1.ColWidths[0]:=60;
Grid1.ColWidths[1]:=60;
Grid1.ColWidths[2]:=45;
Grid1.ColWidths[3]:=35;
Grid1.ColWidths[4]:=35;
Grid1.ColWidths[5]:=30;
end;

procedure TVarForm.Exit1Click(Sender: TObject);
begin
VarForm.close;
end;

procedure TVarForm.Edit1Change(Sender: TObject);
var
    yy,mm,dd :integer;
    hm : double;
    buf1,buf : string;
begin
if lockdate then begin lockdate:=false; exit; end;
try
djd(strtofloat(edit1.text),yy,mm,dd,hm);
if (yy>1) and (yy<9999) then begin
edit1.color:=clWindow;
lockdate:=true;
DateEdit1.date:=setdate(yy,mm,dd);
lockdate:=true;
varform.timepicker1.time:=hm/24;
buf1:=format('%.4d%.2d%.2d',[yy,mm,dd]);
str(frac(varform.timepicker1.time):1:4,buf);
lockdate:=true;
edit2.text:=buf1+copy(buf,2,9);
edit2.color:=clWindow;
end else begin
  edit1.color:=clRed;
end;
except
  edit1.color:=clRed;
end;
Application.processmessages;
lockdate:=false;
end;

procedure TVarForm.Edit2Change(Sender: TObject);
var
    yy,mm,dd,p :integer;
    hm : double;
    buf : string;
begin
if lockdate then begin lockdate:=false; exit; end;
try
buf:=trim(edit2.text);
p:=pos('.',buf);
if p=0 then p:=length(buf);
if p<5 then begin edit2.color:=clRed; exit; end;
yy:=strtoint(copy(buf,1,p-5));
mm:=strtoint(copy(buf,p-4,2));
dd:=strtoint(copy(buf,p-2,2));
hm:=strtofloat(copy(buf,p,9))*24;
if (yy>1) and (yy<9999) then begin
edit2.color:=clWindow;
lockdate:=true;
DateEdit1.date:=setdate(yy,mm,dd);
lockdate:=true;
varform.timepicker1.time:=hm/24;
str(jd(yy,mm,dd,hm):9:4,buf);
lockdate:=true;
edit1.text:=buf;
end else begin
  edit2.color:=clRed;
end;
except
  edit2.color:=clRed;
end;
Application.processmessages;
lockdate:=false;
end;

procedure TVarForm.Open1Click(Sender: TObject);
begin
try
opendialog1.FilterIndex:=2;
if opendialog1.execute then begin
   planname:=opendialog1.FileName;
   varform.caption:='Variables Star Observer, current file : '+planname;
   chdir(appdir);
   CalculVar;
end;
finally
chdir(appdir);
end;
end;

procedure TVarForm.FormShow(Sender: TObject);
var  inifile : Tinifile;
     section : string;
     year,month,day : word;
     i : integer;
begin
timepicker1.time:=now;
decodedate(now,year,month,day);
DateEdit1.date:=now;
planname:=slash(privatedir)+'aavsoeasy.dat';
//if not fileexists(planname) then CopyFile(pchar(slash(appdir)+'aavsoeasy.dat'),pchar(planname),true);
qlurl:='http://www.aavso.org/cgi-bin/newql.pl?name=$$$$&output=votable';
qlinfo:='http://www.aavso.org/data/ql/';
afoevurl:='ftp://cdsarc.u-strasbg.fr/pub/afoev/';
afoevinfo:='http://cdsweb.u-strasbg.fr/afoev/english.htx';
pcobscaption:='PCObs Data Entry';
Optform.DirectoryEdit2.Text:=aavsocharturl;
inifile:=Tinifile.create(configfile);
section:='Default';
with inifile do begin
    planname:=ReadString(section,'planname',planname);
    Radiogroup1.itemindex:=ReadInteger(section,'dateformat',0);
    OptForm.Radiogroup1.itemindex:=ReadInteger(section,'obstype',0);
    OptForm.Radiogroup4.itemindex:=ReadInteger(section,'obsformat',0);
    OptForm.Radiogroup5.itemindex:=ReadInteger(section,'obspgm',0);
    OptForm.Radiogroup6.itemindex:=ReadInteger(section,'onlinedata',0);
    OptForm.FilenameEdit8.text:=ReadString(section,'pcobs','C:\pcobs\pcobs.exe');
    pcobscaption:=ReadString(section,'pcobscaption',pcobscaption);
    OptForm.FilenameEdit0.text:=ReadString(section,'faavsovis',slash(privatedir)+'aavsovis.txt');
    OptForm.FilenameEdit1.text:=ReadString(section,'faavsosum',slash(privatedir)+'aavsosum.txt');
    OptForm.FilenameEdit2.text:=ReadString(section,'fvsnet',slash(privatedir)+'vsnet.txt');
    OptForm.DirectoryEdit3.text:=ReadString(section,'dafoev',privatedir);
    OptForm.FilenameEdit4.text:=ReadString(section,'freeformat',slash(privatedir)+'freeformat.txt');
    OptForm.FilenameEdit5.text:=ReadString(section,'skychartprof',slash(privatedir)+'varobs.cdc3');
    OptForm.FilenameEdit3.text:=ReadString(section,'fobs',slash(privatedir)+'aavsovis.txt');
    OptForm.Edit1.text:=ReadString(section,'namepos','1');
    OptForm.Edit2.text:=ReadString(section,'datepos','2');
    OptForm.Edit3.text:=ReadString(section,'magpos','3');
    OptForm.Radiogroup2.itemindex:=ReadInteger(section,'datetype',1);
    OptForm.Radiogroup3.itemindex:=ReadInteger(section,'formattype',0);
    Optform.DirectoryEdit2.Text:=ReadString(section,'aavsochartdir',aavsocharturl);
    DetailForm.Checkbox1.Checked:=ReadBool(section,'followcurve',true);
    DetailForm.Checkbox2.Checked:=ReadBool(section,'plotobs',true);
    DetailForm.Checkbox3.Checked:=ReadBool(section,'owncolor',true);
    DetailForm.Checkbox4.Checked:=ReadBool(section,'plotql',false);
    DetailForm.Checkbox5.Checked:=ReadBool(section,'plotgroup',false);
    OptForm.Edit4.text:=ReadString(section,'observer','');
    DetailForm.Shape1.Brush.Color:=ReadInteger(section,'color1',clBlack);
    DetailForm.Shape2.Brush.Color:=ReadInteger(section,'color2',clWhite);
    DetailForm.Shape3.Brush.Color:=ReadInteger(section,'color3',clRed);
    DetailForm.Shape4.Brush.Color:=ReadInteger(section,'color4',clAqua);
    DetailForm.Shape5.Brush.Color:=ReadInteger(section,'color5',clRed);
    DetailForm.Shape6.Brush.Color:=ReadInteger(section,'color6',clLime);
    DetailForm.Shape7.Brush.Color:=ReadInteger(section,'color7',clYellow);
    DetailForm.Shape8.Brush.Color:=ReadInteger(section,'color8',clBlue);
    DetailForm.Shape9.Brush.Color:=ReadInteger(section,'color9',clGreen);
    DetailForm.Shape10.Brush.Color:=ReadInteger(section,'color10',clTeal);
    Varform.top:=ReadInteger(section,'formtop',Varform.top);
    Varform.left:=ReadInteger(section,'formleft',Varform.left);
    Varform.width:=ReadInteger(section,'formwidth',Varform.width);
    Varform.height:=ReadInteger(section,'formheight',Varform.height);
end;
inifile.free;
detail1.savecheckbox1:=Detailform.checkbox1.checked;
param.clear;
if paramcount>0 then begin
     for i:=1 to paramcount do param.Add(paramstr(i));
     ReadParam;
end;
//ShowChart1.Enabled:=(not NoChart)and GetSkyChartInfo;  // initialize skychart value
started:=true;
DateEdit1change(sender);
CalculVar;
end;

procedure TVarForm.Grid1MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var Acol,Arow : integer;
begin
if not started then exit;
Grid1.MouseToCell(X,Y,Acol,Arow);
if (Arow=0)and(Acol>=0) then begin
   grid1.StrictSort:=true;
   Grid1.SortColRow(true,Acol);
   Grid1.TopRow:=1;
end;
if (Arow<=0)or(trim(Grid1.cells[0,arow])='') then exit;
case button of
mbLeft  : begin
          CurrentRow:=Arow;
          Detail1.current:=ARow;
          FormPos(DetailForm,mouse.cursorpos.x,mouse.cursorpos.y);
          DetailForm.ShowModal;
          end;
mbRight : begin
          CurrentRow:=Arow;
          popupmenu1.popup(mouse.cursorpos.x,mouse.cursorpos.y);
          end;
end;
end;

procedure TVarForm.Setting1Click(Sender: TObject);
begin
FormPos(OptForm,mouse.cursorpos.x,mouse.cursorpos.y);
OptForm.showmodal;
chdir(appdir);
end;

procedure TVarForm.FormClose(Sender: TObject; var Action: TCloseAction);
var  inifile : Tinifile;
     section : string;
begin
inifile:=Tinifile.create(configfile);
section:='Default';
with inifile do begin
    WriteString(section,'planname',planname);
    WriteInteger(section,'dateformat',Radiogroup1.itemindex);
    WriteInteger(section,'obstype',OptForm.Radiogroup1.itemindex);
    WriteInteger(section,'obsformat',OptForm.Radiogroup4.itemindex);
    WriteInteger(section,'obspgm',OptForm.Radiogroup5.itemindex);
    WriteInteger(section,'onlinedata',OptForm.Radiogroup6.itemindex);
    WriteString(section,'pcobs',OptForm.FilenameEdit8.text);
    WriteString(section,'pcobscaption',pcobscaption);
    WriteString(section,'faavsovis',OptForm.FilenameEdit0.text);
    WriteString(section,'faavsosum',OptForm.FilenameEdit1.text);
    WriteString(section,'fvsnet',OptForm.FilenameEdit2.text);
    WriteString(section,'dafoev',OptForm.DirectoryEdit3.text);
    WriteString(section,'freeformat',OptForm.FilenameEdit4.text);
    WriteString(section,'fobs',OptForm.FilenameEdit3.text);
    WriteString(section,'skychartprof',OptForm.FilenameEdit5.text);
    WriteString(section,'namepos',OptForm.Edit1.text);
    WriteString(section,'datepos',OptForm.Edit2.text);
    WriteString(section,'magpos',OptForm.Edit3.text);
    WriteInteger(section,'datetype',OptForm.Radiogroup2.itemindex);
    WriteInteger(section,'formattype',OptForm.Radiogroup3.itemindex);
    WriteString(section,'aavsochartdir',Optform.DirectoryEdit2.Text);
    WriteBool(section,'followcurve',Detail1.SaveCheckbox1);
    WriteBool(section,'plotobs',DetailForm.Checkbox2.Checked);
    WriteBool(section,'owncolor',DetailForm.Checkbox3.Checked);
    WriteBool(section,'plotql',DetailForm.Checkbox4.Checked);
    WriteBool(section,'plotgroup',DetailForm.Checkbox5.Checked);
    WriteString(section,'observer',OptForm.Edit4.text);
    WriteInteger(section,'color1',DetailForm.Shape1.Brush.Color);
    WriteInteger(section,'color2',DetailForm.Shape2.Brush.Color);
    WriteInteger(section,'color3',DetailForm.Shape3.Brush.Color);
    WriteInteger(section,'color4',DetailForm.Shape4.Brush.Color);
    WriteInteger(section,'color5',DetailForm.Shape5.Brush.Color);
    WriteInteger(section,'color6',DetailForm.Shape6.Brush.Color);
    WriteInteger(section,'color7',DetailForm.Shape7.Brush.Color);
    WriteInteger(section,'color8',DetailForm.Shape8.Brush.Color);
    WriteInteger(section,'color9',DetailForm.Shape9.Brush.Color);
    WriteInteger(section,'color10',DetailForm.Shape10.Brush.Color);
    WriteInteger(section,'formtop',Varform.top);
    WriteInteger(section,'formleft',Varform.left);
    WriteInteger(section,'formwidth',Varform.width);
    WriteInteger(section,'formheight',Varform.Height);
end;
inifile.free;
{if StartedByVarobs then PostMessage(findwindow(nil,Pchar(skychartcaption)),WM_QUIT,0,0)   // close skychart (use WM_CLOSE for close prompt)
else begin
  CielHnd:=findwindow(nil,Pchar(skychartcaption));
  SendMessage(CielHnd, WM_SYSCOMMAND, SC_MINIMIZE, 0);
end;}
end;

Procedure PrtGrid(Grid:TStringGrid; PrtTitle, PrtText, PrtTextDate:string);
 Type
  TCols=Array[0..20] of integer;
 Var
  Rapport,pw,ph,marg:Integer;
  r,c:longint;
  cols:^TCols;
  y:integer;
  MargeLeft,Margetop,MargeRight:integer;
  StrDate:String;
  TextDown:integer;
  Procedure VerticalLines;
   Var
    c:LongInt;
   begin
     With Printer.Canvas do begin
      For c:=0 to Grid.ColCount-1 do begin
       MoveTo(Cols^[c],MargeTop+TextDown);
       LineTo(Cols^[c],y);
      end;
      MoveTo(MargeRight,MargeTop+TextDown);
      LineTo(MargeRight,y);
     end;
   end;
  Procedure PrintRow(r:longint);
   Var
    c:longint;
   begin
    With Printer.Canvas do begin
     For c:=0 to Grid.ColCount-1 do TextOut(Cols^[c]+10,y+10,Grid.Cells[c,r]);
     inc(y,TextDown);
     MoveTo(MargeLeft,y); LineTo(MargeRight,y);
    end;
   end;
  Procedure Entete;
   Var
    rr:longint;
   begin
    With Printer.Canvas do begin
     Font.Style:=[fsBold];

     TextOut(MargeLeft,MargeTop,PrtText);
     TextOut(MargeRight-TextWidth(StrDate),MargeTop,StrDate);
     y:=MargeTop+TextDown;

     Brush.Color:=clSilver;
     FillRect(Classes.Rect(MargeLeft,y,MargeRight,y+TextDown*Grid.FixedRows));
     MoveTo(MargeLeft,y); LineTo(MargeRight,y);
     for rr:=0 to Grid.FixedRows-1 do PrintRow(rr);
     Brush.Color:=clWhite;

     Font.Style:=[];
    end;
   end;
 begin
  GetMem(Cols,Grid.ColCount*SizeOf(Integer));
  StrDate:=PrtTextDate+DateToStr(Date);
  With Printer do begin
   Title:=PrtTitle;
   if Orientation=poLandscape then begin
      marg:=50;
      pw:=PageHeight;
      ph:=PageWidth;
   end else begin
      marg:=25;
      pw:=PageWidth;
      ph:=PageHeight;
   end;
   MargeLeft:=pw div marg;
   MargeTop :=ph div marg;
   MargeRight:=pw-MargeLeft;
   Rapport:=(MargeRight) div Grid.GridWidth;
   BeginDoc;
   With Canvas do begin
    Font.Name:=Grid.Font.Name;
    Font.Height:=Grid.Font.Height*Rapport;
    if Font.Height=0  then Font.Height:=11*Rapport;
    Font.Color:=clBlack;
    Pen.Color:=clBlack;
    TextDown:=TextHeight(StrDate)*3 div 2;
   end;
   { calcul des Cols }
   Cols^[0]:=MargeLeft;
   For c:=1 to Grid.ColCount-1 do begin
     Cols^[c]:=round(Cols^[c-1]+Grid.ColWidths[c-1]*Rapport);
   end;
   Entete;
   For r:=Grid.FixedRows to Grid.RowCount-1 do begin
    PrintRow(r);
    if y>=(ph-MargeTop) then begin
     VerticalLines;
     NewPage;
     Entete;
    end;
   end;
   VerticalLines;
   EndDoc;
  end;
  FreeMem(Cols,Grid.ColCount*SizeOf(Integer));
 end;

procedure TVarForm.Print1Click(Sender: TObject);
begin
PrtGrid(Grid1,'varObs','Variables stars '+datim,'')
end;

procedure TVarForm.Printersetup1Click(Sender: TObject);
begin
PrinterSetupDialog1.execute;
end;

procedure TVarForm.DateEdit1Change(Sender: TObject);
var y1,m1,d1 : word;
    hm : double;
    buf,buf1 : string;
begin
if lockdate then begin lockdate:=false; exit; end;
getdate(DateEdit1.date,y1,m1,d1);
hm:=frac(timepicker1.time);
buf1:=format('%.4d%.2d%.2d',[y1,m1,d1]);
str(hm:1:4,buf);
lockdate:=true;
edit2.text:=buf1+copy(buf,2,9);
str(jd(y1,m1,d1,hm*24):9:4,buf);
lockdate:=true;
edit1.text:=buf;
edit1.color:=clWindow;
edit2.color:=clWindow;
Application.processmessages;
lockdate:=false;
end;

procedure TVarForm.Lightcurve1Click(Sender: TObject);
begin
Detail1.current:=CurrentRow;
FormPos(DetailForm,mouse.cursorpos.x,mouse.cursorpos.y);
DetailForm.ShowModal;
end;

Function InitConv : boolean;
begin
result:=false;
{varform.ddeclientconv1.CloseLink;
with VarForm do if ddeclientconv1.SetLink('ciel','DdeSkyChart') then begin   // initialize conversation
 ddeclientitem1.DdeItem:='DdeData';
 result:=true;
end;}
end;

procedure TVarForm.Timer1Timer(Sender: TObject);
begin
Timer1.Enabled:=false;                            // stop timer to avoid multiple call
{if SkyChartRunning then begin                     // is app running
   sleep(2000);                                   // a litle more time to initialize
   skychartok:=Initconv;                          // start communication
   if not skychartok then Timer1.Enabled:=true;   // if not ok restart timer
end
else Timer1.Enabled:=true;}
end;

Procedure InitSkyChart;
var param : string;
begin
{skychartok := SkyChartRunning;     // is app already running
if not SkyChartok then begin
       if trim(optform.FilenameEdit5.text)='' then param:=''
       else param:='-c '+optform.FilenameEdit5.text;
       param:=param+' -f "CAT: 4 ID:'+trim(VarForm.Grid1.Cells[0,currentrow])+'"';
       StartSkyChart(param);
       VarForm.Timer1.Enabled:=true; // wait app start
       StartedByVarobs:=true;
       end
else begin
   skychartok:=Initconv;         // otherwise start communication directely
   if not skychartok then VarForm.Timer1.Enabled:=true;  // if not ok restart timer
end;
}
end;

Procedure DrawSkyChart;
var buf : string;
begin
{InitConv;
buf := 'FIND CAT: 4 ID:'+trim(VarForm.Grid1.Cells[0,currentrow]);
CielHnd:=findwindow(nil,Pchar(skychartcaption));
SendMessage(CielHnd, WM_SYSCOMMAND, SC_RESTORE, 0);
SetForegroundWindow(CielHnd);
VarForm.ddeClientConv1.PokeData('DdeData',Pchar(buf));   // locate an object
sleep(1000);}
end;

procedure TVarForm.ShowChart1Click(Sender: TObject);
begin
{skychartok := SkyChartRunning;     // is app already running
if not skychartok then InitSkyChart;
DrawSkyChart;}
end;

procedure TVarForm.Editcurrentfile1Click(Sender: TObject);
var i : integer;
begin
i:=ExecuteFile(planname);
chdir(appdir);
if i<=32 then showmessage('Error '+inttostr(i)+'. Please verify that file "'+planname+'" exist and associate it with your favorite text editor.');
end;

procedure TVarForm.Editobservationfile1Click(Sender: TObject);
var i : integer;
begin
i:=ExecuteFile(OptForm.FilenameEdit3.text);
chdir(appdir);
if i<=32 then showmessage('Error '+inttostr(i)+'. Please verify that file "'+OptForm.FilenameEdit3.text+'" exist and associate it with your favorite text editor.');
end;

procedure RunPCObs;
{$ifdef win32}
var nom,id : string ;
    pcobshnd : Thandle;
    ok : boolean;
    i : integer;
{$endif}
begin
{$ifdef win32}
nom:=trim(varform.Grid1.Cells[0,currentrow]);
id:=trim(varform.Grid1.Cells[1,currentrow]);
if id='' then clipboard.settextbuf(pchar(nom))
         else clipboard.settextbuf(pchar(id));
pcobshnd:=findwindow(nil,Pchar(pcobscaption)) ;
ok:= pcobshnd <> 0 ;
if ok then begin
   SendMessage(pcobshnd, WM_SYSCOMMAND, SC_RESTORE, 0);
   SetForegroundWindow(pcobshnd);
end else begin
   i:=ExecuteFile(OptForm.FilenameEdit8.text);
   chdir(appdir);
   if i<=32 then showmessage('Error '+inttostr(i)+'. Please verify that PCObs program is installed at location : '+OptForm.FilenameEdit8.text);
end;
{$endif}
end;

procedure TVarForm.Newobservation1Click(Sender: TObject);
begin
case Optform.radiogroup5.itemindex of
0 : begin
    ObsUnit.current:=CurrentRow;
    FormPos(ObsForm,mouse.cursorpos.x,mouse.cursorpos.y);
    ObsForm.Showmodal;
    chdir(appdir);
    end;
1 : begin
    RunPCObs;
    end;
2: begin
    executefile('http://www.aavso.org/observing/submit/webobs.shtml');
    end;
end;
end;

procedure TVarForm.Content1Click(Sender: TObject);
begin
executefile(slash(appdir)+slash('doc')+'varobs.html');
end;

procedure TVarForm.BitBtn3Click(Sender: TObject);
var i: integer;
begin
i:=grid1.cols[0].IndexOf(edit4.text);
grid1.TopRow:=i;
end;

procedure TVarForm.About1Click(Sender: TObject);
begin
  splash := Tsplash.create(application);
  splash.SplashTimer:=false;
  splash.showmodal;
  splash.free;
end;

procedure TVarForm.PrepareLPVBulletin1Click(Sender: TObject);
begin
executefile(slash(appdir)+'bulletin.exe');
end;

procedure TVarForm.Createobservingplan1Click(Sender: TObject);
begin
executefile(slash(appdir)+'copyplan.exe');
end;

procedure TVarForm.AAVSOwebpage1Click(Sender: TObject);
begin
executefile('http://www.aavso.org');
end;

procedure TVarForm.AAVSOChart1Click(Sender: TObject);
var i : integer;
    buf,id, chartlist: string;
    f: textfile;
begin
if (pos('://',Optform.DirectoryEdit2.Text)=0) then begin
  chartlist:='';
  chdir(appdir);
  assignfile(f,slash(appdir)+'united.txt');
  reset(f);
  try
  repeat
    readln(f,buf);
    i:=pos('#',buf);
    id:=trim(copy(buf,1,i-1));
    if id=VarForm.Grid1.Cells[1,currentrow] then begin
       i:=lastdelimiter('#',buf);
       chartlist:=trim(copy(buf,i+1,9999));
       break;
    end;
  until eof(f);
  finally
  closefile(f);
  end;
  chartform.chartlist:=chartlist;
end;
chartform.starname:=VarForm.Grid1.Cells[0,currentrow];
chartform.chartdir:=Optform.DirectoryEdit2.Text;
FormPos(chartform,mouse.cursorpos.x,mouse.cursorpos.y);
chartform.ShowModal;
end;

initialization
  {$i variables1.lrs}

end.
