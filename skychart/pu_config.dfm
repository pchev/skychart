object f_config: Tf_config
  Left = 435
  Top = 119
  Width = 652
  Height = 544
  BorderStyle = bsSizeToolWin
  Caption = 'Configuration'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Scaled = False
  OnClose = FormClose
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object TreeView1: TTreeView
    Left = 4
    Top = 16
    Width = 136
    Height = 457
    AutoExpand = True
    HideSelection = False
    Indent = 19
    ReadOnly = True
    RowSelect = True
    SortType = stBoth
    TabOrder = 0
    OnChange = TreeView1Change
    Items.Data = {
      08000000250000000000000000000000FFFFFFFF000000000000000002000000
      0C312D20446174652F54696D65250000000000000000000000FFFFFFFFFFFFFF
      FF00000000000000000C312D20446174652F54696D652B000000000000000000
      0000A0A9754100000000000000000000000012322D2054696D652053696D756C
      6174696F6E27000000FFFFFFFFFFFFFFFFA0A975410000000000000000020000
      000E322D204F627365727661746F7279270000000000000000000000FFFFFFFF
      FFFFFFFF00000000000000000E312D204F627365727661746F72792300000000
      00000000000000FFFFFFFFFFFFFFFF00000000000000000A322D20486F72697A
      6F6E2E0000000000000000000000A0A975410000000000000000060000001533
      2D2043686172742C20436F6F7264696E617465732E0000000000000000000000
      FFFFFFFFFFFFFFFF000000000000000015312D2043686172742C20436F6F7264
      696E617465732B0000000000000000000000A0A9754100000000000000000000
      000012322D204669656C64206F6620766973696F6E2600000000000000000000
      00A0A975410000000000000000000000000D332D2050726F6A656374696F6E29
      0000000000000000000000A0A9754100000000000000000000000010342D204F
      626A6563742046696C74657228000000FFFFFFFFFFFFFFFFA0A9754100000000
      00000000000000000F352D20477269642053706163696E672700000000000000
      00000000FFFFFFFFFFFFFFFF00000000000000000E362D204F626A656374204C
      697374260000000000000000000000A0A975410000000000000000050000000D
      342D20436174616C6F67756573260000000000000000000000FFFFFFFFFFFFFF
      FF00000000000000000D312D20436174616C6F67756573210000000000000000
      000000FFFFFFFFFFFFFFFF000000000000000008322D20537461727323000000
      0000000000000000FFFFFFFFFFFFFFFF00000000000000000A332D204E656275
      6C6165240000000000000000000000FFFFFFFFFFFFFFFF00000000000000000B
      342D204F62736F6C657465240000000000000000000000FFFFFFFFFFFFFFFF00
      000000000000000B352D2045787465726E616C280000000000000000000000A0
      A975410000000000000000040000000F352D20536F6C61722053797374656D28
      0000000000000000000000FFFFFFFFFFFFFFFF00000000000000000F312D2053
      6F6C61722053797374656D230000000000000000000000A0A975410000000000
      000000000000000A322D20506C616E657473220000000000000000000000A0A9
      754100000000000000000000000009332D20436F6D6574732500000000000000
      00000000A0A975410000000000000000000000000C342D2041737465726F6964
      73230000000000000000000000A0A975410000000000000000090000000A362D
      20446973706C6179230000000000000000000000FFFFFFFFFFFFFFFF00000000
      000000000A312D20446973706C6179210000000000000000000000A0A9754100
      000000000000000000000008322D20466F6E7473210000000000000000000000
      A0A9754100000000000000000000000008332D20436F6C6F7230000000000000
      0000000000FFFFFFFFFFFFFFFF000000000000000017342D20536B7920426163
      6B67726F756E6420436F6C6F72290000000000000000000000FFFFFFFFFFFFFF
      FF000000000000000010352D204E6562756C616520436F6C6F72210000000000
      000000000000A0A9754100000000000000000000000008362D204C696E657322
      0000000000000000000000A0A9754100000000000000000000000009372D204C
      6162656C73340000000000000000000000FFFFFFFFFFFFFFFF00000000000000
      001B382D2046696E64657220636972636C652028457965706965636529320000
      000000000000000000FFFFFFFFFFFFFFFF000000000000000019392D2046696E
      6465722072656374616E676C65202843434429220000000000000000000000A0
      A9754100000000000000000100000009372D20496D6167657322000000000000
      0000000000FFFFFFFFFFFFFFFF000000000000000009312D20496D6167657322
      000000FFFFFFFFFFFFFFFFA0A9754100000000000000000300000009382D2053
      797374656D220000000000000000000000FFFFFFFFFFFFFFFF00000000000000
      0009312D2053797374656D22000000FFFFFFFFFFFFFFFFA0A975410000000000
      0000000000000009322D20536572766572250000000000000000000000FFFFFF
      FFFFFFFFFF00000000000000000C332D2054656C6573636F7065}
  end
  object CancelBtn: TButton
    Left = 462
    Top = 476
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 1
  end
  object OKBtn: TButton
    Left = 302
    Top = 476
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 2
  end
  object HelpBtn: TButton
    Left = 542
    Top = 476
    Width = 75
    Height = 25
    Caption = '&Help'
    TabOrder = 3
  end
  object Applyall: TCheckBox
    Left = 120
    Top = 480
    Width = 177
    Height = 17
    Caption = 'Apply Change To All Chart'
    Checked = True
    State = cbChecked
    TabOrder = 4
  end
  object next: TButton
    Left = 32
    Top = 476
    Width = 25
    Height = 25
    Caption = '>'
    TabOrder = 5
    OnClick = nextClick
  end
  object previous: TButton
    Left = 8
    Top = 476
    Width = 25
    Height = 25
    Caption = '<'
    TabOrder = 6
    OnClick = previousClick
  end
  object Apply: TButton
    Left = 382
    Top = 476
    Width = 75
    Height = 25
    Caption = 'Apply'
    TabOrder = 7
    OnClick = ApplyClick
  end
  object topmsg: TPanel
    Left = 0
    Top = 0
    Width = 644
    Height = 16
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 8
  end
  object PageControl1: TPageControl
    Left = 144
    Top = 16
    Width = 490
    Height = 455
    ActivePage = s_display
    TabOrder = 9
    object s_time: TTabSheet
      Caption = 's_time'
      TabVisible = False
      object pa_time: TPageControl
        Left = 0
        Top = 0
        Width = 482
        Height = 445
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
              Width = 142
              Height = 13
              Caption = '(Negative East of GreenWich)'
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
              Left = 40
              Top = 104
              Width = 177
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
              OnClick = DateChange2
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
              OnChange = DateChange2
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
              OnChange = DateChange2
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
              OnChange = DateChange2
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
              OnChange = TimeChange2
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
              OnChange = TimeChange2
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
              OnChange = TimeChange2
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
            Left = 256
            Top = 228
            Width = 145
            Height = 25
            Caption = 'Reset to single date'
            Layout = blGlyphTop
            NumGlyphs = 2
            OnClick = stepresetClick
          end
          object Label178: TLabel
            Left = 8
            Top = 258
            Width = 32
            Height = 13
            Caption = 'every  '
          end
          object Label179: TLabel
            Left = 8
            Top = 213
            Width = 110
            Height = 13
            Caption = 'Number of computation'
          end
          object Label180: TLabel
            Left = 8
            Top = 56
            Width = 306
            Height = 13
            Caption = 
              'Plot the moving object position for a number of consecutive date' +
              '.'
          end
          object Label56: TLabel
            Left = 8
            Top = 96
            Width = 115
            Height = 13
            Caption = 'For the following object :'
          end
          object stepunit: TRadioGroup
            Left = 8
            Top = 296
            Width = 417
            Height = 49
            Caption = 'Step unit'
            Columns = 4
            Items.Strings = (
              'Days'
              'Hours'
              'Minutes'
              'Seconds')
            TabOrder = 0
            OnClick = stepunitClick
          end
          object stepline: TCheckBox
            Left = 8
            Top = 360
            Width = 417
            Height = 17
            Caption = 'Connection lines between each position '
            TabOrder = 1
            OnClick = steplineClick
          end
          object nbstep: TSpinEdit
            Left = 144
            Top = 208
            Width = 57
            Height = 22
            MaxValue = 100
            MinValue = 1
            TabOrder = 2
            Value = 1
            OnChange = nbstepChange
          end
          object stepsize: TSpinEdit
            Left = 144
            Top = 256
            Width = 57
            Height = 22
            MaxValue = 999999
            MinValue = 1
            TabOrder = 3
            Value = 1
            OnChange = stepsizeChange
          end
          object SimObj: TCheckListBox
            Left = 144
            Top = 96
            Width = 241
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
        end
      end
    end
    object s_observatory: TTabSheet
      Caption = 's_observatory'
      ImageIndex = 1
      TabVisible = False
      object pa_observatory: TPageControl
        Left = 0
        Top = 0
        Width = 482
        Height = 445
        ActivePage = t_horizon
        Align = alClient
        TabOrder = 0
        object t_observatory: TTabSheet
          Caption = 't_observatory'
          TabVisible = False
          object Latitude: TGroupBox
            Left = 8
            Top = 85
            Width = 185
            Height = 60
            Caption = 'Latitude'
            TabOrder = 0
            object Label58: TLabel
              Left = 8
              Top = 16
              Width = 35
              Height = 13
              Caption = 'Degree'
            end
            object Label59: TLabel
              Left = 48
              Top = 16
              Width = 20
              Height = 13
              Caption = 'Min.'
            end
            object Label60: TLabel
              Left = 80
              Top = 16
              Width = 22
              Height = 13
              Caption = 'Sec.'
            end
            object hemis: TComboBox
              Left = 112
              Top = 33
              Width = 65
              Height = 21
              ItemHeight = 13
              TabOrder = 3
              Text = 'North'
              OnChange = latdegChange
              Items.Strings = (
                'North'
                'South')
            end
            object latdeg: TLongEdit
              Left = 8
              Top = 32
              Width = 33
              Height = 22
              Hint = '0..90'
              MaxLength = 2
              ParentShowHint = False
              ShowHint = True
              TabOrder = 0
              OnChange = latdegChange
              Value = 0
              MaxValue = 90
            end
            object latmin: TLongEdit
              Left = 48
              Top = 32
              Width = 25
              Height = 22
              Hint = '0..59'
              MaxLength = 2
              ParentShowHint = False
              ShowHint = True
              TabOrder = 1
              OnChange = latdegChange
              Value = 0
              MaxValue = 59
            end
            object latsec: TLongEdit
              Left = 80
              Top = 32
              Width = 25
              Height = 22
              Hint = '0..59'
              MaxLength = 2
              ParentShowHint = False
              ShowHint = True
              TabOrder = 2
              OnChange = latdegChange
              Value = 0
              MaxValue = 59
            end
          end
          object Longitude: TGroupBox
            Left = 192
            Top = 85
            Width = 185
            Height = 60
            Caption = 'Longitude'
            TabOrder = 1
            object Label61: TLabel
              Left = 8
              Top = 16
              Width = 35
              Height = 13
              Caption = 'Degree'
            end
            object Label62: TLabel
              Left = 48
              Top = 16
              Width = 20
              Height = 13
              Caption = 'Min.'
            end
            object Label63: TLabel
              Left = 80
              Top = 16
              Width = 22
              Height = 13
              Caption = 'Sec.'
            end
            object long: TComboBox
              Left = 112
              Top = 33
              Width = 65
              Height = 21
              ItemHeight = 13
              ItemIndex = 1
              TabOrder = 3
              Text = 'East'
              OnChange = longdegChange
              Items.Strings = (
                'West'
                'East')
            end
            object longdeg: TLongEdit
              Left = 8
              Top = 32
              Width = 33
              Height = 22
              Hint = '0..180'
              MaxLength = 4
              ParentShowHint = False
              ShowHint = True
              TabOrder = 0
              OnChange = longdegChange
              Value = 0
              MaxValue = 180
            end
            object longmin: TLongEdit
              Left = 48
              Top = 32
              Width = 25
              Height = 22
              Hint = '0..59'
              MaxLength = 2
              ParentShowHint = False
              ShowHint = True
              TabOrder = 1
              OnChange = longdegChange
              Value = 0
              MaxValue = 59
            end
            object longsec: TLongEdit
              Left = 80
              Top = 32
              Width = 25
              Height = 22
              Hint = '0..59'
              MaxLength = 2
              ParentShowHint = False
              ShowHint = True
              TabOrder = 2
              OnChange = longdegChange
              Value = 0
              MaxValue = 59
            end
          end
          object Altitude: TGroupBox
            Left = 376
            Top = 85
            Width = 81
            Height = 60
            Caption = 'Altitude'
            TabOrder = 2
            object Label70: TLabel
              Left = 8
              Top = 16
              Width = 32
              Height = 13
              Caption = 'Meters'
            end
            object altmeter: TFloatEdit
              Left = 8
              Top = 32
              Width = 65
              Height = 22
              Hint = '-500..9000'
              ParentShowHint = False
              ShowHint = True
              TabOrder = 0
              OnChange = altmeterChange
              Decimals = 0
              MinValue = -500
              MaxValue = 9000
              Digits = 5
              NumericType = ntFixed
            end
          end
          object refraction: TGroupBox
            Left = 8
            Top = 145
            Width = 273
            Height = 60
            Caption = 'Atmospheric Refraction'
            TabOrder = 3
            object Label82: TLabel
              Left = 32
              Top = 16
              Width = 81
              Height = 13
              Caption = 'Pressure (millibar)'
            end
            object Label83: TLabel
              Left = 152
              Top = 16
              Width = 102
              Height = 13
              Caption = 'Temperature (Celsius)'
            end
            object pressure: TFloatEdit
              Left = 40
              Top = 32
              Width = 65
              Height = 22
              Hint = '0..1500'
              ParentShowHint = False
              ShowHint = True
              TabOrder = 1
              OnChange = pressureChange
              Decimals = 0
              MaxValue = 1500
              NumericType = ntFixed
            end
            object temperature: TFloatEdit
              Left = 168
              Top = 32
              Width = 65
              Height = 22
              Hint = '-100..100'
              ParentShowHint = False
              ShowHint = True
              TabOrder = 0
              OnChange = temperatureChange
              MinValue = -100
              MaxValue = 100
              NumericType = ntFixed
            end
          end
          object timezone: TGroupBox
            Left = 280
            Top = 145
            Width = 177
            Height = 60
            Caption = 'Time Zone'
            TabOrder = 4
            object Label81: TLabel
              Left = 8
              Top = 28
              Width = 98
              Height = 13
              Caption = 'Local Time =  UTC +'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -11
              Font.Name = 'MS Sans Serif'
              Font.Pitch = fpVariable
              Font.Style = []
              ParentFont = False
            end
            object timez: TFloatEdit
              Left = 122
              Top = 27
              Width = 37
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
          object Obszp: TButton
            Left = 4
            Top = 240
            Width = 41
            Height = 25
            Caption = '+'
            TabOrder = 5
            OnClick = ObszpClick
          end
          object Obszm: TButton
            Left = 4
            Top = 280
            Width = 41
            Height = 25
            Caption = '-'
            TabOrder = 6
            OnClick = ObszmClick
          end
          object Obsmap: TButton
            Left = 4
            Top = 320
            Width = 41
            Height = 25
            Caption = 'Load'
            TabOrder = 7
            OnClick = ObsmapClick
          end
          object ZoomImage1: TZoomImage
            Left = 48
            Top = 208
            Width = 400
            Height = 200
            Cursor = crCross
            Picture.Data = {
              07544269746D6170564E0000424D564E00000000000036000000280000006400
              0000320000000100200000000000204E00000000000000000000000000000000
              0000F2ECE500F0E9E100F1E9E100F1E9E100F1E9E100F0E9E100F1E9E200F0E7
              DF00F0E6DF00F0E8E000F1E9E100F0E8E000F1E8E000F1E9E100F0E8E100F0E8
              E100F0E8E100F0E8E000EFE8E000F0E8E100F0E9E200EFE9E100EFE9E200EFE8
              E100EFE8E000EFE7E000EFE7E000EFE8E000EFE7E000EFE7E000EFE6E000EFE7
              E000F0E8E000F0E7E000F0E7E000EFE7E000EFE8E000EFE8E000EFE8E100EFE8
              E100EFE8E100EFE8E000EFE8E000EFE8E000EFE8E000EFE7E000EFE8E000EFE8
              E000EFE8E100EFE8E100EFE8E100EFE8E100EFE7E000EFE7E000EFE7E000EFE7
              E000EFE7E000EFE7E000F0E7E000F0E7E000F0E7E000F0E8E000F0E8E000EFE7
              E000F0E8E000F0E8E000F0E7E000F0E7E000F0E8E000F0E8E000F0E8E000F0E8
              E000F0E8E000F0E8E100F0E8E100F0E8E100F0E8E000F0E8E000F0E8E000F0E8
              E000F0E8E000F0E8E000F0E8E000F0E8E000F0E8E000F0E8E000F0E8E000F0E8
              E000F0E8E000F0E8E000F0E8E100F0E8E100F0E9E100F0E9E100F0E9E100F1E9
              E100F0E9E200F1E9E200F1E9E200F2ECE500EBDCD700E7D6D200E8D9D700E8D9
              D600E8DBD800E7D8D600E8D8D700E8D7D700EAD9D700E9D9D700EBDDDA00EBDC
              D900EADCDA00E9DBD900E9DCDA00E9DEDB00EADFDC00EADEDB00EADEDA00EADE
              DA00EADEDA00EBE0DC00E9E1DC00EAE1DC00EAE1DD00EADFDB00E8DBD700E7D9
              D500E6D9D500E5D7D400E4D6D400E2D4D200DDCECD00E1D2D000E7D7D500EADF
              DB00E9E0DC00E8DDD900E9DDD900EADEDA00EADEDA00EADFDB00EBDFDB00EADE
              DA00EADFDB00EADFDB00EADFDA00EADEDA00EADEDA00EADDD900EADCD800EBDC
              D800EBDCD900EBDDD900EBDDD900EBDCD900EBDCD900EBDCD900EBDCD900ECDD
              DA00ECDCD900ECDCDA00EDDEDB00EDDFDC00EDE1DD00EEE1DE00EEE2DE00EEE3
              DF00EEE4E000EEE4E000EEE4E000EFE3E000EEE3E000EEE3DF00EEE3DF00EDE3
              DE00EDE2DE00EDE1DD00EDE1DC00ECE0DB00ECE0DB00ECE0DC00ECDFDB00ECE0
              DC00ECE1DD00ECE1DD00ECE2DE00ECE1DD00ECE1DD00ECE1DD00EBE1DD00ECE2
              DD00EDE3DE00EDE3DE00EDE1DD00ECDEDB00E8D8D600E8D8D700E9DCD900EADE
              DA00EDE2DC00E5D9D600E4D8D600E5D9D700E6DAD800E8DBD800E9DBD800E8D5
              D100E7D2CE00E7D1CE00E7D1CE00E9DBD800E9DCD800EADFDC00E9DEDB00E9DE
              DA00E9DFDC00EAE0DC00EBE1DC00EBE0DC00EBE0DC00ECE1DC00EBE0DB00EBE0
              DA00EBE0DB00EBE1DB00EBDFDB00E8DBD700E4D7D500DED1CE00DDCCCA00DAC9
              C700D8C6C500DAC9C800DDCCCA00E1D2D000E3D4D100E4D9D500E3D4D200E7D8
              D500E7D9D700E6D8D500E8DAD700E9DDDA00E9DCD900E9DCD800E9DEDA00E8DF
              DA00E9E1DC00E9E1DB00EAE0DC00EBE1DD00EBE1DC00EBE0DC00ECE0DC00ECE0
              DC00ECE1DC00EDE1DD00EDE2DD00EDE2DD00EDE2DD00EEE3DE00EEE3DE00EFE2
              DE00EEE2DD00EEE3DE00EFE3DF00EFE3DE00EFE1DD00EFE0DC00EFE1DD00EFE2
              DE00F0E4E000EFE4DF00EFE4DF00EFE4DF00EFE4DF00EEE5DF00EEE4DF00EDE4
              DF00EDE4DE00ECE3DE00ECE2DD00ECE1DD00ECE2DE00EBE1DD00EBDFDB00EADF
              DB00EAE0DB00E9DFDA00E9DFDA00E9DEDA00EADFDA00EADCD900E8DAD700EBDF
              DC00ECE2DF00ECE2DE00ECE1DD00EDE3DE007D6D540067563A00655438006654
              380076664E0088796300A5988700B6A99B00E3DAD400EDE6E200EFEAE700EDE6
              E200EDE6E200EEE7E200EDE7E200EDE5E000ECE1DD00ECE1DC00EDE4DF00EDE4
              DF00ECE3DD00ECE1DB00EAE2DD00EBE1DC00EBE2DC00ECE2DC00E8E0DC00E6DB
              D800E2D8D600E0D4D200DED2CE00DBCECB00DACCC700DDCDC900CAB8AF00A994
              8500907B66007D6B52007D6B53007B674D00826D5400A3917F00C5B5AA00E7DA
              D700EBDFDC00ECE2DF00EDE3DF00ECE3DF00EDE5E000EDE5E000EDE6E100EEE6
              E000EDE6E100EEE7E200EEE8E300EEE8E300EFEAE400EFE9E300EEE8E300EFE7
              E200EFE6E100EFE6E100EFE6E100EEE5E000EEE5E100EDE4DF00ECE4DE00ECE3
              DE00ECE2DD00ECE1DD00EDE2DD00EDE2DE00EDE3DF00EEE4DE00EFE4DE00EFE3
              DF00EFE3DE00EFE3DE00EEE4DE00EEE4DE00EDE5E000EDE6E100EDE7E200EDE8
              E300EDE8E300EDE7E200ECE3DE00ECE2DD00ECE2DD00EBE2DD00ECE2DD00EBE2
              DE00ECE2DD00EDE2DD00ECDFDA00E3D4D200B4A6980093846E0093856F008B7C
              650045310E0045310F0046320F0047320F0046320F0046320F0046320F004632
              0F0046320F00503D1C006B5A3E007C6D55007B6A52008C7D6700A5988800AFA4
              95009D8F7C0094856F008E7F6900A79A8B007F6E5500C3B8AE00E8E2DF00DDD7
              D000D4CCC300C6BEB100AC9D8B00A7968400CABCB300CDC0B600E5DDD800EAE4
              DE00E7E0DB007B684E004D35110047320F0045310E0045310E0045300E004531
              0E0045310E0046310F0046320F005F4D30008A7D6900BEB5AC00E0D8D300ECE6
              E000EEE8E200EEE6E000EFE7E200EFE7E200EFE7E100EFE7E200EFE8E200EEE7
              E100EDE4DD00EDE3DC00EDE4DD00EDE4DD00EEE4E000EEE7E400EEE7E300EEE7
              E200EEE6E000EDE3DD00ECE0DA00EADBD500E3CFC900EADCD600EDE2DD00EDE4
              DF00EEE9E300EEE9E300EEE7E200EFE6E000EFE5DF00EEE4DF00EFE5E100EEE5
              E100EDE5E200EDE8E300EFEBE600EFECE800EFEBE500EEE8E200EEE5DE00EDE4
              DD00EDE5E000EDE6E100ECE5E100EDE5E000EDE5E000EDE4DF00EADCD500EAE2
              DD00D5CDC600A89E8F00604E310046320F0046320F0046320F00473310004833
              100049331000493410004833100047331000473310004733100046320F004632
              0F0046320F0046320F0046320F0046320F0046320F0046320F0046320F004632
              0F0046320F00503D1C005F4D2E004E3815004B3511004C3511004C3511004D36
              110058421F00BCB2A600CFC8C000E4DCD700E3DCD700665232004D3611004833
              100046320F0046320F0046320F0046320F0046320F0046320F0046320F004632
              0F0046320F0047320F00554120007B6A510085765E00938671009E907E00998B
              76009E917E00A7978700BBADA200A7978700998774009A887400BCAEA000D7C9
              C100D3C3BC00E2D9D500EEE8E500EFEBE600EFE9E300EFEBE400EFEAE200EEE7
              E000EBE0DA00E6D5D100D6C9C000D2C7BB00EEE8E000EEE8E000EDE6DF00EEE5
              DF00EEE6E100EFE7E300EFE7E600EEE7E400ECE1DD00ECE3E000ECE4E200EDE8
              E400EFEBE600EFEBE500EFE7E200EEE4DE00EEE6E000EFECE800EDE9E600EBE5
              E000E7DFDB00DFD5CF00C0B6A800A293810093836D0076664B00503C1A004733
              10004934100049341000493410004A3410004A3410004934100049330F004933
              100049331000493310004933100049330F0048330F0048330F0048330F004833
              0F0047330F0047330F0047330F0048330F0047330F0047330F0048330F004833
              0F0048330F0048330F0048330F0049330F00493410004B351000553F1C009788
              7400D2C9C400806E53004F3812004B3511004934100049330F0048330F004833
              0F0047330F0047330F0047330F0047330F0047330F0046320F0046320F004733
              0F0047330F0048330F004A34100049341000493310004A341000493310004833
              0F004833100048331000493410004B351100493310004C361200675435007D6B
              5100B1A49300B6ADA0008A7B63006E5B3D0067533300614D2C004D3711005A45
              23009E907E00A89D8C00C5B9AD00BAAC9E00C3B5A800E8DAD700E3D6D500C4B7
              AE00A6958400B7AA9D00C0B4AB00A2948200B4A79A00CAC5BC00D1CBC300C2B9
              AD00B4A99B009C8E7A0085755C00756247005C4726004C3611004B3511004C36
              11004B3511004B3511004B3511004A3410004B3611004B3511004C3611004C36
              11004C3611004C3611004C3611004C3611004C3611004B3511004B3511004A34
              10004A3410004934100049341000483410004834100048341000483410004834
              10004834100048341000483410004934100049341000493410004A3410004A34
              10004A3410004B3511004B3511004C3612005A4522007C6A4F00655130004F38
              12004C3611004D3711004C3611004B3511004A3511004A341000493410004934
              1000493410004934100048341000483410004834100048341000493410004934
              1000493410004834100049341000483410004834100048341000483410004934
              100049341000493410004A3410004A34100049341000493410004A3410004A34
              10004A3511004B3511004B3511004B3511004D3711004C3611004B3511004B35
              11004E3814006E5B3D006F5B40004B3511004B3511004B3511004B3511004B35
              11004B3511004B3511004B3510004B3511004B3511004B3511004B3511004B35
              11004C3611004D3711004D3711004D3711004D3711004C3611004B3511004B35
              11004C3611004C3611004C3611004C3611004C3611004D3711004D3712004E38
              12004F3912004E3812004E3812004D3711004D3711004D3711004C3611004C36
              11004B3611004B3511004B3511004B3511004B3511004B3511004B3511004B36
              11004B3511004B3511004B3511004B3511004B3511004C3611004D3711004E38
              12004D3711004D3711004E3812004E3812004E381200503A13004E3812004F39
              12004F3912004F3912004F3912004B3611004D3711004D3711004C3611004C36
              11004B3611004B3511004B3511004B3511004B3511004A3411004A3511004B35
              11004B3511004A3511004A3511004A3511004A3511004A3511004A3511004A34
              11004B3511004B3511004B3511004B3511004B3611004C3611004F391200513A
              1200513B12004E3812004B3611004C3611004C3611004C3611004C3611004C36
              11004C3611004B3611004B3611004C3611004B3611004B3611004B3511004C36
              11004C3611004C3711004D3712004E3812004E3812004E3812004E3812004C36
              11004B3511004B3511004B3511004C3611004C3711004C3712004D3712004D38
              12004D3812004E3812004F39120050391200503A1200513A1200503A1200513B
              1300513A1300503A12004F391200503A1200503A1200503A1200503912004F39
              12004E3812004E3812004E3812004D3712004C3712004D3712004D3712004D38
              12004E381200503A140055482B0054452500513B1300523B1300513A13004F39
              12004F3912004F391200513A1300543F1700513B13004E3912004E3812004E38
              12004E3812004E3812004E38120050391200513B1300513A1200503A1200503A
              12004E3812004D3712004D3712004E3812004F3912004D3712004C3611004C36
              12004D3812004E3812004E3812004D3712004E3812004D3812004D3812004D38
              120050391200503A1200523B1300533C1300503A12004E3812004E3812004E38
              12004E3912004F3912004F3912004F3912004F3912004E3812004E3812004E38
              12004D3812004D3812004E3812004F3912004F391200503A1300513B13005039
              12004F3912004F3912004F3912004E381200513A12004E3812004C3712004C37
              12004F3912004E3912004E3912004E3912004F391200503A1200503A1200503A
              1200513A1200513B1200523C1300523B1300503A1200513B1200513B1200523C
              1300533C1300543D1300523C1300523C1300513B1200513B1200503A12004F3A
              12004F3A13004F3A1300503A1300513B1300523C13005D5B4B00515A58005841
              1600594014005A472300573F1400553D1400543D1300543D1300543D1300523C
              1300523C1300523C1300513B1300513B1200503A1200513B1200523C1300533C
              1300553D1300553D1300543D1300533C1300523C1300533C1300533C1300523C
              1300523C1300513B13004F3912004F391200513B1300543D1300533C1300513B
              1300513A1200513A13004F3A1200503A1300523B1300553D130059401500553E
              1400523C1300513B1200513A1300513B1200523B1300523C1300523C1300523C
              1300523C1300523C1300523B1300513B1200503A1300513B1300523C1300523C
              1300533C1300523C1300523C1300513B1300513B1200513A1200523B1300523C
              13005840150059401400553D13004F391300553E1400513C1300513B1200513B
              1200523C1300523C1300523C1300523C1300523C1300523C1300523C1300523C
              1300523C1300523C1300533D1300543D1300553D1300563E1400563E1400553D
              1400543D1300533D1300533C1300533C1300533C1300533C1300533D1300543D
              1300563E140072797A0064759000575041005B4315005A411500563E1400513B
              1300503B1300513B1300523C1300513B1200513B1200523C1300533C1300533C
              1300543D1300543D1300563E1400563E1400553D1400553D1300543D1300543D
              1300553E1400533D1300523C1300523C1300523C1300513C1300533C1300543D
              1300533D1300543D1300543D1300543D1300543D1300533D1300533C1300563E
              140059411500624A2000573F1400553E1400553D1400543D1300543D1300543D
              1300553E1400563E1400563E1400553E1400553D1400553D1300553D1300543D
              1300543D1300543D1300553D1300553D1300553D1300533D1300543D1400563E
              1400533C1300523C1300523C1300543D13005A4216005A411500594114005941
              14005A42160058401500553E1400533D1300533D1300543D1400553D1400543D
              1300533D1300533D1300533D1300533D1300543D1300543D1300553D1400553E
              1400563F1400573F14005840150058401500573F1400563F1400563E1400563E
              1400563E1400563F1400573F1400573F14005840140076766700768CA9005E63
              65005E4516005B431500543D1300523C1300533C1300533D1300533D1300533D
              1300533D1300543D1300553E1400563E1400563F14005840140057401400573F
              1400573F1400563F1400553E1400563E1400553E1400543D1400543D1400543D
              1400543D1300533C1300533D1300573F140059411500594115005A4115005941
              150058411500563E1400553D1400543D1400573F1400573F1400573F1400573F
              1400573F1400573F140057401400584015005840150057401400573F1400563F
              1400563E1400563E1400563E1400553E1400553E1400553D1400553D1400553E
              1400553E1400553D140058421700573F1400553E1400543D1400543D1300553E
              14005B583B005C6650005C4316005A4215005B4215005A421500594115005740
              1400563F1400563E1400563F1400563F1400553E1400553E1400553E1400553E
              1400563E1400563F1400573F14005840150058401500594114005A4215005A42
              1500594114005841150058401500584115005941150059411500594115005941
              140059411400635F4400758BA4005E7396005A4E3700614717005B421500553E
              1400553E1400553E1400553E1400553E1400563F1400573F1400584015005840
              1500594114005A4215005941150059411500584115005841150058411500563F
              1400573F140057401400573F1400563F14005740140059411500563F1400573F
              1400584015005A4215005A4215005A4215005941140057401500563E1400563E
              14005740150058401500584114005A4215005A4215005A4215005A4215005A41
              1500594114005841140058401500584015005740150057401500573F1400573F
              1400563F1400563E1400563E1400563E1400563F140058401500555533005846
              1E00573F1400573F1500573F1400574015005C431600615A38005C5D3F005B45
              19005A4215005840140058411400594215005840140058411400584014005840
              1400574014005740140058401400584114005841140059411500594215005A42
              1500594215005A4215005C4416005C4416005B4315005A4215005A4215005B43
              16005B4316005A4215005A4215005A4215005A421500524E3000748CA3004F67
              8F004C66850054707800614D21005B4315005841150058401400584115005841
              150059411500594215005A4215005A4215005B4315005C4416005B4316005B43
              16005B4315005941150058411400584115005841140058411400594215005A43
              1500594215005B431600594215005942150058401400594215005C4416005C44
              16005B43160059421500584014005841150059421500594215005A4215005D44
              16005B4316005A4215005B4215005A4215005A42150059421500594115005841
              1500584115005841150058411400584114005740140057401400573F15005840
              15005B471E0051676700516B5F00595936005941150059411500594115005D44
              160060461700604617005C5D40005D522C005942150059411500594215005942
              15005942150059421500594215005942150059421500594215005A4215005A43
              15005B4315005C4416005C4416005C4416005C4416005D4517005E4517005E45
              17005D4517005D4517005D4517005D4517005C4416005C4416005C4416005C44
              16005C4416005C461A008093A300597697004C6E8A004B727D005C6F7000604D
              28005D4516005B4316005A4315005A4315005B4316005D4416005B4316005C44
              16005C4416005D4517005D4516005C4416005D4416005C4416005B4315005942
              15005A4215005B4315005E45170063655A00646453005B5332005C4416005F46
              17005A4215005A431500604717005C4416005C4416005D4416005A4315005A43
              15005B4315005B4316005C4416005E4517005E4517005D4416005D4416005B43
              16005B4316005B4316005A421500594215005B4316005E461800526E5E00595F
              49005D5330005F461700624817005C56380052676800496C8C004C7B9C005A8D
              95005B461B005B4315005E451700624817006047180061481800604B1F005F46
              17005F4617005A4316005B4316005B4316005B4316005B4316005C4416005C44
              16005C4416005C4416005D4516005E4517005E4517005E4617005E4617005F46
              17005F461700604717006147180061471800604717005F4617005F4617005F46
              1700604717005F4617005E4617005E4617005E4617005D4517009DAAB8006A86
              A200566B8B00425F70004F738F0053667400644E2100604717005F4617006047
              1700624818005F4617005D4517005D4517005D4517005F461700604718005E46
              17005D4517005D4517005F4717005C4416005C4416005F46170068552F007F9C
              BA007D9AB900749BA60064684E00624818005D4517005D451700624918005E46
              17005C4516005D4517005E4617005D4516005D4517005D4517005F4617006047
              17005E4617005F461700624818006047180062481800614818005D4517005C44
              16005B4316005F481B005A8A9E005D909900538A9E0057809B00547187004F76
              9C006286AC005A85B100427484004B878E005A6951005E461700634918006349
              180062481800614818006047170060471700664B19005E4617005D4517005D45
              17005D4517005E4617005E4617005E4617006047170062481800624818006047
              1700614718006148180061481800624818006349180063491800644A1800634A
              1800634A18006349180063491800624918006249180062491800624818006148
              180061481800614718008D9597008AA1B900455B7100456473004A748300618B
              9700636A5500664B19006349180060471800604717005F4718005E4617005F46
              170060471700614818006349180061471800604717005F461700604717006148
              18005F461700634918007E8892008DADCE007EA0C0006D92A7006A8A9C00664F
              22006248180060471700654D1D00624818005D4517005E4617005E4617006047
              1800614718006248180062491800614718006047180060471700624918005F46
              170060471700614718005F4617005E4617005F4617005F5B3D00679CBD00669F
              B300629CB1006497B4006694B4005881AE006C8EB600527599004B7F8D004E8E
              98005B72620061481800654B1900654B1900644A190063491800614818006148
              1800694E1A00614918005F4717005F4718006048180062481800624818006249
              1800624918006349180062491800634A1800644B1800654B1900644B1900654B
              1900654B1900664B1900654B1900644B1900644B1900644A1900644A1800644A
              1800644A1800644A1800644B1900644A180062491800634A180080868000A1B5
              CD00435D690042657200507D8800548C8E0057868400646E550066552C00644B
              19006249180060481800604718006147180062491800634A1800654B19006349
              1800614818006047180060471800654B1900634918006A4F1C00839EBB007FA7
              CB00799FC1006B8EAC006583A100576B6E00664C1900654B190069969900645D
              390061481800624918006249180063491800644A1800654B1900634A18006349
              18006249180062491800644A180061481800604718005F471800614818006249
              1800644A1800666650005F92AE006A99B7006C9AC20074A3CD0077A8D1005F96
              B3005985B100557AAC00578FA600588A8F006A562700674C1900694E1A00674D
              1A006A511F00654B1900634A1800644A18006C501B00694F1B0062491900634A
              1900634A1900644B1900654B1900654B1900654C1900654C1900664C1900674D
              1A00684D1A00664C1900664C1900674C1900674D1A00684D1A00684E1A00674D
              1A00664C1900664C1900654C1900654C1900654C1900654C1900654C1900674D
              1900654B1900644B190082837600A7BECF00567A8900406C750048787E004F8D
              92005D929D005F959D005A7E84006B501B00664C1900644B1900634919006349
              1900644A1900664C1900684D1A00664C1900644B1900634A190062491900644A
              1900674D1A00766E5B007596B600779EBE007299B5007195B3007699B9005974
              76006B521F006A4F1A0065837B00697D6900644A1900674E1C00674D1A00684D
              1A00694E1A00674D1A00654C1900644B1900634A1900644B1900674D1900644A
              190063491900614818006249180063491900644B19006D511B006A5D38006877
              730070A4C80075A7D3006D9ECB005D8BB8005881B2005A85B20064939D006D5F
              34006E511B006B4F1A006C501B006D54240069501D006A4F1B00694E1A006950
              1D006F531C006E521B00664C1A00654C1900654C1900664C1A00674D1A00684E
              1A006A501C006D521B006D511B006B501B00684D1A00694E1A00694E1A006A4F
              1B006A4F1B006B4F1B006C501A006A4F1B00694F1A00694E1A00694F1A00694E
              1A00684E1A00684D1A00674D1A00674D1A006A501C0087846F00A1BBC900688B
              8A003C696B003F75790042797B0051909200609CA6006196A8006494AB006857
              2B00684D1A00664C1A00654B1900654C1900674D1A006A4F1A006B501B00694F
              1A00684D1A00664C1900644B1900644B1900684D1A00738080006C95A9006E99
              B0006F98B1006C92A5006D98AC005C8A970057827E0069572A0066664B00698C
              8A00684E1A00684D1A006D521B006A4F1B006B501B00694E1A00664C1A00664C
              1A00654C1A00664C1A006A4F1A00654C1900654B1900644B1900644B1900644B
              1900644B1900694E1A00684E1A0071551E00677770006E9CBC004E7B9B004E70
              8400675F420059727F006B735B0071541C006C501B006C501A00694F1A00684E
              1A006D5524006B501A006C511B006F59280070541C006B501B006A511D00674E
              1A006B501B006A4F1B00684D1A00684E1A006A4F1B006A4F1B006A4F1B006B50
              1A006B501A006B501A006C501A006C501A006C511B006D511B006E521B006D52
              1B006C511B006B501A006C501A006C511B006C501A006B501A006A4F1A00694E
              1B007C7455007DA6AE00537B7600365F5D003565610041807A00437C73003D73
              6C00478688006698AD006D9EBB00666C51006A4F1B00684E1A00674D1A00674D
              1A00694F1B006C511B006D521B006B501A006B501B00684E1A00664D1900674D
              1A006A4F1B0070694A006694A3005F909E005F8DA1005F8E9C00699AA7006E92
              97005991A000685F3A006E531D006E623A006B4F1B006A4F1B006E521B006E52
              1B006D521B006C501B00684E1A00674D1A00684E1B00694F1B006B501B00674D
              1A00694E1A00684E1A00694E1A00684E1A00694F1A00694E1A00674D1A006E52
              1C0075581E00745A24005E6D61005A67560076581E0067674C0070541C006C51
              1B006D521D006F531C006E521C006C501B006F531D006E521B006E531C006F53
              1C006B501B006C501B006C511B006D511B006E531C006C511B006A4F1A006B50
              1B006B501B006B501B006D511B006F531C006D511B006C511B006D511B006D52
              1B006D511B006D511B006E531C006F541C006F531C006D521B006D521B006E53
              1B006D521B006D511B006D511B006F541E0081A09B0035675F002C554D002B59
              53002C605A002C635B003D7568003D7568003C777600598E9B006C9DBF0073A9
              C2006E6139006A4F1B00694F1B00694F1B006C501B006E531B0070541C006E52
              1B006D511B006B501B00694F1A006A4F1B006C511B006A603C0063909C00698E
              AC00678FAA006790A3006D98A0006999A50056879300705723006E521B006E52
              1B006E521B006E531B0072561D0070541C006F531C0070541C006C511B006A4F
              1A006A501B006A501B006C511B006A4F1B006A4F1A006A4F1B00694F1B006C54
              20006B5F34006F613600725C290075612F0076663800765C2500775B2100785A
              1F00715C2E0065665200736D4A007369440071551D0071572200735D2B007054
              1D006F531C006C511B006A501B006C511B006A501B006B501B006B511B006C51
              1B006F531C006C511B006C511B006C511B006C511B006D521C006E521C006E53
              1C006E521C006D521C006E521C006E521C006E531C006E531C006F541C007055
              1D0071551D0070541C0070541C0070541C006F541C006F541C0070541C007374
              5A00629293002E5B57002B554F002E5C5A00325F5C0031615E0030676100326D
              6300336F67003D797800629CAD0070929D00705F33006C511B006B501B006B50
              1B006D521B006F541C0071551D006F541C006D521B006E521C006D521B006D51
              1B0071551D0056675100507F7D00628DA5006693AB006594A7006C999C006FA2
              B5006789970073571F006E531C006D521B006F531C0075581E0070551C006F54
              1C0070541C0072551D0070541C006C511B006C511B006C511B006E521C006D51
              1B006C511B006C511B00716337007070540076622E00775E2700785C21007766
              3B007259250070551E007358220077673A006F7F7B006996A7007A8A7D007461
              3200725E2E00765C270075581E0072561D0071551D006F541C006C511B006B51
              1B006C511B006D521B006D521B006D521B006D521B006D521B006E531C006E53
              1C006E531C006F541C006F541C006F541C006F541C006F541C006F541C006F53
              1C006F541C0070541C0070541C0070551D0071551D0072561D0072561D007256
              1D007359230075581E0074571E007D7352005F908F00305F5D00336261003F6A
              6C00446D73003E696D00406D6E003966630047675E00646B5200706339007257
              1F006F541C006F531C006F531C006F531C006F531C0070551C0071551D006F54
              1C006E531C006E531C006F541C0071551D00675F3B004D7C7C00507F86005986
              9900598FA1005E959E0072A6A8007C958C00699DAF006764550070551D006E52
              1C006E531C006F541C006F541C006F541C0072561D0071551D0071551D006E53
              1C006E531C006F531C0070541C006F531C006F531C0075602E005C8186007465
              3C006B6A5100517184006B6D54007E877100765C26007A643300766C4800746F
              4D006E705800725F3000765A2000745920007358200076591E0074581E007054
              1C0070551D0070541C006F541D006D521B006D521B006D521B006D511B006D52
              1B006E531B0070541C0071551D006F541C006F541C006F541C006F541C006F54
              1C006F541C006F541C006F541C006F541C0070541D0071551D0071551D007156
              1D0072561D0073571E0073571E0074571E0076591E0076591E0074571E00775D
              2700829A9200548A8D00467779004C7A7B00508383004B7D7F004B858400547D
              7F00795E240073571E0070551C0070541C0071551D0073571E0072561D007155
              1D006F541C006F541C006F541C006F541C006E531C006E531B006F541C007357
              1E0071684200508185004E828A004D808B0044838C005694A0006FA4B50080A7
              C1007093B2005C769E006562580071551D006E531B006F541C006F541C007155
              1D0073571E0071551D0076581E0071551D006F541C006F541C0071551D007155
              1D0073581F00707E6E0069766B007C5E22006E694A005E858E006A8886007560
              2D0076602D0078612E0073561D0070551D0070551D0073561D0070541C006F54
              1C0071551D0075581E0073571E0070551D0070541C0070551D006F551E006D51
              1B006E521B006D521B006D511B006E521B006F541C0072561D006F541C006E53
              1B006E531B006E531B006E531B006F541C006F541C0070541C006F541C006F54
              1C0070551D0070551D0071551D0071551D0071561D0073571E0073561D007256
              1D0072561D0075581E0076581E0075581E0085836A0076A1A4004E7781006290
              8C006EA4A3006791950060736000766C470074571E0071551D006F541C007054
              1C0072561D0072561D0070551D0071551D0071551D006E531B00715821007076
              6D00717D76006C766A006E6441006F716800627B8700588691005A819400597D
              92005E8A9C006388A4006183A9006485AA007BA3BD007294BD00678DBA007171
              64006E531B006F541C0072561D0072561D0070551D0071551D0077591E007558
              1E006D5B2B0071551D0072551D0073571E0079683900796B3F00758069007C5D
              20007B5D200075602D0076897900765B23007460310070561F006F541C007054
              1C0070551D0073571D0071551D0072551D0071551D0072561E0071551D006F54
              1C006F541C0070551E006E531B006C511B006B511B006B511B006D521B006E52
              1B006F541C006F531C006D521B006D521B006D521B006D521B006D521B006E52
              1C006E531C006E521C006E531C006F531C006F541C0070541C0070551D007155
              1D0072561D0073561D0071551D0071551D0071551D0072561D006C6539007165
              3A00756E4C00567A79005C838000527772007892920077683D0073571D007054
              1C006E531C006E531C0070541C0070541C006E531C006D521C006D521B006E53
              1C0070541C0075591F005E716000638D9C006188A20052768F005A819B006084
              A8006185A3006087A5005D80A300587D9D006B90B7005F84AD004F729A006082
              A20087B1C8007EA3C30082A4C4008FB3CE00735B280070541C0071551D006F54
              1C006F541C0070541D0076591E0068685000695E370071551C0071561D007558
              1F0077591E0078704B007C5E220074674100795B1F0076591E00785D2400765B
              2300807E64006D5725006C511B006F541D0071561E0072561D0072561D007155
              1E006E531D006D521C006F531C006E531C006F55200070551F006D521B006C51
              1B006B511B006B501B006B501B006C511B006C511B006B501B006B501B006B50
              1B006B501A006B501B006C511B006C511B006C511B006C511B006D511B006E52
              1C006E531C006F541C006F541C0070541C0071551D0072551D0070551D006F54
              1C006F5722006C6D470052715B0075581E0070551D00715C2B00706032007155
              1D0075581F0074581F006D521B006C511B006D521B0070541C006E521C006B50
              1B006A4F1B006A501B006C511B006D511B006E521C00636451004F7388005F83
              A500678DBB006794BF006795BD006FA2C70081B5D500749EC0006992BA00729E
              C70085B2D8007CACD500739EC9005F83B10081A7C0006E7B8800787057007A68
              3F00775E2A0071561E006F531C006F531C006F541C0071551D00735F2F006795
              AB006C5F390071551D0072551D007559210077591E007075570063756D005F8F
              A2007876510070541C0071551D0079663700776940006A501B00694F1B006C51
              1B006D521B006E531C006C511C006A501B00694F1B006B501B006C511B006D52
              1D006E531D006C511B006B511B006A501B006B501B006B501B006A501B006B50
              1B00694F1B00694F1B006A501B00694F1B006A4F1A00694F1A00694F1A006A4F
              1B006A501B006A501B006C501B006D511B006D521B006E521B006E531C006F53
              1C006F541C00705620006F6E4B006A7357005B877A005C785F00646238007558
              1E0073571F0070541C006E531C006D521C0073571F006C511C00694F1B006B50
              1B006E521B006E531B006B501B006A4F1B00694F1B006A501B006C511B007156
              1F006F531C00727972006C92B50077A2C8008AB3D20085B4D20085B3D20082B2
              D50096BFDA00AAC7D80095B8CF008FBAD200A4CEE10095C3DD007FACD1006E93
              C000788FAB0075623A008FB6D10091BBD50086918800766030006F531C006E53
              1B006E531B0070541C006B725D00618BA3005F6C610071561F0071551D007255
              1D006D6948005A7C84005A839A006794960076612D0072561D006E521B007978
              61006E531C006A4F1B00684E1A006B501B006B501B006D521B006F531C006A4F
              1B006A501B00684E1B00694F1B006A501B006A501B006B501B006C511B006C51
              1B00694F1A006A4F1A006B501B00694E1B00684E1B006A4F1B0070582600684E
              1A00674D1A00674D1A00674D1A00674D1A00684D1A00684E1B00694E1B006B50
              1A006B501A006C501A006D511B006E521C006C5B2C0070939100759C9F006B61
              3600675E3400566F5A006C511C006D521C006A633C00736234006F6945006951
              2000684E1A00674D1A00684E1A00684E1B006B501B006D511B00694E1B00674D
              1A00684D1A00694E1B00694E1B006B501B006D521B008487790093B8CD00A4C8
              D900A0C0D40099C0D60091BED90092BEDA009AC2DA009FC4DA0095BACF0082AE
              CA0097C5DC0090BFDA0079A3C700779BC300746C58007D8A920090BDD90087B5
              D40081A9C8007E9DB700735E31006D511B006E531C00705927005E736E005276
              800057849D00657B8200735925006F5D2D005E8691005D8996006C9DAE006F7B
              6C00776D480075571E0071541D0071582500684E1A00674D1A00654D1900674D
              1A00694E1B006C501B006C511B00694E1A00674D1A00684E1A00684E1A00694E
              1A00684E1A00694F1A006C511B006C511B00644B1900664C1A00674D1A006A4F
              1A00684E1A00694E1B00684D1A00664C1A00654B1900654C1900654C1900664C
              1A00664C1A00674D1A00684D1A00684E1A00694E1A00694E1A006C511E00705B
              2E0067715B0088AAB800658179006C511B006C501B0070541D006F5724006A5E
              32006E5826006A501C00654C1900644B1900644B1900644B1900644B1900654C
              1900684D1A006A4F1A00674D1A00654C1900644B1900644B1900654B1900664C
              1A006A4F1A007976620089ADCE0086ACCE007DA4C90090B7D0008DB6D10096BB
              D6009CC0DA00A0C9DC0090BCD50086B2CC0089B6D4008FBAD6007AA1C4006C83
              9D007066500080A2C40089B4D5007FA9C9007B8993008294A300786A4A006E52
              1C00715B2E00647A8B00517689004B737E00537F96005E89A90063859F005C82
              87004A7980006AA0A9007BACBB006095A3006B96AF0071989A006A795B007468
              3F006A501B00664C1900674D1A00674D1A00674D1A006B501B00644B1900654B
              1900654C1900654C1900654C1900654B1900644B1900644B1900654C1900654C
              1900644B1900654B1900654C1900654C1900644A1900644A1900634919006249
              190063491900644A1900644B1900644B1900654B1900654B1900654B1900654C
              1900664C1900674D1A006F644700666E5F007A9CA70081A2AD005C8489006E54
              20006E511B006B501B006F521C005A5F43006C511C00644B190063491900634A
              1900624918006148180062481800634A1900644B1900674D1A00664C1900644B
              1900634A1800634A1800634A1900634A1900664C19006B522000738188007CA2
              C4008BB1CE0086AECC007DA5C5008BB3CF008DB4D10082B0D00080A8C7007CA1
              BF00779EBF007CA1C200739BBD006F736E007A97B00088B4D1007EAED1007488
              9200776F5500848B8500758A9B006C8BA1006E8DA7006C8FAB006C96B500547B
              97005F89A300719AB00084A2BB0080A0B5005A868F0093B6C1008CB6C7006E9B
              AE006190A60056839300528B8D006B70520071531C006E521D00674C1A00654B
              1900664C1900674D1A00634A1900624918006249180061481800614818006248
              1800624818006148180062481800634919006148180061481800604718005F47
              1800604818005F4718005F471700604718006047180060481800614818006249
              18006249180062491800634A1800634A1800644B19006A5B3600737A73007597
              A80089A9BB0077A0AE004F8D8E00476D65004B625000505E4100506D5800575B
              3A006A4E1A0062491800604818006148180062481800604718005F4718006047
              180062481800644A1800664B1900644B1900634A1800634A1800634918006048
              180062491800644A1800674D1A006A827E0084AAC40097BFD6009BC4D7008DB5
              C70084AFCB007BA6CB00738591007B8380007391AC006C736F00647070007284
              8A007CA8CC007BACCE006689AC00657179009CBDD60092B4CD00688AA30071A1
              C1008AB8D200678CA50049737C0063858B0098B1C100A5C0DA009EB8D20094B2
              C0008CABB6009EC0CC0086A5B7005D7C9D006590A40062859E0051788A005A72
              74006E521B006E511B0068532500634A1800664C1900604818005E4617005E47
              17005F47170061481800604718005E4717005E47170060471800614818006048
              1800604718005E4617005C4517005C4517005D4517005C4517005C4517005D45
              17005D4517005D4517005E4517005E4617005E4617005F4617005F4717006047
              1800665B380075888F007491AB008BA8BA0092B4C10078AEB3005F9CA1004074
              6C00416E6700396D6000407A6B003666560055583400624818005E4617005E46
              17005F4617005F4617005E4617005E4617005F4617006047170062481800644A
              1800644A1800634A1800614818005E4617005F46170062491900614718005F4F
              25006279700084A2AB008BBDD4008AAFC1007C97AD006A562F00674C1A00644C
              1C0068522400664C1B00654B190067562D007CAFC9006C97B9006992B00093C0
              DB0089ADC80077A0C000769FBB0077A1B70096BFCF007EA6B6007E9BA400AEB9
              CD00ACBDD600B3CBE300AEC8E300A4BDD7009ABDD0009EC3D60094B6CD0078A1
              B9006D97B0006890A9005D839F0066634C006B4F1A0069634300636042006369
              4D00625C38005F4718005C4517005C4416005C4416005E461700604718005C45
              17005C4517005F47180060471800614818005B4316005B4416005B4316005A43
              16005B4316005B4316005B4316005B4316005B4316005C4416005B4316005B44
              16005C4416005C4517005D4517005F4D2300627F81008CA5BA008EABBE00A1C0
              CC0092B7BA0087B3C00070ACB400448882003B7A6D0039746A0040837700437F
              6C00406A5900634E1F00604717005D4517005C4416005C4416005B4316005B43
              16005B4316005C4416005D4517005F46170061481800644A1800644A1A005F46
              17005C4416005D4516005E461700595438005A787D006A7A730063542B00655B
              3A00645A3E006752280068563200634E2300675F4100616047007397A2007FA4
              B5007BADCA007EB4D00091BED6007F96970068582F006B889E005E809B004E72
              90006B99B0008FB9C400B6CAD70093B3CC0084AFD40086A9D1009DB9D700AECB
              E500A8C6E20099B6D3008DB4D80086AFD2007CA5CA00658EA60057758A00625D
              4300655125005A6C640064491800644C1C005D6951005D532C005B4316005A43
              16005A4316005B4316005C4416005D4516005B4416005B4416005C4416005C44
              1600584115005841150059421500594115005942150059421500594215005A42
              15005A4215005A4315005B4315005C4416005C4416005D4517005E451700595E
              4200738E980085A0B40091ADBE009CBBC60098B8C30083AEBB006BA9AC005295
              94004F8F8D003D6E5C00508B8B00537E6D00478274004D7868005E5227006349
              18005E4517005B4315005A4315005C4416005D4517005B4315005A4315005B43
              16005C441600604718005F4617005D4517005B4316005A4215005B4316005559
              3B006999A6006997A500626A56006148190063542E005F5F4300676349006779
              70005F7C790053665A0060634C00697B7400696D5700748C87007EAFC1006A71
              65006353310057728B004D708C005B81A50053779400587D88007094950085A5
              B40081A9C700759EC100728CAE006F88AC0084A5CD007897C0007596BF007DA3
              CB007EA7CC0081A8CB006F97AD0064878F00537C8B0060958F005F542D005F48
              1B005D4A1E005A5A3A005B441700594215005942150059421500594215005942
              1500594215005A4315005942150059411500573F1500563F1500573F1500573F
              1500584014005841140058411500584014005841140059421500594215005A42
              16005A4215005C4416005D45170052553700617F87006D8B920088A7AF0089AA
              B1007A99A3007096A0005F909500518685004A887F004A715D004E6A5300536C
              53004B7A6B004985800043736400485F450058563200604B1C00614717006349
              1800614717005B431600594215005A4215005B4315005C4416005D4517005B43
              16005A42150059421500594215005A4518005C481E005F604400558F90005B86
              8600617B75005A716700547973004F7984006093A10050797F00584D26005452
              33005552330054828B00556C72006449180061583F005A768D00596162005777
              9A004D6E8F004B6E8C004B6976004E6C7C005F828D0062849A006691B4007DA5
              CA0082A9CC0083A4C8007D9DC00081A7D00080ACD4007FA7C900759FB400608E
              A0004F738900498384004E8788004F7D71005D4D22005B5938005D4A20005C45
              1900574015005841140057401500563F1500573F150057401500573F1500573F
              1500553E1400563E1400563E1400563E1400563F1400573F1400573F1400563F
              1400573F1400574015005841150058411500594115005A4215005D491F005E61
              4D005E7A7A006082810074989B0073969E006F909C00698F9A005A8589004877
              7000507F7300546348004C776900457D770056949400518887005A8682004B69
              54005C4B2000645631006D807900635028005F4517005D441600584015005840
              150058411500594115005A4215005841150058401500574014005A4215005E45
              17005F4A1E0058654F0045757000477E7D00557E86005D89900054848F005684
              90005D91A10049788000335C56002E524900375A54003C65680044626300494E
              3100494C30003D636A0046718600486A88004D748D0050787E005A8383005981
              8400547B88005E858F0081A3B7008AACCC008EB8D7008DB0C7007496A2006885
              890070929800648A95005A818C005D908F003E717000427C7D0044787A004775
              780058756B005A5434005E4517005C4416005C45170058421600553E1400553E
              1400563F1400563F1400563F1400563E14005841160057411600584015005742
              1900553E1400553E1400553E1400553E1400563E1400563E1400573F14005740
              1400584014005A4821006B6F66007C909800738D9200829DA20066969600648E
              940062878E00578183004961530044746C004C807D00497C7F00436C72004E55
              41004D7277005B8D95006C9CA800639A9F005A9497005D87880064624A005D44
              160058401500563F1400573F140057401400584014005840140057401400573F
              1400573F1400584015005D4416005760490056512F003C605300514C2B004851
              40003D6260003F686B00406A7000416B75004775870049768E00416A78003B66
              6600326054002E60580033685F00325C5600305C5800396C6800447976003F71
              7B003C6E6D003F716D0038605E00335350003459570048767A005C888B00678A
              96007593A400809CAF00608082005E72700068828600698D93005D878A005782
              82004D7B76003D6B6A00487B7A0058878A004B6F7500515641005C4316005C44
              16005D441600565B400055451D00543D1300563E1400563F1400574015005841
              1500553D1300563E1400584015005B4316005B471C00594A240058461F005743
              1B00543D1400553D1300553D1300563E1400584723006C6F6800738A9500798F
              9B00698F93005B8B8B005C8D8F00598A8A00528283004C7979004B7A7B00416D
              6E00456A6C004C5F5500555039005A461C00505C4E0058869A005F8B9F00658F
              A4006D93A5005C5A3E0059411600563F1400553D1300563E1400563E1400573F
              140058401400573F1500563E1400573F1400594014005941150058401500594A
              2600535B48004D5337005C4315005C4315004B4B320050523900514D2F00564D
              2E0045646F00456C8100416F76003B6A64002D5D4F002A5D53002D6058002D5D
              560030605B0031625B00487A7800316460002F5D59002F5A57002F5452002E4F
              4B002F535000355C5D003A6665003E666600426865003C615E00406461005276
              7900677E8000708F9C0071929D006C91980069909400678C91006B9198006282
              87005B5535005B4316005B4215005B4315005B42150051685A00517671005243
              1D00563F1500563E1400553D1300563E1400563F140059401400594115005842
              1800514525004D5A4C004861600065645000655A3F005D4D2C0071644B00807C
              6D00778689006F8993006A838C00617D83004D7270004E7676004E787C004B72
              7800527C8300527F8500567F8D004D66690057431B0059411400594114005941
              1500525B550051708E0054646C005A554000645D4600563F1400543D1400533C
              13005740190068583B005B462200543D1400553D1400563E1400563E1400553D
              1300553E1400573F1400573F1400584014005947210059421800594114006E64
              4C007A7E740049625E004458510058431C004F503A0048534D00405458003861
              5C00315B50002E6359002E625A002F625A0032635E00335F5B00446E70002F55
              51002E514C002B514A002B504A002A4C48002C4C4A002D4E4E0031535200375E
              56003A605500355A540036595800416568003E6164004E7177004F7376004B6F
              6D004E7773004D767200466F6B004B747100658F920056695A00596450005E64
              4D005C68550057461E005A614C0052563E005048270055492500533D1300533C
              1300583F1400594219005741190057401700484D3D00425B5800426265006076
              7E0068808600748B92007E96A10067878F0062808B00688390006B848F00506C
              730045646800425C61004D636500557079005679850056838D0050767F004764
              720051534D005847280058523E005848270058513B005A5746005C5E5A007575
              700063533800553D1400543C13005A472600C0BDBB00ECEBEC0094897A00543D
              1300523C1300533C1300553D1300584118006B5D44006C593A00573F1500563E
              1400563F1600543D1300553D1300614F2F0083817600687F8400556E7100534D
              320049564900495E5E004D5C5C004B60610042615D00335B5400325E5800345D
              5800325C57003259560044676B0030525200315451002D534B002B4C44002C4D
              49002D504C0030555200385E5D00406A6800446F6A0042676000436563003C5C
              59003B5F5C003D6263002F514F0032565300386058003F645F00476D6A005076
              75007B9FA7007A9CA70070959F0060898D00537D7C00638786005A7D79005372
              6C004A747100557F7F0049675C004D4C3200546158007A828800594E36005645
              24005A605A005F7277005E747C00627B8200647E880053727A004E757A00557B
              7F00486B6F0044636900435D63004A606400565D57004E676F00586C6F00566A
              6F00465D6A00576D8200576F860051697D0058708D005F748A00606F7F007476
              7F0071747E006975800054698500757E8B00999FAA0071655000553D13007070
              6D00D4D2D500F0EBEC00E9E4E500C6BEB900968975005A431D00543C13005B46
              210067563A007161480056401900523B12004F3912004E381200503A1200533C
              1300543C130061553C00809298005F7A84004B5857004C666E00536265005255
              4D0054564B004B4D38004550430044594F003A585700365957003F6264003F64
              6600416062003B544C003B4C3D00324C45002F4D4700325452003C5E5C00496E
              6D00547C7D00547877004B6961004B675F004A665F00486661003D5F5900385E
              5A0042615A006C8D93005F8082005474760063828A0056747800526F71004367
              630043686300466D68004D736F0057807F005F878800527574004B6B6900526F
              6E00D0D5DA00CAC7C2009C908000645233006F685B0063686A005B6772006B78
              8800707A84006C756E005D60500050472B004C4024004B4632004C4C3A005353
              4600635F58005E60620061708A00576A8B005C698000989CA800A8ADB800828C
              A000858F9D008E9FAD006073890056647600646E7E00858E9B00868F9A00898E
              9800939AA60059482900594624007D756C00DFDADB00EEEAEB00EEEAEB00EDEA
              EB00EDECEC00E7E6E700BDB6B50073624B00513A12004F3912004F3812004F39
              12004D3711004D3711004D3712004D3712004D3712004F38120054411F006660
              4B0061675D00585C5200534E3A0051432500513D1800513A1200513B1400503D
              180050401F004F4426004D3F1E004A462B004F472D00485C5D004A4B3C00404E
              48003A4F4B0039514E003B5B5800496A6A004B6A6900496462003E5850004561
              5B00476259003E575300425A5A0045605E00435F590056706D004D5E5400465A
              53004A605B00455B5D00495C5E004157520044524300465547004A4A3400524E
              3300524A30004F462B004F4C33009EA29C00E3E0E300EAE9EB00E4E2E500D7D5
              DA00C8C6CC00C6C4CB00C7C5CC00C5C3CB00C5C4CC00C4C7CD00C1C4CB00B6B9
              BF00A6A7AE009794920068583C00636768007889A5008693AC009BA5B800ACB3
              C000A4ADBD00C6C6CC00939BAE009FA5B4008A96AB0073838C00797E7D007A7B
              760065584200543F1D004D3712004E3916004F3A1700584422009B928D00E4DF
              E000EBE7E800ECE8E900EBE8E900EEEAEB00EFEEEF00EEEDEE00DFDDDF00B9B2
              B4006D5B42004D3611004C3511004C3511004C3511004C3511004C3511004C35
              11004C3511004C3511004C3611004C3611004C3611004C3611004C3611004C35
              11004C3511004C3511004C3511004C3611004F3D1C005A584800564C32004D38
              13004D3611004D3F24004C3916004D3915004E4226004B4A390048575500475D
              5F00465C5E003E4F4F00445153004B585700545E5C0050504400504B39005044
              2A004C4730004C432A004E3711004E3812005F4A30007468670055452C006455
              4200796B5B00786B5B0092897D00948B7E00A29A9100ACA5A200BDB7B500E3DE
              E200DCD7D900DED9DB00E0DEE000DEDCDF00DCDBDE00DADADD00DBD9DC00DAD9
              DD00DBDBDE00DDDEE100DCDCDF00D7D9DC00D4D4D900D5D6DA00DADBDF00D7D7
              DB00CACDD500C7CCD500CDD1D800C4C7CE00D2D2D700B4B7C200A7ACB90095A0
              AB0097A2AC0089939F008896A600A1A7AB008C888100655A4600827F7500B1B3
              B300CECFCF00DBDBDC00EBEAEA00ECEAEB00EBEAEA00EBEAEB00ECEBEB00EDEC
              ED00E8E9EB00E5E6EA00E4E5E800C8C3C6007B6956004C3611004A3410004A34
              10004A3410004A3410004A3410004A3410004B351100544327005F574A005545
              2A00503D1E004B3511004B3410004A3410004A3410004A3410004A3410004B34
              10004B3510004B3511004D3A190050412400514226004B3512004A3410004B34
              10004B3511004B3511004C3611004D3814004D3E20004D41270052544B00534C
              38004F452D0062543F007D6E5F00988D8A009F959400968A860090827C009281
              7F009E8C91009E8E92009A8B8A00A79B9C00BEB7BD00C5C1C600C9C2C800D1CA
              CF00D3CCD000D1CACF00D8D2D500DDD8DA00D9D0D100D3C9CA00D2C9CC00D8D2
              D400E0DBDD00E3DFE100E5E2E400E4E3E400E5E4E500E8E8E800E9E8E800E8E8
              E800EBECEC00ECEDED00EBEDEE00E6E7E900E2E4E700E6E8EA00E2E6E900DBE0
              E500D6DBE100D2D8DE00CDD2D800B7BFC600B9C2C800A3B2BE009EAFBB00B8C4
              CC00C1CCD500BDC8D000A8B4C0009EA8B200B5BDC300C7CED200D8DBDE00D9DB
              DE00DDDFE200DCDDE000E7E7E800EAE9EA00DFDBDD00D2CCCD00CCC3C100A595
              87007F6A500067503200533E1B004D371500624D340069573E00715F49006E5D
              45006A583F006E5F4A0071624E0074675400796D5D00796A550075644D006B59
              3F0067543B0064523900645239005C4C3200574526005646290054442800523F
              2000625036007E7063007C6D5F00796A5A00705E48006F5E47006C5B43006F62
              4F007775700080756D008374690086776B0094878000BFB5BB00C7BEC200CEC8
              CB00CEC7CA00CFC8CB00CCC4C700CAC4C700C9C1C500CCC5C800CCC6C900C9C2
              C500CFC8CA00D4CCCE00D8D1D300D8CFD000D7CFD000D6CFD000D8D1D200DDD6
              D700D5CACA00D4CACB00D8D1D200E0DBDD00E5E1E200E8E6E700E7E6E800E5E3
              E400E9E9EA00EAE8E900ECEAEB00EBE7E800EBE9EA00EAE8E900E8E6E700E3E0
              E200E1DFE000E3E2E300E2E4E600E2E4E700DFE1E300DDDDE100DDDCE000DFDF
              E200DEDDE000DFDEE100DFDFE200DFE0E300DFE0E300DDDDE000DCDDE100DDDE
              E100DFDFE200E1E0E300DAD3D800D1C6CD00CDC2C800C7BCC100BAAFAE00B9AD
              AB00C8BEC000CBC0C400BFB3B300AC9E9800B3A7A300C9BEC300CDC1C800CCC1
              C600D4CBD100DAD2D700DAD2D600D8D0D500D6CFD400D7D0D400DDD6DA00DDD6
              DA00DDD6DA00DFD8DB00E1DADD00DFD8DA00DAD3D500D6CFD100D4CDCF00D4CE
              D000D1CBCE00D2CCCF00D2CCCF00D3CDD000D5CFD200D7D0D300D7D0D200D7D1
              D200D9D2D300DBD5D500DBD5D500D8D2D200D4CECE00D1C8C800D0C7C700D6CF
              CF00D7CFCF00D7CFCE00D5C8C800D0BFBE00CEBCBB00CEB9B700CFBFBE00D3C8
              C700D7D0CF00D9CFCF00DACFCE00D9CDCC00DACDCC00DBCCCA00DBCDCB00DBCE
              CD00D9CCCB00D7CDCC00D6CDCD00DBD2D200DED5D500E1D9DA00E2D9DB00E1D9
              DA00DED5D700DFD7D900DDD5D700DED6D800E0D8DA00E2DBDC00E5DDDE00E5DD
              DE00E4DCDD00E4DBDC00E2DADB00E3DBDC00E5DDDE00E3DCDD00DFD8DA00E0D9
              DB00E0DADC00DBD3D600DAD1D500DAD1D500DAD2D500DED5D900DFD7DA00DFD7
              DA00DFD7DA00E0D8DB00E1D9DB00E0D8DA00E0D8DA00E2DADC00E3DADC00E2D9
              DC00E2D9DC00E2D8DB00E2D9DC00E3DADD00E4DADD00E3DADE00E3DADC00E2D9
              DC00E2D9DC00E0D8DB00E1D8DB00E1D9DB00E1D8DB00E1D8DA00E0D8D900E1D8
              D900E1D9DA00E1D9DA00E2DADB00E3DBDC00E5DDDD00E6DEDE00E6DEDE00E6DE
              DE00E4DCDC00E3DBDB00E3DBDB00E2DADA00E2D9DA00E2DADA00E3DBDB00E3DA
              DB00E3DBDB00E4DCDC00E4DCDB00E4DBDB00E5DBDB00E5DDDD00E6DEDD00E5DD
              DD00E5DDDD00E5DDDC00E4DDDC00E4DDDC00E1D9D800DDD3D300DCD1D000DCD1
              D000DBCFCE00DBD0CF00DDD1D100DCD1D100DDD2D100DDD1D000DFD1D000E0D0
              CF00E0D0CE00E0CFCE00DFCFCD00DECECC00DBCBCA00D9CBCA00D8CCCB00D7CC
              CB00}
            Zoom = 4
            ZoomMax = 4
            Xcentre = 0
            Ycentre = 0
            OnMouseUp = ZoomImage1MouseUp
            OnPaint = ZoomImage1Paint
            OnPosChange = ZoomImage1PosChange
          end
          object HScrollBar: TScrollBar
            Left = 48
            Top = 408
            Width = 400
            Height = 18
            PageSize = 0
            TabOrder = 9
            OnChange = HScrollBarChange
          end
          object VScrollBar: TScrollBar
            Left = 448
            Top = 208
            Width = 18
            Height = 200
            Kind = sbVertical
            PageSize = 0
            TabOrder = 10
            OnChange = VScrollBarChange
          end
          object obsname: TGroupBox
            Left = 8
            Top = 0
            Width = 449
            Height = 81
            Caption = 'Observatory Database'
            TabOrder = 11
            OnEnter = obsnameMouseEnter
            object dbreado: TPanel
              Left = 248
              Top = 48
              Width = 192
              Height = 27
              Caption = 'Database cannot be modified'
              TabOrder = 7
              Visible = False
            end
            object citylist: TComboBox
              Left = 8
              Top = 48
              Width = 233
              Height = 21
              AutoComplete = False
              ItemHeight = 13
              TabOrder = 0
              Text = '...'
              OnChange = citylistChange
              OnClick = citylistClick
            end
            object citysearch: TButton
              Left = 364
              Top = 21
              Width = 76
              Height = 21
              Caption = 'Search'
              TabOrder = 1
              OnClick = citysearchClick
            end
            object countrylist: TComboBox
              Left = 8
              Top = 18
              Width = 233
              Height = 21
              AutoComplete = False
              Style = csDropDownList
              ItemHeight = 13
              TabOrder = 2
              OnClick = countrylistClick
            end
            object cityfilter: TEdit
              Left = 248
              Top = 18
              Width = 104
              Height = 21
              TabOrder = 3
            end
            object newcity: TButton
              Left = 248
              Top = 51
              Width = 60
              Height = 21
              Caption = 'Add'
              Enabled = False
              TabOrder = 4
              OnClick = newcityClick
            end
            object updcity: TButton
              Left = 314
              Top = 51
              Width = 60
              Height = 21
              Caption = 'Update'
              Enabled = False
              TabOrder = 5
              OnClick = updcityClick
            end
            object delcity: TButton
              Left = 380
              Top = 51
              Width = 60
              Height = 21
              Caption = 'Delete'
              Enabled = False
              TabOrder = 6
              OnClick = delcityClick
            end
          end
        end
        object t_horizon: TTabSheet
          Caption = 't_horizon'
          ImageIndex = 1
          TabVisible = False
          object hor_l1: TLabel
            Left = 16
            Top = 136
            Width = 124
            Height = 13
            Caption = 'Local Horizon File Name : '
          end
          object hor_l2: TLabel
            Left = 0
            Top = 0
            Width = 72
            Height = 13
            Caption = 'Hotizon Setting'
          end
          object horizonopaque: TCheckBox
            Left = 16
            Top = 72
            Width = 300
            Height = 30
            Caption = 'Show Object below the horizon'
            TabOrder = 0
            OnClick = horizonopaqueClick
          end
          object horizonfile: TEdit
            Left = 16
            Top = 164
            Width = 201
            Height = 21
            TabOrder = 1
            OnChange = horizonfileChange
          end
          object horizonfileBtn: TBitBtn
            Tag = 8
            Left = 215
            Top = 164
            Width = 26
            Height = 26
            TabOrder = 2
            TabStop = False
            OnClick = horizonfileBtnClick
            Glyph.Data = {
              36030000424D3603000000000000360000002800000010000000100000000100
              1800000000000003000000000000000000000000000000000000C0CFCFC0CFCF
              C0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CF
              CFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0
              CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCF
              0000000000000000000000000000000000000000000000000000000000000000
              00C0CFCFC0CFCFC0CFCFC0CFCFC0CFCF7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F
              7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F000000C0CFCFC0CFCFC0CFCFC0CFCF
              7F7F7FFFFFFFC0CFCF00FFFFC0CFCF00FFFFC0CFCF00FFFFC0CFCF00FFFF7F7F
              7F000000C0CFCFC0CFCFC0CFCFC0CFCF7F7F7FFFFFFF00FFFFC0CFCF00FFFFC0
              CFCF00FFFFC0CFCF00FFFFC0CFCF7F7F7F000000C0CFCFC0CFCFC0CFCFC0CFCF
              7F7F7FFFFFFFC0CFCF00FFFFC0CFCF00FFFFC0CFCF00FFFFC0CFCF00FFFF7F7F
              7F000000C0CFCFC0CFCFC0CFCFC0CFCF7F7F7FFFFFFF00FFFFC0CFCF00FFFFC0
              CFCF00FFFFC0CFCF00FFFFC0CFCF7F7F7F000000C0CFCFC0CFCFC0CFCFC0CFCF
              7F7F7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF7F7F
              7F000000C0CFCFC0CFCFC0CFCFC0CFCF7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F
              7F7F7F7F7F7F7F7F7F7F7F7F7F7F000000C0CFCFC0CFCFC0CFCFC0CFCFC0CFCF
              7F7F7F00FFFFFFFFFF00FFFFFFFFFF7F7F7FC0CFCFC0CFCFC0CFCFC0CFCFC0CF
              CFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCF7F7F7F7F7F7F7F7F7F7F7F7FC0
              CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCF
              C0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CF
              CFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0
              CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCF
              C0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CF
              CFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0
              CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCF}
            Layout = blGlyphTop
            Margin = 0
          end
        end
      end
    end
    object s_chart: TTabSheet
      Caption = 's_chart'
      ImageIndex = 2
      TabVisible = False
      object pa_chart: TPageControl
        Left = 0
        Top = 0
        Width = 482
        Height = 445
        ActivePage = t_chart
        Align = alClient
        TabOrder = 0
        object t_chart: TTabSheet
          Caption = 't_chart'
          TabVisible = False
          object Label31: TLabel
            Left = 0
            Top = 0
            Width = 61
            Height = 13
            Caption = 'Chart Setting'
          end
          object Panel1: TPanel
            Left = 9
            Top = 152
            Width = 449
            Height = 105
            BevelInner = bvRaised
            BevelOuter = bvNone
            TabOrder = 0
            object Label68: TLabel
              Left = 404
              Top = 74
              Width = 25
              Height = 13
              Caption = 'years'
            end
            object Label113: TLabel
              Left = 8
              Top = 16
              Width = 254
              Height = 13
              Caption = 'Stars proper motion options (if available in the catalog)'
            end
            object PMBox: TCheckBox
              Left = 8
              Top = 40
              Width = 425
              Height = 17
              Caption = 
                'Use the proper motion to correct the position for the current da' +
                'te'
              TabOrder = 0
              OnClick = PMBoxClick
            end
            object DrawPmBox: TCheckBox
              Left = 8
              Top = 72
              Width = 345
              Height = 17
              Caption = 'Draw a line that represent the proper motion for the next '
              TabOrder = 1
              OnClick = DrawPmBoxClick
            end
            object lDrawPMy: TLongEdit
              Left = 360
              Top = 69
              Width = 40
              Height = 22
              Hint = '-99999..99999'
              ParentShowHint = False
              ShowHint = True
              TabOrder = 2
              OnChange = lDrawPMyChange
              Value = 0
              MinValue = -99999
              MaxValue = 99999
            end
          end
          object Panel10: TPanel
            Left = 8
            Top = 24
            Width = 449
            Height = 121
            TabOrder = 1
            object Label151: TLabel
              Left = 16
              Top = 8
              Width = 178
              Height = 13
              Caption = 'Equatorial Chart  Coordinates Equinox'
            end
            object Label152: TLabel
              Left = 192
              Top = 46
              Width = 41
              Height = 13
              Caption = 'Equinox:'
            end
            object equinoxtype: TRadioGroup
              Left = 16
              Top = 24
              Width = 161
              Height = 89
              ItemIndex = 0
              Items.Strings = (
                'Standard Equinox'
                'Fixed Equinox'
                'Equinox of the date')
              TabOrder = 0
              OnClick = equinoxtypeClick
            end
            object equinox2: TFloatEdit
              Left = 260
              Top = 41
              Width = 49
              Height = 22
              Hint = '-20000..20000'
              ParentShowHint = False
              ShowHint = True
              TabOrder = 1
              Visible = False
              OnChange = equinox2Change
              Value = 1975
              MinValue = -20000
              MaxValue = 20000
              Digits = 8
              NumericType = ntFixed
            end
            object equinox1: TComboBox
              Left = 260
              Top = 42
              Width = 65
              Height = 21
              ItemHeight = 13
              TabOrder = 2
              Text = 'J2000'
              OnChange = equinox1Change
              Items.Strings = (
                'J2000'
                'B1950'
                'B1900')
            end
          end
          object projectiontype: TRadioGroup
            Left = 8
            Top = 332
            Width = 449
            Height = 69
            Caption = 'Chart Coordinate System'
            Columns = 2
            ItemIndex = 0
            Items.Strings = (
              'Equatorial Coordinates'
              'Azimuthal Coordinates'
              'Galactic Coordinates'
              'Ecliptic Coordinates')
            TabOrder = 2
            OnClick = projectiontypeClick
          end
          object ApparentType: TRadioGroup
            Left = 8
            Top = 264
            Width = 449
            Height = 57
            Caption = 'Nutation ,  Aberration'
            Columns = 2
            ItemIndex = 0
            Items.Strings = (
              'Mean position'
              'True position')
            TabOrder = 3
            OnClick = ApparentTypeClick
          end
        end
        object t_fov: TTabSheet
          Caption = 't_fov'
          ImageIndex = 1
          TabVisible = False
          object Label30: TLabel
            Left = 0
            Top = 0
            Width = 101
            Height = 13
            Caption = 'Field of Vision Setting'
          end
          object Bevel1: TBevel
            Left = 16
            Top = 56
            Width = 169
            Height = 265
            Shape = bsFrame
          end
          object Bevel2: TBevel
            Left = 208
            Top = 56
            Width = 169
            Height = 265
            Shape = bsFrame
          end
          object Label96: TLabel
            Left = 72
            Top = 137
            Width = 8
            Height = 13
            Caption = '1'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = 13
            Font.Name = 'MS Sans Serif'
            Font.Pitch = fpVariable
            Font.Style = [fsBold]
            ParentFont = False
          end
          object Label97: TLabel
            Left = 72
            Top = 166
            Width = 8
            Height = 13
            Caption = '2'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = 13
            Font.Name = 'MS Sans Serif'
            Font.Pitch = fpVariable
            Font.Style = [fsBold]
            ParentFont = False
          end
          object Label98: TLabel
            Left = 72
            Top = 195
            Width = 8
            Height = 13
            Caption = '3'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = 13
            Font.Name = 'MS Sans Serif'
            Font.Pitch = fpVariable
            Font.Style = [fsBold]
            ParentFont = False
          end
          object Label99: TLabel
            Left = 72
            Top = 224
            Width = 8
            Height = 13
            Caption = '4'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = 13
            Font.Name = 'MS Sans Serif'
            Font.Pitch = fpVariable
            Font.Style = [fsBold]
            ParentFont = False
          end
          object Label100: TLabel
            Left = 264
            Top = 108
            Width = 8
            Height = 13
            Caption = '5'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = 13
            Font.Name = 'MS Sans Serif'
            Font.Pitch = fpVariable
            Font.Style = [fsBold]
            ParentFont = False
          end
          object Label101: TLabel
            Left = 264
            Top = 137
            Width = 8
            Height = 13
            Caption = '6'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = 13
            Font.Name = 'MS Sans Serif'
            Font.Pitch = fpVariable
            Font.Style = [fsBold]
            ParentFont = False
          end
          object Label102: TLabel
            Left = 264
            Top = 166
            Width = 8
            Height = 13
            Caption = '7'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = 13
            Font.Name = 'MS Sans Serif'
            Font.Pitch = fpVariable
            Font.Style = [fsBold]
            ParentFont = False
          end
          object Label103: TLabel
            Left = 264
            Top = 195
            Width = 8
            Height = 13
            Caption = '8'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = 13
            Font.Name = 'MS Sans Serif'
            Font.Pitch = fpVariable
            Font.Style = [fsBold]
            ParentFont = False
          end
          object Label104: TLabel
            Left = 264
            Top = 224
            Width = 8
            Height = 13
            Caption = '9'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = 13
            Font.Name = 'MS Sans Serif'
            Font.Pitch = fpVariable
            Font.Style = [fsBold]
            ParentFont = False
          end
          object Label105: TLabel
            Left = 256
            Top = 256
            Width = 15
            Height = 13
            Caption = '10'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = 13
            Font.Name = 'MS Sans Serif'
            Font.Pitch = fpVariable
            Font.Style = [fsBold]
            ParentFont = False
          end
          object Label106: TLabel
            Left = 21
            Top = 64
            Width = 62
            Height = 13
            Alignment = taRightJustify
            Caption = 'Field Number'
          end
          object Label107: TLabel
            Left = 112
            Top = 64
            Width = 49
            Height = 13
            Caption = 'Field Limit '
          end
          object Label114: TLabel
            Left = 72
            Top = 108
            Width = 8
            Height = 13
            Caption = '0'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = 13
            Font.Name = 'MS Sans Serif'
            Font.Pitch = fpVariable
            Font.Style = [fsBold]
            ParentFont = False
          end
          object Label57: TLabel
            Left = 213
            Top = 64
            Width = 62
            Height = 13
            Alignment = taRightJustify
            Caption = 'Field Number'
          end
          object Label73: TLabel
            Left = 304
            Top = 64
            Width = 46
            Height = 13
            Caption = 'Field Limit'
          end
          object Label74: TLabel
            Left = 72
            Top = 256
            Width = 8
            Height = 13
            Caption = '5'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = 13
            Font.Name = 'MS Sans Serif'
            Font.Pitch = fpVariable
            Font.Style = [fsBold]
            ParentFont = False
          end
          object fw1: TFloatEdit
            Tag = 1
            Left = 112
            Top = 152
            Width = 40
            Height = 22
            Hint = '0..360'
            ParentShowHint = False
            ShowHint = True
            TabOrder = 0
            OnChange = FWChange
            Value = 1
            MaxValue = 360
            NumericType = ntFixed
          end
          object fw2: TFloatEdit
            Tag = 2
            Left = 112
            Top = 181
            Width = 40
            Height = 22
            Hint = '0..360'
            ParentShowHint = False
            ShowHint = True
            TabOrder = 1
            OnChange = FWChange
            Value = 2
            MaxValue = 360
            NumericType = ntFixed
          end
          object fw3: TFloatEdit
            Tag = 3
            Left = 112
            Top = 210
            Width = 40
            Height = 22
            Hint = '0..360'
            ParentShowHint = False
            ShowHint = True
            TabOrder = 2
            OnChange = FWChange
            Value = 5
            MaxValue = 360
            NumericType = ntFixed
          end
          object fw4: TFloatEdit
            Tag = 4
            Left = 112
            Top = 239
            Width = 40
            Height = 22
            Hint = '0..360'
            ParentShowHint = False
            ShowHint = True
            TabOrder = 3
            OnChange = FWChange
            Value = 10
            MaxValue = 360
            NumericType = ntFixed
          end
          object fw5: TFloatEdit
            Tag = 5
            Left = 304
            Top = 123
            Width = 40
            Height = 22
            Hint = '0..360'
            ParentShowHint = False
            ShowHint = True
            TabOrder = 4
            OnChange = FWChange
            Value = 15
            MaxValue = 360
            NumericType = ntFixed
          end
          object fw6: TFloatEdit
            Tag = 6
            Left = 304
            Top = 152
            Width = 40
            Height = 22
            Hint = '0..360'
            ParentShowHint = False
            ShowHint = True
            TabOrder = 5
            OnChange = FWChange
            Value = 25
            MaxValue = 360
            NumericType = ntFixed
          end
          object fw7: TFloatEdit
            Tag = 7
            Left = 304
            Top = 181
            Width = 40
            Height = 22
            Hint = '0..360'
            ParentShowHint = False
            ShowHint = True
            TabOrder = 6
            OnChange = FWChange
            Value = 45
            MaxValue = 360
            NumericType = ntFixed
          end
          object fw8: TFloatEdit
            Tag = 8
            Left = 304
            Top = 210
            Width = 40
            Height = 22
            Hint = '0..360'
            ParentShowHint = False
            ShowHint = True
            TabOrder = 7
            OnChange = FWChange
            Value = 90
            MaxValue = 360
            NumericType = ntFixed
          end
          object fw9: TFloatEdit
            Tag = 9
            Left = 304
            Top = 239
            Width = 40
            Height = 22
            Hint = '0..360'
            ParentShowHint = False
            ShowHint = True
            TabOrder = 8
            OnChange = FWChange
            Value = 180
            MaxValue = 360
            NumericType = ntFixed
          end
          object fw10: TFloatEdit
            Left = 304
            Top = 268
            Width = 40
            Height = 22
            Hint = '0..360'
            Color = clBtnFace
            ParentShowHint = False
            ReadOnly = True
            ShowHint = True
            TabOrder = 9
            Value = 360
            MaxValue = 360
            NumericType = ntFixed
          end
          object fw0: TFloatEdit
            Left = 112
            Top = 123
            Width = 40
            Height = 22
            Hint = '0..360'
            ParentShowHint = False
            ShowHint = True
            TabOrder = 10
            OnChange = FWChange
            Value = 0.5
            MaxValue = 360
            NumericType = ntFixed
          end
          object fw00: TFloatEdit
            Left = 112
            Top = 95
            Width = 40
            Height = 22
            Hint = '0..360'
            Color = clBtnFace
            ParentShowHint = False
            ReadOnly = True
            ShowHint = True
            TabOrder = 11
            MaxValue = 360
            NumericType = ntFixed
          end
          object fw4b: TFloatEdit
            Tag = 4
            Left = 304
            Top = 95
            Width = 40
            Height = 22
            Hint = '0..360'
            Color = clBtnFace
            ParentShowHint = False
            ReadOnly = True
            ShowHint = True
            TabOrder = 12
            MaxValue = 360
            NumericType = ntFixed
          end
          object fw5b: TFloatEdit
            Tag = 5
            Left = 112
            Top = 268
            Width = 40
            Height = 22
            Hint = '0..360'
            Color = clBtnFace
            ParentShowHint = False
            ReadOnly = True
            ShowHint = True
            TabOrder = 13
            MaxValue = 360
            NumericType = ntFixed
          end
        end
        object t_projection: TTabSheet
          Tag = 1
          Caption = 't_projection'
          ImageIndex = 2
          TabVisible = False
          object Bevel8: TBevel
            Left = 208
            Top = 48
            Width = 185
            Height = 241
            Shape = bsFrame
          end
          object Bevel7: TBevel
            Left = 16
            Top = 48
            Width = 177
            Height = 241
            Shape = bsFrame
          end
          object Label158: TLabel
            Left = 0
            Top = 0
            Width = 83
            Height = 13
            Caption = 'Projection Setting'
          end
          object Labelp1: TLabel
            Left = 72
            Top = 123
            Width = 9
            Height = 16
            Caption = '1'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -13
            Font.Name = 'MS Sans Serif'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object Labelp2: TLabel
            Left = 72
            Top = 152
            Width = 9
            Height = 16
            Caption = '2'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -13
            Font.Name = 'MS Sans Serif'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object Labelp3: TLabel
            Left = 72
            Top = 181
            Width = 9
            Height = 16
            Caption = '3'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -13
            Font.Name = 'MS Sans Serif'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object Labelp4: TLabel
            Left = 72
            Top = 210
            Width = 9
            Height = 16
            Caption = '4'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -13
            Font.Name = 'MS Sans Serif'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object Label165: TLabel
            Left = 29
            Top = 64
            Width = 62
            Height = 13
            Alignment = taRightJustify
            Caption = 'Field Number'
          end
          object Labelp0: TLabel
            Left = 72
            Top = 94
            Width = 9
            Height = 16
            Caption = '0'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -13
            Font.Name = 'MS Sans Serif'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object Labelp5: TLabel
            Left = 264
            Top = 94
            Width = 9
            Height = 16
            Caption = '5'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -13
            Font.Name = 'MS Sans Serif'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object Labelp6: TLabel
            Left = 264
            Top = 123
            Width = 9
            Height = 16
            Caption = '6'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -13
            Font.Name = 'MS Sans Serif'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object Labelp7: TLabel
            Left = 264
            Top = 152
            Width = 9
            Height = 16
            Caption = '7'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -13
            Font.Name = 'MS Sans Serif'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object Labelp8: TLabel
            Left = 264
            Top = 181
            Width = 9
            Height = 16
            Caption = '8'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -13
            Font.Name = 'MS Sans Serif'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object Labelp9: TLabel
            Left = 264
            Top = 210
            Width = 9
            Height = 16
            Caption = '9'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -13
            Font.Name = 'MS Sans Serif'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object Labelp10: TLabel
            Left = 256
            Top = 239
            Width = 17
            Height = 16
            Caption = '10'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -13
            Font.Name = 'MS Sans Serif'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object Label171: TLabel
            Left = 221
            Top = 64
            Width = 62
            Height = 13
            Alignment = taRightJustify
            Caption = 'Field Number'
          end
          object Label172: TLabel
            Left = 104
            Top = 64
            Width = 47
            Height = 13
            Caption = 'Projection'
          end
          object Label173: TLabel
            Left = 304
            Top = 64
            Width = 47
            Height = 13
            Caption = 'Projection'
          end
          object ComboBox2: TComboBox
            Tag = 1
            Left = 104
            Top = 121
            Width = 73
            Height = 21
            ItemHeight = 13
            TabOrder = 0
            Text = 'ARC'
            OnChange = ProjectionChange
            Items.Strings = (
              'ARC'
              'TAN'
              'SIN')
          end
          object ComboBox1: TComboBox
            Left = 104
            Top = 92
            Width = 73
            Height = 21
            ItemHeight = 13
            TabOrder = 1
            Text = 'ARC'
            OnChange = ProjectionChange
            Items.Strings = (
              'ARC'
              'TAN'
              'SIN')
          end
          object ComboBox3: TComboBox
            Tag = 2
            Left = 104
            Top = 150
            Width = 73
            Height = 21
            ItemHeight = 13
            TabOrder = 2
            Text = 'ARC'
            OnChange = ProjectionChange
            Items.Strings = (
              'ARC'
              'TAN'
              'SIN')
          end
          object ComboBox4: TComboBox
            Tag = 3
            Left = 104
            Top = 179
            Width = 73
            Height = 21
            ItemHeight = 13
            TabOrder = 3
            Text = 'ARC'
            OnChange = ProjectionChange
            Items.Strings = (
              'ARC'
              'CAR')
          end
          object ComboBox5: TComboBox
            Tag = 4
            Left = 105
            Top = 208
            Width = 73
            Height = 21
            ItemHeight = 13
            TabOrder = 4
            Text = 'ARC'
            OnChange = ProjectionChange
            Items.Strings = (
              'ARC'
              'CAR')
          end
          object ComboBox6: TComboBox
            Tag = 5
            Left = 304
            Top = 92
            Width = 73
            Height = 21
            ItemHeight = 13
            TabOrder = 5
            Text = 'ARC'
            OnChange = ProjectionChange
            Items.Strings = (
              'ARC'
              'TAN'
              'SIN')
          end
          object ComboBox7: TComboBox
            Tag = 6
            Left = 304
            Top = 121
            Width = 73
            Height = 21
            ItemHeight = 13
            TabOrder = 6
            Text = 'ARC'
            OnChange = ProjectionChange
            Items.Strings = (
              'ARC'
              'TAN'
              'SIN')
          end
          object ComboBox8: TComboBox
            Tag = 7
            Left = 304
            Top = 150
            Width = 73
            Height = 21
            ItemHeight = 13
            TabOrder = 7
            Text = 'ARC'
            OnChange = ProjectionChange
            Items.Strings = (
              'ARC'
              'TAN'
              'SIN')
          end
          object ComboBox9: TComboBox
            Tag = 8
            Left = 304
            Top = 179
            Width = 73
            Height = 21
            ItemHeight = 13
            TabOrder = 8
            Text = 'ARC'
            OnChange = ProjectionChange
            Items.Strings = (
              'ARC'
              'TAN'
              'SIN')
          end
          object ComboBox10: TComboBox
            Tag = 9
            Left = 304
            Top = 208
            Width = 73
            Height = 21
            ItemHeight = 13
            TabOrder = 9
            Text = 'ARC'
            OnChange = ProjectionChange
            Items.Strings = (
              'ARC'
              'TAN'
              'SIN')
          end
          object ComboBox11: TComboBox
            Tag = 10
            Left = 304
            Top = 237
            Width = 73
            Height = 21
            ItemHeight = 13
            TabOrder = 10
            Text = 'ARC'
            OnChange = ProjectionChange
            Items.Strings = (
              'ARC'
              'TAN'
              'SIN')
          end
        end
        object t_filter: TTabSheet
          Caption = 't_filter'
          ImageIndex = 3
          TabVisible = False
          object Label29: TLabel
            Left = 0
            Top = 0
            Width = 92
            Height = 13
            Caption = 'Object Filter Setting'
          end
          object GroupBox2: TGroupBox
            Left = 9
            Top = 16
            Width = 449
            Height = 184
            Caption = 'Stars Filter'
            TabOrder = 0
            object StarBox: TCheckBox
              Left = 8
              Top = 22
              Width = 225
              Height = 17
              Hint = 'Copy|Copies the selection and puts it on the Clipboard'
              Caption = 'Filter stars '
              TabOrder = 0
              OnClick = StarBoxClick
            end
            object Panel4: TPanel
              Left = 4
              Top = 44
              Width = 442
              Height = 137
              TabOrder = 1
              object Panel2: TPanel
                Left = 4
                Top = 30
                Width = 434
                Height = 105
                TabOrder = 2
                object Label32: TLabel
                  Left = 23
                  Top = 24
                  Width = 6
                  Height = 13
                  Caption = '1'
                end
                object Label33: TLabel
                  Left = 64
                  Top = 24
                  Width = 6
                  Height = 13
                  Caption = '2'
                end
                object Label34: TLabel
                  Left = 106
                  Top = 24
                  Width = 6
                  Height = 13
                  Caption = '3'
                end
                object Label35: TLabel
                  Left = 148
                  Top = 24
                  Width = 6
                  Height = 13
                  Caption = '4'
                end
                object Label36: TLabel
                  Left = 190
                  Top = 24
                  Width = 6
                  Height = 13
                  Caption = '5'
                end
                object Label38: TLabel
                  Left = 231
                  Top = 24
                  Width = 6
                  Height = 13
                  Caption = '6'
                end
                object Label39: TLabel
                  Left = 273
                  Top = 24
                  Width = 6
                  Height = 13
                  Caption = '7'
                end
                object Label40: TLabel
                  Left = 315
                  Top = 24
                  Width = 6
                  Height = 13
                  Caption = '8'
                end
                object Label76: TLabel
                  Left = 357
                  Top = 24
                  Width = 6
                  Height = 13
                  Caption = '9'
                end
                object Label78: TLabel
                  Left = 394
                  Top = 24
                  Width = 12
                  Height = 13
                  Caption = '10'
                end
                object Label108: TLabel
                  Left = 8
                  Top = 8
                  Width = 108
                  Height = 13
                  Caption = 'Field of vision number :'
                end
                object Label109: TLabel
                  Left = 8
                  Top = 48
                  Width = 93
                  Height = 13
                  Caption = 'Limiting magnitude :'
                end
                object fsmag0: TFloatEdit
                  Tag = 1
                  Left = 8
                  Top = 71
                  Width = 40
                  Height = 22
                  Hint = '0..99'
                  ParentShowHint = False
                  ShowHint = True
                  TabOrder = 0
                  OnChange = fsmagChange
                  Value = 99
                  MaxValue = 99
                end
                object fsmag1: TFloatEdit
                  Tag = 2
                  Left = 49
                  Top = 71
                  Width = 40
                  Height = 22
                  Hint = '0..99'
                  ParentShowHint = False
                  ShowHint = True
                  TabOrder = 1
                  OnChange = fsmagChange
                  Value = 99
                  MaxValue = 99
                end
                object fsmag2: TFloatEdit
                  Tag = 3
                  Left = 91
                  Top = 71
                  Width = 40
                  Height = 22
                  Hint = '0..99'
                  ParentShowHint = False
                  ShowHint = True
                  TabOrder = 2
                  OnChange = fsmagChange
                  Value = 99
                  MaxValue = 99
                end
                object fsmag3: TFloatEdit
                  Tag = 4
                  Left = 133
                  Top = 71
                  Width = 40
                  Height = 22
                  Hint = '0..99'
                  ParentShowHint = False
                  ShowHint = True
                  TabOrder = 3
                  OnChange = fsmagChange
                  Value = 99
                  MaxValue = 99
                end
                object fsmag4: TFloatEdit
                  Tag = 5
                  Left = 175
                  Top = 71
                  Width = 40
                  Height = 22
                  Hint = '0..99'
                  ParentShowHint = False
                  ShowHint = True
                  TabOrder = 4
                  OnChange = fsmagChange
                  Value = 99
                  MaxValue = 99
                end
                object fsmag5: TFloatEdit
                  Tag = 6
                  Left = 216
                  Top = 71
                  Width = 40
                  Height = 22
                  Hint = '0..99'
                  ParentShowHint = False
                  ShowHint = True
                  TabOrder = 5
                  OnChange = fsmagChange
                  Value = 99
                  MaxValue = 99
                end
                object fsmag6: TFloatEdit
                  Tag = 7
                  Left = 258
                  Top = 71
                  Width = 40
                  Height = 22
                  Hint = '0..99'
                  ParentShowHint = False
                  ShowHint = True
                  TabOrder = 6
                  OnChange = fsmagChange
                  Value = 99
                  MaxValue = 99
                end
                object fsmag7: TFloatEdit
                  Tag = 8
                  Left = 300
                  Top = 71
                  Width = 40
                  Height = 22
                  Hint = '0..99'
                  ParentShowHint = False
                  ShowHint = True
                  TabOrder = 7
                  OnChange = fsmagChange
                  Value = 99
                  MaxValue = 99
                end
                object fsmag8: TFloatEdit
                  Tag = 9
                  Left = 342
                  Top = 71
                  Width = 40
                  Height = 22
                  Hint = '0..99'
                  ParentShowHint = False
                  ShowHint = True
                  TabOrder = 8
                  OnChange = fsmagChange
                  Value = 99
                  MaxValue = 99
                end
                object fsmag9: TFloatEdit
                  Tag = 10
                  Left = 384
                  Top = 71
                  Width = 40
                  Height = 22
                  Hint = '0..99'
                  ParentShowHint = False
                  ShowHint = True
                  TabOrder = 9
                  OnChange = fsmagChange
                  Value = 99
                  MaxValue = 99
                end
              end
              object Panel3: TPanel
                Left = 4
                Top = 30
                Width = 434
                Height = 37
                TabOrder = 0
                object Label110: TLabel
                  Left = 8
                  Top = 12
                  Width = 106
                  Height = 13
                  Caption = 'Nacked eye reference'
                end
                object fsmagvis: TFloatEdit
                  Left = 188
                  Top = 7
                  Width = 40
                  Height = 22
                  Hint = '0..99'
                  ParentShowHint = False
                  ShowHint = True
                  TabOrder = 0
                  OnChange = fsmagvisChange
                  Value = 99
                  MaxValue = 99
                end
              end
              object StarAutoBox: TCheckBox
                Left = 8
                Top = 6
                Width = 265
                Height = 17
                Caption = 'Automatic'
                TabOrder = 1
                OnClick = StarAutoBoxClick
              end
            end
          end
          object GroupBox1: TGroupBox
            Left = 8
            Top = 208
            Width = 449
            Height = 200
            Caption = 'Nebulae Filter'
            TabOrder = 1
            object Label115: TLabel
              Left = 376
              Top = 23
              Width = 36
              Height = 13
              Caption = 'minutes'
            end
            object NebBox: TCheckBox
              Left = 8
              Top = 22
              Width = 129
              Height = 17
              Caption = 'Filter nebulae'
              TabOrder = 0
              OnClick = NebBoxClick
            end
            object BigNebBox: TCheckBox
              Left = 160
              Top = 21
              Width = 161
              Height = 17
              Caption = 'Hide object widther than'
              TabOrder = 1
              OnClick = BigNebBoxClick
            end
            object Panel5: TPanel
              Left = 4
              Top = 44
              Width = 442
              Height = 153
              TabOrder = 2
              object Label48: TLabel
                Left = 8
                Top = 48
                Width = 94
                Height = 13
                Caption = 'Limiting Magnitude :'
              end
              object Label49: TLabel
                Left = 8
                Top = 101
                Width = 124
                Height = 13
                Caption = 'Limiting Size (arcminutes) :'
              end
              object Label41: TLabel
                Left = 23
                Top = 24
                Width = 6
                Height = 13
                Caption = '1'
              end
              object Label42: TLabel
                Left = 64
                Top = 24
                Width = 6
                Height = 13
                Caption = '2'
              end
              object Label43: TLabel
                Left = 106
                Top = 24
                Width = 6
                Height = 13
                Caption = '3'
              end
              object Label44: TLabel
                Left = 148
                Top = 24
                Width = 6
                Height = 13
                Caption = '4'
              end
              object Label45: TLabel
                Left = 190
                Top = 24
                Width = 6
                Height = 13
                Caption = '5'
              end
              object Label46: TLabel
                Left = 231
                Top = 24
                Width = 6
                Height = 13
                Caption = '6'
              end
              object Label47: TLabel
                Left = 273
                Top = 24
                Width = 6
                Height = 13
                Caption = '7'
              end
              object Label79: TLabel
                Left = 315
                Top = 24
                Width = 6
                Height = 13
                Caption = '8'
              end
              object Label80: TLabel
                Left = 357
                Top = 24
                Width = 6
                Height = 13
                Caption = '9'
              end
              object Label111: TLabel
                Left = 394
                Top = 24
                Width = 12
                Height = 13
                Caption = '10'
              end
              object Label112: TLabel
                Left = 8
                Top = 8
                Width = 108
                Height = 13
                Caption = 'Field of vision number :'
              end
              object fmag0: TFloatEdit
                Tag = 1
                Left = 8
                Top = 66
                Width = 40
                Height = 22
                Hint = '0..99'
                ParentShowHint = False
                ShowHint = True
                TabOrder = 0
                OnChange = fmagChange
                Value = 99
                MaxValue = 99
              end
              object fmag1: TFloatEdit
                Tag = 2
                Left = 49
                Top = 66
                Width = 40
                Height = 22
                Hint = '0..99'
                ParentShowHint = False
                ShowHint = True
                TabOrder = 1
                OnChange = fmagChange
                Value = 99
                MaxValue = 99
              end
              object fmag2: TFloatEdit
                Tag = 3
                Left = 91
                Top = 66
                Width = 40
                Height = 22
                Hint = '0..99'
                ParentShowHint = False
                ShowHint = True
                TabOrder = 2
                OnChange = fmagChange
                Value = 99
                MaxValue = 99
              end
              object fmag3: TFloatEdit
                Tag = 4
                Left = 133
                Top = 66
                Width = 40
                Height = 22
                Hint = '0..99'
                ParentShowHint = False
                ShowHint = True
                TabOrder = 3
                OnChange = fmagChange
                Value = 99
                MaxValue = 99
              end
              object fmag4: TFloatEdit
                Tag = 5
                Left = 175
                Top = 66
                Width = 40
                Height = 22
                Hint = '0..99'
                ParentShowHint = False
                ShowHint = True
                TabOrder = 4
                OnChange = fmagChange
                Value = 99
                MaxValue = 99
              end
              object fmag5: TFloatEdit
                Tag = 6
                Left = 216
                Top = 66
                Width = 40
                Height = 22
                Hint = '0..99'
                ParentShowHint = False
                ShowHint = True
                TabOrder = 5
                OnChange = fmagChange
                Value = 99
                MaxValue = 99
              end
              object fmag6: TFloatEdit
                Tag = 7
                Left = 258
                Top = 66
                Width = 40
                Height = 22
                Hint = '0..99'
                ParentShowHint = False
                ShowHint = True
                TabOrder = 6
                OnChange = fmagChange
                Value = 99
                MaxValue = 99
              end
              object fdim0: TFloatEdit
                Tag = 1
                Left = 8
                Top = 120
                Width = 40
                Height = 22
                Hint = '0..1000'
                ParentShowHint = False
                ShowHint = True
                TabOrder = 7
                OnChange = fdimChange
                MaxValue = 1000
              end
              object fdim1: TFloatEdit
                Tag = 2
                Left = 49
                Top = 120
                Width = 40
                Height = 22
                Hint = '0..1000'
                ParentShowHint = False
                ShowHint = True
                TabOrder = 8
                OnChange = fdimChange
                MaxValue = 1000
              end
              object fdim2: TFloatEdit
                Tag = 3
                Left = 91
                Top = 120
                Width = 40
                Height = 22
                Hint = '0..1000'
                ParentShowHint = False
                ShowHint = True
                TabOrder = 9
                OnChange = fdimChange
                MaxValue = 1000
              end
              object fdim3: TFloatEdit
                Tag = 4
                Left = 133
                Top = 120
                Width = 40
                Height = 22
                Hint = '0..1000'
                ParentShowHint = False
                ShowHint = True
                TabOrder = 10
                OnChange = fdimChange
                MaxValue = 1000
              end
              object fdim4: TFloatEdit
                Tag = 5
                Left = 175
                Top = 120
                Width = 40
                Height = 22
                Hint = '0..1000'
                ParentShowHint = False
                ShowHint = True
                TabOrder = 11
                OnChange = fdimChange
                MaxValue = 1000
              end
              object fdim5: TFloatEdit
                Tag = 6
                Left = 216
                Top = 120
                Width = 40
                Height = 22
                Hint = '0..1000'
                ParentShowHint = False
                ShowHint = True
                TabOrder = 12
                OnChange = fdimChange
                MaxValue = 1000
              end
              object fdim6: TFloatEdit
                Tag = 7
                Left = 258
                Top = 120
                Width = 40
                Height = 22
                Hint = '0..1000'
                ParentShowHint = False
                ShowHint = True
                TabOrder = 13
                OnChange = fdimChange
                MaxValue = 1000
              end
              object fmag7: TFloatEdit
                Tag = 8
                Left = 300
                Top = 66
                Width = 40
                Height = 22
                Hint = '0..99'
                ParentShowHint = False
                ShowHint = True
                TabOrder = 14
                OnChange = fmagChange
                Value = 99
                MaxValue = 99
              end
              object fmag8: TFloatEdit
                Tag = 9
                Left = 342
                Top = 66
                Width = 40
                Height = 22
                Hint = '0..99'
                ParentShowHint = False
                ShowHint = True
                TabOrder = 15
                OnChange = fmagChange
                Value = 99
                MaxValue = 99
              end
              object fmag9: TFloatEdit
                Tag = 10
                Left = 384
                Top = 66
                Width = 40
                Height = 22
                Hint = '0..99'
                ParentShowHint = False
                ShowHint = True
                TabOrder = 16
                OnChange = fmagChange
                Value = 99
                MaxValue = 99
              end
              object fdim7: TFloatEdit
                Tag = 8
                Left = 300
                Top = 120
                Width = 40
                Height = 22
                Hint = '0..1000'
                ParentShowHint = False
                ShowHint = True
                TabOrder = 17
                OnChange = fdimChange
                MaxValue = 1000
              end
              object fdim8: TFloatEdit
                Tag = 9
                Left = 342
                Top = 120
                Width = 40
                Height = 22
                Hint = '0..1000'
                ParentShowHint = False
                ShowHint = True
                TabOrder = 18
                OnChange = fdimChange
                MaxValue = 1000
              end
              object fdim9: TFloatEdit
                Tag = 10
                Left = 384
                Top = 120
                Width = 40
                Height = 22
                Hint = '0..1000'
                ParentShowHint = False
                ShowHint = True
                TabOrder = 19
                OnChange = fdimChange
                MaxValue = 1000
              end
            end
            object fBigNebLimit: TLongEdit
              Left = 328
              Top = 18
              Width = 41
              Height = 22
              Hint = '0..20000'
              ParentShowHint = False
              ShowHint = True
              TabOrder = 3
              OnChange = fBigNebLimitChange
              Value = 1
              MaxValue = 20000
            end
          end
        end
        object t_grid: TTabSheet
          Caption = 't_grid'
          ImageIndex = 4
          TabVisible = False
          object Bevel9: TBevel
            Left = 8
            Top = 24
            Width = 355
            Height = 353
            Shape = bsFrame
          end
          object Label159: TLabel
            Left = 0
            Top = 0
            Width = 55
            Height = 13
            Caption = 'Grid Setting'
          end
          object Label160: TLabel
            Left = 23
            Top = 32
            Width = 62
            Height = 13
            Caption = 'Field Number'
          end
          object Label176: TLabel
            Left = 120
            Top = 32
            Width = 99
            Height = 13
            Caption = 'Degree Grid Spacing'
          end
          object Label175: TLabel
            Left = 261
            Top = 32
            Width = 87
            Height = 13
            Caption = 'Hour Grid Spacing'
          end
          object Label161: TLabel
            Left = 48
            Top = 86
            Width = 9
            Height = 16
            Caption = '1'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -13
            Font.Name = 'MS Sans Serif'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object Label162: TLabel
            Left = 48
            Top = 115
            Width = 9
            Height = 16
            Caption = '2'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -13
            Font.Name = 'MS Sans Serif'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object Label163: TLabel
            Left = 48
            Top = 144
            Width = 9
            Height = 16
            Caption = '3'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -13
            Font.Name = 'MS Sans Serif'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object Label164: TLabel
            Left = 48
            Top = 172
            Width = 9
            Height = 16
            Caption = '4'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -13
            Font.Name = 'MS Sans Serif'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object Label166: TLabel
            Left = 48
            Top = 58
            Width = 9
            Height = 16
            Caption = '0'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -13
            Font.Name = 'MS Sans Serif'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object Label167: TLabel
            Left = 48
            Top = 201
            Width = 9
            Height = 16
            Caption = '5'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -13
            Font.Name = 'MS Sans Serif'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object Label168: TLabel
            Left = 48
            Top = 230
            Width = 9
            Height = 16
            Caption = '6'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -13
            Font.Name = 'MS Sans Serif'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object Label169: TLabel
            Left = 48
            Top = 258
            Width = 9
            Height = 16
            Caption = '7'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -13
            Font.Name = 'MS Sans Serif'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object Label170: TLabel
            Left = 48
            Top = 287
            Width = 9
            Height = 16
            Caption = '8'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -13
            Font.Name = 'MS Sans Serif'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object Label174: TLabel
            Left = 48
            Top = 316
            Width = 9
            Height = 16
            Caption = '9'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -13
            Font.Name = 'MS Sans Serif'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object Label177: TLabel
            Left = 40
            Top = 345
            Width = 17
            Height = 16
            Caption = '10'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -13
            Font.Name = 'MS Sans Serif'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object MaskEdit1: TMaskEdit
            Left = 120
            Top = 53
            Width = 69
            Height = 21
            EditMask = '!99\d99\m99\s;1;_'
            MaxLength = 9
            TabOrder = 0
            Text = '  d  m  s'
            OnChange = DegSpacingChange
          end
          object MaskEdit2: TMaskEdit
            Tag = 1
            Left = 120
            Top = 81
            Width = 70
            Height = 21
            EditMask = '!99\d99\m99\s;1;_'
            MaxLength = 9
            TabOrder = 1
            Text = '  d  m  s'
            OnChange = DegSpacingChange
          end
          object MaskEdit3: TMaskEdit
            Tag = 2
            Left = 120
            Top = 110
            Width = 71
            Height = 21
            EditMask = '!99\d99\m99\s;1;_'
            MaxLength = 9
            TabOrder = 2
            Text = '  d  m  s'
            OnChange = DegSpacingChange
          end
          object MaskEdit4: TMaskEdit
            Tag = 3
            Left = 120
            Top = 139
            Width = 72
            Height = 21
            EditMask = '!99\d99\m99\s;1;_'
            MaxLength = 9
            TabOrder = 3
            Text = '  d  m  s'
            OnChange = DegSpacingChange
          end
          object MaskEdit5: TMaskEdit
            Tag = 4
            Left = 120
            Top = 167
            Width = 73
            Height = 21
            EditMask = '!99\d99\m99\s;1;_'
            MaxLength = 9
            TabOrder = 4
            Text = '  d  m  s'
            OnChange = DegSpacingChange
          end
          object MaskEdit6: TMaskEdit
            Tag = 5
            Left = 120
            Top = 196
            Width = 74
            Height = 21
            EditMask = '!99\d99\m99\s;1;_'
            MaxLength = 9
            TabOrder = 5
            Text = '  d  m  s'
            OnChange = DegSpacingChange
          end
          object MaskEdit7: TMaskEdit
            Tag = 6
            Left = 120
            Top = 225
            Width = 75
            Height = 21
            EditMask = '!99\d99\m99\s;1;_'
            MaxLength = 9
            TabOrder = 6
            Text = '  d  m  s'
            OnChange = DegSpacingChange
          end
          object MaskEdit8: TMaskEdit
            Tag = 7
            Left = 120
            Top = 253
            Width = 76
            Height = 21
            EditMask = '!99\d99\m99\s;1;_'
            MaxLength = 9
            TabOrder = 7
            Text = '  d  m  s'
            OnChange = DegSpacingChange
          end
          object MaskEdit9: TMaskEdit
            Tag = 8
            Left = 120
            Top = 282
            Width = 77
            Height = 21
            EditMask = '!99\d99\m99\s;1;_'
            MaxLength = 9
            TabOrder = 8
            Text = '  d  m  s'
            OnChange = DegSpacingChange
          end
          object MaskEdit10: TMaskEdit
            Tag = 9
            Left = 120
            Top = 311
            Width = 78
            Height = 21
            EditMask = '!99\d99\m99\s;1;_'
            MaxLength = 9
            TabOrder = 9
            Text = '  d  m  s'
            OnChange = DegSpacingChange
          end
          object MaskEdit11: TMaskEdit
            Tag = 10
            Left = 120
            Top = 340
            Width = 79
            Height = 21
            EditMask = '!99\d99\m99\s;1;_'
            MaxLength = 9
            TabOrder = 10
            Text = '  d  m  s'
            OnChange = DegSpacingChange
          end
          object MaskEdit12: TMaskEdit
            Left = 264
            Top = 53
            Width = 80
            Height = 21
            EditMask = '!99\h99\m99\s;1;_'
            MaxLength = 9
            TabOrder = 11
            Text = '  h  m  s'
            OnChange = HourSpacingChange
          end
          object MaskEdit13: TMaskEdit
            Tag = 1
            Left = 264
            Top = 81
            Width = 81
            Height = 21
            EditMask = '!99\h99\m99\s;1;_'
            MaxLength = 9
            TabOrder = 12
            Text = '  h  m  s'
            OnChange = HourSpacingChange
          end
          object MaskEdit14: TMaskEdit
            Tag = 2
            Left = 264
            Top = 110
            Width = 82
            Height = 21
            EditMask = '!99\h99\m99\s;1;_'
            MaxLength = 9
            TabOrder = 13
            Text = '  h  m  s'
            OnChange = HourSpacingChange
          end
          object MaskEdit15: TMaskEdit
            Tag = 3
            Left = 264
            Top = 139
            Width = 83
            Height = 21
            EditMask = '!99\h99\m99\s;1;_'
            MaxLength = 9
            TabOrder = 14
            Text = '  h  m  s'
            OnChange = HourSpacingChange
          end
          object MaskEdit16: TMaskEdit
            Tag = 4
            Left = 264
            Top = 167
            Width = 84
            Height = 21
            EditMask = '!99\h99\m99\s;1;_'
            MaxLength = 9
            TabOrder = 15
            Text = '  h  m  s'
            OnChange = HourSpacingChange
          end
          object MaskEdit17: TMaskEdit
            Tag = 5
            Left = 264
            Top = 196
            Width = 85
            Height = 21
            EditMask = '!99\h99\m99\s;1;_'
            MaxLength = 9
            TabOrder = 16
            Text = '  h  m  s'
            OnChange = HourSpacingChange
          end
          object MaskEdit18: TMaskEdit
            Tag = 6
            Left = 264
            Top = 225
            Width = 86
            Height = 21
            EditMask = '!99\h99\m99\s;1;_'
            MaxLength = 9
            TabOrder = 17
            Text = '  h  m  s'
            OnChange = HourSpacingChange
          end
          object MaskEdit19: TMaskEdit
            Tag = 7
            Left = 264
            Top = 253
            Width = 87
            Height = 21
            EditMask = '!99\h99\m99\s;1;_'
            MaxLength = 9
            TabOrder = 18
            Text = '  h  m  s'
            OnChange = HourSpacingChange
          end
          object MaskEdit20: TMaskEdit
            Tag = 8
            Left = 264
            Top = 282
            Width = 88
            Height = 21
            EditMask = '!99\h99\m99\s;1;_'
            MaxLength = 9
            TabOrder = 19
            Text = '  h  m  s'
            OnChange = HourSpacingChange
          end
          object MaskEdit21: TMaskEdit
            Tag = 9
            Left = 264
            Top = 311
            Width = 89
            Height = 21
            EditMask = '!99\h99\m99\s;1;_'
            MaxLength = 9
            TabOrder = 20
            Text = '  h  m  s'
            OnChange = HourSpacingChange
          end
          object MaskEdit22: TMaskEdit
            Tag = 10
            Left = 264
            Top = 340
            Width = 90
            Height = 21
            EditMask = '!99\h99\m99\s;1;_'
            MaxLength = 9
            TabOrder = 21
            Text = '  h  m  s'
            OnChange = HourSpacingChange
          end
        end
        object t_objlist: TTabSheet
          Caption = 't_objlist'
          ImageIndex = 5
          TabVisible = False
          object Label95: TLabel
            Left = 0
            Top = 0
            Width = 86
            Height = 13
            Caption = 'Object List Setting'
          end
          object GroupBox5: TGroupBox
            Left = 24
            Top = 40
            Width = 369
            Height = 217
            Caption = 'Type of object to add to the list'
            TabOrder = 0
            object liststar: TCheckBox
              Left = 32
              Top = 24
              Width = 289
              Height = 30
              Caption = 'Stars'
              TabOrder = 0
              OnClick = liststarClick
            end
            object listneb: TCheckBox
              Left = 32
              Top = 58
              Width = 289
              Height = 30
              Caption = 'Nebulae'
              TabOrder = 1
              OnClick = listnebClick
            end
            object listpla: TCheckBox
              Left = 32
              Top = 92
              Width = 289
              Height = 30
              Caption = 'Solar System object'
              TabOrder = 2
              OnClick = listplaClick
            end
            object listvar: TCheckBox
              Left = 32
              Top = 126
              Width = 289
              Height = 30
              Caption = 'Variable Stars'
              TabOrder = 3
              OnClick = listvarClick
            end
            object listdbl: TCheckBox
              Left = 32
              Top = 160
              Width = 289
              Height = 30
              Caption = 'Double Stars'
              TabOrder = 4
              OnClick = listdblClick
            end
          end
        end
      end
    end
    object s_catalog: TTabSheet
      Caption = 's_catalog'
      ImageIndex = 3
      TabVisible = False
      object pa_catalog: TPageControl
        Left = 0
        Top = 0
        Width = 482
        Height = 445
        ActivePage = t_cdcstar
        Align = alClient
        TabOrder = 0
        object t_catalog: TTabSheet
          Caption = 't_catalog'
          TabVisible = False
          object Label1: TLabel
            Left = 0
            Top = 0
            Width = 112
            Height = 13
            Caption = 'Generic Catalog Setting'
          end
          object Label37: TLabel
            Left = 4
            Top = 28
            Width = 306
            Height = 13
            Caption = 'Stars and Nebulae catalogs prepared with the CATGEN software'
          end
          object addcat: TBitBtn
            Left = 144
            Top = 376
            Width = 75
            Height = 25
            Caption = 'Add'
            TabOrder = 0
            OnClick = addcatClick
          end
          object delcat: TBitBtn
            Left = 248
            Top = 376
            Width = 75
            Height = 25
            Caption = 'Delete'
            TabOrder = 1
            OnClick = delcatClick
          end
          object StringGrid3: TStringGrid
            Left = 0
            Top = 48
            Width = 474
            Height = 321
            ColCount = 6
            DefaultColWidth = 18
            DefaultRowHeight = 18
            RowCount = 2
            Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRowMoving, goEditing, goAlwaysShowEditor]
            TabOrder = 2
            OnDrawCell = StringGrid3DrawCell
            OnMouseUp = StringGrid3MouseUp
            OnSelectCell = StringGrid3SelectCell
            OnSetEditText = StringGrid3SetEditText2
            ColWidths = (
              18
              54
              54
              54
              260
              18)
          end
        end
        object t_cdcstar: TTabSheet
          Caption = 't_cdcstar'
          ImageIndex = 1
          TabVisible = False
          object Label2: TLabel
            Left = 0
            Top = 0
            Width = 124
            Height = 13
            Caption = 'CDC Stars Catalog Setting'
          end
          object Label65: TLabel
            Left = 72
            Top = 38
            Width = 14
            Height = 13
            Caption = 'pm'
          end
          object Label66: TLabel
            Left = 72
            Top = 61
            Width = 14
            Height = 13
            Caption = 'pm'
          end
          object Label87: TLabel
            Left = 72
            Top = 84
            Width = 14
            Height = 13
            Caption = 'pm'
          end
          object Label16: TLabel
            Left = 256
            Top = 16
            Width = 19
            Height = 13
            Caption = ' min'
          end
          object Label28: TLabel
            Left = 266
            Top = 0
            Width = 60
            Height = 13
            Alignment = taRightJustify
            Caption = 'Field number'
          end
          object Label17: TLabel
            Left = 293
            Top = 16
            Width = 22
            Height = 13
            Caption = ' max'
          end
          object Label27: TLabel
            Left = 330
            Top = 16
            Width = 46
            Height = 13
            Caption = 'Files Path'
          end
          object Label18: TLabel
            Left = 8
            Top = 38
            Width = 24
            Height = 13
            Caption = 'Stars'
          end
          object Label21: TLabel
            Left = 8
            Top = 325
            Width = 42
            Height = 26
            Caption = 'Deepsky'#13#10'2000'
          end
          object Label19: TLabel
            Left = 8
            Top = 248
            Width = 43
            Height = 13
            Caption = 'Variables'
          end
          object Label20: TLabel
            Left = 8
            Top = 287
            Width = 39
            Height = 13
            Caption = 'Doubles'
          end
          object BSCbox: TCheckBox
            Tag = 1
            Left = 96
            Top = 36
            Width = 121
            Height = 17
            Hint = 'Bright Stars Catalog 5th Edition  (Hoffleit 1991)'
            HelpContext = 100
            Caption = 'Bright Star Catalog'
            ParentShowHint = False
            ShowHint = True
            TabOrder = 0
            OnClick = CDCStarSelClick
          end
          object Fbsc1: TLongEdit
            Tag = 1
            Left = 256
            Top = 33
            Width = 30
            Height = 22
            Hint = '0..10'
            ParentShowHint = False
            ShowHint = True
            TabOrder = 1
            OnChange = CDCStarField1Change
            Value = 0
            MaxValue = 10
          end
          object Fbsc2: TLongEdit
            Tag = 1
            Left = 296
            Top = 33
            Width = 30
            Height = 22
            Hint = '0..10'
            ParentShowHint = False
            ShowHint = True
            TabOrder = 2
            OnChange = CDCStarField2Change
            Value = 10
            MaxValue = 10
          end
          object bsc3: TEdit
            Tag = 1
            Left = 330
            Top = 35
            Width = 111
            Height = 19
            Ctl3D = False
            ParentCtl3D = False
            TabOrder = 3
            Text = 'bsc3'
            OnChange = CDCStarPathChange
          end
          object BitBtn9: TBitBtn
            Tag = 1
            Left = 439
            Top = 35
            Width = 19
            Height = 19
            TabOrder = 4
            TabStop = False
            OnClick = CDCStarSelPathClick
            Glyph.Data = {
              36030000424D3603000000000000360000002800000010000000100000000100
              1800000000000003000000000000000000000000000000000000C0CFCFC0CFCF
              C0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CF
              CFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0
              CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCF
              0000000000000000000000000000000000000000000000000000000000000000
              00C0CFCFC0CFCFC0CFCFC0CFCFC0CFCF7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F
              7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F000000C0CFCFC0CFCFC0CFCFC0CFCF
              7F7F7FFFFFFFC0CFCF00FFFFC0CFCF00FFFFC0CFCF00FFFFC0CFCF00FFFF7F7F
              7F000000C0CFCFC0CFCFC0CFCFC0CFCF7F7F7FFFFFFF00FFFFC0CFCF00FFFFC0
              CFCF00FFFFC0CFCF00FFFFC0CFCF7F7F7F000000C0CFCFC0CFCFC0CFCFC0CFCF
              7F7F7FFFFFFFC0CFCF00FFFFC0CFCF00FFFFC0CFCF00FFFFC0CFCF00FFFF7F7F
              7F000000C0CFCFC0CFCFC0CFCFC0CFCF7F7F7FFFFFFF00FFFFC0CFCF00FFFFC0
              CFCF00FFFFC0CFCF00FFFFC0CFCF7F7F7F000000C0CFCFC0CFCFC0CFCFC0CFCF
              7F7F7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF7F7F
              7F000000C0CFCFC0CFCFC0CFCFC0CFCF7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F
              7F7F7F7F7F7F7F7F7F7F7F7F7F7F000000C0CFCFC0CFCFC0CFCFC0CFCFC0CFCF
              7F7F7F00FFFFFFFFFF00FFFFFFFFFF7F7F7FC0CFCFC0CFCFC0CFCFC0CFCFC0CF
              CFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCF7F7F7F7F7F7F7F7F7F7F7F7FC0
              CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCF
              C0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CF
              CFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0
              CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCF
              C0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CF
              CFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0
              CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCF}
            Margin = 0
          end
          object SKYbox: TCheckBox
            Tag = 2
            Left = 96
            Top = 59
            Width = 137
            Height = 17
            Hint = 'SKY2000 - Master Star Catalog  (Sande+ 1998)'
            HelpContext = 101
            Caption = 'SKY2000'
            ParentShowHint = False
            ShowHint = True
            TabOrder = 5
            OnClick = CDCStarSelClick
          end
          object Fsky1: TLongEdit
            Tag = 2
            Left = 256
            Top = 56
            Width = 30
            Height = 22
            Hint = '0..10'
            ParentShowHint = False
            ShowHint = True
            TabOrder = 6
            OnChange = CDCStarField1Change
            Value = 0
            MaxValue = 10
          end
          object Fsky2: TLongEdit
            Tag = 2
            Left = 296
            Top = 56
            Width = 30
            Height = 22
            Hint = '0..10'
            ParentShowHint = False
            ShowHint = True
            TabOrder = 7
            OnChange = CDCStarField2Change
            Value = 10
            MaxValue = 10
          end
          object sky3: TEdit
            Tag = 2
            Left = 330
            Top = 58
            Width = 111
            Height = 19
            Ctl3D = False
            ParentCtl3D = False
            TabOrder = 8
            Text = 'sky3'
            OnChange = CDCStarPathChange
          end
          object BitBtn10: TBitBtn
            Tag = 2
            Left = 439
            Top = 58
            Width = 19
            Height = 19
            TabOrder = 9
            TabStop = False
            OnClick = CDCStarSelPathClick
            Glyph.Data = {
              36030000424D3603000000000000360000002800000010000000100000000100
              1800000000000003000000000000000000000000000000000000C0CFCFC0CFCF
              C0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CF
              CFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0
              CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCF
              0000000000000000000000000000000000000000000000000000000000000000
              00C0CFCFC0CFCFC0CFCFC0CFCFC0CFCF7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F
              7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F000000C0CFCFC0CFCFC0CFCFC0CFCF
              7F7F7FFFFFFFC0CFCF00FFFFC0CFCF00FFFFC0CFCF00FFFFC0CFCF00FFFF7F7F
              7F000000C0CFCFC0CFCFC0CFCFC0CFCF7F7F7FFFFFFF00FFFFC0CFCF00FFFFC0
              CFCF00FFFFC0CFCF00FFFFC0CFCF7F7F7F000000C0CFCFC0CFCFC0CFCFC0CFCF
              7F7F7FFFFFFFC0CFCF00FFFFC0CFCF00FFFFC0CFCF00FFFFC0CFCF00FFFF7F7F
              7F000000C0CFCFC0CFCFC0CFCFC0CFCF7F7F7FFFFFFF00FFFFC0CFCF00FFFFC0
              CFCF00FFFFC0CFCF00FFFFC0CFCF7F7F7F000000C0CFCFC0CFCFC0CFCFC0CFCF
              7F7F7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF7F7F
              7F000000C0CFCFC0CFCFC0CFCFC0CFCF7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F
              7F7F7F7F7F7F7F7F7F7F7F7F7F7F000000C0CFCFC0CFCFC0CFCFC0CFCFC0CFCF
              7F7F7F00FFFFFFFFFF00FFFFFFFFFF7F7F7FC0CFCFC0CFCFC0CFCFC0CFCFC0CF
              CFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCF7F7F7F7F7F7F7F7F7F7F7F7FC0
              CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCF
              C0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CF
              CFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0
              CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCF
              C0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CF
              CFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0
              CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCF}
            Margin = 0
          end
          object TY2Box: TCheckBox
            Tag = 4
            Left = 96
            Top = 82
            Width = 137
            Height = 17
            Hint = 'The Tycho-2 Catalogue (Hog+ 2000)'
            HelpContext = 102
            Caption = 'Tycho 2 Catalog'
            ParentShowHint = False
            ShowHint = True
            TabOrder = 10
            OnClick = CDCStarSelClick
          end
          object Fty21: TLongEdit
            Tag = 4
            Left = 256
            Top = 79
            Width = 30
            Height = 22
            Hint = '0..10'
            ParentShowHint = False
            ShowHint = True
            TabOrder = 11
            OnChange = CDCStarField1Change
            Value = 0
            MaxValue = 10
          end
          object Fty22: TLongEdit
            Tag = 4
            Left = 296
            Top = 79
            Width = 30
            Height = 22
            Hint = '0..10'
            ParentShowHint = False
            ShowHint = True
            TabOrder = 12
            OnChange = CDCStarField2Change
            Value = 10
            MaxValue = 10
          end
          object ty23: TEdit
            Tag = 4
            Left = 330
            Top = 81
            Width = 111
            Height = 19
            Ctl3D = False
            ParentCtl3D = False
            TabOrder = 13
            Text = 'cat\tycho2'
            OnChange = CDCStarPathChange
          end
          object BitBtn12: TBitBtn
            Tag = 4
            Left = 439
            Top = 81
            Width = 19
            Height = 19
            TabOrder = 14
            TabStop = False
            OnClick = CDCStarSelPathClick
            Glyph.Data = {
              36030000424D3603000000000000360000002800000010000000100000000100
              1800000000000003000000000000000000000000000000000000C0CFCFC0CFCF
              C0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CF
              CFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0
              CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCF
              0000000000000000000000000000000000000000000000000000000000000000
              00C0CFCFC0CFCFC0CFCFC0CFCFC0CFCF7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F
              7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F000000C0CFCFC0CFCFC0CFCFC0CFCF
              7F7F7FFFFFFFC0CFCF00FFFFC0CFCF00FFFFC0CFCF00FFFFC0CFCF00FFFF7F7F
              7F000000C0CFCFC0CFCFC0CFCFC0CFCF7F7F7FFFFFFF00FFFFC0CFCF00FFFFC0
              CFCF00FFFFC0CFCF00FFFFC0CFCF7F7F7F000000C0CFCFC0CFCFC0CFCFC0CFCF
              7F7F7FFFFFFFC0CFCF00FFFFC0CFCF00FFFFC0CFCF00FFFFC0CFCF00FFFF7F7F
              7F000000C0CFCFC0CFCFC0CFCFC0CFCF7F7F7FFFFFFF00FFFFC0CFCF00FFFFC0
              CFCF00FFFFC0CFCF00FFFFC0CFCF7F7F7F000000C0CFCFC0CFCFC0CFCFC0CFCF
              7F7F7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF7F7F
              7F000000C0CFCFC0CFCFC0CFCFC0CFCF7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F
              7F7F7F7F7F7F7F7F7F7F7F7F7F7F000000C0CFCFC0CFCFC0CFCFC0CFCFC0CFCF
              7F7F7F00FFFFFFFFFF00FFFFFFFFFF7F7F7FC0CFCFC0CFCFC0CFCFC0CFCFC0CF
              CFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCF7F7F7F7F7F7F7F7F7F7F7F7FC0
              CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCF
              C0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CF
              CFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0
              CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCF
              C0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CF
              CFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0
              CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCF}
            Margin = 0
          end
          object GSCFBox: TCheckBox
            Tag = 6
            Left = 96
            Top = 105
            Width = 153
            Height = 17
            Hint = 
              'The Hubble Space Telescope Guide Star Catalog  ( Lasker 1990)  o' +
              'riginal FITS CDROM'
            HelpContext = 104
            Caption = 'HST GSC original FITS'
            ParentShowHint = False
            ShowHint = True
            TabOrder = 15
            OnClick = CDCStarSelClick
          end
          object GSCCbox: TCheckBox
            Tag = 7
            Left = 96
            Top = 129
            Width = 137
            Height = 17
            Hint = 
              'The Hubble Space Telescope Guide Star Catalog  ( Lasker 1990)  C' +
              'ompact CDS version '
            HelpContext = 104
            Caption = 'HST GSC compact'
            ParentShowHint = False
            ShowHint = True
            TabOrder = 16
            OnClick = CDCStarSelClick
          end
          object USNbox: TCheckBox
            Tag = 9
            Left = 96
            Top = 152
            Width = 65
            Height = 17
            Hint = 
              '- USNO-SA1.0 '#13#10'- USNO-A1.0 '#13#10'- USNO-A2.0'#13#10'  U.S. Naval Observato' +
              'ry CDROM'#39's'
            HelpContext = 113
            Caption = 'USNO-A'
            ParentShowHint = False
            ShowHint = True
            TabOrder = 17
            OnClick = CDCStarSelClick
          end
          object dsbasebox: TCheckBox
            Tag = 11
            Left = 96
            Top = 325
            Width = 153
            Height = 17
            Hint = 'Deepsky 2000 base directory with stars to magnitude 5.5'
            HelpContext = 104
            Caption = 'Deepsky 2000 base'
            ParentShowHint = False
            ShowHint = True
            TabOrder = 18
            OnClick = CDCStarSelClick
          end
          object dstycBox: TCheckBox
            Tag = 12
            Left = 96
            Top = 349
            Width = 153
            Height = 17
            Hint = 'Tycho Catalog from Deepsky 2000 CDROM'
            HelpContext = 104
            Caption = 'Deepsky 2000 Super Tycho'
            ParentShowHint = False
            ShowHint = True
            TabOrder = 19
            OnClick = CDCStarSelClick
          end
          object dsgscBox: TCheckBox
            Tag = 13
            Left = 96
            Top = 373
            Width = 153
            Height = 17
            Hint = 
              'The Hubble Space Telescope Guide Star Catalog from Deepsky 2000 ' +
              'CDROM'
            HelpContext = 104
            Caption = 'Deepsky 2000 HST GSC'
            ParentShowHint = False
            ShowHint = True
            TabOrder = 20
            OnClick = CDCStarSelClick
          end
          object USNBright: TCheckBox
            Tag = 9
            Left = 168
            Top = 152
            Width = 81
            Height = 17
            Caption = 'Bright stars'
            TabOrder = 21
            OnClick = USNBrightClick
          end
          object fgscf1: TLongEdit
            Tag = 6
            Left = 256
            Top = 102
            Width = 30
            Height = 22
            Hint = '0..10'
            ParentShowHint = False
            ShowHint = True
            TabOrder = 22
            OnChange = CDCStarField1Change
            Value = 0
            MaxValue = 10
          end
          object fgscc1: TLongEdit
            Tag = 7
            Left = 256
            Top = 126
            Width = 30
            Height = 22
            Hint = '0..10'
            ParentShowHint = False
            ShowHint = True
            TabOrder = 23
            OnChange = CDCStarField1Change
            Value = 0
            MaxValue = 10
          end
          object fusn1: TLongEdit
            Tag = 9
            Left = 256
            Top = 149
            Width = 30
            Height = 22
            Hint = '0..10'
            ParentShowHint = False
            ShowHint = True
            TabOrder = 24
            OnChange = CDCStarField1Change
            Value = 0
            MaxValue = 10
          end
          object dsbase1: TLongEdit
            Tag = 11
            Left = 256
            Top = 322
            Width = 30
            Height = 22
            Hint = '0..10'
            ParentShowHint = False
            ShowHint = True
            TabOrder = 25
            OnChange = CDCStarField1Change
            Value = 0
            MaxValue = 10
          end
          object dstyc1: TLongEdit
            Tag = 12
            Left = 256
            Top = 346
            Width = 30
            Height = 22
            Hint = '0..10'
            ParentShowHint = False
            ShowHint = True
            TabOrder = 26
            OnChange = CDCStarField1Change
            Value = 0
            MaxValue = 10
          end
          object dsgsc1: TLongEdit
            Tag = 13
            Left = 256
            Top = 370
            Width = 30
            Height = 22
            Hint = '0..10'
            ParentShowHint = False
            ShowHint = True
            TabOrder = 27
            OnChange = CDCStarField1Change
            Value = 0
            MaxValue = 10
          end
          object dsgsc2: TLongEdit
            Tag = 13
            Left = 296
            Top = 370
            Width = 30
            Height = 22
            Hint = '0..10'
            ParentShowHint = False
            ShowHint = True
            TabOrder = 28
            OnChange = CDCStarField2Change
            Value = 10
            MaxValue = 10
          end
          object dstyc2: TLongEdit
            Tag = 12
            Left = 296
            Top = 346
            Width = 30
            Height = 22
            Hint = '0..10'
            ParentShowHint = False
            ShowHint = True
            TabOrder = 29
            OnChange = CDCStarField2Change
            Value = 10
            MaxValue = 10
          end
          object dsbase2: TLongEdit
            Tag = 11
            Left = 296
            Top = 322
            Width = 30
            Height = 22
            Hint = '0..10'
            ParentShowHint = False
            ShowHint = True
            TabOrder = 30
            OnChange = CDCStarField2Change
            Value = 10
            MaxValue = 10
          end
          object fusn2: TLongEdit
            Tag = 9
            Left = 296
            Top = 149
            Width = 30
            Height = 22
            Hint = '0..10'
            ParentShowHint = False
            ShowHint = True
            TabOrder = 31
            OnChange = CDCStarField2Change
            Value = 2
            MaxValue = 10
          end
          object fgscc2: TLongEdit
            Tag = 7
            Left = 296
            Top = 126
            Width = 30
            Height = 22
            Hint = '0..10'
            ParentShowHint = False
            ShowHint = True
            TabOrder = 32
            OnChange = CDCStarField2Change
            Value = 2
            MaxValue = 10
          end
          object fgscf2: TLongEdit
            Tag = 6
            Left = 296
            Top = 102
            Width = 30
            Height = 22
            Hint = '0..10'
            ParentShowHint = False
            ShowHint = True
            TabOrder = 33
            OnChange = CDCStarField2Change
            Value = 2
            MaxValue = 10
          end
          object gscf3: TEdit
            Tag = 6
            Left = 330
            Top = 104
            Width = 111
            Height = 19
            Ctl3D = False
            ParentCtl3D = False
            TabOrder = 34
            Text = 'gscf3'
            OnChange = CDCStarPathChange
          end
          object gscc3: TEdit
            Tag = 7
            Left = 330
            Top = 128
            Width = 111
            Height = 19
            Ctl3D = False
            ParentCtl3D = False
            TabOrder = 35
            Text = 'gscc3'
            OnChange = CDCStarPathChange
          end
          object usn3: TEdit
            Tag = 9
            Left = 330
            Top = 151
            Width = 111
            Height = 19
            Ctl3D = False
            ParentCtl3D = False
            TabOrder = 36
            Text = 'usn3'
            OnChange = CDCStarPathChange
          end
          object dsbase3: TEdit
            Tag = 11
            Left = 330
            Top = 324
            Width = 111
            Height = 19
            Ctl3D = False
            ParentCtl3D = False
            TabOrder = 37
            Text = 'dsbase3'
            OnChange = CDCStarPathChange
          end
          object dstyc3: TEdit
            Tag = 12
            Left = 330
            Top = 348
            Width = 111
            Height = 19
            Ctl3D = False
            ParentCtl3D = False
            TabOrder = 38
            Text = 'dstyc3'
            OnChange = CDCStarPathChange
          end
          object dsgsc3: TEdit
            Tag = 13
            Left = 330
            Top = 372
            Width = 111
            Height = 19
            Ctl3D = False
            ParentCtl3D = False
            TabOrder = 39
            Text = 'dsgsc3'
            OnChange = CDCStarPathChange
          end
          object BitBtn22: TBitBtn
            Tag = 13
            Left = 439
            Top = 372
            Width = 19
            Height = 19
            TabOrder = 40
            TabStop = False
            OnClick = CDCStarSelPathClick
            Glyph.Data = {
              36030000424D3603000000000000360000002800000010000000100000000100
              1800000000000003000000000000000000000000000000000000C0CFCFC0CFCF
              C0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CF
              CFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0
              CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCF
              0000000000000000000000000000000000000000000000000000000000000000
              00C0CFCFC0CFCFC0CFCFC0CFCFC0CFCF7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F
              7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F000000C0CFCFC0CFCFC0CFCFC0CFCF
              7F7F7FFFFFFFC0CFCF00FFFFC0CFCF00FFFFC0CFCF00FFFFC0CFCF00FFFF7F7F
              7F000000C0CFCFC0CFCFC0CFCFC0CFCF7F7F7FFFFFFF00FFFFC0CFCF00FFFFC0
              CFCF00FFFFC0CFCF00FFFFC0CFCF7F7F7F000000C0CFCFC0CFCFC0CFCFC0CFCF
              7F7F7FFFFFFFC0CFCF00FFFFC0CFCF00FFFFC0CFCF00FFFFC0CFCF00FFFF7F7F
              7F000000C0CFCFC0CFCFC0CFCFC0CFCF7F7F7FFFFFFF00FFFFC0CFCF00FFFFC0
              CFCF00FFFFC0CFCF00FFFFC0CFCF7F7F7F000000C0CFCFC0CFCFC0CFCFC0CFCF
              7F7F7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF7F7F
              7F000000C0CFCFC0CFCFC0CFCFC0CFCF7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F
              7F7F7F7F7F7F7F7F7F7F7F7F7F7F000000C0CFCFC0CFCFC0CFCFC0CFCFC0CFCF
              7F7F7F00FFFFFFFFFF00FFFFFFFFFF7F7F7FC0CFCFC0CFCFC0CFCFC0CFCFC0CF
              CFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCF7F7F7F7F7F7F7F7F7F7F7F7FC0
              CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCF
              C0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CF
              CFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0
              CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCF
              C0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CF
              CFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0
              CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCF}
            Margin = 0
          end
          object BitBtn21: TBitBtn
            Tag = 12
            Left = 439
            Top = 348
            Width = 19
            Height = 19
            TabOrder = 41
            TabStop = False
            OnClick = CDCStarSelPathClick
            Glyph.Data = {
              36030000424D3603000000000000360000002800000010000000100000000100
              1800000000000003000000000000000000000000000000000000C0CFCFC0CFCF
              C0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CF
              CFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0
              CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCF
              0000000000000000000000000000000000000000000000000000000000000000
              00C0CFCFC0CFCFC0CFCFC0CFCFC0CFCF7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F
              7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F000000C0CFCFC0CFCFC0CFCFC0CFCF
              7F7F7FFFFFFFC0CFCF00FFFFC0CFCF00FFFFC0CFCF00FFFFC0CFCF00FFFF7F7F
              7F000000C0CFCFC0CFCFC0CFCFC0CFCF7F7F7FFFFFFF00FFFFC0CFCF00FFFFC0
              CFCF00FFFFC0CFCF00FFFFC0CFCF7F7F7F000000C0CFCFC0CFCFC0CFCFC0CFCF
              7F7F7FFFFFFFC0CFCF00FFFFC0CFCF00FFFFC0CFCF00FFFFC0CFCF00FFFF7F7F
              7F000000C0CFCFC0CFCFC0CFCFC0CFCF7F7F7FFFFFFF00FFFFC0CFCF00FFFFC0
              CFCF00FFFFC0CFCF00FFFFC0CFCF7F7F7F000000C0CFCFC0CFCFC0CFCFC0CFCF
              7F7F7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF7F7F
              7F000000C0CFCFC0CFCFC0CFCFC0CFCF7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F
              7F7F7F7F7F7F7F7F7F7F7F7F7F7F000000C0CFCFC0CFCFC0CFCFC0CFCFC0CFCF
              7F7F7F00FFFFFFFFFF00FFFFFFFFFF7F7F7FC0CFCFC0CFCFC0CFCFC0CFCFC0CF
              CFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCF7F7F7F7F7F7F7F7F7F7F7F7FC0
              CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCF
              C0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CF
              CFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0
              CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCF
              C0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CF
              CFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0
              CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCF}
            Margin = 0
          end
          object BitBtn20: TBitBtn
            Tag = 11
            Left = 439
            Top = 324
            Width = 19
            Height = 19
            TabOrder = 42
            TabStop = False
            OnClick = CDCStarSelPathClick
            Glyph.Data = {
              36030000424D3603000000000000360000002800000010000000100000000100
              1800000000000003000000000000000000000000000000000000C0CFCFC0CFCF
              C0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CF
              CFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0
              CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCF
              0000000000000000000000000000000000000000000000000000000000000000
              00C0CFCFC0CFCFC0CFCFC0CFCFC0CFCF7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F
              7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F000000C0CFCFC0CFCFC0CFCFC0CFCF
              7F7F7FFFFFFFC0CFCF00FFFFC0CFCF00FFFFC0CFCF00FFFFC0CFCF00FFFF7F7F
              7F000000C0CFCFC0CFCFC0CFCFC0CFCF7F7F7FFFFFFF00FFFFC0CFCF00FFFFC0
              CFCF00FFFFC0CFCF00FFFFC0CFCF7F7F7F000000C0CFCFC0CFCFC0CFCFC0CFCF
              7F7F7FFFFFFFC0CFCF00FFFFC0CFCF00FFFFC0CFCF00FFFFC0CFCF00FFFF7F7F
              7F000000C0CFCFC0CFCFC0CFCFC0CFCF7F7F7FFFFFFF00FFFFC0CFCF00FFFFC0
              CFCF00FFFFC0CFCF00FFFFC0CFCF7F7F7F000000C0CFCFC0CFCFC0CFCFC0CFCF
              7F7F7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF7F7F
              7F000000C0CFCFC0CFCFC0CFCFC0CFCF7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F
              7F7F7F7F7F7F7F7F7F7F7F7F7F7F000000C0CFCFC0CFCFC0CFCFC0CFCFC0CFCF
              7F7F7F00FFFFFFFFFF00FFFFFFFFFF7F7F7FC0CFCFC0CFCFC0CFCFC0CFCFC0CF
              CFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCF7F7F7F7F7F7F7F7F7F7F7F7FC0
              CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCF
              C0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CF
              CFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0
              CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCF
              C0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CF
              CFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0
              CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCF}
            Margin = 0
          end
          object BitBtn19: TBitBtn
            Tag = 9
            Left = 439
            Top = 151
            Width = 19
            Height = 19
            TabOrder = 43
            TabStop = False
            OnClick = CDCStarSelPathClick
            Glyph.Data = {
              36030000424D3603000000000000360000002800000010000000100000000100
              1800000000000003000000000000000000000000000000000000C0CFCFC0CFCF
              C0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CF
              CFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0
              CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCF
              0000000000000000000000000000000000000000000000000000000000000000
              00C0CFCFC0CFCFC0CFCFC0CFCFC0CFCF7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F
              7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F000000C0CFCFC0CFCFC0CFCFC0CFCF
              7F7F7FFFFFFFC0CFCF00FFFFC0CFCF00FFFFC0CFCF00FFFFC0CFCF00FFFF7F7F
              7F000000C0CFCFC0CFCFC0CFCFC0CFCF7F7F7FFFFFFF00FFFFC0CFCF00FFFFC0
              CFCF00FFFFC0CFCF00FFFFC0CFCF7F7F7F000000C0CFCFC0CFCFC0CFCFC0CFCF
              7F7F7FFFFFFFC0CFCF00FFFFC0CFCF00FFFFC0CFCF00FFFFC0CFCF00FFFF7F7F
              7F000000C0CFCFC0CFCFC0CFCFC0CFCF7F7F7FFFFFFF00FFFFC0CFCF00FFFFC0
              CFCF00FFFFC0CFCF00FFFFC0CFCF7F7F7F000000C0CFCFC0CFCFC0CFCFC0CFCF
              7F7F7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF7F7F
              7F000000C0CFCFC0CFCFC0CFCFC0CFCF7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F
              7F7F7F7F7F7F7F7F7F7F7F7F7F7F000000C0CFCFC0CFCFC0CFCFC0CFCFC0CFCF
              7F7F7F00FFFFFFFFFF00FFFFFFFFFF7F7F7FC0CFCFC0CFCFC0CFCFC0CFCFC0CF
              CFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCF7F7F7F7F7F7F7F7F7F7F7F7FC0
              CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCF
              C0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CF
              CFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0
              CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCF
              C0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CF
              CFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0
              CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCF}
            Margin = 0
          end
          object BitBtn17: TBitBtn
            Tag = 7
            Left = 439
            Top = 128
            Width = 19
            Height = 19
            TabOrder = 44
            TabStop = False
            OnClick = CDCStarSelPathClick
            Glyph.Data = {
              36030000424D3603000000000000360000002800000010000000100000000100
              1800000000000003000000000000000000000000000000000000C0CFCFC0CFCF
              C0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CF
              CFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0
              CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCF
              0000000000000000000000000000000000000000000000000000000000000000
              00C0CFCFC0CFCFC0CFCFC0CFCFC0CFCF7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F
              7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F000000C0CFCFC0CFCFC0CFCFC0CFCF
              7F7F7FFFFFFFC0CFCF00FFFFC0CFCF00FFFFC0CFCF00FFFFC0CFCF00FFFF7F7F
              7F000000C0CFCFC0CFCFC0CFCFC0CFCF7F7F7FFFFFFF00FFFFC0CFCF00FFFFC0
              CFCF00FFFFC0CFCF00FFFFC0CFCF7F7F7F000000C0CFCFC0CFCFC0CFCFC0CFCF
              7F7F7FFFFFFFC0CFCF00FFFFC0CFCF00FFFFC0CFCF00FFFFC0CFCF00FFFF7F7F
              7F000000C0CFCFC0CFCFC0CFCFC0CFCF7F7F7FFFFFFF00FFFFC0CFCF00FFFFC0
              CFCF00FFFFC0CFCF00FFFFC0CFCF7F7F7F000000C0CFCFC0CFCFC0CFCFC0CFCF
              7F7F7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF7F7F
              7F000000C0CFCFC0CFCFC0CFCFC0CFCF7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F
              7F7F7F7F7F7F7F7F7F7F7F7F7F7F000000C0CFCFC0CFCFC0CFCFC0CFCFC0CFCF
              7F7F7F00FFFFFFFFFF00FFFFFFFFFF7F7F7FC0CFCFC0CFCFC0CFCFC0CFCFC0CF
              CFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCF7F7F7F7F7F7F7F7F7F7F7F7FC0
              CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCF
              C0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CF
              CFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0
              CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCF
              C0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CF
              CFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0
              CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCF}
            Margin = 0
          end
          object BitBtn16: TBitBtn
            Tag = 6
            Left = 439
            Top = 104
            Width = 19
            Height = 19
            TabOrder = 45
            TabStop = False
            OnClick = CDCStarSelPathClick
            Glyph.Data = {
              36030000424D3603000000000000360000002800000010000000100000000100
              1800000000000003000000000000000000000000000000000000C0CFCFC0CFCF
              C0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CF
              CFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0
              CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCF
              0000000000000000000000000000000000000000000000000000000000000000
              00C0CFCFC0CFCFC0CFCFC0CFCFC0CFCF7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F
              7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F000000C0CFCFC0CFCFC0CFCFC0CFCF
              7F7F7FFFFFFFC0CFCF00FFFFC0CFCF00FFFFC0CFCF00FFFFC0CFCF00FFFF7F7F
              7F000000C0CFCFC0CFCFC0CFCFC0CFCF7F7F7FFFFFFF00FFFFC0CFCF00FFFFC0
              CFCF00FFFFC0CFCF00FFFFC0CFCF7F7F7F000000C0CFCFC0CFCFC0CFCFC0CFCF
              7F7F7FFFFFFFC0CFCF00FFFFC0CFCF00FFFFC0CFCF00FFFFC0CFCF00FFFF7F7F
              7F000000C0CFCFC0CFCFC0CFCFC0CFCF7F7F7FFFFFFF00FFFFC0CFCF00FFFFC0
              CFCF00FFFFC0CFCF00FFFFC0CFCF7F7F7F000000C0CFCFC0CFCFC0CFCFC0CFCF
              7F7F7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF7F7F
              7F000000C0CFCFC0CFCFC0CFCFC0CFCF7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F
              7F7F7F7F7F7F7F7F7F7F7F7F7F7F000000C0CFCFC0CFCFC0CFCFC0CFCFC0CFCF
              7F7F7F00FFFFFFFFFF00FFFFFFFFFF7F7F7FC0CFCFC0CFCFC0CFCFC0CFCFC0CF
              CFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCF7F7F7F7F7F7F7F7F7F7F7F7FC0
              CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCF
              C0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CF
              CFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0
              CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCF
              C0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CF
              CFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0
              CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCF}
            Margin = 0
          end
          object BitBtn14: TBitBtn
            Tag = 1
            Left = 439
            Top = 246
            Width = 19
            Height = 19
            TabOrder = 46
            TabStop = False
            OnClick = BitBtn14Click
            Glyph.Data = {
              36030000424D3603000000000000360000002800000010000000100000000100
              1800000000000003000000000000000000000000000000000000C0CFCFC0CFCF
              C0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CF
              CFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0
              CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCF
              0000000000000000000000000000000000000000000000000000000000000000
              00C0CFCFC0CFCFC0CFCFC0CFCFC0CFCF7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F
              7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F000000C0CFCFC0CFCFC0CFCFC0CFCF
              7F7F7FFFFFFFC0CFCF00FFFFC0CFCF00FFFFC0CFCF00FFFFC0CFCF00FFFF7F7F
              7F000000C0CFCFC0CFCFC0CFCFC0CFCF7F7F7FFFFFFF00FFFFC0CFCF00FFFFC0
              CFCF00FFFFC0CFCF00FFFFC0CFCF7F7F7F000000C0CFCFC0CFCFC0CFCFC0CFCF
              7F7F7FFFFFFFC0CFCF00FFFFC0CFCF00FFFFC0CFCF00FFFFC0CFCF00FFFF7F7F
              7F000000C0CFCFC0CFCFC0CFCFC0CFCF7F7F7FFFFFFF00FFFFC0CFCF00FFFFC0
              CFCF00FFFFC0CFCF00FFFFC0CFCF7F7F7F000000C0CFCFC0CFCFC0CFCFC0CFCF
              7F7F7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF7F7F
              7F000000C0CFCFC0CFCFC0CFCFC0CFCF7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F
              7F7F7F7F7F7F7F7F7F7F7F7F7F7F000000C0CFCFC0CFCFC0CFCFC0CFCFC0CFCF
              7F7F7F00FFFFFFFFFF00FFFFFFFFFF7F7F7FC0CFCFC0CFCFC0CFCFC0CFCFC0CF
              CFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCF7F7F7F7F7F7F7F7F7F7F7F7FC0
              CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCF
              C0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CF
              CFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0
              CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCF
              C0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CF
              CFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0
              CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCF}
            Margin = 0
          end
          object BitBtn15: TBitBtn
            Tag = 1
            Left = 439
            Top = 285
            Width = 19
            Height = 19
            TabOrder = 47
            TabStop = False
            OnClick = BitBtn15Click
            Glyph.Data = {
              36030000424D3603000000000000360000002800000010000000100000000100
              1800000000000003000000000000000000000000000000000000C0CFCFC0CFCF
              C0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CF
              CFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0
              CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCF
              0000000000000000000000000000000000000000000000000000000000000000
              00C0CFCFC0CFCFC0CFCFC0CFCFC0CFCF7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F
              7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F000000C0CFCFC0CFCFC0CFCFC0CFCF
              7F7F7FFFFFFFC0CFCF00FFFFC0CFCF00FFFFC0CFCF00FFFFC0CFCF00FFFF7F7F
              7F000000C0CFCFC0CFCFC0CFCFC0CFCF7F7F7FFFFFFF00FFFFC0CFCF00FFFFC0
              CFCF00FFFFC0CFCF00FFFFC0CFCF7F7F7F000000C0CFCFC0CFCFC0CFCFC0CFCF
              7F7F7FFFFFFFC0CFCF00FFFFC0CFCF00FFFFC0CFCF00FFFFC0CFCF00FFFF7F7F
              7F000000C0CFCFC0CFCFC0CFCFC0CFCF7F7F7FFFFFFF00FFFFC0CFCF00FFFFC0
              CFCF00FFFFC0CFCF00FFFFC0CFCF7F7F7F000000C0CFCFC0CFCFC0CFCFC0CFCF
              7F7F7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF7F7F
              7F000000C0CFCFC0CFCFC0CFCFC0CFCF7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F
              7F7F7F7F7F7F7F7F7F7F7F7F7F7F000000C0CFCFC0CFCFC0CFCFC0CFCFC0CFCF
              7F7F7F00FFFFFFFFFF00FFFFFFFFFF7F7F7FC0CFCFC0CFCFC0CFCFC0CFCFC0CF
              CFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCF7F7F7F7F7F7F7F7F7F7F7F7FC0
              CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCF
              C0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CF
              CFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0
              CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCF
              C0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CF
              CFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0
              CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCF}
            Margin = 0
          end
          object wds3: TEdit
            Tag = 1
            Left = 330
            Top = 285
            Width = 111
            Height = 19
            Ctl3D = False
            ParentCtl3D = False
            TabOrder = 48
            Text = 'wds3'
            OnChange = wds3Change
          end
          object gcv3: TEdit
            Tag = 1
            Left = 330
            Top = 246
            Width = 111
            Height = 19
            Ctl3D = False
            ParentCtl3D = False
            TabOrder = 49
            Text = 'gcv3'
            OnChange = gcv3Change
          end
          object Fgcv2: TLongEdit
            Tag = 1
            Left = 296
            Top = 244
            Width = 30
            Height = 22
            Hint = '0..10'
            ParentShowHint = False
            ShowHint = True
            TabOrder = 50
            OnChange = Fgcv2Change
            Value = 10
            MaxValue = 10
          end
          object Fwds2: TLongEdit
            Tag = 1
            Left = 296
            Top = 283
            Width = 30
            Height = 22
            Hint = '0..10'
            ParentShowHint = False
            ShowHint = True
            TabOrder = 51
            OnChange = Fwds2Change
            Value = 10
            MaxValue = 10
          end
          object Fwds1: TLongEdit
            Tag = 1
            Left = 256
            Top = 283
            Width = 30
            Height = 22
            Hint = '0..10'
            ParentShowHint = False
            ShowHint = True
            TabOrder = 52
            OnChange = Fwds1Change
            Value = 0
            MaxValue = 10
          end
          object Fgcv1: TLongEdit
            Tag = 1
            Left = 256
            Top = 244
            Width = 30
            Height = 22
            Hint = '0..10'
            ParentShowHint = False
            ShowHint = True
            TabOrder = 53
            OnChange = Fgcv1Change
            Value = 0
            MaxValue = 10
          end
          object GCVBox: TCheckBox
            Tag = 1
            Left = 96
            Top = 247
            Width = 137
            Height = 17
            Hint = 'General Catalog of Variable Stars    (Kholopov+ 1998)'
            HelpContext = 105
            Caption = 'Gen. Cat. Variable Star'
            ParentShowHint = False
            ShowHint = True
            TabOrder = 54
            OnClick = GCVBoxClick
          end
          object IRVar: TCheckBox
            Tag = 1
            Left = 96
            Top = 262
            Width = 137
            Height = 17
            Caption = 'Show IR variables'
            TabOrder = 55
            OnClick = IRVarClick
          end
          object WDSbox: TCheckBox
            Tag = 1
            Left = 96
            Top = 286
            Width = 153
            Height = 17
            Hint = 'The Washington Visual Double Star Catalog    (USNO, 2000)'
            HelpContext = 106
            Caption = 'Washington Double Star'
            ParentShowHint = False
            ShowHint = True
            TabOrder = 56
            OnClick = WDSboxClick
          end
        end
        object t_cdcneb: TTabSheet
          Caption = 't_cdcneb'
          ImageIndex = 2
          TabVisible = False
          object Bevel5: TBevel
            Left = 1
            Top = 136
            Width = 457
            Height = 233
            Style = bsRaised
          end
          object Bevel3: TBevel
            Left = 2
            Top = 40
            Width = 457
            Height = 41
            Style = bsRaised
          end
          object Bevel4: TBevel
            Left = 1
            Top = 88
            Width = 457
            Height = 41
            Style = bsRaised
          end
          object Label3: TLabel
            Left = 0
            Top = 0
            Width = 140
            Height = 13
            Caption = 'CDC Nebulae Catalog Setting'
          end
          object Label22: TLabel
            Left = 8
            Top = 148
            Width = 81
            Height = 40
            AutoSize = False
            Caption = 'Nebulae'
            WordWrap = True
          end
          object Label23: TLabel
            Left = 8
            Top = 188
            Width = 81
            Height = 41
            AutoSize = False
            Caption = 'Galaxies'
            WordWrap = True
          end
          object Label24: TLabel
            Left = 8
            Top = 253
            Width = 80
            Height = 34
            AutoSize = False
            Caption = 'Open clusters'
            WordWrap = True
          end
          object Label25: TLabel
            Left = 8
            Top = 293
            Width = 81
            Height = 34
            AutoSize = False
            Caption = 'Globular clusters'
            WordWrap = True
          end
          object Label26: TLabel
            Left = 8
            Top = 333
            Width = 89
            Height = 35
            AutoSize = False
            Caption = 'Planetary nebulae'
            WordWrap = True
          end
          object Label69: TLabel
            Left = 8
            Top = 99
            Width = 37
            Height = 13
            Caption = 'General'
          end
          object Label15: TLabel
            Left = 266
            Top = 0
            Width = 60
            Height = 13
            Alignment = taRightJustify
            Caption = 'Field number'
          end
          object Label116: TLabel
            Left = 256
            Top = 16
            Width = 19
            Height = 13
            Caption = ' min'
          end
          object Label117: TLabel
            Left = 293
            Top = 16
            Width = 22
            Height = 13
            Caption = ' max'
          end
          object Label118: TLabel
            Left = 330
            Top = 16
            Width = 46
            Height = 13
            Caption = 'Files Path'
          end
          object Label119: TLabel
            Left = 8
            Top = 52
            Width = 34
            Height = 13
            Caption = 'Default'
          end
          object Label120: TLabel
            Left = 0
            Top = 381
            Width = 289
            Height = 13
            Alignment = taCenter
            Caption = 'Use only catalog from one of the three block at the same time'
          end
          object NGCbox: TCheckBox
            Tag = 2
            Left = 96
            Top = 99
            Width = 129
            Height = 17
            Hint = 
              'New General Catalogue of Nebulae and Cluster of Stars (Dreyer 18' +
              '88) (Sky Pub. Corp. 1988)'
            HelpContext = 107
            Caption = 'New General Catalog'
            ParentShowHint = False
            ShowHint = True
            TabOrder = 0
            OnClick = CDCNebSelClick
          end
          object RC3box: TCheckBox
            Tag = 4
            Left = 96
            Top = 188
            Width = 153
            Height = 17
            Hint = 
              'Third Reference Catalogue of Bright Galaxies (RC3) (de Vaucouleu' +
              'rs+ 1991)'
            HelpContext = 109
            Caption = '3'#39' Ref. Cat. Bright Galaxies'
            ParentShowHint = False
            ShowHint = True
            TabOrder = 1
            OnClick = CDCNebSelClick
          end
          object OCLbox: TCheckBox
            Tag = 6
            Left = 96
            Top = 253
            Width = 153
            Height = 17
            Hint = 'Open Cluster Data 5th Edition    (Lynga 1987)'
            HelpContext = 110
            Caption = 'Open Cluster Data'
            ParentShowHint = False
            ShowHint = True
            TabOrder = 2
            OnClick = CDCNebSelClick
          end
          object GCMbox: TCheckBox
            Tag = 7
            Left = 96
            Top = 293
            Width = 153
            Height = 17
            Hint = 'Globular Clusters in the Milky Way (Harris, 1997)'
            HelpContext = 111
            Caption = 'Globular Cl. in the Milky Way'
            ParentShowHint = False
            ShowHint = True
            TabOrder = 3
            OnClick = CDCNebSelClick
          end
          object GPNbox: TCheckBox
            Tag = 8
            Left = 96
            Top = 333
            Width = 153
            Height = 17
            Hint = 
              'Strasbourg-ESO Catalogue of Galactic Planetary Nebulae (Acker+, ' +
              '1992)'
            HelpContext = 112
            Caption = 'Cat, Galactic Planetary Neb. '
            ParentShowHint = False
            ShowHint = True
            TabOrder = 4
            OnClick = CDCNebSelClick
          end
          object LBNbox: TCheckBox
            Tag = 3
            Left = 96
            Top = 148
            Width = 153
            Height = 17
            Hint = 'Lynds'#39' Catalogue of Bright Nebulae    (Lynds 1965)'
            HelpContext = 108
            Caption = 'Lynds Bright Nebulae'
            ParentShowHint = False
            ShowHint = True
            TabOrder = 5
            OnClick = CDCNebSelClick
          end
          object ngc3: TEdit
            Tag = 2
            Left = 330
            Top = 98
            Width = 103
            Height = 19
            Ctl3D = False
            ParentCtl3D = False
            TabOrder = 6
            Text = 'ngc3'
            OnChange = CDCNebPathChange
          end
          object rc33: TEdit
            Tag = 4
            Left = 330
            Top = 187
            Width = 103
            Height = 19
            Ctl3D = False
            ParentCtl3D = False
            TabOrder = 7
            Text = 'rc33'
            OnChange = CDCNebPathChange
          end
          object lbn3: TEdit
            Tag = 3
            Left = 330
            Top = 147
            Width = 103
            Height = 19
            Ctl3D = False
            ParentCtl3D = False
            TabOrder = 8
            Text = 'lbn3'
            OnChange = CDCNebPathChange
          end
          object ocl3: TEdit
            Tag = 6
            Left = 330
            Top = 252
            Width = 103
            Height = 19
            Ctl3D = False
            ParentCtl3D = False
            TabOrder = 9
            Text = 'ocl3'
            OnChange = CDCNebPathChange
          end
          object gcm3: TEdit
            Tag = 7
            Left = 330
            Top = 292
            Width = 103
            Height = 19
            Ctl3D = False
            ParentCtl3D = False
            TabOrder = 10
            Text = 'gcm3'
            OnChange = CDCNebPathChange
          end
          object gpn3: TEdit
            Tag = 8
            Left = 330
            Top = 332
            Width = 103
            Height = 19
            Ctl3D = False
            ParentCtl3D = False
            TabOrder = 11
            Text = 'gpn3'
            OnChange = CDCNebPathChange
          end
          object PGCBox: TCheckBox
            Tag = 5
            Left = 96
            Top = 213
            Width = 153
            Height = 17
            Hint = 'Catalogue of Principal Galaxies (PGC)   (Paturel+ 1999)'
            HelpContext = 116
            Caption = 'Cat. of Principal Galaxies'
            ParentShowHint = False
            ShowHint = True
            TabOrder = 12
            OnClick = CDCNebSelClick
          end
          object pgc3: TEdit
            Tag = 5
            Left = 330
            Top = 212
            Width = 103
            Height = 19
            Ctl3D = False
            ParentCtl3D = False
            TabOrder = 13
            Text = 'rc33'
            OnChange = CDCNebPathChange
          end
          object SACbox: TCheckBox
            Tag = 1
            Left = 96
            Top = 52
            Width = 153
            Height = 17
            Hint = 'Saguaro Astronomy Club Database  7.2'
            HelpContext = 107
            Caption = 'SAC '
            ParentShowHint = False
            ShowHint = True
            TabOrder = 14
            OnClick = CDCNebSelClick
          end
          object sac3: TEdit
            Tag = 1
            Left = 330
            Top = 51
            Width = 103
            Height = 19
            Ctl3D = False
            ParentCtl3D = False
            TabOrder = 15
            Text = 'cat\sac'
            OnChange = CDCNebPathChange
          end
          object fngc1: TLongEdit
            Tag = 2
            Left = 256
            Top = 96
            Width = 30
            Height = 22
            Hint = '0..360'
            ParentShowHint = False
            ShowHint = True
            TabOrder = 16
            OnChange = CDCNebField1Change
            Value = 0
            MaxValue = 360
          end
          object fngc2: TLongEdit
            Tag = 2
            Left = 296
            Top = 96
            Width = 30
            Height = 22
            Hint = '0..360'
            ParentShowHint = False
            ShowHint = True
            TabOrder = 17
            OnChange = CDCNebField2Change
            Value = 0
            MaxValue = 360
          end
          object fsac1: TLongEdit
            Tag = 1
            Left = 256
            Top = 49
            Width = 30
            Height = 22
            Hint = '0..360'
            ParentShowHint = False
            ShowHint = True
            TabOrder = 18
            OnChange = CDCNebField1Change
            Value = 0
            MaxValue = 360
          end
          object fsac2: TLongEdit
            Tag = 1
            Left = 296
            Top = 49
            Width = 30
            Height = 22
            Hint = '0..360'
            ParentShowHint = False
            ShowHint = True
            TabOrder = 19
            OnChange = CDCNebField2Change
            Value = 360
            MaxValue = 360
          end
          object flbn1: TLongEdit
            Tag = 3
            Left = 256
            Top = 145
            Width = 30
            Height = 22
            Hint = '0..360'
            ParentShowHint = False
            ShowHint = True
            TabOrder = 20
            OnChange = CDCNebField1Change
            Value = 0
            MaxValue = 360
          end
          object flbn2: TLongEdit
            Tag = 3
            Left = 296
            Top = 145
            Width = 30
            Height = 22
            Hint = '0..360'
            ParentShowHint = False
            ShowHint = True
            TabOrder = 21
            OnChange = CDCNebField2Change
            Value = 0
            MaxValue = 360
          end
          object frc31: TLongEdit
            Tag = 4
            Left = 256
            Top = 185
            Width = 30
            Height = 22
            Hint = '0..360'
            ParentShowHint = False
            ShowHint = True
            TabOrder = 22
            OnChange = CDCNebField1Change
            Value = 0
            MaxValue = 360
          end
          object frc32: TLongEdit
            Tag = 4
            Left = 296
            Top = 185
            Width = 30
            Height = 22
            Hint = '0..360'
            ParentShowHint = False
            ShowHint = True
            TabOrder = 23
            OnChange = CDCNebField2Change
            Value = 0
            MaxValue = 360
          end
          object fpgc1: TLongEdit
            Tag = 5
            Left = 256
            Top = 210
            Width = 30
            Height = 22
            Hint = '0..360'
            ParentShowHint = False
            ShowHint = True
            TabOrder = 24
            OnChange = CDCNebField1Change
            Value = 0
            MaxValue = 360
          end
          object fpgc2: TLongEdit
            Tag = 5
            Left = 296
            Top = 210
            Width = 30
            Height = 22
            Hint = '0..360'
            ParentShowHint = False
            ShowHint = True
            TabOrder = 25
            OnChange = CDCNebField2Change
            Value = 0
            MaxValue = 360
          end
          object focl1: TLongEdit
            Tag = 6
            Left = 256
            Top = 250
            Width = 30
            Height = 22
            Hint = '0..360'
            ParentShowHint = False
            ShowHint = True
            TabOrder = 26
            OnChange = CDCNebField1Change
            Value = 0
            MaxValue = 360
          end
          object focl2: TLongEdit
            Tag = 6
            Left = 296
            Top = 250
            Width = 30
            Height = 22
            Hint = '0..360'
            ParentShowHint = False
            ShowHint = True
            TabOrder = 27
            OnChange = CDCNebField2Change
            Value = 0
            MaxValue = 360
          end
          object fgcm1: TLongEdit
            Tag = 7
            Left = 256
            Top = 290
            Width = 30
            Height = 22
            Hint = '0..360'
            ParentShowHint = False
            ShowHint = True
            TabOrder = 28
            OnChange = CDCNebField1Change
            Value = 0
            MaxValue = 360
          end
          object fgcm2: TLongEdit
            Tag = 7
            Left = 296
            Top = 290
            Width = 30
            Height = 22
            Hint = '0..360'
            ParentShowHint = False
            ShowHint = True
            TabOrder = 29
            OnChange = CDCNebField2Change
            Value = 0
            MaxValue = 360
          end
          object fgpn1: TLongEdit
            Tag = 8
            Left = 256
            Top = 330
            Width = 30
            Height = 22
            Hint = '0..360'
            ParentShowHint = False
            ShowHint = True
            TabOrder = 30
            OnChange = CDCNebField1Change
            Value = 0
            MaxValue = 360
          end
          object fgpn2: TLongEdit
            Tag = 8
            Left = 296
            Top = 330
            Width = 30
            Height = 22
            Hint = '0..360'
            ParentShowHint = False
            ShowHint = True
            TabOrder = 31
            OnChange = CDCNebField2Change
            Value = 0
            MaxValue = 360
          end
          object BitBtn23: TBitBtn
            Tag = 2
            Left = 431
            Top = 98
            Width = 19
            Height = 19
            TabOrder = 32
            TabStop = False
            OnClick = CDCNebSelPathClick
            Glyph.Data = {
              36030000424D3603000000000000360000002800000010000000100000000100
              1800000000000003000000000000000000000000000000000000C0CFCFC0CFCF
              C0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CF
              CFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0
              CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCF
              0000000000000000000000000000000000000000000000000000000000000000
              00C0CFCFC0CFCFC0CFCFC0CFCFC0CFCF7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F
              7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F000000C0CFCFC0CFCFC0CFCFC0CFCF
              7F7F7FFFFFFFC0CFCF00FFFFC0CFCF00FFFFC0CFCF00FFFFC0CFCF00FFFF7F7F
              7F000000C0CFCFC0CFCFC0CFCFC0CFCF7F7F7FFFFFFF00FFFFC0CFCF00FFFFC0
              CFCF00FFFFC0CFCF00FFFFC0CFCF7F7F7F000000C0CFCFC0CFCFC0CFCFC0CFCF
              7F7F7FFFFFFFC0CFCF00FFFFC0CFCF00FFFFC0CFCF00FFFFC0CFCF00FFFF7F7F
              7F000000C0CFCFC0CFCFC0CFCFC0CFCF7F7F7FFFFFFF00FFFFC0CFCF00FFFFC0
              CFCF00FFFFC0CFCF00FFFFC0CFCF7F7F7F000000C0CFCFC0CFCFC0CFCFC0CFCF
              7F7F7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF7F7F
              7F000000C0CFCFC0CFCFC0CFCFC0CFCF7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F
              7F7F7F7F7F7F7F7F7F7F7F7F7F7F000000C0CFCFC0CFCFC0CFCFC0CFCFC0CFCF
              7F7F7F00FFFFFFFFFF00FFFFFFFFFF7F7F7FC0CFCFC0CFCFC0CFCFC0CFCFC0CF
              CFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCF7F7F7F7F7F7F7F7F7F7F7F7FC0
              CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCF
              C0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CF
              CFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0
              CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCF
              C0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CF
              CFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0
              CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCF}
            Margin = 0
          end
          object BitBtn24: TBitBtn
            Tag = 1
            Left = 431
            Top = 51
            Width = 19
            Height = 19
            TabOrder = 33
            TabStop = False
            OnClick = CDCNebSelPathClick
            Glyph.Data = {
              36030000424D3603000000000000360000002800000010000000100000000100
              1800000000000003000000000000000000000000000000000000C0CFCFC0CFCF
              C0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CF
              CFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0
              CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCF
              0000000000000000000000000000000000000000000000000000000000000000
              00C0CFCFC0CFCFC0CFCFC0CFCFC0CFCF7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F
              7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F000000C0CFCFC0CFCFC0CFCFC0CFCF
              7F7F7FFFFFFFC0CFCF00FFFFC0CFCF00FFFFC0CFCF00FFFFC0CFCF00FFFF7F7F
              7F000000C0CFCFC0CFCFC0CFCFC0CFCF7F7F7FFFFFFF00FFFFC0CFCF00FFFFC0
              CFCF00FFFFC0CFCF00FFFFC0CFCF7F7F7F000000C0CFCFC0CFCFC0CFCFC0CFCF
              7F7F7FFFFFFFC0CFCF00FFFFC0CFCF00FFFFC0CFCF00FFFFC0CFCF00FFFF7F7F
              7F000000C0CFCFC0CFCFC0CFCFC0CFCF7F7F7FFFFFFF00FFFFC0CFCF00FFFFC0
              CFCF00FFFFC0CFCF00FFFFC0CFCF7F7F7F000000C0CFCFC0CFCFC0CFCFC0CFCF
              7F7F7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF7F7F
              7F000000C0CFCFC0CFCFC0CFCFC0CFCF7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F
              7F7F7F7F7F7F7F7F7F7F7F7F7F7F000000C0CFCFC0CFCFC0CFCFC0CFCFC0CFCF
              7F7F7F00FFFFFFFFFF00FFFFFFFFFF7F7F7FC0CFCFC0CFCFC0CFCFC0CFCFC0CF
              CFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCF7F7F7F7F7F7F7F7F7F7F7F7FC0
              CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCF
              C0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CF
              CFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0
              CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCF
              C0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CF
              CFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0
              CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCF}
            Margin = 0
          end
          object BitBtn25: TBitBtn
            Tag = 3
            Left = 431
            Top = 147
            Width = 19
            Height = 19
            TabOrder = 34
            TabStop = False
            OnClick = CDCNebSelPathClick
            Glyph.Data = {
              36030000424D3603000000000000360000002800000010000000100000000100
              1800000000000003000000000000000000000000000000000000C0CFCFC0CFCF
              C0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CF
              CFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0
              CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCF
              0000000000000000000000000000000000000000000000000000000000000000
              00C0CFCFC0CFCFC0CFCFC0CFCFC0CFCF7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F
              7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F000000C0CFCFC0CFCFC0CFCFC0CFCF
              7F7F7FFFFFFFC0CFCF00FFFFC0CFCF00FFFFC0CFCF00FFFFC0CFCF00FFFF7F7F
              7F000000C0CFCFC0CFCFC0CFCFC0CFCF7F7F7FFFFFFF00FFFFC0CFCF00FFFFC0
              CFCF00FFFFC0CFCF00FFFFC0CFCF7F7F7F000000C0CFCFC0CFCFC0CFCFC0CFCF
              7F7F7FFFFFFFC0CFCF00FFFFC0CFCF00FFFFC0CFCF00FFFFC0CFCF00FFFF7F7F
              7F000000C0CFCFC0CFCFC0CFCFC0CFCF7F7F7FFFFFFF00FFFFC0CFCF00FFFFC0
              CFCF00FFFFC0CFCF00FFFFC0CFCF7F7F7F000000C0CFCFC0CFCFC0CFCFC0CFCF
              7F7F7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF7F7F
              7F000000C0CFCFC0CFCFC0CFCFC0CFCF7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F
              7F7F7F7F7F7F7F7F7F7F7F7F7F7F000000C0CFCFC0CFCFC0CFCFC0CFCFC0CFCF
              7F7F7F00FFFFFFFFFF00FFFFFFFFFF7F7F7FC0CFCFC0CFCFC0CFCFC0CFCFC0CF
              CFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCF7F7F7F7F7F7F7F7F7F7F7F7FC0
              CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCF
              C0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CF
              CFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0
              CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCF
              C0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CF
              CFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0
              CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCF}
            Margin = 0
          end
          object BitBtn26: TBitBtn
            Tag = 4
            Left = 431
            Top = 187
            Width = 19
            Height = 19
            TabOrder = 35
            TabStop = False
            OnClick = CDCNebSelPathClick
            Glyph.Data = {
              36030000424D3603000000000000360000002800000010000000100000000100
              1800000000000003000000000000000000000000000000000000C0CFCFC0CFCF
              C0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CF
              CFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0
              CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCF
              0000000000000000000000000000000000000000000000000000000000000000
              00C0CFCFC0CFCFC0CFCFC0CFCFC0CFCF7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F
              7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F000000C0CFCFC0CFCFC0CFCFC0CFCF
              7F7F7FFFFFFFC0CFCF00FFFFC0CFCF00FFFFC0CFCF00FFFFC0CFCF00FFFF7F7F
              7F000000C0CFCFC0CFCFC0CFCFC0CFCF7F7F7FFFFFFF00FFFFC0CFCF00FFFFC0
              CFCF00FFFFC0CFCF00FFFFC0CFCF7F7F7F000000C0CFCFC0CFCFC0CFCFC0CFCF
              7F7F7FFFFFFFC0CFCF00FFFFC0CFCF00FFFFC0CFCF00FFFFC0CFCF00FFFF7F7F
              7F000000C0CFCFC0CFCFC0CFCFC0CFCF7F7F7FFFFFFF00FFFFC0CFCF00FFFFC0
              CFCF00FFFFC0CFCF00FFFFC0CFCF7F7F7F000000C0CFCFC0CFCFC0CFCFC0CFCF
              7F7F7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF7F7F
              7F000000C0CFCFC0CFCFC0CFCFC0CFCF7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F
              7F7F7F7F7F7F7F7F7F7F7F7F7F7F000000C0CFCFC0CFCFC0CFCFC0CFCFC0CFCF
              7F7F7F00FFFFFFFFFF00FFFFFFFFFF7F7F7FC0CFCFC0CFCFC0CFCFC0CFCFC0CF
              CFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCF7F7F7F7F7F7F7F7F7F7F7F7FC0
              CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCF
              C0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CF
              CFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0
              CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCF
              C0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CF
              CFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0
              CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCF}
            Margin = 0
          end
          object BitBtn27: TBitBtn
            Tag = 5
            Left = 431
            Top = 212
            Width = 19
            Height = 19
            TabOrder = 36
            TabStop = False
            OnClick = CDCNebSelPathClick
            Glyph.Data = {
              36030000424D3603000000000000360000002800000010000000100000000100
              1800000000000003000000000000000000000000000000000000C0CFCFC0CFCF
              C0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CF
              CFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0
              CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCF
              0000000000000000000000000000000000000000000000000000000000000000
              00C0CFCFC0CFCFC0CFCFC0CFCFC0CFCF7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F
              7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F000000C0CFCFC0CFCFC0CFCFC0CFCF
              7F7F7FFFFFFFC0CFCF00FFFFC0CFCF00FFFFC0CFCF00FFFFC0CFCF00FFFF7F7F
              7F000000C0CFCFC0CFCFC0CFCFC0CFCF7F7F7FFFFFFF00FFFFC0CFCF00FFFFC0
              CFCF00FFFFC0CFCF00FFFFC0CFCF7F7F7F000000C0CFCFC0CFCFC0CFCFC0CFCF
              7F7F7FFFFFFFC0CFCF00FFFFC0CFCF00FFFFC0CFCF00FFFFC0CFCF00FFFF7F7F
              7F000000C0CFCFC0CFCFC0CFCFC0CFCF7F7F7FFFFFFF00FFFFC0CFCF00FFFFC0
              CFCF00FFFFC0CFCF00FFFFC0CFCF7F7F7F000000C0CFCFC0CFCFC0CFCFC0CFCF
              7F7F7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF7F7F
              7F000000C0CFCFC0CFCFC0CFCFC0CFCF7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F
              7F7F7F7F7F7F7F7F7F7F7F7F7F7F000000C0CFCFC0CFCFC0CFCFC0CFCFC0CFCF
              7F7F7F00FFFFFFFFFF00FFFFFFFFFF7F7F7FC0CFCFC0CFCFC0CFCFC0CFCFC0CF
              CFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCF7F7F7F7F7F7F7F7F7F7F7F7FC0
              CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCF
              C0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CF
              CFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0
              CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCF
              C0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CF
              CFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0
              CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCF}
            Margin = 0
          end
          object BitBtn28: TBitBtn
            Tag = 6
            Left = 431
            Top = 252
            Width = 19
            Height = 19
            TabOrder = 37
            TabStop = False
            OnClick = CDCNebSelPathClick
            Glyph.Data = {
              36030000424D3603000000000000360000002800000010000000100000000100
              1800000000000003000000000000000000000000000000000000C0CFCFC0CFCF
              C0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CF
              CFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0
              CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCF
              0000000000000000000000000000000000000000000000000000000000000000
              00C0CFCFC0CFCFC0CFCFC0CFCFC0CFCF7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F
              7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F000000C0CFCFC0CFCFC0CFCFC0CFCF
              7F7F7FFFFFFFC0CFCF00FFFFC0CFCF00FFFFC0CFCF00FFFFC0CFCF00FFFF7F7F
              7F000000C0CFCFC0CFCFC0CFCFC0CFCF7F7F7FFFFFFF00FFFFC0CFCF00FFFFC0
              CFCF00FFFFC0CFCF00FFFFC0CFCF7F7F7F000000C0CFCFC0CFCFC0CFCFC0CFCF
              7F7F7FFFFFFFC0CFCF00FFFFC0CFCF00FFFFC0CFCF00FFFFC0CFCF00FFFF7F7F
              7F000000C0CFCFC0CFCFC0CFCFC0CFCF7F7F7FFFFFFF00FFFFC0CFCF00FFFFC0
              CFCF00FFFFC0CFCF00FFFFC0CFCF7F7F7F000000C0CFCFC0CFCFC0CFCFC0CFCF
              7F7F7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF7F7F
              7F000000C0CFCFC0CFCFC0CFCFC0CFCF7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F
              7F7F7F7F7F7F7F7F7F7F7F7F7F7F000000C0CFCFC0CFCFC0CFCFC0CFCFC0CFCF
              7F7F7F00FFFFFFFFFF00FFFFFFFFFF7F7F7FC0CFCFC0CFCFC0CFCFC0CFCFC0CF
              CFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCF7F7F7F7F7F7F7F7F7F7F7F7FC0
              CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCF
              C0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CF
              CFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0
              CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCF
              C0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CF
              CFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0
              CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCF}
            Margin = 0
          end
          object BitBtn29: TBitBtn
            Tag = 7
            Left = 431
            Top = 292
            Width = 19
            Height = 19
            TabOrder = 38
            TabStop = False
            OnClick = CDCNebSelPathClick
            Glyph.Data = {
              36030000424D3603000000000000360000002800000010000000100000000100
              1800000000000003000000000000000000000000000000000000C0CFCFC0CFCF
              C0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CF
              CFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0
              CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCF
              0000000000000000000000000000000000000000000000000000000000000000
              00C0CFCFC0CFCFC0CFCFC0CFCFC0CFCF7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F
              7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F000000C0CFCFC0CFCFC0CFCFC0CFCF
              7F7F7FFFFFFFC0CFCF00FFFFC0CFCF00FFFFC0CFCF00FFFFC0CFCF00FFFF7F7F
              7F000000C0CFCFC0CFCFC0CFCFC0CFCF7F7F7FFFFFFF00FFFFC0CFCF00FFFFC0
              CFCF00FFFFC0CFCF00FFFFC0CFCF7F7F7F000000C0CFCFC0CFCFC0CFCFC0CFCF
              7F7F7FFFFFFFC0CFCF00FFFFC0CFCF00FFFFC0CFCF00FFFFC0CFCF00FFFF7F7F
              7F000000C0CFCFC0CFCFC0CFCFC0CFCF7F7F7FFFFFFF00FFFFC0CFCF00FFFFC0
              CFCF00FFFFC0CFCF00FFFFC0CFCF7F7F7F000000C0CFCFC0CFCFC0CFCFC0CFCF
              7F7F7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF7F7F
              7F000000C0CFCFC0CFCFC0CFCFC0CFCF7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F
              7F7F7F7F7F7F7F7F7F7F7F7F7F7F000000C0CFCFC0CFCFC0CFCFC0CFCFC0CFCF
              7F7F7F00FFFFFFFFFF00FFFFFFFFFF7F7F7FC0CFCFC0CFCFC0CFCFC0CFCFC0CF
              CFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCF7F7F7F7F7F7F7F7F7F7F7F7FC0
              CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCF
              C0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CF
              CFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0
              CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCF
              C0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CF
              CFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0
              CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCF}
            Margin = 0
          end
          object BitBtn30: TBitBtn
            Tag = 8
            Left = 431
            Top = 332
            Width = 19
            Height = 19
            TabOrder = 39
            TabStop = False
            OnClick = CDCNebSelPathClick
            Glyph.Data = {
              36030000424D3603000000000000360000002800000010000000100000000100
              1800000000000003000000000000000000000000000000000000C0CFCFC0CFCF
              C0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CF
              CFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0
              CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCF
              0000000000000000000000000000000000000000000000000000000000000000
              00C0CFCFC0CFCFC0CFCFC0CFCFC0CFCF7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F
              7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F000000C0CFCFC0CFCFC0CFCFC0CFCF
              7F7F7FFFFFFFC0CFCF00FFFFC0CFCF00FFFFC0CFCF00FFFFC0CFCF00FFFF7F7F
              7F000000C0CFCFC0CFCFC0CFCFC0CFCF7F7F7FFFFFFF00FFFFC0CFCF00FFFFC0
              CFCF00FFFFC0CFCF00FFFFC0CFCF7F7F7F000000C0CFCFC0CFCFC0CFCFC0CFCF
              7F7F7FFFFFFFC0CFCF00FFFFC0CFCF00FFFFC0CFCF00FFFFC0CFCF00FFFF7F7F
              7F000000C0CFCFC0CFCFC0CFCFC0CFCF7F7F7FFFFFFF00FFFFC0CFCF00FFFFC0
              CFCF00FFFFC0CFCF00FFFFC0CFCF7F7F7F000000C0CFCFC0CFCFC0CFCFC0CFCF
              7F7F7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF7F7F
              7F000000C0CFCFC0CFCFC0CFCFC0CFCF7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F
              7F7F7F7F7F7F7F7F7F7F7F7F7F7F000000C0CFCFC0CFCFC0CFCFC0CFCFC0CFCF
              7F7F7F00FFFFFFFFFF00FFFFFFFFFF7F7F7FC0CFCFC0CFCFC0CFCFC0CFCFC0CF
              CFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCF7F7F7F7F7F7F7F7F7F7F7F7FC0
              CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCF
              C0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CF
              CFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0
              CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCF
              C0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CF
              CFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0
              CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCF}
            Margin = 0
          end
        end
        object t_cdcobsolete: TTabSheet
          Caption = 't_cdcobsolete'
          ImageIndex = 3
          TabVisible = False
          object Label88: TLabel
            Left = 0
            Top = 0
            Width = 234
            Height = 13
            Caption = 'CDC Obsolete Catalog (but you can still use them)'
          end
          object Label67: TLabel
            Left = 72
            Top = 39
            Width = 14
            Height = 13
            Caption = 'pm'
          end
          object Label91: TLabel
            Left = 116
            Top = 58
            Width = 102
            Height = 13
            Caption = 'Replaced by Tycho-2'
          end
          object Label92: TLabel
            Left = 116
            Top = 108
            Width = 102
            Height = 13
            Caption = 'Replaced by Tycho-2'
          end
          object Label93: TLabel
            Left = 116
            Top = 162
            Width = 114
            Height = 26
            Caption = 'CDC format, prefere the compact version'
            WordWrap = True
          end
          object Label94: TLabel
            Left = 116
            Top = 226
            Width = 62
            Height = 13
            Caption = 'Not available'
          end
          object Label90: TLabel
            Left = 8
            Top = 39
            Width = 24
            Height = 13
            Caption = 'Stars'
          end
          object TYCbox: TCheckBox
            Tag = 3
            Left = 96
            Top = 37
            Width = 137
            Height = 17
            Hint = 'The Tycho Catalogue (ESA 1997)'
            HelpContext = 102
            Caption = 'Tycho Catalog'
            ParentShowHint = False
            ShowHint = True
            TabOrder = 0
            OnClick = CDCStarSelClick
          end
          object Ftyc1: TLongEdit
            Tag = 3
            Left = 256
            Top = 34
            Width = 30
            Height = 22
            Hint = '0..10'
            ParentShowHint = False
            ShowHint = True
            TabOrder = 1
            OnChange = CDCStarField1Change
            Value = 0
            MaxValue = 10
          end
          object Ftyc2: TLongEdit
            Tag = 3
            Left = 296
            Top = 34
            Width = 30
            Height = 22
            Hint = '0..10'
            ParentShowHint = False
            ShowHint = True
            TabOrder = 2
            OnChange = CDCStarField2Change
            Value = 10
            MaxValue = 10
          end
          object tyc3: TEdit
            Tag = 3
            Left = 330
            Top = 36
            Width = 111
            Height = 19
            Ctl3D = False
            ParentCtl3D = False
            TabOrder = 3
            Text = 'tyc3'
            OnChange = CDCStarPathChange
          end
          object BitBtn11: TBitBtn
            Tag = 3
            Left = 439
            Top = 36
            Width = 19
            Height = 19
            TabOrder = 4
            TabStop = False
            OnClick = CDCStarSelPathClick
            Glyph.Data = {
              36030000424D3603000000000000360000002800000010000000100000000100
              1800000000000003000000000000000000000000000000000000C0CFCFC0CFCF
              C0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CF
              CFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0
              CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCF
              0000000000000000000000000000000000000000000000000000000000000000
              00C0CFCFC0CFCFC0CFCFC0CFCFC0CFCF7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F
              7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F000000C0CFCFC0CFCFC0CFCFC0CFCF
              7F7F7FFFFFFFC0CFCF00FFFFC0CFCF00FFFFC0CFCF00FFFFC0CFCF00FFFF7F7F
              7F000000C0CFCFC0CFCFC0CFCFC0CFCF7F7F7FFFFFFF00FFFFC0CFCF00FFFFC0
              CFCF00FFFFC0CFCF00FFFFC0CFCF7F7F7F000000C0CFCFC0CFCFC0CFCFC0CFCF
              7F7F7FFFFFFFC0CFCF00FFFFC0CFCF00FFFFC0CFCF00FFFFC0CFCF00FFFF7F7F
              7F000000C0CFCFC0CFCFC0CFCFC0CFCF7F7F7FFFFFFF00FFFFC0CFCF00FFFFC0
              CFCF00FFFFC0CFCF00FFFFC0CFCF7F7F7F000000C0CFCFC0CFCFC0CFCFC0CFCF
              7F7F7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF7F7F
              7F000000C0CFCFC0CFCFC0CFCFC0CFCF7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F
              7F7F7F7F7F7F7F7F7F7F7F7F7F7F000000C0CFCFC0CFCFC0CFCFC0CFCFC0CFCF
              7F7F7F00FFFFFFFFFF00FFFFFFFFFF7F7F7FC0CFCFC0CFCFC0CFCFC0CFCFC0CF
              CFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCF7F7F7F7F7F7F7F7F7F7F7F7FC0
              CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCF
              C0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CF
              CFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0
              CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCF
              C0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CF
              CFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0
              CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCF}
            Margin = 0
          end
          object TICbox: TCheckBox
            Tag = 5
            Left = 96
            Top = 90
            Width = 137
            Height = 17
            Hint = 'Tycho Input Catalog  (Revised Version) (Egret+ 1992)'
            HelpContext = 103
            Caption = 'Tycho  Input Catalog'
            ParentShowHint = False
            ShowHint = True
            TabOrder = 5
            OnClick = CDCStarSelClick
          end
          object Ftic1: TLongEdit
            Tag = 5
            Left = 256
            Top = 87
            Width = 30
            Height = 22
            Hint = '0..10'
            ParentShowHint = False
            ShowHint = True
            TabOrder = 6
            OnChange = CDCStarField1Change
            Value = 0
            MaxValue = 10
          end
          object Ftic2: TLongEdit
            Tag = 5
            Left = 296
            Top = 87
            Width = 30
            Height = 22
            Hint = '0..10'
            ParentShowHint = False
            ShowHint = True
            TabOrder = 7
            OnChange = CDCStarField2Change
            Value = 7
            MaxValue = 10
          end
          object tic3: TEdit
            Tag = 5
            Left = 330
            Top = 89
            Width = 111
            Height = 19
            Ctl3D = False
            ParentCtl3D = False
            TabOrder = 8
            Text = 'tic3'
            OnChange = CDCStarPathChange
          end
          object BitBtn13: TBitBtn
            Tag = 5
            Left = 439
            Top = 89
            Width = 19
            Height = 19
            TabOrder = 9
            TabStop = False
            OnClick = CDCStarSelPathClick
            Glyph.Data = {
              36030000424D3603000000000000360000002800000010000000100000000100
              1800000000000003000000000000000000000000000000000000C0CFCFC0CFCF
              C0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CF
              CFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0
              CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCF
              0000000000000000000000000000000000000000000000000000000000000000
              00C0CFCFC0CFCFC0CFCFC0CFCFC0CFCF7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F
              7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F000000C0CFCFC0CFCFC0CFCFC0CFCF
              7F7F7FFFFFFFC0CFCF00FFFFC0CFCF00FFFFC0CFCF00FFFFC0CFCF00FFFF7F7F
              7F000000C0CFCFC0CFCFC0CFCFC0CFCF7F7F7FFFFFFF00FFFFC0CFCF00FFFFC0
              CFCF00FFFFC0CFCF00FFFFC0CFCF7F7F7F000000C0CFCFC0CFCFC0CFCFC0CFCF
              7F7F7FFFFFFFC0CFCF00FFFFC0CFCF00FFFFC0CFCF00FFFFC0CFCF00FFFF7F7F
              7F000000C0CFCFC0CFCFC0CFCFC0CFCF7F7F7FFFFFFF00FFFFC0CFCF00FFFFC0
              CFCF00FFFFC0CFCF00FFFFC0CFCF7F7F7F000000C0CFCFC0CFCFC0CFCFC0CFCF
              7F7F7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF7F7F
              7F000000C0CFCFC0CFCFC0CFCFC0CFCF7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F
              7F7F7F7F7F7F7F7F7F7F7F7F7F7F000000C0CFCFC0CFCFC0CFCFC0CFCFC0CFCF
              7F7F7F00FFFFFFFFFF00FFFFFFFFFF7F7F7FC0CFCFC0CFCFC0CFCFC0CFCFC0CF
              CFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCF7F7F7F7F7F7F7F7F7F7F7F7FC0
              CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCF
              C0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CF
              CFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0
              CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCF
              C0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CF
              CFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0
              CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCF}
            Margin = 0
          end
          object GSCbox: TCheckBox
            Tag = 8
            Left = 96
            Top = 144
            Width = 153
            Height = 17
            Hint = 'The Hubble Space Telescope Guide Star Catalog  ( Lasker 1990)'
            HelpContext = 104
            Caption = 'HST Guide Star Catalog'
            ParentShowHint = False
            ShowHint = True
            TabOrder = 10
            OnClick = CDCStarSelClick
          end
          object fgsc1: TLongEdit
            Tag = 8
            Left = 256
            Top = 141
            Width = 30
            Height = 22
            Hint = '0..10'
            ParentShowHint = False
            ShowHint = True
            TabOrder = 11
            OnChange = CDCStarField1Change
            Value = 0
            MaxValue = 10
          end
          object fgsc2: TLongEdit
            Tag = 8
            Left = 296
            Top = 141
            Width = 30
            Height = 22
            Hint = '0..10'
            ParentShowHint = False
            ShowHint = True
            TabOrder = 12
            OnChange = CDCStarField2Change
            Value = 2
            MaxValue = 10
          end
          object gsc3: TEdit
            Tag = 8
            Left = 330
            Top = 143
            Width = 111
            Height = 19
            Ctl3D = False
            ParentCtl3D = False
            TabOrder = 13
            Text = 'gsc3'
            OnChange = CDCStarPathChange
          end
          object BitBtn18: TBitBtn
            Tag = 8
            Left = 439
            Top = 143
            Width = 19
            Height = 19
            TabOrder = 14
            TabStop = False
            OnClick = CDCStarSelPathClick
            Glyph.Data = {
              36030000424D3603000000000000360000002800000010000000100000000100
              1800000000000003000000000000000000000000000000000000C0CFCFC0CFCF
              C0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CF
              CFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0
              CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCF
              0000000000000000000000000000000000000000000000000000000000000000
              00C0CFCFC0CFCFC0CFCFC0CFCFC0CFCF7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F
              7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F000000C0CFCFC0CFCFC0CFCFC0CFCF
              7F7F7FFFFFFFC0CFCF00FFFFC0CFCF00FFFFC0CFCF00FFFFC0CFCF00FFFF7F7F
              7F000000C0CFCFC0CFCFC0CFCFC0CFCF7F7F7FFFFFFF00FFFFC0CFCF00FFFFC0
              CFCF00FFFFC0CFCF00FFFFC0CFCF7F7F7F000000C0CFCFC0CFCFC0CFCFC0CFCF
              7F7F7FFFFFFFC0CFCF00FFFFC0CFCF00FFFFC0CFCF00FFFFC0CFCF00FFFF7F7F
              7F000000C0CFCFC0CFCFC0CFCFC0CFCF7F7F7FFFFFFF00FFFFC0CFCF00FFFFC0
              CFCF00FFFFC0CFCF00FFFFC0CFCF7F7F7F000000C0CFCFC0CFCFC0CFCFC0CFCF
              7F7F7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF7F7F
              7F000000C0CFCFC0CFCFC0CFCFC0CFCF7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F
              7F7F7F7F7F7F7F7F7F7F7F7F7F7F000000C0CFCFC0CFCFC0CFCFC0CFCFC0CFCF
              7F7F7F00FFFFFFFFFF00FFFFFFFFFF7F7F7FC0CFCFC0CFCFC0CFCFC0CFCFC0CF
              CFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCF7F7F7F7F7F7F7F7F7F7F7F7FC0
              CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCF
              C0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CF
              CFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0
              CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCF
              C0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CF
              CFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0
              CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCF}
            Margin = 0
          end
          object MCTBox: TCheckBox
            Tag = 10
            Left = 96
            Top = 207
            Width = 137
            Height = 17
            Hint = 'AUDE MicroCat CDROM'
            HelpContext = 113
            Caption = 'AUDE MicroCat'
            ParentShowHint = False
            ShowHint = True
            TabOrder = 15
            OnClick = CDCStarSelClick
          end
          object fmct1: TLongEdit
            Tag = 10
            Left = 256
            Top = 204
            Width = 30
            Height = 22
            Hint = '0..10'
            ParentShowHint = False
            ShowHint = True
            TabOrder = 16
            OnChange = CDCStarField1Change
            Value = 0
            MaxValue = 10
          end
          object fmct2: TLongEdit
            Tag = 10
            Left = 296
            Top = 204
            Width = 30
            Height = 22
            Hint = '0..10'
            ParentShowHint = False
            ShowHint = True
            TabOrder = 17
            OnChange = CDCStarField2Change
            Value = 2
            MaxValue = 10
          end
          object mct3: TEdit
            Tag = 10
            Left = 330
            Top = 206
            Width = 111
            Height = 19
            Ctl3D = False
            ParentCtl3D = False
            TabOrder = 18
            Text = 'x:\'
            OnChange = CDCStarPathChange
          end
          object BitBtn32: TBitBtn
            Tag = 10
            Left = 439
            Top = 206
            Width = 19
            Height = 19
            TabOrder = 19
            TabStop = False
            OnClick = CDCStarSelPathClick
            Glyph.Data = {
              36030000424D3603000000000000360000002800000010000000100000000100
              1800000000000003000000000000000000000000000000000000C0CFCFC0CFCF
              C0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CF
              CFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0
              CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCF
              0000000000000000000000000000000000000000000000000000000000000000
              00C0CFCFC0CFCFC0CFCFC0CFCFC0CFCF7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F
              7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F000000C0CFCFC0CFCFC0CFCFC0CFCF
              7F7F7FFFFFFFC0CFCF00FFFFC0CFCF00FFFFC0CFCF00FFFFC0CFCF00FFFF7F7F
              7F000000C0CFCFC0CFCFC0CFCFC0CFCF7F7F7FFFFFFF00FFFFC0CFCF00FFFFC0
              CFCF00FFFFC0CFCF00FFFFC0CFCF7F7F7F000000C0CFCFC0CFCFC0CFCFC0CFCF
              7F7F7FFFFFFFC0CFCF00FFFFC0CFCF00FFFFC0CFCF00FFFFC0CFCF00FFFF7F7F
              7F000000C0CFCFC0CFCFC0CFCFC0CFCF7F7F7FFFFFFF00FFFFC0CFCF00FFFFC0
              CFCF00FFFFC0CFCF00FFFFC0CFCF7F7F7F000000C0CFCFC0CFCFC0CFCFC0CFCF
              7F7F7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF7F7F
              7F000000C0CFCFC0CFCFC0CFCFC0CFCF7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F
              7F7F7F7F7F7F7F7F7F7F7F7F7F7F000000C0CFCFC0CFCFC0CFCFC0CFCFC0CFCF
              7F7F7F00FFFFFFFFFF00FFFFFFFFFF7F7F7FC0CFCFC0CFCFC0CFCFC0CFCFC0CF
              CFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCF7F7F7F7F7F7F7F7F7F7F7F7FC0
              CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCF
              C0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CF
              CFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0
              CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCF
              C0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CF
              CFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0
              CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCF}
            Margin = 0
          end
        end
        object t_cdcexternal: TTabSheet
          Caption = 't_cdcexternal'
          ImageIndex = 4
          TabVisible = False
          object Label4: TLabel
            Left = 0
            Top = 0
            Width = 113
            Height = 13
            Caption = 'External Catalog Setting'
          end
          object Label52: TLabel
            Left = 0
            Top = 20
            Width = 130
            Height = 13
            Caption = 'According to the magnitude'
            Visible = False
          end
          object Label71: TLabel
            Left = 320
            Top = 32
            Width = 88
            Height = 13
            Alignment = taRightJustify
            Caption = 'Highest magnitude'
            Visible = False
          end
          object Label64: TLabel
            Left = 0
            Top = 220
            Width = 99
            Height = 13
            Caption = 'According to the size'
            Visible = False
          end
          object StringGrid1: TStringGrid
            Left = 0
            Top = 56
            Width = 466
            Height = 153
            ColCount = 20
            DefaultColWidth = 40
            DefaultRowHeight = 18
            FixedCols = 0
            RowCount = 20
            Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goDrawFocusSelected, goEditing, goTabs]
            TabOrder = 0
            Visible = False
            ColWidths = (
              30
              43
              107
              40
              40
              40
              40
              40
              40
              40
              40
              40
              40
              40
              40
              40
              40
              40
              40
              40)
          end
          object Cat1Box: TCheckBox
            Left = 0
            Top = 38
            Width = 273
            Height = 17
            HelpContext = 107
            Caption = 'Show this catalogs'
            ParentShowHint = False
            ShowHint = False
            TabOrder = 1
            Visible = False
          end
          object Edit1: TEdit
            Left = 417
            Top = 28
            Width = 41
            Height = 21
            Color = clBtnFace
            ReadOnly = True
            TabOrder = 2
            Visible = False
          end
          object Cat2Box: TCheckBox
            Left = 0
            Top = 238
            Width = 329
            Height = 17
            HelpContext = 107
            Caption = 'Show this catalogs'
            ParentShowHint = False
            ShowHint = False
            TabOrder = 3
            Visible = False
          end
          object StringGrid2: TStringGrid
            Left = 0
            Top = 256
            Width = 465
            Height = 153
            ColCount = 22
            DefaultColWidth = 40
            DefaultRowHeight = 18
            FixedCols = 0
            RowCount = 20
            Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goDrawFocusSelected, goEditing, goTabs]
            TabOrder = 4
            Visible = False
            ColWidths = (
              30
              43
              107
              40
              40
              40
              40
              40
              40
              40
              40
              40
              40
              40
              40
              40
              40
              40
              40
              40
              40
              40)
          end
        end
      end
    end
    object s_solsys: TTabSheet
      Caption = 's_solsys'
      ImageIndex = 4
      TabVisible = False
      object pa_solsys: TPageControl
        Left = 0
        Top = 0
        Width = 482
        Height = 445
        ActivePage = t_planet
        Align = alClient
        TabOrder = 0
        object t_solsys: TTabSheet
          Caption = 't_solsys'
          TabVisible = False
          object Label12: TLabel
            Left = 0
            Top = 0
            Width = 97
            Height = 13
            Caption = 'Solar System Setting'
          end
          object Label131: TLabel
            Left = 40
            Top = 64
            Width = 53
            Height = 13
            Caption = 'Data Files :'
          end
          object PlaParalaxe: TRadioGroup
            Left = 40
            Top = 120
            Width = 329
            Height = 81
            Caption = 'Position'
            Columns = 2
            Items.Strings = (
              'Geocentric'
              'TopoCentric')
            TabOrder = 0
            OnClick = PlaParalaxeClick
          end
          object planetdir: TEdit
            Left = 104
            Top = 59
            Width = 225
            Height = 21
            TabOrder = 1
            Text = '~/'
            OnChange = planetdirChange
          end
          object planetdirsel: TBitBtn
            Left = 336
            Top = 56
            Width = 26
            Height = 26
            TabOrder = 2
            TabStop = False
            OnClick = planetdirselClick
            Glyph.Data = {
              36030000424D3603000000000000360000002800000010000000100000000100
              1800000000000003000000000000000000000000000000000000C0CFCFC0CFCF
              C0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CF
              CFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0
              CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCF
              0000000000000000000000000000000000000000000000000000000000000000
              00C0CFCFC0CFCFC0CFCFC0CFCFC0CFCF7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F
              7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F000000C0CFCFC0CFCFC0CFCFC0CFCF
              7F7F7FFFFFFFC0CFCF00FFFFC0CFCF00FFFFC0CFCF00FFFFC0CFCF00FFFF7F7F
              7F000000C0CFCFC0CFCFC0CFCFC0CFCF7F7F7FFFFFFF00FFFFC0CFCF00FFFFC0
              CFCF00FFFFC0CFCF00FFFFC0CFCF7F7F7F000000C0CFCFC0CFCFC0CFCFC0CFCF
              7F7F7FFFFFFFC0CFCF00FFFFC0CFCF00FFFFC0CFCF00FFFFC0CFCF00FFFF7F7F
              7F000000C0CFCFC0CFCFC0CFCFC0CFCF7F7F7FFFFFFF00FFFFC0CFCF00FFFFC0
              CFCF00FFFFC0CFCF00FFFFC0CFCF7F7F7F000000C0CFCFC0CFCFC0CFCFC0CFCF
              7F7F7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF7F7F
              7F000000C0CFCFC0CFCFC0CFCFC0CFCF7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F
              7F7F7F7F7F7F7F7F7F7F7F7F7F7F000000C0CFCFC0CFCFC0CFCFC0CFCFC0CFCF
              7F7F7F00FFFFFFFFFF00FFFFFFFFFF7F7F7FC0CFCFC0CFCFC0CFCFC0CFCFC0CF
              CFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCF7F7F7F7F7F7F7F7F7F7F7F7FC0
              CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCF
              C0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CF
              CFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0
              CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCF
              C0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CF
              CFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0
              CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCF}
            Layout = blGlyphTop
            Margin = 0
          end
        end
        object t_planet: TTabSheet
          Caption = 't_planet'
          ImageIndex = 1
          TabVisible = False
          object Label5: TLabel
            Left = 0
            Top = 0
            Width = 71
            Height = 13
            Caption = 'Planets Setting'
          end
          object Label89: TLabel
            Left = 40
            Top = 282
            Width = 109
            Height = 13
            Caption = 'Jupiter GRS longitude :'
          end
          object Label53: TLabel
            Left = 40
            Top = 88
            Width = 100
            Height = 13
            Caption = 'Computation Plugin : '
          end
          object PlanetBox: TCheckBox
            Left = 40
            Top = 54
            Width = 209
            Height = 17
            Hint = 'Planetary Ephemerides     (Chapront+ 1996)'
            HelpContext = 107
            Caption = 'Show Planet on the Chart'
            Checked = True
            ParentShowHint = False
            ShowHint = True
            State = cbChecked
            TabOrder = 0
            OnClick = PlanetBoxClick
          end
          object PlanetMode: TRadioGroup
            Left = 40
            Top = 120
            Width = 329
            Height = 137
            Caption = 'Draw Planet As'
            Items.Strings = (
              'Star'
              'Line mode drawing'
              'Realistics image'
              'Symbol')
            TabOrder = 1
            OnClick = PlanetModeClick
          end
          object PlanetBox2: TCheckBox
            Left = 40
            Top = 312
            Width = 321
            Height = 17
            Caption = 'Show stars behind the planets'
            TabOrder = 2
            OnClick = PlanetBox2Click
          end
          object PlanetBox3: TCheckBox
            Left = 40
            Top = 336
            Width = 321
            Height = 17
            Caption = 'Show Earth Shadow  (Lunar eclipses)'
            TabOrder = 3
            OnClick = PlanetBox3Click
          end
          object GRS: TFloatEdit
            Left = 152
            Top = 277
            Width = 41
            Height = 22
            Hint = '0..360'
            ParentShowHint = False
            ShowHint = True
            TabOrder = 4
            OnChange = GRSChange
            Value = 80
            MaxValue = 360
          end
          object BitBtn37: TBitBtn
            Left = 199
            Top = 276
            Width = 27
            Height = 25
            Hint = 'Get recent measurement from JUPOS'
            ParentShowHint = False
            ShowHint = True
            TabOrder = 5
            Glyph.Data = {
              F6060000424DF606000000000000360000002800000018000000180000000100
              180000000000C006000000000000000000000000000000000000808000808000
              8080008080008080008080008080008080008080008080008080008080008080
              0080800080800080800080800080800080800080800080800080800080800080
              8000808000840000840000840000840000840000840000840000840000840000
              8400008400008400008400008400008400008400008400008400008400008400
              0084000084000080800080800084000084000084000084000084000084000084
              0101860A0A8A1A1A8B29298E39398F3A398C2828891919860908840000840000
              8400008400008400008400008400008080008080008400008400008400008400
              00840000860D0D8F3939946765927D798B807B89827D8A837E8D817C947D7A95
              62608F3030860909840000840000840000840000840000808000808000840000
              8400008400008401018C23239365638C827D86857D84847B84847B84847B8484
              7B84847B84847B87867E90827D955F5E8A1C1C84000084000084000084000080
              80008080008400008400008401018D27279D7E7C9A989296968F96968F96968F
              96968F96968F96968F96968F96968F96968F97968F9D9994A077768B1D1D8400
              008400008400008080008080008400008400008919199D7B7BB1B0AFB9B9B8BA
              BAB8BABAB8BABAB8BABAB8BABAB8BABAB8BABAB8BABAB8BABAB8BABAB8B9B9B8
              B1AEAD9C72728915158400008400008080008080008400008507079355557E7A
              7776767374747274747277777378787478787478787478787478787478787478
              7874787874787874767672807A78934D4D850404840000808000808000840000
              8A2323968382A0A09E9C9C9C7272867070849A9A9BA1A19FA1A19FA1A19FA1A1
              9FA1A19FA2A2A0A3A3A1A4A4A3A8A8A7AFAFAEA2A2A09B83828B1C1C84000080
              8000808000840202873B3B47433E31312A2F2F2A2121222121222F2F2931312B
              32322B32322B32312B3B3A3464645F70706D61615D6B6B676565603838325A52
              4E8D35348400008080008080008506068A575655544F48484249494349494349
              494349494349494349494348484247464067605AB3B0AFA3A2A1585651464139
              47453F474741605E5A935555850303808000808000870C0CA37E7EBBBBBBBFBF
              BFC0C0BFC0C0BFC0C0BFC0C0BFC0C0BFC0C0BFBFBFBFBEBDBCB9B0ACB8AEAABE
              BEBEBBBAB9AEA4A0A7A19DB6B6B5B8B7B79D6666850505808000808000860B0B
              A07979ADADACAFAFAEAFAFAEAFAFAEAFAFAEB1B1B0B3B3B3B4B4B3B4B4B3B4B4
              B3B3B3B2B2B1B0B2B2B1B3B3B2B3B3B2B1B1B0B3B3B2B0AFAE9C656585050580
              8000808000850505864C4C43423C32322B32322B32322B37373451526E5A5D99
              7375968081827B7B777B7B777B7B777B7B777B7B777B7B777B7B777B7B778583
              819759588403038080008080008401018A383859534F45454046464147474156
              57674045C32E35D9434AD371729060605C5F5F5A5F5F5A5F5F5A5F5F5A5F5F5A
              5F5F5A5E5E5A7A6F6D8F31318400008080008080008400008919199E8282B4B4
              B3B8B8B7B8B8B8B1B2BE6F74CE4E53D16267CEABACC0B8B8B8B9B9B8BCBCBCBA
              BAB9B8B8B8B8B8B8B8B8B7B3B2B2A18080891414840000808000808000840000
              840404944A4A8A83817B7B787C7C787B7B787474786E6E777273787B7B797D7D
              79878784B6B6B59292907B7B787C7C797B7B7891858494404084020284000080
              8000808000840000840000870F0F8E55559E97969C9C9A8E8E8B90908D787874
              A2A2A0ACACAAACACABAFAFAEBCBCBBA4A4A2898985A8A8A69E97969150508609
              09840000840000808000808000840000840000840000871010986161958D8A86
              857F85857D74746D90908995958F95958F95958E95958E8E8E8886857F9E9390
              9B5D5D8810108400008400008400008080008080008400008400008400008400
              00870F0F914948917A7789857E85847C83837B84847B84847B84847B86857D8C
              8781947976914342860A0A840000840000840000840000808000808000840000
              8400008400008400008400008404048B2121924B4A9165648D74718A76728B77
              739077749364629349488A1A1A84030384000084000084000084000084000080
              8000808000840000840000840000840000840000840000840000840202860909
              8715158718188818188815158508088402028400008400008400008400008400
              0084000084000080800080800084000084000084000084000084000084000084
              0000840000840000840000840000840000840000840000840000840000840000
              8400008400008400008400008400008080008080008080008080008080008080
              0080800080800080800080800080800080800080800080800080800080800080
              8000808000808000808000808000808000808000808000808000}
          end
          object Edit2: TEdit
            Left = 152
            Top = 84
            Width = 100
            Height = 21
            TabOrder = 6
          end
        end
        object t_comet: TTabSheet
          Caption = 't_comet'
          ImageIndex = 2
          TabVisible = False
          object ComPageControl: TPageControl
            Left = 0
            Top = 4
            Width = 465
            Height = 420
            ActivePage = comsetting
            TabIndex = 0
            TabOrder = 0
            object comsetting: TTabSheet
              Caption = 'General Setting'
              ImageIndex = 3
              object GroupBox13: TGroupBox
                Left = 8
                Top = 10
                Width = 441
                Height = 175
                Caption = 'Chart Setting'
                TabOrder = 0
                object Label154: TLabel
                  Left = 32
                  Top = 112
                  Width = 250
                  Height = 13
                  Caption = 'Do not take account of comet fainter than magnitude'
                end
                object Label216: TLabel
                  Left = 32
                  Top = 144
                  Width = 59
                  Height = 13
                  Caption = 'Show comet'
                end
                object Label231: TLabel
                  Left = 160
                  Top = 144
                  Width = 151
                  Height = 13
                  Caption = 'magnitude fainter than the stars.'
                end
                object comlimitmag: TFloatEdit
                  Left = 320
                  Top = 107
                  Width = 41
                  Height = 22
                  Hint = '0..99'
                  ParentShowHint = False
                  ShowHint = True
                  TabOrder = 0
                  OnChange = comlimitmagChange
                  MaxValue = 99
                end
                object showcom: TCheckBox
                  Left = 32
                  Top = 24
                  Width = 241
                  Height = 30
                  Caption = 'Show comets on the chart'
                  TabOrder = 1
                  OnClick = showcomClick
                end
                object comsymbol: TRadioGroup
                  Left = 24
                  Top = 56
                  Width = 393
                  Height = 41
                  Color = clBtnFace
                  Columns = 2
                  ItemIndex = 1
                  Items.Strings = (
                    'Display as a symbol'
                    'Proportional to the magnitude ')
                  ParentColor = False
                  TabOrder = 3
                  OnClick = comsymbolClick
                end
                object commagdiff: TFloatEdit
                  Left = 112
                  Top = 139
                  Width = 41
                  Height = 22
                  Hint = '0..99'
                  ParentShowHint = False
                  ShowHint = True
                  TabOrder = 2
                  OnChange = commagdiffChange
                  MaxValue = 99
                end
              end
              object comdbset: TButton
                Left = 8
                Top = 232
                Width = 113
                Height = 25
                Caption = 'Database setting...'
                TabOrder = 1
                OnClick = astdbsetClick
              end
            end
            object comload: TTabSheet
              Caption = 'Load MPC File'
              ImageIndex = 1
              object Label232: TLabel
                Left = 8
                Top = 112
                Width = 51
                Height = 13
                Caption = 'Messages:'
              end
              object GroupBox14: TGroupBox
                Left = 8
                Top = 10
                Width = 441
                Height = 87
                Caption = 'Load MPC format file'
                TabOrder = 0
                object Label233: TLabel
                  Left = 8
                  Top = 32
                  Width = 22
                  Height = 13
                  Caption = 'File :'
                end
                object comfile: TEdit
                  Left = 32
                  Top = 28
                  Width = 241
                  Height = 21
                  TabOrder = 0
                  Text = 'COMET.DAT'
                end
                object Loadcom: TButton
                  Left = 328
                  Top = 26
                  Width = 97
                  Height = 25
                  Caption = 'Load file'
                  TabOrder = 1
                  OnClick = LoadcomClick
                end
                object comfilebtn: TBitBtn
                  Tag = 8
                  Left = 275
                  Top = 25
                  Width = 26
                  Height = 26
                  TabOrder = 2
                  TabStop = False
                  OnClick = comfilebtnClick
                  Glyph.Data = {
                    36030000424D3603000000000000360000002800000010000000100000000100
                    1800000000000003000000000000000000000000000000000000C0CFCFC0CFCF
                    C0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CF
                    CFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0
                    CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCF
                    0000000000000000000000000000000000000000000000000000000000000000
                    00C0CFCFC0CFCFC0CFCFC0CFCFC0CFCF7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F
                    7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F000000C0CFCFC0CFCFC0CFCFC0CFCF
                    7F7F7FFFFFFFC0CFCF00FFFFC0CFCF00FFFFC0CFCF00FFFFC0CFCF00FFFF7F7F
                    7F000000C0CFCFC0CFCFC0CFCFC0CFCF7F7F7FFFFFFF00FFFFC0CFCF00FFFFC0
                    CFCF00FFFFC0CFCF00FFFFC0CFCF7F7F7F000000C0CFCFC0CFCFC0CFCFC0CFCF
                    7F7F7FFFFFFFC0CFCF00FFFFC0CFCF00FFFFC0CFCF00FFFFC0CFCF00FFFF7F7F
                    7F000000C0CFCFC0CFCFC0CFCFC0CFCF7F7F7FFFFFFF00FFFFC0CFCF00FFFFC0
                    CFCF00FFFFC0CFCF00FFFFC0CFCF7F7F7F000000C0CFCFC0CFCFC0CFCFC0CFCF
                    7F7F7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF7F7F
                    7F000000C0CFCFC0CFCFC0CFCFC0CFCF7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F
                    7F7F7F7F7F7F7F7F7F7F7F7F7F7F000000C0CFCFC0CFCFC0CFCFC0CFCFC0CFCF
                    7F7F7F00FFFFFFFFFF00FFFFFFFFFF7F7F7FC0CFCFC0CFCFC0CFCFC0CFCFC0CF
                    CFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCF7F7F7F7F7F7F7F7F7F7F7F7FC0
                    CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCF
                    C0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CF
                    CFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0
                    CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCF
                    C0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CF
                    CFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0
                    CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCF}
                  Layout = blGlyphTop
                  Margin = 0
                end
              end
              object MemoCom: TMemo
                Left = 8
                Top = 128
                Width = 441
                Height = 257
                Color = clBtnFace
                ScrollBars = ssBoth
                TabOrder = 1
              end
            end
            object comdelete: TTabSheet
              Caption = 'Data Maintenance'
              ImageIndex = 3
              object Label238: TLabel
                Left = 8
                Top = 144
                Width = 51
                Height = 13
                Caption = 'Messages:'
              end
              object GroupBox16: TGroupBox
                Left = 8
                Top = 10
                Width = 441
                Height = 60
                Caption = 'Delete MPC data selectively'
                TabOrder = 0
                object comelemlist: TComboBox
                  Left = 16
                  Top = 24
                  Width = 281
                  Height = 21
                  Style = csDropDownList
                  ItemHeight = 13
                  TabOrder = 0
                end
                object DelCom: TButton
                  Left = 328
                  Top = 24
                  Width = 75
                  Height = 25
                  Caption = 'Delete'
                  TabOrder = 1
                  OnClick = DelComClick
                end
              end
              object GroupBox17: TGroupBox
                Left = 8
                Top = 80
                Width = 441
                Height = 49
                Caption = 'Quick Delete'
                TabOrder = 1
                object Label239: TLabel
                  Left = 24
                  Top = 19
                  Width = 171
                  Height = 13
                  Caption = 'Quickly delete all comet related data'
                end
                object DelComAll: TButton
                  Left = 328
                  Top = 16
                  Width = 75
                  Height = 25
                  Caption = 'Delete'
                  TabOrder = 0
                  OnClick = DelComAllClick
                end
              end
              object DelComMemo: TMemo
                Left = 8
                Top = 168
                Width = 441
                Height = 217
                Color = clBtnFace
                ScrollBars = ssBoth
                TabOrder = 2
              end
            end
            object Addsinglecom: TTabSheet
              Caption = 'Add'
              ImageIndex = 4
              object Label241: TLabel
                Left = 8
                Top = 8
                Width = 287
                Height = 13
                Caption = 'Add a single element to the database. All field are mandatory.'
              end
              object Label242: TLabel
                Left = 8
                Top = 40
                Width = 56
                Height = 13
                Caption = 'Designation'
              end
              object Label243: TLabel
                Left = 8
                Top = 232
                Width = 103
                Height = 13
                Caption = 'H absolute magnitude'
              end
              object Label244: TLabel
                Left = 160
                Top = 232
                Width = 86
                Height = 13
                Caption = 'G slope parameter'
              end
              object Label245: TLabel
                Left = 160
                Top = 168
                Width = 53
                Height = 13
                Caption = 'Epoch (JD)'
              end
              object Label246: TLabel
                Left = 160
                Top = 40
                Width = 70
                Height = 13
                Caption = 'Perihelion date'
              end
              object Label247: TLabel
                Left = 160
                Top = 104
                Width = 105
                Height = 13
                Caption = 'Argument of perihelion'
              end
              object Label248: TLabel
                Left = 312
                Top = 104
                Width = 128
                Height = 13
                Caption = 'Longitude ascending Node'
              end
              object Label249: TLabel
                Left = 8
                Top = 168
                Width = 48
                Height = 13
                Caption = 'Inclination'
              end
              object Label250: TLabel
                Left = 8
                Top = 104
                Width = 55
                Height = 13
                Caption = 'Eccentricity'
              end
              object Label251: TLabel
                Left = 312
                Top = 40
                Width = 89
                Height = 13
                Caption = 'Perihelion distance'
              end
              object Label253: TLabel
                Left = 312
                Top = 168
                Width = 38
                Height = 13
                Caption = 'Equinox'
              end
              object Label254: TLabel
                Left = 8
                Top = 296
                Width = 28
                Height = 13
                Caption = 'Name'
              end
              object comid: TEdit
                Left = 8
                Top = 64
                Width = 100
                Height = 21
                TabOrder = 0
              end
              object comh: TEdit
                Left = 8
                Top = 256
                Width = 100
                Height = 21
                TabOrder = 1
                Text = '5'
              end
              object comg: TEdit
                Left = 160
                Top = 256
                Width = 100
                Height = 21
                TabOrder = 2
                Text = '10'
              end
              object comep: TEdit
                Left = 160
                Top = 192
                Width = 100
                Height = 21
                TabOrder = 3
              end
              object comperi: TEdit
                Left = 160
                Top = 128
                Width = 100
                Height = 21
                TabOrder = 4
                Text = '0.0'
              end
              object comnode: TEdit
                Left = 312
                Top = 128
                Width = 100
                Height = 21
                TabOrder = 5
                Text = '0.0'
              end
              object comi: TEdit
                Left = 8
                Top = 192
                Width = 100
                Height = 21
                TabOrder = 6
                Text = '0.0'
              end
              object comec: TEdit
                Left = 8
                Top = 128
                Width = 100
                Height = 21
                TabOrder = 7
                Text = '0.0'
              end
              object comq: TEdit
                Left = 312
                Top = 64
                Width = 100
                Height = 21
                TabOrder = 8
                Text = '2'
              end
              object comnam: TEdit
                Left = 8
                Top = 320
                Width = 257
                Height = 21
                TabOrder = 9
              end
              object comeq: TEdit
                Left = 312
                Top = 192
                Width = 100
                Height = 21
                TabOrder = 10
                Text = '2000'
              end
              object AddCom: TButton
                Left = 312
                Top = 320
                Width = 75
                Height = 25
                Caption = 'Add'
                TabOrder = 11
                OnClick = AddComClick
              end
              object comt: TMaskEdit
                Left = 160
                Top = 64
                Width = 91
                Height = 21
                EditMask = '!9999.99.00.0000;1;_'
                MaxLength = 15
                TabOrder = 12
                Text = '    .  .  .    '
              end
            end
          end
        end
        object t_asteroid: TTabSheet
          Caption = 't_asteroid'
          ImageIndex = 3
          TabVisible = False
          object AstPageControl: TPageControl
            Left = 0
            Top = 4
            Width = 465
            Height = 420
            ActivePage = astsetting
            TabIndex = 0
            TabOrder = 0
            object astsetting: TTabSheet
              Caption = 'General Setting'
              ImageIndex = 3
              object GroupBox9: TGroupBox
                Left = 8
                Top = 10
                Width = 441
                Height = 175
                Caption = 'Chart Setting'
                TabOrder = 0
                object Label203: TLabel
                  Left = 32
                  Top = 112
                  Width = 258
                  Height = 13
                  Caption = 'Do not take account of asteroid fainter than magnitude'
                end
                object Label212: TLabel
                  Left = 32
                  Top = 144
                  Width = 67
                  Height = 13
                  Caption = 'Show asteroid'
                end
                object Label213: TLabel
                  Left = 160
                  Top = 144
                  Width = 151
                  Height = 13
                  Caption = 'magnitude fainter than the stars.'
                end
                object astlimitmag: TFloatEdit
                  Left = 320
                  Top = 107
                  Width = 41
                  Height = 22
                  Hint = '0..99'
                  ParentShowHint = False
                  ShowHint = True
                  TabOrder = 0
                  OnChange = astlimitmagChange
                  MaxValue = 99
                end
                object showast: TCheckBox
                  Left = 32
                  Top = 24
                  Width = 241
                  Height = 30
                  Caption = 'Show asteroids on the chart'
                  TabOrder = 1
                  OnClick = showastClick
                end
                object astsymbol: TRadioGroup
                  Left = 24
                  Top = 56
                  Width = 393
                  Height = 41
                  Color = clBtnFace
                  Columns = 2
                  ItemIndex = 1
                  Items.Strings = (
                    'Display as a symbol'
                    'Proportional to the magnitude ')
                  ParentColor = False
                  TabOrder = 3
                  OnClick = astsymbolClick
                end
                object astmagdiff: TFloatEdit
                  Left = 112
                  Top = 139
                  Width = 41
                  Height = 22
                  Hint = '0..99'
                  ParentShowHint = False
                  ShowHint = True
                  TabOrder = 2
                  OnChange = astmagdiffChange
                  MaxValue = 99
                end
              end
              object astdbset: TButton
                Left = 8
                Top = 232
                Width = 113
                Height = 25
                Caption = 'Database setting...'
                TabOrder = 1
                OnClick = astdbsetClick
              end
            end
            object astload: TTabSheet
              Caption = 'Load MPC File'
              ImageIndex = 1
              object Label206: TLabel
                Left = 8
                Top = 144
                Width = 51
                Height = 13
                Caption = 'Messages:'
              end
              object GroupBox7: TGroupBox
                Left = 8
                Top = 10
                Width = 441
                Height = 127
                Caption = 'Load MPC format file'
                TabOrder = 0
                object Label204: TLabel
                  Left = 8
                  Top = 32
                  Width = 22
                  Height = 13
                  Caption = 'File :'
                end
                object Label215: TLabel
                  Left = 208
                  Top = 101
                  Width = 100
                  Height = 13
                  Caption = 'Asteroids from the file'
                end
                object mpcfile: TEdit
                  Left = 32
                  Top = 28
                  Width = 241
                  Height = 21
                  TabOrder = 0
                  Text = 'MPCORBcr.DAT'
                end
                object astnumbered: TCheckBox
                  Left = 30
                  Top = 56
                  Width = 157
                  Height = 30
                  Caption = 'Only numbered asteroids'
                  Checked = True
                  State = cbChecked
                  TabOrder = 1
                end
                object LoadMPC: TButton
                  Left = 328
                  Top = 26
                  Width = 97
                  Height = 25
                  Caption = 'Load file'
                  TabOrder = 2
                  OnClick = LoadMPCClick
                end
                object mpcfilebtn: TBitBtn
                  Tag = 8
                  Left = 275
                  Top = 25
                  Width = 26
                  Height = 26
                  TabOrder = 4
                  TabStop = False
                  OnClick = mpcfilebtnClick
                  Glyph.Data = {
                    36030000424D3603000000000000360000002800000010000000100000000100
                    1800000000000003000000000000000000000000000000000000C0CFCFC0CFCF
                    C0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CF
                    CFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0
                    CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCF
                    0000000000000000000000000000000000000000000000000000000000000000
                    00C0CFCFC0CFCFC0CFCFC0CFCFC0CFCF7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F
                    7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F000000C0CFCFC0CFCFC0CFCFC0CFCF
                    7F7F7FFFFFFFC0CFCF00FFFFC0CFCF00FFFFC0CFCF00FFFFC0CFCF00FFFF7F7F
                    7F000000C0CFCFC0CFCFC0CFCFC0CFCF7F7F7FFFFFFF00FFFFC0CFCF00FFFFC0
                    CFCF00FFFFC0CFCF00FFFFC0CFCF7F7F7F000000C0CFCFC0CFCFC0CFCFC0CFCF
                    7F7F7FFFFFFFC0CFCF00FFFFC0CFCF00FFFFC0CFCF00FFFFC0CFCF00FFFF7F7F
                    7F000000C0CFCFC0CFCFC0CFCFC0CFCF7F7F7FFFFFFF00FFFFC0CFCF00FFFFC0
                    CFCF00FFFFC0CFCF00FFFFC0CFCF7F7F7F000000C0CFCFC0CFCFC0CFCFC0CFCF
                    7F7F7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF7F7F
                    7F000000C0CFCFC0CFCFC0CFCFC0CFCF7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F
                    7F7F7F7F7F7F7F7F7F7F7F7F7F7F000000C0CFCFC0CFCFC0CFCFC0CFCFC0CFCF
                    7F7F7F00FFFFFFFFFF00FFFFFFFFFF7F7F7FC0CFCFC0CFCFC0CFCFC0CFCFC0CF
                    CFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCF7F7F7F7F7F7F7F7F7F7F7F7FC0
                    CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCF
                    C0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CF
                    CFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0
                    CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCF
                    C0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CF
                    CFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0
                    CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCF}
                  Layout = blGlyphTop
                  Margin = 0
                end
                object aststoperr: TCheckBox
                  Left = 196
                  Top = 56
                  Width = 157
                  Height = 30
                  Caption = 'Halt after 1000 errors'
                  Checked = True
                  State = cbChecked
                  TabOrder = 3
                end
                object astlimitbox: TCheckBox
                  Left = 30
                  Top = 92
                  Width = 117
                  Height = 30
                  Caption = 'Load only the first '
                  TabOrder = 5
                end
                object astlimit: TLongEdit
                  Left = 152
                  Top = 96
                  Width = 49
                  Height = 22
                  Hint = '0..999999'
                  ParentShowHint = False
                  ShowHint = True
                  TabOrder = 6
                  Value = 5000
                  MaxValue = 999999
                end
              end
              object MemoMPC: TMemo
                Left = 8
                Top = 160
                Width = 441
                Height = 225
                Color = clBtnFace
                ScrollBars = ssBoth
                TabOrder = 1
              end
            end
            object astprepare: TTabSheet
              Caption = 'Prepare Monthly Data'
              ImageIndex = 2
              object Label210: TLabel
                Left = 8
                Top = 104
                Width = 51
                Height = 13
                Caption = 'Messages:'
              end
              object GroupBox8: TGroupBox
                Left = 8
                Top = 10
                Width = 441
                Height = 79
                Caption = 'Prepare data '
                TabOrder = 0
                object Label7: TLabel
                  Left = 8
                  Top = 36
                  Width = 55
                  Height = 13
                  Caption = 'Start Month'
                end
                object Label207: TLabel
                  Left = 152
                  Top = 36
                  Width = 82
                  Height = 13
                  Caption = 'Number of Month'
                end
                object aststrtdate: TMaskEdit
                  Left = 72
                  Top = 32
                  Width = 62
                  Height = 21
                  EditMask = '!9999.99;1;_'
                  MaxLength = 7
                  TabOrder = 0
                  Text = '2003.11'
                end
                object AstCompute: TButton
                  Left = 344
                  Top = 32
                  Width = 75
                  Height = 25
                  Caption = 'Compute'
                  TabOrder = 1
                  OnClick = AstComputeClick
                end
                object astnummonth: TSpinEdit
                  Left = 240
                  Top = 32
                  Width = 49
                  Height = 22
                  MaxValue = 12
                  MinValue = 2
                  TabOrder = 2
                  Value = 2
                end
              end
              object prepastmemo: TMemo
                Left = 8
                Top = 128
                Width = 441
                Height = 249
                Color = clBtnFace
                ScrollBars = ssBoth
                TabOrder = 1
              end
            end
            object astdelete: TTabSheet
              Caption = 'Data Maintenance'
              ImageIndex = 3
              object Label211: TLabel
                Left = 8
                Top = 184
                Width = 51
                Height = 13
                Caption = 'Messages:'
              end
              object GroupBox10: TGroupBox
                Left = 8
                Top = 10
                Width = 441
                Height = 60
                Caption = 'Delete MPC data selectively'
                TabOrder = 0
                object astelemlist: TComboBox
                  Left = 16
                  Top = 24
                  Width = 281
                  Height = 21
                  Style = csDropDownList
                  ItemHeight = 13
                  TabOrder = 0
                end
                object delast: TButton
                  Left = 328
                  Top = 24
                  Width = 75
                  Height = 25
                  Caption = 'Delete'
                  TabOrder = 1
                  OnClick = delastClick
                end
              end
              object GroupBox11: TGroupBox
                Left = 8
                Top = 128
                Width = 441
                Height = 49
                Caption = 'Quick Delete'
                TabOrder = 1
                object Label209: TLabel
                  Left = 24
                  Top = 19
                  Width = 179
                  Height = 13
                  Caption = 'Quickly delete all asteroid related data'
                end
                object delallast: TButton
                  Left = 328
                  Top = 16
                  Width = 75
                  Height = 25
                  Caption = 'Delete'
                  TabOrder = 0
                  OnClick = delallastClick
                end
              end
              object delastMemo: TMemo
                Left = 8
                Top = 208
                Width = 441
                Height = 177
                Color = clBtnFace
                ScrollBars = ssBoth
                TabOrder = 3
              end
              object GroupBox12: TGroupBox
                Left = 8
                Top = 72
                Width = 441
                Height = 57
                Caption = 'Delete Monthly data '
                TabOrder = 2
                object Label214: TLabel
                  Left = 16
                  Top = 24
                  Width = 148
                  Height = 13
                  Caption = 'Delete Monthly data older than '
                end
                object astdeldate: TMaskEdit
                  Left = 232
                  Top = 20
                  Width = 62
                  Height = 21
                  EditMask = '!9999.99;1;_'
                  MaxLength = 7
                  TabOrder = 0
                  Text = '2002.11'
                end
                object deldateast: TButton
                  Left = 328
                  Top = 21
                  Width = 75
                  Height = 25
                  Caption = 'Delete'
                  TabOrder = 1
                  OnClick = deldateastClick
                end
              end
            end
            object AddsingleAst: TTabSheet
              Caption = 'Add'
              ImageIndex = 4
              object Label217: TLabel
                Left = 8
                Top = 8
                Width = 287
                Height = 13
                Caption = 'Add a single element to the database. All field are mandatory.'
              end
              object Label218: TLabel
                Left = 8
                Top = 40
                Width = 56
                Height = 13
                Caption = 'Designation'
              end
              object Label219: TLabel
                Left = 160
                Top = 40
                Width = 103
                Height = 13
                Caption = 'H absolute magnitude'
              end
              object Label220: TLabel
                Left = 312
                Top = 40
                Width = 86
                Height = 13
                Caption = 'G slope parameter'
              end
              object Label221: TLabel
                Left = 8
                Top = 104
                Width = 53
                Height = 13
                Caption = 'Epoch (JD)'
              end
              object Label222: TLabel
                Left = 160
                Top = 104
                Width = 69
                Height = 13
                Caption = 'Mean anomaly'
              end
              object Label223: TLabel
                Left = 312
                Top = 104
                Width = 105
                Height = 13
                Caption = 'Argument of perihelion'
              end
              object Label224: TLabel
                Left = 8
                Top = 168
                Width = 128
                Height = 13
                Caption = 'Longitude ascending Node'
              end
              object Label225: TLabel
                Left = 160
                Top = 168
                Width = 48
                Height = 13
                Caption = 'Inclination'
              end
              object Label226: TLabel
                Left = 312
                Top = 168
                Width = 55
                Height = 13
                Caption = 'Eccentricity'
              end
              object Label227: TLabel
                Left = 8
                Top = 232
                Width = 70
                Height = 13
                Caption = 'Semimajor Axis'
              end
              object Label228: TLabel
                Left = 160
                Top = 232
                Width = 50
                Height = 13
                Caption = 'Reference'
              end
              object Label229: TLabel
                Left = 312
                Top = 232
                Width = 38
                Height = 13
                Caption = 'Equinox'
              end
              object Label230: TLabel
                Left = 8
                Top = 296
                Width = 28
                Height = 13
                Caption = 'Name'
              end
              object astid: TEdit
                Left = 8
                Top = 64
                Width = 100
                Height = 26
                TabOrder = 0
              end
              object asth: TEdit
                Left = 160
                Top = 64
                Width = 100
                Height = 26
                TabOrder = 1
                Text = '16'
              end
              object astg: TEdit
                Left = 312
                Top = 64
                Width = 100
                Height = 26
                TabOrder = 2
                Text = '0.15'
              end
              object astep: TEdit
                Left = 8
                Top = 128
                Width = 100
                Height = 26
                TabOrder = 3
                Text = '2453006.5'
              end
              object astma: TEdit
                Left = 160
                Top = 128
                Width = 100
                Height = 26
                TabOrder = 4
                Text = '0.0'
              end
              object astperi: TEdit
                Left = 312
                Top = 128
                Width = 100
                Height = 26
                TabOrder = 5
                Text = '0.0'
              end
              object astnode: TEdit
                Left = 8
                Top = 192
                Width = 100
                Height = 26
                TabOrder = 6
                Text = '0.0'
              end
              object asti: TEdit
                Left = 160
                Top = 192
                Width = 100
                Height = 26
                TabOrder = 7
                Text = '0.0'
              end
              object astec: TEdit
                Left = 312
                Top = 192
                Width = 100
                Height = 26
                TabOrder = 8
                Text = '0.0'
              end
              object astax: TEdit
                Left = 8
                Top = 256
                Width = 100
                Height = 26
                TabOrder = 9
                Text = '2'
              end
              object astref: TEdit
                Left = 160
                Top = 256
                Width = 100
                Height = 26
                TabOrder = 10
              end
              object astnam: TEdit
                Left = 8
                Top = 320
                Width = 257
                Height = 26
                TabOrder = 11
              end
              object asteq: TEdit
                Left = 312
                Top = 256
                Width = 100
                Height = 26
                TabOrder = 12
                Text = '2000'
              end
              object Addast: TButton
                Left = 312
                Top = 320
                Width = 75
                Height = 25
                Caption = 'Add'
                TabOrder = 13
                OnClick = AddastClick
              end
            end
          end
        end
      end
    end
    object s_display: TTabSheet
      Caption = 's_display'
      ImageIndex = 5
      TabVisible = False
      object pa_display: TPageControl
        Left = 0
        Top = 0
        Width = 482
        Height = 445
        ActivePage = t_display
        Align = alClient
        TabOrder = 0
        object t_display: TTabSheet
          Caption = 't_display'
          TabVisible = False
          object Label14: TLabel
            Left = 0
            Top = 0
            Width = 70
            Height = 13
            Caption = 'Display Setting'
          end
          object stardisplay: TRadioGroup
            Left = 8
            Top = 120
            Width = 441
            Height = 65
            Caption = 'Star Display'
            Columns = 3
            Items.Strings = (
              'Line mode'
              'Photographic'
              'Parametric')
            TabOrder = 0
            OnClick = stardisplayClick
          end
          object nebuladisplay: TRadioGroup
            Left = 8
            Top = 32
            Width = 441
            Height = 65
            Caption = 'Nebula Display'
            Columns = 2
            Items.Strings = (
              'Line mode'
              'Graphic')
            TabOrder = 1
            OnClick = nebuladisplayClick
          end
          object starvisual: TGroupBox
            Left = 8
            Top = 192
            Width = 441
            Height = 233
            Caption = 'Star Display  Properties'
            TabOrder = 2
            Visible = False
            object Label256: TLabel
              Left = 24
              Top = 38
              Width = 76
              Height = 13
              Caption = 'Faint Stars Size '
            end
            object Label262: TLabel
              Left = 24
              Top = 112
              Width = 39
              Height = 13
              Caption = 'Contrast'
            end
            object Label263: TLabel
              Left = 24
              Top = 150
              Width = 73
              Height = 13
              Caption = 'Color saturation'
            end
            object Label257: TLabel
              Left = 24
              Top = 75
              Width = 119
              Height = 13
              Caption = 'Increment for Bright Stars'
            end
            object StarSizeBar: TTrackBar
              Left = 170
              Top = 32
              Width = 225
              Height = 25
              Max = 50
              Min = 1
              Orientation = trHorizontal
              PageSize = 5
              Frequency = 5
              Position = 1
              SelEnd = 0
              SelStart = 0
              TabOrder = 0
              TickMarks = tmBottomRight
              TickStyle = tsAuto
              OnChange = StarSizeBarChange
            end
            object StarContrastBar: TTrackBar
              Left = 170
              Top = 106
              Width = 225
              Height = 25
              Max = 1000
              Min = 100
              Orientation = trHorizontal
              PageSize = 100
              Frequency = 100
              Position = 100
              SelEnd = 0
              SelStart = 0
              TabOrder = 1
              TickMarks = tmBottomRight
              TickStyle = tsAuto
              OnChange = StarContrastBarChange
            end
            object SaturationBar: TTrackBar
              Left = 170
              Top = 144
              Width = 225
              Height = 25
              Max = 255
              Orientation = trHorizontal
              PageSize = 28
              Frequency = 28
              Position = 0
              SelEnd = 0
              SelStart = 0
              TabOrder = 2
              TickMarks = tmBottomRight
              TickStyle = tsAuto
              OnChange = SaturationBarChange
            end
            object SizeContrastBar: TTrackBar
              Left = 170
              Top = 69
              Width = 225
              Height = 25
              Max = 100
              Min = 10
              Orientation = trHorizontal
              PageSize = 10
              Frequency = 10
              Position = 10
              SelEnd = 0
              SelStart = 0
              TabOrder = 3
              TickMarks = tmBottomRight
              TickStyle = tsAuto
              OnChange = SizeContrastBarChange
            end
            object StarButton1: TButton
              Left = 16
              Top = 192
              Width = 95
              Height = 25
              Caption = 'Default'
              TabOrder = 4
              OnClick = StarButton1Click
            end
            object StarButton2: TButton
              Left = 120
              Top = 192
              Width = 95
              Height = 25
              Caption = 'Naked Eye'
              TabOrder = 5
              OnClick = StarButton2Click
            end
            object StarButton3: TButton
              Left = 224
              Top = 192
              Width = 95
              Height = 25
              Caption = 'High Color'
              TabOrder = 6
              OnClick = StarButton3Click
            end
            object StarButton4: TButton
              Left = 336
              Top = 192
              Width = 95
              Height = 25
              Caption = 'Black/White'
              TabOrder = 7
              OnClick = StarButton4Click
            end
          end
        end
        object t_font: TTabSheet
          Caption = 't_font'
          ImageIndex = 1
          TabVisible = False
          object Bevel10: TBevel
            Left = 8
            Top = 32
            Width = 393
            Height = 329
            Shape = bsFrame
          end
          object Label51: TLabel
            Left = 0
            Top = 0
            Width = 62
            Height = 13
            Caption = 'Fonts Setting'
          end
          object Label121: TLabel
            Left = 16
            Top = 74
            Width = 78
            Height = 13
            Caption = 'Coordinates Grid'
          end
          object Label122: TLabel
            Left = 16
            Top = 40
            Width = 31
            Height = 13
            Caption = 'Object'
          end
          object Label123: TLabel
            Left = 16
            Top = 115
            Width = 31
            Height = 13
            Caption = 'Labels'
          end
          object Label124: TLabel
            Left = 16
            Top = 157
            Width = 36
            Height = 13
            Caption = 'Legend'
          end
          object Label125: TLabel
            Left = 16
            Top = 198
            Width = 107
            Height = 13
            Caption = 'Screen and Status Bar'
          end
          object Label126: TLabel
            Left = 16
            Top = 240
            Width = 46
            Height = 13
            Caption = 'Object list'
          end
          object Label127: TLabel
            Left = 16
            Top = 282
            Width = 65
            Height = 13
            Caption = 'Printer legend'
          end
          object Label128: TLabel
            Left = 192
            Top = 40
            Width = 21
            Height = 13
            Caption = 'Font'
          end
          object Label129: TLabel
            Left = 344
            Top = 40
            Width = 31
            Height = 13
            Caption = 'Modify'
          end
          object SpeedButton1: TSpeedButton
            Tag = 1
            Left = 352
            Top = 69
            Width = 23
            Height = 22
            Glyph.Data = {
              76060000424D7606000000000000360000002800000014000000140000000100
              20000000000040060000000000000000000000000000000000000000003F0000
              0000000000000000000000000000000000000000000000000000000000000000
              0000000000000000000000000000000000000000000000000000000000000000
              00000000000000000000BFBFBF3FBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF
              BFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF
              BFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF3FBFBF
              BFBF7F0000BF7F000000BFBFBF00BFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF
              BFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF
              BFBFBFBFBFBFBFBFBFBFBFBFBF3FBFBFBFBF7F0000BF7F000000BFBFBF00BFBF
              BFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF
              BFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF3FBFBF
              BFBF7F0000BF7F000000BFBFBF00BFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF
              BFBFBFBFBFBFBFBFBFBFBFBFBFBFFF00FFBF00007F3FFF00FF00BFBFBF3FBFBF
              BFBFBFBFBFBFBFBFBFBFBFBFBF3FBFBFBFBF7F0000BF7F0000007F000000BFBF
              BF00BFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF
              BFBF00007FBFBFBFBF00BFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF3FBFBF
              BFBF7F0000BF7F000000BFBFBF00BFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF
              BFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF00007FBFBFBFBF00FF00FFBFBFBF
              BF3FBFBFBFBFBFBFBFBFBFBFBF3FBFBFBFBF7F0000BF7F000000BFBFBF00BFBF
              BFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF
              BFBF00007FBF00007F0000007F3FBFBFBF00BFBFBFBFBFBFBFBFBFBFBF3FBFBF
              BFBF7F0000BF7F0000007F0000007F000000BFBFBF00BFBFBFBF7F007FBF7F00
              7F00BFBFBF3FBFBFBFBFBFBFBFBFBFBFBFBF00007FBFBFBFBF00FF00FFBFBFBF
              BF3FBFBFBFBFBFBFBFBFBFBFBF3FBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF
              BFBFBFBFBFBFBFBFBFBFBFBFBFBFFF00FFBF7F007F3FBFBFBF00BFBFBFBFBFBF
              BFBF00007FBFBFBFBF00BFBFBFBFFF00FFBFBFBFBF3FBFBFBFBFBFBFBF3FBFBF
              BFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF
              BFBF7F007FBFBFBFBF00BFBFBFBFFF00FFBF00007F3F00007F0000007F3F0000
              7F00BFBFBF3FBFBFBFBFBFBFBF3FBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF
              BFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF7F007FBFBFBFBF00BFBFBFBFBFBF
              BFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF3FBFBF
              BFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF7F00
              7FBF7F007F3F7F007F00BFBFBF3FBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF
              BFBFBFBFBFBFBFBFBFBFBFBFBF3FBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF
              BFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF7F007FBFBFBFBF00BFBFBFBFBFBF
              BFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF3FBFBF
              BFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF
              BFBF7F007FBFFF00FF00BFBFBF3FBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF
              BFBFBFBFBFBFBFBFBFBFBFBFBF3FBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF
              BFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF7F007FBF7F007F3FBFBF
              BF00BFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF3FBFBF
              BFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF
              BFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF
              BFBFBFBFBFBFBFBFBFBF0000003F000000000000000000000000000000000000
              0000000000000000000000000000000000000000000000000000000000000000
              0000000000000000000000000000000000000000000000000000FFFFFF3F0000
              00BFFF000000FF000000FF000000FF000000FF000000FF000000FF000000FF00
              0000FF000000FF000000FF000000FF000000FF000000FF00000000000000FFFF
              FF00000000BFFFFFFF00FF00FF3FFF00FF3FFF00FF3FFF00FF3FFF00FF3FFF00
              FF3FFF00FF3FFF00FF3FFF00FF3FFF00FF3FFF00FF3FFF00FF3FFF00FF3FFF00
              FF3FFF00FF3FFF00FF3FFF00FF3FFF00FF3FFF00FF3FFF00FF3F}
            OnClick = SelectFontClick
          end
          object SpeedButton2: TSpeedButton
            Tag = 2
            Left = 352
            Top = 110
            Width = 23
            Height = 22
            Glyph.Data = {
              76060000424D7606000000000000360000002800000014000000140000000100
              20000000000040060000000000000000000000000000000000000000003F0000
              0000000000000000000000000000000000000000000000000000000000000000
              0000000000000000000000000000000000000000000000000000000000000000
              00000000000000000000BFBFBF3FBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF
              BFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF
              BFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF3FBFBF
              BFBF7F0000BF7F000000BFBFBF00BFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF
              BFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF
              BFBFBFBFBFBFBFBFBFBFBFBFBF3FBFBFBFBF7F0000BF7F000000BFBFBF00BFBF
              BFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF
              BFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF3FBFBF
              BFBF7F0000BF7F000000BFBFBF00BFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF
              BFBFBFBFBFBFBFBFBFBFBFBFBFBFFF00FFBF00007F3FFF00FF00BFBFBF3FBFBF
              BFBFBFBFBFBFBFBFBFBFBFBFBF3FBFBFBFBF7F0000BF7F0000007F000000BFBF
              BF00BFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF
              BFBF00007FBFBFBFBF00BFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF3FBFBF
              BFBF7F0000BF7F000000BFBFBF00BFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF
              BFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF00007FBFBFBFBF00FF00FFBFBFBF
              BF3FBFBFBFBFBFBFBFBFBFBFBF3FBFBFBFBF7F0000BF7F000000BFBFBF00BFBF
              BFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF
              BFBF00007FBF00007F0000007F3FBFBFBF00BFBFBFBFBFBFBFBFBFBFBF3FBFBF
              BFBF7F0000BF7F0000007F0000007F000000BFBFBF00BFBFBFBF7F007FBF7F00
              7F00BFBFBF3FBFBFBFBFBFBFBFBFBFBFBFBF00007FBFBFBFBF00FF00FFBFBFBF
              BF3FBFBFBFBFBFBFBFBFBFBFBF3FBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF
              BFBFBFBFBFBFBFBFBFBFBFBFBFBFFF00FFBF7F007F3FBFBFBF00BFBFBFBFBFBF
              BFBF00007FBFBFBFBF00BFBFBFBFFF00FFBFBFBFBF3FBFBFBFBFBFBFBF3FBFBF
              BFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF
              BFBF7F007FBFBFBFBF00BFBFBFBFFF00FFBF00007F3F00007F0000007F3F0000
              7F00BFBFBF3FBFBFBFBFBFBFBF3FBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF
              BFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF7F007FBFBFBFBF00BFBFBFBFBFBF
              BFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF3FBFBF
              BFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF7F00
              7FBF7F007F3F7F007F00BFBFBF3FBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF
              BFBFBFBFBFBFBFBFBFBFBFBFBF3FBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF
              BFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF7F007FBFBFBFBF00BFBFBFBFBFBF
              BFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF3FBFBF
              BFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF
              BFBF7F007FBFFF00FF00BFBFBF3FBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF
              BFBFBFBFBFBFBFBFBFBFBFBFBF3FBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF
              BFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF7F007FBF7F007F3FBFBF
              BF00BFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF3FBFBF
              BFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF
              BFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF
              BFBFBFBFBFBFBFBFBFBF0000003F000000000000000000000000000000000000
              0000000000000000000000000000000000000000000000000000000000000000
              0000000000000000000000000000000000000000000000000000FFFFFF3F0000
              00BFFF000000FF000000FF000000FF000000FF000000FF000000FF000000FF00
              0000FF000000FF000000FF000000FF000000FF000000FF00000000000000FFFF
              FF00000000BFFFFFFF00FF00FF3FFF00FF3FFF00FF3FFF00FF3FFF00FF3FFF00
              FF3FFF00FF3FFF00FF3FFF00FF3FFF00FF3FFF00FF3FFF00FF3FFF00FF3FFF00
              FF3FFF00FF3FFF00FF3FFF00FF3FFF00FF3FFF00FF3FFF00FF3F}
            OnClick = SelectFontClick
          end
          object SpeedButton3: TSpeedButton
            Tag = 3
            Left = 352
            Top = 152
            Width = 23
            Height = 22
            Glyph.Data = {
              76060000424D7606000000000000360000002800000014000000140000000100
              20000000000040060000000000000000000000000000000000000000003F0000
              0000000000000000000000000000000000000000000000000000000000000000
              0000000000000000000000000000000000000000000000000000000000000000
              00000000000000000000BFBFBF3FBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF
              BFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF
              BFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF3FBFBF
              BFBF7F0000BF7F000000BFBFBF00BFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF
              BFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF
              BFBFBFBFBFBFBFBFBFBFBFBFBF3FBFBFBFBF7F0000BF7F000000BFBFBF00BFBF
              BFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF
              BFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF3FBFBF
              BFBF7F0000BF7F000000BFBFBF00BFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF
              BFBFBFBFBFBFBFBFBFBFBFBFBFBFFF00FFBF00007F3FFF00FF00BFBFBF3FBFBF
              BFBFBFBFBFBFBFBFBFBFBFBFBF3FBFBFBFBF7F0000BF7F0000007F000000BFBF
              BF00BFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF
              BFBF00007FBFBFBFBF00BFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF3FBFBF
              BFBF7F0000BF7F000000BFBFBF00BFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF
              BFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF00007FBFBFBFBF00FF00FFBFBFBF
              BF3FBFBFBFBFBFBFBFBFBFBFBF3FBFBFBFBF7F0000BF7F000000BFBFBF00BFBF
              BFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF
              BFBF00007FBF00007F0000007F3FBFBFBF00BFBFBFBFBFBFBFBFBFBFBF3FBFBF
              BFBF7F0000BF7F0000007F0000007F000000BFBFBF00BFBFBFBF7F007FBF7F00
              7F00BFBFBF3FBFBFBFBFBFBFBFBFBFBFBFBF00007FBFBFBFBF00FF00FFBFBFBF
              BF3FBFBFBFBFBFBFBFBFBFBFBF3FBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF
              BFBFBFBFBFBFBFBFBFBFBFBFBFBFFF00FFBF7F007F3FBFBFBF00BFBFBFBFBFBF
              BFBF00007FBFBFBFBF00BFBFBFBFFF00FFBFBFBFBF3FBFBFBFBFBFBFBF3FBFBF
              BFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF
              BFBF7F007FBFBFBFBF00BFBFBFBFFF00FFBF00007F3F00007F0000007F3F0000
              7F00BFBFBF3FBFBFBFBFBFBFBF3FBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF
              BFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF7F007FBFBFBFBF00BFBFBFBFBFBF
              BFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF3FBFBF
              BFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF7F00
              7FBF7F007F3F7F007F00BFBFBF3FBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF
              BFBFBFBFBFBFBFBFBFBFBFBFBF3FBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF
              BFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF7F007FBFBFBFBF00BFBFBFBFBFBF
              BFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF3FBFBF
              BFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF
              BFBF7F007FBFFF00FF00BFBFBF3FBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF
              BFBFBFBFBFBFBFBFBFBFBFBFBF3FBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF
              BFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF7F007FBF7F007F3FBFBF
              BF00BFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF3FBFBF
              BFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF
              BFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF
              BFBFBFBFBFBFBFBFBFBF0000003F000000000000000000000000000000000000
              0000000000000000000000000000000000000000000000000000000000000000
              0000000000000000000000000000000000000000000000000000FFFFFF3F0000
              00BFFF000000FF000000FF000000FF000000FF000000FF000000FF000000FF00
              0000FF000000FF000000FF000000FF000000FF000000FF00000000000000FFFF
              FF00000000BFFFFFFF00FF00FF3FFF00FF3FFF00FF3FFF00FF3FFF00FF3FFF00
              FF3FFF00FF3FFF00FF3FFF00FF3FFF00FF3FFF00FF3FFF00FF3FFF00FF3FFF00
              FF3FFF00FF3FFF00FF3FFF00FF3FFF00FF3FFF00FF3FFF00FF3F}
            OnClick = SelectFontClick
          end
          object SpeedButton4: TSpeedButton
            Tag = 4
            Left = 352
            Top = 193
            Width = 23
            Height = 22
            Glyph.Data = {
              76060000424D7606000000000000360000002800000014000000140000000100
              20000000000040060000000000000000000000000000000000000000003F0000
              0000000000000000000000000000000000000000000000000000000000000000
              0000000000000000000000000000000000000000000000000000000000000000
              00000000000000000000BFBFBF3FBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF
              BFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF
              BFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF3FBFBF
              BFBF7F0000BF7F000000BFBFBF00BFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF
              BFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF
              BFBFBFBFBFBFBFBFBFBFBFBFBF3FBFBFBFBF7F0000BF7F000000BFBFBF00BFBF
              BFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF
              BFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF3FBFBF
              BFBF7F0000BF7F000000BFBFBF00BFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF
              BFBFBFBFBFBFBFBFBFBFBFBFBFBFFF00FFBF00007F3FFF00FF00BFBFBF3FBFBF
              BFBFBFBFBFBFBFBFBFBFBFBFBF3FBFBFBFBF7F0000BF7F0000007F000000BFBF
              BF00BFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF
              BFBF00007FBFBFBFBF00BFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF3FBFBF
              BFBF7F0000BF7F000000BFBFBF00BFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF
              BFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF00007FBFBFBFBF00FF00FFBFBFBF
              BF3FBFBFBFBFBFBFBFBFBFBFBF3FBFBFBFBF7F0000BF7F000000BFBFBF00BFBF
              BFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF
              BFBF00007FBF00007F0000007F3FBFBFBF00BFBFBFBFBFBFBFBFBFBFBF3FBFBF
              BFBF7F0000BF7F0000007F0000007F000000BFBFBF00BFBFBFBF7F007FBF7F00
              7F00BFBFBF3FBFBFBFBFBFBFBFBFBFBFBFBF00007FBFBFBFBF00FF00FFBFBFBF
              BF3FBFBFBFBFBFBFBFBFBFBFBF3FBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF
              BFBFBFBFBFBFBFBFBFBFBFBFBFBFFF00FFBF7F007F3FBFBFBF00BFBFBFBFBFBF
              BFBF00007FBFBFBFBF00BFBFBFBFFF00FFBFBFBFBF3FBFBFBFBFBFBFBF3FBFBF
              BFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF
              BFBF7F007FBFBFBFBF00BFBFBFBFFF00FFBF00007F3F00007F0000007F3F0000
              7F00BFBFBF3FBFBFBFBFBFBFBF3FBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF
              BFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF7F007FBFBFBFBF00BFBFBFBFBFBF
              BFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF3FBFBF
              BFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF7F00
              7FBF7F007F3F7F007F00BFBFBF3FBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF
              BFBFBFBFBFBFBFBFBFBFBFBFBF3FBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF
              BFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF7F007FBFBFBFBF00BFBFBFBFBFBF
              BFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF3FBFBF
              BFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF
              BFBF7F007FBFFF00FF00BFBFBF3FBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF
              BFBFBFBFBFBFBFBFBFBFBFBFBF3FBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF
              BFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF7F007FBF7F007F3FBFBF
              BF00BFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF3FBFBF
              BFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF
              BFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF
              BFBFBFBFBFBFBFBFBFBF0000003F000000000000000000000000000000000000
              0000000000000000000000000000000000000000000000000000000000000000
              0000000000000000000000000000000000000000000000000000FFFFFF3F0000
              00BFFF000000FF000000FF000000FF000000FF000000FF000000FF000000FF00
              0000FF000000FF000000FF000000FF000000FF000000FF00000000000000FFFF
              FF00000000BFFFFFFF00FF00FF3FFF00FF3FFF00FF3FFF00FF3FFF00FF3FFF00
              FF3FFF00FF3FFF00FF3FFF00FF3FFF00FF3FFF00FF3FFF00FF3FFF00FF3FFF00
              FF3FFF00FF3FFF00FF3FFF00FF3FFF00FF3FFF00FF3FFF00FF3F}
            OnClick = SelectFontClick
          end
          object SpeedButton5: TSpeedButton
            Tag = 5
            Left = 352
            Top = 235
            Width = 23
            Height = 22
            Glyph.Data = {
              76060000424D7606000000000000360000002800000014000000140000000100
              20000000000040060000000000000000000000000000000000000000003F0000
              0000000000000000000000000000000000000000000000000000000000000000
              0000000000000000000000000000000000000000000000000000000000000000
              00000000000000000000BFBFBF3FBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF
              BFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF
              BFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF3FBFBF
              BFBF7F0000BF7F000000BFBFBF00BFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF
              BFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF
              BFBFBFBFBFBFBFBFBFBFBFBFBF3FBFBFBFBF7F0000BF7F000000BFBFBF00BFBF
              BFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF
              BFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF3FBFBF
              BFBF7F0000BF7F000000BFBFBF00BFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF
              BFBFBFBFBFBFBFBFBFBFBFBFBFBFFF00FFBF00007F3FFF00FF00BFBFBF3FBFBF
              BFBFBFBFBFBFBFBFBFBFBFBFBF3FBFBFBFBF7F0000BF7F0000007F000000BFBF
              BF00BFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF
              BFBF00007FBFBFBFBF00BFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF3FBFBF
              BFBF7F0000BF7F000000BFBFBF00BFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF
              BFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF00007FBFBFBFBF00FF00FFBFBFBF
              BF3FBFBFBFBFBFBFBFBFBFBFBF3FBFBFBFBF7F0000BF7F000000BFBFBF00BFBF
              BFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF
              BFBF00007FBF00007F0000007F3FBFBFBF00BFBFBFBFBFBFBFBFBFBFBF3FBFBF
              BFBF7F0000BF7F0000007F0000007F000000BFBFBF00BFBFBFBF7F007FBF7F00
              7F00BFBFBF3FBFBFBFBFBFBFBFBFBFBFBFBF00007FBFBFBFBF00FF00FFBFBFBF
              BF3FBFBFBFBFBFBFBFBFBFBFBF3FBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF
              BFBFBFBFBFBFBFBFBFBFBFBFBFBFFF00FFBF7F007F3FBFBFBF00BFBFBFBFBFBF
              BFBF00007FBFBFBFBF00BFBFBFBFFF00FFBFBFBFBF3FBFBFBFBFBFBFBF3FBFBF
              BFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF
              BFBF7F007FBFBFBFBF00BFBFBFBFFF00FFBF00007F3F00007F0000007F3F0000
              7F00BFBFBF3FBFBFBFBFBFBFBF3FBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF
              BFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF7F007FBFBFBFBF00BFBFBFBFBFBF
              BFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF3FBFBF
              BFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF7F00
              7FBF7F007F3F7F007F00BFBFBF3FBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF
              BFBFBFBFBFBFBFBFBFBFBFBFBF3FBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF
              BFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF7F007FBFBFBFBF00BFBFBFBFBFBF
              BFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF3FBFBF
              BFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF
              BFBF7F007FBFFF00FF00BFBFBF3FBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF
              BFBFBFBFBFBFBFBFBFBFBFBFBF3FBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF
              BFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF7F007FBF7F007F3FBFBF
              BF00BFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF3FBFBF
              BFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF
              BFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF
              BFBFBFBFBFBFBFBFBFBF0000003F000000000000000000000000000000000000
              0000000000000000000000000000000000000000000000000000000000000000
              0000000000000000000000000000000000000000000000000000FFFFFF3F0000
              00BFFF000000FF000000FF000000FF000000FF000000FF000000FF000000FF00
              0000FF000000FF000000FF000000FF000000FF000000FF00000000000000FFFF
              FF00000000BFFFFFFF00FF00FF3FFF00FF3FFF00FF3FFF00FF3FFF00FF3FFF00
              FF3FFF00FF3FFF00FF3FFF00FF3FFF00FF3FFF00FF3FFF00FF3FFF00FF3FFF00
              FF3FFF00FF3FFF00FF3FFF00FF3FFF00FF3FFF00FF3FFF00FF3F}
            OnClick = SelectFontClick
          end
          object SpeedButton6: TSpeedButton
            Tag = 6
            Left = 352
            Top = 277
            Width = 23
            Height = 22
            Glyph.Data = {
              76060000424D7606000000000000360000002800000014000000140000000100
              20000000000040060000000000000000000000000000000000000000003F0000
              0000000000000000000000000000000000000000000000000000000000000000
              0000000000000000000000000000000000000000000000000000000000000000
              00000000000000000000BFBFBF3FBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF
              BFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF
              BFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF3FBFBF
              BFBF7F0000BF7F000000BFBFBF00BFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF
              BFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF
              BFBFBFBFBFBFBFBFBFBFBFBFBF3FBFBFBFBF7F0000BF7F000000BFBFBF00BFBF
              BFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF
              BFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF3FBFBF
              BFBF7F0000BF7F000000BFBFBF00BFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF
              BFBFBFBFBFBFBFBFBFBFBFBFBFBFFF00FFBF00007F3FFF00FF00BFBFBF3FBFBF
              BFBFBFBFBFBFBFBFBFBFBFBFBF3FBFBFBFBF7F0000BF7F0000007F000000BFBF
              BF00BFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF
              BFBF00007FBFBFBFBF00BFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF3FBFBF
              BFBF7F0000BF7F000000BFBFBF00BFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF
              BFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF00007FBFBFBFBF00FF00FFBFBFBF
              BF3FBFBFBFBFBFBFBFBFBFBFBF3FBFBFBFBF7F0000BF7F000000BFBFBF00BFBF
              BFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF
              BFBF00007FBF00007F0000007F3FBFBFBF00BFBFBFBFBFBFBFBFBFBFBF3FBFBF
              BFBF7F0000BF7F0000007F0000007F000000BFBFBF00BFBFBFBF7F007FBF7F00
              7F00BFBFBF3FBFBFBFBFBFBFBFBFBFBFBFBF00007FBFBFBFBF00FF00FFBFBFBF
              BF3FBFBFBFBFBFBFBFBFBFBFBF3FBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF
              BFBFBFBFBFBFBFBFBFBFBFBFBFBFFF00FFBF7F007F3FBFBFBF00BFBFBFBFBFBF
              BFBF00007FBFBFBFBF00BFBFBFBFFF00FFBFBFBFBF3FBFBFBFBFBFBFBF3FBFBF
              BFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF
              BFBF7F007FBFBFBFBF00BFBFBFBFFF00FFBF00007F3F00007F0000007F3F0000
              7F00BFBFBF3FBFBFBFBFBFBFBF3FBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF
              BFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF7F007FBFBFBFBF00BFBFBFBFBFBF
              BFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF3FBFBF
              BFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF7F00
              7FBF7F007F3F7F007F00BFBFBF3FBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF
              BFBFBFBFBFBFBFBFBFBFBFBFBF3FBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF
              BFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF7F007FBFBFBFBF00BFBFBFBFBFBF
              BFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF3FBFBF
              BFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF
              BFBF7F007FBFFF00FF00BFBFBF3FBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF
              BFBFBFBFBFBFBFBFBFBFBFBFBF3FBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF
              BFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF7F007FBF7F007F3FBFBF
              BF00BFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF3FBFBF
              BFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF
              BFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF
              BFBFBFBFBFBFBFBFBFBF0000003F000000000000000000000000000000000000
              0000000000000000000000000000000000000000000000000000000000000000
              0000000000000000000000000000000000000000000000000000FFFFFF3F0000
              00BFFF000000FF000000FF000000FF000000FF000000FF000000FF000000FF00
              0000FF000000FF000000FF000000FF000000FF000000FF00000000000000FFFF
              FF00000000BFFFFFFF00FF00FF3FFF00FF3FFF00FF3FFF00FF3FFF00FF3FFF00
              FF3FFF00FF3FFF00FF3FFF00FF3FFF00FF3FFF00FF3FFF00FF3FFF00FF3FFF00
              FF3FFF00FF3FFF00FF3FFF00FF3FFF00FF3FFF00FF3FFF00FF3F}
            OnClick = SelectFontClick
          end
          object SpeedButton7: TSpeedButton
            Tag = 7
            Left = 352
            Top = 317
            Width = 23
            Height = 22
            Glyph.Data = {
              76060000424D7606000000000000360000002800000014000000140000000100
              20000000000040060000000000000000000000000000000000000000003F0000
              0000000000000000000000000000000000000000000000000000000000000000
              0000000000000000000000000000000000000000000000000000000000000000
              00000000000000000000BFBFBF3FBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF
              BFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF
              BFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF3FBFBF
              BFBF7F0000BF7F000000BFBFBF00BFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF
              BFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF
              BFBFBFBFBFBFBFBFBFBFBFBFBF3FBFBFBFBF7F0000BF7F000000BFBFBF00BFBF
              BFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF
              BFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF3FBFBF
              BFBF7F0000BF7F000000BFBFBF00BFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF
              BFBFBFBFBFBFBFBFBFBFBFBFBFBFFF00FFBF00007F3FFF00FF00BFBFBF3FBFBF
              BFBFBFBFBFBFBFBFBFBFBFBFBF3FBFBFBFBF7F0000BF7F0000007F000000BFBF
              BF00BFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF
              BFBF00007FBFBFBFBF00BFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF3FBFBF
              BFBF7F0000BF7F000000BFBFBF00BFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF
              BFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF00007FBFBFBFBF00FF00FFBFBFBF
              BF3FBFBFBFBFBFBFBFBFBFBFBF3FBFBFBFBF7F0000BF7F000000BFBFBF00BFBF
              BFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF
              BFBF00007FBF00007F0000007F3FBFBFBF00BFBFBFBFBFBFBFBFBFBFBF3FBFBF
              BFBF7F0000BF7F0000007F0000007F000000BFBFBF00BFBFBFBF7F007FBF7F00
              7F00BFBFBF3FBFBFBFBFBFBFBFBFBFBFBFBF00007FBFBFBFBF00FF00FFBFBFBF
              BF3FBFBFBFBFBFBFBFBFBFBFBF3FBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF
              BFBFBFBFBFBFBFBFBFBFBFBFBFBFFF00FFBF7F007F3FBFBFBF00BFBFBFBFBFBF
              BFBF00007FBFBFBFBF00BFBFBFBFFF00FFBFBFBFBF3FBFBFBFBFBFBFBF3FBFBF
              BFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF
              BFBF7F007FBFBFBFBF00BFBFBFBFFF00FFBF00007F3F00007F0000007F3F0000
              7F00BFBFBF3FBFBFBFBFBFBFBF3FBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF
              BFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF7F007FBFBFBFBF00BFBFBFBFBFBF
              BFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF3FBFBF
              BFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF7F00
              7FBF7F007F3F7F007F00BFBFBF3FBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF
              BFBFBFBFBFBFBFBFBFBFBFBFBF3FBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF
              BFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF7F007FBFBFBFBF00BFBFBFBFBFBF
              BFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF3FBFBF
              BFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF
              BFBF7F007FBFFF00FF00BFBFBF3FBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF
              BFBFBFBFBFBFBFBFBFBFBFBFBF3FBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF
              BFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF7F007FBF7F007F3FBFBF
              BF00BFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF3FBFBF
              BFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF
              BFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF
              BFBFBFBFBFBFBFBFBFBF0000003F000000000000000000000000000000000000
              0000000000000000000000000000000000000000000000000000000000000000
              0000000000000000000000000000000000000000000000000000FFFFFF3F0000
              00BFFF000000FF000000FF000000FF000000FF000000FF000000FF000000FF00
              0000FF000000FF000000FF000000FF000000FF000000FF00000000000000FFFF
              FF00000000BFFFFFFF00FF00FF3FFF00FF3FFF00FF3FFF00FF3FFF00FF3FFF00
              FF3FFF00FF3FFF00FF3FFF00FF3FFF00FF3FFF00FF3FFF00FF3FFF00FF3FFF00
              FF3FFF00FF3FFF00FF3FFF00FF3FFF00FF3FFF00FF3FFF00FF3F}
            OnClick = SelectFontClick
          end
          object Label235: TLabel
            Left = 16
            Top = 328
            Width = 64
            Height = 13
            Caption = 'Greek symbol'
          end
          object gridfont: TEdit
            Left = 184
            Top = 65
            Width = 160
            Height = 30
            TabStop = False
            AutoSize = False
            Color = clBtnFace
            ReadOnly = True
            TabOrder = 0
          end
          object labelfont: TEdit
            Left = 184
            Top = 106
            Width = 160
            Height = 30
            TabStop = False
            AutoSize = False
            Color = clBtnFace
            ReadOnly = True
            TabOrder = 1
          end
          object legendfont: TEdit
            Left = 184
            Top = 148
            Width = 160
            Height = 30
            TabStop = False
            AutoSize = False
            Color = clBtnFace
            ReadOnly = True
            TabOrder = 2
          end
          object statusfont: TEdit
            Left = 184
            Top = 189
            Width = 160
            Height = 30
            TabStop = False
            AutoSize = False
            Color = clBtnFace
            ReadOnly = True
            TabOrder = 3
          end
          object listfont: TEdit
            Left = 184
            Top = 231
            Width = 160
            Height = 30
            TabStop = False
            AutoSize = False
            Color = clBtnFace
            ReadOnly = True
            TabOrder = 4
          end
          object prtfont: TEdit
            Left = 184
            Top = 273
            Width = 160
            Height = 30
            TabStop = False
            AutoSize = False
            Color = clBtnFace
            ReadOnly = True
            TabOrder = 5
          end
          object Button1: TButton
            Left = 184
            Top = 376
            Width = 75
            Height = 25
            Caption = 'Default'
            TabOrder = 6
            OnClick = DefaultFontClick
          end
          object symbfont: TEdit
            Left = 184
            Top = 313
            Width = 160
            Height = 30
            TabStop = False
            AutoSize = False
            Color = clBtnFace
            ReadOnly = True
            TabOrder = 7
          end
        end
        object t_color: TTabSheet
          Caption = 't_color'
          ImageIndex = 2
          TabVisible = False
          object Label8: TLabel
            Left = 0
            Top = 0
            Width = 60
            Height = 13
            Caption = 'Color Setting'
          end
          object Label181: TLabel
            Left = 93
            Top = 22
            Width = 18
            Height = 13
            Caption = '-0.3'
          end
          object Label182: TLabel
            Left = 147
            Top = 22
            Width = 18
            Height = 13
            Caption = '-0.1'
          end
          object Label183: TLabel
            Left = 201
            Top = 22
            Width = 15
            Height = 13
            Caption = '0.2'
          end
          object Label184: TLabel
            Left = 254
            Top = 22
            Width = 15
            Height = 13
            Caption = '0.5'
          end
          object Label185: TLabel
            Left = 308
            Top = 22
            Width = 15
            Height = 13
            Caption = '0.8'
          end
          object Label186: TLabel
            Left = 362
            Top = 22
            Width = 15
            Height = 13
            Caption = '1.3'
          end
          object Label187: TLabel
            Left = 416
            Top = 22
            Width = 6
            Height = 13
            Caption = '>'
          end
          object Label188: TLabel
            Left = 40
            Top = 22
            Width = 6
            Height = 13
            Caption = '<'
          end
          object Label189: TLabel
            Left = 8
            Top = 22
            Width = 20
            Height = 13
            Caption = 'B-V:'
          end
          object Label190: TLabel
            Left = 56
            Top = 86
            Width = 32
            Height = 13
            Alignment = taCenter
            Caption = 'Galaxy'
          end
          object Label191: TLabel
            Left = 120
            Top = 86
            Width = 32
            Height = 13
            Alignment = taCenter
            Caption = 'Cluster'
          end
          object Label192: TLabel
            Left = 185
            Top = 86
            Width = 34
            Height = 13
            Alignment = taCenter
            Caption = 'Nebula'
          end
          object Label193: TLabel
            Left = 248
            Top = 86
            Width = 34
            Height = 13
            Alignment = taCenter
            Caption = 'Az Grid'
          end
          object Label194: TLabel
            Left = 307
            Top = 86
            Width = 35
            Height = 13
            Alignment = taCenter
            Caption = 'Eq Grid'
          end
          object Label195: TLabel
            Left = 380
            Top = 86
            Width = 22
            Height = 13
            Alignment = taCenter
            Caption = 'Orbit'
          end
          object Label197: TLabel
            Left = 32
            Top = 150
            Width = 92
            Height = 13
            Alignment = taCenter
            Caption = 'Constellation Figure'
          end
          object Label198: TLabel
            Left = 144
            Top = 150
            Width = 45
            Height = 13
            Alignment = taCenter
            Caption = 'Boundary'
          end
          object Label199: TLabel
            Left = 208
            Top = 150
            Width = 73
            Height = 13
            Alignment = taCenter
            Caption = 'Eyepiece Circle'
          end
          object Label196: TLabel
            Left = 290
            Top = 150
            Width = 53
            Height = 13
            Alignment = taCenter
            Caption = 'Misc. Lines'
          end
          object Label11: TLabel
            Left = 374
            Top = 150
            Width = 36
            Height = 13
            Alignment = taCenter
            Caption = 'Horizon'
          end
          object Label6: TLabel
            Left = 56
            Top = 214
            Width = 38
            Height = 13
            Alignment = taCenter
            Caption = 'Asteroid'
          end
          object Label234: TLabel
            Left = 120
            Top = 214
            Width = 30
            Height = 13
            Alignment = taCenter
            Caption = 'Comet'
          end
          object bg1: TPanel
            Left = 32
            Top = 36
            Width = 401
            Height = 38
            TabOrder = 0
            OnClick = bgClick
            object Shape1: TShape
              Tag = 1
              Left = 24
              Top = 4
              Width = 30
              Height = 30
              Shape = stCircle
              OnMouseUp = ShapeMouseUp
            end
            object Shape2: TShape
              Tag = 2
              Left = 77
              Top = 4
              Width = 30
              Height = 30
              Shape = stCircle
              OnMouseUp = ShapeMouseUp
            end
            object Shape3: TShape
              Tag = 3
              Left = 130
              Top = 4
              Width = 30
              Height = 30
              Shape = stCircle
              OnMouseUp = ShapeMouseUp
            end
            object Shape4: TShape
              Tag = 4
              Left = 184
              Top = 4
              Width = 30
              Height = 30
              Shape = stCircle
              OnMouseUp = ShapeMouseUp
            end
            object Shape5: TShape
              Tag = 5
              Left = 237
              Top = 4
              Width = 30
              Height = 30
              Shape = stCircle
              OnMouseUp = ShapeMouseUp
            end
            object Shape6: TShape
              Tag = 6
              Left = 290
              Top = 4
              Width = 30
              Height = 30
              Shape = stCircle
              OnMouseUp = ShapeMouseUp
            end
            object Shape7: TShape
              Tag = 7
              Left = 344
              Top = 4
              Width = 30
              Height = 30
              Shape = stCircle
              OnMouseUp = ShapeMouseUp
            end
          end
          object bg2: TPanel
            Left = 32
            Top = 100
            Width = 401
            Height = 38
            TabOrder = 1
            OnClick = bgClick
            object Shape8: TShape
              Tag = 8
              Left = 24
              Top = 7
              Width = 33
              Height = 25
              Brush.Style = bsClear
              Pen.Color = clWhite
              Pen.Width = 3
              Shape = stEllipse
              OnMouseUp = ShapeMouseUp
            end
            object Shape9: TShape
              Tag = 9
              Left = 88
              Top = 4
              Width = 30
              Height = 30
              Brush.Style = bsClear
              Pen.Color = clWhite
              Pen.Width = 3
              Shape = stCircle
              OnMouseUp = ShapeMouseUp
            end
            object Shape10: TShape
              Tag = 10
              Left = 152
              Top = 4
              Width = 30
              Height = 30
              Brush.Style = bsClear
              Pen.Color = clWhite
              Pen.Width = 3
              Shape = stSquare
              OnMouseUp = ShapeMouseUp
            end
            object Shape11: TShape
              Tag = 12
              Left = 216
              Top = 4
              Width = 30
              Height = 30
              Brush.Style = bsClear
              Pen.Color = clWhite
              Pen.Width = 3
              Shape = stSquare
              OnMouseUp = ShapeMouseUp
            end
            object Shape12: TShape
              Tag = 13
              Left = 280
              Top = 4
              Width = 30
              Height = 30
              Brush.Style = bsClear
              Pen.Color = clWhite
              Pen.Width = 3
              Shape = stSquare
              OnMouseUp = ShapeMouseUp
            end
            object Shape13: TShape
              Tag = 14
              Left = 344
              Top = 4
              Width = 30
              Height = 30
              Brush.Style = bsClear
              Pen.Color = clWhite
              Pen.Width = 3
              Shape = stSquare
              OnMouseUp = ShapeMouseUp
            end
          end
          object bg3: TPanel
            Left = 32
            Top = 164
            Width = 401
            Height = 38
            TabOrder = 2
            OnClick = bgClick
            object Shape15: TShape
              Tag = 16
              Left = 32
              Top = 4
              Width = 33
              Height = 30
              Brush.Style = bsClear
              Pen.Color = clWhite
              Pen.Width = 3
              Shape = stSquare
              OnMouseUp = ShapeMouseUp
            end
            object Shape16: TShape
              Tag = 17
              Left = 114
              Top = 4
              Width = 30
              Height = 30
              Brush.Style = bsClear
              Pen.Color = clWhite
              Pen.Width = 3
              Shape = stSquare
              OnMouseUp = ShapeMouseUp
            end
            object Shape17: TShape
              Tag = 18
              Left = 197
              Top = 4
              Width = 30
              Height = 30
              Brush.Style = bsClear
              Pen.Color = clWhite
              Pen.Width = 3
              Shape = stCircle
              OnMouseUp = ShapeMouseUp
            end
            object Shape14: TShape
              Tag = 15
              Left = 272
              Top = 4
              Width = 30
              Height = 30
              Brush.Style = bsClear
              Pen.Color = clWhite
              Pen.Width = 3
              Shape = stSquare
              OnMouseUp = ShapeMouseUp
            end
            object Shape25: TShape
              Tag = 19
              Left = 344
              Top = 4
              Width = 30
              Height = 30
              Shape = stSquare
              OnMouseUp = ShapeMouseUp
            end
          end
          object DefColor: TRadioGroup
            Left = 32
            Top = 288
            Width = 401
            Height = 89
            Caption = 'Standard  Color'
            Columns = 2
            ItemIndex = 0
            Items.Strings = (
              'Default'
              'Red'
              'Black/White'
              'White/Black')
            TabOrder = 3
            OnClick = DefColorClick
          end
          object bg4: TPanel
            Left = 32
            Top = 228
            Width = 401
            Height = 38
            TabOrder = 4
            OnClick = bgClick
            object Shape26: TShape
              Tag = 20
              Left = 24
              Top = 4
              Width = 30
              Height = 30
              Shape = stCircle
              OnMouseUp = ShapeMouseUp
            end
            object Shape27: TShape
              Tag = 21
              Left = 88
              Top = 4
              Width = 30
              Height = 30
              Shape = stCircle
              OnMouseUp = ShapeMouseUp
            end
          end
        end
        object t_skycolor: TTabSheet
          Caption = 't_skycolor'
          ImageIndex = 3
          TabVisible = False
          object Label200: TLabel
            Left = 0
            Top = 0
            Width = 81
            Height = 13
            Caption = 'Sky Color Setting'
          end
          object Label202: TLabel
            Left = 24
            Top = 272
            Width = 50
            Height = 57
            Alignment = taCenter
            AutoSize = False
            Caption = 'Day Time'
            WordWrap = True
          end
          object Label205: TLabel
            Left = 120
            Top = 272
            Width = 169
            Height = 57
            Alignment = taCenter
            AutoSize = False
            Caption = 'Twilight'
            WordWrap = True
          end
          object Label208: TLabel
            Left = 320
            Top = 272
            Width = 81
            Height = 57
            Alignment = taCenter
            AutoSize = False
            Caption = 'Astronomical Twilight'
            WordWrap = True
          end
          object skycolorbox: TRadioGroup
            Left = 24
            Top = 48
            Width = 364
            Height = 89
            Caption = 'Sky Color'
            Columns = 2
            Items.Strings = (
              'Fixed'
              'Automatic')
            TabOrder = 0
            OnClick = skycolorboxClick
          end
          object Panel6: TPanel
            Left = 24
            Top = 168
            Width = 364
            Height = 97
            TabOrder = 1
            object Shape18: TShape
              Tag = 1
              Left = 0
              Top = 0
              Width = 52
              Height = 97
              Pen.Color = clSilver
              OnMouseUp = ShapeSkyMouseUp
            end
            object Shape19: TShape
              Tag = 2
              Left = 52
              Top = 0
              Width = 52
              Height = 97
              Pen.Color = clSilver
              OnMouseUp = ShapeSkyMouseUp
            end
            object Shape20: TShape
              Tag = 3
              Left = 104
              Top = 0
              Width = 52
              Height = 97
              Pen.Color = clSilver
              OnMouseUp = ShapeSkyMouseUp
            end
            object Shape21: TShape
              Tag = 4
              Left = 156
              Top = 0
              Width = 52
              Height = 97
              Pen.Color = clSilver
              OnMouseUp = ShapeSkyMouseUp
            end
            object Shape22: TShape
              Tag = 5
              Left = 208
              Top = 0
              Width = 52
              Height = 97
              Pen.Color = clSilver
              OnMouseUp = ShapeSkyMouseUp
            end
            object Shape23: TShape
              Tag = 6
              Left = 260
              Top = 0
              Width = 52
              Height = 97
              Pen.Color = clSilver
              OnMouseUp = ShapeSkyMouseUp
            end
            object Shape24: TShape
              Tag = 7
              Left = 312
              Top = 0
              Width = 52
              Height = 97
              Pen.Color = clSilver
              OnMouseUp = ShapeSkyMouseUp
            end
          end
          object Button3: TButton
            Left = 24
            Top = 344
            Width = 75
            Height = 25
            Caption = 'Reset'
            TabOrder = 2
            OnClick = Button3Click
          end
        end
        object t_nebcolor: TTabSheet
          Caption = 't_nebcolor'
          ImageIndex = 4
          TabVisible = False
          object Label201: TLabel
            Left = 0
            Top = 0
            Width = 103
            Height = 13
            Caption = 'Nebulae Color Setting'
          end
        end
        object t_lines: TTabSheet
          Caption = 't_lines'
          ImageIndex = 5
          TabVisible = False
          object Label9: TLabel
            Left = 0
            Top = 0
            Width = 61
            Height = 13
            Caption = 'Lines Setting'
          end
          object Bevel6: TBevel
            Left = 8
            Top = 136
            Width = 449
            Height = 81
            Shape = bsFrame
          end
          object Label132: TLabel
            Left = 24
            Top = 184
            Width = 151
            Height = 13
            Caption = 'Constellation Figure File Name : '
          end
          object Bevel11: TBevel
            Left = 8
            Top = 224
            Width = 449
            Height = 81
            Shape = bsFrame
          end
          object Label72: TLabel
            Left = 24
            Top = 272
            Width = 167
            Height = 13
            Caption = 'Constellation Boundary File Name : '
          end
          object Bevel12: TBevel
            Left = 8
            Top = 312
            Width = 449
            Height = 57
            Shape = bsFrame
          end
          object EqGrid: TCheckBox
            Left = 24
            Top = 64
            Width = 185
            Height = 30
            Caption = 'Add Equatorial Grid'
            TabOrder = 0
            OnClick = EqGridClick
          end
          object CGrid: TCheckBox
            Left = 24
            Top = 32
            Width = 185
            Height = 30
            Caption = 'Show Coordinate Grid'
            TabOrder = 1
            OnClick = CGridClick
          end
          object Constl: TCheckBox
            Left = 24
            Top = 144
            Width = 300
            Height = 30
            Caption = 'Show Constellation Figure'
            TabOrder = 2
            OnClick = ConstlClick
          end
          object ConstlFile: TEdit
            Left = 216
            Top = 180
            Width = 201
            Height = 21
            TabOrder = 3
            OnChange = ConstlFileChange
          end
          object ConstlFileBtn: TBitBtn
            Tag = 8
            Left = 415
            Top = 180
            Width = 26
            Height = 26
            TabOrder = 4
            TabStop = False
            OnClick = ConstlFileBtnClick
            Glyph.Data = {
              36030000424D3603000000000000360000002800000010000000100000000100
              1800000000000003000000000000000000000000000000000000C0CFCFC0CFCF
              C0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CF
              CFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0
              CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCF
              0000000000000000000000000000000000000000000000000000000000000000
              00C0CFCFC0CFCFC0CFCFC0CFCFC0CFCF7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F
              7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F000000C0CFCFC0CFCFC0CFCFC0CFCF
              7F7F7FFFFFFFC0CFCF00FFFFC0CFCF00FFFFC0CFCF00FFFFC0CFCF00FFFF7F7F
              7F000000C0CFCFC0CFCFC0CFCFC0CFCF7F7F7FFFFFFF00FFFFC0CFCF00FFFFC0
              CFCF00FFFFC0CFCF00FFFFC0CFCF7F7F7F000000C0CFCFC0CFCFC0CFCFC0CFCF
              7F7F7FFFFFFFC0CFCF00FFFFC0CFCF00FFFFC0CFCF00FFFFC0CFCF00FFFF7F7F
              7F000000C0CFCFC0CFCFC0CFCFC0CFCF7F7F7FFFFFFF00FFFFC0CFCF00FFFFC0
              CFCF00FFFFC0CFCF00FFFFC0CFCF7F7F7F000000C0CFCFC0CFCFC0CFCFC0CFCF
              7F7F7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF7F7F
              7F000000C0CFCFC0CFCFC0CFCFC0CFCF7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F
              7F7F7F7F7F7F7F7F7F7F7F7F7F7F000000C0CFCFC0CFCFC0CFCFC0CFCFC0CFCF
              7F7F7F00FFFFFFFFFF00FFFFFFFFFF7F7F7FC0CFCFC0CFCFC0CFCFC0CFCFC0CF
              CFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCF7F7F7F7F7F7F7F7F7F7F7F7FC0
              CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCF
              C0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CF
              CFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0
              CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCF
              C0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CF
              CFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0
              CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCF}
            Layout = blGlyphTop
            Margin = 0
          end
          object ecliptic: TCheckBox
            Left = 224
            Top = 32
            Width = 185
            Height = 30
            Caption = 'Show Ecliptic'
            TabOrder = 5
            OnClick = eclipticClick
          end
          object galactic: TCheckBox
            Left = 224
            Top = 64
            Width = 185
            Height = 30
            Caption = 'Show Galactic Equator'
            TabOrder = 6
            OnClick = galacticClick
          end
          object Constb: TCheckBox
            Left = 24
            Top = 232
            Width = 300
            Height = 30
            Caption = 'Show Constellation Boundary'
            TabOrder = 7
            OnClick = ConstbClick
          end
          object ConstbFile: TEdit
            Left = 216
            Top = 268
            Width = 201
            Height = 21
            TabOrder = 8
            OnChange = ConstbFileChange
          end
          object ConstbfileBtn: TBitBtn
            Tag = 8
            Left = 415
            Top = 268
            Width = 26
            Height = 26
            TabOrder = 9
            TabStop = False
            OnClick = ConstbfileBtnClick
            Glyph.Data = {
              36030000424D3603000000000000360000002800000010000000100000000100
              1800000000000003000000000000000000000000000000000000C0CFCFC0CFCF
              C0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CF
              CFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0
              CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCF
              0000000000000000000000000000000000000000000000000000000000000000
              00C0CFCFC0CFCFC0CFCFC0CFCFC0CFCF7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F
              7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F000000C0CFCFC0CFCFC0CFCFC0CFCF
              7F7F7FFFFFFFC0CFCF00FFFFC0CFCF00FFFFC0CFCF00FFFFC0CFCF00FFFF7F7F
              7F000000C0CFCFC0CFCFC0CFCFC0CFCF7F7F7FFFFFFF00FFFFC0CFCF00FFFFC0
              CFCF00FFFFC0CFCF00FFFFC0CFCF7F7F7F000000C0CFCFC0CFCFC0CFCFC0CFCF
              7F7F7FFFFFFFC0CFCF00FFFFC0CFCF00FFFFC0CFCF00FFFFC0CFCF00FFFF7F7F
              7F000000C0CFCFC0CFCFC0CFCFC0CFCF7F7F7FFFFFFF00FFFFC0CFCF00FFFFC0
              CFCF00FFFFC0CFCF00FFFFC0CFCF7F7F7F000000C0CFCFC0CFCFC0CFCFC0CFCF
              7F7F7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF7F7F
              7F000000C0CFCFC0CFCFC0CFCFC0CFCF7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F
              7F7F7F7F7F7F7F7F7F7F7F7F7F7F000000C0CFCFC0CFCFC0CFCFC0CFCFC0CFCF
              7F7F7F00FFFFFFFFFF00FFFFFFFFFF7F7F7FC0CFCFC0CFCFC0CFCFC0CFCFC0CF
              CFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCF7F7F7F7F7F7F7F7F7F7F7F7FC0
              CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCF
              C0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CF
              CFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0
              CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCF
              C0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CF
              CFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0
              CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCF}
            Layout = blGlyphTop
            Margin = 0
          end
          object milkyway: TCheckBox
            Left = 24
            Top = 320
            Width = 185
            Height = 30
            Caption = 'Show Milky Way'
            TabOrder = 10
            OnClick = milkywayClick
          end
          object fillmilkyway: TCheckBox
            Left = 224
            Top = 320
            Width = 185
            Height = 30
            Caption = 'Fill Milky Way'
            TabOrder = 11
            OnClick = fillmilkywayClick
          end
          object GridNum: TCheckBox
            Left = 24
            Top = 96
            Width = 185
            Height = 30
            Caption = 'Show Grid Label'
            TabOrder = 12
            OnClick = GridNumClick
          end
        end
        object t_labels: TTabSheet
          Caption = 't_labels'
          ImageIndex = 6
          TabVisible = False
          object Label10: TLabel
            Left = 0
            Top = 0
            Width = 67
            Height = 13
            Caption = 'Labels Setting'
          end
          object labelcolorStar: TShape
            Tag = 1
            Left = 344
            Top = 88
            Width = 17
            Height = 17
            OnMouseUp = labelcolorMouseUp
          end
          object Label236: TLabel
            Left = 40
            Top = 40
            Width = 60
            Height = 13
            Caption = 'Label Object'
          end
          object Label237: TLabel
            Left = 264
            Top = 40
            Width = 65
            Height = 33
            AutoSize = False
            Caption = 'Magnitude difference'
            WordWrap = True
          end
          object Label240: TLabel
            Left = 344
            Top = 40
            Width = 26
            Height = 13
            Caption = 'Label'
          end
          object Label252: TLabel
            Left = 344
            Top = 56
            Width = 24
            Height = 13
            Caption = 'Color'
          end
          object Label255: TLabel
            Left = 384
            Top = 56
            Width = 20
            Height = 13
            Caption = 'Size'
          end
          object labelcolorVar: TShape
            Tag = 2
            Left = 344
            Top = 120
            Width = 17
            Height = 17
            OnMouseUp = labelcolorMouseUp
          end
          object labelcolorMult: TShape
            Tag = 3
            Left = 344
            Top = 152
            Width = 17
            Height = 17
            OnMouseUp = labelcolorMouseUp
          end
          object labelcolorNeb: TShape
            Tag = 4
            Left = 344
            Top = 184
            Width = 17
            Height = 17
            OnMouseUp = labelcolorMouseUp
          end
          object labelcolorSol: TShape
            Tag = 5
            Left = 344
            Top = 216
            Width = 17
            Height = 17
            OnMouseUp = labelcolorMouseUp
          end
          object labelcolorMisc: TShape
            Tag = 7
            Left = 344
            Top = 280
            Width = 17
            Height = 17
            OnMouseUp = labelcolorMouseUp
          end
          object labelcolorConst: TShape
            Tag = 6
            Left = 344
            Top = 248
            Width = 17
            Height = 17
            OnMouseUp = labelcolorMouseUp
          end
          object labelsizeStar: TSpinEdit
            Tag = 1
            Left = 384
            Top = 85
            Width = 41
            Height = 22
            MaxValue = 48
            MinValue = 6
            TabOrder = 0
            Value = 6
            OnChange = labelsizeChange
          end
          object labelmagStar: TSpinEdit
            Tag = 1
            Left = 264
            Top = 85
            Width = 41
            Height = 22
            MaxValue = 10
            MinValue = 0
            TabOrder = 1
            Value = 0
            OnChange = labelmagChange
          end
          object showlabelStar: TCheckBox
            Tag = 1
            Left = 40
            Top = 88
            Width = 209
            Height = 17
            Caption = 'Stars'
            TabOrder = 2
            OnClick = showlabelClick
          end
          object labelsizeVar: TSpinEdit
            Tag = 2
            Left = 384
            Top = 117
            Width = 41
            Height = 22
            MaxValue = 48
            MinValue = 6
            TabOrder = 3
            Value = 6
          end
          object labelmagVar: TSpinEdit
            Tag = 2
            Left = 264
            Top = 117
            Width = 41
            Height = 22
            MaxValue = 10
            MinValue = 0
            TabOrder = 4
            Value = 0
            OnChange = labelmagChange
          end
          object showlabelVar: TCheckBox
            Tag = 2
            Left = 40
            Top = 120
            Width = 209
            Height = 17
            Caption = 'Variable Stars'
            TabOrder = 5
            OnClick = showlabelClick
          end
          object labelsizeMult: TSpinEdit
            Tag = 3
            Left = 384
            Top = 149
            Width = 41
            Height = 22
            MaxValue = 48
            MinValue = 6
            TabOrder = 6
            Value = 6
          end
          object LabelmagMult: TSpinEdit
            Tag = 3
            Left = 264
            Top = 149
            Width = 41
            Height = 22
            MaxValue = 10
            MinValue = 0
            TabOrder = 7
            Value = 0
            OnChange = labelmagChange
          end
          object showlabelMult: TCheckBox
            Tag = 3
            Left = 40
            Top = 152
            Width = 209
            Height = 17
            Caption = 'Multiple Stars'
            TabOrder = 8
            OnClick = showlabelClick
          end
          object labelsizeNeb: TSpinEdit
            Tag = 4
            Left = 384
            Top = 181
            Width = 41
            Height = 22
            MaxValue = 48
            MinValue = 6
            TabOrder = 9
            Value = 6
          end
          object labelmagNeb: TSpinEdit
            Tag = 4
            Left = 264
            Top = 181
            Width = 41
            Height = 22
            MaxValue = 10
            MinValue = 0
            TabOrder = 10
            Value = 0
            OnChange = labelmagChange
          end
          object showlabelNeb: TCheckBox
            Tag = 4
            Left = 40
            Top = 184
            Width = 209
            Height = 17
            Caption = 'Nebulae'
            TabOrder = 11
            OnClick = showlabelClick
          end
          object labelsizeSol: TSpinEdit
            Tag = 5
            Left = 384
            Top = 213
            Width = 41
            Height = 22
            MaxValue = 48
            MinValue = 6
            TabOrder = 12
            Value = 6
          end
          object labelmagSol: TSpinEdit
            Tag = 5
            Left = 264
            Top = 213
            Width = 41
            Height = 22
            MaxValue = 10
            MinValue = 0
            TabOrder = 13
            Value = 0
            OnChange = labelmagChange
          end
          object showlabelSol: TCheckBox
            Tag = 5
            Left = 40
            Top = 216
            Width = 209
            Height = 17
            Caption = 'Solar System'
            TabOrder = 14
            OnClick = showlabelClick
          end
          object labelsizeMisc: TSpinEdit
            Tag = 7
            Left = 384
            Top = 277
            Width = 41
            Height = 22
            MaxValue = 48
            MinValue = 6
            TabOrder = 15
            Value = 6
          end
          object showlabelMisc: TCheckBox
            Tag = 7
            Left = 40
            Top = 280
            Width = 209
            Height = 17
            Caption = 'Other labels'
            TabOrder = 16
            OnClick = showlabelClick
          end
          object showlabelConst: TCheckBox
            Tag = 6
            Left = 40
            Top = 248
            Width = 209
            Height = 17
            Caption = 'Constellation name'
            TabOrder = 17
            OnClick = showlabelClick
          end
          object labelsizeConst: TSpinEdit
            Tag = 6
            Left = 384
            Top = 245
            Width = 41
            Height = 22
            MaxValue = 48
            MinValue = 6
            TabOrder = 18
            Value = 6
          end
          object MagLabel: TRadioGroup
            Left = 24
            Top = 320
            Width = 201
            Height = 57
            Caption = 'Star Label'
            Columns = 2
            ItemIndex = 0
            Items.Strings = (
              'Name'
              'Magnitude')
            TabOrder = 19
            OnClick = MagLabelClick
          end
          object constlabel: TRadioGroup
            Left = 240
            Top = 320
            Width = 201
            Height = 57
            Caption = 'Constellation Label'
            Columns = 2
            ItemIndex = 0
            Items.Strings = (
              'Full Name'
              'Abbreviation')
            TabOrder = 20
            OnClick = constlabelClick
          end
        end
        object t_circle: TTabSheet
          Caption = 't_circle'
          ImageIndex = 7
          TabVisible = False
          object Label307: TLabel
            Left = 80
            Top = 8
            Width = 145
            Height = 13
            Caption = 'Finder circle (Eyepiece/Telrad)'
          end
          object cb1: TCheckBox
            Tag = 1
            Left = 24
            Top = 76
            Width = 57
            Height = 17
            Caption = 'No. 1'
            TabOrder = 0
            OnClick = cb1Click
          end
          object cb2: TCheckBox
            Tag = 2
            Left = 24
            Top = 106
            Width = 57
            Height = 17
            Caption = 'No. 2'
            TabOrder = 1
            OnClick = cb1Click
          end
          object cb3: TCheckBox
            Tag = 3
            Left = 24
            Top = 137
            Width = 57
            Height = 17
            Caption = 'No. 3'
            TabOrder = 2
            OnClick = cb1Click
          end
          object cb4: TCheckBox
            Tag = 4
            Left = 24
            Top = 168
            Width = 57
            Height = 17
            Caption = 'No. 4'
            TabOrder = 3
            OnClick = cb1Click
          end
          object cb5: TCheckBox
            Tag = 5
            Left = 24
            Top = 199
            Width = 57
            Height = 17
            Caption = 'No. 5'
            TabOrder = 4
            OnClick = cb1Click
          end
          object cb6: TCheckBox
            Tag = 6
            Left = 24
            Top = 230
            Width = 57
            Height = 17
            Caption = 'No. 6'
            TabOrder = 5
            OnClick = cb1Click
          end
          object cb7: TCheckBox
            Tag = 7
            Left = 24
            Top = 261
            Width = 57
            Height = 17
            Caption = 'No. 7'
            TabOrder = 6
            OnClick = cb1Click
          end
          object cb8: TCheckBox
            Tag = 8
            Left = 24
            Top = 292
            Width = 57
            Height = 17
            Caption = 'No. 8'
            TabOrder = 7
            OnClick = cb1Click
          end
          object cb9: TCheckBox
            Tag = 9
            Left = 24
            Top = 323
            Width = 57
            Height = 17
            Caption = 'No. 9'
            TabOrder = 8
            OnClick = cb1Click
          end
          object cb10: TCheckBox
            Tag = 10
            Left = 24
            Top = 354
            Width = 57
            Height = 17
            Caption = 'No. 10'
            TabOrder = 9
            OnClick = cb1Click
          end
          object Circlegrid: TStringGrid
            Left = 80
            Top = 36
            Width = 380
            Height = 349
            ColCount = 4
            DefaultColWidth = 70
            DefaultRowHeight = 30
            FixedCols = 0
            RowCount = 11
            Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goEditing, goAlwaysShowEditor]
            ScrollBars = ssNone
            TabOrder = 10
            OnSetEditText = CirclegridSetEditText
          end
          object CenterMark1: TCheckBox
            Left = 24
            Top = 392
            Width = 273
            Height = 30
            Caption = 'Mark the chart center '
            TabOrder = 11
            OnClick = CenterMark1Click
          end
        end
        object t_rectangle: TTabSheet
          Caption = 't_rectangle'
          ImageIndex = 8
          TabVisible = False
          object Label308: TLabel
            Left = 80
            Top = 8
            Width = 154
            Height = 13
            Caption = 'Finder rectangle (CCD / Camera)'
          end
          object rb1: TCheckBox
            Tag = 1
            Left = 24
            Top = 74
            Width = 49
            Height = 17
            Caption = 'No. 1'
            TabOrder = 0
            OnClick = rb1Click
          end
          object rb2: TCheckBox
            Tag = 2
            Left = 24
            Top = 105
            Width = 49
            Height = 17
            Caption = 'No. 2'
            TabOrder = 1
            OnClick = rb1Click
          end
          object rb3: TCheckBox
            Tag = 3
            Left = 24
            Top = 136
            Width = 49
            Height = 17
            Caption = 'No. 3'
            TabOrder = 2
            OnClick = rb1Click
          end
          object rb4: TCheckBox
            Tag = 4
            Left = 24
            Top = 167
            Width = 49
            Height = 17
            Caption = 'No. 4'
            TabOrder = 3
            OnClick = rb1Click
          end
          object rb5: TCheckBox
            Tag = 5
            Left = 24
            Top = 198
            Width = 49
            Height = 17
            Caption = 'No. 5'
            TabOrder = 4
            OnClick = rb1Click
          end
          object rb6: TCheckBox
            Tag = 6
            Left = 24
            Top = 230
            Width = 49
            Height = 17
            Caption = 'No. 6'
            TabOrder = 5
            OnClick = rb1Click
          end
          object rb7: TCheckBox
            Tag = 7
            Left = 24
            Top = 261
            Width = 49
            Height = 17
            Caption = 'No. 7'
            TabOrder = 6
            OnClick = rb1Click
          end
          object rb8: TCheckBox
            Tag = 8
            Left = 24
            Top = 292
            Width = 49
            Height = 17
            Caption = 'No. 8'
            TabOrder = 7
            OnClick = rb1Click
          end
          object rb9: TCheckBox
            Tag = 9
            Left = 24
            Top = 323
            Width = 49
            Height = 17
            Caption = 'No. 9'
            TabOrder = 8
            OnClick = rb1Click
          end
          object rb10: TCheckBox
            Tag = 10
            Left = 24
            Top = 355
            Width = 49
            Height = 17
            Caption = 'No10'
            TabOrder = 9
            OnClick = rb1Click
          end
          object RectangleGrid: TStringGrid
            Left = 80
            Top = 36
            Width = 380
            Height = 349
            DefaultColWidth = 60
            DefaultRowHeight = 30
            FixedCols = 0
            RowCount = 11
            Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goEditing, goAlwaysShowEditor]
            ScrollBars = ssNone
            TabOrder = 10
            OnSetEditText = RectangleGridSetEditText
          end
          object CenterMark2: TCheckBox
            Left = 24
            Top = 392
            Width = 273
            Height = 30
            Caption = 'Mark the chart center '
            TabOrder = 11
            OnClick = CenterMark1Click
          end
        end
      end
    end
    object s_images: TTabSheet
      Caption = 's_images'
      ImageIndex = 6
      TabVisible = False
      object pa_images: TPageControl
        Left = 0
        Top = 0
        Width = 482
        Height = 445
        ActivePage = t_images
        Align = alClient
        TabOrder = 0
        object t_images: TTabSheet
          Caption = 't_images'
          TabVisible = False
          object Label50: TLabel
            Left = 0
            Top = 0
            Width = 70
            Height = 13
            Caption = 'Images Setting'
          end
        end
      end
    end
    object s_system: TTabSheet
      Caption = 's_system'
      ImageIndex = 7
      TabVisible = False
      object pa_system: TPageControl
        Left = 0
        Top = 0
        Width = 482
        Height = 445
        ActivePage = t_system
        Align = alClient
        TabOrder = 0
        object t_system: TTabSheet
          Caption = 't_system'
          TabVisible = False
          object Label153: TLabel
            Left = 0
            Top = 0
            Width = 70
            Height = 13
            Caption = 'System Setting'
          end
          object GroupBox6: TGroupBox
            Left = 16
            Top = 26
            Width = 441
            Height = 175
            Caption = 'MySQL  Database'
            TabOrder = 0
            object Label77: TLabel
              Left = 16
              Top = 28
              Width = 49
              Height = 13
              Caption = 'DB Name:'
            end
            object Label84: TLabel
              Left = 168
              Top = 28
              Width = 56
              Height = 13
              Caption = 'Host Name:'
            end
            object Label85: TLabel
              Left = 328
              Top = 28
              Width = 22
              Height = 13
              Caption = 'Port:'
            end
            object Label86: TLabel
              Left = 16
              Top = 68
              Width = 33
              Height = 13
              Caption = 'Userid:'
            end
            object Label133: TLabel
              Left = 208
              Top = 68
              Width = 46
              Height = 13
              Caption = 'Password'
            end
            object dbname: TEdit
              Left = 80
              Top = 24
              Width = 65
              Height = 21
              TabOrder = 0
              Text = 'cdc'
              OnChange = dbnameChange
            end
            object dbport: TLongEdit
              Left = 368
              Top = 26
              Width = 57
              Height = 22
              TabOrder = 1
              OnChange = dbportChange
              Value = 3306
            end
            object dbhost: TEdit
              Left = 240
              Top = 24
              Width = 65
              Height = 21
              TabOrder = 2
              Text = 'dbhost'
              OnChange = dbhostChange
            end
            object dbuser: TEdit
              Left = 80
              Top = 64
              Width = 100
              Height = 21
              TabOrder = 5
              Text = 'dbuser'
              OnChange = dbuserChange
            end
            object dbpass: TEdit
              Left = 272
              Top = 64
              Width = 100
              Height = 21
              PasswordChar = '*'
              TabOrder = 7
              Text = 'dbpass'
              OnChange = dbpassChange
            end
            object chkdb: TButton
              Left = 16
              Top = 104
              Width = 97
              Height = 25
              Caption = 'Check'
              TabOrder = 3
              OnClick = chkdbClick
            end
            object credb: TButton
              Left = 168
              Top = 104
              Width = 97
              Height = 25
              Caption = 'Create Database'
              TabOrder = 4
              OnClick = credbClick
            end
            object dropdb: TButton
              Left = 328
              Top = 104
              Width = 97
              Height = 25
              Caption = 'Drop Database'
              TabOrder = 6
              OnClick = dropdbClick
            end
            object AstDB: TButton
              Left = 16
              Top = 136
              Width = 97
              Height = 25
              Caption = 'Asteroid Setting'
              TabOrder = 8
              OnClick = AstDBClick
            end
            object CometDB: TButton
              Left = 168
              Top = 136
              Width = 97
              Height = 25
              Caption = 'Comet Setting'
              TabOrder = 9
              OnClick = CometDBClick
            end
          end
          object GroupBoxDir: TGroupBox
            Left = 16
            Top = 216
            Width = 441
            Height = 105
            Caption = 'Directory'
            TabOrder = 1
            object Label156: TLabel
              Left = 8
              Top = 24
              Width = 68
              Height = 13
              Caption = 'Program Data '
            end
            object Label157: TLabel
              Left = 8
              Top = 68
              Width = 65
              Height = 13
              Caption = 'Personal data'
            end
            object prgdir: TEdit
              Left = 104
              Top = 20
              Width = 233
              Height = 21
              TabOrder = 0
            end
            object persdir: TEdit
              Left = 104
              Top = 64
              Width = 233
              Height = 21
              TabOrder = 1
            end
            object BitBtn1: TBitBtn
              Tag = 8
              Left = 338
              Top = 17
              Width = 26
              Height = 26
              TabOrder = 2
              TabStop = False
              OnClick = BitBtn1Click
              Glyph.Data = {
                36030000424D3603000000000000360000002800000010000000100000000100
                1800000000000003000000000000000000000000000000000000C0CFCFC0CFCF
                C0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CF
                CFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0
                CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCF
                0000000000000000000000000000000000000000000000000000000000000000
                00C0CFCFC0CFCFC0CFCFC0CFCFC0CFCF7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F
                7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F000000C0CFCFC0CFCFC0CFCFC0CFCF
                7F7F7FFFFFFFC0CFCF00FFFFC0CFCF00FFFFC0CFCF00FFFFC0CFCF00FFFF7F7F
                7F000000C0CFCFC0CFCFC0CFCFC0CFCF7F7F7FFFFFFF00FFFFC0CFCF00FFFFC0
                CFCF00FFFFC0CFCF00FFFFC0CFCF7F7F7F000000C0CFCFC0CFCFC0CFCFC0CFCF
                7F7F7FFFFFFFC0CFCF00FFFFC0CFCF00FFFFC0CFCF00FFFFC0CFCF00FFFF7F7F
                7F000000C0CFCFC0CFCFC0CFCFC0CFCF7F7F7FFFFFFF00FFFFC0CFCF00FFFFC0
                CFCF00FFFFC0CFCF00FFFFC0CFCF7F7F7F000000C0CFCFC0CFCFC0CFCFC0CFCF
                7F7F7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF7F7F
                7F000000C0CFCFC0CFCFC0CFCFC0CFCF7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F
                7F7F7F7F7F7F7F7F7F7F7F7F7F7F000000C0CFCFC0CFCFC0CFCFC0CFCFC0CFCF
                7F7F7F00FFFFFFFFFF00FFFFFFFFFF7F7F7FC0CFCFC0CFCFC0CFCFC0CFCFC0CF
                CFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCF7F7F7F7F7F7F7F7F7F7F7F7FC0
                CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCF
                C0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CF
                CFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0
                CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCF
                C0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CF
                CFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0
                CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCF}
              Layout = blGlyphTop
              Margin = 0
            end
            object BitBtn2: TBitBtn
              Tag = 8
              Left = 338
              Top = 61
              Width = 26
              Height = 26
              TabOrder = 3
              TabStop = False
              OnClick = BitBtn2Click
              Glyph.Data = {
                36030000424D3603000000000000360000002800000010000000100000000100
                1800000000000003000000000000000000000000000000000000C0CFCFC0CFCF
                C0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CF
                CFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0
                CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCF
                0000000000000000000000000000000000000000000000000000000000000000
                00C0CFCFC0CFCFC0CFCFC0CFCFC0CFCF7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F
                7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F000000C0CFCFC0CFCFC0CFCFC0CFCF
                7F7F7FFFFFFFC0CFCF00FFFFC0CFCF00FFFFC0CFCF00FFFFC0CFCF00FFFF7F7F
                7F000000C0CFCFC0CFCFC0CFCFC0CFCF7F7F7FFFFFFF00FFFFC0CFCF00FFFFC0
                CFCF00FFFFC0CFCF00FFFFC0CFCF7F7F7F000000C0CFCFC0CFCFC0CFCFC0CFCF
                7F7F7FFFFFFFC0CFCF00FFFFC0CFCF00FFFFC0CFCF00FFFFC0CFCF00FFFF7F7F
                7F000000C0CFCFC0CFCFC0CFCFC0CFCF7F7F7FFFFFFF00FFFFC0CFCF00FFFFC0
                CFCF00FFFFC0CFCF00FFFFC0CFCF7F7F7F000000C0CFCFC0CFCFC0CFCFC0CFCF
                7F7F7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF7F7F
                7F000000C0CFCFC0CFCFC0CFCFC0CFCF7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F
                7F7F7F7F7F7F7F7F7F7F7F7F7F7F000000C0CFCFC0CFCFC0CFCFC0CFCFC0CFCF
                7F7F7F00FFFFFFFFFF00FFFFFFFFFF7F7F7FC0CFCFC0CFCFC0CFCFC0CFCFC0CF
                CFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCF7F7F7F7F7F7F7F7F7F7F7F7FC0
                CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCF
                C0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CF
                CFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0
                CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCF
                C0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CF
                CFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0
                CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCFC0CFCF}
              Layout = blGlyphTop
              Margin = 0
            end
          end
        end
        object t_server: TTabSheet
          Caption = 't_server'
          ImageIndex = 1
          TabVisible = False
          object GroupBox3: TGroupBox
            Left = 16
            Top = 8
            Width = 393
            Height = 177
            Caption = 'TCP/IP Server'
            TabOrder = 0
            object Label54: TLabel
              Left = 16
              Top = 104
              Width = 95
              Height = 13
              Caption = 'Server IP Interface :'
            end
            object Label55: TLabel
              Left = 16
              Top = 140
              Width = 72
              Height = 13
              Caption = 'Server IP Port :'
            end
            object UseIPserver: TCheckBox
              Left = 16
              Top = 32
              Width = 345
              Height = 30
              Caption = 'Use TCP/IP Server'
              TabOrder = 0
              OnClick = UseIPserverClick
            end
            object ipaddr: TEdit
              Left = 144
              Top = 100
              Width = 100
              Height = 21
              TabOrder = 1
              Text = '127.0.0.1'
              OnChange = ipaddrChange
            end
            object ipport: TEdit
              Left = 144
              Top = 136
              Width = 100
              Height = 21
              TabOrder = 2
              Text = '3292'
              OnChange = ipportChange
            end
            object keepalive: TCheckBox
              Left = 16
              Top = 64
              Width = 345
              Height = 30
              Caption = 'Client Connection Keep Alive'
              TabOrder = 3
              OnClick = keepaliveClick
            end
          end
          object GroupBox4: TGroupBox
            Left = 16
            Top = 200
            Width = 393
            Height = 105
            Caption = 'TCP/IP Server Status'
            TabOrder = 1
            object ipstatus: TEdit
              Left = 16
              Top = 24
              Width = 353
              Height = 21
              TabOrder = 0
              Text = 'ipstatus'
            end
            object refreshIP: TButton
              Left = 144
              Top = 64
              Width = 75
              Height = 25
              Caption = 'Refresh Status'
              TabOrder = 1
              OnClick = refreshIPClick
            end
          end
        end
        object t_telescope: TTabSheet
          Caption = 't_telescope'
          ImageIndex = 2
          TabVisible = False
          object Label13: TLabel
            Left = 0
            Top = 0
            Width = 86
            Height = 13
            Caption = 'Telescope Setting'
          end
          object INDI: TGroupBox
            Left = 8
            Top = 112
            Width = 450
            Height = 257
            Caption = 'INDI Driver setting'
            TabOrder = 0
            object Label75: TLabel
              Left = 8
              Top = 28
              Width = 84
              Height = 13
              Caption = 'INDI Server Host '
            end
            object Label130: TLabel
              Left = 248
              Top = 28
              Width = 76
              Height = 13
              Caption = 'INDI server Port'
            end
            object Label258: TLabel
              Left = 8
              Top = 104
              Width = 108
              Height = 13
              Caption = 'INDI Server command '
            end
            object Label259: TLabel
              Left = 248
              Top = 136
              Width = 82
              Height = 13
              Caption = 'INDI Driver name'
            end
            object Label260: TLabel
              Left = 248
              Top = 104
              Width = 73
              Height = 13
              Caption = 'Telescope type'
            end
            object Label261: TLabel
              Left = 8
              Top = 180
              Width = 59
              Height = 13
              Caption = 'Device Port '
            end
            object IndiServerHost: TEdit
              Left = 120
              Top = 24
              Width = 100
              Height = 21
              TabOrder = 0
              OnChange = IndiServerHostChange
            end
            object IndiServerPort: TEdit
              Left = 336
              Top = 24
              Width = 97
              Height = 21
              TabOrder = 1
              OnChange = IndiServerPortChange
            end
            object IndiAutostart: TCheckBox
              Left = 8
              Top = 64
              Width = 401
              Height = 30
              Caption = 'Automatically start a local server if not already running'
              TabOrder = 3
              OnClick = IndiAutostartClick
            end
            object IndiServerCmd: TEdit
              Left = 120
              Top = 100
              Width = 100
              Height = 21
              TabOrder = 5
              OnChange = IndiServerCmdChange
            end
            object IndiDriver: TEdit
              Left = 336
              Top = 132
              Width = 100
              Height = 21
              Enabled = False
              TabOrder = 2
              OnChange = IndiDriverChange
            end
            object IndiDev: TComboBox
              Left = 336
              Top = 100
              Width = 100
              Height = 21
              Style = csDropDownList
              ItemHeight = 13
              ItemIndex = 0
              TabOrder = 4
              OnChange = IndiDevChange
              Items.Strings = (
                '')
            end
            object IndiPort: TComboBox
              Left = 120
              Top = 176
              Width = 100
              Height = 21
              Style = csDropDownList
              ItemHeight = 13
              TabOrder = 6
              OnChange = IndiPortChange
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
          end
          object TelescopeSelect: TRadioGroup
            Left = 8
            Top = 32
            Width = 450
            Height = 65
            Caption = 'TelescopeSelect'
            Columns = 2
            ItemIndex = 0
            Items.Strings = (
              'INDI'
              'CDC plugin')
            TabOrder = 1
            OnClick = TelescopeSelectClick
          end
          object TelescopePlugin: TGroupBox
            Left = 8
            Top = 112
            Width = 450
            Height = 105
            Caption = 'CDC plugin setting'
            TabOrder = 2
            object Label155: TLabel
              Left = 24
              Top = 46
              Width = 85
              Height = 13
              Caption = 'Telescope Plugin '
            end
            object telescopepluginlist: TComboBox
              Left = 144
              Top = 42
              Width = 145
              Height = 21
              Style = csDropDownList
              ItemHeight = 13
              TabOrder = 0
              OnChange = telescopepluginlistChange
            end
          end
        end
      end
    end
  end
  object FontDialog1: TFontDialog
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    MinFontSize = 0
    MaxFontSize = 0
    Options = []
    Left = 8
    Top = 384
  end
  object FolderDialog1: TFolderDialog
    Top = 384
    Left = 72
    Title = 'Browse for Folder'
  end
  object OpenDialog1: TOpenDialog
    Left = 40
    Top = 384
  end
  object ColorDialog1: TColorDialog
    Ctl3D = True
    Left = 104
    Top = 384
  end
end
