unit pu_search;

{$MODE Delphi}{$H+}

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
 Search dialog for different object type.
}

interface

uses u_help, u_translation, u_constant, u_util, cu_database,
  httpsend, blcksock, XMLRead, DOM, LCLType, UScaleDPI,
  LCLIntf, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Buttons, LResources, LazHelpHTML;

const maxcombo = 500;

type

  { Tf_search }

  Tf_search = class(TForm)
    Button3: TButton;
    Button4: TButton;
    AsteroidList: TComboBox;
    Button5: TButton;
    RadioGroup2: TRadioGroup;
    ServerList: TComboBox;
    CometList: TComboBox;
    CometPanel: TPanel;
    CometFilter: TEdit;
    AsteroidPanel: TPanel;
    AsteroidFilter: TEdit;
    StatusLabel: TLabel;
    OnlineEdit: TEdit;
    OnlinePanel: TPanel;
    RadioGroup1: TRadioGroup;
    IDPanel: TPanel;
    Button1: TButton;
    Button2: TButton;
    Id: TEdit;
    NumPanel: TPanel;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    SpeedButton4: TSpeedButton;
    SpeedButton5: TSpeedButton;
    SpeedButton6: TSpeedButton;
    SpeedButton7: TSpeedButton;
    SpeedButton8: TSpeedButton;
    SpeedButton9: TSpeedButton;
    SpeedButton10: TSpeedButton;
    SpeedButton11: TSpeedButton;
    SpeedButton12: TSpeedButton;
    SpeedButton13: TSpeedButton;
    Label1: TLabel;
    NebPanel: TPanel;
    SpeedButton14: TSpeedButton;
    SpeedButton15: TSpeedButton;
    SpeedButton16: TSpeedButton;
    SpeedButton17: TSpeedButton;
    SpeedButton18: TSpeedButton;
    StarPanel: TPanel;
    SpeedButton19: TSpeedButton;
    SpeedButton20: TSpeedButton;
    SpeedButton22: TSpeedButton;
    SpeedButton23: TSpeedButton;
    VarPanel: TPanel;
    SpeedButton21: TSpeedButton;
    SpeedButton24: TSpeedButton;
    SpeedButton25: TSpeedButton;
    SpeedButton26: TSpeedButton;
    SpeedButton27: TSpeedButton;
    SpeedButton28: TSpeedButton;
    SpeedButton29: TSpeedButton;
    DblPanel: TPanel;
    SpeedButton30: TSpeedButton;
    SpeedButton31: TSpeedButton;
    PlanetPanel: TPanel;
    PlanetBox: TComboBox;
    Label2: TLabel;
    NebNamePanel: TPanel;
    Label3: TLabel;
    NebNameBox: TComboBox;
    StarNamePanel: TPanel;
    Label4: TLabel;
    StarNameBox: TComboBox;
    ConstPanel: TPanel;
    Label5: TLabel;
    ConstBox: TComboBox;
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure NumButtonClick(Sender: TObject);
    procedure RadioGroup2Click(Sender: TObject);
    procedure ServerListChange(Sender: TObject);
    procedure SpeedButton11Click(Sender: TObject);
    procedure SpeedButton13Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure CatButtonClick(Sender: TObject);
    procedure IdKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure RadioGroup1Click(Sender: TObject);
    procedure Init;
    procedure InitPlanet;
    procedure InitConst;
    procedure InitStarName;
    procedure InitNebName;
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    cometid, astid : array[0..maxcombo] of string;
    NebNameAR : array of single;
    NebNameDE : array of single;
    numNebName : integer;
    Fnightvision:boolean;
    http: THTTPSend;
  protected
    Fproxy,Fproxyport,Fproxyuser,Fproxypass : string;
    FSocksproxy,FSockstype : string;
    Sockreadcount, LastRead: integer;
    procedure httpstatus(Sender: TObject; Reason: THookSocketReason; const Value: String);
  public
    { Public declarations }
    cdb: Tcdcdb;
    Num,sesame_resolver,sesame_name,sesame_desc : string;
    ra,de: double;
    onlineOK: string;
    SearchKind : integer;
    cfgshr: Tconf_shared;
    showpluto: boolean;
    SesameUrlNum, SesameCatNum: integer;
    procedure SetLang;
    function SearchNebName(Num:string; var ar1,de1: double): boolean;
    procedure SetServerList;
    function SearchOnline: boolean;
    function LoadSesame(fn:string): boolean;
    property HttpProxy : string read Fproxy  write Fproxy ;
    property HttpProxyPort : string read Fproxyport  write Fproxyport ;
    property HttpProxyUser : string read Fproxyuser  write Fproxyuser ;
    property HttpProxyPass : string read Fproxypass  write Fproxypass ;
    property SocksProxy : string read FSocksproxy  write FSocksproxy ;
    property SocksType : string read FSockstype  write FSockstype ;
  end;

