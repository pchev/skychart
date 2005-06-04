unit cu_database;
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
{
 General database function. 
}
interface

uses passql, pasmysql, passqlite, u_constant, u_util, u_projection, cu_fits,
     {$ifdef linux}
        QForms, QStdctrls, QComCtrls,
     {$endif}
     {$ifdef mswindows}
        Forms, Stdctrls, ComCtrls,
     {$endif}
     Classes, Sysutils, StrUtils;


type
  TCDCdb = class(TComponent)
  private
    { Private declarations }
    db:TSqlDB;
    FFits: TFits;
    FInitializeDB: TNotifyEvent;
  public
    { Public declarations }
     constructor Create(AOwner:TComponent); override;
     destructor  Destroy; override;
     function createDB(cmain: conf_main; var ok:boolean): string;
     function dropDB(cmain: conf_main): string;
     function checkDBConfig(cmain: conf_main): string;
     Function ConnectDB(host,dbn,user,pass:string; port:integer):boolean;
     function CheckDB:boolean;
     procedure GetCometFileList(cmain:conf_main; list:Tstrings);
     procedure GetAsteroidFileList(cmain:conf_main; list:Tstrings);
     procedure LoadCometFile(comfile:string; memocom:Tmemo);
     procedure DelComet(comelemlist: string; memocom:Tmemo);
     procedure DelCometAll(memocom:Tmemo);
     function AddCom(comid,comt,comep,comq,comec,comperi,comnode,comi,comh,comg,comnam,comeq:string ):string;
     function LoadAsteroidFile(astfile:string; astnumbered,stoperr,limit: boolean; astlimit:integer; memoast:Tmemo): boolean;
     procedure DelAsteroid(astelemlist: string; memoast:Tmemo);
     procedure DelAstDate(astdeldate:string; memoast:Tmemo);
     procedure DelAstAll(memoast:Tmemo);
     function AddAsteroid(astid,asth,astg,astep,astma,astperi,astnode,asti,astec,astax,astref,astnam,asteq: string): string;
     procedure TruncateDailyComet;
     procedure TruncateDailyAsteroid;
     procedure GetCometList(filter:string; maxnumber:integer; list:Tstrings; var cometid: array of string);
     procedure GetAsteroidList(filter:string; maxnumber:integer; list:Tstrings; var astid: array of string);
     function GetCometEpoch(id:string; now_jd:double):double;
     function GetAsteroidEpoch(id:string; now_jd:double):double;
     Function GetAstElem(id: string; epoch:double; var h,g,ma,ap,an,ic,ec,sa,eq: double; var ref,nam,elem_id:string):boolean;  published
     Function GetAstElemEpoch(id:string; jd:double; var epoch,h,g,ma,ap,an,ic,ec,sa,eq: double; var ref,nam,elem_id:string):boolean;
     Function GetComElem(id: string; epoch:double; var tp,q,ec,ap,an,ic,h,g,eq: double; var nam,elem_id:string):boolean;
     Function GetComElemEpoch(id:string; jd:double; var epoch,tp,q,ec,ap,an,ic,h,g,eq: double; var nam,elem_id:string):boolean;
     procedure LoadSampleData(memo:Tmemo);
     function CountImages:integer;
     procedure ScanImagesDirectory(ImagePath:string; ProgressCat:Tlabel; ProgressBar:TProgressBar );
     property onInitializeDB: TNotifyEvent read FInitializeDB write FInitializeDB;
  end;

implementation

constructor TCDCdb.Create(AOwner:TComponent);
begin
 inherited Create(AOwner);
 FFits:=TFits.Create(self);
 if DBtype=mysql then
    db:=TMyDB.create(self)
 else if DBtype=sqlite then
    db:=TLiteDB.create(self);
end;

destructor TCDCdb.Destroy;
begin
 db.Free;
 FFits.Free;
 inherited destroy;
end;

Function TCDCdb.ConnectDB(host,dbn,user,pass:string; port:integer):boolean;
begin
try
 if DBtype=mysql then begin
   db.SetPort(port);
   db.Connect(host,user,pass,dbn);
 end;
 if db.database<>dbn then db.Use(dbn);
 result:=db.Active;
except
 result:=false;
end;
end;

function TCDCdb.Checkdb:boolean;
var i,j:integer;
   ok,creatednow:boolean;
