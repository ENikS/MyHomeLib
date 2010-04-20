(* *****************************************************************************
  *
  * MyHomeLib
  *
  * Copyright (C) 2008-2010 Aleksey Penkov
  *
  * Created             14.04.2010
  * Description         ������ ���������� � �����
  * Author(s)           Nick Rymanov (nrymanov@gmail.com)
  *
  * History
  *
  ****************************************************************************** *)

unit BookInfoPanel;

interface

uses
  Controls,
  Graphics,
  Classes,
  StdCtrls,
  ExtCtrls,
  MHLLinkLabel;

type
  TInfoPanel = class(TCustomPanel)
  private
    FCover: TImage;
    FInfoPanel: TPanel;
    FTitle: TLabel;
    FAuthors: TMHLLinkLabel;
    FSerieLabel: TLabel;
    FSerie: TMHLLinkLabel;
    FGenreLabel: TLabel;
    FGenres: TMHLLinkLabel;
    FAnnotation: TMemo;
    FOnAuthorLinkClicked: TSysLinkEvent;
    FOnGenreLinkClicked: TSysLinkEvent;
    FOnSerieLinkClicked: TSysLinkEvent;

    function GetShowCover: boolean;
    procedure SetShowCover(const Value: boolean);

    function GetShowAnnotation: Boolean;
    procedure SetShowAnnotation(const Value: Boolean);

    procedure UpdateLinkTexts;

    procedure OnLinkClicked(Sender: TObject; const Link: string; LinkType: TSysLinkType);

  public
    constructor Create(AOwner: TComponent); override;

    procedure SetBookInfo(
      const BookTitle: string;
      const Autors: string;
      const Serie: string;
      const Genres: string;
      const Annotation: string
    );

    procedure Clear;

  published
    property Align;
    property Anchors;
    property BiDiMode;
    property Color;
    //property Constraints;
    property Ctl3D;
    property UseDockManager default True;
    property DockSite;
    property DoubleBuffered;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property FullRepaint;
    property Font;
    //property Locked;
    property Padding;
    property ParentBiDiMode;
    property ParentBackground;
    property ParentColor;
    property ParentCtl3D;
    property ParentDoubleBuffered;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property Touch;
    property VerticalAlignment;
    property Visible;

    property OnAlignInsertBefore;
    property OnAlignPosition;
    property OnCanResize;
    property OnClick;
    property OnConstrainedResize;
    property OnContextPopup;
    property OnDockDrop;
    property OnDockOver;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDock;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnGesture;
    property OnGetSiteInfo;
    property OnMouseActivate;
    property OnMouseDown;
    property OnMouseEnter;
    property OnMouseLeave;
    property OnMouseMove;
    property OnMouseUp;
    property OnResize;
    property OnStartDock;
    property OnStartDrag;
    property OnUnDock;

    property ShowCover: Boolean read GetShowCover write SetShowCover default True;
    property ShowAnnotation: Boolean read GetShowAnnotation write SetShowAnnotation default True;

    property OnAuthorLinkClicked: TSysLinkEvent read FOnAuthorLinkClicked write FOnAuthorLinkClicked;
    property OnSerieLinkClicked: TSysLinkEvent read FOnSerieLinkClicked write FOnAuthorLinkClicked;
    property OnGenreLinkClicked: TSysLinkEvent read FOnGenreLinkClicked write FOnAuthorLinkClicked;
  end;

implementation

resourcestring
  rstrSerieLabel = '�����:';
  rstrGenreLabel = '����(�):';
  rstrNoAnnotationHint = '��������� �����������';

