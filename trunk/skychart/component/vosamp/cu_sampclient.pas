unit cu_sampclient;

{$mode objfpc}{$H+}

interface

uses cu_sampserver, ExtCtrls, LibXmlParser, LibXmlComps, Math,
  Classes, SysUtils,FileUtil,HTTPSend, synautil;

type

Tmapvalue = record name,value:string end ;
Tmap = array of Tmapvalue;
Subscription = (coord_pointAt_sky,table_load_votable,image_load_fits);
Subscriptions = set of Subscription;
TSubscriptionsList = array of Subscriptions;
TSampAsyncEvent = (ClientChange,TableLoadVoTable,ImageLoadFits);
TcoordpointAtsky = procedure(ra,dec:double) of object;
TImageLoadFits = procedure(image_name,image_id,url:string) of object;
TTableLoadVotable = procedure(table_name,table_id,url:string) of object;
TTableHighlightRow = procedure(table_id,url,row:string) of object;
TTableSelectRowlist = procedure(table_id,url:string;rowlist:Tstringlist) of object;

TSampClient = class(TObject)
  private
    samp_secret,
    samp_hub_xmlrpc_url,
    samp_private_key,
    samp_profile_version: string;
    Fconnected: boolean;
    Ferrorcode: integer;
    Ferrortext: string;
    FClients,FClientNames,FClientDesc: Tstringlist;
    FClientSubscriptions: TSubscriptionsList;
    FClientSubscriptionsPos: integer;
    FcoordpointAtsky: TcoordpointAtsky;
    FImageLoadFits: TImageLoadFits;
    FTableLoadVotable: TTableLoadVotable;
    FTableHighlightRow: TTableHighlightRow;
    FTableSelectRowlist: TTableSelectRowlist;
    FClientChange, FDisconnect: TNotifyEvent;
    Flistenport: integer;
    FLockTableSelectRow: boolean;
    SampAsyncEvent:TSampAsyncEvent;
    SampAsyncP1,SampAsyncP2,SampAsyncP3: string;
    methodResponse,xfault,xparams,xparam,xarray,xdata,xarrayvalue,xmember,xparamn,xparamv: boolean;
    xparamname,xmethodname:string;
    methodCall,cmethodn,creceiveCall,creceiveNotification,cparams,cparam,cparamdata,cvalue,cmember,cparamn,cparamv,cparamarray : boolean;
    cmethodName,key,sender_id,msg_id,cparamname,cmtype,cname,ctable_id,cimage_id,curl,crow,cra,cdec: string;
    crowlist:TStringList;
    cparampos: integer;
    SampAsyncTimer: TTimer;
    aHTTP: THTTPSend;
    XmlScanner: TEasyXmlScanner;
    HttpServer:TTCPHttpDaemon;
    procedure InitScanner;
    procedure XmlStartTag(Sender: TObject; TagName: String; Attributes: TAttrList);
    procedure XmlContent(Sender: TObject; Content: String);
    procedure XmlEndTag(Sender: TObject; TagName: String);
    procedure XmlLoadExternal(Sender : TObject; SystemId, PublicId, NotationId : STRING; VAR Result : TXmlParser);
    procedure SampAsyncTimerTimer(Sender: TObject);
    procedure StartHTTPServer;
    procedure StopHTTPServer;
    function doRpcCall(p: string):boolean;
    function SampCall(m,p: string):boolean;overload;
    function SampCall(m,p1,p2: string):boolean;overload;
    function SampCall(m,p: string; map:Tmap):boolean;overload;
    function SampCall(m,p,mt: string; map:Tmap):boolean;overload;
    function SampCall(m,p1,p2,mt: string; map:Tmap):boolean;overload;
    function SampReply(mid:string;map:Tmap):boolean;
    function SampNotification(data:TMemoryStream):boolean;
  public
    constructor Create ;
    destructor Destroy; override;
    function SampReadProfile:boolean;
    function SampHubConnect:boolean;
    function SampHubDisconnect:boolean;
    function SampHubSendMetadata:boolean;
    function SampHubGetClientList:boolean;
    function SampSendCoord(client:string;ra,de: double):boolean;
    function SampSendVoTable(client,tname,table_id,url:string):boolean;
    function SampSelectRow(client,tableid,url,row: string):boolean;
    function SampSendImageFits(client,imgname,imgid,url:string):boolean;
    function SampSubscribe(SubscribeCoord,SubscribeImage,SubscribeTable: boolean):boolean;
    property LastErrorcode: integer read Ferrorcode;
    property LastError: string read Ferrortext;
    property Connected: boolean read Fconnected;
    property HubUrl: string read samp_hub_xmlrpc_url;
    property ListenPort : integer read Flistenport;
    property Clients: Tstringlist read FClients;
    property ClientNames: Tstringlist read FClientNames;
    property ClientDesc: Tstringlist read FClientDesc;
    property ClientSubscriptions: TSubscriptionsList read FClientSubscriptions;
    property LockTableSelectRow: boolean read FLockTableSelectRow write FLockTableSelectRow;
    property onClientChange: TNotifyEvent read FClientChange write FClientChange;
    property onDisconnect: TNotifyEvent read FDisconnect write FDisconnect;
    property oncoordpointAtsky: TcoordpointAtsky read FcoordpointAtsky write FcoordpointAtsky;
    property onImageLoadFits: TImageLoadFits read FImageLoadFits write FImageLoadFits;
    property onTableLoadVotable: TTableLoadVotable read FTableLoadVotable write FTableLoadVotable;
    property onTableHighlightRow: TTableHighlightRow read FTableHighlightRow write FTableHighlightRow;
    property onTableSelectRowlist: TTableSelectRowlist read FTableSelectRowlist write FTableSelectRowlist;
  end;

