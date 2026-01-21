unit cu_mount;

{$mode objfpc}{$H+}

{
Copyright (C) 2015 Patrick Chevalley

http://www.ap-i.net
pch@ap-i.net

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>. 

}

{$define AppSkychart}
//{$define AppCcdciel}



interface

uses
  {$ifdef AppSkychart}
  u_constant, u_util, u_projection,
  {$endif}
  {$ifdef AppCcdciel}
  u_global, u_utils, cu_dome, fu_safety,
  {$endif}
  indiapi, u_translation,
  Classes, SysUtils;

type

T_mount = class(TComponent)
  protected
    {$ifdef AppCcdciel}
    FDome: T_dome;
    Fsafety: Tf_safety;
    {$endif}
    FMountInterface: TDevInterface;
    FonMsg,FonDeviceMsg: TNotifyMsg;
    FonCoordChange: TNotifyEvent;
    FonPiersideChange: TNotifyEvent;
    FonParkChange: TNotifyEvent;
    FonTrackingChange: TNotifyEvent;
    FonStatusChange: TNotifyEvent;
    FStatus: TDeviceStatus;
    Fdevice, Fcapability: string;
    FMountSlewing: boolean;
    FTimeOut: integer;
    FAutoLoadConfig: boolean;
    FIsEqmod, FIsGem: boolean;
    FEquinox,FEquinoxJD: double;
    FSlaveDome: boolean;
    FDomeActionWait: integer;
    FCanPulseGuide, FCanMoveAxis,FUseSetPierSide: boolean;
    procedure msg(txt: string; level:integer=3);
    function  GetEquinoxCache: double;
    function  GetEquinoxJD: double;
    function  GetTracking:Boolean; virtual; abstract;
    function  GetPark:Boolean; virtual; abstract;
    function  getCanSetGuideRates:Boolean; virtual; abstract;
    procedure SetPark(value:Boolean); virtual; abstract;
    procedure SetParkInterface(value:Boolean);
    function  GetRA:double; virtual; abstract;
    function  GetDec:double; virtual; abstract;
    function  GetEquinox: double; virtual; abstract;
    function  GetAperture:double; virtual; abstract;
    function  GetFocaleLength:double; virtual; abstract;
    procedure SetTimeout(num:integer); virtual; abstract;
    function  GetSyncMode:TEqmodAlign; virtual; abstract;
    procedure SetSyncMode(value:TEqmodAlign); virtual; abstract;
    function GetMountSlewing:boolean; virtual; abstract;
    function GetPierSide: TPierSide; virtual; abstract;
    procedure SetPierSide(value: TPierSide); virtual; abstract;
    function GetGuideRateRa: double; virtual; abstract;
    function GetGuideRateDe: double; virtual; abstract;
    function GetPulseGuiding: boolean; virtual; abstract;
    procedure SetGuideRateRa(value:double); virtual; abstract;
    procedure SetGuideRateDe(value:double); virtual; abstract;
    function GetAlignmentMode: TAlignmentMode; virtual; abstract;
    function GetCanSetPierSide: boolean; virtual; abstract;
    function GetSlewRates: TstringList; virtual; abstract;
    function GetTrackRate: TTrackRate; virtual; abstract;
    procedure SetTrackRate(value: TTrackRate); virtual; abstract;
    function GetMountRefraction: TMountRefraction; virtual; abstract;
 public
   {$ifdef AppCcdciel}
    DomeOpenActions: TDomeOpenActions;
    DomeCloseActions: TDomeCloseActions;
    {$endif}
    constructor Create(AOwner: TComponent);override;
    destructor  Destroy; override;
    procedure SlewToSkyFlatPosition;
    procedure SlewToDomeFlatPosition;
    Procedure Connect(cp1: string; cp2:string=''; cp3:string=''; cp4:string=''; cp5:string=''; cp6:string=''); virtual; abstract;
    Procedure Disconnect; virtual; abstract;
    function Slew(sra,sde: double):boolean; virtual; abstract;
    function SlewAsync(sra,sde: double):boolean; virtual; abstract;
    function Sync(sra,sde: double):boolean; virtual; abstract;
    function Track:boolean; virtual; abstract;
    procedure AbortMotion; virtual; abstract;
    procedure AbortSlew; virtual; abstract;
    function FlipMeridian(belowthepole:boolean):boolean; virtual; abstract;
    function GetSite(var long,lat,elev: double): boolean; virtual; abstract;
    function SetSite(long,lat,elev: double): boolean; virtual; abstract;
    function GetDate(var utc,offset: double): boolean; virtual; abstract;
    function SetDate(utc,offset: double): boolean; virtual; abstract;
    function PulseGuide(direction,duration:integer): boolean; virtual; abstract;
    procedure MoveAxis(axis: integer; rate: string); virtual; abstract;
    // Eqmod specific
    function ClearAlignment:boolean; virtual; abstract;
    function ClearDelta:boolean; virtual; abstract;
    property IsEqmod: boolean read FIsEqmod;
    property isGem: boolean read FIsGem;
    property SyncMode:TEqmodAlign read GetSyncMode write SetSyncMode;
    // Eqmod specific
    property DeviceName: string read FDevice;
    property MountInterface: TDevInterface read FMountInterface;
    property Status: TDeviceStatus read FStatus;
    property Tracking: Boolean read GetTracking;
    property TrackRate: TTrackRate read GetTrackRate write SetTrackRate;
    property Park: Boolean read GetPark write SetParkInterface;
    property CanSetGuideRates: Boolean read GetCanSetGuideRates;
    property MountSlewing: boolean read GetMountSlewing;
    property RA: double read GetRA;
    property Dec: double read GetDec;
    property Capability: string read Fcapability;
    property PierSide: TPierSide read GetPierSide write SetPierSide;
    property CanSetPierSide: boolean read GetCanSetPierSide;
    property UseSetPierSide: boolean read FUseSetPierSide write FUseSetPierSide;
    property Equinox: double read GetEquinoxCache;
    property EquinoxJD: double read GetEquinoxJD;
    property Aperture: double read GetAperture;
    property FocaleLength: double read GetFocaleLength;
    property AlignmentMode: TAlignmentMode read GetAlignmentMode;
    property GuideRateRa: double read GetGuideRateRa write SetGuideRateRa;
    property GuideRateDe: double read GetGuideRateDe write SetGuideRateDe;
    property CanPulseGuide: boolean read FCanPulseGuide;
    property PulseGuiding: boolean read GetPulseGuiding;
    property Timeout: integer read FTimeout write SetTimeout;
    property CanMoveAxis: boolean read FCanMoveAxis;
    Property SlewRates: TstringList read GetSlewRates;
    property AutoLoadConfig: boolean read FAutoLoadConfig write FAutoLoadConfig;
    property MountRefraction: TMountRefraction read GetMountRefraction;
    {$ifdef AppCcdciel}
    property Safety: Tf_safety read Fsafety write Fsafety;
    property Dome: T_dome read FDome write FDome;
    property SlaveDome: boolean read FSlaveDome write FSlaveDome;
    property DomeActionWait: integer read FDomeActionWait write FDomeActionWait;
    {$endif}
    property onMsg: TNotifyMsg read FonMsg write FonMsg;
    property onDeviceMsg: TNotifyMsg read FonDeviceMsg write FonDeviceMsg;
    property onCoordChange: TNotifyEvent read FonCoordChange write FonCoordChange;
    property onPiersideChange: TNotifyEvent read FonPiersideChange write FonPiersideChange;
    property onParkChange: TNotifyEvent read FonParkChange write FonParkChange;
    property onTrackingChange: TNotifyEvent read FonTrackingChange write FonTrackingChange;
    property onStatusChange: TNotifyEvent read FonStatusChange write FonStatusChange;
