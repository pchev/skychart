object f_config_chart: Tf_config_chart
  Left = 0
  Top = 0
  Width = 490
  Height = 440
  TabOrder = 0
  object pa_chart: TPageControl
    Left = 0
    Top = 0
    Width = 490
    Height = 440
    ActivePage = t_filter
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
          Height = 21
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
          Top = 41
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
        object BigNebUnit: TLabel
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
