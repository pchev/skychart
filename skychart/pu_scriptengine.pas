unit pu_scriptengine;

{$mode objfpc}{$H+}

{
Copyright (C) 2014 Patrick Chevalley

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
 Script engine with specific function for Skychart
}

interface

uses  u_translation, u_constant, u_projection, u_help,
  u_scriptsocket, u_util, ActnList, pu_pascaleditor, fpjson, jsonparser,
  cu_database, cu_catalog, cu_fits, cu_planet, math, fu_chart, jdcalendar, upsi_translation,
  uPSComponent, uPSComponent_Default, uPSCompiler, uPSRuntime, uPSComponent_DB,
  uPSComponent_Forms, uPSComponent_Controls, uPSI_CheckLst, uPSComponent_StdCtrls,
  StdCtrls, ExtCtrls, Menus, Classes, SysUtils,Forms, Controls, Graphics, Dialogs,
  ComCtrls, Buttons, FileUtil, IniFiles, CheckLst, ExtDlgs
  {$ifdef mswindows}
  , uPSComponent_COM    // in case of error here please apply the Lazarus patch
                        // available in (Skychart_source)/tools/Lazarus_Patch/
                        // or install PascalScript from git master
  {$endif}
  ;

type

  Teventlist=(evInitialisation,evActivation,evTimer,evTelescope_move,evChart_refresh,evObject_identification,evDistance_measurement,evTelescope_connect,evTelescope_disconnect,evTranslation);

  { Tf_scriptengine }

  Tf_scriptengine = class(TForm)
    ButtonHelp: TButton;
    ButtonDown: TBitBtn;
    ButtonSave: TButton;
    ButtonLoad: TButton;
    ButtonUp: TBitBtn;
    ButtonUpdate: TButton;
    ButtonAdd: TButton;
    ButtonEditScript: TButton;
    ButtonApply: TButton;
    ButtonClear: TButton;
    ButtonDelete: TButton;
    CheckBoxHidenTimer: TCheckBox;
    LabelCaptionEdit: TEdit;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    ListHeightEdit: TEdit;
    CheckListHeightEdit: TEdit;
    Panel3: TPanel;
    PanelLeft: TPanel;
    PSCustomPlugin1: TPSCustomPlugin;
    PSDllPlugin1: TPSDllPlugin;
    RadioButtonLabel: TRadioButton;
    RadioButtonList: TRadioButton;
    RadioButtonCombo: TRadioButton;
    RadioButtonCheckList: TRadioButton;
    ScriptTitle: TEdit;
    Panel2: TPanel;
    EventTimer: TTimer;
    Splitter1: TSplitter;
    TimerIntervalEdit: TEdit;
    EventComboBox: TComboBox;
    CompileMemo: TMemo;
    GroupBox1: TGroupBox;
    GroupCaptionEdit: TEdit;
    ButtonCaptionEdit: TEdit;
    MemoHeightEdit: TEdit;
    GroupRowEdit: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    OpenDialog1: TOpenDialog;
    Panel1: TPanel;
    PSImport_Classes1: TPSImport_Classes;
    PSImport_Controls1: TPSImport_Controls;
    PSImport_DateUtils1: TPSImport_DateUtils;
    PSImport_Forms1: TPSImport_Forms;
    PSImport_StdCtrls1: TPSImport_StdCtrls;
    {$ifdef mswindows}
    PSImport_ComObj1: TPSImport_ComObj;
    {$endif}
    RadioButtonEvent: TRadioButton;
    RadioButtonGroup: TRadioButton;
    RadioButtonButton: TRadioButton;
    RadioButtonEdit: TRadioButton;
    RadioButtonMemo: TRadioButton;
    RadioButtonSpacer: TRadioButton;
    SaveDialog1: TSaveDialog;
    TplPSScript: TPSScript;
    TreeView1: TTreeView;
    procedure ButtonAddClick(Sender: TObject);
    procedure ButtonCaptionEditChange(Sender: TObject);
    procedure ButtonDownClick(Sender: TObject);
    procedure ButtonEditScriptClick(Sender: TObject);
    procedure ButtonApplyClick(Sender: TObject);
    procedure ButtonClearClick(Sender: TObject);
    procedure ButtonDeleteClick(Sender: TObject);
    procedure ButtonHelpClick(Sender: TObject);
    procedure ButtonLoadClick(Sender: TObject);
    procedure ButtonSaveClick(Sender: TObject);
    procedure ButtonUpClick(Sender: TObject);
    procedure ButtonUpdateClick(Sender: TObject);
    procedure CheckListHeightEditChange(Sender: TObject);
    procedure EventComboBoxChange(Sender: TObject);
    procedure EventTimerTimer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure GroupCaptionEditChange(Sender: TObject);
    procedure GroupRowEditChange(Sender: TObject);
    procedure LabelCaptionEditChange(Sender: TObject);
    procedure ListHeightEditChange(Sender: TObject);
    procedure MemoHeightEditChange(Sender: TObject);
    procedure PSCustomPlugin1CompileImport1(Sender: TPSScript);
    procedure PSCustomPlugin1ExecImport1(Sender: TObject; se: TPSExec;
      x: TPSRuntimeClassImporter);
    procedure RadioButtonClick(Sender: TObject);
    procedure TimerIntervalEditClick(Sender: TObject);
    procedure TplPSScriptCompile(Sender: TPSScript);
    procedure TplPSScriptExecute(Sender: TPSScript);
    procedure TplPSScriptLine(Sender: TObject);
    procedure TreeView1Change(Sender: TObject; Node: TTreeNode);
    procedure TreeView1DragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure TreeView1DragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
  private
    { private declarations }
    FScriptFilename: string;
    FEditSurface: TPanel;
    FonApply: TNotifyEvent;
    dbgscr: TPSScriptDebugger;
    grnum:integer;
    gr: array of TGroupBox;
    btnum:integer;
    bt: array of TButton;
    btscrnum: integer;
    btscr: array of TPSScript;
    cbscrnum: integer;
    cbscr: array of TPSScript;
    evscrnum: integer;
    evscr: array of TPSScript;
    ednum:integer;
    ed: array of TEdit;
    menum:integer;
    me: array of TMemo;
    spnum:integer;
    sp: array of TPanel;
    cbnum:integer;
    cb: array of TCombobox;
    lsnum:integer;
    ls: array of TListBox;
    lbnum:integer;
    lb: array of TLabel;
    cknum:integer;
    ck: array of TCheckListBox;
    opdialog: TOpenDialog;
    svdialog: TSaveDialog;
    cadialog: TJDCalendarDialog;
    FConfigToolbar1,FConfigToolbar2: TStringlist;
    Fpascaleditor: Tf_pascaleditor;
    GroupIdx,ButtonIdx,EditIdx,MemoIdx,SpacerIdx,LabelIdx,ComboIdx,ListIdx,CheckListIdx,EventIdx: integer;
    FExecuteCmd: TExecuteCmd;
    FCometMark: TExecuteCmd;
    FAsteroidMark: TExecuteCmd;
    FGetScopeRates: TExecuteCmd;
    FSendInfo: TSendInfo;
    FMainmenu: TMenu;
    Fcdb: TCDCdb;
    Fcatalog: TCatalog;
    Ffits : TFits;
    Fplanet  : Tplanet;
    Fcmain: Tconf_main;
    FActiveChart: Tf_chart;
    ChartName,TelescopeChartName,RefreshText,SelectionText,DescriptionText,DistanceText: string;
    TelescopeRA,TelescopeDE: double;
    FTelescopeConnected: boolean;
    vlist: array of Variant;
    ilist: array of Integer;
    dlist: array of Double;
    slist: array of String;
    reservedslist: string;
    strllist: array of TStringList;
    socklist: array[0..maxscriptsock] of TScriptSocket;
    FTimerReady,FEventReady: boolean;
    function doOpenFile(fn:string):boolean;
    function doRun(cmdline:string):boolean;
    function doRunOutput(cmdline:string; var output:TStringlist):boolean;
    function doExecuteCmd(cname:string; arg:Tstringlist):string;
    function doGetS(varname:string; var str: string):Boolean;
    function doSetS(varname:string; str: string):Boolean;
    function doGetSL(varname:string; var strl: TStringList):Boolean;
    function doSetSL(varname:string; strl: TStringList):Boolean;
    function doGetI(varname:string; var i: Integer):Boolean;
    function doSetI(varname:string; i: Integer):Boolean;
    function doGetD(varname:string; var x: Double):Boolean;
    function doSetD(varname:string; x: Double):Boolean;
    function doGetV(varname:string; var v: Variant):Boolean;
    function doSetV(varname:string; v: Variant):Boolean;
    function doGetObservatoryList(list:TstringList):boolean;
    function doOpenDialog(var fn: string): boolean;
    function doSaveDialog(var fn: string): boolean;
    function doCalendarDialog(var dt: double): boolean;
    Function doJDtoStr(var jd: Double) : string;
    Function doStrtoJD(dt:string; var jdt: Double) : boolean;
    Function doARtoStr(var ar: Double) : string;
    Function doDEtoStr(var de: Double) : string;
    Function doStrtoAR(str:string; var ar: Double) : boolean;
    Function doStrtoDE(str:string; var de: Double) : boolean;
    Procedure doEq2Hz(ra,de : double ; var a,h : double);
    Procedure doHz2Eq(a,h : double; var ra,de : double);
    function doFormatFloat(Const Format : String; var Value : double) : String;
    function doFormat(Const Fmt : String; const Args : Array of const) : String;
    Procedure doStrtoFloatD(str:string; var defval: Double; var val: Double);
    function doStringReplace(str,s1,s2: String): string;
    function doIsNumber(str: String): boolean;
    function doMsgBox(const aMsg: string):boolean;
    Procedure doShowMessage(const aMsg: string);
    function doGetCometList(const filter: string; maxnum:integer; list:TstringList):boolean;
    function doCometMark(list:TstringList):boolean;
    function doGetAsteroidList(const filter: string; maxnum:integer; list:TstringList):boolean;
    function doAsteroidMark(list:TstringList):boolean;
    function doGetScopeRates(list:TstringList):boolean;
    procedure doSendInfo(origin,str:string);
    function doTcpConnect(socknum:integer; ipaddr,port,timeout:string):boolean;
    function doTcpDisconnect(socknum:integer):boolean;
    Function doTcpConnected(socknum:integer) : boolean;
    Function doTcpReadCount(socknum:integer; var buf : string; var count : integer) : boolean;
    Function doTcpRead(socknum:integer; var buf : string; termchar:string) : boolean;
    Function doTcpWrite(socknum:integer; var buf : string; var count : integer) : boolean;
    Procedure doTcpPurgeBuffer(socknum:integer);
    procedure JsonDataToStringlist(var SK,SV: TStringList; prefix:string; D : TJSONData);
    procedure doJsonToStringlist(jsontxt:string; var SK,SV: TStringList);
    procedure Button_Click(Sender: TObject);
    procedure Combo_Change(Sender: TObject);
    procedure ReorderGroup;
    function  AddGroup(num,capt:string; pt: TWinControl; ctlperline,ordernum:integer):TGroupBox;
    procedure AddButton(num,capt:string; pt: TWinControl);
    procedure AddEdit(num:string; pt: TWinControl);
    procedure AddMemo(num:string; pt: TWinControl;h: integer);
    procedure AddSpacer(num:string; pt: TWinControl);
    procedure AddLabel(num,capt:string; pt: TWinControl);
    procedure AddCombo(num:string; pt: TWinControl);
    procedure AddList(num:string; pt: TWinControl;h: integer);
    procedure AddCheckList(num:string; pt: TWinControl;h: integer);
    function GetScriptTranslation(str:string):string;
    procedure ClearTreeView;
    procedure CompileScripts;
  public
    { public declarations }
    InitialLoad: Boolean;
    procedure SetLang;
    procedure StopAllScript;
    procedure StartTimer;
    procedure Save(strbtn, strscr, comboscr, eventscr: Tstringlist; var title:string);
    procedure Load(strbtn, strscr, comboscr, eventscr: Tstringlist; title:string);
    procedure LoadFile(fn: string);
    procedure ChartRefreshEvent(origin,str:string);
    procedure ObjectSelectionEvent(origin,str,longstr:string);
    procedure DistanceMeasurementEvent(origin,str:string);
    procedure TelescopeMoveEvent(origin:string; ra,de: double);
    procedure TelescopeConnectEvent(origin:string; connected:boolean);
    procedure ActivateEvent;
    property TimerReady: boolean read FTimerReady;
    property EventReady: boolean read FEventReady write FEventReady;
    property ConfigToolbar1: TStringList read FConfigToolbar1 write FConfigToolbar1;
    property ConfigToolbar2: TStringList read FConfigToolbar2 write FConfigToolbar2;
    property EditSurface: TPanel read FEditSurface write FEditSurface;
    property onApply: TNotifyEvent read FonApply write FonApply;
    property ExecuteCmd: TExecuteCmd read FExecuteCmd write FExecuteCmd;
    property CometMark: TExecuteCmd read FCometMark write FCometMark;
    property AsteroidMark: TExecuteCmd read FAsteroidMark write FAsteroidMark;
    property GetScopeRates: TExecuteCmd read FGetScopeRates write FGetScopeRates;
    property SendInfo: TSendInfo read FSendInfo write FSendInfo;
    property Mainmenu: TMenu read FMainmenu write FMainmenu;
    property cdb: TCDCdb read Fcdb  write Fcdb;
    property catalog: TCatalog read Fcatalog write Fcatalog;
    property fits: TFits read Ffits write Ffits;
    property planet: Tplanet read Fplanet write Fplanet;
    property cmain: Tconf_main read Fcmain write Fcmain;
    property ActiveChart: Tf_chart read FActiveChart write FActiveChart;
    property ScriptFilename: string read FScriptFilename;
  end;

