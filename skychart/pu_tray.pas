unit pu_tray;

{$mode objfpc}{$H+}

interface

uses
{$ifdef win32}
  windows,
{$endif}
  u_util, u_constant, Inifiles, u_help,
  Classes, SysUtils, FileUtil, LResources, Forms, Controls, Graphics, Dialogs,
  Menus, ExtCtrls, StdCtrls;

type

  { Tf_tray }

  Tf_tray = class(TForm)
    Button1: TButton;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    MenuItem4: TMenuItem;
    MenuItem5: TMenuItem;
    PopupMenu1: TPopupMenu;
    SysTray: TTrayIcon;
    Timer1: TTimer;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure MenuItem1Click(Sender: TObject);
    procedure MenuItem2Click(Sender: TObject);
    procedure MenuItem3Click(Sender: TObject);
    procedure MenuItem5Click(Sender: TObject);
    procedure UpdateIcon(Sender: TObject);
  private
    { private declarations }
    bmp:TBitmap;
    procedure TrayMsg(txt1,txt2,hint1:string);
    procedure GetAppdir;
  public
    { public declarations }
    procedure Init;
  end; 

var
  f_tray: Tf_tray;

implementation

uses pu_clock;

{ Tf_tray }

procedure Tf_tray.Init;
var inif: TMemIniFile;
    section,buf : string;
begin
f_clock.cfgsc:=Tconf_skychart.Create;
inif:=TMeminifile.create(configfile);
try
with inif do begin
section:='observatory';
f_clock.cfgsc.ObsLatitude := ReadFloat(section,'ObsLatitude',f_clock.cfgsc.ObsLatitude );
f_clock.cfgsc.ObsLongitude := ReadFloat(section,'ObsLongitude',f_clock.cfgsc.ObsLongitude );
f_clock.cfgsc.ObsAltitude := ReadFloat(section,'ObsAltitude',f_clock.cfgsc.ObsAltitude );
f_clock.cfgsc.ObsTemperature := ReadFloat(section,'ObsTemperature',f_clock.cfgsc.ObsTemperature );
f_clock.cfgsc.ObsPressure := ReadFloat(section,'ObsPressure',f_clock.cfgsc.ObsPressure );
f_clock.cfgsc.ObsName := Condutf8decode(ReadString(section,'ObsName',f_clock.cfgsc.ObsName ));
f_clock.cfgsc.ObsCountry := ReadString(section,'ObsCountry',f_clock.cfgsc.ObsCountry );
f_clock.cfgsc.ObsTZ := ReadString(section,'ObsTZ',f_clock.cfgsc.ObsTZ );
f_clock.cfgsc.countrytz := ReadBool(section,'countrytz',f_clock.cfgsc.countrytz );
end;
finally
inif.Free;
end;
f_clock.cfgsc.tz.LoadZoneTab(ZoneDir+'zone.tab');
f_clock.cfgsc.tz.TimeZoneFile:=ZoneDir+StringReplace(f_clock.cfgsc.ObsTZ,'/',PathDelim,[rfReplaceAll]);
UpdateIcon(nil);
Timer1.Enabled:=true;
SysTray.Visible:=true;
end;

procedure Tf_tray.TrayMsg(txt1,txt2,hint1:string);
begin
bmp.Canvas.Brush.Color:=clBlack;
bmp.Canvas.Rectangle(0,0,bmp.Width,bmp.Height);
bmp.Canvas.Font.Color:=clYellow;
if bmp.width>30 then begin
  bmp.Canvas.TextOut(8,2,txt1);
  bmp.Canvas.TextOut(8,14,txt2);
end else begin
  bmp.Canvas.Font.Size:=6;
  bmp.Canvas.TextOut(3,-1,txt1);
  bmp.Canvas.TextOut(3,7,txt2);
end;
Systray.Icon.FreeImage;
SysTray.Icon.Canvas.Draw(0,0,bmp);
Systray.Hint:=hint1;
end;

procedure Tf_tray.Button1Click(Sender: TObject);
begin
  Hide;
end;

procedure Tf_tray.FormCreate(Sender: TObject);
begin
{$ifdef win32}
  SysTray.Icon.LoadFromLazarusResource('black16x16');
{$else}
  SysTray.Icon.LoadFromLazarusResource('black32x32');
{$endif}
  bmp:=TBitmap.Create;
  bmp.Width:=SysTray.Icon.Width;
  bmp.Height:=SysTray.Icon.Height;
  SysTray.PopUpMenu:=PopupMenu1;
  GetAppDir;
end;

procedure Tf_tray.FormDestroy(Sender: TObject);
begin
  SysTray.Hide;
  bmp.free;
  if (f_clock<>nil)and(f_clock.cfgsc<>nil) then f_clock.cfgsc.Free;
end;

procedure Tf_tray.MenuItem1Click(Sender: TObject);
begin
if f_clock.Visible then begin
  f_clock.Hide;
end else begin
  UpdateIcon(nil);
  FormPos(f_clock,SysTray.GetPosition.X,SysTray.GetPosition.Y);
  f_clock.Show;
end;
end;

procedure Tf_tray.MenuItem2Click(Sender: TObject);
begin
  ExecNoWait(CdC+' --unique');
end;

procedure Tf_tray.MenuItem3Click(Sender: TObject);
begin
  FormPos(Self,SysTray.GetPosition.X,SysTray.GetPosition.Y);
  Show;
end;

procedure Tf_tray.MenuItem5Click(Sender: TObject);
begin
  Close;
end;

procedure Tf_tray.UpdateIcon(Sender: TObject);
var buf: string;
begin
  if not f_clock.Timer1.Enabled then f_clock.UpdateClock;
  buf:=f_clock.clock4.Caption;
  TrayMsg(copy(buf,1,2),copy(buf,4,2),f_clock.label4.Caption+blank+f_clock.clock4.caption);
