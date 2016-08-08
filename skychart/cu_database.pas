unit cu_database;
{
Copyright (C) 2005 Patrick Chevalley

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
Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
}
{
 General database function. 
}
{$mode objfpc}{$H+}
interface

uses passql, pasmysql, passqlite, u_constant, u_util, u_projection, cu_fits, FileUtil,
  Forms, Stdctrls, ComCtrls, Classes, Dialogs, Sysutils, StrUtils, u_translation;


type
  TCDCdb = class(TComponent)
  private
    { Private declarations }
    db:TSqlDB;
    FFits: TFits;
    FInitializeDB: TNotifyEvent;
    FAstmsg: string;
    FComMindt: integer;
    tstval: double;
  public
    { Public declarations }
     constructor Create(AOwner:TComponent); override;
     destructor  Destroy; override;
     function createDB(cmain: Tconf_main; var ok:boolean): string;
     function dropDB(cmain: Tconf_main): string;
     function checkDBConfig(cmain: Tconf_main): string;
     Function ConnectDB(host,dbn,user,pass:string; port:integer):boolean;
     function CheckForUpgrade(memo:Tmemo; updversion:string):boolean;
     function CheckDB:boolean;
     function LoadCountryList(locfile:string; memo:Tmemo):boolean;
     function LoadWorldLocation(locfile,country:string; city_only:boolean; memo:Tmemo):boolean;
     function LoadUSLocation(locfile:string; city_only:boolean; memo:Tmemo; state:string = ''):boolean;
     procedure GetCountryList(codelist,countrylist:Tstrings);
     procedure GetCountryISOCode(countrycode:string; var isocode: string);
     procedure GetCountryFromISO(isocode:string; var cname: string);
     procedure GetCityList(countrycode,filter:string; codelist,citylist:Tstrings; startr,limit:integer);
     procedure GetCityRange(country:string;lat1,lat2,lon1,lon2:double; codelist,citylist:Tstrings; limit:integer);
     function  GetCityLoc(locid:string; var loctype,latitude,longitude,elevation,timezone: string):boolean;
     function  UpdateCity(locid:integer; country,location,loctype,lat,lon,elev,tz:string):string;
     function  DeleteCity(locid:integer):string;
     function  DeleteCountry(country:string; deleteall: boolean):string;
     procedure GetCometFileList(cmain:Tconf_main; list:Tstrings);
     procedure GetAsteroidFileList(cmain:Tconf_main; list:Tstrings);
     function LoadCometFile(comfile:string; memocom:Tmemo):boolean;
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
     procedure GetCometList(filter:string; maxnumber:integer; list:TstringList; var cometid: array of string);
     procedure GetAsteroidList(filter:string; maxnumber:integer; var list:TstringList; var astid: array of string);
     function GetCometEpoch(id:string; now_jd:double):double;
     function GetAsteroidEpoch(id:string; now_jd:double):double;
     Function GetAstElem(id: string; epoch:double; var h,g,ma,ap,an,ic,ec,sa,eq: double; var ref,nam,elem_id:string):boolean;  published
     Function GetAstElemEpoch(id:string; jd:double; var epoch,h,g,ma,ap,an,ic,ec,sa,eq: double; var ref,nam,elem_id:string):boolean;
     Function GetComElem(id: string; epoch:double; var tp,q,ec,ap,an,ic,h,g,eq: double; var nam,elem_id:string):boolean;
     Function GetComElemEpoch(id:string; jd:double; var epoch,tp,q,ec,ap,an,ic,h,g,eq: double; var nam,elem_id:string):boolean;
     procedure LoadSampleData(memo:Tmemo; cmain: Tconf_main);
     function CountImages(catname:string):integer;
     procedure ScanImagesDirectory(ImagePath:string; ProgressCat:Tlabel; ProgressBar:TProgressBar );
     procedure ScanArchiveDirectory(ArchivePath:string; var count:integer );
     function AddFitsArchiveFile(ArchivePath,fn:string):boolean;
     property onInitializeDB: TNotifyEvent read FInitializeDB write FInitializeDB;
     property AstMsg : string read FAstmsg write FAstmsg;
     property ComMinDT : integer read FComMinDT write FComMinDT;
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
try
 db.Free;
 FFits.Free;
 inherited destroy;
except
writetrace('error destroy '+name);
end;
end;

Function TCDCdb.ConnectDB(host,dbn,user,pass:string; port:integer):boolean;
begin
try
 if DBtype=mysql then begin
   db.SetPort(port);
   db.Connect(host,user,pass,dbn);
 end
 else if DBtype=sqlite then begin
   dbn:=UTF8Encode(dbn);
 end;
 if db.database<>dbn then db.Use(dbn);
 result:=db.Active;
except
 result:=false;
end;
end;

function TCDCdb.Checkdb:boolean;
var i,j,k:integer;
   ok,creatednow:boolean;
   indexlist: TStringlist;
   emsg: string;
begin
creatednow:=false;
if db.Active then begin
  indexlist:=TStringlist.Create;
  result:=true;
  for i:=1 to numsqltable do begin
     ok:=(sqltable[dbtype,i,1]=db.QueryOne(showtable[dbtype]+' "'+sqltable[dbtype,i,1]+'"'));
     if not ok then begin  // try to create the missing table
       db.Query('CREATE TABLE '+sqltable[dbtype,i,1]+sqltable[dbtype,i,2]);
       emsg:=db.ErrorMessage;
       if sqltable[dbtype,i,3]>'' then begin   // create the index
          SplitRec(sqltable[dbtype,i,3],',',indexlist);
          for j:=0 to indexlist.Count-1 do begin
            k:=strtoint(indexlist[j]);
            db.Query('CREATE INDEX '+sqlindex[dbtype,k,1]+' on '+sqlindex[dbtype,k,2]);
          end;
       end;
       ok:=(sqltable[dbtype,i,1]=db.QueryOne(showtable[dbtype]+' "'+sqltable[dbtype,i,1]+'"'));
       if ok then begin
           writetrace('Create table '+sqltable[dbtype,i,1]+' ... Ok');
           creatednow:=true;
           end
        else writetrace('Create table '+sqltable[dbtype,i,1]+' ... Failed: '+emsg);
     end;
     result:=result and ok;
  end;
  indexlist.Free;