var
  f_scriptengine: Tf_scriptengine;

implementation

{$R *.lfm}

procedure Tf_scriptengine.SetLang;
begin
  caption:=rsScript;
  ButtonAdd.Caption:=rsAdd;
  ButtonEditScript.Caption:=rsEditScript;
  ButtonUpdate.Caption:=rsUpdate1;
  ButtonDelete.Caption:=rsDelete;
  ButtonApply.Caption:=rsApply;
  ButtonSave.Caption:=rsSave;
  ButtonLoad.Caption:=rsLoad;
  ButtonClear.Caption:=rsClearAll;
  ButtonHelp.Caption:=rsHelp;
  GroupBox1.Caption:=rsComponent;
  RadioButtonGroup.Caption:=rsGroup;
  RadioButtonButton.Caption:=rsButton;
  RadioButtonEdit.Caption:=rsEdit;
  RadioButtonMemo.Caption:=rsMemo;
  RadioButtonList.Caption:=rsList;
  RadioButtonCheckList.Caption:=rsCheckList;
  RadioButtonCombo.Caption:=rsComboBox;
  RadioButtonSpacer.Caption:=rsSpacer;
  RadioButtonEvent.Caption:=rsEvent;
  Label1.Caption:=rsColumns;
  Label2.Caption:=rsCaption;
  Label3.Caption:=rsCaption;
  Label4.Caption:=rsHeight;
  Label5.Caption:=rsHeight;
  CheckBoxHidenTimer.Caption:=rsActivateTheT;
  if Fpascaleditor<>nil then Fpascaleditor.SetLang;
  SetHelp(self,hlpToolboxEditor);
  if (evscr[ord(evTranslation)]<>nil) and
     (evscr[ord(evTranslation)].Script.Count>0)
     then begin
      evscr[ord(evTranslation)].Compile;
      evscr[ord(evTranslation)].Execute;
     end;
end;

function Tf_scriptengine.doExecuteCmd(cname:string; arg:Tstringlist):string;
var i: integer;
begin
  for i:=arg.count to MaxCmdArg do arg.add('');
  if assigned(FExecuteCmd) then result:=FExecuteCmd(cname,arg);
end;

Procedure Tf_scriptengine.doEq2Hz(ra,de : double ; var a,h : double);
begin
  if assigned(FActiveChart) then FActiveChart.cmdEq2Hz(ra,de,a,h);
end;

Procedure Tf_scriptengine.doHz2Eq(a,h : double; var ra,de : double);
begin
  if assigned(FActiveChart) then FActiveChart.cmdHz2Eq(a,h,ra,de);
end;

function Tf_scriptengine.doFormatFloat(Const Format : String; var Value : double) : String;
begin
  result:=FormatFloat(format, Value);
end;

Procedure Tf_scriptengine.doStrtoFloatD(str:string; var defval: Double; var val: Double);
begin
  val:=StrToFloatDef(str,defval);
end;

function Tf_scriptengine.doStringReplace(str,s1,s2: String): string;
begin
  result:=StringReplace(str,s1,s2,[rfReplaceAll]);
end;

function Tf_scriptengine.doFormat(Const Fmt : String; const Args : Array of const) : String;
begin
 result:=Format(Fmt,Args);
end;

function Tf_scriptengine.doIsNumber(str: String): boolean;
begin
  result:=IsNumber(str);
end;

function Tf_scriptengine.doMsgBox(const aMsg: string):boolean;
begin
  result:=MessageDlg(aMsg,mtConfirmation,mbYesNo,0)=mrYes;
end;

Procedure Tf_scriptengine.doShowMessage(const aMsg: string);
begin
  ShowMessage(aMsg);
end;

function Tf_scriptengine.doGetCometList(const filter: string; maxnum:integer; list:TstringList):boolean;
var cometid : array of string;
begin
  SetLength(cometid,maxnum);
  list.Clear;
  Fcdb.GetCometList(filter,maxnum,list,cometid);
  SetLength(cometid,0);
  result:=list.count>0;
end;

function Tf_scriptengine.doCometMark(list:TstringList):boolean;
var str: string;
begin
  if assigned(FCometMark) then str:=FCometMark('',list);
  result:=(pos(msgOK,str)>0);
end;

function Tf_scriptengine.doGetAsteroidList(const filter: string; maxnum:integer; list:TstringList):boolean;
var astid : array of string;
begin
  SetLength(astid,maxnum);
  list.Clear;
  Fcdb.GetAsteroidList(filter,maxnum,list,astid);
  SetLength(astid,0);
  result:=list.count>0;
end;

function Tf_scriptengine.doAsteroidMark(list:TstringList):boolean;
var str: string;
begin
  if assigned(FAsteroidMark) then str:=FAsteroidMark('',list);
  result:=(pos(msgOK,str)>0);
end;

function Tf_scriptengine.doGetScopeRates(list:TstringList):boolean;
var str: string;
begin
  if assigned(FGetScopeRates) then str:=FGetScopeRates(TelescopeChartName,list);
  result:=(pos(msgOK,str)>0);
end;

procedure Tf_scriptengine.doSendInfo(origin,str:string);
begin
  if Assigned(FSendInfo) then FSendInfo(self,origin,str);
end;

function Tf_scriptengine.doGetObservatoryList(list:TstringList):boolean;
var str,buf,cobs,clat,clon,calt,ctz: string;
    cmd: Tstringlist;
    addcobs: boolean;
    i,p: integer;
begin
list.clear;
addcobs:=true;
cobs:='';
cmd:=Tstringlist.Create;
cmd.add('GETOBS');
str:=ExecuteCmd('',cmd);
p:=pos('OK!',str);
if p>0 then begin
 delete(str,1,p+2);
 p:=pos('LAT:',str);
 delete(str,1,p+3);
 p:=pos('LON:',str);
 clat:=copy(str,1,p-1);
 delete(str,1,p+3);
 p:=pos('ALT:',str);
 clon:=copy(str,1,p-1);
 delete(str,1,p+3);
 p:=pos('OBS:',str);
 calt:=copy(str,1,p-1);
 delete(str,1,p+3);
 cobs:=str;
end;
cmd.clear;
cmd.add('GETTZ');
str:=ExecuteCmd('',cmd);
p:=pos('OK!',str);
if p>0 then begin
 delete(str,1,p+2);
 ctz:=str;
end;
cmd.Free;
for i:=0 to cmain.ObsNameList.Count-1 do begin
  str:=cmain.ObsNameList[i];
  buf:=trim(TObsDetail(cmain.ObsNameList.Objects[i]).country);
  if buf<>'' then str:=buf+'/'+str;
  if str=cobs then addcobs:=false;
  str:=str+'='+DEtoStr3(TObsDetail(cmain.ObsNameList.Objects[i]).lat)+';';
  str:=str+DEtoStr3(TObsDetail(cmain.ObsNameList.Objects[i]).lon)+';';
  str:=str+FormatFloat(f0,TObsDetail(cmain.ObsNameList.Objects[i]).alt)+'m;';
  str:=str+TzGMT2UTC(TObsDetail(cmain.ObsNameList.Objects[i]).tz);
  list.Add(str);
end;
if addcobs then begin
 str:=cobs+'='+clat+';'+clon+';'+calt+';'+ctz;
 list.Insert(0,str);
end;
result:=(list.Count>0);
end;

function Tf_scriptengine.doOpenFile(fn:string):boolean;
var i: integer;
begin
  i:=ExecuteFile(fn);
  result:=(i=0);
end;

function Tf_scriptengine.doRun(cmdline:string):boolean;
begin
  ExecNoWait(cmdline,'',true);
  result:=true;
end;

function Tf_scriptengine.doRunOutput(cmdline:string; var output:TStringlist):boolean;
var i: integer;
begin
  i:=ExecProcess(cmdline,output,false);
  result:=(i=0);
end;

function Tf_scriptengine.doGetS(varname:string; var str: string):Boolean;
begin
  result:=true;
  varname:=uppercase(varname);
  if varname='CHARTNAME' then str:=ChartName
  else if varname='REFRESHTEXT' then str:=RefreshText
  else if varname='SELECTIONTEXT' then str:=SelectionText
  else if varname='DESCRIPTIONTEXT' then str:=DescriptionText
  else if varname='DISTANCETEXT' then str:=DistanceText
  else if varname='STR1' then str:=slist[0]
  else if varname='STR2' then str:=slist[1]
  else if varname='STR3' then str:=slist[2]
  else if varname='STR4' then str:=slist[3]
  else if varname='STR5' then str:=slist[4]
  else if varname='STR6' then str:=slist[5]
  else if varname='STR7' then str:=slist[6]
  else if varname='STR8' then str:=slist[7]
  else if varname='STR9' then str:=slist[8]
  else if varname='STR10' then str:=slist[9]
  else result:=false;
end;

function Tf_scriptengine.doSetS(varname:string; str: string):Boolean;
begin
  result:=true;
  varname:=uppercase(varname);
  if varname='STR1' then slist[0]:=str
  else if varname='STR2' then slist[1]:=str
  else if varname='STR3' then slist[2]:=str
  else if varname='STR4' then slist[3]:=str
  else if varname='STR5' then slist[4]:=str
  else if varname='STR6' then slist[5]:=str
  else if varname='STR7' then slist[6]:=str
  else if varname='STR8' then slist[7]:=str
  else if varname='STR9' then slist[8]:=str
  else if varname='STR10' then slist[9]:=str
  else if varname='RESERVED' then reservedslist:=str
  else result:=false;
end;

function Tf_scriptengine.doGetSL(varname:string; var strl: TStringList):Boolean;
begin
result:=true;
varname:=uppercase(varname);
if varname='STRL1' then strl:=strllist[0]
else if varname='STRL2' then strl:=strllist[1]
else if varname='STRL3' then strl:=strllist[2]
else if varname='STRL4' then strl:=strllist[3]
else if varname='STRL5' then strl:=strllist[4]
else if varname='STRL6' then strl:=strllist[5]
else if varname='STRL7' then strl:=strllist[6]
else if varname='STRL8' then strl:=strllist[7]
else if varname='STRL9' then strl:=strllist[8]
else if varname='STRL10' then strl:=strllist[9]
else result:=false;
end;

function Tf_scriptengine.doSetSL(varname:string; strl: TStringList):Boolean;
begin
result:=true;
varname:=uppercase(varname);
if varname='STRL1' then strllist[0]:=strl
else if varname='STRL2' then strllist[1]:=strl
else if varname='STRL3' then strllist[2]:=strl
else if varname='STRL4' then strllist[3]:=strl
else if varname='STRL5' then strllist[4]:=strl
else if varname='STRL6' then strllist[5]:=strl
else if varname='STRL7' then strllist[6]:=strl
else if varname='STRL8' then strllist[7]:=strl
else if varname='STRL9' then strllist[8]:=strl
else if varname='STRL10' then strllist[9]:=strl
else result:=false;
end;