var
  f_search: Tf_search;

implementation
{$R *.lfm}

procedure Tf_search.SetLang;
begin
Caption:=rsSearch;
Button3.caption:=rsFilter;
Button4.caption:=rsFilter;
Label2.caption:=rsSolarSystemO;
Label3.caption:=rsNebula;
Label4.caption:=rsStar;
Label5.caption:=rsConstellatio;
Label1.caption:=rsObjectName;
RadioGroup1.caption:=rsSearchFor;
RadioGroup1.Items[0]:=rsNebula;
RadioGroup1.Items[1]:=rsNebulaCommon;
RadioGroup1.Items[2]:=rsStar;
RadioGroup1.Items[3]:=rsStarCommonNa;
RadioGroup1.Items[4]:=rsVariableStar;
RadioGroup1.Items[5]:=rsDoubleStar;
RadioGroup1.Items[6]:=rsComet;
RadioGroup1.Items[7]:=rsAsteroid;
RadioGroup1.Items[8]:=rsSolarSystem;
RadioGroup1.Items[9]:=rsConstellatio;
RadioGroup1.Items[10]:=rsInternet+' NED, Simbad, Vizier';
Button1.caption:=rsFind;
Button2.caption:=rsCancel;
Button5.caption:=rsHelp;
SetHelp(self,hlpSearch);
end;

procedure Tf_search.FormShow(Sender: TObject);
begin
{$ifdef mswindows}
if Fnightvision<>nightvision then begin
   SetFormNightVision(self,nightvision);
   Fnightvision:=nightvision;
end;
{$endif}
// return cursor to corresponding input box
case RadioGroup1.itemindex of
  0 : begin                      //neb
      ActiveControl:=Id;
      end;
  1 : begin                      //neb name
      ActiveControl:=NebNameBox;
      end;
  2 : begin                      //star
      ActiveControl:=Id;
      end;
  3 : begin                      //star name
      ActiveControl:=StarNameBox;
      end;
  4 : begin                      //var
      ActiveControl:=Id;
      end;
  5 : begin                      //dbl
      ActiveControl:=Id;
      end;
  6 : begin                      //comet
      ActiveControl:=CometList;
      end;
  7 : begin                      //asteroid
      ActiveControl:=AsteroidList;
      end;
  8 : begin                      //planet
      ActiveControl:=PlanetBox;
      end;
  9 : begin                      //const
      ActiveControl:=ConstBox;
      end;
  10 : begin                      // online
      ActiveControl:=OnlineEdit;
      end;
end;
end;

procedure Tf_search.CatButtonClick(Sender: TObject);
begin
with sender as TspeedButton do begin
  Id.text:=caption;
end;
Id.SelStart:=length(Id.Text);
end;

procedure Tf_search.NumButtonClick(Sender: TObject);
begin
with sender as TspeedButton do begin
  Id.text:=Id.text+caption;
end;
Id.SelStart:=length(Id.Text);
end;

procedure Tf_search.RadioGroup2Click(Sender: TObject);
begin
  SesameCatNum:=RadioGroup2.ItemIndex;
end;

procedure Tf_search.ServerListChange(Sender: TObject);
begin
  SesameUrlNum:=ServerList.ItemIndex;
end;

