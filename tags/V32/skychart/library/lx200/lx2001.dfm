object pop_scope: Tpop_scope
  Left = 224
  Top = 117
  HorzScrollBar.Visible = False
  VertScrollBar.Visible = False
  AutoSize = True
  BorderStyle = bsToolWindow
  Caption = 'LX200'
  ClientHeight = 407
  ClientWidth = 313
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDefault
  OnCloseQuery = kill
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 313
    Height = 407
    ActivePage = TabSheet1
    MultiLine = True
    TabOrder = 0
    object TabSheet1: TTabSheet
      Caption = 'Coordinates'
      object SpeedButton8: TSpeedButton
        Left = 176
        Top = 255
        Width = 113
        Height = 22
        Caption = 'Set TelescopeTime'
        OnClick = SpeedButton8Click
      end
      object SpeedButton9: TSpeedButton
        Left = 176
        Top = 283
        Width = 113
        Height = 22
        Caption = 'Park Telescope'
        OnClick = SpeedButton9Click
      end
      object Panel1: TPanel
        Left = 3
        Top = 3
        Width = 286
        Height = 61
        TabOrder = 0
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
        object pos_x: TEdit
          Left = 44
          Top = 6
          Width = 70
          Height = 21
          ReadOnly = True
          TabOrder = 0
        end
        object pos_y: TEdit
          Left = 160
          Top = 6
          Width = 70
          Height = 21
          ReadOnly = True
          TabOrder = 1
        end
        object az_x: TEdit
          Left = 44
          Top = 30
          Width = 70
          Height = 21
          ReadOnly = True
          TabOrder = 2
        end
        object alt_y: TEdit
          Left = 160
          Top = 30
          Width = 70
          Height = 21
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
        Left = 3
        Top = 73
        Width = 286
        Height = 169
        Caption = 'Move '
        TabOrder = 1
        object Shape1: TShape
          Left = 124
          Top = 16
          Width = 150
          Height = 150
          Brush.Style = bsClear
          Shape = stCircle
        end
        object TopBtn: TSpeedButton
          Left = 187
          Top = 40
          Width = 25
          Height = 25
          Enabled = False
          Glyph.Data = {
            4E010000424D4E01000000000000760000002800000012000000120000000100
            040000000000D800000000000000000000001000000010000000000000000000
            8000008000000080800080000000800080008080000080808000C0C0C0000000
            FF00C0C0C00000FFFF00FF000000C0C0C000FFFF0000FFFFFF00DADADD000000
            0DDADA000000DADADD0000000DDADA000000ADADAA0666660AADAD000000DADA
            DD0666660DDADA000000ADADAA0666660AADAD000000DADADD0666660DDADA00
            0000ADADAA0666660AADAD000000DADADD0666660DDADA000000ADADAA066666
            0AADAD000000D00000066666000000000000D00000066666000000000000AD00
            6666666666600D000000DAD0066666666600DA000000ADAD00666666600DAD00
            0000DADAD006666600DADA000000ADADAA0066600AADAD000000DADADDA00600
            ADDADA000000ADADAADA000ADAADAD000000}
          OnMouseDown = TopBtnMouseDown
          OnMouseUp = TopBtnMouseUp
        end
        object LeftBtn: TSpeedButton
          Left = 149
          Top = 79
          Width = 25
          Height = 25
          Enabled = False
          Glyph.Data = {
            4E010000424D4E01000000000000760000002800000012000000120000000100
            040000000000D800000000000000000000001000000010000000000000000000
            8000008000000080800080000000800080008080000080808000C0C0C0000000
            FF00C0C0C00000FFFF00FF000000C0C0C000FFFF0000FFFFFF00AADADADADAAD
            ADADAD000000DDADADAD0DDADADADA000000AADADAD00AADADADAD000000DDAD
            AD000DDADADADA000000AADAD0060AADADADAD000000AADA00660AADADADAD00
            0000DDA006660000000000000000AA0066666666666660000000D00666666666
            666660000000006666666666666660000000D00666666666666660000000AA00
            66666666666660000000DDA006660000000000000000AADA00660AADADADAD00
            0000AADAD0060AADADADAD000000DDADAD000DDADADADA000000AADADAD00AAD
            ADADAD000000DDADADAD0DDADADADA000000}
          OnMouseDown = LeftBtnMouseDown
          OnMouseUp = LeftBtnMouseUp
        end
        object RightBtn: TSpeedButton
          Left = 225
          Top = 79
          Width = 25
          Height = 25
          Enabled = False
          Glyph.Data = {
            4E010000424D4E01000000000000760000002800000012000000120000000100
            040000000000D800000000000000000000001000000010000000000000000000
            8000008000000080800080000000800080008080000080808000C0C0C0000000
            FF00C0C0C00000FFFF00FF000000C0C0C000FFFF0000FFFFFF00DDADADADADDA
            DADADA000000AADADADAD00DADADAD000000DDADADADA000DADADA000000AADA
            DADAD0000DADAD000000DDADADADA00600DADA000000DDADADADA006600ADA00
            00000000000000066600AD00000000666666666666600A000000006666666666
            6666000000000066666666666666600000000066666666666666000000000066
            6666666666600A0000000000000000066600AD000000DDADADADA006600ADA00
            0000DDADADADA00600DADA000000AADADADAD0000DADAD000000DDADADADA000
            DADADA000000AADADADAD00DADADAD000000}
          OnMouseDown = RightBtnMouseDown
          OnMouseUp = RightBtnMouseUp
        end
        object BotBtn: TSpeedButton
          Left = 187
          Top = 118
          Width = 25
          Height = 25
          Enabled = False
          Glyph.Data = {
            4E010000424D4E01000000000000760000002800000012000000120000000100
            040000000000D800000000000000000000001000000010000000000000000000
            8000008000000080800080000000800080008080000080808000C0C0C0000000
            FF00C0C0C00000FFFF00FF000000C0C0C000FFFF0000FFFFFF008DADAADAD0DA
            DAADAD0000008DADAADA000ADAADAD0000008ADADDA00600ADDADA0000008DAD
            AA0066600AADAD0000008ADAD006666600DADA0000008DAD00666666600DAD00
            00008AD0066666666600DA0000008D006666666666600D000000800000066666
            0000000000008DADAA0666660AADAD0000008DADAA0666660AADAD0000008ADA
            DD0666660DDADA0000008DADAA0666660AADAD0000008ADADD0666660DDADA00
            00008DADAA0666660AADAD0000008ADADD0666660DDADA0000008DADAA066666
            0AADAD0000008ADADD0000000DDADA000000}
          OnMouseDown = BotBtnMouseDown
          OnMouseUp = BotBtnMouseUp
        end
        object StopBtn: TSpeedButton
          Left = 181
          Top = 73
          Width = 37
          Height = 37
          Caption = 'STOP'
          Enabled = False
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clRed
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
          OnMouseDown = StopBtnMouseDown
        end
        object Label3: TLabel
          Left = 193
          Top = 20
          Width = 12
          Height = 16
          Caption = 'N'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object Label4: TLabel
          Left = 253
          Top = 83
          Width = 15
          Height = 16
          Caption = 'W'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object Label6: TLabel
          Left = 194
          Top = 144
          Width = 11
          Height = 16
          Caption = 'S'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object Label14: TLabel
          Left = 131
          Top = 83
          Width = 11
          Height = 16
          Caption = 'E'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object RadioGroup1: TRadioGroup
          Left = 8
          Top = 15
          Width = 94
          Height = 90
          Caption = 'Speed'
          Enabled = False
          ItemIndex = 2
          Items.Strings = (
            'Slew'
            'Find'
            'Centering'
            'Guide')
          TabOrder = 0
        end
        object GroupBox8: TGroupBox
          Left = 8
          Top = 105
          Width = 94
          Height = 57
          Caption = 'Swap button'
          TabOrder = 1
          object CheckBox3: TCheckBox
            Left = 8
            Top = 16
            Width = 65
            Height = 17
            Caption = 'N <-> S'
            TabOrder = 0
            OnClick = CheckBox3Click
          end
          object CheckBox4: TCheckBox
            Left = 8
            Top = 32
            Width = 65
            Height = 17
            Caption = 'E <-> W'
            TabOrder = 1
            OnClick = CheckBox4Click
          end
        end
      end
      object GroupBox3: TGroupBox
        Left = 3
        Top = 319
        Width = 286
        Height = 49
        TabOrder = 2
        object SpeedButton1: TSpeedButton
          Left = 8
          Top = 12
          Width = 65
          Height = 22
          Caption = 'Connect'
          OnClick = setresClick
        end
        object SpeedButton2: TSpeedButton
          Left = 182
          Top = 12
          Width = 65
          Height = 22
          Caption = 'Hide'
          OnClick = SpeedButton2Click
        end
        object SpeedButton5: TSpeedButton
          Left = 108
          Top = 12
          Width = 65
          Height = 22
          Caption = 'Disconnect'
          OnClick = SpeedButton5Click
        end
        object SpeedButton4: TSpeedButton
          Left = 253
          Top = 12
          Width = 25
          Height = 22
          Caption = '?'
          OnClick = SpeedButton4Click
        end
        object led: TEdit
          Left = 84
          Top = 14
          Width = 15
          Height = 20
          AutoSize = False
          Color = clRed
          ReadOnly = True
          TabOrder = 0
        end
      end
      object GroupBox6: TGroupBox
        Left = 3
        Top = 248
        Width = 145
        Height = 65
        Caption = 'High Precision Pointing'
        TabOrder = 3
        Visible = False
        object SpeedButton3: TSpeedButton
          Left = 12
          Top = 25
          Width = 89
          Height = 22
          Caption = 'Resume GoTo'
          OnClick = SpeedButton3Click
        end
      end
    end
    object MotorTab: TTabSheet
      Caption = 'Motor'
      ImageIndex = 6
      object FanControl: TCheckBox
        Left = 32
        Top = 184
        Width = 57
        Height = 49
        Caption = 'Fan'
        TabOrder = 5
        Visible = False
        OnClick = FanControlClick
      end
      object LxPecToggle: TButton
        Left = 16
        Top = 200
        Width = 89
        Height = 25
        Caption = 'Pec Toggle'
        Enabled = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 1
        OnClick = PecToggleClick
      end
      object SlewSpeedGroup: TGroupBox
        Left = 16
        Top = 232
        Width = 241
        Height = 89
        Caption = ' Slew Speed '
        TabOrder = 6
        object LabelSetSlewSpeed: TLabel
          Left = 40
          Top = 32
          Width = 61
          Height = 26
          Caption = 'Set Slewing '#13#10' Speed (2..4)'
        end
        object SlewSpeedBar: TTrackBar
          Left = 136
          Top = 32
          Width = 81
          Height = 41
          Enabled = False
          Max = 4
          Min = 2
          Position = 2
          TabOrder = 0
          OnChange = SlewSpeedBarChange
        end
      end
      object TrackingGroup: TGroupBox
        Left = 16
        Top = 16
        Width = 241
        Height = 121
        Caption = 'Tracking '
        Enabled = False
        TabOrder = 0
        object TrackingRateLabel: TLabel
          Left = 136
          Top = 64
          Width = 19
          Height = 13
          Caption = '[Hz]'
        end
        object TrackingDecreaseLabel: TLabel
          Left = 16
          Top = 88
          Width = 46
          Height = 26
          Caption = 'Decrease'#13#10' 0.1 Hz'
        end
        object TrackingIncreaseLabel: TLabel
          Left = 184
          Top = 88
          Width = 41
          Height = 26
          Caption = 'Increase'#13#10'0.1 Hz'
        end
        object TrackingDefaultButton: TButton
          Left = 16
          Top = 24
          Width = 65
          Height = 25
          Caption = 'Default'
          Enabled = False
          TabOrder = 0
          OnClick = TrackingDefaultButtonClick
        end
        object TrackingLunarButton: TButton
          Left = 88
          Top = 24
          Width = 65
          Height = 25
          Caption = 'Lunar'
          Enabled = False
          TabOrder = 1
          OnClick = TrackingLunarButtonClick
        end
        object TrackingCustomButton: TButton
          Left = 160
          Top = 24
          Width = 65
          Height = 25
          Caption = 'Custom'
          Enabled = False
          TabOrder = 2
          OnClick = TrackingCustomButtonClick
        end
        object TrackingGetButton: TButton
          Left = 16
          Top = 56
          Width = 57
          Height = 25
          Caption = 'Get'
          Enabled = False
          TabOrder = 3
          OnClick = TrackingGetButtonClick
        end
        object TrackingRateEdit: TFloatEdit
          Left = 80
          Top = 56
          Width = 49
          Height = 22
          Hint = '0..999'
          Enabled = False
          MaxLength = 6
          ParentShowHint = False
          ShowHint = True
          TabOrder = 4
          Value = 60.000000000000000000
          Decimals = 3
          MaxValue = 999.000000000000000000
          Digits = 7
          NumericType = ntFixed
        end
        object TrackingSetRateButton: TButton
          Left = 168
          Top = 56
          Width = 57
          Height = 25
          Caption = 'Set'
          Enabled = False
          TabOrder = 5
          OnClick = TrackingSetRateButtonClick
        end
        object TrackingRateDecrease: TButton
          Left = 80
          Top = 88
          Width = 33
          Height = 25
          Caption = '-'
          Enabled = False
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -19
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 6
          OnClick = TrackingRateDecreaseClick
        end
        object TrackingRateIncrease: TButton
          Left = 136
          Top = 88
          Width = 33
          Height = 25
          Caption = '+'
          Enabled = False
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -19
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 7
          OnClick = TrackingRateIncreaseClick
        end
      end
      object FieldRotationGroup: TGroupBox
        Left = 16
        Top = 144
        Width = 241
        Height = 41
        Caption = 'Field Rotation'
        TabOrder = 2
        object FRLabel: TLabel
          Left = 80
          Top = 16
          Width = 44
          Height = 13
          Caption = 'FR Angle'
          Visible = False
        end
        object FieldRotation: TCheckBox
          Left = 16
          Top = 16
          Width = 57
          Height = 17
          Hint = 
            'Turn on or off field rotation. If turning off, abort slew. Initi' +
            'al state unknown.'
          Caption = 'Motor'
          Enabled = False
          ParentShowHint = False
          ShowHint = True
          TabOrder = 0
          OnClick = ScopeFieldRotationClick
        end
        object FRQuery: TButton
          Left = 184
          Top = 16
          Width = 43
          Height = 17
          Caption = 'Update'
          Enabled = False
          TabOrder = 1
          Visible = False
          OnClick = FRQueryClick
        end
        object FRAngle: TFloatEdit
          Left = 128
          Top = 16
          Width = 49
          Height = 17
          Enabled = False
          ReadOnly = True
          TabOrder = 2
          Visible = False
          Decimals = 2
          Digits = 7
          NumericType = ntFixed
        end
      end
      object Lx200GPSMotorSpeeds: TGroupBox
        Left = 16
        Top = 232
        Width = 241
        Height = 89
        Caption = 'Motor Speeds '
        TabOrder = 3
        Visible = False
        object LabelGuideSpeed: TLabel
          Left = 16
          Top = 16
          Width = 93
          Height = 13
          Caption = 'Guide Rate [arc"/s]'
        end
        object LabelRaAzSpeed: TLabel
          Left = 16
          Top = 40
          Width = 107
          Height = 13
          Caption = 'RA/Az Slew Rate ['#176'/s]'
        end
        object LabelDecSlewRate: TLabel
          Left = 16
          Top = 64
          Width = 111
          Height = 13
          Caption = 'DEC/El Slew Rate ['#176'/s]'
        end
        object LxGuideRate: TFloatEdit
          Left = 136
          Top = 16
          Width = 33
          Height = 17
          Enabled = False
          TabOrder = 0
          Digits = 3
          NumericType = ntFixed
        end
        object LxGuideRateSet: TBitBtn
          Left = 176
          Top = 16
          Width = 33
          Height = 17
          Caption = 'Set'
          Enabled = False
          TabOrder = 1
          OnClick = LxGuideRateSetClick
        end
        object RASlewRate: TFloatEdit
          Left = 136
          Top = 40
          Width = 33
          Height = 17
          Enabled = False
          TabOrder = 2
          Digits = 3
          NumericType = ntFixed
        end
        object RASlewRateSet: TBitBtn
          Left = 176
          Top = 40
          Width = 33
          Height = 17
          Caption = 'Set'
          Enabled = False
          TabOrder = 3
          OnClick = RASlewRateSetClick
        end
        object DECSlewRate: TFloatEdit
          Left = 136
          Top = 64
          Width = 33
          Height = 17
          Enabled = False
          TabOrder = 4
          Digits = 3
          NumericType = ntFixed
        end
        object DECSlewRateSet: TBitBtn
          Left = 176
          Top = 64
          Width = 33
          Height = 17
          Caption = 'Set'
          Enabled = False
          TabOrder = 5
          OnClick = DECSlewRateSetClick
        end
      end
      object LX200GPSRate: TCheckBox
        Left = 120
        Top = 184
        Width = 137
        Height = 49
        Caption = 'Gps-16" Adv. Settings'
        TabOrder = 4
        OnClick = LX200GPSRateClick
      end
    end
    object Focus: TTabSheet
      Caption = 'Focus'
      ImageIndex = 3
      object SpeedButton6: TSpeedButton
        Left = 168
        Top = 192
        Width = 35
        Height = 35
        Glyph.Data = {
          76020000424D7602000000000000760000002800000020000000200000000100
          04000000000000020000110B0000110B00001000000010000000000000000000
          8000008000000080800080000000800080008080000080808000C0C0C0000000
          FF00C0C0C00000FFFF00FF000000C0C0C000FFFF0000FFFFFF00DAADDAADD000
          00000000000DDAADDAA8DAADDAADD00000000000000DDAADDAA8ADDAADDAA006
          66666666600AADDAADD8ADDAADDAA00666666666600AADDAADD8DAADDAADD006
          66666666600DDAADDAA8DAADDAADD00666666666600DDAADDAA8ADDAADDAA006
          66666666600AADDAADD8ADDAADDAA00666666666600AADDAADD8DAADDAADD006
          66666666600DDAADDAA8DAADDAADD00666666666600DDAADDAA8ADDAADDAA006
          66666666600AADDAADD8ADDAADDAA00666666666600AADDAADD8DAADDAADD006
          66666666600DDAADDAA8DAADDAADD00666666666600DDAADDAA8ADDAADDAA006
          66666666600AADDAADD8ADDAADDAA00666666666600AADDAADD8D00000000006
          66666666600000000008D0000000000666666666600000000008AD0006666666
          666666666666666000D8ADD00066666666666666666666000DD8DAAD00066666
          6666666666666000DAA8DAADD0006666666666666666000DDAA8ADDAAD000666
          66666666666000DAADD8ADDAADD000666666666666000DDAADD8DAADDAAD0006
          666666666000DAADDAA8DAADDAADD00066666666000DDAADDAA8ADDAADDAAD00
          0666666000DAADDAADD8ADDAADDAADD0006666000DDAADDAADD8DAADDAADDAAD
          00066000DAADDAADDAA8DAADDAADDAADD000000DDAADDAADDAA8ADDAADDAADDA
          AD0000DAADDAADDAADD8ADDAADDAADDAADD00DDAADDAADDAADD8}
        OnMouseDown = SpeedButton6MouseDown
        OnMouseUp = SpeedButton6MouseUp
      end
      object SpeedButton7: TSpeedButton
        Left = 168
        Top = 240
        Width = 35
        Height = 35
        Glyph.Data = {
          76020000424D7602000000000000760000002800000020000000200000000100
          04000000000000020000110B0000110B00001000000010000000000000000000
          8000008000000080800080000000800080008080000080808000C0C0C0000000
          FF00C0C0C00000FFFF00FF000000C0C0C000FFFF0000FFFFFF008DDAADDAADDA
          ADD00DDAADDAADDAADDA8DDAADDAADDAAD0000DAADDAADDAADDA8AADDAADDAAD
          D000000DDAADDAADDAAD8AADDAADDAAD00066000DAADDAADDAAD8DDAADDAADD0
          006666000DDAADDAADDA8DDAADDAAD000666666000DAADDAADDA8AADDAADD000
          66666666000DDAADDAAD8AADDAAD0006666666666000DAADDAAD8DDAADD00066
          6666666666000DDAADDA8DDAAD00066666666666666000DAADDA8AADD0006666
          666666666666000DDAAD8AAD000666666666666666666000DAAD8DD000666666
          66666666666666000DDA8D0006666666666666666666666000DA800000000006
          6666666660000000000D8000000000066666666660000000000D8DDAADDAA006
          66666666600AADDAADDA8DDAADDAA00666666666600AADDAADDA8AADDAADD006
          66666666600DDAADDAAD8AADDAADD00666666666600DDAADDAAD8DDAADDAA006
          66666666600AADDAADDA8DDAADDAA00666666666600AADDAADDA8AADDAADD006
          66666666600DDAADDAAD8AADDAADD00666666666600DDAADDAAD8DDAADDAA006
          66666666600AADDAADDA8DDAADDAA00666666666600AADDAADDA8AADDAADD006
          66666666600DDAADDAAD8AADDAADD00666666666600DDAADDAAD8DDAADDAA006
          66666666600AADDAADDA8DDAADDAA00666666666600AADDAADDA8AADDAADD000
          00000000000DDAADDAAD8AADDAADD00000000000000DDAADDAAD}
        OnMouseDown = SpeedButton7MouseDown
        OnMouseUp = SpeedButton6MouseUp
      end
      object Label19: TLabel
        Left = 40
        Top = 224
        Width = 70
        Height = 13
        Caption = 'Pulse duration:'
      end
      object Label20: TLabel
        Left = 104
        Top = 245
        Width = 14
        Height = 13
        Caption = 'Ms'
      end
      object Bevel1: TBevel
        Left = 24
        Top = 192
        Width = 113
        Height = 81
        Style = bsRaised
      end
      object RadioGroup3: TRadioGroup
        Left = 24
        Top = 96
        Width = 225
        Height = 73
        Caption = 'Autostar Focus Speed'
        Columns = 4
        ItemIndex = 0
        Items.Strings = (
          '1'
          '2'
          '3'
          '4')
        TabOrder = 0
        Visible = False
      end
      object RadioGroup4: TRadioGroup
        Left = 24
        Top = 96
        Width = 225
        Height = 73
        Caption = 'LX200 Focus Speed'
        Columns = 2
        ItemIndex = 1
        Items.Strings = (
          'Slow'
          'Fast')
        TabOrder = 1
      end
      object RadioGroup5: TRadioGroup
        Left = 24
        Top = 8
        Width = 225
        Height = 73
        Caption = 'Speed Selection'
        Columns = 2
        ItemIndex = 0
        Items.Strings = (
          'LX200'
          'Autostar, GPS')
        TabOrder = 2
        OnClick = RadioGroup5Click
      end
      object CheckBox6: TCheckBox
        Left = 40
        Top = 200
        Width = 89
        Height = 17
        Caption = 'Pulse Mode'
        TabOrder = 3
        OnClick = CheckBox6Click
      end
      object LongEdit1: TLongEdit
        Left = 40
        Top = 240
        Width = 57
        Height = 22
        Hint = '0..1000'
        Enabled = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 4
        Value = 100
        MaxValue = 1000
      end
      object Button1: TButton
        Left = 92
        Top = 300
        Width = 89
        Height = 25
        Caption = 'Save Setting'
        TabOrder = 5
        OnClick = SaveButton1Click
      end
    end
    object VirtHP: TTabSheet
      Caption = 'VirtHP'
      ImageIndex = 4
      TabVisible = False
      object VHPTitleLabel: TLabel
        Left = 0
        Top = 16
        Width = 249
        Height = 13
        Align = alCustom
        Alignment = taCenter
        AutoSize = False
        Caption = 'Virtual HandPad for Scope.exe '
      end
      object HandPadModeSelection: TRadioGroup
        Left = 8
        Top = 120
        Width = 257
        Height = 193
        Hint = 'Quick selection of handpad mode'
        Caption = 'HandPad Mode Selection'
        Columns = 2
        Enabled = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        Items.Strings = (
          'Off'
          'InitAutoOn'
          'Init1On'
          'Init2On'
          'Init3On'
          'PolarAlign'
          'AnalyzeOn'
          'Guide'
          'GuideStay'
          'GuideStayRo'
          'GuideDrag'
          'GrandTour'
          'ScrollTour'
          'ScrollAuto'
          'RecordEquat'
          'ToggleTrack'
          'FRMotorCtrl'
          'Focus'
          'AuxOutCtrl')
        ParentFont = False
        TabOrder = 1
        OnClick = HandPadModeSelectionClick
      end
      object LRModeGroup: TGroupBox
        Left = 8
        Top = 40
        Width = 257
        Height = 65
        Caption = 'Mode Button Simulator'
        Enabled = False
        TabOrder = 0
        object RightModeButton: TButton
          Left = 144
          Top = 24
          Width = 83
          Height = 25
          Hint = 'Press this button to simulate right handpaddle mode'
          Caption = 'Right Mode'
          ParentShowHint = False
          ShowHint = True
          TabOrder = 0
          OnClick = VHRightClick
        end
        object LeftModeButton: TButton
          Left = 32
          Top = 24
          Width = 81
          Height = 25
          Hint = 'Press this button to simulate left handpaddle mode'
          Caption = 'Left Mode'
          ParentShowHint = False
          ShowHint = True
          TabOrder = 1
          OnClick = VHpLeftClick
        end
      end
      object VirtHpHelp: TButton
        Left = 224
        Top = 8
        Width = 27
        Height = 25
        Caption = '?'
        TabOrder = 2
        OnClick = VirtHpHelpClick
      end
    end
    object Adv: TTabSheet
      Caption = 'Scope Adv'
      ImageIndex = 5
      TabVisible = False
      object ADVTitleLabel: TLabel
        Left = 0
        Top = 16
        Width = 249
        Height = 13
        Align = alCustom
        Alignment = taCenter
        AutoSize = False
        Caption = 'Advanced Settings for Scope.exe '
      end
      object ScopeSpeeds: TGroupBox
        Left = 16
        Top = 40
        Width = 89
        Height = 281
        Caption = 'Speed settings'
        Enabled = False
        TabOrder = 0
        object MsArcSecLabel: TLabel
          Left = 8
          Top = 24
          Width = 73
          Height = 33
          Alignment = taCenter
          AutoSize = False
          Caption = 'msarcsec'
        end
        object GuideArcSecLabel: TLabel
          Left = 8
          Top = 152
          Width = 73
          Height = 33
          Alignment = taCenter
          AutoSize = False
          Caption = 'guide arcsec'
        end
        object MsArcSec: TLongEdit
          Left = 16
          Top = 59
          Width = 57
          Height = 22
          Hint = '0..9999'
          Enabled = False
          ParentShowHint = False
          ShowHint = True
          TabOrder = 0
          Value = 0
          MaxValue = 9999
        end
        object GuideArcSec: TLongEdit
          Left = 16
          Top = 195
          Width = 57
          Height = 22
          Hint = '0..9999'
          Enabled = False
          ParentShowHint = False
          ShowHint = True
          TabOrder = 1
          Value = 0
          MaxValue = 9999
        end
        object GetMsArcSec: TButton
          Left = 16
          Top = 88
          Width = 57
          Height = 17
          Caption = 'Get'
          TabOrder = 2
          OnClick = GetMsArcSecClick
        end
        object GetGuideArcSec: TButton
          Left = 16
          Top = 224
          Width = 57
          Height = 17
          Caption = 'Get'
          TabOrder = 3
          OnClick = GetGuideArcSecClick
        end
        object SetMsArcSec: TButton
          Left = 16
          Top = 112
          Width = 57
          Height = 17
          Caption = 'Set'
          TabOrder = 4
          OnClick = SetMsArcSecClick
        end
        object SetGuideArcSec: TButton
          Left = 16
          Top = 248
          Width = 57
          Height = 17
          Caption = 'Set'
          TabOrder = 5
          OnClick = SetGuideArcSecClick
        end
      end
      object ScopeInit: TGroupBox
        Left = 128
        Top = 40
        Width = 121
        Height = 145
        Hint = 
          'initialize point 1 through 3 using already sent equatorial coord' +
          'inates'
        Caption = 'Initialize'
        Enabled = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 1
        object ScopeInit1: TButton
          Left = 24
          Top = 24
          Width = 75
          Height = 25
          Caption = 'Init 1'
          TabOrder = 0
          OnClick = ScopeInit1Click
        end
        object ScopeInit2: TButton
          Left = 24
          Top = 64
          Width = 75
          Height = 25
          Caption = 'Init2'
          TabOrder = 1
          OnClick = ScopeInit2Click
        end
        object ScopeInit3: TButton
          Left = 24
          Top = 104
          Width = 75
          Height = 25
          Caption = 'Init3'
          TabOrder = 2
          OnClick = ScopeInit3Click
        end
      end
      object AdvHelp: TButton
        Left = 224
        Top = 8
        Width = 27
        Height = 25
        Caption = '?'
        TabOrder = 2
        OnClick = AdvHelpClick
      end
    end
    object PEC: TTabSheet
      Caption = 'PEC'
      ImageIndex = 7
      TabVisible = False
      object RAPEC: TGroupBox
        Left = 24
        Top = 56
        Width = 217
        Height = 73
        Caption = 'RA/AZ PEC Compensation'
        TabOrder = 0
        object RAPECOn: TButton
          Left = 24
          Top = 32
          Width = 75
          Height = 25
          Caption = 'On'
          Enabled = False
          TabOrder = 0
        end
        object RAPECOff: TButton
          Left = 120
          Top = 32
          Width = 75
          Height = 25
          Caption = 'Off'
          Enabled = False
          TabOrder = 1
        end
      end
      object DECPEC: TGroupBox
        Left = 24
        Top = 168
        Width = 217
        Height = 73
        Caption = 'DEC/EL PEC Compensation'
        TabOrder = 1
        object DECPECOn: TButton
          Left = 24
          Top = 32
          Width = 75
          Height = 25
          Caption = 'On'
          Enabled = False
          TabOrder = 0
        end
        object DECPECOff: TButton
          Left = 120
          Top = 32
          Width = 75
          Height = 25
          Caption = 'Off'
          Enabled = False
          TabOrder = 1
        end
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'Configuration'
      ImageIndex = 1
      object SaveButton1: TButton
        Left = 192
        Top = 340
        Width = 89
        Height = 25
        Caption = 'Save Setting'
        TabOrder = 0
        OnClick = SaveButton1Click
      end
      object GroupBox5: TGroupBox
        Left = 8
        Top = 231
        Width = 281
        Height = 89
        Caption = 'Observatory '
        TabOrder = 1
        object Label15: TLabel
          Left = 24
          Top = 20
          Width = 47
          Height = 13
          Caption = 'Latitude : '
        end
        object Label16: TLabel
          Left = 24
          Top = 45
          Width = 70
          Height = 39
          Caption = 'Longitude :'#13#10'(negative east '#13#10'of Greenwich)'
        end
        object lat: TEdit
          Left = 120
          Top = 16
          Width = 121
          Height = 21
          TabOrder = 0
          Text = '0'
          OnChange = latChange
        end
        object long: TEdit
          Left = 120
          Top = 42
          Width = 121
          Height = 21
          TabOrder = 1
          Text = '0'
          OnChange = longChange
        end
      end
      object GroupBox2: TGroupBox
        Left = 8
        Top = 0
        Width = 178
        Height = 119
        Caption = 'LX200'
        TabOrder = 2
        object Label1: TLabel
          Left = 8
          Top = 28
          Width = 29
          Height = 13
          Caption = 'Model'
        end
        object Label2: TLabel
          Left = 8
          Top = 60
          Width = 61
          Height = 13
          Caption = 'Refresh rate '
        end
        object Label21: TLabel
          Left = 8
          Top = 84
          Width = 75
          Height = 25
          AutoSize = False
          Caption = 'Equatorial System'
          WordWrap = True
        end
        object cbo_type: TComboBox
          Left = 87
          Top = 24
          Width = 81
          Height = 21
          ItemHeight = 13
          TabOrder = 0
          Text = 'LX200'
          OnChange = cbo_typeChange
          Items.Strings = (
            'LX200'
            'AutoStar'
            'Magellan-II'
            'Magellan-I'
            'Scope.exe')
        end
        object ReadIntBox: TComboBox
          Left = 87
          Top = 56
          Width = 81
          Height = 21
          ItemHeight = 13
          TabOrder = 1
          Text = '1000'
          OnChange = ReadIntBoxChange
          Items.Strings = (
            '250'
            '500'
            '1000'
            '1500'
            '2000'
            '5000')
        end
        object EqSys1: TComboBox
          Left = 87
          Top = 87
          Width = 81
          Height = 21
          ItemHeight = 13
          ItemIndex = 0
          TabOrder = 2
          Text = 'Local'
          Items.Strings = (
            'Local'
            'B1950'
            'J2000'
            'J2050')
        end
      end
      object ProductInfoBox: TGroupBox
        Left = 192
        Top = 1
        Width = 97
        Height = 89
        Caption = 'Product Info'
        TabOrder = 7
        object QueryFirmwareButton: TButton
          Left = 16
          Top = 25
          Width = 65
          Height = 33
          Caption = 'Query'
          TabOrder = 0
          OnClick = QueryFirmwareButtonClick
        end
      end
      object RadioGroup2: TRadioGroup
        Left = 8
        Top = 125
        Width = 281
        Height = 45
        Caption = 'Display Precision'
        Columns = 2
        ItemIndex = 0
        Items.Strings = (
          'Low ( ddd:mm )'
          'High ( ddd:mm:ss )')
        TabOrder = 3
        OnClick = RadioGroup2Click
      end
      object GroupBox7: TGroupBox
        Left = 8
        Top = 176
        Width = 281
        Height = 49
        Caption = 'High Precision Pointing'
        TabOrder = 4
        object CheckBox1: TCheckBox
          Left = 8
          Top = 18
          Width = 65
          Height = 17
          Caption = 'Use HPP'
          Enabled = False
          TabOrder = 0
          OnClick = CheckBox1Click
        end
        object Button3: TButton
          Left = 76
          Top = 16
          Width = 75
          Height = 25
          Caption = 'Switch HPP'
          Enabled = False
          TabOrder = 1
          OnClick = Button3Click
        end
        object HPP: TEdit
          Left = 156
          Top = 16
          Width = 97
          Height = 21
          ReadOnly = True
          TabOrder = 2
        end
      end
      object CheckBox2: TCheckBox
        Left = 24
        Top = 348
        Width = 129
        Height = 17
        Caption = 'Form always visible'
        TabOrder = 5
        OnClick = CheckBox2Click
      end
      object CheckBox5: TCheckBox
        Left = 24
        Top = 328
        Width = 165
        Height = 17
        Caption = 'Record protocol to a trace file'
        TabOrder = 6
        OnClick = CheckBox5Click
      end
    end
    object TabSheet3: TTabSheet
      Caption = 'Comm Settings'
      ImageIndex = 2
      object GroupBox4: TGroupBox
        Left = 8
        Top = 4
        Width = 257
        Height = 200
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
          Top = 49
          Width = 37
          Height = 13
          Caption = 'Speed :'
        end
        object Label8: TLabel
          Left = 24
          Top = 98
          Width = 32
          Height = 13
          Caption = 'Parity :'
        end
        object Label9: TLabel
          Left = 24
          Top = 73
          Width = 49
          Height = 13
          Caption = 'Data Bits :'
        end
        object Label10: TLabel
          Left = 24
          Top = 123
          Width = 48
          Height = 13
          Caption = 'Stop Bits :'
        end
        object Label13: TLabel
          Left = 24
          Top = 147
          Width = 66
          Height = 13
          Caption = 'Timeout [ms] :'
        end
        object Label18: TLabel
          Left = 24
          Top = 172
          Width = 79
          Height = 13
          Caption = 'Interval Timeout '
        end
        object PortSpeedbox: TComboBox
          Left = 120
          Top = 45
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
          Top = 94
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
          Top = 69
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
          Top = 119
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
          Top = 143
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
          Top = 168
          Width = 113
          Height = 21
          ItemHeight = 13
          TabOrder = 6
          Text = 'IntTimeOutBox'
          Items.Strings = (
            '10'
            '50'
            '100'
            '150'
            '200'
            '250'
            '500')
        end
      end
      object Button2: TButton
        Left = 88
        Top = 304
        Width = 89
        Height = 25
        Caption = 'Save Setting'
        TabOrder = 1
        OnClick = SaveButton1Click
      end
      object Panel2: TPanel
        Left = 8
        Top = 208
        Width = 257
        Height = 89
        TabOrder = 2
        object Label17: TLabel
          Left = 17
          Top = 4
          Width = 215
          Height = 78
          Alignment = taCenter
          Caption = 
            'Interface for LX200 like system.'#13#10'Will work with all systems usi' +
            'ng same protocol'#13#10'PJ Pallez Nov 1999'#13#10'P. Chevalley Feb 2002'#13#10'Ren' +
            'ato Bonomini Jul 2004'#13#10'Version 2.0'
        end
      end
    end
  end
  object Timer1: TTimer
    Enabled = False
    OnTimer = Timer1Timer
    Top = 376
  end
end
