object Form1: TForm1
  Left = 192
  Top = 116
  Width = 664
  Height = 430
  Caption = 'Catalog Library Demo VCL'
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
    Top = 12
    Width = 61
    Height = 13
    Caption = 'Catalog Path'
  end
  object Label2: TLabel
    Left = 200
    Top = 12
    Width = 24
    Height = 13
    Caption = 'RA 1'
  end
  object Label3: TLabel
    Left = 288
    Top = 12
    Width = 24
    Height = 13
    Caption = 'RA 2'
  end
  object Label4: TLabel
    Left = 376
    Top = 12
    Width = 24
    Height = 13
    Caption = 'DE 1'
  end
  object Label5: TLabel
    Left = 464
    Top = 12
    Width = 24
    Height = 13
    Caption = 'DE 2'
  end
  object Memo1: TMemo
    Left = 8
    Top = 40
    Width = 633
    Height = 345
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Courier New'
    Font.Style = []
    Lines.Strings = (
      '   Demo to illustrate the use of the catalog library.'
      ''
      
        '   This demo use the Bright Stars Catalog that is include with t' +
        'he'
      '   base version of Cartes du Ciel.'
      '   The principle of use is the same for all the other catalogs.'
      ''
      
        '   Look at catalogues.pas for a detailed description of the func' +
        'tion.'
      
        '   The comment in this file are in French maybe I will change th' +
        'at'
      '   if I have enough time.'
      ''
      '   To use this demo :'
      ''
      '   -  Enter the full path for the BSC files'
      
        '   -  Enter the decimal coordinates RA1 and DE1 of the lower rig' +
        'th corner'
      
        '   -  Enter the decimal coordinates RA2 and DE2 of the upper lef' +
        't corner'
      
        '   -  Press the Search button to show all the stars between the ' +
        'two corner.'
      
        '   -  Beware to not select a too large area, the number of stars' +
        ' can break'
      '      the 64k limit of the memo component.'
      ''
      '   Note :   '
      
        '   This way to access the catalog do not provide facilities for ' +
        'a chart that'
      '   cross the RA origin, you have to manage this by yourself.'
      
        '   (i.e. for a chart from 23H to 1H you first get the stars from' +
        ' 23H to 24H'
      '   then from 0H to 1H).'
      
        '   Cartes du Ciel use the function InitCatWin() and OpenBSCwin()' +
        ' that manage'
      
        '   this probleme but are heavier to use. Look at the source code' +
        ' if you want'
      '   to use this function.')
    ParentFont = False
    ReadOnly = True
    ScrollBars = ssBoth
    TabOrder = 6
  end
  object Edit1: TEdit
    Left = 80
    Top = 8
    Width = 113
    Height = 21
    TabOrder = 0
    Text = 'D:\ciel\cat\bsc5'
  end
  object Button1: TButton
    Left = 560
    Top = 6
    Width = 75
    Height = 25
    Caption = 'Search'
    TabOrder = 5
    OnClick = Button1Click
  end
  object Edit2: TEdit
    Left = 232
    Top = 8
    Width = 49
    Height = 21
    TabOrder = 1
    Text = '19.5'
  end
  object Edit3: TEdit
    Left = 320
    Top = 8
    Width = 49
    Height = 21
    TabOrder = 3
    Text = '20.0'
  end
  object Edit4: TEdit
    Left = 408
    Top = 8
    Width = 49
    Height = 21
    TabOrder = 2
    Text = '15.0'
  end
  object Edit5: TEdit
    Left = 496
    Top = 8
    Width = 49
    Height = 21
    TabOrder = 4
    Text = '20.0'
  end
end
