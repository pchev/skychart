unit Sky_DDE_Util;

interface

uses Windows,Forms,SysUtils,Registry,ShellApi, IniFiles;
//
Function GetSkyChartInfo : boolean;
Function StartSkyChart(param : string) : boolean;
function SkyChartRunning : boolean;

var
    skychartcaption : string ='cdc_vcl';
    cieldir : string = '';
    ciellang : string = '';
    skychartok : boolean;

const cdc = 'cdc_vcl';
  

implementation


function SkyChartRunning : boolean;
begin
result:= findwindow(nil,Pchar(skychartcaption)) <> 0 ;    // find skychart main window
end;

Function Exec(FileName, Params, DefaultDir: string): THandle;
// execute a command
var
  zFileName, zParams, zDir: array[0..255] of Char;
begin
Result := ShellExecute(Application.MainForm.Handle, nil, StrPCopy(zFileName, FileName),
                       StrPCopy(zParams, Params), StrPCopy(zDir, DefaultDir), SW_SHOWNORMAL);
end;

Function GetSkyChartInfo : boolean;
var Registry1: TRegistry;
    inifile : Tinifile;
begin
Registry1 := TRegistry.Create;         // find if skychart is installed
with Registry1 do begin                // and where to start it
  result:=Openkey('Software\Astro_PC\Ciel\Config',false);
  if result then
     if ValueExists('Language') then ciellang:=ReadString('Language'); // current language
     if ValueExists('AppDir') then cieldir:=ReadString('Appdir')   // install directory
                              else result:=false;
  CloseKey;
end;
Registry1.Free;
if ciellang<>'' then begin
   inifile:=Tinifile.create(cieldir+'\language_'+ciellang+'.ini');   // find window caption in language ini file
   if Inifile.SectionExists('main_') then begin
      skychartcaption:=inifile.ReadString('main_','title',skychartcaption);
   end;
   inifile.free;
end;
end;

Function StartSkyChart(param : string) : boolean;
begin
result := cieldir>'';
if result then begin
   Exec(cieldir+'\'+cdc+'.exe',param,cieldir);        // execute command
end;
end;

end.

