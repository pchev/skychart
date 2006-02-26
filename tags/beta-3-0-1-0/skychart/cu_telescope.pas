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
  u_util, Types,Classes,Dialogs;

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

  TTelescope = class(TComponent)
  private
    { Private declarations }
    Fscopelib : Dword;
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
    FScopeClose := TScopeClose(GetProcAddress(Fscopelib, 'ScopeClose'));
    FScopeConnect := TScopeConnect(GetProcAddress(Fscopelib, 'ScopeConnect'));
    FScopeDisconnect := TScopeDisconnect(GetProcAddress(Fscopelib, 'ScopeDisconnect'));
    FScopeAlign := TScopeAlign(GetProcAddress(Fscopelib, 'ScopeAlign'));
    FScopeShowModal := TScopeShowModal(GetProcAddress(Fscopelib, 'ScopeShowModal'));
    FScopeShow := TScopeShow(GetProcAddress(Fscopelib, 'ScopeShow'));
    FScopeGetRaDec := TScopeGetRaDec(GetProcAddress(Fscopelib, 'ScopeGetRaDec'));
    FScopeGetAltAz := TScopeGetAltAz(GetProcAddress(Fscopelib, 'ScopeGetAltAz'));
    FScopeGetName := TScopeGetName(GetProcAddress(Fscopelib, 'ScopeGetName'));
    FScopeReset := TScopeReset(GetProcAddress(Fscopelib, 'ScopeReset'));
    FScopeConnected := TScopeConnected(GetProcAddress(Fscopelib, 'ScopeConnected'));
    FScopeInitialized := TScopeInitialized(GetProcAddress(Fscopelib, 'ScopeInitialized'));
    FScopeGetInfo := TScopeGetInfo(GetProcAddress(Fscopelib, 'ScopeGetInfo'));
    FScopeSetObs := TScopeSetObs(GetProcAddress(Fscopelib, 'ScopeSetObs'));
    FScopeGoto := TScopeGoto(GetProcAddress(Fscopelib, 'ScopeGoto'));
    Fscopelibok:=true;
   {$ifdef win32}
    CoInitialize(nil);
   {$endif}
end else begin
    Fscopelibok:=false;
    Showmessage('Error opening '+Fplugin);
end;
except
 Fscopelibok:=false;
 Showmessage('Error opening '+Fplugin);
end;
end;

function TTelescope.ScopeConnect : boolean;
begin
FScopeConnect(result);
end;

function TTelescope.ScopeDisconnect : boolean;
begin
FScopeDisconnect(result);
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

procedure TTelescope.ScopeGetRaDec(var ar,de : double; var ok : boolean);
begin
FScopeGetRaDec(ar,de,ok);
end;

procedure TTelescope.ScopeGetAltAz(var alt,az : double; var ok : boolean);
begin
FScopeGetAltAz(alt,az,ok);
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
