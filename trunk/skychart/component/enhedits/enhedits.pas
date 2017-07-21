{*******************************************************
                Enhanced Edits [EnhEdits unit]

--------------------------------------------------------------

Change by P. Chevalley

December 2005 : Lazarus port, right alignement and focus not supported

November 25 2002 :
Linux port
   Remove D16 support TRealEdit
   change CMexit message to OnExit event
   May 5 2005: Change TRightEdit ancestor to TCustomEdit on Linux to avoid strange cursor behavior.

Remove DsgnIntf dependency

Add automatic hint's with mini-maxi values
--------------------------------------------------------------

This unit contains the code for 4 enhanced edits. TRightEdit,
TLongEdit, TRealEdit and TFloatEdit. TRightEdit is the base
class for the other three and is written by Dr. Bob and
released to the public domain in Issue three of the Delphi
Magazine. Thanks Dr Bob!! (Note: I have not registered the
TRightEdit because I don''t have a use for it right now. If
you want to register it just include a line in the register
procedure and include a bit map in EnhEdits.dcr)

These edits, especially TRealEdit, were written to improve the
already rich VCL. When Dr. Bob published his right aligned edit
I re-wrote these edits as decendents of the TRightEdit which I
feel completed the suite.

TLongEdit allows Setting the unpublished Text property via a
LongInt Value property. In addition there are AsString, AsInteger,
AsWord and AsByte methods for runtime convenience.

TRealEdit Gets and Sets the unpublished Text property via a
TRealStr Value property. The input is checked for validity as
a real before acceptance. Why do this?? The object inspector will
not allow the use of reals so machines, like one of mine, without
the 80x87 coprocessor can''t Set or Get floating point values at
design time. Therefore, the TRealProperty property editor should
be useful in many situations.

TFloatEdit is an editor for machines with the80x87 coprocessor.
With TFloatEdit you can use anything up to type extended. For
convenience, there are AsString, AsSingle, AsDouble and AsReal
methods.

I hope you find this code useful. If you make improvements please
e-mail me a copy. Enjoy.

                Paul Warren
       HomeGrown Software Development
     (c) 1995 Langley British Columbia.
              (604) 530-9097
       e-mail:  hg_soft@uniserve.com
  Home page: http://users.uniserve.com/~hg_soft

********************************************************}

{$mode objfpc}{$H+}

unit enhedits;

interface

uses
  SysUtils, Classes, LResources, Controls, StdCtrls;

