unit ticunit;
{
Copyright (C) 2000 Patrick Chevalley

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

uses
  skylibcat, sysutils;
type
    TICrec = record
                     ar,de : longint;
                     gscz: word;
                     gscn: word;
                     mb,mv :smallint;
                     end;
Function IsTICpath(path : shortstring) : Boolean; stdcall;
procedure SetTICpath(path : shortstring); stdcall;
Procedure OpenTIC(ar1,ar2,de1,de2: double ; var ok : boolean); stdcall;
Procedure OpenTICwin(var ok : boolean); stdcall;
Procedure ReadTIC(var lin : TICrec; var SMnum : shortstring ; var ok : boolean); stdcall;
Procedure NextTIC( var ok : boolean); stdcall;
procedure CloseTIC ; stdcall;


var
  TICpath: String='';

implementation

const CacheNum = 100;

var
   ftic : file of TICrec ;
   curSM : integer;
   SMname,NomFich : string;
   hemis : char;
   zone,Sm,nSM : integer;
   hemislst : array[1..732] of char;
   zonelst,SMlst : array[1..732] of integer;
   FileIsOpen : Boolean = false;
   cache : array[1..CacheNum] of array of TICrec;
   cachelst,Imax,Iread : array[1..CacheNum] of integer;
   OnCache : boolean;
   Ncache,Icache : integer;
   lastcache : integer = 0;

Function IsTICpath(path : shortstring) : Boolean;
var p : string;
begin
p:=slash(path);
result:=    FileExists(p+'N0000'+slashchar+'001.dat')
         or FileExists(p+'N0730'+slashchar+'049.dat')
         or FileExists(p+'N1500'+slashchar+'096.dat')
         or FileExists(p+'N2230'+slashchar+'141.dat')
         or FileExists(p+'N3000'+slashchar+'184.dat')
         or FileExists(p+'N3730'+slashchar+'224.dat')
         or FileExists(p+'N4500'+slashchar+'260.dat')
         or FileExists(p+'N5230'+slashchar+'292.dat')
         or FileExists(p+'N6000'+slashchar+'319.dat')
         or FileExists(p+'N6730'+slashchar+'340.dat')
         or FileExists(p+'N7500'+slashchar+'355.dat')
         or FileExists(p+'N8230'+slashchar+'364.dat')
         or FileExists(p+'S0000'+slashchar+'367.dat')
         or FileExists(p+'S0730'+slashchar+'415.dat')
         or FileExists(p+'S1500'+slashchar+'462.dat')
         or FileExists(p+'S2230'+slashchar+'507.dat')
         or FileExists(p+'S3000'+slashchar+'550.dat')
         or FileExists(p+'S3730'+slashchar+'590.dat')
         or FileExists(p+'S4500'+slashchar+'626.dat')
         or FileExists(p+'S5230'+slashchar+'658.dat')
         or FileExists(p+'S6000'+slashchar+'685.dat')
         or FileExists(p+'S6730'+slashchar+'706.dat')
         or FileExists(p+'S7500'+slashchar+'721.dat')
         or FileExists(p+'S8230'+slashchar+'730.dat')
end;

procedure SetTICpath(path : shortstring);
var i : integer;
begin
path:=noslash(path);
if path<>TICpath then for i:=1 to CacheNum do cachelst[i]:=0;
TICpath:=path;
end;

Procedure CloseRegion;
begin
{$I-}
if fileisopen then begin
FileisOpen:=false;
closefile(ftic);
end;
{$I+}
end;

Procedure Openfile(nomfich : string; var ok : boolean);
begin
ok:=false;
if not FileExists(nomfich) then begin
   ok:=false;
   exit;
end;
AssignFile(ftic,nomfich);
FileisOpen:=true;
FileMode:=0;
reset(ftic);
ok:=true;
end;

Procedure OpenRegion(hemis : char ;zone,S : integer ; var ok:boolean);
var nomzone,nomreg :string;
    i,j : integer;
begin
OnCache:=false;
if UseCache then for i:=1 to CacheNum do if cachelst[i]=s then begin OnCache:=true; Ncache:=i; break; end;
str(S:3,nomreg);
SMname:=nomreg;
Icache:=-1;
if fileisopen then CloseRegion;
str(abs(zone):4,nomzone);
nomfich:=TICpath+slashchar+hemis+padzeros(nomzone,4)+slashchar+padzeros(nomreg,3)+'.dat';
if not OnCache then begin
OpenFile(nomfich,ok);
if not ok then exit;
if UseCache then begin
   j:=lastcache+1;
   if j>CacheNum then j:=1;
   cachelst[j]:=s;
   Ncache:=j;
   lastcache:=j;
   SetLength(cache[Ncache],1);
   Imax[Ncache]:=filesize(ftic)-1;
   Iread[Ncache]:=0;
   SetLength(cache[Ncache],Imax[Ncache]+1);
end;
end;
ok:=true;
end;

Procedure OpenTIC(ar1,ar2,de1,de2: double ; var ok : boolean);
begin
curSM:=1;
ar1:=ar1*15; ar2:=ar2*15;
if Usecache then FindRegionList7(ar1,ar2,de1,de2,nSM,zonelst,SMlst,hemislst)
            else FindRegionAll7(ar1,ar2,de1,de2,nSM,zonelst,SMlst,hemislst);
hemis:= hemislst[curSM];
zone := zonelst[curSM];
Sm := Smlst[curSM];
OpenRegion(hemis,zone,Sm,ok);
end;

Procedure ReadTIC(var lin : TICrec; var SMnum : shortstring ; var ok : boolean);
begin
ok:=true;
inc(Icache);
while ok and((OnCache and(Icache>Imax[Ncache]))or((not OnCache) and eof(ftic))) do begin
  dec(Icache);
  NextTIC(ok);
  inc(Icache);
end;
if OnCache then begin
  if ok then begin
     if Icache<=Iread[ncache] then lin:=cache[Ncache,Icache]
     else begin
       if not fileisopen then begin
          OpenFile(nomfich,ok);
          if not ok then exit;
          seek(ftic,Icache);
       end;
       Read(ftic,lin);
       cache[Ncache,Icache]:=lin;
       Iread[ncache]:=Icache;
     end;
  end;
end else begin
  if ok then begin
     Read(ftic,lin);
     if UseCache then begin
        cache[Ncache,Icache]:=lin;
        Iread[ncache]:=Icache;
     end;
  end;
end;
SMnum:=SMname;
end;

Procedure NextTIC( var ok : boolean);
begin
if OnCache then begin
end else begin
  CloseRegion;
end;
  inc(curSM);
  if curSM>nSM then ok:=false
  else begin
    hemis:= hemislst[curSM];
    zone := zonelst[curSM];
    Sm := Smlst[curSM];
    OpenRegion(hemis,zone,Sm,ok);
  end;
end;

procedure CloseTIC ;
begin
curSM:=nSM;
CloseRegion;
end;

Procedure OpenTICwin(var ok : boolean);
begin
curSM:=1;
if usecache then FindRegionListWin7(nSM,zonelst,SMlst,hemislst)
            else FindRegionAllWin7(nSM,zonelst,SMlst,hemislst);
hemis:= hemislst[curSM];
zone := zonelst[curSM];
Sm := Smlst[curSM];
OpenRegion(hemis,zone,Sm,ok);
end;

end.
