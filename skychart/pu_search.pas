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

uses
  u_help, u_translation, u_constant, u_util, cu_database, cu_calceph,
  httpsend, blcksock, XMLRead, DOM, LCLType, UScaleDPI, synacode,
  LCLIntf, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Buttons, LResources, LazHelpHTML_fix, ComCtrls, Types;

const
  maxcombo = 500;

type

  { THTTPthread }

  THTTPthread = class(TThread)
    private
      Fhttp: THTTPSend;
      Furl,Fmethod: String;
      FonStatus: TNotifyEvent;
      FStatusReason: THookSocketReason;
      FStatusValue: String;
      Fok: boolean;
      procedure sendstatus;
      procedure httpstatus(Sender: TObject; Reason: THookSocketReason; const Value: String);
    public
      constructor Create;
      destructor Destroy; override;
      procedure Execute; override;
      property http: THTTPSend read Fhttp write Fhttp;
      property url: String read Furl write Furl;
      property method: String read Fmethod write Fmethod;
      property ok: boolean read Fok;
      property StatusReason: THookSocketReason read FStatusReason;
      property StatusValue: String read FStatusValue;
      property onStatus:TNotifyEvent read FonStatus write FonStatus;
  end;

  { Tf_search }

  Tf_search = class(TForm)
    btnCometFilter: TButton;
    btnAstFilter: TButton;
    AsteroidList: TComboBox;
    btnFindInfo: TButton;
    btnHelp: TButton;
    Label6: TLabel;
    SPKbox: TComboBox;
    PageControl1: TPageControl;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
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
    btnFind: TButton;
    btnCancel: TButton;
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
    tsBody: TTabSheet;
    tsStarName: TTabSheet;
    tsConst: TTabSheet;
    tsStars: TTabSheet;
    tsOnline: TTabSheet;
    tsPlanet: TTabSheet;
    tsComet: TTabSheet;
    tsAsteroid: TTabSheet;
    tsNebName: TTabSheet;
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
    procedure btnCometFilterClick(Sender: TObject);
    procedure btnAstFilterClick(Sender: TObject);
    procedure btnFindInfoClick(Sender: TObject);
    procedure btnHelpClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure NumButtonClick(Sender: TObject);
    procedure PageControl1Change(Sender: TObject);
    procedure RadioGroup2Click(Sender: TObject);
    procedure ServerListChange(Sender: TObject);
    procedure SpeedButton11Click(Sender: TObject);
    procedure SpeedButton13Click(Sender: TObject);
    procedure btnFindClick(Sender: TObject);
    procedure CatButtonClick(Sender: TObject);
    procedure IdKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure RadioGroup1Click(Sender: TObject);
    procedure Init;
    procedure InitPlanet;
    procedure InitConst;
    procedure InitStarName;
    procedure InitNebName;
    procedure InitBody;
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    FFindInfo: TNotifyEvent;
    cometid: array[0..maxcombo] of string;
    astid: array[0..maxcombo] of integer;
    NebNameAR : array of single;
    NebNameDE : array of single;
    numNebName : integer;
    Fnightvision:boolean;
    pagespk: integer;
    procedure GetSearchText;
  protected
    Fproxy,Fproxyport,Fproxyuser,Fproxypass : string;
    FSocksproxy,FSockstype : string;
    Sockreadcount, LastRead: integer;
    FTimeout: integer;
    procedure httpstatus(Sender: TObject);
    function WaitRequest(req: THTTPthread): boolean;
  public
    { Public declarations }
    cdb: Tcdcdb;
    csc: Tconf_skychart;
    Num,sesame_resolver,sesame_name,sesame_desc : string;
    ra,de: double;
    onlineOK: string;
    SearchKind : integer;
    cfgshr: Tconf_shared;
    showpluto: boolean;
    SesameUrlNum, SesameCatNum: integer;
    procedure SetLang;
    function SearchNebNameExact(Num:string; var ar1,de1: double): boolean;
    function SearchNebNameGeneric(Num:string; var ar1,de1: double): boolean;
    procedure SetServerList;
    function SearchOnline: boolean;
    function LoadSesame(fn:string): boolean;
    property HttpProxy : string read Fproxy  write Fproxy ;
    property HttpProxyPort : string read Fproxyport  write Fproxyport ;
    property HttpProxyUser : string read Fproxyuser  write Fproxyuser ;
    property HttpProxyPass : string read Fproxypass  write Fproxypass ;
    property SocksProxy : string read FSocksproxy  write FSocksproxy ;
    property SocksType : string read FSockstype  write FSockstype ;
    property onFindInfo: TNotifyEvent read FFindInfo write FFindInfo;
  end;