end;

const
   SlewDelay=180000; // 3 minutes

implementation

constructor T_mount.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  {$ifdef AppCcdciel}
  Fsafety:=nil;
  {$endif}
  FIsEqmod:=false;
  FMountSlewing:=false;
  FStatus := devDisconnected;
  FTimeOut:=100;
  FEquinox:=NullCoord;
  FEquinoxJD:=NullCoord;
  FSlaveDome:=false;
  FDomeActionWait:=1;
  FCanPulseGuide:=false;
  FCanMoveAxis:=false;
  FUseSetPierSide:=true;
  Fcapability:='';
end;

destructor  T_mount.Destroy;
begin
  inherited Destroy;
end;

procedure T_mount.msg(txt: string; level:integer=3);
begin
 if Assigned(FonMsg) then FonMsg(Fdevice+': '+txt,level);
end;

function T_mount.GetEquinoxCache: double;
begin
 if FEquinox=NullCoord then begin
    FEquinox:=GetEquinox;
 end;
 result:=FEquinox;
end;

function T_mount.GetEquinoxJD: double;
begin
 if FEquinoxJD=NullCoord then begin
   if Equinox=0 then
    FEquinoxJD:=jdtoday
   else
    FEquinoxJD:=Jd(trunc(Equinox),1,1,12);
 end;
 result:=FEquinoxJD;
