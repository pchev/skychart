unit encoder1;

{****************************************************************
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
****************************************************************}

{------------- interface for ouranos like system. ----------------------------

PJ Pallez Nov 1999
Patrick Chevalley Aug 2000

will work with all systems using same protocol
(Ouranos, NGC MAX,MicroGuider,..)

-------------------------------------------------------------------------------}

interface

uses
  Windows,  Messages, SysUtils, Classes, Graphics, Controls,
Forms, Dialogs, ShellAPI,
  StdCtrls, Buttons, inifiles, ComCtrls, Menus, ExtCtrls, HiResTim,
  EnhEdits;

type
  Tpop_scope = class(TForm)
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    Panel1: TPanel;
    LabelAlpha: TLabel;
    LabelDelta: TLabel;
    pos_x: TEdit;
    pos_y: TEdit;
    GroupBox1: TGroupBox;
    SpeedButton4: TSpeedButton;
    Label1: TLabel;
    list_init: TListView;
    TabSheet2: TTabSheet;
    GroupBox2: TGroupBox;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label6: TLabel;
    cbo_type: TComboBox;
    led: TEdit;
    res_x: TEdit;
    res_y: TEdit;
    GroupBox3: TGroupBox;
    led1: TEdit;
    SpeedButton1: TSpeedButton;
    SaveButton1: TButton;
    az_x: TEdit;
    alt_y: TEdit;
    Label11: TLabel;
    Label12: TLabel;
    TabSheet3: TTabSheet;
    GroupBox4: TGroupBox;
    Label5: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    PortSpeedbox: TComboBox;
    cbo_port: TComboBox;
    Paritybox: TComboBox;
    DatabitBox: TComboBox;
    StopbitBox: TComboBox;
    Label13: TLabel;
    TimeOutBox: TComboBox;
    Mounttype: TRadioGroup;
    Button2: TButton;
    ReadIntBox: TComboBox;
    Label14: TLabel;
    GroupBox5: TGroupBox;
    Label15: TLabel;
    Label16: TLabel;
    lat: TEdit;
    long: TEdit;
    Panel2: TPanel;
    Label17: TLabel;
    SpeedButton2: TSpeedButton;
    SpeedButton5: TSpeedButton;
    PopupMenu1: TPopupMenu;
    Delete1: TMenuItem;
    Timer1: THiResTimer;
    GroupBox6: TGroupBox;
    cbo_source: TComboBox;
    cbo_starname: TComboBox;
    SpeedButton3: TSpeedButton;
    Panel3: TPanel;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Label18: TLabel;
    Label19: TLabel;
    Label20: TLabel;
    IntTimeOutBox: TComboBox;
    Label21: TLabel;
    StatusBar1: TStatusBar;
    GroupBox7: TGroupBox;
    Label22: TLabel;
    Label23: TLabel;
    Label24: TLabel;
    Z1T: TFloatEdit;
    Z2T: TFloatEdit;
    Z3T: TFloatEdit;
    init90: TSpeedButton;
    status: TSpeedButton;
    InitType: TRadioGroup;
    CheckBox3: TCheckBox;
    SpeedButton6: TSpeedButton;
    CheckBox4: TCheckBox;
    {Ouranos compatible IO}
    procedure INITClick(Sender: TObject);
    procedure query_encoder;
    {Utility and form functions}
    procedure formcreate(Sender: TObject);
    procedure kill(Sender: TObject; var CanClose: Boolean);
    procedure Timer1Timer(Sender: TObject);
    procedure setresClick(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    function str2ra(s:string):double;
    function str2dec(s:string):double;
    procedure Encoder_Error;
    procedure statusClick(Sender: TObject);
    procedure SpeedButton4Click(Sender: TObject);
    procedure cbo_sourceChange(Sender: TObject);
    procedure SaveButton1Click(Sender: TObject);
    procedure ReadIntBoxChange(Sender: TObject);
    procedure latChange(Sender: TObject);
    procedure longChange(Sender: TObject);
    procedure MounttypeClick(Sender: TObject);
    procedure SpeedButton5Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure list_initMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Delete1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure CheckBox1Click(Sender: TObject);
    procedure init90Click(Sender: TObject);
    procedure InitTypeClick(Sender: TObject);
    procedure CheckBox3Click(Sender: TObject);
    procedure SpeedButton6Click(Sender: TObject);
    procedure CheckBox4Click(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }
  end;

{ Cartes du Ciel Dll export }
Procedure ScopeShow; stdcall;
Procedure ScopeShowModal(var ok : boolean); stdcall;
Procedure ScopeConnect(var ok : boolean); stdcall;
Procedure ScopeDisconnect(var ok : boolean); stdcall;
Procedure ScopeGetInfo(var Name : shortstring; var QueryOK,SyncOK,GotoOK : boolean ; var refreshrate : integer); stdcall;
Procedure ScopeSetObs(la,lo : double); stdcall;
Procedure ScopeAlign(source : string; ra,dec : double); stdcall;
Procedure ScopeGetRaDec(var ar,de : double; var ok : boolean); stdcall;
Procedure ScopeGetAltAz(var alt,az : double; var ok : boolean); stdcall;
Procedure ScopeGoto(ar,de : double; var ok : boolean); stdcall;
Procedure ScopeReset; stdcall;
Function  ScopeInitialized : boolean ; stdcall;
Function  ScopeConnected : boolean ; stdcall;
Procedure ScopeClose; stdcall;

{ internal function }
Procedure InitObject(source : string; alpha,delta:double);
Procedure SetRes;
Procedure Clear_Init_List;
Procedure AffMsg(msgtxt : string);

var
  pop_scope: Tpop_scope;

implementation

{$R *.DFM}
 uses
    encoder_lib,
    skylib2,
    serial,
    Taki,
    u_types;

var X_List, Y_List, Istatus : integer;
    theta0, phi0 : double;
    g_ok : boolean;
    wait_create : boolean = true;
    first_show : boolean = true;
    Init90Y : integer = 999999;

const crlf=chr(10)+chr(13);


procedure InitLib;
var ini:tinifile;
    buf : string;
    av : boolean;
begin
     buf:=extractfilepath(paramstr(0));
     ini:=tinifile.create(buf+'scope.ini');
     av:=ini.ReadBool('encoders','AlwaysVisible',true);
     ini.free;
     if av then pop_scope.FormStyle:=fsStayOnTop
           else pop_scope.FormStyle:=fsNormal;
end;

{-------------------------------------------------------------------------------

                       Cartes du Ciel Dll functions

--------------------------------------------------------------------------------}

Procedure ScopeConnect(var ok : boolean); stdcall;
begin
SetRes;
ok:=(pop_scope.led.color=clLime);
end;

Procedure ScopeDisconnect(var ok : boolean); stdcall;
begin
pop_scope.timer1.enabled:=false;
ok:=Encoder_Close;
if ok then begin
   pop_scope.led.color:=clRed;
   pop_scope.led1.color:=clRed;
end;
Clear_Init_List;
pop_scope.pos_x.text:='';
pop_scope.pos_y.text:='';
pop_scope.az_x.text:='';
pop_scope.alt_y.text:='';
Alpha_Inversion:=false;
Delta_Inversion:=false;
Init90Y := 999999;
pop_scope.init90.font.color:=clWindowText;
end;

Procedure ScopeClose; stdcall;
begin
pop_scope.release;
end;

Function  ScopeConnected : boolean ; stdcall;
begin
while wait_create do Application.processmessages;
if pop_scope<>nil then result:=(pop_scope.led.color=clLime)
                  else result:=false;
end;

Function  ScopeInitialized : boolean ; stdcall;
begin
while wait_create do Application.processmessages;
if pop_scope<>nil then result:= (init_objects.count>=2)
                  else result:=false;
end;

Procedure ScopeAlign(source : string; ra,dec : double); stdcall;
begin
InitObject(copy(source,1,9),15*ra,dec);
end;

Procedure ScopeShowModal(var ok : boolean); stdcall;
begin
if pop_scope<>nil then begin
pop_scope.showmodal;
ok:=(pop_scope.modalresult=mrOK);
end
else ok:=false;
end;

Procedure ScopeShow; stdcall;
begin
while wait_create do Application.processmessages;
if pop_scope<>nil then pop_scope.show;
end;

Procedure ScopeGetRaDec(var ar,de : double; var ok : boolean); stdcall;
begin
if (init_objects.Count>=2) then begin
   ar:=curdeg_x/15;
   de:=curdeg_y;
   ok:=true;
end else begin
   ar:=0;
   de:=0;
   ok:=false;
end;
end;

Procedure ScopeGetAltAz(var alt,az : double; var ok : boolean); stdcall;
begin
if (init_objects.Count>=2) then begin
   alt:=cur_alt;
   az:=cur_az;
   ok:=true;
end else begin
   alt:=0;
   az:=0;
   ok:=false;
end;
end;

Procedure ScopeGetInfo(var Name : shortstring; var QueryOK,SyncOK,GotoOK : boolean ; var refreshrate : integer); stdcall;
begin
if (pop_scope=nil)or(pop_scope.pos_x=nil) then begin
   decimalseparator:='.';
   wait_create:=true;
   First_Show:=true;
   pop_scope:=Tpop_scope.Create(nil);
   Initlib;
end;
while wait_create do Application.processmessages;
if pop_scope<>nil then begin
name:=pop_scope.cbo_type.text;
QueryOK:=true;
SyncOK:=true;
GotoOK:=false;
refreshrate:=pop_scope.Timer1.Interval;
end;
end;

Procedure ScopeReset; stdcall;
begin
Clear_Init_List;
end;

Procedure ScopeSetObs(la,lo : double); stdcall;
begin
if pop_scope<>nil then begin
pop_scope.lat.text:=floattostr(la);
pop_scope.long.text:=floattostr(lo);
latitude:=la;
ObsLatitude:=la;
longitude:=lo;
ObsLongitude:=lo;
end;
end;

Procedure ScopeGoto(ar,de : double; var ok : boolean); stdcall;
begin
ok:=false;
end;

{-------------------------------------------------------------------------------

                                  Coordinates functions

--------------------------------------------------------------------------------}

Procedure GetSideralTime;
var jd0,ut : double;
    st : TSystemTime;
begin
GetSystemTime(st);
jd0:=jd(st.wYear,st.wMonth,st.wDay,0.0);
ut:=st.wHour+st.wMinute/60+st.wSecond/3600;
Sideral_Time:=15*SidTim(jd0,ut,Longitude); // in degree
end;

Procedure ComputeCoord(p1,p2 : PInit_object; x,y : integer; var alpha,delta : double);
var theta,phi,tim,tim0,tim1,tim2 : double;
begin
if p2.time>p1.time then begin
   tim0:=p1.time;
   tim1:=0;
   tim2:=(p2.time-p1.time)*1440;
end else begin
   tim0:=p2.time;
   tim1:=(p1.time-p2.time)*1440;
   tim2:=0;
end;

Taki.Reset(pop_scope.Z1T.value,pop_scope.Z2T.value,pop_scope.Z3T.value);
if Delta_Inversion then theta:=theta0-p1.theta
                   else theta:=p1.theta-theta0;
if Alpha_Inversion then phi:=phi0-p1.phi
                   else phi:=p1.phi-phi0;
Taki.AddStar(p1.alpha,p1.delta,tim1,phi,theta);
if Delta_Inversion then theta:=theta0-p2.theta
                   else theta:=p2.theta-theta0;
if Alpha_Inversion then phi:=phi0-p2.phi
                   else phi:=p2.phi-phi0;
Taki.AddStar(p2.alpha,p2.delta,tim2,phi,theta);

theta:=y*scaling_y+180;
phi:=x*scaling_x+180;
tim:=(now-tim0)*1440;
if Delta_Inversion then theta:=theta0-theta
                   else theta:=theta-theta0;
if Alpha_Inversion then phi:=phi0-phi
                   else phi:=phi-phi0;
Taki.Tel2Equ(phi,theta,tim,alpha,delta);
end;

Procedure GetCoordinates;
var j,n,m,py : integer;
    p1,p2 : PInit_object;
    pos : Tpoint;
    alpha,delta,dista,disti,d : double;
begin
try
with pop_scope do begin
if init_objects.count<2 then begin
   AffMsg('TWO stars must be used for initialisation.');
   exit;
end;
if not Encoder_query(curstep_x,curstep_y) then begin Encoder_Error; exit; end;
{ approx. coordinates using last init. star}
ComputeCoord(Last_p1,Last_p2, curstep_x,curstep_y,alpha,delta);
{ search nearest and farest init star }
n:=init_objects.count-1;
m:=0;
dista:=High(Integer);
disti:=0;
for j := 0 to init_objects.count-1 do begin
  p1:=init_objects[j];
  d:=angulardistance(alpha,delta,p1.alpha,p1.delta);
  if d<dista then begin
     n:=j;
     dista:=d;
  end;
  if d>disti then begin
     m:=j;
     disti:=d;
  end;
  list_init.Items.Item[j].SubItems.Strings[3]:='   ';
end;
{p1:=init_objects[n];
case MountType.ItemIndex of
0 : begin
    if Delta_Inversion then theta0:=p1.theta+p1.delta
                       else theta0:=p1.theta-p1.delta;
    if Alpha_Inversion then phi0:=p1.phi+p1.alpha
                       else phi0:=p1.phi-p1.alpha;
    end;
1 : begin
    if Delta_Inversion then theta0:=p1.theta+p1.alt
                       else theta0:=p1.theta-p1.alt;
    if Alpha_Inversion then phi0:=p1.phi+p1.az
                       else phi0:=p1.phi-p1.az;
    end;
end;}
if n>m then begin   // respect time order
   j:=m;
   m:=n;
   n:=j;
end;
{ mark used star in list }
list_init.Items.Item[n].SubItems.Strings[3]:=' * ';
list_init.Items.Item[m].SubItems.Strings[3]:=' * ';
pos:=list_init.Items.Item[n].GetPosition;
py:=pos.y;
pos:=list_init.TopItem.GetPosition;
py:=py-pos.y;
list_init.Scroll(0,py);
{compute instrumental coordinates}
p1:=init_objects[n];
p2:=init_objects[m];
Last_p1:=p1;
Last_p2:=p2;
ComputeCoord(p1, p2, curstep_x, curstep_y, curdeg_x, curdeg_y);
  {convert to alt-az pos}
  GetSideralTime;
  Eq2Hz(sideral_time-curdeg_x,curdeg_y,cur_az,cur_alt);
  cur_az:=rmod(cur_az+180,360);
  { clean RA }
  curdeg_x:=rmod(curdeg_x+720,360);
if debug then writeserialdebug(FormatDateTime('hh:mm:ss.zzz',now)+
             ' Coord : S1:'+inttostr(n)+' S2:'+inttostr(m)+
             ' X:'+inttostr(curstep_x)+' Y:'+inttostr(curstep_y)+' T:'+floattostr(now)+
             ' RA:'+floattostr(curdeg_x)+' DEC:'+floattostr(curdeg_y)+
             ' AZ:'+floattostr(cur_az)+' ALT:'+floattostr(cur_alt) );
end;
except
curdeg_x:=0; curdeg_y:=0;
cur_az:=0; cur_alt:=0;
end;
end;

{-------------------------------------------------------------------------------

                                  Utility functions

--------------------------------------------------------------------------------}

Procedure tpop_scope.Encoder_Error;
begin
inc(num_error);
if num_error>max_error then ScopeDisconnect(g_OK);
end;

function tpop_scope.str2ra(s:string):double;
var
h,m,ss:integer;
begin
     h:=strtoint(copy(s,19,2));
     m:=strtoint(copy(s,22,2));
     ss:=strtoint(copy(s,25,1)); // tenth of minute
     result:=15*((h)+(m/60)+(ss/600));
end;

function tpop_scope.str2dec(s:string):double;
var
sgn,d,m :integer;
begin
     d:=strtoint(copy(s,27,3)); if d < 0 then sgn:=-1 else sgn:= 1;
     m:=strtoint(copy(s,31,2));
     result:=sgn*(abs(d)+(m/60));
end;

Procedure Clear_Init_List;
begin
initialised:=false;
with pop_scope do begin
list_init.items.clear;
init_objects.Clear;
end;
end;

Procedure Load_Init_Objects;
var fn : string;
begin
fn:='';
with pop_scope do begin
if cbo_source.text='Not used' then fn:=''
else if cbo_source.text='Star Name' then fn:='star.txt'
else if cbo_source.text='Messier' then fn:='messier.txt'
else if cbo_source.text='NGC' then fn:='ngc.txt'
else if cbo_source.text='IC' then fn:='ic.txt';
cbo_starname.clear;
if fn>'' then cbo_starname.Items.LoadFromFile(fn);
cbo_starname.Itemindex:=0;
end;
end;

{-------------------------------------------------------------------------------

                                  Form functions

--------------------------------------------------------------------------------}

Procedure AffMsg(msgtxt : string);
begin
if msgtxt<>'' then begin
   Istatus:=10000 div pop_scope.Timer1.Interval;
   Beep;
end;
pop_scope.statusbar1.SimpleText:=msgtxt;
pop_scope.statusbar1.Refresh;
end;

procedure Tpop_scope.formcreate(Sender: TObject);
begin
     GetDir(0,appdir);
     Application.UpdateFormatSettings:=false;
     decimalseparator:='.';
     init_objects:=tlist.create;
     wait_create := false;
end;

Procedure LoadDefault;
var ini:tinifile;
    newcolumn:tlistcolumn;
    buf,nom : string;
begin
with pop_scope do begin
     buf:=extractfilepath(paramstr(0));
     ini:=tinifile.create(buf+'scope.ini');
     res_x.text:=ini.readstring('encoders','res_x','2000');
     res_y.text:=ini.readstring('encoders','res_y','2000');
     nom:= ini.readstring('encoders','name','Ouranos');
     cbo_type.text:=nom;
     ReadIntBox.text:=ini.readstring('encoders','read_interval','1000');
     cbo_port.text:=ini.readstring('encoders','comport','COM1');
     if strtointdef(copy(cbo_port.text,4,1),9)>4 then cbo_port.text:='COM1';
     PortSpeedbox.text:=ini.readstring('encoders','baud','9600');
     DatabitBox.text:=ini.readstring('encoders','databits','8');
     Paritybox.text:=ini.readstring('encoders','parity','N');
     StopbitBox.text:=ini.readstring('encoders','stopbits','1');
     TimeOutBox.text:=ini.readstring('encoders','timeout','1000');
     IntTimeOutBox.text:=ini.readstring('encoders','inttimeout','100');
     lat.text:=ini.readstring('observatory','latitude','0');
     long.text:=ini.readstring('observatory','longitude','0');
     MountType.ItemIndex:=ini.ReadInteger('encoders','mount',0);
     InitType.ItemIndex:=ini.ReadInteger('encoders','initpos',1);
     Z1T.text:=ini.Readstring('encoders','mount_Z1','0');
     Z2T.text:=ini.Readstring('encoders','mount_Z2','0');
     Z3T.text:=ini.Readstring('encoders','mount_Z3','0');
     Checkbox4.checked:=ini.ReadBool('encoders','AlwaysVisible',true);
     ini.free;
     with list_init do
     begin
          newcolumn:=columns.add; newcolumn.caption:='Name';
          newcolumn.width:=-1;
          newcolumn:=columns.add; newcolumn.caption:='Alpha';
          newcolumn.width:=-1;
          newcolumn:=columns.add; newcolumn.caption:='Delta';
          newcolumn.width:=-1;
          newcolumn:=columns.add; newcolumn.caption:='Time';
          newcolumn.width:=-1;
          newcolumn:=columns.add; newcolumn.caption:='Sel';
          newcolumn.width:=-1;
     end;
     Timer1.Interval:=strtointdef(ReadIntBox.text,1000);
     ReadIntBox.text:=inttostr(Timer1.Interval);
end;
First_Show:=false;
end;


procedure Tpop_scope.kill(Sender: TObject; var CanClose: Boolean);
begin
if port_opened then begin
   canclose:=false;
   pop_scope.hide;
end;
end;


procedure Tpop_scope.Timer1Timer(Sender: TObject);
begin
    if port_opened and resolution_sent
       then query_encoder;
end;



procedure Tpop_scope.SpeedButton1Click(Sender: TObject);
begin
     query_encoder;
end;


procedure Tpop_scope.statusClick(Sender: TObject);
{gives the status of the system}
var
s1,s2,s3,s4,s5:string;
a:double;
b:integer;
begin
Affmsg('');
     if port_opened then s1:= ' Connected' else s1:=' Diconnected';
     if resolution_sent then s2:='Resolution X: '+inttostr(reso_x)+' Y :'+inttostr(reso_y)+' steps';
     if alpha_inversion then s4:='Inversion Alpha ,' else s4:='';
     if delta_inversion then s4:=s4+' Inversion Delta' ;
     if init90y=999999 then s5:='Vertical axis 90° initialisation not done'
                       else s5:='Vertical axis encoder origin : '+inttostr(init90y);
     if initialised then
     begin
           a:=last_init_alpha-trunc(last_init_alpha);
           b:=trunc(last_init_alpha/15);
           s3:='Initialised at '+last_init+#13#10+' using : '+#13#10+
           last_init_target+' (RA: '+artostr(b+a)+' DEC:'+detostr(last_init_delta)+')'
     end else begin s3:='Not initialised'; end;
     if checkbox4.checked then pop_scope.formstyle:=fsNormal;
     messagedlg('Sytem status:'+#13#10#13#10+cbo_port.text+s1+
                 #13#10+s2+#13#10+s3+#13#10+s4+#13#10+s5+#13#10,mtinformation,[mbok],0);
     if checkbox4.checked then pop_scope.formstyle:=fsStayOnTop;
end;

Procedure ShowCoordinates;
begin
with pop_scope do begin
   if (init_objects.Count>=2) then begin
      GetCoordinates;
      pos_x.text := armtostr(Curdeg_x/15);
      pos_y.text := demtostr(Curdeg_y);
      az_x.text  := demtostr(Cur_az);
      alt_y.text := demtostr(Cur_alt);
      if Cur_alt<0 then alt_y.Color:=clRed else alt_y.Color:=clWindow;
   end else if MountType.ItemIndex=0 then  begin
      if not Encoder_query(curstep_x,curstep_y) then begin Encoder_Error; exit; end;
      pos_x.text := Inttostr(curstep_x);
      pos_y.text := Inttostr(curstep_y);
      az_x.text  := '';
      alt_y.text := '';
   end else begin
      if not Encoder_query(curstep_x,curstep_y) then begin Encoder_Error; exit; end;
      pos_x.text := '';
      pos_y.text := '';
      az_x.text  := Inttostr(curstep_x);
      alt_y.text := Inttostr(curstep_y);
   end;
end;
end;

procedure Tpop_scope.SpeedButton4Click(Sender: TObject);
begin
Affmsg('');
Clear_Init_List;
Alpha_Inversion:=false;
Delta_Inversion:=false;
end;

procedure Tpop_scope.setresClick(Sender: TObject);
begin
SetRes;
Alpha_Inversion:=false;
Delta_Inversion:=false;
end;

Procedure SetRes;
var i,x,y : integer;
begin
Affmsg('');
{Connect and Sets the Resolution.}
with pop_scope do begin
led.color:=clRed;
led.refresh;
led1.color:=clRed;
led1.refresh;
timer1.enabled:=false;
Clear_Init_List;
Init90Y := 999999;
pop_scope.init90.font.color:=clWindowText;
if debug then begin
   writeserialdebug(FormatDateTime('hh:mm:ss.zzz',now)+
             ' ObsLat:'+floattostr(ObsLatitude)+' ObsLong:'+floattostr(ObsLongitude));
   writeserialdebug(FormatDateTime('hh:mm:ss.zzz',now)+
             ' ResolX:'+res_x.text+' ResolY:'+res_y.text+
             ' Z1:'+z1t.text+' Z2:'+z2t.text+' Z3:'+z3t.text);
end;
try
if Encoder_Open(trim(cbo_type.text),trim(cbo_port.text),PortSpeedbox.text,Paritybox.text,DatabitBox.text,StopbitBox.text,TimeOutBox.text,IntTimeOutBox.text) and Encoder_Query(x,y) then begin
   reso_x:=strtoint(res_x.text);
   reso_y:=strtoint(res_y.text);
   i:=0;
   repeat
     Encoder_Set_Resolution(reso_x,reso_y);
     Encoder_Init(reso_x div 2,reso_y div 2);
     Encoder_Query(x,y);
     inc(i);
     sleep(100);
   until ((x=0)and(y=0))or(i>3);
//   Encoder_Set_Init_Flag;
   {Calculate how much an encoder step means in degrees}
   scaling_x:=360/reso_x;
   scaling_y:=360/reso_y;
   resolution_sent:=true;
   led.color:=clLime;
   led1.color:=clLime;
   timer1.enabled:=true;
end else begin
    Encoder_Close;
    Affmsg('Error opening '+cbo_type.text+' on port '+cbo_port.text);
end;
finally

end;
end;
end;

Procedure InitObject(source : string; alpha,delta:double);
{Add a point to the initialisation list.}
var
p,q:Pinit_object;
listitem:tlistitem;
s1,s2 : integer;
a1,d1 : double;
inittime : Tdatetime;
begin
with pop_scope do begin
     {Check if Resolution has been set}
     if port_opened and resolution_sent then
     begin
         {Check if scope level is set}
         if Init90Y=999999 then begin
              Affmsg('Please init the 90° elevation first');
              exit;
         end;;
         {be sure we have the current steps}
         if not pop_scope.timer1.enabled then
            if not Encoder_query(curstep_x,curstep_y) then begin
               Encoder_Error;
               exit;
            end;
         {be sure first two initialisation are valid}
         if init_objects.Count=1 then begin
            q:=init_objects[0];
            if (abs(q.steps_x-curstep_x)<5)or(abs(q.steps_y-curstep_y)<5) then begin
              Affmsg('Please move the telescope along the two axis');
              exit;
            end;
         end;
         {... store information in global vars and Tlist}
         inittime:=now;
         last_init:=datetimetostr(inittime);
         last_init_target:=source; last_init_alpha:=alpha;
         last_init_delta:=delta;
         new(p);
         with list_init do
         begin
              listitem:=items.add; listitem.caption:=source;
              listitem.subitems.add(copy(armtostr(alpha/15),2,99));
              listitem.subitems.add(demtostr(delta));
              listitem.subitems.add(formatdatetime('hh:nn',inittime));
              listitem.subitems.add('   ');
              {stores the pointer in new column item}
              listitem.Data:=p;
         end;
         { store information }
         p.name:=source; p.alpha:=alpha;
         p.delta:=delta; p.time:=inittime;
         p.steps_x:=curstep_x; p.steps_y:=curstep_y; p.error:=0;
         p.theta:=p.steps_y*scaling_y+180;
         p.phi:=p.steps_x*scaling_x+180;
         GetSideralTime;
         Eq2Hz(sideral_time-p.alpha,p.delta,a1,d1);
         p.az:=360-rmod(a1+180,360);
         p.alt:=d1;

         if debug then writeserialdebug(FormatDateTime('hh:mm:ss.zzz',now)+
                  ' Align : '+inttostr(init_objects.Count)+' '+p.name+' RA:'+floattostr(p.alpha)+' DEC:'+floattostr(p.delta)+' T:'+floattostr(p.time)+
                  ' X: '+inttostr(p.steps_x)+' Y: '+inttostr(p.steps_y)+
                  ' TH:'+floattostr(p.theta)+' PHI:'+floattostr(p.phi)+
                  ' AZ:'+floattostr(p.az)+' ALT:'+floattostr(p.alt) );

         if init_objects.Count=1 then begin    // set axis direction
            q:=init_objects[0];
            // Find any encoder inversion
            case MountType.ItemIndex of
            0 : begin   //  Equatorial mount
                s1:=trunc(sgn(q.alpha-p.alpha));
                s2:=trunc(sgn(q.phi-p.phi));
                if s1=s2 then Alpha_Inversion:=false else Alpha_Inversion:=true;
                if abs(q.phi-p.phi)>180 then Alpha_Inversion:=not Alpha_Inversion;
                if abs(q.alpha-p.alpha)>180 then Alpha_Inversion:=not Alpha_Inversion;
                s1:=trunc(sgn(q.delta-p.delta));
                s2:=trunc(sgn(q.theta-p.theta));
                if s1=s2 then Delta_Inversion:=false else Delta_Inversion:=true;
                if abs(q.theta-p.theta)>180 then Delta_Inversion:=not Delta_Inversion;
                if Delta_Inversion then theta0:=(Init90Y*scaling_y+180)+90*inittype.ItemIndex
                                   else theta0:=(Init90Y*scaling_y+180)-90*inittype.ItemIndex;
                if Alpha_Inversion then phi0:=p.phi+p.alpha
                                   else phi0:=p.phi-p.alpha;
                if debug then begin
                   writeserialdebug(FormatDateTime('hh:mm:ss.zzz',now)+' Equatorial mount'+
                             ' INITPOS:'+inttostr(init90y)+' INIT :'+inttostr(inittype.ItemIndex)+
                             ' TH0:'+floattostr(theta0)+' PHI0:'+floattostr(phi0));
                   if Delta_Inversion then writeserialdebug(FormatDateTime('hh:mm:ss.zzz',now)+' Delta_Inversion : True')
                                      else writeserialdebug(FormatDateTime('hh:mm:ss.zzz',now)+' Delta_Inversion : False');
                   if Alpha_Inversion then writeserialdebug(FormatDateTime('hh:mm:ss.zzz',now)+' Alpha_Inversion : True')
                                      else writeserialdebug(FormatDateTime('hh:mm:ss.zzz',now)+' Alpha_Inversion : False');
                end;
            end;
            1 : begin   // AltAZ mount
                s1:=trunc(sgn(q.az-p.az));
                s2:=trunc(sgn(q.phi-p.phi));
                if s1=s2 then Alpha_Inversion:=false else Alpha_Inversion:=true;
                if abs(q.phi-p.phi)>180 then Alpha_Inversion:=not Alpha_Inversion;
                if abs(q.az-p.az)>180 then Alpha_Inversion:=not Alpha_Inversion;
                s1:=trunc(sgn(q.alt-p.alt));
                s2:=trunc(sgn(q.theta-p.theta));
                if s1=s2 then Delta_Inversion:=false else Delta_Inversion:=true;
                if abs(q.theta-p.theta)>180 then Delta_Inversion:=not Delta_Inversion;
                if Delta_Inversion then theta0:=(Init90Y*scaling_y+180)+90*inittype.ItemIndex
                                   else theta0:=(Init90Y*scaling_y+180)-90*inittype.ItemIndex;
                if Alpha_Inversion then phi0:=p.phi+p.az
                                   else phi0:=p.phi-p.az;
                if debug then begin
                   writeserialdebug(FormatDateTime('hh:mm:ss.zzz',now)+' AltAZ mount'+
                             ' INITPOS:'+inttostr(init90y)+' INIT :'+inttostr(inittype.ItemIndex)+
                             ' TH0:'+floattostr(theta0)+' PHI0:'+floattostr(phi0));
                   if Delta_Inversion then writeserialdebug(FormatDateTime('hh:mm:ss.zzz',now)+' Delta_Inversion : True')
                                      else writeserialdebug(FormatDateTime('hh:mm:ss.zzz',now)+' Delta_Inversion : False');
                   if Alpha_Inversion then writeserialdebug(FormatDateTime('hh:mm:ss.zzz',now)+' Alpha_Inversion : True')
                                      else writeserialdebug(FormatDateTime('hh:mm:ss.zzz',now)+' Alpha_Inversion : False');
                end;
            end;
            end;
         end;
         {store the checked data}
         init_objects.Add(p);
         if init_objects.Count=1 then Last_p1:=p;
         if init_objects.Count=2 then Last_p2:=p;
     end
     else
     begin
          Affmsg('The interface is either not connected or not initialized');
     end;
end;
end;

procedure Tpop_scope.INITClick(Sender: TObject);
var source : string;
    alpha,delta:double;
begin
{First get coordinates of the init point}
if (cbo_source.text='Star Name')or
            (cbo_source.text='Messier')or
            (cbo_source.text='NGC')or
            (cbo_source.text='IC')
         then begin
             alpha :=str2ra(cbo_starname.text);
             delta:=str2dec(cbo_starname.text);
             source:=copy(cbo_starname.text,1,9);
             InitObject(source,alpha,delta);
end;
end;

Procedure QueryStatus;
var ex,ey : integer;
    batteryOK : boolean;
begin
if GetDeviceStatus(ex,ey,batteryOK) then begin
   pop_scope.edit1.text:=inttostr(ex);
   pop_scope.edit2.text:=inttostr(ey);
   if batteryOK then pop_scope.edit3.color:=clLime else pop_scope.edit3.color:=clRed;
   pop_scope.Panel3.refresh;
end;   
end;

procedure tpop_scope.query_encoder;
{Just sends a 'Q' to the encoder interface.}
begin
     if not port_opened or not resolution_sent
then
     begin
          led.color:=clred;
          led1.color:=clred;
          exit;
     end
     else
     begin
         if statusbar1.SimpleText<>'' then begin
            if Istatus<=0 then Affmsg('')
                          else dec(Istatus);
         end;
         ShowCoordinates;
         if CheckBox2.Checked then QueryStatus;
     end;
end;

procedure Tpop_scope.cbo_sourceChange(Sender: TObject);
begin
Load_Init_Objects;
end;

procedure Tpop_scope.SaveButton1Click(Sender: TObject);
var
ini:tinifile;
begin
ini:=tinifile.create(extractfilepath(paramstr(0))+'scope.ini');
ini.writestring('encoders','res_x',res_x.text);
ini.writestring('encoders','res_y',res_y.text);
ini.writestring('encoders','name',cbo_type.text);
ini.writestring('encoders','read_interval',ReadIntBox.text);
ini.writeinteger('encoders','mount',MountType.ItemIndex);
ini.writeinteger('encoders','initpos',InitType.ItemIndex);
ini.writestring('encoders','mount_Z1',Z1T.text);
ini.writestring('encoders','mount_Z2',Z2T.text);
ini.writestring('encoders','mount_Z3',Z3T.text);
ini.writestring('encoders','comport',cbo_port.text);
ini.writestring('encoders','baud',PortSpeedbox.text);
ini.writestring('encoders','databits',DatabitBox.text);
ini.writestring('encoders','parity',Paritybox.text);
ini.writestring('encoders','stopbits',StopbitBox.text);
ini.writestring('encoders','timeout',TimeOutBox.text);
ini.writestring('encoders','inttimeout',IntTimeOutBox.text);
ini.writebool('encoders','AlwaysVisible',checkbox4.checked);
ini.writestring('observatory','latitude',lat.text);
ini.writestring('observatory','longitude',long.text);
ini.free;
end;

procedure Tpop_scope.ReadIntBoxChange(Sender: TObject);
begin
     Timer1.Interval:=strtointdef(ReadIntBox.text,1000);
end;

procedure Tpop_scope.latChange(Sender: TObject);
var x : double;
    i : integer;
begin
val(lat.text,x,i);
if i=0 then latitude:=x;
ObsLatitude:=latitude;
end;

procedure Tpop_scope.longChange(Sender: TObject);
var x : double;
    i : integer;
begin
val(long.text,x,i);
if i=0 then longitude:=x;
ObsLongitude:=longitude;
end;

procedure Tpop_scope.MounttypeClick(Sender: TObject);
begin
Clear_Init_List;
end;

procedure Tpop_scope.SpeedButton5Click(Sender: TObject);
var ok : boolean;
begin
Affmsg('');
ScopeDisconnect(ok);
end;

procedure Tpop_scope.SpeedButton2Click(Sender: TObject);
begin
pop_scope.Hide;
end;

procedure Tpop_scope.list_initMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var ht : THitTests;
begin
if (button=mbRight) then begin
   ht:=list_init.GetHitTestInfoAt(X,Y);
   if ht=[htOnLabel] then begin
   X_List:=X;
   Y_List:=Y;
   popupmenu1.popup(mouse.cursorpos.x,mouse.cursorpos.y);
   end;
end;
end;

procedure Tpop_scope.Delete1Click(Sender: TObject);
var lin : TlistItem;
    i : integer;
begin
lin:=list_init.GetItemAt(X_List, Y_List);
if lin<>nil then begin
   i:=lin.Index;
   init_objects.Delete(i);
   lin.Delete;
end;
end;

procedure Tpop_scope.FormShow(Sender: TObject);
begin
Load_Init_Objects;
if First_Show then LoadDefault;
end;

procedure Tpop_scope.CheckBox1Click(Sender: TObject);
begin
cbo_source.Enabled := Checkbox1.Checked;
SpeedButton3.Enabled := Checkbox1.Checked;
cbo_starname.Enabled := Checkbox1.Checked;
if Checkbox1.Checked then cbo_source.ItemIndex:=1
                     else cbo_source.ItemIndex:=0;
Load_Init_Objects;                     
end;

procedure Tpop_scope.init90Click(Sender: TObject);
begin
{be sure we have the current steps}
if not pop_scope.timer1.enabled then
   if not Encoder_query(curstep_x,curstep_y) then begin
      Encoder_Error;
      exit;
   end;
Init90Y := curstep_y;
init90.Font.Color:=clGreen;
end;

procedure Tpop_scope.InitTypeClick(Sender: TObject);
begin
case inittype.ItemIndex of
0 :  Init90.Caption:='Init 0°';
1 :  Init90.Caption:='Init 90°';
end;
end;

procedure Tpop_scope.CheckBox3Click(Sender: TObject);
begin
if CheckBox3.checked then begin
  Initserialdebug('encoder_trace.txt');
  debug:=true;
end else begin
  CloseSerialDebug;
end;
end;

Function ExecuteFile(const FileName, Params, DefaultDir: string; ShowCmd: Integer): THandle;
var
  zFileName, zParams, zDir: array[0..79] of Char;
begin
  Result := ShellExecute(pop_scope.Handle, nil, StrPCopy(zFileName, FileName),
                         StrPCopy(zParams, Params), StrPCopy(zDir, DefaultDir), ShowCmd);
end;

procedure Tpop_scope.SpeedButton6Click(Sender: TObject);
begin
ExecuteFile('encoder.html','',appdir+'\doc',SW_SHOWNORMAL);
end;

procedure Tpop_scope.CheckBox4Click(Sender: TObject);
begin
if first_show then exit;
if checkbox4.checked then pop_scope.FormStyle:=fsStayOnTop
                     else pop_scope.FormStyle:=fsNormal;
end;


initialization
decimalseparator:='.';
pop_scope:=Tpop_scope.Create(nil);
Initlib;
end.
