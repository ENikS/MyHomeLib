(* *****************************************************************************
  *
  * MyHomeLib
  *
  * Copyright (C) 2008-2010 Aleksey Penkov
  *
  * Authors Nick Rymanov     nrymanov@gmail.com
  *         Aleksey Penkov   alex.penkov@gmail.com
  *
  * History
  *
  ****************************************************************************** *)

unit frame_NCWInpxSource;

interface

uses
  Windows,
  Messages,
  SysUtils,
  Variants,
  Classes,
  Graphics,
  Controls,
  Forms,
  Dialogs,
  frame_InteriorPageBase,
  StdCtrls,
  ExtCtrls,
  unit_StaticTip,
  unit_NCWParams,
  Mask,
  ComCtrls,
  MHLSimplePanel,
  unit_AutoCompleteEdit;

type
  TCollectionDesc = record
    Group: integer;
    Title: string;
    Desc: string;
    INPX: string;
  end;

  TframeNCWInpxSource = class(TInteriorPageBase)
    Panel1: TMHLSimplePanel;
    pageHint: TMHLStaticTip;
    rbLocal: TRadioButton;
    edINPXPath: TMHLAutoCompleteEdit;
    rbDownload: TRadioButton;
    lvCollections: TListView;
    MHLSimplePanel1: TMHLSimplePanel;
    btnSelectINPX: TButton;
    procedure OnSetCollectionType(Sender: TObject);
    procedure edINPXPathButtonClick(Sender: TObject);
    procedure lvCollectionsChange(Sender: TObject; Item: TListItem;
      Change: TItemChange);
  private
    FCollections: array of TCollectionDesc;
    FGroups: array of string;

    procedure LoadDescriptions;
  public
    function Activate(LoadData: Boolean): Boolean; override;
    function Deactivate(CheckData: Boolean): Boolean; override;
    procedure FillList;
  end;

var
  frameNCWInpxSource: TframeNCWInpxSource;

implementation

uses
  unit_Settings,
  unit_Helpers,
  ZipForge,
  IniFiles;

resourcestring
  rstrServerDownload = '��������� ���� INPX ����� ������ � �������.';
  rstrLocal = '��������� �� ������ ����� *.inpx. ������� ���� � �����.';
  rstrGroupLibrusec = '���������� Lib.rus.ec';
  rstrGroupFlibusta = '���������� Flibusta';
  rstrGroupTraum = '���������� ������';
  rstrLibrusecFB2 = '������ FB2 (fb2-xxxxxx-xxxxxx.zip)';
  rstrLibrusecUSR = '������ USR (usr-xxxxxx-xxxxxx.zip)';
  rstrLibrusecAll = '��� ������ (fb2-xxxxxx-xxxxxx.zip � usr-xxxxxx-xxxxxx.zip)';
  rstrLibrusecOnline = '����� ����������� �� ������� � �������� lib.rus.ec (���������� �����������)';
  rstrFlibustaOnline = '����� ����������� �� ������� � ������� flibusta.net';
  rstrTraum_2_11_FB2 = '���������� ������ 2.11';
  rstrTraum_2_12_FB2 = '���������� ������ 2.12';
  rstrTraum_2_13_FB2 = '���������� ������ 2.13 (������ FB2)';
  rstrTraum_2_13_All = '���������� ������ 2.13 (������)';

{$R *.dfm}

const
  INPX_SECTION = 'INPX';
  INPX_GROUP_SECTION = 'GROUPS';
  INPX_KEY_PREFIX = 'Inpx';
  INPX_GROUP_KEY_PREFIX = 'Group';

  DefaultGroups: array [0 .. 2] of string = (rstrGroupLibrusec, rstrGroupFlibusta, rstrGroupTraum);

  DefaultCollections: array [0 .. 8] of TCollectionDesc =
  (
    (Group: 0; Title: 'Lib.rus.ec [FB2]';        Desc: rstrLibrusecFB2; INPX: 'librusec.inpx'),
    (Group: 0; Title: 'Lib.rus.ec [USR]';        Desc: rstrLibrusecUSR; INPX: 'librusec_usr.inpx'),
    (Group: 0; Title: 'Lib.rus.ec [ALLBOOKS]';   Desc: rstrLibrusecAll;    INPX: 'librusec_allbooks.inpx'),
    (Group: 0; Title: 'Lib.rus.ec Online [FB2]'; Desc: rstrLibrusecOnline; INPX: 'librusec_online.inpx'),
    (Group: 1; Title: 'Flibusta OnLine [FB2]';   Desc: rstrFlibustaOnline; INPX: 'flibusta_online.inpx'),
    (Group: 2; Title: 'Traum 2.11 [FB2]';        Desc: rstrTraum_2_11_FB2; INPX: 'Traum_2-11.inpx'),
    (Group: 2; Title: 'Traum 2.12 [FB2]';        Desc: rstrTraum_2_12_FB2; INPX: 'Traum_2-12.inpx'),
    (Group: 2; Title: 'Traum 2.13 [FB2]';        Desc: rstrTraum_2_13_FB2; INPX: 'Traum_2-13_fb2.inpx'),
    (Group: 2; Title: 'Traum 2.13 [ALLBOOKS]';   Desc: rstrTraum_2_13_All; INPX: 'Traum_2-13_full.inpx')
  );