function  Tf_scriptengine.doGetD(varname:string; var x: double):boolean;
begin
  result:=true;
  varname:=uppercase(varname);
  if varname='TELESCOPERA' then x:=TelescopeRA
  else if varname='TELESCOPEDE' then x:=TelescopeDE
  else if varname='TIMENOW' then x:=now
  else if varname='DOUBLE1' then x:=dlist[0]
  else if varname='DOUBLE2' then x:=dlist[1]
  else if varname='DOUBLE3' then x:=dlist[2]
  else if varname='DOUBLE4' then x:=dlist[3]
  else if varname='DOUBLE5' then x:=dlist[4]
  else if varname='DOUBLE6' then x:=dlist[5]
  else if varname='DOUBLE7' then x:=dlist[6]
  else if varname='DOUBLE8' then x:=dlist[7]
  else if varname='DOUBLE9' then x:=dlist[8]
  else if varname='DOUBLE10' then x:=dlist[9]
  else result:=false;
end;

function Tf_scriptengine.doSetD(varname:string; x: Double):Boolean;
begin
  result:=true;
  varname:=uppercase(varname);
  if varname='DOUBLE1' then dlist[0]:=x
  else if varname='DOUBLE2' then dlist[1]:=x
  else if varname='DOUBLE3' then dlist[2]:=x
  else if varname='DOUBLE4' then dlist[3]:=x
  else if varname='DOUBLE5' then dlist[4]:=x
  else if varname='DOUBLE6' then dlist[5]:=x
  else if varname='DOUBLE7' then dlist[6]:=x
  else if varname='DOUBLE8' then dlist[7]:=x
  else if varname='DOUBLE9' then dlist[8]:=x
  else if varname='DOUBLE10' then dlist[9]:=x
  else result:=false;
end;

function  Tf_scriptengine.doGetI(varname:string; var i: Integer):Boolean;
begin
  result:=true;
  varname:=uppercase(varname);
  if varname='INT1' then i:=ilist[0]
  else if varname='INT2' then i:=ilist[1]
  else if varname='INT3' then i:=ilist[2]
  else if varname='INT4' then i:=ilist[3]
  else if varname='INT5' then i:=ilist[4]
  else if varname='INT6' then i:=ilist[5]
  else if varname='INT7' then i:=ilist[6]
  else if varname='INT8' then i:=ilist[7]
  else if varname='INT9' then i:=ilist[8]
  else if varname='INT10' then i:=ilist[9]
  else result:=false;
end;

function Tf_scriptengine.doSetI(varname:string; i: Integer):Boolean;
begin
  result:=true;
  varname:=uppercase(varname);
  if varname='INT1' then ilist[0]:=i
  else if varname='INT2' then ilist[1]:=i
  else if varname='INT3' then ilist[2]:=i
  else if varname='INT4' then ilist[3]:=i
  else if varname='INT5' then ilist[4]:=i
  else if varname='INT6' then ilist[5]:=i
  else if varname='INT7' then ilist[6]:=i
  else if varname='INT8' then ilist[7]:=i
  else if varname='INT9' then ilist[8]:=i
  else if varname='INT10' then ilist[9]:=i
  else result:=false;
end;

function Tf_scriptengine.doGetV(varname:string; var v: Variant):Boolean;
begin
  result:=true;
  varname:=uppercase(varname);
  if varname='TELESCOPE1' then v:=vlist[0]
  else if varname='TELESCOPE2' then v:=vlist[1]
  else if varname='DOME1' then v:=vlist[2]
  else if varname='DOME2' then v:=vlist[3]
  else if varname='CAMERA1' then v:=vlist[4]
  else if varname='CAMERA2' then v:=vlist[5]
  else if varname='FOCUSER1' then v:=vlist[6]
  else if varname='FOCUSER2' then v:=vlist[7]
  else if varname='FILTER1' then v:=vlist[8]
  else if varname='FILTER1' then v:=vlist[9]
  else if varname='ROTATOR1' then v:=vlist[10]
  else if varname='ROTATOR2' then v:=vlist[11]
  else if varname='VARIANT1' then v:=vlist[12]
  else if varname='VARIANT2' then v:=vlist[13]
  else if varname='VARIANT3' then v:=vlist[14]
  else if varname='VARIANT4' then v:=vlist[15]
  else if varname='VARIANT5' then v:=vlist[16]
  else if varname='VARIANT6' then v:=vlist[17]
  else if varname='VARIANT7' then v:=vlist[18]
  else if varname='VARIANT8' then v:=vlist[19]
  else if varname='VARIANT9' then v:=vlist[20]
  else if varname='VARIANT10' then v:=vlist[21]
  else result:=false;
end;

function Tf_scriptengine.doSetV(varname:string; v: Variant):Boolean;
begin
  result:=true;
  varname:=uppercase(varname);
  if varname='TELESCOPE1' then vlist[0]:=v
  else if varname='TELESCOPE2' then vlist[1]:=v
  else if varname='DOME1' then vlist[2]:=v
  else if varname='DOME2' then vlist[3] := v
  else if varname='CAMERA1' then vlist[4] := v
  else if varname='CAMERA2' then vlist[5] := v
  else if varname='FOCUSER1' then vlist[6] := v
  else if varname='FOCUSER2' then vlist[7] := v
  else if varname='FILTER1' then vlist[8] := v
  else if varname='FILTER1' then vlist[9] := v
  else if varname='ROTATOR1' then vlist[10] := v
  else if varname='ROTATOR2' then vlist[11] := v
  else if varname='VARIANT1' then vlist[12] := v
  else if varname='VARIANT2' then vlist[13] := v
  else if varname='VARIANT3' then vlist[14] := v
  else if varname='VARIANT4' then vlist[15] := v
  else if varname='VARIANT5' then vlist[16] := v
  else if varname='VARIANT6' then vlist[17] := v
  else if varname='VARIANT7' then vlist[18] := v
  else if varname='VARIANT8' then vlist[19] := v
  else if varname='VARIANT9' then vlist[20] := v
  else if varname='VARIANT10' then vlist[21] := v
  else result:=false;
end;

function Tf_scriptengine.doOpenDialog(var fn: string): boolean;
begin
  opdialog.FileName:=fn;
  result:=opdialog.Execute;
  if result then fn:=opdialog.FileName;
end;

function Tf_scriptengine.doSaveDialog(var fn: string): boolean;
begin
  svdialog.FileName:=fn;
  result:=svdialog.Execute;
  if result then fn:=svdialog.FileName;
end;

function Tf_scriptengine.doCalendarDialog(var dt: double): boolean;
begin
  cadialog.JD:=dt;
  result:=cadialog.Execute;
  if result then dt:=cadialog.JD;
end;

Function Tf_scriptengine.doARtoStr(var ar: Double) : string;
begin
  // script do not work if a float parameter is not var.
  result:=ARtoStr3(ar);
end;

Function Tf_scriptengine.doDEtoStr(var de: Double) : string;
begin
  result:=DEtoStr3(de);
end;

Function Tf_scriptengine.doStrtoAR(str:string; var ar: Double) : boolean;
begin
  if trim(str)<>'' then begin
    ar:=Str3ToAR(str);
    result:=(ar<>0);
  end
  else result:=false;
end;

Function Tf_scriptengine.doStrtoDE(str:string; var de: Double) : boolean;
begin
  if trim(str)<>'' then begin
    str:=StringReplace(str,ldeg,'d',[rfReplaceAll]);
    str:=StringReplace(str,lmin,'m',[rfReplaceAll]);
    str:=StringReplace(str,lsec,'s',[rfReplaceAll]);
    de:=Str3ToDE(str);
    result:=(de<>0);
  end
  else result:=false;
end;

Function Tf_scriptengine.doJDtoStr(var jd: Double) : string;
begin
  result:=jddate(jd);
end;

Function Tf_scriptengine.doStrtoJD(dt:string; var jdt: Double) : boolean;
var sy,y,m,d,p: integer;
    h:double;
begin
result:=false;
sy:=1;
h:=0;
dt:=trim(dt);
if length(dt)>2 then begin
 if dt[1]='-' then begin sy:=-1; delete(dt,1,1); end;
 if dt[1]='+' then begin sy:=1; delete(dt,1,1); end;
end;
p:=pos('-',dt);
if p=0 then exit;
y:=sy*strtoint(trim(copy(dt,1,p-1)));
dt:=copy(dt,p+1,999);
p:=pos('-',dt);
if p=0 then exit;
m:=strtoint(trim(copy(dt,1,p-1)));
dt:=copy(dt,p+1,999);
p:=pos('T',dt);
if p=0 then p:=pos(' ',dt);
if p=0 then d:=strtoint(trim(dt))     // no time part
   else begin
    d:=strtoint(trim(copy(dt,1,p-1)));

   end;
jdt:=jd(y,m,d,h);
end;

procedure Tf_scriptengine.Save(strbtn, strscr, comboscr, eventscr: Tstringlist; var title:string);
var m:TMemoryStream;
   j: integer;
   node:TTreeNode;
   buf,txt,nu: string;
   s:TStringList;
begin
  title:=ScriptTitle.Text;
  s:=TStringList.Create;
  strbtn.Clear;
  m:=TMemoryStream.Create;
  TreeView1.SaveToStream(m);
  m.Position:=0;
  strbtn.LoadFromStream(m);
  m.Free;
  strscr.Clear;
  comboscr.Clear;
  eventscr.Clear;
  node:=TreeView1.Items.GetFirstNode;
  while node<>nil do begin
    buf:=words(node.Text,'',1,1,';');
    txt:=words(buf,'',1,1,'_');
    nu:=words(buf,'',2,1,'_');
    if (txt='Button')and(node.data<>nil)and(TObject(node.data) is TStringList) then begin
      s.Assign(TStringList(node.data));
      for j:=0 to s.count-1 do begin
         strscr.Add(nu+tab+s[j]);
      end;
    end;
    if (txt='Combo')and(node.data<>nil)and(TObject(node.data) is TStringList) then begin
      s.Assign(TStringList(node.data));
      for j:=0 to s.count-1 do begin
         comboscr.Add(nu+tab+s[j]);
      end;
    end;
    if (txt='Event')and(node.data<>nil)and(TObject(node.data) is TStringList) then begin
      s.Assign(TStringList(node.data));
      for j:=0 to s.count-1 do begin
         eventscr.Add(nu+tab+s[j]);
      end;
    end;
    node:=node.GetNext;
  end;
  s.Free;
end;

procedure Tf_scriptengine.Load(strbtn, strscr, comboscr, eventscr: Tstringlist; title:string);
var m:TMemoryStream;
   bu,cnu,nu,scrlin: string;
   i: integer;
   node:TTreeNode;
   s,p:TStringList;
