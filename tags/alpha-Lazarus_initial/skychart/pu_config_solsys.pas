unit pu_config_solsys;

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

uses  u_constant, u_util, u_projection, cu_database,
  LCLIntf, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Spin, enhedits, StdCtrls, Buttons, ExtCtrls, ComCtrls, LResources, MaskEdit,
  WizardNotebook;

type

  { Tf_config_solsys }

  Tf_config_solsys = class(TForm)
    MainPanel: TPanel;
    Page1: TPage;
    Page2: TPage;
    Page3: TPage;
    Page4: TPage;
    SelectDirectoryDialog1: TSelectDirectoryDialog;
    Label12: TLabel;
    Label131: TLabel;
    PlaParalaxe: TRadioGroup;
    planetdir: TEdit;
    planetdirsel: TBitBtn;
    Label5: TLabel;
    Label89: TLabel;
    Label53: TLabel;
    PlanetBox: TCheckBox;
    PlanetMode: TRadioGroup;
    PlanetBox3: TCheckBox;
    GRS: TFloatEdit;
    BitBtn37: TBitBtn;
    Edit2: TEdit;
    ComPageControl: TPageControl;
    comsetting: TTabSheet;
    GroupBox13: TGroupBox;
    Label154: TLabel;
    Label216: TLabel;
    Label231: TLabel;
    comlimitmag: TFloatEdit;
    showcom: TCheckBox;
    comsymbol: TRadioGroup;
    commagdiff: TFloatEdit;
    comdbset: TButton;
    comload: TTabSheet;
    Label232: TLabel;
    GroupBox14: TGroupBox;
    Label233: TLabel;
    comfile: TEdit;
    Loadcom: TButton;
    comfilebtn: TBitBtn;
    MemoCom: TMemo;
    comdelete: TTabSheet;
    Label238: TLabel;
    GroupBox16: TGroupBox;
    comelemlist: TComboBox;
    DelCom: TButton;
    GroupBox17: TGroupBox;
    Label239: TLabel;
    DelComAll: TButton;
    DelComMemo: TMemo;
    Addsinglecom: TTabSheet;
    Label241: TLabel;
    Label242: TLabel;
    Label243: TLabel;
    Label244: TLabel;
    Label245: TLabel;
    Label246: TLabel;
    Label247: TLabel;
    Label248: TLabel;
    Label249: TLabel;
    Label250: TLabel;
    Label251: TLabel;
    Label253: TLabel;
    Label254: TLabel;
    comid: TEdit;
    comh: TEdit;
    comg: TEdit;
    comep: TEdit;
    comperi: TEdit;
    comnode: TEdit;
    comi: TEdit;
    comec: TEdit;
    comq: TEdit;
    comnam: TEdit;
    comeq: TEdit;
    AddCom: TButton;
    comt: TMaskEdit;
    AstPageControl: TPageControl;
    astsetting: TTabSheet;
    GroupBox9: TGroupBox;
    Label203: TLabel;
    Label212: TLabel;
    Label213: TLabel;
    astlimitmag: TFloatEdit;
    showast: TCheckBox;
    astsymbol: TRadioGroup;
    astmagdiff: TFloatEdit;
    astdbset: TButton;
    astload: TTabSheet;
    Label206: TLabel;
    GroupBox7: TGroupBox;
    Label204: TLabel;
    Label215: TLabel;
    mpcfile: TEdit;
    astnumbered: TCheckBox;
    LoadMPC: TButton;
    mpcfilebtn: TBitBtn;
    aststoperr: TCheckBox;
    astlimitbox: TCheckBox;
    astlimit: TLongEdit;
    MemoMPC: TMemo;
    astprepare: TTabSheet;
    Label210: TLabel;
    GroupBox8: TGroupBox;
    Label7: TLabel;
    Label207: TLabel;
    aststrtdate: TMaskEdit;
    AstCompute: TButton;
    astnummonth: TSpinEdit;
    prepastmemo: TMemo;
    astdelete: TTabSheet;
    Label211: TLabel;
    GroupBox10: TGroupBox;
    astelemlist: TComboBox;
    delast: TButton;
    GroupBox11: TGroupBox;
    Label209: TLabel;
    delallast: TButton;
    delastMemo: TMemo;
    GroupBox12: TGroupBox;
    Label214: TLabel;
    astdeldate: TMaskEdit;
    deldateast: TButton;
    AddsingleAst: TTabSheet;
    Label217: TLabel;
    Label218: TLabel;
    Label219: TLabel;
    Label220: TLabel;
    Label221: TLabel;
    Label222: TLabel;
    Label223: TLabel;
    Label224: TLabel;
    Label225: TLabel;
    Label226: TLabel;
    Label227: TLabel;
    Label228: TLabel;
    Label229: TLabel;
    Label230: TLabel;
    astid: TEdit;
    asth: TEdit;
    astg: TEdit;
    astep: TEdit;
    astma: TEdit;
    astperi: TEdit;
    astnode: TEdit;
    asti: TEdit;
    astec: TEdit;
    astax: TEdit;
    astref: TEdit;
    astnam: TEdit;
    asteq: TEdit;
    Addast: TButton;
    OpenDialog1: TOpenDialog;
    WizardNotebook1: TWizardNotebook;
    XplanetBox: TGroupBox;
    UseXplanet: TCheckBox;
    XplanetDir: TEdit;
    XplanetBtn: TBitBtn;
    procedure FormCreate(Sender: TObject);
    procedure PlanetDirChange(Sender: TObject);
    procedure PlanetDirSelClick(Sender: TObject);
    procedure PlaParalaxeClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure PlanetBoxClick(Sender: TObject);
    procedure PlanetModeClick(Sender: TObject);
    procedure GRSChange(Sender: TObject);
    procedure PlanetBox3Click(Sender: TObject);
    procedure BitBtn37Click(Sender: TObject);
    procedure showcomClick(Sender: TObject);
    procedure comsymbolClick(Sender: TObject);
    procedure comlimitmagChange(Sender: TObject);
    procedure commagdiffChange(Sender: TObject);
    procedure comfilebtnClick(Sender: TObject);
    procedure LoadcomClick(Sender: TObject);
    procedure DelComClick(Sender: TObject);
    procedure DelComAllClick(Sender: TObject);
    procedure AddComClick(Sender: TObject);
    procedure comdbsetClick(Sender: TObject);
    procedure showastClick(Sender: TObject);
    procedure astsymbolClick(Sender: TObject);
    procedure astlimitmagChange(Sender: TObject);
    procedure astmagdiffChange(Sender: TObject);
    procedure astdbsetClick(Sender: TObject);
    procedure mpcfilebtnClick(Sender: TObject);
    procedure LoadMPCClick(Sender: TObject);
    procedure AstComputeClick(Sender: TObject);
    procedure delastClick(Sender: TObject);
    procedure deldateastClick(Sender: TObject);
    procedure delallastClick(Sender: TObject);
    procedure AddastClick(Sender: TObject);
    procedure XplanetBtnClick(Sender: TObject);
    procedure XplanetDirChange(Sender: TObject);
    procedure UseXplanetClick(Sender: TObject);
  private
    { Private declarations }
    FShowDB: TNotifyEvent;
    FPrepareAsteroid: TPrepareAsteroid;
    LockChange: boolean;
    procedure ShowPlanet;
    procedure ShowComet;
    procedure UpdComList;
    procedure ShowAsteroid;
    procedure UpdAstList;
  public
    { Public declarations }
    cdb: Tcdcdb;
    autoprocess: boolean;
    mycsc : conf_skychart;
    myccat : conf_catalog;
    mycshr : conf_shared;
    mycplot : conf_plot;
    mycmain : conf_main;
    csc : ^conf_skychart;
    ccat : ^conf_catalog;
    cshr : ^conf_shared;
    cplot : ^conf_plot;
    cmain : ^conf_main;
    constructor Create(AOwner:TComponent); override;
    procedure LoadSampleData;
    property onShowDB: TNotifyEvent read FShowDB write FShowDB;
    property onPrepareAsteroid: TPrepareAsteroid read FPrepareAsteroid write FPrepareAsteroid;
  end;

