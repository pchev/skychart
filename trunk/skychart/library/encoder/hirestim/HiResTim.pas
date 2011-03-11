unit HiResTim;

interface

uses
  Windows, MMSystem, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs;

type

  THiResTimer = class;
  EHiResTimer = class( Exception );

  TTimerThread = class( TThread )
  private
  protected
  public
   hr: THiResTimer;
   OnCall:Boolean;
   procedure Execute; override;
  end;

  THiResTimer = class( TComponent )
  private
     nID: UINT;
     FEnabled: boolean;
     FInterval: UINT;
     FResolution: UINT;
     FOnTimer: TNotifyEvent;
     hTimerEvent: THandle;
     bPaused: boolean;
     timerThread: TTimerThread;
     procedure CreateTimer;

  protected
     procedure SetEnabled( b: boolean );
  public
     constructor Create( AOwner: TComponent ); override;
     destructor Destroy; override;
     procedure Pause;
     procedure Resume;
  published
     property Enabled: boolean read FEnabled write SetEnabled default FALSE;
     property Interval: UINT read FInterval write FInterval default 100;
     property Resolution: UINT read FResolution write FResolution default 100;
     property OnTimer: TNotifyEvent read FOnTimer write FOnTimer;
  end;

procedure Register;

implementation

procedure TimerCallback( uTimerID, uMessage: UINT; dwUser, dw1, dw2: DWORD ); stdcall;
var hr:THiResTimer;
begin
 hr:=THiResTimer(dwUser);
 if hr<>nil then
  if not hr.bPaused then
   SetEvent(hr.hTimerEvent);
end;

procedure TTimerThread.Execute;
begin
 while not Terminated and (hr<>nil) and Hr.FEnabled do
 begin
  WaitForSingleObject(hr.hTimerEvent,INFINITE);
  if Assigned(hr.FOnTimer) then
  begin
   OnCall:=True;
   hr.FOnTimer(hr);
   OnCall:=False;
  end;
 end;
end;

constructor THiResTimer.Create( AOwner: TComponent );
begin
 inherited Create(AOwner);
 FEnabled:=FALSE;
 FInterval:=100;
 FResolution:=100;
 bPaused:=FALSE;
 hTimerEvent:=CreateEvent(nil,FALSE,FALSE,nil);
end;

destructor THiResTimer.Destroy;
begin
 Enabled:=FALSE;
 CloseHandle(hTimerEvent);
 inherited Destroy;
end;

procedure THiResTimer.SetEnabled( b: boolean );
begin
 if b and ( csDesigning in ComponentState ) then
 begin
  ShowMessage('Met a vrai l''evenement timer uniquement à l''exécution');
  Exit;
 end;

 if b<>FEnabled then
 begin

  if b then
  begin
   if not (csDesigning in ComponentState) then
   begin
    timerThread:=TTimerThread.Create(TRUE);
    FEnabled:=True;     
    timerThread.OnCall:=False;
    timerThread.hr:=self;
    timerThread.FreeOnTerminate:=TRUE;
    timerThread.Resume;
    CreateTimer;
   end;
  end
  else
  begin
   if not (csDesigning in ComponentState) then
   begin
    timeKillEvent(nID);
    if not timerThread.OnCall then
    begin
     TerminateThread(timerThread.Handle,0);
     timerThread.Free;
    end;
    FEnabled:=False;
   end;
  end;
 end;
end;

procedure THiResTimer.CreateTimer;
var
  lpTimerProc: TFNTimeCallBack;
begin
 lpTimerProc := @TimerCallback;
 nID := timeSetEvent( FInterval, FResolution, lpTimerProc, DWORD( self ), TIME_PERIODIC );
 if nID = 0 then
 begin
  FEnabled := FALSE;
  raise EHiResTimer.Create('Unable to create a timer');
 end;
end;

procedure THiResTimer.Pause;
begin
  if Enabled then
     timerThread.Suspend;
end;

procedure THiResTimer.Resume;
begin
  if Enabled then
     timerThread.Resume;
end;

procedure Register;
begin
  RegisterComponents( 'CDC', [THiResTimer] );
end;

end.
