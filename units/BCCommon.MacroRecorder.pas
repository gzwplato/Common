unit BCCommon.MacroRecorder;

interface

uses
  Winapi.Windows, Winapi.Messages, System.Classes, Vcl.Controls;

type
  TMacroWinControl = class
  strict private
    FHandle: THandle;
    FWinControl: TWinControl;
  public
    function Self: TMacroWinControl;
    function ScreenX: Integer;
    function ScreenY: Integer;
    property Handle: THandle read FHandle write FHandle;
    property WinControl: TWinControl read FWinControl write FWinControl;
  end;

  TMacroWinControlList = class(TObject)
  strict private
    FWinControlList: TStringList;
  public
    constructor CreateList;
    destructor Destroy; override;
    function Add(Name: string): TMacroWinControl; overload;
    function WinControlByHandle(HandleParam: THandle): TMacroWinControl;
    procedure Add(Name: string; WinControl: TWinControl); overload;
    procedure BuildList(WinControl: TWinControl);
  end;

  TWindowsMessage = packed record
    Msg: Cardinal;
    case Integer of
      0 : (
        WParam: Longint;
        LParam: Longint;
        Time: DWORD;
        WindowHandle: HWND);
      1 : (
        case Integer of
          0: (
            WParamLo: Word;
            WParamHi: Word;
            LParamLo: Word;
            LParamHi: Word);
          1: (
            WParamBytes, LParamBytes: packed array[0..3] of Byte));
  end;

  PWindowsMessage = ^TWindowsMessage;

  TMacroMessageList = class;

  TMacroMessage = class
  strict private
    FParentMessageList: TMacroMessageList;
  public
    { WindowsMessage can't be a property because it makes the TWindowsMessage record read-only even though
      there is a write attribute. }
    WindowsMessage: TWindowsMessage;
    function IsMouseMessage: Boolean;
    property ParentMessageList: TMacroMessageList read FParentMessageList write FParentMessageList;
  end;

  TMacroMessageList = class
  strict private
    FMessageList: TStringList;
    FWinControlList: TMacroWinControlList;
    FStartTickCount: Integer;
  public
    constructor Create(WinControl: TWinControl); overload;
    destructor Destroy; override;

    procedure Clear;
    procedure Add(Name: string; MacroMessage: TMacroMessage); overload;
    function Add(Name: string): TMacroMessage; overload;
    function Add(WindowsMessage: PWindowsMessage): TMacroMessage; overload;
    function GetMessage(Index: Integer): TMacroMessage;
    function Count: Integer;
    procedure SaveToFile(const FileName: string);
    procedure LoadFromFile(const FileName: string);
    procedure UpdateRelative;
    property StartTickCount: Integer read FStartTickCount write FStartTickCount;
    property WinControlList: TMacroWinControlList read FWinControlList;
  end;

  TMacroRecorder = class
  strict private
    FMessageIndex: Integer;
    FMacroMessageList: TMacroMessageList;
    FNextMacroMessage: TMacroMessage;
    FIsRecording: Boolean;
    FIsPaused: Boolean;
    FIsPlaying: Boolean;
    FHookHandle: hHook;
  public
    constructor Create(WinControl: TWinControl); overload;
    destructor Destroy; override;

    procedure Start;
    procedure Stop;
    procedure Pause;
    procedure Play;
    procedure StopPlayback;
    procedure GetMessage(Index: Integer);

    property HookHandle: hHook read FHookHandle;
    property MacroMessageList: TMacroMessageList read FMacroMessageList;
    property MessageIndex: Integer read FMessageIndex write FMessageIndex;
    property NextMacroMessage: TMacroMessage read FNextMacroMessage;
  end;

  function MacroRecorder(WinControl: TWinControl): TMacroRecorder;

implementation

uses
  System.Types;

const
  MAXCONTROLLENGTH = 50;

type
  TMacroFile = packed record
    WindowsMessage: TWindowsMessage;
  end;

var
  FMacroRecorder: TMacroRecorder = nil;

function MacroRecorder(WinControl: TWinControl): TMacroRecorder;
begin
  if not Assigned(FMacroRecorder) then
  begin
    Assert(not Assigned(WinControl), 'MacroRecorder: WinControl not assigned.');
    FMacroRecorder := TMacroRecorder.Create(WinControl);
  end;
  Result:= FMacroRecorder;
end;

{ TMacroWinControl }

function TMacroWinControl.Self: TMacroWinControl;
begin
  Result := Self;
end;

function TMacroWinControl.ScreenX: Integer;
begin
  with FWinControl do
    Result:= ClientToScreen(Point(Left, Top)).X;
