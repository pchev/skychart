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

uses u_voconstant, httpsend, LibXmlParser, LibXmlComps,
     Classes, SysUtils;

type
  ///////////////////////////////////////////////////////////////
  //   VO Table Data
  ///////////////////////////////////////////////////////////////
  TVO_TableData = class(TComponent)
  private
    Fbaseurl,FLastErr,Fvopath,FTableName: string;
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
    FSelectCoord,FAllFields: boolean;
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
  public
    constructor Create(AOwner:TComponent); override;
    destructor  Destroy; override;
    procedure GetData(Table:string);
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
    property SelectCoord: boolean read FSelectCoord write FSelectCoord;
    property Ra: double read Fra write Fra;
    property Dec: double read Fde write Fde;
    property FOV: double read Ffov write Ffov;
    property SelectAllFields: boolean read FAllFields write FAllFields;
    property MaxData: integer read Fmax write Fmax;
    property onColsDef: TNotifyEvent read FColsDef write FColsDef;
    property onDataRow: TNotifyEvent read FGetDataRow write FGetDataRow;
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
   XmlScanner.LoadFromFile(slash(Fvopath)+vo_data);
   XmlScanner.Execute;
end;

procedure TVO_TableData.GetData(Table:string);
var url:string;
    i: integer;
const f6='0.000000';
      s6='+0.000000;-0.000000;+0.000000';
begin
FTableName:=trim(Table);
Fcatalog:=FTableName;
url:=Fbaseurl;
case Fvo_type of
  VizierMeta: begin
                if FSelectCoord then
                   url:=url+'&-c='+formatfloat(f6,(15*Fra))+'%20'+formatfloat(s6,Fde)+'&-c.r='+inttostr(round(60*Ffov))
                else
                   url:=url+'&recno=>='+inttostr(FFirst);
                {if FAllFields then
                   url:=url+'&-out.all'
                else}
                   for i:=0 to FFieldList.Count-1 do begin
                      url:=url+'&-out='+FFieldList[i];
                   end;
                if FSelectCoord then url:=url+'&-out=_RA&-out=_DE';
                url:=url+'&-oc.form=dec&-out.max='+inttostr(Fmax)+'&-out.form=XML-VOTable(XSL)';
              end;
  ConeSearch: begin
                url:=Fbaseurl+'RA='+formatfloat(f6,(15*Fra))+'&DEC='+formatfloat(s6,(Fde))+'&SR='+formatfloat(f6,(Ffov));
              end;
end;
http.Clear;
http.Timeout:=60000;
if http.HTTPMethod('GET', url)
   and ((http.ResultCode=200)
   or (http.ResultCode=0))
     then begin
       http.Document.SaveToFile(slash(Fvopath)+vo_data);
       FLastErr:='';
       LoadData;
     end
     else FLastErr:='Error: '+inttostr(http.ResultCode)+' '+http.ResultString;
http.Clear;
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