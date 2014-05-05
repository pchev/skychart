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

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ComCtrls,
  ActnList, ExtCtrls, StdCtrls;

type

  { Tf_edittoolbar }

  Tf_edittoolbar = class(TForm)
    ButtonUp: TButton;
    ButtonDown: TButton;
    ButtonClear: TButton;
    ButtonOK: TButton;
    ButtonCancel: TButton;
    ButtonAdd: TButton;
    ButtonDel: TButton;
    ComboBox1: TComboBox;
    Label1: TLabel;
    LabelMsg: TLabel;
    Panel1: TPanel;
    ActionTreeView: TTreeView;
    editbarPanel: TPanel;
    procedure ButtonClearClick(Sender: TObject);
    procedure ButtonDownClick(Sender: TObject);
    procedure ButtonOKClick(Sender: TObject);
    procedure ButtonAddClick(Sender: TObject);
    procedure ButtonDelClick(Sender: TObject);
    procedure ButtonUpClick(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { private declarations }
    numaction,numcontrol,numeditbar: integer;
    FTBOnMouseUp: TMouseEvent;
    Fimages: TImageList;
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
    procedure AddBtn(act: string; barnum,imgix: integer);
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
    procedure ProcessToolbar;

    // Save the right tree
    procedure SaveToolbar(bn:integer; str:TStringList);

    // Load the right tree
    procedure LoadToolbar(bn:integer; str:TStringList);

    // Load the right tree using the current toolbar components
    procedure LoadFromToolbar;

    // the imagelist to use for all the buttons
    property Images: TImageList read Fimages write Fimages;

    // set the action to expand by default in the left tree
    property DefaultAction: string read defaultact write defaultact;

    // set the toolbar to show by default in the right tree
    property DefaultToolbar: string read defaultbar write defaultbar;

    // add a mouseup event to each toolbutton (to process the right click)
    property TBOnMouseUp: TMouseEvent read FTBOnMouseUp write FTBOnMouseUp;

  end;

var
  f_edittoolbar: Tf_edittoolbar;

const
  tab = chr(9);

implementation

{$R *.lfm}

{ Tf_edittoolbar }

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
  DividerTxt:='Divider';
  SeparatorTxt:='Separator';
end;

procedure Tf_edittoolbar.ProcessActions;
var i,k,n: integer;
  catlst: TStringList;
  cat,act: string;
  actnode,cnode: TTreeNode;
begin
if (numeditbar>0) and (numaction>0) then begin
  ActionTreeView.Items.Clear;
  ActionTreeView.FullCollapse;
  ActionTreeView.Images:=Fimages;
  // add separator tools
  actnode:=ActionTreeView.Items.Add(nil,'Tools');
  cnode:=ActionTreeView.Items.AddChild(actnode,'Separators');
  ActionTreeView.Items.AddChild(cnode,DividerTxt);
  ActionTreeView.Items.AddChild(cnode,SeparatorTxt);
  for k:=0 to numaction-1 do begin
    // set main actionlist as first level
    actnode:=ActionTreeView.Items.Add(nil,editActionTxt[k]);
    // list categories
    catlst:=TStringList.Create;
    for i:=0 to editAction[k].ActionCount-1 do begin
      cat:=editAction[k].Actions[i].Category;
      if cat='' then cat:='none';
      if not catlst.Find(cat,n) then catlst.Add(cat);
    end;
    // second tree level is categories
    for i:=0 to catlst.Count-1 do begin
      ActionTreeView.Items.AddChild(actnode,catlst[i]);
    end;
    // add actions by categories
    for i:=0 to editAction[k].ActionCount-1 do begin
      cat:=editAction[k].Actions[i].Category;
      act:=TAction(editAction[k].Actions[i]).caption;
      if cat='' then cat:='none';
      with ActionTreeView.Items.AddChild(actnode.FindNode(cat),act) do begin
        ImageIndex:=TAction(editAction[k].Actions[i]).ImageIndex;
      end;
    end;
    catlst.Free;
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
end;
end;

procedure Tf_edittoolbar.LoadFromToolbar;
var i,j,k: integer;
    cn: string;
begin
// add current visible buttons
for k:=0 to numeditbar-1 do begin
  ToolbarTreeview[k].Items.Clear;
  ToolbarTreeview[k].Images:=Fimages;
  for i:=0 to editbar[k].ControlCount-1 do begin
    if (editbar[k].Controls[i] is TToolButton) then begin
      // toolbutton
      with  ToolbarTreeview[k].Items.Add(nil,editbar[k].Controls[i].Caption) do begin
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
  ProcessToolbar;
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
      buf:=inttostr(im)+tab+act;
      str.add(buf);
    end;
end;
end;

procedure Tf_edittoolbar.LoadToolbar(bn:integer; str:TStringList);
var i,j,im:integer;
    act,buf: string;
begin
if (bn<numeditbar) then begin
   ToolbarTreeview[bn].Items.Clear;
   for i:=0 to str.Count-1 do begin
     buf:=str[i];
     j:=pos(tab,buf);
     im:=strtoint(copy(buf,1,j-1));
     delete(buf,1,j);
     act:=GetControlCaption(buf);
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
    if TAction(editAction[k].Actions[j]).caption=capt then begin
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
      result:=TAction(editAction[k].Actions[j]).Caption;
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

procedure Tf_edittoolbar.ProcessToolbar;
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
    for i:=0 to editbar[p].ControlCount-1 do begin
      if editbar[p].Controls[i].Name='ChildControl' then continue;
      if editbar[p].Controls[i].Name='Divider_ToolBarMain_end' then continue;
      editbar[p].Controls[i].Visible:=false;
    end;
    for i:=editbar[p].ButtonCount-1 downto 0 do begin
       if editbar[p].Buttons[i].Name='Divider_ToolBarMain_end' then continue;
       editbar[p].Buttons[i].Free;
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
          if TAction(editAction[k].Actions[j]).caption=act then begin
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

procedure Tf_edittoolbar.AddBtn(act: string; barnum,imgix: integer);
var ok: boolean;
    i: integer;
begin
ok:=true;
if (act<>DividerTxt)and(act<>SeparatorTxt) then begin
  for i:=0 to numeditbar-1 do begin
   ok:=ok and (ToolbarTreeview[i].Items.FindNodeWithText(act)=nil);
   if not ok then begin
     LabelMsg.Caption:='Button already in '+editbar[i].Caption;
     break;
   end;
  end;
end;
if ok then begin
  with  ToolbarTreeview[barnum].Items.Add(nil,act) do begin
     ImageIndex:=imgix;
  end;
end;
end;

procedure Tf_edittoolbar.ButtonAddClick(Sender: TObject);
var act:string;
    lvl,bn:integer;
    node: TTreeNode;
begin
LabelMsg.Caption:='';
bn:=ComboBox1.ItemIndex;
lvl:=ActionTreeView.Selected.Level;
// individual button
if lvl=2 then begin
  act:=ActionTreeView.Selected.Text;
  AddBtn(act,bn,ActionTreeView.Selected.ImageIndex);
end;
// all the selected category
if lvl=1 then begin
  node:=ActionTreeView.Selected.GetFirstChild;
  while node<>nil do begin
    act:=node.Text;
    AddBtn(act,bn,node.ImageIndex);
    node:=node.GetNextSibling;
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
begin
bn:=ComboBox1.ItemIndex;
for i:=ToolbarTreeview[bn].items.Count-1 downto 0 do begin
  if ToolbarTreeview[bn].Items[i].Selected then ToolbarTreeview[bn].Items.Delete(ToolbarTreeview[bn].Items[i]);
end;
end;

procedure Tf_edittoolbar.ButtonClearClick(Sender: TObject);
var bn: integer;
begin
 bn:=ComboBox1.ItemIndex;
 ToolbarTreeview[bn].Items.Clear;
end;


end.

