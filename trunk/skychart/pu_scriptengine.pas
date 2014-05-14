unit pu_scriptengine;

{$mode objfpc}{$H+}

interface

uses  u_translation, u_constant, u_util, ActnList, pu_pascaleditor,
  StdCtrls, ExtCtrls, Menus, Classes, SysUtils, FileUtil, IniFiles,
  uPSComponent, uPSComponent_Default, uPSComponent_DB, uPSComponent_Forms,
  uPSComponent_Controls, uPSComponent_StdCtrls, Forms, Controls, Graphics,
  Dialogs, ComCtrls,uPSCompiler, uPSRuntime, math;

type

  { Tf_scriptengine }

  Tf_scriptengine = class(TForm)
    ButtonSave: TButton;
    ButtonLoad: TButton;
    ButtonUpdate: TButton;
    ButtonAdd: TButton;
    ButtonEditScript: TButton;
    ButtonApply: TButton;
    ButtonClear: TButton;
    ButtonDelete: TButton;
    EventComboBox: TComboBox;
    CompileMemo: TMemo;
    GroupBox1: TGroupBox;
    GroupCaptionEdit: TEdit;
    ButtonCaptionEdit: TEdit;
    MemoHeightEdit: TEdit;
    GroupRowEdit: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    OpenDialog1: TOpenDialog;
    Panel1: TPanel;
    PSImport_Classes1: TPSImport_Classes;
    PSImport_Controls1: TPSImport_Controls;
    PSImport_DateUtils1: TPSImport_DateUtils;
    PSImport_Forms1: TPSImport_Forms;
    PSImport_StdCtrls1: TPSImport_StdCtrls;
    RadioButtonEvent: TRadioButton;
    RadioButtonGroup: TRadioButton;
    RadioButtonButton: TRadioButton;
    RadioButtonEdit: TRadioButton;
    RadioButtonMemo: TRadioButton;
    RadioButtonSpacer: TRadioButton;
    SaveDialog1: TSaveDialog;
    TplPSScript: TPSScript;
    TreeView1: TTreeView;
    procedure ButtonAddClick(Sender: TObject);
    procedure ButtonCaptionEditChange(Sender: TObject);
    procedure ButtonEditScriptClick(Sender: TObject);
    procedure ButtonApplyClick(Sender: TObject);
    procedure ButtonClearClick(Sender: TObject);
    procedure ButtonDeleteClick(Sender: TObject);
    procedure ButtonLoadClick(Sender: TObject);
    procedure ButtonSaveClick(Sender: TObject);
    procedure ButtonUpdateClick(Sender: TObject);
    procedure EventComboBoxChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure GroupCaptionEditChange(Sender: TObject);
    procedure GroupRowEditChange(Sender: TObject);
    procedure MemoHeightEditChange(Sender: TObject);
    procedure RadioButtonClick(Sender: TObject);
    procedure TplPSScriptCompile(Sender: TPSScript);
    procedure TplPSScriptExecute(Sender: TPSScript);
    procedure TreeView1Change(Sender: TObject; Node: TTreeNode);
  private
    { private declarations }
    FEditSurface: TPanel;
    FonApply: TNotifyEvent;
    gnum:integer;
    gr: array of TGroupBox;
    bnum:integer;
    bt: array of TButton;
    scrnum: integer;
    scr: array of TPSScript;
    evscrnum: integer;
    evscr: array of TPSScript;
    enum:integer;
    ed: array of TEdit;
    mnum:integer;
    mem: array of TMemo;
    snum:integer;
    sp: array of TPanel;
    Fpascaleditor: Tf_pascaleditor;
    GroupIdx,ButtonIdx,EditIdx,MemoIdx,SpacerIdx,EventIdx: integer;
    FExecuteCmd: TExecuteCmd;
    FMainmenu: TMenu;
    ChartName,RefreshText,SelectionText,DistanceText: string;
    TelescopeRA,TelescopeDE: double;
    function  doExecuteCmd(cname:string; arg:Tstringlist):string;
    function  doGetS(varname:string; var str: string):Boolean;
    function  doGetI(varname:string; var i: Integer):Boolean;
    function doGetD(varname:string; var x: Double):Boolean;
    procedure Button_Click(Sender: TObject);
    function  AddGroup(num,capt:string; pt: TWinControl; ctlperline:integer=1):TGroupBox;
    procedure AddButton(num,capt:string; pt: TWinControl);
    procedure AddEdit(num:string; pt: TWinControl);
    procedure AddMemo(num:string; pt: TWinControl;h: integer);
    procedure AddSpacer(num:string; pt: TWinControl);
    procedure ClearTreeView;
    procedure CompileScripts;
  public
    { public declarations }
    procedure Save(strbtn, strscr, eventscr: Tstringlist);
    procedure Load(strbtn, strscr, eventscr: Tstringlist);
    procedure ChartRefreshEvent(origin,str:string);
    procedure ObjectSelectionEvent(origin,str:string);
    procedure TelescopeMoveEvent(origin:string; ra,de: double);
    property EditSurface: TPanel read FEditSurface write FEditSurface;
    property onApply: TNotifyEvent read FonApply write FonApply;
    property ExecuteCmd: TExecuteCmd read FExecuteCmd write FExecuteCmd;
    property Mainmenu: TMenu read FMainmenu write FMainmenu;
  end;