implementation

const
  {$ifdef mswindows}
    Default_SAMP_HUB = '.samp';
  {$else}
    Default_SAMP_HUB = '~/.samp';
  {$endif}
  f7 = '0.0000000';

constructor TSampClient.Create ;
begin
  inherited create;
  Fconnected:=false;
  samp_hub_xmlrpc_url:='';
  Ferrorcode:=0;
  Ferrortext:='';
  aHTTP:=THTTPSend.Create;
  FClients:=Tstringlist.Create;
  FClientNames:=Tstringlist.Create;
  FClientDesc:=Tstringlist.Create;
  crowlist:=TStringList.Create;
  SampAsyncTimer:=TTimer.Create(nil);
  SampAsyncTimer.Enabled:=false;
  SampAsyncTimer.Interval:=500;
  SampAsyncTimer.OnTimer:=@SampAsyncTimerTimer;
  XmlScanner:=TEasyXmlScanner.Create(nil);
  XmlScanner.OnStartTag:=@XmlStartTag;
  XmlScanner.OnContent:=@XmlContent;
  XmlScanner.OnEndTag:=@XmlEndTag;
  XmlScanner.OnLoadExternal:=@XmlLoadExternal;
  StartHTTPServer;
end;

Destructor TSampClient.Destroy;
begin
  aHTTP.Free;
  FClients.Free;
  FClientNames.Free;
  FClientDesc.Free;
  crowlist.Free;
  SampAsyncTimer.Free;
  XmlScanner.Free;
  inherited Destroy;
end;

procedure TSampClient.StartHTTPServer;
begin
 HttpServer:=TTCPHttpDaemon.create;
 HttpServer.onProcessNotification:=@SampNotification;
end;

procedure TSampClient.StopHTTPServer;
begin
 HttpServer.Terminate;
 sleep(500);
end;