end
 else result:=false;
if creatednow and (Assigned(FInitializeDB)) then FInitializeDB(self);
end;

function TCDCdb.CheckForUpgrade(memo:Tmemo; updversion:string):boolean;
var updcountry:boolean;
    i,k: integer;
    buf: string;
begin
result:=false;
updcountry:=false;
if db.Active then begin
  // add isocode column to country table
  if ((not db.Query('select isocode from cdc_country where country="AF"'))
      or (db.RowCount<1) )
   then updcountry:=true;
  // Correct Japan code
  if ((db.Query('select isocode from cdc_country where isocode="JA"'))
      and (db.RowCount>=1) )
   then updcountry:=true;
  // Correct Australia code
  i:=strtointdef(db.QueryOne('select count(*) from cdc_country where isocode="AU"'),0);
  if (i>1)
   then updcountry:=true;
  if (updcountry)
   then begin
     if VerboseMsg then WriteTrace('Upgrade DB for country change ');
     db.Query('drop table cdc_country');
     writetrace('Drop table cdc_country ... '+db.ErrorMessage);
     db.Commit;
     db.Query('CREATE TABLE '+sqltable[dbtype,9,1]+sqltable[dbtype,9,2]);
     writetrace('Create table '+sqltable[dbtype,9,1]+' ...  '+db.ErrorMessage);
     LoadCountryList(slash(sampledir)+'country.dat',memo);
     result:=true;
  end;
  // Correct Fits index
  if DBtype=mysql then begin
    db.Query('show index from cdc_fits where Key_name="cdc_fits_objname"');
    i:=0; buf:=' ';
    while i<db.Rowcount do begin
      buf:=buf+' '+db.Results[i][4];
      inc(i);
    end;
  end
  else begin
    buf:=db.QueryOne('select sql from sqlite_master where name="cdc_fits_objname"');
  end;
  if (pos('objectname',buf)>0) and (pos('catalogname',buf)=0) then begin
     if VerboseMsg then WriteTrace('Upgrade DB for new Fits indexes');
     db.Query('drop table cdc_fits');
     writetrace('Drop table cdc_fits ... '+db.ErrorMessage);
     db.Commit;
     db.Query('CREATE TABLE '+sqltable[dbtype,8,1]+sqltable[dbtype,8,2]);
     writetrace('Create table '+sqltable[dbtype,8,1]+' ...  '+db.ErrorMessage);
     k:=2;
     db.Query('CREATE INDEX '+sqlindex[dbtype,k,1]+' on '+sqlindex[dbtype,k,2]);
  end;
  // change catalogname field length
  if (DBtype=mysql)and(updversion<cdcver)and(updversion<'3.9b') then begin
    db.Query('drop table cdc_fits');
    writetrace('Drop table cdc_fits ... '+db.ErrorMessage);
    db.Commit;
    db.Query('CREATE TABLE '+sqltable[dbtype,8,1]+sqltable[dbtype,8,2]);
    writetrace('Create table '+sqltable[dbtype,8,1]+' ...  '+db.ErrorMessage);
    k:=2;
    db.Query('CREATE INDEX '+sqlindex[dbtype,k,1]+' on '+sqlindex[dbtype,k,2]);
  end;
end;
end;

function TCDCdb.checkDBConfig(cmain: Tconf_main):string;
var msg,dbn: string;
    i:integer;
label dmsg;
begin
try
  if DBtype=mysql then begin
    dbn:=cmain.db;
    db.SetPort(cmain.dbport);
    db.Connect(cmain.dbhost,cmain.dbuser,cmain.dbpass,'');
    if db.Active then msg:=Format(rsConnectToSuc, [cmain.dbhost, inttostr(
      cmain.dbport), crlf])
       else begin msg:=Format(rsConnectToFai, [cmain.dbhost, inttostr(
         cmain.dbport), trim(db.ErrorMessage)+crlf]); goto dmsg; end;
  end else if DBtype=sqlite then begin
    dbn:=UTF8Encode(cmain.db);
  end;
  if ((db.database=dbn)or db.use(dbn)) then msg:=Format(rsDatabaseOpen, [msg,
    cmain.db, crlf])
     else begin msg:=Format(rsCannotOpenDa, [msg, cmain.db, trim(db.ErrorMessage
       )+crlf]); goto dmsg; end;
  for i:=1 to numsqltable do begin
     if sqltable[dbtype, i, 1]=db.QueryOne(showtable[dbtype]+' "'+sqltable[
       dbtype, i, 1]+'"') then msg:=Format(rsTableExist, [msg, sqltable[dbtype,
       i, 1]+crlf])
        else begin msg:=Format(rsTableDoNotEx, [msg, sqltable[dbtype, i, 1],
          crlf]) ; goto dmsg; end;
  end;
  msg:=Format(rsAllTablesStr, [msg]);
dmsg:
  result:=msg;
except
  result:=rsSQLDatabaseS;
end;
end;

function TCDCdb.createDB(cmain: Tconf_main; var ok:boolean): string;
var msg,dbn:string;
    i,j,k:integer;
    indexlist: TStringlist;