function TframeNCWInpxSource.Activate(LoadData: Boolean): Boolean;
begin
  if LoadData then
  begin
    FillList;
    rbLocal.Checked := True;
    OnSetCollectionType(rbLocal);
  end;
  Result := True;
end;

function TframeNCWInpxSource.Deactivate(CheckData: Boolean): Boolean;
begin
  if rbLocal.Checked then
  begin
    FPParams^.INPXFile := edINPXPath.Text;
  end
  else
    FPParams^.Operation := otDownload;

  Result := True;
end;

procedure TframeNCWInpxSource.edINPXPathButtonClick(Sender: TObject);
var
  key: TMHLFileName;
  AFileName: string;
begin
  key := fnOpenINPX;
  if FPParams^.Operation = otExisting then
    key := fnOpenCollection;

  if GetFileName(key, AFileName) then
  begin
    edINPXPath.Text := AFileName;
  end;
end;

procedure TframeNCWInpxSource.FillList;
var
  I: integer;
  G: TListGroup;
  Item: TListItem;
begin
  LoadDescriptions;

  lvCollections.Items.BeginUpdate;
  try
    lvCollections.Groups.Clear;
    lvCollections.Items.Clear;

    for I := 0 to High(FGroups) do
    begin
      G := lvCollections.Groups.Add;
      G.Header := FGroups[I];
    end;

    for I := 0 to High(FCollections) do
    begin
      Item := lvCollections.Items.Add;
      Item.Caption := FCollections[I].Title;
      Item.GroupID := FCollections[I].Group;
    end;
  finally
    lvCollections.Items.EndUpdate;
  end;
end;

procedure TframeNCWInpxSource.LoadDescriptions;
var
  I: integer;
  sl: TStringList;
  slHelper: TStringList;
  INIFile: TMemIniFile;
begin
  INIFile := TMemIniFile.Create(Settings.SystemFileName[sfCollectionsStore]);
  try
    INIFile.Encoding := TEncoding.UTF8;

    sl := TStringList.Create;
    try
      INIFile.ReadSection(INPX_GROUP_SECTION, sl);
      // ������������ ����
      if sl.Count > 0 then
      begin
        SetLength(FGroups, sl.Count);
        for I := 0 to sl.Count - 1 do
          if Pos(INPX_GROUP_KEY_PREFIX, sl[I]) = 1 then
            FGroups[I] := INIFile.ReadString(INPX_GROUP_SECTION, sl[I], '');
      end // if
      else
      begin
        // ������� ������ �� ���������
      end;

      INIFile.ReadSection(INPX_SECTION, sl);
      // ������������ ����
      if sl.Count > 0 then
      begin
        SetLength(FCollections, sl.Count);
        slHelper := TIniStringList.Create;
        try
          for I := 0 to sl.Count - 1 do
          begin
            if Pos(INPX_KEY_PREFIX, sl[I]) = 1 then
            begin
              slHelper.DelimitedText := INIFile.ReadString(INPX_SECTION, sl[I], '');
              if slHelper.Count > 4 then
              begin
                FCollections[I].Group := StrToInt(slHelper[0]);
                FCollections[I].Title := slHelper[1];
                FCollections[I].Desc := slHelper[2];
                FCollections[I].INPX := slHelper[3];
              end;
            end;
          end;
        finally
          slHelper.Free;
        end;
      end // if
      else
      begin
        // ������� inpx �� ���������
        // SetLength(FCollections, 9);
        // FCollections := DefaultCollections;
      end;
    finally
      sl.Free;
    end;
  finally
    INIFile.Free;
  end;
end;

procedure TframeNCWInpxSource.lvCollectionsChange(Sender: TObject; Item: TListItem; Change: TItemChange);
begin
  pageHint.Caption := FCollections[Item.Index].Desc;
  FPParams^.INPXFile := Settings.WorkPath + FCollections[Item.Index].INPX;
  FPParams^.INPXUrl := Settings.InpxURL + FCollections[Item.Index].INPX;
end;

procedure TframeNCWInpxSource.OnSetCollectionType(Sender: TObject);
begin
  if Sender = rbLocal then
    pageHint.Caption := rstrLocal
  else
    pageHint.Caption := rstrServerDownload;

  edINPXPath.Enabled := rbLocal.Checked;
  btnSelectINPX.Enabled := rbLocal.Checked;
  lvCollections.Enabled := rbDownload.Checked;
end;

end.
