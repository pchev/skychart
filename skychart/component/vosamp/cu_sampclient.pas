unit cu_sampclient;

{$mode objfpc}{$H+}

interface

uses cu_sampserver, ExtCtrls,
  Classes, SysUtils,FileUtil,HTTPSend, synautil, XMLRead, DOM, XMLUtils;

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
    FcoordpointAtsky: TcoordpointAtsky;
    FImageLoadFits: TImageLoadFits;
    FTableLoadVotable: TTableLoadVotable;
    FTableHighlightRow: TTableHighlightRow;
    FTableSelectRowlist: TTableSelectRowlist;
    FClientChange, FDisconnect: TNotifyEvent;
    Flistenport: integer;
    SampAsyncEvent:TSampAsyncEvent;
    SampAsyncP1,SampAsyncP2,SampAsyncP3: string;
    SampAsyncTimer: TTimer;
    aHTTP: THTTPSend;
    Doc: TXMLDocument;
    HttpServer:TTCPHttpDaemon;
    procedure SampAsyncTimerTimer(Sender: TObject);
    procedure StartHTTPServer;
    procedure StopHTTPServer;
    function FindNodeName(StartNode:TDOMNode; ANodeName: string): TDOMNode;
    function FindItem(StartNode:TDOMNode; ItemName: string): TDOMNode;
    function CheckResponse(response: TMemoryStream): boolean;
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
    function SampSubscribe:boolean;
    property LastErrorcode: integer read Ferrorcode;
    property LastError: string read Ferrortext;
    property Connected: boolean read Fconnected;
    property HubUrl: string read samp_hub_xmlrpc_url;
    property ListenPort : integer read Flistenport;
    property Clients: Tstringlist read FClients;
    property ClientNames: Tstringlist read FClientNames;
    property ClientDesc: Tstringlist read FClientDesc;
    property ClientSubscriptions: TSubscriptionsList read FClientSubscriptions;
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
  SampAsyncTimer:=TTimer.Create(nil);
  SampAsyncTimer.Enabled:=false;
  SampAsyncTimer.Interval:=500;
  SampAsyncTimer.OnTimer:=@SampAsyncTimerTimer;
  StartHTTPServer;
end;

Destructor TSampClient.Destroy;
begin
  aHTTP.Free;
  FClients.Free;
  FClientNames.Free;
  FClientDesc.Free;
  SampAsyncTimer.Free;
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

function TSampClient.doRpcCall(p:string):boolean;
begin
  aHTTP.Clear;
  WriteStrToStream(aHTTP.Document, p);
  aHTTP.MimeType := 'application/xml';
  aHTTP.HTTPMethod('POST', samp_hub_xmlrpc_url);
  result:=CheckResponse(aHTTP.Document);
end;

function TSampClient.SampReply(mid:string;map:Tmap):boolean;
var i: integer;
    cmd: string;
begin
  cmd:='<methodCall>'+
           '<methodName>samp.hub.reply</methodName>'+
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
  result:=doRpcCall('<methodCall>'+
             '<methodName>'+m+'</methodName>'+
             '<params>'+
                '<param><value>'+p+'</value></param>'+
             '</params>'+
             '</methodCall>');
end;

function TSampClient.SampCall(m,p1,p2: string):boolean;overload;
begin
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

function TSampClient.FindItem(StartNode:TDOMNode; ItemName: string): TDOMNode;
var tmpNode : TDOMNode;
    chilNodes : TDOMNodeList;
    i: integer;
    buf:string;
begin
 result:=nil;
 if StartNode<>nil then begin
   if StartNode.NodeName=ItemName then tmpNode:=StartNode
      else tmpNode:=StartNode.FindNode(ItemName);
   if (tmpNode=nil)and(StartNode.HasChildNodes) then begin
      chilNodes:=StartNode.ChildNodes;
      for i := 0 to chilNodes.Count-1 do begin
          tmpNode:=FindItem(chilNodes[i],ItemName);
          if tmpNode<>nil then break;
      end;
   end;
   result:=tmpNode;
 end;
end;

function TSampClient.FindNodeName(StartNode:TDOMNode; ANodeName: string): TDOMNode;
var tmpNode : TDOMNode;
    chilNodes : TDOMNodeList;
    i: integer;

    function FindNode1(ScopeObject:TDOMNode; ANodeName: string): TDOMNode;
    var
      memberNode, tmpNode : TDOMNode;
      i : Integer;
      chilNodes : TDOMNodeList;
      nodeFound : Boolean;
    const
      sNAME = 'name';
      sVALUE = 'value';
    begin
      Result := nil;
      if (ScopeObject<>nil)and(ScopeObject.HasChildNodes()) then begin
        nodeFound := False;
        memberNode := ScopeObject.FirstChild;
        while ( not nodeFound ) and ( memberNode <> nil ) do begin
          if memberNode.HasChildNodes() then begin
            chilNodes := memberNode.ChildNodes;
            for i := 0 to chilNodes.Count-1 do begin
              tmpNode := chilNodes.Item[i];
              if AnsiSameText(sNAME,tmpNode.NodeName) and
                 ( tmpNode.FirstChild <> nil ) and
                 AnsiSameText(ANodeName,tmpNode.FirstChild.NodeValue)
              then begin
                nodeFound := True;
                Break;
              end;
            end;
            if nodeFound then begin
              tmpNode := memberNode.FindNode(sVALUE);
              if ( tmpNode <> nil ) and ( tmpNode.FirstChild <> nil ) then begin
                Result := tmpNode.FirstChild;
                Break;
              end;
            end;
          end;
          memberNode := memberNode.NextSibling;
        end;
      end;
    end;

