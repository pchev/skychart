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
var i:integer;
begin
comelemlist.clear;
comelemlist.text:='';
db:=TMyDB.create(self);
try
db.SetPort(cmain.dbport);
db.database:=cmain.db;
db.Connect(cmain.dbhost,cmain.dbuser,cmain.dbpass,cmain.db);
if db.Active then begin
  db.Query('Select elem_id,filedesc from cdc_com_elem_list order by elem_id');
  i:=0;
  while i<db.Rowcount do begin
     comelemlist.items.add(db.Results[i][0]+'; '+db.Results[i][1]);
     inc(i);
  end;
  comelemlist.itemindex:=0;
  if comelemlist.items.count>0 then comelemlist.text:=comelemlist.items[0];
end;
  db.Free;
except
db.Free;
end;
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
var
  buf,cmd,filedesc,filenum,edate :string;
  t,ep,id,nam,ec,q,i,node,peri,eq,h,g  : string;
  y,m,d,nl: integer;
  hh:double;
  f : textfile;
begin
MemoCom.clear;
if not fileexists(comfile.text) then begin
  MemoCom.lines.add('File not found!');
  exit;
end;
db:=TMyDB.create(self);
try
screen.cursor:=crHourGlass;
db.SetPort(cmain.dbport);
db.database:=cmain.db;
db.Connect(cmain.dbhost,cmain.dbuser,cmain.dbpass,cmain.db);
if db.Active then begin
  filedesc:=extractfilename(comfile.text)+blank+FormatDateTime('yyyy-mmm-dd hh:nn',FileDateToDateTime(FileAge(comfile.text)));
  assignfile(f,comfile.text);
  reset(f);
  db.Query('LOCK TABLES cdc_com_elem WRITE, cdc_ast_com_list WRITE, cdc_com_name WRITE');
  nl:=0;
  repeat
    readln(f,buf);
    inc(nl);
    if trim(buf)='' then continue;
    if (nl mod 10000)=0 then begin MemoCom.lines.add('Processing line '+inttostr(nl)); application.processmessages; end;
    id:=trim(copy(buf,1,12));
    y:=strtoint(trim(copy(buf,15,4)));
    m:=strtoint(trim(copy(buf,20,2)));
    d:=strtoint(trim(copy(buf,23,2)));
    hh:=24*strtofloat('0'+trim(copy(buf,25,5)));
    t:=formatfloat(f6,jd(y,m,d,hh));
    ep:=trim(copy(buf,82,8));
    if ep<>'' then begin
       y:=strtoint(trim(copy(ep,1,4)));
       m:=strtoint(trim(copy(ep,5,2)));
       d:=strtoint(trim(copy(ep,7,2)));
       hh:=0;
    end;
    ep:=formatfloat(f1,jd(y,m,d,hh));
    if nl=1 then edate:=inttostr(y)+'.'+inttostr(m);
    q:=copy(buf,31,9);
    ec:=copy(buf,41,9);
    peri:=copy(buf,51,9);
    node:=copy(buf,61,9);
    i:=copy(buf,71,9);
    h:=copy(buf,92,4);
    g:=copy(buf,97,4);
    nam:=stringreplace(trim(copy(buf,103,27)),'"','\"',[rfreplaceall]);
    eq:='2000';
    if nl=1 then begin
       filedesc:=filedesc+', epoch='+ep;
       buf:=db.QueryOne('Select max(elem_id) from cdc_com_elem_list');
       if buf<>'' then filenum:=inttostr(strtoint(buf)+1)
                   else filenum:='1';
       if not db.Query('Insert into cdc_com_elem_list (elem_id, filedesc) Values("'+filenum+'","'+filedesc+'")') then
              MemoCom.lines.add(trim(db.GetLastError));
    end;
    cmd:='INSERT INTO cdc_com_elem (id,peri_epoch,peri_dist,eccentricity,arg_perihelion,asc_node,inclination,epoch,h,g,name,equinox,elem_id) VALUES ('
        +'"'+id+'"'
        +',"'+t+'"'
        +',"'+q+'"'
        +',"'+ec+'"'
        +',"'+peri+'"'
        +',"'+node+'"'
        +',"'+i+'"'
        +',"'+ep+'"'
        +',"'+h+'"'
        +',"'+g+'"'
        +',"'+nam+'"'
        +',"'+eq+'"'
        +',"'+filenum+'"'+')';
    if not db.query(cmd) then begin
       MemoCom.lines.add('insert failed line '+inttostr(nl)+' : '+trim(db.GetLastError));
    end;
    cmd:='INSERT INTO cdc_com_name (name, id) VALUES ('
        +'"'+nam+'"'
        +',"'+id+'"'+')';
    db.query(cmd);
  until eof(f);
  closefile(f);
  MemoCom.lines.add('Processing ended. Total number of comet :'+inttostr(nl));
