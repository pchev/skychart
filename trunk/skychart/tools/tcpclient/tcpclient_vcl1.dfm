object Form1: TForm1
  Left = 63
  Top = 319
  Width = 352
  Height = 416
  HorzScrollBar.Range = 331
  VertScrollBar.Range = 377
  ActiveControl = Edit1
  AutoScroll = False
  Caption = 'TCP Client'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = True
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 84
    Height = 13
    Caption = 'Server IP address'
  end
  object Label2: TLabel
    Left = 104
    Top = 8
    Width = 53
    Height = 13
    Caption = 'Server Port'
  end
  object Label3: TLabel
    Left = 8
    Top = 88
    Width = 69
    Height = 13
    Caption = 'Command line:'
  end
  object Edit1: TEdit
    Left = 8
    Top = 24
    Width = 89
    Height = 21
    TabOrder = 0
    Text = '127.0.0.1'
  end
  object Edit2: TEdit
    Left = 104
    Top = 24
    Width = 65
    Height = 21
    TabOrder = 1
    Text = '3292'
  end
  object Button1: TButton
    Left = 176
    Top = 22
    Width = 75
    Height = 25
    Caption = 'Connect'
    TabOrder = 2
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 256
    Top = 22
    Width = 75
    Height = 25
    Caption = 'Disconnect'
    TabOrder = 3
    OnClick = Button2Click
  end
  object Edit3: TEdit
    Left = 8
    Top = 56
    Width = 161
    Height = 21
    Color = clBtnFace
    ReadOnly = True
    TabOrder = 5
  end
  object Button3: TButton
    Left = 256
    Top = 102
    Width = 75
    Height = 25
    Caption = 'Send'
    TabOrder = 7
    OnClick = Button3Click
  end
  object Memo1: TMemo
    Left = 8
    Top = 144
    Width = 321
    Height = 233
    ScrollBars = ssVertical
    TabOrder = 4
  end
  object ComboBox1: TComboBox
    Left = 8
    Top = 104
    Width = 241
    Height = 21
    ItemHeight = 13
    TabOrder = 6
    Text = 'listchart'
    OnKeyDown = Combobox1KeyDown
    Items.Strings = (
      'newchart tcpclient'
      'selectchart tcpclient'
      'closechart tcpclient'
      'listchart'
      'search m51'
      'getmsgbox'
      'getcoordbox'
      'zoom+'
      'zoom-'
      'fov 15d0m0s'
      'movenorth'
      'movesoutheast'
      'flipx'
      'flipy'
      'rot+'
      'rot-'
      'eqgrid on'
      'azgrid on'
      'undo'
      'redo'
      'proj equat'
      'move "RA:18h25m0s DEC:-24d0m0s"'
      'date 2003-05-20T22:34:00'
      'obsl "LAT:+30d00m00.0s LON:-105d00m00.0s ALT:120m OBS:Myobs"'
      'setcursor 200 200'
      'idcursor'
      'centre'
      'zoom+move'
      'saveimg PNG "test image.png"')
  end
  object Button4: TButton
    Left = 176
    Top = 56
    Width = 75
    Height = 25
    Caption = 'Create chart'
    TabOrder = 8
    OnClick = Button4Click
  end
end
