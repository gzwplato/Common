unit BCCommon.Frames.Options.Editor.Font;

interface

uses
  System.SysUtils, System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.Buttons,
  Vcl.StdCtrls, Vcl.ActnList, System.Actions, Vcl.ComCtrls, Vcl.ImgList,
  BCControls.ImageList, BCControls.Edit, BCControls.Panel,
  BCCommon.Frames.Options.Base, acAlphaImageList, sEdit, sPanel, sFrameAdapter, sComboBox,
  BCControls.ComboBox, sFontCtrls, JsonDataObjects, System.ImageList;

type
  TOptionsEditorFontFrame = class(TBCOptionsBaseFrame)
    BookmarkImagesList: TBCImageList;
    ComboBoxColor: TBCComboBox;
    ComboBoxElement: TBCComboBox;
    EditFontSize: TBCEdit;
    FontComboBoxFont: TBCFontComboBox;
    Panel: TBCPanel;
    procedure ComboBoxElementChange(Sender: TObject);
    procedure ComboBoxColorChange(Sender: TObject);
    procedure FontComboBoxFontChange(Sender: TObject);
    procedure EditFontSizeChange(Sender: TObject);
  private
    FFileName: string;
    FJSONObject: TJsonObject;
    FModified: Boolean;
    function GetColorFileName: string;
    procedure FreeJSONObject;
    procedure SaveFont(ADoChange: Boolean = True);
  protected
    procedure Init; override;
  public
    destructor Destroy; override;
  end;

function OptionsEditorFontFrame(AOwner: TComponent): TOptionsEditorFontFrame;

implementation

{$R *.dfm}

uses
  BCCommon.Options.Container, BCCommon.StringUtils;

var
  FOptionsEditorFontFrame: TOptionsEditorFontFrame;

function OptionsEditorFontFrame(AOwner: TComponent): TOptionsEditorFontFrame;
begin
  if not Assigned(FOptionsEditorFontFrame) then
    FOptionsEditorFontFrame := TOptionsEditorFontFrame.Create(AOwner);
  Result := FOptionsEditorFontFrame;
end;

procedure TOptionsEditorFontFrame.FontComboBoxFontChange(Sender: TObject);
begin
  FModified := True;
  FJSONObject['Colors']['Editor']['Fonts'][CapitalizeText(ComboBoxElement.Text)] := FontComboBoxFont.Text;
  SaveFont(False);
end;

procedure TOptionsEditorFontFrame.FreeJSONObject;
begin
  if Assigned(FJSONObject) then
  begin
    FJSONObject.Free;
    FJSONObject := nil;
  end;
end;

function TOptionsEditorFontFrame.GetColorFileName: string;
begin
  Result := Format('%sColors\%s.json', [ExtractFilePath(Application.ExeName), FFileName]);
end;

procedure TOptionsEditorFontFrame.SaveFont(ADoChange: Boolean = True);
begin
  if Assigned(FJSONObject) then
  begin
    JsonSerializationConfig.IndentChar := '    ';
    FJSONObject.SaveToFile(GetColorFileName, False);
    if ADoChange then
      ComboBoxElementChange(Self);
  end;
end;

procedure TOptionsEditorFontFrame.ComboBoxColorChange(Sender: TObject);
var
  LFileName: string;
begin
  if FModified then
    SaveFont(False);

  FFileName := ComboBoxColor.Text;
  LFileName := GetColorFileName;

  FModified := False;
  FreeJSONObject;
  FJSONObject := TJsonObject.ParseFromFile(LFileName) as TJsonObject;

  ComboBoxElementChange(Self);
end;

procedure TOptionsEditorFontFrame.ComboBoxElementChange(Sender: TObject);
var
  LFont: string;
begin
  LFont := FJSONObject['Colors']['Editor']['Fonts'][CapitalizeText(ComboBoxElement.Text)];
  if LFont <> '' then
    FontComboBoxFont.ItemIndex := FontComboBoxFont.Items.IndexOf(LFont);
  EditFontSize.Text := FJSONObject['Colors']['Editor']['FontSizes'][CapitalizeText(ComboBoxElement.Text)];
end;

destructor TOptionsEditorFontFrame.Destroy;
begin
  FreeJSONObject;
  FOptionsEditorFontFrame := nil;
  inherited;
end;

procedure TOptionsEditorFontFrame.EditFontSizeChange(Sender: TObject);
begin
  FModified := True;
  FJSONObject['Colors']['Editor']['FontSizes'][CapitalizeText(ComboBoxElement.Text)] := EditFontSize.Text;
  SaveFont(False);
end;

procedure TOptionsEditorFontFrame.Init;
begin
  FModified := False;
  ComboBoxColor.Items := OptionsContainer.ColorStrings;
  ComboBoxColor.ItemIndex := ComboBoxColor.Items.IndexOf(OptionsContainer.DefaultColor);
  FFileName := ComboBoxColor.Text;
  ComboBoxColorChange(Self);
end;

end.