begin
creatednow:=false;
if db.Active then begin
  result:=true;
  for i:=1 to numsqltable do begin
     ok:=(sqltable[i,1]=db.QueryOne(showtable[dbtype]+' "'+sqltable[i,1]+'"'));
     if not ok then begin  // try to create the missing table
       if DBtype=sqlite then
           db.Query('CREATE TABLE '+sqltable[i,1]+stringreplace(sqltable[i,2],'binary','',[rfReplaceAll]))
       else
           db.Query('CREATE TABLE '+sqltable[i,1]+sqltable[i,2]);
       if sqltable[i,3]>'' then begin   // create the index
          j:=strtoint(sqltable[i,3]);
          db.Query('CREATE INDEX '+sqlindex[j,1]+' on '+sqlindex[j,2]);
       end;
       ok:=(sqltable[i,1]=db.QueryOne(showtable[dbtype]+' "'+sqltable[i,1]+'"'));
       if ok then begin
           writetrace('Create table '+sqltable[i,1]+' ... Ok');
           creatednow:=true;
           end
        else writetrace('Create table '+sqltable[i,1]+' ... Failed');
     end;
     result:=result and ok;
  end;
end
 else result:=false;
if creatednow and (Assigned(FInitializeDB)) then FInitializeDB(self);
end;

function TCDCdb.checkDBConfig(cmain: conf_main):string;
var msg: string;
    i:integer;
label dmsg;
begin
try
  if DBtype=mysql then begin
    db.SetPort(cmain.dbport);
    db.Connect(cmain.dbhost,cmain.dbuser,cmain.dbpass,'');
    if db.Active then msg:='Connect to '+cmain.dbhost+', '+inttostr(cmain.dbport)+' successful.'+crlf
       else begin msg:='Connect to '+cmain.dbhost+', '+inttostr(cmain.dbport)+' failed! '+trim(db.ErrorMessage)+crlf+'Verify if the MySQL Server is running and control the Userid/Password'; goto dmsg;end;
  end;
  if ((db.database=cmain.db)or db.use(cmain.db)) then msg:=msg+'Database '+cmain.db+' opened.'+crlf
     else begin msg:=msg+'Cannot open database '+cmain.db+'! '+trim(db.ErrorMessage)+crlf; goto dmsg;end;
  for i:=1 to numsqltable do begin
     if sqltable[i,1]=db.QueryOne(showtable[dbtype]+' "'+sqltable[i,1]+'"') then msg:=msg+'Table exist '+sqltable[i,1]+crlf
        else begin msg:=msg+'Table '+sqltable[i,1]+' do not exist! '+crlf+'Please correct the error and retry.' ; goto dmsg;end;
  end;
  msg:=msg+'All tables structure exists.';
dmsg:
  result:=msg;
except
  result:='SQL database software is probably not installed!';
end;
end;

function TCDCdb.createDB(cmain: conf_main; var ok:boolean): string;
var msg:string;
    i,j:integer;
begin
ok:=false;
result:='';
try
  if DBtype=mysql then begin
     db.SetPort(cmain.dbport);
     db.database:='';
     db.Connect(cmain.dbhost,cmain.dbuser,cmain.dbpass,'');
     if db.Active then db.Query('Create Database if not exists '+cmain.db);
     result:=trim(db.ErrorMessage);
     db.Connect(cmain.dbhost,cmain.dbuser,cmain.dbpass,cmain.db);
  end;
  if db.database<>cmain.db then db.Use(cmain.db);
  if db.database=cmain.db then begin
    ok:=true;
    for i:=1 to numsqltable do begin
      if DBtype=sqlite then
          db.Query('CREATE TABLE '+sqltable[i,1]+stringreplace(sqltable[i,2],'binary','',[rfReplaceAll]))
      else
          db.Query('CREATE TABLE '+sqltable[i,1]+sqltable[i,2]);
      msg:=trim(db.ErrorMessage);
      if sqltable[i,3]>'' then begin   // create the index
         j:=strtoint(sqltable[i,3]);
         db.Query('CREATE INDEX '+sqlindex[j,1]+' on '+sqlindex[j,2]);
      end;
      if sqltable[i,1]<>db.QueryOne(showtable[dbtype]+' "'+sqltable[i,1]+'"') then begin
         ok:=false;
         result:=result+crlf+'Error creating table '+sqltable[i,1]+' '+msg;
         break;
      end;
    end;
  end else begin
     ok:=false;
     result:=result+crlf+trim(db.ErrorMessage);
  end;
  db.Query(flushtable[dbtype]);
except
end;
end;

function TCDCdb.dropDB(cmain: conf_main): string;
var msg:string;
    i: integer;
begin
result:='';
if DBtype=mysql then begin
  try
  db.SetPort(cmain.dbport);
  db.database:='';
  db.Connect(cmain.dbhost,cmain.dbuser,cmain.dbpass,'');
  if db.Active then db.Query('Drop Database '+cmain.db);
  msg:=trim(db.ErrorMessage);
  if msg<>'0' then result:=msg;
  db.Close;
  except
  end;
