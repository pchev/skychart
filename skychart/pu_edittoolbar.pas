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
Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
}
{
 Tool bar editor for CDC/Skychart
}

{$mode objfpc}{$H+}

interface

uses
  u_constant, u_translation, u_help, IniFiles, UScaleDPI,
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ComCtrls,
  lazutf8, ActnList, ExtCtrls, StdCtrls, PairSplitter, Buttons;

type

  { Tf_edittoolbar }

  Tf_edittoolbar = class(TForm)
    ButtonDefault: TButton;
    ButtonSave: TBitBtn;
    ButtonLoad: TBitBtn;
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
    BtnText: TCheckBox;
    OpenDialog1: TOpenDialog;
    PanelRbot: TPanel;
    ComboBox1: TComboBox;
    BtnSize: TComboBox;
    Label1: TLabel;
    Label2: TLabel;
    Panel1: TPanel;
    PanelRtop: TPanel;
    PanelLtop: TPanel;
    PanelLbot: TPanel;
    PanelCentre: TPanel;
    PanelRight: TPanel;
    PanelBottom: TPanel;
    ActionTreeView: TTreeView;
    editbarPanel: TPanel;
    PanelLeft: TPanel;
    SaveDialog1: TSaveDialog;
    procedure BtnSizeChange(Sender: TObject);
    procedure BtnTextChange(Sender: TObject);
    procedure ButtonDefaultClick(Sender: TObject);
    procedure ButtonEmptyClick(Sender: TObject);
    procedure ButtonCollapseClick(Sender: TObject);
    procedure ButtonExpandClick(Sender: TObject);
    procedure ButtonHelpClick(Sender: TObject);
    procedure ButtonLoadClick(Sender: TObject);
    procedure ButtonMiniClick(Sender: TObject);
    procedure ButtonClearClick(Sender: TObject);
    procedure ButtonDownClick(Sender: TObject);
    procedure ButtonOKClick(Sender: TObject);
    procedure ButtonAddClick(Sender: TObject);
    procedure ButtonDelClick(Sender: TObject);
    procedure ButtonSaveClick(Sender: TObject);
    procedure ButtonStdClick(Sender: TObject);
    procedure ButtonUpClick(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormResize(Sender: TObject);
  private
    { private declarations }
    numaction, numcontrol, numeditbar: integer;
    FTBOnMouseDown, FTBOnMouseUp: TMouseEvent;
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
    procedure SetImages(Value: TImageList);
    function AddBtn(pos: TTreeNode; act: string; barnum, imgix: integer): TTreeNode;
    procedure ClearToolbarTree(bn: integer);
    function GetControlName(capt: string): string;
    function GetControlCaption(nam: string): string;
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
    procedure AddAction(Value: TActionList; txt: string);

    // Add an other control
    procedure AddOtherControl(Value: TControl; txt, cat, group: string; imgindex: integer);

    // Add a toolbar to edit
    procedure AddToolbar(Value: TToolBar);

    // Fill the left tree with the available action list and other control
    procedure ProcessActions;

    // Update the toolbar using the right tree
    procedure ActivateToolbar;

    // Save the right tree
    procedure SaveToolbar(bn: integer; str: TStringList);

    // Load the right tree
    procedure LoadToolbar(bn: integer; str: TStringList);

    // Load the right tree using the current toolbar components
    procedure LoadFromToolbar;

    // the imagelist to use for all the buttons
    property Images: TImageList read Fimages write SetImages;

    // set the action to expand by default in the left tree
    property DefaultAction: string read defaultact write defaultact;

    // set the toolbar to show by default in the right tree
    property DefaultToolbar: string read defaultbar write defaultbar;

    // The container for the other objects removed from the toolbar
    property DisabledContainer: TWinControl read FDisabledContainer
      write FDisabledContainer;

    // add a mouseup event to each toolbutton (to process the right click)
    property TBOnMouseUp: TMouseEvent read FTBOnMouseUp write FTBOnMouseUp;

    // add a mousedown event to each toolbutton (to set modifier keys)
    property TBOnMouseDown: TMouseEvent read FTBOnMouseDown write FTBOnMouseDown;

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
  Caption := rsToolBarEdito;
  ButtonOK.Caption := rsOK;
  ButtonCancel.Caption := rsCancel;
  ButtonHelp.Caption := rsHelp;
  Label1.Caption := rsAvailableAct;
  label2.Caption := rsButtonSize;
  BtnText.Caption := rsShowButtonTe;
  ButtonMini.Caption := rsMinimal;
  ButtonDefault.Caption := rsDefault;
  ButtonStd.Caption := rsStandard;
  ButtonEmpty.Caption := rsClear;
  DividerTxt := rsDivider;
  SeparatorTxt := rsSeparator;
  SetHelp(self, hlpToolbarEditor);
  ButtonAdd.Hint := rsAdd;
  ButtonDel.Hint := rsDelete;
  ButtonUp.Hint := rsUp;
  ButtonDown.Hint := rsDown;
  ButtonClear.Hint := rsClear;
  ButtonExpand.Hint := rsExpand;
  ButtonCollapse.Hint := rsCollapse;
  ButtonSave.Hint := rsSaveToFile;
  ButtonLoad.Hint := rsLoadFromFile;
end;

procedure Tf_edittoolbar.SetImages(Value: TImageList);
var
  i: integer;
begin
  Fimages := Value;
  for i := 0 to numeditbar - 1 do
    ToolbarTreeview[i].Images := Fimages;
  ActionTreeView.Images := Fimages;
end;

procedure Tf_edittoolbar.ClearToolbar;
var
  i: integer;
begin
  ComboBox1.Clear;
  for i := 0 to numeditbar - 1 do
    ToolbarTreeview[i].Free;
  numeditbar := 0;
  SetLength(editbar, 0);
  SetLength(ToolbarTreeview, 0);
end;

procedure Tf_edittoolbar.ClearAction;
begin
  numaction := 0;
  SetLength(editAction, 0);
  SetLength(editActionTxt, 0);
end;

procedure Tf_edittoolbar.AddAction(Value: TActionList; txt: string);
begin
  if Value <> nil then
  begin
    Inc(numaction);
    SetLength(editAction, numaction);
    SetLength(editActionTxt, numaction);
    editAction[numaction - 1] := Value;
    editActionTxt[numaction - 1] := txt;
  end;
end;

procedure Tf_edittoolbar.ClearControl;
begin
  numcontrol := 0;
  SetLength(editControl, 0);
  SetLength(editControlTxt, 0);
  SetLength(editControlCat, 0);
  SetLength(editControlGroup, 0);
end;

procedure Tf_edittoolbar.AddOtherControl(Value: TControl; txt, cat, group: string;
  imgindex: integer);
begin
  if Value <> nil then
  begin
    Inc(numcontrol);
    SetLength(editControl, numcontrol);
    SetLength(editControlTxt, numcontrol);
    SetLength(editControlImg, numcontrol);
    SetLength(editControlCat, numcontrol);
    SetLength(editControlGroup, numcontrol);
    editControl[numcontrol - 1] := Value;
    editControlTxt[numcontrol - 1] := txt;
    editControlImg[numcontrol - 1] := imgindex;
    editControlCat[numcontrol - 1] := cat;
    editControlGroup[numcontrol - 1] := group;
  end;
end;

procedure Tf_edittoolbar.AddToolbar(Value: TToolBar);
var
  i: integer;
begin
  if Value <> nil then
  begin
    Inc(numeditbar);
    SetLength(editbar, numeditbar);
    SetLength(ToolbarTreeview, numeditbar);
    editbar[numeditbar - 1] := Value;
    ToolbarTreeview[numeditbar - 1] := TTreeView.Create(self);
    ToolbarTreeview[numeditbar - 1].Parent := editbarpanel;
    ToolbarTreeview[numeditbar - 1].Images := Fimages;
    ToolbarTreeview[numeditbar - 1].Align := alClient;
    ToolbarTreeview[numeditbar - 1].ScrollBars := ssAutoBoth;
    ToolbarTreeview[numeditbar - 1].Visible := (Value.Caption = defaultbar);
    i := ComboBox1.Items.Add(Value.Caption);
    if (Value.Caption = defaultbar) then
      ComboBox1.ItemIndex := i;
  end;
end;

procedure Tf_edittoolbar.ComboBox1Change(Sender: TObject);
var
  i, bn: integer;
begin
  bn := ComboBox1.ItemIndex;
  for i := 0 to numeditbar - 1 do
  begin
    ToolbarTreeview[i].Visible := (i = bn);
  end;
end;

procedure Tf_edittoolbar.FormCreate(Sender: TObject);
begin
  ScaleDPI(Self);
  numaction := 0;
  numeditbar := 0;
  Setlang;
end;

procedure Tf_edittoolbar.FormResize(Sender: TObject);
begin
  PanelRight.Width := trunc((ClientWidth - PanelCentre.Width) / 2);
end;

procedure Tf_edittoolbar.ProcessActions;
var
  i, k, n: integer;
  catlst: TStringList;
  cat, act: string;
  actnode, cnode: TTreeNode;
begin
  if (numeditbar > 0) and (numaction > 0) then
  begin
    catlst := TStringList.Create;
    ActionTreeView.Items.Clear;
    ActionTreeView.FullCollapse;
    ActionTreeView.Images := Fimages;
    // add separator tools
    actnode := ActionTreeView.Items.Add(nil, rsTools);
    cnode := ActionTreeView.Items.AddChild(actnode, rsSeparator);
    with ActionTreeView.Items.AddChild(cnode, DividerTxt) do
      ImageIndex := 100;
    with ActionTreeView.Items.AddChild(cnode, SeparatorTxt) do
      ImageIndex := 101;
    for k := 0 to numaction - 1 do
    begin
      // set main actionlist as first level
      actnode := ActionTreeView.Items.Add(nil, editActionTxt[k]);
      // list categories
      catlst.Clear;
      for i := 0 to editAction[k].ActionCount - 1 do
      begin
        cat := editAction[k].Actions[i].Category;
        if cat = '' then
          cat := 'none';
        n := catlst.IndexOf(cat);
        if n < 0 then
          catlst.Add(cat);
      end;
      // second tree level is categories
      for i := 0 to catlst.Count - 1 do
      begin
        ActionTreeView.Items.AddChild(actnode, catlst[i]);
      end;
      // add actions by categories
      for i := 0 to editAction[k].ActionCount - 1 do
      begin
        cat := editAction[k].Actions[i].Category;
        if cat = '' then
          cat := 'none';
        if TAction(editAction[k].Actions[i]).Name='Track' then
           act:='Track'
        else
           act := TAction(editAction[k].Actions[i]).hint;
        if act = '' then
          continue; // skip action without Hint, they are for internal use (SetFOV*).
        with ActionTreeView.Items.AddChild(actnode.FindNode(cat), act) do
        begin
          ImageIndex := TAction(editAction[k].Actions[i]).ImageIndex;
        end;
       end;
      // add other control (non action button)
      for i := 0 to numcontrol - 1 do
      begin
        if editControlGroup[i] = editActionTxt[k] then
        begin
          cat := editControlCat[i];
          act := editControlTxt[i];
          if cat = '' then
            cat := 'none';
          with ActionTreeView.Items.AddChild(actnode.FindNode(cat), act) do
          begin
            ImageIndex := editControlImg[i];
          end;
        end;
      end;
      if cnode.Count = 0 then
        ActionTreeView.Items.Delete(cnode);
      // expand
      if editActionTxt[k] = defaultact then
        actnode.Expand(True);
    end;
    catlst.Free;
  end;
end;

procedure Tf_edittoolbar.LoadFromToolbar;
var
  i, j, k: integer;
  cn,hi: string;
  node: TTreeNode;
begin
  // add current visible buttons
  for k := 0 to numeditbar - 1 do
  begin
    ClearToolbarTree(k);
    ToolbarTreeview[k].Images := Fimages;
    for i := 0 to editbar[k].ControlCount - 1 do
    begin
      if (editbar[k].Controls[i] is TToolButton) then
      begin
        // toolbutton
        if editbar[k].Controls[i].Name='Track' then
           hi:='Track'
        else
           hi:=editbar[k].Controls[i].hint;
        node := ActionTreeView.Items.FindNodeWithText(hi);
        if node <> nil then
          node.Visible := False;
        with  ToolbarTreeview[k].Items.Add(nil, hi) do
        begin
          ImageIndex := TToolButton(editbar[k].Controls[i]).ImageIndex;
        end;
      end
      else
      begin
        // other objects
        if numcontrol > 0 then
        begin
          cn := editbar[k].Controls[i].Caption;
          if cn = '' then
            cn := editbar[k].Controls[i].Name;
          for j := 0 to numcontrol - 1 do
          begin
            if editbar[k].Controls[i] = editControl[j] then
              cn := editControlTxt[j];
          end;
          node := ActionTreeView.Items.FindNodeWithText(cn);
          if node <> nil then
            node.Visible := False;
          with ToolbarTreeview[k].Items.Add(nil, cn) do
          begin
            ImageIndex := editControlImg[j];
          end;
        end;
      end;
    end;
  end;
end;

procedure Tf_edittoolbar.ButtonOKClick(Sender: TObject);
begin
  ActivateToolbar;
  ModalResult := mrOk;
end;

procedure Tf_edittoolbar.SaveToolbar(bn: integer; str: TStringList);
var
  i, im: integer;
  act, buf: string;
begin
  if (bn < numeditbar) then
  begin
    str.Clear;
    for i := 0 to ToolbarTreeview[bn].Items.Count - 1 do
    begin
      act := GetControlName(ToolbarTreeview[bn].Items[i].Text);
      im := ToolbarTreeview[bn].Items[i].ImageIndex;
      buf := IntToStr(im) + sep + act;
      str.add(buf);
    end;
  end;
end;

procedure Tf_edittoolbar.LoadToolbar(bn: integer; str: TStringList);
var
  i, j, im: integer;
  act, buf: string;
  node: TTreeNode;
begin
  if (bn < numeditbar) then
  begin
    ClearToolbarTree(bn);
    for i := 0 to str.Count - 1 do
    begin
      buf := str[i];
      if buf = '' then
        continue;
      j := pos(sep, buf);
      if j <= 0 then
        continue;
      im := strtointdef(copy(buf, 1, j - 1), 0);
      Delete(buf, 1, j);
      act := GetControlCaption(buf);
      if (act <> SeparatorTxt) and (act <> DividerTxt) then
      begin
        node := ActionTreeView.Items.FindNodeWithText(act);
        if node <> nil then
          node.Visible := False;
      end;
      with  ToolbarTreeview[bn].Items.Add(nil, act) do
      begin
        ImageIndex := im;
      end;
    end;
  end;
end;

function Tf_edittoolbar.GetControlName(capt: string): string;
var
  j, k: integer;
  hi: string;
begin
  Result := '';
  // search action by caption
  for k := 0 to numaction - 1 do
  begin
    for j := 0 to editAction[k].ActionCount - 1 do
    begin
      if TAction(editAction[k].Actions[j]).Name='Track' then
         hi:='Track'
      else
         hi:=TAction(editAction[k].Actions[j]).hint;
      if hi = capt then
      begin
        Result := TAction(editAction[k].Actions[j]).Name;
        break;
      end;
    end;
    if Result <> '' then
      break;
  end;
  // search for a control
  if Result = '' then
    for k := 0 to numcontrol - 1 do
    begin
      if editControlTxt[k] = capt then
      begin
        Result := editControl[k].Name;
        break;
      end;
    end;
  // search for a separator
  if (Result = '') and (capt = SeparatorTxt) then
    Result := 'Separator';
  if (Result = '') and (capt = DividerTxt) then
    Result := 'Divider';
end;

function Tf_edittoolbar.GetControlCaption(nam: string): string;
var
  j, k: integer;
  hi: string;
begin
  Result := '';
  // search action by name
  for k := 0 to numaction - 1 do
  begin
    for j := 0 to editAction[k].ActionCount - 1 do
    begin
      if TAction(editAction[k].Actions[j]).Name = nam then
      begin
        if TAction(editAction[k].Actions[j]).Name='Track' then
           hi:='Track'
        else
           hi:=TAction(editAction[k].Actions[j]).hint;
        Result := hi;
        break;
      end;
    end;
    if Result <> '' then
      break;
  end;
  // search for a control
  if Result = '' then
    for k := 0 to numcontrol - 1 do
    begin
      if editControl[k].Name = nam then
      begin
        Result := editControlTxt[k];
        break;
      end;
    end;
  // search for a separator
  if (Result = '') and (nam = 'Separator') then
    Result := SeparatorTxt;
  if (Result = '') and (nam = 'Divider') then
    Result := DividerTxt;
end;

procedure Tf_edittoolbar.ActivateToolbar;
var
  i, j, k, n, m, p, t, lpos, w, h: integer;
  b: TToolButton;
  act,hi: string;
  visiblebar: boolean;
begin
  if (numeditbar > 0) and (numaction > 0) then
  begin
    for p := 0 to numeditbar - 1 do
    begin
      lpos := 0; // first button to the left
      // clear bar
      visiblebar := editbar[p].Visible;
      editbar[p].Visible := False;
      editbar[p].BeginUpdate;
      for i := editbar[p].ButtonCount - 1 downto 0 do
      begin
        if editbar[p].Buttons[i].Name = 'Divider_ToolBarMain_end' then
          continue;
        editbar[p].Buttons[i].Free;
      end;
      for i := editbar[p].ControlCount - 1 downto 0 do
      begin
        if editbar[p].Controls[i].Name = 'ChildControl' then
          continue;
        if editbar[p].Controls[i].Name = 'Divider_ToolBarMain_end' then
          continue;
        editbar[p].Controls[i].Visible := False;
        editbar[p].Controls[i].Parent := FDisabledContainer;
      end;
      editbar[p].EndUpdate;
      editbar[p].Visible := visiblebar;
      editbar[p].BeginUpdate;
      // add buttons
      for i := 0 to ToolbarTreeview[p].Items.Count - 1 do
      begin
        act := ToolbarTreeview[p].Items[i].Text;
        // search action by caption
        n := -1;
        m := -1;
        for k := 0 to numaction - 1 do
        begin
          for j := 0 to editAction[k].ActionCount - 1 do
          begin
            if TAction(editAction[k].Actions[j]).Name='Track' then
               hi:='Track'
            else
               hi:=TAction(editAction[k].Actions[j]).hint;
            if hi = act then
            begin
              m := k;
              n := j;
              break;
            end;
          end;
          if n >= 0 then
            break;
        end;
        // create button
        if n >= 0 then
        begin
          b := TToolButton.Create(editbar[p]);
          b.Name := 'ToolButton_' + editAction[m].Actions[n].Name;
          b.Parent := editbar[p];
          b.AutoSize := True;
          b.Style := tbsButton;
          b.Action := editAction[m].Actions[n];
          if utf8length(b.Caption) > 15 then
          begin
            b.Caption := utf8copy(b.Caption, 1, 14) + '...';
          end;
          if assigned(FTBOnMouseUp) then
            b.OnMouseUp := FTBOnMouseUp;
          if assigned(FTBOnMouseDown) then
            b.OnMouseDown := FTBOnMouseDown;
          b.Left := lpos;
        end
        else
        begin
          // search for a control
          n := -1;
          for k := 0 to numcontrol - 1 do
          begin
            if editControlTxt[k] = act then
            begin
              n := k;
              break;
            end;
          end;
          // move control to toolbar
          if n >= 0 then
          begin
            editControl[n].Parent := editbar[p];
            editControl[n].Visible := True;
            editControl[n].Left := lpos;
            if editControl[n].Name = 'quicksearch' then
            begin
              editControl[n].Width := 90;
              editControl[n].Font.Size := 0;
            end;
            if editControl[n].Name = 'TimeU' then
            begin
              editControl[n].Font.Size := 0;
            end;
            if editControl[n].Name = 'TimeValPanel' then
            begin
              editControl[n].Font.Size := 0;
            end;
            if editControl[n].Name = 'MagPanel' then
            begin
            end;
            if editControl[n].Name = 'ToolBarFOV' then
            begin
              if editbar[p].Height > editbar[p].Width then
              begin
                editControl[n].Font.Size := DoScaleX(SysFontSize - 2);
                for t := 0 to tpanel(editControl[n]).ControlCount - 1 do
                begin
                  TSpeedButton(tpanel(editControl[n]).Controls[t]).Width :=
                    editbar[p].Width;
                  TSpeedButton(tpanel(editControl[n]).Controls[t]).Height :=
                    editbar[p].Width;
                end;
                w := editbar[p].Width;
                h := 10 * (editbar[p].Width);
                editControl[n].SetBounds(editControl[n].Left, editControl[n].Top, w, h);
              end
              else
              begin
                editControl[n].Font.Size := DoScaleX(SysFontSize - 2);
                for t := 0 to tpanel(editControl[n]).ControlCount - 1 do
                begin
                  TSpeedButton(tpanel(editControl[n]).Controls[t]).Width :=
                    editbar[p].Height;
                  TSpeedButton(tpanel(editControl[n]).Controls[t]).Height :=
                    editbar[p].Height;
                end;
                w := 10 * (editbar[p].Height);
                h := editbar[p].Height;
                editControl[n].SetBounds(editControl[n].Left, editControl[n].Top, w, h);
              end;
            end;
          end
          else
          begin
            // search for a separator
            if act = SeparatorTxt then
            begin
              b := TToolButton.Create(editbar[p]);
              b.Name := 'ToolButton_separator' + IntToStr(p) + '_' + IntToStr(i);
              b.Caption := SeparatorTxt;
              b.Parent := editbar[p];
              b.AutoSize := True;
              b.Style := tbsSeparator;
              b.Left := lpos;
            end;
            if act = DividerTxt then
            begin
              b := TToolButton.Create(editbar[p]);
              b.Name := 'ToolButton_divider' + IntToStr(p) + '_' + IntToStr(i);
              b.Caption := DividerTxt;
              b.Parent := editbar[p];
              b.AutoSize := True;
              b.Style := tbsDivider;
              b.Left := lpos;
            end;
          end;
        end;
        lpos := 10000; // big enough to add the next button to the right
      end;
      // Move the final divider to the end
      if editbar[p].Name = 'ToolBarMain' then
        for i := editbar[p].ButtonCount - 1 downto 0 do
        begin
          if editbar[p].Buttons[i].Name = 'Divider_ToolBarMain_end' then
            editbar[p].Buttons[i].Left := lpos;
        end;
      editbar[p].EndUpdate;
    end;
  end;
end;

function Tf_edittoolbar.AddBtn(pos: TTreeNode; act: string;
  barnum, imgix: integer): TTreeNode;
var
  ok: boolean;
  i: integer;
begin
  ok := True;
  Result := nil;
  if (act <> DividerTxt) and (act <> SeparatorTxt) then
  begin
    for i := 0 to numeditbar - 1 do
    begin
      ok := ok and (ToolbarTreeview[i].Items.FindNodeWithText(act) = nil);
      if not ok then
      begin
        break;
      end;
    end;
  end;
  if ok then
  begin
    Result := ToolbarTreeview[barnum].Items.InsertBehind(pos, act);
    Result.ImageIndex := imgix;
  end;
end;

procedure Tf_edittoolbar.ButtonAddClick(Sender: TObject);
var
  act: string;
  lvl, bn: integer;
  node, pos, nextpos: TTreeNode;
begin
  bn := ComboBox1.ItemIndex;
  node := ActionTreeView.Selected;
  if node <> nil then
  begin
    lvl := node.Level;
    pos := ToolbarTreeview[bn].Selected;
    // individual button
    if lvl = 2 then
    begin
      act := node.Text;
      AddBtn(pos, act, bn, ActionTreeView.Selected.ImageIndex);
      if (act <> SeparatorTxt) and (act <> DividerTxt) then
        node.Visible := False;
    end;
    // all the selected category
    if lvl = 1 then
    begin
      node := ActionTreeView.Selected.GetFirstChild;
      while node <> nil do
      begin
        if node.Visible then
        begin
          act := node.Text;
          nextpos := AddBtn(pos, act, bn, node.ImageIndex);
          if (act <> SeparatorTxt) and (act <> DividerTxt) then
            node.Visible := False;
          if nextpos <> nil then
            pos := nextpos;
        end;
        node := node.GetNextSibling;
      end;
    end;
  end;
end;

procedure Tf_edittoolbar.ButtonUpClick(Sender: TObject);
var
  node: TTreeNode;
  i, bn: integer;
begin
  bn := ComboBox1.ItemIndex;
  node := ToolbarTreeview[bn].Selected;
  if node <> nil then
  begin
    i := node.Index;
    if i > 0 then
      node.Index := i - 1;
  end;
end;

procedure Tf_edittoolbar.ButtonDownClick(Sender: TObject);
var
  node: TTreeNode;
  i, bn: integer;
begin
  bn := ComboBox1.ItemIndex;
  node := ToolbarTreeview[bn].Selected;
  if node <> nil then
  begin
    i := node.Index;
    if i < (ToolbarTreeview[bn].Items.Count - 1) then
      node.Index := i + 1;
  end;
end;

procedure Tf_edittoolbar.ButtonDelClick(Sender: TObject);
var
  i, bn: integer;
  capt: string;
  node: TTreeNode;
begin
  bn := ComboBox1.ItemIndex;
  for i := ToolbarTreeview[bn].items.Count - 1 downto 0 do
  begin
    if ToolbarTreeview[bn].Items[i].Selected then
    begin
      capt := ToolbarTreeview[bn].Items[i].Text;
      node := ActionTreeView.Items.FindNodeWithText(capt);
      if node <> nil then
        node.Visible := True;
      ToolbarTreeview[bn].Items.Delete(ToolbarTreeview[bn].Items[i]);
    end;
  end;
end;

procedure Tf_edittoolbar.ClearToolbarTree(bn: integer);
var
  i: integer;
  capt: string;
  node: TTreeNode;
begin
  for i := ToolbarTreeview[bn].items.Count - 1 downto 0 do
  begin
    capt := ToolbarTreeview[bn].Items[i].Text;
    node := ActionTreeView.Items.FindNodeWithText(capt);
    if node <> nil then
      node.Visible := True;
    ToolbarTreeview[bn].Items.Delete(ToolbarTreeview[bn].Items[i]);
  end;
end;

procedure Tf_edittoolbar.ButtonClearClick(Sender: TObject);
var
  bn: integer;
begin
  bn := ComboBox1.ItemIndex;
  ClearToolbarTree(bn);
end;

procedure Tf_edittoolbar.ButtonStdClick(Sender: TObject);
var
  str: TStringList;
  i: integer;
begin
  // standard bar
  str := TStringList.Create;
  str.Clear;
  for i := 1 to numstandardmainbar do
    str.Add(standardmainbar[i]);
  LoadToolbar(0, str);
  str.Clear;
  for i := 1 to numstandardobjectbar do
    str.Add(standardobjectbar[i]);
  LoadToolbar(1, str);
  str.Clear;
  for i := 1 to numstandardleftbar do
    str.Add(standardleftbar[i]);
  LoadToolbar(2, str);
  str.Clear;
  for i := 1 to numstandardrightbar do
    str.Add(standardrightbar[i]);
  LoadToolbar(3, str);
  str.Free;
end;

procedure Tf_edittoolbar.ButtonMiniClick(Sender: TObject);
var
  str: TStringList;
  i: integer;
begin
  // minimal bar
  str := TStringList.Create;
  str.Clear;
  for i := 1 to numminimalmainbar do
    str.Add(minimalmainbar[i]);
  LoadToolbar(0, str);
  str.Clear;
  LoadToolbar(1, str);
  str.Clear;
  LoadToolbar(2, str);
  str.Clear;
  LoadToolbar(3, str);
  str.Free;
end;

procedure Tf_edittoolbar.ButtonDefaultClick(Sender: TObject);
var
  str: TStringList;
  i: integer;
begin
  // default bar for v4.2
  str := TStringList.Create;
  str.Clear;
  for i := 1 to numdefaultmainbar do
    str.Add(defaultmainbar[i]);
  LoadToolbar(0, str);
  str.Clear;
  LoadToolbar(1, str);
  str.Clear;
  LoadToolbar(2, str);
  str.Clear;
  for i := 1 to numdefaultrightbar do
    str.Add(defaultrightbar[i]);
  LoadToolbar(3, str);
  str.Free;
end;

procedure Tf_edittoolbar.ButtonExpandClick(Sender: TObject);
begin
  ActionTreeView.FullExpand;
end;

procedure Tf_edittoolbar.ButtonHelpClick(Sender: TObject);
begin
  ShowHelp;
end;

procedure Tf_edittoolbar.ButtonCollapseClick(Sender: TObject);
begin
  ActionTreeView.FullCollapse;
end;

procedure Tf_edittoolbar.ButtonEmptyClick(Sender: TObject);
var
  i: integer;
begin
  for i := 0 to ComboBox1.Items.Count - 1 do
    ClearToolbarTree(i);
end;

procedure Tf_edittoolbar.BtnSizeChange(Sender: TObject);
begin
  if BtnSize.ItemIndex < 3 then
  begin
    BtnText.Checked := False;
    BtnText.Enabled := False;
  end
  else
    BtnText.Enabled := True;
end;

procedure Tf_edittoolbar.BtnTextChange(Sender: TObject);
begin
  if BtnSize.ItemIndex < 3 then
    BtnText.Checked := False;
end;

procedure Tf_edittoolbar.ButtonSaveClick(Sender: TObject);
var
  str: TStringList;
  section: string;
  inif: TMemIniFile;
  i, j: integer;
begin
  if SaveDialog1.Execute then
  begin
    inif := TMeminifile.Create(SaveDialog1.FileName);
    str := TStringList.Create;
    try
      for i := 0 to numeditbar - 1 do
      begin
        section := 'bar' + IntToStr(i);
        SaveToolbar(i, str);
        inif.WriteInteger(section, 'btncount', str.Count);
        for j := 0 to str.Count - 1 do
        begin
          inif.WriteString(section, 'b' + IntToStr(j), str[j]);
        end;
      end;
      inif.Updatefile;
    finally
      inif.Free;
      str.Free;
    end;
  end;
end;

procedure Tf_edittoolbar.ButtonLoadClick(Sender: TObject);
var
  str: TStringList;
  section, buf: string;
  inif: TMemIniFile;
  i, j, n: integer;
begin
  if OpenDialog1.Execute then
  begin
    ButtonEmptyClick(nil);
    inif := TMeminifile.Create(OpenDialog1.FileName);
    str := TStringList.Create;
    try
      for i := 0 to numeditbar - 1 do
      begin
        section := 'bar' + IntToStr(i);
        str.Clear;
        n := inif.ReadInteger(section, 'btncount', 0);
        for j := 0 to n - 1 do
        begin
          buf := inif.ReadString(section, 'b' + IntToStr(j), '');
          if buf <> '' then
            str.Add(buf);
        end;
        LoadToolbar(i, str);
      end;
    finally
      inif.Free;
      str.Free;
    end;
  end;
end;

end.
