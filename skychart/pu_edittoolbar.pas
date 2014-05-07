unit pu_edittoolbar;

{
Copyright (C) 2014 Patrick Chevalley

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
 Tool bar editor for CDC/Skychart
}

{$mode objfpc}{$H+}

interface

uses u_constant, u_translation,  u_help,
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ComCtrls,
  ActnList, ExtCtrls, StdCtrls, PairSplitter, Buttons;

type

  { Tf_edittoolbar }

  Tf_edittoolbar = class(TForm)
    ButtonHelp: TButton;
    ButtonClear: TBitBtn;
    ButtonDown: TBitBtn;
    ButtonUp: TBitBtn;
    ButtonDel: TBitBtn;
    ButtonAdd: TBitBtn;
    ButtonCollapse: TBitBtn;
    ButtonExpand: TBitBtn;
    ButtonEmpty: TButton;
    ButtonMini: TButton;
    ButtonStd: TButton;
    ButtonOK: TButton;
    ButtonCancel: TButton;
    ComboBox1: TComboBox;
    Label1: TLabel;
    PanelRtop: TPanel;
    PanelLtop: TPanel;
    PanelLbot: TPanel;
    PanelCentre: TPanel;
    PanelRight: TPanel;
    PanelBottom: TPanel;
    ActionTreeView: TTreeView;
    editbarPanel: TPanel;
    PanelLeft: TPanel;
    procedure ButtonEmptyClick(Sender: TObject);
    procedure ButtonCollapseClick(Sender: TObject);
    procedure ButtonExpandClick(Sender: TObject);
    procedure ButtonMiniClick(Sender: TObject);
    procedure ButtonClearClick(Sender: TObject);
    procedure ButtonDownClick(Sender: TObject);
    procedure ButtonOKClick(Sender: TObject);
    procedure ButtonAddClick(Sender: TObject);
    procedure ButtonDelClick(Sender: TObject);
    procedure ButtonStdClick(Sender: TObject);
    procedure ButtonUpClick(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormResize(Sender: TObject);
  private
    { private declarations }
    numaction,numcontrol,numeditbar: integer;
    FTBOnMouseUp: TMouseEvent;
    Fimages: TImageList;
    FDisabledContainer: TWinControl;
    editbar: array of TToolBar;
    ToolbarTreeview: array of TTreeView;
    editAction: array of TActionList;
    editActionTxt: array of string;
    editControl: array of TControl;
    editControlTxt: array of string;
    editControlImg: array of integer;
    editControlCat: array of string;
    editControlGroup: array of string;
    defaultact, defaultbar: string;
    procedure SetImages(value: TImageList);
    function AddBtn(pos:TTreeNode; act: string; barnum,imgix: integer):TTreeNode;
    procedure ClearToolbarTree(bn:integer);
    function GetControlName(capt:string):string;
    function GetControlCaption(nam:string):string;
  public
    { public declarations }
    DividerTxt, SeparatorTxt: string;

    // Clear the action list
    procedure ClearAction;

    // Clear the other control list
    procedure ClearControl;

    // Clear the editable toolbar
    procedure ClearToolbar;

    // Add an action list
    procedure AddAction(value:TActionList; txt:string);

    // Add an other control
    procedure AddOtherControl(value:TControl; txt,cat,group:string; imgindex:integer);

    // Add a toolbar to edit
    procedure AddToolbar(value:TToolBar);

    // Fill the left tree with the available action list and other control
    procedure ProcessActions;

    // Update the toolbar using the right tree
    procedure ActivateToolbar;

    // Save the right tree
    procedure SaveToolbar(bn:integer; str:TStringList);

    // Load the right tree
    procedure LoadToolbar(bn:integer; str:TStringList);

    // Load the right tree using the current toolbar components
    procedure LoadFromToolbar;

    // the imagelist to use for all the buttons
    property Images: TImageList read Fimages write SetImages;

    // set the action to expand by default in the left tree
    property DefaultAction: string read defaultact write defaultact;

    // set the toolbar to show by default in the right tree
    property DefaultToolbar: string read defaultbar write defaultbar;

    // The container for the other objects removed from the toolbar
    property DisabledContainer: TWinControl read FDisabledContainer write FDisabledContainer;

    // add a mouseup event to each toolbutton (to process the right click)
    property TBOnMouseUp: TMouseEvent read FTBOnMouseUp write FTBOnMouseUp;
    procedure SetLang;
  end;

var
  f_edittoolbar: Tf_edittoolbar;

const
  sep = ';';

implementation

{$R *.lfm}

{ Tf_edittoolbar }

procedure Tf_edittoolbar.SetLang;
begin
Caption:=rsToolBarEdito;
ButtonOK.caption:=rsOK;
ButtonCancel.caption:=rsCancel;
ButtonHelp.caption:=rsHelp;
Label1.Caption:=rsAvailableAct;
ButtonMini.Caption:=rsMinimal;
ButtonStd.Caption:=rsStandard;
ButtonEmpty.Caption:=rsEmpty;
DividerTxt:=rsDivider;
SeparatorTxt:=rsSeparator;
SetHelp(self,hlpToolbarEditor);
end;

procedure Tf_edittoolbar.SetImages(value: TImageList);
var i: integer;
begin
Fimages:=value;
for i:=0 to numeditbar-1 do ToolbarTreeview[i].Images:=Fimages;
ActionTreeView.Images:=Fimages;
end;

procedure Tf_edittoolbar.ClearToolbar;
var i: integer;
begin
ComboBox1.Clear;
for i:=0 to numeditbar-1 do ToolbarTreeview[i].Free;
numeditbar:=0;
SetLength(editbar,0);
SetLength(ToolbarTreeview,0);
end;

procedure Tf_edittoolbar.ClearAction;
begin
numaction:=0;
SetLength(editAction,0);
SetLength(editActionTxt,0);
end;

procedure Tf_edittoolbar.AddAction(value:TActionList; txt:string);
begin
if value<>nil then begin
  inc(numaction);
  SetLength(editAction,numaction);
  SetLength(editActionTxt,numaction);
  editAction[numaction-1]:=value;
  editActionTxt[numaction-1]:=txt;
end;
end;

procedure Tf_edittoolbar.ClearControl;
begin
numcontrol:=0;
SetLength(editControl,0);
SetLength(editControlTxt,0);
SetLength(editControlCat,0);
SetLength(editControlGroup,0);
end;

procedure Tf_edittoolbar.AddOtherControl(value:TControl; txt,cat,group:string; imgindex:integer);
begin
if value<>nil then begin
  inc(numcontrol);
  SetLength(editControl,numcontrol);
  SetLength(editControlTxt,numcontrol);
  SetLength(editControlImg,numcontrol);
  SetLength(editControlCat,numcontrol);
  SetLength(editControlGroup,numcontrol);
  editControl[numcontrol-1]:=value;
  editControlTxt[numcontrol-1]:=txt;
  editControlImg[numcontrol-1]:=imgindex;
  editControlCat[numcontrol-1]:=cat;
  editControlGroup[numcontrol-1]:=group;
end;
end;

procedure Tf_edittoolbar.AddToolbar(value: TToolBar);
var i:integer;
begin
if value<>nil then begin
  inc(numeditbar);
  SetLength(editbar,numeditbar);
  SetLength(ToolbarTreeview,numeditbar);
  editbar[numeditbar-1]:=value;
  ToolbarTreeview[numeditbar-1]:=TTreeView.Create(self);
  ToolbarTreeview[numeditbar-1].Parent:=editbarpanel;
  ToolbarTreeview[numeditbar-1].Images:=Fimages;
  ToolbarTreeview[numeditbar-1].Align:=alClient;
  ToolbarTreeview[numeditbar-1].ScrollBars:=ssAutoBoth;
  ToolbarTreeview[numeditbar-1].Visible:=(value.Caption=defaultbar);
  i:=ComboBox1.Items.Add(value.Caption);
  if (value.Caption=defaultbar) then ComboBox1.ItemIndex:=i;
end;
end;

procedure Tf_edittoolbar.ComboBox1Change(Sender: TObject);
var i,bn: integer;
begin
bn:=ComboBox1.ItemIndex;
for i:=0 to numeditbar-1 do begin
  ToolbarTreeview[i].Visible:=(i=bn);
end;
end;

procedure Tf_edittoolbar.FormCreate(Sender: TObject);
begin
  numaction:=0;
  numeditbar:=0;
  Setlang;
end;

procedure Tf_edittoolbar.FormResize(Sender: TObject);
begin
PanelRight.Width:=trunc((ClientWidth-PanelCentre.Width)/2);
end;

procedure Tf_edittoolbar.ProcessActions;
var i,k,n: integer;
  catlst: TStringList;
  cat,act: string;
  actnode,cnode: TTreeNode;
begin
if (numeditbar>0) and (numaction>0) then begin
  catlst:=TStringList.Create;
  ActionTreeView.Items.Clear;
  ActionTreeView.FullCollapse;
  ActionTreeView.Images:=Fimages;
  // add separator tools
  actnode:=ActionTreeView.Items.Add(nil,rsTools);
  cnode:=ActionTreeView.Items.AddChild(actnode,rsSeparator);
  with ActionTreeView.Items.AddChild(cnode,DividerTxt) do ImageIndex:=100;
  with ActionTreeView.Items.AddChild(cnode,SeparatorTxt) do ImageIndex:=101;
  for k:=0 to numaction-1 do begin
    // set main actionlist as first level
    actnode:=ActionTreeView.Items.Add(nil,editActionTxt[k]);
    // list categories
    catlst.Clear;
    for i:=0 to editAction[k].ActionCount-1 do begin
      cat:=editAction[k].Actions[i].Category;
      if cat='' then cat:='none';
      n:=catlst.IndexOf(cat);
      if n<0 then catlst.Add(cat);
    end;
    // second tree level is categories
    for i:=0 to catlst.Count-1 do begin
      ActionTreeView.Items.AddChild(actnode,catlst[i]);
    end;
    // add actions by categories
    for i:=0 to editAction[k].ActionCount-1 do begin
      cat:=editAction[k].Actions[i].Category;
      if cat='' then cat:='none';
      act:=TAction(editAction[k].Actions[i]).hint;
      if act='' then continue; // skip action without Hint, they are for internal use (SetFOV*).
      with ActionTreeView.Items.AddChild(actnode.FindNode(cat),act) do begin
        ImageIndex:=TAction(editAction[k].Actions[i]).ImageIndex;
      end;
    end;
    // add other control (non action button)
    for i:=0 to numcontrol-1 do begin
       if editControlGroup[i]=editActionTxt[k] then begin
         cat:=editControlCat[i];
         act:=editControlTxt[i];
         if cat='' then cat:='none';
         with ActionTreeView.Items.AddChild(actnode.FindNode(cat),act)do begin
            ImageIndex:= editControlImg[i];
         end;
       end;
    end;
    if cnode.Count=0 then ActionTreeView.Items.Delete(cnode);
    // expand
    if editActionTxt[k]=defaultact then actnode.Expand(true);
  end;
  catlst.Free;
end;
end;

procedure Tf_edittoolbar.LoadFromToolbar;
var i,j,k: integer;
    cn: string;
    node: TTreeNode;
begin
// add current visible buttons
for k:=0 to numeditbar-1 do begin
  ClearToolbarTree(k);
  ToolbarTreeview[k].Images:=Fimages;
  for i:=0 to editbar[k].ControlCount-1 do begin
    if (editbar[k].Controls[i] is TToolButton) then begin
      // toolbutton
      node:=ActionTreeView.Items.FindNodeWithText(editbar[k].Controls[i].hint);
      if node<>nil then node.Visible:=false;
      with  ToolbarTreeview[k].Items.Add(nil,editbar[k].Controls[i].hint) do begin
         ImageIndex:=TToolButton(editbar[k].Controls[i]).ImageIndex;
      end;
    end else begin
      // other objects
       if numcontrol>0 then begin
         cn:=editbar[k].Controls[i].Caption;
         if cn='' then cn:=editbar[k].Controls[i].Name;
         for j:=0 to numcontrol-1 do begin
           if editbar[k].Controls[i]=editControl[j] then cn:=editControlTxt[j];
         end;
         node:=ActionTreeView.Items.FindNodeWithText(cn);
         if node<>nil then node.Visible:=false;
         with ToolbarTreeview[k].Items.Add(nil,cn) do begin
           ImageIndex:=editControlImg[j]
         end;
       end;
    end;
  end;
end;
end;

procedure Tf_edittoolbar.ButtonOKClick(Sender: TObject);
begin
  ActivateToolbar;
end;

procedure Tf_edittoolbar.SaveToolbar(bn:integer; str:TStringList);
var i,im:integer;
    act,buf: string;
begin
if (bn<numeditbar) then begin
    str.Clear;
    for i:=0 to ToolbarTreeview[bn].Items.Count-1 do begin
      act:=GetControlName(ToolbarTreeview[bn].Items[i].Text);
      im:=ToolbarTreeview[bn].Items[i].ImageIndex;
      buf:=inttostr(im)+sep+act;
      str.add(buf);
    end;
end;
end;

procedure Tf_edittoolbar.LoadToolbar(bn:integer; str:TStringList);
var i,j,im:integer;
    act,buf: string;
    node: TTreeNode;
begin
if (bn<numeditbar) then begin
   ClearToolbarTree(bn);
   for i:=0 to str.Count-1 do begin
     buf:=str[i];
     if buf='' then continue;
     j:=pos(sep,buf);
     if j<=0 then continue;
     im:=strtointdef(copy(buf,1,j-1),0);
     delete(buf,1,j);
     act:=GetControlCaption(buf);
     if (act<>SeparatorTxt)and(act<>DividerTxt) then begin
       node:=ActionTreeView.Items.FindNodeWithText(act);
       if node<>nil then node.Visible:=false;
     end;
     with  ToolbarTreeview[bn].Items.Add(nil,act) do begin
        ImageIndex:=im;
     end;
   end;
end;
end;

function Tf_edittoolbar.GetControlName(capt:string):string;
var j,k: integer;
begin
result:='';
// search action by caption
for k:=0 to numaction-1 do begin
  for j:=0 to editAction[k].ActionCount-1 do begin
    if TAction(editAction[k].Actions[j]).hint=capt then begin
      result:=TAction(editAction[k].Actions[j]).name;
      break;
    end;
  end;
  if result<>'' then break;
end;
// search for a control
if result='' then for k:=0 to numcontrol-1 do begin
  if editControlTxt[k]=capt then begin
    result:=editControl[k].Name;
    break;
  end;
end;
// search for a separator
if (result='') and (capt=SeparatorTxt) then result:='Separator';
if (result='') and (capt=DividerTxt) then result:='Divider';
end;

function Tf_edittoolbar.GetControlCaption(nam:string):string;
var j,k: integer;
begin
result:='';
// search action by name
for k:=0 to numaction-1 do begin
  for j:=0 to editAction[k].ActionCount-1 do begin
    if TAction(editAction[k].Actions[j]).Name=nam then begin
      result:=TAction(editAction[k].Actions[j]).hint;
      break;
    end;
  end;
  if result<>'' then break;
end;
// search for a control
if result='' then for k:=0 to numcontrol-1 do begin
  if editControl[k].Name=nam then begin
    result:=editControlTxt[k];
    break;
  end;
end;
// search for a separator
if (result='') and (nam='Separator') then result:=SeparatorTxt;
if (result='') and (nam='Divider') then result:=DividerTxt;
end;

procedure Tf_edittoolbar.ActivateToolbar;
var i,j,k,n,m,p,lpos,w,h: integer;
    b: TToolButton;
    act: string;
begin
if (numeditbar>0) and  (numaction>0) then begin
  lpos:=10000; // big enough to add to the right
  for p:=0 to numeditbar-1 do begin
    // clear bar
    i:=editbar[p].ButtonCount;
    editbar[p].BeginUpdate;
    i:=editbar[p].ControlCount;
    for i:=editbar[p].ButtonCount-1 downto 0 do begin
       if editbar[p].Buttons[i].Name='Divider_ToolBarMain_end' then continue;
       editbar[p].Buttons[i].Free;
    end;
    for i:=editbar[p].ControlCount-1 downto 0 do begin
      if editbar[p].Controls[i].Name='ChildControl' then continue;
      if editbar[p].Controls[i].Name='Divider_ToolBarMain_end' then continue;
      editbar[p].Controls[i].Visible:=false;
      editbar[p].Controls[i].Parent:=FDisabledContainer;
    end;
    editbar[p].EndUpdate;
    i:=editbar[p].ButtonCount;
    // add buttons
    for i:=0 to ToolbarTreeview[p].Items.Count-1 do begin
      act:=ToolbarTreeview[p].Items[i].Text;
      // search action by caption
      n:=-1;
      for k:=0 to numaction-1 do begin
        for j:=0 to editAction[k].ActionCount-1 do begin
          if TAction(editAction[k].Actions[j]).hint=act then begin
            m:=k;
            n:=j;
            break;
          end;
        end;
        if n>=0 then break;
      end;
      // create button
      if n>=0 then begin
        b:=TToolButton.Create(editbar[p]);
        b.Name:='ToolButton_'+editAction[m].Actions[n].Name;
        b.Parent:=editbar[p];
        b.AutoSize:=true;
        b.Style:=tbsButton;
        b.Action:=editAction[m].Actions[n];
        if assigned(FTBOnMouseUp) then b.OnMouseUp:=FTBOnMouseUp;
        b.Left:=lpos;
      end else begin
        // search for a control
        n:=-1;
        for k:=0 to numcontrol-1 do begin
          if editControlTxt[k]=act then begin
            n:=k;
            break;
          end;
        end;
        // move control to toolbar
        if n>=0 then begin
          if editControl[n] is TToolbar then begin
            if editbar[p].Height>editbar[p].Width then begin
              if editControl[n].Width>editControl[n].Height then begin
                w:=editControl[n].Width;
                h:=editControl[n].Height;
                editControl[n].Width:=h;
                editControl[n].Height:=w;
              end;
            end else begin
                if editControl[n].Width<editControl[n].Height then begin
                  w:=editControl[n].Width;
                  h:=editControl[n].Height;
                  editControl[n].Width:=h;
                  editControl[n].Height:=w;
                end;
            end;
          end;
          editControl[n].Parent:=editbar[p];
          editControl[n].Visible:=true;
          editControl[n].Left:=lpos;
      end else begin
        // search for a separator
        if act=SeparatorTxt then begin
          b:=TToolButton.Create(editbar[p]);
          b.Name:='ToolButton_separator'+inttostr(p)+'_'+inttostr(i);
          b.Caption:=SeparatorTxt;
          b.Parent:=editbar[p];
          b.AutoSize:=true;
          b.Style:=tbsSeparator;
          b.Left:=lpos;
        end;
        if act=DividerTxt then begin
          b:=TToolButton.Create(editbar[p]);
          b.Name:='ToolButton_divider'+inttostr(p)+'_'+inttostr(i);
          b.Caption:=DividerTxt;
          b.Parent:=editbar[p];
          b.AutoSize:=true;
          b.Style:=tbsDivider;
          b.Left:=lpos;
        end;
      end;
      end;
    end;
    // Move the final divider to the end
    if editbar[p].Name='ToolBarMain' then
      for i:=editbar[p].ButtonCount-1 downto 0 do begin
         if editbar[p].Buttons[i].Name='Divider_ToolBarMain_end' then editbar[p].Buttons[i].Left:=lpos;
      end;
  end;
end;
ModalResult:=mrOK;
end;

function Tf_edittoolbar.AddBtn(pos:TTreeNode; act: string; barnum,imgix: integer):TTreeNode;
var ok: boolean;
    i: integer;
begin
ok:=true;
result:=nil;
if (act<>DividerTxt)and(act<>SeparatorTxt) then begin
  for i:=0 to numeditbar-1 do begin
   ok:=ok and (ToolbarTreeview[i].Items.FindNodeWithText(act)=nil);
   if not ok then begin
     break;
   end;
  end;
end;
if ok then begin
  result:=ToolbarTreeview[barnum].Items.InsertBehind(pos,act);
  result.ImageIndex:=imgix;
end;
end;

procedure Tf_edittoolbar.ButtonAddClick(Sender: TObject);
var act:string;
    lvl,bn:integer;
    node,pos,nextpos: TTreeNode;
begin
bn:=ComboBox1.ItemIndex;
node:=ActionTreeView.Selected;
if node<>nil then begin
  lvl:=node.Level;
  pos:=ToolbarTreeview[bn].Selected;
  // individual button
  if lvl=2 then begin
    act:=node.Text;
    AddBtn(pos,act,bn,ActionTreeView.Selected.ImageIndex);
    if (act<>SeparatorTxt)and(act<>DividerTxt) then node.Visible:=false;
  end;
  // all the selected category
  if lvl=1 then begin
    node:=ActionTreeView.Selected.GetFirstChild;
    while node<>nil do begin
     if node.visible then begin
       act:=node.Text;
       nextpos:=AddBtn(pos,act,bn,node.ImageIndex);
       if (act<>SeparatorTxt)and(act<>DividerTxt) then node.Visible:=false;
       if nextpos<>nil then pos:=nextpos;
     end;
     node:=node.GetNextSibling;
    end;
  end;
end;
end;

procedure Tf_edittoolbar.ButtonUpClick(Sender: TObject);
var node: TTreeNode;
    i,bn: integer;
begin
bn:=ComboBox1.ItemIndex;
node:=ToolbarTreeview[bn].Selected;
if node<>nil then begin
  i:=node.Index;
  if i>0 then node.Index:=i-1;
end;
end;

procedure Tf_edittoolbar.ButtonDownClick(Sender: TObject);
var node: TTreeNode;
    i,bn: integer;
begin
bn:=ComboBox1.ItemIndex;
node:=ToolbarTreeview[bn].Selected;
if node<>nil then begin
  i:=node.Index;
  if i<(ToolbarTreeview[bn].Items.Count-1) then node.Index:=i+1;
end;
end;

procedure Tf_edittoolbar.ButtonDelClick(Sender: TObject);
var i,bn: integer;
    capt: string;
    node: TTreeNode;
begin
bn:=ComboBox1.ItemIndex;
for i:=ToolbarTreeview[bn].items.Count-1 downto 0 do begin
  if ToolbarTreeview[bn].Items[i].Selected then begin
    capt:=ToolbarTreeview[bn].Items[i].Text;
    node:=ActionTreeView.Items.FindNodeWithText(capt);
    if node<>nil then node.Visible:=true;
    ToolbarTreeview[bn].Items.Delete(ToolbarTreeview[bn].Items[i]);
  end;
end;
end;

procedure Tf_edittoolbar.ClearToolbarTree(bn:integer);
var i: integer;
    capt: string;
    node: TTreeNode;
begin
 for i:=ToolbarTreeview[bn].items.Count-1 downto 0 do begin
   capt:=ToolbarTreeview[bn].Items[i].Text;
   node:=ActionTreeView.Items.FindNodeWithText(capt);
   if node<>nil then node.Visible:=true;
   ToolbarTreeview[bn].Items.Delete(ToolbarTreeview[bn].Items[i]);
 end;
end;

procedure Tf_edittoolbar.ButtonClearClick(Sender: TObject);
var bn: integer;
begin
 bn:=ComboBox1.ItemIndex;
 ClearToolbarTree(bn);
end;

procedure Tf_edittoolbar.ButtonStdClick(Sender: TObject);
var str:TStringList;
    i:integer;
begin
// standard bar
str:=TStringList.Create;
str.clear;
for i:=1 to numstandardmainbar do str.Add(standardmainbar[i]);
LoadToolbar(0,str);
str.clear;
for i:=1 to numstandardobjectbar do str.Add(standardobjectbar[i]);
LoadToolbar(1,str);
str.clear;
for i:=1 to numstandardleftbar do str.Add(standardleftbar[i]);
LoadToolbar(2,str);
str.clear;
for i:=1 to numstandardrightbar do str.Add(standardrightbar[i]);
LoadToolbar(3,str);
str.free;
end;

procedure Tf_edittoolbar.ButtonMiniClick(Sender: TObject);
var str:TStringList;
    i:integer;
begin
// minimal bar
str:=TStringList.Create;
str.clear;
for i:=1 to numminimalmainbar do str.Add(minimalmainbar[i]);
LoadToolbar(0,str);
str.clear;
LoadToolbar(1,str);
str.clear;
LoadToolbar(2,str);
str.clear;
LoadToolbar(3,str);
str.free;
end;

procedure Tf_edittoolbar.ButtonExpandClick(Sender: TObject);
begin
  ActionTreeView.FullExpand;
end;

procedure Tf_edittoolbar.ButtonCollapseClick(Sender: TObject);
begin
ActionTreeView.FullCollapse;
end;

procedure Tf_edittoolbar.ButtonEmptyClick(Sender: TObject);
var i: integer;
begin
 for i:=0 to ComboBox1.Items.Count-1 do ClearToolbarTree(i);
end;


end.