end
else if DBtype=sqlite then begin
  // do not work
  result:='';
  db.StartTransaction;
  for i:=0 to db.Tables.Count-1 do begin
    db.Query('DROP TABLE '+db.Tables[i]);
     msg:=trim(db.ErrorMessage);
     if msg<>'0' then result:=result+msg;
  end;
  db.Commit;
  db.Query('VACUUM');
  msg:=trim(db.ErrorMessage);
  if msg<>'0' then result:=result+msg;
end;
end;

procedure TCDCdb.GetCometFileList(cmain:conf_main; list:Tstrings);
var i:integer;
begin
list.clear;
try
if db.Active then begin
  db.Query('Select elem_id,filedesc from cdc_com_elem_list order by elem_id');
  i:=0;
  while i<db.Rowcount do begin
     list.add(db.Results[i][0]+'; '+db.Results[i][1]);
     inc(i);
  end;
end;
except
end;
end;

procedure TCDCdb.GetAsteroidFileList(cmain:conf_main; list:Tstrings);
var i:integer;
begin
list.clear;
try
if db.Active then begin
  db.Query('Select elem_id,filedesc from cdc_ast_elem_list order by elem_id');
  i:=0;
  while i< db.Rowcount do begin
     list.add(db.Results[i][0]+'; '+db.Results[i][1]);
     inc(i);
  end;
end;
except
end;
end;

procedure TCDCdb.LoadCometFile(comfile:string; memocom:Tmemo);
var
  buf,cmd,filedesc,filenum,edate :string;
  t,ep,id,nam,ec,q,i,node,peri,eq,h,g  : string;
  y,m,d,nl: integer;
  hh:double;
  f : textfile;
begin
MemoCom.clear;
if not fileexists(comfile) then begin
  MemoCom.lines.add('File not found!');
  exit;
end;
try
if db.Active then begin
  filedesc:=extractfilename(comfile)+blank+FormatDateTime('yyyy-mmm-dd hh:nn',FileDateToDateTime(FileAge(comfile)));
  assignfile(f,comfile);
  reset(f);
  db.starttransaction;
  if DBtype=mysql then db.Query('LOCK TABLES cdc_com_elem WRITE, cdc_ast_com_list WRITE, cdc_com_name WRITE');
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
              MemoCom.lines.add(trim(db.ErrorMessage));
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
       MemoCom.lines.add('insert failed line '+inttostr(nl)+' : '+trim(db.ErrorMessage));
    end;
    cmd:='INSERT INTO cdc_com_name (name, id) VALUES ('
        +'"'+nam+'"'
        +',"'+id+'"'+')';
    db.query(cmd);
  until eof(f);
  closefile(f);
  MemoCom.lines.add('Processing ended. Total number of comet :'+inttostr(nl));
end else begin
   buf:=trim(db.ErrorMessage);
   if buf<>'0' then MemoCom.lines.add(buf);
end;
  if DBtype=mysql then db.Query('UNLOCK TABLES');
  db.commit;
  db.Query(flushtable[DBtype]);
except
end;
end;

procedure TCDCdb.DelComet(comelemlist: string; memocom:Tmemo);
var i: integer;
    elem_id:string;
begin
memocom.clear;
i:=pos(';',comelemlist);
elem_id:=copy(comelemlist,1,i-1);
if trim(elem_id)='' then exit;
try
if db.Active then begin
  db.starttransaction;
  if DBtype=mysql then db.Query('LOCK TABLES cdc_com_elem WRITE, cdc_com_elem_list WRITE');
  memocom.lines.add('Delete from element table...');
  application.processmessages;
  if not db.Query('Delete from cdc_com_elem where elem_id='+elem_id) then
     memocom.lines.add('Failed : '+trim(db.ErrorMessage));
  memocom.lines.add('Delete from element list...');
  application.processmessages;
  if not db.Query('Delete from cdc_com_elem_list where elem_id='+elem_id) then
     memocom.lines.add('Failed : '+trim(db.ErrorMessage));
  if DBtype=mysql then db.Query('UNLOCK TABLES');
  db.commit;
  db.Query(flushtable[DBtype]);
  memocom.lines.add('Delete daily data');
  TruncateDailyComet;
  if DBtype=sqlite then db.Query('VACUUM');
  memocom.lines.add('Delete completed');
end;
except
end;
end;