begin
ok:=false;
result:='';
try
  if DBtype=mysql then begin
     dbn:=cmain.db;
     db.SetPort(cmain.dbport);
     db.database:='';
     db.Connect(cmain.dbhost,cmain.dbuser,cmain.dbpass,'');
     if db.Active then db.Query('Create Database if not exists '+cmain.db);
     result:=trim(db.ErrorMessage);
     db.Connect(cmain.dbhost,cmain.dbuser,cmain.dbpass,cmain.db);
  end else if DBtype=sqlite then begin
    dbn:=UTF8Encode(cmain.db);
  end;
  if db.database<>dbn then db.Use(dbn);
  if db.database=dbn then begin
    indexlist:=TStringlist.Create;
    ok:=true;
    for i:=1 to numsqltable do begin
      db.Query('CREATE TABLE '+sqltable[dbtype,i,1]+sqltable[dbtype,i,2]);
      msg:=trim(db.ErrorMessage);
      if sqltable[dbtype,i,3]>'' then begin   // create the index
         SplitRec(sqltable[dbtype,i,3],',',indexlist);
         for j:=0 to indexlist.Count-1 do begin
           k:=strtoint(indexlist[j]);
           db.Query('CREATE INDEX '+sqlindex[dbtype,k,1]+' on '+sqlindex[dbtype,k,2]);
         end;
      end;
      if sqltable[dbtype,i,1]<>db.QueryOne(showtable[dbtype]+' "'+sqltable[dbtype,i,1]+'"') then begin
         ok:=false;
         result:=Format(rsErrorCreatin, [result+crlf, sqltable[dbtype, i, 1]+
           blank+msg]);
         break;
      end;
    end;
    indexlist.Free;
  end else begin
     ok:=false;
     result:=result+crlf+trim(db.ErrorMessage);
  end;
  db.flush('tables');
except
end;
end;

function TCDCdb.dropDB(cmain: Tconf_main): string;
var msg:string;
    //i: integer;
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
{  result:='';
  db.StartTransaction;
  for i:=0 to db.Tables.Count-1 do begin
    db.Query('DROP TABLE '+db.Tables[i]);
     msg:=trim(db.ErrorMessage);
     if msg<>'0' then result:=result+msg;
  end;
  db.Commit;
  db.Vacuum;
  msg:=trim(db.ErrorMessage);
  if msg<>'0' then result:=result+msg;}
  db.Close;
  DeleteFile(cmain.db);
end;
end;

procedure TCDCdb.GetCometFileList(cmain:Tconf_main; list:Tstrings);
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

procedure TCDCdb.GetAsteroidFileList(cmain:Tconf_main; list:Tstrings);
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

function TCDCdb.LoadCometFile(comfile:string; memocom:Tmemo):boolean;
var
  buf,cmd,filedesc,filenum :string;
  t,ep,id,nam,ec,q,i,node,peri,eq,h,g  : string;
  y,m,d,nl: integer;
  hh:double;
  f : textfile;
begin
result:=false;
if not fileexists(comfile) then begin
  MemoCom.lines.add(rsFileNotFound);
  exit;
end;
try
if db.Active then begin
  filedesc:=extractfilename(comfile)+blank+FormatDateTime('yyyy-mm-dd hh:nn',FileDateToDateTime(FileAge(comfile)));
  Filemode:=0;
  assignfile(f,comfile);
  reset(f);
  db.starttransaction;
  db.LockTables('cdc_com_elem WRITE, cdc_ast_com_list WRITE, cdc_com_name WRITE');
  nl:=0;
  repeat
    readln(f,buf);
    inc(nl);
    if trim(buf)='' then continue;
    if (nl mod 10000)=0 then begin MemoCom.lines.add(Format(rsProcessingLi, [
      inttostr(nl)])); application.processmessages; end;
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
    q:=trim(copy(buf,31,9));
    ec:=trim(copy(buf,41,9));
    peri:=trim(copy(buf,51,9));
    node:=trim(copy(buf,61,9));
    i:=trim(copy(buf,71,9));
    h:=trim(copy(buf,92,4));
    if trim(h)='' then h:='15';
    g:=trim(copy(buf,97,4));
    if trim(g)='' then g:='4.0';
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
    cmd:='REPLACE INTO cdc_com_elem (id,peri_epoch,peri_dist,eccentricity,arg_perihelion,asc_node,inclination,epoch,h,g,name,equinox,elem_id) VALUES ('
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
    if (not db.query(cmd))and(db.LastError<>19) then begin
       MemoCom.lines.add(Format(rsInsertFailed, [inttostr(nl), trim(
         db.ErrorMessage)]));
    end
      else result:=true; // at least one insert
    cmd:='REPLACE INTO cdc_com_name (name, id) VALUES ('
        +'"'+nam+'"'
        +',"'+id+'"'+')';
    db.query(cmd);
  until eof(f);
  closefile(f);
  MemoCom.lines.add(Format(rsProcessingEn, [inttostr(nl)]));
end else begin
   buf:=trim(db.ErrorMessage);
   if buf<>'0' then MemoCom.lines.add(buf);
end;
db.UnLockTables;
db.commit;
db.flush('tables');
memocom.Lines.SaveToFile(slash(DBDir)+'LoadCometFile.log');
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
  db.LockTables('cdc_com_elem WRITE, cdc_com_elem_list WRITE');
  memocom.lines.add(rsDeleteFromEl);
  application.processmessages;
  if not db.Query('Delete from cdc_com_elem where elem_id='+elem_id) then
     memocom.lines.add(Format(rsFailed, [trim(db.ErrorMessage)]));
  memocom.lines.add('Delete from element list...');
  application.processmessages;
  if not db.Query('Delete from cdc_com_elem_list where elem_id='+elem_id) then
     memocom.lines.add(Format(rsFailed, [trim(db.ErrorMessage)]));
  db.UnLockTables;
  db.commit;
  db.flush('tables');
  memocom.lines.add(rsDeleteDailyD);
  TruncateDailyComet;
  db.Vacuum;
  memocom.lines.add(rsDeleteComple);
end;
except
end;
end;

procedure TCDCdb.DelCometAll(memocom:Tmemo);
begin
memocom.clear;
try
if db.Active then begin
  db.UnLockTables;
  db.starttransaction;
  memocom.lines.add(rsDeleteFromEl);
  application.processmessages;
  db.TruncateTable('cdc_com_elem');
  memocom.lines.add(rsDeleteFromEl2);
  application.processmessages;
  db.TruncateTable('cdc_com_elem_list');
  memocom.lines.add(rsDeleteFromNa);
  application.processmessages;
  db.TruncateTable('cdc_com_name');
  db.commit;
  memocom.lines.add(rsDeleteDailyD);
  TruncateDailyComet;
  db.Vacuum;
  memocom.lines.add(rsDeleteComple);
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
    end else result:=Format(rsInsertFailed2, [trim(db.ErrorMessage)]);
end else begin
   buf:=trim(db.ErrorMessage);
   if buf<>'0' then result:=buf;