end;

Procedure Tf_tray.GetAppDir;
var inif: TMemIniFile;
    buf: string;
    startdir: string;
{$ifdef darwin}
    i: integer;
{$endif}
{$ifdef win32}
    PIDL : PItemIDList;
    Folder : array[0..MAX_PATH] of Char;
const CSIDL_PERSONAL = $0005;
{$endif}
begin
startdir:=ExtractFilePath(ParamStr(0));
{$ifdef darwin}
appdir:=getcurrentdir;
if not DirectoryExists(slash(appdir)+slash('data')+slash('planet')) then begin
   appdir:=ExtractFilePath(ParamStr(0));
   i:=pos('.app/',appdir);
   if i>0 then begin
     appdir:=ExtractFilePath(copy(appdir,1,i));
   end;
end;
{$else}
appdir:=getcurrentdir;
{$ifdef trace_debug}
 debugln('appdir='+appdir);
{$endif}
{$endif}
privatedir:=DefaultPrivateDir;
{$ifdef unix}
appdir:=expandfilename(appdir);
privatedir:=expandfilename(PrivateDir);
configfile:=expandfilename(Defaultconfigfile);
{$endif}
{$ifdef win32}
SHGetSpecialFolderLocation(0, CSIDL_PERSONAL, PIDL);
SHGetPathFromIDList(PIDL, Folder);
privatedir:=slash(Folder)+privatedir;
configfile:=slash(privatedir)+Defaultconfigfile;
{$endif}

if fileexists(configfile) then begin
  inif:=TMeminifile.create(configfile);
  try
  buf:=inif.ReadString('main','AppDir',appdir);
  if Directoryexists(buf) then appdir:=buf;
  privatedir:=inif.ReadString('main','PrivateDir',privatedir);
  finally
   inif.Free;
  end;
end;
Tempdir:=slash(privatedir)+DefaultTmpDir;
{$ifdef trace_debug}
 debugln('appdir='+appdir);
{$endif}
// Be sur the data directory exists
if (not directoryexists(slash(appdir)+slash('data')+'constellation')) then begin
  // try under the current directory
  buf:=GetCurrentDir;
  {$ifdef trace_debug}
   debugln('Try '+buf);
  {$endif}
  if (directoryexists(slash(buf)+slash('data')+'constellation')) then
     appdir:=buf
  else begin
     // try under the program directory
     buf:=ExtractFilePath(ParamStr(0));
    {$ifdef trace_debug}
     debugln('Try '+buf);
    {$endif}
     if (directoryexists(slash(buf)+slash('data')+'constellation')) then
        appdir:=buf
     else begin
         // try share directory under current location
         buf:=ExpandFileName(slash(GetCurrentDir)+SharedDir);
          {$ifdef trace_debug}
           debugln('Try '+buf);
          {$endif}
         if (directoryexists(slash(buf)+slash('data')+'constellation')) then
            appdir:=buf
         else begin
            // try share directory at the same location as the program
            buf:=ExpandFileName(slash(ExtractFilePath(ParamStr(0)))+SharedDir);
            {$ifdef trace_debug}
             debugln('Try '+buf);
            {$endif}
            if (directoryexists(slash(buf)+slash('data')+'constellation')) then
               appdir:=buf
            else begin
               MessageDlg('Could not found the application data directory.'+crlf
                   +'Please edit the file .cartesduciel.ini'+crlf
                   +'and indicate at the line Appdir= where you install the data.',
                   mtError, [mbAbort], 0);
               Halt;
            end;
         end;
     end;
  end;
end;
{$ifdef trace_debug}
 debugln('appdir='+appdir);
 debugln('privatedir='+privatedir);
{$endif}
{$ifdef win32}
tracefile:=slash(privatedir)+'tray_'+tracefile;
{$endif}
VarObs:=slash(startdir)+DefaultVarObs;     // varobs normally at same location as skychart
if not FileExists(VarObs) then VarObs:=DefaultVarObs; // if not try in $PATH
CdC:=slash(startdir)+DefaultCdC;
if not FileExists(CdC) then CdC:=DefaultCdC;
helpdir:=slash(appdir)+slash('doc');
SampleDir:=slash(appdir)+slash('data')+'sample';
// Be sure zoneinfo exists in standard location or in skychart directory
ZoneDir:=slash(appdir)+slash('data')+slash('zoneinfo');
{$ifdef trace_debug}
 debugln('ZoneDir='+ZoneDir);
{$endif}
buf:=slash('')+slash('usr')+slash('share')+slash('zoneinfo');
{$ifdef trace_debug}
 debugln('Try '+buf);
{$endif}
if (FileExists(slash(buf)+'zone.tab')) then
     ZoneDir:=slash(buf)
else begin
  buf:=slash('')+slash('usr')+slash('lib')+slash('zoneinfo');
  {$ifdef trace_debug}
   debugln('Try '+buf);
  {$endif}
  if (FileExists(slash(buf)+'zone.tab')) then
      ZoneDir:=slash(buf)
  else begin
     if (not FileExists(slash(ZoneDir)+'zone.tab')) then begin
       MessageDlg('zoneinfo directory not found!'+crlf
         +'Please install the tzdata package.'+crlf
         +'If it is not installed at a standard location create a logical link zoneinfo in skychart data directory.',
         mtError, [mbAbort], 0);
       Halt;
     end;
  end;
end;
{$ifdef trace_debug}
 debugln('ZoneDir='+ZoneDir);
{$endif}
end;

initialization
  {$I pu_tray.lrs}
  {$I blankicon.lrs}
end.

