{
 ***************************************************************************
                              editbtn.pas
                              -----------
               Component Library Extended dialogs Controls


 ***************************************************************************

 *****************************************************************************
 *                                                                           *
 *  This file is part of the Lazarus Component Library (LCL)                 *
 *  See the file COPYING.modifiedLGPL.txt, included in this distribution,    *
 *  for details about the copyright.                                         *
 *                                                                           *
 *  This program is distributed in the hope that it will be useful,          *
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of           *
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.                     *
 *                                                                           *
 *****************************************************************************


}
unit CdC_EditBtn;

{$mode objfpc}{$H+}

//{$I lcl_defines.inc}

interface

uses
  Classes, SysUtils, LCLProc, LResources, LCLStrConsts, Types, LCLType, LMessages,
  Graphics, Controls, Forms, LazFileUtils, Dialogs, StdCtrls, Buttons, Calendar,
  ExtDlgs, CalendarPopup, MaskEdit, Menus, StrUtils, DateUtils, TimePopup, CalcForm;

const
  NullDate: TDateTime = 0;

type

  { TEbEdit }

  TEbEdit = class(TCustomMaskedit)
  protected
    procedure DoEnter; override;
    procedure DoExit; override;
    function PerformTab(ForwardTab: boolean): boolean; override;
  end;

  { TCustomEditButton }

  TCustomEditButton = class(TCustomControl)
  private
    FButton: TSpeedButton;
    FButtonOnlyWhenFocused: Boolean;
    FDirectInput: Boolean;
    FEdit: TEbEdit;
    FInitialColor: TColor;
    FIsReadOnly: Boolean;
    FFlat: Boolean;
    FFocusOnButtonClick: Boolean;
    FLayout: TLeftRight;
    //Forwarded events from FButton
    FOnButtonClick: TNotifyEvent;
    //Forwarded events from FEdit
    FOnEditClick: TNotifyEvent;
    FOnEditChange: TNotifyEvent;
    FOnEditDblClick: TNotifyEvent;
    FOnEditDragDrop: TDragDropEvent;
    FOnEditDragOver: TDragOverEvent;
    FOnEditEditingDone: TNotifyEvent;
    FOnEditEndDrag: TEndDragEvent;
    FOnEditExit: TNotifyEvent;
    FOnEditKeyDown: TKeyEvent;
    FOnEditKeyPress: TKeyPressEvent;
    FOnEditEnter: TNotifyEvent;
    FOnEditKeyUp: TKeyEvent;
    FOnEditMouseDown: TMouseEvent;
    FOnEditMouseUp: TMouseEvent;
    FOnEditMouseEnter: TNotifyEvent;
    FOnEditMouseLeave: TNotifyEvent;
    FOnEditMouseMove: TMouseMoveEvent;
    FOnEditMouseWheel: TMouseWheelEvent;
    FOnEditMouseWheelUp: TMouseWheelUpDownEvent;
    FOnEditMouseWheelDown: TMouseWheelUpDownEvent;
    FOnEditStartDrag: TStartDragEvent;
    FOnEditUtf8KeyPress: TUtf8KeyPressEvent;

    function GetAlignment: TAlignment;
    function GetAutoSelect: Boolean;
    function GetAutoSelected: Boolean;
    function GetBtnCaption: TCaption;
    function GetButtonCursor: TCursor;
    function GetButtonHint: TTranslateString;
    function GetButtonWidth: Integer;
    function GetCanUndo: Boolean;
    function GetCaretPos: TPoint;
    function GetCharCase: TEditCharCase;
    function GetColor: TColor;
    function GetDirectInput: Boolean;
    function GetEchoMode: TEchoMode;
    function GetEditMask: String;
    function GetEditText: string;
    function GetGlyph: TBitmap;
    function GetHideSelection: Boolean;
    function GetIsMasked: Boolean;
    function GetMaxLength: Integer;
    function GetModified: Boolean;
    function GetNumbersOnly: Boolean;
    function GetNumGlyps: Integer;
    function GetParentColor: Boolean;
    function GetPasswordChar: char;
    function GetReadOnly: Boolean;
    function GetSelLength: Integer;
    function GetSelStart: Integer;
    function GetSelText: String;
    function GetSpacing: Integer;
    function GetTabStop: Boolean;
    function GetText: TCaption;
    function GetTextHint: TTranslateString;
    function GetTextHintFontColor: TColor;
    function GetTextHintFontStyle: TFontStyles;
    function IsCustomGlyph : Boolean;

    procedure FocusAndMaybeSelectAll;
    procedure InternalOnButtonClick(Sender: TObject);
    procedure InternalOnEditClick(Sender: TObject);
    procedure InternalOnEditDblClick(Sender: TObject);
    procedure InternalOnEditChange(Sender: TObject);
    procedure InternalOnEditDragDrop(Sender, Source: TObject; X,Y: Integer);
    procedure InternalOnEditDragOver(Sender, Source: TObject; X,Y: Integer; State: TDragState; var Accept: Boolean);
    procedure InternalOnEditEditingDone(Sender: TObject);
    procedure InternalOnEditEnter(Sender: TObject);
    procedure InternalOnEditExit(Sender: TObject);
    procedure InternalOnEditEndDrag(Sender, Target: TObject; X,Y: Integer);
    procedure InternalOnEditKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
    procedure InternalOnEditKeyPress(Sender: TObject; var Key: char);
    procedure InternalOnEditKeyUp(Sender: TObject; var Key: word; Shift: TShiftState);
    procedure InternalOnEditMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure InternalOnEditMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure InternalOnEditMouseEnter(Sender: TObject);
    procedure InternalOnEditMouseLeave(Sender: TObject);
    procedure InternalOnEditMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure InternalOnEditMouseWheel(Sender: TObject; Shift: TShiftState;
         WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
    procedure InternalOnEditMouseWheelUp(Sender: TObject;
          Shift: TShiftState; MousePos: TPoint; var Handled: Boolean);
    procedure InternalOnEditMouseWheelDown(Sender: TObject;
          Shift: TShiftState; MousePos: TPoint; var Handled: Boolean);
    procedure InternalOnEditUtf8KeyPress(Sender: TObject; var UTF8Key: TUTF8Char);
    procedure InternalOnEditStartDrag(Sender: TObject; var DragObject: TDragObject);

    procedure SetAlignment(AValue: TAlignment);
    procedure SetAutoSelect(AValue: Boolean);
    procedure SetAutoSelected(AValue: Boolean);
    procedure SetBtnCaption(AValue: TCaption);
    procedure SetButtonCursor(AValue: TCursor);
    procedure SetButtonHint(AValue: TTranslateString);
    procedure SetButtonOnlyWhenFocused(AValue: Boolean);
    procedure SetButtonWidth(AValue: Integer);
    procedure SetCaretPos(AValue: TPoint);
    procedure SetCharCase(AValue: TEditCharCase);
    procedure SetEchoMode(AValue: TEchoMode);
    procedure SetEditMask(AValue: String);
    procedure SetEditText(AValue: string);
    procedure SetFlat(AValue: Boolean);
    procedure SetGlyph(AValue: TBitmap);
    procedure SetHideSelection(AValue: Boolean);
    procedure SetLayout(AValue: TLeftRight);
    procedure SetMaxLength(AValue: Integer);
    procedure SetModified(AValue: Boolean);
    procedure SetNumbersOnly(AValue: Boolean);
    procedure SetNumGlyphs(AValue: Integer);
    procedure SetParentColor(AValue: Boolean);
    procedure SetPasswordChar(AValue: char);
    procedure SetPopupMenu(AValue: TPopupMenu);
    procedure SetReadOnly(AValue: Boolean);
    procedure SetSelLength(AValue: Integer);
    procedure SetSelStart(AValue: Integer);
    procedure SetSelText(AValue: String);
    procedure SetSpacing(const Value: integer);
    procedure SetTabStop(AValue: Boolean);
    procedure SetTextHint(AValue: TTranslateString);
    procedure SetTextHintFontColor(AValue: TColor);
    procedure SetTextHintFontStyle(AValue: TFontStyles);
  protected
    class function GetControlClassDefaultSize: TSize; override;
    function CalcButtonVisible: Boolean; virtual;
    function GetDefaultGlyph: TBitmap; virtual;
    function GetDefaultGlyphName: String; virtual;
    procedure SetDirectInput(AValue: Boolean); virtual;
    procedure SetText(AValue: TCaption); virtual;

    function GetEditPopupMenu: TPopupMenu;

    procedure CalculatePreferredSize(var PreferredWidth,
                                     PreferredHeight: integer;
                                     WithThemeSpace: Boolean); override;
    procedure CheckButtonVisible;
    procedure ButtonClick; virtual;

    procedure DoEnter; override;

    procedure EditChange; virtual;
    procedure EditClick; virtual;
    procedure EditDblClick; virtual;
    procedure EditDragDrop(Source: TObject; X,Y: Integer);  virtual;
    procedure EditDragOver(Source: TObject; X,Y: Integer; State: TDragState; var Accept: Boolean); virtual;
    procedure EditEditingDone; virtual;
    procedure EditEndDrag(Target: TObject; X,Y: Integer); virtual;
    procedure EditEnter; virtual;
    procedure EditExit; virtual;
    procedure EditKeyDown(var Key: word; Shift: TShiftState); virtual;
    procedure EditKeyPress( var Key: char); virtual;
    procedure EditKeyUp(var Key: word; Shift: TShiftState); virtual;
    procedure EditMouseDown(Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer); virtual;
    procedure EditMouseUp(Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer); virtual;
    procedure EditMouseEnter; virtual;
    procedure EditMouseLeave; virtual;
    procedure EditMouseMove(Shift: TShiftState; X, Y: Integer); virtual;
    procedure EditMouseWheel(Shift: TShiftState;
         WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
    procedure EditMouseWheelUp(Shift: TShiftState; MousePos: TPoint; var Handled: Boolean);
    procedure EditMouseWheelDown(Shift: TShiftState; MousePos: TPoint; var Handled: Boolean);
    procedure EditUtf8KeyPress(var UTF8Key: TUTF8Char); virtual;
    procedure EditStartDrag(var DragObject: TDragObject); virtual;


    procedure CheckCursor;
    procedure CMParentColorChanged(var Message: TLMessage); message CM_PARENTCOLORCHANGED;
    function  EditCanModify: Boolean; virtual;
    procedure GetSel(out _SelStart: Integer; out _SelStop: Integer);
    procedure SetSel(const _SelStart: Integer; _SelStop: Integer);
    procedure Loaded; override;
    procedure Reset; virtual;
    procedure SetAutoSize(AValue: Boolean); override;
    procedure SetColor(AValue: TColor); override;
    procedure SetCursor(AValue: TCursor); override;

    property AutoSelect: Boolean read GetAutoSelect write SetAutoSelect default True;
    property AutoSelected: Boolean read GetAutoSelected write SetAutoSelected;
    property Button: TSpeedButton read FButton;
    property ButtonCaption: TCaption read GetBtnCaption write SetBtnCaption;
    property ButtonCursor: TCursor read GetButtonCursor write SetButtonCursor default crDefault;
    property ButtonHint: TTranslateString read GetButtonHint write SetButtonHint;
    property ButtonOnlyWhenFocused: Boolean read FButtonOnlyWhenFocused write SetButtonOnlyWhenFocused default False;
    property ButtonWidth: Integer read GetButtonWidth write SetButtonWidth;
    property Color: TColor read GetColor write SetColor stored True default {$ifdef UseCLDefault}clDefault{$else}clWindow{$endif};
    property DirectInput : Boolean read GetDirectInput write SetDirectInput default True;
    property Edit: TEbEdit read FEdit;
    property EditMask: String read GetEditMask write SetEditMask;
    property EditText: string read GetEditText write SetEditText;
    property Flat: Boolean read FFlat write SetFlat default False;
    property FocusOnButtonClick: Boolean read FFocusOnButtonClick write FFocusOnButtonClick default False;
    property Glyph: TBitmap read GetGlyph write SetGlyph stored IsCustomGlyph;
    property IsMasked: Boolean read GetIsMasked;
    property Layout: TLeftRight read FLayout write SetLayout default taLeftJustify;
    property NumGlyphs: Integer read GetNumGlyps write SetNumGlyphs;
    property Spacing: Integer read GetSpacing write SetSpacing default 4;

    property OnButtonClick: TNotifyEvent read FOnButtonClick write FOnButtonClick;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure SetFocus; override;
    function Focused: Boolean; override;
    procedure Clear;
    procedure ClearSelection; virtual;
    procedure CopyToClipboard; virtual;
    procedure CutToClipboard; virtual;
    procedure PasteFromClipboard; virtual;
    procedure SelectAll;
    procedure Undo; virtual;
    procedure ValidateEdit; virtual;

    property Autosize default True;
    property Alignment: TAlignment read GetAlignment write SetAlignment default taLeftJustify;
    property CanUndo: Boolean read GetCanUndo;
    property CaretPos: TPoint read GetCaretPos write SetCaretPos;
    property CharCase: TEditCharCase read GetCharCase write SetCharCase default ecNormal;
    property ParentColor: Boolean read GetParentColor write SetParentColor default False;
    property EchoMode: TEchoMode read GetEchoMode write SetEchoMode default emNormal;
    property HideSelection: Boolean read GetHideSelection write SetHideSelection default False;
    property MaxLength: Integer read GetMaxLength write SetMaxLength;
    property Modified: Boolean read GetModified write SetModified;
    property NumbersOnly: Boolean read GetNumbersOnly write SetNumbersOnly default False;
    property PasswordChar: char read GetPasswordChar write SetPasswordChar;
    property PopupMenu: TPopupMenu read GetEditPopupMenu write SetPopupMenu;
    property ReadOnly: Boolean read GetReadOnly write SetReadOnly default False;
    property SelLength: Integer read GetSelLength write SetSelLength;
    property SelStart: Integer read GetSelStart write SetSelStart;
    property SelText: String read GetSelText write SetSelText;
    property TabStop: Boolean read GetTabStop write SetTabStop default True;
    property Text: TCaption read GetText write SetText;
    property TextHint: TTranslateString read GetTextHint write SetTextHint;
    property TextHintFontColor: TColor read GetTextHintFontColor write SetTextHintFontColor default clGrayText;
    property TextHintFontStyle: TFontStyles read GetTextHintFontStyle write SetTextHintFontStyle default [fsItalic];

    property OnChange: TNotifyEvent read FOnEditChange write FOnEditChange;
    property OnClick: TNotifyEvent read FOnEditClick write FOnEditClick;
    property OnDblClick: TNotifyEvent read FOnEditDblClick write FOnEditDblClick;
    property OnDragDrop: TDragDropEvent read FOnEditDragDrop write FOnEditDragDrop;
    property OnDragOver: TDragOverEvent read FOnEditDragOver write FOnEditDragOver;
    property OnEditingDone: TNotifyEvent read FOnEditEditingDone write FOnEditEditingDone;
    property OnEndDrag: TEndDragEvent read FOnEditEndDrag write FOnEditEndDrag;
    property OnEnter: TNotifyEvent read FOnEditEnter write FOnEditEnter;
    property OnExit: TNotifyEvent read FOnEditExit write FOnEditExit;
    property OnMouseDown: TMouseEvent read FOnEditMouseDown write FOnEditMouseDown;
    property OnKeyPress: TKeyPressEvent read FOnEditKeyPress write FOnEditKeyPress;
    property OnKeyDown: TKeyEvent read FOnEditKeyDown write FOnEditKeyDown;
    property OnKeyUp: TKeyEvent read FOnEditKeyUp write FOnEditKeyUp;
    property OnMouseEnter: TNotifyEvent read FOnEditMouseEnter write FOnEditMouseEnter;
    property OnMouseLeave: TNotifyEvent read FOnEditMouseLeave write FOnEditMouseLeave;
    property OnMouseMove: TMouseMoveEvent read FOnEditMouseMove write FOnEditMouseMove;
    property OnMouseWheel: TMouseWheelEvent read FOnEditMouseWheel write FOnEditMouseWheel;
    property OnMouseWheelUp: TMouseWheelUpDownEvent read FOnEditMouseWheelUp write FOnEditMouseWheelUp;
    property OnMouseWheelDown: TMouseWheelUpDownEvent read FOnEditMouseWheelDown write FOnEditMouseWheelDown;
    property OnMouseUp: TMouseEvent read FOnEditMouseUp write FOnEditMouseUp;
    property OnStartDrag: TStartDragEvent read FOnEditStartDrag write FOnEditStartDrag;
    property OnUtf8KeyPress: TUtf8KeyPressEvent read FOnEditUtf8KeyPress write FOnEditUtf8KeyPress;

  end;

 { TEditButton }

  TEditButton = class(TCustomEditButton)
  public
    property AutoSelected;
    property Button;
  published
    property NumbersOnly;
    property Action;
    property AutoSelect;
    property AutoSize default True;
    property Align;
    property Alignment;
    property Anchors;
    property BiDiMode;
    property BorderSpacing;
    property BorderStyle default bsNone;
    property ButtonCaption;
    property ButtonCursor;
    property ButtonHint;
    property ButtonOnlyWhenFocused;
    property ButtonWidth;
    property CharCase;
    property Color;
    property Constraints;
    property Cursor;
    property DirectInput;
    property EchoMode;
    property Enabled;
    property Flat;
    property FocusOnButtonClick;
    property Font;
    property Glyph;
//    property HideSelection;
    property Hint;
    property Layout;
    property MaxLength;
    property NumGlyphs;
    property OnButtonClick;
    property OnChange;
    property OnClick;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnContextPopup;
    property OnEditingDone;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMouseDown;
    property OnMouseEnter;
    property OnMouseLeave;
    property OnMouseMove;
    property OnMouseUp;
    property OnMouseWheel;
    property OnMouseWheelDown;
    property OnMouseWheelUp;
    property OnStartDrag;
    property OnUTF8KeyPress;
    property ParentBiDiMode;
    property ParentColor;
    property ParentFont;
    property ParentShowHint;
    property PasswordChar;
    property PopupMenu;
    property ReadOnly;
    property ShowHint;
    property Spacing;
    property TabOrder;
    property TabStop;
    property Text;
    property TextHint;
    property TextHintFontColor;
    property TextHintFontStyle;
    property Visible;
  end;

  // Called when an item is filtered. Returns true if the item passes the filter.
  // Done=False means the data should also be filtered by its title string.
  // Done=True means no other filtering is needed.
  TFilterItemEvent = function (Item: TObject; out Done: Boolean): Boolean of object;

  // Can be used only for items that have a checkbox. Returns true if checked.
  TCheckItemEvent = function (Item: TObject): Boolean of object;

  { TCustomControlFilterEdit }

  // An abstract base class for edit controls which filter data in
  // visual controls like TListView and TTreeView.
  TCustomControlFilterEdit = class(TCustomEditButton)
  private
    fFilter: string;
    fIdleConnected: Boolean;
    fSortData: Boolean;             // Data needs to be sorted.
    fUseFormActivate: Boolean;
    fIsFirstSetFormActivate: Boolean;
    fJustActivated: Boolean;
    fParentForm: TForm;
    fOnAfterFilter: TNotifyEvent;
    procedure SetFilter(const AValue: string);
    procedure SetIdleConnected(const AValue: Boolean);
    procedure OnIdle(Sender: TObject; var Done: Boolean);
    procedure SetUseFormActivate(AValue: Boolean);
    procedure FormActivate(Sender: TObject); // Connects to owning form.
    procedure FormDeactivate(Sender: TObject);
    function IsTextHintStored: Boolean;
  protected
    fNeedUpdate: Boolean;
    fIsFirstUpdate: Boolean;
    fSelectedPart: TObject;         // Select this node on next update
    fOnFilterItem: TFilterItemEvent;
    fOnCheckItem: TCheckItemEvent;
    procedure EditKeyDown(var Key: Word; Shift: TShiftState); override;
    procedure EditChange; override;
    procedure EditEnter; override;
    procedure EditExit; override;
    procedure ButtonClick; override;
    procedure SortAndFilter; virtual; abstract;
    procedure ApplyFilter(Immediately: Boolean = False);
    procedure ApplyFilterCore; virtual; abstract;
    procedure MoveNext(ASelect: Boolean = False); virtual; abstract;
    procedure MovePrev(ASelect: Boolean = False); virtual; abstract;
    procedure MovePageUp(ASelect: Boolean = False); virtual; abstract;
    procedure MovePageDown(ASelect: Boolean = False); virtual; abstract;
    procedure MoveHome(ASelect: Boolean = False); virtual; abstract;
    procedure MoveEnd(ASelect: Boolean = False); virtual; abstract;
    function ReturnKeyHandled: Boolean; virtual; abstract;
    function GetDefaultGlyphName: String; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure InvalidateFilter;
    procedure ResetFilter;
    function ForceFilter(AFilter: String) : String;
    procedure StoreSelection; virtual; abstract;
    procedure RestoreSelection; virtual; abstract;
  public
    property Filter: string read fFilter write SetFilter;
    property IdleConnected: Boolean read fIdleConnected write SetIdleConnected;
    property SortData: Boolean read fSortData write fSortData;
    property SelectedPart: TObject read fSelectedPart write fSelectedPart;
  published
    property OnAfterFilter: TNotifyEvent read fOnAfterFilter write fOnAfterFilter;
    property OnFilterItem: TFilterItemEvent read fOnFilterItem write fOnFilterItem;
    property OnCheckItem: TCheckItemEvent read fOnCheckItem write fOnCheckItem;
    property UseFormActivate: Boolean read fUseFormActivate write SetUseFormActivate default False;
    // TEditButton properties.
    property ButtonCaption;
    property ButtonCursor;
    property ButtonHint;
    property ButtonOnlyWhenFocused;
    property ButtonWidth;
    property DirectInput;
    property NumGlyphs;
    property Flat;
    property FocusOnButtonClick;
    // Other properties
    property Align;
    property Anchors;
    property BidiMode;
    property BorderSpacing;
    property BorderStyle;
    property AutoSize;
    property AutoSelect;
    property Color;
    property DragCursor;
    property DragMode;
    property Enabled;
    property Font;
    property Layout;
    property MaxLength;
    property ParentBidiMode;
    property ParentColor;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ReadOnly;
    property ShowHint;
    property Spacing;
    property TabOrder;
    property TabStop;
    property Visible;
    property OnButtonClick;
    property OnChange;
    property OnClick;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEditingDone;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMouseDown;
    property OnMouseEnter;
    property OnMouseLeave;
    property OnMouseMove;
    property OnMouseUp;
    property OnMouseWheel;
    property OnMouseWheelDown;
    property OnMouseWheelUp;
    property OnStartDrag;
    property OnUTF8KeyPress;
    property Text;
    property TextHint stored IsTextHintStored;
    property TextHintFontColor;
    property TextHintFontStyle;
  end;

  { TFileNameEdit }

  TAcceptFileNameEvent = procedure (Sender : TObject; Var Value : String) of Object;
  TDialogKind = (dkOpen,dkSave,dkPictureOpen,dkPictureSave);

  TFileNameEdit = class(TCustomEditButton)
  private
    FDialogOptions: TOpenOptions;
    FFileName : String;
    FDialogFiles : TStrings;
    FDialogKind: TDialogKind;
    FDialogTitle: String;
    FFilter: String;
    FFilterIndex: Integer;
    FDefaultExt: String;
    FHideDirectories: Boolean;
    FInitialDir: String;
    FOnAcceptFileName: TAcceptFileNameEvent;
    FOnFolderChange: TNotifyEvent;
    FFileNameChangeLock: Integer;
    procedure SetFileName(const AValue: String);
  protected
    function GetDefaultGlyph: TBitmap; override;
    function GetDefaultGlyphName: String; override;
    function CreateDialog(AKind: TDialogKind): TCommonDialog; virtual;
    procedure SaveDialogResult(AKind: TDialogKind; D: TCommonDialog); virtual;
    procedure ButtonClick; override;
    procedure RunDialog; virtual;
    procedure EditChange; override;
    procedure DoFolderChange(Sender:TObject); virtual;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property AutoSelected;
    property DialogFiles: TStrings read FDialogFiles;
  published
    // TFileName properties.
    property FileName: String read FFileName write SetFileName;
    property InitialDir: String read FInitialDir write FInitialDir;
    property OnAcceptFileName: TAcceptFileNameEvent read FOnAcceptFileName write FOnAcceptFileName;
    property OnFolderChange: TNotifyEvent read FOnFolderChange write FOnFolderChange;
    property DialogKind: TDialogKind read FDialogKind write FDialogKind default dkOpen;
    property DialogTitle: String read FDialogTitle write FDialogTitle;
    property DialogOptions: TOpenOptions read FDialogOptions write FDialogOptions default DefaultOpenDialogOptions;
    property Filter: String read FFilter write FFilter;
    property FilterIndex: Integer read FFilterIndex write FFIlterIndex;
    property DefaultExt: String read FDefaultExt write FDefaultExt;
    property HideDirectories: Boolean read FHideDirectories write FHideDirectories;
    // TEditButton properties.
    property ButtonCaption;
    property ButtonCursor;
    property ButtonHint;
    property ButtonOnlyWhenFocused;
    property ButtonWidth;
    property DirectInput;
    // property Glyph;
    property NumGlyphs;
    property Flat;
    property FocusOnButtonClick;
    // Other properties
    property Align;
    property Alignment;
    property Anchors;
    property AutoSelect;
    property BidiMode;
    property BorderSpacing;
    property BorderStyle;
    property AutoSize;
    property Color;
    property DragCursor;
    property DragMode;
    property Enabled;
    property Font;
    property Layout;
    property MaxLength;
    property ParentBidiMode;
    property ParentColor;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ReadOnly;
    property ShowHint;
    property Spacing;
    property TabOrder;
    property TabStop;
    property Visible;
    property OnButtonClick;
    property OnChange;
    property OnClick;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEditingDone;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMouseDown;
    property OnMouseEnter;
    property OnMouseLeave;
    property OnMouseMove;
    property OnMouseUp;
    property OnMouseWheel;
    property OnMouseWheelDown;
    property OnMouseWheelUp;
    property OnStartDrag;
    property OnUTF8KeyPress;
    property Text;
    property TextHint;
    property TextHintFontColor;
    property TextHintFontStyle;
  end;


  { TDirectoryEdit }

  TDirectoryEdit = class(TCustomEditButton)
  private
    FDialogTitle: String;
    FRootDir: String;
    FOnAcceptDir: TAcceptFileNameEvent;
    FShowHidden: Boolean;
    function GetDirectory: String;
    procedure SetDirectory(const AValue: String);
  protected
    function GetDefaultGlyph: TBitmap; override;
    function GetDefaultGlyphName: String; override;
    function CreateDialog: TCommonDialog; virtual;
    function GetDialogResult(D : TCommonDialog) : String; virtual;
    procedure ButtonClick; override;
    procedure RunDialog; virtual;
  public
    property AutoSelected;
  published
    // TDirectory properties.
    property Directory: String read GetDirectory write SetDirectory;
    property RootDir: String read FRootDir write FRootDir;
    property OnAcceptDirectory: TAcceptFileNameEvent read FOnAcceptDir write FonAcceptDir;
    property DialogTitle: String read FDialogTitle write FDialogTitle;
    property ShowHidden: Boolean read FShowHidden write FShowHidden;
    // TEditButton properties.
    property ButtonCaption;
    property ButtonCursor;
    property ButtonHint;
    property ButtonOnlyWhenFocused;
    property ButtonWidth;
    property DirectInput;
    // property Glyph;
    property NumGlyphs;
    property Flat;
    property FocusOnButtonClick;
    // Other properties
    property Align;
    property Anchors;
    property AutoSize;
    property AutoSelect;
    property BidiMode;
    property BorderSpacing;
    property BorderStyle;
    property Color;
    property DragCursor;
    property DragMode;
    property Enabled;
    property Font;
    property Layout;
    property MaxLength;
    property ParentBidiMode;
    property ParentColor;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ReadOnly;
    property ShowHint;
    property TabOrder;
    property Spacing;
    property TabStop;
    property Visible;
    property OnButtonClick;
    property OnChange;
    property OnClick;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEditingDone;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMouseDown;
    property OnMouseEnter;
    property OnMouseLeave;
    property OnMouseMove;
    property OnMouseUp;
    property OnMouseWheel;
    property OnMouseWheelDown;
    property OnMouseWheelUp;
    property OnStartDrag;
    property OnUTF8KeyPress;
    property Text;
    property TextHint;
    property TextHintFontColor;
    property TextHintFontStyle;
  end;


  { TDateEdit }

  TAcceptDateEvent = procedure (Sender : TObject; var ADate : TDateTime;
    var AcceptDate: Boolean) of object;
  TCustomDateEvent = procedure (Sender : TObject; var ADate : string) of object;
  TDateOrder = (doNone,doMDY,doDMY,doYMd);

  TDateEdit = class(TCustomEditButton)
  private
    FDateOrder: TDateOrder;
    FDefaultToday: Boolean;
    FDisplaySettings: TDisplaySettings;
    FDroppedDown: Boolean;
    FOnAcceptDate: TAcceptDateEvent;
    FOnCustomDate: TCustomDateEvent;
    FOKCaption: TCaption;
    FCancelCaption: TCaption;
    FFixedDateFormat: string; //used when DateOrder <> doNone
    FFreeDateFormat: String;  //used when DateOrder = doNone
    FDate: TDateTime;
    FUpdatingDate: Boolean;
    procedure SetFreeDateFormat(AValue: String);
    function TextToDate(AText: String; ADefault: TDateTime): TDateTime;
    function GetDate: TDateTime;
    procedure SetDate(Value: TDateTime);
    procedure CalendarPopupReturnDate(Sender: TObject; const ADate: TDateTime);
    procedure CalendarPopupShowHide(Sender: TObject);
    procedure SetDateOrder(const AValue: TDateOrder);
    function DateToText(Value: TDateTime): String;
  protected
    function GetDefaultGlyph: TBitmap; override;
    function GetDefaultGlyphName: String; override;
    procedure ButtonClick; override;
    procedure EditDblClick; override;
    procedure SetDirectInput(AValue: Boolean); override;
    procedure SetText(AValue: TCaption); override;
    procedure SetDateMask; virtual;
  public
    constructor Create(AOwner: TComponent); override;
    function GetDateFormat: string;
    property AutoSelected;
    property Date: TDateTime read GetDate write SetDate;
    property Button;
    property DroppedDown: Boolean read FDroppedDown;
  published
    property CalendarDisplaySettings: TDisplaySettings read FDisplaySettings write FDisplaySettings;
    property OnAcceptDate: TAcceptDateEvent read FOnAcceptDAte write FOnAcceptDate;
    property OnCustomDate: TCustomDateEvent read FOnCustomDate write FOnCustomDate;
    property OKCaption: TCaption read FOKCaption write FOKCaption;
    property CancelCaption: TCaption read FCancelCaption write FCancelCaption;
    property ReadOnly;
    property DefaultToday: Boolean read FDefaultToday write FDefaultToday default False;
    Property DateOrder : TDateOrder Read FDateOrder Write SetDateOrder;
    property DateFormat: String read FFreeDateFormat write SetFreeDateFormat;
    property ButtonOnlyWhenFocused;
    property ButtonCaption;
    property ButtonCursor;
    property ButtonHint;
    property ButtonWidth;
    property Action;
    property Align;
    property Anchors;
    property AutoSize;
    property AutoSelect;
    property BidiMode;
    property BorderSpacing;
    property BorderStyle;
    property CharCase;
    property Color;
    property Constraints;
    property DirectInput;
    property Glyph;
    property NumGlyphs;
    property DragMode;
    property EchoMode;
    property Enabled;
    property Flat;
    property FocusOnButtonClick;
    property Font;
    property Layout;
    property MaxLength;
    property OnButtonClick;
    property OnChange;
    property OnChangeBounds;
    property OnClick;
    property OnDblClick;
    property OnEditingDone;
    property OnEnter;
    property OnExit;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMouseDown;
    property OnMouseEnter;
    property OnMouseLeave;
    property OnMouseMove;
    property OnMouseUp;
    property OnMouseWheel;
    property OnMouseWheelDown;
    property OnMouseWheelUp;
    property OnResize;
    property OnUTF8KeyPress;
    property ParentBidiMode;
    property ParentColor;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property TabStop;
    property TabOrder;
    property Spacing;
    property Visible;
    property Text;
    property TextHint;
    property TextHintFontColor;
    property TextHintFontStyle;
  end;
  
  { TTimeEdit }

  TAcceptTimeEvent = procedure (Sender : TObject; var ATime : TDateTime; var AcceptTime: Boolean) of object;
  TCustomTimeEvent = procedure (Sender : TObject; var ATime : TDateTime) of object;

  TTimeEdit = class(TCustomEditButton)
    private
      FTime: TTime;
      IsEmptyTime: Boolean;
      FDefaultNow: Boolean;
      FDroppedDown: Boolean;
      FSimpleLayout: Boolean;
      FOnAcceptTime: TAcceptTimeEvent;
      FOnCustomTime: TCustomTimeEvent;
      function GetTime: TDateTime;
      procedure SetTime(AValue: TDateTime);
      procedure SetEmptyTime;
      function GetLayout: Boolean;
      procedure SetLayout(AValue: Boolean);
      procedure TimePopupReturnTime(Sender: TObject; const ATime: TDateTime);
      procedure TimePopupShowHide(Sender: TObject);
      procedure OpenTimePopup;
      procedure ParseInput;
      function TryParseInput(AInput: String; out ParseResult: TDateTime): Boolean;
    protected
      function GetDefaultGlyph: TBitmap; override;
      function GetDefaultGlyphName: String; override;
      procedure ButtonClick; override;
      procedure EditDblClick; override;
      procedure EditEditingDone; override;
    public
      constructor Create(AOwner: TComponent); override;
      property Time: TDateTime read GetTime write SetTime;
      property Button;
      property DroppedDown: Boolean read FDroppedDown;
    published
      property DefaultNow: Boolean read FDefaultNow write FDefaultNow default False;
      property OnAcceptTime: TAcceptTimeEvent read FOnAcceptTime write FOnAcceptTime;
      property OnCustomTime: TCustomTimeEvent read FOnCustomTime write FOnCustomTime;
      property ReadOnly;
      property ButtonOnlyWhenFocused;
      property ButtonWidth;
      property Action;
      property Align;
      property Anchors;
      property AutoSize;
      property AutoSelect;
      property BidiMode;
      property BorderSpacing;
      property BorderStyle;
      property CharCase;
      property Color;
      property Constraints;
      property DirectInput;
      property Glyph;
      property NumGlyphs;
      property DragMode;
      property EchoMode;
      property Enabled;
      property Flat;
      property FocusOnButtonClick;
      property Font;
      property MaxLength;
      property OnButtonClick;
      property OnChange;
      property OnChangeBounds;
      property OnClick;
      property OnDblClick;
      property OnEditingDone;
      property OnEnter;
      property OnExit;
      property OnKeyDown;
      property OnKeyPress;
      property OnKeyUp;
      property OnMouseDown;
      property OnMouseEnter;
      property OnMouseLeave;
      property OnMouseMove;
      property OnMouseUp;
      property OnMouseWheel;
      property OnMouseWheelDown;
      property OnMouseWheelUp;
      property OnResize;
      property OnUTF8KeyPress;
      property ParentBidiMode;
      property ParentColor;
      property ParentFont;
      property ParentShowHint;
      property PopupMenu;
      property ShowHint;
      property SimpleLayout: Boolean read GetLayout write SetLayout default True;
      property TabStop;
      property TabOrder;
      property Visible;
      property Text;
      property TextHint;
      property TextHintFontColor;
      property TextHintFontStyle;
  end;
  

  { TCalcEdit }

  TAcceptValueEvent = procedure(Sender: TObject; var AValue: Double; var Accept: Boolean) of object;

  TCalcEdit = class(TCustomEditButton)
  private
    FDialogTitle: String;
    FCalculatorLayout: TCalculatorLayout;
    FOnAcceptValue: TAcceptValueEvent;
    function GetAsFloat: Double;
    function GetAsInteger: Integer;
    procedure SetAsFloat(const AValue: Double);
    procedure SetAsInteger(const AValue: Integer);
    function TitleStored: boolean;
  protected
    FCalcDialog : TForm;
    function GetDefaultGlyph: TBitmap; override;
    function GetDefaultGlyphName: String; override;
    procedure ButtonClick; override;
    procedure RunDialog; virtual;
  public
    constructor Create(AOwner: TComponent); override;
    property AutoSelected;
  published
    // CalcEdit properties
    property CalculatorLayout : TCalculatorLayout read FCalculatorLayout write FCalculatorLayout;
    property AsFloat : Double read GetAsFloat write SetAsFloat;
    property AsInteger : Integer read GetAsInteger write SetAsInteger;
    property OnAcceptValue : TAcceptValueEvent read FOnAcceptValue write FOnAcceptValue;
    property DialogTitle : String read FDialogTitle write FDialogTitle stored TitleStored;
    // TEditButton properties.
    property ButtonCaption;
    property ButtonCursor;
    property ButtonHint;
    property ButtonOnlyWhenFocused;
    property ButtonWidth;
    property DirectInput;
    // property Glyph;
    property NumGlyphs;
    property Flat;
    property FocusOnButtonClick;
    // Other properties
    property Align;
    property Anchors;
    property BidiMode;
    property BorderSpacing;
    property BorderStyle;
    property AutoSize;
    property AutoSelect;
    property Color;
    property DragCursor;
    property DragMode;
    property Enabled;
    property Font;
    property Layout;
    property MaxLength;
    property ParentBidiMode;
    property ParentColor;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ReadOnly;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property Visible;
    property OnButtonClick;
    property OnChange;
    property OnClick;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEditingDone;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMouseDown;
    property OnMouseEnter;
    property OnMouseLeave;
    property OnMouseMove;
    property OnMouseUp;
    property OnMouseWheel;
    property OnMouseWheelDown;
    property OnMouseWheelUp;
    property OnStartDrag;
    property OnUTF8KeyPress;
    property Text;
    property TextHint;
    property TextHintFontColor;
    property TextHintFontStyle;
  end;


var
  FileOpenGlyph: TBitmap;
  DateGlyph: TBitmap;
  CalcGlyph: TBitmap;
  TimeGlyph: TBitmap;

const
  ResBtnListFilter = 'btnfiltercancel';
  ResBtnFileOpen   = 'btnselfile';
  ResBtnSelDir     = 'btnseldir';
  ResBtnCalendar   = 'btncalendar';
  ResBtnCalculator = 'btncalculator';
  ResBtnTime       = 'btntime';

//procedure Register;

implementation

//{$R lcl_edbtnimg.res}

{ TEbEdit }

procedure TEbEdit.DoEnter;
begin
  if (Owner is TCustomEditButton) then TCustomEditButton(Owner).CheckButtonVisible;
  inherited DoEnter;
end;

procedure TEbEdit.DoExit;
begin
  if (Owner is TCustomEditButton) then TCustomEditButton(Owner).CheckButtonVisible;
  inherited DoExit;
end;

function TEbEdit.PerformTab(ForwardTab: boolean): boolean;
begin
  //if not Forward then inherited PerFormTab will set focus to the owning
  //TCustomEditButton, which immediately transfers the focus back to the TEbEdit
  //so let TCustomEditButton do the Performtab in this case
  if ForwardTab then
    Result := inherited PerformTab(ForwardTab)
  else
  begin
    if Assigned(Owner) and (Owner is TCustomEditButton) then
      Result :=  TCustomEditButton(Owner).PerformTab(ForwardTab)
    else
      Result := False;
  end;
end;

{ TCustomEditButton }

procedure TCustomEditButton.InternalOnButtonClick(Sender: TObject);
begin
  ButtonClick;
end;

procedure TCustomEditButton.InternalOnEditChange(Sender: TObject);
begin
  if not (csLoading in ComponentState) then
    EditChange;
end;

procedure TCustomEditButton.InternalOnEditClick(Sender: TObject);
begin
  EditClick;
end;

procedure TCustomEditButton.InternalOnEditDblClick(Sender: TObject);
begin
  EditDblClick;
end;

procedure TCustomEditButton.InternalOnEditDragDrop(Sender, Source: TObject; X, Y: Integer);
begin
  EditDragDrop(Source, X, Y);
end;

procedure TCustomEditButton.InternalOnEditDragOver(Sender, Source: TObject; X, Y: Integer; State: TDragState; var Accept: Boolean);
begin
  EditDragOver(Source, X, Y, State, Accept);
end;

procedure TCustomEditButton.InternalOnEditEditingDone(Sender: TObject);
begin
  EditEditingDone;
end;

procedure TCustomEditButton.InternalOnEditEndDrag(Sender, Target: TObject; X, Y: Integer);
begin
  EditEndDrag(Target, X, Y);
end;

procedure TCustomEditButton.InternalOnEditEnter(Sender: TObject);
begin
  EditEnter;
end;

procedure TCustomEditButton.InternalOnEditExit(Sender: TObject);
begin
  EditExit;
end;

procedure TCustomEditButton.InternalOnEditKeyDown(Sender: TObject; var Key: word;
  Shift: TShiftState);
begin
  EditKeyDown(Key, Shift);
end;

procedure TCustomEditButton.InternalOnEditKeyPress(Sender: TObject; var Key: char);
begin
  EditKeyPress(Key);
end;

procedure TCustomEditButton.InternalOnEditKeyUp(Sender: TObject; var Key: word;
  Shift: TShiftState);
begin
  EditKeyUp(Key, Shift);
end;

procedure TCustomEditButton.InternalOnEditMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  EditMouseDown(Button, Shift, X, Y);
end;

procedure TCustomEditButton.InternalOnEditMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  EditMouseUp(Button, Shift, X, Y);
end;

procedure TCustomEditButton.InternalOnEditMouseEnter(Sender: TObject);
begin
  EditMouseEnter;
end;

procedure TCustomEditButton.InternalOnEditMouseLeave(Sender: TObject);
begin
  EditMouseLeave;
end;

procedure TCustomEditButton.InternalOnEditMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  EditMouseMove(Shift, X, Y);
end;

procedure TCustomEditButton.InternalOnEditMouseWheel(Sender: TObject;
  Shift: TShiftState; WheelDelta: Integer; MousePos: TPoint;
  var Handled: Boolean);
begin
  EditMouseWheel(Shift, WheelDelta, MousePos, Handled);
end;

procedure TCustomEditButton.InternalOnEditMouseWheelUp(Sender: TObject;
  Shift: TShiftState; MousePos: TPoint; var Handled: Boolean);
begin
  EditMouseWheelUp(Shift, MousePos, Handled);
end;

procedure TCustomEditButton.InternalOnEditMouseWheelDown(Sender: TObject;
  Shift: TShiftState; MousePos: TPoint; var Handled: Boolean);
begin
  EditMouseWheelDown(Shift, MousePos, Handled);
end;

procedure TCustomEditButton.InternalOnEditUtf8KeyPress(Sender: TObject;
  var UTF8Key: TUTF8Char);
begin
  EditUtf8KeyPress(UTF8Key);
end;

procedure TCustomEditButton.InternalOnEditStartDrag(Sender: TObject; var DragObject: TDragObject);
begin
  EditStartDrag(DragObject);
end;

function TCustomEditButton.GetButtonWidth: Integer;
begin
  Result := FButton.Width;
end;

function TCustomEditButton.GetCanUndo: Boolean;
begin
  Result := FEdit.CanUndo;
end;

function TCustomEditButton.GetCaretPos: TPoint;
begin
  Result := FEdit.CaretPos;
end;

function TCustomEditButton.GetEditPopupMenu: TPopupMenu;
begin
  Result := FEdit.PopupMenu;
end;

procedure TCustomEditButton.CalculatePreferredSize(var PreferredWidth,
  PreferredHeight: integer; WithThemeSpace: Boolean);
begin
  inherited CalculatePreferredSize(PreferredWidth, PreferredHeight, WithThemeSpace);
  PreferredWidth := 0;
end;

function TCustomEditButton.GetReadOnly: Boolean;
begin
  Result := FIsReadOnly;
end;

function TCustomEditButton.GetSelLength: Integer;
begin
  Result := FEdit.SelLength;
end;

function TCustomEditButton.GetSelStart: Integer;
begin
  Result := FEdit.SelStart;
end;

function TCustomEditButton.GetSelText: String;
begin
  Result := FEdit.SelText;
end;

function TCustomEditButton.GetSpacing: Integer;
begin
  Result := FButton.Spacing;
end;

function TCustomEditButton.GetTabStop: Boolean;
begin
  Result := inherited TabStop;
end;

function TCustomEditButton.GetText: TCaption;
begin
  Result := FEdit.Text;
end;

function TCustomEditButton.GetTextHint: TTranslateString;
begin
  Result := FEdit.TextHint;
end;

function TCustomEditButton.GetTextHintFontColor: TColor;
begin
  Result := FEdit.TextHintFontColor;
end;

function TCustomEditButton.GetTextHintFontStyle: TFontStyles;
begin
  Result := FEdit.TextHintFontStyle;
end;

function TCustomEditButton.IsCustomGlyph: Boolean;

  function _LoadRes: TBitmap;
  var
    ResName: String;
    C : TCustomBitmap;
  begin
    ResName := GetDefaultGlyphName;
    if ResName = '' then
      Exit(nil);
    Result := TBitmap.Create;
    try
      try
        C := TPortableNetworkGraphic.Create;
        C.LoadFromResourceName(hInstance, ResName);
        Result.Assign(C); // the "Equals" did not work with ClassType different
        // maybe it should compare the "RawImage" because it is independent of ClassType
      finally
        C.Free;
      end;
    except
      Result.Free;
      raise;
    end;
  end;

var
  B, GlypRes, GlypActual: TBitmap;
begin
  GlypActual := nil;
  GlypRes := nil;
  try
    B := GetDefaultGlyph;
    if B = nil then                // if Default Glyph is nil, use the resource
    begin
      GlypRes := _LoadRes;
      B := GlypRes;
    end;
    if B = nil then
      Result := Glyph <> nil
    else if Glyph = nil then
      Result := True
    else
    begin
      GlypActual := TBitmap.Create; // the "Equals" did not work with ClassType different.
      GlypActual.Assign(Glyph);
      Result := not GlypActual.Equals(B);
    end;
  finally
    GlypRes.Free;
    GlypActual.Free;
  end;
end;

procedure TCustomEditButton.FocusAndMaybeSelectAll;
begin
  FEdit.SetFocus;
  if AutoSelect then
    FEdit.SelectAll
  else
    FEdit.SelStart := MaxInt;
end;

function TCustomEditButton.GetAlignment: TAlignment;
begin
  Result := FEdit.Alignment;
end;


function TCustomEditButton.GetAutoSelect: Boolean;
begin
  Result := FEdit.AutoSelect;
end;

function TCustomEditButton.GetAutoSelected: Boolean;
begin
  Result := FEdit.AutoSelected;
end;

function TCustomEditButton.GetButtonHint: TTranslateString;
begin
  Result := FButton.Hint;
end;

function TCustomEditButton.GetBtnCaption: TCaption;
begin
  Result := FButton.Caption;
end;

function TCustomEditButton.GetButtonCursor: TCursor;
begin
  Result := FButton.Cursor;
end;


procedure TCustomEditButton.SetButtonHint(AValue: TTranslateString);
begin
  FButton.Hint := AValue;
end;

procedure TCustomEditButton.SetButtonOnlyWhenFocused(AValue: Boolean);
begin
  if FButtonOnlyWhenFocused <> AValue then
  begin
    FButtonOnlyWhenFocused := AValue;
    CheckButtonVisible;
  end;
end;

procedure TCustomEditButton.SetButtonWidth(AValue: Integer);
begin
  FButton.Width := AValue;
end;

procedure TCustomEditButton.SetCaretPos(AValue: TPoint);
begin
  FEdit.CaretPos := AValue;
end;

function TCustomEditButton.GetCharCase: TEditCharCase;
begin
  Result := FEdit.CharCase;
end;

function TCustomEditButton.GetDirectInput: Boolean;
begin
  Result := FDirectInput;
end;

function TCustomEditButton.GetEchoMode: TEchoMode;
begin
  Result := FEdit.EchoMode;
end;

function TCustomEditButton.GetEditMask: String;
begin
  Result := FEdit.EditMask
end;

function TCustomEditButton.GetEditText: string;
begin
  Result := FEdit.EditText;
end;

function TCustomEditButton.GetColor: TColor;
begin
  Result := FEdit.Color;
end;


function TCustomEditButton.GetGlyph: TBitmap;
begin
  Result := FButton.Glyph;
end;

function TCustomEditButton.GetHideSelection: Boolean;
begin
  Result := FEdit.HideSelection;
end;

function TCustomEditButton.GetIsMasked: Boolean;
begin
  Result := FEdit.IsMasked;
end;


function TCustomEditButton.GetMaxLength: Integer;
begin
  Result := FEdit.MaxLength;
end;

function TCustomEditButton.GetModified: Boolean;
begin
  Result := FEdit.Modified;
end;

function TCustomEditButton.GetNumbersOnly: Boolean;
begin
  Result := FEdit.NumbersOnly;
end;

function TCustomEditButton.GetNumGlyps: Integer;
begin
  Result := FButton.NumGlyphs;
end;

function TCustomEditButton.GetParentColor: Boolean;
begin
  Result := FEdit.ParentColor;
end;

function TCustomEditButton.GetPasswordChar: char;
begin
  Result := FEdit.PasswordChar;
end;

procedure TCustomEditButton.SetAlignment(AValue: TAlignment);
begin
  FEdit.Alignment := AValue;
end;

procedure TCustomEditButton.SetAutoSelect(AValue: Boolean);
begin
  FEdit.AutoSelect := AValue;
end;

procedure TCustomEditButton.SetAutoSelected(AValue: Boolean);
begin
  FEdit.AutoSelected := AValue;
end;

procedure TCustomEditButton.SetAutoSize(AValue: Boolean);
begin
  if AutoSize = AValue then
    Exit;
  inherited SetAutosize(AValue);
  //FButton.AutoSize := AValue;
  FEdit.AutoSize := AValue;
end;

procedure TCustomEditButton.SetBtnCaption(AValue: TCaption);
begin
  FButton.Caption := AValue;
end;

procedure TCustomEditButton.SetButtonCursor(AValue: TCursor);
begin
  FButton.Cursor := AValue;
end;

class function TCustomEditButton.GetControlClassDefaultSize: TSize;
begin
  Result.CX := 80 + 23; //as TCustomEdit + TCustomSpeedButton
  Result.CY := 23;  //as TCustomEdit
end;

function TCustomEditButton.GetDefaultGlyph: TBitmap;
begin
  Result := nil;
end;

function TCustomEditButton.GetDefaultGlyphName: String;
begin
  Result := '';
end;

procedure TCustomEditButton.SetCharCase(AValue: TEditCharCase);
begin
  FEdit.CharCase := AValue;
end;

procedure TCustomEditButton.SetDirectInput(AValue: Boolean);
begin
  FDirectInput := AValue;
  FEdit.ReadOnly := ((not FDirectInput) or (FIsReadOnly));
end;

procedure TCustomEditButton.SetEchoMode(AValue: TEchoMode);
begin
  FEdit.EchoMode := AValue;
end;

procedure TCustomEditButton.SetEditMask(AValue: String);
begin
  FEdit.EditMask := AValue;
end;

procedure TCustomEditButton.SetEditText(AValue: string);
begin
  FEdit.EditText := AValue;
end;

procedure TCustomEditButton.SetColor(AValue: TColor);
begin
  if (csLoading in ComponentState) then
    FInitialColor := AValue
  else
    FEdit.Color := AValue;
end;

procedure TCustomEditButton.SetCursor(AValue: TCursor);
begin
  if Cursor = AValue then
    Exit;
  inherited SetCursor(AValue);
  FEdit.Cursor := AValue;
end;

procedure TCustomEditButton.SetFocus;
begin
  FEdit.SetFocus;
end;

procedure TCustomEditButton.SetFlat(AValue: Boolean);
begin
  if FFlat = AValue then
    Exit;
  FFlat := AValue;
  FButton.Flat := AValue;
end;

procedure TCustomEditButton.SetHideSelection(AValue: Boolean);
begin
  FEdit.HideSelection := AValue;
end;

procedure TCustomEditButton.SetLayout(AValue: TLeftRight);
begin
  if (FLayout = AValue) then
    Exit;
  FLayout := AValue;
  case FLayout of
    taLeftJustify : FButton.Align := alRight;
    taRightJustify: FButton.Align := alLeft;
  end;
end;

procedure TCustomEditButton.SetMaxLength(AValue: Integer);
begin
  FEdit.MaxLength := AValue;
end;

procedure TCustomEditButton.SetModified(AValue: Boolean);
begin
  FEdit.Modified := AValue;
end;

procedure TCustomEditButton.SetNumbersOnly(AValue: Boolean);
begin
  FEdit.NumbersOnly := AValue;
end;

procedure TCustomEditButton.SetNumGlyphs(AValue: Integer);
begin
  FButton.NumGlyphs := AValue;
end;

procedure TCustomEditButton.SetParentColor(AValue: Boolean);
begin
  FEdit.ParentColor := AValue;
end;

procedure TCustomEditButton.SetPasswordChar(AValue: char);
begin
  FEdit.PasswordChar := AValue;
end;

procedure TCustomEditButton.SetPopupMenu(AValue: TPopupMenu);
begin
  FEdit.PopupMenu := AValue;
end;

procedure TCustomEditButton.SetText(AValue: TCaption);
begin
  FEdit.Text := AValue;
end;

function TCustomEditButton.CalcButtonVisible: Boolean;
begin
  Result := (csdesigning in ComponentState) or
            (Visible and (FEdit.Focused or not FButtonOnlyWhenFocused));
end;

procedure TCustomEditButton.CheckButtonVisible;
begin
  If Assigned(FButton) then
    FButton.Visible := CalcButtonVisible;
end;

procedure TCustomEditButton.ButtonClick;
begin
  if ReadOnly then
    Exit;
  if Assigned(FOnButtonClick) then
    FOnButtonClick(Self);
  //derived controls that override ButtonClick tipically run a dialog after calling inherited,
  //in that case selecting the text now does not make sense at all (and looks silly)
  //it's up to the derived control to implement this focus and select if wanted
  if TMethod(@Self.ButtonClick).Code = Pointer(@TCustomEditButton.ButtonClick) then
  begin
    if FocusOnButtonClick then FocusAndMaybeSelectAll;
  end;
end;

procedure TCustomEditButton.DoEnter;
begin
  inherited DoEnter;
  if fedit.canfocus then FEdit.SetFocus;
end;

procedure TCustomEditButton.EditChange;
begin
  if Assigned(FOnEditChange) then FOnEditChange(Self);
end;

procedure TCustomEditButton.EditClick;
begin
  if Assigned(FOnEditClick) then FOnEditClick(Self);
end;

procedure TCustomEditButton.EditDblClick;
begin
  if Assigned(FOnEditDblClick) then FOnEditDblClick(Self);
end;

procedure TCustomEditButton.EditDragDrop(Source: TObject; X, Y: Integer);
begin
  if Assigned(FOnEditDragDrop) then FOnEditDragDrop(Self, Source, X, Y);
end;

procedure TCustomEditButton.EditDragOver(Source: TObject; X, Y: Integer;
  State: TDragState; var Accept: Boolean);
begin
  if Assigned(FOnEditDragOver) then FOnEditDragOver(Self, Source, X, Y, State, Accept);
end;

procedure TCustomEditButton.EditEditingDone;
begin
  if Assigned(FOnEditEditingDone) then FOnEditEditingDone(Self);
end;

procedure TCustomEditButton.EditEndDrag(Target: TObject; X, Y: Integer);
begin
  if Assigned(FOnEditEndDrag) then FOnEditEndDrag(Self, Target, X, Y);
end;

procedure TCustomEditButton.EditEnter;
begin
  if Assigned(FOnEditEnter) then FOnEditEnter(Self);
end;

procedure TCustomEditButton.EditExit;
begin
  if Assigned(FOnEditExit) then FOnEditExit(Self);
end;

procedure TCustomEditButton.EditKeyDown(var Key: word; Shift: TShiftState);
begin
  if Assigned(FOnEditKeyDown) then FOnEditKeyDown(Self, Key, Shift);
end;

procedure TCustomEditButton.EditKeyPress(var Key: char);
begin
  if Assigned(FOnEditKeyPress) then FOnEditKeyPress(Self, Key);
end;

procedure TCustomEditButton.EditKeyUp(var Key: word; Shift: TShiftState);
begin
  if Assigned(FOnEditKeyUp) then FOnEditKeyUp(Self, Key, Shift);
end;

procedure TCustomEditButton.EditMouseDown(Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if Assigned(FOnEditMouseDown) then FOnEditMouseDown(Self, Button, Shift, X, Y);
end;

procedure TCustomEditButton.EditMouseUp(Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if Assigned(FOnEditMouseUp) then FOnEditMouseUp(Self, Button, Shift, X, Y);
end;

procedure TCustomEditButton.EditMouseEnter;
begin
  if Assigned(FOnEditMouseEnter) then FOnEditMouseEnter(Self);
end;

procedure TCustomEditButton.EditMouseLeave;
begin
  if Assigned(FOnEditMouseLeave) then FOnEditMouseLeave(Self);
end;

procedure TCustomEditButton.EditMouseMove(Shift: TShiftState; X, Y: Integer);
begin
  if Assigned(FOnEditMouseMove) then FOnEditMouseMove(Self, Shift, X, Y);
end;

procedure TCustomEditButton.EditMouseWheel(Shift: TShiftState;
  WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
begin
  if Assigned(FOnEditMouseWheel) then FOnEditMouseWheel(Self, Shift, WheelDelta, MousePos, Handled);
end;

procedure TCustomEditButton.EditMouseWheelUp(Shift: TShiftState;
  MousePos: TPoint; var Handled: Boolean);
begin
  if Assigned(FOnEditMouseWheelUp) then FOnEditMouseWheelUp(Self, Shift, MousePos, Handled);
end;

procedure TCustomEditButton.EditMouseWheelDown(Shift: TShiftState;
  MousePos: TPoint; var Handled: Boolean);
begin
  if Assigned(FOnEditMouseWheelDown) then FOnEditMouseWheelDown(Self, Shift, MousePos, Handled);
end;

procedure TCustomEditButton.EditUtf8KeyPress(var UTF8Key: TUTF8Char);
begin
  if Assigned(FOnEditUtf8KeyPress) then FOnEditUtf8KeyPress(Self, Utf8Key);
end;

procedure TCustomEditButton.EditStartDrag(var DragObject: TDragObject);
begin
  if Assigned(FOnEditStartDrag) then FOnEditStartDrag(Self, DragObject);
end;

procedure TCustomEditButton.CheckCursor;
begin
  FEdit.CheckCursor;
end;

procedure TCustomEditButton.CMParentColorChanged(var Message: TLMessage);
begin
  if inherited ParentColor then
  begin
    inherited SetColor(Parent.Color);
    inherited ParentColor := True;
  end;
end;

function TCustomEditButton.EditCanModify: Boolean;
begin
  Result := FEdit.EditCanModify;
end;

procedure TCustomEditButton.GetSel(out _SelStart: Integer; out _SelStop: Integer);
begin
  FEdit.GetSel(_SelStart, _SelStop);
end;

procedure TCustomEditButton.SetSel(const _SelStart: Integer; _SelStop: Integer);
begin
  FEdit.SetSel(_SelStart, _SelStop);
end;

procedure TCustomEditButton.Loaded;
begin
  inherited Loaded;
  {
    inherited Loaded sends a CM_PARENTFONTCHANGED message, which then
    also sets FEdit's color, which is undesired.
  }
  if GetColor <> FInitialColor then SetColor(FInitialColor);
  CheckButtonVisible;
end;


procedure TCustomEditButton.Reset;
begin
  FEdit.Reset;
end;

procedure TCustomEditButton.SetGlyph(AValue: TBitmap);
begin
  FButton.Glyph := AValue;
  Invalidate;
end;

procedure TCustomEditButton.SetReadOnly(AValue: Boolean);
begin
  FIsReadOnly := AValue;
  FEdit.ReadOnly := AValue or (not DirectInput);
  FButton.Enabled := not FIsReadOnly and Enabled;
end;

procedure TCustomEditButton.SetSelLength(AValue: Integer);
begin
  FEdit.SelLength := AValue;
end;

procedure TCustomEditButton.SetSelStart(AValue: Integer);
begin
  FEdit.SelStart := AValue;
end;

procedure TCustomEditButton.SetSelText(AValue: String);
begin
  FEdit.SelText := AValue;
end;

procedure TCustomEditButton.SetSpacing(const Value: integer);
begin
  FButton.Spacing := Value;
end;

procedure TCustomEditButton.SetTabStop(AValue: Boolean);
begin
  inherited TabStop := AValue;
  FEdit.TabStop := AValue;
end;

procedure TCustomEditButton.SetTextHint(AValue: TTranslateString);
begin
  FEdit.TextHint := AValue;
end;

procedure TCustomEditButton.SetTextHintFontColor(AValue: TColor);
begin
  FEdit.TextHintFontColor := AValue;
end;

procedure TCustomEditButton.SetTextHintFontStyle(AValue: TFontStyles);
begin
  FEdit.TextHintFontStyle := AValue;
end;

constructor TCustomEditButton.Create(AOwner: TComponent);
var
  B: TBitmap;
begin
  FButton := TSpeedButton.Create(Self);
  FEdit := TEbEdit.Create(Self);
  inherited Create(AOwner);
  ControlStyle := ControlStyle + [csNoFocus];
  FEdit.ParentColor := False;
  FInitialColor := {$ifdef UseCLDefault}clDefault{$else}clWindow{$endif};
  BorderStyle := bsNone;
  FLayout := taLeftjustify;
  FButtonOnlyWhenFocused := False;
  FDirectInput := True;
  FIsReadOnly := False;
  TabStop := True;
  FocusOnButtonClick := False;

  SetInitialBounds(0, 0, GetControlClassDefaultSize.CX, GetControlClassDefaultSize.CY);

  with FButton do
  begin
    Align := alRight;
    OnClick := @InternalOnButtonClick;
    Spacing := 4;
    Parent := Self;
  end;
  B := GetDefaultGlyph;
  if B = nil
  then
   FButton.LoadGlyphFromResourceName(hInstance, GetDefaultGlyphName)
  else
    FButton.Glyph := B;

  with FEdit do
  begin
    Align := alClient;
    ParentColor := False;
    ParentFont := True;

    AutoSelect := True;
    Alignment := taLeftJustify;
    ReadOnly := False;

    OnChange := @InternalOnEditChange;
    OnClick := @InternalOnEditClick;
    OnDblClick := @InternalOnEditDblClick;
    OnDragDrop := @InternalOnEditDragDrop;
    OnDragOver := @InternalOnEditDragOver;
    OnEditingDone := @InternalOnEditEditingDone;
    OnEndDrag := @InternalOnEditEndDrag;
    OnExit := @InternalOnEditExit;
    OnEnter := @InternalOnEditEnter;
    OnKeyDown := @InternalOnEditKeyDown;
    OnKeyPress := @InternalOnEditKeyPress;
    OnKeyUp := @InternalOnEditKeyUp;
    OnMouseDown := @InternalOnEditMouseDown;
    OnMouseUp := @InternalOnEditMouseUp;
    OnMouseEnter := @InternalOnEditMouseEnter;
    OnMouseLeave := @InternalOnEditMouseLeave;
    OnMouseMove := @InternalOnEditMouseMove;
    OnMouseWheel := @InternalOnEditMouseWheel;
    OnMouseWheelUp := @InternalOnEditMouseWheelUp;
    OnMouseWheelDown := @InternalOnEditMouseWheelDown;
    OnStartDrag := @InternalOnEditStartDrag;
    OnUtf8KeyPress := @InternalOnEditUtf8KeyPress;

    Parent := Self;
  end;
  AutoSize := True;
  Color := {$ifdef UseCLDefault}clDefault{$else}clWindow{$endif};
  inherited ParentColor := True; //don't want to see the container if Parent's color changes
end;

destructor TCustomEditButton.Destroy;
begin
  inherited Destroy;
end;

function TCustomEditButton.Focused: Boolean;
begin
  Result := FEdit.Focused;
end;

procedure TCustomEditButton.Clear;
begin
  FEdit.Clear;
end;

procedure TCustomEditButton.ClearSelection;
begin
  FEdit.ClearSelection;
end;

procedure TCustomEditButton.CopyToClipboard;
begin
  FEdit.CopyToClipboard;
end;

procedure TCustomEditButton.CutToClipboard;
begin
  FEdit.CutToClipBoard;
end;

procedure TCustomEditButton.PasteFromClipboard;
begin
  FEdit.PasteFromClipBoard;
end;

procedure TCustomEditButton.SelectAll;
begin
  FEdit.SelectAll;
end;


procedure TCustomEditButton.Undo;
begin
  FEdit.Undo;
end;

procedure TCustomEditButton.ValidateEdit;
begin
  FEdit.ValidateEdit;
end;

{ TCustomControlFilterEdit }

constructor TCustomControlFilterEdit.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  CharCase:=ecLowerCase;
  Button.Enabled:=False;
  fIsFirstUpdate:=True;
  fIsFirstSetFormActivate:=True;
  TextHint:=rsFilter;
end;

destructor TCustomControlFilterEdit.Destroy;
begin
  inherited Destroy;
end;

procedure TCustomControlFilterEdit.OnIdle(Sender: TObject; var Done: Boolean);
begin
  if fNeedUpdate then
    ApplyFilter(true);
  IdleConnected:=false;
  if Assigned(fOnAfterFilter) then
    fOnAfterFilter(Self);
end;

procedure TCustomControlFilterEdit.SetUseFormActivate(AValue: Boolean);
var
  c: TWinControl;
begin
  if fUseFormActivate=AValue then Exit;
  fUseFormActivate:=AValue;
  c:=Parent;
  // Find the parent form
  while Assigned(c) and not (c is TForm) do
    c:=c.Parent;
  // Found: set or remove Activate and Deactivate handlers
  if c is TForm then begin
    fParentForm:=TForm(c);
    if AValue then begin          // Set handlers
      if fIsFirstSetFormActivate then begin
        if Assigned(fParentForm.OnActivate) or Assigned(fParentForm.OnDeactivate) then
          raise Exception.Create('TCustomControlFilterEdit.SetUseFormActivate:'+
                                 ' OnActivate handler already set in parent form');
        fIsFirstSetFormActivate:=False;
      end;
      fParentForm.OnActivate:=@FormActivate;
      fParentForm.OnDeactivate:=@FormDeactivate;
    end
    else begin                    // Remove handlers
      fParentForm.OnActivate:=nil;
      fParentForm.OnDeactivate:=nil;
    end;
  end
  else
    raise Exception.Create('TCustomControlFilterEdit.SetUseFormActivate: This control'+
              ' has no TForm in the parent chain. You should disable UseFormActivate.');
end;

procedure TCustomControlFilterEdit.FormActivate(Sender: TObject);
begin
  fJustActivated:=fParentForm.ActiveControl=Self.FEdit;
  if fJustActivated then
    Filter:=Text;
end;

procedure TCustomControlFilterEdit.FormDeactivate(Sender: TObject);
begin
  fJustActivated:=False;
end;

procedure TCustomControlFilterEdit.SetFilter(const AValue: string);
var
  NewValue: String;
begin
  if (TextHint<>'') and (AValue=TextHint) then
    NewValue:=''
  else
    NewValue:=AValue;
  Button.Enabled:=NewValue<>'';
  if (NewValue<>'') or Focused or fJustActivated or (csDesigning in ComponentState) then
  begin
    Text:=NewValue;
  end;
  if fFilter=NewValue then exit;
  fFilter:=NewValue;
  ApplyFilter;
end;

procedure TCustomControlFilterEdit.SetIdleConnected(const AValue: Boolean);
begin
  if fIdleConnected=AValue then exit;
  fIdleConnected:=AValue;
  if fIdleConnected then
    Application.AddOnIdleHandler(@OnIdle)
  else
    Application.RemoveOnIdleHandler(@OnIdle);
end;

procedure TCustomControlFilterEdit.EditKeyDown(var Key: Word; Shift: TShiftState);
var
  Handled: Boolean;
begin
  Handled:=False;
  if Shift = [] then
    case Key of
      VK_RETURN: Handled:=ReturnKeyHandled;
    end;

  if (Shift = []) or (Shift = [ssShift]) then
  begin
    case Key of
      VK_UP:     begin MovePrev(ssShift in Shift); Handled:=True; end;
      VK_DOWN:   begin MoveNext(ssShift in Shift); Handled:=True; end;
      VK_PRIOR:  begin MovePageUp(ssShift in Shift); Handled:=True; end;
      VK_NEXT:   begin MovePageDown(ssShift in Shift); Handled:=True; end;
    end;
  end;
  if (Shift = [ssCtrl]) or (Shift = [ssCtrl, ssShift]) then
  begin
    case Key of
      VK_HOME:   begin MoveHome(ssShift in Shift); Handled:=True; end;
      VK_END:    begin MoveEnd(ssShift in Shift); Handled:=True; end;
    end;
  end;
  if Handled then
    Key:=VK_UNKNOWN
  else
    inherited EditKeyDown(Key, Shift);
end;

procedure TCustomControlFilterEdit.EditChange;
begin
  Filter:=Text;
  inherited;
end;

procedure TCustomControlFilterEdit.EditEnter;
begin
//  inherited;
  fJustActivated:=False;
end;

procedure TCustomControlFilterEdit.EditExit;
begin
  fJustActivated:=False;
  Filter:=Text;
//  inherited;
end;

procedure TCustomControlFilterEdit.ButtonClick;
begin
  fJustActivated:=False;
  Text:='';
  Filter:='';
  if FocusOnButtonClick then FEdit.SetFocus; //don't SelectAll here
end;

procedure TCustomControlFilterEdit.ApplyFilter(Immediately: Boolean);
begin
  if Immediately then begin
    fNeedUpdate := False;
    SortAndFilter;
    if (fSelectedPart=Nil) and not fIsFirstUpdate then
      StoreSelection;      // At first round the selection is from caller
    fIsFirstUpdate:=False;

    ApplyFilterCore;       // The actual filtering implemented by inherited class.

    fSelectedPart:=Nil;
    RestoreSelection;
  end
  else if [csDestroying,csDesigning]*ComponentState=[] then
    InvalidateFilter;
end;

procedure TCustomControlFilterEdit.InvalidateFilter;
begin
  fNeedUpdate:=true;
  IdleConnected:=true;
end;

function TCustomControlFilterEdit.IsTextHintStored: Boolean;
begin
  Result := TextHint <> rsFilter;
end;

procedure TCustomControlFilterEdit.ResetFilter;
begin
  Filter := '';
end;

function TCustomControlFilterEdit.ForceFilter(AFilter: String): String;
// Apply a new filter immediately without waiting for idle. Returns the previous filter.
begin
  Result := FFilter;
  if fFilter <> AFilter then begin
    FFilter := AFilter;
    ApplyFilter(True);
  end;
end;

function TCustomControlFilterEdit.GetDefaultGlyphName: String;
begin
  Result := ResBtnListFilter;
end;

{ TFileNameEdit }

constructor TFileNameEdit.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FDialogFiles := TStringList.Create;
  FDialogKind := dkOpen;
  FDialogOptions := DefaultOpenDialogOptions;
end;

destructor TFileNameEdit.Destroy;
begin
  FreeAndNil(FDialogFiles);
  inherited Destroy;
end;

procedure TFileNameEdit.SetFileName(const AValue: String);
begin
  if FFileNameChangeLock > 0 then
    Exit;
  FFileName := AValue;
  Inc(FFileNameChangeLock);
  try
    if FHideDirectories then
      Text:=ExtractFileName(AValue) //Originally used inherited RealSetText()
    else
      Text:=AValue
  finally
    Dec(FFileNameChangeLock);
  end;
end;

function TFileNameEdit.CreateDialog(AKind: TDialogKind): TCommonDialog;
var
  O: TOpenDialog;
  S: TSaveDialog;
  Dir: String;
begin
  case AKind of
    dkOpen, dkPictureOpen:
    begin
      if AKind = dkPictureOpen then
        O := TOpenPictureDialog.Create(Self)
      else
        O := TOpenDialog.Create(Self);
      Result := O;
    end;
    dkSave, dkPictureSave:
    begin
      S:=TSaveDialog.Create(Self);
      S.DefaultExt := FDefaultExt;
      Result := S;
    end;
  end;
  if Result is TOpenDialog then
  begin
    O:=TOpenDialog(Result);
    Dir:=ExtractFilePath(Filename);
    if (Dir<>'') and DirPathExists(Dir) then
      // setting a FileName with path disables InitialDir
      O.FileName := FileName
    else begin
      // do not use path, so that InitialDir works
      O.FileName := ExtractFileName(Filename);
    end;
    O.Options := DialogOptions;
    O.Filter := Filter;
    O.FilterIndex := FilterIndex;
    O.InitialDir := CleanAndExpandDirectory(InitialDir);
  end;
  // Set some common things.
  Result.Title := DialogTitle;
end;

procedure TFileNameEdit.SaveDialogResult(AKind: TDialogKind; D: TCommonDialog);
var
  FN: String;
begin
  case AKind of
    dkOpen, dkPictureOpen :
    begin
      FilterIndex := TOpenDialog(D).FilterIndex;
      FN := TOpenDialog(D).FileName;
      if (FN <> '') then
      begin
        if Assigned(OnAcceptFileName) then
          OnAcceptFileName(Self, FN);
      end;
      if (FN <> '') then
      begin
        // set FDialogFiles first since assigning of FileName trigger events
        FDialogFiles.Text := TOpenDialog(D).Files.Text;
        FileName := FN;
      end;
    end;
    dkSave, dkPictureSave :
    begin
      FileName := TSaveDialog(D).FileName;
      FilterIndex := TSaveDialog(D).FilterIndex;
      FDialogFiles.Clear;
    end;
  end;
end;

procedure TFileNameEdit.ButtonClick;
begin
  inherited ButtonClick;
  RunDialog;
  //Do this after the dialog, otherwise it just looks silly
  if FocusOnButtonClick then FocusAndMaybeSelectAll;
end;

function TFileNameEdit.GetDefaultGlyph: TBitmap;
begin
  Result := FileOpenGlyph;
end;

function TFileNameEdit.GetDefaultGlyphName: String;
begin
  Result := ResBtnFileOpen;
end;

procedure TFileNameEdit.RunDialog;
var
  D: TCommonDialog;
begin
  D := CreateDialog(DialogKind);
  try
    if D.Execute then
      SaveDialogResult(DialogKind, D);
  finally
    D.Free;
  end
end;

procedure TFileNameEdit.EditChange;
begin
  if FFileNameChangeLock <= 0 then
  begin
    Inc(FFileNameChangeLock);
    try
      if FHideDirectories and (ExtractFilePath(Text) = '') then
        FFileName := ExtractFilePath(FFileName) + Text
      else
        FFileName := Text;
    finally
      Dec(FFileNameChangeLock);
    end;
  end;
  inherited EditChange; //do this _after_ we have updated FFileName
end;

procedure TFileNameEdit.DoFolderChange(Sender: TObject);
begin
  if Assigned(FOnFolderChange) then
    FOnFolderChange(Self);
end;

{ TDirectoryEdit }

procedure TDirectoryEdit.SetDirectory(const AValue: String);
begin
  if (Text<>AValue) then
    Text:=AValue;
end;

function TDirectoryEdit.CreateDialog: TCommonDialog;
begin
  Result:=TSelectDirectoryDialog.Create(Self);
  if DirPathExists(Directory) then
  begin
    TSelectDirectoryDialog(Result).InitialDir:=Directory;
    TSelectDirectoryDialog(Result).FileName:='';
  end
  else
  begin
    TSelectDirectoryDialog(Result).InitialDir:=RootDir;
    TSelectDirectoryDialog(Result).FileName:=Directory;
  end;
  // Set some common things.
  Result.Title := DialogTitle;
end;

function TDirectoryEdit.GetDialogResult(D: TCommonDialog) : String;
begin
  Result:=TSelectDirectoryDialog(D).FileName;
end;


procedure TDirectoryEdit.ButtonClick;
begin
  inherited ButtonClick;
  RunDialog;
  //Do this after the dialog, oterwise it just looks silly
  if FocusOnButtonClick then FocusAndMaybeSelectAll;
end;

function TDirectoryEdit.GetDefaultGlyph: TBitmap;
begin
  Result := FileOpenGlyph;
end;

function TDirectoryEdit.GetDefaultGlyphName: String;
begin
  Result := ResBtnSelDir;
end;

procedure TDirectoryEdit.RunDialog;
var
  D: String;
  Dlg: TCommonDialog;
  B: Boolean;
begin
  Dlg:=CreateDialog;
  try
    B:=Dlg.Execute;
    if B then
      D:=GetDialogResult(Dlg);
  finally
    Dlg.Free;
  end;
  if B then
  begin
    if Assigned(FOnAcceptDir) then
    begin
      FOnAcceptdir(Self,D);
      if (D<>'') then
        Directory:=D;
    end
    else
      Directory:=D;
  end;
end;

function TDirectoryEdit.GetDirectory: String;
begin
  Result:=Text;
end;

{ TDateEdit }

function StrToDateDef(cDate: String; dDefault: TDateTime): TDateTime;
begin
  try
    Result := StrToDate(cDate)
  except
    Result := dDefault;
  end;
end;

constructor TDateEdit.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FDate := NullDate;
  FUpdatingDate := False;
  FDefaultToday := False;
  FDisplaySettings := [dsShowHeadings, dsShowDayNames];
  OKCaption := 'OK';
  CancelCaption := 'Cancel';
end;


function TDateEdit.GetDateFormat: string;
begin
  Result := FFixedDateFormat;
end;

function TDateEdit.GetDefaultGlyph: TBitmap;
begin
  Result := DateGlyph;
end;

function TDateEdit.GetDefaultGlyphName: String;
begin
  Result := ResBtnCalendar;
end;

procedure TDateEdit.ButtonClick;//or onClick
var
  PopupOrigin: TPoint;
  ADate: TDateTime;
begin
  inherited ButtonClick;

  PopupOrigin := ControlToScreen(Point(0, Height));
  ADate := GetDate;
  if ADate = NullDate then
    ADate := SysUtils.Date;
  ShowCalendarPopup(PopupOrigin, ADate, CalendarDisplaySettings,
                    @CalendarPopupReturnDate, @CalendarPopupShowHide);
  //Do this after the dialog, otherwise it just looks silly
  if FocusOnButtonClick then FocusAndMaybeSelectAll;
end;

procedure TDateEdit.EditDblClick;
begin
  inherited EditDblClick;
  if not ReadOnly then
    ButtonClick;
end;

procedure TDateEdit.SetDirectInput(AValue: Boolean);
var
  Def: TDateTime;
begin
  inherited SetDirectInput(AValue);
  //Synchronize FDate and force valid text
  FDate := TextToDate(Text, NullDate);
  SetDate(FDate);
end;

procedure TDateEdit.SetText(AValue: TCaption);
begin
  if (not DirectInput) and not FUpdatingDate then
  begin
    //force a valid date and set FDate
    //debugln('TDateEdit.SetText: DirectInput = False');
    if FDefaultToday then
      FDate := TextToDate(AValue, SysUtils.Date)
    else
      FDate := TextToDate(AValue, NullDate);
    AValue := DateToText(FDate);
  end;
  inherited SetText(AValue);
end;

procedure TDateEdit.SetDateMask;

Var
  S : String;
  D : TDateTime;
begin
  Case DateOrder of
    doNone :
       begin
       S:=''; // no mask
       FFixedDateFormat:='';
       end;
    doDMY,
    doMDY  :
      begin
      S:='99/99/9999;1;_';
      if DateOrder=doMDY then
        FFixedDateFormat:='mm/dd/yyyy'
      else
        FFixedDateFormat:='dd/mm/yyyy';
      end;
    doYMD  :
      begin
      S:='9999/99/99;1;_';
      FFixedDateFormat:='yyyy/mm/dd';
      end;
  end;
  D:=GetDate;
  EditMask:=S;
  SetDate(D);
end;

Function ParseDate(S : String; Order : TDateOrder; Def: TDateTime) : TDateTime;

Var
  P,N1,N2,N3 : Integer;
  B : Boolean;

begin
  Result:=Def;
  P:=Pos(DefaultFormatSettings.DateSeparator,S);
  If (P=0) then
    Exit;
  N1:=StrToIntDef(Copy(S,1,P-1),-1);
  If (N1=-1) then Exit;
  Delete(S,1,P);
  P:=Pos(DefaultFormatSettings.DateSeparator,S);
  If (P=0) then
    Exit;
  N2:=StrToIntDef(Copy(S,1,P-1),-1);
  If (N1=0) then Exit;
  Delete(S,1,P);
  N3:=StrToIntDef(S,-1);
  If (N3=-1) then
    exit;
  Case Order of
    doYMD : B:=TryEncodeDate(N1,N2,N3,Result);
    doMDY : B:=TryEncodeDate(N3,N1,N2,Result);
    doDMY : B:=TryEncodeDate(N3,N2,N1,Result);
    else B:=false;
  end;
  If not B then // Not sure if TryEncodeDate touches Result.
    Result:=Def;
end;

// Tries to parse string when DateOrder = doNone when string maybe contains
// literal day or monthnames. For example when ShortDateFormat = 'dd-mmm-yyy'
// Returns NullDate upon failure.
function ParseDateNoPredefinedOrder(SDate: String; FS: TFormatSettings): TDateTime;
var
  Fmt: String;
  DPos, MPos, YPos: SizeInt;
  DStr, MStr, YStr: String;
  LD, LM, LY: LongInt;
  DD, MM, YY: Word;
const
  Digits = ['0'..'9'];

  procedure GetPositions(out DPos, MPos, YPos: SizeInt);
  begin
    DStr := '';
    MStr := '';
    YStr := '';
    DPos := Pos('D', Fmt);
    MPos := Pos('M', Fmt);
    YPos := Pos('Y', Fmt);
    if (YPos = 0) or (MPos = 0) or (DPos = 0) then Exit;
    if (YPos > DPos) then YPos := 3 else YPos := 1;
    if (DPos < MPos) then
    begin
      if (YPos = 3) then
      begin
        DPos := 1;
        MPos := 2;
      end
      else
      begin
        DPos := 2;
        MPos := 3;
      end;
    end
    else
    begin
      if (YPos = 3) then
      begin
        DPos := 2;
        MPos := 1;
      end
      else
      begin
        DPos := 3;
        MPos := 2;
      end;
    end;
  end;

  procedure ReplaceLiterals;
  var
    i, P: Integer;
    Sub: String;
  begin
    if (Pos('MMMM',Fmt) > 0) then
    begin //long monthnames
      //writeln('Literal monthnames');
      for i := 1 to 12 do
      begin
        Sub := FS.LongMonthNames[i];
        P := Pos(Sub, SDate);
        if (P > 0) then
        begin
          Delete(SDate, P, Length(Sub));
          Insert(IntToStr(i), SDate, P);
          Break;
        end;
      end;
    end
    else
    begin
      if (Pos('MMM',Fmt) > 0) then
      begin //short monthnames
        for i := 1 to 12 do
        begin
          Sub := FS.ShortMonthNames[i];
          P := Pos(Sub, SDate);
          if (P > 0) then
          begin
            Delete(SDate, P, Length(Sub));
            Insert(IntToStr(i), SDate, P);
            Break;
          end;
        end;
      end;
    end;

    if (Pos('DDDD',Fmt) > 0) then
    begin  //long daynames
      //writeln('Literal daynames');
      for i := 1 to 7 do
      begin
        Sub := FS.LongDayNames[i];
        P := Pos(Sub, SDate);
        if (P > 0) then
        begin
          Delete(SDate, P, Length(Sub));
          Break;
        end;
      end;
    end
    else
    begin
      if (Pos('DDD',Fmt) > 0) then
      begin //short daynames
        for i := 1 to 7 do
        begin
          Sub := FS.ShortDayNames[i];
          P := Pos(Sub, SDate);
          if (P > 0) then
          begin
            Delete(SDate, P, Length(Sub));
            Break;
          end;
        end;
      end;
    end;
    SDate := Trim(SDate);
    //writeln('ReplaceLiterals -> ',SDate);
  end;

  procedure Split(out DStr, MStr, YStr: String);
  var
    i, P: Integer;
    Sep: Set of Char;
    Sub: String;
  begin
    DStr := '';
    MStr := '';
    YStr := '';
    Sep := [];
    for i :=  1 to Length(Fmt) do
      if not (Fmt[i] in Digits) then Sep := Sep + [Fmt[i]];
    //get fist part
    P := 1;
    while (P <= Length(SDate)) and (SDate[P] in Digits) do Inc(P);
    Sub := Copy(SDate, 1, P-1);
    Delete(SDate, 1, P);
    if (DPos = 1) then DStr := Sub else if (MPos = 1) then MStr := Sub else YStr := Sub;
    //get second part
    if (SDate = '') then Exit;
    while (Length(SDate) > 0) and (SDate[1] in Sep) do Delete(SDate, 1, 1);
    if (SDate = '') then Exit;
    P := 1;
    while (P <= Length(SDate)) and (SDate[P] in Digits) do Inc(P);
    Sub := Copy(SDate, 1, P-1);
    Delete(SDate, 1, P);
    if (DPos = 2) then DStr := Sub else if (MPos = 2) then MStr := Sub else YStr := Sub;
    //get thirdpart
    if (SDate = '') then Exit;
    while (Length(SDate) > 0) and (SDate[1] in Sep) do Delete(SDate, 1, 1);
    if (SDate = '') then Exit;
    Sub := SDate;
    if (DPos = 3) then DStr := Sub else if (MPos = 3) then MStr := Sub else YStr := Sub;
  end;

  procedure AdjustYear(var YY: Word);
  var
    CY, CM, CD: Word;
  begin
    DecodeDate(Date, CY, CM, CD);
    LY := CY Mod 100;
    CY := CY - LY;
    if ((YY - LY) <= 50) then
      YY := CY + YY
    else
      YY := CY + YY - 100;
  end;

begin
  Result := NullDate;  //assume failure
  if (Length(SDate) < 5) then Exit; //y-m-d is minimum we support
  Fmt := UpperCase(FS.ShortDateFormat); //only care about y,m,d so this will do
  GetPositions(DPos, MPos, YPos);
  ReplaceLiterals;
  if (not (SDate[1] in Digits)) or (not (SDate[Length(SDate)] in Digits)) then Exit;
  Split(Dstr, MStr, YStr);
  if not TryStrToInt(DStr, LD) or
     not TryStrToInt(Mstr, LM) or
     not TryStrToInt(YStr, LY) then Exit;
  DD := LD;
  MM := LM;
  YY := LY;
  if (YY < 100) and (Pos('YYYY', UpperCase(Fmt)) = 0) then
  begin
    AdjustYear(YY);
  end;
  if not TryEncodeDate(YY, MM, DD, Result) then
    Result := NullDate;
end;

function TDateEdit.TextToDate(AText: String; ADefault: TDateTime): TDateTime;
var
  FS: TFormatSettings;
begin
  if Assigned(FOnCustomDate) then
    FOnCustomDate(Self, AText);
  if (DateOrder = doNone) then
  begin
    FS := DefaultFormatSettings;
    if (FFreeDateFormat <> '') then
      FS.ShortDateFormat := FFreeDateFormat;
    if not TryStrToDate(AText, Result, FS) then
    begin
      Result := ParseDateNoPredefinedOrder(AText, FS);
      if (Result = NullDate) then Result := ADefault;
    end;
  end
  else
    Result := ParseDate(AText,DateOrder,ADefault)
end;

procedure TDateEdit.SetFreeDateFormat(AValue: String);
var
  D: TDateTime;
begin
  if FFreeDateFormat = AValue then Exit;
  if (Text <> '') and (FDateOrder = doNone) and (not (csDesigning in ComponentState)) then
  begin
    D := GetDate;
    FFreeDateFormat := AValue;
    SetDate(D); //will update the text
  end
  else
    FFreeDateFormat := AValue;
end;

function TDateEdit.GetDate: TDateTime;
var
  ADate: string;
  Def: TDateTime;
begin
  //debugln(['TDateEdit.GetDate: FDate = ',DateToStr(FDate)]);
  if (FDate = NullDate) and FDefaultToday then
    Def := SysUtils.Date
  else
    Def := FDate;
  ADate := Trim(Text);
  //if not DirectInput then FDate matches the Text, so no need to parse it
  if (ADate <> '') and DirectInput then
  begin
    Result := TextToDate(ADate, Def);
    FDate := Result;
  end
  else
    Result := Def;
end;

procedure TDateEdit.SetDate(Value: TDateTime);
begin
  FUpdatingDate := True;
  try
    if {not IsValidDate(Value) or }(Value = NullDate) then
    begin
      if DefaultToday then
        Value := SysUtils.Date
      else
        Value := NullDate;
    end;
    FDate := Value;
    Text := DateToText(FDate);
  finally
    FUpdatingDate := False;
  end;
end;

procedure TDateEdit.CalendarPopupReturnDate(Sender: TObject;
  const ADate: TDateTime);
var
  B: Boolean;
  D: TDateTime;
begin
  try
    B := True;
    D := ADate;
    if Assigned(FOnAcceptDate) then
      FOnAcceptDate(Self, D, B);
    if B then
      Self.Date := D;
  except
    on E:Exception do
      MessageDlg(E.Message, mtError, [mbOK], 0);
  end;
end;

procedure TDateEdit.CalendarPopupShowHide(Sender: TObject);
begin
  FDroppedDown := (Sender as TForm).Visible;
end;

procedure TDateEdit.SetDateOrder(const AValue: TDateOrder);
begin
  if FDateOrder=AValue then exit;
  FDateOrder:=AValue;
  SetDateMask;
end;

function TDateEdit.DateToText(Value: TDateTime): String;
var
  FS: TFormatSettings;
begin
  if Value = NullDate then
    Result := ''
  else
  begin
    if (FDateOrder = doNone) or (FFixedDateFormat = '') then
    begin
      FS := DefaultFormatSettings;
      if (FFreeDateFormat <> '') then
        FS.ShortDateFormat := FFreeDateFormat;
      Result := DateToStr(Value, FS)
    end
    else
      Result := FormatDateTime(FFixedDateFormat, Value)
  end;
end;

{ TTimeEdit }

function TTimeEdit.GetTime: TDateTime;
begin
  Result := FTime;
  if IsEmptyTime then begin
    if FDefaultNow then
      Result := TimeOf(Now);
  end else begin
    if Assigned(FOnCustomTime) then
      FOnCustomTime(Self, Result);
  end;
end;

function TTimeEdit.GetLayout: Boolean;
begin
  Result := FSimpleLayout;
end;

procedure TTimeEdit.SetLayout(AValue: Boolean);
begin
  FSimpleLayout := AValue;
end;

procedure TTimeEdit.SetTime(AValue: TDateTime);
var
  Output: String;
begin
  DateTimeToString(Output, DefaultFormatSettings.ShortTimeFormat, AValue);
  Text := Output;
  FTime := AValue;
  IsEmptyTime := False;
end;

procedure TTimeEdit.SetEmptyTime;
begin
  Text := EmptyStr;
  FTime := NullDate;
  IsEmptyTime := True;
end;

procedure TTimeEdit.TimePopupReturnTime(Sender: TObject; const ATime: TDateTime);
var
  AcceptResult: Boolean;
  ReturnedTime: TDateTime;
begin
  try
    AcceptResult := True;
    ReturnedTime := ATime;
    if Assigned(FOnAcceptTime) then
      FOnAcceptTime(Self, ReturnedTime, AcceptResult);
    if AcceptResult then
      Self.Time := ReturnedTime;
  except
    on E:Exception do
      MessageDlg(E.Message, mtError, [mbOK], 0);
  end;
end;

procedure TTimeEdit.TimePopupShowHide(Sender: TObject);
begin
  FDroppedDown := (Sender as TForm).Visible;
end;

procedure TTimeEdit.OpenTimePopup;
var
  PopupOrigin: TPoint;
  ATime: TDateTime;
begin
  ParseInput;
  PopupOrigin := ControlToScreen(Point(0, Height));
  ATime := GetTime;
  if ATime = NullDate then
    ATime := SysUtils.Time;
  ShowTimePopup(PopupOrigin, ATime, Self.DoubleBuffered, @TimePopupReturnTime, @TimePopupShowHide, FSimpleLayout);
end;

function TTimeEdit.TryParseInput(AInput: String; out ParseResult: TDateTime): Boolean;
begin
  AInput := Trim(AInput);
  if (Length(AInput) in [3..4]) and (not AnsiContainsStr(AInput, DefaultFormatSettings.TimeSeparator)) then begin
    Insert(DefaultFormatSettings.TimeSeparator, AInput, Length(AInput) - 1);
  end;
  Result := TryStrToTime(AInput, ParseResult);
end;

procedure TTimeEdit.ParseInput;
var
  TmpResult: TDateTime;
begin
  if Trim(Text) = EmptyStr then
    SetEmptyTime
  else if TryParseInput(Self.Text, TmpResult) then
    SetTime(TmpResult)
  else
    SetTime(FTime);
end;

function TTimeEdit.GetDefaultGlyph: TBitmap;
begin
  Result := TimeGlyph;
end;

function TTimeEdit.GetDefaultGlyphName: String;
begin
  Result := ResBtnTime;
end;

procedure TTimeEdit.ButtonClick;
begin
  inherited ButtonClick;
  OpenTimePopup;
end;

procedure TTimeEdit.EditDblClick;
begin
  inherited EditDblClick;
  OpenTimePopup;
end;

procedure TTimeEdit.EditEditingDone;
begin
  ParseInput;
  inherited EditEditingDone;
end;

constructor TTimeEdit.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  SetEmptyTime;
  FSimpleLayout := True;
end;

{ TCalcEdit }

function TCalcEdit.GetAsFloat: Double;
begin
  Result := StrToFloatDef(Trim(Text), 0.0);
end;

function TCalcEdit.GetAsInteger: Integer;
begin
  Result:=StrToIntDef(Text,0);
end;

function TCalcEdit.GetDefaultGlyph: TBitmap;
begin
  Result := CalcGlyph;
end;

function TCalcEdit.GetDefaultGlyphName: String;
begin
  Result := ResBtnCalculator;
end;

procedure TCalcEdit.SetAsFloat(const AValue: Double);
begin
  Text:=FloatToStr(AValue);
end;

procedure TCalcEdit.SetAsInteger(const AValue: Integer);
begin
  Text:=IntToStr(AValue);
end;

function TCalcEdit.TitleStored: boolean;
begin
  Result:=FDialogTitle<>rsCalculator;
end;

procedure TCalcEdit.ButtonClick;
begin
  inherited ButtonClick;
  RunDialog;
  //Do this after the dialog, otherwise it just looks silly
  if FocusOnButtonClick then FocusAndMaybeSelectAll;
end;

procedure TCalcEdit.RunDialog;
var
  D : Double;
  B : Boolean;
begin
  D:=AsFloat;
  with CreateCalculatorForm(Self,FCalculatorLayout,0) do
    try
      Caption:=DialogTitle;
      Value:=D;
      if (ShowModal=mrOK) then
      begin
        D:=Value;
        B:=True;
        If Assigned(FOnAcceptValue) then
          FOnAcceptValue(Self,D,B);
        if B then
          AsFloat:=D;
      end;
    finally
      Free;
    end;
end;

constructor TCalcEdit.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FdialogTitle:=rsCalculator;
end;


{procedure Register;
begin
  RegisterComponents('Misc', [TEditButton,TFileNameEdit,TDirectoryEdit,
                              TDateEdit,TTimeEdit,TCalcEdit]);
end;}

end.
