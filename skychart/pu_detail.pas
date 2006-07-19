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

You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software
Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
}
{
 Detail display form
}

interface

uses u_translation, u_util,
  LCLIntf, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, ExtCtrls, Menus, StdActns, ActnList, LResources,
  Buttons, SynEdit, IpHtml;

type
  Tstr1func = procedure(txt:string) of object;

  { Tf_detail }

  Tf_detail = class(TForm)
    IpHtmlPanel1: TIpHtmlPanel;
    Panel1: TPanel;
    Button1: TButton;
    ActionList1: TActionList;
    EditSelectAll1: TEditSelectAll;
    EditCopy1: TEditCopy;
    PopupMenu1: TPopupMenu;
    SelectAll1: TMenuItem;
    Copy1: TMenuItem;
    Button2: TButton;
    Button3: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure EditCopy1Execute(Sender: TObject);
    procedure EditSelectAll1Execute(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    FCenter : Tstr1func;
    FNeighbor : Tstr1func;
    FHTMLText: String;
    procedure SetHTMLText(const value: string);
  public
    source_chart:string;
    { Public declarations }
    property text: string read FHTMLText write SetHTMLText;
    property OnCenterObj: Tstr1func read FCenter write FCenter;
    property OnNeighborObj: Tstr1func read FNeighbor write FNeighbor;
    procedure SetLang;
  end;

var
  f_detail: Tf_detail;

implementation

procedure Tf_detail.SetLang;
begin
Caption:=rsDetails;
Button1.caption:=rsClose;
Button2.caption:=rsCenterObject;
Button3.caption:=rsNeighbor;
SelectAll1.caption:=rsSelectAll;
Copy1.caption:=rsCopy;
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

procedure Tf_detail.EditCopy1Execute(Sender: TObject);
begin
  IpHtmlPanel1.CopyToClipboard;
end;

procedure Tf_detail.EditSelectAll1Execute(Sender: TObject);
begin
  IpHtmlPanel1.SelectAll;
end;

procedure Tf_detail.FormCreate(Sender: TObject);
begin
SetLang;
{$ifdef win32}
 ScaleForm(self,Screen.PixelsPerInch/96);
{$endif}
end;

procedure Tf_detail.SetHTMLText(const value: string);
var
  s: TStringStream;
  NewHTML: TIpHtml;
begin
  try
    s:=TStringStream.Create(value);
    try
      NewHTML:=TIpHtml.Create; // Beware: Will be freed automatically by IpHtmlPanel1
      NewHTML.LoadFromStream(s);
    finally
      FHTMLText:=value;
      s.Free;
    end;
    IpHtmlPanel1.SetHtml(NewHTML);
  except
  end;
end;

initialization
  {$i pu_detail.lrs}

end.