var
  f_scriptengine: Tf_scriptengine;

implementation

{$R *.lfm}

function Tf_scriptengine.doExecuteCmd(cname:string; arg:Tstringlist):string;
begin
  if assigned(FExecuteCmd) then result:=FExecuteCmd(cname,arg);
end;

function  Tf_scriptengine.doGetS(varname:string; var str: string):Boolean;
begin
  result:=true;
  varname:=uppercase(varname);
  if varname='CHARTNAME' then str:=ChartName
  else if varname='REFRESHTEXT' then str:=RefreshText
  else if varname='SELECTIONTEXT' then str:=SelectionText
  else if varname='DISTANCETEXT' then str:=DistanceText
  else result:=false;
end;

function  Tf_scriptengine.doGetD(varname:string; var x: double):boolean;
begin
  result:=true;
  varname:=uppercase(varname);
  if varname='TELESCOPERA' then x:=TelescopeRA
  else if varname='TELESCOPEDE' then x:=TelescopeDE
  else result:=false;
end;

function  Tf_scriptengine.doGetI(varname:string; var i: Integer):Boolean;
begin
  result:=false;
end;

procedure Tf_scriptengine.Save(strbtn, strscr, eventscr: Tstringlist);
var m:TMemoryStream;
   i,j: integer;
   node:TTreeNode;
   buf,txt,nu: string;
   s:TStringList;
begin
  s:=TStringList.Create;
  strbtn.Clear;
  m:=TMemoryStream.Create;
  TreeView1.SaveToStream(m);
  m.Position:=0;
  strbtn.LoadFromStream(m);
  m.Free;
  strscr.Clear;
  eventscr.Clear;
  node:=TreeView1.Items.GetFirstNode;
  while node<>nil do begin
    buf:=words(node.Text,'',1,1,';');
    txt:=words(buf,'',1,1,'_');
    nu:=words(buf,'',2,1,'_');
    if (txt='Button')and(node.data<>nil)and(TObject(node.data) is TStringList) then begin
      s.Assign(TStringList(node.data));
      for j:=0 to s.count-1 do begin
         strscr.Add(nu+tab+s[j]);
      end;
    end;
    if (txt='Event')and(node.data<>nil)and(TObject(node.data) is TStringList) then begin
      s.Assign(TStringList(node.data));
      for j:=0 to s.count-1 do begin
         eventscr.Add(nu+tab+s[j]);
      end;
    end;
    node:=node.GetNext;
  end;
  s.Free;
end;

procedure Tf_scriptengine.Load(strbtn, strscr, eventscr: Tstringlist);
var m:TMemoryStream;
   bu,txt,cnu,nu,scrlin: string;
   i,j: integer;
   node:TTreeNode;
   s,p:TStringList;