begin
  ScriptTitle.Text:=title;
  // load toolbar
  m:=TMemoryStream.Create;
  strbtn.SaveToStream(m);
  m.Position:=0;
  TreeView1.LoadFromStream(m);
  m.Free;
  p:=TStringList.Create;
  // load button scripts
  cnu:='';
  if strscr.Count>0 then begin
  s:=TStringList.Create;
  for i:=0 to strscr.Count-1 do begin
    bu:=strscr[i];
    SplitRec(bu,tab,p);
    if p.Count<2 then continue;
    nu:=p[0];
    scrlin:=p[1];
    if (cnu='') then cnu:=nu;
    if cnu=nu then begin
      s.Add(scrlin);
    end else begin
      node := TreeView1.Items.GetFirstNode;
      while Assigned(node) and (pos('Button_'+cnu+';',node.Text)<=0) do
            node := node.GetNext;
      if assigned(node) then begin
        node.Data:=s;
      end;
      s:=TStringList.Create;
      s.Add(scrlin);
      cnu:=nu;
    end;
  end;
  if s.Count=0 then s.Free;
  node := TreeView1.Items.GetFirstNode;
  while Assigned(node) and (pos('Button_'+cnu+';',node.Text)<=0) do
        node := node.GetNext;
  if assigned(node) then begin
    node.Data:=s;
  end;
  end;
  // load combo scripts
  cnu:='';
  if comboscr.Count>0 then begin
  s:=TStringList.Create;
  for i:=0 to comboscr.Count-1 do begin
    bu:=comboscr[i];
    SplitRec(bu,tab,p);
    if p.Count<2 then continue;
    nu:=p[0];
    scrlin:=p[1];
    if (cnu='') then cnu:=nu;
    if cnu=nu then begin
      s.Add(scrlin);
    end else begin
      node := TreeView1.Items.GetFirstNode;
      while Assigned(node) and (pos('Combo_'+cnu+';',node.Text)<=0) do
            node := node.GetNext;
      if assigned(node) then begin
        node.Data:=s;
      end;
      s:=TStringList.Create;
      s.Add(scrlin);
      cnu:=nu;
    end;
  end;
  if s.Count=0 then s.Free;
  node := TreeView1.Items.GetFirstNode;
  while Assigned(node) and (pos('Combo_'+cnu+';',node.Text)<=0) do
        node := node.GetNext;
  if assigned(node) then begin
    node.Data:=s;
  end;
  end;

  // load event script
  cnu:='';
  if eventscr.Count>0 then begin
  s:=TStringList.Create;
  for i:=0 to eventscr.Count-1 do begin
    bu:=eventscr[i];
    SplitRec(bu,tab,p);
    if p.Count<2 then continue;
    nu:=p[0];
    scrlin:=p[1];
    if (cnu='') then cnu:=nu;
    if cnu=nu then begin
      s.Add(scrlin);
    end else begin
      node := TreeView1.Items.GetFirstNode;
      while Assigned(node) and (pos('Event_'+cnu+';',node.Text)<=0) do
            node := node.GetNext;
      if assigned(node) then begin
        node.Data:=s;
      end;
      s:=TStringList.Create;
      s.Add(scrlin);
      cnu:=nu;
    end;
  end;
  if s.Count=0 then s.Free;
  node := TreeView1.Items.GetFirstNode;
  while Assigned(node) and (pos('Event_'+cnu+';',node.Text)<=0) do
        node := node.GetNext;
  if assigned(node) then begin
    node.Data:=s;
  end;
  end;

  p.free;
  ButtonApplyClick(nil);
end;


function Tf_scriptengine.GetScriptTranslation(str:string):string;
var testscr:Tstringlist;
    tscr:TPSScript;
begin
testscr:=Tstringlist.create;
testscr.Add('var buf:string;');
testscr.Add('begin');
testscr.Add('buf:='+str+';');
testscr.Add('SetS(''RESERVED'',buf);');
testscr.Add('end.');
tscr:=TPSScript.Create(self);
tscr.OnCompile:=@TplPSScriptCompile;
tscr.OnExecute:=@TplPSScriptExecute;
tscr.OnLine:=@TplPSScriptLine;
tscr.Plugins.Assign(TplPSScript.Plugins);
tscr.Script.Assign(testscr);
tscr.Compile;
tscr.Execute;
tscr.free;
testscr.free;
result:=reservedslist;
end;

procedure Tf_scriptengine.LoadFile(fn: string);
var ConfigScriptButton, ConfigScript, ConfigCombo, ConfigEvent: Tstringlist;
    section,buf,titl,num: string;
    sectionlist,scrlist: Tstringlist;
    inif: TMemIniFile;
    i,j,k,n: integer;
begin
  ConfigScriptButton:=Tstringlist.create;
  ConfigScript:=Tstringlist.create;
  ConfigCombo:=Tstringlist.create;
  ConfigEvent:=Tstringlist.create;
  FScriptFilename:=fn;
  inif:=TMeminifile.create(fn);
  try
  with inif do begin
  if SectionExists('Panel') then begin // New format
    section:='Panel';
    titl:=ReadString(section,'Title',ScriptTitle.Text);
    if copy(titl,1,1)='%' then begin
      delete(titl,1,1);
      titl:=GetScriptTranslation(titl);
    end;
    CheckBoxHidenTimer.Checked:=ReadBool(section,'HidenTimer',CheckBoxHidenTimer.Checked);
    n:=ReadInteger(section,'NumToolbar1',0);
    ConfigToolbar1.Clear;
    for j:=0 to n-1 do ConfigToolbar1.Add(ReadString(section,'toolbar1_'+inttostr(j),''));
    n:=ReadInteger(section,'NumNoolbar2',0);
    ConfigToolbar2.Clear;
    for j:=0 to n-1 do ConfigToolbar2.Add(ReadString(section,'toolbar2_'+inttostr(j),''));
    n:=ReadInteger(section,'NumComponent',0);
    for j:=0 to n-1 do begin
      buf:=ReadString(section,'component_'+inttostr(j),'');
      if buf='' then continue;
      buf:=StringReplace(buf,'"','',[rfReplaceAll]);
      ConfigScriptButton.Add(buf);
    end;
    sectionlist:=Tstringlist.Create;
    scrlist:=Tstringlist.Create;
    ReadSections(sectionlist);
    for j:=0 to sectionlist.Count-1 do begin
      section:=sectionlist[j];
      if pos('button_',section)=1 then begin
         num:=section;
         delete(num,1,7);
         ReadSectionRaw(section,scrlist);
         for k:=0 to scrlist.Count-1 do begin
           buf:=scrlist[k];
           if k=0 then begin
             delete(buf,1,2); // s="..."
           end;
           delete(buf,1,1); //start quote
           delete(buf,length(buf),1); //end quote
           ConfigScript.Add(num+tab+buf);
         end;
         scrlist.Clear;
      end else if pos('combo_',section)=1 then begin
        num:=section;
        delete(num,1,6);
        ReadSectionRaw(section,scrlist);
        for k:=0 to scrlist.Count-1 do begin
          buf:=scrlist[k];
          if k=0 then begin
            delete(buf,1,2); // s="..."
          end;
          delete(buf,1,1); //start quote
          delete(buf,length(buf),1); //end quote
          ConfigCombo.Add(num+tab+buf);
        end;
        scrlist.Clear;
      end else if pos('event_',section)=1 then begin
        num:=section;
        delete(num,1,6);
        ReadSectionRaw(section,scrlist);
        for k:=0 to scrlist.Count-1 do begin
          buf:=scrlist[k];
          if k=0 then begin
            delete(buf,1,2); // s="..."
          end;
          delete(buf,1,1); //start quote
          delete(buf,length(buf),1); //end quote
          ConfigEvent.Add(num+tab+buf);
        end;
        scrlist.Clear;
      end;
    end;
    sectionlist.Free;
    scrlist.Free;

  end else begin // Old format
    section:='ScriptPanel';
    titl:=ReadString(section,'Title','');
    CheckBoxHidenTimer.Checked:=ReadBool(section,'HidenTimer',CheckBoxHidenTimer.Checked);
    n:=ReadInteger(section,'numtoolbar1',0);
    ConfigToolbar1.Clear;
    for j:=0 to n-1 do ConfigToolbar1.Add(ReadString(section,'toolbar1_'+inttostr(j),''));
    n:=ReadInteger(section,'numtoolbar2',0);
    ConfigToolbar2.Clear;
    for j:=0 to n-1 do ConfigToolbar2.Add(ReadString(section,'toolbar2_'+inttostr(j),''));
    n:=ReadInteger(section,'numscriptbutton',0);
    for j:=0 to n-1 do begin
      buf:=ReadString(section,'scriptbutton_'+inttostr(j),'');
      if buf='' then continue;
      buf:=StringReplace(buf,'"','',[rfReplaceAll]);
      ConfigScriptButton.Add(buf);
    end;
    n:=ReadInteger(section,'numscriptrows',0);
    for j:=0 to n-1 do ConfigScript.Add(ReadString(section,'script_'+inttostr(j),''));
    n:=ReadInteger(section,'numcomborows',0);
    for j:=0 to n-1 do ConfigCombo.Add(ReadString(section,'comboscript_'+inttostr(j),''));
    n:=ReadInteger(section,'numevents',0);
    for j:=0 to n-1 do ConfigEvent.Add(ReadString(section,'event_'+inttostr(j),''));
  end;
  end;
  finally
   inif.Free;
  end;
  Load(ConfigScriptButton, ConfigScript, ConfigCombo, ConfigEvent,titl);
  ConfigScriptButton.Free;
  ConfigScript.Free;
  ConfigCombo.Free;
  ConfigEvent.Free;
end;

Function Tf_scriptengine.AddGroup(num,capt:string; pt: TWinControl; ctlperline,ordernum:integer):TGroupBox;
begin
inc(grnum);
SetLength(gr,grnum);
if num='' then num:=inttostr(grnum);
gr[grnum-1]:=TGroupBox.Create(self);
gr[grnum-1].Name:='Group_'+num;
gr[grnum-1].Caption:=capt;
gr[grnum-1].tag:=StrToIntDef(num,0);
gr[grnum-1].AutoSize:=true;
gr[grnum-1].top:=10*ordernum;
gr[grnum-1].Align:=altop;
gr[grnum-1].ChildSizing.EnlargeHorizontal := crsHomogenousChildResize;
gr[grnum-1].ChildSizing.EnlargeVertical := crsHomogenousSpaceResize;
gr[grnum-1].ChildSizing.ShrinkHorizontal := crsHomogenousChildResize;
gr[grnum-1].ChildSizing.ShrinkVertical := crsHomogenousSpaceResize;
gr[grnum-1].ChildSizing.Layout := cclLeftToRightThenTopToBottom;
gr[grnum-1].ChildSizing.ControlsPerLine := ctlperline;
gr[grnum-1].Parent:=pt;
result:=gr[grnum-1];
end;

procedure Tf_scriptengine.AddButton(num,capt:string; pt: TWinControl);
var n: integer;
begin
inc(btnum);
SetLength(bt,btnum);
if num='' then num:=inttostr(btnum);
n:=StrToIntDef(num,btnum);
if capt='' then capt:='Button_'+num;
bt[btnum-1]:=Tbutton.Create(self);
bt[btnum-1].Name:='Button_'+num;
bt[btnum-1].Caption:=capt;
bt[btnum-1].tag:=n;
bt[btnum-1].OnClick:=@Button_Click;
bt[btnum-1].Parent:=pt;
btscrnum:=max(btscrnum,n+1);
SetLength(btscr,btscrnum);
btscr[n]:=TPSScript.Create(self);
btscr[n].tag:=n;
btscr[n].OnCompile:=@TplPSScriptCompile;
btscr[n].OnExecute:=@TplPSScriptExecute;
btscr[n].OnLine:=@TplPSScriptLine;
btscr[n].Plugins.Assign(TplPSScript.Plugins);
end;

procedure Tf_scriptengine.Button_Click(Sender: TObject);
var n: integer;
    ok: boolean;
begin
n:=TButton(sender).tag;
if (n<btscrnum)and(btscr[n].Script.Count>0) then begin
  ok:=btscr[n].Execute;
  if visible then begin
    CompileMemo.Clear;
    if ok then
      CompileMemo.Lines.Add('OK')
    else
      CompileMemo.Lines.Add('Failed! row='+inttostr(btscr[n].ExecErrorRow)+': '+btscr[n].ExecErrorToString);
  end;
end;
end;

procedure Tf_scriptengine.Combo_Change(Sender: TObject);
var n: integer;
    ok: boolean;
begin
n:=TComboBox(sender).tag;
if (n<cbscrnum)and(cbscr[n].Script.Count>0) then begin
  ok:=cbscr[n].Execute;
  if visible then begin
    CompileMemo.Clear;
    if ok then
      CompileMemo.Lines.Add('OK')
    else
      CompileMemo.Lines.Add('Failed! row='+inttostr(cbscr[n].ExecErrorRow)+': '+cbscr[n].ExecErrorToString);
  end;
end;
end;

procedure Tf_scriptengine.AddEdit(num:string; pt: TWinControl);
begin
inc(ednum);
SetLength(ed,ednum);
if num='' then num:=inttostr(ednum);
ed[ednum-1]:=TEdit.Create(self);
ed[ednum-1].Name:='Edit_'+num;
ed[ednum-1].tag:=StrToIntDef(num,0);
ed[ednum-1].Text:='';
ed[ednum-1].Parent:=pt;
end;

procedure Tf_scriptengine.AddMemo(num:string; pt: TWinControl;h: integer);
begin
inc(menum);
SetLength(me,menum);
if num='' then num:=inttostr(menum);
me[menum-1]:=TMemo.Create(self);
me[menum-1].Name:='Memo_'+num;
me[menum-1].tag:=StrToIntDef(num,0);
me[menum-1].Constraints.MinHeight:=h;
me[menum-1].Constraints.MaxHeight:=h;
me[menum-1].Height:=h;
me[menum-1].Clear;
me[menum-1].ScrollBars:=ssAutoBoth;
me[menum-1].Parent:=pt;
end;

