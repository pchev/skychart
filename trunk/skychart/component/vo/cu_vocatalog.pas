unit cu_vocatalog;

{$MODE Delphi}

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
Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
}
{
 Virtual Observatory interface.
 Catalog resource list
}

interface

uses u_voconstant, httpsend, blcksock, LibXmlParser, LibXmlComps,
     Classes, SysUtils;


type
  ///////////////////////////////////////////////////////////////
  // List of available VO catalog
  ///////////////////////////////////////////////////////////////
  TVO_Catalogs = class(TComponent)
  private
    Fvo_source: Tvo_source;
    Fvo_type: Tvo_type;
    FListUrl,FLastErr,Fvopath: string;
    searchtxt: string;
    FCatList: Tstringlist;
    currentitem: integer;
    http: THTTPSend;
    XmlScanner: TEasyXmlScanner;
    votable,description,resource,info,tname,ArrayOfResource,aurl : boolean;
    catalog,catalog_desc,catalog_info,base_url,catalog_url : string;
    procedure XmlStartTag(Sender: TObject; TagName: String; Attributes: TAttrList);
    procedure XmlContent(Sender: TObject; Content: String);
    procedure XmlEndTag(Sender: TObject; TagName: String);
    procedure XmlEmptyTag(Sender: TObject; TagName: String; Attributes: TAttrList);
    procedure LoadCats;
    procedure GetCats;
    function  GetCatList:TstringList;
    procedure Set_source(value: Tvo_source);
  protected
    Fproxy,Fproxyport,Fproxyuser,Fproxypass : string;
    FSocksproxy,FSockstype : string;
    Sockreadcount, LastRead: integer;
    FDownloadFeedback: TDownloadFeedback;
    procedure httpstatus(Sender: TObject; Reason: THookSocketReason; const Value: String);
  public
    constructor Create(AOwner:TComponent); override;
    destructor  Destroy; override;
    function Search(txt: string; startpos:integer=0):integer;
    function SearchNext:integer;
    function ForceUpdate: boolean;
    procedure ClearCatlist;
    property CatList: TstringList read GetCatList;
    property LastErr: string read FlastErr;
  published
    property vo_source: Tvo_source read Fvo_source write Set_source;
    property vo_type: Tvo_type read Fvo_type;
    property ListUrl: string read FListUrl write FListUrl;
    property CachePath: string read Fvopath write Fvopath;
    property onDownloadFeedback: TDownloadFeedback read FDownloadFeedback write FDownloadFeedback;
    property HttpProxy : string read Fproxy  write Fproxy ;
    property HttpProxyPort : string read Fproxyport  write Fproxyport ;
    property HttpProxyUser : string read Fproxyuser  write Fproxyuser ;
    property HttpProxyPass : string read Fproxypass  write Fproxypass ;
    property SocksProxy : string read FSocksproxy  write FSocksproxy ;
    property SocksType : string read FSockstype  write FSockstype ;
  end;

implementation

Function Slash(nom : string) : string;
begin
result:=trim(nom);
if copy(result,length(nom),1)<>PathDelim then result:=result+PathDelim;
end;

Function fixurl(url:string):string;
begin
result:=trim(url);
if (copy(result,length(url),1)<>'&') and (copy(result,length(url),1)<>'?')
   then  begin
     if pos('?',result)>0 then
          result:=result+'&'
       else
          result:=result+'?';
end;
end;

///////////////////////////////////////////////////////////////////////
//   VO List of Catalogs
///////////////////////////////////////////////////////////////////////

constructor TVO_Catalogs.Create(AOwner:TComponent);
begin
 inherited Create(AOwner);
 http := THTTPSend.Create;
 XmlScanner:=TEasyXmlScanner.Create(nil);
 XmlScanner.OnStartTag:=XmlStartTag;
 XmlScanner.OnContent:=XmlContent;
 XmlScanner.OnEndTag:=XmlEndTag;
 XmlScanner.OnEmptyTag:=XmlEmptyTag;
 FCatList:=Tstringlist.create;
 Fvo_source:=Vizier;
 Fvo_type:=vo_types[Fvo_source];
 FListUrl:=vo_url[Fvo_source,1,1];
 Fvopath:='.';
 Fproxy:='';
 FSocksproxy:='';
end;

destructor TVO_Catalogs.Destroy;
begin
 http.Free;
 XmlScanner.Free;
 FCatList.Free;
 inherited destroy;
end;

procedure TVO_Catalogs.Set_source(value: Tvo_source);
begin
FListUrl:=vo_url[value,1,1];
Fvo_type:=vo_types[value];
Fvo_source:=value;
end;

function TVO_Catalogs.GetCatList:TstringList;
begin
if FCatList.Count=0 then begin
   if fileexists(slash(Fvopath)+vo_list[Fvo_source]) then
      LoadCats
   else
      GetCats;
end;
result:=FCatList;
end;