begin
  // load toolbar
  m:=TMemoryStream.Create;
  strbtn.SaveToStream(m);
  m.Position:=0;
  TreeView1.LoadFromStream(m);
  m.Free;
  // load button scripts
  cnu:='';
  s:=TStringList.Create;
  p:=TStringList.Create;
  for i:=0 to strscr.Count-1 do begin
    bu:=strscr[i];
    SplitRec(bu,tab,p);
    if p.Count<2 then continue;
    nu:=p[0];
    scrlin:=p[1];
    if (cnu='') then cnu:=nu;
    if cnu=nu then begin
      s.Add(scrlin);
    end else begin
      node := TreeView1.Items.GetFirstNode;
      while Assigned(node) and (pos('Button_'+cnu+';',node.Text)<=0) do
            node := node.GetNext;
      if assigned(node) then begin
        txt:=node.text;
        node.Data:=s;
      end;
      s:=TStringList.Create;
      s.Add(scrlin);
      cnu:=nu;
    end;
  end;
  node := TreeView1.Items.GetFirstNode;
  while Assigned(node) and (pos('Button_'+cnu+';',node.Text)<=0) do
        node := node.GetNext;
  if assigned(node) then begin
    txt:=node.text;
    node.Data:=s;
  end;
  // load event script
  cnu:='';
  s:=TStringList.Create;
  for i:=0 to eventscr.Count-1 do begin
    bu:=eventscr[i];
    SplitRec(bu,tab,p);
    if p.Count<2 then continue;
    nu:=p[0];
    scrlin:=p[1];
    if (cnu='') then cnu:=nu;
    if cnu=nu then begin
      s.Add(scrlin);
    end else begin
      node := TreeView1.Items.GetFirstNode;
      while Assigned(node) and (pos('Event_'+cnu+';',node.Text)<=0) do
            node := node.GetNext;
      if assigned(node) then begin
        txt:=node.text;
        node.Data:=s;
      end;
      s:=TStringList.Create;
      s.Add(scrlin);
      cnu:=nu;
    end;
  end;
  node := TreeView1.Items.GetFirstNode;
  while Assigned(node) and (pos('Event_'+cnu+';',node.Text)<=0) do
        node := node.GetNext;
  if assigned(node) then begin
    txt:=node.text;
    node.Data:=s;
  end;

  p.free;
  ButtonApplyClick(self);
end;

Function Tf_scriptengine.AddGroup(num,capt:string; pt: TWinControl; ctlperline:integer=1):TGroupBox;
begin
inc(gnum);
SetLength(gr,gnum);
if num='' then num:=inttostr(gnum);
if capt='' then capt:='Group_'+num;
gr[gnum-1]:=TGroupBox.Create(self);
gr[gnum-1].Name:='Group_'+num;
gr[gnum-1].Caption:=capt;
gr[gnum-1].tag:=StrToIntDef(num,0);
gr[gnum-1].AutoSize:=true;
gr[gnum-1].top:=gnum;
gr[gnum-1].Align:=altop;
gr[gnum-1].ChildSizing.EnlargeHorizontal := crsHomogenousChildResize;
gr[gnum-1].ChildSizing.EnlargeVertical := crsHomogenousSpaceResize;
gr[gnum-1].ChildSizing.ShrinkHorizontal := crsHomogenousChildResize;
gr[gnum-1].ChildSizing.ShrinkVertical := crsHomogenousSpaceResize;
gr[gnum-1].ChildSizing.Layout := cclLeftToRightThenTopToBottom;
gr[gnum-1].ChildSizing.ControlsPerLine := ctlperline;
gr[gnum-1].Parent:=pt;
result:=gr[gnum-1];
end;

procedure Tf_scriptengine.AddButton(num,capt:string; pt: TWinControl);
var n: integer;
begin
inc(bnum);
SetLength(bt,bnum);
if num='' then num:=inttostr(bnum);
n:=StrToIntDef(num,bnum);
if capt='' then capt:='Button_'+num;
bt[bnum-1]:=Tbutton.Create(self);
bt[bnum-1].Name:='Button_'+num;
bt[bnum-1].Caption:=capt;
bt[bnum-1].tag:=n;
bt[bnum-1].OnClick:=@Button_Click;
bt[bnum-1].Parent:=pt;
scrnum:=max(scrnum,n+1);
SetLength(scr,scrnum);
scr[n]:=TPSScript.Create(self);
scr[n].tag:=n;
scr[n].OnCompile:=@TplPSScriptCompile;
scr[n].OnExecute:=@TplPSScriptExecute;
scr[n].Plugins.Assign(TplPSScript.Plugins);
end;

procedure Tf_scriptengine.Button_Click(Sender: TObject);
var n: integer;
begin
n:=TButton(sender).tag;
if (n<scrnum)and(scr[n].Script.Count>0) then begin
  CompileMemo.Clear;
  if scr[n].Execute then
    CompileMemo.Lines.Add('OK')
  else
    CompileMemo.Lines.Add('Failed! row='+inttostr(scr[n].ExecErrorRow)+': '+scr[n].ExecErrorToString);
end;
end;

procedure Tf_scriptengine.AddEdit(num:string; pt: TWinControl);
begin
inc(enum);
SetLength(ed,enum);
if num='' then num:=inttostr(enum);
ed[enum-1]:=TEdit.Create(self);
ed[enum-1].Name:='Edit_'+num;
ed[enum-1].tag:=StrToIntDef(num,0);
ed[enum-1].Text:='';
ed[enum-1].Parent:=pt;
end;