procedure TSampClient.InitScanner;
begin
methodCall:=false; cmethodn:=false; creceiveCall:=false; creceiveNotification:=false; cparams:=false;
cparam:=false; cparamdata:=false; cvalue:=false; cmember:=false; cparamn:=false; cparamv:=false; cparamarray:=false;
methodResponse:=false; xfault:=false; xparams:=false; xarray:=false; xdata:=false; xarrayvalue:=false;
xparam:=false; xmember:=false; xparamn:=false; xparamv:=false;
xparamname:=''; SampAsyncP1:=''; SampAsyncP2:=''; SampAsyncP3:='';
cmethodName:=''; key:=''; sender_id:=''; msg_id:=''; cparamname:=''; cmtype:=''; cname:='';
ctable_id:=''; cimage_id:=''; curl:=''; crow:=''; cra:=''; cdec:='';
crowlist.Clear;
cparampos:=0;
end;

function TSampClient.doRpcCall(p:string):boolean;
var buf:array [0..8192] of char;
    i: integer;
begin
  aHTTP.Clear;
  WriteStrToStream(aHTTP.Document, p);
  aHTTP.MimeType := 'application/xml';
  aHTTP.HTTPMethod('POST', samp_hub_xmlrpc_url);
  InitScanner;
  i:=min(aHTTP.Document.Size,SizeOf(buf));
  FillByte(buf,SizeOf(buf),0);
  aHTTP.Document.Position:=0;
  aHTTP.Document.Read(buf,i);
  XmlScanner.LoadFromBuffer(@buf);
  XmlScanner.Execute;
  result:=(Ferrorcode=0);
end;

function TSampClient.SampReply(mid:string;map:Tmap):boolean;
var i: integer;
    cmd: string;
begin
  xmethodname:='samp.hub.reply';
  cmd:='<methodCall>'+
           '<methodName>'+xmethodname+'</methodName>'+
           '<params>'+
              '<param><value>'+samp_private_key+'</value></param>'+
              '<param><value>'+mid+'</value></param>'+
              '<param><value><struct>';
for i:=0 to Length(map)-1 do begin
    cmd:=cmd+  '<member>'+
                 '<name>'+map[i].name+'</name>'+
                 '<value>'+map[i].value+'</value>'+
               '</member>';
end;
cmd:=cmd+  '</struct></value></param>'+
         '</params>'+
     '</methodCall>';
result:=doRpcCall(cmd);
end;

function TSampClient.SampCall(m,p: string):boolean;overload;
begin
  xmethodname:=m;
  result:=doRpcCall('<methodCall>'+
             '<methodName>'+m+'</methodName>'+
             '<params>'+
                '<param><value>'+p+'</value></param>'+
             '</params>'+
             '</methodCall>');
end;

function TSampClient.SampCall(m,p1,p2: string):boolean;overload;
begin
  xmethodname:=m;
  result:=doRpcCall('<methodCall>'+
             '<methodName>'+m+'</methodName>'+
             '<params>'+
                '<param><value>'+p1+'</value></param>'+
                '<param><value>'+p2+'</value></param>'+
             '</params>'+
             '</methodCall>');
end;

function TSampClient.SampCall(m,p: string; map:Tmap):boolean;overload;
var i: integer;
    cmd: string;
begin
  xmethodname:=m;
  cmd:='<methodCall>'+
             '<methodName>'+m+'</methodName>'+
             '<params>'+
                '<param><value>'+p+'</value></param>'+
                '<param><value><struct>';
  for i:=0 to Length(map)-1 do begin
      cmd:=cmd+  '<member>'+
                   '<name>'+map[i].name+'</name>'+
                   '<value>'+map[i].value+'</value>'+
                 '</member>';
  end;
  cmd:=cmd+    '</struct></value></param>'+
           '</params>'+
       '</methodCall>';
  result:=doRpcCall(cmd);
end;

function TSampClient.SampCall(m,p,mt: string; map:Tmap):boolean;overload;
var i: integer;
    cmd: string;