var
  f_search: Tf_search;

implementation
{$R *.lfm}

procedure Tf_search.SetLang;
begin

  Caption:=rsSearch;

  btnCometFilter.caption:=rsFilter;
  btnAstFilter.caption:=rsFilter;
  Label2.caption:=rsSolarSystemO;
  Label3.caption:=rsNebula;
  Label4.caption:=rsStar;
  Label5.caption:=rsConstellatio;
  Label1.caption:=rsObjectName;
  label6.Caption:=rsSPICEEphemer;
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
  if pagespk>0 then RadioGroup1.Items[pagespk]:=rsSolarSystemB;
  btnFind.caption:=rsFind;
  btnFindInfo.Caption:=rsFindInfo;
  btnCancel.caption:=rsCancel;
  btnHelp.caption:=rsHelp;
  SetHelp(self,hlpSearch);
end;

procedure Tf_search.FormShow(Sender: TObject);
begin

  PageControl1Change(Self);

end;

procedure Tf_search.CatButtonClick(Sender: TObject);
begin

  with sender as TSpeedButton do
  begin
    Id.text := caption;
  end;

  Id.SelStart:=length(Id.Text);

end;

procedure Tf_search.NumButtonClick(Sender: TObject);
begin

  with sender as TSpeedButton do
  begin
    Id.text := Id.text+caption;
  end;

  Id.SelStart := length(Id.Text);

end;

procedure Tf_search.PageControl1Change(Sender: TObject);
begin
  // return cursor to corresponding input box

  case RadioGroup1.itemindex of

    0 : ActiveControl:=Id;             //neb
    1 : ActiveControl:=NebNameBox;     //neb name
    2 : ActiveControl:=Id;             //star
    3 : ActiveControl:=StarNameBox;    //star name
    4 : ActiveControl:=Id;             //var
    5 : ActiveControl:=Id;             //dbl
    6 : ActiveControl:=CometFilter;    //comet
    7 : ActiveControl:=AsteroidFilter; //asteroid
    8 : ActiveControl:=PlanetBox;      //planet
    9 : ActiveControl:=ConstBox;       //const
   10 : ActiveControl:=OnlineEdit;     //online
   11 : ActiveControl:=SPKbox;         //spk

  end;
end;

procedure Tf_search.RadioGroup2Click(Sender: TObject);
begin
  SesameCatNum := RadioGroup2.ItemIndex;
end;

procedure Tf_search.ServerListChange(Sender: TObject);
begin
  SesameUrlNum := ServerList.ItemIndex;
end;

procedure Tf_search.FormCreate(Sender: TObject);
begin

  PageControl1.ShowTabs := false;
  PageControl1.AutoSize := True;

  ScaleDPI(Self);
  SetLang;
  Fnightvision:=false;
  StatusLabel.Caption:='';
  CometFilter.Text:='C/'+FormatDateTime('yyyy',now);
  RadioGroup1Click(Sender);

  FTimeout:=5000;
  Fproxy:='';
  FSocksproxy:='';

  pagespk:=-1;

end;

procedure Tf_search.FormDestroy(Sender: TObject);
begin
end;

procedure Tf_search.btnCometFilterClick(Sender: TObject);
var
  list: TStringList;
begin

  list := TStringList.Create;

  try

    Cdb.GetCometList(CometFilter.Text,maxcombo,list,cometid);
    CometList.Items.Assign(list);
    CometList.ItemIndex:=0;

  finally
    list.Free;
  end;

end;

procedure Tf_search.btnAstFilterClick(Sender: TObject);
var
  list: TStringList;
begin

  list := TStringList.Create;

  try

    Cdb.GetAsteroidList(AsteroidFilter.Text,maxcombo,list,Astid);
    AsteroidList.Items.Assign(list);
    AsteroidList.ItemIndex:=0;

  finally
    List.Free
  end;

end;

procedure Tf_search.btnHelpClick(Sender: TObject);
begin
  ShowHelp;
end;

procedure Tf_search.SpeedButton11Click(Sender: TObject);
var
  buf : string;
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

function Tf_search.SearchNebNameExact(Num:string; var ar1,de1: double): boolean;
var
  i: integer;
  buf: string;
begin

  buf := uppercase(Num);

  result:=false;

  for i:=0 to NebNameBox.Items.Count-1 do
  begin

    if buf=uppercase(NebNameBox.Items[i]) then
    begin
      ar1:=NebNameAR[i];
      de1:=NebNameDE[i];
      result:=true;
      break;
    end;

  end;