end else begin
   buf:=trim(db.GetLastError);
   if buf<>'' then showmessage(buf);
end;
  screen.cursor:=crDefault;
  db.Query('UNLOCK TABLES');
  db.Query('FLUSH TABLES');
  db.Free;
  UpdComList;
except
  screen.cursor:=crDefault;
  db.Free;
end;
end;

procedure Tf_config_solsys.DelComClick(Sender: TObject);
var i: integer;
    elem_id:string;
begin
delComMemo.clear;
i:=pos(';',comelemlist.text);
elem_id:=copy(comelemlist.text,1,i-1);
if trim(elem_id)='' then exit;
db:=TMyDB.create(self);
try
screen.cursor:=crHourGlass;
db.SetPort(cmain.dbport);
db.database:=cmain.db;
db.Connect(cmain.dbhost,cmain.dbuser,cmain.dbpass,cmain.db);
if db.Active then begin
  db.Query('LOCK TABLES cdc_com_elem WRITE, cdc_com_elem_list WRITE');
  delcomMemo.lines.add('Delete from element table...');
  application.processmessages;
  if not db.Query('Delete from cdc_com_elem where elem_id='+elem_id) then
     delcomMemo.lines.add('Failed : '+trim(db.GetLastError));
  delcomMemo.lines.add('Delete from element list...');
  application.processmessages;
  if not db.Query('Delete from cdc_com_elem_list where elem_id='+elem_id) then
     delcomMemo.lines.add('Failed : '+trim(db.GetLastError));
  db.Query('UNLOCK TABLES');
  db.Query('FLUSH TABLES');
  delcomMemo.lines.add('Delete daily data');
  planet.TruncateDailyComet;
  delcomMemo.lines.add('Delete completed');
end;
  db.Free;
  screen.cursor:=crDefault;
  UpdComList;
except
  screen.cursor:=crDefault;
  db.Free;
end;
end;

procedure Tf_config_solsys.DelComAllClick(Sender: TObject);
begin
delComMemo.clear;
db:=TMyDB.create(self);
try
screen.cursor:=crHourGlass;
db.SetPort(cmain.dbport);
db.database:=cmain.db;
db.Connect(cmain.dbhost,cmain.dbuser,cmain.dbpass,cmain.db);
if db.Active then begin
  db.Query('UNLOCK TABLES');
  delComMemo.lines.add('Delete from element table...');
  application.processmessages;
  db.Query('Truncate table cdc_com_elem');
  delcomMemo.lines.add('Delete from element list...');
  application.processmessages;
  db.Query('Truncate table cdc_com_elem_list');
  delcomMemo.lines.add('Delete from name list...');
  application.processmessages;
  db.Query('Truncate table cdc_com_name');
  delcomMemo.lines.add('Delete daily data');
  planet.TruncateDailyComet;
  delcomMemo.lines.add('Delete completed');
end;
  screen.cursor:=crDefault;
  db.Free;
  UpdComList;
except
  screen.cursor:=crDefault;
  db.Free;
end;
end;

procedure Tf_config_solsys.AddComClick(Sender: TObject);
var
  buf,cmd,filedesc,filenum :string;
  t,q,ep,id,nam,ec,i,node,peri,eq,h,g  : string;
  y,m,d,p:integer;
  hh:double;