implementation



constructor Tf_config_solsys.Create(AOwner:TComponent);
begin
 csc:=@mycsc;
 ccat:=@myccat;
 cshr:=@mycshr;
 cplot:=@mycplot;
 cmain:=@mycmain;
 inherited Create(AOwner);
end;

procedure Tf_config_solsys.FormShow(Sender: TObject);
begin
LockChange:=true;
ShowPlanet;
ShowComet;
ShowAsteroid;
LockChange:=false;
end;

procedure Tf_config_solsys.ShowPlanet;
begin
if csc.PlanetParalaxe then PlaParalaxe.itemindex:=1
                      else PlaParalaxe.itemindex:=0;
PlanetBox.checked:=csc.ShowPlanet;
PlanetMode.itemindex:=cplot.plaplot;
grs.value:=csc.GRSlongitude;
PlanetBox3.checked:=csc.ShowEarthShadow;
Planetdir.Text:=cmain.planetdir;
XplanetDir.text:=xplanet_dir;
UseXplanet.checked:=use_xplanet;
{$ifdef unix}
 XplanetDir.Visible:=false;
 XplanetBtn.Visible:=false;
{$endif}
end;

procedure Tf_config_solsys.ShowComet;
begin
showcom.checked:=csc.ShowComet;
comsymbol.itemindex:=csc.ComSymbol;
comlimitmag.value:=csc.CommagMax;
commagdiff.value:=csc.CommagDiff;
if csc.ShowComet then UpdComList;
end;

