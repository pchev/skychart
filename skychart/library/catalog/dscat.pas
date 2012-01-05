unit dscat;
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

uses skylibcat, sysutils;

type
StarRecType = packed record
                  RA  : single;
                  Dec : single;
                  Mag : byte;
              end;
Star1RecType = packed record
                  RA  : double;
                  Dec : double;
                  Mag : byte;
              end;
DSRec = record
                  RA  : double;
                  Dec : double;
                  Mag : double;
              end;

Function IsDSbasepath(path : shortstring) : Boolean; stdcall;
Function IsDStycpath(path : shortstring) : Boolean; stdcall;
Function IsDSgscpath(path : shortstring) : Boolean; stdcall;
procedure SetDSpath(path,tycpath,gscpath : shortstring); stdcall;
Procedure OpenDSTYC(ar1,ar2,de1,de2: double ; var ok : boolean); stdcall;
Procedure OpenDSTYCwin(var ok : boolean); stdcall;
Procedure ReadDSTYC(var dslin : DSrec; var ok : boolean); stdcall;
Procedure NextDSTYC( var ok : boolean); stdcall;
procedure CloseDSTYC ; stdcall;
Procedure OpenDSGSC(ar1,ar2,de1,de2: double ; var ok : boolean); stdcall;
Procedure OpenDSGSCwin(var ok : boolean); stdcall;
Procedure ReadDSGSC(var dslin : DSrec; var ok : boolean); stdcall;
Procedure NextDSGSC( var ok : boolean); stdcall;
procedure CloseDSGSC ; stdcall;
Procedure OpenDSbase(ar1,ar2,de1,de2: double ; var ok : boolean); stdcall;
Procedure OpenDSbasewin(var ok : boolean); stdcall;
Procedure ReadDSbase(var dslin : DSrec; var ok : boolean); stdcall;
procedure CloseDSbase ; stdcall;

var
  DSpath, DSTYCpath, DSGSCpath: String;

implementation

var
   fds : file of StarRecType ;
   fbase : file of Star1RecType;
   lin : StarRecType ;
   lbase : Star1RecType;
   curSM, nSM, Imax, Icache : integer;
   zone : string;
   zonelst : array[1..432] of string;
   FileIsOpen : Boolean = false;
   BaseFileIsOpen : Boolean = false;
   OnCache : Boolean = false;
   Cache : array of DSrec;

Function IsDSbasepath(path : shortstring) : Boolean;
begin
result:= FileExists(slash(path)+'star5.dat');
end;

Function IsDStycpath(path : shortstring) : Boolean;
begin
result:= FileExists(slash(path)+'00N00.dat');
end;

Function IsDSgscpath(path : shortstring) : Boolean;
begin
result:= FileExists(slash(path)+'00N00.dat');
end;

procedure SetDSpath(path,tycpath,gscpath : shortstring);
begin
path:=noslash(path);
if path<>DSpath then OnCache:=false;
DSpath:=path;
DSTYCpath:=tycpath;
DSGSCpath:=gscpath;
end;

// TYC

Procedure CloseRegion;
begin
{$I-}
if fileisopen then begin
FileisOpen:=false;
closefile(fds);
end;
{$I+}
end;

Procedure OpenRegionTYC(zone : string ; var ok:boolean);
var nomfich :string;
begin
nomfich:=DSTYCpath+slashchar+zone+'.dat';
if not FileExists(nomfich) then begin
   ok:=false;
   exit;
end;
if fileisopen then CloseRegion;
AssignFile(fds,nomfich);
FileisOpen:=true;
FileMode:=0;
reset(fds);
ok:=true;
end;

Procedure OpenDSTYC(ar1,ar2,de1,de2: double ; var ok : boolean);
begin
curSM:=1;
ar1:=ar1*15; ar2:=ar2*15;
FindRegionListDS(ar1,ar2,de1,de2,nSM,zonelst);
zone := zonelst[curSM];
OpenRegionTYC(zone,ok);
end;

Procedure ReadDSTYC(var dslin : DSrec; var ok : boolean);
begin
ok:=true;
if eof(fds) then NextDSTYC(ok);
if ok then begin
   Read(fds,lin);
   dslin.ra := lin.RA;
   dslin.Dec:= lin.Dec;
   dslin.Mag:= lin.Mag/10;
