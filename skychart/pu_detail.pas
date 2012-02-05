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

uses u_help, u_translation, u_util, u_constant,
  LCLIntf, SysUtils, Classes, Graphics, Controls, Forms, FileUtil,
  Dialogs, StdCtrls, ComCtrls, ExtCtrls, Menus, StdActns, ActnList, LResources,
  Buttons, LazHelpHTML, IpHtml, types;

type
  TSimpleIpHtml = class(TIpHtml)
  public
    property OnGetImageX;
  end;

type
  Tstr1func = procedure(txt:string) of object;

  { Tf_detail }

  Tf_detail = class(TForm)
    EditCopy: TAction;
    IpHtmlPanel1: TIpHtmlPanel;
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
    procedure EditCopyExecute(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure IpHtmlPanel1HotClick(Sender: TObject);
    procedure SelectAllExecute(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private
    { Private declarations }
    FCenter : Tstr1func;
    FNeighbor : Tstr1func;
    FHTMLText: String;
    procedure SetHTMLText(const value: string);
    procedure HTMLGetImageX(Sender: TIpHtmlNode; const URL: string; var Picture: TPicture);
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

procedure Tf_detail.IpHtmlPanel1HotClick(Sender: TObject);
var
  NodeA: TIpHtmlNodeA;
  i: integer;
  src,url,sra,sde,n: string;
begin
  if IpHtmlPanel1.HotNode is TIpHtmlNodeA then begin
    NodeA:=TIpHtmlNodeA(IpHtmlPanel1.HotNode);
    src:=NodeA.HRef;
    i:=strtointdef(src,-1);
    if i>0 then begin
      if i>infoname_maxurl then begin
        i:=i-infoname_maxurl;
        sra:=trim(ARtoStr(rad2deg*ra/15));
        sde:=trim(DEToStr3(rad2deg*de));
        if (Copy(sde,1,1)<>'-') then sde:='%2b'+sde;
        url:=infocoord_url[i,1];
        url:=StringReplace(url,'$RA',sra,[]);
        url:=StringReplace(url,'$DE',sde,[]);
      end else begin
        n:=objname;
        if pos('BSC',n)=1 then Delete(n,1,3);
        if pos('Sky',n)=1 then Delete(n,1,3);
        n:=StringReplace(n,' ','%20',[rfReplaceAll]);
        n:=StringReplace(n,'+','%2b',[rfReplaceAll]);
        n:=StringReplace(n,'.','%20',[rfReplaceAll]);
        url:=infoname_url[i,1];
        url:=StringReplace(url,'$ID',n,[]);
      end;
      ExecuteFile(url);
    end;
  end;
end;

procedure Tf_detail.EditCopyExecute(Sender: TObject);
var buf: string;
begin
if not IpHtmlPanel1.HaveSelection then IpHtmlPanel1.SelectAll;
IpHtmlPanel1.CopyToClipboard;
end;

procedure Tf_detail.FormShow(Sender: TObject);
begin
  {$ifdef darwin}   { TODO : Check Mac OS X Bringtofront when called from popupmenu }
  timer1.Enabled:=true;
  {$endif}
end;


procedure Tf_detail.Timer1Timer(Sender: TObject);
begin
  timer1.Enabled:=false;
  BringToFront;
end;

procedure Tf_detail.SelectAllExecute(Sender: TObject);
begin
  IpHtmlPanel1.SelectAll;
  IpHtmlPanel1.Invalidate;
end;

procedure Tf_detail.FormCreate(Sender: TObject);
begin
SetLang;
end;

procedure Tf_detail.SetHTMLText(const value: string);
var s: TStringStream;
  NewHTML: TSimpleIpHtml;
begin
  try
    s:=TStringStream.Create(value);
    try
      NewHTML:=TSimpleIpHtml.Create; // Beware: Will be freed automatically by IpHtmlPanel1
      NewHTML.OnGetImageX:=HTMLGetImageX;
      NewHTML.LoadFromStream(s);
    finally
      FHTMLText:=value;
      s.Free;
    end;
    IpHtmlPanel1.SetHtml(NewHTML);
  except
  end;
end;

procedure Tf_detail.HTMLGetImageX(Sender: TIpHtmlNode; const URL: string; var Picture: TPicture);
var
  PicCreated: boolean;
  bmp:tbitmap;
  Stream: TMemoryStream;
  png: TPortableNetworkGraphic;
  jpg: TJPEGImage;
  src,ext: string;
begin
  try
    src:=SysToUTF8(url);
    if FileExistsUTF8(src) then begin
      PicCreated := False;
      if Picture=nil then begin
        Picture:=TPicture.Create;
        PicCreated := True;
      end;
      ext:=uppercase(ExtractFileExt(src));
      bmp:=TBitmap.Create;
      png:=TPortableNetworkGraphic.Create;
      jpg:=TJPEGImage.Create;
      Stream:=TMemoryStream.Create;
      try
        if ext='.PNG' then begin
           png.LoadFromFile(src);
           bmp.Assign(png);
        end;
        if ext='.JPG' then begin
           jpg.LoadFromFile(src);
           bmp.Assign(jpg);
        end;
        if ext='.BMP' then begin
           bmp.LoadFromFile(src);
        end;
        if not bmp.Empty then begin
          bmp.Canvas.Pen.Color:=clFuchsia;
          bmp.Canvas.Pen.Width:=1;
          bmp.Canvas.Pen.Mode:=pmCopy;
          bmp.Canvas.Brush.Style:=bsClear;
          bmp.Canvas.Rectangle(0,0,bmp.Width,bmp.Height);
          bmp.SaveToStream(Stream);
          Stream.position:=0;
          Picture.LoadFromStream(stream);
        end else begin
          if PicCreated then
            Picture.Free;
          Picture := nil;
        end;
      finally
        bmp.free;
        png.free;
        jpg.free;
        Stream.Free;
      end;
    end;
  except
    if PicCreated then
      Picture.Free;
    Picture := nil;
  end;
end;


end.