end;

function TMacroWinControl.ScreenY: Integer;
begin
  with FWinControl do
    Result:= ClientToScreen(Point(Left, Top)).Y;
end;

{ TWinControlList }

constructor TMacroWinControlList.CreateList;
begin
  inherited Create;
  FWinControlList := TStringList.Create;
end;

destructor TMacroWinControlList.Destroy;
begin
  FWinControlList.Free;
  inherited;
end;

function TMacroWinControlList.Add(Name: string): TMacroWinControl;
begin
  Result := TMacroWinControl.Create;
  FWinControlList.AddObject(Name, Result);
end;

procedure TMacroWinControlList.Add(Name: string; WinControl: TWinControl);
var
  MacroWinControl: TMacroWinControl;
begin
  MacroWinControl := Add(Name);
  MacroWinControl.Handle := WinControl.Handle;
  MacroWinControl.WinControl := WinControl;
end;

procedure TMacroWinControlList.BuildList(WinControl: TWinControl);

  procedure BuildListRecursive(Level: integer; WinControl: TWinControl; TotalX, TotalY: Integer);
  var
    i: integer;
    X, Y: Integer;
  begin
    with WinControl do
    begin
      X := TotalX + Left;
      Y := TotalY + Top;

      Add(Name, WinControl);

      for i := 0 to ControlCount - 1 do
        if Controls[i] is TWinControl then
          BuildListRecursive(Level + 1, Controls[i] as TWinControl, X, Y);
    end;
  end;

begin
  BuildListRecursive(0, WinControl, 0, 0);
end;

function TMacroWinControlList.WinControlByHandle(HandleParam: THandle): TMacroWinControl;
var
  i: Integer;
begin
  Result := nil;
  for i := 0 to FWinControlList.Count - 1 do
  with FWinControlList.Objects[i] as TMacroWinControl do
  if Handle = HandleParam then
  begin
    Result := Self;
    Break;
  end;
end;

{ TMacroMessage }

function TMacroMessage.IsMouseMessage: Boolean;
begin
  with WindowsMessage do
    Result:= (Msg = wm_lButtonDown) or (Msg = wm_lButtonUp) or (Msg = wm_rButtonUp) or
      (Msg = wm_rButtonUp) or (Msg = wm_mButtonUp) or (Msg = wm_mButtonUp)
end;

{ TMacroMessageList }

constructor TMacroMessageList.Create(WinControl: TWinControl);
begin
  inherited Create;
  FWinControlList := TMacroWinControlList.CreateList;
  FWinControlList.BuildList(WinControl);
  FMessageList := TStringList.Create;
end;

destructor TMacroMessageList.Destroy;
var
  i: Integer;
begin
  FWinControlList.Free;
  for i := 0 to FMessageList.Count - 1 do
    FMessageList.Objects[i].Free;
  FMessageList.Free;
  inherited;
end;

procedure TMacroMessageList.Clear;
begin
  FMessageList.Clear;
end;

procedure TMacroMessageList.Add(Name: string; MacroMessage: TMacroMessage);
begin
  MacroMessage.ParentMessageList := Self;
  FMessageList.AddObject(Name, MacroMessage);
end;

function TMacroMessageList.Add(Name: string): TMacroMessage;
begin
  Result := TMacroMessage.Create;
  Add(Name, Result);
end;

function TMacroMessageList.Add(WindowsMessage: PWindowsMessage): TMacroMessage;
begin
  Result := Add('');
  Result.WindowsMessage := WindowsMessage^;
end;

function TMacroMessageList.GetMessage(Index: Integer): TMacroMessage;
begin
  Result := FMessageList.Objects[Index] as TMacroMessage;
end;

function TMacroMessageList.Count: Integer;
begin
  Result := FMessageList.Count;
end;

procedure TMacroMessageList.UpdateRelative;
var
  i: Integer;
begin
  for i := 0 to FMessageList.Count - 1 do
  with FMessageList.Objects[i] as TMacroMessage, WindowsMessage do
  begin
    Dec(WindowsMessage.Time, FStartTickCount);

    if IsMouseMessage then
    with FWinControlList.WinControlByHandle(WindowsMessage.WindowHandle) do
    begin
      Dec(WParam, ScreenX);
      Dec(LParam, ScreenY);
    end;
  end;
end;

procedure TMacroMessageList.SaveToFile(const FileName: string);
var
  i: Integer;
  F: File of TMacroFile;
  MacroFile: TMacroFile;
