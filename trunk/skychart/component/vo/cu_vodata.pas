unit cu_vodata;

{$MODE Delphi}

{                                        
Copyright (C) 2005 Patrick Chevalley

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
}
{
 Virtual Observatory interface.
 Table data
}

interface

uses u_voconstant, httpsend, blcksock, LibXmlParser, LibXmlComps,
     Classes, SysUtils;

type
  ///////////////////////////////////////////////////////////////
  //   VO Table Data
  ///////////////////////////////////////////////////////////////
  TVO_TableData = class(TComponent)
  private
    Fbaseurl,FLastErr,Fvopath,FTableName,Fvo_data: string;
    Fvo_type: Tvo_type;
    Fra,Fde,Ffov : double;
    FFirst,Fmax: integer;
    FData: TStringArray;
    FColumns: TStringArray;
    FFieldList: TStringList;
    Fncol: Integer;
    http: THTTPSend;
    XmlScanner: TEasyXmlScanner;
    votable,table,description,definition,resource,field,data,tabledata,tr,td : boolean;
    Fequinox,Fepoch,Fsystem,Fcatalog : String;
    Fequ,Fepo,Fsys: string;
    FSelectCoord: boolean;
    fieldnum,currentfield: integer;
    FGetDataRow, FColsDef: TNotifyEvent;
    procedure XmlStartTag(Sender: TObject; TagName: String; Attributes: TAttrList);
    procedure XmlContent(Sender: TObject; Content: String);
    procedure XmlEndTag(Sender: TObject; TagName: String);
    procedure XmlEmptyTag(Sender: TObject; TagName: String; Attributes: TAttrList);
    procedure XmlLoadExternal(Sender : TObject; SystemId, PublicId, NotationId : STRING; VAR Result : TXmlParser);
    procedure LoadData;
    procedure ClearData;
  protected
    Fproxy : boolean;
    Fproxyhost,Fproxyport,Fproxyuser,Fproxypass : string;
    Sockreadcount, LastRead: integer;
    FDownloadFeedback: TDownloadFeedback;
    procedure httpstatus(Sender: TObject; Reason: THookSocketReason; const Value: String);
  public
    constructor Create(AOwner:TComponent); override;
    destructor  Destroy; override;
    procedure GetData(Table,objtype:string; preview: boolean=false);
    property Columns: TStringArray read FColumns;
    property Cols: Integer read Fncol;
    property DataRow: TStringArray read FData;
    property FieldList: TStringList read FFieldList write FFieldList;
    property FirstRec: integer read FFirst write FFirst;
    property TableName :String read Fcatalog;
    property Equinox :String read Fequinox;
    property Epoch :String read Fepoch;
    property System :String read Fsystem;
    property LastErr: string read FlastErr;
  published
    property BaseUrl: string read Fbaseurl write Fbaseurl;
    property vo_type: Tvo_type read Fvo_type write Fvo_type;
    property CachePath: string read Fvopath write Fvopath;
    property Datafile: string read Fvo_data;
    property SelectCoord: boolean read FSelectCoord write FSelectCoord;
    property Ra: double read Fra write Fra;
    property Dec: double read Fde write Fde;
    property FOV: double read Ffov write Ffov;
    property MaxData: integer read Fmax write Fmax;
    property onColsDef: TNotifyEvent read FColsDef write FColsDef;
    property onDataRow: TNotifyEvent read FGetDataRow write FGetDataRow;
    property onDataRow: TNotifyEvent read FGetDataRow write FGetDataRow;
    property onDownloadFeedback: TDownloadFeedback read FDownloadFeedback write FDownloadFeedback;
    property Proxy : boolean read Fproxy  write Fproxy ;
    property HttpProxyhost : string read Fproxyhost  write Fproxyhost ;
    property HttpProxyPort : string read Fproxyport  write Fproxyport ;
    property HttpProxyUser : string read Fproxyuser  write Fproxyuser ;
    property HttpProxyPass : string read Fproxypass  write Fproxypass ;
  end;