end;
end;

Procedure NextDSTYC( var ok : boolean);
begin
  CloseRegion;
  inc(curSM);
  if curSM>nSM then ok:=false
  else begin
    zone := zonelst[curSM];
    OpenRegionTYC(zone,ok);
  end;
end;

procedure CloseDSTYC ;
begin
curSM:=nSM;
CloseRegion;
end;

Procedure OpenDSTYCwin(var ok : boolean);
begin
curSM:=1;
FindRegionListWinDS(nSM,zonelst);
zone := zonelst[curSM];
OpenRegionTYC(zone,ok);
end;

//   GSC

Procedure OpenRegionGSC(zone : string ; var ok:boolean);
var nomfich :string;
begin
nomfich:=DSGSCpath+slashchar+zone+'.dat';
if not FileExists(nomfich) then begin
   ok:=false;
   exit;
end;
if fileisopen then CloseRegion;
AssignFile(fds,nomfich);
FileisOpen:=true;
FileMode:=0;
reset(fds);
ok:=true;
end;

Procedure OpenDSGSC(ar1,ar2,de1,de2: double ; var ok : boolean);
begin
curSM:=1;
ar1:=ar1*15; ar2:=ar2*15;
FindRegionListDS(ar1,ar2,de1,de2,nSM,zonelst);
zone := zonelst[curSM];
OpenRegionGSC(zone,ok);
end;

Procedure ReadDSGSC(var dslin : DSrec; var ok : boolean);
begin
ok:=true;
if eof(fds) then NextDSGSC(ok);
if ok then begin
   Read(fds,lin);
   dslin.ra := lin.RA;
   dslin.Dec:= lin.Dec;
   dslin.Mag:= lin.Mag/10;
end;
end;

Procedure NextDSGSC( var ok : boolean);
begin
  CloseRegion;
  inc(curSM);
  if curSM>nSM then ok:=false
  else begin
    zone := zonelst[curSM];
    OpenRegionGSC(zone,ok);
  end;
end;

procedure CloseDSGSC ;
begin
curSM:=nSM;
CloseRegion;
end;

Procedure OpenDSGSCwin(var ok : boolean);
begin
curSM:=1;
FindRegionListWinDS(nSM,zonelst);
zone := zonelst[curSM];
OpenRegionGSC(zone,ok);
end;

// base

Procedure CloseRegionBase;
begin
{$I-}
if basefileisopen then begin
baseFileisOpen:=false;
closefile(fbase);
end;
{$I+}
end;

Procedure OpenRegionBase(var ok:boolean);
var nomfich :string;
begin
if not OnCache then begin
   nomfich:=DSpath+slashchar+'star1.dat';
   if not FileExists(nomfich) then begin
      ok:=false;
      exit;
   end;
   if basefileisopen then CloseRegionBase;
   AssignFile(fbase,nomfich);
   baseFileisOpen:=true;
   FileMode:=0;
   reset(fbase);
   if Usecache then begin
      SetLength(cache,1);
      Imax:=filesize(fbase)-1;
      SetLength(cache,Imax+1);
   end;
end;
Icache:=0;
ok:=true;
end;

Procedure OpenDSbase(ar1,ar2,de1,de2: double ; var ok : boolean);
begin
OpenRegionBase(ok);
end;

Procedure ReadDSbase(var dslin : DSrec; var ok : boolean);
begin
ok:=true;
inc(Icache);
if ((OnCache and(Icache>Imax))or((not OnCache) and eof(fbase))) then begin
   ok:=false;
   If Usecache then Oncache:=true;
end;
if ok then begin
if OnCache then begin
   dslin:=cache[Icache];
end else begin
   Read(fbase,lbase);
   dslin.ra := lbase.RA;
   dslin.Dec:= lbase.Dec;
   dslin.Mag:= lbase.Mag/10;
   if UseCache then cache[Icache]:=dslin;
end;
end;
end;

procedure CloseDSbase ;
begin
CloseRegionBase;
end;

Procedure OpenDSbasewin(var ok : boolean);
begin
curSM:=1;
Nsm:=1;
OpenRegionBase(ok);
end;

end.