procedure Tf_search.FormCreate(Sender: TObject);
begin
ScaleDPI(Self);
SetLang;
Fnightvision:=false;
StatusLabel.Caption:='';
CometFilter.Text:='C/'+FormatDateTime('yyyy',now);
RadioGroup1Click(Sender);
http := THTTPSend.Create;
Fproxy:='';
FSocksproxy:='';
end;

procedure Tf_search.FormDestroy(Sender: TObject);
begin
http.Free;
end;

procedure Tf_search.Button3Click(Sender: TObject);
var list: TStringList;
begin
list:=TStringList.Create;
Cdb.GetCometList(CometFilter.Text,maxcombo,list,cometid);
CometList.Items.Assign(list);
CometList.ItemIndex:=0;
end;

procedure Tf_search.Button4Click(Sender: TObject);
var list: TStringList;
begin
list:=TStringList.Create;
Cdb.GetAsteroidList(AsteroidFilter.Text,maxcombo,list,Astid);
AsteroidList.Items.Assign(list);
AsteroidList.ItemIndex:=0;
end;

procedure Tf_search.Button5Click(Sender: TObject);
begin
  ShowHelp;
end;

procedure Tf_search.SpeedButton11Click(Sender: TObject);
var buf : string;
begin
buf:=Id.text;
delete(buf,length(buf),1);
Id.text:=buf;
Id.SelStart:=length(Id.Text);
end;

procedure Tf_search.SpeedButton13Click(Sender: TObject);
begin
Id.text:='';
end;

function Tf_search.SearchNebName(Num:string; var ar1,de1: double): boolean;
var i,p: integer;
    buf: string;
begin
buf:=uppercase(Num);
result:=false;
for i:=0 to NebNameBox.Items.Count-1 do begin
   p:=pos(buf,uppercase(NebNameBox.Items[i]));
   if p=1 then begin
      ar1:=NebNameAR[i];
      de1:=NebNameDE[i];
      result:=true;
      break;
   end;
end;
end;

function Tf_search.LoadSesame(fn:string): boolean;
var Doc: TXMLDocument;
    Node,Snode,Dnode: TDOMNode;
    k,v,a,buf,k1,v1: string;
begin
result:=false;
sesame_resolver:='';sesame_name:='';sesame_desc:='';
ReadXMLFile( Doc, fn);
try
Node:=Doc.DocumentElement.FindNode('Target');
if Node=nil then exit;
Node:=Node.FindNode('Resolver');
if Node=nil then exit;
Snode:=Node.Attributes.GetNamedItem('name');
if Snode<>nil then sesame_resolver:=string(Snode.TextContent);
Node:=Node.FirstChild;
while Node<>nil do begin
   k:=string(Node.NodeName);
   if k<>'#comment' then begin
   v:=string(Node.TextContent);
   a:='';
   Dnode:=Node.Attributes.Item[0];
   if Dnode<>nil then a:=string(Dnode.NodeName)+'.'+string(Dnode.TextContent);
   buf:='';
   Dnode:=Node.FirstChild;
   while Dnode<>nil do begin
     k1:=string(Dnode.NodeName);
     if k1='#text' then break;
     v1:=string(Dnode.TextContent);
     buf:=buf+k+'.'+a+'.'+k1+':'+v1+tab;
     Dnode:=Dnode.NextSibling;
   end;
   if buf='' then sesame_desc:=sesame_desc+k+':'+v+tab
             else sesame_desc:=sesame_desc+buf;
   if k='oname' then sesame_name:=v;
   if k='jradeg' then begin
      ra:=StrToFloatDef(v,-9999);
      if ra=-9999 then exit;
      ra:=deg2rad*ra;
   end;
   if k='jdedeg' then begin
      de:=StrToFloatDef(v,-9999);
      if de=-9999 then exit;
      de:=deg2rad*de;
   end;
   end;
   Node:=Node.NextSibling;
end;
if sesame_name='' then sesame_name:=num;
result:=true;
finally
Doc.Free;
end;
end;

procedure Tf_search.SetServerList;
var i : integer;
begin
  ServerList.Items.Clear;
  for i:=1 to sesame_maxurl do
    if sesame_url[i,2]<>'' then
      ServerList.Items.Add(sesame_url[i,2]);
  ServerList.ItemIndex:=SesameUrlNum;
  RadioGroup2.ItemIndex:=SesameCatNum;