procedure Tf_config_solsys.ShowAsteroid;
begin
showast.checked:=csc.ShowAsteroid;
astsymbol.itemindex:=csc.AstSymbol;
astlimitmag.value:=csc.AstmagMax;
astmagdiff.value:=csc.AstmagDiff;
aststrtdate.text:=inttostr(csc.curyear)+'.'+inttostr(csc.curmonth);
astdeldate.text:=inttostr(csc.curyear-1)+'.'+inttostr(csc.curmonth);
if csc.ShowAsteroid then UpdAstList;
end;

procedure Tf_config_solsys.PlanetDirChange(Sender: TObject);
begin
if LockChange then exit;
cmain.planetdir:=planetdir.text;
end;

procedure Tf_config_solsys.FormCreate(Sender: TObject);
begin
  LockChange:=true;
end;

procedure Tf_config_solsys.PlanetDirSelClick(Sender: TObject);
begin
  SelectDirectoryDialog1.InitialDir:=expandfilename(planetdir.text);
  if SelectDirectoryDialog1.execute then
     planetdir.text:=SelectDirectoryDialog1.Filename;

end;

procedure Tf_config_solsys.PlaParalaxeClick(Sender: TObject);
begin
csc.PlanetParalaxe:=(PlaParalaxe.itemindex=1);
end;


procedure Tf_config_solsys.PlanetBoxClick(Sender: TObject);
begin
csc.ShowPlanet:=PlanetBox.checked;
end;

procedure Tf_config_solsys.PlanetModeClick(Sender: TObject);
begin
cplot.plaplot:=PlanetMode.itemindex;
end;

procedure Tf_config_solsys.GRSChange(Sender: TObject);
begin
if LockChange then exit;
csc.GRSlongitude:=grs.value;
end;

procedure Tf_config_solsys.PlanetBox3Click(Sender: TObject);
begin
csc.ShowEarthShadow:=PlanetBox3.checked;
end;

procedure Tf_config_solsys.BitBtn37Click(Sender: TObject);
begin
ExecuteFile('http://jupos.privat.t-online.de/');
end;

procedure Tf_config_solsys.UpdComList;
begin
cdb.GetCometFileList(cmain^,comelemlist.items);
comelemlist.itemindex:=0;
if comelemlist.items.count>0 then comelemlist.text:=comelemlist.items[0];
end;

procedure Tf_config_solsys.showcomClick(Sender: TObject);
begin
csc.ShowComet:=showcom.checked;
end;

procedure Tf_config_solsys.comsymbolClick(Sender: TObject);
begin
csc.ComSymbol:=comsymbol.itemindex;
end;

