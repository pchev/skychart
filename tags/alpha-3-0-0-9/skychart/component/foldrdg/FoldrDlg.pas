(*
  TFolderDialog Component for Borland Delphi 32 wraps the Windows 95/NT 4.0+
    Shell32 dialog 'Browse For Folder' into a true native, customizable
    and extendable Delphi component.

  Copyright (C) 1997, 1998, 1999  Fred de Jong - Heerlen - Netherlands

  This library is free software; you can redistribute it and/or
  modify it under the terms of the GNU Library General Public
  License as published by the Free Software Foundation; either
  version 2 of the License, or (at your option) any later version.
  This library is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
  Library General Public License for more details.
  You should have received a copy of the GNU Library General Public
  License along with this library; if not, write to the
  Free Software Foundation, Inc., 59 Temple Place - Suite 330,
  Boston, MA  02111-1307, USA.

  FoldrDlg.pas - 12 October 1997, 26 Oct 1997, 2 Apr 1999

  Most ideas and parts of this source originate from the freeware
  TBrowseFolder component written by:
   - Todd Fast, Pencilneck Software, tfast@eden.com, pencilneck@hotmail.com
           http://www.eden.com/~tfast/pencilneck.html
   - Alin Flaider, aflaidar@datalog.ro
   - Ahto Tanner, ahto@moonsoftware.ee, http://www.moonsoftware.ee
   - Manuel Duarte

  It was redesigned to a Delphi 'naturalized' TFolderDialog and
  brought under the 'GNU Library General Public License' by:
   - Fred de Jong, frejon@worldonline.nl, fjng@cbs.nl

  The TFolderDialog librarycomponent is CopyLefted software, see
  accompanying COPYLIB.htm text, added to this distribution, and:
  http://agnes.dida.physik.uni-essen.de/gnu/copyleft/lgpl.html

  For Free Software Foundation, see:
  http://agnes.dida.physik.uni-essen.de/gnu/fsf/fsf.html

  11 Oct 97:
    Added support for any custombutton derived from TButtonControl.
    Added bfResizeCustomButton Option (def. off).
  26 Oct 97: fdj:
    Support Delphi 2 without the need to modify source (except for DELPHI2 define).
    Added Option bfBrowseIncludeFiles to allow TFolderDialog to show
      files in it's common browse treeview too.
  09 Nov 97: fdj:
    DirectoryExists now recognizes rootdirectories of drives too.
    Added public read/only property SelectionAttributes, having
       ShlObj.SFGAO_* attribute bits of selected shellitem (e.g. SFGAO_LINK).
    Keep internal FSelectionIDList relative between Execute-s where
       possible to prevent preselect along absolute path.
    When CustomButton is clicked, only change TemplateButton's Checked state.
  10 Nov 97: fdj:
    Prevent firing checkable CustomButton's OnClick on dlg close.
    Compiles with D2.01 again. Using unit D2ShlObj i.s.o. D2.01's ShlObj.
    To do: Changed name of property Directory to Path (because option
        bfBrowseIncludeFiles makes the dlg return filenames too).
  11 Nov 97: fdj:
    Presetting prop. Directory now functions again.
    Ensure FSelectionPath and FSelectionIDList are a pair:
      they must be both empty/nil or both refer to same thing.
  12 Nov 97: fdj:
    Removed bug: CustomButton made Owner's reference to FolderDialog
      invalid because it cleared FolderDialog's Name;
    Fixed D2.01 IDE raising "Control '<ButtonName>' has no parent window",
      leaving IDE's cmplib in EAccessViolation state.
  27 feb 99: fdj:
    Compile for Delphi 4.0: give DefaultHandler public visibility.
  2 apr 99: fdj:
    Compile for Delphi 4 Upgrade Pack 2: give DefineProperties public
      visibility.
*)
{
  Adapted for Skychart project December 1st 2002 P. Chevalley

  Remove Delphi 2 compatibility
  Remove Design time support, now compile fine with Delphi 6
}

{$BOOLEVAL OFF}

UNIT FoldrDlg;

INTERFACE

uses
  Windows, Messages, Classes, Controls, StdCtrls, Dialogs,
  ActiveX, ShlObj;

type
  TFolderDialogOption = (
       bfFileSysDirsOnly, bfDontGoBelowDomain, bfStatusText,
       bfFileSysAncestors, bfBrowseForComputer, bfBrowseForPrinter,
       bfBrowseIncludeFiles, { fdj 26-10 }
       { added extra browsefolder options: fdj }
       bfShowPathInStatusArea, bfSyncCustomButton, bfAlignCustomButton,
       bfScreenCenter, bfParentCenter, bfResizeCustomButton
       );
  TFolderDialogOptions = set of TFolderDialogOption;

  TShellFolder = (sfoDesktopExpanded,sfoDesktop,sfoPrograms,sfoControlPanel,
    sfoPrinters,sfoPersonal,sfoFavorites,sfoStartup,sfoRecent,
    sfoSendto,sfoRecycleBin,sfoStartMenu,sfoDesktopDirectory,sfoMyComputer,
    sfoNetwork,sfoNetworkNeighborhood,sfoFonts,sfoTemplates,
    { sfoCommon* is for NT 4.0+ only: fdj }
    sfoCommonStartMenu, sfoCommonPrograms, sfoCommonStartup,
    sfoCommonDesktopDirectory, sfoAppData, sfoPrintHood
    );

