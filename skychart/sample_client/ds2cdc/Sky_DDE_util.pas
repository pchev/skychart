unit Sky_DDE_Util;

{
   This software is free of any right.
   It can be used or modified as you want at your sole responsibility.

   Program author : Patrick Chevalley
                    Switzerland
                    pch@ap-i.net
}

{$mode objfpc}{$H+}
//{$define trace_debug}

interface

uses Windows,SysUtils,Registry,ShellApi, shlobj, shfolder, IniFiles;
//
Procedure InitTrace;
Procedure WriteTrace(msg: string);
Function GetSkyChartInfo : boolean;
Procedure GetWorkDir;
Function StartSkyChart(param : string) : boolean;
Function StartVarobs(param : string) : boolean;
function SkyChartRunning : boolean;
Function ARToStr(ar: Double) : string;
Function DEToStr(de: Double) : string;
Function sgn(x:Double):Double ;
Function DEToStr2(de: Double) : string;  

var
    skychartcaption : string ='Skychart';
    cieldir : string = '';
    vardir : string = '';
    ciellang : string = '';
    privatedir, workdir: string;
    skychartok : boolean;
    tracefile: string ='C:\ds2cdc_trace.txt';

const
    dateiso='yyyy"-"mm"-"dd"T"hh":"nn":"ss.zzz';

implementation

Procedure InitTrace;
var f: textfile;
begin
Filemode:=2;
assignfile(f,tracefile);
rewrite(f);
writeln(f,FormatDateTime(dateiso,Now)+'  Start trace');
closefile(f);
end;

Procedure WriteTrace(msg: string);
var f: textfile;
begin
 Filemode:=2;
 assignfile(f,tracefile);
 append(f);
 writeln(f,FormatDateTime(dateiso,Now)+'  '+msg);
 closefile(f);
end;

function SkyChartRunning : boolean;
begin
result:= findwindow(nil,Pchar(skychartcaption)) <> 0 ;    // find skychart main window
end;

Function Exec(FileName, Params, DefaultDir: string): THandle;
// execute a command
var
  zFileName, zParams, zDir: array[0..255] of Char;
begin
Result := ShellExecute(0, nil, StrPCopy(zFileName, FileName),StrPCopy(zParams, Params), StrPCopy(zDir, DefaultDir), SW_SHOWNORMAL);
end;

Function Slash(nom : string) : string;
begin
result:=trim(nom);
if copy(result,length(nom),1)<>PathDelim then result:=result+PathDelim;
end;

Function GetSkyChartInfo : boolean;
var Registry1: TRegistry;
    inifile : Tinifile;
begin
cieldir:='';
Registry1 := TRegistry.Create;         // find if skychart is installed
with Registry1 do begin                // and where to start it
  if Openkey('Software\Astro_PC\Ciel\Config',false) then
     if ValueExists('AppDir') then cieldir:=ReadString('Appdir');   // install directory
  if Openkey('Software\Astro_PC\Ciel',false) then
     if ValueExists('Install_Dir') then cieldir:=ReadString('Install_Dir');   // install directory
  CloseKey;
end;
Registry1.Free;
vardir:=cieldir;
result:=(cieldir<>'');
end;

Function StartSkyChart(param : string) : boolean;
begin
result := cieldir>'';
if result then begin
   {$ifdef trace_debug}
   writetrace('Exec '+cieldir+'\skychart.exe '+param);
   {$endif}
   Exec(cieldir+'\skychart.exe',param,cieldir);        // execute command
end;
end;

Function StartVarobs(param : string) : boolean;
begin
result := vardir>'';
if result then begin
   Exec(vardir+'\varobs.exe',param,vardir);        // execute command
end;
end;

Procedure GetWorkDir;
var
  buf: string;
  PIDL : PITEMIDLIST;
  Folder : array[0..MAX_PATH] of Char;
begin
buf:='';
SHGetSpecialFolderLocation(0, CSIDL_LOCAL_APPDATA, PIDL);
SHGetPathFromIDList(PIDL, Folder);
buf:=Folder;
buf:=trim(buf);
if buf='' then begin  // old windows version
   SHGetSpecialFolderLocation(0, CSIDL_APPDATA, PIDL);
   SHGetPathFromIDList(PIDL, Folder);
   buf:=trim(Folder);
end;
privatedir:=slash(buf)+'Skychart';
workdir:=slash(privatedir)+'ds2000';
if not directoryexists(privatedir) then CreateDir(privatedir);
if not directoryexists(privatedir) then forcedirectories(privatedir);
if not directoryexists(workdir) then CreateDir(workdir);
if not directoryexists(workdir) then forcedirectories(workdir);
end;

Function sgn(x:Double):Double ;
begin
if x<0 then
   sgn:= -1
else
   sgn:=  1 ;
end ;

Function ARToStr(ar: Double) : string;
var dd,min1,min,sec: Double;
    d,m,s : string;
begin
    dd:=Int(ar);
    min1:=abs(ar-dd)*60;
    if min1>=59.999 then begin
       dd:=dd+sgn(ar);
       min1:=0.0;
    end;
    min:=Int(min1);
    sec:=(min1-min)*60;
    if sec>=59.95 then begin
       min:=min+1;
       sec:=0.0;
    end;
    str(dd:3:0,d);
    str(min:2:0,m);
    if abs(min)<10 then m:='0'+trim(m);
    str(sec:4:1,s);
    if abs(sec)<9.95 then s:='0'+trim(s);
    result := d+'h'+m+'m'+s+'s';
end;

Function DEToStr(de: Double) : string;
var dd,min1,min,sec: Double;
    d,m,s : string;
begin
    dd:=Int(de);
    min1:=abs(de-dd)*60;
    if min1>=59.99 then begin
       dd:=dd+sgn(de);
       min1:=0.0;
    end;
    min:=Int(min1);
    sec:=(min1-min)*60;
    if sec>=59.5 then begin
       min:=min+1;
       sec:=0.0;
    end;
    str(abs(dd):2:0,d);
    if abs(dd)<10 then d:='0'+trim(d);
    if de<0 then d:='-'+d else d:='+'+d;
    str(min:2:0,m);
    if abs(min)<10 then m:='0'+trim(m);
    str(sec:2:0,s);
    if abs(sec)<9.5 then s:='0'+trim(s);
    result := d+'°'+m+chr(39)+s+'"';
end;

Function DEToStr2(de: Double) : string;  // command line compatibility
var dd,min1,min,sec: Double;
    d,m,s : string;
begin
    dd:=Int(de);
    min1:=abs(de-dd)*60;
    if min1>=59.99 then begin
       dd:=dd+sgn(de);
       min1:=0.0;
    end;
    min:=Int(min1);
    sec:=(min1-min)*60;
    if sec>=59.5 then begin
       min:=min+1;
       sec:=0.0;
    end;
    str(abs(dd):2:0,d);
    if abs(dd)<10 then d:='0'+trim(d);
    if de<0 then d:='-'+d else d:='+'+d;
    str(min:2:0,m);
    if abs(min)<10 then m:='0'+trim(m);
    str(sec:2:0,s);
    if abs(sec)<9.5 then s:='0'+trim(s);
    result := d+'d'+m+'m'+s+'s';
end;

end.