procedure Tf_scriptengine.AddSpacer(num:string; pt: TWinControl);
begin
inc(spnum);
SetLength(sp,spnum);
if num='' then num:=inttostr(spnum);
sp[spnum-1]:=TPanel.Create(self);
sp[spnum-1].Name:='Spacer_'+num;
sp[spnum-1].tag:=StrToIntDef(num,0);
sp[spnum-1].BevelOuter:=bvNone;
sp[spnum-1].Caption:='';
sp[spnum-1].Parent:=pt;
end;

procedure Tf_scriptengine.AddLabel(num,capt:string; pt: TWinControl);
begin
inc(lbnum);
SetLength(lb,lbnum);
if num='' then num:=inttostr(lbnum);
lb[lbnum-1]:=TLabel.Create(self);
lb[lbnum-1].Name:='Label_'+num;
lb[lbnum-1].tag:=StrToIntDef(num,0);
lb[lbnum-1].Caption:=capt;
lb[lbnum-1].Parent:=pt;
end;

procedure Tf_scriptengine.AddCombo(num:string; pt: TWinControl);
var n: integer;
begin
inc(cbnum);
SetLength(cb,cbnum);
if num='' then num:=inttostr(cbnum);
n:=StrToIntDef(num,cbnum);
cb[cbnum-1]:=TComboBox.Create(self);
cb[cbnum-1].Name:='Combo_'+num;
cb[cbnum-1].tag:=n;
cb[cbnum-1].Text:='';
cb[cbnum-1].OnChange:=@Combo_Change;
cb[cbnum-1].Parent:=pt;
cbscrnum:=max(cbscrnum,n+1);
SetLength(cbscr,cbscrnum);
cbscr[n]:=TPSScript.Create(self);
cbscr[n].tag:=n;
cbscr[n].OnCompile:=@TplPSScriptCompile;
cbscr[n].OnExecute:=@TplPSScriptExecute;
cbscr[n].OnLine:=@TplPSScriptLine;
cbscr[n].Plugins.Assign(TplPSScript.Plugins);
end;

procedure Tf_scriptengine.AddList(num:string; pt: TWinControl;h: integer);
begin
inc(lsnum);
SetLength(ls,lsnum);
if num='' then num:=inttostr(lsnum);
ls[lsnum-1]:=TListBox.Create(self);
ls[lsnum-1].Name:='List_'+num;
ls[lsnum-1].tag:=StrToIntDef(num,0);
ls[lsnum-1].Constraints.MinHeight:=h;
ls[lsnum-1].Constraints.MaxHeight:=h;
ls[lsnum-1].Height:=h;
ls[lsnum-1].Parent:=pt;
end;

procedure Tf_scriptengine.AddCheckList(num:string; pt: TWinControl;h: integer);
begin
inc(cknum);
SetLength(ck,cknum);
if num='' then num:=inttostr(cknum);
ck[cknum-1]:=TCheckListBox.Create(self);
ck[cknum-1].Name:='CheckList_'+num;
ck[cknum-1].tag:=StrToIntDef(num,0);
ck[cknum-1].Constraints.MinHeight:=h;
ck[cknum-1].Constraints.MaxHeight:=h;
ck[cknum-1].Height:=h;
ck[cknum-1].Parent:=pt;
end;

procedure Tf_scriptengine.ReorderGroup;
var i: integer;
begin
FEditSurface.DisableAlign;
for i:=0 to grnum-1 do begin
  gr[i].top:=10*i;
end;
FEditSurface.EnableAlign;
end;

Procedure Tf_scriptengine.StopAllScript;
var i:integer;
begin
EventTimer.Enabled:=false;
for i:=0 to btscrnum-1 do if (btscr[i]<>nil) and btscr[i].Running then btscr[i].Stop;
for i:=0 to cbscrnum-1 do if (cbscr[i]<>nil) and cbscr[i].Running then cbscr[i].Stop;
for i:=0 to evscrnum-1 do if (evscr[i]<>nil) and evscr[i].Running then evscr[i].Stop;
EventTimer.Enabled:=false;
FEventReady:=false;
end;

procedure Tf_scriptengine.StartTimer;
begin
EventTimer.Enabled:=FTimerReady;
end;

procedure Tf_scriptengine.ButtonApplyClick(Sender: TObject);
var node:TTreeNode;
   curgroup:TGroupBox;
   txt,parm1,parm2,buf,nu: string;
   i,groupseq: integer;
begin
StopAllScript;
for i:=cknum-1 downto 0 do ck[i].Free;
for i:=lsnum-1 downto 0 do ls[i].Free;
for i:=cbnum-1 downto 0 do cb[i].Free;
for i:=spnum-1 downto 0 do sp[i].Free;
for i:=lbnum-1 downto 0 do lb[i].Free;
for i:=menum-1 downto 0 do me[i].Free;
for i:=ednum-1 downto 0 do ed[i].Free;
for i:=btnum-1 downto 0 do bt[i].Free;
for i:=grnum-1 downto 0 do gr[i].Free;
btnum:=0; SetLength(bt,0);
ednum:=0; SetLength(ed,0);
menum:=0; SetLength(me,0);
spnum:=0; SetLength(sp,0);
lbnum:=0; SetLength(lb,0);
cbnum:=0; SetLength(cb,0);
lsnum:=0; SetLength(ls,0);
cknum:=0; SetLength(ck,0);
grnum:=0; SetLength(gr,0);
groupseq:=0;
node:=TreeView1.Items.GetFirstNode;
while node<>nil do begin
  buf:=words(node.Text,'',1,1,';');
  txt:=words(buf,'',1,1,'_');
  nu:=words(buf,'',2,1,'_');
  parm1:=words(node.Text,'',2,1,';');
  parm2:=words(node.Text,'',3,1,';');
  if txt='Group' then begin
    curgroup:=AddGroup(nu,parm1,FEditSurface,StrToIntDef(parm2,1),groupseq);
    GroupIdx:=max(GroupIdx,strtoint(nu));
    inc(groupseq);
  end
  else if txt='Button' then begin
    AddButton(nu,parm1,curgroup);
    ButtonIdx:=max(ButtonIdx,strtoint(nu));
  end
  else if txt='Edit' then begin
    AddEdit(nu,curgroup);
    EditIdx:=max(EditIdx,strtoint(nu));
  end
  else if txt='Memo' then begin
    AddMemo(nu,curgroup,StrToIntDef(parm1,50));
    MemoIdx:=max(MemoIdx,strtoint(nu));
  end
  else if txt='Combo' then begin
    AddCombo(nu,curgroup);
    ComboIdx:=max(ComboIdx,strtoint(nu));
  end
  else if txt='List' then begin
    AddList(nu,curgroup,StrToIntDef(parm1,50));
    ListIdx:=max(ListIdx,strtoint(nu));
  end
  else if txt='CheckList' then begin
    AddCheckList(nu,curgroup,StrToIntDef(parm1,50));
    CheckListIdx:=max(CheckListIdx,strtoint(nu));
  end
  else if txt='Spacer' then begin
    AddSpacer(nu,curgroup);
    SpacerIdx:=max(SpacerIdx,strtoint(nu));
  end
  else if txt='Label' then begin
    AddLabel(nu,parm1,curgroup);
    LabelIdx:=max(LabelIdx,strtoint(nu));
  end;
  node:=node.GetNext;
end;
ReorderGroup;
CompileScripts;
evscr[ord(evInitialisation)].Execute;
evscr[ord(evTranslation)].Execute;
if not InitialLoad then begin
  FEventReady:=true;
  evscr[ord(evActivation)].Execute;
  TelescopeConnectEvent(TelescopeChartName,FTelescopeConnected);
  if CompileMemo.Lines.Count=0 then begin
    CompileMemo.Lines.Add(rsDonTForgetTo);
  end;
end;
if Assigned(FonApply) then FonApply(self);
end;

procedure Tf_scriptengine.ButtonAddClick(Sender: TObject);
var
   buf,txt,num: string;
   ok:boolean;
   node:TTreeNode;
begin
if RadioButtonGroup.Checked then begin
  if (TreeView1.Selected=nil)or((TreeView1.Selected<>nil)and(TreeView1.Selected.Level=0)) then begin
    if isInteger(GroupRowEdit.Text) then begin
      inc(GroupIdx);
      TreeView1.Selected:=TreeView1.Items.Add(TreeView1.Selected,'Group_'+inttostr(GroupIdx)+';'+StringReplace(GroupCaptionEdit.Text,';','',[rfReplaceAll])+';'+IntToStr(StrToIntDef(GroupRowEdit.Text,1)));
    end;
  end;
end else if RadioButtonButton.Checked then begin
  if (TreeView1.Selected<>nil)and(TreeView1.Selected.Level=0) then begin
    inc(ButtonIdx);
    TreeView1.Items.AddChild(TreeView1.Selected,'Button_'+inttostr(ButtonIdx)+';'+StringReplace(ButtonCaptionEdit.Text,';','',[rfReplaceAll]));
  end;
end else if RadioButtonEdit.Checked then begin
  if (TreeView1.Selected<>nil)and(TreeView1.Selected.Level=0) then begin
    inc(EditIdx);
    TreeView1.Items.AddChild(TreeView1.Selected,'Edit_'+inttostr(EditIdx));
  end;
end else if RadioButtonCombo.Checked then begin
  if (TreeView1.Selected<>nil)and(TreeView1.Selected.Level=0) then begin
    inc(ComboIdx);
    TreeView1.Items.AddChild(TreeView1.Selected,'Combo_'+inttostr(ComboIdx)+';');
  end;
end else if RadioButtonList.Checked then begin
  if (TreeView1.Selected<>nil)and(TreeView1.Selected.Level=0) then begin
    inc(ListIdx);
    TreeView1.Items.AddChild(TreeView1.Selected,'List_'+inttostr(ListIdx)+';'+IntToStr(StrToIntDef(ListHeightEdit.Text,50)));
  end;
end else if RadioButtonCheckList.Checked then begin
  if (TreeView1.Selected<>nil)and(TreeView1.Selected.Level=0) then begin
    inc(CheckListIdx);
    TreeView1.Items.AddChild(TreeView1.Selected,'CheckList_'+inttostr(CheckListIdx)+';'+IntToStr(StrToIntDef(CheckListHeightEdit.Text,50)));
  end;
end else if RadioButtonMemo.Checked then begin
  if (TreeView1.Selected<>nil)and(TreeView1.Selected.Level=0) then begin
    if isInteger(MemoHeightEdit.Text) then begin
      inc(MemoIdx);
      TreeView1.Items.AddChild(TreeView1.Selected,'Memo_'+inttostr(MemoIdx)+';'+IntToStr(StrToIntDef(MemoHeightEdit.Text,50)));
    end;
  end;
end else if RadioButtonSpacer.Checked then begin
  if (TreeView1.Selected<>nil)and(TreeView1.Selected.Level=0) then begin
    inc(SpacerIdx);
    TreeView1.Items.AddChild(TreeView1.Selected,'Spacer_'+inttostr(SpacerIdx));
  end;
end else if RadioButtonLabel.Checked then begin
  if (TreeView1.Selected<>nil)and(TreeView1.Selected.Level=0) then begin
    inc(LabelIdx);
    TreeView1.Items.AddChild(TreeView1.Selected,'Label_'+inttostr(LabelIdx)+';'+StringReplace(LabelCaptionEdit.Text,';','',[rfReplaceAll]));
  end;
end else if RadioButtonEvent.Checked then begin
  if (TreeView1.Selected<>nil)and(TreeView1.Selected.Level=0) then begin
    ok:=true;
    node:=TreeView1.Items.GetFirstNode;
    // check for a single event type per script page
    while node<>nil do begin
      buf:=words(node.Text,'',1,1,';');
      txt:=words(buf,'',1,1,'_');
      num:=words(node.Text,'',2,1,';');
      if (txt='Event')and(num=IntToStr(EventComboBox.ItemIndex)) then begin
          ok:=false;
          break;
      end;
      node:=node.GetNext;
    end;
    if ok then begin
      num:=IntToStr(EventComboBox.ItemIndex);
      if EventComboBox.ItemIndex=ord(evTimer) then txt:=IntToStr(StrToIntDef(TimerIntervalEdit.Text,60))
         else txt:='';
      TreeView1.Items.AddChild(TreeView1.Selected,'Event_'+num+';'+num+';'+EventComboBox.Text+';'+txt);
    end;
  end;
