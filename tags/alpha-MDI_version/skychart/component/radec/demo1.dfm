object Form1: TForm1
  Left = 198
  Top = 103
  Width = 351
  Height = 202
  Caption = 'Form1'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Button1: TButton
    Left = 40
    Top = 80
    Width = 75
    Height = 25
    Caption = 'Button1'
    TabOrder = 0
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 192
    Top = 80
    Width = 75
    Height = 25
    Caption = 'Button2'
    TabOrder = 1
    OnClick = Button2Click
  end
  object RaDec1: TRaDec
    Left = 40
    Top = 32
    Width = 75
    Height = 21
    EditMask = '!99h99m99s;1; '
    MaxLength = 9
    TabOrder = 2
    Text = '00h00m00s'
    kind = RA
  end
  object RaDec2: TRaDec
    Left = 192
    Top = 32
    Width = 71
    Height = 21
    EditMask = '!##9d99m99s;1; '
    MaxLength = 10
    TabOrder = 3
    Text = '+10d30m00s'
    kind = DE
    value = 10.5
  end
end
