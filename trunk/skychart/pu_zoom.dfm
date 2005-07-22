object f_zoom: Tf_zoom
  Left = 453
  Top = 181
  Width = 308
  Height = 154
  BorderStyle = bsSizeToolWin
  Caption = 'Set FOV'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = True
  Scaled = False
  OnShow = FormShow
  PixelsPerInch = 120
  TextHeight = 16
  object Label1: TLabel
    Left = 16
    Top = 8
    Width = 10
    Height = 16
    Caption = '1'#39
  end
  object Label2: TLabel
    Left = 120
    Top = 8
    Width = 7
    Height = 16
    Caption = '1'
  end
  object Label3: TLabel
    Left = 172
    Top = 8
    Width = 14
    Height = 16
    Caption = '10'
  end
  object Label4: TLabel
    Left = 225
    Top = 8
    Width = 21
    Height = 16
    Caption = '100'
  end
  object Label5: TLabel
    Left = 254
    Top = 8
    Width = 21
    Height = 16
    Caption = '360'
  end
  object Label6: TLabel
    Left = 70
    Top = 8
    Width = 17
    Height = 16
    Caption = '10'#39
  end
  object TrackBar1: TTrackBar
    Left = 8
    Top = 24
    Width = 273
    Height = 33
    Max = 260
    Min = -178
    Orientation = trHorizontal
    PageSize = 10
    Frequency = 1
    Position = 0
    SelEnd = 0
    SelStart = 0
    TabOrder = 0
    TickMarks = tmTopLeft
    TickStyle = tsManual
    OnChange = TrackBar1Change
  end
  object BitBtn1: TBitBtn
    Left = 70
    Top = 88
    Width = 73
    Height = 25
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 1
    NumGlyphs = 2
  end
  object BitBtn2: TBitBtn
    Left = 158
    Top = 88
    Width = 73
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 2
    NumGlyphs = 2
  end
  object Edit1: TEdit
    Left = 120
    Top = 56
    Width = 49
    Height = 24
    TabStop = False
    Color = clBtnFace
    ReadOnly = True
    TabOrder = 3
  end
end