begin
  AssignFile(F, FileName);
  Reset(F);
  for i := 0 to FMessageList.Count - 1 do
  with GetMessage(i) do
  begin
    MacroFile.WindowsMessage := WindowsMessage;
    write(F, MacroFile);
  end;
  Close(F);
end;

procedure TMacroMessageList.LoadFromFile(const FileName: string);
var
  F: File of TMacroFile;
  MacroFile: TMacroFile;
begin
  Clear;
  AssignFile(F, FileName);
  Reset(F);
  while not Eof(F) do
  begin
    Read(F, MacroFile);
    Add(@MacroFile.WindowsMessage)
  end;
  Close(F);
end;

{ TMacroRecorder }

constructor TMacroRecorder.Create(WinControl: TWinControl);
begin
  inherited Create;

  FIsRecording := False;
  FIsPaused := False;

  FMacroMessageList := TMacroMessageList.Create(WinControl);

  FNextMacroMessage := TMacroMessage.Create;
  FNextMacroMessage.ParentMessageList := FMacroMessageList;
end;

destructor TMacroRecorder.Destroy;
begin
  FMacroMessageList.Free;
  inherited;
end;

function JournalRecordHookProc(code: Integer; wparam: WPARAM; lparam: LPARAM): LRESULT; stdcall;
var
  WindowsMessage: PWindowsMessage;
begin
  Result := 0;

  with MacroRecorder(nil) do
  begin
    if GetKeyState(vk_Pause) < 0 then
    begin
      Stop;
      Result := CallNextHookEx(HookHandle, code, wparam, lparam);
      Exit;
    end;

    case code of
      HC_ACTION:
        begin
          WindowsMessage := PWindowsMessage(lparam);
          with WindowsMessage^ do
            if (Msg <> wm_MouseMove) and (Msg <> $FF) then
              MacroMessageList.Add(WindowsMessage);
        end;
    else
      Result := CallNextHookEx(HookHandle, code, wparam, lparam);
    end;
  end;
end;

function JournalPlaybackHookProc(code: Integer; wparam: WPARAM; lparam: LPARAM): LRESULT; stdcall;
begin
  with MacroRecorder(nil) do
  case code of
    HC_SKIP:
      begin
        MessageIndex := MessageIndex + 1; { MessageIndex is a property, can't use Inc(MessageIndex); }

        if MessageIndex >= MacroMessageList.Count then
          StopPlayback
        else
          GetMessage(MessageIndex);
        Result:= 0;
      end;
    HC_GETNEXT:
      begin
        PWindowsMessage(lparam)^ := NextMacroMessage.WindowsMessage;
        Result:= 0;
      end
  else
    Result:= CallNextHookEx(HookHandle, code, wparam, lparam);
  end;
end;

procedure TMacroRecorder.Start;
begin
  if not FIsRecording then
  begin
    if not FIsPaused then
      FMacroMessageList.Clear;
    FHookHandle := SetWindowsHookEx(WH_JOURNALRECORD, JournalRecordHookProc, hInstance, 0);
  end;
  FIsRecording := True;
  FIsPaused := False;
end;

procedure TMacroRecorder.Stop;
begin
  if FIsRecording then
    UnhookWindowsHookEx(FHookHandle);

  if not FIsPaused then
    FMacroMessageList.UpdateRelative;

  FIsRecording := False;
end;

procedure TMacroRecorder.Pause;
begin
  FIsPaused := True;
  Stop;
end;

procedure TMacroRecorder.Play;
begin
  if FIsPlaying then
    Exit;

  FMessageIndex := 0;
  FMacroMessageList.StartTickCount := GetTickCount; { TODO: Needed? }

  FHookHandle := SetWindowsHookEx(WH_JOURNALPLAYBACK, JournalPlaybackHookProc, hInstance, 0);
  if FHookHandle = 0 then
    Exit;

  FIsPlaying:= True;
end;

procedure TMacroRecorder.StopPlayback;
begin
  if FIsPlaying then
    UnhookWindowsHookEx(FHookHandle);
  FIsPlaying := False;
end;

procedure TMacroRecorder.GetMessage(Index: Integer);
begin
  with MacroMessageList.GetMessage(Index) do
    NextMacroMessage.WindowsMessage := WindowsMessage;

  with NextMacroMessage, WindowsMessage do
  begin
    if IsMouseMessage then
    with MacroMessageList.WinControlList.WinControlByHandle(WindowHandle) do
    begin
      Inc(WParam, ScreenX);
      Inc(LParam, ScreenY);
    end;
    Inc(Time, MacroMessageList.StartTickCount);
  end;
end;

end.