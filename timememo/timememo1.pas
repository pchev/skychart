unit timememo1;
{
Copyright (C) 2001-2017 Patrick Chevalley

http://www.ap-i.net
pch@ap-i.net

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
  Program to log time difference with a server and optionally set the time
}
interface

uses
  LCLIntf, LCLType,
  {$IFDEF MSWINDOWS}
    windows,
  {$ENDIF}
  Forms, Controls, StdCtrls, ExtCtrls, Graphics, sysutils,
  LazUTF8SysUtils, LazUTF8, LazFileUtils, Inifiles, Classes,  sntpsend ;


type

  { Tform_memo }

  Tform_memo = class(TForm)
    Panel6: TPanel;
    Panel7: TPanel;
    Panel8: TPanel;
    Timer1: TTimer;
    Label8: TLabel;
    GroupBox1: TGroupBox;
    EditLog: TEdit;
    CheckBoxLog: TCheckBox;
    Panel2: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    Panel3: TPanel;
    Label3: TLabel;
    Label4: TLabel;
    Label6: TLabel;
    Label5: TLabel;
    Panel4: TPanel;
    Label7: TLabel;
    Panel1: TPanel;
    BtnStart: TButton;
    GroupBox2: TGroupBox;
    BtnSetTime: TButton;
    BtnShowTime: TButton;
    ServerList: TComboBox;
    BtnExit: TButton;
    Label9: TLabel;
    Label10: TLabel;
    EditInterval: TEdit;
    EditMaxofffset: TEdit;
    EditUpdateInterval: TEdit;
    EditMaxDifference: TEdit;
    CheckBoxSetTime: TCheckBox;
    Panel5: TPanel;
    Memo1: TMemo;
    procedure BtnStartClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure BtnSetTimeClick(Sender: TObject);
    procedure BtnShowTimeClick(Sender: TObject);
    procedure BtnExitClick(Sender: TObject);
    procedure EditIntervalExit(Sender: TObject);
    procedure EditMaxofffsetExit(Sender: TObject);
    procedure EditUpdateIntervalExit(Sender: TObject);
    procedure EditMaxDifferenceExit(Sender: TObject);
    procedure CheckBoxSetTimeClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
  private
    sntp:TSntpSend;
    LastSet : Tdatetime;
    RefRate   : integer;
    SyncEvery : integer;
    MinSync   : double;
    MaxSync   : double;
    startimmed:boolean;
    starthide:boolean;
    ConfigDir: string;
    InitFile: string;
    {$IFDEF MSWINDOWS}
    function SetUTTime(newdt: Tdatetime): boolean;
    {$ENDIF}
    function  SynchroNTP(out timeset : boolean):boolean;
    procedure SynchroTime;
    procedure CheckTime(canset : boolean);
    Procedure Cleanmemo;
    Procedure Writememo(lin : string);
  public
  end;

var
  form_memo: Tform_memo;

implementation

const datefmtiso = 'yyyy"-"mm"-"dd" "hh":"nn":"ss"."zzz';
      sep = ' | ';

{$R *.lfm}

function Slash(nom : string) : string;
begin
result:=trim(nom);
if copy(result,length(result),1)<>PathDelim then result:=result+PathDelim;
end;


procedure Tform_memo.FormCreate(Sender: TObject);
var ini : Tinifile;
    i : integer;
begin
DefaultFormatSettings.decimalseparator:='.';
sntp:=TSntpSend.Create;
LastSet:=0;
// get config
ConfigDir:=GetAppConfigDirUTF8(false,true);
// search in program dir first
if FileExistsUTF8('timeserver.lst') then begin
     ServerList.Items.clear;
     ServerList.Items.LoadFromFile('timeserver.lst');
     ServerList.ItemIndex:=0;
end;
// then search in config dir
if FileExistsUTF8(slash(ConfigDir)+'timeserver.lst') then begin
     ServerList.Items.clear;
     ServerList.Items.LoadFromFile(slash(ConfigDir)+'timeserver.lst');
     ServerList.ItemIndex:=0;
