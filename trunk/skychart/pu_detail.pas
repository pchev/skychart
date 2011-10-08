unit pu_detail;

{$MODE Delphi}{$H+}

{
Copyright (C) 2002 Patrick Chevalley

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

You should have received a EditCopy of the GNU General Public License
along with this program; if not, write to the Free Software
Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
}
{
 Detail display form
}

interface

uses u_help, u_translation, u_util, u_constant, Clipbrd,
  LCLIntf, SysUtils, Classes, Graphics, Controls, Forms, FileUtil,
  Dialogs, StdCtrls, ComCtrls, ExtCtrls, Menus, StdActns, ActnList, LResources,
  Buttons, LazHelpHTML, Htmlview, Htmlsubs, types;

type
  Tstr1func = procedure(txt:string) of object;

  { Tf_detail }

  Tf_detail = class(TForm)
    Button4: TButton;
    ComboBox1: TComboBox;
    EditCopy: TAction;
    HTMLViewer1: THTMLViewer;
    SelectAll: TAction;
    Panel1: TPanel;
    Button1: TButton;
    ActionList1: TActionList;
    PopupMenu1: TPopupMenu;
    SelectAll1: TMenuItem;
    Copy1: TMenuItem;
    Button2: TButton;
    Button3: TButton;
    Timer1: TTimer;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure EditCopyExecute(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure HTMLViewer1ImageRequest(Sender: TObject; const SRC: string;
      var Stream: TMemoryStream);
    procedure SelectAllExecute(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private
    { Private declarations }
    FCenter : Tstr1func;
    FNeighbor : Tstr1func;
    FHTMLText: String;
    procedure SetHTMLText(const value: string);
  public
    { Public declarations }
    source_chart:string;
    ra,de: double;
    objname: string;
    InfoUrlNum: integer;
    property text: string read FHTMLText write SetHTMLText;
    property OnCenterObj: Tstr1func read FCenter write FCenter;
    property OnNeighborObj: Tstr1func read FNeighbor write FNeighbor;
    procedure SetLang;
  end;

var
  f_detail: Tf_detail;

implementation
{$R *.lfm}

procedure Tf_detail.SetLang;
begin
Caption:=rsDetails;
Button1.caption:=rsClose;
Button2.caption:=rsCenterObject;
Button3.caption:=rsNeighbor;
Button4.Caption:=rsSearch;
SelectAll1.caption:=rsSelectAll;
Copy1.caption:=rsCopy;
SetHelp(self,hlpInfo);
end;

procedure Tf_detail.Button1Click(Sender: TObject);
begin
close;
end;

procedure Tf_detail.Button2Click(Sender: TObject);
begin
if assigned(FCenter) then FCenter(source_chart);
end;

procedure Tf_detail.Button3Click(Sender: TObject);
begin
if assigned(FNeighbor) then FNeighbor(source_chart);
end;

procedure Tf_detail.Button4Click(Sender: TObject);
var i: integer;
    url,sra,sde,n: string;
begin
  i:=ComboBox1.ItemIndex+1;
  if i>infoname_maxurl then begin
    i:=i-infoname_maxurl;
    url:=infocoord_url[i,1];
    sra:=trim(ARtoStr(rad2deg*ra/15));
    sde:=trim(DEToStr3(rad2deg*de));
    if (Copy(sde,1,1)<>'-') then sde:='%2b'+sde;
    case i of
      1 : url:=url+sra+'%20'+sde;            // simbad
      2 : url:=url+'&lon='+sra+'&lat='+sde;  // ned
      3 : url:=url+sra+'%20'+sde;            // hyperleda
    end;
  end else begin
    n:=StringReplace(objname,' ','%20',[rfReplaceAll]);
    n:=StringReplace(n,'+','%2b',[rfReplaceAll]);
    n:=StringReplace(n,'.','%20',[rfReplaceAll]);
    url:=infoname_url[i,1]+n;
  end;
  ExecuteFile(url);
end;

procedure Tf_detail.EditCopyExecute(Sender: TObject);
var buf: string;
begin
  if HTMLViewer1.SelLength=0 then HTMLViewer1.SelectAll;
  buf:=HTMLViewer1.SelText;
  Clipboard.AsText:=buf;
end;

procedure Tf_detail.FormShow(Sender: TObject);
begin
  {$ifdef darwin}   { TODO : Check Mac OS X Bringtofront when called from popupmenu }
  timer1.Enabled:=true;
  {$endif}
end;

procedure Tf_detail.HTMLViewer1ImageRequest(Sender: TObject; const SRC: string; var Stream: TMemoryStream);
var png: TPortableNetworkGraphic;
    bmp: TBitmap;
begin
  // bmp and jpg load nativelly.
  if LowerCase(ExtractFileExt(src))='.png' then begin
    Stream:=TMemoryStream.Create;
    bmp:=TBitmap.Create;
    png:=TPortableNetworkGraphic.Create;
    png.LoadFromFile(systoutf8(src));
    bmp.Assign(png);
    bmp.SaveToStream(Stream);
    Stream.position:=0;
    bmp.free;
    png.free;
  end;
end;

procedure Tf_detail.Timer1Timer(Sender: TObject);
begin
  timer1.Enabled:=false;
  BringToFront;
end;

procedure Tf_detail.SelectAllExecute(Sender: TObject);
begin
  HTMLViewer1.SelectAll;
end;

procedure Tf_detail.FormCreate(Sender: TObject);
var i: integer;
begin
SetLang;
ComboBox1.Items.Clear;
for i:=1 to infoname_maxurl do
  if infoname_url[i,2]<>'' then
    ComboBox1.Items.Add(infoname_url[i,2]);
for i:=1 to infocoord_maxurl do
  if infocoord_url[i,2]<>'' then
    ComboBox1.Items.Add(infocoord_url[i,2]);
ComboBox1.ItemIndex:=InfoUrlNum;
end;

procedure Tf_detail.SetHTMLText(const value: string);
begin
  HTMLViewer1.Clear;
  HTMLViewer1.ClearHistory;
  HTMLViewer1.LoadFromString(value);
end;

end.