procedure Tf_scriptengine.AddMemo(num:string; pt: TWinControl;h: integer);
begin
inc(mnum);
SetLength(mem,mnum);
if num='' then num:=inttostr(mnum);
mem[mnum-1]:=TMemo.Create(self);
mem[mnum-1].Name:='Memo_'+num;
mem[mnum-1].tag:=StrToIntDef(num,0);
mem[mnum-1].Height:=h;
mem[mnum-1].Constraints.MinHeight:=h;
mem[mnum-1].Clear;
mem[mnum-1].ScrollBars:=ssAutoBoth;
mem[mnum-1].Parent:=pt;
end;

procedure Tf_scriptengine.AddSpacer(num:string; pt: TWinControl);
begin
inc(snum);
SetLength(sp,snum);
if num='' then num:=inttostr(snum);
sp[snum-1]:=TPanel.Create(self);
sp[snum-1].Name:='Spacer_'+num;
sp[snum-1].tag:=StrToIntDef(num,0);
sp[snum-1].BevelOuter:=bvNone;
sp[snum-1].Caption:='';
sp[snum-1].Parent:=pt;
end;

procedure Tf_scriptengine.ButtonApplyClick(Sender: TObject);
var node:TTreeNode;
   curgroup:TGroupBox;
   txt,parm1,parm2,parm3,buf,nu: string;
   i: integer;
begin
for i:=snum-1 downto 0 do sp[i].Free;
for i:=mnum-1 downto 0 do mem[i].Free;
for i:=enum-1 downto 0 do ed[i].Free;
for i:=bnum-1 downto 0 do bt[i].Free;
for i:=gnum-1 downto 0 do gr[i].Free;
bnum:=0; SetLength(bt,0);
enum:=0; SetLength(ed,0);
mnum:=0; SetLength(mem,0);
snum:=0; SetLength(sp,0);
gnum:=0; SetLength(gr,0);
node:=TreeView1.Items.GetFirstNode;
while node<>nil do begin
  buf:=words(node.Text,'',1,1,';');
  txt:=words(buf,'',1,1,'_');
  nu:=words(buf,'',2,1,'_');
  parm1:=words(node.Text,'',2,1,';');
  parm2:=words(node.Text,'',3,1,';');
  parm3:=words(node.Text,'',4,1,';');
  if txt='Group' then begin
    curgroup:=AddGroup(nu,parm1,FEditSurface,StrToIntDef(parm2,1));
    GroupIdx:=max(GroupIdx,strtoint(nu));
  end
  else if txt='Button' then begin
    AddButton(nu,parm1,curgroup);
    ButtonIdx:=max(ButtonIdx,strtoint(nu));
  end
  else if txt='Edit' then begin
    AddEdit(nu,curgroup);
    EditIdx:=max(EditIdx,strtoint(nu));
  end
  else if txt='Memo' then begin
    AddMemo(nu,curgroup,StrToIntDef(parm1,50));
    MemoIdx:=max(MemoIdx,strtoint(nu));
  end
  else if txt='Spacer' then begin
    AddSpacer(nu,curgroup);
    SpacerIdx:=max(SpacerIdx,strtoint(nu));
  end;
  node:=node.GetNext;
end;
CompileScripts;
if Assigned(FonApply) then FonApply(self);
end;

procedure Tf_scriptengine.ButtonAddClick(Sender: TObject);
var v,n: integer;
   buf,txt,num: string;
   ok:boolean;
   node:TTreeNode;
begin
if RadioButtonGroup.Checked then begin
  if (TreeView1.Selected=nil)or((TreeView1.Selected<>nil)and(TreeView1.Selected.Level=0)) then begin
    val(GroupRowEdit.Text,v,n);
    if n=0 then begin
      inc(GroupIdx);
      TreeView1.Selected:=TreeView1.Items.Add(TreeView1.Selected,'Group_'+inttostr(GroupIdx)+';'+StringReplace(GroupCaptionEdit.Text,';','',[rfReplaceAll])+';'+IntToStr(StrToIntDef(GroupRowEdit.Text,1)));
    end;
  end;
end else if RadioButtonButton.Checked then begin
  if (TreeView1.Selected<>nil)and(TreeView1.Selected.Level=0) then begin
    inc(ButtonIdx);
    TreeView1.Items.AddChild(TreeView1.Selected,'Button_'+inttostr(ButtonIdx)+';'+StringReplace(ButtonCaptionEdit.Text,';','',[rfReplaceAll]));
  end;
