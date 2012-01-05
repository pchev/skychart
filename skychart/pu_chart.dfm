object f_chart: Tf_chart
  Left = 400
  Top = 118
  Width = 384
  Height = 244
  Caption = 'Chart'
  Color = clBlack
  ParentFont = True
  FormStyle = fsMDIChild
  KeyPreview = True
  OldCreateOrder = False
  Position = poDefault
  Visible = True
  OnActivate = FormActivate
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnKeyDown = FormKeyDown
  OnKeyPress = FormKeyPress
  OnResize = FormResize
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 376
    Height = 217
    Align = alClient
    BevelOuter = bvNone
    Color = clBlack
    TabOrder = 0
    object Image1: TImage
      Left = 0
      Top = 0
      Width = 376
      Height = 217
      Align = alClient
      AutoSize = True
      PopupMenu = PopupMenu1
      Stretch = True
      OnClick = Image1Click
      OnMouseDown = Image1MouseDown
      OnMouseMove = Image1MouseMove
      OnMouseUp = Image1MouseUp
    end
    object identlabel: TLabel
      Left = 96
      Top = 120
      Width = 45
      Height = 13
      Cursor = crHandPoint
      Caption = 'identlabel'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      Visible = False
      OnClick = identlabelClick
    end
  end
  object RefreshTimer: TTimer
    Enabled = False
    Interval = 200
    OnTimer = RefreshTimerTimer
    Left = 16
    Top = 64
  end
  object ActionList1: TActionList
    Images = f_main.ImageList1
    Left = 56
    Top = 64
    object zoomplus: TAction
      Category = 'zoom'
      Caption = 'Zoom +'
      ImageIndex = 6
      OnExecute = zoomplusExecute
    end
    object zoomminus: TAction
      Category = 'zoom'
      Caption = 'Zoom -'
      ImageIndex = 7
      OnExecute = zoomminusExecute
    end
    object MoveWest: TAction
      Category = 'move'
      Caption = 'Move West'
      OnExecute = MoveWestExecute
    end
    object MoveEast: TAction
      Category = 'move'
      Caption = 'Move East'
      OnExecute = MoveEastExecute
    end
    object MoveNorth: TAction
      Category = 'move'
      Caption = 'Move North'
      OnExecute = MoveNorthExecute
    end
    object MoveSouth: TAction
      Category = 'move'
      Caption = 'Move South'
      OnExecute = MoveSouthExecute
    end
    object MoveNorthWest: TAction
      Category = 'move'
      Caption = 'Move North-West'
      OnExecute = MoveNorthWestExecute
    end
    object MoveNorthEast: TAction
      Category = 'move'
      Caption = 'Move North-East'
      OnExecute = MoveNorthEastExecute
    end
    object MoveSouthWest: TAction
      Category = 'move'
      Caption = 'Move South-West'
      OnExecute = MoveSouthWestExecute
    end
    object MoveSouthEast: TAction
      Category = 'move'
      Caption = 'Move South-East'
      OnExecute = MoveSouthEastExecute
    end
    object Centre: TAction
      Category = 'move'
      Caption = 'Centre'
      OnExecute = CentreExecute
    end
    object zoomplusmove: TAction
      Category = 'zoom'
      Caption = 'Zoom + Centre'
      ImageIndex = 6
      OnExecute = zoomplusmoveExecute
    end
    object zoomminusmove: TAction
      Category = 'zoom'
      Caption = 'Zoom - Centre'
      ImageIndex = 7
      OnExecute = zoomminusmoveExecute
    end
    object FlipX: TAction
      Category = 'rotation'
      Caption = 'FlipX'
      ImageIndex = 15
      OnExecute = FlipXExecute
    end
    object FlipY: TAction
      Category = 'rotation'
      Caption = 'FlipY'
      ImageIndex = 17
      OnExecute = FlipYExecute
    end
    object Undo: TAction
      Category = 'Undo'
      Caption = 'Undo'
      OnExecute = UndoExecute
    end
    object Redo: TAction
      Category = 'Undo'
      Caption = 'Redo'
      OnExecute = RedoExecute
    end
    object rot_plus: TAction
      Category = 'rotation'
      Caption = 'rot_plus'
      ImageIndex = 21
      OnExecute = rot_plusExecute
    end
    object rot_minus: TAction
      Category = 'rotation'
      Caption = 'rot_minus'
      ImageIndex = 22
      OnExecute = rot_minusExecute
    end
    object GridEQ: TAction
      Category = 'Grid'
      Caption = 'GridEQ'
      ImageIndex = 24
      OnExecute = GridEQExecute
    end
    object Grid: TAction
      Category = 'Grid'
      Caption = 'Grid'
      ImageIndex = 25
      OnExecute = GridExecute
    end
    object switchbackground: TAction
      Caption = 'switchbackground'
      OnExecute = switchbackgroundExecute
    end
    object switchstar: TAction
      Caption = 'switchstar'
      OnExecute = switchstarExecute
    end
  end
  object PopupMenu1: TPopupMenu
    Images = f_main.ImageList1
    OnPopup = PopupMenu1Popup
    Left = 104
    Top = 64
    object Centre1: TMenuItem
      Action = Centre
    end
    object Zoom1: TMenuItem
      Action = zoomplusmove
    end
    object Zoom2: TMenuItem
      Action = zoomminusmove
    end
    object Resetalllabels1: TMenuItem
      Caption = 'Reset all labels'
      OnClick = Resetalllabels1Click
    end
  end
end
