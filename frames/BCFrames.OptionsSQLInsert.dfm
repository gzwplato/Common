inherited OptionsSQLInsertFrame: TOptionsSQLInsertFrame
  Width = 284
  Height = 150
  ExplicitWidth = 284
  ExplicitHeight = 150
  object Panel: TPanel
    Left = 0
    Top = 0
    Width = 284
    Height = 150
    BevelOuter = bvNone
    Color = clWindow
    ParentBackground = False
    TabOrder = 0
    object ColumnListStyleLabel: TLabel
      Left = 6
      Top = 0
      Width = 77
      Height = 13
      Caption = 'Column list style'
    end
    object ValueListStyleLabel: TLabel
      Left = 6
      Top = 42
      Width = 68
      Height = 13
      Caption = 'Value list style'
    end
    object InsertColumnsPerLineLabel: TLabel
      Left = 6
      Top = 84
      Width = 108
      Height = 13
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'Insert columns per line'
    end
    object ParenthesisInSeparateLinesCheckBox: TBCCheckBox
      Left = 4
      Top = 125
      Width = 282
      Height = 21
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = ' Parenthesis in separate lines'
      Checked = True
      State = cbChecked
      TabOrder = 2
      ReadOnly = False
    end
    object ColumnListStyleComboBox: TBCComboBox
      Left = 4
      Top = 16
      Width = 186
      Height = 22
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Style = csOwnerDrawFixed
      DropDownCount = 9
      TabOrder = 0
      DeniedKeyStrokes = True
      ReadOnly = False
      DropDownFixedWidth = 0
    end
    object ValueListStyleComboBox: TBCComboBox
      Left = 4
      Top = 58
      Width = 186
      Height = 22
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Style = csOwnerDrawFixed
      DropDownCount = 9
      TabOrder = 1
      DeniedKeyStrokes = True
      ReadOnly = False
      DropDownFixedWidth = 0
    end
    object InsertColumnsPerLineEdit: TBCEdit
      Left = 4
      Top = 100
      Width = 64
      Height = 21
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      AutoSize = False
      TabOrder = 3
      Text = '0'
      EnterToTab = False
      OnlyNumbers = True
      NumbersWithDots = False
      NumbersWithSpots = False
      ErrorColor = 14803198
      NumbersAllowNegative = False
    end
  end
end