procedure TCDCdb.DelCometAll(memocom:Tmemo);
begin
memocom.clear;
try
if db.Active then begin
  if DBtype=mysql then db.Query('UNLOCK TABLES');
  db.starttransaction;
  memocom.lines.add('Delete from element table...');
  application.processmessages;
  db.Query(truncatetable[DBtype]+' cdc_com_elem');
  memocom.lines.add('Delete from element list...');
  application.processmessages;
  db.Query(truncatetable[DBtype]+' cdc_com_elem_list');
  memocom.lines.add('Delete from name list...');
  application.processmessages;
  db.Query(truncatetable[DBtype]+' cdc_com_name');
  db.commit;
  memocom.lines.add('Delete daily data');
  TruncateDailyComet;
  if DBtype=sqlite then db.Query('VACUUM');
  memocom.lines.add('Delete completed');
end;
except
end;
end;

function TCDCdb.AddCom(comid,comt,comep,comq,comec,comperi,comnode,comi,comh,comg,comnam,comeq:string ):string;
var
  buf,cmd,filedesc,filenum :string;
  t,q,ep,id,nam,ec,i,node,peri,eq,h,g  : string;
  y,m,d,p:integer;
  hh:double;
begin
try
if db.Active then begin
    id:=trim(copy(comid,1,7));
    buf:=comt;
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
    ep:=trim(comep);
    if ep='' then begin
       ep:=formatfloat(f1,jd(y,m,d,hh));
    end;
    q:=trim(comq);
    ec:=trim(comec);
    peri:=trim(comperi);
    node:=trim(comnode);
    i:=trim(comi);
    h:=trim(comh);
    g:=trim(comg);
    nam:=stringreplace(trim(comnam),'"','\"',[rfreplaceall]);
    eq:=trim(comeq);
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
       result:='OK!'
    end else result:='Insert failed! '+trim(db.ErrorMessage);
end else begin
   buf:=trim(db.ErrorMessage);
   if buf<>'0' then result:=buf;
end;
db.Query(flushtable[DBtype]);
except
end;
end;

function TCDCdb.LoadAsteroidFile(astfile:string; astnumbered,stoperr,limit: boolean; astlimit:integer;  memoast:Tmemo):boolean;
var
  buf,cmd,c,filedesc,filenum,edate :string;
  ep,id,nam,ec,ax,i,node,peri,eq,ma,h,g,ref  : string;
  y,m,d,nl,prefl,lid,nerr: integer;
  hh:double;
  f : textfile;
begin
nerr:=1;
result:=false;
memoast.clear;
if not fileexists(astfile) then begin
  memoast.lines.add('File not found!');
  exit;
end;
try
if db.Active then begin
  filedesc:=extractfilename(astfile)+blank+FormatDateTime('yyyy-mmm-dd hh:nn',FileDateToDateTime(FileAge(astfile)));
  assignfile(f,astfile);
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
     memoast.lines.add('This file was not recognized as a MPCORB file.');
     raise exception.create('');
  end;
  memoast.lines.add('Data start on line '+inttostr(nl+1));
  prefl:=nl;
  db.starttransaction;
  if DBtype=mysql then db.Query('LOCK TABLES cdc_ast_elem WRITE, cdc_ast_elem_list WRITE, cdc_ast_name WRITE');
  nerr:=0;
  nl:=0;
  repeat
    readln(f,buf);
    inc(nl);
    if trim(buf)='' then begin
      if astnumbered then break
                     else continue;
    end;
    if (nl mod 10000)=0 then begin memoast.lines.add('Processing line '+inttostr(nl)); application.processmessages; end;
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
       memoast.lines.add('invalid epoch on line'+inttostr(nl+prefl)+' : '+buf);
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
              memoast.lines.add(trim(db.ErrorMessage));
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
       memoast.lines.add('insert failed line '+inttostr(nl+prefl)+' : '+trim(db.ErrorMessage));
       inc(nerr);
       if stoperr and (nerr>1000) then begin
          memoast.lines.add('More than 1000 errors! Process aborted.');
          break;
       end;
    end;
    cmd:='INSERT INTO cdc_ast_name (name, id) VALUES ('
        +'"'+nam+'"'
        +',"'+id+'"'+')';
    db.query(cmd);
    if limit and (nl>=astlimit) then break;
  until eof(f);
  closefile(f);
  memoast.lines.add('Processing ended. Total number of asteroid :'+inttostr(nl));
end else begin
   buf:=trim(db.ErrorMessage);
   if buf<>'0' then memoast.lines.add(buf);
end;
  if DBtype=mysql then db.Query('UNLOCK TABLES');
  db.commit;
  db.Query(flushtable[DBtype]);
result:=(nerr=0);
except
end;
end;