end;
InitFile := slash(ConfigDir)+'timememo.ini';
ini:= TInifile.Create(InitFile);
RefRate:=ini.readInteger('Default','RefRate',60);
SyncEvery:=ini.readInteger('Default','SyncEvery',300);
MinSync:=ini.readFloat('Default','MinSync',0.1);
MaxSync:=ini.readFloat('Default','MaxSync',3600);
ServerList.text:=ini.readstring('Default','NTPhost',ServerList.text);
EditLog.text:=ini.readstring('Default','FileName',slash(ConfigDir)+'timememo.txt');
CheckBoxLog.Checked:=ini.readBool('Default','RecFile',true);
CheckBoxSetTime.Checked:=ini.readBool('Default','AutoSync',false);
ini.free;
{$IFNDEF mswindows}
 // hide control not use with Linux
 CheckBoxSetTime.Checked:=false;
 panel3.visible:=false;
 BtnSetTime.Visible:=false;
{$ENDIF}
// initialize parameters
EditInterval.text:=inttostr(RefRate);
EditUpdateInterval.text:=inttostr(SyncEvery);
EditMaxofffset.text:=floattostr(MinSync);
EditMaxDifference.text:=floattostr(MaxSync);
CheckBoxSetTimeClick(sender);
startimmed:=false;
starthide:=false;
for i:=1 to paramcount do begin
  if paramstr(i)='-s' then startimmed:=true;
  if paramstr(i)='-d' then begin starthide:=true; startimmed:=true; end;
end;
if startimmed then BtnStartClick(Sender);
end;

procedure Tform_memo.FormShow(Sender: TObject);
begin
  memo1.Lines.Add('Time memo version 2.0');
  if starthide then hide;
end;

procedure Tform_memo.FormClose(Sender: TObject; var CloseAction: TCloseAction);
var ini : Tinifile;
begin
ini:= TInifile.Create(InitFile);
ini.writeInteger('Default','RefRate',RefRate);
ini.writeInteger('Default','SyncEvery',SyncEvery);
ini.writeFloat('Default','MinSync',MinSync);
ini.writeFloat('Default','MaxSync',MaxSync);
ini.writestring('Default','NTPhost',ServerList.text);
ini.writestring('Default','FileName',EditLog.text);
ini.writeBool('Default','RecFile',CheckBoxLog.Checked);
ini.writeBool('Default','AutoSync',CheckBoxSetTime.Checked);
ini.UpdateFile;
ini.free;
CloseAction:=caFree;
end;

Procedure Tform_memo.Writememo(lin : string);
var f : textfile;
  i:integer;
begin
// write to memo
i:=memo1.lines.add(lin);
memo1.Top:=i;
if CheckBoxLog.checked then begin
  // write to logfile
  Assignfile(f,EditLog.text);
  if FileExistsUTF8(EditLog.text) then append(f) else rewrite(f);
  writeln(f,lin);
  closefile(f);
end;
end;

Procedure Tform_memo.Cleanmemo;
var i,n : integer;
begin
// do not keep to many rows if the program run for a long time
with memo1 do begin
  if (lines.count > 100) then begin
     n:=lines.count-50;
     lines.beginupdate;
     for i:=1 to n do lines.Delete(0);
     lines.endupdate;
  end;
end;
end;

procedure Tform_memo.CheckTime(canset : boolean);
var
  lin : string;
begin
  lin:='';
  try
    // get time from server
    if sntp.GetNTP
      then begin
        lin:=FormatDatetime(datefmtiso,NowUTC)+sep+FormatDatetime(datefmtiso,sntp.NTPTime)+sep+
             format('%8.3f',[sntp.NTPOffset])+sep+format('%6.3f',[sntp.NTPDelay])+sep;
        writememo(lin);
        if canset and CheckBoxSetTime.checked and (abs(sntp.NTPOffset)>MinSync) and (((NowUTC-LastSet)*86400)>SyncEvery) then begin
           SynchroTime;
           LastSet:=NowUTC;
        end;
      end
      else begin
        lin:=FormatDatetime(datefmtiso,NowUTC)+' Server or connection error!';
        writememo(lin);
      end;
  finally
    Cleanmemo;
  end;
end;

{$IFDEF MSWINDOWS}
function Tform_memo.SetUTTime(newdt: Tdatetime): boolean;
var st : TSystemTime;

begin
 // allow to set time only on windows, on linux use ntpd
 DateTimeToSystemTime(newdt,st);
 result:=SetSystemTime(st);
end;
{$ENDIF}

function Tform_memo.SynchroNTP(out timeset : boolean):boolean;
{$IFDEF MSWINDOWS}
var t,t1: TDateTime;
{$ENDIF}
begin
  result:=false;
  timeset:=false;
  {$IFDEF MSWINDOWS}
  t1 := NowUTC;
  if sntp.GetNTP then begin
    result:=true;
    if (abs(sntp.NTPTime-t1)*86400)<=MaxSync then
       timeset := SetUTTime(sntp.NTPTime);
  end;
  {$ENDIF}
end;

procedure Tform_memo.SynchroTime;
var
  ok : boolean;
  lin : string;
