unit unit_Downloader;

interface

uses
  Windows,
  Classes,
  SysUtils,
  Dialogs,
  IdHTTP,
  IdComponent,
  IdStack,
  IdStackConsts,
  IdWinsock2,
  IdMultipartFormData,
  DateUtils;

type
  TQueryKind = (qkGet, qkPost);
  EInvalidLogin = class (Exception);

  TCommand = record
    Code: Integer;
    Params: array [1..5] of string;
  end;

  TSetCommentEvent = procedure(const Current, Total: string) of object;
  TProgressEvent = procedure(Current, Total: Integer) of object;

  TDownloader = class
  private
    FidHTTP : TidHttp;
    FParams: TIdMultiPartFormDataStream;
    FResponce: TMemoryStream;

    FSetProgress: TProgressEvent;
    FSetComment: TSetCommentEvent;

    FNewURL: string;
    FNoProgress: boolean;
    Canceled: boolean;
    FDownloadSize: integer;

    FStartDate : TDateTime;
    FIgnoreErrors: boolean;

    FFile: string;

    //function CalcURI(Template: string):string;
    function Main: Boolean;
    function Query(Kind: TQueryKind; const URL: string): Boolean;
    procedure AddParam(const Name: string; const Value: string);
    function CheckResponce: Boolean;
    function CheckRedirect: Boolean;
    function Pause(Time: integer): Boolean;

    procedure HTTPWorkBegin(ASender: TObject; AWorkMode: TWorkMode; AWorkCountMax: Int64);
    procedure HTTPWorkEnd(ASender: TObject; AWorkMode: TWorkMode);
    procedure HTTPWork(ASender: TObject; AWorkMode: TWorkMode; AWorkCount: Int64);
    procedure HTTPRedirect(Sender: TObject; var dest: string; var NumRedirect: Integer; var Handled: Boolean; var VMethod: string);

    procedure Set_OnSetComment(const Value: TSetCommentEvent);
    procedure Set_OnProgress(const Value: TProgressEvent);

    procedure ProcessError(const LongMsg, ShortMsg, AFileName: string);

    procedure ParseCommand(S: string; out Command: TCommand);

  public
    constructor Create;
    destructor Destroy; override;

    function Download(BookID: Integer):boolean;
    procedure Stop;

    property IgnoreErrors: Boolean read FIgnoreErrors write FIgnoreErrors;
    property OnSetComment: TSetCommentEvent write Set_OnSetComment;
    property OnProgress: TProgressEvent write Set_OnProgress;
  end;

implementation

uses
  Forms,
  unit_Globals,
  unit_Settings,
  dm_collection,
  dm_user,
  unit_Consts,
  unit_MHL_strings;

const
   CommandList: array [0..5] of string = ('ADD','GET','POST','REDIR', 'CHECK', 'PAUSE');
   Params :     array [0..2] of string = ('%USER%', '%PASS%', '%RESURL%');

{ TDownloader }

procedure TDownloader.AddParam(const Name: string; const Value: string);
begin
  FParams.AddFormField(Name, Value);
end;

{
function TDownloader.CalcURI(Template: string):string;
var
  S: string;
begin
  dmCollection.FieldByName(0, LIB_ID_FIELD, S);
  StrReplace('%LIBID%', S, Template);
  Result := Template;
end;
}

function TDownloader.CheckRedirect: boolean;
begin
  Result := (FNewURL <> '');
  if not Result then raise EInvalidLogin.Create('������������ �����/������');
end;

function TDownloader.CheckResponce: boolean;
var
  Path: string;
  Str: TStringList;
begin
  Path := ExtractFileDir(FFile);
  CreateFolders('', Path);
  FResponce.Position := 0;
  Str := TstringList.Create;
  try
    Str.LoadFromStream(FResponce);
    if Str.Count > 0 then
    begin
      if (Pos('<!DOCTYPE', Str[0]) <> 0)
         or (Pos('overload', Str[0]) <> 0)
         or (Pos('not found', Str[0]) <> 0) then
      begin
        ProcessError(
              '�������� ����� ������������� ��������!' + #13 + ' ����� ������� ����� ���������� � ����� "server_error.html"',
              '������������� ��������',
              FFile
              );
        Str.SaveToFile(Settings.SystemFileName[sfServerErrorLog]);
      end
      else
      begin
        FResponce.SaveToFile(FFile);
        Result := TestArchive(FFile);
        if not Result then
          DeleteFile(PChar(FFile));
      end;
    end;
  finally
    Str.Free;
  end;