type
  TRightEdit = class(TCustomEdit)
  private
    { Private declarations }
  protected
    { Protected declarations }
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    procedure SetBounds(ALeft, ATop, AWidth, AHeight: integer); override;
  published
    { Published declarations }
    property BorderStyle;
    property Color;
    property Cursor;
    property DragMode;
    property Enabled;
    property Font;
    property Height;
    property HelpContext;
    property Hint;
    property Left;
    property MaxLength;
    property Name;
    property ParentColor;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ReadOnly;
    property ShowHint;
    property TabOrder;
    property Tag;
    property Top;
    property Visible;
    property Width;
    property OnChange;
    property OnClick;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDrag;
    property OnEnter;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property CharCase;
    property DragCursor;
  end;

  TLongEdit = class(TRightEdit)
  private
    { Private declarations }
    FOnExit: TNotifyEvent;
    FValue: longint;
    FMinValue: longint;
    FMaxValue: longint;
    procedure SetValue(Val: longint);
    function GetValue: longint;
    function CheckValue(NewValue: longint): longint;
    procedure SetMaxValue(NewValue: longint);
    procedure SetMinValue(NewValue: longint);
    procedure SetAsString(NewValue: string);
    function GetAsString: string;
    procedure SetAsInteger(NewValue: integer);
    function GetAsInteger: integer;
    procedure SetAsWord(NewValue: word);
    function GetAsWord: word;
    procedure SetAsByte(NewValue: byte);
    function GetAsByte: byte;
    procedure FormatText;
    procedure CMonExit(Sender: TObject);
  protected
    { Protected declarations }
    procedure KeyPress(var Key: char); override;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    property AsString: string read GetAsString write SetAsString;
    property AsInteger: integer read GetAsInteger write SetAsInteger;
    property AsWord: word read GetAsWord write SetAsWord;
    property AsByte: byte read GetAsByte write SetAsByte;
  published
    { Published declarations }
    property Value: longint read GetValue write SetValue;
    property MinValue: longint read FMinValue write SetMinValue default 0;
    property MaxValue: longint read FMaxValue write SetMaxValue default 0;
    property OnExit: TNotifyEvent read FOnExit write FOnExit;
  end;

  TNumericType = (ntGeneral, ntExponent, ntFixed);

  TFloatEdit = class(TRightEdit)
  private
    { Private declarations }
    FOnExit: TNotifyEvent;
    FValue: extended;
    FDecimals: word;
    FMinValue: extended;
    FMaxValue: extended;
    FDigits: word;
    FNumericType: TNumericType;
    procedure SetValue(Val: extended);
    function GetValue: extended;
    procedure SetMaxValue(NewValue: extended);
    procedure SetMinValue(NewValue: extended);
    function CheckValue(NewValue: extended): extended;
    procedure SetDecimals(NewValue: word);
    procedure SetDigits(NewValue: word);
    procedure SetNumericType(Val: TNumericType);
    procedure SetAsString(NewValue: string);
    function GetAsString: string;
    procedure SetAsDouble(NewValue: double);
    function GetAsDouble: double;
    procedure SetAsSingle(NewValue: single);
    function GetAsSingle: single;
    procedure SetAsReal(NewValue: real);
    function GetAsReal: real;
    procedure FormatText;
    procedure CMonExit(Sender: TObject);
  protected
    { Protected declarations }
    procedure KeyPress(var Key: char); override;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    property AsString: string read GetAsString write SetAsString;
    property AsDouble: double read GetAsDouble write SetAsDouble;
    property AsSingle: single read GetAsSingle write SetAsSingle;
    property AsReal: real read GetAsReal write SetAsReal;
  published
    { Published declarations }
    property Value: extended read GetValue write SetValue;
    property Decimals: word read FDecimals write SetDecimals default 1;
    property MinValue: extended read FMinValue write SetMinValue;
    property MaxValue: extended read FMaxValue write SetMaxValue;
    property Digits: word read FDigits write SetDigits default 12;
    property NumericType: TNumericType
      read FNumericType write SetNumericType default ntGeneral;
    property OnExit: TNotifyEvent read FOnExit write FOnExit;
  end;

procedure Register;

implementation

constructor TRightEdit.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Align := alNone;
  //  Alignment := taRightJustify;
end;

procedure TRightEdit.SetBounds(ALeft, ATop, AWidth, AHeight: integer);
begin
  //  if AHeight > (2 * abs(Font.Height)) then AHeight := 2 * abs(Font.Height);
  inherited SetBounds(ALeft, ATop, AWidth, AHeight);
end;

{ Construct the TLongEdit }
constructor TLongEdit.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FMinValue := 0;
  FMaxValue := 0;
  FValue := 0;
  Text := '0';
  FOnExit := nil;
  inherited onExit := @CMonExit;
end;

{ Set the unpublished Text property to its string
  representation. Check the value is in range. }
procedure TLongEdit.SetValue(Val: longint);
begin
  FValue := Val;
  FormatText;
end;

{ Get the Text property as a LongInt by converting
  from its string representation. }
function TLongEdit.GetValue: longint;
begin
  FValue := StrToIntDef(Text, 0);
  Result := CheckValue(FValue);
end;

{ Method to set the FMinValue property, check that
  Value is still in range and update the Text }
