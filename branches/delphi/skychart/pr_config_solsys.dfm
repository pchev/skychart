object f_config_solsys: Tf_config_solsys
  Left = 0
  Top = 0
  Width = 490
  Height = 443
  TabOrder = 0
  object pa_solsys: TPageControl
    Left = 0
    Top = 0
    Width = 490
    Height = 443
    ActivePage = t_solsys
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
        OnChange = PlanetDirChange
      end
      object planetdirsel: TBitBtn
        Left = 328
        Top = 56
        Width = 26
        Height = 26
        TabOrder = 2
        TabStop = False
        OnClick = PlanetDirSelClick
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
        Top = 314
        Width = 109
        Height = 13
        Caption = 'Jupiter GRS longitude :'
      end
      object Label53: TLabel
        Left = 248
        Top = 48
        Width = 100
        Height = 13
        Caption = 'Computation Plugin : '
        Visible = False
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
        Top = 80
        Width = 329
        Height = 145
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
        Top = 344
        Width = 321
        Height = 17
        Caption = 'Show stars behind the planets'
        TabOrder = 2
        OnClick = PlanetBox2Click
      end
      object PlanetBox3: TCheckBox
        Left = 40
        Top = 368
        Width = 321
        Height = 17
        Caption = 'Show Earth Shadow  (Lunar eclipses)'
        TabOrder = 3
        OnClick = PlanetBox3Click
      end
      object GRS: TFloatEdit
        Left = 152
        Top = 309
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
        Top = 308
        Width = 27
        Height = 25
        Hint = 'Get recent measurement from JUPOS'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 5
        OnClick = BitBtn37Click
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
        Left = 360
        Top = 44
        Width = 100
        Height = 21
        TabOrder = 6
        Visible = False
      end
      object XplanetBox: TGroupBox
        Left = 40
        Top = 232
        Width = 329
        Height = 65
        Caption = 'Image Options'
        TabOrder = 7
        object UseXplanet: TCheckBox
          Left = 8
          Top = 24
          Width = 97
          Height = 17
          Caption = 'Use Xplanet'
          TabOrder = 0
          OnClick = UseXplanetClick
        end
        object XplanetDir: TEdit
          Left = 104
          Top = 24
          Width = 177
          Height = 21
          TabOrder = 1
          Text = 'XplanetDir'
          OnChange = XplanetDirChange
        end
        object XplanetBtn: TBitBtn
          Left = 279
          Top = 23
          Width = 26
          Height = 26
          TabOrder = 2
          TabStop = False
          OnClick = XplanetBtnClick
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
    object t_comet: TTabSheet
      Caption = 't_comet'
      ImageIndex = 2
      TabVisible = False
      object ComPageControl: TPageControl
        Left = 0
        Top = 4
        Width = 481
        Height = 429
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
                'Proportional to the tail length')
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
            OnClick = comdbsetClick
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
              OnClick = comfilebtnClick
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
        Width = 481
        Height = 429
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
              ItemHeight = 0
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
            Height = 21
            TabOrder = 0
          end
          object asth: TEdit
            Left = 160
            Top = 64
            Width = 100
            Height = 21
            TabOrder = 1
            Text = '16'
          end
          object astg: TEdit
            Left = 312
            Top = 64
            Width = 100
            Height = 21
            TabOrder = 2
            Text = '0.15'
          end
          object astep: TEdit
            Left = 8
            Top = 128
            Width = 100
            Height = 21
            TabOrder = 3
            Text = '2453006.5'
          end
          object astma: TEdit
            Left = 160
            Top = 128
            Width = 100
            Height = 21
            TabOrder = 4
            Text = '0.0'
          end
          object astperi: TEdit
            Left = 312
            Top = 128
            Width = 100
            Height = 21
            TabOrder = 5
            Text = '0.0'
          end
          object astnode: TEdit
            Left = 8
            Top = 192
            Width = 100
            Height = 21
            TabOrder = 6
            Text = '0.0'
          end
          object asti: TEdit
            Left = 160
            Top = 192
            Width = 100
            Height = 21
            TabOrder = 7
            Text = '0.0'
          end
          object astec: TEdit
            Left = 312
            Top = 192
            Width = 100
            Height = 21
            TabOrder = 8
            Text = '0.0'
          end
          object astax: TEdit
            Left = 8
            Top = 256
            Width = 100
            Height = 21
            TabOrder = 9
            Text = '2'
          end
          object astref: TEdit
            Left = 160
            Top = 256
            Width = 100
            Height = 21
            TabOrder = 10
          end
          object astnam: TEdit
            Left = 8
            Top = 320
            Width = 257
            Height = 21
            TabOrder = 11
          end
          object asteq: TEdit
            Left = 312
            Top = 256
            Width = 100
            Height = 21
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
  object FolderDialog1: TFolderDialog
    Top = 8
    Left = 448
    Title = 'Browse for Folder'
  end
  object OpenDialog1: TOpenDialog
    Left = 408
    Top = 8
  end
end
