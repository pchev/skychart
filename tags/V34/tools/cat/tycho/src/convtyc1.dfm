object Form1: TForm1
  Left = 165
  Top = 202
  Caption = 'Tycho Catalogue conversion utility'
  ClientHeight = 331
  ClientWidth = 505
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = True
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 32
    Top = 52
    Width = 155
    Height = 13
    Caption = 'Path to original file : tyc_main.dat'
  end
  object Label2: TLabel
    Left = 112
    Top = 92
    Width = 80
    Height = 13
    Caption = 'Destination path '
  end
  object Label3: TLabel
    Left = 56
    Top = 132
    Width = 137
    Height = 13
    Caption = 'Number of stars : zone / total'
  end
  object Label5: TLabel
    Left = 56
    Top = 16
    Width = 383
    Height = 16
    Caption = 
      'I/239           The Tycho Catalogue                    (ESA 1997' +
      ')'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label6: TLabel
    Left = 16
    Top = 200
    Width = 488
    Height = 137
    AutoSize = False
    Caption = 
      'This program convert the Tycho Catalogue for use with "Cartes du' +
      ' Ciel" / "Sky Charts" program.'#13#10'In the first field enter the com' +
      'plete directory path where you put the file tyc_main.dat of the ' +
      'original catalog ( keep this file in Unix fomat, do NOT convert ' +
      'it in cr+lf format). '#13#10'In the second field enter the path where ' +
      'to install the converted catalog, I suggest you keep the default' +
      ': <Sky Chart path>\cat\tycho'#13#10'You must have 25 MB free disk spac' +
      'e on the destination directory.'#13#10'Press "Conversion" key and be p' +
      'atient... there are 732 files and 1'#39'058'#39'332 stars. This may take' +
      ' from ten minutes to more than one hour, depending on your machi' +
      'ne. '#13#10'When it finish press *Exit" key.'
    WordWrap = True
  end
  object Button1: TButton
    Left = 216
    Top = 160
    Width = 75
    Height = 25
    Caption = 'Conversion'
    TabOrder = 0
    OnClick = Button1Click
  end
  object Edit1: TEdit
    Left = 216
    Top = 48
    Width = 225
    Height = 21
    TabOrder = 1
    Text = 'C:\temp'
  end
  object Edit2: TEdit
    Left = 216
    Top = 88
    Width = 225
    Height = 21
    TabOrder = 2
    Text = 'C:\ciel\cat\tycho'
  end
  object Edit3: TEdit
    Left = 216
    Top = 128
    Width = 105
    Height = 21
    TabOrder = 3
  end
  object Button2: TButton
    Left = 344
    Top = 160
    Width = 75
    Height = 25
    Caption = 'Exit'
    TabOrder = 4
    OnClick = Button2Click
  end
  object Edit4: TEdit
    Left = 336
    Top = 128
    Width = 105
    Height = 21
    TabOrder = 5
  end
end