procedure TCDCdb.DelAsteroid(astelemlist: string; memoast:Tmemo);
var i: integer;
    elem_id:string;
begin
memoast.clear;
i:=pos(';',astelemlist);
elem_id:=copy(astelemlist,1,i-1);
if trim(elem_id)='' then exit;
try
if db.Active then begin
  db.starttransaction;
  if DBtype=mysql then db.Query('LOCK TABLES cdc_ast_elem WRITE, cdc_ast_elem_list WRITE, cdc_ast_mag WRITE');
  memoast.lines.add('Delete from element table...');
  application.processmessages;
  if not db.Query('Delete from cdc_ast_elem where elem_id='+elem_id) then
     memoast.lines.add('Failed : '+trim(db.ErrorMessage));
  memoast.lines.add('Delete from element list...');
  application.processmessages;
  if not db.Query('Delete from cdc_ast_elem_list where elem_id='+elem_id) then
     memoast.lines.add('Failed : '+trim(db.ErrorMessage));
  memoast.lines.add('Delete from monthly table...');
  application.processmessages;
  if not db.Query('Delete from cdc_ast_mag where elem_id='+elem_id) then
     memoast.lines.add('Failed : '+trim(db.ErrorMessage));
  if DBtype=mysql then db.Query('UNLOCK TABLES');
  db.commit;
  db.Query(flushtable[DBtype]);
  memoast.lines.add('Delete daily data');
  TruncateDailyAsteroid;
  if DBtype=sqlite then db.Query('VACUUM');
  memoast.lines.add('Delete completed');
end;
except
end;
end;

procedure TCDCdb.DelAstDate(astdeldate:string; memoast:Tmemo);
var i,y,m: integer;
    jds: string;
begin
memoast.clear;
i:=pos('.',astdeldate);
y:=strtoint(trim(copy(astdeldate,1,i-1)));
m:=strtoint(trim(copy(astdeldate,i+1,99)));
jds:=formatfloat(f1,jd(y,m,1,0));
try
if db.Active then begin
  db.starttransaction;
  if DBtype=mysql then db.Query('LOCK TABLES cdc_ast_mag WRITE');
  memoast.lines.add('Delete from monthly table for jd<'+jds);
  application.processmessages;
  if not db.Query('Delete from cdc_ast_mag where jd<'+jds) then
     memoast.lines.add('Failed : '+trim(db.ErrorMessage));
  if DBtype=mysql then db.Query('UNLOCK TABLES');
  db.commit;
  db.Query(flushtable[DBtype]);
  if DBtype=sqlite then db.Query('VACUUM');
  memoast.lines.add('Delete completed');
end;
except
end;
end;

procedure TCDCdb.DelAstAll(memoast:Tmemo);
begin
memoast.clear;
try
if db.Active then begin
  if DBtype=mysql then db.Query('UNLOCK TABLES');
  db.starttransaction;
  memoast.lines.add('Delete from element table...');
  application.processmessages;
  db.Query(truncatetable[DBtype]+' cdc_ast_elem');
  memoast.lines.add('Delete from element list...');
  application.processmessages;
  db.Query(truncatetable[DBtype]+' cdc_ast_elem_list');
  memoast.lines.add('Delete from name list...');
  application.processmessages;
  db.Query(truncatetable[DBtype]+' cdc_ast_name');
  memoast.lines.add('Delete from monthly table...');
  application.processmessages;
  db.Query(truncatetable[DBtype]+' cdc_ast_mag');
  db.commit;
  memoast.lines.add('Delete daily data');
  TruncateDailyAsteroid;
  if DBtype=sqlite then db.Query('VACUUM');
  memoast.lines.add('Delete completed');
end;
except
end;
end;

function TCDCdb.AddAsteroid(astid,asth,astg,astep,astma,astperi,astnode,asti,astec,astax,astref,astnam,asteq: string): string;
var
  buf,cmd,filedesc,filenum :string;
  ep,id,nam,ec,ax,i,node,peri,eq,ma,h,g,ref  : string;
  lid: integer;
begin
try
if db.Active then begin
    id:=trim(copy(astid,1,7));
    lid:=length(id);
    if lid<7 then id:=StringofChar('0',7-lid)+id;
    h:=trim(asth);
    g:=trim(astg);
    ep:=trim(astep);
    ma:=trim(astma);
    peri:=trim(astperi);
    node:=trim(astnode);
    i:=trim(asti);
    ec:=trim(astec);
    ax:=trim(astax);
    ref:=trim(astref);
    nam:=stringreplace(trim(astnam),'"','\"',[rfreplaceall]);
    eq:=trim(asteq);
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
       result:='OK!'
    end else result:='Insert failed! '+trim(db.ErrorMessage);
