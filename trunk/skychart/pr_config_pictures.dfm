object f_config_pictures: Tf_config_pictures
  Left = 0
  Top = 0
  Width = 490
  Height = 440
  TabOrder = 0
  object pa_images: TPageControl
    Left = 0
    Top = 0
    Width = 490
    Height = 440
    ActivePage = t_background
    Align = alClient
    TabOrder = 0
    object t_images: TTabSheet
      Caption = 't_images'
      TabVisible = False
      object Label50: TLabel
        Left = 2
        Top = 2
        Width = 164
        Height = 13
        Caption = 'Display image of cataloged objects'
      end
      object Label264: TLabel
        Left = 8
        Top = 46
        Width = 63
        Height = 13
        Caption = 'Pictures Path'
      end
      object Label265: TLabel
        Left = 98
        Top = 80
        Width = 41
        Height = 13
        Caption = 'There is '
      end
      object nimages: TLabel
        Left = 144
        Top = 80
        Width = 39
        Height = 13
        Caption = 'nimages'
      end
      object Label267: TLabel
        Left = 200
        Top = 80
        Width = 89
        Height = 13
        Caption = 'catalogued images'
      end
      object imgpath: TEdit
        Tag = 1
        Left = 98
        Top = 43
        Width = 239
        Height = 19
        Ctl3D = False
        ParentCtl3D = False
        TabOrder = 0
        OnChange = imgpathChange
      end
      object BitBtn3: TBitBtn
        Tag = 1
        Left = 335
        Top = 43
        Width = 19
        Height = 19
        TabOrder = 1
        TabStop = False
        OnClick = BitBtn3Click
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
      object ScanImages: TButton
        Left = 98
        Top = 104
        Width = 113
        Height = 25
        Caption = 'Scan directory'
        TabOrder = 2
        OnClick = ScanImagesClick
      end
      object Panel11: TPanel
        Left = 16
        Top = 168
        Width = 401
        Height = 145
        TabOrder = 3
        object Label266: TLabel
          Left = 32
          Top = 32
          Width = 49
          Height = 13
          Caption = 'Luminosity'
        end
        object Label268: TLabel
          Left = 40
          Top = 96
          Width = 39
          Height = 13
          Caption = 'Contrast'
        end
        object ImgLumBar: TTrackBar
          Left = 120
          Top = 24
          Width = 222
          Height = 45
          Max = 30
          Min = -30
          Orientation = trHorizontal
          PageSize = 5
          Frequency = 5
          Position = 0
          SelEnd = 0
          SelStart = 0
          TabOrder = 0
          TickMarks = tmBottomRight
          TickStyle = tsAuto
          OnChange = ImgLumBarChange
        end
        object ImgContrastBar: TTrackBar
          Left = 120
          Top = 88
          Width = 222
          Height = 45
          Max = 30
          Min = -30
          Orientation = trHorizontal
          PageSize = 5
          Frequency = 5
          Position = 0
          SelEnd = 0
          SelStart = 0
          TabOrder = 1
          TickMarks = tmBottomRight
          TickStyle = tsAuto
          OnChange = ImgContrastBarChange
        end
      end
      object ProgressPanel: TPanel
        Left = 16
        Top = 80
        Width = 401
        Height = 73
        TabOrder = 4
        Visible = False
        object ProgressCat: TLabel
          Left = 187
          Top = 8
          Width = 26
          Height = 13
          Caption = 'Other'
        end
        object ProgressBar1: TProgressBar
          Left = 24
          Top = 40
          Width = 361
          Height = 17
          Min = 0
          Max = 100
          TabOrder = 0
        end
      end
      object ShowImagesBox: TCheckBox
        Left = 32
        Top = 344
        Width = 369
        Height = 17
        Caption = 'Show object pictures on the chart'
        TabOrder = 5
        OnClick = ShowImagesBoxClick
      end
    end
    object t_background: TTabSheet
      Caption = 't_background'
      ImageIndex = 1
      TabVisible = False
      object Label270: TLabel
        Left = 0
        Top = 0
        Width = 94
        Height = 13
        Caption = 'Background Picture'
      end
      object Label271: TLabel
        Left = 8
        Top = 22
        Width = 42
        Height = 13
        Caption = 'FITS File'
      end
      object backimginfo: TLabel
        Left = 8
        Top = 40
        Width = 65
        Height = 13
        Caption = 'backimginfo'
      end
      object Image1: TImage
        Left = 0
        Top = 112
        Width = 481
        Height = 313
        Stretch = True
      end
      object backimg: TEdit
        Tag = 1
        Left = 98
        Top = 19
        Width = 327
        Height = 19
        Ctl3D = False
        ParentCtl3D = False
        TabOrder = 0
        OnChange = backimgChange
      end
      object BitBtn5: TBitBtn
        Tag = 1
        Left = 428
        Top = 19
        Width = 19
        Height = 19
        TabOrder = 1
        TabStop = False
        OnClick = BitBtn5Click
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
      object ShowBackImg: TCheckBox
        Left = 8
        Top = 80
        Width = 145
        Height = 17
        Caption = 'Show this picture'
        TabOrder = 2
        OnClick = ShowBackImgClick
      end
      object Panel1: TPanel
        Left = 176
        Top = 60
        Width = 305
        Height = 50
        TabOrder = 3
        object Label1: TLabel
          Left = 54
          Top = 8
          Width = 49
          Height = 13
          Caption = 'Luminosity'
        end
        object Label2: TLabel
          Left = 203
          Top = 8
          Width = 39
          Height = 13
          Caption = 'Contrast'
        end
        object ImgLumBar2: TTrackBar
          Left = 8
          Top = 24
          Width = 140
          Height = 18
          Max = 30
          Min = -30
          Orientation = trHorizontal
          PageSize = 5
          Frequency = 5
          Position = 0
          SelEnd = 0
          SelStart = 0
          TabOrder = 0
          ThumbLength = 13
          TickMarks = tmBottomRight
          TickStyle = tsAuto
          OnChange = ImgLumBar2Change
        end
        object ImgContrastBar2: TTrackBar
          Left = 152
          Top = 24
          Width = 140
          Height = 18
          Max = 30
          Min = -30
          Orientation = trHorizontal
          PageSize = 5
          Frequency = 5
          Position = 0
          SelEnd = 0
          SelStart = 0
          TabOrder = 1
          ThumbLength = 13
          TickMarks = tmBottomRight
          TickStyle = tsAuto
          OnChange = ImgContrastBar2Change
        end
      end
    end
  end
  object FolderDialog1: TFolderDialog
    Top = 400
    Left = 40
    Title = 'Browse for Folder'
  end
  object OpenDialog1: TOpenDialog
    Left = 8
    Top = 400
  end
  object ImageTimer1: TTimer
    Enabled = False
    Interval = 200
    OnTimer = ImageTimer1Timer
    Left = 80
    Top = 400
  end
end
