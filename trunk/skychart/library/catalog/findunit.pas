unit findunit;
{
Copyright (C) 2000 Patrick Chevalley

http://www.ap-i.net
pchev@geocities.com

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
{$mode objfpc}{$H+}
interface
Uses sysutils,skylibcat,ngcunit,wdsunit,gcvunit,gscunit,gscfits,gsccompact,bscunit,pgcunit,sacunit,tyc2unit,usnoaunit;

Procedure FindNumNGC(id:Integer ;var ar,de:double; var ok:boolean);
Procedure FindNumIC(id:Integer ;var ar,de:double; var ok:boolean);
Procedure FindNumMessier(id:Integer ;var ar,de:double; var ok:boolean);
Procedure FindNumGCVS(id:string ;var ar,de:double; var ok:boolean);
Procedure FindNumGSC(id : string ;var ar,de:double; var ok:boolean);
Procedure FindNumGSCF(id : string ;var ar,de:double; var ok:boolean);
Procedure FindNumGSCC(id : string ;var ar,de:double; var ok:boolean);
Procedure FindNumGC(id:Integer ;var ar,de:double; var ok:boolean);
Procedure FindNumHR(id:Integer ;var ar,de:double; var ok:boolean);
Procedure FindNumBayer(id:string ;var ar,de:double; var ok:boolean);
Procedure FindNumFlam(id:string ;var ar,de:double; var ok:boolean);
Procedure FindNumHD(id:Integer ;var ar,de:double; var ok:boolean);
Procedure FindNumSAO(id:Integer ;var ar,de:double; var ok:boolean);
Procedure FindNumBD(id:string ;var ar,de:double; var ok:boolean);
Procedure FindNumCD(id:string ;var ar,de:double; var ok:boolean);
Procedure FindNumCPD(id:string ;var ar,de:double; var ok:boolean);
Procedure FindNumPGC(id:Integer ;var ar,de:double; var ok:boolean);
Procedure FindNumSAC(id:string ;var ar,de:double; var ok:boolean);
Procedure FindNumWDS(id:string ;var ar,de:double; var ok:boolean);
Procedure FindNumGcat(path,catshortname,id : string ; keylen : integer; var ar,de:double; var ok:boolean);
Procedure FindNumTYC2(id : string ;var ar,de:double; var ok:boolean);
Procedure FindNumUSNOA(id : string ;var ar,de:double; var ok:boolean);
procedure SetXHIPpath(path : string);

implementation                          

const blank='               ';

var XHIPpath: string;


procedure SetXHIPpath(path : string);
begin
XHIPpath:=noslash(path);
end;

Procedure FindIdxStr(idx, id : string; var ar,de:double; var ok:boolean);
Type idxfil = record
              num : array[1..12] of char;
              ar,de :single;
              end;
var
    imin,imax,i : integer;
    pnum : string;
    fx : file of idxfil ;
    lin : idxfil;
begin
ok:=false;
if not fileexists(idx) then begin
   exit;
end;
AssignFile(fx,idx);
FileMode:=0;
Reset(fx);
imin:=0;
imax := filesize(fx);
lin.num:='';
repeat
  pnum:=lin.num;
  i:=imin + ((imax-imin) div 2);
  seek(fx,i);
  read(fx,lin);
  if lin.num>id then imax:=i
                else imin:=i;
  if lin.num=id then ok:=true;
until ok or (pnum=lin.num);
CloseFile(fx);
if ok then begin
   ar:=lin.ar/15;
   de:=lin.de;
end;
end;

Procedure FindIdx(idx : string; id:Integer ;var ar,de:double; var ok:boolean);
type idxfil = record num :longint ;
                 ar,de :single;
                 end;
var
    imin,imax,i,pnum : integer;
    fx : file of idxfil ;
    lin : idxfil;
begin
ok:=false;
if not fileexists(idx) then begin
   exit;
end;
AssignFile(fx,idx);
FileMode:=0;
Reset(fx);
imin:=0;
imax := filesize(fx);
lin.num:=-MaxInt;
repeat
  pnum:=lin.num;
  i:=imin + ((imax-imin) div 2);
  seek(fx,i);
  read(fx,lin);
  if lin.num>id then imax:=i
                else imin:=i;
  if lin.num=id then ok:=true;
until ok or (pnum=lin.num);
CloseFile(fx);
if ok then begin
   ar:=lin.ar/15;
   de:=lin.de;
end;
end;

Procedure FindNumNGC(id:Integer ;var ar,de:double; var ok:boolean);
begin
FindIdx(NGCpath+slashchar+'ngc.idx',id,ar,de,ok);
end;

Procedure FindNumIC(id:Integer ;var ar,de:double; var ok:boolean);
begin
FindIdx(NGCpath+slashchar+'ic.idx',id,ar,de,ok);
end;

Procedure FindNumMessier(id:Integer ;var ar,de:double; var ok:boolean);
begin
FindIdx(NGCpath+slashchar+'messier.idx',id,ar,de,ok);
end;

{$NOTES OFF}
function IsNumber(n : string) : boolean;
var i : integer;
    dummy_double : double;
begin
val(n,Dummy_double,i);
result:= (i=0) ;
end;
{$NOTES ON}

Procedure FindNumGCVS(id:string ;var ar,de:double; var ok:boolean);
var buf,buf1,buf2 : string;
begin
buf1:=words(id,'',1,1);
buf2:=words(id,'',2,1);
buf1:=uppercase(buf1)+blank;
if trim(buf1)='NSV' then buf2:=padzeros(buf2,5);
if copy(buf1,1,1)='V' then begin
   buf:=trim(copy(buf1,2,99));
   if IsNumber(buf) then buf1:='V'+padzeros(buf,4)+blank;
end;
buf2:=uppercase(buf2)+blank;
if copy(buf2,1,1)='V' then begin
   buf:=trim(copy(buf2,2,99));
   if IsNumber(buf) then buf2:='V'+padzeros(buf,4)+blank;
end;
buf:=copy(buf1,1,6)+copy(buf2,1,6);
FindIdxStr(GCVpath+slashchar+'gcvs.idx',buf,ar,de,ok);
end;

Procedure FindNumGSC(id : string ;var ar,de:double; var ok:boolean);
var smnum,num,p : integer;
    buf:string;
begin
ok:=false;
buf:=trim(id);
p:=pos('-',buf);
if p>0 then begin
   smnum:=strtoint(copy(buf,1,p-1));
   num:=strtoint(copy(buf,p+1,5));
   FindGSCnum(smnum,num,ar,de,ok);
end;
end;

Procedure FindNumGSCF(id : string ;var ar,de:double; var ok:boolean);
var smnum,num,p : integer;
    buf:string;
begin
ok:=false;
buf:=trim(id);
p:=pos('-',buf);
if p>0 then begin
   smnum:=strtoint(copy(buf,1,p-1));
   num:=strtoint(copy(buf,p+1,5));
   FindGSCFnum(smnum,num,ar,de,ok);
end;
end;

Procedure FindNumGSCC(id : string ;var ar,de:double; var ok:boolean);
var smnum,num : integer;
    p : integer;
    buf:string;
begin
ok:=false;
buf:=trim(id);
p:=pos('-',buf);
if p>0 then begin
   smnum:=strtoint(copy(buf,1,p-1));
   num:=strtoint(copy(buf,p+1,5));
   FindGSCCnum(smnum,num,ar,de,ok);
end;
end;

Procedure FindNumTYC2(id : string ;var ar,de:double; var ok:boolean);
var smnum,num : integer;
    p : integer;
    buf:string;
begin
ok:=false;
buf:=trim(id);
p:=pos('-',buf);
if p>0 then begin
   smnum:=strtoint(copy(buf,1,p-1));
   buf:=copy(buf,p+1,5);
   p:=pos('-',buf);
   if p>0 then delete(buf,p,5);
   num:=strtoint(buf);
   FindTYC2num(smnum,num,ar,de,ok);
end;
end;

Procedure FindNumUSNOA(id : string ;var ar,de:double; var ok:boolean);
var smnum,num : integer;
    p : integer;
    buf:string;
begin
ok:=false;
buf:=trim(id);
p:=pos('-',buf);
if p>0 then begin
   smnum:=strtoint(copy(buf,1,p-1));
   num:=strtoint(copy(buf,p+1,99));
   FindUSNOAnum(smnum,num,ar,de,ok);
end;
end;

Procedure FindNumGC(id:Integer ;var ar,de:double; var ok:boolean);
begin
FindIdx(BSCpath+slashchar+'gc.idx',id,ar,de,ok);
end;

Procedure FindNumHR(id:Integer ;var ar,de:double; var ok:boolean);
var buf:string;
begin
buf:='HR'+inttostr(id);
FindNumGcat(XHIPpath,'ixhr',buf,9,ar,de,ok);
end;

Procedure FindNumBayer(id:string ;var ar,de:double; var ok:boolean);
begin
FindNumGcat(XHIPpath,'ixhr',id,9,ar,de,ok);
end;

Procedure FindNumFlam(id:string ;var ar,de:double; var ok:boolean);
begin
FindNumGcat(XHIPpath,'ixhr',id,9,ar,de,ok);
end;

Procedure FindNumWDS(id:string ;var ar,de:double; var ok:boolean);
var buf : string;
begin
buf:=copy(uppercase(stringreplace(id,' ','',[rfReplaceAll]))+'             ',1,12);
FindIdxStr(WDSpath+slashchar+'wds.idx',buf,ar,de,ok);
end;

Procedure FindNumHD(id:Integer ;var ar,de:double; var ok:boolean);
begin
FindIdx(BSCpath+slashchar+'hd.idx',id,ar,de,ok);
end;

Procedure FindNumSAO(id:Integer ;var ar,de:double; var ok:boolean);
begin
FindIdx(BSCpath+slashchar+'sao.idx',id,ar,de,ok);
end;

Procedure FindNumBD(id:string ;var ar,de:double; var ok:boolean);
var sign,buf : string;
    zone,num,p : integer;
begin
buf:=trim(id);
p:=pos(' ',buf);
if p>0 then begin
   sign:=copy(buf,1,1);
   zone:=strtoint(sign+trim(copy(buf,2,p-1)));
   num:=strtoint(sign+trim(copy(buf,p+1,5)));
   num:=100000*zone + num;
   FindIdx(BSCpath+slashchar+'bd.idx',num,ar,de,ok);
end;
end;

Procedure FindNumCD(id:string ;var ar,de:double; var ok:boolean);
var sign,buf : string;
    zone,num,p : integer;
begin
buf:=trim(id);
p:=pos(' ',id);
if p>0 then begin
   sign:=copy(buf,1,1);
   zone:=strtoint(sign+trim(copy(buf,2,p-1)));
   num:=strtoint(sign+trim(copy(buf,p+1,5)));
   num:=100000*zone + num;
   FindIdx(BSCpath+slashchar+'cd.idx',num,ar,de,ok);
end;
end;

Procedure FindNumCPD(id:string ;var ar,de:double; var ok:boolean);
var sign,buf : string;
    zone,num,p : integer;
begin
buf:=trim(id);
p:=pos(' ',buf);
if p>0 then begin
   sign:=copy(buf,1,1);
   zone:=strtoint(sign+trim(copy(buf,2,p-1)));
   num:=strtoint(sign+trim(copy(buf,p+1,5)));
   num:=100000*zone + num;
   FindIdx(BSCpath+slashchar+'cp.idx',num,ar,de,ok);
end;
end;

Procedure FindNumPGC(id:Integer ;var ar,de:double; var ok:boolean);
begin
FindIdx(PGCpath+slashchar+'pgc.idx',id,ar,de,ok);
end;

Procedure FindNumSAC(id : string ;var ar,de:double; var ok:boolean);
Type idxfil = record
              num : string[18];
              ar,de :single;
              end;
var
    imin,imax,i : integer;
    pnum,idx,buf : string;
    fx : file of idxfil ;
    lin : idxfil;
begin
buf:=Uppercase(stringreplace(id,' ','',[rfReplaceAll]));
idx:=SACpath+slashchar+'sac.idx';
ok:=false;
if not fileexists(idx) then begin
   exit;
end;
AssignFile(fx,idx);
FileMode:=0;
Reset(fx);
imin:=0;
imax := filesize(fx);
lin.num:='';
repeat
  pnum:=lin.num;
  i:=imin + ((imax-imin) div 2);
  seek(fx,i);
  read(fx,lin);
  if lin.num>buf then imax:=i
                else imin:=i;
  if lin.num=buf then ok:=true;
until ok or (pnum=lin.num);
CloseFile(fx);
if ok then begin
   ar:=lin.ar/15;
   de:=lin.de;
end;
end;

Procedure FindNumGcat(path,catshortname,id : string ; keylen : integer; var ar,de:double; var ok:boolean);
Type
Tixrec = record ra,dec : single;
                   key : array [0..512] of char;
         end;
var
    reclen,n : integer;
    imin,imax,i: Int64;
    num,pnum,idx,buf : string;
    fx : file;
    lin : Tixrec;
begin
buf:=uppercase(stringreplace(id,' ','',[rfReplaceAll]));
idx:=path+slashchar+catshortname+'.idx';
ok:=false;
if not fileexists(idx) then begin
   exit;
end;
reclen:=keylen+8;
AssignFile(fx,idx);
FileMode:=0;
Reset(fx,1);
imin:=0;
imax := filesize(fx) div reclen;
num:='';
repeat
  pnum:=num;
  i:=(imin + ((imax-imin) div 2))*reclen;
  seek(fx,i);
  blockread(fx,lin,reclen,n);
  num:=trim(copy(lin.key,1,keylen));
  if num>buf then imax:=i div reclen
            else imin:=i div reclen;
  if num=buf then ok:=true;
until ok or (pnum=num);
CloseFile(fx);
if ok then begin
   ar:=lin.ra/15;
   de:=lin.dec;
end;
end;

end.