begin
 result:=nil;
 if StartNode<>nil then begin
   tmpNode:=FindNode1(StartNode,ANodeName);
   if (tmpNode=nil)and(StartNode.HasChildNodes) then begin
      chilNodes:=StartNode.ChildNodes;
      for i := 0 to chilNodes.Count-1 do begin
          tmpNode:=FindNodeName(chilNodes[i],ANodeName);
          if tmpNode<>nil then break;
      end;
   end;
   result:=tmpNode;
 end;
end;

function TSampClient.CheckResponse(response: TMemoryStream):boolean;
var node,pnode,fnode:TDOMNode;
begin
 result:=false;
 response.Position := 0;
 Doc.Free;
 ReadXMLFile(Doc, response);
   node:=FindItem(Doc,'methodResponse');
   if node<>nil then begin
      pnode:=FindItem(node,'params');
      fnode:=FindItem(node,'fault');
   end;
   if pnode<>nil then begin
     Ferrorcode:=0;
     Ferrortext:='';
     result:=true;
   end else begin
     Ferrorcode:=1;
     Ferrortext:='Unknow error';
     if fnode<>nil then begin
       node:=FindNodeName(fnode,'faultCode');
       if node<>nil then Ferrorcode:=strtointdef(node.TextContent,1);
       node:=FindNodeName(fnode,'faultString');
       if node<>nil then Ferrortext:=node.TextContent;
     end;
   end;
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
var node:TDOMNode;
begin
 result:=false;
 if SampCall('samp.hub.register',samp_secret) then
 begin
   node:=FindNodeName(doc.FirstChild,'samp.private-key');
   if node<> nil then begin
     samp_private_key:=node.TextContent;
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
var node:TDOMNode;
    buf:string;
    i: integer;
begin
  FClients.Clear;
  FClientNames.Clear;
  FClientDesc.Clear;
  setlength(FClientSubscriptions,0);
  result:=SampCall('samp.hub.getRegisteredClients',samp_private_key);
  if result then begin
    node:=FindItem(doc,'methodResponse');
    if node<>nil then node:=FindItem(node,'params');
    if node<>nil then node:=FindItem(node,'array');
    if node<>nil then node:=FindItem(node,'value');
    while node<>nil do begin
       FClients.Add(node.TextContent);
       node:=node.NextSibling;
    end;
  end;
  setlength(FClientSubscriptions,FClients.Count);
  if FClients.Count>0 then for i:=0 to FClients.Count-1 do begin
     SampCall('samp.hub.getMetadata',samp_private_key,FClients[i]);
     node:=FindNodeName(doc.FirstChild,'samp.name');
     if node=nil then buf:=''
        else buf:=node.TextContent;
     FClientNames.Add(buf);
     node:=FindNodeName(doc.FirstChild,'samp.description.text');
     if node=nil then buf:=''
        else buf:=node.TextContent;
     FClientDesc.Add(buf);
     FClientSubscriptions[i]:=[];
     SampCall('samp.hub.getSubscriptions',samp_private_key,FClients[i]);
     node:=FindNodeName(doc.FirstChild,'coord.pointAt.sky');
     if node<>nil then FClientSubscriptions[i]:=FClientSubscriptions[i]+[coord_pointAt_sky];
     node:=FindNodeName(doc.FirstChild,'table.load.votable');
     if node<>nil then FClientSubscriptions[i]:=FClientSubscriptions[i]+[table_load_votable];
     node:=FindNodeName(doc.FirstChild,'image.load.fits');
     if node<>nil then FClientSubscriptions[i]:=FClientSubscriptions[i]+[image_load_fits];
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

function TSampClient.SampSubscribe:boolean;
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
    map[i].name:='coord.pointAt.sky';
    map[i].value:='<struct></struct>';
    inc(i);
    map[i].name:='image.load.fits';
    map[i].value:='<struct></struct>';
    inc(i);
    map[i].name:='table.load.votable';
    map[i].value:='<struct></struct>';
    inc(i);
    map[i].name:='table.highlight.row';
    map[i].value:='<struct></struct>';
    inc(i);
    map[i].name:='table.select.rowList';
    map[i].value:='<struct></struct>';
    inc(i);
    SetLength(map,i);
    result:=SampCall('samp.hub.declareSubscriptions',samp_private_key,map);
    if Assigned(FClientChange) then FClientChange(self);
  end;
end;


function TSampClient.SampNotification(data:TMemoryStream):boolean;
var NotifyDoc: TXMLDocument;
    node,pnode: TDOMNode;
    cmd,mtype,p1,p2,p3: string;
    plist: Tstringlist;
    key,sender_id,msg_id: string;
    map: Tmap;
