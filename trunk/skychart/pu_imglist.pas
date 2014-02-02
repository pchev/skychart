unit pu_imglist;

{$mode objfpc}{$H+}

interface

uses u_help, u_translation, cu_fits, u_constant,
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  CheckLst, StdCtrls, Menus;

type

    TSendImageFits = procedure(client,imgname,imgid,url: string) of object;

  { Tf_imglist }

  Tf_imglist = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    Button6: TButton;
    CheckListBox1: TCheckListBox;
    ComboBox1: TComboBox;
    ViewHeader: TMenuItem;
    Panel1: TPanel;
    PopupMenu1: TPopupMenu;
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure CheckListBox1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormShow(Sender: TObject);
    procedure ViewHeaderClick(Sender: TObject);
  private
    { private declarations }
    FFits: TFits;
    ListIndex: integer;
    FSendImageFits: TSendImageFits;
  public
    { public declarations }
    procedure SetLang;
    property Fits: TFits read FFits write FFits;
    property onSendImageFits: TSendImageFits read FSendImageFits write FSendImageFits;
  end;

var
  f_imglist: Tf_imglist;

implementation

{$R *.lfm}

procedure Tf_imglist.CheckListBox1MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  APoint: TPoint;
begin
APoint.X := X;
APoint.Y := Y;
ListIndex := CheckListBox1.ItemAtPos(APoint, True);
if ListIndex>=CheckListBox1.Items.Count then ListIndex:=CheckListBox1.Items.Count-1;
if (ListIndex<0) then exit;
CheckListBox1.Selected[ListIndex];
Application.ProcessMessages;
if Button = mbRight then begin
  PopupMenu1.PopUp;
end;
end;

procedure Tf_imglist.Button5Click(Sender: TObject);
var cn,client,imgname,imgid,url: string;
    i: integer;
begin
client:='';
cn:=ComboBox1.Text;
for i:=0 to SampClientName.Count-1 do begin
    if SampClientName[i]=cn then begin
      client:=SampClientId[i];
      break;
    end;
end;
if ListIndex>=CheckListBox1.Items.Count then ListIndex:=CheckListBox1.Items.Count-1;
if (ListIndex<0) then exit;
imgname:=ExtractFileNameOnly(CheckListBox1.Items[ListIndex]);
imgid:='skychart_'+imgname;
url:='file://'+CheckListBox1.Items[ListIndex];
if assigned(FSendImageFits) then FSendImageFits(client,imgname,imgid,url);
end;

procedure Tf_imglist.Button6Click(Sender: TObject);
begin
  ShowHelp;
end;

procedure Tf_imglist.FormShow(Sender: TObject);
var i: integer;
begin
  SetLang;
  ListIndex:=0;
  if SampConnected then begin
    ComboBox1.Enabled:=true;
    button5.Enabled:=true;
    ComboBox1.Clear;
    ComboBox1.Items.Add(rsAllSAMPClien);
    for i:=0 to SampClientName.Count-1 do begin
       if SampClientTableLoadVotable[i]='1' then begin
         ComboBox1.Items.Add(SampClientName[i]);
       end;
    end;
    ComboBox1.ItemIndex:=0;
   end else begin
      ComboBox1.Clear;
      ComboBox1.Items.Add(rsAllSAMPClien);
      ComboBox1.ItemIndex:=0;
      ComboBox1.Enabled:=false;
      button5.Enabled:=false;
  end;
end;

procedure Tf_imglist.ViewHeaderClick(Sender: TObject);
begin
if ListIndex>=CheckListBox1.Items.Count then ListIndex:=CheckListBox1.Items.Count-1;
if (ListIndex<0) then exit;
FFits.FileName:=utf8tosys(CheckListBox1.Items[ListIndex]);
FFits.ViewHeaders;
end;

procedure Tf_imglist.SetLang;
begin
Caption:=rsImageList;
Button1.Caption:=rsOK;
Button2.Caption:=rsCancel;
Button3.Caption:=rsSetup;
Button4.Caption:=rsViewHeader;
Button5.Caption:=rsSendImageTo;
Button6.Caption:=rsHelp;
ViewHeader.Caption:=rsViewHeader;
SetHelp(self,hlpImgList);
end;

end.