end;

constructor TDownloader.Create;
begin
  inherited Create;

  FidHTTP := TIdHTTP.Create;
  FidHTTP.OnWork := HTTPWork;
  FidHTTP.OnWorkBegin := HTTPWorkBegin;
  FidHTTP.OnWorkEnd := HTTPWorkEnd;
  FidHTTP.OnRedirect := HTTPRedirect;
  FidHTTP.HandleRedirects := True;

  SetProxySettings(FidHTTP);
  FIgnoreErrors := False;
end;

function TDownloader.Download(BookID: Integer): Boolean;
var
  Ext: string;
  FN: string;
  Folder: string;
  No: integer;
begin
  Result := False;
  dmCollection.GetBookFileName(BookID, FN, Folder, Ext, No);
  if Ext = FB2_EXTENSION then
    dmCollection.GetBookFolder(BookID, FFile)
  else
  begin
    Folder := StringReplace(Folder, FB2ZIP_EXTENSION, Ext, []);
    FFile := DMUser.ActiveCollection.RootPath + Folder;
  end;

  if FileExists(FFile) then
  begin
    dmCollection.SetLocalStatus(BookID, True);
    Result := True;
  end
  else if Main then
  begin
    dmCollection.SetLocalStatus(BookID, True);
    Result := True;
  end;
end;

destructor TDownloader.Destroy;
begin
  FidHTTP.Free;
  inherited;
end;

procedure TDownloader.HTTPRedirect(Sender: TObject; var dest: string;
  var NumRedirect: Integer; var Handled: Boolean; var VMethod: string);
begin
  if pos('fb2.zip', dest) <> 0 then
    FNewURL := dest
  else
    FNewURL := '';
end;

procedure TDownloader.HTTPWork(ASender: TObject; AWorkMode: TWorkMode;
  AWorkCount: Int64);
var
  ElapsedTime: Cardinal;
  Speed: string;
begin
  if FNoProgress then Exit;

  if Canceled then
  begin
    FidHTTP.Disconnect;
    Exit;
  end;

  if FDownloadSize <> 0 then
    FSetProgress(AWorkCount * 100 div FDownloadSize, -1);

  ElapsedTime := SecondsBetween(Now, FStartDate);
  if ElapsedTime > 0 then
  begin
    Speed := FormatFloat('0.00', AWorkCount / 1024 / ElapsedTime);
    FSetComment(Format('��������: %s Kb/s', [Speed]), '');
  end;
end;

procedure TDownloader.HTTPWorkBegin(ASender: TObject; AWorkMode: TWorkMode;
  AWorkCountMax: Int64);
begin
  if FNoProgress then Exit;
  FDownloadSize := AWorkCountMax;
  FStartDate := Now;
  FSetProgress(1, -1);
end;

procedure TDownloader.HTTPWorkEnd(ASender: TObject; AWorkMode: TWorkMode);
begin
  if FNoProgress then Exit;
  FSetProgress(100, -1);
  FSetComment(rstrReadyMessage, '');
end;

function TDownloader.Main: boolean;
var
  CL: TStringList;
  Commands : array of TCommand;
  I: Integer;
begin
  CL := TStringList.Create;
  try
    CL.Text := DMUser.ActiveCollection.Script;
    SetLength(Commands, CL.Count);

    FParams := TIdMultiPartFormDataStream.Create;
    try
      FResponce := TMemoryStream.Create;
      try
        for I := 0 to CL.Count - 1 do
        begin
          if Canceled then
            Break;

          ParseCommand(CL[i], Commands[i]);
          with Commands[i] do
            case Code of
              0: begin
                   AddParam(Params[1], Params[2]);
                   Result := True;
                 end;
              1: Result := Query(qkGet, Params[1]);
              2: Result := Query(qkPost, Params[1]);
              3: Result := CheckRedirect;
              4: Result := CheckResponce;
              5: Result := Pause(StrToInt(Params[1]));
            end;

          if not Result then
            Break;
        end;
      finally
        FResponce.Free;
      end;
    finally
      FParams.Free;
    end;
  finally
    CL.Free;
  end;