end;
db.flush('tables');
except
end;
end;

function TCDCdb.LoadAsteroidFile(astfile:string; astnumbered,stoperr,limit: boolean; astlimit:integer;  memoast:Tmemo):boolean;
var
  buf,cmd,c,filedesc,filenum :string;
  ep,id,nam,ec,ax,i,node,peri,eq,ma,h,g,ref  : string;
  y,m,d,nl,prefl,lid,nerr,ierr,rerr: integer;
  hh:double;
  f : textfile;
begin
nerr:=1;
result:=false;
if not fileexists(astfile) then begin
  memoast.lines.add(rsFileNotFound);
  exit;
end;
try
if db.Active then begin
  filedesc:=extractfilename(astfile)+blank+FormatDateTime('yyyy-mm-dd hh:nn',FileDateToDateTime(FileAge(astfile)));
  Filemode:=0;
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
     memoast.lines.add(rsThisFileWasN);
     raise exception.create('');
  end;
  memoast.lines.add(Format(rsDataStartOnL, [inttostr(nl+1)]));
  prefl:=nl;
  db.starttransaction;
  db.LockTables('cdc_ast_elem WRITE, cdc_ast_elem_list WRITE, cdc_ast_name WRITE');
  nerr:=0;
  rerr:=0;
  nl:=0;
  repeat
    readln(f,buf);
    inc(nl);
    if trim(buf)='' then begin
      if astnumbered then break
                     else continue;
    end;
    if (nl mod 10000)=0 then begin memoast.lines.add(Format(rsProcessingLi, [inttostr(nl)])); application.processmessages; end;
    id:=trim(copy(buf,1,7));
    if id='' then begin dec(nl); inc(rerr); Continue; end;
    lid:=length(id);
    if lid<7 then id:=StringofChar('0',7-lid)+id;
    h:=trim(copy(buf,9,5));
    g:=trim(copy(buf,15,5));
    ep:=trim(copy(buf,21,5));
    if ep='' then begin dec(nl); inc(rerr); Continue; end;
    if decode_mpc_date(ep,y,m,d,hh) then
       ep:=floattostr(jd(y,m,d,hh))
     else begin
       inc(nerr);
       memoast.lines.add(Format(rsInvalidEpoch, [inttostr(nl+prefl), buf]));
       break;
     end;
    ma:=trim(copy(buf,27,9));
    val(ma,tstval,ierr);
    if ierr<>0 then begin dec(nl); inc(rerr); Continue; end;
    peri:=trim(copy(buf,38,9));
    val(peri,tstval,ierr);
    if ierr<>0 then begin dec(nl); inc(rerr); Continue; end;
    node:=trim(copy(buf,49,9));
    val(node,tstval,ierr);
    if ierr<>0 then begin dec(nl); inc(rerr); Continue; end;
    i:=trim(copy(buf,60,9));
    val(i,tstval,ierr);
    if ierr<>0 then begin dec(nl); inc(rerr); Continue; end;
    ec:=trim(copy(buf,71,9));
    val(ec,tstval,ierr);
    if ierr<>0 then begin dec(nl); inc(rerr); Continue; end;
    ax:=trim(copy(buf,93,11));
    val(ax,tstval,ierr);
    if ierr<>0 then begin dec(nl); inc(rerr); Continue; end;
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
    cmd:='REPLACE INTO cdc_ast_elem (id,h,g,epoch,mean_anomaly,arg_perihelion,asc_node,inclination,eccentricity,semi_axis,ref,name,equinox,elem_id) VALUES ('
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
    if (not db.query(cmd))and(db.LastError<>19) then begin
       memoast.lines.add(Format(rsInsertFailed, [inttostr(nl+prefl), trim(
         db.ErrorMessage)]));
       inc(nerr);
       if stoperr and (nerr>1000) then begin
          memoast.lines.add(rsMoreThan1000);
          break;
       end;
    end;
    cmd:='REPLACE INTO cdc_ast_name (name, id) VALUES ('
        +'"'+nam+'"'
        +',"'+id+'"'+')';
    db.query(cmd);
    if limit and (nl>=astlimit) then break;
  until eof(f);
  closefile(f);
  memoast.lines.add(Format(rsProcessingEn2, [inttostr(nl)]));
  if rerr>0 then memoast.lines.add(Format(rsNumberOfIgno, [inttostr(rerr)]));
end else begin
   buf:=trim(db.ErrorMessage);
   if buf<>'0' then memoast.lines.add(buf);
end;
db.UnLockTables;
db.commit;
db.flush('tables');
result:=(nerr=0);
memoast.Lines.SaveToFile(slash(DBDir)+'LoadAsteroidFile.log');
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
  db.LockTables('cdc_ast_elem WRITE, cdc_ast_elem_list WRITE, cdc_ast_mag WRITE');
  memoast.lines.add(rsDeleteFromEl);
  application.processmessages;
  if not db.Query('Delete from cdc_ast_elem where elem_id='+elem_id) then
     memoast.lines.add(Format(rsFailed, [trim(db.ErrorMessage)]));
  memoast.lines.add(rsDeleteFromEl2);
  application.processmessages;
  if not db.Query('Delete from cdc_ast_elem_list where elem_id='+elem_id) then
     memoast.lines.add(Format(rsFailed, [trim(db.ErrorMessage)]));
  memoast.lines.add(rsDeleteFromMo);
  application.processmessages;
  if not db.Query('Delete from cdc_ast_mag where elem_id='+elem_id) then
     memoast.lines.add(Format(rsFailed, [trim(db.ErrorMessage)]));
  db.UnLockTables;
  db.commit;
  db.flush('tables');
  memoast.lines.add(rsDeleteDailyD);
  TruncateDailyAsteroid;
  db.Vacuum;
  memoast.lines.add(rsDeleteComple);
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
  db.LockTables('cdc_ast_mag WRITE');
  memoast.lines.add(Format(rsDeleteFromMo2, [jds]));
  application.processmessages;
  if not db.Query('Delete from cdc_ast_mag where jd<'+jds) then
     memoast.lines.add(Format(rsFailed, [trim(db.ErrorMessage)]));
  db.UnLockTables;
  db.commit;
  db.flush('tables');
  db.Vacuum;
  memoast.lines.add(rsDeleteComple);
