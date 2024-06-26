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
Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
}
{
 Virtual Observatory interface.
 Catalog resource list
}

interface

uses
  u_voconstant, httpsend, blcksock, LibXmlParser, LibXmlComps,
  Classes, SysUtils;

type
  ///////////////////////////////////////////////////////////////
  // List of available VO catalog
  ///////////////////////////////////////////////////////////////
  TVO_Catalogs = class(TComponent)
  private
    Fvo_source: Tvo_source;
    Fvo_type: Tvo_type;
    FListUrl, FLastErr, Fvopath: string;
    searchtxt: string;
    FCatList: TStringList;
    currentitem: integer;
    http: THTTPSend;
    XmlScanner: TEasyXmlScanner;
    votable, description, info, table, tname, ArrayOfResource, aurl: boolean;
    resource: integer;
    catalog, catalog_desc, catalog_info, base_url, catalog_url: string;
    procedure XmlStartTag(Sender: TObject; TagName: string; Attributes: TAttrList);
    procedure XmlContent(Sender: TObject; Content: string);
    procedure XmlEndTag(Sender: TObject; TagName: string);
    procedure XmlEmptyTag(Sender: TObject; TagName: string; Attributes: TAttrList);
    procedure LoadCats;
    procedure GetCats;
    function GetCatList: TStringList;
    procedure Set_source(Value: Tvo_source);
  protected
    Fproxy, Fproxyport, Fproxyuser, Fproxypass: string;
    FSocksproxy, FSockstype: string;
    Sockreadcount, LastRead: integer;
    FDownloadFeedback: TDownloadFeedback;
    procedure httpstatus(Sender: TObject; Reason: THookSocketReason;
      const Value: string);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function Search(txt: string; startpos: integer = 0): integer;
    function SearchNext: integer;
    function ForceUpdate: boolean;
    procedure ClearCatlist;
    property CatList: TStringList read GetCatList;
    property LastErr: string read FlastErr;
  published
    property vo_source: Tvo_source read Fvo_source write Set_source;
    property vo_type: Tvo_type read Fvo_type;
    property ListUrl: string read FListUrl write FListUrl;
    property CachePath: string read Fvopath write Fvopath;
    property onDownloadFeedback: TDownloadFeedback
      read FDownloadFeedback write FDownloadFeedback;
    property HttpProxy: string read Fproxy write Fproxy;
    property HttpProxyPort: string read Fproxyport write Fproxyport;
    property HttpProxyUser: string read Fproxyuser write Fproxyuser;
    property HttpProxyPass: string read Fproxypass write Fproxypass;
    property SocksProxy: string read FSocksproxy write FSocksproxy;
    property SocksType: string read FSockstype write FSockstype;
  end;

implementation

function Slash(nom: string): string;
begin
  Result := trim(nom);
  if copy(Result, length(nom), 1) <> PathDelim then
    Result := Result + PathDelim;
end;

function fixurl(url: string): string;
begin
  Result := trim(url);
  if (copy(Result, length(url), 1) <> '&') and (copy(Result, length(url), 1) <> '?') then
  begin
    if pos('?', Result) > 0 then
      Result := Result + '&'
    else
      Result := Result + '?';
  end;
end;

///////////////////////////////////////////////////////////////////////
//   VO List of Catalogs
///////////////////////////////////////////////////////////////////////

constructor TVO_Catalogs.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  http := THTTPSend.Create;
  XmlScanner := TEasyXmlScanner.Create(nil);
  XmlScanner.OnStartTag := XmlStartTag;
  XmlScanner.OnContent := XmlContent;
  XmlScanner.OnEndTag := XmlEndTag;
  XmlScanner.OnEmptyTag := XmlEmptyTag;
  FCatList := TStringList.Create;
  Fvo_source := Vizier;
  Fvo_type := vo_types[Fvo_source];
  FListUrl := vo_url[Fvo_source, 1, 1];
  Fvopath := '.';
  Fproxy := '';
  FSocksproxy := '';
end;

destructor TVO_Catalogs.Destroy;
begin
  http.Free;
  XmlScanner.Free;
  FCatList.Free;
  inherited Destroy;
end;

procedure TVO_Catalogs.Set_source(Value: Tvo_source);
begin
  FListUrl := vo_url[Value, 1, 1];
  Fvo_type := vo_types[Value];
  Fvo_source := Value;
