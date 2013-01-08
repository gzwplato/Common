unit Language;

interface

uses
  System.SysUtils, System.Classes, JvStringHolder;

type
  TLanguageDataModule = class(TDataModule)
    YesOrNoMultiStringHolder: TJvMultiStringHolder;
    MessageMultiStringHolder: TJvMultiStringHolder;
    ErrorMessageMultiStringHolder: TJvMultiStringHolder;
    WarningMessageMultiStringHolder: TJvMultiStringHolder;
    ConstantMultiStringHolder: TJvMultiStringHolder;
    FileTypesMultiStringHolder: TJvMultiStringHolder;
  private
    { Private declarations }
  public
    { Public declarations }
    function GetConstant(Name: string): string;
    function GetPConstant(Name: string): PWideChar;
    function GetMessage(Name: string): string;
    function GetYesOrNo(Name: string): string;
    function GetFileTypes(Name: string): string;
  end;

procedure ReadLanguageFile(Language: string);

var
  LanguageDataModule: TLanguageDataModule;

implementation

{$R *.dfm}

uses
  Windows, Consts, Vcl.ActnList, Vcl.Menus, BigINI;

procedure HookResourceString(aResStringRec: PResStringRec; aNewStr: PChar);
var
  OldProtect: DWORD;
begin
  VirtualProtect(aResStringRec, SizeOf(aResStringRec^), PAGE_EXECUTE_READWRITE, @OldProtect);
  aResStringRec^.Identifier := Integer(aNewStr);
  VirtualProtect(aResStringRec, SizeOf(aResStringRec^), OldProtect, @OldProtect);
end;

procedure ReadLanguageFile(Language: string);
var
  LanguagePath: string;
  BigIniFile: TBigIniFile;

  procedure SetStringHolder(MultiStringHolder: TJvMultiStringHolder; Section: string);
  var
    i: Integer;
    StringName, s: string;
  begin
    for i := 0 to MultiStringHolder.MultipleStrings.Count - 1 do
    begin
      StringName := MultiStringHolder.MultipleStrings.Items[i].Name;
      s := BigIniFile.ReadString(Section, StringName, '');
      if s <> '' then
        MultiStringHolder.MultipleStrings.Items[i].Strings.Text := s;
    end;
  end;
begin
  if Language = '' then
    Exit;

  LanguagePath := IncludeTrailingPathDelimiter(Format('%s%s', [ExtractFilePath(ParamStr(0)), 'Languages']));
  if not DirectoryExists(LanguagePath) then
    Exit;

  BigIniFile := TBigIniFile.Create(Format('%s%s.%s', [LanguagePath, Language, 'lng']));
  try
    SetStringHolder(LanguageDataModule.YesOrNoMultiStringHolder, 'AskYesOrNo');
    SetStringHolder(LanguageDataModule.MessageMultiStringHolder, 'Message');
    SetStringHolder(LanguageDataModule.ErrorMessageMultiStringHolder, 'ErrorMessage');
    SetStringHolder(LanguageDataModule.WarningMessageMultiStringHolder, 'WarningMessage');
    SetStringHolder(LanguageDataModule.ConstantMultiStringHolder, 'Constant');
    SetStringHolder(LanguageDataModule.FileTypesMultiStringHolder, 'FileTypes');
  finally
    BigIniFile.Free;
  end;

  HookResourceString(@SMsgDlgWarning, LanguageDataModule.GetPConstant('SMsgDlgWarning'));
  HookResourceString(@SMsgDlgError, LanguageDataModule.GetPConstant('SMsgDlgError'));
  HookResourceString(@SMsgDlgInformation, LanguageDataModule.GetPConstant('SMsgDlgInformation'));
  HookResourceString(@SMsgDlgConfirm, LanguageDataModule.GetPConstant('SMsgDlgConfirm'));
  HookResourceString(@SMsgDlgYes, LanguageDataModule.GetPConstant('SMsgDlgYes'));
  HookResourceString(@SMsgDlgNo, LanguageDataModule.GetPConstant('SMsgDlgNo'));
  HookResourceString(@SMsgDlgOK, LanguageDataModule.GetPConstant('SMsgDlgOK'));
  HookResourceString(@SMsgDlgCancel, LanguageDataModule.GetPConstant('SMsgDlgCancel'));
  HookResourceString(@SMsgDlgHelp, LanguageDataModule.GetPConstant('SMsgDlgHelp'));
  HookResourceString(@SMsgDlgHelpNone, LanguageDataModule.GetPConstant('SMsgDlgHelpNone'));
  HookResourceString(@SMsgDlgHelpHelp, LanguageDataModule.GetPConstant('SMsgDlgHelpHelp'));
  HookResourceString(@SMsgDlgAbort, LanguageDataModule.GetPConstant('SMsgDlgAbort'));
  HookResourceString(@SMsgDlgRetry, LanguageDataModule.GetPConstant('SMsgDlgRetry'));
  HookResourceString(@SMsgDlgIgnore, LanguageDataModule.GetPConstant('SMsgDlgIgnore'));
  HookResourceString(@SMsgDlgAll, LanguageDataModule.GetPConstant('SMsgDlgAll'));
  HookResourceString(@SMsgDlgNoToAll, LanguageDataModule.GetPConstant('SMsgDlgNoToAll'));
  HookResourceString(@SMsgDlgYesToAll, LanguageDataModule.GetPConstant('SMsgDlgYesToAll'));
  HookResourceString(@SMsgDlgClose, LanguageDataModule.GetPConstant('SMsgDlgClose'));
end;

function TLanguageDataModule.GetYesOrNo(Name: string): string;
begin
  Result := Trim(YesOrNoMultiStringHolder.StringsByName[Name].Text);
end;

function TLanguageDataModule.GetMessage(Name: string): string;
begin
  Result := Trim(MessageMultiStringHolder.StringsByName[Name].Text);
end;

function TLanguageDataModule.GetFileTypes(Name: string): string;
begin
  Result := Trim(FileTypesMultiStringHolder.StringsByName[Name].Text);
end;

function TLanguageDataModule.GetConstant(Name: string): string;
begin
  Result := Trim(ConstantMultiStringHolder.StringsByName[Name].Text);
end;

function TLanguageDataModule.GetPConstant(Name: string): PWideChar;
begin
  GetMem(Result, sizeof(WideChar) * Succ(Length(GetConstant(Name))));
  StringToWideChar(GetConstant(Name), Result, Length(GetConstant(Name)) + 1);
end;

initialization

  LanguageDataModule := TLanguageDataModule.Create(Nil);

end.