procedure TVO_Catalogs.ClearCatlist;
begin
FCatList.Clear;
end;

function TVO_Catalogs.ForceUpdate: boolean;
begin
GetCats;
result:=(FLastErr='');
end;

procedure TVO_Catalogs.LoadCats;
var i : integer;
begin
FCatList.Clear;
i:=pos('?',FListUrl);
base_url:=copy(FListUrl,1,i)+'-source=';
XmlScanner.LoadFromFile(slash(Fvopath)+vo_list[Fvo_source]);
XmlScanner.Execute;
end;

procedure TVO_Catalogs.GetCats;
var url:string;
begin
url:=FListUrl;
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
       http.Document.SaveToFile(slash(Fvopath)+vo_list[Fvo_source]);
       FLastErr:='';
       if Assigned(FDownloadFeedback) then FDownloadFeedback('Download completed.');
       LoadCats;
     end
else begin
   FLastErr:='Error: '+inttostr(http.ResultCode)+' '+http.ResultString;
   if Assigned(FDownloadFeedback) then FDownloadFeedback(FLastErr);
end;
http.Clear;
end;

procedure TVO_Catalogs.httpstatus(Sender: TObject; Reason: THookSocketReason; const Value: String);
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
if (txt>'')and Assigned(FDownloadFeedback) then FDownloadFeedback(txt);
end;

function TVO_Catalogs.Search(txt: string; startpos:integer=0):integer;
var i: integer;
begin
result:=-1;
searchtxt:=uppercase(txt);
for i:=startpos to FCatList.count-1 do begin
  if pos(searchtxt,uppercase(FCatList[i]))>0 then begin
    currentitem:=i;
    result:=currentitem;
    break;
  end;
end;
end;

function TVO_Catalogs.SearchNext:integer;
begin
result:=search(searchtxt,currentitem+1);
end;

procedure TVO_Catalogs.XmlStartTag(Sender: TObject; TagName: String; Attributes: TAttrList);
begin
// Vizier
if Fvo_source=Vizier then
if TagName='VOTABLE' then votable:=true
else if TagName='DESCRIPTION' then description:=true
else if TagName='INFO' then info:=true
else if TagName='RESOURCE' then begin
        resource:=true;
        catalog:=Attributes.Value('name');
        catalog_url:=base_url+catalog;
        catalog_desc:='';
        catalog_info:='';
end;
// NVO
if Fvo_source=NVO then
if TagName='ArrayOfResource' then ArrayOfResource:=true
else if TagName='description' then description:=true
else if TagName='title' then info:=true
else if TagName='shortName' then tname:=true
//else if TagName='ServiceURL' then surl:=true
else if TagName='accessURL' then aurl:=true
else if TagName='Resource' then begin
        resource:=true;
        catalog:='';
        catalog_url:='';
        catalog_desc:='';
        catalog_info:='';
end;

end;

procedure TVO_Catalogs.XmlContent(Sender: TObject; Content: String);
begin
// Vizier
if Fvo_source=Vizier then
if votable and resource and description then begin
   catalog_desc:=Content;
end
{else if votable and resource and info then begin
   catalog_info:=Content;
end};
// NVO
if Fvo_source=NVO then
if ArrayOfResource and resource and description then begin
   catalog_desc:=Content;
end
else if ArrayOfResource and resource and tname then begin
   catalog:=Content;
end
else if ArrayOfResource and resource and aurl then begin
   catalog_url:=Content;
end
{else if ArrayOfResource and resource and surl and (catalog_url='') then begin
   catalog_url:=Content;
end}
{else if ArrayOfResource and resource and info then begin
   catalog_info:=Content;
end};
end;

procedure TVO_Catalogs.XmlEndTag(Sender: TObject; TagName: String);
begin
// Vizier
if Fvo_source=Vizier then
if TagName='VOTABLE' then begin
        votable:=false;
     end
else if TagName='DESCRIPTION' then description:=false
else if TagName='RESOURCE' then begin
        resource:=false;
        if catalog<>'META' then
           FCatList.Add(' '+catalog+tab+catalog_desc+tab+catalog_info+tab+catalog_url);
end;
// NVO
if Fvo_source=NVO then
if TagName='ArrayOfResource' then begin
        ArrayOfResource:=false;
     end
else if TagName='description' then description:=false
else if TagName='title' then info:=false
else if TagName='shortName' then tname:=false
//else if TagName='ServiceURL' then surl:=false
else if TagName='accessURL' then aurl:=false
else if TagName='Resource' then begin
        resource:=false;
        if catalog_url<>'' then
           FCatList.Add(' '+catalog+tab+catalog_desc+tab+catalog_info+tab+fixurl(catalog_url));
end;
end;

procedure TVO_Catalogs.XmlEmptyTag(Sender: TObject; TagName: String; Attributes: TAttrList);
begin
 //nothing at the moment
end;

end.