end;
end;



procedure Tf_scriptengine.ButtonUpdateClick(Sender: TObject);
var txt: string;
begin
if (TreeView1.Selected<>nil) then begin
  if RadioButtonGroup.Checked then begin
    TreeView1.Selected.Text:=words(TreeView1.Selected.Text,'',1,1,';')+';'+StringReplace(GroupCaptionEdit.Text,';','',[rfReplaceAll])+';'+IntToStr(StrToIntDef(GroupRowEdit.Text,1));
  end else if RadioButtonButton.Checked then begin
    TreeView1.Selected.Text:=words(TreeView1.Selected.Text,'',1,1,';')+';'+StringReplace(ButtonCaptionEdit.Text,';','',[rfReplaceAll]);
  end else if RadioButtonEdit.Checked then begin
     //
  end else if RadioButtonMemo.Checked then begin
    TreeView1.Selected.Text:=words(TreeView1.Selected.Text,'',1,1,';')+';'+IntToStr(StrToIntDef(MemoHeightEdit.Text,50));
  end else if RadioButtonList.Checked then begin
    TreeView1.Selected.Text:=words(TreeView1.Selected.Text,'',1,1,';')+';'+IntToStr(StrToIntDef(ListHeightEdit.Text,50));
  end else if RadioButtonCheckList.Checked then begin
    TreeView1.Selected.Text:=words(TreeView1.Selected.Text,'',1,1,';')+';'+IntToStr(StrToIntDef(CheckListHeightEdit.Text,50));
  end else if RadioButtonSpacer.Checked then begin
     //
  end else if RadioButtonLabel.Checked then begin
    TreeView1.Selected.Text:=words(TreeView1.Selected.Text,'',1,1,';')+';'+StringReplace(LabelCaptionEdit.Text,';','',[rfReplaceAll]);
  end else if RadioButtonEvent.Checked then begin
    if EventComboBox.ItemIndex=ord(evTimer) then txt:=IntToStr(StrToIntDef(TimerIntervalEdit.Text,60))
       else txt:='';
    TreeView1.Selected.Text:=words(TreeView1.Selected.Text,'',1,1,';')+';'+IntToStr(EventComboBox.ItemIndex)+';'+EventComboBox.Text+';'+txt;
  end;
end;
end;

procedure Tf_scriptengine.EventComboBoxChange(Sender: TObject);
begin
  ButtonUpdate.Visible:=false;
  TimerIntervalEdit.Visible:=(EventComboBox.ItemIndex=ord(evTimer));
end;

procedure Tf_scriptengine.GroupCaptionEditChange(Sender: TObject);
begin
  if ButtonUpdate.Tag=1 then ButtonUpdate.Visible:=true;
end;

procedure Tf_scriptengine.GroupRowEditChange(Sender: TObject);
begin
  ButtonUpdate.Visible:=(isInteger(GroupRowEdit.Text))and(ButtonUpdate.Tag=1);
end;

procedure Tf_scriptengine.ListHeightEditChange(Sender: TObject);
begin
  ButtonUpdate.Visible:=(isInteger(ListHeightEdit.Text))and(ButtonUpdate.Tag=5);
end;

procedure Tf_scriptengine.CheckListHeightEditChange(Sender: TObject);
begin
  ButtonUpdate.Visible:=(isInteger(CheckListHeightEdit.Text))and(ButtonUpdate.Tag=6);
end;

procedure Tf_scriptengine.MemoHeightEditChange(Sender: TObject);
begin
  ButtonUpdate.Visible:=(isInteger(MemoHeightEdit.Text))and(ButtonUpdate.Tag=3);
end;

procedure Tf_scriptengine.TimerIntervalEditClick(Sender: TObject);
begin
  ButtonUpdate.Visible:=(isInteger(TimerIntervalEdit.Text))and(ButtonUpdate.Tag=4);
end;

procedure Tf_scriptengine.RadioButtonClick(Sender: TObject);
begin
  ButtonUpdate.Tag:=0;
  ButtonUpdate.Visible:=false;
  TimerIntervalEdit.Visible:=(EventComboBox.ItemIndex=ord(evTimer));
end;

procedure Tf_scriptengine.ButtonCaptionEditChange(Sender: TObject);
begin
  if ButtonUpdate.Tag=2 then ButtonUpdate.Visible:=true;
end;

procedure Tf_scriptengine.LabelCaptionEditChange(Sender: TObject);
begin
  if ButtonUpdate.Tag=8 then ButtonUpdate.Visible:=true;
end;

procedure Tf_scriptengine.TreeView1Change(Sender: TObject; Node: TTreeNode);
begin
ButtonUpdate.Tag:=0;
if node<>nil then begin
  if (pos('Group_',node.Text)=1) then begin
    ButtonEditScript.Visible:=false;
    RadioButtonGroup.Checked:=true;
    GroupCaptionEdit.Text:=words(node.Text,'',2,1,';');
    GroupRowEdit.Text:=words(node.Text,'',3,1,';');
    ButtonUpdate.Visible:=false;
    ButtonUpdate.Tag:=1;
  end else if (pos('Button_',node.Text)=1) then begin
    ButtonEditScript.Visible:=true;
    RadioButtonButton.Checked:=true;
    ButtonCaptionEdit.Text:=words(node.Text,'',2,1,';');
    ButtonUpdate.Visible:=false;
    ButtonUpdate.Tag:=2;
  end else if (pos('Edit_',node.Text)=1) then begin
    ButtonEditScript.Visible:=false;
    ButtonUpdate.Visible:=false;
    RadioButtonEdit.Checked:=true;
  end else if (pos('Memo_',node.Text)=1) then begin
    ButtonEditScript.Visible:=false;
    RadioButtonMemo.Checked:=true;
    MemoHeightEdit.Text:=words(node.Text,'',2,1,';');
    ButtonUpdate.Visible:=false;
    ButtonUpdate.Tag:=3;
  end else if (pos('Combo_',node.Text)=1) then begin
    ButtonEditScript.Visible:=true;
    RadioButtonCombo.Checked:=true;
    ButtonUpdate.Visible:=false;
    ButtonUpdate.Tag:=7;
  end else if (pos('List_',node.Text)=1) then begin
    ButtonEditScript.Visible:=false;
    RadioButtonList.Checked:=true;
    ListHeightEdit.Text:=words(node.Text,'',2,1,';');
    ButtonUpdate.Visible:=false;
    ButtonUpdate.Tag:=5;
  end else if (pos('CheckList_',node.Text)=1) then begin
    ButtonEditScript.Visible:=false;
    RadioButtonCheckList.Checked:=true;
    CheckListHeightEdit.Text:=words(node.Text,'',2,1,';');
    ButtonUpdate.Visible:=false;
    ButtonUpdate.Tag:=6;
  end else if (pos('Spacer_',node.Text)=1) then begin
    ButtonEditScript.Visible:=false;
    ButtonUpdate.Visible:=false;
    RadioButtonSpacer.Checked:=true;
  end else if (pos('Label_',node.Text)=1) then begin
    ButtonEditScript.Visible:=false;
    RadioButtonLabel.Checked:=true;
    LabelCaptionEdit.Text:=words(node.Text,'',2,1,';');
    ButtonUpdate.Visible:=false;
    ButtonUpdate.Tag:=8;
  end else if (pos('Event_',node.Text)=1) then begin
    ButtonEditScript.Visible:=true;
    RadioButtonEvent.Checked:=true;
    EventComboBox.ItemIndex:=StrToIntDef(words(node.Text,'',2,1,';'),0);
    TimerIntervalEdit.Visible:=(EventComboBox.ItemIndex=ord(evTimer));
    if (EventComboBox.ItemIndex=ord(evTimer)) then TimerIntervalEdit.Text:=words(node.Text,'',4,1,';');
    ButtonUpdate.Visible:=false;
    ButtonUpdate.Tag:=4;
  end;
end;
end;

procedure Tf_scriptengine.TreeView1DragDrop(Sender, Source: TObject; X, Y: Integer);
var
  DestNode  : TTreeNode;
begin
  if (Source=Sender)and(Sender is TTreeView)and(Assigned(TTreeView(Sender).Selected)) then begin
    DestNode:=TTreeView(Sender).GetNodeAt(x,y);
    if (DestNode<>TTreeView(Sender).Selected) then begin
      if DestNode.Level=TTreeView(Sender).Selected.Level then
         TTreeView(Sender).Selected.MoveTo(DestNode, naInsert)
      else if DestNode.Level<TTreeView(Sender).Selected.Level then
         TTreeView(Sender).Selected.MoveTo(DestNode, naAddChild)
    end;
  end;
end;

procedure Tf_scriptengine.TreeView1DragOver(Sender, Source: TObject; X, Y: Integer; State: TDragState; var Accept: Boolean);
var
  DestNode: TTreeNode;
begin
  accept:=false;
  if (Source=Sender)and(Sender is TTreeView)and(Assigned(TTreeView(Sender).Selected)) then begin
     DestNode := TTreeView(Sender).GetNodeAt(x,y);
     if Assigned(DestNode)and(DestNode<>TTreeView(Sender).Selected) then accept:=(DestNode.Level<=TTreeView(Sender).Selected.Level);
  end;
end;


procedure Tf_scriptengine.ButtonDeleteClick(Sender: TObject);
begin
if TreeView1.Selected<>nil then begin
  if MessageDlg(Format(rsDeleteAllThe, [TreeView1.Selected.Text]),mtConfirmation, mbYesNo, 0)=mrYes then begin
    TreeView1.Items.Delete(TreeView1.Selected);
  end;
end;
end;

procedure Tf_scriptengine.ButtonHelpClick(Sender: TObject);
begin
  ShowHelp;
end;

procedure Tf_scriptengine.ButtonLoadClick(Sender: TObject);
var fn: string;
begin
if OpenDialog1.Execute then begin
  fn:=OpenDialog1.FileName;
  LoadFile(fn);
end;
end;

procedure Tf_scriptengine.ButtonSaveClick(Sender: TObject);
var ConfigScriptButton, ConfigScript, ConfigCombo, ConfigEvent: Tstringlist;
    fn,section,scrsect,scrline,titl,num,pnum,buf: string;
    inif: TMemIniFile;
    j,n,p: integer;
begin
SaveDialog1.FileName:=FScriptFilename;
if SaveDialog1.Execute then begin
  fn:=SaveDialog1.FileName;
  FScriptFilename:=fn;
  ConfigScriptButton:=Tstringlist.create;
  ConfigScript:=Tstringlist.create;
  ConfigCombo:=Tstringlist.create;
  ConfigEvent:=Tstringlist.create;
  Save(ConfigScriptButton, ConfigScript, ConfigCombo, ConfigEvent,titl);
  inif:=TMeminifile.create(fn);
  inif.Clear;
  try
  with inif do begin
  section:='Panel';
  EraseSection(section);
  WriteString(section,'Title',titl);
  WriteBool(section,'HidenTimer',CheckBoxHidenTimer.Checked);
  n:=ConfigToolbar1.Count;
  WriteInteger(section,'NumToolbar1',n);
  for j:=0 to n-1 do WriteString(section,'toolbar1_'+inttostr(j),ConfigToolbar1[j]);
  n:=ConfigToolbar2.Count;
  WriteInteger(section,'NumToolbar2',n);
  for j:=0 to n-1 do WriteString(section,'toolbar2_'+inttostr(j),ConfigToolbar2[j]);
  n:=ConfigScriptButton.Count;
  WriteInteger(section,'NumComponent',n);
  for j:=0 to n-1 do WriteString(section,'component_'+inttostr(j),'"'+ConfigScriptButton[j]+'"');
  // button script
  n:=ConfigScript.Count;
  pnum:='';
  scrline:=''; scrsect:='';
  for j:=0 to n-1 do begin
    buf:=ConfigScript[j];
    p:=pos(tab,buf);
    num:=copy(buf,1,p-1);
    delete(buf,1,p);
    if num=pnum then begin
      scrline:=scrline+'"'+buf+'"'+crlf;
    end else begin
      if scrline>'' then WriteString(scrsect,'s',scrline);
      pnum:=num;
      scrsect:='button_'+num;
      scrline:='"'+buf+'"'+crlf;
    end;
  end;
  if scrline>'' then WriteString(scrsect,'s',scrline);
  // Combo script
  n:=ConfigCombo.Count;
  pnum:='';
  scrline:=''; scrsect:='';
  for j:=0 to n-1 do begin
    buf:=ConfigCombo[j];
    p:=pos(tab,buf);
    num:=copy(buf,1,p-1);
    delete(buf,1,p);
    if num=pnum then begin
      scrline:=scrline+'"'+buf+'"'+crlf;
    end else begin
      if scrline>'' then WriteString(scrsect,'s',scrline);
      pnum:=num;
      scrsect:='combo_'+num;
      scrline:='"'+buf+'"'+crlf;
    end;
  end;
  if scrline>'' then WriteString(scrsect,'s',scrline);
  // Events
  n:=ConfigEvent.Count;
  pnum:='';
  scrline:=''; scrsect:='';
  for j:=0 to n-1 do begin
    buf:=ConfigEvent[j];
    p:=pos(tab,buf);
    num:=copy(buf,1,p-1);
    delete(buf,1,p);
    if num=pnum then begin
      scrline:=scrline+'"'+buf+'"'+crlf;
    end else begin
      if scrline>'' then WriteString(scrsect,'s',scrline);
      pnum:=num;
      scrsect:='event_'+num;
      scrline:='"'+buf+'"'+crlf;
    end;
  end;
  if scrline>'' then WriteString(scrsect,'s',scrline);
  Updatefile;
  end;
  finally
   inif.Free;
  end;
  ConfigScriptButton.Free;
  ConfigScript.Free;
  ConfigEvent.Free;
