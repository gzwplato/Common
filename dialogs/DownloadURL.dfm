object DownloadURLDialog: TDownloadURLDialog
  Left = 0
  Top = 0
  BorderStyle = bsToolWindow
  Caption = 'Download'
  ClientHeight = 116
  ClientWidth = 364
  Color = clActiveBorder
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  Visible = True
  OnDestroy = FormDestroy
  DesignSize = (
    364
    116)
  PixelsPerInch = 96
  TextHeight = 13
  object TopPanel: TPanel
    Left = 1
    Top = 1
    Width = 362
    Height = 74
    Anchors = [akLeft, akTop, akRight]
    BevelEdges = []
    BevelOuter = bvNone
    BorderWidth = 1
    Color = clWhite
    Ctl3D = True
    ParentBackground = False
    ParentCtl3D = False
    TabOrder = 0
    DesignSize = (
      362
      74)
    object InformationLabel: TLabel
      Left = -4
      Top = 18
      Width = 366
      Height = 13
      Alignment = taCenter
      Anchors = [akLeft, akTop, akRight]
      AutoSize = False
      Caption = 'InformationLabel'
      ExplicitWidth = 372
    end
    object ProgressBar: TJvProgressBar
      Left = 12
      Top = 44
      Width = 341
      Height = 17
      Anchors = [akLeft, akTop, akRight]
      DoubleBuffered = False
      ParentDoubleBuffered = False
      TabOrder = 0
    end
  end
  object ProgressPanel: TPanel
    Left = 1
    Top = 76
    Width = 362
    Height = 40
    Anchors = [akLeft, akRight, akBottom]
    BevelOuter = bvNone
    Ctl3D = True
    ParentBackground = False
    ParentCtl3D = False
    TabOrder = 1
    DesignSize = (
      362
      40)
    object Button: TButton
      Left = 147
      Top = 7
      Width = 67
      Height = 25
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Action = CancelAction
      Anchors = [akLeft, akRight]
      Cancel = True
      Default = True
      ModalResult = 2
      TabOrder = 0
    end
  end
  object ActionList: TActionList
    Left = 300
    Top = 20
    object CancelAction: TAction
      Caption = 'Cancel'
      OnExecute = CancelActionExecute
    end
    object OKAction: TAction
      Caption = '&OK'
      OnExecute = OKActionExecute
    end
  end
  object SaveDialog: TSaveDialog
    DefaultExt = 'zip'
    Filter = 'Zip files (*.zip)|*.zip'
    Title = 'Save As...'
    Left = 300
    Top = 68
  end
end
