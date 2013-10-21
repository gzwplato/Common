unit BCDialogs.DownloadURL;

interface

uses
  System.SysUtils, System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.ActnList, Vcl.StdCtrls, Vcl.ComCtrls,
  JvExComCtrls, BCControls.ProgressBar, Vcl.ExtCtrls, Vcl.ExtActns, BCDialogs.Dlg, System.Actions, JvProgressBar;

type
  TDownloadURLDialog = class(TDialog)
    ActionList: TActionList;
    Button: TButton;
    CancelAction: TAction;
    InformationLabel: TLabel;
    OKAction: TAction;
    Panel1: TPanel;
    ProgressBar: TBCProgressBar;
    ProgressPanel: TPanel;
    TopPanel: TPanel;
    procedure CancelActionExecute(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure OKActionExecute(Sender: TObject);
  private
    { Private declarations }
    FCancel: Boolean;
    procedure OnURLDownloadProgress(Sender: TDownLoadURL; Progress, ProgressMax: Cardinal;
      StatusCode: TURLDownloadStatus; StatusText: String; var Cancel: Boolean);
    procedure SetInformationText(Value: string);
  public
    { Public declarations }
    function Open(DefaultFileName: string; DownloadURL: string): string;
  end;

function DownloadURLDialog: TDownloadURLDialog;

implementation

{$R *.dfm}

uses
  BCCommon.LanguageStrings, BCCommon.Dialogs;

var
  FDownloadURLDialog: TDownloadURLDialog;

function DownloadURLDialog: TDownloadURLDialog;
begin
  if not Assigned(FDownloadURLDialog) then
    Application.CreateForm(TDownloadURLDialog, FDownloadURLDialog);
  Result := FDownloadURLDialog;
end;

procedure TDownloadURLDialog.CancelActionExecute(Sender: TObject);
begin
  FCancel := True;
  InformationLabel.Caption := LanguageDataModule.GetConstant('DownloadCancelling');
  Repaint;
  Application.ProcessMessages;
  Close;
end;

procedure TDownloadURLDialog.FormDestroy(Sender: TObject);
begin
  FDownloadURLDialog := nil;
end;

procedure TDownloadURLDialog.SetInformationText(Value: string);
begin
  InformationLabel.Caption := Value;
  Invalidate;
  Application.ProcessMessages;
end;

function TDownloadURLDialog.Open(DefaultFileName: string; DownloadURL: string): string;
var
  FilterIndex: Cardinal;
begin
  FCancel := False;
  Result := '';
  Button.Action := CancelAction;
  Application.ProcessMessages;
  if BCCommon.Dialogs.SaveFile(Handle, '', Trim(StringReplace(LanguageDataModule.GetFileTypes('Zip')
        , '|', #0, [rfReplaceAll])) + #0#0,
        LanguageDataModule.GetConstant('SaveAs'), FilterIndex, DefaultFileName, 'zip') then
  begin
    SetInformationText(DownloadURL);
    Application.ProcessMessages;
    with TDownloadURL.Create(Self) do
    try
      URL := DownloadURL;
      FileName := BCCommon.Dialogs.Files[0];
      Result := FileName;
      OnDownloadProgress := OnURLDownloadProgress;
      ExecuteTarget(nil);
    finally
      Free;
    end;
  end
  else
    Close;
  SetInformationText(LanguageDataModule.GetConstant('DownloadDone'));
  Button.Action := OKAction;
end;

procedure TDownloadURLDialog.OKActionExecute(Sender: TObject);
begin
  Close;
end;

procedure TDownloadURLDialog.OnURLDownloadProgress;
begin
  ProgressBar.Max := ProgressMax;
  ProgressBar.Position := Progress;
  Invalidate;
  Cancel := FCancel;
  Application.ProcessMessages;
end;

end.