type
{ TFolderDialog is a shell supplied task modal dialog with
    active events and customizable buttoncontrol }
  TFolderDialog = class(TCommonDialog)
  private
    FHandle: HWnd;
    FXDefWndProc, FXObjectInstance: Pointer;
    FParent: TWinControl;
    FCaption, FTitleText, FStatusText: String;
    FDisplayName: string;
    FImageIndex: Integer;
    FDirectory: string;
    FOptions: TFolderDialogOptions;
    FRootFolder: TShellFolder;
    FClientWidth, FClientHeight: integer;
    FOkBtnHandle: HWND;
    FTemplateButton: TButtonControl;
    FCustomButton: TButtonControl;
    FOnChange: TNotifyEvent;
    FFirstShowDone: boolean;
    FBrowseInfo: TBrowseInfo;
    FDummyCtl3D: boolean;
    // pointers to Shell ID list (PIDL)
    FRootIDList: PItemIDList; // corresponds with RootFolder
    FDirectoryIDList: PItemIDList; // dlg result
    FSelectionIDList: PItemIDList; // always absolute, from root of namespace, updated by BFFMSelChanged;
    FSelectionAttributes: integer; // ShlObj.SFGAO_* bits
    { GPV* = GetPropertyValue, SPV* = SetPropertyValue }
    class       procedure InitializeClass;
    class       function GetDlgCtlPixelRect(duX, duY, duCX, duCY: word): TRect;
    procedure   CenterOnParent;
    function    BffScaledX(dlgpixX: integer): integer;
    function    BffScaledY(dlgpixY: integer): integer;
    function    GPVHandle: HWND;
    procedure   SPVParent(const Value: TWinControl);
    function    GPVDirectory: string;
    procedure   SPVDirectory(const Value: string);
    function    GPVCustomButton: TButtonControl;
    procedure   SPVOptions(const Value: TFolderDialogOptions);
    function    GPVCaption: string;
    procedure   SPVCaption(const Value: string);
    procedure   SPVDesignedTop(Value: integer);
    procedure   SPVDesignedLeft(Value: integer);
    function    GPVDesignedTop: integer;
    function    GPVDesignedLeft: integer;
    procedure   SPVStatusText(const Value: string);
    procedure   SPVCustomButton(Value: TButtonControl);
    function    GPVParent: TWinControl;
    function    GPVParentHandle: HWND;
    procedure   SPVRootFolder(Value: TShellFolder);
    procedure   SPVSelectionPIDL(const Value: PItemIDList);
    function    GPVSelectionPath: string;
    procedure   SPVSelectionPath(const Value: String); { triggers OnChange }
    procedure   SPVDummyCtl3D(Value: boolean);
    procedure   WMShowWindow(var Message: TWMShowWindow); message WM_SHOWWINDOW;
    procedure   WMCommand(var Message: TWMCommand); message WM_COMMAND;
    procedure   WMDestroy(var Message: TWMDestroy); message WM_DESTROY;
    procedure   WMNCDestroy(var Message: TWMNCDestroy); message WM_NCDESTROY;
    procedure   DoChange;
    procedure   ReplaceSelection(PIDL: PItemIDList);
    class function Desktop: IShellFolder;
    class function MAlloc: IMalloc;
    function    GetPathFromIDList(const ItemIDList: PItemIDList;
                           var Path: string): boolean;
    function    GetIDListFromPath(Path: String; var AbsItemIDList: PItemIDList): boolean;
    procedure   FreeIDList(var PIDL: PItemIDList);
    function    CloneIDListFrom(PIDL: PItemIDList): PItemIDList;
  protected
    function    CreateCustomControl(ATemplateControl: TWinControl): TWinControl;
    procedure   PositionWindow; virtual;
    property    ParentHandle: HWnd read GPVParentHandle;
    procedure   BFFMInitialized(Param: integer);
    procedure   BFFMSelChanged(Param: integer);
    procedure   Notification(AComponent: TComponent; Operation: TOperation); override;
  public
    procedure   DefineProperties(Filer: TFiler); override;
    procedure   DefaultHandler(var Message); override;
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    // procedure   SetBounds(ALeft, ATop, AWidth, AHeight: Integer);
    { a defined Parent makes Top, Left position relative to it's client }
    property    Parent: TWinControl read GPVParent write SPVParent;
    function    Execute: Boolean; override;
    { DisplayName is dlg result when browsing non-filesystemfolders
          (e.g. bfBrowseForComputer) }
    property    DisplayName: String read FDisplayName;
    property    ImageIndex: Integer read FImageIndex; // icon index in system imagelist
    { next are valid while Executing }
    property    Handle: HWND read GPVHandle;
    function    Perform(Msg: Cardinal; WParam, LParam: Longint): Longint;
    property    ClientWidth: integer read FClientWidth;
    property    ClientHeight: integer read FClientHeight;
    property    StatusText: string read FStatusText write SPVStatusText;
    {procedure   Refresh; // SHChangeNotify}
    procedure   EnableOK(const Value: Boolean);
    property    SelectionPath: string read GPVSelectionPath write SPVSelectionPath;
    // SelectionPIDL is, as the dlg result, absolute, from root of namespace
    property    SelectionPIDL: PItemIDList read FSelectionIDList write SPVSelectionPIDL;
    property    RootPIDL: PItemIDList read FRootIDList; // set by prop. RootFolder
    // SelectionAttributes receive ShlObj.SFGAO_* bits of last selected item
    property    SelectionAttributes: integer read FSelectionAttributes;
  published
    // ignore inherited Ctl3D (can't unpublish Ctl3D again ?)
    property    Ctl3D: boolean read FDummyCtl3D write SPVDummyCtl3D
                       stored False default True;
    property    Top: integer read GPVDesignedTop write SPVDesignedTop;
    property    Left: integer read GPVDesignedLeft write SPVDesignedLeft;
    property    Title: string read GPVCaption write SPVCaption;
    property    Directory: String read GPVDirectory write SPVDirectory;
    property    Text: String read FTitleText write FTitleText;
    property    Options: TFolderDialogOptions read FOptions write SPVOptions
                   default [bfFileSysDirsOnly, bfStatusText, bfSyncCustomButton,
                            bfShowPathInStatusArea, bfAlignCustomButton, bfParentCenter];
    property    RootFolder: TShellFolder read FRootFolder write SPVRootFolder
                   default sfoDesktopExpanded;
    property    CustomButton: TButtonControl read GPVCustomButton write SPVCustomButton;
    property    OnShow  ;
    property    OnClose ;
    property    OnChange: TNotifyEvent read FOnChange write FOnChange;
  end;

procedure Register;

IMPLEMENTATION

uses
  SysUtils, Forms,
  ShellAPI, Registry;

var
  ClassInitialized: boolean = False;

// TFolderDialog support functions
//---------------------------------------------------------------//

procedure CopyPropertyValues(const Source, Dest: TComponent;
            const AOwner: TComponent; const AParent: TControl); {fdj}
{ copies non-default values of published properties from Source
  to Dest, including references to EventHandlers should they be
    implemented by Source.Owner }
var
  MS: TMemoryStream;
  W: TWriter;
  R: TReader;
begin
  { see also: TReader.CopyValue(Writer); }
  MS:= TMemoryStream.Create;
  try
    { custom MS.WriteComponent(Source) }
    W:= TWriter.Create(MS, 256{BufSize});
    try with W do
    begin
      { method props. are only written when Root has the EventHandlers implemented }
      Root:= Source.Owner; IgnoreChildren:= True;
      Ancestor:= nil; RootAncestor:= nil;
      WriteComponent(Source);
      FlushBuffer;
    end
    finally W.Free end;
    MS.Position:= 0;
    { custom MS.ReadComponent(Dest) }
    R:= TReader.Create(MS, 256);
    try with R do
    begin
      Root:= Source.Owner; IgnoreChildren:= True;
      Ancestor:= nil;
      BeginReferences;
      try
        Owner:= AOwner; Parent:= AParent;
        ReadComponent(Dest);
        FixupReferences;
      finally
        EndReferences;
        end;
    end
    finally R.Free end;
  finally MS.Free end;
end;

function DirectoryExists(const Path: string): boolean;
var
  H: THandle; WFD: TWin32FindData;
begin
  H:= Windows.FindFirstFile(PChar(Path), WFD);
  if H <> INVALID_HANDLE_VALUE then
  begin
    Result := ((WFD.dwFileAttributes and FILE_ATTRIBUTE_DIRECTORY) =
               FILE_ATTRIBUTE_DIRECTORY);
    Windows.FindClose(H);
  end
  else
    { check for root paths like 'C:\' }
    Result:= Windows.GetDriveType(PChar(Path)) <> 1;
end;

function TFolderDialog.GetPathFromIDList(const ItemIDList: PItemIDList;
            var Path: string): boolean;
begin
  SetLength(Path, MAX_PATH);
// { support ItemIDLists relative to FolderRoot }
//  Result:= IRootFolder.GetDisplayNameOf(ItemIDList,,)

// else assume it's absolute:
  Result:= SHGetPathFromIDList(ItemIDList, PChar(Path));
  if Result then SetLength(Path, Strlen(PChar(Path)));
  if not Result then Path:= '';
end;

{ ----------------- }

{$IFDEF DUMPIDLIST}
const
  CrLf = chr($D)+chr($A);

function ClsIdDescription(const CLSID: TCLSID): string;
{ Returns a class description from: HKCR\'CLSID'\<CLSID> - default value }
var
  Reg: TRegistry;
begin
  Result:= ''; Reg:= TRegistry.Create;
  try with Reg do
    begin
      RootKey:= HKEY_CLASSES_ROOT;
      if OpenKey('CLSID\' + GUIDToString(CLSID), False) then
        try Result:= ReadString('')
        finally CloseKey end;
    end
  finally Reg.Free end;
end;

procedure DumpIDList(IDL: PItemIDList);
{ fdj: debug only: show parsed IDList from Shell Explorer Namespace }
const
  { Shell Item ID Format Types as seen in 1st byte (mkid.abid[0])
     of any ItemID from an ItemIDList }
  C_ShID_CLSID = $1F; { rootclass, CLSID at mkid.abid[2], e.g. MyComputer }
  C_ShID_Drive = $23; { rootdir at mkid.abid[1] e.g. 'F:\' }
  C_ShID_CDRom = $25; { rootdir at mkid.abid[1] e.g. 'I:\' }
  C_ShID_Floppy = $29; { rootdir at mkid.abid[1] e.g. 'A:\' }
  C_ShID_Container {?} = $2E; { unnamed, CLSID at mkid.abid[2]; e.g. DialUpNetworking, ControlPanel }
  C_ShID_SubDir = $31; { <longname><shortname> at mkid.abid[2] }
  C_ShID_File = $32; { <longname><shortname> at mkid.abid[2] }
  C_ShID_Briefcase = $B1; { e.g. 'My Briefcase'.<CLSID> }
  C_ShID_ControlPanelItem = $00; { <path><displayname><hinttext> }

  function ShowChar(B: byte): char;
  begin
    if (B >= ord(' ')) and (B <= ord('z')) then Result:= chr(B)
    else Result:= '.'
  end;

var
  Level, N, I: integer;
  E, S: string;
begin
  if Assigned(IDL) then
  begin
    Level:= 0; S:= 'ItemIDList at $'+IntToHex(integer(IDL), 8)+ CrLf;
    while (IDL^.mkId.cb <> 0) and (Level < 200) do
    begin
    {$IFOPT R+}{$DEFINE _DORANGEON}{$RANGECHECKS OFF}{$ELSE}{$UNDEF _DORANGEON}{$ENDIF}
      N:= IDL^.mkId.cb;
      S:= S + 'Level '+IntToStr(Level)+': Size = ' + IntToStr(N) + CrLf;
      E:= '''';
      for I:= 0 to (N - 2{sizeof(TSHItemID.cb)} - 1) do
      begin
        S:= S + '$' + IntToHex(IDL^.mkid.abid[I], 2);
        E:= E + ShowChar(IDL^.mkid.abid[I]);
      end;
      S:= S + CrLf + E + '''' + CrLf;
      case IDL^.mkid.abID[0] of
        C_ShID_CLSID, C_ShID_Container:
          begin
            I:= 2; // suppress compiler warning
            S:= S + 'CLSID descr. = ''' +
                ClsIdDescription(PCLSID(@IDL^.mkid.abID[I])^) + '''' + CrLf;
          end;
        else ;
        end;
      IDL:= PItemIdList(@IDL^.mkId.abID[N - 2{sizeof(TSHItemID.cb)}]);
    {$IFDEF _DORANGEON}{$RANGECHECKS ON}{$UNDEF _DORANGEON}{$ENDIF}
      inc(Level);
    end;
    ShowMessage(S);
  end;
end;
{$ENDIF} {DUMPIDLIST}

//-------------------------------------------------------------------------//

// ShlObj.TFNBFFCallBack
function CBBrowseForFolder(Wnd: HWND; uMsg: UINT;
                           lParam, lpData: LPARAM): Integer stdcall;
// lpData contains TFolderDialog instance
begin
  Result:= 0;
  with TObject(lpData) as TFolderDialog do
  case uMsg of
    BFFM_INITIALIZED:
      begin
        FHandle := Wnd;
        // Hook the dialog's window procedure
        FXDefWndProc := pointer(SetWindowLong(
          FHandle, GWL_WNDPROC, integer(FXObjectInstance)));
        BFFMInitialized(lParam);
      end;
    BFFM_SELCHANGED:
      BFFMSelChanged(lParam);
    end;
end;

{ TFolderDialog }

{ class variables }
var
  ClassFDIMalloc: IMalloc = nil;
  ClassFDIDesktop: IShellFolder = nil;

{ class methods }

{ fdj: next pseudo class properties are RefCnt neutral }

{$IFDEF CHKREFCNT}
procedure ShowRefCnt(IU: IUnknown);
var N: integer;
begin
  if Assigned(IU) then
  begin
    N:= IU._AddRef;
    ShowMessage('TFolderDialog IUnknown RefCnt = '+IntToStr(N));
    IU._Release;
  end;
end;
{$ENDIF}

class function TFolderDialog.MAlloc: IMalloc;
begin
  if not Assigned(ClassFDIMalloc) then
    SHGetMalloc(ClassFDIMalloc); // CoGetMalloc(MEMCTX_TASK{1}, ClassFDIMalloc);
  Result:= ClassFDIMalloc;
end;

class function TFolderDialog.Desktop: IShellFolder;
begin
  if not Assigned(ClassFDIDesktop) then
    // D3: ClassFDIDesktop:= CreateCOMObject(CLSID_ShellDesktop) as IShellFolder;
    //  same as:
    if SHGetDesktopFolder(ClassFDIDesktop) <> NOERROR then
      ClassFDIDesktop:= nil;
  Result:= ClassFDIDesktop;
  {$IFDEF CHKREFCNT}
  ShowRefCnt(Result);
  {$ENDIF}
end;

procedure TFolderDialog.FreeIDList(var PIDL: PItemIDList);
begin
  if Assigned(PIDL) then
    if Malloc.DidAlloc(PIDL) = 1 then
    begin
      Malloc.Free(PIDL); PIDL:= nil;
    end
end;

function TFolderDialog.GetIDListFromPath(Path: String; var AbsItemIDList: PItemIDList): boolean;
// Generate an absolute PIDL from the given filesystem path name
// Don't forget, free the AbsItemIDList using
//    ClassFDIMalloc.Free(AbsItemIDList)
var
  Eaten: ULONG;
  Attr: ULONG; { SFGAO_* }
  WSP: PWideChar;
  WS: WideString;
  H: HWND;
begin
  Result:= false; AbsItemIDList:= nil;
  if DirectoryExists(Path) then
  begin
    { 1st ItemID in AbsItemIDList will be 'My Computer' }
    if Copy(Path, length(Path) - 1, 2) = '\.' then
      { ParseDisplayName doesn't parse Paths like 'F:\Winnt\.' correctly }
      Path:= Copy(Path, 1, length(Path)-1);
      WS:= Path; WSP:= PWideChar(WS);
    H:= ParentHandle;
    Result:= Desktop.ParseDisplayName(H, nil,
      WSP, Eaten, AbsItemIDList, Attr) = NOERROR;
    if Result and (
        ((Attr and SFGAO_FILESYSTEM) <> SFGAO_FILESYSTEM) {or
         (Eaten <> length(WS))}
       ) then
    begin
      Malloc.Free(AbsItemIDList);
      Result:= false; AbsItemIDList:= nil;
    end;
  end
end;

procedure TFolderDialog.SPVDummyCtl3D(Value: boolean);
begin
  {ignore change requests}
end;

procedure TFolderDialog.SPVRootFolder(Value: TShellFolder);
const
  SH_FOLDERS_MAP: array[TShellFolder] of Integer=
   (-1 {foDesktopExpanded}, CSIDL_DESKTOP,
    CSIDL_PROGRAMS, CSIDL_CONTROLS, CSIDL_PRINTERS, CSIDL_PERSONAL, CSIDL_FAVORITES,
    CSIDL_STARTUP, CSIDL_RECENT, CSIDL_SENDTO, CSIDL_BITBUCKET, CSIDL_STARTMENU,
    CSIDL_DESKTOPDIRECTORY, CSIDL_DRIVES, CSIDL_NETWORK, CSIDL_NETHOOD, CSIDL_FONTS,
    CSIDL_TEMPLATES,
    { CSIDL_COMMON_* is for NT 4.0+ }
    CSIDL_COMMON_STARTMENU, CSIDL_COMMON_PROGRAMS, CSIDL_COMMON_STARTUP,
    CSIDL_COMMON_DESKTOPDIRECTORY, CSIDL_APPDATA, CSIDL_PRINTHOOD
    );
var
  Folder: integer;
begin
  if FRootFolder <> Value then
  begin
    FreeIDList(FSelectionIDList);
    FreeIDList(FDirectoryIDList);
    FreeIDList(FRootIDList);
    FRootFolder:= Value; Folder:= SH_FOLDERS_MAP[FRootFolder];
  // Atoh Taner:
  // If root is NIL, it shows MyComputer expanded so both drives and network stuff are visible.
  // This is default Desktop, but I don't know why SHGetSpecialFolderLocation retrieves poor PIDL, so
  // it doesn't collapse tree. It's nice if it is expanded.  :)
    if Folder <> -1 then
      {Get the pointer to the appropriate folder pidl as the root}
      if SHGetSpecialFolderLocation(ParentHandle, Folder, FRootIDList) <> 0 then
        FRootIDList:= nil;
  end;
end;

(*
procedure TFolderDialog.Refresh;
{ This has no effect:
   Looks like the dlg's TreeView is not sensitive to
      shell's systemwide change notifications (also no F5-key):
      the dlg doesn't refresh his IShellFolder interface }
const
  SHCNE_FOLDEREVENTS =
    SHCNE_MKDIR or SHCNE_RMDIR or
    SHCNE_MEDIAINSERTED or SHCNE_MEDIAREMOVED or
    SHCNE_DRIVEREMOVED or SHCNE_DRIVEADD or
    SHCNE_UPDATEDIR or SHCNE_DRIVEADDGUI or SHCNE_RENAMEFOLDER;
var
  P1, p2: pointer; dw1, dw2: dword;
begin
  dw1:= 0; dw2:= 0; p1:= @dw1; p2:= @dw2;
  if Assigned(FRootIDList) then p1:= FRootIDList;
  if Assigned(FSelectionIDList) then p2:= FSelectionIDList;
  SHChangeNotify(SHCNE_FOLDEREVENTS{SHCNE_RENAMEFOLDER},
    SHCNF_IDLIST or SHCNF_FLUSH{NOWAIT}, p1, p2);
end;
*)

procedure TFolderDialog.SPVCustomButton(Value: TButtonControl);
begin
  { make sure we get a notification when the CustomButton is destroyed }
  if Assigned(Value) then
    Value.FreeNotification(Self);
  FTemplateButton:= Value;
end;

procedure TFolderDialog.Notification(AComponent: TComponent; Operation: TOperation);
begin
  { called by inherited Create(AOwner) in our ctor too }
  if Operation = opRemove then
  begin
    if AComponent = FCustomButton then FCustomButton:= nil
    else
    if AComponent = FTemplateButton then FTemplateButton:= nil
  end;
  { pass on to our Owner if any }
  inherited Notification(AComponent, Operation);
end;

procedure TFolderDialog.DefineProperties(Filer: TFiler);
begin
{ The call to inherited TComponent.DefinedProperties is omitted
  since the Left and Top special properties are redefined with
  real properties. }
end;

(*
NT 4.0 WKS Build 1381 SP3: Shell32.dll resource:
DIALOG #1079 x=46, y=21, w=212, h=188
Title "Browse for Folder"
FONT "MS Shell Dlg", POINTSIZE 8
TEXT Title "" id = $3742 'B7' x=7, y=7, w=160, h=20
TEXT Status "" id = $3743 'C7' x=7, y=27, w=160, h=12
STATIC Status "" id = $3744 'D7' x=7, y=27, w=160, h=12
TREEVIEW "" id = $3741 'A7' x=7, y=42, w=197, h=112
DEFAULTPUSHBUTTON "OK" id = 1 x=100, y=166, w=50, h=14
PUSHBUTTON "Cancel" id = 2 x=154, y=166, w=50, h=14
*)
const
  ID_BFF_OK = 1;
  ID_BFF_CANCEL = 2;
  ID_BFF_TREEVIEW = $3741;
  ID_BFF_TITLE = $3742;
  ID_BFF_STATUSTEXT = $3743;
  ID_BFF_STATUSSTATIC = $3744;

{ class variables for precise aligments (pixels) }
var
  DialogBase: packed record unitX, unitY: word end;
   { e.g.: small fonts = (8,16), large fonts = (10,20) }
  BffDlgRect: TRect;
  BffCtlStatusAreaRect: TRect;
  BffCtlOkBtnRect: TRect;
  BffCtlCancelBtnRect: TRect;
  BffClientScaleXDiv: integer;
  BffClientScaleYDiv: integer;

class function TFolderDialog.GetDlgCtlPixelRect(duX, duY, duCX, duCY: word): TRect;
begin
  with Result do
  begin
    { pixelX = (dialogunitX * baseunitX) / 4
      pixelY = (dialogunitY * baseunitY) / 8 }
    Left:= duX; Left := (Left * DialogBase.unitX) div 4;
    Top:= duY; Top:=(Top * DialogBase.unitY) div 8;
    Right:= duX+duCX; Right := (Right * DialogBase.unitX) div 4;
    Bottom:= duY+duCY; Bottom:= (Bottom * DialogBase.unitY) div 8;
  end;
end;

class procedure TFolderDialog.InitializeClass;
begin
  ClassInitialized:= true;
  longint(DialogBase) := GetDialogBaseUnits;
  { next values are from Shell32.dll DIALOG resource  #1079 }
  BffDlgRect := GetDlgCtlPixelRect(46, 21, 212, 188);
  BffCtlStatusAreaRect := GetDlgCtlPixelRect(7, 27, 160, 12);
  BffCtlOkBtnRect:= GetDlgCtlPixelRect(100, 166, 50, 14);
  BffCtlCancelBtnRect := GetDlgCtlPixelRect(154, 166, 50, 14);
  BffClientScaleXDiv := BffDlgRect.Right-BffDlgRect.Left;
  BffClientScaleYDiv := BffDlgRect.Bottom-BffDlgRect.Top;
end;

function TFolderDialog.BffScaledX(dlgpixX: integer): integer;
begin
  { compensate for Mapping Mode of dialog's canvas }
  Result:= 1 + ((dlgpixX * FClientWidth) div BffClientScaleXDiv)
end;

function TFolderDialog.BffScaledY(dlgpixY: integer): integer;
begin
  { compensate for Mapping Mode of dialog's canvas }
  Result:= 1 + ((dlgpixY * FClientHeight) div BffClientScaleYDiv)
end;

(*
procedure TFolderDialog.SetBounds(ALeft, ATop, AWidth, AHeight: Integer);
{ resize common shell dialog and contained controls }
begin
  if FHandle <> 0 then
  begin
      SetWindowPos(Handle, 0, 0, 0, ClientWidth+80, ClientHeight+40,
        SWP_NOACTIVATE or SWP_NOCOPYBITS or SWP_NOMOVE or
        SWP_NOZORDER);
  end;
end;
*)

constructor TFolderDialog.Create(AOwner: TComponent);
begin
  if not ClassInitialized then InitializeClass;
  inherited Create(AOwner);
  // prepare subclassing shell's BrowseForFolder dialog
  FXObjectInstance := Forms.MakeObjectInstance(WndProc);
  // set default prop. values
  FDummyCtl3D:= true; // ignore inherited Ctl3d
  FCaption:= 'Browse for Folder';
  RootFolder:= sfoDesktopExpanded;
  FOptions:= [bfFileSysDirsOnly, bfStatusText, bfSyncCustomButton,
              bfShowPathInStatusArea, bfAlignCustomButton, bfParentCenter];
end;

destructor TFolderDialog.Destroy;
begin
  if FHandle <> 0 then
    Perform(WM_SYSCOMMAND, SC_CLOSE, 0); { just to be sure }
  if FXObjectInstance <> nil then FreeObjectInstance(FXObjectInstance);
  {Free the ID lists with the system task allocator}
  FreeIDList(FSelectionIDList);
  FreeIDList(FDirectoryIDList);
  FreeIDList(FRootIDList);
  inherited Destroy
end;

procedure TFolderDialog.DefaultHandler(var Message);
begin
  if FHandle <> 0 then
    with TMessage(Message) do
      // Pass on to original dialog procedure
      Result := CallWindowProc(FXDefWndProc, FHandle, Msg, WParam, LParam)
  else inherited DefaultHandler(Message);
end;

function TFolderDialog.Perform(Msg: Cardinal; WParam, LParam: Longint): Longint;
var
  Message: TMessage;
begin
  Message.Msg := Msg;  Message.WParam := WParam;
  Message.LParam := LParam;  Message.Result := 0;
  if Self <> nil then WndProc(Message); { does Dispatch(Message) }
  Result := Message.Result;
end;

procedure TFolderDialog.WMShowWindow(var Message: TWMShowWindow);
var TrVwHandle: HWND;
begin
  inherited;
  if not FFirstShowDone then
  begin
    FFirstShowDone:= true;
    TrVwHandle:= GetDlgItem(FHandle, ID_BFF_TREEVIEW);
    if TrVwHandle <> 0 then
      Windows.SetFocus(TrVwHandle);
  end;
end;

procedure TFolderDialog.WMCommand(var Message: TWMCommand);

  procedure UpdateTemplate;
  var
    NE: TNotifyEvent;
  begin
    if FTemplateButton is TCheckBox then with TCheckBox(FTemplateButton) do
    begin
      NE:= OnClick; OnClick:= nil;
      Checked:= TCheckBox(FCustomButton).Checked;
      OnClick:= NE;
    end
    else
    if FTemplateButton is TRadioButton then
      with TRadioButton(FTemplateButton) do
      begin
        NE:= OnClick; OnClick:= nil;
        Checked:= TRadioButton(FCustomButton).Checked;
        OnClick:= NE;
      end;
  end;

begin
  with Message do
  begin
    if Assigned(FCustomButton) then
    begin
      if ItemId = ID_BFF_OK then
      begin
        if Assigned(FTemplateButton)
           {and not (csDesigning in ComponentState)}
        then UpdateTemplate;
        inherited;
      end
      else
      // Intercept the custom button's click
      if Ctl = FCustomButton.Handle then
      begin
        // Show the current path when in design mode
        if csDesigning in ComponentState then
        begin
          Result :=0;
          MessageDlg('Current path is ' + SelectionPath,
                     mtInformation, [mbOK], 0)
        end
        else // Otherwise, execute the user's code
          // looks like RadioButtons do not allow to get Unchecked
          Result := FCustomButton.Perform(CN_COMMAND,
                         TMessage(Message).wParam, Ctl);
      end
      else
        inherited;
    end
    else
      inherited;
  end;
end;

procedure TFolderDialog.WMDestroy(var Message: TWMDestroy);
begin
  inherited; { D3: triggers OnClose }
  if Assigned(FCustomButton) then
  begin
    FCustomButton.Parent:= nil;
    FCustomButton.Free; FCustomButton:= nil;
  end;
end;

procedure TFolderDialog.WMNCDestroy(var Message: TWMNCDestroy);
begin
  inherited;
  { reset dialog window dependent member variables }
  FFirstShowDone:= false;
  FCustomButton:= nil;
  { inherited TCommonDialog's FHandle is not same as ours, so: }
  FHandle:= 0;
end;

function TFolderDialog.CreateCustomControl(
            ATemplateControl: TWinControl): TWinControl;
var
  CLS: TWinControlClass;
  X, Y, CX, CY: integer;
begin
  Result:= nil;
  // Create custom control, then Assign(template)
  CLS:= TWinControlClass(ATemplateControl.ClassType);
  try
    Result:= CLS.CreateParented(FHandle);
    // pity, no chance to set Owner now
    if Assigned(Result) then
    begin
      { make sure we get a notification when the CustomControl is destroyed }
      Result.FreeNotification(Self);
      { clone the control, can't use Assign(), buttons do not support it }
      CopyPropertyValues(ATemplateControl, Result, {Owner}Self, nil);
    end;

    if bfAlignCustomButton in FOptions then
    begin { auto align left on button row }
      X:= BffScaledX(BffCtlStatusAreaRect.Left)+1;
      Y:= BffScaledY(BffCtlCancelBtnRect.Top)-1;
    end
    else with ATemplateControl do
    begin
      X:= Left; Y:= Top
    end;
    if bfResizeCustomButton in FOptions then with BffCtlCancelBtnRect do
    begin
      CX:= BffScaledX(Right-Left); CY:= BffScaledY(Bottom-Top);
    end
    else with ATemplateControl do
    begin
      CX:= Width;
      if ATemplateControl is TButton then
        with BffCtlCancelBtnRect do CY:= BffScaledY(Bottom-Top)
      else CY:= Height
    end;

    with Result do
    begin
      SetBounds(X, Y, CX, CY);
      { FCustomControl.Owner = nil }
      Visible:= false; Visible:= true; { toggling Visible is really needed }
      Enabled:= ATemplateControl.Enabled;
      // If we should, disable/enable the custom control in sync with the OK button
      if (bfSyncCustomButton in FOptions) and (FOkBtnHandle <> 0) then
          Enabled := IsWindowEnabled(FOkBtnHandle);
    end;
  except
    Result.Free; Result:= nil;
    end;
end; { TFolderDialog.CreateCustomControl }

procedure TFolderDialog.SPVStatusText(const Value: string);

  procedure ShowStatusText(const Text: string);
  { fit text in StatusArea on invisible canvas mirrored from dialog client area }
  var
    R: TRect; DC, CDC: HDC; S: string; DTM: integer;
  begin
    S:= Text; UniqueString(S); S:= S + 'W';
    DC:= GetDC(Handle);
    try CDC:= CreateCompatibleDC(DC) finally ReleaseDC(Handle, DC) end;
    if CDC <> 0 then
    try
      R:= BffCtlStatusAreaRect; { unscaled, canvas Mapping Mode is used }
      DTM:= DT_MODIFYSTRING or DT_NOPREFIX or DT_LEFT or DT_EXTERNALLEADING;
      if bfShowPathInStatusArea in FOptions then
        DTM:= DTM or DT_PATH_ELLIPSIS // never truncates filenamepart ?
      else
        DTM:= DTM or DT_END_ELLIPSIS;
      DrawTextEx(CDC, PChar(S), -1, R, DTM, nil);
      Setlength(S, Strlen(PChar(S))-1);
      Perform(BFFM_SETSTATUSTEXT, 0, Longint(PChar(S)));
    finally DeleteDC(CDC) end;
  end;

begin
  FStatusText:= Value;
  if FHandle <> 0 then
    ShowStatusText(FStatusText);
end;

function TFolderDialog.CloneIDListFrom(PIDL: PItemIDList): PItemIDList;
var
  L, N: cardinal;
  P: PItemIDList;
begin
  Result:= nil;
  if Assigned(PIDL) then
  begin
    { calc length of IDList }
    L:= 0; P:= PIDL; N:= P^.mkId.cb;
    while N <> 0 do
    begin
      inc(L, N); P:= PItemIdList(PChar(@P^.mkId.cb) + N);
      N:= P^.mkId.cb;
    end;
    if L <> 0 then
    begin
      Result:= Malloc.Alloc(L+2); { +2 for terminating zero .cb }
      if Assigned(Result) then
        System.Move(PIDL^, Result^, L+2);
    end;
  end;
end;

function TFolderDialog.GPVSelectionPath: string;
begin
  if Assigned(FSelectionIDList) then
    GetPathFromIDList(FSelectionIDList, Result)
  else
    Result:= '';
end;

procedure TFolderDialog.ReplaceSelection(PIDL: PItemIDList);
begin
  FreeIDList(FSelectionIDList);
  if Assigned(PIDL) then
    FSelectionIDList:= CloneIDListFrom(PIDL);
end;

procedure TFolderDialog.BFFMSelChanged(Param: integer);
{ Selection changed: Shell Dlg will free the passed PItemIDList(Param) }
const
  FIGAO_Dim = 1;
var
  ValidPath: Boolean;
  IDLArr: array[0..FIGAO_Dim-1] of PItemIDList;
  AtrArr: array[0..FIGAO_Dim-1] of integer;
  SP: string;
begin
  ReplaceSelection(PItemIDList(Param)); // IDList always is absolute

  // update folderitem attributes

  FSelectionAttributes:= integer({-1;} SFGAO_CAPABILITYMASK or
     SFGAO_DISPLAYATTRMASK or SFGAO_CONTENTSMASK);
  IDLArr[0]:= PItemIDList(Param);
  AtrArr[0]:= FSelectionAttributes;
  if Desktop.GetAttributesOf(FIGAO_Dim, IDLArr[0], UINT(AtrArr[0])) <> NOERROR then
    FSelectionAttributes:= 0
  else
    FSelectionAttributes:= AtrArr[0];

  SP:= SelectionPath;
  ValidPath:= Length(SP) <> 0;
  if bfFileSysDirsOnly in FOptions then
    EnableOK(ValidPath);
  if ValidPath then
  begin
    if bfShowPathInStatusArea in FOptions then
      SPVStatusText(SP);
    // Fire the user event
    DoChange;
  end
  else
    if [bfFileSysDirsOnly, bfShowPathInStatusArea] * FOptions <> [] then
    begin // clear statustext
      Perform(BFFM_SETSTATUSTEXT, 0, Longint(PChar(SP)));
    end
end;

procedure TFolderDialog.BFFMInitialized(Param: integer);
var
  R: TRect; S: string;
begin
  try
    // Get size
    if Windows.GetClientRect(Handle, R) then
    begin
      FClientWidth:= R.Right; FClientHeight:= R.Bottom
    end;

    FOkBtnHandle:= GetDlgItem(Handle, ID_BFF_OK);

    // move the dialog window
    PositionWindow;

    // Set the initial path
    if FDirectory <> '' then
    begin
      if not GetPathFromIDList(FDirectoryIDList, S) then S:= '';
      if FDirectory =  S then
        SPVSelectionPIDL(FDirectoryIDList)
      else
        SelectionPath:= FDirectory;
    end;
    FreeIDList(FDirectoryIDList);

    if Assigned(FTemplateButton) then
      // Show the custom button
      FCustomButton:= CreateCustomControl(FTemplateButton) as TButtonControl;

    Perform(WM_SETTEXT, 0, integer(PChar(FCaption)));

    // Fire the user event (WM_InitDialog is not sent by shell dlgs)

    if Assigned(OnShow) then
      OnShow(Self);
  finally end;
end;

function TFolderDialog.GPVCustomButton: TButtonControl;
begin
  if Handle <> 0 then Result:= FCustomButton
  else Result:= FTemplateButton;
end;

function TFolderDialog.GPVDirectory: string;
begin
  if Handle <> 0 then Result:= SelectionPath
  else Result:= FDirectory;
end;

function TFolderDialog.GPVParent: TWinControl;
begin
  if not Assigned(FParent) then
    if Assigned(Owner) and (Owner is TWinControl) then
      FParent := TWinControl(Owner)
    else
      if Assigned(Application.MainForm) then
        FParent := Application.MainForm;
  Result:= FParent;
end;

function TFolderDialog.GPVParentHandle: HWND;
begin
  if Assigned(Parent) and Parent.HandleAllocated then
    Result:= Parent.Handle
  else
    Result:= 0; { desktop }
end;

procedure TFolderDialog.SPVDirectory(const Value: string);
begin
  FDirectory:= Value;
  SPVSelectionPath(Value);
end;

function TFolderDialog.GPVHandle: HWND;
begin
  Result:= FHandle
end;

procedure TFolderDialog.SPVParent(const Value: TWinControl);
begin
  FParent:= Value; PositionWindow
end;

procedure TFolderDialog.SPVDesignedTop(Value: integer);
var LR: LongRec;
begin
  LR:= LongRec(DesignInfo); LR.Hi:= Value; DesignInfo:= longint(LR);
  PositionWindow;
end;

procedure TFolderDialog.SPVDesignedLeft(Value: integer);
var LR: LongRec;
begin
  LR:= LongRec(DesignInfo); LR.Lo:= Value; DesignInfo:= longint(LR);
  PositionWindow;
end;

function TFolderDialog.GPVDesignedTop: integer;
begin
  Result:= LongRec(DesignInfo).Hi
end;
function TFolderDialog.GPVDesignedLeft: integer;
begin
  Result:= LongRec(DesignInfo).Lo
end;

procedure TFolderDialog.DoChange;
begin
  if Assigned(FOnChange) then FOnChange(Self)
end;

procedure TFolderDialog.SPVOptions(const Value: TFolderDialogOptions);
var
  NV: TFolderDialogOptions;
begin
  { exclude invalid combinations }
  NV:= Value;
  if ([bfParentCenter, bfScreenCenter] * NV) = [bfParentCenter, bfScreenCenter] then
  begin
    if bfScreenCenter in FOptions then
      Exclude(NV, bfScreenCenter)
    else
    if bfParentCenter in FOptions then
      Exclude(NV, bfParentCenter)
  end;
  if (bfBrowseForComputer in NV) and not (bfBrowseForComputer in FOptions) then
  begin
    RootFolder:= sfoNetwork;
    NV:= NV - [bfFileSysDirsOnly, bfFileSysAncestors, bfBrowseForPrinter]
  end
  else
  if (bfBrowseForPrinter in NV) and not (bfBrowseForPrinter in FOptions) then
    NV:= NV - [bfFileSysDirsOnly, bfFileSysAncestors,
               bfBrowseForComputer, bfDontGoBelowDomain];
  if (bfShowPathInStatusArea in NV) and
     (not (bfShowPathInStatusArea in FOptions)) and
     (not (bfStatusText in NV)) then
    Include(NV, bfStatusText);
  { include implicit combinations }
  if (not (bfStatusText in NV)) and
     (bfStatusText in FOptions) and
     (bfShowPathInStatusArea in NV) then
    Exclude(NV, bfShowPathInStatusArea);
  FOptions := NV;
end;

function TFolderDialog.GPVCaption: string;
begin
  if FHandle = 0 then
    Result:= FCaption
  else
  begin
    SetLength(Result, 256);
    Perform(WM_GETTEXT, 256, integer(PChar(Result)));
    SetLength(Result, StrLen(PChar(Result)));
  end
end;

procedure TFolderDialog.SPVCaption(const Value: string);
begin
  FCaption:= Value;
  if FHandle <> 0 then
    Perform(WM_SETTEXT, 0, integer(PChar(FCaption)));
end;

{Center the given window on the Foreground window  - Added by Manuel Duarte}
{Modifed by Todd Fast to place the top of the dialog at visual center of main window}
{Changed CenterWindow to method CenterOnParent: fdj }
procedure TFolderDialog.CenterOnParent;
var
  Rect, FWRect: TRect;
begin
  GetWindowRect(FHandle, Rect);
  GetWindowRect(ParentHandle,FWRect);
  SetWindowPos(FHandle,0,
    (FWRect.Left+(FWRect.Right-FWRect.Left) div 2)-(Rect.Right-Rect.Left) div 2,
    FWRect.Top+((FWRect.Bottom-FWRect.Top) div 4),
    0,0,SWP_NOACTIVATE or SWP_NOSIZE or SWP_NOZORDER);
end;

procedure TFolderDialog.PositionWindow;
var
  P: TPoint;
begin
  if FHandle <> 0 then
  begin
    if bfParentCenter in FOptions then
      CenterOnParent
    else
    begin
      if bfScreenCenter in Options then
      begin
        P.X:= (GetSystemMetrics(SM_CXSCREEN) - FClientWidth) div 2;
        P.Y:= (GetSystemMetrics(SM_CYSCREEN) - FClientHeight) div 3;
      end
      else
      begin { designed position }
        P.X:= Left; P.Y:= Top;
        if Assigned(Parent) and Parent.HandleAllocated then
          P:= Parent.ClientToScreen(P);
      end;
      SetWindowPos(FHandle, 0, P.X, P.Y, 0, 0,
                   SWP_NOACTIVATE or SWP_NOSIZE or SWP_NOZORDER);
    end;
  end;
end;

procedure TFolderDialog.SPVSelectionPIDL(const Value: PItemIDList);
begin
  if Handle = 0 then
  begin
    FreeIDList(FSelectionIDList);
    FSelectionIDList:= CloneIDListFrom(Value)
  end
  else
    Perform(BFFM_SETSELECTION, integer(FALSE), integer(Value))
end;

procedure TFolderDialog.SPVSelectionPath(const Value: String);

  function GetChildIDList(RootPath, AbsChildPath: PItemIDList;
                          var RelChildPath: PItemIDList): boolean;
  { returns right part of AbsChildPath trimmed left with RootPath }
  var
    L, N: cardinal;
    RP, ACP, RCP: PItemIDList;
  begin
    if (Value = FDirectory{FSelectionPath}) or (not Assigned(RootPath)) then
    begin
      RelChildPath:= CloneIDListFrom(AbsChildPath);
      Result:= true;
      exit;
    end;

    Result:= false;
    { start comparing from root }
    RP:= RootPath; ACP:= AbsChildPath; N:= RP^.mkid.cb;
    while (N <> 0) and CompareMem(RP, ACP, N) do
    begin
      inc(PChar(RP), N); inc(PChar(ACP), N); N:= RP^.mkid.cb;
    end;
    if (N = 0){end of RootPath} and (ACP.mkid.cb <> 0) then
    begin { RelChildPath is longer than RootPath }
      RCP:= ACP; L:= 0; N:= ACP^.mkid.cb;
      while N <> 0 do
      begin
        inc(L, N); inc(PChar(ACP), N); N:= ACP^.mkid.cb;
      end;
      RelChildPath:= Malloc.Alloc(L+2);
      System.Move(RCP^, RelChildPath^, L+2);
// DumpIDList(RelChildPath);
      Result:= true;
    end;
  end;

var
  SP: string;
  AbsPIDL, RelPIDL: PItemIDList;
begin
  SP:= SelectionPath;
  if Value = SP then
    Exit
  else
    FreeIDList(FSelectionIDList);
  { prevent shell dlg from choosing the longest path in its namespace }
  AbsPIDL:= nil; RelPIDL:= nil;
  try
    if GetIdListFromPath(Value, AbsPIDL) then
    begin
      if GetChildIDList(RootPIDL, AbsPIDL, RelPidl) then
        FSelectionIDList:= CloneIDListFrom(RelPIDL)
      else
        FSelectionIDList:= CloneIDListFrom(AbsPIDL);
      if Handle <> 0 then
        SPVSelectionPIDL(FSelectionIDList)
    end
  finally
    FreeIDList(AbsPIDL); FreeIDList(RelPIDL)
    end;
end;

//--------------------------------------------------------------------------------------------------------//
{Use this function to enable/disable the OK button of the browse dialog from within one of the TFolderDialog event handlers}
procedure TFolderDialog.EnableOK(const Value: Boolean);
begin
  Perform(BFFM_ENABLEOK, 0, integer(Value));
  // If we should, disable/enable the custom button in sync with the OK button
  if (bfSyncCustomButton in FOptions) and Assigned(FCustomButton) then
    FCustomButton.Enabled := Value;
end;

(*
procedure TFolderDialog.InitImages;
var
  SFI : TSHFileInfo;
  FSysImageListSmall : HImageList;
begin
  FSysImageListSmall:= SHGetFileInfo(PChar(Desktop), 0, SFI, sizeof(SFI),
     SHGFI_PIDL or SHGFI_SYSICONINDEX or SHGFI_SMALLICON);
end;
*)

function TFolderDialog.Execute: Boolean;
const
  BROWSE_FLAG_MAP: array[TFolderDialogOption] of Integer=
    (BIF_RETURNONLYFSDIRS, BIF_DONTGOBELOWDOMAIN, BIF_STATUSTEXT,
     BIF_RETURNFSANCESTORS, BIF_BROWSEFORCOMPUTER, BIF_BROWSEFORPRINTER,
     BIF_BROWSEINCLUDEFILES, // fdj added: 26-10-97
     0, 0, 0, 0, 0, 0);
var
  i: Integer;
  DispName: string;
  DlgPIDL: PItemIDList;
begin
  FillChar(FBrowseInfo, sizeof(FBrowseInfo), 0);
  with FBrowseInfo do
  begin
    {Init the BrowseInfo structure}
    hwndOwner:= ParentHandle;

    FSelectionAttributes:= 0;
    DispName:= '';
    SetLength(DispName, MAX_PATH); pszDisplayName := PChar(DispName);
    if length(FTitleText) <> 0 then
      lpszTitle := PChar(FTitleText);

    {OR all the flags together}
    for i:= 0 to ord(bfBrowseIncludeFiles) do
      if TFolderDialogOption(i) in FOptions then
        ulFlags := ulFlags or cardinal(BROWSE_FLAG_MAP[TFolderDialogOption(i)]);

    lpfn := @CBBrowseForFolder; lParam := Longint(Self);
    pidlRoot:= FRootIDList;

    { start modal Browse dialog }
    DlgPIDL:= SHBrowseForFolder(FBrowseInfo);
    { dlg. returns always absolute IDList (from root of
        shell's namespace), not relative from FRootIDList }
    Result:= DlgPIDL <> nil;
    FreeIDList(FSelectionIDList);
    if Assigned(Parent) and Parent.HandleAllocated then
      Parent.SetFocus; // Win95 /w D2.01

    if Result then
    begin
      FDirectoryIDList:= CloneIDListFrom(DlgPIDL);
      FreeIDList(DlgPIDL);
      //  DumpIDList(FDirectoryIDList);
      FImageIndex := iImage;
(*
    var
      SFI: TSHFileInfo;
    SHGetFileInfo(PChar(SelectionPIDL), 0, SFI, sizeof(SFI),
                  SHGFI_PIDL or SHGFI_SYSICONINDEX {or SHGFI_LINKOVERLAY});
    ImageIndex:= SFI.iIcon;
    {IconHandle:= SFI.hIcon;}
    SHGetFileInfo(PChar(SelectionPIDL), 0, SFI, sizeof(SFI),
                  SHGFI_PIDL or SHGFI_SYSICONINDEX or SHGFI_OPENICON);
    SelectedIndex:= SFI.iIcon;
*)
      // FSelectionAttributes:= FSelectionAttributes;
      SetLength(DispName, StrLen(PChar(DispName)));
      FDisplayName := DispName;
      if not GetPathFromIDList(FDirectoryIDList, FDirectory) then
        FDirectory:= '';
    end
    else
    begin
      FDirectory:= '';
      FSelectionAttributes:= 0;
    end;
  end; // with BrowseInfo
end;

//--------------------------------------------------------------------------------------------------------//

procedure Register;
begin
  RegisterComponents('CDC', [TFolderDialog]);
end;

INITIALIZATION

FINALIZATION
  ClassFDIMalloc:= nil;
  ClassFDIDesktop:= nil;

END.
