unit cu_vodetail;

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
 Table details
}

interface

uses
  u_voconstant, httpsend, blcksock, LibXmlParser, LibXmlComps,
  Classes, SysUtils;

type
  ///////////////////////////////////////////////////////////////
  // Detail for a VO catalog
  ///////////////////////////////////////////////////////////////
  TVO_Detail = class(TComponent)
  private
    Fbaseurl, FLastErr, Fvopath, FCatalogName: string;
    FRecName, FRecUCD, FRecDataType, FRecUnits, FRecDescription: TStringListArray;
    FHasCoord, FHasMag, FHasSize: TBoolArray;
    Fvo_type: Tvo_type;
    Nlist: integer;
    Fnrow: TIntegerArray;
    http: THTTPSend;
    XmlScanner: TEasyXmlScanner;
    votable, table, param, descr, definition, field, Coord, Magnitude, Size: boolean;
    resource: integer;
    Fequinox, Fepoch, Fsystem, Fcatalog, cat_desc: TStringArray;
    param_desc, resdesc, Fequ, Fepo, Fsys, resourcename: string;
    fieldnum: integer;
    procedure XmlStartTag(Sender: TObject; TagName: string; Attributes: TAttrList);
    procedure XmlContent(Sender: TObject; Content: string);
    procedure XmlEndTag(Sender: TObject; TagName: string);
    procedure XmlEmptyTag(Sender: TObject; TagName: string; Attributes: TAttrList);
    procedure XmlLoadExternal(Sender: TObject; SystemId, PublicId, NotationId: string;
      var Result: TXmlParser);
    procedure NewList;
    procedure ClearList;
    procedure LoadDetail;
    procedure GetDetail(Catalog: string; Subdir: boolean; retry: integer = 0);
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
    property RecName: TStringListArray read FRecName;
    property RecUCD: TStringListArray read FRecUCD;
    property RecDataType: TStringListArray read FRecDataType;
    property RecUnits: TStringListArray read FRecUnits;
    property RecDescription: TStringListArray read FRecDescription;
    property Equinox: TStringArray read Fequinox;
    property Epoch: TStringArray read Fepoch;
    property System: TStringArray read Fsystem;
    property TableName: TStringArray read Fcatalog;
    property Description: TStringArray read cat_desc;
    property Rows: TIntegerArray read Fnrow;
    property HasCoord: TBoolArray read FHasCoord;
    property HasMag: TBoolArray read FHasMag;
    property HasSize: TBoolArray read FHasSize;
    property NumTables: integer read Nlist;
    property LastErr: string read FlastErr;
  published
    function Update(Catalog: string; Subdir: boolean): boolean;
    property BaseUrl: string read Fbaseurl write Fbaseurl;
    property vo_type: Tvo_type read Fvo_type write Fvo_type;
    property CachePath: string read Fvopath write Fvopath;
    property CatalogName: string read FCatalogName;
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

///////////////////////////////////////////////////////////////////////
//   VO Detail for a selected catalog
///////////////////////////////////////////////////////////////////////

constructor TVO_Detail.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  http := THTTPSend.Create;
  XmlScanner := TEasyXmlScanner.Create(nil);
  XmlScanner.OnStartTag := XmlStartTag;
  XmlScanner.OnContent := XmlContent;
  XmlScanner.OnEndTag := XmlEndTag;
  XmlScanner.OnEmptyTag := XmlEmptyTag;
  XmlScanner.OnLoadExternal := XmlLoadExternal;
  Fbaseurl := '';
  Fvopath := '.';
  Nlist := 0;
  Fproxy := '';
  FSocksproxy := '';
  NewList;
end;

destructor TVO_Detail.Destroy;
begin
  http.Free;
  XmlScanner.Free;
  ClearList;
  inherited Destroy;
end;

procedure TVO_Detail.NewList;
var
  i: integer;
begin
  i := Nlist + 1;
  setlength(FRecName, i);
  setlength(FRecUCD, i);
  setlength(FRecDataType, i);
  setlength(FRecUnits, i);
  setlength(FRecDescription, i);
  setlength(Fequinox, i);
  setlength(Fepoch, i);
  setlength(Fsystem, i);
  setlength(FHasCoord, i);
  setlength(FHasMag, i);
  setlength(FHasSize, i);
  setlength(Fcatalog, i);
  setlength(cat_desc, i);
  setlength(Fnrow, i);
  FRecName[i - 1] := TStringList.Create;
  FRecUCD[i - 1] := TStringList.Create;
  FRecDataType[i - 1] := TStringList.Create;
  FRecUnits[i - 1] := TStringList.Create;
  FRecDescription[i - 1] := TStringList.Create;
  Nlist := i;