end;

function Tf_search.SearchNebNameGeneric(Num:string; var ar1,de1: double): boolean;
var
  i,p: integer;
  buf: string;
begin

  buf := uppercase(Num);

  result:=false;

  for i:=0 to NebNameBox.Items.Count-1 do
  begin

    p:=pos(buf,uppercase(NebNameBox.Items[i]));

    if p=1 then
    begin
      ar1:=NebNameAR[i];
      de1:=NebNameDE[i];
      result:=true;
      break;
    end;

  end;

end;


function Tf_search.LoadSesame(fn:string): boolean;
var
  Doc: TXMLDocument;
  Node,Snode,Dnode: TDOMNode;
  k,v,a,buf,k1,v1: string;
begin

  result:=false;

  sesame_resolver:='';
  sesame_name:='';
  sesame_desc:='';
  ra:=NullCoord;
  de:=NullCoord;

  Doc := nil;

  try
  ReadXMLFile( Doc, fn);
  except
    result:=false;
    exit;
  end;

  if Doc = nil then
    exit;

  try

    Node := Doc.DocumentElement.FindNode('Target');

    if Node = nil then
      exit;

    Node := Node.FindNode('Resolver');

    if Node = nil then
      exit;

    Snode := Node.Attributes.GetNamedItem('name');

    if Snode <> nil then
      sesame_resolver := string(Snode.TextContent);

    Node := Node.FirstChild;

    while Node <> nil do
    begin

      k := string(Node.NodeName);

      if k <> '#comment' then
      begin

        v := string(Node.TextContent);
        a := '';

        Dnode := Node.Attributes.Item[0];

        if Dnode <> nil then
           a := string(Dnode.NodeName) + '.' + string(Dnode.TextContent);

        buf :='';
        Dnode := Node.FirstChild;

        while Dnode <> nil do
        begin
          k1 := string(Dnode.NodeName);

          if k1 = '#text' then break;

          v1 := string(Dnode.TextContent);

          buf := buf+k+'.'+a+'.'+k1+':'+v1+tab;
          Dnode := Dnode.NextSibling;
        end;

        if buf='' then sesame_desc:=sesame_desc+k+':'+v+tab
                  else sesame_desc:=sesame_desc+buf;

        if k = 'oname' then sesame_name := v;

        if k ='jradeg' then
        begin
          ra := StrToFloatDef(v,-9999);
          if ra = -9999 then
            exit;

          ra := deg2rad * ra;
        end;

        if k = 'jdedeg' then
        begin
          de := StrToFloatDef(v,-9999);
          if de = -9999 then
            exit;

          de := deg2rad * de;
        end;

      end;

      Node := Node.NextSibling;

    end;

    if sesame_name = '' then
      sesame_name := num;

    result := (ra>-9000)and(de>-9000);

  finally
    Doc.Free;
  end;

end;

procedure Tf_search.SetServerList;
var
  i : integer;
begin

  ServerList.Items.Clear;

  for i:=1 to sesame_maxurl do
    if sesame_url[i,2]<>'' then
      ServerList.Items.Add(sesame_url[i,2]);

  ServerList.ItemIndex:=SesameUrlNum;
  RadioGroup2.ItemIndex:=SesameCatNum;

end;

function Tf_search.SearchOnline: boolean;
var
  url,cat,vo_sesame,n:string;
  HTTPRequest: THTTPthread;