end;
except
end;
end;

procedure TCDCdb.DelAstAll(memoast:Tmemo);
begin
memoast.clear;
try
if db.Active then begin
  db.UnLockTables;
  db.starttransaction;
  memoast.lines.add(rsDeleteFromEl);
  application.processmessages;
  db.TruncateTable('cdc_ast_elem');
  memoast.lines.add(rsDeleteFromEl2);
  application.processmessages;
  db.TruncateTable('cdc_ast_elem_list');
  memoast.lines.add(rsDeleteFromNa);
  application.processmessages;
  db.TruncateTable('cdc_ast_name');
  memoast.lines.add(rsDeleteFromMo);
  application.processmessages;
  db.TruncateTable('cdc_ast_mag');
  db.commit;
  memoast.lines.add(rsDeleteDailyD);
  TruncateDailyAsteroid;
  db.Vacuum;
  memoast.lines.add(rsDeleteComple);
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
    end else result:=Format(rsInsertFailed2, [trim(db.ErrorMessage)]);
end else begin
   buf:=trim(db.ErrorMessage);
   if buf<>'0' then result:=buf;
end;
db.flush('tables');
except
end;
end;

procedure TCDCdb.TruncateDailyAsteroid;
var i,j:integer;
    dailytable:Tstringlist;
begin
dailytable:=Tstringlist.create;
try
  db.UnLockTables;
  db.Query(showtable[DBtype]+' "cdc_ast_day_%"');
  i:=0;
  while i<db.Rowcount do begin
     dailytable.add(db.results[i][0]);
     inc(i);
  end;
  j:=0;
  db.StartTransaction;
  while j<dailytable.Count do begin
     db.TruncateTable(dailytable[j]);
     db.Query('drop table '+dailytable[j]);
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
  db.UnLockTables;
  db.Query(showtable[DBtype]+' "cdc_com_day_%"');
  i:=0;
  while i<db.Rowcount do begin
     dailytable.add(db.results[i][0]);
     inc(i);
  end;
  j:=0;
  db.StartTransaction;
  while j<dailytable.Count do begin
     db.TruncateTable(dailytable[j]);
     db.Query('drop table '+dailytable[j]);
     inc(j);
  end;
  db.Commit;
finally
  dailytable.free;
end;
end;

procedure TCDCdb.LoadSampleData(memo:Tmemo; cmain: Tconf_main);
begin
try
  // load sample asteroid data
  if not LoadAsteroidFile(slash(sampledir)+'MPCsample.dat',true,false,false,1000,memo) then begin
     dropdb(cmain);
     raise exception.create('Error loading '+slash(sampledir)+'MPCsample.dat');
  end;
  // load sample comet data
  if not LoadCometFile(slash(sampledir)+'Cometsample.dat',memo) then begin
     dropdb(cmain);
     raise exception.create('Error loading '+slash(sampledir)+'Cometsample.dat');
  end;
  // load location
  if not LoadCountryList(slash(sampledir)+'country.dat',memo) then begin
     dropdb(cmain);
     raise exception.create('Error loading '+slash(sampledir)+'country.dat');
  end;
  if not LoadWorldLocation(slash(sampledir)+'world.dat','',false,memo) then begin
     dropdb(cmain);
     raise exception.create('Error loading '+slash(sampledir)+'world.dat');
  end;
  if not LoadUSLocation(slash(sampledir)+'us.dat',false,memo) then begin
     dropdb(cmain);
     raise exception.create('Error loading '+slash(sampledir)+'us.dat');
  end;
except
  on E: Exception do begin
   WriteTrace('LoadSampleData: '+E.Message);
   MessageDlg('LoadSampleData: '+E.Message+crlf+rsSomethingGoW+crlf
             +rsPleaseTryToR,
             mtError, [mbAbort], 0);
   Halt;
   end;
end;
memo.Lines.SaveToFile(slash(DBDir)+'LoadSampleData.log');
end;

procedure TCDCdb.GetCometList(filter:string; maxnumber:integer; list:TstringList; var cometid: array of string);
var qry: string;
    i: integer;
begin
qry:='SELECT distinct(id),name FROM cdc_com_elem where name like "%'+trim(Filter)+'%" limit '+inttostr(maxnumber);
db.Query(qry);
if db.Rowcount>0 then
  for i:=0 to db.Rowcount-1 do begin
    cometid[i]:=db.Results[i][0];
    list.Add(db.Results[i][1]);
  end;
end;

procedure TCDCdb.GetAsteroidList(filter:string; maxnumber:integer; var list:TstringList; var astid: array of string);
var qry: string;
    i: integer;
begin
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
      dif:=abs(strtofloat(strim(db.Results[i][0]))-now_jd);
      if dif<diff then begin
         result:=strtofloat(strim(db.Results[i][0]));
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
      dif:=abs(strtofloat(strim(db.Results[i][0]))-now_jd);
      if dif<diff then begin
         result:=strtofloat(strim(db.Results[i][0]));
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
    +' and epoch='+strim(formatfloat(f6s,epoch));