begin
  xmethodname:=m;
  cmd:='<methodCall>'+
             '<methodName>'+m+'</methodName>'+
             '<params>'+
                '<param><value>'+p+'</value></param>'+
                '<param><value><struct>'+
                '<member>'+
                   '<name>samp.mtype</name>'+
                   '<value>'+mt+'</value>'+
                '</member>'+
                '<member>'+
                   '<name>samp.params</name>'+
                   '<value><struct>';
  for i:=0 to Length(map)-1 do begin
      cmd:=cmd+  '<member>'+
                   '<name>'+map[i].name+'</name>'+
                   '<value>'+map[i].value+'</value>'+
                 '</member>';
  end;
  cmd:=cmd+     '</struct></value>'+
              '</member>'+
             '</struct></value></param>'+
           '</params>'+
       '</methodCall>';
  result:=doRpcCall(cmd);
end;

function TSampClient.SampCall(m,p1,p2,mt: string; map:Tmap):boolean;overload;
var i: integer;
    cmd: string;
begin
  xmethodname:=m;
  cmd:='<methodCall>'+
             '<methodName>'+m+'</methodName>'+
             '<params>'+
                '<param><value>'+p1+'</value></param>'+
                '<param><value>'+p2+'</value></param>'+
                '<param><value><struct>'+
                '<member>'+
                   '<name>samp.mtype</name>'+
                   '<value>'+mt+'</value>'+
                '</member>'+
                '<member>'+
                   '<name>samp.params</name>'+
                   '<value><struct>';
  for i:=0 to Length(map)-1 do begin
      cmd:=cmd+  '<member>'+
                   '<name>'+map[i].name+'</name>'+
                   '<value>'+map[i].value+'</value>'+
                 '</member>';
  end;
  cmd:=cmd+     '</struct></value>'+
              '</member>'+
             '</struct></value></param>'+
           '</params>'+
       '</methodCall>';
  result:=doRpcCall(cmd);
end;

function TSampClient.SampReadProfile:boolean;
var lockfile,buf,k,v: string;
    str:TStringList;
    i,p: integer;
begin
 result:=false;
 samp_hub_xmlrpc_url:='';
 samp_secret:='';
 samp_profile_version:='';
 str:=TStringList.Create;
 lockfile:=GetEnvironmentVariableUTF8('SAMP_HUB');
 if copy(lockfile,1,12)='std-lockurl:' then begin
    p:=pos('file://',lockfile);
    if p>0 then Delete(lockfile,1,p+6)
           else begin
            Ferrorcode:=1;
            Ferrortext:='Unsupported SAMP hub profile. Must be a File URL: '+lockfile;
            exit;
           end;
 end;
 if lockfile='' then begin
  {$ifdef mswindows}
    lockfile:=GetEnvironmentVariableUTF8('USERPROFILE')+'\'+Default_SAMP_HUB;
  {$else}
    lockfile:=ExpandFileNameUTF8(Default_SAMP_HUB);
  {$endif}
 end;
 if FileExistsUTF8(lockfile) then begin
    str.LoadFromFile(lockfile);
    for i:=0 to str.Count-1 do begin
       buf:=trim(str[i]);
       p:=pos('=',buf);
       if p>0 then begin
          k:=copy(buf,1,p-1);
          v:=buf;
          delete(v,1,p);
          if k='samp.hub.xmlrpc.url' then samp_hub_xmlrpc_url:=v;
          if k='samp.secret' then samp_secret:=v;
          if k='samp.profile.version' then samp_profile_version:=v;
       end;
    end;
    result:=(samp_hub_xmlrpc_url<>'')and(samp_secret<>'')and(samp_profile_version<>'');
    if result then begin
      Ferrorcode:=0;
      Ferrortext:='';
    end else begin
       Ferrorcode:=1;
       Ferrortext:='SAMP hub profile '+lockfile+' found, but it is missing a required value.';
    end;
 end else begin
    Ferrorcode:=1;
    Ferrortext:='No SAMP hub profile found, no hub is running.';
 end;
 str.Free;
end;

function TSampClient.SampHubConnect:boolean;
begin
 result:=false;
 samp_private_key:='';
 if SampCall('samp.hub.register',samp_secret) then begin
    if samp_private_key<>'' then begin
      Fconnected:=true;
      result:=true;
    end;
 end;