begin

  result:=false;

  vo_sesame:=slash(VODir)+'vo_sesame.xml';

  case SesameCatNum of
    0 : cat:='N';
    1 : cat:='S';
    2 : cat:='V';
    3 : cat:='~SNVA';
  else
    cat:='';
  end;

  n := EncodeURLElement(num);

  url:=sesame_url[SesameUrlNum+1,1];
  url:=url+'/-oxFI/'+cat+'?'+trim(n);

  HTTPRequest:=THTTPthread.Create;
  HTTPRequest.http.Sock.SocksIP:='';
  HTTPRequest.http.ProxyHost:='';
  if FSocksproxy<>'' then
  begin
    HTTPRequest.http.Sock.SocksIP:=FSocksproxy;
    if Fproxyport<>'' then HTTPRequest.http.Sock.SocksPort:=Fproxyport;
    if FSockstype='Socks4' then HTTPRequest.http.Sock.SocksType:=ST_Socks4
                           else HTTPRequest.http.Sock.SocksType:=ST_Socks5;
    if Fproxyuser<>'' then HTTPRequest.http.Sock.SocksUsername:=Fproxyuser;
    if Fproxypass<>'' then HTTPRequest.http.Sock.SocksPassword:=Fproxypass;
  end

  else if Fproxy<>'' then  begin
      HTTPRequest.http.ProxyHost:=Fproxy;
      if Fproxyport<>'' then HTTPRequest.http.ProxyPort:=Fproxyport;
      if Fproxyuser<>'' then HTTPRequest.http.ProxyUser :=Fproxyuser;
      if Fproxypass<>'' then HTTPRequest.http.ProxyPass :=Fproxypass;
  end;
  HTTPRequest.http.Document.Clear;
  HTTPRequest.http.Headers.Clear;
  HTTPRequest.http.Timeout:=FTimeout;
  HTTPRequest.http.sock.SocksTimeout:=FTimeout;
  if visible then
    HTTPRequest.OnStatus:=httpstatus;
  HTTPRequest.url:=url;
  HTTPRequest.method:='GET';
  Sockreadcount:=0;
  HTTPRequest.Start;
  if WaitRequest(HTTPRequest) then
  begin
   if((HTTPRequest.http.ResultCode=200)or(HTTPRequest.http.ResultCode=0)) then
   begin
      StatusLabel.Caption:='Completed';
      HTTPRequest.http.Document.SaveToFile(vo_sesame);
      result:=LoadSesame(vo_sesame);
      if not Result then begin
        StatusLabel.Caption:=format(rsNotFound,[num]);
        num:='Not found';
      end;
    end
    else begin
      StatusLabel.Caption:=StatusLabel.Caption+' '+rsOnlineSearch;
      num:='Not found';
    end;
    HTTPRequest.Free;
  end
  else begin
    StatusLabel.Caption:=StatusLabel.Caption+' '+rsOnlineSearch;
    num:='Not found';
  end;
end;

procedure Tf_search.GetSearchText;
begin
  searchkind := RadioGroup1.itemindex;
  case searchkind of
    1 :
      begin
        num := NebNameBox.Text;

        ra := NebNameAR[NebNameBox.itemindex];
        de := NebNameDE[NebNameBox.itemindex];
      end;
    3 : num := 'HR'+inttostr(cfgshr.StarNameHR[starnamebox.itemindex]);
    6 : num := CometList.Text;
    7 : num := AsteroidList.Text;
    8 : num := PlanetBox.Text;
    9 : num := ConstBox.Text;
   10 :
      begin
        num:=OnlineEdit.Text;

        if not SearchOnline then
           exit;
      end;
   11: num := SPKbox.Text;
    else
      num:=Id.text;
  end;
end;

procedure Tf_search.btnFindInfoClick(Sender: TObject);
begin
  GetSearchText;
  if trim(num)='' then
    ShowMessage(rsPleaseEnterA)
  else if trim(num)='Not found' then
      ShowMessage(format(rsNotFound,['']))
  else
    if assigned(FFindInfo) then FFindInfo(self);
end;


procedure Tf_search.btnFindClick(Sender: TObject);
begin
  GetSearchText;
  if trim(num)='' then
    ShowMessage(rsPleaseEnterA)
  else if trim(num)='Not found' then
    ShowMessage(format(rsNotFound,['']))
  else
    ModalResult := mrOk;
end;

procedure Tf_search.IdKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key=VK_RETURN then
    btnFind.Click;
end;

procedure Tf_search.RadioGroup1Click(Sender: TObject);
begin

  NumPanel.Visible  :=false;
  NebPanel.Visible  :=false;
  StarPanel.Visible :=false;
  VarPanel.Visible  :=false;
  DblPanel.Visible  :=false;

  case RadioGroup1.itemindex of

    0 :                       //neb
      begin
        NumPanel.Visible:=true;
        NebPanel.Visible:=true;

        PageControl1.ActivePage := tsStars;
      end;

    1 : PageControl1.ActivePage := tsNebName; //neb name

    2 :                       //star
      begin
        NumPanel.Visible:=true;
        StarPanel.Visible:=true;

        PageControl1.ActivePage := tsStars;

      end;

    3 : PageControl1.ActivePage := tsStarName; //star name

    4 :                       //var
      begin
        NumPanel.Visible:=true;
        VarPanel.Visible:=true;

        PageControl1.ActivePage := tsStars;
      end;

    5 :                       //dbl
      begin
        NumPanel.Visible:=true;
        DblPanel.Visible:=true;

        PageControl1.ActivePage := tsStars;

      end;

    6 : PageControl1.ActivePage := tsComet;    //comet
    7 : PageControl1.ActivePage := tsAsteroid; //asteroid
    8 : PageControl1.ActivePage := tsPlanet;   //planet
    9 : PageControl1.ActivePage := tsConst;    //const
   10 : PageControl1.ActivePage := tsOnline;   //online
   else begin
     if RadioGroup1.itemindex=pagespk then PageControl1.ActivePage := tsBody;     //SPK
   end;

  end;
