object f_printsetup: Tf_printsetup
  Left = 207
  Top = 166
  Width = 413
  Height = 368
  HorzScrollBar.Range = 331
  VertScrollBar.Range = 233
  ActiveControl = printmode
  AutoScroll = False
  Caption = 'f_printsetup'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = True
  Scaled = False
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object qtoption: TPanel
    Left = 18
    Top = 83
    Width = 367
    Height = 110
    TabOrder = 1
    object qtprintername: TLabel
      Left = 197
      Top = 49
      Width = 48
      Height = 13
      Caption = '                '
    end
    object qtprintresol: TLabel
      Left = 197
      Top = 71
      Width = 57
      Height = 13
      Caption = '                   '
    end
    object Label2: TLabel
      Left = 120
      Top = 49
      Width = 33
      Height = 13
      Caption = 'Printer:'
    end
    object Label3: TLabel
      Left = 120
      Top = 71
      Width = 53
      Height = 13
      Caption = 'Resolution:'
    end
    object Label7: TLabel
      Left = 16
      Top = 16
      Width = 263
      Height = 13
      Caption = 'Select the Windows printer and options you want to use'
    end
    object qtsetup: TButton
      Left = 12
      Top = 58
      Width = 85
      Height = 25
      Caption = 'Printer Setup'
      TabOrder = 0
      OnClick = qtsetupClick
    end
  end
  object customoption: TPanel
    Left = 18
    Top = 83
    Width = 367
    Height = 110
    TabOrder = 2
    object Label1: TLabel
      Left = 209
      Top = 4
      Width = 84
      Height = 13
      Caption = 'Raster Resolution'
    end
    object Label4: TLabel
      Left = 8
      Top = 62
      Width = 168
      Height = 13
      Caption = 'Command to use to process the file.'
    end
    object Label5: TLabel
      Left = 256
      Top = 28
      Width = 95
      Height = 13
      Caption = 'dpi for 8"x11" paper'
    end
    object Label6: TLabel
      Left = 9
      Top = 4
      Width = 100
      Height = 13
      Caption = 'Path to save the file :'
    end
    object prtres: TLongEdit
      Left = 208
      Top = 23
      Width = 41
      Height = 22
      Hint = '0..600'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      OnChange = prtresChange
      Value = 75
      MaxValue = 600
    end
    object cmdreport: TEdit
      Left = 8
      Top = 84
      Width = 345
      Height = 21
      Color = clBtnFace
      ReadOnly = True
      TabOrder = 1
    end
    object savepath: TEdit
      Left = 8
      Top = 24
      Width = 161
      Height = 21
      TabOrder = 2
      Text = 'savepath'
      OnChange = savepathChange
    end
    object printcmd: TEdit
      Left = 208
      Top = 58
      Width = 121
      Height = 21
      TabOrder = 3
      Text = 'printcmd'
      OnChange = printcmdChange
    end
    object savepathsel: TBitBtn
      Left = 168
      Top = 21
      Width = 26
      Height = 26
      TabOrder = 4
      TabStop = False
      OnClick = savepathselClick
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
      Layout = blGlyphTop
      Margin = 0
    end
    object printcmdsel: TBitBtn
      Left = 328
      Top = 55
      Width = 26
      Height = 26
      TabOrder = 5
      TabStop = False
      OnClick = printcmdselClick
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
      Layout = blGlyphTop
      Margin = 0
    end
  end
  object printmode: TRadioGroup
    Left = 18
    Top = 12
    Width = 367
    Height = 61
    Caption = 'Print method'
    Columns = 3
    Items.Strings = (
      'Windows Printer'
      'Postscript'
      'Bitmap File')
    TabOrder = 0
    OnClick = printmodeClick
  end
  object Ok: TButton
    Left = 110
    Top = 294
    Width = 75
    Height = 25
    Caption = 'Ok'
    ModalResult = 1
    TabOrder = 3
  end
  object Cancel: TButton
    Left = 228
    Top = 294
    Width = 75
    Height = 25
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 4
  end
  object prtcolor: TRadioGroup
    Left = 18
    Top = 199
    Width = 207
    Height = 82
    Caption = 'Color'
    Items.Strings = (
      'Color, Line mode'
      'Black/White, Line mode'
      'As on screen (black background!)')
    TabOrder = 5
    OnClick = prtcolorClick
  end
  object prtorient: TRadioGroup
    Left = 240
    Top = 199
    Width = 149
    Height = 82
    Caption = 'Orientation'
    Items.Strings = (
      'Portrait'
      'Landscape')
    TabOrder = 6
    OnClick = prtorientClick
  end
  object PrintDialog1: TPrintDialog
    Left = 376
  end
  object FolderDialog1: TFolderDialog
    Top = 32
    Left = 376
    Title = 'Browse for Folder'
  end
  object OpenDialog1: TOpenDialog
    Left = 376
    Top = 64
  end
end