begin
  lin:='';
  if SynchroNTP(ok)
    then begin
      lin:=FormatDatetime(datefmtiso,NowUTC)+sep+FormatDatetime(datefmtiso,sntp.NTPTime)+sep+
           format('%8.2f',[sntp.NTPOffset])+sep+format('%5.2f',[sntp.NTPDelay]);
      if ok then lin:=lin+sep+'OK!'
            else lin:=lin+sep+'Failed!';
      writememo(lin);
    end
    else begin
      lin:=FormatDatetime(datefmtiso,NowUTC)+' Server or connection error!';
      writememo(lin);
    end;
end;

function EditToInt(edit : Tedit; min,max : integer; var i : integer): boolean;
var code : Integer;
begin
result:=false;
val(edit.text,i,code);
if (code=0)and(i>=min)and(i<=max) then
     result:=true
   else begin
     beep;
     edit.hint:=inttostr(min)+'..'+inttostr(max);
     edit.showhint:=true;
end;
end;

function EditToFloat(edit : Tedit; min,max : integer; var x : double): boolean;
var code : Integer;
begin
result:=false;
val(edit.text,x,code);
if (code=0)and(x>=min)and(x<=max) then
     result:=true
   else begin
     beep;
     edit.hint:=floattostr(min)+'..'+floattostr(max);
     edit.showhint:=true;
end;
end;

procedure Tform_memo.BtnStartClick(Sender: TObject);
var lin : string;
begin
if timer1.enabled then begin
   // stop loop
   timer1.enabled:=false;
   BtnStart.caption:='Start';
   panel1.color:=clred;
   EditInterval.enabled:=true;
   EditMaxofffset.enabled:=true;
   EditUpdateInterval.enabled:=true;
   EditMaxDifference.enabled:=true;
   ServerList.enabled:=true;
   CheckBoxSetTime.enabled:=true;
   EditLog.enabled:=true;
   lin:=(FormatDatetime(datefmtiso,NowUTC)+' Stop');
   writememo(lin);
end else begin
   // start loop
   sntp.TargetHost:=ServerList.Text;
   timer1.interval:=Refrate*1000;
   timer1.enabled:=true;
   BtnStart.caption:='Stop';
   panel1.color:=clLime;
   EditInterval.enabled:=false;
   EditMaxofffset.enabled:=false;
   EditUpdateInterval.enabled:=false;
   EditMaxDifference.enabled:=false;
   ServerList.enabled:=false;
   CheckBoxSetTime.enabled:=false;
   EditLog.enabled:=false;
   lin:=FormatDatetime(datefmtiso,NowUTC)+' Start, NTP Server : '+sntp.TargetHost;
   writememo(lin);
   lin:=label8.caption;
   writememo(lin);
   checktime(true);
end;
end;

procedure Tform_memo.Timer1Timer(Sender: TObject);
begin
// periodic refresh
checktime(true);
end;

procedure Tform_memo.BtnSetTimeClick(Sender: TObject);
begin
sntp.TargetHost:=ServerList.Text;
writememo('NTP Server : '+sntp.TargetHost);
SynchroTime;
end;

procedure Tform_memo.BtnShowTimeClick(Sender: TObject);
begin
sntp.TargetHost:=ServerList.Text;
writememo('NTP Server : '+sntp.TargetHost);
checktime(false);
end;

procedure Tform_memo.BtnExitClick(Sender: TObject);
begin
Close;
end;

procedure Tform_memo.EditIntervalExit(Sender: TObject);
begin
edittoint(EditInterval,1,86400,RefRate);
end;

procedure Tform_memo.EditMaxofffsetExit(Sender: TObject);
begin
edittofloat(EditMaxofffset,0,100,Minsync);
end;

procedure Tform_memo.EditUpdateIntervalExit(Sender: TObject);
begin
edittoint(EditUpdateInterval,1,86400,Syncevery);
end;

procedure Tform_memo.EditMaxDifferenceExit(Sender: TObject);
begin
edittofloat(EditMaxDifference,0,86400,Maxsync);
end;

procedure Tform_memo.CheckBoxSetTimeClick(Sender: TObject);
var factive : boolean;
begin
if CheckBoxSetTime.checked then
    factive:=true
else
    factive:=false;
EditMaxofffset.enabled:=factive;
EditUpdateInterval.enabled:=factive;
EditMaxDifference.enabled:=factive;
label3.enabled:=factive;
label4.enabled:=factive;
label5.enabled:=factive;
label6.enabled:=factive;
label9.enabled:=factive;
label10.enabled:=factive;
end;

end.
