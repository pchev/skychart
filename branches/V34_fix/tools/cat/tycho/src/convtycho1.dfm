object Form1: TForm1
  Left = 235
  Top = 34
  Caption = 'Form1'
  ClientHeight = 159
  ClientWidth = 363
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = True
  PixelsPerInch = 96
  TextHeight = 13
  object Button1: TButton
    Left = 280
    Top = 48
    Width = 75
    Height = 25
    Caption = 'Insert'
    TabOrder = 0
    OnClick = Button1Click
  end
  object Edit1: TEdit
    Left = 16
    Top = 48
    Width = 225
    Height = 21
    TabOrder = 1
    Text = 'E:'
  end
  object Edit2: TEdit
    Left = 16
    Top = 88
    Width = 225
    Height = 21
    TabOrder = 2
    Text = 'D:\appli\astro\tycho'
  end
end