end else if RadioButtonEdit.Checked then begin
  if (TreeView1.Selected<>nil)and(TreeView1.Selected.Level=0) then begin
    inc(EditIdx);
    TreeView1.Items.AddChild(TreeView1.Selected,'Edit_'+inttostr(EditIdx));
  end;
end else if RadioButtonMemo.Checked then begin
  if (TreeView1.Selected<>nil)and(TreeView1.Selected.Level=0) then begin
    val(MemoHeightEdit.Text,v,n);
    if n=0 then begin
      inc(MemoIdx);
      TreeView1.Items.AddChild(TreeView1.Selected,'Memo_'+inttostr(MemoIdx)+';'+IntToStr(StrToIntDef(MemoHeightEdit.Text,1)));
    end;
  end;
end else if RadioButtonSpacer.Checked then begin
  if (TreeView1.Selected<>nil)and(TreeView1.Selected.Level=0) then begin
    inc(SpacerIdx);
    TreeView1.Items.AddChild(TreeView1.Selected,'Spacer_'+inttostr(SpacerIdx));
  end;
end else if RadioButtonEvent.Checked then begin
  if (TreeView1.Selected<>nil)and(TreeView1.Selected.Level=0) then begin
    ok:=true;
    node:=TreeView1.Items.GetFirstNode;
    while node<>nil do begin
      buf:=words(node.Text,'',1,1,';');
      txt:=words(buf,'',1,1,'_');
      num:=words(node.Text,'',2,1,';');
      if (txt='Event')and(num=IntToStr(EventComboBox.ItemIndex)) then begin
          ok:=false;
          break;
      end;
      node:=node.GetNext;
    end;
    if ok then begin
      num:=IntToStr(EventComboBox.ItemIndex);
      TreeView1.Items.AddChild(TreeView1.Selected,'Event_'+num+';'+num+';'+EventComboBox.Text);
    end;
  end;
end;
end;

procedure Tf_scriptengine.ButtonUpdateClick(Sender: TObject);
begin
if (TreeView1.Selected<>nil) then begin
  if RadioButtonGroup.Checked then begin
    TreeView1.Selected.Text:=words(TreeView1.Selected.Text,'',1,1,';')+';'+StringReplace(GroupCaptionEdit.Text,';','',[rfReplaceAll])+';'+IntToStr(StrToIntDef(GroupRowEdit.Text,1));
  end else if RadioButtonButton.Checked then begin
    TreeView1.Selected.Text:=words(TreeView1.Selected.Text,'',1,1,';')+';'+StringReplace(ButtonCaptionEdit.Text,';','',[rfReplaceAll]);
  end else if RadioButtonEdit.Checked then begin
     //
  end else if RadioButtonMemo.Checked then begin
    TreeView1.Selected.Text:=words(TreeView1.Selected.Text,'',1,1,';')+';'+IntToStr(StrToIntDef(MemoHeightEdit.Text,1));
  end else if RadioButtonSpacer.Checked then begin
     //
  end else if RadioButtonEvent.Checked then begin
    TreeView1.Selected.Text:=words(TreeView1.Selected.Text,'',1,1,';')+';'+IntToStr(EventComboBox.ItemIndex)+';'+EventComboBox.Text;
  end;
end;
end;

procedure Tf_scriptengine.EventComboBoxChange(Sender: TObject);
begin
//  if ButtonUpdate.Tag=4 then ButtonUpdate.Visible:=true;
end;

procedure Tf_scriptengine.GroupCaptionEditChange(Sender: TObject);
begin
  if ButtonUpdate.Tag=1 then ButtonUpdate.Visible:=true;
end;

procedure Tf_scriptengine.GroupRowEditChange(Sender: TObject);
var v,n: integer;
begin
  val(GroupRowEdit.Text,v,n);
  ButtonUpdate.Visible:=(n=0)and(ButtonUpdate.Tag=1);
end;

procedure Tf_scriptengine.MemoHeightEditChange(Sender: TObject);
var v,n: integer;
begin
  val(MemoHeightEdit.Text,v,n);
  ButtonUpdate.Visible:=(n=0)and(ButtonUpdate.Tag=3);
end;

procedure Tf_scriptengine.RadioButtonClick(Sender: TObject);
begin
  ButtonUpdate.Tag:=0;
  ButtonUpdate.Visible:=false;
end;

procedure Tf_scriptengine.ButtonCaptionEditChange(Sender: TObject);
begin
  if ButtonUpdate.Tag=2 then ButtonUpdate.Visible:=true;
end;

