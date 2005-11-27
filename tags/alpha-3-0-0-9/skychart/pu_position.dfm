object f_position: Tf_position
  Left = 192
  Top = 289
  BorderStyle = bsToolWindow
  Caption = 'Position'
  ClientHeight = 223
  ClientWidth = 291
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Button1: TButton
    Left = 72
    Top = 184
    Width = 75
    Height = 25
    Caption = 'OK'
    ModalResult = 1
    TabOrder = 0
  end
  object Button2: TButton
    Left = 160
    Top = 184
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 1
  end
  object Panel1: TPanel
    Left = 8
    Top = 64
    Width = 273
    Height = 57
    TabOrder = 2
    object coord1: TLabel
      Left = 8
      Top = 32
      Width = 12
      Height = 13
      Caption = 'Az'
    end
    object coord2: TLabel
      Left = 152
      Top = 32
      Width = 12
      Height = 13
      Caption = 'Alt'
    end
    object coord: TLabel
      Left = 40
      Top = 4
      Width = 27
      Height = 13
      Caption = 'coord'
    end
    object long: TRaDec
      Left = 40
      Top = 28
      Width = 70
      Height = 21
      EditMask = '!999d99m99s;1; '
      MaxLength = 10
      TabOrder = 0
      Text = '000d00m00s'
      OnChange = CoordChange
      kind = Az
    end
    object lat: TRaDec
      Left = 184
      Top = 28
      Width = 72
      Height = 21
      EditMask = '!##9d99m99s;1; '
      MaxLength = 10
      TabOrder = 1
      Text = '+00d00m00s'
      OnChange = CoordChange
      kind = Alt
    end
  end
  object Panel2: TPanel
    Left = 8
    Top = 3
    Width = 273
    Height = 57
    TabOrder = 3
    object eq1: TLabel
      Left = 8
      Top = 32
      Width = 15
      Height = 13
      Caption = 'RA'
    end
    object eq2: TLabel
      Left = 152
      Top = 32
      Width = 15
      Height = 13
      Caption = 'DE'
    end
    object Equinox: TLabel
      Left = 40
      Top = 8
      Width = 38
      Height = 13
      Caption = 'Equinox'
    end
    object Ra: TRaDec
      Left = 40
      Top = 28
      Width = 73
      Height = 21
      EditMask = '!99h99m99s;1; '
      MaxLength = 9
      TabOrder = 0
      Text = '00h00m00s'
      OnChange = EqChange
      kind = RA
    end
    object De: TRaDec
      Left = 184
      Top = 28
      Width = 71
      Height = 21
      EditMask = '!##9d99m99s;1; '
      MaxLength = 10
      TabOrder = 1
      Text = '+00d00m00s'
      OnChange = EqChange
      kind = DE
    end
  end
  object Panel3: TPanel
    Left = 8
    Top = 126
    Width = 273
    Height = 41
    TabOrder = 4
    object Label3: TLabel
      Left = 8
      Top = 14
      Width = 21
      Height = 13
      Caption = 'FOV'
    end
    object Label4: TLabel
      Left = 136
      Top = 14
      Width = 40
      Height = 13
      Caption = 'Rotation'
    end
    object Fov: TRaDec
      Left = 40
      Top = 10
      Width = 72
      Height = 21
      EditMask = '!##9d99m99s;1; '
      MaxLength = 10
      TabOrder = 0
      Text = '+00d00m00s'
      kind = DE
    end
    object rot: TFloatEdit
      Left = 184
      Top = 9
      Width = 72
      Height = 22
      Hint = '-180..180'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 1
      MinValue = -180
      MaxValue = 180
      Digits = 5
    end
  end
end