constructor TInfoPanel.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  SetBounds(0, 0, 500, 200);

  BevelOuter := bvNone;
  ShowCaption := False;

  FCover := TImage.Create(Self);
  FCover.Parent := Self;
  FCover.SetBounds(0, 0, 200, 200);
  FCover.Align := alLeft;
  FCover.AlignWithMargins := True;

  FInfoPanel := TPanel.Create(Self);
  FInfoPanel.Parent := Self;
  FInfoPanel.SetBounds(200, 0, 300, 200);
  FInfoPanel.Align := alClient;
  FInfoPanel.BevelOuter := bvNone;
  FInfoPanel.ShowCaption := False;

  FTitle := TLabel.Create(FInfoPanel);
  FTitle.Parent := FInfoPanel;
  FTitle.AutoSize := False;
  FTitle.Font.Style := [fsBold];

  FAuthors := TMHLLinkLabel.Create(FInfoPanel);
  FAuthors.Parent := FInfoPanel;
  FAuthors.UseVisualStyle := True;
  FAuthors.OnLinkClick := OnLinkClicked;

  FSerieLabel := TLabel.Create(FInfoPanel);
  FSerieLabel.Parent := FInfoPanel;
  FSerieLabel.Caption := rstrSerieLabel;
  FSerieLabel.AutoSize := False;
  FSerieLabel.Font.Style := [fsBold];

  FSerie := TMHLLinkLabel.Create(FInfoPanel);
  FSerie.Parent := FInfoPanel;
  FSerie.UseVisualStyle := True;
  FSerie.OnLinkClick := OnLinkClicked;

  FGenreLabel := TLabel.Create(FInfoPanel);
  FGenreLabel.Parent := FInfoPanel;
  FGenreLabel.Caption := rstrGenreLabel;
  FGenreLabel.AutoSize := False;
  FGenreLabel.Font.Style := [fsBold];

  FGenres := TMHLLinkLabel.Create(FInfoPanel);
  FGenres.Parent := FInfoPanel;
  FGenres.UseVisualStyle := True;
  FGenres.OnLinkClick := OnLinkClicked;

  FAnnotation := TMemo.Create(FInfoPanel);
  FAnnotation.Parent := FInfoPanel;
  FAnnotation.Anchors := [akLeft, akTop, akRight, akBottom];
  FAnnotation.ReadOnly := True;
  FAnnotation.TextHint := rstrNoAnnotationHint;

  //       300 200
  //0,  0, 300,  20
  //0, 20, 300,  20
  //0, 40,  60,  20 | 60, 40, 140, 20
  //0, 60,  60,  20 | 60, 60, 140, 20
  //0, 80, 300, 120

  if csDesigning in ComponentState then
  begin
    FTitle.Caption := '�������� �����';
    FAuthors.Caption := '<a>����� �����</a> <a>����� �����</a>';
    FSerie.Caption := '<a>�������� �����</a>';
    FGenres.Caption := '<a>�������� �����</a> <a>�������� �����</a> <a>�������� �����</a>';
  end;

  FTitle.SetBounds(0, 0, 300, 20);
  FAuthors.SetBounds(0, 20, 300, 20);
  FSerieLabel.SetBounds(0, 40, 60, 20);  FSerie.SetBounds(60, 40, 140, 20);
  FGenreLabel.SetBounds(0, 60, 60, 20);  FGenres.SetBounds(60, 60, 140, 20);
  FAnnotation.SetBounds(0, 80, 300, 120);

  //
  //
  //
  Constraints.MinHeight := 150;
end;

procedure TInfoPanel.OnLinkClicked(Sender: TObject; const Link: string; LinkType: TSysLinkType);
begin
  if Sender = FAuthors then
  begin
    if Assigned(FOnAuthorLinkClicked) then
      FOnAuthorLinkClicked(Self, Link, LinkType);
  end
  else if Sender = FSerie then
  begin
    if Assigned(FOnSerieLinkClicked) then
      FOnSerieLinkClicked(Self, Link, LinkType);
  end
  else if Sender = FGenres then
  begin
    if Assigned(FOnGenreLinkClicked) then
      FOnGenreLinkClicked(Self, Link, LinkType);
  end
  else
    Assert(False);
end;

procedure TInfoPanel.SetBookInfo(
  const BookTitle: string;
  const Autors: string;
  const Serie: string;
  const Genres: string;
  const Annotation: string
);
begin
  FTitle.Caption := BookTitle;
  FAuthors.Caption := Autors;
  FSerie.Caption := Serie;
  FGenres.Caption := Genres;
  FAnnotation.Lines.BeginUpdate;
  try
    FAnnotation.Lines.Text := Annotation;
    FAnnotation.SelStart := 0;
    FAnnotation.SelLength := 0;
  finally
    FAnnotation.Lines.EndUpdate;
  end;
end;

procedure TInfoPanel.Clear;
begin
  FTitle.Caption := '';
  FAuthors.Caption := '';
  FSerie.Caption := '';
  FGenres.Caption := '';
  FAnnotation.Lines.Clear;
end;

function TInfoPanel.GetShowAnnotation: Boolean;
begin
  Result := FAnnotation.Visible;
end;

procedure TInfoPanel.SetShowAnnotation(const Value: Boolean);
begin
  if GetShowAnnotation <> Value then
  begin
    FAnnotation.Visible := Value;
    if Value then
      Constraints.MinHeight := 150
    else
      Constraints.MinHeight := 80;
  end;
end;

function TInfoPanel.GetShowCover: boolean;
begin
  Result := FCover.Visible;
end;

procedure TInfoPanel.SetShowCover(const Value: boolean);
begin
  if GetShowCover <> Value then
  begin
    FCover.Visible := Value;
    UpdateLinkTexts;
  end;
end;

procedure TInfoPanel.UpdateLinkTexts;
begin
  //
  // TODO : ������ ����� ������ ���������� ���������� ����� � "Link Link � ��.", � � ������ ����������� � �������� " � ��."
  //
end;

end.