procedure Tf_scriptengine.TreeView1Change(Sender: TObject; Node: TTreeNode);
begin
ButtonUpdate.Tag:=0;
if node<>nil then begin
  if (pos('Group_',node.Text)=1) then begin
    ButtonEditScript.Visible:=false;
    RadioButtonGroup.Checked:=true;
    GroupCaptionEdit.Text:=words(node.Text,'',2,1,';');
    GroupRowEdit.Text:=words(node.Text,'',3,1,';');
    ButtonUpdate.Visible:=false;
    ButtonUpdate.Tag:=1;
  end else if (pos('Button_',node.Text)=1) then begin
    ButtonEditScript.Visible:=true;
    RadioButtonButton.Checked:=true;
    ButtonCaptionEdit.Text:=words(node.Text,'',2,1,';');
    ButtonUpdate.Visible:=false;
    ButtonUpdate.Tag:=2;
  end else if (pos('Edit_',node.Text)=1) then begin
    ButtonEditScript.Visible:=false;
    ButtonUpdate.Visible:=false;
    RadioButtonEdit.Checked:=true;
  end else if (pos('Memo_',node.Text)=1) then begin
    ButtonEditScript.Visible:=false;
    RadioButtonMemo.Checked:=true;
    MemoHeightEdit.Text:=words(node.Text,'',2,1,';');
    ButtonUpdate.Visible:=false;
    ButtonUpdate.Tag:=3;
  end else if (pos('Spacer_',node.Text)=1) then begin
    ButtonEditScript.Visible:=false;
    ButtonUpdate.Visible:=false;
    RadioButtonSpacer.Checked:=true;
  end else if (pos('Event_',node.Text)=1) then begin
    ButtonEditScript.Visible:=true;
    RadioButtonEvent.Checked:=true;
    EventComboBox.ItemIndex:=StrToIntDef(words(node.Text,'',2,1,';'),0);
    ButtonUpdate.Visible:=false;
    ButtonUpdate.Tag:=4;
  end;
end;
end;


procedure Tf_scriptengine.ButtonDeleteClick(Sender: TObject);
begin
if TreeView1.Selected<>nil then begin
  if MessageDlg('Delete '+TreeView1.Selected.Text+', all the child nodes and the scripts?', mtConfirmation, mbYesNo, 0)=mrYes then begin
    TreeView1.Items.Delete(TreeView1.Selected);
  end;
end;
end;

procedure Tf_scriptengine.ButtonLoadClick(Sender: TObject);
var ConfigScriptButton, ConfigScript, ConfigEvent: Tstringlist;
    fn,section,buf: string;
    inif: TMemIniFile;
    j,n: integer;
begin
if OpenDialog1.Execute then begin
  fn:=OpenDialog1.FileName;
  ConfigScriptButton:=Tstringlist.create;
  ConfigScript:=Tstringlist.create;
  ConfigEvent:=Tstringlist.create;
  inif:=TMeminifile.create(fn);
  try
  with inif do begin
  section:='ScriptPanel';
{  n:=ReadInteger(section,'numtoolbar1',0);
  for j:=0 to n-1 do Fscript[i].ConfigToolbar1.Add(ReadString(section,'toolbar1_'+inttostr(j),''));
  n:=ReadInteger(section,'numtoolbar2',0);
  for j:=0 to n-1 do Fscript[i].ConfigToolbar2.Add(ReadString(section,'toolbar2_'+inttostr(j),''));  }
  n:=ReadInteger(section,'numscriptbutton',0);
  for j:=0 to n-1 do begin
    buf:=ReadString(section,'scriptbutton_'+inttostr(j),'');
    if buf='' then continue;
    buf:=StringReplace(buf,'"','',[rfReplaceAll]);
    ConfigScriptButton.Add(buf);
  end;
  n:=ReadInteger(section,'numscriptrows',0);
  for j:=0 to n-1 do ConfigScript.Add(ReadString(section,'script_'+inttostr(j),''));
  n:=ReadInteger(section,'numevents',0);
  for j:=0 to n-1 do ConfigEvent.Add(ReadString(section,'event_'+inttostr(j),''));
  Load(ConfigScriptButton, ConfigScript, ConfigEvent);
  end;
  finally
   inif.Free;
  end;
end;
end;

procedure Tf_scriptengine.ButtonSaveClick(Sender: TObject);
var ConfigScriptButton, ConfigScript, ConfigEvent: Tstringlist;
    fn,section: string;
    inif: TMemIniFile;
    j,n: integer;