end else begin
   buf:=trim(db.ErrorMessage);
   if buf<>'0' then result:=buf;
end;
db.Query(flushtable[DBtype]);
except
end;
end;

procedure TCDCdb.TruncateDailyAsteroid;
var i,j:integer;
    dailytable:Tstringlist;
begin
dailytable:=Tstringlist.create;
try
  if DBtype=mysql then db.Query('UNLOCK TABLES');
  db.Query(showtable[DBtype]+' "cdc_ast_day_%"');
  i:=0;
  while i<db.Rowcount do begin
     dailytable.add(db.results[i][0]);
     inc(i);
  end;
  j:=0;
  db.StartTransaction;
  while j<dailytable.Count do begin
     db.Query(truncatetable[DBtype]+' '+dailytable[j]);
     inc(j);
  end;
  db.Commit;
finally
  dailytable.free;
end;
end;

procedure TCDCdb.TruncateDailyComet;
var i,j:integer;
    dailytable:Tstringlist;
begin
dailytable:=Tstringlist.create;
try
  if DBtype=mysql then db.Query('UNLOCK TABLES');
  db.Query(showtable[DBtype]+' "cdc_com_day_%"');
  i:=0;
  while i<db.Rowcount do begin
     dailytable.add(db.results[i][0]);
     inc(i);
  end;
  j:=0;
  db.StartTransaction;
  while j<dailytable.Count do begin
     db.Query(truncatetable[DBtype]+' '+dailytable[j]);
     inc(j);
  end;
  db.Commit;
finally
  dailytable.free;
end;
end;

procedure TCDCdb.LoadSampleData(memo:Tmemo);
begin
  // load sample asteroid data
  LoadAsteroidFile(slash(sampledir)+'MPCsample.dat',true,false,false,1000,memo);
  // load sample comet data
  LoadCometFile(slash(sampledir)+'Cometsample.dat',memo);
end;

procedure TCDCdb.GetCometList(filter:string; maxnumber:integer; list:Tstrings; var cometid: array of string);
var qry: string;
    i: integer;
begin
list.Clear;
qry:='SELECT distinct(id),name FROM cdc_com_elem where name like "%'+trim(Filter)+'%" limit '+inttostr(maxnumber);
db.Query(qry);
if db.Rowcount>0 then
  for i:=0 to db.Rowcount-1 do begin
    cometid[i]:=db.Results[i][0];
    list.Add(db.Results[i][1]);
  end;
end;

procedure TCDCdb.GetAsteroidList(filter:string; maxnumber:integer; list:Tstrings; var astid: array of string);
var qry: string;
    i: integer;
begin
list.Clear;
qry:='SELECT distinct(id),name FROM cdc_ast_elem where name like "%'+trim(Filter)+'%" limit '+inttostr(maxnumber);
db.Query(qry);
if db.Rowcount>0 then
  for i:=0 to db.Rowcount-1 do begin
    astid[i]:=db.Results[i][0];
    list.Add(db.Results[i][1]);
  end;
end;

function TCDCdb.GetCometEpoch(id:string; now_jd:double):double;
var diff,dif: double;
    i: integer;
    qry: string;
begin
diff:=1E10;
result:=0;
qry:='SELECT epoch FROM cdc_com_elem where id="'+id+'"';
db.Query(qry);
if db.Rowcount>0 then
  for i:=0 to db.Rowcount-1 do begin
      dif:=abs(strtofloat(db.Results[i][0])-now_jd);
      if dif<diff then begin
         result:=strtofloat(db.Results[i][0]);
         diff:=dif;
      end;
  end;
end;

function TCDCdb.GetAsteroidEpoch(id:string; now_jd:double):double;
var diff,dif: double;
    i: integer;
    qry: string;
begin
diff:=1E10;
result:=0;
qry:='SELECT epoch FROM cdc_ast_elem where id="'+id+'"';
db.Query(qry);
if db.Rowcount>0 then
  for i:=0 to db.Rowcount-1 do begin
      dif:=abs(strtofloat(db.Results[i][0])-now_jd);
      if dif<diff then begin
         result:=strtofloat(db.Results[i][0]);
         diff:=dif;
      end;
  end;
end;


Function TCDCdb.GetAstElem(id: string; epoch:double; var h,g,ma,ap,an,ic,ec,sa,eq: double; var ref,nam,elem_id:string):boolean;
var qry : string;
begin
try
qry:='SELECT id,h,g,epoch,mean_anomaly,arg_perihelion,asc_node,inclination,eccentricity,semi_axis,ref,name,equinox,elem_id'
    +' from cdc_ast_elem '
    +' where id="'+id+'"'
    +' and epoch='+formatfloat(f1,epoch);