db.Query(qry);
if db.rowcount>0 then begin
  if not trystrtofloat(strim(db.Results[0][1]),h) then h:=17;
  if not trystrtofloat(strim(db.Results[0][2]),g) then g:=0.15;
  ma:=strtofloat(strim(db.Results[0][4]));
  ap:=strtofloat(strim(db.Results[0][5]));
  an:=strtofloat(strim(db.Results[0][6]));
  ic:=strtofloat(strim(db.Results[0][7]));
  ec:=strtofloat(strim(db.Results[0][8]));
  sa:=strtofloat(strim(db.Results[0][9]));
  ref:=db.Results[0][10];
  nam:=db.Results[0][11];
  eq:=strtofloat(strim(db.Results[0][12]));
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
  tp:=strtofloat(strim(db.Results[0][1]));
  q:=strtofloat(strim(db.Results[0][2]));
  ec:=strtofloat(strim(db.Results[0][3]));
  ap:=strtofloat(strim(db.Results[0][4]));
  an:=strtofloat(strim(db.Results[0][5]));
  ic:=strtofloat(strim(db.Results[0][6]));
  h:=strtofloat(strim(db.Results[0][8]));
  g:=strtofloat(strim(db.Results[0][9]));
  nam:=db.Results[0][10];
  eq:=strtofloat(strim(db.Results[0][11]));
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
  epoch:=strtofloat(strim(db.Results[0][3]));
  dt:=abs(jd-epoch);
  j:=0;
  i:=1;
  while i<db.Rowcount do begin
    t:=strtofloat(strim(db.Results[i][3]));
    if abs(jd-t)<dt then begin
       epoch:=t;
       dt:=abs(jd-t);
       j:=i;
    end;
    inc(i);
  end;
  if dt>180 then begin
     FAstmsg:=rsWarningSomeA;
  end;
  h:=StrToFloatDef(strim(db.Results[j][1]),20);  // H and G not present in file for some poorly observed asteroids
  g:=StrToFloatDef(strim(db.Results[j][2]),0.15);
  ma:=strtofloat(strim(db.Results[j][4]));
  ap:=strtofloat(strim(db.Results[j][5]));
  an:=strtofloat(strim(db.Results[j][6]));
  ic:=strtofloat(strim(db.Results[j][7]));
  ec:=strtofloat(strim(db.Results[j][8]));
  sa:=strtofloat(strim(db.Results[j][9]));
  ref:=db.Results[j][10];
  nam:=db.Results[j][11];
  eq:=strtofloat(strim(db.Results[j][12]));
  elem_id:=db.Results[j][13];
  result:=true;
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
  epoch:=strtofloat(strim(db.Results[0][7]));
  dt:=abs(jd-epoch);
  j:=0;
  i:=1;
  while i<db.Rowcount do begin
    t:=strtofloat(strim(db.Results[i][7]));
    if abs(jd-t)<dt then begin
       epoch:=t;
       dt:=abs(jd-t);
       j:=i;
    end;
    inc(i);
  end;

  if dt<FComMindt then begin
     FComMindt:=round(dt-1);
  end;
  if dt<36500 then begin // 100 years grace period...
    tp:=strtofloat(strim(db.Results[j][1]));
    q:=strtofloat(strim(db.Results[j][2]));
    ec:=strtofloat(strim(db.Results[j][3]));
    ap:=strtofloat(strim(db.Results[j][4]));
    an:=strtofloat(strim(db.Results[j][5]));
    ic:=strtofloat(strim(db.Results[j][6]));
    h:=strtofloat(strim(db.Results[j][8]));
    g:=strtofloat(strim(db.Results[j][9]));
    nam:=db.Results[j][10];
    eq:=strtofloat(strim(db.Results[j][11]));
    elem_id:=db.Results[j][12];
    result:=true;
  end else
    result:=false;
end else begin
  result:=false;
end;
except
  result:=false;
end;
end;

function TCDCdb.CountImages(catname:string):integer;
begin
try
if db.Active then begin
  result:=strtointdef(db.QueryOne('select count(*) from cdc_fits where catalogname="'+uppercase(catname)+'"'),0);
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
if DirectoryExists(ImagePath) then begin
try
if db.Active then begin
ProgressCat.caption:='';
ProgressBar.position:=0;
j:=findfirst(slash(ImagePath)+'*',faDirectory,c);
while j=0 do begin
  if ((c.attr and faDirectory)<>0)and(c.Name<>'.')and(c.Name<>'..') then begin
  catdir:=slash(ImagePath)+c.Name;
  ProgressCat.caption:=c.Name;
  ProgressBar.position:=0;
  Application.processmessages;
  db.UnLockTables;
  db.starttransaction;
  cmd:='delete from cdc_fits where catalogname="'+uppercase(c.Name)+'"';
  db.query(cmd);
  db.commit;
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
    if f.Name='README.TXT' then begin
       i:=findnext(f);
       continue;
    end;
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
      objn:=uppercase(stringreplace(objn,blank,'',[rfReplaceAll]));
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
         writetrace(Format(rsDBInsertFail, [f.Name, db.ErrorMessage]));
    end
    else
      writetrace(Format(rsInvalidFITSF, [f.Name]));
    i:=findnext(f);
  end;
  db.commit;
  findclose(f);
  end;
  j:=findnext(c);
end;
db.flush('tables');
end;
finally
  findclose(c);
end;
end else begin
  ProgressCat.Caption:='Directory not found!';
end;
except
end;
end;

function TCDCdb.AddFitsArchiveFile(ArchivePath,fn:string):boolean;
var ra,de,w,h,r: double;
    p:integer;
    cmd,objn,fname: string;