implementation

Function Slash(nom : string) : string;
begin
result:=trim(nom);
if copy(result,length(nom),1)<>PathDelim then result:=result+PathDelim;
end;

///////////////////////////////////////////////////////////////////////
//   VO Table Data
///////////////////////////////////////////////////////////////////////

constructor TVO_TableData.Create(AOwner:TComponent);
begin
 inherited Create(AOwner);
 http := THTTPSend.Create;
 FFieldList:=TStringList.Create;
 XmlScanner:=TEasyXmlScanner.Create(nil);
 XmlScanner.OnStartTag:=XmlStartTag;
 XmlScanner.OnContent:=XmlContent;
 XmlScanner.OnEndTag:=XmlEndTag;
 XmlScanner.OnEmptyTag:=XmlEmptyTag;
 XmlScanner.OnLoadExternal:=XmlLoadExternal;
 Fbaseurl:='';
 Fvo_data:='';
 Fvopath:='.';
 Fncol:=0;
 Fmax:=50;
 FSelectCoord:=true;
 Fra:=0;
 Fde:=0;
 FFov:=0.1;
end;

destructor TVO_TableData.Destroy;
begin
 http.Free;
 FFieldList.Free;
 XmlScanner.Free;
 ClearData;
 inherited destroy;
end;

procedure TVO_TableData.ClearData;
begin
 setlength(FData,0);
 setlength(FColumns,0);
 fieldnum:=0;
 FnCol:=0;
end;

procedure TVO_TableData.LoadData;
begin
   ClearData;
   XmlScanner.LoadFromFile(slash(Fvopath)+Fvo_data);
   XmlScanner.Execute;
end;

procedure TVO_TableData.GetData(Table,objtype:string; preview: boolean=false);
var url:string;
    i: integer;
const f6='0.000000';
      s6='+0.000000;-0.000000;+0.000000';
begin
FTableName:=trim(Table);
Fcatalog:=FTableName;
url:=Fbaseurl;
if preview then Fvo_data:='vo_preview.xml'
   else Fvo_data:='vo_table_'+trim(objtype)+'_'+StringReplace(FTableName,'/','_',[rfReplaceAll])+'.xml';
case Fvo_type of
  VizierMeta: begin
                url:=url+'-source='+FTableName;
                if FSelectCoord then
                   url:=url+'&-c='+formatfloat(f6,(15*Fra))+'%20'+formatfloat(s6,Fde)+'&-c.r='+inttostr(round(60*Ffov))
                else
                   url:=url+'&recno=>='+inttostr(FFirst);
                   for i:=0 to FFieldList.Count-1 do begin
                      url:=url+'&-out='+FFieldList[i];
                   end;
                url:=url+'&-out=_RAJ2000&-out=_DEJ2000';
                url:=url+'&-oc.form=dec&-out.max='+inttostr(Fmax)+'&-out.form=XML-VOTable(XSL)';
              end;
  ConeSearch: begin
                url:=Fbaseurl+'RA='+formatfloat(f6,(15*Fra))+'&DEC='+formatfloat(s6,(Fde))+'&SR='+formatfloat(f6,(Ffov));
              end;
end;
http.Clear;
if Fproxy then begin
   http.ProxyHost:=Fproxyhost;
   http.ProxyPort:=Fproxyport;
   http.ProxyUser :=Fproxyuser;
   http.ProxyPass :=Fproxypass;
end else begin
  http.ProxyHost:='';
  http.ProxyPort:='';
  http.ProxyUser :='';
  http.ProxyPass :='';