begin
db:=TMyDB.create(self);
try
db.SetPort(cmain.dbport);
db.database:=cmain.db;
db.Connect(cmain.dbhost,cmain.dbuser,cmain.dbpass,cmain.db);
if db.Active then begin
    id:=trim(copy(comid.text,1,7));
    buf:=comt.text;
    p:=pos('.',buf);
    y:=strtoint(trim(copy(buf,1,p-1)));
    delete(buf,1,p);
    p:=pos('.',buf);
    m:=strtoint(trim(copy(buf,1,p-1)));
    delete(buf,1,p);
    p:=pos('.',buf);
    d:=strtoint(trim(copy(buf,1,p-1)));
    delete(buf,1,p);
    hh:=strtofloat(trim('0.'+trim(buf)))*24;
    t:=formatfloat(f6,jd(y,m,d,hh));
    ep:=trim(comep.text);
    if ep='' then begin
       ep:=formatfloat(f1,jd(y,m,d,hh));
    end;
    q:=trim(comq.text);
    ec:=trim(comec.text);
    peri:=trim(comperi.text);
    node:=trim(comnode.text);
    i:=trim(comi.text);
    h:=trim(comh.text);
    g:=trim(comg.text);
    nam:=stringreplace(trim(comnam.text),'"','\"',[rfreplaceall]);
    eq:=trim(comeq.text);
    buf:=db.QueryOne('Select max(elem_id) from cdc_com_elem_list');
    if buf<>'' then filenum:=inttostr(strtoint(buf)+1)
               else filenum:='1';
    filedesc:='Add '+id+', '+nam+', '+ep;
    db.Query('Insert into cdc_com_elem_list (elem_id, filedesc) Values("'+filenum+'","'+filedesc+'")');
    cmd:='INSERT INTO cdc_com_elem (id,peri_epoch,peri_dist,eccentricity,arg_perihelion,asc_node,inclination,epoch,h,g,name,equinox,elem_id) VALUES ('
        +'"'+id+'"'
        +',"'+t+'"'
        +',"'+q+'"'
        +',"'+ec+'"'
        +',"'+peri+'"'
        +',"'+node+'"'
        +',"'+i+'"'
        +',"'+ep+'"'
        +',"'+h+'"'
        +',"'+g+'"'
        +',"'+nam+'"'
        +',"'+eq+'"'
        +',"'+filenum+'"'+')';
    if db.query(cmd) then begin
       cmd:='INSERT INTO cdc_com_name (name, id) VALUES ('
           +'"'+nam+'"'
           +',"'+id+'"'+')';
       db.query(cmd);
       ShowMessage('OK!')
    end else ShowMessage('Insert failed! '+trim(db.GetLastError));
end else begin
   buf:=trim(db.GetLastError);
   if buf<>'' then showmessage(buf);
end;
db.Query('FLUSH TABLES');
db.Free;
UpdComList;
except
  db.Free;
end;
end;

procedure Tf_config_solsys.comdbsetClick(Sender: TObject);
begin
if Assigned(FShowDB) then FShowDB(self);
end;

procedure Tf_config_solsys.UpdAstList;
var i:integer;
begin
astelemlist.clear;
astelemlist.text:='';
db:=TMyDB.create(self);
try
db.SetPort(cmain.dbport);
db.database:=cmain.db;
db.Connect(cmain.dbhost,cmain.dbuser,cmain.dbpass,cmain.db);
if db.Active then begin
  db.Query('Select elem_id,filedesc from cdc_ast_elem_list order by elem_id');
  i:=0;
  while i< db.Rowcount do begin
     astelemlist.items.add(db.Results[i][0]+'; '+db.Results[i][1]);
     inc(i);
  end;
  astelemlist.itemindex:=0;
  if astelemlist.items.count>0 then astelemlist.text:=astelemlist.items[0];
end;
  db.Free;
except
db.Free;
end;
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
var
  buf,cmd,c,filedesc,filenum,edate :string;
  ep,id,nam,ec,ax,i,node,peri,eq,ma,h,g,ref  : string;
  y,m,d,nl,prefl,lid,nerr: integer;
  hh:double;
  f : textfile;
begin
nerr:=1;
MemoMPC.clear;
if not fileexists(mpcfile.text) then begin
  MemoMPC.lines.add('File not found!');
  exit;