end;

function TVO_Catalogs.GetCatList: TStringList;
begin
  if FCatList.Count = 0 then
  begin
    if fileexists(slash(Fvopath) + vo_list[Fvo_source]) then
      LoadCats
    else
      GetCats;
  end;
  Result := FCatList;
end;

procedure TVO_Catalogs.ClearCatlist;
begin
  FCatList.Clear;
end;

function TVO_Catalogs.ForceUpdate: boolean;
begin
  GetCats;
  Result := (FLastErr = '');
end;

procedure TVO_Catalogs.LoadCats;
var
  i: integer;
  f:textfile;
  buf:string;
begin
  FCatList.Clear;
  votable := False;
  description := False;
  resource := 0;
  info := False;
  table := False;
  tname := False;
  ArrayOfResource := False;
  aurl := False;
  i := pos('?', FListUrl);
  base_url := copy(FListUrl, 1, i) + '-source=';
  AssignFile(f,slash(Fvopath) + vo_list[Fvo_source]);
  Reset(f);
  ReadLn(f,buf);
  CloseFile(f);
  if LowerCase(copy(buf,1,5))='<?xml' then begin
    XmlScanner.LoadFromFile(slash(Fvopath) + vo_list[Fvo_source]);
    XmlScanner.Execute;
  end;
end;

procedure TVO_Catalogs.GetCats;
var
  url,buf: string;
  stime: double;
begin
  url := FListUrl;
  http.Clear;
  http.Sock.SocksIP := '';
  http.ProxyHost := '';
  if FSocksproxy <> '' then
  begin
    http.Sock.SocksIP := FSocksproxy;
    if Fproxyport <> '' then
      http.Sock.SocksPort := Fproxyport;
    if FSockstype = 'Socks4' then
      http.Sock.SocksType := ST_Socks4
    else
      http.Sock.SocksType := ST_Socks5;
    if Fproxyuser <> '' then
      http.Sock.SocksUsername := Fproxyuser;
    if Fproxypass <> '' then
      http.Sock.SocksPassword := Fproxypass;
  end
  else if Fproxy <> '' then
  begin
    http.ProxyHost := Fproxy;
    if Fproxyport <> '' then
      http.ProxyPort := Fproxyport;
    if Fproxyuser <> '' then
      http.ProxyUser := Fproxyuser;
    if Fproxypass <> '' then
      http.ProxyPass := Fproxypass;
  end;
  http.Timeout := 60000;
  http.Sock.ConnectionTimeout:=10000;
  http.Sock.OnStatus := httpstatus;
  Sockreadcount := 0;
  stime:=now;
  if http.HTTPMethod('GET', url) and ((http.ResultCode = 200) or
    (http.ResultCode = 0)) then
  begin
    http.Document.SaveToFile(slash(Fvopath) + vo_list[Fvo_source]);
    FLastErr := '';
    if Assigned(FDownloadFeedback) then
      FDownloadFeedback('Download completed.');
    LoadCats;
  end
  else
  begin
    buf:=http.ResultString;
    if (buf='')and(http.ResultCode=0) then buf:='No response from server after '+IntToStr(round((now-stime)*SecsPerDay))+' seconds';
    FLastErr := 'Error: ' + IntToStr(http.ResultCode) + ' ' +buf;
    if Assigned(FDownloadFeedback) then
      FDownloadFeedback(FLastErr);
  end;
  http.Clear;
end;

procedure TVO_Catalogs.httpstatus(Sender: TObject; Reason: THookSocketReason;
  const Value: string);
var
  txt: string;
begin
  txt := '';
  case reason of
    HR_ResolvingBegin: txt := 'Resolving ' + Value;
    HR_Connect: txt := 'Connect ' + Value;
    HR_Accept: txt := 'Accept ' + Value;
    HR_ReadCount:
    begin
      Sockreadcount := Sockreadcount + StrToInt(Value);
      if (Sockreadcount - LastRead) > 100000 then
      begin
        txt := 'Read data: ' + IntToStr(Sockreadcount div 1024) + ' KB';
        LastRead := Sockreadcount;
      end;
    end;
    HR_WriteCount:
    begin
      txt := 'Request sent ...';
    end;
    else
      txt := '';
  end;
  if (txt > '') and Assigned(FDownloadFeedback) then
    FDownloadFeedback(txt);