end;

function TSampClient.SampHubDisconnect:boolean;
begin
  result:=SampCall('samp.hub.unregister',samp_private_key);
  Fconnected:=false;
  StopHTTPServer;
  if assigned(FDisconnect) then FDisconnect(self);
end;

function TSampClient.SampHubSendMetadata:boolean;
var map:Tmap;
begin
  SetLength(map,4);
  map[0].name:='samp.name';
  map[0].value:='skychart';
  map[1].name:='samp.description.text';
  map[1].value:='Cartes du Ciel - Skychart planetarium';
  map[2].name:='samp.icon.url';
  map[2].value:='http://ap-i.net/skychart/ciel.png';
  map[3].name:='samp.documentation.url';
  map[3].value:='http://ap-i.net/skychart/en/documentation/start';
  result:=SampCall('samp.hub.declareMetadata',samp_private_key,map);
end;

function TSampClient.SampHubGetClientList:boolean;
var i,j: integer;
begin
  FClients.Clear;
  FClientNames.Clear;
  FClientDesc.Clear;
  setlength(FClientSubscriptions,0);
  result:=SampCall('samp.hub.getRegisteredClients',samp_private_key);
  setlength(FClientSubscriptions,FClients.Count);
  if FClients.Count>0 then for i:=0 to FClients.Count-1 do begin
     SampCall('samp.hub.getMetadata',samp_private_key,FClients[i]);
     FClientSubscriptions[i]:=[];
     FClientSubscriptionsPos:=i;
     SampCall('samp.hub.getSubscriptions',samp_private_key,FClients[i]);
  end;
end;

function TSampClient.SampSendCoord(client:string; ra,de:double):boolean;
var map:Tmap;
begin
  SetLength(map,2);
  map[0].name:='ra';
  map[0].value:=FormatFloat(f7,ra);
  map[1].name:='dec';
  map[1].value:=FormatFloat(f7,de);
  if client='' then
     result:=SampCall('samp.hub.notifyAll',samp_private_key,'coord.pointAt.sky',map)
  else
     result:=SampCall('samp.hub.notify',samp_private_key,client,'coord.pointAt.sky',map);
end;

function TSampClient.SampSendVoTable(client,tname,table_id,url:string):boolean;
var map:Tmap;
begin
  SetLength(map,3);
  map[0].name:='name';
  map[0].value:=tname;
  map[1].name:='table-id';
  map[1].value:=table_id;
  map[2].name:='url';
  map[2].value:=url;
  if client='' then
     result:=SampCall('samp.hub.notifyAll',samp_private_key,'table.load.votable',map)
  else
     result:=SampCall('samp.hub.notify',samp_private_key,client,'table.load.votable',map);
end;

