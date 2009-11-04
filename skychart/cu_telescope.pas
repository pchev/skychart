{
Copyright (C) 2004 Patrick Chevalley

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
unit cu_telescope;
{
  Windows specific telescope interface compatible with V2.75 drivers
}
{$mode objfpc}{$H+}
interface

Uses
  {$ifdef win32}
    ActiveX,
  {$endif}
  dynlibs,
  u_translation, u_util, SysUtils, Types,Classes,Dialogs;

type

  TScopeConnect   = Procedure(var ok : boolean); stdcall;
  TScopeDisconnect= Procedure(var ok : boolean); stdcall;
  TScopeAlign     = Procedure(source : string; ra,dec : double); stdcall;
  TScopeShowModal = Procedure(var ok : boolean); stdcall;
  TScopeShow      = Procedure; stdcall;
  TScopeClose     = Procedure; stdcall;
  TScopeGetRaDec  = Procedure (var ar,de : double; var ok : boolean); stdcall;
  TScopeGetAltAz  = Procedure (var alt,az : double; var ok : boolean); stdcall;
  TScopeGetName   = Procedure (var name : shortstring); stdcall;
  TScopeReset     = Procedure; stdcall;
  TScopeConnected  = Function : boolean; stdcall;
  TScopeGetInfo    = Procedure (var Name : shortstring; var QueryOK,SyncOK,GotoOK : boolean; var refreshrate : integer); stdcall;
  TScopeInitialized = Function   : boolean; stdcall;
  TScopeSetObs     = Procedure (latitude,longitude : double); stdcall;
  TScopeGoto       = Procedure (ar,de : double; var ok : boolean); stdcall;
  TScopeGetEqSys   = Procedure (var EqSys : double); stdcall;

  TTelescope = class(TComponent)
  private
    { Private declarations }
    Fscopelib : TLibHandle;
    Fscopelibok : boolean;
    Fpluginpath : string;
    Fplugin : string;
    FScopeConnect : TScopeConnect;
    FScopeDisconnect : TScopeDisconnect;
    FScopeAlign : TScopeAlign;
    FScopeShowModal : TScopeShowModal;
    FScopeShow : TScopeShow;
    FScopeClose : TScopeClose;
    FScopeGetRaDec : TScopeGetRaDec;
    FScopeGetAltAz : TScopeGetAltAz;
    FScopeGetName : TScopeGetName;
    FScopeReset : TScopeReset;
    FScopeConnected : TScopeConnected;
    FScopeInitialized : TScopeInitialized;
    FScopeGetInfo : TScopeGetInfo;
    FScopeSetObs : TScopeSetObs;
    FScopeGoto : TScopeGoto;
    FScopeGetEqSys : TScopeGetEqSys;

  protected
  public
     constructor Create(AOwner:TComponent); override;
     destructor  Destroy; override;
  published
     procedure InitScopeLibrary;
     procedure UnloadScopeLibrary;
     function  ScopeConnect: boolean;
     function  ScopeDisconnect : boolean;
     procedure ScopeAlign(source : string; ra,dec : double);
     function  ScopeShowModal : boolean;
     procedure ScopeShow;
     procedure ScopeClose;
     procedure ScopeGetEqSys(var EqSys : double);
     procedure ScopeGetRaDec(var ar,de : double; var ok : boolean);
     procedure ScopeGetAltAz(var alt,az : double; var ok : boolean);
     procedure ScopeGetName(var scopename : shortstring);
     procedure ScopeReset;
     function  ScopeConnected : boolean;
     function  ScopeInitialized : boolean;
     procedure ScopeGetInfo(var scopename : shortstring; var QueryOK,SyncOK,GotoOK : boolean; var refreshrate : integer);
     procedure ScopeSetObs(latitude,longitude : double);
     procedure ScopeGoto(ar,de : double; var ok : boolean);
     property pluginpath : string read Fpluginpath write Fpluginpath;
     property plugin : string read Fplugin write Fplugin;
     property scopelibok : boolean read Fscopelibok;
  end;

implementation

constructor TTelescope.Create(AOwner:TComponent);
begin
 inherited Create(AOwner);
 Fscopelib := 0;
 Fscopelibok := false;
 Fplugin:='ascom.tid';
end;

destructor TTelescope.Destroy;
begin
try
 UnloadScopeLibrary;
 inherited destroy;
except
writetrace('error destroy '+name);
end;
end;

Procedure TTelescope.UnloadScopeLibrary;
var ok : boolean;
begin
try
if Fscopelib<>0 then begin
   Fscopelibok:=false;
   FScopeDisconnect(ok);
   FScopeClose;
   Fscopelib:=0;
  {$ifdef win32}
    CoUnInitialize;
  {$endif}
end;
except
end;
end;

Procedure TTelescope.InitScopeLibrary;
begin
try
UnloadScopeLibrary;
Fscopelib := LoadLibrary(Pchar(Fpluginpath+Fplugin));
if Fscopelib<>0 then begin
    FScopeClose := TScopeClose(GetProcedureAddress(Fscopelib, 'ScopeClose'));
    FScopeConnect := TScopeConnect(GetProcedureAddress(Fscopelib, 'ScopeConnect'));
    FScopeDisconnect := TScopeDisconnect(GetProcedureAddress(Fscopelib, 'ScopeDisconnect'));
    FScopeAlign := TScopeAlign(GetProcedureAddress(Fscopelib, 'ScopeAlign'));
    FScopeShowModal := TScopeShowModal(GetProcedureAddress(Fscopelib, 'ScopeShowModal'));
    FScopeShow := TScopeShow(GetProcedureAddress(Fscopelib, 'ScopeShow'));
    FScopeGetRaDec := TScopeGetRaDec(GetProcedureAddress(Fscopelib, 'ScopeGetRaDec'));
    FScopeGetAltAz := TScopeGetAltAz(GetProcedureAddress(Fscopelib, 'ScopeGetAltAz'));
    FScopeGetName := TScopeGetName(GetProcedureAddress(Fscopelib, 'ScopeGetName'));
    FScopeReset := TScopeReset(GetProcedureAddress(Fscopelib, 'ScopeReset'));
    FScopeConnected := TScopeConnected(GetProcedureAddress(Fscopelib, 'ScopeConnected'));
    FScopeInitialized := TScopeInitialized(GetProcedureAddress(Fscopelib, 'ScopeInitialized'));
    FScopeGetInfo := TScopeGetInfo(GetProcedureAddress(Fscopelib, 'ScopeGetInfo'));
    FScopeSetObs := TScopeSetObs(GetProcedureAddress(Fscopelib, 'ScopeSetObs'));
    FScopeGoto := TScopeGoto(GetProcedureAddress(Fscopelib, 'ScopeGoto'));
    FScopeGetEqSys := TScopeGetEqSys(GetProcedureAddress(Fscopelib, 'ScopeGetEqSys'));
    Fscopelibok:=true;
   {$ifdef win32}
    CoInitialize(nil);
   {$endif}
end else begin
    Fscopelibok:=false;
    Showmessage(Format(rsErrorOpening, [Fplugin]));
end;
except
 Fscopelibok:=false;
 Showmessage(Format(rsErrorOpening, [Fplugin]));
end;
end;

function TTelescope.ScopeConnect : boolean;
begin
try
FScopeConnect(result);
except
 result:=false;
end;
end;

function TTelescope.ScopeDisconnect : boolean;
begin
try
FScopeDisconnect(result);
except
 result:=false;
end;
end;

procedure TTelescope.ScopeAlign(source : string; ra,dec : double);
begin
FScopeAlign(source,ra,dec);
end;

function TTelescope.ScopeShowModal : boolean;
begin
FScopeShowModal(result);
end;

procedure TTelescope.ScopeShow;
begin
FScopeShow;
end;

procedure TTelescope.ScopeClose;
begin
FScopeClose;
end;

procedure TTelescope.ScopeGetEqSys(var EqSys : double);
begin
try
if FScopeGetEqSys<>nil then FScopeGetEqSys(EqSys)
   else EqSys:=0;
except
  EqSys:=0;
end;
end;

procedure TTelescope.ScopeGetRaDec(var ar,de : double; var ok : boolean);
begin
try
FScopeGetRaDec(ar,de,ok);
except
 ok:=false;
end;
end;

procedure TTelescope.ScopeGetAltAz(var alt,az : double; var ok : boolean);
begin
try
FScopeGetAltAz(alt,az,ok);
except
 ok:=false;
end;
end;

procedure TTelescope.ScopeGetName(var scopename : shortstring);
begin
FScopeGetName(scopename);
end;

procedure TTelescope.ScopeReset;
begin
FScopeReset;
end;

function  TTelescope.ScopeConnected : boolean;
begin
result:=FScopeConnected();
end;

function  TTelescope.ScopeInitialized : boolean;
begin
result:=FScopeInitialized();
end;

procedure TTelescope.ScopeGetInfo(var scopename : shortstring; var QueryOK,SyncOK,GotoOK : boolean; var refreshrate : integer);
begin
FScopeGetInfo(scopename,QueryOK,SyncOK,GotoOK,refreshrate);
end;

procedure TTelescope.ScopeSetObs(latitude,longitude : double);
begin
FScopeSetObs(latitude,longitude);
end;

procedure TTelescope.ScopeGoto(ar,de : double; var ok : boolean);
begin
FScopeGoto(ar,de,ok);
end;

end.
