{----------------------------------------------------------------------------

This helped me out when creating wizards and I think it will help you.

Start off looking at the Sample.

You can use it anywhere and you don't even have to say my name anywhere.


Home Page
http://members.tripod.com/durkeehome/durkee.htm

Email
stevedurkee@yahoo.com

----------------------------------------------------------------------------
6/9/2003
Minor changes by Tony Maro and released as a Lazarus package
Changed filename to all lowercase for FPC 1.0 compatibility

----------------------------------------------------------------------------

TO USE:
Drop on a form, add tabs, configure each tab for the individual wizard pages
After done, you may wish to hide the tab display at the top of the notebook

Add a next and back button OUTSIDE the notebook for navigation
You can also add a header and info label outside the notebook and have the
notebook populate them from the HeaderCaption and InfoCaption strings.

If your wizard can be reused, be sure to reset the "NEXT" button caption
before next display as it will change to "Finish".

----------------------------------------------------------------------------}

unit WizardNotebook;

interface

uses
  SysUtils, Classes, Forms, LResources, Controls, Graphics, Dialogs,
  StdCtrls, ExtCtrls, buttons;

// Events
type TbtnBackClick = procedure (Sender: TObject) of object;
type TbtnNextClick = procedure (Sender: TObject; const FinalState: boolean) of object;

type
  TWizardNotebook = class(TNotebook)
  private
    { Private declarations }
    FbtnBackClick: TbtnBackClick;
    FbtnNextClick: TbtnNextClick;
    FbtnNext,
    FbtnBack: TButton;
    FlblHeader,
    FlblInfo: TLabel;
    FHeaderCaption,
    FInfoCaption: TStrings;

    procedure PHeaderCaption(Value: TStrings);
    procedure PInfoCaption(Value: TStrings);
    procedure PbtnBack(const Value: TButton);
    procedure PbtnNext(const Value: TButton);
    procedure PlblHeader(const Value: TLabel);
    procedure PlblInfo(const Value: TLabel);
  protected
    { Protected declarations }
    procedure btnBackClick(Sender: TObject);
    procedure btnNextClick(Sender: TObject);
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    { Published declarations }
    property btnNext: TButton
      read FbtnNext
      write PbtnNext;
    property btnBack: TButton
      read FbtnBack
      write PbtnBack;
    property lblHeader: TLabel
      read FlblHeader
      write PlblHeader;
    property lblInfo: TLabel
      read FlblInfo
      write PlblInfo;
    property HeaderCaption: TStrings
      read FHeaderCaption
      write PHeaderCaption;
    property InfoCaption: TStrings
      read FInfoCaption
      write PInfoCaption;

    // Events
    property OnButtonBackClick: TbtnBackClick
      read FbtnBackClick
      write FbtnBackClick;
    property OnButtonNextClick: TbtnNextClick
      read FbtnNextClick
      write FbtnNextClick;
  end;

procedure Register;

implementation

constructor TWizardNotebook.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  try
    FHeaderCaption := TStringList.Create;
    FInfoCaption := TStringList.Create;
  except
  end;

  // does not go to first page automatically
  
end;

destructor TWizardNotebook.Destroy;
begin
  FHeaderCaption.Free;
  FInfoCaption.Free;
  inherited Destroy;
end;

procedure TWizardNotebook.PbtnNext(const Value: TButton);
begin
  FbtnNext := Value;
  if not (csDesigning in ComponentState) then
  begin
    if FbtnNext <> nil then FbtnNext.OnClick := @btnNextClick;
    if (Pages.Count = 1) and (btnNext <> nil) then btnNext.Caption := '&Finish';
  end;
end;

procedure TWizardNotebook.PbtnBack(const Value: TButton);
begin
  FbtnBack := Value;
  if not (csDesigning in ComponentState) then
  begin
    if FbtnBack <> nil then FbtnBack.OnClick := @btnBackClick;
    if FbtnBack <> nil then FbtnBack.Visible := false;
  end;