end;

function TVO_Catalogs.Search(txt: string; startpos: integer = 0): integer;
var
  i: integer;
begin
  Result := -1;
  searchtxt := uppercase(txt);
  for i := startpos to FCatList.Count - 1 do
  begin
    if pos(searchtxt, uppercase(FCatList[i])) > 0 then
    begin
      currentitem := i;
      Result := currentitem;
      break;
    end;
  end;
end;

function TVO_Catalogs.SearchNext: integer;
begin
  Result := search(searchtxt, currentitem + 1);
end;

procedure TVO_Catalogs.XmlStartTag(Sender: TObject; TagName: string;
  Attributes: TAttrList);
begin
  // Vizier
  if Fvo_source = Vizier then
    if TagName = 'VOTABLE' then
      votable := True
    else if TagName = 'DESCRIPTION' then
      description := True
    else if TagName = 'INFO' then
      info := True
    else if TagName = 'TABLE' then
      table := True
    else if TagName = 'RESOURCE' then
    begin
      resource += 1;
      catalog := Attributes.Value('name');
      catalog_url := base_url + catalog;
      catalog_desc := '';
      catalog_info := '';
    end;
  // NVO
  if Fvo_source = NVO then
    if TagName = 'ArrayOfResource' then
      ArrayOfResource := True
    else if TagName = 'description' then
      description := True
    else if TagName = 'title' then
      info := True
    else if TagName = 'shortName' then
      tname := True
    //else if TagName='ServiceURL' then surl:=true
    else if TagName = 'accessURL' then
      aurl := True
    else if TagName = 'Resource' then
    begin
      resource += 1;
      catalog := '';
      catalog_url := '';
      catalog_desc := '';
      catalog_info := '';
    end;

end;

procedure TVO_Catalogs.XmlContent(Sender: TObject; Content: string);
begin
  // Vizier
  if Fvo_source = Vizier then
    if votable and (resource>0) and description and (not table) then
    begin
      catalog_desc := Content;
    end
{else if votable and resource and info then begin
   catalog_info:=Content;
end};
  // NVO
  if Fvo_source = NVO then
    if ArrayOfResource and (resource>0) and description then
    begin
      catalog_desc := Content;
    end
    else if ArrayOfResource and (resource>0) and tname then
    begin
      catalog := Content;
    end
    else if ArrayOfResource and (resource>0) and aurl then
    begin
      catalog_url := Content;
    end
{else if ArrayOfResource and resource and surl and (catalog_url='') then begin
   catalog_url:=Content;
end}
{else if ArrayOfResource and resource and info then begin
   catalog_info:=Content;
end};
end;

procedure TVO_Catalogs.XmlEndTag(Sender: TObject; TagName: string);
begin
  // Vizier
  if Fvo_source = Vizier then
    if TagName = 'VOTABLE' then
    begin
      votable := False;
    end
    else if TagName = 'DESCRIPTION' then
      description := False
    else if TagName = 'TABLE' then
      table := False
    else if TagName = 'RESOURCE' then
    begin
      resource -= 1;
      if (resource=0)and(catalog <> 'META') then
        FCatList.Add(' ' + catalog + tab + catalog_desc + tab +
          catalog_info + tab + catalog_url);
    end;
  // NVO
  if Fvo_source = NVO then
    if TagName = 'ArrayOfResource' then
    begin
      ArrayOfResource := False;
    end
    else if TagName = 'description' then
      description := False
    else if TagName = 'title' then
      info := False
    else if TagName = 'shortName' then
      tname := False
    //else if TagName='ServiceURL' then surl:=false
    else if TagName = 'accessURL' then
      aurl := False
    else if TagName = 'Resource' then
    begin
      resource -= 1;
      if (resource=0)and (catalog_url <> '') then
        FCatList.Add(' ' + catalog + tab + catalog_desc + tab +
          catalog_info + tab + fixurl(catalog_url));
    end;
end;

procedure TVO_Catalogs.XmlEmptyTag(Sender: TObject; TagName: string;
  Attributes: TAttrList);
begin
  //nothing at the moment
end;

end.
