unit pu_voconfig;

{$MODE Delphi}

{                                        
Copyright (C) 2011 Patrick Chevalley

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
 Virtual Observatory interface configuration.
}

interface

uses XMLConf, u_translation, u_constant, Messages, SysUtils, Classes,  Graphics, Controls, Forms, FileUtil,
  Dialogs, StdCtrls, Menus, pr_vodetail, ComCtrls, Grids, ExtCtrls, math, UScaleDPI,
  LResources, Buttons, u_voconstant, cu_vocatalog, cu_vodetail, cu_vodata;

type

  { Tf_voconfig }

  Tf_voconfig = class(TForm)
    Button1: TButton;
    ButtonClose: TButton;
    ButtonHelp: TButton;
    ButtonBack: TButton;
    CatDescEdit: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    LabelStatus: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Panel3: TPanel;
    Panel4: TPanel;
    CloseTimer: TTimer;
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
    procedure CatDescEditKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure CloseTimerTimer(Sender: TObject);
    procedure Searchbyposition(Sender: TObject);
    procedure ButtonCloseClick(Sender: TObject);
    procedure ButtonHelpClick(Sender: TObject);
    procedure ButtonBackClick(Sender: TObject);
    procedure SearchCatalogDesc(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure SelectCatalog(Sender: TObject);
    procedure ServerListChange(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure SelectRegistry(Sender: TObject);
  private
    { Private declarations }
    Fvopath,CatName : string;
    Fcurrentconfig: string;
    Fvourlnum: integer;
    FReloadFeedback: TDownloadFeedback;
    Fvo_maxrecord: integer;
    procedure SetServerList;
    procedure FillGrid(fr:Tf_vodetail; i,n,nactive: integer;active:boolean);
    procedure FillCatList;
    procedure ClearCatalog;
    procedure ClearDataGrid;
    procedure PreviewData(Sender: TObject);
    procedure GetData(Sender: TObject);
    procedure Updateconfig(Sender: TObject);
    procedure Goback(Sender: TObject);
    procedure ReceiveData(Sender: TObject);
    procedure DefColumns(Sender: TObject);
    procedure Setvopath(value:string);
    procedure SetHttpProxy(value:string);
    procedure SetProxyPort(value:string);
    procedure SetProxyUser(value:string);
    procedure SetProxyPass(value:string);
    procedure SetSocksProxy(value:string);
    procedure SetSockstype(value:string);
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
    procedure UpdateCatalog(cn: string);
    property vopath: string read Fvopath write Setvopath;
    property HttpProxy : string write SetHttpProxy;
    property HttpProxyPort : string write SetProxyPort ;
    property HttpProxyUser : string write SetProxyUser ;
    property HttpProxyPass : string write SetProxyPass ;
    property SocksProxy : string write SetSocksProxy ;
    property SocksType : string write SetSockstype;
    property vourlnum: integer read Fvourlnum write Setvourlnum;
    property vo_maxrecord: integer read Fvo_maxrecord write Fvo_maxrecord;
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
ButtonHelp.Caption:=rsHelp;
ButtonClose.Caption:=rsCancel;
end;

procedure Tf_voconfig.Setvopath(value:string);
begin
Fvopath:=value;
VO_Catalogs1.CachePath:=Fvopath;
VO_Detail1.CachePath:=Fvopath;
VO_TableData1.CachePath:=Fvopath;
end;

procedure Tf_voconfig.SetHttpProxy(value:string);
begin
VO_Catalogs1.HttpProxy:=value;
VO_Detail1.HttpProxy:=value;
VO_TableData1.HttpProxy:=value;
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

procedure Tf_voconfig.SetSocksProxy(value:string);
begin
VO_Catalogs1.SocksProxy:=value;
VO_Detail1.SocksProxy:=value;
VO_TableData1.SocksProxy:=value;
end;

procedure Tf_voconfig.SetSockstype(value:string);
begin
VO_Catalogs1.Sockstype:=value;
VO_Detail1.Sockstype:=value;
VO_TableData1.Sockstype:=value;
end;

procedure Tf_voconfig.Setvourlnum(value: integer);
begin
Fvourlnum:=value;
SetServerList;
end;

procedure Tf_voconfig.FormCreate(Sender: TObject);
begin
  ScaleDPI(Self,96);
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
 ClearDataGrid;
 Timer1.Enabled:=true;
end;

procedure Tf_voconfig.SearchCatalogDesc(Sender: TObject);
var buf:string;
begin
if trim(CatDescEdit.Text)>'' then begin
  screen.Cursor:=crHourGlass;
  buf:=vo_url[VO_Catalogs1.vo_source, ServerList.ItemIndex+1,1];
  buf:=buf+'-meta&-meta.max=1000&-words='+StringReplace(trim(CatDescEdit.Text),' ','%20',[rfReplaceAll]);
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
end;

procedure Tf_voconfig.Searchbyposition(Sender: TObject);
var buf:string;
begin
screen.Cursor:=crHourGlass;
buf:=vo_url[VO_Catalogs1.vo_source, ServerList.ItemIndex+1,1];
buf:=buf+'-meta&-meta.max=500&-out.max=500&-source=&-c='+formatfloat(f6,(rad2deg*ra))+'%20'+formatfloat(s6,rad2deg*dec)+'&-c.r=2';
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

procedure Tf_voconfig.CatDescEditKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key=13 then  SearchCatalogDesc(Sender);
end;

procedure Tf_voconfig.CloseTimerTimer(Sender: TObject);
begin
  // to avoid to call Close from a child event
  CloseTimer.Enabled:=false;
  Close;
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
var p,l: integer;
    buf1,buf2:string;
begin
l:=length(txt);
p:=l div 2;
buf1:=copy(txt,1,p);
buf2:=copy(txt,p+2,9999);
if buf1=buf2 then result:=buf1
   else result:=txt;
end;

function numericunit(units: string; out u:double; out log:boolean): string;   //  numeric prefix
var i,j,pe,s,ni: integer;
    e,k,c,n:string;
    ex: double;
begin
log:=false;
k:=trim(units);
i:=length(k);
// log scale
if (copy(k,1,1)='[')and(copy(k,i,1)=']') then begin
  log:=true;
  k:=copy(k,2,i-2);
end;
// sign
s:=1;
c:=copy(k,1,1);
if c='+' then Delete(k,1,1);
if c='-' then begin
   Delete(k,1,1);
   s:=-1;
end;
// exponent position
pe:=pos('10-',k);
if pe=0 then pe:=pos('10+',k);
j:=pe;
if j=0 then j:=length(k);
// numeric factor
n:='';
ni:=0;
for i:=1 to j-1 do begin
   c:=copy(k,i,1);
   if ((c>='0')and(c<='9'))or(c='.') then begin
      n:=n+c;
      inc(ni);
   end
   else break;
end;
if ni>0 then begin
  u:=s*StrToFloatDef(n,0);
  delete(k,1,ni);
end
else u:=1;
// exponent
if pe>0 then begin
   n:='';
   ni:=0;
   for i:=4 to length(k) do begin
      if ((c>='0')and(c<='9')) then begin
         n:=n+c;
         inc(ni);
      end
      else break;
   end;
   e:=n;
   delete(k,1,ni);
   ex:=StrToFloatDef(e,-99999);
   if ex<>-99999 then u:=u*power(10,(ex))
      else u:=0;
end;
result:=k;
end;

function angleunits(units: string; out log: Boolean): double;  // result in radian
var k:string;
    u: double;
begin
  k:=trim(units);
  k:=numericunit(k,u,log);
  if k='mas' then u:=u/3600/1000
  else if k='arcsec' then u:=u/3600
  else if k='arcmin' then u:=u/60
  else if k='rad' then u:=u*rad2deg
  else if k<>'deg' then u:=0;
  result:=deg2rad*u;
end;

procedure Tf_voconfig.FillGrid(fr:Tf_vodetail; i,n,nactive: integer;active:boolean);
var u:double;
    l:boolean;
    p:integer;
begin
  if (not active)or(nactive<0) then nactive:=-99;
  fr.Grid.Cells[1,i]:=VO_Detail1.RecName[n][i-1];
  fr.Grid.Cells[2,i]:=VO_Detail1.RecUCD[n][i-1];
  fr.Grid.Cells[3,i]:=VO_Detail1.RecDatatype[n][i-1];
  fr.Grid.Cells[4,i]:=VO_Detail1.RecUnits[n][i-1];
  fr.Grid.Cells[5,i]:=VO_Detail1.RecDescription[n][i-1];
  if (fr.field_size=nactive)or((fr.field_size=-1)and(pos('phys.angSize',VO_Detail1.RecUCD[n][i-1])=1)and(pos('error',VO_Detail1.RecUCD[n][i-1])=0)) then begin
    u:=angleunits(VO_Detail1.RecUnits[n][i-1],l);
    if (u>0) then begin
       p:=fr.SizeField.Items.Add(VO_Detail1.RecName[n][i-1]);
       fr.SizeField.ItemIndex:=p;
       fr.field_size:=nactive;
    end;
  end;
  if (fr.forcemag=nactive)or(((pos('phot.mag',VO_Detail1.RecUCD[n][i-1])=1)or(pos('phys.mag',VO_Detail1.RecUCD[n][i-1])=1))and(pos('error',VO_Detail1.RecUCD[n][i-1])=0)and(pos('phot.mag.',VO_Detail1.RecUCD[n][i-1])=0)) then begin
    p:=fr.MagField.Items.Add(VO_Detail1.RecName[n][i-1]);
    if (fr.forcemag=nactive)or((fr.forcemag<0)and((fr.field_mag=-1)or(pos('em.opt.V',VO_Detail1.RecUCD[n][i-1])>0))) then begin
      fr.MagField.ItemIndex:=p;
      fr.field_mag:=nactive;
    end;
  end;
  if (fr.forcename=nactive)or((pos('meta.id',VO_Detail1.RecUCD[n][i-1])>0)and(pos('meta.id.',VO_Detail1.RecUCD[n][i-1])=0)) then begin
    p:=fr.NameField.Items.Add(VO_Detail1.RecName[n][i-1]);
    if (fr.forcename=nactive)or((fr.forcename<0)and((fr.field_name=-1)or(pos('meta.main',VO_Detail1.RecUCD[n][i-1])>0))) then begin
       fr.NameField.ItemIndex:=p;
       fr.field_name:=nactive;
       fr.nameprefix:=trim(VO_Detail1.RecName[n][i-1])+' ';
    end;
  end;
end;

procedure Tf_voconfig.SelectCatalog(Sender: TObject);
var i,n,nactive: integer;
    act: boolean;
    buf,ucd: string;
    tb:TTabsheet;
    fr:Tf_vodetail;
begin
screen.Cursor:=crHourGlass;
try
if CatList.Row>0 then begin
  i:=CatList.Row;
  buf:=CatList.Cells[0,i];
  CatName:=CatList.Cells[1,i];
  VO_Detail1.onDownloadFeedback:=DownloadFeedback1;
  VO_Detail1.CachePath:=VO_Catalogs1.CachePath;
  VO_Detail1.BaseUrl:=vo_url[VO_Catalogs1.vo_source, ServerList.ItemIndex+1,1];
  VO_Detail1.vo_type:=VO_Catalogs1.vo_type;
  VO_Detail1.Update(buf,true);
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
     fr.vo_maxrecord:=Fvo_maxrecord;
     with fr do begin
       tablenum:=n;
       field_size:=-1;
       forcesize:=field_size;
       field_mag:=-1;
       forcemag:=field_mag;
       field_name:=-1;
       forcename:=field_name;
       nameprefix:='';
       SizeField.Clear;
       MagField.Clear;
       NameField.Clear;
       SizeField.Items.Add(rsAutomatic);
       MagField.Items.Add(rsAutomatic);
       NameField.Items.Add(rsAutomatic);
       SizeField.ItemIndex:=0;
       MagField.ItemIndex:=0;
       NameField.ItemIndex:=0;
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
       nactive:=-1;
       Grid.RowCount:=VO_Detail1.RecName[n].Count+1;
       for i:=1 to VO_Detail1.RecName[n].Count do begin
         ucd:=VO_Detail1.RecUCD[n][i-1];
         if (pos('meta.ref',ucd)=1)or(pos('stat.error',ucd)=1) then begin
            Grid.Cells[0,i]:='';
            act:=false;
         end else begin
           Grid.Cells[0,i]:='x';
           act:=true;
           inc(nactive);
         end;
         FillGrid(fr,i,n,nactive,act);
       end;
       SelectAll:=true;
       tn.Caption:=VO_Detail1.TableName[n];
       tb.Caption:=VO_Detail1.TableName[n];
       tr.Caption:=inttostr(VO_Detail1.Rows[n]);
       if trim(VO_Detail1.description[n])>'' then desc.Caption:=dedupstr(VO_Detail1.description[n])
          else desc.Caption:=CatName;
       if not VO_Detail1.HasCoord[n] then
          RadioGroup1.ItemIndex:=0
       else if (VO_Detail1.HasSize[n])or(not VO_Detail1.HasMag[n]) then
          RadioGroup1.ItemIndex:=2
       else
          RadioGroup1.ItemIndex:=1;
       RadioGroup1Click(self);
       FullDownload.Checked:=(StrToIntDef(tr.Caption,MaxInt)<=vo_maxrecord);
       Prefix.Text:=nameprefix;
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

procedure Tf_voconfig.UpdateCatalog(cn: string);
var i,j,n,fs,fm,fn,nactive: integer;
    buf,tablen,baseurl,objtype,np: string;
    fullcat,act:boolean;
    dt,dc,ds,dm,fc: integer;
    tb:TTabsheet;
    fr:Tf_vodetail;
    votype:Tvo_type;
    config: TXMLConfig;
    ActiveFields: TStringList;
    ActiveFieldNum: integer;
begin
screen.Cursor:=crHourGlass;
try
  Fcurrentconfig:=cn;
  ActiveFields:=TStringList.Create;
  config:=TXMLConfig.Create(self);
  config.Filename:=cn;
  CatName:=config.GetValue('VOcat/catalog/name','');
  tablen:=config.GetValue('VOcat/catalog/table','');
  objtype:=config.GetValue('VOcat/catalog/objtype','');
  fs:=config.GetValue('VOcat/data/sizeposition',-1);
  fm:=config.GetValue('VOcat/data/magposition',-1);
  fn:=config.GetValue('VOcat/data/nameposition',-1);
  np:=config.GetValue('VOcat/data/nameprefix','');
  baseurl:=config.GetValue('VOcat/update/baseurl','');
  votype:=Tvo_type(config.GetValue('VOcat/update/votype',0));
  fullcat:=config.GetValue('VOcat/update/fullcat',false);
  dt:=config.GetValue('VOcat/plot/drawtype',14);
  dc:=config.GetValue('VOcat/plot/drawcolor',$808080);
  fc:=config.GetValue('VOcat/plot/forcecolor',0);
  ds:=config.GetValue('VOcat/default/defsize',60);
  dm:=config.GetValue('VOcat/default/defmag',12);
  ActiveFieldNum:=config.GetValue('VOcat/fields/fieldcount',0);
  ActiveFields.Clear;
  for i:=0 to ActiveFieldNum do begin
      buf:=config.GetValue('VOcat/fields/field_'+inttostr(i),'');
      ActiveFields.Add(buf);
  end;
  config.Flush;
  config.free;
  if baseurl<>'' then begin
    VO_Detail1.onDownloadFeedback:=DownloadFeedback1;
    VO_Detail1.CachePath:=VO_Catalogs1.CachePath;
    VO_Detail1.BaseUrl:=baseurl;
    VO_Detail1.vo_type:=votype;
    VO_Detail1.Update(tablen,false);
  end;
  for n:=0 to Pagecontrol2.PageCount-1 do
      Pagecontrol2.Pages[0].Free;
  n:=0;
  tb:=TTabsheet.Create(PageControl2);
  tb.PageControl:=Pagecontrol2;
  fr:=Tf_vodetail.Create(tb);
  fr.MainPanel.Parent:=tb;
  fr.onGetData:=GetData;
  fr.onUpdateconfig:=Updateconfig;
  fr.onPreviewData:=PreviewData;
  fr.onGoback:=Goback;
  fr.vo_maxrecord:=Fvo_maxrecord;
  with fr do begin
     field_size:=fs;
     forcesize:=field_size;
     field_mag:=fm;
     forcemag:=field_mag;
     field_name:=fn;
     forcename:=field_name;
     SizeField.Clear;
     MagField.Clear;
     NameField.Clear;
     SizeField.Items.Add(rsAutomatic);
     MagField.Items.Add(rsAutomatic);
     NameField.Items.Add(rsAutomatic);
     SizeField.ItemIndex:=0;
     MagField.ItemIndex:=0;
     NameField.ItemIndex:=0;
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
     nactive:=-1;
     if baseurl<>'' then begin
       Grid.RowCount:=VO_Detail1.RecName[n].Count+1;
       for i:=1 to VO_Detail1.RecName[n].Count do begin
         buf:=VO_Detail1.RecName[n][i-1];
         Grid.Cells[0,i]:='';
         act:=false;
         for j:=0 to ActiveFields.Count-1 do begin
           if ActiveFields[j]=buf then begin
                Grid.Cells[0,i]:='x';
                inc(nactive);
                act:=true;
                break;
           end;
         end;
         FillGrid(fr,i,n,nactive,act);
       end;
       SelectAll:=true;
       tn.Caption:=VO_Detail1.TableName[n];
       tb.Caption:=VO_Detail1.TableName[n];
       tr.Caption:=inttostr(VO_Detail1.Rows[n]);
       if trim(VO_Detail1.description[n])>'' then desc.Caption:=dedupstr(VO_Detail1.description[n])
          else desc.Caption:=CatName;
       if objtype='' then begin
         if not VO_Detail1.HasCoord[n] then
            RadioGroup1.ItemIndex:=0
         else if (VO_Detail1.HasSize[n])or(not VO_Detail1.HasMag[n]) then
            RadioGroup1.ItemIndex:=2
         else
            RadioGroup1.ItemIndex:=1;
       end else begin
         if objtype='star' then RadioGroup1.ItemIndex:=1
         else if objtype='dso' then RadioGroup1.ItemIndex:=2
         else RadioGroup1.ItemIndex:=0;
       end;
       RadioGroup1Click(self);
       FullDownload.Checked:=(StrToIntDef(tr.Caption,MaxInt)<=Fvo_maxrecord);
       nameprefix:=np;
       Prefix.Text:=np;
     end else begin
       Grid.RowCount:=ActiveFieldNum;
       for i:=0 to ActiveFieldNum-1 do begin
          Grid.Cells[0,i]:='x';
          Grid.Cells[1,i]:=ActiveFields[i];
       end;
       Grid.OnMouseUp:=nil;
       SelectAll:=true;
       tn.Caption:=tablen;
       tb.Caption:=tablen;
       tr.Caption:='-1';
       tr.Visible:=false;
       Rows.Visible:=false;
       desc.Caption:=CatName;
       RadioGroup1.ItemIndex:=2;
       RadioGroup1Click(self);
       FullDownload.Checked:=true;
       RadioGroup1.Enabled:=false;
       FullDownload.Enabled:=false;
       button2.Visible:=false;
     end;
   end;
   if Pagecontrol2.PageCount=0 then begin
      ClearCatalog;
   end;
   fr.ButtonBack.Visible:=false;
   fr.FullDownload.Checked:=fullcat;
   fr.DefMag.Value:=dm;
   fr.DefSize.Value:=ds;
   fr.drawtype:=dt;
   fr.ComboBox1.ItemIndex:=fr.drawtype;
   fr.drawcolor:=dc;
   fr.ColorDialog1.Color:=fr.drawcolor;
   fr.shape1.Brush.Color:=fr.drawcolor;
   fr.forcecolor:=fc;
   fr.CheckBox1.Checked:=(fr.forcecolor=1);
   fr.needdownload:=false;
   fr.Button1.Caption:=rsUpdate1;
   Pagecontrol1.ActivePage:=TabDetail;
   Pagecontrol2.ActivePageIndex:=0;
finally
  ActiveFields.Free;
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
       VO_TableData1.BaseUrl:=stringreplace(VO_Detail1.BaseUrl,VO_Detail1.CatalogName+'/*',tn.Caption,[]);
       VO_TableData1.SelectCoord:=not FullDownload.Checked;
       VO_TableData1.ra:=rad2deg*ra;
       VO_TableData1.dec:=rad2deg*dec;
       VO_TableData1.fov:=rad2deg*fov;
       if VO_TableData1.SelectCoord then
           coordselection:='RA:'+formatfloat(f2,rad2deg*ra/15)+' DEC:'+formatfloat(f2,rad2deg*dec)+' FOV:'+formatfloat(f2,rad2deg*fov)
       else
           coordselection:='';
       DataGrid.cells[1,1]:=DataGrid.cells[1,1]+coordselection;
       VO_TableData1.FirstRec:=1;
       VO_TableData1.maxdata:=Fvo_maxrecord;
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
       VO_TableData1.GetData(tn.Caption,objtype,false);
       extfn:=slash(VO_TableData1.CachePath)+ChangeFileExt(VO_TableData1.Datafile,'.config');
       config:=TXMLConfig.Create(self);
       config.Filename:=extfn;
       config.SetValue('VOcat/catalog/name',CatName);
       config.SetValue('VOcat/catalog/table',tn.Caption);
       config.SetValue('VOcat/catalog/objtype',objtype);
       config.DeletePath('VOcat/data');
       config.SetValue('VOcat/data/sizeposition',-1);
       for i:=0 to VO_TableData1.FieldList.Count-1 do
         if VO_TableData1.FieldList[i]=SizeField.Text then begin
           config.SetValue('VOcat/data/sizeposition',i);
           break;
         end;
       config.SetValue('VOcat/data/magposition',-1);
       for i:=0 to VO_TableData1.FieldList.Count-1 do
         if VO_TableData1.FieldList[i]=MagField.Text then begin
           config.SetValue('VOcat/data/magposition',i);
           break;
         end;
       config.SetValue('VOcat/data/nameposition',-1);
       for i:=0 to VO_TableData1.FieldList.Count-1 do
         if VO_TableData1.FieldList[i]=NameField.Text then begin
           config.SetValue('VOcat/data/nameposition',i);
           break;
         end;
       config.SetValue('VOcat/data/nameprefix',nameprefix);
       config.SetValue('VOcat/update/fullcat',not VO_TableData1.SelectCoord);
       config.SetValue('VOcat/update/baseurl',VO_TableData1.BaseUrl);
       config.SetValue('VOcat/update/votype',ord(VO_Detail1.vo_type));
       config.SetValue('VOcat/plot/active',true);
       config.SetValue('VOcat/plot/maxmag',-99);
       config.SetValue('VOcat/plot/drawtype',drawtype);
       config.SetValue('VOcat/plot/drawcolor',drawcolor);
       config.SetValue('VOcat/plot/forcecolor',forcecolor);
       config.SetValue('VOcat/default/defsize',DefSize.Value);
       config.SetValue('VOcat/default/defmag',DefMag.Value);
       config.DeletePath('VOcat/fields');
       config.SetValue('VOcat/fields/fieldcount',VO_TableData1.FieldList.Count);
       for i:=0 to VO_TableData1.FieldList.Count-1 do
           config.SetValue('VOcat/fields/field_'+inttostr(i),VO_TableData1.FieldList[i]);
       config.Flush;
       config.free;
   end;
finally
screen.Cursor:=crDefault;
CloseTimer.Enabled:=true;
end;
end;

procedure Tf_voconfig.ReloadVO(fn: string);
var objtype, extfn, baseurl,table: string;
    i, fieldcount: integer;
    votype:Tvo_type;
    config: TXMLConfig;
begin
try
   extfn:=slash(VO_TableData1.CachePath)+ChangeFileExt(fn,'.config');
   config:=TXMLConfig.Create(self);
   config.Filename:=extfn;
   CatName:=config.GetValue('VOcat/catalog/name','');
   table:=config.GetValue('VOcat/catalog/table','');
   objtype:=config.GetValue('VOcat/catalog/objtype','');
   baseurl:=config.GetValue('VOcat/update/baseurl','');
   votype:=Tvo_type(config.GetValue('VOcat/update/votype',0));
   fieldcount:=config.GetValue('VOcat/fields/fieldcount',0);
   VO_TableData1.FieldList.Clear;
   for i:=0 to fieldcount do
       VO_TableData1.FieldList.Add(config.GetValue('VOcat/fields/field_'+inttostr(i),''));
   config.SetValue('VOcat/plot/maxmag',-99);
   config.Flush;
   config.free;
   VO_TableData1.vo_type:=votype;
   VO_TableData1.BaseUrl:=baseurl;
   VO_TableData1.SelectCoord:=true;
   VO_TableData1.ra:=rad2deg*ra;
   VO_TableData1.dec:=rad2deg*dec;
   VO_TableData1.fov:=rad2deg*fov;
   VO_TableData1.FirstRec:=1;
   VO_TableData1.maxdata:=Fvo_maxrecord;
   VO_TableData1.onDownloadFeedback:=DownloadFeedback3;
   VO_TableData1.GetData(table,objtype,false);
finally
end;
end;

procedure Tf_voconfig.Updateconfig(Sender: TObject);
var objtype, extfn: string;
    i: integer;
    config: TXMLConfig;
begin
screen.Cursor:=crHourGlass;
try
ClearDataGrid;
if sender is Tf_vodetail then
   with sender as Tf_vodetail do begin
       VO_TableData1.vo_type:=VO_Detail1.vo_type;
       VO_TableData1.FieldList.Clear;
       for i:=1 to grid.RowCount-1 do begin
          if grid.Cells[0,i]='x' then
             VO_TableData1.FieldList.Add(grid.Cells[1,i]);
       end;
       case RadioGroup1.ItemIndex of
         0: objtype:='na';
         1: objtype:='star';
         2: objtype:='dso';
       end;
       extfn:=Fcurrentconfig;
       config:=TXMLConfig.Create(self);
       config.Filename:=extfn;
       config.SetValue('VOcat/catalog/objtype',objtype);
       config.SetValue('VOcat/update/fullcat',FullDownload.Checked);
       config.DeletePath('VOcat/data');
       config.SetValue('VOcat/data/sizeposition',-1);
       for i:=0 to VO_TableData1.FieldList.Count-1 do
         if VO_TableData1.FieldList[i]=SizeField.Text then begin
           config.SetValue('VOcat/data/sizeposition',i);
           break;
         end;
       config.SetValue('VOcat/data/magposition',-1);
       for i:=0 to VO_TableData1.FieldList.Count-1 do
         if VO_TableData1.FieldList[i]=MagField.Text then begin
           config.SetValue('VOcat/data/magposition',i);
           break;
         end;
       config.SetValue('VOcat/data/nameposition',-1);
       for i:=0 to VO_TableData1.FieldList.Count-1 do
         if VO_TableData1.FieldList[i]=NameField.Text then begin
           config.SetValue('VOcat/data/nameposition',i);
           break;
         end;
       config.SetValue('VOcat/data/nameprefix',nameprefix);
       config.SetValue('VOcat/plot/maxmag',-99);
       config.SetValue('VOcat/plot/drawtype',drawtype);
       config.SetValue('VOcat/plot/drawcolor',drawcolor);
       config.SetValue('VOcat/plot/forcecolor',forcecolor);
       config.SetValue('VOcat/default/defsize',DefSize.Value);
       config.SetValue('VOcat/default/defmag',DefMag.Value);
       config.DeletePath('VOcat/fields');
       config.SetValue('VOcat/fields/fieldcount',VO_TableData1.FieldList.Count);
       for i:=0 to VO_TableData1.FieldList.Count-1 do
           config.SetValue('VOcat/fields/field_'+inttostr(i),VO_TableData1.FieldList[i]);
       config.Flush;
       config.free;
   end;
finally
screen.Cursor:=crDefault;
CloseTimer.Enabled:=true;
end;
end;

procedure Tf_voconfig.PreviewData(Sender: TObject);
var coordselection, objtype: string;
    i: integer;
const previewmax=50;
begin
screen.Cursor:=crHourGlass;
try
ClearDataGrid;
if sender is Tf_vodetail then
   with sender as Tf_vodetail do begin
       VO_TableData1.vo_type:=VO_Detail1.vo_type;
       VO_TableData1.BaseUrl:=stringreplace(VO_Detail1.BaseUrl,VO_Detail1.CatalogName+'/*',tn.Caption,[]);
       VO_TableData1.SelectCoord:=not FullDownload.Checked;
       VO_TableData1.ra:=rad2deg*ra;
       VO_TableData1.dec:=rad2deg*dec;
       VO_TableData1.fov:=rad2deg*fov;
       if VO_TableData1.SelectCoord then
           coordselection:='RA:'+formatfloat(f2,ra/15)+' DEC:'+formatfloat(f2,dec)+' FOV:'+formatfloat(f2,fov)
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
       VO_TableData1.GetData(tn.Caption,objtype,true);
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
