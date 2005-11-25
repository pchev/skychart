object f_config_time: Tf_config_time
  Left = 0
  Top = 0
  Width = 490
  Height = 440
  TabOrder = 0
  object pa_time: TPageControl
    Left = 0
    Top = 0
    Width = 490
    Height = 440
    ActivePage = t_time
    Align = alClient
    TabOrder = 0
    object t_time: TTabSheet
      Caption = 't_time'
      TabVisible = False
      object Label142: TLabel
        Left = 224
        Top = 50
        Width = 42
        Height = 13
        Caption = 'Seconds'
      end
      object Label147: TLabel
        Left = 0
        Top = 0
        Width = 59
        Height = 13
        Caption = 'Time Setting'
      end
      object CheckBox1: TCheckBox
        Left = 40
        Top = 24
        Width = 177
        Height = 17
        Caption = 'Use system time'
        TabOrder = 0
        OnClick = CheckBox1Click
      end
      object CheckBox2: TCheckBox
        Left = 40
        Top = 48
        Width = 129
        Height = 17
        Caption = 'Auto-refresh every '
        TabOrder = 1
        OnClick = CheckBox2Click
      end
      object Panel7: TPanel
        Left = 32
        Top = 216
        Width = 409
        Height = 65
        TabOrder = 2
        object Label134: TLabel
          Left = 8
          Top = 31
          Width = 97
          Height = 13
          Caption = 'Local Time   =  UT +'
        end
        object Label148: TLabel
          Left = 8
          Top = 8
          Width = 51
          Height = 13
          Caption = 'Time Zone'
        end
        object Label149: TLabel
          Left = 200
          Top = 32
          Width = 146
          Height = 13
          Caption = '(Negative West of GreenWich)'
        end
        object tz: TFloatEdit
          Left = 120
          Top = 26
          Width = 41
          Height = 22
          Hint = '-12..12'
          ParentShowHint = False
          ShowHint = True
          TabOrder = 0
          OnChange = tzChange
          MinValue = -12
          MaxValue = 12
          Digits = 3
          NumericType = ntFixed
        end
      end
      object Panel8: TPanel
        Left = 32
        Top = 288
        Width = 409
        Height = 97
        TabOrder = 3
        object Label135: TLabel
          Left = 8
          Top = 33
          Width = 51
          Height = 13
          Caption = 'DT - UT  : '
        end
        object Tdt_Ut: TLabel
          Left = 77
          Top = 33
          Width = 24
          Height = 13
          Caption = '0000'
        end
        object Label136: TLabel
          Left = 115
          Top = 33
          Width = 42
          Height = 13
          Caption = 'Seconds'
        end
        object Label150: TLabel
          Left = 8
          Top = 8
          Width = 212
          Height = 13
          Caption = 'Dynamic Time difference with Universal Time'
        end
        object CheckBox4: TCheckBox
          Left = 8
          Top = 64
          Width = 193
          Height = 17
          Caption = 'Use another DT-UT value'
          TabOrder = 0
          OnClick = CheckBox4Click
        end
        object dt_ut: TLongEdit
          Left = 208
          Top = 61
          Width = 105
          Height = 22
          Hint = '-99999999..99999999'
          Enabled = False
          ParentShowHint = False
          ShowHint = True
          TabOrder = 1
          OnChange = dt_utChange
          Value = 0
          MinValue = -99999999
          MaxValue = 99999999
        end
      end
      object LongEdit2: TLongEdit
        Left = 176
        Top = 45
        Width = 41
        Height = 22
        Hint = '0..86400'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 5
        OnChange = LongEdit2Change
        Value = 1
        MaxValue = 86400
      end
      object Panel9: TPanel
        Left = 32
        Top = 72
        Width = 409
        Height = 137
        TabOrder = 4
        object Label137: TLabel
          Left = 8
          Top = 70
          Width = 23
          Height = 13
          Caption = 'Time'
        end
        object Label139: TLabel
          Left = 112
          Top = 52
          Width = 9
          Height = 13
          Caption = 'M'
        end
        object Label141: TLabel
          Left = 152
          Top = 52
          Width = 7
          Height = 13
          Caption = 'S'
        end
        object Label138: TLabel
          Left = 56
          Top = 52
          Width = 8
          Height = 13
          Caption = 'H'
        end
        object Label143: TLabel
          Left = 56
          Top = 6
          Width = 7
          Height = 13
          Caption = 'Y'
        end
        object Label144: TLabel
          Left = 112
          Top = 6
          Width = 9
          Height = 13
          Caption = 'M'
        end
        object Label145: TLabel
          Left = 152
          Top = 6
          Width = 8
          Height = 13
          Caption = 'D'
        end
        object Label140: TLabel
          Left = 8
          Top = 22
          Width = 23
          Height = 13
          Caption = 'Date'
        end
        object BitBtn4: TBitBtn
          Left = 256
          Top = 104
          Width = 137
          Height = 25
          Caption = 'Actual system time'
          TabOrder = 0
          OnClick = BitBtn4Click
        end
        object ADBC: TRadioGroup
          Left = 216
          Top = 12
          Width = 89
          Height = 33
          Columns = 2
          Items.Strings = (
            'AD'
            'BC')
          TabOrder = 1
          OnClick = DateChange
        end
        object d_year: TSpinEdit
          Left = 56
          Top = 19
          Width = 57
          Height = 22
          MaxValue = 20000
          MinValue = 0
          TabOrder = 2
          Value = 2003
          OnChange = DateChange
        end
        object d_month: TSpinEdit
          Left = 112
          Top = 19
          Width = 41
          Height = 22
          MaxValue = 12
          MinValue = 1
          TabOrder = 3
          Value = 1
          OnChange = DateChange
        end
        object d_day: TSpinEdit
          Left = 152
          Top = 19
          Width = 41
          Height = 22
          MaxValue = 31
          MinValue = 1
          TabOrder = 4
          Value = 1
          OnChange = DateChange
        end
        object t_hour: TSpinEdit
          Left = 56
          Top = 65
          Width = 41
          Height = 22
          MaxValue = 23
          MinValue = 0
          TabOrder = 5
          Value = 0
          OnChange = TimeChange
        end
        object t_min: TSpinEdit
          Left = 112
          Top = 65
          Width = 41
          Height = 22
          MaxValue = 59
          MinValue = 0
          TabOrder = 6
          Value = 0
          OnChange = TimeChange
        end
        object t_sec: TSpinEdit
          Left = 152
          Top = 65
          Width = 41
          Height = 22
          MaxValue = 59
          MinValue = 0
          TabOrder = 7
          Value = 0
          OnChange = TimeChange
        end
      end
    end
    object t_simulation: TTabSheet
      Caption = 't_simulation'
      ImageIndex = 1
      TabVisible = False
      object Label146: TLabel
        Left = 0
        Top = 0
        Width = 110
        Height = 13
        Caption = 'Time Simulation Setting'
      end
      object stepreset: TSpeedButton
        Left = 96
        Top = 316
        Width = 81
        Height = 25
        Caption = 'Reset '
        Layout = blGlyphTop
        NumGlyphs = 2
        OnClick = stepresetClick
      end
      object Label178: TLabel
        Left = 176
        Top = 213
        Width = 32
        Height = 13
        Caption = 'every  '
      end
      object Label179: TLabel
        Left = 8
        Top = 213
        Width = 77
        Height = 13
        Caption = 'Number of steps'
      end
      object Label180: TLabel
        Left = 8
        Top = 32
        Width = 136
        Height = 13
        Caption = 'Choose which objects to plot'
      end
      object Label56: TLabel
        Left = 8
        Top = 152
        Width = 159
        Height = 13
        Caption = 'Plot the position of moving object.'
      end
      object stepunit: TRadioGroup
        Left = 304
        Top = 171
        Width = 153
        Height = 89
        Caption = 'Step unit'
        Items.Strings = (
          'Days'
          'Hours'
          'Minutes'
          'Seconds')
        TabOrder = 0
        OnClick = stepunitClick
      end
      object stepline: TCheckBox
        Left = 96
        Top = 280
        Width = 281
        Height = 17
        Caption = 'Connection lines between each position '
        TabOrder = 1
        OnClick = steplineClick
      end
      object nbstep: TSpinEdit
        Left = 96
        Top = 208
        Width = 57
        Height = 22
        MaxValue = 100
        MinValue = 1
        TabOrder = 2
        Value = 1
        OnChange = nbstepChanged
      end
      object stepsize: TSpinEdit
        Left = 232
        Top = 208
        Width = 57
        Height = 22
        MaxValue = 999999
        MinValue = 1
        TabOrder = 3
        Value = 1
        OnChange = stepsizeChanged
      end
      object SimObj: TCheckListBox
        Left = 8
        Top = 48
        Width = 257
        Height = 84
        OnClickCheck = SimObjClickCheck
        Columns = 3
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        IntegralHeight = True
        ItemHeight = 16
        Items.Strings = (
          'Sun'
          'Mercury '
          'Venus'
          'Moon'
          'Mars'
          'Jupiter'
          'Saturn'
          'Uranus'
          'Neptune'
          'Pluto'
          'Asteroids'
          'Comets')
        ParentFont = False
        TabOrder = 4
      end
      object AllSim: TButton
        Left = 296
        Top = 56
        Width = 75
        Height = 25
        Caption = 'All'
        TabOrder = 5
        OnClick = AllSimClick
      end
      object NoSim: TButton
        Left = 296
        Top = 88
        Width = 75
        Height = 25
        Caption = 'None'
        TabOrder = 6
        OnClick = NoSimClick
      end
    end
  end
end