db.Query(qry);
if db.rowcount>0 then begin
  h:=strtofloat(db.Results[0][1]);
  g:=strtofloat(db.Results[0][2]);
  ma:=strtofloat(db.Results[0][4]);
  ap:=strtofloat(db.Results[0][5]);
  an:=strtofloat(db.Results[0][6]);
  ic:=strtofloat(db.Results[0][7]);
  ec:=strtofloat(db.Results[0][8]);
  sa:=strtofloat(db.Results[0][9]);
  ref:=db.Results[0][10];
  nam:=db.Results[0][11];
  eq:=strtofloat(db.Results[0][12]);
  elem_id:=db.Results[0][13];
  result:=true;
end else begin
  result:=false;
end;
except
  result:=false;
end;
end;

Function TCDCdb.GetComElem(id: string; epoch:double; var tp,q,ec,ap,an,ic,h,g,eq: double; var nam,elem_id:string):boolean;
var qry : string;
begin
try
qry:='SELECT id,peri_epoch,peri_dist,eccentricity,arg_perihelion,asc_node,inclination,epoch,h,g,name,equinox,elem_id'
    +' from cdc_com_elem '
    +' where id="'+id+'"'
    +' and epoch='+formatfloat(f1,epoch);
db.Query(qry);
if db.Rowcount>0 then begin
  tp:=strtofloat(db.Results[0][1]);
  q:=strtofloat(db.Results[0][2]);
  ec:=strtofloat(db.Results[0][3]);
  ap:=strtofloat(db.Results[0][4]);
  an:=strtofloat(db.Results[0][5]);
  ic:=strtofloat(db.Results[0][6]);
  h:=strtofloat(db.Results[0][8]);
  g:=strtofloat(db.Results[0][9]);
  nam:=db.Results[0][10];
  eq:=strtofloat(db.Results[0][11]);
  elem_id:=db.Results[0][12];
  result:=true;
end else begin
  result:=false;
end;
except
  result:=false;
end;
end;

Function TCDCdb.GetAstElemEpoch(id:string; jd:double; var epoch,h,g,ma,ap,an,ic,ec,sa,eq: double; var ref,nam,elem_id:string):boolean;
var qry : string;
    dt,t : double;
    i,j : integer;
begin
try
qry:='SELECT id,h,g,epoch,mean_anomaly,arg_perihelion,asc_node,inclination,eccentricity,semi_axis,ref,name,equinox,elem_id'
    +' from cdc_ast_elem'
    +' where id="'+id+'"';
db.Query(qry);
if db.Rowcount>0 then begin
  epoch:=strtofloat(db.Results[0][3]);
  dt:=abs(jd-epoch);
  j:=0;
  i:=1;
  while i<db.Rowcount do begin
    t:=strtofloat(db.Results[i][3]);
    if abs(jd-t)<dt then begin
       epoch:=t;
       dt:=abs(jd-t);
       j:=i;
    end;
    inc(i);
  end;
  if dt<1000 then begin
     h:=strtofloat(db.Results[j][1]);
     g:=strtofloat(db.Results[j][2]);
     ma:=strtofloat(db.Results[j][4]);
     ap:=strtofloat(db.Results[j][5]);
     an:=strtofloat(db.Results[j][6]);
     ic:=strtofloat(db.Results[j][7]);
     ec:=strtofloat(db.Results[j][8]);
     sa:=strtofloat(db.Results[j][9]);
     ref:=db.Results[j][10];
     nam:=db.Results[j][11];
     eq:=strtofloat(db.Results[j][12]);
     elem_id:=db.Results[j][13];
     result:=true;
  end
  else
     result:=false;
end else begin
  result:=false;
end;
except
  result:=false;
end;
end;

Function TCDCdb.GetComElemEpoch(id:string; jd:double; var epoch,tp,q,ec,ap,an,ic,h,g,eq: double; var nam,elem_id:string):boolean;
var qry : string;
    dt,t : double;
    i,j : integer;
begin
try
qry:='SELECT id,peri_epoch,peri_dist,eccentricity,arg_perihelion,asc_node,inclination,epoch,h,g,name,equinox,elem_id'
    +' from cdc_com_elem'
    +' where id="'+id+'"';
