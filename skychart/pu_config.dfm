object f_config: Tf_config
  Left = 285
  Top = 96
  Width = 634
  Height = 507
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
    Top = 0
    Width = 136
    Height = 441
    HideSelection = False
    Indent = 19
    ReadOnly = True
    TabOrder = 0
    OnChange = TreeView1Change
    Items.Data = {
      08000000250000000000000000000000FFFFFFFF000000000000000001000000
      0C312D20446174652F54696D652B0000000000000000000000A0A97541000000
      00000000000000000012312D2054696D652053696D756C6174696F6E27000000
      FFFFFFFFFFFFFFFFA0A975410000000000000000000000000E322D204F627365
      727661746F72792E0000000000000000000000A0A97541000000000000000004
      00000015332D2043686172742C20436F6F7264696E617465732B000000000000
      0000000000A0A9754100000000000000000000000012312D204669656C64206F
      6620766973696F6E260000000000000000000000A0A975410000000000000000
      000000000D322D2050726F6A656374696F6E290000000000000000000000A0A9
      754100000000000000000000000010332D204F626A6563742046696C74657228
      000000FFFFFFFFFFFFFFFFA0A975410000000000000000000000000F342D2047
      7269642053706163696E67260000000000000000000000A0A975410000000000
      000000020000000D342D20436174616C6F677565732B00000000000000000000
      00A0A9754100000000000000000000000012312D20436174616C6F6720536574
      74696E672D0000000000000000000000A0A97541000000000000000003000000
      14322D2043444320636F6D7061746962696C6974792100000000000000000000
      00A0A9754100000000000000000000000008312D205374617273230000000000
      000000000000A0A975410000000000000000000000000A322D204E6562756C61
      65240000000000000000000000A0A975410000000000000000000000000B332D
      2045787465726E616C280000000000000000000000A0A9754100000000000000
      00030000000F352D20536F6C61722053797374656D2300000000000000000000
      00A0A975410000000000000000000000000A312D20506C616E65747322000000
      0000000000000000A0A9754100000000000000000000000009322D20436F6D65
      7473250000000000000000000000A0A975410000000000000000000000000C33
      2D2041737465726F696473230000000000000000000000A0A975410000000000
      000000040000000A362D20446973706C6179210000000000000000000000A0A9
      754100000000000000000000000008312D20466F6E7473210000000000000000
      000000A0A9754100000000000000000200000008322D20436F6C6F7230000000
      FFFFFFFFFFFFFFFFA0A9754100000000000000000000000017312D20536B7920
      4261636B67726F756E6420436F6C6F7232000000FFFFFFFFFFFFFFFFA0A97541
      00000000000000000000000019322D205374617220616E64204E6562756C6165
      20436F6C6F72210000000000000000000000A0A9754100000000000000000000
      000008332D204C696E6573220000000000000000000000A0A975410000000000
      0000000000000009342D204C6162656C73220000000000000000000000A0A975
      4100000000000000000000000009372D20496D6167657322000000FFFFFFFFFF
      FFFFFFA0A9754100000000000000000100000009382D2053797374656D220000
      00FFFFFFFFFFFFFFFFA0A9754100000000000000000000000009312D20536572
      766572}
  end
  object PageControl1: TPageControl
    Left = 144
    Top = 0
    Width = 474
    Height = 441
    ActivePage = p_observatory
    TabOrder = 1
    OnChange = PageControl1Change
    object p_time: TTabSheet
      Caption = 'p_time'
      ImageIndex = 19
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
      object Panel11: TPanel
        Left = 32
        Top = 104
        Width = 409
        Height = 105
        TabOrder = 6
        object Label155: TLabel
          Left = 8
          Top = 22
          Width = 23
          Height = 13
          Caption = 'Date'
        end
        object Label156: TLabel
          Left = 8
          Top = 46
          Width = 23
          Height = 13
          Caption = 'Time'
        end
        object Label157: TLabel
          Left = 8
          Top = 70
          Width = 51
          Height = 13
          Caption = 'Time Zone'
        end
        object LabelDate: TLabel
          Left = 80
          Top = 22
          Width = 49
          Height = 13
          Caption = 'LabelDate'
        end
        object LabelTime: TLabel
          Left = 80
          Top = 46
          Width = 49
          Height = 13
          Caption = 'LabelTime'
        end
        object LabelTimezone: TLabel
          Left = 80
          Top = 70
          Width = 72
          Height = 13
          Caption = 'LabelTimezone'
        end
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
    end
    object p_simulation: TTabSheet
      Caption = 'p_simulation'
      ImageIndex = 20
      TabVisible = False
      object Label146: TLabel
        Left = 0
        Top = 0
        Width = 110
        Height = 13
        Caption = 'Time Simulation Setting'
      end
      object SpeedButton7: TSpeedButton
        Left = 256
        Top = 228
        Width = 145
        Height = 25
        Caption = 'Reset to single date'
        Layout = blGlyphTop
        NumGlyphs = 2
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
    object p_observatory: TTabSheet
      Caption = 'p_observatory'
      ImageIndex = 27
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
        Zoom = 1
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
    object p_chart: TTabSheet
      Caption = 'p_chart'
      ImageIndex = 14
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
    object p_fov: TTabSheet
      Caption = 'p_fov'
      ImageIndex = 15
      TabVisible = False
      object Bevel1: TBevel
        Left = 16
        Top = 48
        Width = 177
        Height = 225
        Shape = bsFrame
      end
      object Bevel2: TBevel
        Left = 208
        Top = 48
        Width = 177
        Height = 225
        Shape = bsFrame
      end
      object Label30: TLabel
        Left = 0
        Top = 0
        Width = 101
        Height = 13
        Caption = 'Field of Vision Setting'
      end
      object Label96: TLabel
        Left = 80
        Top = 147
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
      object Label97: TLabel
        Left = 80
        Top = 176
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
      object Label98: TLabel
        Left = 80
        Top = 205
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
      object Label99: TLabel
        Left = 80
        Top = 234
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
      object Label100: TLabel
        Left = 272
        Top = 90
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
      object Label101: TLabel
        Left = 272
        Top = 118
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
      object Label102: TLabel
        Left = 272
        Top = 147
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
      object Label103: TLabel
        Left = 272
        Top = 176
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
      object Label104: TLabel
        Left = 272
        Top = 205
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
      object Label105: TLabel
        Left = 264
        Top = 234
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
      object Label106: TLabel
        Left = 29
        Top = 64
        Width = 62
        Height = 13
        Alignment = taRightJustify
        Caption = 'Field Number'
      end
      object Label107: TLabel
        Left = 120
        Top = 64
        Width = 53
        Height = 13
        Caption = 'Field Width'
      end
      object Label114: TLabel
        Left = 80
        Top = 118
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
      object Label153: TLabel
        Left = 221
        Top = 64
        Width = 62
        Height = 13
        Alignment = taRightJustify
        Caption = 'Field Number'
      end
      object Label154: TLabel
        Left = 312
        Top = 64
        Width = 53
        Height = 13
        Caption = 'Field Width'
      end
      object fw1: TFloatEdit
        Tag = 1
        Left = 120
        Top = 144
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
        Left = 120
        Top = 173
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
        Left = 120
        Top = 202
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
        Left = 120
        Top = 231
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
        Left = 312
        Top = 87
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
        Left = 312
        Top = 115
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
        Left = 312
        Top = 144
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
        Left = 312
        Top = 173
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
        Left = 312
        Top = 202
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
        Left = 312
        Top = 231
        Width = 40
        Height = 22
        Hint = '0..360'
        TabStop = False
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
        Left = 120
        Top = 115
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
        Left = 120
        Top = 87
        Width = 40
        Height = 22
        Hint = '0..360'
        TabStop = False
        Color = clBtnFace
        ParentShowHint = False
        ReadOnly = True
        ShowHint = True
        TabOrder = 11
        MaxValue = 360
        NumericType = ntFixed
      end
    end
    object p_projection: TTabSheet
      Tag = 1
      Caption = 'p_projection'
      ImageIndex = 21
      ParentShowHint = False
      ShowHint = True
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
    object p_filter: TTabSheet
      Caption = 'p_filter'
      ImageIndex = 16
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
              Tag = 1
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
              Tag = 2
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
              Tag = 3
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
              Tag = 4
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
              Tag = 5
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
              Tag = 6
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
              Tag = 7
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
              Tag = 8
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
              Tag = 9
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
            Tag = 1
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
            Tag = 2
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
            Tag = 3
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
            Tag = 4
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
            Tag = 5
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
            Tag = 6
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
            Tag = 1
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
            Tag = 2
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
            Tag = 3
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
            Tag = 4
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
            Tag = 5
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
            Tag = 6
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
            Tag = 7
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
            Tag = 8
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
            Tag = 9
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
            Tag = 7
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
            Tag = 8
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
            Tag = 9
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
    object p_gridspacing: TTabSheet
      Caption = 'p_gridspacing'
      ImageIndex = 22
      TabVisible = False
      object Bevel9: TBevel
        Left = 8
        Top = 24
        Width = 377
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
        Width = 90
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
        Width = 90
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
        Width = 90
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
        Width = 90
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
        Width = 90
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
        Width = 90
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
        Width = 90
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
        Width = 90
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
        Width = 90
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
        Width = 90
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
        Width = 90
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
        Width = 90
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
        Width = 90
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
        Width = 90
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
        Width = 90
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
        Width = 90
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
        Width = 90
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
        Width = 90
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
        Width = 90
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
        Width = 90
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
        Width = 90
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
    object p_catalog: TTabSheet
      Caption = 'p_catalog'
      ImageIndex = 10
      TabVisible = False
      object Label11: TLabel
        Left = 0
        Top = 0
        Width = 72
        Height = 13
        Caption = 'Catalog Setting'
      end
    end
    object p_catgen: TTabSheet
      Caption = 'p_catgen'
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
    object p_cdc: TTabSheet
      Caption = 'p_cdc'
      ImageIndex = 12
      TabVisible = False
      object Label13: TLabel
        Left = 0
        Top = 0
        Width = 97
        Height = 13
        Caption = 'CDC Catalog Setting'
      end
      object Label130: TLabel
        Left = 56
        Top = 72
        Width = 305
        Height = 153
        Alignment = taCenter
        AutoSize = False
        Caption = 
          'Use this pages to define the catalogues compatible with the prev' +
          'ious version of Cartes du Ciel'
        WordWrap = True
      end
    end
    object p_cdcstars: TTabSheet
      Caption = 'p_cdcstars'
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
      object Label67: TLabel
        Left = 72
        Top = 85
        Width = 14
        Height = 13
        Caption = 'pm'
      end
      object Label87: TLabel
        Left = 72
        Top = 108
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
        Top = 37
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
        Top = 272
        Width = 43
        Height = 13
        Caption = 'Variables'
      end
      object Label20: TLabel
        Left = 8
        Top = 303
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
      object BitBtn11: TBitBtn
        Tag = 3
        Left = 439
        Top = 82
        Width = 19
        Height = 19
        TabOrder = 10
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
      object tyc3: TEdit
        Tag = 3
        Left = 330
        Top = 82
        Width = 111
        Height = 19
        Ctl3D = False
        ParentCtl3D = False
        TabOrder = 11
        Text = 'tyc3'
        OnChange = CDCStarPathChange
      end
      object Ftyc2: TLongEdit
        Tag = 3
        Left = 296
        Top = 80
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
      object Ftyc1: TLongEdit
        Tag = 3
        Left = 256
        Top = 80
        Width = 30
        Height = 22
        Hint = '0..10'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 13
        OnChange = CDCStarField1Change
        Value = 0
        MaxValue = 10
      end
      object TYCbox: TCheckBox
        Tag = 3
        Left = 96
        Top = 83
        Width = 137
        Height = 17
        Hint = 'The Tycho Catalogue (ESA 1997)'
        HelpContext = 102
        Caption = 'Tycho Catalog'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 14
        OnClick = CDCStarSelClick
      end
      object TY2Box: TCheckBox
        Tag = 4
        Left = 96
        Top = 106
        Width = 137
        Height = 17
        Hint = 'The Tycho-2 Catalogue (Hog+ 2000)'
        HelpContext = 102
        Caption = 'Tycho 2 Catalog'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 15
        OnClick = CDCStarSelClick
      end
      object TICbox: TCheckBox
        Tag = 5
        Left = 96
        Top = 130
        Width = 137
        Height = 17
        Hint = 'Tycho Input Catalog  (Revised Version) (Egret+ 1992)'
        HelpContext = 103
        Caption = 'Tycho  Input Catalog'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 16
        OnClick = CDCStarSelClick
      end
      object Ftic1: TLongEdit
        Tag = 5
        Left = 256
        Top = 127
        Width = 30
        Height = 22
        Hint = '0..10'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 17
        OnChange = CDCStarField1Change
        Value = 0
        MaxValue = 10
      end
      object Fty21: TLongEdit
        Tag = 4
        Left = 256
        Top = 103
        Width = 30
        Height = 22
        Hint = '0..10'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 18
        OnChange = CDCStarField1Change
        Value = 0
        MaxValue = 10
      end
      object Fty22: TLongEdit
        Tag = 4
        Left = 296
        Top = 103
        Width = 30
        Height = 22
        Hint = '0..10'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 19
        OnChange = CDCStarField2Change
        Value = 10
        MaxValue = 10
      end
      object Ftic2: TLongEdit
        Tag = 5
        Left = 296
        Top = 127
        Width = 30
        Height = 22
        Hint = '0..10'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 20
        OnChange = CDCStarField2Change
        Value = 7
        MaxValue = 10
      end
      object ty23: TEdit
        Tag = 4
        Left = 330
        Top = 105
        Width = 111
        Height = 19
        Ctl3D = False
        ParentCtl3D = False
        TabOrder = 21
        Text = 'cat\tycho2'
        OnChange = CDCStarPathChange
      end
      object tic3: TEdit
        Tag = 5
        Left = 330
        Top = 129
        Width = 111
        Height = 19
        Ctl3D = False
        ParentCtl3D = False
        TabOrder = 22
        Text = 'tic3'
        OnChange = CDCStarPathChange
      end
      object BitBtn13: TBitBtn
        Tag = 5
        Left = 439
        Top = 129
        Width = 19
        Height = 19
        TabOrder = 23
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
      object BitBtn12: TBitBtn
        Tag = 4
        Left = 439
        Top = 105
        Width = 19
        Height = 19
        TabOrder = 24
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
        Top = 153
        Width = 153
        Height = 17
        Hint = 
          'The Hubble Space Telescope Guide Star Catalog  ( Lasker 1990)  o' +
          'riginal FITS CDROM'
        HelpContext = 104
        Caption = 'HST GSC original FITS'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 25
        OnClick = CDCStarSelClick
      end
      object GSCCbox: TCheckBox
        Tag = 7
        Left = 96
        Top = 177
        Width = 137
        Height = 17
        Hint = 
          'The Hubble Space Telescope Guide Star Catalog  ( Lasker 1990)  C' +
          'ompact CDS version '
        HelpContext = 104
        Caption = 'HST GSC compact'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 26
        OnClick = CDCStarSelClick
      end
      object GSCbox: TCheckBox
        Tag = 8
        Left = 96
        Top = 200
        Width = 153
        Height = 17
        Hint = 'The Hubble Space Telescope Guide Star Catalog  ( Lasker 1990)'
        HelpContext = 104
        Caption = 'HST Guide Star Catalog'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 27
        OnClick = CDCStarSelClick
      end
      object USNbox: TCheckBox
        Tag = 9
        Left = 96
        Top = 224
        Width = 65
        Height = 17
        Hint = 
          '- USNO-SA1.0 '#13#10'- USNO-A1.0 '#13#10'- USNO-A2.0'#13#10'  U.S. Naval Observato' +
          'ry CDROM'#39's'
        HelpContext = 113
        Caption = 'USNO-A'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 28
        OnClick = CDCStarSelClick
      end
      object MCTBox: TCheckBox
        Tag = 10
        Left = 96
        Top = 247
        Width = 137
        Height = 17
        Hint = 'AUDE MicroCat CDROM'
        HelpContext = 113
        Caption = 'AUDE MicroCat'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 29
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
        TabOrder = 30
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
        TabOrder = 31
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
        TabOrder = 32
        OnClick = CDCStarSelClick
      end
      object USNBright: TCheckBox
        Tag = 9
        Left = 168
        Top = 224
        Width = 81
        Height = 17
        Caption = 'Bright stars'
        TabOrder = 33
        OnClick = USNBrightClick
      end
      object fgscf1: TLongEdit
        Tag = 6
        Left = 256
        Top = 150
        Width = 30
        Height = 22
        Hint = '0..10'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 34
        OnChange = CDCStarField1Change
        Value = 0
        MaxValue = 10
      end
      object fgscc1: TLongEdit
        Tag = 7
        Left = 256
        Top = 174
        Width = 30
        Height = 22
        Hint = '0..10'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 35
        OnChange = CDCStarField1Change
        Value = 0
        MaxValue = 10
      end
      object fgsc1: TLongEdit
        Tag = 8
        Left = 256
        Top = 197
        Width = 30
        Height = 22
        Hint = '0..10'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 36
        OnChange = CDCStarField1Change
        Value = 0
        MaxValue = 10
      end
      object fusn1: TLongEdit
        Tag = 9
        Left = 256
        Top = 221
        Width = 30
        Height = 22
        Hint = '0..10'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 37
        OnChange = CDCStarField1Change
        Value = 0
        MaxValue = 10
      end
      object fmct1: TLongEdit
        Tag = 10
        Left = 256
        Top = 244
        Width = 30
        Height = 22
        Hint = '0..10'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 38
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
        TabOrder = 39
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
        TabOrder = 40
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
        TabOrder = 41
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
        TabOrder = 42
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
        TabOrder = 43
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
        TabOrder = 44
        OnChange = CDCStarField2Change
        Value = 10
        MaxValue = 10
      end
      object fmct2: TLongEdit
        Tag = 10
        Left = 296
        Top = 244
        Width = 30
        Height = 22
        Hint = '0..10'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 45
        OnChange = CDCStarField2Change
        Value = 2
        MaxValue = 10
      end
      object fusn2: TLongEdit
        Tag = 9
        Left = 296
        Top = 221
        Width = 30
        Height = 22
        Hint = '0..10'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 46
        OnChange = CDCStarField2Change
        Value = 2
        MaxValue = 10
      end
      object fgsc2: TLongEdit
        Tag = 8
        Left = 296
        Top = 197
        Width = 30
        Height = 22
        Hint = '0..10'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 47
        OnChange = CDCStarField2Change
        Value = 2
        MaxValue = 10
      end
      object fgscc2: TLongEdit
        Tag = 7
        Left = 296
        Top = 174
        Width = 30
        Height = 22
        Hint = '0..10'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 48
        OnChange = CDCStarField2Change
        Value = 2
        MaxValue = 10
      end
      object fgscf2: TLongEdit
        Tag = 6
        Left = 296
        Top = 150
        Width = 30
        Height = 22
        Hint = '0..10'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 49
        OnChange = CDCStarField2Change
        Value = 2
        MaxValue = 10
      end
      object gscf3: TEdit
        Tag = 6
        Left = 330
        Top = 152
        Width = 111
        Height = 19
        Ctl3D = False
        ParentCtl3D = False
        TabOrder = 50
        Text = 'gscf3'
        OnChange = CDCStarPathChange
      end
      object gscc3: TEdit
        Tag = 7
        Left = 330
        Top = 176
        Width = 111
        Height = 19
        Ctl3D = False
        ParentCtl3D = False
        TabOrder = 51
        Text = 'gscc3'
        OnChange = CDCStarPathChange
      end
      object gsc3: TEdit
        Tag = 8
        Left = 330
        Top = 199
        Width = 111
        Height = 19
        Ctl3D = False
        ParentCtl3D = False
        TabOrder = 52
        Text = 'gsc3'
        OnChange = CDCStarPathChange
      end
      object usn3: TEdit
        Tag = 9
        Left = 330
        Top = 223
        Width = 111
        Height = 19
        Ctl3D = False
        ParentCtl3D = False
        TabOrder = 53
        Text = 'usn3'
        OnChange = CDCStarPathChange
      end
      object mct3: TEdit
        Tag = 10
        Left = 330
        Top = 246
        Width = 111
        Height = 19
        Ctl3D = False
        ParentCtl3D = False
        TabOrder = 54
        Text = 'x:\'
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
        TabOrder = 55
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
        TabOrder = 56
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
        TabOrder = 57
        Text = 'dsgsc3'
        OnChange = CDCStarPathChange
      end
      object BitBtn22: TBitBtn
        Tag = 13
        Left = 439
        Top = 372
        Width = 19
        Height = 19
        TabOrder = 58
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
        TabOrder = 59
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
        TabOrder = 60
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
      object BitBtn32: TBitBtn
        Tag = 10
        Left = 439
        Top = 246
        Width = 19
        Height = 19
        TabOrder = 61
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
        Top = 223
        Width = 19
        Height = 19
        TabOrder = 62
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
      object BitBtn18: TBitBtn
        Tag = 8
        Left = 439
        Top = 199
        Width = 19
        Height = 19
        TabOrder = 63
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
        Top = 176
        Width = 19
        Height = 19
        TabOrder = 64
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
        Top = 152
        Width = 19
        Height = 19
        TabOrder = 65
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
        Top = 270
        Width = 19
        Height = 19
        TabOrder = 66
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
        Top = 301
        Width = 19
        Height = 19
        TabOrder = 67
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
        Top = 301
        Width = 111
        Height = 19
        Ctl3D = False
        ParentCtl3D = False
        TabOrder = 68
        Text = 'wds3'
        OnChange = wds3Change
      end
      object gcv3: TEdit
        Tag = 1
        Left = 330
        Top = 270
        Width = 111
        Height = 19
        Ctl3D = False
        ParentCtl3D = False
        TabOrder = 69
        Text = 'gcv3'
        OnChange = gcv3Change
      end
      object Fgcv2: TLongEdit
        Tag = 1
        Left = 296
        Top = 268
        Width = 30
        Height = 22
        Hint = '0..10'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 70
        OnChange = Fgcv2Change
        Value = 10
        MaxValue = 10
      end
      object Fwds2: TLongEdit
        Tag = 1
        Left = 296
        Top = 299
        Width = 30
        Height = 22
        Hint = '0..10'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 71
        OnChange = Fwds2Change
        Value = 10
        MaxValue = 10
      end
      object Fwds1: TLongEdit
        Tag = 1
        Left = 256
        Top = 299
        Width = 30
        Height = 22
        Hint = '0..10'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 72
        OnChange = Fwds1Change
        Value = 0
        MaxValue = 10
      end
      object Fgcv1: TLongEdit
        Tag = 1
        Left = 256
        Top = 268
        Width = 30
        Height = 22
        Hint = '0..10'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 73
        OnChange = Fgcv1Change
        Value = 0
        MaxValue = 10
      end
      object GCVBox: TCheckBox
        Tag = 1
        Left = 96
        Top = 271
        Width = 137
        Height = 17
        Hint = 'General Catalog of Variable Stars    (Kholopov+ 1998)'
        HelpContext = 105
        Caption = 'Gen. Cat. Variable Star'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 74
        OnClick = GCVBoxClick
      end
      object IRVar: TCheckBox
        Tag = 1
        Left = 96
        Top = 286
        Width = 81
        Height = 17
        Caption = 'IR variables'
        TabOrder = 75
        OnClick = IRVarClick
      end
      object WDSbox: TCheckBox
        Tag = 1
        Left = 96
        Top = 302
        Width = 153
        Height = 17
        Hint = 'The Washington Visual Double Star Catalog    (USNO, 2000)'
        HelpContext = 106
        Caption = 'Washington Double Star'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 76
        OnClick = WDSboxClick
      end
    end
    object p_cdcneb: TTabSheet
      Caption = 'p_cdcneb'
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
    object p_external: TTabSheet
      Caption = 'p_external'
      ImageIndex = 3
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
    object p_solsys: TTabSheet
      Caption = 'p_solsys'
      ImageIndex = 11
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
      object planet3: TEdit
        Left = 104
        Top = 59
        Width = 113
        Height = 21
        TabOrder = 1
        Text = '~/'
      end
      object BitBtn31: TBitBtn
        Left = 216
        Top = 59
        Width = 26
        Height = 26
        TabOrder = 2
        TabStop = False
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
    object p_planets: TTabSheet
      Caption = 'p_planets'
      ImageIndex = 4
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
    object p_comets: TTabSheet
      Caption = 'p_comets'
      ImageIndex = 5
      TabVisible = False
      object Label6: TLabel
        Left = 0
        Top = 0
        Width = 71
        Height = 13
        Caption = 'Comets Setting'
      end
    end
    object p_asteroids: TTabSheet
      Caption = 'p_asteroids'
      ImageIndex = 6
      TabVisible = False
      object Label7: TLabel
        Left = 0
        Top = 0
        Width = 79
        Height = 13
        Caption = 'Asteroids Setting'
      end
    end
    object p_display: TTabSheet
      Caption = 'p_display'
      ImageIndex = 13
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
        Top = 48
        Width = 441
        Height = 65
        Caption = 'Star Display'
        Columns = 2
        Items.Strings = (
          'Line mode'
          'Graphic')
        TabOrder = 0
        OnClick = stardisplayClick
      end
      object nebuladisplay: TRadioGroup
        Left = 8
        Top = 128
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
    end
    object p_fonts: TTabSheet
      Caption = 'p_fonts'
      ImageIndex = 18
      TabVisible = False
      object Bevel10: TBevel
        Left = 8
        Top = 32
        Width = 393
        Height = 281
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
        Top = 328
        Width = 75
        Height = 25
        Caption = 'Default'
        TabOrder = 6
        OnClick = DefaultFontClick
      end
    end
    object p_color: TTabSheet
      Caption = 'p_color'
      ImageIndex = 7
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
        Top = 30
        Width = 18
        Height = 13
        Caption = '-0.3'
      end
      object Label182: TLabel
        Left = 147
        Top = 30
        Width = 18
        Height = 13
        Caption = '-0.1'
      end
      object Label183: TLabel
        Left = 201
        Top = 30
        Width = 15
        Height = 13
        Caption = '0.2'
      end
      object Label184: TLabel
        Left = 254
        Top = 30
        Width = 15
        Height = 13
        Caption = '0.5'
      end
      object Label185: TLabel
        Left = 308
        Top = 30
        Width = 15
        Height = 13
        Caption = '0.8'
      end
      object Label186: TLabel
        Left = 362
        Top = 30
        Width = 15
        Height = 13
        Caption = '1.3'
      end
      object Label187: TLabel
        Left = 416
        Top = 30
        Width = 6
        Height = 13
        Caption = '>'
      end
      object Label188: TLabel
        Left = 40
        Top = 30
        Width = 6
        Height = 13
        Caption = '<'
      end
      object Label189: TLabel
        Left = 8
        Top = 30
        Width = 20
        Height = 13
        Caption = 'B-V:'
      end
      object Label190: TLabel
        Left = 56
        Top = 118
        Width = 32
        Height = 13
        Alignment = taCenter
        Caption = 'Galaxy'
      end
      object Label191: TLabel
        Left = 120
        Top = 118
        Width = 32
        Height = 13
        Alignment = taCenter
        Caption = 'Cluster'
      end
      object Label192: TLabel
        Left = 185
        Top = 118
        Width = 34
        Height = 13
        Alignment = taCenter
        Caption = 'Nebula'
      end
      object Label193: TLabel
        Left = 248
        Top = 118
        Width = 34
        Height = 13
        Alignment = taCenter
        Caption = 'Az Grid'
      end
      object Label194: TLabel
        Left = 307
        Top = 118
        Width = 35
        Height = 13
        Alignment = taCenter
        Caption = 'Eq Grid'
      end
      object Label195: TLabel
        Left = 380
        Top = 118
        Width = 22
        Height = 13
        Alignment = taCenter
        Caption = 'Orbit'
      end
      object Label197: TLabel
        Left = 32
        Top = 206
        Width = 92
        Height = 13
        Alignment = taCenter
        Caption = 'Constellation Figure'
      end
      object Label198: TLabel
        Left = 144
        Top = 206
        Width = 108
        Height = 13
        Alignment = taCenter
        Caption = 'Constellation Boundary'
      end
      object Label199: TLabel
        Left = 272
        Top = 206
        Width = 73
        Height = 13
        Alignment = taCenter
        Caption = 'Eyepiece Circle'
      end
      object Label196: TLabel
        Left = 370
        Top = 206
        Width = 53
        Height = 13
        Alignment = taCenter
        Caption = 'Misc. Lines'
      end
      object bg1: TPanel
        Left = 32
        Top = 48
        Width = 401
        Height = 57
        TabOrder = 0
        OnClick = bgClick
        object Shape1: TShape
          Tag = 1
          Left = 24
          Top = 16
          Width = 30
          Height = 30
          Shape = stCircle
          OnMouseUp = ShapeMouseUp
        end
        object Shape2: TShape
          Tag = 2
          Left = 77
          Top = 16
          Width = 30
          Height = 30
          Shape = stCircle
          OnMouseUp = ShapeMouseUp
        end
        object Shape3: TShape
          Tag = 3
          Left = 130
          Top = 16
          Width = 30
          Height = 30
          Shape = stCircle
          OnMouseUp = ShapeMouseUp
        end
        object Shape4: TShape
          Tag = 4
          Left = 184
          Top = 16
          Width = 30
          Height = 30
          Shape = stCircle
          OnMouseUp = ShapeMouseUp
        end
        object Shape5: TShape
          Tag = 5
          Left = 237
          Top = 16
          Width = 30
          Height = 30
          Shape = stCircle
          OnMouseUp = ShapeMouseUp
        end
        object Shape6: TShape
          Tag = 6
          Left = 290
          Top = 16
          Width = 30
          Height = 30
          Shape = stCircle
          OnMouseUp = ShapeMouseUp
        end
        object Shape7: TShape
          Tag = 7
          Left = 344
          Top = 16
          Width = 30
          Height = 30
          Shape = stCircle
          OnMouseUp = ShapeMouseUp
        end
      end
      object bg2: TPanel
        Left = 32
        Top = 136
        Width = 401
        Height = 57
        TabOrder = 1
        OnClick = bgClick
        object Shape8: TShape
          Tag = 8
          Left = 24
          Top = 20
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
          Top = 16
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
          Top = 16
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
          Top = 16
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
          Top = 16
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
          Top = 16
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
        Top = 224
        Width = 401
        Height = 57
        TabOrder = 2
        OnClick = bgClick
        object Shape15: TShape
          Tag = 16
          Left = 32
          Top = 16
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
          Left = 146
          Top = 16
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
          Left = 261
          Top = 16
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
          Left = 344
          Top = 16
          Width = 30
          Height = 30
          Brush.Style = bsClear
          Pen.Color = clWhite
          Pen.Width = 3
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
    end
    object p_skycolor: TTabSheet
      Caption = 'p_skycolor'
      ImageIndex = 23
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
    object p_nebcolor: TTabSheet
      Caption = 'p_nebcolor'
      ImageIndex = 24
      TabVisible = False
      object Label201: TLabel
        Left = 0
        Top = 0
        Width = 103
        Height = 13
        Caption = 'Nebulae Color Setting'
      end
    end
    object p_lines: TTabSheet
      Caption = 'p_lines'
      ImageIndex = 8
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
    object p_labels: TTabSheet
      Caption = 'p_labels'
      ImageIndex = 9
      TabVisible = False
      object Label10: TLabel
        Left = 0
        Top = 0
        Width = 67
        Height = 13
        Caption = 'Labels Setting'
      end
    end
    object p_image: TTabSheet
      Caption = 'p_image'
      ImageIndex = 17
      TabVisible = False
      object Label50: TLabel
        Left = 0
        Top = 0
        Width = 70
        Height = 13
        Caption = 'Images Setting'
      end
    end
    object p_system: TTabSheet
      Caption = 'p_system'
      ImageIndex = 25
      TabVisible = False
    end
    object p_server: TTabSheet
      Caption = 'p_server'
      ImageIndex = 26
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
  end
  object CancelBtn: TButton
    Left = 462
    Top = 448
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 2
  end
  object OKBtn: TButton
    Left = 302
    Top = 448
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 3
  end
  object HelpBtn: TButton
    Left = 542
    Top = 448
    Width = 75
    Height = 25
    Caption = '&Help'
    TabOrder = 4
  end
  object Applyall: TCheckBox
    Left = 120
    Top = 452
    Width = 177
    Height = 17
    Caption = 'Apply Change To All Chart'
    Checked = True
    State = cbChecked
    TabOrder = 5
  end
  object next: TButton
    Left = 32
    Top = 448
    Width = 25
    Height = 25
    Caption = '>'
    TabOrder = 6
    OnClick = nextClick
  end
  object previous: TButton
    Left = 8
    Top = 448
    Width = 25
    Height = 25
    Caption = '<'
    TabOrder = 7
    OnClick = previousClick
  end
  object Button2: TButton
    Left = 382
    Top = 448
    Width = 75
    Height = 25
    Caption = 'Apply'
    TabOrder = 8
    OnClick = Button2Click
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
