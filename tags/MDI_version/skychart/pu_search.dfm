object f_search: Tf_search
  Left = 193
  Top = 133
  BorderStyle = bsToolWindow
  Caption = 'Search'
  ClientHeight = 326
  ClientWidth = 433
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object PlanetPanel: TPanel
    Left = 7
    Top = 232
    Width = 416
    Height = 41
    TabOrder = 4
    object Label2: TLabel
      Left = 13
      Top = 14
      Width = 33
      Height = 13
      Caption = 'Planet '
    end
    object PlanetBox: TComboBox
      Left = 88
      Top = 11
      Width = 114
      Height = 21
      ItemHeight = 13
      TabOrder = 0
    end
  end
  object NebNamePanel: TPanel
    Left = 7
    Top = 232
    Width = 416
    Height = 41
    TabOrder = 5
    object Label3: TLabel
      Left = 13
      Top = 14
      Width = 34
      Height = 13
      Caption = 'Nebula'
    end
    object NebNameBox: TComboBox
      Left = 88
      Top = 11
      Width = 296
      Height = 21
      ItemHeight = 13
      TabOrder = 0
    end
  end
  object StarNamePanel: TPanel
    Left = 7
    Top = 232
    Width = 416
    Height = 41
    TabOrder = 6
    object Label4: TLabel
      Left = 13
      Top = 14
      Width = 19
      Height = 13
      Caption = 'Star'
    end
    object StarNameBox: TComboBox
      Left = 88
      Top = 11
      Width = 290
      Height = 21
      ItemHeight = 13
      TabOrder = 0
    end
  end
  object ConstPanel: TPanel
    Left = 7
    Top = 232
    Width = 416
    Height = 41
    TabOrder = 7
    object Label5: TLabel
      Left = 13
      Top = 14
      Width = 60
      Height = 13
      Caption = 'Constellation'
    end
    object ConstBox: TComboBox
      Left = 88
      Top = 11
      Width = 290
      Height = 21
      ItemHeight = 13
      TabOrder = 0
    end
  end
  object IDPanel: TPanel
    Left = 7
    Top = 232
    Width = 416
    Height = 41
    TabOrder = 0
    object Label1: TLabel
      Left = 8
      Top = 14
      Width = 62
      Height = 13
      Caption = 'Object Name'
    end
    object DblPanel: TPanel
      Left = 210
      Top = 1
      Width = 73
      Height = 39
      TabOrder = 5
      object SpeedButton30: TSpeedButton
        Left = 0
        Top = 2
        Width = 36
        Height = 18
        Caption = 'ADS'
        OnClick = CatButtonClick
      end
      object SpeedButton31: TSpeedButton
        Left = 36
        Top = 2
        Width = 36
        Height = 18
        Caption = 'STF'
        OnClick = CatButtonClick
      end
    end
    object VarPanel: TPanel
      Left = 210
      Top = 1
      Width = 73
      Height = 39
      TabOrder = 4
      object SpeedButton21: TSpeedButton
        Left = 0
        Top = 2
        Width = 18
        Height = 18
        Caption = 'R'
        OnClick = NumButtonClick
      end
      object SpeedButton24: TSpeedButton
        Left = 18
        Top = 2
        Width = 18
        Height = 18
        Caption = 'S'
        OnClick = NumButtonClick
      end
      object SpeedButton25: TSpeedButton
        Left = 0
        Top = 20
        Width = 18
        Height = 18
        Caption = 'V'
        OnClick = NumButtonClick
      end
      object SpeedButton26: TSpeedButton
        Left = 36
        Top = 20
        Width = 36
        Height = 18
        Caption = 'NSV'
        OnClick = CatButtonClick
      end
      object SpeedButton27: TSpeedButton
        Left = 36
        Top = 2
        Width = 18
        Height = 18
        Caption = 'T'
        OnClick = NumButtonClick
      end
      object SpeedButton28: TSpeedButton
        Left = 54
        Top = 2
        Width = 18
        Height = 18
        Caption = 'U'
        OnClick = NumButtonClick
      end
      object SpeedButton29: TSpeedButton
        Left = 18
        Top = 20
        Width = 18
        Height = 18
        Caption = 'W'
        OnClick = NumButtonClick
      end
    end
    object StarPanel: TPanel
      Left = 210
      Top = 1
      Width = 73
      Height = 39
      TabOrder = 3
      object SpeedButton19: TSpeedButton
        Left = 0
        Top = 2
        Width = 36
        Height = 18
        Caption = 'TYC'
        OnClick = CatButtonClick
      end
      object SpeedButton20: TSpeedButton
        Left = 36
        Top = 2
        Width = 36
        Height = 18
        Caption = 'GSC'
        OnClick = CatButtonClick
      end
      object SpeedButton22: TSpeedButton
        Left = 0
        Top = 20
        Width = 36
        Height = 18
        Caption = 'HD'
        OnClick = CatButtonClick
      end
      object SpeedButton23: TSpeedButton
        Left = 36
        Top = 20
        Width = 36
        Height = 18
        Caption = 'BD'
        OnClick = CatButtonClick
      end
    end
    object Id: TEdit
      Left = 88
      Top = 10
      Width = 113
      Height = 21
      TabOrder = 0
      OnKeyDown = IdKeyDown
    end
    object NumPanel: TPanel
      Left = 288
      Top = 1
      Width = 128
      Height = 39
      BevelOuter = bvNone
      TabOrder = 1
      object SpeedButton1: TSpeedButton
        Left = 0
        Top = 2
        Width = 18
        Height = 18
        Caption = '1'
        OnClick = NumButtonClick
      end
      object SpeedButton2: TSpeedButton
        Left = 18
        Top = 2
        Width = 18
        Height = 18
        Caption = '2'
        OnClick = NumButtonClick
      end
      object SpeedButton3: TSpeedButton
        Left = 36
        Top = 2
        Width = 18
        Height = 18
        Caption = '3'
        OnClick = NumButtonClick
      end
      object SpeedButton4: TSpeedButton
        Left = 54
        Top = 2
        Width = 18
        Height = 18
        Caption = '4'
        OnClick = NumButtonClick
      end
      object SpeedButton5: TSpeedButton
        Left = 72
        Top = 2
        Width = 18
        Height = 18
        Caption = '5'
        OnClick = NumButtonClick
      end
      object SpeedButton6: TSpeedButton
        Left = 0
        Top = 20
        Width = 18
        Height = 18
        Caption = '6'
        OnClick = NumButtonClick
      end
      object SpeedButton7: TSpeedButton
        Left = 18
        Top = 20
        Width = 18
        Height = 18
        Caption = '7'
        OnClick = NumButtonClick
      end
      object SpeedButton8: TSpeedButton
        Left = 36
        Top = 20
        Width = 18
        Height = 18
        Caption = '8'
        OnClick = NumButtonClick
      end
      object SpeedButton9: TSpeedButton
        Left = 54
        Top = 20
        Width = 18
        Height = 18
        Caption = '9'
        OnClick = NumButtonClick
      end
      object SpeedButton10: TSpeedButton
        Left = 72
        Top = 20
        Width = 18
        Height = 18
        Caption = '0'
        OnClick = NumButtonClick
      end
      object SpeedButton11: TSpeedButton
        Left = 90
        Top = 2
        Width = 18
        Height = 18
        Caption = '<-'
        OnClick = SpeedButton11Click
      end
      object SpeedButton12: TSpeedButton
        Left = 90
        Top = 20
        Width = 36
        Height = 18
        Caption = ' '
        OnClick = NumButtonClick
      end
      object SpeedButton13: TSpeedButton
        Left = 108
        Top = 2
        Width = 18
        Height = 18
        Caption = 'C'
        OnClick = SpeedButton13Click
      end
    end
    object NebPanel: TPanel
      Left = 210
      Top = 1
      Width = 73
      Height = 39
      TabOrder = 2
      object SpeedButton14: TSpeedButton
        Left = 0
        Top = 2
        Width = 18
        Height = 18
        Caption = 'M'
        OnClick = CatButtonClick
      end
      object SpeedButton15: TSpeedButton
        Left = 18
        Top = 2
        Width = 36
        Height = 18
        Caption = 'NGC'
        OnClick = CatButtonClick
      end
      object SpeedButton16: TSpeedButton
        Left = 54
        Top = 2
        Width = 18
        Height = 18
        Caption = 'IC'
        OnClick = CatButtonClick
      end
      object SpeedButton17: TSpeedButton
        Left = 0
        Top = 20
        Width = 36
        Height = 18
        Caption = 'PGC'
        OnClick = CatButtonClick
      end
      object SpeedButton18: TSpeedButton
        Left = 36
        Top = 20
        Width = 36
        Height = 18
        Caption = 'PK'
        OnClick = CatButtonClick
      end
    end
  end
  object RadioGroup1: TRadioGroup
    Left = 7
    Top = 8
    Width = 416
    Height = 217
    Caption = 'Search for '
    Columns = 2
    ItemIndex = 0
    Items.Strings = (
      'Nebulae'
      'Nebula Common Name'
      'Stars'
      'Star Common Name'
      'Variable Stars'
      'Double Stars'
      'Comets'
      'Asteroids'
      'Planets'
      'Constellation'
      'Other Lines Catalogs')
    TabOrder = 1
    OnClick = RadioGroup1Click
  end
  object Button1: TButton
    Left = 128
    Top = 288
    Width = 75
    Height = 25
    Caption = 'Find'
    TabOrder = 2
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 232
    Top = 288
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 3
  end
end