end;

function Tf_search.SearchOnline: boolean;
var url,cat,vo_sesame:string;
begin
result:=false;
vo_sesame:=slash(VODir)+'vo_sesame.xml';
case SesameCatNum of
  0 : cat:='N';
  1 : cat:='S';
  2 : cat:='V';
  3 : cat:='NSV';
  else cat:='';
end;
url:=sesame_url[SesameUrlNum+1,1];
url:=url+'/-oxFI/'+cat+'?'+trim(StringReplace(num,' ','%20',[rfReplaceAll]));
http.Clear;
http.Sock.SocksIP:='';
http.ProxyHost:='';
if FSocksproxy<>'' then begin
  http.Sock.SocksIP:=FSocksproxy;
  if Fproxyport<>'' then http.Sock.SocksPort:=Fproxyport;
  if FSockstype='Socks4' then http.Sock.SocksType:=ST_Socks4
                         else http.Sock.SocksType:=ST_Socks5;
  if Fproxyuser<>'' then http.Sock.SocksUsername:=Fproxyuser;
  if Fproxypass<>'' then http.Sock.SocksPassword:=Fproxypass;
end
else if Fproxy<>'' then  begin
    http.ProxyHost:=Fproxy;
    if Fproxyport<>'' then http.ProxyPort:=Fproxyport;
    if Fproxyuser<>'' then http.ProxyUser :=Fproxyuser;
    if Fproxypass<>'' then http.ProxyPass :=Fproxypass;
end;
http.Timeout:=10000;
http.Sock.OnStatus:=httpstatus;
Sockreadcount:=0;
if http.HTTPMethod('GET', url)
   and ((http.ResultCode=200)
   or (http.ResultCode=0))
     then begin
       StatusLabel.Caption:='Completed';
       http.Document.SaveToFile(vo_sesame);
       result:=LoadSesame(vo_sesame);
       if not Result then StatusLabel.Caption:=format(rsNotFound,[num]);
     end
     else StatusLabel.Caption:=StatusLabel.Caption+' '+rsOnlineSearch;
http.Clear;
end;

procedure Tf_search.Button1Click(Sender: TObject);
begin
searchkind:=RadioGroup1.itemindex;
case searchkind of
  1 : begin
      num:=NebNameBox.Text;
      ra:=NebNameAR[NebNameBox.itemindex];
      de:=NebNameDE[NebNameBox.itemindex];
      end;
  3 : num:='HR'+inttostr(cfgshr.StarNameHR[starnamebox.itemindex]);
  6 : num:=CometList.Text;
  7 : num:=AsteroidList.Text;
  8 : num:=PlanetBox.Text;
  9 : num:=ConstBox.Text;
  10: begin
      num:=OnlineEdit.Text;
      if not SearchOnline then exit;
      end;
  else num:=Id.text;
end;
if trim(num)='' then ShowMessage(rsPleaseEnterA)
                else ModalResult := mrOk;
end;

procedure Tf_search.IdKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
if key=VK_RETURN then Button1.Click;
end;