procedure Tf_config_solsys.comlimitmagChange(Sender: TObject);
begin
if LockChange then exit;
csc.CommagMax:=comlimitmag.value;
end;

procedure Tf_config_solsys.commagdiffChange(Sender: TObject);
begin
if LockChange then exit;
csc.CommagDiff:=commagdiff.value;
end;

procedure Tf_config_solsys.comfilebtnClick(Sender: TObject);
var f : string;
begin
f:=comFile.Text;
opendialog1.InitialDir:=extractfilepath(f);
if opendialog1.InitialDir='' then opendialog1.InitialDir:=slash(privatedir)+slash('MPC');
opendialog1.filename:=extractfilename(f);
opendialog1.Filter:='DAT Files|*.DAT|All Files|*.*';
opendialog1.DefaultExt:='';
try
if opendialog1.execute then begin
   comFile.Text:=opendialog1.FileName;
end;
finally
 chdir(appdir);
end;
end;

procedure Tf_config_solsys.LoadcomClick(Sender: TObject);
begin
screen.cursor:=crHourGlass;
cdb.LoadCometFile(comfile.text,MemoCom);
UpdComList;
screen.cursor:=crDefault;
end;

procedure Tf_config_solsys.DelComClick(Sender: TObject);
begin
screen.cursor:=crHourGlass;
cdb.DelComet(comelemlist.text,delcommemo);
screen.cursor:=crDefault;
UpdComList;
end;

procedure Tf_config_solsys.DelComAllClick(Sender: TObject);
begin
screen.cursor:=crHourGlass;
cdb.DelCometAll(delComMemo);
screen.cursor:=crDefault;
UpdComList;
end;

procedure Tf_config_solsys.AddComClick(Sender: TObject);
var
  msg :string;
begin
msg:=cdb.AddCom(comid.text,comt.text,comep.text,comq.text,comec.text,comperi.text,comnode.text,comi.text,comh.text,comg.text,comnam.text,comeq.text);
UpdComList;
if msg<>'' then Showmessage(msg);
end;

procedure Tf_config_solsys.comdbsetClick(Sender: TObject);
begin
if Assigned(FShowDB) then FShowDB(self);
end;

procedure Tf_config_solsys.UpdAstList;
begin
cdb.GetAsteroidFileList(cmain^,astelemlist.items);
astelemlist.itemindex:=0;
if astelemlist.items.count>0 then astelemlist.text:=astelemlist.items[0];
end;


procedure Tf_config_solsys.showastClick(Sender: TObject);
begin
csc.ShowAsteroid:=showast.checked;
end;

procedure Tf_config_solsys.astsymbolClick(Sender: TObject);
begin
csc.astsymbol:=astsymbol.itemindex;
end;

procedure Tf_config_solsys.astlimitmagChange(Sender: TObject);
begin
if LockChange then exit;
if trim(astlimitmag.text)<>'' then csc.AstmagMax:=astlimitmag.value;
end;

procedure Tf_config_solsys.astmagdiffChange(Sender: TObject);
begin
if LockChange then exit;
csc.AstmagDiff:=astmagdiff.value;
end;

procedure Tf_config_solsys.astdbsetClick(Sender: TObject);
begin
if Assigned(FShowDB) then FShowDB(self);
end;

procedure Tf_config_solsys.mpcfilebtnClick(Sender: TObject);
var f : string;
begin
f:=mpcFile.Text;
opendialog1.InitialDir:=extractfilepath(f);
if opendialog1.InitialDir='' then opendialog1.InitialDir:=slash(privatedir)+slash('MPC');
opendialog1.filename:=extractfilename(f);
opendialog1.Filter:='DAT Files|*.DAT|All Files|*.*';
opendialog1.DefaultExt:='';
try
if opendialog1.execute then begin
   mpcFile.Text:=opendialog1.FileName;
end;
finally
 chdir(appdir);
end;
end;