end;

procedure TVO_Detail.ClearList;
var
  i: integer;
begin
  for i := 0 to Nlist - 1 do
  begin
    FRecName[i].Free;
    FRecUCD[i].Free;
    FRecDataType[i].Free;
    FRecUnits[i].Free;
    FRecDescription[i].Free;
  end;
  setlength(FRecName, 0);
  setlength(FRecUCD, 0);
  setlength(FRecDataType, 0);
  setlength(FRecUnits, 0);
  setlength(FRecDescription, 0);
  setlength(Fequinox, 0);
  setlength(Fepoch, 0);
  setlength(Fsystem, 0);
  setlength(FHasCoord, 0);
  setlength(FHasMag, 0);
  setlength(FHasSize, 0);
  setlength(Fcatalog, 0);
  setlength(cat_desc, 0);
  setlength(Fnrow, 0);
  Nlist := 0;
end;

function TVO_Detail.Update(Catalog: string; Subdir: boolean): boolean;
begin
  GetDetail(Catalog, Subdir);
  Result := (FLastErr = '');
end;

procedure TVO_Detail.LoadDetail;
begin
  ClearList;
  XmlScanner.LoadFromFile(slash(Fvopath) + vo_meta);
  XmlScanner.Execute;
end;

procedure TVO_Detail.GetDetail(Catalog: string; Subdir: boolean; retry: integer = 0);
var
  url: string;
begin
  FCatalogName := StringReplace(trim(Catalog), ' ', '%20', [rfReplaceAll]);
  case Fvo_type of
    VizierMeta:
    begin
      if retry = 0 then
      begin
        url := Fbaseurl +
          '-meta.all&-out=_RAJ2000&-out=_DEJ2000&-out=**&-source=' + FCatalogName;
        // tables description and row numbers
        if Subdir then
          url := url + '/*';
      end
      else
        url := Fbaseurl + '-source=' + FCatalogName +
          '/*&-out.all&-oc.form=dec&-c=0%2b0&-c.rs=1&-out.max=1';
      // table description from empty data search, because the previous form do not work for all the catalogs
    end;
    ConeSearch: url := Fbaseurl + 'RA=0&DEC=0&SR=0';
    else
      url := '';
  end;
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
  http.Timeout := 10000;
  http.Sock.OnStatus := httpstatus;
  Sockreadcount := 0;
  if http.HTTPMethod('GET', url) and ((http.ResultCode = 200) or (http.ResultCode = 0))
  then
  begin
    http.Document.SaveToFile(slash(Fvopath) + vo_meta);
    FLastErr := '';
    if Assigned(FDownloadFeedback) then
      FDownloadFeedback('Download completed.');
    LoadDetail;
    if (Nlist = 0) and (retry = 0) then
      GetDetail(Catalog, Subdir, 1);
  end
  else
  begin
    FLastErr := 'Error: ' + IntToStr(http.ResultCode) + ' ' + http.ResultString;
    if Assigned(FDownloadFeedback) then
      FDownloadFeedback(FLastErr);
  end;
  http.Clear;
end;