end;

procedure TWizardNotebook.PlblHeader(const Value: TLabel);
begin
  FlblHeader := Value;
  if not (csDesigning in ComponentState) then
    if (FlblHeader <> nil) and (HeaderCaption.Count > 0) then FlblHeader.Caption := HeaderCaption.Strings[PageIndex];
end;

procedure TWizardNotebook.PlblInfo(const Value: TLabel);
begin
  FlblInfo := Value;
  if not (csDesigning in ComponentState) then
    if (FlblInfo <> nil) and (InfoCaption.Count > 0) then FlblInfo.Caption := InfoCaption.Strings[PageIndex];
end;

procedure TWizardNotebook.PHeaderCaption(Value: TStrings);
begin
  FHeaderCaption.Assign(Value);
end;

procedure TWizardNotebook.PInfoCaption(Value: TStrings);
begin
  FInfoCaption.Assign(Value);
end;

{-------------------------------------------------------------------------------
EVENTS
-------------------------------------------------------------------------------}
procedure TWizardNotebook.btnBackClick(Sender: TObject);
var OnFirstPage: boolean;
begin
  OnFirstPage := (PageIndex = 0);

  // only one page (Do NOT allow)
  if (Pages.Count = 1) Or (OnFirstPage) then
  begin
    if (btnBack <> nil) then btnBack.Visible := false;
  end
  // TWO .. N pages and not OnFirstPage  (Allow Move)
  else if not (OnFirstPage) then
  begin
    PageIndex := PageIndex - 1;
    if (lblHeader <> nil) and (HeaderCaption.Count >= (PageIndex - 1)) then lblHeader.Caption := HeaderCaption.Strings[PageIndex];
    if (lblInfo <> nil) and (InfoCaption.Count >= (PageIndex - 1)) then lblInfo.Caption := InfoCaption.Strings[PageIndex];
    if (btnNext <> nil) then btnNext.Caption := '&Next >>';
  end;

  // Check to see if on First page after move
  OnFirstPage := (PageIndex = 0);
  if (OnFirstPage) And (Pages.Count > 1) then
    if (btnBack <> nil) then btnBack.Visible := false;

  // -- Added check to see if event was assigned - Tony Maro
  if assigned(FBtnBackClick) then FbtnBackClick(Sender);
end;

procedure TWizardNotebook.btnNextClick(Sender: TObject);
var FinalState,
    OnLastPage: boolean;
begin

  OnLastPage := Pages.Count = (PageIndex + 1);

  // only one page (Do NOT allow)
  if (Pages.Count = 1) Or (OnLastPage) then
  begin
    FinalState := true;
  end
  // TWO .. N pages and not OnLastPage  (Allow Move)
  else if not (OnLastPage) then
  begin
    PageIndex := PageIndex + 1;
    if (lblHeader <> nil) and (HeaderCaption.Count >= (PageIndex + 1)) then lblHeader.Caption := HeaderCaption.Strings[PageIndex];
    if (lblInfo <> nil) and (InfoCaption.Count >= (PageIndex + 1)) then lblInfo.Caption := InfoCaption.Strings[PageIndex];
    if (btnBack <> nil) then btnBack.Visible := true;
  end;

  // Check to see if on Last page after move
  OnLastPage := Pages.Count = (PageIndex + 1);
  if (OnLastPage) And (btnNext <> nil) then btnNext.Caption := '&Finish';

  // -- Added check to see if event was assigned - Tony Maro
  if assigned(FBtnNextClick) then FbtnNextClick(Sender, FinalState);

end;

{-------------------------------------------------------------------------------
REGISTER
-------------------------------------------------------------------------------}
procedure Register;
begin
  RegisterComponents('CDC', [TWizardNotebook]);
end;

initialization
{$I twizardnotebook.lrs}

end.