end;
end;

procedure Tf_scriptengine.ButtonUpClick(Sender: TObject);
var node: TTreeNode;
    i: integer;
begin
node:=TreeView1.Selected;
if node<>nil then begin
  i:=node.Index;
  if i>0 then node.Index:=i-1;
end;
end;

procedure Tf_scriptengine.ButtonDownClick(Sender: TObject);
var node: TTreeNode;
    i,imax: integer;
begin
node:=TreeView1.Selected;
if node.Parent=nil then
   imax:=TreeView1.Items.GetLastNode.Index
else
   imax:=node.Parent.GetLastSubChild.Index ;
if node<>nil then begin
  i:=node.Index;
  if i<(imax) then node.Index:=i+1;
end;
end;

procedure Tf_scriptengine.ButtonEditScriptClick(Sender: TObject);
var s:TStringList;
   txt:string;
   node:TTreeNode;
begin
if (TreeView1.Selected<>nil) then begin
  txt:=copy(TreeView1.Selected.Text,1,6);
  if (txt='Button')or(txt='Combo_')or(txt='Event_') then begin
    node:=TreeView1.Selected;
    if (node.data<>nil)and(TObject(node.data) is TStringList) then
       s:=(TStringList(node.data))
    else
       s:=TStringList.Create;
    if Fpascaleditor=nil then begin
      Fpascaleditor:=Tf_pascaleditor.Create(self);
      dbgscr:=TPSScriptDebugger.Create(self);
      dbgscr.OnCompile:=@TplPSScriptCompile;
      dbgscr.OnExecute:=@TplPSScriptExecute;
      dbgscr.Plugins.Assign(TplPSScript.Plugins);
      Fpascaleditor.DebugScript:=dbgscr;
    end;
    Fpascaleditor.ScriptName:=TreeView1.Selected.Text;
    Fpascaleditor.SynEdit1.Lines.Assign(s);
    FormPos(Fpascaleditor,mouse.cursorpos.x,mouse.cursorpos.y);
    Fpascaleditor.ShowModal;
    if Fpascaleditor.ModalResult=mrOK then begin
      s.Assign(Fpascaleditor.SynEdit1.Lines);
      node.Data:=s;
    end;
  end;
end;
end;

procedure Tf_scriptengine.CompileScripts;
var i,j,n: integer;
    buf,txt,nu,parm: string;
    node:TTreeNode;
    ok: boolean;
begin
CompileMemo.Clear;
EventTimer.Enabled:=false;
FTimerReady:=false;
FEventReady:=false;
for i:=0 to evscrnum-1 do begin evscr[i].Script.Clear; evscr[i].Exec.Clear; end;
node:=TreeView1.Items.GetFirstNode;
while node<>nil do begin
  buf:=words(node.Text,'',1,1,';');
  txt:=words(buf,'',1,1,'_');
  nu:=words(buf,'',2,1,'_');
  if (txt='Button')and(node.data<>nil)and(TObject(node.data) is TStringList) then begin
    n:=strtoint(nu);
    btscr[n].Script.Assign(TStringList(node.data));
    btscr[n].Compile;
    for j:=0 to btscr[n].CompilerMessageCount-1 do CompileMemo.Lines.Add('Script button_'+inttostr(n)+': '+ btscr[n].CompilerErrorToStr(j));
  end
  else if (txt='Combo')and(node.data<>nil)and(TObject(node.data) is TStringList) then begin
    n:=strtoint(nu);
    cbscr[n].Script.Assign(TStringList(node.data));
    cbscr[n].Compile;
    for j:=0 to cbscr[n].CompilerMessageCount-1 do CompileMemo.Lines.Add('Script button_'+inttostr(n)+': '+ cbscr[n].CompilerErrorToStr(j));
  end
  else if (txt='Event')and(node.data<>nil)and(TObject(node.data) is TStringList) then begin
    n:=strtoint(nu);
    evscr[n].Script.Assign(TStringList(node.data));
    ok:=evscr[n].Compile;
    for j:=0 to evscr[n].CompilerMessageCount-1 do CompileMemo.Lines.Add('Script event_'+inttostr(n)+': '+ evscr[n].CompilerErrorToStr(j));
    if (n=ord(evTimer)) then begin // Timer
      parm:=words(node.Text,'',4,1,';');
      i:=StrToIntDef(parm,60);
      EventTimer.Interval:=i*1000;
      FTimerReady:=ok;
    end;
  end;
  node:=node.GetNext;
end;
if visible then StartTimer;
end;

procedure Tf_scriptengine.FormCreate(Sender: TObject);
var i: integer;
begin
  grnum:=0;
  btnum:=0;
  ednum:=0;
  cbnum:=0;
  lsnum:=0;
  cknum:=0;
  menum:=0;
  spnum:=0;
  lbnum:=0;
  btscrnum:=0;
  cbscrnum:=0;
  GroupIdx:=0;
  ButtonIdx:=0;
  EditIdx:=0;
  MemoIdx:=0;
  ComboIdx:=0;
  ListIdx:=0;
  CheckListIdx:=0;
  SpacerIdx:=0;
  LabelIdx:=0;
  {$ifdef mswindows}
    PSImport_ComObj1:=TPSImport_ComObj.Create(self);
    TPSPluginItem(TplPSScript.Plugins.Add).Plugin:=PSImport_ComObj1;
  {$endif}
  FTimerReady:=false;
  FEventReady:=false;
  InitialLoad:=true;
  FTelescopeConnected:=false;
  SetLength(vlist,22);
  SetLength(ilist,10);
  SetLength(dlist,10);
  SetLength(slist,10);
  SetLength(strllist,10);
  for i:=0 to 9 do strllist[i]:=TStringList.Create;
  for i:=0 to maxscriptsock do socklist[i]:=TScriptSocket.Create;
  EventComboBox.ItemIndex:=0;
  evscrnum:=ord(High(Teventlist))+1;
  SetLength(evscr,evscrnum);
  for i:=0 to evscrnum-1 do begin
    evscr[i]:=TPSScript.Create(self);
    evscr[i].tag:=i;
    evscr[i].OnCompile:=@TplPSScriptCompile;
    evscr[i].OnExecute:=@TplPSScriptExecute;
    evscr[i].Plugins.Assign(TplPSScript.Plugins);
  end;
  opdialog:=TOpenDialog.Create(self);
  svdialog:=TSaveDialog.Create(self);
  cadialog:=TJDCalendarDialog.Create(nil);
  SetLang;
end;

procedure Tf_scriptengine.ClearTreeView;
var buf,txt: string;
    node:TTreeNode;
begin
node:=TreeView1.Items.GetFirstNode;
while node<>nil do begin
  buf:=words(node.Text,'',1,1,';');
  txt:=words(buf,'',1,1,'_');
  if (txt='Button')and(node.data<>nil)and(TObject(node.data) is TStringList) then begin
     TStringList(node.data).Free;
  end;
  if (txt='Combo')and(node.data<>nil)and(TObject(node.data) is TStringList) then begin
     TStringList(node.data).Free;
  end;
  if (txt='Event')and(node.data<>nil)and(TObject(node.data) is TStringList) then begin
     TStringList(node.data).Free;
  end;
  node:=node.GetNext;
end;
TreeView1.Items.Clear;
GroupIdx:=0;
ButtonIdx:=0;
EditIdx:=0;
MemoIdx:=0;
SpacerIdx:=0;
EventIdx:=0;
end;

procedure Tf_scriptengine.FormDestroy(Sender: TObject);
var i : integer;
begin
  ClearTreeView;
  TreeView1.free;
  opdialog.Free;
  svdialog.Free;
  cadialog.Free;
  if Fpascaleditor<>nil then Fpascaleditor.Free;
  SetLength(vlist,0);
  SetLength(ilist,0);
  SetLength(dlist,0);
  SetLength(slist,0);
  for i:=0 to 9 do strllist[i].Free;
  SetLength(strllist,0);
  for i:=0 to maxscriptsock do socklist[i].Free;
end;

procedure Tf_scriptengine.FormShow(Sender: TObject);
begin
OpenDialog1.InitialDir:=PrivateScriptDir;
SaveDialog1.InitialDir:=PrivateScriptDir;
CompileMemo.Clear;
end;

procedure Tf_scriptengine.ButtonClearClick(Sender: TObject);
begin
  if MessageDlg(Format(rsDeleteAllThe, [rsAll] ),mtConfirmation, mbYesNo, 0)=mrYes then begin
   ScriptTitle.Text:='';
   ClearTreeView;
end;
end;

procedure Tf_scriptengine.TplPSScriptCompile(Sender: TPSScript);
var i: integer;
  procedure ProcessMenu(Amenu: TMenuItem);
  var k: integer;
  begin
    for k:=0 to Amenu.Count-1 do begin
       TPSScript(Sender).AddRegisteredVariable(Amenu.Items[k].Name, 'TMenuItem');
       ProcessMenu(Amenu[k]);
    end;
  end;