end;
http.Timeout:=60000;
http.Sock.OnStatus:=httpstatus;
Sockreadcount:=0;
if http.HTTPMethod('GET', url)
   and ((http.ResultCode=200)
   or (http.ResultCode=0))
     then begin
       http.Document.SaveToFile(slash(Fvopath)+Fvo_data);
       FLastErr:='';
       if Assigned(FDownloadFeedback) then FDownloadFeedback('Download completed.');
       if preview then LoadData;
     end
     else begin
        FLastErr:='Error: '+inttostr(http.ResultCode)+' '+http.ResultString;
        if Assigned(FDownloadFeedback) then FDownloadFeedback(FLastErr);
     end;
http.Clear;
end;

procedure TVO_TableData.httpstatus(Sender: TObject; Reason: THookSocketReason; const Value: String);
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
  else txt:='';
end;
if (txt>'')and Assigned(FDownloadFeedback) then FDownloadFeedback(txt);
end;

procedure TVO_TableData.XmlStartTag(Sender: TObject; TagName: String; Attributes: TAttrList);
var buf: string;
begin
if TagName='VOTABLE' then votable:=true
else if resource and (TagName='DESCRIPTION') then description:=true
else if resource and (TagName='DEFINITIONS') then definition:=true
else if resource and (TagName='DATA') then data:=true
else if resource and (TagName='TABLE') then begin
        table:=true;
        buf:=Attributes.Value('name');
        if buf<>'' then Fcatalog:=buf;
     end
else if votable and (TagName='RESOURCE') then begin
        resource:=true;
        fieldnum:=0;
        buf:=Attributes.Value('name');
        if buf='' then buf:=Attributes.Value('ID');
        if buf<>'' then Fcatalog:=buf;
     end
else if resource and (TagName='FIELD') then begin
        field:=true;
        XmlEmptyTag(Sender,TagName,Attributes);
     end
else if resource and (TagName='TABLEDATA') then begin
        tabledata:=true;
        setlength(FData,fieldnum);
        currentfield:=-1;
        Fncol:=fieldnum;
        if assigned(FColsDef) then FColsDef(self);
     end
else if tabledata and (TagName='TR') then begin
        tr:=true;
        currentfield:=-1;
     end
else if tabledata and (TagName='TD') then begin
        td:=true;
        inc(currentfield);
        FData[currentfield]:='';
end;
end;

procedure TVO_TableData.XmlContent(Sender: TObject; Content: String);
begin
if td then begin
   FData[currentfield]:=Content;
end;
end;

procedure TVO_TableData.XmlEndTag(Sender: TObject; TagName: String);
begin
if TagName='VOTABLE' then begin
        votable:=false;
     end
else if resource and(TagName='DEFINITIONS') then definition:=false
else if resource and(TagName='DESCRIPTION') then description:=false
else if resource and(TagName='DATA') then data:=false
else if resource and(TagName='TABLEDATA') then tabledata:=false
else if votable and(TagName='RESOURCE') then begin
        resource:=false;
        Fequinox:=Fequ;
        Fepoch:=Fepo;
        Fsystem:=Fsys;
     end
else if resource and(TagName='FIELD') then field:=false
else if resource and(TagName='TR') then begin
        tr:=false;
        if assigned(FGetDataRow) then FGetDataRow(self);
     end
else if resource and(TagName='TD') then begin
        td:=false;
end;
end;

procedure TVO_TableData.XmlEmptyTag(Sender: TObject; TagName: String; Attributes: TAttrList);
begin
if votable and (TagName='COOSYS') then begin
        Fequ:=Attributes.Value('equinox');
        Fepo:=Attributes.Value('epoch');
        Fsys:=Attributes.Value('system');
     end
else if resource and (TagName='FIELD') then begin
        inc(fieldnum);
        setlength(FColumns,fieldnum);
        FColumns[fieldnum-1]:=Attributes.Value('name');
end;
end;

procedure TVO_TableData.XmlLoadExternal(Sender : TObject; SystemId, PublicId, NotationId : STRING; VAR Result : TXmlParser);
// do not try to load the dtd
begin
Result := TXmlParser.Create;
end;

end.