end;
db:=TMyDB.create(self);
try
screen.cursor:=crHourGlass;
db.SetPort(cmain.dbport);
db.database:=cmain.db;
db.Connect(cmain.dbhost,cmain.dbuser,cmain.dbpass,cmain.db);
if db.Active then begin
  filedesc:=extractfilename(mpcfile.text)+blank+FormatDateTime('yyyy-mmm-dd hh:nn',FileDateToDateTime(FileAge(mpcfile.text)));
  assignfile(f,mpcfile.text);
  reset(f);
  // minimal file checking to distinguish full mpcorb from daily update
  readln(f,buf);
  nl:=1;
  c:=trim(copy(buf,27,9));
  val(c,hh,nerr);
  if nerr=0 then begin
            reset(f);
            nl:=0;
     end else repeat
             readln(f,buf);
             inc(nl);
          until eof(f) or (copy(buf,1,5)='-----');
  if eof(f) then begin
     MemoMPC.lines.add('This file was not recognized as a MPCORB file.');
     raise exception.create('');
  end;
  MemoMPC.lines.add('Data start on line '+inttostr(nl+1));
  prefl:=nl;
  db.Query('LOCK TABLES cdc_ast_elem WRITE, cdc_ast_elem_list WRITE, cdc_ast_name WRITE');
  nerr:=0;
  nl:=0;
  repeat
    readln(f,buf);
    inc(nl);
    if trim(buf)='' then begin
      if astnumbered.checked then break
                             else continue;
    end;
    if (nl mod 10000)=0 then begin MemoMPC.lines.add('Processing line '+inttostr(nl)); application.processmessages; end;
    id:=trim(copy(buf,1,7));
    lid:=length(id);
    if lid<7 then id:=StringofChar('0',7-lid)+id;
    h:=copy(buf,9,5);
    g:=copy(buf,15,5);
    ep:=trim(copy(buf,21,5));
    if decode_mpc_date(ep,y,m,d,hh) then
       ep:=floattostr(jd(y,m,d,hh))
     else begin
       inc(nerr);
       MemoMPC.lines.add('invalid epoch on line'+inttostr(nl+prefl)+' : '+buf);
       break;
     end;
    if nl=1 then edate:=inttostr(y)+'.'+inttostr(m);
    ma:=copy(buf,27,9);
    peri:=copy(buf,38,9);
    node:=copy(buf,49,9);
    i:=copy(buf,60,9);
    ec:=copy(buf,71,9);
    ax:=copy(buf,93,11);
    ref:=trim(copy(buf,108,10));
    nam:=stringreplace(trim(copy(buf,167,27)),'"','\"',[rfreplaceall]);
    eq:='2000';
    if nl=1 then begin
       filedesc:=filedesc+', epoch='+ep;
       buf:=db.QueryOne('Select max(elem_id) from cdc_ast_elem_list');
       if buf<>'' then filenum:=inttostr(strtoint(buf)+1)
                   else filenum:='1';
       if not db.Query('Insert into cdc_ast_elem_list (elem_id, filedesc) Values("'+filenum+'","'+filedesc+'")') then
              MemoMPC.lines.add(trim(db.GetLastError));
    end;
    cmd:='INSERT INTO cdc_ast_elem (id,h,g,epoch,mean_anomaly,arg_perihelion,asc_node,inclination,eccentricity,semi_axis,ref,name,equinox,elem_id) VALUES ('
        +'"'+id+'"'
        +',"'+h+'"'
        +',"'+g+'"'
        +',"'+ep+'"'
        +',"'+ma+'"'
        +',"'+peri+'"'
        +',"'+node+'"'
        +',"'+i+'"'
        +',"'+ec+'"'
        +',"'+ax+'"'
        +',"'+ref+'"'
        +',"'+nam+'"'
        +',"'+eq+'"'
        +',"'+filenum+'"'+')';
    if not db.query(cmd) then begin
       MemoMPC.lines.add('insert failed line '+inttostr(nl+prefl)+' : '+trim(db.GetLastError));
       inc(nerr);
       if aststoperr.checked and (nerr>1000) then begin
          MemoMPC.lines.add('More than 1000 errors! Process aborted.');
          break;
       end;
    end;
    cmd:='INSERT INTO cdc_ast_name (name, id) VALUES ('
        +'"'+nam+'"'
        +',"'+id+'"'+')';
    db.query(cmd);
    if astlimitbox.checked and (nl>=astlimit.value) then break;
  until eof(f);
  closefile(f);
  MemoMPC.lines.add('Processing ended. Total number of asteroid :'+inttostr(nl));