end;

procedure TDownloader.ParseCommand(S: string; out Command: TCommand);
var
  p, i: integer;
  s1: string;

  t: string;
begin
  Command.Code := -1;

  dmCollection.FieldByName(0, LIB_ID_FIELD, t);
  StrReplace('%LIBID%', t, S);

  StrReplace('%USER%', DMUser.ActiveCollection.User, S);
  StrReplace('%PASS%', DMUser.ActiveCollection.Password, S);

  StrReplace('%URL%',  DMUser.ActiveCollection.URL, S);
  StrReplace('%RESURL%', FNewURL, S);

  p := Pos(' ', S);
  if p <> 0 then
  begin
    s1 := Copy(S, 1, p - 1);
    Delete(S, 1, p);
  end
  else
    s1 := S;

  for i := 0 to 5 do
    if CommandList[i] = s1 then
    begin
      Command.Code := i;
      Break;
    end;

  p := Pos(' ', S);
  i := 1;
  while p <> 0 do
  begin
    s1 := Copy(S,1, p - 1);
    Command.Params[i] := s1;
    Inc(i);
    Delete(S, 1, p);
    p := Pos(' ', S);
  end;

  if S <> '' then
    Command.Params[i] := S
end;

function TDownloader.Pause(Time: integer): boolean;
begin
  Sleep(Time);
  Result := True;
end;

procedure TDownloader.ProcessError(const LongMsg, ShortMsg, AFileName: string);
var
  F: Text;
  FileName: string;
begin
  if Settings.ErrorLog then
  begin
    FileName := Settings.SystemFileName[sfDownloadErrorLog];
    AssignFile(F, FileName);
    if FileExists(FileName) then
      Append(F)
    else
      Rewrite(F);
    Writeln(F, Format('%s %s >> %s', [DateTimeToStr(Now), ShortMsg, AFileName]));
    CloseFile(F);
  end;
  if not FIgnoreErrors then
    Application.MessageBox(PChar(LongMsg), '������ �������');
end;

function TDownloader.Query(Kind: TQueryKind; const URL: string):boolean;
begin
  Result := False;
  try
    case Kind of
      qkGet : begin
                FNoProgress := False;
                FidHTTP.Get(URL, FResponce);
              end;

      qkPost: begin
                FNoProgress := True;
                FidHTTP.Post(URL, FParams,FResponce);
              end;
    end;
    Result := True;
  except
    on E: EIdSocketError do
    begin
      case E.LastError of
        WSAHOST_NOT_FOUND: ProcessError('������� �� �������! ������ �� ������.', '������ ' + IntToStr(E.LastError), FFile);
        Id_WSAETIMEDOUT: ProcessError('������� �� �������! ��������� ����� ��������.', '������ ' + IntToStr(E.LastError), FFile);
        else
          ProcessError('������� �� �������! ������ �����������.', '������ ' + IntToStr(E.LastError), FFile);
      end; // case
    end;
    on E: Exception do
      if (FidHTTP.ResponseCode <> 405) and  not ((FidHTTP.ResponseCode = 404) and (FNewURL <> ''))
      then
        ProcessError('������� �� �������! ������ �������� �� ������ "' + E.Message + '".' + #10#13, '��� ������ ' + IntToStr(FidHTTP.ResponseCode), FFile)
      else
        Result := True;
  end; // try ... except
end;

procedure TDownloader.Set_OnProgress(const Value: TProgressEvent);
begin
  FSetProgress := Value;
end;

procedure TDownloader.Set_OnSetComment(const Value: TSetCommentEvent);
begin
  FSetComment := Value;
end;

procedure TDownloader.Stop;
begin
  try
    FidHTTP.Disconnect;
  except
    //
  end;
end;

end.