db.Query(qry);
if db.Rowcount>0 then begin
  epoch:=strtofloat(db.Results[0][7]);
  dt:=abs(jd-epoch);
  j:=0;
  i:=1;
  while i<db.Rowcount do begin
    t:=strtofloat(db.Results[i][7]);
    if abs(jd-t)<dt then begin
       epoch:=t;
       dt:=abs(jd-t);
       j:=i;
    end;
    inc(i);
  end;
  if dt<1000 then begin
     tp:=strtofloat(db.Results[j][1]);
     q:=strtofloat(db.Results[j][2]);
     ec:=strtofloat(db.Results[j][3]);
     ap:=strtofloat(db.Results[j][4]);
     an:=strtofloat(db.Results[j][5]);
     ic:=strtofloat(db.Results[j][6]);
     h:=strtofloat(db.Results[j][8]);
     g:=strtofloat(db.Results[j][9]);
     nam:=db.Results[j][10];
     eq:=strtofloat(db.Results[j][11]);
     elem_id:=db.Results[j][12];
     result:=true;
  end
  else
    result:=false;
end else begin
  result:=false;
end;
except
  result:=false;
end;
end;

function TCDCdb.CountImages:integer;
begin
try
if db.Active then begin
  result:=strtointdef(db.QueryOne('select count(*) from cdc_fits'),0);
end
else result:=0;
finally
end;
end;

procedure TCDCdb.ScanImagesDirectory(ImagePath:string; ProgressCat:Tlabel; ProgressBar:TProgressBar );
var c,f : tsearchrec;
    i,j,n,p:integer;
    catdir,objn,fname,cmd:string;
    dummyfile : boolean;
    ra,de,w,h,r: double;
begin
try
if db.Active then begin
ProgressCat.caption:='';
ProgressBar.position:=0;
if DBtype=mysql then db.Query('UNLOCK TABLES');
db.starttransaction;
db.Query(truncatetable[DBtype]+' cdc_fits');
db.commit;
j:=findfirst(slash(ImagePath)+'*',faDirectory,c);
while j=0 do begin
  if ((c.attr and faDirectory)<>0)and(c.Name<>'.')and(c.Name<>'..') then begin
  catdir:=slash(ImagePath)+c.Name;
  ProgressCat.caption:=c.Name;
  ProgressBar.position:=0;
  Application.processmessages;
  i:=findfirst(slash(catdir)+'*.*',0,f);
  n:=1;
  while i=0 do begin
   inc(n);
   i:=findnext(f);
  end;
  ProgressBar.min:=0;
  ProgressBar.max:=n;
  if (ProgressBar.Max > 25) then
    ProgressBar.Step := ProgressBar.Max div 25
  else
    ProgressBar.Step := 1;
  i:=findfirst(slash(catdir)+'*.*',0,f);
  n:=0;
  db.starttransaction;
  while i=0 do begin
    inc(n);
    if (n mod ProgressBar.step)=0 then begin ProgressBar.stepit; Application.processmessages; end;
    dummyfile:=uppercase((extractfileext(f.Name)))='.NIL';
    if dummyfile then begin
      ra:=99+random(999999999999999);
      de:=99+random(999999999999999);
      w:=0;
      h:=0;
      r:=0;
      fname:=slash(catdir)+f.Name;
    end else begin
      FFits.FileName:=slash(catdir)+f.Name;
      ra:=FFits.Center_RA;
      de:=FFits.Center_DE;
      w:=FFits.Img_Width;
      h:=FFits.img_Height;
      r:=FFits.Rotation;
      fname:=FFits.FileName;
    end;
    if FFits.header.valid or dummyfile then begin
      objn:=extractfilename(f.Name);
      p:=pos(extractfileext(objn),objn);
      objn:=copy(objn,1,p-1);
      objn:=uppercase(stringreplace(objn,' ','',[rfReplaceAll]));
      cmd:='INSERT INTO cdc_fits (filename,catalogname,objectname,ra,de,width,height,rotation) VALUES ('
        +'"'+stringreplace(fname,'\','\\',[rfReplaceAll])+'"'
        +',"'+uppercase(c.Name)+'"'
        +',"'+uppercase(objn)+'"'
        +',"'+formatfloat(f5,ra)+'"'
        +',"'+formatfloat(f5,de)+'"'
        +',"'+formatfloat(f5,w)+'"'
        +',"'+formatfloat(f5,h)+'"'
        +',"'+formatfloat(f5,r)+'"'
        +')';
      if not db.query(cmd) then
         writetrace('DB insert failed for '+f.Name+' :'+db.ErrorMessage);
    end
    else writetrace('Invalid FITS file: '+f.Name);
    i:=findnext(f);
  end;
  end;
  j:=findnext(c);
end;
db.commit;
db.Query(flushtable[DBtype]);
end;
finally
  findclose(c);
  findclose(f);
end;
end;

end.