procedure Tf_search.RadioGroup1Click(Sender: TObject);
begin
case RadioGroup1.itemindex of
  0 : begin                      //neb
      IDPanel.Visible:=true;
      NumPanel.Visible:=true;
      NebPanel.Visible:=true;
      StarPanel.Visible:=false;
      VarPanel.Visible:=false;
      DblPanel.Visible:=false;
      PlanetPanel.Visible:=false;
      NebNamePanel.Visible:=false;
      StarNamePanel.Visible:=false;
      ConstPanel.Visible:=false;
      CometPanel.Visible:=false;
      AsteroidPanel.Visible:=false;
      OnlinePanel.Visible:=false;
      end;
  1 : begin                      //neb name
      IDPanel.Visible:=false;
      PlanetPanel.Visible:=false;
      NebNamePanel.Visible:=true;
      StarNamePanel.Visible:=false;
      ConstPanel.Visible:=false;
      CometPanel.Visible:=false;
      AsteroidPanel.Visible:=false;
      OnlinePanel.Visible:=false;
      end;
  2 : begin                      //star
      IDPanel.Visible:=true;
      NumPanel.Visible:=true;
      NebPanel.Visible:=false;
      StarPanel.Visible:=true;
      VarPanel.Visible:=false;
      DblPanel.Visible:=false;
      PlanetPanel.Visible:=false;
      NebNamePanel.Visible:=false;
      StarNamePanel.Visible:=false;
      ConstPanel.Visible:=false;
      CometPanel.Visible:=false;
      AsteroidPanel.Visible:=false;
      OnlinePanel.Visible:=false;
      end;
  3 : begin                      //star name
      IDPanel.Visible:=false;
      PlanetPanel.Visible:=false;
      NebNamePanel.Visible:=false;
      StarNamePanel.Visible:=true;
      ConstPanel.Visible:=false;
      CometPanel.Visible:=false;
      AsteroidPanel.Visible:=false;
      OnlinePanel.Visible:=false;
      end;
  4 : begin                      //var
      IDPanel.Visible:=true;
      NumPanel.Visible:=true;
      NebPanel.Visible:=false;
      StarPanel.Visible:=false;
      VarPanel.Visible:=true;
      DblPanel.Visible:=false;
      PlanetPanel.Visible:=false;
      NebNamePanel.Visible:=false;
      StarNamePanel.Visible:=false;
      ConstPanel.Visible:=false;
      CometPanel.Visible:=false;
      AsteroidPanel.Visible:=false;
      OnlinePanel.Visible:=false;
      end;
  5 : begin                      //dbl
      IDPanel.Visible:=true;
      NumPanel.Visible:=true;
      NebPanel.Visible:=false;
      StarPanel.Visible:=false;
      VarPanel.Visible:=false;
      DblPanel.Visible:=true;
      PlanetPanel.Visible:=false;
      NebNamePanel.Visible:=false;
      StarNamePanel.Visible:=false;
      ConstPanel.Visible:=false;
      CometPanel.Visible:=false;
      AsteroidPanel.Visible:=false;
      OnlinePanel.Visible:=false;
      end;
  6 : begin                      //comet
      IDPanel.Visible:=false;
      PlanetPanel.Visible:=false;
      NebNamePanel.Visible:=false;
      StarNamePanel.Visible:=false;
      ConstPanel.Visible:=false;
      CometPanel.Visible:=true;
      OnlinePanel.Visible:=false;
      AsteroidPanel.Visible:=false;
      end;
  7 : begin                      //asteroid
      IDPanel.Visible:=false;
      PlanetPanel.Visible:=false;
      NebNamePanel.Visible:=false;
      StarNamePanel.Visible:=false;
      ConstPanel.Visible:=false;
      CometPanel.Visible:=false;
      AsteroidPanel.Visible:=true;
      OnlinePanel.Visible:=false;
      end;
  8 : begin                      //planet
      IDPanel.Visible:=false;
      PlanetPanel.Visible:=true;
      NebNamePanel.Visible:=false;
      StarNamePanel.Visible:=false;
      ConstPanel.Visible:=false;
      CometPanel.Visible:=false;
      AsteroidPanel.Visible:=false;
      OnlinePanel.Visible:=false;
      end;
  9 : begin                      //const
      IDPanel.Visible:=false;
      PlanetPanel.Visible:=false;
      NebNamePanel.Visible:=false;
      StarNamePanel.Visible:=false;
      ConstPanel.Visible:=true;
      CometPanel.Visible:=false;
      AsteroidPanel.Visible:=false;
      OnlinePanel.Visible:=false;
      end;
  10 :begin                      // online
      IDPanel.Visible:=false;
      PlanetPanel.Visible:=false;
      NebNamePanel.Visible:=false;
      StarNamePanel.Visible:=false;
      ConstPanel.Visible:=false;
      CometPanel.Visible:=false;
      AsteroidPanel.Visible:=false;
      OnlinePanel.Visible:=true;
      end;
  {  10 : begin                      //Other Line Catalog , not active at the moment as Catgen do not allow to create the index for line cat.
        IDPanel.Visible:=true;
        NumPanel.Visible:=false;
        NebPanel.Visible:=false;
        StarPanel.Visible:=false;
        VarPanel.Visible:=false;
        DblPanel.Visible:=false;
        PlanetPanel.Visible:=false;
        NebNamePanel.Visible:=false;
        StarNamePanel.Visible:=false;
        ConstPanel.Visible:=false;
        CometPanel.Visible:=false;
        AsteroidPanel.Visible:=false;
        OnlinePanel.Visible:=false;
        end;  }
