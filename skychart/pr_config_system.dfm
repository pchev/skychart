object f_config_system: Tf_config_system
  Left = 0
  Top = 0
  Width = 490
  Height = 440
  TabOrder = 0
  OnExit = FrameExit
  object pa_system: TPageControl
    Left = 0
    Top = 0
    Width = 490
    Height = 440
    ActivePage = t_telescope
    Align = alClient
    TabOrder = 0
    object t_system: TTabSheet
      Caption = 't_system'
      TabVisible = False
      object Label153: TLabel
        Left = 0
        Top = 0
        Width = 70
        Height = 13
        Caption = 'System Setting'
      end
      object MysqlBox: TGroupBox
        Left = 16
        Top = 48
        Width = 441
        Height = 97
        Caption = 'MySQL  Database'
        TabOrder = 0
        object Label77: TLabel
          Left = 16
          Top = 28
          Width = 49
          Height = 13
          Caption = 'DB Name:'
        end
        object Label84: TLabel
          Left = 168
          Top = 28
          Width = 56
          Height = 13
          Caption = 'Host Name:'
        end
        object Label85: TLabel
          Left = 328
          Top = 28
          Width = 22
          Height = 13
          Caption = 'Port:'
        end
        object Label86: TLabel
          Left = 16
          Top = 68
          Width = 33
          Height = 13
          Caption = 'Userid:'
        end
        object Label133: TLabel
          Left = 208
          Top = 68
          Width = 46
          Height = 13
          Caption = 'Password'
        end
        object dbname: TEdit
          Left = 80
          Top = 24
          Width = 65
          Height = 21
          TabOrder = 0
          Text = 'cdc'
          OnChange = dbnameChange
        end
        object dbport: TLongEdit
          Left = 368
          Top = 26
          Width = 57
          Height = 22
          TabOrder = 1
          OnChange = dbportChange
          Value = 3306
        end
        object dbhost: TEdit
          Left = 240
          Top = 24
          Width = 65
          Height = 21
          TabOrder = 2
          Text = 'dbhost'
          OnChange = dbhostChange
        end
        object dbuser: TEdit
          Left = 80
          Top = 64
          Width = 100
          Height = 21
          TabOrder = 3
          Text = 'dbuser'
          OnChange = dbuserChange
        end
        object dbpass: TEdit
          Left = 272
          Top = 64
          Width = 100
          Height = 21
          PasswordChar = '*'
          TabOrder = 4
          Text = 'dbpass'
          OnChange = dbpassChange
        end
      end
      object GroupBoxDir: TGroupBox
        Left = 16
        Top = 256
        Width = 441
        Height = 105
        Caption = 'Directory'
        TabOrder = 1
        object Label156: TLabel
          Left = 8
          Top = 24
          Width = 68
          Height = 13
          Caption = 'Program Data '
        end
        object Label157: TLabel
          Left = 8
          Top = 68
          Width = 65
          Height = 13
          Caption = 'Personal data'
        end
        object prgdir: TEdit
          Left = 104
          Top = 20
          Width = 233
          Height = 21
          TabOrder = 0
          OnChange = prgdirChange
        end
        object persdir: TEdit
          Left = 104
          Top = 64
          Width = 233
          Height = 21
          TabOrder = 1
          OnChange = persdirChange
        end
        object BitBtn1: TBitBtn
          Tag = 8
          Left = 338
          Top = 17
          Width = 26
          Height = 26
          TabOrder = 2
          TabStop = False
          OnClick = BitBtn1Click
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
        object BitBtn2: TBitBtn
          Tag = 8
          Left = 338
          Top = 61
          Width = 26
          Height = 26
          TabOrder = 3
          TabStop = False
          OnClick = BitBtn2Click
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
      object GroupBox1: TGroupBox
        Left = 16
        Top = 144
        Width = 441
        Height = 81
        TabOrder = 2
        object chkdb: TButton
          Left = 16
          Top = 16
          Width = 97
          Height = 25
          Caption = 'Check'
          TabOrder = 0
          OnClick = chkdbClick
        end
        object credb: TButton
          Left = 168
          Top = 16
          Width = 97
          Height = 25
          Caption = 'Create Database'
          TabOrder = 1
          OnClick = credbClick
        end
        object dropdb: TButton
          Left = 328
          Top = 16
          Width = 97
          Height = 25
          Caption = 'Drop Database'
          TabOrder = 2
          OnClick = dropdbClick
        end
        object CometDB: TButton
          Left = 168
          Top = 48
          Width = 97
          Height = 25
          Caption = 'Comet Setting'
          TabOrder = 3
          OnClick = CometDBClick
        end
        object AstDB: TButton
          Left = 16
          Top = 48
          Width = 97
          Height = 25
          Caption = 'Asteroid Setting'
          TabOrder = 4
          OnClick = AstDBClick
        end
      end
      object SqliteBox: TGroupBox
        Left = 16
        Top = 48
        Width = 441
        Height = 97
        Caption = 'Sqlite Database'
        TabOrder = 3
        Visible = False
        object Label1: TLabel
          Left = 16
          Top = 44
          Width = 68
          Height = 13
          Caption = 'Database file: '
        end
        object dbnamesqlite: TEdit
          Left = 128
          Top = 40
          Width = 281
          Height = 21
          Color = clBtnFace
          ReadOnly = True
          TabOrder = 0
          Text = 'dbnamesqlite'
          OnChange = dbnamesqliteChange
        end
      end
      object DBtypeGroup: TRadioGroup
        Left = 120
        Top = 0
        Width = 337
        Height = 41
        Hint = 'Warning! '#13#10'Change to this setting will restart the program now!'
        Caption = 'Database Type'
        Columns = 2
        ItemIndex = 0
        Items.Strings = (
          'SQLite'
          'MySQL')
        ParentShowHint = False
        ShowHint = True
        TabOrder = 4
        OnClick = DBtypeGroupClick
      end
    end
    object t_server: TTabSheet
      Caption = 't_server'
      ImageIndex = 1
      TabVisible = False
      object GroupBox3: TGroupBox
        Left = 16
        Top = 8
        Width = 393
        Height = 177
        Caption = 'TCP/IP Server'
        TabOrder = 0
        object Label54: TLabel
          Left = 16
          Top = 104
          Width = 95
          Height = 13
          Caption = 'Server IP Interface :'
        end
        object Label55: TLabel
          Left = 16
          Top = 140
          Width = 72
          Height = 13
          Caption = 'Server IP Port :'
        end
        object UseIPserver: TCheckBox
          Left = 16
          Top = 32
          Width = 345
          Height = 30
          Caption = 'Use TCP/IP Server'
          TabOrder = 0
          OnClick = UseIPserverClick
        end
        object ipaddr: TEdit
          Left = 144
          Top = 100
          Width = 100
          Height = 21
          TabOrder = 1
          Text = '127.0.0.1'
          OnChange = ipaddrChange
        end
        object ipport: TEdit
          Left = 144
          Top = 136
          Width = 100
          Height = 21
          TabOrder = 2
          Text = '3292'
          OnChange = ipportChange
        end
        object keepalive: TCheckBox
          Left = 16
          Top = 64
          Width = 345
          Height = 30
          Caption = 'Client Connection Keep Alive'
          TabOrder = 3
          OnClick = keepaliveClick
        end
      end
    end
    object t_telescope: TTabSheet
      Caption = 't_telescope'
      ImageIndex = 2
      TabVisible = False
      object Label13: TLabel
        Left = 0
        Top = 0
        Width = 86
        Height = 13
        Caption = 'Telescope Setting'
      end
      object TelescopeManual: TGroupBox
        Left = 8
        Top = 112
        Width = 449
        Height = 297
        Caption = 'Manual Mount'
        TabOrder = 3
        Visible = False
        object Label7: TLabel
          Left = 24
          Top = 24
          Width = 361
          Height = 41
          AutoSize = False
          Caption = 
            'Set how the mount move on each axis when you turn the driving kn' +
            'ob.'#13#10'Then the Telescope button show you the turns you must do to' +
            ' go from one object to another.'
          WordWrap = True
        end
        object EquatorialMount: TPanel
          Left = 24
          Top = 112
          Width = 361
          Height = 161
          TabOrder = 0
          object Label3: TLabel
            Left = 16
            Top = 16
            Width = 77
            Height = 13
            Caption = 'Right Ascension'
          end
          object Label4: TLabel
            Left = 16
            Top = 93
            Width = 53
            Height = 13
            Caption = 'Declination'
          end
          object Label5: TLabel
            Left = 240
            Top = 16
            Width = 55
            Height = 13
            Caption = 'turns / hour'
          end
          object Label6: TLabel
            Left = 240
            Top = 93
            Width = 67
            Height = 13
            Caption = 'turns / degree'
          end
          object TurnsRa: TFloatEdit
            Left = 128
            Top = 11
            Width = 81
            Height = 22
            ParentShowHint = False
            ShowHint = False
            TabOrder = 0
            OnChange = TurnsRaChange
          end
          object TurnsDec: TFloatEdit
            Left = 128
            Top = 88
            Width = 81
            Height = 22
            ParentShowHint = False
            ShowHint = False
            TabOrder = 1
            OnChange = TurnsDecChange
          end
          object RevertTurnsRa: TCheckBox
            Left = 128
            Top = 40
            Width = 177
            Height = 17
            Caption = 'Revert RA knob'
            TabOrder = 2
            OnClick = TurnsRaChange
          end
          object RevertTurnDec: TCheckBox
            Left = 128
            Top = 120
            Width = 193
            Height = 17
            Caption = 'Revert DEC knob'
            TabOrder = 3
            OnClick = TurnsDecChange
          end
        end
        object ManualMountType: TRadioGroup
          Left = 24
          Top = 64
          Width = 361
          Height = 41
          Columns = 2
          Items.Strings = (
            'Equatorial'
            'Alt / Az')
          TabOrder = 1
          OnClick = ManualMountTypeClick
        end
        object AltAzMount: TPanel
          Left = 24
          Top = 112
          Width = 361
          Height = 161
          TabOrder = 2
          object Label8: TLabel
            Left = 16
            Top = 16
            Width = 37
            Height = 13
            Caption = 'Azimuth'
          end
          object Label9: TLabel
            Left = 16
            Top = 93
            Width = 35
            Height = 13
            Caption = 'Altitude'
          end
          object Label10: TLabel
            Left = 240
            Top = 16
            Width = 67
            Height = 13
            Caption = 'turns / degree'
          end
          object Label11: TLabel
            Left = 240
            Top = 93
            Width = 67
            Height = 13
            Caption = 'turns / degree'
          end
          object TurnsAz: TFloatEdit
            Left = 128
            Top = 11
            Width = 81
            Height = 22
            ParentShowHint = False
            ShowHint = False
            TabOrder = 0
            OnChange = TurnsAzChange
          end
          object TurnsAlt: TFloatEdit
            Left = 128
            Top = 88
            Width = 81
            Height = 22
            ParentShowHint = False
            ShowHint = False
            TabOrder = 1
            OnChange = TurnsAltChange
          end
          object RevertTurnsAz: TCheckBox
            Left = 128
            Top = 40
            Width = 177
            Height = 17
            Caption = 'Revert Az knob'
            TabOrder = 2
            OnClick = TurnsAzChange
          end
          object RevertTurnsAlt: TCheckBox
            Left = 128
            Top = 120
            Width = 193
            Height = 17
            Caption = 'Revert Alt knob'
            TabOrder = 3
            OnClick = TurnsAltChange
          end
        end
      end
      object INDI: TGroupBox
        Left = 8
        Top = 112
        Width = 450
        Height = 257
        Caption = 'INDI Driver setting'
        TabOrder = 0
        object Label75: TLabel
          Left = 8
          Top = 28
          Width = 84
          Height = 13
          Caption = 'INDI Server Host '
        end
        object Label130: TLabel
          Left = 248
          Top = 28
          Width = 76
          Height = 13
          Caption = 'INDI server Port'
        end
        object Label258: TLabel
          Left = 8
          Top = 104
          Width = 108
          Height = 13
          Caption = 'INDI Server command '
        end
        object Label259: TLabel
          Left = 248
          Top = 136
          Width = 82
          Height = 13
          Caption = 'INDI Driver name'
        end
        object Label260: TLabel
          Left = 248
          Top = 104
          Width = 73
          Height = 13
          Caption = 'Telescope type'
        end
        object Label261: TLabel
          Left = 8
          Top = 180
          Width = 59
          Height = 13
          Caption = 'Device Port '
        end
        object Label2: TLabel
          Left = 16
          Top = 224
          Width = 115
          Height = 13
          Caption = 'Control Panel command '
        end
        object IndiServerHost: TEdit
          Left = 120
          Top = 24
          Width = 100
          Height = 21
          TabOrder = 0
          OnChange = IndiServerHostChange
        end
        object IndiServerPort: TEdit
          Left = 336
          Top = 24
          Width = 97
          Height = 21
          TabOrder = 1
          OnChange = IndiServerPortChange
        end
        object IndiAutostart: TCheckBox
          Left = 8
          Top = 64
          Width = 401
          Height = 30
          Caption = 'Automatically start a local server if not already running'
          TabOrder = 3
          OnClick = IndiAutostartClick
        end
        object IndiServerCmd: TEdit
          Left = 120
          Top = 100
          Width = 100
          Height = 21
          TabOrder = 5
          OnChange = IndiServerCmdChange
        end
        object IndiDriver: TEdit
          Left = 336
          Top = 132
          Width = 100
          Height = 21
          Enabled = False
          TabOrder = 2
          OnChange = IndiDriverChange
        end
        object IndiDev: TComboBox
          Left = 336
          Top = 100
          Width = 100
          Height = 21
          Style = csDropDownList
          ItemHeight = 13
          ItemIndex = 0
          TabOrder = 4
          OnChange = IndiDevChange
          Items.Strings = (
            '')
        end
        object IndiPort: TComboBox
          Left = 120
          Top = 176
          Width = 100
          Height = 21
          Style = csDropDownList
          ItemHeight = 13
          TabOrder = 6
          OnChange = IndiPortChange
          Items.Strings = (
            'COM1'
            'COM2'
            'COM3'
            'COM4'
            'COM5'
            'COM6'
            'COM7'
            'COM8')
        end
        object PanelCmd: TEdit
          Left = 152
          Top = 220
          Width = 257
          Height = 21
          TabOrder = 7
          OnChange = PanelCmdChange
        end
      end
      object TelescopeSelect: TRadioGroup
        Left = 8
        Top = 32
        Width = 450
        Height = 65
        Caption = 'TelescopeSelect'
        Columns = 3
        Items.Strings = (
          'INDI'
          'Manual'
          'CDC plugin')
        TabOrder = 1
        OnClick = TelescopeSelectClick
      end
      object TelescopePlugin: TGroupBox
        Left = 8
        Top = 112
        Width = 450
        Height = 105
        Caption = 'CDC plugin setting'
        TabOrder = 2
        Visible = False
        object Label155: TLabel
          Left = 24
          Top = 46
          Width = 85
          Height = 13
          Caption = 'Telescope Plugin '
        end
        object telescopepluginlist: TComboBox
          Left = 144
          Top = 42
          Width = 145
          Height = 21
          Style = csDropDownList
          ItemHeight = 13
          TabOrder = 0
          OnChange = telescopepluginlistChange
        end
      end
    end
  end
  object FolderDialog1: TFolderDialog
    Top = 8
    Left = 456
    Title = 'Browse for Folder'
  end
end