begin
if SaveDialog1.Execute then begin
  fn:=SaveDialog1.FileName;
  ConfigScriptButton:=Tstringlist.create;
  ConfigScript:=Tstringlist.create;
  ConfigEvent:=Tstringlist.create;
  Save(ConfigScriptButton, ConfigScript, ConfigEvent);
  inif:=TMeminifile.create(fn);
  try
  with inif do begin
  section:='ScriptPanel';
  EraseSection(section);
{  n:=ConfigToolbar1.Count;
  WriteInteger(section,'numtoolbar1',n);
  for j:=0 to n-1 do WriteString(section,'toolbar1_'+inttostr(j),ConfigToolbar1[j]);
  n:=Fscript[i].ConfigToolbar2.Count;
  WriteInteger(section,'numtoolbar2',n);
  for j:=0 to n-1 do WriteString(section,'toolbar2_'+inttostr(j),Fscript[i].ConfigToolbar2[j]); }
  n:=ConfigScriptButton.Count;
  WriteInteger(section,'numscriptbutton',n);
  for j:=0 to n-1 do WriteString(section,'scriptbutton_'+inttostr(j),'"'+ConfigScriptButton[j]+'"');
  n:=ConfigScript.Count;
  WriteInteger(section,'numscriptrows',n);
  for j:=0 to n-1 do WriteString(section,'script_'+inttostr(j),ConfigScript[j]);
  n:=ConfigEvent.Count;
  WriteInteger(section,'numevents',n);
  for j:=0 to n-1 do WriteString(section,'event_'+inttostr(j),ConfigEvent[j]);
  Updatefile;
  end;
  finally
   inif.Free;
  end;
end;
end;

procedure Tf_scriptengine.ButtonEditScriptClick(Sender: TObject);
var s:TStringList;
   txt:string;
   node:TTreeNode;
begin
if (TreeView1.Selected<>nil) then begin
  txt:=copy(TreeView1.Selected.Text,1,6);
  if (txt='Button')or(txt='Event_') then begin
    node:=TreeView1.Selected;
    if (node.data<>nil)and(TObject(node.data) is TStringList) then
       s:=(TStringList(node.data))
    else
       s:=TStringList.Create;
    if Fpascaleditor=nil then begin
      Fpascaleditor:=Tf_pascaleditor.Create(self);
    end;
    Fpascaleditor.SynEdit1.Lines.Assign(s);
    Fpascaleditor.ShowModal;
    if Fpascaleditor.ModalResult=mrOK then begin
      s.Assign(Fpascaleditor.SynEdit1.Lines);
      node.Data:=s;
    end;
  end;
end;
end;

procedure Tf_scriptengine.CompileScripts;
var i,j,n: integer;
    buf,txt,nu: string;
    node:TTreeNode;
begin
CompileMemo.Clear;
node:=TreeView1.Items.GetFirstNode;
while node<>nil do begin
  buf:=words(node.Text,'',1,1,';');
  txt:=words(buf,'',1,1,'_');
  nu:=words(buf,'',2,1,'_');
  if (txt='Button')and(node.data<>nil)and(TObject(node.data) is TStringList) then begin
    n:=strtoint(nu);
    scr[n].Script.Assign(TStringList(node.data));
    scr[n].Compile;
    for j:=0 to scr[n].CompilerMessageCount-1 do CompileMemo.Lines.Add('Script'+inttostr(n)+': '+ scr[n].CompilerErrorToStr(j));
  end;
  if (txt='Event')and(node.data<>nil)and(TObject(node.data) is TStringList) then begin
    n:=strtoint(nu);
    evscr[n].Script.Assign(TStringList(node.data));
    evscr[n].Compile;
    for j:=0 to evscr[n].CompilerMessageCount-1 do CompileMemo.Lines.Add('Script'+inttostr(n)+': '+ evscr[n].CompilerErrorToStr(j));
  end;
  node:=node.GetNext;
end;
end;

procedure Tf_scriptengine.FormCreate(Sender: TObject);
var i: integer;
begin
  gnum:=0;
  bnum:=0;
  enum:=0;
  mnum:=0;
  snum:=0;
  scrnum:=0;
  GroupIdx:=0;
  ButtonIdx:=0;
  EditIdx:=0;
  MemoIdx:=0;
  SpacerIdx:=0;
  evscrnum:=3;
  SetLength(evscr,evscrnum);
  for i:=0 to evscrnum-1 do begin
    evscr[i]:=TPSScript.Create(self);
    evscr[i].tag:=i;
    evscr[i].OnCompile:=@TplPSScriptCompile;
    evscr[i].OnExecute:=@TplPSScriptExecute;
    evscr[i].Plugins.Assign(TplPSScript.Plugins);
  end;
end;