end;

procedure T_mount.SlewToSkyFlatPosition;
var zra,zde: double;
begin
  {$ifdef AppCcdciel}
    // every 5 minutes maintain position near the zenith, add some randomness and stop tracking
   if now-FlatSlewTime>(5/minperday) then begin
     FlatSlewTime:=now;
     zra:=0; zde:=0;
     cmdHz2Eq(0,90,zra,zde);
     zra:=zra+(Random-0.5)/15;     // move +/- 0.5 degree
     zde:=zde+(Random-0.5);
     if FlatWaitDusk then
        zra:=rmod(zra+1,24)        // dusk, 1 hour east of zenith
     else
        zra:=rmod(zra-1+24,24);    // dawn, 1 hour west of zenith
     // slew
     Slew(zra,zde);
     // stop tracking to blur the stars
     AbortMotion;
   end;
  {$endif}
end;

procedure T_mount.SlewToDomeFlatPosition;
var zra,zde: double;
begin
 {$ifdef AppCcdciel}
 case DomeFlatPosition of
   DomeFlatPositionAltAz: begin
           zra:=0; zde:=0;
           // actual equatorial position of flat panel
           cmdHz2Eq(DomeFlatTelescopeAz,DomeFlatTelescopeAlt,zra,zde);
           // slew
           Slew(zra,zde);
           // stop tracking
           AbortMotion;
         end;
   DomeFlatPositionPark: begin
           SetParkInterface(True);
         end;
   DomeFlatPositionHome: begin
           { #todo : set mount home }
         end;
 end;
 {$endif}
end;

procedure T_mount.SetParkInterface(value:Boolean);
var i: integer;
begin
  {$ifdef AppCcdciel}
  if FSlaveDome then begin
   if FDomeActionWait<1 then FDomeActionWait:=1;
   if (FDome<>nil) and (FDome.Status=devConnected) then begin
    // Process Dome park options
    if value then begin
      // park requested
      msg(rsParkTheTeles3, 1);
      for i:=0 to DomeCloseActionNum-1 do begin
        case DomeCloseActions[i] of
          dclNothing        : continue;
          dclStopTelescope  : begin
                              AbortMotion;
                              wait(FDomeActionWait);
                              if GetTracking or GetMountSlewing then begin
                                msg(Format(rsTelescopeNot, [rsStop]), 0);
                                msg(Format(rsAbortMount, [blank+rsPark]), 0);
                                exit;
                              end;
                              end;
          dclParkTelescope  : begin
                              SetPark(true);
                              wait(FDomeActionWait);
                              if not GetPark then begin
                                msg(Format(rsTelescopeNot, [rsParked]), 0);
                                msg(Format(rsAbortMount, [blank+rsPark]), 0);
                                exit;
                              end;
                              end;
          dclStopDomeSlaving: begin
                              dome.Slave:=false;
                              wait(FDomeActionWait);
                              if dome.Slave then begin
                                msg(Format(rsDomeNotAfter, [rsUnslaved]), 0);
                                msg(Format(rsAbortMount, [blank+rsPark]), 0);
                                exit;
                              end;
                              end;
          dclParkDome       : if dome.Park then
                                 msg(Format(rsDomeAlready, [rsParked]))
                              else begin
                                dome.Park:=true;
                                wait(FDomeActionWait);
                                if not dome.Park then begin
                                  msg(Format(rsDomeNotAfter, [rsParked]), 0);
                                  msg(Format(rsAbortMount, [blank+rsPark]), 0);
                                  exit;
                                end;
                              end;
          dclCloseDome      : if not dome.Shutter then
                                msg(Format(rsDomeAlready, [rsClose]))
                              else begin
                                dome.Shutter:=false;
                                wait(FDomeActionWait);
                                if dome.Shutter then begin
                                  msg(Format(rsDomeNotAfter, [rsClose]), 0);
                                  msg(Format(rsAbortMount, [blank+rsPark]), 0);
                                  exit;
                                end;
                              end;
        end;
      end;
      msg(rsTelescopeAnd, 1);
    end
    else begin
      // unpark requested
      // check weather
      if (not DomeNoSafetyCheck) and (Fsafety<>nil) and Fsafety.Connected and (not Fsafety.Safe) then begin
         msg(rsUnsafeCondit,0);
         msg('Abort mount unpark',0);
         exit;
      end;
      msg(rsUnparkTheTel2, 1);
      for i:=0 to DomeOpenActionNum-1 do begin
        case DomeOpenActions[i] of
          dopNothing         : continue;
          dopOpenDome        : if dome.Shutter then
                                 msg(Format(rsDomeAlready, [rsOpen]))
                               else begin
                                 dome.Shutter:=true;
                                 wait(FDomeActionWait);
                                 if not dome.Shutter then begin
                                   msg(Format(rsDomeNotAfter, [rsOpen]), 0);
                                   msg(Format(rsAbortMount, [blank+rsUnpark]), 0);
                                   exit;
                                 end;
                               end;
          dopUnparkdome      : if not dome.Park then
                                 msg(Format(rsDomeAlready, [rsUnparked]))
                               else begin
                                 dome.Park:=false;
                                 wait(FDomeActionWait);
                                 if dome.Park then begin
                                   msg(Format(rsDomeNotAfter, [rsUnparked]), 0);
                                   msg(Format(rsAbortMount, [blank+rsUnpark]), 0);
                                   exit;
                                 end;
                               end;
          dopUnparkTelescope : begin
                               SetPark(false);
                               wait(FDomeActionWait);
                               if GetPark then begin
                                 msg(Format(rsTelescopeNot, [rsUnparked]), 0);
                                 msg(Format(rsAbortMount, [blank+rsUnpark]), 0);
                                 exit;
                               end;
                               end;
          dopStartTelescope  : begin
                               Track;
                               wait(FDomeActionWait);
                               if not GetTracking then begin
                                 msg(Format(rsTelescopeNot, [rsTracking]), 0);
                                 msg(Format(rsAbortMount, [blank+rsUnpark]), 0);
                                 exit;
                               end;
                               end;
          dopStartdomeSlaving: begin
                               dome.Slave:=true;
                               wait(FDomeActionWait);
                               if not dome.Slave then begin
                                 msg(Format(rsDomeNotAfter, [rsSlaved]), 0);
                                 msg(Format(rsAbortMount, [blank+rsUnpark]), 0);
                                 exit;
                               end;
                               end;
        end;
      end;
      msg(rsTelescopeAnd2, 1);
    end;
   end
   else begin
     msg(format(rsNotConnected,[rsDome]),0);
     msg(Format(rsAbortMount, [blank+rsPark+'/'+rsUnpark]), 0);
   end;
  end
  else
  {$endif}
    // Process only mount
    SetPark(value);
end;

end.