begin
  result:=false;
  FFits.FileName:=slash(ArchivePath)+fn;
  ra:=FFits.Center_RA;
  de:=FFits.Center_DE;
  w:=FFits.Img_Width;
  h:=FFits.img_Height;
  r:=FFits.Rotation;
  fname:=FFits.FileName;
  if FFits.header.valid then begin
    objn:=FFits.header.objects;
    if objn>'' then begin
      objn:=StringReplace(objn,'''','',[rfReplaceAll]);
      p:=pos(',',objn);
      if p>0 then objn:=copy(objn,1,p-1);
    end else begin
      objn:=extractfilename(fn);
      p:=pos(extractfileext(objn),objn);
      objn:=copy(objn,1,p-1);
      objn:=uppercase(stringreplace(objn,blank,'',[rfReplaceAll]));
    end;
    cmd:='INSERT INTO cdc_fits (filename,catalogname,objectname,ra,de,width,height,rotation) VALUES ('
      +'"'+stringreplace(fname,'\','\\',[rfReplaceAll])+'"'
      +',"'+uppercase(ArchivePath)+'"'
      +',"'+uppercase(objn)+'"'
      +',"'+formatfloat(f9,ra)+'"'
      +',"'+formatfloat(f9,de)+'"'
      +',"'+formatfloat(f5,w)+'"'
      +',"'+formatfloat(f5,h)+'"'
      +',"'+formatfloat(f5,r)+'"'
      +')';
    if db.query(cmd) then
       result:=true
      else
       writetrace(Format(rsDBInsertFail, [fn, db.ErrorMessage]));
  end
  else writetrace(Format(rsInvalidFITSF, [fn]));
end;

procedure TCDCdb.ScanArchiveDirectory(ArchivePath:string; var count:integer );
var f : tsearchrec;
    i,n:integer;
    cmd:string;
begin
n:=0;
try
if DirectoryExists(ArchivePath) then begin
  if db.Active then begin
    db.UnLockTables;
    db.StartTransaction;
    cmd:='delete from cdc_fits where catalogname="'+uppercase(ArchivePath)+'"';
    db.query(cmd);
    db.Commit;
    i:=findfirst(slash(ArchivePath)+'*.*',0,f);
    db.StartTransaction;
    while i=0 do begin
        if AddFitsArchiveFile(ArchivePath,f.Name) then inc(n);
        i:=findnext(f);
    end;
    findclose(f);
    db.Commit;
    db.flush('tables');
  end;
end;
count:=n;
except
end;
end;

function TCDCdb.LoadCountryList(locfile:string; memo:Tmemo):boolean;
var f: textfile;
    buf,sql: string;
    rec: TStringList;
begin
result:=false;
Memo.clear;
if not fileexists(locfile) then begin
  Memo.lines.add(rsFileNotFound);
  ShowMessage(rsFileNotFound+crlf+locfile);
  exit;
end;
try
if db.Active then begin
  rec:= TStringList.Create;
  Filemode:=0;
  assignfile(f,locfile);
  reset(f);
  db.StartTransaction;
  repeat
    readln(f,buf);
    SplitRec(buf,tab,rec);
    sql:='insert into cdc_country (country,isocode,name)'+
       'values ('+
       '"'+rec[0]+'",'+
       '"'+rec[1]+'",'+
       '"'+rec[2]+'")';
    if not db.Query(sql) then Memo.lines.add(rec[0]+blank+db.ErrorMessage)
       else result:=true;
  until(eof(f));
  db.Commit;
  db.flush('tables');
  closefile(f);
  rec.Free;
end;
memo.Lines.SaveToFile(slash(DBDir)+'LoadCountryList.log');
application.ProcessMessages;
except
end;
end;

function TCDCdb.LoadWorldLocation(locfile,country:string; city_only:boolean; memo:Tmemo):boolean;
var f: textfile;
    buf,sql,cc: string;
    rec: TStringList;
    nl: integer;
    force_country: boolean;
begin
result:=false;
Memo.clear;
if not fileexists(locfile) then begin
  Memo.lines.add(rsFileNotFound);
  exit;
end;
try
if db.Active then begin
  rec:= TStringList.Create;
  nl:=0;
  force_country:=(country<>'');
  Filemode:=0;
  assignfile(f,locfile);
  reset(f);
  readln(f,buf); // heading
  if isnumber(copy(buf,1,1)) then reset(f);
  db.starttransaction;
  db.LockTables('cdc_location WRITE');
  repeat
    readln(f,buf);
    if (nl mod 10000)=0 then begin Memo.lines.add(Format(rsProcessingLi, [
      inttostr(nl)])); application.processmessages; end;
    SplitRec(buf,tab,rec);
    if (rec[17]<>'V') and  // skip alternate name
       ((not  city_only)  // all names
          or ((rec[9]='P')and(rec[10]<>'PPLQ')and(rec[10]<>'PPLW'))  // populated place only
        )
     then begin
       if not IsNumber(rec[3]) then continue;
       if not IsNumber(rec[4]) then continue;
       if force_country then cc:=country
          else cc:=rec[12];
       sql:='insert into cdc_location (locid,country,location,type,latitude,longitude,elevation,timezone)'+
         'values ('+
         rec[2]+','+
         '"'+cc+'",'+
         '"'+strim(rec[22])+'",'+
         '"'+rec[10]+'",'+
         rec[3]+','+
         rec[4]+','+
         '0,'+
         '0)';
       if not db.Query(sql) then Memo.lines.add(rec[2]+blank+cc+blank+db.ErrorMessage)
          else inc(nl);
    end;
  until(eof(f));
  closefile(f);
  rec.Free;
  db.UnLockTables;
  db.commit;
  db.flush('tables');
  Memo.lines.add(Format(rsProcessingEn3, [inttostr(nl)]));
  application.ProcessMessages;
  result:=(nl>0);
end;
memo.Lines.SaveToFile(slash(DBDir)+'LoadWorldLocation.log');
except
end;
end;

function TCDCdb.LoadUSLocation(locfile:string; city_only:boolean; memo:Tmemo; state:string = ''):boolean;
var f: textfile;
    buf,sql: string;
    rec: TStringList;
    nl: integer;
    elev:double;
begin
result:=false;
Memo.clear;
if not fileexists(locfile) then begin
  Memo.lines.add(rsFileNotFound);
  exit;
end;
try
if db.Active then begin
  rec:= TStringList.Create;
  nl:=0;
  Filemode:=0;
  assignfile(f,locfile);
  reset(f);
  readln(f,buf); // heading
  if isnumber(copy(buf,1,1)) then reset(f);
  db.starttransaction;
  db.LockTables('cdc_location WRITE');
  repeat
    if (nl mod 10000)=0 then begin Memo.lines.add(Format(rsProcessingLi, [
      inttostr(nl)])); application.processmessages; end;
    readln(f,buf);
    SplitRec(buf,tab,rec);
     if ((not city_only)  // all names
          or (rec[2]='Populated Place')  // populated place only
        )
     then begin
      if (state<>'')and(state<>rec[3]) then continue; // wrong state
      if not IsNumber(rec[9]) then continue;
      if not IsNumber(rec[10]) then continue;
      elev:=strtointdef(rec[15],0);
      if rec[1]<>rec[5] then rec[1]:=rec[1]+', '+rec[5];
      sql:='insert into cdc_location (locid,country,location,type,latitude,longitude,elevation,timezone)'+
         'values ('+
         rec[0]+','+
         '"US-'+rec[3]+'",'+
         '"'+Condutf8encode(strim(rec[1]))+'",'+
         '"'+rec[2]+'",'+
         rec[9]+','+
         rec[10]+','+
         formatfloat('0.0',elev)+','+
         '0)';
       if not db.Query(sql) then Memo.lines.add(rec[0]+blank+rec[3]+blank+db.ErrorMessage)
          else inc(nl);
    end;
  until(eof(f));
  closefile(f);
  rec.Free;
  db.UnLockTables;
  db.commit;
  db.flush('tables');
  Memo.lines.add(Format(rsProcessingEn3, [inttostr(nl)]));
  Application.ProcessMessages;
  result:=(nl>0);
end;
memo.Lines.SaveToFile(slash(DBDir)+'LoadUSLocation.log');
except
end;
end;

procedure TCDCdb.GetCountryList(codelist,countrylist:Tstrings);
var i:integer;
    buf:string;
begin
countrylist.Clear;
codelist.Clear;
db.Query('select country,name from cdc_country');
i:=0;
while i<db.RowCount do begin
  codelist.add(db.results[i][0]);
  buf:=db.results[i][1];
  countrylist.add(Condutf8decode(buf));
  inc(i);
end;
end;

procedure TCDCdb.GetCountryISOCode(countrycode:string; var isocode: string);
begin
isocode:=db.QueryOne('select isocode from cdc_country where country = "'+countrycode+'"');
end;

procedure TCDCdb.GetCountryFromISO(isocode:string; var cname: string);
begin
cname:=db.QueryOne('select name from cdc_country where isocode = "'+isocode+'"');
end;

procedure TCDCdb.GetCityList(countrycode,filter:string; codelist,citylist:Tstrings; startr,limit:integer);
var i,k:integer;
    prev,buf,bufutf8:string;
begin
citylist.Clear;
codelist.Clear;
filter:=Condutf8encode(filter);
buf:='select locid,location,type from cdc_location where country = "'+countrycode+'" ';
if filter<>'' then buf:=buf+' and location like "'+filter+'" ';
buf:=buf+' order by location limit '+inttostr(startr)+','+inttostr(limit);
db.Query(buf);
i:=0;
k:=0;
prev:='';
while i<db.RowCount do begin
  codelist.add(db.results[i][0]);
  buf:=db.results[i][1];
  if copy(db.results[i][2],1,3)<>'PPL' then
     buf:=buf+' -- '+db.results[i][2];
  if buf=prev then begin
    inc(k);
    buf:=buf+' -- '+inttostr(k);
  end else begin
    prev:=buf;
    k:=0;
  end;
  bufutf8:=Condutf8decode(buf);
  citylist.add(bufutf8);
  inc(i);
end;
if db.RowCount>=limit then citylist.add('...');
end;

procedure TCDCdb.GetCityRange(country:string;lat1,lat2,lon1,lon2:double; codelist,citylist:Tstrings; limit:integer);
var lo1,lo2,la1,la2,buf,prev:string;
    i,k: integer;
begin
la1:=floattostr(lat1);
la2:=floattostr(lat2);
lo1:=floattostr(lon1);
lo2:=floattostr(lon2);
db.Query('select locid,location,type from cdc_location where '+
        'country="'+country+'" and '+
        '(latitude between '+la1+' and '+la2+') and '+
        '(longitude between '+lo1+' and '+lo2+') order by location limit '+inttostr(limit));
i:=0;
k:=0;
prev:='';
while i<db.RowCount do begin
  codelist.add(db.results[i][0]);
  buf:=db.results[i][1];
  if copy(db.results[i][2],1,3)<>'PPL' then
     buf:=buf+' -- '+db.results[i][2];
  if buf=prev then begin
    inc(k);
    buf:=buf+' -- '+inttostr(k);
  end else begin
    prev:=buf;
    k:=0;
  end;
  citylist.add(Condutf8decode(buf));
  inc(i);
end;
end;

function TCDCdb.GetCityLoc(locid:string; var loctype,latitude,longitude,elevation,timezone: string):boolean;
begin
db.Query('select type,latitude,longitude,elevation,timezone from cdc_location where locid="'+locid+'"');
if db.RowCount>0 then begin
  loctype:=db.results[0][0];
  latitude:=db.results[0][1];
  longitude:=db.results[0][2];
  elevation:=db.results[0][3];
  timezone:=db.results[0][4];
  result:=true;
end
else result:=false;
end;

function TCDCdb.UpdateCity(locid:integer; country,location,loctype,lat,lon,elev,tz:string):string;
var id,buf:string;
begin
if locid=0 then begin // Add new location
  id:=CdcMinLocid;
  buf:=db.QueryOne('select max(locid) from cdc_location where locid>='+id);
  if buf<>'' then begin
    id:=inttostr(strtoint(buf)+1)
  end;
  db.StartTransaction;
  db.Query('insert into cdc_location (locid,country,location,type,latitude,longitude,elevation,timezone)'+
       'values ('+
       id+','+
       '"'+country+'",'+
       '"'+Condutf8encode(location)+'",'+
       '"'+loctype+'",'+
       lat+','+
       lon+','+
       elev+','+
       tz+')');
  result:=db.ErrorMessage;
  db.Commit;
end
else begin  // update location
  id:=inttostr(locid);
  db.StartTransaction;
  db.Query('update cdc_location set '+
           'latitude='+lat+','+
           'longitude='+lon+','+
           'elevation='+elev+','+
           'timezone='+tz+
           ' where locid='+id);
  result:=db.ErrorMessage;
  db.Commit;
end;
end;

function TCDCdb.DeleteCity(locid:integer):string;
begin
db.StartTransaction;
db.Query('delete from cdc_location where locid="'+inttostr(locid)+'"');
result:=db.ErrorMessage;
db.Commit;
end;

function TCDCdb.DeleteCountry(country:string; deleteall: boolean):string;
var sql: string;
begin
sql:='delete from cdc_location where country="'+country+'"';
if not deleteall then sql:=sql+' and locid<'+CdcMinLocid;
db.StartTransaction;
db.Query(sql);
result:=db.ErrorMessage;
db.Commit;
end;

end.