begin
 result:=false;
 sender_id:=''; msg_id:='';
 data.Position := 0;
 ReadXMLFile(NotifyDoc, data);
 node:=FindItem(NotifyDoc,'methodName');
 if node<>nil then cmd:=node.TextContent;
 if cmd='samp.client.receiveCall' then begin
    node:=FindItem(NotifyDoc,'param');
    key:=node.TextContent;
    node:=node.NextSibling;
    sender_id:=node.TextContent;
    node:=node.NextSibling;
    msg_id:=node.TextContent;
 end;
 if (cmd='samp.client.receiveNotification')or(cmd='samp.client.receiveCall') then begin
    node:=FindNodeName(NotifyDoc.FirstChild,'samp.mtype');
    if node<>nil then begin
       mtype:=node.TextContent;
       pnode:=FindNodeName(NotifyDoc.FirstChild,'samp.params');
       if mtype='coord.pointAt.sky' then begin
          node:=FindNodeName(pnode,'ra');
          if node<>nil then p1:=node.TextContent;
          node:=FindNodeName(pnode,'dec');
          if node<>nil then p2:=node.TextContent;
          if Assigned(FcoordpointAtsky) then FcoordpointAtsky(StrToFloatDef(p1,0),StrToFloatDef(p2,0));
          result:=true;
       end else if mtype='image.load.fits' then begin
         node:=FindNodeName(pnode,'name');
         if node<>nil then SampAsyncP1:=node.TextContent;
         node:=FindNodeName(pnode,'image-id');
         if node<>nil then SampAsyncP2:=node.TextContent;
         node:=FindNodeName(pnode,'url');
         if node<>nil then SampAsyncP3:=node.TextContent;
         SampAsyncEvent:=ImageLoadFits;
         SampAsyncTimer.Enabled:=false;
         SampAsyncTimer.Enabled:=true;
         result:=true;
       end else if mtype='table.load.votable' then begin
         node:=FindNodeName(pnode,'name');
         if node<>nil then SampAsyncP1:=node.TextContent;
         node:=FindNodeName(pnode,'table-id');
         if node<>nil then SampAsyncP2:=node.TextContent;
         node:=FindNodeName(pnode,'url');
         if node<>nil then SampAsyncP3:=node.TextContent;
         SampAsyncEvent:=TableLoadVoTable;
         SampAsyncTimer.Enabled:=false;
         SampAsyncTimer.Enabled:=true;
         result:=true;
       end else if mtype='table.highlight.row' then begin
         node:=FindNodeName(pnode,'table-id');
         if node<>nil then p1:=node.TextContent;
         node:=FindNodeName(pnode,'url');
         if node<>nil then p2:=node.TextContent;
         node:=FindNodeName(pnode,'row');
         if node<>nil then p3:=node.TextContent;
         if Assigned(FTableHighlightRow) then FTableHighlightRow(p1,p2,p3);
         result:=true;
       end else if mtype='table.select.rowList' then begin
         plist:=TStringList.Create;
         node:=FindNodeName(pnode,'table-id');
         if node<>nil then p1:=node.TextContent;
         node:=FindNodeName(pnode,'url');
         if node<>nil then p2:=node.TextContent;
         node:=FindNodeName(pnode,'row-list');
         if node<>nil then node:=FindItem(node,'array');
         if node<>nil then node:=FindItem(node,'value');
          while node<>nil do begin
            p3:=node.FirstChild.NodeValue;
            plist.Add(p3);
            node:=node.NextSibling;
          end;
         if Assigned(FTableSelectRowlist) then FTableSelectRowlist(p1,p2,plist);
         plist.Free;
         result:=true;
       end else if mtype='samp.hub.event.shutdown' then begin
         SampHubDisconnect;
         result:=true;
       end else if mtype='samp.hub.disconnect' then begin
         SampHubDisconnect;
         result:=true;
       end else if mtype='samp.hub.event.register' then begin
         SampAsyncEvent:=ClientChange;
         SampAsyncTimer.Enabled:=false;
         SampAsyncTimer.Enabled:=true;
         result:=true;
       end else if mtype='samp.hub.event.unregister' then begin
         SampAsyncEvent:=ClientChange;
         SampAsyncTimer.Enabled:=false;
         SampAsyncTimer.Enabled:=true;
         result:=true;
       end else if mtype='samp.hub.event.metadata' then begin
         SampAsyncEvent:=ClientChange;
         SampAsyncTimer.Enabled:=false;
         SampAsyncTimer.Enabled:=true;
         result:=true;
       end else if mtype='samp.app.ping' then begin
         result:=true;
       end;
    end;
 end;
 if (cmd='samp.client.receiveCall')and(msg_id<>'') then begin
    SetLength(map,2);
    map[0].name:='samp.status';
    map[0].value:='samp.ok';
    map[1].name:='samp.result';
    map[1].value:='<struct></struct>';
    SampReply(msg_id,map);
 end;
 NotifyDoc.Free;
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

end.

