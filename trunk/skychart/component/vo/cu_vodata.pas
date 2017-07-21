unit cu_vodata;

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
 Table data
}

interface

uses
  u_voconstant, httpsend, blcksock, LibXmlParser, LibXmlComps,
  Classes, SysUtils;

type
  ///////////////////////////////////////////////////////////////
  //   VO Table Data
  ///////////////////////////////////////////////////////////////
  TVO_TableData = class(TComponent)
  private
    Fbaseurl, FLastErr, Fvopath, FTableName, Fvo_data: string;
    Fvo_type: Tvo_type;
    Fra, Fde, Ffov: double;
    FFirst, Fmax: integer;
    FData: TStringArray;
    FColumns: TStringArray;
    FFieldList: TStringList;
    Fncol: integer;
    MetaOnly: boolean;
    http: THTTPSend;
    XmlScanner: TEasyXmlScanner;
    votable, table, description, definition, resource, field, Data, tabledata, tr, td: boolean;
    Fequinox, Fepoch, Fsystem, Fcatalog: string;
    Fequ, Fepo, Fsys: string;
    FSelectCoord: boolean;
    fieldnum, currentfield: integer;
    FGetDataRow, FColsDef: TNotifyEvent;
    procedure XmlStartTag(Sender: TObject; TagName: string; Attributes: TAttrList);
    procedure XmlContent(Sender: TObject; Content: string);
    procedure XmlEndTag(Sender: TObject; TagName: string);
    procedure XmlEmptyTag(Sender: TObject; TagName: string; Attributes: TAttrList);
    procedure XmlLoadExternal(Sender: TObject; SystemId, PublicId, NotationId: string;
      var Result: TXmlParser);
  protected
    Fproxy, Fproxyport, Fproxyuser, Fproxypass: string;
    FSocksproxy, FSockstype: string;
    Sockreadcount, LastRead: integer;
    FDownloadFeedback: TDownloadFeedback;
    procedure httpstatus(Sender: TObject; Reason: THookSocketReason;
      const Value: string);
    procedure LoadData;
    procedure ClearData;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure LoadMeta;
    procedure GetData(Table, objtype: string; preview: boolean = False);
    property Columns: TStringArray read FColumns;
    property Cols: integer read Fncol;
    property DataRow: TStringArray read FData;
    property FieldList: TStringList read FFieldList write FFieldList;
    property FirstRec: integer read FFirst write FFirst;
    property TableName: string read Fcatalog;
    property Equinox: string read Fequinox;
    property Epoch: string read Fepoch;
    property System: string read Fsystem;
    property LastErr: string read FlastErr;
  published
    property BaseUrl: string read Fbaseurl write Fbaseurl;
    property vo_type: Tvo_type read Fvo_type write Fvo_type;
    property CachePath: string read Fvopath write Fvopath;
    property Datafile: string read Fvo_data write Fvo_data;
    property SelectCoord: boolean read FSelectCoord write FSelectCoord;
    property Ra: double read Fra write Fra;
    property Dec: double read Fde write Fde;
    property FOV: double read Ffov write Ffov;
    property MaxData: integer read Fmax write Fmax;
    property onColsDef: TNotifyEvent read FColsDef write FColsDef;
    property onDataRow: TNotifyEvent read FGetDataRow write FGetDataRow;
    //property onDataRow: TNotifyEvent read FGetDataRow write FGetDataRow;
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
//   VO Table Data
///////////////////////////////////////////////////////////////////////

constructor TVO_TableData.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  http := THTTPSend.Create;
  FFieldList := TStringList.Create;
  XmlScanner := TEasyXmlScanner.Create(nil);
  XmlScanner.OnStartTag := XmlStartTag;
  XmlScanner.OnContent := XmlContent;
  XmlScanner.OnEndTag := XmlEndTag;
  XmlScanner.OnEmptyTag := XmlEmptyTag;
  XmlScanner.OnLoadExternal := XmlLoadExternal;
  Fbaseurl := '';
  Fvo_data := '';
  Fvopath := '.';
  Fncol := 0;
  Fmax := 50;
  FSelectCoord := True;
  Fra := 0;
  Fde := 0;
  FFov := 0.1;
  Fproxy := '';
  FSocksproxy := '';
end;

destructor TVO_TableData.Destroy;
begin
  http.Free;
  FFieldList.Free;
  XmlScanner.Free;
  ClearData;
  inherited Destroy;
end;

procedure TVO_TableData.ClearData;
begin
  setlength(FData, 0);
  setlength(FColumns, 0);
  fieldnum := 0;
  FnCol := 0;
end;

procedure TVO_TableData.LoadData;
begin
  ClearData;
  XmlScanner.LoadFromFile(slash(Fvopath) + Fvo_data);
  MetaOnly := False;
  XmlScanner.Execute;
end;

procedure TVO_TableData.LoadMeta;
begin
  ClearData;
  XmlScanner.LoadFromFile(slash(Fvopath) + Fvo_data);
  MetaOnly := True;
  XmlScanner.Execute;
end;

procedure TVO_TableData.GetData(Table, objtype: string; preview: boolean = False);
var
  url: string;
  i: integer;
const
  f6 = '0.000000';
  s6 = '+0.000000;-0.000000;+0.000000';
