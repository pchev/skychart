unit pu_detail;

{$MODE Delphi}{$H+}

{
Copyright (C) 2002 Patrick Chevalley

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

You should have received a EditCopy of the GNU General Public License
along with this program; if not, write to the Free Software
Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
}
{
 Detail display form
}

interface

uses
  u_help, u_translation, u_util, u_constant, pu_info, Clipbrd, UScaleDPI, LCLVersion, synacode, u_grappavar,
  LCLIntf, SysUtils, Classes, Graphics, Controls, Forms, LazUTF8, LazFileUtils, IpHtml, Ipfilebroker,
  Dialogs, StdCtrls, ComCtrls, ExtCtrls, Menus, StdActns, ActnList, LResources,
  Buttons, LazHelpHTML_fix, types;

type
  Tstr1func = procedure(txt: string) of object;

  { Tf_detail }

  Tf_detail = class(TForm)
    Button4: TButton;
    EditCopy: TAction;
    IpHtmlDataProvider1: TIpHtmlDataProvider;
    IpHtmlPanel1: TIpHtmlPanel;
    Memo1: TMemo;
    PageControl1: TPageControl;
    SelectAll: TAction;
    Panel1: TPanel;
    Button1: TButton;
    ActionList1: TActionList;
    PopupMenu1: TPopupMenu;
    SelectAll1: TMenuItem;
    Copy1: TMenuItem;
    Button2: TButton;
    Button3: TButton;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    Timer1: TTimer;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure EditCopyExecute(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
    procedure FormShow(Sender: TObject);
    procedure HTMLGetImageX(Sender: TIpHtmlNode; const URL: string;
      var Picture: TPicture);
    procedure IpHtmlPanel1HotClick(Sender: TObject);
    procedure SelectAllExecute(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private
    { Private declarations }
    LockText, CanRetry: boolean;
    FCenter: Tstr1func;
    FNeighbor, FVarNeighbor: Tstr1func;
    FHTMLText: string;
    FTextOnly: boolean;
    FSameposition: boolean;
    Fkeydown: TKeyEvent;
    FHtmlFontSize: integer;
    FSetPos: integer;
    procedure SetTextOnly(value: boolean);
    procedure SetHTMLText(const Value: string);
    procedure ShowVarType(t:string);
    function FindVarType(t:string):string;
    function FindVarSubType(t:string):string;
  public
    { Public declarations }
    source_chart: string;
    ra, de: double;
    objname: string;
    InfoUrlNum: integer;
    property Text: string read FHTMLText write SetHTMLText;
    property TextOnly: boolean read FTextOnly write SetTextOnly;
    property HtmlFontSize: integer read FHtmlFontSize write FHtmlFontSize;
    property Sameposition: boolean read FSameposition write FSameposition;
    property OnCenterObj: Tstr1func read FCenter write FCenter;
    property OnNeighborObj: Tstr1func read FNeighbor write FNeighbor;
    property OnVarNeighborObj: Tstr1func read FVarNeighbor write FVarNeighbor;
    property OnKeydown: TKeyEvent read Fkeydown write Fkeydown;
    procedure SetLang;
  end;

var
  f_detail: Tf_detail;

implementation

{$if (lcl_major>=3)}
uses IpHtmlNodes;
{$endif}

{$R *.lfm}

procedure Tf_detail.SetLang;
begin
  Caption := rsDetails;
  Button1.Caption := rsClose;
  Button2.Caption := rsCenterObject;
  Button3.Caption := rsNeighbor;
  SelectAll1.Caption := rsSelectAll;
  Copy1.Caption := rsCopy;
  SetHelp(self, hlpInfo);
end;

procedure Tf_detail.Button1Click(Sender: TObject);
begin
  Close;
end;

procedure Tf_detail.Button2Click(Sender: TObject);
begin
  if assigned(FCenter) then
    FCenter(source_chart);
end;

procedure Tf_detail.Button3Click(Sender: TObject);
begin
  if assigned(FNeighbor) then
    FNeighbor(source_chart);
end;

procedure Tf_detail.Button4Click(Sender: TObject);
begin
  if assigned(FVarNeighbor) then
    FVarNeighbor(source_chart);
end;

procedure Tf_detail.IpHtmlPanel1HotClick(Sender: TObject);
var
  NodeA: TIpHtmlNodeA;
  src: string;
  i: integer;
  url, sra, sde, dra, dde, n: string;
begin
  if IpHtmlPanel1.HotNode is TIpHtmlNodeA then
  begin
    NodeA := TIpHtmlNodeA(IpHtmlPanel1.HotNode);
    src := NodeA.HRef;
    if copy(src,1,7)='VarType' then
    begin
      ShowVarType(copy(src,8,99));
      exit;
    end;
    if copy(src,1,4)='Link' then
    begin
      url:=trim(copy(src,5,999));
      ExecuteFile(url);
      exit;
    end;
    if (copy(src,1,7)='http://')or(copy(src,1,8)='https://') then
    begin
      url:=trim(src);
      ExecuteFile(url);
      exit;
    end;
    i := strtointdef(src, -1);
    if i > 0 then
    begin
      if i > infoname_maxurl then
      begin
        i := i - infoname_maxurl;
        dra := trim(FormatFloat(f6,rad2deg * ra));
        dde := trim(FormatFloat(f6,rad2deg * de));
        sra := trim(ARtoStr(rad2deg * ra / 15));
        sde := trim(DEToStr3(rad2deg * de));
        if (Copy(sde, 1, 1) <> '-') then
          sde := '%2b' + sde;
        url := infocoord_url[i, 1];
        url := StringReplace(url, '$RA', sra, []);
        url := StringReplace(url, '$DE', sde, []);
        url := StringReplace(url, '$DRA', dra, []);
        url := StringReplace(url, '$DDE', dde, []);
      end
      else
      begin
        n := objname;
        if pos('BSC', n) = 1 then
          Delete(n, 1, 3);
        if pos('Sky', n) = 1 then
          Delete(n, 1, 3);
        if copy(n,1,6)='UCAC4-' then
          n[6]:=' ';
        n := EncodeURLElement(n);
        url := infoname_url[i, 1];
        url := StringReplace(url, '$ID', n, []);
      end;
    end
    else
      url:=src;
    ExecuteFile(url);
  end;
end;


procedure Tf_detail.EditCopyExecute(Sender: TObject);
begin
  IpHtmlPanel1.CopyToClipboard;
end;

procedure Tf_detail.FormKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
begin
  if assigned(Fkeydown) then
    Fkeydown(Sender, Key, Shift);
end;

procedure Tf_detail.FormShow(Sender: TObject);
begin
  CanRetry:=true;
  FSameposition := False;
  FSetPos := 0;
  Button4.Visible:=GrappavarOpen;
end;

procedure Tf_detail.HTMLGetImageX(Sender: TIpHtmlNode; const URL: string;
  var Picture: TPicture);
var
  urlutf8: UTF8String;
begin
  urlutf8 := SysToUTF8(URL);
  if FileExistsUTF8(urlutf8) then
  begin
    if Picture = nil then
      Picture := TPicture.Create;
    try
      Picture.LoadFromFile(urlutf8);
      // disable transparency
      Picture.Bitmap.TransparentMode := tmFixed;
      Picture.Bitmap.TransparentColor := clNone;
    except
      Picture.Free;
      Picture := nil;
    end;
  end;
end;

procedure Tf_detail.Timer1Timer(Sender: TObject);
begin
  timer1.Enabled := False;
  IpHtmlPanel1.VScrollPos := FSetPos;
end;

procedure Tf_detail.SelectAllExecute(Sender: TObject);
begin
  IpHtmlPanel1.SelectAll;
end;

procedure Tf_detail.FormCreate(Sender: TObject);
begin
  ScaleDPI(Self);
  FTextOnly := False;
  PageControl1.ActivePageIndex:=1;
  LockText := False;
  SetLang;
end;

procedure Tf_detail.SetTextOnly(value: boolean);
begin
  FTextOnly:=value;
  if FTextOnly then
    PageControl1.ActivePageIndex:=0
  else
    PageControl1.ActivePageIndex:=1;
end;

procedure Tf_detail.SetHTMLText(const Value: string);
var
  sstream: TStringStream;
  p: integer;
begin
if LockText then exit;
try
  LockText := True;
  if FTextOnly then
  begin
    memo1.Clear;
    memo1.Text := striphtml(Value);
  end
  else
  begin
    sstream := TStringStream.Create(Value);
    try
    p := IpHtmlPanel1.VScrollPos;  // save old position
    IpHtmlPanel1.DefaultFontSize := FHtmlFontSize;  // HTML font is already sized for DPI
    IpHtmlPanel1.SetHtmlFromStream(sstream);
    sstream.Free;
    if FSameposition then
    begin
      FSetPos := p;
    end
    else begin
      FSetPos := 0;
    end;
    CanRetry:=true;
    Timer1.Enabled := True;
    except
      if CanRetry then begin
        // uncorrectable error condition in IpHtmlPanel1, try to create a new one and retry.
        IpHtmlPanel1 := TIpHtmlPanel.Create(self);
        IpHtmlPanel1.Parent:=TabSheet2;
        IpHtmlPanel1.Align := alClient;
        IpHtmlPanel1.DataProvider := IpHtmlDataProvider1;
        IpHtmlPanel1.FixedTypeface := 'Courier New';
        IpHtmlPanel1.DefaultTypeFace := 'default';
        IpHtmlPanel1.DefaultFontSize := 12;
        IpHtmlPanel1.FlagErrors := False;
        IpHtmlPanel1.PopupMenu := PopupMenu1;
        IpHtmlPanel1.TabOrder := 1;
        IpHtmlPanel1.OnHotClick := IpHtmlPanel1HotClick;
        Canretry:=False;
        LockText := False;
        SetHTMLText(Value);
      end
      else begin
        // fail again, set to text display
        TextOnly:=true;
        LockText := False;
        SetHTMLText(Value);
      end;
      try
       sstream.Free;
      except
      end;
    end;
  end;
finally
 LockText := False;
end;
end;

procedure Tf_detail.ShowVarType(t:string);
var txt: string;
begin
  txt:=FindVarType(t);
  if trim(txt)<>'' then begin
    f_info.setpage(3);
    f_info.TitlePanel.Caption :='Variable star type '+trim(t);
    f_info.Button1.Caption := rsClose;
    f_info.InfoMemo.Text:=txt;
    f_info.show;
  end;
end;

function Tf_detail.FindVarType(t:string):string;
var i: integer;
  buf: string;
  tt: TStringList;
begin
  tt:=TStringList.Create;
  try
  t:=trim(t);
  result:=t+crlf+crlf;
  SplitRec2(t,'+',tt);
  if tt.count>1 then begin
    for i:=0 to tt.Count-1 do begin
      result:=result+FindVarType(tt[i]);
      if i<(tt.count-1) then result:=result+'And'+crlf+crlf;
    end;
    exit;
  end;
  t:=tt[0];
  SplitRec2(t,'|',tt);
  if tt.count>1 then begin
    for i:=0 to tt.Count-1 do begin
      result:=result+FindVarType(tt[i]);
      if i<(tt.count-1) then result:=result+'Or'+crlf+crlf;
    end;
    exit;
  end;
  t:=tt[0];
  if pos(':',t)>0 then
    result:='Classification is uncertain'+crlf+crlf
  else
    result:='';
  t:=StringReplace(t,':','',[rfReplaceAll]);
  for i:=0 to Length(vartype)-1 do begin
    if vartype[i].code=t then begin
      result:=result+t+crlf+vartype[i].desc+crlf+crlf;
      break;
    end;
  end;
  SplitRec2(t,'/',tt);
  if tt.count>1 then begin
    t:=tt[0];
    t:=StringReplace(t,':','',[rfReplaceAll]);
    for i:=0 to Length(vartype)-1 do begin
      if vartype[i].code=t then begin
        result:=result+t+crlf+vartype[i].desc+crlf+crlf;
        break;
      end;
    end;
    if tt.count>1 then begin
      for i:=1 to tt.Count-1 do begin
        buf:=FindVarSubType(tt[i]);
        if trim(buf)='' then buf:=FindVarType(tt[i]);
        result:=result+buf+crlf+crlf;
      end;
      exit;
    end;
  end;
  finally
   tt.free;
  end;
end;

function Tf_detail.FindVarSubType(t:string):string;
var i: integer;
begin
  t:=StringReplace(t,':','',[rfReplaceAll]);
  result:='';
  for i:=0 to Length(varsubtype)-1 do begin
    if varsubtype[i].code=t then begin
      result:=t+crlf+varsubtype[i].desc;
      break;
    end;
  end;
end;

end.
