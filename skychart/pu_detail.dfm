object f_detail: Tf_detail
  Left = 516
  Top = 103
  Width = 337
  Height = 414
  Caption = 'Details'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 329
    Height = 41
    Align = alTop
    TabOrder = 0
    object Button1: TButton
      Left = 8
      Top = 8
      Width = 75
      Height = 25
      Cancel = True
      Caption = 'Close'
      TabOrder = 0
      OnClick = Button1Click
    end
  end
  object memo: TRichEdit
    Left = 0
    Top = 41
    Width = 329
    Height = 346
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