end;
end;

procedure Tf_search.Init;
begin
InitPlanet;
InitConst;
InitNebName;
InitStarName;
SetServerList;
end;

procedure Tf_search.InitPlanet;
var i : integer;
begin
PlanetBox.Clear;
for i:=1 to 11 do begin
  if i=3 then continue;
  if (i=9) and (not ShowPluto) then continue;
  PlanetBox.Items.Add(pla[i]);
end;
PlanetBox.ItemIndex:=0;
end;

procedure Tf_search.InitConst;
var i : integer;
begin
ConstBox.Clear;
for i:=0 to cfgshr.ConstelNum-1 do
  ConstBox.Items.Add(cfgshr.ConstelName[i,2]);
if ConstBox.items.Count=0 then
   ConstBox.items.add(blank);
ConstBox.ItemIndex:=0;
end;

procedure Tf_search.InitStarName;
var
    i : integer;
begin
starnamebox.Clear;
for i:=0 to cfgshr.StarNameNum-1 do
   starnamebox.items.Add(cfgshr.StarName[i]);
if starnamebox.items.Count=0 then
   starnamebox.items.add(blank);
starnamebox.itemindex:=0;
end;

procedure Tf_search.InitNebName;
var
    n,fn : string;
    buf : string;
    f : textfile;
    i,p : integer;
begin
try
NebNameBox.Clear;
i:=0;
fn:=slash(appdir)+slash('data')+slash('common_names')+'NebulaNames_'+lang+'.txt';
if not fileexists(fn) then fn:=slash(appdir)+slash('data')+slash('common_names')+'NebulaNames.txt';
numNebName:=100;
setlength(NebNameAR,numNebName);
setlength(NebNameDE,numNebName);
if FileExists(fn) then begin
  AssignFile(f,fn);
  FileMode:=0;
  reset(f);
  repeat
    if i>=numNebName then begin
       numNebName:=numNebName+50;
       setlength(NebNameAR,numNebName);
       setlength(NebNameDE,numNebName);
    end;
    Readln(f,buf);
    buf:=CondUTF8Decode(buf);
    p:=pos(';',buf);
    if p=0 then continue;
    if not isnumber(trim(copy(buf,1,p-1))) then continue;
    NebNameAR[i]:=deg2rad*15*strtofloat(trim(copy(buf,1,p-1)));
    delete(buf,1,p);
    p:=pos(';',buf);
    if p=0 then continue;
    NebNameDE[i]:=deg2rad*strtofloat(trim(copy(buf,1,p-1)));
    delete(buf,1,p);
    n:=trim(buf);
    NebNameBox.items.Add(n);
    inc(i);
  until eof(f);
  numNebName:=i-1;
  CloseFile(f);
end;
finally
if NebNameBox.items.Count=0 then begin
  NebNameBox.items.add(blank);
end;
NebNameBox.ItemIndex:=0;
end;
end;

procedure Tf_search.httpstatus(Sender: TObject; Reason: THookSocketReason; const Value: String);
var txt: string;
begin
txt:='';
case reason of
  HR_ResolvingBegin : txt:='Resolving '+value;
  HR_Connect        : txt:='Connect '+value;
  HR_Accept         : txt:='Accept '+value;
  HR_ReadCount      : begin
                      Sockreadcount:=Sockreadcount+strtoint(value);
                      if (Sockreadcount-LastRead)>100000 then begin
                        txt:='Read data: '+inttostr(Sockreadcount div 1024)+' KB';
                        LastRead:=Sockreadcount;
                      end;
                      end;
  HR_WriteCount     : begin
                      txt:='Request sent ...';
                      end;
  else txt:='';
end;
if (txt>'')then begin
  StatusLabel.Caption:=txt;
  Application.ProcessMessages;
end;
end;

end.