procedure TLongEdit.SetMinValue(NewValue: longint);
begin
  if FMinValue <> NewValue then
  begin
    FMinValue := NewValue;
    //    if FMinValue > FMaxValue then FMinValue := FMaxValue;
    if FValue < FMinValue then
      FValue := FMinValue;
    FormatText;
  end;
  if MinValue <> MaxValue then
  begin
    hint := IntToStr(MinValue) + '..' + IntToStr(MaxValue);
    ShowHint := True;
  end
  else
  begin
    hint := '';
    ShowHint := False;
  end;
end;

{ Method to set the FMaxValue property, check that
  Value is still in range and update the Text }
procedure TLongEdit.SetMaxValue(NewValue: longint);
begin
  if FMaxValue <> NewValue then
  begin
    FMaxValue := NewValue;
    //    if FMaxValue < FMinValue then FMaxValue := FMinValue;
    if FValue > FMaxValue then
      FValue := FMaxValue;
    FormatText;
  end;
  if MinValue <> MaxValue then
  begin
    hint := IntToStr(MinValue) + '..' + IntToStr(MaxValue);
    ShowHint := True;
  end
  else
  begin
    hint := '';
    ShowHint := False;
  end;
end;

{ Function to check the Value property is in range
  Min < Value < Max. }
function TLongEdit.CheckValue(NewValue: longint): longint;
begin
  Result := NewValue;
  if (FMaxValue <> FMinValue) then
  begin
    if NewValue < FMinValue then
      Result := FMinValue
    else
    if NewValue > FMaxValue then
      Result := FMaxValue;
  end;
end;

{ Method to update the Text property }
procedure TLongEdit.FormatText;
var
  L: longint;
begin
  L := FValue;
  Text := IntToStr(L);
end;

{ Method to get Value as a string }
function TLongEdit.GetAsString: string;
begin
  Result := Text;
end;

{ Method to Set Value as a string }
procedure TLongEdit.SetAsString(NewValue: string);
begin
  FValue := CheckValue(StrToIntDef(NewValue, 0));
  FormatText;
end;

{ Method to get Value as an integer }
function TLongEdit.GetAsInteger: integer;
const
  MaxInteger: integer = 32767;
  MinInteger: integer = -32768;
begin
  Result := 0;
  if (Text <> '') and not (Text = '-') then
    FValue := StrToIntDef(Text, 0);
  if (FValue <= MaxInteger) and (FValue >= MinInteger) then
    Result := FValue;
end;

{ Method to Set Value as an integer }
procedure TLongEdit.SetAsInteger(NewValue: integer);
begin
  FValue := NewValue;
  FormatText;
end;

{ Method to get Value as a word }
function TLongEdit.GetAsWord: word;
const
  MaxWord: word = 65535;
  MinWord: word = 0;
begin
  Result := 0;
  if (Text <> '') and not (Text = '-') then
    FValue := StrToIntDef(Text, 0);
  if (FValue <= MaxWord) and (FValue >= MinWord) then
    Result := word(FValue);
end;

{ Method to Set Value as a word }
procedure TLongEdit.SetAsWord(NewValue: word);
begin
  FValue := NewValue;
  FormatText;
end;

{ Method to get Value as a byte }
function TLongEdit.GetAsByte: byte;
const
  MaxByte: byte = 255;
  MinByte: byte = 0;
begin
  Result := 0;
  if (Text <> '') and not (Text = '-') then
    FValue := StrToIntDef(Text, 0);
  if (FValue <= MaxByte) and (FValue >= MinByte) then
    Result := byte(FValue);
end;

{ Method to Set Value as a byte }
procedure TLongEdit.SetAsByte(NewValue: byte);
begin
  FValue := NewValue;
  FormatText;
end;

{ Check the Value property is in range before allowing
  user to exit the edit.  }
//procedure TLongEdit.CMExit(var Message: TCMExit);
procedure TLongEdit.CMonExit(Sender: TObject);
var
  L: longint;