procedure TVO_Detail.httpstatus(Sender: TObject; Reason: THookSocketReason;
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
    else
      txt := '';
  end;
  if (txt > '') and Assigned(FDownloadFeedback) then
    FDownloadFeedback(txt);
end;

procedure TVO_Detail.XmlStartTag(Sender: TObject; TagName: string;
  Attributes: TAttrList);
begin
  if TagName = 'VOTABLE' then
    votable := True
  else if (resource>0) and (TagName = 'TABLE') then
  begin
    NewList;
    fieldnum := -1;
    Coord := False;
    Magnitude := False;
    Size := False;
    Fcatalog[Nlist - 1] := Attributes.Value('name');
    if trim(Fcatalog[Nlist - 1]) = '' then
      Fcatalog[Nlist - 1] := resourcename;
    if Fcatalog[Nlist - 1] = '' then
      Fcatalog[Nlist - 1] := Attributes.Value('ID');
    if Fcatalog[Nlist - 1] = '' then
      Fcatalog[Nlist - 1] := FCatalogName;
    table := True;
    Fnrow[Nlist - 1] := strtointdef(Attributes.Value('nrows'), 0);
  end
  else if (resource>0) and (TagName = 'DESCRIPTION') then
    descr := True
  else if (resource>0) and (TagName = 'DEFINITIONS') then
    definition := True
  else if (resource>0) and (TagName = 'PARAM') then
    param := True
  else if votable and (TagName = 'RESOURCE') then
  begin
    resource += 1;
    resourcename := Attributes.Value('name');
  end
  else if table and (TagName = 'FIELD') then
  begin
    field := True;
    XmlEmptyTag(Sender, TagName, Attributes);
  end;
end;

procedure TVO_Detail.XmlContent(Sender: TObject; Content: string);
begin
  if (resource>0) and (not table) and (not param) and (not definition) and descr then
  begin
    resdesc := Content;
  end;
  if table and descr then
  begin
    if field then
      FRecDescription[Nlist - 1][fieldnum] := Content
    else if param then
      param_desc := Content
    else
      cat_desc[Nlist - 1] := Content;
  end;
end;

procedure TVO_Detail.XmlEndTag(Sender: TObject; TagName: string);
begin
  if TagName = 'VOTABLE' then
  begin
    votable := False;
  end
  else if (resource>0) and (TagName = 'TABLE') then
  begin
    table := False;
    Fequinox[Nlist - 1] := Fequ;
    Fepoch[Nlist - 1] := Fepo;
    Fsystem[Nlist - 1] := Fsys;
    FHasCoord[Nlist - 1] := Coord;
    FHasMag[Nlist - 1] := Magnitude;
    FHasSize[Nlist - 1] := Size;
    if trim(cat_desc[Nlist - 1]) = '' then
      cat_desc[Nlist - 1] := resdesc;
  end
  else if (resource>0) and (TagName = 'DEFINITIONS') then
    definition := False
  else if (resource>0) and (TagName = 'DESCRIPTION') then
    descr := False
  else if (resource>0) and (TagName = 'PARAM') then
    param := False
  else if votable and (TagName = 'RESOURCE') then
  begin
    resource -= 1;
  end
  else if (resource>0) and (TagName = 'FIELD') then
  begin
    field := False;
  end;
end;

procedure TVO_Detail.XmlEmptyTag(Sender: TObject; TagName: string;
  Attributes: TAttrList);
var
  i: integer;
  buf, b1, b2, b3, b4: string;
begin
  if votable and (TagName = 'COOSYS') then
  begin
    Fequ := Attributes.Value('equinox');
    Fepo := Attributes.Value('epoch');
    Fsys := Attributes.Value('system');
  end
  else if (resource>0) and (TagName = 'FIELD') then
  begin
    Inc(fieldnum);
    b1 := '';
    b2 := '';
    b3 := '';
    b4 := '';
    for i := 0 to Attributes.Count - 1 do
    begin
      buf := uppercase(Attributes.Name(i));
      // unconsidered use of uppercase in some votable!
      if buf = 'NAME' then
        b1 := Attributes.Value(i);
      if buf = 'UCD' then
        b2 := Attributes.Value(i);
      if buf = 'DATATYPE' then
        b3 := Attributes.Value(i);
      if buf = 'UNIT' then
        b4 := Attributes.Value(i);
    end;
    FRecName[Nlist - 1].Add(b1);
    FRecUCD[Nlist - 1].Add(b2);
    FRecDatatype[Nlist - 1].Add(b3);
    FRecUnits[Nlist - 1].Add(b4);
    FRecDescription[Nlist - 1].Add('');
    if pos('pos.eq.ra', FRecUCD[Nlist - 1][fieldnum]) > 0 then
      Coord := True;
    if pos('phot.mag', FRecUCD[Nlist - 1][fieldnum]) > 0 then
      Magnitude := True;
    if pos('phys.angSize', FRecUCD[Nlist - 1][fieldnum]) > 0 then
      Size := True;
  end;
end;

procedure TVO_Detail.XmlLoadExternal(Sender: TObject;
  SystemId, PublicId, NotationId: string; var Result: TXmlParser);
// do not try to load the dtd
begin
  Result := TXmlParser.Create;
end;

end.