end;


procedure Tf_search.Init;
begin
  if (pagespk<0)and(libcalceph<>0) then begin
    pagespk := RadioGroup1.Items.Add(rsSolarSystemB);
  end;
  InitPlanet;
  InitConst;
  InitNebName;
  InitStarName;
  SetServerList;
end;

procedure Tf_search.InitBody;
var i,j: integer;
  buf:string;
begin
  buf:=SPKbox.Text;
  SPKbox.Clear;

  j:=0;
  for i:=0 to csc.BodiesNb-1 do begin
    SPKbox.Items.Add(csc.SPKNames[i]);
    if csc.SPKNames[i]=buf then j:=i;
  end;

  SPKbox.ItemIndex:=j;
end;

procedure Tf_search.InitPlanet;
var
  i : integer;
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
var
  i : integer;
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

    if not fileexists(fn) then
      fn:=slash(appdir)+slash('data')+slash('common_names')+'NebulaNames.txt';

    numNebName:=100;

    setlength(NebNameAR,numNebName);
    setlength(NebNameDE,numNebName);

    if FileExists(fn) then
    begin
      AssignFile(f,fn);
      FileMode:=0;
      reset(f);

      repeat

        if i >= numNebName then
        begin
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

    if NebNameBox.items.Count=0 then
      NebNameBox.items.add(blank);

    NebNameBox.ItemIndex:=0;
  end;

end;

procedure Tf_search.httpstatus(Sender: TObject);
var
  txt: string;
begin

  txt:='';

  with THTTPthread(sender) do
  case StatusReason of

    HR_ResolvingBegin : txt:='Resolving '+StatusValue;
    HR_Connect        : txt:='Connect '+StatusValue;
    HR_Accept         : txt:='Accept '+StatusValue;

    HR_ReadCount      :
      begin
        Sockreadcount:=Sockreadcount+strtoint(StatusValue);

        if (Sockreadcount-LastRead)>100000 then
        begin
          txt:='Read data: '+inttostr(Sockreadcount div 1024)+' KB';
          LastRead:=Sockreadcount;
        end;

      end;

    HR_WriteCount     : txt:='Request sent ...';

  else
    txt:='';
  end;
  if txt<>'' then
    StatusLabel.Caption:=txt;
  Application.ProcessMessages;
end;

function Tf_search.WaitRequest(req: THTTPthread): boolean;
var endt: double;
    aborted: boolean;
begin
  result:=false;
  // ensure request time do not excess timeout
  endt:=now+FTimeout/MSecsPerDay;
  aborted:=false;
  while (not req.Finished)and(not aborted) do begin
    aborted:=(now>endt);
    sleep(10);
    Application.ProcessMessages;
  end;
  if aborted then begin
     req.FreeOnTerminate:=true;
     req.http.Abort;
     req.http.Sock.AbortSocket;
  end
  else
     result:=true;
end;

{ THTTPthread }

constructor THTTPthread.Create;
begin
  inherited Create(True);
  FreeOnTerminate:=False;
  Furl:='';
  Fmethod:='';
  Fok:=False;
  Fhttp:=THTTPSend.Create;
  Fhttp.Sock.ConnectionTimeout:=5000;  // not too long if service is not available
  Fhttp.Timeout:=5000;
  Fhttp.UserAgent:='';
end;

destructor THTTPthread.Destroy;
begin
   Fhttp.Free;
   inherited Destroy;
end;

procedure THTTPthread.Execute;
begin
  if Assigned(FonStatus) then Fhttp.Sock.OnStatus:=httpstatus;
  Fok:=Fhttp.HTTPMethod(method, fURL);
end;

procedure THTTPthread.httpstatus(Sender: TObject; Reason: THookSocketReason; const Value: String);
begin
  FStatusReason:=Reason;
  FStatusValue:=Value;
  if Assigned(FonStatus) then Synchronize(sendstatus);
end;

procedure THTTPthread.sendstatus;
begin
  if Assigned(FonStatus) then FonStatus(self);
end;

end.
