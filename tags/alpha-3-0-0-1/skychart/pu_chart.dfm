object f_chart: Tf_chart
  Left = 400
  Top = 118
  Width = 384
  Height = 244
  Caption = 'Chart'
  Color = clBtnFace
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
  OnMouseWheel = FormMouseWheel
  OnResize = FormResize
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Image1: TImage
    Left = 0
    Top = 0
    Width = 376
    Height = 217
    Cursor = crCross
    Align = alClient
    AutoSize = True
    PopupMenu = PopupMenu1
    Stretch = True
    OnMouseMove = Image1MouseMove
    OnMouseUp = Image1MouseUp
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
      Category = 'zoom'
      Caption = 'FlipX'
      ImageIndex = 15
      OnExecute = FlipXExecute
    end
    object FlipY: TAction
      Category = 'zoom'
      Caption = 'FlipY'
      ImageIndex = 17
      OnExecute = FlipYExecute
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
  end
end