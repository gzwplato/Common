object SearchForFilesForm: TSearchForFilesForm
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  Caption = 'Search for Files'
  ClientHeight = 401
  ClientWidth = 383
  Color = clWindow
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Icon.Data = {
    0000010001001010000001002000280400001600000028000000100000002000
    0000010020000000000000000000000000000000000000000000000000000000
    0000AEAEABFFAEAEABFFAEAEABFFAEAEABFFAEAEABFFAEAEABFFAEAEABFFAEAE
    ABFFAEAEABFFAEAEABFFAEAEABFFAEAEABFFAEAEABFF00000000000000000000
    0000AEAEABFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
    FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFAEAEABFF00000000000000000000
    0000AEAEABFFFFFFFFFFFDFDFDFFFCFCFCFFFCFCFCFFFCFCFCFFFCFCFCFFFCFC
    FCFFFCFCFCFFFCFCFCFFFDFDFDFFFFFFFFFFAEAEABFF00000000000000000000
    0000AEAEABFFFFFFFFFFFAF9F9FFF9F8F8FFF9F8F8FFF9F8F8FFF9F8F8FFF9F8
    F8FFF9F8F8FFF9F8F8FFFAF9F9FFFFFFFFFFAEAEABFF00000000000000000000
    0000AEAEABFFFFFFFFFFF6F6F6FFF6F6F6FFF6F6F6FFF6F6F6FFF6F6F6FFF6F6
    F6FFF6F6F6FFF6F6F6FFF6F6F6FFFFFFFFFFAEAEABFF00000000000000000000
    0000AEAEABFFFFFFFFFFF4F4F3FFF4F4F3FFF4F4F3FFF4F4F3FFF4F4F3FFF4F4
    F3FFF4F4F3FFF4F4F3FFF4F4F3FFFFFFFFFFAEAEABFF00000000000000000000
    0000AEAEABFFFFFFFFFFF2F1F0FFF2F1F0FFF2F1F0FFF2F1F0FFF2F1F0FFF2F1
    F0FFF2F1F0FFF2F1F0FFF2F1F0FFFFFFFFFFAEAEABFF00000000000000000000
    0000AEAEABFFFFFFFFFFEFEFEEFFEFEFEEFFEFEFEEFFEFEFEEFFEFEFEEFFEFEF
    EEFFEFEFEEFFEEEEEDFFEEEFEEFFFFFFFFFFAEAEABFF00000000000000000000
    0000AEAEABFFFFFFFFFFEDEBEAFFEDECEBFFEDECEBFFEDECEBFFEDECEBFFECEB
    EAFFECEBE9FFEBEAE9FFECEAE9FFFFFFFFFFAEAEABFF00000000000000000000
    0000AEAEABFFFFFFFFFFE9E9E8FFEAEAE9FFEAEAE9FFEAEAE9FFE9E9E8FFF4F4
    F2FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFAEAEABFF00000000000000000000
    0000AEAEABFFFFFFFFFFE7E6E5FFE8E7E6FFE8E7E6FFE8E7E6FFE6E5E4FFFFFF
    FFFFCBCCCBFFA5A5A3FFA5A5A3FFFFFFFFFFAEAEABFF00000000000000000000
    0000AEAEABFFFFFFFFFFE3E3E2FFE4E4E3FFE4E5E4FFE4E4E3FFE3E3E2FFFFFF
    FFFFA5A5A3FFEBEBEAFFFFFFFFFFEAEAEAFFAEAEABFF00000000000000000000
    0000AEAEABFFFFFFFFFFE0DFDDFFE0DFDEFFE0DFDEFFE0DFDEFFDFDEDCFFFFFF
    FFFFA5A5A3FFFFFFFFFFE9E9E9FFAEAEABFF0000000000000000000000000000
    0000AEAEABFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
    FFFFFFFFFFFFEAEAEAFFAEAEABFF000000000000000000000000000000000000
    0000B3B3B1FFAEAEABFFAEAEABFFAEAEABFFAEAEABFFAEAEABFFAEAEABFFAEAE
    ABFFAEAEABFFAEAEABFF00000000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    000000000000000000000000000000000000000000000000000000000000}
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnResize = FormResize
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object SearchingFilesPanel: TPanel
    Left = 0
    Top = 24
    Width = 383
    Height = 358
    Align = alClient
    BevelOuter = bvNone
    Caption = 'Searching files...'
    ParentColor = True
    TabOrder = 2
    Visible = False
  end
  object SearchForEdit: TBCButtonedEdit
    AlignWithMargins = True
    Left = 3
    Top = 3
    Width = 377
    Height = 21
    Margins.Bottom = 0
    Align = alTop
    DoubleBuffered = True
    Images = ImageList
    LeftButton.Enabled = False
    ParentDoubleBuffered = False
    RightButton.HotImageIndex = 1
    RightButton.ImageIndex = 0
    RightButton.PressedImageIndex = 2
    TabOrder = 0
    OnChange = SearchActionExecute
    OnRightButtonClick = ClearActionExecute
  end
  object SearchVirtualDrawTree: TVirtualDrawTree
    AlignWithMargins = True
    Left = 3
    Top = 27
    Width = 377
    Height = 352
    Align = alClient
    Header.AutoSizeIndex = 0
    Header.Font.Charset = DEFAULT_CHARSET
    Header.Font.Color = clWindowText
    Header.Font.Height = -11
    Header.Font.Name = 'Tahoma'
    Header.Font.Style = []
    Header.MainColumn = -1
    Indent = 0
    TabOrder = 1
    TreeOptions.MiscOptions = [toFullRepaintOnResize, toInitOnSave, toToggleOnDblClick, toWheelPanning]
    TreeOptions.PaintOptions = [toShowRoot, toThemeAware]
    OnCompareNodes = SearchVirtualDrawTreeCompareNodes
    OnDblClick = SearchVirtualDrawTreeDblClick
    OnDrawNode = SearchVirtualDrawTreeDrawNode
    OnFreeNode = SearchVirtualDrawTreeFreeNode
    OnGetImageIndex = SearchVirtualDrawTreeGetImageIndex
    OnGetNodeWidth = SearchVirtualDrawTreeGetNodeWidth
    Columns = <>
  end
  object StatusBar: TStatusBar
    Left = 0
    Top = 382
    Width = 383
    Height = 19
    Panels = <
      item
        Width = 300
      end>
  end
  object ActionList: TActionList
    Left = 196
    Top = 104
    object ClearAction: TAction
      Caption = 'ClearAction'
      OnExecute = ClearActionExecute
    end
    object SearchAction: TAction
      Caption = 'SearchAction'
      OnExecute = SearchActionExecute
    end
  end
  object ImageList: TBCImageList
    Left = 142
    Top = 112
    Bitmap = {
      494C010103000500040010001000FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000001000000001002000000000000010
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000007171710071717100000000000000000000000000717171007171
      7100000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000717171007171710000000000000000000000000071717100717171000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000717171007171710000000000000000000000000071717100717171000000
      0000000000000000000000000000000000000000000000000000000000000000
      000071717100FFFFFF00FFFFFF00717171000000000071717100FFFFFF00FFFF
      FF00717171000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000007171
      7100DBDBDB00DBDBDB00717171000000000071717100DBDBDB00DBDBDB007171
      7100000000000000000000000000000000000000000000000000000000007171
      7100FFFFFF00FFFFFF00717171000000000071717100FFFFFF00FFFFFF007171
      7100000000000000000000000000000000000000000000000000000000000000
      000071717100FFFFFF00FFFFFF00FFFFFF0071717100FFFFFF00FFFFFF00FFFF
      FF00717171000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000007171
      7100DBDBDB00DBDBDB00DBDBDB0071717100DBDBDB00DBDBDB00DBDBDB007171
      7100000000000000000000000000000000000000000000000000000000007171
      7100FFFFFF00FFFFFF00FFFFFF0071717100FFFFFF00FFFFFF00FFFFFF007171
      7100000000000000000000000000000000000000000000000000000000000000
      00000000000071717100FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF007878
      7800000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000071717100DBDBDB00DBDBDB00DBDBDB00DBDBDB00DBDBDB00787878000000
      0000000000000000000000000000000000000000000000000000000000000000
      000071717100FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00787878000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000071717100FFFFFF00FFFFFF00FFFFFF00717171000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000071717100DBDBDB00DBDBDB00DBDBDB0071717100000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000071717100FFFFFF00FFFFFF00FFFFFF0071717100000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000071717100FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF007171
      7100000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000071717100DBDBDB00DBDBDB00DBDBDB00DBDBDB00DBDBDB00717171000000
      0000000000000000000000000000000000000000000000000000000000000000
      000071717100FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00717171000000
      0000000000000000000000000000000000000000000000000000000000000000
      000071717100FFFFFF00FFFFFF00FFFFFF0071717100FFFFFF00FFFFFF00FFFF
      FF00717171000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000007171
      7100DBDBDB00DBDBDB00DBDBDB0071717100DBDBDB00DBDBDB00DBDBDB007171
      7100000000000000000000000000000000000000000000000000000000007171
      7100FFFFFF00FFFFFF00FFFFFF0071717100FFFFFF00FFFFFF00FFFFFF007171
      7100000000000000000000000000000000000000000000000000000000000000
      000071717100FFFFFF00FFFFFF00717171000000000071717100FFFFFF00FFFF
      FF00717171000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000007171
      7100DBDBDB00DBDBDB00717171000000000071717100DBDBDB00DBDBDB007171
      7100000000000000000000000000000000000000000000000000000000007171
      7100FFFFFF00FFFFFF00717171000000000071717100FFFFFF00FFFFFF007171
      7100000000000000000000000000000000000000000000000000000000000000
      0000000000007171710071717100000000000000000000000000717171007171
      7100000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000717171007171710000000000000000000000000071717100717171000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000717171007171710000000000000000000000000071717100717171000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000040000000100000000100010000000000800000000000000000000000
      000000000000000000000000FFFFFF00FFFFFFFFFFFF0000FFFFFFFFFFFF0000
      FFFFFFFFFFFF0000FFFFFFFFF9CF0000F39FF39FF0870000E10FE10FF0070000
      E00FE00FF80F0000F01FF01FFC1F0000F83FF83FF80F0000F01FF01FF0070000
      E00FE00FF0870000E10FE10FF9CF0000F39FF39FFFFF0000FFFFFFFFFFFF0000
      FFFFFFFFFFFF0000FFFFFFFFFFFF000000000000000000000000000000000000
      000000000000}
  end
end
