object f_detail: Tf_detail
  Left = 521
  Top = 108
  Width = 398
  Height = 391
  BorderStyle = bsSizeToolWin
  Caption = 'Details'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -14
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 120
  TextHeight = 16
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 390
    Height = 50
    Align = alTop
    TabOrder = 0
    object Button1: TButton
      Left = 266
      Top = 10
      Width = 117
      Height = 31
      Cancel = True
      Caption = 'Close'
      TabOrder = 0
      OnClick = Button1Click
    end
    object Button2: TButton
      Left = 10
      Top = 10
      Width = 117
      Height = 31
      Caption = 'Center Object'
      TabOrder = 1
      OnClick = Button2Click
    end
    object Button3: TButton
      Left = 138
      Top = 10
      Width = 117
      Height = 31
      Caption = 'Neighbor'
      TabOrder = 2
      OnClick = Button3Click
    end
  end
  object memo: TRichEdit
    Left = 0
    Top = 50
    Width = 390
    Height = 301
    Align = alClient
    Lines.Strings = (
      '')
    PopupMenu = PopupMenu1
    ReadOnly = True
    ScrollBars = ssBoth
    TabOrder = 1
    WordWrap = False
  end
  object ActionList1: TActionList
    Left = 128
    Top = 144
    object EditSelectAll1: TEditSelectAll
      Category = 'Edit'
      Caption = 'Select &All'
      Hint = 'Select All|Selects the entire document'
      ShortCut = 16449
    end
    object EditCopy1: TEditCopy
      Category = 'Edit'
      Caption = '&Copy'
      Hint = 'Copy|Copies the selection and puts it on the Clipboard'
      ImageIndex = 1
      ShortCut = 16451
    end
  end
  object PopupMenu1: TPopupMenu
    Left = 72
    Top = 144
    object SelectAll1: TMenuItem
      Action = EditSelectAll1
    end
    object Copy1: TMenuItem
      Action = EditCopy1
    end
  end
end
