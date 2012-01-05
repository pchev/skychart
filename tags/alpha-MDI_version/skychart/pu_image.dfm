object f_image: Tf_image
  Left = 363
  Top = 106
  Width = 615
  Height = 407
  HorzScrollBar.Smooth = True
  HorzScrollBar.Size = 12
  HorzScrollBar.Tracking = True
  VertScrollBar.Smooth = True
  VertScrollBar.Size = 12
  VertScrollBar.Tracking = True
  Caption = 'Taille r'#233'elle'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  Scaled = False
  OnCreate = FormCreate
  OnKeyPress = FormKeyPress
  OnMouseWheel = FormMouseWheel
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 13
  object Image1: TZoomImage
    Left = 0
    Top = 32
    Width = 465
    Height = 265
    Zoom = 1
    ZoomMax = 4
    Xcentre = 0
    Ycentre = 0
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 607
    Height = 27
    Align = alTop
    AutoSize = True
    TabOrder = 0
    TabStop = True
    object Label1: TLabel
      Left = 240
      Top = 6
      Width = 32
      Height = 13
      Caption = 'Label1'
    end
    object Button1: TButton
      Left = 0
      Top = 1
      Width = 75
      Height = 25
      Caption = 'Close'
      TabOrder = 0
      OnClick = Button1Click
    end
    object Button2: TButton
      Left = 80
      Top = 1
      Width = 75
      Height = 25
      Caption = 'Zoom +'
      TabOrder = 1
      OnClick = Button2Click
    end
    object Button3: TButton
      Left = 160
      Top = 1
      Width = 75
      Height = 25
      Caption = 'Zoom -'
      TabOrder = 2
      OnClick = Button3Click
    end
  end
  object VScrollBar: TScrollBar
    Left = 590
    Top = 27
    Width = 17
    Height = 333
    Align = alRight
    Kind = sbVertical
    PageSize = 0
    TabOrder = 2
    OnChange = VScrollBarChange
  end
  object HScrollBar: TScrollBar
    Left = 0
    Top = 360
    Width = 607
    Height = 17
    Align = alBottom
    PageSize = 0
    TabOrder = 3
    OnChange = HScrollBarChange
  end
end
