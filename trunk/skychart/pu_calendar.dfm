object f_calendar: Tf_calendar
  Left = 339
  Top = 112
  Width = 635
  Height = 413
  Caption = 'f_calendar'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object memo1: TRichEdit
    Left = 16
    Top = 8
    Width = 185
    Height = 89
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Courier'
    Font.Pitch = fpFixed
    Font.Style = []
    Lines.Strings = (
      'memo1')
    ParentFont = False
    TabOrder = 2
    WordWrap = False
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 627
    Height = 70
    Align = alTop
    TabOrder = 1
    object Label1: TLabel
      Left = 3
      Top = 14
      Width = 62
      Height = 13
      Caption = 'P'#233'riode du'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label2: TLabel
      Left = 170
      Top = 14
      Width = 15
      Height = 13
      Caption = 'au'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label5: TLabel
      Left = 58
      Top = 46
      Width = 8
      Height = 13
      Caption = #224
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label3: TLabel
      Left = 172
      Top = 46
      Width = 21
      Height = 13
      Caption = 'pas'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label4: TLabel
      Left = 242
      Top = 46
      Width = 28
      Height = 13
      Caption = 'jours'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object SatPanel: TPanel
      Left = 8
      Top = 37
      Width = 273
      Height = 30
      Cursor = crHandPoint
      Alignment = taLeftJustify
      TabOrder = 10
      Visible = False
      object Label9: TLabel
        Left = 1
        Top = 1
        Width = 254
        Height = 26
        Hint = 'http://users2.ev1.net/~mmccants/'
        Caption = 
          'Satellites calculation use QuickSat by Mike McCants, Iridium fla' +
          're prediction use Iridflar by Robert Matson'
        ParentShowHint = False
        ShowHint = True
        WordWrap = True
      end
    end
    object EcliPanel: TPanel
      Left = 8
      Top = 37
      Width = 273
      Height = 30
      Cursor = crHandPoint
      Caption = 'Eclipse Predictions by Fred Espenak, NASA/GSFC'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 9
      Visible = False
      OnClick = EcliPanelClick
    end
    object BitBtn1: TBitBtn
      Left = 314
      Top = 8
      Width = 81
      Height = 25
      Caption = 'Refresh'
      Default = True
      TabOrder = 4
      OnClick = BitBtn1Click
      NumGlyphs = 2
    end
    object Time: TDateTimePicker
      Left = 76
      Top = 42
      Width = 77
      Height = 21
      CalAlignment = dtaLeft
      Date = 36290.8449956019
      Time = 36290.8449956019
      DateFormat = dfShort
      DateMode = dmComboBox
      Kind = dtkTime
      ParseInput = False
      TabOrder = 2
    end
    object BitBtn2: TBitBtn
      Left = 536
      Top = 8
      Width = 81
      Height = 25
      Cancel = True
      Caption = 'Fermer'
      ModalResult = 2
      TabOrder = 6
      OnClick = BitBtn2Click
      NumGlyphs = 2
    end
    object BitBtn3: TBitBtn
      Left = 425
      Top = 8
      Width = 81
      Height = 25
      Caption = 'Aide'
      TabOrder = 5
      OnClick = BitBtn3Click
      NumGlyphs = 2
    end
    object BitBtn4: TBitBtn
      Left = 425
      Top = 40
      Width = 81
      Height = 25
      Caption = 'Print'
      TabOrder = 8
      OnClick = BitBtn4Click
    end
    object BitBtn5: TBitBtn
      Left = 314
      Top = 40
      Width = 81
      Height = 25
      Caption = 'Copy'
      TabOrder = 7
      OnClick = BitBtn5Click
    end
    object ResetBtn: TBitBtn
      Left = 536
      Top = 40
      Width = 80
      Height = 25
      Caption = 'Reset Chart'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 11
      Visible = False
      OnClick = ResetBtnClick
    end
    object Date1: TJDDatePicker
      Left = 72
      Top = 8
      Width = 95
      Height = 21
      EditMask = '!999999.99.99;1; '
      MaxLength = 12
      TabOrder = 0
      Text = '  2005. 4. 2'
      JD = 2453462.5
      Year = 2005
      Month = 4
      Day = 2
    end
    object Date2: TJDDatePicker
      Left = 192
      Top = 8
      Width = 95
      Height = 21
      EditMask = '!999999.99.99;1; '
      MaxLength = 12
      TabOrder = 1
      Text = '  2005. 4. 2'
      JD = 2453462.5
      Year = 2005
      Month = 4
      Day = 2
    end
    object step: TLongEdit
      Left = 200
      Top = 41
      Width = 33
      Height = 22
      TabOrder = 3
      Value = 1
    end
  end
  object PageControl1: TPageControl
    Left = 0
    Top = 70
    Width = 627
    Height = 313
    ActivePage = twilight
    Align = alClient
    HotTrack = True
    TabIndex = 0
    TabOrder = 0
    OnChange = PageControl1Change
    object twilight: TTabSheet
      Caption = 'Cr'#233'puscule'
      DesignSize = (
        619
        285)
      object TwilightGrid: TStringGrid
        Left = 0
        Top = 24
        Width = 616
        Height = 256
        Anchors = [akLeft, akTop, akRight, akBottom]
        DefaultColWidth = 115
        DefaultRowHeight = 20
        RowCount = 3
        FixedRows = 2
        Options = [goVertLine, goHorzLine, goRangeSelect, goThumbTracking]
        TabOrder = 0
        OnMouseUp = GridMouseUp
        RowHeights = (
          20
          20
          20)
      end
    end
    object planets: TTabSheet
      Caption = 'Plan'#232'tes'
      ImageIndex = 1
      DesignSize = (
        619
        285)
      object Pagecontrol2: TPageControl
        Left = 0
        Top = 0
        Width = 621
        Height = 285
        ActivePage = Psoleil
        Anchors = [akLeft, akTop, akRight, akBottom]
        HotTrack = True
        Style = tsFlatButtons
        TabIndex = 0
        TabOrder = 0
        object Psoleil: TTabSheet
          Caption = 'Soleil'
          ImageIndex = 9
          DesignSize = (
            613
            254)
          object SoleilGrid: TStringGrid
            Left = 0
            Top = 0
            Width = 598
            Height = 242
            Anchors = [akLeft, akTop, akRight, akBottom]
            ColCount = 11
            DefaultColWidth = 75
            DefaultRowHeight = 20
            RowCount = 15
            FixedRows = 2
            Options = [goVertLine, goHorzLine, goRangeSelect, goThumbTracking]
            TabOrder = 0
            OnMouseUp = GridMouseUp
            ColWidths = (
              75
              75
              75
              55
              52
              40
              68
              71
              72
              75
              75)
            RowHeights = (
              20
              20
              20
              20
              20
              20
              20
              20
              20
              20
              20
              20
              20
              20
              20)
          end
        end
        object Mercure: TTabSheet
          Caption = 'Mercure'
          DesignSize = (
            613
            254)
          object MercureGrid: TStringGrid
            Left = 0
            Top = 0
            Width = 598
            Height = 242
            Anchors = [akLeft, akTop, akRight, akBottom]
            ColCount = 11
            DefaultColWidth = 75
            DefaultRowHeight = 20
            RowCount = 15
            FixedRows = 2
            Options = [goVertLine, goHorzLine, goRangeSelect, goThumbTracking]
            TabOrder = 0
            OnMouseUp = GridMouseUp
            ColWidths = (
              75
              75
              75
              55
              52
              40
              68
              71
              72
              75
              75)
            RowHeights = (
              20
              20
              20
              20
              20
              20
              20
              20
              20
              20
              20
              20
              20
              20
              20)
          end
        end
        object Venus: TTabSheet
          Caption = 'Venus'
          ImageIndex = 1
          DesignSize = (
            613
            254)
          object VenusGrid: TStringGrid
            Left = 0
            Top = 0
            Width = 598
            Height = 242
            Anchors = [akLeft, akTop, akRight, akBottom]
            ColCount = 11
            DefaultColWidth = 75
            DefaultRowHeight = 20
            RowCount = 15
            FixedRows = 2
            Options = [goVertLine, goHorzLine, goRangeSelect, goThumbTracking]
            TabOrder = 0
            OnMouseUp = GridMouseUp
            ColWidths = (
              75
              75
              75
              55
              52
              40
              68
              71
              72
              75
              75)
          end
        end
        object PLune: TTabSheet
          Caption = 'Lune'
          ImageIndex = 2
          DesignSize = (
            613
            254)
          object LuneGrid: TStringGrid
            Left = 0
            Top = 0
            Width = 598
            Height = 242
            Anchors = [akLeft, akTop, akRight, akBottom]
            ColCount = 11
            DefaultColWidth = 75
            DefaultRowHeight = 20
            RowCount = 15
            FixedRows = 2
            Options = [goVertLine, goHorzLine, goRangeSelect, goThumbTracking]
            TabOrder = 0
            OnMouseUp = GridMouseUp
            ColWidths = (
              75
              75
              75
              55
              52
              40
              68
              71
              72
              75
              75)
          end
        end
        object Mars: TTabSheet
          Caption = 'Mars'
          ImageIndex = 3
          DesignSize = (
            613
            254)
          object MarsGrid: TStringGrid
            Left = 0
            Top = 0
            Width = 598
            Height = 242
            Anchors = [akLeft, akTop, akRight, akBottom]
            ColCount = 11
            DefaultColWidth = 75
            DefaultRowHeight = 20
            RowCount = 15
            FixedRows = 2
            Options = [goVertLine, goHorzLine, goRangeSelect, goThumbTracking]
            TabOrder = 0
            OnMouseUp = GridMouseUp
            ColWidths = (
              75
              75
              75
              55
              52
              40
              68
              71
              72
              75
              75)
          end
        end
        object Jupiter: TTabSheet
          Caption = 'Jupiter'
          ImageIndex = 4
          DesignSize = (
            613
            254)
          object JupiterGrid: TStringGrid
            Left = 0
            Top = 0
            Width = 598
            Height = 242
            Anchors = [akLeft, akTop, akRight, akBottom]
            ColCount = 11
            DefaultColWidth = 75
            DefaultRowHeight = 20
            RowCount = 15
            FixedRows = 2
            Options = [goVertLine, goHorzLine, goRangeSelect, goThumbTracking]
            TabOrder = 0
            OnMouseUp = GridMouseUp
            ColWidths = (
              75
              75
              75
              55
              52
              40
              68
              71
              72
              75
              75)
          end
        end
        object Saturne: TTabSheet
          Caption = 'Saturne'
          ImageIndex = 5
          DesignSize = (
            613
            254)
          object SaturneGrid: TStringGrid
            Left = 0
            Top = 0
            Width = 606
            Height = 248
            Anchors = [akLeft, akTop, akRight, akBottom]
            ColCount = 11
            DefaultColWidth = 75
            DefaultRowHeight = 20
            RowCount = 15
            FixedRows = 2
            Options = [goVertLine, goHorzLine, goRangeSelect, goThumbTracking]
            TabOrder = 0
            OnMouseUp = GridMouseUp
            ColWidths = (
              75
              75
              75
              55
              52
              40
              68
              71
              72
              75
              75)
          end
        end
        object Uranus: TTabSheet
          Caption = 'Uranus'
          ImageIndex = 6
          DesignSize = (
            613
            254)
          object UranusGrid: TStringGrid
            Left = 0
            Top = 0
            Width = 598
            Height = 242
            Anchors = [akLeft, akTop, akRight, akBottom]
            ColCount = 11
            DefaultColWidth = 75
            DefaultRowHeight = 20
            RowCount = 15
            FixedRows = 2
            Options = [goVertLine, goHorzLine, goRangeSelect, goThumbTracking]
            TabOrder = 0
            OnMouseUp = GridMouseUp
            ColWidths = (
              75
              75
              75
              55
              52
              40
              68
              71
              72
              75
              75)
          end
        end
        object Neptune: TTabSheet
          Caption = 'Neptune'
          ImageIndex = 7
          DesignSize = (
            613
            254)
          object NeptuneGrid: TStringGrid
            Left = 0
            Top = 0
            Width = 598
            Height = 242
            Anchors = [akLeft, akTop, akRight, akBottom]
            ColCount = 11
            DefaultColWidth = 75
            DefaultRowHeight = 20
            RowCount = 15
            FixedRows = 2
            Options = [goVertLine, goHorzLine, goRangeSelect, goThumbTracking]
            TabOrder = 0
            OnMouseUp = GridMouseUp
            ColWidths = (
              75
              75
              75
              55
              52
              40
              68
              71
              72
              75
              75)
          end
        end
        object Pluton: TTabSheet
          Caption = 'Pluton'
          ImageIndex = 8
          DesignSize = (
            613
            254)
          object PlutonGrid: TStringGrid
            Left = 0
            Top = 0
            Width = 598
            Height = 242
            Anchors = [akLeft, akTop, akRight, akBottom]
            ColCount = 11
            DefaultColWidth = 75
            DefaultRowHeight = 20
            RowCount = 15
            FixedRows = 2
            Options = [goVertLine, goHorzLine, goRangeSelect, goThumbTracking]
            TabOrder = 0
            OnMouseUp = GridMouseUp
            ColWidths = (
              75
              75
              75
              55
              52
              40
              68
              71
              72
              75
              75)
          end
        end
      end
    end
    object comet: TTabSheet
      Caption = 'Com'#232'tes'
      ImageIndex = 2
      DesignSize = (
        619
        285)
      object ComboBox1: TComboBox
        Left = 216
        Top = 2
        Width = 169
        Height = 21
        Style = csDropDownList
        ItemHeight = 13
        TabOrder = 2
        OnChange = ComboBox1Change
      end
      object CometGrid: TStringGrid
        Left = 0
        Top = 24
        Width = 611
        Height = 254
        Anchors = [akLeft, akTop, akRight, akBottom]
        ColCount = 13
        DefaultColWidth = 70
        DefaultRowHeight = 20
        RowCount = 3
        FixedRows = 2
        Options = [goVertLine, goHorzLine, goThumbTracking]
        TabOrder = 3
        OnMouseUp = GridMouseUp
        ColWidths = (
          70
          85
          74
          45
          70
          70
          70
          70
          70
          70
          70
          70
          70)
      end
      object CometFilter: TEdit
        Left = 8
        Top = 2
        Width = 121
        Height = 21
        TabOrder = 0
      end
      object Button1: TButton
        Left = 136
        Top = 1
        Width = 75
        Height = 22
        Caption = 'Filter ->'
        TabOrder = 1
        OnClick = Button1Click
      end
    end
    object Asteroids: TTabSheet
      Caption = 'Asteroids'
      ImageIndex = 6
      DesignSize = (
        619
        285)
      object AsteroidGrid: TStringGrid
        Left = 0
        Top = 24
        Width = 611
        Height = 254
        Anchors = [akLeft, akTop, akRight, akBottom]
        ColCount = 9
        DefaultColWidth = 70
        DefaultRowHeight = 20
        RowCount = 3
        FixedRows = 2
        Options = [goVertLine, goHorzLine, goThumbTracking]
        TabOrder = 0
        OnMouseUp = GridMouseUp
        ColWidths = (
          70
          85
          74
          45
          70
          70
          70
          70
          70)
      end
      object AstFilter: TEdit
        Left = 8
        Top = 2
        Width = 121
        Height = 21
        TabOrder = 1
      end
      object Button2: TButton
        Left = 136
        Top = 1
        Width = 75
        Height = 22
        Caption = 'Filter ->'
        TabOrder = 2
        OnClick = Button2Click
      end
      object ComboBox2: TComboBox
        Left = 216
        Top = 2
        Width = 169
        Height = 21
        Style = csDropDownList
        ItemHeight = 13
        TabOrder = 3
        OnChange = ComboBox2Change
      end
    end
    object Solar: TTabSheet
      Caption = 'Eclipses Solaires'
      ImageIndex = 3
      DesignSize = (
        619
        285)
      object SolarGrid: TStringGrid
        Left = 8
        Top = 8
        Width = 606
        Height = 272
        Anchors = [akLeft, akTop, akRight, akBottom]
        ColCount = 12
        DefaultColWidth = 75
        DefaultRowHeight = 20
        RowCount = 3
        FixedRows = 2
        Options = [goVertLine, goHorzLine, goRangeSelect, goThumbTracking]
        TabOrder = 0
        OnMouseUp = GridMouseUp
        RowHeights = (
          20
          20
          20)
      end
    end
    object Lunar: TTabSheet
      Caption = 'Eclipses Lunaires'
      ImageIndex = 4
      DesignSize = (
        619
        285)
      object LunarGrid: TStringGrid
        Left = 8
        Top = 8
        Width = 606
        Height = 272
        Anchors = [akLeft, akTop, akRight, akBottom]
        ColCount = 9
        DefaultColWidth = 75
        DefaultRowHeight = 20
        RowCount = 3
        FixedRows = 2
        Options = [goVertLine, goHorzLine, goRangeSelect, goThumbTracking]
        TabOrder = 0
        OnMouseUp = GridMouseUp
        RowHeights = (
          20
          20
          20)
      end
    end
    object Satellites: TTabSheet
      Caption = 'Satellites artificiels'
      ImageIndex = 5
      TabVisible = False
      DesignSize = (
        619
        285)
      object Label6: TLabel
        Left = 240
        Top = 4
        Width = 26
        Height = 13
        Caption = 'TLE :'
      end
      object Label7: TLabel
        Left = 0
        Top = 4
        Width = 106
        Height = 13
        Caption = 'Magnitude limite, liste :'
      end
      object Label8: TLabel
        Left = 152
        Top = 4
        Width = 30
        Height = 13
        Caption = 'carte :'
      end
      object SatGrid: TStringGrid
        Left = 8
        Top = 48
        Width = 603
        Height = 230
        Anchors = [akLeft, akTop, akRight, akBottom]
        ColCount = 10
        DefaultColWidth = 70
        DefaultRowHeight = 20
        RowCount = 3
        FixedRows = 2
        Options = [goVertLine, goHorzLine, goThumbTracking]
        TabOrder = 0
        ColWidths = (
          132
          100
          42
          41
          34
          44
          45
          47
          46
          42)
      end
      object maglimit: TFloatEdit
        Left = 112
        Top = 0
        Width = 33
        Height = 21
        Hint = '0..99'
        MaxLength = 4
        ParentShowHint = False
        ShowHint = True
        TabOrder = 1
        Value = 4
        MaxValue = 99
      end
      object tle: TEdit
        Left = 272
        Top = 0
        Width = 97
        Height = 21
        TabOrder = 2
        Text = 'Visual.tle'
      end
      object SatChartBox: TCheckBox
        Left = 408
        Top = 0
        Width = 201
        Height = 17
        Caption = 'Uniquement dans la carte courante'
        TabOrder = 3
      end
      object magchart: TFloatEdit
        Left = 192
        Top = 0
        Width = 33
        Height = 21
        Hint = '0..99'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 4
        Value = 6.5
        MaxValue = 99
      end
      object IridiumBox: TCheckBox
        Left = 408
        Top = 24
        Width = 185
        Height = 17
        Caption = 'Inclu les flares Iridium'
        Checked = True
        State = cbChecked
        TabOrder = 5
      end
      object TLEListBox: TFileListBox
        Left = 272
        Top = 0
        Width = 110
        Height = 43
        IntegralHeight = True
        ItemHeight = 13
        Mask = '*.tle'
        MultiSelect = True
        TabOrder = 6
      end
      object fullday: TCheckBox
        Left = 8
        Top = 24
        Width = 153
        Height = 17
        Caption = 'Include day time pass'
        TabOrder = 7
      end
    end
  end
  object ActionList1: TActionList
    Left = 32
    Top = 304
    object HelpContents1: THelpContents
      Category = 'Help'
      Caption = '&Contents'
      Enabled = False
      Hint = 'Help Contents'
      ImageIndex = 40
      ShortCut = 112
      OnExecute = HelpContents1Execute
    end
  end
end
