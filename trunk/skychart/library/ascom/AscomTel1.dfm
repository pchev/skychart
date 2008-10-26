object pop_scope: Tpop_scope
  Left = 973
  Top = 226
  HorzScrollBar.Visible = False
  VertScrollBar.Visible = False
  BorderStyle = bsToolWindow
  Caption = 'ASCOM Telescope Interface 1.4'
  ClientHeight = 317
  ClientWidth = 272
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDefault
  OnCloseQuery = kill
  OnCreate = formcreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object GroupBox3: TGroupBox
    Left = 8
    Top = 272
    Width = 257
    Height = 41
    TabOrder = 0
    object SpeedButton1: TSpeedButton
      Left = 8
      Top = 11
      Width = 65
      Height = 22
      Caption = 'Connect'
      OnClick = setresClick
    end
    object SpeedButton2: TSpeedButton
      Left = 184
      Top = 11
      Width = 65
      Height = 22
      Caption = 'Hide'
      OnClick = SpeedButton2Click
    end
    object SpeedButton5: TSpeedButton
      Left = 112
      Top = 11
      Width = 65
      Height = 22
      Caption = 'Disconnect'
      OnClick = SpeedButton5Click
    end
    object led: TEdit
      Left = 80
      Top = 12
      Width = 25
      Height = 20
      TabStop = False
      AutoSize = False
      Color = clRed
      ReadOnly = True
      TabOrder = 0
    end
  end
  object GroupBox5: TGroupBox
    Left = 8
    Top = 88
    Width = 257
    Height = 89
    Caption = 'Observatory '
    TabOrder = 1
    object Label15: TLabel
      Left = 4
      Top = 20
      Width = 47
      Height = 13
      Caption = 'Latitude : '
    end
    object Label16: TLabel
      Left = 124
      Top = 21
      Width = 53
      Height = 13
      Caption = 'Longitude :'
    end
    object SpeedButton8: TSpeedButton
      Left = 136
      Top = 51
      Width = 105
      Height = 22
      Caption = 'Set Time'
      Enabled = False
      OnClick = SpeedButton8Click
    end
    object SpeedButton9: TSpeedButton
      Left = 16
      Top = 51
      Width = 105
      Height = 22
      Caption = 'Set Location'
      Enabled = False
      OnClick = SpeedButton9Click
    end
    object lat: TEdit
      Left = 50
      Top = 16
      Width = 70
      Height = 21
      TabStop = False
      Color = clBtnFace
      ReadOnly = True
      TabOrder = 0
      Text = '0'
    end
    object long: TEdit
      Left = 180
      Top = 18
      Width = 70
      Height = 21
      TabStop = False
      Color = clBtnFace
      ReadOnly = True
      TabOrder = 1
      Text = '0'
    end
  end
  object Panel1: TPanel
    Left = 8
    Top = 180
    Width = 257
    Height = 93
    TabOrder = 2
    object LabelAlpha: TLabel
      Left = 26
      Top = 10
      Width = 18
      Height = 13
      Caption = 'RA '
    end
    object LabelDelta: TLabel
      Left = 128
      Top = 10
      Width = 22
      Height = 13
      Caption = 'DEC'
    end
    object Label11: TLabel
      Left = 26
      Top = 34
      Width = 14
      Height = 13
      Caption = 'AZ'
    end
    object Label12: TLabel
      Left = 128
      Top = 34
      Width = 20
      Height = 13
      Caption = 'ALT'
    end
    object SpeedButton6: TSpeedButton
      Left = 92
      Top = 63
      Width = 73
      Height = 22
      Caption = 'Abort Slew'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clRed
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      OnClick = SpeedButton6Click
    end
    object SpeedButton10: TSpeedButton
      Left = 16
      Top = 63
      Width = 65
      Height = 22
      Caption = 'Tracking'
      Enabled = False
      OnClick = SpeedButton10Click
    end
    object SpeedButton4: TSpeedButton
      Left = 176
      Top = 63
      Width = 65
      Height = 22
      Caption = 'Help...'
      OnClick = SpeedButton4Click
    end
    object pos_x: TEdit
      Left = 44
      Top = 6
      Width = 70
      Height = 21
      TabStop = False
      ReadOnly = True
      TabOrder = 0
    end
    object pos_y: TEdit
      Left = 160
      Top = 6
      Width = 70
      Height = 21
      TabStop = False
      ReadOnly = True
      TabOrder = 1
    end
    object az_x: TEdit
      Left = 44
      Top = 30
      Width = 70
      Height = 21
      TabStop = False
      ReadOnly = True
      TabOrder = 2
    end
    object alt_y: TEdit
      Left = 160
      Top = 30
      Width = 70
      Height = 21
      TabStop = False
      ReadOnly = True
      TabOrder = 3
    end
    object ShowAltAz: TCheckBox
      Left = 8
      Top = 32
      Width = 17
      Height = 17
      TabOrder = 4
    end
  end
  object GroupBox1: TGroupBox
    Left = 8
    Top = 0
    Width = 257
    Height = 81
    Caption = 'Driver Selection'
    TabOrder = 3
    object SpeedButton3: TSpeedButton
      Left = 176
      Top = 9
      Width = 65
      Height = 22
      Caption = 'Select'
      OnClick = SpeedButton3Click
    end
    object Label1: TLabel
      Left = 8
      Top = 56
      Width = 64
      Height = 13
      Caption = 'Refresh rate :'
    end
    object SpeedButton7: TSpeedButton
      Left = 176
      Top = 32
      Width = 65
      Height = 22
      Caption = 'Configure'
      OnClick = SpeedButton7Click
    end
    object SpeedButton11: TSpeedButton
      Left = 176
      Top = 55
      Width = 65
      Height = 22
      Caption = 'About'
      OnClick = SpeedButton11Click
    end
    object Edit1: TEdit
      Left = 8
      Top = 24
      Width = 153
      Height = 21
      TabStop = False
      Color = clBtnFace
      ReadOnly = True
      TabOrder = 0
    end
    object ReadIntBox: TComboBox
      Left = 88
      Top = 52
      Width = 73
      Height = 21
      ItemHeight = 13
      TabOrder = 1
      Text = '1000'
      OnChange = ReadIntBoxChange
      Items.Strings = (
        '100'
        '250'
        '500'
        '1000'
        '2000')
    end
  end
  object Timer1: TTimer
    Enabled = False
    OnTimer = Timer1Timer
    Left = 240
    Top = 8
  end
end
