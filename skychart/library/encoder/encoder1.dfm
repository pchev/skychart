object pop_scope: Tpop_scope
  Left = 204
  Top = 96
  BorderStyle = bsToolWindow
  Caption = 'Digital encoders'
  ClientHeight = 448
  ClientWidth = 326
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  Position = poDefault
  OnCloseQuery = kill
  OnCreate = formcreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object SpeedButton6: TSpeedButton
    Left = 296
    Top = 426
    Width = 23
    Height = 22
    Hint = 'Help...'
    Glyph.Data = {
      4E010000424D4E01000000000000760000002800000012000000120000000100
      040000000000D8000000130B0000130B00001000000000000000000000000000
      8000008000000080800080000000800080008080000080808000C0C0C0000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00888888888888
      8888880000008888888888888888880000008888888800888888880000008888
      8888008888888800000088888888888888888800000088888888008888888800
      0000888888880088888888000000888888880008888888000000888888888000
      8888880000008888888888000888880000008888888888800088880000008888
      0008888000888800000088888008888008888800000088888000000008888800
      0000888888800000888888000000888888888888888888000000888888888888
      888888000000888888888888888888000000}
    OnClick = SpeedButton6Click
  end
  object PageControl1: TPageControl
    Left = 0
    Top = 4
    Width = 321
    Height = 421
    ActivePage = TabSheet1
    TabOrder = 0
    object TabSheet1: TTabSheet
      Caption = 'Coordinates'
      object Panel1: TPanel
        Left = 8
        Top = 4
        Width = 297
        Height = 61
        TabOrder = 0
        object LabelAlpha: TLabel
          Left = 8
          Top = 8
          Width = 18
          Height = 13
          Caption = 'RA '
        end
        object LabelDelta: TLabel
          Left = 160
          Top = 8
          Width = 22
          Height = 13
          Caption = 'DEC'
        end
        object Label11: TLabel
          Left = 8
          Top = 36
          Width = 37
          Height = 13
          Caption = 'Azimuth'
        end
        object Label12: TLabel
          Left = 160
          Top = 36
          Width = 35
          Height = 13
          Caption = 'Altitude'
        end
        object pos_x: TEdit
          Left = 64
          Top = 4
          Width = 81
          Height = 21
          ReadOnly = True
          TabOrder = 0
        end
        object pos_y: TEdit
          Left = 208
          Top = 4
          Width = 81
          Height = 21
          ReadOnly = True
          TabOrder = 1
        end
        object az_x: TEdit
          Left = 64
          Top = 32
          Width = 81
          Height = 21
          ReadOnly = True
          TabOrder = 2
        end
        object alt_y: TEdit
          Left = 208
          Top = 32
          Width = 81
          Height = 21
          ReadOnly = True
          TabOrder = 3
        end
      end
      object GroupBox1: TGroupBox
        Left = 8
        Top = 192
        Width = 297
        Height = 148
        TabOrder = 1
        object SpeedButton4: TSpeedButton
          Left = 224
          Top = 8
          Width = 65
          Height = 22
          Caption = 'Clear'
          OnClick = SpeedButton4Click
        end
        object Label1: TLabel
          Left = 8
          Top = 13
          Width = 134
          Height = 13
          Caption = 'Objects used for Initialisation'
        end
        object status: TSpeedButton
          Left = 152
          Top = 8
          Width = 65
          Height = 22
          Caption = 'Status'
          OnClick = statusClick
        end
        object list_init: TListView
          Left = 2
          Top = 35
          Width = 289
          Height = 110
          Columns = <>
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Courier New'
          Font.Style = []
          ReadOnly = True
          ParentFont = False
          TabOrder = 0
          ViewStyle = vsReport
          OnMouseDown = list_initMouseDown
        end
      end
      object GroupBox3: TGroupBox
        Left = 8
        Top = 344
        Width = 297
        Height = 41
        TabOrder = 2
        object SpeedButton1: TSpeedButton
          Left = 4
          Top = 11
          Width = 61
          Height = 22
          Caption = 'Connect'
          OnClick = setresClick
        end
        object SpeedButton2: TSpeedButton
          Left = 228
          Top = 11
          Width = 61
          Height = 22
          Caption = 'Hide'
          OnClick = SpeedButton2Click
        end
        object SpeedButton5: TSpeedButton
          Left = 162
          Top = 11
          Width = 61
          Height = 22
          Caption = 'Disconnect'
          OnClick = SpeedButton5Click
        end
        object init90: TSpeedButton
          Left = 94
          Top = 11
          Width = 61
          Height = 22
          Caption = 'Init 90'#176
          OnClick = init90Click
        end
        object led1: TEdit
          Left = 70
          Top = 12
          Width = 17
          Height = 20
          AutoSize = False
          Color = clRed
          ReadOnly = True
          TabOrder = 0
        end
      end
      object GroupBox6: TGroupBox
        Left = 8
        Top = 112
        Width = 297
        Height = 84
        Hint = 
          'You can also use any object from the chart to do the initialisat' +
          'ion'
        Caption = 'Standalone Initialisation '
        ParentShowHint = False
        ShowHint = True
        TabOrder = 3
        object SpeedButton3: TSpeedButton
          Left = 224
          Top = 19
          Width = 65
          Height = 22
          Caption = 'Align'
          Enabled = False
          OnClick = INITClick
        end
        object cbo_source: TComboBox
          Left = 8
          Top = 20
          Width = 153
          Height = 21
          Enabled = False
          ItemHeight = 13
          TabOrder = 0
          Text = 'Not used'
          OnChange = cbo_sourceChange
          Items.Strings = (
            'Not used'
            'Star Name')
        end
        object cbo_starname: TComboBox
          Left = 8
          Top = 51
          Width = 281
          Height = 22
          Enabled = False
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Courier New'
          Font.Style = []
          ItemHeight = 14
          ParentFont = False
          TabOrder = 1
        end
        object CheckBox1: TCheckBox
          Left = 168
          Top = 22
          Width = 44
          Height = 17
          Caption = 'Use'
          TabOrder = 2
          OnClick = CheckBox1Click
        end
      end
      object Panel3: TPanel
        Left = 8
        Top = 68
        Width = 297
        Height = 44
        Hint = 'This require your device understand the "P" command'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 4
        object Label18: TLabel
          Left = 104
          Top = 2
          Width = 37
          Height = 13
          Caption = 'X Errors'
        end
        object Label19: TLabel
          Left = 168
          Top = 2
          Width = 37
          Height = 13
          Caption = 'Y Errors'
        end
        object Label20: TLabel
          Left = 232
          Top = 2
          Width = 33
          Height = 13
          Caption = 'Battery'
        end
        object CheckBox2: TCheckBox
          Left = 8
          Top = 13
          Width = 89
          Height = 20
          Caption = 'Device Status'
          TabOrder = 0
        end
        object Edit1: TEdit
          Left = 104
          Top = 16
          Width = 25
          Height = 21
          ReadOnly = True
          TabOrder = 1
        end
        object Edit2: TEdit
          Left = 168
          Top = 16
          Width = 25
          Height = 21
          ReadOnly = True
          TabOrder = 2
        end
        object Edit3: TEdit
          Left = 232
          Top = 16
          Width = 25
          Height = 21
          ReadOnly = True
          TabOrder = 3
        end
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'Encoder Configuration'
      ImageIndex = 1
      object GroupBox2: TGroupBox
        Left = 8
        Top = 12
        Width = 297
        Height = 157
        Caption = 'Encoder Configuration'
        TabOrder = 0
        object Label2: TLabel
          Left = 24
          Top = 24
          Width = 30
          Height = 13
          Caption = 'Type :'
        end
        object Label3: TLabel
          Left = 24
          Top = 51
          Width = 69
          Height = 13
          Caption = 'Steps (Alpha) :'
        end
        object Label4: TLabel
          Left = 24
          Top = 78
          Width = 64
          Height = 13
          Caption = 'Steps (Delta):'
        end
        object Label6: TLabel
          Left = 24
          Top = 129
          Width = 58
          Height = 13
          Caption = 'Connected :'
        end
        object Label14: TLabel
          Left = 24
          Top = 105
          Width = 92
          Height = 13
          Caption = 'Read Interval [ms] :'
        end
        object cbo_type: TComboBox
          Left = 120
          Top = 20
          Width = 113
          Height = 21
          ItemHeight = 13
          TabOrder = 0
          Items.Strings = (
            'Tangent'
            'Ouranos'
            'NGC-MAX'
            'MicroGuider'
            'AAM'
            'SkyVector'
            'Discovery'
            'Intelliscope')
        end
        object led: TEdit
          Left = 120
          Top = 128
          Width = 49
          Height = 20
          AutoSize = False
          Color = clRed
          ReadOnly = True
          TabOrder = 1
        end
        object res_x: TEdit
          Left = 120
          Top = 47
          Width = 65
          Height = 21
          TabOrder = 2
          Text = '2000'
        end
        object res_y: TEdit
          Left = 120
          Top = 74
          Width = 65
          Height = 21
          TabOrder = 3
          Text = '2000'
        end
        object ReadIntBox: TComboBox
          Left = 120
          Top = 101
          Width = 113
          Height = 21
          ItemHeight = 13
          TabOrder = 4
          Text = 'ReadIntBox'
          OnChange = ReadIntBoxChange
          Items.Strings = (
            '100'
            '250'
            '500'
            '1000'
            '2000'
            '5000')
        end
      end
      object SaveButton1: TButton
        Left = 204
        Top = 360
        Width = 89
        Height = 25
        Caption = 'Save Setting'
        TabOrder = 1
        OnClick = SaveButton1Click
      end
      object Mounttype: TRadioGroup
        Left = 8
        Top = 168
        Width = 147
        Height = 41
        Caption = 'Mount type'
        Columns = 2
        ItemIndex = 0
        Items.Strings = (
          'Equatorial'
          'Alt-Az')
        TabOrder = 2
        OnClick = MounttypeClick
      end
      object GroupBox5: TGroupBox
        Left = 8
        Top = 256
        Width = 297
        Height = 97
        Caption = 'Observatory '
        TabOrder = 3
        object Label15: TLabel
          Left = 24
          Top = 24
          Width = 47
          Height = 13
          Caption = 'Latitude : '
        end
        object Label16: TLabel
          Left = 24
          Top = 51
          Width = 70
          Height = 39
          Caption = 'Longitude :'#13#10'(negative east '#13#10'of Greenwich)'
        end
        object lat: TEdit
          Left = 120
          Top = 20
          Width = 121
          Height = 21
          TabOrder = 0
          Text = '0'
          OnChange = latChange
        end
        object long: TEdit
          Left = 120
          Top = 47
          Width = 121
          Height = 21
          TabOrder = 1
          Text = '0'
          OnChange = longChange
        end
      end
      object GroupBox7: TGroupBox
        Left = 8
        Top = 208
        Width = 297
        Height = 49
        Hint = 
          'Mount fabrication error as defined by Toshimi Taki (S&T Feb 1989' +
          ')'
        Caption = 'Mount fabrication error'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 4
        object Label22: TLabel
          Left = 16
          Top = 24
          Width = 19
          Height = 13
          Caption = 'Z1 :'
        end
        object Label23: TLabel
          Left = 112
          Top = 24
          Width = 19
          Height = 13
          Caption = 'Z2 :'
        end
        object Label24: TLabel
          Left = 208
          Top = 24
          Width = 19
          Height = 13
          Caption = 'Z3 :'
        end
        object Z1T: TFloatEdit
          Left = 40
          Top = 19
          Width = 49
          Height = 22
          Hint = 
            'Elevation axis offset from the perpendicular to the horizontal a' +
            'xis.'
          ParentShowHint = False
          ShowHint = True
          TabOrder = 0
        end
        object Z2T: TFloatEdit
          Left = 136
          Top = 19
          Width = 49
          Height = 22
          Hint = 'Optical axis offset'
          ParentShowHint = False
          ShowHint = True
          TabOrder = 1
        end
        object Z3T: TFloatEdit
          Left = 232
          Top = 19
          Width = 49
          Height = 22
          Hint = 'Elevation axis zero shifting'
          ParentShowHint = False
          ShowHint = True
          TabOrder = 2
        end
      end
      object InitType: TRadioGroup
        Left = 158
        Top = 168
        Width = 147
        Height = 41
        Caption = 'Encoder initialization angle'
        Columns = 2
        ItemIndex = 1
        Items.Strings = (
          '0 degree'
          '90 degree')
        TabOrder = 5
        OnClick = InitTypeClick
      end
      object CheckBox3: TCheckBox
        Left = 10
        Top = 356
        Width = 165
        Height = 17
        Caption = 'Record protocol to a trace file'
        TabOrder = 6
        OnClick = CheckBox3Click
      end
      object CheckBox4: TCheckBox
        Left = 10
        Top = 376
        Width = 127
        Height = 17
        Caption = 'Form always visible'
        TabOrder = 7
        OnClick = CheckBox4Click
      end
    end
    object TabSheet3: TTabSheet
      Caption = 'Port Configuration'
      ImageIndex = 2
      object GroupBox4: TGroupBox
        Left = 8
        Top = 12
        Width = 297
        Height = 213
        Caption = 'Port Configuration'
        TabOrder = 0
        object Label5: TLabel
          Left = 24
          Top = 24
          Width = 54
          Height = 13
          Caption = 'Serial Port :'
        end
        object Label7: TLabel
          Left = 24
          Top = 51
          Width = 37
          Height = 13
          Caption = 'Speed :'
        end
        object Label8: TLabel
          Left = 24
          Top = 105
          Width = 32
          Height = 13
          Caption = 'Parity :'
        end
        object Label9: TLabel
          Left = 24
          Top = 78
          Width = 49
          Height = 13
          Caption = 'Data Bits :'
        end
        object Label10: TLabel
          Left = 24
          Top = 132
          Width = 48
          Height = 13
          Caption = 'Stop Bits :'
        end
        object Label13: TLabel
          Left = 24
          Top = 159
          Width = 66
          Height = 13
          Caption = 'Timeout [ms] :'
        end
        object Label21: TLabel
          Left = 24
          Top = 186
          Width = 82
          Height = 13
          Caption = 'Interval Timeout :'
        end
        object PortSpeedbox: TComboBox
          Left = 120
          Top = 47
          Width = 113
          Height = 21
          ItemHeight = 13
          TabOrder = 0
          Text = 'PortSpeedbox'
          Items.Strings = (
            '110'
            '300'
            '1200'
            '2400'
            '4800'
            '9600'
            '14400'
            '19200'
            '38400'
            '57600'
            '115200')
        end
        object cbo_port: TComboBox
          Left = 120
          Top = 20
          Width = 113
          Height = 21
          ItemHeight = 13
          TabOrder = 1
          Text = 'cbo_port'
          Items.Strings = (
            'COM1'
            'COM2'
            'COM3'
            'COM4'
            'COM5'
            'COM6'
            'COM7'
            'COM8')
        end
        object Paritybox: TComboBox
          Left = 120
          Top = 101
          Width = 113
          Height = 21
          ItemHeight = 13
          TabOrder = 2
          Text = 'Paritybox'
          Items.Strings = (
            'N'
            'E'
            'O')
        end
        object DatabitBox: TComboBox
          Left = 120
          Top = 74
          Width = 113
          Height = 21
          ItemHeight = 13
          TabOrder = 3
          Text = 'DatabitBox'
          Items.Strings = (
            '4'
            '5'
            '6'
            '7'
            '8')
        end
        object StopbitBox: TComboBox
          Left = 120
          Top = 128
          Width = 113
          Height = 21
          ItemHeight = 13
          TabOrder = 4
          Text = 'StopbitBox'
          Items.Strings = (
            '1'
            '2')
        end
        object TimeOutBox: TComboBox
          Left = 120
          Top = 155
          Width = 113
          Height = 21
          ItemHeight = 13
          TabOrder = 5
          Text = 'TimeOutBox'
          Items.Strings = (
            '100'
            '500'
            '1000'
            '2500'
            '5000'
            '10000')
        end
        object IntTimeOutBox: TComboBox
          Left = 120
          Top = 182
          Width = 113
          Height = 21
          ItemHeight = 13
          TabOrder = 6
          Text = 'IntTimeOutBox'
          Items.Strings = (
            '10'
            '50'
            '100'
            '250'
            '500'
            '1000')
        end
      end
      object Button2: TButton
        Left = 112
        Top = 360
        Width = 89
        Height = 25
        Caption = 'Save Setting'
        TabOrder = 1
        OnClick = SaveButton1Click
      end
      object Panel2: TPanel
        Left = 8
        Top = 232
        Width = 297
        Height = 113
        TabOrder = 2
        object Label17: TLabel
          Left = 41
          Top = 12
          Width = 215
          Height = 78
          Alignment = taCenter
          Caption = 
            'Interface for Tangent like system.'#13#10'Will work with all systems u' +
            'sing same protocol'#13#10'(Ouranos, NGC MAX,MicroGuider,..)'#13#10'PJ Pallez' +
            ' Nov 1999'#13#10'P. Chevalley Nov 2001'#13#10'Version 2.0'
        end
      end
    end
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 429
    Width = 289
    Height = 19
    Align = alNone
    Panels = <>
    SimplePanel = True
  end
  object PopupMenu1: TPopupMenu
    Left = 260
    Top = 4
    object Delete1: TMenuItem
      Caption = 'Delete'
      OnClick = Delete1Click
    end
  end
  object Timer1: THiResTimer
    Interval = 500
    OnTimer = Timer1Timer
    Left = 292
    Top = 4
  end
end