procedure Tf_scriptengine.ClearTreeView;
var i: integer;
    buf,txt: string;
    node:TTreeNode;
begin
node:=TreeView1.Items.GetFirstNode;
while node<>nil do begin
  buf:=words(node.Text,'',1,1,';');
  txt:=words(buf,'',1,1,'_');
  if (txt='Button')and(node.data<>nil)and(TObject(node.data) is TStringList) then begin
     TStringList(node.data).Free;
  end;
  if (txt='Event')and(node.data<>nil)and(TObject(node.data) is TStringList) then begin
     TStringList(node.data).Free;
  end;
  node:=node.GetNext;
end;
TreeView1.Items.Clear;
GroupIdx:=0;
ButtonIdx:=0;
EditIdx:=0;
MemoIdx:=0;
SpacerIdx:=0;
EventIdx:=0;
end;

procedure Tf_scriptengine.FormDestroy(Sender: TObject);
begin
  ClearTreeView;
  TreeView1.free;
  if Fpascaleditor<>nil then Fpascaleditor.Free;
end;

procedure Tf_scriptengine.ButtonClearClick(Sender: TObject);
begin
if MessageDlg('This action remove all the component and you lose all your scripts.', mtConfirmation, mbYesNo, 0)=mrYes then begin
   ClearTreeView;
end;
end;

procedure Tf_scriptengine.TplPSScriptCompile(Sender: TPSScript);
var i: integer;
  procedure ProcessMenu(Amenu: TMenuItem);
  var k: integer;
  begin
    for k:=0 to Amenu.Count-1 do begin
       TPSScript(Sender).AddRegisteredVariable(Amenu.Items[k].Name, 'TMenuItem');
       ProcessMenu(Amenu[k]);
    end;
  end;

begin
with Sender as TPSScript do begin
  for i:=1 to bnum do AddRegisteredVariable('Button_'+inttostr(i), 'TButton');
  for i:=1 to enum do AddRegisteredVariable('Edit_'+inttostr(i), 'TEdit');
  for i:=1 to mnum do AddRegisteredVariable('Memo_'+inttostr(i), 'TMemo');
  comp.AddConstantN('deg2rad', 'extended').SetExtended(deg2rad);
  comp.AddConstantN('rad2deg', 'extended').SetExtended(rad2deg);
  AddMethod(self, @Tf_scriptengine.doExecuteCmd, 'function  Cmd(cname:string; arg:Tstringlist):string;');
  AddMethod(self, @Tf_scriptengine.doGetS, 'function GetS(varname:string; var str: string):Boolean;');
  AddMethod(self, @Tf_scriptengine.doGetI, 'function GetI(varname:string; var i: Integer):Boolean;');
  AddMethod(self, @Tf_scriptengine.doGetD, 'function GetD(varname:string; var x: double):boolean;');
  AddFunction(@ARtoStr, 'Function ARToStr(ar: Double) : string;');
  AddFunction(@DEtoStr, 'Function DEToStr(de: Double) : string;');
end;
ProcessMenu(FMainmenu.Items);
end;

procedure Tf_scriptengine.TplPSScriptExecute(Sender: TPSScript);
var i: integer;
  procedure ProcessMenu(Amenu: TMenuItem);
  var k: integer;
  begin
    for k:=0 to Amenu.Count-1 do begin
       TPSScript(Sender).SetVarToInstance(Amenu.Items[k].Name, Amenu.Items[k]);
       ProcessMenu(Amenu[k]);
    end;
  end;

begin
with Sender as TPSScript do begin
  for i:=1 to bnum do SetVarToInstance('Button_'+inttostr(i), bt[i-1]);
  for i:=1 to enum do SetVarToInstance('Edit_'+inttostr(i), ed[i-1]);
  for i:=1 to mnum do SetVarToInstance('Memo_'+inttostr(i), mem[i-1]);
end;
ProcessMenu(FMainmenu.Items);
end;

procedure Tf_scriptengine.ChartRefreshEvent(origin,str:string);
begin
ChartName:=origin;
RefreshText:=str;
evscr[0].Execute;
end;

procedure Tf_scriptengine.ObjectSelectionEvent(origin,str:string);
var l:integer;
begin
ChartName:=origin;
l:=length(rsFrom);
if copy(str,1,l)=rsFrom then DistanceText:=str
   else SelectionText:=str;
evscr[1].Execute;
end;

procedure Tf_scriptengine.TelescopeMoveEvent(origin:string; ra,de: double);
begin
ChartName:=origin;
TelescopeRA:=ra;
TelescopeDE:=de;
evscr[2].Execute;
end;

end.

