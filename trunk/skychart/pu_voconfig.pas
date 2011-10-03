unit pu_voconfig;

{$MODE Delphi}

{                                        
Copyright (C) 2011 Patrick Chevalley

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
 Virtual Observatory interface configuration.
}

interface

uses XMLConf, u_translation, u_constant, Messages, SysUtils, Classes,  Graphics, Controls, Forms, FileUtil,
  Dialogs, StdCtrls, Menus, pr_vodetail, ComCtrls, Grids, ExtCtrls, math,
  LResources, Buttons, u_voconstant, cu_vocatalog, cu_vodetail, cu_vodata;

type

  { Tf_voconfig }

  Tf_voconfig = class(TForm)
    Button1: TButton;
    ButtonClose: TButton;
    ButtonHelp: TButton;
    ButtonBack: TButton;
    CatFilter: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    LabelStatus: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Panel3: TPanel;
    Panel4: TPanel;
    VO_Catalogs1: TVO_Catalogs;
    PageControl1: TPageControl;
    TabCat: TTabSheet;
    TabDetail: TTabSheet;
    VO_Detail1: TVO_Detail;
    PageControl2: TPageControl;
    TabData: TTabSheet;
    DataGrid: TStringGrid;
    Panel1: TPanel;
    msg: TLabel;
    Button11: TButton;
    Button12: TButton;
    VO_TableData1: TVO_TableData;
    CatList: TStringGrid;
    Panel2: TPanel;
    Timer1: TTimer;
    ServerList: TComboBox;
    SaveDialog1: TSaveDialog;
    tn: TEdit;
    TabRegistry: TTabSheet;
    RadioGroup1: TRadioGroup;
    Button13: TButton;
    procedure Searchbyposition(Sender: TObject);
    procedure ButtonCloseClick(Sender: TObject);
    procedure ButtonHelpClick(Sender: TObject);
    procedure ButtonBackClick(Sender: TObject);
    procedure SearchCatalog(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure SelectCatalog(Sender: TObject);
    procedure ServerListChange(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure SelectRegistry(Sender: TObject);
  private
    { Private declarations }
    Fvopath,catname : string;
    Fvourlnum: integer;
    FReloadFeedback: TDownloadFeedback;
    procedure SetServerList;
    procedure FillCatList;
    procedure ClearCatalog;
    procedure ClearDataGrid;
    procedure PreviewData(Sender: TObject);
    procedure GetData(Sender: TObject);
    procedure Goback(Sender: TObject);
    procedure ReceiveData(Sender: TObject);
    procedure DefColumns(Sender: TObject);
    procedure Setvopath(value:string);
    procedure SetProxy(value:boolean);
    procedure SetProxyHost(value:string);
    procedure SetProxyPort(value:string);
    procedure SetProxyUser(value:string);
    procedure SetProxyPass(value:string);
    procedure Setvourlnum(value: integer);
    procedure DownloadFeedback1(txt:string);
    procedure DownloadFeedback2(txt:string);
    procedure DownloadFeedback3(txt:string);
  public
    { Public declarations }
    ra,dec,fov: double;
    OnlyCoord: boolean;
    procedure Setlang;
    procedure ReloadVO(fn: string);
    property vopath: string read Fvopath write Setvopath;
    property Proxy: boolean  write SetProxy;
    property ProxyHost: string  write SetProxyHost;
    property ProxyPort: string  write SetProxyPort;
    property ProxyUser: string  write SetProxyUser;
    property ProxyPass: string  write SetProxyPass;
    property vourlnum: integer read Fvourlnum write Setvourlnum;
    property onReloadFeedback: TDownloadFeedback read FReloadFeedback write FReloadFeedback;
  end;

var
  f_voconfig: Tf_voconfig;

implementation
{$R *.lfm}

Function Slash(nom : string) : string;
begin
result:=trim(nom);
if copy(result,length(nom),1)<>PathDelim then result:=result+PathDelim;
end;

procedure Tf_voconfig.Setlang;
begin
Caption:=rsVOCatalogBro;
Label6.Caption:=rsMakeSelectio;
label2.Caption:=rsSearchCatalo;
Button11.Caption:=rsByName;
Button1.Caption:=rsAroundCurren;
Label1.Caption:=rsSelectMirror;
Button12.Caption:=rsSelectCatalo;
ButtonBack.Caption:='< '+rsBack;
CatList.Cells[0, 0]:=rsName;
CatList.Cells[1, 0]:=rsDescription;
CatList.Cells[2, 0]:=rsURL;
end;

procedure Tf_voconfig.Setvopath(value:string);
begin
Fvopath:=value;
VO_Catalogs1.CachePath:=Fvopath;
VO_Detail1.CachePath:=Fvopath;
VO_TableData1.CachePath:=Fvopath;
end;

procedure Tf_voconfig.SetProxy(value:boolean);
begin
VO_Catalogs1.Proxy:=value;
VO_Detail1.Proxy:=value;
VO_TableData1.Proxy:=value;
end;

procedure Tf_voconfig.SetProxyHost(value:string);
begin
VO_Catalogs1.HttpProxyhost:=value;
VO_Detail1.HttpProxyhost:=value;
VO_TableData1.HttpProxyhost:=value;
end;

procedure Tf_voconfig.SetProxyPort(value:string);
begin
VO_Catalogs1.HttpProxyPort:=value;
VO_Detail1.HttpProxyPort:=value;
VO_TableData1.HttpProxyPort:=value;
end;

procedure Tf_voconfig.SetProxyUser(value:string);
begin
VO_Catalogs1.HttpProxyUser:=value;
VO_Detail1.HttpProxyUser:=value;
VO_TableData1.HttpProxyUser:=value;
end;

procedure Tf_voconfig.SetProxyPass(value:string);
begin
VO_Catalogs1.HttpProxyPass:=value;
VO_Detail1.HttpProxyPass:=value;
VO_TableData1.HttpProxyPass:=value;
end;

procedure Tf_voconfig.Setvourlnum(value: integer);
begin
Fvourlnum:=value;
SetServerList;
end;

procedure Tf_voconfig.FormCreate(Sender: TObject);
begin
  ra:=0;
  dec:=0;
  fov:=deg2rad;
  OnlyCoord:=true;
  CatList.ColWidths[0]:=100;
  CatList.ColWidths[1]:=400;
  CatList.ColWidths[2]:=400;
  PageControl1.ActivePage:=TabCat;
  LabelStatus.Caption:='';
  Setlang;
end;

procedure Tf_voconfig.SetServerList;
var i : integer;
begin
  ServerList.Items.Clear;
  for i:=1 to vo_maxurl do
    if vo_url[VO_Catalogs1.vo_source,i,2]<>'' then
      ServerList.Items.Add(vo_url[VO_Catalogs1.vo_source,i,2]);
  ServerList.ItemIndex:=Fvourlnum;
end;

procedure Tf_voconfig.FillCatList;
var i,p: integer;
    buf: string;
begin
CatList.RowCount:=VO_Catalogs1.CatList.Count+1;
for i:=0 to VO_Catalogs1.CatList.Count-1 do begin
  buf:=VO_Catalogs1.CatList[i];
  p:=pos(tab,buf);
  CatList.Cells[0,i+1]:=copy(buf,1,p-1);
  delete(buf,1,p);
  p:=pos(tab,buf);
  CatList.Cells[1,i+1]:=copy(buf,1,p-1);
  delete(buf,1,p);
  p:=pos(tab,buf);
  //CatList.Cells[2,i+1]:=copy(buf,1,p-1);
  delete(buf,1,p);
  CatList.Cells[2,i+1]:=buf;
end;
CatList.SortColRow(true,0);
msg.Caption:=Format(rsCatalogsAvai, [inttostr(CatList.RowCount-1)]);
end;

procedure Tf_voconfig.FormShow(Sender: TObject);
begin
 VO_Catalogs1.vo_source:=Tvo_source(RadioGroup1.itemindex);
 SetServerList;
 VO_Catalogs1.ClearCatList;
 ClearCatalog;
 ClearDataGrid;
 Timer1.Enabled:=true;
end;

procedure Tf_voconfig.SearchCatalog(Sender: TObject);
var buf:string;
begin
screen.Cursor:=crHourGlass;
buf:=vo_url[VO_Catalogs1.vo_source, ServerList.ItemIndex+1,1];
buf:=buf+'-words='+trim(CatFilter.Text)+'&-meta&-meta.max=1000';
VO_Catalogs1.ListUrl:=buf;
VO_Catalogs1.onDownloadFeedback:=DownloadFeedback1;
try
 msg.Caption:='';
 if VO_Catalogs1.ForceUpdate then
    FillCatList
 else
    msg.Caption:=Format(rsCannotConnec, [VO_Catalogs1.LastErr]);
finally
screen.Cursor:=crDefault;
end;
end;

procedure Tf_voconfig.Searchbyposition(Sender: TObject);
var buf:string;
begin
screen.Cursor:=crHourGlass;
buf:=vo_url[VO_Catalogs1.vo_source, ServerList.ItemIndex+1,1];
buf:=buf+'-source='+'&-c='+formatfloat(f6,(rad2deg*ra))+'%20'+formatfloat(s6,rad2deg*dec)+'&-c.r=2'+'&-meta&-meta.max=500&-out.max=500';
VO_Catalogs1.ListUrl:=buf;
VO_Catalogs1.onDownloadFeedback:=DownloadFeedback1;
try
 msg.Caption:='';
 if VO_Catalogs1.ForceUpdate then
    FillCatList
 else
    msg.Caption:=Format(rsCannotConnec, [VO_Catalogs1.LastErr]);
finally
screen.Cursor:=crDefault;
end;
end;

procedure Tf_voconfig.ButtonBackClick(Sender: TObject);
begin
PageControl1.ActivePage:=TabDetail;
end;

procedure Tf_voconfig.ButtonCloseClick(Sender: TObject);
begin
  Close;
end;

procedure Tf_voconfig.ButtonHelpClick(Sender: TObject);
begin
  // help
end;

function dedupstr(txt:string):string;
var i,p,l: integer;
    buf1,buf2:string;
begin
l:=length(txt);
p:=l div 2;
buf1:=copy(txt,1,p);
buf2:=copy(txt,p+2,9999);
if buf1=buf2 then result:=buf1
   else result:=txt;
end;

procedure Tf_voconfig.SelectCatalog(Sender: TObject);
var i,n: integer;
    buf: string;
    tb:TTabsheet;
    fr:Tf_vodetail;
begin
screen.Cursor:=crHourGlass;
try
if CatList.Row>0 then begin
  i:=CatList.Row;
  buf:=CatList.Cells[0,i];
  catname:=CatList.Cells[1,i];
  VO_Detail1.onDownloadFeedback:=DownloadFeedback1;
  VO_Detail1.CachePath:=VO_Catalogs1.CachePath;
  VO_Detail1.BaseUrl:=vo_url[VO_Catalogs1.vo_source, ServerList.ItemIndex+1,1];
  VO_Detail1.vo_type:=VO_Catalogs1.vo_type;
  VO_Detail1.Update(buf);
  for n:=0 to Pagecontrol2.PageCount-1 do
      Pagecontrol2.Pages[0].Free;
  for n:=0 to VO_Detail1.NumTables-1 do begin
    if OnlyCoord and (not VO_Detail1.HasCoord[n]) then continue;
     tb:=TTabsheet.Create(PageControl2);
     tb.PageControl:=Pagecontrol2;
     fr:=Tf_vodetail.Create(tb);
     fr.MainPanel.Parent:=tb;
     fr.onGetData:=GetData;
     fr.onPreviewData:=PreviewData;
     fr.onGoback:=Goback;
     with fr do begin
       Grid.ColCount:=6;
       Grid.ColWidths[0]:=20;
       Grid.ColWidths[1]:=100;
       Grid.ColWidths[2]:=120;
       Grid.ColWidths[3]:=70;
       Grid.ColWidths[4]:=70;
       Grid.ColWidths[5]:=500;
       Grid.Cells[0,0]:='x';
       Grid.Cells[1, 0]:=rsFieldName;
       Grid.Cells[2,0]:='UCD';
       Grid.Cells[3, 0]:=rsDataType;
       Grid.Cells[4, 0]:=rsUnits;
       Grid.Cells[5, 0]:=rsDescription;
       Grid.RowCount:=VO_Detail1.RecName[n].Count+1;
       for i:=1 to VO_Detail1.RecName[n].Count do begin
         Grid.Cells[0,i]:='x';
         Grid.Cells[1,i]:=VO_Detail1.RecName[n][i-1];
         Grid.Cells[2,i]:=VO_Detail1.RecUCD[n][i-1];
         Grid.Cells[3,i]:=VO_Detail1.RecDatatype[n][i-1];
         Grid.Cells[4,i]:=VO_Detail1.RecUnits[n][i-1];
         Grid.Cells[5,i]:=VO_Detail1.RecDescription[n][i-1];
       end;
       SelectAll:=true;
       tn.Text:=VO_Detail1.TableName[n];
       tb.Caption:=VO_Detail1.TableName[n];
       tr.value:=VO_Detail1.Rows[n];
       if trim(VO_Detail1.description[n])>'' then desc.text:=dedupstr(VO_Detail1.description[n])
          else desc.text:=Catname;
       radec1.Enabled:=VO_Detail1.HasCoord[n];
       radec2.Enabled:=VO_Detail1.HasCoord[n];
       radec3.Enabled:=VO_Detail1.HasCoord[n];
       if radec1.Enabled then begin
          radec1.value:=rad2deg*ra/15;
          radec2.value:=rad2deg*dec;
          radec3.value:=rad2deg*fov;
       end else begin
          radec1.value:=0;
          radec2.value:=0;
          radec3.value:=0;
       end;
       if not VO_Detail1.HasCoord[n] then
          RadioGroup1.ItemIndex:=0
       else if (VO_Detail1.HasSize[n])or(not VO_Detail1.HasMag[n]) then
          RadioGroup1.ItemIndex:=2
       else
          RadioGroup1.ItemIndex:=1;
       FullDownload.Checked:=(tr.Value<=vo_maxrecord);
     end;
  end;
  if Pagecontrol2.PageCount=0 then begin
    ClearCatalog;
  end;
  Pagecontrol1.ActivePage:=TabDetail;
  Pagecontrol2.ActivePageIndex:=0;
end;
finally
screen.Cursor:=crDefault;
end;
end;

procedure Tf_voconfig.ServerListChange(Sender: TObject);
begin
  Fvourlnum:=ServerList.ItemIndex;
end;

procedure Tf_voconfig.ClearCatalog;
var tb:TTabsheet;
    fr:Tf_vodetail;
begin
 tb:=TTabsheet.Create(PageControl2);
 tb.PageControl:=Pagecontrol2;
 fr:=Tf_vodetail.Create(tb);
 fr.MainPanel.Parent:=tb;
 fr.onGoback:=Goback;
 with fr do begin
   Grid.ColCount:=2;
   Grid.ColWidths[0]:=10;
   Grid.ColWidths[1]:=1000;
   Grid.Cells[1, 1]:=rsNoCatalogSel;
 end;
end;

procedure Tf_voconfig.Goback(Sender: TObject);
begin
  PageControl1.ActivePageIndex:=min(0,PageControl1.ActivePageIndex-1);
end;

procedure Tf_voconfig.GetData(Sender: TObject);
var coordselection, objtype, extfn: string;
    i: integer;
    config: TXMLConfig;
begin
screen.Cursor:=crHourGlass;
try
ClearDataGrid;
if sender is Tf_vodetail then
   with sender as Tf_vodetail do begin
       VO_TableData1.vo_type:=VO_Detail1.vo_type;
       VO_TableData1.BaseUrl:=stringreplace(VO_Detail1.BaseUrl,VO_Detail1.CatalogName+'/*',tn.Text,[]);
       VO_TableData1.SelectCoord:=Radec1.Enabled;
       VO_TableData1.ra:=RaDec1.value;
       VO_TableData1.dec:=RaDec2.value;
       VO_TableData1.fov:=RaDec3.value;
       if VO_TableData1.SelectCoord then
           coordselection:='RA:'+RaDec1.text+' DEC:'+RaDec2.text+' FOV:'+RaDec3.text
       else
           coordselection:='';
       DataGrid.cells[1,1]:=DataGrid.cells[1,1]+coordselection;
       VO_TableData1.FirstRec:=1;
       VO_TableData1.maxdata:=vo_maxrecord;
       VO_TableData1.FieldList.Clear;
       for i:=1 to grid.RowCount-1 do begin
          if grid.Cells[0,i]='x' then
             VO_TableData1.FieldList.Add(grid.Cells[1,i]);
       end;
       VO_TableData1.onDownloadFeedback:=DownloadFeedback2;
       case RadioGroup1.ItemIndex of
         0: objtype:='na';
         1: objtype:='star';
         2: objtype:='dso';
       end;
       VO_TableData1.GetData(tn.Text,objtype,false);
       extfn:=slash(VO_TableData1.CachePath)+ChangeFileExt(VO_TableData1.Datafile,'.config');
       config:=TXMLConfig.Create(self);
       config.Filename:=extfn;
       config.SetValue('name',catname);
       config.SetValue('table',tn.Text);
       config.SetValue('objtype',objtype);
       config.SetValue('active',true);
       config.SetValue('fullcat',not VO_TableData1.SelectCoord);
       config.SetValue('drawtype',14);
       config.SetValue('drawcolor',$FF0000);
       config.SetValue('defsize',DefSize.Value);
       config.SetValue('defmag',DefMag.Value);
       config.SetValue('maxmag',-99);
       config.SetValue('baseurl',VO_TableData1.BaseUrl);
       config.SetValue('votype',ord(VO_Detail1.vo_type));
       config.SetValue('fieldcount',VO_TableData1.FieldList.Count);
       for i:=0 to VO_TableData1.FieldList.Count-1 do
           config.SetValue('field_'+inttostr(i),VO_TableData1.FieldList[i]);

       config.Flush;
       config.free;
   end;
finally
screen.Cursor:=crDefault;
end;
end;

procedure Tf_voconfig.ReloadVO(fn: string);
var coordselection, objtype, extfn, baseurl,table: string;
    i, fieldcount: integer;
    votype:Tvo_type;
    config: TXMLConfig;
begin
try
   extfn:=slash(VO_TableData1.CachePath)+ChangeFileExt(fn,'.config');
   config:=TXMLConfig.Create(self);
   config.Filename:=extfn;
   catname:=config.GetValue('name','');
   table:=config.GetValue('table','');
   objtype:=config.GetValue('objtype','');
   baseurl:=config.GetValue('baseurl','');
   votype:=Tvo_type(config.GetValue('votype',0));
   fieldcount:=config.GetValue('fieldcount',0);
   VO_TableData1.FieldList.Clear;
   for i:=0 to fieldcount do
       VO_TableData1.FieldList.Add(config.GetValue('field_'+inttostr(i),''));
   config.SetValue('maxmag',-99);
   config.Flush;
   config.free;
   VO_TableData1.vo_type:=votype;
   VO_TableData1.BaseUrl:=baseurl;
   VO_TableData1.SelectCoord:=true;
   VO_TableData1.ra:=rad2deg*ra/15;
   VO_TableData1.dec:=rad2deg*dec;
   VO_TableData1.fov:=rad2deg*fov;
   VO_TableData1.FirstRec:=1;
   VO_TableData1.maxdata:=vo_maxrecord;
   VO_TableData1.onDownloadFeedback:=DownloadFeedback3;
   VO_TableData1.GetData(table,objtype,false);
finally
end;
end;

procedure Tf_voconfig.PreviewData(Sender: TObject);
var coordselection, objtype, extfn: string;
    i: integer;
const previewmax=50;
begin
screen.Cursor:=crHourGlass;
try
ClearDataGrid;
if sender is Tf_vodetail then
   with sender as Tf_vodetail do begin
       VO_TableData1.vo_type:=VO_Detail1.vo_type;
       VO_TableData1.BaseUrl:=stringreplace(VO_Detail1.BaseUrl,VO_Detail1.CatalogName+'/*',tn.Text,[]);
       VO_TableData1.SelectCoord:=Radec1.Enabled;
       VO_TableData1.ra:=RaDec1.value;
       VO_TableData1.dec:=RaDec2.value;
       VO_TableData1.fov:=RaDec3.value;
       if VO_TableData1.SelectCoord then
           coordselection:='RA:'+RaDec1.text+' DEC:'+RaDec2.text+' FOV:'+RaDec3.text
       else
           coordselection:='';
       DataGrid.cells[1,1]:=DataGrid.cells[1,1]+coordselection;
       VO_TableData1.FirstRec:=1;
       VO_TableData1.maxdata:=previewmax;
       VO_TableData1.FieldList.Clear;
       for i:=1 to grid.RowCount-1 do begin
          if grid.Cells[0,i]='x' then
             VO_TableData1.FieldList.Add(grid.Cells[1,i]);
       end;
       VO_TableData1.onColsDef:=DefColumns;
       VO_TableData1.onDataRow:=ReceiveData;
       VO_TableData1.onDownloadFeedback:=DownloadFeedback2;
       case RadioGroup1.ItemIndex of
         0: objtype:='na';
         1: objtype:='star';
         2: objtype:='dso';
       end;
       VO_TableData1.GetData(tn.Text,objtype,true);
   end;
tn.Text:=VO_TableData1.TableName;
Pagecontrol1.ActivePage:=TabData;
finally
screen.Cursor:=crDefault;
end;
end;

procedure Tf_voconfig.ClearDataGrid;
begin
with DataGrid do begin
  RowCount:=2;
  ColCount:=2;
  colwidths[1]:=400;
  cells[1, 1]:=rsNoData;
end;
end;

procedure Tf_voconfig.ReceiveData(Sender: TObject);
var i: integer;
begin
with DataGrid do begin
  RowCount:=RowCount+1;
  FixedRows:=1;
  for i:=0 to VO_TableData1.Cols-1 do begin
    cells[i,rowcount-1]:=VO_TableData1.DataRow[i];
  end;
end;
end;

procedure Tf_voconfig.DefColumns(Sender: TObject);
var i: integer;
begin
with DataGrid do begin
  RowCount:=1;
  ColCount:=VO_TableData1.Cols;
  for i:=0 to VO_TableData1.Cols-1 do begin
    cells[i,0]:=VO_TableData1.Columns[i];
    colwidths[i]:=75;
  end;
end;
end;

procedure Tf_voconfig.Timer1Timer(Sender: TObject);
begin
Timer1.Enabled:=false;
screen.Cursor:=crHourGlass;
try
 msg.Caption:=rsLoadingCatal;
 msg.Refresh;
 VO_Catalogs1.ListUrl:=vo_url[VO_Catalogs1.vo_source, ServerList.ItemIndex+1,1];
 FillCatList;
 msg.Caption:=VO_Catalogs1.LastErr;
 if msg.Caption='' then msg.Caption:=Format(rsCatalogsAvai, [inttostr(CatList.RowCount-1)]);
finally
screen.Cursor:=crDefault;
end;
end;

procedure Tf_voconfig.DownloadFeedback1(txt:string);
begin
  msg.Caption:=txt;
  msg.Invalidate;
  Application.ProcessMessages;
end;

procedure Tf_voconfig.DownloadFeedback2(txt:string);
begin
  LabelStatus.Caption:=txt;
  LabelStatus.Invalidate;
  Application.ProcessMessages;
end;

procedure Tf_voconfig.DownloadFeedback3(txt:string);
begin
  if Assigned(FReloadFeedback) then FReloadFeedback(txt);
end;

//////////////  Registry selection not used at the moment ////////////////////

procedure Tf_voconfig.SelectRegistry(Sender: TObject);
begin
 VO_Catalogs1.vo_source:=Tvo_source(RadioGroup1.itemindex);
 SetServerList;
 VO_Catalogs1.ClearCatList;
 Timer1.Enabled:=true;
 Pagecontrol1.ActivePage:=TabCat;
end;


end.