function TSampClient.SampSelectRow(client,tableid,url,row: string):boolean;
var map:Tmap;
begin
  // replaces general entity
  tableid:=StringReplace(tableid,'&','&amp;',[rfReplaceAll]);
  tableid:=StringReplace(tableid,'<','&lt;',[rfReplaceAll]);
  tableid:=StringReplace(tableid,'>','&gt;',[rfReplaceAll]);
  tableid:=StringReplace(tableid,'''','&apos;',[rfReplaceAll]);
  tableid:=StringReplace(tableid,'"','&quote;',[rfReplaceAll]);
  SetLength(map,2);
  map[0].name:='table-id';
  map[0].value:=tableid;
  map[1].name:='row-list';
  map[1].value:='<array><data><value>'+row+'</value></data></array>';
  if client='' then
     result:=SampCall('samp.hub.notifyAll',samp_private_key,'table.select.rowList',map)
  else
     result:=SampCall('samp.hub.notify',samp_private_key,client,'table.select.rowList',map);
end;

function TSampClient.SampSendImageFits(client,imgname,imgid,url:string):boolean;
var map:Tmap;
begin
  SetLength(map,3);
  map[0].name:='name';
  map[0].value:=imgname;
  map[1].name:='image-id';
  map[1].value:=imgid;
  map[2].name:='url';
  map[2].value:=url;
  if client='' then
     result:=SampCall('samp.hub.notifyAll',samp_private_key,'image.load.fits',map)
  else
     result:=SampCall('samp.hub.notify',samp_private_key,client,'image.load.fits',map);
end;

function TSampClient.SampSubscribe(SubscribeCoord,SubscribeImage,SubscribeTable: boolean):boolean;
var map:Tmap;
    i: integer;
begin
  Flistenport:=HttpServer.ListenPort;
  result:=SampCall('samp.hub.setXmlrpcCallback',samp_private_key,'http://127.0.0.1:'+inttostr(HttpServer.ListenPort));
  if result then begin
    SetLength(map,20);
    i:=0;
    map[i].name:='samp.hub.event.shutdown';
    map[i].value:='<struct></struct>';
    inc(i);
    map[i].name:='samp.hub.disconnect';
    map[i].value:='<struct></struct>';
    inc(i);
    map[i].name:='samp.app.ping';
    map[i].value:='<struct></struct>';
    inc(i);
    map[i].name:='samp.hub.event.register';
    map[i].value:='<struct></struct>';
    inc(i);
    map[i].name:='samp.hub.event.unregister';
    map[i].value:='<struct></struct>';
    inc(i);
    map[i].name:='samp.hub.event.metadata';
    map[i].value:='<struct></struct>';
    inc(i);
    if SubscribeCoord then begin
      map[i].name:='coord.pointAt.sky';
      map[i].value:='<struct></struct>';
      inc(i);
    end;
    if SubscribeImage then begin
      map[i].name:='image.load.fits';
      map[i].value:='<struct></struct>';
      inc(i);
    end;
    if SubscribeTable then begin
      map[i].name:='table.load.votable';
      map[i].value:='<struct></struct>';
      inc(i);
      map[i].name:='table.highlight.row';
      map[i].value:='<struct></struct>';
      inc(i);
      map[i].name:='table.select.rowList';
      map[i].value:='<struct></struct>';
      inc(i);
    end;
    SetLength(map,i);
    result:=SampCall('samp.hub.declareSubscriptions',samp_private_key,map);
    if Assigned(FClientChange) then FClientChange(self);
  end;
end;

function TSampClient.SampNotification(data:TMemoryStream):boolean;
var buf:array [0..8192] of char;
    i: integer;
    map: Tmap;
begin
  InitScanner;
  i:=min(data.Size,SizeOf(buf));
  FillByte(buf,SizeOf(buf),0);
  data.Position:=0;
  data.Read(buf,i);
  XmlScanner.LoadFromBuffer(@buf);
  XmlScanner.Execute;
  result:=(Ferrorcode=0);
  if (cmethodName='samp.client.receiveNotification')or(cmethodName='samp.client.receiveCall') then begin
     if cmtype='coord.pointAt.sky' then begin
       if Assigned(FcoordpointAtsky) then FcoordpointAtsky(StrToFloatDef(cra,0),StrToFloatDef(cdec,0));
       result:=true;
     end
     else if cmtype='image.load.fits' then begin
       SampAsyncP1:=cname;
       SampAsyncP2:=cimage_id;
       SampAsyncP3:=curl;
       SampAsyncEvent:=ImageLoadFits;
       SampAsyncTimer.Enabled:=false;
       SampAsyncTimer.Enabled:=true;
       result:=true;
     end
     else if cmtype='table.load.votable' then begin
       SampAsyncP1:=cname;
       SampAsyncP2:=ctable_id;
       SampAsyncP3:=curl;
       SampAsyncEvent:=TableLoadVoTable;
       SampAsyncTimer.Enabled:=false;
       SampAsyncTimer.Enabled:=true;
       result:=true;
     end
     else if cmtype='table.highlight.row' then begin
       if Assigned(FTableHighlightRow) then FTableHighlightRow(ctable_id,curl,crow);
       result:=true;
     end
     else if cmtype='table.select.rowList' then begin
       if Assigned(FTableSelectRowlist) then FTableSelectRowlist(ctable_id,curl,crowlist);
       result:=true;
     end
     else if cmtype='samp.hub.event.shutdown' then begin
         SampHubDisconnect;
         result:=true;
     end
     else if cmtype='samp.hub.disconnect' then begin
         SampHubDisconnect;
         result:=true;
     end
     else if cmtype='samp.hub.event.register' then begin
         SampAsyncEvent:=ClientChange;
         SampAsyncTimer.Enabled:=false;
         SampAsyncTimer.Enabled:=true;
         result:=true;
     end
     else if cmtype='samp.hub.event.unregister' then begin
         SampAsyncEvent:=ClientChange;
         SampAsyncTimer.Enabled:=false;
         SampAsyncTimer.Enabled:=true;
         result:=true;
     end
     else if cmtype='samp.hub.event.metadata' then begin
         SampAsyncEvent:=ClientChange;
         SampAsyncTimer.Enabled:=false;
         SampAsyncTimer.Enabled:=true;
         result:=true;
     end
     else if cmtype='samp.app.ping' then begin
         result:=true;
     end;
end;
if (cmethodName='samp.client.receiveCall')and(msg_id<>'') then begin
  SetLength(map,2);
  map[0].name:='samp.status';
  map[0].value:='samp.ok';
  map[1].name:='samp.result';
  map[1].value:='<struct></struct>';
  SampReply(msg_id,map);
end;
end;

procedure TSampClient.SampAsyncTimerTimer(Sender: TObject);
begin
 SampAsyncTimer.Enabled:=false;
 case SampAsyncEvent of
    ClientChange     : if Assigned(FClientChange) then FClientChange(self);
    TableLoadVoTable : if Assigned(FTableLoadVotable) then FTableLoadVotable(SampAsyncP1,SampAsyncP2,SampAsyncP3);
    ImageLoadFits    : if Assigned(FImageLoadFits) then FImageLoadFits(SampAsyncP1,SampAsyncP2,SampAsyncP3);
 end;
end;


procedure TSampClient.XmlStartTag(Sender: TObject; TagName: String; Attributes: TAttrList);
var buf: string;
begin
if TagName='methodResponse' then methodResponse:=true
else if methodResponse and(TagName='params') then begin
  xparams:=true;
  Ferrorcode:=0;
  Ferrortext:='';
end
else if methodResponse and(TagName='fault') then begin
  xfault:=true;
  Ferrorcode:=0;
  Ferrortext:='Unknow error';
end
else if xparams and(TagName='param') then xparam:=true
else if (xparam or xfault) and(TagName='member') then xmember:=true
else if xmember and(TagName='name') then xparamn:=true
else if xmember and(TagName='value') then xparamv:=true
else if xparam and(TagName='array') then xarray:=true
else if xarray and(TagName='data') then xdata:=true
else if xdata and(TagName='value') then xarrayvalue:=true
else if TagName='methodCall' then methodCall:=true
else if methodCall and (TagName='methodName') then cmethodn:=true
else if methodCall and ((TagName='params')) then cparams:=true
else if cparams and(TagName='param') then begin
   cparam:=true;
   inc(cparampos);
   if creceiveCall and (cparampos>=4) then cparamdata:=true;
   if creceiveNotification and (cparampos>=3) then cparamdata:=true;
   end
else if cparam and (not cparamdata)and(TagName='value') then cvalue:=true
else if cparamdata and(TagName='member') then cmember:=true
else if cmember and(TagName='name') then cparamn:=true
else if cmember and(TagName='value') then cparamv:=true
else if cmember and cparamv and (TagName='array') then cparamarray:=true;
end;

procedure TSampClient.XmlContent(Sender: TObject; Content: String);
var buf: string;
begin
if xparamn then begin
  xparamname:=content;
  if xmethodname='samp.hub.getSubscriptions' then begin
         // value not used in samp 1.3
         if xparamname='coord.pointAt.sky' then FClientSubscriptions[FClientSubscriptionsPos]:=FClientSubscriptions[FClientSubscriptionsPos]+[coord_pointAt_sky];
         if xparamname='table.load.votable' then FClientSubscriptions[FClientSubscriptionsPos]:=FClientSubscriptions[FClientSubscriptionsPos]+[table_load_votable];
         if xparamname='image.load.fits' then FClientSubscriptions[FClientSubscriptionsPos]:=FClientSubscriptions[FClientSubscriptionsPos]+[image_load_fits];
  end;
end
else if xparamv then begin
  if xparamname='faultCode' then Ferrorcode:=StrToIntDef(Content,1)
  else if xparamname='faultString' then Ferrortext:=Content
  else if (xmethodname='samp.hub.register')and(xparamname='samp.private-key') then samp_private_key:=Content
  else if xmethodname='samp.hub.getMetadata' then begin
         if xparamname='samp.name' then FClientNames.Add(Content)
         else if xparamname='samp.description.text' then FClientDesc.Add(Content);
  end;
  end
else if xarrayvalue then begin
  if xmethodname='samp.hub.getRegisteredClients' then FClients.Add(Content);
  end
else if cmethodn then begin
  cmethodName:=Content;
  if cmethodName='samp.client.receiveCall' then creceiveCall:=true;
  if cmethodName='samp.client.receiveNotification' then creceiveNotification:=true;
  end
else if cvalue then begin
  if creceiveCall then begin
    case cparampos of
      1 : key:=Content;
      2 : sender_id:=Content;
      3 : msg_id:=Content;
    end;
  end
  else if creceiveNotification then begin
    case cparampos of
      1 : key:=Content;
      2 : sender_id:=Content;
    end;
  end
  end
else if cparamn then cparamname:=content
else if cparamv then begin
     if cparamarray then begin
       if cparamname='row-list' then crowlist.Add(content);
     end
     else begin
       if cparamname='samp.mtype' then cmtype:=content
       else if cparamname='name' then cname:=content
       else if cparamname='table-id' then ctable_id:=content
       else if cparamname='image-id' then cimage_id:=content
       else if cparamname='url' then curl:=content
       else if cparamname='ra' then cra:=content
       else if cparamname='dec' then cdec:=content
       else if cparamname='row' then crow:=content;
     end;
  end
end;

procedure TSampClient.XmlEndTag(Sender: TObject; TagName: String);
begin
if TagName='methodResponse' then methodResponse:=false
else if methodResponse and (TagName='fault') then xfault:=false
else if methodResponse and (TagName='params') then xparams:=false
else if methodResponse and (TagName='param') then xparam:=false
else if methodResponse and (TagName='array') then xarray:=false
else if methodResponse and (TagName='data') then xdata:=false
else if xdata and (TagName='value') then xarrayvalue:=false
else if methodResponse and (TagName='member') then xmember:=false
else if methodResponse and (TagName='name') then xparamn:=false
else if methodResponse and (TagName='value') then xparamv:=false
else if TagName='methodCall' then methodCall:=false
else if methodCall and (TagName='methodName') then cmethodn:=false
else if methodCall and ((TagName='params')) then cparams:=false
else if cparams and(TagName='param') then cparam:=false
else if cparam and(TagName='value') then cvalue:=false
else if cparamdata and(TagName='name') then cparamn:=false
else if cparamdata and(TagName='value') then cparamv:=false
else if cmember and cparamv and (TagName='array') then cparamarray:=false;
end;

procedure TSampClient.XmlLoadExternal(Sender : TObject; SystemId, PublicId, NotationId : STRING; VAR Result : TXmlParser);
// do not try to load external resources
begin
Result := TXmlParser.Create;
end;

end.

