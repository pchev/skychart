object f_info: Tf_info
  Left = 210
  Top = 163
  Width = 448
  Height = 352
  ActiveControl = PageControl1
  BorderStyle = bsSizeToolWin
  Caption = 'Info'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = True
  Position = poDefaultPosOnly
  OnClose = FormClose
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 440
    Height = 298
    ActivePage = ProgressMessages
    Align = alClient
    TabIndex = 2
    TabOrder = 0
    object TabSheet1: TTabSheet
      Caption = 'TCP/IP Connection'
      object StringGrid1: TStringGrid
        Left = 0
        Top = 0
        Width = 432
        Height = 242
        Align = alClient
        ColCount = 1
        DefaultColWidth = 800
        DefaultRowHeight = 22
        FixedCols = 0
        RowCount = 10
        FixedRows = 0
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goDrawFocusSelected, goRowSelect]
        PopupMenu = PopupMenu1
        ScrollBars = ssVertical
        TabOrder = 0
        OnMouseDown = StringGrid1MouseDown
      end
      object Panel2: TPanel
        Left = 0
        Top = 242
        Width = 432
        Height = 28
        Align = alBottom
        TabOrder = 1
        object Button2: TButton
          Left = 12
          Top = 1
          Width = 75
          Height = 25
          Caption = 'Refresh'
          TabOrder = 0
          OnClick = Button2Click
        end
        object CheckBox1: TCheckBox
          Left = 136
          Top = 2
          Width = 100
          Height = 22
          Caption = 'AutoRefresh'
          Checked = True
          State = cbChecked
          TabOrder = 1
          OnClick = CheckBox1Click
        end
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'Object List'
      ImageIndex = 1
      object Panel3: TPanel
        Left = 0
        Top = 243
        Width = 432
        Height = 27
        Align = alBottom
        TabOrder = 0
        DesignSize = (
          432
          27)
        object Button3: TButton
          Left = 94
          Top = 1
          Width = 75
          Height = 25
          Anchors = [akTop, akRight]
          Caption = 'Search'
          TabOrder = 0
          OnClick = Button3Click
        end
        object Edit1: TEdit
          Left = 4
          Top = 3
          Width = 85
          Height = 21
          Anchors = [akTop, akRight]
          TabOrder = 1
          OnKeyUp = Edit1KeyUp
        end
        object Button5: TButton
          Left = 180
          Top = 1
          Width = 75
          Height = 25
          Anchors = [akTop, akRight]
          Caption = 'Sort by RA'
          TabOrder = 2
          OnClick = Button5Click
        end
        object Button6: TButton
          Left = 268
          Top = 1
          Width = 75
          Height = 25
          Anchors = [akTop, akRight]
          Caption = 'Print'
          TabOrder = 3
          OnClick = Button6Click
        end
        object Button7: TButton
          Left = 356
          Top = 0
          Width = 75
          Height = 25
          Anchors = [akTop, akRight]
          Caption = 'Save'
          TabOrder = 4
          OnClick = Button7Click
        end
      end
      object Memo1: TRichEdit
        Left = 0
        Top = 0
        Width = 432
        Height = 243
        Align = alClient
        PlainText = True
        PopupMenu = PopupMenu2
        ReadOnly = True
        ScrollBars = ssBoth
        TabOrder = 1
        WordWrap = False
        OnMouseUp = Memo1MouseUp
      end
    end
    object ProgressMessages: TTabSheet
      Caption = 'Progress Messages'
      ImageIndex = 2
      object ProgressMemo: TMemo
        Left = 0
        Top = 0
        Width = 432
        Height = 270
        Align = alClient
        Lines.Strings = (
          '')
        TabOrder = 0
      end
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 298
    Width = 440
    Height = 27
    Align = alBottom
    TabOrder = 1
    DesignSize = (
      440
      27)
    object Button1: TButton
      Left = 272
      Top = 1
      Width = 75
      Height = 25
      Anchors = [akTop, akRight]
      Cancel = True
      Caption = 'Close'
      TabOrder = 0
      OnClick = Button1Click
    end
    object Button4: TButton
      Left = 360
      Top = 0
      Width = 76
      Height = 25
      Anchors = [akTop, akRight]
      Caption = 'Help'
      TabOrder = 1
    end
  end
  object PopupMenu1: TPopupMenu
    Left = 112
    Top = 64
    object closeconnection: TMenuItem
      Caption = 'Close Connection'
      OnClick = closeconnectionClick
    end
  end
  object Timer1: TTimer
    Enabled = False
    Interval = 2000
    OnTimer = Timer1Timer
    Left = 64
    Top = 64
  end
  object PopupMenu2: TPopupMenu
    Left = 104
    Top = 176
    object outslectionner1: TMenuItem
      Action = EditSelectAll1
    end
    object Copier1: TMenuItem
      Action = EditCopy1
    end
  end
  object ActionList1: TActionList
    Left = 72
    Top = 176
    object EditSelectAll1: TEditSelectAll
      Category = 'Edition'
      Caption = '&Tout s'#233'lectionner'
      Hint = 'Tout s'#233'lectionner|S'#233'lectionner l'#39'int'#233'gralit'#233' du document'
      ShortCut = 16449
    end
    object EditCopy1: TEditCopy
      Category = 'Edition'
      Caption = '&Copier'
      Hint = 'Copier|Copier la s'#233'lection et la mettre dans le Presse-papiers'
      ImageIndex = 1
      ShortCut = 16451
    end
  end
  object SaveDialog1: TSaveDialog
    Left = 72
    Top = 136
  end
end