end else begin
   buf:=trim(db.GetLastError);
   if buf<>'' then showmessage(buf);
end;
  screen.cursor:=crDefault;
  db.Query('UNLOCK TABLES');
  db.Query('FLUSH TABLES');
  db.Free;
  UpdAstList;
if nerr=0 then begin
  if autoprocess then AstComputeClick(Sender)
  else begin
     Showmessage('To use this new data you must compute the Monthly Data for a period near '+edate);
     if aststrtdate.text<edate then aststrtdate.text:=edate;
     AstPageControl.activepage:=astprepare;
  end;
end;
except
  screen.cursor:=crDefault;
  db.Free;
end;
end;

procedure Tf_config_solsys.AstComputeClick(Sender: TObject);
var jdt:double;
    y,m,i:integer;
begin
try
screen.cursor:=crHourGlass;
//planet.ConnectDB(cmain.dbhost,cmain.db,cmain.dbuser,cmain.dbpass,cmain.dbport);
prepastmemo.clear;
i:=pos('.',aststrtdate.text);
y:=strtoint(trim(copy(aststrtdate.text,1,i-1)));
m:=strtoint(trim(copy(aststrtdate.text,i+1,99)));
for i:=1 to astnummonth.value do begin
  jdt:=jd(y,m,1,0);
  if not planet.PrepareAsteroid(jdt,prepastmemo.lines) then begin
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
except
screen.cursor:=crDefault;
end;
end;

procedure Tf_config_solsys.delastClick(Sender: TObject);
var i: integer;
    elem_id:string;
begin
delastMemo.clear;
i:=pos(';',astelemlist.text);
elem_id:=copy(astelemlist.text,1,i-1);
if trim(elem_id)='' then exit;
db:=TMyDB.create(self);
try
screen.cursor:=crHourGlass;
db.SetPort(cmain.dbport);
db.database:=cmain.db;
db.Connect(cmain.dbhost,cmain.dbuser,cmain.dbpass,cmain.db);
if db.Active then begin
  db.Query('LOCK TABLES cdc_ast_elem WRITE, cdc_ast_elem_list WRITE, cdc_ast_mag WRITE');
  delastMemo.lines.add('Delete from element table...');
  application.processmessages;
  if not db.Query('Delete from cdc_ast_elem where elem_id='+elem_id) then
     delastMemo.lines.add('Failed : '+trim(db.GetLastError));
  delastMemo.lines.add('Delete from element list...');
  application.processmessages;
  if not db.Query('Delete from cdc_ast_elem_list where elem_id='+elem_id) then
     delastMemo.lines.add('Failed : '+trim(db.GetLastError));
  delastMemo.lines.add('Delete from monthly table...');
  application.processmessages;
  if not db.Query('Delete from cdc_ast_mag where elem_id='+elem_id) then
     delastMemo.lines.add('Failed : '+trim(db.GetLastError));
  db.Query('UNLOCK TABLES');
  db.Query('FLUSH TABLES');
  delastMemo.lines.add('Delete daily data');
  planet.TruncateDailyAsteroid;
  delastMemo.lines.add('Delete completed');
end;
  db.Free;
  screen.cursor:=crDefault;
  UpdAstList;
except
  screen.cursor:=crDefault;
  db.Free;
end;
end;

procedure Tf_config_solsys.deldateastClick(Sender: TObject);
var i,y,m: integer;
    jds: string;
begin
delastMemo.clear;
i:=pos('.',astdeldate.text);
y:=strtoint(trim(copy(astdeldate.text,1,i-1)));
m:=strtoint(trim(copy(astdeldate.text,i+1,99)));
jds:=formatfloat(f1,jd(y,m,1,0));
db:=TMyDB.create(self);
try
screen.cursor:=crHourGlass;
db.SetPort(cmain.dbport);
db.database:=cmain.db;
db.Connect(cmain.dbhost,cmain.dbuser,cmain.dbpass,cmain.db);
if db.Active then begin
  db.Query('LOCK TABLES cdc_ast_mag WRITE');
  delastMemo.lines.add('Delete from monthly table for jd<'+jds);
  application.processmessages;
  if not db.Query('Delete from cdc_ast_mag where jd<'+jds) then
     delastMemo.lines.add('Failed : '+trim(db.GetLastError));
  db.Query('UNLOCK TABLES');
  db.Query('FLUSH TABLES');
  delastMemo.lines.add('Delete completed');
