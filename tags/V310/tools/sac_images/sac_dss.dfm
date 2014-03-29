object Form1: TForm1
  Left = 272
  Top = 110
  Width = 398
  Height = 301
  Caption = 'Form1'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 36
    Width = 62
    Height = 13
    Caption = 'SAC catalog:'
  end
  object Label2: TLabel
    Left = 8
    Top = 140
    Width = 32
    Height = 13
    Caption = 'Output'
  end
  object Label3: TLabel
    Left = 8
    Top = 72
    Width = 76
    Height = 13
    Caption = 'RealSky header'
  end
  object Label4: TLabel
    Left = 8
    Top = 108
    Width = 64
    Height = 13
    Caption = 'RealSky data'
  end
  object Button1: TButton
    Left = 96
    Top = 176
    Width = 75
    Height = 25
    Caption = 'Button1'
    TabOrder = 0
    OnClick = Button1Click
  end
  object Edit1: TEdit
    Left = 96
    Top = 32
    Width = 193
    Height = 21
    TabOrder = 1
    Text = 'D:\CIEL\Cat\sac'
  end
  object Edit2: TEdit
    Left = 96
    Top = 136
    Width = 193
    Height = 21
    TabOrder = 2
    Text = 'F:\realsky'
  end
  object Edit3: TEdit
    Left = 96
    Top = 68
    Width = 193
    Height = 21
    TabOrder = 3
    Text = 'D:\CIEL\Cat\Realsky\'
  end
  object Edit4: TEdit
    Left = 96
    Top = 104
    Width = 193
    Height = 21
    TabOrder = 4
    Text = 'D:\Realsky\'
  end
  object Edit5: TEdit
    Left = 96
    Top = 216
    Width = 193
    Height = 21
    Color = clBtnFace
    TabOrder = 5
  end
end
