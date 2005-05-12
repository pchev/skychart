object f_config: Tf_config
  Left = 296
  Top = 127
  Width = 714
  Height = 527
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
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object PageControl1: TPageControl
    Left = 200
    Top = 0
    Width = 506
    Height = 452
    ActivePage = s_time
    Align = alClient
    TabOrder = 0
    object s_time: TTabSheet
      Caption = 's_time'
      TabVisible = False
      inline f_config_time1: Tf_config_time
        Left = 4
        Top = 4
        Width = 490
        Height = 440
        TabOrder = 0
      end
    end
    object s_observatory: TTabSheet
      Caption = 's_observatory'
      ImageIndex = 1
      TabVisible = False
      inline f_config_observatory1: Tf_config_observatory
        Left = 4
        Top = 4
        Width = 490
        Height = 440
        TabOrder = 0
      end
    end
    object s_chart: TTabSheet
      Caption = 's_chart'
      ImageIndex = 2
      TabVisible = False
      inline f_config_chart1: Tf_config_chart
        Left = 4
        Top = 4
        Width = 490
        Height = 440
        TabOrder = 0
      end
    end
    object s_catalog: TTabSheet
      Caption = 's_catalog'
      ImageIndex = 3
      TabVisible = False
      inline f_config_catalog1: Tf_config_catalog
        Left = 4
        Top = 4
        Width = 490
        Height = 440
        TabOrder = 0
      end
    end
    object s_solsys: TTabSheet
      Caption = 's_solsys'
      ImageIndex = 4
      TabVisible = False
      inline f_config_solsys1: Tf_config_solsys
        Left = 4
        Top = 4
        Width = 490
        Height = 440
        TabOrder = 0
        inherited pa_solsys: TPageControl
          Height = 440
        end
      end
    end
    object s_display: TTabSheet
      Caption = 's_display'
      ImageIndex = 5
      TabVisible = False
      inline f_config_display1: Tf_config_display
        Left = 4
        Top = 4
        Width = 490
        Height = 440
        TabOrder = 0
      end
    end
    object s_images: TTabSheet
      Caption = 's_images'
      ImageIndex = 6
      TabVisible = False
      inline f_config_pictures1: Tf_config_pictures
        Left = 4
        Top = 4
        Width = 490
        Height = 440
        TabOrder = 0
      end
    end
    object s_system: TTabSheet
      Caption = 's_system'
      ImageIndex = 7
      TabVisible = False
      inline f_config_system1: Tf_config_system
        Left = 4
        Top = 4
        Width = 490
        Height = 440
        TabOrder = 0
      end
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 200
    Height = 452
    Align = alLeft
    TabOrder = 1
    object TreeView1: TTreeView
      Left = 4
      Top = 4
      Width = 189
      Height = 421
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
        6465722072656374616E676C65202843434429240000000000000000000000A0
        A975410000000000000000020000000B372D2050696374757265732200000000
        00000000000000FFFFFFFFFFFFFFFF000000000000000009312D204F626A6563
        74260000000000000000000000FFFFFFFFFFFFFFFF00000000000000000D322D
        204261636B67726F756E6422000000FFFFFFFFFFFFFFFFA0A975410000000000
        0000000300000009382D2053797374656D220000000000000000000000FFFFFF
        FFFFFFFFFF000000000000000009312D2053797374656D22000000FFFFFFFFFF
        FFFFFFA0A9754100000000000000000000000009322D20536572766572250000
        000000000000000000FFFFFFFFFFFFFFFF00000000000000000C332D2054656C
        6573636F7065}
    end
    object previous: TButton
      Left = 56
      Top = 428
      Width = 25
      Height = 25
      Caption = '<'
      TabOrder = 1
      OnClick = previousClick
    end
    object next: TButton
      Left = 104
      Top = 428
      Width = 25
      Height = 25
      Caption = '>'
      TabOrder = 2
      OnClick = nextClick
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 452
    Width = 706
    Height = 41
    Align = alBottom
    TabOrder = 2
    object Applyall: TCheckBox
      Left = 16
      Top = 12
      Width = 177
      Height = 17
      Caption = 'Apply Change To All Chart'
      Checked = True
      State = cbChecked
      TabOrder = 0
    end
    object OKBtn: TButton
      Left = 270
      Top = 8
      Width = 75
      Height = 25
      Caption = 'OK'
      Default = True
      ModalResult = 1
      TabOrder = 1
    end
    object Apply: TButton
      Left = 358
      Top = 8
      Width = 75
      Height = 25
      Caption = 'Apply'
      TabOrder = 2
      OnClick = ApplyClick
    end
    object CancelBtn: TButton
      Left = 446
      Top = 8
      Width = 75
      Height = 25
      Cancel = True
      Caption = 'Cancel'
      ModalResult = 2
      TabOrder = 3
    end
    object HelpBtn: TButton
      Left = 534
      Top = 8
      Width = 75
      Height = 25
      Caption = '&Help'
      TabOrder = 4
    end
  end
end
