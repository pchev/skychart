object f_manualtelescope: Tf_manualtelescope
  Left = 222
  Top = 198
  BorderStyle = bsNone
  Caption = 'Manual Telescope'
  ClientHeight = 112
  ClientWidth = 415
  Color = clBlack
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  OnMouseDown = FormMouseDown
  OnMouseMove = FormMouseMove
  OnMouseUp = FormMouseUp
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 415
    Height = 112
    Align = alClient
    Color = clBlack
    TabOrder = 0
    OnDblClick = Panel1DblClick
    OnMouseDown = FormMouseDown
    OnMouseMove = FormMouseMove
    OnMouseUp = FormMouseUp
    object Label1: TLabel
      Left = 16
      Top = 4
      Width = 88
      Height = 13
      Caption = 'Manual Telescope'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clRed
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      Transparent = True
      OnDblClick = Panel1DblClick
      OnMouseDown = FormMouseDown
      OnMouseMove = FormMouseMove
      OnMouseUp = FormMouseUp
    end
    object Label2: TLabel
      Left = 16
      Top = 20
      Width = 57
      Height = 13
      Caption = '                   '
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clRed
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      Transparent = True
      OnDblClick = Panel1DblClick
      OnMouseDown = FormMouseDown
      OnMouseMove = FormMouseMove
      OnMouseUp = FormMouseUp
    end
    object Label4: TLabel
      Left = 16
      Top = 32
      Width = 134
      Height = 37
      Caption = 'RA turns:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clRed
      Font.Height = -32
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      Transparent = True
      OnDblClick = Panel1DblClick
      OnMouseDown = FormMouseDown
      OnMouseMove = FormMouseMove
      OnMouseUp = FormMouseUp
    end
    object Label5: TLabel
      Left = 16
      Top = 64
      Width = 157
      Height = 37
      Caption = 'DEC turns:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clRed
      Font.Height = -32
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      Transparent = True
      OnDblClick = Panel1DblClick
      OnMouseDown = FormMouseDown
      OnMouseMove = FormMouseMove
      OnMouseUp = FormMouseUp
    end
  end
end