end;
  screen.cursor:=crDefault;
  db.Free;
except
  screen.cursor:=crDefault;
  db.Free;
end;
end;

procedure Tf_config_solsys.delallastClick(Sender: TObject);
begin
delastMemo.clear;
db:=TMyDB.create(self);
try
screen.cursor:=crHourGlass;
db.SetPort(cmain.dbport);
db.database:=cmain.db;
db.Connect(cmain.dbhost,cmain.dbuser,cmain.dbpass,cmain.db);
if db.Active then begin
  db.Query('UNLOCK TABLES');
  delastMemo.lines.add('Delete from element table...');
  application.processmessages;
  db.Query('Truncate table cdc_ast_elem');
  delastMemo.lines.add('Delete from element list...');
  application.processmessages;
  db.Query('Truncate table cdc_ast_elem_list');
  delastMemo.lines.add('Delete from name list...');
  application.processmessages;
  db.Query('Truncate table cdc_ast_name');
  delastMemo.lines.add('Delete from monthly table...');
  application.processmessages;
  db.Query('Truncate table cdc_ast_mag');
  delastMemo.lines.add('Delete daily data');
  planet.TruncateDailyAsteroid;
  delastMemo.lines.add('Delete completed');
end;
  screen.cursor:=crDefault;
  db.Free;
  UpdAstList;
except
  screen.cursor:=crDefault;
  db.Free;
end;
end;

procedure Tf_config_solsys.AddastClick(Sender: TObject);
var
  buf,cmd,filedesc,filenum :string;
  ep,id,nam,ec,ax,i,node,peri,eq,ma,h,g,ref  : string;
  lid: integer;
begin
db:=TMyDB.create(self);
try
db.SetPort(cmain.dbport);
db.database:=cmain.db;
db.Connect(cmain.dbhost,cmain.dbuser,cmain.dbpass,cmain.db);
if db.Active then begin
    id:=trim(copy(astid.text,1,7));
    lid:=length(id);
    if lid<7 then id:=StringofChar('0',7-lid)+id;
    h:=trim(asth.text);
    g:=trim(astg.text);
    ep:=trim(astep.text);
    ma:=trim(astma.text);
    peri:=trim(astperi.text);
    node:=trim(astnode.text);
    i:=trim(asti.text);
    ec:=trim(astec.text);
    ax:=trim(astax.text);
    ref:=trim(astref.text);
    nam:=stringreplace(trim(astnam.text),'"','\"',[rfreplaceall]);
    eq:=trim(asteq.text);
    buf:=db.QueryOne('Select max(elem_id) from cdc_ast_elem_list');
    if buf<>'' then filenum:=inttostr(strtoint(buf)+1)
               else filenum:='1';
    filedesc:='Add '+id+', '+nam+', '+ep;
    db.Query('Insert into cdc_ast_elem_list (elem_id, filedesc) Values("'+filenum+'","'+filedesc+'")');
    cmd:='INSERT INTO cdc_ast_elem (id,h,g,epoch,mean_anomaly,arg_perihelion,asc_node,inclination,eccentricity,semi_axis,ref,name,equinox,elem_id) VALUES ('
        +'"'+id+'"'
        +',"'+h+'"'
        +',"'+g+'"'
        +',"'+ep+'"'
        +',"'+ma+'"'
        +',"'+peri+'"'
        +',"'+node+'"'
        +',"'+i+'"'
        +',"'+ec+'"'
        +',"'+ax+'"'
        +',"'+ref+'"'
        +',"'+nam+'"'
        +',"'+eq+'"'
        +',"'+filenum+'"'+')';
    if db.query(cmd) then begin
       cmd:='INSERT INTO cdc_ast_name (name, id) VALUES ('
           +'"'+nam+'"'
           +',"'+id+'"'+')';
       db.query(cmd);
       ShowMessage('OK!')
    end else ShowMessage('Insert failed! '+trim(db.GetLastError));
end else begin
   buf:=trim(db.GetLastError);
   if buf<>'' then showmessage(buf);
end;
db.Query('FLUSH TABLES');
db.Free;
UpdAstList;
except
  db.Free;
end;
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
end;

