object Form1: TForm1
  Left = 210
  Top = 232
  Width = 696
  Height = 480
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
  object Image1: TImage
    Left = 0
    Top = 0
    Width = 487
    Height = 446
    Align = alClient
    AutoSize = True
  end
  object Panel1: TPanel
    Left = 487
    Top = 0
    Width = 201
    Height = 446
    Align = alRight
    TabOrder = 0
    object Label1: TLabel
      Left = 16
      Top = 296
      Width = 75
      Height = 13
      Caption = 'Central meridian'
    end
    object Label2: TLabel
      Left = 16
      Top = 320
      Width = 30
      Height = 13
      Caption = 'Phase'
    end
    object Label3: TLabel
      Left = 16
      Top = 344
      Width = 66
      Height = 13
      Caption = 'Position angle'
    end
    object Label4: TLabel
      Left = 16
      Top = 368
      Width = 71
      Height = 13
      Caption = 'Pole inclination'
    end
    object Label5: TLabel
      Left = 16
      Top = 392
      Width = 69
      Height = 13
      Caption = 'Sun inclination'
    end
    object Label6: TLabel
      Left = 16
      Top = 416
      Width = 27
      Height = 13
      Caption = 'Zoom'
    end
    object Button1: TButton
      Left = 64
      Top = 240
      Width = 75
      Height = 25
      Caption = 'OK'
      TabOrder = 0
      OnClick = Button1Click
    end
    object RadioGroup1: TRadioGroup
      Left = 8
      Top = 8
      Width = 169
      Height = 217
      Caption = 'Planet'
      ItemIndex = 4
      Items.Strings = (
        'mercury'
        'venus'
        'moon'
        'mars'
        'jupiter'
        'saturn'
        'uranus'
        'neptune'
        'pluto'
        'sun')
      TabOrder = 1
    end
    object Edit1: TEdit
      Left = 120
      Top = 292
      Width = 65
      Height = 21
      TabOrder = 2
      Text = '0'
    end
    object Edit2: TEdit
      Left = 120
      Top = 316
      Width = 65
      Height = 21
      TabOrder = 3
      Text = '0'
    end
    object Edit3: TEdit
      Left = 120
      Top = 340
      Width = 65
      Height = 21
      TabOrder = 4
      Text = '0'
    end
    object Edit4: TEdit
      Left = 120
      Top = 364
      Width = 65
      Height = 21
      TabOrder = 5
      Text = '30'
    end
    object Edit5: TEdit
      Left = 120
      Top = 388
      Width = 65
      Height = 21
      TabOrder = 6
      Text = '30'
    end
    object Edit6: TEdit
      Left = 120
      Top = 412
      Width = 65
      Height = 21
      TabOrder = 7
      Text = '1'
    end
  end
end