begin
  L := StrToIntDef(Text, 0);
  if ((FMinValue <> 0) or (FMaxValue <> 0)) and ((L > FMaxValue) or (L < FMinValue)) then
  begin
    if L > FMaxValue then
      Text := IntToStr(FMaxValue);
    if L < FMinValue then
      Text := IntToStr(FMinValue);
    Beep;
    SelectAll;
    SetFocus;
  end
  else
  begin
    Text := IntToStr(L);
    FValue := L;
    //    inherited;
    if Assigned(FOnExit) then
      FOnExit(Sender);
  end;
end;

{ Don't accept invalid characters }
procedure TLongEdit.KeyPress(var Key: char);
begin
  if Key in ['0'..'9', '-', #0 .. #20] then
    inherited KeyPress(Key)
  else
  begin
    Key := #0;
    Beep;
  end;
end;

{ Construct the TFloatEdit }
constructor TFloatEdit.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FDecimals := 1;
  FDigits := 12;
  FValue := 0.0;
  FMinValue := 0;
  FMaxValue := 0;
  Text := '0.0';
  FOnExit := nil;
  inherited onExit := @CMonExit;
end;

{ Check the Value property is in range before allowing
  user to exit the edit.  }
procedure TFloatEdit.CMonExit(Sender: TObject);
var
  L: double;
begin
  L := GetAsDouble;
  if ((FMinValue <> 0) or (FMaxValue <> 0)) and ((L > FMaxValue) or (L < FMinValue)) then
  begin
    Beep;
    SelectAll;
    SetFocus;
  end
  else
  begin
    FValue := L;
    inherited;
    if Assigned(FOnExit) then
      FOnExit(Sender);
  end;
end;

{ Set the unpublished Text property to its string
  representation. Check the value is in range. }
procedure TFloatEdit.SetValue(Val: extended);
begin
  FValue := Val;
  FormatText;
end;

{ Get the Text property as a Floating type by
  converting from its string representation. }
function TFloatEdit.GetValue: extended;
begin
  try
    if Text = '' then
      FValue := 0
    else
      FValue := StrToFloatDef(Text, 0);
    Result := CheckValue(FValue);
  except
    FValue := 0;
    Result := CheckValue(FValue);
  end;
end;

{ Method to set the FMinValue property, check that
  Value is still in range and update the Text }
procedure TFloatEdit.SetMinValue(NewValue: extended);
begin
  if FMinValue <> NewValue then
  begin
    FMinValue := NewValue;
    //    if FMinValue > FMaxValue then FMinValue := FMaxValue;
    if FValue < FMinValue then
      FValue := FMinValue;
    FormatText;
  end;
  if MinValue <> MaxValue then
  begin
    hint := floattostr(MinValue) + '..' + floattostr(MaxValue);
    ShowHint := True;
  end
  else
  begin
    hint := '';
    ShowHint := False;
  end;
end;

{ Method to set the FMaxValue property, check that
  Value is still in range and update the Text }
procedure TFloatEdit.SetMaxValue(NewValue: extended);
begin
  if FMaxValue <> NewValue then
  begin
    FMaxValue := NewValue;
    //    if FMaxValue < FMinValue then FMaxValue := FMinValue;
    if FValue > FMaxValue then
      FValue := FMaxValue;
    FormatText;
  end;
  if MinValue <> MaxValue then
  begin
    hint := floattostr(MinValue) + '..' + floattostr(MaxValue);
    ShowHint := True;
  end
  else
  begin
    hint := '';
    ShowHint := False;
  end;
end;

{ Function to check the Value property is in range
  Min < Value < Max. }
function TFloatEdit.CheckValue(NewValue: extended): extended;
begin
  Result := NewValue;
  if (FMaxValue <> FMinValue) then
  begin
    if NewValue < FMinValue then
      Result := FMinValue
    else
    if NewValue > FMaxValue then
      Result := FMaxValue;
  end;
end;

{ Method to set FDecimal property. }
procedure TFloatEdit.SetDecimals(NewValue: word);
begin
  if FDecimals <> NewValue then
  begin
    FDecimals := NewValue;
    FormatText;
  end;
end;

procedure TFloatEdit.SetDigits(NewValue: word);
begin
  if FDigits <> NewValue then
  begin
    FDigits := NewValue;
    FormatText;
  end;
end;

procedure TFloatEdit.SetNumericType(Val: TNumericType);
begin
  if FNumericType <> Val then
  begin
    FNumericType := Val;
    FormatText;
  end;
end;

{ Method to get Value as a string }
function TFloatEdit.GetAsString: string;
begin
  Result := Text;
end;

{ Method to Set Value as a string }
procedure TFloatEdit.SetAsString(NewValue: string);
begin
  FValue := CheckValue(StrToFloatDef(NewValue, 0));
  FormatText;
end;

{ Method to get Value as a double }
function TFloatEdit.GetAsDouble: double;
const
  MaxDouble: double = 1.7E308;
  MinDouble: double = -1.7E308;
begin
  Result := 0;
  if (Text <> '') and not (Text = '-') then
    FValue := StrToFloatDef(Text, 0);
  if (FValue <= MaxDouble) and (FValue >= MinDouble) then
    Result := double(FValue);
end;

{ Method to Set Value as a double }
procedure TFloatEdit.SetAsDouble(NewValue: double);
begin
  FValue := NewValue;
  FormatText;
end;

{ Method to get Value as a single }
function TFloatEdit.GetAsSingle: single;
const
  MaxSingle: single = 3.4E38;
  MinSingle: single = -3.4E38;
begin
  Result := 0;
  if (Text <> '') and not (Text = '-') then
    FValue := StrToFloatDef(Text, 0);
  if (FValue <= MaxSingle) and (FValue >= MinSingle) then
    Result := single(FValue);
end;

{ Method to Set Value as a single }
procedure TFloatEdit.SetAsSingle(NewValue: single);
begin
  FValue := NewValue;
  FormatText;
end;

{ Method to get Value as a real }
function TFloatEdit.GetAsReal: real;
const
  MaxReal: real = 1.7E38;
  MinReal: real = -1.7E38;
begin
  Result := 0;
  if (Text <> '') and not (Text = '-') then
    FValue := StrToFloatDef(Text, 0);
  if (FValue <= MaxReal) and (FValue >= MinReal) then
    Result := real(FValue);
end;

{ Method to Set Value as a real }
procedure TFloatEdit.SetAsReal(NewValue: real);
begin
  FValue := NewValue;
  FormatText;
end;

procedure TFloatEdit.FormatText;
var
  X: extended;
begin
  X := FValue;
  case FNumericType of
    ntGeneral: Text := FloatToStrF(X, ffGeneral, FDigits, FDecimals);
    ntExponent: Text := FloatToStrF(X, ffExponent, FDigits, FDecimals);
    ntFixed: Text := FloatToStrF(X, ffFixed, FDigits, FDecimals);
  end;
end;

{ Don't accept invalid characters }
procedure TFloatEdit.KeyPress(var Key: char);
begin
  if Key in ['0'..'9', '-', '+', 'e', 'E', DefaultFormatSettings.DecimalSeparator,
    #0 .. #20] then
    inherited KeyPress(Key)
  else
  begin
    Key := #0;
    Beep;
  end;
end;

{ Register the property editor to apply to all types
  TRealStr in all components regardless of the
  property name }

{ Register all the edits }
procedure Register;
begin
  RegisterComponents('CDC', [TLongEdit]);
  RegisterComponents('CDC', [TFloatEdit]);
  //  RegisterComponents('CDC', [TRightEdit]);
end;

initialization
  {$I enhedit.lrs}

end.