begin
  FTableName := trim(Table);
  Fcatalog := FTableName;
  url := Fbaseurl;
  if preview then
    Fvo_data := 'vo_preview.xml'
  else
    Fvo_data := 'vo_' + trim(objtype) + '_' + StringReplace(FTableName, '/', '_',
      [rfReplaceAll]) + '.xml';
  case Fvo_type of
    VizierMeta:
    begin
      url := url + '-source=' + FTableName;
      if FSelectCoord then
        url := url + '&-c=' + formatfloat(f6, (Fra)) + '%20' + formatfloat(
          s6, Fde) + '&-c.rm=' + IntToStr(round(60 * Ffov)) + '&-sort=_r'
      else
        url := url + '&recno=>=' + IntToStr(FFirst);
      for i := 0 to FFieldList.Count - 1 do
      begin
        url := url + '&-out=' + FFieldList[i];
      end;
      url := url + '&-out=_RAJ2000&-out=_DEJ2000';
      url := url + '&-oc.form=dec&-out.max=' + IntToStr(Fmax) +
        '&-out.form=XML-VOTable(XSL)';
    end;
    ConeSearch:
    begin
      url := Fbaseurl + 'RA=' + formatfloat(f6, (Fra)) + '&DEC=' +
        formatfloat(s6, (Fde)) + '&SR=' + formatfloat(f6, (Ffov));
    end;
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
  http.Timeout := 60000;
  http.Sock.OnStatus := httpstatus;
  Sockreadcount := 0;
  if http.HTTPMethod('GET', url) and ((http.ResultCode = 200) or (http.ResultCode = 0))
  then
  begin
    http.Document.SaveToFile(slash(Fvopath) + Fvo_data);
    FLastErr := '';
    if Assigned(FDownloadFeedback) then
      FDownloadFeedback('Download completed.');
    if preview then
      LoadData;
  end
  else
  begin
    FLastErr := 'Error: ' + IntToStr(http.ResultCode) + ' ' + http.ResultString;
    if Assigned(FDownloadFeedback) then
      FDownloadFeedback(FLastErr);
  end;
  http.Clear;
end;

procedure TVO_TableData.httpstatus(Sender: TObject; Reason: THookSocketReason;
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

procedure TVO_TableData.XmlStartTag(Sender: TObject; TagName: string;
  Attributes: TAttrList);
var
  buf: string;
begin
  if TagName = 'VOTABLE' then
    votable := True
  else if resource and (TagName = 'DESCRIPTION') then
    description := True
  else if resource and (TagName = 'DEFINITIONS') then
    definition := True
  else if resource and (TagName = 'DATA') then
    Data := True
  else if resource and (TagName = 'TABLE') then
  begin
    table := True;
    buf := Attributes.Value('name');
    if buf <> '' then
      Fcatalog := buf;
  end
  else if votable and (TagName = 'RESOURCE') then
  begin
    resource := True;
    fieldnum := 0;
    buf := Attributes.Value('name');
    if buf = '' then
      buf := Attributes.Value('ID');
    if buf <> '' then
      Fcatalog := buf;
  end
  else if resource and (TagName = 'FIELD') then
  begin
    field := True;
    XmlEmptyTag(Sender, TagName, Attributes);
  end
  else if resource and (TagName = 'TABLEDATA') then
  begin
    if MetaOnly then
    begin
      XmlScanner.StopParser := True;
    end
    else
    begin
      tabledata := True;
      setlength(FData, fieldnum);
      currentfield := -1;
      Fncol := fieldnum;
      if assigned(FColsDef) then
        FColsDef(self);
    end;
  end
  else if tabledata and (TagName = 'TR') then
  begin
    tr := True;
    currentfield := -1;
  end
  else if tabledata and (TagName = 'TD') then
  begin
    td := True;
    Inc(currentfield);
    FData[currentfield] := '';
  end;
end;

procedure TVO_TableData.XmlContent(Sender: TObject; Content: string);
begin
  if td then
  begin
    FData[currentfield] := Content;
  end;
end;

procedure TVO_TableData.XmlEndTag(Sender: TObject; TagName: string);
begin
  if TagName = 'VOTABLE' then
  begin
    votable := False;
  end
  else if resource and (TagName = 'DEFINITIONS') then
    definition := False
  else if resource and (TagName = 'DESCRIPTION') then
    description := False
  else if resource and (TagName = 'DATA') then
    Data := False
  else if resource and (TagName = 'TABLEDATA') then
    tabledata := False
  else if votable and (TagName = 'RESOURCE') then
  begin
    resource := False;
    Fequinox := Fequ;
    Fepoch := Fepo;
    Fsystem := Fsys;
  end
  else if resource and (TagName = 'FIELD') then
    field := False
  else if resource and (TagName = 'TR') then
  begin
    tr := False;
    if assigned(FGetDataRow) then
      FGetDataRow(self);
  end
  else if resource and (TagName = 'TD') then
  begin
    td := False;
  end;
end;

procedure TVO_TableData.XmlEmptyTag(Sender: TObject; TagName: string;
  Attributes: TAttrList);
begin
  if votable and (TagName = 'COOSYS') then
  begin
    Fequ := Attributes.Value('equinox');
    Fepo := Attributes.Value('epoch');
    Fsys := Attributes.Value('system');
  end
  else if resource and (TagName = 'FIELD') then
  begin
    Inc(fieldnum);
    setlength(FColumns, fieldnum);
    FColumns[fieldnum - 1] := Attributes.Value('name');
  end;
end;

procedure TVO_TableData.XmlLoadExternal(Sender: TObject;
  SystemId, PublicId, NotationId: string; var Result: TXmlParser);
// do not try to load the dtd
begin
  Result := TXmlParser.Create;
end;

end.
