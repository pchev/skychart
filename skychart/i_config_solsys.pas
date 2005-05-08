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
ShowPlanet;
ShowComet;
ShowAsteroid;
end;

procedure Tf_config_solsys.ShowPlanet;
begin
if csc.PlanetParalaxe then PlaParalaxe.itemindex:=1
                      else PlaParalaxe.itemindex:=0;
PlanetBox.checked:=csc.ShowPlanet;
PlanetMode.itemindex:=cplot.plaplot;
grs.value:=csc.GRSlongitude;
PlanetBox3.checked:=csc.ShowEarthShadow;
PlanetBox2.checked:=cplot.PlanetTransparent;
Planetdir.Text:=cmain.planetdir;
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
cmain.planetdir:=planetdir.text;
end;

procedure Tf_config_solsys.PlanetDirSelClick(Sender: TObject);
begin
{$ifdef mswindows}
  FolderDialog1.Directory:=planetdir.text;
  if FolderDialog1.execute then
     planetdir.text:=FolderDialog1.Directory;
{$endif}
{$ifdef linux }
  f_directory.DirectoryTreeView1.Directory:=planetdir.text;
  f_directory.showmodal;
  if f_directory.modalresult=mrOK then
     planetdir.text:=f_directory.DirectoryTreeView1.Directory;
{$endif}
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
csc.GRSlongitude:=grs.value;
end;

procedure Tf_config_solsys.PlanetBox2Click(Sender: TObject);
begin
cplot.PlanetTransparent:=PlanetBox2.checked;
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
csc.CommagMax:=comlimitmag.value;
end;

procedure Tf_config_solsys.commagdiffChange(Sender: TObject);
begin
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
if trim(astlimitmag.text)<>'' then csc.AstmagMax:=astlimitmag.value;
end;

procedure Tf_config_solsys.astmagdiffChange(Sender: TObject);
begin
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

