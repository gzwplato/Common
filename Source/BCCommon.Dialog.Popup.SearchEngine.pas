unit BCCommon.Dialog.Popup.SearchEngine;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics, BCEditor.Types,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, sRadioButton, BCControl.RadioButton, VirtualTrees, sSkinProvider;

type
  TSelectSearchEngineEvent = procedure(ASearchEngine: TBCEditorSearchEngine) of object;

  TBCPopupSearchEngineDialog = class(TForm)
    SkinProvider: TsSkinProvider;
    VirtualDrawTree: TVirtualDrawTree;
    procedure VirtualDrawTreeDblClick(Sender: TObject);
    procedure VirtualDrawTreeDrawNode(Sender: TBaseVirtualTree; const PaintInfo: TVTPaintInfo);
    procedure VirtualDrawTreeFreeNode(Sender: TBaseVirtualTree; Node: PVirtualNode);
    procedure VirtualDrawTreeGetNodeWidth(Sender: TBaseVirtualTree; HintCanvas: TCanvas; Node: PVirtualNode;
      Column: TColumnIndex; var NodeWidth: Integer);
  private
    { Private declarations }
    FSelectSearchEngine: TSelectSearchEngineEvent;
    procedure WMActivate(var AMessage: TWMActivate); message WM_ACTIVATE;
  public
    { Public declarations }
    procedure Execute(const ASelectedSearchEngine: TBCEditorSearchEngine);
    property OnSelectSearchEngine: TSelectSearchEngineEvent read FSelectSearchEngine write FSelectSearchEngine;
  end;

implementation

{$R *.dfm}

uses
  System.Math, System.Types, BCCommon.Utils, BCCommon.Language.Strings, acPopupController, sVclUtils;

type
  PSearchRec = ^TSearchRec;
  TSearchRec = packed record
    SearchEngine: TBCEditorSearchEngine;
    Name: string;
  end;

procedure TBCPopupSearchEngineDialog.VirtualDrawTreeDblClick(Sender: TObject);
var
  LNode: PVirtualNode;
  LData: PSearchRec;
begin
  LNode := VirtualDrawTree.GetFirstSelected;
  LData := VirtualDrawTree.GetNodeData(LNode);
  if Assigned(LData) then
    if Assigned(FSelectSearchEngine) then
      FSelectSearchEngine(LData.SearchEngine);
  Hide;
end;

procedure TBCPopupSearchEngineDialog.VirtualDrawTreeDrawNode(Sender: TBaseVirtualTree; const PaintInfo: TVTPaintInfo);
var
  LData: PSearchRec;
  LName: string;
  LRect: TRect;
  LFormat: Cardinal;
begin
  with Sender as TVirtualDrawTree, PaintInfo do
  begin
    LData := Sender.GetNodeData(Node);

    if not Assigned(LData) then
      Exit;

    Canvas.Font.Color := SkinProvider.SkinData.SkinManager.GetActiveEditFontColor;

    if vsSelected in PaintInfo.Node.States then
    begin
      Canvas.Brush.Color := SkinProvider.SkinData.SkinManager.GetHighLightColor;
      Canvas.Font.Color := SkinProvider.SkinData.SkinManager.GetHighLightFontColor
    end;

    SetBKMode(Canvas.Handle, TRANSPARENT);

    LRect := ContentRect;
    InflateRect(LRect, -TextMargin, 0);
    Dec(LRect.Right);
    Dec(LRect.Bottom);

    LName := LData.Name;

    if Length(LName) > 0 then
    begin
      LFormat := DT_TOP or DT_LEFT or DT_VCENTER or DT_SINGLELINE;
      DrawText(Canvas.Handle, LName, Length(LName), LRect, LFormat);
    end;
  end;
end;

procedure TBCPopupSearchEngineDialog.VirtualDrawTreeFreeNode(Sender: TBaseVirtualTree; Node: PVirtualNode);
var
  LData: PSearchRec;
begin
  LData := Sender.GetNodeData(Node);
  Finalize(LData^);

  inherited;
end;

procedure TBCPopupSearchEngineDialog.VirtualDrawTreeGetNodeWidth(Sender: TBaseVirtualTree; HintCanvas: TCanvas;
  Node: PVirtualNode; Column: TColumnIndex; var NodeWidth: Integer);
var
  LData: PSearchRec;
  LMargin: Integer;
begin
  with Sender as TVirtualDrawTree do
  begin
    LMargin := TextMargin;
    LData := GetNodeData(Node);
    if Assigned(LData) then
      NodeWidth := Canvas.TextWidth(LData.Name) + 2 * LMargin;
  end;
end;

procedure TBCPopupSearchEngineDialog.WMActivate(var AMessage: TWMActivate);
begin
  if AMessage.Active <> WA_INACTIVE then
    SendMessage(Self.PopupParent.Handle, WM_NCACTIVATE, WPARAM(True), -1);

  inherited;
end;

procedure TBCPopupSearchEngineDialog.Execute(const ASelectedSearchEngine: TBCEditorSearchEngine);
var
  LWidth, LMaxWidth: Integer;

  procedure AddSearchEngine(const ASearchEngine: TBCEditorSearchEngine; AName: string);
  var
    LNode: PVirtualNode;
    LNodeData: PSearchRec;
  begin
    LNode := VirtualDrawTree.AddChild(nil);
    LNodeData := VirtualDrawTree.GetNodeData(LNode);

    LWidth := VirtualDrawTree.Canvas.TextWidth(AName);
    if LWidth > LMaxWidth then
      LMaxWidth := LWidth;

    LNodeData.SearchEngine := ASearchEngine;
    LNodeData.Name := AName;
    VirtualDrawTree.Selected[LNode] := ASelectedSearchEngine = ASearchEngine;
  end;

begin
  LMaxWidth := 0;

  VirtualDrawTree.Clear;

  AddSearchEngine(seNormal, LanguageDataModule.GetConstant('Normal'));
  AddSearchEngine(seRegularExpression, LanguageDataModule.GetConstant('RegularExpression'));
  AddSearchEngine(seWildcard, LanguageDataModule.GetConstant('Wildcard'));

  VirtualDrawTree.Invalidate;

  Width := LMaxWidth + ScaleSize(80);
  Height := Min(Integer(VirtualDrawTree.DefaultNodeHeight) * 3 + VirtualDrawTree.BorderWidth * 2 + ScaleSize(2), TForm(Self.PopupParent).Height);

  ShowPopupForm(Self, acMousePos);
end;

end.