procedure Tf_config_solsys.LoadMPCClick(Sender: TObject);
var ok:boolean;
begin
screen.cursor:=crHourGlass;
ok:=cdb.LoadAsteroidFile(mpcfile.text,astnumbered.checked,aststoperr.checked,astlimitbox.checked,astlimit.value,MemoMPC);
UpdAstList;
screen.cursor:=crDefault;
if ok then begin
  if autoprocess then AstComputeClick(Sender)
  else begin
     Showmessage('To use this new data you must now compute the Monthly Data');
     AstPageControl.activepage:=astprepare;
  end;
end;
end;

procedure Tf_config_solsys.AstComputeClick(Sender: TObject);
var jdt:double;
    y,m,i:integer;
begin
try
screen.cursor:=crHourGlass;
prepastmemo.clear;
if assigned(FPrepareAsteroid) then begin
i:=pos('.',aststrtdate.text);
y:=strtoint(trim(copy(aststrtdate.text,1,i-1)));
m:=strtoint(trim(copy(aststrtdate.text,i+1,99)));
for i:=1 to astnummonth.value do begin
  jdt:=jd(y,m,1,0);
  if not FPrepareAsteroid(jdt,prepastmemo.lines) then begin
     screen.cursor:=crDefault;
     ShowMessage('No Asteroid data found!'+crlf+'Please load a MPC file first.');
     AstPageControl.activepage:=astload;
     exit;
  end;
  inc(m);
  if m>12 then begin
     inc(y);
     m:=1;
  end;
end;
prepastmemo.lines.Add('You are now ready to display the asteroid for this time period.');
screen.cursor:=crDefault;
showast.checked:=true;
end
 else prepastmemo.lines.Add('Error! PrepareAsteroid function not initialized.');
except
screen.cursor:=crDefault;
end;
end;

procedure Tf_config_solsys.delastClick(Sender: TObject);
begin
screen.cursor:=crHourGlass;
Cdb.DelAsteroid(astelemlist.text, delastMemo);
screen.cursor:=crDefault;
UpdAstList;
end;

procedure Tf_config_solsys.deldateastClick(Sender: TObject);
begin
screen.cursor:=crHourGlass;
cdb.DelAstDate(astdeldate.text, delastMemo);
screen.cursor:=crDefault;
end;

procedure Tf_config_solsys.delallastClick(Sender: TObject);
begin
screen.cursor:=crHourGlass;
cdb.DelAstAll(delastMemo);
screen.cursor:=crDefault;
UpdAstList;
end;

procedure Tf_config_solsys.AddastClick(Sender: TObject);
var
  msg :string;
begin
msg:=Cdb.AddAsteroid(astid.text,asth.text,astg.text,astep.text,astma.text,astperi.text,astnode.text,asti.text,astec.text,astax.text,astref.text,astnam.text,asteq.text);
UpdAstList;
if msg<>'' then showmessage(msg);
end;

procedure Tf_config_solsys.LoadSampleData;
begin
  // load sample asteroid data
  mpcfile.text:=slash(sampledir)+'MPCsample.dat';
  autoprocess:=true;
  LoadMPCClick(Self);
  autoprocess:=false;
  mpcfile.text:='';
  // load sample comet data
  comfile.text:=slash(sampledir)+'Cometsample.dat';
  LoadComClick(Self);
  comfile.text:='';
  csc.ShowComet:=true;
  csc.ShowAsteroid:=true;
end;

// windows specific code:
procedure Tf_config_solsys.XplanetBtnClick(Sender: TObject);
var f : string;
begin
f:=slash(XplanetDir.text)+'xplanet.exe';
opendialog1.InitialDir:=extractfilepath(f);
opendialog1.filename:=extractfilename(f);
opendialog1.Filter:='Exe Files|*.exe';
opendialog1.DefaultExt:='';
try
if opendialog1.execute then begin
   XplanetDir.text:=extractfilepath(opendialog1.FileName);
end;
finally
 chdir(appdir);
end;
end;

procedure Tf_config_solsys.XplanetDirChange(Sender: TObject);
begin
if LockChange then exit;
xplanet_dir:=XplanetDir.text;
end;

procedure Tf_config_solsys.UseXplanetClick(Sender: TObject);
begin
use_xplanet:=UseXplanet.checked;
end;

initialization
  {$i pu_config_solsys.lrs}

end.