object f_chart: Tf_chart
  Left = 641
  Top = 135
  Width = 508
  Height = 338
  Caption = 'Chart'
  Color = clBlack
  ParentFont = True
  KeyPreview = True
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnKeyDown = FormKeyDown
  OnKeyPress = FormKeyPress
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 500
    Height = 300
    BevelOuter = bvNone
    Color = clBlack
    TabOrder = 0
    OnResize = ChartResize
    object Image1: TImage
      Left = 0
      Top = 0
      Width = 500
      Height = 300
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
      Font.Height = -12
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      ShowAccelChar = False
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
    object N1: TMenuItem
      Caption = '-'
    end
    object NewFinderCircle1: TMenuItem
      Caption = 'New Finder Circle'
      OnClick = NewFinderCircle1Click
    end
    object RemoveLastCircle1: TMenuItem
      Caption = 'Remove Last Circle'
      OnClick = RemoveLastCircle1Click
    end
    object RemoveAllCircles1: TMenuItem
      Caption = 'Remove All Circles'
      OnClick = RemoveAllCircles1Click
    end
    object N2: TMenuItem
      Caption = '-'
    end
    object elescope1: TMenuItem
      Caption = 'Telescope'
      object Slew1: TMenuItem
        Caption = 'Slew'
        OnClick = Slew1Click
      end
      object Sync1: TMenuItem
        Caption = 'Sync'
        OnClick = Sync1Click
      end
      object Connect1: TMenuItem
        Caption = 'Connect'
        OnClick = Connect1Click
      end
      object AbortSlew1: TMenuItem
        Caption = 'Abort Slew'
        OnClick = AbortSlew1Click
      end
    end
    object N3: TMenuItem
      Caption = '-'
    end
    object TrackOn1: TMenuItem
      Caption = 'Lock on'
      OnClick = TrackOn1Click
    end
    object TrackOff1: TMenuItem
      Caption = 'Unlock Chart'
      OnClick = TrackOff1Click
    end
  end
  object TelescopeTimer: TTimer
    Enabled = False
    Interval = 500
    OnTimer = TelescopeTimerTimer
    Left = 160
    Top = 64
  end
end