begin
with Sender as TPSScript do begin
  for i:=1 to grnum do AddRegisteredVariable(gr[i-1].Name, 'TGroupbox');
  for i:=1 to btnum do AddRegisteredVariable(bt[i-1].Name, 'TButton');
  for i:=1 to ednum do AddRegisteredVariable(ed[i-1].Name, 'TEdit');
  for i:=1 to menum do AddRegisteredVariable(me[i-1].Name, 'TMemo');
  for i:=1 to cbnum do AddRegisteredVariable(cb[i-1].Name, 'TComboBox');
  for i:=1 to lsnum do AddRegisteredVariable(ls[i-1].Name, 'TListBox');
  for i:=1 to cknum do AddRegisteredVariable(ck[i-1].Name, 'TCheckListBox');
  comp.AddConstantN('deg2rad', 'extended').SetExtended(deg2rad);
  comp.AddConstantN('rad2deg', 'extended').SetExtended(rad2deg);
  AddMethod(self, @Tf_scriptengine.doExecuteCmd, 'function  Cmd(cname:string; arg:Tstringlist):string;');
  AddMethod(self, @Tf_scriptengine.doGetS, 'function GetS(varname:string; var str: string):Boolean;');
  AddMethod(self, @Tf_scriptengine.doSetS, 'function SetS(varname:string; str: string):Boolean;');
  AddMethod(self, @Tf_scriptengine.doSetSL, 'function SetSL(varname:string; strl: TStringList):Boolean;');
  AddMethod(self, @Tf_scriptengine.doGetSL, 'function GetSL(varname:string; var strl: TStringList):Boolean;');
  AddMethod(self, @Tf_scriptengine.doGetI, 'function GetI(varname:string; var i: Integer):Boolean;');
  AddMethod(self, @Tf_scriptengine.doSetI, 'function SetI(varname:string; i: Integer):Boolean;');
  AddMethod(self, @Tf_scriptengine.doGetD, 'function GetD(varname:string; var x: double):boolean;');
  AddMethod(self, @Tf_scriptengine.doSetD, 'function SetD(varname:string; x: Double):Boolean;');
  AddMethod(self, @Tf_scriptengine.doGetV, 'function GetV(varname:string; var v: Variant):Boolean;');
  AddMethod(self, @Tf_scriptengine.doSetV, 'function SetV(varname:string; v: Variant):Boolean;');
  AddMethod(self, @Tf_scriptengine.doOpenDialog, 'function OpenDialog(var fn: string): boolean;');
  AddMethod(self, @Tf_scriptengine.doSaveDialog, 'function SaveDialog(var fn: string): boolean;');
  AddMethod(self, @Tf_scriptengine.doCalendarDialog, 'function CalendarDialog(var dt: double): boolean;');
  AddMethod(self, @Tf_scriptengine.doARtoStr, 'Function ARtoStr(var ar: Double) : string;');
  AddMethod(self, @Tf_scriptengine.doDEtoStr, 'Function DEtoStr(var de: Double) : string;');
  AddMethod(self, @Tf_scriptengine.doStrtoAR, 'Function StrtoAR(str:string; var ar: Double) : boolean;');
  AddMethod(self, @Tf_scriptengine.doStrtoDE, 'Function StrtoDE(str:string; var de: Double) : boolean;');
  AddMethod(self, @Tf_scriptengine.doJDtoStr, 'Function JDtoStr(var jd: Double) : string;');
  AddMethod(self, @Tf_scriptengine.doStrtoJD, 'Function StrtoJD(dt:string; var jdt: Double) : boolean;');
  AddMethod(self, @Tf_scriptengine.doEq2Hz, 'Procedure Eq2Hz(ra,de : double ; var a,h : double);');
  AddMethod(self, @Tf_scriptengine.doHz2Eq, 'Procedure Hz2Eq(a,h : double; var ra,de : double);');
  AddMethod(self, @Tf_scriptengine.doFormatFloat, 'function FormatFloat(Const Format : String; var Value : double) : String;');
  AddMethod(self, @Tf_scriptengine.doStrtoFloatD, 'Procedure StrtoFloatD(str:string; var defval: Double; var val: Double);');
  AddMethod(self, @Tf_scriptengine.doStringReplace, 'function StringReplace(str,s1,s2: String): string;');
  AddMethod(self, @Tf_scriptengine.doFormat, 'Function Format(Const Fmt : String; const Args : Array of const) : String;');
  AddMethod(self, @Tf_scriptengine.doIsNumber, 'function IsNumber(str: String): boolean;');
  AddMethod(self, @Tf_scriptengine.doMsgBox,'function MsgBox(const aMsg: string):boolean;');
  AddMethod(self, @Tf_scriptengine.doShowMessage,'Procedure ShowMessage(const aMsg: string);');
  AddMethod(self, @Tf_scriptengine.doGetCometList,'function GetCometList(const filter: string; maxnum:integer; list:TstringList):boolean;');
  AddMethod(self, @Tf_scriptengine.doCometMark,'function CometMark(list:TstringList):boolean;');
  AddMethod(self, @Tf_scriptengine.doGetAsteroidList,'function GetAsteroidList(const filter: string; maxnum:integer; list:TstringList):boolean;');
  AddMethod(self, @Tf_scriptengine.doAsteroidMark,'function AsteroidMark(list:TstringList):boolean;');
  AddMethod(self, @Tf_scriptengine.doGetScopeRates,'function GetScopeRates(list:TstringList):boolean;');
  AddMethod(self, @Tf_scriptengine.doSendInfo,'procedure SendInfo(origin,str:string);');
  AddMethod(self, @Tf_scriptengine.doGetObservatoryList,'function GetObservatoryList(list:TstringList):boolean;');
  AddMethod(self, @Tf_scriptengine.doOpenFile,'function OpenFile(fn:string):boolean;');
  AddMethod(self, @Tf_scriptengine.doRun,'function Run(cmdline:string):boolean;');
  AddMethod(self, @Tf_scriptengine.doRunOutput,'function RunOutput(cmdline:string; var output:TStringlist):boolean;');
  AddMethod(self, @Tf_scriptengine.doTcpConnect,'function TcpConnect(socknum:integer; ipaddr,port,timeout:string):boolean;');
  AddMethod(self, @Tf_scriptengine.doTcpDisconnect,'function TcpDisconnect(socknum:integer):boolean;');
  AddMethod(self, @Tf_scriptengine.doTcpConnected,'Function TcpConnected(socknum:integer) : boolean;');
  AddMethod(self, @Tf_scriptengine.doTcpReadCount,'Function TcpReadCount(socknum:integer; var buf : string; var count : integer) : boolean;');
  AddMethod(self, @Tf_scriptengine.doTcpRead,'Function TcpRead(socknum:integer; var buf : string; termchar:string) : boolean;');
  AddMethod(self, @Tf_scriptengine.doTcpWrite,'Function TcpWrite(socknum:integer; var buf : string; var count : integer) : boolean;');
  AddMethod(self, @Tf_scriptengine.doTcpPurgeBuffer,'Procedure TcpPurgeBuffer(socknum:integer);');
  AddMethod(self, @Tf_scriptengine.doJsonToStringlist,'procedure JsonToStringlist(jsontxt:string; var SK,SV: TStringList);');

end;
ProcessMenu(FMainmenu.Items);
end;

procedure Tf_scriptengine.PSCustomPlugin1CompileImport1(Sender: TPSScript);
begin
 SIRegister_CheckLst(Sender.Comp);
 SIRegister_translation(Sender.Comp)
end;

procedure Tf_scriptengine.PSCustomPlugin1ExecImport1(Sender: TObject;
  se: TPSExec; x: TPSRuntimeClassImporter);
begin
 RIRegister_CheckLst(x);
 RIRegister_CheckLst_Routines(se);
end;


procedure Tf_scriptengine.TplPSScriptExecute(Sender: TPSScript);
var i: integer;

  procedure ProcessMenu(Amenu: TMenuItem);
  var k: integer;
  begin
    for k:=0 to Amenu.Count-1 do begin
       TPSScript(Sender).SetVarToInstance(Amenu.Items[k].Name, Amenu.Items[k]);
       ProcessMenu(Amenu[k]);
    end;
  end;

begin
with Sender as TPSScript do begin
  for i:=1 to grnum do SetVarToInstance(gr[i-1].Name, gr[i-1]);
  for i:=1 to btnum do SetVarToInstance(bt[i-1].Name, bt[i-1]);
  for i:=1 to ednum do SetVarToInstance(ed[i-1].Name, ed[i-1]);
  for i:=1 to menum do SetVarToInstance(me[i-1].Name, me[i-1]);
  for i:=1 to cbnum do SetVarToInstance(cb[i-1].Name, cb[i-1]);
  for i:=1 to lsnum do SetVarToInstance(ls[i-1].Name, ls[i-1]);
  for i:=1 to cknum do SetVarToInstance(ck[i-1].Name, ck[i-1]);
end;
ProcessMenu(FMainmenu.Items);
end;

procedure Tf_scriptengine.TplPSScriptLine(Sender: TObject);
begin
  Application.ProcessMessages;
end;

procedure Tf_scriptengine.EventTimerTimer(Sender: TObject);
begin
EventTimer.Enabled:=false;
evscr[ord(evTimer)].Execute;
EventTimer.Enabled:=true;
end;

procedure Tf_scriptengine.ChartRefreshEvent(origin,str:string);
begin
if origin<>'' then ChartName:=origin;
RefreshText:=str;
if FEventReady then evscr[ord(evChart_refresh)].Execute;
end;

procedure Tf_scriptengine.ObjectSelectionEvent(origin,str,longstr:string);
begin
if origin<>'' then ChartName:=origin;
SelectionText:=str;
DescriptionText:=longstr;
if FEventReady then
   evscr[ord(evObject_identification)].Execute;
end;

procedure Tf_scriptengine.DistanceMeasurementEvent(origin,str:string);
begin
if origin<>'' then ChartName:=origin;
DistanceText:=str;
if FEventReady then evscr[ord(evDistance_measurement)].Execute;
end;

procedure Tf_scriptengine.TelescopeMoveEvent(origin:string; ra,de: double);
begin
if origin<>'' then ChartName:=origin;
TelescopeRA:=ra;
TelescopeDE:=de;
if FEventReady then evscr[ord(evTelescope_move)].Execute;
end;

procedure Tf_scriptengine.TelescopeConnectEvent(origin:string; connected:boolean);
begin
if origin<>'' then TelescopeChartName:=origin;
FTelescopeConnected:=connected;
if FEventReady then begin
  if connected then evscr[ord(evTelescope_connect)].Execute
     else evscr[ord(evTelescope_disconnect)].Execute;
end;
end;

procedure Tf_scriptengine.ActivateEvent;
begin
if FEventReady then evscr[ord(evActivation)].Execute;
end;

function Tf_scriptengine.doTcpConnect(socknum:integer; ipaddr,port,timeout:string):boolean;
var timout:integer;
begin
result:=false;
if (socknum>=0)and(socknum<=maxscriptsock) then begin
  timout:=StrToIntDef(timeout,100);
  result:=socklist[socknum].Connect(ipaddr,port,timout);
end;
end;

function Tf_scriptengine.doTcpDisconnect(socknum:integer):boolean;
begin
result:=false;
if (socknum>=0)and(socknum<=maxscriptsock) then begin
  result:=socklist[socknum].Disconnect;
end;
end;

Function Tf_scriptengine.doTcpConnected(socknum:integer) : boolean;
begin
result:=false;
if (socknum>=0)and(socknum<=maxscriptsock) then begin
  result:=socklist[socknum].Tcpip_opened;
end;
end;

Function Tf_scriptengine.doTcpReadCount(socknum:integer; var buf : string; var count : integer) : boolean;
begin
result:=false;
if (socknum>=0)and(socknum<=maxscriptsock) then begin
  result:=socklist[socknum].ReadCount(buf,count);
end;
end;

Function Tf_scriptengine.doTcpRead(socknum:integer; var buf : string; termchar:string) : boolean;
begin
result:=false;
if (socknum>=0)and(socknum<=maxscriptsock) then begin
  result:=socklist[socknum].Read(buf,termchar);
end;
end;

Function Tf_scriptengine.doTcpWrite(socknum:integer; var buf : string; var count : integer) : boolean;
begin
result:=false;
if (socknum>=0)and(socknum<=maxscriptsock) then begin
  result:=socklist[socknum].Write(buf,count);
end;
end;

Procedure Tf_scriptengine.doTcpPurgeBuffer(socknum:integer);
begin
if (socknum>=0)and(socknum<=maxscriptsock) then begin
  socklist[socknum].PurgeBuffer;
end;
end;

procedure Tf_scriptengine.JsonDataToStringlist(var SK,SV: TStringList; prefix:string; D : TJSONData);
var i:integer;
    pr,buf:string;
begin
if Assigned(D) then begin
  case D.JSONType of
    jtArray,jtObject: begin
        for i:=0 to D.Count-1 do begin
           if D.JSONType=jtArray then begin
              if prefix='' then pr:=IntToStr(I) else pr:=prefix+'.'+IntToStr(I);
              JsonDataToStringlist(SK,SV,pr,D.items[i]);
           end else begin
              if prefix='' then pr:=TJSONObject(D).Names[i] else pr:=prefix+'.'+TJSONObject(D).Names[i];
              JsonDataToStringlist(SK,SV,pr,D.items[i]);
           end;
        end;
       end;
    jtNull: begin
       SK.Add(prefix);
       SV.Add('null');
    end;
    jtNumber: begin
       SK.Add(prefix);
       buf:=floattostr(D.AsFloat);
       SV.Add(buf);
    end
    else begin
       SK.Add(prefix);
       SV.Add(D.AsString);
    end;
 end;
end;
end;

procedure Tf_scriptengine.doJsonToStringlist(jsontxt:string; var SK,SV: TStringList);
var  J: TJSONData;
begin
J:=GetJSON(jsontxt);
JsonDataToStringlist(SK,SV,'',J);
J.Free;
end;

end.

