object Form1: TForm1
  Left = 192
  Top = 114
  Width = 696
  Height = 281
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
  object JDMonthlyCalendar1: TJDMonthlyCalendar
    Left = 400
    Top = 32
    Width = 234
    Height = 177
    BevelOuter = bvNone
    Caption = 'JDMonthlyCalendar1'
    TabOrder = 0
    JD = 2453462.500000000000000000
    Year = 2005
    Month = 4
    Day = 2
    OKBtnVisible = False
  end
  object JDDatePicker1: TJDDatePicker
    Left = 40
    Top = 32
    Width = 95
    Height = 21
    EditMask = '!999999.99.99;1; '
    MaxLength = 12
    TabOrder = 1
    Text = '  2005. 4. 2'
    JD = 2453462.500000000000000000
    Year = 2005
    Month = 4
    Day = 2
  end
  object Button1: TButton
    Left = 176
    Top = 32
    Width = 75
    Height = 25
    Caption = 'Button1'
    TabOrder = 2
    OnClick = Button1Click
  end
  object Edit1: TEdit
    Left = 40
    Top = 88
    Width = 121
    Height = 21
    TabOrder = 3
    Text = '2006'
  end
  object Edit2: TEdit
    Left = 40
    Top = 120
    Width = 121
    Height = 21
    TabOrder = 4
    Text = '7'
  end
  object Edit3: TEdit
    Left = 40
    Top = 152
    Width = 121
    Height = 21
    TabOrder = 5
    Text = '23'
  end
  object Edit4: TEdit
    Left = 40
    Top = 200
    Width = 121
    Height = 21
    TabOrder = 6
    Text = '1234567'
  end
  object Button2: TButton
    Left = 176
    Top = 88
    Width = 75
    Height = 25
    Caption = 'Button2'
    TabOrder = 7
    OnClick = Button2Click
  end
  object Button3: TButton
    Left = 176
    Top = 200
    Width = 75
    Height = 25
    Caption = 'Button3'
    TabOrder = 8
    OnClick = Button3Click
  end
  object Button4: TButton
    Left = 296
    Top = 24
    Width = 75
    Height = 25
    Caption = 'francais'
    TabOrder = 9
    OnClick = Button4Click
  end
end
